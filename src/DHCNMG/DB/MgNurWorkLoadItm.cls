/// creator: zhangjz
/// Description：新版工作量项目表
/// Date:2018-07-30
Class DHCNMG.DB.MgNurWorkLoadItm Extends %Persistent
{

// Relationship ChildSub As DHCNMG.DB.MgNurWorkLoadItmSub [ Cardinality = children, Inverse = Parref ];

Property WorkItm As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WorkItm ];

Property WorkCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WorkCode ];

Property WorkDistill As %Library.String(DISPLAYLIST = ",WorkLoad,Attention,OutIn,Qt", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",W,A,O,Q") [ SqlColumnNumber = 4, SqlFieldName = WorkDistill ];

Property WorkRelItm As %Library.String(DISPLAYLIST = ",Instruct,Hours,Days,Persons,Num", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,H,D,P,N") [ SqlColumnNumber = 5, SqlFieldName = WorkRelItm ];

Property WorkPercent As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = WorkPercent ];

Property WorkMeth As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = WorkMeth ];

Property CurrFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CurrFlag ];

/// 开始日期
Property StartDate As %Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = StartDate ];

/// 结束日期
Property EndDate As %Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = EndDate ];

Index TYP On WorkDistill;

Index Type On (WorkDistill, WorkCode);

Storage Default
{
<Data name="MgNurWorkLoadItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkItm</Value>
</Value>
<Value name="3">
<Value>WorkCode</Value>
</Value>
<Value name="4">
<Value>WorkDistill</Value>
</Value>
<Value name="5">
<Value>WorkRelItm</Value>
</Value>
<Value name="6">
<Value>WorkPercent</Value>
</Value>
<Value name="7">
<Value>WorkMeth</Value>
</Value>
<Value name="8">
<Value>CurrFlag</Value>
</Value>
<Value name="9">
<Value>StartDate</Value>
</Value>
<Value name="10">
<Value>EndDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgNurWorkLoadItmD</DataLocation>
<DefaultData>MgNurWorkLoadItmDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgNurWorkLoadItmD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgNurWorkLoadItmI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgNurWorkLoadItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
