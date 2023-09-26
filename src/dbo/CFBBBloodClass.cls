Class dbo.CFBBBloodClass Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = CFBB_BloodClass, StorageStrategy = Default ]
{

/// Foreign Key FKAGAssessTypeHospital created via DDL
ForeignKey FKCFBBBCBloodClass(BloodClassDR) References dbo.BBBloodClass(PKBBBLOODCLASS) [ SqlName = FK_CFBB_BC_BloodClass ];

/// Foreign Key FKAGAssessTypeHospital created via DDL
ForeignKey FKCFBBBCHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_CFBB_BC_Hospital ];

/// Foreign Key FKAGAssessTypeHospital created via DDL
ForeignKey FKCFBBBCBloodGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_CFBB_BC_BloodGroup ];

Index IndexMaster On (BloodClassDR, HospitalDR, BloodGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKCFBBBLOODPRODUCT On RowID [ PrimaryKey, SqlName = PK_CFBB_BLOODCLASS, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血液分类  
Property BloodClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 医院
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 血型组  
Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 一级预警量 红
Property LevelOne As %Library.Float [ SqlColumnNumber = 6 ];

/// 二级预警量 橙
Property LevelTwo As %Library.Float [ SqlColumnNumber = 7 ];

/// 三级预警量 黄
Property LevelThree As %Library.Float [ SqlColumnNumber = 8 ];

/// 预警天数
Property Days As %Library.TinyInt [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="CFBBBloodClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodClassDR</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
<Value name="4">
<Value>BloodGroupDR</Value>
</Value>
<Value name="5">
<Value>LevelOne</Value>
</Value>
<Value name="6">
<Value>LevelTwo</Value>
</Value>
<Value name="7">
<Value>LevelThree</Value>
</Value>
<Value name="8">
<Value>Days</Value>
</Value>
</Data>
<DataLocation>^dbo.CFBBBloodClassD</DataLocation>
<DefaultData>CFBBBloodClassDefaultData</DefaultData>
<IdLocation>^dbo.CFBBBloodClassD</IdLocation>
<IndexLocation>^dbo.CFBBBloodClassI</IndexLocation>
<StreamLocation>^dbo.CFBBBloodClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
