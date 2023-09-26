Class web.SSHL7Queue Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 14;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLROWID = "HL7MQ_RowId";

Parameter SQLCODE = "HL7MQ_RowId";

Parameter SQLDESCRIPTION = "HL7MQ_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query QueueList(TSRTITM As %String, TSRTORD As %String, PARREF As %String) As %Query(ROWSPEC = "HL7MQ_RowId:%String,HL7MQ_Sequence:%String,HL7MQ_Type:%String,HL7MQ_Message:%String")
{
}

ClassMethod QueueListExecute(ByRef qHandle As %Binary, TSRTITM As %String, TSRTORD As %String, PARREF As %String) As %Status
{
}

ClassMethod QueueListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueueListExecute ]
{
}

ClassMethod QueueListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueueListExecute ]
{
}

}
