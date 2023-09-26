Class DHCEPRSearch.Tool.BasicDataMaintain Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// ------------------------------------------------------------------------------------
/// 系统参数维护
/// d ##class(DHCEPRSearch.Tool.BasicDataMaintain).InitSystemOption()
ClassMethod InitSystemOption()
{
	s sc = $$InitSystemOption("SolrUrl","http://localhost:8080/solr/","Solr服务器地址和端口","Y")
	s sc = $$InitSystemOption("QueryOption","AND","用户输入多个词用空格分隔时，默认采用的逻辑连接方式，值可为AND或者OR","Y")
	s dataServiceURL = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("WebURL")
	s sc = $$InitSystemOption("DataServiceUrl",dataServiceURL,"检索出的文档所在的DataServiceUrl","Y")
	s sc = $$InitSystemOption("WordCollect","Y","记录搜索词开关","Y")
	
InitSystemOption(argName,argOptionValue,argDesc,argIsVisible)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRSearch_META.SystemOption
		where Name = :argName)
	
	if (rowid = "")
	{
		&sql(insert into DHCEPRSearch_META.SystemOption (Name,OptionValue,Description,IsVisible) 
			values (:argName,:argOptionValue,:argDesc,:argIsVisible))
	}
	else
	{
		&sql(update DHCEPRSearch_META.SystemOption set Name=:argName,OptionValue=:argOptionValue,Description=:argDesc,IsVisible=:argIsVisible
			where ID = :rowid)
	}
	q "1"
}

/// ------------------------------------------------------------------------------------
/// 过滤项目基础数据维护
/// d ##class(DHCEPRSearch.Tool.BasicDataMaintain).InsertFilterQueryItem()
ClassMethod InsertFilterQueryItem()
{
	d ..InitFQCategory()
	d ..InitFQSubCategory()
	d ..InsertMRItem()
	d ..InsertLoc("adm")
	d ..InsertLoc("dis")
}

/// 维护表DHCEPRSearch.META.CustomWordDic的基础数据
/// d ##class(DHCEPRSearch.Tool.BasicDataMaintain).InitCustomWordDic()
ClassMethod InitCustomWordDic()
{
	d ..InsertCustomWordDic("AND")
	d ..InsertCustomWordDic("OR")
	d ..InsertCustomWordDic("NOT")
}

/// Debug: d ##class(DHCEPRSearch.Tool.BasicDataMaintain).InsertMRItem()
ClassMethod InsertMRItem()
{
	s code = ""
	for {
		s code = $O(^DHCEPRFS.META.MRItemI("IdxMain", code))
		q:(code="")
		s rowID = ""
		for {
			s rowID = $O(^DHCEPRFS.META.MRItemI("IdxMain", code,rowID))
			q:(rowID="")
			s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(rowID)
			s name = obj.Name
			s subCgID = obj.MRSubCategoryID
			d obj.%Close()
			s subCgCode = ""
			s objSubCg = ##class(DHCEPRFS.META.MRSubCategory).%OpenId(subCgID)
			if (objSubCg '= "")
			{
				s subCgCode = objSubCg.Code
				d objSubCg.%Close()
			}
			
			s filterQueryID = ""
			s filterQueryID = $o(^DHCEPRSearch.META.FilterQueryI("IdxGroupItem"," 1"," "_rowID,filterQueryID))
			continue:(filterQueryID'="")  //如已存在 跳过循环
			
			s objFQ = ##class(DHCEPRSearch.META.FilterQueryItem).%New()
			s objFQ.ItemGroupID = "1"
			s objFQ.ItemGroupName = "MRItemID"
			s objFQ.ItemGroupDesc = "分类"
			s objFQ.ItemID = rowID
			s objFQ.ItemName = name
			s objFQ.FQSubCategoryID = ..GetFQSubCategoryIDByCode(subCgCode)
			
			s status = objFQ.%Save()
			if ($$$ISOK(status))
			{
				s objFQ.Sequence = objFQ.%Id()
				d objFQ.%Save()
				d objFQ.%Close()
			}
			else
			{
				w rowID,!
			}
			
		}
	}
}

/// Debug: d ##class(DHCEPRSearch.Tool.BasicDataMaintain).InsertLoc("adm")
ClassMethod InsertLoc(AType As %String)
{
	s rset = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.HISInfo.BLDictionaryInfo:CTLoc")
	s sc = rset.Execute()
	
	while (rset.Next())
	{
		s rowID = rset.Data("rowid")
		s code = rset.Data("Code")
		s desc = rset.Data("Desc")
		s alias = rset.Data("Alias")
		
		s objFQ = ##class(DHCEPRSearch.META.FilterQueryItem).%New()
		if (AType = "adm")
		{
			s objFQ.ItemGroupID = "2"
			s objFQ.ItemGroupName = "AdmLocID"
			s objFQ.ItemGroupDesc = "入院科室"
			s objFQ.FQSubCategoryID = ..GetFQSubCategoryIDByCode("LOCSUB01")
			
			s filterQueryID = ""
			s filterQueryID = $o(^DHCEPRSearch.META.FilterQueryI("IdxGroupItem"," 2"," "_rowID,filterQueryID))
			continue:(filterQueryID'="")  //如已存在 退出
		}
		else
		{
			s objFQ.ItemGroupID = "3"
			s objFQ.ItemGroupName = "DisLocID"
			s objFQ.ItemGroupDesc = "出院科室"
			s objFQ.FQSubCategoryID = ..GetFQSubCategoryIDByCode("LOCSUB02")
			
			s filterQueryID = ""
			s filterQueryID = $o(^DHCEPRSearch.META.FilterQueryI("IdxGroupItem"," 3"," "_rowID,filterQueryID))
			continue:(filterQueryID'="")  //如已存在 跳过循环
		}
		s objFQ.ItemID = rowID
		s objFQ.ItemName = desc
		s objFQ.ItemAlias = alias
			
		s status = objFQ.%Save()
		if ($$$ISOK(status))
		{
			s objFQ.Sequence = objFQ.%Id()
			d objFQ.%Save()
			d objFQ.%Close()
		}
		else
		{
			w rowID,!
		}
	}
}

/// d ##class(DHCEPRSearch.Tool.BasicDataMaintain).InsertCustomWordDic("AND")
ClassMethod InsertCustomWordDic(AWord As %String)
{
	s obj = ##Class(DHCEPRSearch.META.CustomWordDic).%New()
	s obj.Word = AWord
	s obj.IsAvailable = "N"
	s obj.DateInput = $p($h,",",1)
	s obj.TimeInput = $p($h,",",2)
	s obj.DateUpdate = $p($h,",",1)
	s obj.TimeUpdate = $p($h,",",2)
	s obj.WordFrequency = 1
	    
	s status = obj.%Save()
}

/// Desc: 初始化过滤项目大类
/// Debug: d ##Class(DHCEPRSearch.Tool.BasicDataMaintain).InitFQCategory()
ClassMethod InitFQCategory()
{
	s sc = $$InitFQCategory("MRItemID","分类","1","01")
	s sc = $$InitFQCategory("AdmLocID","入院科室","2","02")
	s sc = $$InitFQCategory("DisLocID","出院科室","3","03")
	
InitFQCategory(argName,argDescription,argSequence,argCode)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRSearch_META.FQCategory
		where Code = :argCode)
	
	if (rowid = "")
	{
		&sql(insert into DHCEPRSearch_META.FQCategory (Name,Description,Sequence,Code) 
			values (:argName,:argDescription,:argSequence,:argCode))
	}
	else
	{
		&sql(update DHCEPRSearch_META.FQCategory set Name=:argName,Description=:argDescription,Sequence=:argSequence,Code=:argCode
			where id = :rowid)
	}
	
	q "1"
}

/// Desc: 初始化过滤项目子类
/// Debug: d ##class(DHCEPRSearch.Tool.BasicDataMaintain).InitFQSubCategory()
ClassMethod InitFQSubCategory()
{
	s categoryID = ""
	s categoryID = $o(^DHCEPRSearch.META.FQCategoryI("IdxMain"," 01",categoryID))
	if (categoryID = "")
	{
		w "过滤项目大类：分类不存在，请先初始化过滤项目大类！",!
	}
	else
	{
		s subCategoryID = ""
		f {
			s subCategoryID = $o(^DHCEPRFS.META.MRSubCategoryD(subCategoryID))
			q:(subCategoryID = "")
			s objSub = ##class(DHCEPRFS.META.MRSubCategory).%OpenId(subCategoryID)
			s name = objSub.Name
			s desc = objSub.Description
			s code = objSub.Code
			s ret = ..CreateFQSubCategory(name,desc,categoryID,code)
			if (ret = "")
			{
				w subCategoryID,!
			}
		}
	}
	s categoryID = ""
	s categoryID = $o(^DHCEPRSearch.META.FQCategoryI("IdxMain"," 02",categoryID))
	if (categoryID = "")
	{
		w "过滤项目大类：入院科室不存在，请先初始化过滤项目大类！",!
	}
	else
	{
		s ret = ..CreateFQSubCategory("入院科室","入院科室",categoryID,"LOCSUB01")
		w ret,!
	}
	s categoryID = ""
	s categoryID = $o(^DHCEPRSearch.META.FQCategoryI("IdxMain"," 03",categoryID))
	if (categoryID = "")
	{
		w "过滤项目大类：出院科室不存在，请先初始化过滤项目大类！",!
	}
	else
	{
		s ret = ..CreateFQSubCategory("出院科室","出院科室",categoryID,"LOCSUB02")
		w ret,!
	}
}

/// Debug: w ##class(DHCEPRSearch.Tool.BasicDataMaintain).CreateFQSubCategory("科室","科室","3","sub01")
ClassMethod CreateFQSubCategory(AName As %String, ADesc As %String, AFQCategoryID As %String, ACode As %String) As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRSearch.META.FQSubCateI("IdxMain"," "_$zcvt(ACode,"U"),rowID))
	if (rowID '= "")
	{
		q rowID
	}
	else
	{
		s obj = ##class(DHCEPRSearch.META.FQSubCategory).%New()
		s obj.Name = AName
		s obj.Description = ADesc
		s obj.FQCategoryID = AFQCategoryID
		s obj.Code = ACode
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			s obj.Sequence = obj.%Id()
			d obj.%Save()
			d obj.%Close()
			q obj.%Id()
		}
		else
		{
			q ""
		}
	}
}

/// Debug: w ##class(DHCEPRSearch.Tool.BasicDataMaintain).GetFQSubCategoryIDByCode("EPRSUB001")
ClassMethod GetFQSubCategoryIDByCode(ACode As %String) As %String
{
	q:(ACode = "") ""
	s rowID = ""
	s rowID = $o(^DHCEPRSearch.META.FQSubCateI("IdxMain"," "_$zcvt(ACode,"U"),rowID))
	q rowID
}

}
