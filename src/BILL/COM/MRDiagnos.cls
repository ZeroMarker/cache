/// 名称: BILL.COM.MRDiagnos.cls
/// 描述: 计费组公共诊断相关类
/// 编写者: ZhYW
/// 编写日期: 2021-07-26
Class BILL.COM.MRDiagnos Extends %RegisteredObject
{

/// Creator: ZhYW
/// CreatDate: 2021-07-26
/// Description: 查询诊断
/// Input: alias:别名, sessionStr:SS_User.RowId^SS_Group.RowId^CT_Loc.RowId^CT_Hospital.RowId
/// Output: 诊断名称,诊断ID
/// Debug: do ##class(%ResultSet).RunQuery("BILL.COM.MRDiagnos","FindMRDiagnos","ycx","5^122^49^2")
Query FindMRDiagnos(alias As %String, sessionStr As %String = "") As websys.Query(ROWSPEC = "DiagDesc:%String,DiagRowID:%String")
{
}

ClassMethod FindMRDiagnosExecute(ByRef qHandle As %Binary, alias As %String, sessionStr As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindMRDiagnos")=$lb(alias, sessionStr)
	if (alias="") quit $$$OK
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set deptId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	//西医诊断
	set rset=##class(%ResultSet).%New("web.DHCMRDiagnos:LookUpWithAlias")
	do rset.Execute(alias, "", "", "", 0, userId, "", "")
	while(rset.Next()){
		set diagId=rset.GetData(2)
		continue:(diagId="")
		set diagDesc=rset.GetData(1)
		do OutputMRDiagnos
	}
	
	kill rset
	//中医诊断
	set rset=##class(%ResultSet).%New("web.DHCMRDiagnos:LookUpWithAlias")
	do rset.Execute(alias, "", "", "", 1, userId, "", "")
	while(rset.Next()){
		set diagId=rset.GetData(2)
		continue:(diagId="")
		set diagDesc=rset.GetData(1)
		do OutputMRDiagnos
	}
	
	quit $$$OK
	
OutputMRDiagnos
	set data=$lb(diagDesc,diagId)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	quit
}

}
