Class CHSSWeb.HISInterface.WomenDangerScoreInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-06-07
/// Description:高危评分记录
ClassMethod WomenDangerScoreList(womanRowId As %String, start As %String, limit As %String) As %String
{
	s womanRowId = $g(womanRowId)
	s start = $g(start)
	s limit = $g(limit)
	s count = 0
	s reportData = ""
	s returnData = ""
	s resultString = ""
	s end = start + limit
	s sqlStr = "select DangerRowId from CHSS.WomenDangerRecord where WomanRowId = "_womanRowId
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	while(result.Next())
	{		
		s DangerRowId = result.Data("DangerRowId")
		s tempDangerScore = ##class(CHSS.WomenDangerRecord).%OpenId(DangerRowId)
		s reportData = ##class(CHSSWeb.HISInterface.WomenDangerScoreInfo).%New()
		if ($IsObject(tempDangerScore))
		{
			s count = count+1
			s reportData.DangerRowId = DangerRowId
			s reportData.CheckDate = ""
			i tempDangerScore.CheckDate '= "" d
			.s reportData.CheckDate = $zd(tempDangerScore.CheckDate,3)
			s reportData.CheckDoctor = tempDangerScore.CheckDoctor
			s reportData.PregWeeks = tempDangerScore.PregWeeks
			s reportData.Grade = tempDangerScore.Grade
			s reportData.Deal = tempDangerScore.Deal
			s reportData.BookingDate = ""
			i tempDangerScore.BookingDate '= "" d
			.s reportData.BookingDate = $zd(tempDangerScore.BookingDate,3)
			
			i (count>start)&(count<=end) d
			.s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.WomenDangerScoreInfo")
			.s countPro = cdef.Properties.Count()
			.s returnData = "<Danger>"
			.f i=1:1:countPro d
			..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
			.s returnData = returnData_"</Danger>"
			.i resultString = "" d
 			..s resultString = returnData
 			.e  d
 			..s resultString = resultString_returnData
		}
	}
	i count '= 0 d
	.s resultString="<Womens count='"_count_"'>"_resultString_"</Womens>"
	q resultString
}

/// Creator:jinming
/// Date:2011-6-7
/// Description:获取高危因素字段
ClassMethod DangerFactor(DangerRowId As %String) As %String
{
	s DangerRowId = $g(DangerRowId)
	s sqlstr = "select ItemVsDetailRowId from CHSS.WomenDangerFactor where DangerRowId="_DangerRowId
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlstr)
	d result.Execute()
	s temp = ""
	s startStr = ""
	s resultString = ""
	while(result.Next())
	{
		s ItemVsDetailRowId = result.Data("ItemVsDetailRowId")
		s tempItemVsDetail = ##class(CHSS.DictDangerItemVsDetail).%OpenId(ItemVsDetailRowId)
		i $IsObject(tempItemVsDetail) d
		.s ItemType = tempItemVsDetail.ItemType
		.s RowIdDetail = tempItemVsDetail.RowIdDetail
		.s DetailDes = tempItemVsDetail.RowIdDetail.Description
		.s RowIdMain = tempItemVsDetail.RowIdMain
		.s MainDes = tempItemVsDetail.RowIdMain.Description
		.s temp = temp_startStr_"名称:"_MainDes_"，类别:"_ItemType_"级，明细:"_DetailDes
		.s startStr = "<br/>"
	}
	s resultString = "<WomenDanger><Info><![CDATA["_temp_"]]></Info></WomenDanger>"
	q resultString
}

Storage Default
{
<Data name="WomenDangerScoreInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenDangerSAB0D</DataLocation>
<DefaultData>WomenDangerScoreInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenDangerSAB0D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenDangerSAB0I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenDangerSAB0S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
