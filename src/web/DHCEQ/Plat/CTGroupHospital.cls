Class web.DHCEQ.Plat.CTGroupHospital Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Modified By CSJ 2018-10-23 
/// 描述: 安全组访问院区HISUI改造：按规范修改Query输出列
/// 入参:安全组id
/// 访问表：DHC_EQCGroupHospital
/// 输出列：TRowid,TGroupDR,TGroup,THospitalDR,THospital,TOpt
/// 返回值:无
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTGroupHospital","GetGroupHospital","1")
Query GetGroupHospital(Group As %String = "") As %Query(ROWSPEC = "TRowid:%String,TGroupDR:%String,TGroup:%String,THospitalDR:%String,THospital:%String,TOpt:%String")
{
}

ClassMethod GetGroupHospitalExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,TRowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s HospRowID=0
	f  s HospRowID=$o(^CT("HOSP",HospRowID))  quit:HospRowID=""  d
	.d ResetVariablesGetGroupHospital
	.s THospitalDR=HospRowID
	.s THospital=$Piece($Get(^CT("HOSP",HospRowID)),"^",2)
 	.s TGroupDR=Group
 	.s TGroup=$p(^SSU("SSGRP",TGroupDR),"^",1)
	.s TOpt="N"
	.s TRowid=$o(^DHCEQCCode("DHCEQCGroupHospital",0,"GroupHospital",TGroupDR,THospitalDR,0))
	.i TRowid'="" s TOpt="Y"
	.d OutputRowGetGroupHospital
	Quit $$$OK
OutputRowGetGroupHospital
	set Data=$lb(TRowid,TGroupDR,TGroup,THospitalDR,THospital,TOpt)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroupHospital
	Set (TRowid,TGroupDR,TGroup,THospitalDR,THospital,TOpt)=""
	Quit
}

ClassMethod GetGroupHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupHospitalExecute ]
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

ClassMethod GetGroupHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SaveData(PTData)
{
	k PLIST
	s PLIST(1)=$p($G(PTData),"^",1)
	s PLIST(2)=$p($G(PTData),"^",2)
	s PLIST(3)=$p($G(PTData),"^",3)
	s PLIST(4)=$p($G(PTData),"^",4)
	i (PLIST(1)="")
	{
		i (PLIST(4)="N")
		{ 
			q ""
		}
		else
		{
			&SQL(insert into sqluser.DHC_EQCGroupHospital values :PLIST())
		}
	}
	else
	{
		i (PLIST(4)="N") 
		{
			s uhrowid=PLIST(1)
			&SQL(delete from SQLUser.DHC_EQCGroupHospital  where UH_RowID=:uhrowid)
		}
		else 
		{
			s uhrowid=PLIST(1)
			&SQL(update  SQLUser.DHC_EQCGroupHospital Values :PLIST() where UH_RowID=:uhrowid)
		}
	}
	if SQLCODE  q SQLCODE
	q $g(%ROWID)
}

}
