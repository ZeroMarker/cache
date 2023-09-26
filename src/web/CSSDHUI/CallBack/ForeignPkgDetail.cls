Import sqluser

/// Creator:ban
/// CreatDate:2021-07-30
/// Description:外来器械登记绑定明细
/// Table:CSSD_ExtDevBindDetail
Class web.CSSDHUI.CallBack.ForeignPkgDetail Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2021-07-30
/// Description:外来器械登记新增保存,并且保存关联明细
/// Table:CSSD_ExtDevBind
/// w ##class(web.CSSDHUI.CallBack.ForeignPkgDetail).jsSave("")
ClassMethod jsSave(Params, Others) As %Library.String
{
	n (%session,Params,Others)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params,Others)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Save(Params, Others) As web.CSSDHUI.RtnObj
{
	n (%session,Params,Others)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s OPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=OPJObj.%FromJSON(Others)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s RowId=PJObj.%Get("ExtRowId")
	s PkgId=PJObj.%Get("ExtInstruName")	//消毒包
	s CodeDict=PJObj.%Get("ExtInstruCode")	//标牌
	s ExtLocId=PJObj.%Get("ExtPatientLoc")	//使用科室
	s FirmId=PJObj.%Get("ExtFirm")	//厂商
	s OperatorTypeId=PJObj.%Get("ExtOperatorType")	//手术类型
	s FunctionalCheckId=PJObj.%Get("ExtFunctionalCheck")	//器械功能检查
	s PatientAge=PJObj.%Get("ExtPatientAge")	//患者年龄
	s BedNo=PJObj.%Get("ExtBedNo")	//床号
	s RecNum=PJObj.%Get("ExtRecNum")	//接收数量
	s RecDate=PJObj.%Get("ExtRecDate")	//接收日期
	s RecManId=PJObj.%Get("ExtRecManDr")	//接收人
	s SerManName=PJObj.%Get("ExtSerMan")	//配送人
	s Receipt=PJObj.%Get("ExtReceipt")	//单据
	s UseDoctor=PJObj.%Get("ExtUseDoctor")	//使用医生
	s UseDate=PJObj.%Get("ExtUseDate")	//使用日期
	s SickerName=PJObj.%Get("ExtSickerName")	//患者姓名
	s HospitalNo=PJObj.%Get("ExtHospitalNo")	//住院登记号、患者登记号
	s Tel=PJObj.%Get("ExtTel")	//电话
	s PowerInstru=PJObj.%Get("ExtPowerInstru")	//动力器械
	s Remark=PJObj.%Get("ExtRemark")	//备注
	s SterParameter=PJObj.%Get("ExtSterParameter")	//灭菌参数
	s SterTemp=PJObj.%Get("ExtSterTemp")	//高温选项
	s BackWash=PJObj.%Get("ExtBackWash")	//是否反洗
	s PatientSex=PJObj.%Get("ExtPatientSex")	//患者性别
	s InstruNum=PJObj.%Get("ExtInstruNum")	//器械数量
	s ImplantsNum=PJObj.%Get("ExtImplantsNum")	//植入物数量
	s OprScheduleId=PJObj.%Get("OprScheduleId")	//手术排班ID
	
	s gUserId=OPJObj.%Get("gUserId")
	s gLocId=OPJObj.%Get("gLocId")
	s gGroupId=OPJObj.%Get("gGroupId")
	s gHospId=OPJObj.%Get("gHospId")
	
	i RecNum="" s RecNum=1
	s UseDate=..DH2L(UseDate)
	s RecDate=..DH2L(RecDate)
	s NowTime=$p($h,",",2)
	s NowTime=..TH2L(NowTime)
	
	i CodeDict="" d RtnObj.Err(-2,"","标牌不能为空")
	q:RtnObj.success'=0 RtnObj
	
	i RecManId="" d RtnObj.Err(-2,"","接收人不能为空")
	q:RtnObj.success'=0 RtnObj
	
	i RowId'="" d
	.s ExtObj=##class(User.CSSDExtDevBind).%OpenId(RowId)
	.s NowStatus=ExtObj.CSSDExtStatus
	.i NowStatus'="B" d RtnObj.Err(-3,"",CodeDict_"外来器械非登记状态不能修改！")
	e  d
	.s RtnObj=..CheckExtFlag(CodeDict)
	q:RtnObj.success'=0 RtnObj
	
	i RowId="" d
	.s ExtObj=##class(User.CSSDExtDevBind).%New()
	.s ExtObj.CSSDExtStatus="B"
	e  d
	.s ExtObj=##class(User.CSSDExtDevBind).%OpenId(RowId)
	
	d ExtObj.CSSDExtInstruNameSetObjectId(PkgId)
	s ExtObj.CSSDExtCode=CodeDict
	d ExtObj.CSSDExtLocSetObjectId(ExtLocId)
	s ExtObj.CSSDExtRecNum=RecNum
	s ExtObj.CSSDExtRecDate=RecDate
	s ExtObj.CSSDExtReciveDate=RecDate
	s ExtObj.CSSDExtReciveTime=NowTime
	d ExtObj.CSSDExtRecManSetObjectId(RecManId)
	s ExtObj.CSSDExtSerMan=SerManName
	s ExtObj.CSSDExtReceipt=Receipt
	s ExtObj.CSSDExtDocName=UseDoctor
	s ExtObj.CSSDExtUseDate=UseDate
	s ExtObj.CSSDExtSickerName=SickerName
	s ExtObj.CSSDExtHospitalNo=HospitalNo
	d ExtObj.CSSDExtFirmSetObjectId(FirmId)
	s ExtObj.CSSDExtTel=Tel
	s ExtObj.CSSDExtPowerInstru=PowerInstru
	s ExtObj.CSSDExtRemark=Remark
	d ExtObj.CSSDExtHospitalSetObjectId(gHospId)
	s ExtObj.CSSDExtFunctionalCheck=FunctionalCheckId
	s ExtObj.CSSDExtPatientSex=PatientSex
	s ExtObj.CSSDExtPatientAge=PatientAge
	s ExtObj.CSSDExtBedNo=BedNo
	s ExtObj.CSSDExtSterParameter=SterParameter
	s ExtObj.CSSDExtSterTemp=SterTemp
	s ExtObj.CSSDExtBackwash=BackWash
	s ExtObj.CSSDExtOperatorType=OperatorTypeId
	s ExtObj.CSSDExtInstruNum=InstruNum
	s ExtObj.CSSDExtImplants=ImplantsNum
	s ExtObj.CSSDExtOpPlanDr=OprScheduleId
	s Sc=ExtObj.%Save()
	i $$$ISERR(Sc) d RtnObj.Err(-5,"","外来器械登记失败!")
	q:RtnObj.success'=0 RtnObj
	
	s RowId=ExtObj.%Id()
	s DetailId=$o(^User.CSSDExtDevBindDetailI("CSSDParrefDrPkgNumIndex",RowId,0))
	i DetailId="" d	//自动插入明细
	.s RtnObj=..AutoSaveDetail(RowId,PkgId)
	q:RtnObj.success'=0 RtnObj
	
	//未清洗外来器械依据此表取值
	s ExtCallBackId=$o(^User.CSSDExtCallBackLabelI("CSSDECLParrefDrStatusIndex",RowId,"B",""))
	i ExtCallBackId="" d
	.&sql(INSERT INTO CSSD_ExtCallBackLabel(CSSDECL_Parref_DR,CSSDECL_Qty,CSSDECL_Label,CSSDECL_Status,CSSDECL_Date) 
		VALUES 
		(:RowId,:RecNum,:CodeDict,"B",:RecDate))
	.i SQLCODE'=0 d RtnObj.Err(-5,"","插入外来器械明细数据失败!")
	e  d
	.&sql(UPDATE CSSD_ExtCallBackLabel SET CSSDECL_Parref_DR=:RowId,CSSDECL_Qty=:RecNum,CSSDECL_Label =:CodeDict,CSSDECL_Date =:RecDate where CSSDECL_Rowid=:ExtCallBackId)
	.i SQLCODE'=0 d RtnObj.Err(-5,"","插入外来器械明细数据失败!")
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj.rowid=RowId
	q RtnObj
}

/// w ##class(web.CSSDHUI.CallBack.ForeignPkgDetail).AutoSaveDetail()
ClassMethod AutoSaveDetail(MainId, PackageDr) As web.CSSDHUI.RtnObj
{
	n (%session,MainId,PackageDr)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:((MainId="")||(PackageDr="")) RtnObj.Err(-6,"","入参不能为空!")
	
	s DetailId=$o(^User.CSSDExtDevBindDetailI("CSSDParrefDrPkgNumIndex",MainId,0))
	q:DetailId'="" RtnObj
	
	s PkgItm=0
	f  s PkgItm=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PackageDr,PkgItm)) q:((PkgItm="")||(RtnObj.success'=0))  d
	.s Qty=$lg(^User.CSSDPackageItemD(PkgItm),4)
	.s ItmId=$lg(^User.CSSDPackageItemD(PkgItm),7)
	.s ImplantsFlag=$lg(^User.CSSDItemD(ItmId),10)
	.s ExtBindDetailObj=##class(User.CSSDExtDevBindDetail).%New()
	.d ExtBindDetailObj.CSSDEBDParrefDrSetObjectId(MainId)
	.d ExtBindDetailObj.CSSDEBDPackageSetObjectId(PackageDr)
	.d ExtBindDetailObj.CSSDEBDItmDRSetObjectId(ItmId)
	.s ExtBindDetailObj.CSSDEBDQty=Qty
	.s ExtBindDetailObj.CSSDEBDNum=1
	.s ExtBindDetailObj.CSSDEBDPkgNum="01"
	.s ExtBindDetailObj.CSSDEBDIsImplants=ImplantsFlag
	.s Sc=ExtBindDetailObj.%Save()
	.i $$$ISERR(Sc) d RtnObj.Err(-7,"","自动保存明细失败!")
	.q:RtnObj.success'=0
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2021.7.30
/// Description:保存外来器械明细
/// Table:CSSD_ExtDevBindDetail
/// d ##class(web.CSSDHUI.CallBack.ForeignPkgDetail).jsSaveDetail("16","[{""Desc"":""钳子"",""Spec"":""11cm"",""itmDr"":""11"",""Qty"":""3"",""IsImplants"":"""",""PkgQty"":""2""}]")
ClassMethod jsSaveDetail(MainId, Params) As %Library.String
{
	n (%session,MainId,Params)
	s $ZT=..sssError()
	ts
	s RtnObj=..SaveDetail(MainId,Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2021.7.30
/// Description:保存外来器械明细
/// Table:CSSD_ExtDevBindDetail
/// d ##class(web.CSSDHUI.CallBack.ForeignPkgDetail).SaveDetail("16","[{""Desc"":""钳子"",""Spec"":""11cm"",""itmDr"":""11"",""Qty"":""3"",""IsImplants"":"""",""PkgQty"":""2""}]")
ClassMethod SaveDetail(MainId, Params) As web.CSSDHUI.RtnObj
{
	n (%session,MainId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:((MainId="")||(Params="")) RtnObj.Err(-1,"","入参不能为空!")
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-2,"","入参解析失败!")
	
	s ExtObj=##class(User.CSSDExtDevBind).%OpenId(MainId)
	q:'$IsObject(ExtObj) RtnObj.Err(-1,"","登记信息不存在！")
	
	s PkgDr = ExtObj.CSSDExtInstruNameGetObjectId()
	s RecNum=ExtObj.CSSDExtRecNum	//接收数量
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s ItmId=Obj.%Get("itmDr")
		s Qty=Obj.%Get("Qty")
		s PkgNum=Obj.%Get("PkgNum")	//分包数
		s IsImplants=Obj.%Get("IsImplants")
		
		i (Qty<0) d RtnObj.Err(-3,"","器械数量必须大于0!")
		q:RtnObj.success'=0
		
		i (PkgNum<0) d RtnObj.Err(-4,"","分包数必须大于0!")
		q:RtnObj.success'=0
		
		i PkgNum>RecNum d RtnObj.Err(-5,"","分包数不能大于外来器械接收数量！")
		q:RtnObj.success'=0

		s ExtDetailId = $o(^User.CSSDExtDevBindDetailI("ParrefDrPkgDrItmDr",MainId,PkgDr,ItmId,""))
		i ((ExtDetailId'="")&&(ExtDetailId'=RowId)) d RtnObj.Err(-6,"","绑定的器械明细已存在,请核对!")
		q:RtnObj.success'=0

		i IsImplants="" s IsImplants="N"
		s PkgNumQty= $tr($j(PkgNum,2)," ","0")
		
		i RowId="" d
		.s ItmObj=##class(User.CSSDExtDevBindDetail).%New()
		e  d
		.s ItmObj=##class(User.CSSDExtDevBindDetail).%OpenId(RowId)
		s ItmObj.CSSDEBDParrefDr=ExtObj
		d ItmObj.CSSDEBDPackageSetObjectId(PkgDr)
		d ItmObj.CSSDEBDItmDRSetObjectId(ItmId)
		s ItmObj.CSSDEBDQty=Qty
		s ItmObj.CSSDEBDNum=PkgNum
		s ItmObj.CSSDEBDPkgNum=PkgNumQty
		s ItmObj.CSSDEBDIsImplants=IsImplants
		s Sc=ItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-6,"","明细保存失败!")
		q:RtnObj.success'=0
	}
	q RtnObj
}

/// Creator:ban
/// CreatDate:2021.7.30
/// Description:根据主表rowid获取明细表的数据列表
/// Table:CSSD_ExtDevBindDetail
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.ForeignPkgDetail","SelectByF","37")
Query SelectByF(ExtId As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,itmDr,Spec,Desc,packageDr,Qty,IsImplants,PkgNum,ParrefDr,ConsumeName,ConsumeQty") [ SqlProc ]
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, ExtId As %String) As %Status
{
	n (%session,qHandle,ExtId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:ExtId="" $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDEBD_Rowid,CSSDEBD_Itm_DR,CSSDEBD_Itm_DR->CSSDI_Desc as ItemDesc,CSSDEBD_Itm_DR->CSSDI_Spec as Spec,"
			_" CSSDEBD_Package_DR,CSSDEBD_Qty,CSSDEBD_IsImplants,CSSDEBD_Num,CSSDEBD_Parref_DR,CSSDEBD_Label "
			_" FROM CSSD_ExtDevBindDetail where CSSDEBD_Parref_DR="_ExtId
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("CSSDEBD_Rowid")
		s ItmId = Result.Data("CSSDEBD_Itm_DR")
		s Spec = Result.Data("Spec")
		s ItmDesc = Result.Data("ItemDesc")
		s PkgId = Result.Data("CSSDEBD_Package_DR")
		s Qty = Result.Data("CSSDEBD_Qty")
		s IsImplants = Result.Data("CSSDEBD_IsImplants")
		s PkgNum = Result.Data("CSSDEBD_Num")
		s ExtLabel = Result.Data("CSSDEBD_Label")
		s MainId = Result.Data("CSSDEBD_Parref_DR")
		s (ConsumeName,ConsumeQty)=""
		i ((ExtLabel'="")&&(ItmId'="")) d
		.s ConsumeDetailId=$o(^User.CSSDConsumeDetailI("CSSDCDLabelItmIndex",ExtLabel,ItmId,""))
		.q:ConsumeDetailId=""
		.s ConsumeDetailObj=##class(User.CSSDConsumeDetail).%OpenId(ConsumeDetailId)
		.s ConsumeQty=ConsumeDetailObj.CSSDCDConsumeQty
		.s ConsumeReasonObj=ConsumeDetailObj.CSSDCDConsumeReasonDr
		.i $IsObject(ConsumeReasonObj) s ConsumeName=ConsumeReasonObj.CSSDMConsumeDesc
		
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,ItmId,Spec,ItmDesc,PkgId,Qty,IsImplants,PkgNum,MainId,ConsumeName,ConsumeQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2021.7.30
/// Description:根据主表rowid获取明细表的数据列表
/// Table:CSSD_ExtDevBindDetail
/// w ##class(web.CSSDHUI.CallBack.ForeignPkgDetail).SumQty("16","N")
ClassMethod SumQty(ExtDr As %String, IsImplants As %String) As %Library.String
{
	n (%session,ExtDr,IsImplants)
	s Qty=0
	s ItemRowId=""
	f  s ItemRowId=$o(^User.CSSDExtDevBindDetailI("CSSDParrefDrImplantsIndex",ExtDr,IsImplants,ItemRowId)) q:(ItemRowId="")  d
	.s ItemObj=##class(User.CSSDExtDevBindDetail).%OpenId(ItemRowId)
	.s ItemQty=ItemObj.CSSDEBDQty
	.s Qty=Qty+ItemQty
	q Qty
}

/// Creator:ban
/// CreatDate:2021.7.30
/// Description:根据明细表ID删除明细
/// Table:CSSD_ExtDevBindDetail
/// d ##class(web.CSSDHUI.CallBack.ForeignPkgDetail).jsDeleteDetail(3)
ClassMethod jsDeleteDetail(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..DeleteDetail(RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2021.7.30
/// Description:根据主表rowid获取明细表的数据列表
/// Table:CSSD_ExtDevBindDetail
ClassMethod DeleteDetail(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i RowId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s DetailObj=##class(User.CSSDExtDevBindDetail).%OpenId(RowId)
	d DetailObj.%Reload()
	i '$IsObject(DetailObj) d RtnObj.Err(-2,"","明细不存在!")
	q:RtnObj.success'=0 RtnObj
	
	s MainObj=DetailObj.CSSDEBDParrefDr
	i '$IsObject(MainObj) d RtnObj.Err(-2,"","单据不存在!")
	q:RtnObj.success'=0 RtnObj
	
	s Status=MainObj.CSSDExtStatus
	q:(Status'="B") RtnObj.Err(-1,"","非登记状态，不能删除")
	
	&sql(Delete From CSSD_ExtDevBindDetail WHERE CSSDEBD_Rowid=:RowId)
	q:SQLCODE<0 RtnObj.Err(-3,"","删除明细失败！")
	
	q RtnObj
}

/// Description: 外来器械是否可以新增
/// w ##class(web.CSSDHUI.CallBack.ForeignPkgDetail).CheckExtFlag("101219002")
ClassMethod CheckExtFlag(InstruCode) As web.CSSDHUI.RtnObj
{
	n (%session,InstruCode)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s CodeDictId=""
	s PackageInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPkgInfoByCodeDict(InstruCode)
	q:PackageInfo="" RtnObj.Err(-3,"",InstruCode_":标牌信息不存在!")
	
	s PackageId=$p(PackageInfo,"^",1)
	s PackTypeDetail=$p(PackageInfo,"^",2)
	s CodeDictId=$p(PackageInfo,"^",4)
	s IsExt=$p(PackageInfo,"^",6)
	q:IsExt'="Y" RtnObj.Err(-3,"",InstruCode_":非外来器械包!")
	
	s RegisterId=$o(^User.CSSDExtDevBindI("IndexCSSDExtCodeIsTransfer",InstruCode,"N",""))
	q:RegisterId'="" RtnObj.Err(-3,"",InstruCode_"外来器械为非移交状态!")
	
	q RtnObj
}

}
