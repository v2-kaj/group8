const express = require("express");
const mysql = require('mysql2');
const nodemailer = require('nodemailer');
const { keys } = require('./secrets/keys')
const fs = require('fs');
const PDFDocument = require('pdfkit');
const bcrypt = require('bcrypt');

// Set up the session middleware
const session = require('express-session');
const { constants } = require("buffer");
const { connect } = require("http2");

async function hashPassword(password) {
    return await bcrypt.hash(password, 10);
}


const connection = mysql.createPool({
    host: 'localhost',
    port: 4306,
    user: 'root',
    password: '',
    database: 'gms',
    waitForConnections: true,
    connectionLimit: 10, // Adjust the connection limit as needed
    queueLimit: 0,
});

const port = 8000


const app = express();
app.set("view engine", "ejs");
app.use(express.static("public"));
app.use(express.urlencoded({ extended: true }))
app.use(session({ secret: 'group8-group8', resave: false, saveUninitialized: true }));
function generateTemporaryPassword(length) {
    const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+";
    let password = "";

    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * charset.length);
        password += charset.charAt(randomIndex);
    }

    return password;
}

const generateRegNumber = async (program_id) => {
    try {
        const program = await queryProgram(program_id);
        const currentYear = new Date().getFullYear();
        const yearLastTwoDigits = currentYear % 100;
        const program_abbreviation = program[0].abbreviation;

        const result = await queryLastRegNumber(program_id);


        if (result.length > 0) {
            const lastRegNumber = result[0].regnumber;
            const regnumberLastThreeDigits = extractLastThreeDigits(lastRegNumber);
            const newLastThreeDigits = (parseInt(regnumberLastThreeDigits) + 1).toString().padStart(3, '0');
            return `${program_abbreviation}/${yearLastTwoDigits}/SS/${newLastThreeDigits}`;
        } else {
            const lastRegNumber = "RE/21/SS/000";
            const regnumberLastThreeDigits = extractLastThreeDigits(lastRegNumber);
            const newLastThreeDigits = (parseInt(regnumberLastThreeDigits) + 1).toString().padStart(3, '0');
            return `${program_abbreviation}/${yearLastTwoDigits}/SS/${newLastThreeDigits}`;
        }



    } catch (error) {
        console.error(error);
        throw error;
    }
};


//helper function
function insertModuleIntoDatabase(moduleCode, lectureId) {
    const data = {
        module_code: moduleCode,
        lecturer_id: lectureId
    }
    connection.query("INSERT INTO lecturer_module SET?", data, (error, results) => {

        if (error) {
            console.log(error)
        }

    })

}

// Helper function to query the program
function queryProgram(program_id) {
    return new Promise((resolve, reject) => {
        const query = "SELECT * FROM programs WHERE program_id = ?";
        connection.query(query, [program_id], (error, program) => {
            if (error) {
                reject(error);
            } else {
                resolve(program);
            }
        });
    });
}

// Helper function to query the last registration number
function queryLastRegNumber(program_id) {
    return new Promise((resolve, reject) => {
        const query = "SELECT regnumber FROM students WHERE program_id = ? ORDER BY regnumber DESC LIMIT 1";
        connection.query(query, [program_id], (error, result) => {
            if (error) {
                reject(error);
            } else {
                resolve(result);
            }
        });
    });
}

// Helper function to extract the last three digits
function extractLastThreeDigits(inputString) {
    const regex = /(\d{3})$/;
    const match = inputString.match(regex);
    if (match) {
        return match[1];
    } else {
        console.log("No match found.");
        return "000";
    }
}


app.get("/", (req, res) => {
    const data = {
        title: "Dashboard",
        active: "Dashboard"
    };
    res.render("index", data);
});

app.get("/student/logout", (req, res) => {
    delete req.session.studentId
    res.redirect('/student');
});
app.get("/students", (req, res) => {
    connection.query(`SELECT s.*, p.*
    FROM students s
    NATURAL JOIN programs p;
    `, (error, students) => {





        if (students.length > 0) {

            const data = {
                title: "Students",
                active: "Students",
                students: students,

            };
            res.render("students", data);
        }
        else {
            const data = {
                title: "Students",
                active: "Students",
                students: students,
                programs: [],
                total: []
            }
            res.render("students", data);
        }
    })
});


app.get("/students/add-student", (req, res) => {

    connection.query("SELECT * FROM programs", (error, programs) => {
        if (error) {
            console.log(error);
        } else {
            const data = {
                title: "Add Student",
                active: "Add",
                programs: programs,
            };
            res.render("addStudent", data);
        }
    });
});

app.post("/students/add-student", async (req, res) => {
    // Extract the form data from the request
    const { firstname, lastname, regnumber } = req.body;
    const program_id = parseInt(req.body.program, 10);

    if (regnumber === undefined) {
        try {
            const regnumber = await generateRegNumber(program_id);
            console.log("Generated Registration Number:", regnumber);

            // Example usage: Generate a temporary password of length 8
            const tempPassword = generateTemporaryPassword(8);
            const password = await hashPassword(tempPassword);

            // Generate a random password
            const studentData = {
                regnumber,
                firstname,
                lastname,
                program_id,
                password,
                
            };

            connection.query("INSERT INTO students SET ?", studentData, (error, results) => {
                if (error) {
                    console.log(error);
                } else {
                    const data = {
                        title: "Get Login Details",
                        active: "Student",
                        regnumber,
                        firstname,
                        lastname,
                        program_id,
                        tempPassword,
                    };
                    res.render("temporary", data);
                }
            });
        } catch (error) {
            console.error("Error:", error);
        }
    } else {
        const studentData = {
            regnumber,
            firstname,
            lastname,
            program_id,
        };

        connection.query("INSERT INTO students SET ?", studentData, (error, results) => {
            if (error) {
                console.log(error);
            } else {
                res.redirect("/students/add-student");
            }
        });
    }
});

app.post("/students/add-student/verify", (req, res) => {
    // Extract the form data from the request
    const { firstname, lastname } = req.body;
    const program_id = parseInt(req.body.program, 10);
    const password = generateTemporaryPassword(8);

    generateRegNumber(program_id)
        .then(regnumber => {

            const studentData = {
                title: "Students",
                active: "Students",
                regnumber,
                firstname,
                lastname,
                program_id,
                password,

            }
            res.render("addStudentVerify", studentData)
        })
        .catch(error => {
            console.error("Error:", error);
        });
})



app.get("/lecturers", (req, res) => {
    connection.query("SELECT * FROM lecturers", (error, lecturers) => {
        const data = {
            title: "Lecturers",
            active: "Lecturers",
            lecturers: lecturers,
        };
        res.render("lecturers", data);
    });
})

app.get("/lecturers/add-lecturer", (req, res) => {
    connection.query("SELECT * FROM departments", (error, departments) => {

        const data = {
            title: "Lecturers",
            active: "Lecturers",
            departments: departments,
        }
        res.render("addLecturer", data);

    })

})

app.post("/lecturers/add-lecturer", (req, res) => {
    // Extract the form data from the request
    const { firstname, lastname } = req.body;
    const department = parseInt(req.body.department, 10);
    const lecturerData = {
        firstname,
        lastname,
        department,
    }
    connection.query("INSERT INTO lecturers SET?", lecturerData, (error, results) => {
        if (error) {
            console.log(error)
        }
        else {
            req.session.lecturerId = results.insertId
            req.session.lecturerName = `${firstname} ${lastname}`

            res.redirect(`/lecturers/add-module/${department}`)
        }
    })
})
//add module to the lecturer

//student home page
app.get("/student", (req, res) => {
    if (req.session.studentId === undefined) {
        const data = {
            title: "Student",
            active: "Student",
            message: null,
        };

        res.render("studentLogin", data);
    }
    else {
        const data = {
            title: "Dashboard",
            active: "Dashboard",
        }
        res.render('studentDash', data)
    }
});

//login the student
app.post("/student/login", async (req, res) => {
    const { username, password } = req.body;

    connection.query('SELECT * FROM students WHERE regnumber=?', [username], async (error, results) => {
        if (error) throw error;

        if (results.length === 0) {
            const data = {
                title: "Student",
                active: "Student",
                message: "Invalid credentials",
            };

            res.render('studentLogin', data);
        } else {
            const hashedPassword = await hashPassword(password);
            console.log(hashedPassword);

            bcrypt.compare(password, results[0].password).then((isPasswordCorrect) => {
                if (isPasswordCorrect) {
                    req.session.studentId = results[0].regnumber;
    
                    const data = {
                        title: "Student",
                        active: "Student"
                    };
    
                    res.render("studentDash", data);
                } else {
                    const data = {
                        title: "Student",
                        active: "Student",
                        message: "Invalid credentials",
                    };
    
                    res.render('studentLogin', data);
                }
            });
        }
    });
});

app.get("/student/update-profile", (req, res) => {

    const regnumber = req.session.studentId
    if (regnumber === undefined) {
        res.redirect('/student')
    }
    else {
        connection.query("SELECT s.*, p.* FROM students s INNER JOIN programs p ON p.program_id = s.program_id  WHERE regnumber =?", regnumber, (err, results) => {

            if (results.length > 0) {

                const data = {
                    title: "Student",
                    active: "Student",
                    profile: results[0],

                };
                res.render("updateProfile", data);
            }
            else {
                res.send("Student doesnt exist")
            }
        })
    }
});

app.post("/student/update-profile", (req, res) => {
    const regnumber = req.session.studentId
    if (regnumber === undefined) {
        res.redirect("/student")
    }
    else {
        const gender = req.body.gender
        const nk_full_name = req.body.nk_full_name
        const nk_relationship = req.body.nk_relationship
        const nk_phone_number = req.body.nk_phone_number
        const nk_email = req.body.nk_email

        const updateQuery = `UPDATE students SET
    gender = ?,
    nk_full_name = ?,
    nk_relationship = ?,
    nk_phone_number = ?,
    nk_email= ?
    WHERE regnumber = ?`;

        // Execute the update query
        connection.query(updateQuery, [gender, nk_full_name, nk_relationship, nk_phone_number, nk_email, regnumber], (err, result) => {
            if (err) throw err;
            // Check if any rows were affected
            if (result.affectedRows > 0) {
                res.render("feedback", { title: "Students", active: "Students", message: 'Student information updated successfully' });
            } else {
                res.send('No matching student found for the provided regnumber');
            }
        })
    }

})

// add module to a lecture
app.get('/lecturers/add-module/:department', (req, res) => {
    const id = req.params.department;
    connection.query("SELECT * FROM modules WHERE department_id = ? ", [id], (error, modules) => {
        const data = {
            title: "Lecturers",
            active: "Lecturers",
            lecturerName: req.session.lecturerName,
            modules: modules,
        }
        res.render("addModule", data)


    })

});

app.get('/student/results/download-pdf', (req, res) => {
    const regnumber = req.session.studentId;
    if (regnumber === undefined) {
        const data = {
            title: "Student",
            active: "Student",
            message: null,
        };
        res.render('studentLogin', data)
    }
    else {
        connection.query('SELECT * FROM grades WHERE regnumber=?', [regnumber], (error, results) => {
            const semester1Results = results.filter((result) => result.semester === 1)
            const semester2Results = results.filter((result) => result.semester === 2)
            console.log(results)
            const sem1 = semester1Results.map((res) => {
                return `${res.module_code} ${res.marks}  ${parseInt(res.module_code) < 50 ? 'Fail' : 'Pass'}\n`;
            });

            const sem2 = semester2Results.map((res) => {
                return `${res.module_code} ${res.marks}  ${parseInt(res.module_code) < 50 ? 'Fail' : 'Pass'}\n`;
            });



            console.log(sem1)
            // Create a new PDF document
            const doc = new PDFDocument();
            res.setHeader('Content-Type', 'application/pdf');
            res.setHeader('Content-Disposition', 'attachment; filename="results.pdf"');

            // Pipe the PDF content to the response stream
            doc.pipe(res);

            doc.fontSize(24).text(`Exam Results for: ${regnumber}`, { align: 'center' });
            doc.moveDown(); // Move down a line

            // Add a heading
            doc.fontSize(18).text('Semester 1', { underline: true });


            // Add some text content
            doc.fontSize(12).text(`${sem1.join(" ")}`);
            doc.moveDown(); // Move down a line
            doc.moveDown(); // Move down a line
            doc.fontSize(18).text('Semester 2', { underline: true });


            // Add some text content
            doc.fontSize(12).text(`${sem2.join(" ")}`);



            // End the PDF generation
            doc.end();
        })


    }

});



app.get('/delete-student/:regnumber', (req, res) => {
    const regnumber = req.params.regnumber;
    connection.query('DELETE FROM students WHERE regnumber=?', [regnumber], (error, results) => {
        console.log(results)
        if (results.affectedRows === 1) {
            const data = {
                title: "Students",
                active: "Students",
                message: "student successfully removed",

            }
            res.render('removedFeedback', data)
        }
    })

})

app.post('/lecturers/add-modules', (req, res) => {
    const selectedModules = req.body.modules;
    if (selectedModules && selectedModules.length > 0) {
        // Iterate over the selected modules and insert each one into the database
        selectedModules.forEach((moduleCode) => {
            const storedId = req.session.lecturerId;
            if (storedId !== undefined) {
                insertModuleIntoDatabase(moduleCode, storedId);
            } else {
                res.send('No ID found in the session.');
            }

        });

        res.redirect('/lecturers/add-lecturer');
    } else {
        res.send('No modules selected to insert.');

        res.send('Form submitted successfully!');
    }
});

// Define a route to view assigned modules for a lecturer
app.get('/lecturers/:lecturerId/modules', (req, res) => {
    const lecturerId = req.params.lecturerId;

    // Query the database to fetch assigned modules for the lecturer
    const query = `SELECT lm.*, m.title, l.* FROM lecturer_module lm INNER JOIN modules m ON lm.module_code = m.code INNER JOIN lecturers l ON lm.lecturer_id = l.id WHERE lm.lecturer_id = ?;`;

    connection.query(query, [lecturerId], (error, results) => {
        if (error) {
            console.error('Error fetching assigned modules:', error);
            res.status(500).send('An error occurred while fetching assigned modules.');
            return;
        }

        const data = {
            lecturerId: lecturerId,
            title: "Lecturer Modules",
            active: 'Lecturers',
            modules: results,
            lecturerName: `${results[0].firstname} ${results[0].lastname}`,
        }

        // Render the page with the module information
        res.render('lecturerModules', data);
    });
});

// Route to render the form for adding an assessment
app.get('/lecturers/add-assessment', (req, res) => {
    // Replace this with the actual lecturer's ID from the session
    const lecturerId = 18;
    const query = `
    SELECT lm.*, m.code
    FROM lecturer_module lm
    INNER JOIN modules m
    ON lm.module_code = m.code
    WHERE lm.lecturer_id = ?;`;

    connection.query(query, [lecturerId], (error, results) => {

        const data = {
            title: "Add Assessment",
            active: "Assessments",
            lecturerId: lecturerId,
            modules: results,


        }
        res.render('addAssessment', data);
    })
});

// Route to handle the form submission and insert the assessment
app.post('/lecturers/add-assessment', (req, res) => {
    const { name, type, total_marks, module_code, weight, scheduled_date, lecturer_id } = req.body;

    // Insert the assessment into the database
    const query = `
      INSERT INTO assessments (name, type, total_marks, module_code, weight, scheduled_date, lecturer_id)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `;

    connection.query(
        query,
        [name, type, total_marks, module_code, weight, scheduled_date, lecturer_id],
        (error, results) => {
            if (error) {
                console.error('Error inserting assessment:', error);
                res.status(500).send('An error occurred while adding the assessment.');
                return;
            }
            res.redirect('/lecturers/add-assessment');
        }
    );
});
app.get('/student/results', (req, res) => {
    const regnumber = req.session.studentId

    if (regnumber === undefined) {
        const data = {
            title: "Student",
            active: "Student",
            message: null,
        };
        res.render('student', data)
    } else {

        connection.query("SELECT * FROM grades WHERE regnumber=?", [regnumber], (error, results) => {



            const data = {
                title: "Results",
                active: "Results",
                grades: results,
            }
            res.render('studentResults', data)

        })
    }


})

app.get('/performance', (req, res) => {
    const query = `SELECT p.abbreviation, AVG(g.marks) AS average_grade
    FROM programs p
    INNER JOIN students s ON p.program_id = s.program_id
    INNER JOIN grades g ON s.regnumber = g.regnumber
    GROUP BY p.name;`;

    connection.query(query, (error, results) => {
        const query = `SELECT p.abbreviation,
            COUNT(s.regnumber) AS number_of_students
            FROM students s INNER JOIN programs p ON
            s.program_id = p.program_id GROUP BY s.program_id`;

        connection.query(query, (error, countResults) => {

            const studentsData = {
                programsAb: [],
                total: []
            };

            countResults.forEach(item => {
                studentsData.programsAb.push(item.abbreviation);
                studentsData.total.push(item.number_of_students);
            });

            // Object destructuring
            const { programsAb, total } = studentsData




            const performanceData = {
                programs: [],
                avg: []
            };

            results.forEach(item => {
                performanceData.programs.push(item.abbreviation);
                performanceData.avg.push(item.average_grade);
            });

            // Object destructuring
            const { programs, avg } = performanceData




            if (results.length > 0) {
                const data = {
                    title: "Performance",
                    active: "Performance",
                    programs: programs,
                    programsAb: programsAb,
                    total: total,
                    avg: avg,
                }
                res.render("performance", data)
            }

        })
    })

})


// reprts to students


app.get('/reports', (req, res) => {
    const query = `
    SELECT
        s.firstname,
        g.regnumber,
        g.module_code,
        g.semester,
        m.title,
        g.marks
    FROM
        students s
    JOIN
        grades g ON s.regnumber = g.regnumber
    JOIN 
        modules m ON m.code = g.module_code
    ORDER BY
    s.firstname,
    g.semester
    
    ;`;

    connection.query(query, (error, results) => {
        const data = results

        const mappedData = {};

        // Loop through the data and organize it by 'regnumber'
        data.forEach((item) => {
            const regnumber = item.regnumber;

            if (!mappedData[regnumber]) {
                // Initialize an array for each 'regnumber'
                mappedData[regnumber] = {
                    firstname: item.firstname,
                    regnumber: regnumber,
                    modules: [],
                };
            }

            // Add the module details to the 'modules' array
            mappedData[regnumber].modules.push({
                module_code: item.module_code,
                module_name: item.title,
                semester: item.semester,
                marks: item.marks,
            });
        });

        // Convert the mapped data object into an array
        const mappedDataArray = Object.values(mappedData);





        if (results.length > 0) {
            const data = {
                title: "Reports",
                active: "Reports",
                students: mappedDataArray,
            }
            res.render("reports", data)
        }

    })


})

app.get('/send-results/:regnumber', (req, res) => {

    const regnumber = req.params.regnumber;

    const query = `
    SELECT
    s.*,
    g.regnumber,
    g.module_code,
    g.semester,
    g.marks,
    m.*
FROM
    students s
JOIN
    grades g ON s.regnumber = g.regnumber
JOIN 
    modules m ON m.code = g.module_code
WHERE g.regnumber = ?
ORDER BY
    g.semester;
    ;`;

    connection.query(query, [regnumber], (error, results) => {







        if (results.length > 0) {
            const email = results[0].nk_email
            const data = {
                title: "Reports",
                active: "Reports",
                regnumber: regnumber,
                results: results,
                email: email,

            }
            //put the students results in session 
            req.session.studentResults = results
            if (email == null) {
                res.send("Student Must update their next of kin email address")

            }
            else {
                res.render("sendReport", data)
            }
        }

    })


})

app.post('/send-results/:regnumber/:email', (req, res) => {
    const emailAddress = req.params.email
    const results = req.session.studentResults !== undefined ? req.session.studentResults : undefined;
    const message = [`<p>From: School</p>`]
    if (results != undefined) {
        results.map((res) => {
            message.push(`<p style="color:red">${res.title} ${res.marks}  ${parseInt(res.module_code) < 50 ? "Fail" : "Pass"}</p>`)
        });
        console.log(req.body.comments)
        message.push(`<h1> Administrator Comments</h1><p>${req.body.comments}</p>`)
        const msg = message.join(' ')
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: keys.originUser,
                pass: keys.originPassword
            }
        });
        const mailOptions = {
            from: keys.originUser,
            to: 'bit21-mmuva@poly.ac.mw',
            subject: `Exam Results for ${results[0].firstname} ${results[0].lastname}`,
            html: msg
        };

        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                console.log(error);
            } else {
                console.log('Email sent: ' + info.response);
            }
        })

        delete req.session.studentResults;
    }
    else {
        res.send("Did not success")
    }

    res.send("Reached")


})



app.listen(port, () => {
    console.log(`server started at port ${port}`);
});
