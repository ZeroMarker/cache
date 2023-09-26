/// 名称：		EMR.OP.BL.BLDocumentRule
/// 描述：		文档规则业务逻辑类
/// 编写者：	huhao
/// 编写时间：	2021-12-9
Class EMR.OP.BL.BLDocumentRule Extends EMR.OP.COM.ActionBase
{

/// Creator:	huhao
/// CreatDate:  获取文档规则列表(网页
/// Desc:		
/// Input：		2021-12-13
/// Return：	失败：0，成功：1
ClassMethod GetRuleList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##class(EMR.OP.BL.BLDocumentRule).GetList(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查询到内容",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetList(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s countc=""
	&sql(select count(*) into countc from CF_EMR_DOC.DocRuleList)
	s resJson=##class(%DynamicArray).%New()
	for i=1:1:countc
	{
		s resObj=##class(%DynamicObject).%New()
		s obj = ##Class(CF.EMR.DOC.DocRuleList).%OpenId(i)
		s resObj.key=i
		s resObj.DocName=obj.DocName
		s resObj.DocRule=obj.DocRule
		s resObj.DocType=..GetRuleContent(obj.DocType)
		s resObj.Pathol=obj.Pathol
		d resJson.%Push(resObj)		
	}
	d resJson.%ToJSON(argOutData)
	q "1"
}

/// Creator:	huhao
/// CreatDate:  根据文档规则编码获取文档规则内容
/// Desc:		
/// Input：		2021-12-13
/// Return：	失败：0，成功：1
ClassMethod GetRuleContent(DocRule As %String) As %String
{
	s rules=..QueryTable(DocRule)
	s lastres=""
	while rules.%Next()
	{
		s strRule=rules.GetDataByName("Grop")
		s count=$LENGTH(strRule,"^")
		s res=""
		for i=1:1:count
		{	
			s ds="",tbName="",rowId="",descContent=""
			s rule=$Piece(strRule,"^",i)
			s rulecode=$Piece(rule,":",1)
			s ruledesc=$Piece(rule,":",2)
		
			&sql(select Description into :ds from CF_EMR_DOC.StdDictionary where Code=:rulecode)
			&sql(select TableName into :tbName from CF_EMR_DOC.StdDictionary where Code=:rulecode)
			&sql(select DicCodeCol into :rowId from CF_EMR_DOC.StdDictionary where Code=:rulecode)
			&sql(select DicDescCol into :descContent from CF_EMR_DOC.StdDictionary where Code=:rulecode)
			s data=..QueryDynTable(tbName,ruledesc,rowId,descContent)
			while data.%Next()
			{
				s A=data.GetDataByName(descContent)
			}
			s result=ds_"."_A
			if (res'="")
			{
				s res=result_" + "_res
			}
			else {s res=result}
		}
		s lastres=lastres_" "_res
	}
	q lastres
}

ClassMethod QueryTable(RuleType As %String) As %XML.DataSet
{
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
 	s sql= "select Grop from CF_EMR_DOC.CodeGroup WHERE Code="_RuleType_"AND Status='1'"
	s status=dataset.Prepare(sql)
	d dataset.Execute()
	if $$$ISERR(status) { q "" }
    q dataset
}

ClassMethod QueryDynTable(TableName As %String, rulecode As %String, rowId As %String, desc As %String) As %XML.DataSet
{
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
 	s sql = "select "_desc_" from "_TableName_" where "_rowId_"='"_rulecode_"'"
	s status=dataset.Prepare(sql)
	d dataset.Execute()
	if $$$ISERR(status) { q "" }
    q dataset
}

/// Desc:       获取已添加字典规则列表(弹层
/// Creator:    huhao
/// CreateDate: 2020-12-10
/// Input:      
/// OutPut:     argOutData 返回数据
ClassMethod GetModalList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s code=argInJson.params.code
    s strRes = ##Class(EMR.OP.BL.BLDocumentRule).getCode(code,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到科室列表数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

ClassMethod getCode(code As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s resJson=##class(%DynamicArray).%New()
	s rules=..QueryTable(code)
	s lastres="",countc=0
	while rules.%Next()
	{			
		s obj=##class(%DynamicObject).%New()
		s strRule=rules.GetDataByName("Grop")
		s count=$LENGTH(strRule,"^")
		s res=""
		for i=1:1:count
		{	
			s ds="",tbName="",rowId="",descContent=""
			s rule=$Piece(strRule,"^",i)
			s rulecode=$Piece(rule,":",1)
			s ruledesc=$Piece(rule,":",2)
		
			&sql(select Description into :ds from CF_EMR_DOC.StdDictionary where Code=:rulecode)
			&sql(select TableName into :tbName from CF_EMR_DOC.StdDictionary where Code=:rulecode)
			&sql(select DicCodeCol into :rowId from CF_EMR_DOC.StdDictionary where Code=:rulecode)
			&sql(select DicDescCol into :descContent from CF_EMR_DOC.StdDictionary where Code=:rulecode)
			s data=..QueryDynTable(tbName,ruledesc,rowId,descContent)
			while data.%Next()
			{
				s A=data.GetDataByName(descContent)
			}
			s result=ds_"."_A
			if (res'="")
			{
				s res=result_" + "_res
			}
			else {
				s res=result			
				}
			s countc=countc+1
		}
		&sql(select ID into countc from CF_EMR_DOC.CodeGroup where Grop=:strRule AND Status='1')		
		s obj.key=countc
		s obj.text=res
		d resJson.%Push(obj)
	}
	d resJson.%ToJSON(argOutData)
	q "1"
}

/// Desc:       获取字典目录
/// Creator:    huhao
/// CreateDate: 2020-12-16
/// Input:      
/// OutPut:     argOutData 返回数据
ClassMethod GetStCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.OP.BL.BLDocumentRule).GetCategory(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到科室列表数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

ClassMethod GetCategory(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s data=..QueryCategory()
	s resArray=##class(%DynamicArray).%New()
	s key=0
	while data.%Next()
	{
		s resobj=##class(%DynamicObject).%New()
		s resobj.value=data.GetDataByName("Code")
		s resobj.label=data.GetDataByName("Description")
		s tagID=data.GetDataByName("RuleTypeTag")
		s objRuleType=##class(CF.EMR.DOC.EMRTSRuleType).%OpenId(tagID)
		continue:objRuleType=""
		s resobj.ruleTag=objRuleType.Code
		s resobj.key=key
		d resArray.%Push(resobj)
		s key=key+1
	}
	d resArray.%ToJSON(argOutData)
	q "1"
}

ClassMethod QueryCategory() As %XML.DataSet
{
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
 	s sql= "select Code,Description,RuleTypeTag from CF_EMR_DOC.StdDictionary WHERE IsRuleType='Y'"
	s status=dataset.Prepare(sql)
	d dataset.Execute()
	if $$$ISERR(status) { q "" }
    q dataset
}

/// Creator:	huhao
/// CreatDate:  添加单一规则
/// Desc:		
/// Input：		2021-12-13
/// Return：	失败：0，成功：1
ClassMethod AddDocRule(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s rowId=argInJson.params.rowId
	s dicCode=argInJson.params.dicCode
	s dataId=argInJson.params.dataId
    s strRes = ##Class(EMR.OP.BL.BLDocumentRule).AddSigleRule(rowId,dicCode,dataId)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes="101")
	{
	    q ..SetOutMessage(argOutMessage,"ERROR","重复添加",2)
	}
	elseif (strRes="102")
	{
	    q ..SetOutMessage(argOutMessage,"ERROR","请选择需要添加的规则",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到科室列表数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// 参数描述： rowid：外层列表行号，确认修改哪一条规则 dicCode：字典的编码 dataId：基础数据的id
ClassMethod AddSigleRule(rowid As %String, dicCode As %String, dataId As %String) As %String
{
	s strRes = ""
	if ((dicCode="")||(dataId=""))
	{
		s strRes="102"
	}
	else
	{
		s res=dicCode_":"_dataId
		s content=..QueryAddContent(rowid)
		while content.%Next()
		{
			s AddedContent=content.GetDataByName("Grop")
			if (AddedContent=res)
			{
				s strRes = "101"
				q
			}
		}
		if (strRes'="101")
		{
			&sql(insert into CF_EMR_DOC.CodeGroup (Code,Grop,Status) values(:rowid,:res,'1'))
			s strRes = "1"
		}
	}
	q strRes
}

ClassMethod QueryAddContent(rowid As %String) As %XML.DataSet
{
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
 	s sql = "SELECT Grop FROM CF_EMR_DOC.CodeGroup where Code='"_rowid_"' AND Status='1'"
	s status=dataset.Prepare(sql)
	d dataset.Execute()
	if $$$ISERR(status) { q "" }
    q dataset
}

/// Creator:	huhao
/// CreatDate:  组合规则
/// Desc:		
/// Input：		2021-12-13
/// Return：	失败：0，成功：1
/// 参数描述： rowid：外层列表行号 dicCode：字典的编码 dataId：基础数据的id
ClassMethod MatchDocRule(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s rowId=argInJson.params.rowId
	s dicCode=argInJson.params.dicCode
	s dataId=argInJson.params.dataId
	s ruleId=argInJson.params.ruleId
    s strRes = ##Class(EMR.OP.BL.BLDocumentRule).AddmuchRule(rowId,dicCode,dataId,ruleId)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes="101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","已添加相同类型规则",2)
	}
	elseif (strRes="102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请选择需要组合的规则",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到科室列表数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

ClassMethod AddmuchRule(rowid As %String, dicCode As %String, dataId As %String, ruleId As %String) As %String
{
	q:(dataId="")||(ruleId="") "102"
	s resL=dicCode_":"_dataId
	s resR=""
	&sql(select Grop into resR from CF_EMR_DOC.CodeGroup where ID=:ruleId AND Status='1')
	if ($find(resR,dicCode)'=0)
	{
		q "101"
	}
	else
	{
		s result=resR_"^"_resL
		&sql(update CF_EMR_DOC.CodeGroup set Grop=:result where ID=:ruleId )
		q "1"
	}
}

/// Creator:	huhao
/// CreatDate:  删除规则
/// Desc:		
/// Input：		2021-12-13
/// Return：	失败：0，成功：1
ClassMethod DeleteDocRule(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s rowId=argInJson.params.rowId
    s strRes = ##Class(EMR.OP.BL.BLDocumentRule).DeleteRule(rowId)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

ClassMethod DeleteRule(id As %String) As %String
{
	if (id="")	{q "101"}
	else
	{
		&SQL(UPDATE CF_EMR_DOC.CodeGroup SET Status="0" WHERE ID=:id)
		q "1"
	}
}

}
