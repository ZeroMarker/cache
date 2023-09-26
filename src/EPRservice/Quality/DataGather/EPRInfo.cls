/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataGather.EPRInfo
/// * Description:	与电子病历相关逻辑处理
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-05-11
/// * Version:		
/// ************************************************************/
Class EPRservice.Quality.DataGather.EPRInfo Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.EPRInfo","GetInstanceData","201764","9787")
Query GetInstanceData(AEpisodeID As %String, AElementID As %String) As %Query(ROWSPEC = "InstanceID,CreateDate,CreateTime,ModifyDate,ModifyTime,HappenDate,HappenTime,Title")
{
}

ClassMethod GetInstanceDataExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AElementID As %String) As %Status
{
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AEpisodeID = "")||(AElementID = "") $$$OK
	
	s TemplateID = $list($g(^DHCEPRM.QualityTemplateD(AElementID)),1)
	q:(TemplateID = "") $$$OK
	
	//找到界面所在目录通过界面模板ID
    s CategoryID=$lg(^DHCEPRM.TemplateD(TemplateID),7)
    q:(CategoryID = "") $$$OK
    
	s CatalogID = " "_CategoryID
		
		s ECRecordID = ""
		for {
			s ECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_AEpisodeID,CatalogID,ECRecordID))
			q:(ECRecordID = "")
			
			s objECRecord = ##Class(EPRinstance.ECRecord).%OpenId(ECRecordID)
			continue:(objECRecord.ChartItemType '= "Multi")  //  Multi-可重复模板 Single-唯一模板
			
			s ChildSub = 0
			for {
				s ChildSub = $o(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,ChildSub))
				q:(ChildSub = "")
				
				s InstanceID = ECRecordID_"||"_ChildSub
				s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(InstanceID)
				continue:(objInstance.Status = "UnSave")
				
				s CreateDate = objInstance.CreateDate
				s CreateTime = objInstance.CreateTime
				s ModifyDate = objInstance.ModifyDate
				s ModifyTime = objInstance.ModifyTime
				s HappenDate = objInstance.HappenDate
				s HappenTime = objInstance.HappenTime
				s:(CreateDate '= "") CreateDate = $ZD(CreateDate,3)
				s:(CreateTime '= "") CreateTime = $ZT(CreateTime,1)
				s:(ModifyDate '= "") ModifyDate = $ZD(ModifyDate,3)
				s:(ModifyTime '= "") ModifyTime = $ZT(ModifyTime,1)
				s:(HappenDate '= "") HappenDate = $ZD(HappenDate,3)
				s:(HappenTime '= "") HappenTime = $ZT(HappenTime,1)
				s Title = objInstance.Title
				
				s Data = $lb(InstanceID,CreateDate,CreateTime,ModifyDate,ModifyTime,HappenDate,HappenTime,Title)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1
			}
		}
	
	q $$$OK
}

ClassMethod GetInstanceDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstanceDataExecute ]
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

ClassMethod GetInstanceDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstanceDataExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取某质控结构下的界面模板集合;
/// Input:	AStructID为质控结构RowID;
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.EPRInfo","GetEPRTemplates","11")
Query GetEPRTemplates(AStructID As %String) As %Query(ROWSPEC = "TemplateId:%String,TemplateName:%String")
{
}

ClassMethod GetEPRTemplatesExecute(ByRef qHandle As %Binary, AStructID As %String) As %Status
{
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AStructID = "") $$$OK
	
	s (TemplateID,TemplateName) = ""
	
	s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(AStructID)
	q:(objStruct = "") $$$OK
	
	s CategoryID = objStruct.BindCategoryId
	q:(CategoryID = "") $$$OK
	
	s type = objStruct.Type
	
	if (type = "EMR")
	{
		s RowID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_CategoryID,0))
		While(RowID '= "")
		{
			s TemplateID = RowID
			s objTemplate = ##Class(EMRmeta.Template).%OpenId(RowID)
			continue:(objTemplate = "")
			s TemplateName = objTemplate.Name    //$list($g(^DHCEMRM.TemplateD(RowID)),5)
			s Data = $lb(TemplateID,TemplateName)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind+1

			s RowID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_CategoryID,RowID))
		}		
	}
	else
	{
		s RowID = $o(^DHCEPRM.TemplateI("IndexCategoryId"," "_CategoryID,0))
		While(RowID '= "")
		{
			s TemplateID = RowID
			s objTemplate = ##Class(EPRmeta.Template).%OpenId(RowID)
			continue:(objTemplate = "")
			s TemplateName = objTemplate.Name  //$list($g(^DHCEPRM.TemplateD(RowID)),5)
		
			s Data = $lb(TemplateID,TemplateName)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind+1

			s RowID = $o(^DHCEPRM.TemplateI("IndexCategoryId"," "_CategoryID,RowID))
		}
	}
	q $$$OK
}

ClassMethod GetEPRTemplatesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEPRTemplatesExecute ]
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

ClassMethod GetEPRTemplatesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEPRTemplatesExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:根据字典code获得字典描述
/// Input:ADicCode 字典表代码 ,AItemCode 字典项目中code值
/// Output Desc AItemCode 对应描述
/// Debug w ##Class(EPRservice.Quality.DataGather.EPRInfo).GetDictionaryByCode("S01","110000")
ClassMethod GetDictionaryByCode(ADicCode As %String, AItemCode As %String) As %String
{
	s ds = ##Class(%ResultSet).%New("EPRmeta.StdDictionary:GetStdDicList")
	d ds.Execute(ADicCode,"",AItemCode,"",1,1)
	s Desc = ""
	While(ds.Next())
	{
		s Desc = ds.Data("DicDesc")
	}
	q Desc
}

ClassMethod GetUserIDByUserCode(AUserCode As %String) As %String
{
	s userID = ""
	&sql(select SSUSR_RowId into :userID from SQLUser.SS_User where SSUSR_Initials = :AUserCode)
	q userID
}

ClassMethod GetUserNameByUserID(AUserID As %String) As %String
{
	s userName = ""
	&sql(select SSUSR_Name into :userName from SQLUser.SS_User where SSUSR_RowId = :AUserID)
	q userName
}

/// 获取主管医生姓名
ClassMethod GetMainDocByEpisodeID(AEpisodeID As %String) As %String
{
	q:(AEpisodeID ="") ""
	
	s ret = $p(##class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(AEpisodeID),"^",3)
	q ret
}

/// 获取主管医生UserID
/// Debug w ##Class(EPRservice.Quality.DataGather.EPRInfo).GetMainDocIDByEpisodeID("373")
ClassMethod GetMainDocIDByEpisodeID(AEpisodeID As %String) As %String
{
	q:(AEpisodeID ="") ""
	
	s mainDocCode = $p(##class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(AEpisodeID),"^",2)
	s ret = ..GetUserIDByUserCode(mainDocCode)
	q ret
}

/// 获取主治医生姓名
/// Debug w ##Class(EPRservice.Quality.DataGather.EPRInfo).GetAttendDocByEpisodeID("373")
ClassMethod GetAttendDocByEpisodeID(AEpisodeID As %String) As %String
{
	q:(AEpisodeID ="") ""
	
	s attendDocID = ..GetAttendDocIDByEpisodeID(AEpisodeID)
	s ret = ..GetUserNameByUserID(attendDocID)
	q ret
}

/// 获取主治医生ID
/// Debug w ##Class(EPRservice.Quality.DataGather.EPRInfo).GetAttendDocIDByEpisodeID("373")
ClassMethod GetAttendDocIDByEpisodeID(AEpisodeID As %String) As %String
{
	q:(AEpisodeID ="") ""
	
	s mainDocCode = $p(##class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(AEpisodeID),"^",2)
	s userID = ..GetUserIDByUserCode(mainDocCode)
	s AttendDocID = ##class(EPRservice.Privilege.BOPowerUser).GetUserSuperiorUserID(userID)
	s AttendDocID = $p(AttendDocID,"^",1)
	q AttendDocID
}

/// Desc:		获取病历书写类型(EPR or EMR)
/// Creator:	Candy
/// CreateDate:	2014-10-11
/// Input:		AEpisodeID 就诊ID
/// 				ATestLocIDs 试点科室ID 为空为全部科室为试点科室
/// Output:     result EMR or EPR or ""
/// Dubug:      w ##Class(EPRservice.Quality.DataGather.EPRInfo).GetRecordWriteType(76,"")
ClassMethod GetRecordWriteType(AEpisodeID As %String, ATestLocIDs As %String = "") As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s Loc = ##Class(EPRservice.Quality.DataGather.AdmInfo).AdmDept(AEpisodeID)
	q:(Loc = "") result
	s LocId = $p(Loc,"^",1)
	q:(LocId = "") result
	s result = "EMR"
	if ($d(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID))>0) 
	{
		s result = "EPR"
	}
	elseif (ATestLocIDs '= "")
	{
		s flag = 0
		s count = $l(ATestLocIDs,"^")
		for I=1:1:count
		{
			s TempLocID = $p(ATestLocIDs,"^",I)
		    s:(TempLocID = LocId) flag = 1
			q:(flag = 1)
		}
		s:(flag = 0) result = "EPR"
	}
	q result
}

}
