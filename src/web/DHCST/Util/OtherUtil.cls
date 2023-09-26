/// Descript:除药品、科室、医院等其他Store的取法
/// 在dhcst.otherutil.csp中调用
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-05
Class web.DHCST.Util.OtherUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-10-23
/// description: 取得出入库的操作类别
/// input:  type(入库出库类型：I,O)
/// output: String "RowId^Description"
/// others:
ClassMethod GetOperateType(type, hosp = "")
{
 n (type,hosp)
 s i=0 
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s id=0
 f  s id=$o(^DHCOPTYPE(0,"TYPE",type,id)) q:+id'>0  d
 .q:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_OperateType",id,hosp)="N"
 .s code=$p(^DHCOPTYPE(id),"^",1)
 .s desc=$p(^DHCOPTYPE(id),"^",2)
 .s defaultflag=$p(^DHCOPTYPE(id),"^",4)
 .s i=i+1
 .s tmp=id_"^"_desc_"^"_defaultflag
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description^Default",i)
 k json
 q resultString
}

/// creator:zhangyong
/// date:2011-12-9
/// description: 退货原因ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetReasonForReturn(Start, Limit, Type = "G", Hosp = "")
{
	n (Start, Limit, Type, Hosp)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select RET_Rowid AS RowId, RET_Desc AS Description, RET_StkType AS StkType from INC_ReasonForReturn ORDER BY RET_Rowid"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s StkType = result.Data("StkType")
		continue:(StkType'="")&(StkType'=Type)
		s Rowid = result.Data("RowId")
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_ReasonForReturn",Rowid,Hosp)="N"
		s Description = result.Data("Description")
		s tmp=Rowid_"^"_Description
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	Q resultString
}

/// creator:zhangdongmei
/// date:2012-02-07
/// description: 调价原因ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "Description"
/// others:
ClassMethod GetReasonForAdjSp(Start, Limit, Type As %String = "G", Hosp = "")
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select REA_RowId AS RowId, REA_Desc AS Description, REA_StkType AS StkType from DHC_ReasonForAdjustPrice"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s StkType=result.Data("StkType")
		continue:(StkType'="")&(StkType'=Type)
		s Rowid = result.Data("RowId")
		s Description = result.Data("Description")
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_ReasonForAdjustPrice",Rowid,Hosp)="N"
		s tmp=Rowid_"^"_Description
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	Q resultString
}

/// creator:zhangyong
/// date:2011-12-20
/// description: 调整原因ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GeReasonForAdjustment(Type As %String = "G", Hosp = "")
{
	n (Type,Hosp)
 	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ADJ_RowId as RowId, ADJ_Desc as Description,ADJ_StkType as StkType FROM INC_ReasonForAdjustment order by ADJ_RowId"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s Rowid = result.Data("RowId")
		s Description = result.Data("Description")
		s StkType = result.Data("StkType")
		continue:(StkType'="")&(StkType'=Type)
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_ReasonForAdjustment",Rowid,Hosp)="N"
		s tmp=Rowid_"^"_Description
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	Q resultString
}

/// creator:liangqiang
/// date:2013-12-26
/// description: 报损原因ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetReasonForScrap(Start, Limit, Type = "", Hosp = "")
{
	n (Start, Limit, Type,Hosp)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select REASON_ScrapRowID AS RowId, REASON_ScrapDesc AS Description,REASON_ScrapType As SType  from DHC_IncReasonForStockScrap ORDER BY REASON_ScrapRowID"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s Rowid = result.Data("RowId")
		s Description = result.Data("Description")
		s SType= result.Data("SType")
		continue:(SType'=Type)&(SType'="")
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_IncReasonForStockScrap",Rowid,Hosp)="N"
		s tmp=Rowid_"^"_Description
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	Q resultString
}

}
