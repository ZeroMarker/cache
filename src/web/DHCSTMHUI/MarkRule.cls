Import sqluser

/// Descript:定价规则维护
/// Creater:	wfg
/// CreateDate:	2018-09-28
Class web.DHCSTMHUI.MarkRule Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_MarkRule";

/// Descript:	保存/更新定价规则信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_MarkRule
/// Input:数据串:rowid^代码^描述^规则上限^规则下限^加成率^定价类型^备注^是否使用^最高加成额
/// ^最高加成率^加成额^小数规则,rowid^代码^描述^规则上限^规则下限^加成率^定价类型^备注
/// ^是否使用^最高加成额^最高加成率^加成额^小数规则
/// Output:		
/// Return："" – 成功，
/// 非空：失败
/// w ##class(web.DHCSTMHUI.MarkRule).Save("","")
ClassMethod Save(Params As %String, Main As %String) As %Library.String
{
	n (Params,Main,%session)
	
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1111,"","入参解析失败!").Json()
	
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
		s MinRp=RowObj.%Get("MinRp")
		s MaxRp=RowObj.%Get("MaxRp")
		s Margin=RowObj.%Get("Margin")
		s MPrice=RowObj.%Get("MPrice")
		s MaxMargin=RowObj.%Get("MaxMargin")
		s MaxMPrice=RowObj.%Get("MaxMPrice")
		s MtDr=RowObj.%Get("MtDr")
		s SdDr=RowObj.%Get("SdDr")
		s UseFlag=RowObj.%Get("UseFlag")
		s Remark=RowObj.%Get("Remark")
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
		.s DHCMarkRuleObj=##class(User.DHCMarkRule).%New()
		.s OpType="A"
		e  d
		.s DHCMarkRuleObj=##Class(User.DHCMarkRule).%OpenId(RowId)
		.s OpType="U"
		.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MarkRule",RowId)
		s DHCMarkRuleObj.MRCode=Code
		s DHCMarkRuleObj.MRDesc=Desc
		s DHCMarkRuleObj.MRMargin=Margin
		s DHCMarkRuleObj.MRMaxMargin=MaxMargin
		s DHCMarkRuleObj.MRMaxMPrice=MaxMPrice
		s DHCMarkRuleObj.MRMaxRp=MaxRp
		s DHCMarkRuleObj.MRMinRp=MinRp
		s DHCMarkRuleObj.MRMPrice=MPrice
		s DHCMarkRuleObj.MRRemark=Remark
		s DHCMarkRuleObj.MRType=StkType
		s DHCMarkRuleObj.MRUseFlag=UseFlag
		s DHCMarkRuleObj.MRMTDr=##Class(User.DHCMarkType).%OpenId(MtDr)
		s DHCMarkRuleObj.MRSDDr=##Class(User.DHCStkDecimal).%OpenId(SdDr)
		s Sc=DHCMarkRuleObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,RowId,"保存失败!")
		continue:RtnObj.success<0
		s RowId=DHCMarkRuleObj.%Id()
		//保存医院关联
		s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP(..#AppTable,RowId,gHospId)
		i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
		continue:RtnObj.success<0
		s RtnObj=##class(Log).SaveLog("DHC_MarkRule","User.DHCMarkRule","定价规则信息",RowId,Desc,OpType,"",OldJsonStr)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	删除定价规则信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_MarkRule
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
	
	q:rowid="" ""
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MarkRule",rowid)
	s Err=0
	&sql(Delete from DHC_MarkRule where MR_Rowid=:rowid)
	i SQLCODE'=0  d
	.s Err=-1
	e  d
	.d ##class(Log).SaveLog("DHC_MarkRule","User.DHCMarkRule","定价规则信息",rowid,"","D",JsonStr)
	q Err
}

/// Descript:	查询定价规则信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_MarkRule
/// Input:
/// Output:	RowId^代码^描述^规则下限^规则上限^加成率^定价类型id^定价类型描述
/// ^备注^是否使用^最大加成额^加成额^最大加成率^小数规则id^小数规则描述	
/// Return：定价规则信息
ClassMethod SelectAll(Params As %String)
{
	n (Params,%session)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Params)'=0 $$$OK
	
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s result = ##class(%Library.ResultSet).%New()
	s type=..sssCode()
	s sqlStr = "SELECT MR_Rowid as Rowid,MR_Code,MR_Desc,MR_MinRp,MR_MaxRp,"_  
	"MR_Margin,MR_MT_Dr,MR_Remark,MR_UseFlag,MR_MaxMPrice,MR_MPrice,MR_MaxMargin,"_
	"MR_SD_Dr FROM DHC_MarkRule where MR_Type='"_type_"'"
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
		s Code = result.Data("MR_Code")
		s Desc = result.Data("MR_Desc")
		s MinRp = result.Data("MR_MinRp")
		s MaxRp = result.Data("MR_MaxRp")
		s Margin = result.Data("MR_Margin")
		s MtDr = +result.Data("MR_MT_Dr")				//定价类型
		s MtDesc=""
		s:MtDr'=0 MtDesc=$p(^DHCINMT(MtDr),"^",2)		//定价类型描述
		s Remark = result.Data("MR_Remark")
		s UseFlag = result.Data("MR_UseFlag")
		s MaxMPrice = result.Data("MR_MaxMPrice")
		s MPrice = result.Data("MR_MPrice")
		s MaxMargin = result.Data("MR_MaxMargin")
		s SdDr = +result.Data("MR_SD_Dr")     			//小数规则
		s SdDesc=""
		s:SdDr'=0 SdDesc=$p(^DHCSD(SdDr),"^",2)		//小数规则描述
		;
		s Data1=Rowid_"^"_Code_"^"_Desc_"^"_MinRp_"^"_MaxRp_"^"_Margin_"^"_MtDr_"^"_MtDesc
		s Data2=Remark_"^"_UseFlag_"^"_MaxMPrice_"^"_MPrice_"^"_MaxMargin_"^"_SdDr_"^"_SdDesc
		s tmp=Data1_"^"_Data2
		s count = count+1	
		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	d json.getJsonData("RowId^Code^Desc^MinRp:number^MaxRp:number^Margin:number^MtDr^MtDesc^Remark^UseFlag^MaxMPrice:number^MPrice:number^MaxMargin:number^SdDr^SdDesc",count)
	k json
	
	Q ""
}

}
