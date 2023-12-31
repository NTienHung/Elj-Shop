package controller.admin;

import constant.IConstant;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import util.Helper;

/**
 *
 * @author Huy Nguyen
 */
public class UpdateUserController extends HttpServlet {

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
        if (!Helper.isUserExists(request)) {
            Helper.setNotification(request, "User doesn't exists!", "RED");
            response.sendRedirect("home");
        } else {
            UserDAO udao = new UserDAO();
            User user = udao.getById(Integer.parseInt(request.getParameter("userId")));
            request.setAttribute("user", user);
            request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
        }
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
        if (request.getParameter("UpdateUserEditPersonalInfoSubmit") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            String role = request.getParameter("role");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String street = request.getParameter("street");
            String city = request.getParameter("city");
            String province = request.getParameter("province");
            String country = request.getParameter("country");
            String phone = request.getParameter("phone");

            UserDAO udao = new UserDAO();
            User user = udao.getById(id);
            User userToUpdate = new User(id, role, firstName, lastName, dateOfBirth.isEmpty() ? null : dateOfBirth, street, city, province, country, phone);
            userToUpdate.setEmail(user.getEmail());
            if (user.getPassword() != null) { //for distinct Google user
                userToUpdate.setPassword("password"); 
            }
            request.setAttribute("user", userToUpdate);

            Date minimumDate = new Date(System.currentTimeMillis());
            Date userDOB = new Date();
            Date maximumDate = new Date(System.currentTimeMillis());
            if(!dateOfBirth.isEmpty()) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                Calendar calendar = Calendar.getInstance();
                try {
                    userDOB = dateFormat.parse(dateOfBirth);
                    calendar.setTime(minimumDate);
                    calendar.add(Calendar.YEAR, -100);
                    minimumDate = dateFormat.parse(dateFormat.format(calendar.getTime()));
                    calendar.setTime(maximumDate);
                    calendar.add(Calendar.YEAR, role.equals("Customer") ? -13 : -18);
                    maximumDate = dateFormat.parse(dateFormat.format(calendar.getTime()));
                } catch (ParseException ex) {
                    Logger.getLogger(AddUserController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            if (!firstName.matches(IConstant.REGEX_FIRSTNAME)) {
                Helper.setNotification(request, "First name is invalid!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else if (!lastName.matches(IConstant.REGEX_LASTNAME)) {
                Helper.setNotification(request, "Last name is invalid!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else if (!role.equals("Customer") && (dateOfBirth.isEmpty() || (userDOB.before(minimumDate) || userDOB.after(maximumDate)))) {
                Helper.setNotification(request, "Employee age must be not empty and greater than 18!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            }  else if (role.equals("Customer")  && !dateOfBirth.isEmpty() && (userDOB.before(minimumDate) || userDOB.after(maximumDate))) {
                Helper.setNotification(request, "Customer age must be greater than 13!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else if ((!role.equals("Customer") || !street.isEmpty()) && !street.matches(IConstant.REGEX_STREET)) {
                Helper.setNotification(request, "Street name is invalid!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else if ((!role.equals("Customer") || !city.isEmpty()) && !city.matches(IConstant.REGEX_CITY)) {
                Helper.setNotification(request, "City name is invalid!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else if ((!role.equals("Customer") || !province.isEmpty()) && !province.matches(IConstant.REGEX_PROVINCE)) {
                Helper.setNotification(request, "Province name is not valid!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else if ((!role.equals("Customer") || !country.isEmpty()) && !country.matches(IConstant.REGEX_COUNTRY)) {
                Helper.setNotification(request, "Country name is invalid!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else if ((!role.equals("Customer") || !phone.isEmpty()) && !phone.matches(IConstant.REGEX_PHONE)) {
                Helper.setNotification(request, "Please enter valid phone number!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else {
                udao.updateProfile(userToUpdate);
                udao.changeRole(id, role);
                Helper.setNotification(request, "Change information successfully!", "GREEN");
                response.sendRedirect("home");
            }
        } else if (request.getParameter("UpdateUserUpdateEmailSubmit") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            String email = request.getParameter("email");

            UserDAO udao = new UserDAO();
            User user = udao.getById(id);
            user.setEmail(email);
            request.setAttribute("user", user);

            if (!email.matches(IConstant.REGEX_EMAIL)) {
                Helper.setNotification(request, "Please enter valid email address!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else if (udao.isEmailExisted(email)) {
                Helper.setNotification(request, "Email address has been used!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else {
                udao.updateEmail(user, email);
                Helper.setNotification(request, "Update user " + user.getFirstName() + " email successfully!", "GREEN");
                response.sendRedirect("home");
            }
        } else if (request.getParameter("UpdateUserChangePasswordSubmit") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            String password = request.getParameter("password");

            UserDAO udao = new UserDAO();
            User user = udao.getById(id);
            request.setAttribute("user", user);

            if (!password.matches(IConstant.REGEX_PASSWORD)) {
                Helper.setNotification(request, "Password must be Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character!", "RED");
                request.getRequestDispatcher("/jsp/updateUserPage.jsp").forward(request, response);
            } else {
                User userToUpdate = new User(id, user.getEmail(), Helper.hashPassword(password));
                udao.changePassword(userToUpdate, Helper.hashPassword(password));
                Helper.setNotification(request, "Change " + user.getFirstName() + " password successfully!", "GREEN");
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
