Import sqluser

/// Descript:	采购计划制单模板
Class web.DHCSTMHUI.INPurPlanMould Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询采购计划单模板
/// Creator:	wangjiabin
/// CreateDate:	2020-05-14
/// Table:		IN_PurPlan
/// Input:		Params(PurLoc:制单科室)
/// Return：	采购计划单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPurPlanMould","QueryMould","{""PurLoc"":""326"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""MouldFlag"":""Y""}")
Query QueryMould(Params As %String) As Query(ROWSPEC = "RowId,PurNo,PurLocId,PurLoc,CreateDate,CreateUser,StkScgId,StkScg,CompFlag,AuditFlag,PoFlag,RefuseCase") [ SqlProc ]
{
}

ClassMethod QueryMouldExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s ^bintmp(25)=$lb(Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s pPurLocId=PJObj.%Get("PurLoc")	//模板标记(Y/N)
	s pMouldFlag=PJObj.%Get("MouldFlag")	//模板标记(Y/N)
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s:pMouldFlag="" pMouldFlag="N"
	
	s Type=..sssCode()
	s pHospId=..sssHospId(pPurLocId)
	s:pHospId="" pHospId=gHospId
	s StkGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,Type,pPurLocId,"",pHospId)
	
	s SqlStr="select INPP_Rowid RowId,"
		_"INPP_No PurNo,"
		_"INPP_CTLOC_DR PurLocId,"
		_"INPP_CTLOC_DR->CTLOC_Desc PurLoc,"
		_"INPP_Date CreateDate,"
		_"INPP_SSUSR_DR->SSUSR_Name CreateUser,"
		_"INPP_SCG_DR StkScgId,"
		_"INPP_Complete CompFlag,"
		_"INPP_AuditFlag AuditFlag,"
		_"INPP_PoFlag PoFlag,"
		_"INPP_RefuseCase RefuseCase" 
		_" from IN_PurPlan"
		_" where INPP_MouldFlag='Y' and INPP_CTLOC_DR="_pPurLocId_" and INPP_StkType='"_Type_"'"
		_" order by INPP_Rowid desc"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s PurNo = Result.Data("PurNo")
		;continue:(pPurNo'="")&&(pPurNo'=PurNo)
		s CreateDate = Result.Data("CreateDate")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s PurLocId = Result.Data("PurLocId")
		s PurLoc = Result.Data("PurLoc")
		s CreateUser = Result.Data("CreateUser")
		s StkScgId = Result.Data("StkScgId")
		continue:(StkScgId'="")&&(StkGrpStr'="")&&(("^"_StkGrpStr_"^")'[("^"_StkScgId_"^"))
		s StkScg=""
		s:StkScgId'="" StkScg=$p(^DHCSCG(StkScgId),"^",2)
		s CompFlag = Result.Data("CompFlag")
		s:CompFlag="" CompFlag="N"
		;i pCompFlag'="" continue:pCompFlag'=CompFlag
		s AuditFlag = Result.Data("AuditFlag")
		s:AuditFlag="" AuditFlag="N"
		;i pAuditFlag'="" continue:pAuditFlag'=AuditFlag
		s PoFlag = Result.Data("PoFlag")
		s RefuseCase = Result.Data("RefuseCase")
		;i pVendorId'="" continue:..ExistVendor(pVendorId,RowId)="N"
		;i (pInciId'="")!(pInciDesc'="") continue:..ExistInci(pInciId,pInciDesc,RowId)="N"
		;i pStkCatId'="" continue:..ExistStkCat(pStkCatId,RowId)="N"
		d OutPutMouldRow
	}
	Quit $$$OK
OutPutMouldRow
	s Data=$lb(RowId,PurNo,PurLocId,PurLoc,CreateDate,CreateUser,StkScgId,StkScg,CompFlag,AuditFlag,
		PoFlag,RefuseCase)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
