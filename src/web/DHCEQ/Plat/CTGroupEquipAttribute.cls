Class web.DHCEQ.Plat.CTGroupEquipAttribute Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// add by lmm 2020-044-28
/// 描述: 安全组访问公告分类
/// 入参:安全组id
/// 访问表：DHC_EQCGroupNoticeCat
/// 返回值:无
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTGroupNoticeCat","GetGroupEquipAttribute","1")
Query GetGroupEquipAttribute(Group As %String = "") As %Query(ROWSPEC = "TRowID:%String,TGroupDR:%String,TGroup:%String,TEquipAttributeDR:%String,TEquipAttribute:%String,TEditFlag:%String")
{
}

ClassMethod GetGroupEquipAttributeExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,TRowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s erowid=0
	f  s erowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",erowid))  quit:erowid=""  d
	.d ResetVariablesGroupEquipType
	.q:($p($g(^DHCEQCCode("DHCEQCEquipAttribute",erowid)),"^",5)="Y")   //modify by lmm 2020-05-08
	.s TGroupDR=Group
	.s TGroup=$p(^SSU("SSGRP",Group),"^",1)
	.s TEquipAttributeDR=erowid
	.s TEquipAttribute=$p($g(^DHCEQCCode("DHCEQCEquipAttribute",erowid)),"^",2)
	.i $D(^DHCEQCCode("DHCEQCGroupEquipAttribute",0,"Group",Group,erowid)) d
	..s TRowID=$o(^DHCEQCCode("DHCEQCGroupEquipAttribute",0,"Group",Group,erowid,0))
	.i TRowID="" d
	..s TEditFlag="N"
	.e  d
	..s TEditFlag=$p($g(^DHCEQCCode("DHCEQCGroupEquipAttribute",TRowID)),"^",3) 
	.d OutputRowGetGroupEquipAttribute
	Quit $$$OK
OutputRowGetGroupEquipAttribute
	set Data=$lb(TRowID,TGroupDR,TGroup,TEquipAttributeDR,TEquipAttribute,TEditFlag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGroupEquipType
	Set (TRowID,TGroupDR,TGroup,TEquipAttributeDR,TEquipAttribute,TEditFlag)=""
	Quit
}

ClassMethod GetGroupEquipAttributeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupEquipAttributeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGroupEquipAttributeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupEquipAttributeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by lmm 2020-04-17
/// 描述：修改保存方法
ClassMethod SaveData(GroupDR, listVal)
{
	s SQLCODE=0
	new Length,i,GPTRowID,AccessFlag
	s Length=$l(listVal,"#")
	for i=1:1:Length
	{
		q:SQLCODE'=0
		k PLIST
		s List=	$p(listVal,"#",i)
		s GPTRowID=$p(List,"^",1)
		s PLIST(2)=GroupDR
		s PLIST(3)=$p(List,"^",3)
		s PLIST(4)=$p(List,"^",4)
		s AccessFlag=$p(List,"^",4)
		if (GPTRowID'="")
		{
			if (AccessFlag'="Y")
			{
				&SQL(delete from sqluser.DHC_EQCGroupEquipAttribute  where CEA_RowID=:GPTRowID)
			}
			else
			{
				&SQL(Update SQLUSER.DHC_EQCGroupEquipAttribute values :PLIST() where CEA_RowID=:GPTRowID)
			}
		}
		else
		{
			if (AccessFlag="Y")
			{
				&SQL(insert into SQLUser.DHC_EQCGroupEquipAttribute values :PLIST())
			}
		}
		
	}
	q SQLCODE
}

/// add by lmm 2020-04-17
/// 描述：当前安全组是否可编辑设备属性
/// w ##Class(web.DHCEQ.Plat.CTGroupEquipAttribute).EquipAttributeIsEdit("85","1")
ClassMethod EquipAttributeIsEdit(GroupID As %String = "", EquipAttributeID)
{
	i EquipAttributeID="" q "N"
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s EditFlag="N"
	s erowid=""
	s erowid=$o(^DHCEQCCode("DHCEQCGroupEquipAttribute",0,"Group",GroupID,EquipAttributeID,0))
	i erowid'="" s EditFlag=$p($g(^DHCEQCCode("DHCEQCGroupEquipAttribute",erowid)),"^",3) 
		
	q EditFlag
}

}
