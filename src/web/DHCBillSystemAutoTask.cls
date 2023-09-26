/// 名称: web.DHCBillSystemAutoTask.cls
/// 描述: 计费组自动任务类
/// 编写者: ZhYW
/// 编写日期: 2019-03-27
Class web.DHCBillSystemAutoTask Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2012-12-03
/// Description: 自动结算门诊收费员日报表,每天结算到23:59:59
/// Input: endDate:先独立结算时设置成+$h-1,把任务放到24:00:00以后
/// Return: 
/// Debug: do ##class(web.DHCBillSystemAutoTask).AutoOPHandDaily("")
ClassMethod AutoOPHandDaily(endDate As %String = "") As %String
{
	set $zt="ERROR"
	
	if (endDate="") set endDate=+$h-1
	set rtn=0
	set job=$j
	kill ^||TMP(job)
	
    set rowId=$o(^DHCJFRcptGroupSet(0,"Type","O",3,0))
    quit:(+rowId=0) rtn
    
	set sub=0
	while($o(^DHCJFRcptGroupSet(rowId,"Sub",sub))) {
		set sub=$o(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		set data=$g(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		continue:(data="")
		set userId=$p(data,"^",4)
		continue:(+userId=0)
		set ^||TMP(job,userId)=""
	}
    
    set isNullBDHandin=##class(web.DHCBillCommon).GetParamConfigFlag("NullBDHandinFlag")
	
	set userId=0
	while($o(^||TMP(job,userId))) {
		set userId=$o(^||TMP(job,userId))
		set hospStr=##class(web.DHCBillCommon).GetUserLogonHosps(userId)   //+2018-12-11 ZhYW 取登录科室所在院区
		for i=1:1:$l(hospStr,"^") {
			set hospDR=$p(hospStr,"^",i)
			continue:(+hospDR=0)
			set endTime="23:59:59"
			if (isNullBDHandin=1) {
				set count=..CheckOPData(userId, hospDR, endDate, $zth(endTime,1))
				continue:(count=0)  //没有结账数据的不结算
			}
			set footInfo=##class(web.DHCOPBillDailyHandin).GetStDate(userId, hospDR, "U")
			set $p(footInfo,"^",3)=##class(websys.Conversions).DateLogicalToHtml(endDate)
			set $p(footInfo,"^",4)=endTime
			set $p(footInfo,"^",5)="Y"
			set $p(footInfo,"^",6)="N"
			set rtnValue=##class(web.DHCOPBillDailyHandin).Handin(userId, hospDR, footInfo)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				//结账失败日志
				set ^TMPAUTOOPDAILYHAND("FAIL",$zd(+$h,3),$zt($p($h,",",2),1),userId,"INPUT")=$lb(userId,hospDR,footInfo)
				set ^TMPAUTOOPDAILYHAND("FAIL",$zd(+$h,3),$zt($p($h,",",2),1),userId,"OUTPUT")=rtnValue
			}
		}
	}
	kill ^||TMP(job)
	
	quit rtn

ERROR
 	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-03-27
/// Description: 判断门诊日结是否有未结业务数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSystemAutoTask).CheckOPData(5, 2, 65717, 86399)
ClassMethod CheckOPData(userId As %String, hospId As %String, endDate As %String, endTime As %String) As %String
{
	set count=0
	
	//卡发票
	set cardInvId=0
	while($o(^DHCCARDINVPRTi(0,"HandIn","N",userId,cardInvId))) {
		set cardInvId=$o(^DHCCARDINVPRTi(0,"HandIn","N",userId,cardInvId))
		set cardInvData=$g(^DHCCARDINVPRT(cardInvId))
		set hospDR=$p(cardInvData,"^",20)
		continue:(hospId'=hospDR)
		set myDate=$p(cardInvData,"^",4)
		set myTime=$p(cardInvData,"^",5)
		continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
		set count=$i(count)
		quit
	}
	quit:(count'=0) count
	
	//门诊预交金
	set accM=0
	while($o(^DHCACDi("AccM",0,"HandIn","N",userId,accM))) {
		set accM=$o(^DHCACDi("AccM",0,"HandIn","N",userId,accM))
		set accMPD=0
		while($o(^DHCACDi("AccM",0,"HandIn","N",userId,accM,"AccPD",accMPD))) {
			set accMPD=$o(^DHCACDi("AccM",0,"HandIn","N",userId,accM,"AccPD",accMPD))
			set accMPDData=$g(^DHCACD("AccM",accM,"AccPD",accMPD))
			set hospDR=$p(accMPDData,"^",15)
			continue:(hospId'=hospDR)
			set myDate=$p(accMPDData,"^",3)
			set myTime=$p(accMPDData,"^",4)
			continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
			set count=$i(count)
			quit
		}
		quit:(count'=0)
	}
	quit:(count'=0) count
	
	//急诊留观押金
	set eccM=0
	while($o(^DHCEPMi("EPM",0,"HandIn","N",userId,eccM))) {
		set eccM=$o(^DHCEPMi("EPM",0,"HandIn","N",userId,eccM))
		set eccMPD=0
		while($o(^DHCEPMi("EPM",0,"HandIn","N",userId,eccM,"EPMD",eccMPD))) {
			set eccMPD=$o(^DHCEPMi("EPM",0,"HandIn","N",userId,eccM,"EPMD",eccMPD))
			set eccMPDData=$g(^DHCEPM("EPM",eccM,"EPMD",eccMPD))
			set hospDR=$p(eccMPDData,"^",13)
			continue:(hospId'=hospDR)
			set myDate=$p(eccMPDData,"^",3)
			set myTime=$p(eccMPDData,"^",4)
			continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
			set count=$i(count)
		}
		quit:(count'=0)
	}
	quit:(count'=0) count
	
	//门诊发票表
	set invId=0
	while($o(^DHCINVPRT(0,"HandIn","N",userId,invId))) {
		set invId=$o(^DHCINVPRT(0,"HandIn","N",userId,invId))
		set invData=$g(^DHCINVPRT(invId))
		set hospDR=$p(invData,"^",39)
		continue:(hospId'=hospDR)
		set prtFlag=$p(invData,"^",8)
		continue:(prtFlag="TP")
		set myDate=$p(invData,"^",5)
		set myTime=$p(invData,"^",20)
		continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
		set count=$i(count)
		quit
	}
	quit:(count'=0) count
	
	//门诊集中打印发票表
	set accPInvId=0
	while($o(^DHCINVPRTAPi(0,"HandIn","N",userId,accPInvId))) {
		set accPInvId=$o(^DHCINVPRTAPi(0,"HandIn","N",userId,accPInvId))
		set accPInvData=$g(^DHCINVPRTAP(accPInvId))
		set hospDR=$p(accPInvData,"^",30)
		continue:(hospId'=hospDR)
		set myDate=$p(accPInvData,"^",3)
		set myTime=$p(accPInvData,"^",4)
		continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
		set count=$i(count)
		quit
	}
	quit:(count'=0) count
	
	//作废发票表
	set voidId=0
	while($o(^DHCVoidInv(0,"HandIn","N",userId,voidId))) {
		set voidId=$o(^DHCVoidInv(0,"HandIn","N",userId,voidId))
		set voidData=$g(^DHCVoidInv(voidId))
		set voidInvType=$p(voidData,"^",11)    //VOI_Type
		continue:(voidInvType'["O")
		set hospDR=$p(voidData,"^",12)
		continue:(hospId'=hospDR)
		set myDate=$p(voidData,"^",1)
		set myTime=$p(voidData,"^",2)
		continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
		set count=$i(count)
		quit
	}
	quit:(count'=0) count
	
	//体检发票表
	set peInvId=0
	while($o(^DHCPEINVPRT(0,"RPFLAG",userId,"N",peInvId))) {
		set peInvId=$o(^DHCPEINVPRT(0,"RPFLAG",userId,"N",peInvId))
		set peInvData=$g(^DHCPEINVPRT(peInvId))
		set hospDR=$p(peInvData,"^",26)
		continue:(hospId'=hospDR)
		set myDate=$p(peInvData,"^",11)
		set myTime=$p(peInvData,"^",12)
		continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
		set count=$i(count)
		quit
	}
	quit:(count'=0) count
	
	//体检集中打印发票表
	set myDate=0
	while($o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",userId,myDate))) {
		set myDate=$o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",userId,myDate))
		set peInvFId=0
		while($o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",userId,myDate,peInvFId))) {
			set peInvFId=$o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",userId,myDate,peInvFId))
			set preInvData=$g(^User.DHCPEINVFocusPrtD(peInvFId))
			set hospDR=$lg(preInvData,12)
			continue:(hospId'=hospDR)
			set myTime=$lg(preInvData,6)
			continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
			set count=$i(count)
			quit
		}
		quit:(count'=0)
	}
	quit:(count'=0) count
	
	//体检充值表
	set peAPId=0
	while($o(^DHCPEAP(0,"ReportFlag",userId,"N",peAPId))) {
		set peAPId=$o(^DHCPEAP(0,"ReportFlag",userId,"N",peAPId))
		set peAPSub=0
		while($o(^DHCPEAP(0,"ReportFlag",userId,"N",peAPId,peAPSub))) {
			set peAPSub=$o(^DHCPEAP(0,"ReportFlag",userId,"N",peAPId,peAPSub))
			set peAPData=$g(^DHCPEAP(peAPId,"AC",peAPSub))
			set hospDR=$p(peAPData,"^",15)
			continue:(hospId'=hospDR)
			set myDate=$p(peAPData,"^",5)
			set myTime=$p(peAPData,"^",6)
			continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
			set count=$i(count)
			quit
		}
		quit:(count'=0)
	}
	
	quit count
}

/// Creator: ZhYW
/// CreatDate: 2018-02-09
/// Description: 住院日结任务
///             挂任务时应该挂到第二天(当天结前一天的账)
/// Input: endDate
/// Return: rtn
/// Debug: w ##class(web.DHCBillSystemAutoTask).AutoIPDailyHand(+$h-1)
ClassMethod AutoIPDailyHand(endDate As %String = "") As %String
{
	set $zt="ERROR"
	
	if (endDate="") set endDate=+$h-1
	
	set rtn=0
	set job=$j
	kill ^||TMP(job)
	
	set rowId=$o(^DHCJFRcptGroupSet(0,"Type","I",3,0))
	quit:(+rowId=0) rtn
	
	set sub=0
	while($o(^DHCJFRcptGroupSet(rowId,"Sub",sub))) {
		set sub=$o(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		set data=$g(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		continue:(data="")
	 	set userId=$p(data,"^",4)
	 	continue:(+userId=0)
	 	set ^||TMP(job,userId)=""
	}
	
	set isNullBDHandin=##class(web.DHCBillCommon).GetParamConfigFlag("NullBDHandinFlag")
	
	set userId=0
	while($o(^||TMP(job,userId))) {
		set userId=$o(^||TMP(job,userId))
		set hospStr=##class(web.DHCBillCommon).GetUserLogonHosps(userId)   //+2018-12-11 ZhYW 取登录科室所在院区
		for i=1:1:$l(hospStr,"^") {
			set hospDR=$p(hospStr,"^",i)
			continue:(+hospDR=0)
			set endTime="23:59:59"
			if (isNullBDHandin=1) {
				set count=..CheckIPData(userId, hospDR, endDate, $zth(endTime,1))
				continue:(count=0)  //没有结账数据的不结算
			}
			set footInfo=##class(web.DHCIPBillDailyHandin).GetStDate(userId, hospDR)
			set $p(footInfo,"^",3)=##class(websys.Conversions).DateLogicalToHtml(endDate)
			set $p(footInfo,"^",4)=endTime      //结账结束日期为前一天的"23:59:59"
			set $p(footInfo,"^",5)="Y"          //自动任务结账标识
			set rtnValue=##class(web.DHCIPBillDailyHandin).Handin(userId, hospDR, footInfo)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				//结账失败日志
				set ^TMPAUTOIPDAILYHAND("FAIL",$zd(+$h,3),$zt($p($h,",",2),1),userId,"INPUT")=$lb(userId,hospDR,footInfo)
				set ^TMPAUTOIPDAILYHAND("FAIL",$zd(+$h,3),$zt($p($h,",",2),1),userId,"OUTPUT")=rtnValue
			}
		}
	}
	
	kill ^||TMP(job)
	
	quit rtn

ERROR
 	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-03-27
/// Description: 判断住院日结是否有未结业务数据
/// Input: 
/// Return: >0:有未结数据
/// Debug: w ##class(web.DHCBillSystemAutoTask).CheckIPData("12173","2","65754","86399")
ClassMethod CheckIPData(userId As %String, hospId As %String, endDate As %String, endTime As %String) As %String
{
	set count=0
	
	//住院押金
	set depId=0
	while($o(^DHCSFPRINTDETAIL(0,"JKFLAG","N",userId,depId))) {
		set depId=$o(^DHCSFPRINTDETAIL(0,"JKFLAG","N",userId,depId))
		set depData=$g(^DHCSFPRINTDETAIL(depId))
		set hospDR=$p(depData,"^",44)
		continue:(hospId'=hospDR)
		set myDate=$p(depData,"^",2)
		set myTime=$p(depData,"^",3)
		continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
		set count=$i(count)
		quit
	}
	quit:(count'=0) count
	
	//住院发票
	set invId=0
	while($o(^DHCINVPRTZY(0,"HandIn","N",userId,invId))) {
		set invId=$o(^DHCINVPRTZY(0,"HandIn","N",userId,invId))
		set invData=$g(^DHCINVPRTZY(invId))
		set hospDR=$p(invData,"^",35)
		continue:(hospId'=hospDR)
		set myDate=$p(invData,"^",2)
		set myTime=$p(invData,"^",3)
		continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
		set count=$i(count)
		quit
	}
	quit:(count'=0) count
	
	//作废发票表
	set voidId=0
	while($o(^DHCVoidInv(0,"HandIn","N",userId,voidId))) {
		set voidId=$o(^DHCVoidInv(0,"HandIn","N",userId,voidId))
		set voidData=$g(^DHCVoidInv(voidId))
		set voidInvType=$p(voidData,"^",11)    //VOI_Type
		continue:(voidInvType'["I")
		set hospDR=$p(voidData,"^",12)
		continue:(hospId'=hospDR)
		set myDate=$p(voidData,"^",1)
		set myTime=$p(voidData,"^",2)
		continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
		set count=$i(count)
		quit
	}
	quit:(count'=0) count
	
	//欠费结算表
	set QFId=0
	while($o(^DHCJFQFTOTAL(0,"HandIn","N",userId,QFId))) {
		set QFId=$o(^DHCJFQFTOTAL(0,"HandIn","N",userId,QFId))
		set QFData=$g(^DHCJFQFTOTAL(QFId))
		set hospDR=$p(QFData,"^",18)
		continue:(hospId'=hospDR)
		set myDate=$p(QFData,"^",2)
		set myTime=$p(QFData,"^",3)
		continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
		set count=$i(count)
		quit
	}
	quit:(count'=0) count
	
	//集中打印发票表
	set spiRowId=0
	while($o(^BILL.IP.SummaryPrtInvI("HandinUserDR","N",userId,spiRowId))) {
		set spiRowId=$o(^BILL.IP.SummaryPrtInvI("HandinUserDR","N",userId,spiRowId))
		set spiData=$g(^BILL.IP.SummaryPrtInvD(spiRowId))
		set hospDR=$lg(spiData,14)
	 	continue:(hospId'=hospDR)
	 	set myDate=$lg(spiData,7)
		set myTime=$lg(spiData,8)
		continue:((myDate>endDate) || ((myDate=endDate)&&(myTime>endTime)))
		set count=$i(count)
		quit
	}
	quit:(count'=0) count
	
	quit count
}

/// Creator: Lid
/// CreatDate: 2015-12-28
/// Description: 自动撤销/确认完成任务
/// Debug: w ##class(web.DHCBillSystemAutoTask).AutoCancelTask()
ClassMethod AutoCancelTask(Date As %String = "") As %String
{
	set $zt="ERROR"
	
	if (Date="") set Date=+$h-1   //默认处理前一天的预结算记录
	
	set PrtRowID=0
	while($o(^DHCINVPRT(0,"Date",Date,PrtRowID))) {
		set PrtRowID=$o(^DHCINVPRT(0,"Date",Date,PrtRowID))
		set PrtData=$g(^DHCINVPRT(PrtRowID))
		continue:(PrtData="")
		set PrtFlag=$p(PrtData,"^",8)
		continue:(PrtFlag'="TP")		//过滤非预结算记录
		set PrtUser=$p(PrtData,"^",21)
		set HospDR=$p(PrtData,"^",39)
		set Grup=$p(PrtData,"^",41)
		if (Grup="") set Grup=$p($g(^SSU("SSUSR",PrtUser)),"^",5)
		//set IsCashier=##class(web.UDHCJFBaseCommon).CheckISCashier(PrtUser, HospDR)
		//continue:(+IsCashier=0)	   //过滤收费员
		set InsTypeDR=$p(PrtData,"^",9)
		set ExceptionInfo=##class(web.DHCOPBillChargExcepiton).GetExceptionInfo(PrtRowID)
		set OperatCode=$p(ExceptionInfo,"^",1)
		if (+OperatCode=1) {
			//撤销
			set myExpStr=Grup_"^"_PrtUser
			set err=##class(web.DHCBillConsIF).DelINVPRTForYB(PrtRowID, myExpStr)
			set ^DHCOPBILLExceptionTaskErrLog("ExceptionLog","Cancel",+$h,PrtUser,PrtRowID)=err
		}
	}
	
	quit 0
	
ERROR
 	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2012-12-03
/// Description: 自动结算诊间支付日报表,每天结算到23:59:59
/// Input: endDate:先独立结算时设置成+$h-1,把任务放到24:00:00以后
/// Return: 
/// Debug: do ##class(web.DHCBillSystemAutoTask).AutoDiagHandDaily("")
ClassMethod AutoDiagHandDaily(endDate As %String = "") As %String
{
	set $zt="ERROR"
	
	if (endDate="") set endDate=+$h-1
	set rtn=0
	set job=$j
	kill ^||TMP(job)
	
	set hospId=0
	while($o(^CT("HOSP",hospId))) {
		set hospId=$o(^CT("HOSP",hospId))
		set rset=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultByRelaCodeForQuery")
		do rset.Execute("OPCHRG.CnstroomChrg.AQZYJSYHDZ", "", "", hospId)
		while (rset.Next()) {
			set userId=rset.Get("CRDTgtData")
			continue:(+userId=0)
			set ^||TMP(job,userId)=""
		}
	}
    set isNullBDHandin=##class(web.DHCBillCommon).GetParamConfigFlag("NullBDHandinFlag")
	
	set userId=0
	while($o(^||TMP(job,userId))) {
		set userId=$o(^||TMP(job,userId))
		set hospStr=##class(web.DHCBillCommon).GetUserLogonHosps(userId)   //+2018-12-11 ZhYW 取登录科室所在院区
		for i=1:1:$l(hospStr,"^") {
			set hospDR=$p(hospStr,"^",i)
			continue:(+hospDR=0)
			set endTime="23:59:59"
			if (isNullBDHandin=1) {
				set count=..CheckOPData(userId, hospDR, endDate, $zth(endTime,1))
				continue:(count=0)  //没有结账数据的不结算
			}
			set footInfo=##class(web.DHCOPBillDailyHandin).GetStDate(userId, hospDR, "U")
			set $p(footInfo,"^",3)=##class(websys.Conversions).DateLogicalToHtml(endDate)
			set $p(footInfo,"^",4)=endTime
			set $p(footInfo,"^",5)="Y"
			set $p(footInfo,"^",6)="N"
			set rtnValue=##class(web.DHCOPBillDailyHandin).Handin(userId, hospDR, footInfo)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				//结账失败日志
				set ^TMPAUTOOPDAILYHAND("FAIL",$zd(+$h,3),$zt($p($h,",",2),1),userId,"INPUT")=$lb(userId,hospDR,footInfo)
				set ^TMPAUTOOPDAILYHAND("FAIL",$zd(+$h,3),$zt($p($h,",",2),1),userId,"OUTPUT")=rtnValue
			}
		}
	}
	kill ^||TMP(job)
	
	quit rtn

ERROR
 	quit ..AppException()
}

}
