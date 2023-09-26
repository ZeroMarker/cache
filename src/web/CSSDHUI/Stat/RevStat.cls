Class web.CSSDHUI.Stat.RevStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	接收工作量统计
/// Creator:	ljl
/// CreateDate:	2022-11-15
/// Table:		cssd_packagedisp CSSD_PackageDispMain
/// Input:		排序，查询条件,接收科室id
/// Return：	消毒包、科室跟踪信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.RevStat","QueryDetail",^tmpljlkk,"")
Query QueryDetail(Params As %Text, RRecLocId As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RecLocId,RecLocDesc,SupLocId,SupLocDesc,RecPrice:%Float,RecQty:%Float,SumPrice:%Float,RecTime,RecDate,PkgId,PkgDesc,PkgClassId,PkgClassDesc,PkgSpecId,PkgSpecDesc") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %Text, RRecLocId As %String = "") As %Status
{
	n (qHandle,Params,RRecLocId)
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
	s PPkgClassId=PJObj.%Get("PkgClass")
	s PPkgId=PJObj.%Get("PkgName")
	s PPkgSpecId=PJObj.%Get("PkgSpec")
	s gHospId=PJObj.%Get("gHospId")
	s PDocType=PJObj.%Get("DocType")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	i RRecLocId'="" s PRecLocId=RRecLocId		//PRecLocId科室接收详情链接传值
	s sql="SELECT main.CSSDPDM_ToLoc_DR as RecLocId,main.CSSDPDM_ToLoc_DR->CTLOC_Desc as RecLocDesc,main.CSSDPDM_FromLoc_Dr as SupLocId,"
		_" main.CSSDPDM_FromLoc_Dr->CTLOC_Desc as SupLocDesc,main.CSSDPDM_ReceiveDate as RecDate ,main.CSSDPDM_ReceiveTime as RecTime,"
		_" main.CSSDPDM_DocType as DocType,detail.CSSDPD_Package_DR as PkgId,detail.CSSDPD_Package_DR->CSSDP_Desc as PkgDesc,"
		_" detail.CSSDPD_DispPrice as RecPrice,detail.CSSDPD_Qty as RecQty"
		_" FROM CSSD_PackageDispMain main,cssd_packagedisp detail"
		_" where main.ID=detail.CSSDPD_Parref_DR and CSSDPDM_IsRec ='Y'"
		_" and CSSDPDM_ReceiveDate between "_PStartDate_" and "_PEndDate
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sql)
	d result.Execute()
	While(result.Next())
	{
		s RecLocId=result.Data("RecLocId")
		s RecLocDesc=result.Data("RecLocDesc")
		s SupLocId=result.Data("SupLocId")
		s SupLocDesc=result.Data("SupLocDesc")
		s PkgId=result.Data("PkgId")
		s PkgDesc=result.Data("PkgDesc")
		s RecPrice=result.Data("RecPrice")
		s RecDate=result.Data("RecDate")
		s RecTime=result.Data("RecTime")
		s DocType=result.Data("DocType") ;1-调拨类型发放单 空-发放单 0-全部
		s RecQty=result.Data("RecQty")
		s SumPrice=RecPrice*RecQty
		continue:((PStartTime'="")&&(RecTime<PStartTime))&&(RecDate=PStartDate)
		continue:((PEndTime'="")&&(RecTime>=PEndTime))&&(RecDate=PEndDate)
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",SupLocId,gHospId)
		continue:ShowDataFlag="N"
		s PkgClassId=$lg(^User.CSSDPackageD(PkgId),12)
		s PkgSpecId=$lg(^User.CSSDPackageD(PkgId),27)
		s:PkgClassId'="" PkgClassDesc=$lg(^User.CSSDPackageClassD(PkgClassId),2)
		s:PkgSpecId'="" PkgSpecDesc=$lg(^CT.STER.CSSD.PackageSpecD(PkgSpecId),3)
		continue:((PDocType'="0")&&(PDocType'=DocType)) 
		continue:((PRecLocId'="")&&(PRecLocId'=RecLocId))
		continue:((PSupLocId'="")&&(PSupLocId'=SupLocId))
		continue:((PPkgId'="")&&(PPkgId'=PkgId))
		continue:((PPkgClassId'="")&&(PPkgClassId'=PkgClassId))
		continue:((PPkgSpecId'="")&&(PPkgSpecId'=PkgSpecId))
		s RecTime=..TL2H(RecTime)
		s RecDate=..DL2H(RecDate)
		d OutputRow
	}
	d result.Close()
	q $$$OK
OutputRow
	s Data=$lb(RecLocId,RecLocDesc,SupLocId,SupLocDesc,RecPrice,RecQty,SumPrice,RecTime,RecDate,PkgId,PkgDesc,PkgClassId,PkgClassDesc,PkgSpecId,PkgSpecDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
