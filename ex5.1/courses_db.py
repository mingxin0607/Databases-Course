import sqlite3
from tabulate import tabulate
DATABASE_FILE = 'courses_system.db'

# connect to SQLite database
def connect_to_database():
    try:
        conn = sqlite3.connect(DATABASE_FILE)
        cursor = conn.cursor()
        return conn, cursor
    except sqlite3.Error as e:
        print(f"Error connecting to the database: {e}")
        return None, None

# create tables
def create_tables(cursor):
    try:
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS students (
                student_id INTEGER PRIMARY KEY,
                student_name TEXT NOT NULL
            )
        ''')

        cursor.execute('''
            CREATE TABLE IF NOT EXISTS courses (
                course_id INTEGER PRIMARY KEY,
                course_name TEXT NOT NULL,
                schedule TEXT NOT NULL
            )
        ''')

        cursor.execute('''
            CREATE TABLE IF NOT EXISTS enrollments (
                student_id INTEGER,
                course_id INTEGER,
                FOREIGN KEY (student_id) REFERENCES students (student_id),
                FOREIGN KEY (course_id) REFERENCES courses (course_id),
                PRIMARY KEY (student_id, course_id)
            )
        ''')
    except sqlite3.Error as e:
        print(f"Error creating tables: {e}")

# enroll a student in a course
def enroll_student(cursor, student_id, course_id):
    try:
        cursor.execute('INSERT INTO enrollments VALUES (?, ?)', (student_id, course_id))
        conn.commit()
        print("Student enrolled in the course successfully.")
    except sqlite3.Error as e:
        print(f"Error enrolling student: {e}")

# display students enrolled in a course
def students_in_course(cursor, course_id):
    try:
        cursor.execute('''
            SELECT students.student_name
            FROM students
            JOIN enrollments ON students.student_id = enrollments.student_id
            WHERE enrollments.course_id = ?
        ''', (course_id,))
        students = cursor.fetchall()
        return students
    except sqlite3.Error as e:
        print(f"Error retrieving students in course: {e}")
        return []

# display courses a student is enrolled in
def courses_for_student(cursor, student_id):
    try:
        cursor.execute('''
            SELECT courses.course_name, courses.schedule
            FROM courses
            JOIN enrollments ON courses.course_id = enrollments.course_id
            WHERE enrollments.student_id = ?
        ''', (student_id,))
        courses = cursor.fetchall()
        return courses
    except sqlite3.Error as e:
        print(f"Error retrieving courses for student: {e}")
        return []

# display courses and their schedule for a student on a given day
def student_schedule(cursor, student_id, day_of_week):
    try:
        cursor.execute('''
            SELECT courses.course_name, courses.schedule
            FROM courses
            JOIN enrollments ON courses.course_id = enrollments.course_id
            WHERE enrollments.student_id = ? AND courses.schedule LIKE ?
        ''', (student_id, f'%{day_of_week}%'))
        schedule = cursor.fetchall()
        return schedule
    except sqlite3.Error as e:
        print(f"Error retrieving student schedule: {e}")
        # return []chall()
    # return schedule

# display students table
def show_students_table(cursor):
    cursor.execute('''
        SELECT *
        FROM students
    ''')
    students_table = cursor.fetchall()
    return students_table

# display courses table
def show_courses_table(cursor):
    cursor.execute('''
        SELECT *
        FROM courses
    ''')
    courses_table = cursor.fetchall()
    return courses_table

# display courses table
def show_enrollments_table(cursor):
    cursor.execute('''
        SELECT *
        FROM enrollments
    ''')
    enrollments_table = cursor.fetchall()
    return enrollments_table

# main loop
conn, cursor = connect_to_database()

while True:
    print("\n-------- Courses Management System --------")
    print("1. Enroll a new student")
    print("2. Introduce a new course")
    print("3. Enroll a student in a course")
    print("4. View students in a course")
    print("5. View courses for a student")
    print("6. View courses and schedule for a student on a given day")
    print("7. Print students table")
    print("8. Print courses table")
    print("9. Print enrollment table")
    print("10. Exit")

    choice = input("Enter your choice: ")

    if choice == '1':
        student_name = input("Enter the student's name: ")
        cursor.execute('INSERT INTO students (student_name) VALUES (?)', ( student_name,))
        conn.commit()
        print("Student enrolled successfully.")

    elif choice == '2':
        course_name = input("Enter the course name: ")
        schedule = input("Enter the course schedule: ")
        cursor.execute('INSERT INTO courses (course_name, schedule) VALUES (?, ?)', (course_name, schedule))
        conn.commit()
        print("Course introduced successfully.")

    elif choice == '3':
        student_id = int(input("Enter the student ID: "))
        course_id = int(input("Enter the course ID: "))
        enroll_student(cursor, student_id, course_id)
        

    elif choice == '4':
        course_id = int(input("Enter the course ID: "))
        enrolled_students = students_in_course(cursor, course_id)
        print(tabulate(enrolled_students, headers=['Student Name']))

    elif choice == '5':
        student_id = int(input("Enter the student ID: "))
        enrolled_courses = courses_for_student(cursor, student_id)
        print(tabulate(enrolled_courses, headers=['Course Name', 'Schedule']))

    elif choice == '6':
        student_id = int(input("Enter the student ID: "))
        day_of_week = input("Enter the day of the week: ")
        student_schedule_info = student_schedule(cursor,student_id, day_of_week)
        print(tabulate(student_schedule_info, headers=['Course Name', 'Schedule']))

    elif choice == '7':
        print(tabulate(show_students_table(cursor), headers=['Student ID', 'Student Name']))

    elif choice == '8':
        print(tabulate(show_courses_table(cursor), headers=['Course ID', "Course Name", "Schedule"]))

    elif choice == '9':
        print(tabulate(show_enrollments_table(cursor), headers=['Student ID', 'Course ID']))

    elif choice == '10':
        break

    else:
        print("Invalid choice. Please enter a valid option.")

# close the database connection
conn.close()
