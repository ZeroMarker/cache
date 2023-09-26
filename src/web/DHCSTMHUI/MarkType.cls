Import sqluser

/// Descript:定价类型维护
/// Creater:	wfg
/// CreateDate:	2018-9-28
Class web.DHCSTMHUI.MarkType Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_MarkType";

/// Descript:	保存/更新定价类型信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_MarkType
/// Input:数据串:rowid^代码^描述^是否中标^是否使用,rowid^代码^描述^是否中标^是否使用
/// Output:		
/// Return："" – 成功，
/// 非空：失败
/// w ##class(web.DHCSTMHUI.MarkType).Save("^jkk^ui^^")
ClassMethod Save(Params As %String, Main As %String) As %Library.String
{
	n (Params,Main,%session)
	
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	s StkType=..sssCode()
	s AppName="DHCSTCOMMONM"
	s Version=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"Version","")
	ts
	While(RtnObj.success=0){
		s RowObj=PJObj.%Pop()
		q:RowObj=""
		s RowId=RowObj.%Get("RowId")
		s Code=RowObj.%Get("Code")
		s Desc=RowObj.%Get("Desc")
		s ZbFlag=RowObj.%Get("ZbFlag")
		s UseFlag=RowObj.%Get("UseFlag")
		i ($$ALPHAUP^SSUTIL4(Code)="")||($$ALPHAUP^SSUTIL4(Desc)="") d RtnObj.Err(-2,RowId,"代码或名称不可为空!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,..#AppTable,gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Desc_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Desc,..#AppTable,gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Desc_" 名称重复!","",0)
		continue:RtnObj.success<0
		s OpType="",OldJsonStr=""
		i RowId="" d
		.s DHCMarkTypeObj=##class(User.DHCMarkType).%New()
		.s OpType="A"
		e  d
		.s DHCMarkTypeObj=##Class(User.DHCMarkType).%OpenId(RowId)
		.s OpType="U"
		.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MarkType",RowId)
		s DHCMarkTypeObj.MTCode=Code
		s DHCMarkTypeObj.MTDesc=Desc
		s DHCMarkTypeObj.MTZbFlag=ZbFlag
		s DHCMarkTypeObj.MTUseFlag=UseFlag
		s DHCMarkTypeObj.MTType=StkType
		s Sc=DHCMarkTypeObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,RowId,"保存失败!")
		continue:RtnObj.success<0
		s RowId=DHCMarkTypeObj.%Id()
		//保存医院关联
		s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP(..#AppTable,RowId,gHospId)
		i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		continue:RtnObj.success<0
		s RtnObj=##class(Log).SaveLog("DHC_MarkType","User.DHCMarkType","定价类型信息",RowId,Code,OpType,"",OldJsonStr)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	删除定价类型信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_MarkType
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
	;
	;不能为空项
	q:rowid="" ""
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MarkType",rowid)
	s Err=0
	&sql(Delete from DHC_MarkType where MT_Rowid=:rowid)
	i SQLCODE'=0  d
	.s Err=-1
	e  d
	.d ##class(Log).SaveLog("DHC_MarkType","User.DHCMarkType","定价类型信息",rowid,"","D",JsonStr)
	q Err
}

/// Descript:	查询定价类型信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_MarkType
/// Input:
/// Output:		
/// Return：定价类型信息
ClassMethod SelectAll(Params As %String)
{
	n (Params,%session)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Params)'=0 $$$OK
	
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Type=..sssCode()
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MT_Rowid as Rowid,MT_Code,MT_Desc,MT_ZbFlag,MT_UseFlag"_
	" FROM DHC_MarkType where MT_Type='"_Type_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		CONTINUE:+Rowid=0
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(..#AppTable,Rowid,gHospId)
		continue:ShowDataFlag="N"
		s Code = result.Data("MT_Code")
		s Desc = result.Data("MT_Desc")
		s ZbFlag = result.Data("MT_ZbFlag")
		s UseFlag = result.Data("MT_UseFlag")
		s tmp=Rowid_"^"_Code_"^"_Desc_"^"_ZbFlag_"^"_UseFlag
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	d json.getJsonData("RowId^Code^Desc^ZbFlag^UseFlag",count)
	k json
	Q ""
}

}
