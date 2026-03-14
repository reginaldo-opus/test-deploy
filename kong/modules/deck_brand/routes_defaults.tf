# ============================================================================
# Default route definitions — extracted from the original Kong Terraform modules
# ============================================================================

locals {
  default_routes_status = [
        {
        name   = "status-v2"
        method = "GET"
        path   = "~/open-banking/discovery/v2/status$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.1"
        feature = "core"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "outages-v2"
        method = "GET"
        path   = "~/open-banking/discovery/v2/outages$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.1"
        feature = "core"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "metrics-v2"
        method = "GET"
        path   = "~/open-banking/admin/v2/metrics$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.1"
        feature = "core"
        block_before_date = "2023-11-17"
        block_from_date = "none"
        has_operational_limits = false
    }
  ]

  default_routes_status_maintenance = [
    {
        name   = "failure-type-v1"
        method = "GET"
        path   = "~/open-banking/outages-maintenance/v1/domains/failure-type$"
        scopes = [["oob_outages:read"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "endpoints-v1"
        method = "GET"
        path   = "~/open-banking/outages-maintenance/v1/endpoints$"
        scopes = [["oob_outages:read"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "outages-v1"
        method = "GET"
        path   = "~/open-banking/outages-maintenance/v1/outages$"
        scopes = [["oob_outages:read"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "outages-v1"
        method = "POST"
        path   = "~/open-banking/outages-maintenance/v1/outages$"
        scopes = [["oob_outages:write"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "outages-id-v1"
        method = "GET"
        path   = "~/open-banking/outages-maintenance/v1/outages/[0-9a-fA-F-]+$"
        scopes = [["oob_outages:read"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "outages-v1"
        method = "PUT"
        path   = "~/open-banking/outages-maintenance/v1/outages/[0-9a-fA-F-]+$"
        scopes = [["oob_outages:write"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "outages-v1"
        method = "DELETE"
        path   = "~/open-banking/outages-maintenance/v1/outages/[0-9a-fA-F-]+$"
        scopes = [["oob_outages:write"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "failures-v1"
        method = "GET"
        path   = "~/open-banking/outages-maintenance/v1/failures$"
        scopes = [["oob_outages:read"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "failures-id-v1"
        method = "GET"
        path   = "~/open-banking/outages-maintenance/v1/failures/[0-9a-fA-F-]+$"
        scopes = [["oob_outages:read"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "failures-v1"
        method = "PUT"
        path   = "~/open-banking/outages-maintenance/v1/failures/[0-9a-fA-F-]+$"
        scopes = [["oob_outages:write"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "services-v1"
        method = "GET"
        path   = "~/open-banking/outages-maintenance/v1/services$"
        scopes = [["oob_outages:read"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    }
  ]

  default_routes_consent_payment = [
    {
        name   = "payments-consents-id-v3"
        method = "GET"
        path   = "~/open-banking/payments/v3/consents/[0-9a-zA-Z-:]+$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "3.0.0"
        feature = "payments"
        block_before_date = "2023-10-13"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    },
    {
        name   = "payments-consents-id-v4"
        method = "GET"
        path   = "~/open-banking/payments/v4/consents/[0-9a-zA-Z-:]+$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "4.0.1"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2026-08-21"
        has_operational_limits = false
    },
    {
        name   = "payments-consents-id-v5"
        method = "GET"
        path   = "~/open-banking/payments/v5/consents/[0-9a-zA-Z-:]+$"
        scopes = [["payments"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "5.0.0"
        feature = "payments"
        block_before_date = "2026-05-21"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payments-consents-id-payments-v5"
        method = "GET"
        path   = "~/open-banking/payments/v5/consents/[0-9a-zA-Z-:]+/pix/payments$"
        scopes = [["payments"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "5.0.0"
        feature = "payments"
        block_before_date = "2026-05-21"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payments-consents-v3"
        method = "POST"
        path   = "~/open-banking/payments/v3/consents$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "3.0.0"
        feature = "payments"
        block_before_date = "2023-10-13"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    },
    {
        name   = "payments-consents-v4"
        method = "POST"
        path   = "~/open-banking/payments/v4/consents$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "4.0.1"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2026-08-21"
        has_operational_limits = false
    },
    {
        name   = "payments-consents-v5"
        method = "POST"
        path   = "~/open-banking/payments/v5/consents$"
        scopes = [["payments"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "5.0.0"
        feature = "payments"
        block_before_date = "2026-05-21"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "enrollments-v2"
        method = "POST"
        path   = "~/open-banking/enrollments/v2/enrollments$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "enrollments"
        block_before_date = "2024-11-14"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "enrollments-v2-enrollment-id"
        method = "GET"
        path   = "~/open-banking/enrollments/v2/enrollments/[0-9a-zA-Z-:]+$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "enrollments"
        block_before_date = "2024-11-14"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "enrollments-v2-enrollment-id-risk-signals"
        method = "POST"
        path   = "~/open-banking/enrollments/v2/enrollments/[0-9a-zA-Z-:]+/risk-signals$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "enrollments"
        block_before_date = "2024-11-14"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "enrollments-v2-enrollment-id"
        method = "PATCH"
        path   = "~/open-banking/enrollments/v2/enrollments/[0-9a-zA-Z-:]+$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "enrollments"
        block_before_date = "2024-11-14"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "enrollments-v2-enrollment-id-fido-registration-options"
        method = "POST"
        path   = "~/open-banking/enrollments/v2/enrollments/[0-9a-zA-Z-:]+/fido-registration-options$"
        scopes = [["payments", "enrollment:"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "enrollments"
        block_before_date = "2024-11-14"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "enrollments-v2-enrollment-id-fido-registration"
        method = "POST"
        path   = "~/open-banking/enrollments/v2/enrollments/[0-9a-zA-Z-:]+/fido-registration$"
        scopes = [["payments", "enrollment:"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "enrollments"
        block_before_date = "2024-11-14"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "enrollments-v2-enrollment-id-fido-sign-options"
        method = "POST"
        path   = "~/open-banking/enrollments/v2/enrollments/[0-9a-zA-Z-:]+/fido-sign-options$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "enrollments"
        block_before_date = "2024-11-14"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "enrollments-v2-consent-id-authorise"
        method = "POST"
        path   = "~/open-banking/enrollments/v2/consents/[0-9a-zA-Z-:]+/authorise$"
        scopes = [["nrp-consents", "payments", "enrollment:"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "enrollments"
        block_before_date = "2024-11-14"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "enrollments-v2-recurring-consent-id-authorise"
        method = "POST"
        path   = "~/open-banking/enrollments/v2/recurring-consents/[0-9a-zA-Z-:]+/authorise$"
        scopes = [["nrp-consents", "recurring-payments", "enrollment:"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "enrollments"
        block_before_date = "2026-02-06"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-recurring-consents-v1"
        method = "POST"
        path   = "~/open-banking/automatic-payments/v1/recurring-consents$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2025-06-15"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-recurring-consents-id-v1"
        method = "GET"
        path   = "~/open-banking/automatic-payments/v1/recurring-consents/[0-9a-zA-Z-:]+$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2025-06-15"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-recurring-consents-id-v1"
        method = "PATCH"
        path   = "~/open-banking/automatic-payments/v1/recurring-consents/[0-9a-zA-Z-:]+$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2025-06-15"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-recurring-consents-v2"
        method = "POST"
        path   = "~/open-banking/automatic-payments/v2/recurring-consents$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "payments"
        block_before_date = "2025-04-22"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-recurring-consents-id-v2"
        method = "GET"
        path   = "~/open-banking/automatic-payments/v2/recurring-consents/[0-9a-zA-Z-:]+$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "payments"
        block_before_date = "2025-04-22"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-recurring-consents-id-v2"
        method = "PATCH"
        path   = "~/open-banking/automatic-payments/v2/recurring-consents/[0-9a-zA-Z-:]+$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "payments"
        block_before_date = "2025-04-22"
        block_from_date = "none"
        has_operational_limits = false
    }
  ]

  default_routes_consent_data_sharing_v2 = [
    {
        name   = "resources-v2"
        method = "GET"
        path   = "~/open-banking/resources/v2/resources$"
        scopes = [["resources", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    },
    {
        name   = "consents-v2"
        method = "POST"
        path   = "~/open-banking/consents/v2/consents$"
        scopes = [["consents"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JSON"
        response_format = "JSON"
        api_version = "2.0.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    },
    {
        name   = "consents-id-v2"
        method = "DELETE"
        path   = "~/open-banking/consents/v2/consents/[0-9a-zA-Z-:]+$"
        scopes = [["consents"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    },
    {
        name   = "consents-id-v2"
        method = "GET"
        path   = "~/open-banking/consents/v2/consents/[0-9a-zA-Z-:]+$"
        scopes = [["consents"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    },
    {
        name   = "consents-id-extends-v2"
        method = "POST"
        path   = "~/open-banking/consents/v2/consents/[0-9a-zA-Z-:]+/extends$"
        scopes = [["openid", "consent:"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.0"
        feature = "financial-data"
        block_before_date = "2023-11-13"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    },
    {
        name   = "consents-id-extends-v2"
        method = "GET"
        path   = "~/open-banking/consents/v2/consents/[0-9a-zA-Z-:]+/extends$"
        scopes = [["consents"]]
        must_report_pcm = false
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.0"
        feature = "financial-data"
        block_before_date = "2023-11-13"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    }
  ]

  default_routes_consent_data_sharing_v3 = [
    {
        name   = "resources-v3"
        method = "GET"
        path   = "~/open-banking/resources/v3/resources$"
        scopes = [["resources", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "3.1.0"
        feature = "financial-data"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "consents-v3"
        method = "POST"
        path   = "~/open-banking/consents/v3/consents$"
        scopes = [["consents"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JSON"
        response_format = "JSON"
        api_version = "3.3.1"
        feature = "financial-data"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "consents-id-v3"
        method = "GET"
        path   = "~/open-banking/consents/v3/consents/[0-9a-zA-Z-:]+$"
        scopes = [["consents"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "3.3.1"
        feature = "financial-data"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "consents-id-v3"
        method = "DELETE"
        path   = "~/open-banking/consents/v3/consents/[0-9a-zA-Z-:]+$"
        scopes = [["consents"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "3.3.1"
        feature = "financial-data"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "consents-id-extends-v3"
        method = "POST"
        path   = "~/open-banking/consents/v3/consents/[0-9a-zA-Z-:]+/extends$"
        scopes = [["openid", "consent:"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JSON"
        response_format = "JSON"
        api_version = "3.3.1"
        feature = "financial-data"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "consents-id-extensions-v3"
        method = "GET"
        path   = "~/open-banking/consents/v3/consents/[0-9a-zA-Z-:]+/extensions$"
        scopes = [["consents"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "3.3.1"
        feature = "financial-data"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = false
    }
  ]

  default_routes_consent_credit_portability = [
    {
        name   = "payroll-credit-portability-account-data-v1"
        method = "GET"
        path   = "~/open-banking/payroll-credit-portability/v1/portabilities/[0-9a-zA-Z-:]+/account-data$"
        scopes = [["payroll-credit-portability"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2026-08-03"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "credit-portability-account-data-v1"
        method = "GET"
        path   = "~/open-banking/credit-portability/v1/portabilities/[0-9a-zA-Z-:]+/account-data$"
        scopes = [["credit-portability"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payroll-credit-portability-credit-operations-contract-id-portability-eligibility-v1"
        method = "GET"
        path   = "~/open-banking/payroll-credit-portability/v1/credit-operations/[0-9a-zA-Z-:]+/portability-eligibility$"
        scopes = [["openid", "consent:", "loans"]]
        must_report_pcm = false
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2026-08-03"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "credit-portability-credit-operations-contract-id-portability-eligibility-v1"
        method = "GET"
        path   = "~/open-banking/credit-portability/v1/credit-operations/[0-9a-zA-Z-:]+/portability-eligibility$"
        scopes = [["openid", "consent:", "loans"]]
        must_report_pcm = false
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "credit-portability-portabilities-v1"
        method = "POST"
        path   = "~/open-banking/credit-portability/v1/portabilities$"
        scopes = [["openid", "consent:", "loans"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payroll-credit-portability-portabilities-v1"
        method = "POST"
        path   = "~/open-banking/payroll-credit-portability/v1/portabilities$"
        scopes = [["openid", "consent:", "loans"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2026-08-03"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "credit-portability-portabilities-portability-id-v1"
        method = "GET"
        path   = "~/open-banking/credit-portability/v1/portabilities/[0-9a-zA-Z-:]+$"
        scopes = [["credit-portability"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payroll-credit-portability-portabilities-portability-id-v1"
        method = "GET"
        path   = "~/open-banking/payroll-credit-portability/v1/portabilities/[0-9a-zA-Z-:]+$"
        scopes = [["payroll-credit-portability"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2026-08-03"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "credit-portability-portabilities-portability-id-cancel-v1"
        method = "PATCH"
        path   = "~/open-banking/credit-portability/v1/portabilities/[0-9a-zA-Z-:]+/cancel$"
        scopes = [["credit-portability"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "credit-portability-portabilities-portability-id-payment-v1"
        method = "POST"
        path   = "~/open-banking/credit-portability/v1/portabilities/[0-9a-zA-Z-:]+/payment$"
        scopes = [["credit-portability"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payroll-credit-portability-portabilities-portability-id-payment-reversal-v1"
        method = "POST"
        path   = "~/open-banking/payroll-credit-portability/v1/portabilities/[0-9a-zA-Z-:]+/payment-reversal$"
        scopes = [["payroll-credit-portability"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2026-08-03"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payroll-credit-portability-portabilities-portability-id-payment-v1"
        method = "POST"
        path   = "~/open-banking/payroll-credit-portability/v1/portabilities/[0-9a-zA-Z-:]+/payment$"
        scopes = [["payroll-credit-portability"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2026-08-03"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payroll-credit-portability-portabilities-portability-id-cancel-v1"
        method = "PATCH"
        path   = "~/open-banking/payroll-credit-portability/v1/portabilities/[0-9a-zA-Z-:]+/cancel$"
        scopes = [["payroll-credit-portability"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2026-08-03"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payroll-credit-portability-portabilities-portability-id-credit-operations-registering-entity-v1"
        method = "GET"
        path   = "~/open-banking/payroll-credit-portability/v1/credit-operations/[0-9a-zA-Z-:]+/registering-entity$"
        scopes = [["payroll-credit-portability"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2026-08-03"
        block_from_date = "none"
        has_operational_limits = false
    }
  ]

  default_routes_consent_oob = [
    {
        name   = "oob-consents-domains-permission-v1"
        method = "GET"
        path   = "~/open-banking/oob-consents/v1/domains/permission$"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-domains-consent-type-v1"
        method = "GET"
        path   = "~/open-banking/oob-consents/v1/domains/consent-type$"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-domains-consent-status-v1"
        method = "GET"
        path   = "~/open-banking/oob-consents/v1/domains/consent-status$"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-id-v1"
        method = "GET"
        path   = "~/open-banking/oob-consents/v1/consents/[0-9a-zA-Z-:]+$"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-id-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-consents/v1/consents/[0-9a-zA-Z-:]+$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-consents-id-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-consents/consents/v1/consents/[0-9a-zA-Z-:]+$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-consents-v2-active"
        method = "GET"
        path   = "~/open-banking/oob-consents/consents/v2/active$"
        scopes = [["oob_consents:read"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-v1"
        method = "GET"
        path   = "~/open-banking/oob-consents/v1/consents$"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-payments-status-notification-v1"
        method = "POST"
        path   = "~/open-banking/oob-consents/v1/payment-status-notification$"
        scopes = [["oob_payments:write"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-tpps-payment-legacy-ids-v1"
        method = "GET"
        path   = "~/open-banking/oob-consents/v1/tpps/payment-legacy-ids$"
        scopes = [["oob_consents:read"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-id-extends-v1"
        method = "GET"
        path   = "~/open-banking/oob-consents/v1/consents/[0-9a-zA-Z-:]+/extends$"
        scopes = [["oob_consents:read"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-payments-consents-id-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-consents/payments/v1/consents/[0-9a-zA-Z-:]+$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-enrollments-enrollment-id-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-consents/enrollments/v1/enrollments/[0-9a-zA-Z-:]+$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },

    {
        name   = "oob-consents-enrollments-enrollment-id-edit-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-consents/enrollments/v1/enrollments/[0-9a-zA-Z-:]+/edit$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-id-payments-v1"
        method = "GET"
        path   = "~/open-banking/oob-consents/consents/v1/consents/[0-9a-zA-Z-:]+/payments$"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-search-key-v1"
        method = "POST"
        path = "~/open-banking/oob-consents/consents/v1/consents/[0-9a-zA-Z-:]+/search-key/.+$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-get-search-keys-v1"
        method = "GET"
        path = "~/open-banking/oob-consents/consents/v1/consents/[0-9a-zA-Z-:]+/search-keys"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-get-search-key-v1"
        method = "GET"
        path = "~/open-banking/oob-consents/consents/v1/consents/[0-9a-zA-Z-:]+/search-key/.+$"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-search-keys-v1"
        method = "POST"
        path = "~/open-banking/oob-consents/consents/v1/consents/[0-9a-zA-Z-:]+/search-keys"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-reources-translations-v1"
        method = "GET"
        path = "~/open-banking/oob-consents/v1/consents/[0-9a-zA-Z-:]+/resources/translation"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-search-key-v1"
        method = "DELETE",
        path = "~/open-banking/oob-consents/consents/v1/consents/[0-9a-zA-Z-:]+/search-key/.+$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-search-keys-v1"
        method = "DELETE",
        path = "~/open-banking/oob-consents/consents/v1/consents/[0-9a-zA-Z-:]+/search-keys"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-meta-data-v1"
        method = "GET"
        path = "~/open-banking/oob-consents/v1/consents/[0-9a-zA-Z-:]+/meta-data$"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-meta-data-v1"
        method = "PUT"
        path = "~/open-banking/oob-consents/v1/consents/[0-9a-zA-Z-:]+/meta-data$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-meta-data-v1"
        method = "PATCH"
        path = "~/open-banking/oob-consents/v1/consents/[0-9a-zA-Z-:]+/meta-data$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name = "oob-consents-id-meta-data-v1"
        method = "DELETE"
        path = "~/open-banking/oob-consents/v1/consents/[0-9a-zA-Z-:]+/meta-data$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-payments-consents-id-authorisation-v1"
        method = "POST"
        path   = "~/open-banking/oob-consents/v1/payments/consents/[0-9a-zA-Z-:]+/authorisation$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-automatic-payments-recurring-consents-id-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-consents/automatic-payments/v1/recurring-consents/[0-9a-zA-Z-:]+$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-portabilities-portability-id-status-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-consents/v1/portabilities/[0-9a-zA-Z-:]+/status$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "2025-10-06"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-resources-notification-v1"
        method = "POST"
        path   = "~/open-banking/oob-consents/v1/resources-notification$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-webhook-toggle-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-consents/v1/webhook/toggle/[0-9a-zA-Z-:]+$"
        scopes = [["oob_consents:write"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-consents-webhook-status-v1"
        method = "GET"
        path   = "~/open-banking/oob-consents/v1/webhook/status/[0-9a-zA-Z-:]+$"
        scopes = [["oob_consents:read"], ["oob_customer"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    }
  ]

  default_routes_consent_as = [
    {
        name   = "oob-internal-consents-domains-permission-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/domains/permission$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-payments-id-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/payments/[0-9a-zA-Z-:]$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-domains-resource-type-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/domains/resource-type$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-basic-info-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+/basic-info$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-information-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+/information$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-v1"
        method = "PUT"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consent-id-payments-v1"
        method = "PUT"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+/payments$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "payments"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-v1"
        method = "DELETE"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-discovery-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+/discovery$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-discovery-v1"
        method = "PUT"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+/discovery$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-legacy-id-v1"
        method = "PUT"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+/legacy-ids$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-openbanking-id-type-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+/open-banking-ids/[0-9A-Z]+/type/[a-zA-Z]+$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-revoke-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+/revoke$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JWT"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-retrieve-payment-payload-payment-id-v1"
        method = "POST"
        path   = "~/open-banking/oob-internal-consents/v1/consents/retrieve-payment-payload/[0-9a-zA-Z-:]+$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-consume-v1"
        method = "POST"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+/consume$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-cancellation-v1"
        method = "POST"
        path   = "~/consents/[0-9a-zA-Z-:]+/cancellation$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-tpps-v1"
        method = "PUT"
        path   = "~/open-banking/oob-internal-consents/v1/tpps/[0-9a-zA-Z-:_]+$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-tpps-v1"
        method = "DELETE"
        path   = "~/open-banking/oob-internal-consents/v1/tpps/[0-9a-zA-Z-:_]+$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-tpps-id-payments-id-v1"
        method = "GET"
        path   = "/open-banking/oob-internal-consents/v1/tpps/[0-9a-zA-Z_:-]/payments/[0-9a-zA-Z_:-]$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-tpps-id-consents-id-payments-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/tpps/[0-9a-zA-Z_:-]/consents/[0-9a-zA-Z_:-]/payments$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-payments-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z_:-]/payments$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-consume-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/tpps/[0-9a-zA-Z_:-]+/open-banking-ids/[0-9a-zA-Z_:-]+/type/[a-zA-Z]+/consent$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-domains-purpose-v1"
        method = "GET"
        path   = "~/open-banking/oob-internal-consents/v1/domains/purpose$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-id-v1"
        method = "PATCH"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "oob-internal-consents-consents-payments-id-v1"
        method = "DELETE"
        path   = "~/open-banking/oob-internal-consents/v1/consents/[0-9a-zA-Z-:]+/idempotency-key/[0-9a-zA-Z-:]+/payment$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    }
  ]

  default_routes_financial_data = [
    {
        name   = "credit-cards-accounts-v2"
        method = "GET"
        path   = "~/open-banking/credit-cards-accounts/v2/accounts$"
        scopes = [["credit-cards-accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.3.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-cards-account-id-v2"
        method = "GET"
        path   = "~/open-banking/credit-cards-accounts/v2/accounts/[0-9a-zA-Z-]+$"
        scopes = [["credit-cards-accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.3.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-cards-account-id-bills-v2"
        method = "GET"
        path   = "~/open-banking/credit-cards-accounts/v2/accounts/[0-9a-zA-Z-]+/bills$"
        scopes = [["credit-cards-accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.3.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-cards-account-id-bill-id-transactions-v2"
        method = "GET"
        path   = "~/open-banking/credit-cards-accounts/v2/accounts/[0-9a-zA-Z-]+/bills/[0-9a-zA-Z-]+/transactions$"
        scopes = [["credit-cards-accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.3.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-cards-account-id-limits-v2"
        method = "GET"
        path   = "~/open-banking/credit-cards-accounts/v2/accounts/[0-9a-zA-Z-]+/limits$"
        scopes = [["credit-cards-accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.3.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-cards-account-id-transactions-v2"
        method = "GET"
        path   = "~/open-banking/credit-cards-accounts/v2/accounts/[0-9a-zA-Z-]+/transactions$"
        scopes = [["credit-cards-accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.3.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-cards-account-id-transactions-current-v2"
        method = "GET"
        path   = "~/open-banking/credit-cards-accounts/v2/accounts/[0-9a-zA-Z-]+/transactions-current$"
        scopes = [["credit-cards-accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.3.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "customers-business-identifications-v2"
        method = "GET"
        path   = "~/open-banking/customers/v2/business/identifications$"
        scopes = [["customers", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "customers-business-financial-relations-v2"
        method = "GET"
        path   = "~/open-banking/customers/v2/business/financial-relations$"
        scopes = [["customers", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "customers-business-qualifications-v2"
        method = "GET"
        path   = "~/open-banking/customers/v2/business/qualifications$"
        scopes = [["customers", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "customers-personal-identifications-v2"
        method = "GET"
        path   = "~/open-banking/customers/v2/personal/identifications$"
        scopes = [["customers", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "customers-personal-financial-relations-v2"
        method = "GET"
        path   = "~/open-banking/customers/v2/personal/financial-relations$"
        scopes = [["customers", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "customers-personal-qualifications-v2"
        method = "GET"
        path   = "~/open-banking/customers/v2/personal/qualifications$"
        scopes = [["customers", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.1"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "accounts-accounts-v2"
        method = "GET"
        path   = "~/open-banking/accounts/v2/accounts$"
        scopes = [["accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "accounts-account-id-v2"
        method = "GET"
        path   = "~/open-banking/accounts/v2/accounts/[0-9a-zA-Z-]+$"
        scopes = [["accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "accounts-account-id-overdraft-limits-v2"
        method = "GET"
        path   = "~/open-banking/accounts/v2/accounts/[0-9a-zA-Z-]+/overdraft-limits$"
        scopes = [["accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "accounts-account-id-balances-v2"
        method = "GET"
        path   = "~/open-banking/accounts/v2/accounts/[0-9a-zA-Z-]+/balances$"
        scopes = [["accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "accounts-account-id-transactions-v2"
        method = "GET"
        path   = "~/open-banking/accounts/v2/accounts/[0-9a-zA-Z-]+/transactions$"
        scopes = [["accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "accounts-account-id-transactions-current-v2"
        method = "GET"
        path   = "~/open-banking/accounts/v2/accounts/[0-9a-zA-Z-]+/transactions-current$"
        scopes = [["accounts", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "financings-contracts-v2"
        method = "GET"
        path   = "~/open-banking/financings/v2/contracts$"
        scopes = [["financings", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "financings-contract-id-v2"
        method = "GET"
        path   = "~/open-banking/financings/v2/contracts/[0-9a-zA-Z-]+$"
        scopes = [["financings", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "financings-contract-id-payments-v2"
        method = "GET"
        path   = "~/open-banking/financings/v2/contracts/[0-9a-zA-Z-]+/payments$"
        scopes = [["financings", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "financings-contract-id-scheduled-instalments-v2"
        method = "GET"
        path   = "~/open-banking/financings/v2/contracts/[0-9a-zA-Z-]+/scheduled-instalments$"
        scopes = [["financings", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "financings-contract-id-warranties-v2"
        method = "GET"
        path   = "~/open-banking/financings/v2/contracts/[0-9a-zA-Z-]+/warranties$"
        scopes = [["financings", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "loans-contracts-v2"
        method = "GET"
        path   = "~/open-banking/loans/v2/contracts$"
        scopes = [["loans", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "loans-contract-id-v2"
        method = "GET"
        path   = "~/open-banking/loans/v2/contracts/[0-9a-zA-Z-]+$"
        scopes = [["loans", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "loans-contract-id-payments-v2"
        method = "GET"
        path   = "~/open-banking/loans/v2/contracts/[0-9a-zA-Z-]+/payments$"
        scopes = [["loans", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "loans-contract-id-scheduled-instalments-v2"
        method = "GET"
        path   = "~/open-banking/loans/v2/contracts/[0-9a-zA-Z-]+/scheduled-instalments$"
        scopes = [["loans", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "loans-contract-id-warranties-v2"
        method = "GET"
        path   = "~/open-banking/loans/v2/contracts/[0-9a-zA-Z-]+/warranties$"
        scopes = [["loans", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.2.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "unarranged-accounts-overdraft-contracts-v2"
        method = "GET"
        path   = "~/open-banking/unarranged-accounts-overdraft/v2/contracts$"
        scopes = [["unarranged-accounts-overdraft", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.5.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "unarranged-accounts-overdraft-contract-id-v2"
        method = "GET"
        path   = "~/open-banking/unarranged-accounts-overdraft/v2/contracts/[0-9a-zA-Z-]+$"
        scopes = [["unarranged-accounts-overdraft", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.5.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "unarranged-accounts-overdraft-contract-id-payments-v2"
        method = "GET"
        path   = "~/open-banking/unarranged-accounts-overdraft/v2/contracts/[0-9a-zA-Z-]+/payments$"
        scopes = [["unarranged-accounts-overdraft", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.5.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "unarranged-accounts-overdraft-contract-id-scheduled-instalments-v2"
        method = "GET"
        path   = "~/open-banking/unarranged-accounts-overdraft/v2/contracts/[0-9a-zA-Z-]+/scheduled-instalments$"
        scopes = [["unarranged-accounts-overdraft", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.5.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "unarranged-accounts-overdraft-contract-id-warranties-v2"
        method = "GET"
        path   = "~/open-banking/unarranged-accounts-overdraft/v2/contracts/[0-9a-zA-Z-]+/warranties$"
        scopes = [["unarranged-accounts-overdraft", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.5.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "invoice-financings-contracts-v2"
        method = "GET"
        path   = "~/open-banking/invoice-financings/v2/contracts$"
        scopes = [["invoice-financings", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "invoice-financings-contract-id-v2"
        method = "GET"
        path   = "~/open-banking/invoice-financings/v2/contracts/[0-9a-zA-Z-]+$"
        scopes = [["invoice-financings", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "invoice-financings-contract-id-payments-v2"
        method = "GET"
        path   = "~/open-banking/invoice-financings/v2/contracts/[0-9a-zA-Z-]+/payments$"
        scopes = [["invoice-financings", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "invoice-financings-contract-id-scheduled-instalments-v2"
        method = "GET"
        path   = "~/open-banking/invoice-financings/v2/contracts/[0-9a-zA-Z-]+/scheduled-instalments$"
        scopes = [["invoice-financings", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "invoice-financings-contract-id-warranties-v2"
        method = "GET"
        path   = "~/open-banking/invoice-financings/v2/contracts/[0-9a-zA-Z-]+/warranties$"
        scopes = [["invoice-financings", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "2.4.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },  
    {
        name   = "bank-fixed-incomes-investments-v1"
        method = "GET"
        path   = "~/open-banking/bank-fixed-incomes/v1/investments$"
        scopes = [["bank-fixed-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "bank-fixed-incomes-investments-investment-id-v1"
        method = "GET"
        path   = "~/open-banking/bank-fixed-incomes/v1/investments/[0-9a-zA-Z-]+$"
        scopes = [["bank-fixed-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "bank-fixed-incomes-investments-investment-id-balances-v1"
        method = "GET"
        path   = "~/open-banking/bank-fixed-incomes/v1/investments/[0-9a-zA-Z-]+/balances$"
        scopes = [["bank-fixed-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "bank-fixed-incomes-investments-investment-id-transactions-v1"
        method = "GET"
        path   = "~/open-banking/bank-fixed-incomes/v1/investments/[0-9a-zA-Z-]+/transactions$"
        scopes = [["bank-fixed-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "bank-fixed-incomes-investments-investment-id-transactions-current-v1"
        method = "GET"
        path   = "~/open-banking/bank-fixed-incomes/v1/investments/[0-9a-zA-Z-]+/transactions-current$"
        scopes = [["bank-fixed-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-fixed-incomes-investments-v1"
        method = "GET"
        path   = "~/open-banking/credit-fixed-incomes/v1/investments$"
        scopes = [["credit-fixed-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-fixed-incomes-investments-investment-id-v1"
        method = "GET"
        path   = "~/open-banking/credit-fixed-incomes/v1/investments/[0-9a-zA-Z-]+$"
        scopes = [["credit-fixed-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-fixed-incomes-investments-investment-id-balances-v1"
        method = "GET"
        path   = "~/open-banking/credit-fixed-incomes/v1/investments/[0-9a-zA-Z-]+/balances$"
        scopes = [["credit-fixed-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-fixed-incomes-investments-investment-id-transactions-v1"
        method = "GET"
        path   = "~/open-banking/credit-fixed-incomes/v1/investments/[0-9a-zA-Z-]+/transactions$"
        scopes = [["credit-fixed-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "credit-fixed-incomes-investments-investment-id-transactions-current-v1"
        method = "GET"
        path   = "~/open-banking/credit-fixed-incomes/v1/investments/[0-9a-zA-Z-]+/transactions-current$"
        scopes = [["credit-fixed-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "variable-incomes-investments-v1"
        method = "GET"
        path   = "~/open-banking/variable-incomes/v1/investments$"
        scopes = [["variable-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.3.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "variable-incomes-investments-investment-id-v1"
        method = "GET"
        path   = "~/open-banking/variable-incomes/v1/investments/[0-9a-zA-Z-]+$"
        scopes = [["variable-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.3.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "variable-incomes-investments-investment-id-balances-v1"
        method = "GET"
        path   = "~/open-banking/variable-incomes/v1/investments/[0-9a-zA-Z-]+/balances$"
        scopes = [["variable-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.3.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "variable-incomes-investments-investment-id-transactions-v1"
        method = "GET"
        path   = "~/open-banking/variable-incomes/v1/investments/[0-9a-zA-Z-]+/transactions$"
        scopes = [["variable-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.3.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "variable-incomes-investments-investment-id-transactions-current-v1"
        method = "GET"
        path   = "~/open-banking/variable-incomes/v1/investments/[0-9a-zA-Z-]+/transactions-current$"
        scopes = [["variable-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.3.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "variable-incomes-broker-notes-broker-note-id-v1"
        method = "GET"
        path   = "~/open-banking/variable-incomes/v1/broker-notes/[0-9a-zA-Z-]+$"
        scopes = [["variable-incomes", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.3.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
        {
        name   = "treasure-titles-investments-v1"
        method = "GET"
        path   = "~/open-banking/treasure-titles/v1/investments$"
        scopes = [["treasure-titles", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "treasure-titles-investments-investment-id-v1"
        method = "GET"
        path   = "~/open-banking/treasure-titles/v1/investments/[0-9a-zA-Z-]+$"
        scopes = [["treasure-titles", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "treasure-titles-investments-investment-id-balances-v1"
        method = "GET"
        path   = "~/open-banking/treasure-titles/v1/investments/[0-9a-zA-Z-]+/balances$"
        scopes = [["treasure-titles", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "treasure-titles-investments-investment-id-transactions-v1"
        method = "GET"
        path   = "~/open-banking/treasure-titles/v1/investments/[0-9a-zA-Z-]+/transactions$"
        scopes = [["treasure-titles", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "treasure-titles-investments-investment-id-transactions-current-v1"
        method = "GET"
        path   = "~/open-banking/treasure-titles/v1/investments/[0-9a-zA-Z-]+/transactions-current$"
        scopes = [["treasure-titles", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "2023-09-29"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "funds-investments-v1"
        method = "GET"
        path   = "~/open-banking/funds/v1/investments$"
        scopes = [["funds", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "funds-investments-investment-id-v1"
        method = "GET"
        path   = "~/open-banking/funds/v1/investments/[0-9a-zA-Z-]+$"
        scopes = [["funds", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "funds-investments-investment-id-balances-v1"
        method = "GET"
        path   = "~/open-banking/funds/v1/investments/[0-9a-zA-Z-]+/balances$"
        scopes = [["funds", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "funds-investments-investment-id-transactions-v1"
        method = "GET"
        path   = "~/open-banking/funds/v1/investments/[0-9a-zA-Z-]+/transactions$"
        scopes = [["funds", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name   = "funds-investments-investment-id-transactions-current-v1"
        method = "GET"
        path   = "~/open-banking/funds/v1/investments/[0-9a-zA-Z-]+/transactions-current$"
        scopes = [["funds", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.1.0"
        feature = "financial-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name    = "exchanges-operations-v1"
        method  = "GET"
        path    = "~/open-banking/exchanges/v1/operations$"
        scopes = [["exchanges", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name    = "exchanges-operations-id-v1"
        method  = "GET"
        path    = "~/open-banking/exchanges/v1/operations/[0-9a-zA-Z-]+$"
        scopes  = [["exchanges", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = true
    },
    {
        name    = "exchanges-operations-id-events-v1"
        method  = "GET"
        path    = "~/open-banking/exchanges/v1/operations/[0-9a-zA-Z-]+/events$"
        scopes  = [["exchanges", "consent:"]]
        must_report_pcm = true
        must_report_mqd = true
        must_log_request_response = true
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "financial-data"
        block_before_date = "2024-04-15"
        block_from_date = "none"
        has_operational_limits = true
    }
  ]

  default_routes_payment = [       
    {
        name   = "payments-pix-v3"
        method = "POST"
        path   = "~/open-banking/payments/v3/pix/payments$"
        scopes = [["payments", "consent:"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "3.0.0"
        feature = "payments",
        block_before_date = "2023-10-13"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-pix-v1"
        method = "POST"
        path   = "~/open-banking/automatic-payments/v1/pix/recurring-payments$"
        scopes = [["recurring-payments", "recurring-consent:"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2025-06-15"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-pix-v1"
        method = "GET"
        path   = "~/open-banking/automatic-payments/v1/pix/recurring-payments$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2025-06-15"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-pix-id-v1"
        method = "GET"
        path   = "~/open-banking/automatic-payments/v1/pix/recurring-payments/[0-9a-zA-Z-]+$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2025-06-15"
        has_operational_limits = false
    },
    {
        name   = "payments-pix-payment-id-v3"
        method = "PATCH"
        path   = "~/open-banking/payments/v3/pix/payments/[0-9a-zA-Z-]+$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "3.0.0"
        feature = "payments"
        block_before_date = "2023-10-13"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    },
    {
        name   = "payments-pix-payment-id-v3"
        method = "GET"
        path   = "~/open-banking/payments/v3/pix/payments/[0-9a-zA-Z-]+$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "3.0.0"
        feature = "payments"
        block_before_date = "2023-10-13"
        block_from_date = "2024-07-16"
        has_operational_limits = false
    },
    {
        name   = "payments-pix-payment-id-v4"
        method = "GET"
        path   = "~/open-banking/payments/v4/pix/payments/[0-9a-zA-Z-]+$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "4.0.1"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2026-08-21"
        has_operational_limits = false
    },
    {
        name   = "payments-pix-v4"
        method = "POST"
        path   = "~/open-banking/payments/v4/pix/payments$"
        scopes = [["enrollment:", "payments", "nrp-consents"], ["consent:", "payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "4.0.1"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2026-08-21"
        has_operational_limits = false
    },
    {
        name   = "payments-pix-payment-id-v4"
        method = "PATCH"
        path   = "~/open-banking/payments/v4/pix/payments/[0-9a-zA-Z-]+$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "4.0.1"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2026-08-21"
        has_operational_limits = false
    },
    {
        name   = "payments-pix-consents-consent-id-v4"
        method = "PATCH"
        path   = "~/open-banking/payments/v4/pix/payments/consents/[0-9a-zA-Z-:]+$"
        scopes = [["payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "4.0.1"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2026-08-21"
        has_operational_limits = false
    },
    {
        name   = "payments-pix-payment-id-v5"
        method = "GET"
        path   = "~/open-banking/payments/v5/pix/payments/[0-9a-zA-Z-]+$"
        scopes = [["payments"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "5.0.0"
        feature = "payments"
        block_before_date = "2026-05-21"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payments-pix-v5"
        method = "POST"
        path   = "~/open-banking/payments/v5/pix/payments$"
        scopes = [["enrollment:", "payments", "nrp-consents"], ["consent:", "payments"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "5.0.0"
        feature = "payments"
        block_before_date = "2026-05-21"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payments-pix-payment-id-v5"
        method = "PATCH"
        path   = "~/open-banking/payments/v5/pix/payments/[0-9a-zA-Z-]+$"
        scopes = [["payments"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "5.0.0"
        feature = "payments"
        block_before_date = "2026-05-21"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "payments-pix-consents-consent-id-v5"
        method = "PATCH"
        path   = "~/open-banking/payments/v5/consents/[0-9a-zA-Z-:]+/pix/payments$"
        scopes = [["payments"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "5.0.0"
        feature = "payments"
        block_before_date = "2026-05-21"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-pix-id-v1"
        method = "PATCH"
        path   = "~/open-banking/automatic-payments/v1/pix/recurring-payments/[0-9a-zA-Z-]+$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "1.0.0"
        feature = "payments"
        block_before_date = "2024-04-29"
        block_from_date = "2025-06-15"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-pix-v2"
        method = "POST"
        path   = "~/open-banking/automatic-payments/v2/pix/recurring-payments$"
        scopes = [["enrollment:", "recurring-payments", "nrp-consents"], ["recurring-consent:", "recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "payments"
        block_before_date = "2025-04-22"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-pix-id-retry-v2"
        method = "POST"
        path   = "~/open-banking/automatic-payments/v2/pix/recurring-payments/[0-9a-zA-Z-]+/retry$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "payments"
        block_before_date = "2025-04-22"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-pix-v2"
        method = "GET"
        path   = "~/open-banking/automatic-payments/v2/pix/recurring-payments$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "payments"
        block_before_date = "2025-04-22"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-pix-id-v2"
        method = "GET"
        path   = "~/open-banking/automatic-payments/v2/pix/recurring-payments/[0-9a-zA-Z-]+$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "none"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "payments"
        block_before_date = "2025-04-22"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "automatic-payments-pix-id-v2"
        method = "PATCH"
        path   = "~/open-banking/automatic-payments/v2/pix/recurring-payments/[0-9a-zA-Z-]+$"
        scopes = [["recurring-payments"]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = true
        request_format = "JWT"
        response_format = "JWT"
        api_version = "2.2.0"
        feature = "payments"
        block_before_date = "2025-04-22"
        block_from_date = "none"
        has_operational_limits = false
    }
  ]

  default_routes_payment_oob = [
      {
        name   = "oob-payments-id-v2"
        method = "PATCH"
        path   = "~/open-banking/oob-payments/v2/pix/payments/[0-9a-zA-Z-:]+$"
        scopes = [["oob_payments:write"]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "payments"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
      }
  ]

  default_routes_payment_as = [
    {
        name   = "oob-internal-payments-pix-v2"
        method = "POST"
        path   = "~/open-banking/oob-internal-payments/v2/pix/payments/[0-9a-zA-Z-:]+$"
        scopes = [[]]
        must_report_pcm = false
        must_report_mqd = false
        must_log_request_response = false
        request_format = "JSON"
        response_format = "JSON"
        api_version = "2.1.0"
        feature = "core"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    }
  ]

  default_routes_open_data = [
    {
        name   = "opendata-personal-accounts-v1"
        method = "GET"
        path   = "~/open-banking/opendata-accounts/v1/personal-accounts$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-business-accounts-v1"
        method = "GET"
        path   = "~/open-banking/opendata-accounts/v1/business-accounts$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-personal-loans-v1"
        method = "GET"
        path   = "~/open-banking/opendata-loans/v1/personal-loans$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-business-loans-v1"
        method = "GET"
        path   = "~/open-banking/opendata-loans/v1/business-loans$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-personal-financings-v1"
        method = "GET"
        path   = "~/open-banking/opendata-financings/v1/personal-financings$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-business-financings-v1"
        method = "GET"
        path   = "~/open-banking/opendata-financings/v1/business-financings$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-personal-invoice-financings-v1"
        method = "GET"
        path   = "~/open-banking/opendata-invoicefinancings/v1/personal-invoice-financings$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-business-invoice-financings-v1"
        method = "GET"
        path   = "~/open-banking/opendata-invoicefinancings/v1/business-invoice-financings$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-personal-credit-cards-v1"
        method = "GET"
        path   = "~/open-banking/opendata-creditcards/v1/personal-credit-cards$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-business-credit-cards-v1"
        method = "GET"
        path   = "~/open-banking/opendata-creditcards/v1/business-credit-cards$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-personal-unarranged-account-overdraft-v1"
        method = "GET"
        path   = "~/open-banking/opendata-unarranged/v1/personal-unarranged-account-overdraft$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-business-unarranged-account-overdraft-v1"
        method = "GET"
        path   = "~/open-banking/opendata-unarranged/v1/business-unarranged-account-overdraft$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-capitalization-bonds-v2"
        method = "GET"
        path   = "~/open-banking/opendata-capitalization/v2/bonds$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-investments-funds-v1"
        method = "GET"
        path   = "~/open-banking/opendata-investments/v1/funds$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-investments-bank-fixed-incomes-v1"
        method = "GET"
        path   = "~/open-banking/opendata-investments/v1/bank-fixed-incomes$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-investments-credit-fixed-incomes-v1"
        method = "GET"
        path   = "~/open-banking/opendata-investments/v1/credit-fixed-incomes$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-investments-variable-incomes-v1"
        method = "GET"
        path   = "~/open-banking/opendata-investments/v1/variable-incomes$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-investments-treasure-titles-v1"
        method = "GET"
        path   = "~/open-banking/opendata-investments/v1/treasure-titles$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-exchange-online-rates-v1"
        method = "GET"
        path   = "~/open-banking/opendata-exchange/v1/online-rates$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-exchange-vet-values-v1"
        method = "GET"
        path   = "~/open-banking/opendata-exchange/v1/vet-values$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-acquiring-services-personals-v1"
        method = "GET"
        path   = "~/open-banking/opendata-acquiring-services/v1/personals$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-acquiring-services-businesses-v1"
        method = "GET"
        path   = "~/open-banking/opendata-acquiring-services/v1/businesses$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "1.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-pension-risk-coverages-v2"
        method = "GET"
        path   = "~/open-banking/opendata-pension/v2/risk-coverages$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-pension-survival-coverages-v2"
        method = "GET"
        path   = "~/open-banking/opendata-pension/v2/survival-coverages$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "opendata-insurance-personals-v2"
        method = "GET"
        path   = "~/open-banking/opendata-insurance/v2/personals$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.0"
        feature = "open-data"
        block_before_date = "none"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "channels-branches-v2"
        method = "GET"
        path   = "~/open-banking/channels/v2/branches$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "channels-electronic-channels-v2"
        method = "GET"
        path   = "~/open-banking/channels/v2/electronic-channels$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "channels-phone-channels-v2"
        method = "GET"
        path   = "~/open-banking/channels/v2/phone-channels$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "channels-banking-agents-v2"
        method = "GET"
        path   = "~/open-banking/channels/v2/banking-agents$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    },
    {
        name   = "channels-shared-automated-teller-machines-v2"
        method = "GET"
        path   = "~/open-banking/channels/v2/shared-automated-teller-machines$"
        scopes = [[]]
        must_report_pcm = true
        must_report_mqd = false
        must_log_request_response = false
        request_format = "none"
        response_format = "JSON"
        api_version = "2.0.0"
        feature = "open-data"
        block_before_date = "2024-02-27"
        block_from_date = "none"
        has_operational_limits = false
    }
  ]

  default_routes_auth_server_fapi = [
    {
      name   = "auth-server-webhook-v1"
      method = "POST"
      path   = "~/webhook/[0-9a-zA-Z-:_]+$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-well-known"
      method = "GET"
      path   = "~/.well-known/openid-configuration$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-android-assetlinks"
      method = "GET"
      path   = "~/.well-known/assetlinks.json$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-apple-app-site-association"
      method = "GET"
      path   = "~/apple-app-site-association$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-me"
      method = "GET"
      path   = "~/me$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-jwks"
      method = "GET"
      path   = "~/jwks$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-token-introspection"
      method = "POST"
      path   = "~/token/introspection$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-token-revocation"
      method = "POST"
      path   = "~/token/revocation$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-request"
      method = "POST"
      path   = "~/request$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-auth"
      method = "GET"
      path   = "~/auth$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = true
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-auth"
      method = "POST"
      path   = "~/auth$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = true
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-session-end"
      method = "GET"
      path   = "~/session/end$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-app-commands-id"
      method = "GET"
      path   = "~/app/commands/[0-9a-zA-Z-:_]+$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-app-commands-id-authentication"
      method = "PUT"
      path   = "~/app/commands/[0-9a-zA-Z-:_]+/authentication$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-app-commands-id-consent"
      method = "PUT"
      path   = "~/app/commands/[0-9a-zA-Z-:_]+/consent$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-app-commands-id-resumeconsent"
      method = "GET"
      path   = "~/app/commands/[0-9a-zA-Z-:_]+/resumeconsent$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-app-commands-id-error"
      method = "GET"
      path   = "~/app/commands/[0-9a-zA-Z-:_]+/error$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-handoff-v1-oob-handoff.js"
      method = "GET"
      path   = "~/handoff/v1/oob-handoff.js$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-handoff-id"
      method = "GET"
      path   = "~/handoff/[^/]*$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-handoff-v1-id-status"
      method = "PUT"
      path   = "~/handoff/v1/[^/]*/status$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-handoff-v1-id-abort"
      method = "PUT"
      path   = "~/handoff/v1/[^/]*/abort$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-final-interaction-id"
      method = "GET"
      path   = "~/final-interaction/[0-9a-zA-Z-:_]+$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-session-end-confirm"
      method = "POST"
      path   = "~/session/end/confirm$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-auth-id"
      method = "GET"
      path   = "~/auth/[0-9a-zA-Z-:_]+$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
  ]

  default_routes_auth_server_fapi_mtls = [
    {
      name   = "auth-server-reg"
      method = "POST"
      path   = "~/reg$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = true
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-reg-client-id"
      method = "GET"
      path   = "~/reg/[0-9a-zA-Z-:_]+$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = true
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-reg-client-id"
      method = "PUT"
      path   = "~/reg/[0-9a-zA-Z-:_]+$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = true
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-reg-client-id"
      method = "DELETE"
      path   = "~/reg/[0-9a-zA-Z-:_]+$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = true
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-me"
      method = "GET"
      path   = "~/me$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-token"
      method = "POST"
      path   = "~/token$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = true
      request_format = "none"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-token-introspection"
      method = "POST"
      path   = "~/token/introspection$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-token-revocation"
      method = "POST"
      path   = "~/token/revocation$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-request"
      method = "POST"
      path   = "~/request$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    }
  ]

  default_routes_auth_server_non_fapi = [
    {
      name   = "well-known"
      method = "GET"
      path   = "~/.well-known/openid-configuration$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-me"
      method = "GET"
      path   = "~/me$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-jwks"
      method = "GET"
      path   = "~/jwks$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-token"
      method = "POST"
      path   = "~/token$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "none"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-token-introspection"
      method = "POST"
      path   = "~/token/introspection$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-token-revocation"
      method = "POST"
      path   = "~/token/revocation$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-request"
      method = "POST"
      path   = "~/request$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-auth"
      method = "GET"
      path   = "~/auth$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-auth"
      method = "POST"
      path   = "~/auth$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    },
    {
      name   = "auth-server-session-end"
      method = "GET"
      path   = "~/session/end$"
      scopes = [[]]
      must_report_pcm = false
      must_report_mqd = false
      must_log_request_response = false
      request_format = "JSON"
      response_format = "JSON"
      api_version = "1.0.0"
      feature = "core"
      block_before_date = "none"
      block_from_date = "none"
      has_operational_limits = false
    }
  ]

}