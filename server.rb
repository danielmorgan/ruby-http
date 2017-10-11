#!/usr/bin/env ruby

require 'socket'

def main
    socket = Socket.new(:INET, :STREAM)
    socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
    socket.bind(Addrinfo.tcp("127.0.0.1", 9000))
    socket.listen(1)
    conn_sock, addr_info = socket.accept
    conn = Connection.new(conn_sock)
    respond(conn_sock, 404, "Hello world")
end

def read_request(conn)
    request_line = conn.read_line
    method, path, version = request_line.split(" ", 3)
    headers = {}
    loop do
        line = conn.read_line
        break if line.empty?
        key, value = line.split(/:\s*/, 2)
        headers[key] = value
    end
    Request.new(method, path, headers)
end

def respond(conn_sock, status_code, content)
    status_text = {
        200 => "OK",
        404 => "Not Found",
    }.fetch(status_code)
    conn_sock.send("HTTP/1.1 #{status_code} #{status_text}\r\n", 0)
    conn_sock.send("Content-Length: #{content.length}\r\n", 0)
    conn_sock.send("\r\n", 0)
    conn_sock.send(content, 0)
end

class Connection
    def initialize(conn_sock)
        @conn_sock = conn_sock
        @buffer = ""
    end

    def read_line
        read_until("\r\n");
    end

    def read_until(string)
        until @buffer.include?(string)
            @buffer += @conn_sock.recv(7)
        end
        result, @buffer = @buffer.split(string, 2)
        result
    end
end

Request = Struct.new(:method, :path, :headers)

main
