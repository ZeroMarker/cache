/// ************************************************************
/// * Class Name:	EPRservice.Quality.ExpExplain.BOCheckRange
/// * Description:	判断电子病历质控检查范围
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-06-30
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.ExpExplain.BOCheckRange Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	设置电子病历质控检查范围;
/// Input:	AEpisodeID为患者就诊号; 
/// 		AEventType为触发事件类型;
/// 		ATemplateID为界面模板RowID;
/// 		APrintTemplateDocID为打印模板Doc ID;
/// 		ARuleID为质控标准RowID;
/// Output:	唯一模板Global		^CacheTemp("DHCEPRQQualityCTS",UniqueKey,ATemplateCategoryID,TemplateID,Status) = SaveTime
/// 	  	可重复模板Global	^CacheTemp("DHCEPRQQualityCTS",UniqueKey,ATemplateCategoryID,TemplateID,Status,Title,InstanceID) = SaveTime
/// Debug:	d ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).SetCheckRange("65","Print","704","158","")
ClassMethod SetCheckRange(AEpisodeID As %String, AEventType As %String, ATemplateID As %String, APrintTemplateDocID As %String, ARuleID As %String, AUniqueKey As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AEventType = "") ret
	q:($d(AEpisodeID) = 0)||($d(AEventType) = 0) ret
	
	s $zt = "SetCheckRangeError"	
	
	if (AEventType = "Print")||(AEventType = "Commit") 
	{
		// 打印和提交必须设置打印模板Doc ID
		q:(APrintTemplateDocID = "") ret
		
		s PrintTemplateDocID = " "_$g(APrintTemplateDocID)
		s EPRTemplateRowID = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID",PrintTemplateDocID,""))
		While(EPRTemplateRowID '= "")
		{
			s objEPRTemplate = $g(^DHCEPRM.EPRTemplateD(EPRTemplateRowID))
			s BindTemplateCategoryID = $list(objEPRTemplate,11)
			s BindTemplateID = $list(objEPRTemplate,12)
			
			s flag = ..IsCategoryValid(AEpisodeID,BindTemplateCategoryID)
			if (flag > 0)
			{
				d ..BuildCheckRange(BindTemplateCategoryID,BindTemplateID,AEpisodeID,AEventType,AUniqueKey)
			}
			s EPRTemplateRowID = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID",PrintTemplateDocID,EPRTemplateRowID))
		}
	}
	elseif (AEventType = "Save")
	{
		// 保存必须设置界面模板ID
		q:(ATemplateID = "") ret
		
		s objTemplate = ##Class(EPRmeta.Template).%OpenId(ATemplateID)
		q:(objTemplate = "") ret
		s TemplateCategoryID = objTemplate.TemplateCategoryID
		q:(TemplateCategoryID = "") ret
		
		s flag = ..IsCategoryValid(AEpisodeID,TemplateCategoryID)
		q:(flag <= 0) ret
		
		d ..BuildCheckRange(TemplateCategoryID,ATemplateID,AEpisodeID,AEventType,AUniqueKey)
	}
	else 
	{
		// 提示列表和自动任务不用设置界面模板ID和打印模板Doc ID,但必须设置质控标准ID
		q:(ARuleID = "") ret
		
		s ParentStructID = $list($g(^DHCEPRM.QualityRuleD(ARuleID)),3)
		q:(ParentStructID = "") ret
		
		d ..SetNoTriggerCheckRange(AEpisodeID,ParentStructID,AUniqueKey)		
	}
	
	s ret = 1
	q ret
	
SetCheckRangeError
	s error = $ZERROR
	s ^CacheTemp("EPRQuality","SetCheckRange",AEpisodeID,AEventType) = $zd($h,3)_":"_error
	s ret = -1_"^"_error
	q ret
}

/// Desc:	判断界面模板目录对当前就诊患者是否有效;
/// Input:	AEpisodeID为患者就诊号;
/// 		ATemplateCategoryID为界面模板目录RowID;
/// Output:	ret=1有效;ret=-1无效;
/// Debug:	w ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).IsCategoryValid("201865","533")
ClassMethod IsCategoryValid(AEpisodeID As %String, ATemplateCategoryID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(ATemplateCategoryID = "") ret
	q:($d(AEpisodeID) = 0)||($d(ATemplateCategoryID) = 0) ret
	
	// Find row id of QualityStruct by the unique index <IdxCategoryId>
	s structID = $o(^DHCEPRM.QualityStructI("IdxCategoryId"," "_ATemplateCategoryID,""))
	q:(structID = "") ret
	
	// Fixed bug 1115, if the current struct is not active, then exclude it
	s isStructActive = $list($g(^DHCEPRM.QualityStructD(structID)),8)
	q:($zcvt(isStructActive,"U") '= "Y") ret
	
	// Get the check condition for the up struct
	s chkConditionDR = $list($g(^DHCEPRM.QualityStructD(structID)),7)
	q:(+chkConditionDR = 0) ret
	
	// Check if <AEpisodeID> satisify the up condition
	s ret = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,chkConditionDR,structID)
	q ret
}

/// Desc:	生成病历质控检查范围;
/// Input:	ATemplateCategoryID为界面模板目录RowID;
/// 		ATemplateID为界面模板ID;
/// 		AEpisodeID为患者就诊号;
/// 		AEventType为触发事件类型;
/// Output:	^CacheTemp("DHCEPRQQualityCTS")
/// Debug:	k ^CacheTemp("DHCEPRQQualityCTS")
/// 		w ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).BuildCheckRange("533","704","8706","Print")
ClassMethod BuildCheckRange(ATemplateCategoryID As %String, ATemplateID As %String, AEpisodeID As %String, AEventType As %String, AUniqueKey As %String)
{
	q:(AEpisodeID = "")||(ATemplateCategoryID = "")
	q:($d(AEpisodeID) = 0)||($d(ATemplateCategoryID) = 0)	
	
	s SaveFlag = 0
	s ECRecordID = ""
	for {
		s ECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_AEpisodeID," "_ATemplateCategoryID,ECRecordID))
		q:(ECRecordID = "")
		
		s objECRecord = ##Class(EPRinstance.ECRecord).%OpenId(ECRecordID)
		continue:(objECRecord = "")
	
		s ChartItemType = objECRecord.ChartItemType
		s ChildSub = ""
		for {
			s ChildSub = $o(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,ChildSub))
			q:(ChildSub = "")
			
			s InstanceID = ECRecordID_"||"_ChildSub
			s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(InstanceID)
			continue:(objInstance = "")
			
			s Status = objInstance.Status
			s TemplateID = objInstance.TemplateID
			continue:(TemplateID = "")	//For compliant old version
			
			if (AEventType = "Print")||(AEventType = "Commit")||(AEventType = "Save")
			{
				if (TemplateID = ATemplateID)
				{
					s SaveTime = ""
					if (ChartItemType = "Single")
					{
						s SaveTime = $zd(objInstance.CreateDate,3)_" "_$zt(objInstance.CreateTime,1)	
						s:(Status = "UnSave") SaveTime = ""
						s ^CacheTemp("DHCEPRQQualityCTS",AUniqueKey,ATemplateCategoryID,TemplateID,Status) = SaveTime	
						s SaveFlag = 1
					}
					if (ChartItemType = "Multi")
					{
						s SaveTime = $zd(objInstance.HappenDate,3)_" "_$zt(objInstance.HappenTime,1)
						s Title = objInstance.Title
						s Status = "Save"
						s ^CacheTemp("DHCEPRQQualityCTS",AUniqueKey,ATemplateCategoryID,TemplateID,Status,Title,InstanceID) = SaveTime
						s SaveFlag = 1
					}
				}
			}
			else
			{
				s SaveTime = ""
				if (ChartItemType = "Single")
				{
					s SaveTime = $zd(objInstance.CreateDate,3)_" "_$zt(objInstance.CreateTime,1)	
					s:(Status = "UnSave") SaveTime = ""
					s ^CacheTemp("DHCEPRQQualityCTS",AUniqueKey,ATemplateCategoryID,TemplateID,Status) = SaveTime	
					s SaveFlag = 1
				}
				if (ChartItemType = "Multi")
				{
					s SaveTime = $zd(objInstance.HappenDate,3)_" "_$zt(objInstance.HappenTime,1)
					s Title = objInstance.Title
					s Status = "Save"
					s ^CacheTemp("DHCEPRQQualityCTS",AUniqueKey,ATemplateCategoryID,TemplateID,Status,Title,InstanceID) = SaveTime
					s SaveFlag = 1
				}
			}
		}
	}
	
	//Process no saved status
	if (SaveFlag = 0) 
	{
		s tempInfo = ##Class(EPRservice.TPrivLogic.PrivLogic).GetTempForView(AEpisodeID,"",ATemplateCategoryID)
		s IsUseTPriv = $p(tempInfo,"^",1)
		if (IsUseTPriv '= "Y")  
		{
			//未开启模板权限，取第一个适用的模板ID
			s TemplateID = $o(^DHCEPRM.TemplateI("IndexCategoryId"," "_ATemplateCategoryID,0))
		}
		else   
		{
			//已开启模板权限，取第一个满足模板权限的模板ID
			s TemplateID = $p(tempInfo,"^",2)
		}
		if (TemplateID = "")
		{
			s ^CacheTemp("DHCEPRQQualityCTS",AUniqueKey,ATemplateCategoryID) = "UnSave"
			q
		}
		s objTemplate = ##Class(EPRmeta.Template).%OpenId(TemplateID)
		q:(objTemplate = "")
		s ^CacheTemp("DHCEPRQQualityCTS",AUniqueKey,ATemplateCategoryID,TemplateID,"UnSave") = ""
	}
	q
}

/// Desc:	设置病历质控提示列表或自动任务的检查范围;
/// Input:	AEpisodeID为患者就诊号;
/// 		AParentStructID为上层质控结构RowID;
/// Debug:	d ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).SetNoTriggerCheckRange("65","4")
ClassMethod SetNoTriggerCheckRange(AEpisodeID As %String, AParentStructID As %String, AUniqueKey As %String)
{
	q:(AEpisodeID = "")||(AParentStructID = "")
	q:($d(AEpisodeID) = 0)||($d(AParentStructID) = 0)
	
	// Recursive get all template category under the given <AParentStructID> and then invoke [BuildCheckRange] method
	d ..GetCategoryIDListByStructID(AEpisodeID,AParentStructID,AUniqueKey)
}

/// Desc:	根据上层质控结构递归设置提示列表或自动任务检查范围;
/// Input:	AEpisodeID为患者就诊号;
/// 		AParentStructID为上层质控结构RowID;
/// Output:	^CacheTemp("DHCEPRQQualityCTS")
/// Debug:	d ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).GetCategoryIDListByStructID("8706","4")
ClassMethod GetCategoryIDListByStructID(AEpisodeID As %String, AParentStructID As %String, AUniqueKey As %String = "") As %String
{
	q:(AEpisodeID = "")||(AParentStructID = "")
	q:($d(AEpisodeID) = 0)||($d(AParentStructID) = 0)
	
	s structID = ""
	for {
		s structID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AParentStructID,structID))
		q:(structID = "")

		s objStruct = $g(^DHCEPRM.QualityStructD(structID))
		continue:(objStruct = "")
		
		s isActive = $list(objStruct,8)
		continue:($zcvt(isActive,"U") '= "Y")
		
		s chkConditionDR = $list(objStruct,7)
		continue:(chkConditionDR = "")||(chkConditionDR = $c(0))
		
		s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,chkConditionDR,structID)
		continue:(flag '= "1")
		
		s BindCategoryID = $list(objStruct,5)
		s BindCategoryParentId = $list(objStruct,6)
		if (BindCategoryID = "")||(BindCategoryID = $c(0))
		{
			d ..GetCategoryIDListByStructID(AEpisodeID,structID,AUniqueKey)	
		}
		else
		{
			// BuildCheckRange(TemplateCategoryID, TemplateID, EpisodeID, EventType,UniqueKey)
			d ..BuildCheckRange(BindCategoryID,"",AEpisodeID,"",AUniqueKey)
		}
	}
}

/// Desc:	判断质控项目是否在病历质控检查范围内;
/// 		判断逻辑: 先判断质控项目挂载的质控结构是否有效,无效退出. 如果该质控结构关联界面模板目录,则继续判断界面模板目录下界面模板完成情况;
/// 		剩下内部逻辑交由质控规则处理;
/// Todo:	将来扩展可以在质控项目上设置检查条件进行进一步范围限定;
/// Input:	AEpisodeID为患者就诊号;
/// 		AEntryID为病历质控项目RowID;
/// 		ACheckStatus为检查状态;
/// Output:	ret=1须检查;ret=-1不需要检查;
/// Debug:	w ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).IsCheckEntry("","","","")
ClassMethod IsCheckEntry(AEpisodeID As %String, AEntryID As %String, ACheckStatus As %String, AUniqueKey As %String) As %String
{
	s ret = -1
	s $zt = "IsCheckEntryError"
	q:($d(AEntryID) = 0)||(AEntryID = "") ret
	
	s objEntry 	= $g(^DHCEPRM.QualityEntryD(AEntryID))
	s PoolDR	= $list(objEntry,1)
	s RuleDR	= $list(objEntry,2)
	s StructDR	= $list(objEntry,3)
	q:(PoolDR = "")||(RuleDR = "")||(StructDR = "") ret
	
	// Fixed bug 1114 ---Zuoxiang Xie
	s ParentStructID = $list($g(^DHCEPRM.QualityRuleD(RuleDR)),3)
	q:(ParentStructID = "") ret
	s flag = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).IsChildStruct(ParentStructID,StructDR)
	q:(flag < 0) ret
	
	if (PoolDR [ "E") 
	{
		s UnitID = $zstrip(PoolDR,"*A") //EPRmeta_Quality.QualityTemplate表ID
		s TemplateID = $list($g(^DHCEPRM.QualityTemplateD(+UnitID)),1)
		q:(TemplateID = "") ret
		s CatalogID = $list($g(^DHCEPRM.TemplateD(+TemplateID)),7)
		s ret = ..CheckBindCategoryInRange(CatalogID,TemplateID,ACheckStatus,AUniqueKey)
	} 
	else
	{
		s BindCategoryId = $list($g(^DHCEPRM.QualityStructD(StructDR)),5)
		
		// Fixed bug 1113
		if (BindCategoryId = "")||(BindCategoryId = $C(0))
		{
			s StructID = ""
			for {
				s StructID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_StructDR,StructID))
				q:(StructID = "")
		
				s objStruct = $g(^DHCEPRM.QualityStructD(StructID))
				
				s IsActive = $list(objStruct,8)
				continue:(IsActive '= "Y")
				
				s ChkConditionDR = $list(objStruct,7)
				continue:(ChkConditionDR = "")||(ChkConditionDR = $c(0))
		
				s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,ChkConditionDR,StructID)
				continue:(flag '= "1")
								
				s CatalogID = $list(objStruct,5)
				s flag = ..CheckBindCategoryInRange(CatalogID,"",ACheckStatus,AUniqueKey)
				if (flag < 0)
				{
					s ret = -1
					q	
				}
				else
				{
					s ret = 1	
				}
			}
		}
		else
		{
			s ret = ..CheckBindCategoryInRange(BindCategoryId,"",ACheckStatus,AUniqueKey)	
		}
	}
	
	q ret
	
IsCheckEntryError
	s error = $ZERROR
	s ^CacheTemp("EPRQuality","CheckEntryError",AEpisodeID,AEntryID) = $zd($h,3)_":"_error
	s ret = -1_"^"_error
	q ret
}

/// Desc:	判断是否在所设置的病历质控检查范围内;
/// Input:	ACatalogID为界面模板目录RowID;
/// 		ATemplateID为界面模板RowID;
/// 		ACheckStatus为检查状态;
/// 		AUniqueKey为存储临时病历质控检查范围的键值;
/// Output: ret=1在检查范围内;ret=-1不在检查范围内;
ClassMethod CheckBindCategoryInRange(ACatalogID As %String, ATemplateID As %String, ACheckStatus As %String, AUniqueKey As %String)
{
	s ret = 1
	if (ACatalogID '= "")&&(ATemplateID '= "")
	{
		if (ACheckStatus = "Save")
		{
			s:('$d(^CacheTemp("DHCEPRQQualityCTS",AUniqueKey,ACatalogID,ATemplateID,"Save"))) ret=-1	
		}
		elseif (ACheckStatus = "")
		{
			s:('$d(^CacheTemp("DHCEPRQQualityCTS",AUniqueKey,ACatalogID,ATemplateID))) ret=-1	
		}
	}
	
	if (ACatalogID '= "")&&(ATemplateID = "")
	{
		s:('$d(^CacheTemp("DHCEPRQQualityCTS",AUniqueKey,ACatalogID))) ret=-1		
	}
	q ret
}

/// Desc:	是否应该写此模板(EPR病历)
/// Input:	AEpisodeID为患者就诊号; 
/// 		ATemplateCategoryID模板目录ID;
/// Output:	result 1需要写，-1不需要写
ClassMethod IsNeedCheckEPR(AEpisodeID As %String, ATemplateCategoryID As %String) As %String
{
	s result = -1
	q:(AEpisodeID = "")||(ATemplateCategoryID = "") result
	
	s ECRecordID = ""
	for {
		s ECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_AEpisodeID," "_ATemplateCategoryID,ECRecordID))
		q:(ECRecordID = "")
		if ($d(^DHCEPRI.InstanceDataI("IdxECRecordStatus",ECRecordID," SAVE")))
		{
			s result = 1
			q
		}
	}
	if (result = -1) 
	{
		s tempInfo = ##Class(EPRservice.TPrivLogic.PrivLogic).GetTempForView(AEpisodeID,"",ATemplateCategoryID)
		s:($p(tempInfo,"^",2)="") result = 1
	}
	q result
}

/// Desc:	是否应该写此模板(EMR病历)
/// Input:	AEpisodeID为患者就诊号; 
/// 		ATemplateCategoryID模板目录ID;
/// Output:	result 1需要写，-1不需要写
ClassMethod IsNeedCheckEMR(AEpisodeID As %String, ATemplateCategoryID As %String) As %String
{
	s result = -1
	q:(AEpisodeID = "")||(ATemplateCategoryID = "") result
	s ECRecordID = ""
	for {
		s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID"," "_AEpisodeID," "_ATemplateCategoryID,ECRecordID))
		q:(ECRecordID = "")
		if ($d(^DHCEMRI.DirectoryInformationI("IdxECRecordID"," "_ECRecordID)))
		{
			s result = 1
			q
		}	
	}
	if (result = -1) 
	{
		s tempInfo = ##Class(EMRservice.TPrivLogic.PrivLogic).GetTempForView(AEpisodeID,"",ATemplateCategoryID,"Quality")
		s:($p(tempInfo,"^",2)="") result = 1
	}
	q result
}

}
