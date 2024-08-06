<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registro de Estudiantes</title>
    <link rel="stylesheet" href="estilo.css">
</head>
<body>
<%
String nombre = request.getParameter("nombre");
String apellido = request.getParameter("apellido");
String email = request.getParameter("correo");
String contraseña = request.getParameter("password");
String telefono = request.getParameter("telefono");
String dia = request.getParameter("dia");
String mes = request.getParameter("mes");
String año = request.getParameter("ano");

// comprobar que los datos se esten obteniendo
System.out.println("Nombre: " + nombre);
System.out.println("Apellido: " + apellido);
System.out.println("Correo: " + email);
System.out.println("Telefono: " + telefono);
System.out.println("Dia: " + dia);
System.out.println("Mes: " + mes);
System.out.println("Año: " + año);

String fechanac = null;

if (dia != null && mes != null && año != null && !dia.isEmpty() && !mes.isEmpty() && !año.isEmpty()) {
    fechanac = String.format("%s-%s-%s", año, mes, dia);
}

String mensaje = "";

// Verificar que los campos requeridos no sean nulos ni vacíos
if (nombre == null || apellido == null || email == null || contraseña == null || telefono == null ||
    nombre.isEmpty() || apellido.isEmpty() || email.isEmpty() || contraseña.isEmpty() || telefono.isEmpty() || fechanac == null) {
    mensaje = "Por favor, complete todos los campos requeridos.";
} else {
    Connection conn = null;
    PreparedStatement ps = null;

    try {
        // Cargar el driver de Oracle
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // Establecer la conexión
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ALDER", "2410");

        // Preparar la consulta SQL
        ps = conn.prepareStatement("INSERT INTO usuario_registro (usu_id, usu_nombre, usu_apellido, usu_correo, usu_contasena, usu_telefono, usu_fecha_nacimiento) VALUES (usuario_registro_seq.NEXTVAL, ?, ?, ?, ?, ?, ?)");
        ps.setString(1, nombre);
        ps.setString(2, apellido);
        ps.setString(3, email);
        ps.setString(4, contraseña); // Asegúrate de agregar la contraseña aquí
        ps.setString(5, telefono);
        ps.setString(6, fechanac);

        // Ejecutar la consulta
        int x = ps.executeUpdate();
        if (x != 0) {
            response.sendRedirect("login.html"); // Redirige a la página de login
            return; 
        } else {
            mensaje = "Algo salió mal";
        }
    } catch (Exception e) {
        mensaje = "Error: " + e.getMessage();
    } finally {
        // Cerrar recursos
        try { if (ps != null) ps.close(); } catch (SQLException e) { /* Ignorar */ }
        try { if (conn != null) conn.close(); } catch (SQLException e) { /* Ignorar */ }
    }

    System.out.println("Datos recibidos: ");
    System.out.println("Nombre: " + nombre);
    System.out.println("Apellido: " + apellido);
    System.out.println("Correo: " + email);
    System.out.println("Telefono: " + telefono);
    System.out.println("Fecha de nacimiento: " + fechanac);
}

%>

<% if (!mensaje.isEmpty()) { %>
    <p style="color: red;"><%= mensaje %></p>
<% } %>
