Class EPRservice.Quality.OperationLogic.GradeEvaluation Extends EPRservice.Quality.OperationLogic.EvaluationLogic [ ClassType = "", Not ProcedureBlock ]
{

/// Desc:计算级别
/// Creator:Candyxu
/// CreateDate:2012-11-22
/// Input:pEpisodeID:就诊号;pRuleIDs:质控标准代码,多个以^分隔
/// OutPut:级别^特殊判断ID^特殊判断个数^一般判断ID^一般判断个数^总触犯个数
///       所谓特殊判断为几个...相当于... 例如：6个以上轻级相当于1个中级
ClassMethod DoOperation(pEpisodeID As %String, pRuleIDs As %String, pAction As %String = "") As %String
{
	q ..SetGrade(pEpisodeID,pRuleIDs,pAction)
}

/// Desc:计算级别
/// Creator:Candyxu
/// CreateDate:2012-11-22
/// Input:pEpisodeID:就诊号;pRuleIDs:质控标准代码,多个以^分隔
/// OutPut:级别^特殊判断ID^特殊判断个数^一般判断ID^一般判断个数^总触犯个数
///       所谓特殊判断为几个...相当于... 例如：6个以上轻级相当于1个中级
/// Debug:w ##Class(EPRservice.Quality.OperationLogic.GradeEvaluation).SetGrade("2408173","1^6")
ClassMethod SetGrade(pEpisodeID As %String, pRuleIDs As %String, pAction As %String = "") As %String
{
   s Result = "0"
   s RuleIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(pRuleIDs,"^")
   s UniqueKey = $i(^CacheTemp)
   k ^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey)
   for i = 1:1:$listlength(RuleIDs) 
   {
		s RuleID = $listget(RuleIDs,i)
		continue:(RuleID = "")
		s ResultID = ""
		for {
			s ResultID = $o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_pEpisodeID," "_RuleID,ResultID))
			q:(ResultID = "")
			s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
			s Action = objResult.Action
			continue:(Action'=pAction)&&(pAction'="")&&(Action'="")
			s ChildSub = ""
			for {
				s ChildSub = $o(^DHCEPRQ.QualityResultDetailI("IdxResult",ResultID,ChildSub))
				q:(ChildSub = "")
				s DetailID = ResultID_"||"_ChildSub
				s objDetail = ##Class(EPRinstance.Quality.QualityResultDetail).%OpenId(DetailID)
				s EntryID = objDetail.EntryDR	
				// 如果这个条目被删除了，则不参与计分
				continue:($g(^DHCEPRM.QualityEntryD(+EntryID)) = "")
				s EntryScore = objDetail.EntryScore	
				s ExamCount = objDetail.ExamCount
				
				//按级别计算分数
                s ^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,EntryScore) = (+$g(^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,EntryScore))) + ExamCount
				if (objDetail '= "")
				{
					d objDetail.%Close()
					k objDetail
				}
			}
		} 				
	}
    q ..GetGrade(UniqueKey)
}

/// Desc:判断分数级别
/// Creator:Candyxu
/// CreateDate:2012-11-22
/// InPut:UniqueKey:唯一识别码
/// OutPut:级别^特殊判断ID^特殊判断个数^一般判断ID^一般判断个数^总触犯个数
ClassMethod GetGrade(UniqueKey As %String) As %String
{
	s Result = ""
	s QPID = $o(^DHCEPRM.QualityParamsI("IdxCode","GradeStandard",""))
	s:(QPID = "") TempSys = "<OperationItem><Items><Level>Ⅴ级</Level><Grade>3L</Grade><Ruler><![CDATA[3L>=1]]></Ruler></Items><Items><Level>Ⅳ级</Level><Grade>2L</Grade><Ruler><![CDATA[2L>=4]]></Ruler><SpecialRuler><![CDATA[1L|1L>=6]]></SpecialRuler></Items><Items><Level>Ⅲ级</Level><Grade>2L</Grade><Ruler><![CDATA[((2L>=2)&&(2L<=3))]]></Ruler><SpecialRuler><![CDATA[1L|1L>=6]]></SpecialRuler></Items><Items><Level>Ⅱ级</Level><Grade>2L</Grade><Ruler>2L=1</Ruler><SpecialRuler><![CDATA[1L|1L>=6]]></SpecialRuler></Items><Items><Level>Ⅰ级</Level><Grade>1L</Grade><Ruler><![CDATA[((1L>=0)&&(1L<=5))]]></Ruler></Items></OperationItem>"
    s TempSys = $li(^DHCEPRM.QualityParamsD(QPID),2)
    s reader = ##class(%XML.Reader).%New()
    s sc = reader.OpenString(TempSys)
    d reader.Correlate("OperationItem","EPRservice.Quality.OperationLogic.OperationItem")
    While reader.Next(.obj,.sc)
    {
	    s count = obj.Items.Count()
        for i = 1:1:count 
        {
           s Level = obj.Items.GetAt(i).Level
           s Grade = obj.Items.GetAt(i).Grade
           s Ruler = obj.Items.GetAt(i).Ruler
           s Special = obj.Items.GetAt(i).SpecialRuler
           s SpecialGrade = $p(Special,"|",1)
           s SpecialRuler = $p(Special,"|",2)
           
           s Totlecount = 0
		   s TGradeCode = "",TCount = 0
		   s PGradeCode = "",PCount = 0
		   s flag = 0
		   //特殊条件判断
		   if (SpecialRuler '= "")
		   {
			  if $d(^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,SpecialGrade))
		      {
			     s count = ^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,SpecialGrade)
			     s strExpress = ##Class(EPRservice.Util.StringHelper).Replace(SpecialRuler,SpecialGrade,count)
			     s Command = "^CacheTemp("_UniqueKey_")="_strExpress
			     s @Command
			     if ($g(^CacheTemp(UniqueKey)))
			     {
			         s TCount = ^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,SpecialGrade)
			         s Totlecount = Totlecount +1				     
				 }
		      }
		   }
		   //条件判断
		   if ($d(^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,Grade)))
		   {
			   s PCount = ^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,Grade)
			   s Totlecount = Totlecount + PCount
		   }
		   s strExpress = ##Class(EPRservice.Util.StringHelper).Replace(Ruler,Grade,Totlecount)
		   s Command = "^CacheTemp("_UniqueKey_")="_strExpress
		   s @Command
		   if ($g(^CacheTemp(UniqueKey)))
		   {
			  s Result = Level_"^"_SpecialGrade_"^"_TCount_"^"_Grade_"^"_PCount_"^"_Totlecount
			  q 
		   }
        }
	}
	q Result
}

/// Desc: 根据等级的代码值,取其描述值
/// Creator: Candyxu
/// CreateDate: 2012-11-28
/// Input:pValue 等级的code
/// OutPut:等级的描述
/// Debug: w ##Class(EPRservice.Quality.OperationLogic.GradeEvaluation).GetEvaluationValue("1L")
ClassMethod GetEvaluationValue(pValue As %String) As %String
{
   s Desc = "无"
   q:(pValue = "") Desc
   q:('$d(^DHCEPRM.QualityDicI("IdxCode",pValue))) Desc
   s RowID = $O(^DHCEPRM.QualityDicI("IdxCode",pValue,""))
   q:(RowID = "") Desc
   s Desc = $li(^DHCEPRM.QualityDicD(RowID),3)
   q Desc
}

/// Desc:出院查询级别模式计算
/// Creator:Candyxu
/// CreateDate:2012-12-04
/// Input:pGrade 级别,pAUniqueKey 唯一识别值,pDisLocID 科室ID,pDisWardID 病区ID,pAdmDoctorID 医生ID
ClassMethod GetSearchReport(pGrade As %String, pAUniqueKey As %String, pDisLocID As %String, pDisWardID As %String, pAdmDoctorID As %String, pQualityType As %String)
{
   s:(pGrade = "Ⅰ级") ^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"First") = (+$g(^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"First"))) + 1  
   s:(pGrade = "Ⅱ级") ^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Second") = (+$g(^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Second"))) + 1
   s:(pGrade = "Ⅲ级") ^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Third") = (+$g(^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Third"))) + 1
   s:(pGrade = "Ⅳ级") ^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Fourth") = (+$g(^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Fourth"))) + 1
   s:(pGrade = "Ⅴ级") ^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Fifth") = (+$g(^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Fifth"))) + 1
}

/// Desc: 报表临时global
/// Creator:Candyxu
/// CreateDate:2012-12-11
/// Input:pGrade 级别,PStyle 类型,pAUniqueKey 唯一识别值,pDisLocID 科室ID,pAdmDoctorID 医生ID
ClassMethod GetQualityReportGloable(pGrade As %String, PStyle As %String, pAUniqueKey As %String, pDisLocID As %String, pAdmDoctorID As %String)
{
   s:(pGrade = "Ⅰ级") ^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"First") = (+$g(^CacheTemp("EPRQuality","DischSearch",pAUniqueKey,pDisLocID,pAdmDoctorID,"First"))) + 1  
   s:(pGrade = "Ⅱ级") ^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"Second") = (+$g(^CacheTemp("EPRQuality","DischSearch",pAUniqueKey,pDisLocID,pAdmDoctorID,"Second"))) + 1
   s:(pGrade = "Ⅲ级") ^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"Third") = (+$g(^CacheTemp("EPRQuality","DischSearch",pAUniqueKey,pDisLocID,pAdmDoctorID,"Third"))) + 1
   s:(pGrade = "Ⅳ级") ^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"Fourth") = (+$g(^CacheTemp("EPRQuality","DischSearch",pAUniqueKey,pDisLocID,pAdmDoctorID,"Fourth"))) + 1
   s:(pGrade = "Ⅴ级") ^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"Fifth") = (+$g(^CacheTemp("EPRQuality","DischSearch",pAUniqueKey,pDisLocID,pAdmDoctorID,"Fifth"))) + 1
}

/// Debug: w ##Class(EPRservice.Quality.OperationLogic.GradeEvaluation).GetLastEvaluation(493054)
ClassMethod GetLastEvaluation(pEpisodeID As %String) As %String
{
	s ret = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(pEpisodeID)
	s Grade = $p($g(ret),"^",2)
	q "病历级别:"_Grade
}

/// ////////////////////////////////////////////////////////////////////////////////
/// Desc:生成缺陷级别xml candyxu 2012-12-20
/// Debug: do ##Class(EPRservice.Quality.OperationLogic.GradeEvaluation).TestXML()
ClassMethod TestXML()
{
	/*
	s xml = "<OperationItem><Items><Level>1级</Level><Grade>1L</Grade><Ruler><![CDATA[1L=>0 && 5=1L]]></Ruler></Items><Items><Level>2级</Level><Grade>2L</Grade><Ruler>2L=1</Ruler><SpecialRuler><![CDATA[1L>=6]]></SpecialRuler></Items><Items><Level>3级</Level><Grade>2L</Grade><Ruler><![CDATA[2L>=2 && 3>=2L]]></Ruler><SpecialRuler><![CDATA[1L>=6]]></SpecialRuler></Items><Items><Level>4级</Level><Grade>2L</Grade><Ruler><![CDATA[2L>=4]]></Ruler><SpecialRuler><![CDATA[1L>=6]]></SpecialRuler></Items><Items><Level>5级</Level><Grade>3L</Grade><Ruler><![CDATA[3L>=1]]></Ruler></Items></OperationItem>"
    s reader = ##class(%XML.Reader).%New()
    s xmlobj = ##class(%FileCharacterStream).%New()
    s sc = reader.OpenString(xml)
    d reader.Correlate("OperationItem","EPRservice.Quality.OperationLogic.OperationItem")
    While reader.Next(.obj,.sc)
    {
	    Write obj.Items.GetAt(1).Ruler
	}
	*/
	s obj = ##Class(EPRservice.Quality.OperationLogic.OperationItem).%New()
    s ItemObj = ##Class(EPRservice.Quality.OperationLogic.OperationSubItem).%New()
	s ItemObj.Level = "5级"
	s ItemObj.Grade = "3L"
	s ItemObj.Ruler = "3L>=1"
	s ItemObj.SpecialRuler = ""
	d obj.Items.Insert(ItemObj)
	
	s ItemObj = ##Class(EPRservice.Quality.OperationLogic.OperationSubItem).%New()
	s ItemObj.Level = "4级"
	s ItemObj.Grade = "2L"
	s ItemObj.Ruler = "2L>=4"
	s ItemObj.SpecialRuler = "1L|1L>=6"
	d obj.Items.Insert(ItemObj)

    s ItemObj = ##Class(EPRservice.Quality.OperationLogic.OperationSubItem).%New()
	s ItemObj.Level = "3级"
	s ItemObj.Grade = "2L"
	s ItemObj.Ruler = "((2L>=2) && (2L<=3))"
	s ItemObj.SpecialRuler = "1L|1L>=6"
	d obj.Items.Insert(ItemObj)	
	
    s ItemObj = ##Class(EPRservice.Quality.OperationLogic.OperationSubItem).%New()
	s ItemObj.Level = "2级"
	s ItemObj.Grade = "2L"
	s ItemObj.Ruler = "2L=1"
	s ItemObj.SpecialRuler = "1L|1L>=6"
	d obj.Items.Insert(ItemObj)
	s ItemObj = ##Class(EPRservice.Quality.OperationLogic.OperationSubItem).%New()	
	s ItemObj.Level = "1级"
	s ItemObj.Grade = "1L"
	s ItemObj.Ruler = "((1L=>0) && (1L<=5))"
	s ItemObj.SpecialRuler = ""
	d obj.Items.Insert(ItemObj)

	d obj.XMLExportToString(.xml)	
	s ^TempXML = xml
}

}
