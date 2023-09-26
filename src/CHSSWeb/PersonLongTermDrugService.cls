Class CHSSWeb.PersonLongTermDrugService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009—07-10
/// Description:检索体检乙肝用药情况
/// Table：PersonLongTermDrug
/// Input: PersonLongTermDrug
/// Output：
/// Return：
/// Others：
ClassMethod ListPage(start As %Integer, limit As %Integer, PersonRowId As %Integer, RecordId As %Integer, TableType As %String) As %String
{
  
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DrugRowId,DateOfStart,DateOfEnd,DrugName,DrugCode,Useage,Dosage,ADR,Remark,RecordId,RecordType FROM CHSS.PersonLongTermDrug"
		
	i (PersonRowId'="")&&(TableType'="") d
	.s sqlStr = sqlStr_" where PersonRowId ="_PersonRowId_" and TableType='"_TableType_"'"
	e  i (RecordId'="")&&(TableType'="") d
	.s sqlStr = sqlStr_" where RecordId ="_RecordId_" and TableType='"_TableType_"'"
	e  i (RecordId'="") d
	.s sqlStr = sqlStr_" where RecordId ="_RecordId_" and TableType is null"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()
	
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
	Set tmp=DrugRowId_"^"_DateOfStart_"^"_DateOfEnd_"^"_DrugName_"^"_DrugCode_"^"_Useage_"^"_Dosage_"^"_ADR_"^"_Remark_"^"_RecordId_"^"_RecordType
	Set count = count+1
	If (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("DrugRowId^DateOfStart^DateOfEnd^DrugName^DrugCode^Useage^Dosage^ADR^Remark^RecordId^RecordType",count)
	
	k json
	d result.Close()
	q resultString
}

ClassMethod ListPage1(start As %Integer, limit As %Integer, PersonRowId As %Integer, RecordId As %Integer, TableType As %String) As %String
{
  
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DrugRowId,DateOfStart,DateOfEnd,DrugName,DrugCode,Useage,Dosage,ADR,Remark,RecordId,RecordType FROM CHSS.PersonLongTermDrug"
		
	i (PersonRowId'="")&&(TableType'="")&&(RecordId'="") d
	.s sqlStr = sqlStr_" where PersonRowId ="_PersonRowId_" and TableType='"_TableType_"' and RecordId="_RecordId_""
	e  i (RecordId'="")&&(TableType'="") d
	.s sqlStr = sqlStr_" where RecordId ="_RecordId_" and TableType='"_TableType_"'"
	e  i (RecordId'="") d
	.s sqlStr = sqlStr_" where RecordId ="_RecordId_" and TableType is null"

	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()
	
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
	Set tmp=DrugRowId_"^"_DateOfStart_"^"_DateOfEnd_"^"_DrugName_"^"_DrugCode_"^"_Useage_"^"_Dosage_"^"_ADR_"^"_Remark_"^"_RecordId_"^"_RecordType
	Set count = count+1
	If (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("DrugRowId^DateOfStart^DateOfEnd^DrugName^DrugCode^Useage^Dosage^ADR^Remark^RecordId^RecordType",count)
	
	k json
	d result.Close()
	q resultString
}

ClassMethod ShowInfo(start As %Integer, limit As %Integer, PersonRowId As %Integer, RecordId As %Integer, TableType As %String) As %String
{
  
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DrugRowId,DateOfStart,DateOfEnd,DrugName,DrugCode,Useage,Dosage,ADR,Remark,RecordId,RecordType FROM CHSS.PersonLongTermDrug"
	
	i (PersonRowId'="")&&(TableType'="") d
	.s sqlStr = sqlStr_" where PersonRowId ="_PersonRowId_" and TableType='"_TableType_"'"
	e  i (RecordId'="")&&(TableType'="") d
	.s sqlStr = sqlStr_" where RecordId ="_RecordId_" and TableType='"_TableType_"'"
	e  i (RecordId'="") d
	.s sqlStr = sqlStr_" where RecordId ="_RecordId_" and TableType is null"

		
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	set tmp = ""
	set startStr = "'"
	
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
	.s tmp = tmp_"'"
	e  d
	.s tmp = """"""
	q "{""success"":""true"",""info"":"_tmp_"}"
}

ClassMethod ShowInfo1(start As %Integer, limit As %Integer, PersonRowId As %Integer, RecordId As %Integer, TableType As %String) As %String
{
  
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DrugRowId,DateOfStart,DateOfEnd,DrugName,DrugCode,Useage,Dosage,ADR,Remark,RecordId,RecordType FROM CHSS.PersonLongTermDrug"
	
	i (PersonRowId'="")&&(TableType'="")&&(RecordId'="") d
	.s sqlStr = sqlStr_" where PersonRowId ="_PersonRowId_" and TableType='"_TableType_"' and RecordId="_RecordId_""
	e  i (RecordId'="")&&(TableType'="") d
	.s sqlStr = sqlStr_" where RecordId ="_RecordId_" and TableType='"_TableType_"'"
	e  i (RecordId'="") d
	.s sqlStr = sqlStr_" where RecordId ="_RecordId_" and TableType is null"

	
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	set tmp = ""
	set startStr = "'"
	
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
	.s tmp = tmp_"'"
	e  d
	.s tmp = """"""
	q "{""success"":""true"",""info"":"_tmp_"}"
}

ClassMethod insert(DateOfStart, DateOfEnd, DrugName, DrugCode, Useage, Dosage, ADR, Remark, RecordId, RecordType, PersonRowId As %Integer, TableType As %String) As %String
{
	q:((PersonRowId="")||(TableType=""))&&(RecordId="") "个人档案号，药品类别或体检记录号为空，保存出错！"
		
	s DrugRowId=""
	q:DrugRowId'="" "code-rep"

	i DateOfStart '= "" d
	.s start=$zdh(DateOfStart,3)
	i DateOfEnd '= "" d
	.s end=$zdh(DateOfEnd,3)
	&sql(insert into CHSS.PersonLongTermDrug (DateOfStart,DateOfEnd,DrugName,DrugCode,Useage,Dosage,ADR,Remark,RecordId,RecordType, PersonRowId, TableType) values(:start,:end,:DrugName,:DrugCode,:Useage,:Dosage,:ADR,:Remark,:RecordId,:RecordType,:PersonRowId,:TableType))
	q SQLCODE
}

/// Modify jinming by 2011-6-30
ClassMethod update(DrugRowId, DateOfStart, DateOfEnd, DrugName, DrugCode, Useage, Dosage, ADR, Remark, RecordType) As %String
{
	
	q:(DrugRowId="") "code-rep"
	i DateOfStart '= "" d
	.s start=$zdh(DateOfStart,3)
	i DateOfEnd '= "" d
	.s end=$zdh(DateOfEnd,3)
	&sql(update CHSS.PersonLongTermDrug set DateOfStart=:start,DateOfEnd=:end,DrugName=:DrugName,DrugCode=:DrugCode,Useage=:Useage,Dosage=:Dosage,ADR=:ADR,Remark=:Remark,RecordType=:RecordType where %ID=:DrugRowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(DrugRowId) As %String
{
	&sql(delete from CHSS.PersonLongTermDrug where %ID=:DrugRowId)
	q SQLCODE
}

Storage Default
{
<Data name="PersonLongTermDrugServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonLongTeA02D</DataLocation>
<DefaultData>PersonLongTermDrugServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonLongTeA02D</IdLocation>
<IndexLocation>^CHSSWeb.PersonLongTeA02I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonLongTeA02S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
