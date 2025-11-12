package com.happypaws.petcare.servlet.payment;

public final class ForwardAction implements NextAction {
    private final String jspPath;

    public ForwardAction(String jspPath) { this.jspPath = jspPath; }

    public String jspPath() { return jspPath; }
}

