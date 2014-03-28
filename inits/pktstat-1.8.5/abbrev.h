/* David Leonard, 2002. Public domain. */
/* $Id: abbrev.h 1199 2008-02-29 16:11:24Z d $ */

const char *abbrev_tag(const char *);
void	abbrev_add(const char *);
void	abbrev_add_file(const char *, int);
void	abbrev_add_default_files(void);
void	abbrev_free(void);
