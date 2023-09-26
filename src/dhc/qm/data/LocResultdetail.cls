Class dhc.qm.data.LocResultdetail Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LocResultdetail_rowid, SqlTableName = LocResultdetail ]
{

/// LocResultdetail_parRef
Property LocResultdetailparRef As dhc.qm.data.LocResultMain [ SqlColumnNumber = 2, SqlFieldName = LocResultdetail_parRef ];

/// LocResultdetail_sDetailDr
Property LocResultdetailsDetailDr As dhc.qm.data.QMSchemDetail [ SqlColumnNumber = 3, SqlFieldName = LocResultdetail_sDetailDr ];

/// LocResultdetail_JXPatDr
Property LocResultdetailJXPatDr As dhc.qm.data.JXPat [ SqlColumnNumber = 4, SqlFieldName = LocResultdetail_JXPatDr ];

/// LocResultdetail_checkDr
Property LocResultdetailcheckDr As dhc.qm.data.Check [ SqlColumnNumber = 5, SqlFieldName = LocResultdetail_checkDr ];

/// LocResultdetail_rate
Property LocResultdetailrate As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = LocResultdetail_rate ];

/// LocResultdetail_actValue
Property LocResultdetailactValue As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = LocResultdetail_actValue ];

/// LocResultdetail_txtValue
Property LocResultdetailtxtValue As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = LocResultdetail_txtValue ];

/// LocResultdetail_PicLink
Property LocResultdetailPicLink As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = LocResultdetail_PicLink ];

/// LocResultdetail_saveUserDr
Property LocResultdetailsaveUserDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = LocResultdetail_saveUserDr ];

/// LocResultdetail_saveDate
Property LocResultdetailsaveDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = LocResultdetail_saveDate ];

/// LocResultdetail_exdepartDr
Property LocResultdetailexdepartDr As User.RBCDepartmentGroup [ SqlColumnNumber = 12, SqlFieldName = LocResultdetail_exdepartDr ];

/// LocResultdetail_disqua
Property LocResultdetaildisqua As %Library.Integer [ SqlColumnNumber = 13, SqlFieldName = LocResultdetail_disqua ];

/// LocResultdetail_saveStatus 0：选择 1：保存 
Property LocResultMainauditState As %Library.Integer [ SqlColumnNumber = 14, SqlFieldName = LocResultdetail_saveStatus ];

Index CheckDr On LocResultdetailcheckDr;

Index JXPatDr On LocResultdetailJXPatDr;

Index LocResultMain On LocResultdetailparRef;

Index QMLRMCheckDr On (LocResultdetailparRef, LocResultdetailcheckDr);

Index QMLRMPatCheckDr On (LocResultdetailparRef, LocResultdetailJXPatDr, LocResultdetailcheckDr);

Storage Default
{
<Data name="LocResultdetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocResultdetailparRef</Value>
</Value>
<Value name="3">
<Value>LocResultdetailsDetailDr</Value>
</Value>
<Value name="4">
<Value>LocResultdetailJXPatDr</Value>
</Value>
<Value name="5">
<Value>LocResultdetailcheckDr</Value>
</Value>
<Value name="6">
<Value>LocResultdetailrate</Value>
</Value>
<Value name="7">
<Value>LocResultdetailactValue</Value>
</Value>
<Value name="8">
<Value>LocResultdetailtxtValue</Value>
</Value>
<Value name="9">
<Value>LocResultdetailPicLink</Value>
</Value>
<Value name="10">
<Value>LocResultdetailsaveUserDr</Value>
</Value>
<Value name="11">
<Value>LocResultdetailsaveDate</Value>
</Value>
<Value name="12">
<Value>LocResultdetailexdepartDr</Value>
</Value>
<Value name="13">
<Value>LocResultdetaildisqua</Value>
</Value>
<Value name="14">
<Value>LocResultMainauditState</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMLocResultdetailD</DataLocation>
<DefaultData>LocResultdetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMLocResultdetailD</IdLocation>
<IndexLocation>^DHCCJXQMLocResultdetailI</IndexLocation>
<StreamLocation>^DHCCJXQMLocResultdetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
