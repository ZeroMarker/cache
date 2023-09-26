Class DHCEPRFS.Tool.InitDataByFile Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	通过文件初始化归档内容（默认Windows系统D盘下）
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitAll()
ClassMethod InitAll()
{
	s isExistedInwindows = ##class(%File).Exists("d:\category.txt")
	s isExistedInLinux = ##class(%File).Exists("/data/category.txt")
	if (isExistedInwindows)
	{
		d ..InitCategoryByFile("d:\category.txt")
		d ..InitSubCategoryByFile("d:\subcategory.txt")
		d ..InitItemByFile("d:\item.txt")
	}
	elseif (isExistedInLinux)
	{
		d ..InitCategoryByFile("/data/category.txt")
		d ..InitSubCategoryByFile("/data/subcategory.txt")
		d ..InitItemByFile("/data/item.txt")
	}
	else
	{
		w !,"请先维护路径下存在该文件!"
	}
}

/// Desc:	通过文件导入：归档大类
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitCategoryByFile("d:\category.txt")
ClassMethod InitCategoryByFile(AFileName As %String) As %Boolean
{
	s isExisted = ##class(%File).Exists(AFileName) 
	If ('isExisted)
 	{
	 	Write !,"file is not exist!"
	 	quit
 	}
 	
 	w !, "+++++++++++ init MRCategory started!"
	
	s failCount = 0, okCount =0, totCount = 0
 	
	Set fs = ##class(%FileCharacterStream).%New()
	Set fs.Filename = AFileName
	
	While 'fs.AtEnd {
		Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		s ACode = $p(sRec, $c(9), 1)
 		s AName = $p(sRec, $c(9), 2)
 		s ADesc = $p(sRec, $c(9), 3)
		s isOK = ..InitCategory(ACode, AName, ADesc)
	
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	
	}  

	d fs.%Close()
	s fs = ""
	
	w !, "+++++++++++totCount:"_totCount_", okCount:"_okCount_", failCount:"_failCount
	w !, "+++++++++++init MRCategory finished!"
	
	quit
}

/// Desc:	初始化归档大类
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitCategory("EPR001","病历文书新版","病历文书新版")
ClassMethod InitCategory(ACode, AName, ADesc) As %Boolean
{
	s rowID = ##Class(DHCEPRFS.BL.BLMRCategory).GetCategoryIDByCode(ACode)
	if (rowID '= "")
	{
		w !, "Code:"_ACode_", Name:"_AName_" 已存在!"
		q "1"
	}
	else
	{
		s rowID = ##Class(DHCEPRFS.BL.BLMRCategory).CreateCategory(ACode, AName, ADesc)
		if (rowID = "")
		{
			w !,"------Code:"_ACode_", Name:"_AName_" 初始化失败!"
			q "0"
		}
		else
		{
			w !,"Code:"_ACode_", Name:"_AName_" 初始化成功!"
			q "1"
		}
	}
}

/// Desc:	通过文件导入：归档子类
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitSubCategoryByFile("d:\subcategory.txt")
ClassMethod InitSubCategoryByFile(AFileName As %String) As %Boolean
{
	s isExisted = ##class(%File).Exists(AFileName) 
	If ('isExisted)
 	{
	 	Write !,"file is not exist!"
	 	quit
 	}
 	
 	w !, "+++++++++++ init MRSubCategory started!"
	
	s failCount = 0, okCount =0, totCount = 0
 	
	Set fs = ##class(%FileCharacterStream).%New()
	Set fs.Filename = AFileName
	
	While 'fs.AtEnd {
		Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		s ACode = $p(sRec, $c(9), 1)
 		s AName = $p(sRec, $c(9), 2)
 		s ADesc = $p(sRec, $c(9), 3)
 		s ACateCode = $p(sRec, $c(9), 4)
		s isOK = ..InitSubCategory(ACode, AName, ADesc, ACateCode)
	
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	
	}  

	d fs.%Close()
	s fs = ""
	
	w !, "+++++++++++totCount:"_totCount_", okCount:"_okCount_", failCount:"_failCount
	w !, "+++++++++++init MRSubCategory finished!"
	
	quit
}

/// Desc:	初始化归档子类
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitSubCategory("EPRSUB001","住院证","住院证","EPR005")
ClassMethod InitSubCategory(ACode, AName, ADesc, ACateCode) As %Boolean
{
	s rowID = ##Class(DHCEPRFS.BL.BLMRSubCategory).GetSubCategoryIDByCode(ACode)
	if (rowID '= "")
	{
		w !, "Code:"_ACode_", Name:"_AName_" 已存在!"
		q "1"
	}
	else
	{
		s mrCategoryID = ##Class(DHCEPRFS.BL.BLMRCategory).GetCategoryIDByCode(ACateCode)
		if (mrCategoryID = "")
		{
			w !,"------Code:"_ACode_", Name:"_AName_" 初始化失败!"_"病历大类:"_ACateCode_"不存在!"
			q "0"
		}
		s rowID = ##Class(DHCEPRFS.BL.BLMRSubCategory).CreateSubCategory(ACode, AName, ADesc, mrCategoryID)
		if (rowID = "")
		{
			w !,"------Code:"_ACode_", Name:"_AName_" 初始化失败!"
			q "0"
		}
		else
		{
			w !,"Code:"_ACode_", Name:"_AName_" 初始化成功!"
			q "1"
		}
	}
}

/// Desc:	通过文件导入：归档项目
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitItemByFile("d:\item.txt")
ClassMethod InitItemByFile(AFileName As %String) As %Boolean
{
	s isExisted = ##class(%File).Exists(AFileName) 
	If ('isExisted)
 	{
	 	Write !,"file is not exist!"
	 	quit
 	}
 	
 	w !, "+++++++++++ init MRItem started!"
	
 	s failCount = 0, okCount =0, totCount = 0
 	
	Set fs = ##class(%FileCharacterStream).%New()
	Set fs.Filename = AFileName
	
	While 'fs.AtEnd {
		Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		s ACode 	=	$p(sRec, $c(9), 1)
 		s AName 	=	$p(sRec, $c(9), 2)
 		s ADesc 	=	$p(sRec, $c(9), 3)
 		s ACateCode = 	$p(sRec, $c(9), 4)
 		s AType 	=	$p(sRec, $c(9), 5)
 		s ATypeParams = $p(sRec, $c(9), 6)
		s isOK = ..InitItem(ACode, AName, ADesc, ACateCode,AType,ATypeParams)
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}  

	d fs.%Close()
	s fs = ""
	
	w !, "+++++++++++totCount:"_totCount_", okCount:"_okCount_", failCount:"_failCount
	w !, "+++++++++++init MRItem finished!"
	quit
}

/// Desc:	初始化归档项目
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitItem("EPRITEM001","住院证","住院证","EPRSUB001","05","1")
ClassMethod InitItem(ACode, AName, ADesc, ACateCode, AType, ATypeParams) As %Boolean
{
	if (ACode = "")||(ACateCode = "")
	{
		w !, "------Code:"_ACode_", Name:"_AName_" 的子类编码为空!"
		q "0"
	}

	s rowID = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByCode(ACode)
	if (rowID '= "")
	{
		w !, "Code:"_ACode_", Name:"_AName_" 已存在!"
		q "1"
	}
	else
	{
		s mrSubCategoryID = ##Class(DHCEPRFS.BL.BLMRSubCategory).GetSubCategoryIDByCode(ACateCode)
		if (mrSubCategoryID = "")
		{
			w !,"------Code:"_ACode_", Name:"_AName_" 初始化失败!"_"病历子类:"_ACateCode_"不存在!"
			q "0"
		}
		s rowID = ##Class(DHCEPRFS.BL.BLMRItem).CreateItem(ACode, AName, ADesc, mrSubCategoryID, AType, ATypeParams)
		if (rowID = "")
		{
			w !,"------Code:"_ACode_", Name:"_AName_" 初始化失败!"
			q "0"
		}
		else
		{
			w !,"Code:"_ACode_", Name:"_AName_" 初始化成功!"
			q "1"
		}
	}
}

/// Desc:	通过文件导入：三单一致数据
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitRecordCheck("d:\CheckValue.txt")
ClassMethod InitRecordCheck(AFileName As %String) As %Boolean
{
	s isExisted = ##class(%File).Exists(AFileName) 
	If ('isExisted)
 	{
	 	Write !,"file is not exist!"
	 	quit
 	}
 	
 	w !, "+++++++++++ init RecordCheck started!"
	
	s failCount = 0, okCount =0, totCount = 0
 	
	Set fs = ##class(%FileCharacterStream).%New()
	Set fs.Filename = AFileName
	
	While 'fs.AtEnd {
		Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		s CheckName = $p(sRec, $c(9), 1)
 		s CheckDesc = $p(sRec, $c(9), 2)
 		s CheckType = $p(sRec, $c(9), 3)
		s CheckURL  = $p(sRec, $c(9), 4) 
		s Index =     $p(sRec, $c(9), 5)
	    s isOK = ##Class(DHCEPRFS.BL.BLRecordCheck).SetValue(CheckName, CheckDesc, CheckType,CheckURL,Index)
	
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}  
	d fs.%Close()
	s fs = ""
	w !, "+++++++++++totCount:"_totCount_", okCount:"_okCount_", failCount:"_failCount
	w !, "+++++++++++init RecordCheck finished!"
	
	quit
}

/// Desc:	查询导入方法
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitFile("d:\test.txt")
ClassMethod InitFile(AFileName As %String) As %FileCharacterStream
{
	s isExisted = ##class(%File).Exists(AFileName) 
	If ('isExisted)
 	{
	 	Write !,"!!!file is not exist!!!"
	 	quit ""
 	}
 	w !, "+++++++++++ init "_$e(AFileName,$f(AFileName,"\"),$l(AFileName))_" started!"
	Set fs = ##class(%FileCharacterStream).%New()
	Set fs.Filename = AFileName	
	q fs
}

/// Desc:   通过文件导入：查询模块字典
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitCustomDictionary("d:\CustomDictionary.txt")
ClassMethod InitCustomDictionary(AFileName As %String) As %Boolean
{
	s failCount = 0, okCount =0, totCount = 0
    s fs = ..InitFile(AFileName)
    q:(fs="")
	While 'fs.AtEnd {
		Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		s ACode = $p(sRec, $c(9), 1)
 		s ADesc = $p(sRec, $c(9), 2)
 		s Alias = $p(sRec, $c(9), 3)
		s AType = $p(sRec, $c(9), 4) 
		s AIsActive = $p(sRec, $c(9), 5)
		s AIndex = $p(sRec, $c(9), 6)
	    s isOK = ##Class(DHCEPRFS.BL.BLCustomDic).AddDic(ACode, ADesc, Alias,AType,AIsActive,AIndex)
	
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}  
	d fs.%Close()
	s fs = ""
	w !, "+++++++++++totCount:"_totCount_", okCount:"_okCount_", failCount:"_failCount
	w !, "+++++++++++init CustomDictionary finished!"
	
	quit
}

/// Desc:	通过文件导入：权限功能字典
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitDicFunction("d:\DicFunction.txt")
ClassMethod InitDicFunction(AFileName As %String)
{
	s failCount = 0, okCount =0, totCount = 0
	s fs = ..InitFile(AFileName)
	q:(fs="")
    While 'fs.AtEnd {
		Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		s FuncName = $p(sRec, $c(9), 1)
 		s FuncDesc = $p(sRec, $c(9), 2)
 		s ParentID = $p(sRec, $c(9), 3)
 		
		s isOK =##Class(DHCEPRFS.BL.BLQueryRoleFunction).AddFunction(FuncName, FuncDesc, ParentID)
	
    	s totCount = totCount + 1
		if (isOK)
		{
	   		s okCount = okCount + 1
		}
		else
		{
	   		s failCount = failCount + 1
		}
    }
	w !, "+++++++++++totCount:"_totCount_", okCount:"_okCount_", failCount:"_failCount
	w !, "+++++++++++init DicFunction finished!"
}

/// Desc:	通过文件导入：结果列
/// Debug:	d ##Class(DHCEPRFS.Tool.InitDataByFile).InitResultColumn("d:\ResultColumn.txt")
ClassMethod InitResultColumn(AFileName As %String)
{
	s failCount = 0, okCount =0, totCount = 0
	s fs = ..InitFile(AFileName)
	q:(fs="")
	While 'fs.AtEnd {
	Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		s FName	=	$p(sRec, $c(9), 1)
 		s Desc	=	$p(sRec, $c(9), 2)
 		s Active =	$p(sRec, $c(9), 3)
 		
	    s isOK =##Class(DHCEPRFS.BL.BLResultColumn).AddColumn("",Desc,FName, Active)
	
	}
	w !, "+++++++++++totCount:"_totCount_", okCount:"_okCount_", failCount:"_failCount
	w !, "+++++++++++init ResultColumn finished!"
}

/// Desc: 初始化MRItem的OCRArrangeTitle字段
/// Debug: d ##class(DHCEPRFS.Tool.InitDataByFile).InitMRItemOCRArrangeTitleByFile()
ClassMethod InitMRItemOCRArrangeTitleByFile()
{
	s isExisted = ##class(%File).Exists("d:\ocr.txt")
	i ('isExisted)
	{
		w !,"file is not exist!"
		q
	}
	w !, "+++++++++++ init OcrCategory started!"
	Set fs = ##class(%FileCharacterStream).%New()
	Set fs.Filename = "d:\ocr.txt"	
	d ..Trim()
	While 'fs.AtEnd {
		
		Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
 		s ADesc = $p(sRec, $c(9), 2)
 		s AName = $p(sRec, $c(9), 3)
		try
		{
			s isOK =..InitOcrCategory(ADesc,AName)
		}catch{
			w "出错"
			}
	
		
	
	}  

	d fs.%Close()
	s fs = ""
	
	
	w !, "+++++++++++init MRCategory finished!"
	
	quit
}

ClassMethod InitOcrCategory(ADesc, AName) As %Boolean
{
	s id = ""
	s flag = ""
	f
	{
		s id = $O(^DHCEPRFS.META.MRItemD(id))
		q:(id="")
		s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(id)
		
		i (obj.Name = AName)
		{
			
			s ocrarrange = obj.OCRArrangeTitle
			s:(ocrarrange = "") obj.OCRArrangeTitle = ADesc
			s:(ocrarrange '= "") obj.OCRArrangeTitle = ocrarrange_"^"_ADesc
			s flag = "1"
			d obj.%Save()
		}
		s obj = ""
		q:(flag '= "")
	}
	q 1
}

ClassMethod Trim()
{
	
	s id = ""
	f
	{
		s id = $O(^DHCEPRFS.META.MRItemD(id))
		q:(id="")
		s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(id)
		s obj.OCRArrangeTitle = ""
		d obj.%Save()
		s obj = ""
	}
}

}
