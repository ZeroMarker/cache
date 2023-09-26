/// 硬件通讯设备 连接 注册接口
/// 接口设备的 软件分为：
/// 1. Com类型的Dll
/// 2. Net 框架下的Dll
/// 3. Java 编写的Jar文件
/// 
/// 此类的目的主要是解耦 多个设备的同一个操作
/// 对于某一种操作需要有特殊的分类
/// 同时加入操作分类
Class web.UDHCCardCommLinkRegister Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 256;

ClassMethod GetCardHardJSFunction() As %String
{
	;读卡 函数设备 接口
	;d ##class(web.UDHCCardCommLinkRegister).GetCardHardJSFunction()
	n (ad)
	
	s myHaveFlag=0
	
	d ..KillTMP()
	
	;定义一个JS函数名称
	s ^TMPFunStr($j, 1)="function DHCHardComm_RandomCardEquip(CardType, FunctionType, InPara1, InPara2, InPara3)"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="{"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	var myrtn=""0"";"
	
	s myHaveFlag=##class(web.UDHCCardCommLinkRegister).InitHardCommunation("CE","R")
	
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	return myrtn;"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="}"
	
	W !,"<SCRIPT language=""Javascript"">",!
		s myIdx=0
		f  s myIdx=$o(^TMPFunStr($j, myIdx)) q:(myIdx="")  d
		.w ^TMPFunStr($j, myIdx),!
	w "</SCRIPT>"
	w !
	
	d ..KillTMP()
	
	;增加输出本地的js，用于扩展读卡函数
	w !,"<script type=""text/javascript"" src=""../scripts/DHCWeb.OPCommonManageCard.Local.js""></script>",!

	q ""
}

ClassMethod GetWriteCardHardJSFunction() As %String
{
	; 写卡 Dll函数接口
	;d ##class(web.UDHCCardCommLinkRegister).GetWriteCardHardJSFunction()
	n (ad)
	
	s myHaveFlag=0
	
	;定义一个JS函数名称
	s ^TMPFunStr($j,1)="function DHCHardComm_RandomWriteCardEquip(CardType, InPara1, InPara2, InPara3)"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="{"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	var myrtn="""";"
	
	s myHaveFlag=##class(web.UDHCCardCommLinkRegister).InitHardCommunation("CE","W")
	
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	return myrtn;"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="}"
	
	
	W !,"<SCRIPT language=""Javascript"">",!
		s myIdx=0
		f  s myIdx=$o(PLIST(myIdx)) q:(myIdx="")  d
		.w PLIST(myIdx),!
	w "</SCRIPT>"
	w !
	
	k PLIST
	
	q ""
}

ClassMethod GetBarCodeHardJSFunction() As %String
{
	;d ##class(web.UDHCCardCommLinkRegister).GetBarCodeHardJSFunction()
	;对于条形码设备的接口文件
	n (ad)
	
	s myHaveFlag=0
	d ..KillTMP()
	
	;定义一个JS函数名称
	s ^TMPFunStr($j,1)="function DHCHardComm_BarCodeEquip(CardType,FunctionType,InPara1, InPara2, InPara3)"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="{"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	var myrtn=""0"";"
	
	s myHaveFlag=##class(web.UDHCCardCommLinkRegister).InitHardCommunation("BC","P")
	
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	return myrtn;"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="}"
	
	W !,"<SCRIPT language=""Javascript"">",!
		s myIdx=0
		f  s myIdx=$o(^TMPFunStr($j, myIdx)) q:(myIdx="")  d
		.w ^TMPFunStr($j, myIdx),!
	w "</SCRIPT>"
	w !
	d ..KillTMP()
	
	q ""
}

/// 语音设备
ClassMethod GetSoundQuoteHardJSFunction() As %String
{
	n (ad)
	
	s myHaveFlag=0
	d ..KillTMP()
	
	;定义一个JS函数名称
	s ^TMPFunStr($j,1)="function DHCHardComm_SoundQuoteEquip(CardType,FunctionType, InPara1, InPara2, InPara3)"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="{"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	var myrtn=""0^"";"
	
	s myHaveFlag=##class(web.UDHCCardCommLinkRegister).InitHardCommunation("SQ","P")
	
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	return myrtn;"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="}"
	
	W !,"<SCRIPT language=""Javascript"">",!
		s myIdx=0
		f  s myIdx=$o(^TMPFunStr($j, myIdx)) q:(myIdx="")  d
		.w ^TMPFunStr($j, myIdx),!
	w "</SCRIPT>"
	w !
	d ..KillTMP()
	
	q ""
}

/// 密码输入设备
ClassMethod GetPWDKeyPressHardJSFunction() As %String
{
	n (ad)
	
	s myHaveFlag=0
	d ..KillTMP()
	
	;定义一个JS函数名称
	s ^TMPFunStr($j,1)="function DHCHardComm_PWDKeyPressEquip(CardType, FunctionType, InPara1, InPara2, InPara3)"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="{"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	var myrtn=""0^000000"";"
	
	s myHaveFlag=##class(web.UDHCCardCommLinkRegister).InitHardCommunation("PKE","P")
	
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	return myrtn;"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="}"
	
	W !,"<SCRIPT language=""Javascript"">",!
		s myIdx=0
		f  s myIdx=$o(^TMPFunStr($j, myIdx)) q:(myIdx="")  d
		.w ^TMPFunStr($j, myIdx),!
	w "</SCRIPT>"
	w !
	d ..KillTMP()
	
	q ""
}

/// /读取身份证设备
ClassMethod GetPersonInfoJSFunction() As %String
{
	;d ##class(web.UDHCCardCommLinkRegister).GetPersonInfoJSFunction()
	;读取身份证基本信息
	s myHaveFlag=0
	
	d ..KillTMP()
	
	;定义一个JS函数名称
	s ^TMPFunStr($j, 1)="function DHCHardComm_RandomPersonInfoEquip(CardType, FunctionType, InPara1, InPara2, InPara3)"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="{"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	var myrtn=""0"";"
	
	s myHaveFlag=##class(web.UDHCCardCommLinkRegister).InitHardCommunation("IE","R")
	
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	return myrtn;"
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="}"
	
	W !,"<SCRIPT language=""Javascript"">",!
		s myIdx=0
		f  s myIdx=$o(^TMPFunStr($j, myIdx)) q:(myIdx="")  d
		.w ^TMPFunStr($j, myIdx),!
	w "</SCRIPT>"
	w !
	b
	d ..KillTMP()
	
	q ""
}

ClassMethod InitHardCommunation(HardGroupType As %String, FunctionType As %String) As %String
{
	;初始化读卡设备类接口
	;把同一个分组的设备函数写在一个函数中
	;d ##class(web.UDHCCardCommLinkRegister).InitHardCommunation("CE")
	;还要细分其他的类型
	;n (HardGroupType)
	
	;^DHCCARDHARDCOM("GROUP",{CCG_RowID})
	;^DHCCARDHARDCOMi("GROUP",0,{CCG_Type},{CCG_RowID})
	
	;modify by 郭荣勇,兼容IE,Chorme
	;q ..InitHardCommunation020(HardGroupType,FunctionType)
	
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="		try{"
	q:(HardGroupType="") ""
	s myGRowID=$o(^DHCCARDHARDCOMi("GROUP",0,HardGroupType,0))
	
	q:(myGRowID="") ""
	
	s myHaveFlag=0
	;JS函数名称
	;PLIST
	
	s myCount=0
	;^DHCCARDHARDCOMi("MANAGER",0,"CG",{CCM_ComGroup_DR},{CCM_RowID})
	s myMRowID=0
	f  s myMRowID=$o(^DHCCARDHARDCOMi("MANAGER",0,"CG",myGRowID,myMRowID))  q:(myMRowID="")  d
	.;^DHCCARDHARDCOM("MANAGER",{CCM_RowID})
	.s myDateTo=+$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",15)
	.q:((+myDateTo'=0)&&(myDateTo<+$h))
	.s myDllType=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",16)		;CTD_DLLType
	.i myDllType="CD" d
	..d ..GetByComDll(myMRowID)
	.i myDllType="ND" d
	..d ..GetByNetDLL(myMRowID)
	.s myJSFunction=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",9)	;CCM_JSFunctionName
	.s myDLLFunctionNam=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",10)	;CCM_JSFunctionName
	.s myInParaStr=""
	.s myDLLInPara1=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",11)	;CCM_DLLInPara1
	.s:(myDLLInPara1'="") myInParaStr="InPara1"
	.s myDLLInPara2=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",12)	;CCM_DLLInPara2
	.s:(myDLLInPara2'="") myInParaStr=myInParaStr_", InPara2"
	.s myDLLInPara3=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",13)	;CCM_DLLInPara3
	.s:(myDLLInPara3'="") myInParaStr=myInParaStr_", InPara3"
	.s myObjectID=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",5)		;CCM_OBJECTID
	.;Function Dll 
	.s myFunSub=0
	.;^DHCCARDHARDCOM("MANAGER", myMRowID, "FUN", myFunSub)
	.f  s myFunSub=$o(^DHCCARDHARDCOM("MANAGER", myMRowID, "FUN", myFunSub)) q:(myFunSub="")  d
	..q:($d(^DHCCARDHARDCOM("MANAGER", myMRowID, "FUN", myFunSub))=10)
	..s myData=^DHCCARDHARDCOM("MANAGER", myMRowID, "FUN", myFunSub)
	..s myDLLFunctionTyp=$p(myData,"^",5)
	..;q:(myDLLFunctionTyp'=FunctionType)
	..s:myDLLFunctionTyp="" myDLLFunctionTyp="default"
	..s ^TMPDHCCLASSFun($j,myDLLFunctionTyp, myMRowID_"||"_myFunSub)=myMRowID_"||"_myFunSub
	
	;写JS函数体
	;FunctionType
	s myObjectID=""
	s myCaseType=""
	s myDLLFunctionTyp=""
	f  s myDLLFunctionTyp=$o(^TMPDHCCLASSFun($j,myDLLFunctionTyp)) q:(myDLLFunctionTyp="")  d
	.s myDLLFunRowID=""
	.f  s myDLLFunRowID=$o(^TMPDHCCLASSFun($j,myDLLFunctionTyp, myDLLFunRowID))  q:(myDLLFunRowID="")  d
	..s myMRowID=+$p(myDLLFunRowID,"||",1)
	..s myFunSub=$p(myDLLFunRowID,"||",2)
	..s myObjectID=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",5)		;CCM_OBJECTID
	..s myDllType=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",16)		;CTD_DLLType
	..s:(+myCount=0) ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	switch (FunctionType) {"
	..s:((myCaseType'=myDLLFunctionTyp)&&(myCaseType="")) ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	case """_myDLLFunctionTyp_""":"
	..i ((myCaseType'=myDLLFunctionTyp)&(myCaseType'="")) d
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="		}"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="		break;"
	...;s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			}"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	case """_myDLLFunctionTyp_""":"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="		switch (CardType) {"
	..s myCaseType=myDLLFunctionTyp
	..s:(+myCount=0) ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="		switch (CardType) {"
	..s myCount=+myCount+1
	..s myData=^DHCCARDHARDCOM("MANAGER", myMRowID, "FUN", myFunSub)
	..s myInParaStr=""
	..s myDLLFunctionNam=$p(myData,"^",1)		;CDF_DLLFunctionName
	..s myDLLInPara1=$p(myData,"^",2)
	..s:(myDLLInPara1'="") myInParaStr="InPara1"
	..s myDLLInPara2=$p(myData,"^",3)
	..s:(myDLLInPara2'="") myInParaStr=myInParaStr_", InPara2"
	..s myDLLInPara3=$p(myData,"^",4)
	..s:(myDLLInPara3'="") myInParaStr=myInParaStr_", InPara3"
	..s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="		case """_myMRowID_""":"
	..;对于本地服务,支持chrome,和IE直接使用ActiveX的调用有差异
	..i myDllType="LS" d
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			if ("_myObjectID_")"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			{"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="				myrtn = "_myObjectID_"."_myDLLFunctionNam_"("_myInParaStr_")"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="				if (typeof myrtn=='object') {var myrtnJson=myrtn;myrtn = myrtnJson.rtn;}"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			}"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			break;"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			"
	..e  d
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			var myobj=document.getElementById("""_myObjectID_""");"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			if (myobj)"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			{"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="				myrtn = myobj."_myDLLFunctionNam_"("_myInParaStr_")"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			}"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			break;"
	...s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="			"
	..s myHaveFlag=1
	
	i (+myHaveFlag=1){
		s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="		}"
		s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="		break;"
		s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="	}"
	}
	
	s ^TMPFunStr($j,$o(^TMPFunStr(($j),""),-1)+1)="		}catch(e){console.log('读卡调用异常,错误信息：e.message')}"
	
	q myHaveFlag
}

ClassMethod GetByComDll(MRowID) As %String
{
	n (MRowID)
	s myMRowID=MRowID
	s myClassID=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",4)		;CCM_CLASSID
	q:(myClassID="")
	s myObjectID=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",5)		;CCM_OBJECTID
	q:(myObjectID="")
	q:(+$d(^TMPDHCCLSSID($j,myClassID, myObjectID))'=0)
	s ^TMPDHCCLSSID($j,myClassID, myObjectID)=""
	
	s myVersion=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",6)	;CCM_Version
	
	s myCodeBase=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",7)	;CCM_CodeBase
	s myPort=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",8)	;CCM_EquipPort
	
	w "<OBJECT ID='"_myObjectID_"' WIDTH=0 HEIGHT=0 CLASSID='CLSID:"_myClassID_"' CODEBASE='"_myCodeBase_"#version="_myVersion_"' VIEWASTEXT style=""display:none;"">"
	w "</object>",!
}

ClassMethod GetByNetDLL(MRowID) As %String
{
	n (MRowID)
	
	w "<object id='CPMReport' name='CPMReport' classid='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetFormURL() _ "ReportReview.dll#DHCCPM.ReportReview.CPMClientPrint' Width='0' Height='0' VIEWASTEXT>",!
	w "<param name='URL' value='" _ ##class(DHCCPMWeb.CPMBL.ServerConfig).GetServiceURL() _ "'>",!
	w "</object>",!
}

ClassMethod GetByJar() As %String
{
}

/// 得到单一设备的RowID,提供给界面使用
ClassMethod GetSingleEquipDR(HardGroupType As %String) As %String
{
	;初始化读卡设备类接口
	;把同一个分组的设备函数写在一个函数中
	;w ##class(web.UDHCCardCommLinkRegister).GetSingleEquipDR("SQ")
	;还要细分其他的类型
	;n (HardGroupType)
	
	;^DHCCARDHARDCOM("GROUP",{CCG_RowID})
	;^DHCCARDHARDCOMi("GROUP",0,{CCG_Type},{CCG_RowID})
	
	q:(HardGroupType="") ""
	s myGRowID=$o(^DHCCARDHARDCOMi("GROUP",0,HardGroupType,0))
	
	q:(myGRowID="") ""
	
	s myHaveFlag=0
	;JS函数名称
	
	s myCount=0
	;^DHCCARDHARDCOMi("MANAGER",0,"CG",{CCM_ComGroup_DR},{CCM_RowID})
	s myEquipDR=0
	s myMRowID=0
	f  s myMRowID=$o(^DHCCARDHARDCOMi("MANAGER",0,"CG",myGRowID,myMRowID))  q:(myMRowID="")  d
	.;^DHCCARDHARDCOM("MANAGER",{CCM_RowID})
	.s myDateTo=+$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",15)
	.q:((+myDateTo'=0)&&(myDateTo<+$h))
	.s myDllType=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",16)		;CTD_DLLType
	.i +myEquipDR=0 d
	..s myEquipDR=myMRowID
	
	q myEquipDR
}

ClassMethod KillTMP() As %String
{
	k ^TMPDHCCLSSID($j)
	k ^TMPDHCCLASSFun($j)
	k ^TMPFunStr($j)
}

ClassMethod ReadHardComListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadHardComListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TestInsertDLLFun()
{
	;d ##class(web.UDHCCardCommLinkRegister).TestInsertDLLFun()
	k PLIST
	;d ##class(web.UDHCCardHardDLLFunction).SELECT("1||2")
	s PLIST(0)="3"
	s PLIST(3)="CommWrite"
	s PLIST(4)="RWType"
	s PLIST(7)="R"
	b
	;d ##class(web.UDHCCardHardDLLFunction).UPDATE("1||2")
	d ##class(web.UDHCCardHardDLLFunction).INSERT()
	b
}

ClassMethod ReadHardComListExecute(ByRef qHandle As %Binary, HardGroupType As %String, ExpStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	b
	;d ##class(%ResultSet).RunQuery("web.UDHCCardCommLinkRegister","ReadHardComList","IE","")
	i (HardGroupType=""){
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	
	s myGRowID=$o(^DHCCARDHARDCOMi("GROUP",0,HardGroupType,0))
	
	i (myGRowID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s myHaveFlag=0
	;JS函数名称
	s myMDesc=""
	
	s myCount=0
	;^DHCCARDHARDCOMi("MANAGER",0,"CG",{CCM_ComGroup_DR},{CCM_RowID})
	s myMRowID=0
	f  s myMRowID=$o(^DHCCARDHARDCOMi("MANAGER",0,"CG",myGRowID,myMRowID))  q:(myMRowID="")  d
	.;^DHCCARDHARDCOM("MANAGER",{CCM_RowID})
	.s myDateTo=+$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",15)
	.q:((+myDateTo'=0)&&(myDateTo<+$h))
	.s myDllType=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",16)		;CTD_DLLType
	.b	;;CD
	.s myMDesc=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",2)
	.Do OutputRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(myMRowID, myMDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod TestINsertData()
{
	;d ##class(web.UDHCCardCommLinkRegister).TestINsertData()
	k PLIST
	s PLIST(2)="ICCard"
	s PLIST(3)="IC4442卡"
	s PLIST(4)="1"			;GroupType
	s PLIST(5)="F30DC1D4-5E29-4B89-902F-2E3DC81AE46E"
	s PLIST(6)="ClsIC442"
	s PLIST(7)="1,0,0,1"
	s PLIST(8)="../addins/client/DHCOPPrint.CAB"
	s PLIST(9)="0"			;Com Port
	s PLIST(10)="JSFunctionName"
	s PLIST(11)="CommPrint"
	s PLIST(12)="RWType"
	s PLIST(13)=""
	s PLIST(14)=""
	s PLIST(15)=..%SysDate()
	s PLIST(17)="CD"
	
	
	;w "<object ID='' WIDTH=0 HEIGHT=0 CLASSID='CLSID:' CODEBASE='#version=' VIEWASTEXT>"
	;w "</object>",!
	d ##class(web.UDHCCardHardComManager).INSERT()
	
	b
}

ClassMethod ReadHardComListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadHardComListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ReadHardComList(HardGroupType As %String, ExpStr As %String) As %Query(ROWSPEC = "HGRowID:%String,HGDesc:%String")
{
}

/// w ##class(web.UDHCCardCommLinkRegister).GetReadHardComList("IE","")
ClassMethod GetReadHardComList(HardGroupType As %String, ExpStr As %String) As %String
{
	s json="[",index=1
	Set rset=##class(%ResultSet).%New("web.UDHCCardCommLinkRegister.ReadHardComList")
	d rset.Execute(HardGroupType,ExpStr)
	While (rset.Next()) {
		s OneJsonData="{""HGRowID"":"""_rset.Data("HGRowID")_""",""HGDesc"":"""_rset.Data("HGDesc")_""""_"}"
		i index=1 {
			s json=json_OneJsonData
		}else{
			s json=json_","_OneJsonData
		}
		s index=index+1
        
	}
	d rset.Close()
	s json=json_"]"  
	q json
}

/// 初始化加载读卡相关元素
/// medStepCode 诊疗环节，相关代码如下
/// 	CardReg:门诊建档,CardManage:卡管理,AdmQuery:就诊查询,OPAdmReg:挂号/预约,Update:修改患者信息,
/// 	Triage:分诊,Diag:诊断,Order:开方,Cure:治疗,InPatReg:住院建档,InAdmReg:入院登记,PrintBill:打印票据和清单,
/// 	Bill:收费,Disp:取药/发药,CMReturn:草药退药,CMDisp:草药发药,PY:配药,Return:退药,NarcRec:毒麻回收,Exam:检查,
/// 	Opera:手术,BlackList:黑名单,PEReg:体检预约,PEBill:体检收费,EMR:电子病历,EMRCopy:病历材料复印,Other:其他
ClassMethod GetCardHardInfo(SessionStr, medStepCode)
{
    w "<input id='ReadAccExpEncrypt' name='InsuPatTypeCheck' type='hidden' value='"_##Class(websys.Page).Encrypt($lb("web.UDHCAccManageCLSIF.getaccinfofromcardno"))_"'>",$C(13,10)
	w "<input id='ReadCardTypeEncrypt' name='ReadCardTypeEncrypt' type='hidden' value='"_##Class(websys.Page).Encrypt($lb("web.UDHCOPOtherLB.ReadCardTypeDefineListBroker"))_"'>",$C(13,10)
	w "<input id='GetCardTypeEncrypt' name='GetCardTypeEncrypt' type='hidden' value='"_##Class(websys.Page).Encrypt($lb("DHCDoc.OPDoc.PatientList.GessCardType"))_"'>",$C(13,10)
	d ##class(web.UDHCCardCommLinkRegister).GetCardHardJSFunction()

	s flag=##class(%Dictionary.MethodDefinition).%ExistsId("DHCDoc.Interface.AccessManage"_"||"_"LoadJS")
    i (flag=1) {
		i (SessionStr="") s SessionStr=##class(DHCDoc.Util.RegisteredObject).%SessionStr()
		i (medStepCode="") s medStepCode="Other"
		d ##class(DHCDoc.Interface.AccessManage).LoadJS(SessionStr,"Card",medStepCode)
	}
	
    q ""
}

}
