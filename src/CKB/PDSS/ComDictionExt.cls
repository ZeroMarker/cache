Class CKB.PDSS.ComDictionExt Extends (%Persistent, User.Abstract) [ SqlRowIdName = CDExt_RowID, SqlTableName = ComDictionExt ]
{

/// 安全用药码表的扩展表-- 暂时用于码表重新编码,将编码和码表对应存储
/// D ##class(CKB.PDSS.ComDictionExt).%BuildIndices()
Property CDExtIdentity As %String [ SqlColumnNumber = 2, SqlFieldName = CDExt_Identity ];

Property CDExtCDDr As %String [ SqlColumnNumber = 3, SqlFieldName = CDExt_CD_Dr ];

Storage Default
{
<Data name="ComDictionExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CDExtIdentity</Value>
</Value>
<Value name="3">
<Value>CDExtCDDr</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.ComDictionExtD</DataLocation>
<DefaultData>ComDictionExtDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.ComDictionExtD</IdLocation>
<IndexLocation>^CKB.PDSS.ComDictionExtI</IndexLocation>
<StreamLocation>^CKB.PDSS.ComDictionExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexDicID On (CDExtCDDr As Exact, CDExtIdentity As Exact);

}
