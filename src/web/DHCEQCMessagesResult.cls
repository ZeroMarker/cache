/// -------------------------------
/// 创建:zy 2010-12-28
/// 描述:消息结果描述
/// --------------------------------
Class web.DHCEQCMessagesResult Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:zy 2010-12-28
/// 描述:消息结果查询
/// 访问表:DHC_EQMessagesResult
/// ----------------------------------
Query GetMessagesResult(ValBussType As %String = "", ValCode As %String = "", ValDesc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TBussType:%String,TCode:%String,TDesc:%String,TIsNomalFlag:%String,TRemark:%String,TInvalidFlag:%String,THold1:%String,THold2:%String,THold3:%String,TRow:%String")
{
}

ClassMethod GetMessagesResultExecute(ByRef qHandle As %Binary, ValBussType As %String = "", ValCode As %String = "", ValDesc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s BussTypeID=""		// MZY0024	1312306		2020-05-09	修正初始赋值
	for  s BussTypeID=$o(^DHCEQCCode("DHCEQCMessagesResult",0,"BussType",BussTypeID)) q:BussTypeID=""  d
	.q:(ValBussType'="")&&(BussTypeID'=ValBussType)
	.s rowid=0
	.for  s rowid=$o(^DHCEQCCode("DHCEQCMessagesResult",0,"BussType",BussTypeID,rowid)) q:rowid=""  d
	..d ResetVariablesMessagesResult
	..s TRowID=rowid
	..s TBussType=$p($g(^DHCEQCCode("DHCEQCMessagesResult",rowid)),"^",1)
	..s TBussType=##class(web.DHCEQFind).GetBussTypeDesc(TBussType)
	..s TCode=$p($g(^DHCEQCCode("DHCEQCMessagesResult",rowid)),"^",2)
	..q:(ValCode'="")&&(ValCode'[TCode)
	..s TDesc=$p($g(^DHCEQCCode("DHCEQCMessagesResult",rowid)),"^",3)
	..q:(ValDesc'="")&&(ValDesc'[TDesc)
	..s TIsNomalFlag=$p($g(^DHCEQCCode("DHCEQCMessagesResult",rowid)),"^",4)
	..i TIsNomalFlag'="" s TIsNomalFlag=##class(web.DHCEQCommon).TransValueToPage(TIsNomalFlag,"bool")
	..s TRemark=$p($g(^DHCEQCCode("DHCEQCMessagesResult",rowid)),"^",5)
	..s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMessagesResult",rowid)),"^",6)
	..q:TInvalidFlag="Y"
	..s THold1=$p($g(^DHCEQCCode("DHCEQCMessagesResult",rowid)),"^",7)
	..s THold2=$p($g(^DHCEQCCode("DHCEQCMessagesResult",rowid)),"^",8)
	..s THold3=$p($g(^DHCEQCCode("DHCEQCMessagesResult",rowid)),"^",9)
	..d OutputRowMessagesResult
	Quit $$$OK
OutputRowMessagesResult
	set Data=$lb(TRowID,TBussType,TCode,TDesc,TIsNomalFlag,TRemark,TInvalidFlag,THold1,THold2,THold3,TRow)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesMessagesResult
	s (TRowID,TBussType,TCode,TDesc,TIsNomalFlag,TRemark,TInvalidFlag,THold1,THold2,THold3)=""
	quit
}

ClassMethod GetMessagesResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessagesResultExecute ]
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

ClassMethod GetMessagesResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessagesResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 创建:zy 2010-12-28
/// w ##Class(web.DHCEQMessagesResult).GetOneMessagesResult("2")
ClassMethod GetOneMessagesResult(rowid)
{
	new (rowid)
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCMessagesResult",rowid)
	s resultex=resultex_"^"	;BussType
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_##class(web.DHCEQFind).GetBussTypeDesc($p(result,"^",1))
	s resultex=resultex_"^"	;IsNomalFlag
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"bool")
	s resultex=resultex_"^"	;InvalidFlag
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"bool")
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// ----------------------------------
/// 创建:zy 2010-12-28
/// 描述:新增、更新
/// w ##Class(web.DHCEQCMessagesResult).SaveData(0,"^11^2^描述2^^^^^^")
/// ----------------------------------
ClassMethod SaveData(appType, val)
{
	new (appType,val)
	k PLIST
	Set $ZT="ERRORSave"
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID = $p(val,"^",1)	;RowID
	s PLIST(2) = $p(val,"^",2)	;BussType
	s PLIST(3) = $p(val,"^",3)	;Code
	s PLIST(4) = $p(val,"^",4)	;Desc
	i $p(val,"^",5)'="" s PLIST(5) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")	;IsNomalFlag
	s PLIST(6) = $p(val,"^",6)	;Remark
	i $p(val,"^",7)'="" s PLIST(7) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"bool")	;InvalidFlag
	s PLIST(8) = $p(val,"^",8)	;Hold1
	s PLIST(9) = $p(val,"^",9)	;Hold2
	s PLIST(10) = $p(val,"^",10)	;Hold3
	TSTART
	if +appType=0
	{
		&SQL(select MR_RowID into:tmp from sqluser.DHC_EQCMessagesResult where MR_BussType=:PLIST(2) and MR_Code=:PLIST(3) and MR_Desc=:PLIST(4) and MR_InvalidFlag<>'Y')
		if tmp=""
		{
			&SQL(insert into sqluser.DHC_EQCMessagesResult values :PLIST())
		}
	}
	elseif +appType=1
	{
		&SQL(update sqluser.DHC_EQCMessagesResult values :PLIST() where MR_RowID=:RowID)
	}
	elseif +appType=2
	{
		&SQL(update sqluser.DHC_EQCMessagesResult set MR_InvalidFlag='Y' where MR_RowID=:RowID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s RowID=$G(%ROWID)
 	TCOMMIT
 	q RowID
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

}
