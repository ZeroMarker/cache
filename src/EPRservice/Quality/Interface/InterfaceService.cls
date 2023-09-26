Class EPRservice.Quality.Interface.InterfaceService Extends %RegisteredObject
{

/// Desc： 提供给病案组科室质控是否通过接口:(返回值格式：Y^1)
///       （上箭头分隔的第一个字段是Y（启用），N（未启用），第二个字段是否是通过1（通过），0（未通过））
///        DepQFlagForMR：（质控公共函数配置——>是否启用病案管理关联科室质控,Y:启用，N：不启用)
/// DeBug：##class(EPRservice.Quality.Interface.InterfaceService).GetDepQFlagForMR(EpisodeID,"MD")
ClassMethod GetDepQFlagForMR(EpisodeID As %String, Action As %String)
{
		s ret=0,DepQFlagForMR="N"
		s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","DepQFlagForMR",""))
	    s:(ParamID '= "") DepQFlagForMR= ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("DepQFlagForMR")
	    s DisCheckFlag=##class(EPRservice.Quality.SetDepDisFlag).GetDisCheck(EpisodeID,Action)
	    s:(DisCheckFlag="Y") ret=1
	    q DepQFlagForMR_"^"_ret
}

/// Desc：提供给医生站病历是否存在超时质控条目接口，（0：不存在，1 存在）
/// DeBug：w ##class(EPRservice.Quality.Interface.InterfaceService).GetPromptQFlag(AEpisodeID)
ClassMethod GetPromptQFlag(AEpisodeID As %String) As %String
{
	s PromptQFlag=0
	q:(AEpisodeID="") PromptQFlag
	s EventTypeID = $o(^DHCEPRM.QualityDicI("IdxCode","Prompt",""))
	q:(EventTypeID = "") PromptQFlag
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") PromptQFlag
	
	s AdmLocID = $p(objPaAdm,"^",4)
	s objCtLoc = $g(^CTLOC(+AdmLocID))
	s HospitalID = $P(objCtLoc,"^",22)
	
	s SSGroupID = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("QuaSetSSGroup")
	s SSGroupID = $tr(SSGroupID," ","")
	q:(SSGroupID = "") PromptQFlag
	
	
	//是否启用集团化医院设置，如果否，则取质控默认医院QuaSetHospital
	s IsGroupHospital = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("QuaSetIsGroupHosp")
	if (IsGroupHospital '= "Y")
	{
		s HospitalID =  ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("QuaSetHospital")
		s HospitalID = $tr(HospitalID," ","")
		q:(HospitalID = "") PromptQFlag
	}
	q:(SSGroupID = "")||(HospitalID = "") PromptQFlag
	s QuaSettingID = $o(^DHCEPRM.QualitySettingI("IdxSSGroup",SSGroupID," "_EventTypeID,HospitalID,""))
	q:(QuaSettingID = "") PromptQFlag

	s objSetting = ##Class(EPRmeta.Quality.QualitySetting).%OpenId(QuaSettingID)
	q:(objSetting = "") PromptQFlag
	q:(objSetting.IsActive '[ "Y") PromptQFlag

	s EntryID = ""
	for
	{
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," 2",EntryID))
		q:(EntryID = "")
		s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)  
		continue:(objEntry = "")
		s isEntryActive = objEntry.IsActive   
		continue:(isEntryActive '[ "Y")
		
		s poolId = objEntry.PoolDR    
		continue:(poolId = "")
		s objPool = ##Class(EPRmeta.Quality.QualityPool).%OpenId(poolId)
		continue:(objPool = "")
		continue:(objPool.IsActive '["Y")
		s EntryTitle = objPool.Title
	    s EntryConditionDR = objEntry.EntryConditionDR 
	    if ((EntryConditionDR '= 0) && (EntryConditionDR '= $c(0)) &&(EntryConditionDR '= ""))
	    {
	       s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,EntryConditionDR)
	       continue:(flag '= "1")
	    }
	    
	    //检查表达式
		s ExpressionResult = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal(AEpisodeID,EntryID,"")
		continue:(ExpressionResult >= 0)
		s ErrInfo=ExpressionResult
	    s ErrInfo=$p(ErrInfo,";",1,10)
	    s:(ErrInfo[";") PromptQFlag=1
	    q:(PromptQFlag=1)
	    s OverFlag=""
	    s Hours = $p(ErrInfo,"^",5)
	    s FinishDate = $p(ErrInfo,"^",6)
		s:(Hours["-") OverFlag = "是"
		s:(OverFlag= "是")&&(FinishDate="") PromptQFlag=1		   
		q:(PromptQFlag=1)
		
		
	}
	q PromptQFlag
}

}
