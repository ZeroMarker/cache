/// d ##class(DHCWL.DM.T.DataType).%BuildIndices($lb("JTCNI"))
Class DHCWL.DM.T.DataType Extends %Persistent
{

// 只能由字母,数字或者下划线组成，且必须是字母开头

Property Code As %String [ Required ];

Property Name As %String;

Property Description As %String;

Property JDBCTypeCodeNum As %Integer [ Required ];

Index MainI On Code [ PrimaryKey ];

Index JTCNI On JDBCTypeCodeNum;

// d ##class(DHCWL.DM.T.DataType).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.DataType)
	k ^DHCWL.DM.T.DataTypeD,^DHCWL.DM.T.DataTypeI
	&sql(insert into DHCWL_DM_T.DataType(Code,Name,Description,JDBCTypeCodeNum) values('string','字符串','可变长字符串类型',12))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.DataType(Code,Name,Description,JDBCTypeCodeNum) values('INTEGER','整数值','4字节长度的整数值',4))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.DataType(Code,Name,Description,JDBCTypeCodeNum) values('DOUBLE','浮点数','8字节长度的浮点数',8))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.DataType(Code,Name,Description,JDBCTypeCodeNum) values('DATE','日期','日期，包含年月日',91))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.DataType(Code,Name,Description,JDBCTypeCodeNum) values('TIME','时间','时间，包含时分秒',92))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.DataType(Code,Name,Description,JDBCTypeCodeNum) values('VARCHAR','字符串','可变长字符串类型',12))
	w %ROWID,","
}

// s obj=##class(DHCWL.DM.T.DataType).GetByCode("string")

ClassMethod GetByPath(code) As DataType
{
	q ##class(DataType).%OpenId(..GetIdByPath(code))
}

ClassMethod GetIdByPath(code) As DataType
{
	q:code=""
	s code=$p(code,"(",1)
	s code=$zcvt(code,"U")
	q:'$d(^DHCWL.DM.T.DataTypeI("MainI"," "_code)) ""
	q $o(^DHCWL.DM.T.DataTypeI("MainI"," "_code,""))
}

ClassMethod GetByJDBCTypeCode(jdbcTypeCode) As DataType
{
	q:(jdbcTypeCode="")||('$d(^DHCWL.DM.T.DataTypeI("JTCNI",jdbcTypeCode))) ""
	s id=$o(^DHCWL.DM.T.DataTypeI("JTCNI",jdbcTypeCode,""))
	q ##class(DataType).%OpenId(id)
}

ClassMethod Upasert(typeName, dateType) As %Status
{
	s status=$$$OK
	s typeName=$p($p(typeName,"(",1)," ",1)
	s tn=" "_$zcvt(typeName,"U")
	if $d(^DHCWL.DM.T.DataTypeI("MainI",tn)) d
	.s id=$o(^DHCWL.DM.T.DataTypeI("MainI",tn,""))
	.&sql(UPDATE DHCWL_DM_T.DataType SET JDBCTypeCodeNum=:dateType where ID=:id)
	.s:SQLCODE'=0 status=$$$ERROR("SQLCODE:"_SQLCODE)
	e  d
	.&sql(INSERT INTO DHCWL_DM_T.DataType(Code,JDBCTypeCodeNum) VALUES (:typeName,:dateType) )
	.s:SQLCODE'=0 status=$$$ERROR("SQLCODE:"_SQLCODE)
	q status
}

Storage Default
{
<Data name="DataTypeDefaultData">
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
<Value>Description</Value>
</Value>
<Value name="5">
<Value>JDBCTypeCodeNum</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.DataTypeD</DataLocation>
<DefaultData>DataTypeDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.DataTypeD</IdLocation>
<IndexLocation>^DHCWL.DM.T.DataTypeI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.DataTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
