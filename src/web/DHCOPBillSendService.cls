Class web.DHCOPBillSendService Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2019-06-10
/// Modify: ZhYW 2022-12-30 增加扩展参数
/// Description: 收费后，调用平台的接口
/// Input: prtRowIdStr:发票rowid串，用"^"分隔, expStr:安全组Id^登录科室Id
/// Return: 
/// Other: 是否成功不影响收费
/// Debug: do ##class(web.DHCOPBillSendService).SendOPChargeInfo("142", "239^3")
ClassMethod SendOPChargeInfo(prtRowIdStr As %String, expStr As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	set ordAry=..GetChgOrdJsonAry(prtRowIdStr)   //结算发票对应的医嘱数组
	
	do ..SendChgInfo2ENS(ordAry)   //调用平台接口推送收费消息
	
	do ..SendChgInfo2STM(ordAry)   //调用物资组接口减库存
	
	do ..SendChgInfo2CloseLoop(ordAry, expStr)    //给医嘱闭环管理推送收费消息
	
	quit rtn

ERROR
	do ..AppException()
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2019-08-01
/// Description: 退费后服务
/// Input: oeitmStr: 退费医嘱rowid串，用"^"分隔
/// Return: 0:成功，其他:失败
/// Other: 退费时只调用一下，是否成功不影响退费
/// Debug: w ##class(web.DHCOPBillSendService).SendOPRefundInfo("1816||3","10207")
ClassMethod SendOPRefundInfo(oeitmStr As %String, expStr As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	quit:(oeitmStr="") rtn
	
	set userId=$p(expStr,"^",1)
	
	set myOEORIStr=..FilterRefOEORIStr(oeitmStr)
	
	do ..StopAppPartID(myOEORIStr, userId)   //多部位检查申请单按部位退费
	
	do ..SendRefInfo2ENS(myOEORIStr)         //调用平台接口推送退费消息
	
	quit rtn

ERROR
	do ..AppException()
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2020-08-11
/// Description: 判断医嘱中是否有物资材料医嘱
/// Input: oeitmStr:退费医嘱rowid串，用"^"分隔
/// Return: 1:是，0:否
/// Other: 
/// Debug: w ##class(web.DHCOPBillSendService).IsContainsMat("526||227")
ClassMethod IsContainsMat(oeitmStr As %String) As %String
{
	set rtn=0
	for i=1:1:$p(oeitmStr,"^") {
		set oeitm=$p(oeitmStr,"^",i)
		continue:(oeitm="")
		set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
		continue:(arcim="")
		set isDispMat=##class(BILL.Interface.Inside.Invoke).AllowDispFlag(arcim)
		continue:(isDispMat'=1)
		set rtn=1
		quit
	}
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2021-07-27
/// Description: 收费时过滤已经收过一次费的医嘱，防止多次给第三方发消息或扣库存
/// 			 主要针对退费时不自动再收而是到收费界面重新收费的情况。
/// Input: oeitmStr: 医嘱串
/// Return: oeitmStr：筛选后的医嘱串
/// Debug: w ##class(web.DHCOPBillSendService).FilterChgOEORIStr("1400||4")
ClassMethod FilterChgOEORIStr(oeitmStr As %String) As %String
{
	set rtn=""
	for i=1:1:$l(oeitmStr,"^") {
		set oeitm=$p(oeitmStr,"^",i)
		continue:(oeitm="")
		continue:(##class(BILL.OP.COM.Method).IsReChgedOEORI(oeitm)=1)   //过滤重新收费的医嘱
		set rtn=$s((rtn=""):oeitm,1:(rtn_"^"_oeitm))
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2023-05-08
/// Description: 返回结算发票对应的医嘱数组
/// Input: prtRowIdStr: DHC_INVPRT.RowId，多个之间以"^"分隔
/// Return: 动态数组
///          如：[{"InvPrtID":"103","OEORIStr":"136||13^136||2^136||3^136||4^136||5^136||9"},{"InvPrtID":"109","OEORIStr":"54||2^54||3"}]
/// Debug: w ##class(web.DHCOPBillSendService).GetChgOrdJsonAry("103^109")
ClassMethod GetChgOrdJsonAry(prtRowIdStr As %String) As %DynamicArray
{
	set r=##class(%DynamicArray).%New()
	set len=$l(prtRowIdStr,"^")
	for i=1:1:len {
		set prtRowId=$p(prtRowIdStr,"^",i)
		continue:(+prtRowId=0)
		set oeitmStr=##class(web.DHCBL.CIDefine.OEORIDefine).GetOEORIStrByINVPRTStr(prtRowId, 0)
		set oeitmStr=..FilterChgOEORIStr(oeitmStr)
		set o=##class(%DynamicObject).%New()
		set o.InvPrtID=prtRowId
		set o.OEORIStr=oeitmStr
		do r.%Push(o)
		do o.%Close()
	}
	quit r
}

/// Creator: ZhYW
/// CreatDate: 2023-05-08
/// Description: 调用平台接口推送收费消息
/// Input: ordAry: 结算医嘱信息
/// Return: 
/// Debug: w ##class(web.DHCOPBillSendService).SendChgInfo2ENS("103^109")
ClassMethod SendChgInfo2ENS(ordAry As %DynamicArray) As %String
{
	set $zt="ERROR"
	set rtn=0
	set iter=ordAry.%GetIterator()
	while iter.%GetNext(.key, .value) {
   		set prtRowId=value.InvPrtID
   		continue:(prtRowId="")
		set oeitmStr=value.OEORIStr
		continue:(oeitmStr="")
		set sendInfo=oeitmStr_"@"_prtRowId
		do ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPCHARGEINFO", sendInfo)
   	}
   	quit rtn
ERROR
	do ..AppException()
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2023-05-08
/// Description: 调用物资组接口减库存
/// Input: ordAry: 结算医嘱信息
/// Return: 
/// Debug: w ##class(web.DHCOPBillSendService).SendChgInfo2STM("103^109")
ClassMethod SendChgInfo2STM(ordAry As %DynamicArray) As %String
{
	set $zt="ERROR"
	set rtn=0
	set iter=ordAry.%GetIterator()
	while iter.%GetNext(.key, .value) {
		set prtRowId=value.InvPrtID
		continue:(prtRowId="")
		set oeitmStr=value.OEORIStr
		continue:(oeitmStr="")
		set isMatFlag=..IsContainsMat(oeitmStr)
		continue:(isMatFlag=0)
		//物资组接口调用
		set sendInfo=oeitmStr_"@"_prtRowId
		do ##class(BILL.Interface.Inside.Invoke).BILLDisp(sendInfo)	   //收费后，调用物资组程序减库存
	}
   	quit rtn
ERROR
	do ..AppException()
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2023-05-08
/// Description: 给医嘱闭环管理推送收费消息
/// Input: ordAry: 结算医嘱信息, expStr:安全组Id^登录科室Id
/// Return: 
/// Debug: w ##class(web.DHCOPBillSendService).SendChgInfo2CloseLoop()
ClassMethod SendChgInfo2CloseLoop(ordAry As %DynamicArray, expStr As %String) As %String
{
	set $zt="ERROR"
	
	set ordR=##class(%DynamicArray).%New()
	set groupId=$p(expStr,"^",1)	    //安全组
	set ctLocId=$p(expStr,"^",2)		//登录科室
	
	set ctLocData=$s((+ctLocId'=0):$g(^CTLOC(ctLocId)),1:"")
    set ctLocCode=$p(ctLocData,"^",1)
    set ctLocDesc=$p(ctLocData,"^",2)
    
    set iter=ordAry.%GetIterator()
	while iter.%GetNext(.key, .value) {
   		set prtRowId=value.InvPrtID
   		continue:(prtRowId="")
		set oeitmStr=value.OEORIStr
		continue:(oeitmStr="")
		set prtData=$g(^DHCINVPRT(prtRowId))
		set prtDate=$p(prtData,"^",5)
		set prtTime=$p(prtData,"^",20)
		set userDR=$p(prtData,"^",21)
		set userCode=$s((+userDR'=0):$p($g(^SSU("SSUSR",userDR)),"^",1),1:"")
		set userName=$s((+userDR'=0):$p($g(^SSU("SSUSR",userDR)),"^",2),1:"")
		set prtDateTime=$zdt((prtDate_","_prtTime),3,1)
		for i=1:1:$l(oeitmStr,"^") {
			set oeitm=$p(oeitmStr,"^",i)
			continue:(oeitm="")
			set labEpisodeNo=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3)),"^",20)
			set ordO=##class(%DynamicObject).%New()
			set ordO.OEOrdItemID=oeitm
			set ordO.Position=""
			set ordO.ExamID=labEpisodeNo
			set ordO.Status="CHARGE"
			set ordO.UserID=userCode
			set ordO.UserName=userName
			set ordO.UpDateTime=prtDateTime
			set ordO.SourceSystem="HIS"
			set ordO.Notes=""
			set ordO.OperateDeptCode=ctLocCode
			set ordO.OperateDept=ctLocDesc
			do ordR.%Push(ordO)
			do ordO.%Close()
		}
   	}
	//调用平台接口更新闭环状态
	if (ordR.%Size()>0) {
		set ordS=##class(%Stream.GlobalCharacter).%New()
		do ordR.%ToJSON(.ordS)
		do ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus", ordS)
	}
	quit 0
ERROR
	do ..AppException()
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2023-05-08
/// Description: 退费时过滤急诊转出到住院的医嘱
/// Input: oeitmStr: 医嘱串
/// Return: oeitmStr：筛选后的医嘱串
/// Debug: w ##class(web.DHCOPBillSendService).FilterRefOEORIStr("")
ClassMethod FilterRefOEORIStr(oeitmStr As %String) As %String
{
	set rtn=""
	for i=1:1:$l(oeitmStr,"^") {
		set oeitm=$p(oeitmStr,"^",i)
		continue:(oeitm="")
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(oeitm)=1)   //+2022-05-05 ZhYW 急诊转出到住院的医嘱退出
		set rtn=$s((rtn=""):oeitm,1:(rtn_"^"_oeitm))
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2023-05-08
/// Description: 多部位检查申请单按部位退费，没有全退时不停止医嘱
/// Input: oeitmStr: 医嘱串
/// Return: 
/// Debug: w ##class(web.DHCOPBillSendService).FilterRefOEORIStr("")
ClassMethod StopAppPartID(oeitmStr As %String, userId As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	
	for i=1:1:$l(oeitmStr,"^") {
		set oeitm=$p(oeitmStr,"^",i)
		continue:(oeitm="")
		set statDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
		continue:(statCode="D")
		set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
		continue:(isAppRep'="Y")
		do ##class(web.DHCAPPInterface).StopPartID(oeitm, userId) //多部位检查申请单按部位退费，没有全退时不停止医嘱
	}
	quit rtn

ERROR
	do ..AppException()
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2023-05-08
/// Description: 调用平台接口推送退费消息
/// Input: oeitmStr: 医嘱串
/// Return: 
/// Debug: w ##class(web.DHCOPBillSendService).SendRefInfo2ENS("")
ClassMethod SendRefInfo2ENS(oeitmStr As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	quit:(oeitmStr="") rtn
	do ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPREFUNDCHARGEINFO", oeitmStr)
   	quit rtn
ERROR
	do ..AppException()
	quit 0
}

}
