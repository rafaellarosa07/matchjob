package com.br.project.matchjob.repository;


import com.br.project.matchjob.model.Estado;
import com.br.project.matchjob.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import javax.websocket.server.PathParam;
import java.util.List;

public interface EstadoRepository extends JpaRepository<Estado, Long> {

}
