/// ************************************************************
/// *  类名称	: EPRmeta.EPRActStatusCfg
/// *  描述 : 存储操作和状态的对应关系，用于判断处于某状态的病历能否执行某操作，以及由前状态和操作得到后状态
/// *  编写者： gaojb
/// *  编写日期	  : 2009-7-22
/// ************************************************************/
Class EPRmeta.EPRActStatusCfg Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 操作Code(EPRmeta.EPRAction)
Property EPRAction As %String(TRUNCATE = 1);

/// 操作前状态Code(EPRmeta.EPRStatus)
Property PreStatus As %String(TRUNCATE = 1);

/// 操作后状态Code(EPRmeta.EPRStatus)
Property PostStatus As %String(TRUNCATE = 1);

Index IdxUnique On (PreStatus, EPRAction) [ Unique ];

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Action:%String,PreStatus:%String,PostStatus:%String")
{
		SELECT ID,EPRAction,PreStatus,PostStatus
		FROM EPRmeta.EPRActStatusCfg
		ORDER BY ID
}

Query SelectByAction(parAction As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Action:%String,PreStatus:%String,PostStatus:%String")
{
		SELECT ID,EPRAction,PreStatus,PostStatus
		FROM EPRmeta.EPRActStatusCfg
		WHERE EPRAction like :parName
		ORDER BY ID
}

/// Function:    IsActionValid
/// Description: 判断在某状态下的病历是否能够执行某操作
/// Input:       parPreStatus：操作前状态, parAction：需要判断的操作
/// Return:      0--不能执行操作, 1--能执行操作
/// Others:      usage: w ##class(EPRmeta.EPRActStatusCfg).IsActionValid("unfinished","save")--1
ClassMethod IsActionValid(parPreStatus As %String, parAction As %String) As %String
{
	k SQLCODE
	s count=0
	&sql(select count(*) into :count from EPRmeta.EPRActStatusCfg
	     where PreStatus=:parPreStatus and EPRAction=:parAction)
	q count
}

/// Function:    GetPostStatus
/// Description: 由操作前状态和操作得到操作后状态
/// Input:       parPreStatus：操作前状态, parAction：执行的操作
/// Return:      操作后状态代码
/// Others:      usage: w ##class(EPRmeta.EPRActStatusCfg).GetPostStatus("unfinished","save")--unfinished
ClassMethod GetPostStatus(parPreStatus As %String, parAction As %String) As %String
{
	k SQLCODE
	s status=""
	&sql(select PostStatus into :status from EPRmeta.EPRActStatusCfg
	     where PreStatus=:parPreStatus and EPRAction=:parAction)
	q status
}

Storage Default
{
<Data name="EPRActStatusCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPRAction</Value>
</Value>
<Value name="3">
<Value>PostStatus</Value>
</Value>
<Value name="4">
<Value>PreStatus</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.EPRActStatusCfgD</DataLocation>
<DefaultData>EPRActStatusCfgDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.EPRActStatusCfgD</IdLocation>
<IndexLocation>^DHCEPRM.EPRActStatusCfgI</IndexLocation>
<StreamLocation>^DHCEPRM.EPRActStatusCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
