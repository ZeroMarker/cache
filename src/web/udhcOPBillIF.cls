Class web.udhcOPBillIF Extends BILL.COM.Abstract
{

/// Debug: w ##class(web.udhcOPBillIF).GetnobilledCount("13^", "46^693")
ClassMethod GetnobilledCount(PAADMStr As %String = "", unBillStr As %String, ExpStr As %String = "") As %String
{
	set myGroupId=$p(ExpStr,"^",1)
	set myLocId=$p(ExpStr,"^",2)
	
	set myHospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myLocId)
	set myRecDepStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(myGroupId, myHospId, myLocId)
	
	quit ##class(web.udhcOPBill1).GetnobilledCount(PAADMStr, unBillStr, myRecDepStr)
}

/// Debug: w ##class(web.udhcOPBillIF).GetReceiptNO("setReceiptNo","","5^^122^F^^2")
ClassMethod GetReceiptNO(itmjs As %String = "", itmjsex As %String = "", ExpStr As %String = "")
{
	set ^TMP("GetReceiptNO")=$lb(itmjs, itmjsex, ExpStr)
	set myUserID=$p(ExpStr,"^",1)
	set myPINVFlag=$p(ExpStr,"^",2)
	set myGroupID=$p(ExpStr,"^",3)
	set myFairType=$p(ExpStr,"^",4)
	set myAdmInsType=$p(ExpStr,"^",5)
	set myHospDR=$p(ExpStr,"^",6)
	
	quit ##class(web.udhcOPBill7).GetReceiptNO(itmjs, itmjsex, myUserID, myGroupID, myFairType, myAdmInsType, myHospDR)
}

/// Debug: w ##class(web.udhcOPBillIF).ReadReceiptNO("5","122","F^^2")
ClassMethod ReadReceiptNO(UserDR As %String, GroupDR As %String = "", ExpStr As %String = "") As %String
{
	set ^TMP("ReadReceiptNO")=$lb(UserDR, GroupDR, ExpStr)
	set fairType=$p(ExpStr,"^",1)
	set admInsType=$p(ExpStr,"^",2)
	set myHospDR=$p(ExpStr,"^",3)
	
	quit ##class(web.udhcOPBill7).ReadReceiptNO(UserDR, GroupDR, fairType, admInsType, myHospDR)
}

/// 重新发布内嵌接口
/// Debug: w ##class(web.udhcOPBillIF).OPOEORDBILLINL(18400,"1111^","","2.00","21491","174","922","1043","")
ClassMethod OPOEORDBILLINL(PAPMIDR As %String, ADMStrInfo As %String, OEORDStr As %String, PatPaySum As %String, AccMRowID As %String, SessionStr As %String) As %String
{
	quit ##class(web.udhcOPBill1).OPOEORDBILLINL(PAPMIDR, ADMStrInfo, OEORDStr, PatPaySum, AccMRowID, SessionStr)
}

/// Debug: w ##class(web.udhcOPBillIF).GetOEORDSum("807||20","")
ClassMethod GetOEORDSum(OEORIStr As %String, ExpStr As %String = "") As %String
{
	quit ##class(web.udhcOPBill1).GetOEORDSum(OEORIStr)
}

/// Creator: Lid
/// CreatDate: 2014-04-11
/// Description: 根据就诊号或医嘱Rowid串，获取科室结算数据
/// Input: EpisodeID:就诊号, InsType:费别, OeoriIDStr:要结算的医嘱传, ExpStr:扩展串(用户^安全组^科室^院区^^^)
/// Return: 
/// Debug: w ##class(web.udhcOPBillIF).GetLocCheckOutInfo("763","","","11103^10^28^2")
ClassMethod GetLocCheckOutInfo(EpisodeID As %String, InsType As %String, OeoriIDStr As %String, SessionStr As %String = "") As %String
{
	set ^TMP("GetLocCheckOutInfo")=$lb(EpisodeID, InsType, OeoriIDStr, SessionStr)
	quit ##class(web.udhcOPBill1).GetLocCheckOutInfo(EpisodeID, InsType, OeoriIDStr, SessionStr)
}

/// Creator: Lid
/// CreatDate: 2014-04-11
/// Description: 科室卡消费结算模式
/// Input: expStr:安全组指针^科室指针^医院指针
/// Return: 0:弹出收费组界面，1：不弹界面直接结算
/// Other: 
/// Debug: w ##class(web.udhcOPBillIF).GetCheckOutMode("150^50^2")
ClassMethod GetCheckOutMode(expStr As %String) As %String
{
	set groupId=$p(expStr,"^",1)
	set ctLocId=$p(expStr,"^",2)
	set hospId=$p(expStr,"^",3)
	set myBCInfo=##class(web.UDHCOPGSConfig).ReadCFByGRowID(groupId, hospId)
	set rtn=+$p(myBCInfo,"^",20)
	quit rtn
}

/// Description: 查询实际退款总额
/// Debug: w ##class(web.udhcOPBillIF).ReadParkSum("6058")
ClassMethod ReadParkSum(PRTRowID As %String = "", ExpStr As %String = "") As %String
{
	quit ##class(web.udhcOPBill3).ReadParkSum(PRTRowID)
}

/// 增加一个查询未结算医嘱的类方法?
/// 参数待定  费别?PAADMStr?
/// 返回参数基本上是医嘱的RowID?扩展信息需要各个产品自己查询
/// 主要是推出1版
/// Debug: w ##class(web.udhcOPBillIF).ReadUFAdmOrder("35","","","22","636")
ClassMethod ReadUFAdmOrder(PAADMStr As %String, AdmInsType As %String, UnBillStr As %String, GroupDR As %String = "", CTLocDR As %String = "") As %String
{
	quit ##class(web.udhcOPBill1).ReadUFAdmOrder(PAADMStr, AdmInsType, UnBillStr, GroupDR, CTLocDR)
}

/// Debug: w ##class(web.udhcOPBillIF).GetPresPhw()
ClassMethod GetPresPhw() As %String
{
	quit ##class(web.udhcOPBill).GetPresPhw()
}

}
