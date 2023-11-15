package controller.marketingstaff;

import dao.VoucherDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.time.LocalDate;
import java.lang.IllegalArgumentException;
import java.util.Vector;
import model.Voucher;
import util.Helper;

/**
 *
 * @author maclile
 */
public class MaketingStaffHomeController extends HttpServlet {

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
        if (service == null || service.equals("")) {
            service = "displayAll";
        }
        if (service.equals("displayAll")) {
            VoucherDAO voucherDAO = new VoucherDAO();
            Vector<Voucher> voucher = voucherDAO.getAll();
            request.setAttribute("voucher", voucher);
            request.getRequestDispatcher("/jsp/manageVoucherPage.jsp").forward(request, response);
        }
        if (service.equals("delete")) {
            VoucherDAO dao = new VoucherDAO();
            int id = Integer.parseInt(request.getParameter("id"));
            Voucher deleteVoucher = dao.getById(id);
            int checkDelete = dao.deleteVoucher(id);

            if (checkDelete != 0) {
                //Delete success notification
                Helper.setNotification(request, "Delete voucher " + deleteVoucher.getCode() + " successfully!", "GREEN");
            } else {
                //Delete fail notification
                Helper.setNotification(request, "Delete voucher " + deleteVoucher.getCode() + " fail!", "RED");
            }
            response.sendRedirect("home");
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
        VoucherDAO voucherDAO = new VoucherDAO();
        //
        if (request.getParameter("search") != null) {
            String code = request.getParameter("code");
            Vector<Voucher> voucher = voucherDAO.findByCode(code);
            request.setAttribute("voucher", voucher);
            request.getRequestDispatcher("/jsp/manageVoucherPage.jsp").forward(request, response);
        }
        //
        if (service.equals("add")) {
            try {
                LocalDate today = LocalDate.now();
                Date todayDate = Date.valueOf(today);
                Voucher vc = new Voucher();
                vc.setCode(request.getParameter("code"));
                vc.setStartDate(Date.valueOf(request.getParameter("startDate")));
                vc.setEndDate(Date.valueOf(request.getParameter("endDate")));
                vc.setValue(Double.parseDouble(request.getParameter("value")));
                if (vc.getEndDate().compareTo(vc.getStartDate()) >= 0) {
                    if (vc.getEndDate().compareTo(todayDate) >= 0) {
                        if (vc.getValue() >= 0 && vc.getValue() <= 100) {
                            voucherDAO.insertVoucher(vc);
                            response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                            Helper.setNotification(request, "Create new voucher successfully!", "GREEN");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                            Helper.setNotification(request, "Value must between 0 and 100", "RED");
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                        Helper.setNotification(request, "End date can not be in past", "RED");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                    Helper.setNotification(request, "The end date cannot be before the creation date", "RED");
                }
            } catch (IllegalArgumentException e) {
                response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                Helper.setNotification(request, "Invalid date format. Please use yyyy-MM-dd", "RED");
            }
        }
        
        if (service.equals("updateVoucher")) {
            try {
                LocalDate today = LocalDate.now();
                Date todayDate = Date.valueOf(today);
                int id = Integer.parseInt(request.getParameter("id"));
                String code = request.getParameter("code");
                Date startDate = Date.valueOf(request.getParameter("startDate"));
                Date endDate = Date.valueOf(request.getParameter("endDate"));
                Double value = Double.parseDouble(request.getParameter("value"));
                //
                Voucher updateVoucher = new Voucher(id, code, startDate, endDate, value, true);
                if (endDate.compareTo(startDate) >= 0) {
                    if (endDate.compareTo(todayDate) >= 0) {
                        if (value >= 0 && value <= 100) {
                            voucherDAO.updateVoucher(updateVoucher);
                            response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                            Helper.setNotification(request, "Update voucher " + code + " successfully!", "GREEN");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                            Helper.setNotification(request, "Value must between 0 and 100", "RED");
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                        Helper.setNotification(request, "End date can not be in past", "RED");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                    Helper.setNotification(request, "The end date cannot be before the creation date", "RED");
                }
            } catch (IllegalStateException e) {
                response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                Helper.setNotification(request, "Invalid date format. Please use yyyy-MM-dd", "RED");
            } catch (IllegalArgumentException e2){
                response.sendRedirect(request.getContextPath() + "/marketing-staff/home");
                Helper.setNotification(request, "Invalid date format. Please use yyyy-MM-dd", "RED");
            }
        }
    }
}
