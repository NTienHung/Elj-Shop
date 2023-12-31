package controller.admin;

import constant.IConstant;
import dao.EmployeeDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Vector;
import model.User;
import util.Helper;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Huy Nguyen
 */
public class AddUserController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String role = request.getParameter("role");
        String dateOfBirth = request.getParameter("dateOfBirth");
        String street = request.getParameter("street");
        String city = request.getParameter("city");
        String province = request.getParameter("province");
        String country = request.getParameter("country");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmedPassword = request.getParameter("confirmedPassword");
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("role", role);
        request.setAttribute("dateOfBirth", dateOfBirth);
        request.setAttribute("street", street);
        request.setAttribute("city", city);
        request.setAttribute("province", province);
        request.setAttribute("country", country);
        request.setAttribute("phone", phone);
        request.setAttribute("email", email);
        request.setAttribute("password", password);
        request.setAttribute("confirmedPassword", confirmedPassword);

        UserDAO udao = new UserDAO();
        Vector<User> users = udao.getActiveUsers();
        request.setAttribute("users", users);

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date minimumDate = new Date(System.currentTimeMillis());
        Date userDOB = new Date();
        Date maximumDate = new Date(System.currentTimeMillis());
        Calendar calendar = Calendar.getInstance();
        try {
            userDOB = dateFormat.parse(dateOfBirth);
            calendar.setTime(minimumDate);
            calendar.add(Calendar.YEAR, -100);
            minimumDate = dateFormat.parse(dateFormat.format(calendar.getTime()));
            calendar.setTime(maximumDate);
            calendar.add(Calendar.YEAR, -13);
            maximumDate = dateFormat.parse(dateFormat.format(calendar.getTime()));
        } catch (ParseException ex) {
            Logger.getLogger(AddUserController.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        if (!firstName.matches(IConstant.REGEX_FIRSTNAME)) {
            Helper.setNotification(request, "First name is invalid!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else if (!lastName.matches(IConstant.REGEX_LASTNAME)) {
            Helper.setNotification(request, "Last name is invalid!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else if (userDOB.before(minimumDate) || userDOB.after(maximumDate)) {
            Helper.setNotification(request, "User age must be greater than 13!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else if (!street.matches(IConstant.REGEX_STREET)) {
            Helper.setNotification(request, "Street name is invalid!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else if (!city.matches(IConstant.REGEX_CITY)) {
            Helper.setNotification(request, "City name is invalid!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else if (!province.matches(IConstant.REGEX_PROVINCE)) {
            Helper.setNotification(request, "Province name is not valid!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else if (!country.matches(IConstant.REGEX_COUNTRY)) {
            Helper.setNotification(request, "Country name is invalid!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else if (!phone.matches(IConstant.REGEX_PHONE)) {
            Helper.setNotification(request, "Please enter valid phone number!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else if (!email.matches(IConstant.REGEX_EMAIL)) {
            Helper.setNotification(request, "Please enter valid email address!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else if (!password.matches(IConstant.REGEX_PASSWORD)) {
            Helper.setNotification(request, "Password must be Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else if (!confirmedPassword.equals(password)) {
            Helper.setNotification(request, "Confirmed password does not match with password!", "RED");
            request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
        } else {
            if (udao.isEmailExisted(email)) {
                Helper.setNotification(request, "Email address has been used!", "RED");
                request.getRequestDispatcher("/jsp/manageUserPage.jsp").forward(request, response);
            } else {
                int userId = udao.insert(new User(role, firstName, lastName, dateOfBirth, street, city, province, country, phone, email, Helper.hashPassword(password)), true);
                EmployeeDAO edao = new EmployeeDAO();
                edao.insert(userId);
                users = udao.getActiveUsers();
                request.setAttribute("users", users);
                Helper.setNotification(request, "Add new user successfully!", "GREEN");
                response.sendRedirect("home");
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
