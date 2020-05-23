package com.br.project.matchjob.repository;


import com.br.project.matchjob.model.Vaga;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface VagaRepository extends JpaRepository<Vaga, Long> {

    List<Vaga> findByIdUsuario(Long id);

}
