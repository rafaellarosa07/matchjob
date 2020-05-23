package com.br.project.matchjob.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
+
@Service
public class PastaService {

    private static String  PATH = "/Users/douglasalmeidaqueiroz/dir/";

    public void createDirectoryVaga(Long idVaga){
        String directoryName = PATH.concat("vaga-"+idVaga);

        File directory = new File(directoryName);
        if (! directory.exists()){
            directory.mkdir();
            // If you require it to make the entire directory path including parents,
            // use directory.mkdirs(); here instead.
        }

    }

    public void createDirectoryUser(Long user){
        String directoryName = PATH.concat("user-"+user);
        File directory = new File(directoryName);
        if (! directory.exists()){
            directory.mkdir();
            // If you require it to make the entire directory path including parents,
            // use directory.mkdirs(); here instead.
        }
    }

    public void writeFiles(Long idUser, MultipartFile fileMulti){
        FileInputStream fileInputStream = null;
        try {
            File file = new File(PATH.concat("user-"+idUser)+"/" + "curriculo-" + idUser+".pdf");
            file.createNewFile();
            byte[] bFile = fileMulti.getBytes();

            //read file into bytes[]
            fileInputStream = new FileInputStream(file);
            fileInputStream.read(bFile);

            //save bytes[] into a file
            writeBytesToFile(bFile, PATH.concat("user-"+idUser)+"/" + "curriculo-" + idUser+".pdf");

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fileInputStream != null) {
                try {
                    fileInputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
    }

    public byte[] buscarFile(Long idUser){
        FileInputStream fileInputStream = null;
        try {
            File file = new File(PATH.concat("user-"+idUser)+"/" + "curriculo-" + idUser+".pdf");
            byte[] fileContent = Files.readAllBytes(file.toPath());
            return fileContent;

        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    private static void writeBytesToFile(byte[] bFile, String fileDest) {

        try (FileOutputStream fileOuputStream = new FileOutputStream(fileDest)) {
            fileOuputStream.write(bFile);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
