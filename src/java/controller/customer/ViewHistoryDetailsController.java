/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dao.CategoryDAO;
import dao.FeedbackDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.ProductDAO;
import dao.ProviderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.Vector;
import model.Category;
import model.Feedback;
import model.Order;
import model.OrderDetail;
import model.Product;
import model.Provider;
import util.Helper;

/**
 *
 * @author Admin
 */
public class ViewHistoryDetailsController extends HttpServlet {

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
        try ( PrintWriter out = response.getWriter()) {

            int orderId = Integer.parseInt(request.getParameter("orderId"));
            HttpSession session = request.getSession();
            if (session.getAttribute("userId") == null) {
                Helper.setNotification(request, "Please login!", "RED");
                response.sendRedirect("home");
            } else {
                int userId = (int) session.getAttribute("userId");
                String status = request.getParameter("status");
                OrderDetailDAO oddao = new OrderDetailDAO();
                FeedbackDAO feedbackDAO = new FeedbackDAO();
                Vector<OrderDetail> details = oddao.getOrderDetailsById(userId, orderId);
                int check = feedbackDAO.getProductHaveFeedbackInOrder(orderId);
                OrderDAO odao = new OrderDAO();
                Order order = odao.getById(orderId);
                request.setAttribute("order", order);
                request.setAttribute("check", check);
                request.setAttribute("details", details);
                request.setAttribute("status", status);
                CategoryDAO categoryDAO = new CategoryDAO();
                ProviderDAO providerDAO = new ProviderDAO();
                Vector<Category> categories = categoryDAO.getAllCategory();
                Vector<Provider> providers = providerDAO.getAllProvider();
                request.setAttribute("categories", categories);
                request.setAttribute("providers", providers);
                request.getRequestDispatcher("/jsp/HistoryDetails.jsp").forward(request, response);
            }
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
        processRequest(request, response);
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
        processRequest(request, response);
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
