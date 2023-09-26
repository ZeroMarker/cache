/// 单病种指标用血汇总
Class dbo.BSBldTargetTrans Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlTableName = BS_BldTargetTrans ]
{

/// Foreign Key created via DDL
ForeignKey FKTAT(BSBldTargetDR) References dbo.BSBldTarget(PKBSBldTargetId) [ SqlName = FK_BSBldTargetDR ];

Index IndexMaster On (BSBldTargetDR, BloodCompontDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BSBldTargetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

///  血液品种
Property BloodCompontDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

///  血液制品
Property Volume As %Library.Float(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BSBldTargetTransDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSBldTargetDR</Value>
</Value>
<Value name="3">
<Value>BloodCompontDR</Value>
</Value>
<Value name="4">
<Value>Volume</Value>
</Value>
</Data>
<DataLocation>^dbo.BSBldTargetTransD</DataLocation>
<DefaultData>BSBldTargetTransDefaultData</DefaultData>
<IdLocation>^dbo.BSBldTargetTransD</IdLocation>
<IndexLocation>^dbo.BSBldTargetTransI</IndexLocation>
<StreamLocation>^dbo.BSBldTargetTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
