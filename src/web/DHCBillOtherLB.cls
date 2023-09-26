/// 名称: web.DHCBillOtherLB.cls
/// 描述: 公共列表数据查询类--为门诊收费、住院收费界面的下拉框提供数据
/// 编写者: Lid
/// 编写日期: 2014-03-13
/// 产品组：计费医保组
Class web.DHCBillOtherLB Extends BILL.COM.Abstract
{

/// Creator: Lid
/// CreatDate: 2014-03-13
/// Description: 获取卡类型信息
/// Input: SessionStr:session数据串(IP地址^用户ID^登录科室ID^安全组ID^院区ID^站点^^^)
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QCardTypeDefineList","")
Query QCardTypeDefineList(SessionStr As %String = "", LangId As %String = "") As websys.Query(ROWSPEC = "value:%String,caption:%String,selected:%Boolean")
{
}

ClassMethod QCardTypeDefineListExecute(ByRef qHandle As %Binary, SessionStr As %String = "", LangId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
 
	set myDataFlag=0
	set myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($isObject(myPEObj)){
		set myDataFlag=1
	}
	set hospId=$p(SessionStr,"^",5)
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^DHCCARDTYPEDef(id))) {
		set id=$o(^DHCCARDTYPEDef(id))
		set data=$g(^DHCCARDTYPEDef(id))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef", id, hospId)
		continue:(showFlag="N")
		set mydes=$p(data,"^",2)
		set mydes=##class(User.DHCCardTypeDef).GetTranByDesc("CTDDesc", mydes, LangId)
		set activeFlag=$p(data,"^",11)		//CTD_ActiveFlag
		continue:(activeFlag'="IE")
		set dateFrom=$p(data,"^",9)         //CTD_DateFrom
		set dateTo=$p(data,"^",10)		    //CTD_DateTo
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set myval=id_"^"_data
		set myDefault=$p(data,"^",8)
		if (+myDataFlag=1) {
			set myFindFlag=myPEObj.FindCardTypeByDR(id)
			continue:(+myFindFlag=0)
			if (myPEObj.DefaultCardTypeDR=id) {
				set myDefault="Y"
			}
		}
		set selected=$s((myDefault="Y"):"true",1:"false")     //取默认		
		do OutputCardTypeList
	}
   	
   	quit $$$OK
 
OutputCardTypeList
	set Data=$lb(myval,mydes,selected)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: Lid
/// CreatDate: 2014-03-13
/// Description: 查询银行列表
/// Table: CMC_BankMas
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QBankList")
Query QBankList(langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,selected:%Boolean")
{
}

ClassMethod QBankListExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=""
	set text="　"	//此处是一个全角空格
	set selected="true"
	do OutputBankList
	
	set id=0
	while($o(^CMC("CMCBM",id))) {
		set id=$o(^CMC("CMCBM",id))
		set data=$g(^CMC("CMCBM",id))
		continue:(data="")
		set dateFrom=$p(data,"^",5)
		set dateTo=$p(data,"^",6)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))   //+2018-01-16 ZhYW 过滤不在有效期的
		set text=$p(data,"^",2)
		set text=##class(User.CMCBankMas).GetTranByDesc("CMCBMDesc", text, langId)
		set selected="false"
		do OutputBankList
	}
   	
	quit $$$OK
 
OutputBankList
	set Data=$lb(id,text,selected)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// w ##class(web.DHCBillOtherLB).test1("web.DHCBillOtherLB","QBankList")
ClassMethod test1(ClassName, QueryName)
{
	set ret=""
	set cdef=##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	set count=cdef.Queries.Count() 
	for i=1:1:count {
		if (cdef.Queries.GetAt(i).Name=QueryName) {		 	
	 		set ret=cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
		}
	}
	kill cdef
	quit ret
}

/// Creator: ZhYW
/// CreatDate: 2020-06-15
/// Description: 查询合同单位
/// Table: CT_HealthCareProvider
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryHCPList", "")
Query QryHCPList(patientId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,selected:%Boolean")
{
}

ClassMethod QryHCPListExecute(ByRef qHandle As %Binary, patientId As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
 	set patHCPDR=$s((+patientId'=0):$p($g(^PAPER(patientId,"PER",4)),"^",17),1:"")
 	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

	set id=""
	set text="　"	//此处是一个全角空格
	set selected="false"
	do OutputHCPList
	
	set id=0
	while ($o(^CT("HCP",id))) {
		set id=$o(^CT("HCP",id))
		set data=$g(^CT("HCP",id))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_HealthCareProvider", id, hospId)
		continue:(showFlag="N")
		set isActive=$p(data,"^",6)
		continue:(isActive'="Y")
		set text=$p(data,"^",2)
		set text=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", text, langId)
		set selected=$s((id=patHCPDR):"true",1:"false")
		do OutputHCPList
	}
	
	quit $$$OK
OutputHCPList
	set Data=$lb(id,text,selected)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-11-18
/// Description: 查询费别
/// Table: PAC_AdmReason
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryAdmReason","2")
Query QryAdmReason(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryAdmReasonExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^PAC("ADMREA",id))) {
		set id=$o(^PAC("ADMREA",id))
		set data=$g(^PAC("ADMREA",id))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason", id, hospId)
		continue:(showFlag="N")
		set dateFrom=$p(data,"^",3)
		set dateTo=$p(data,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.PACAdmReason).GetTranByDesc("READesc", text, langId)
		do OutputAdmReason
	}
 	
	quit $$$OK
    
OutputAdmReason
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-11-20
/// Description: 查询支付方式
/// Table: CT_PayMode
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryPayMode")
Query QryPayMode(langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryPayModeExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^CT("CTPM",id))) {
		set id=$o(^CT("CTPM",id))
		set data=$g(^CT("CTPM",id))
		set dateFrom=$p(data,"^",5)
		set dateTo=$p(data,"^",6)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.CTPayMode).GetTranByDesc("CTPMDesc",text,langId)
		do OutputPayMode
	}
 	
	quit $$$OK
    
OutputPayMode
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-11-20
/// Description: 查询支付方式
/// Table: CT_Hospital
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryHospital")
Query QryHospital(langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryHospitalExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^CT("HOSP",id))) {
		set id=$o(^CT("HOSP",id))
		set data=$g(^CT("HOSP",id))
		set dateFrom=$p(data,"^",9)
		set dateTo=$p(data,"^",10)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.CTHospital).GetTranByDesc("HOSPDesc", text, langId)
		do OutputHosp
	}
 	
	quit $$$OK
    
OutputHosp
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-04-15
/// Description: 查询科室组
/// Table: RBC_DepartmentGroup
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryDeptGrp", 2)
Query QryDeptGrp(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryDeptGrpExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
    if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set id=0
    while($o(^RBC("DEP",id))) {
	    set id=$o(^RBC("DEP",id))
		set data=$g(^RBC("DEP",id))
		continue:(data="")
	  	set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("RBC_DepartmentGroup", id, hospId)
		continue:(showFlag="N")
		set dateFrom=$p(data,"^",3)
		set dateTo=$p(data,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.RBCDepartmentGroup).GetTranByDesc("DEPDesc", text, langId)
		do OutputDeptGrp
	}

	quit $$$OK
OutputDeptGrp
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-04-15
/// Description: 查询科室
/// Input:  
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryDept", "")
Query QryDept(desc As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,contactName:%String")
{
}

ClassMethod QryDeptExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^CTLOC(id))) {
		set id=$o(^CTLOC(id))
		set data=$g(^CTLOC(id))
		continue:(data="")
	 	set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", id, hospId)
		continue:(showFlag="N")
	 	set dateFrom=$p(data,"^",24)
		set dateTo=$p(data,"^",25)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		continue:(##class(web.DHCOPAdmReg).CheckLocDesc(id, desc)'=1)
		set text=$p(data,"^",2)
		set text=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", text, langId)
		set contactName=$p(data,"^",43)
	 	do OutputDept
	}
	
	quit $$$OK
    
OutputDept
	set Data=$lb(id,text,contactName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-04-15
/// Description: 查询住院科室
/// Input:  
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryIPDept", "", 2)
Query QryIPDept(desc As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,contactName:%String")
{
}

ClassMethod QryIPDeptExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^PAC("ADMLOC",0,"AdmType","I",id))) {
		set id=$o(^PAC("ADMLOC",0,"AdmType","I",id))
	 	set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", id, hospId)
		continue:(showFlag="N")
		set data=$g(^CTLOC(id))
		set wardFlag=$p(data,"^",5)
		continue:(wardFlag="Y")
	 	set dateFrom=$p(data,"^",24)
		set dateTo=$p(data,"^",25)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		continue:(##class(web.DHCOPAdmReg).CheckLocDesc(id, desc)'=1)
		set text=$p(data,"^",2)
		set text=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", text, langId)
		set contactName=$p(data,"^",43)
	 	do OutputDept
	}
	
	quit $$$OK
    
OutputDept
	set Data=$lb(id,text,contactName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-04-15
/// Description: 查询科室关联的病区
/// Table: CT_LocLinkLocation
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryLocLinkWard", 105)
Query QryLocLinkWard(locId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryLocLinkWardExecute(ByRef qHandle As %Binary, locId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
    if (+locId=0) quit $$$OK
    
    if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set linkSub=0
	while($o(^CTLOC(locId,"LINK",linkSub))) {
		set linkSub=$o(^CTLOC(locId,"LINK",linkSub))
		set linkSubData=$g(^CTLOC(locId,"LINK",linkSub))
		set locDR=$p(linkSubData,"^",1)
		continue:(+locDR=0)
		set locData=$g(^CTLOC(locDR))
		set wardFlag=$p(locData,"^",5)
		continue:(wardFlag'="Y")
		set wardId=$o(^PAWARD(0,"WARD_LocationDR",locDR,0))
		continue:(+wardId=0)
		set ward=$p($g(^PAWARD(wardId)),"^",2)
		set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
		do OutputLinkWard
	}
	
	quit $$$OK
    
OutputLinkWard
	set Data=$lb(wardId,ward)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-04-15
/// Description: 查询病区
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryWard","","2")
Query QryWard(desc As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,contactName:%String")
{
}

ClassMethod QryWardExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^PAWARD(id))) {
		set id=$o(^PAWARD(id))
		set data=$g(^PAWARD(id))
		continue:(data="")
		set isActive=$p(data,"^",6)
		continue:(isActive'="Y")
		set locDR=$p(data,"^",5)
		continue:(+locDR=0)
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", locDR, hospId)
		continue:(showFlag="N")
		set locData=$g(^CTLOC(locDR))
		set wardFlag=$p(locData,"^",5)
		continue:(wardFlag'="Y")
		set locType=$p(locData,"^",13)
		continue:(locType'="W")
		set dateFrom=$p(locData,"^",24)
		set dateTo=$p(locData,"^",25)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		continue:(##class(web.DHCOPAdmReg).CheckLocDesc(locDR, desc)'=1)
		set text=$p(locData,"^",2)
		set text=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", text, langId)
		set contactName=$p(locData,"^",43)
		do OutputWard
	}
	
	quit $$$OK
    
OutputWard
	set Data=$lb(id,text,contactName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-04-15
/// Description: 查询医嘱大类
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryOrdCate", "")
Query QryOrdCate(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryOrdCateExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^OEC("ORCAT",id))) {
		set id=$o(^OEC("ORCAT",id))
		set cateData=$g(^OEC("ORCAT",id))
		continue:(cateData="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("OEC_OrderCategory", id, hospId)
		continue:(showFlag="N")
		set text=$p(cateData,"^",2)
		set text=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", text, langId)
		do OutputOrdCate
	}
 	
	quit $$$OK
	
OutputOrdCate
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-05-30
/// Description: 查询医嘱子类
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryARCItemCat", "")
Query QryARCItemCat(ordCatId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryARCItemCatExecute(ByRef qHandle As %Binary, ordCatId As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^ARC("IC",id))) {
		set id=$o(^ARC("IC",id))
		set arcicData=$g(^ARC("IC",id))
		continue:(arcicData="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat", id, hospId)
		continue:(showFlag="N")
		set ordCatDR=$p(arcicData,"^",8)
		continue:((ordCatId'="")&&(ordCatId'=ordCatDR))
		set text=$p(arcicData,"^",2)
		set text=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc", text, langId)
		do OutputItemCat
	}
 	
	quit $$$OK
	
OutputItemCat
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-04-21
/// Description: 查询住院费用大类
/// Table: DHC_TarIC
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryTarIC")
Query QryTarIC(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryTarICExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
    if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set id=0
    while($o(^DHCTarC("TIC",id))) {
	    set id=$o(^DHCTarC("TIC",id))
	    set data=$g(^DHCTarC("TIC",id))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarIC", id, hospId)
		continue:(showFlag="N")
		set dateFrom=$p(data,"^",3)
		set dateTo=$p(data,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.DHCTarIC).GetTranByDesc("TARTICDesc", text, langId)
		do OutputTarIC
	}

	quit $$$OK
OutputTarIC
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: gongxin
/// CreatDate: 2023-04-21
/// Description: 查询住院费用子类
/// Table: DHC_TarInpatCate
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryTarInpatCate",2,1)
Query QryTarInpatCate(tarTICDR As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryTarInpatCateExecute(ByRef qHandle As %Binary, tarTICDR As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
    if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
    set id=0
    while($o(^DHCTarC("IC",0,"TIC",tarTICDR,id))) {
	    set id=$o(^DHCTarC("IC",0,"TIC",tarTICDR,id))
	    set data=$g(^DHCTarC("IC",id))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarInpatCate", id, hospId)
		continue:(showFlag="N")
		set dateFrom=$p(data,"^",3)
		set dateTo=$p(data,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.DHCTarInpatCate).GetTranByDesc("TARICDesc", text, langId)
		do OutputTarInpatCate
	}

	quit $$$OK
OutputTarInpatCate
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-04-22
/// Description: 查询SS_User
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QrySSUser", "sf", 2)
Query QrySSUser(desc As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QrySSUserExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (desc="") quit $$$OK
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set keyReg=$s((desc'=""):"^"_$zcvt(desc,"U"),1:"")  //左匹配正则表达式
	
	set id=0
	while($o(^SSU("SSUSR",id))) {
		set id=$o(^SSU("SSUSR",id))
		set data=$g(^SSU("SSUSR",id))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_User", id, hospId)
		continue:(showFlag="N")
		set isActive=$p(data,"^",19)
		continue:(isActive'="Y")
		set dateFrom=$p(data,"^",96)
		set dateTo=$p(data,"^",97)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set code=$p(data,"^",1)
		set text=$p(data,"^",2)
		set namePY=##class(ext.util.String).ToChineseSpell(text)
		set text=##class(User.SSUser).GetTranByDesc("SSUSRName", text, langId)
		continue:((keyReg'="")&&('$locate(code,keyReg))&&('$locate(text,keyReg))&&('$locate($zcvt(namePY,"U"),keyReg)))
		do OutputUserList
	}
	
	quit $$$OK
	
OutputUserList
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-05-06
/// Description: 查询患者类型
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryPatType", "2")
Query QryPatType(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryPatTypeExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^CT("SS",id))) {
		set id=$o(^CT("SS",id))
		set data=$g(^CT("SS",id))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_SocialStatus", id, hospId)
		continue:(showFlag="N")
		set text=$p(data,"^",2)
		set text=##class(User.CTSocialStatus).GetTranByDesc("SSDesc", text, langId)
		do OutputPatType
	}
 	
	quit $$$OK
	
OutputPatType
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-05-06
/// Description: 门诊收费集中打印发票患者类型
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryPatTypeForAccPINV", "2")
Query QryPatTypeForAccPINV(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "value:%String,text:%String,selected:%Boolean")
{
}

ClassMethod QryPatTypeForAccPINVExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set isSelfFlag=0
	set myBConStr=##class(web.DHCOPConfig).GetOPBaseConfig(hospId)
	set myYBConFlag=$p(myBConStr,"^",10)
		
	set id=0
	while($o(^CT("SS",id))) {
		set id=$o(^CT("SS",id))
		set data=$g(^CT("SS",id))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_SocialStatus", id, hospId)
		continue:(showFlag="N")
		set myPACRowID=$o(^DHCPACADM(0,"Social",id,0))
		set myReaRowID=$s((+myPACRowID'=0):$p(^DHCPACADM(myPACRowID),"^",2),1:"")
		set myAdmSource=$s((+myReaRowID'=0):$p($g(^PAC("ADMREA",myReaRowID)),"^",9),1:0)
		set myConFlag=$s(((myYBConFlag=1)&&(+myAdmSource>0)):myAdmSource,1:0)
		set code=$p(data,"^",1)
		set value=id_"^"_code_"^"_myConFlag_"^"_myReaRowID
		set text=$p(data,"^",2)
		set text=##class(User.CTSocialStatus).GetTranByDesc("SSDesc", text, langId)
		set selected="false"
		if ((isSelfFlag=0)&&(+myAdmSource=0)) {
			set selected="true"
			set isSelfFlag=1
		}
		do OutputPatTypeForAccPINV
	}
 	
	quit $$$OK
	
OutputPatTypeForAccPINV
	set Data=$lb(value,text,selected)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-05-25
/// Description: 证件类型
/// Table: DHC_CredType
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryCredType")
Query QryCredType(langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,selected:%Boolean")
{
}

ClassMethod QryCredTypeExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set id=0
    while($o(^PAC("CARD",id))) {
	    set id=$o(^PAC("CARD",id))
	    set data=$g(^PAC("CARD",id))
		continue:(data="")
		set isActive=$p($g(^PAC("CARD",id,"DHC")),"^",1)
		continue:(isActive'="Y")
		set dateFrom=$p(data,"^",3)
		set dateTo=$p(data,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.DHCCredType).GetTranByDesc("CRTDesc", text, langId)
		set isDefault=$p($g(^PAC("CARD",id,"DHC")),"^",2)
		set selected=$case(isDefault,"Y":"true",:"false")
		do OutputCredType
	}
	
	quit $$$OK
OutputCredType
	set Data=$lb(id,text,selected)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-06
/// Description: 银行卡类型
/// Table: ARC_BankCardType
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryBankCardType")
Query QryBankCardType(langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryBankCardTypeExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set id=0
    while($o(^ARC("CARD",id))) {
	    set id=$o(^ARC("CARD",id))
	    set data=$g(^ARC("CARD",id))
		continue:(data="")
		set dateFrom=$p(data,"^",4)
		set dateTo=$p(data,"^",5)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.ARCBankCardType).GetTranByDesc("CARDDesc", text, langId)
		do OutputBankCardType
	}
	
	quit $$$OK
OutputBankCardType
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-06
/// Description: 查询退费原因
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryRefReason","2","20")
Query QryRefReason(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryRefReasonExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
    if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
    set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_OP_RefInvReason", hospId)
    
    set id=0
    while ($o(^DHCINVOPREFR(id))) {
	    set id=$o(^DHCINVOPREFR(id))
	    set data=$g(^DHCINVOPREFR(id))
	    continue:(data="")
	    set hospDR=$p(data,"^",3)
	    continue:(hospDR'=defHospId)
	    set text=$p(data,"^",2)
	    set text=##class(User.DHCINVOPRefReason).GetTranByDesc("IRRDesc", text, langId)
	    do OutputRefReason
	}
	
	quit $$$OK
OutputRefReason
	set Data=$lb(id,text)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-21
/// Description: 查询取消结算原因
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryCancelChgReason","2")
Query QryCancelChgReason(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryCancelChgReasonExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryReasonList")=$lb(hospId, langId)
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_IP_CancelChgReason", hospId)
	
	set id=0
	while($o(^CF.BILL.IP.CancelChgReasonD(id))) {
		set id=$o(^CF.BILL.IP.CancelChgReasonD(id))
		set data=$g(^CF.BILL.IP.CancelChgReasonD(id))
		set hospDR=$lg(data,12)
		quit:(hospDR'=defHospId)
		set dateFrom=$lg(data,4)
		set dateTo=$lg(data,5)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$lg(data,3)
	    set text=##class(CF.BILL.IP.CancelChgReason).GetTranByDesc("ReaDesc", text, langId)
		do OutputCancelChgReason
	}
	quit $$$OK
OutputCancelChgReason
	set data=$lb(id,text)
	set ^CacheTemp(repid,ind)=data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-24
/// Description: 查询入院途径
/// Table: PAC_AdmSource
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryInAdmSource", "")
Query QryInAdmSource(langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryInAdmSourceExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^PAC("ADSOU",id))) {
		set id=$o(^PAC("ADSOU",id))
		set data=$g(^PAC("ADSOU",id))
		continue:(data="")
		set dateFrom=$p(data,"^",4)
		set dateTo=$p(data,"^",5)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.PACAdmSource).GetTranByDesc("ADSOUDesc", text, langId)
		do OutputAdmSource
	}
	
	quit $$$OK
OutputAdmSource
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-24
/// Description: 查询入院途径
/// Table: PAC_AdmCategory
/// Input:  
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryAdmCategory")
Query QryAdmCategory(langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,selected:%Boolean")
{
}

ClassMethod QryAdmCategoryExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^PAC("ADMCAT",id))) {
		set id=$o(^PAC("ADMCAT",id))
		set data=$g(^PAC("ADMCAT",id))
		continue:(data="")
		set dateFrom=$p(data,"^",3)
		set dateTo=$p(data,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set code=$p(data,"^",1)
		set text=$p(data,"^",2)
		set text=##class(User.PACAdmCategory).GetTranByDesc("ADMCATDesc", text, langId)
		set selected=$case(code,"02":"true",:"false")    //默认"非绿色通道"
		do OutputAdmCategory
	}
	
	quit $$$OK
OutputAdmCategory
	set Data=$lb(id,text,selected)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-24
/// Description: 查询就诊子类
/// Table: PAC_EpisodeSubType
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryEpisSubType")
Query QryEpisSubType(langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryEpisSubTypeExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^PAC("SUBT",id))) {
		set id=$o(^PAC("SUBT",id))
		set data=$g(^PAC("SUBT",id))
		continue:(data="")
		set dateFrom=$p(data,"^",8)
		set dateTo=$p(data,"^",9)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.PACEpisodeSubType).GetTranByDesc("SUBTDesc", text, langId)
		do OutputEpis
	}
    
	quit $$$OK
OutputEpis
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-24
/// Description: 查询入院病情
/// Table: PAC_ReferralPriority
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryRefPriority")
Query QryRefPriority(langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryRefPriorityExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
  	set ind=1
  	
  	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^PAC("REFPRI",id))) {
		set id=$o(^PAC("REFPRI",id))
		set data=$g(^PAC("REFPRI",id))
		continue:(data="")
		set dateFrom=$p(data,"^",8)
		set dateTo=$p(data,"^",9)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.PACReferralPriority).GetTranByDesc("REFPRIDesc", text, langId)
		do OutputRefPri
	}
    
	quit $$$OK
OutputRefPri
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-07-01
/// Description: 查询收费员
/// Table: DHC_JFRcptGroupSet
/// Input: invType:票据类型(O:门诊, I:住院, R:挂号)
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryInvUser","O",2)
Query QryInvUser(invType As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryInvUserExecute(ByRef qHandle As %Binary, invType As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
 	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	if (invType="") quit $$$OK
	
	set rowId=$o(^DHCJFRcptGroupSet(0,"Type",$zcvt(invType,"U"),3,0))
	if (rowId="") quit $$$OK
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_RcptGroupUser", hospId)

	set sub=0
	while($o(^DHCJFRcptGroupSet(rowId,"Sub",sub))) {
		set sub=$o(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		set data=$g(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		continue:(data="")
		set hospDR=$p(data,"^",5)
		continue:(hospDR'=defHospId)
		set userDR=$p(data,"^",4)
		set userName=$s((+userDR'=0):$p(^SSU("SSUSR",userDR),"^",2),1:"")
		set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
		do OutputInvUser
	}
 
 	quit $$$OK
 	
OutputInvUser
	set Data=$lb(userDR,userName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
 	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-07-01
/// Description: 查询票据购入人员
/// Input: hospId: CT_Hospital.RowId
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryInvBuyer",2)
Query QryInvBuyer(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryInvBuyerExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
  	
	set rowId=$o(^DHCJFRcptGroupSet(0,"Type","A",1,0))
	if (rowId="") quit $$$OK
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_RcptGroupUser", hospId)
	
	set sub=0
	while($o(^DHCJFRcptGroupSet(rowId,"Sub",sub))) {
		set sub=$o(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		set data=$g(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		continue:(data="")
		set hospDR=$p(data,"^",5)
		continue:(hospDR'=defHospId)
		set userDR=$p(data,"^",4)
		set userName=$s((+userDR'=0):$p(^SSU("SSUSR",userDR),"^",2),1:"")
		set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
		do OutputInvBuyer
	}
 
 	quit $$$OK
 	
OutputInvBuyer
	set Data=$lb(userDR,userName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
 	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 国家
/// Table: CT_Country
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryCountry", "", 1)
Query QryCountry(desc As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryCountryExecute(ByRef qHandle As %Binary, desc As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^CT("COU",id))) {
		set id=$o(^CT("COU",id))
		set data=$g(^CT("COU",id))
		continue:(data="")
		set isActive=$p(data,"^",3)
		continue:(isActive'="Y")
		set dateFrom=$p(data,"^",4)
		set dateTo=$p(data,"^",5)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set country=$p(data,"^",2)
		set country=##class(User.CTCountry).GetTranByDesc("CTCOUDesc", country, langId)
		continue:((desc'="")&&(country'[desc))
	 	do OutputCountry
	}
    
	quit $$$OK
OutputCountry
	set Data=$lb(id,country)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 省份
/// Table: CT_Province
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryProvince", "", 1)
Query QryProvince(desc As %String, countryId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryProvinceExecute(ByRef qHandle As %Binary, desc As %String, countryId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
    
    if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set id=0
	while($o(^CT("PROV",id))) {
		set id=$o(^CT("PROV",id))
		set data=$g(^CT("PROV",id))
		continue:(data="")
		set regionDR=$p(data,"^",3)
		set ctryDR=$s((+regionDR'=0):$p($g(^CT("RG",regionDR)),"^",4),1:"")
		continue:(countryId'=ctryDR)
		set dateFrom=$p(data,"^",4)
		set dateTo=$p(data,"^",5)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set prov=$p(data,"^",2)
		set prov=##class(User.CTProvince).GetTranByDesc("PROVDesc", prov, langId)
		continue:((desc'="")&&(prov'[desc))
		do OutputProvince
	}
    
	quit $$$OK
OutputProvince
	set Data=$lb(id,prov)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 市
/// Table: CT_City
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryCity", "", 1)
Query QryCity(desc As %String, provId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryCityExecute(ByRef qHandle As %Binary, desc As %String, provId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (+provId=0)  quit $$$OK
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set code=""
    while($o(^CT("CIT",0,"ProvCode",provId,code))'="") {
	    set code=$o(^CT("CIT",0,"ProvCode",provId,code))
	    set id=0
	    while($o(^CT("CIT",0,"ProvCode",provId,code,id))) {
		    set id=$o(^CT("CIT",0,"ProvCode",provId,code,id))
		    set data=$g(^CT("CIT",id))
			continue:(data="")
			set dateFrom=$p(data,"^",5)
			set dateTo=$p(data,"^",6)
			continue:((dateFrom'="")&&(dateFrom>+$h))
			continue:((dateTo'="")&&(dateTo<+$h))
			set city=$p(data,"^",2)
			set city=##class(User.CTCity).GetTranByDesc("CTCITDesc", city, langId)
			continue:((desc'="")&&(city'[desc))
			do OutputCity
		}
	}
    
	quit $$$OK
OutputCity
	set Data=$lb(id,city)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 区县
/// Table: CT_CityArea
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryCityArea", "", 1)
Query QryCityArea(desc As %String, cityId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryCityAreaExecute(ByRef qHandle As %Binary, desc As %String, cityId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (+cityId=0)  quit $$$OK
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}

	set code=""
	while($o(^CT("CITAREA",0,"CityCode",cityId,code))'="") {
		set code=$o(^CT("CITAREA",0,"CityCode",cityId,code))
		set id=0
		while($o(^CT("CITAREA",0,"CityCode",cityId,code,id))) {
			set id=$o(^CT("CITAREA",0,"CityCode",cityId,code,id))
			set data=$g(^CT("CITAREA",id))
			continue:(data="")
			set dateFrom=$p(data,"^",4)
			set dateTo=$p(data,"^",5)
			continue:((dateFrom'="")&&(dateFrom>+$h))
			continue:((dateTo'="")&&(dateTo<+$h))
			set cityArea=$p(data,"^",2)
			set cityArea=##class(User.CTCityArea).GetTranByDesc("CITAREADesc", cityArea, langId)
			continue:((desc'="")&&(cityArea'[desc))
		  	do OutputCityArea
		}
	}
    
	quit $$$OK
	
OutputCityArea
	set Data=$lb(id,cityArea)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 地址
/// Table: CT_Address
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryAddress", "", "3137")
Query QryAddress(desc As %String, cityAreaId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryAddressExecute(ByRef qHandle As %Binary, desc As %String, cityAreaId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (+cityAreaId=0)  quit $$$OK
 	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}

	set id=0
	while($o(^CT("ADD",0,"CityArea",cityAreaId,id))) {
		set id=$o(^CT("ADD",0,"CityArea",cityAreaId,id))
		set data=$g(^CT("ADD",id))
		continue:(data="")
		set dateFrom=$p(data,"^",9)
		set dateTo=$p(data,"^",10)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.CTAddress).GetTranByDesc("CTADDDesc", text, langId)
		continue:((desc'="")&&(text'[desc))
		do OutputAddress
	}
    
	quit $$$OK
	
OutputAddress
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-08-30
/// Description: 查询医生
/// Table: CT_CareProv
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryDoctor", "", 2)
Query QryDoctor(desc As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,contactName:%String")
{
}

ClassMethod QryDoctorExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (desc="") quit $$$OK
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^CTPCP(id))) {
		set id=$o(^CTPCP(id))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_CareProv", id, hospId)
		continue:(showFlag="N")
		set carPrvTpDR=$p($g(^CTPCP(id,1)),"^",4)   //CTPCP_CarPrvTp_DR
		continue:(+carPrvTpDR=0)
		set doctorType=$p($g(^CT("CPT",carPrvTpDR)),"^",4)
		continue:($zcvt(doctorType,"U")'="DOCTOR")  //非医生过滤
		set isActive=$p($g(^CTPCP(id,1)),"^",9)
		continue:(isActive'="Y")
		set dateFrom=$p($g(^CTPCP(id,2)),"^",14)
		set dateTo=$p($g(^CTPCP(id,2)),"^",15)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p($g(^CTPCP(id,1)),"^",2)
		set text=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", text, langId)
		set contactName=$p($g(^CTPCP(id,3)),"^",28)    //CTPCP_OtherName
		continue:((desc'="")&&($zcvt(text,"U")'[$zcvt(desc,"U"))&&($zcvt(contactName,"U")'[$zcvt(desc,"U")))
	  	do OutputDoctor
	}
    
	quit $$$OK
	
OutputDoctor
	set Data=$lb(id,text,contactName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 查询根据安全组配置的费别
/// Table: DHC_JFSSGrpAdmReasonConfig，PAC_AdmReason
/// Input: groupId: SS_Group.RowId
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryGrpAdmReason","131",2)
Query QryGrpAdmReason(groupId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,nationalCode:%String,selected:%Boolean")
{
}

ClassMethod QryGrpAdmReasonExecute(ByRef qHandle As %Binary, groupId As %String, hospId As %String, langId As %String = "") As %Status
{
  	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
  	set ind=1
  	if (groupId="") quit $$$OK
  	
  	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
  	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_GroupAuth", hospId)
  	
	set id=0
	while($o(^DHCJFSSGRPADMREASONCONFIG(0,"SSGrp",groupId,id))) {
		set id=$o(^DHCJFSSGRPADMREASONCONFIG(0,"SSGrp",groupId,id))
		set data=$g(^DHCJFSSGRPADMREASONCONFIG(id))
		continue:(data="")
		set admReaDR=$p(data,"^",2)
		continue:(+admReaDR=0)
		set hospDR=$p(data,"^",6)
		continue:(hospDR'=defHospId)
		set admReaData=$g(^PAC("ADMREA",admReaDR))
		set admReaDesc=$p(admReaData,"^",2)
		set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
		set nationalCode=$p(admReaData,"^",5)
		set isDefault=$p(data,"^",3)
		set selected=$case(isDefault,"Y":"true", :"false")
		do OutputGrpAdmReason
	}
   	
	quit $$$OK
OutputGrpAdmReason
    set Data=$lb(admReaDR,admReaDesc,nationalCode,selected)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-06-03
/// Description: 查询退押金原因
/// Table: dhc_jfyjrefreason
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryRefDepReason",2)
Query QryRefDepReason(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryRefDepReasonExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
    if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_IP_RefDepReason", hospId)
    
    set id=0
    while($o(^DHCJFYJRREASON(id))) {
	    set id=$o(^DHCJFYJRREASON(id))
	    set data=$g(^DHCJFYJRREASON(id))
		continue:(data="")
	  	set hospDR=$p(data,"^",6)
	  	continue:(hospDR'=defHospId)
	  	set dateFrom=$p(data,"^",3)
		set dateTo=$p(data,"^",4)
	   	continue:((dateFrom'="")&&(dateFrom>+$h))
	   	continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.dhcjfyjrefreason).GetTranByDesc("yjrreadesc", text, langId)
	  	do OutputRefDepReason
	}
    
	quit $$$OK
OutputRefDepReason
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-06-03
/// Description: 查询安全组授权的押金类型
/// Table: DHC_JFSSGrpDepTypeConfig
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryGrpDepType", "241", "2")
Query QryGrpDepType(groupId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,selected:%Boolean")
{
}

ClassMethod QryGrpDepTypeExecute(ByRef qHandle As %Binary, groupId As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_IP_GroupDepType", hospId)
	
	set id=0
	while($o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",groupId,id))) {
		set id=$o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",groupId,id))
		set data=$g(^DHCJFSSGRPDEPTYPECONFIG(id))
		set hospDR=$p(data,"^",6)
		continue:(hospDR'=defHospId)
		set depTypeDR=$p(data,"^",2)
		set depTypeData=$g(^ARC("ARCDT",depTypeDR))
		set depTypeDesc=$p(depTypeData,"^",2)
		set depTypeDesc=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", depTypeDesc, langId)
		set idDefault=$p(data,"^",3)
		set selected=$s((idDefault="Y"):"true",1:"false")
		do OutputGrpDepType
	}
	
	quit $$$OK
	
OutputGrpDepType
    set Data=$lb(depTypeDR,depTypeDesc,selected)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 查询科室内医生
/// Table: RB_Resource
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryDeptDoctor", "104", "")
Query QryDeptDoctor(deptId As %String, desc As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryDeptDoctorExecute(ByRef qHandle As %Binary, deptId As %String, desc As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (deptId="") quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

 	kill careProvAry

	set id=0
	while($o(^RB("RES",0,"CTLOC",deptId,id))) {
		set id=$o(^RB("RES",0,"CTLOC",deptId,id))
		set careProvId=$p(^RB("RES",id),"^",2)   //RES_CTPCP_DR->CT_CareProv
		continue:(careProvId="")
		continue:($d(careProvAry(careProvId)))   //去重
		set careProvAry(careProvId)=""
		set userDR=$o(^SSU("SSUSR",0,"CTPCP",careProvId,0))
		set doctorType=##class(web.SSUser).GetDefaultCareProviderType(userDR)
		continue:($zcvt(doctorType,"U")'="DOCTOR")       //非医生过滤
		set isActive=$p($g(^CTPCP(careProvId,1)),"^",9)
		continue:(isActive'="Y")
		set dateFrom=$p($g(^CTPCP(careProvId,2)),"^",14)
		set dateTo=$p($g(^CTPCP(careProvId,2)),"^",15)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p($g(^CTPCP(careProvId,1)),"^",2)
		set text=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", text, langId)
		set contactName=$p($g(^CTPCP(careProvId,3)),"^",28)    //CTPCP_OtherName
		continue:((desc'="")&&($zcvt(text,"U")'[$zcvt(desc,"U"))&&($zcvt(contactName,"U")'[$zcvt(desc,"U")))
		do OutputDoctor
	}
	
	quit $$$OK
OutputDoctor
	set Data=$lb(careProvId,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-11-15
/// Description: 街道
/// Table: CT_LocalityType
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryStreet", "", "3137")
Query QryStreet(desc As %String, cityAreaId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryStreetExecute(ByRef qHandle As %Binary, desc As %String, cityAreaId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (+cityAreaId=0)  quit $$$OK
 	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set cityAreaCode=$p($g(^CT("CITAREA",cityAreaId)),"^",1)
	set streetCode=cityAreaCode
	while($o(^CT("LOCTYPE",0,"Code",streetCode))'="") {
		set streetCode=$o(^CT("LOCTYPE",0,"Code",streetCode))
		continue:('$locate(streetCode,cityAreaCode))
		set id=0
		while($o(^CT("LOCTYPE",0,"Code",streetCode,id))) {
			set id=$o(^CT("LOCTYPE",0,"Code",streetCode,id))
			set data=$g(^CT("LOCTYPE",id))
			continue:(data="")
			set isActive=$p(data,"^",5)
			continue:(isActive'="Y")
			set text=$p(data,"^",2)
			set text=##class(User.CTLocalityType).GetTranByDesc("LOCTYPEDesc", text, langId)
			continue:((desc'="")&&(text'[desc))
			do OutputStreet
		}
	}
    
	quit $$$OK
	
OutputStreet
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-11-15
/// Description: 社区
/// Table: CT_Community
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB", "QryCommunity", "", "7")
Query QryCommunity(desc As %String, streetId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryCommunityExecute(ByRef qHandle As %Binary, desc As %String, streetId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (+streetId=0)  quit $$$OK
 	
 	set ^TMP("QryCommunity")=$lb(desc, streetId, langId)
 	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set streetCode=$p($g(^CT("LOCTYPE",streetId)),"^",1)
	
	set commCode=streetCode
	while($o(^CT("CTCMUNT",0,"Code",commCode))'="") {
		set commCode=$o(^CT("CTCMUNT",0,"Code",commCode))
		continue:('$locate(commCode,streetCode))
		set id=0
		while($o(^CT("CTCMUNT",0,"Code",commCode,id))) {
			set id=$o(^CT("CTCMUNT",0,"Code",commCode,id))
			set data=$g(^CT("CTCMUNT",id))
			continue:(data="")
			set isActive=$p(data,"^",4)
			continue:(isActive'="Y")
			set text=$p(data,"^",2)
			set text=##class(User.CTCommunity).GetTranByDesc("CTCMUNTDesc", text, langId)
			continue:((desc'="")&&(text'[desc))
			do OutputCommunity
		}
	}
    
	quit $$$OK
	
OutputCommunity
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

}
