package com.br.project.matchjob.repository;


import com.br.project.matchjob.model.Cidade;
import com.br.project.matchjob.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import javax.websocket.server.PathParam;
import java.util.List;

public interface CidadeRepository extends JpaRepository<Cidade, Long> {

    List<Cidade> findByEstadoId(@Param("id") Long id);
}
