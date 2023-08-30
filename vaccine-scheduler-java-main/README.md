# Appointment Reservation System

Users can schedule time splots for some centralized source. Programmed using SQL from within Java via JDBC to schedule appointments for vaccines, with users being patients and caregviers that must keep track of vaccine stock and appointments.

Contains methods to create a patient/caregiver username and password, system login, search caregiver schedule, reserve vaccines, upload availability, cancel appointments, add doses, show appointments, logout, and quit. 

## Notes
The assignment is to build a vaccine scheduling application (with a database hosted on Microsoft Azure) that can be deployed by hospitals or clinics and supports interaction with users through the terminal/command-line interface. In the real world it is unlikely that users would be using the command line terminal instead of a GUI, but all of the application logic would remain the same. For simplicity of programming, we use the command line terminal as our user interface for this assignment.
We need the following entity sets in our database schema design:
* Patients: these are customers that want to receive the vaccine.
* Caregivers: these are employees of the health organization administering the vaccines.
* Vaccines: these are vaccine doses in the health organization’s inventory of medical supplies that are on hand and ready to be given to the patients.
