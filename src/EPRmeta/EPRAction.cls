/// ************************************************************
/// *  类名称	: EPRmeta.EPRAction
/// *  描述 :  病历操作字典及相关操作
/// *  编写者： gaojb
/// *  编写日期	  : 2009-7-22
/// ************************************************************/
Class EPRmeta.EPRAction Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ActionCode As %String(TRUNCATE = 1);

Property ActionName As %String(TRUNCATE = 1);

Index IdxActionCode On ActionCode [ Unique ];

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,ActionCode:%String,ActionName:%String")
{
		SELECT ID,ActionCode,ActionName
		FROM EPRmeta.EPRAction
		ORDER BY ID
}

Query SelectByActionName(parActionName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,ActionCode:%String,ActionName:%String")
{
		SELECT ID,ActionCode,ActionName
		FROM EPRmeta.EPRAction
		WHERE ActionName like :parName
		ORDER BY ID
}

/// Function:    ActionCodeValid
/// Description: 验证操作Code是否在表中，用于避免在日志中加入不合法的操作Code
/// Input:       parActionCode: 需要验证的操作code
/// Return:      0-非法/1-合法
/// Others:      
ClassMethod ActionCodeValid(parActionCode As %String) As %String
{
	s valid=0
	&sql(select count(*) into :valid from EPRmeta.EPRAction
		WHERE ActionCode = :parActionCode)
	q valid
}

/// Function:    GetSaveType
/// Description: 根据parEpisodeID、parEPRStructID和parTemplateID判断当前操作是save还是complete
/// Input:       parEpisodeID, parEPRStructID：打印模板在病历结构表中的ID, parTemplateID: 打印模板下的界面模板ID
/// Return:      1 所有必填界面模板都已保存
/// 			 0 有部分必填界面模板未保存
/// 			 -1 所有界面模板都未保存
/// Others:      
ClassMethod GetSaveType(parEpisodeID As %String, parEPRStructID As %String) As %String
{
	s status = ""
	//s status = ##class(EPRservice.EPRDoc.BODocsInGroup).CheckAllNecessaryDocReady(parEpisodeID, parEPRStructID)	
	//q:(status = "Y") 1
	s status = ##class(EPRservice.EPRDoc.BODocsInGroup).IsAllNecessaryDocReady(parEpisodeID, parEPRStructID)	
	q:(status = "1") 1
	
	q status
}

Storage Default
{
<Data name="EPRActionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>ActionName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.EPRActionD</DataLocation>
<DefaultData>EPRActionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.EPRActionD</IdLocation>
<IndexLocation>^DHCEPRM.EPRActionI</IndexLocation>
<StreamLocation>^DHCEPRM.EPRActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
