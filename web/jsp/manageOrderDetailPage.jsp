<%-- 
    Document   : manageOrderDetailPage
    Created on : Oct 26, 2023, 1:35:26 PM
    Author     : LENOVO
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="dao.ProductDAO" %>
<%@ page import="dao.FeedbackDAO" %>
<%@ page import="model.Product" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="model.Order" %>
<%@ page import="java.util.Vector" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Elj Shop - Online Art Supplies Shop</title>
        <!<!-- Favicon -->
        <link rel="icon" href="${pageContext.request.contextPath}/img/logo.ico" type="image/icon type">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link href="${pageContext.request.contextPath}/css/manager.css?version=1" rel="stylesheet"/>
        <style>
            img{
                width: 200px;
                height: 120px;
            }
        </style>
    <body>
        <div class="container">
            <div class="row p-3 text-right">
                <a href="profile" class="btn btn-primary">Profile</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary">Log Out</a>
            </div>
            <% ProductDAO pdao = new ProductDAO(); %>
            <% Vector<OrderDetail> details = (Vector<OrderDetail>) request.getAttribute("orderdetails"); %>
            <% Order od = (Order) request.getAttribute("order");%>
            <style>
                .vertical-line {
                    border-right: 1px solid #ccc;
                }
            </style>
            <% double oldTotal=0; %>
            <% for(int i = 0; i < details.size(); i++) {%>
            <% oldTotal += details.get(i).getPrice()*details.get(i).getQuantity(); %>
            <% } %>
            <div class="table-wrapper">
                <div class="table-title">
                    <div class="row">
                        <div class="col-sm-3">
                            <a href="home" style="color: white"> <h2>Manage <b>Order Detail</b></h2></a>
                        </div>
                    </div>
                </div>              
                <div class="details">
                    <div class="row px-xl-5">
                        <div class="col-md-6 ">
                            <h5>Customer's Order Information</h5>
                            <label>Name</label>
                            <input class="form-control" type="text" placeholder="Receiver Name" value="${order.receiver}" readonly>
                            <label>Phone</label> 
                            <input class="form-control" type="text" placeholder="Phone" value="${order.shipPhone}" readonly>
                            <label>Address</label>
                            <input class="form-control" type="text" placeholder="Address" value="${order.shipStreet}, ${order.shipCity}, ${order.shipProvince}, ${order.shipCountry}" readonly>
                            <label>E-mail</label>
                            <input class="form-control" type="email" placeholder="example@email.com" value="${order.shipEmail}" readonly>
                        </div>
                        <div class="col-md-6 form-group">
                            <h5>Order Information</h5>
                            <label>Created Date</label>
                            <input class="form-control" type="text" placeholder="Created Time" value="${order.createdTime}" readonly>
                            <label>Status</label>
                            <input class="form-control" type="text" placeholder="Status" value="${order.status}" readonly>
                            <label>Subtotal</label>
                            <input class="form-control" type="text" placeholder="Subtotal" value="<fmt:formatNumber type="currency" pattern="###,###¤"><%= oldTotal %></fmt:formatNumber>" readonly>
                                <label>Shipping</label>
                                <input class="form-control" type="text" placeholder="Shipping" value="<fmt:formatNumber type="currency" pattern="###,###¤"><%= oldTotal*0.1 %></fmt:formatNumber>" readonly>
                                <label>Discount</label>
                            <% if((oldTotal*1.1 - od.getTotalPrice())==0) {%>
                            <input class="form-control" type="text" placeholder="Discount" value="<fmt:formatNumber type="currency" pattern="###,###¤">0</fmt:formatNumber>" readonly>
                            <% } else { %>
                            <input class="form-control" type="text" placeholder="Discount" value="<fmt:formatNumber type="currency" pattern="###,###¤">-<%= (oldTotal*1.1 - od.getTotalPrice()) %></fmt:formatNumber>" readonly>
                            <% } %>
                            <label>Total</label>
                            <input class="form-control" type="text" placeholder="Total" value="<fmt:formatNumber type="currency" pattern="###,###¤">${order.totalPrice}</fmt:formatNumber>" readonly>
                            </div>
                        </div>
                    </div>
                
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ProductID</th>
                            <th>OrderId</th>
                            <th>Price</th>
                            <th>Quantity</th
                        </tr>
                    </thead>

                    <tbody>

                    <c:forEach items="${orderdetails}" var="orderdetail">
                        <tr>
                            <td class="align-middle">${orderdetail.productID}</td>
                            <td class="align-middle">${orderdetail.orderID}</td>
                            <td class="align-middle">${orderdetail.price}</td>
                            <td class="align-middle">${orderdetail.quantity}</td>  
                        </tr>
                    </c:forEach>

                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Modal HTML -->
    <div id="addEmployeeModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="add" method="post">
                    <div class="modal-header">						
                        <h4 class="modal-title">Add Product</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    </div>
                    <div class="modal-body">					
                        <div class="form-group">
                            <label>Name</label>
                            <input name="name" type="text" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Image</label>
                            <input name="image" type="text" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Price</label>
                            <input name="price" type="text" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Title</label>
                            <textarea name="title" class="form-control" required></textarea>
                        </div>
                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="description" class="form-control" required></textarea>
                        </div>
                        <div class="form-group">
                            <label>Category</label>
                            <select name="category" class="form-select" aria-label="Default select example">
                                <c:forEach begin="1" end="3" var="o">
                                    <option value="1">Giày Adidas</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                        <input type="submit" class="btn btn-success" value="Add">
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Modal HTML -->
    <div id="editEmployeeModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <form>
                    <div class="modal-header">						
                        <h4 class="modal-title">Edit Employee</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    </div>
                    <div class="modal-body">					
                        <div class="form-group">
                            <label>Name</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Address</label>
                            <textarea class="form-control" required></textarea>
                        </div>
                        <div class="form-group">
                            <label>Phone</label>
                            <input type="text" class="form-control" required>
                        </div>					
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                        <input type="submit" class="btn btn-info" value="Save">
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Modal HTML -->
    <div id="deleteEmployeeModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <form>
                    <div class="modal-header">						
                        <h4 class="modal-title">Delete Product</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    </div>
                    <div class="modal-body">					
                        <p>Are you sure you want to delete these Records?</p>
                        <p class="text-warning"><small>This action cannot be undone.</small></p>
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                        <input type="submit" class="btn btn-danger" value="Delete">
                    </div>
                </form>
            </div>
        </div>
    </div>
</a>
<script src="${pageContext.request.contextPath}/js/manager.js" type="text/javascript"></script>
</body>
</html>