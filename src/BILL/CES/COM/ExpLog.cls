/// 名称: BILL.CES.COM.ExpLog
/// 描述: 单机版程序基础数据同步日志
/// 编写者: xiongwang
/// 编写日期: 2022-07-08
Class BILL.CES.COM.ExpLog Extends %RegisteredObject [ Abstract ]
{

/// Creator: xiongwang
/// CreatDate: 2022-07-08
/// Description: 写入日志表
/// w ##class(BILL.CES.COM.ExpLog).SaveExpLog("18","A02","S","ARC_Alias同步失败:class 'BILL.CES.COM.DBEXCUTE', method 'Excute': <UNDEFINED> 9 zGetARCAliasData+5^BILL.CES.BL.Export.1 b")
ClassMethod SaveExpLog(rowId As %String, terminalNo As %String, expStatus As %String, msg As %String)
{
	set $ze="SaveExpLogET"
	
	set rtnCode=0
	set rtnMsg=""
	set rtnVal=""
	if (terminalNo=""){
		set rtnCode=-1
		set rtnMsg="机器码不能为空"
		quit rtnCode_"^"_rtnVal_"^"_rtnMsg
	}
	if ("^B^S^F^")'[("^"_expStatus_"^"){
		set rtnCode=-1
		set rtnMsg="状态传入有误"
		quit rtnCode_"^"_rtnVal_"^"_rtnMsg
	}
	ts
	if (rowId=""){
		set elObj=##class(BILL.CES.PO.DHCExportLog).%New()
	}else{
		set elObj=##class(BILL.CES.PO.DHCExportLog).%OpenId(rowId)
	}

	set elObj.ELStatus=expStatus
	set elObj.ELMsg=msg
	set elObj.ELTerminalNo=terminalNo
	if (expStatus="B"){
		set elObj.ELCreateDate=+$h
		set elObj.ELCreateTime=$p($h,",",2)
	}else{
		set elObj.ELEndDate=+$h
		set elObj.ELEndTime=$p($h,",",2)
		
	}

	set sc=elObj.%Save()
	if ($system.Status.IsError(sc)) {
		tro
		set rtnCode=$system.Status.GetErrorCodes(sc)
		set rtnMsg=$system.Status.GetErrorText(sc)
		
	}else{
		tc
		set rtnVal=elObj.%Id()
	}
	
	quit rtnCode_"^"_rtnVal_"^"_rtnMsg
SaveExpLogET
	if ($tl>0) tro
	set rtnMsg=$ze
	set $zt=""
	quit -99_"^^"_"程序异常:"_$tr($ze,"^",":")
}

/// Creator: xiongwang
/// CreatDate: 2022-07-08
/// Description: 判断终端是否有效
ClassMethod CheckIsValid(terminalNo As %String) As %String
{
	set rtnCode=-1,rtnMsg=""
	if (terminalNo=""){
		set rtnMsg="机器码不能为空"
		quit rtnCode_"^"_rtnMsg
	}
	set rowId=$O(^CF.BSP.SYS.ClientI("CodeInd",$zu(28,terminalNo,7,32768),""))
	if (+rowId=0){
		set rtnMsg="客户端未注册"
		quit rtnCode_"^"_rtnMsg
	}

	set clientData=$g(^CF.BSP.SYS.ClientD(rowId))
	set stDate=$lg(clientData,6)
	set endDate=$lg(clientData,7)
	if (stDate>+$h){
		set rtnCode=-2
		set rtnMsg="客户端未生效,生效日期："_##class(websys.Conversions).DateLogicalToHtml(stDate)
		quit rtnCode_"^"_rtnMsg
	}
	
	if ((endDate'="")&&(endDate<=+$h)){
		set rtnCode=-3
		set rtnMsg="客户端已停用,停用日期："_##class(websys.Conversions).DateLogicalToHtml(endDate)
		quit rtnCode_"^"_rtnMsg
	}
	set rtnCode=0
	set rtnMsg="有效"
	quit rtnCode_"^"_rtnMsg
}

/// Creator: xiongwang
/// CreatDate: 2022-07-08
/// Description: 查询终端同步情况
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CES.COM.ExpLog","QryClientList","2022-09-08","N^B^F")
Query QryClientList(qryDate As %String = {+$h}, syncStatus As %String = "", clientCode As %String = "") As websys.Query(ROWSPEC = "terminalNo:%String,ipAddr:%String,macAddr:%String,webAddr:%String,locAddr:%String,elStatus:%String,elStDate:%String,elStTime:%String,takeTime:%String,elDate:%String,elMsg:%String")
{
}

ClassMethod QryClientListExecute(ByRef qHandle As %Binary, qryDate As %String = {+$h}, syncStatus As %String = "", clientCode As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
 	set qryDate=##class(websys.Conversions).DateHtmlToLogical(qryDate)
 	set rowId=0
 	while($o(^CF.BSP.SYS.ClientD(rowId))) {
	    set rowId=$o(^CF.BSP.SYS.ClientD(rowId))
	    set clientData=$g(^CF.BSP.SYS.ClientD(rowId))
	    set stDate=$lg(clientData,6)
	    set endDate=$lg(clientData,7)
		continue:(stDate>+qryDate) 
		continue:((endDate'="")&&(endDate<=+qryDate))
	    set terminalNo=$lg(clientData,2)
	    set ipAddr=$lg(clientData,3)
	    set macAddr=$lg(clientData,4)
	    set webAddr=$lg(clientData,5)
	    set locAddr=$lg(clientData,8)
	    continue:((clientCode'="")&&(clientCode'[terminalNo))
	    set elId=$o(^BILL.CES.PO.DHCExportLogI("IDXTNoDate",terminalNo,qryDate,""),-1)
	    if (elId>0){
		    set elStatus=$lg(^BILL.CES.PO.DHCExportLogD(elId),5)
		    set elStDate=$lg(^BILL.CES.PO.DHCExportLogD(elId),3)
		    set elStTime=$lg(^BILL.CES.PO.DHCExportLogD(elId),4)
		    set elEndDate=$lg(^BILL.CES.PO.DHCExportLogD(elId),6)
		    set elEndTime=$lg(^BILL.CES.PO.DHCExportLogD(elId),7)
		    set elMsg=$lg(^BILL.CES.PO.DHCExportLogD(elId),8)
		    set takeTime=""
		    if (elStatus'="B"){
			    set times=((elEndDate-elStDate)*24*60*60)+elEndTime-elStTime
			    set day=times\(24*60*60)
			    set hour=(times#(24*60*60))\(60*60)
				set min=((times#(24*60*60))#(60*60))\60
				set sec=((times#(24*60*60))#(60*60))#60
			    set:(day>0) takeTime=takeTime_day_"天"
			    set:(hour>0) takeTime=takeTime_hour_"小时"
			    set takeTime=takeTime_min_"分"_sec_"秒"
		    }
		    set elStDate=##class(websys.Conversions).DateLogicalToHtml(elStDate)
		    set elStTime=##class(websys.Conversions).TimeLogicalToHtml(elStTime,1)
	    }else{
		    set elStatus="N",elMsg="未同步"
		    set elStDate="",elStTime="",elEndDate="",elEndTime="",takeTime=""
	    }
	    continue:((syncStatus'="")&&(("^"_syncStatus_"^")'[("^"_elStatus_"^")))
	    set elStatus=$case(elStatus,"N":"未同步","B":"同步中","S":"成功","F":"失败",:"")
	    set elDate=##class(websys.Conversions).DateLogicalToHtml(qryDate)
	    do OutputClientList
	    
    }
	quit $$$OK
OutputClientList
    set Data=$lb(terminalNo,ipAddr,macAddr,webAddr,locAddr,elStatus,elStDate,elStTime,takeTime,elDate,elMsg)
    set ^CacheTemp(repid,ind)=Data
    set ind=ind+1
}

/// Creator: xiongwang
/// CreatDate: 2022-07-08
/// Description: 查询终端同步历史
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CES.COM.ExpLog","QryExpLogList","2022-07-18","2022-09-18","hjl","")
Query QryExpLogList(stDate As %String, endDate As %String, clientCode As %String, syncStatus As %String = "") As websys.Query(ROWSPEC = "elStDate:%String,elStTime:%String,elEndDate:%String,elEndTime:%String,takeTime:%String,elStatus:%String,elMsg:%String")
{
}

ClassMethod QryExpLogListExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, clientCode As %String, syncStatus As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
 	if (clientCode="") quit $$$OK
 	
 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
 	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	
 	
 	for date=stDate:1:endDate {
	 	set rowId=0
	 	while($o(^BILL.CES.PO.DHCExportLogI("IDXTNoDate",clientCode,date,rowId))) {
		    set rowId=$o(^BILL.CES.PO.DHCExportLogI("IDXTNoDate",clientCode,date,rowId))
		    set elData=$g(^BILL.CES.PO.DHCExportLogD(rowId))
		    set elStatus=$lg(elData,5)
		    set elStDate=$lg(elData,3)
		    set elStTime=$lg(elData,4)
		    set elEndDate=$lg(elData,6)
		    set elEndTime=$lg(elData,7)
		    set elMsg=$lg(elData,8)
		    set takeTime=""
		    continue:(elStDate<stDate)
		    continue:(elStDate>endDate)
		    if (elStatus'="B"){
			    set times=((elEndDate-elStDate)*24*60*60)+elEndTime-elStTime
			    set day=times\(24*60*60)
			    set hour=(times#(24*60*60))\(60*60)
				set min=((times#(24*60*60))#(60*60))\60
				set sec=((times#(24*60*60))#(60*60))#60
			    set:(day>0) takeTime=takeTime_day_"天"
			    set:(hour>0) takeTime=takeTime_hour_"小时"
			    set takeTime=takeTime_min_"分"_sec_"秒"
		    }
		    set elStDate=##class(websys.Conversions).DateLogicalToHtml(elStDate)
		    set elStTime=##class(websys.Conversions).TimeLogicalToHtml(elStTime,1)
			
			set elEndDate=##class(websys.Conversions).DateLogicalToHtml(elEndDate)
		    set elEndTime=##class(websys.Conversions).TimeLogicalToHtml(elEndTime,1)
		    
		    continue:((syncStatus'="")&&(syncStatus'=elStatus))
		    set elStatus=$case(elStatus,"N":"未同步","B":"同步中","S":"成功","F":"失败",:"")
		    
		    do OutputExpLogList
		    
	    }
 	}
	quit $$$OK
OutputExpLogList
    set Data=$lb(elStDate,elStTime,elEndDate,elEndTime,takeTime,elStatus,elMsg)
    set ^CacheTemp(repid,ind)=Data
    set ind=ind+1
}

}
