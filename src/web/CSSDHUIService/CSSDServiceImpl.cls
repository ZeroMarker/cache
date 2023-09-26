Import sqluser

/// Descript:	消毒供应第三方接口
Class web.CSSDHUIService.CSSDServiceImpl Extends %RegisteredObject
{

/// w ##class(web.CSSDHUIService.CSSDServiceImpl).CSSDService("LogOn","{""UserCode"":""demo"",""UserPassWord"":""dhcc""}")
ClassMethod CSSDService(RequestCode As %String, RequestXML As %String) As %String
{
	s Ret=""
	i (RequestCode="InsertTransOP") {
		;插入患者追踪信息
		s Ret=##class(web.CSSDHUI.Interface.CSSDTransOP).InsertTransOp(RequestXML)
	}
	elseif(RequestCode="DeleteTransOP")
	{
		;解绑患者信息
		s Ret=##class(web.CSSDHUI.Interface.CSSDTransOP).DeleteTransOP(RequestXML)
	}
	elseif(RequestCode="GetPackageItmByLabel")
	{
		;根据标签获取消毒包明细
		s Ret=##class(web.CSSDHUI.Interface.CSSDTransOP).GetPackageItmByLabel(RequestXML)
	}
	q Ret
}

///  手麻调用接口
///  Description:根据标签获取消毒包明细信息
///  input:标签
///  d ##class(%ResultSet).RunQuery("web.CSSDHUIService.CSSDServiceImpl","SelectByLabel","10000400100000301")
Query SelectByLabel(PackageLabel As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,ItmId,Desc,Spec,Qty:%Integer,ConsumeQty,ConsumeReasonId,ConsumeReasonDesc,NotUseFlag,Remarks,OneOffFlag") [ SqlProc ]
{
}

ClassMethod SelectByLabelExecute(ByRef qHandle As %Binary, PackageLabel As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:PackageLabel="" $$$OK
	
	s TransId="",PackageRowId=""
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",PackageLabel,""))
	q:TransId="" $$$OK
	
	s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	i $IsObject(TransObj) s PackageRowId=TransObj.CSSDTPackageGetObjectId()
	q:PackageRowId="" $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s ExtDev="",ExtDetailId=""
	i PackageLabel'="" d
	.s FixedLabel=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(PackageLabel)
	.s CodeLength=$l(FixedLabel)
	.s ExtDev=$o(^User.CSSDExtDevBindI("IndexCSSDExtLabel",$e(PackageLabel,1,CodeLength+6),0))	//判断条码是否在外来器械登记表中
	.i ExtDev'="" d
	..&sql(SELECT CSSDEBD_Rowid into:ExtDetailId from CSSD_ExtDevBindDetail WHERE CSSDEBD_Parref_DR=:ExtDev)
	
	i ExtDetailId="" d
	.s SqlStr = "SELECT ID As RowId ,CSSDPI_Itm_DR As ItmId ,CSSDPI_Qty As Qty From CSSD_PackageItem  where CSSDPI_Package_DR = "_PackageRowId_" "
	e  d
	.s SqlStr = "SELECT CSSDEBD_Rowid As RowId ,CSSDEBD_Itm_DR As ItmId,CSSDEBD_Qty As Qty From CSSD_ExtDevBindDetail where CSSDEBD_Label = '"_PackageLabel_"' "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ItmId = Result.Data("ItmId")
		s Qty = Result.Data("Qty")
		
		s Desc=$lg(^User.CSSDItemD(ItmId),2)
		s Spec=$lg(^User.CSSDItemD(ItmId),3)
		s Remarks=$lg(^User.CSSDItemD(ItmId),6)
		s OneOffFlag=$lg(^User.CSSDItemD(ItmId),9)
		s NotUseFlag=$lg(^User.CSSDItemD(ItmId),5)
		
		s (ConsumeQty,ConsumeReasonId)=""
		&sql(SELECT CSSDCD_ConsumeQty,CSSDCD_ConsumeReason_DR INTO ConsumeQty,ConsumeReasonId FROM CSSD_ConsumeDetail WHERE CSSDCD_Label=:PackageLabel AND CSSDCD_Itm_DR=:ItmId)
		s ConsumeReasonDesc=""
		i ConsumeReasonId'="" d
		.s NotUseFlag=$lg(^User.CSSDMachineConsumeReasonD(ConsumeReasonId),4)
		.s ConsumeReasonDesc=$lg(^User.CSSDMachineConsumeReasonD(ConsumeReasonId),3)
		d OutPutPackageItmRow
	}
	d Result.Close()
	Quit $$$OK
OutPutPackageItmRow
	s Data=$lb(RowId,ItmId,Desc,Spec,Qty,ConsumeQty,ConsumeReasonId,ConsumeReasonDesc,NotUseFlag,Remarks,OneOffFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
