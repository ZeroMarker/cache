Class CHSSWeb.HISInterface.WomenAntepartumRecheckInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-06-01
/// Description:第2~5次产前随访服务记录表
ClassMethod WomenAntepartumRecheckList(womanRowId As %String, start As %String, limit As %String) As %String
{
	s womanRowId=$G(womanRowId)
    s start=$G(start)
    s limit=$G(limit)
    s count=0
    s resultString = ""
    s returnData = ""
    s end = start+limit
    s recheckRowId = 0
    s reportData = ""
    f  s recheckRowId=$O(^CHSS.WhAntepartumRecheckI("WomanRowIdParrefIndex",womanRowId,recheckRowId)) q:recheckRowId=""  d    
    .s count = count + 1  
    .s tempWhAntepartumRecheck=##class(CHSS.WhAntepartumRecheck).%OpenId(recheckRowId)
    .s reportData = ##class(CHSSWeb.HISInterface.WomenAntepartumRecheckInfo).%New()
    .; 检查信息
    .s reportData.CheckDate = tempWhAntepartumRecheck.CheckDate
    .i reportData.CheckDate '= "" d
    ..s reportData.CheckDate = $zd(reportData.CheckDate,3)
    .s reportData.CheckUnit = tempWhAntepartumRecheck.CheckUnit     
    .s reportData.Checker = tempWhAntepartumRecheck.Checker
    .s reportData.PreDate = tempWhAntepartumRecheck.PreDate
    .i reportData.PreDate '= "" d
    ..s reportData.PreDate = $zd(reportData.PreDate,3)      
    .; 孕产检查信息
    .s reportData.UrineProtein = tempWhAntepartumRecheck.UrineProtein            
    .s reportData.Hemglobin = tempWhAntepartumRecheck.Hemglobin
    .s reportData.DangerGradeName = ""
    .s reportData.DangerGradeRowId = ""
    .i tempWhAntepartumRecheck.DangerGradeRowId '= "" d
    ..s reportData.DangerGradeRowId = tempWhAntepartumRecheck.DangerGradeRowId.%Id()
    ..s reportData.DangerGradeName = tempWhAntepartumRecheck.DangerGradeRowId.Description      
    .s reportData.PregWeeks = tempWhAntepartumRecheck.PregWeeks
    .s reportData.BPUnitName = ""
    .s reportData.BPUnit = ""
    .i tempWhAntepartumRecheck.BPUnit '= "" d
    ..s reportData.BPUnit = tempWhAntepartumRecheck.BPUnit.%Id()
    ..s reportData.BPUnitName = tempWhAntepartumRecheck.BPUnit.Description      
    .s reportData.HighPressure = tempWhAntepartumRecheck.HighPressure
    .s reportData.LowPressure = tempWhAntepartumRecheck.LowPressure
    .s reportData.Weight = tempWhAntepartumRecheck.Weight
    .s reportData.WombHeight = tempWhAntepartumRecheck.WombHeight
    .s reportData.AbdomenGirth = tempWhAntepartumRecheck.AbdomenGirth
    .s reportData.FetusPosition = tempWhAntepartumRecheck.FetusPosition           
    .s reportData.FetusCentre = tempWhAntepartumRecheck.FetusCentre
    .s reportData.FirstAppear = tempWhAntepartumRecheck.FirstAppear
    .s reportData.Gedema = tempWhAntepartumRecheck.Gedema
    .; 处理及建议
    .s reportData.OtherDeal = tempWhAntepartumRecheck.OtherDeal
    .s reportData.OtherCheck = tempWhAntepartumRecheck.OtherCheck
    .s reportData.TransferAdvice = tempWhAntepartumRecheck.TransferAdvice
    .s reportData.Remark = tempWhAntepartumRecheck.Remark
    .s reportData.Chiefcomplaint = tempWhAntepartumRecheck.Chiefcomplaint
    .s reportData.FHR = tempWhAntepartumRecheck.FHR
    .s reportData.bClassAbnormity = tempWhAntepartumRecheck.bClassAbnormity
    .s reportData.ClassAbnormityInfo = tempWhAntepartumRecheck.ClassAbnormityInfo
    .s reportData.bTransfer = tempWhAntepartumRecheck.bTransfer
    .s reportData.TransferReason = tempWhAntepartumRecheck.TransferReason
    .s reportData.TransferDept = tempWhAntepartumRecheck.TransferDept
    .; 处理数据
    .i (count>start)&(count<=end) d
    ..s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.WomenAntepartumRecheckInfo") 	
	..s countProperties = cdef.Properties.Count()
	..s returnData = "<AntepartumRecheck>"
	..f i = 1:1:countProperties d
    ...s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	..s returnData = returnData_"</AntepartumRecheck>"
 	..i resultString = "" d
 	...s resultString = returnData
 	..e  d
 	...s resultString = resultString_returnData
 	i count '= 0 d
	.s result="<AntepartumRechecks count='"_count_"'>"_resultString_"</AntepartumRechecks>"
	q result
}

Storage Default
{
<Data name="WomenAntepartumRecheckInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenAnteparD39D</DataLocation>
<DefaultData>WomenAntepartumRecheckInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenAnteparD39D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenAnteparD39I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenAnteparD39S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
