Import SQLUSER

/// Creator: TangTao
/// CreateDate:	2013-01-13
/// Function: 欠费管理
Class DHCBILLConfig.DHCBILLArrears Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindALType")
Query FindALType() As websys.Query(ROWSPEC = "TALTypeCode:%String,TALTypeDesc:%String")
{
}

ClassMethod FindALTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set rtn=$$OPENArrearsLevelType^DHCJFARREARSM()
    If (+rtn) Quit $$$OK
    Set ROW=0
	Do{
		Set rtn=$$FETCHArrearsLevelType^DHCJFARREARSM()
		Do GetALType
	}While(rtn=0)
	Do CLOSE^DHCJFARREARSM()
	Quit $$$OK
GetALType
	Quit:'$d(PLIST)
	Set ALTypeInfo=PLIST(1)
	Set ALTypeCode=$p(ALTypeInfo,"^",1)
	Set ALTypeDesc=$p(ALTypeInfo,"^",2)
	Do OutputALType
	Quit
OutputALType
	Set Data=$lb(ALTypeCode,ALTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindArrearsLevel", 2)
Query FindArrearsLevel(HospId As %String) As websys.Query(ROWSPEC = "JFALRowID:%String,JFALCode:%String,JFALDesc:%String,JFALType:%String,JFALOrderEntry:%String,JFALOrderExecute:%String,JFALFlag:%String,JFALLimitPrice:%String,JFALOrdCatReverse:%String,JFALTtpe1:%String,JFALOrderEntry1:%String,JFALOrderExecute1:%String,JFALFlag1:%String,JFALOrdCatReverse1:%String,JFALHospId:%String")
{
}

ClassMethod FindArrearsLevelExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
	Set rtn=$$OPEN^DHCJFARREARSLEVEL()
	If (+rtn) Quit $$$OK
	Do{
		Set rtn=$$FETCH^DHCJFARREARSLEVEL()
	    Do GetArrearsInfo
	}while(rtn=0)
    Set rtn=$$CLOSE^DHCJFARREARSLEVEL()
	Quit $$$OK
GetArrearsInfo
	Quit:$d(PLIST)=0
	Quit:(PLIST=1)
	Set JFALHospDR=PLIST(19)
	Quit:(JFALHospDR'=HospId)
	Set JFALRowID=PLIST(1)
	Set JFALCode=PLIST(2)	;级别名称
	Set JFALDesc=PLIST(3)	;级别描述
	Set JFALTtpe1=PLIST(4)
	Set JFALType=$$getArrearsLevelType^DHCJFARREARSM(PLIST(4))	;级别类型
	Set JFALOrderEntry1=PLIST(5)	;是否允许录入医嘱
	Set JFALOrderEntry=$Case(JFALOrderEntry1,"N":"不允许","Y":"允许",:JFALOrderEntry1)
	Set JFALOrderExecute1=PLIST(6)	;是否允许执行医嘱
	Set JFALOrderExecute=$Case(JFALOrderExecute1,"N":"不允许","Y":"允许",:JFALOrderExecute1)
	Set JFALFlag1=PLIST(7)	;是否可以发药
	Set JFALFlag=$Case(JFALFlag1,"N":"不允许","Y":"允许",:JFALFlag1)
	Set JFALLimitPrice=PLIST(8)	;限价
	Set JFALLimitPrice=$s((((+JFALLimitPrice'=0)&&($zabs(JFALLimitPrice)<1))):($p(JFALLimitPrice,".")_"0."_$p(JFALLimitPrice,".",2)),1:JFALLimitPrice)
	Set JFALLimitPrice2=PLIST(9)
	Set JFALOrdCatReverse1=PLIST(10)	;医嘱分类反向
	Set JFALOrdCatReverse=$Case(JFALOrdCatReverse1,"N":"不允许","Y":"允许",:JFALOrdCatReverse1)
	Set JFALUserDr=PLIST(11)	;添加人
	Set JFALDate=##class(websys.Conversions).DateLogicalToHtml(PLIST(12))		;添加日期
	Set JFALTime=##class(websys.Conversions).TimeLogicalToHtml(PLIST(13))		;添加时间
	Set JFALUpdateUserDr=PLIST(14)	;修改人
	Set JFALUpdateDate=PLIST(15)	;修改日期
	Set JFALUpdateTime=PLIST(16)	;修改时间
	Set JFALDateFrom=PLIST(17)	    ;开始日期
	Set JFALDateTo=PLIST(18)	    ;开始时间
	Do OutputArrearsLevel
	Quit
OutputArrearsLevel
	Set Data=$lb(JFALRowID,JFALCode,JFALDesc,JFALType,JFALOrderEntry,JFALOrderExecute,JFALFlag,JFALLimitPrice,JFALOrdCatReverse,JFALTtpe1,JFALOrderEntry1,JFALOrderExecute1,JFALFlag1,JFALOrdCatReverse1,JFALHospDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// w ##class(DHCBILLConfig.DHCBILLArrears).InsertArrearsLevel("^预计^^W^N^N^^N^Y^2","1")
ClassMethod InsertArrearsLevel(LevelInfo As %String, Guser As %String) As %String
{
	New (LevelInfo, Guser)
	set ^TMP("InsertArrearsLevel")=$lb(LevelInfo, Guser)
	Set JFALCode=$p(LevelInfo,"^",2)
	Set JFALDesc=$p(LevelInfo,"^",3)
	Set JFALType=$p(LevelInfo,"^",4)
	Set JFALOrderEntry=$p(LevelInfo,"^",5)
	Set JFALOrderExecute=$p(LevelInfo,"^",6)
	Set JFALLimitPrice=$p(LevelInfo,"^",7)
	Set JFALFlag=$p(LevelInfo,"^",8)
	Set JFALOrdCatReverse=$p(LevelInfo,"^",9)
	Set JFALHospId=$p(LevelInfo,"^",10)
	
	Set CurDate=+$h
	Set CurTime=$p($h,",",2)
	
	Kill PLIST
	Set PLIST(2)=JFALCode
	Set PLIST(3)=JFALDesc
	Set PLIST(4)=JFALType
	Set PLIST(5)=JFALOrderEntry
	Set PLIST(6)=JFALOrderExecute
	Set PLIST(7)=JFALFlag
	Set PLIST(8)=JFALLimitPrice
	Set PLIST(9)=""
	Set PLIST(10)=JFALOrdCatReverse
	Set PLIST(11)=Guser
	Set PLIST(12)=CurDate
	Set PLIST(13)=CurTime
	Set PLIST(14)=Guser
	Set PLIST(15)=CurDate
	Set PLIST(16)=CurTime
	Set PLIST(19)=JFALHospId
	Set rtn=$$INSERT^DHCJFARREARSLEVEL()
	If (rtn=-100) Set rtn="-100^级别名称重复"

	If (+rtn=0) Do
	.Set Flag2="DHC_JFArrearsLevel",UserTable="User.DHCJFArrearsLevel",TableDesc="欠费控制级别",InsRowid=%ROWID
	.Set JsonStr="{JFALRowID:"_InsRowid_",JFALCode:"_JFALCode_",JFALDesc:"_JFALDesc
	.Set JsonStr=JsonStr_",JFALType:"_JFALType_",JFALOrderEntry:"_JFALOrderEntry_",JFALOrderExecute:"_JFALOrderExecute
	.Set JsonStr=JsonStr_",JFALFlag:"_JFALFlag_",JFALLimitPrice:"_JFALLimitPrice_",JFALLimitPrice2:"_""
	.Set JsonStr=JsonStr_",JFALOrdCatReverse:"_JFALOrdCatReverse_",JFALUserDr:"_Guser
	.Set JsonStr=JsonStr_",JFALDate:"_CurDate_",JFALTime:"_CurTime
	.Set JsonStr=JsonStr_",JFALUpdateUserDr:"_Guser_",JFALUpdateDate:"_CurDate
	.Set JsonStr=JsonStr_",JFALUpdateTime:"_CurTime_",JFALDateFrom:"_""
	.Set JsonStr=JsonStr_",JFALDateTo:"_""_"}"
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

	Quit """"_rtn_""""
}

ClassMethod UpdateArrearsLevel(LevelInfo, Guser)
{
	New (LevelInfo, Guser)

	Set JFALRowID=$p(LevelInfo,"^",1)
	Set JFALCode=$p(LevelInfo,"^",2)
	Set JFALDesc=$p(LevelInfo,"^",3)
	Set JFALType=$p(LevelInfo,"^",4)
	Set JFALOrderEntry=$p(LevelInfo,"^",5)
	Set JFALOrderExecute=$p(LevelInfo,"^",6)
	Set JFALLimitPrice=$p(LevelInfo,"^",7)
	Set JFALFlag=$p(LevelInfo,"^",8)
	Set JFALOrdCatReverse=$p(LevelInfo,"^",9)
	Set JFALHospId=$p(LevelInfo,"^",10)
	Set CurDate=+$h
	Set CurTime=$p($h,",",2)
	
	Set OldJFALCode=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",1)
	Set OldJFALDesc=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",2)
	Set OldJFALType=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",3)
	Set OldJFALOrderEntry=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",4)
	Set OldJFALOrderExecute=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",5)
	Set OldJFALFlag=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",6)
	Set OldJFALLimitPrice=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",7)
	Set OldJFALLimitPrice2=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",8)
	Set OldJFALOrdCatReverse=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",9)
	Set OldGuser=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",10)
	Set OldCurDate=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",11)
	Set OldCurTime=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",12)
	Set OldUPGuser=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",13)
	Set OldUPCurDate=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",14)
	Set OldUPCurTime=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",15)
	Set OldDateFrom=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",16)
	Set OldDateTo=$p(^DHCJFARREARSLEVEL(JFALRowID),"^",17)

	Kill PLIST
	Set PLIST(2)=JFALCode
	Set PLIST(3)=JFALDesc
	Set PLIST(4)=JFALType
	Set PLIST(5)=JFALOrderEntry
	Set PLIST(6)=JFALOrderExecute
	Set PLIST(7)=JFALFlag
	Set PLIST(8)=JFALLimitPrice
	Set PLIST(9)=""
	Set PLIST(10)=JFALOrdCatReverse
	Set PLIST(11)=Guser
	Set PLIST(12)=CurDate
	Set PLIST(13)=CurTime
	Set PLIST(14)=Guser
	Set PLIST(15)=CurDate
	Set PLIST(16)=CurTime
	Set PLIST(19)=JFALHospId
	Set rtn=$$UPDATE^DHCJFARREARSLEVEL(JFALRowID)
	If (rtn=-100) Set rtn="-100^级别名称重复"
	
	If (+rtn=0) Do
	.Set Flag2="DHC_JFArrearsLevel",UserTable="User.DHCJFArrearsLevel",TableDesc="欠费控制级别",InsRowid=JFALRowID
	.Set JsonStr="{JFALRowID:"_InsRowid_",JFALCode:"_JFALCode_",JFALDesc:"_JFALDesc
	.Set JsonStr=JsonStr_",JFALType:"_JFALType_",JFALOrderEntry:"_JFALOrderEntry_",JFALOrderExecute:"_JFALOrderExecute
	.Set JsonStr=JsonStr_",JFALFlag:"_JFALFlag_",JFALLimitPrice:"_JFALLimitPrice_",JFALLimitPrice2:"_""
	.Set JsonStr=JsonStr_",JFALOrdCatReverse:"_JFALOrdCatReverse_",JFALUserDr:"_Guser
	.Set JsonStr=JsonStr_",JFALDate:"_CurDate_",JFALTime:"_CurTime
	.Set JsonStr=JsonStr_",JFALUpdateUserDr:"_Guser_",JFALUpdateDate:"_CurDate
	.Set JsonStr=JsonStr_",JFALUpdateTime:"_CurTime_",JFALDateFrom:"_""
	.Set JsonStr=JsonStr_",JFALDateTo:"_""_"}" 

	.Set JsonStrOld="{JFALRowID:"_InsRowid_",JFALCode:"_OldJFALCode_",JFALDesc:"_OldJFALDesc
	.Set JsonStrOld=JsonStrOld_",JFALType:"_OldJFALType_",JFALOrderEntry:"_OldJFALOrderEntry_",JFALOrderExecute:"_OldJFALOrderExecute
	.Set JsonStrOld=JsonStrOld_",JFALFlag:"_OldJFALFlag_",JFALLimitPrice:"_OldJFALLimitPrice_",JFALLimitPrice2:"_OldJFALLimitPrice2
	.Set JsonStrOld=JsonStrOld_",JFALOrdCatReverse:"_OldJFALOrdCatReverse_",JFALUserDr:"_OldGuser
	.Set JsonStrOld=JsonStrOld_",JFALDate:"_OldCurDate_",JFALTime:"_OldCurTime
	.Set JsonStrOld=JsonStrOld_",JFALUpdateUserDr:"_OldUPGuser_",JFALUpdateDate:"_OldUPCurDate
	.Set JsonStrOld=JsonStrOld_",JFALUpdateTime:"_OldUPCurTime_",JFALDateFrom:"_OldDateFrom
	.Set JsonStrOld=JsonStrOld_",JFALDateTo:"_OldDateTo_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit """"_rtn_""""
}

/// w ##class(DHCBILLConfig.DHCBILLArrears).DeleteArrearsLevel("3^完全控制^完全控制描述^^不允许^不允许^^不允许^允许","","2")
ClassMethod DeleteArrearsLevel(LevelInfo, Guser)
{
	New (LevelInfo, Guser)
	Set ^TMP("DeleteArrearsLevel")=$lb(LevelInfo, Guser)
	Set JFALRowID=$p(LevelInfo,"^",1)
	
	Set rtn=$$SELECT^DHCJFARREARSLEVEL(JFALRowID)
	Set JFALCode=PLIST(2)
	Set JFALDesc=PLIST(3)
	Set JFALType=PLIST(4)
	Set JFALOrderEntry=PLIST(5)
	Set JFALOrderExecute=PLIST(6)
	Set JFALFlag=PLIST(7)
	Set JFALLimitPrice=PLIST(8)
	Set JFALOrdCatReverse=PLIST(10)
	Set JFALGuser=PLIST(11)
	Set JFALDate=PLIST(12)
	Set JFALTime=PLIST(13)
	Set JFALUPGuser=PLIST(14)
	Set JFALUPDate=PLIST(15)
	Set JFALUPTime=PLIST(16)

	Set rtn=$$DELETE^DHCJFARREARSLEVEL(JFALRowID)

	If (+rtn=0) Do
	.Set Flag2="DHC_JFArrearsLevel",UserTable="User.DHCJFArrearsLevel",TableDesc="欠费控制级别",InsRowid=JFALRowID
	.Set JsonStr="{JFALRowID:"_InsRowid_",JFALCode:"_JFALCode_",JFALDesc:"_JFALDesc
	.Set JsonStr=JsonStr_",JFALType:"_JFALType_",JFALOrderEntry:"_JFALOrderEntry_",JFALOrderExecute:"_JFALOrderExecute
	.Set JsonStr=JsonStr_",JFALFlag:"_JFALFlag_",JFALLimitPrice:"_JFALLimitPrice_",JFALLimitPrice2:"_""
	.Set JsonStr=JsonStr_",JFALOrdCatReverse:"_JFALOrdCatReverse_",JFALUserDr:"_JFALGuser
	.Set JsonStr=JsonStr_",JFALDate:"_JFALDate_",JFALTime:"_JFALTime
	.Set JsonStr=JsonStr_",JFALUpdateUserDr:"_JFALUPGuser_",JFALUpdateDate:"_JFALUPDate
	.Set JsonStr=JsonStr_",JFALUpdateTime:"_JFALUPTime_",JFALDateFrom:"_""
	.Set JsonStr=JsonStr_",JFALDateTo:"_""_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "删除", "D", JsonStr)

	Quit """"_rtn_""""
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindArrearsLocExpt")
Query FindArrearsLocExpt(HospId As %String) As websys.Query(ROWSPEC = "JFALERowID:%String,JFALELocDesc:%String,JFALEDateFrom:%String,JFALEDateTo:%String,JFALELocDR:%String")
{
}

ClassMethod FindArrearsLocExptExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
	Set rtn=$$OPEN^DHCJFARREARSLOCEXCEPT()
	If (+rtn) Quit $$$OK
	Do{
		Set rtn=$$FETCH^DHCJFARREARSLOCEXCEPT()
	    Do GetLocExpt
	}While(rtn=0)
    Set rtn=$$CLOSE^DHCJFARREARSLEVEL()
	Quit $$$OK
GetLocExpt
	Quit:$d(PLIST)=0
	Quit:PLIST=1
	Set JFALERowID=PLIST(1)
	Set JFALELocDR=PLIST(2)
	Set JFALELocDesc=JFALELocDR
	If (JFALELocDR'="") Set JFALELocDesc=$p(^CTLOC(JFALELocDR),"^",2)
	Set JFALEDateFrom=PLIST(3)
	If (JFALEDateFrom'="") Set JFALEDateFrom=##class(websys.Conversions).DateLogicalToHtml(JFALEDateFrom)
	Set JFALEDateTo=PLIST(4)
	If (JFALEDateTo'="") Set JFALEDateTo=##class(websys.Conversions).DateLogicalToHtml(JFALEDateTo)
	Set JFALEUserDR=PLIST(5)
	Set JFALEDate=PLIST(6)
	Set JFALETime=PLIST(7)
	Set JFHospDR=PLIST(8)
	Quit:(HospId'=JFHospDR)
	Do OutputLocExpt
	Quit
OutputLocExpt
	Set Data=$lb(JFALERowID,JFALELocDesc,JFALEDateFrom,JFALEDateTo,JFALELocDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindLoc", "")
Query FindLoc(desc As %String, hospId As %String) As websys.Query(ROWSPEC = "LocRowid:%String,LocDesc:%String")
{
}

ClassMethod FindLocExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    If (desc'="") Set desc=$$ALPHAUP^SSUTIL4(desc)
    
    Set rowid=0
    For  Set rowid=$o(^CTLOC(rowid)) Quit:(rowid="")  Do
	.Set locData=$g(^CTLOC(rowid))
	.Quit:(locData="")
	.Set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", rowid, hospId)
	.Quit:(showFlag="N")
    .Set locType=$p(locData,"^",13)
    .//Quit:(" E OP W "'[(" "_locType_" "))
	.Set dateFrom=$p(locData,"^",24)
	.Set dateTo=$p(locData,"^",25)
	.Quit:((dateFrom'="")&&(dateFrom>+$h))
	.Quit:((dateTo'="")&&(dateTo<+$h))      //过滤不在有效期的
    .Set contactName=$p(locData,"^",43)     //科室检索码
    .Set locDesc=$p(locData,"^",2)
    .Quit:((desc'="")&&($$ALPHAUP^SSUTIL4(contactName)'[desc)&&($$ALPHAUP^SSUTIL4(locDesc)'[desc))
	.Do OutputLoc
	
	Quit $$$OK
OutputLoc
	Set Data=$lb(rowid,locDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// w ##class(DHCBILLConfig.DHCBILLArrears).InsertArrearsLevel("^预警1^预警1^W^Y^Y^1212121^Y^N",1,2)
ClassMethod InsertArrearsLocExpt(LocExptInfo, Guser, HospID)
{
	New (LocExptInfo, Guser, HospID)
	Set JFALERowID=""
	Set JFALELocDR=$p(LocExptInfo,"^",2)
	Set JFALEDateFrom=$p(LocExptInfo,"^",3)
	Set JFALEDateTo=$p(LocExptInfo,"^",4)
	Set JFALEDateFrom=##class(websys.Conversions).DateHtmlToLogical(JFALEDateFrom)
	Set JFALEDateTo=##class(websys.Conversions).DateHtmlToLogical(JFALEDateTo)

	Kill PLIST
	Set PLIST(2)=JFALELocDR
	Set PLIST(3)=JFALEDateFrom
	Set PLIST(4)=JFALEDateTo
	Set PLIST(5)=Guser
	Set PLIST(6)=+$h
	Set PLIST(7)=$p($h,",",2)
	Set PLIST(8)=HospID
	Set rtn=$$INSERT^DHCJFARREARSLOCEXCEPT()
	If (rtn=-100) Set rtn="-100^科室重复"
	
	If +rtn=0 Do
	.Set Flag2="DHC_JFARREARSLOCEXCEPT",UserTable="User.DHCJFArrearsLocExcept",TableDesc="欠费管理不受控制科室",InsRowid=%ROWID
	.Set JsonStr="{JFALERowID:"_InsRowid_",JFALELocDR:"_JFALELocDR_",JFALEDateFrom:"_JFALEDateFrom
	.Set JsonStr=JsonStr_",JFALEDateTo:"_JFALEDateTo_",JFALEUserDR:"_Guser_",JFALEDate:"_+$h
	.Set JsonStr=JsonStr_",JFALETime:"_$p($h,",",2)_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

	Quit """"_rtn_""""
}

ClassMethod UpdateArrearsLocExpt(LocExptInfo, Guser)
{
	New (LocExptInfo, Guser)
	Set JFALERowID=$p(LocExptInfo,"^",1)
	Set JFALELocDR=$p(LocExptInfo,"^",2)
	Set JFALEDateFrom=$p(LocExptInfo,"^",3)
	Set JFALEDateTo=$p(LocExptInfo,"^",4)
	Set JFALEDateFrom=##class(websys.Conversions).DateHtmlToLogical(JFALEDateFrom)
	Set JFALEDateTo=##class(websys.Conversions).DateHtmlToLogical(JFALEDateTo)
	
	Set OldJFALELocDR=$p(^DHCJFARREARSLOCEXCEPT(JFALERowID),"^",1)
	Set OldJFALEDateFrom=$p(^DHCJFARREARSLOCEXCEPT(JFALERowID),"^",2)
	Set OldJFALEDateTo=$p(^DHCJFARREARSLOCEXCEPT(JFALERowID),"^",3)
	Set OldGuser=$p(^DHCJFARREARSLOCEXCEPT(JFALERowID),"^",4)
	Set OldDate=$p(^DHCJFARREARSLOCEXCEPT(JFALERowID),"^",5)
	Set OldTime=$p(^DHCJFARREARSLOCEXCEPT(JFALERowID),"^",6)
	
	Kill PLIST
	Set PLIST(2)=JFALELocDR
	Set PLIST(3)=JFALEDateFrom
	Set PLIST(4)=JFALEDateTo
	Set PLIST(5)=Guser
	Set PLIST(6)=+$h
	Set PLIST(7)=$p($h,",",2)
	
	Set rtn=$$UPDATE^DHCJFARREARSLOCEXCEPT(JFALERowID)
	If (rtn=-100) Set rtn="-100^科室重复"
	
	If (+rtn=0) Do
	.Set Flag2="DHC_JFARREARSLOCEXCEPT",UserTable="User.DHCJFArrearsLocExcept",TableDesc="欠费管理不受控制科室",InsRowid=JFALERowID
	.Set JsonStr="{JFALERowID:"_InsRowid_",JFALELocDR:"_JFALELocDR_",JFALEDateFrom:"_JFALEDateFrom
	.Set JsonStr=JsonStr_",JFALEDateTo:"_JFALEDateTo_",JFALEUserDR:"_Guser_",JFALEDate:"_+$h
	.Set JsonStr=JsonStr_",JFALETime:"_$p($h,",",2)_"}" 

	.Set JsonStrOld="{JFALERowID:"_InsRowid_",JFALELocDR:"_OldJFALELocDR_",JFALEDateFrom:"_OldJFALEDateFrom
	.Set JsonStrOld=JsonStrOld_",JFALEDateTo:"_OldJFALEDateTo_",JFALEUserDR:"_OldGuser_",JFALEDate:"_OldDate
	.Set JsonStrOld=JsonStrOld_",JFALETime:"_OldTime_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit """"_rtn_""""
}

ClassMethod DeleteArrearsLocExpt(LocExptInfo, Guser)
{
	New (LocExptInfo, Guser)
	Set JFALERowID=$p(LocExptInfo,"^",1)
	
	Set rtn=$$SELECT^DHCJFARREARSLOCEXCEPT(JFALERowID)
	Set JFALELocDR=PLIST(2)
	Set JFALEDateFrom=PLIST(2)
	Set JFALEDateTo=PLIST(2)
	Set JFALEUserDR=PLIST(2)
	Set JFALEDate=PLIST(6)
	Set JFALETime=PLIST(7)
	
	Set rtn=$$DELETE^DHCJFARREARSLOCEXCEPT(JFALERowID)
	
	If (+rtn=0) Do
	.Set Flag2="DHC_JFARREARSLOCEXCEPT",UserTable="User.DHCJFArrearsLocExcept",TableDesc="欠费管理不受控制科室",InsRowid=JFALERowID
	.Set JsonStr="{JFALERowID:"_InsRowid_",JFALELocDR:"_JFALELocDR_",JFALEDateFrom:"_JFALEDateFrom
	.Set JsonStr=JsonStr_",JFALEDateTo:"_JFALEDateTo_",JFALEUserDR:"_JFALEUserDR_",JFALEDate:"_JFALEDate
	.Set JsonStr=JsonStr_",JFALETime:"_JFALETime_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "删除", "D", JsonStr)

	Quit """"_rtn_""""
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindAdmCat")
Query FindAdmCat() As websys.Query(ROWSPEC = "TAdmCatRowid:%String,TAdmCatDesc:%String")
{
}

ClassMethod FindAdmCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set rowid="0"
    For  Set rowid=$o(^PAC("ADMCAT",rowid)) Quit:(rowid="")  Do 
    .Set code=$p(^PAC("ADMCAT",rowid),"^",1)
    .Set desc=$p(^PAC("ADMCAT",rowid),"^",2)
	.Do OutputAdmCat
	Quit $$$OK
OutputAdmCat
	set Data=$lb(rowid,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindArrears","2")
Query FindArrears(AdmCat As %String, HospId As %String) As websys.Query(ROWSPEC = "TJFARowID:%String,TJFAAdmReasonDr:%String,TJFAAdmReasonDesc:%String,TJFAAdmType:%String,TJFAAdmTypeDesc:%String,TJFADiaCatDr:%String,TJFADiaCatDesc:%String,TJFALocDr:%String,TJFALocDesc:%String,TJFAWardDr:%String,TJFAWardDesc:%String,TJFAEPSDr:%String,TJFAEPSDesc:%String,TJFAEHospDr:%String")
{
}

ClassMethod FindArrearsExecute(ByRef qHandle As %Binary, AdmCat As %String, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    If (AdmCat="")  Quit $$$OK
	Set rtn=$$getArrearsByAdmCat^DHCJFARREARSM(AdmCat)
	If (rtn=0) Quit $$$OK
	
	For i=1:1:rtn Do
	.Set ArrearsInfo=PLIST(i)
	.Set JFARowID=$p(ArrearsInfo,$c(2),1)
	.Set JFAAdmCatDr=$p(^DHCJFARREARS(JFARowID),"^",1)
	.Set JFAGreenWay=$p(^DHCJFARREARS(JFARowID),"^",2)
	.Set JFAAdmReasonDr=$p(ArrearsInfo,$c(2),3)
	.Set JFAAdmReasonDesc=$p(ArrearsInfo,$c(2),2)
	.Set JFAAdmType=$p(ArrearsInfo,$c(2),5)
	.Set JFAAdmTypeDesc=$p(ArrearsInfo,$c(2),4)
	.Set JFADiaCatDr=$p(ArrearsInfo,$c(2),7)
	.Set JFADiaCatDesc=$p(ArrearsInfo,$c(2),6)
	.Set JFALocDr=$p(ArrearsInfo,$c(2),9)
	.Set JFALocDesc=$p(ArrearsInfo,$c(2),8)
	.Set JFAWardDr=$p(ArrearsInfo,$c(2),11)
	.Set JFAWardDesc=$p(ArrearsInfo,$c(2),10)
	.Set JFAFlag=$p(^DHCJFARREARS(JFARowID),"^",8)
	.Set JFADesc=$p(^DHCJFARREARS(JFARowID),"^",9)
	.Set JFARemark=$p(^DHCJFARREARS(JFARowID),"^",10)
	.Set JFAUserDr=$p(^DHCJFARREARS(JFARowID),"^",11)
	.Set JFADate=$p(^DHCJFARREARS(JFARowID),"^",12)
	.Set JFATime=$p(^DHCJFARREARS(JFARowID),"^",13)
	.Set JFAUpdateUserDr=$p(^DHCJFARREARS(JFARowID),"^",14)
	.Set JFAUpdateDate=$p(^DHCJFARREARS(JFARowID),"^",15)
	.Set JFAUpdateTime=$p(^DHCJFARREARS(JFARowID),"^",16)
	.Set JFADateFrom=$p(^DHCJFARREARS(JFARowID),"^",17)
	.Set JFADateTo=$p(^DHCJFARREARS(JFARowID),"^",18)
	.Set JFAEHospDr=$p(^DHCJFARREARS(JFARowID),"^",20)
	.Quit:(HospId'=JFAEHospDr)
	.Set JFAEPSDr=$p(ArrearsInfo,$c(2),13)
	.Set JFAEPSDesc=$p(ArrearsInfo,$c(2),12)
	.Do OutputArrears
    Set rtn=$$CLOSE^DHCJFARREARSM()
	Quit $$$OK
OutputArrears
	Set Data=$lb(JFARowID,JFAAdmReasonDr,JFAAdmReasonDesc,JFAAdmType,JFAAdmTypeDesc,JFADiaCatDr,JFADiaCatDesc,JFALocDr,JFALocDesc,JFAWardDr,JFAWardDesc,JFAEPSDr,JFAEPSDesc,JFAEHospDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindAdmType")
Query FindAdmType() As websys.Query(ROWSPEC = "TAdmTypeCode:%String,TAdmTypeDesc:%String")
{
}

ClassMethod FindAdmTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set rtn=$$OPENAdmType^DHCJFBILLPOLICYM()
    If (+rtn) Quit $$$OK
    Set ROW=0
	Do{
		Set rtn=$$FETCHAdmType^DHCJFBILLPOLICYM()
		Do GetAdmType
	}while(rtn=0)
	Quit $$$OK
GetAdmType
	Quit:'$d(PLIST)
	Set AdmTypeInfo=PLIST(1)
	Set AdmTypeCode=$p(AdmTypeInfo,"^",1)
	Set AdmTypeDesc=$p(AdmTypeInfo,"^",2)
	Do OutputAdmType
	Quit
OutputAdmType
	Set Data=$lb(AdmTypeCode,AdmTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindDiaCat")
Query FindDiaCat() As websys.Query(ROWSPEC = "TDiaCatRowid:%String,TDiaCatDesc:%String")
{
}

ClassMethod FindDiaCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set rowid="0"
    For  Set rowid=$o(^DHCDiagnosCat(rowid)) Quit:rowid=""  Do
    .Set desc=$p(^DHCDiagnosCat(rowid),"^",1)
	.Do OutputDiaCat
	Quit $$$OK
OutputDiaCat
	set Data=$lb(rowid,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindAdmLoc", "JZNKMZ")
Query FindAdmLoc(desc As %String, hospId As %String) As websys.Query(ROWSPEC = "TAdmLocRowid:%String,TAdmLocDesc:%String")
{
}

ClassMethod FindAdmLocExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    If (desc'="") Set desc=$$ALPHAUP^SSUTIL4(desc)

    Set rowid=0
    For  Set rowid=$o(^PAC("ADMLOC",rowid)) Quit:(rowid="")  Do
    .Set locDR=$p(^PAC("ADMLOC",rowid),"^",2)
 	.Set locData=$g(^CTLOC(locDR))
	.Quit:(locData="")
	.Set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", locDR, hospId)
	.Quit:(showFlag="N")
	.Set dateFrom=$p(locData,"^",24)
	.Set dateTo=$p(locData,"^",25)
	.Quit:((dateFrom'="")&&(dateFrom>+$h))
	.Quit:((dateTo'="")&&(dateTo<+$h))          //+2018-01-16 ZhYW 过滤不在有效期的
 	.Set contactName=$p(locData,"^",43)     //科室检索码
    .Set locDesc=$p(locData,"^",2)
    .Quit:((desc'="")&&($$ALPHAUP^SSUTIL4(contactName)'[desc)&&($$ALPHAUP^SSUTIL4(locDesc)'[desc))
	.Do OutputAdmLoc
	
	Quit $$$OK
OutputAdmLoc
	Set Data=$lb(locDR,locDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

Query FindWard(desc As %String, hospId As %String) As websys.Query(ROWSPEC = "TWardRowid:%String,TWardDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindWard", "", 2)
ClassMethod FindWardExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
	If (desc'="") Set desc=$$ALPHAUP^SSUTIL4(desc)
	
    Set rowId=0
    For  Set rowId=$o(^PAWARD(rowId)) Quit:(+rowId=0)  Do
    .Set wardData=$g(^PAWARD(rowId))
    .Quit:(wardData="")
    .Set locationDR=$p(wardData,"^",5)
    .Quit:(+locationDR=0)
	.Set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", locationDR, hospId)
	.Quit:(showFlag="N")
	.Set locData=$g(^CTLOC(locationDR))
	.Set dateFrom=$p(locData,"^",24)
	.Set dateTo=$p(locData,"^",25)
	.Quit:((dateFrom'="")&&(dateFrom>+$h))
	.Quit:((dateTo'="")&&(dateTo<+$h))      //过滤不在有效期的
    .Set contactName=$p(locData,"^",43)    //科室检索码
    .Set wardDesc=$p(wardData,"^",2)
    .Quit:((desc'="")&&($$ALPHAUP^SSUTIL4(contactName)'[desc)&&(wardDesc'[desc))
	.Do OutputRowWard
	
	Quit $$$OK
OutputRowWard
	Set Data=$lb(rowId,wardDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod InsertArrears(ArrearsInfo, Guser, HospId)
{
	New (ArrearsInfo, Guser, HospId)
	//Set JFARowID=$p(ArrearsInfo,"^",1)
	Set JFAAdmCatDr=$p(ArrearsInfo,"^",2)
	Quit:(JFAAdmCatDr="") """"_"通道不能为空"_""""
	Set JFAEPSDr=$p(ArrearsInfo,"^",3)
	Set JFAAdmReasonDr=$p(ArrearsInfo,"^",4)
	Quit:(JFAAdmReasonDr="") """"_"收费类型为空"_""""
	Set JFAAdmType=$p(ArrearsInfo,"^",5)
	Set JFADiaCatDr=$p(ArrearsInfo,"^",6)
	Set JFALocDr=$p(ArrearsInfo,"^",7)
	Set JFAWardDr=$p(ArrearsInfo,"^",8)
	Set JFAGreenWay="N"
	Set JFAFlag=""
	Set JFADesc=""
	Set JFARemark=""
	Set JFAUserDr=Guser
	Set JFADate=+$h
	Set JFATime=$p($h,",",2)
	Set JFAUpdateUserDr=Guser
	Set JFAUpdateDate=+$h
	Set JFAUpdateTime=$p($h,",",2)
	Set JFADateFrom=""
	Set JFADateTo=""

	Kill PLIST
	Set PLIST(2)=JFAAdmCatDr
	Set PLIST(3)=JFAGreenWay
	Set PLIST(4)=JFAAdmReasonDr
	Set PLIST(5)=JFAAdmType
	Set PLIST(6)=JFADiaCatDr
	Set PLIST(7)=JFALocDr
	Set PLIST(8)=JFAWardDr
	Set PLIST(9)=JFAFlag
	Set PLIST(10)=JFADesc
	Set PLIST(11)=JFARemark
	Set PLIST(12)=JFAUserDr
	Set PLIST(13)=JFADate
	Set PLIST(14)=JFATime
	Set PLIST(15)=JFAUpdateUserDr
	Set PLIST(16)=JFAUpdateDate
	Set PLIST(17)=JFAUpdateTime
	Set PLIST(18)=JFADateFrom
	Set PLIST(19)=JFADateTo
	Set PLIST(20)=JFAEPSDr
	Set PLIST(21)=HospId
	Set rtn=$$INSERT^DHCJFARREARS()
	
	If (+rtn=0) Do
	.Set Flag2="DHC_JFARREARS",UserTable="User.DHCJFArrears",TableDesc="非绿色通道欠费额度",InsRowid=%ROWID
	.Set JsonStr="{JFARowID:"_InsRowid_",JFAAdmCatDr:"_JFAAdmCatDr_",JFAGreenWay:"_JFAGreenWay
	.Set JsonStr=JsonStr_",JFAAdmReasonDr:"_JFAAdmReasonDr_",JFAAdmType:"_JFAAdmType_",JFADiaCatDr:"_JFADiaCatDr
	.Set JsonStr=JsonStr_",JFALocDr:"_JFALocDr_",JFAWardDr:"_JFAWardDr_",JFAFlag:"_JFAFlag
	.Set JsonStr=JsonStr_",JFADesc:"_JFADesc_",JFARemark:"_JFARemark_",JFAUserDr:"_JFAUserDr
	.Set JsonStr=JsonStr_",JFADate:"_JFADate_",JFATime:"_JFATime_",JFAUpdateUserDr:"_JFAUpdateUserDr
	.Set JsonStr=JsonStr_",JFAUpdateDate:"_JFAUpdateDate_",JFAUpdateTime:"_JFAUpdateTime_",JFADateFrom:"_JFADateFrom
	.Set JsonStr=JsonStr_",JFADateTo:"_JFADateTo_",JFAEPSDr:"_JFAEPSDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

	Quit """"_rtn_""""
}

ClassMethod UpdateArrears(ArrearsInfo, Guser)
{
	New (ArrearsInfo, Guser)
	Set JFARowID=$p(ArrearsInfo,"^",1)
	Set JFAAdmCatDr=$p(ArrearsInfo,"^",2)
	Quit:(JFAAdmCatDr="") """"_"通道不能为空"_""""
	Set JFAEPSDr=$p(ArrearsInfo,"^",3)
	Set JFAAdmReasonDr=$p(ArrearsInfo,"^",4)
	Quit:(JFAAdmReasonDr="") """"_"收费类型为空"_""""
	Set JFAAdmType=$p(ArrearsInfo,"^",5)
	Set JFADiaCatDr=$p(ArrearsInfo,"^",6)
	Set JFALocDr=$p(ArrearsInfo,"^",7)
	Set JFAWardDr=$p(ArrearsInfo,"^",8)
	Set JFAGreenWay="N"
	Set JFAFlag=""
	Set JFADesc=""
	Set JFARemark=""
	Set JFAUserDr=Guser
	Set JFADate=+$h
	Set JFATime=$p($h,",",2)
	Set JFAUpdateUserDr=Guser
	Set JFAUpdateDate=+$h
	Set JFAUpdateTime=$p($h,",",2)
	Set JFADateFrom=""
	Set JFADateTo=""
	
	Set OldJFAAdmCatDr=$p(^DHCJFARREARS(JFARowID),"^",1)
	Set OldJFAGreenWay=$p(^DHCJFARREARS(JFARowID),"^",2)
	Set OldJFAAdmReasonDr=$p(^DHCJFARREARS(JFARowID),"^",3)
	Set OldJFAAdmType=$p(^DHCJFARREARS(JFARowID),"^",4)
	Set OldJFADiaCatDr=$p(^DHCJFARREARS(JFARowID),"^",5)
	Set OldJFALocDr=$p(^DHCJFARREARS(JFARowID),"^",6)
	Set OldJFAWardDr=$p(^DHCJFARREARS(JFARowID),"^",7)
	Set OldJFAFlag=$p(^DHCJFARREARS(JFARowID),"^",8)
	Set OldJFADesc=$p(^DHCJFARREARS(JFARowID),"^",9)
	Set OldJFARemark=$p(^DHCJFARREARS(JFARowID),"^",10)
	Set OldJFAUserDr=$p(^DHCJFARREARS(JFARowID),"^",11)
	Set OldJFADate=$p(^DHCJFARREARS(JFARowID),"^",12)
	Set OldJFATime=$p(^DHCJFARREARS(JFARowID),"^",13)
	Set OldJFAUpdateUserDr=$p(^DHCJFARREARS(JFARowID),"^",14)
	Set OldJFAUpdateDate=$p(^DHCJFARREARS(JFARowID),"^",15)
	Set OldJFAUpdateTime=$p(^DHCJFARREARS(JFARowID),"^",16)
	Set OldJFADateFrom=$p(^DHCJFARREARS(JFARowID),"^",17)
	Set OldJFADateTo=$p(^DHCJFARREARS(JFARowID),"^",18)
	Set OldJFAEPSDr=$p(^DHCJFARREARS(JFARowID),"^",19)

	Kill PLIST
	Set PLIST(2)=JFAAdmCatDr
	Set PLIST(3)=JFAGreenWay
	Set PLIST(4)=JFAAdmReasonDr
	Set PLIST(5)=JFAAdmType
	Set PLIST(6)=JFADiaCatDr
	Set PLIST(7)=JFALocDr
	Set PLIST(8)=JFAWardDr
	Set PLIST(9)=JFAFlag
	Set PLIST(10)=JFADesc
	Set PLIST(11)=JFARemark
	Set PLIST(12)=JFAUserDr
	Set PLIST(13)=JFADate
	Set PLIST(14)=JFATime
	Set PLIST(15)=JFAUpdateUserDr
	Set PLIST(16)=JFAUpdateDate
	Set PLIST(17)=JFAUpdateTime
	Set PLIST(18)=JFADateFrom
	Set PLIST(19)=JFADateTo
	Set PLIST(20)=JFAEPSDr
	
	Set rtn=$$UPDATE^DHCJFARREARS(JFARowID)
	
	If (+rtn=0) Do
	.Set Flag2="DHC_JFARREARS",UserTable="User.DHCJFArrears",TableDesc="非绿色通道欠费额度",InsRowid=JFARowID
	.Set JsonStr="{JFARowID:"_InsRowid_",JFAAdmCatDr:"_JFAAdmCatDr_",JFAGreenWay:"_JFAGreenWay
	.Set JsonStr=JsonStr_",JFAAdmReasonDr:"_JFAAdmReasonDr_",JFAAdmType:"_JFAAdmType_",JFADiaCatDr:"_JFADiaCatDr
	.Set JsonStr=JsonStr_",JFALocDr:"_JFALocDr_",JFAWardDr:"_JFAWardDr_",JFAFlag:"_JFAFlag
	.Set JsonStr=JsonStr_",JFADesc:"_JFADesc_",JFARemark:"_JFARemark_",JFAUserDr:"_JFAUserDr
	.Set JsonStr=JsonStr_",JFADate:"_JFADate_",JFATime:"_JFATime_",JFAUpdateUserDr:"_JFAUpdateUserDr
	.Set JsonStr=JsonStr_",JFAUpdateDate:"_JFAUpdateDate_",JFAUpdateTime:"_JFAUpdateTime_",JFADateFrom:"_JFADateFrom
	.Set JsonStr=JsonStr_",JFADateTo:"_JFADateTo_",JFAEPSDr:"_JFAEPSDr_"}" 

	.Set JsonStrOld="{JFARowID:"_InsRowid_",JFAAdmCatDr:"_OldJFAAdmCatDr_",JFAGreenWay:"_OldJFAGreenWay
	.Set JsonStrOld=JsonStrOld_",JFAAdmReasonDr:"_OldJFAAdmReasonDr_",JFAAdmType:"_OldJFAAdmType_",JFADiaCatDr:"_OldJFADiaCatDr
	.Set JsonStrOld=JsonStrOld_",JFALocDr:"_OldJFALocDr_",JFAWardDr:"_OldJFAWardDr_",JFAFlag:"_OldJFAFlag
	.Set JsonStrOld=JsonStrOld_",JFADesc:"_OldJFADesc_",JFARemark:"_OldJFARemark_",JFAUserDr:"_OldJFAUserDr
	.Set JsonStrOld=JsonStrOld_",JFADate:"_OldJFADate_",JFATime:"_OldJFATime_",JFAUpdateUserDr:"_OldJFAUpdateUserDr
	.Set JsonStrOld=JsonStrOld_",JFAUpdateDate:"_OldJFAUpdateDate_",JFAUpdateTime:"_OldJFAUpdateTime_",JFADateFrom:"_OldJFADateFrom
	.Set JsonStrOld=JsonStrOld_",JFADateTo:"_OldJFADateTo_",JFAEPSDr:"_OldJFAEPSDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit """"_rtn_""""
}

ClassMethod DeleteArrears(ArrearsInfo, Guser)
{
	New (ArrearsInfo, Guser)
	Set JFARowID=$p(ArrearsInfo,"^",1)

	Set rtn=$$SELECT^DHCJFARREARS(JFARowID)
	Set JFAAdmCatDr=PLIST(2)
	Set JFAGreenWay=PLIST(3)
	Set JFAAdmReasonDr=PLIST(4)
	Set JFAAdmType=PLIST(5)
	Set JFADiaCatDr=PLIST(6)
	Set JFALocDr=PLIST(7)
	Set JFAWardDr=PLIST(8)
	Set JFAFlag=PLIST(9)
	Set JFADesc=PLIST(10)
	Set JFARemark=PLIST(11)
	Set JFAUserDr=PLIST(12)
	Set JFADate=PLIST(13)
	Set JFATime=PLIST(14)
	Set JFAUpdateUserDr=PLIST(15)
	Set JFAUpdateDate=PLIST(16)
	Set JFAUpdateTime=PLIST(17)
	Set JFADateFrom=PLIST(18)
	Set JFADateTo=PLIST(19)
	Set JFAEPSDr=PLIST(20)

	Set rtn=$$DELETE^DHCJFARREARS(JFARowID)

	If (+rtn=0) Do
	.Set Flag2="DHC_JFARREARS",UserTable="User.DHCJFArrears",TableDesc="非绿色通道欠费额度",InsRowid=JFARowID
	.Set JsonStr="{JFARowID:"_InsRowid_",JFAAdmCatDr:"_JFAAdmCatDr_",JFAGreenWay:"_JFAGreenWay
	.Set JsonStr=JsonStr_",JFAAdmReasonDr:"_JFAAdmReasonDr_",JFAAdmType:"_JFAAdmType_",JFADiaCatDr:"_JFADiaCatDr
	.Set JsonStr=JsonStr_",JFALocDr:"_JFALocDr_",JFAWardDr:"_JFAWardDr_",JFAFlag:"_JFAFlag
	.Set JsonStr=JsonStr_",JFADesc:"_JFADesc_",JFARemark:"_JFARemark_",JFAUserDr:"_JFAUserDr
	.Set JsonStr=JsonStr_",JFADate:"_JFADate_",JFATime:"_JFATime_",JFAUpdateUserDr:"_JFAUpdateUserDr
	.Set JsonStr=JsonStr_",JFAUpdateDate:"_JFAUpdateDate_",JFAUpdateTime:"_JFAUpdateTime_",JFADateFrom:"_JFADateFrom
	.Set JsonStr=JsonStr_",JFADateTo:"_JFADateTo_",JFAEPSDr:"_JFAEPSDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "删除", "D", JsonStr)

	Quit """"_rtn_""""
}

/// do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindArrearsMoney",2)
Query FindArrearsMoney(JFARowID) As websys.Query(ROWSPEC = "winJFARowID:%String,winJFAMRowID:%String,winJFAMTypeDesc:%String,winJFAMType:%String,winJFAMALDesc:%String,winJFAMALDr:%String,winJFAMOperator1:%String,winJFAMMoneyFrom:%String,winJFAMOperator2:%String,winJFAMMoneyTo:%String,winJFAMFeeRate:%String,winJFAMOperatorDr1:%String,winJFAMOperatorDr2:%String")
{
}

ClassMethod FindArrearsMoneyExecute(ByRef qHandle As %Binary, JFARowID) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    If (JFARowID="") Quit $$$OK
    Set rtn=$$getArrearsMoney^DHCJFARREARSM(JFARowID)
    If (rtn=0) Quit $$$OK
    
    For i=1:1:rtn Do
    .Set ArrMoneyInfo=PLIST(i)
	.Set JFAMRowID=$p(ArrMoneyInfo,$c(2),1)
	.Set JFAMTypeDesc=$p(ArrMoneyInfo,$c(2),2)
	.Set JFAMType=$p(ArrMoneyInfo,$c(2),3)
	.Set JFAMALDesc=$p(ArrMoneyInfo,$c(2),4)
	.Set JFAMALDr=$p(ArrMoneyInfo,$c(2),5)
	.Set JFAMOperator1=$p(ArrMoneyInfo,$c(2),6)
	.Set JFAMMoneyFrom=$p(ArrMoneyInfo,$c(2),7)
	.Set JFAMOperator2=$p(ArrMoneyInfo,$c(2),8)
	.Set JFAMMoneyTo=$p(ArrMoneyInfo,$c(2),9)
	.Set JFAMFeeRate=$p(ArrMoneyInfo,$c(2),10)
	.Do OutputArrMoney

	Quit $$$OK
OutputArrMoney
	Set Data=$lb(JFARowID,JFAMRowID,JFAMTypeDesc,JFAMType,JFAMALDesc,JFAMALDr,JFAMOperator1,JFAMMoneyFrom,JFAMOperator2,JFAMMoneyTo,JFAMFeeRate,JFAMOperator1,JFAMOperator2)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindMoneyType")
Query FindMoneyType() As websys.Query(ROWSPEC = "winMoneyTypeCode:%String,winMoneyTypeDesc:%String")
{
}

ClassMethod FindMoneyTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    Set rtn=$$OPENMoneyType^DHCJFARREARSM()
    If (+rtn) Quit $$$OK
    Set ROW=0
	Do{
		Set rtn=$$FETCHMoneyType^DHCJFARREARSM()
		Do GetMoneyTpye
	}while(rtn=0)
	Do CLOSE^DHCJFARREARSM()
	Quit $$$OK
GetMoneyTpye
	Quit:'$d(PLIST)
	Set MoneyTypeInfo=PLIST(1)
	Set MoneyTypeCode=$p(MoneyTypeInfo,"^",1)
	Set MoneyTypeDesc=$p(MoneyTypeInfo,"^",2)
	Do OutputMonType
	Quit
OutputMonType
	Set Data=$lb(MoneyTypeCode,MoneyTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindOperator",^TMP("tt"))
Query FindOperator(OpFlag) As websys.Query(ROWSPEC = "TOperatorCode:%String,TOperatorDesc:%String")
{
}

ClassMethod FindOperatorExecute(ByRef qHandle As %Binary, OpFlag) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set rtn=$$OPENOperator^DHCJFARREARSM()
    If (+rtn) Quit $$$OK
    Set ROW=0
	Do{
		Set rtn=$$FETCHOperator^DHCJFARREARSM()
		Do GetOperator(OpFlag)
	}while(rtn=0)
	Do CLOSE^DHCJFARREARSM()
	Quit $$$OK
GetOperator(OpFlag)
	Quit:'$d(PLIST)
	Set OperatorInfo=PLIST(1)
	Quit:(OperatorInfo'[OpFlag)
	Set OperatorCode=OperatorInfo
	Set OperatorDesc=OperatorCode
	If (OperatorDesc="<") Set OperatorDesc="< "	 ;IE前台combobox显示时，<显示有问题，转义也不能处理，这里增加空格处理
	Do OutputOperator
	Quit
OutputOperator
	Set Data=$lb(OperatorCode,OperatorDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// Debug: w ##class(DHCBILLConfig.DHCBILLArrears).InsertArrearsMoney("2^2||3^A^3^>^<^-1000^0^1",1,2)
ClassMethod InsertArrearsMoney(ArrMoneyInfo, Guser)
{
	New (ArrMoneyInfo, Guser)
	Set JFARowID=$p(ArrMoneyInfo,"^",1)
	//Set JFAMRowID=$p(ArrMoneyInfo,"^",2)
	Set MoneyType=$p(ArrMoneyInfo,"^",3)
	Set ArrLevel=$p(ArrMoneyInfo,"^",4)
	Set Oprator1=$p(ArrMoneyInfo,"^",5)
	Set Oprator2=$p(ArrMoneyInfo,"^",6)
	Set MoneyFrom=$p(ArrMoneyInfo,"^",7)
	Set MoneyTo=$p(ArrMoneyInfo,"^",8)
	Set FeeRate=$p(ArrMoneyInfo,"^",9)
	Quit:((MoneyFrom="")||(MoneyTo="")) """"_"-1001金额不能为空!"_""""
	Set Oprator1=$tr(Oprator1," ","")
	Set Oprator2=$tr(Oprator2," ","")
	
	Kill PLIST
	Set PLIST(3)=ArrLevel
	Set PLIST(4)=MoneyType
	Set PLIST(5)=Oprator1
	Set PLIST(6)=MoneyFrom
	Set PLIST(7)=Oprator2
	Set PLIST(8)=MoneyTo
	Set PLIST(9)=""
	Set PLIST(10)=""
	Set PLIST(11)=Guser
	Set PLIST(12)=+$h
	Set PLIST(13)=$p($h,",",2)
	Set PLIST(14)=Guser
	Set PLIST(15)=+$h
	Set PLIST(16)=$p($h,",",2)
	Set PLIST(17)=""
	Set PLIST(18)=""
	Set PLIST(19)=FeeRate

	Set rtn=$$INSERT^DHCJFARREARSMONEY(JFARowID)
	
	If (+rtn=0) Do
	.Set Flag2="DHC_JFArrearsMoney",UserTable="User.DHCJFArrearsMoney",TableDesc="欠费金额",InsRowid=%ROWID
	.Set JsonStr="{JFAMJFAParref:"_JFARowID_",JFAMRowID:"_InsRowid
	.Set JsonStr=JsonStr_",JFAMALDr:"_ArrLevel_",JFAMType:"_MoneyType_",JFAMOperator1:"_Oprator1
	.Set JsonStr=JsonStr_",JFAMMoneyFrom:"_MoneyFrom_",JFAMOperator2:"_Oprator2_",JFAMMoneyTo:"_MoneyTo
	.Set JsonStr=JsonStr_",JFAMDesc:"_""_",JFAMFlag:"_""_",JFAMUserDr:"_Guser
	.Set JsonStr=JsonStr_",JFAMDate:"_+$h_",JFAMTime:"_$p($h,",",2)_",JFAMUpdateUserDr:"_Guser
	.Set JsonStr=JsonStr_",JFAMUpdateDate:"_+$h_",JFAMUpdateTime:"_$p($h,",",2)_",JFAMDateFrom:"_""
	.Set JsonStr=JsonStr_",JFAMDateTo:"_""_",JFAMFeeRate:"_FeeRate_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

	Quit +rtn
}

/// Debug: w ##class(DHCBILLConfig.DHCBILLArrears).UpdateArrearsMoney("20^20||1^A^3^>^<=^1^500^1","1")
ClassMethod UpdateArrearsMoney(ArrMoneyInfo, Guser)
{
	New (ArrMoneyInfo, Guser)
	Set ^TMP("UpdateArrearsMoney")=$lb(ArrMoneyInfo, Guser)
	Set JFARowID=$p(ArrMoneyInfo,"^",1)
	Set JFAMRowID=$p(ArrMoneyInfo,"^",2)
	Set MoneyType=$p(ArrMoneyInfo,"^",3)
	Set ArrLevel=$p(ArrMoneyInfo,"^",4)
	Set Oprator1=$p(ArrMoneyInfo,"^",5)
	Set Oprator2=$p(ArrMoneyInfo,"^",6)
	Set MoneyFrom=$p(ArrMoneyInfo,"^",7)
	Set MoneyTo=$p(ArrMoneyInfo,"^",8)
	Set FeeRate=$p(ArrMoneyInfo,"^",9)
	Set Oprator1=$tr(Oprator1," ","")
	Set Oprator2=$tr(Oprator2," ","")
	
	Set OldJFAMALDr=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",1)
	Set OldJFAMType=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",2)
	Set OldJFAMOperator1=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",3)
	Set OldJFAMMoneyFrom=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",4)
	Set OldJFAMOperator2=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",5)
	Set OldJFAMMoneyTo=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",6)
	Set OldJFAMDesc=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",7)
	Set OldJFAMFlag=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",8)
	Set OldJFAMUserDr=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",9)
	Set OldJFAMDate=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",10)
	Set OldJFAMTime=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",11)
	Set OldJFAMUpdateUserDr=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",12)
	Set OldJFAMUpdateDate=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",13)
	Set OldJFAMUpdateTime=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",14)
	Set OldJFAMDateFrom=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",15)
	Set OldJFAMDateTo=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",16)
	Set OldJFAMFeeRate=$p(^DHCJFARREARS(+JFAMRowID,"M",$p(JFAMRowID,"||",2)),"^",17)

	Kill PLIST
	Set PLIST(3)=ArrLevel
	Set PLIST(4)=MoneyType
	Set PLIST(5)=Oprator1
	Set PLIST(6)=MoneyFrom
	Set PLIST(7)=Oprator2
	Set PLIST(8)=MoneyTo
	Set PLIST(9)=""
	Set PLIST(10)=""
	Set PLIST(11)=Guser
	Set PLIST(12)=+$h
	Set PLIST(13)=$p($h,",",2)
	Set PLIST(14)=Guser
	Set PLIST(15)=+$h
	Set PLIST(16)=$p($h,",",2)
	Set PLIST(17)=""
	Set PLIST(18)=""
	Set PLIST(19)=FeeRate
	
	Set rtn=$$UPDATE^DHCJFARREARSMONEY(JFAMRowID)
	
	If (+rtn=0) Do
	.Set Flag2="DHC_JFArrearsMoney",UserTable="User.DHCJFArrearsMoney",TableDesc="欠费金额",InsRowid=JFAMRowID
	.Set JsonStr="{JFAMJFAParref:"_JFARowID_",JFAMRowID:"_InsRowid
	.Set JsonStr=JsonStr_",JFAMALDr:"_ArrLevel_",JFAMType:"_MoneyType_",JFAMOperator1:"_Oprator1
	.Set JsonStr=JsonStr_",JFAMMoneyFrom:"_MoneyFrom_",JFAMOperator2:"_Oprator2_",JFAMMoneyTo:"_MoneyTo
	.Set JsonStr=JsonStr_",JFAMDesc:"_""_",JFAMFlag:"_""_",JFAMUserDr:"_Guser
	.Set JsonStr=JsonStr_",JFAMDate:"_+$h_",JFAMTime:"_$p($h,",",2)_",JFAMUpdateUserDr:"_Guser
	.Set JsonStr=JsonStr_",JFAMUpdateDate:"_+$h_",JFAMUpdateTime:"_$p($h,",",2)_",JFAMDateFrom:"_""
	.Set JsonStr=JsonStr_",JFAMDateTo:"_""_",JFAMFeeRate:"_FeeRate_"}" 

	.Set JsonStrOld="{JFAMJFAParref:"_JFARowID_",JFAMRowID:"_InsRowid
	.Set JsonStrOld=JsonStrOld_",JFAMALDr:"_OldJFAMALDr_",JFAMType:"_OldJFAMType_",JFAMOperator1:"_OldJFAMOperator1
	.Set JsonStrOld=JsonStrOld_",JFAMMoneyFrom:"_OldJFAMMoneyFrom_",JFAMOperator2:"_OldJFAMOperator2_",JFAMMoneyTo:"_OldJFAMMoneyTo
	.Set JsonStrOld=JsonStrOld_",JFAMDesc:"_OldJFAMDesc_",JFAMFlag:"_OldJFAMFlag_",JFAMUserDr:"_OldJFAMUserDr
	.Set JsonStrOld=JsonStrOld_",JFAMDate:"_OldJFAMDate_",JFAMTime:"_OldJFAMTime_",JFAMUpdateUserDr:"_OldJFAMUpdateUserDr
	.Set JsonStrOld=JsonStrOld_",JFAMUpdateDate:"_OldJFAMUpdateDate_",JFAMUpdateTime:"_OldJFAMUpdateTime_",JFAMDateFrom:"_OldJFAMDateFrom
	.Set JsonStrOld=JsonStrOld_",JFAMDateTo:"_OldJFAMDateTo_",JFAMFeeRate:"_OldJFAMFeeRate_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit +rtn
}

/// w ##class(DHCBILLConfig.DHCBILLArrears).InsertArrearsLevel("2^^A^1^>=^<^3^444444^1",1,2)
ClassMethod DeleteArrearsMoney(ArrMoneyInfo, Guser, HospID)
{
	New (ArrMoneyInfo, Guser, HospID)
	Set JFARowID=$p(ArrMoneyInfo,"^",1)
	Set JFAMRowID=$p(ArrMoneyInfo,"^",2)
	Set rtn=$$SELECT^DHCJFARREARSMONEY(JFAMRowID)
	Set ArrLevel=PLIST(3)
	Set MoneyType=PLIST(4)
	Set Oprator1=PLIST(5)
	Set MoneyFrom=PLIST(6)
	Set Oprator2=PLIST(7)
	Set MoneyTo=PLIST(8)
	Set JFAMDesc=PLIST(9)
	Set JFAMFlag=PLIST(10)
	Set JFAMUserDr=PLIST(11)
	Set JFAMDate=PLIST(12)
	Set JFAMTime=PLIST(13)
	Set JFAMUpdateUserDr=PLIST(14)
	Set JFAMUpdateDate=PLIST(15)
	Set JFAMUpdateTime=PLIST(16)
	Set JFAMDateFrom=PLIST(17)
	Set JFAMDateTo=PLIST(18)
	Set JFAMFeeRate=PLIST(19)
	
	Set rtn=$$DELETE^DHCJFARREARSMONEY(JFAMRowID)

	If (+rtn=0) Do
	.Set Flag2="DHC_JFArrearsMoney",UserTable="User.DHCJFArrearsMoney",TableDesc="欠费金额",InsRowid=JFAMRowID
	.Set JsonStr="{JFAMJFAParref:"_JFARowID_",JFAMRowID:"_InsRowid
	.Set JsonStr=JsonStr_",JFAMALDr:"_ArrLevel_",JFAMType:"_MoneyType_",JFAMOperator1:"_Oprator1
	.Set JsonStr=JsonStr_",JFAMMoneyFrom:"_MoneyFrom_",JFAMOperator2:"_Oprator2_",JFAMMoneyTo:"_MoneyTo
	.Set JsonStr=JsonStr_",JFAMDesc:"_JFAMDesc_",JFAMFlag:"_JFAMFlag_",JFAMUserDr:"_JFAMUserDr
	.Set JsonStr=JsonStr_",JFAMDate:"_JFAMDate_",JFAMTime:"_JFAMTime_",JFAMUpdateUserDr:"_JFAMUpdateUserDr
	.Set JsonStr=JsonStr_",JFAMUpdateDate:"_JFAMUpdateDate_",JFAMUpdateTime:"_JFAMUpdateTime_",JFAMDateFrom:"_JFAMDateFrom
	.Set JsonStr=JsonStr_",JFAMDateTo:"_JFAMDateTo_",JFAMFeeRate:"_JFAMFeeRate_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "删除", "D", JsonStr)

	Quit +rtn
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindOrdCat","ArcItmCat","4",2)
Query FindOrdCat(CateFlag As %String, CateDr As %String, HospId As %String) As websys.Query(ROWSPEC = "OrcRowid:%String,OrdCode:%String,OrdCat:%String")
{
}

ClassMethod FindOrdCatExecute(ByRef qHandle As %Binary, CateFlag As %String, CateDr As %String, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)	
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	If (CateFlag="OrdCat") Do
	.Set Rowid=0
	.For  Set Rowid=$o(^OEC("ORCAT",Rowid)) Quit:(Rowid="")  Do
	..Set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("OEC_OrderCategory", Rowid, HospId)
	..Quit:(ShowFlag="N")
	..Quit:((CateDr'="")&&(Rowid'=CateDr))
	..Set OrdCode=$p(^OEC("ORCAT",Rowid),"^",1)
	..Set OrdCat=$p(^OEC("ORCAT",Rowid),"^",2)
	..Do OutputOrdCat
	If (CateFlag="ArcItmCat") Do
	.Set Rowid=0
	.For  Set Rowid=$o(^ARC("IC",Rowid)) Quit:(Rowid="")  Do
	..Set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat", Rowid, HospId)
	..Quit:(ShowFlag="N")
	..Set OrdCode=$p(^ARC("IC",Rowid),"^",1)
	..Set OrdCat=$p(^ARC("IC",Rowid),"^",2)
	..Set OrdCateglory=$p(^ARC("IC",Rowid),"^",8)
	..Quit:((CateDr'="")&&(OrdCateglory'=CateDr))
	..Do OutputOrdCat
	
	Quit $$$OK
OutputOrdCat
	Set Data=$lb(Rowid,OrdCode,OrdCat)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLArrears","FindArrearsOrdCat",1)
Query FindArrearsOrdCat(JFALRowID) As websys.Query(ROWSPEC = "winJFAOCRowID:%String,winJFAOCOrderCat:%String,winJFAOCOrderCatDesc:%String,winJFAOCArcItmCat:%String,winJFAOCArcItmCatDesc:%String")
{
}

ClassMethod FindArrearsOrdCatExecute(ByRef qHandle As %Binary, JFALRowID) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    If (JFALRowID="") Quit $$$OK
	Set rtn=$$OPEN^DHCJFARREARSORDCAT(JFALRowID)
	If (+rtn) Quit $$$OK
	Do{
		Set rtn=$$FETCH^DHCJFARREARSORDCAT(JFALRowID)
	    Do GetArrearsOrdCat
	}while(rtn=0)
    Set rtn=$$CLOSE^DHCJFARREARSORDCAT()
	Quit $$$OK
GetArrearsOrdCat
	Quit:$d(PLIST)=0
	Quit:PLIST=1
	Quit:PLIST=2
	Set JFAOCRowID=PLIST(1)
	Set JFAOCOrderCat=PLIST(3)
	Set JFAOCOrderCatDesc=$$getOrdCatDesc^DHCJFARREARSM(JFAOCOrderCat)
	Set JFAOCArcItmCat=PLIST(4)
	Set JFAOCArcItmCatDesc=$$getOrdSubCatDesc^DHCJFARREARSM(JFAOCArcItmCat)
	Do OutputArrOrdCat
	Quit
OutputArrOrdCat
	Set Data=$lb(JFAOCRowID,JFAOCOrderCat,JFAOCOrderCatDesc,JFAOCArcItmCat,JFAOCArcItmCatDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// w ##class(DHCBILLConfig.DHCBILLArrears).InsertArrOrdCat("^4^216^1",1,2)
ClassMethod InsertArrOrdCat(ArrOrdCatInfo, Guser)
{
	New (ArrOrdCatInfo, Guser)
	Set OrdCat=$p(ArrOrdCatInfo,"^",2)
	Set ArcCat=$p(ArrOrdCatInfo,"^",3)
	Set JFALRowID=$p(ArrOrdCatInfo,"^",4)
	Kill PLIST
	Set PLIST(3)=OrdCat
	Set PLIST(4)=ArcCat
	Set PLIST(5)=""
	Set PLIST(6)=""
	Set PLIST(7)=Guser
	Set PLIST(8)=+$h
	Set PLIST(9)=$p($h,",",2)
	Set PLIST(10)=+$h
	Set PLIST(11)=$p($h,",",2)
	Set PLIST(12)=Guser
	
	Set rtn=$$INSERT^DHCJFARREARSORDCAT(JFALRowID)
	
	If (rtn="-101") Set rtn="-101医嘱大类不能重复录入"
	If (rtn="-102") Set rtn="-102医嘱子类不能重复录入"
	
	If (+rtn=0) Do
	.Set Flag2="DHC_JFArrearsOrdCat",UserTable="User.DHCJFArrearsOrdCat",TableDesc="控制级别医嘱分类",InsRowid=%ROWID
	.Set JsonStr="{JFAOCALParref:"_JFALRowID_",JFAOCRowID:"_InsRowid
	.Set JsonStr=JsonStr_",JFAOCOrdCatDr:"_OrdCat_",JFAOCOrdSubCatDr:"_ArcCat_",JFAOCDateFrom:"_""
	.Set JsonStr=JsonStr_",JFAOCDateTo:"_""_",JFAOCUserDr:"_Guser_",JFAOCDate:"_+$h
	.Set JsonStr=JsonStr_",JFAOCTime:"_$p($h,",",2)_",JFAOCUpdateDate:"_+$h_",JFAOCUpdateTime:"_$p($h,",",2)
	.Set JsonStr=JsonStr_",JFAOCUpdateUserDr:"_Guser_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

	Quit """"_rtn_""""
}

/// w ##class("DHCBILLConfig.DHCBILLArrears").UpdateArrOrdCat("3||14^4^19^3",1)
ClassMethod UpdateArrOrdCat(ArrOrdCatInfo, Guser)
{
	New (ArrOrdCatInfo, Guser)
	Set JOCRowid=$p(ArrOrdCatInfo,"^",1)
	Set OrdCat=$p(ArrOrdCatInfo,"^",2)
	Set ArcCat=$p(ArrOrdCatInfo,"^",3)
	Set JFALRowID=$p(ArrOrdCatInfo,"^",4)
	
	Set OldJFAOCOrdCatDr=$p(^DHCJFARREARSLEVEL(+JOCRowid,"O",$p(JOCRowid,"||",2)),"^",1)
	Set OldJFAOCOrdSubCatDr=$p(^DHCJFARREARSLEVEL(+JOCRowid,"O",$p(JOCRowid,"||",2)),"^",2)
	Set OldJFAOCDateFrom=$p(^DHCJFARREARSLEVEL(+JOCRowid,"O",$p(JOCRowid,"||",2)),"^",3)
	Set OldJFAOCDateTo=$p(^DHCJFARREARSLEVEL(+JOCRowid,"O",$p(JOCRowid,"||",2)),"^",4)
	Set OldJFAOCUserDr=$p(^DHCJFARREARSLEVEL(+JOCRowid,"O",$p(JOCRowid,"||",2)),"^",5)
	Set OldJFAOCDate=$p(^DHCJFARREARSLEVEL(+JOCRowid,"O",$p(JOCRowid,"||",2)),"^",6)
	Set OldJFAOCTime=$p(^DHCJFARREARSLEVEL(+JOCRowid,"O",$p(JOCRowid,"||",2)),"^",7)
	Set OldJFAOCUpdateDate=$p(^DHCJFARREARSLEVEL(+JOCRowid,"O",$p(JOCRowid,"||",2)),"^",8)
	Set OldJFAOCUpdateTime=$p(^DHCJFARREARSLEVEL(+JOCRowid,"O",$p(JOCRowid,"||",2)),"^",9)
	Set OldJFAOCUpdateUserDr=$p(^DHCJFARREARSLEVEL(+JOCRowid,"O",$p(JOCRowid,"||",2)),"^",10)
	
	Kill PLIST
	Set PLIST(3)=OrdCat
	Set PLIST(4)=ArcCat
	Set PLIST(5)=""
	Set PLIST(6)=""
	Set PLIST(7)=""
	Set PLIST(8)=""
	Set PLIST(9)=""
	Set PLIST(10)=+$h
	Set PLIST(11)=$p($h,",",2)
	Set PLIST(12)=Guser
	Set rtn=$$UPDATE^DHCJFARREARSORDCAT(JOCRowid)
	
	If (rtn="-101") Set rtn="-101医嘱大类已存在"
	If (rtn="-102") Set rtn="-102医嘱子类已存在"
		
	If (+rtn=0) Do
	.Set Flag2="DHC_JFArrearsOrdCat",UserTable="User.DHCJFArrearsOrdCat",TableDesc="控制级别医嘱分类",InsRowid=JOCRowid
	.Set JsonStr="{JFAOCALParref:"_JFALRowID_",JFAOCRowID:"_InsRowid
	.Set JsonStr=JsonStr_",JFAOCOrdCatDr:"_OrdCat_",JFAOCOrdSubCatDr:"_ArcCat_",JFAOCDateFrom:"_""
	.Set JsonStr=JsonStr_",JFAOCDateTo:"_""_",JFAOCUserDr:"_""_",JFAOCDate:"_""
	.Set JsonStr=JsonStr_",JFAOCTime:"_""_",JFAOCUpdateDate:"_+$h_",JFAOCUpdateTime:"_$p($h,",",2)
	.Set JsonStr=JsonStr_",JFAOCUpdateUserDr:"_Guser_"}" 

	.Set JsonStrOld="{JFAOCALParref:"_JFALRowID_",JFAOCRowID:"_InsRowid
	.Set JsonStrOld=JsonStrOld_",JFAOCOrdCatDr:"_OldJFAOCOrdCatDr_",JFAOCOrdSubCatDr:"_OldJFAOCOrdSubCatDr_",JFAOCDateFrom:"_OldJFAOCDateFrom
	.Set JsonStrOld=JsonStrOld_",JFAOCDateTo:"_OldJFAOCDateTo_",JFAOCUserDr:"_OldJFAOCUserDr_",JFAOCDate:"_OldJFAOCDate
	.Set JsonStrOld=JsonStrOld_",JFAOCTime:"_OldJFAOCTime_",JFAOCUpdateDate:"_OldJFAOCUpdateDate_",JFAOCUpdateTime:"_OldJFAOCUpdateTime
	.Set JsonStrOld=JsonStrOld_",JFAOCUpdateUserDr:"_OldJFAOCUpdateUserDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit """"_rtn_""""
}

ClassMethod DeleteArrOrdCat(ArrOrdCatInfo, Guser)
{
	New (ArrOrdCatInfo, Guser)
	Set JOCRowid=$p(ArrOrdCatInfo,"^",1)
	Set OrdCat=$p(ArrOrdCatInfo,"^",2)
	Set ArcCat=$p(ArrOrdCatInfo,"^",3)
	Set JFALRowID=$p(ArrOrdCatInfo,"^",4)

	Set rtn=$$SELECT^DHCJFARREARSORDCAT(JOCRowid)
	
	Set OrdCat=PLIST(3)
	Set ArcCat=PLIST(4)
	Set OCDateFrom=PLIST(5)
	Set OCDateTo=PLIST(6)
	Set OCUserDr=PLIST(7)
	Set OCDate=PLIST(8)
	Set OCTime=PLIST(9)
	Set OCUpdateDate=PLIST(10)
	Set OCUpdateTime=PLIST(11)
	Set OCUpdateUserDr=PLIST(12)
	
	Set rtn=$$DELETE^DHCJFARREARSORDCAT(JOCRowid)
	
	If (+rtn=0) Do
	.Set Flag2="DHC_JFArrearsOrdCat",UserTable="User.DHCJFArrearsOrdCat",TableDesc="控制级别医嘱分类",InsRowid=JOCRowid
	.Set JsonStr="{JFAOCALParref:"_JFALRowID_",JFAOCRowID:"_InsRowid
	.Set JsonStr=JsonStr_",JFAOCOrdCatDr:"_OrdCat_",JFAOCOrdSubCatDr:"_ArcCat_",JFAOCDateFrom:"_OCDateFrom
	.Set JsonStr=JsonStr_",JFAOCDateTo:"_OCDateTo_",JFAOCUserDr:"_OCUserDr_",JFAOCDate:"_OCDate
	.Set JsonStr=JsonStr_",JFAOCTime:"_OCTime_",JFAOCUpdateDate:"_OCUpdateDate_",JFAOCUpdateTime:"_OCUpdateTime
	.Set JsonStr=JsonStr_",JFAOCUpdateUserDr:"_OCUpdateUserDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "删除", "D", JsonStr)

	Quit """"_rtn_""""
}

}
