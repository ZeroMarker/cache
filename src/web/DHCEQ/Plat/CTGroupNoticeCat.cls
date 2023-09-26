Class web.DHCEQ.Plat.CTGroupNoticeCat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// add by lmm 2020-04-17
/// 描述: 安全组访问公告分类
/// 入参:安全组id
/// 访问表：DHC_EQCGroupNoticeCat
/// 返回值:无
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTGroupNoticeCat","GetGroupNoticeCat","1")
Query GetGroupNoticeCat(Group As %String = "") As %Query(ROWSPEC = "TRowID:%String,TGroupDR:%String,TGroup:%String,TNoticeCatDR:%String,TNoticeCat:%String,TEditFlag:%String")
{
}

ClassMethod GetGroupNoticeCatExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,TRowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s erowid=0
	f  s erowid=$o(^DHCEQCCode("DHCEQPCNoticeCat",erowid))  quit:erowid=""  d
	.d ResetVariablesGroupEquipType
	.q:($p($g(^DHCEQCCode("DHCEQPCNoticeCat",erowid)),"^",4)="Y")
	.s TGroupDR=Group
	.s TGroup=$p(^SSU("SSGRP",Group),"^",1)
	.s TNoticeCatDR=erowid
	.s TNoticeCat=$p($g(^DHCEQCCode("DHCEQPCNoticeCat",erowid)),"^",2)
	.i $D(^DHCEQCCode("DHCEQCGroupNoticeCat",0,"Group",Group,erowid)) d
	..s TRowID=$o(^DHCEQCCode("DHCEQCGroupNoticeCat",0,"Group",Group,erowid,0))
	.i TRowID="" d
	..s TEditFlag="N"
	.e  d
	..s TEditFlag=$p($g(^DHCEQCCode("DHCEQCGroupNoticeCat",TRowID)),"^",3) 
	.d OutputRowGetGroupNoticeCat
	Quit $$$OK
OutputRowGetGroupNoticeCat
	set Data=$lb(TRowID,TGroupDR,TGroup,TNoticeCatDR,TNoticeCat,TEditFlag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGroupEquipType
	Set (TRowID,TGroupDR,TGroup,TNoticeCatDR,TNoticeCat,TEditFlag)=""
	Quit
}

ClassMethod GetGroupNoticeCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupNoticeCatExecute ]
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

ClassMethod GetGroupNoticeCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupNoticeCatExecute ]
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
				&SQL(delete from sqluser.DHC_EQCGroupNoticeCat  where GNC_RowID=:GPTRowID)
			}
			else
			{
				&SQL(Update SQLUSER.DHC_EQCGroupNoticeCat values :PLIST() where GNC_RowID=:GPTRowID)
			}
		}
		else
		{
			if (AccessFlag="Y")
			{
				&SQL(insert into SQLUser.DHC_EQCGroupNoticeCat values :PLIST())
			}
		}
		
	}
	q SQLCODE
}

}
