Class web.DHCAntCVRunqian Extends %RegisteredObject
{

/// debug:d ##class(%ResultSet).RunQuery("web.DHCAntCVRunqian","QryCount","2020-01-01","2022-10-25")
Query QryCount(SDate As %String = "", EDate As %String = "", HospId As %String = "", AdmType = "", CountType = "") As websys.Query(CONTAINID = 0, ROWSPEC = "repType,repTypeDesc,locId,locDesc,cnt:%Double:总数,recCnt:%Double:已接收数,recOnTimeCnt:%Double:及时接收数,unrecOverTimeCnt:%Double:超时未接收数,execCnt:%Double:已处理数,execOnTimeCnt:%Double:及时处理数,unexecOverTimeCnt:%Double:超时未处理数,emrCnt:%Double:已书写病历数") [ SqlProc ]
{
}

ClassMethod QryCountExecute(ByRef QHandle As %Library.Binary, SDate As %String = "", EDate As %String = "", HospId As %String = "", AdmType = "", CountType = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	set ind=1 s QHandle=$lb(0,repid,0) 
	
	s SDate=$tr(SDate,$c(0)),EDate=$tr(EDate,$c(0)),HospId=$tr(HospId,$c(0)),AdmType=$tr(AdmType,$c(0)),CountType=$tr(CountType,$c(0))
	
	s RECTIMELIMIT=##class(web.DHCAntCVOptions).GetBaseOpt("RecTimeLimit")  //及时接收时间限制分钟
	s EXECTIMELIMIT=##class(web.DHCAntCVOptions).GetBaseOpt("ExecTimeLimit")   //及时处理时间限制分钟
	
	if EXECTIMELIMIT'>0 s EXECTIMELIMIT=30  //不配置处理限制 默认30分钟
	if RECTIMELIMIT'>0 s RECTIMELIMIT=EXECTIMELIMIT  //不配置接收限制 接收限制和处理相同
	
	
	if SDate="" q $$$OK
 	if EDate="" q $$$OK
 	s SDate=..DateParser(SDate)
	s EDate=..DateParser(EDate)
	
	if AdmType'="" s AdmType=","_AdmType_","
	
	s now=$h,nowDate=$p(now,",",1),nowTime=$p(now,",",2)
	
 	s iDate=SDate-1
 	for {
	 	s iDate=$o(^DHCAntCVReport(0,"DATE",iDate))
	 	q:(iDate="")||(iDate>EDate)
	 	
	 	s repType=""
	 	for {
		 	s repType=$o(^DHCAntCVReport(0,"DATE",iDate,repType))
		 	q:repType=""
		 	
		 	s repLabno=""
		 	for {
			 	s repLabno=$o(^DHCAntCVReport(0,"DATE",iDate,repType,repLabno))
			 	q:repLabno=""
			 	s repOrder=""
			 	for {
				 	s repOrder=$o(^DHCAntCVReport(0,"DATE",iDate,repType,repLabno,repOrder))
				 	q:repOrder=""
				 	
				 	s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
				 	s repStatus=$p(repInfo,"\",9)
				 	continue:repStatus="D"  //删除标志
				 	
				 	s adm=$p(repInfo,"\",7)
				 	
				 	s myAdmType=$p(^PAADM(adm),"^",2)
				 	continue:(AdmType'="")&&(AdmType'[myAdmType)
				 	
				 	s admLoc=$p(^PAADM(adm),"^",4)
				 	continue:admLoc=""
					s admHosp=$p($g(^CTLOC(+admLoc)),"^",22)
					continue:(HospId'="")&&(admHosp'=HospId)  //院区过滤
					
					
					if CountType="OnlyLoc" { //仅按科室统计
						s keyRepType=0,keyAdmLoc=admLoc
					}elseif CountType="OnlyType"{ //仅按报告类型统计
						s keyRepType=repType,keyAdmLoc=0	
					}else{
						s keyRepType=repType,keyAdmLoc=admLoc	
					}
					
					
					//开始计数
					//总数
					s cntList(keyRepType,keyAdmLoc,"all")=+$g(cntList(keyRepType,keyAdmLoc,"all"))+1
					
					s repDate=$p(repInfo,"\",1)
					s repTime=$p(repInfo,"\",2)
					
					//取首次接收 处理时间
					s recDate="",recTime="",execDate="",execTime=""
					s trOrder=""
					for {
						s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder))
						q:trOrder=""
						continue:trOrder'>0
						s trInfo=^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder)
						s trOpType=$p(trInfo,"\",16) if trOpType="",$p(trInfo,"\",8)="F" s trOpType="E"
						
						if trOpType="E" {
							continue:execDate'=""
							s execDate=$p(trInfo,"\",1),execTime=$p(trInfo,"\",2)
						}elseif trOpType="Rec" {
							continue:recDate'=""
							s recDate=$p(trInfo,"\",1),recTime=$p(trInfo,"\",2)
						}
						q:(execDate'="")&&(recDate'="")
					}
					
					if recDate="",execDate'="" { //有处理时间 没有接收时间  那么是没有接收流程的情况  接收信息同处理信息
						s recDate=execDate,recTime=recTime
					}
					if repType=1,admLoc=39 b
					if recDate'="" { 
						///接收数
						s cntList(keyRepType,keyAdmLoc,"rec")=+$g(cntList(keyRepType,keyAdmLoc,"rec"))+1
						
						if ..IsOverTime(repDate,repTime,recDate,recTime,RECTIMELIMIT)=0 {  //已接收 未超时
							//及时接收数
							s cntList(keyRepType,keyAdmLoc,"recOnTime")=+$g(cntList(keyRepType,keyAdmLoc,"recOnTime"))+1
						}
					}else{
						if ..IsOverTime(repDate,repTime,nowDate,nowTime,RECTIMELIMIT)=1 { //未接收 已超时
							//超时未接收数
							s cntList(keyRepType,keyAdmLoc,"unrecOverTime")=+$g(cntList(keyRepType,keyAdmLoc,"unrecOverTime"))+1
						}
					}
					
					if execDate'="" { 
						///处理数
						s cntList(keyRepType,keyAdmLoc,"exec")=+$g(cntList(keyRepType,keyAdmLoc,"exec"))+1
						
						if ..IsOverTime(repDate,repTime,execDate,execTime,EXECTIMELIMIT)=0 {  //已处理 未超时
							//及时处理数
							s cntList(keyRepType,keyAdmLoc,"execOnTime")=+$g(cntList(keyRepType,keyAdmLoc,"execOnTime"))+1
						}
					}else{
						if ..IsOverTime(repDate,repTime,nowDate,nowTime,EXECTIMELIMIT)=1 { //未处理 已超时
							//超时未处理数
							s cntList(keyRepType,keyAdmLoc,"unexecOverTime")=+$g(cntList(keyRepType,keyAdmLoc,"unexecOverTime"))+1
						}
					}
					
					
					s HasTransEMR=##class(web.DHCAntCVReportLink).HasTransEMR(repType_"||"_repLabno_"||"_repOrder)
					if HasTransEMR=1 {
						//病历数
						s cntList(keyRepType,keyAdmLoc,"emr")=+$g(cntList(keyRepType,keyAdmLoc,"emr"))+1
					}
					
					
				} //end repLabno

			} //end repLabno

		}  //end repType
	} //end iDate
	
	

	s keyRepType=""
	for {
		s keyRepType=$o(cntList(keyRepType))
		q:keyRepType=""
		
		if keyRepType=0 s repType="",repTypeDesc=""
		else  s repType=keyRepType,repTypeDesc=##class(web.DHCAntCVReportNameQuery).GetPanicName(repType)
		
		
		s keyAdmLoc=""
		for {
			
			s keyAdmLoc=$o(cntList(keyRepType,keyAdmLoc))
			q:keyAdmLoc=""
			
			if keyAdmLoc=0 s locId="",locDesc=""
			else  s locId=keyAdmLoc,locDesc=$p($g(^CTLOC(locId)),"^",2)
			
			s Data=$lb(repType,repTypeDesc,locId,locDesc)
			
			for cntKey="all","rec","recOnTime","unrecOverTime","exec","execOnTime","unexecOverTime","emr"{ //所有统计数值
				s Data=Data_$lb( +$g(cntList(keyRepType,keyAdmLoc,cntKey)) )
			}
			d OutputRow
		}
		
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

/// debug:d ##class(%ResultSet).RunQuery("web.DHCAntCVRunqian","QryCountDet","2020-01-01","2022-10-25","2","O","1","","^12^")
/// pStatus: pRecStatus^pExecStatus^pEmrStatus
/// 1-pRecStatus:接收状态  及时接收1 超时接收2  未接收但未超时3 超时未接收4
/// 2-pExecStatus:处理状态  及时处理1 超时处理2  未处理但未超时3 超时未处理4
/// 3-pEmrStatus 及时书写1 超时书写2  未书写但未超时3 未书写已超时4
Query QryCountDet(SDate As %String = "", EDate As %String = "", HospId As %String = "", AdmType = "", pRepType = "", pLocId = "", pStatus = "") As websys.Query(CONTAINID = 0, ROWSPEC = "reportID,adm,patientID,ordItem,examNo,repDT,repUserName,admLocDesc,admDocName,patName,patNo,mrNo,age,sex,dob,ordDesc,ordLocDesc,ordDoc,repResult,recDT,recUserName,recStatus,recStatusDesc,recTimeUsedAlias,execDT,execUserName,execStatus,execStatusDesc,execTimeUsedAlias,emrStatusDesc") [ SqlProc ]
{
}

ClassMethod QryCountDetExecute(ByRef QHandle As %Library.Binary, SDate As %String = "", EDate As %String = "", HospId As %String = "", AdmType = "", pRepType = "", pLocId = "", pStatus = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	set ind=1 s QHandle=$lb(0,repid,0) 
	
	s SDate=$tr(SDate,$c(0)),EDate=$tr(EDate,$c(0)),HospId=$tr(HospId,$c(0)),AdmType=$tr(AdmType,$c(0))
	s pRepType=$tr(pRepType,$c(0)),pLocId=$tr(pLocId,$c(0)),pStatus=$tr(pStatus,$c(0))
	s pRecStatus=$p(pStatus,"^",1),pExecStatus=$p(pStatus,"^",2),pEmrStatus=$p(pStatus,"^",3)

	s RECTIMELIMIT=##class(web.DHCAntCVOptions).GetBaseOpt("RecTimeLimit")  //及时接收时间限制分钟
	s EXECTIMELIMIT=##class(web.DHCAntCVOptions).GetBaseOpt("ExecTimeLimit")   //及时处理时间限制分钟
	
	if EXECTIMELIMIT'>0 s EXECTIMELIMIT=30  //不配置处理限制 默认30分钟
	if RECTIMELIMIT'>0 s RECTIMELIMIT=EXECTIMELIMIT  //不配置接收限制 接收限制和处理相同
	
	
	if SDate="" q $$$OK
 	if EDate="" q $$$OK
 	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	
	if AdmType'="" s AdmType=","_AdmType_","
	
	s now=$h,nowDate=$p(now,",",1),nowTime=$p(now,",",2)
	
 	s iDate=SDate-1
 	for {
	 	s iDate=$o(^DHCAntCVReport(0,"DATE",iDate))
	 	q:(iDate="")||(iDate>EDate)
	 	
	 	s repType=""
	 	for {
		 	s repType=$o(^DHCAntCVReport(0,"DATE",iDate,repType))
		 	q:repType=""
		 	
		 	continue:(pRepType'="")&&(pRepType'=repType) //类型过滤
		 	
		 	s repLabno=""
		 	for {
			 	s repLabno=$o(^DHCAntCVReport(0,"DATE",iDate,repType,repLabno))
			 	q:repLabno=""
			 	s repOrder=""
			 	for {
				 	s repOrder=$o(^DHCAntCVReport(0,"DATE",iDate,repType,repLabno,repOrder))
				 	q:repOrder=""
				 	
				 	s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
				 	s repStatus=$p(repInfo,"\",9)
				 	continue:repStatus="D"  //删除标志
				 	
				 	s adm=$p(repInfo,"\",7)
				 	
				 	s myAdmType=$p(^PAADM(adm),"^",2)
				 	continue:(AdmType'="")&&(AdmType'[myAdmType)
				 	s admLoc=$p(^PAADM(adm),"^",4)
				 	continue:admLoc=""
				 	continue:(pLocId'="")&&(pLocId'=admLoc) //科室过滤
				 	
					s admHosp=$p($g(^CTLOC(+admLoc)),"^",22)
					continue:(HospId'="")&&(admHosp'=HospId)  //院区过滤
					
				
					
					
					s repDate=$p(repInfo,"\",1)
					s repTime=$p(repInfo,"\",2)
					
					//取首次接收 处理时间
					s recDate="",recTime="",execDate="",execTime="",recUserName="",execUserName=""
					s trOrder=""
					for {
						s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder))
						q:trOrder=""
						continue:trOrder'>0
						s trInfo=^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder)
						s trOpType=$p(trInfo,"\",16) if trOpType="",$p(trInfo,"\",8)="F" s trOpType="E"
						
						if trOpType="E" {
							continue:execDate'=""
							s execDate=$p(trInfo,"\",1),execTime=$p(trInfo,"\",2)
							s execUserCode=$p(trInfo,"\",3),execUserCodeU=$$ALPHAUP^SSUTIL4(execUserCode)
							if execUserCodeU'="" {
								s execUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",execUserCodeU,""))
								if execUserId>0 s execUserName=$p(^SSU("SSUSR",execUserId),"^",2)
							}
						}elseif trOpType="Rec" {
							continue:recDate'=""
							s recDate=$p(trInfo,"\",1),recTime=$p(trInfo,"\",2)
							s recUserCode=$p(trInfo,"\",3),recUserCodeU=$$ALPHAUP^SSUTIL4(recUserCode)
							if recUserCodeU'="" {
								s recUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",recUserCodeU,""))
								if recUserId>0 s recUserName=$p(^SSU("SSUSR",recUserId),"^",2)
							}
						}
						q:(execDate'="")&&(recDate'="")
					}
					
					if recDate="",execDate'="" { //有处理时间 没有接收时间  那么是没有接收流程的情况  接收信息同处理信息
						s recDate=execDate,recTime=recTime
					}
					
					
					s (recStatus,recStatusDesc,recDT,recTimeUsedAlias)=""
					if recDate'="" {
						if ..IsOverTime(repDate,repTime,recDate,recTime,RECTIMELIMIT)=0 {  //已接收 未超时
							s recStatus=1,recStatusDesc="及时接收"
						}else{
							s recStatus=2,recStatusDesc="超时接收"
						}
						s recDT=..DateFormatter(recDate)_" "_$zt(recTime)
						s recTimeUsedAlias=..GetTimeUsedAlias(repDate,repTime,recDate,recTime)
						
					}else{
						if ..IsOverTime(repDate,repTime,nowDate,nowTime,RECTIMELIMIT)=1 { //未接收 已超时
							s recStatus=4,recStatusDesc="超时未接收"
						}else{
							s recStatus=3,recStatusDesc="未超时未接收"
						}
					}
					
					continue:(pRecStatus'="")&&(pRecStatus'[recStatus)  //接收状态过滤
					
					
					s (execStatus,execStatusDesc,execDT,execTimeUsedAlias)=""
					if execDate'="" { 
						if ..IsOverTime(repDate,repTime,execDate,execTime,EXECTIMELIMIT)=0 {  //已处理 未超时
							s execStatus=1,execStatusDesc="及时处理"
						}else{
							s execStatus=2,execStatusDesc="超时处理"
						}
						s execDT=..DateFormatter(execDate)_" "_$zt(execTime)
						s execTimeUsedAlias=..GetTimeUsedAlias(repDate,repTime,execDate,execTime)
					}else{
						if ..IsOverTime(repDate,repTime,nowDate,nowTime,EXECTIMELIMIT)=1 { //未处理 已超时
							s execStatus=4,execStatusDesc="超时未处理"
						}else{
							s execStatus=3,execStatusDesc="未超时未处理"
						}
						
					}
					continue:(pExecStatus'="")&&(pExecStatus'[execStatus)  //处理状态过滤
					
					
					s (emrStatus,emrStatusDesc,emrDT,emrTimeUsedAlias)=""
					s HasTransEMR=##class(web.DHCAntCVReportLink).HasTransEMR(repType_"||"_repLabno_"||"_repOrder)
					if HasTransEMR=1 {
						s emrStatus=1,emrStatusDesc="已写病程"
					}else{
						s emrStatus=3,emrStatusDesc="未写病程"	
					}
					continue:(pEmrStatus'="")&&(pEmrStatus'[emrStatus)  //病历状态过滤
					
					
					//取一些基本信息
					s admLocDesc=$p($g(^CTLOC(admLoc)),"^",2)
					s admDoc=$p(^PAADM(adm),"^",9),admDocName=""
					if admDoc>0 s admDocName=$p($g(^CTPCP(admDoc,1)),"^",2)
					s patientID=$p(^PAADM(adm),"^",1)
					s patNo=$p(^PAPER(patientID,"PAT",1),"^",1) //登记号 
					s mrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm,myAdmType,.ErrMsg)
					s patName=$p(^PAPER(patientID,"ALL"),"^",1)  //病人姓名 
					s sexDr=$p(^PAPER(patientID,"ALL"),"^",7),sex=""
					if sexDr>0 s sex=$p(^CT("SEX",sexDr),"^",2)
					s dob=$p(^PAPER(patientID,"ALL"),"^",6)  //生日 
					i dob>0 s DOB=..DateFormatter(dob)
					s age=##class(web.DHCBillInterface).GetPapmiAge(patientID,adm)  //年龄 
					s ordItem=$p(repInfo,"\",14)
					s ordDesc=##class(web.DHCAntCVReportSearch).GetOrdItems(ordItem,",","+")
					s ordPar=+$p(ordItem,"||",1),ordSub=+$p(ordItem,"||",2)
					s ordDoc=$p($g(^OEORD(ordPar,"I",ordSub,1)),"^",11),ordDocName=""
					s:ordDoc>0 ordDocName=$p(^CTPCP(ordDoc,1),"^",2) //下医嘱医生姓名
					s ordLoc = $p($g(^OEORD(ordPar,"I",ordSub,7)),"^",2),ordLocDesc="" 
					s:ordLoc>0 ordLocDesc=$p($g(^CTLOC(ordLoc)),"^",2) //开单科室
					s repResult=$g(^DHCAntCVReport(repType,repLabno,repOrder,"Result"))
					s repDT=..DateFormatter(repDate)_" "_$zt(repTime)
					s repUser=$p(repInfo,"\",3),repUserName=""
					if repUser>0 s repUserName=$p($g(^SSU("SSUSR",repUser)),"^",2)
					s examNo=$replace(repLabno,"--","||")
					s reportID=repType_"||"_repLabno_"||"_repOrder
					s Data=$lb(reportID,adm,patientID,ordItem,examNo,repDT,repUserName,admLocDesc,admDocName,patName,patNo,mrNo,age,sex,dob,ordDesc,ordLocDesc,ordDoc,repResult,recDT,recUserName,recStatus,recStatusDesc,recTimeUsedAlias,execDT,execUserName,execStatus,execStatusDesc,execTimeUsedAlias,emrStatusDesc)
					d OutputRow
				} //end repLabno

			} //end repLabno

		}  //end repType
	} //end iDate
	
	

	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod IsOverTime(date1, time1, date2, time2, minutes)
{
	q (date2-date1*86400+time2-time1)>(minutes*60)
}

ClassMethod GetTimeUsedAlias(date1, time1, date2, time2)
{
	s ret=""
	s sec=(date2-date1*86400+time2-time1)
	if sec>0 {
		s ret=##class(web.DHCAntCVComm).Seconds2Alias(sec)
	}
	q ret
}

ClassMethod DateFormatter(d)
{
	q ##class(websys.Conversions).DateLogicalToHtml(d)
}

ClassMethod DateParser(d)
{
	q ##class(websys.Conversions).DateHtmlToLogical(d)
}

}
