Import sqluser

/// creator:yunhaibao
/// createdate:20160704
/// descirpiton:住院药房发药科室维护
Class web.DHCINPHA.PhaLocation Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160621
/// descirpiton:获取发药科室维护列表
/// w ##class(web.DHCINPHA.PhaLocation).jsQueryPhaLocation()
ClassMethod jsQueryPhaLocation(HospId = "")
{
    s $zt="ErrorjsQueryPhaLocation"
    s result=##class(%Library.ResultSet).%New("web.DHCINPHA.PhaLocation:QueryPhaLocation")
	s sc=result.Execute(HospId)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i i=1 s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1  //可做索引用
		I countrecords=1 d
		.w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(999)
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	i countrecords>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	q ""
ErrorjsQueryPhaLocation
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160621
/// descirpiton:获取发药科室对应发药类别列表
/// w ##class(web.DHCINPHA.PhaLocation).jsQueryPhaLocDispType()
ClassMethod jsQueryPhaLocDispType(params)
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    s $zt="ErrorjsQueryPhaLocDispType"
    s result=##class(%Library.ResultSet).%New("web.DHCINPHA.PhaLocation:QueryPhaLocDispType")
	s sc=result.Execute(+params)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1  //可做索引用
		I countrecords=1 d
		.w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(999)
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	i countrecords>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	q ""
ErrorjsQueryPhaLocDispType
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// w ##class(%ResultSet).RunQuery("web.DHCINPHA.PhaLocation","QueryPhaLocation")
Query QueryPhaLocation(HospId) As websys.Query(ROWSPEC = "phaLocation:%String,locRowId:%String,locDesc:%String,nurseAudit:%String,pharmacyAudit:%String,reserveFlag:%String,allResFlag:%String,machineFlag:%String,dispNoPrefix:%String,dispStartDate:%String,dispStartTime:%String,dispEndDate:%String,dispEndTime:%String,cacuStartDate:%String,cacuStartTime:%String,cacuEndDate:%String,cacuEndTime:%String,resStartDate:%String,resEndDate:%String,dealOrdFlag")
{
}

ClassMethod QueryPhaLocationExecute(ByRef qHandle As %Binary, HospId = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s plrowid=""
	f  s plrowid=$o(^DHCPL(plrowid)) q:plrowid=""  d
	.q:+plrowid=0
	.s plobj=##class(User.DHCPhaLocation).%OpenId(plrowid,0)
	.s phaLocation=plrowid
	.s locRowId=$s(plobj.PLCTLOCDR'="":plobj.PLCTLOCDR.%Id(),1:"")
	.q:+locRowId="0"
	.s locDesc=$p($g(^CTLOC(+locRowId)),"^",2)
	.q:(HospId'="")&&(HospId'=$p($g(^CTLOC(+locRowId)),"^",22))
	.i locDesc["-" s locDesc=$p(locDesc,"-",2)
	.s nurseAudit=plobj.PLAuditNeedFlag //领药审核
	.s pharmacyAudit=plobj.PLOrdAuditFlag //医嘱审核
	.s reserveFlag=plobj.PLReserveRetFlag //冲减
	.s allResFlag=plobj.PLRetAllFlag
	.s machineFlag=plobj.PLSendMachine
	.s dispNoPrefix=plobj.PLCountPrefix
	.s dispStartDate=plobj.PLDispStartDate
	.s dispStartTime=plobj.PLDispStartTime
	.s dispEndDate=plobj.PLDispEndDate
	.s dispEndTime=plobj.PLDispEndTime
	.s cacuStartDate=plobj.PLStatStartDate
	.s cacuStartTime=plobj.PLStatStartTime
	.s cacuEndDate=plobj.PLStatEndDate
	.s cacuStartTime=plobj.PLStatEndTime
	.s resStartDate=plobj.PLRetStDate
	.s resEndDate=plobj.PLRetEndDate
	.s dealOrdFlag=plobj.PLDealOrdFlag
	.d outputrow
	q $$$OK
outputrow
	s Data=$lb(	phaLocation,locRowId,locDesc,nurseAudit,pharmacyAudit,reserveFlag,allResFlag,machineFlag,
	dispNoPrefix,dispStartDate,dispStartTime,dispEndDate,dispEndTime,
	cacuStartDate,cacuStartTime,cacuEndDate,cacuEndTime,resStartDate,
	resEndDate,dealOrdFlag)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// w ##class(%ResultSet).RunQuery("web.DHCINPHA.PhaLocation","QueryPhaLocDispType","2")
Query QueryPhaLocDispType(parref As %String) As websys.Query(ROWSPEC = "RowId:%String,DispTypeDR:%String,DispTypeDesc:%String,DispTypeDefault:%String,ImPermitReqFlag:%String")
{
}

ClassMethod QueryPhaLocDispTypeExecute(ByRef qHandle As %Binary, parref As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:parref="" $$$OK
	s plsub=""
	f  s plsub=$o(^DHCPL(parref,"DIS",plsub)) q:plsub=""  d
	.q:+plsub=0
	.s RowId=parref_"||"_plsub
	.s DispTypeDR=$p(^DHCPL(parref,"DIS",plsub),"^",1)
	.s DispTypeDesc=""
	.i (DispTypeDR'="") d 
	..i $d(^DHCSTDRUGGRP(DispTypeDR)) s DispTypeDesc=$p(^DHCSTDRUGGRP(DispTypeDR),"^",2)
	.s DispTypeDefault=$p(^DHCPL(parref,"DIS",plsub),"^",5)
	.s ImPermitReqFlag=$p(^DHCPL(parref,"DIS",plsub),"^",6)
	.d outputrow
	q $$$OK
outputrow
	s Data=$lb(RowId,DispTypeDR,DispTypeDesc,DispTypeDefault,ImPermitReqFlag)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// 修改科室发药类别默认状态
ClassMethod UpdateDefLocDispType(rowid, flag)
{
 	q:rowid="" -1
 	&SQL(UPDATE DHC_PhaLocDisType SET PLDP_DefaultFlag=:flag WHERE PLDP_Rowid=:rowid)
 	q SQLCODE
}

/// 修改科室发药类别禁止退药申请状态
ClassMethod UpdateImPermitReqFlag(rowid, flag)
{
 	q:rowid="" -1
 	&SQL(UPDATE DHC_PhaLocDisType SET PLDP_ImPermitReqFlag=:flag WHERE PLDP_Rowid=:rowid)
 	q SQLCODE
}

/// description: 不需要领药审核的医嘱子类
/// w ##class(%ResultSet).RunQuery("web.DHCINPHA.PhaLocation","LocArcCatConfig","98")
Query LocArcCatConfig(PhaLocId = "", HospId = "") As websys.Query(ROWSPEC = "arcCatId,arcCatDesc,passAudit")
{
}

ClassMethod LocArcCatConfigExecute(ByRef qHandle As %Binary, PhaLocId As %String, HospId = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:PhaLocId="" $$$OK
	s arcCatId=""
	f  s arcCatId=$o(^ARC("IC",0,"OrderType","R",arcCatId)) q:arcCatId=""  d
	.q:+arcCatId=0
	.s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("ARC_ItemCat",arcCatId,HospId) //医院级别授权
	.q:flag="N"
	.s passAudit="N"
	.i PhaLocId'="" d
	..s placId=$o(^CF.PHA.IP.LOCARCCATi("LOCARCCAT",PhaLocId,arcCatId,""))
	..i placId'="" d
	...s passAudit=$p($g(^CF.PHA.IP.LOCARCCAT(placId)),"^",3)
	.s arcCatDesc=$p(^ARC("IC",arcCatId),"^",2)
	.i passAudit="Y" s sortIndex=1
	.e  s sortIndex=2
	.s LocArcCatConfigData(sortIndex,arcCatId)=arcCatId_"^"_arcCatDesc_"^"_passAudit
	s sortIndex=""
	f  s sortIndex=$o(LocArcCatConfigData(sortIndex)) q:sortIndex=""  d
	.s arcCatId=""
	.f  s arcCatId=$o(LocArcCatConfigData(sortIndex,arcCatId)) q:arcCatId=""  d
	..s outputData=LocArcCatConfigData(sortIndex,arcCatId)
	..s ^CacheTemp(repid,ind)=$lfs(outputData,"^")	
	..s ind=ind+1
	q $$$OK
}

/// description: 更新不需要领药审核的医嘱子类
/// table:		 PHAIP_LocArcCat
ClassMethod SavePHAIPLocArcCat(LocId, ArcCatId, InputStr)
{
	q:LocId="" "-1^科室Id为空"
	q:ArcCatId="" "-1^医嘱子类为空"
	s PassAudit=$p(InputStr,"^",1)
	s placId=$o(^CF.PHA.IP.LOCARCCATi("LOCARCCAT",LocId,ArcCatId,""))
	if placId'=""{
		&SQL(
		 	UPDATE PHAIP_LocArcCat 
		 	SET PLAC_PassAudit=:PassAudit
		 	WHERE PLAC_RowId=:placId
		)
	}else{
		&SQL(
		 	INSERT INTO PHAIP_LocArcCat 
		 	(PLAC_Loc_Dr,PLAC_ArcCat_Dr,PLAC_PassAudit)
			VALUES
			(:LocId,:ArcCatId,:PassAudit)
		)	
	}
	q:SQLCODE'=0 "-1^设置失败,SQLCODE:"_SQLCODE_",msg:"_$g(%msg)
	q 0
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

}
