/// 用户自定义查询界面
Class EMRmeta.OPCustomerQuery Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxName On Name [ Unique ];

Property Name As %String(TRUNCATE = 1);

Property Columns As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Method As %String(TRUNCATE = 1);

Property Clazz As %String(TRUNCATE = 1);

Property RefColumns As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Pagination As %Boolean;

/// d ##class(EMRservice.BL.OPCustomerQuery).%BuildIndices()
ClassMethod insertRecord(Name, Columns, Method, Clazz, RefColumns, Pagination As %String)
{
	s id=$O(^DHCEMRM.OPCustomerQueryI("IdxName"," "_$zcvt(Name,"U"),""))
	q:(""'=id)

	s obj = ##Class(EMRmeta.OPCustomerQuery).%New()
	s obj.Name = Name
	s obj.Columns = Columns
	s obj.Method = Method
	s obj.Clazz = Clazz
	s obj.RefColumns = RefColumns
	s obj.Pagination = Pagination
	d obj.%Save()
}

/// d ##Class(EMRmeta.OPCustomerQuery).Init()
ClassMethod Init()
{
	d ##class(EMRmeta.OPCustomerQuery).%BuildIndices()
	
	s Name= "CustomerFirst"
	s Columns = "[[{""field"":""ck"",""checkbox"":true}, {""field"":""MedicareNo"",""title"":""病案号"",""width"":50},{""field"":""EpisodeDate"",""title"":""就诊日期"",""width"":80},{""field"":""Diagnosis"",""title"":""诊断"",""width"":100},{""field"":""EpisodeType"",""title"":""类型"",""width"":60},{""field"":""EpisodeDeptDesc"",""title"":""科室"",""width"":100},{""field"":""MainDocName"",""title"":""主治医生"",""width"":80},{""field"":""DischargeDate"",""title"":""出院日期"",""width"":60},{""field"":""EpisodeDeptID"",""title"":""科室ID"",""width"":40}]]"
	s Method = "GetEpisodeList"
	s Clazz = "EMRservice.BL.OPCustomerQuery"
	s RefColumns = "就诊号：{{EpisodeID}}，就诊日期：{{EpisodeDate}}"
	s Pagination = 1
	d ..insertRecord(Name, Columns, Method, Clazz, RefColumns, Pagination)
}

Storage Default
{
<Data name="OPCustomerQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>JSON</Value>
</Value>
<Value name="4">
<Value>Method</Value>
</Value>
<Value name="5">
<Value>Columns</Value>
</Value>
<Value name="6">
<Value>Clazz</Value>
</Value>
<Value name="7">
<Value>RefColumns</Value>
</Value>
<Value name="8">
<Value>Pagination</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.OPCustomerQueryD</DataLocation>
<DefaultData>OPCustomerQueryDefaultData</DefaultData>
<IdLocation>^DHCEMRM.OPCustomerQueryD</IdLocation>
<IndexLocation>^DHCEMRM.OPCustomerQueryI</IndexLocation>
<StreamLocation>^DHCEMRM.OPCustomerQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
