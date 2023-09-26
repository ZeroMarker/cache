Include webimport

IncludeGenerator webimport

Class web.DHCRepServerConfig Extends (%RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 80;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "RSC_AppName";

Parameter SQLROWID = "ID";

Parameter SQLFILTER = "ID >2";

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
 new blnUDF,blnDSS
 set (blnUDF,blnDSS)=""
 set blnUDF=##class(websys.UserDefinedFunctions).Evaluate("DHCRepServerConfig","OnBeforeSave")
 set blnDSS=##class(websys.DSSActionType).doSomething(id,"C",compref,"OnBeforeSave")
 ;d msg.AddItem("E","Test","这是一个简单的测试","50965","update")
 ;d msg.AddItem("I","Test","这是一个简单的测试","50965","update1")
 if 'blnUDF quit 0
 if 'blnDSS quit 0
 quit 1
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	i ##class(websys.UserDefinedFunctions).Evaluate("DHCRepServerConfig","OnAfterSave")
	do ##class(websys.DSSActionType).doSomething(id,"C",compref,"OnAfterSave")
 q
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
	s ^TMPDFDFDFDFDFD=compref_"^"_id
	d ##class(websys.ComponentXRef).GetSave(compref,id)
	
	;m ^TMPaaaaaa("msg","RquestData", "Before")=^TMP("reload",%session.SessionId,optid)
	
	; 需要做的工作：
	; 1. 如果msg.Count>0 应该 把提交的 %request.Data 给 reload 
	;   1.1  先把 msg.Data 给
	
	if (+msg.Count>0){
		;m ^TMP("reload",%session.SessionId,optid)=%request.Data
		
		; zhaocz 2011-05-28 add requestname 
		; 需要增加页面设置？  zhaocz
		;s ^TMP("reload", %session.SessionId, optid, "RequestPageName") = %request.PageName
		
		s TRELOADID=%request.Get("TRELOADID")
	}
	
	Quit
}

ClassMethod Test111()
{
	q ""
}

}
