/// Creator:高姗姗
/// CreatDate:2020-12-24
/// Description：文献详情
Class web.CDSS.CMKB.DocuDetail Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2020-12-24
/// Description：获取文献详情树形列表
/// Input:父id
/// return:Json格式字符串
/// w ##class(web.CDSS.CMKB.DocuDetail).GetTreeJson("1807","")
ClassMethod GetTreeJson(DocuDR As %String, Parent) As %String
{
	q:DocuDR="" ""
    s myJsonStr=""
    if (Parent="") s Parent=-100000000000000
    s myRowID=0
    for {
        s myRowID=$o(^CT.WDT.CDSS.DocuDetailI("DocuParentIndex",DocuDR,Parent,myRowID))
        q:myRowID=""
        s myObj=##Class(CT.WDT.CDSS.DocuDetail).%OpenId(myRowID)
        if $IsObject(myObj) {
        	s Title=myObj.Title
           	s Content=myObj.Content
           	s Content=##class(web.DHCBL.BDP.FunLib).EvalJSONB(Content)
           	s:myObj.ParentDR'="" ParentDR=myObj.ParentDR.%Id()
           	s:myObj.ParentDR="" ParentDR=""
            
            s:(myJsonStr'="") myJsonStr=myJsonStr_","
            s myJsonStr=myJsonStr_"{"
            s myJsonStr=myJsonStr_"""id"":"""_myRowID_""",""text"":"""_Title_""",""parent"":"""_ParentDR_""",""content"":"""_Content_""","
            s myJsonStr=myJsonStr_"""state"":""open"""
			if ($d(^CT.WDT.CDSS.DocuDetailI("DocuParentIndex",DocuDR,myRowID))){
				s myJsonStr=myJsonStr_",""children"":"_..GetTreeJson(DocuDR,myRowID)
			}
			s myJsonStr=myJsonStr_"}"
			d myObj.%Close()
        }
    }
    s myJsonStr="["_myJsonStr_"]"
    
    q myJsonStr
}

/// Creator：高姗姗
/// CreatDate: 2020-12-24
/// Description：获取文献详情父级下拉树
/// Input:父id
/// return:Json格式字符串
/// w ##class(web.CDSS.CMKB.DocuDetail).GetTreeComboJson("13","")
ClassMethod GetTreeComboJson(DocuDR As %String, Parent) As %String
{
	q:DocuDR="" ""
    s myJsonStr=""
    if (Parent="") s Parent=-100000000000000
    s myRowID=0
    for {
        s myRowID=$o(^CT.WDT.CDSS.DocuDetailI("DocuParentIndex",DocuDR,Parent,myRowID))
        q:myRowID=""
        s myObj=##Class(CT.WDT.CDSS.DocuDetail).%OpenId(myRowID)
        if $IsObject(myObj) {
        	s Title=myObj.Title
            
            s:(myJsonStr'="") myJsonStr=myJsonStr_","
            s myJsonStr=myJsonStr_"{"
            s myJsonStr=myJsonStr_"""id"":"""_myRowID_""",""text"":"""_Title_""","
            s myJsonStr=myJsonStr_"""state"":""open"""
			if ($d(^CT.WDT.CDSS.DocuDetailI("DocuParentIndex",DocuDR,myRowID))){
				s myJsonStr=myJsonStr_",""children"":"_..GetTreeComboJson(DocuDR,myRowID)
			}
			s myJsonStr=myJsonStr_"}"
			d myObj.%Close()
        }
    }
    s myJsonStr="["_myJsonStr_"]"
    
    q myJsonStr
}

/// Creator:高姗姗
/// CreatDate:2020-12-28
/// Description:保存文献管理详细信息
/// Input：eobj文献详细信息对象
/// Other:w ##class(web.CDSS.CMKB.DocuDetail).SaveData()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DocuDetail)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.Content="3@%CSP.CharacterStream")
		{
			q "{success:'false',errorinfo:'录入字符（包含标点）太多,已经达到上限，没法保存，请调整文字！'}"
		}
		else{
			if (eobj.RowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(CT.WDT.CDSS.DocuDetail).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(CT.WDT.CDSS.DocuDetail).%OpenId(eobj.RowId)
				
				s bobj = ##class(web.CDSSEntity.CMKB.DocuDetail).%New()
				s bobj.DocuDR=obj.DocuDR.%Id()
				s bobj.Title=obj.Title
				s bobj.Content=obj.Content
				s:obj.ParentDR'="" bobj.ParentDR=obj.ParentDR.%Id()
			}
			
			d:eobj.DocuDR'="" obj.DocuDRSetObjectId(eobj.DocuDR)
			d:eobj.DocuDR="" obj.DocuDRSetObjectId("") 
			s obj.Title=eobj.Title
			s eobj.Content=##class(web.DHCBL.BDP.FunLib).Util(eobj.Content)
			s obj.Content=eobj.Content
			d:eobj.ParentDR'="" obj.ParentDRSetObjectId(eobj.ParentDR) 
			d:eobj.ParentDR="" obj.ParentDRSetObjectId("") 
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				
				 //保存日志
			    d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuDetail","CT.WDT.CDSS.DocuDetail","文献管理详细信息",id,eobj.Title,"A",eobj)
			 	d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuDetail","CT.WDT.CDSS.DocuDetail","文献管理详细信息",eobj.RowId,eobj.Title,"U",eobj,bobj)    
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("文献管理详细信息","web.CDSS.CMKB.DocuDetail","SaveData",eobj)
	       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("文献管理详细信息","web.CDSS.CMKB.DocuDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
	q result
}

/// Other: w ##class(web.CDSS.CMKB.DocuDetail).Test()
ClassMethod Test() As %String
{
	s eobj=##class(web.CDSSEntity.CMKB.DocuDetail).%New()
	s eobj.RowId="1"
	s eobj.DocuDR="1807"
	s eobj.Title="11"
	s eobj.Content="<p>123</p><p><br/></p>"
	s eobj.ParentDR=""
	s res=..SaveData(eobj)
	q res
}

/// Creator：高姗姗
/// CreatDate: 2020-12-28
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.CDSS.CMKB.DocuDetail).GetRefFlag("167")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s DocuDR=$lg($g(^CT.WDT.CDSS.DocuDetailD(id)),2)
	if $d(^CT.WDT.CDSS.DocuDetailI("DocuParentIndex",DocuDR,id)) s myInfo=myInfo_"<文献管理详细信息>"
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Creator:高姗姗
/// CreatDate:2020-12-28
/// Description:数据删除方法
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DocuDetail).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	s re=##class(web.CDSS.CMKB.DocuDetail).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		
		s obj=##class(CT.WDT.CDSS.DocuDetail).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.DocuDetail).%New()
		s bobj.DocuDR=obj.DocuDR.%Id()
		s bobj.Title=obj.Title
		s bobj.Content=obj.Content
		s:obj.ParentDR'="" bobj.ParentDR=obj.ParentDR.%Id()
		s:obj.ParentDR="" bobj.ParentDR=""
				
		s sc=##class(CT.WDT.CDSS.DocuDetail).%DeleteId(id)
		if $$$ISOK(sc)
		{
			s result = "{success:'true',info:'删除成功！'}"	
			
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuDetail","CT.WDT.CDSS.DocuDetail","文献管理详细信息",id,bobj.Title,"D",bobj)
			d bobj.%Close()
		}
		else
		{
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息	
		}
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2021-01-13
/// Description:获取文本编辑器中的内容
/// Other: w ##class(web.CDSS.CMKB.DocuDetail).GetContent("167")
ClassMethod GetContent(id As %String) As %String
{
	s obj=##class(CT.WDT.CDSS.DocuDetail).%OpenId(id)
	s Content=obj.Content
	q Content
}

}
