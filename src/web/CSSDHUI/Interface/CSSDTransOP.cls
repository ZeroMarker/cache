Import SQLUser

Class web.CSSDHUI.Interface.CSSDTransOP Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:	why
/// CreatDate:	2020-03-11
/// Description:C#版本手术清点调用接口
/// Table:		User.CSSDTransOP
/// Input:		包号(label),清点时间（nurseTime）,患者(Id)，opaId(手术记录ID)，手术名称，
/// 			感染名称，手术医生(ID)，手术间名称,清点护士id,巡回护士(ID),患者姓名
/// Output: 
/// Return:		0:成功, 其他: 失败(1:错误的标签,2:没有灭菌,3:过期的消毒包)
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).InsertRec("10010100100019",2,3,4,5,6,7,8,9)
ClassMethod InsertRec(label, nurseTime, pationtDR, anopID, oPName, infectName, oPDoctor, oPDept, instNurse, circNurse, patientName) As %String
{
	n (label,nurseTime,pationtDR,anopID,oPName,infectName,oPDoctor,oPDept,instNurse,circNurse,patientName)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i label="" d RtnObj.Err(-1,"","标签不能为空！")
	q:RtnObj.success'=0 RtnObj
	
	s TransOpId=$o(^User.CSSDTransOPI("CSSDTOPLabelIndex",label,""))
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",label,""))
	i TransId="" d RtnObj.Err(-1,"","错误的标签号","",0)
	q:RtnObj.success'=0 RtnObj
	
	s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	d TransObj.%Reload()
	s SterItmObj=TransObj.CSSDTSterilize
	s ExpDate=TransObj.CSSDTExpDate
	;没有灭菌
	i '$IsObject(SterItmObj) d RtnObj.Err(-2,"","消毒包没有灭菌","",0)
	q:RtnObj.success'=0 RtnObj
	
	s NowDate=$p($h,",",1)
	i NowDate>=ExpDate d RtnObj.Err(-3,"","消毒包过期","",0)
	q:RtnObj.success'=0 RtnObj
	
	ts
	i TransOpId="" d
	.s obj=##class(User.CSSDTransOP).%New()
	e  d
	.s obj=##class(User.CSSDTransOP).%OpenId(TransOpId)
	.d obj.%Reload()
	s obj.CSSDTOPLabel=label
	s obj.CSSDTOPCountNurseTime=nurseTime
	d obj.CSSDTOPPationtDRSetObjectId(pationtDR)
	d obj.CSSDTOPANOPIDSetObjectId(anopID)
	s obj.CSSDTOPOPName=oPName
	s obj.CSSDTOPInfectName=infectName
	d obj.CSSDTOPOPDoctorSetObjectId(oPDoctor)
	s obj.CSSDTOPOPRoom=oPDept
	d obj.CSSDTOPCountNurseDRSetObjectId(instNurse)
	d obj.CSSDOPCircNurseSetObjectId(circNurse)
	s obj.CSSDTOPPationtName=patientName
	s Sc=obj.%Save()
	i $$$ISERR(Sc) d RtnObj.Err(-4,"","保存失败！") tro 
	q:RtnObj.success'=0 RtnObj
	
	&sql(Update cssd_trans set CSSDT_Status='U' where CSSDT_Rowid=:TransId)
	i SQLCODE<0 d RtnObj.Err(-5,"","更新消毒包状态失败！") tro
	q:RtnObj.success'=0 RtnObj
	
	s mainRowid=obj.%Id()
	tc
	s RtnObj.rowid=mainRowid
	q RtnObj
}

/// Creator:	ban
/// CreatDate:	2022-02-24
/// Description:撤销消毒包患者绑定
/// Table:		User.CSSDTransOP
/// Input:		包号(label)
/// Output: 
/// Return:		0:成功, 其他: 失败(1:错误的标签,2:没有灭菌,3:过期的消毒包)
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).CancelPackageBind("10010100100019")
ClassMethod CancelPackageBind(label) As %String
{
	n (label)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i label="" d RtnObj.Err(-1,"","标签不能为空！")
	q:RtnObj.success'=0 RtnObj
	
	s TransOpId=$o(^User.CSSDTransOPI("CSSDTOPLabelIndex",label,""))
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",label,""))
	i TransId="" d RtnObj.Err(-1,"","错误的标签号","",0)
	q:RtnObj.success'=0 RtnObj
	
	s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	i '$IsObject(TransObj) d RtnObj.Err(-1,"","未获取到标签信息","",0)
	q:RtnObj.success'=0 RtnObj
	
	d TransObj.%Reload()
	s SterItmObj=TransObj.CSSDTSterilize
	s ExpDate=TransObj.CSSDTExpDate
	;没有灭菌
	i '$IsObject(SterItmObj) d RtnObj.Err(-2,"","消毒包没有灭菌","",0)
	q:RtnObj.success'=0 RtnObj
	
	s NowDate=$p($h,",",1)
	i NowDate>=ExpDate d RtnObj.Err(-3,"","消毒包已过期","",0)
	q:RtnObj.success'=0 RtnObj
	
	ts
	i TransOpId'="" d
	.&sql(DELETE FROM CSSD_Trans_OP WHERE CSSDTOP_Rowid=:TransOpId)
	.i SQLCODE<0 d RtnObj.Err(-4,"","更新消毒包状态失败！") tro
	q:RtnObj.success'=0 RtnObj
	
	&sql(Update cssd_trans set CSSDT_Status='R' where CSSDT_Rowid=:TransId)
	i SQLCODE<0 d RtnObj.Err(-5,"","更新消毒包状态失败！") tro
	q:RtnObj.success'=0 RtnObj
	
	tc
	q RtnObj
}

/// Creator:	why
/// CreatDate:	2020-03-11
/// Description:删除标签调用接口2022.10.11修改
/// Table:		User.CSSDTransOP,CSSD_Trans
/// Input:		{""label"":""22222221212""}
/// Output: 
/// Return:		<0:失败
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).DeleteTransOP("{""label"":""22222221212""}")
ClassMethod DeleteTransOP(Params As %Text) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s label=PJObj.%Get("label")  ;标签
	i label="" d RtnObj.Err(-1,"","标签不能为空！")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s TransOpId=$o(^User.CSSDTransOPI("CSSDTOPLabelIndex",label,""))
	i TransOpId="" d RtnObj.Err(-1,"","标签没有被使用","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",label,""))
	i TransId="" d RtnObj.Err(-1,"","错误的标签号","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	&sql(DELETE FROM CSSD_Trans_OP WHERE CSSDTOP_Rowid=:TransOpId)
	i SQLCODE<0 d RtnObj.Err(-4,"","更新消毒包状态失败！") tro
	q:RtnObj.success'=0 RtnObj.Json()
	
	&sql(Update cssd_trans set CSSDT_Status='R' where CSSDT_Rowid=:TransId)
	i SQLCODE<0 d RtnObj.Err(-5,"","更新消毒包状态失败！") tro
	q:RtnObj.success'=0 RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Creator:	why
/// CreatDate:	2021-04-26
/// Description:内部手麻组手术清点调用接口hisui
/// Table:		User.CSSDTransOP
/// Input:		包号(label),清点时间（nurseTime）,患者(Id)，opaId(手术记录ID)，手术名称，
/// 			感染名称，手术医生(ID)，手术间名称,清点护士id,巡回护士(ID),患者姓名
/// Output: 
/// Return:		0:成功, 其他: 失败(1:错误的标签,2:没有灭菌,3:过期的消毒包)
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).InsertRecHisui("{""label"":""000001001000022"",""nurseTime"":""2"",""pationtDR"":""222"",""anopID"":""236"",""oPName"":""2221"",""infectName"":""1"",""oPDept"":""1"",""instNurse"":""1"",""circNurse"":""1"",""patientName"":""2212""}")
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).InsertRecHisui("{""label"":""000001001000022"",""nurseTime"":""541"",""pationtDR"":""360"",""anopID"":""236"",""oPName"":"""",""infectName"":""1"",""oPDept"":""2"",""instNurse"":""901"",""circNurse"":""1"",""pad"",""333""}")
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).InsertRecHisui("{""patientName"",""2212""}")
ClassMethod InsertRecHisui(Params As %Text) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s label=PJObj.%Get("label")  ;标签
	s nurseTime=PJObj.%Get("nurseTime") ;清点时间
	s pationtDR=PJObj.%Get("pationtDR") ;患者就诊号
	s anopID=PJObj.%Get("anopID")   ;手术申请id
	s oPName=PJObj.%Get("oPName")    ;手术名称
	s infectName=PJObj.%Get("infectName") ;感染名称
	s oPDoctor=PJObj.%Get("oPDoctor")  ;手术医生id
	s oPDept=PJObj.%Get("oPDept")    ;手术间名称
	s instNurse=PJObj.%Get("instNurse")  ;清点护士
	s circNurse=PJObj.%Get("circNurse")    ;巡回护士
	s patientName=PJObj.%Get("patientName")  ;患者姓名
	s TransOpId=$o(^User.CSSDTransOPI("CSSDTOPLabelIndex",label,""))
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",label,""))
	i TransId="" d RtnObj.Err(-1,"","错误的标签号","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	d TransObj.%Reload()
	s SterItmObj=TransObj.CSSDTSterilize
	s ExpDate=TransObj.CSSDTExpDate
	s PkgDr=TransObj.CSSDTPackage.%Id()
	;没有灭菌
	i '$IsObject(SterItmObj) d RtnObj.Err(-2,"","消毒包没有灭菌","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s NowDate=$p($h,",",1)
	i NowDate>=ExpDate d RtnObj.Err(-3,"","消毒包过期","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	i TransOpId="" d
	.s obj=##class(User.CSSDTransOP).%New()
	e  d
	.s obj=##class(User.CSSDTransOP).%OpenId(TransOpId)
	.d obj.%Reload()
	s obj.CSSDTOPLabel=label
	s obj.CSSDTOPCountNurseTime=nurseTime
	d obj.CSSDTOPPationtDRSetObjectId(pationtDR)
	d obj.CSSDTOPANOPIDSetObjectId(anopID)
	s obj.CSSDTOPOPName=oPName
	s obj.CSSDTOPInfectName=infectName
	d obj.CSSDTOPOPDoctorSetObjectId(oPDoctor)
	s obj.CSSDTOPOPRoom=oPDept
	d obj.CSSDTOPCountNurseDRSetObjectId(instNurse)
	d obj.CSSDOPCircNurseSetObjectId(circNurse)
	s obj.CSSDTOPPationtName=patientName
	s Sc=obj.%Save()
	i $$$ISERR(Sc) d RtnObj.Err(-4,"","保存失败！") tro 
	q:RtnObj.success'=0 RtnObj.Json()
	
	&sql(Update cssd_trans set CSSDT_Status='U' where CSSDT_Rowid=:TransId)
	i SQLCODE<0 d RtnObj.Err(-5,"","更新消毒包状态失败！") tro
	q:RtnObj.success'=0 RtnObj.Json()
	
	s mainRowid=obj.%Id()
	tc
	s RtnObj.rowid=mainRowid
	s RtnObj.keyValue=..GetPackageItm(PkgDr)
	q RtnObj.Json()
}

/// Creator:	why
/// CreatDate:	2021-05-10
/// Description:第三方手术清点调用接口hisui
/// Table:		User.CSSDTransOP
/// Input:		包号(label),住院号(HospitalNo),患者编号(pationtId),卡号(CardNo),患者类型(PationtType)
/// 			患者姓名(PationtName),性别(Sex),手术名称(oPName),手术日期(OprDate),手术台次(OprTabletime)
/// 			,手术间名称(oPDept),手术医生(OprDoctor),器械护士(CountNurse),巡回护士(CircleNurse),感染名称(InfectName)
/// Output: 
/// Return:		0:成功, 其他: 失败(1:错误的标签,2:没有灭菌,3:过期的消毒包)
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).InsertRecHisui("{""label"":""000001001000022"",""nurseTime"":""2"",""pationtDR"":""222"",""anopID"":""236"",""oPName"":""2221"",""infectName"":""1"",""oPDept"":""1"",""instNurse"":""1"",""circNurse"":""1"",""patientName"":""2212""}")
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).InsertTransOp("{""label"":""002031001000001"",
ClassMethod InsertTransOp(Params As %Text) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s label=PJObj.%Get("label")  ;标签
	s HospitalNo=PJObj.%Get("HospitalNo") ;住院号
	s pationtId=PJObj.%Get("pationtId") ;患者编号
	s CardNo=PJObj.%Get("CardNo")   ;卡号
	s PationtType=PJObj.%Get("PationtType")    ;患者类型
	s PationtName=PJObj.%Get("PationtName") ;患者姓名
	s Sex=PJObj.%Get("Sex")  ;患者性别
	s oPName=PJObj.%Get("oPName")    ;手术名称
	s OprDate=PJObj.%Get("OprDate")  ;手术日期
	s OprTabletime=PJObj.%Get("OprTabletime")    ;手术台次
	s oPDept=PJObj.%Get("oPDept")  ;手术间名称
	s OprDoctor=PJObj.%Get("OprDoctor")    ;手术医生
	s CountNurse=PJObj.%Get("CountNurse")  ;器械护士
	s CircleNurse=PJObj.%Get("CircleNurse")    ;巡回护士
	s InfectName=PJObj.%Get("InfectName")  ;感染名称
	s TransOpId=$o(^User.CSSDTransOPI("CSSDTOPLabelIndex",label,""))
	
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",label,""))
	i TransId="" d RtnObj.Err(-1,"","错误的标签号","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	d TransObj.%Reload()
	s SterItmObj=TransObj.CSSDTSterilize
	s ExpDate=TransObj.CSSDTExpDate
	s PkgDr=TransObj.CSSDTPackage.%Id()
	;没有灭菌
	i '$IsObject(SterItmObj) d RtnObj.Err(-2,"","消毒包没有灭菌","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s NowDate=$p($h,",",1)
	i NowDate>=ExpDate d RtnObj.Err(-3,"","消毒包过期","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	i TransOpId="" d
	.s obj=##class(User.CSSDTransOP).%New()
	e  d
	.s obj=##class(User.CSSDTransOP).%OpenId(TransOpId)
	.d obj.%Reload()
	s obj.CSSDTOPLabel=label
	s obj.CSSDTOPHospitalNo=HospitalNo
	s obj.CSSDTOPPationtDR=pationtId
	s obj.CSSDTOPCardNo=CardNo
	s obj.CSSDTOPPationtType=PationtType
	s obj.CSSDTOPPationtName=PationtName
	s obj.CSSDTOPSex=Sex
	s obj.CSSDTOPOPName=oPName
	s obj.CSSDTOPOprDate=OprDate
	s obj.CSSDTOPOprTabletime=OprTabletime
	s obj.CSSDTOPOPRoom=oPDept
	s obj.CSSDTOPDoctor=OprDoctor
	s obj.CSSDTOPCountNurseName=CountNurse
	s obj.CSSDTOPCircNurseName=CircleNurse
	s obj.CSSDTOPInfectName=InfectName
	s obj.CSSDTOPIsThird=1
	s Sc=obj.%Save()
	i $$$ISERR(Sc) d RtnObj.Err(-4,"","保存失败!") tro 
	q:RtnObj.success'=0 RtnObj.Json()
	
	&sql(Update cssd_trans set CSSDT_Status='U' where CSSDT_Rowid=:TransId)
	i SQLCODE<0 d RtnObj.Err(-5,"","更新消毒包状态失败！") tro
	q:RtnObj.success'=0 RtnObj.Json()
	
	s mainRowid=obj.%Id()
	tc
	s RtnObj.rowid=mainRowid
	s RtnObj.keyValue=..GetPackageItm(PkgDr)
	q RtnObj.Json()
}

/// 根据包Id获取明细
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).GetPackageItm("43")
ClassMethod GetPackageItm(PkgDr As %String) As %String
{
	n (PkgDr)
	s Result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT ID As RowId ,CSSDPI_Itm_DR,CSSDPI_Package_DR,CSSDPI_Qty,CSSDPI_SORT From CSSD_PackageItem where CSSDPI_Package_DR = "_PkgDr_" Order By CSSDPI_SORT"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(sqlStr)
	d Result.Execute()
	s count=0
	s ResultStr=""
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s itmDr = Result.Data("CSSDPI_Itm_DR")
		s Qty = Result.Data("CSSDPI_Qty")
		s SerialNo = Result.Data("CSSDPI_SORT")
		s PkgId=Result.Data("CSSDPI_Package_DR")
		s PkgName=$lg(^User.CSSDPackageD(PkgId),5)
		s Desc=$lg(^User.CSSDItemD(itmDr),2)
		s Spec=$lg(^User.CSSDItemD(itmDr),3)
		s UseFlag=$lg(^User.CSSDItemD(itmDr),5)
		s:(ResultStr'="") ResultStr=ResultStr_","
		s ResultStr=ResultStr_"{"
		s ResultStr=ResultStr_"""id"":"""_""_RowId_""",""PkgDesc"":"""_PkgName_""",""ItmDesc"":"""_Desc_""",""Spec"":"""_Spec_""""
		s ResultStr=ResultStr_"}"
	}
	s ResultStr="["_ResultStr_"]"
	d Result.Close()
	q ResultStr
}

/// 根据标签获取明细
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).GetPackageItmByLabel("10205700300000101")
ClassMethod GetPackageItmByLabel(PackageLabel As %String) As %String
{
	n (PackageLabel)
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
	s ResultStr="["
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
		.
		s Title="ItmId^Desc^Spec^Qty^ConsumeQty^ConsumeReasonId^ConsumeReasonDesc^NotUseFlag^Remarks^OneOffFlag"
		s DataStr=ItmId_"^"_Desc_"^"_Spec_"^"_Qty_"^"_ConsumeQty_"^"_ConsumeReasonId_"^"_ConsumeReasonDesc_"^"_NotUseFlag_"^"_Remarks_"^"_OneOffFlag
		s ItmStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DataStr,Title)
		i ResultStr="[" d
		.s ResultStr=ResultStr_ItmStr
		e  d
		.s ResultStr=ResultStr_","_ItmStr
	}
	s ResultStr=ResultStr_"]"
	d Result.Close()
	q ResultStr
}

}
