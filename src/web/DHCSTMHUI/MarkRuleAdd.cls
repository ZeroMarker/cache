Import sqluser

/// Descript:规则累计进差率维护
/// Creater:	WFG
/// CreateDate:	2018-09-28
Class web.DHCSTMHUI.MarkRuleAdd Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新规则信息
/// Creater:	WFG
/// CreateDate:	2018-09-28
/// Table:DHC_MarkRuleAdd
/// Input:数据串:rowid^父表id^代码^描述^上限^下限^加成^备注^是否使用,
/// rowid^父表id^代码^描述^上限^下限^加成^备注^是否使用
/// Output:		
/// Return："" – 成功，
/// 非空：失败
ClassMethod Save(PRowId As %String, Params As %String) As %Library.String
{
	n (PRowId,Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PRowId="" RtnObj.Err(-1,"","入参错误!").Json()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!").Json()
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
		s UseFlag=RowObj.%Get("UseFlag")
		s Remark=RowObj.%Get("Remark")
		s OpType="",OldJsonStr=""
		s Chl=""
		i RowId="" d
		.s RuleAddObj=##class(User.DHCMarkRuleAdd).%New()
		.s Chl=1+$o(^DHCINMRA(PRowId,"I",""),-1)
		.s OpType="A"
		e  d
		.s RuleAddObj=##Class(User.DHCMarkRuleAdd).%OpenId(RowId)
		.s Chl=$o(^DHCINMRA(PRowId,"I",""),-1)
		.s OpType="U"
		.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MarkRuleAdd",RowId)
		s RuleAddObj.MRACode=Code
		s RuleAddObj.MRADesc=Desc
		s RuleAddObj.MRAMargin=Margin
		s RuleAddObj.MRAMaxRp=MaxRp
		s RuleAddObj.MRAMinRp=MinRp
		s RuleAddObj.MRARemark=Remark
		s RuleAddObj.MRAUseFlag=UseFlag
		s RuleAddObj.MRAMRParref=##Class(User.DHCMarkRule).%OpenId(PRowId)
		s RuleAddObj.MRAChildSub=Chl
		s Sc=RuleAddObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,RowId,"保存失败!")
		continue:RtnObj.success<0
		s RowId=RuleAddObj.%Id()
		s RtnObj=##class(Log).SaveLog("DHC_MarkRuleAdd","User.DHCMarkRuleAdd","定价规则明细信息",RowId,Desc,OpType,"",OldJsonStr)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	删除累计规则信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_MarkRuleAdd
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(RowId As %String) As %Library.String
{
	n (RowId,%session)
	;不能为空项
	s RtnObj=##class(RtnObj).%New()
	q:RowId="" RtnObj.Err(-10,RowId,"参数错误!").Json()
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MarkRuleAdd",RowId)
	&sql(Delete from DHC_MarkRuleAdd where MRA_Rowid=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-10,RowId,"删除失败!")
	e  d
	.d ##class(Log).SaveLog("DHC_MarkRuleAdd","User.DHCMarkRuleAdd","定价规则明细信息",RowId,"","D",JsonStr)
	q RtnObj.Json()
}

/// Descript:	查询某规则的累计规则信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_MarkRuleAdd
/// Input:父表id
/// Output:	
/// Return：RowId^代码^描述^下限^上限^加成^备注^是否使用
ClassMethod SelectAll(Parref As %String)
{
	n (Parref)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MRA_RowID as Rowid,MRA_Code,MRA_Desc,MRA_MinRp,MRA_MaxRp,"_  
	"MRA_Margin,MRA_Remark,MRA_UseFlag"_
	" FROM DHC_MarkRuleAdd where MRA_MR_Parref="_Parref
	d result.Prepare(sqlStr)
	d result.Execute()
	;
	s count = 0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		CONTINUE:+Rowid=0
		s Code = result.Data("MRA_Code")
		s Desc = result.Data("MRA_Desc")
		s MinRp = result.Data("MRA_MinRp")
		s MaxRp = result.Data("MRA_MaxRp")
		s Margin = result.Data("MRA_Margin")
		s Remark = result.Data("MRA_Remark")
		s UseFlag = result.Data("MRA_UseFlag")
	
		s tmp=Rowid_"^"_Code_"^"_Desc_"^"_MinRp_"^"_MaxRp_"^"_Margin_"^"_Remark_"^"_UseFlag
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	d json.getJsonData("RowId^Code^Desc^MinRp:number^MaxRp:number^Margin:number^Remark^UseFlag",count)
	k json
	Q ""
}

}
