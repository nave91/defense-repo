/* David Leonard, 2002. Public domain. */
/* $Id: tcp.h 1201 2008-03-21 22:26:04Z d $ */

void tcp_x11(struct flow *f, const char *data, const char *end);
void tcp_http(struct flow *f, const char *data, const char *end, int toserver);
void tcp_sup(struct flow *f, const char *data, const char *end, int isclient);
void tcp_smtp(struct flow *f, const char *data, const char *end, int toserver);
