Import sqluser

/// 灭菌不合格登记
/// wfg
Class web.CSSDHUI.PackageSterilize.SterilizeFail Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description:查询灭菌不合格记录
/// Table:cssd_sterpredo
/// Input:Params:查询灭菌不合格记录
/// Output:
/// Return:日志信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageSterilize.SterilizeFail","SelectAll",^tmpmy("hhh"))
Query SelectAll(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,CSSDSPNo,CSSDSPLoc,CSSDSPDate,Register,Status,SterNo") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PDeptLocID=PJObj.%Get("DeptLocID")
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID,CSSDSP_No,CSSDSP_Loc,CSSDSP_Date,CSSDSP_Time,CSSDSP_Register,CSSDSP_Status,"
			_"CSSDSP_SterNo FROM CSSD_SterPredo where CSSDSP_Date between "_PStartDate_" AND "_PEndDate_" "
	
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s CSSDSPNo = Result.Data("CSSDSP_No")
		s CSSDSPLocDR = Result.Data("CSSDSP_Loc")
		s CSSDSPLoc=..sssLocDesc(CSSDSPLocDR)
		continue:((PDeptLocID'="")&(PDeptLocID'=CSSDSPLocDR))
		s CSSDSPDate = Result.Data("CSSDSP_Date")
		s CSSDSPTime = Result.Data("CSSDSP_Time")
		s RegisterId=Result.Data("CSSDSP_Register")
		s Status = Result.Data("CSSDSP_Status")
		s SterNo = Result.Data("CSSDSP_SterNo") 
		s CSSDSPDate=..DL2H(CSSDSPDate)
		s CSSDSPTime=..TL2H(CSSDSPTime)
		s CSSDSPDateTime=CSSDSPDate_" "_CSSDSPTime
		s RegisterName=..sssUserName(RegisterId)
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,CSSDSPNo,CSSDSPLoc,CSSDSPDateTime,RegisterName,Status,SterNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description: 提交单据
/// Table:cssd_sterpredo
/// Input:mainRowId:主表id
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeFail).jsCancelOrder(3)
ClassMethod jsCancelOrder(SterFailId As %String) As %Library.String
{
	n (%session,SterFailId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i SterFailId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!")).Json()
	ts
	s RtnObj=..CancelOrder(SterFailId)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description: 撤销提交的单据
/// Table:cssd_sterpredo
/// Input:mainRowId:主表id
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeFail).jsCancelOrder(3)
ClassMethod CancelOrder(SterFailId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,SterFailId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s SterFailObj=##class(User.CSSDSterPrdo).%OpenId(SterFailId)
	i '$IsObject(SterFailObj) d RtnObj.Err(-1,"","未获取不合格信息！")
	q:RtnObj.success'=0 RtnObj
	
	d SterFailObj.%Reload()
	s Status=SterFailObj.CSSDSPStatus
	i Status'=1 d RtnObj.Err(-2,"","只有提交状态的单据才能撤销！")
	q:RtnObj.success'=0 RtnObj
	
	&sql(UPDATE CSSD_SterPredo SET CSSDSP_Status = 0 WHERE ID = :SterFailId)
	i SQLCODE'=0 d RtnObj.Err(-3,"","撤销失败!")
	q RtnObj
}

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description: 提交单据
/// Table:cssd_sterpredo
/// Input:mainRowId:主表id
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeFail).jsSubmitOrder(3)
ClassMethod jsSubmitOrder(SterFailId As %String) As %Library.String
{
	n (%session,SterFailId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i SterFailId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!")).Json()
	ts
	s RtnObj=..SubmitOrder(SterFailId)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description: 提交单据
/// Table:cssd_sterpredo
/// Input:mainRowId:主表id
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeFail).SubmitOrder(3)
ClassMethod SubmitOrder(SterFailId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,SterFailId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s SterFailObj=##class(User.CSSDSterPrdo).%OpenId(SterFailId)
	i '$IsObject(SterFailObj) d RtnObj.Err(-1,"","未获取不合格信息！")
	q:RtnObj.success'=0 RtnObj
	
	d SterFailObj.%Reload()
	s Status=SterFailObj.CSSDSPStatus
	i Status=1 d RtnObj.Err(-2,"","单据已提交，不能再次提交！")
	q:RtnObj.success'=0 RtnObj
	
	s SterFailItmId=$o(^User.CSSDSterPredoDetailI("IndexMainDr",SterFailId,""))
	i SterFailItmId="" d RtnObj.Err(-3,"","灭菌不合格单据无明细，不能提交！")
	q:RtnObj.success'=0 RtnObj
	
	&sql(UPDATE CSSD_SterPredo SET CSSDSP_Status = 1 WHERE ID = :SterFailId)
	i SQLCODE'=0 d RtnObj.Err(-4,"","灭菌不合格信息提交失败！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

}
