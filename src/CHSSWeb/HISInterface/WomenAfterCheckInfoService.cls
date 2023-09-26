Class CHSSWeb.HISInterface.WomenAfterCheckInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-06-03
/// Description:产后访视记录表
ClassMethod WomenAfterCheckList(womanRowId As %String, start As %String, limit As %String) As %String
{
	Set womanRowId=$G(womanRowId)
    Set start=$G(start)
    Set limit=$G(limit)
    Set count=0
    Set resultString = ""
    Set end = start+limit    
    s reportData = ""
    s result = ""
    s returnData = ""
    set visitRowId = 0
    For  Set visitRowId=$O(^CHSS.WhAfterBirthVisitRecordI("WomanRowIdIndex",womanRowId,visitRowId)) q:visitRowId=""  d
    .s count=count+1
    .s tempWhAfterBirthVisitRecord=##class(CHSS.WhAfterBirthVisitRecord).%OpenId(visitRowId)
    .s reportData = ##class(CHSSWeb.HISInterface.WomenAfterCheckInfo).%New()
    .; 检查信息
    .s reportData.VisitRowId = visitRowId
    .s reportData.CheckDate = tempWhAfterBirthVisitRecord.CheckDate
    .i reportData.CheckDate '= "" d
    ..s reportData.CheckDate = $zd(reportData.CheckDate,3)
    .s reportData.CheckUnit = tempWhAfterBirthVisitRecord.CheckUnit      
    .s reportData.Checker = tempWhAfterBirthVisitRecord.Checker
    .; 健康检查
    .s reportData.GeneralCheck = tempWhAfterBirthVisitRecord.GeneralCheck
    .s reportData.HighPressure = tempWhAfterBirthVisitRecord.HighPressure
    .s reportData.LowPressure = tempWhAfterBirthVisitRecord.LowPressure
    .s reportData.Weight = tempWhAfterBirthVisitRecord.Weight
    .s reportData.Brest = tempWhAfterBirthVisitRecord.Brest
    .s reportData.Uterus = tempWhAfterBirthVisitRecord.Uterus
    .s reportData.Lochia = tempWhAfterBirthVisitRecord.Lochia
    .s reportData.Wound = tempWhAfterBirthVisitRecord.Wound
    .s reportData.OtherCheck = tempWhAfterBirthVisitRecord.OtherCheck
    .; 保健指导
    .s reportData.GeneralGuid = tempWhAfterBirthVisitRecord.GeneralGuid
    .s reportData.PsychologyGuid = tempWhAfterBirthVisitRecord.PsychologyGuid
    .s reportData.NutritionGuid = tempWhAfterBirthVisitRecord.NutritionGuid
    .s reportData.BreastFeedingGuid = tempWhAfterBirthVisitRecord.BreastFeedingGuid
    .s reportData.Remark = tempWhAfterBirthVisitRecord.Remark
    .s reportData.Temperature = tempWhAfterBirthVisitRecord.Temperature
    .s reportData.Psychologic = tempWhAfterBirthVisitRecord.Psychologic      
    .s reportData.PreDate = tempWhAfterBirthVisitRecord.PreDate
    .i reportData.PreDate '= "" d
    ..s reportData.PreDate = $zd(reportData.PreDate,3)
    .s reportData.bClassAbnormity = tempWhAfterBirthVisitRecord.bClassAbnormity
    .s reportData.ClassAbnormityInfo = tempWhAfterBirthVisitRecord.ClassAbnormityInfo
    .s reportData.bTransfer = tempWhAfterBirthVisitRecord.bTransfer
    .s reportData.TransferReason = tempWhAfterBirthVisitRecord.TransferReason
    .s reportData.TransferDept = tempWhAfterBirthVisitRecord.TransferDept
    .; 处理数据
    .i (count>start)&(count<=end) d
    ..s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.WomenAfterCheckInfo") 	
	..s countProperties = cdef.Properties.Count()
	..s returnData = "<WomenAfterCheck>"
	..f i = 1:1:countProperties d
    ...s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	..s returnData = returnData_"</WomenAfterCheck>"
 	..i resultString = "" d
 	...s resultString = returnData
 	..e  d
 	...s resultString = resultString_returnData
 	i count '= 0 d
	.s result="<WomenAfterChecks count='"_count_"'>"_resultString_"</WomenAfterChecks>"
	q result
}

Storage Default
{
<Data name="WomenAfterCheckInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenAfterChA33D</DataLocation>
<DefaultData>WomenAfterCheckInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenAfterChA33D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenAfterChA33I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenAfterChA33S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
