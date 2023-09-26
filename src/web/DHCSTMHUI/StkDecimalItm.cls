Import sqluser

/// Descript:小数规则明细维护
/// Creater:	wfg
/// CreateDate:	2018-09-28
Class web.DHCSTMHUI.StkDecimalItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新小数规则明细信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_StkDecimalItm
/// Input:数据串:rowid^父表id^规则下限^规则上限^小数位数,
/// rowid^父表id^规则下限^规则上限^小数位数
/// Output:		
/// Return："" – 成功，
/// 非空：失败
/// w ##class(web.DHCSTMHUI.StkDecimalItm).Save(2,[{""Min"":""0"",""Max"":""5"",""DecimalLen"":""3""}])
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
		s Min=RowObj.%Get("Min")
		s Max=RowObj.%Get("Max")
		s DecimalLen=RowObj.%Get("DecimalLen")
		s RtnObj=..CheckData(PRowId,RowId,Min,Max)
		q:RtnObj.success'=0
		s OpType=""
		s Chl=""
		s OldJsonStr=""
		i RowId="" d
		.s DHCStkDecimalItmObj=##class(User.DHCStkDecimalItm).%New()
		.s Chl=1+$o(^DHCSD(PRowId,"I",""),-1)
		.s OpType="A"
		e  d
		.s DHCStkDecimalItmObj=##Class(User.DHCStkDecimalItm).%OpenId(RowId)
		.s Chl=$p(RowId,"||",2)
		.s OpType="U"
		.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StkDecimalItm",RowId)
		s DHCStkDecimalItmObj.SDISDParref=##Class(User.DHCStkDecimal).%OpenId(PRowId)
		s DHCStkDecimalItmObj.SDIChildsub=Chl
		s DHCStkDecimalItmObj.SDIMin=Min
		s DHCStkDecimalItmObj.SDIMax=Max
		s DHCStkDecimalItmObj.SDIDecimalLen=DecimalLen
		s Sc=DHCStkDecimalItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,RowId,"保存失败!")
		continue:RtnObj.success<0
		s ID=DHCStkDecimalItmObj.%Id()	
		s RtnObj=##class(Log).SaveLog("DHC_StkDecimalItm","User.DHCStkDecimalItm","小数规则明细信息",ID,DecimalLen,OpType,"",OldJsonStr)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	删除小数规则明细信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_StkDecimalItm
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(RowId As %String) As %Library.String
{
	n (RowId,%session)
	;不能为空项
	s RtnObj=##class(RtnObj).%New()
	q:RowId="" RtnObj.Err(-10,RowId,"参数错误!").Json()
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StkDecimalItm",RowId)
	&sql(Delete from DHC_StkDecimalItm where SDI_Rowid=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-10,RowId,"删除失败!")
	e  d
	.d ##class(Log).SaveLog("DHC_StkDecimalItm","User.DHCStkDecimalItm","小数规则明细信息",RowId,"","D",JsonStr)
	q RtnObj.Json()
}

/// Descript:	查询小数规则明细信息
/// Creater:	wfg
/// CreateDate:	2018-09-28
/// Table:DHC_StkDecimalItm
/// Input:
/// Output:		
/// Return：小数规则明细信息
ClassMethod SelectAll(Parref As %String)
{
	n (Parref)
	q:Parref="" ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT SDI_Rowid as Rowid,SDI_Min,SDI_Max,SDI_DecimalLen"_  
	" FROM DHC_StkDecimalItm where SDI_SD_Parref="_Parref
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		CONTINUE:+Rowid=0
		s Min = result.Data("SDI_Min")
		s Max = result.Data("SDI_Max")
		s DecimalLen = result.Data("SDI_DecimalLen")
		s tmp=Rowid_"^"_Min_"^"_Max_"^"_DecimalLen
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	d json.getJsonData("RowId^Min:number^Max:number^DecimalLen:number",count)
	k json
	Q ""
}

/// Description:判断规则明细是否已存在
/// Creator:	tsr
/// CreatDate:	2019-08-23
/// Table:		DHC_StkDecimalItm
/// Input:		小数规则ID,规则明细ID,下限,上限
/// Return:		
ClassMethod CheckData(PRowId As %String, RowId As %String, Min As %String, Max As %String) As RtnObj
{
	n (PRowId,RowId,Min,Max)
	s RtnObj=##class(RtnObj).%New()
	s Ch=$p(RowId,"||",2)
	s sub=0
	f  s sub=$O(^DHCSD(PRowId,"I",sub)) q:(sub="")!(sub=0)!(RtnObj.success'=0)  d
	.q:(Ch'="")&&(sub=Ch)
	.s sData=^(sub)
	.s sMin=+$P(sData,"^",1)
	.s sMax=+$P(sData,"^",2)
	.i ((sMin<=Min)&&(Min<=sMax)) d RtnObj.Err(-1,RowId,"下限已存在于其他规则明细中!","",0)
	.q:RtnObj.success'=0
	.i ((sMin<=Max)&&(Max<=sMax)) d RtnObj.Err(-1,RowId,"上限已存在于其他规则明细中!","",0)
	.q:RtnObj.success'=0
	q RtnObj
}

}
