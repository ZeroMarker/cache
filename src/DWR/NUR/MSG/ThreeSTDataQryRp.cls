Class DWR.NUR.MSG.ThreeSTDataQryRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 患者ID
Property PatientID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 患者编号
Property PatientNo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 患者姓名
Property PatientName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 性别名称
Property Sex As %String(MAXLEN = 50, TRUNCATE = 1);

/// 年龄
Property Age As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入院日期       (YYYY-MM-DD)
Property InDate As %String(MAXLEN = 50, TRUNCATE = 1);

/// 住院天数       
Property InDays As %String(MAXLEN = 50, TRUNCATE = 1);

/// 床号      
Property BedNo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 病区
Property WardName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科室名称
Property DepartmentName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主管医生
Property Doctor As %String(MAXLEN = 50, TRUNCATE = 1);

/// 第几周
Property Week As %String(TRUNCATE = 1);

/// 患者生命体征数据列表
Property ThreeSTDataList As list Of DWR.NUR.MSG.ThreeSTDataDay(XMLNAME = "ThreeSTDataList");

Storage Default
{
<Data name="ThreeSTDataQryRpDefaultData">
<Subscript>"ThreeSTDataQryRp"</Subscript>
<Value name="1">
<Value>Age</Value>
</Value>
<Value name="2">
<Value>BedNo</Value>
</Value>
<Value name="3">
<Value>DepartmentName</Value>
</Value>
<Value name="4">
<Value>Doctor</Value>
</Value>
<Value name="5">
<Value>InDate</Value>
</Value>
<Value name="6">
<Value>InDays</Value>
</Value>
<Value name="7">
<Value>PatientID</Value>
</Value>
<Value name="8">
<Value>PatientName</Value>
</Value>
<Value name="9">
<Value>PatientNo</Value>
</Value>
<Value name="10">
<Value>ResultCode</Value>
</Value>
<Value name="11">
<Value>ResultContent</Value>
</Value>
<Value name="12">
<Value>Sex</Value>
</Value>
<Value name="13">
<Value>ThreeSTDataList</Value>
</Value>
<Value name="14">
<Value>WardName</Value>
</Value>
</Data>
<DefaultData>ThreeSTDataQryRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
