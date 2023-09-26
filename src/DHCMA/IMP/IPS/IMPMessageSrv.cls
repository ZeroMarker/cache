/// 名称: DHCMA.IMP.IPS.IMPMessageSrv
/// 描述: 重点患者筛查消息服务
/// 编写者：zhufei
/// 编写日期: 2020-09-25
Class DHCMA.IMP.IPS.IMPMessageSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangdc
/// CreatDate：   2020-08-26
/// Description:  更新消息记录信息
/// Table：       DHCMA.IMP.IP.IMPRecordMsg
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IPS.IMPMessageSrv).UpdateMsg("8^^1^^^9^334^您好,请上报院感情况。^0^^^9","")
ClassMethod UpdateMsg(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set ^TEMPZDC20201019=aInputStr
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		      		= $p(aInputStr,aSeparete,1)
	set ChildSub     			= $p(aInputStr,aSeparete,2)
	Set MsgType          		= $p(aInputStr,aSeparete,3)
	Set MsgDate   				= $p(aInputStr,aSeparete,4)
	Set MsgTime 				= $p(aInputStr,aSeparete,5)
	Set MsgUserID  				= $p(aInputStr,aSeparete,6)
	Set MsgLocID  				= $p(aInputStr,aSeparete,7)
	Set MsgMessage  			= $p(aInputStr,aSeparete,8)
	Set MsgIsRead  				= $p(aInputStr,aSeparete,9)
	Set MsgReadDate  			= $p(aInputStr,aSeparete,10)
	Set MsgReadTime  			= $p(aInputStr,aSeparete,11)
	Set MsgReadUserID  			= $p(aInputStr,aSeparete,12)
	Set MsgDtlID 				= $p(aInputStr,aSeparete,13)
	Set aHospID 				= $p(aInputStr,aSeparete,14)
	Quit:(MsgType="") return
	Quit:(Parref="") -1
	
	Set objParref=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(Parref)
	Quit:('$Isobject(objParref)) return
	
	Set:MsgDate'="" MsgDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(MsgDate)
	Set:MsgTime[":" MsgTime = $zth(MsgTime,1)
	Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(Parref)
	Quit:'$Isobject(objRecord) return
	Set EpisodeDr = objRecord.EpisodeID

	If ChildSub="" {
		Set obj=##class(DHCMA.IMP.IP.IMPRecordMsg).%New()
		Set:MsgDate="" MsgDate=+$h
		Set:MsgTime="" MsgTime=$p($h,",",2)
		set obj.Parref      = objParref
		Set obj.MsgType   	= MsgType
		Set obj.MsgDate  	= MsgDate
		Set obj.MsgTime 	= MsgTime
		Set obj.MsgUserID 	= MsgUserID
		Set obj.MsgLocID 	= MsgLocID
		Set obj.MsgMessage 	= MsgMessage
		//根据系统配置获取是否往HIS下同时发送消息
		Set MsgSendFlag=##class(DHCMA.Util.BT.Config).GetValueByCode("IMPMsgSendFlag",aHospID)
		If (MsgSendFlag="1")&&(MsgType=1) {//只考虑院感科向临床发送消息，临床消息加入推送会出现临床能看到一条自己发送的消息待处理
			//Set HisPaadm = $p(obj.CSEpisodeDr.PAEpisodeIDx,"||",2)
			Set otherInfoJson="{""linkParam"":""EpisodeDr="_EpisodeDr_"&Paadm="_EpisodeDr_"&MsgType=2""}"   //处理消息对应的链接
			Set MsgDtlID = ##class(DHCMA.Util.IO.FromHisSrv).SendMsg(MsgMessage,"1064",MsgUserID,EpisodeDr,"",otherInfoJson)			
		}
		Set obj.MsgDtlID = MsgDtlID  //HIS下消息明细ID
		b ;1
	}Else{
		Set obj=##class(DHCMA.IMP.IP.IMPRecordMsg).%OpenId(Parref_"||"_ChildSub)
	}
	
	Quit:'$IsObject(obj) return

	Set obj.MsgIsRead = MsgIsRead
	if (MsgIsRead) 
	{
		
		//是阅读则更新阅读信息
		Set obj.MsgReadDate 	=+$h
		Set obj.MsgReadTime 	=$p($h,",",2)
		Set obj.MsgReadUserID 	=MsgReadUserID
	}	
		b ;2
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-08-27
/// Description:  根据病人查询消息记录
/// Table：       
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPMessageSrv","QryMsgByPaadm","717",6,717,"")
Query QryMsgByPaadm(aPaadm As %String, aIMPCateDr As %String, aIMPOrdNo As %String, aIsRead As %String) As %Query(ROWSPEC = "ID:%String,CSMsgType:%String,MTitle:%String,CSMessage:%String,CSIsRead:%String,CSReadDate:%String,CSReadTime:%String,CSReadUserDr:%String,CSReadUser:%String")
{
}

ClassMethod QryMsgByPaadmExecute(ByRef qHandle As %Binary, aPaadm As %String, aIMPCateDr As %String, aIMPOrdNo As %String, aIsRead As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aPaadm="")||(aIMPCateDr="")||(aIMPOrdNo="") $$$OK
 	
 	Set xParRef =""
 	For {
	 	Set xParRef = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(aPaadm,"U"),aIMPCateDr," "_$zcvt(aIMPOrdNo,"U"),xParRef))
		Quit:xParRef=""
		Set xID = ""
		For {
			Set xID = $o(^MA.IMP.IPIMPRecordD(xParRef,"Msg",xID))
			Quit:xID=""
				
			Set obj = ##class(DHCMA.IMP.IP.IMPRecordMsg).GetObjById(xParRef_"||"_xID)
			Continue:'$Isobject(obj)
						
			Set (MsgType,MTitle,Message,IsRead,ReadDate,ReadTime,ReadUserDr,ReadUser)=""
			Set MsgType = obj.MsgType
			Set (MUserName,MLocName)=""
			//Set:$Isobject(obj.CSMsgUserDr) MUserName = obj.CSMsgUserDr.BTDesc
			//Set:$Isobject(obj.CSMsgLocDr) MLocName = obj.CSMsgLocDr.BTDesc
			Set SYSTEMID=$o(^DHCMA.Util.BT.SYSTEMI("IdxofCode"," "_$zcvt("HIS01","U"),0))
			if (SYSTEMID '="") && (obj.MsgUserID '=""){
				Set MsgUserDr = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(obj.MsgUserID_"!!"_SYSTEMID)
				Set:$Isobject(MsgUserDr) MUserName = MsgUserDr.BTDesc
				Set:MUserName'="" MUserName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",MUserName)
			}
			if (SYSTEMID '="") && (obj.MsgLocID '=""){
				Set MsgLocDr = ##class(DHCMA.Util.EP.Location).GetObjByOID(obj.MsgLocID_"!!"_SYSTEMID)
				Set:$Isobject(MsgLocDr) MLocName = MsgLocDr.BTDesc
				Set:MLocName'="" MLocName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",MLocName)
			}
				
			Set SendDate=obj.MsgDate
			Set:SendDate'="" SendDate = ##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SendDate)
			Set MTitle =MLocName_" "_MUserName_" "_SendDate_" "_$zt(obj.MsgTime,1)
				
			Set Message = obj.MsgMessage 
			Set IsRead =obj.MsgIsRead
			//如果是未读去同步消息状态	
			if IsRead = 0 {
				Set MsgDtls = +obj.MsgDtlID
				if MsgDtls>0{
					Set obj = ##class(DHCMA.IMP.IPS.IMPMessageSrv).MsgStatusFromHIS(obj)
					Set IsRead =obj.MsgIsRead
				}
			}
				
			Continue:(aIsRead'="")&&(aIsRead'=IsRead)
			//同步临床在平台的回复消息
			Set DetailDr = obj.MsgDtlID
			If (DetailDr)  {
				Set Flg =##class(DHCMA.IMP.IPS.IMPMessageSrv).SyncReplyMessage(aPaadm,aIMPCateDr,aIMPOrdNo,DetailDr)
				b ;
			}
				
			Set ReadDate = obj.MsgReadDate
			Set:ReadDate'="" ReadDate = ##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ReadDate)
			Set ReadTime = obj.MsgReadTime
			Set:ReadTime'="" ReadTime = $zt(ReadTime,1)
			Set Data=$lb(xParRef_"||"_xID,MsgType,MTitle,Message,IsRead,ReadDate,ReadTime)
			//阅读信息
			//Set:$Isobject(obj.CSReadUserDr) CSReadUserDr = obj.CSReadUserDr.%Id()
			//Set:$Isobject(obj.CSReadUserDr) CSReadUser = obj.CSReadUserDr.BTDesc
			Set:obj.MsgReadUserID'="" ReadUserDr = obj.MsgReadUserID
			if (ReadUserDr'=""){
				Set MsgUser = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(ReadUserDr_"!!"_SYSTEMID)
				Set:$Isobject(MsgUser) ReadUser = MsgUser.BTDesc
			}
			Set Data=Data_$lb(ReadUserDr,ReadUser)
				
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
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

/// Creator：     zhangdc
/// CreatDate：   2020-08-28
/// Description:  同步临床回复消息
/// Table：       DHCMA.IMP.IP.IMPRecordMsg
/// Input：       各属性列表 ^分隔
/// 1 ID 
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IPS.IMPMessageSrv).SyncReplyMessage(717,6,717,2377)
ClassMethod SyncReplyMessage(aEpisodeID As %String, aIMPCateDr As %String, aIMPOrdNo As %String, aMsgDtlID As %String) As %String
{
	New (aEpisodeID,aMsgDtlID,aIMPCateDr,aIMPOrdNo)
	Set return=""
	Quit:(aEpisodeID="")||(aMsgDtlID="")||(aIMPCateDr="")||(aIMPOrdNo="") return
	
	Set SYSTEMID=$o(^DHCMA.Util.BT.SYSTEMI("IdxofCode"," "_$zcvt("HIS01","U"),0))
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
		Set MsgUserDr = ReplyUserID
		Set IsRead = 0
		Set:MsgUserDr'="" MsgUserDrId=MsgUserDr
		//Set:$IsObject(MsgUserDr) MsgLocDr=MsgUserDr.BTLocDr.%Id()
		Set MsgUser = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(MsgUserDrId_"!!"_SYSTEMID)
		
		Set:$IsObject(MsgUser) MsgLocDr=MsgUser.BTLocID
		Set:MsgLocDr'="" MsgLocDr=$p(MsgLocDr,"!!",1)
		Set xMessageID = $o(^MA.IMP.IPIMPRecordI("Msg","IndexMsgDateTime",ReplyDate,ReplyTime,0))
		
		Set ParRef= $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(aEpisodeID,"U"),aIMPCateDr," "_$zcvt(aIMPOrdNo,"U"),0))
		b ;
		Quit:ParRef=""
		If (xMessageID){
			Set objMsg = ##class(DHCMA.IMP.IP.IMPRecordMsg).GetObjById(ParRef_"||"_xMessageID)
			Continue:'$Isobject(objMsg)
			Set IsRead = objMsg.MsgIsRead
		}
		Continue:(xMessageID'="")&&(IsRead=1)  //过滤院感科已阅读的临床平台消息
		Set InputStr=ParRef_"^"_xMessageID_"^2^"_ReplyDate_"^"_ReplyTime_"^"_MsgUserDrId_"^"_MsgLocDr_"^"_ReplyContnet_"^0^"_xReplyID_"^^"
		
		Set return =##class(DHCMA.IMP.IPS.IMPMessageSrv).UpdateMsg(InputStr,"^")
	}
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-08-28
/// Description:  阅读对方消息
/// Table：       DHCMA.IMP.IP.IMPRecordMsg
/// w ##class(DHCMA.IMP.IPS.IMPMessageSrv).ReadMessage("717","6","717","8","1")
ClassMethod ReadMessage(aEpisodeID As %String, aIMPCateDr As %String, aIMPOrdNo As %String, aUserID As %String, aTypeCode As %String) As %String
{
	New (aEpisodeID,aUserID,aTypeCode,aIMPCateDr,aIMPOrdNo)
	Set return=0
	Quit:(aEpisodeID="")||(aUserID="")||(aTypeCode="")||(aIMPCateDr="")||(aIMPOrdNo="") return
	
	Set Count = 0 
	Set xParRef =""
 	For {
	 	Set xParRef = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(aEpisodeID,"U"),aIMPCateDr," "_$zcvt(aIMPOrdNo,"U"),xParRef))
	 	b ;
		Quit:xParRef=""
		Set xID = ""
		For {
			Set xID = $o(^MA.IMP.IPIMPRecordD(xParRef,"Msg",xID))
			Quit:xID=""
				
			Set obj = ##class(DHCMA.IMP.IP.IMPRecordMsg).GetObjById(xParRef_"||"_xID)
			Continue:'$Isobject(obj)
			Continue:obj.MsgIsRead=1
			Set MsgType = obj.MsgType	
			Continue:MsgType=aTypeCode   //只阅读对方消息
				
			Set obj.MsgIsRead  		= 1
			Set obj.MsgReadDate 	= +$h
			Set obj.MsgReadTime 	= $p($h,",",2)
			Set obj.MsgReadUserID 	= aUserID
				
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
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-08-31
/// Description:  根据临床处理消息更新信息状态
/// Table：       DHCMA.IMP.IP.IMPRecordMsg
/// Input：       各属性列表 ^分隔
/// 1 ID 
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IPS.IMPMessageSrv).MsgStatusFromHIS()
ClassMethod MsgStatusFromHIS(aObjMsg As %String) As DHCMA.IMP.IP.IMPRecordMsg
{
	New (aObjMsg)
	Set return=""
	
	Set xMsgDtlID=aObjMsg.MsgDtlID
	Set objMsgDtl=##class(websys.DHCMessageDetails).%OpenId(xMsgDtlID)
	Quit:'$Isobject(objMsgDtl) ""
	Quit:'$Isobject(objMsgDtl.DHCDetailsContentDr) ""
	Set DetailsContentDr = objMsgDtl.DHCDetailsContentDr.%Id()
	
	Set IsRead =0,ReadDate="",ReadTime="",ReadUser=""
	//发送给科室的，一条阅读、处理即为阅读
	Set xToUserID=""
	For {
		Set xToUserID=$O(^websys.DHCMessageDetailsI("ContentUser",DetailsContentDr,xToUserID)) 
		Quit:(xToUserID="")
		Quit:IsRead=1
		
		Set xDetailsID=""
		For {
			Set xDetailsID=$O(^websys.DHCMessageDetailsI("ContentUser",DetailsContentDr,xToUserID,xDetailsID)) 
			Quit:(xDetailsID="")
			
			Set ReadFlag=$lg(^websys.DHCMessageDetailsD(xDetailsID),6)   //消息是否阅读过
			Set ExecFlag=$lg(^websys.DHCMessageDetailsD(xDetailsID),10)  //消息是否处理过 , 处理过则一定读过
	        Continue:ReadFlag="N"
	        Set IsRead = 1
	        Set ReadDate = $lg(^websys.DHCMessageDetailsD(xDetailsID),4)
	        Set ReadTime = $lg(^websys.DHCMessageDetailsD(xDetailsID),5)	
	        Set ReadUser = $lg(^websys.DHCMessageDetailsD(xDetailsID),7)
		}
	}

	Set aObjMsg.MsgIsRead = IsRead
	If (IsRead=1) {
		//是阅读则更新阅读信息
		Set aObjMsg.MsgReadDate =ReadDate
		Set aObjMsg.MsgReadTime =ReadTime
		Set aObjMsg.MsgReadUserID =ReadUser
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

}
