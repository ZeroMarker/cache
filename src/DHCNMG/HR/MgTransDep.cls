/// Creator:
/// Descriptions:护理人员调科记录表
/// Date:2017-07-21
/// 
Class DHCNMG.HR.MgTransDep Extends %Persistent
{

/// 人员表ID
Property PerDr As %Library.String [ SqlColumnNumber = 2, SqlFieldName = Per_Dr ];

/// 科室
Property PerDepart As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_Depart ];

/// 开始日期
Property PerTranStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Per_Tran_StDate ];

/// 开始时间
Property PerTranStTime As %Time [ SqlColumnNumber = 5, SqlFieldName = Per_Tran_StTime ];

/// 结束日期
Property PerTranEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Per_Tran_EndDate ];

/// 结束时间
Property PerTranEndTime As %Time [ SqlColumnNumber = 7, SqlFieldName = Per_Tran_EndTime ];

/// 当前状态
Property PerTranCurrent As %Library.String(DISPLAYLIST = ",Yes,No,Pre", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N,P") [ SqlColumnNumber = 8, SqlFieldName = Per_Tran_Current ];

/// 备注
Property PerTranMem As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Per_Tran_Mem ];

/// 调科申请表ID
Property PerAppID As %String [ SqlColumnNumber = 10, SqlFieldName = Per_AppID ];

/// 调科类型【L:长期调科 T：临时调科】
Property PerTransType As %String [ SqlColumnNumber = 11, SqlFieldName = Per_TransType ];

Index ssdr On PerDr;

Index Current On (PerTranCurrent, PerDr);

Index Dep On PerDepart;

Index flag On (PerTranCurrent, PerDr, PerDepart);

Storage Default
{
<Data name="MgTransDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerDr</Value>
</Value>
<Value name="3">
<Value>PerDepart</Value>
</Value>
<Value name="4">
<Value>PerTranStDate</Value>
</Value>
<Value name="5">
<Value>PerTranStTime</Value>
</Value>
<Value name="6">
<Value>PerTranEndDate</Value>
</Value>
<Value name="7">
<Value>PerTranEndTime</Value>
</Value>
<Value name="8">
<Value>PerTranCurrent</Value>
</Value>
<Value name="9">
<Value>PerTranMem</Value>
</Value>
<Value name="10">
<Value>PerAppID</Value>
</Value>
<Value name="11">
<Value>PerTransType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgTransDepD</DataLocation>
<DefaultData>MgTransDepDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgTransDepD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgTransDepI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgTransDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
