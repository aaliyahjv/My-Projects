package scheduler;

import scheduler.db.ConnectionManager;
import scheduler.model.Caregiver;
import scheduler.model.Patient;
import scheduler.model.Vaccine;
import scheduler.util.Util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;

public class Scheduler {

    // objects to keep track of the currently logged-in user
    // Note: it is always true that at most one of currentCaregiver and currentPatient is not null
    //       since only one user can be logged-in at a time
    private static Caregiver currentCaregiver = null;
    private static Patient currentPatient = null;

    public static void main(String[] args) {
        // printing greetings text
        System.out.println();
        System.out.println("Welcome to the COVID-19 Vaccine Reservation Scheduling Application!");
        System.out.println("*** Please enter one of the following commands ***");
        System.out.println("> create_patient <username> <password>");  //TODO: implement create_patient (Part 1)
        System.out.println("> create_caregiver <username> <password>");
        System.out.println("> login_patient <username> <password>");  // TODO: implement login_patient (Part 1)
        System.out.println("> login_caregiver <username> <password>");
        System.out.println("> search_caregiver_schedule <date>");  // TODO: implement search_caregiver_schedule (Part 2)
        System.out.println("> reserve <date> <vaccine>");  // TODO: implement reserve (Part 2)
        System.out.println("> upload_availability <date>");
        System.out.println("> cancel <appointment_id>");  // TODO: implement cancel (extra credit)
        System.out.println("> add_doses <vaccine> <number>");
        System.out.println("> show_appointments");  // TODO: implement show_appointments (Part 2)
        System.out.println("> logout");  // TODO: implement logout (Part 2)
        System.out.println("> quit");
        System.out.println();

        // read input from user
        BufferedReader r = new BufferedReader(new InputStreamReader(System.in));
        while (true) {
            System.out.print("> ");
            String response = "";
            try {
                response = r.readLine();
            } catch (IOException e) {
                System.out.println("Please try again!");
            }
            // split the user input by spaces
            String[] tokens = response.split(" ");
            // check if input exists
            if (tokens.length == 0) {
                System.out.println("Please try again!");
                continue;
            }
            // determine which operation to perform
            String operation = tokens[0];
            if (operation.equals("create_patient")) {
                createPatient(tokens);
            } else if (operation.equals("create_caregiver")) {
                createCaregiver(tokens);
            } else if (operation.equals("login_patient")) {
                loginPatient(tokens);
            } else if (operation.equals("login_caregiver")) {
                loginCaregiver(tokens);
            } else if (operation.equals("search_caregiver_schedule")) {
                searchCaregiverSchedule(tokens);
            } else if (operation.equals("reserve")) {
                reserve(tokens);
            } else if (operation.equals("upload_availability")) {
                uploadAvailability(tokens);
            } else if (operation.equals("cancel")) {
                cancel(tokens);
            } else if (operation.equals("add_doses")) {
                addDoses(tokens);
            } else if (operation.equals("show_appointments")) {
                showAppointments(tokens);
            } else if (operation.equals("logout")) {
                logout(tokens);
            } else if (operation.equals("quit")) {
                System.out.println("Bye!");
                return;
            } else {
                System.out.println("Invalid operation name!");
            }
        }
    }

    private static void createPatient(String[] tokens) {
        // create_patient <username> <password>
        // check 1: the length for tokens need to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Failed to create user.");
            return;
        }
        String username = tokens[1];
        String password = tokens[2];
        // check 2: check if the username has been taken already
        if (usernameExistsPatient(username)) {
            System.out.println("Username taken, try again!");
            return;
        }
        if (password.length() < 8 ||
                password.equals(password.toLowerCase()) ||
                password.equals(password.toUpperCase()) ||
                password.matches("[a-zA-Z]+") ||
                password.matches("[0-9]+") ||
                (!password.contains("!") && !password.contains("@") &&
                        !password.contains("#") && !password.contains("?"))) {
            System.out.println("Failed to create user.");
            return;
        }
        byte[] salt = Util.generateSalt();
        byte[] hash = Util.generateHash(password, salt);
        // create the caregiver
        try {
            currentPatient = new Patient.PatientBuilder(username, salt, hash).build();
            // save to caregiver information to our database
            currentPatient.saveToDB();
            System.out.println("Created user " + username);
        } catch (SQLException e) {
            System.out.println("Failed to create user.");
            e.printStackTrace();
        }

    }

    private static boolean usernameExistsPatient(String username) {
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();

        String selectUsername = "SELECT * FROM Patients WHERE Username = ?";
        try {
            PreparedStatement statement = con.prepareStatement(selectUsername);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
            // returns false if the cursor is not before the first record or if there are no rows in the ResultSet.
            return resultSet.isBeforeFirst();
        } catch (SQLException e) {
            System.out.println("Error occurred when checking username");
            e.printStackTrace();
        } finally {
            cm.closeConnection();
        }
        return true;
    }

    private static void createCaregiver(String[] tokens) {
        // create_caregiver <username> <password>
        // check 1: the length for tokens need to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Failed to create user.");
            return;
        }
        String username = tokens[1];
        String password = tokens[2];
        // check 2: check if the username has been taken already
        if (usernameExistsCaregiver(username)) {
            System.out.println("Username taken, try again!");
            return;
        }
        if (password.length() < 8 ||
                password.equals(password.toLowerCase()) ||
                password.equals(password.toUpperCase()) ||
                password.matches("[a-zA-Z]+") ||
                password.matches("[0-9]+") ||
                (!password.contains("!") && !password.contains("@") &&
                        !password.contains("#") && !password.contains("?"))) {
            System.out.println("Failed to create user.");
            return;
        }
        byte[] salt = Util.generateSalt();
        byte[] hash = Util.generateHash(password, salt);
        // create the caregiver
        try {
            currentCaregiver = new Caregiver.CaregiverBuilder(username, salt, hash).build();
            // save to caregiver information to our database
            currentCaregiver.saveToDB();
            System.out.println("Created user " + username);
        } catch (SQLException e) {
            System.out.println("Failed to create user.");
            e.printStackTrace();
        }
    }

    private static boolean usernameExistsCaregiver(String username) {
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();

        String selectUsername = "SELECT * FROM Caregivers WHERE Username = ?";
        try {
            PreparedStatement statement = con.prepareStatement(selectUsername);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
            // returns false if the cursor is not before the first record or if there are no rows in the ResultSet.
            return resultSet.isBeforeFirst();
        } catch (SQLException e) {
            System.out.println("Error occurred when checking username");
            e.printStackTrace();
        } finally {
            cm.closeConnection();
        }
        return true;
    }

    private static void loginPatient(String[] tokens) {
        // login_patient <username> <password>
        // check 1: if someone's already logged-in, they need to log out first
        if (currentCaregiver != null || currentPatient != null) {
            System.out.println("User already logged in.");
            return;
        }
        // check 2: the length for tokens need to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Login failed.");
            return;
        }
        String username = tokens[1];
        String password = tokens[2];

        Patient patient = null;
        try {
            patient = new Patient.PatientGetter(username, password).get();
        } catch (SQLException e) {
            System.out.println("Login failed.");
            e.printStackTrace();
        }
        // check if the login was successful
        if (patient == null) {
            System.out.println("Login failed.");
        } else {
            System.out.println("Logged in as: " + username);
            currentPatient = patient;
        }
    }

    private static void loginCaregiver(String[] tokens) {
        // login_caregiver <username> <password>
        // check 1: if someone's already logged-in, they need to log out first
        if (currentCaregiver != null || currentPatient != null) {
            System.out.println("User already logged in.");
            return;
        }
        // check 2: the length for tokens need to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Login failed.");
            return;
        }
        String username = tokens[1];
        String password = tokens[2];

        Caregiver caregiver = null;
        try {
            caregiver = new Caregiver.CaregiverGetter(username, password).get();
        } catch (SQLException e) {
            System.out.println("Login failed.");
            e.printStackTrace();
        }
        // check if the login was successful
        if (caregiver == null) {
            System.out.println("Login failed.");
        } else {
            System.out.println("Logged in as: " + username);
            currentCaregiver = caregiver;
        }
    }

    private static void searchCaregiverSchedule(String[] tokens) {
        // TODO: Part 2
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();
        // check 1: if no user is logged in, they need to login first
        if (currentCaregiver == null && currentPatient == null) {
            System.out.println("Please login first!");
            return;
        }
        // check 2: the length for tokens need to be exactly 2 to include all information (with the operation name)
        if (tokens.length != 2) {
            System.out.println("Please try again!");
            return;
        }

        String selectDate = tokens[1];
        String allVaccines = "SELECT * FROM Vaccines";
        String availCaregivers = "SELECT Username FROM Availabilities WHERE Time = ? ORDER BY Username";
        try {
            PreparedStatement statement1 = con.prepareStatement(availCaregivers);
            statement1.setString(1, selectDate);
            ResultSet resultSet1 = statement1.executeQuery();
            while (resultSet1.next()) {
                String caregiverName = resultSet1.getString("Username");
                System.out.println("Caregiver username: " + caregiverName);
            }
            PreparedStatement statement2 = con.prepareStatement(allVaccines);
            ResultSet resultSet2 = statement2.executeQuery();
            while (resultSet2.next()) {
                String vaccineName = resultSet2.getString("Name");
                int numVaccines = resultSet2.getInt("Doses");
                System.out.println("Vaccine Name: " + vaccineName + ". Doses: " + numVaccines + ".");
            }
        } catch (IllegalArgumentException e) {
            System.out.println("Please try again!");
        } catch (SQLException e) {
            System.out.println("Please try again!");
            e.printStackTrace();
        } finally {
            cm.closeConnection();
        }
    }

    private static void reserve(String[] tokens) {
        // TODO: Part 2
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();
        // check 1: if no user is logged in, they need to login first
        if (currentCaregiver == null && currentPatient == null) {
            System.out.println("Please login first");
        // check 2: check if the current logged-in user is a patient
        } else if (currentCaregiver != null) {
            System.out.println("Please login as a patient!");
        }
        // check 3: the length for tokens need to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Please try again!");
            return;
        }

        String selectDate = tokens[1];
        String allVaccines = tokens[2];
        String availCaregivers = "SELECT Username FROM Availabilities WHERE Time = ?";
        try {
            PreparedStatement statement1 = con.prepareStatement(availCaregivers);
            statement1.setString(1, selectDate);
            ResultSet resultSet1 = statement1.executeQuery();
            if (resultSet1 == null) {
                System.out.println("No Caregiver is available!");
                return;
            }
            resultSet1.next();
            String caregiverName = resultSet1.getString("Username");
            String availDoses = "SELECT Doses FROM Vaccines WHERE Name = ?";
            PreparedStatement statement2 = con.prepareStatement(availDoses);
            statement2.setString(1, allVaccines);
            ResultSet resultSet2 = statement2.executeQuery();
            resultSet2.next();
            int numDoses = resultSet2.getInt("Doses");
            if (numDoses == 0) {
                System.out.println("Not enough available doses!");
                return;
            }

            // Delete date and caregiver from Availabilities table
            String deleteUsername = "DELETE FROM Availabilities WHERE Time = ? AND Username = ?";
            PreparedStatement statement3 = con.prepareStatement(deleteUsername);
            statement3.setString(1, selectDate);
            statement3.setString(2, caregiverName);
            statement3.executeUpdate();

            // Update number of doses of vaccine by decreasing number by 1
            String updateDoses = "UPDATE Vaccines SET Doses = ? WHERE Name = ?";
            PreparedStatement statement4 = con.prepareStatement(updateDoses);
            statement4.setInt(1, numDoses - 1);
            statement4.setString(2, allVaccines);
            statement4.executeUpdate();

            // Create new appointment ID
            String appointmentCount = "SELECT COUNT(*) AS Count FROM Appointments";
            PreparedStatement statement5 = con.prepareStatement(appointmentCount);
            ResultSet resultSet5 = statement5.executeQuery();
            resultSet5.next();
            String appointmentID = resultSet5.getString("Count");

            // Insert appointment ID, date, caregiver username, patient username, and vaccine name into
            //      Appointment table
            String updateAppointments = "INSERT INTO Appointments VALUES(?, ?, ?, ?, ?)";
            PreparedStatement statement6 = con.prepareStatement(updateAppointments);
            statement6.setString(1, appointmentID);
            statement6.setString(2, selectDate);
            statement6.setString(3, caregiverName);
            statement6.setString(4, currentPatient.getUsername());
            statement6.setString(5, allVaccines);
            statement6.executeUpdate();
            System.out.println("Appointment ID: " + appointmentID + ", Caregiver username: " + caregiverName);
        } catch (IllegalArgumentException e) {
            System.out.println("Please try again!");
        } catch (SQLException e) {
            System.out.println("Please try again!");
            e.printStackTrace();
        } finally {
            cm.closeConnection();
        }
    }

    private static void uploadAvailability(String[] tokens) {
        // upload_availability <date>
        // check 1: check if the current logged-in user is a caregiver
        if (currentCaregiver == null) {
            System.out.println("Please login as a caregiver first!");
            return;
        }
        // check 2: the length for tokens need to be exactly 2 to include all information (with the operation name)
        if (tokens.length != 2) {
            System.out.println("Please try again!");
            return;
        }
        String date = tokens[1];
        try {
            Date d = Date.valueOf(date);
            currentCaregiver.uploadAvailability(d);
            System.out.println("Availability uploaded!");
        } catch (IllegalArgumentException e) {
            System.out.println("Please enter a valid date!");
        } catch (SQLException e) {
            System.out.println("Error occurred when uploading availability");
            e.printStackTrace();
        }
    }

    private static void cancel(String[] tokens) {
        // TODO: Extra credit
    }

    private static void addDoses(String[] tokens) {
        // add_doses <vaccine> <number>
        // check 1: check if the current logged-in user is a caregiver
        if (currentCaregiver == null) {
            System.out.println("Please login as a caregiver first!");
            return;
        }
        // check 2: the length for tokens need to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Please try again!");
            return;
        }
        String vaccineName = tokens[1];
        int doses = Integer.parseInt(tokens[2]);
        Vaccine vaccine = null;
        try {
            vaccine = new Vaccine.VaccineGetter(vaccineName).get();
        } catch (SQLException e) {
            System.out.println("Error occurred when adding doses");
            e.printStackTrace();
        }
        // check 3: if getter returns null, it means that we need to create the vaccine and insert it into the Vaccines
        //          table
        if (vaccine == null) {
            try {
                vaccine = new Vaccine.VaccineBuilder(vaccineName, doses).build();
                vaccine.saveToDB();
            } catch (SQLException e) {
                System.out.println("Error occurred when adding doses");
                e.printStackTrace();
            }
        } else {
            // if the vaccine is not null, meaning that the vaccine already exists in our table
            try {
                vaccine.increaseAvailableDoses(doses);
            } catch (SQLException e) {
                System.out.println("Error occurred when adding doses");
                e.printStackTrace();
            }
        }
        System.out.println("Doses updated!");
    }

    private static void showAppointments(String[] tokens) {
        // TODO: Part 2
        // check 1: if no user is logged in, they need to login first
        if (currentCaregiver == null && currentPatient == null) {
            System.out.println("Please login first");
        }
        // check 2: the length for tokens need to be exactly 1 to include all information (with the operation name)
        if (tokens.length != 1) {
            System.out.println("Please try again!");
            return;
        }

        if (currentPatient != null) {
            String caregiverAppointment = "SELECT appointmentId, Name, Time, cUsername FROM Appointments WHERE pUsername = ? ORDER BY appointmentId";
            System.out.println(showAppointmentHelper(caregiverAppointment, currentCaregiver.getUsername()));
        } else {
            String patientAppointment = "SELECT appointmentId, Name, Time, cUsername FROM Appointments WHERE pUsername = ? ORDER BY appointmentId";
            System.out.println(showAppointmentHelper(patientAppointment, currentPatient.getUsername()));
        }
    }

    private static String showAppointmentHelper(String select, String username) {
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();
        String appointmentString = "";
        try {
            PreparedStatement statement1 = con.prepareStatement(select);
            statement1.setString(1, username);
            ResultSet resultSet1 = statement1.executeQuery();
            if (resultSet1 == null) {
                System.out.println("Please try again!");
            } else {
                while (resultSet1.next()) {
                    String appointmentID = resultSet1.getString("appointmentId");
                    String vaccineName = resultSet1.getString("Name");
                    String date = resultSet1.getString("Time");
                    if (username == currentCaregiver.getUsername()) {
                        String caregiverUsername = resultSet1.getString("pUsername");
                        appointmentString += (appointmentID + " " + vaccineName + " " + date + " " + caregiverUsername);
                    } else {
                        String patientUsername = resultSet1.getString("cUsername");
                        appointmentString += (appointmentID + " " + vaccineName + " " + date + " " + patientUsername);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Please try again!");
            e.printStackTrace();
        } finally {
            cm.closeConnection();
        }
        return appointmentString;
    }

    private static void logout(String[] tokens) {
        // TODO: Part 2
        // check 1: if no user is logged in, they need to login first
        if (currentCaregiver == null && currentPatient == null) {
            System.out.println("Please login first");
            return;
        // check 2: the length for tokens need to be exactly 1 to include all information (with the operation name)
        } else if (tokens.length != 1) {
            System.out.println("Please try again!");
            return;
        } else {
            currentCaregiver = null;
            currentPatient = null;
            System.out.println("Successfully logged out!");
        }
    }
}
