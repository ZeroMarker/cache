Import sqluser

/// Creator:ban
/// CreatDate:2021.6.24
/// Description:外来器械申请科室、标牌追溯包回收中的回收科室、接收界面的接收科室下拉数据源都需要动态的去绑定科室
/// Table:CSSD_BindLoc
Class web.CSSDHUI.System.BindLoc Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

ClassMethod jsSave(Params As %String, Others As %String) As %Library.String
{
	n (Params,Others)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params,Others)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Return:RtnObj
/// Description:保存维护的科室数据
/// Creator:ban
/// Date:2021.6.24
/// Table:CSSD_BindLoc
/// Input:Params, Others
/// Output:RtnObj 多院区
/// w ##class(web.CSSDHUI.System.BindLoc).Save()
ClassMethod Save(Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Params,Others)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OthersSc'=0)) q RtnObj.Err(-1,"","入参解析失败!")

	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s SupLocId=Obj.%Get("SupLocId")
		s TypeCode=Obj.%Get("TypeCode")
		s Description=Obj.%Get("TypeDesc")
		s LocId=Obj.%Get("LocId")
		s UseFlag=Obj.%Get("UseFlag")
		s DefaultFlag=Obj.%Get("DefaultFlag")
		i TypeCode="" s TypeCode="RecLoc",Description="接收科室"

		s BindId=$o(^User.CSSDBindLocI("CSSDBLDeptCenterTypeLocDr",SupLocId,TypeCode,LocId,""))
		i ((BindId'="")&&(BindId'=RowId)) d RtnObj.Err(-2,"","该科室已存在！")
		continue:RtnObj.success'=0

		i RowId="" d
		.s BindLocObj=##class(User.CSSDBindLoc).%New()
		e  d
		.s BindLocObj=##class(User.CSSDBindLoc).%OpenId(RowId)
		.d BindLocObj.%Reload()
		s BindLocObj.CSSDBLTypeCode=TypeCode
		s BindLocObj.CSSDBLTypeDesc=Description
		d BindLocObj.CSSDBLDeptCenterDrSetObjectId(SupLocId)
		d BindLocObj.CSSDBLLocDrSetObjectId(LocId)
		s BindLocObj.CSSDBLUseFlag=UseFlag
		s BindLocObj.CSSDBLDefaultFlag=DefaultFlag
		s Sc=BindLocObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-3,"","保存失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Return:RtnObj.Json()
/// Description:删除召回原因
/// Creator:ban
/// Date:2021.6.24
/// Table:CSSD_BindLoc
/// Input:Params
/// Output:RtnObj
/// w ##class(web.CSSDHUI.System.BindLoc).jsDelete("")
ClassMethod jsDelete(Params) As %Library.String
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

/// Return:RtnObj
/// Description:删除绑定科室
/// Creator:ban
/// Date:2021.6.24
/// Table:CSSD_BindLoc
/// Input:Params
/// Output:RtnObj
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

		s BindLocID=Obj.%Get("RowId")
		continue:BindLocID=""
		
		&sql(delete from CSSD_BindLoc where CSSDBL_Rowid=:BindLocID)
		i SQLCODE'=0 d RtnObj.Err(-2,BindLocID,MethodName_":处理CSSD_BindLoc失败,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// Return:RtnObj.Json()
/// Description:获取维护的科室数据
/// Creator:ban
/// Date:2021.6.24
/// Table:CSSD_BindLoc
/// Input:ID
/// Output:RtnObj
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.BindLoc","SelectAllBindLoc","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query SelectAllBindLoc(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,SupLocId,SupLocDesc,TypeCode,LocId,LocDesc,UseFlag,DefaultFlag") [ SqlProc ]
{
}

ClassMethod SelectAllBindLocExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDBL_Rowid,CSSDBL_TypeCode,CSSDBL_DeptCenterDr as DeptCenterLocDr,"
		_"CSSDBL_DeptCenterDr->CTLOC_Desc as DeptCenterLocDesc,CSSDBL_TypeDesc,"
		_"CSSDBL_LocDr,CSSDBL_LocDr->CTLOC_Desc as LocDesc, CSSDBL_UseFlag,CSSDBL_DefaultFlag "
		_" FROM CSSD_BindLoc order by CSSDBL_TypeCode,CSSDBL_LocDr->CTLoc_Desc"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDBL_Rowid")
		s SupLocId = Result.Data("DeptCenterLocDr")
		s SupLocDesc = Result.Data("DeptCenterLocDesc")
		s TypeCode = Result.Data("CSSDBL_TypeCode")
		s LocId = Result.Data("CSSDBL_LocDr")
		s LocDesc = Result.Data("LocDesc")
		s UseFlag = Result.Data("CSSDBL_UseFlag")
		s DefaultFlag = Result.Data("CSSDBL_DefaultFlag")

		continue:(SupLocId="")
		;只要医院配置了供应中心,即可显示
		continue:'$d(^User.CSSDDeptCenterI("HospDept",gHospId,SupLocId))

		d OutPutRowBindLoc
	}
	d Result.Close()
	Quit $$$OK
OutPutRowBindLoc
	s Data=$lb(RowId,SupLocId,SupLocDesc,TypeCode,LocId,LocDesc,UseFlag,DefaultFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:依据科室类型获取默认值
/// Creator:lxt
/// Date:20220317
/// Table:CSSD_BindLoc
/// Input:Params
/// Output:Json
/// w ##class(web.CSSDHUI.System.BindLoc).GetDefaultLoc(^templxt("GetDefaultLoc"))
ClassMethod GetDefaultLoc(Params) As %String
{
	n (Params)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 "{}"

	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s PHospId=PJObj.%Get("BDPHospital")
	s PType=PJObj.%Get("Type")

	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
	q:PType="" "{}"

	s Date=+$h
	s HospSr=PHospId
	s AppParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_PHospId
	s ShowAllHospital=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCOMMON","ShowAllHospital",AppParam)
	i ShowAllHospital=1 d
	.s HospSr=##class(web.CSSDHUI.HospMap).GetGroupHospStr("CT_Loc",PHospId)
	e  i ShowAllHospital=2 d
	.s HospSr=##class(web.CSSDHUI.HospMap).GetAllHospStr()

	s DefaultLocId="",DefaultLocDesc=""
	s RowId=0
	f  s RowId=$o(^User.CSSDBindLocI("CSSDBLTypeDefaultFlagIndex",PType,"Y",RowId)) q:(RowId="")||(DefaultLocId'="")  d
	.s BindObj=##class(User.CSSDBindLoc).%OpenId(RowId)
	.d BindObj.%Reload()
	.s LocId=BindObj.CSSDBLLocDr.%Id()
	.s LocHospId=..sssHospId(LocId)
	.q:(HospSr'="")&&(HospSr'[LocHospId)
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s ToDate=$p(^CTLOC(LocId),"^",25)
	.q:(ToDate'="")&&(Date>ToDate)
	.q:(FromDate'="")&&(Date<FromDate)
	.s DefaultLocId=LocId

	s DefaultLocDesc=$s(DefaultLocId'="":$p(^CTLOC(DefaultLocId),"^",2),1:"")

	s Data=DefaultLocId_"^"_DefaultLocDesc
	s Title="RowId^Description"
	s Str=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Str
}

/// Description:依据科室类型获取默认值
/// Creator:lxt
/// Date:20220317
/// Table:CSSD_BindLoc
/// Input:Params
/// Output:Json
/// w ##class(web.CSSDHUI.System.BindLoc).UpdateBindLoc("3,4","RecLoc")
ClassMethod UpdateBindLoc(LocStr, Type, SupplyLocDr) As web.CSSDHUI.RtnObj
{
	n (LocStr,Type,SupplyLocDr)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:(LocStr="") RtnObj.Err(-1,"","科室不能为空！")
	s TypeDesc="接收科室"
	i Type="" d
	.s Type="RecLoc"
	.s TypeDesc="接收科室"

	s Len=$l(LocStr,",")
	f i=1:1:Len q:(RtnObj.success'=0)  d
	.s LocId=$p(LocStr,",",i)
	.s RowId=$o(^User.CSSDBindLocI("CSSDBLDeptCenterTypeLocDr",SupplyLocDr,Type,LocId,0))
	.q:RowId'=""
	.s BindLocObj=##class(User.CSSDBindLoc).%New()
	.s BindLocObj.CSSDBLTypeCode=Type
	.s BindLocObj.CSSDBLTypeDesc=TypeDesc
	.d BindLocObj.CSSDBLLocDrSetObjectId(LocId)
	.d BindLocObj.CSSDBLDeptCenterDrSetObjectId(SupplyLocDr)
	.s BindLocObj.CSSDBLUseFlag="Y"
	.s BindLocObj.CSSDBLDefaultFlag="N"
	.s Sc=BindLocObj.%Save()
	.i $$$ISERR(Sc) d RtnObj.Err(-3,"","保存科室失败！")

	q RtnObj
}

}
