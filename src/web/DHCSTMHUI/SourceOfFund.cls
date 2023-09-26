Import sqluser

/// Descript:资金来源维护
/// Creater:    zhangxiao
/// CreateDate: 2015-9-9
Class web.DHCSTMHUI.SourceOfFund Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新资金来源维护
/// Creater:    zhangxiao
/// CreateDate: 2015-9-9
/// Table:DHC_SourceOfFund
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:     
/// Return："" : 成功，非空：失败
/// w ##class(web.DHCSTMHUI.SourceOfFund).Save("[{""Code"":""6"",""Description"":""SSS""}]")
ClassMethod Save(Params As %String, Main As %String) As %Library.String
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
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	s $ZT=..sssError()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Desc=Obj.%Get("Description")
		s TmpId=""
		&sql(select SOF_RowId into :TmpId from DHC_SourceOfFund where  SOF_Code=:Code)
		i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Desc,"DHC_SourceOfFund",gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Desc_" 名称重复!","",0)
		continue:RtnObj.success<0
		
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Desc)
		e  d
		.s RtnObj=..Insert(Code,Desc,gHospId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:   增加资金来源
/// Creater:    zhangxiao
/// CreateDate: 2015-9-9
/// Table:DHC_SourceOfFund
/// Input:代码,描述
/// Output:     
/// Return：rowid
/// w ##class(web.DHCSTMHUI.SourceOfFund).Insert(8,"CESHI")
ClassMethod Insert(Code As %String, Desc As %String, gHospId As %String) As RtnObj
{
	n (Code,Desc,gHospId,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	i (Code="")||(Desc="") q RtnObj.Err(-1,"","必填项不可为空","",0)
	&sql(Insert into DHC_SourceOfFund (SOF_Code,SOF_Desc) values (:Code,:Desc))
	i SQLCODE'=0 d
	.s JsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Code_"^"_Desc,"Code^Description")
	.d RtnObj.Err(-6,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg),JsonStr)
	q:RtnObj.success'=0 RtnObj
	s RowId=$p(%ROWID,$c(1))
	//保存医院关联
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_SourceOfFund",RowId,gHospId)
	i ret<0 q RtnObj.Err(-11,"","关联医院失败"_ret)
	s RtnObj=##class(Log).SaveLog("DHC_SourceOfFund","User.DHCSourceOfFund","资金来源信息",$SYSTEM.SQL.GetROWID(),Desc,"A")
	q:RtnObj.success'=0 RtnObj
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:   更新资金来源
/// Creater:    zhangxiao
/// CreateDate: 2015-9-9
/// Table:DHC_SourceOfFund
/// Input:代码,描述
/// Output:     
/// Return：rowid
ClassMethod Update(RowId As %String, Code As %String, Desc As %String) As RtnObj [ Private ]
{
	n (RowId,Code,Desc,%session)
	s RtnObj=##class(RtnObj).%New()
	i (Code="")||(Desc="")||(RowId="") d
	.s RtnObj.success=-1
	.s RtnObj.msg="必填项不可为空"
	q:RtnObj.success'=0 RtnObj
	
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_SourceOfFund",RowId)
	&sql(Update DHC_SourceOfFund set SOF_Code=:Code,SOF_Desc=:Desc where SOF_RowId=:RowId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-3,rowid,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg),OldJsonStr)
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_SourceOfFund","User.DHCSourceOfFund","资金来源信息",RowId,Desc,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

///  Descript:   删除资金来源
/// Creater:     zhangxiao
/// CreateDate: 2015-9-9
/// Table:DHC_SourceOfFund
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
	q:rowid="" ""
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_SourceOfFund",rowid)
	&sql(Delete from DHC_SourceOfFund where SOF_RowId=:rowid)
	q:SQLCODE'=0 SQLCODE
	d ##class(Log).SaveLog("DHC_SourceOfFund","User.DHCSourceOfFund","资金来源信息",rowid,"","D",JsonStr)
	q 0
}

/// Descript:	查询资金来源信息
/// Creater:	qiushengxin
/// CreateDate:	20180809
/// Table: DHC_SourceOfFund
/// Input:
/// Output:		
/// Return：资金来源信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.SourceOfFund","SelectAll","RowId","Desc")
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
	d Result.RuntimeModeSet(0)
	s SqlStr = "select SOF_RowId as RowId, SOF_Code as Code,SOF_Desc as Description from DHC_SourceOfFund "
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		CONTINUE:+RowId=0
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_SourceOfFund",RowId,gHospId)
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
