/// Creator:guozj
/// Descriptions:技术能手、服务之星
/// Date:2017-08-31
/// 
Class DHCNMG.HR.MgTechService Extends %Persistent
{

/// 护士
Property ElecteNurse As %String [ SqlColumnNumber = 2, SqlFieldName = Electe_Nurse ];

/// 评选日期
Property ElecteDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Electe_Date ];

/// 所在病区
Property ElecteWard As %String [ SqlColumnNumber = 4, SqlFieldName = Electe_Ward ];

/// 评选人
Property ElecteUser As %String [ SqlColumnNumber = 5, SqlFieldName = Electe_User ];

/// 创建日期
Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 6, SqlFieldName = RecDate ];

/// 状态【未提交：N  已提交：Y】
Property ElecteStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Electe_Status ];

/// 单据类型【技术能手：E 服务之星：S】
Property ElecteType As %String [ SqlColumnNumber = 8, SqlFieldName = Electe_Type ];

Index type On (ElecteType, ElecteDate);

Index dep On (ElecteType, ElecteDate, ElecteNurse, ElecteWard);

Storage Default
{
<Data name="MgTechServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElecteNurse</Value>
</Value>
<Value name="3">
<Value>ElecteDate</Value>
</Value>
<Value name="4">
<Value>ElecteWard</Value>
</Value>
<Value name="5">
<Value>ElecteUser</Value>
</Value>
<Value name="6">
<Value>RecDate</Value>
</Value>
<Value name="7">
<Value>ElecteStatus</Value>
</Value>
<Value name="8">
<Value>ElecteType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgTechServiceD</DataLocation>
<DefaultData>MgTechServiceDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgTechServiceD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgTechServiceI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgTechServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
