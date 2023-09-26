Import sqluser

/// wfg  清洗不合格登记明细
Class web.CSSDHUI.Clean.CleanFailItem Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:wn
/// CreatDate:2020.1.9
/// Description:保存清洗不合格登记页面明细
/// Table:CSSD_UsedPredoDetail
/// Input:MainId : 主表单据ID ,Params : 明细的消毒包、器械、数量等参数
/// Output:
/// Return:
/// w ##class(web.CSSDHUI.Clean.CleanFailItem).jsSaveSter(^tmpljl("4"),^tmpljl("3"))
ClassMethod jsSaveSter(MainId, Params) As %Library.String
{
	n (%session,MainId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SaveSter(MainId,Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod SaveSter(MainId, Params) As web.CSSDHUI.RtnObj
{
	n (%session,MainId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((MainId="")||(Params="")) q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	
	s Status=$lg(^User.CSSDUsedPrdoD(MainId),6)
	i Status="1" q RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"单据已确认,不能添加!"))
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s PkgNum=Obj.%Get("PkgNum")
		s ReasonAnalysis=Obj.%Get("ReasonAnalysis")
		s Improve=Obj.%Get("Improve")
		s ReasonId=Obj.%Get("ReasonId")
		s ItmId=Obj.%Get("ItmId")
		s PkgId=Obj.%Get("PkgId")
		s CodeDictId=Obj.%Get("CodeDictId")
		s CleanDetailId=Obj.%Get("CleanDetailId")
		s PkgMainQty=Obj.%Get("PkgMainQty")
		s ExistRowId=..ChkIsExist(MainId,ItmId,PkgId,CodeDictId)
		i ((ExistRowId'="")&&(ExistRowId'=RowId)) d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"保存失败,器械重复"))
		q:RtnObj.success'=0
		
		s ItmObj=""
		i RowId="" d
		.s ItmObj=##class(User.CSSDUsedPredoDetail).%New()
		.s ItmObj.CSSDUPDMainDr=##class(User.CSSDUsedPrdo).%OpenId(MainId)
		.s ItmObj.CSSDUPDItm=##class(User.CSSDItem).%OpenId(ItmId)
		.s ItmObj.CSSDUPDPkg=##class(User.CSSDPackage).%OpenId(PkgId)
		.s ItmObj.CSSDUPDCleanDetailDr=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
		.s ItmObj.CSSDUPDQxpcNum=PkgNum
		.s ItmObj.CSSDUPDBarCode=CodeDictId
		.s ItmObj.CSSDUPDPkgNum=PkgMainQty
		e  d
		.s ItmObj=##class(User.CSSDUsedPredoDetail).%OpenId(RowId)
		s ItmObj.CSSDUPDQueWhy=##class(User.CSSDCleanItmReason).%OpenId(ReasonId)
		s ItmObj.CSSDUPDSumNum=PkgNum
		s ItmObj.CSSDUPDReasonAnalysis=ReasonAnalysis
		s ItmObj.CSSDUPDImprove=Improve
		s Sc=ItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_"jsSave:"_..%Translate($CLASSNAME(),"保存失败!"))
		q:RtnObj.success'=0
	}
	
	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.1.9
/// Description:判断新增明细时是否有重复
/// Table:CSSD_UsedPredoDetail
/// Input:MainId : 主表单据ID ,ItmDr : 器械ID ,PackageDr:消毒包ID
/// Output:
/// Return:
/// w ##class(web.CSSDHUI.Clean.CleanFailItem).ChkIsExist("328","1","436")
ClassMethod ChkIsExist(MainId As %String, ItmDr As %String, PackageDr As %Integer, BarCode As %String)
{
	n (%session,MainId,ItmDr,PackageDr,BarCode) 
	i ((MainId="")||(PackageDr="")||(ItmDr="")) q ""
	s (result,regid)=""
	i BarCode'="" d
	.s regid=$o(^User.CSSDUsedPredoDetailI("CSSDUPDMainDrItmPkgBarCodeIndex",MainId,ItmDr,PackageDr,BarCode,regid)) q:regid=""  d
	e  d
	.s regid=$o(^User.CSSDUsedPredoDetailI("CSSDUPDMainDrItmPkgIndex",MainId,ItmDr,PackageDr,regid)) q:regid=""  d
	s result=regid
	q result
}

/// Creator:wn
/// CreatDate:2020.1.9
/// Description:清洗不合格登记页面根据主表ID查询明细
/// Table:CSSD_UsedPredoDetail
/// Input: MainId:对应主表ID
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanFailItem","SelectByF","6")
Query SelectByF(MainId As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PkgId,ItmId,PkgNum,ReasonId,IsUsed,ReasonDesc,PkgDesc,ItmDesc,ItmSpec,ReasonAnalysis,Improve,CodeDict,CodeDictDesc,MaxCleanQty")
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, MainId As %String) As %Status
{
	n (%session,qHandle,MainId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:MainId="" $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID as RowId,CSSDUPD_Itm,CSSDUPD_SumNum as pkgnum, CSSDUPD_Pkg,CSSDUPD_BarCode,"
			_"CSSDUPD_QueWhy as QueWhy,CSSDUPD_ReasonAnalysis, CSSDUPD_Improve,CSSDUPD_CleanDetailDr,"
			_"CSSDUP_QxpcNum as MaxCleanQty FROM CSSD_UsedPredoDetail "
			_"WHERE CSSDUPD_MainDr="_MainId_""
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ItmId = Result.Data("CSSDUPD_Itm")
		s PkgNum = Result.Data("pkgnum")
		s MaxCleanQty = Result.Data("MaxCleanQty")
		s PkgId = Result.Data("CSSDUPD_Pkg")
		continue:PkgId=""
		s ReasonAnalysis = Result.Data("CSSDUPD_ReasonAnalysis")	//不合格原因分析
		s Improve = Result.Data("CSSDUPD_Improve")	//改进措施
		s CodeDict = Result.Data("CSSDUPD_BarCode")	//标牌编码
		s ReasonId = Result.Data("QueWhy")
		s CleanDetailId = Result.Data("CSSDUPD_CleanDetailDr")
		s IsUsedPkg=$List(^User.CSSDPackageD(PkgId),7)
		s PkgDesc=$List(^User.CSSDPackageD(PkgId),5)
		s AttributeId=$List(^User.CSSDPackageD(PkgId),15)
		
		s (IsUsedItm,ItmDesc,ItmSpec,ReasonDesc,CodeDictDesc)=""
		i ItmId'="" d
		.s IsUsedItm=$List(^User.CSSDItemD(ItmId),5)
		.s ItmDesc=$List(^User.CSSDItemD(ItmId),2)
		.s ItmSpec=$List(^User.CSSDItemD(ItmId),3)
		s:ReasonId'="" ReasonDesc=$List(^User.CSSDCleanItmReasonD(ReasonId),3)
		s:CodeDict'="" CodeDictDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(CodeDict)
		s IsUsed=IsUsedPkg_"^"_IsUsedItm
		
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,PkgId,ItmId,PkgNum,ReasonId,IsUsed,ReasonDesc,PkgDesc,ItmDesc,ItmSpec,ReasonAnalysis,Improve,CodeDict,CodeDictDesc,MaxCleanQty) 
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wn
/// CreatDate:2020.1.9
/// Description:删除清洗不合格登记页面明细(前端调用)
/// Table:CSSD_UsedPredoDetail
/// Input: rowId:当前明细ID
/// Output:
/// Return:
/// d ##class(web.CSSDHUI.Clean.CleanFailItem).jsDelete(3)
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!")).Json()
	
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

/// Creator:wn
/// CreatDate:2020.1.9
/// Description:删除清洗不合格登记页面明细
/// Table:CSSD_UsedPredoDetail
/// Input:rowId:当前明细ID
/// Output:
/// Return:
/// d ##class(web.CSSDHUI.Clean.CleanFailItem).Delete(3)
ClassMethod Delete(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i RowId="" d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	q:RtnObj.success'=0 RtnObj
	
	s UPDObj=##class(User.CSSDUsedPredoDetail).%OpenId(RowId)
	q:'$IsObject(UPDObj) RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"已删除"))
	
	s UPMainStatus=UPDObj.CSSDUPDMainDr.CSSDSPStatus
	q:UPMainStatus=1 RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"已确认不能删除"))
	
	&sql(Delete From CSSD_UsedPredoDetail WHERE ID=:RowId)
	q:SQLCODE'=0 RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"删除数据失败"))
	
	q RtnObj
}

/// Creator:my
/// Date:2022-06-22
/// Description:查询清洗验收不合格未加入清洗不合格明细的消毒包数据(清洗不合格登记页面弹窗调用)
/// Input: CleanMainId,PrdoId
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanFailItem","GetCleanFailPackage",^tmpollknbb)
Query GetCleanFailPackage(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "PkgId,PkgDesc,CodeDictId,CleanNum,AttributeIdDesc,CleanDetailId,ReasonId,UnPassReasonDesc,ItmId,ItmDesc,PkgNum,ItmSpec,PkgMainQty") [ SqlProc ]
{
}

ClassMethod GetCleanFailPackageExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	
	s CleanMainId=PJObj.%Get("CleanMainId")
	q:CleanMainId="" $$$OK
	
	s PrdoId=PJObj.%Get("PrdoId")
	s RegisterFlag=PJObj.%Get("RegisterFlag") ;待登记弹框:1 不合格包弹框为:""
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID,CSSDCDP_Label,CSSDPR_Package_DR->CSSDP_Desc as PkgDesc,CSSDCDP_UnPassQty,CSSDCDP_Reason->CSSD_RejectDesc as UnPassReasonDesc,"
			_" CSSDCDP_CleanMainDR->CSSDC_No as CleanNum,CSSDPR_Package_DR,CSSDPR_Package_DR->CSSDP_PackTypeDetail as AttributeId,CSSDCDP_Reason "
			_" FROM CSSD_CleanDetailPacks WHERE CSSDCDP_CleanMainDR='"_CleanMainId_"' and CSSDCDP_UnPassQty IS NOT NULL "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s CleanDetailId = Result.Data("ID")
		s UnPassQty = Result.Data("CSSDCDP_UnPassQty")
		continue:UnPassQty=0
		
		s PkgId = Result.Data("CSSDPR_Package_DR")
		s PkgDesc = Result.Data("PkgDesc")
		s CleanNum = Result.Data("CleanNum")
		s AttributeId = Result.Data("AttributeId")
		s AttributeIdDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
		s CodeDictId = Result.Data("CSSDCDP_Label")
		s ReasonId = Result.Data("CSSDCDP_Reason")
		s UnPassReasonDesc = Result.Data("UnPassReasonDesc")
		s PkgMainQty=UnPassQty
		
		;消毒包关联器械明细
		s PkgItmId="",ItmDesc="",PkgNum=0,ItmSpec="",UPItmId="",ItmId=""
		s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,""))
		
		i PkgItmId'="" {
			s PkgItmId=""
			f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,PkgItmId)) q:PkgItmId=""  d
			.s PkgItmObj=##class(User.CSSDPackageItem).%OpenId(PkgItmId)
			.s PkgItmQty=PkgItmObj.CSSDPIQty
			.s PkgNum=UnPassQty*PkgItmQty
			.s ItmId=PkgItmObj.CSSDPIItmDRGetObjectId()
			.i RegisterFlag'="1" s UPItmId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDMainCleanDItmIndex",PrdoId,CleanDetailId,ItmId,0))
			.q:UPItmId'="" 
			.
			.i ItmId'="" d
			..s ItmDesc=$lg(^User.CSSDItemD(ItmId),2)
			..s ItmSpec=$lg(^User.CSSDItemD(ItmId),3)
			..s DetailId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDCleanDItmUPDItmIndex",CleanDetailId,ItmId,""))
			..q:DetailId'=""
			..
			..d OutPutCleanFailPackage
		}else {
			i RegisterFlag'="1" s UPItmId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDMainCleanDPkgIndex",PrdoId,CleanDetailId,PkgId,0))
			continue:UPItmId'=""
			s PkgNum=UnPassQty
			s DetailId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDCleanDItmIndex",CleanDetailId,""))
			continue:DetailId'=""
			d OutPutCleanFailPackage
		}
	}
	d Result.Close()
	Quit $$$OK
	
OutPutCleanFailPackage
	s Data=$lb(PkgId,PkgDesc,CodeDictId,CleanNum,AttributeIdDesc,CleanDetailId,ReasonId,UnPassReasonDesc,ItmId,ItmDesc,PkgNum,ItmSpec,PkgMainQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
