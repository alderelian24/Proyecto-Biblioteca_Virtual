<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.Statement" %>

<%
// Manejar añadir libro
String titulo = request.getParameter("titulo");
String descripcion = request.getParameter("descripcion");
String imagen = request.getParameter("imagen");
List<String[]> librosAñadidos = (List<String[]>) session.getAttribute("librosAñadidos");

if (librosAñadidos == null) {
    librosAñadidos = new ArrayList<>();
}

if (titulo != null && descripcion != null) {
    if (imagen == null || imagen.isEmpty()) {
        imagen = "default_image.jpg"; // URL de la imagen por defecto
    }
    librosAñadidos.add(new String[] { titulo, descripcion, imagen });
    session.setAttribute("librosAñadidos", librosAñadidos);
}

// Manejar quitar libro
String quitarIndex = request.getParameter("quitarIndex");

if (quitarIndex != null) {
    int index = Integer.parseInt(quitarIndex);
    if (index >= 0 && index < librosAñadidos.size()) {
        librosAñadidos.remove(index);
        session.setAttribute("librosAñadidos", librosAñadidos);
    }
}

// Manejar realizar pedido
String realizarPedido = request.getParameter("realizarPedido");

if ("true".equals(realizarPedido) && !librosAñadidos.isEmpty()) {
	String sucursal = request.getParameter("sucursal");
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String user = "ALDER";
    String password = "2410";

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection conn = DriverManager.getConnection(url, user, password);

        String sql = "INSERT INTO pedidos (id, titulo, descripcion, imagen, sucursal, fecha_prestamo, fecha_devolucion) VALUES (secuencia_libros.NEXTVAL, ?, ?, ?, ?, SYSDATE, SYSDATE + 90)";
        PreparedStatement stmt = conn.prepareStatement(sql);

        for (String[] libro : librosAñadidos) {
            stmt.setString(1, libro[0]);
            stmt.setString(2, libro[1]);
            stmt.setString(3, libro[2]);
            stmt.setString(4, sucursal);
            stmt.addBatch();
        }

        stmt.executeBatch();
        conn.close();
        session.removeAttribute("librosAñadidos");
        
        // Redirigir a la página de historial
        response.sendRedirect("HistorialPrestamo.jsp");
        return;
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error al realizar el pedido.");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Préstamo - Libre Praesto</title>
    <link rel="stylesheet" type="text/css" href="CSS/normalize.css">
    <link rel="stylesheet" type="text/css" href="CSS/estilo.css">
</head>
<body>
	<!-- Encabezado -->
    <header>
        <div class="logo_menu">
            <img src="Imagenes/Logo.png" alt="Libre Praesto Logo">
        </div>
        <nav>
            <ul>
                <li><a href="Inicio.html">Inicio</a></li>
                <li><a href="PrestamoLibro.jsp">Prestamo de libros</a></li>
                <li><a href="HistorialPrestamo.jsp">Historial de libros</a></li>
                <li><a href="Contactenos.html">Soporte</a></li>
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

 <!-- Contenido principal -->
    <section>
        <h2 id="Título_ListaAñadidos">Lista de Añadidos</h2>
        <main>
		
		<!-- arreglo para poder enlistar los libros seleccionados -->
            <% if (librosAñadidos != null && !librosAñadidos.isEmpty()) { %>
                <% for (int i = 0; i < librosAñadidos.size(); i++) {
                    String[] libro = librosAñadidos.get(i);
                    String imagenLibro = libro.length > 2 ? libro[2] : "default_image.jpg";
                %>
                <article class="cuadrado_PrestamoLibro flex flex--row">
                    <img class="Portada_PrestamoLibro" src="<%= imagenLibro %>" alt="Portada del libro">
                    <div class="Contenido_PrestamoLibro">
                        <h3 class="Título-Libro_PrestamoLibro"><%= libro[0] %></h3>
                        <p><%= libro[1] %></p>
                    </div>
                    <form class="formulario--input" method="post">
                        <input type="hidden" name="quitarIndex" value="<%= i %>">    
                        <button class="button_PrestamoLibro" type="submit">Quitar</button>
                    </form>
                </article>
                <% } %> 
                <form method="post">  
	                <article class="cuadrado_PrestamoLibro flex flex--row">
	                    <div id="Leyenda">
	                        <p>Seleccione la sede mas cercana o al que prefiera recoger su reserva</p>
	                    </div>
	
	                    <div class="select--sucursal">
	                        <select name="sucursal" required>
	                            <option value="">Sucursal</option>
	                            <option value="Sede Central">Sede Central</option>
	                            <option  value="Sede Este">Sede Este</option>
	                            <option value="Sede Oeste">Sede Oeste</option>
	                        </select>
	                    </div>
	                </article>
	
	                <article class="cuadrado_RealizarPedido flex flex--row">
	                    <div id="Leyenda">
	                        <p>Recuerde devolver los libros dentro del limite de la fecha de devolución</p>
	                    </div>
	                    <form method="post">                        
	                    <input type="hidden" name="realizarPedido" value="true">    
	                    <button class="button_PrestamoLibro">Realizar Pedido</button>
	                    </form>
	                </article> 
                </form>   
            <% } else { %>
                <p>No hay libros añadidos.</p>
            <% } %>
        </main>
    </section>
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