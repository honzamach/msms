# Make coding more python3-ish
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import datetime


def _to_datetime(ts, format="%Y-%m-%d"):
    if isinstance(ts, datetime.datetime):
        return ts
    if isinstance(ts, datetime.date):
        return datetime.datetime.combine(ts, datetime.datetime.min.time())
    return datetime.datetime.strptime(ts, format)

def delta_days(ts, format="%Y-%m-%d"):
    timestamp = _to_datetime(ts, format)
    curr = datetime.datetime.now()
    if timestamp > curr:
        return (timestamp-curr).days
    return '-%d' % (curr-timestamp).days

def delta_days_abs(ts, format="%Y-%m-%d"):
    timestamp = _to_datetime(ts, format)
    curr = datetime.datetime.now()
    if timestamp > curr:
        return (timestamp-curr).days
    return (curr-timestamp).days

def date_in_past(ts, format="%Y-%m-%d"):
    timestamp = _to_datetime(ts, format)
    curr = datetime.datetime.now()
    return timestamp < curr

def date_in_future(ts, format="%Y-%m-%d"):
    timestamp = _to_datetime(ts, format)
    curr = datetime.datetime.now()
    return timestamp > curr

def print_if(when, what):
    if when:
        return what
    return ''

def enclose_with_if(what, condition, with_what):
    if condition:
        return '%s%s%s' % (with_what, what, with_what)
    return what

class FilterModule(object):
    ''' Ansible core jinja2 filters '''

    def filters(self):
        return {
            # jinja2 overrides
            'delta_days': delta_days,
            'delta_days_abs': delta_days_abs,
            'date_in_past': date_in_past,
            'date_in_future': date_in_future,
            'print_if': print_if,
            'enclose_with_if': enclose_with_if,
        }
