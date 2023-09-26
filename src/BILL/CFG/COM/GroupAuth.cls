/// 名称: BILL.CFG.COM.GroupAuth.cls
/// 描述: 安全组功能授权配置类
/// 编写者: ZhYW
/// 编写日期: 2020-05-20
/// 产品组：计费医保组
Class BILL.CFG.COM.GroupAuth Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 查询安全组
/// Input: hospId: CT_Hospital.RowId
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GroupAuth","QuerySSGroup","2", "demo")
Query QuerySSGroup(hospId As %String, desc As %String) As websys.Query(ROWSPEC = "id:%String:ID,text:%String:安全组")
{
}

ClassMethod QuerySSGroupExecute(ByRef qHandle As %Binary, hospId As %String, desc As %String) As %Status
{
	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set rowId=0
	while($o(^SSU("SSGRP",rowId))) {
		set rowId=$o(^SSU("SSGRP",rowId))
		set grpData=$g(^SSU("SSGRP",rowId))
		continue:(grpData="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_Group", rowId, hospId)
		continue:(showFlag="N")
		set isActive=$p(grpData,"^",151)
		continue:(isActive="N")
		set grpDesc=$p(grpData,"^",1)
		continue:((desc'="")&&($zcvt(grpDesc,"U")'[$zcvt(desc,"U")))
		do OutputSSGroup
	}
	quit $$$OK
	
OutputSSGroup
	set Data=$lb(rowId,grpDesc)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GroupAuth","InitListObjectValue","User.DHCOPGroupSettings","GSUseINVType")
Query InitListObjectValue(ClsName As %String, PropName As %String) As websys.Query(ROWSPEC = "ValueList:%String,DisplayValue:%String")
{
}

ClassMethod InitListObjectValueExecute(ByRef qHandle As %Binary, ClsName As %String, PropName As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set myobj=##class(%Dictionary.CompiledClass).%OpenId(ClsName, 0)
	set myCount=myobj.Properties.Count()
	set myParList=""
	for i=1:1:myCount {
		set mypropobj=myobj.Properties.GetAt(i)
		if (mypropobj.Name=PropName) {
			set myParList=mypropobj.Parameters
			quit
		}
	}
	set myDisList=myParList.GetAt("DISPLAYLIST")
	set myValList=myParList.GetAt("VALUELIST")
	do mypropobj.%Close()
	do myobj.%Close()
	
	for i=1:1:$l(myDisList,",") {
		set myDisValue=$p(myDisList,",",i)
		set myValue=$p(myValList,",",i)
		do OutputLObj
	}

	quit $$$OK
	
OutputLObj
	set Data=$lb(myValue,myDisValue)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 获取安全组功能配置数据(json)
/// Table: DHC_OPGroupSettings
/// Input: groupId:SS_Group.RowId, hospId:CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).GetGSCfgInfo("122","2")
ClassMethod GetGSCfgInfo(groupId As %String, hospId As %String) As %String
{
	set myGSRowID=..GetGSRowID(groupId, hospId)	
	quit ##class(web.DHCBillCommon).GetClsPropValById("User.DHCOPGroupSettings", myGSRowID)
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 保存安全组功能配置数据
/// Table: DHC_OPGroupSettings
/// Input: groupId:SS_Group.RowId, hospId:CT_Hospital.RowId
/// Return: DHCOPGroupSettings.RowId
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).UpdateGS("238","2","Y^Y^Y^Y^INVPrtFlag2007^INVPrtFlagCPP22^O^^N^N^0^1^1")
ClassMethod UpdateGS(groupId As %String, hospId As %String, gsStr As %String) As %String
{
	set $zt="ERROR"
	set myGSRowID=..GetGSRowID(groupId, hospId)

	ts
	
	if (+myGSRowID'=0) {
		set dataObj=##class(User.DHCOPGroupSettings).%OpenId(myGSRowID, 0)
	}else {
		set dataObj=##class(User.DHCOPGroupSettings).%New()
	}
	set dataObj.GSFootFlag=$p(gsStr,"^",1)               //GS_FootFlag
	set dataObj.GSPrtINVFlag=$p(gsStr,"^",2)             //GS_PrtINVFlag
	set dataObj.GSAbortFlag=$p(gsStr,"^",3)              //GS_AbortFlag
	set dataObj.GSRefundFlag=$p(gsStr,"^",4)		     //GS_RefundFlag
	do dataObj.GSSSGroupDRSetObjectId(groupId)		     //GS_SSGroup_DR
	set dataObj.GSPrtXMLName=$p(gsStr,"^",5)		     //GS_PrtXMLName
	set dataObj.GSColPrtXMLName=$p(gsStr,"^",6)		     //GS_ColPrtXMLName
	set dataObj.GSUseINVType=$p(gsStr,"^",7)		     //GS_UseINVType
	set dataObj.GSInputOrdFlag=$p(gsStr,"^",8)		     //GS_InputOrdFlag
	set dataObj.GSPrtListFlag=$p(gsStr,"^",9)		     //GS_PrtListFlag
	set dataObj.GSColPrtListFlag=$p(gsStr,"^",10)        //GS_ColPrtListFlag
	set dataObj.GSCardPayModeFlag=$p(gsStr,"^",11)		 //GS_CardPayModeFlag
	set dataObj.GSReceiveFlag=$p(gsStr,"^",12)		     //GS_ReceiveFlag  +2018-05-18 ZhYW 日结汇总需要接收标识
	set dataObj.GSRegBillFlag=$p(gsStr,"^",13)		     //GS_RegBillFlag  +2018-05-31 ZhYW 挂号医嘱跟收费医嘱一起结算?
	set dataObj.GSPrtEINVFlag=$p(gsStr,"^",14)           //GS_PrtEINVFlag
	do dataObj.GSHospDRSetObjectId(hospId)		         //GS_SSGroup_DR
	set sc=dataObj.%Save()
	set GSRowID=dataObj.%Id()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc
	
	quit 0

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 获取安全组功能配置RowId
/// Table: DHC_OPGroupSettings
/// Input: groupId:SS_Group.RowId, hospId:CT_Hospital.RowId
/// Return: DHCOPGroupSettings.RowId
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).GetGSRowID(122, 2)
ClassMethod GetGSRowID(groupId As %String, hospId As %String) As %String
{
	set gsCfgId=""
	set rowId=0
	while($o(^DHCOPGSi("GS",0,"GSDR",groupId,rowId))) {
		set rowId=$o(^DHCOPGSi("GS",0,"GSDR",groupId,rowId))
		set hospDR=$p($g(^DHCOPGS("GS",rowId)),"^",33)
		continue:(hospDR'=hospId)
		set gsCfgId=rowId
		quit
	}
	
	quit gsCfgId
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 查询安全组配置的支付方式
/// Table: DHC_OPGSPayMode
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GroupAuth","ReadPMConfig","1", 2)
Query ReadPMConfig(groupId As %String, hospId As %String) As websys.Query(ROWSPEC = "CTPMRowID:%String,CTPMCode:%String,CTPMDesc:%String,PMRowID:%String,DefFlag:%String,RPFlag:%String,INVPrtFlag:%String,PMPDFlag:%String,PMOPCFlag:%String,PMOPRegFlag:%String,PMOPRefundFlag:%String,PMSequence:%String,PMHotKey:%String,PMIconCls:%String,PMObsChgFlag:%String,PMDEPRefundFlag:%String")
{
}

ClassMethod ReadPMConfigExecute(ByRef qHandle As %Binary, groupId As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set myGSRowID=..GetGSRowID(groupId, hospId)
	
	set myCTPMRowID=0
	while($o(^CT("CTPM",myCTPMRowID))) {
		set myCTPMRowID=$o(^CT("CTPM",myCTPMRowID))
		set myCTPMData=$g(^CT("CTPM",myCTPMRowID))
		do InitPMCfg
		set myCTPMCode=$p(myCTPMData,"^",1)
		set myCTPMDesc=$p(myCTPMData,"^",2)
		set myCTPMDateFrom=$p(myCTPMData,"^",5)
		set myCTPMDateTo=$p(myCTPMData,"^",6)
		continue:((myCTPMDateFrom'="")&&(myCTPMDateFrom>+$h))
		continue:((myCTPMDateTo'="")&&(myCTPMDateTo<+$h))
		if (myGSRowID'="") {
			set myPMSub=0
			while($o(^DHCOPGSi("GS",0,"CTPMDR",myCTPMRowID,myGSRowID,"PM",myPMSub))) {
				set myPMSub=$o(^DHCOPGSi("GS",0,"CTPMDR",myCTPMRowID,myGSRowID,"PM",myPMSub))
				set myGSPMData=$g(^DHCOPGS("GS",myGSRowID,"PM",myPMSub))
				continue:(myGSPMData="")
				set myPMRowID=myGSRowID_"||"_myPMSub
				set myDefFlag=$p(myGSPMData,"^",4)
				set myINVPrtFlag=$p(myGSPMData,"^",5)
				set myRPFlag=$p(myGSPMData,"^",6)
				set myPMPDFlag=$p(myGSPMData,"^",7)          //预交金
				set myPMOPCFlag=$p(myGSPMData,"^",8)         //收费
				set myPMOPRegFlag=$p(myGSPMData,"^",9)       //挂号
				set myPMOPRefundFlag=$p(myGSPMData,"^",10)   //退费
				set myPMSequence=$p(myGSPMData,"^",11)       //顺序号
				set myPMHotKey=$p(myGSPMData,"^",12)         //快捷键
				set myPMIconCls=$p(myGSPMData,"^",13)        //图标
				set myObsChgFlag=$p(myGSPMData,"^",14)       //急诊留观收费
				set myPMDepRefundFlag=$p(myGSPMData,"^",15)   //退预交金
			}
		}
		do OutputPMCfg
	}
	
	quit $$$OK
	
OutputPMCfg
	set Data=$lb(myCTPMRowID,myCTPMCode,myCTPMDesc,myPMRowID,myDefFlag,myRPFlag,myINVPrtFlag,myPMPDFlag,myPMOPCFlag,myPMOPRegFlag,myPMOPRefundFlag,myPMSequence,myPMHotKey,myPMIconCls,myObsChgFlag,myPMDepRefundFlag)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
InitPMCfg
	set (myCTPMCode, myCTPMDesc, myPMRowID)=""
	set myDefFlag="N"
	set myRPFlag="N"
	set myINVPrtFlag="Y"
	set myPMPDFlag="N"
	set myPMOPCFlag="N"
	set myPMOPRegFlag="N"
	set myPMOPRefundFlag="N"
	set myPMSequence=""
	set myPMHotKey=""
	set myPMIconCls=""
	set myObsChgFlag="N"
	set myPMDepRefundFlag="N"
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 保存DHC_OPGSPayMode数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).UpdateGSPM("122","2","1^99||1^Y^Y^N^Y^Y^Y^Y"_$c(2)_"2^99||2^N^Y^Y^Y^Y^N^Y"_$c(2)_"3^99||3^N^Y^N^N^Y^Y^Y"_$c(2)_"4^99||4^N^Y^N^Y^Y^Y^Y"_$c(2)_"6^99||5^N^Y^N^N^N^N^N"_$c(2)_"11^99||7^N^N^N^N^Y^N^N"_$c(2)_"12^99||8^N^Y^N^N^Y^N^Y"_$c(2)_"28^99||18^N^Y^N^N^N^N^N"_$c(2)_"33^99||10^N^Y^N^N^N^N^Y"_$c(2)_"43^99||11^N^Y^N^N^N^N^N"_$c(2)_"44^99||12^N^Y^N^N^N^N^N")
ClassMethod UpdateGSPM(groupId As %String, hospId As %String, gsPMStr As %String) As %String
{
	set ^TMP("UpdateGSPM")=$lb(groupId, hospId, gsPMStr)
	set $zt="ERROR"
	set rtn=0
	quit:(+groupId=0) -1_"^"_"参数错误"
	
	set myGSRowID=..GetGSRowID(groupId, hospId)
	
	ts
	
	if (myGSRowID="") {
		set objectGS=##class(User.DHCOPGroupSettings).%New()
		do objectGS.GSSSGroupDRSetObjectId(groupId)		    //GS_SSGroup_DR
		do objectGS.GSHospDRSetObjectId(hospId)		         //GS_SSGroup_DR
		set sc=objectGS.%Save()
		set myGSRowID=objectGS.%Id()
		do objectGS.%Close()
		if $$$ISERR(sc) {
			tro
			quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
		}
	}
	
	set myStr=""
	for i=1:1:$l(gsPMStr,$c(2)) {
		set myPMInfo=$p(gsPMStr,$c(2),i)
		set myPMID=$p(myPMInfo,"^",1)
		continue:(myPMID="")
		set myGMID=$p(myPMInfo,"^",2)	        //PM_RowID
		if (myGMID'="") {
			set objectGPM=##class(User.DHCOPGSPayMode).%OpenId(myGMID, 0)
		}else {
			set objectGPM=##class(User.DHCOPGSPayMode).%New(myGSRowID)
		}
		do objectGPM.GSPMParRefSetObjectId(myGSRowID)
		do objectGPM.PMCTPMDRSetObjectId(myPMID)
		set objectGPM.PMDefaultFlag=$p(myPMInfo,"^",3)	    //PM_DefaultFlag
		set objectGPM.PMINVPrtFlag=$p(myPMInfo,"^",4)		//PM_INVPrtFlag
		set objectGPM.PMRPFlag=$p(myPMInfo,"^",5)		    //PM_RPFlag
		set objectGPM.PMNote1=$p(myPMInfo,"^",6)		    //PM_Note1
		set objectGPM.PMNote2=$p(myPMInfo,"^",7)            //PM_Note2
		set objectGPM.PMNote3=$p(myPMInfo,"^",8)		    //PM_Note3
		set objectGPM.PMNote4=$p(myPMInfo,"^",9)		    //PM_Note4
		set objectGPM.PMSequence=$p(myPMInfo,"^",10)		//PM_Sequence
		set objectGPM.PMHotKey=$p(myPMInfo,"^",11)		    //PM_HotKey
		set objectGPM.PMIconCls=$p(myPMInfo,"^",12)		    //PM_IconCls
		set objectGPM.PMObsChg=$p(myPMInfo,"^",13)          //PM_ObsChg
		set objectGPM.PMDepRefund=$p(myPMInfo,"^",14)       //PM_DepRefund
		set sc=objectGPM.%Save()
		set GPMRowID=objectGPM.%Id()
		do objectGPM.%Close()
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
		set myStr=$s((myStr=""):GPMRowID,1:(myStr_"^"_GPMRowID))
	}
	if (+rtn) tro  quit rtn
	
	//Delete not use PM
	set mySub=0
	while($o(^DHCOPGS("GS",myGSRowID,"PM",mySub))) {
		set mySub=$o(^DHCOPGS("GS",myGSRowID,"PM",mySub))
		set myGMRowID=myGSRowID_"||"_mySub
		continue:(("^"_myStr_"^")[("^"_myGMRowID_"^"))
		set sc=##class(User.DHCOPGSPayMode).%DeleteId(myGMRowID)
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc

	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 取科室
/// Input: hospId: CT_Hospital.RowId
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GroupAuth","ReadLoc",2)
Query ReadLoc(hospId As %String) As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod ReadLocExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set id=0
	while($o(^CTLOC(0,"Hosp",hospId,id))) {
		set id=$o(^CTLOC(0,"Hosp",hospId,id))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", id, hospId)
		continue:(showFlag="N")
		set locData=$g(^CTLOC(id))
		continue:(locData="")
		set wardFlag=$p(locData,"^",5)
		continue:(wardFlag="Y")
		set desc=$p(locData,"^",2)
		do OutputLoc
	}
	quit $$$OK
	
OutputLoc
	set Data=$lb(id,desc)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 取安全组配置的接收科室列表
/// Input:  groupId: SS_Group.RowId
///         hospId: CT_Hospital.RowId
/// 		logonLocId: CT_Loc.RowId
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GroupAuth","ReadSelRecLocList",122,"")
Query ReadSelRecLocList(groupId As %String, hospId As %String, logonLocId As %String) As websys.Query(ROWSPEC = "id:%String,code:%String,desc:%String,rlRowId:%String,selected:%Boolean")
{
}

ClassMethod ReadSelRecLocListExecute(ByRef qHandle As %Binary, groupId As %String, hospId As %String, logonLocId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("ReadSelRecLocList")=$lb(groupId, hospId, logonLocId)
	if (+groupId=0) quit $$$OK
	
	set myGSRowID=..GetGSRowID(groupId, hospId)
	
	kill ^||TMPRL($j)
	if (myGSRowID'="") {
		set myLStr=..ReadRLByGPLoc(myGSRowID, logonLocId)
		set myRecLocIdStr=$p(myLStr,$c(2),1)
		set myRLIdStr=$p(myLStr,$c(2),2)
		for i=1:1:$l(myRecLocIdStr,"^") {
			set myRecRowID=$p(myRecLocIdStr,"^",i)
			continue:(+myRecRowID=0)
			set myRLRowID=$p(myRLIdStr,"^",i)
			set ^||TMPRL($j,myRecRowID)=myRLRowID
		}
	}
	
	kill ^||TMPLOC($j)
	set id=0
	while($o(^CTLOC(0,"Hosp",hospId,id))) {
		set id=$o(^CTLOC(0,"Hosp",hospId,id))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", id, hospId)
		continue:(showFlag="N")
		set locData=$g(^CTLOC(id))
		continue:(locData="")
		set wardFlag=$p(locData,"^",5)
		continue:(wardFlag="Y")
		set myRLRowID=$g(^||TMPRL($j,id))
		if (+myRLRowID'=0) {
			set ^||TMPLOC($j,1,id)=myRLRowID
		}else {
			set ^||TMPLOC($j,2,id)=""
		}
	}
	
	//按选中科室排序
	set seq=0
	while($o(^||TMPLOC($j,seq))'="") {
		set seq=$o(^||TMPLOC($j,seq))
		quit:(seq="")
		set id=0
		while($o(^||TMPLOC($j,seq,id))'="") {
			set id=$o(^||TMPLOC($j,seq,id))
			set locData=$g(^CTLOC(id))
			continue:(locData="")
			set code=$p(locData,"^",1)
			set desc=$p(locData,"^",2)
			set rlRowId=$g(^||TMPLOC($j,seq,id))
			set selected=$s((+rlRowId'=0):"true",1:"false")
			do OutputSelRecLocList
		}
	}
	
	kill ^||TMPRL($j)
	kill ^||TMPLOC($j)
	
	quit $$$OK
	
OutputSelRecLocList
	set Data=$lb(id,code,desc,rlRowId,selected)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

ClassMethod ReadRLByGPLoc(GSRowID As %String, LoadLocRowID As %String) As %String
{
	set myRecStr=""
	set myGRStr=""
	set mySub=0
	while($o(^DHCOPGS("GS",GSRowID,"RL",mySub))) {
		set mySub=$o(^DHCOPGS("GS",GSRowID,"RL",mySub))
		set myGRLInfo=$g(^DHCOPGS("GS",GSRowID,"RL",mySub))
		continue:(myGRLInfo="")
		set myGRLID=GSRowID_"||"_mySub
		set myActFlag=$p(myGRLInfo,"^",4)
		continue:(myActFlag="N")
		set myloadLoc=$p(myGRLInfo,"^",5)
		continue:(myloadLoc'=LoadLocRowID)
		set myRecLoc=$p(myGRLInfo,"^",1)
		set myRecStr=myRecLoc_"^"_myRecStr
		set myGRStr=myGRLID_"^"_myGRStr
	}
	
	set rtn=myRecStr_$c(2)_myGRStr
	quit rtn
}

/// Debug: w ##class(BILL.CFG.COM.GroupAuth).UpdateGSRL("122","N","","")
ClassMethod UpdateGSRL(groupId As %String, hospId As %String, recLocFlag As %String, logonLocId As %String, gsRLStr As %String) As %String
{
	set ^TMP("UpdateGSRL")=$lb(groupId, hospId, recLocFlag, logonLocId, gsRLStr)
	set $zt="ERROR"
	set rtn=0
	quit:(+groupId=0) -1_"^"_"参数错误"
	quit:((gsRLStr'="")&&(logonLocId="")) -1_"^"_"参数错误"
	
	set myGSRowID=..GetGSRowID(groupId, hospId)
	
	ts
	
	if (myGSRowID="") {
		set objectGS=##class(User.DHCOPGroupSettings).%New()
		do objectGS.GSSSGroupDRSetObjectId(groupId)		    //GS_SSGroup_DR
		do objectGS.GSHospDRSetObjectId(hospId)		        //GS_SSGroup_DR
		set sc=objectGS.%Save()
		set myGSRowID=objectGS.%Id()
		do objectGS.%Close()
		if $$$ISERR(sc) {
			tro
			quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetEGetErrorText(sc)
		}
	}
	
	set objectGS=##class(User.DHCOPGroupSettings).%OpenId(myGSRowID, 0)
	set objectGS.GSRecLocFlag=recLocFlag
	set sc=objectGS.%Save()
	do objectGS.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetEGetErrorText(sc)
	}
	
	set myStr=""
	for i=1:1:$l(gsRLStr,$c(2)) {
		set myRLInfo=$p(gsRLStr,$c(2),i)
		continue:(myRLInfo="")
		set myLocID=$p(myRLInfo,"^",1)
		continue:(myLocID="")
		set myRLID=$p(myRLInfo,"^",2)	        //PM_RowID
		if (myRLID'="") {
			set objectGRL=##class(User.DHCOPGSRecLoc).%OpenId(myRLID, 0)
		}else {
			set objectGRL=##class(User.DHCOPGSRecLoc).%New(myGSRowID)
		}
		do objectGRL.GSRLParRefSetObjectId(myGSRowID)
		do objectGRL.RLRecLocDRSetObjectId(myLocID)
		set objectGRL.RLActiveFlag="Y"	                    //RL_ActiveFlag
		do objectGRL.RLLoadLocDRSetObjectId(logonLocId)		//RL_LoadLoc_DR
		set sc=objectGRL.%Save()
		set GRLRowID=objectGRL.%Id()
		do objectGRL.%Close()
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetEGetErrorText(sc)
			quit
		}
		set myStr=$s((myStr=""):GRLRowID,1:(myStr_"^"_GRLRowID))
	}
	if (+rtn) tro  quit rtn
	
	//delete not use RL
	if (logonLocId'="") {
		set mySub=0
		while($o(^DHCOPGSi("GS",0,"LRDR",logonLocId,myGSRowID,"RL",mySub))&&(+rtn=0)) {
			set mySub=$o(^DHCOPGSi("GS",0,"LRDR",logonLocId,myGSRowID,"RL",mySub))
			set myGRLRowID=myGSRowID_"||"_mySub
			continue:(("^"_myStr_"^")[("^"_myGRLRowID_"^"))
			set sc=##class(User.DHCOPGSRecLoc).%DeleteId(myGRLRowID)
			if $$$ISERR(sc) {
				set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetEGetErrorText(sc)
				quit
			}
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 取安全组配置的打印单据列表
/// Input:  groupId: SS_Group.RowId
///         hospId: CT_Hospital.RowId
/// 		taskType: CT_Loc.RowId
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GroupAuth","ReadGSPrtList","238","2","CP")
Query ReadGSPrtList(groupId As %String, hospId As %String, taskType As %String) As websys.Query(ROWSPEC = "GSPTRowID:%String,PrtXmlName:%String,ClassName:%String,MethodName:%String,TaskType:%String,PrintMode:%String,HardEquipDR:%String,CCMDesc::%String")
{
}

ClassMethod ReadGSPrtListExecute(ByRef qHandle As %Binary, groupId As %String, hospId As %String, taskType As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set ^TMP("ReadGSPrtList")=$lb(groupId, hospId, taskType)
	if (+groupId=0) quit $$$OK
	
	set myGSRowID=..GetGSRowID(groupId, hospId)
	if (+myGSRowID=0) quit $$$OK
	
	set myPTSub=0
	while($o(^DHCOPGS("GS",myGSRowID,"PT",myPTSub))) {
		set myPTSub=$o(^DHCOPGS("GS",myGSRowID,"PT",myPTSub))
		set myPTData=$g(^DHCOPGS("GS",myGSRowID,"PT",myPTSub))
		continue:(myPTData="")
		set myGSPTRowID=myGSRowID_"||"_myPTSub
		set myTaskType=$p(myPTData,"^",4)
		continue:(myTaskType="")
		set myPrtXmlName=$p(myPTData,"^",1)
		set myClassName=$p(myPTData,"^",2)
		set myMethodName=$p(myPTData,"^",3)
		set myPrintMode=$p(myPTData,"^",5)
		set myHardEquipDR=$p(myPTData,"^",6)
		set myCCMDesc=$s((+myHardEquipDR'=0):$p($g(^DHCCARDHARDCOM("MANAGER",myHardEquipDR)),"^",2),1:"")
		do OutputGSPrtList
	}
	
	quit $$$OK
	
OutputGSPrtList
	set Data=$lb(myGSPTRowID,myPrtXmlName,myClassName,myMethodName,myTaskType,myPrintMode,myHardEquipDR,myCCMDesc)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Description: 新增/更新单据打印列表记录
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).UpdateGSPT("2","2",^TMPXmlData)
ClassMethod UpdateGSPT(groupId As %String, hospId As %String, xmlData As %String) As %String
{
	set ^TMP("UpdateGSPT")=$lb(groupId, hospId)
	set ^TMPXMLData=xmlData
	set $zt="ERROR"
	quit:(xmlData="") -1_"^"_"参数错误"
	
	set myGSRowID=..GetGSRowID(groupId, hospId)
	
	ts
	
	if (myGSRowID="") {
		set objectGS=##class(User.DHCOPGroupSettings).%New()
		do objectGS.GSSSGroupDRSetObjectId(groupId)		     //GS_SSGroup_DR
		do objectGS.GSHospDRSetObjectId(hospId)		         //GS_SSGroup_DR
		set sc=objectGS.%Save()
		set myGSRowID=objectGS.%Id()
		do objectGS.%Close()
		if $$$ISERR(sc) {
			tro
			quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetEGetErrorText(sc)
		}
	}
	
	set PTObj=##class(web.DHCEntity.OPGS.GSPrintTask).%New()
	do PTObj.XMLDeserialize(.PTObj, xmlData)
	if (PTObj.GSPTRowID'="") {
		set objectGPT=##class(User.DHCOPGSPrintTask).%OpenId(PTObj.GSPTRowID, 0)
	}else {
		set objectGPT=##class(User.DHCOPGSPrintTask).%New(myGSRowID)
	}
	do objectGPT.GSPTParRefSetObjectId(myGSRowID)
	set objectGPT.PTPrtXmlName=PTObj.XmlTemplateName
	set objectGPT.PTClassName=PTObj.ClassName
	set objectGPT.PTMethodName=PTObj.MethodName
	set objectGPT.PTTaskType=PTObj.TaskType
	set objectGPT.PTPrintMode=PTObj.PrintMode
	do objectGPT.PTHardEquipDRSetObjectId(PTObj.HardEquipDR)
	set sc=objectGPT.%Save()
	do objectGPT.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetEGetErrorText(sc)
	}	
	do PTObj.%Close()
	
	if ($tl>0) tc

	quit 0

ERROR
	quit ..AppException()
}

/// Description: 删除单据打印列表记录
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).DelGSPT("5||1")
ClassMethod DelGSPT(rowId As %String) As %String
{
	set sc=##class(User.DHCOPGSPrintTask).%DeleteId(rowId)
	if $$$ISERR(sc) {
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetEGetErrorText(sc)
	}
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 获取Tab页签
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GroupAuth","FindGroupTabs", 99)
Query FindGroupTabs(groupId As %String, hospId As %String) As websys.Query(ROWSPEC = "id:%String,title:%String,type:%String,defFlag:%String,tabRowID:%String,gtRowID:%String,checked:%Boolean,_parentId:%String")
{
}

ClassMethod FindGroupTabsExecute(ByRef qHandle As %Binary, groupId As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (+groupId=0) quit $$$OK
	
	set GSRowID=..GetGSRowID(groupId, hospId)
	
	set index=0
	set type=""
	while($o(^DHCBILLTABSi(0,"TYPE",type),-1)'="") {
		set type=$o(^DHCBILLTABSi(0,"TYPE",type),-1)
		do InitGroupTabs
		set id=$i(index)
		set title=..GetTabTitle(type)
		do OutputGroupTabs
		do InitGroupTabs
		set childIndex=0
		set tabRowID=0
		while($o(^DHCBILLTABSi(0,"TYPE",type,tabRowID))) {
			set tabRowID=$o(^DHCBILLTABSi(0,"TYPE",type,tabRowID))
			set tabData=$g(^DHCBILLTABS(tabRowID))
			set isActive=$p(tabData,"^",4)
			continue:(isActive="N")
			set id=index_$i(childIndex)
			set title=$p(tabData,"^",2)
			set gtRowID=$s((+GSRowID'=0):$o(^DHCBILLGROUPSETTABSi(0,"GROUPTABS",GSRowID,tabRowID,0)),1:"")
			set defFlag=$s((+gtRowID'=0):$p(^DHCBILLGROUPSETTABS(gtRowID),"^",3),1:"N")
			set checked=$s((+gtRowID'=0):"true",1:"false")
			set parentId=index
			do OutputGroupTabs
		}
	}
	
	quit $$$OK
InitGroupTabs
	set (id, title, defFlag, tabRowID, gtRowID, checked, parentId)=""
	quit
OutputGroupTabs
	set Data=$lb(id,title,type,defFlag,tabRowID,gtRowID,checked,parentId)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 取Tab页签的title
/// Input: code:业务类型代码
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).GetTabTitle("OPC")
ClassMethod GetTabTitle(code As %String) As %String
{
	quit:(code="") ""
	if ($d(%GetTabTitle($this,code))) quit %GetTabTitle($this,code)
	set json=..GetTabBizTypes()
	set title=json.%Get($zcvt(code,"U"))
	set title=$s((title'=""):title,1:"其他")    //未定义的返回"其他"
	set %GetTabTitle($this,code)=title
	quit title
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Descripiton: 获取页签业务类型
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).GetTabBizTypes()
ClassMethod GetTabBizTypes() As %DynamicObject
{
	set json=##class(%DynamicObject).%New()
	do json.%Set("OPD", "门诊日结")
	do json.%Set("OPC", "门诊日结汇总")
	do json.%Set("OPW", "门诊收费员工作量统计")
	do json.%Set("ESC", "急诊留观结算")
	do json.%Set("IPD", "住院日结")
	do json.%Set("IPC", "住院日结汇总")
	do json.%Set("BOA", "第三方对账平台")
	do json.%Set("IPB", "住院收费")
	do json.%Close()
	quit json
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 授权Tab页签
/// Input: groupId:SS_Group.RowID
/// Return: 
/// Debug:  w ##class(BILL.CFG.COM.GroupAuth).SaveGroupTabs("238","2","323^1^N"_$c(2)_"324^2^N"_$c(2)_"325^3^N"_$c(2)_"318^4^N"_$c(2)_"319^5^N"_$c(2)_"320^6^N"_$c(2)_"321^7^Y"_$c(2)_"322^8^N")
ClassMethod SaveGroupTabs(groupId As %String, hospId As %String, GTStr As %String) As %String
{
	set ^TMP("SaveGroupTabs")=$lb(groupId, hospId, GTStr)
	set $zt="ERROR"
	set rtn=0
	set myGSRowID=..GetGSRowID(groupId, hospId)

	ts
	
	if (myGSRowID="") {
		set objectGS=##class(User.DHCOPGroupSettings).%New()
		do objectGS.GSSSGroupDRSetObjectId(groupId)		    //GS_SSGroup_DR
		do objectGS.GSHospDRSetObjectId(hospId)		        //GS_SSGroup_DR
		set sc=objectGS.%Save()
		set myGSRowID=objectGS.%Id()
		do objectGS.%Close()
		if $$$ISERR(sc) {
			tro
			quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
		}
	}
	
	set myStr=""
	for i=1:1:$l(GTStr,$c(2)) {
		set myGTStr=$p(GTStr,$c(2),i)
		continue:(myGTStr="")
		set myGTRowId=$p(myGTStr,"^",1)
		set myTabRowId=$p(myGTStr,"^",2)
		continue:(+myTabRowId=0)
		set myDefFlag=$p(myGTStr,"^",3)
		if (myGTRowId'="") {
			set objectGT=##class(User.DHCBillGroupSetTabs).%OpenId(myGTRowId, 0)
		}else {
			set objectGT=##class(User.DHCBillGroupSetTabs).%New()
		}
		do objectGT.GTGroupSetDRSetObjectId(myGSRowID)
		do objectGT.GTTabsDRSetObjectId(myTabRowId)
		set objectGT.GTDefaultFlag=myDefFlag
		set sc=objectGT.%Save()
		set GTRowId=objectGT.%Id()
		do objectGT.%Close()
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
		set myStr=$s((myStr=""):GTRowId,1:(myStr_"^"_GTRowId))
	}
	if (+rtn) tro  quit rtn
	
	set myGTRowId=0
	while($o(^DHCBILLGROUPSETTABSi(0,"GROUPSETDR",myGSRowID,myGTRowId))) {
		set myGTRowId=$o(^DHCBILLGROUPSETTABSi(0,"GROUPSETDR",myGSRowID,myGTRowId))
		continue:(("^"_myStr_"^")[("^"_myGTRowId_"^"))
		set sc=##class(User.DHCBillGroupSetTabs).%DeleteId(myGTRowId)
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 获取住院收费菜单列表
/// Input: groupId:SS_Group.RowID, hospId:CT_Hospital.RowID
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GroupAuth","GetMenuList","IPBILLRighty","4","2")
Query GetMenuList(code As %String, groupId As %String, hospId As %String) As websys.Query(ROWSPEC = "rowId:%String,JBMCode:%String,JBMDesc:%String,JBMPage:%String,JBMTarget:%String,JBMParrefDr:%String,JBMActiveFlag:%String,JBMNodeLevel:%String,Select:%String,JBMSequence:%String,JBMIconCls:%String,JBMHandler:%String")
{
}

ClassMethod GetMenuListExecute(ByRef qHandle As %Binary, code As %Binary, groupId As %String, hospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("GetMenuList")=$lb(code, groupId, hospId)
 	set myParref=$o(^DHCJFBM(0,"Code",code,""),-1)
	if (+myParref=0)  quit $$$OK
 	
 	set rowId=0
 	while($o(^DHCJFBM(0,"Parref",myParref,rowId))) {
	 	set rowId=$o(^DHCJFBM(0,"Parref",myParref,rowId))
	 	set data=$g(^DHCJFBM(rowId))
	 	continue:(data="")
	 	set JBMCode=$p(data,"^",1)
		set JBMDesc=$p(data,"^",2)
		set JBMPage=$p(data,"^",3)
		set JBMTarget=$p(data,"^",4)
		set JBMParrefDr=$p(data,"^",5)
		set JBMActiveFlag=$p(data,"^",6)
		set JBMNodeLevel=$p(data,"^",7)
		set JBMSequence=$p(data,"^",9)
		set JBMIconCls=$p(data,"^",10)
		set JBMHandler=$p(data,"^",11)
	 	set grantId=""
	 	set myGGId=0
	 	while($o(^DHCJFMGG(0,"Grp",groupId,"Menu",rowId,myGGId))) {
		 	set myGGId=$o(^DHCJFMGG(0,"Grp",groupId,"Menu",rowId,myGGId))
		 	set myGGData=$g(^DHCJFMGG(myGGId))
		 	set myHospDR=$p(myGGData,"^",4)
		 	continue:(myHospDR'=hospId)
		 	set grantId=myGGId
		 	quit
		}
		set Select=(+grantId'=0)
		do OutputMenuList
	}
	
	quit $$$OK

OutputMenuList
	set Data=$lb(rowId,JBMCode,JBMDesc,JBMPage,JBMTarget,JBMParrefDr,JBMActiveFlag,JBMNodeLevel,Select,JBMSequence,JBMIconCls,JBMHandler)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Debug: w ##class(BILL.CFG.COM.GroupAuth).GetMenuInfo(7,"DHCIPBILL")
ClassMethod GetMenuInfo(rowId As %String, code As %String) As %String
{
	if (rowId="") {
		set rowId=$o(^DHCJFBM(0,"Code",code,""))
	}
	
	quit:(rowId="") "-1^^^^^^^^^^^"
	quit:'$d(^DHCJFBM(rowId)) "-1^^^^^^^^^^^"
	
	set dataObj=##class(User.DHCJFBILLMENU).%OpenId(rowId, 0)
	set JBMCode=dataObj.JBMCode
 	set JBMDesc=dataObj.JBMDesc
 	set JBMPage=dataObj.JBMPage
 	set JBMTarget=dataObj.JBMTarget
 	set JBMParrefDr=dataObj.JBMParrefDrGetObjectId()
 	set JBMActiveFlag=dataObj.JBMActiveFlag
 	set JBMNodeLevel=dataObj.JBMNodeLevel
 	
 	set str=0_"^"_rowId_"^"_JBMCode_"^"_JBMDesc_"^"_JBMPage_"^"_JBMTarget_"^"_JBMParrefDr_"^"_JBMActiveFlag_"^"_JBMNodeLevel
 	quit str
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 验证代码是否已存在
/// Input: 
/// Return: 0:不存在, >0:已存在
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).CheckCodeExist(6, "BillRighty")
ClassMethod CheckCodeExist(id As %String, code As %String)
{
	quit:(code="") 0
	set pId=$o(^DHCJFBM(0,"Code",code,0))
	if ((pId'="")&&(pId'=id)) {
		quit pId
	}
	quit 0
}

/// 保存菜单数据
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).SaveMenu("22^BillTool^账单^Y^5^3^^^4^icon-mnypaper-run^billClick")
ClassMethod SaveMenu(menuInfo As %String) As %String
{
	set ^TMP("SaveMenu")=$lb(menuInfo)
	set $zt="ERROR"
	set rowId=$p(menuInfo,"^",1)
	set code=$p(menuInfo,"^",2)
	set desc=$p(menuInfo,"^",3)
	set active=$p(menuInfo,"^",4)
	set parref=$p(menuInfo, "^",5)
	set nodeLevel=$p(menuInfo,"^",6)
	set page=$p(menuInfo,"^",7)
	set target=$p(menuInfo,"^",8)
	set sequence=$p(menuInfo,"^",9)
	set iconCls=$p(menuInfo,"^",10)
	set handler=$p(menuInfo,"^",11)
	if ((code="")||(desc="")) {
		quit -1_"^"_"参数错误"
	}
	
	ts
	
	if (rowId'="") {
		set dataObj=##class(User.DHCJFBILLMENU).%OpenId(rowId, 0)
	}else {
		set dataObj=##class(User.DHCJFBILLMENU).%New()
	}
	set dataObj.JBMCode=code
	set dataObj.JBMDesc=desc
	set dataObj.JBMPage=page
	set dataObj.JBMTarget=target
	set dataObj.JBMIsLeaf="Y"
	do dataObj.JBMParrefDrSetObjectId(parref)
	set dataObj.JBMActiveFlag=active
	set dataObj.JBMNodeLevel=nodeLevel 	
	set dataObj.JBMSequence=sequence
	set dataObj.JBMIconCls=iconCls
	set dataObj.JBMHandler=handler
	set sc=dataObj.%Save()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc
	
	quit 0

ERROR
	quit ..AppException()
}

/// Description: 菜单授权
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).GrantMenu("4","2","22^23")
ClassMethod GrantMenu(groupId As %String, hospId As %String, menuStr As %String) As %String
{
	set ^TMP("GrantMenu")=$lb(groupId, hospId, menuStr)
	set $zt="ERROR"
	set rtn=0
	if ((groupId="")||(menuStr="")) {
		quit -1_"^"_"参数错误"
	}
	
	ts
	
	set myGGRowId=0
	while($o(^DHCJFMGG(0,"GrpOnly",groupId,myGGRowId))) {
	 	set myGGRowId=$o(^DHCJFMGG(0,"GrpOnly",groupId,myGGRowId))
	 	set myHospDR=$p($g(^DHCJFMGG(myGGRowId)),"^",4)
	 	continue:(myHospDR'=hospId)
	 	set sc=##class(User.DHCJFMenuGroupGrant).%DeleteId(myGGRowId)
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
	}
	if (+rtn) tro  quit rtn

	for i=1:1:$l(menuStr,"^") {
		set menuId=+$p(menuStr,"^",i)
		continue:((menuId=0)||('$d(^DHCJFBM(menuId))))
		set dataObj=##class(User.DHCJFMenuGroupGrant).%New()
		do dataObj.MGGGrpDRSetObjectId(groupId)
		do dataObj.MGGMenuDRSetObjectId(menuId)
		set dataObj.MGGUseRight="Y"
		do dataObj.MGGHospDRSetObjectId(hospId)
		set sc=dataObj.%Save()
		do dataObj.%Close()
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2020-08-15
/// Description: 查询安全组与押金类型配置数据
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GroupAuth","FindGSDepType")
Query QryGSDepType(groupId As %String, hospId As %String) As websys.Query(ROWSPEC = "DepTypeID:%String,DepTypeDesc:%String,GSCfgID:%String,DefFlag:%String")
{
}

ClassMethod QryGSDepTypeExecute(ByRef qHandle As %Binary, groupId As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set rowId=0
	while($o(^ARC("ARCDT",rowId))) {
		set rowId=$o(^ARC("ARCDT",rowId))
		set desc=$p($g(^ARC("ARCDT",rowId)),"^",2)
		set myGSCfgId=""
		set myDefFlag=""
		set cfgId=0
		while($o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",groupId,cfgId))&&(myGSCfgId="")) {
			set cfgId=$o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",groupId,cfgId))
			set cfgData=$g(^DHCJFSSGRPDEPTYPECONFIG(cfgId))
			set myHospDR=$p(cfgData,"^",6)
			continue:(myHospDR'=hospId)
			set myDepTypeDR=$p(cfgData,"^",2)
			continue:(myDepTypeDR'=rowId)
			set myGSCfgId=cfgId
			set myDefFlag=$p(cfgData,"^",3)
		}
		do OutputDepType
	}
	
	quit $$$OK
OutputDepType 
    set Data=$lb(rowId,desc,myGSCfgId,myDefFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-08-15
/// Description: 保存DHC_JFSSGrpDepTypeConfig数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).UpdateGSDepType("122","2",""_$c(2)_""_$c(2)_""_$c(2)_"4^99||4^N^Y^N^Y^Y^Y^Y"_$c(2)_"6^99||5^N^Y^N^N^N^N^N"_$c(2)_"11^99||7^N^N^N^N^Y^N^N"_$c(2)_"12^99||8^N^Y^N^N^Y^N^Y"_$c(2)_"28^99||18^N^Y^N^N^N^N^N"_$c(2)_"33^99||10^N^Y^N^N^N^N^Y"_$c(2)_"43^99||11^N^Y^N^N^N^N^N"_$c(2)_"44^99||12^N^Y^N^N^N^N^N")
ClassMethod UpdateGSDepType(groupId As %String, hospId As %String, depTypeStr As %String) As %String
{
	set ^TMP("UpdateGSDepType")=$lb(groupId, hospId, depTypeStr)
	set $zt="ERROR"
	set rtn=0
	quit:(+groupId=0) -1_"^"_"参数错误"
	
	ts
	
	set myStr=""
	for i=1:1:$l(depTypeStr,$c(2)) {
		set myDTInfo=$p(depTypeStr,$c(2),i)
		set myDepTypeID=$p(myDTInfo,"^",1)
		set myGRPRowID=$p(myDTInfo,"^",2)
		if (myGRPRowID'="") {
			set objectData=##class(User.DHCJFSSGrpDepTypeConfig).%OpenId(myGRPRowID, 0)
		}else {
			set objectData=##class(User.DHCJFSSGrpDepTypeConfig).%New()
		}
		do objectData.GrpDrSetObjectId(groupId)
		do objectData.GrpDepTypeDrSetObjectId(myDepTypeID)
		set objectData.GrpDefault=$p(myDTInfo,"^",3)	    //Grp_Default
		do objectData.GrpHospDrSetObjectId(hospId)
		set sc=objectData.%Save()
		set GRPRowID=objectData.%Id()
		do objectData.%Close()
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
		set myStr=$s((myStr=""):GRPRowID,1:(myStr_"^"_GRPRowID))
	}
	if (+rtn) tro  quit rtn
	
	//Delete not use
	set cfgId=0
	while($o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",groupId,cfgId))) {
		set cfgId=$o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",groupId,cfgId))
		continue:(("^"_myStr_"^")[("^"_cfgId_"^"))
		set cfgData=$g(^DHCJFSSGRPDEPTYPECONFIG(cfgId))
		set myHospDR=$p(cfgData,"^",6)
		continue:(myHospDR'=hospId)
		set sc=##class(User.DHCJFSSGrpDepTypeConfig).%DeleteId(cfgId)
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc

	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2020-08-15
/// Description: 查询安全组与就诊费别配置数据
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GroupAuth","QryGSAdmReason",2,2)
Query QryGSAdmReason(groupId As %String, hospId As %String) As websys.Query(ROWSPEC = "AdmReaID:%String,AdmReaDesc:%String,GSCfgID:%String,DefFlag:%String")
{
}

ClassMethod QryGSAdmReasonExecute(ByRef qHandle As %Binary, groupId As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set rowId=0
	while($o(^PAC("ADMREA",rowId))) {
		set rowId=$o(^PAC("ADMREA",rowId))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason", rowId, hospId)
		continue:(showFlag="N")
		set admReaData=$g(^PAC("ADMREA",rowId))
		set dateFrom=$p(admReaData,"^",3)
		set dateTo=$p(admReaData,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set desc=$p(admReaData,"^",2)
		set myGSCfgId=""
		set myDefFlag=""
		set cfgId=0
		while($o(^DHCJFSSGRPADMREASONCONFIG(0,"SSGrp",groupId,cfgId))&&(myGSCfgId="")) {
			set cfgId=$o(^DHCJFSSGRPADMREASONCONFIG(0,"SSGrp",groupId,cfgId))
			set cfgData=$g(^DHCJFSSGRPADMREASONCONFIG(cfgId))
			set myHospDR=$p(cfgData,"^",6)
			continue:(myHospDR'=hospId)
			set myAdmReaDR=$p(cfgData,"^",2)
			continue:(myAdmReaDR'=rowId)
			set myGSCfgId=cfgId
			set myDefFlag=$p(cfgData,"^",3)
		}
		do OutputAdmRea
	}
	
	quit $$$OK
OutputAdmRea 
    set Data=$lb(rowId,desc,myGSCfgId,myDefFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-08-15
/// Description: 保存DHC_JFSSGrpDepTypeConfig数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GroupAuth).UpdateGSAdmReason("122","2",""_$c(2)_""_$c(2)_""_$c(2)_"4^99||4^N^Y^N^Y^Y^Y^Y"_$c(2)_"6^99||5^N^Y^N^N^N^N^N"_$c(2)_"11^99||7^N^N^N^N^Y^N^N"_$c(2)_"12^99||8^N^Y^N^N^Y^N^Y"_$c(2)_"28^99||18^N^Y^N^N^N^N^N"_$c(2)_"33^99||10^N^Y^N^N^N^N^Y"_$c(2)_"43^99||11^N^Y^N^N^N^N^N"_$c(2)_"44^99||12^N^Y^N^N^N^N^N")
ClassMethod UpdateGSAdmReason(groupId As %String, hospId As %String, admReasonStr As %String) As %String
{
	set ^TMP("UpdateGSAdmReason")=$lb(groupId, hospId, admReasonStr)
	set $zt="ERROR"
	set rtn=0
	quit:(+groupId=0) -1_"^"_"参数错误"
	
	ts
	
	set myStr=""
	for i=1:1:$l(admReasonStr,$c(2)) {
		set myAdmReaInfo=$p(admReasonStr,$c(2),i)
		set myAdmReaID=$p(myAdmReaInfo,"^",1)
		set myGRPRowID=$p(myAdmReaInfo,"^",2)
		if (myGRPRowID'="") {
			set objectData=##class(User.DHCJFSSGrpAdmReasonConfig).%OpenId(myGRPRowID, 0)
		}else {
			set objectData=##class(User.DHCJFSSGrpAdmReasonConfig).%New()
		}
		do objectData.GrpReaSSGrpDrSetObjectId(groupId)
		do objectData.GrpReaAdmReasonDrSetObjectId(myAdmReaID)
		set objectData.GrpReaDefault=$p(myAdmReaInfo,"^",3)	    //GrpRea_Default
		do objectData.GrpReaHospDrSetObjectId(hospId)
		set sc=objectData.%Save()
		set GRPRowID=objectData.%Id()
		do objectData.%Close()
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
		set myStr=$s((myStr=""):GRPRowID,1:(myStr_"^"_GRPRowID))
	}
	if (+rtn) tro  quit rtn
	
	//Delete not use
	set cfgId=0
	while($o(^DHCJFSSGRPADMREASONCONFIG(0,"SSGrp",groupId,cfgId))) {
		set cfgId=$o(^DHCJFSSGRPADMREASONCONFIG(0,"SSGrp",groupId,cfgId))
		continue:(("^"_myStr_"^")[("^"_cfgId_"^"))
		set cfgData=$g(^DHCJFSSGRPADMREASONCONFIG(cfgId))
		set myHospDR=$p(cfgData,"^",6)
		continue:(myHospDR'=hospId)
		set sc=##class(User.DHCJFSSGrpAdmReasonConfig).%DeleteId(cfgId)
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc

	quit rtn
ERROR
	quit ..AppException()
}

}
