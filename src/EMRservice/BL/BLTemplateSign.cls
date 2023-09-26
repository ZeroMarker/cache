/// 名称：		EMRservice.BL.BLTemplateSign
/// 描述：		待签BL层
/// 编写者：	yejian
/// 编写时间：	2018-12-5
Class EMRservice.BL.BLTemplateSign Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:	Donglulu
/// CreatDate:  2022-6-9
/// Desc:		获取待签角色
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTemplateSign","SeletcSignRole")
Query SeletcSignRole() As %Query(ROWSPEC = "ActionCode:%String,Description:%String,RoleLevel:%String")
{
}

ClassMethod SeletcSignRoleExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s roleLevel = ""
	for {
		s roleLevel = $o(^DHCEMRM.SignRoleI("IdxRoleLevel",roleLevel))
		q:(roleLevel = "")	
			
		s arowID = ""
		for {
			s arowID = $o(^DHCEMRM.SignRoleI("IdxRoleLevel",roleLevel,arowID))
			q:(arowID = "")	
			s objSignRole = ##Class(EMRmeta.SignRole).%OpenId(arowID)
			continue:(objSignRole.IsValid '= "1")
			s ActionCode = objSignRole.ActionCode
			s Description = objSignRole.Description
			s RoleLevel = objSignRole.RoleLevel
			
			s Data = $lb(ActionCode,Description,RoleLevel)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1
			
			if (ActionCode = "viceChiefCheck")
			{
				s ActionCode = "chiefCheck/viceChiefCheck"
				s Description = "主任/副主任医师"
				
				s Data = $lb(ActionCode,Description,RoleLevel)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1
			}
		}
	}
	
	q $$$OK
}

ClassMethod SeletcSignRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SeletcSignRoleExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SeletcSignRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SeletcSignRoleExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:	yejian
/// CreatDate:  2018-12-5
/// Desc:		获取所有配置信息
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTemplateSign","SelectSignData","1","617")
Query SelectSignData(aTemplateID As %String, aVersionNum As %String) As %Query(ROWSPEC = "ID:%Integer,TemplateID:%String,TemplateVersion:%String,ActionCode:%String,Description:%String,TitleCode:%String,TitleName:%String,SignType:%String,RoleRuleCode:%String,Sequence:%String,IsForce:%String")
{
}

ClassMethod SelectSignDataExecute(ByRef qHandle As %Binary, aTemplateID As %String, aVersionNum As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s arowID = ""
	for {
		s arowID = $o(^DHCEMRM.TemplateSignI("IndexTIDVersion"," "_aTemplateID,aVersionNum,arowID))
		q:(arowID = "")	
		s objTemplateSign = ##Class(EMRmeta.TemplateSign).%OpenId(arowID)
		s TemplateID = objTemplateSign.TemplateID
		s TemplateVersion = objTemplateSign.TemplateVersion
		s ActionCode = objTemplateSign.ActionCode
		s Description = objTemplateSign.Description
		s TitleCode = objTemplateSign.TitleCode
		s TitleName = objTemplateSign.TitleName
		s SignType = objTemplateSign.SignType
		s RoleRuleCode = objTemplateSign.RoleRuleCode
		s Sequence = objTemplateSign.Sequence
		s IsForce = objTemplateSign.IsForce
		
		s Data = $lb(arowID,TemplateID,TemplateVersion,ActionCode,Description,TitleCode,TitleName,SignType,RoleRuleCode,Sequence,IsForce)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod SelectSignDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectSignDataExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectSignDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectSignDataExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 添加待签数据
/// asigns数据格式为(格式为 signCode1|Description^signCode2|Description^signCode3|Description)
ClassMethod AddTemplateSignS(aTemplateSign As EMRservice.entity.ETemplateSign, aSignS As %String) As %String
{
	
	q:((aSignS="")||(aTemplateSign="")|| (aSignS = $c(0))) "0"
	
	s strSignCount = $l(aSignS, "^")
	
	//保存选中的科室
	s i = 1
	WHILE (i <= strSignCount) 
	{
		s curstrSignID = $p(aSignS, "^", i)
		s strcurstrSignID = $p(curstrSignID,"|",1)
		s strcurstrSignName = $p(curstrSignID,"|",2)
		s strRoleLevel = $p(curstrSignID,"|",3)
		if (curstrSignID '= "")
		{
			
			//如果没有,则新增;有则不处理
			s objSignItem = ##class(EMRmeta.TemplateSign).%New()
			
			s objSignItem.TemplateID = aTemplateSign.TemplateID
			s objSignItem.TemplateVersion = aTemplateSign.TemplateVersion
			s objSignItem.TitleCode = aTemplateSign.TitleCode
			s objSignItem.TitleName = aTemplateSign.TitleName
			s objSignItem.IsForce = aTemplateSign.IsForce
			s strSignType = ""
			if (strcurstrSignID ="patientSign")
			{
				s strSignType = "PATIENT"
			}
			else
			{
				s strSignType = "MEDICAL"
			}
			s objSignItem.SignType = strSignType
			s objSignItem.ActionCode = strcurstrSignID
			s objSignItem.Description = strcurstrSignName
			s objSignItem.Sequence = strRoleLevel
			s sc = objSignItem.%Save()
			if ($$$ISOK(sc))
			{
				
				s res = objSignItem.%Id()
				
			}
			d objSignItem.%Close()
			s objSignItem = ""
			
		}
		s i = i + 1
	}	
	//返回
	q "1"
}

/// 添加待签数据（根据版本）
/// aTemplateID:模板ID，aOVersion：旧版本号，aNVersion，新版本号
ClassMethod AddTemSignSByVersion(aTemplateID As %String, aOVersion As %String, aNVersion As %String) As %String
{
	s res ="0"
	q:((aOVersion="")||(aNVersion="")||(aTemplateID="")) res
	q:((aOVersion=$c(0))||(aNVersion=$c(0))||(aTemplateID=$c(0))) res
	
	s arowID = ""
	for {
		s arowID = $o(^DHCEMRM.TemplateSignI("IndexTIDVersion"," "_aTemplateID,aOVersion,arowID))
		q:(arowID = "")	
		s objTemplateSign = ##Class(EMRmeta.TemplateSign).%OpenId(arowID)
		//如果没有,则新增;有则不处理
		s objSignItem = ##class(EMRmeta.TemplateSign).%New()
		
		s objSignItem.TemplateID = objTemplateSign.TemplateID
		s objSignItem.TemplateVersion = aNVersion
		s objSignItem.ActionCode = objTemplateSign.ActionCode
		s objSignItem.Description = objTemplateSign.Description
		s objSignItem.TitleCode = objTemplateSign.TitleCode
		s objSignItem.TitleName = objTemplateSign.TitleName
		s objSignItem.SignType = objTemplateSign.SignType
		s objSignItem.RoleRuleCode = objTemplateSign.RoleRuleCode
		s objSignItem.Sequence=objTemplateSign.Sequence
		s objSignItem.IsForce=objTemplateSign.IsForce
		s sc =objSignItem.%Save()
		if ($$$ISOK(sc))
		{
			s res = objSignItem.%Id()
		}
		d objSignItem.%Close()
		d objTemplateSign.%Close()
		s objSignItem = ""
			
	}
	s id=$O(^DHCEMRM..TemplateSignConfigI("IndexTIDVersion"," "_$zcvt(aTemplateID,"U"),aOVersion,""))
	q:(id = "") res
	s objConfigO = ##Class(EMRmeta.TemplateSignConfig).%OpenId(id)
	s objConfig = ##Class(EMRmeta.TemplateSignConfig).%New()
	s objConfig.TemplateID = aTemplateID
	s objConfig.TemplateVersion = aNVersion
	s objConfig.HasSign = objConfigO.HasSign
	s sc= objConfig.%Save()	
	//返回
	q res
}

/// 删除待签数据(id1^id2^id3)
ClassMethod DeleteSignByIDs(aSignIds As %String) As %String
{
	s res = "1"
	q:(aSignIds="") res
	//删除未选中的科室
	s delCount = $l(aSignIds,"^")
	s i = 1
	WHILE (i <= delCount) 
	{
		s signRowID = $p(aSignIds, "^", i)
		if (signRowID '= "")
		{
			s itemLocRowID = ^DHCEMRM.TemplateSignD(signRowID)
			//如果有,则删除; 没有则不处理
			if (itemLocRowID '= "")
			{
				d ##class(EMRmeta.TemplateSign).%DeleteId(signRowID)
			}
		}
		s i = i + 1
	}
	q res
}

/// 删除待签数据（根据版本）
/// aTemplateID:模板ID，aVersion：版本号
ClassMethod DelTemSignSByVersion(aTemplateID As %String, aVersion As %String) As %String
{
	
	q:((aVersion="")||(aTemplateID="")) "0"
	q:((aVersion=$c(0))||(aTemplateID=$c(0))) "0"
	
	&sql(DELETE FROM emrmeta.templatesign WHERE TemplateID = :aTemplateID AND TemplateVersion =:aVersion)
	
	&sql(DELETE FROM EMRmeta.TemplateSignConfig WHERE TemplateID = :aTemplateID AND TemplateVersion =:aVersion)
		
	//返回
	q "1"
}

/// Creator:	yejian
/// CreatDate:  2018-12-5
/// Desc:		更新角色规则）
/// Input：     aTemplateID:模板ID，
ClassMethod GetTitleRelevance(aTemplateID As %String) As %String
{
	
	q:((aTemplateID=$c(0))||(aTemplateID="")) "0"
	s strCount = "0"
	&sql(SELECT count(t.TitleCode) into :strCount FROM EMRmeta.TitleConfig t 
JOIN emrmeta.emrtemplate e ON t.TemplateID = e.ID  WHERE e.BindTemplateID = :aTemplateID)
		
	//返回
	q strCount
}

/// Creator:	yejian
/// CreatDate:  2018-12-5
/// Desc:		更新角色规则
/// Input：		aRoleRuleS数据格式为(格式为 RoleRuleCode^RoleRuleCode)
/// Return：	失败：0，成功：1
ClassMethod UpdateRoleRuleS(aTemplateSign As EMRservice.entity.ETemplateSign, aRoleRuleS As %String) As %String
{
	s res = "0"
	q:((aTemplateSign="")) res
	
	//如果没有,则新增;有则不处理
	s objSignItem = ##class(EMRmeta.TemplateSign).%OpenId(aTemplateSign.ID)
	
	s objSignItem.RoleRuleCode = aRoleRuleS
	s sc = objSignItem.%Save()
	if ($$$ISOK(sc))
	{
		
		s res = "1"
		
	}
	d objSignItem.%Close()
	s objSignItem = ""
	
		
	//返回
	q res
}

/// Creator:	yejian
/// CreatDate:  2018-12-5
/// Desc:		跟新排序
/// Return：	失败：0，成功：1
ClassMethod UpdateSequences(argStr As %String) As %String
{
	s $zt = "Error"
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		S argstrItem= $P(argStr,",",I)
		S argID = $P(argstrItem,"^",1)
		S argSeq = $P(argstrItem,"^",2)
		if ($d(argID)=0)||($d(argSeq)=0)||(argID="")||(argSeq="")
		{
			s strMrk = 0
			q
		}
		s objTemSign="",result=""
		s objTemSign=##class(EMRmeta.TemplateSign).%OpenId(argID)
		if (objTemSign ="")
		{
			s strMrk = 0
			q
		}	
		s objTemSign.Sequence=argSeq
		s result=""
		if '(objTemSign.%Save())
		{
			s strMrk = 0
		    q
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 q 0
	 }
	TCOMMIT
	q 1
Error
	TROLLBACK
	q 0
}

/// Creator:	yejian
/// CreatDate:  2018-12-5
/// Desc:		修复签名级别
/// debug: w ##Class(EMRservice.BL.BLTemplateSign).initSequence()
ClassMethod initSequence() As %String
{
	s res = 0
	
	s arowID = ""
	for {
		s arowID = $o(^DHCEMRM.TemplateSignD(arowID))
		q:(arowID = "")	
		s objTemSign = ##Class(EMRmeta.TemplateSign).%OpenId(arowID)
		s rowId  = $o(^DHCEMRM.SignRoleI("IdxActionCode"," "_$zcvt(objTemSign.ActionCode,"U"),""))
		continue:(rowId = "")
		s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
		s objTemSign.Sequence = obj.RoleLevel
		s sc = objTemSign.%Save()
		if ($$$ISOK(sc))
		{
			s res =res+1
		}
	}
	d objTemSign.%Close()
	s objTemSign = ""

	//返回
	q res
}

/// Desc:     	判断待签状态
/// Creator:   	董璐璐
/// CreateDate:	2018-12-5
/// Input:     	ATemplateId 		模板ID
///           	ATemplateVersion 	模板版本号
///           	ATitleCode			titleCode
///           	ASignType 			(医务人员待签：MEDICAL，患者待签：PATIENT)
///           	AHasSign  			是否有签名
///           	AEpsiodeId			就诊号
///           	ADocId				
///           	AListNo
///           	ARevokeSign			系统参数IsRevokeSign
/// Output:    	0 不显示待签  1 显示待签
/// debug:     	w ##Class(EMRservice.BL.BLTemplateSign).GetSignWaitStatus(96,31,"","MEDICAL",1,456449,879,11,"Y")
ClassMethod GetSignWaitStatus(ATemplateId As %String, ATemplateVersion As %String, ATitleCode As %String, ASignType As %String, AHasSign As %String, AEpsiodeId As %String, ADocId As %String, AListNo As %String, ARevokeSign As %String) As %String
{
	s result = "0"
	q:(ATemplateId = "")||(ATemplateVersion = "")||(ASignType = "")||(AHasSign = "")||(AEpsiodeId = "")||(ADocId = "")||(AListNo = "")||(ATitleCode = "") -1
	
	if ($o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," "_ATemplateId,ATemplateVersion," "_ATitleCode," "_ASignType," Y","")) '= "")
	{
		s actionCode = ""
		for
		{
			s actionCode = $o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," "_ATemplateId,ATemplateVersion," "_ATitleCode," "_ASignType," Y",actionCode))
			q:(actionCode = "")
			//判断同一个待签actionCode配置了几个

			s templateSign = ""
			s waitSignCount = 0
			for
			{
				s templateSign = $o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," "_ATemplateId,ATemplateVersion," "_ATitleCode," "_ASignType," Y",actionCode,templateSign))
				q:(templateSign = "")
				s waitSignCount = waitSignCount + 1
			}
			//判断该份病历同一个actionCode实际有几个签名
			
			s signCount = 0
			s length = $l(actionCode,"/")
			for I=1:1:length
			{
				s curAction = $p(actionCode,"/",I)
				q:(curAction = "")
				s:(I > 1) curAction = " "_curAction
				s sign = ""
				for
				{
					s sign = $o(^DHCEMRI.EMRSignI("IdxMain"," "_AEpsiodeId," "_ADocId," "_AListNo,curAction,sign))
					q:(sign = "")
					if (ARevokeSign = "N")
					{
						s signCount = signCount + 1
					}
					else
					{
						s objSign = ##Class(EMRinstance.EMRSign).%OpenId(sign)
						continue:(objSign = "")
						continue:(objSign.isSignValid '= "1")
						s signCount = signCount + 1
					}
				}
			}
			//实际签名小于配置签名个数退出，需待签
			if (signCount < waitSignCount)
			{
				s result = "1"
				q
			}
		}
	}
	else
	{
		if (ASignType = "MEDICAL")
		{
			s:(AHasSign = "0") result = "1"
		}
	}	
		
	q result
}

/// Desc: 		    查询该次就诊未签名的病历
/// Creator:		Donglulu
/// CreateDate: 	2019-1-14
/// Input:          ACTLocId 科室
///                 ASSgroupId 安全组
///                 AEpisodeId 就诊号
/// Output: 	    未签名数量 ^ 未签名病历docID
/// Debug:          w ##Class(EMRservice.BL.BLTemplateSign).GetWaitSignInstance(155,29,11804839,"viceChiefCheck")	
ClassMethod GetWaitSignInstance(ACTLocId As %String, ASSgroupId As %String, AEpisodeID As %String, AAction As %String, AUserID As %String = "") As %String
{
	s count = 0
	s allInstance = ""
	q:(ACTLocId = "")||(AEpisodeID = "")||(ASSgroupId = "") count	
		
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocId,ASSgroupId,AEpisodeID)
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryID = result.Data("ItemCategoryID")
		s docIds = ##Class(EMRservice.BL.BLClientCategory).GetDocIdsByParent(categoryID)
		s length = $l(docIds,",")
		for I=1:1:length
		{
			s docID = $p(docIds,",",I)
			
			s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docID,""))
			continue:(ECRecordID = "")
			s happenDate = ""
			for
			{
				s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate))
				q:(happenDate = "")
				s happenTime = ""
				for
				{
					s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate,happenTime))
					q:(happenTime = "")
					s listNo = ""
					for
					{
						s listNo = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate,happenTime,listNo))
						q:(listNo = "")
						s instanceID = ECRecordID_"||"_listNo
						//病历有无签名
						if (AAction = "Check")
						{
							s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docID)
							continue:(objCategoryDoc = "")
							s isWaitSign = objCategoryDoc.IsWaitsign
							if (isWaitSign = "1")
							{
								s hasSign = "1"
							}
							else
							{
								//病历医师签名选项显示未签名病历,有签名的退出
								s hasSign = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(AEpisodeID,docID,listNo)
							}
							
						}
						else
						{
							if (AAction = "patientSign")
							{
								s actionType = "PATIENT"
							}
							else
							{
								s actionType = "MEDICAL"
							}
							s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
							q:(objInstance = "")
							s revokeSign = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsRevokeSign","Y")
							s waitTitleCode = objInstance.TitleCode
							s:(objInstance.TheECRecord.DocumentCharacteristic = "0") waitTitleCode = $zcvt(objInstance.TheECRecord.ChartItemType,"U")
							s hasSign = "1"
							s slength = $l(AAction,"^")
							for J=1:1:slength
							{
								s action = $p(AAction,"^",J)
								s hasSignFlag = ##Class(EMRservice.BL.BLTemplateSign).IsWaitHasSign(objInstance.RealTemplateID,objInstance.TemplateVersion,waitTitleCode,actionType,AEpisodeID,docID,listNo,revokeSign,action,AUserID)
								s hasSign = hasSign && hasSignFlag
							}
						}
						continue:(hasSign'="0")
						s count = count + 1
						s:(allInstance '= "") allInstance = allInstance_"^"
						s allInstance = allInstance_instanceID
					}
				}
			}	
		}
	} 
	s allInstance = count_"#"_allInstance
	q allInstance
}

/// Desc:     	判断该病历是否模板配置了某个签名的待签属性并且未签名
/// Creator:   	董璐璐
/// CreateDate:	2019-1-14
/// Input:     	ATemplateId 		模板ID
///           	ATemplateVersion 	模板版本号
///           	ATitleCode			titleCode
///           	ASignType 			(医务人员待签：MEDICAL，患者待签：PATIENT)
///           	AEpsiodeId			就诊号
///           	ADocId				
///           	AListNo
///           	ARevokeSign			系统参数IsRevokeSign
///           	AActionCode  		签名操作
/// Output:    	0 未签名需待签病历
/// debug:     	w ##Class(EMRservice.BL.BLTemplateSign).IsWaitHasSign(96,31,"","MEDICAL",1,456449,879,11,"Y")
ClassMethod IsWaitHasSign(ATemplateId As %String, ATemplateVersion As %String, ATitleCode As %String, ASignType As %String, AEpsiodeId As %String, ADocId As %String, AListNo As %String, ARevokeSign As %String, AActionCode As %String, AUserID As %String = "") As %String
{
	s result = "1"
	q:(ATemplateId = "")||(ATemplateVersion = "")||(ASignType = "")||(AEpsiodeId = "")||(ADocId = "")||(AListNo = "")||(AActionCode = "")||(ATitleCode = "") -1
	
	if ($o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," "_ATemplateId,ATemplateVersion," "_ATitleCode," "_ASignType," Y","")) '= "")
	{
		//判断同一个待签actionCode配置了几个
		s templateSign = ""
		s waitSignCount = 0
		for
		{
			s templateSign = $o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," "_ATemplateId,ATemplateVersion," "_ATitleCode," "_ASignType," Y"," "_$zcvt(AActionCode,"U"),templateSign))
			q:(templateSign = "")
			s waitSignCount = waitSignCount + 1
		}
		//判断该份病历同一个actionCode实际有几个签名
		s actionCode = " "_$zcvt(AActionCode,"U")
		s signCount = 0
		s length = $l(actionCode,"/")
		for I=1:1:length
		{
			s curAction = $p(actionCode,"/",I)
			q:(curAction = "")
			s:(I > 1) curAction = " "_curAction
			s sign = ""
			for
			{
				s sign = $o(^DHCEMRI.EMRSignI("IdxMain"," "_AEpsiodeId," "_ADocId," "_AListNo,curAction,sign))
				q:(sign = "")
				if (ARevokeSign = "N")
				{
					s signCount = signCount + 1
				}
				else
				{
					s objSign = ##Class(EMRinstance.EMRSign).%OpenId(sign)
					continue:(objSign = "")
					continue:(objSign.isSignValid '= "1")
					s signCount = signCount + 1
				}
			}
		}
		
		//登录用户是否是患者的对应级别医师
		s isPatientDoctor = ##Class(EMRservice.BL.BLTemplateSign).IsPatientDoctor(AEpsiodeId,AActionCode,AUserID)
		
		//实际签名小于配置签名个数退出，需待签
		if ((signCount < waitSignCount)&&(isPatientDoctor = "1"))
		{
			s result = "0"
		}
	}
	q result
}

/// Desc:       获取病历信息
/// Creator:    donglulu
/// CreateDate: 2019-1-14
/// Input:      AInstanceIDs instanceID,以^分隔
/// Output:     json
/// w ##Class(EMRservice.BL.BLTemplateSign).GetRecordData("")
ClassMethod GetRecordData(AInstanceIDs As %String, AInterface As %String) As %String
{
	s json = ""
	s count = 0
	q:(AInstanceIDs = "") "{""total"":"_count_",""rows"":["_json_"]}"
	s length = $l(AInstanceIDs,"^")
	for I=1:1:length
	{
		s instanceID = $p(AInstanceIDs,"^",I)
		s ecrecordID = $p(instanceID,"||",1)
		s subID = $p(instanceID,"||",2)
		s result = ##Class(EMRservice.BL.BLClientCategory).GetInstanceJsonByID(ecrecordID,subID,"List")
		continue:(result = "")
		
		s result = $e(result,1,$l(result)-1)
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
		continue:(objInstance = "")
		s epsiodeId = objInstance.TheECRecord.RealEpisodeID
		s docId = objInstance.TheECRecord.RealChartItemID
		if (AInterface ="HISUI"){
			s url = "emr.interface.ip.edit.csp?EpisodeID="_epsiodeId_"&DocID="_docId_"&InstanceID="_instanceID
		}
		else
		{
			s url = "emr.record.interface.csp?EpisodeID="_epsiodeId_"&DocID="_docId_"&InstanceID="_instanceID
		}
		s desc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","电子病历")
		s patientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(epsiodeId)
		s result = result_",""patientID"":"""_patientID_""""
		s result = result_",""record"":"""_url_""""
		s result = result_"}"
		
		s json = json_result
		s json = json_","
		s count = count + 1
	}
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	q "["_json_"]"
}

/// Desc:		病历是否签名
/// Creator:		Candy
/// CreateDate:	2015-8-10
/// Input:       pEpisodeID 就诊科室
///             pEmrDocID 目录ID
///             pNum 病历序号
/// Debug:       w ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(11983760,375,1)
ClassMethod HasRecordSign(pEpisodeID As %String, pEmrDocID As %String, pNum As %String) As %String
{
	s result = "0"
	s revokeSign = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsRevokeSign","Y")
	s actionCode = ""
	for
	{
		s actionCode = $o(^DHCEMRI.EMRSignI("IdxMain"," "_pEpisodeID," "_pEmrDocID," "_pNum,actionCode))
		q:(actionCode = "")
		continue:(actionCode = " PATIENTSIGN")
		s sign = ""
		for
		{
			s sign = $o(^DHCEMRI.EMRSignI("IdxMain"," "_pEpisodeID," "_pEmrDocID," "_pNum,actionCode,sign))
			q:(sign = "")
			if (revokeSign = "N")
			{
				s result = "1"
				q
			}
			else
			{
				s objSign = ##Class(EMRinstance.EMRSign).%OpenId(sign)
				continue:(objSign = "")
				continue:(objSign.isSignValid '= "1")
				s result = "1"
				q
			}
		}
	}
	q result
}

/// Desc:       初始化EMRmeta.TemplateSign表的Force字段
/// Creator:    donglulu
/// CreateDate: 2019-6-4
/// Input:      
/// Output:     
/// d ##Class(EMRservice.BL.BLTemplateSign).InitTemplateSignForce()
ClassMethod InitTemplateSignForce()
{
	s templateID = ""
	for
	{
		s templateID = $o(^DHCEMRM.TemplateSignI("IndexTIDVersion",templateID))
		q:(templateID = "")
		s templateVersion = ""
		for
		{
			s templateVersion = $o(^DHCEMRM.TemplateSignI("IndexTIDVersion",templateID,templateVersion))
			q:(templateVersion = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEMRM.TemplateSignI("IndexTIDVersion",templateID,templateVersion,rowID))
				q:(rowID = "")
				s obj = ##Class(EMRmeta.TemplateSign).%OpenId(rowID)
	    		q:(obj = "")
	    		s obj.IsForce = "Y"
	    		d obj.%Save()
	    		d obj.%Close()	
				k obj
			}
		}
	}
}

ClassMethod GetAppPath() As %String
{
	&sql(SELECT pathtoapp INTO :pathtoapp 
          FROM websys.Configuration
          WHERE ID = 1)	
          
    s:($e(pathtoapp,1,1)'="/") pathtoapp = "/"_pathtoapp
    s:($e(pathtoapp,$L(pathtoapp),$L(pathtoapp))'="/") pathtoapp = pathtoapp_"/"
    
	Quit pathtoapp
}

ClassMethod GetHostIP() As %String
{
	;&sql(SELECT WebServer INTO :hostip FROM websys.Configuration WHERE ID = 1)
	;Quit hostip
	;Q %request.CgiEnvs("SERVER_NAME")
	s hostip=%request.CgiEnvs("SERVER_NAME")
	s:($e(hostip,$l(hostip),$l(hostip))="/") hostip=$e(1,$L(hostip-1))
	Q "http://"_hostip
}

/// Desc:		判断用户是否为本次就诊的对应级别医师（电子病历中给患者设置了三级医师）
/// Creator:	Donglulu
/// CreateDate:	2019-11-29
/// Input:      pEpisodeID 就诊科室
///             pActionCode 签名操作
///             pUserID    登录用户ID
///             未设置患者三级医师返回1 ，是对应级别的医师返回1，对应级别设置的医师和登录医师不一致返回0
/// Debug:       w ##Class(EMRservice.BL.BLTemplateSign).IsPatientDoctor(22,"residentCheck",362)
ClassMethod IsPatientDoctor(pEpisodeID As %String, pActionCode As %String, pUserID As %String) As %String
{
	s result = "1"
	q:(pEpisodeID = "")||(pActionCode = "")||(pUserID = "") result
	s code = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDLevelDoc"," "_pEpisodeID,""))
	q:(code = "") result
	
	s levelCode = ""
	if (pActionCode [ "intern")
	{
		s levelCode = "intern"
	}
	elseif(pActionCode [ "resident")
	{
		s levelCode = "Resident"
	}
	elseif(pActionCode [ "attending")
	{
		s levelCode = "Attending"
	}
	elseif(pActionCode [ "chief")
	{
		s levelCode = "Chief"
	}
	s doctorID = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDLevelDoc"," "_pEpisodeID," "_$zcvt(levelCode,"U"),""))
	q:(doctorID = "") result
	s doctorID = $tr(doctorID," ","")
	s:(doctorID '= pUserID) result = "0"
	
	q result
}

/// w ##class(EMRservice.BL.BLTemplateSign).GetDocumentFinishSign("157737||263")
ClassMethod GetDocumentFinishSign(AInstanceID As %String) As %String
{
	s ret = 0 
	
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)	
	s TemplateID = objInstance.RealTemplateID
	s TemplateVersion = objInstance.TemplateVersion
	s TitleCode = objInstance.TitleCode
	s objTemplate= ##class(EMRmeta.Template).%OpenId(TemplateID)
	s type = objTemplate.ChartItemType
	
	s TitleCode = $case(TitleCode,"":$zcvt(type,"U"),:TitleCode)
	
	s confirmAlertType = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ConfirmAlertType","1")
	if (confirmAlertType = "2")
	{
		//confirmAlertType = "2" 是只返回配置了待签属性，但没有签名的数据（没配置待签属性也没签名的病历不返回）
		
		//获取配置了哪些待签属性
		s ListTemplateSign = ..GetTemplateSignList(TemplateID,TemplateVersion,TitleCode)
		q:(ListTemplateSign="") "1"
		//获取签名信息
		s ListInstanceSign = ..GetInstanceSignList(AInstanceID)
		q:(ListInstanceSign="") "未签名"
	}
	else
	{
		//获取签名信息，如果该病历没签名，并且没有配置不显示待签，则在待签列表中显示该条数据
		s ListInstanceSign = ..GetInstanceSignList(AInstanceID)
		if (ListInstanceSign = "")
		{
			s docId = objInstance.TheECRecord.RealChartItemID
			q:(docId="") "1"
			s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
			q:(objCategoryDoc = "") "1"
			//配置了不显示待签，则isWaitsign=“1”，不显示在待签列表里
			s isWaitsign = objCategoryDoc.IsWaitsign
			if (isWaitsign '= "1")
			{
				q "未签名"
			}
			else
			{
				q "1"
			}
		}
				
		s ListTemplateSign = ..GetTemplateSignList(TemplateID,TemplateVersion,TitleCode)
		q:(ListTemplateSign="") "1"
	}
	
	s ret = $LISTSAME(ListTemplateSign,ListInstanceSign)

	if ret = 0
	{
		SET ptr=0,count=0,requireSignLost=""
		s actionDesc = ""
		WHILE $LISTNEXT(ListTemplateSign,ptr,value) {
			s isSign = $listfind(ListInstanceSign,value)
			continue:(isSign>0)
			s actionID = $o(^DHCEMRM.SignRoleI("IdxActionCode"," "_value,""))
			continue:(actionID = "")
			s objSignRole = ##class(EMRmeta.SignRole).%OpenId(actionID)
			continue:(objSignRole = "")
			s:(actionDesc '= "") actionDesc = actionDesc_","
			s actionDesc = actionDesc_objSignRole.Description
			s ret = "缺少必要的【"_actionDesc_"】签名"
		}	
		s:(ret = "0") ret = "1"	
	}
	q ret
}

/// w ##class(EMRservice.BL.BLTemplateSign).GetTemplateSignList(5,10,"EMR100201")
ClassMethod GetTemplateSignList(ATemplateID As %String, ATemplateVersion As %String, ATiteleCode As %String) As %List
{
		
	s retList=""
	s tmpSignType=""
	for
	{
		s tmpSignType=$o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," "_ATemplateID,ATemplateVersion," "_ATiteleCode,tmpSignType))
		q:(tmpSignType="")
		
		s tmpActionCode = ""
		for
		{
			s tmpActionCode=$o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," "_ATemplateID,ATemplateVersion," "_ATiteleCode,tmpSignType," Y",tmpActionCode))
			q:(tmpActionCode="")
			
			s retList=retList_$lb($e(tmpActionCode,2,*))	
		}
	}
	q retList
}

/// w ##class(EMRservice.BL.BLTemplateSign).GetInstanceSignList("83||4")
ClassMethod GetInstanceSignList(AInstanceID) As %List
{
	s retList=""
	s ecrecordID = +$g(AInstanceID)
	s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ecrecordID)	
	s chartItemID = objECRecord.RealChartItemID
	s EpisodeID = objECRecord.RealEpisodeID
	s num = $p(AInstanceID,"||",2)
	s revokeSign = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsRevokeSign","Y")
	
	s action = ""
	for
	{
		s action = $o(^DHCEMRI.EMRSignI("IdxMain"," "_EpisodeID," "_chartItemID," "_num,action))
		q:(action = "")
		if (revokeSign = "N")
		{
			s retList=retList_$lb($e(action,2,*))
		}
		else
		{
			s sign = $o(^DHCEMRI.EMRSignI("IdxMain"," "_EpisodeID," "_chartItemID," "_num,action,""))
			q:(sign = "")
			s objSign = ##Class(EMRinstance.EMRSign).%OpenId(sign)
			continue:(objSign = "")
			continue:(objSign.isSignValid '= "1")
			s retList=retList_$lb($e(action,2,*))
		}
	}
	q retList
}

/// Desc:		EMRmeta.SignRole的RoleLevel改变时，更新EMRmeta.TemplateSign表的Sequence字段使其一致
/// Creator:	Donglulu
/// CreateDate:	2020-7-30
/// Input:      
/// Debug:       d ##Class(EMRservice.BL.BLTemplateSign).UpdateTemplateSignSequence()
ClassMethod UpdateTemplateSignSequence()
{
	s templateID = ""
	for
	{
		s templateID = $o(^DHCEMRM.TemplateSignI("IndexTIDVersion",templateID))
		q:(templateID = "")
		
		s versionID = ""
		for
		{
			s versionID = $o(^DHCEMRM.TemplateSignI("IndexTIDVersion",templateID,versionID))
			q:(versionID = "")
			
			s rowid = ""
			for
			{
				s rowid = $o(^DHCEMRM.TemplateSignI("IndexTIDVersion",templateID,versionID,rowid))
				q:(rowid = "")
				
				s objTemplateSign = ##Class(EMRmeta.TemplateSign).%OpenId(rowid)
				continue:(objTemplateSign = "")
				s actionCode = objTemplateSign.ActionCode
				continue:(actionCode = "")
				
				s signID  = $o(^DHCEMRM.SignRoleI("IdxActionCode"," "_$zcvt(actionCode,"U"),""))
				continue:(signID = "")
				s obj = ##Class(EMRmeta.SignRole).%OpenId(signID)
				continue:(obj = "")
				s roleLevel = obj.RoleLevel
				continue:(roleLevel = "")
				
				s objTemplateSign.Sequence = roleLevel
				d objTemplateSign.%Save()
				d objTemplateSign.%Close()	
				k objTemplateSign
				
			}
			
		}
		
		
	}
}

/// Desc:     	判断患者PDF待签状态
/// Creator:   	董璐璐
/// CreateDate:	2020-11-13
/// Input:     	ATemplateId 		模板ID
///           	ATemplateVersion 	模板版本号
///           	ATitleCode			titleCode
///           	ASignType 			(医务人员待签：MEDICAL，患者待签：PATIENT)
///           	AHasSign  			是否有签名
///           	AEpsiodeId			就诊号
///           	ADocId				
///           	AListNo
///           	AInstanceID			实例ID
/// Output:    	0 不显示待签  1 显示待签
/// debug:     	w ##Class(EMRservice.BL.BLTemplateSign).GetSignWaitStatus(96,31,"","MEDICAL",1,456449,879,11,"Y")
ClassMethod GetPatientPDFSignWaitStatus(ATemplateId As %String, ATemplateVersion As %String, ATitleCode As %String, ASignType As %String, AHasSign As %String, AEpsiodeId As %String, ADocId As %String, AListNo As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(ATemplateId = "")||(ATemplateVersion = "")||(ASignType = "")||(AHasSign = "")||(AEpsiodeId = "")||(ADocId = "")||(AListNo = "")||(ATitleCode = "")||(AInstanceID = "") -1
	
	if ($o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," "_ATemplateId,ATemplateVersion," "_ATitleCode," "_ASignType," Y","")) '= "")
	{
		q:(##class(%Dictionary.CompiledClass).%ExistsId("EMRservice.BL.BLPDFAuditSignLog") = "0") result
		q:(##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.BL.BLPDFAuditSignLog||GetPDFStatus") = "0") result
		
		s pdfstatus = ##class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(AInstanceID,AEpsiodeId)
		s:(pdfstatus '= "SIGNED") result = "1"
	}	
		
	q result
}

/// Desc:       获取签名角色
/// Creator:    董璐璐
/// CreateDate: 2022-5-10
/// Input:      doctor/nurse
/// Output:     签名角色
/// Debug:      w ##Class(EMRservice.BL.BLTemplateSign).GetSignRole("doctor")
ClassMethod GetSignRole(AType As %String) As %String
{
	s json = ""
	s:(AType = "") AType = "doctor"
	s config = ##Class(EMRservice.BL.BLTemplateSign).GetSignRoleConfig(AType)
	if ((config '= "")&&(config '= "[]"))
	{
		q config
	}
	
	s json = "["
	
	s roleLevel = ""
	for {
	 	s roleLevel = $O(^DHCEMRM.SignRoleI("IdxRoleLevel",roleLevel))
	 	q:(roleLevel = "")
	 	s rowID = ""
	 	for
	 	{
		 	s rowID = $O(^DHCEMRM.SignRoleI("IdxRoleLevel",roleLevel,rowID))
		 	q:(rowID = "")
		 	s obj = ##Class(EMRmeta.SignRole).%OpenId(rowID)
		 	s Code = obj.ActionCode
		 	continue:(Code = "")
		 	continue:(obj.RoleLevel = 0)
		 	s Desc = obj.Description
		 	
		 	continue:(Code = "check" )
		 	
		 	if (AType = "doctor")
		 	{
			 	continue:(Desc [ "护士")
			 	continue:(obj.Name = "ViceChief")
			 	if (obj.Name = "Chief")
			 	{
				 	
				 	s Code = "viceChiefCheck^chiefCheck^chiefCheck/viceChiefCheck"
				 	s Desc = "(副)主任医师签名"
			 	}
		 	}
		 	elseif(AType = "nurse")
		 	{
			 	continue:(Desc '[ "护士")
		 	}
		 	
		 	s:(json '= "[") json =json_","
			s json = json_"{"
			s json = json_"""Name"":"""_obj.Name_""","
			s json = json_"""Action"":"""_Code_""","
			s json = json_"""Desc"":"""_Desc_""""
	    	s json = json_"}"
	 	}
	}

	s json = json_"]"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Desc:       获取配置的签名角色
/// Creator:    董璐璐
/// CreateDate: 2022-5-10
/// Input:      doctor/nurse
/// Output:     签名角色
/// Debug:      w ##Class(EMRservice.BL.BLTemplateSign).GetSignRoleConfig("nurse")
ClassMethod GetSignRoleConfig(AType As %String) As %String
{
	s result = ""
	s config = ##Class(EMRservice.SystemParameter).GetSignRange()
	q:(config = "") result
	if (AType = "doctor")
 	{
	 	s config = $p(config, "|", 1)
 	}
 	elseif(AType = "nurse")
 	{
	 	s config = $p(config, "|", 2)
 	}
	q:(config = "") result

	s json = "["
	s name = ""
	s count=$l(config, "^")
	f i=1:1:count 
	{
		s signInfo = $p(config, "^", i)
		q:(signInfo = "")
		
	 	s rowID = $O(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(signInfo,"U"),""))
	 	continue:(rowID = "")
	 	s obj = ##Class(EMRmeta.SignRole).%OpenId(rowID)
	 	s Code = obj.ActionCode
	 	continue:(Code = "")
	 	s Desc = obj.Description
	 	
	 	continue:(obj.Name = "ViceChief")
	 	if (obj.Name = "Chief")
	 	{
		 	
		 	s Code = "viceChiefCheck^chiefCheck^chiefCheck/viceChiefCheck"
		 	s Desc = "(副)主任医师签名"
	 	}
	 	
	 	s:(json '= "[") json =json_","
		s json = json_"{"
		s json = json_"""Name"":"""_signInfo_""","
		s json = json_"""Action"":"""_Code_""","
		s json = json_"""Desc"":"""_Desc_""""
    	s json = json_"}"
	}
	s json = json_"]"
	s result = $ZSTRIP(json,"*C")
	q result
}

/// Desc:		用户是否为护士[UserIsNur]
/// Modify: 	duan
/// Input: 		argDocID 用户ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BL.BLTemplateSign).UserIsNur("76")
ClassMethod UserIsNur(argDocID As %String) As %String
{
	q:($d(argDocID)=0)||(argDocID="") "0" 
	s LinkId="",CareProvId="",Degree="",TemplateUse=""
	s LinkId=$p($G(^SSU("SSUSR",argDocID)),"^",14)
	q:(LinkId="") "0"
	s CareProvId=$p($G(^CTPCP(LinkId,"1")),"^",4)
	q:(CareProvId="") "0"
	s Degree=$p($G(^CT("CPT",CareProvId)),"^",4)
	q:(Degree="NURSE") "1"
	q "0"
}

}
