Class dbo.BTTATTimeTSGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATTimeTSGroup ]
{

Index IndexMaster On (HospitalDR, GroupType, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (HospitalDR, GroupType, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTTATTimeTSGroupHospitalDR created via DDL
ForeignKey FKBTTATTimeTSGroupHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTTATTimeTSGroupHospitalDR ];

/// DDL Primary Key BTTATTimeTSGroup
Index PKBTTATTIMETSGROUP On RowID [ PrimaryKey, SqlName = PK_BT_TATTIMETSGROUP, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

/// 状态 {1：送检，2：分拣，3：审核，4：取报告提示}
Property GroupType As %Library.TinyInt [ Required, SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTTATTimeTSGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>GroupType</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTATTimeTSGroupD</DataLocation>
<DefaultData>BTTATTimeTSGroupDefaultData</DefaultData>
<IdLocation>^dbo.BTTATTimeTSGroupD</IdLocation>
<IndexLocation>^dbo.BTTATTimeTSGroupI</IndexLocation>
<StreamLocation>^dbo.BTTATTimeTSGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
