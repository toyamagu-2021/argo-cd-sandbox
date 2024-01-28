# OpenTelemetry with Datadog

## やりたいこと

* DatadogのAgentを使わずに、OpenTelemetryのControllerを使ってDatadogにトレースを送信したい

### できたこと

OpenTelemetry Controllerを通して、DataDogに以下送信することができた [Ref](https://docs.datadoghq.com/ja/opentelemetry/otel_collector_datadog_exporter/?tab=%E3%83%9B%E3%82%B9%E3%83%88%E4%B8%8A)。

* Host Metricsの送信
  * CPU, Mem, Disk, Networkなど
* Container関連のMetricsの送信
* Prometheus Metricsの送信
  * ArgoCDのメトリクスなど送信できた
* ログの送信
* OpenTelemetry Tracingの送信
  * ArgoCDのTracingを送信できた

### できなかったこと

* `dd-trace-go` を利用してOpenTelemetryにトレースを送信すること
  * `dd-trace-go` を利用している限り、DatadogのAgentを利用する必要がある
  * [ddtrace/opentelemetry](https://docs.datadoghq.com/ja/tracing/trace_collection/custom_instrumentation/otel_instrumentation/go) はあくまでもOpenTelemetryのAPIを利用できるだけっぽい。
    * 送信はDatadog Agentを用いて行うみたい
  * `sample-app` が失敗作のゴミ
