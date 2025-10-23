package tema2.ejercicio2;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class Ejercicio2 {
	public static void main(String[] args) {
		
		String estructura= "<html>\r\n"
				+ "   <head>\r\n"
				+ "      <title> [Nombre de la carpeta] </title>\r\n"
				+ "   </head>\r\n"
				+ "   <body>\r\n"
				+ "      <h1>[Ruta + nombre de la carpeta]</h1>\r\n"
				+ "      <h3>Autor: [nombre_del_alumno]</h3>\r\n"
				+ "   </body>\r\n"
				+ "</html>";
	
		String fichero = "src\\tema2\\ejercicio2\\carpetas.txt";

		String directorio = "C:\\Users\\diego.fernandez\\";

		String directorioArchivo;
		
		String cadena;

		try {

			BufferedReader bReader = new BufferedReader(new FileReader(fichero));
			

			cadena = bReader.readLine();
			directorioArchivo="";
			
			while (cadena != null) {
				directorioArchivo = directorio + cadena;
				
				System.out.println(directorioArchivo);
				
				escribirFichero(directorioArchivo);
				
				cadena = bReader.readLine();

			}

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
}
	
	public static void escribirFichero(String carpeta) {
		
		String carpeta2 = carpeta + "\\index.html";

		String autor = "Diego Fernandez Dominguez";
		
		String[] palabras;
		
		palabras = carpeta.split("\\\\");
		
		int longitud = palabras.length;
		
		try (BufferedWriter bWriter = new BufferedWriter(new FileWriter(carpeta2))) {


				bWriter.write("<html>\r\n"
						+ "   <head>\r\n"
						+ "      <title>" + palabras[longitud-1] + "</title>\r\n"
						+ "   </head>\r\n"
						+ "   <body>\r\n"
						+ "      <h1>" +   carpeta   +"</h1>\r\n"
						+ "      <h3>Autor: " + autor +  "</h3>\r\n"
						+ "   </body>\r\n"
						+ "</html>");

			
		} catch (IOException e) {
			System.out.println(e.getMessage());
		}

	}

	
}
