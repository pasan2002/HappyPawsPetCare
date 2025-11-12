package com.happypaws.petcare.servlet.pet;

import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.model.Pet;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/pets")
public class PetsServlet extends HttpServlet {
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        try {
            List<Pet> pets = PetDAO.getAll();
            mapper.writeValue(res.getOutputStream(), pets);
        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(),
                    Collections.singletonMap("error", e.getMessage()));
        }
    }
}



