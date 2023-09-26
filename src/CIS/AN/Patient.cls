Class CIS.AN.Patient Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Patient ]
{

/// 登记号
Property RegNo As %String [ SqlColumnNumber = 2 ];

/// 患者ID
Property PatientID As %String [ SqlColumnNumber = 3 ];

/// 患者卡号
Property CardID As %String [ SqlColumnNumber = 4 ];

/// 患者身份证号
Property CertID As %String [ SqlColumnNumber = 5 ];

/// 姓名
Property FullName As %String [ SqlColumnNumber = 6 ];

/// 姓名拼音码
Property Alias As %String [ SqlColumnNumber = 7 ];

/// 住院登记号
Property InpatientNo As %String [ SqlColumnNumber = 8 ];

/// 门诊登记号
Property OutpatientNo As %String [ SqlColumnNumber = 9 ];

/// 出生日期
Property DOB As %Date [ SqlColumnNumber = 10 ];

/// 患者性别
Property Sex As CT.AN.Sex [ SqlColumnNumber = 11 ];

/// 激活标志
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 12 ];

/// Deceased Flag
Property Deceased As %String(DISPLAYLIST = ",是,否", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13 ];

/// Deceased Date
Property DeceasedDate As %Date [ SqlColumnNumber = 14 ];

/// Deceased Time
Property DeceasedTime As %Time [ SqlColumnNumber = 15 ];

/// 患者民族
Property Nation As %String [ SqlColumnNumber = 16 ];

/// 社保状态
Property SocialStatus As %String [ SqlColumnNumber = 17 ];

/// 家庭住址
Property Address As %String [ SqlColumnNumber = 18 ];

/// 手机号码
Property TelephoneNo As %String [ SqlColumnNumber = 19 ];

/// 患者保密级别
Property SecretLevel As %String [ SqlColumnNumber = 20 ];

/// 患者保密代码
Property SecretCode As %String [ SqlColumnNumber = 21 ];

/// 患者登记号索引
Index IReg On RegNo;

/// 患者ID索引
Index IPatID On PatientID;

/// 患者身份证号索引
Index ICert On CertID;

/// 患者性别索引
Index ISex On Sex;

/// 激活状态索引
Index IActive On Active;

/// 死亡标志索引
Index IDeceased On Deceased;

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>RegNo</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>CardID</Value>
</Value>
<Value name="4">
<Value>CertID</Value>
</Value>
<Value name="5">
<Value>FullName</Value>
</Value>
<Value name="6">
<Value>Alias</Value>
</Value>
<Value name="7">
<Value>InpatientNo</Value>
</Value>
<Value name="8">
<Value>OutpatientNo</Value>
</Value>
<Value name="9">
<Value>DOB</Value>
</Value>
<Value name="10">
<Value>Sex</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
<Value name="12">
<Value>Deceased</Value>
</Value>
<Value name="13">
<Value>DeceasedDate</Value>
</Value>
<Value name="14">
<Value>DeceasedTime</Value>
</Value>
<Value name="15">
<Value>Nation</Value>
</Value>
<Value name="16">
<Value>SocialStatus</Value>
</Value>
<Value name="17">
<Value>Address</Value>
</Value>
<Value name="18">
<Value>TelephoneNo</Value>
</Value>
<Value name="19">
<Value>SecretLevel</Value>
</Value>
<Value name="20">
<Value>SecretCode</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^CIS.AN.PatientD</IdLocation>
<IndexLocation>^CIS.AN.PatientI</IndexLocation>
<StreamLocation>^CIS.AN.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
