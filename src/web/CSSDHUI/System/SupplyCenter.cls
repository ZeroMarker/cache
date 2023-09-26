Import SQLUser

Class web.CSSDHUI.System.SupplyCenter Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

ClassMethod jsSave(Params As %String, Others As %String) As %Library.String
{
	n (Params,Others)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params,Others)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 消毒供应中心
/// 保存消毒供应中心信息
/// w ##class(web.CSSDHUI.System.SupplyCenter).Save()
ClassMethod Save(Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Params,Others)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	q:((Sc'=0)||(OthersSc="")) RtnObj.Err(-1,"",MethodName_"入参解析失败!")

	s HospId=OthersObj.%Get("BDPHospital")

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s SupLocId=Obj.%Get("SupLocId")
		
		i SupLocId="" d RtnObj.Err(-2,"",MethodName_"科室为空，无法保存！")
		continue:RtnObj.success'=0

		s TmpId=""
		&sql(SELECT %ID into :TmpId FROM CSSD_DeptCenter where CSSDD_Loc_DR=:SupLocId and CSSDD_Hosp_DR=:HospId)
		i ((TmpId'="")&&(TmpId'=RowId)) d RtnObj.Err(-3,"","科室已存在!","",0)
		continue:RtnObj.success'=0

		i RowId="" d
		.s DeptObj=##class(User.CSSDDeptCenter).%New()
		e  d
		.s DeptObj=##class(User.CSSDDeptCenter).%OpenId(RowId)
		.d DeptObj.%Reload()
		d DeptObj.CSSDDLocSetObjectId(SupLocId)
		d DeptObj.CSSDDHospDRSetObjectId(HospId)
		s Sc=DeptObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"",MethodName_":保存失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// 删除消毒供应中心
/// w ##class(web.CSSDHUI.System.SupplyCenter).jsDelete()
ClassMethod jsDelete(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Delete(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Return:		RtnObj
/// Description:删除消毒供应中心
/// Creator:	qiushengxin
/// Date:		2019-04-12
/// Input:		Params
/// Output:		RtnObj
ClassMethod Delete(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败")
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s SupplyCenterId=Obj.%Get("RowId")
		continue:SupplyCenterId=""
		&sql(delete from CSSD_DeptCenter where %ID=:SupplyCenterId)
		i SQLCODE'=0 d RtnObj.Err(-2,SupplyCenterId,MethodName_":处理CSSD_DeptCenter失败,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// 供应中心
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.SupplyCenter","SelectAllSupplyCenter",^tmpbin(112))
Query SelectAllSupplyCenter(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,SupLocId,SupLocDesc,HospDesc") [ SqlProc ]
{
}

ClassMethod SelectAllSupplyCenterExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT %ID As RowId, CSSDD_Loc_DR, CSSDD_Hosp_DR, CSSDD_Hosp_DR->HOSP_Desc "
		_" FROM SQLUser.CSSD_DeptCenter order by RowId desc"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s SupLocId=Result.Data("CSSDD_Loc_DR")
		s HospId=Result.Data("CSSDD_Hosp_DR")
		s HospDesc=Result.Data("HOSP_Desc")
		continue:SupLocId=""
		continue:(HospId'=gHospId)
		s SupLocDesc=$p($g(^CTLOC(SupLocId)),"^",2)
		d OutPutRowSupplyCenter
	}
	d Result.Close()
	Quit $$$OK
OutPutRowSupplyCenter
	s Data=$lb(RowId,SupLocId,SupLocDesc,HospDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
