FROM rust:1.51 as builder

RUN USER=root cargo new --bin xra
WORKDIR ./xra
COPY ./Cargo.lock ./Cargo.toml ./
RUN cargo build --release
RUN rm src/*.rs
COPY ./src ./src
RUN rm ./target/release/deps/xra*
RUN cargo build --release

FROM ubuntu:20.04

RUN apt update && apt install -y libssl-dev

COPY --from=builder /xra/target/release/xra .
EXPOSE 8080
ENTRYPOINT ["./xra"]