Class web.DHCEQ.Plat.CTGroupPicType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modified By CSJ 2018-10-23 
/// 描述: 安全组访问类组HISUI改造：按规范修改Query输出列
/// 入参:安全组id
/// 访问表：DHC_EQCPicType,DHC_EQCGroupPicType
/// 输出列：TRowid,TGroupDR,TGroup,TEquipTypeDR,TEquipType,TDefaultFlag,TAccessFlag
/// 返回值:无
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTGroupPicType","GetGroupPicType","1")
Query GetGroupPicType(Group As %String = "") As %Query(ROWSPEC = "TRowID:%String,TGroupDR:%String,TGroup:%String,TPicTypeDR:%String,TPicType:%String,TEditFlag:%String,TAccessFlag:%String")
{
}

ClassMethod GetGroupPicTypeExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,TRowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i Group="" Quit $$$OK
	s PTRowID=0
	f  s PTRowID=$o(^DHCEQCCode("DHCEQCPicType",PTRowID))  quit:PTRowID=""  d
	.d ResetVariablesGetGroupPicType
	.q:($p($g(^DHCEQCCode("DHCEQCPicType",PTRowID)),"^",4)="Y")
	.s TGroupDR=Group
	.s TGroup=$p(^SSU("SSGRP",Group),"^",1)
	.s TPicTypeDR=PTRowID
	.s TPicType=$p($g(^DHCEQCCode("DHCEQCPicType",PTRowID)),"^",2)
	.s GPTRowID=0
	.f  s GPTRowID=$o(^DHCEQCCode("DHCEQCGroupPicType",0,"GPTPicTypeDR",TPicTypeDR,GPTRowID))  quit:GPTRowID=""  d
	..q:($p($g(^DHCEQCCode("DHCEQCGroupPicType",GPTRowID)),"^",1)'=TGroupDR)
	..s TRowID=GPTRowID
	.i TRowID="" d
	..s TEditFlag="N"
	..s TAccessFlag="N"
	.e  d
	..s TEditFlag=$p($g(^DHCEQCCode("DHCEQCGroupPicType",TRowID)),"^",3) 
	..s TAccessFlag="Y"
	.d OutputRowGetGroupPicType
	Quit $$$OK
OutputRowGetGroupPicType
	set Data=$lb(TRowID,TGroupDR,TGroup,TPicTypeDR,TPicType,TEditFlag,TAccessFlag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroupPicType
	Set (TRowID,TGroupDR,TGroup,TPicTypeDR,TPicType,TEditFlag,TAccessFlag)=""
	Quit
}

ClassMethod GetGroupPicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupPicTypeExecute ]
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

ClassMethod GetGroupPicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupPicTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Modefied by zc 2015-07-30 zc0027
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
		s AccessFlag=$p(List,"^",5)
		if (GPTRowID'="")
		{
			if (AccessFlag'="Y")
			{
				&SQL(delete from sqluser.DHC_EQCGroupPicType  where GPT_RowID=:GPTRowID)
			}
			else
			{
				&SQL(Update SQLUSER.DHC_EQCGroupPicType values :PLIST() where GPT_RowID=:GPTRowID)
			}
		}
		else
		{
			if (AccessFlag="Y")
			{
				&SQL(insert into SQLUser.DHC_EQCGroupPicType values :PLIST())
			}
		}
		
	}
	q SQLCODE
}

}
