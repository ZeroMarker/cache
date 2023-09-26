/// used to log routine data and calls
/// can be switched on/off using ^zEPR("Control")
Class epr.Log Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

ClassMethod Add(ID1 As %Library.String, ID2 As %Library.String = "", ByRef Array As %Library.String) As %Library.Stream
{
}

ClassMethod ViewLogClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ViewLogFetch ]
{
}

ClassMethod ViewLogExecute(ByRef QHandle As %Library.Binary, LogClass As %Library.String = "", LogSubClass As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Library.Status
{
}

ClassMethod ViewLogFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ViewLogExecute ]
{
}

Query ViewLog(LogClass As %String, LogSubClass, DateFrom, DateTo) As %Library.Query(CONTAINID = 0, ROWSPEC = "LogClass:%String,LogSubClass:%String,LogDate:%Date,LogTime:%Time,LogStrings:%List")
{
}

Storage Default
{
<Data name="LogClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<DataLocation>^epr.LogD</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.LogD</IdLocation>
<IndexLocation>^epr.LogI</IndexLocation>
<StreamLocation>^epr.LogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
