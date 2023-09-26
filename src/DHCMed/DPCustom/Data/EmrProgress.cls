/// 名称: DHCMed.DPCustom.Data.EmrProgress
/// 描述: 与日常病程相关的数据接口
/// 编写者：zhufei
/// 编写日期: 2014-02-26
Class DHCMed.DPCustom.Data.EmrProgress Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 记录ID
Property RecordID As %String(TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 目录ID
Property CategoryID As %String(TRUNCATE = 1);

/// InstanceID
Property InstanceID As %String(TRUNCATE = 1);

/// 标题
Property Title As %String(TRUNCATE = 1);

/// 病历内容
Property DataValue As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 短语列表（发热^感染）
Property ActWords As %String(TRUNCATE = 1);

/// 修改日期
Property UpdateDate As %String(TRUNCATE = 1);

/// 修改时间
Property UpdateTime As %String(TRUNCATE = 1);

/// 修改人
Property UpdateUser As %String(TRUNCATE = 1);

/// 发生时间
Property HappenDate As %String(TRUNCATE = 1);

/// 发生时间
Property HappenTime As %String(TRUNCATE = 1);

/// 记录日期
Property ActDate As %String(TRUNCATE = 1);

/// 记录时间
Property ActTime As %String(TRUNCATE = 1);

/// 记录人
Property ActUser As %String(TRUNCATE = 1);

/// 记录人名称
Property ActUserDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.DPCustom.Data.EmrProgress).GetDataByAdm("3666877")
ClassMethod GetDataByAdm(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aActWords As %String = "") As %ListOfObjects
{
	New (aEpisodeID,aDateFrom,aDateTo,aActWords)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-EmrProgress","")
	Set DataType=+DataType
	
	If DataType=1 {
		Set Code=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-EmrProgGlossary","")  //HDSD00.14.139 住院病程
		Set arr=##Class(EMRservice.BIEMRService).GetDataByGlossary(aEpisodeID,Code) 
		Set RecordID=""
		For
		{
		    Set value = arr.GetNext(.RecordID)
		    Quit:(RecordID="")
		    ;w !,RecordID
		    Set obj=..GetObjById1(RecordID)
			Continue:'$IsObject(obj)
			
			Set ActDate=obj.ActDate
			Continue:ActDate=""
			Set tmpDate=ActDate
			Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
			Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
			Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
			Continue:(aDateTo'="")&&(tmpDate>aDateTo)
			
			Set WordList=""
			If aActWords'="" {
				//常用短语筛查（包含）
				Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check1(aActWords,obj.DataValue)
				Continue:checkFlag=""
				For indWord=1:1:$listlength(checkFlag) {
					Set tmpWord=$list(checkFlag,indWord)
					Continue:tmpWord=""
					Set WordList=WordList_"^"_tmpWord
				}
				Set:WordList'="" WordList=$e(WordList,2,$l(WordList))
			}
			Set obj.ActWords = WordList
			Do return.Insert(obj)
		}
		
		//
	} Else {
		//DataType=0 默认取值HIS日常病程
		Set ElCodes=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-EmrProgElCode","")
		For indElCode=1:1:$l(ElCodes,",") {
			Set ElCode=$p(ElCodes,",",indElCode)
			Continue:ElCode=""
			
			Set TemplateID=$p($p(ElCode,"#TID:",2),"#",1)
			Continue:TemplateID=""
			Set tmpTemplate=$g(^DHCEPRM.TemplateD(TemplateID))
			Continue:tmpTemplate=""
			Set CategoryID=$list(tmpTemplate,7)
			Continue:CategoryID=""
			
			Set ds = ##class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
			Do ds.Execute(aEpisodeID,CategoryID,"","","","","")
			While(ds.Next())
			{
				Set MultiDataInfo=ds.Data("MultiDataInfo")
				Set InstanceID=$p(MultiDataInfo,$c(1),2)   //InstanceID
				
				Set RecordID=InstanceID_"||"_ElCode
				Set obj=..GetObjById0(RecordID)
				Continue:'$IsObject(obj)
		    	
				Set ActDate=obj.ActDate
				Continue:ActDate=""
				Set tmpDate=ActDate
				Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
				Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
				Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
				Continue:(aDateTo'="")&&(tmpDate>aDateTo)
				
				Set WordList=""
				If aActWords'="" {
					//常用短语筛查（包含）
					Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check1(aActWords,obj.DataValue)
					Continue:checkFlag=""
					For indWord=1:1:$listlength(checkFlag) {
						Set tmpWord=$list(checkFlag,indWord)
						Continue:tmpWord=""
						Set WordList=WordList_"^"_tmpWord
					}
					Set:WordList'="" WordList=$e(WordList,2,$l(WordList))
				}
				Set obj.ActWords = WordList
				
		    	//Do $system.OBJ.Dump(obj)
				Do return.Insert(obj)
			}
			Do ds.Close()
		}
	}
	
	Quit return
}

/// w ##Class(DHCMed.DPCustom.Data.EmrProgress).GetDataByID("472631||1||#TYPE:TextDesc#TID:26#TVER:0#ECODE:E0001")
ClassMethod GetDataByID(aRecordID As %String) As DHCMed.DPCustom.Data.EmrProgress
{
	New (aRecordID)
	Set return=""
	Quit:(aRecordID="") return
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-EmrProgress","")
	Set DataType=+DataType
	
	If DataType=1 {
		//
	} Else {
		//DataType=0 默认取值HIS日常病程
		Set obj=..GetObjById0(aRecordID)
		//Do $system.OBJ.Dump(obj)
	}
	Set return=obj
	
	Quit return
}

/// 通过HIS系统获取数据对象
ClassMethod GetObjById0(aId As %String) As DHCMed.DPCustom.Data.EmrProgress
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Set InstanceID=$p(aId,"||",1)_"||"_$p(aId,"||",2)
	Set ElCode=$p(aId,InstanceID,2)
	
	Set objInstance=##Class(EPRinstance.InstanceData).%OpenId(InstanceID)
	Quit:'$IsObject(objInstance) return
	Do objInstance.%Close()
	
	Set EpisodeID=objInstance.TheECRecord.EpisodeID
	Set Title=objInstance.Title
	Set HappenDate=objInstance.HappenDate
	Set HappenTime=objInstance.HappenTime
	Set UpdateDate=objInstance.ModifyDate
	Set UpdateTime=objInstance.ModifyTime
	Set UpdateUser=objInstance.ModifyUser
	Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	Set:HappenDate'="" HappenDate=$zd(HappenDate,3)
	Set:HappenTime'="" HappenTime=$zt(HappenTime,1)
	
	Set TemplateID=objInstance.TemplateID
	Set CategoryID=""
	Set tmpTemplate=$g(^DHCEPRM.TemplateD(TemplateID))
	Set:tmpTemplate'="" CategoryID=$list(tmpTemplate,7)
	
	Set EPRData=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID,ElCode,InstanceID)
	Quit:EPRData="" return
	
	//记录ID、记录日期、记录时间、记录人
	Set ActDate=UpdateDate                    //发生日期
	Set ActTime=UpdateTime                    //发生时间
	Set ActUser=UpdateUser,ActUserDesc=""     //修改人
	Set:ActUser'="" ActUserDesc=$p($g(^SSU("SSUSR",ActUser)),"^",2)
	
	Set obj=##Class(DHCMed.DPCustom.Data.EmrProgress).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = aId
	Set obj.TemplateID     = TemplateID
	Set obj.CategoryID     = CategoryID
	Set obj.InstanceID     = InstanceID
	Set obj.Title          = Title
	Set obj.DataValue      = EPRData
	Set obj.ActWords       = ""
	Set obj.UpdateDate     = UpdateDate
	Set obj.UpdateTime     = UpdateTime
	Set obj.UpdateUser     = UpdateUser
	Set obj.HappenDate     = HappenDate
	Set obj.HappenTime     = HappenTime
	Set obj.ActDate        = ActDate
	Set obj.ActTime        = ActTime
	Set obj.ActUser        = ActUser
	Set obj.ActUserDesc    = ActUserDesc
	
	Set return=obj
	Quit return
}

/// 通过HIS系统获取数据对象 新版电子病历
/// w ##Class(DHCMed.DPCustom.Data.EmrProgress).GetObjById1("66||1")
ClassMethod GetObjById1(aId As %String) As DHCMed.DPCustom.Data.EmrProgress
{
	New (aId)
	Set return=""
	Quit:aId="" return
 
	Set InstanceID=aId
	
	Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
	Quit:'$IsObject(objInstance) return
	Do objInstance.%Close()
	
	Set EpisodeID=objInstance.TheECRecord.EpisodeID
	Set Title=objInstance.Title
	Set HappenDate=objInstance.HappenDate
	Set HappenTime=objInstance.HappenTime
	Set UpdateDate=objInstance.ModifyDate
	Set UpdateTime=objInstance.ModifyTime
	Set UpdateUser=objInstance.ModifyUser
	Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	Set:HappenDate'="" HappenDate=$zd(HappenDate,3)
	Set:HappenTime'="" HappenTime=$zt(HappenTime,1)
	 
	Set TemplateID=objInstance.TemplateID
	Set CategoryID=objInstance.GroupItemID   //^DHCEMRM.TemplateD可能有变化
	//Set CategoryID=""
	//Set tmpTemplate=$g(^DHCEMRM.TemplateD(TemplateID))
	//Set:tmpTemplate'="" CategoryID=$list(tmpTemplate,9)
    
	Set Code=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-EmrProgGlossary","")  //HDSD00.14.139 住院病程
	Set arr=##Class(EMRservice.BIEMRService).GetDataByGlossary(EpisodeID,Code) 
	Set EPRData = arr.GetAt(.InstanceID)
	Quit:EPRData="" return
 
	//记录ID、记录日期、记录时间、记录人
	Set ActDate=UpdateDate                    //发生日期
	Set ActTime=UpdateTime                    //发生时间
	Set ActUser=UpdateUser,ActUserDesc=""     //修改人
	Set:ActUser'="" ActUserDesc=$p($g(^SSU("SSUSR",ActUser)),"^",2)
	
	Set obj=##Class(DHCMed.DPCustom.Data.EmrProgress).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = aId
	Set obj.TemplateID     = TemplateID
	Set obj.CategoryID     = CategoryID
	Set obj.InstanceID     = InstanceID
	Set obj.Title          = Title
	Set obj.DataValue      = EPRData
	Set obj.ActWords       = ""
	Set obj.UpdateDate     = UpdateDate
	Set obj.UpdateTime     = UpdateTime
	Set obj.UpdateUser     = UpdateUser
	Set obj.HappenDate     = HappenDate
	Set obj.HappenTime     = HappenTime
	Set obj.ActDate        = ActDate
	Set obj.ActTime        = ActTime
	Set obj.ActUser        = ActUser
	Set obj.ActUserDesc    = ActUserDesc
	
	Set return=obj
	Quit return
}

}
