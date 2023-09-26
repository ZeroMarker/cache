Class web.DHCCardStatistic Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod CardStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardStatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CardStatisticExecute(ByRef qHandle As %Binary, CardOperUserDr As %String = "", StartDate As %String = "", EndDate As %String = "", ChangeCardFlag As %String = "", CardOperUser As %String = "", ReplaceCardFlag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
 i $g(ind)="" s ind=1
	s ^DHCXPTest("CardStatisticExecute")=CardOperUserDr_"^"_StartDate_"^"_EndDate_"^"_ChangeCardFlag
	i StartDate'="" s StartDate=..%ZDH(StartDate)
	i EndDate'="" s EndDate=..%ZDH(EndDate)
	f CreateDate=StartDate:1:EndDate  d 
	.s CFRowid=""
	.f  s CFRowid=$o(^DHCCARDi("CF",0,"Date",CreateDate,CFRowid)) q:CFRowid=""  d 
	..s CFUserDr=$p(^DHCCARD("CF",CFRowid),"^",9)
	..q:(CFUserDr'=CardOperUserDr)&(CardOperUserDr'="")&(CardOperUser'="")	;操作员
	..s CFUserDesc=$p(^SSU("SSUSR",CFUserDr),"^",2)
	..s CFCreatDate=$p(^DHCCARD("CF",CFRowid),"^",7)		;建卡日期
	..s CFCreatDate=..%ZD(CFCreatDate) //$zd(CFCreatDate,3)
	..s CFCreatTime=$p(^DHCCARD("CF",CFRowid),"^",8)		;建卡时间
	..s CFCreatTime=..%ZT(CFCreatTime,3)
	..s CFCancelDate=$p(^DHCCARD("CF",CFRowid),"^",13)		;退卡日期
	..i CFCancelDate'=""  s CFCancelDate=..%ZD(CFCancelDate) //$zd(CFCancelDate,3)
	..s CFCancelTime=$p(^DHCCARD("CF",CFRowid),"^",14)		;退卡时间
	..i CFCancelTime'=""  s CFCancelTime=..%ZT(CFCancelTime,3)
	..s CFCardNo=$p(^DHCCARD("CF",CFRowid),"^",2)			;卡号
	..s CFActiveFlag=$p(^DHCCARD("CF",CFRowid),"^",10)		;卡状态
	..if (CFActiveFlag="S") s CFCancelDate="",CFCancelTime=""
	..;q:(CFActiveFlag'="D")&(ChangeCardFlag="on")
	..s PapmiDr=$p(^DHCCARD("CF",CFRowid),"^",4)		;病人基本信息 
	..s PapmiInform=$$GetPapmiInform(PapmiDr)
	..;s CFFormerCardNo=""
	..;s CFFormerCardNo=$$GetFormerCardDr(CFRowid,PapmiDr)
	..s CFFormerCardInform=$$GetFormerCardInform(CFRowid,PapmiDr)
	..s FormerCardActiveFlag=$p(CFFormerCardInform,"^",1)
	..s CFChangeID=$o(^DHCCARD("CF",CFRowid,"CSC","0"))
	..s NewCardChangeActiveFlag="N"
	..if CFChangeID'="" d
	...s NewCardChangeActiveFlag=$P(^DHCCARD("CF",CFRowid,"CSC",CFChangeID),"^",3)
	..s ChangeCard=0
	..if (FormerCardActiveFlag="D")&&(NewCardChangeActiveFlag="E") s ChangeCard=1
	..if (FormerCardActiveFlag="D")&&(NewCardChangeActiveFlag="RN") s ChangeCard=2
	..q:(ChangeCardFlag="on")&&(ChangeCard'=1)
	..q:(ReplaceCardFlag="on")&&(ChangeCard'=2)
	..;q:(FormerCardActiveFlag'="D")||(NewCardChangeActiveFlag'="E")&(ChangeCardFlag="on")
	..;q:(FormerCardActiveFlag'="D")&(NewCardChangeActiveFlag'="RN")&(ReplaceCardFlag="on")
	..s CFFormerCardNo=$p(CFFormerCardInform,"^",2)
	..s EmployeeFunction="",SecretLevel=""
	..s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PapmiDr,.ErrMsg)
	..i PatEncryptLevel'="" d
	...s EmployeeFunction=$p(PatEncryptLevel,"^",2)
	...s SecretLevel=$p(PatEncryptLevel,"^",4)
	..s CardInfrom=CFUserDesc_"^"_CFCreatDate_"^"_CFCreatTime_"^"_CFCancelDate_"^"_CFCancelTime
	..s CardInfrom=CardInfrom_"^"_CFCardNo_"^"_PapmiInform_"^"_CFFormerCardNo_"^"_EmployeeFunction_"^"_SecretLevel
	..s ^CacheTemp(repid,ind)=$LB(CardInfrom,CFRowid,CFUserDesc,CFCreatDate,CFCreatTime,CFCancelDate,CFCancelTime,CFCardNo,PapmiName,PapmiSexDesc,PapmiBirth,myPatType,CFFormerCardNo,EmployeeFunction,SecretLevel)
	..s ind=ind+1
	i ind=1  {s qHandle=$lb(0,repid,0) q $$$OK}
	;合计
	s ^CacheTemp(repid,ind)=$LB("合计^"_(ind-1),"m_999","合计",ind-1,"","","","","","","","","","","")
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
GetFormerCardInform(CFRowid,PapmiDr)
	s CFFormerCardInform=""
	s CFFormerCardDr=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiDr,CFRowid),-1)
	i CFFormerCardDr'=""  d 
	.s CFFormerCardNo=$p(^DHCCARD("CF",CFFormerCardDr),"^",2)			;卡号
	.s FormerCardActiveFlag=$p(^DHCCARD("CF",CFFormerCardDr),"^",10)			;卡状态
	.s CFFormerCardInform=FormerCardActiveFlag_"^"_CFFormerCardNo 
	q CFFormerCardInform

GetPapmiInform(PapmiDr)
	; 病人基本信息
	i ('$d(^PAPER(PapmiDr,"ALL"))!'$d(^PAPER(PapmiDr,"ALL"))) q "^^^"
	s PapmiName=$p(^PAPER(PapmiDr,"ALL"),"^",1)    	;病人姓名
	s PapmiSexDr=$p(^PAPER(PapmiDr,"ALL"),"^",7)    	;性别
	s PapmiSexDesc=$p(^CT("SEX",PapmiSexDr),"^",2)
	s PapmiBirth=$p(^PAPER(PapmiDr,"ALL"),"^",6)    	;出生日期
	s PapmiBirth=..%ZD(PapmiBirth) //$zd(PapmiBirth,3)
	s myPatType=""   
	s socialstatus=$p($g(^PAPER(PapmiDr,"PER",1)),"^",10) 
	i socialstatus'="" d
	.s myPatType=$p($g(^CT("SS",socialstatus)),"^",2)           ;病人类型
	.s PapmiInform=PapmiName_"^"_PapmiSexDesc_"^"_PapmiBirth_"^"_myPatType
	q PapmiInform
}

ClassMethod CardStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardStatisticExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" 
 {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      
 {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CardStatistic(CardOperUserDr As %String = "", StartDate As %String = "", EndDate As %String = "", ChangeCardFlag As %String = "", CardOperUser As %String = "", ReplaceCardFlag As %String = "") As %Query(ROWSPEC = "CardInfrom:%String,CFRowid:%String,CFUserDesc:%String,CFCreatDate:%String,CFCreatTime:%String,CFCancelDate:%String,CFCancelTime:%String,CFCardNo:%String,PapmiName:%String,PapmiSexDesc:%String,PapmiBirth:%String,myPatType:%String,CFFormerCardNo:%String,EmployeeFunction:%String,SecretLevel:%String")
{
}

Query CardStatisticExport(CardOperUserDr As %String = "", StartDate As %String = "", EndDate As %String = "", ChangeCardFlag As %String = "", CardOperUser As %String = "", ReplaceCardFlag As %String = "") As websys.Query(ROWSPEC = "CFUserDesc:%String:操作员,CFCreatDate:%String:建卡日期,CFCreatTime:%String:建卡时间,CFCancelDate:%String:退卡日期,CFCancelTime:%String:退卡时间,CFCardNo:%String:卡号,CFFormerCardNo:%String:原卡号,PapmiName:%String:患者姓名,PapmiSexDesc:%String:性别,PapmiBirth:%String:出生日期,myPatType:%String:患者类型,EmployeeFunction:%String:患者级别,SecretLevel:%String:患者密级")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCardStatistic","CardStatisticExport","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod CardStatisticExportExecute(ByRef qHandle As %Library.Binary, CardOperUserDr As %String = "", StartDate As %String = "", EndDate As %String = "", ChangeCardFlag As %String = "", CardOperUser As %String = "", ReplaceCardFlag As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("web.DHCCardStatistic:CardStatistic")
	d rset.Execute(CardOperUserDr,StartDate,EndDate,ChangeCardFlag,CardOperUser,ReplaceCardFlag)
	While (rset.Next()) {
		s CFUserDesc=rset.Data("CFUserDesc")
		s CFCreatDate=rset.Data("CFCreatDate")
		s CFCreatTime=rset.Data("CFCreatTime")
		s CFCancelDate=rset.Data("CFCancelDate")
		s CFCancelTime=rset.Data("CFCancelTime")
		s CFCardNo=rset.Data("CFCardNo")
		s CFFormerCardNo=rset.Data("CFFormerCardNo")
		s PapmiName=rset.Data("PapmiName")
		s PapmiSexDesc=rset.Data("PapmiSexDesc")
		s myPatType=rset.Data("myPatType")
		s PapmiBirth=rset.Data("PapmiBirth")
		s EmployeeFunction=rset.Data("EmployeeFunction")
		s SecretLevel=rset.Data("SecretLevel")
		s OutputList=$lb(CFUserDesc,CFCreatDate,CFCreatTime,CFCancelDate,CFCancelTime,CFCardNo,CFFormerCardNo,PapmiName,PapmiSexDesc,PapmiBirth,myPatType,EmployeeFunction,SecretLevel)
		d OutputRow14
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow14
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

}
