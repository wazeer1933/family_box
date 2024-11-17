<!-- const functions = require('firebase-functions');
const nodemailer = require('nodemailer');

// Configure the email transporter with your email provider details
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'Allahaidanfam@gmail.com',  // replace with your email
        pass: 'Fahad@1234567'    // replace with your email password
    }
});

// Cloud Function to send an email with a verification code
exports.sendVerificationCode = functions.https.onCall(async (data, context) => {
    const { email, code } = data;

    // Set up the email options
    const mailOptions = {
        from: 'Allahaidanfam@gmail.com',  // sender's email
        to: email,                     // recipient's email
        subject: 'عائلة اللحيدان',
        text: `كود تحققك هو: ${code}`
    };

    // Send the email
    try {
        await transporter.sendMail(mailOptions);
        return { success: true, message: 'Email sent successfully!' };
    } catch (error) {
        console.error('Error sending email:', error);
        return { success: false, message: 'Failed to send email.' };
    }
}); -->

<?php
function sendEmail($email, $code) {
    $to = $email;
    $subject = 'عائلة اللحيدان';
    $message = "كود تحققك هو: $code";
    $headers = "From: Allahaidanfam@gmail.com";

    // Send email
    if (mail($to, $subject, $message, $headers)) {
        echo "Email sent successfully to $to";
    } else {
        echo "Email sending failed";
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $code = $_POST['code'];
    sendEmail($email, $code);
}
?>
