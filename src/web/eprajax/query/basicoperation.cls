/// Desc: 电子病历综合查询单元编辑
Class web.eprajax.query.basicoperation Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"null")
	q:(action = "null") $$$OK
	s frameType = $g(%request.Data("frameType",1),"")
	
	if (action = "TypeCode ")
	{
		d ..GetQueryItemType()		
	}
	q $$$OK
}

/// Creator：      wangyu
/// CreatDate：    2020-10-23
/// Description:   查询单元项目的添加、修改和导入
/// Table：        EPRmeta.Query.QueryItem
/// Input：        argInMessage :QueryItemData
/// Output            argInData    :result
/// Others：       其它说明
/// Debug:         w ##Class(web.eprajax.query.basicoperation).SetobjQueryCategoryData("8^EPRIndexRecord1^一般情况1^7^一般情况1^3001^Y/","")
ClassMethod SetQueryItemData(QueryItemData As %String, action As %String = "")
{
	s result =""
	s ^temp("1030") = QueryItemData
	q:(QueryItemData = "") result
	for i=1:1:$l(QueryItemData,"/")-1
	{
		s data= $p(QueryItemData,"/",i)
		s rowId =$p(data,"^",11)
		if (rowId = "")
		{
			s objQueryItem = ##class(EPRmeta.Query.QueryItem).%New()
		}
		else
		{
			s objQueryItem = ##class(EPRmeta.Query.QueryItem).%OpenId(rowId)
			q:(objQueryItem = "") 
		}
		s objQueryItem.CategoryID = $p(data,"^",1)
		s objQueryItem.Code = $p(data,"^",2)
		s objQueryItem.IsActive = $p(data,"^",3)
		s objQueryItem.Name = $p(data,"^",4)
		s objQueryItem.ParentID = $p(data,"^",5)
		s objQueryItem.QueryItemTypeID = $p(data,"^",6)
		if ($p(data,"^",7)="undefined")
		{	
			s $p(data,"^",7) = ""
		}
		s objQueryItem.Remark = $p(data,"^",7)
		s objQueryItem.Sequence = $p(data,"^",8)
		s objQueryItem.StdDic = $p(data,"^",9)
		s objQueryItem.Title = $p(data,"^",10)
		s sc = objQueryItem.%Save()
		if ($$$ISERR(sc))
		{
			 s result = -1
			
		}
		else
		{
			s result = 1
		}
	}
		
	q result
}

/// Creator：      wangyu
/// CreatDate：    2020-10-23
/// Description:   查询单元项目分类的添加、修改
/// Table：        EPRmeta.Query.QueryCategory
/// Input：        argInMessage :QueryItemData
/// Output            argInData    :result
/// Others：       其它说明
/// Debug:         w ##Class(web.eprajax.query.basicoperation).SetobjQueryCategoryData("8^EPRIndexRecord1^一般情况1^7^一般情况1^3001^Y/","")
ClassMethod SetobjQueryCategoryData(QueryCategoryData As %String, action As %String = "")
{
	s result =""
	s ^temp("1030") = QueryCategoryData
	q:(QueryCategoryData = "") result
	for i=1:1:$l(QueryCategoryData,"/")-1
	{
		s data= $p(QueryCategoryData,"/",i)
		s rowId =$p(data,"^",1)
		if (rowId = "")
		{
			s objQueryCategory = ##class(EPRmeta.Query.QueryCategory).%New()
		}
		else
		{
			s objQueryCategory = ##class(EPRmeta.Query.QueryCategory).%OpenId(rowId)
			q:(objQueryCategory = "") 
		}
		s objQueryCategory.Code = $p(data,"^",2)
		s objQueryCategory.Name = $p(data,"^",3)
		s objQueryCategory.ParentID = $p(data,"^",4)
		s objQueryCategory.Remark = $p(data,"^",5)
		s objQueryCategory.Sequence = $p(data,"^",6)
		s objQueryCategory.IsActive = $p(data,"^",7)
		s sc = objQueryCategory.%Save()
		if ($$$ISERR(sc))
		{
			 s result = -1
			
		}
		else
		{
			s result = 1
		}
	}
		
	q result
}

/// Creator：      wangyu
/// CreatDate：    2020-10-23
/// Description:   查询QueryItemType
/// Table：        EPRmeta.Query.QueryItemType
/// Input：        
/// Output            argInData    :json
/// Others：       其它说明
/// Debug:         w ##Class(web.eprajax.query.basicoperation).GetQueryItemType()
ClassMethod GetQueryItemType()
{
	s length =$g(^DHCEPRM.QueryItemTypeD)
	s json = "["
	s RowID = 0
	for i=1:1:length
	{
		s RowID = RowID + 1
		s objQueryItemType = $g(^DHCEPRM.QueryItemTypeD(RowID))
		q:(objQueryItemType = "") 	
		if (RowID > 1) { s json = json_"," }
		s Code = $list(objQueryItemType,2)
		s json = json_"{""id"":"""_RowID_""","
 		s json = json_"""text"":"""_Code_"""}"	
	}
	s json = json_"]"
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	q json
}

/// Creator：      wangyu
/// CreatDate：    2020-10-23
/// Description:   查询QueryItemType
/// Table：        EPRmeta.Query.QueryItemType
/// Input：        
/// Output         argInData    :json
/// Others：       其它说明
/// Debug:         w ##Class(web.eprajax.query.basicoperation).GetStdDictionary()	
ClassMethod GetStdDictionary()
{
	s length =$g(^DHCEMRM.StdDictionaryD)
	s RowID = 0
	s json = "["
	for i=1:1:length 
	{
		if (RowID<1)
		{
			s json = json_"{""id"":""0"","
			s json = json_"""Code"":""1"","
 			s json = json_"""Description"":""默认""},"
		}
		s RowID = RowID +1
		s objStdDictionary = $g(^DHCEMRM.StdDictionaryD(RowID))
		q:(objStdDictionary = "") 
		s Code = $list(objStdDictionary,2)
		s Description = $list(objStdDictionary,3)
		if (RowID > 1) { s json = json_","  }
		s json = json_"{""id"":"""_RowID_""","
		s json = json_"""Code"":"""_Code_""","
 		s json = json_"""Description"":"""_Description_"""}"
	}
	s json = json_"]"
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	q json
}

}
