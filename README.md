# db2022_2
Inlämningsuppgift

## Entity Relationship Diagram
erDiagram
    Student ||--o{ Phone : has
    Student ||--o{ StudentSchool :attends
    School ||--o{ StudentSchool :enrolls
    Student ||--o{ StudentHobby : has
    Hobby ||--o{ StudentHobby : involves


    StudentSchool {
        int StudentId
        int SchoolId
    }

    Student {
        int StudentId
        Varchar FirstName
        Varchar LastName
    }

    School {
        int SchoolId
        Varchar SchoolName
        Varchar City
    }

    Phone{
        int PhoneId
        int StudentId
        Varchar PhoneType
        Varchar PhoneNumber
    }

    Hobby{
        int HobbyId
        varchar HobbyName
    }

    StudentHobby{
        int StudentId
        int HobbyId
    }

