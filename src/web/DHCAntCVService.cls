/// 名称:     web.DHCAntCVService
/// 描述:     危急值平台对外服务
/// 编写者：  hw
/// 编写日期: 2016-1-26
Class web.DHCAntCVService Extends %RegisteredObject
{

ClassMethod GetExecFlag(EpisodeId, OrdItemId, OtherInfoJson)
{
	s RepType=+$p(OtherInfoJson,"=",3)
	s ReportId=$p(OtherInfoJson,"=",2)
	s ReportId=$p(ReportId,"&",1)
	s Status=$p(^DHCAntCVReport(RepType,$p(ReportId,"||",1),$p(ReportId,"||",2)),"\",9)
	i Status="F" d
	.s TransOrd=+$o(^DHCAntCVReport(RepType,$p(ReportId,"||",1),$p(ReportId,"||",2),"TR",""),-1)
	.s str=$g(^DHCAntCVReport(RepType,$p(ReportId,"||",1),$p(ReportId,"||",2),"TR",TransOrd))
	.s TDate=$p(str,"\",1)
	.s TTime=$p(str,"\",2)
	.s TUser=$p(str,"\",3)
	.s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(TUser,"U"),""))
	.s rtn="1^"_UserId_"^"_TDate_"^"_TTime
	e  s rtn="0^^^"
	q rtn
}

ClassMethod GetReportWarn(EpisodeId)
{
	q ..GetCVReportNum(EpisodeId,"C,Rec",1)
	s rtn=0
	q:EpisodeId="" rtn
	s DPRPType=""
	f  s DPRPType=$o(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType)) q:(DPRPType="")||(rtn=1)  d
	.s DPRPLabNo=""
	.f  s DPRPLabNo=$o(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType,DPRPLabNo)) q:(DPRPLabNo="")||(rtn=1)  d
	..s DPRPOrder=""
	..f  s DPRPOrder=$O(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType,DPRPLabNo,DPRPOrder)) q:(DPRPOrder="")||(rtn=1)  d
	...s Status=$p(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder),"\",9)
	...i Status'="F" s rtn=1
	q rtn
}

ClassMethod GetReportWarnNum(EpisodeId)
{
	q ..GetCVReportNum(EpisodeId,"C,Rec",0)
	s rtn=0
	q:EpisodeId="" rtn
	s DPRPType=""
	f  s DPRPType=$o(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType)) q:(DPRPType="")  d
	.s DPRPLabNo=""
	.f  s DPRPLabNo=$o(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType,DPRPLabNo)) q:(DPRPLabNo="")  d
	..s DPRPOrder=""
	..f  s DPRPOrder=$O(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType,DPRPLabNo,DPRPOrder)) q:(DPRPOrder="")  d
	...s Status=$p(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder),"\",9)
	...i Status'="F" s rtn=rtn+1
	
	q rtn
}

/// add TestItems 2020-07-17
ClassMethod SaveCVResult(ReportType As %String, ExamNo As %String, Adm As %String, OEOrdId As %String, ReportInfo As %String, Result As %String, LisRowid As %String = "", OrderInfo As %String = "", TestItems = "") As %String
{
	s ret=##Class(web.DHCAntCVResult).Save(ReportType,ExamNo,Adm,OEOrdId,ReportInfo,Result,LisRowid,OrderInfo,TestItems)
	q ret
}

/// 只传ExamNo 如果两种类型的ExamNo一致 就不准确
/// 只传 OEOrdId 可能同医嘱对应不同ExamNo
ClassMethod IsCVReport(ExamNo As %String = "", OEOrdId As %String = "")
{
	s ExamNo=$replace(ExamNo,"||","--")  //ExamNo在保存时是将||转成了--
	s flag=0,rowid=""
	if OEOrdId>0,$d(^OEORD(+OEOrdId)) {
		s EpisodeId=$p(^OEORD(+OEOrdId),"^",1)
		q:EpisodeId'>0 flag
		s DPRPType=0
		for {
			s DPRPType=$o(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType))
			q:(DPRPType="")||(flag=1)
			s DPRPLabNo=""
			for {
				s DPRPLabNo=$o(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType,DPRPLabNo)) 
				q:(DPRPLabNo="")||(flag=1)
				continue:(ExamNo'="")&&(DPRPLabNo'=ExamNo)
				s DPRPOrder=""
				for{
					s DPRPOrder=$o(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType,DPRPLabNo,DPRPOrder),-1) 
					q:(DPRPOrder="")||(flag=1)
					
					continue:$p(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder),"\",9)="D"
					
					s DPRPOEOrdId=$p(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder),"\",14)
					//if DPRPOEOrdId=OEOrdId s flag=1,rowid=DPRPType_"||"_DPRPLabNo_"||"_DPRPOrder
					//多医嘱ID 用,分割 包含判断
					if (","_DPRPOEOrdId_",")[(","_OEOrdId_",") s flag=1,rowid=DPRPType_"||"_DPRPLabNo_"||"_DPRPOrder
				}
			}
		}
	}elseif ExamNo'=""{  //只有ExamNo
		s DPRPType=0
		for {
			s DPRPType=$o(^DHCAntCVReport(DPRPType))
			q:(DPRPType="")||(flag=1)
			s DPRPOrder=""
			for {
				s DPRPOrder=$o(^DHCAntCVReport(DPRPType,ExamNo,DPRPOrder),-1)
				q:DPRPOrder=""
				continue:DPRPOrder'>0
				q:flag=1
				
				continue:$p(^DHCAntCVReport(DPRPType,ExamNo,DPRPOrder),"\",9)="D"
				set flag=1,rowid=DPRPType_"||"_ExamNo_"||"_DPRPOrder
			}
			
		}
	}
	
	if flag=1 q flag_"^"_rowid
	else  q flag
}

/// 根据就诊号获取危急值
/// Adm 就诊ID Status:状态F已处理 C未处理 空全部   DateFrom:开始日期 DateTo:结束日期 UseType:用途 ReportType危急值报告类型(1:检验,2病理,3心电,4超声,5内镜,6放射  多个以,分割)
/// 返回值 $lb($lb(1危急值报告ID,2检查(检验)号,3医嘱ID,4状态,5报告类型,6报告科室,7报告日期,8报告时间,9报告结果,10处理人,11处理意见,12医嘱名称,13处理日期,14处理时间,15护士处理完成状态,16接收人,17接收备注,18接收日期,19接收时间),$lb())
/// s ret= ##class(web.DHCAntCVService).GetCVByAdm(138583)
/// zw ret   
/// w $ll(ret)  
ClassMethod GetCVByAdm(Adm = "", Status = "", DateFrom = "", DateTo = "", UseType = "", ReportType = "")
{
	if DateFrom'="" s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
	if DateTo'="" s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
	s ret=""
	q:Adm="" ret
	
	s AllowNurExec=0
	if ##class(web.DHCAntCVOptions).GetBaseOpt("AllowNurExec")="1" s AllowNurExec=1  //是否允许护士处理
	if UseType="NURSE-TODO" { //护士待办
		if AllowNurExec=1 s Status="C,Rec"  //护士可处理 C,Rec 护士都可以继续操作
		else  s Status="C"  //只有C状态
	}elseif UseType="NURSE-DONE" {  //护士已完成
		if AllowNurExec=1 s Status="F" //护士可处理 已处理状态才算护士已完成
		else  s Status="Rec,F"  //护士不可处理情况下  接收和处理状态的危急值都算护士已完成 
	}
	
	if Status'="" s Status=","_Status_","
	
	if ReportType'="" s ReportType=","_ReportType_","
	
	
	s repType=0
	for {
		s repType=$o(^DHCAntCVReport(0,"ADM",Adm,repType))
		q:repType=""
		continue:(ReportType'="")&&(ReportType'[(","_repType_","))
		s repTypeDesc=##class(web.DHCAntCVReportNameQuery).GetPanicName(repType)
		s repLabno=""
		for {
			s repLabno=$o(^DHCAntCVReport(0,"ADM",Adm,repType,repLabno))
			q:repLabno=""
			s repOrder=""
			for {
				s repOrder=	$o(^DHCAntCVReport(0,"ADM",Adm,repType,repLabno,repOrder))
				q:repOrder=""
				s repInfo=$g(^DHCAntCVReport(repType,repLabno,repOrder))
				s repStatus=$p(repInfo,"\",9)
				continue:(repStatus="D")&&(Status'[",D,")
				continue:(Status'="")&&(Status'[(","_repStatus_","))
				
				s reportID=repType_"||"_repLabno_"||"_repOrder
				s examno=$replace(repLabno,"--","||") //检查检验号
				s repDate=$p(repInfo,"\",1)
				continue:(DateFrom>0)&&(repDate<DateFrom)
				continue:(DateTo>0)&&(repDate>DateTo)
				s repTime=$p(repInfo,"\",2)
				s repResult=$g(^DHCAntCVReport(repType,repLabno,repOrder,"Result"))
				s ordItem=$p(repInfo,"\",14)
				s ordItemDesc=##class(web.DHCAntCVReportSearch).GetOrdItems(ordItem,",","+")
				s repLoc=$p(^OEORD(+ordItem,"I",+$p(ordItem,"||",2),3),"^",6) 
				if repLoc>0 s repLoc=$p(^CTLOC(repLoc),"^",2)
			
				s trUser="",trAdvice="",trDate="",trTime=""
				s recUser="",recAdvice="",recDate="",recTime=""
				//if repStatus="F"{
				s trOrder=""
				for {
					s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder),-1)
					q:trOrder=""
					continue:trOrder'>0
					s trInfo=^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder)
					s opType=$p(trInfo,"\",16) if opType="",$p(trInfo,"\",8)="F" s opType="E"
					
					if opType="E"{
						continue:trDate'=""
						s trDate=$p(trInfo,"\",1),trTime=$p(trInfo,"\",2)
						s trDate=##class(websys.Conversions).DateLogicalToHtml(trDate)
						s trTime=$zt(trTime)
						s trAdvice=$p(trInfo,"\",9)	//处理意见
						s usercode=$p(trInfo,"\",3),username="",userid=""
						s:usercode'="" userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
						if userid>0 s username=$p(^SSU("SSUSR",userid),"^",2)
						s trUser=username
					}elseif opType="Rec" { //接收
						continue:recDate'=""
						s recDate=$p(trInfo,"\",1),recTime=$p(trInfo,"\",2)
						s recDate=##class(websys.Conversions).DateLogicalToHtml(recDate)
						s recTime=$zt(recTime)
						s recAdvice=$p(trInfo,"\",9)	//接收备注
						s usercode=$p(trInfo,"\",3),username="",userid=""
						s:usercode'="" userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
						if userid>0 s username=$p(^SSU("SSUSR",userid),"^",2)
						s recUser=username
					}
					q:(trDate'="")&&(recDate'="")
				}
				//}
				s repDate=##class(websys.Conversions).DateLogicalToHtml(repDate)
				s repTime=$zt(repTime)
				
				s nurseDoneStatus=0
				if AllowNurExec{
					if repStatus="F" s nurseDoneStatus=1  //护士可处理 已处理状态才算护士已完成
				}else{
					if (repStatus="Rec")||(repStatus="F") s nurseDoneStatus=1  //护士不可处理情况下  接收和处理状态的危急值都算护士已完成 
				}
				
				s $li(ret,$i(ind))=$lb(reportID,examno,ordItem,repStatus,repTypeDesc,repLoc,repDate,repTime,repResult,trUser,trAdvice,ordItemDesc,trDate,trTime,nurseDoneStatus,recUser,recAdvice,recDate,recTime)
				
			}
		}
	}
	q ret
}

/// 获取危急值数量
/// EpisodeId 就诊
/// Status 状态 C未处理 F已处理 空全部
/// FlagOnly 是否仅查标志，即查到一条就退出循环
/// AppUserId 开单用户过滤
/// w ##class(web.DHCAntCVService).GetCVReportNum(1)
ClassMethod GetCVReportNum(EpisodeId, Status = "", FlagOnly = 0, AppUserId = "")
{
	s AppUserId=$g(AppUserId)
	if Status'="" s Status=","_Status_"," 
	s ret=0
	s repType=0
	for {
		s repType=$o(^DHCAntCVReport(0,"ADM",EpisodeId,repType))
		q:repType=""
		q:(FlagOnly=1)&&(ret>0)
		s repLabno=""
		for {
			s repLabno=	$o(^DHCAntCVReport(0,"ADM",EpisodeId,repType,repLabno))
			q:repLabno=""
			q:(FlagOnly=1)&&(ret>0)
			s repOrder=""
			for {
				s repOrder=$o(^DHCAntCVReport(0,"ADM",EpisodeId,repType,repLabno,repOrder))
				q:repOrder=""
				q:(FlagOnly=1)&&(ret>0)
				s repStatus=$p(^DHCAntCVReport(repType,repLabno,repOrder),"\",9)
				continue:(repStatus="D")&&(Status'[",D,")
				continue:(Status'="")&&(Status'[(","_repStatus_",")) //用包含判断 2020-07-17
				
				if AppUserId>0 { //开单用户过滤
					s AppDoc=$p($g(^SSU("SSUSR",AppUserId)),"^",14)
					s ordItem=$p(^DHCAntCVReport(repType,repLabno,repOrder),"\",14)
					s ordPar=+ordItem,ordSub=+$p(ordItem,"||",2)
					s ordDoc=$p($g(^OEORD(ordPar,"I",ordSub,1)),"^",11)
					continue:ordDoc'=AppDoc
				}
				s ret=ret+1
			}
		}
	}
	q ret
}

/// s obj=##class(web.DHCAntCVService).GetOneCVInfo("2||49--2||2")
/// 获取危急值信息
ClassMethod GetOneCVInfo(reportID)
{
	s repType=$p(reportID,"||",1),repLabno=$p(reportID,"||",2),repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||'$d(^DHCAntCVReport(repType,repLabno,repOrder)) ""
	s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
	s obj=##class(BSP.SYS.COM.ProxyObject).%New()
	s obj.reportID=reportID
	s obj.examNo=$replace(repLabno,"--","||")
	s obj.repResult=$g(^DHCAntCVReport(repType,repLabno,repOrder,"Result"))
	s obj.repType=repType
	s obj.repTypeDesc=##class(web.DHCAntCVReportNameQuery).GetPanicName(repType)
	s ordItemId=$p(repInfo,"\",14)
	s obj.ordItemId=ordItemId
	s obj.ordItemDesc=##class(web.DHCAntCVReportSearch).GetOrdItems(ordItemId,",","+")
	s oneOrdItemId=$p(ordItemId,",",1)
	s oneOrdObj=##class(web.DHCAntCVComm).GetOneOrdInfoObj(oneOrdItemId)
	
	s obj.repLoc=oneOrdObj.ordRecLocDesc //报告科室 取医嘱接收科室
	s obj.ordAddDT=oneOrdObj.ordAddDT //开立日期时间
	s obj.ordDocName=oneOrdObj.ordDocName //开医嘱人
	s obj.ordLocDesc=oneOrdObj.ordLocDesc //开医嘱科室
	
	s adm=$p(repInfo,"\",7),patientID=$p($g(^PAADM(+adm)),"^",1)
	if adm>0,patientID>0 {
		s admObj=##class(web.DHCAntCVComm).GetAdmInfoObj(adm)
		s patObj=##class(web.DHCAntCVComm).GetPatInfoObj(patientID,adm)
		s obj.admDT=admObj.admDate_" "_admObj.admTime
		s obj.admLocDesc=admObj.admLocDesc
		s obj.admDocName=admObj.admDocName
		s obj.adm=admObj.adm
		s obj.patPhone=patObj.patPhone
		s obj.patientID=patObj.patientID
		s admObj="",patObj=""
	}
	
	s repDate=$p(repInfo,"\",1),repTime=$p(repInfo,"\",2),repUserId=$p(repInfo,"\",3),repUserName=""
	s obj.repDate=repDate,obj.repTime=repTime,obj.repDT=##class(websys.Conversions).DateLogicalToHtml(repDate)_" "_$zt(repTime)
	s:repUserId>0 repUserName=$p($g(^SSU("SSUSR",repUserId)),"^",2)
	s obj.repUserName=repUserName
	
	s (trUserId,trUserName,trDate,trTime,trAdvice,trDT)=""
	s (recUserId,recUserName,recDate,recTime,recAdvice,recDT)=""
	s trOrder=""
	for {
		s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder),-1)
		q:trOrder=""
		
		q:(trDate'="")&&(recDate'="") //取到一次记录不再取
		s trInfo=^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder)
		s trOpType=$p(trInfo,"\",16)
		if trOpType="",$p(trInfo,"\",8)="F" s trOpType="E"
		if trOpType="E" {
			continue:trDate'=""
			s trDate=$p(trInfo,"\",1),trTime=$p(trInfo,"\",2),trUserCode=$p(trInfo,"\",3),trUserId=""
			s:trUserCode'="" trUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(trUserCode),""))
			if trUserId>0 s trUserName=$p(^SSU("SSUSR",trUserId),"^",2)
			s trAdvice=$p(trInfo,"\",9)	//处理意见
			s trAdvice=$replace(trAdvice,"$c(92)","\"),trAdvice=$replace(trAdvice,"$c(94)","^")
			s trDT=##class(websys.Conversions).DateLogicalToHtml(trDate)_" "_$zt(trTime)
		}elseif trOpType="Rec" {
			continue:recDate'=""
			s recDate=$p(trInfo,"\",1),recTime=$p(trInfo,"\",2),recUserCode=$p(trInfo,"\",3),recUserId=""
			s:recUserCode'="" recUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(recUserCode),""))
			if recUserId>0 s recUserName=$p(^SSU("SSUSR",recUserId),"^",2)
			s recAdvice=$p(trInfo,"\",9)	//处理意见
			s recAdvice=$replace(recAdvice,"$c(92)","\"),recAdvice=$replace(recAdvice,"$c(94)","^")
			s recDT=##class(websys.Conversions).DateLogicalToHtml(recDate)_" "_$zt(recTime)
				
		}

	}
	s obj.trUserName=trUserName,obj.trDate=trDate,obj.trTime=trTime,obj.trDT=trDT,obj.trAdvice=trAdvice
	s obj.recUserName=recUserName,obj.recDate=recDate,obj.recTime=recTime,obj.recDT=recDT,obj.recAdvice=recAdvice

	s trOrdItemList=##class(BSP.SYS.COM.ProxyArray).%New()
	
	s lkOrder=0
	for{
		s lkOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder))
		q:lkOrder=""
		s lkID=reportID_"||"_lkOrder
		s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
		s lkType=$p(lkInfo,"\",1)
		continue:lkType'=1
		s ordItemId=$p(lkInfo,"\",2)
		s ordObj=##class(web.DHCAntCVComm).GetOneOrdInfoObj(ordItemId)
		
		d trOrdItemList.%Push(ordObj)
	}
	s obj.trOrdItemList=trOrdItemList
	q obj
}

ClassMethod GetOneCVStatusInfo(reportID) As BSP.SYS.COM.ProxyArray
{
	q ##class(web.DHCAntCVReportSearch).GetCVProcessObj(reportID)
}

/// 获取某就诊 是否有未处理的危急值且开单医生是AppUserId
ClassMethod GetDocCVReportWarn(EpisodeId, AppUserId = "")
{
	q ..GetCVReportNum(EpisodeId,"C,Rec",1,AppUserId)
}

/// 获取一次就诊所有的危急值ID
ClassMethod GetCVIDByAdm(Adm = "")
{
	s list=..GetCVByAdm(Adm,"","",""),ret=""
	if list'="",$lv(list) {
		s len=$ll(list)
		for i=1:1:len {
			s item=$lg(list,i)
			s itemid=$lg(item,1)
			s $p(ret,"^",i)=itemid
		}	
	}
	q ret
}

/// w ##class(web.DHCAntCVService).GetCVExecTimesByAdm(1253396)
ClassMethod GetCVExecTimesByAdm(Adm = "")
{
	s list=..GetCVByAdm(Adm,"F","",""),ret=""
	if list'="",$lv(list) {
		s len=$ll(list)
		for i=1:1:len {
			s item=$lg(list,i)
			s itemid=$lg(item,1)
			s itemDate=$lg(item,13)
			s itemTime=$lg(item,14)
			if itemDate'="" {
				s itemDate=$zd( ##class(websys.Conversions).DateHtmlToLogical(itemDate),3)
				s ret=ret_$s(ret="":"",1:"\")_itemDate_" "_itemTime	
			}
		}	
	}
	q ret
}

/// 为医技系统提供危急值撤销接口
/// Input：        报告类型:ReportType(1:检验,2病理,3心电,4超声,5内镜,6放射),
///                检查号:ExamNo
///                就诊号:Adm
///                医嘱ID:OEOrdId
///                检验传过来的id：LisRowid  不止检验，也可以其它医技系统，一般为医技系统的危急值ID
/// 			   撤销用户工号：CancelUserCode
/// 			   撤销说明备注：CancelNote
/// ReportType,ExamNo,OEOrdId,LisRowid 都对应危急值保存时的参数
/// 只会根据条件查到最后一条危急值，然后尝试撤销它
/// 返回值 
/// 失败 -1^错误信息
/// 成功 1
ClassMethod SaveCVCancel(ReportType, ExamNo, OEOrdId, LisRowid = "", CancelUserCode = "", CancelNote = "")
{
	s $zt="SaveCVCancelErr"
	if CancelUserCode="" q "-1^撤销用户为空"
	if '$d(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CancelUserCode))) q "-1^错误的工号"_CancelUserCode
	
	if ReportType="" q "-1^报告类型为空"
	if ExamNo="" q "-1^检查检验号为空"
	s repLabno=$replace(ExamNo,"||","--")
	s repOrder="",reportID="",repInfo=""
	for {
		s repOrder=$o(^DHCAntCVReport(ReportType,repLabno,repOrder),-1)
		q:repOrder=""
		
		s repInfo=^DHCAntCVReport(ReportType,repLabno,repOrder)
		
		continue:$p(repInfo,"\",14)'=OEOrdId
		
		continue:$p(repInfo,"\",16)'=LisRowid
	
		s reportID=ReportType_"||"_repLabno_"||"_repOrder
		q
	}
	if reportID="" q "-1^没找到满足条件的危急值"
	s ret=##class(web.DHCAntCVReportTrans).SaveCancel(reportID,CancelUserCode,CancelNote)
	q ret
SaveCVCancelErr
	q "-1^"_$ze
}

/// 第三方用户确认收到处理回传消息
ClassMethod SaveTPSConfirmExec(ReportType, ExamNo, OEOrdId, LisRowid As %String = "", UserCode = "")
{
	if UserCode="" q "-1^操作用户工号为空"
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	if UserId'>0 q "-1^操作用户工号"_UserCode_"不正确"
	
	
	s repLabno=$replace(ExamNo,"||","--")
	s repOrder="",reportID=""
	for {
		s repOrder=$o(^DHCAntCVReport(ReportType,repLabno,repOrder),-1)
		q:repOrder=""
		
		s repInfo=^DHCAntCVReport(ReportType,repLabno,repOrder)
		
		continue:$p(repInfo,"\",14)'=OEOrdId
		
		continue:$p(repInfo,"\",16)'=LisRowid
		
		continue:$p(repInfo,"\",9)'="F"
		
		s reportID=ReportType_"||"_repLabno_"||"_repOrder
		q
	}
	if reportID="" q "-1^没找到满足条件的已处理的危急值"
	
	s ret=##class(web.DHCAntCVReportLink).SaveTPSConfirmExec(reportID,UserId)
	if ret>0 q 1
	else  q ret
}

/// 为医技系统提供获取危急值处理意见措施接口 
/// 当医技系统需要在自己危急值列表展示意见措施时,不建议通过webservice或http等接口形式获取数据，毕竟几百几千条要是这样调用，很容易出问题
/// Input：        报告类型:ReportType(1:检验,2病理,3心电,4超声,5内镜,6放射),
///                检查号:ExamNo
///                就诊号:Adm
///                医嘱ID:OEOrdId
///                检验传过来的id：LisRowid  不止检验，也可以其它医技系统，一般为医技系统的危急值ID
/// ReportType,ExamNo,OEOrdId,LisRowid 都对应危急值保存时的参数
/// 只会根据条件查到最后一条危急值，然后返回它最后一条处理记录的意见措施字段
/// 返回值 
/// 失败 -1^错误信息
/// 成功 意见措施
ClassMethod GetTransAdvice(ReportType, ExamNo, OEOrdId, LisRowid = "")
{
	s $zt="GetTransAdviceErr"
	if ReportType="" q "-1^报告类型为空"
	if ExamNo="" q "-1^检查检验号为空"
	s repLabno=$replace(ExamNo,"||","--")
	s repOrder="",reportID="",repInfo=""
	for {
		s repOrder=$o(^DHCAntCVReport(ReportType,repLabno,repOrder),-1)
		q:repOrder=""
		
		s repInfo=^DHCAntCVReport(ReportType,repLabno,repOrder)
		
		continue:$p(repInfo,"\",14)'=OEOrdId
		
		continue:$p(repInfo,"\",16)'=LisRowid
	
		s reportID=ReportType_"||"_repLabno_"||"_repOrder
		q
	}
	if reportID="" q "-1^没找到满足条件的危急值"
	if $p(repInfo,"\",9)'="F" q "-1^危急值（"_reportID_"）还未处理"
	
	s trOrder="",trAdvice=""
	for {
		s trOrder=$o(^DHCAntCVReport(ReportType,repLabno,repOrder,"TR",trOrder),-1)
		q:trOrder=""
		s trInfo=^DHCAntCVReport(ReportType,repLabno,repOrder,"TR",trOrder)
		s trOpType=$p(trInfo,"\",16)
		if trOpType="",$p(trInfo,"\",8)="F" s trOpType="E"
		if trOpType="E" {
			s trAdvice=$p(trInfo,"\",9)
		}
	}
	q trAdvice
GetTransAdviceErr
	q "-1^"_$ze
}

/// 获取患者的危急值弹框链接
/// 如果患者历次就诊记录中有未处理的危急值 则返回要弹窗的URL；如果患者历次就诊记录中没有未处理的危急值 则返回空
ClassMethod GetCVPopupUrl(EpisodeID = "", PatientID = "")
{
	if EpisodeID="",PatientID="" q ""
	
	if PatientID="",EpisodeID>0 s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	
	if (PatientID="")||('$d(^PAPER(PatientID,"ALL"))) q ""
	
	s flag=0
	
	s admType = ""
	for {
		s admType = $O(^PAPERdr(PatientID,"ADM",admType))
		q:(admType="")
		q:flag=1
		
		s adm = ""
		for {
 			s adm = $O(^PAPERdr(PatientID,"ADM",admType,adm),-1)
 			q:(adm="")
 			q:flag=1
 			
 			if ..GetReportWarn(adm) s flag=1
 			
 			
		}
	}
	
	if flag=1 {
		q "criticalvalue.list.csp?EpisodeID="_EpisodeID_"&PatientID="_PatientID_"&SearchByPat=1"   //按患者查询 查询患者所有未处理危急值 
	}else{
		q ""	
	}
}

}
