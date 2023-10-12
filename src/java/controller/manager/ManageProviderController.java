/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manager;

import dao.CategoryDAO;
import dao.ProductDAO;
import dao.ProviderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.Category;
import model.Product;
import model.Provider;

/**
 *
 * @author admin
 */
public class ManageProviderController extends HttpServlet {

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
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ManageProviderController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageProviderController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        CategoryDAO cdao = new CategoryDAO();
        Vector<Category> categories = cdao.getAllCategory();
        ProviderDAO providerDAO = new ProviderDAO();
        request.setAttribute("categories", categories);
        if (service == null || service.equals("")) {
            service = "displayAll";
        }
        if (service.equals("displayAll")) {
            Vector<Provider> providers = providerDAO.getAllProvider();
            request.setAttribute("providers", providers);
            request.getRequestDispatcher("/jsp/manageProviderPage.jsp").forward(request, response);
        } else if (service.equals("delete")) {
            String pid = request.getParameter("pid");
            providerDAO.deleteProvider(pid);
            response.sendRedirect("provider");
        }else if (service.equals("getEditProvider")) {
            int pUpdateId = Integer.parseInt(request.getParameter("pid"));
            Provider updateProvider = providerDAO.getProviderById(pUpdateId);
            request.setAttribute("updateProvider", updateProvider);
            request.getRequestDispatcher("/jsp/updateProviderPage.jsp").forward(request, response);
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
        CategoryDAO cdao = new CategoryDAO();
        ProviderDAO providerDAO = new ProviderDAO();
        Vector<Category> categories = cdao.getAllCategory();
        request.setAttribute("categories", categories);
        if (service.equals("AddProvider")) {
            String pCompanyName = request.getParameter("companyName");
            String pImage = request.getParameter("image");
            ProviderDAO pro = new ProviderDAO();
            int checkInsert = pro.insertProvider(pCompanyName, pImage);
            if (checkInsert != 0 ) {
                //Insert success notification
            }else{
                //Insert fail notification
            }
            response.sendRedirect("provider");
        }else if(service.equals("UpdateProvider")){
            int pId = Integer.parseInt(request.getParameter("id"));
            String pName = request.getParameter("name");
            String pImage = request.getParameter("image");
            Provider updateProvider = new Provider(pId, pName, pImage, true);
            int checkUpdate =  providerDAO.updateProvider(updateProvider);
            if (checkUpdate != 0) {
                //Insert success notification
            } else {
                //Insert fail notification
            }
            response.sendRedirect("provider");
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
