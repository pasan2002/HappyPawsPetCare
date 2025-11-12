package com.happypaws.petcare.servlet.payment;

public final class RedirectAction implements NextAction {
    private final String url;

    public RedirectAction(String url) { this.url = url; }

    public String url() { return url; }
}

