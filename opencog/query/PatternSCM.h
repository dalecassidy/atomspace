/*
 * PatternSCM.h
 *
 * Simplified wrapper for creating guile modules.
 * Copyright (c) 2008, 2014, 2015 Linas Vepstas <linas@linas.org>
 */

#ifndef _OPENCOG_PATTERN_SCM_H
#define _OPENCOG_PATTERN_SCM_H

#include <opencog/guile/SchemeModule.h>

namespace opencog {

class PatternSCM : public ModuleWrap
{
	protected:
		virtual void init(void);
		static std::vector<FunctionWrap*> _binders;
		Handle find_approximate_match(Handle);
		bool value_is_type(Handle, Handle);
		bool type_match(Handle, Handle);
		Handle type_compose(Handle, Handle);
	public:
		PatternSCM(void);
		~PatternSCM();
};

}

extern "C" {
void opencog_query_init(void);
};

#endif // _OPENCOG_PATTERN_SCM_H
