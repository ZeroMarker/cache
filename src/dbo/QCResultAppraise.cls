///     
Class dbo.QCResultAppraise Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_ResultAppraise, StorageStrategy = Default ]
{

/// Foreign Key FKResultAppraiseAddUser created via DDL
ForeignKey FKResultAppraiseAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_ResultAppraiseAddUser ];

/// Foreign Key FKResultAppraiseLot created via DDL
ForeignKey FKResultAppraiseLot(MaterialLotDR) References dbo.BTQCMaterialLot(PKBTQCMATERIALLOT) [ SqlName = FK_ResultAppraiseLot ];

/// Foreign Key FKResultAppraiseTestCode created via DDL
ForeignKey FKResultAppraiseTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_ResultAppraiseTestCode ];

/// Foreign Key FKResultAppraiseUser created via DDL
ForeignKey FKResultAppraiseUser(AppraiseUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_ResultAppraiseUser ];

Index IndexAddDate On (MaterialLotDR, TestCodeDR, LevelNo, AddDate) [ SqlName = Index_AddDate, Type = index ];

Index IndexAppUser On (AppraiseUserDR, AppraiseDate) [ SqlName = Index_AppUser, Type = index ];

Index IndexMaster On (MaterialLotDR, TestCodeDR, AppraiseDate, AppraiseTime, LevelNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexUser On (AddUserDR, AddDate) [ SqlName = Index_User, Type = index ];

/// DDL Primary Key Specification
Index PKQCRESULTAPPRAISE On RowID [ PrimaryKey, SqlName = PK_QC_RESULTAPPRAISE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialLotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property LevelNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property AppraiseDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AppraiseTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AppraiseUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 9 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property Reported As %Library.Boolean [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="QCResultAppraiseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialLotDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>AppraiseDate</Value>
</Value>
<Value name="6">
<Value>AppraiseTime</Value>
</Value>
<Value name="7">
<Value>AppraiseUserDR</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>AddDate</Value>
</Value>
<Value name="10">
<Value>AddTime</Value>
</Value>
<Value name="11">
<Value>AddUserDR</Value>
</Value>
<Value name="12">
<Value>Reported</Value>
</Value>
</Data>
<DataLocation>^dbo.QCResultAppraiseD</DataLocation>
<DefaultData>QCResultAppraiseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.QCResultAppraiseD</IdLocation>
<IndexLocation>^dbo.QCResultAppraiseI</IndexLocation>
<StreamLocation>^dbo.QCResultAppraiseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
