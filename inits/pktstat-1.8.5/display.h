/* David Leonard, 2002. Public domain. */
/* $Id: display.h 1199 2008-02-29 16:11:24Z d $ */

extern int keepalive;
extern int tflag;

void	display_open(const char *device, const char *filter);
void	display_close(void);
void	display_update(double period);
void	batch_update(double period);
void	display_message(const char *msg, ...);
void	display_reset(void);
