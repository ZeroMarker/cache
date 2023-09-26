Class CHSS.PersonChangeRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = PERSON_CHANGE_SN, SqlTableName = PersonChangeRecord ]
{

/// 个人档案主键	
Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

/// 原因编码	
Property ReasonSn As CHSS.DictChangeReason;

/// 操作员	
Property Operator As User.SSUser;

/// 变更日期	
Property OperatorDate As %Date(FORMAT = 1);

/// 登记日期	
Property RegisterDate As %Date(FORMAT = 1);

/// 备注	
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 曾经社区编码	
Property OldCommunityCode As %String(MAXLEN = 5, TRUNCATE = 1);

/// 迁入 还是迁出 
Property InOrOut As %String(MAXLEN = 10, TRUNCATE = 1);

Index PersonRowIdIndex On PersonRowId;

Storage Default
{
<Data name="PersonChangeRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPERATOR</Value>
</Value>
<Value name="3">
<Value>OPERATORDATE</Value>
</Value>
<Value name="4">
<Value>PersonRowId</Value>
</Value>
<Value name="5">
<Value>REASONSN</Value>
</Value>
<Value name="6">
<Value>REGISTERDATE</Value>
</Value>
<Value name="7">
<Value>REMARK</Value>
</Value>
<Value name="8">
<Value>OldCommunityCode</Value>
</Value>
<Value name="9">
<Value>Operator</Value>
</Value>
<Value name="10">
<Value>OperatorDate</Value>
</Value>
<Value name="11">
<Value>ReasonSn</Value>
</Value>
<Value name="12">
<Value>RegisterDate</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
<Value name="14">
<Value>InOrOut</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonChangeRecordD</DataLocation>
<DefaultData>PersonChangeRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonChangeRecordD</IdLocation>
<IndexLocation>^CHSS.PersonChangeRecordI</IndexLocation>
<StreamLocation>^CHSS.PersonChangeRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
