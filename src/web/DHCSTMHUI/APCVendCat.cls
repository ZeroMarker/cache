Import sqluser

/// Descript:	供应商分类相关
/// Creater:    tsr
/// CreateDate: 2018-08-09
Class web.DHCSTMHUI.APCVendCat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询供应商分类
/// Creater:	tsr
/// CreateDate:	2018-08-09
Query GetVendorCat(Params) As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod GetVendorCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT APCVC_RowId RowId, APCVC_Code, APCVC_Desc Description FROM APC_VendCat WHERE APCVC_StkType = 'M'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("APC_VendCat",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Code = Result.Data("APCVC_Code")
		s Description = Result.Data("Description")
		d OutPutVendorCatRow
	}
	Quit $$$OK
OutPutVendorCatRow
	s Data=$lb(RowId,Code,Description)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存/更新供应商分类
/// Creater:	tsr
/// CreateDate: 2018-08-10
/// Table:		APC_VendCat
/// Input:		数据Json串:rowid,代码,描述,类型,医院ID
/// Return: 	RtnObj Json
ClassMethod Save(Params As %String, OtherParams = "") As %Library.String
{
	n (Params,OtherParams,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj1=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc1=PJObj1.%FromJSON(OtherParams)
	i Sc1'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	s gHospId=PJObj1.%Get("gHospId")
	s pHospId=PJObj1.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Description=Obj.%Get("Description")
		i (Code="")||(Description="") d RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,"APC_VendCat",pHospId,RowId)
		i (TmpId'="") d RtnObj.Err(-3,"",Description_"代码重复!","",0)
		q:RtnObj.success'=0
		s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"APC_VendCat",pHospId,RowId)
		i (TmpId'="") d RtnObj.Err(-4,"",Description_"名称重复!","",0)
		q:RtnObj.success'=0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Description)
		e  d
		.s RtnObj=..Insert(Code,Description)
		q:RtnObj.success'=0
		i RowId="" s RowId=RtnObj.rowid
		s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("APC_VendCat",RowId,pHospId)
		i +ret<0 d RtnObj.Err(-5,"",Description_"同步院区失败!")
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	增加供应商分类
/// Creater:	tsr
/// CreateDate: 2018-08-10
/// Table:		APC_VendCat
/// Input:		代码,描述
/// Return:		RtnObj
ClassMethod Insert(Code As %String, Description As %String) As RtnObj [ Private ]
{
	n (Code,Description,%session)
	s RtnObj=##class(RtnObj).%New()
	s Type=..sssCode()
	&sql(Insert into APC_VendCat
		(APCVC_Code, APCVC_Desc, APCVC_StkType)
		values
		(:Code,:Description,:Type))
	i SQLCODE'=0 d
	.d RtnObj.Err(-11,"","增加供应商分类失败:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("APC_VendCat","User.APCVendCat","供应商分类",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	s RtnObj.rowid=$p($g(%ROWID),$c(1))
	q RtnObj
}

/// Descript:	更新供应商分类
/// Creater:	tsr
/// CreateDate: 2018-08-10
/// Table:		APC_VendCat
/// Input:		RowId,代码,描述,类型
/// Return:		RtnObj
ClassMethod Update(RowId As %String, Code As %String, Description As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Description,%session)
	s RtnObj=##class(RtnObj).%New()
	s Type=..sssCode()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("APC_VendCat",RowId)
	&sql(UPDATE SQLUser.APC_VendCat
		SET APCVC_Code = :Code, APCVC_Desc = :Description, APCVC_StkType = :Type
		WHERE APCVC_RowId =:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-22,"","更新供应商分类失败:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_STOrigin","User.DHCSTOrigin","产地信息",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

}
