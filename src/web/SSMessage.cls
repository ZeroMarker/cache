Class web.SSMessage Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 372;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod test(compref As %Library.String, DisDate As %Library.String)
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	//m ^Temp("Upgrade",$j,"websysAfterSave","%req")=%request.Data
	//m ^Temp("Upgrade",$j,"websysAfterSave","%sess")=%session.Data
	s recIdList=%request.Data("MessageRecipientIDs",1)
	quit:id=""
	if new{
		d ##class(web.SSMessageRecipient).insertMessage(recIdList,id)
	}
	quit
}

ClassMethod Save(MessageInfo, CreateUser) As %Integer
{
	n (MessageInfo,CreateUser)
	set obj = ##class(User.SSMessage).%New()
	d ##Class(websys.Conversions).LongTextHtmlToLogical(obj.MESSMessage,MessageInfo,$C(13,10))
	set obj.MESSDateCreated = +$h
	set obj.MESSTimeCreated = $P($h,",",2)
	do obj.MESSUserCreatedDRSetObjectId(CreateUser)
	set sc = obj.%Save()
	if $$$ISERR(sc){
		q "-1^"_$SYSTEM.Status.GetErrorText(sc)
	}
	set Id = obj.%Id()
	set obj = ""
	q Id
}

Parameter SQLCODE = "MESS_RowId";

Parameter SQLDESCRIPTION = "MESS_RowId";

Parameter SQLROWID = "MESS_RowId";

}
