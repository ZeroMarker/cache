Class web.DHCANOPSterilityPack Extends %RegisteredObject
{

/// Creator: 陈长青
/// CreatDate: 2015-08-20
/// Description: 取无菌包检查情况信息
/// Table：DHC_AN_OPSterilityPack
/// Input：OpaId:手术申请ID
/// Return：无菌包检查ID 无菌包条码号 无菌包名称 无菌包灭菌时间 无菌包失效时间 无菌包是否合格
/// d ##class(%ResultSet).RunQuery("web.DHCANOPSterilityPack","FindSterilityPacks","98")
Query FindSterilityPacks(opaId) As %Query(ROWSPEC = "Id,PackNo,PackDesc,SterilizingDate,SterilizingTime,ExpiredDate,ExpiredTime,Qualified,QualifiedDesc")
{
}

ClassMethod FindSterilityPacksExecute(ByRef qHandle As %Binary, opaId) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s dateformatnum=##class(websys.Conversions).DateFormat()
	set packId=0
	for
	{
		set packId=$order(^DHCANOPSterilityPack(0,"OPA",opaId,packId))
		quit:(packId="")
		set packInfo=^DHCANOPSterilityPack(packId)
		set packNo=$list(packInfo,3)
		set packDesc=$list(packInfo,2)
		set sterilizingDate=$list(packInfo,4)
		set sterilizingTime=$list(packInfo,5)
		set sterilizingTime=$zt(sterilizingTime,2)
		set sterilizingDate=$zd(sterilizingDate,dateformatnum)
		;set sterilizingDT=##class(web.DHCANOPCom).ConvertToDateTime(sterilizingDate,sterilizingTime)
		set expiredDate=$list(packInfo,6)
		set expiredDate=$zd(expiredDate,dateformatnum)
		set expiredTime=$list(packInfo,7)
		set expiredTime=$zt(expiredTime,2)
		;set expiredDT=##class(web.DHCANOPCom).ConvertToDateTime(expiredDate,expiredTime)
		set qualified=$list(packInfo,8)
		set qualifiedDesc="是"
		if (qualified'="Y")	set qualifiedDesc="否"
		
		do OutputRow
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(packId,packNo,packDesc,sterilizingDate,sterilizingTime,expiredDate,expiredTime,qualified,qualifiedDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSterilityPacksFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSterilityPacksExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindSterilityPacksClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSterilityPacksExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: 陈长青
/// CreatDate: 2015-08-20
/// Description: 保存无菌包检查情况
/// Table：DHC_AN_OPSterilityPack
/// Input：OpaId:手术申请ID,packParam:无菌包信息
/// Return：成功返回无菌包检查ID，失败返回错误原因
/// w ##class(web.DHCANOPSterilityPack).SaveSterilityPack("98","^0001^test^2015-08-20 14:00^2015-08-20 16:00^Y")
ClassMethod SaveSterilityPack(opaId, packParam) As %String
{
	quit:('##class(User.DHCANOPArrange).%ExistsId(opaId)) "手术申请ID不正确！"
	
	set $zt="Error"
	
	set packId=$piece(packParam,"^",1)
	set pack=""
	if (##class(User.DHCANOPSterilityPack).%ExistsId(packId))
	{
		set pack=##class(User.DHCANOPSterilityPack).%OpenId(packId)	
	}	
	else
	{
		set pack=##class(User.DHCANOPSterilityPack).%New()	
	}
	
	
	set pack.SPOPADR=##class(User.DHCANOPArrange).%OpenId(opaId)
	set pack.SPNo=$piece(packParam,"^",2)
	set pack.SPDesc=$piece(packParam,"^",3)
	
	set sterilizingDate=$piece(packParam,"^",4)
	set sterilizingDateH=##class(web.DHCANOPCom).ConvertToDateH(sterilizingDate)
	set pack.SPSterilizingDate=sterilizingDateH
	set sterilizingTime=$piece(packParam,"^",5)
	set sterilizingTimeH=##class(web.DHCANOPCom).ConvertToTimeH(sterilizingTime)
	set pack.SPSterilizingTime=sterilizingTimeH
	
	set expiredDate=$piece(packParam,"^",6)
	set expiredDateH=##class(web.DHCANOPCom).ConvertToDateH(expiredDate)
	set pack.SPExpiredDate=expiredDateH
	set expiredTime=$piece(packParam,"^",7)
	set expiredTimeH=##class(web.DHCANOPCom).ConvertToTimeH(expiredTime)
	set pack.SPExpiredTime=expiredTimeH
	
	set pack.SPQualified=$piece(packParam,"^",8)
	do pack.%Save()
	
	quit pack.%Id()
	
Error
	Quit "错误信息："_$ZE
}

/// Creator: 陈长青
/// CreatDate: 2015-08-20
/// Description: 删除无菌包检查情况
/// Table：DHC_AN_OPSterilityPack
/// Input：packId:无菌包检查ID
/// Return：成功返回0，失败返回错误原因
/// w ##class(web.DHCANOPSterilityPack).RemoveSterilityPack("98")
ClassMethod RemoveSterilityPack(packId) As %String
{
	quit:('##class(User.DHCANOPSterilityPack).%ExistsId(packId)) "不存在该无菌包检查情况"
	
	&sql(delete from SQLUser.DHC_AN_OPSterilityPack where %ID=:packId)
	
	quit:(SQLCODE'=0) $System.SQL.SQLCODE(SQLCODE)
	
	quit "0"
}

}
