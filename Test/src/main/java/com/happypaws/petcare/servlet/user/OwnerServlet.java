package com.happypaws.petcare.servlet.user;

import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Owner;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.Collections;
import java.util.List;

@WebServlet("/owner")
public class OwnerServlet extends HttpServlet {
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        try {
            List<Owner> owners = OwnerDAO.getAll();
            mapper.writeValue(res.getOutputStream(), owners);
        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(),
                    Collections.singletonMap("error", e.getMessage()));
        }
    }
}



