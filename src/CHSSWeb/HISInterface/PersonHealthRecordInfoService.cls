Class CHSSWeb.HISInterface.PersonHealthRecordInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-05-23
/// Description:健康体检表--健康情况--中医体质辨识,现存主要健康问题,家庭病床史,计划外免疫史
ClassMethod PersonHealthDiagnoseInfo(personRowId As %Integer, ItemdCode As %String) As %String
{
	s personRowId = $g(personRowId)
	s ItemdCode = $g(ItemdCode)
	set ItemdCode = " "_ItemdCode	
	s reportData = ""
	s returnData = ""
	set tmp = ""
	set startStr = ""
	set DiagnoseRowId = 0
	For  Set DiagnoseRowId=$O(^CHSS.PersonHealthDiagnoseI("PersonAndCodeIndex",personRowId,ItemdCode,DiagnoseRowId)) q:DiagnoseRowId=""  d
	.s tempObj=##class(CHSS.PersonHealthDiagnose).%OpenId(DiagnoseRowId)
	.s DetailRowId = tempObj.DetailRowId
	.s ItemName = tempObj.ItemName
	.s ItemAssortCode = tempObj.ItemAssortCode
	.s ItemAssortName = tempObj.ItemAssortName
	.s DiagnoseResult = tempObj.DiagnoseResult
	.s ICDCode = tempObj.ICDCode
	.set DateOfStart = tempObj.DateOfStart
	.i DateOfStart '= "" d
	..s DateOfStart = $zd(DateOfStart,3)
	.set DateOfEnd = tempObj.DateOfEnd
	.i DateOfEnd '= "" d
	..s DateOfEnd = $zd(DateOfEnd,3)
	.s MainPart = tempObj.MainPart
	.s MainReason = tempObj.MainReason
	.s MainDiagnose = tempObj.MainDiagnose
	.s SequenceCode = tempObj.SequenceCode

	.i ItemdCode = " 1" d  //ABO血型
	..s tmp = tmp_startStr_DiagnoseResult
	.e  i ItemdCode = " 2" d  //RH血型
	..s tmp = tmp_startStr_DiagnoseResult
	.e  i ItemdCode = " 3" d  //药物过敏史
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 4" d  //暴露史
	..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
	.e  i ItemdCode = " 5" d  //疾病史
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 51" d  //外伤
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 6" d  //手术史
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 7" d  //输血情况
	..s tmp = tmp_startStr_DiagnoseResult
	.e  i ItemdCode = " 8" d  //家族疾病史-父亲
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 9" d  //家族疾病史-母亲
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 10" d  //家族疾病史-兄弟姐妹
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 11" d  //家族疾病史-子女
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 12" d  //家族遗传病史
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 13" d  //精神疾病情况
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 14" d  //残疾状况
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 15" d  //免疫接种类别
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 16" d  //并发症
	..i DateOfStart '= "" d
	...s DateOfStart =  $p(DateOfStart,"-",1,1)
	...s tmp = tmp_startStr_ItemAssortName_":"_DateOfStart_"年"
	..e  d
	...s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 18" d  //有创医疗操作
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 19" d  //体征
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 20" d  //传染病接触史
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 21" d //X线检查结果
	..s tmp = tmp_startStr_ItemAssortName_DiagnoseResult_ItemAssortCode
	.e  i ItemdCode = " 22" d  //慢性病
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 23" d  //家族疾病史-祖辈
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 24" d  //中医体质辨识
	..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
	.e  i ItemdCode = " 25" d  //现存主要健康问题
	..s tmp = tmp_startStr_DiagnoseResult
	.e  i ItemdCode = " 26" d  //住院史
	..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
	.e  i ItemdCode = " 27" d  //家庭病床史
	..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
	.e  i ItemdCode = " 28" d  //主要用药情况
	..s tmp = tmp_startStr_ItemAssortName
	.e  i ItemdCode = " 29" d  //妇科疾病
	..s tmp = tmp_startStr_ItemAssortName
	.s startStr = "、"
	i tmp '= "" d
	.s reportData = ##class(CHSSWeb.HISInterface.PersonHealthRecordInfo).%New()
	.s reportData.Info = tmp
	.s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonHealthRecordInfo") 	
	.s count = cdef.Properties.Count()
	.s returnData = "<PersonHealthDiagnose>"
	.f i = 1:1:count d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</PersonHealthDiagnose>"
	q returnData
}

/// Creator:jinming
/// CreateDate:2011-05-23
/// Description:健康体检表--健康情况--住院史
ClassMethod PersonInHosRecordInfo(personRowId As %String) As %String
{
	Set personRowId=$G(personRowId)
	s reportData = ""
	s returnData = ""
	s InHosRowId=0
	s tmp = ""
	s startStr = ""
    For  Set InHosRowId=$O(^CHSS.PersonInHosRecordI("PersonIndex",personRowId,InHosRowId)) q:InHosRowId=""  d
	.s tempHos=##class(CHSS.PersonInHosRecord).%OpenId(InHosRowId)
	.s DateInHos=tempHos.DateInHos
	.i DateInHos'="" d
	..s DateInHos=$zd(DateInHos,3)
	.s HospitalName = tempHos.HospitalName
	.s DeptName = tempHos.DeptName
	.s Diagnose = tempHos.Diagnose
	.s Result = tempHos.Result
	.s DateOutHos =tempHos.DateOutHos
	.i tempHos.DateOutHos '= "" d
	..s DateOutHos = $zd(tempHos.DateOutHos,3)
	.s InHosCode = tempHos.InHosCode
	.s Remark = tempHos.Remark
	.s DateRegister = tempHos.DateRegister
	.i tempHos.DateRegister '= "" d
	..s DateRegister = $zd(tempHos.DateRegister,3)
	.s Register = tempHos.Register
	.s tmp = tmp_startStr_HospitalName_":"_Diagnose
	.s startStr = "、"
	i tmp '= "" d
	.s reportData = ##class(CHSSWeb.HISInterface.PersonHealthRecordInfo).%New()
	.s reportData.Info = tmp
	.s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonHealthRecordInfo") 	
	.s count = cdef.Properties.Count()
	.s returnData = "<PersonInHos>"
	.f i = 1:1:count d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</PersonInHos>"
	q returnData
}

/// Creator:jinming
/// CreateDate:2011-05-23
/// Description:健康体检表--健康情况--主要用药情况
ClassMethod PersonUseDrugInfo(personRowId As %String, checkRowId As %String, tableType As %String) As %String
{
	s personRowId = $g(personRowId)
	s checkRowId = $g(checkRowId)
	s tableType = $g(tableType)
	s reportData = ""
	s returnData = ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DrugRowId,DateOfStart,DateOfEnd,DrugName,DrugCode,Useage,Dosage,ADR,Remark,RecordId,RecordType FROM CHSS.PersonLongTermDrug"	
	i (personRowId'="")&&(tableType'="")&&(checkRowId'="") d
	.s sqlStr = sqlStr_" where PersonRowId ="_personRowId_" and TableType='"_tableType_"' and RecordId="_checkRowId_""
	e  i (checkRowId'="")&&(tableType'="") d
	.s sqlStr = sqlStr_" where RecordId ="_checkRowId_" and TableType='"_tableType_"'"
	e  i (checkRowId'="") d
	.s sqlStr = sqlStr_" where RecordId ="_checkRowId_" and TableType is null"		
	d result.Prepare(sqlStr)
	d result.Execute()	
	set tmp = ""
	set startStr = ""	
	While(result.Next())
	{
		s DrugRowId = result.Data("DrugRowId")
		s DateOfStart = result.Data("DateOfStart")
		i (DateOfStart'="") d
		.s DateOfStart = $zd(DateOfStart,3)
		s DateOfEnd = result.Data("DateOfEnd")
		i (DateOfEnd'="") d
		.s DateOfEnd = $zd(DateOfEnd,3)
		s DrugName = result.Data("DrugName")
		s DrugCode = result.Data("DrugCode")
		s Useage = result.Data("Useage")
		s Dosage = result.Data("Dosage")
		s ADR = result.Data("ADR")
		s Remark = result.Data("Remark")
		s RecordId = result.Data("RecordId")
		s RecordType = result.Data("RecordType")
		Set tmp = tmp_startStr_DrugName
		s startStr = "、"
	}	
	i tmp '= "" d
	.s reportData = ##class(CHSSWeb.HISInterface.PersonHealthRecordInfo).%New()
	.s reportData.Info = tmp
	.s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonHealthRecordInfo") 	
	.s count = cdef.Properties.Count()
	.s returnData = "<PersonUseDrug>"
	.f i = 1:1:count d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</PersonUseDrug>"
	q returnData
}

/// Creator:jinming
/// CreateDate:2011-06-22
/// Description:健康体检表--健康情况--主要用药情况列表
ClassMethod PersonUseDrugList(personRowId As %String, checkRowId As %String, tableType As %String, start As %String, limit As %String) As %String
{
	s personRowId = $g(personRowId)
	s checkRowId = $g(checkRowId)
	s tableType = $g(tableType)
	s start = $g(start)
	s limit = $g(limit)	
	s resultString=""
	s count=0
	s end=start+limit
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DrugRowId,DateOfStart,DateOfEnd,DrugName,DrugCode,Useage,Dosage,ADR,Remark,RecordId,RecordType FROM CHSS.PersonLongTermDrug"	
	i (personRowId'="")&&(tableType'="")&&(checkRowId'="") d
	.s sqlStr = sqlStr_" where PersonRowId ="_personRowId_" and TableType='"_tableType_"' and RecordId="_checkRowId_""
	e  i (checkRowId'="")&&(tableType'="") d
	.s sqlStr = sqlStr_" where RecordId ="_checkRowId_" and TableType='"_tableType_"'"
	e  i (checkRowId'="") d
	.s sqlStr = sqlStr_" where RecordId ="_checkRowId_" and TableType is null"		
	d result.Prepare(sqlStr)
	d result.Execute()	
	
	While(result.Next())
	{
		s DrugRowId = result.Data("DrugRowId")
		s DateOfStart = result.Data("DateOfStart")
		i (DateOfStart'="") d
		.s DateOfStart = $zd(DateOfStart,3)
		s DateOfEnd = result.Data("DateOfEnd")
		i (DateOfEnd'="") d
		.s DateOfEnd = $zd(DateOfEnd,3)
		s DrugName = result.Data("DrugName")
		s DrugCode = result.Data("DrugCode")
		s Useage = result.Data("Useage")
		s Dosage = result.Data("Dosage")
		s ADR = result.Data("ADR")
		s Remark = result.Data("Remark")
		s RecordId = result.Data("RecordId")
		s RecordType = result.Data("RecordType")
		
		s temp="<Drag>"
		s count=count+1
		i (count>start)&(count<=end) d
		.s temp=temp_"<RowId>"_DrugRowId_"</RowId>"
		.;药物名称
		.s temp=temp_"<DrugName>"_DrugName_"</DrugName>"
		.;剂量
		.s temp=temp_"<Dosage>"_Dosage_"</Dosage>"
		.;疗程
		.s temp=temp_"<Useage>"_Useage_"</Useage>"
		.s temp=temp_"</Drag>"
		.s resultString=resultString_temp
		
	}	
	
	i count'=0 d
	.s resultString="<Drags count='"_count_"'>"_resultString_"</Drags>"
	q resultString
}

Storage Default
{
<Data name="PersonHealthRecordInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonHealthB89D</DataLocation>
<DefaultData>PersonHealthRecordInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonHealthB89D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonHealthB89I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonHealthB89S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
