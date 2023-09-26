Import sqluser

/// 清洗不合格登记
/// wfg
Class web.CSSDHUI.Clean.CleanFailed Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:wn
/// CreatDate:2020.1.8
/// Description:查询清洗不合格登记页面的数据
/// Table:CSSD_UsedPredo
/// Input:Params 开始日期 结束日期 科室
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanFailed","SelectAll",^tmpljl("1"))
Query SelectAll(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,No,SupLocDesc,RegistDate,RegisterName,Status,CleanNum,CleanMainId") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	
	s pStartDate=PJObj.%Get("StartDate")
	s pEndDate=PJObj.%Get("EndDate")
	s pSupLocId=PJObj.%Get("SupLoc")
	q:((pStartDate="")||(pEndDate="")||(pSupLocId="")) $$$OK

	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID As RowId,CSSDUP_No,CSSDUP_Loc,CSSDUP_Date,CSSDUP_Time,"
		_"CSSDUP_Register,CSSDUP_Register->SSUSR_Name as RegisterName, CSSDUP_Status,CSSDUP_CleanNo,CSSDUP_Clean_Dr "
		_" FROM CSSD_UsedPredo where CSSDUP_Date between "_pStartDate_" and "_pEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s No = Result.Data("CSSDUP_No")
		s SupLocId = Result.Data("CSSDUP_Loc")
		continue:pSupLocId'=SupLocId
		s Date = Result.Data("CSSDUP_Date")
		s Time = Result.Data("CSSDUP_Time")
		s RegisterId = Result.Data("CSSDUP_Register")
		s Status = Result.Data("CSSDUP_Status")
		s CleanNum = Result.Data("CSSDUP_CleanNo")
		s CleanMainId = Result.Data("CSSDUP_Clean_Dr")
		s SupLocDesc=..sssLocDesc(SupLocId)	
		s RegistDate=..DL2H(Date)_" "_..TL2H(Time)
		s RegisterName=Result.Data("RegisterName")
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,No,SupLocDesc,RegistDate,RegisterName,Status,CleanNum,CleanMainId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wn
/// CreatDate:2020.1.8
/// Description:清洗不合格单据确认功能
/// Table:CSSD_UsedPredo,CSSD_UsedPredoDetail
/// Input:ID 要确认单据的ID
/// Output:
/// Return:
/// d ##class(web.CSSDHUI.Clean.CleanFailed).jsSubmitOrder(3)
ClassMethod jsSubmitOrder(Id As %String) As %Library.String
{
	n (%session,Id)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SubmitOrder(Id)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod SubmitOrder(Id As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Id)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Id="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s Obj=##class(User.CSSDUsedPrdo).%OpenId(Id)
	d Obj.%Reload()
	s Status=Obj.CSSDSPStatus
	i Status="1" d RtnObj.Err(-2,"","已确认不能重复确认！")
	q:RtnObj.success'=0 RtnObj
	
	s detailid=$o(^User.CSSDUsedPredoDetailI("CSSDUPDMainDrIndex",Id,""))
	i detailid="" d RtnObj.Err(-2,"","无明细不能确认")
	q:RtnObj.success'=0
	
	ts
	&sql(UPDATE CSSD_UsedPredo SET CSSDUP_Status = 1 WHERE ID = :Id)
	i SQLCODE'=0  d RtnObj.Err(-4,mainRowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-1-11
/// Description:判断不合格单据中的明细是否已清洗
/// Table:CSSD_UsedPredoDetail
/// d ##class(web.CSSDHUI.Clean.CleanFailed).IsClean("7")
ClassMethod IsClean(MainID) As %Library.String
{
	n (%session,MainID)
	s FailDetail="",States="N"
	f  s FailDetail=$o(^User.CSSDUsedPredoDetailI("CSSDUPDMainDrIndex",MainID,FailDetail)) q:((States="Y")||(FailDetail=""))  d
	.s FailDetailObj=##Class(User.CSSDUsedPredoDetail).%OpenId(FailDetail)
	.i $IsObject(FailDetailObj) d
	..d FailDetailObj.%Reload()
	..s States=FailDetailObj.CSSDUPDStates
	q States
}

///  Creator:wn
///  CreatDate:2020.1.8
///  Description:清洗不合格单据撤销功能
///  Table:CSSD_UsedPredo
///  Input:ID 要撤销单据的ID
///  Output:
///  Return:
/// d ##class(web.CSSDHUI.Clean.CleanFailed).jsCancelOrder("7")
ClassMethod jsCancelOrder(Id As %String) As %Library.String
{
	n (%session,Id)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CancelOrder(Id)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod CancelOrder(Id As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Id)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Id="" d RtnObj.Err(-1,"","入参不能为空！")
	q:RtnObj.success'=0 RtnObj
	
	s Obj=##class(User.CSSDUsedPrdo).%OpenId(Id)
	d Obj.%Reload()
	s Status=Obj.CSSDSPStatus
	i Status="0" d RtnObj.Err(-2,"","已撤销不能重复撤销！")
	q:RtnObj.success'=0 RtnObj
	
	s States=..IsClean(Id)
	i States="Y" d RtnObj.Err(-2,"","不合格包已清洗，不能进行撤销操作！")
	q:RtnObj.success'=0 RtnObj
	
	ts
	&sql(UPDATE CSSD_UsedPredo SET CSSDUP_Status = 0 WHERE ID = :Id)
	i SQLCODE'=0  d RtnObj.Err(-3,Id,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	i RtnObj.success<0 tro  q RtnObj
	tc
	
	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.1.8
/// Description:删除清洗不合格登记页面的数据
/// Table:CSSD_UsedPredo
/// Input:mainRowId 主表单据ID
/// Output:
/// Return:
/// d ##class(web.CSSDHUI.Clean.CleanFailed).jsDelete(3
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Delete(RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Delete(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i RowId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s UPObj=##class(User.CSSDUsedPrdo).%OpenId(RowId)
	q:'$IsObject(UPObj) RtnObj.Err(-1,"","已删除")
	
	s UPStatus=UPObj.CSSDSPStatus
	q:UPStatus=1 RtnObj.Err(-1,"","已确认不能删除")
	
	&sql(Delete From CSSD_UsedPredoDetail WHERE CSSDUPD_MainDr=:RowId)
	q:SQLCODE<0 RtnObj.Err(-2,"","删除明细数据失败")
	
	&sql(Delete From CSSD_UsedPredo WHERE ID=:RowId)
	q:SQLCODE'=0 RtnObj.Err(-2,"","删除数据失败")
	
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanFailed","Select",^tmplloij)
Query Select(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,CleanNum,SupLocId,SupLocDesc,CheckResult,CheckResultDesc") [ SqlProc ]
{
}

ClassMethod SelectExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	
	s pStartDate=PJObj.%Get("FStartDate")
	s pEndDate=PJObj.%Get("FEndDate")
	s pSupLocId=PJObj.%Get("FSupLoc")
	s gLocId=PJObj.%Get("gLocId")
	i pSupLocId="" s pSupLocId=gLocId
	q:((pStartDate="")||(pEndDate="")||(pSupLocId="")) $$$OK
	
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select ID,CSSDC_Loc_DR,CSSDC_No,CSSDC_Result "
		_" from CSSD_Clean where CSSDC_ChkDate between "_pStartDate_" and "_pEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s CleanNum = Result.Data("CSSDC_No")
		s CheckResult = Result.Data("CSSDC_Result")
		s SupLocId = Result.Data("CSSDC_Loc_DR")
		continue:CheckResult'="0"
		continue:pSupLocId'=SupLocId
		s SupLocDesc=..sssLocDesc(SupLocId)	
		s CheckResultDesc="不合格"
		
		;做过登记的不展示
		s CleanDetailId="",flag=0
		f  s CleanDetailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",RowId,CleanDetailId)) q:(CleanDetailId="")||(flag'=0)  d
		.s PkgId=$lg(^User.CSSDCleanDetailPacksD(CleanDetailId),5)
		.s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,""))
		.i PkgItmId'="" d
		.s PkgItmId=""
		.f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,PkgItmId)) q:PkgItmId=""  d
		..s PkgItmObj=##class(User.CSSDPackageItem).%OpenId(PkgItmId)
		..s ItmId=PkgItmObj.CSSDPIItmDRGetObjectId()
		..s UsedPredoDetailId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDCleanDItmUPDItmIndex",CleanDetailId,ItmId,""))
		..i UsedPredoDetailId="" s flag=1
		.e  d
		..s UsedPredoDetailId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDCleanDItmIndex",CleanDetailId,""))
		..i UsedPredoDetailId="" s flag=2
		continue:flag=0
		d OutPutRow1
	}
	d Result.Close()
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,CleanNum,SupLocId,SupLocDesc,CheckResult,CheckResultDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##Class(web.CSSDHUI.Clean.CleanFailed).CleanFailedRegister(^tmpllkll,^tmpllokjh)
ClassMethod CleanFailedRegister(Params As %String, Details As %String)
{
	n (%session,Params,Details)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	s DetailObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=DetailObj.%FromJSON(Details)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	s gUserId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s pCleanMainID=PJObj.%Get("CleanMainId")
	s CurDate=$P($h,",",1),CurTime=$P($h,",",2)
	s CleanMainObj=##class(User.CSSDClean).%OpenId(pCleanMainID)
	d CleanMainObj.%Reload()
	s CleanLocId=CleanMainObj.CSSDCLocDrGetObjectId()
	s Checker=CleanMainObj.CSSDCChkerGetObjectId()
	s CleanNum=CleanMainObj.CSSDCNo
	i Checker="" s Checker=gUserId
	
	//处理不合格登记主表
	s UPRowId=$o(^User.CSSDUsedPrdoI("IndexCleanStatus",pCleanMainID,"0",0))
	i UPRowId="" d
	.s Ret=..sssLock("CleanFail")
	.i Ret'=0 d RtnObj.Err(-1,"","生成清洗不合格批号加锁失败！") q
	.
	.s UPNo=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("CLEANFIAL")
	.s UPStatus=0
	.&sql(insert into cssd_usedpredo
		(CSSDUP_No,CSSDUP_Loc,CSSDUP_Register,CSSDUP_Status,CSSDUP_CleanNo,CSSDUP_Date,CSSDUP_Time,CSSDUP_Clean_Dr) 
		values 
		(:UPNo,:CleanLocId,:Checker,:UPStatus,:CleanNum,:CurDate,:CurTime,:pCleanMainID))
	.d ..sssUnLock("CleanFail")
	.i SQLCODE'=0 d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg)) q
	.s UPRowId=%ROWID
	q:RtnObj.success'=0 RtnObj
	
	//处理不合格登记子表
	while(RtnObj.success=0){
		s Obj=DetailObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s PkgId=Obj.%Get("PkgId")
		s PkgDesc=Obj.%Get("PkgDesc")
		s CodeDict=Obj.%Get("CodeDictId")
		s ItmId=Obj.%Get("ItmId")
		s ItmDesc=Obj.%Get("ItmDesc")
		s PkgNum=Obj.%Get("PkgNum")
		s ItmSpec=Obj.%Get("ItmSpec")
		s ReasonId=Obj.%Get("ReasonId")
		s UnPassReasonDesc=Obj.%Get("UnPassReasonDesc")
		s AttributeIdDesc=Obj.%Get("AttributeIdDesc")
		s CleanDetailId=Obj.%Get("CleanDetailId")
		s PkgMainQty=Obj.%Get("PkgMainQty")
		
		s ItmObj=""
		s ItmObj=##class(User.CSSDUsedPredoDetail).%New()
		s ItmObj.CSSDUPDMainDr=##class(User.CSSDUsedPrdo).%OpenId(UPRowId)
		s ItmObj.CSSDUPDItm=##class(User.CSSDItem).%OpenId(ItmId)
		s ItmObj.CSSDUPDPkg=##class(User.CSSDPackage).%OpenId(PkgId)
		s ItmObj.CSSDUPDCleanDetailDr=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
		s ItmObj.CSSDUPDQxpcNum=PkgNum
		s ItmObj.CSSDUPDBarCode=CodeDict
		s ItmObj.CSSDUPDPkgNum=PkgMainQty
		s ItmObj.CSSDUPDQueWhy=##class(User.CSSDCleanItmReason).%OpenId(ReasonId)
		s ItmObj.CSSDUPDSumNum=PkgNum
		s Sc=ItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"","更新清洗不合格登记子表失败!")
		q:RtnObj.success'=0
		
	}
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanFailed","Select","{""FStartDate"":""2023-01-05"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""FEndDate"":""2023-01-06"",""FSupLoc"":""166""}")
Query SelectCleanDetail(ID As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,CleanNum,SupLocId,SupLocDesc,CheckResult,CheckResultDesc") [ SqlProc ]
{
}

ClassMethod SelectCleanDetailExecute(ByRef qHandle As %Binary, ID As %String = "") As %Status
{
	n (qHandle,Params)
	s ^tmpllokmn=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	
	s pStartDate=PJObj.%Get("FStartDate")
	s pEndDate=PJObj.%Get("FEndDate")
	s pSupLocId=PJObj.%Get("FSupLoc")
	q:((pStartDate="")||(pEndDate="")||(pSupLocId="")) $$$OK
	
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select ID,CSSDC_Loc_DR,CSSDC_No,CSSDC_Result "
		_" from CSSD_Clean where CSSDC_ChkDate between "_pStartDate_" and "_pEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s CleanNum = Result.Data("CSSDC_No")
		s CheckResult = Result.Data("CSSDC_Result")
		s SupLocId = Result.Data("CSSDC_Loc_DR")
		continue:CheckResult'="0"
		continue:pSupLocId'=SupLocId
		s SupLocDesc=..sssLocDesc(SupLocId)	
		s CheckResultDesc="不合格"
		
		;做过登记的不展示
		s UsedPrdoId=$o(^User.CSSDUsedPrdoI("IndexCSSDUPCleanNo",CleanNum,""))
		continue:UsedPrdoId'=""
		
		d OutPutRowall
	}
	d Result.Close()
	Quit $$$OK
OutPutRowall
	s Data=$lb(RowId,CleanNum,SupLocId,SupLocDesc,CheckResult,CheckResultDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 待登记角标数量
/// w ##class(web.CSSDHUI.Clean.CleanFailed).GetMarkQty(^tmpljl("10"))
ClassMethod GetMarkQty(Params)
{
	n (%session,Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "0"
	
	s pStartDate = PJObj.%Get("StartDate")
	s pEndDate = PJObj.%Get("EndDate")
	s gHospId = PJObj.%Get("gHospId")
	s gGroupId = PJObj.%Get("gGroupId")
	s gLocId = PJObj.%Get("gLocId")
	s gUserId = PJObj.%Get("gUserId")
	s Data=pStartDate_"^"_pEndDate_"^"_gHospId_"^"_gGroupId_"^"_gLocId_"^"_gUserId
	s TmpTitle="gHospId^gGroupId^gLocId^gUserId"
	s Num=0
	s RegisterTitle="FStartDate^FEndDate^"_TmpTitle
	s RegisterParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,RegisterTitle)
	s RegisterResult=##class(%Library.ResultSet).%New("web.CSSDHUI.Clean.CleanFailed:Select")
	s sc=RegisterResult.Execute(RegisterParams)
	i $$$ISERR(sc) q "0"
	
	While(RegisterResult.Next()){s Num=Num+1}
	d RegisterResult.Close()
	q Num
}

}
