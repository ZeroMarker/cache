Import SQLUser

/// Creator: 陈曦
/// CreatDate: 2014-04-15
/// Description: 门诊非药品医嘱允许部分退费配置
Class web.DHCOPBillOrdRefundAppConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 陈曦
/// CreatDate: 2014-04-15
/// Description: 获取医嘱子类
Query FindArcimCat(HospId As %String) As websys.Query(ROWSPEC = "ArcicDr:%String,ArcicDesc:%String")
{
}

ClassMethod FindArcimCatExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set CNMedItemCatStr=##class(web.DHCDocOrderCommon).GetCNMedItemCatStr(HospId)

	set ArcicDr=0
	while($o(^ARC("IC",ArcicDr))) {
		set ArcicDr=$o(^ARC("IC",ArcicDr))
		set ArcData=$g(^ARC("IC",ArcicDr))
		continue:(ArcData="")
		set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat", ArcicDr, HospId)
		continue:(ShowFlag="N")
		if ("^"_CNMedItemCatStr_"^")[("^"_ArcicDr_"^") {
			continue
		}
		set ArcicDesc=$p(ArcData,"^",2)
		do OutputArcimCat
	}
 	
	quit $$$OK
    
OutputArcimCat
	set Data=$lb(ArcicDr,ArcicDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: 陈曦
/// CreatDate: 2014-04-15
/// Description: 获取医嘱项
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCOPBillOrdRefundAppConfig","FindArcim","","","xzdm","1")
Query FindArcim(ArcicDr As %String, ArcimDesc As %String, HospId As %String) As websys.Query(ROWSPEC = "ArcimDesc1:%String,ArcimRowid:%String,ArcicDesc:%String,ArcCatRowid:%String")
{
}

ClassMethod FindArcimExecute(ByRef qHandle As %Binary, ArcicDr As %String, ArcimDesc As %String, HospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindArcim")=$lb(ArcicDr, ArcimDesc, HospId)

 	if ((ArcicDr="")&&(ArcimDesc="")) quit $$$OK
 	
 	set CNMedItemCatStr=##class(web.DHCDocOrderCommon).GetCNMedItemCatStr(HospId)
 	
 	kill ^||TMP($j)
 	
 	if (ArcimDesc'="") {
	 	set ArcimDesc=$$ALPHAUP^SSUTIL4(ArcimDesc)
	 	set rowid=0
	 	while($o(^ARC("ALIAS",rowid))) {
		 	set rowid=$o(^ARC("ALIAS",rowid))
		 	set data=$g(^ARC("ALIAS",rowid))
			continue:(data="")
			set type=$p(data,"^",5)
			continue:(type'="ARCIM")
			set aliasDesc=$p(data,"^",3)
			set aliasDesc=$$ALPHAUP^SSUTIL4(aliasDesc)
			set aliasText=$p(data,"^",6)
			set aliasText=$$ALPHAUP^SSUTIL4(aliasText)
			set textIdx=##class(BILL.Util.Tools).InStr(aliasText, ArcimDesc)
			set descIdx=##class(BILL.Util.Tools).InStr(aliasDesc, ArcimDesc)
			continue:((ArcimDesc'="")&&(textIdx'=1)&&(descIdx'=1))
			set arcim=$p(data,"^",1)
			continue:((arcim="")||('$d(^ARCIM(+arcim,$p(arcim,"||",2)))))
			set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast", arcim, HospId)
			continue:(showFlag="N")
			continue:($d(^||TMP($j,arcim)))
			set dateFrom=$p($p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",13),"Z",1)
			set dateTo=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),7)),"^",1)
			continue:((dateFrom'="")&&(dateFrom>+$h))
			continue:((dateTo'="")&&(dateTo<+$h))
			set itemCatDR=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
			continue:((+ArcicDr'=0)&&(+ArcicDr'=itemCatDR))
			continue:("^"_CNMedItemCatStr_"^")[("^"_itemCatDR_"^")
			set ^||TMP($j,arcim)=""
		}
		
		set ArcimRowid=""
		while($o(^||TMP($j,ArcimRowid))'="") {
			set ArcimRowid=$o(^||TMP($j,ArcimRowid))
			continue:('$d(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2))))
			set ArcimDesc1=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
			set ArcCatRowid=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10) 	
			set ArcicDesc=$p(^ARC("IC",ArcCatRowid),"^",2)
	 		do OutputArcim
		}
	 	
	 	kill ^||TMP($j)
		quit $$$OK
	}
 	
	if (ArcicDr'="") {
		set ArcimSub=0
		while($o(^ARCIM(0,"ARCIC_DR",ArcicDr,ArcimSub))) {
			set ArcimSub=$o(^ARCIM(0,"ARCIC_DR",ArcicDr,ArcimSub))
			set ArcimVer=0
			while($o(^ARCIM(0,"ARCIC_DR",ArcicDr,ArcimSub,ArcimVer))) {
				set ArcimVer=$o(^ARCIM(0,"ARCIC_DR",ArcicDr,ArcimSub,ArcimVer))
				set ArcimDesc1=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
				set ArcimRowid=ArcimSub_"||"_ArcimVer
				set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast", ArcimRowid, HospId)
				continue:(showFlag="N")
				set ArcCatRowid=ArcicDr
				set ArcicDesc=$p(^ARC("IC",ArcCatRowid),"^",2)
			 	do OutputArcim
			}
		}
	 	quit $$$OK
	}
 	
	quit $$$OK
    
OutputArcim
	set Data=$lb(ArcimDesc1,ArcimRowid,ArcicDesc,ArcCatRowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: 陈曦
/// CreatDate: 2014-04-15
/// Description: 允许退费医嘱配置查询
Query FindOrdRefundAppConfig(ArcicDr As %String, ArcimRowid As %String, AppFlag As %String, HospId As %String) As websys.Query(ROWSPEC = "TArcicDesc:%String,TArcicDr:%String,TArcimDesc:%String,TArcimRowid:%String,TAPPFlag:%String,TDate:%String,TTime:%String,TUser:%String,TUpDate:%String,TUpTime:%String,TUpUser:%String,TStDate:%String,TEndDate:%String,TORACRowid:%String")
{
}

ClassMethod FindOrdRefundAppConfigExecute(ByRef qHandle As %Binary, ArcicDr As %String, ArcimRowid As %String, AppFlag As %String, HospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	if (+HospId=0)  quit $$$OK
	
 	if (ArcicDr'="") {
	 	set ORACRowid=0
	 	while($o(^DHCJFOrderRefundAppConfig(0,"Arcic",ArcicDr,ORACRowid))) {
		 	set ORACRowid=$o(^DHCJFOrderRefundAppConfig(0,"Arcic",ArcicDr,ORACRowid))
			set cfgData=$g(^DHCJFOrderRefundAppConfig(ORACRowid))
		 	do GetOutputRefApp
		}
	 	quit $$$OK
	}

	set ORACRowid=0
	while($o(^DHCJFOrderRefundAppConfig(ORACRowid))) {
		set ORACRowid=$o(^DHCJFOrderRefundAppConfig(ORACRowid))
		set cfgData=$g(^DHCJFOrderRefundAppConfig(ORACRowid))
		do GetOutputRefApp
	}

	quit $$$OK

GetOutputRefApp
	set HospDR=$p(cfgData,"^",15)
	quit:(HospDR'=HospId)
	set ArcicDr=$p(cfgData,"^",1)
 	set TArcicDesc=$p(^ARC("IC",ArcicDr),"^",2)
 	set TArcicDr=ArcicDr
 	set TArcimRowid=$p(cfgData,"^",2)
 	quit:(TArcimRowid'="")&&(TArcimRowid'=ArcimRowid)&&(ArcimRowid'="")
 	set TArcimDesc=$s((TArcimRowid'=""):$p(^ARCIM(+TArcimRowid,$p(TArcimRowid,"||",2),1),"^",2),1:"")
 	set TAPPFlag=$p(cfgData,"^",14)
 	set TDate=$p(cfgData,"^",5)
	set TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
 	set TTime=$p(cfgData,"^",6)
	set TTime=##class(websys.Conversions).TimeLogicalToHtml(TTime, 1)
 	set TUser=$p(cfgData,"^",7)
 	set TUser=$s((TUser'=""):$p(^SSU("SSUSR",TUser),"^",2),1:"")
 	set TUpDate=$p(cfgData,"^",8) 
	set TUpDate=##class(websys.Conversions).DateLogicalToHtml(TUpDate)
 	set TUpTime=$p(cfgData,"^",9)
	set TUpTime=##class(websys.Conversions).TimeLogicalToHtml(TUpTime, 1)
 	set TUpUser=$p(cfgData,"^",10)
 	set TUpUser=$s((TUpUser'=""):$p(^SSU("SSUSR",TUpUser),"^",2),1:"")
 	set TStDate=$p(cfgData,"^",3)
	set TStDate=##class(websys.Conversions).DateLogicalToHtml(TStDate)
 	set TEndDate=$p(cfgData,"^",4)
	set TEndDate=##class(websys.Conversions).DateLogicalToHtml(TEndDate)
 	set TORACRowid=ORACRowid
	do OutputRefApp
	quit
    
OutputRefApp
	set Data=$lb(TArcicDesc,TArcicDr,TArcimDesc,TArcimRowid,TAPPFlag,TDate,TTime,TUser,TUpDate,TUpTime,TUpUser,TStDate,TEndDate,TORACRowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: 陈曦
/// CreatDate: 2014-04-15
/// Description: 插入可部分退费的医嘱子类或医嘱项
/// Debug: w ##class(web.DHCOPBillOrdRefundAppConfig).InsertOrdRefundAppConfig("81^11888||1^Y^^","1","2")
ClassMethod InsertOrdRefundAppConfig(InsertInfo As %String, UserId As %String, HospId As %String)
{
	new (InsertInfo, UserId, HospId)
	set ^TMP("InsertOrdRefundAppConfig")=$lb(InsertInfo, UserId, HospId)
	quit:(InsertInfo="") -1_"^"_"录入信息不能为空"
	quit:(UserId="") -1_"^"_"操作员不能为空"
	set ArcicDr=$p(InsertInfo,"^",1)
	quit:(ArcicDr="") -1_"^"_"医嘱子类不能为空"
	set ArcimRowid=$p(InsertInfo,"^",2)
	
	set rtn=0
	set errMsg=""
	
	set OldORACRowid=0
	while($o(^DHCJFOrderRefundAppConfig(0,"Arcic",ArcicDr,OldORACRowid))&&(rtn=0)) {
		set OldORACRowid=$o(^DHCJFOrderRefundAppConfig(0,"Arcic",ArcicDr,OldORACRowid))
		set cfgData=$g(^DHCJFOrderRefundAppConfig(OldORACRowid))
		set HospDR=$p(cfgData,"^",15)
		continue:(HospDR'=HospId)
		set OldArcimRowid=$p(cfgData,"^",2)
		if ((OldArcimRowid'="")&&(ArcimRowid'="")&&(ArcimRowid=OldArcimRowid)) {
			set rtn=-1
			set errMsg="该医嘱已经存在不能增加"
		}
		if (OldArcimRowid="") {
			set rtn=-1
			set errMsg="该医嘱子类已经存在不能增加"
		}
	}
	quit:(+rtn) rtn_"^"_errMsg

	set APPFlag=$p(InsertInfo,"^",3)
	quit:(APPFlag'="Y") -1_"^"_"请选择有效标识"
	
	set StDate=$p(InsertInfo,"^",4)
	set EndDate=$p(InsertInfo,"^",5)
	
	ts
	kill PLIST
	set PLIST(2)=ArcicDr
	set PLIST(3)=ArcimRowid
	set PLIST(4)=StDate
	set PLIST(5)=EndDate
	set PLIST(8)=UserId
	set PLIST(15)=APPFlag
	set PLIST(16)=HospId
	&sql(INSERT INTO DHC_JFOrderRefundAppConfig VALUES PLIST()) 
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn
	
	tc
	
	quit rtn
}

/// Creator: 陈曦
/// CreatDate: 2014-04-15
/// Description: 修改可部分退费的医嘱子类或医嘱项
/// Debug: w ##class(web.DHCOPBillOrdRefundAppConfig).UpdateOrdRefundAppConfig("1^^N^^","1","116")
ClassMethod UpdateOrdRefundAppConfig(UpdateInfo As %String, UserId As %String, ORACRowid As %String)
{
	new (UpdateInfo, UserId, ORACRowid)
	set ^TMP("UpdateOrdRefundAppConfig")=$lb(UpdateInfo, UserId, ORACRowid)

	quit:(UpdateInfo="") -1_"^"_"录入信息不能为空"
	quit:(UserId="") -1_"^"_"操作员不能为空"
	quit:(+ORACRowid=0) -1_"^"_"请选择要修改的记录"
	quit:('$d(^DHCJFOrderRefundAppConfig(ORACRowid))) -1_"^"_"医嘱子类不能为空"
	set ArcicDr=$p(UpdateInfo,"^",1)
	quit:(ArcicDr="") -1_"^"_"医嘱子类不能为空"
	set ArcimRowid=$p(UpdateInfo,"^",2)
	set APPFlag=$p(UpdateInfo,"^",3)
	set StDate=$p(UpdateInfo,"^",4)
	set EndDate=$p(UpdateInfo,"^",5)
	set HospId=$p($g(^DHCJFOrderRefundAppConfig(ORACRowid)),"^",15)
	set CurDate=+$h
	set CurTime=$p($h,",",2)
	
	set rtn=0
	set errMsg=""
	
	set OldORACRowid=0
	while($o(^DHCJFOrderRefundAppConfig(0,"Arcic",ArcicDr,OldORACRowid))&&(rtn=0)) {
		set OldORACRowid=$o(^DHCJFOrderRefundAppConfig(0,"Arcic",ArcicDr,OldORACRowid))
		set cfgData=$g(^DHCJFOrderRefundAppConfig(OldORACRowid))
		continue:(OldORACRowid=ORACRowid)
		set HospDR=$p(cfgData,"^",15)
		continue:(HospDR'=HospId)
		set OldArcimRowid=$p(cfgData,"^",2)
		if ((OldArcimRowid'="")&&(ArcimRowid'="")&&(ArcimRowid=OldArcimRowid)) {
			set rtn=-1
			set errMsg="该医嘱已经存在"
		}
		if (OldArcimRowid="") {
			set rtn=-1
			set errMsg="该医嘱子类已经存在"
		}
	}
	quit:(+rtn) rtn_"^"_errMsg

	ts
  
	&sql(UPDATE DHC_JFOrderRefundAppConfig
        SET ORAC_Arcic_DR=:ArcicDr,
        	ORAC_Arcim_DR=:ArcimRowid,
        	ORAC_StDate=:StDate,
            ORAC_EndDate=:EndDate,
            ORAC_UpDate=:CurDate,
            ORAC_UpTime=:CurTime,
            ORAC_UpUser_DR=:UserId,
            ORAC_Flag=:APPFlag
        WHERE ORAC_Rowid=:ORACRowid)
    set rtn=SQLCODE
	if (+rtn) tro  quit rtn
	
	tc

	quit rtn
}

}
