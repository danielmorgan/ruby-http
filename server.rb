#!/usr/bin/env ruby

require 'socket'

def main
    socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
    addr = Socket.pack_sockaddr_in(9012, '0.0.0.0')
    socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
    socket.bind(addr)
    socket.listen(1)

    loop do
        connection, addr_info = socket.accept
        request = connection.recv(4096)

        request.each_line do |line|
            if line.include? 'foo='
                key, _, value = line.partition('=')
                STDOUT.puts "#{key}: #{value}"
            end
        end

        content = "Hello world";
        response = "HTTP/1.1 200 OK\r\nContent-Length: #{content.length}\r\n\r\n#{content}"

        connection.send(response, 0)
        connection.close
    end
end

main
