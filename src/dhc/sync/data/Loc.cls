Class dhc.sync.data.Loc Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, SqlRowIdName = Rowid, SqlTableName = Sync_Loc ]
{

//Rowid Code Name LocLevel Super State IsLast

//科室类型 科室部门组 分类  物理位置 电话  助记码  启用时间 停用时间 楼层 目录 科室 扩展1 扩展2 扩展3

//　　Type DGroup Classify Address Phone Mnemonics StartDate EndDate Storey Catalogue Dept Code1 Code2 Code3

Property Code As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Code ];

Property Name As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Name ];

Property LocLevel As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LocLevel ];

//上级科室

Property Super As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Super ];

//1:有效 2：无效

Property State As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = State ];

//是否是最小科室

Property IsLast As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = IsLast ];

Property Type As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Type ];

//科室组

Property DGroup As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DGroup ];

//分类

Property Classify As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Classify ];

Property Address As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Address ];

Property Phone As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = Phone ];

//助记码

Property Mnemonics As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = Mnemonics ];

Property StartDate As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = StartDate ];

Property EndDate As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = EndDate ];

//楼层

Property Storey As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = Storey ];

//是否是目录

Property Catalogue As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = Catalogue ];

//是否是科室

Property Dept As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = Dept ];

Property Code0 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = Code0 ];

Property Code1 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = Code1 ];

Property Code2 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = Code2 ];

Property Code3 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = Code3 ];

/// 分院代码
Property HospCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = HospCode ];

Index syncLocIdx On Code [ Unique ];

Index syncLocNameIdx On (Name, Dept);

Storage Default
{
<Data name="LocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>LocLevel</Value>
</Value>
<Value name="5">
<Value>Super</Value>
</Value>
<Value name="6">
<Value>State</Value>
</Value>
<Value name="7">
<Value>IsLast</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>DGroup</Value>
</Value>
<Value name="10">
<Value>Classify</Value>
</Value>
<Value name="11">
<Value>Address</Value>
</Value>
<Value name="12">
<Value>Phone</Value>
</Value>
<Value name="13">
<Value>Mnemonics</Value>
</Value>
<Value name="14">
<Value>StartDate</Value>
</Value>
<Value name="15">
<Value>EndDate</Value>
</Value>
<Value name="16">
<Value>Storey</Value>
</Value>
<Value name="17">
<Value>Catalogue</Value>
</Value>
<Value name="18">
<Value>Dept</Value>
</Value>
<Value name="19">
<Value>Code1</Value>
</Value>
<Value name="20">
<Value>Code2</Value>
</Value>
<Value name="21">
<Value>Code3</Value>
</Value>
<Value name="22">
<Value>Code0</Value>
</Value>
<Value name="23">
<Value>HospCode</Value>
</Value>
</Data>
<DataLocation>^dhcsyncLocD</DataLocation>
<DefaultData>LocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcsyncLocD</IdLocation>
<IndexLocation>^dhcsyncLocI</IndexLocation>
<StreamLocation>^dhcsyncLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
