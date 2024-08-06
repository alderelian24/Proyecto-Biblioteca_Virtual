<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial - Libre Praesto</title>
    <link rel="stylesheet" type="text/css" href="CSS/normalize.css">
    <link rel="stylesheet" type="text/css" href="CSS/estilo.css">
</head>

<body>
    <header>
        <div class="logo_menu">
            <img src="Imagenes/Logo.png" alt="Libre Praesto Logo">
        </div>
        
        <!-- Menú de navegación -->
        <nav>
            <ul>
                <li><a href="Inicio.html">Inicio</a></li>
                <li><a href="PrestamoLibro.jsp">Prestamo de libros</a></li>
                <li><a href="HistorialPrestamo.jsp">Historial de libros</a></li>
                <li><a href="Contactenos.html">Soporte</a></li>
                 <!-- Íconos de búsqueda y redes sociales -->
                <li>
                    <a href="https://www.google.com" class="search-icon">
                        <img src="Imagenes/ic_search.png" alt="Buscar" class="icon ic_buscar">
                    </a>
                </li>
                <li>
                    <a href="https://www.instagram.com" class="search-icon">
                        <img src="Imagenes/ic_instagram.png" alt="Instagram" class="icon">
                    </a>
                </li>
                    <a href="https://www.facebook.com" class="search-icon">
                        <img src="Imagenes/ic_facebook.png" alt="Facebook" class="icon ic_face">
                    </a>
                <li>
                    <a href="Catalogo.html" class="btn-pedir-libro">Catálogo</a>
                </li>
            </ul>
        </nav>
    </header>

    <!-- Sección principal con el historial de préstamos -->
    <main>
        <section>
            <h1 id="Título-Historial--Prestamo">HISTORIAL DE PRESTAMOS</h1>
            <div class="table-container">
                <div id="cuadrado--Leyenda">
                    <p id="Subtitulo--Leyenda">¡Prepárate para recordar todos los mundos que has visitado!</p>
                </div>

                <!-- Tabla que muestra el historial de préstamos -->
                <table>
                    <thead>
                        <tr>
                            <th>Codigo de reserva</th>
                            <th>Libro</th>
                            <th>Descripción</th>
                            <th>Sucursal</th>
                            <th>Fecha del prestamo</th>
                            <th>Fecha de devolución</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Código Java para conectar a la base de datos y obtener los datos del historial -->
                        <%
                        String url = "jdbc:oracle:thin:@localhost:1521:xe";
                        String user = "ALDER";
                        String password = "2410";
                        Connection conn = null;

                        try {
                            Class.forName("oracle.jdbc.driver.OracleDriver");
                            conn = DriverManager.getConnection(url, user, password);

                            String sql = "SELECT id, titulo, descripcion, sucursal, fecha_prestamo, fecha_devolucion FROM pedidos";
                            PreparedStatement stmt = conn.prepareStatement(sql);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {
                                String id = rs.getString("id");
                                String titulo = rs.getString("titulo");
                                String descripcion = rs.getString("descripcion");
                                String sucursal = rs.getString("sucursal");
                                String fechaPrestamo = rs.getString("fecha_prestamo");
                                String fechaDevolucion = rs.getString("fecha_devolucion");
                        %>
                        <!-- Fila de la tabla con los datos de cada préstamo -->
                        <tr>
                            <td>#<%= id %></td>
                            <td><%= titulo %></td>
                            <td><%= descripcion %></td>
                            <td><%= sucursal %></td>
                            <td><%= fechaPrestamo %></td>
                            <td><%= fechaDevolucion %></td>
                        </tr>
                        <% 
                            }
                            conn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
    <!-- Sección del pie de página -->

    <footer>
        <div class="logo_footer">
            <img src="Imagenes/Logo.png" alt="Libre Praesto Logo">
        </div>
        <nav id="PiePag">
            <ul id="Submenu">
                <li class="LinkSubmenu"><a href="Inicio.html">Inicio</a></li>
                <li class="LinkSubmenu"><a href="PrestamoLibro.jsp">Pedir Libros</a></li>
                <li class="LinkSubmenu"><a href="HistorialPrestamo.jsp">Historial de Prestamos</a></li>
                <li class="LinkSubmenu"><a href="Contactenos.html">Soporte</a></li>
            </ul>
            <a href="login.html" class="logout-link">Logout</a>
            <p id="copyright">© 2024 Libre Praesto. Todos los derechos reservados.</p>
        </nav>
    </footer>
</body>
</html>
