package main

import (
	"context"
	"log"
	"net/http"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc"
	"go.opentelemetry.io/otel/trace"
	httptrace "gopkg.in/DataDog/dd-trace-go.v1/contrib/net/http"
	ddotel "gopkg.in/DataDog/dd-trace-go.v1/ddtrace/opentelemetry"
)

var tracer trace.Tracer
var collectorAddr = "otl-controller.open-telemetry.svc.cluster.local:4317"

func newExporter(ctx context.Context) (*otlptrace.Exporter, error) {
	exporter, err :=
		otlptracegrpc.New(ctx,
			// WithInsecure lets us use http instead of https (for local dev only).
			otlptracegrpc.WithInsecure(),
			otlptracegrpc.WithEndpoint(collectorAddr),
		)

	return exporter, err
}

// func newTraceProvider(exp sdktrace.SpanExporter) *sdktrace.TracerProvider {
// 	// Ensure default SDK resources and the required service name are set.
// 	r, err := resource.Merge(
// 		resource.Default(),
// 		resource.NewWithAttributes(
// 			semconv.SchemaURL,
// 			semconv.ServiceName("ExampleService"),
// 		),
// 	)

// 	if err != nil {
// 		panic(err)
// 	}

// 	return sdktrace.NewTracerProvider(
// 		sdktrace.WithBatcher(exp),
// 		sdktrace.WithResource(r),
// 	)
// }

func main() {
	ctx := context.Background()

	_, err := newExporter(ctx)
	if err != nil {
		log.Fatalf("failed to initialize exporter: %v", err)
	}

	// Create a new tracer provider with a batch span processor and the given exporter.
	// tp := newTraceProvider(exp)
	tp := ddotel.NewTracerProvider()

	// Handle shutdown properly so nothing leaks.
	defer func() { _ = tp.Shutdown() }()

	otel.SetTracerProvider(tp)

	// Finally, set the tracer that can be used for this package.
	tracer = tp.Tracer("ExampleService")

	_, span := tracer.Start(ctx, "hello-span")
	defer span.End()

	// Create a traced mux router
	mux := httptrace.NewServeMux()
	// Continue using the router as you normally would.
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello World!"))
	})
	if err := http.ListenAndServe(":8080", mux); err != nil {
		log.Fatal(err)
	}
}
