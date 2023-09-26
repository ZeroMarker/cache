Class EPRservice.tool.BaseData.EPRMessageBaseData Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##Class(EPRservice.tool.BaseData.EPRMessageBaseData).Init()
ClassMethod Init()
{
	d ..InitEPRMessageType()
	d ..InitEPRMessageSource()
}

/// Debug: d ##Class(EPRservice.tool.BaseData.EPRMessageBaseData).InitEPRMessageType()
ClassMethod InitEPRMessageType()
{
	s sc = $$InitOneEPRMessageType("SEND","发送消息","1")
	s sc = $$InitOneEPRMessageType("SENDALL","发送群组消息","1")
	s sc = $$InitOneEPRMessageType("READ","已读","1")
	s sc = $$InitOneEPRMessageType("REPLY","回复","1")
	s sc = $$InitOneEPRMessageType("REPLYALL","回复整个群组","1")
	s sc = $$InitOneEPRMessageType("DONEWORK","已完成","1")
	
InitOneEPRMessageType(argActionCode, argActionName, argIsActive)
	s rowid = ""
	&sql(select ID into :rowid from EPRmeta.EPRMessageType
		where ActionCode = :argActionCode)
	
	if rowid = ""
	{
		&sql(insert into EPRmeta.EPRMessageType (ActionCode, ActionName, IsActive) 
			values (:argActionCode, :argActionName, :argIsActive))
	}
	
	q "1"
}

/// Debug: d ##Class(EPRservice.tool.BaseData.EPRMessageBaseData).InitEPRMessageSource()
ClassMethod InitEPRMessageSource()
{
	s sc = $$InitOneEPRMessageSource("QUALITY","电子病历质控","1")
	
InitOneEPRMessageSource(argActionCode, argActionName, argIsActive)
	s rowid = ""
	&sql(select ID into :rowid from EPRmeta.EPRMessageSource
		where ActionCode = :argActionCode)
	
	if rowid = ""
	{
		&sql(insert into EPRmeta.EPRMessageSource (ActionCode, ActionName, IsActive) 
			values (:argActionCode, :argActionName, :argIsActive))
	}
	
	q "1"
}

}
