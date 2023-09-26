Class EPRmeta.EPRStatus Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property StatusCode As %String(TRUNCATE = 1);

Property StatusName As %String(TRUNCATE = 1);

Index IdxStatusCode On StatusCode [ Unique ];

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,StatusCode:%String,StatusName:%String")
{
		SELECT ID,StatusCode,StatusName
		FROM EPRmeta.EPRStatus
		ORDER BY ID
}

Query SelectByStatusName(parStatusName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,StatusCode:%String,StatusName:%String")
{
		SELECT ID,StatusCode,StatusName
		FROM EPRmeta.EPRStatus
		WHERE StatusName like :parName
		ORDER BY ID
}

/// Function:    StatusCodeValid
/// Description: 验证状态Code是否在表中，用于避免在日志中加入不合法的状态Code
/// Input:       parActionCode: 需要验证的操作code
/// Return:      0-非法/1-合法
/// Others:      
ClassMethod StatusCodeValid(parStatusCode As %String) As %String
{
	s valid=0
	&sql(select count(*) into :valid from EPRmeta.EPRStatus
		WHERE StatusCode = :parStatusCode)
	q valid
}

Storage Default
{
<Data name="EPRStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StatusCode</Value>
</Value>
<Value name="3">
<Value>StatusName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.EPRStatusD</DataLocation>
<DefaultData>EPRStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.EPRStatusD</IdLocation>
<IndexLocation>^DHCEPRM.EPRStatusI</IndexLocation>
<StreamLocation>^DHCEPRM.EPRStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
