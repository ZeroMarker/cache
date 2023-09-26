/// 名称:     web.DHCAntCVSend
/// 描述:     危急值平台对外发送信息类
/// 编写者：  hw
/// 编写日期: 2016-5-11
Class web.DHCAntCVSend Extends %RegisteredObject
{

/// Creator：      hw
/// CreatDate：    2016-5-11
/// Description:： 根据危急值报告ID等信息对外发送危急值消息
/// Table：        
/// Input：        危急值报告ID,就诊表ID,操作用户,医嘱子表ID
/// Output：       
/// Return：        
/// Others：      d ##class(web.DHCAntCVSend).SendAntCVInfo("1||696||1",1,1,"988||4")
ClassMethod SendAntCVInfo(reportID As %String, Adm As %String, AUser As %String, OEOrdId As %String)
{
	//发送消息给平台
	s Portalret=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000020",reportID,"1",Adm)
  	//发送的消息内容^消息动作代码^发送消息的用户Id^病人就诊Id^医嘱Id^接收消息的用户Id^其它信息
  	//d ##class(websys.DHCMessageInterface).Send(Context, ActionTypeCode, FromUserRowId, EpisodeId , OrdItemId , ToUserRowId , OtherInfoJson )	
	s RepId=$p(reportID,"||",2)_"||"_$p(reportID,"||",3)
	s ReportType=$p(reportID,"||",1)
	;s Link="criticalvalue.trans.csp?ReportId="_RepId_"&RepType="_ReportType
	;s lk="{""link"":"""_Link_""",""dialogWidth"":""800"",""dialogHeight"":""460""}"
	s AdmLocId=$p(^PAADM(Adm),"^",4)
	s OrdRecLocId=$p(^OEORD(+OEOrdId,"I",+$p(OEOrdId,"||",2),3),"^",6) //医嘱接受科室
	s Link="ReportId="_RepId_"&RepType="_ReportType
	s lk="{""linkParam"":"""_Link_""",""dialogWidth"":""800"",""dialogHeight"":""460"",""BizObjId"":"""_reportID_"""}"
	//s ret=##class(websys.DHCMessageInterface).Send("","1000",AUser,Adm,OEOrdId,,lk,"","",OrdRecLocId)
	s ret=..SendHISMsgByCfg(reportID)  //按配置表来发
	
	s ret=..InsertEnsStatusLog(reportID,"AP,RP")  //危急值产生时往ENS_StatusLog 插入开医嘱和报告节点数据
	
	q
}

ClassMethod SendCVReceive(reportID, contact, contactTel, contactResult, contactResultDesc, note, usercode)
{
	s repType=$p(reportID,"||",1),repLabno=$p(reportID,"||",2),repOrder=$p(reportID,"||",3)
	s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
	s Adm=$p(repInfo,"\",7)
	set AdmType=$p(^PAADM(Adm),"^",2)
	s AdmTypeDet=AdmType
	if AdmTypeDet="E"{
		if ##class(web.DHCADMVisitStat).GetStayStatus(Adm)>0 set AdmTypeDet="EI"
		else  s AdmTypeDet="EO"
	}
		
		
	if ##class(web.DHCAntCVOptions).GetBaseOpt("InvMTSTimePoint")="Rec" { //接收时调用
		d ..SendMTS(reportID,usercode,"^"_contact_"^"_contactTel_"^"_contactResultDesc_"^"_note)
	}
	
	if ##class(web.DHCAntCVOptions).GetBaseOpt("ExecNurMsgOnReceive")=1 { // 接收时处理“非医生”消息
		d ..SendHisMsg(reportID,usercode,"Rec")
	}
	
	if ##class(web.DHCAntCVOptions).GetBaseOpt("ConfirmMgsOnReceive"_AdmTypeDet)=1 { //解锁时解锁消息
		s msgRet=##class(websys.DHCMessageInterface).Confirm("","1000","","",reportID,"")
	}
	

	
	s ret=..InsertEnsStatusLog(reportID,"Rec") //危急值接收时往ENS_StatusLog 插入接收节点数据
}

ClassMethod SendCVExec(reportID, contact, contactTel, contactResult, contactResultDesc, note, usercode)
{
	s repType=$p(reportID,"||",1),repLabno=$p(reportID,"||",2),repOrder=$p(reportID,"||",3)
	s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
	s Adm=$p(repInfo,"\",7)
	s Portalret=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000020",reportID,"2",Adm)
	
	s ReceiveMode=##class(web.DHCAntCVOptions).GetBaseOpt("ReceiveMode"),InvMTSTimePoint=##class(web.DHCAntCVOptions).GetBaseOpt("InvMTSTimePoint")
	if (ReceiveMode'>0)||(InvMTSTimePoint'="Rec") { //不需要接收模式 或者不是接收时调用医技系统时
		d ..SendMTS(reportID,usercode,"^"_contact_"^"_contactTel_"^"_contactResultDesc_"^"_note)
	}
	d ..SendHisMsg(reportID,usercode,"E")
	
	s ret=..InsertEnsStatusLog(reportID,"E") ////危急值接收时往ENS_StatusLog 插入处理节点数据
}

ClassMethod SendCVForwardDoc(reportID, usercode, fwLocId, fwUserId, fwUserId2 = "")
{
	if fwUserId2>0 s fwUserId=fwUserId_$s(fwUserId="":"",1:"^")_fwUserId2   //将转发用户1 转发用户2拼起来
	d ..SendHisMsg(reportID,usercode,"FwD", fwLocId, fwUserId)
}

ClassMethod SendCVCancel(reportID, usercode, forceFlag = "")
{
	d ..SendHisMsg(reportID,usercode,"D")
}

ClassMethod SendHisMsg(reportID, usercode, opType, fwLocId, fwUserId)
{
	
	s repType=$p(reportID,"||",1),repLabno=$p(reportID,"||",2),repOrder=$p(reportID,"||",3)
	s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	s Adm=$p(repInfo,"\",7)
	s OEOrdItemId=$p(repInfo,"\",14)
	
	if (opType="Rec") {
		if ##class(web.DHCAntCVOptions).GetBaseOpt("ExecNurMsgOnReceive")=1 { //接收时处理非医生消息
			s ObjectId="ReportId="_repLabno_"||"_repOrder_"&RepType="_repType
			s MesgRet=##class(websys.DHCMessageInterface).Exec("","1000",Adm,OEOrdItemId,ObjectId,UserId,"","","!DOCTOR") //!DOCTOR 处理非医生的消息，需要消息平台支持
		}
		
	}elseif (opType="E")||(opType="FwD") { //处理或转发
		s ObjectId="ReportId="_repLabno_"||"_repOrder_"&RepType="_repType
		//处理原始消息
		s MesgRet=##class(websys.DHCMessageInterface).Exec("","1000",Adm,OEOrdItemId,ObjectId,UserId,"","")
		///处理重发
		s AlreadySendTimes=+$p(repInfo,"\",18)  //已发送次数
		for times=2:1:AlreadySendTimes{
			s MesgRet=##class(websys.DHCMessageInterface).Exec("","1045",Adm,OEOrdItemId,reportID_"||"_times,UserId,"","")
		}
		//处理之前转发的
		s MesgRet=##class(websys.DHCMessageInterface).Exec("","1173",Adm,OEOrdItemId,reportID,UserId,"","")
		
	}elseif (opType="D"){ //危急值撤销 直接调用消息的强制撤销接口就行，究竟能不能撤销在危急值业务上进行判定
		s ObjectId="ReportId="_repLabno_"||"_repOrder_"&RepType="_repType
		//处理原始消息
		s MesgRet=##class(websys.DHCMessageInterface).CancelForce("","1000",Adm,OEOrdItemId,ObjectId,UserId,"","") //
		///处理重发
		s AlreadySendTimes=+$p(repInfo,"\",18)  //已发送次数
		for times=2:1:AlreadySendTimes{
			s MesgRet=##class(websys.DHCMessageInterface).CancelForce("","1045",Adm,OEOrdItemId,reportID_"||"_times,UserId,"","")
		}
		//处理之前转发的
		s MesgRet=##class(websys.DHCMessageInterface).CancelForce("","1173",Adm,OEOrdItemId,reportID,UserId,"","")
		
	}
	if opType="FwD" { //转发
		s ToUserRowId="",ToLocRowId=""
		if (fwUserId>0){
			s ToUserRowId=fwUserId
		}else{
			s ToLocRowId=fwLocId_"|"_"ToDoctor"
		}
		s Link="ReportId="_repLabno_"||"_repOrder_"&FWDoc=1&RepType="_repType
		s BizObjId=reportID
		s lk="{""linkParam"":"""_Link_""",""dialogWidth"":""1000"",""dialogHeight"":""600"",""BizObjId"":"""_BizObjId_"""}"
		s context="<br>危急值转发"_"<br>"_$g(^DHCAntCVReport(repType,repLabno,repOrder,"Result"))
		s MesgRet=##class(websys.DHCMessageInterface).Send(context,1173,UserId,Adm,OEOrdItemId,ToUserRowId,lk,ToLocRowId)

	}
}

/// 回传给医技系统
ClassMethod SendMTS(reportID, AUser, TransStr)
{
	q 0 // 从8.5开始 统一走平台
	s LisId=$p(^DHCAntCVReport($p(reportID,"||",1),$p(reportID,"||",2),$p(reportID,"||",3)),"\",16)
	s RepId=LisId_"||"_$p(reportID,"||",3)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AUser),""))
	s UserName=$p(^SSU("SSUSR",UserId),"^",2)
	s ExamNo=$replace($p(reportID,"||",2),"--","||")
	s ReportType=$p(reportID,"||",1)
	
	i ReportType=1 {
		s LisRet=##class(DHCLIS.DHCCommon).SaveTransPanicNotice(RepId,AUser,TransStr,"F")
		q LisRet
	}
	
	if ",3,4,5,6,"[(","_ReportType_",") {  //1:检验,2病理,3心电,4超声,5内镜,6放射
		//检查号^处理人工号（人事ID）^处理人姓名^联系电话^意见措施^联系人姓名^联系结果 ？
		s RisInput=ExamNo_"^"_AUser_"^"_UserName
		s $p(RisInput,"^",4)=$p(TransStr,"^",3) //联系电话
		s $p(RisInput,"^",5)=$p(TransStr,"^",5) //意见措施
		s $p(RisInput,"^",6)=$p(TransStr,"^",2) //联系人姓名
		s $p(RisInput,"^",7)=$p(TransStr,"^",4) //联系结果

		s RisRet="-100"
		if ReportType=3 { //3心电
			s RisRet=..InvokeEkg(RisInput)
		}else { //,4超声,5内镜,6放射
			s RisRet=..InvokeRis(RisInput)
		}
		q RisRet
	}
	q "-1^no interface"
}

/// Creator：      hw
/// CreatDate：    2016-5-11
/// Description:： 根据危急值报告ID等信息对外发送危急值处理情况
/// Table：        
/// Input：        危急值报告ID,操作用户,操作信息,操作状态
/// Output：       
/// Return：        
/// Others：      d ##class(web.DHCAntCVSend).SendAntCVTrans("1||696||1",1,"^123^123^已通知","F")
ClassMethod SendAntCVTrans(reportID As %String, AUser As %String, TransStr As %String, Status As %String)
{
	
	s Adm=$p(^DHCAntCVReport($p(reportID,"||",1),$p(reportID,"||",2),$p(reportID,"||",3)),"\",7)
	s LisId=$p(^DHCAntCVReport($p(reportID,"||",1),$p(reportID,"||",2),$p(reportID,"||",3)),"\",16)
	s RepId=LisId_"||"_$p(reportID,"||",3)
	s ReportType=$p(reportID,"||",1)
	
	
	s OEOrdItemId=$p(^DHCAntCVReport($p(reportID,"||",1),$p(reportID,"||",2),$p(reportID,"||",3)),"\",14)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AUser),""))
	s UserName=$p(^SSU("SSUSR",UserId),"^",2)
	s ExamNo=$replace($p(reportID,"||",2),"--","||")
	
	//发送消息给平台
	i Status="F" s Portalret=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000020",reportID,"2",Adm)
	///检验危机值结果处理回传  liuzf  //在没有检验相关服务 这里会卡
	i ReportType=1,Status="F" s LisRet=##class(DHCLIS.DHCCommon).SaveTransPanicNotice(RepId,AUser,TransStr,Status)
	
	if ",3,4,5,6,"[(","_ReportType_","),Status="F" {  //1:检验,2病理,3心电,4超声,5内镜,6放射
		//检查号^处理人工号（人事ID）^处理人姓名^联系电话^意见措施^联系人姓名^联系结果 ？
		s RisInput=ExamNo_"^"_AUser_"^"_UserName
		s $p(RisInput,"^",4)=$p(TransStr,"^",3) //联系电话
		s $p(RisInput,"^",5)=$p(TransStr,"^",5) //意见措施
		s $p(RisInput,"^",6)=$p(TransStr,"^",2) //联系人姓名
		s $p(RisInput,"^",7)=$p(TransStr,"^",4) //联系结果

		s RisRet="-100"
		if ReportType=3 { //3心电
			s RisRet=..InvokeEkg(RisInput)
		}else { //,4超声,5内镜,6放射
			s RisRet=..InvokeRis(RisInput)
		}
	}
	
	///发送给消息平台
	/// 执行所有消息##class(websys.DHCMessageInterface).Exec("159","1000",13,"9||45","ObjectId=xxxx","111","56662","22111")

	s ObjectId="ReportId="_$p(reportID,"||",2)_"||"_$p(reportID,"||",3)_"&RepType="_ReportType
	
	i Status="F"{
		s MesgRet=##class(websys.DHCMessageInterface).Exec("","1000",Adm,OEOrdItemId,ObjectId,UserId,"","")
		///处理重发
		s AlreadySendTimes=+$p(^DHCAntCVReport($p(reportID,"||",1),$p(reportID,"||",2),$p(reportID,"||",3)),"\",18)  //已发送次数
		for times=2:1:AlreadySendTimes{
			s MesgRet=##class(websys.DHCMessageInterface).Exec("","1045",Adm,OEOrdItemId,reportID_"||"_times,UserId,"","")
		}
	}
	q
}

ClassMethod InvokeEkg(input)
{
	Set CurNS = $namespace
	s $zt="InvokeEkgErr"
	s ret="-100^EkgService not exists"
	if ##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCEkgService||updateEmrRecord") s ret=##class(web.DHCEkgService).updateEmrRecord(input)
	q ret
InvokeEkgErr
	Set $namespace=CurNS
	q "-100^"_$ze
}

ClassMethod InvokeRis(input)
{
	Set CurNS = $namespace
	s $zt="InvokeRisErr"
	s ret="-100^RisService not exists"
	if ##class(%Dictionary.MethodDefinition).%ExistsId("RISService.InvokeRISService||ClinicDealUrgency") s ret=##class(RISService.InvokeRISService).ClinicDealUrgency(input)
	q ret
InvokeRisErr
	Set $namespace=CurNS
	q "-100^"_$ze
}

/// 根据配置发送HIS消息
ClassMethod SendHISMsgByCfg(reportID)
{
	s ReportType=$p(reportID,"||",1)
	s ReportLabNo=$p(reportID,"||",2)
	s ReportOrder=$p(reportID,"||",3)
	s RepInfo=^DHCAntCVReport(ReportType,ReportLabNo,ReportOrder)
	s Adm=$p(RepInfo,"\",7)
	s OEOrdItemId=$p(RepInfo,"\",14)
	
	s AdmType=$p(^PAADM(Adm),"^",2)
	s AdmLoc=$p(^PAADM(Adm),"^",4)
	
	s AdmHosp=$p(^CTLOC(AdmLoc),"^",22) //就诊科室对应医院
	if AdmHosp="" s AdmHosp=$o(^CT("HOSP",0)) //如果医院为空 则取第一个医院
	
	q:AdmHosp="" 1 //医院为空 不发送
	
	s repResult=$g(^DHCAntCVReport(ReportType,ReportLabNo,ReportOrder,"Result"))
	
	s AlreadySendTimes=+$p(RepInfo,"\",18)  //已发送次数
	s CreateDate=$p(RepInfo,"\",1)
	s CreateTime=$p(RepInfo,"\",2)
	s CreateUser=$p(RepInfo,"\",3)
	s NowDateTime=$h,NowDate=+NowDateTime,NowTime=+$p(NowDateTime,",",2)
	s SpaceSeconds=(NowDate-CreateDate)*86400+(NowTime-CreateTime)
	s NowDayOfWeek=$zd(NowDate,10) //0-6 日一...六
	//根据配置 读出ReceiveCode
	s FinalReceiveCode=""
	for loc=AdmLoc,0{
		s cfgid=""
		for {
			//s cfgid=$o(^User.DHCAntCVMsgCfgI("AdmTypeLocTimes",AdmType,loc,AlreadySendTimes+1,cfgid))
			s cfgid=$o(^User.DHCAntCVMsgCfgI("HTLT",AdmHosp,AdmType,loc,AlreadySendTimes+1,cfgid)) //自己存院区版本
			q:cfgid=""
			//s cfgid=$o(^User.DHCAntCVMsgCfgI("AdmTypeLocTimes",AdmType,loc,AlreadySendTimes+1,cfgid))
			//q:cfgid=""
			//continue:'##class(BSP.GRPHOSP.SRV.Interface).GetDataShowFlag("DHC_AntCVMsgCfg",cfgid,AdmHosp) //院区
			
			s g=^User.DHCAntCVMsgCfgD(cfgid)
			//b ;cfgid
			s CVTypes=$lg(g,6)	
			continue:CVTypes'[ReportType  //过滤危急值类型
			s DaysOfWeek=$lg(g,12)
			continue:(DaysOfWeek'="")&&(DaysOfWeek'[NowDayOfWeek) //星期过滤 2020-06-01
			s SendInterval=$lg(g,5)
			continue:(AlreadySendTimes'=0)&&(SendInterval*60-SpaceSeconds>=0)  //不是第一次发送，没到此次重发时间
			s StartTime=$lg(g,7)
			continue:(NowTime<StartTime)&&(StartTime'="")  //在开始时间之前
			s EndTime=$lg(g,8)
			continue:(NowTime>EndTime)&&(EndTime'="")  //在结束时间之后
			s ReceiveCode=$lg(g,9)
			
			s SendMode=$lg(g,13)
			if SendMode="" s SendMode="I"
			s TargetRole=$lg(g,14) //目标角色 2020-07-27
			
			s ResultContains=$lg(g,15)  //结果需包含 2022-03-08
			continue:(ResultContains'="")&&(repResult'[ResultContains)
			
			if ReceiveCode'="" { //2019-2-13 改为就诊类型 科室（或默认） 第n次 下所有满足的配置 接收人的并集
				//if FinalReceiveCode'="" s FinalReceiveCode=FinalReceiveCode_"^"_ReceiveCode
				//else  s FinalReceiveCode=ReceiveCode
				
				if $d(FinalReceiveCode(SendMode)) s FinalReceiveCode(SendMode)=FinalReceiveCode(SendMode)_"^"_ReceiveCode_"-"_TargetRole
				else  s FinalReceiveCode(SendMode)=ReceiveCode_"-"_TargetRole
			}
		}
		q:$d(FinalReceiveCode)>9  //q:FinalReceiveCode'=""
	}
	if $d(FinalReceiveCode)>9{  // FinalReceiveCode'=""{

		s Link="ReportId="_ReportLabNo_"||"_ReportOrder_"&RepType="_ReportType
		s lk="{""linkParam"":"""_Link_""",""dialogWidth"":""900"",""dialogHeight"":""590"",""BizObjId"":"""_reportID_"""}"
		s OrdRecLocId=$p(^OEORD(+OEOrdItemId,"I",+$p(OEOrdItemId,"||",2),3),"^",6) //医嘱接受科室
		s ReportLoc=$p(RepInfo,"\",21) if ReportLoc'="" s OrdRecLocId=ReportLoc  //如过存了危急值报告科室字段 则使用危急值报告科室作为消息发送科室 2020-06-14
		s repResult=$g(^DHCAntCVReport(ReportType,ReportLabNo,ReportOrder,"Result"))
		s MsgActionCode="1000",context="<br>"_repResult
		if AlreadySendTimes>0 {  //重发的消息内容、类型、OtherInfoJson不同
			set context="<br>危急值已经过了"_(SpaceSeconds\60)_"分钟还未处理"_context
			s Link="criticalvalue.trans.hisui.csp?ReportId="_ReportLabNo_"||"_ReportOrder_"&RepType="_ReportType_"&SendTime="_(AlreadySendTimes+1)
			s lk="{""link"":"""_Link_""",""dialogWidth"":""1000"",""dialogHeight"":""590"",""BizObjId"":"""_reportID_"||"_(AlreadySendTimes+1)_"""}"  //重发 业务id再拼上 ||次数
			s MsgActionCode="1045"
		}
		
		if ##class(web.DHCAntCVMsgCfg).IsV85Plus() {  //消息平台聚合多种发送方式
			s argReceiveCode=""
			s iMode=""
			for {
				s iMode=$o(FinalReceiveCode(iMode))
				q:iMode=""
				s argReceiveCode=argReceiveCode_"/"_iMode_":"_$tr(FinalReceiveCode(iMode),"^",",")
			}
			s contextObj=##class(BSP.SYS.COM.ProxyObject).%New()
			s contextObj.I=context
			s contextObj.S="BSP_CV_SMS_DOC" //危急值医生短信模板
			if AlreadySendTimes>0 s contextObj.S="BSP_CV_SMS_REPEAT"  //危急值医生短信重发模板
			s otherJsonObj=##class(BSP.SYS.COM.ProxyObject).%FromJSON(lk)
			s otherJsonObj.repResult=repResult
			s otherJsonObj.minuteUsed=(SpaceSeconds\60),otherJsonObj.sendNo=(AlreadySendTimes+1)
			s otherJsonObj.repDate=$zd(CreateDate,3),otherJsonObj.repTime=$zt(CreateTime),otherJsonObj.repUser=$p(^SSU("SSUSR",CreateUser),"^",2)
			s otherJson=otherJsonObj.%ToJSON()
			s ret=##class(BSP.MSG.SRV.Interface).Send(contextObj.%ToJSON(),MsgActionCode,CreateUser,Adm,OEOrdItemId,argReceiveCode,otherJson,"",OrdRecLocId,"")
			
		}else{ //没有 HIS消息单独调用  短信单独调用短信
			s FinalReceiveCode=$g(FinalReceiveCode("I")) //信息系统
			if FinalReceiveCode'="" {
				if ##class(%Dictionary.MethodDefinition).%ExistsId("BSP.MSG.SRV.Interface||Send"){ //如果有新版消息接口 走新版消息接口
					//新版接口 ReceiveCode参数 Type-Keys(k1^k2^k3)-Role,Type-Keys(k1^k2^k3)-Role 
					s argReceiveCode=$tr(FinalReceiveCode,"^",",") //FinalReceiveCode L-1^M-AdmDoctor^U-1 将^替换成,即可
					s ret=##class(BSP.MSG.SRV.Interface).Send(context,MsgActionCode,CreateUser,Adm,OEOrdItemId,argReceiveCode,lk,"",OrdRecLocId,"")
				}else{ //没有新版接口 还是自己取用户 兼容老项目
					s ToUserRowId=..GetUserIdsByReceiveCodes(FinalReceiveCode,Adm,OEOrdItemId)  //改成FinalReceiveCode 可以是用^分隔得
					if ToUserRowId>0 {
						//需登录科室问题
						i $d(^||Content("Loc")) Set ToLocId = ^||Content("Loc")_"|OnlyFlag" 
						e  s ToLocId=""
						s ret=##class(websys.DHCMessageInterface).Send(context,MsgActionCode,CreateUser,Adm,OEOrdItemId,ToUserRowId,lk,ToLocId,"",OrdRecLocId)
					}
					
				}
			}
			
			s SMSFinalReceiveCode=$g(FinalReceiveCode("S")) 
			if SMSFinalReceiveCode'=""{ //短信  单独调用
				
			} 
			
		}
		


		///发送完成后 次数加1   //只要取到了第二次的配置 无论根据配置是否取到人 都算作已发送把更新次数提出来 cryze 20200216
		s AlreadySendTimes=AlreadySendTimes+1
		&sql(
			update SQLUser.DHC_AntCVReport set DPRP_AlredySendTimes=:AlreadySendTimes where DPRP_RowID=:reportID 
		)
	}
	q 1
}

/// d ##class(web.DHCAntCVSend).RepeatTask()
ClassMethod RepeatTask()
{
	//重发任务调用方法
	//只查24小时内的未处理的
	set nowDate=+$h,nowTime=+$p($h,",",2)
	for date=nowDate,nowDate-1{
		set repType=""
		for {
			s repType=$o(^DHCAntCVReport(0,"DATE",date,repType))
			q:repType=""
			s repLabNo=""
			for {
				s repLabNo=$o(^DHCAntCVReport(0,"DATE",date,repType,repLabNo))
				q:repLabNo=""
				s repOrder=""
				for {
					s repOrder=$o(^DHCAntCVReport(0,"DATE",date,repType,repLabNo,repOrder))
					q:repOrder=""
					s RepInfo=^DHCAntCVReport(repType,repLabNo,repOrder)
					s CreateDate=$p(RepInfo,"\",1)
					s CreateTime=$p(RepInfo,"\",2)
					continue:(nowDate>CreateDate)&&(nowTime>CreateTime)   //昨天的 并且此时大于发送时间
					s Status=$p(RepInfo,"\",9)
					Continue:Status="F"   //已处理的
					s AlreadySendTimes=+$p(RepInfo,"\",18)
					Continue:AlreadySendTimes=0  //刚巧还没发送的
					b ;Repeat Before Send
					d ..SendHISMsgByCfg(repType_"||"_repLabNo_"||"_repOrder) //发送
				}
			}
		}
	}
}

ClassMethod GetUserIdsByReceiveCodes(ReceiveCodes, EpisodeId, OrdItemId)
{
	k ^||Content
	s ret=-100,targetLoc=""
	for i=1:1:$l(ReceiveCodes,"^"){
		s ReceiveCode=$p(ReceiveCodes,"^",i)
		continue:ReceiveCode=""
		s ToUserRowId=..GetUserIdsByReceiveCode(ReceiveCode, EpisodeId, OrdItemId)
		if ToUserRowId>0{
			if ret>0 s ret=ret_"^"_ToUserRowId
			else  s ret=ToUserRowId
			
			if $d(^||Content("Loc")){
				if targetLoc="" s targetLoc=^||Content("Loc")
				else  s targetLoc=targetLoc_"^"_^||Content("Loc")
			}
			
			if $d(^||Content("MedUnit")){
				if targetLoc="" s targetLoc=+^||Content("MedUnit")
				else  s targetLoc=targetLoc_"^"_+^||Content("MedUnit")
			}
		}
	}
	k ^||Content
	if targetLoc'="" { //如果中间有单个的下医嘱医生 又有病区护士 这时候只记录到了病区护士所在科室  没有病人就诊科室和下医嘱科室 强行加上
		s admLoc=$p(^PAADM(EpisodeId),"^",4)
		if (("^"_targetLoc_"^")'[("^"_admLoc_"^")) s targetLoc=targetLoc_"^"_admLoc
		
		s ordPar=+$p(OrdItemId,"||",1)
		s ordSub=+$p(OrdItemId,"||",2)
		s ordLoc = $p($g(^OEORD(ordPar,"I",ordSub,7)),"^",2)
		if (("^"_targetLoc_"^")'[("^"_ordLoc_"^")) s targetLoc=targetLoc_"^"_ordLoc
		
		s ^||Content("Loc")=targetLoc //最后再把值赋给^||Content("Loc")
	}
	q ret
}

ClassMethod GetUserIdsByReceiveCode(ReceiveCode, EpisodeId, OrdItemId)
{
	k ^||Content
	s ToUserRowId=-100
	s rectype=$p(ReceiveCode,"-",1)
	s recobj=$p(ReceiveCode,"-",2)
	if rectype="M"{  //消息接收对象  recobj为 消息接收对象代码
		s ToUserRowId=##class(websys.DHCMessageReceiveTypeMgr).GetToUserRowId(recobj,EpisodeId,OrdItemId)
	}elseif rectype="L" { //科室 recobj为科室id
		//s ToUserRowId=##class(websys.DHCMessageReceiveTypeMgr).SendToResourseUser("","","",EpisodeId,OrdItemId,"",recobj,"")
		//科室取有此科室登录权限的用户
		Set ^||Content("Loc")=recobj
		s ToUserRowId=..GetLocUsersByLogon(recobj)
		//s ToUserRowId=##class(websys.DHCMessageReceiveTypeMgr).SendToLocLogonUser(recobj)
	}elseif rectype="U"{  //用户 recobj为用户id
		s ToUserRowId=recobj  
	}
	q ToUserRowId
}

/// 获取有某科室登录权限的所有用户
ClassMethod GetLocUsersByLogon(LocId)
{
	
	Set UserId=0 For {
		Set UserId = $Order(^SSU("SSUSR",UserId))	
		Quit:UserId="" 
		;1 判断默认科室
		set DefaultLoc=$p(^SSU("SSUSR",UserId),"^",4)
		if DefaultLoc=LocId {
			s tempUserList(UserId)=1
			continue    ;此用户符合条件 跳出此用户的循环
		}
		;2判断其他登录科室
		Set ChildSub=0 For {
			Set ChildSub = $Order(^SSU("SSUSR",UserId,"OTHLL",ChildSub))	
			Quit:ChildSub="" 
			set othllInfo=$g(^SSU("SSUSR",UserId,"OTHLL",ChildSub))
			Set OtherLocDr=$p(othllInfo,"^",1)
			if OtherLocDr=LocId {
				Set stdate=$p(othllInfo,"^",4)
				Set edate=$p(othllInfo,"^",5)
				continue:(stdate'="")&&(stdate>+$h)   ;还未开始 
				continue:(edate'="")&&(edate<+$h)    ;已经结束 
				s tempUserList(UserId)=1
				q   ;跳出整个内层循环
			}
		}
	}
	set UserId="",UserIds=""
	for{
		s UserId=$o(tempUserList(UserId))
		q:UserId=""
		if UserIds="" set UserIds=UserId 
		else  set UserIds=UserIds_"^"_UserId
	}
	q UserIds
}

/// 获取某次发送之前的发送历史
ClassMethod GetSendHistory(reportID, SendTime)
{
	s ReportType=$p(reportID,"||",1)
	s ReportLabNo=$p(reportID,"||",2)
	s ReportOrder=$p(reportID,"||",3)
	s RepInfo=^DHCAntCVReport(ReportType,ReportLabNo,ReportOrder)
	s Adm=$p(RepInfo,"\",7)
	s OEOrdItemId=$p(RepInfo,"\",14)
	s AlreadySendTimes=+$p(RepInfo,"\",18)  //已发送次数
	//如果SendTime为空 取所有
	if SendTime=""{
		set SendTime=AlreadySendTimes+1
	}
	w "["
	for i=1:1:SendTime-1{
		if i=1 set ContentId=##class(websys.DHCMessageInterface).FindContentId("1000",Adm,OEOrdItemId,reportID)
		else  set ContentId=##class(websys.DHCMessageInterface).FindContentId("1045",Adm,OEOrdItemId,reportID_"||"_i)
		w "{""SendTime"":"""_i_""",""ContentId"":"""_ContentId_""",""rows"":"
		if ContentId>0{
			set total=0
			set rtn= ##class(ext.util.JsonObject).ClassQuery2JsonQ("websys.DHCMessageDetailsMgr","FindByContent","0","100",.total,ContentId,"","")
			w rtn_",""total"":"_total
			Set CreateDate=$lg(^websys.DHCMessageContentD(ContentId),5)  set CreateDate=##class(websys.Conversions).DateLogicalToHtml(CreateDate)
			Set CreateTime=$lg(^websys.DHCMessageContentD(ContentId),6)  set CreateTime=$zt(CreateTime)
			w ",""CreateDate"":"""_CreateDate_""",""CreateTime"":"""_CreateTime_""""
			
		}else{
			w "[],""total"":0"
		}
		w "}"
		if i<(SendTime-1) w ","
	}
	w "]"
	q ""
}

/// 插入平台 ENS_StatusLog表记录
ClassMethod InsertEnsStatusLog(reportID, op)
{
	s sourceSys="CV"  //系统来源
	
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) "-1^危急值ID"_reportID_"不正确"
	
	
	s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
	s ordItem=$p(repInfo,"\",14)
	s ordPar=+$p(ordItem,"||",1),ordSub=+$p(ordItem,"||",2)

	
	s arr=##class(BSP.SYS.COM.ProxyArray).%New()
	s len=$l(op,",")
	for i=1:1:len{
		s iop=$p(op,",",i)
		s iop=$zcvt(iop,"U")
		s status=$case(iop,"AP":"AP","REP":"CVRP","RP":"CVRP","REC":"CVREC","E":"CVHAD","EXEC":"CVHAD",:"")
		continue:status=""
		s (oprUserCode,oprUserName,oprLocCode,oprLocDesc,oprDT,notes)=""
		
		if (iop="AP") { //申请 开医嘱
			s ordDoc=$p($g(^OEORD(ordPar,"I",ordSub,1)),"^",11)
			if ordDoc>0 s oprUserCode=$p($g(^CTPCP(ordDoc,1)),"^",1),oprUserName=$p($g(^CTPCP(ordDoc,1)),"^",2)
			s ordLoc = $p($g(^OEORD(ordPar,"I",ordSub,7)),"^",2)
			if ordLoc>0 s oprLocCode=$P($g(^CTLOC(ordLoc)),"^",1),oprLocDesc=$P($g(^CTLOC(ordLoc)),"^",2)
			s ordDate=$p($g(^OEORD(ordPar,"I",ordSub,3)),"^",7)
			s ordTime=$p($g(^OEORD(ordPar,"I",ordSub,1)),"^",17)
			if ordDate>0,ordTime'="" s oprDT=$zd(ordDate,3)_" "_$zt(ordTime)
		}elseif (iop="RP")||(iop="REP") { //报告
			s repDate=$p(repInfo,"\",1),repTime=$p(repInfo,"\",2)
			if repDate>0,repTime'="" s oprDT=$zd(repDate,3)_" "_$zt(repTime)
			s repUser=$p(repInfo,"\",3)
			if repUser>0 s oprUserCode=$p($g(^SSU("SSUSR",repUser)),"^",1),oprUserName=$p($g(^SSU("SSUSR",repUser)),"^",2)
			
			s repLoc=$p(repInfo,"\",21)
			if repLoc'="" { //危急值报告表记录的报告科室
				if repLoc>0 s oprLocCode=$p($g(^CTLOC(repLoc)),"^",1),oprLocDesc=$p($g(^CTLOC(repLoc)),"^",2)
				else  s oprLocDesc=$p(repLoc,"^",2)
			}
			if oprLocDesc="" {
				s repLoc=$p($g(^OEORD(ordPar,"I",ordSub,3)),"^",6)  //医嘱接收科室
				if repLoc>0 s oprLocCode=$p($g(^CTLOC(repLoc)),"^",1),oprLocDesc=$p($g(^CTLOC(repLoc)),"^",2)
			}
			
		}elseif (iop="REC")||(iop="E")||(iop="EXEC") {  //接收与处理
			s opType=$case(iop,"REC":"Rec","E":"E","EXEC":"E",:iop)
			s trOrder=""
			for {
				s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder),-1)
				q:trOrder=""
				s trInfo=^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder)
				s trOpType=$p(trInfo,"\",16)
				if trOpType="",$p(trInfo,"\",8)="F" s trOpType="E"
				continue:trOpType'=opType
				
				s trDate=$p(trInfo,"\",1),trTime=$p(trInfo,"\",2)
				if trDate>0,trTime'="" s oprDT=$zd(trDate,3)_" "_$zt(trTime)
				s oprUserCode=$p(trInfo,"\",3),oprUserName=##class(web.DHCAntCVComm).GetUserNameByCode(oprUserCode)
				s trLoc=$p(trInfo,"\",11)
				if trLoc>0 s oprLocCode=$p($g(^CTLOC(trLoc)),"^",1),oprLocDesc=$p($g(^CTLOC(trLoc)),"^",2)
				q
			}
			
		}
		
		
		
		if (oprDT'="") {
			s item=##class(BSP.SYS.COM.ProxyObject).%New()
			s item.OEOrdItemID=reportID
			s item.Position=""
			s item.ExamID=""
			s item.Status=status
			s item.UserID=oprUserCode
			s item.UserName=oprUserName
			s item.UpDateTime=oprDT
			s item.SourceSystem=sourceSys
			s item.Notes=notes
			s item.OperateDeptCode=oprLocCode
			s item.OperateDept=oprLocDesc
			
			d arr.%Push(item)
		}
	}
	
	if arr.%Size()>0 {
		s stream=##class(%GlobalCharacterStream).%New()
		d arr.%ToJSON(stream)
		d stream.Rewind()
		s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",stream)
		s stream="",arr="",item=""
		q 1
	}else{
		q "-1^没有需要插入的操作数据"	
	}
}

}
