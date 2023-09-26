/// websys.Conversions
Class ext.websys.Conversions Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter Base64Seq = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

Property expression As ext.websys.Expression [ Final ];

/// Base64 encode a string
ClassMethod Base64(line As %Library.String) As %Library.Status
{
	q ##class(websys.Conversions).Base64(line)
}

/// [Previously private]
ClassMethod Base64Encode(b1 As %Library.String, b2 As %Library.String, b3 As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).Base64Encode(b1, b2, b3)
}

/// A Simple BinHex converter
ClassMethod BinHexS(str As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).BinHexS(str)
}

/// Convert the vaue of an HTML check box to boolean
ClassMethod BooleanHtmlToLogical(x As %Library.String) As %Library.Boolean
{
	q ##class(websys.Conversions).BooleanHtmlToLogical(x)
}

/// Convert a stored boolean value to HTML value for a checkbox
ClassMethod BooleanLogicalToHtml(x As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).BooleanLogicalToHtml(x)
}

/// calculates the minutes passed since 'datefrom' and 'timefrom' till 'dateto' and 'timeto'
/// if 'datefrom' or 'timefrom' is blank, returns 0
/// if 'dateto' is blank, uses current date
/// if 'timeto' is blank, uses current time
ClassMethod CalculateMinutesPassed(datefrom As %Library.Date, timefrom As %Library.Time, dateto As %Library.String, timeto As %Library.String) As %Library.Integer
{
	q ##class(websys.Conversions).CalculateMinutesPassed(datefrom, timefrom, dateto, timeto)
}

ClassMethod CommonReload()
{
	d ##class(websys.Conversions).CommonReload()
}

ClassMethod CurrencyHtmlToLogical(x As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).CurrencyHtmlToLogical(x)
}

ClassMethod CurrencyLogicalToHtml(x As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).CurrencyLogicalToHtml(x)
}

/// ab 15.10.07 64959
ClassMethod FloatLogicalToHtml(x As %String) As %String
{
	q ##class(websys.Conversions).FloatLogicalToHtml(x)
}

/// Converted a cache $h format date to a crystal data format Date(yyyy,mm,dd)
ClassMethod DateLogicalToCrystal(h As %Library.String) As %String
{
	q ##class(websys.Conversions).DateLogicalToCrystal(h)
}

ClassMethod DelimitedStringToHtml(str As %Library.String, strdelim As %Library.String, htmldelim As %Library.String = "", keepblanks As %Boolean = 0)
{
	q ##class(websys.Conversions).DelimitedStringToHtml(str, strdelim,htmldelim, keepblanks)
}

ClassMethod EscapeUrl(in As %String) As %String
{
	q ##class(websys.Conversions).EscapeUrl(in)
}

ClassMethod GetCacheVersion() As %Library.String
{
	q ##class(websys.Conversions).GetCacheVersion()
}

/// Return the SQl rowid name for the class (if it is explicitly specified)
ClassMethod GetClassRowIDName(classname As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).GetClassRowIDName(classname)
}

/// Return the SQL field name for the parameter/class specified
ClassMethod GetClassParameter(classname As %Library.String, parameter As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).GetClassParameter(classname, parameter)
}

/// Get the computer name from the ip address.
ClassMethod GetComputerName(ip As %Library.String) As %Library.String
{
	Q ##class(%SYS.ProcessQuery).%OpenId($JOB).ClientNodeName
	;q ##class(websys.Conversions).GetComputerName(ip)
}

ClassMethod GetDirectoryPathSlash() As %String
{
	q ##class(websys.Conversions).GetDirectoryPathSlash()
}

/// This should be superceded by accescing the property definition but will do for now.
ClassMethod GetPropertyParameter(classname As %Library.String, property As %Library.String, parameter As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).GetPropertyParameter(classname, property, parameter)
}

/// Return the SQL table name given a class name
ClassMethod GetSQLTableName(userclass As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).GetSQLTableName(userclass)
}

/// ; ab 4.05.06 52166
ClassMethod GetUserClassName(sqlclass As %String = "") As %Library.String
{
	q ##class(websys.Conversions).GetUserClassName(sqlclass)
}

/// ; ab 4.05.06 52166
ClassMethod GetSQLTableID(userclass As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).GetSQLTableID(userclass)
}

/// A simple HexBin Converter
ClassMethod HexBinS(str As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).HexBinS(str)
}

ClassMethod IsValidClassName(classname As %Library.String) As %Library.Boolean
{
	q ##class(websys.Conversions).IsValidClassName(classname)
}

/// Check if query exists for a class
ClassMethod IsValidMethodName(classname As %Library.String, methodname As %Library.String) As %Library.Boolean
{
	q ##class(websys.Conversions).IsValidMethodName(classname, methodname)
}

/// Check if query exists for a class
ClassMethod IsValidQueryName(classname As %Library.String, queryname As %Library.String) As %Library.Boolean
{
	q ##class(websys.Conversions).IsValidQueryName(classname, queryname)
}

/// Determine if result set is valid (a run time test!)
ClassMethod IsValidResultSet(rs As %Library.String) As %Library.Boolean
{
	q ##class(websys.Conversions).IsValidResultSet(rs)
}

/// Convert a $LIST format string to Html data using the delimiter specified.
/// Useful for converting long text fields from result set queries for html display/update.
ClassMethod ListLogicalToHtml(list As %String, delim As %String = "<BR>", keepblanks As %Integer = 0) As %String
{
	q ##class(websys.Conversions).ListLogicalToHtml(list, delim, keepblanks)
}

/// Load Reload parameters from temp global
ClassMethod LoadReload(id As %Library.String)
{
	d ##class(websys.Conversions).LoadReload(id)
}

/// wrokaround for serverside redirect losing request data.
ClassMethod LoadRequest()
{
	d ##class(websys.Conversions).LoadRequest()
}

/// convert from a string to long text field
ClassMethod LongTextHtmlToLogical(ByRef prp As %Library.String, str As %Library.String, delim As %Library.String = "<BR>")
{
	d ##class(websys.Conversions).LongTextHtmlToLogical(.prp, str, delim)
}

ClassMethod LongTextLogicalToHtml(ByRef longtext As %String, delim As %String = "<BR>") As %String
{
	q ##class(websys.Conversions).LongTextLogicalToHtml(.longtext, delim)
}

ClassMethod LookUpClassNameClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpClassNameFetch ]
{
}

ClassMethod LookUpClassNameExecute(ByRef QHandle As %Library.Binary, classname As %String) As %Library.Status
{
}

ClassMethod LookUpClassNameFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpClassNameExecute ]
{
}

ClassMethod LookUpPropertyNameClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPropertyNameFetch ]
{
}

ClassMethod LookUpPropertyNameExecute(ByRef QHandle As %Library.Binary, tablename As %String) As %Library.Status
{
}

ClassMethod LookUpPropertyNameFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPropertyNameExecute ]
{
}

ClassMethod LookUpMethodNameClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPropertyNameFetch ]
{
}

ClassMethod LookUpMethodNameExecute(ByRef QHandle As %Library.Binary, tablename As %String) As %Library.Status
{
}

ClassMethod LookUpMethodNameFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPropertyNameExecute ]
{
}

/// replaces a double quote for 2 double quotes
/// used in questionnaires, websys.Component.JSBuild(), websys.ComponentItem.InvokeMethod()
ClassMethod QuotedCacheString(str As %Library.String = "") As %Library.String
{
}

/// Save reload parameters and return unique id
ClassMethod SaveReload(optid As %Library.String = "") As %Library.String
{
	q ##class(websys.Conversions).SaveReload(optid)
}

/// temporarily save request variables when jumping betweeen pages with ServerSideRedirect.
/// Should be fixed as a bug by Intersystems. (!!)
ClassMethod SaveRequest()
{
	d ##class(websys.Conversions).SaveRequest()
}

/// 2009-07-07  zhaocz
ClassMethod Unique() As %Library.Integer
{
	;q ##class(websys.Conversions).Unique()
	q $i(^websys.Unique)
}

/// Replace CR, LF, TAB etc with SPACE.
/// Mainly used with multipline fields and SQL queries
ClassMethod WhiteSpace(str As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).WhiteSpace(str)
}

/// Convert the value from an html check box to a Yes/No field value
ClassMethod YesNoHtmlToLogical(x As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).YesNoHtmlToLogical(x)
}

/// Convert a yes/no vaue to HTML checkbox value
ClassMethod YesNoLogicalToHtml(x As %Library.String) As %Library.String
{
	q ##class(websys.Conversions).YesNoLogicalToHtml(x)
}

/// Takes a mathematical expression that uses brackets *,/,+ and - and evaluates it
/// If there is an error then the error variable is set with the error
/// error returned as <CODE>^Error Text (where messages are defined in MRObservations.EditList)
ClassMethod CalculateExpression(function As %String, ByRef error As %String, ByRef ARYTOK As %String, ValidateFunction As %Integer = 0) As %String
{
	q ##class(websys.Conversions).CalculateExpression(function, .error, .ARYTOK,ValidateFunction)
}

/// Get a list of classnames - faster than using the system classes
Query LookUpClassName(classname As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ClassName:%String,TableName:%String")
{
}

/// Get a list of methodnames - faster than using the system classes
Query LookUpMethodName(classname As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ClassName:%String,TableName:%String")
{
}

/// parameter is an unqualified table name (possibly) with underscores.
/// The classname will be deduced from this.
Query LookUpPropertyName(tablename) As %Library.Query(CONTAINID = 1, ROWSPEC = "property:%String,column:%String")
{
}

ClassMethod DateLogicalToHtml(h As %String) As %String
{
	q ##class(websys.Conversions).DateLogicalToHtml(h)
}

ClassMethod DateHijraToJulianDay(y As %Integer, m As %Integer, d As %Integer) As %Numeric
{
	q ##class(websys.Conversions).DateHijraToJulianDay(y, m, d)
}

ClassMethod DateGregorianToJulianDay(y As %Integer, m As %Integer, d As %Integer) As %Numeric
{
	q ##class(websys.Conversions).DateGregorianToJulianDay(y, m, d)
}

ClassMethod DateLogicalToHijra(h As %String) As %String
{
	;w ##class(dtwebsys.Conversions).DateLogicalToHijra($h)
	q ##class(websys.Conversions).DateLogicalToHijra(h)
}

ClassMethod DateHijraToLogical(dt As %String) As %String
{
	q ##class(websys.Conversions).DateHijraToLogical(dt)
}

ClassMethod TimeHtmlToLogical(t As %String) As %String [ Final ]
{
	q ##class(websys.Conversions).TimeHtmlToLogical(t)
}

ClassMethod TimeLogicalToHtml(h As %String) As %String [ Final ]
{
	q ##class(websys.Conversions).TimeLogicalToHtml(h)
}

}
