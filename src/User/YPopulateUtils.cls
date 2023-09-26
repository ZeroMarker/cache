Include %occInclude

IncludeGenerator %occInclude

/// The <CLASS>%PopulateUtils</CLASS> class contains a number of utility methods used by the 
/// <CLASS>%Populate</CLASS> class.
Class User.YPopulateUtils [ ClassType = "", Not ProcedureBlock ]
{

/// Return a random array element.
ClassMethod ArrayElement(ByRef array) As %String
{
}

/// Populate a random sample of ID values from a class.
ClassMethod BuildReferenceSample(class, sample, size = 500, selpct = 25)
{
}

/// Returns a random city name.
ClassMethod City() As %String
{
}

/// Returns a random company name.
ClassMethod Company() As %String
{
}

/// Returns a random currency value between <var>min</var> 
/// and <var>max</var> (if present).
ClassMethod Currency(min As %Integer = 0, max As %Integer = 10000) As %Integer
{
}

/// Returns a random date value in <i>Cach&eacute;</i> <code>$H</code> format.
ClassMethod Date() As %Date [ CodeMode = expression ]
{
}

/// Returns a string containing a random first name.
/// <p><var>gender</var> is a optional string used to control the 
/// gender of the generated name: 1 is Male, 2 = Female, "" is either.
ClassMethod FirstName(gender As %String = "") As %String
{
}

/// Returns a string containing a random first name.
/// <p><var>gender</var> is a optional string used to control the 
/// gender of the generated name: 1 is Male, 2 = Female, "" is either.
ClassMethod FirstNameX(gender As %String = "") As %String
{
}

/// Returns a random floating point value between <var>min</var> 
/// and <var>max</var> (if present).
ClassMethod Float(min As %Integer = 0, max As %Integer = 10000, scale As %Integer = 0) As %Integer
{
}

/// Returns a random integer value between <var>min</var> 
/// and <var>max</var> (if present).
ClassMethod Integer(min As %Integer = 0, max As %Integer = 10000) As %Integer
{
}

/// Returns a string containing a random last name.
ClassMethod LastName() As %String
{
}

/// Returns a string containing a random last name.
ClassMethod LastNameX() As %String
{
}

/// Returns some shakespearean stuff....
ClassMethod LongTextX(pct As %Library.String) As %String
{
}

/// Returns a string containing a randomly generated corporate mission statement.
ClassMethod Mission() As %String
{
}

/// Returns a string containing a random name as <i>lastname,firstname</i>.
/// <p><var>gender</var> is a optional string used to control the 
/// gender of the generated name: 1 is Male, 2 = Female, "" is either.
ClassMethod Name(gender As %String = "") As %String
{
}

/// Returns a random Aussie style phone number.
ClassMethod Phone() As %String [ CodeMode = expression ]
{
}

/// Return a random U.S. Social Security Number.
ClassMethod SSN() As %String [ CodeMode = expression ]
{
}

/// Returns a random street address.
ClassMethod Street() As %String
{
}

/// Returns a string value of length <var>len</var> 
/// of a random character_$r(9999).
ClassMethod String(len As %Integer = 1) As %String
{
}

/// Returns a random syllable string.
ClassMethod Syllable(maxlen As %Integer = 30) As %String
{
}

/// Returns a random TimeStamp value.
ClassMethod TimeStamp(min As %Integer, max As %Integer) As %String
{
}

/// Returns a random Job Title.
ClassMethod Title() As %String
{
}

/// Returns a random U.S. phone number.
ClassMethod USPhone() As %String [ CodeMode = expression ]
{
}

/// Returns a random U.S. state abbreviation.
ClassMethod USState() As %String
{
}

/// Returns a random U.S. Zone Improvement Plan code.
ClassMethod USZip() As %String [ CodeMode = expression ]
{
}

/// Returns a random piece from a delimited list. The first character in the list is the delimiter.
ClassMethod ValueList(vallist) As %String
{
}

/// Returns a random string value of random length 
/// up to <var>maxlen</var> characters.
ClassMethod VarString(maxlen As %Integer = 1) As %String
{
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.YPopulateUtils).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.YPopulateUtils","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.YPopulateUtils).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.YPopulateUtils","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.YPopulateUtils).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.YPopulateUtils","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.YPopulateUtils).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.YPopulateUtils","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.YPopulateUtils).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.YPopulateUtils","OnBeforeUpdate")
}

}
