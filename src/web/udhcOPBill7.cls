Class web.udhcOPBill7 Extends BILL.COM.Abstract
{

/// 取挂号的收据类型设置
/// Debug: w ##class(web.udhcOPBill7).GetRegReceiptType(2)
ClassMethod GetRegReceiptType(hospId As %String) As %String
{
	set receiptType=""
	set myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfig(hospId)
	if ($p(myBCInfo,"^",1)=0) {
		set receiptType=$p(myBCInfo,"^",30)
	}
	quit receiptType
}

/// Debug: w ##class(web.udhcOPBill7).GetReceiptNO("SetReceipNO","",4988,5,"","")
ClassMethod GetReceiptNO(itmjs As %String = "", itmjsex As %String = "", userId As %String, groupId As %String = "", fairType As %String = "", insTypeId As %String = "", hospId As %String = "")
{
	set rtn=0

	if (groupId="") set groupId=$p(^SSU("SSUSR",userId),"^",5)
	
	set myPrtFlag=1
	if (groupId'="") {
		set rtnValue=##class(web.UDHCOPGSConfig).ReadCFByGRowID(groupId, hospId)
		set rtn=$p(rtnValue,"^",1)
		quit:(+rtn) rtn
		set myPrtFlag=$p(rtnValue,"^",5)
		quit:(+myPrtFlag=0) rtn
	}

	set rtnValue=##class(udhcOPBill7).ReadReceiptNO(userId, groupId, fairType, insTypeId, hospId)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) 100
	
	set curNo=$p(rtnValue,"^",2)
	set rowId=$p(rtnValue,"^",3)
	set endNo=$p(rtnValue,"^",4)
	set title=$p(rtnValue,"^",5)
	set leftNum=$p(rtnValue,"^",6)
	set tipFlag=$p(rtnValue,"^",7)     //余票数小于设置值时，界面给予提示(1:提示, 0:不提示)
	
	set str=curNo_"^"_rowId_"^"_leftNum_"^"_endNo_"^"_title_"^"_tipFlag
	set retval=itmjs_"('"_$zcvt(str,"O","JS")_"');"
	//(if itmjsex'="""") set retval=retval_itmjsex_"('"_$zcvt(str,"O","JS")_"');"
	&javascript<#(retval)#>
	
	quit rtn
}

/// Debug: w ##class(web.udhcOPBill7).ReadReceiptNO(userId, groupId)
ClassMethod ReadReceiptNO(userId As %String, groupId As %String = "", fairType As %String = "", insTypeId As %String = "", hospId As %String = "") As %String
{
	set receiptNo=""
	set rid=""
	set endNo=""
	set title=""
	set leftNum=0
	set rtn=108
	quit:(userId="") rtn	//没有发票
	
	set myINVType="O"		//默认为门诊发票
	if (groupId'="") {
		set myGSRowID=$o(^DHCOPGSi("GS",0,"GSDR",groupId,0))
		if (+myGSRowID'=0) {
			set myUseINVType=$p($g(^DHCOPGS("GS",myGSRowID)),"^",18)
			if (myUseINVType'="") {
				set myINVType=myUseINVType
			}
		}
	}
	
	//增加费别与发票类型的配置，按如果做了费别与发票类型的配置则按费别取发票类型
	set myInsINVType=##class(web.UDHCJFPAY).GetInvTypeByAdmRea(insTypeId, "O", hospId)
	if (myInsINVType'="") set myINVType=myInsINVType
    
	set myRegReceiptType=..GetRegReceiptType(hospId)
	if ((fairType="R")&&(myRegReceiptType'="")) set myINVType=myRegReceiptType

	set myINVRowID=0
	while($o(^DHCINVOICE(0,"USER",userId,myINVRowID))) {
		set myINVRowID=$o(^DHCINVOICE(0,"USER",userId,myINVRowID))
		set myInvData=$g(^DHCINVOICE(myINVRowID))
		set myHospDR=$p(myInvData,"^",26)
		continue:(myHospDR'=hospId)
		set myFinalFlag=$p(myInvData,"^",7)   //INV_Finalflag
		continue:(myFinalFlag'="Y")
		set myType=$p(myInvData,"^",8)
		continue:(myType'=myINVType)
		set myCurNo=$p(myInvData,"^",6)
		set myEndno=$p(myInvData,"^",2)
		set myBegNo=$p(myInvData,"^",1)
		continue:((+myCurNo<+myBegNo))
		continue:((+myCurNo>+myEndno))
		set receiptNo=myCurNo
		set endNo=myEndno
		set rid=myINVRowID
		set title=$p(myInvData,"^",16)
		set leftNum=+endNo-myCurNo+1
		set rtn=0
		quit
	}
	
	set minTipRcptNum=##class(web.DHCBillCommon).GetParamConfigFlag("MinTipRcptNum")
	set tipFlag=$s((leftNum<minTipRcptNum):1, 1:0)  //余票数小于设置值时，界面给予提示(1:提示, 0:不提示)

	quit rtn_"^"_receiptNo_"^"_rid_"^"_endNo_"^"_title_"^"_leftNum_"^"_tipFlag
}

}
