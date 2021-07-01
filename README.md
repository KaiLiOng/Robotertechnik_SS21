# Robotertechnik_SS21
The purpose of this GUI is to calculate Denavit Hartenberg Parameter by using vector and quaternion orientation in the base coordinate system.

COMPULSORY HOMEWORK ROBOT TECHNOLOGY SS21
    Lecturer: Prof. Martin Kipfmüeller
    Group member:
                   Danial Hawari (67252)
                   Kai Li Ong    (67254)
                   Davin Lukito  (75420)
    Task list:
    To Create an algorithm using the Denavit-Hartenberg convention that,
    1) User specifies the vector to the origin of the i-th coordinate system in base coordinates
    2) Specifies the orientation of the i-th coordinate system relative to the base in terms of quaternions (Euler-Rodrigues parameters)
    3) Data is to be requested from the user in the form of a prompt
    4) Compute Denavit-Hartenberg parameters
    5) Plot 2D or 3D figure
    6) Check whether the user insert sensible input

Procedures taken to solve the homework
    Create the GUI with Mathlab App Designer
    Prompt user for the vector in base coordinate system
    Prompt user for the quaternion relative to the base coordinate system
    Check user input for vector and quaternion with:
        1) baseVectorPlausibilityCheck function that examines whether at least one of the input vector variable inside (x,y,z) base coordinate is equal to the previous input vector. If equal, the two links can be connected to the same joint.      
        2) quaternionPlausibilityCheck function that examines
            a. q0^2+q1^2+q2^2+q3^2 == 1
            b. |q0|<= 1 && |q1|<=1 && |q2|<=1 && |q3|<=1
    Calculate the Denavit Hartenberg parameter by converting quaternion to rotation matrix getting theta and alpha from RotMat getting distance d and a from the input vector
    Connect all links together
    Plot figure
    
    ![alt text](https://github.com/KaiLiOng/Robotertechnik_SS21/blob/Media/DHApp.jpeg?raw=true)
