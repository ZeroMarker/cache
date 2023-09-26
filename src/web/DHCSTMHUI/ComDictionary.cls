Import sqluser

/// Descript:通用字典维护
/// Creater:wxj
/// CreateDate:	2022-06-15
Class web.DHCSTMHUI.ComDictionary Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存
/// w ##class(web.DHCSTMHUI.ComDictionary).jsSave(^tempxj("Type"),^tempxj("Main"),^tempxj("Detail"))
ClassMethod jsSave(Type As %String, Main As %String, Detail As %String) As %String
{
	n (Type,Main,Detail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i Type="DictType" d
	.s RtnObj=..SaveType(Main,Detail)
	e  d
	.s RtnObj=..SaveVal(Main,Detail)
	q RtnObj.Json()
}

/// Descript:	保存字典类型
/// Creator:	wxj
/// CreateDate:	2022-06-15
/// Table:		CT_HRP_MAT.ComDictType
ClassMethod SaveType(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	

	s gHospId=MainPJObj.%Get("gHospId")
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Detail)'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s DITypeCode=Obj.%Get("DITypeCode")
		s DITypeDesc=Obj.%Get("DITypeDesc")
		i RowId'="" d
		.s ComDictTypeInfo=^CT.HRP.MAT.ComDictTypeD(RowId)
		.s OrginCode=$lg(ComDictTypeInfo,2)
		.i DITypeCode'=OrginCode d RtnObj.Err(-2,RowId,OrginCode_" 代码维护后不允许修改!","",0)
		q:RtnObj.success<0		
		s TmpId=$o(^CT.HRP.MAT.ComDictTypeI("Code",DITypeCode,""))
		i (TmpId'="")&(TmpId'=RowId) d RtnObj.Err(-3,RowId,DITypeCode_" 代码重复!","",0)
		q:RtnObj.success<0
		s TmpId=$o(^CT.HRP.MAT.ComDictTypeI("Desc",DITypeDesc,""))
		i (TmpId'="")&(TmpId'=RowId) d RtnObj.Err(-3,RowId,DITypeDesc_" 名称重复!","",0)
		q:RtnObj.success<0		
		i RowId="" d
		.s obj=##class(CT.HRP.MAT.ComDictType).%New()
		e  d
		.s obj=##class(CT.HRP.MAT.ComDictType).%OpenId(RowId)
		.d obj.%Reload()
		s obj.ComDITypeCode=DITypeCode
		s obj.ComDITypeDesc=DITypeDesc
		s Sc=obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-6,"",MethodName_":保存失败!")
		q:RtnObj.success<0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj
}

/// Descript:	保存字典类型值
/// Creator:	wxj
/// CreateDate:	2020-8-19
/// Table:		CT_HRP_MAT.ComDictValue
ClassMethod SaveVal(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s DIValType=MainPJObj.%Get("DITypeCode")
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Detail)'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s DIValCode=Obj.%Get("DIValCode")
		s DIValDesc=Obj.%Get("DIValDesc")	
		s TempId=$o(^CT.HRP.MAT.ComDictValueI("CodeType",DIValCode,DIValType,""))
		i (TempId'="")&&(TempId'=RowId) d RtnObj.Err(-3,RowId,DIValCode_" 代码重复!","",0)	
		q:RtnObj.success<0
		
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",DIValDesc,"CT_HRP_MAT.ComDictValue",pHospId,RowId,"",DIValType)
		i ret>0 d RtnObj.Err(-4,RowId,DIValDesc_" 描述重复!","",0)
		q:RtnObj.success<0
		
		i RowId="" d
		.s obj=##class(CT.HRP.MAT.ComDictValue).%New()
		e  d
		.s obj=##class(CT.HRP.MAT.ComDictValue).%OpenId(RowId)
		.d obj.%Reload()
		s obj.ComDIValType=DIValType
		s obj.ComDIValCode=DIValCode
		s obj.ComDIValDesc=DIValDesc
		s Sc=obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-6,"",MethodName_":保存失败!")
		q:RtnObj.success<0
		
		i RowId="" d
		.s RowId=obj.%Id()
		.//保存医院关联
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("CT_HRP_MAT.ComDictValue",RowId,pHospId)
		.i ret<0 d RtnObj.Err(-7,"","关联医院失败"_ret)
		q:RtnObj.success<0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj
}

/// 查询字典类型
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ComDictionary","GetDictType",^tempxj(1))
Query GetDictType() As Query(ROWSPEC = "RowId,DITypeCode,DITypeDesc") [ SqlProc ]
{
}

ClassMethod GetDictTypeExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s SqlStr="SELECT ID, ComDI_TypeCode, ComDI_TypeDesc "
		_" FROM CT_HRP_MAT.ComDictType"
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s DITypeCode=Result.Data("ComDI_TypeCode")
		s DITypeDesc=Result.Data("ComDI_TypeDesc")
		d OutPutType
	}
	Quit $$$OK
OutPutType
	s Data=$lb(RowId,DITypeCode,DITypeDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 查询字典类型值
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ComDictionary","GetDictVal",^tempxj(1))
Query GetDictVal(Params As %String) As Query(ROWSPEC = "RowId,DIValType,DIValTypeDesc,DIValCode,DIValDesc") [ SqlProc ]
{
}

ClassMethod GetDictValExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s TypeCode=PJObj.%Get("TypeCode")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s SqlStr="SELECT ID, ComDI_ValType, ComDI_ValCode,ComDI_ValDesc "
		_" FROM CT_HRP_MAT.ComDictValue WHERE 1=1"
	i TypeCode'="" d
	.s SqlStr=SqlStr_" And ComDI_ValType='"_TypeCode_"'"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("CT_HRP_MAT.ComDictValue",RowId,pHospId)
		continue:ShowDataFlag="N"
		s DIValType=Result.Data("ComDI_ValType")
		s TypeId=$o(^CT.HRP.MAT.ComDictTypeI("Code",DIValType,""))
		continue:+TypeId'>0
		s DIValTypeDesc=$lg(^CT.HRP.MAT.ComDictTypeD(TypeId),3)
		s DIValCode=Result.Data("ComDI_ValCode")
		s DIValDesc=Result.Data("ComDI_ValDesc")
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,DIValType,DIValTypeDesc,DIValCode,DIValDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 删除字典类型
/// d ##class(web.DHCSTMHUI.ComDictionary).DeleteType(1)
ClassMethod DeleteType(RowId As %String) As %Library.String
{
	n (RowId,%session)
	;不能为空项
	s RtnObj=##class(RtnObj).%New()
	q:RowId="" RtnObj.Err(-10,RowId,"参数错误!").Json()
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("CT_HRP_MAT.ComDictType",RowId)
	&sql(Delete from CT_HRP_MAT.ComDictType where ID=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-10,RowId,"删除失败!")
	e  d
	.d ##class(Log).SaveLog("CT_HRP_MAT.ComDictType","CT.HRP.MAT.ComDictType","通用字典类型",RowId,"","D",JsonStr)
	q RtnObj.Json()
}

/// Descript:   删除字典类型值
/// w ##class(web.DHCSTMHUI.ComDictionary).jsDelete()
ClassMethod jsDelete(Params As %String) As %Library.String
{
    n (Params)   
    s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
 	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj="" 
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..DeleteVal(RowId)
		continue:RtnObj.success<0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// 删除字典类型值
/// d ##class(web.DHCSTMHUI.ComDictionary).DeleteVal(1)
ClassMethod DeleteVal(RowId As %String) As RtnObj
{
	n (RowId,%session)
	;不能为空项
	s RtnObj=##class(RtnObj).%New()
	q:RowId="" RtnObj.Err(-10,RowId,"参数错误!").Json()
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("CT_HRP_MAT.ComDictValue",RowId)
	&sql(Delete from CT_HRP_MAT.CT_HRP_MAT.ComDictValue where ID=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-10,RowId,"删除失败!")
	e  d
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("CT_HRP_MAT.ComDictValue",RowId)
	.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	.q:RtnObj.success'=0
	.s RtnObj=##class(Log).SaveLog("CT_HRP_MAT.ComDictValue","CT.HRP.MAT.ComDictValue","通用字典类型值",RowId,"","D",JsonStr)
	q RtnObj
}

}
