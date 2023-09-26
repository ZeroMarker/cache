Class web.DHCEQ.Plat.CTCApproveFlow Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEQ.Plat.CTCApproveFlow).GetApproveFlowType("141","19","25","0","2","WX_Maint")
ClassMethod GetApproveFlowType(SourceID, CurRoleID, ApporveTypeCode, Type, RoleStep, ActionCode As %String = "")
{
    	n ApproveType,ApproveSet,ApproveFlowDR,ApproveAllowType
    	s ApproveType=##class(web.DHCEQApproveList).GetApproveType(ApporveTypeCode)
    	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet(ApporveTypeCode,SourceID)
    	s ApproveAllowType=""
    	i ActionCode="" d
    	.s ApproveFlowDR=0
    	.f  s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,CurRoleID,ApproveFlowDR)) q:ApproveFlowDR=""  d
    	..q:$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",3)'=RoleStep
    	..i Type=0 d
    	...s ApproveAllowType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",11)
    	..i Type=1 d
    	...s ApproveAllowType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",13)
    	e  d
    	.s ActionID=$o(^DHCEQCCode("DHCEQCAction",0,"Code",ActionCode,0))
    	.i ActionID'="" d
    	..s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,ActionID,0))
    	..q:ApproveFlowDR=""
    	..i Type=0 d
    	...s ApproveAllowType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",11)
    	..i Type=1 d
    	...s ApproveAllowType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",13)
    	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ApproveAllowType)
}

/// Add By QW20211110 BUG:QW0154
/// 取得对应业务的角色或动作
/// 入参  Buss:业务类型
///       Type：0：角色  1：动作
/// 出参  TRowID:对应角色或者动作的id
///       TCode:对应角色或者动作的code
///       TDesc:对应角色或者动作的描述
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTCApproveFlow","GetRoleAction","","0")
Query GetRoleAction(Buss As %String, Type As %String, Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String")
{
}

ClassMethod GetRoleActionExecute(ByRef qHandle As %Binary, Buss As %String, Type As %String, Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i Buss'=""
	{	Set ApproveType=##class(web.DHCEQMessages).GetApproveTypeByBussType(Buss)
		s ApproveSet=0
		f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  q:(ApproveSet="")  d	
		.d GetApproveFlowInfo
	}
	else
	{
		if +Type=0		//czf 2021-11-25 begin
		{
			s ARRowID=0
			f  s ARRowID=$o(^DHCEQCCode("DHCEQCApproveRole",ARRowID)) q:ARRowID=""  d
			.d ResetVariablesGetRoleAction
			.s TRowID=ARRowID
			.q:$p($g(^DHCEQCCode("DHCEQCApproveRole",TRowID)),"^",4)="Y"
			.s TCode=$p($g(^DHCEQCCode("DHCEQCApproveRole",TRowID)),"^",1)
			.s TDesc=$p($g(^DHCEQCCode("DHCEQCApproveRole",TRowID)),"^",2)
			.d OutputRowGetRoleAction
		}
		elseif Type=1
		{
			s ACRowID=0
			f  s ACRowID=$o(^DHCEQCCode("DHCEQCAction",ACRowID)) q:ACRowID=""  d
			.d ResetVariablesGetRoleAction
			.s TRowID=ACRowID
			.q:$p($g(^DHCEQCCode("DHCEQCAction",TRowID)),"^",5)="Y"
			.s TCode=$p($g(^DHCEQCCode("DHCEQCAction",TRowID)),"^",1)
			.s TDesc=$p($g(^DHCEQCCode("DHCEQCAction",TRowID)),"^",2)
			.d OutputRowGetRoleAction
		}		//czf 2021-11-25 end
	}
	Quit $$$OK
GetApproveFlowInfo
	
	if (Type="1")
	{
		i $d(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet))
		{
			;通过动作配置流获取审批流信息
			
			;设置步骤临时节点
			s job=$job
			k ^DHCEQTemp("GetRoleAction",job)
			
			s ActionID=""
			f  s ActionID=$o(^DHCEQCCode("DHCEQCAction",0,"SourceType",ApproveType,ActionID)) q:ActionID=""  d
			.q:$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",5)'="N"
			.i $p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",3)="" d
			..s ^DHCEQTemp("GetRoleAction",job,ActionID)=ActionID
			.e  d
			..s ^DHCEQTemp("GetRoleAction",job,$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",3))=ActionID
			 
			s Step=""
			f  s Step=$o(^DHCEQTemp("GetRoleAction",job,Step)) q:Step=""  d
			.s ActionID=$g(^DHCEQTemp("GetRoleAction",job,Step))
			.s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,ActionID,""))
			.q:rowid=""
			.d SetApproveFlowInfo
			k ^DHCEQTemp("GetRoleAction",job)
		}
	}
	else
	{
		s Step=""
		f  s Step=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,Step)) quit:Step=""  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,Step,rowid)) quit:rowid=""  d
		..d SetApproveFlowInfo
	}
	quit
SetApproveFlowInfo
	d ResetVariablesGetRoleAction

	s TApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",2)
	s THold3=+$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",9)
	if ((Type="1")&&(THold3>0)) d
	.s TRowID=THold3
	.s TCode=$p($g(^DHCEQCCode("DHCEQCAction",THold3)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCAction",THold3)),"^",2)
	e  i ((Type="0")&&(TApproveRoleDR'="")) d
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",1)
	.s TRowID=TApproveRoleDR
	d OutputRowGetRoleAction
	quit	

OutputRowGetRoleAction
	q:(Desc'="")&&(TDesc'[Desc)
	s Data=$lb(TRowID,TCode,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRoleAction
	s (TRowID,TCode,TDesc)=""
	quit
}

ClassMethod GetRoleActionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleActionExecute ]
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

ClassMethod GetRoleActionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleActionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
