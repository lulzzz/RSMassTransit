﻿/*
    Copyright (C) 2018 Jeffrey Sharp

    Permission to use, copy, modify, and distribute this software for any
    purpose with or without fee is hereby granted, provided that the above
    copyright notice and this permission notice appear in all copies.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Security;

// General Information
[assembly: AssemblyTitle       ("Sharp.Logging")]
[assembly: AssemblyDescription ("Micro-framework for logging via the .NET TraceSource API")]
[assembly: AssemblyProduct     ("Sharp.Logging")]
[assembly: AssemblyCompany     ("Jeffrey Sharp")]
[assembly: AssemblyCopyright   ("Copyright 2018 Jeffrey Sharp")]
[assembly: AssemblyVersion     ("0.0.0")]

// Compliance
[assembly: ComVisible(false)]

// Security
[assembly: SecurityRules(SecurityRuleSet.Level2)]
[assembly: InternalsVisibleTo("Sharp.Logging.Tests")]
[assembly: InternalsVisibleTo("DynamicProxyGenAssembly2")]
                            // ^^^^^^^^^^^^^^^^^^^^^^^^
                            // Required for Moq to mock a class with an internal abstract method.

// Configuration
#if DEBUG
    [assembly: AssemblyConfiguration("Debug")]
#else
    [assembly: AssemblyConfiguration("Release")]
#endif
