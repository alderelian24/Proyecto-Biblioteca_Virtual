<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
</head>
<body>
<% //Recoger los datos en la base de datos
    String correo = request.getParameter("correo");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet resultados = null;
    String mensaje = "";

    try { //Conectar a la base de datos
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ALDER", "2410");

        PreparedStatement verified = conn.prepareStatement("SELECT * FROM usuario_registro WHERE usu_correo=? AND usu_contasena=?");
        verified.setString(1, correo);
        verified.setString(2, password);

        resultados = verified.executeQuery();

        if(resultados.next()) {
            response.sendRedirect("Inicio.html"); // Redirige a la página de inicio
        } else {
            mensaje = "Algo salió mal";
        }

    } catch (Exception e) {
        mensaje = "<h1 style='color: red;'>****ERROR*** <br> " + e.getMessage() + "</h1>";
    } finally {
        if(resultados != null) try { resultados.close(); } catch (SQLException ignore) {}
        if(ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if(conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
<%= mensaje %>
</body>
</html>
