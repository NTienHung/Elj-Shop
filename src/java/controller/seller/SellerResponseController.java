/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.seller;

import dao.FeedbackDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;
import model.Feedback;
import model.Report;
import model.User;

/**
 *
 * @author LENOVO
 */
public class SellerResponseController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        String service = request.getParameter("go");
        FeedbackDAO feedBackDAO = new FeedbackDAO();
        UserDAO userDAO = new UserDAO();
        if (service.equals("viewFeedback")) {
            Vector<Feedback> feedbacks = feedBackDAO.getAllFeedback();
            Vector<User> customers = userDAO.getActiveCustomer();
            request.setAttribute("customers", customers);
            request.setAttribute("feedbacks", feedbacks);
            request.getRequestDispatcher("/jsp/sellerFeedbackPage.jsp").forward(request, response);
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

        String service = request.getParameter("go");
        FeedbackDAO feedBackDAO = new FeedbackDAO();
        UserDAO userDAO = new UserDAO();
        if (service.equals("response-customer")) {
            Date date = new Date();
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
            String formattedDate = formatter.format(date);

            int customerId = Integer.parseInt(request.getParameter("customerId"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            String content = request.getParameter("response-content");
            String reply = request.getParameter("reply");
            System.out.println(reply);
            Feedback feedback = new Feedback(customerId, productId, content, reply, formattedDate, true);

            feedBackDAO.insertCheckedFeedback(feedback);
            Vector<Feedback> feedbacks = feedBackDAO.getAllFeedback();
            Vector<User> customers = userDAO.getActiveCustomer();
            request.setAttribute("customers", customers);
            request.setAttribute("feedbacks", feedbacks);
//            response.sendRedirect("write-feedback");
            request.getRequestDispatcher("/jsp/sellerFeedbackPage.jsp").forward(request, response);
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
    }// </editor-fold>

}
