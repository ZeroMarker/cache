Class CHSS.FamilyChangeRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = FRM_CHA_RECORD_SN, SqlTableName = FamilyChangeRecord ]
{

/// 家庭档案主键	
Property FamilyRowId As CHSS.FamilyHealthRecord [ Required ];

/// 原因编码	
Property FrmChangeSn As CHSS.DictChangeReason;

/// 原家庭编号
Property OrgFrmCode As %String(MAXLEN = 20, TRUNCATE = 1);

/// 现家庭编号
Property CurFrmCode As %String(MAXLEN = 20, TRUNCATE = 1);

/// 原管辖单位
Property OrgCommunity As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现管辖单位
Property CurCommunity As %String(MAXLEN = 100, TRUNCATE = 1);

/// 原住址
Property OrgAdd As %String(MAXLEN = 50, TRUNCATE = 1);

/// 现住址
Property CurAdd As %String(MAXLEN = 50, TRUNCATE = 1);

/// 操作员	
Property Operator As User.SSUser;

/// 变更日期	
Property OperatorDate As %Date(FORMAT = 1);

/// 登记日期	
Property RegisterDate As %Date(FORMAT = 1);

/// 备注	
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 迁入 还是迁出 
Property InOrOut As %String(MAXLEN = 10, TRUNCATE = 1);

Index FamilyRowIdIndex On FamilyRowId;

Storage Default
{
<Data name="FamilyChangeRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CurAdd</Value>
</Value>
<Value name="3">
<Value>CurCommunity</Value>
</Value>
<Value name="4">
<Value>CurFrmCode</Value>
</Value>
<Value name="5">
<Value>FamilyRowId</Value>
</Value>
<Value name="6">
<Value>FrmChangeSn</Value>
</Value>
<Value name="7">
<Value>InOrOut</Value>
</Value>
<Value name="8">
<Value>Operator</Value>
</Value>
<Value name="9">
<Value>OperatorDate</Value>
</Value>
<Value name="10">
<Value>OrgAdd</Value>
</Value>
<Value name="11">
<Value>OrgCommunity</Value>
</Value>
<Value name="12">
<Value>OrgFrmCode</Value>
</Value>
<Value name="13">
<Value>RegisterDate</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^CHSS.FamilyChangeRecordD</DataLocation>
<DefaultData>FamilyChangeRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.FamilyChangeRecordD</IdLocation>
<IndexLocation>^CHSS.FamilyChangeRecordI</IndexLocation>
<StreamLocation>^CHSS.FamilyChangeRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
