"""Generated definition of gateway_grpc_library."""

load("//grpc-gateway:gateway_grpc_compile.bzl", "gateway_grpc_compile")
load("//internal:compile.bzl", "proto_compile_attrs")
load("@io_bazel_rules_go//go:def.bzl", "go_library")
load("//go:go_grpc_library.bzl", "GRPC_DEPS")

def gateway_grpc_library(name, **kwargs):
    # Compile protos
    name_pb = name + "_pb"
    gateway_grpc_compile(
        name = name_pb,
        prefix_path = kwargs.get("prefix_path", kwargs.get("importpath", "")),
        **{
            k: v
            for (k, v) in kwargs.items()
            if k in proto_compile_attrs.keys() and k != "prefix_path"
        }  # Forward args
    )

    # Create go library
    go_library(
        name = name,
        srcs = [name_pb],
        deps = kwargs.get("go_deps", []) + GATEWAY_DEPS + GRPC_DEPS + kwargs.get("deps", []),
        importpath = kwargs.get("importpath"),
        visibility = kwargs.get("visibility"),
        tags = kwargs.get("tags"),
    )

GATEWAY_DEPS = [
    "@org_golang_google_protobuf//proto:go_default_library",
    "@org_golang_google_grpc//grpclog:go_default_library",
    "@org_golang_google_grpc//metadata:go_default_library",
    "@grpc_ecosystem_grpc_gateway//runtime:go_default_library",
    "@grpc_ecosystem_grpc_gateway//utilities:go_default_library",
    "@go_googleapis//google/api:annotations_go_proto",
]
