Class web.CSSDHUI.Stat.CallBackStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:统计回收表数据
/// Creator:why
/// CreateDate:2019-9-2
/// Table:cssd_packagecallback
/// Input:排序，查询条件
/// Return:消毒包回收信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.CallBackStat","QueryDetail","{""DateType"":""4"",""gUserId"":""13922"",""gLocId"":""396"",""gGroupId"":""102"",""gHospId"":""3"",""SupLoc"":"""",""RecLoc"":"""",""PackageClass"":"""",""PackName"":"""",""PackageSpec"":"""",""ConsumeFlag"":"""",""StartDate"":""2022-10-01"",""StartTime"":""22:00:00"",""EndDate"":""2022-11-14"",""EndTime"":""21:00:00""}","","")
Query QueryDetail(Params As %Text, RPkgId As %String = "", RRecLocId As %String = "") As web.CSSDHUI.Query(ROWSPEC = "ToLocId,ToLocDesc,FromLocId,FromLocDesc,CallBackNo,CallBackDate,PkgId,PkgDesc,UnitPrice:%Float,Qty:%Float,SumPrice:%Float") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %Text, RPkgId As %String = "", RRecLocId As %String = "") As %Status
{
	n (qHandle,Params,RPkgId,RRecLocId)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PSupLocId=PJObj.%Get("SupLoc")
	s PRecLocId=PJObj.%Get("RecLoc")
	s PPkgClassId=PJObj.%Get("PackageClass")
	s PPkgId=PJObj.%Get("PackName")
	s PSpecId=PJObj.%Get("PackageSpec")  
	s gHospId=PJObj.%Get("gHospId")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	s sql="SELECT main.CSSDPC_Date AS CallBackDate,main.CSSDPC_Time AS CallbackTime,"
		_" main.CSSDPC_ToLoc_Dr as ToLocId ,main.CSSDPC_ToLoc_Dr->CTLOC_Desc as ToLocDesc,"
		_" main.CSSDPC_FromLoc_Dr as FromLocId,main.CSSDPC_FromLoc_Dr->CTLOC_Desc as FromLocDesc,"
		_" detail.CSSDCD_Package_DR as PkgId,detail.CSSDCD_Package_DR->CSSDP_Desc as PkgDesc,"
		_" detail.CSSDCD_Price as UnitPrice,detail.CSSDCD_Qty as Qty,main.CSSDPC_SerialNo as CallBackNo"
		_" FROM CSSD_PackageCallback main,CSSD_CallBackDetailNew detail"
		_" where main.CSSDPC_Rowid=detail.CSSDCD_Parref_DR"
		_" and main.CSSDPC_Date between "_PStartDate_" and "_PEndDate
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sql)
	d result.Execute()
	While(result.Next())
	{
		s CallBackDate=result.Data("CallBackDate")
		s CallBackTime=result.Data("CallbackTime")
		s CallBackNo=result.Data("CallBackNo")
		s ToLocId=result.Data("ToLocId")
		s ToLocDesc=result.Data("ToLocDesc")
		s FromLocId=result.Data("FromLocId") 
		s FromLocDesc=result.Data("FromLocDesc")
		s PkgId=result.Data("PkgId")
		s PkgDesc=result.Data("PkgDesc")
		s UnitPrice=result.Data("UnitPrice")
		s Qty=result.Data("Qty")
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",FromLocId,gHospId)
		continue:ShowDataFlag="N"
		continue:((PPkgId'="")&&(PPkgId'=PkgId))
		continue:((RPkgId'="")&&(RPkgId'=PkgId))
		continue:((PStartTime'="")&&(CallBackTime<PStartTime))&&(CallBackDate=PStartDate)
		continue:((PEndTime'="")&&(CallBackTime>=PEndTime))&&(CallBackDate=PEndDate)
		continue:(PSupLocId'="")&&(ToLocId'=PSupLocId)
		continue:(PRecLocId'="")&&(FromLocId'=PRecLocId)
		continue:(RRecLocId'="")&&(FromLocId'=RRecLocId)
		s PkgClassId=$lg(^User.CSSDPackageD(PkgId),12)
		s SpecId=$lg(^User.CSSDPackageD(PkgId),27)
		continue:((PPkgClassId'="")&(PPkgClassId'=PkgClassId))
		continue:((PSpecId'="")&(PSpecId'=SpecId))
		s CallBackDate=..DL2H(CallBackDate)
		s CallBackTime=..TL2H(CallBackTime)
		s CallBackDate=CallBackDate_" "_CallBackTime
		s SumPrice=UnitPrice*Qty
		d OutputRow
	}
	d result.Close()
	q $$$OK
OutputRow
	s Data=$lb(ToLocId,ToLocDesc,FromLocId,FromLocDesc,CallBackNo,CallBackDate,PkgId,PkgDesc,UnitPrice,Qty,SumPrice)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 报损登记汇总
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.CallBackStat","QueryDetailByConsume",^tmpmy("vf"))
Query QueryDetailByConsume(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "ToLocId,ToLocDesc,FromLocId,FromLocDesc,CallBackDate,PkgItmId,PkgItmDesc,UnitPrice:%Float,Qty:%Integer,SumPrice:%Float,ConsumeReasonDesc") [ SqlProc ]
{
}

ClassMethod QueryDetailByConsumeExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PSupLocId=PJObj.%Get("SupLoc")
	s PRecLocId=PJObj.%Get("RecLoc")
	s PConsumeFlag=PJObj.%Get("ConsumeFlag")
	s gHospId=PJObj.%Get("gHospId")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	s sqlstra="SELECT main.CSSDPC_Date AS CallBackDate,main.CSSDPC_Time AS CallBackTime,"
		_" main.CSSDPC_ToLoc_Dr as ToLocId,main.CSSDPC_ToLoc_Dr->CTLOC_Desc as ToLocDesc,"
		_" main.CSSDPC_FromLoc_Dr as FromLocId,main.CSSDPC_FromLoc_Dr->CTLOC_Desc as FromLocDesc,"
		_" detail.CSSDCD_Itm_DR AS PkgItmId,detail.CSSDCD_Itm_DR->CSSDI_Desc as PkgItmDesc,"
		_" detail.CSSDCD_Itm_DR->CSSDI_Price AS UnitPrice,detail.CSSDCD_ConsumeQty AS Qty,"
		_" detail.CSSDCD_ConsumeReason_DR AS ConsumeReasonId"
		_" FROM CSSD_PackageCallback main,CSSD_ConsumeDetail detail"
		_" WHERE main.CSSDPC_Rowid=detail.CSSDCD_Callback_Dr "
	s sqlstrb="SELECT CSSDUD_MainDr->CSSDU_Date as CallBackDate,CSSDUD_MainDr->CSSDU_Time AS CallBackTime,"
		_" '' AS ToLocId,'' AS ToLocDesc,CSSDUD_MainDr->CSSDU_Loc AS FromLocId,"
		_" CSSDUD_MainDr->CSSDU_Loc->CTLOC_Desc as FromLocDesc,CSSDUD_Item AS PkgItmId,"
		_" CSSDUD_Item->CSSDI_Desc AS PkgItmDesc,CSSDUD_Item->CSSDI_Price AS UnitPrice, CSSDUD_Num AS Qty,"
		_" CSSDUD_ConsumeReason_DR AS ConsumeReasonId FROM CSSD_UllageDetail"
	i PConsumeFlag="" d
	.s sqlstr=sqlstra_" union all "_sqlstrb
	e  i PConsumeFlag=1 d
	.s sqlstr=sqlstra
	e  i PConsumeFlag=2 d
	.s sqlstr=sqlstrb
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlstr)
	d result.Execute()
	While(result.Next())
	{
		s CallBackDate=result.Data("CallBackDate")
		s CallBackTime=result.Data("CallBackTime")
		s ToLocId=result.Data("ToLocId")
		s ToLocDesc=result.Data("ToLocDesc")
		s FromLocId=result.Data("FromLocId") 
		s FromLocDesc=result.Data("FromLocDesc")
		s PkgItmId=result.Data("PkgItmId")
		s PkgItmDesc=result.Data("PkgItmDesc")
		s UnitPrice=result.Data("UnitPrice")
		s Qty=result.Data("Qty")
		s ConsumeReasonId=result.Data("ConsumeReasonId")
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",FromLocId,gHospId)
		continue:ShowDataFlag="N"
		continue:((PStartDate'="")&&(CallBackDate<PStartDate))
		continue:((PEndDate'="")&&(CallBackDate>PEndDate))
		continue:((PStartTime'="")&&(CallBackTime<PStartTime))&&(CallBackDate=PStartDate)
		continue:((PEndTime'="")&&(CallBackTime>=PEndTime))&&(CallBackDate=PEndDate)
		continue:(PConsumeFlag=1)&&(PSupLocId'="")&&(ToLocId'=PSupLocId)
		continue:(PRecLocId'="")&&(FromLocdr'=PRecLocId)
		s CallBackDate=..DL2H(CallBackDate)
		s CallBackTime=..TL2H(CallBackTime)
		s CallBackDate=CallBackDate_" "_CallBackTime
		s SumPrice=UnitPrice*Qty
		s ConsumeReasonDesc=""
		i ConsumeReasonId'="" d
		.s ConsumeReasonDesc=$lg(^User.CSSDMachineConsumeReasonD(ConsumeReasonId),3)
		d OutputBackConsumeDetailRow
	}
	d result.Close()
	q $$$OK
OutputBackConsumeDetailRow
	s Data=$lb(ToLocId,ToLocDesc,FromLocId,FromLocDesc,CallBackDate,PkgItmId,PkgItmDesc,UnitPrice,Qty,SumPrice,ConsumeReasonDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
