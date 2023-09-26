Class CHSSWeb.HISInterface.WomenBaseInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-05-30
/// Description:妇女档案列表
ClassMethod WomenBaseInfoList(personRowId As %String, start As %String, limit As %String) As %String
{
	
	s personRowId = $g(personRowId)
	s start=$g(start)
	s limit=$g(limit)	
	s count=0
	s resultString = ""
	s end = start+limit	
	s result = ""
	s reportData = ""
	s returnData = ""         
    s womanRowId = 0
    q:personRowId="" ""   
    ; 开始读取数据 
    f  s womanRowId=$o(^CHSS.WomenBaseInfoI("PersonRowIdParrefIndex",personRowId,womanRowId)) q:womanRowId=""  d    
    .s tempWomenBaseInfo=##class(CHSS.WomenBaseInfo).%OpenId(womanRowId)
    .q:tempWomenBaseInfo.FinishIdentifier="true"
    .s count=count+1
    .s reportData = ##class(CHSSWeb.HISInterface.WomenBaseInfo).%New()
    .; 妇女基本信息
    .s reportData.PersonRowIdParref = personRowId
    .s reportData.WomanRowId = womanRowId
    .s reportData.PersonName = tempWomenBaseInfo.PersonName
    .s reportData.SpellCode = tempWomenBaseInfo.SpellCode
    .s reportData.WoAge = tempWomenBaseInfo.WoAge
    .s reportData.Birth = tempWomenBaseInfo.Birth
    .i reportData.Birth '= "" d
    ..s reportData.Birth = $zd(reportData.Birth,3)
    .s reportData.WomanHandBookCode = tempWomenBaseInfo.WomanHandBookCode
    .s reportData.WorkUnit = tempWomenBaseInfo.WorkUnit
    .s reportData.TelPhone = tempWomenBaseInfo.TelPhone
    .s reportData.CellPhone = tempWomenBaseInfo.CellPhone
    .s reportData.Email = tempWomenBaseInfo.Email
    .s reportData.ResidenceAddress = tempWomenBaseInfo.ResidenceAddress
    .s reportData.AfMaAddress = tempWomenBaseInfo.AfMaAddress
    .s reportData.AftBeAddress = tempWomenBaseInfo.AftBeAddress
    .s reportData.bDose = tempWomenBaseInfo.bDose
    .s reportData.IdCard = tempWomenBaseInfo.IdCard
    .s reportData.Card = tempWomenBaseInfo.Card
    .s reportData.CardType = tempWomenBaseInfo.CardType
    .s reportData.InHosCode = tempWomenBaseInfo.InHosCode    
    .; 丈夫基本信息     
    .s reportData.HusbandName = tempWomenBaseInfo.HusbandName
    .s reportData.HusbandBirth = tempWomenBaseInfo.HusbandBirth
    .i reportData.HusbandBirth '= "" d
    ..s reportData.HusbandBirth = $zd(reportData.HusbandBirth ,3)
    .s reportData.HusbandWorkUnit = tempWomenBaseInfo.HusbandWorkUnit
    .s reportData.HusbandTele = tempWomenBaseInfo.HusbandTele
    .s reportData.HusbandMobTele = tempWomenBaseInfo.HusbandMobTele
    .s reportData.HusbandEmail = tempWomenBaseInfo.HusbandEmail
    .; 建册报告
    .s reportData.EBPeriodName = ""
    .s reportData.EBPeriod = ""
    .i tempWomenBaseInfo.EBPeriod '= "" d
    ..s reportData.EBPeriod = tempWomenBaseInfo.EBPeriod.%Id()
    ..s reportData.EBPeriodName = tempWomenBaseInfo.EBPeriod.Description
    .s reportData.EBPeriodDes = tempWomenBaseInfo.EBPeriodDes
    .s reportData.EBTime = tempWomenBaseInfo.EBTime
    .i reportData.EBTime '= "" d
    ..s reportData.EBTime = $zd(reportData.EBTime ,3)
    .s reportData.EBunit = tempWomenBaseInfo.EBunit
    .s reportData.EBbefore = tempWomenBaseInfo.EBbefore
    .s reportData.EBnum = tempWomenBaseInfo.EBnum
    .s reportData.EBfrontCode = tempWomenBaseInfo.EBfrontCode
    .; 本次填表情况    
    .s reportData.FinishTable = tempWomenBaseInfo.FinishTable    
    .s reportData.OperatorName = ""
    .s reportData.Operator = ""
    .i tempWomenBaseInfo.Operator '= "" d
    ..s reportData.Operator = tempWomenBaseInfo.Operator.%Id()
    ..s reportData.OperatorName = tempWomenBaseInfo.Operator.SSUSRName
    .s reportData.OperateDate = tempWomenBaseInfo.OperateDate
    .i reportData.OperateDate '= "" d
    ..s reportData.OperateDate = $zd(reportData.OperateDate ,3)
    .s reportData.FinishIdentifier = tempWomenBaseInfo.FinishIdentifier    
    .; 处理数据
    .i (count>start)&(count<=end) d
    ..s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.WomenBaseInfo") 	
	..s countProperties = cdef.Properties.Count()
	..s returnData = "<Women>"
	..f i = 1:1:countProperties d
    ...s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	..s returnData = returnData_"</Women>"
 	..i resultString = "" d
 	...s resultString = returnData
 	..e  d
 	...s resultString = resultString_returnData
 	i count '= 0 d
	.s result="<Womens count='"_count_"'>"_resultString_"</Womens>"
	q result
}

Storage Default
{
<Data name="WomenBaseInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenBaseInf7DED</DataLocation>
<DefaultData>WomenBaseInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenBaseInf7DED</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenBaseInf7DEI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenBaseInf7DES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
