Class ABN.DHCNurCureRec Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//开始日期

Relationship ChildSub As ABN.DHCNurCureRecChild [ Cardinality = children, Inverse = CureRecParef ];

Property PapmiID As %String;

Property CureStdate As %Library.Date(FORMAT = 1);

//达维持剂量的日期

Property CureAttainDoseDate As %Library.Date(FORMAT = 1);

//维持剂量 

Property ProtectDose As %String(TRUNCATE = 1);

//维持治疗的时间间隔

Property InterValDays As %String(TRUNCATE = 1);

//处方信息 

Property Prescription As %String(TRUNCATE = 1);

//免疫治疗方案 (常规，维持)

Property Scheme As %Library.String(DISPLAYLIST = ",Routine,Keep", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",R,K");

//最佳极限峰流速 

Property FineRate As %String(TRUNCATE = 1);

Index papmi On PapmiID;

Index CureStdateIndex On CureStdate;

Storage Default
{
<Data name="DHCNurCureRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CureStdate</Value>
</Value>
<Value name="3">
<Value>CureAttainDoseDate</Value>
</Value>
<Value name="4">
<Value>ProtectDose</Value>
</Value>
<Value name="5">
<Value>InterValDays</Value>
</Value>
<Value name="6">
<Value>Prescription</Value>
</Value>
<Value name="7">
<Value>Scheme</Value>
</Value>
<Value name="8">
<Value>FineRate</Value>
</Value>
<Value name="9">
<Value>PapmiID</Value>
</Value>
</Data>
<DataLocation>^ABN.DHCNurCureRecD</DataLocation>
<DefaultData>DHCNurCureRecDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ABN.DHCNurCureRecD</IdLocation>
<IndexLocation>^ABN.DHCNurCureRecI</IndexLocation>
<StreamLocation>^ABN.DHCNurCureRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
