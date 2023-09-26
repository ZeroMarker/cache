Class CHSSWeb.HISInterface.WomenBirthRecordInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-06-02
/// Description:孕妇分娩情况
ClassMethod WomenBirthRecordInfo(WomanRowId As %String) As %String
{
	
	s WomanRowId=$g(WomanRowId)
    s count=0
    s resultString = ""
    s reportData = ""
    s returnData = ""
    s BirthRowId = 0
    f  s BirthRowId=$o(^CHSS.WhBirthRecordI("WomanRowIdIndex",WomanRowId,BirthRowId)) q:BirthRowId=""  d
    .s tempWhBirthRecord=##class(CHSS.WhBirthRecord).%OpenId(BirthRowId)
    .s reportData = ##class(CHSSWeb.HISInterface.WomenBirthRecordInfo).%New()
    .; 检查信息
    .s reportData.WomanRowId = WomanRowId
    .s reportData.DateOfBirth = tempWhBirthRecord.DateOfBirth
    .i reportData.DateOfBirth '= "" d
    ..s reportData.DateOfBirth = $zd(reportData.DateOfBirth,3)
    .s reportData.BirthGW = tempWhBirthRecord.BirthGW
    .s reportData.BirthPlace = tempWhBirthRecord.BirthPlace
    .s reportData.BirthTypeName = ""
    .s reportData.BirthType = ""
    .i tempWhBirthRecord.BirthType '= "" d
    ..s reportData.BirthType = tempWhBirthRecord.BirthType.%Id()
    ..s reportData.BirthTypeName = tempWhBirthRecord.BirthType.Description
    .s reportData.BirthComp = tempWhBirthRecord.BirthComp
    .s reportData.BirthParity = tempWhBirthRecord.BirthParity      
    .s reportData.TotalStage = tempWhBirthRecord.TotalStage
    .s reportData.CaesareanReason = tempWhBirthRecord.CaesareanReason
    .s reportData.PlacentaFallModeName = ""
    .s reportData.PlacentaFallMode = ""
    .i tempWhBirthRecord.PlacentaFallMode '= "" d
    ..s reportData.PlacentaFallMode = tempWhBirthRecord.PlacentaFallMode.%Id()
    ..s reportData.PlacentaFallModeName = tempWhBirthRecord.PlacentaFallMode.Description
    .s reportData.DystociaName = ""
    .s reportData.Dystocia = ""
    .i tempWhBirthRecord.Dystocia '= "" d
    ..s reportData.Dystocia = tempWhBirthRecord.Dystocia.%Id()
    ..s reportData.DystociaName = tempWhBirthRecord.Dystocia.Description      
    .s reportData.ODFDName = ""
    .s reportData.ODFD = ""
    .i tempWhBirthRecord.ODFD '= "" d
    ..s reportData.ODFD = tempWhBirthRecord.ODFD.%Id()
    ..s reportData.ODFDName = tempWhBirthRecord.ODFD.Description      
    .s reportData.SplitTypeName = ""
    .s reportData.SplitType = ""
    .i tempWhBirthRecord.SplitType '= "" d
    ..s reportData.SplitType = tempWhBirthRecord.SplitType.%Id()
    ..s reportData.SplitTypeName = tempWhBirthRecord.SplitType.Description
    .s reportData.OuterFissureNum = tempWhBirthRecord.OuterFissureNum
    .s tempComplication = tempWhBirthRecord.Complication
    .s reportData.Complication = ##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempComplication,"DictWomenComplication")
    .s reportData.OtherComplication = tempWhBirthRecord.OtherComplication
    .s reportData.BleedNum = tempWhBirthRecord.BleedNum     
    .s reportData.BleedReasonName = ""
    .s reportData.BleedReason = ""
    .i tempWhBirthRecord.BleedReason '= "" d
    ..s reportData.BleedReason = tempWhBirthRecord.BleedReason.%Id()
    ..s reportData.BleedReasonName = tempWhBirthRecord.BleedReason.Description           
    .s reportData.BleedReasonDes = tempWhBirthRecord.BleedReasonDes
    .s reportData.FetusNum = tempWhBirthRecord.FetusNum      
    .s reportData.LeaveDate = tempWhBirthRecord.LeaveDate
    .i reportData.LeaveDate '= "" d
    ..s reportData.LeaveDate = $zd(reportData.LeaveDate,3)      
    .s reportData.Suggestion = tempWhBirthRecord.Suggestion
    .; 处理数据
    .s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.WomenBirthRecordInfo") 	
	.s count = cdef.Properties.Count()
	.s returnData = "<BirthRecord>"
	.f i = 1:1:count d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</BirthRecord>"
	q returnData
}

/// Creator:jinming
/// CreateDate:2011-06-02
/// Description:孕妇分娩情况，获取“新生儿情况”字段
ClassMethod WhNewBorn(WomanRowId As %String) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT NewBornRowId, BirthWeight, Sex, Name, BirthSort FROM CHSS.WhNewBorn where WomanRowId ="_WomanRowId	
	d result.Prepare(sqlStr)
	d result.Execute()		
	Set resultString = ""	
	set tmp = ""
	set startStr = ""	
	While(result.Next())
	{
    s NewBornRowId = result.Data("NewBornRowId")
    s BirthWeight = result.Data("BirthWeight")
    s Sex = result.Data("Sex")
    s Name = result.Data("Name")
    s BirthSort = result.Data("BirthSort")
	Set tmp = tmp_startStr_"姓名: "_Name_", 体重: "_BirthWeight_"g, 性别: "_Sex
	s startStr = "<br/>"	
	}
	s resultString = "<WhNewBorn><Info><![CDATA["_tmp_"]]></Info></WhNewBorn>"
	q resultString
}

Storage Default
{
<Data name="WomenBirthRecordInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenBirthReABBD</DataLocation>
<DefaultData>WomenBirthRecordInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenBirthReABBD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenBirthReABBI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenBirthReABBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
