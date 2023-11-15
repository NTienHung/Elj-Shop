<%-- 
    Document   : ManagerProduct
    Created on : Dec 28, 2020, 5:19:02 PM
    Author     : maclife
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

            <!-- Notification -->
            <c:if test="${notification != null}">
                <div class="container-fluid mb-3">
                    <div class="row px-xl-5">
                        <div class="col-lg-12">
                            <div class="alert <c:choose><c:when test="${notiType == 'RED'}">alert-danger</c:when><c:otherwise>alert-success</c:otherwise></c:choose>">
                                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                            <strong><%= session.getAttribute("notification")%></strong>
                                <%session.removeAttribute("notification");%>
                                <%session.removeAttribute("notiType");%>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!--Search Form-->

            <div class="table-wrapper">
                <div class="table-title">
                    <div class="row">
                        <div class="col-sm-6">
                            <h2>Manage <b>Voucher</b></h2>
                        </div>
                        <div class="col-sm-6">
                            <a href="#addEmployeeModal"  class="btn btn-success" data-toggle="modal"><i class="material-icons">&#xE147;</i> <span>Add</span></a>					
                        </div>
                    </div>
                </div>
                <div class="">
                    <form action="${pageContext.request.contextPath}/marketing-staff/home" method="POST">
                        <div class="text-right" style="margin-top: 0.5%">
                            <input style="color: black" name = "code" type="text" placeholder="Search by code" value="${param.code}">
                            <input style="color: #000000" type="submit" name = "search" value="Search">
                        </div>
                    </form>
                </div>
                <!--Data table-->
                <c:choose>
                    <c:when test="${param.go == null || param.go == 'displayAll'}">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Code</th> 
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Value</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${voucher}" var="voucher">
                                    <tr>
                                        <td class="align-middle">${voucher.id}</td>
                                        <td class="align-middle">${voucher.code}</td>
                                        <td class="align-middle">${voucher.startDate}</td>
                                        <td class="align-middle">${voucher.endDate}</td>
                                        <td class="align-middle">${voucher.value}</td>
                                        <td>
                                            <a href="#editEmployeeModal${voucher.id}"  class="edit" data-toggle="modal"><i class="material-icons" data-toggle="tooltip" title="Edit">&#xE254;</i></a>
                                            <a href="home?go=delete&id=${voucher.id}" class="delete" data-toggle="modal"><i class="material-icons" data-toggle="tooltip" title="Delete">&#xE872;</i></a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                </c:choose>
            </div>
        </div>



        <!-- Add Modal HTML -->
        <div id="addEmployeeModal" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="${pageContext.request.contextPath}/marketing-staff/home?go=add" method="post">
                        <div class="modal-header">						
                            <h4 class="modal-title">Add Voucher</h4>
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        </div>
                        <div class="modal-body">					
                            <div class="form-group">
                                <label>Code</label>
                                <input name="code" type="text" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Start Date</label>
                                <input name="startDate" type="date" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>End Date</label>
                                <input name="endDate" type="date" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Value</label>
                                <input name="value" type="number" class="form-control" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                            <input type="submit" class="btn btn-success" title="Add" name="add" value="Add new voucher">
                        </div>
                    </form>
                </div>
            </div>
        </div>


        <!-- Edit Modal HTML -->
        <c:forEach items="${voucher}" var="voucher">
            <div id="editEmployeeModal${voucher.id}" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="home" method="post">
                            <div class="modal-header">						
                                <h4 class="modal-title">Edit Employee</h4>
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            </div>
                            <div class="modal-body">					
                                <div class="form-group">
                                    <label>ID</label>
                                    <input type="number" class="form-control" value="${voucher.id}" name="id" readonly required>
                                </div>
                                <div class="form-group">
                                    <label>Code</label>
                                    <input type="text" class="form-control" value="${voucher.code}" name="code" required>
                                </div>
                                <div class="form-group">
                                    <label>Start Date</label>
                                    <input type="date" class="form-control" value="${voucher.startDate}" name="startDate" required>
                                </div>
                                <div class="form-group">
                                    <label>End Date</label>
                                    <input type="date" class="form-control" value="${voucher.endDate}" name="endDate" required>
                                </div>
                                <div class="form-group">
                                    <label>Value</label>
                                    <input type="number" class="form-control" value="${voucher.value}" name="value" required>
                                </div>
                                <input type="hidden" name="go" value="updateVoucher">
                            </div>
                            <div class="modal-footer">
                                <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                                <input type="submit" class="btn btn-info" value="Edit">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>

        <script src="${pageContext.request.contextPath}/js/manager.js" type="text/javascript"></script>
    </body>
</html>
