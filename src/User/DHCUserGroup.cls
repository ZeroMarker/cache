Class User.DHCUserGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCUserGroup ]
{

Index UserNamedr On UsegUsername As String;

/// 排班权限医生
Property UsegDoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = UsegDoc ];

/// UsegFlag
Property UsegFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = UsegFlag ];

/// 排班权限科室
Property UsegUsergroup As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = UsegUsergroup ];

/// 排班人员
Property UsegUsername As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = UsegUsername ];

/// 排班权限类型(RegUser排班权限管理,Nurse护士加号权限管理)
Property UsegType As %String(DISPLAYLIST = ",RegUser,Nurse", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",REG,NUR") [ SqlColumnNumber = 6, SqlFieldName = UsegType ];

Index UserLocDoc On (UsegType, UsegUsername, UsegUsergroup, UsegDoc);

Storage Default
{
<Data name="DHCUserGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UsegDoc</Value>
</Value>
<Value name="3">
<Value>UsegFlag</Value>
</Value>
<Value name="4">
<Value>UsegUsergroup</Value>
</Value>
<Value name="5">
<Value>UsegUsername</Value>
</Value>
<Value name="6">
<Value>UsegType</Value>
</Value>
</Data>
<DataLocation>^User.DHCUserGroupD</DataLocation>
<DefaultData>DHCUserGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCUserGroupD</IdLocation>
<IndexLocation>^User.DHCUserGroupI</IndexLocation>
<StreamLocation>^User.DHCUserGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
