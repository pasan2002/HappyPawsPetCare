package com.happypaws.petcare.servlet.payment;

import com.happypaws.petcare.servlet.payment.ClinicPaymentStrategy;
import com.happypaws.petcare.servlet.payment.OnlinePaymentStrategy;

import java.util.Map;

public final class PaymentStrategyFactory {
    private PaymentStrategyFactory() {}

    private static final Map<String, PaymentStrategy> REGISTRY = Map.of(
            "online", new OnlinePaymentStrategy(),
            "clinic", new ClinicPaymentStrategy()
    );

    public static PaymentStrategy get(String method) {
        if (method == null) throw new IllegalArgumentException("Payment method required");
        PaymentStrategy s = REGISTRY.get(method.toLowerCase());
        if (s == null) throw new IllegalArgumentException("Unknown payment method: " + method);
        return s;
    }
}

