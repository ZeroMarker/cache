Class web.UDHCOPINVPrtData12 Extends %RegisteredObject
{

/// 截取打印明细项名称长度
Parameter LimitLength [ Final ] = 15;

/// 发票一列可显示行数
Parameter MaxRows [ Final ] = 15;

/// Description: 获取发票打印信息
/// Debug: w ##class(web.UDHCOPINVPrtData12).GetOPPrtData("InvPrintNew",179,"SF01","","INVPrtFlag2007")
ClassMethod GetOPPrtData(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String, PrtFlag As %String) As %String
{
	set ^TMP("GetOPPrtData")=$lb(JSFunName, InvRowID, UseID, PayMode, PrtFlag)
	quit:($g(InvRowID)="") ""
	
	set SelectPrtDr=InvRowID
	set PrtData=$g(^DHCINVPRT(SelectPrtDr))
	set PatDr=$p(PrtData,"^",15)
	quit:(PatDr="") ""
	set myPrtFlag=$p(PrtData,"^",8)
	quit:(myPrtFlag="TP") ""
	
	set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	set SCH=$p(^PAPER(PatDr,"PAT",3),"^",12)  //$p(^PAPER(PatDr,"ALL"),"^",19)
	set SexDR=$p(^PAPER(PatDr,"ALL"),"^",7)
	set Sex=$s((+SexDR'=0):$p($g(^CT("SEX",SexDR)),"^",2),1:"")
	
	set Date=$p(PrtData,"^",5)
	set myInvNo=$p(PrtData,"^",14)
	set hospDR=$p(PrtData,"^",39)
	
	//2015-06-05 Lid 修改此处时一定要注意模版
	//1.发票号为空时不打印发票，发票模块是“INVPrtFlag2007”
	quit:((PrtFlag="INVPrtFlag2007")&&(myInvNo="")) ""
	
	set InsTypeDR=$p(PrtData,"^",9)
	set InsType=$s((+InsTypeDR'=0):$p($g(^PAC("ADMREA",InsTypeDR)),"^",2),1:"")
	set InsuDivDR=$p(PrtData,"^",30)
	set initDr=$p(PrtData,"^",13)
	//if (initDr'="") set InsuDivDR=$p(^DHCINVPRT(initDr),"^",30)
	set AdmLoc=$$GetAdmLocByInvID(SelectPrtDr)
	
	set YBSC=""
	/*
	set YBSCNo=myInvNo
	if (SCH'="99999999999S") set YBSC="上传No: "_YBSCNo
	if (SCH'="99999999999S") set SCH="手册号: "_SCH
	else  set SCH=""
	*/
	
	set UserDR=$p(PrtData,"^",21)
	set UsrName=$p(^SSU("SSUSR",UserDR),"^",2)
	set UsrCode=$p(^SSU("SSUSR",UserDR),"^",1)
	
	set myHospDR=$p(PrtData,"^",39)
	set Hospital=$s((+myHospDR'=0):$p($g(^CT("HOSP",myHospDR)),"^",2),1:"")
	set InvNum=$p(PrtData,"^",42)    //PRT_BusinessNo
	
	set DateL=$zd(Date,3)
	set PYear=$p(DateL,"-",1)
	set PMon=$p(DateL,"-",2)
	set PDay=$p(DateL,"-",3)
	
	set PayModeStr=""
	set PayMSub=0
	while($o(^DHCINVPRT(SelectPrtDr,"P",PayMSub))) {
		set PayMSub=$o(^DHCINVPRT(SelectPrtDr,"P",PayMSub))
		set PayMSubData=$g(^DHCINVPRT(SelectPrtDr,"P",PayMSub))
		set PayMAmt=+$p(PayMSubData,"^",3)
		continue:(PayMAmt=0)
		set PayMDR=$p(PayMSubData,"^",1)
		set PayMDesc=$p($g(^CT("CTPM",PayMDR)),"^",2)
		set myStr=PayMDesc_":"_$fn(PayMAmt,"",2)
		set PayModeStr=$s((PayModeStr=""):myStr,1:(PayModeStr_","_myStr))
	}
	
	set DiscAmount=+$p(PrtData,"^",7)
	if (+DiscAmount'=0) {
		set PayModeStr=PayModeStr_","_"折扣"_":"_$fn(DiscAmount,"",2)
	}
	set PrtPayorShare=+$p(PrtData,"^",18)
	if (+PrtPayorShare'=0) {
		set PayModeStr=PayModeStr_","_"记账"_":"_$fn(PrtPayorShare,"",2)
	}
	
	kill ^||TMP("InvData",$j)
	kill ^||TMP("WinInfo",$j)
	do ..SetINVPrtPLISTData(InvRowID)
	   	
	set prtListInfo=""
	if (PrtFlag="INVPrtFlag") {
		set prtListInfo=$$GetDetails()
	}
	
	if (PrtFlag="InvListPrint") {               //add by yyx  打印发票明细
		set prtListInfo=$$GetInvListDetails()
	}
	
	if (PrtFlag="InvPHW") {                     //add by yyx  打印发票明细
		set prtListInfo=$$GetInvPHW(SelectPrtDr)
	}
	
	set txtDataParaO=##class(%DynamicObject).%New()
	do txtDataParaO.%Set("PatName",PatName).%Set("RegNo",PatNo)
	do txtDataParaO.%Set("Date",DateL).%Set("OpenID",UsrName).%Set("UsrCode",UsrCode)
	do txtDataParaO.%Set("PYear",PYear).%Set("PMon",PMon).%Set("PDay",PDay)
	do txtDataParaO.%Set("UsrInvNum",InvNum).%Set("YBSC",YBSC).%Set("SCH",SCH)
	do txtDataParaO.%Set("InsType",InsType).%Set("AdmLoc",AdmLoc)
	do txtDataParaO.%Set("InvNo",myInvNo).%Set("Sex",Sex)
	do txtDataParaO.%Set("Hospital",Hospital).%Set("PML",PayModeStr)
	//获取发票打印的门诊收费大类信息
	set cateJsonStr=..GetCateData($j)
	if (cateJsonStr'="") {
		set cateJsonObj=##class(%DynamicObject).%FromJSON(cateJsonStr)  //分类信息
		set iter=cateJsonObj.%GetIterator()
	   	while iter.%GetNext(.key, .value) {
	   		do txtDataParaO.%Set(key,value)
	   	}
	}
	
   	set prtTxtInfo=##class(BILL.COM.XMLPrint).GetPrintTxtData(txtDataParaO)

	set listDataStr=..GetDetailsData($j)
	set listDataO=##class(%DynamicArray).%FromJSON(listDataStr)  //费用明细信息
	set prtListInfo=##class(BILL.COM.XMLPrint).GetPrintListData(listDataO)
	
	set rtnval=JSFunName_"('"_$zcvt(prtTxtInfo,"O","JS")_"','"_$zcvt(prtListInfo,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	kill ^||TMP("InvData",$j)
	kill ^||TMP("WinInfo",$j)
	
	//+2022-05-20 ZhYW 打印内容留痕
	do ##class(BILL.COM.BL.PrintLog).XMLPrintLog($classname(), "GetOPPrtData", "OPChgInv", InvRowID, txtDataParaO, listDataO, $lb(JSFunName, InvRowID, UseID, PayMode, PrtFlag))

	//add by lml 2015-01-27 增加打印日志
	try{
		set UseID=$p(^DHCINVPRT(InvRowID),"^",21)
		set myCondition="{InvRowID:"""_InvRowID_""",UseID:"""_UseID_""",PayMode:"""_PayMode_""",PrtFlag:"""_PrtFlag_"""}"
		set myContent="{InvRowID:"""_InvRowID_""",myInvNo:"""_myInvNo_"""}"
 		set mySecretCodeStr=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PatDr, "")
 		set mySecretCode=$p(mySecretCodeStr,"^",3)
		set mylog=##class(web.DHCEventLog).EventLog("udhcOPCharge.BillPrintInv", myCondition, myContent, mySecretCode)
	}catch{
		
	}
	//end
	
	quit 0
	
GetDetails()
	set myList=""
	set myIdx=0
	while($o(^||TMP("InvData",$j,"D",myIdx))) {
		set myIdx=$o(^||TMP("InvData",$j,"D",myIdx))
		set myStr=$g(^||TMP("InvData",$j,"D",myIdx))
		set myList=$s((myList=""):myStr,1:(myList_$c(2)_myStr))
	}
	quit myList
GetInvListDetails()
	//set myList="项目名称"_$c(2)_"单价"_"  "_"数量"_"  "_"金额"
	set TotalAmt=0
	set myList=""
	set myIdx=0
	while($o(^||TMP("InvData",$j,"D",myIdx))) {
		set myIdx=$o(^||TMP("InvData",$j,"D",myIdx))
		set myData=$g(^||TMP("InvData",$j,"D",myIdx))
		set ArcimDesc=$p(myData,"^",1)
		set UnitPrice=$p(myData,"^",2)
		set PackQty=$p(myData,"^",3)
		set OrdTotSum=$p(myData,"^",4)
		continue:(+OrdTotSum=0)
		set YBCode=$p(myData,"^",5)
		set TotalAmt=$i(TotalAmt,OrdTotSum)
		set myStr=ArcimDesc_$c(2)_"    "_UnitPrice_"    "_PackQty_"    "_OrdTotSum_" "_YBCode
		set myList=$s((myList=""):myStr,1:(myList_$c(2)_myStr))
	}
	
	set myList=myList_""_$c(2)_"合计"_"          "_$fn(TotalAmt,"",2)
	
	quit myList

GetAdmLocByInvID(invid)
    set locStr=""
    quit:(invid="") locStr
    set bci=0
    while($o(^DHCBCI(0,"INV",invid,bci))) {
	    set bci=$o(^DHCBCI(0,"INV",invid,bci))
	  	set adm=$p($g(^DHCBCI(bci)),"^",3)
	    continue:(adm="")
	    set LocDr=$p($g(^PAADM(adm)),"^",4)
	    continue:(LocDr="")
	    set LocDesc=$p($g(^CTLOC(LocDr)),"^",2)
	    continue:(LocDesc="")
	    set locStr=$s((locStr=""):LocDesc,1:(locStr_"  "_LocDesc))
	}
    quit locStr
GetInvPHW(InvRowID)
	set myList=""
    set ArcDesc=""
    while($o(^||TMP("WinInfo",$j,InvRowID,ArcDesc))'="") {
	    set ArcDesc=$o(^||TMP("WinInfo",$j,InvRowID,ArcDesc))
	    set Win=$g(^||TMP("WinInfo",$j,InvRowID,ArcDesc))
		set WinStr=ArcDesc_"请到"_Win_"领药"
		set myList=$s((myList=""):WinStr,1:(myList_$c(2)_WinStr))
	}
    quit myList
}

/// Description: 获取集中打印发票数据
/// Debug: w ##class(web.UDHCOPINVPrtData12).GetOPAccPayPrtData("xmlPrintFun","INVPrtFlagCPP","92","SF01","","^^239")
ClassMethod GetOPAccPayPrtData(JSFunName As %String, PrtXMLName As %String, AccPRowID As %String, UseID As %String, PayMode As %String, myExpStr As %String) As %String
{
	set ^||TMP("GetOPAccPayPrtData")=$lb(JSFunName, PrtXMLName, AccPRowID, UseID, PayMode, myExpStr)
	quit:$g(AccPRowID)="" ""
	set SelectPrtDr=AccPRowID
	set AccPData=$g(^DHCINVPRTAP(SelectPrtDr))
	set PatDr=$p(AccPData,"^",11)
	quit:(PatDr="") ""
	set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	set SCH=$p(^PAPER(PatDr,"PAT",3),"^",12)  //$p(^PAPER(PatDr,"ALL"),"^",19)
	set SexDR=$p(^PAPER(PatDr,"ALL"),"^",7)
	set Sex=$s((+SexDR'=0):$p($g(^CT("SEX",SexDR)),"^",2),1:"")
	set Date=$p(AccPData,"^",3)
	set myInvNo=$p(AccPData,"^",6)
	set myPayDiscSum=+$p(AccPData,"^",14)
	set myPatPaySum=+$p(AccPData,"^",13)
	set myHospDR=$p(AccPData,"^",30)
	set Hospital=$s((+myHospDR'=0):$p($g(^CT("HOSP",myHospDR)),"^",2),1:"")

	set UserDR=$p(AccPData,"^",5)
	set UsrName=$p(^SSU("SSUSR",UserDR),"^",2)
	set UsrCode=$p(^SSU("SSUSR",UserDR),"^",1)
	
	set DateL=$zd(Date,3)
	set PYear=$p(DateL,"-",1)
	set PMon=$p(DateL,"-",2)
	set PDay=$p(DateL,"-",3)
	set InvNum=$g(^DHCIPBill("InvNum","AccPrt",SelectPrtDr))
	
	set myallamount=""
	set PrtAcount=0, PrtDiscAmount=0, PrtPayorShare=0, PrtPatPay=0
	set AllPrtAcount=0, AllPrtDiscAmount=0, AllPrtPayorShare=0, AllPrtPatPay=0
	set ApPrtRowid=0
	while($o(^DHCINVPRTCAPi(0,"APINVDR",SelectPrtDr,ApPrtRowid))) {
		set ApPrtRowid=$o(^DHCINVPRTCAPi(0,"APINVDR",SelectPrtDr,ApPrtRowid))
		set PrtRowid=$p(^DHCINVPRTCAP(ApPrtRowid),"^",1)
		set PrtData=$g(^DHCINVPRT(PrtRowid))
		set PrtAcount=$p(PrtData,"^",1)
		set PrtDiscAmount=$p(PrtData,"^",7)
		set PrtPatPay=$p(PrtData,"^",16)
		set PrtPayorShare=$p(PrtData,"^",18)
		set AllPrtPatPay=AllPrtPatPay+PrtPatPay
		set AllPrtAcount=AllPrtAcount+PrtAcount
		set AllPrtDiscAmount=AllPrtDiscAmount+PrtDiscAmount
		set AllPrtPayorShare=AllPrtPayorShare+PrtPayorShare
	}
	if (AllPrtPatPay'=0)  set myallamount=myallamount_"自付金额"_":"_$fn(AllPrtPatPay,"",2)
	if (AllPrtDiscAmount'=0)  set myallamount=myallamount_"  折扣金额"_":"_$fn(AllPrtDiscAmount,"",2)
	if (AllPrtPayorShare'=0)  set myallamount=myallamount_"  记账金额"_":"_$fn(AllPrtPayorShare,"",2)
		
	set PayModeStr=""
	set PayMSub=0
	while($o(^DHCINVPRTAP(AccPRowID,"P",PayMSub))) {
		set PayMSub=$o(^DHCINVPRTAP(AccPRowID,"P",PayMSub))
		set PayMSubData=$g(^DHCINVPRTAP(AccPRowID,"P",PayMSub))
		set PayMAmt=$p(PayMSubData,"^",3)
		continue:(+PayMAmt=0)
		set PayMDR=$p(PayMSubData,"^",1)
		set PayMDesc=$p($g(^CT("CTPM",PayMDR)),"^",2)
		set myStr=PayMDesc_":"_$fn(PayMAmt,"",2)
		set PayModeStr=$s((PayModeStr=""):myStr,1:(PayModeStr_","_myStr))
	}
	if (AllPrtDiscAmount'=0) {
		if (PayModeStr="") {
			set PayModeStr="折扣"_":"_$fn(AllPrtDiscAmount,"",2)
		}else {
			set PayModeStr=PayModeStr_","_"折扣"_":"_$fn(AllPrtDiscAmount,"",2)
		}
	}
	if (AllPrtPayorShare'=0) {
		if (PayModeStr="") {
			set PayModeStr="记账"_":"_$fn(AllPrtPayorShare,"",2)
		}else {
			set PayModeStr=PayModeStr_","_"记账"_":"_$fn(AllPrtPayorShare,"",2)
		}
	}
	
	kill ^||TMP("InvData",$j)
	kill ^||TMP("WinInfo",$j)
	
	set myAccPRowID=0
	while($o(^DHCINVPRTCAPi(0,"APINVDR",AccPRowID,myAccPRowID))) {
		set myAccPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",AccPRowID,myAccPRowID))
		set myPrtRowID=$p(^DHCINVPRTCAP(myAccPRowID),"^",1)
		continue:(+myPrtRowID=0)
		do ..SetINVPrtPLISTData(myPrtRowID)
	}
	
	set txtDataParaO=##class(%DynamicObject).%New()
	do txtDataParaO.%Set("PatName",PatName).%Set("RegNo",PatNo_"  (集中)")
	do txtDataParaO.%Set("Sex",Sex).%Set("OpenID",UsrName).%Set("UsrCode",UsrCode)
	do txtDataParaO.%Set("PYear",PYear).%Set("PMon",PMon)
	do txtDataParaO.%Set("PDay",PDay).%Set("UsrInvNum",InvNum)
	do txtDataParaO.%Set("Hospital",Hospital).%Set("PayMode",myallamount)
	do txtDataParaO.%Set("InvNo",myInvNo).%Set("PML",PayModeStr)
	
	//ZhYW 2019-04-19 获取挂号打印凭证信息
	set admStr=..GetAdmStrByAPI(AccPRowID)
	for i=1:1:$l(admStr,"^") {
		set adm=$p(admStr,"^",i)
		continue:(+adm=0)
		set regJsonStr=##class(web.DHCOPAdmReg).GetPrintDataJson(adm)
		if (regJsonStr'="") {
			set regJsonObj=##class(%DynamicObject).%FromJSON(regJsonStr)
			set iter=regJsonObj.%GetIterator()
		   	while iter.%GetNext(.key, .value) {
		   		do txtDataParaO.%Set(key,value)
		   	}
			quit    //取第一条就诊信息
		}
	}
	//

	//获取发票打印的门诊收费大类信息
	set cateJsonStr=..GetCateData($j)
	if (cateJsonStr'="") {
		set cateJsonObj=##class(%DynamicObject).%FromJSON(cateJsonStr)  //分类信息
		set iter=cateJsonObj.%GetIterator()
	   	while iter.%GetNext(.key, .value) {
	   		do txtDataParaO.%Set(key,value)
	   	}
	}

   	set prtTxtInfo=##class(BILL.COM.XMLPrint).GetPrintTxtData(txtDataParaO)
	
	set listDataStr=..GetDetailsData($j)
	set listDataO=##class(%DynamicArray).%FromJSON(listDataStr)  //费用明细信息
	set prtListInfo=##class(BILL.COM.XMLPrint).GetPrintListData(listDataO)
	
	set rtnval=JSFunName_"('"_$zcvt(prtTxtInfo,"O","JS")_"','"_$zcvt(prtListInfo,"O","JS")_"');"
	&javascript<#(rtnval)#>
	kill ^||TMP("InvData",$j)
	kill ^||TMP("WinInfo",$j)
	
	//+2022-05-20 ZhYW 打印内容留痕
	do ##class(BILL.COM.BL.PrintLog).XMLPrintLog($classname(), "GetOPAccPayPrtData", "OPAccPayInv", AccPRowID, txtDataParaO, listDataO, $lb(JSFunName, PrtXMLName, AccPRowID, UseID, PayMode, myExpStr))

	//add by lml 2015-01-27 增加打印日志
	set myCondition="{PrtXMLName:"""_PrtXMLName_""",AccPRowID:"""_AccPRowID_""",UseID:"""_UseID_""",PayMode:"""_PayMode_""",myExpStr:"""_myExpStr_"""}"
	set myContent="{AccPRowID:"""_AccPRowID_""",myInvNo:"""_myInvNo_"""}"
 	set mySecretCodeStr=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PatDr,"")
 	set mySecretCode=$p(mySecretCodeStr,"^",3)
	set mylog=##class(web.DHCEventLog).EventLog("UDHCACAcc.PatPayINVPrt",myCondition,myContent,mySecretCode)
	//end
	quit 0
}

/// ShowCNMedDtl:是否显示草药明细标识(1:是, 0:否)
/// Debug: w ##class(web.UDHCOPINVPrtData12).SetINVPrtPLISTData("202501")
ClassMethod SetINVPrtPLISTData(InvRowID As %String, ShowCNMedDtl As %String = 0) As %String
{
	//获取中草药配制
	set myHospDR=$p(^DHCINVPRT(InvRowID),"^",39)
	set HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig(myHospDR)
	set rtn=$p(HerbConfig,$c(2))
	quit:(+rtn) ""   //配置错误
	
	do ..SetCurrencyUnit(myHospDR)	//+WangXQ 20230413 根据配置设置单位

	set FCHerbFlag=$p(HerbConfig,$c(2),2)	 //OPFC_HerbalFlag
	set FCHerbDesc=$p(HerbConfig,$c(2),3)
	set FCHerbNum=$p(HerbConfig,$c(2),4)
	set FCHerbRange=$p(HerbConfig,$c(2),5)
	set HerbIdx=0						     //草药费明细索引
	
	kill ^||TMP("InvData",$j,"PBID")
	set INVLinkDr=0
	while($o(^DHCBCI(0,"INV",InvRowID,INVLinkDr))) {
		set INVLinkDr=$o(^DHCBCI(0,"INV",InvRowID,INVLinkDr))
		set PB=$p(^DHCBCI(INVLinkDr),"^",2)
		continue:(+PB=0)
		set PBO=0
		while($o(^DHCPB(PB,"O",PBO))) {
			set PBO=$o(^DHCPB(PB,"O",PBO))
			set PBOData=$g(^DHCPB(PB,"O",PBO))
			continue:(PBOData="")
			set PBORowID=PB_"||"_PBO
			set Arcim=$p(PBOData,"^",3)
			set OEIMDR=$p(PBOData,"^",4)
			set recDeptDR=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),3)),"^",6)    //接收科室
			set locType=$p(^CTLOC(recDeptDR),"^",13) 
			if (locType="") set locType="Z"	;放在最后?
			set ^||TMP("InvData",$j,"PBID",locType,recDeptDR,PBORowID)=""
		}
	}
	
	set myLocType=""
	while($o(^||TMP("InvData",$j,"PBID",myLocType))'="") {
		set myLocType=$o(^||TMP("InvData",$j,"PBID",myLocType))
		set myRecDR=""
		while($o(^||TMP("InvData",$j,"PBID",myLocType,myRecDR))'="") {
			set myRecDR=$o(^||TMP("InvData",$j,"PBID",myLocType,myRecDR))
			set myPBORID=""
			while($o(^||TMP("InvData",$j,"PBID",myLocType,myRecDR,myPBORID))'="") {
				set myPBORID=$o(^||TMP("InvData",$j,"PBID",myLocType,myRecDR,myPBORID))
				set PB=+myPBORID
				set PBO=$p(myPBORID,"||",2)
				set PBOData=$g(^DHCPB(PB,"O",PBO))
				set OEIMDR=$p(PBOData,"^",4)
				set myAcrim=$p(PBOData,"^",3)
				set myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
				set ItmSubCatDR=$p(^ARCIM(+myAcrim,+$p(myAcrim,"||",2),1),"^",10)
				set ArcicID=$p(^ARC("IC",ItmSubCatDR),"^",8)    //医嘱大类rowid
				set ArcicDesc=$p(^OEC("ORCAT",ArcicID),"^",2)
				//yyx 按接收科室,分类打印副联
				set OrdType=##class(web.UDHCJFBaseCommon).GetOrdCateType(OEIMDR)
				if (OrdType="R") {
					do AddDWin(InvRowID, myRecDR, ArcicDesc, myPresNo)
				}
				set myOFFlag=##class(web.DHCOPConfig).ReadOESpPrtFlag(myAcrim)
				if (myOFFlag="F") {
					do AddJFToDetails(myPBORID)
				}else {
					do AddToDetails(myPBORID)
				}
				set PBD=0
				while($o(^DHCPB(PB,"O",PBO,"D",PBD))'="") {
					set PBD=$o(^DHCPB(PB,"O",PBO,"D",PBD))
					set PBDRowID=PB_"||"_PBO_"||"_PBD
					do AddToPLIST(PBDRowID)
				}
			}
		}
	}
	
	quit 0
	
AddDWin(InvRowID, myRecDR, ArcicDesc, myPresNo)
    quit:(myPresNo="")
	set WinInfo=##class(PHA.FACE.OUT.Com).GetPrtPrescWin(InvRowID, myPresNo)
	if (WinInfo'="") set ^||TMP("WinInfo",$j,InvRowID,ArcicDesc)=WinInfo
	quit
	
AddJFToDetails(PBORowID)
	set PB=$p(PBORowID,"||",1), PBO=$p(PBORowID,"||",2)
	set pboData=$g(^DHCPB(PB,"O",PBO))
	quit:(pboData="")
	set Arcim=$p(pboData,"^",3)
	set OEIMDR=$p(pboData,"^",4)
	set myINCIDR=$o(^INCI(0,"ARCIM_DR",+Arcim,0))
	set myINCRegu=$s((myINCIDR'=""):##class(web.DHCSTCOMMONSRV).getBarcode(myINCIDR),1:"")   //调用药房组接口取规格	
	set DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(Arcim)
	set ArcimDesc=$p($g(^ARCIM(+Arcim,1,1)),"^",2)  //名称
	set:(DrugCommonDesc'="") ArcimDesc=DrugCommonDesc_myINCRegu
	
	set PBD=0
	while($o(^DHCPB(PB,"O",PBO,"D",PBD))) {
		set PBD=$o(^DHCPB(PB,"O",PBO,"D",PBD))
		set pbdData=$g(^DHCPB(PB,"O",PBO,"D",PBD))
		continue:(pbdData="")
		set myTarRowID=$p(pbdData,"^",3)	        //PBD_TARI_DR
		continue:(myTarRowID="")
		set myTarDesc=$p($g(^DHCTARI(myTarRowID)),"^",2)
		set myUnitPrice=$p(pbdData,"^",4)		//PBD_UnitPrice
		set myUnitPrice=$fn(myUnitPrice,"",4)
		set PackQty=$p(pbdData,"^",5)			//PBD_BillQty
		continue:(+PackQty=0)
		//set OrdTotSum=$p(pbdData,"^",7)		//PBD_TotalAmount
		set OrdTotSum=$p(pbdData,"^",10)			//PBD_PatientShare
		set OrdTotSum=$fn(OrdTotSum,"",2)
		set PackUOMRowid=$p($g(^DHCTARI(myTarRowID)),"^",3)
		set PackUOM=$s((+PackUOMRowid'=0):$p($g(^CT("UOM",PackUOMRowid)),"^",2),1:"")
		set dspbDR=$p(pbdData,"^",27)
		if (dspbDR'="") {
			set dspbData=$g(^DHCOEDISQTY(+dspbDR,"I",$p(dspbDR,"||",2)))
			if (dspbData'="") {
				set inci=$p(dspbData,"^",5)
				set myTarDesc=$s((+inci'=0):$p(^INCI(inci,1),"^",2),1:myTarDesc)
				set baseUomDR=$s((+inci'=0):$p(^INCI(inci,1),"^",10),1:"")    //库存项基本单位
				set outUomDR=$s((+inci'=0):$p(^INCI(inci,1),"^",12),1:"")     //门诊药品取门诊发药单位
				set dispUomDR=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),"DHC")),"^",13)     //协议包装单位
				set uomDR=""
				if (dispUomDR'="") {
					set uomDR=dispUomDR
				}else {
					set uomDR=$s((outUomDR'=""):outUomDR,1:baseUomDR)
				}
				set PackUOM=$s((+uomDR'=0):$p($g(^CT("UOM",uomDR)),"^",2),1:"")
				set ConFac=##class(PHA.FACE.OUT.Com).UOMFac(uomDR, baseUomDR)
				set PackQty=PackQty/ConFac
			}
		}
		set myYBCode=""
		if (myYBCode'="") {
			if (myYBCode["#")  set myYBCode="无自付"
			if (myYBCode["%")  set myYBCode="有自付"
			if (myYBCode["*")  set myYBCode="全自付"
		}
		set Idx=$i(^||TMP("InvData",$j,"D"))
		set ^||TMP("InvData",$j,"D",Idx)=$e(myTarDesc,1,..#LimitLength)_"^"_myUnitPrice_%CurrencyUnit_"^"_$fn(PackQty,"N")_"/"_PackUOM_"^"_OrdTotSum_%CurrencyUnit_"^"_myYBCode
	}

	quit
AddToDetails(PBORowID)
	set PB=$p(PBORowID,"||",1), PBO=$p(PBORowID,"||",2)
	set pboData=$g(^DHCPB(PB,"O",PBO))
	quit:(pboData="")
	set Arcim=$p(pboData,"^",3)
	set OEIMDR=$p(pboData,"^",4)
	set ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) //ARC_ItmMast->ARCIM_ItemCat_DR
	//增加规格
	set myINCIDR=$o(^INCI(0,"ARCIM_DR",+Arcim,0))
	set myINCRegu=$s((myINCIDR'=""):##class(web.DHCSTCOMMONSRV).getBarcode(myINCIDR),1:"")   //调用药费组接口取规格
	
	//set DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(Arcim)
	set ArcimDesc=$p($g(^ARCIM(+Arcim,1,1)),"^",2)    //名称
	//if (DrugCommonDesc'="") set ArcimDesc=DrugCommonDesc_myINCRegu
	set IsAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(OEIMDR)
	if (IsAppRepFlag="Y") {
		set PartDesc=##class(web.DHCAPPInterface).GetExaReqPartDesc(OEIMDR)
		set ArcimDesc=ArcimDesc_PartDesc          //名称 + 部位
	}
	set DrgDesc=""
	set PackUOM=##class(web.DHCBillCommon).GetPackUom(Arcim, OEIMDR)
	set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEIMDR)
	set BillQty=$p(pboData,"^",5)
	set RefundQty=$p(pboData,"^",6)
	set Qty=BillQty+RefundQty
	quit:(+Qty=0)
	set PackQty=Qty/ConFac
	set Price=$p(pboData,"^",7)
	set Price=$fn(Price*ConFac,"",4)
	
	//set OrdTotSum=$p(pboData,"^",8)    //PBO_ToTalAmount
	set OrdTotSum=$p(pboData,"^",11)     //PBO_PatientShare
	set OrdTotSum=$fn(OrdTotSum,"",2)
	
	if ((+FCHerbFlag=1)&&(FCHerbRange[("^"_ItemCatDR_"^"))&&(ShowCNMedDtl=0)) {
		//属于草药?
		if (HerbIdx=0) {
			set HerbIdx=$i(^||TMP("InvData",$j,"D"))
		}
		set $p(^||TMP("InvData",$j,"D",HerbIdx),"^",1)=FCHerbDesc
		set $p(^||TMP("InvData",$j,"D",HerbIdx),"^",2)=""
		set $p(^||TMP("InvData",$j,"D",HerbIdx),"^",3)=""
		set $p(^||TMP("InvData",$j,"D",HerbIdx),"^",4)=$p($g(^||TMP("InvData",$j,"D",HerbIdx)),"^",4)+OrdTotSum
		set $p(^||TMP("InvData",$j,"D",HerbIdx),"^",5)=""
		quit
	}
	
	set Idx=$i(^||TMP("InvData",$j,"D"))
	set ^||TMP("InvData",$j,"D",Idx)=$e(ArcimDesc,1,..#LimitLength)_"^"_Price_%CurrencyUnit_"^"_$fn(PackQty,"N")_"/"_PackUOM_"^"_OrdTotSum_%CurrencyUnit_"^"_DrgDesc
	
	quit

AddToPLIST(PBDRowID)
	set PB=$p(PBDRowID,"||",1), PBO=$p(PBDRowID,"||",2), PBD=$p(PBDRowID,"||",3)
	set PBDData=$g(^DHCPB(PB,"O",PBO,"D",PBD))
	quit:(PBDData="")
	set ItmDR=$p(PBDData,"^",3)
	set TotalAmount=$p(PBDData,"^",7)
	set DiscAmount=$p(PBDData,"^",8)
	set PayorShare=$p(PBDData,"^",9)
	set PatientShare=$p(PBDData,"^",10)
	quit:(ItmDR="")
	set SubCatDR=$p(^DHCTARI(ItmDR),"^",15)
	quit:(SubCatDR="")
	set CateDR=$p(^DHCTarC("OC",SubCatDR),"^",3)
	quit:(CateDR="")
	
	set $li(^||TMP("InvData",$j,"CAT",CateDR),1)=$lg($g(^||TMP("InvData",$j,"CAT",CateDR)),1)+TotalAmount
	set $li(^||TMP("InvData",$j,"CAT",CateDR),2)=$lg($g(^||TMP("InvData",$j,"CAT",CateDR)),2)+DiscAmount
	set $li(^||TMP("InvData",$j,"CAT",CateDR),3)=$lg($g(^||TMP("InvData",$j,"CAT",CateDR)),3)+PatientShare
	set $li(^||TMP("InvData",$j,"CAT",CateDR),4)=$lg($g(^||TMP("InvData",$j,"CAT",CateDR)),4)+PayorShare

	quit
}

/// Description: 卡支付打印小条
/// Debug: w ##class(web.UDHCOPINVPrtData12).GetOPAccPayList("","185726","467","")
ClassMethod GetOPAccPayList(JSFunName As %String, InvRowID As %String, UseID As %String, PayMode As %String) As %String
{
	set ^||TMP("GetOPAccPayList")=$lb(JSFunName, InvRowID, UseID, PayMode)
	
	quit:($g(InvRowID)="") ""
	set SelectPrtDr=InvRowID
	
	set PrtData=$g(^DHCINVPRT(SelectPrtDr))
	set PatDr=$p(PrtData,"^",15)
	quit:(PatDr="") ""
	set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	set Date=$p(PrtData,"^",5)
	//set myInvNo=$p(PrtData,"^",14)
	set myPatPaySum=+$p(PrtData,"^",14)
	set InsuDivDR=$p(PrtData,"^",30)
	set UserDR=$p(PrtData,"^",21)
	set UsrName=$p(^SSU("SSUSR",UserDR),"^",2)
	set UsrCode=$p(^SSU("SSUSR",UserDR),"^",1)
	set hospDR=$p(PrtData,"^",39)

	set myPLRowID=""
	set myAccRowID=""
	set myAccPaySum=0
	set mySub=0
	while($o(^DHCINVPRT(SelectPrtDr,"P",mySub))&&(myAccRowID="")) {
		set mySub=$o(^DHCINVPRT(SelectPrtDr,"P",mySub))
		set myData=$g(^DHCINVPRT(SelectPrtDr,"P",mySub))
		continue:(myData="")
		set myPLRowID=$p(myData,"^",8)
		if (myPLRowID'="") {
			set myAccRowID=+myPLRowID
		}
		set myAccPaySum=$p(myData,"^",3)
	}
	set myRMB=##class(web.UDHCJFBaseCommon).RMBDXXZH(myAccPaySum)
	
	set CardNo=$p(^DHCACD("AccM",myAccRowID),"^",4)	
	set myBalance=$p(^DHCACD("AccM",+myPLRowID,"AccPL",$p(myPLRowID,"||",2)),"^",9)	
	set myPayLocDR=$p(^DHCACD("AccM",+myPLRowID,"AccPL",$p(myPLRowID,"||",2)),"^",10)
	set myPayLocDesc=$s((myPayLocDR'=""):$p($g(^CTLOC(myPayLocDR)),"^",2),1:"")
	
	set txtDataParaO=##class(%DynamicObject).%New()
	do txtDataParaO.%Set("PatName", PatName).%Set("RegNo", PatNo)
	do txtDataParaO.%Set("Datetime", $zd(Date,3)).%Set("OpenID", UsrName)
	do txtDataParaO.%Set("PayMode", PayMode).%Set("CardNo", CardNo)
	do txtDataParaO.%Set("Balance", $fn(myBalance,"",2)).%Set("PaySumYMB", myRMB)
	do txtDataParaO.%Set("PaySum", $fn(myAccPaySum,"",2)).%Set("Guser", UsrCode)
	do txtDataParaO.%Set("PayLoc", myPayLocDesc)
	
	set prtTxtInfo=##class(BILL.COM.XMLPrint).GetPrintTxtData(txtDataParaO)
	
	kill ^||TMP("InvData",$j)
	kill ^||TMP("WinInfo",$j)
	
	do ..SetINVPrtPLISTData(InvRowID, 1)
	
	set listDataStr=$$GetDetailsForList()
	set listDataO=##class(%DynamicArray).%FromJSON(listDataStr)  //费用明细信息
	set prtListInfo=##class(BILL.COM.XMLPrint).GetPrintListData(listDataO)
	
	set rtnval=JSFunName_"('"_$zcvt(prtTxtInfo,"O","JS")_"','"_$zcvt(prtListInfo,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	kill ^||TMP("InvData",$j)
	kill ^||TMP("WinInfo",$j)
	
	//+2022-05-20 ZhYW 打印内容留痕
	do ##class(BILL.COM.BL.PrintLog).XMLPrintLog($classname(), "GetOPAccPayList", "OPAccPayList", InvRowID, txtDataParaO, listDataO, $lb(JSFunName, InvRowID, UseID, PayMode))
	
	quit 0
GetDetailsForList()
	set ao=##class(%DynamicArray).%New()	
	set do=##class(%DynamicObject).%New()
	set do.Listdatapara="项目名称          规格  数量    金额"
	do ao.%Push(do)
	set myIdx=0
	while($o(^||TMP("InvData",$j,"D",myIdx))) {
		set myIdx=$o(^||TMP("InvData",$j,"D",myIdx))
		set myData=$g(^||TMP("InvData",$j,"D",myIdx))
		set myStr=$p(myData,"^",1)
		set myStr=myStr_"   "_$p(myData,"^",3)
		set myStr=myStr_"   "_$p(myData,"^",4)
		set myStr=myStr_"   "_$p(myData,"^",5)
		set do=##class(%DynamicObject).%New()
		set do.Listdatapara=myStr
		do ao.%Push(do)
	}
	quit ao.%ToJSON()
}

/// Debug: w ##class(web.UDHCOPINVPrtData12).GetDrugSpec()
ClassMethod GetDrugSpec(ArcimID As %String = "") As %String
{
	set rtn=""
	quit:(ArcimID="") rtn
	set inc=$o(^INCI(0,"ARCIM_DR",$p(ArcimID,"||",1),""))
	quit:(inc="") rtn
	set itminf=$o(^DHCITMINFO(0,"INCI",inc,""))
	if (itminf'="") {
		set rtn=$p($g(^DHCITMINFO(itminf)),"^",27)
	}
	quit rtn
}

/// Description: 获取打印审批数据
/// Debug: w ##class(web.UDHCOPINVPrtData12).GetOPOEAuditData("InvPrintNew","229002:PRT","cashier")
ClassMethod GetOPOEAuditData(JSFunName As %String, InvStr As %String, UserID As %String, LocId As %String = "") As %String
{
	set ^TMP("GetOPOEAuditData")=$lb(JSFunName, InvStr, UserID)
	set InvRowID=$p(InvStr,":",1)
	set InvType=$p(InvStr,":",2)
	quit:(InvRowID="") ""
	kill ^||TMP("InvData",$j)
	
	set AuditSum=0
	if (InvType="API") {
		set myHospDR=$p(^DHCINVPRTAP(InvRowID),"^",30)
	}else {
		set myHospDR=$p(^DHCINVPRT(InvRowID),"^",39)
	}
	
	set PrtCateIdStr=..GetOrdAuditCateIdStr(LocId, myHospDR)   //打印的医嘱大类
	
	set HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig(myHospDR)
	set rtn=$p(HerbConfig,$c(2))
	quit:(+rtn) ""              //配置错误
	set FCHerbFlag=$p(HerbConfig,$c(2),2)		//OPFC_HerbalFlag
	set FCHerbDesc=$p(HerbConfig,$c(2),3)
	set FCHerbNum=$p(HerbConfig,$c(2),4)
	set FCHerbRange=$p(HerbConfig,$c(2),5)
	set HerbIdx=0						        //草药费明细索引
	
	if (InvType="API") {
		set Papmi=$p(^DHCINVPRTAP(InvRowID),"^",11)
		set Date=$p(^DHCINVPRTAP(InvRowID),"^",3)
		set HospDR=$p(^DHCINVPRTAP(InvRowID),"^",30)
		set APIConDR=0
		while($o(^DHCINVPRTCAPi(0,"APINVDR",InvRowID,APIConDR))) {
			set APIConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",InvRowID,APIConDR))
			set PrtId=$p($g(^DHCINVPRTCAP(APIConDR)),"^",1)
			do BuildINVPrtAuditData(PrtId)
		}
	}else {
		set Papmi=$p(^DHCINVPRT(InvRowID),"^",15)
		set Date=$p(^DHCINVPRT(InvRowID),"^",5)
		set HospDR=$p(^DHCINVPRT(InvRowID),"^",39)
		do BuildINVPrtAuditData(InvRowID)
	}
	
	set PatName=$s((+Papmi'=0):$p(^PAPER(Papmi,"ALL"),"^",1),1:"")
	set PatNo=$s((+Papmi'=0):$p(^PAPER(Papmi,"PAT",1),"^",2),1:"")
	set Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	set Hospital=$s((+HospDR'=0):$p(^CT("HOSP",HospDR),"^",2),1:"")
	
	set txtDataParaO=##class(%DynamicObject).%New()
	do txtDataParaO.%Set("PatName", PatName).%Set("RegNo", PatNo)
	do txtDataParaO.%Set("Date", Date).%Set("Guser", UserID)
	do txtDataParaO.%Set("AuditSum", $fn(AuditSum,"",2)).%Set("Title", Hospital_"退费审批凭据")
	
	set prtTxtInfo=##class(BILL.COM.XMLPrint).GetPrintTxtData(txtDataParaO)
	
	set listDataStr=$$GetPrtDetails()
	set listDataO=##class(%DynamicArray).%FromJSON(listDataStr)  //费用明细信息
	set prtListInfo=##class(BILL.COM.XMLPrint).GetPrintListData(listDataO)
	
	set rtnval=JSFunName_"('"_$zcvt(prtTxtInfo,"O","JS")_"','"_$zcvt(prtListInfo,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	kill ^||TMP("InvData",$j)
	
	//+2022-05-20 ZhYW 打印内容留痕
	do ##class(BILL.COM.BL.PrintLog).XMLPrintLog($classname(), "GetOPOEAuditData", "OPOEAuditData", InvStr, txtDataParaO, listDataO, $lb(JSFunName, InvStr, UserID))

	quit rtn

BuildINVPrtAuditData(PrtRowId)
	set IOASub=0
	while($o(^DHCINVPRT(PrtRowId,"OA",IOASub))) {
		set IOASub=$o(^DHCINVPRT(PrtRowId,"OA",IOASub))
		set IOAData=$g(^DHCINVPRT(PrtRowId,"OA",IOASub))
		continue:(IOAData="")
		set OEIMDR=$p(IOAData,"^",1)
		set Arcim=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),1)),"^",2)
		set ItemCatDR=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10)
		set OrdCateDR=$p($g(^ARC("IC",ItemCatDR)),"^",8)    //医嘱大类
		continue:((PrtCateIdStr'="")&&(("^"_PrtCateIdStr_"^")'[("^"_OrdCateDR_"^")))
		set ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2)
		set IsAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(OEIMDR)
		if (IsAppRepFlag="Y") {
			set PartDesc=##class(web.DHCAPPInterface).GetReqBillPartIDDesc(OEIMDR)
			if (PartDesc'="") set ArcimDesc=ArcimDesc_PartDesc       //名称 + 部位
		}
		set PackUom=##class(web.DHCBillCommon).GetPackUom(Arcim, OEIMDR)
		set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEIMDR)
		set ReqQty=$p(IOAData,"^",5)
		set DspbDR=$p(IOAData,"^",9)
		set ReqAmt=$fn($p(IOAData,"^",22),"",2)
		set AuditSum=$i(AuditSum,ReqAmt)
		if (+DspbDR'=0) {
			set DspbData=$g(^DHCOEDISQTY(+DspbDR,"I",$p(DspbDR,"||",2)))
			set Inci=$p(DspbData,"^",5)            //库存项指针
			set BaseUomDR=$s((+Inci'=0):$p(^INCI(Inci,1),"^",10),1:"")     //库存项基本单位
			set OutUomDR=$s((+Inci'=0):$p(^INCI(Inci,1),"^",12),1:"")      //门诊药品取门诊发药单位
			set DispUomDR=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),"DHC")),"^",13)     //协议包装单位
			set UomDR=""
			if (DispUomDR'="") {
				set UomDR=DispUomDR
			}else {
				set UomDR=$s((OutUomDR'=""):OutUomDR,1:BaseUomDR)
			}
			set PackUom=$s((+UomDR'=0):$p($g(^CT("UOM",UomDR)),"^",2),1:"")
			set ConFac=##class(PHA.FACE.OUT.Com).UOMFac(UomDR, BaseUomDR)
		}
		set ReqQty=ReqQty/ConFac
		set ReqQty=$fn(ReqQty,"N")
		if ((+FCHerbFlag=1)&&(FCHerbRange[("^"_ItemCatDR_"^"))) {
			//属于草药?
			if (HerbIdx=0) {
				set HerbIdx=$i(^||TMP("InvData",$j,"D"))
			}
			set $p(^||TMP("InvData",$j,"D",HerbIdx),"^",1)=FCHerbDesc
			set $p(^||TMP("InvData",$j,"D",HerbIdx),"^",2)=""
			set $p(^||TMP("InvData",$j,"D",HerbIdx),"^",3)=$p($g(^||TMP("InvData",$j,"D",HerbIdx)),"^",4)+ReqAmt
			continue
		}
		set Idx=$i(^||TMP("InvData",$j,"D"))
		set ^||TMP("InvData",$j,"D",Idx)=$e(ArcimDesc,1,..#LimitLength)_"^"_$fn(ReqQty,"N")_"/"_PackUom_"^"_ReqAmt
	}
	
	quit

GetPrtDetails()	
	set ao=##class(%DynamicArray).%New()
	set do=##class(%DynamicObject).%New()
	set do.Listdatapara="项目名称"_"^"_"数量/规格"_"^"_"金额"
	do ao.%Push(do)
	set myIdx=0
	while($o(^||TMP("InvData",$j,"D",myIdx))) {
		set myIdx=$o(^||TMP("InvData",$j,"D",myIdx))
		set myStr=$g(^||TMP("InvData",$j,"D",myIdx))
		set do=##class(%DynamicObject).%New()
		set do.Listdatapara=myStr
		do ao.%Push(do)
	}
	quit ao.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2022-05-19
/// Description: 根据集中打印发票Id获取就诊Id串
/// Input: accPInvId:集中打印发票Id
/// Return: 
/// Debug: w ##class(web.UDHCOPINVPrtData12).GetAdmStrByAPI(1)
ClassMethod GetAdmStrByAPI(accPInvId As %String) As %String
{
    set admStr=""
    quit:(+accPInvId=0) admStr
    set conId=0
    while($o(^DHCINVPRTCAPi(0,"APINVDR",accPInvId,conId))) {
	    set conId=$o(^DHCINVPRTCAPi(0,"APINVDR",accPInvId,conId))
	 	set tmp=$g(^DHCINVPRTCAP(conId))
		continue:(tmp="")
		set prtRowId=$p(tmp,"^",1)
		continue:(+prtRowId=0)
		set billConInv=0
		while($o(^DHCBCI(0,"INV",prtRowId,billConInv))) {
			set billConInv=$o(^DHCBCI(0,"INV",prtRowId,billConInv))
			set billConData=$g(^DHCBCI(billConInv))
			continue:(billConData="")
			set adm=$p(billConData,"^",3)
			set admStr=$s((admStr=""):adm,1:(admStr_"^"_adm))	
		}
	}
    quit admStr
}

/// Creator: ZhYW
/// CreatDate: 2022-05-19
/// Description: 获取发票打印的门诊收费大类信息
/// Input: pid:进程号
/// Return: json
/// Debug: w ##class(web.UDHCOPINVPrtData12).GetCateData(1)
ClassMethod GetCateData(pid As %String) As %String
{
	set $zt="GetCateDataET"
	
	set jsonObj=##class(%DynamicObject).%New()
	
	set PatientShare=0
	set TotSum=0
	set DiscSum=0        //折扣金额
	set PayOrShare=0     //记账金额
	set Idx=0
	set FeeKey="Fee"
	set CateKey="FeeLab"
	
	set CateId=0
	while($o(^||TMP("InvData",pid,"CAT",CateId))) {
		set CateId=$o(^||TMP("InvData",pid,"CAT",CateId))
		set CateFeeStr=$g(^||TMP("InvData",pid,"CAT",CateId))
		set CateDesc=$p($g(^DHCTarC("TOC",CateId)),"^",2)
		set CateTotAmt=$lg(CateFeeStr,1)
		set CateDiscAmt=$lg(CateFeeStr,2)
		set CatePatAmt=$lg(CateFeeStr,3)
		set CatePayOrAmt=$lg(CateFeeStr,4)
		set Idx=$i(Idx)
		do jsonObj.%Set(CateKey_Idx, CateDesc).%Set(FeeKey_Idx, $fn(CatePatAmt,"",2)_%CurrencyUnit)
		set PatientShare=$i(PatientShare, CatePatAmt)
		set TotSum=$i(TotSum, CateTotAmt)
		set DiscSum=$i(DiscSum, CateDiscAmt)
		set PayOrShare=$i(PayOrShare, CatePayOrAmt)
	}
	
	set myRMB=##class(web.UDHCJFBaseCommon).RMBDXXZH(PatientShare)    //大写金额中只显示自付金额
	do jsonObj.%Set("PaySum", $fn(PatientShare,"",2)_%CurrencyUnit).%Set("PaySumPY", myRMB)
	
	quit jsonObj.%ToJSON()

GetCateDataET
	set $zt=""
	quit "{}"
}

/// Creator: ZhYW
/// CreatDate: 2022-05-19
/// Description: 获取发票打印的费用明细信息(双列打印)
/// Input: pid:进程号
/// Return: json
/// Debug: w ##class(web.UDHCOPINVPrtData12).GetDetailsData(1)
ClassMethod GetDetailsData(pid As %String) As %String
{
	set $zt="GetDetailsDataET"
		
	set myOrdCount=+$g(^||TMP("InvData",pid,"D"))
	for i=(myOrdCount+1):1:(..#MaxRows*2) {
		set ^||TMP("InvData",$j,"D",i)="^^^^"
		set ^||TMP("InvData",$j,"D")=i
	}
	
	set ao=##class(%DynamicArray).%New()
	for i=1:1:(..#MaxRows) {
		set myStr=$g(^||TMP("InvData",pid,"D",i))_"^"_$g(^||TMP("InvData",pid,"D",(i+..#MaxRows)))
		set do=##class(%DynamicObject).%New()
		set do.Listdatapara=myStr
		do ao.%Push(do)
	}
	quit ao.%ToJSON()

GetDetailsDataET
	set $zt=""
	quit "[]"
}

/// Creator: WangXQ
/// CreatDate: 2023-04-13
/// Description: 取配置的发票金额货币单位值
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置-门诊收费系统-门诊收费-发票金额货币单位
/// Debug: w ##class(web.UDHCOPINVPrtData12).GetCfgCurrencyUnit(2)
ClassMethod GetCfgCurrencyUnit(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPChrg.FPJEHBDW", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).value
	quit cfgData
}

/// Creator: WangXQ
/// CreatDate: 2023-04-13
/// Description: 根据配置修改全局变量%CurrencyUnit的值
/// Input: hospId: CT_Hospital.RowId
ClassMethod SetCurrencyUnit(hospId As %String) As %String
{
    set CurrencyUnit=..GetCfgCurrencyUnit(hospId)
	set %CurrencyUnit=CurrencyUnit
}

/// Creator: tangzf
/// CreatDate: 2023-04-13
/// Description: 获取门诊退费申请单需打印的医嘱大类RowId串
/// Input: deptId: CT_LocId.RowId,hospId: CT_Hospital.RowId
/// Return: OEC_OrderCategory.RowId
/// Others: 通用配置-门诊收费系统-门诊退费申请-退费单打印科室对照
/// Debug: w ##class(web.UDHCOPINVPrtData12).GetOrdAuditCateIdStr(1, 2)
ClassMethod GetOrdAuditCateIdStr(deptId As %String, hospId As %String) As %String
{
	set cateIdStr=""
	set rset=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultForQuery")
	do rset.Execute("OPCHRG.OPDrOrdRefdAppy.TFDDYKSDZ", deptId, "", hospId)
	while (rset.Next()) {
		set id=rset.Get("ID")
		continue:(id="")
		set cateIdStr=$s((cateIdStr=""):id,1:(cateIdStr_"^"_id))
	}
	quit cateIdStr
}

}
