Import sqluser

/// Descript: 帐薄分类维护
/// Creater:	wxj
/// CreateDate:	2018-06-21
Class web.DHCSTMHUI.BookCat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存
/// Creater:	wxj
/// CreateDate:	2018-06-21
/// Table:		DHCST_BookCat
/// Input:		数据Json串:rowid,代码,描述
/// Return：	RtnObj Json 
ClassMethod Save(Params, Main As %String) As %Library.String
{
	n (Params,Main,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
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
		s Code=Obj.%Get("Code")
		s Description=Obj.%Get("Description")
		i (Code="")||(Description="") s Sc=RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		s type=..sssCode()
		
	 	s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,"DHCST_BookCat",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,"DHCST_BookCat",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Description_" 名称重复!","",0)
		continue:RtnObj.success<0
		
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Description)
		e  d
		.s RtnObj=..Insert(Code,Description,gHospId)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加
/// Creater:	wxj
/// CreateDate:	2018-06-21
/// Table:		DHCST_BookCat
/// Input:		代码,描述	
/// Return：	RtnObj
ClassMethod Insert(Code As %String, Description As %String, gHospId As %String) As RtnObj [ Private ]
{
	n (Code,Description,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	&sql(Insert into DHCST_BookCat
		(BC_Code,BC_Desc)
		values
		(:Code,:Description))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RowId=%ROWID
	.//保存医院关联
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHCST_BookCat",RowId,gHospId)
	.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	.s RtnObj=##class(Log).SaveLog("DHCST_BookCat","User.DHCSTBookCat","账簿分类信息",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新
/// Creater:	wxj
/// CreateDate:	2018-05-03
/// Table:		DHCST_BookCat
/// Input:		rowid^代码^描述
/// Return：	RtnObj 
ClassMethod Update(RowId As %String, Code As %String, Description As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Description,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHCST_BookCat",RowId)
	&sql(Update DHCST_BookCat set 
		BC_Code=:Code,BC_Desc=:Description
		where BC_RowId=:RowId)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHCST_BookCat","User.DHCSTBookCat","账簿分类信息",RowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除
/// Creater:	wxj
/// CreateDate:	2018-06-21
/// Table:		DHCST_BookCat
/// Input:		RowId	
/// Return：	RtnObj
ClassMethod Delete(Params) As %Library.String
{
	n (Params,%session)
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
		i (RowId="") s Sc=RtnObj.Err(-2,"","没有需要删除信息!","",0)
		q:RtnObj.success'=0
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHCST_BookCat",RowId)
		&sql(Delete from DHCST_BookCat where BC_RowId=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-3,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHCST_BookCat",RowId)
		.i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		.q:RtnObj.success'=0
		.s RtnObj=##class(Log).SaveLog("DHCST_BookCat","User.DHCSTBookCat","账簿分类信息",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Descript:	查询
/// Creater:	wxj
/// CreateDate:	2018-06-21
/// Table:		DHCST_BookCat
/// Input:		排序，查询条件
/// Return：	原因信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.BookCat","SelectAll","")
Query SelectAll(Params As %String) As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	
	s type=..sssCode()
	s SqlStr="SELECT BC_RowID as RowId,BC_Code as Code,BC_Desc as Description"  
		_" FROM DHCST_BookCat"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHCST_BookCat",RowId,gHospId)
		continue:ShowDataFlag="N"
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
