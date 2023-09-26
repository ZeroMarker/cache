Class EMRservice.Tools.InitStandardDataTool Extends %RegisteredObject
{

/// EMRservice.Tools.InitStandardDataTool
/// 	初始化01
/// Desc:      TemplateCategory
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitTemplateCategory("D:\01_TemplateCategory.txt")
ClassMethod InitTemplateCategory(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.TemplateCategory).%New()
		//Descriptio   Name    ParentID		PropertyCode	PropertyName	ResChildCount
		s obj.Description = $p(sRec, $c(9), 2)
 		s obj.Name = $p(sRec, $c(9), 3)
 		s obj.ParentID = $p(sRec, $c(9), 4)
		s obj.PropertyCode = $p(sRec, $c(9), 5)
		s obj.PropertyName = $p(sRec, $c(9), 6)
		s obj.ResChildCount = $p(sRec, $c(9), 7)

		s isOK = obj.%Save()
	    
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
	w !,"01_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化02
/// Desc:      KBCategory
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitKBCategory("D:\02_01_KBCategory.txt")
ClassMethod InitKBCategory(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.KBCategory).%New()
		//Description	Name	ParentID	ResChildCount
		s obj.Description = $p(sRec, $c(9), 2)
 		s obj.Name = $p(sRec, $c(9), 3)
 		s obj.ParentID = $p(sRec, $c(9), 4)
		s obj.ResChildCount = $p(sRec, $c(9), 5)

		s isOK = obj.%Save()
	    
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
	w !,"02_01_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:      KnowledgeBase
/// Creator:   lfb
/// Createdate:20160226
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitKnowledgeBase("D:\02_02_KnowledgeBase.txt")
ClassMethod InitKnowledgeBase(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.KnowledgeBase).%New()
		//Description	Name	ParentID	ResChildCount
		s obj.Description = $p(sRec, $c(9), 2)
 		s obj.KBCategoryID = $p(sRec, $c(9), 3)
 		s obj.Name = $p(sRec, $c(9), 4)
		
		s isOK = obj.%Save()
	    
	    s objKBCategory=##class(EMRmeta.KBCategory).%OpenId(obj.KBCategoryID)
	    s objKBCategory.ResChildCount=objKBCategory.ResChildCount+1
	    
	    d objKBCategory.%Save()
	    
	    
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
	w !,"02_02_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化03
/// Desc:    初始化病历展现结构目录：EMRmeta.EMRTemplateCategory
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRTemplateCategory("D:\03_01_EMRTemplateCategory.txt")
ClassMethod InitEMRTemplateCategory(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.EMRTemplateCategory).%New()

		//CategoryName	CategorySeq	CategoryType	IsLeadframe	IsMutex		ParentCategoryID
		s obj.CategoryName = $p(sRec, $c(9), 2)
 		s obj.CategorySeq = $p(sRec, $c(9), 3)
		s obj.CategoryType = $p(sRec, $c(9), 4)
		s obj.FullFight = $p(sRec, $c(9), 5)
		s obj.ImageUrl = $p(sRec, $c(9), 6)
		s obj.InternalID= $p(sRec, $c(9), 7)
 		s obj.IsLeadframe = $p(sRec, $c(9), 8)
		s obj.IsMutex = $p(sRec, $c(9), 9)
		s obj.IsWaitsign = $p(sRec, $c(9), 10)
		s obj.JaneSpell = $p(sRec, $c(9), 11)
		s obj.ParentCategoryID = $p(sRec, $c(9), 12)


		s isOK = obj.%Save()
	    
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
	w !,"03_01_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// Desc:    初始化病历展现结构目录：EMRmeta.EMRTemplate
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRTemplate("D:\03_02_EMRTemplate.txt")
ClassMethod InitEMRTemplate(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.EMRTemplate).%New()

		//CategoryName	CategorySeq	CategoryType	IsLeadframe	IsMutex		ParentCategoryID
		s obj.BindTemplateCategoryID = $p(sRec, $c(9), 2)
 		s obj.BindTemplateID = $p(sRec, $c(9), 3)
		s obj.CategoryID = $p(sRec, $c(9), 4)
 		s obj.NecessaryTemplate = $p(sRec, $c(9), 5)
		s obj.PrivRuleDR = $p(sRec, $c(9), 6)
		s obj.TemplateName = $p(sRec, $c(9), 7)
		s obj.TemplateSeq = $p(sRec, $c(9), 8)


		s isOK = obj.%Save()
	    
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
	w !,"03_02_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化04
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRTemplateStructure("D:\04_TemplateStructure.txt")
ClassMethod InitEMRTemplateStructure(argFile As %String)
{
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s obj=##Class(EMRmeta.TemplateStructure).%New()
		s obj.Code=$p(Line,$c(9),2)
		s obj.Description=$p(Line,$c(9),3)
		s obj.IsFixedSection=$p(Line,$c(9),4)
		s obj.Name=$p(Line,$c(9),5)
		s obj.ParentCode=$p(Line,$c(9),6)
		s obj.ParentID=$p(Line,$c(9),7)
		s obj.ResChildCount=$p(Line,$c(9),8)
		s obj.StructType=$p(Line,$c(9),9)
		s obj.MetaTemplate=""
		
		
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	
	s id=""
	for {
		s id=$o(^DHCEMRM.TemplateStructureD(id))
		q:(id="")
		s objts=##class(EMRmeta.TemplateStructure).%OpenId(id)
		continue:(objts="")
		s parid=objts.ParentID
		s parcode=objts.ParentCode
		if (parid="") {
			
			CONTINUE:(parcode="")	
			if ($l(parcode,"^")=1)
			{
				
				s parid=$o(^DHCEMRM.TemplateStructureI("IdxCode"," "_$tr(parcode," ",""),parid))
				s objts.ParentID=parid
				s objts.ParentCode=$tr(parcode," ","")
				d objts.%Save()
				d objts.%Close()
			}
			if ($l(parcode,"^")=2)
			{
				s pdocumentcode = $p(parcode,"^",1)
				s psectioncode = $p(parcode,"^",2)
				
				s pdocumentid=$o(^DHCEMRM.TemplateStructureI("IdxCode"," "_$tr(pdocumentcode," ",""),""))
				
				s tmppsectionid=""
				for {
					s tmppsectionid=$o(^DHCEMRM.TemplateStructureI("IdxCode"," "_$tr(psectioncode," ",""),tmppsectionid))
					q:(tmppsectionid="")
					
					s tmpsectionobj=##class(EMRmeta.TemplateStructure).%OpenId(tmppsectionid)
					s tmppdocid=tmpsectionobj.ParentID
					continue:(tmppdocid'= pdocumentid)
					s parid=tmppsectionid
					
				}
				s objts.ParentID=parid
				s objts.ParentCode=$tr(parcode," ","")
				d objts.%Save()
				d objts.%Close()
			}
			
		} 
		
		if (parcode="") {
			
			CONTINUE:(parid="")||(parid=0)
			s parobj=##class(EMRmeta.TemplateStructure).%OpenId(parid)
			continue:(parobj="")
			s pobjcode=parobj.Code
			s objts.ParentCode=pobjcode
			d objts.%Save()
			d objts.%Close()
			d parobj.%Close()
			s parobj=""
			
		} 
		
	}
	w !,"04_Summary: "_FileCnt_" rows imported"
	quit
}

/// 	初始化05
/// Desc:      SysOption
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitSysOption("D:\05_SysOption.txt")
ClassMethod InitSysOption(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.SysOption).%New()
		//Description	IsVisible	IsEditor	Name	OptionValue
		s obj.Description = $p(sRec, $c(9), 2)
		s obj.IsEditor = $p(sRec, $c(9), 3)
 		s obj.IsVisible = $p(sRec, $c(9), 4)
 		s obj.Name = $p(sRec, $c(9), 5)
		s obj.OptionValue = $p(sRec, $c(9), 6)

		s isOK = obj.%Save()
	    
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
	w !,"05_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化06
/// Desc:      StdDictionary
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitStdDictionary("D:\06_StdDictionary.txt")
ClassMethod InitStdDictionary(argFile As %String)
{
	k ^DHCEMRM.StdDictionaryD,^DHCEMRM.StdDictionaryI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.StdDictionary).%New()
		//Code	Condition	ConditionCode	Description	DicAliasCol	DicCodeCol	DicDescCol	IsDiagnosRuleType	IsRuleType	Name	RuleTypeTag	Sequence	TableName
		//net端维护程序对空值做处理，所以将字段处理成$c(0)
		s obj.Code = $p(sRec, $c(9), 2)
 		s obj.Condition = $s($p(sRec, $c(9), 3)="":$c(0),1:$p(sRec, $c(9), 3))
 		s obj.ConditionCode = $s($p(sRec, $c(9), 4)="":$c(0),1:$p(sRec, $c(9), 4))
		s obj.Description = $p(sRec, $c(9), 5)
		s obj.DicAliasCol = $s($p(sRec, $c(9), 6)="":$c(0),1:$p(sRec, $c(9), 6))
 		s obj.DicCodeCol = $p(sRec, $c(9), 7)
 		s obj.DicDescCol = $p(sRec, $c(9), 8)
		s obj.IsDiagnosRuleType = $p(sRec, $c(9), 9)
		s obj.IsRuleType = $s($p(sRec, $c(9), 10)="":$c(0),1:$p(sRec, $c(9), 10))
 		s obj.Name = $p(sRec, $c(9), 11)
 		s obj.RuleTypeTag = $s($p(sRec, $c(9), 12)="":$c(0),1:$p(sRec, $c(9), 12))
		s obj.Sequence = $p(sRec, $c(9), 13)
		s obj.TableName = $p(sRec, $c(9), 14)

		s isOK = obj.%Save()
	    
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
	w !,"06_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化07
/// Desc:      BlindSysData
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitBlindSysData("D:\07_BlindSysData.txt")
ClassMethod InitBlindSysData(argFile As %String)
{
	//清除Global
	k ^DHCEMRM.BindQueryD,^DHCEMRM.BindQueryI,^DHCEMRM.BindQueryS
	k ^DHCEMRM.BindParameterD,^DHCEMRM.BindParameterI,^DHCEMRM.BindParameterS
	k ^DHCEMRM.BindFieldD,^DHCEMRM.BindFieldI,^DHCEMRM.BindFieldS
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s Flag=$p(sRec, $c(9), 1)
		i (Flag="EMRmeta.BindQuery"){
			s obj = ##Class(EMRmeta.BindQuery).%New()
			//ClassName	Description	Mark	Name	QueryName	SingleResult
			s obj.ClassName = $p(sRec, $c(9), 3)
			s obj.Description = $p(sRec, $c(9), 4)
			s obj.Mark = $p(sRec, $c(9), 5)
			s obj.Name = $p(sRec, $c(9), 6)
			s obj.QueryName = $p(sRec, $c(9), 7)
			s obj.SingleResult = $p(sRec, $c(9), 8)

			s isOK = obj.%Save()
		    
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

		i (Flag="EMRmeta.BindParameter"){
			s obj = ##Class(EMRmeta.BindParameter).%New()
			//Description	Name	ParameterName	ParameterType	QueryID
			s obj.Description = $p(sRec, $c(9), 3)
			s obj.Name = $p(sRec, $c(9), 4)
			s obj.ParameterName = $p(sRec, $c(9), 5)
			s obj.ParameterType = $p(sRec, $c(9), 6)
			s obj.QueryID = $p(sRec, $c(9), 7)

			s isOK = obj.%Save()
		    
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


		i (Flag="EMRmeta.BindField"){
			s obj = ##Class(EMRmeta.BindField).%New()
			//Description	DicID	FieldName	FieldType	Name	QueryID
			s obj.Description = $p(sRec, $c(9), 3)
			s obj.DicID = $p(sRec, $c(9), 4)
			s obj.FieldName = $p(sRec, $c(9), 5)
			s obj.FieldType = $p(sRec, $c(9), 6)
			s obj.Name = $p(sRec, $c(9), 7)
			s obj.QueryID = $p(sRec, $c(9), 8)
			s obj.ValueType=$p(sRec, $c(9), 9)

			s isOK = obj.%Save()
		    
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
	}
	w !,"07_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化08
/// Desc:     界面模板目录类型：EMRmeta.CategoryType
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitCategoryType("D:\08_CategoryType.txt")
ClassMethod InitCategoryType(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.CategoryType).%New()

		//TypeDescription	TypeName
		s obj.TypeDescription = $p(sRec, $c(9), 2)
 		s obj.TypeName = $p(sRec, $c(9), 3)


		s isOK = obj.%Save()
	    
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
	w !,"08_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化09
/// Desc:     就诊数据项：EpisodeDataItem
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEpisodeDataItem("D:\09_EpisodeDataItem.txt")
ClassMethod InitEpisodeDataItem(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.EpisodeDataItem).%New()
		//DataType	Description	FieldName	Name
		s obj.DataType = $p(sRec, $c(9), 2)
 		s obj.Description = $p(sRec, $c(9), 3)
		s obj.FieldName = $p(sRec, $c(9), 4)
 		s obj.Name = $p(sRec, $c(9), 5)


		s isOK = obj.%Save()
	    
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
	w !,"09_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/*
/// Desc:     界面模板目录类型：EMRmeta.CategoryType
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitCategoryType("D:\CategoryType.txt")
ClassMethod InitCategoryType(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.CategoryType).%New()

		//TypeDescription	TypeName
		s obj.TypeDescription = $p(sRec, $c(9), 1)
 		s obj.TypeName = $p(sRec, $c(9), 2)


		s isOK = obj.%Save()
	    
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
	w !,"Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

*/
/// 	初始化10
/// 	初始化11
/// Desc:    界面模板目录属性：EMRmeta.CTProperty
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitCTProperty("D:\11_CTProperty.txt")
ClassMethod InitCTProperty(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.CTProperty).%New()

		//ParentID	PropertyCode	PropertyName 
		s obj.ParentID = $p(sRec, $c(9), 2)
 		s obj.PropertyCode = $p(sRec, $c(9), 3)
		s obj.PropertyName = $p(sRec, $c(9), 4)

		s isOK = obj.%Save()
	    
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
	w !,"11_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化12
/// Desc:     页面引用设置：EMRmeta.EPRPageURL
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEPRPageURL("D:\12_EPRPageURL.txt")
ClassMethod InitEPRPageURL(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.EPRPageURL).%New()
		//Num Paras Title URL 
		s obj.Num = $p(sRec, $c(9), 2)
 		s obj.Paras = $p(sRec, $c(9), 3)
		s obj.Title = $p(sRec, $c(9), 4)
 		s obj.URL = $p(sRec, $c(9), 5)


		s isOK = obj.%Save()
	    
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
	w !,"12_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化13
/// Desc:    界面模板目录属性：EMRmeta.PrivRuleType
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitPrivRuleType("D:\13_PrivRuleType.txt")
ClassMethod InitPrivRuleType(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.PrivRuleType).%New()

		//Description Name 
		s obj.Description = $p(sRec, $c(9), 2)
 		s obj.Name  = $p(sRec, $c(9), 3)

		s isOK = obj.%Save()
	    
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
	w !,"13_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化14
/// Desc:      初始化标题表配置表
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitTitlesTitleConfig("D:\14_TitlesTitleConfig.txt")
ClassMethod InitTitlesTitleConfig(argFile As %String)
{
	k ^DHCEMRM.TitleCategoryD
	k ^DHCEMRM.TitleCategoryI
	k ^DHCEMRM.TitleCategoryS
	k ^DHCEMRM.TitlesD
	k ^DHCEMRM.TitlesI
	k ^DHCEMRM.TitlesS
	k ^DHCEMRM.TitleConfigD
	k ^DHCEMRM.TitleConfigI
	k ^DHCEMRM.TitleConfigS
	k ^DHCEMRM.TitleColConfigI
	k ^DHCEMRM.TitleColConfigS	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0,totconfigcount=0


	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s Flag=$p(sRec, $c(9), 1)
		
		i (Flag="EMRmeta.TitleCategory"){
			s objTC = ##Class(EMRmeta.TitleCategory).%New()
			//TitleCategoryName TitleCategoryType TitleParentCategoryID 
 			s objTC.TitleCategoryName = $p(sRec, $c(9), 3)
 			s objTC.TitleCategoryType = $p(sRec, $c(9), 4)
			//s objTC.TitleParentCategoryID = $p(sRec, $c(9), 5)
			s objTC.PropertyParams=$p(sRec, $c(9), 5)
			s isOK = objTC.%Save()
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
		i (Flag="EMRmeta.Titles"){
			s objTT = ##Class(EMRmeta.Titles).%New()
			//Alias		Code	Description
 			s objTT.Alias = $p(sRec, $c(9), 3)
 			s objTT.Code = $p(sRec, $c(9), 4)
			s objTT.Description = $p(sRec, $c(9), 5)

			s isOK = objTT.%Save()
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
		i (Flag="EMRmeta.TitleConfig"){
			s objTCfg = ##Class(EMRmeta.TitleConfig).%New()
			//AutoLoad  CategoryID	GroupID PageBreak	Sequence  TitleCode	Align  Format	LineBreak	ReadOnly SeqNum 	Type Visible	Align  Format	LineBreak	ReadOnly SeqNum 	Type Visible
			s objTCfg.AutoLoad = $p(sRec, $c(9), 3)
			s objTCfg.CategoryID = $p(sRec, $c(9), 4)
			s objTCfg.GroupID = $p(sRec, $c(9), 5)
			s objTCfg.PageBreak = $p(sRec, $c(9), 6)
			s objTCfg.Sequence = $p(sRec, $c(9), 7)
			s objTCfg.TemplateID = $p(sRec, $c(9), 8)
			s objTCfg.TitleCode = $p(sRec, $c(9), 9)
			s objTCfg.UniqueCreate=$p(sRec, $c(9), 10)
			
			s $zt = "ECRecordErrorHandler"
			Tstart
			s sc = objTCfg.%Save()
			if ($$$ISOK(sc))
			{
				//Align  Format	LineBreak	ReadOnly SeqNum 	Type Visible	
				s c1obj = ##Class(EMRmeta.TitleColConfig).%New()
				s c1obj.Align = $p(sRec, $c(9), 11)
				s c1obj.FontStyle = $p(sRec, $c(9), 12)
				s c1obj.Format = $p(sRec, $c(9), 13)
				s c1obj.LineBreak = $p(sRec, $c(9), 14)
				s c1obj.Params = $p(sRec, $c(9), 15)
				s c1obj.ReadOnly = $p(sRec, $c(9), 16)
				s c1obj.SeqNum = $p(sRec, $c(9), 17)
				s c1obj.Type = $p(sRec, $c(9), 18)
				s c1obj.Visible = $p(sRec, $c(9), 19)
				s c1obj.TitleConfig = objTCfg
				s c1sc = c1obj.%Save()
				if ($$$ISOK(c1sc))
				{

					s c2obj = ##Class(EMRmeta.TitleColConfig).%New()
					s c2obj.Align = $p(sRec, $c(9), 20)
					s c2obj.FontStyle = $p(sRec, $c(9), 21)
					s c2obj.Format = $p(sRec, $c(9), 22)
					s c2obj.LineBreak = $p(sRec, $c(9), 23)
					s c1obj.Params = $p(sRec, $c(9), 24)
					s c2obj.ReadOnly = $p(sRec, $c(9), 25)
					s c2obj.SeqNum = $p(sRec, $c(9), 26)
					s c2obj.Type = $p(sRec, $c(9), 27)
					s c2obj.Visible = $p(sRec, $c(9), 28)
					s c2obj.TitleConfig = objTCfg
					s c2sc = c2obj.%Save()
					if ($$$ISOK(c2sc))
					{
						 TCOMMIT
					}else
					{
						Trollback
					}
				}else
				{
					Trollback
				}
				s okCount = okCount + 1
			}else
			{
				s failCount = failCount + 1
			}
		}

	}
	w !,"14_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
ECRecordErrorHandler
    Trollback
}

/// 	初始化15
/// Desc:     病历状态：EMRmeta.EMRStatus
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRStatus("D:\15_EMRStatus.txt")
ClassMethod InitEMRStatus(argFile As %String)
{
	k ^DHCEMRM.EMRStatusD,^DHCEMRM.EMRStatusI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.EMRStatus).%New()

		//StatusCode	StatusName
		s obj.StatusCode = $p(sRec, $c(9), 2)
 		s obj.StatusName = $p(sRec, $c(9), 3)


		s isOK = obj.%Save()
	    
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
	w !,"15_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化16
/// EMRmeta.EMRAction
/// Desc:     病历状态：EMRmeta.EMRAction
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRAction("D:\16_EMRAction.txt")
ClassMethod InitEMRAction(argFile As %String)
{
	k ^DHCEMRM.EMRActionD,^DHCEMRM.EMRActionI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.EMRAction).%New()

		//ActionCode	ActionName
		s obj.ActionCode = $p(sRec, $c(9), 2)
 		s obj.ActionName = $p(sRec, $c(9), 3)


		s isOK = obj.%Save()
	    
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
	w !,"16_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化17
/// EMRmeta.EMRActStatusCfg 
/// Desc:     病历状态与操作：EMRmeta.EMRActStatusCfg 
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRActStatusCfg("D:\17_EMRActStatusCfg.txt")
ClassMethod InitEMRActStatusCfg(argFile As %String)
{
	k ^DHCEMRM.EMRActStatusCfgD,^DHCEMRM.EMRActStatusCfgI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.EMRActStatusCfg).%New()

		//EMRAction	PostStatus	PreStatus
		s obj.EMRAction = $p(sRec, $c(9), 2)
 		s obj.PostStatus = $p(sRec, $c(9), 3)
		s obj.PreStatus = $p(sRec, $c(9), 4)


		s isOK = obj.%Save()
	    
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
	w !,"17_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化18
/// Desc:     维护程序系统功能项定义表：EMRmeta.MainDictFunction
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitMainDictFunction("D:\18_MainDictFunction.txt")
ClassMethod InitMainDictFunction(argFile As %String)
{
	if (argFile = "")
	{
		w "文件名为空"
		q
	}
	k ^DHCEMRM.MainDictFunctionI
	k ^DHCEMRM.MainDictFunctionD
	k ^DHCEMRM.MainRoleFunctionD
	k ^DHCEMRM.MainRoleFunctionI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.MainDictFunction).%New()

				//FuncName	FuncDesc	ParentID	Type	Notes
		s obj.FuncName = $p(sRec, $c(9), 2)
 		s obj.FuncDesc = $p(sRec, $c(9), 3)
		s obj.ParentID = $p(sRec, $c(9), 4)
		s obj.Type = $p(sRec, $c(9), 5)
		s obj.Notes = $p(sRec, $c(9), 6)


		s isOK = obj.%Save()
	    
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
	w !,"18_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化19
/// Desc:     用户角色：EMRmeta.MainRole
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitMainRole("D:\19_MainRole.txt")
ClassMethod InitMainRole(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.MainRole).%New()

		//RoleDesc RoleName 
		s obj.RoleDesc = $p(sRec, $c(9), 2)
 		s obj.RoleName = $p(sRec, $c(9), 3)


		s isOK = obj.%Save()
	    
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
	w !,"19_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化20
/// Desc:     角色权限维护：EMRmeta.MainRoleFunction
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitMainRoleFunction("D:\20_MainRoleFunction.txt")
ClassMethod InitMainRoleFunction(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.MainRoleFunction).%New()

		//DataFrom	DataTo	FuncName	RoleID
		s obj.DataFrom = $p(sRec, $c(9), 2)
 		s obj.DataTo = $p(sRec, $c(9), 3)
		s obj.FuncName = $p(sRec, $c(9), 4)
 		s obj.RoleID = $p(sRec, $c(9), 5)


		s isOK = obj.%Save()
	    
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
	w !,"20_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化21
/// 	初始化22
/// Desc:   
/// Creator:   lfb
/// Createdate:20140513
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitPrivRuleList("D:\22_PrivRuleList.txt")
ClassMethod InitPrivRuleList(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.PrivRuleList).%New()

		//RuleDesc RuleName RuleType 
		s obj.RuleDesc = $p(sRec, $c(9), 2)
 		s obj.RuleName = $p(sRec, $c(9), 3)
		s obj.RuleType = $p(sRec, $c(9), 4)

		s isOK = obj.%Save()
	    
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
	w !,"22_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化23
/// 	初始化24
/// Desc:		初始化Item 主要字段(EMRTemplateCategoryID,ItemCode,ItemName,ItemParas,ItemTitle,ItemURL)
///             将以上字段内容写进txt文本,以tab键分隔 
/// Creaotr:	Candy
/// CreateDate:	2014-8-29
/// Input：     txt文本名称
/// Debug: d ##Class(EMRservice.Tools.InitStandardDataTool).InitSchemeItem("D:\24_SchemeItem.txt")
ClassMethod InitSchemeItem(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		s sRec = Stream.ReadLine()
		s sRec = $tr(sRec,$c(13),"")
		
		continue:(sRec = "")
		
		s obj = ##Class(EMRmeta.CTOrganizationSchemeItem).%New()
		s obj.EMRTemplateCategoryID = $p(sRec, $c(9), 2)
		s obj.EndDate=""
		s obj.EndTime=""
		s obj.imagePath=$p(sRec, $c(9), 3)
		s obj.ItemCode = $p(sRec, $c(9), 4)
		s obj.ItemName = $p(sRec, $c(9), 5)
		s obj.ItemParas = $p(sRec, $c(9), 6)
		s obj.ItemTitle = $p(sRec, $c(9), 7)
		s obj.ItemURL = $p(sRec, $c(9), 8)
		s obj.StartDate = +$h
		s obj.StartTime = $p($h,",",2)
		s isOK = obj.%Save()
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
	w !,"24_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
}

/// 	初始化25
/// Desc: 	初始化Scheme
/// 		EMRmeta.EMROrganizationScheme表 内容为(CreateUserID,SchemSeq,SchemeCode,SchemeName)
/// 		EMRmeta.EMROrganizationSchemeType表 内容为(SchemeName)
/// 		EMRmeta.EMROrganizationSchemeDetails表 内容为(ItemCode,ItemDr,ItemName,ItemSeq)
/// 		初始化内容格式为：第一列表类型，第一行父表(EMRmeta.EMROrganizationScheme)类型为scheme
/// 		第二行为 类型表(EMRmeta.EMROrganizationSchemeType)类型为type,
/// 		第三行为 明细表(EMRmeta.EMROrganizationSchemeDetails)类型为detial,若干行
/// 		接着为第二种类型表内容,明细
/// 		多个方案以此类推   
/// Creator:Candy
/// Date:	2014-8-29              
/// Debug: 	d ##Class(EMRservice.Tools.InitStandardDataTool).InitScheme("D:\25_Scheme.txt")
ClassMethod InitScheme(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		s sRec = Stream.ReadLine()
		s sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s type = $p(sRec, $c(9), 1)
		if (type = "scheme")
		{
			s objScheme = ##Class(EMRmeta.EMROrganizationScheme).%New()
			s objScheme.CreateDate=+$h
			s objScheme.CreateTime=$p($h,",",2)
			
			s objScheme.CreateUserID = $p(sRec, $c(9), 3)
			s objScheme.SchemSeq = $p(sRec, $c(9), 4)
			s objScheme.SchemeCode = $p(sRec, $c(9), 5)
			s objScheme.SchemeName = $p(sRec, $c(9), 6)
			
			s isOK = objScheme.%Save()
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
		elseif (type = "type")
		{
			s TypeParID=$p($p(sRec, $c(9), 2),"||",1)
			
			s objScheme = ##Class(EMRmeta.EMROrganizationScheme).%OpenId(TypeParID)
			continue:(objScheme = "")
			s objType = ##Class(EMRmeta.EMROrganizationSchemeType).%New()
			s objType.SchemType = $p(sRec, $c(9), 3)
			s objType.ParScheme = objScheme
			
			s isOK = objType.%Save()
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
		elseif(type = "detail")
		{
			s DetParID=$p($p(sRec, $c(9), 2),"||",1,2)
			s objType = ##Class(EMRmeta.EMROrganizationSchemeType).%OpenId(DetParID)
			continue:(objType = "")
			s objDetial = ##Class(EMRmeta.EMROrganizationSchemeDetails).%New()
			s objDetial.ItemCode = $p(sRec, $c(9), 3)
			s objDetial.ItemDr =  $p(sRec, $c(9), 4)
			s objDetial.ItemName = $p(sRec, $c(9), 5)
			s objDetial.ItemSeq = $p(sRec, $c(9), 6)
			s objDetial.ParSchemeType = objType
			
			s isOK = objDetial.%Save()
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
	}
	w !,"25_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
}

/// 	初始化26
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRCommonEleValues("D:\26_CommonEleValues.txt")
ClassMethod InitEMRCommonEleValues(argFile As %String)
{
	s totCount=0,okCount=0,failCount=0
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		//w Line,!
		s obj=##class(EMRmeta.CommonEleValues).%New()
		
		s obj.AllowCodeNull=$p(Line,$c(9),2)
	    s obj.AllowEdit=$p(Line,$c(9),3)
	    s obj.AllowNull=$p(Line,$c(9),4)
	    s obj.AllowValueNull=$p(Line,$c(9),5)
	    s obj.AssociateItem=$p(Line,$c(9),6)
	    s obj.BindCode=$p(Line,$c(9),7)
	    s obj.BindType=$p(Line,$c(9),8)
	    s obj.CheckedPrefix=$p(Line,$c(9),9)
	    s obj.Choices=$p(Line,$c(9),10)
	    s obj.Code=$p(Line,$c(9),11)
	    s obj.CodeSystem=$p(Line,$c(9),12)
	    s obj.CodeSystemName=$p(Line,$c(9),13)
	    s obj.ConfidentialityCode=$p(Line,$c(9),14)
	    s obj.CustDicClassName=$p(Line,$c(9),15)
	    s obj.DateFormat=$p(Line,$c(9),16)
	    s obj.DecimalPlace=$p(Line,$c(9),17)
	    s obj.Description=$p(Line,$c(9),18)
	    s obj.DictionaryType=$p(Line,$c(9),19)
	    s obj.DisplayName=$p(Line,$c(9),20)
	    s obj.DisplayType=$p(Line,$c(9),21)
	    s obj.DynamicField=$p(Line,$c(9),22)
	    s obj.ElemType=$p(Line,$c(9),23)
	    s obj.FirstColType=$p(Line,$c(9),24)
	    s obj.FixedStructs=$p(Line,$c(9),25)
	    s obj.HasMaxVal=$p(Line,$c(9),26)
	    s obj.HasMinVal=$p(Line,$c(9),27)
	    s obj.IncludeDate=$p(Line,$c(9),28)
	    s obj.IncludeMax=$p(Line,$c(9),29)
	    s obj.IncludeMin=$p(Line,$c(9),30)
	    s obj.IncludeTime=$p(Line,$c(9),31)
	    s obj.LinkCode=$p(Line,$c(9),32)
	    s obj.LinkDisplayType=$p(Line,$c(9),33)
	    s obj.LinkMethod=$p(Line,$c(9),34)
	    s obj.MaxLength=$p(Line,$c(9),35)
	    s obj.MaxVal=$p(Line,$c(9),36)
	    s obj.MinVal=$p(Line,$c(9),37)
	    s obj.OneByOneLink=$p(Line,$c(9),38)
	    s obj.ReadOnly=$p(Line,$c(9),39)
	    s obj.RegExp=$p(Line,$c(9),40)
	    s obj.SecondColType=$p(Line,$c(9),41)
	    s obj.SectionCode=$p(Line,$c(9),42)
	    s obj.SectionName=$p(Line,$c(9),43)
	    s obj.Separator=$p(Line,$c(9),44)
	    s obj.ShowSignerDescription=$p(Line,$c(9),45)
	    s obj.ShowUnChecked=$p(Line,$c(9),46)
	    s obj.SignatureLevel=$p(Line,$c(9),47)
	    s obj.Synch=$p(Line,$c(9),48)
	    s obj.TabIndex=$p(Line,$c(9),49)
	    s obj.TemplateCode=$p(Line,$c(9),50)
	    s obj.TemplateName=$p(Line,$c(9),51)
	    s obj.ThirdColType=$p(Line,$c(9),52)
	    s obj.TimeFormat=$p(Line,$c(9),53)
	    s obj.UncheckedPrefix=$p(Line,$c(9),54)
	    s obj.Url=$p(Line,$c(9),55)
	    s obj.ValidateMsg=$p(Line,$c(9),56)
	    s obj.Visible=$p(Line,$c(9),57)
	    s obj.WrapChoice=$p(Line,$c(9),58)
		s obj.WriteBack=$p(Line,$c(9),59)
		 
		s isOK = obj.%Save()
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
	w !,"26_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化27
/// EMRmeta.Events.EventType
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEventType("D:\27_EventType.txt")
ClassMethod InitEventType(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.Events.EventType).%New()

		//RuleDesc RuleName RuleType 
		s obj.TypeCode = $p(sRec, $c(9), 2)
 		s obj.TypeDesc = $p(sRec, $c(9), 3)

		s isOK = obj.%Save()
	    
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
	w !,"27_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化28
/// EMRmeta.Events.EventConfig
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEventConfig("D:\28_EventConfig.txt")
ClassMethod InitEventConfig(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.Events.EventConfig).%New()

		//RuleDesc RuleName RuleType 
 		s obj.EventType = $p(sRec, $c(9), 2)
		s obj.LinkDocID = $p(sRec, $c(9), 3)
		s obj.LinkTitleCode = $p(sRec, $c(9), 4)
		s obj.Location = $p(sRec, $c(9), 5)
		s obj.PromptMessage = $p(sRec, $c(9), 6)
		s obj.Scheme = $p(sRec, $c(9), 7)

		s isOK = obj.%Save()
	    
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
	w !,"28_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化29
/// EMRmeta.Events.EventConfig
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitUserPost("D:\29_UserPost.txt")
ClassMethod InitUserPost(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.UserPost).%New()

		//RuleDesc RuleName RuleType 
 		s obj.Description = $p(sRec, $c(9), 2)
		s obj.IsValid = $p(sRec, $c(9), 3)
		s obj.Name = $p(sRec, $c(9), 4)
		s obj.OperAction = $p(sRec, $c(9), 5)
		
		s isOK = obj.%Save()
	    
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
	w !,"29_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 	初始化30
/// EMRmeta.Events.EventConfig
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEventConfig("D:\30_UserLevel.txt")
ClassMethod InitUserLevel(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.UserLevel).%New()

		//RuleDesc RuleName RuleType 
 		s obj.Description = $p(sRec, $c(9), 2)
		s obj.IsValid = $p(sRec, $c(9), 3)
		s obj.Name = $p(sRec, $c(9), 4)

		s isOK = obj.%Save()
	    
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
	w !,"30_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// 初始化 31
/// Desc:       初始化用户行为Action 码表
/// Creator:    Candy
/// CreateDate: 2015-1-30
/// Debug:      d ##Class(EMRservice.Tools.InitStandardDataTool).InitTraceActions("D:\StandardData\31_TraceActions.txt") 
ClassMethod InitTraceActions(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s total = 0
	s success = 0
	s error = 0
	While 'Stream.AtEnd {
		s sRec = Stream.ReadLine()
		s sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s objAction = ##Class(EMRinstance.Trace.Actions).%New()
		s objAction.ActionCode = $p(sRec, $c(9), 2)
		s objAction.ActionDesc = $p(sRec, $c(9), 3)
		if ($$$ISOK(objAction.%Save()))
		{
			s success = success + 1
		}
		else
		{
			s error = error + 1
		}	
		s total = total + 1
	}
	w "!,31_Summary: "_total_" okCount"_success_" failCount"_error
}

/// 初始化 32
/// Desc:      初始化DHCEPRRBAC.META.PrivateDomainDefinition
/// Creator:   
/// Createdate:
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitPrivateDomainDefinition("D:\StandardData\32_PrivateDomainDefinition.txt")
ClassMethod InitPrivateDomainDefinition(argFile As %String)
{
	k ^DHCEPRRBAC.META.PrivDDFD
	k ^DHCEPRRBAC.META.PrivDDFI
	k ^DHCEPRRBAC.META.PrivDDFS
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(DHCEPRRBAC.META.PrivateDomainDefinition).%New()
		s obj.RPDActive=$p(sRec, $c(9) , 2)
 		s obj.RPDCode=$p(sRec, $c(9) , 3)
		s obj.RPDDesc = $p(sRec, $c(9) , 4)
		s obj.RPDLevel = $p(sRec, $c(9) , 5)
		s obj.RPDName = $p(sRec, $c(9) , 6)

		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""

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
	w !,"32_Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// 初始化 33
/// Desc:      初始化DHCEPRRBAC.META.ItemDefinition。
/// Creator:   
/// Createdate:
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitItemDefinition("D:\StandardData\33_ItemDefinition.txt")
ClassMethod InitItemDefinition(argFile As %String)
{
	
	k ^DHCEPRRBAC.META.ItemDFD
	k ^DHCEPRRBAC.META.ItemDFI
	k ^DHCEPRRBAC.META.ItemDFS
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(DHCEPRRBAC.META.ItemDefinition).%New()
		s obj.ItemActive=$p(sRec, $c(9) , 2)
 		s obj.ItemCode=$p(sRec, $c(9) , 3)
		s obj.ItemDesc = $p(sRec, $c(9) , 4)
 		s obj.ItemName = $p(sRec, $c(9) , 5)
		s obj.ItemType = $p(sRec, $c(9) , 6)

		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""
		
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
	w !,"33_Summary: "_totCount_" okCount:"_okCount_" failCount:"_failCount
	quit
}

/// 初始化 34
/// Desc:      初始化DHCEPRRBAC.META.ItemDefinition。
/// Creator:   
/// Createdate:
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitResourceItem("D:\StandardData\34_ResourceItem.txt")
ClassMethod InitResourceItem(argFile As %String)
{
	
	k ^DHCEPRRBAC.INST.ResourceItemD
	k ^DHCEPRRBAC.INST.ResourceItemI
	k ^DHCEPRRBAC.INST.ResourceItemS
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(DHCEPRRBAC.INST.ResourceItem).%New()
		s obj.IsActive=$p(sRec, $c(9) , 2)
 		s obj.ItemID=$p(sRec, $c(9) , 3)
		s obj.PrivateDomainID = $p(sRec, $c(9) , 4)

		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""

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
	w !,"34_Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// 初始化 35
/// Desc:      初始化DHCEPRRBAC.META.RoleDefinition。
/// Creator:   
/// Createdate:
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitRoleDefinition("D:\StandardData\35_RoleDefinition.txt")
ClassMethod InitRoleDefinition(argFile As %String)
{
	
	k ^DHCEPRRBAC.META.RoleDFD
	k ^DHCEPRRBAC.META.RoleDFI
	k ^DHCEPRRBAC.META.RoleDFS
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(DHCEPRRBAC.META.RoleDefinition).%New()
		s obj.DefaultRole=$p(sRec, $c(9) , 2)
 		s obj.RoleActive=$p(sRec, $c(9) , 3)
		s obj.RoleCode = $p(sRec, $c(9) , 4)
		s obj.RoleDesc = $p(sRec, $c(9) , 5)
		s obj.RoleName = $p(sRec, $c(9) , 6)
	
		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""

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
	w !,"35_Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// 初始化 36
/// Desc:      初始化DHCEPRRBAC.META.OperationDefinition
/// Creator:   
/// Createdate:
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitOperationDefinition("D:\StandardData\36_OperationDefinition.txt")
ClassMethod InitOperationDefinition(argFile As %String)
{
	k ^DHCEPRRBAC.META.OperDFD
	k ^DHCEPRRBAC.META.OperDFI
	k ^DHCEPRRBAC.META.OperDFS
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(DHCEPRRBAC.META.OperationDefinition).%New()
		s obj.DefaultOp=$p(sRec, $c(9) , 2)
 		s obj.OpActive=$p(sRec, $c(9) , 3)
		s obj.OpCode = $p(sRec, $c(9) , 4)
		s obj.OpDesc = $p(sRec, $c(9) , 5)
		s obj.OpName = $p(sRec, $c(9) , 6)
	
		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""

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
	w !,"36_Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// 	初始化37
/// Desc:      初始化DHCEPRRBAC.META.OperationDefinition
/// Creator:   
/// Createdate:
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitDocRestrictionGroup("D:\StandardData\37_DocRestrictionGroup.txt")
ClassMethod InitDocRestrictionGroup(argFile As %String)
{
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(EMRmeta.EMRDocRestriction.DocGroup).%New()
		s obj.GroupName=$p(sRec, $c(9) , 2)
	
		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""

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
	w !,"37_Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// 	初始化38
/// Desc:      初始化EMRmeta.MedicalConceptLocation
/// Creator:   
/// Createdate:
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitMedicalConceptLocation("D:\StandardData\38_MedicalConceptLocation.txt")
ClassMethod InitMedicalConceptLocation(argFile As %String)
{
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(EMRmeta.MedicalConceptLocation).%New()
		s obj.Code=$p(sRec, $c(9) , 2)
		s obj.ConceptCode = $p(sRec, $c(9) , 3)
		s obj.Description = $p(sRec, $c(9) , 4)
		s obj.DisplayName = $p(sRec, $c(9) , 5)
		s obj.SectionCode = $p(sRec, $c(9) , 6)
		s obj.SectionName = $p(sRec, $c(9) , 7)
		s obj.TemplateCode = $p(sRec, $c(9) , 8)
		s obj.TemplateName = $p(sRec, $c(9) , 9)
		
	
		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""

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
	w !,"38_Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// 	初始化39
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitKBTree("D:\StandardData\39_KBTree.txt")
ClassMethod InitKBTree(argFile As %String)
{
	s KnowledgeBaseID="",Stream=""
	s totCount=0,okCount=0,failCount=0
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s count=1
	for {
		s KnowledgeBaseID=$o(^DHCEMRM.KnowledgeBaseD(KnowledgeBaseID))
		q:(KnowledgeBaseID="")
		
		d Stream.Rewind()
		
		While 'Stream.AtEnd {
			Set sRec = Stream.ReadLine()
			Set sRec = $tr(sRec,$c(13),"")
			continue:(sRec = "")
			s obj=##Class(EMRmeta.KBTree).%New()
			
			s treeCode=$p(sRec, $c(9) , 3)
			s obj.Description=treeCode
			s obj.KnowledgeBaseID = KnowledgeBaseID
			s ^tmpKBTree(treeCode)=count
			s obj.Name = $p(sRec, $c(9) , 4)
			s obj.ParentID =$s($l(treeCode,".")=1:0,$l(treeCode,".")=2:^tmpKBTree($p(treeCode,".",1)),$l(treeCode,"."=3):^tmpKBTree($p(treeCode,".",1,2))) 
			
			
			s obj.PersonalKBUserID = ""
			s obj.ResChildCount=0
			s obj.Sequence=count
		
			
			s isOK = obj.%Save()
			d obj.%Close()
			s obj=""
			s count=count+1
				
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
		
	}
	w !,"39_Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// 	初始化40
/// d ##Class(EMRservice.Tools.InitStandardDataTool).setDefaultSpechars()
ClassMethod setDefaultSpechars()
{
	&SQL(delete FROM EMRmeta.SpecharsCategory)
	
	s strtsFH = "特殊符号 ＃ ＠ ＆ ＊ ※ § 〃 № 〓 ○ ● △ ▲ ◎ ☆ ★ ◇ ◆ □ ■ ▽ ▼ ㊣ ℅ ˉ ￣ ＿ ﹉ ﹊ ﹍ ﹎ ﹋ ﹌ ﹟ ﹠ ﹡ ♀ ♂ ⊕ ⊙ ↑ ↓ ← → ↖ ↗ ↙ ↘ ∥ ∣ ／ ＼ ∕ ﹨"
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strtsFH," ",1)
	s objCatagory.CategoryDesc = $p(strtsFH," ",1)
	s objCatagory.Sequence = 1
	s IDCount = $l(strtsFH," ")
	For I=2:1:IDCount
	 {
		S ACode= $P(strtsFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	 }
	 s strbdFH = "标点符号 ， 、 。 ． ； ： ？ ！ ︰ … ‥ ′ ‵ 々 ～ ‖ ˇ ˉ ﹐ ﹑ ﹒ · ﹔ ﹕ ﹖ ﹗ ｜ – ︱ — ︳ ︴ ﹏ （ ） ︵ ︶｛ ｝ ︷ ︸ 〔 〕 ︹ ︺ 【 】 ︻ ︼ 《 》 ︽ ︾ 〈 〉 ︿ ﹀ 「 」 ﹁ ﹂ 『 』 ﹃ ﹄ ﹙ ﹚ ﹛ ﹜ ﹝ ﹞ ‘ ’ "" "" 〝 〞 ˋ ˊ"
	 s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strbdFH," ",1)
	s objCatagory.CategoryDesc = $p(strbdFH," ",1)
	s objCatagory.Sequence = 2
	s IDCount = $l(strbdFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strbdFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	s strdwFH = "单位符号 ° ′ ″ ＄ ￥ 〒 ￠ ￡ ％ ＠ ℃ ℉ ﹩ ﹪ ‰ ﹫ ㏕ ㎜ ㎝ ㎞ ㏎ ㎡ ㎎ ㎏ ㏄ ° ○ ¤"
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strdwFH," ",1)
	s objCatagory.CategoryDesc = $p(strdwFH," ",1)
	s objCatagory.Sequence = 3
	s IDCount = $l(strdwFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strdwFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	s strszFH = "数字符号 ⅰ ⅱ ⅲ ⅳ ⅴ ⅵ ⅶ ⅷ ⅸ ⅹ Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ Ⅺ Ⅻ ⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏ ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗ ⒘ ⒙ ⒚ ⒛ ⑴ ⑵ ⑶ ⑷ ⑸ ⑹ ⑺ ⑻ ⑼ ⑽ ⑾ ⑿ ⒀ ⒁ ⒂ ⒃ ⒄ ⒅ ⒆ ⒇ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ㈠ ㈡ ㈢ ㈣ ㈤ ㈥ ㈦ ㈧ ㈨ ㈩"
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strszFH," ",1)
	s objCatagory.CategoryDesc = $p(strszFH," ",1)
	s objCatagory.Sequence = 4
	s IDCount = $l(strszFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strszFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	s strsxFH = "数学符号 ≈ ≡ ≠ ＝ ≤ ≥ ＜ ＞ ≮ ≯ ∷ ± ＋ － × ÷ ／ ∫ ∮ ∝ ∞ ∧ ∨ ∑ ∏ ∪ ∩ ∈ ∵ ∴ ⊥ ∥ ∠ ⌒ ⊙ ≌ ∽ √ ≦ ≧ ≒ ≡ ﹢ ﹣ ﹤ ﹥ ﹦ ～ ∟ ⊿ ㏒ ㏑" 
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strsxFH," ",1)
	s objCatagory.CategoryDesc = $p(strsxFH," ",1)
	s objCatagory.Sequence = 5
	s IDCount = $l(strsxFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strsxFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	s strxnFH = "希腊子母 α β γ δ ε ζ η θ ι κ λ μ ν ξ ο π ρ σ τ υ φ χ ψ ω Α Β Γ Δ Ε Ζ Η Θ Ι Κ Λ Μ Ν Ξ Ο Π Ρ Σ Τ Υ Φ Χ Ψ Ω"
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strxnFH," ",1)
	s objCatagory.CategoryDesc = $p(strxnFH," ",1)
	s objCatagory.Sequence = 6
	s IDCount = $l(strxnFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strxnFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	s strxnFH = "自定义 ×109/L ×1012/L mmol/L ㎏/㎡ mmHg └1 └2 └3 └4 └5 └6 └7 └8 └I └II └III └IV └V └VI 1┘ 2┘ 3┘ 4┘ 5┘ 6┘ 7┘ 8┘ I┘ II┘ III┘ IV┘ V┘ VI┘ 1┐ 2┐ 3┐ 4┐ 5┐ 6┐ 7┐ 8┐ I┐ II┐ III┐ IV┐ V┐ VI┐ ┌1 ┌2 ┌3 ┌4 ┌5 ┌6 ┌7 ┌8 ┌I ┌II ┌III ┌IV ┌V ┌VI"
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strxnFH," ",1)
	s objCatagory.CategoryDesc = $p(strxnFH," ",1)
	s objCatagory.Sequence = 7
	s IDCount = $l(strxnFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strxnFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	w !,"40_Summary: 完成"
}

/// 	初始化41
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRStructure("D:\41_EMRStructure.txt")
ClassMethod InitEMRStructure(argFile As %String)
{
	//清除Global
	//k ^DHCEMRM.EMRStructureD,^DHCEMRM.EMRStructureI,^DHCEMRM.EMRStructureS
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		
		//处理读出数据包含 $c(13)
		s Line = $p(Line,$c(13),1)
		
		s strCode = $p(Line,$c(9),2)
		s strRowID=$o(^DHCEMRM.EMRStructureI("IdxCode"," "_$tr(strCode," ",""),""))
		continue:(strRowID'="")
		s obj=##Class(EMRmeta.EMRStructure).%New()
		s obj.Code=strCode
		s obj.Description=$p(Line,$c(9),3)
		s obj.GlossaryInternalID = $p(Line,$c(9),4)
		s obj.Name=$p(Line,$c(9),5)
		s obj.ParentCode=$p(Line,$c(9),6)
		s obj.ParentID="0"	//$p(Line,$c(9),7)
		s obj.StructType=$p(Line,$c(9),8)
		
		
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	
	s id=""
	for {
		s id=$o(^DHCEMRM.EMRStructureD(id))
		q:(id="")
		s objts=##class(EMRmeta.EMRStructure).%OpenId(id)
		continue:(objts="")
		s parid=objts.ParentID
		s parcode=objts.ParentCode
		if (parid="")||(parid="0") {
			
			CONTINUE:(parcode="")	
			if ($l(parcode,"^")=1)
			{
				
				s parid=$o(^DHCEMRM.EMRStructureI("IdxCode"," "_$tr(parcode," ",""),parid))
				s objts.ParentID=parid
				s objts.ParentCode=$tr(parcode," ","")
				d objts.%Save()
				d objts.%Close()
			}
			
		} 
		
		if (parcode="") {
			
			CONTINUE:(parid="")||(parid=0)
			s parobj=##class(EMRmeta.EMRStructure).%OpenId(parid)
			continue:(parobj="")
			s pobjcode=parobj.Code
			s objts.ParentCode=pobjcode
			d objts.%Save()
			d objts.%Close()
			d parobj.%Close()
			s parobj=""
			
		} 
		
	}
	w !,"41_Summary: "_FileCnt_" rows imported"
	quit
}

/// EMRmeta.CategoryViewDisplay
/// Desc:     病历目录视图显示：EMRmeta.CategoryViewDisplay
/// Creator:   Lina
/// Createdate:2016-12-26
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitCategoryViewDisplay("D:\43_CategoryViewDisplay.txt")
ClassMethod InitCategoryViewDisplay(argFile As %String)
{
	k ^DHCEMRM.CategoryViewDisplayD,^DHCEMRM.CategoryViewDisplayI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.CategoryViewDisplay).%New()

		//ViewDisplayId	ViewDisplayDesc
		s obj.ViewDisplayId = $p(sRec, $c(9), 1)
 		s obj.ViewDisplayDesc = $p(sRec, $c(9), 2)
        s obj.ViewDisplayType = $p(sRec, $c(9), 3)

		s isOK = obj.%Save()
	    
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
	w "Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

ClassMethod InitEMRProduct(argFile As %String)
{
	K ^DHCEMRM.EMRProductD
	K ^DHCEMRM.EMRProductI
	K ^DHCEMRM.EMRProductS
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()

		s obj=##Class(EMRmeta.EMRProduct).%New()
		s obj.ProductCode=$p(Line,$c(9),2)
		s obj.ProductName=$p(Line,$c(9),3)

		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}

	
	w !,"46_Summary: "_FileCnt_" rows imported"
	quit
}

ClassMethod InitOPUnitLink(argFile As %String)
{
	K ^DHCEMRM.OPUnitLinkD
	K ^DHCEMRM.OPUnitLinkI
	K ^DHCEMRM.OPUnitLinkS
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()

		s obj=##Class(EMRmeta.OPUnitLink).%New()
		s obj.IsDirectOpen = $p(Line,$c(9),2)
		s obj.Link = $p(Line,$c(9),3)
		s obj.Method=$p(Line,$c(9),4)
		s obj.Name = $p(Line,$c(9),5)
		s obj.Scheme =$p(Line,$c(9),6)
		s obj.Title = $p(Line,$c(9),7)


		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}

	
	w !,"50_Summary: "_FileCnt_" rows imported"
	quit
}

/// EMRmeta.ToothPosition
/// Desc:     牙位表：EMRmeta.ToothPosition
/// Creator:   yejian
/// Createdate:2018-1-31
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitToothPosition("D:\57_ToothPosition.txt")
ClassMethod InitToothPosition(argFile As %String)
{
	k ^DHCEMRM.ToothPositionD,^DHCEMRM.ToothPositionI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.ToothPosition).%New()

		//ViewDisplayId	ViewDisplayDesc
		s obj.ToothPCode = $p(sRec, $c(9), 2)
		s obj.ToothPDefine = $p(sRec, $c(9), 3)
 		s obj.ToothPDes = $p(sRec, $c(9), 4)
 		s obj.ToothPQuadrant = $p(sRec, $c(9), 5)
        s obj.ToothType = $p(sRec, $c(9), 6)
		continue:(obj.ToothPCode ="")
		s isOK = obj.%Save()
	    
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
	w "57_Summary_ToothPosition: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// EMRmeta.ToothSurface
/// Desc:     牙面表：EMRmeta.ToothSurface
/// Creator:   yejian
/// Createdate:2018-1-31
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitToothSurface("D:\57_ToothSurface.txt")
ClassMethod InitToothSurface(argFile As %String)
{
	k ^DHCEMRM.ToothSurfaceD,^DHCEMRM.ToothSurfaceI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.ToothSurface).%New()

		//ViewDisplayId	ViewDisplayDesc
		s obj.ToothSCode = $p(sRec, $c(9), 2)
		s obj.ToothSDefine = $p(sRec, $c(9), 3)
 		s obj.ToothSDes = $p(sRec, $c(9), 4)
        
		continue:(obj.ToothSCode ="")
		s isOK = obj.%Save()
	    
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
	w !,"57_Summary_ToothSurface: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// EMRmeta.ToothSurfaceItem
/// Desc:     牙面信息：EMRmeta.ToothSurfaceItem
/// Creator:   yejian
/// Createdate:2018-1-31
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitToothSurfaceItem("D:\57_ToothSurfaceItem.txt")
ClassMethod InitToothSurfaceItem(argFile As %String)
{
	k ^DHCEMRM.ToothSurfaceItemD,^DHCEMRM.ToothSurfaceItemI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.ToothSurfaceItem).%New()

		//ViewDisplayId	ViewDisplayDesc
		s obj.ScriptMode = $p(sRec, $c(9), 2)
		s obj.ToothPCode = $p(sRec, $c(9), 3)
		s obj.ToothSICode = $p(sRec, $c(9), 4)
		s obj.ToothSIDefine = $p(sRec, $c(9), 5)
 		s obj.ToothSIDes = $p(sRec, $c(9), 6)
        s obj.ToothType = $p(sRec, $c(9), 7)
		continue:(obj.ToothSICode ="")
		s isOK = obj.%Save()
	    
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
	w !,"57_Summary_ToothSurfaceItem: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// EMRmeta.ToothSurfaceItem
/// Desc:     牙面信息：EMRmeta.ToothSurfaceItem
/// Creator:   yejian
/// Createdate:2018-1-31
/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitToothRepresentItem("D:\57_ToothRepresentItem.txt")
ClassMethod InitToothRepresentItem(argFile As %String)
{
	k ^EMRmeta.ToothRepresentItemD,^EMRmeta.ToothRepresentItemI
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(EMRmeta.ToothRepresentItem).%New()

		//ViewDisplayId	ViewDisplayDesc
		s obj.ToothPCode = $p(sRec, $c(9), 2)
		s obj.ToothRepresent = $p(sRec, $c(9), 3)
		s obj.ToothPDes = $p(sRec, $c(9), 4)
		s obj.ToothPQuadrant = $p(sRec, $c(9), 5)
		continue:(obj.ToothPCode ="")
		s isOK = obj.%Save()
	    
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
	w !,"57_Summary_ToothRepresentItem: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitAllStandardData()
ClassMethod InitAllStandardData()
{
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitTemplateCategory("D:\StandardData\01_TemplateCategory.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitKBCategory("D:\StandardData\02_01_KBCategory.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitKnowledgeBase("D:\StandardData\02_02_KnowledgeBase.txt")
	 
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRTemplateCategory("D:\StandardData\03_01_EMRTemplateCategory.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRTemplate("D:\StandardData\03_02_EMRTemplate.txt")
	 
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRTemplateStructure("D:\StandardData\04_TemplateStructure.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitSysOption("D:\StandardData\05_SysOption.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitStdDictionary("D:\StandardData\06_StdDictionary.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitBlindSysData("D:\StandardData\07_BlindSysData.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitCategoryType("D:\StandardData\08_CategoryType.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEpisodeDataItem("D:\StandardData\09_EpisodeDataItem.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitCTProperty("D:\StandardData\11_CTProperty.txt")
	
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEPRPageURL("D:\StandardData\12_EPRPageURL.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitPrivRuleType("D:\StandardData\13_PrivRuleType.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitTitlesTitleConfig("D:\StandardData\14_TitlesTitleConfig.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRStatus("D:\StandardData\15_EMRStatus.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRAction("D:\StandardData\16_EMRAction.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRActStatusCfg("D:\StandardData\17_EMRActStatusCfg.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitMainDictFunction("D:\StandardData\18_MainDictFunction.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitMainRole("D:\StandardData\19_MainRole.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitMainRoleFunction("D:\StandardData\20_MainRoleFunction.txt")
	
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitPrivRuleList("D:\StandardData\22_PrivRuleList.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitSchemeItem("D:\StandardData\24_SchemeItem.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitScheme("D:\StandardData\25_Scheme.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRCommonEleValues("D:\StandardData\26_CommonEleValues.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEventType("D:\StandardData\27_EventType.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEventConfig("D:\StandardData\28_EventConfig.txt")
	
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitUserPost("D:\StandardData\29_UserPost.txt")	
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitUserLevel("D:\StandardData\30_UserLevel.txt")
	
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitTraceActions("D:\StandardData\31_TraceActions.txt")
	
	
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitPrivateDomainDefinition("D:\StandardData\32_PrivateDomainDefinition.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitItemDefinition("D:\StandardData\33_ItemDefinition.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitResourceItem("D:\StandardData\34_ResourceItem.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitRoleDefinition("D:\StandardData\35_RoleDefinition.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitOperationDefinition("D:\StandardData\36_OperationDefinition.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitDocRestrictionGroup("D:\StandardData\37_DocRestrictionGroup.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitMedicalConceptLocation("D:\StandardData\38_MedicalConceptLocation.txt")
	
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRStructure("D:\StandardData\41_EMRStructure.txt")
	
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitKBTree("D:\StandardData\39_KBTree.txt")
	
	d ##Class(EMRservice.Tools.InitStandardDataTool).setDefaultSpechars()
	d ##Class(EMRservice.BL.BLSignRole).IniData()
	
	//扩充初始化数据范围20201225
	//42初始化
	d ##class(EMRservice.BL.BLAuthPrivRuleKey).InitRiveRuleKey()
	//43初始化
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitCategoryViewDisplay("D:\StandardData\43_CategoryViewDisplay.txt")
	//44初始化
	d ##Class(EMRservice.BL.BLConfirmAction).Init()
	//45初始化
	d ##class(EMRmeta.DiagRefStyleData).Init()
	//46初始化
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitEMRProduct("D:\StandardData\46_EMRProduct.txt")
	//47初始化
	d ##Class(EMRservice.BL.GroupSignType).InitData("Chinese")
	d ##Class(EMRservice.BL.GroupSignType).InitData("")
	///48初始化
	d ##Class(EMRservice.BL.IPResource).Init()
	///49初始化
	d ##Class(EMRservice.BL.BLOperationNameBasedProduct).Init()
	///50初始化
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitOPUnitLink("D:\StandardData\50_OPUnitLink.txt")
	///51初始化
	d ##Class(EMRservice.BL.BLPatientDoctor).Init()
	///52初始化
	d ##Class(EMRmeta.OPResource).Init()
	///53初始化
	d ##Class(EMRservice.BL.BLProducts).Init()
	///54初始化
	d ##Class(EMRservice.BL.BLRoleSignRuleList).Init()
	///55初始化
	d ##Class(EMRservice.BL.BLSignRole).IniData()
	///56初始化
	d ##Class(EMRservice.BL.BLSignRoleLinkCarPrvTp).InitData()
	///57初始化
	d ##Class(EMRservice.BL.BLToothPosition).InitData()
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitToothPosition("D:\57_ToothPosition.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitToothSurface("D:\57_ToothSurface.txt")
	d ##Class(EMRservice.Tools.InitStandardDataTool).InitToothSurfaceItem("D:\57_ToothSurfaceItem.txt")
}

/// d ##Class(EMRservice.Tools.InitStandardDataTool).GetMedicalConceptValuesPath()
ClassMethod GetMedicalConceptValuesPath()
{
	s id=""
	for {
		s id = $o(^DHCEMRM.MedConceptLocationD(id))
		q:id=""
		s medlocationobj=##Class(EMRmeta.MedicalConceptLocation).%OpenId(id)
		continue:(medlocationobj="")
		s Code=medlocationobj.Code
		s Name=medlocationobj.DisplayName
		s ConceptCode=medlocationobj.ConceptCode
		s SecName=medlocationobj.SectionName
		s TemplateName=medlocationobj.TemplateName
		s MedCVID=""
		s ConceptCode=$tr(ConceptCode,"MedConCept","MEDCONCEPT")
		s MedCVID=$o(^DHCEMRM.MedConceptVI("IdxCode"," "_ConceptCode,MedCVID))
		
		s MedCVObj=##class(EMRmeta.MedicalConceptValues).%OpenId(MedCVID)
		continue:(MedCVObj="")
		
		s CateID=MedCVObj.CategoryID
		s Name=MedCVObj.DisplayName
		
		s Path=..GetMedicalConceptCatePath(CateID,"")
		
		s PathWay=Path_Name
		
		w !,TemplateName_$c(9)_SecName_$c(9)_Code_$c(9)_Name_$c(9)_ConceptCode_$c(9)_PathWay
		}
}

/// w ##Class(EMRservice.Tools.InitStandardDataTool).GetMedicalConceptCatePath(7,"")
ClassMethod GetMedicalConceptCatePath(MedCateID As %String, APath As %String = "") As %String
{
	
	s objCate=##Class(EMRmeta.MedicalConceptCategory).%OpenId(MedCateID)
	s ParentID=objCate.ParentID
	q:(ParentID=0) "医学概念\"_objCate.Name_"\"_APath
	s Path=objCate.Name_"\"_APath
	s PathWay=..GetMedicalConceptCatePath(ParentID,Path)
	q PathWay
}

/// w ##Class(EMRservice.Tools.InitStandardDataTool).ImportGlossaryCatDataForSP(D:\StandardData\01_TemplateCategory.txt)
ClassMethod ImportGlossaryCatDataForSP(argFile As %String)
{
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(EPRmeta.GlossaryCategory).%New()
		
		s obj.Description=$p(sRec, $c(9) , 2)
		s obj.InternalID = $p(sRec, $c(9) , 3)
		s obj.Name = $p(sRec, $c(9) , 4)
		s obj.ParentID = $p(sRec, $c(9) , 5)
		s obj.ResChildCount = $p(sRec, $c(9) , 6)
		s obj.TemplateCategroyID = $p(sRec, $c(9) , 7)
		
	
		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""

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
	w !,"SP_Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitGlossaryCatDataForSP("D:\StandardData\41_GlossaryCategory.txt")
ClassMethod InitGlossaryCatDataForSP(argFile As %String)
{
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(EPRmeta.GlossaryCategory).%New()
		
		s obj.Description=$p(sRec, $c(9) , 2)
		s obj.InternalID = $p(sRec, $c(9) , 3)
		s obj.Name = $p(sRec, $c(9) , 4)
		s obj.ParentID = $p(sRec, $c(9) , 5)
		s obj.ResChildCount = $p(sRec, $c(9) , 6)
		s obj.TemplateCategroyID = $p(sRec, $c(9) , 7)
		
	
		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""

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
	w !,"SP_Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// d ##class(EMRservice.Tools.InitStandardDataTool).InitPlanTrainSignInfo()
ClassMethod InitPlanTrainSignInfo()
{
	s objSignRole = ##class(EMRmeta.SignRole).%New()
	s objSignRole.ActionCode="PlanTrainCheck"
	s objSignRole.Description="规培医生"
	s objSignRole.IsValid="1"
	s objSignRole.Name="PlanTrain"
	s objSignRole.RoleLevel="0"
	s objSignRole.SignPrefix="1"
	d objSignRole.%Save()
	d objSignRole.%Close()
	
	
	s objEMRAction = ##class(EMRmeta.EMRAction).%New()
	s objEMRAction.ActionCode ="PlanTrainCheck"
	s objEMRAction.ActionName = "规培医生"
	d objEMRAction.%Save()
	d objEMRAction.%Close()
	
	
	s objEMRStatus=##class(EMRmeta.EMRStatus).%New()
	s objEMRStatus.StatusCode="PlanTrainChecked"
	s objEMRStatus.StatusName="规培医师审核"
	d objEMRStatus.%Save()
	d objEMRStatus.%Close()
	
	s objUserLevel=##class(EMRmeta.UserLevel).%New()
	s objUserLevel.Description =  "规培医生"
	s objUserLevel.IsValid = "1"
	s objUserLevel.Name = "PlanTrain"
	d objUserLevel.%Save()
	d objUserLevel.%Close()
	
	
	s PreStatusList = $lb("finished","participantChecked","residentChecked","attendingChecked","chiefChecked","chairmanChecked","chargeNurseChecked","qcdocChecked","qcnurseChecked","refresherChecked","coderChecked","internChecked","studentChecked","patientSigned","viceChiefChecked","checkedRevision")
	
	for i=1:1:$ll(PreStatusList)
	{
		s tmpPreStatus = $list(PreStatusList,i)
		s objActStatusCfg = ##class(EMRmeta.EMRActStatusCfg).%New()
		s objActStatusCfg.EMRAction="PlanTrainCheck"
		s objActStatusCfg.PostStatus="PlanTrainChecked"
		s objActStatusCfg.PreStatus=tmpPreStatus
		d objActStatusCfg.%Save()
		d objActStatusCfg.%Close()
	}
	
	s PostStatusList = $lb("save^checkedRevision","participantCheck^participantChecked","residentCheck^residentChecked","attendingCheck^attendingChecked","viceChiefCheck^viceChiefChecked","chiefCheck^chiefChecked","chairmanCheck^chairmanChecked","chargeNurseCheck^chargeNurseChecked","qcdocCheck^qcdocChecked","qcnurseCheck^qcnurseChecked","refresherCheck^refresherChecked","coderCheck^coderChecked","internCheck^internChecked","studentCheck^studentChecked","delete^deleted","print^PlanTrainChecked","patientSign^patientSigned","PlanTrainCheck^PlanTrainChecked")
	
	for j=1:1:$ll(PostStatusList)
	{
		s tmpPostStatusData = $list(PostStatusList,j)
		s tmpAction = $p(tmpPostStatusData,"^",1)
		s tmpPostStatus = $p(tmpPostStatusData,"^",2)
		
		s objActStatusCfg = ##class(EMRmeta.EMRActStatusCfg).%New()
		s objActStatusCfg.EMRAction=tmpAction
		s objActStatusCfg.PostStatus=tmpPostStatus
		s objActStatusCfg.PreStatus="PlanTrainChecked"
		d objActStatusCfg.%Save()
		d objActStatusCfg.%Close()
	}
}

/// lifengbo
/// 初始化首页标准值域数据
/// d ##class(EMRservice.Tools.InitStandardDataTool).InitFirstPageCTData()
ClassMethod InitFirstPageCTData()
{
	d ##class(EMRmeta.CT.MedicalPaymentMethod).Init()
	d ##class(EMRmeta.CT.AdmConditions).Init()
	d ##class(EMRmeta.CT.AdmPathways).Init()
	d ##class(EMRmeta.CT.AdmTimeHaveDiease).Init()
	d ##class(EMRmeta.CT.DischConditions).Init()
	d ##class(EMRmeta.CT.DischargeMode).Init()
	d ##class(EMRmeta.CT.IncisionHealingGrade).Init()
	d ##class(EMRmeta.CT.BloodGroupABO).Init()
	d ##class(EMRmeta.CT.BloodGroupRH).Init()
	d ##class(EMRmeta.CT.FirstCaseInHosp).Init()
	d ##class(EMRmeta.CT.FollowUP).Init()
	d ##class(EMRmeta.CT.TeachingMedicalRecord).Init()
	d ##class(EMRmeta.CT.BloodTransfusionReaction).Init()
	d ##class(EMRmeta.CT.DeathPatWithAutopsy).Init()
	d ##class(EMRmeta.CT.MedicalRecordQuality).Init()
	d ##class(EMRmeta.CT.MRClassification).Init()
	d ##class(EMRmeta.CT.DiagCoincidence).Init()
	d ##class(EMRmeta.CT.ServiceRadius).Init()
	d ##class(EMRmeta.CT.HepatitisMarker).Init()
}

}
