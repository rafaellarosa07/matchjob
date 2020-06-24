
package com.br.project.matchjob.util;

import org.modelmapper.ModelMapper;

public abstract class ConvertModelToDTO {

    private ModelMapper mapper;

    protected ConvertModelToDTO() {
        mapper = new ModelMapper();

    }

    protected <O, T> T toModel(O dto, Class<T> clazz) {
        return mapper.map(dto, clazz);
    }

    protected <O, T> T toDTO(O model, Class<T> clazz) {
        return mapper.map(model, clazz);
    }

}
