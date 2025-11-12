package com.happypaws.petcare.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Pet {
    private Integer petId;
    private String petUid;
    private Integer ownerId;
    private String name;
    private String species;
    private String breed;
    private LocalDate dob;
    private String sex;
    private String microchipNo;
    private LocalDateTime createdAt;

    // Additional fields for search/display purposes (not stored in pets table)
    private String ownerName;
    private String ownerPhone;

    public Integer getPetId() { return petId; }
    public void setPetId(Integer petId) { this.petId = petId; }

    public String getPetUid() { return petUid; }
    public void setPetUid(String petUid) { this.petUid = petUid; }

    public Integer getOwnerId() { return ownerId; }
    public void setOwnerId(Integer ownerId) { this.ownerId = ownerId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSpecies() { return species; }
    public void setSpecies(String species) { this.species = species; }

    public String getBreed() { return breed; }
    public void setBreed(String breed) { this.breed = breed; }

    public LocalDate getDob() { return dob; }
    public void setDob(LocalDate dob) { this.dob = dob; }

    public String getSex() { return sex; }
    public void setSex(String sex) { this.sex = sex; }

    public String getMicrochipNo() { return microchipNo; }
    public void setMicrochipNo(String microchipNo) { this.microchipNo = microchipNo; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    // Additional fields for search/display purposes
    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getOwnerPhone() { return ownerPhone; }
    public void setOwnerPhone(String ownerPhone) { this.ownerPhone = ownerPhone; }
}


