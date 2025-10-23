package tema2.ejercicio1;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.BufferedReader;

public class Ejercicio1 {
	public static void main(String[] args) {

		String directorioArchivo;

		String fichero = "src\\tema2\\ejercicio1\\carpetas.txt";

		String directorio = "C:\\Users\\diego.fernandez\\";

		String cadena;

		try {

			BufferedReader bReader = new BufferedReader(new FileReader(fichero));

			cadena = bReader.readLine();
			directorioArchivo="";
			
			while (cadena != null) {
				directorioArchivo = directorio + cadena;

				System.out.println(directorioArchivo);
				
				File d1 = new File(directorioArchivo);

				if (!d1.exists()) {
					d1.mkdir();
					System.out.println("Carpeta creada correctamente");
				}else {
					System.out.println("La carpeta ya existe");
				}
				cadena = bReader.readLine();

			}

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
