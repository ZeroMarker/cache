/// 质控规则信息查询
Class web.DHCQCPRORule Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCPRORule","GetAll","","")
ClassMethod GetAllExecute(ByRef qHandle As %Binary, code As %String, name As %String) As %Status
{
	Set code=$Get(code),name=$Get(name)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set ruleCode="" For  Set ruleCode=$Order(^DHCQCRL(ruleCode)) Quit:ruleCode=""  Do
	.Set str=$Get(^DHCQCRL(ruleCode))
	.Set uName=$Piece(str,"^",2)
	.If $Length(code),ruleCode'=code Quit
	.If $Length(uName),uName'[name Quit
	.Set Seqenue=$Piece(str,"^",3)
	.Set Status=$Piece(str,"^",4)
	.Set StatusName=""
	.If Status="Disable" Set StatusName="禁止"
	.If Status="Reject" Set StatusName="失控"
	.If Status="Warning" Set StatusName="警告"
	.Set Color=$Piece(str,"^",5)
	.Set ZNote=$Piece(str,"^",6)
	.Set Visible=$Piece(str,"^",7)
	.i Visible="Y" s Visible="true"
	.e  s Visible="false"
	.Do OutputRow		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(ruleCode,uName,Seqenue,StatusName,Color,Visible,Status,ZNote)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20100712
/// Description:： 质控规则查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(code As %String, name As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Sequence:%String,Status:%String,Color:%String,Visible:%String,StatusCode:%String,ZNote") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20120315
/// Description:： 质控规则默认状态查询
/// Table：        DHCQC_Rul
/// Input：        RulCode:规则代码
/// Output：       RulStatus:规则状态。
/// Return：      
/// Others：
ClassMethod QueryQCRulStatus(RulCode As %String) As %String
{
	Set Ret="^"
	Set RulCode=$Get(RulCode)
	If $Data(^DHCQCRL(RulCode)) Do
	.Set RulName=$Piece($Get(^DHCQCRL(RulCode)),"^",4)
	.If RulName="Disable" Set StatusName="禁止"
	.If RulName="Reject" Set StatusName="失控"
	.If RulName="Warning" Set StatusName="警告"
	.Set Ret=RulName_"^"_StatusName
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20120315
/// Description:： 保存质控物规则
/// Table：        DHCQCMat_Rul
/// Input：        MatCode:质控物代码,RulCode:规则代码，StatusCode：规则状态代码
/// Output：       SQLCODE:保存是否成功。
/// Return：      
/// Others：
/// d ##class(web.DHCQCPRORule).AddMetQCRul("","","")
ClassMethod AddMetQCRul(MatCode As %String, RulCode As %String, StatusCode As %String) As %String
{
	//Set MatCode="ACA530",RulCode="A",StatusCode="Disable"
	Set MatCode=$Get(MatCode),RulCode=$Get(RulCode),StatusCode=$Get(StatusCode)
	Set Ret=0
	If '$Data(^DHCQCMATRL(MatCode,RulCode)) Do
	.&SQL(Insert into lab.DHCQCMat_Rul Set DQCM_MatCode=:MatCode,DQCM_Code=:RulCode,DQCM_Status=:StatusCode )
	.Set Ret=SQLCODE
	Else  Do
	.&SQL(Update lab.DHCQCMat_Rul Set DQCM_Status=:StatusCode Where DQCM_MatCode=:MatCode And DQCM_Code=:RulCode  )
	.Set Ret=SQLCODE
	Quit SQLCODE
}

/// Creator：      DaiYi
/// CreatDate：    20120315
/// Description:： 保存质控物规则
/// Table：        DHCQCMat_Rul
/// Input：        MatCode:质控物代码,RulCode:规则代码，StatusCode：规则状态代码
/// Output：       SQLCODE:保存是否成功。
/// Return：      
/// Others：
/// d ##class(web.DHCQCPRORule).DeleteMetQCRul("","")
ClassMethod DeleteMetQCRul(MatCode As %String, RulCode As %String) As %String
{
	//Set MatCode="ACA530",RulCode="A"
	Set MatCode=$Get(MatCode),RulCode=$Get(RulCode)
	Set Ret=1
	If $Data(^DHCQCMATRL(MatCode,RulCode)) Do
	.&SQL(Delete From  lab.DHCQCMat_Rul Where DQCM_MatCode=:MatCode And DQCM_Code=:RulCode)
	.Set Ret=SQLCODE
	Quit SQLCODE
}

ClassMethod QueryMatRulClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMatRulExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCPRORule","QueryMatRul","ACA5301")
ClassMethod QueryMatRulExecute(ByRef qHandle As %Binary, MatCode As %String) As %Status
{
	Set MatCode=$Get(MatCode)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	If '$Data(^DHCQCMATRL(MatCode)) Quit $$$OK
	Set RuleCode="" For  Set RuleCode=$Order(^DHCQCMATRL(MatCode,RuleCode)) Quit:RuleCode=""  Do
	.Set Status=$Piece(^DHCQCMATRL(MatCode,RuleCode),"^",1)
	.Set MatName=$Piece($Get(^DHCQCMAT(MatCode)),"^",2)
	.Set RuleName=$Piece($Get(^DHCQCRL(RuleCode)),"^",2)
	.Set ZNote=$Piece($Get(^DHCQCRL(RuleCode)),"^",6)
	.If Status="Disable" Set StatusName="禁止"
	.If Status="Reject" Set StatusName="失控"
	.If Status="Warning" Set StatusName="警告"
	.Do OutputRul		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRul
    Set Data=$lb(MatCode,MatName,RuleCode,RuleName,Status,StatusName,ZNote)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryMatRulFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMatRulExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20120316
/// Description:： 质控物质控规则查询
/// Table：        DHCQCMat_Rul
/// Input：        MatCode： 质控物代码
/// Output：       质控规则。
/// Return：       0:无,1:有
/// Others：
Query QueryMatRul(MatCode As %String) As %Query(ROWSPEC = "MatCode:%String,MatName:%String,RuleCode:%String,RuleName:%String,Status:%String,StatusName:%String,ZNote") [ SqlProc ]
{
}

ClassMethod QueryMatRulInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMatRulInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCPRORule","QueryMatRul","ACA530")
ClassMethod QueryMatRulInfExecute(ByRef qHandle As %Binary, MatCode As %String) As %Status
{
	Set MatCode=$Get(MatCode)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	If '$Data(^DHCQCMATRL(MatCode)) Quit $$$OK
	Set RuleCode="" For  Set RuleCode=$Order(^DHCQCMATRL(MatCode,RuleCode)) Quit:RuleCode=""  Do
	.Set Status=$Piece(^DHCQCMATRL(MatCode,RuleCode),"^",1)
	.Set RuleName=$Piece($Get(^DHCQCRL(RuleCode)),"^",2)
	.If Visible="1"
	.Do OutputRulInf		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRulInf
    Set Data=$lb(Visible,RuleCode,RuleName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryMatRulInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMatRulInfExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20120316
/// Description:： 质控物质控规则查询
/// Table：        DHCQCMat_Rul
/// Input：        MatCode： 质控物代码
/// Output：       质控规则。
/// Return：       0:无,1:有
/// Others：
Query QueryMatRulInf(MatCode As %String) As %Query(ROWSPEC = "Visible:%String,RuleCode:%String,RuleName:%String") [ SqlProc ]
{
}

}
