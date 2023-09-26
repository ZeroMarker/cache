///     
Class dbo.BBBloodProductMedicalFee Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodProductMedicalFee, StorageStrategy = Default ]
{

/// Foreign Key FKProductMedicalFeeBloodProductFee created via DDL
ForeignKey FKProductMedicalFeeBloodProductFee(BloodProductFeeDR) References dbo.BBBloodProductFee(PKBBBLOODPRODUCTFEE) [ SqlName = FK_ProductMedicalFee_BloodProductFee ];

/// DDL Primary Key Specification
Index IndexProductMedicalFee On BloodProductFeeDR [ SqlName = Index_ProductMedicalFee, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBBloodProductMedicalFee On RowID [ PrimaryKey, SqlName = PK_BB_BloodProductMedicalFee, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodProductFeeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property MedicalFlag As %Library.Boolean [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BBBloodProductMedicalFeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>BloodProductFeeDR</Value>
</Value>
<Value name="4">
<Value>MedicalFlag</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodProductMedicalFeeD</DataLocation>
<DefaultData>BBBloodProductMedicalFeeDefaultData</DefaultData>
<IdLocation>^dbo.BBBloodProductMedicalFeeD</IdLocation>
<IndexLocation>^dbo.BBBloodProductMedicalFeeI</IndexLocation>
<StreamLocation>^dbo.BBBloodProductMedicalFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
