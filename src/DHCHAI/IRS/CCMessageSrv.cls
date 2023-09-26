/// 名称: DHCHAI.IRS.CCMessageSrv
/// 描述: 疑似病历消息相关服务
/// 编写者：chenjb
/// 编写日期: 2017-08-09
Class DHCHAI.IRS.CCMessageSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-08-07
/// Description:  根据病人查询消息记录
/// Table：       
/// Input：       aPutNum:显示最新记录的条数
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCMessageSrv","QryMsgByPaadm","50","")
Query QryMsgByPaadm(aPaadm As %String, aIsRead As %String, aPutNum As %String = "") As %Query(ROWSPEC = "ID:%String,CSMsgType:%String,MTitle:%String,CSMessage:%String,CSIsRead:%String,CSReadDate:%String,CSReadTime:%String,CSReadUserDr:%String,CSReadUser:%String")
{
}

ClassMethod QryMsgByPaadmExecute(ByRef qHandle As %Binary, aPaadm As %String, aIsRead As %String, aPutNum As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aPaadm="") $$$OK
 	
 	K arrMessage
 	Set Count=0
 	Set xDate =""
 	For {
	 	Set xDate = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aPaadm,xDate),-1)
		Quit:xDate=""
		Quit:(aPutNum'="")&&(ind>aPutNum)   // 输出消息条数限制，数据量大导致消息显示一直在加载中
		Set xTime = ""
		For {
			Set xTime = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aPaadm,xDate,xTime),-1)
			Quit:xTime=""
		 	Set xID = ""
			For {
				Set xID = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aPaadm,xDate,xTime,xID),-1)
				Quit:xID=""
				
				Set obj = ##class(DHCHAI.IR.CCMessage).GetObjById(xID)
				Continue:'$Isobject(obj)				
			
				Set CSIsRead =obj.CSIsRead
				//如果是未读去同步消息状态	
				if CSIsRead = 0 {
					Set MsgDtls = +obj.CSMsgDtlID
					if MsgDtls>0{
						Set obj = ##class(DHCHAI.IRS.CCMessageSrv).MsgStatusFromHIS(obj)
						Continue:'$Isobject(obj)
						Set CSIsRead =obj.CSIsRead
					}
				}
				
				Continue:(aIsRead'="")&&(aIsRead'=CSIsRead)	
				Set Count=Count+1
				Continue:(aPutNum'="")&&(Count>aPutNum)
				Set arrMessage(xID)=""
			}
		}
 	}
 
 	Set xMsgID=0
 	For {
	 	Set xMsgID=$o(arrMessage(xMsgID))
	 	Quit:xMsgID=""
	 
	 	Set obj = ##class(DHCHAI.IR.CCMessage).GetObjById(xMsgID)
		Continue:'$Isobject(obj)		
        
		Set (CSMsgType,MTitle,CSMessage,CSIsRead,CSReadDate,CSReadTime,CSReadUserDr,CSReadUser)=""
		Set CSMsgType = obj.CSMsgType
		Set (MUserName,MLocName)=""
		Set:$Isobject(obj.CSMsgUserDr) MUserName = obj.CSMsgUserDr.BTDesc
		Set:$Isobject(obj.CSMsgLocDr) MLocName = obj.CSMsgLocDr.BTDesc
		Set SendDate= obj.CSMsgDate	
		Set:SendDate'="" SendDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SendDate)
		Set SendTime= obj.CSMsgTime
		//多语言处理
		Set MLocName=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",MLocName,"User.CTLoc")
		Set MUserName=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",MUserName,"User.SSUser")
		Set MTitle =MLocName_" "_MUserName_" "_SendDate_" "_$zt(SendTime,1)
		
		Set CSIsRead =obj.CSIsRead
		//如果是未读去同步消息状态	
		if CSIsRead = 0 {
			Set MsgDtls = +obj.CSMsgDtlID
			if MsgDtls>0{
				Set obj = ##class(DHCHAI.IRS.CCMessageSrv).MsgStatusFromHIS(obj)
				Continue:'$Isobject(obj)
				Set CSIsRead =obj.CSIsRead
			}
		}
		Set CSMessage = obj.CSMessage 
		//同步临床在平台的回复消息
		Set DetailDr = obj.CSMsgDtlID
		If (DetailDr)  {
			Set Flg =##class(DHCHAI.IRS.CCMessageSrv).SyncReplyMessage(aPaadm,DetailDr)
		}
		Set CSReadDate = obj.CSReadDate
		Set:CSReadDate'="" CSReadDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CSReadDate)
		Set CSReadTime = obj.CSReadTime
		Set:CSReadTime'="" CSReadTime = $zt(CSReadTime,1)
		Set Data=$lb(xMsgID,CSMsgType,MTitle,CSMessage,CSIsRead,CSReadDate,CSReadTime)
		//阅读信息
		Set:$Isobject(obj.CSReadUserDr) CSReadUserDr = obj.CSReadUserDr.%Id()
		Set:$Isobject(obj.CSReadUserDr) CSReadUser = obj.CSReadUserDr.BTDesc
		Set Data=Data_$lb(CSReadUserDr,CSReadUser)
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	K arrMessage
	Quit $$$OK
}

ClassMethod QryMsgByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMsgByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMsgByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMsgByPaadmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2020-07-22
/// Description:  同步临床回复消息
/// Table：       DHCHAI.IR.CCMessage
/// Input：       各属性列表 ^分隔
/// 1 ID 
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.CCMessageSrv).SyncReplyMessage()
ClassMethod SyncReplyMessage(aEpisodeID As %String, aMsgDtlID As %String) As %String
{
	New (aEpisodeID,aMsgDtlID)
	Set return=""
	Quit:(aEpisodeID="")||(aMsgDtlID="") return
	
	
	Set objMsgDtl=##class(websys.DHCMessageDetails).%OpenId(aMsgDtlID)
	Quit:'$Isobject(objMsgDtl) return
	Quit:'$Isobject(objMsgDtl.DHCDetailsContentDr) return
	Set ContentDr = objMsgDtl.DHCDetailsContentDr.%Id()
	Set MsgLocDr =$lg(^websys.DHCMessageContentD(ContentDr),12)
	Set xReplyID=""
	For {
		Set xReplyID=$O(^websys.DHCMessageReplyContentI("ContentDrIndex",ContentDr,xReplyID),-1)
		Quit:xReplyID=""
		Set ReplyInfo = ^websys.DHCMessageReplyContentD(xReplyID)
	
		Set ReplyContnet = $lg(ReplyInfo,3)
		Set ReplyUserID = $lg(ReplyInfo,4)
		Set ReplyDate = $lg(ReplyInfo,5)
		Set ReplyTime = $lg(ReplyInfo,6)
		Set MsgUserDr = ##class(DHCHAI.BT.SysUser).GetObjByXCode("HIS01",ReplyUserID)
		Set IsRead = 0 
		Set xMessageID = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aEpisodeID,ReplyDate,ReplyTime,0))
		If (xMessageID) {  
			Set objMsg = ##class(DHCHAI.IR.CCMessage).GetObjById(xMessageID)
			Continue:'$Isobject(objMsg)
			Set IsRead = objMsg.CSIsRead
		}
		Continue:(xMessageID'="")&&(IsRead=1)  //过滤院感科已阅读的临床平台消息
		Set InputStr=xMessageID_"^"_aEpisodeID_"^2^"_ReplyDate_"^"_ReplyTime_"^"_MsgUserDr_"^"_MsgLocDr_"^"_ReplyContnet_"^"_0
		Set return =##class(DHCHAI.IR.CCMessage).Update(InputStr,"^")
	}
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-12-16
/// Description:  根据临床处理消息更新信息状态
/// Table：       DHCHAI.IR.CCMessage
/// Input：       各属性列表 ^分隔
/// 1 ID 
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.CCMessageSrv).MsgStatusFromHIS()
ClassMethod MsgStatusFromHIS(aObjMsg As %String) As DHCHAI.IR.CCMessage
{
	New (aObjMsg)
	Set return=""
	
	Set xMsgDtlID=aObjMsg.CSMsgDtlID
	Set objMsgDtl=##class(websys.DHCMessageDetails).%OpenId(xMsgDtlID)
	Quit:'$Isobject(objMsgDtl) ""
	Quit:'$Isobject(objMsgDtl.DHCDetailsContentDr) ""
	Set DetailsContentDr = objMsgDtl.DHCDetailsContentDr.%Id()
	
	Set CSIsRead =0,ReadDate="",ReadTime="",ReadUser=""
	//发送给科室的，一条阅读、处理即为阅读
	Set xToUserID=""
	For {
		Set xToUserID=$O(^websys.DHCMessageDetailsI("ContentUser",DetailsContentDr,xToUserID)) 
		Quit:(xToUserID="")
		Quit:CSIsRead=1
		
		Set xDetailsID=""
		For {
			Set xDetailsID=$O(^websys.DHCMessageDetailsI("ContentUser",DetailsContentDr,xToUserID,xDetailsID)) 
			Quit:(xDetailsID="")
			
			Set ReadFlag=$lg(^websys.DHCMessageDetailsD(xDetailsID),6)   //消息是否阅读过
			Set ExecFlag=$lg(^websys.DHCMessageDetailsD(xDetailsID),10)  //消息是否处理过 , 处理过则一定读过
	        Continue:ReadFlag="N"
	        Set CSIsRead = 1
	        Set ReadDate = $lg(^websys.DHCMessageDetailsD(xDetailsID),4)
	        Set ReadTime = $lg(^websys.DHCMessageDetailsD(xDetailsID),5)
	        Set ReadUser = $lg(^websys.DHCMessageDetailsD(xDetailsID),7)
		}
	}

	Set aObjMsg.CSIsRead = CSIsRead
	If (CSIsRead=1) {
		//是阅读则更新阅读信息
		Set aObjMsg.CSReadDate =ReadDate
		Set aObjMsg.CSReadTime =ReadTime
		Set aObjMsg.CSReadUserDr =##class(DHCHAI.BT.SysUser).GetObjByXCode("HIS01",ReadUser)
	}	
	Set sc=aObjMsg.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=aObjMsg
	}
	Do aObjMsg.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-06-24
/// Description:  阅读对方消息
/// Table：       DHCHAI.IR.CCMessage
/// w ##class(DHCHAI.IRS.CCMessageSrv).ReadMessage("91","8","1")
ClassMethod ReadMessage(aEpisodeID As %String, aUserID As %String, aTypeCode As %String) As %String
{
	New (aEpisodeID,aUserID,aTypeCode)
	Set return=0
	Quit:(aEpisodeID="")||(aTypeCode="")||(aTypeCode="") return
	
	Set Count = 0 
	Set xDate =""
 	For {
	 	Set xDate = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aEpisodeID,xDate))
		Quit:xDate=""
		Set xTime = ""
		For {
			Set xTime = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aEpisodeID,xDate,xTime))
			Quit:xTime=""
		 	Set xID = ""
			For {
				Set xID = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aEpisodeID,xDate,xTime,xID))
				Quit:xID=""
				
				Set obj = ##class(DHCHAI.IR.CCMessage).GetObjById(xID)
				Continue:'$Isobject(obj)
				Continue:obj.CSIsRead=1
				Set MsgType = obj.CSMsgType	
				Continue:MsgType=aTypeCode   //只阅读对方消息
				
				Set obj.CSIsRead   = 1
				Set obj.CSReadDate = +$h
				Set obj.CSReadTime = $p($h,",",2)
				Set obj.CSReadUserDr = ##class(DHCHAI.BT.SysUser).GetObjById(aUserID)
				
				Set sc=obj.%Save()
				If $system.Status.IsError(sc) {        //检查Save是否成功
			   		Do $system.OBJ.DisplayError(sc) 
			   		Set return=-1
				}Else{
					Set Count=Count+1
					Set return=Count
				}
				Do obj.%Close()
			}
		}
	}
	Quit return
}

/// Creator：     pyllian
/// CreatDate：   2020-03-04
/// Description:  查询未读消息病例记录
/// Table：       
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCMessageSrv","QryUnReadMsg","","2019-01-01","2020-02-28")
Query QryUnReadMsg(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,CurrBed:%String,VisitStatus:%String,LocDesc:%String,DischDate:%String,DischTime:%String,LocUnRead:%String,AdminUnRead:%String,IsNeedAtt:%String,SuspendCode:%String,NeedRepCnt:%String")
{
}

ClassMethod QryUnReadMsgExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set:aDateFrom'="" aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set:aDateTo'="" aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)	
	Set:aDateFrom="" aDateFrom=+$h-31
	Set:aDateTo="" aDateTo=+$h
	Quit:(aDateFrom="")||(aDateTo="") $$$OK 
	
    Set xEpisodeID = ""
	For {
		Set xEpisodeID = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",xEpisodeID))
		Quit:xEpisodeID=""
		
		Set LocUnRead=0,AdminUnRead=0 
  	    For xMsgDate=aDateFrom:1:aDateTo {
		 	Continue:'$d(^DHCHAI.IR.CCMessageI("IndexPaadmDate",xEpisodeID,xMsgDate))
			Set xMsgTime = ""
			For {
				Set xMsgTime = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",xEpisodeID,xMsgDate,xMsgTime))
				Quit:xMsgTime=""
				
			 	Set xMsgID = ""
				For {
					Set xMsgID = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",xEpisodeID,xMsgDate,xMsgTime,xMsgID))
					Quit:xMsgID=""
				
					Set obj = ##class(DHCHAI.IR.CCMessage).GetObjById(xMsgID)
					Continue:'$Isobject(obj)
					Continue:'$IsObject(obj.CSEpisodeDr)
				    Continue:obj.CSIsRead=1
				    
				    Set EpisodeID = obj.CSEpisodeDr.%Id()
					Set MsgType = obj.CSMsgType  //1院感、2临床
					If MsgType=1 {    //院感科发送的消息，科室未阅读
						Set LocUnRead=1
						Continue:LocUnRead=1
					}
					If MsgType=2 {     //科室发送的消息，院感未阅读
						Set AdminUnRead=1
						Continue:AdminUnRead=1
					}
				}
			}
		}
		Continue:(LocUnRead=0)&&(AdminUnRead=0)
		Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$IsObject(objEpisode)
		Set EpisodeIDx=objEpisode.PAEpisodeIDx
		Set SCode = $p(EpisodeIDx,"||",1)
		Set VisitStatus=objEpisode.PAVisitStatus
		Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
		If VisitStatusInfo'="" {
			Set VisitStatus=$p(VisitStatusInfo,"^",2)
		}
		Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
		If VisitStatusInfo'="" {
			Set VisitStatus=$p(VisitStatusInfo,"^",3)
		} Else {
			Set VisitStatus=$s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="P":"预住院",VisitStatus="C":"退院",VisitStatus="U":"作废",1:"其他")
		}
		
		Continue:'$IsObject(objEpisode.PAAdmLocDr)
		Continue:'$IsObject(objEpisode.PAAdmWardDr)
		Set objAdmLoc=objEpisode.PAAdmLocDr
		Set LocID=objAdmLoc.%Id()
		Set LocDesc=objAdmLoc.BTDesc
		Set LocDesc2=objAdmLoc.BTDesc2
		Set:LocDesc2'="" LocDesc=LocDesc2
		
	    Continue:'$IsObject(objAdmLoc.BTHospDr)
		Set HospID=objAdmLoc.BTHospDr.%Id()
		Set HospDesc=objAdmLoc.BTHospDr.BTDesc
		Set HospDesc2=objAdmLoc.BTHospDr.BTDesc2
		Set:HospDesc2'="" HospDesc=HospDesc2
		Continue:(aHospIDs'="")&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))  //医院过滤
		
		Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(xEpisodeID)
		Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)	//需关注标记
		Set IsSusInf=+$p(ScreenAttInfo,"^",2)   //疑似标记
		Set IsSuspend=+$p(ScreenAttInfo,"^",3)  //处置标记
		Set SuspendCode=IsSuspend
		Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已确诊",SuspendCode=2:"已排除",SuspendCode=3:"已上报",1:"错误")
	   
		Set PapmiNo=objEpisode.PAPapmiNo     //登记号
		Set MrNo=objEpisode.PAMrNo           //病案号
		Set PatName=objEpisode.PAPatName     //姓名
		Set Sex=objEpisode.PASex             //性别
		Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
		Set Age=objEpisode.PAAge             //年龄
		Set AdmDate=objEpisode.PAAdmDate     //就诊日期
		Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
		Set AdmTime=objEpisode.PAAdmTime     //就诊时间
		Set:AdmTime'="" AdmTime=$zt(AdmTime)
		Set DischDate=objEpisode.PADischDate //出院日期
		Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
		Set DischTime=objEpisode.PADischTime //出院时间
		Set:DischTime'="" DischTime=$zt(DischTime)
        Set (CurrBedDr,CurrBed)=""           //床位
		If $IsObject(objEpisode.PAAdmBedDr){
			Set CurrBedDr=objEpisode.PAAdmBedDr.%Id()
			Set CurrBed=objEpisode.PAAdmBedDr.BTDesc
			Set:CurrBed'["床" CurrBed=CurrBed_"床"
		}
		
		//获取患者需上报数量
		Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(xEpisodeID)
		Set ConfCnt = $p(ConfRepCnt,"^",1)
		Set RepCnt = $p(ConfRepCnt,"^",2)
		Set NeedRepCnt=ConfCnt-RepCnt
		Set:NeedRepCnt<0 NeedRepCnt=0

		Set Data=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmDate,AdmTime,CurrBed,VisitStatus,LocDesc,DischDate,DischTime,LocUnRead,AdminUnRead,IsNeedAtt,SuspendCode,NeedRepCnt)
					
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryUnReadMsgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUnReadMsgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUnReadMsgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUnReadMsgExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获得31日内未读消息病例数
/// w ##class(DHCHAI.IRS.CCMessageSrv).GetUnReadMsgCnt(6)
ClassMethod GetUnReadMsgCnt(aLocID As %String) As %String
{
	New (aLocID)
	
	Set return=0
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTHospDr) return
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) return
	Set HospID=objLoc.BTHospDr.%Id() 	
    Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
    
	Set Count=0
    Set xEpisodeID = ""
	For {
		Set xEpisodeID = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",xEpisodeID))
		Quit:xEpisodeID=""
		
		Set LocUnRead=0,AdminUnRead=0 		
  	    For xMsgDate=(+$h-31):1:(+$h) {
			Continue:'$d(^DHCHAI.IR.CCMessageI("IndexPaadmDate",xEpisodeID,xMsgDate))
			Set xMsgTime = ""
			For {
				Set xMsgTime = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",xEpisodeID,xMsgDate,xMsgTime))
				Quit:xMsgTime=""
				
			 	Set xMsgID = ""
				For {
					Set xMsgID = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",xEpisodeID,xMsgDate,xMsgTime,xMsgID))
					Quit:xMsgID=""
				
					Set obj = ##class(DHCHAI.IR.CCMessage).GetObjById(xMsgID)
					Continue:'$Isobject(obj)
					Continue:'$IsObject(obj.CSEpisodeDr)
				    Continue:obj.CSIsRead=1
				    
				    Set EpisodeID = obj.CSEpisodeDr.%Id()
					Set MsgType = obj.CSMsgType  //1院感、2临床
					If MsgType=1 {    //院感科发送的消息，科室未阅读
						Set LocUnRead=1
						Continue:LocUnRead=1
					}
					If MsgType=2 {     //科室发送的消息，院感未阅读
						Set AdminUnRead=1
						Continue:AdminUnRead=1
					}
				}
			}
		}
		Continue:(LocUnRead=0)&&(AdminUnRead=0)	
	
		Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$IsObject(objEpisode)
		Continue:'$IsObject(objEpisode.PAAdmLocDr)
		Continue:'$IsObject(objEpisode.PAAdmWardDr)
		Set objAdmLoc=objEpisode.PAAdmLocDr
	    Continue:'$IsObject(objAdmLoc.BTHospDr)
	    Continue:'$IsObject(objAdmLoc.BTHospDr.BTGroupDr)
		Set HospID=objAdmLoc.BTHospDr.%Id()
		Set tHospGrpID=objAdmLoc.BTHospDr.BTGroupDr.%Id()
		Continue:HospGrpID'=tHospGrpID
	
		Set Count=Count+1	
	}
	
   Set return = Count
   Quit return
}

}
