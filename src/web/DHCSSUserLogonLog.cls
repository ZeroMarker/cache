Include websys

Class web.DHCSSUserLogonLog Extends %RegisteredObject
{

// d ##class(%ResultSet).RunQuery("web.CTLoc:LookUpRestrType","","","")

ClassMethod FindLocExecute(ByRef QHandle As %Library.Binary, Desc As %String) As %Library.Status
{
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s repid=$I(^CacheTemp)
	s ind=1
	Set nowDate = +$h
	s QHandle=$lb(0,repid,0)
	s locRowid=0
	f  s locRowid=$o(^CTLOC(locRowid)) q:locRowid=""  d
	.s CTLOCDesc=$p(^CTLOC(locRowid),"^",2)
	.q:(Desc'="")&&(CTLOCDesc'[Desc)
	.s CTLOCCode=$p(^CTLOC(locRowid),"^",2)
	.Set ActiveFlag = $p(^CTLOC(locRowid),"^",14)
	.Quit:ActiveFlag="N"
	.Set ActiveFrom = $p(^CTLOC(locRowid),"^",24)
	.Set ActiveTo = $p(^CTLOC(locRowid),"^",25)
	.Quit:(ActiveFrom>nowDate)&&(ActiveFrom'="")
	.Quit:(ActiveTo<nowDate)&&(ActiveTo'="")
	.s Data=$lb(CTLOCDesc,CTLOCCode,locRowid)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

Query FindLoc(Desc As %String) As websys.Query(CONTAINID = 0, ROWSPEC = "CTLOCDesc:%String,CTLOCCode:%String,CTLOCRowId:%String")
{
}

/// d ##class(web.DHCSSUserLogonLog).LocUserJson("2015-11-17",9)
/// @Parma : Date 日期
/// @param : LocId 科室id
/// @Param : SchFlag  1->排班的才显示, 0->显示所有
/// @param : CareType 类型 医生(DOCTOR)或护士(NURSE)
/// @param : OutlineFlag 1->显示离线人员, 0->显示所有
ClassMethod LocUserJson(Date, LocId, SchFlag = 1, CareType = "", OutlineFlag = 0)
{
	//Set ^Wanghc("LocUserJson")=SchFlag_"^"_CareType
	Set JsonObj = ##class(ext.util.JsonObject).%New()
	/*w "{""locInfo"":"
	Set LocDesc = $p(^CTLOC(LocId),"^",1)
	do JsonObj.Put("locId",LocId).Put("locDesc",LocDesc).Put("showDate",Date).Put("amStWorkTime","8:30").Put("amEndWorkTime","12:00")
	do JsonObj.Put("pmStWorkTime","14:30").Put("pmEndWorkTime","17:30") //.Put("nightStWorkTime","").Put("nightEndWorkTime","")
	do JsonObj.Put("amStWorkTimeH",$zth("8:30")).Put("amEndWorkTimeH",$zth("12:00"))
	do JsonObj.Put("pmStWorkTimeH",$zth("14:30")).Put("pmEndWorkTimeH",$zth("17:30"))
	w JsonObj.Json()
	d JsonObj.Clear()
	*/
	w "{""userInfo"":["
	Set rs = ##class(%ResultSet).%New("web.DHCSSUserLogonLog:FindLocUserWorkInfo")
	Set rs2 = ##class(%ResultSet).%New("web.DHCSSUserLogonLog:FindUserLog")
	Set ColCount1 = rs.GetColumnCount()
	Set ColCount2 = rs2.GetColumnCount()
	Do rs.Execute(Date,LocId,SchFlag,CareType)
	Set Ind1 = 0
	while(rs.Next()){
		Set Ind1 = Ind1+1
		Write $Select(Ind1=1:"{",1:",{") 
		For i=1:1:ColCount1 write """"_rs.GetColumnName(i)_""":"""_##class(ext.util.String).EvalJSON(rs.GetData(i))_""","
		Do rs2.Execute(Date,Date,rs.GetDataByName("UserCode"),"","",OutlineFlag)
		Set Ind2 = 0 ,inLine=""
		Write """records"":["
		while(rs2.Next()){
			Set Ind2 = Ind2+1
			Write $Select(Ind2=1:"",1:",") 
			for i=1:1:ColCount2 do JsonObj.Put(rs2.GetColumnName(i),rs2.GetData(i))
			write JsonObj.Json()
			if (rs2.GetDataByName("inLine")=1) Set inLine = 1
			do JsonObj.Clear()
		}
		Write "]"
		write ",""inLine"":"""_inLine_"""}"
	}
	W "]}"
	Quit ""
}

/// / 显示科室下医生或护士 在线情况
/// @param : StDate 开始日期
/// @param : LocId  科室Id
/// @param : SchFlag 显示排班 Schedule . 1只显示已排班医生, 0显示所有
/// @param : CareType 类型 医生(DOCTOR)或护士(NURSE)
/// d ##class(%ResultSet).RunQuery("web.DHCSSUserLogonLog","FindLocUserWorkInfo",+$h,9,1)
Query FindLocUserWorkInfo(StDate As %String, LocId As %String, SchFlag = 1, CareType = "") As websys.Query(ROWSPEC = "LocCode:%String,UserId:%String,UserName:%String,UserCode:%String,amStTimeH:%String,amEndTimeH:%String,pmStTimeH:%String,pmEndTimeH:%String,nightStTimeH:%String,nightEndTimeH:%String,am:%String,pm:%String,night:%String,CateType:%String,amStTime:%String,amEndTime:%String,pmStTime:%String,pmEndTime:%String,nightStTime:%String,nightEndTime:%String,SchRFlag:%String")
{
}

ClassMethod FindLocUserWorkInfoExecute(ByRef qHandle As %Binary, StDate As %String, LocId As %String, SchFlag = 1, CareType = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
	i StDate["-" s StDate=$ZDH(StDate,3)
    Quit:StDate="" $$$OK
    Quit:(LocId="")&&(SchFlag'=1) $$$OK
    k ^||LocUser,^||LocUserSort
    Set CurrPM = ($p($h,",",2)>$zth("12:00"))&&($p($h,",",2)<$zth("19:00")) ;当前是下午
 	Set ^Wanghc("LocUserJson","1")=SchFlag_"^"_CareType
 	Set TmpCTRowId = 0
    do{
	    Set TmpCTRowId = $O(^CTLOC(TmpCTRowId))
	    if (TmpCTRowId>0){
		    If (TmpCTRowId=LocId)||(LocId="") {
			    Set ResId = "" 
			    Do{
					Set ResId = $Order(^RB("RES",0,"CTLOC",TmpCTRowId,ResId))	;
					If (ResId>0) {
						Set LocCode = $p(^CTLOC(TmpCTRowId),"^",1)
						Set ResCTPCPDR = $p(^RB("RES",ResId),"^",2)
						If ResCTPCPDR>0,$d(^CTPCP(ResCTPCPDR,1)){
							Set CarPrvTpDR = $p(^CTPCP(ResCTPCPDR,1),"^",4) ;CTPCP_CarPrvTp_DR-->CT_CarPrvTp
							Set Type = $p(^CT("CPT",CarPrvTpDR),"^",4)		;CTCPT_InternalType
							if (CareType="")||(CareType=Type) {
								Set UserRowId = $o(^SSU("SSUSR",0,"CTPCP",ResCTPCPDR,""))
								if UserRowId>0 {
									if ($d(^||LocUser(UserRowId))=0){
										Do OutputRowByUser
									}
								}
							}
						}
					}
				}While(ResId>0)
		    }
	    }
	}while(TmpCTRowId>0)
	b ;排序输出
	Set lc = ""
    For {
    	Set lc = $o(^||LocUserSort(lc))
    	Quit:lc=""
    	Set ur=""
    	For {
	    	Set ur = $o(^||LocUserSort(lc,ur))
	    	Quit:ur=""
	    	Set ^CacheTemp(repid,ind) = ^||LocUserSort(lc,ur)
	    	Set ind = ind+1
    	}
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

Init
  Set (UserName,UserCode,amStTime,amEndTime,pmStTime,pmEndTime,nightStTime,nightEndTime,am,pm,night,ProvLocCode,SchRFlag)=""
  Set (amStTimeH,amEndTimeH,pmStTimeH,pmEndTimeH,nightStTimeH,nightEndTimeH)=""
  Quit 
OutputRowByUser
	do Init
	Set SchStr = ..GetSchInfo(ResCTPCPDR,StDate)
	
	Quit:((+SchStr=0)&&(SchFlag=1))
	
	Set amStr = $p(SchStr,"^",2)
	if (amStr'="") {
		Set amStTimeH = $p(amStr,"-",1),amEndTimeH = $p(amStr,"-",2), amStTime = $zt(amStTimeH,2),amEndTime = $zt(amEndTimeH,2), am=1
	}
	Set pmStr = $p(SchStr,"^",3)
	Quit:(CurrPM&&(pmStr=""))
	if (pmStr'="") {
		Set pmStTimeH = $p(pmStr,"-",1), pmEndTimeH = $p(pmStr,"-",2),pmStTime = $zt(pmStTimeH,2), pmEndTime = $zt(pmEndTimeH,2), pm=1
	}
	Set nmStr = $p(SchStr,"^",4)
	if (nmStr'="") {
		Set nightStTimeH=$p(nmStr,"-",1),nightEndTimeH=$p(nmStr,"-",2),nightStTime = $zt(nightStTimeH,2),nightEndTime=$zt(nightEndTimeH,2), night=1	
	}
	
	Set ProvLocDr = $p(SchStr,"^",5) 
	If (ProvLocDr>0){
		Set ProvLocCode = $p($g(^CTLOC(ProvLocDr)),"^",2)
		SEt ProvLocCode = $p(ProvLocCode,"-",2)
	}
	
	;w:+SchStr=1 ResCTPCPDR,",",SchStr,!
	Quit:ProvLocCode=""
	Set ProvDr =  $p(SchStr,"^",6)
	Set SCStatusCode = $p(SchStr,"^",7)
	Set UserName = $p($g(^SSU("SSUSR",UserRowId)),"^",2)
	Set UserCode = $p($g(^SSU("SSUSR",UserRowId)),"^",1)
	;w SchStr,!
	if ((SCStatusCode="R") || (SCStatusCode="TR")){
		b ;R
		If SCStatusCode="R" {
			Set SCStatusCode = "TR" ;先显示 被替诊 
			Set SchUserRowId = $o(^SSU("SSUSR",0,"CTPCP",ProvDr,""))
			Quit:(SchUserRowId'>0)
			Set SchUserName = $p($g(^SSU("SSUSR",SchUserRowId)),"^",2)
			Set SchUserCode = $p($g(^SSU("SSUSR",SchUserRowId)),"^",1)
			Set Data =$lb(ProvLocCode,SchUserRowId,SchUserName,SchUserCode,amStTimeH,amEndTimeH,pmStTimeH,pmEndTimeH,nightStTimeH,nightEndTimeH,am,pm,night,Type,amStTime,amEndTime,pmStTime,pmEndTime,nightStTime,nightEndTime,SCStatusCode)
			Set ^||LocUser(SchUserRowId) = 1
			Set ^||LocUserSort(ProvLocCode,$i(^||LocUserSort(ProvLocCode))) = Data
			Set SCStatusCode = "R" ; 后 显示 替诊 
			Set Data =$lb(ProvLocCode,UserRowId,UserName,UserCode,amStTimeH,amEndTimeH,pmStTimeH,pmEndTimeH,nightStTimeH,nightEndTimeH,am,pm,night,Type,amStTime,amEndTime,pmStTime,pmEndTime,nightStTime,nightEndTime,SCStatusCode)
			Set ^||LocUser(UserRowId) = 1
			Set ^||LocUserSort(ProvLocCode,$i(^||LocUserSort(ProvLocCode))) = Data
		}
		if SCStatusCode="TR"{
			; 先显示 被替诊 
			Set Data =$lb(ProvLocCode,UserRowId,UserName,UserCode,amStTimeH,amEndTimeH,pmStTimeH,pmEndTimeH,nightStTimeH,nightEndTimeH,am,pm,night,Type,amStTime,amEndTime,pmStTime,pmEndTime,nightStTime,nightEndTime,SCStatusCode)
			Set ^||LocUser(UserRowId) = 1
			Set ^||LocUserSort(ProvLocCode,$i(^||LocUserSort(ProvLocCode))) = Data
			; 后 显示 替诊
			Set SCStatusCode = "R" 
			Set SchUserRowId = $o(^SSU("SSUSR",0,"CTPCP",ProvDr,""))
			Quit:(SchUserRowId'>0)
			Set SchUserName = $p($g(^SSU("SSUSR",SchUserRowId)),"^",2)
			Set SchUserCode = $p($g(^SSU("SSUSR",SchUserRowId)),"^",1)
			Set Data =$lb(ProvLocCode,SchUserRowId,SchUserName,SchUserCode,amStTimeH,amEndTimeH,pmStTimeH,pmEndTimeH,nightStTimeH,nightEndTimeH,am,pm,night,Type,amStTime,amEndTime,pmStTime,pmEndTime,nightStTime,nightEndTime,SCStatusCode)
			Set ^||LocUser(SchUserRowId) = 1
			Set ^||LocUserSort(ProvLocCode,$i(^||LocUserSort(ProvLocCode))) = Data
		}
	}else{
		Set Data =$lb(ProvLocCode,UserRowId,UserName,UserCode,amStTimeH,amEndTimeH,pmStTimeH,pmEndTimeH,nightStTimeH,nightEndTimeH,am,pm,night,Type,amStTime,amEndTime,pmStTime,pmEndTime,nightStTime,nightEndTime,SCStatusCode)
		Set ^||LocUser(UserRowId) = 1
		Set ^||LocUserSort(ProvLocCode,$i(^||LocUserSort(ProvLocCode))) = Data
	}
	Quit ""
}

/// 取出出诊时间
/// w ##class(web.DHCSSUserLogonLog).GetResEffDateTime(1522)
ClassMethod GetResEffDateTime(RBRowId)
{
	Quit:RBRowId="" ""
	Set LocDr = $P(^RB("RES",RBRowId),"^",1)
	Quit:LocDr="" ""
	Set Sub = "",SchFlag="",SCSCPCPDr="",SCStatusCode="",TimeDis="",rtn=""
	// 一个医生只有一个班次,班次是按星期排的
	Set SchDate = $O(^RB("RES",RBRowId,"DATE",0,"Date",""),-1)
	Quit:SchDate="" ""
	;1,2,3,4,5,6,0
	Set NowWeek = $zd(+$h,10)
	If NowWeek=0 Set NowWeek=7
	For{
		;User.RBResEffDate
		Set Sub = $O(^RB("RES",RBRowId,"DATE",0,"Date",SchDate,Sub))
		Quit:Sub=""
		Set SessRowId = ""
		For{
			;User.RBResEffDateSession
			Set SessRowId = $O(^RB("RES",RBRowId,"DATE",Sub,"SESS",SessRowId))
			Quit:SessRowId=""
			Set SessDOW = -1
			Set SessDOWRowid=$p(^RB("RES",RBRowId,"DATE",Sub,"SESS",SessRowId),"^",2)
			If SessDOWRowid'="" Set SessDOW=$P(^CT("DOW",1,SessDOWRowid),"^",2) ;CT_DayOfWeek
			Continue:(SessDOW'=NowWeek)
			Set TRCode="01" 
			Set TRRowId=$p(^RB("RES",RBRowId,"DATE",Sub,"SESS",SessRowId),"^",3)
			If TRRowId'="" s TRCode=$P(^DHCTimeRange(TRRowId),"^",1)
			Set SessTimeStart=$p(^RB("RES",RBRowId,"DATE",Sub,"SESS",SessRowId),"^",4)
			Set SessTimeEnd=$p(^RB("RES",RBRowId,"DATE",Sub,"SESS",SessRowId),"^",5)
			b ;
			If (TRCode="01") {
				Set $p(rtn,"^",2) =SessTimeStart_"-"_SessTimeEnd 
			}elseIf (TRCode="02"){
				Set $p(rtn,"^",3) = SessTimeStart_"-"_SessTimeEnd
			}elseIf (TRCode="03"){
				Set $p(rtn,"^",4) = SessTimeStart_"-"_SessTimeEnd
			}else{
				Set $p(rtn,"^",2) = SessTimeStart_"-"_SessTimeEnd
			}
			Set $p(rtn,"^",1)=1
			;Set TimeDis = TimeDis_"^"_SessTimeStart_"-"_SessTimeEnd
		}
	}
	;Set rtn = SchFlag_TimeDis
	Set $p(rtn,"^",5)=LocDr 
	Set $p(rtn,"^",6)=SCSCPCPDr
	Set $p(rtn,"^",7)=SCStatusCode
	Quit rtn
}

/// 走排班
ClassMethod GetStEndTime(RBRowId, SchDate = {+$h})
{
	Quit:RBRowId="" ""
	Set LocDr = $P(^RB("RES",RBRowId),"^",1)
	Set SchFlag=0,StartTime = "",SCSCDR="",SCSCLocDr="",SCSCPCPDr="",TimeDis="",SCStatusCode=""
	For {
		// 号别与医护人员表是一张
		Set StartTime = $O(^RBAS(RBRowId,0,"DateSTime",SchDate,StartTime))
		Quit:StartTime=""
		Set Sub = $O(^RBAS(RBRowId,0,"DateSTime",SchDate,StartTime,""))
		If (Sub>0){
			Set ASIrregularFlag=$p($g(^RBAS(RBRowId,Sub)),"^",13)
			//便民和体检VIP在排班报表里不显示
			Quit:ASIrregularFlag="A"
			Set EndTime = $P($G(^RBAS(RBRowId,Sub)),"^",5)
			
			Set TimeDis = TimeDis_"^"_StartTime_"-"_EndTime
			
			Set SCSCDR = $P(^RBAS(RBRowId,Sub,"DHC"),"^",12)	;替诊记录
			Set SCStatusDR = $P(^RBAS(RBRowId,Sub,"DHC"),"^",10)	;替诊记录
			Set SCStatusCode = $p(^DHCRBCASStatus(SCStatusDR),"^",1)
			Set SchFlag = "1"
			if (SCSCDR>0){
				;Set SCSCLocDr = $P(^RB("RES",+SCSCDR),"^",1)
				Set SCSCPCPDr = $P(^RB("RES",+SCSCDR),"^",2)
				;如果替诊是医护人员不是号别,UserId>0
				Set SCUserId = $o(^SSU("SSUSR",0,"CTPCP",SCSCPCPDr,""))
				if (+SCUserId>0){
					
				}
			}
		}
	}
	Set rtn = SchFlag_TimeDis
	Set $p(rtn,"^",5)=LocDr 
	Set $p(rtn,"^",6)=SCSCPCPDr
	Set $p(rtn,"^",7)=SCStatusCode
	Quit rtn
}

/// @param  ResCTPCPDR CT_CareProv--RowId
/// @param  SchDate    mDate +$h
/// @return SchFlag^am-am^pm-pm^nm-nm^CareProvDr^LocDr   排班与否^上午时间段^下午时间段^晚上时间段^替诊医护人员^号别所在科室
/// 只考虑全天替诊情况
/// w ##class(web.DHCSSUserLogonLog).GetSchInfo(1522,+$H)
ClassMethod GetSchInfo(ResCTPCPDR, SchDate = {+$h})
{
	Set OutpatientDepGroup = 3
	Quit:ResCTPCPDR="" "0^^^"
	Set CareProvDesc = $p(^CTPCP(ResCTPCPDR,1),"^",2) 
	Set:SchDate="" SchDate=+$h	
	Set StartTime = ""
	Set SchFlag = 0, TimeDis="",SCSCPCPDr="",LocDr=""
	Set MarkDr = "",rtn=""
	For{		
		Set LocDr = $O(^RB("RES",0,"CTPCP",ResCTPCPDR,LocDr)) ;-->RB_Resource
		Quit:LocDr=""
		Set LocDepGroupDr = $p(^CTLOC(LocDr),"^",19)
		;Continue:(LocDepGroupDr'=OutpatientDepGroup)
		Set RBRowId = $O(^RB("RES",0,"CTPCP",ResCTPCPDR,LocDr,"")) ;-->RB_Resource
		Quit:RBRowId=""
		Set ScheSt=$p(^RB("RES",RBRowId),"^",6)   //RES_ScheduleRequired字段?判断是不是需要排班
		Quit:(ScheSt'="Y")
		Set rtn = ..GetStEndTime(RBRowId, SchDate) ;..GetResEffDateTime(RBRowId)
		b ; GetSchInfo -1
		Quit:rtn>0
	}
	If rtn'>0 {
		For{		
			// 通过医护人员拿号别
			Set MarkDr = $O(^User.DHCMarkDocI("MarkdDocMarkIndex",ResCTPCPDR,MarkDr))
			Quit:MarkDr=""
			Set MarkDesc = $p(^CTPCP(MarkDr,1),"^",2) ;CT_CareProv--> 
			;Continue:(CareProvDesc'=MarkDesc)  ;只查询号别与医护人员名称一样的排班 龙岩二院 
			Set MDRowId = $O(^User.DHCMarkDocI("MarkdDocMarkIndex",ResCTPCPDR,MarkDr,""))
			Set LocDr = $lg(^User.DHCMarkDocD(MDRowId),4)
			Quit:LocDr=""
			Set LocDepGroupDr = $p(^CTLOC(LocDr),"^",19)
			Continue:(LocDepGroupDr'=OutpatientDepGroup)
			Set RBRowId = $O(^RB("RES",0,"CTPCP",MarkDr,LocDr,"")) ;-->RB_Resource
			Quit:RBRowId=""
			Set rtn =  ..GetStEndTime(RBRowId, SchDate) ;..GetResEffDateTime(RBRowId)
			b ;GetSchInfo-2
			Quit:rtn>0
		}
	}
	Quit rtn
}

/// @param UserCode
/// @param MessageContext
/// @return 1 成功  -1失败
ClassMethod sendMessage(UserCode, MessageContext)
{
	
	Quit:UserCode="" "-1^请选择用户!"
	//Set ^Wanghc("sendMessage",1)=UserCode_","_MessageContext
	Set UserRowId = $O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	Quit:UserRowId'>0 "-1^没有该用户"_UserCode_"!"
	Set CTCareProvDr = $p(^SSU("SSUSR",UserRowId),"^",14)
	Quit:CTCareProvDr'>0 "-1^"_UserCode_".没有手机号码!"
	Set MobilePhone = $p(^CTPCP(CTCareProvDr,3),"^",6)
	Quit:MobilePhone="" "-1^"_UserCode_".没有手机号码!"    //CT_CareProv -> CTPCP_MobilePhone
	Set PhoneLen = $l(MobilePhone)
	Quit:PhoneLen'=11 "-1^"_MobilePhone_".手机号码错误!"
	
	Set Input = "456^F001@@"_MobilePhone_"^"_MessageContext_"^^^^^^^^^^"
	Set ^Wanghc("sendMessage",2)=Input
	Set rtn = ##class(web.DHCENS.BLL.Sms.Method.SmsInterface).SendSmsInfo(Input)
	if rtn<0 Quit "-1^发送短消息失败!"
	Quit "1^发送成功!"
}

/// d ##class(%ResultSet).RunQuery("web.DHCSSUserLogonLog","FindUserLog",+$h,+$h,"d502","","")
Query FindUserLog(Stdate As %String, Enddate As %String, Guser As %String, StartTime, EndTime, OutlineFlag = 0, LocType = "", ReqLocDesc = "", InIP = "", InMAC = "") As websys.Query(ROWSPEC = "UserName:%String,UserCode:%String,Date:%String,LogonTime:%String,LogofDate:%String,LogofTime:%String,IP:%String,CompName:%String,MAC:%String,Loc:%String,SessionId:%String,LogonTimeH:%String,LogofTimeH:%String,inLine:%String,TPSName,ServerECPIP:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCSSUserLogonLog","FindUserLog",64336,64336,"",54000,50400,"")
ClassMethod FindUserLogExecute(ByRef qHandle As %Binary, Stdate As %String, Enddate As %String, Guser As %String, StartTime, EndTime, OutlineFlag = 0, LocType = "", ReqLocDesc = "", InIP = "", InMAC = "") As %Status
{
	//Set ^Wanghc("find user log",1) = Stdate_","_Enddate_","_Guser_","_StartTime_","_EndTime_","_OutlineFlag
	Set Stdate = ##class(websys.Conversions).DateHtmlToLogical(Stdate)
	Set Enddate = ##class(websys.Conversions).DateHtmlToLogical(Enddate)
	if StartTime[":" set StartTime=$zth(StartTime)
	if EndTime[":" set EndTime=$zth(EndTime)
	//Set ^Wanghc("find user log",2) = Stdate_","_Enddate_","_Guser_","_StartTime_","_EndTime_","_OutlineFlag
	
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    i Stdate="" Set Stdate=+$h
    i Enddate="" Set Enddate = +$h
    s UserRowid=""
	i Guser'=""  d
	.s Guser1=$$ALPHAUP^SSUTIL4(Guser)
	.i Guser1'=""  d
	..s UserRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",Guser1,"")) 

    Set nowDateH = +$h
    f Date=Stdate:1:Enddate d
    .s User=""
    .f  s User=$o(^SST("LOG",0,"Date",Date,User)) q:User=""  d
    ..q:(UserRowid'="")&(User'=UserRowid)
    ..s Logid="", lasterLogRowId = $O(^SST("LOG",0,"Date",Date,User,""),-1)
    ..f  s Logid=$o(^SST("LOG",0,"Date",Date,User,Logid))  q:Logid=""  d
    ...s (IP,SessionId,CompName,MAC)=""
    ...s g = $g(^SST("LOG",Logid))
    ...s UserName=$p($g(^SSU("SSUSR",User)),"^",2)
    ...s UserCode=$p($g(^SSU("SSUSR",User)),"^",1)
    ...s LogonTime=$p(g,"^",4)
    ...b ;
    ...q:(Stdate=Date)&&(StartTime'="")&&(LogonTime<StartTime)
    ...q:(Enddate=Date)&&(EndTime'="")&&(LogonTime>EndTime)
    ...b ;2
    ...s LogonTimeH = LogonTime
    ...i LogonTime'="" s LogonTime=$zt(LogonTime)
    ...s a=$g(^SST("LOG",Logid,"ADDR"))	;User.DHCClientLogin
    ...s IP=$p(a,"^",1)
    ...q:((InIP'="")&&(""=IP))||('##class(BSP.SYS.UTIL.String).IsValidIP(IP,InIP))
	...s SessionId = $p(a,"^",2)
	
    ...s CompName=$p(a,"^",4)
    ...s MAC=$p(a,"^",5)
    ...q:((InMAC'="")&&(MAC'[InMAC))
    ...s ServerECPIP = $p(a, "^", 10)
    ...s LogofDate=$p(g,"^",5)
    ...s LogofTime=$p(g,"^",6)
    ...s updateDate = $p(g,"^",8) 
    ...s updateTime = "" ;$p(g,"^",9) 
    ...S inLine=0
    ...if SessionId'="",$d(^%cspSession(SessionId))'=0,$g(^%cspSession(SessionId,0,"LOGON.SSUSERLOGINID"))=Logid,Date=nowDateH d
	....;当前会话在线
	....Set updateDate = +$h,updateTime= $p($h,",",2)
	....Set inLine = 1
	...if (lasterLogRowId=Logid)&&((LogofDate="")&&(LogofTime=""))&&(Date=nowDateH) d
	....;退出时间为空
	....Set updateDate = +$h,updateTime= $p($h,",",2)
	....Set inLine = 1
	....b ;
    ...I LogofDate="" S LogofDate=updateDate	;最后更新日期
    ...I LogofTime="" S LogofTime=updateTime	;最后更新时间
    ...s LogofTimeH=LogofTime
    ...i LogofDate'="" s LogofDate=##class(websys.Conversions).DateLogicalToHtml(LogofDate)  ;$zd(LogofDate,3)
    ...i LogofTime'="" s LogofTime=##class(websys.Conversions).TimeLogicalToHtml(LogofTime) ;$zt(LogofTime,2)
    ...s LogonLoc = $p(g,"^",7)
    ...S LogonLocType="" //S LogonLocType = $p(^CTLOC(LogonLoc),"^",13)
    ...if LocType'="" &sql(SELECT ADMLOC_AdmType Into :LogonLocType FROM SQLUser.PAC_AdmTypeLocation WHERE ADMLOC_CTLOC_DR=:LogonLoc)
    ...Q:(LocType'="")&&($G(LogonLocType)'=LocType)
    ...i LogonLoc'="" s LogonLoc = $p(^CTLOC(LogonLoc),"^",2)
    ...Q:(ReqLocDesc'="")&&(LogonLoc'=ReqLocDesc)
    ...Set TPSRowId =$p(a,"^",7),TPSName=""
    ...if TPSRowId>0,$d(^websys.ThirdPartySystemD(+TPSRowId)) d
    ....Set TPSName = $p(^websys.ThirdPartySystemD(+TPSRowId),"^",3)_" 的 "_$p(^websys.ThirdPartySystemD(+TPSRowId),"^",2)_" 模块接入"
    ...d OutputRow
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
 s Data=$lb(UserName,UserCode,##class(websys.Conversions).DateLogicalToHtml(Date),##class(websys.Conversions).TimeLogicalToHtml(LogonTime),LogofDate,LogofTime,IP,CompName,MAC,LogonLoc,SessionId,LogonTimeH,LogofTimeH,inLine,TPSName,ServerECPIP)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 Quit
}

Query FindUserFirstLog(Stdate As %String, Enddate As %String, Guser As %String, StartTime As %String, EndTime As %String, OutlineFlag = 0, LogonLoc, DepGroup) As websys.Query(ROWSPEC = "UserName:%String,UserCode:%String,Date:%String,LogonTimeH:%String,Loc:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCSSUserLogonLog","FindUserLog","2014-05-19","2014-05-19","")
ClassMethod FindUserFirstLogExecute(ByRef qHandle As %Binary, Stdate As %String, Enddate As %String, Guser As %String, StartTime, EndTime, OutlineFlag = 0, LogonLoc = "", DepGroup) As %Status
{
	SEt ^Wanghc("log")=Stdate_","_StartTime
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    q:Stdate="" $$$OK
    q:Enddate="" $$$OK
    k ^||FLog
    s UserRowid=""
	i Guser'=""  d
	.s Guser1=$$ALPHAUP^SSUTIL4(Guser)
	.i Guser1'=""  d
	..s UserRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",Guser1,"")) 
	i Stdate["/" s Stdate=$zdh(Stdate,4)
	i Enddate["/" s Enddate=$zdh(Enddate,4)
    i Stdate["-" s Stdate=$ZDH(Stdate,3)
    i Enddate["-" s Enddate=$ZDH(Enddate,3)
    i StartTime[":" s StartTime = $zth(StartTime)
    i EndTime[":" s EndTime = $zth(EndTime)
    Set nowDateH = +$h
    f Date=Stdate:1:Enddate d
    .s User=""
    .f  s User=$o(^SST("LOG",0,"Date",Date,User)) q:User=""  d
    ..q:(UserRowid'="")&(User'=UserRowid)
    ..s Logid="", lasterLogRowId = $O(^SST("LOG",0,"Date",Date,User,""),-1)
    ..f  s Logid=$o(^SST("LOG",0,"Date",Date,User,Logid))  q:Logid=""  d
    ...s g = $g(^SST("LOG",Logid))
    ...s LogonLocDr = $p(g,"^",7)
    ...S outflag=0,depgroupCode=""
    ...s depgroup = $p(^CTLOC(LogonLocDr),"^",19) ;outpat
	...S:depgroup>0 depgroupCode = $p(^RBC("DEP",depgroup),"^",2)
	...i depgroupCode="门诊科室" set outflag = 1
	...Q:(DepGroup'="")&&(DepGroup'=depgroupCode)
    ...s LogonLocDesc = $p(^CTLOC(LogonLocDr),"^",2)
    ...;Quit:LogonLocDesc'["门诊"
    ...Quit:(LogonLoc'="")&&(LogonLoc'=LogonLocDesc)
    ...s LogonTime=$p(g,"^",4)
    ...If $d(^||FLog(Date,User)) d
    ....S FTime = $p(^||FLog(Date,User),"^",2)
    ....if FTime>LogonTime S ^||FLog(Date,User) = Logid_"^"_LogonTime
	...Else  d
	....S ^||FLog(Date,User) = Logid_"^"_LogonTime
    b ;
    
    set Date="" for  set Date = $o(^||FLog(Date)) Quit:Date=""  d
    .set User="" for  set User = $o(^||FLog(Date,User)) Quit:User=""  d
    ..Set LogId = $p(^||FLog(Date,User),"^",1)
    ..Set Time = $p(^||FLog(Date,User),"^",2)
	..q:(StartTime'="")&&(Time<StartTime)
    ..q:(EndTime'="")&&(Time>EndTime)
    ..d OutputRow
    k ^||FLog
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
 set (UserName,UserCode,LogonDateH,LogonTimeH,LogonLoc)=""
 s LogStr = $g(^SST("LOG",LogId))
 s User = $p(LogStr,"^",1)
 s LogonDateH = $p(LogStr,"^",3)
 s LogonTimeH = $p(LogStr,"^",4)
 s LogonLocDr =$p(LogStr,"^",7)
 s LogonLoc = $p(^CTLOC(LogonLocDr),"^",2)
 s UserName=$p($g(^SSU("SSUSR",User)),"^",2)
 s UserCode=$p($g(^SSU("SSUSR",User)),"^",1) s Data=$lb(UserName,UserCode,LogonDateH,LogonTimeH,LogonLoc)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 Quit
}

///   d ##class(web.DHCSSUserLogonLog).ExportExcel("20/05/2016","20/05/2016","","","",0,"MZYF-门诊药房")
ClassMethod ExportExcel(Stdate As %String, Enddate As %String, Guser As %String, StartTime, EndTime, OutlineFlag = 0, LogonLoc = "", DepGrpup = "")
{
	;Set ^Wanghc("exp")=Stdate_","_ Enddate _","_ Guser _","_ StartTime_","_ EndTime_","_ OutlineFlag_","_LogonLoc
	SEt rs = ##class(%ResultSet).%New("web.DHCSSUserLogonLog:FindUserFirstLog")
	d rs.Execute(Stdate , Enddate , Guser , StartTime, EndTime, OutlineFlag,LogonLoc,DepGrpup)
	;&javascript<#("debugger;")#>
	
	while(rs.Next()){
		;UserName ,UserCode ,Date ,LogonTimeH ,Loc
		&javascript<#("setRow('"_rs.Data("UserName")_"','"_rs.Data("UserCode")_"','"_$zd(rs.Data("Date"),3)_"','"_$zt(rs.Data("LogonTimeH"))_"','"_rs.Data("Loc")_"');")#>
		;&javascript<#("row++; xlsheet.cells(row,2)='199';")#>
		;&javascript<#("row++; xlsheet.cells(row,2)='"_$tr(rs.Data("UserName"),$c(10,13),"")_"';"
		;_"xlsheet.cells(row,3)='"_rs.Data("UserCode")_"';"_"xlsheet.cells(row,4)='"_$zd(rs.Data("Date"),3)_"';"_"xlsheet.cells(row,5)='"_$zt(rs.Data("LogonTimeH"))_"';"_"xlsheet.cells(row,6)='"_rs.Data("Loc")_"';")#>
	}
	s rs =""
	q ""
}

ClassMethod Save(StDate, StTime)
{
	Set StDateH = ##class(websys.Conversions).DateHtmlToLogical(StDate)
	Set StTimeH = ##class(websys.Conversions).TimeHtmlToLogical(StTime)
	Quit StDateH_","_StTimeH
}

/// 根据IP获取在线用户
/// w ##class(web.DHCSSUserLogonLog).GetUserByIP("10.1.30.141")
ClassMethod GetUserByIP(IPAddr = "")
{
	q:IPAddr="" ""
	s nowDate=+$h,nowTime=+$p($h,",",2)
	s LogId="",ret=""
	for{
		set LogId=$o(^SST("LOG",0,"IP",IPAddr,"in",LogId),-1)  //根据IP索引取登录日志
		q:LogId=""
		s LogInfo=$g(^SST("LOG",LogId))
		s date=$p(LogInfo,"^",3)
		s time=$p(LogInfo,"^",4)
		q:((nowDate-date=1)&&(nowTime>time))||(nowDate-date>1) //只查24小时内的 
		
		s sessionId=$p($g(^SST("LOG",LogId,"ADDR")),"^",2)
		//continue:'$d(^%cspSession(sessionId))

		s UserId=$p(LogInfo,"^",1)
		s LocId=$p(LogInfo,"^",7)
		
		if ret="" set ret=UserId_"^"_LocId
		else  s ret=ret_"$$"_UserId_"^"_LocId
	}
	q ret
}

ClassMethod Force(SSULogonRowid)
{
	Quit:SSULogonRowid="" 0
	Set LOGADDRSessionId = $P($g(^SST("LOG",SSULogonRowid,"ADDR")),"^",2)
	Set mysession = ##class(%CSP.Session).%OpenId(LOGADDRSessionId)
	if mysession {
		Do mysession.Lock()
		Set mysession.AppTimeout=1 
		Do mysession.%Save()
	}
	Quit 1
}

/// 获得科室与用户在线会话LogId
ClassMethod GetLogIdByUserLoc(userCode, locDesc = "", groupDesc = "") As %Boolean
{
	
	Set myrtn=0,LOGADDRSessionId=""
	if userCode="" quit myrtn
	set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	if UserID="" quit myrtn
	Set LocId = ##class(web.CTLoc).GetIdFromCodeDescriptionHosp(locDesc)
	Quit:LocId="" myrtn
	Set GroupId = ##class(web.SSGroup).GetIdFromCodeOrDescription(groupDesc)
	Quit:GroupId="" myrtn
	Set HospID = $p($g(^CTLOC(+LocId)),"^",22)
	&sql(select StoredValue,RowID into :defmysvalue,:id from websys.StandardTypeItem 
	where ParRef='websys' and Code='UserSingleLogon')
	Q:SQLCODE myrtn
	Set SubKey = id
	Set mysvalue = ##class(websys.Preferences).GetDataExLE(UserID,GroupId,HospID,"","","STANDARD",
	SubKey,.ActiveObject,.ActiveReference,.ActiveContext,"","",LocId)
	If mysvalue="" Set mysvalue = defmysvalue
	Quit:'mysvalue 0
	// 通过1索引倒序查询
	Set MaxLoop = 1000   ; 最多循环1000次日志
	Set mydate = "" For {
		Quit:MaxLoop<1
		set mydate = $o(^SST("LOG","0","User",UserID,mydate),-1)
		Quit:mydate=""
		Set SSULogonRowid="" For{
			// 通过2索引倒序查询
			set SSULogonRowid = $o(^SST("LOG","0","Date",mydate,UserID,SSULogonRowid),-1)
			Quit:SSULogonRowid=""
			Quit:MaxLoop<1
			Set MaxLoop=MaxLoop-1
			Set LOGLogoffDate = $P(^SST("LOG",SSULogonRowid),"^",5)
			Continue:(LOGLogoffDate'="")
			If (ActiveObject="User.CTLoc"){
				Set LOGLocId = $P(^SST("LOG",SSULogonRowid),"^",7)
				IF LocId=LOGLocId {
					Set LOGADDRSessionId = $P($g(^SST("LOG",SSULogonRowid,"ADDR")),"^",2)
					Set LOGADDRIP = $P($g(^SST("LOG",SSULogonRowid,"ADDR")),"^",1)
					Set myrtn = SSULogonRowid_"^"_LOGADDRIP_"^"_LOGADDRSessionId
					Quit
				}
			}
			If (ActiveObject="User.SSGroup") {
				Set LOGGroupId = $P(^SST("LOG",SSULogonRowid),"^",10)
				IF GroupId=LOGGroupId {
					Set LOGADDRSessionId = $P($g(^SST("LOG",SSULogonRowid,"ADDR")),"^",2)
					Set LOGADDRIP = $P($g(^SST("LOG",SSULogonRowid,"ADDR")),"^",1)
					Set myrtn = SSULogonRowid_"^"_LOGADDRIP_"^"_LOGADDRSessionId
					Quit
				}
			}
		}
	}
	q myrtn
}

ClassMethod WriteLocTypeCombo()
{
	/// 默认所有权限
	Set LocTypList("O")="门诊"
	Set LocTypList("I")="住院"
	Set LocTypList("E")="急诊"
	W "<SELECT id=""LocType"" name=""LocType"" class=""hisui-combobox"" style=""width:130px;"">"
	SET VALS = $G(%request.Data("LocTypeList",1),",O,I,E")
	If $D(%request.Data("LocType",1))#2=0 Set %request.Data("LocType",1)=$p(VALS,",",1)
	
	FOR locTypeInd=1:1:$l(VALS,","){
		Set locType=$p(VALS,",",locTypeInd)
		if (locType=""){
			W "<OPTION value="""""_$case(%request.Get("LocType"),locType:" selected",:"")_">全部</OPTION>"
		}else{
			W "<OPTION value="""_locType_""""_$case(%request.Get("LocType"),locType:" selected",:"")_">"_LocTypList(locType)_"</OPTION>"
		}
	}
	W "</SELECT>"
}

}
