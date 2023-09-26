Import sqluser

/// wfg
Class web.CSSDHUI.PackageSterilize.SterilizeFailItem Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description: 保存消毒包分类信息
/// Table:cssd_sterpredo、CSSD_SterPredoDetail
/// Input:MainId:主表id,Params:明细数据
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.SterilizeFailItem).jsSaveSterFailItm("38","[{""RowId"":""64"",""Label"":""10062023021600005"",""PkgDesc"":""手术衣包"",""ReasonId"":""4"",""ReasonDesc"":""标签字迹不清晰"",""ReasonAnalysis"":""11"",""Improve"":""22""}]")
ClassMethod jsSaveSterFailItm(SterFailId, Params) As %Library.String
{
	n (%session,SterFailId,Params)
	s $ZT=..sssError()
	ts
	s RtnObj=..SaveSterFailItm(SterFailId,Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

ClassMethod SaveSterFailItm(SterFailId, Params) As web.CSSDHUI.RtnObj
{
	n (%session,SterFailId,Params)
	
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((SterFailId="")||(Params="")) d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s SterFailObj=##class(User.CSSDSterPrdo).%OpenId(SterFailId)
	d SterFailObj.%Reload()
	i SterFailObj="" d RtnObj.Err(-2,"","未获取实体对象信息!")
	q:RtnObj.success'=0 RtnObj
	
	s SterFailNo =SterFailObj.CSSDSPNo
	s Status=SterFailObj.CSSDSPStatus
	i Status="1" d RtnObj.Err(-2,"","单据已确认，不能修改！")
	q:RtnObj.success'=0 RtnObj
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s Label=Obj.%Get("Label")
		s ReasonId=Obj.%Get("ReasonId")
		s ReasonAnalysis=Obj.%Get("ReasonAnalysis")
		s Improve=Obj.%Get("Improve")
		s TransId= $o(^User.CSSDTransI("CSSDTLabel",Label,""))
		i TransId="" d RtnObj.Err(-4,"","保存失败!无效的标签"_Obj.%Get("Label"))
		continue:RtnObj.success'=0
		
		s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
		d TransObj.%Reload()
		continue:'$IsObject(TransObj)
		s ExpDate=TransObj.CSSDTExpDate
		s NowDate=$p($h,",",1)
		i NowDate>=ExpDate d RtnObj.Err(-6,"","标签已经过期!"_Obj.%Get("Label"))
		continue:RtnObj.success'=0
		
		s SterPredoItmId = $o(^User.CSSDSterPredoDetailI("IndexLable",Label,""))
		i ((SterPredoItmId'="")&&(RowId'=SterPredoItmId)) d RtnObj.Err(-6,"","同一条码不可以重复录入!"_Obj.%Get("pkgnum"))
		continue:RtnObj.success'=0
		
		s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""))
		i SterItmId="" d RtnObj.Err(-5,"","该标签未进行灭菌,不能添加"_Obj.%Get("pkgnum"))
		continue:RtnObj.success'=0
		
		s SterMainId=""
		s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
		i '$IsObject(SterItmObj) d RtnObj.Err(-5,"","未获取到标签信息!")
		continue:RtnObj.success'=0
		s SterMainId=SterItmObj.CSSDPSParrefGetObjectId()
		s IsCheck=$lg(^User.CSSDSterilizeRecordD(SterMainId),27)
		s CompFlag=$lg(^User.CSSDSterilizeRecordD(SterMainId),19)
		i ((CompFlag'="Y")&&(CompFlag'="F")) d RtnObj.Err(-10,"","该标签未灭菌,不能添加不合格记录!"_Obj.%Get("pkgnum"))
		continue:RtnObj.success'=0
		i ((CompFlag="Y")&&(IsCheck="")) d RtnObj.Err(-10,"","该标签未验收,不能添加不合格记录!"_Obj.%Get("pkgnum"))
		continue:RtnObj.success'=0
		i ((CompFlag="Y")&&(IsCheck=1)) d RtnObj.Err(-10,"","该标签已验收合格,不能添加不合格记录!"_Obj.%Get("pkgnum"))
		continue:RtnObj.success'=0
		
		s SterFailItmObj=""
		i RowId="" d
		.s SterFailItmObj=##class(User.CSSDSterPredoDetail).%New()
		e  d
		.s SterFailItmObj=##class(User.CSSDSterPredoDetail).%OpenId(RowId)
		.d SterFailItmObj.%Reload()
		s SterFailItmObj.CSSDSPDMainDr=##class(User.CSSDSterPrdo).%OpenId(SterFailId)
		s SterFailItmObj.CSSDSPDResion=##class(User.CSSDSteCheckReason).%OpenId(ReasonId)
		s SterFailItmObj.CSSDSPDNum=Label
		s SterFailItmObj.CSSDSUPDSterNo=SterFailNo
		s SterFailItmObj.CSSDSPDReasonAnalysis=ReasonAnalysis
		s SterFailItmObj.CSSDSPDImprove=Improve
		s Sc=SterFailItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-9,"",$ClassName()_"jsSave:保存失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Creator:wfg
/// CreatDate:2019-6-18
/// Description: 根据主表获取子表的数据列表
/// Table:CSSD_SterPredoDetail
/// Input:MainId:主表id
/// Output:
/// Return:日志信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageSterilize.SterilizeFailItem","SelectByF","5")
Query SelectByF(SterFailId As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,PkgDesc,ReasonId,ReasonDesc,ReasonAnalysis,Improve")
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, SterFailId As %String) As %Status
{
	n (%session,qHandle,SterFailId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:SterFailId="" $$$OK
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID as RowId, CSSDSPD_Num as pkgnum, CSSDSPD_Resion as QueSumNum,CSSDSPD_ReasonAnalysis, CSSDSPD_Improve, CSSDSP_Package_DR FROM CSSD_SterPredoDetail "
			_"WHERE CSSDSPD_MainDr="_SterFailId_""
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("RowId")
		s Label = Result.Data("pkgnum")
		s PkgId=Result.Data("CSSDSP_Package_DR")
		continue:PkgId=""
		s PkgObj = ##class(User.CSSDPackage).%OpenId(PkgId)
		s PkgDesc=PkgObj.CSSDPDesc
		s AttributeId=PkgObj.CSSDPPackTypeDetail
		i AttributeId="1" d
		.s FixLabel=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
		.s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(FixLabel)
		s ReasonId = Result.Data("QueSumNum")
		s ReasonAnalysis = Result.Data("CSSDSPD_ReasonAnalysis")
		s Improve = Result.Data("CSSDSPD_Improve")
		s ReasonDesc=""
		i ReasonId'="" d
		.s ReasonObj = ##class(User.CSSDSteCheckReason).%OpenId(ReasonId)
		.s ReasonDesc= ReasonObj.CSSDSteFailDesc
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Label,PkgDesc,ReasonId,ReasonDesc,ReasonAnalysis,Improve)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
