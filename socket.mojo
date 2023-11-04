from sys.intrinsics import external_call
from memory.memory import stack_allocation

alias c_int = Int32
alias c_void = UInt8
alias c_char = UInt8
alias sa_family_t = UInt16
alias port_t = UInt16
alias socklen_t = UInt16
alias size_t = UInt64
alias ssize_t = Int64
alias in_addr_t = UInt32


struct Domain:
    alias AF_UNIX: Int = 1
    alias AF_LOCAL: Int = 1
    alias AF_INET: Int = 2
    alias AF_INET6: Int = 10


struct Type:
    alias SOCK_STREAM: Int = 1
    alias SOCK_DGRAM: Int = 2
    alias SOCK_SEQPACKET: Int = 5


# Unix Socket
@value
@register_passable("trivial")
struct sockaddr_un:
    var sa_family: sa_family_t
    var sun_path: StaticTuple[108, UInt8]


@value
@register_passable("trivial")
struct in_addr:
    var s_addr: in_addr_t


# IP6 Socket
@value
@register_passable("trivial")
struct in6_addr:
    var s6_addr: StaticTuple[16, UInt8]


@value
@register_passable("trivial")
struct sockaddr_in6:
    var sin6_family: sa_family_t
    var sin6_port: port_t
    var sin6_flowinfo: UInt32
    var sin6_addr: in6_addr
    var sin6_scope_id: UInt32


# Generic Socket Address
@value
@register_passable("trivial")
struct sockaddr:
    var sa_family: sa_family_t
    var sa_data: StaticTuple[14, UInt8]


@always_inline
fn htonl(hostlong: UInt32) -> UInt32:
    return external_call["htonl", UInt32](hostlong)


@always_inline
fn htons(hostshort: UInt16) -> UInt16:
    return external_call["htons", UInt16](hostshort)


@always_inline
fn ntohl(netlong: UInt32) -> UInt32:
    return external_call["netlong", UInt32](netlong)


@always_inline
fn ntohs(netshort: UInt16) -> UInt16:
    return external_call["ntohs", UInt16](netshort)


@always_inline
fn inet_aton(cp: Pointer[UInt8], inp: Pointer[in_addr]) -> c_int:
    return external_call["inet_aton", c_int](cp, inp)


@always_inline
fn inet_addr(cp: Pointer[c_char]) -> in_addr_t:
    return external_call["inet_addr", in_addr_t](cp)


@always_inline
fn inet_network(cp: Pointer[c_char]) -> in_addr_t:
    return external_call["inet_network", in_addr_t](cp)


@always_inline
fn inet_ntoa(_in: in_addr) -> Pointer[c_char]:
    return external_call["inet_ntoa", Pointer[c_char]](_in)


@always_inline
fn inet_makeaddr(net: in_addr_t, host: in_addr_t) -> in_addr:
    return external_call["inet_makeaddr", in_addr](net, host)


@always_inline
fn inet_lnaof(_in: in_addr) -> in_addr_t:
    return external_call["inet_lnaof", in_addr_t](_in)


@always_inline
fn inet_netof(_in: in_addr) -> in_addr_t:
    return external_call["inet_netof", in_addr_t](_in)


@always_inline
fn inet_pton(af: c_int, src: Pointer[UInt8], dst: Pointer[UInt8]) -> c_int:
    return external_call["inet_pton", c_int](af, src, dst)


@always_inline
fn socket(domain: c_int, type: c_int, protocol: c_int) -> c_int:
    return external_call["socket", c_int](domain, type, protocol)


@always_inline
fn remove(pathname: Pointer[UInt8]) -> c_int:
    return external_call["remove", c_int](pathname)


@always_inline
fn socketpair(
    domain: c_int, type: c_int, protocol: c_int, inout sv: StaticTuple[2, c_int]
) -> c_int:
    return external_call["socketpair", c_int](
        domain, type, protocol, Pointer.address_of(sv[0])
    )


@always_inline
fn bind(sockfd: c_int, addr: Pointer[sockaddr], addrlen: socklen_t) -> c_int:
    return external_call["bind", c_int](sockfd, addr, addrlen)


@always_inline
fn listen(sockfd: c_int, backlog: c_int) -> c_int:
    return external_call["listen", c_int](sockfd, backlog)


@always_inline
fn accept(sockfd: c_int, addr: Pointer[sockaddr], addrlen: Pointer[socklen_t]) -> c_int:
    return external_call["accept", c_int](sockfd, addr, addrlen)


@always_inline
fn connect(sockfd: c_int, addr: Pointer[sockaddr], addrlen: socklen_t) -> c_int:
    return external_call["connect", c_int](sockfd, addr, addrlen)


@always_inline
fn getsockname(
    sockfd: c_int, addr: Pointer[sockaddr], addrlen: Pointer[socklen_t]
) -> c_int:
    return external_call["getsockname", c_int](sockfd, addr, addrlen)


@always_inline
fn close(fd: c_int) -> c_int:
    return external_call["close", c_int](fd)


@always_inline
fn recv(sockfd: c_int, buf: Pointer[c_void], len: size_t, flags: c_int) -> c_int:
    return external_call["recv", c_int](sockfd, buf, len, flags)


@always_inline
fn read(fd: c_int, buf: Pointer[c_void], count: size_t) -> ssize_t:
    return external_call["read", ssize_t](fd, buf, count)


@always_inline
fn send(sockfd: c_int, buf: Pointer[c_void], len: size_t, flags: c_int) -> ssize_t:
    return external_call["send", ssize_t](sockfd, buf, len, flags)


@value
@register_passable("trivial")
struct iovec:
    var iov_base: Pointer[c_void]
    var iov_len: size_t


@value
@register_passable("trivial")
struct msghdr:
    var msg_name: Pointer[c_void]
    var msg_namelen: socklen_t
    var msg_iov: Pointer[iovec]
    var msg_iovlen: size_t
    var msg_control: Pointer[c_void]
    var msg_controllen: size_t
    var msg_flags: c_int


@always_inline
fn sendmsg(sockfd: c_int, msg: Pointer[msghdr], flags: c_int) -> ssize_t:
    return external_call["sendmsg", ssize_t](sockfd, msg, flags)
