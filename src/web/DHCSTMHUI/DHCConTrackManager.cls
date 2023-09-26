Import sqluser

Class web.DHCSTMHUI.DHCConTrackManager Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:查询供应商合同信息
/// Creator:	tsr
/// CreatDate:	2018-08-23
/// Table:		DHC_Contrack
/// Input:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCConTrackManager","QueryCont","{""Vendor"":"""",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""ContractNo"":"""",""Remark"":"""",""BDPHospital"":""3""}")
Query QueryCont(Params As %String) As Query(ROWSPEC = "RowId,ContractNo,Remark,Vendor,StartDate,EndDate,LcFlag,StopFlag,VendorDesc,Status,CompFlag,AuditFlag,AuditDate,AuditUser,ConLocId,ConLocDesc") [ SqlProc ]
{
}

ClassMethod QueryContExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pRowId=PJObj.%Get("RowId")
	s pContractNo=PJObj.%Get("ContractNo")
	s pRemark=PJObj.%Get("Remark")
	s pConLoc=PJObj.%Get("ConLoc")
	s pVendor=PJObj.%Get("Vendor")
	s pCompFlag=PJObj.%Get("CompFlag")
	s pAuditFlag=PJObj.%Get("AuditFlag")
	s pStartDate=PJObj.%Get("StartDate")
	s pEndDate=PJObj.%Get("EndDate")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s DateMon1=$zdh($p($SYSTEM.SQL.DATEADD("mm",1,$zd(+$h,3))," "),3)
	s DateMon3=$zdh($p($SYSTEM.SQL.DATEADD("mm",3,$zd(+$h,3))," "),3)
	
	s SqlStr="SELECT * FROM DHC_Contrack WHERE 1=1"
	i pRowId'="" d
	.s SqlStr=SqlStr_" and %id="_pRowId
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("Cont_RowId")
		s ContractNo = xrs.Data("Cont_No")
		s Remark = xrs.Data("Cont_Remark")
		s ConLocId=xrs.Data("Cont_CTLOC_DR")
		s Vendor = xrs.Data("Cont_APCVM_DR")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("APC_Vendor",Vendor,gHospId)
		continue:ShowDataFlag="N"
		s StartDate = xrs.Data("Cont_Date")
		s EndDate = xrs.Data("Cont_EndDate")
		s LcFlag = xrs.Data("Cont_LcFlag")
		s StopFlag = xrs.Data("Cont_StopFlag")
		s CompFlag=xrs.Data("Cont_CompFlag")
		s AuditFlag=xrs.Data("Cont_AuditFlag")
		s AuditDate=xrs.Data("Cont_AuditDate")
		s AuditUserId=xrs.Data("Cont_AuditUser_DR")
		s:CompFlag="" CompFlag="N"
		s:AuditFlag="" AuditFlag="N"
		continue:(pRowId="")&&(pCompFlag'="")&&(pCompFlag'=CompFlag)
		continue:(pRowId="")&&(pAuditFlag'="")&&(pAuditFlag'=AuditFlag)
		continue:(pRowId="")&&(pConLoc'="")&&(pConLoc'=ConLocId)
		continue:(pRowId="")&&(pVendor'="")&&(pVendor'=Vendor)
		continue:(pRowId="")&&(pContractNo'="")&&(ContractNo'[pContractNo)
		continue:(pRowId="")&&(pRemark'="")&&(Remark'[pRemark)
		
		;按审核日期过滤
		continue:(pAuditFlag="Y")&&(pStartDate'="")&&(AuditDate<pStartDate)
		continue:(pAuditFlag="Y")&&(pEndDate'="")&&(AuditDate>pEndDate)
		
		;0:正常, -1:已过期, 1-一个月警示, 3-三个月警示
		s Status=0
		i EndDate="" d
		.s Status=0
		e  i EndDate<$h d
		.s Status=-1
		e  i (+$h<=EndDate)&&(EndDate<DateMon1) d
		.s Status=1
		e  i (DateMon1<=EndDate)&&(EndDate<DateMon3) d
		.s Status=3
		
		s ConLocDesc=$s(ConLocId'="":$p(^CTLOC(ConLocId),"^",2),1:"")
		s VendorDesc = $s(Vendor'="":$p($g(^APC("APCVM",Vendor)),"^",3),1:"")
		s:StartDate'="" StartDate = ..DL2H(StartDate)
		s:EndDate'="" EndDate = ..DL2H(EndDate)
		s AuditDate=..DL2H(AuditDate)
		s AuditUser=$s(AuditUserId'="":$p(^SSU("SSUSR",AuditUserId),"^",2),1:"")
		d OutPutRow
	}
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,ContractNo,Remark,Vendor,StartDate,EndDate,LcFlag,StopFlag,VendorDesc,Status,
		CompFlag,AuditFlag,AuditDate,AuditUser,ConLocId,ConLocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:根据合同Id查询供应商合同信息
/// Creator:	tsr
/// CreatDate:	2018-08-23
/// Table:		DHC_Contrack
/// Input:		合同Id
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).SelectCont(10)
ClassMethod SelectCont(ContId As %String) As %Library.String
{
	n (ContId)
	q:ContId="" ""
	&sql(select Cont_No,Cont_Remark,Cont_Date,Cont_EndDate,Cont_APCVM_DR,
		Cont_LcFlag,Cont_StopFlag,Cont_CTLOC_DR
		into
		:ContractNo,:Remark,:StartDate,:EndDate,:Vendor,
		:LcFlag,:StopFlag,:ConLocId
		from DHC_Contrack where Cont_RowId=:ContId)
	q:SQLCODE'=0 "{}"
	s:StartDate'="" StartDate=..DL2H(StartDate)
	s:EndDate'="" EndDate=..DL2H(EndDate)
	s VendorDesc=$s(Vendor'="":$p($g(^APC("APCVM",Vendor)),"^",3),1:"")
	s ConLocDesc=$s(ConLocId'="":$p(^CTLOC(ConLocId),"^",2),1:"")
	s Vendor=..sssComboStr(Vendor,VendorDesc)
	s ConLoc=..sssComboStr(ConLocId,ConLocDesc)
	s Data=ContractNo_"^"_Remark_"^"_StartDate_"^"_EndDate_"^"_Vendor
		_"^"_LcFlag_"^"_StopFlag_"^"_VendorDesc_"^"_ConLoc
	s Title="ContractNo^Remark^StartDate^EndDate^Vendor"
		_"^LcFlag^StopFlag^VendorDesc^ConLoc"
	s Result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Result
}

/// Description:保存供应商合同信息
/// Creator:	tsr
/// CreatDate:	2018-08-24
/// Table:		DHC_Contrack
ClassMethod SaveCont(ContId As %String, Params As %String) As %Library.String
{
	n (ContId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	
	s ConLoc=PJObj.%Get("ConLoc")
	s ContractNo=PJObj.%Get("ContractNo")
	s Remark=PJObj.%Get("Remark")
	s Vendor=PJObj.%Get("Vendor")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s LcFlag=PJObj.%Get("LcFlag")
	s StopFlag=PJObj.%Get("StopFlag")
	s LocId=PJObj.%Get("gLocId")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	
	s RowId=""
	&sql(select Cont_RowId into :RowId from DHC_Contrack where Cont_No=:ContractNo)
	
	i ContId="" d
	.i RowId'="" d RtnObj.Err(-2,RowId,"已存在此合同号信息!","",0) q
	.s Obj=##class(User.DHCConTrack).%New()
	e  d
	.i (RowId'="")&&(RowId'=ContId) d RtnObj.Err(-4,ContId,"已存在此合同号信息!","",0) q
	.s Obj=##class(User.DHCConTrack).%OpenId(ContId)
	q:RtnObj.success<0 RtnObj.Json()
	
	s Obj.ContNo=ContractNo
	s Obj.ContRemark=Remark
	s Obj.ContDate=StartDate
	s Obj.ContEndDate=EndDate
	d Obj.ContCTLOCDRSetObjectId(LocId)
	d Obj.ContAPCVMDRSetObjectId(Vendor)
	s Obj.ContLcFlag=LcFlag
	s Obj.ContStopFlag=StopFlag
	s Obj.ContAuditFlag="N"
	s Obj.ContAuditDate=""
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-1,"","合同信息保存失败","",0).Json()
	s ContId=Obj.%Id()
	
	s RtnObj.rowid=ContId
	q RtnObj.Json()
}

/// Description:查询合同物资信息
/// Creator:	tsr
/// CreatDate:	2018-08-23
/// Table:		DHC_ItmConTrack
/// Input:		合同Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCConTrackManager","QueryItmCont",1)
Query QueryItmCont(ContId As %String) As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,Spec,PRp:%Float") [ SqlProc ]
{
}

ClassMethod QueryItmContExecute(ByRef qHandle As %Binary, ContId As %String) As %Status
{
	n (qHandle,ContId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	i ContId="" q $$$OK
	s SqlStr="SELECT * FROM DHC_ItmConTrack WHERE ItmCont_Cont_DR="_ContId
	
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("ItmCont_RowId")
		s InciId = xrs.Data("ItmCont_INCItm_DR")
		continue:'$d(^INCI(InciId,1))
		s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
		s TmpGrpType=$p(TmpGrpInfo,"^",3)
		continue:TmpGrpType'=..sssCode()
		s InciCode=$p(^INCI(InciId,1),"^",1)
		s InciDesc=$p(^INCI(InciId,1),"^",2)
		s PUomId=$p(^INCI(InciId,3),"^",6)
		s Info=$o(^DHCITMINFO(0,"INCI",InciId,""))
		s Spec=$s(Info'="":$p($g(^DHCITMINFO(Info)),"^",27),1:"")
		s PRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(InciId,+$h,PUomId)
		d OutPutItmRow
	}
	d xrs.Close()
	Quit $$$OK
OutPutItmRow
	s Data=$lb(RowId,InciId,InciCode,InciDesc,Spec,PRp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:保存合同物资信息
/// Creator:	tsr
/// CreatDate:	2018-08-23
/// Table:		DHC_ItmConTrack
/// Input:		合同Id,物资明细
ClassMethod SaveItmCont(ContId As %String, Detail As %String) As %String
{
	n (ContId,Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	i ContId="" d RtnObj.Err(-1,ContId,"请选择合同信息!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-2,ContId,"入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s InciId=Obj.%Get("InciId")
		s InciDesc=$p(^INCI(InciId,1),"^",2)
		s ContDate=+$H
		i RowId="" d
		.s TmpId=$o(^DHCSTMITMCONTRACK(0,"CONTRACT",ContId,InciId,0))
		.i TmpId'="" d RtnObj.Err(-3,ContId,"此合同存在"_InciDesc_"物资信息!","",0)
		.q:RtnObj.success'=0
		.&sql(insert into DHC_ItmConTrack(ItmCont_Date,ItmCont_Cont_DR,ItmCont_INCItm_DR)
			values(:ContDate,:ContId,:InciId))
		.i SQLCODE'=0 d RtnObj.Err(-4,RowId,"保存合同物资信息失败!"_SQLCODE)
		e  d
		.s TmpId=$o(^DHCSTMITMCONTRACK(0,ContId,InciId,0))
		.i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-5,ContId,"此合同存在"_InciDesc_"物资信息!","",0)
		.q:RtnObj.success'=0
		.&sql(UPDATE SQLUser.DHC_ItmConTrack SET ItmCont_Cont_DR = :ContId, ItmCont_INCItm_DR = :InciId, ItmCont_Date = :ContDate
			WHERE ItmCont_RowId = :RowId)
		.i SQLCODE'=0 d RtnObj.Err(-6,RowId,"更新合同物资信息失败!"_SQLCODE)
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	&sql(update DHC_Contrack set Cont_AuditFlag='N' where %id=:ContId)
	i SQLCODE tro  q RtnObj.Err(-10,"","更新合同状态失败:"_SQLCODE).Json()
	
	tc
	q RtnObj.Json()
}

/// Description:删除合同物资信息
/// Creator:	tsr
/// CreatDate:	2018-08-23
/// Table:		DHC_ItmConTrack
ClassMethod DelItmCont(Params As %String) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","参数解析错误!")
	q:RtnObj.success'=0 RtnObj.Json()
	s ContId=""
	ts
	While(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s ItmContId=Obj.%Get("RowId")
		i ItmContId="" d RtnObj.Err(-2,"","请选择合同物资信息!","",0)
		q:RtnObj.success'=0
		s ContId=$p(^DHCSTMITMCONTRACK(ItmContId),"^",1)
		&sql(delete from DHC_ItmConTrack where ItmCont_RowId=:ItmContId)
		i SQLCODE'=0 d RtnObj.Err(-3,ContId,"删除失败!"_SQLCODE)
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	i ContId'="" d
	.&sql(update DHC_Contrack set Cont_AuditFlag='N' where %id=:ContId)
	i (ContId'="")&&(SQLCODE'=0) tro  q RtnObj.Err(-10,"","更新合同状态失败:"_SQLCODE).Json()
	
	tc
	q RtnObj.Json()
}

/// Description:获取某招标供应商的物资列表
/// Creator:	tsr
/// CreatDate:	2018-08-28
/// Table:		DHC_ItmAddionInfo
/// Input:		供应商Id
/// Return:	
Query QueryItmByVendor(Vendor As %String, ContId As %String) As Query(ROWSPEC = "InciId,InciCode,InciDesc,Spec,PRp:%Float") [ SqlProc ]
{
}

ClassMethod QueryItmByVendorExecute(ByRef qHandle As %Binary, Vendor As %String, ContId As %String) As %Status
{
	n (qHandle,Vendor,ContId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Vendor="" $$$OK
	s InciId=""
	f  s InciId=$o(^INCI(InciId)) q:InciId=""  d
	.q:+InciId=0
	.s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	.q:InfoId=""
	.s VendorId=$p($G(^DHCITMINFO(InfoId)),"^",24)
	.q:VendorId'=Vendor
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.q:NotUseFlag="Y"
	.s TmpId=$o(^DHCSTMITMCONTRACK(0,"CONTRACT",ContId,InciId,0))
	.q:TmpId'=""  ;已经存在的物资过滤
	.s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpGrpType=$p(TmpGrpInfo,"^",3)
	.q:TmpGrpType'="M"
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s PUomId=$p(^INCI(InciId,3),"^",6)
	.s Spec=$p(^DHCITMINFO(InfoId),"^",27)
	.s PRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(InciId,+$h,PUomId)
	.d OutPutVenItmRow
	Quit $$$OK
OutPutVenItmRow
	s Data=$lb(InciId,InciCode,InciDesc,Spec,PRp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:根据库存项ID获取合同信息
/// Creator:	lihui
/// CreatDate:	20210521
/// Table:		DHC_Contrack DHC_ItmConTrack
/// Input:		库存项ID
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).GetContByInci(1203)
ClassMethod GetContByInci(InciId As %String)
{
	n (InciId)
	s ContObj={}
	q:InciId="" ContObj
	s ContractId=""
	s RowId=""
	f  s RowId=$o(^DHCSTMITMCONTRACK(0,"INCI",InciId,RowId),-1) q:(RowId="")||(ContractId'="")  d
	.s ContractInfo=^DHCSTMCONTRACK(RowId)
	.s ConStartDate=$p(RowId,"^",4)
	.s ConEndDate=$p(RowId,"^",5)
	.q:(ConEndDate'="")&&(ConEndDate<+$h)
	.s ContractId=RowId
	;如均已过期,取最后一个
	i ContractId="" s ContractId=$o(^DHCSTMITMCONTRACK(0,"INCI",InciId,""),-1)
	q:(ContractId="")||'$d(^DHCSTMCONTRACK(ContractId)) ContObj
	
	s ContractInfo=^DHCSTMCONTRACK(ContractId)
	s ContractNo=$p(ContractInfo,"^",1)
	s ConStartDate=$p(ContractInfo,"^",4)
	s ConEndDate=$p(ContractInfo,"^",5)
	s AuditFlag=$p(ContractInfo,"^",11)
	
	s ConStartDate=..DL2H(ConStartDate)
	s ConEndDate=..DL2H(ConEndDate)
	
	s ContObj.ContractNo=ContractNo
	s ContObj.ConStartDate=ConStartDate
	s ContObj.ConEndDate=ConEndDate
	s ContObj.ConAuditFlag=AuditFlag
	q ContObj
}

/// Description:提交合同
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).jsSetComp
ClassMethod jsSetComp(Params As %String, ListData As %String) As %Library.String
{
	n (Params,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetComp(Params,ListData)
	q RtnObj.Json()
}

/// Description:提交合同
/// Table:		
/// Input:		json类型数据
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).SetComp(1203)
ClassMethod SetComp(Params As %String, ListData As %String) As RtnObj
{
	n (Params,ListData)
	s MethodName=$CLASSNAME()_".SetComp"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误")
	
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误")
	
	s UserId=PJObj.%Get("gUserId")
	s Date=+$h
	
	ts
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		
		s RowId=ItmObj.%Get("RowId")
		s ConObj=##class(User.DHCConTrack).%OpenId(RowId)
		s ConObj.ContCompFlag="Y"
		s Sc=ConObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-1,"","更新合同状态失败")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Description:撤销提交
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).jsCancelComp
ClassMethod jsCancelComp(Params As %String, ListData As %String) As %Library.String
{
	n (Params,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CancelComp(Params,ListData)
	q RtnObj.Json()
}

/// Description:撤销提交
/// Table:		
/// Input:		json类型数据
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).CancelComp(1203)
ClassMethod CancelComp(Params As %String, ListData As %String) As RtnObj
{
	n (Params,ListData)
	s MethodName=$CLASSNAME()_".SetComp"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误")
	
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误")
	
	s UserId=PJObj.%Get("gUserId")
	s Date=+$h
	
	ts
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		
		s RowId=ItmObj.%Get("RowId")
		s ConObj=##class(User.DHCConTrack).%OpenId(RowId)
		s ConObj.ContCompFlag="N"
		s Sc=ConObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-1,"","更新合同状态失败")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Description:审核合同
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).jsAudit
ClassMethod jsAudit(Params As %String, ListData As %String) As %Library.String
{
	n (Params,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Audit(Params,ListData)
	q RtnObj.Json()
}

/// Description:审核合同
/// Table:		
/// Input:		json类型数据
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).Audit(1203)
ClassMethod Audit(Params As %String, ListData As %String) As RtnObj
{
	n (Params,ListData)
	s MethodName=$CLASSNAME()_".Audit"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误")
	
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误")
	
	s UserId=PJObj.%Get("gUserId")
	s Date=+$h
	
	ts
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		
		s RowId=ItmObj.%Get("RowId")
		s ConObj=##class(User.DHCConTrack).%OpenId(RowId)
		s CompFlag=ConObj.ContCompFlag
		i CompFlag'="Y" d RtnObj.Err(-1,"","有合同尚未提交,请核实!","",0) q
		
		s ConObj.ContAuditFlag="Y"
		d ConObj.ContAuditUserDRSetObjectId(UserId)
		s ConObj.ContAuditDate=Date
		s Sc=ConObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-1,"","更新审核状态失败")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Description:拒绝合同
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).jsAuditNo
ClassMethod jsAuditNo(Params As %String, ListData As %String) As %Library.String
{
	n (Params,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..AuditNo(Params,ListData)
	q RtnObj.Json()
}

/// Description:拒绝合同
/// Table:		
/// Input:		json类型数据
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).AuditNo(1203)
ClassMethod AuditNo(Params As %String, ListData As %String) As RtnObj
{
	n (Params,ListData)
	s MethodName=$CLASSNAME()_".AuditNo"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误")
	
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误")
	
	s UserId=PJObj.%Get("gUserId")
	s Date=+$h
	
	ts
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		
		s RowId=ItmObj.%Get("RowId")
		s ConObj=##class(User.DHCConTrack).%OpenId(RowId)
		s AuditFlag=ConObj.ContAuditFlag
		i AuditFlag="Y" d RtnObj.Err(-2,"","已审核合同不可拒绝!","",0) q
		
		s ConObj.ContCompFlag="N"
		s Sc=ConObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-1,"","更新合同状态失败")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Description:取消审核合同
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).jsCancelAudit
ClassMethod jsCancelAudit(ListData As %String) As %Library.String
{
	n (ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CancelAudit(ListData)
	q RtnObj.Json()
}

/// Description:取消审核合同
/// Table:		
/// Input:		json类型数据
/// w ##class(web.DHCSTMHUI.DHCConTrackManager).CancelAudit(1203)
ClassMethod CancelAudit(ListData As %String) As RtnObj
{
	n (ListData)
	s MethodName=$CLASSNAME()_".CancelAudit"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误")	
	ts
	While (RtnObj.success=0) {
		s ItmObj=PJObj.%Pop()
		q:ItmObj=""
		
		s RowId=ItmObj.%Get("RowId")
		s ConObj=##class(User.DHCConTrack).%OpenId(RowId)
		s AuditFlag=ConObj.ContAuditFlag
		i AuditFlag'="Y" d RtnObj.Err(-2,"","未审核合同不可取消审核!","",0) q
		
		s ConObj.ContAuditFlag="N"
		d ConObj.ContAuditUserDRSetObjectId("")
		s ConObj.ContAuditDate=""
		s Sc=ConObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-1,"","更新合同状态失败")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

}
