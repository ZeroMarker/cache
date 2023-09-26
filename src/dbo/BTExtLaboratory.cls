Class dbo.BTExtLaboratory Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_ExtLaboratory, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKTestCodeHospital created via DDL
ForeignKey FKExtLaboratoryHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_ExtLaboratoryHospital ];

/// DDL Primary Key Specification
Index PKBTEXTLABORATORY On RowID [ PrimaryKey, SqlName = PK_BT_EXTLABORATORY, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// 全称  
Property LName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 联系人  
Property LinkMan As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

/// 序号  
Property OfficeTel As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 序号  
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 9 ];

/// 序号  
Property PostNo As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 10 ];

/// 序号  
Property Email As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 序号  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BTExtLaboratoryDefaultData">
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
<Value>LName</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>LinkMan</Value>
</Value>
<Value name="7">
<Value>OfficeTel</Value>
</Value>
<Value name="8">
<Value>Address</Value>
</Value>
<Value name="9">
<Value>PostNo</Value>
</Value>
<Value name="10">
<Value>Email</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>Sequence</Value>
</Value>
<Value name="13">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTExtLaboratoryD</DataLocation>
<DefaultData>BTExtLaboratoryDefaultData</DefaultData>
<IdLocation>^dbo.BTExtLaboratoryD</IdLocation>
<IndexLocation>^dbo.BTExtLaboratoryI</IndexLocation>
<StreamLocation>^dbo.BTExtLaboratoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
