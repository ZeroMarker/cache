Class CHSS.PersonHealthBefore512 Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = BeforeRowId, SqlTableName = PersonHealthBefore512 ]
{

//个人档案主键

Property PersonRowIdParref As CHSS.PersonHealthRecordMain [ SqlColumnNumber = 2, SqlFieldName = PersonRowIdParref ];

//地震前结核病既往史

Property bHaveTBHISBefore As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = bHaveTBHISBefore ];

//地震前是否有结核病

Property bHaveTB As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = bHaveTB ];

//诊断

Property TBDiagnose As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TBDiagnose ];

//是否治疗

Property bTreat As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = bTreat ];

//家庭成员中是否有肺结核

Property bFamilyHaveTB As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = bFamilyHaveTB ];

//接触者是否有肺结核

Property bContractHaveTB As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = bContractHaveTB ];

//地震前是否做过乙肝检查

Property bHBVCheck As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = bHBVCheck ];

//乙肝检查时间

Property DateOfHBVCheck As %Date [ SqlColumnNumber = 10, SqlFieldName = DateOfHBVCheck ];

//HbsAg

Property HbsAg As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = HbsAg ];

//HbsAb

Property HbsAb As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = HbsAb ];

//HbeAg

Property HbeAg As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = HbeAg ];

//HBeAb

Property HBeAb As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = HBeAb ];

//HbcAb

Property HbcAb As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = HbcAb ];

//地震前HbsAg

Property HbsAgBefore As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = HbsAgBefore ];

//HbsAgType

Property HbsAgType As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = HbsAgType ];

//曾经有医生告诉您患过支气管哮喘

Property bToldBronchia As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = bToldBronchia ];

//目前您是否仍然患有哮喘

Property bHaveBronchiaCur As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = bHaveBronchiaCur ];

//父母兄弟姐妹患有哮喘

Property bFamilyHaveBronchia As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = bFamilyHaveBronchia ];

//其他亲戚是否患有哮喘

Property bOtherRelaHaveBro As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = bOtherRelaHaveBro ];

//地震后病情是否加重

Property bWorse As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = bWorse ];

Index PresonRowIdParrefIndex On PersonRowIdParref [ Unique ];

Storage Default
{
<Data name="PersonHealthBefore512DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfHBVCheck</Value>
</Value>
<Value name="3">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="4">
<Value>TBDiagnose</Value>
</Value>
<Value name="5">
<Value>bContractHaveTB</Value>
</Value>
<Value name="6">
<Value>bFamilyHaveTB</Value>
</Value>
<Value name="7">
<Value>bHBVCheck</Value>
</Value>
<Value name="8">
<Value>bHaveTB</Value>
</Value>
<Value name="9">
<Value>bHaveTBHISBefore</Value>
</Value>
<Value name="10">
<Value>bTreat</Value>
</Value>
<Value name="11">
<Value>HBeAb</Value>
</Value>
<Value name="12">
<Value>HbcAb</Value>
</Value>
<Value name="13">
<Value>HbeAg</Value>
</Value>
<Value name="14">
<Value>HbsAb</Value>
</Value>
<Value name="15">
<Value>HbsAg</Value>
</Value>
<Value name="16">
<Value>HbsAgBefore</Value>
</Value>
<Value name="17">
<Value>HbsAgType</Value>
</Value>
<Value name="18">
<Value>bFamilyHaveBronchia</Value>
</Value>
<Value name="19">
<Value>bHaveBronchiaCur</Value>
</Value>
<Value name="20">
<Value>bOtherRelaHaveBro</Value>
</Value>
<Value name="21">
<Value>bToldBronchia</Value>
</Value>
<Value name="22">
<Value>bWorse</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHealthBefore512D</DataLocation>
<DefaultData>PersonHealthBefore512DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonHealthBefore512D</IdLocation>
<IndexLocation>^CHSS.PersonHealthBefore512I</IndexLocation>
<StreamLocation>^CHSS.PersonHealthBefore512S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
