/* -*- mode: c; c-file-style: "openbsd" -*- */
/* TODO:5002 You may want to change the copyright of all files. This is the
 * TODO:5002 ISC license. Choose another one if you want.
 */
/*
 * Copyright (c) 2014 Erik Hugne <erik.hugne@gmail.com>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "kdev.h"

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <getopt.h>

extern const char *__progname;

static void
usage(void)
{
	/* TODO:3002 Don't forget to update the usage block with the most
	 * TODO:3002 important options. */
	fprintf(stderr, "Usage: %s [OPTIONS]\n",
	    __progname);
	fprintf(stderr, "Version: %s\n", PACKAGE_STRING);
	fprintf(stderr, "\n");
	fprintf(stderr, " -d, --debug        be more verbose.\n");
	fprintf(stderr, " -h, --help         display help and exit\n");
	fprintf(stderr, " -v, --version      print version and exit\n");
	fprintf(stderr, "\n");
	fprintf(stderr, "see manual page " PACKAGE "(8) for more information\n");
}

int
main(int argc, char *argv[])
{
	int debug = 1;
	int ch;

	/* TODO:3001 If you want to add more options, add them here. */
	static struct option long_options[] = {
                { "debug", no_argument, 0, 'd' },
                { "help",  no_argument, 0, 'h' },
                { "version", no_argument, 0, 'v' },
		{ 0 }
	};
	while (1) {
		int option_index = 0;
		ch = getopt_long(argc, argv, "hvdD:",
		    long_options, &option_index);
		if (ch == -1) break;
		switch (ch) {
		case 'h':
			usage();
			exit(0);
			break;
		case 'v':
			fprintf(stdout, "%s\n", PACKAGE_VERSION);
			exit(0);
			break;
		case 'd':
			debug++;
			break;
		case 'D':
			log_accept(optarg);
			break;
		default:
			fprintf(stderr, "unknown option `%c'\n", ch);
			usage();
			exit(1);
		}
	}

	log_init(debug, __progname);

	/* TODO:3000 It's time for you program to do something. Add anything
	 * TODO:3000 you want here. */
	log_info("main", "hello world!");
	log_warnx("main", "your program does nothing");

	return EXIT_SUCCESS;
}
