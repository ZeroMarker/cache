Class User.DKBTreeBase Extends %Persistent [ SqlTableName = DKB_TreeBase ]
{

Property DKBTBCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1);

Property DKBTBDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1);

/// 父分类
Property DKBTBLastLevel As User.DKBTreeBase;

/// 等级 可以使用1,2,3等字符定义，使用Ascii码来标识大小
Property DKBTBLevel As %String;

Property DKBTBBCDR As User.DKBBaseCat;

Property DKBTBRemark As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1);

Property DKBTBActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

Property DKBTBExtend As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1);

Index CodeIndex On (DKBTBBCDR, DKBTBCode);

Index DescIndex On (DKBTBBCDR, DKBTBDesc);

Index BaseCatIdx On DKBTBBCDR;

Index ParCatIdx On DKBTBLastLevel;

/// 父菜单+顺序生成的索引
Index ParSeqIdx On (DKBTBLastLevel, DKBTBLevel);

/// 子术语库大类+父菜单生成的索引
Index CatParIdx On (DKBTBBCDR, DKBTBLastLevel);

Storage Default
{
<Data name="DKBTreeBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DKBTBCode</Value>
</Value>
<Value name="3">
<Value>DKBTBDesc</Value>
</Value>
<Value name="4">
<Value>DKBTBLastLevel</Value>
</Value>
<Value name="5">
<Value>DKBTBLevel</Value>
</Value>
<Value name="6">
<Value>DKBTBBCDR</Value>
</Value>
<Value name="7">
<Value>DKBTBRemark</Value>
</Value>
<Value name="8">
<Value>DKBTBActiveFlag</Value>
</Value>
<Value name="9">
<Value>DKBTBExtend</Value>
</Value>
</Data>
<DataLocation>^User.DKBTreeBaseD</DataLocation>
<DefaultData>DKBTreeBaseDefaultData</DefaultData>
<IdLocation>^User.DKBTreeBaseD</IdLocation>
<IndexLocation>^User.DKBTreeBaseI</IndexLocation>
<StreamLocation>^User.DKBTreeBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
