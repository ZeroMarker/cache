Class web.DHCEQSwap Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(%ResultSet).RunQuery("web.DHCEQSwap","GetSwap","","","","","","","","")
Query GetSwap(SwapNo, Type, StartDate, EndDate, RequestLocDR, Status, ApproveRole, InvalidFlag As %String = "N") As %Query(ROWSPEC = "TRowID:%String,TSwapNo:%String,TType:%String,TWashDate:%String,TLoc:%String,TRequestLoc:%String,TStatus:%String,TQuantityNum:%String,TRequestUser:%String,TRequestDate:%String,TUpdateUser:%String,TUpdateDate:%String,TSubmitUser:%String,TSubmitDate:%String,TAuditUser:%String,TAuditDate:%String,TApproveStep:%String,TApproveRole:%String")
{
}

ClassMethod GetSwapExecute(ByRef qHandle As %Binary, SwapNo, Type, StartDate, EndDate, RequestLocDR, Status, ApproveRole, InvalidFlag As %String = "N") As %Status
{
 	new repid, index,rowid,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("23")
	s index=1
	s rowid=0
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	d BuildDataGetSwap
	Quit $$$OK
BuildDataGetSwap
	f  s rowid=$o(^DHCEQSwap(rowid))  quit:rowid=""  d
	.d ResetVariablesGetSwap
	.s TRowID = rowid
	.s ISFlag=$p($g(^DHCEQSwap(rowid)),"^",25)
	.i ISFlag="" s ISFlag="N"
	.q:(InvalidFlag'="")&&(InvalidFlag'=ISFlag)
	.s TType = $p($g(^DHCEQSwap(rowid)),"^",2)
	.q:(Type'="")&&(Type'=TType)
	.s TType=..GetSwapType(TType)
	.q:($p($g(^DHCEQSwap(rowid)),"^",18)>EndDate)||($p($g(^DHCEQSwap(rowid)),"^",18)<StartDate)
	.s TWashDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSwap(rowid)),"^",18),"date")
	.s TRequestLocDR = $p($g(^DHCEQSwap(rowid)),"^",4)
	.q:(RequestLocDR'="")&&(RequestLocDR'=TRequestLocDR)
	.i TRequestLocDR '= ""  s TRequestLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	.s TSwapNo = $p($g(^DHCEQSwap(rowid)),"^",1)
	.q:(SwapNo'="")&&(SwapNo'=TSwapNo)
	.s TStatus = $p($g(^DHCEQSwap(rowid)),"^",10)
	.q:(Status'="")&&(Status'=TStatus)
	.s TStatus=..GetSwapStatus(TStatus)
	.s TLocDR = $p($g(^DHCEQSwap(rowid)),"^",3)
	.i TLocDR '= ""  s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSwap(rowid)),"^",5),"date")
	.s TRequestUserDR = $p($g(^DHCEQSwap(rowid)),"^",6)
	.i TRequestUserDR '=""  d
	..s TRequestUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	.s TQuantityNum = $p($g(^DHCEQSwap(rowid)),"^",7)
	.s TUpdateUserDR = $p($g(^DHCEQSwap(rowid)),"^",11)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSwap(rowid)),"^",12),"date")
	.s TSubmitUserDR = $p($g(^DHCEQSwap(rowid)),"^",14)
	.i TSubmitUserDR '=""  d
	..s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	.s TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSwap(rowid)),"^",15),"date")
	.s TAuditUserDR = $p($g(^DHCEQSwap(rowid)),"^",17)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSwap(rowid)),"^",18),"date")
	.s THold1 = $p($g(^DHCEQSwap(rowid)),"^",20)
	.s THold2 = $p($g(^DHCEQSwap(rowid)),"^",21)
	.s THold3 = $p($g(^DHCEQSwap(rowid)),"^",22)
	.s THold4 = $p($g(^DHCEQSwap(rowid)),"^",23)
	.s THold5 = $p($g(^DHCEQSwap(rowid)),"^",24)
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.s CurRole=""
	.i AIRowID'="" s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	.q:((CurRole'="")&&(CurRole'=ApproveRole))
	.d OutputRowGetSwap
	quit
OutputRowGetSwap
	s Data=$lb(TRowID,TSwapNo,TType,TWashDate,TLoc,TRequestLoc,TStatus,TQuantityNum,TRequestUser,TRequestDate,TUpdateUser,TUpdateDate,TSubmitUser,TSubmitDate,TAuditUser,TAuditDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetSwap
	s (TRowID,TWashDate,TLocDR,TRequestUserDR,TRequestUser,TRequestDate,TUpdateUserDR,TUpdateUser,TUpdateDate,TSubmitUserDR,TSubmitUser,TSubmitDate,TAuditUserDR,TAuditUser,TAuditDate,TStatus,TLoc,CurRole)=""
	quit
}

ClassMethod GetSwapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSwapExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetSwapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSwapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod TypeList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>销毁</option>"
	w "<option value=2>更换</option>"
	w "</select>",!
}

ClassMethod GetSwapType(Type)
{
	q $CASE(Type,"1":"销毁","2":"更换",:"没有定义")
}

ClassMethod StatusList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>新增</option>"
	w "<option value=1>提交</option>"
	w "<option value=2>审核</option>"
	//w "<option value=3>作废</option>"
	w "</select>",!
}

ClassMethod GetSwapStatus(Status)
{
	q $CASE(Status,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")
}

}
