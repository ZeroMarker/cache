/// Class Name:		EPRservice.Quality.BORunQualityRule
/// Description:	运行时质控入口
/// Author:			Zuoxiang Xie
/// Create Date:	2010-06-22
/// Version:	
Class EPRservice.Quality.BORunQualityRule Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	检查保存、提交和打印等病历操作的质控结果;
/// Input:	AEpisodeID为患者就诊号;
/// 		ATemplateID为界面模板RowID;
/// 		AInstanceIDs为实例数据RowID集合,唯一模板传空值即可;
/// 		ASSGroupID为操作者安全组RowID;
/// 		AEventType为病历操作类型(Save,Commit或者Print);
/// 		AHospitalID为医院RowID,集团化医院时需要;
/// 		ACheckStatus为检查的病历状态(Save);
/// 		APrintTemplateDocID为打印模板DocID(做Commit和Print操作时需要);
/// 		AUniqueKey为调用方UniqueKey,用做存储数据临时Global节点用;
/// Return:	EpisodeID,RuleSub,RuleTitle,SectionSub,SectionTitle,EntrySub,EntryTitle
/// Output:	^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID) = RuleTitle
/// 		^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID,PhaseID,EntryID) = EntryTitle
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BORunQualityRule","GetQualityResult","201871","704","","","Print","","","19")
Query GetQualityResult(AEpisodeID As %String, ATemplateID As %String, AInstanceIDs As %String, ASSGroupID As %String, AEventType As %String, AHospitalID As %String, ACheckStatus As %String, APrintTemplateDocID As %String = "", AUniqueKey As %String) As %Query(ROWSPEC = "EpisodeID:%String,RuleSub:%String,RuleTitle:%String,SectionSub:%String,SectionTitle:%String,EntrySub:%String,EntryTitle:%String")
{
}

ClassMethod GetQualityResultExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ATemplateID As %String, AInstanceIDs As %String, ASSGroupID As %String, AEventType As %String, AHospitalID As %String, ACheckStatus As %String, APrintTemplateDocID As %String = "", AUniqueKey As %String) As %Status
{
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(AEpisodeID = "")||(AEventType = "")||(AUniqueKey = "") $$$OK
	
    s SSGroupID = $g(ASSGroupID)
    s HospitalID = $g(AHospitalID)
    
	//事件类型RowID
	s EventTypeID = $o(^DHCEPRM.QualityDicI("IdxCode",AEventType,""))
	q:(EventTypeID = "") $$$OK
	
	//是否启用登录安全组设置，如果不采用，则取默认安全组QuaSetSSGroup
	s IsSSGroup = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("QuaSetIsSSGroup")
	if (IsSSGroup '= "Y") 
	{
		s SSGroupID = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("QuaSetSSGroup")
		s SSGroupID = $tr(SSGroupID," ","")
		q:(SSGroupID = "") $$$OK
	} 
	
	//是否启用集团化医院设置，如果否，则取质控默认医院QuaSetHospital
	s IsGroupHospital = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("QuaSetIsGroupHosp")
	if (IsGroupHospital '= "Y")
	{
		s HospitalID =  ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("QuaSetHospital")
		s HospitalID = $tr(HospitalID," ","")
		q:(HospitalID = "") $$$OK
	}
	q:(SSGroupID = "")||(HospitalID = "") $$$OK
	
	//根据EventTypeId，SSGroupId和HospitalId获取相应的质控开关设置，找不到则退出
	s QuaSettingID = $o(^DHCEPRM.QualitySettingI("IdxSSGroup",SSGroupID," "_EventTypeID,HospitalID,""))
	q:(QuaSettingID = "") $$$OK
	s objSetting = ##Class(EPRmeta.Quality.QualitySetting).%OpenId(QuaSettingID)
	q:(objSetting = "") $$$OK
	q:(objSetting.IsActive '= "Y") $$$OK
	
	//控制类型
	s ControlTypeID = objSetting.ControlTypeDR
    s objDic = ##Class(EPRmeta.Quality.QualityDictionary).%OpenId(ControlTypeID)
    q:(objDic = "")
    s ControlType = objDic.Code
    
    //质控结构
	s StructID = objSetting.StructDR
	q:(StructID = "") $$$OK
	
	//质控标准
	s RuleID = objSetting.QualityRuleDR
	q:(RuleID = "") $$$OK
	s objRule = ##Class(EPRmeta.Quality.QualityRule).%OpenId(RuleID)
	q:(objRule = "") $$$OK
	q:(objRule.IsActive '= "Y") $$$OK
	
	//InstanceIDs "\"分割
	s InstanceIDs = $tr(AInstanceIDs,$c(0),"")
	s InstanceIDs = $tr(AInstanceIDs,",","\")
	
	//当前触发的质控标准
	s RuleTitle = objRule.Name
	s ^CacheTemp("DHCEPRQQuality",AUniqueKey,AEpisodeID,RuleID) = ControlType_"^"_RuleTitle
	s count = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(StructID,RuleID,AEpisodeID,AUniqueKey,"GetQualityResult",AInstanceIDs,ATemplateID)	
	q $$$OK
}

ClassMethod GetQualityResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityResultExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQualityResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityResultExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取质控控制类型(0:提示;1:控制);
/// Input:	ASSGroupID为安全组RowID;
/// 		AEventType为事件类型;
/// 		AHospitalID为医院RowID(CT_Hospital表);
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BORunQualityRule","GetControlType","","Print","")
Query GetControlType(ASSGroupID As %String, AEventType As %String, AHospitalID As %String) As %Query(ROWSPEC = "EventType:%String,ControlType:%String,RuleID:%String")
{
}

ClassMethod GetControlTypeExecute(ByRef qHandle As %Binary, ASSGroupID As %String, AEventType As %String, AHospitalID As %String) As %Status
{
    s repid = $i(^CacheTemp)
	s indQry = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AEventType = "") $$$OK
	
	s EventTypeID = $o(^DHCEPRM.QualityDicI("IdxCode",AEventType,""))
	q:(EventTypeID = "") $$$OK
	
	//是否启用登录安全组设置，如果不采用，则取默认安全组SSGroupID
	s IsSSGroupRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetIsSSGroup",""))
	s IsSSGroup = $list(^DHCEPRM.QualityParamsD(+IsSSGroupRowID),2)
	if (IsSSGroup '= "Y") 
	{
		s SSGroupRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetSSGroup",""))
		s SSGroupID = $list(^DHCEPRM.QualityParamsD(+SSGroupRowID),2)
		s SSGroupID = $tr(SSGroupID," ","")
		q:(SSGroupID = "") $$$OK
	} 
	
	//是否启用集团化医院设置，如果否，则取质控默认医院HospitalID
	s IsGroupHospitalRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetIsGroupHosp",""))
	s IsGroupHospital = $list(^DHCEPRM.QualityParamsD(+IsGroupHospitalRowID),2)
	if (IsGroupHospital '= "Y")
	{
		s HospitalRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetHospital",""))
		s HospitalID = $list($g(^DHCEPRM.QualityParamsD(+HospitalRowID)),2)
		s HospitalID = $tr(HospitalID," ","")
		q:(HospitalID = "") $$$OK
	}
	
	s QuaSettingID = $o(^DHCEPRM.QualitySettingI("IdxSSGroup",SSGroupID," "_EventTypeID,HospitalID,""))
	q:(QuaSettingID = "") $$$OK
	s objQuaSetting = $g(^DHCEPRM.QualitySettingD(QuaSettingID))
	s RuleID = $list(objQuaSetting, 5)
	q:(RuleID = "") $$$OK
	q:($list($g(^DHCEPRM.QualityRuleD(RuleID)),4) '= "Y") $$$OK
	
	s ControlTypeDr = $list(objQuaSetting,4)
	q:(ControlTypeDr = "") $$$OK
	s tmpInfo = $g(^DHCEPRM.QualityDicD(ControlTypeDr))
	s ControlType = $s($list(tmpInfo,1)["0":"0",$list(tmpInfo,1)["1":"1",1:"")
	q:(ControlType = "") $$$OK
	
	s Data = $lb(AEventType,ControlType,RuleID)
	s ^CacheTemp(repid,indQry) = Data
	s indQry = indQry+1
	
	q $$$OK
}

ClassMethod GetControlTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetControlTypeExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{ 
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetControlTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetControlTypeExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	检查保存、提交和打印等病历操作的质控结果;
/// Input:	AEpisodeID为患者就诊号;
/// 		ATemplateID为界面模板RowID;
/// 		AInstanceIDs为实例数据RowID集合,唯一模板传空值即可;
/// 		ASSGroupID为操作者安全组RowID;
/// 		AEventType为病历操作类型(Save,Commit或者Print);
/// 		AHospitalID为医院RowID,集团化医院时需要;
/// 		ACheckStatus为检查的病历状态(Save);
/// 		APrintTemplateDocID为打印模板DocID(做Commit和Print操作时需要);
/// 		AUniqueKey为调用方UniqueKey,用做存储数据临时Global节点用;
/// Return:	EpisodeID,RuleSub,RuleTitle,SectionSub,SectionTitle,EntrySub,EntryTitle
/// Output:	^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID) = RuleTitle
/// 		^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID,PhaseID,EntryID) = EntryTitle
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BORunQualityRule","GetQualityResult",27,"","",29,"ConfirmRecord",2,"","",106375)
Query GetQualityResultNew(AEpisodeID As %String, ATemplateID As %String, AInstanceIDs As %String, ASSGroupID As %String, AEventType As %String, AHospitalID As %String, ACheckStatus As %String, APrintTemplateDocID As %String = "", AUniqueKey As %String) As %Query(ROWSPEC = "")
{
}

ClassMethod GetQualityResultNewExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ATemplateID As %String, AInstanceIDs As %String, ASSGroupID As %String, AEventType As %String, AHospitalID As %String, ACheckStatus As %String, APrintTemplateDocID As %String = "", AUniqueKey As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(AEpisodeID = "")||(AEventType = "")||(AUniqueKey = "") $$$OK
	
    s SSGroupID = $g(ASSGroupID)
    s HospitalID = $g(AHospitalID)
   
	//事件类型RowID
	s EventTypeID = $o(^CT.MA.QC.QualityDictionaryI("IdxCode",AEventType,""))
	q:(EventTypeID = "") $$$OK
	
	//是否启用登录安全组设置，如果不采用，则取默认安全组QuaSetSSGroup
	s IsSSGroup = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("QuaSetIsSSGroup")
	if (IsSSGroup '= "Y") 
	{
		s SSGroupID = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("QuaSetSSGroup")
		s SSGroupID = $tr(SSGroupID," ","")
		q:(SSGroupID = "") $$$OK
	} 
	
	//是否启用集团化医院设置，如果否，则取质控默认医院QuaSetHospital
	s IsGroupHospital = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("QuaSetIsGroupHosp")
	if (IsGroupHospital '= "Y")
	{
		s HospitalID =  ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("QuaSetHospital")
		s HospitalID = $tr(HospitalID," ","")
		q:(HospitalID = "") $$$OK
	}
	q:(SSGroupID = "")||(HospitalID = "") $$$OK
    
	//根据EventTypeId，SSGroupId和HospitalId获取相应的质控开关设置，找不到则退出
	s QuaSettingID = $o(^CT.MA.QC.QualitySettingI("IdxSSGroup",SSGroupID," "_EventTypeID,HospitalID,""))
	q:(QuaSettingID = "") $$$OK
	s objSetting = ##Class(CT.MA.QC.QualitySetting).%OpenId(QuaSettingID)
	q:(objSetting = "") $$$OK
	q:(objSetting.IsActive '= "Y") $$$OK
	
	//控制类型
	s ControlTypeID = objSetting.ControlTypeDR
    s objDic = ##Class(CT.MA.QC.QualityDictionary).%OpenId(ControlTypeID)
    q:(objDic = "")
    s ControlType = objDic.Code
    
    //质控结构
	s StructID = objSetting.StructDR
	q:(StructID = "") $$$OK
	
	//质控标准
	s RuleID = objSetting.QualityRuleDR
	q:(RuleID = "") $$$OK
	s objRule = ##Class(CT.MA.QC.QualityRule).%OpenId(RuleID)
	q:(objRule = "") $$$OK
	q:(objRule.IsActive '= "Y") $$$OK
	
	//InstanceIDs "\"分割
	s InstanceIDs = $tr(AInstanceIDs,$c(0),"")
	s InstanceIDs = $tr(AInstanceIDs,",","\")
	//当前触发的质控标准
	s RuleTitle = objRule.Name
	s ^CacheTemp("DHCEPRQQuality",AUniqueKey,AEpisodeID,RuleID) = ControlType_"^"_RuleTitle
	s count = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStructNew(StructID,RuleID,AEpisodeID,AUniqueKey,"GetQualityResult",AInstanceIDs,ATemplateID)	

	Quit $$$OK
}

ClassMethod GetQualityResultNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityResultNewExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetQualityResultNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityResultNewExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
