/// 名称: web.DHCEQ.Plat.CTFundsType
/// 描述: 资金来源
/// 编写者：ZC
/// 编写日期: 2018-09-20
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTFundsType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZC
/// CreatDate：    2018-09-20
/// Description:   资金来源LookUp所需Query
/// Table：        DHC_EQCFundsType
/// Input：        FundsTypeID:资金来源ID
///                FundsType:资金来源描述
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTFundsType","FundsType","","",1)
Query FundsType(FundsTypeID As %String = "", FundsType As %String = "", GroupID As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TRemark:%String,GFTid:%String,TOpt:%String") [ SqlProc ]
{
}

ClassMethod FundsTypeExecute(ByRef qHandle As %Binary, FundsTypeID As %String = "", FundsType As %String = "", GroupID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFundsType",rowid))  quit:rowid=""  d
	.q:(FundsTypeID'="")&(FundsTypeID'=rowid)
	.s TRowID = rowid	//rowid
	.s TCode = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",1)	//代码
	.s TDesc = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",2)	//描述
	.q:(FundsType'="")&&($ZCONVERT(TDesc,"U")'[FundsType)&&($ZCONVERT(TCode,"U")'[FundsType) //add by jyp 2018-02-26 546003
	.s TRemark = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",3)	//备注
	.s TRemark=##class(web.DHCEQCommon).Replace(TRemark,$C(0),"")	;; Mozy0237	2019-12-9	1127221
	.s TInvalidFlag = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",4) //无效标志
	.q:TInvalidFlag="Y"
	.// Mozy0231	资金来源类型
	.s TOpt="N"
	.s GFTid=$o(^DHCEQCCode("DHCEQCGroupFundsType",0,"Group",+GroupID,TRowID,0))
	.i GFTid'="" s TOpt="Y"
	.d OutputRowGetFundsType
	Quit $$$OK
OutputRowGetFundsType
	s Data=$lb(TDesc,TRowID,TCode,TRemark,GFTid,TOpt)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod FundsTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FundsTypeExecute ]
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

ClassMethod FundsTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FundsTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Mozy0231	安全组访问资金来源类型
ClassMethod SaveData(Data)
{
	;s ^DHCEQMozy("web.DHCEQ.Plat.CTFundsType.SaveData")=Data
	k PLIST
	s PLIST(1)=$p($G(Data),"^",1)
	s gftrowid=PLIST(1)
	s PLIST(2)=$p($G(Data),"^",2)
	s PLIST(3)=$p($G(Data),"^",3)
	s PLIST(4)=$p($G(Data),"^",4)
	i (gftrowid="")
	{
		i (PLIST(4)="Y") &SQL(insert into sqluser.DHC_EQCGroupFundsType values :PLIST())
	}
	else
	{
		i (PLIST(4)="N")
		{
			&SQL(delete from SQLUser.DHC_EQCGroupFundsType where GFT_RowID=:gftrowid)
		}
		else 
		{
			&SQL(update  SQLUser.DHC_EQCGroupFundsType Values :PLIST() where GFT_RowID=:gftrowid)
		}
	}
	if SQLCODE  q SQLCODE
	q $g(%ROWID)
}

}
