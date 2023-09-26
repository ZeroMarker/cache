Class CHSSWeb.HISInterface.WomenAfter42DaysRecordInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-06-03
/// Description:产后42天健康检查记录表
ClassMethod WomenAfter42DaysRecordInfo(WomanRowId As %String) As %String
{
	Set WomanRowId=$G(WomanRowId)
    Set count=0
    s reportData = ""
    set VisitRowId = 0
    For  Set VisitRowId=$O(^CHSS.WhAfter42DaysRecordI("WomanRowIdIndex",WomanRowId,VisitRowId)) q:VisitRowId=""  d
    .s tempWhAfter42DaysRecord=##class(CHSS.WhAfter42DaysRecord).%OpenId(VisitRowId)
    .s reportData = ##class(CHSSWeb.HISInterface.WomenAfter42DaysRecordInfo).%New()
    .; 检查信息
    .s reportData.CheckDate = tempWhAfter42DaysRecord.CheckDate
    .i reportData.CheckDate '= "" d
    ..s reportData.CheckDate = $zd(reportData.CheckDate,3)
    .s reportData.CheckUnit = tempWhAfter42DaysRecord.CheckUnit      
    .s reportData.Checker = tempWhAfter42DaysRecord.Checker
    .; 健康检查
    .s reportData.GeneralCheck = tempWhAfter42DaysRecord.GeneralCheck
    .s reportData.HighPressure = tempWhAfter42DaysRecord.HighPressure
    .s reportData.LowPressure = tempWhAfter42DaysRecord.LowPressure
    .s reportData.Weight = tempWhAfter42DaysRecord.Weight
    .s reportData.Brest = tempWhAfter42DaysRecord.Brest
    .s reportData.Uterus = tempWhAfter42DaysRecord.Uterus
    .s reportData.Lochia = tempWhAfter42DaysRecord.Lochia
    .s reportData.Wound = tempWhAfter42DaysRecord.Wound
    .s reportData.OtherCheck = tempWhAfter42DaysRecord.OtherCheck
    .; 保健指导
    .s reportData.GeneralGuid = tempWhAfter42DaysRecord.GeneralGuid
    .s reportData.BirthControlGuid = tempWhAfter42DaysRecord.BirthControlGuid
    .s reportData.PsychologyGuid = tempWhAfter42DaysRecord.PsychologyGuid
    .s reportData.NutritionGuid = tempWhAfter42DaysRecord.NutritionGuid
    .s reportData.BreastFeedingGuid = tempWhAfter42DaysRecord.BreastFeedingGuid
    .s reportData.Remark = tempWhAfter42DaysRecord.Remark
    .s reportData.Psychologic = tempWhAfter42DaysRecord.Psychologic
    .s reportData.bClassAbnormity = tempWhAfter42DaysRecord.bClassAbnormity
    .s reportData.ClassAbnormityInfo = tempWhAfter42DaysRecord.ClassAbnormityInfo
    .s reportData.bTransfer = tempWhAfter42DaysRecord.bTransfer
    .s reportData.TransferReason = tempWhAfter42DaysRecord.TransferReason
    .s reportData.TransferDept = tempWhAfter42DaysRecord.TransferDept
    .; 处理数据
    .s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.WomenAfter42DaysRecordInfo") 	
	.s count = cdef.Properties.Count()
	.s returnData = "<WomenAfter42DaysRecord>"
	.f i = 1:1:count d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</WomenAfter42DaysRecord>"
	q returnData
}

Storage Default
{
<Data name="WomenAfter42DaysRecordInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenAfter42CABD</DataLocation>
<DefaultData>WomenAfter42DaysRecordInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenAfter42CABD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenAfter42CABI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenAfter42CABS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
