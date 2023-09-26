/// 临时处理一些问题
Class web.DHCPE.Temp [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DeleteUA(GID)
{
	;d ##class(web.DHCPE.Temp).DeleteUA("1256")
	s i=0
	s ItemID="16174||1"
	s IADM=0
	f  s IADM=$O(^DHCPEPreIADM(0,"PGADM",GID,IADM)) q:IADM=""  d
	.s Status=$P(^DHCPEPreIADM(IADM),"^",8)
	.q:Status="ARRIVED"
	.q:Status="CANCELPE"
	.s ADM=$O(^DHCPEIADM(0,"CRMADM",IADM,0))
	.q:ADM=""
	.s AdmDate=$P(^DHCPEIADM(ADM),"^",5)
	.s TeamID=$P(^DHCPEIADM(ADM),"^",3)
	.;q:AdmDate>=+$H
	.s DepartDesc=$G(^DHCPEDataEx("DHCPEPreIADM","Position",IADM))
	.q:DepartDesc'=""
	.s Sub=0
	.f  s Sub=$O(^DHCPEPreIADM(0,"ItmMast",ItemID,IADM,Sub)) q:Sub=""  d
	..s CurData=$G(^DHCPEPreIADM(IADM,"ORDITEM",Sub))
	..s TItemStat=$p(CurData,"^",16) 
	..q:TItemStat'="1"
	..s PreItemID=IADM_"||"_Sub
	..w PreItemID_"^"_TeamID,!
	..s i=i+1
	..d ##class(web.DHCPE.PreItemList).IDeleteItem(IADM,"PERSON",PreItemID,"")
	w i,!
}

ClassMethod UpdateGroupBaseInfo(TeamID)
{
	;d ##class(web.DHCPE.Temp).UpdateGroupBaseInfo("1188||2")
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGTeam",TeamID,PreIADM)) q:PreIADM=""  d
	.s Status=$P(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status'="ARRIVED"
	.s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADM=""
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.q:PAADM=""
	.s PatID=$P(^PAADM(PAADM),"^",1)
	.s StatusDR=$P(^PAPER(PatID,"PER",1),"^",10)
	.q:StatusDR'="1"
	
	.d ..UpdateInfo(PatID)
}

// d ##class(web.DHCPE.Temp).UpdateInfo("4443280")

ClassMethod UpdateInfo(PatID)
{
	;s SoapObj=##class(web.DHCPE.PatServiceSoap).%New()
	;s Info=SoapObj.GetPatInfo(PatID)
	q:Info=""
	s obj=##class(User.PAPerson).%OpenId(PatID)
	s obj.PAPERAgeDay=$P(Info,"^",1)
	s obj.PAPERAgeMth=$P(Info,"^",2)
	s obj.PAPERAgeYr=$P(Info,"^",3)
	s obj.PAPERDob=$P(Info,"^",4)
	s obj.PAPERName=$P(Info,"^",5)
	d obj.PAPERSexDRSetObjectId($P(Info,"^",6))
	s obj.PAPERAge=$P(Info,"^",7)
	d obj.PAPERUserUpdateSetObjectId($P(Info,"^",8))
	d obj.PAPERCountryDRSetObjectId($P(Info,"^",9))
	d obj.PAPERCTProvinceDRSetObjectId($P(Info,"^",10))
	d obj.PAPERCityCodeDRSetObjectId($P(Info,"^",11))
	d obj.PAPERLangPrimDRSetObjectId($P(Info,"^",12))
	d obj.PAPERNationDRSetObjectId($P(Info,"^",13))
	d obj.PAPERReligionDRSetObjectId($P(Info,"^",14))
	d obj.PAPERMaritalDRSetObjectId($P(Info,"^",15))
	d obj.PAPEREducationDRSetObjectId($P(Info,"^",16))
	d obj.PAPERSocialStatusDRSetObjectId($P(Info,"^",17))
	s obj.PAPERForeignId=$P(Info,"^",18)
	d obj.PAPERZipDRSetObjectId($P(Info,"^",19))
	s obj.PAPERTelH=$P(Info,"^",20)
	s obj.PAPERTelO=$P(Info,"^",21)
	s obj.PAPERSecondPhone=$P(Info,"^",22)
	s obj.PAPERNokAddress2=$P(Info,"^",23)
	;s obj.PAPERID=$P(Info,"^",24)
	d obj.PAPEREmplTypeDRSetObjectId($P(Info,"^",25))
	s obj.PAPERNokText=$P(Info,"^",26)
	d obj.PAPERHCPDRSetObjectId($P(Info,"^",27))
	d obj.PAPERCTHCADRSetObjectId($P(Info,"^",28))
	s obj.PAPEREmployeeNo=$P(Info,"^",29)
	s sc=obj.%Save()
	w sc,!
}

ClassMethod UpdateSpecNo(TeamID)
{
	;d ##class(web.DHCPE.Temp).UpdateSpecNo("1478||5")
	s XCGItemID="21485||1"
	s YMItemID="21989||1"
	s i=0
	s j=0
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGTeam",TeamID,PreIADM)) q:PreIADM=""  d
	.;q:PreIADM'="85526"
	.s Status=$P(^DHCPEPreIADM(PreIADM),"^",8)
	.;q:Status'="REGISTERED"
	.s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADM=""
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.q:PAADM=""
	.s Order=$O(^OEORD(0,"Adm",PAADM,0))
	.s (OldSpecNo,NewSpecNo)=""
	.q:Order=""
	.s i=i+1
	.s SttDat=""
	.s XCGOEID=""
	.f  s SttDat=$O(^OEORDi(0,"ARCIM",Order,XCGItemID,SttDat)) q:SttDat=""  d
	..s OrderSub=""
	..f  s OrderSub=$O(^OEORDi(0,"ARCIM",Order,XCGItemID,SttDat,OrderSub)) q:OrderSub=""  d
	...s Stat=$p($G(^OEORD(+Order,"I",OrderSub,1)),"^",13)
	...q:Stat=4
	...s OldSpecNo=$p($G(^OEORD(+Order,"I",OrderSub,3)),"^",20)
	...s XCGOEID=Order_"||"_OrderSub
	.w:XCGOEID="" "没有血常规",!
	.q:XCGOEID=""
	.s SttDat=""
	.f  s SttDat=$O(^OEORDi(0,"ARCIM",Order,YMItemID,SttDat)) q:SttDat=""  d
	..s OrderSub=""
	..f  s OrderSub=$O(^OEORDi(0,"ARCIM",Order,YMItemID,SttDat,OrderSub)) q:OrderSub=""  d
	...s Stat=$p($G(^OEORD(+Order,"I",OrderSub,1)),"^",13)
	...q:Stat=4
	...s NewSpecNo=$p($G(^OEORD(+Order,"I",OrderSub,3)),"^",20)
	.s j=j+1
	.w NewSpecNo_"^"_OldSpecNo_"^"_XCGOEID,!
	.;q
	.&SQL(Update Sqluser.OE_OrdItem set OEORI_LabEpisodeNo=:NewSpecNo where OEORI_RowID=:XCGOEID)
	w i_"^"_j,!
}

ClassMethod DealJY()
{
	
	s Date=""
	f  s Date=$O(^DHCPESpecial("DHCPE","DateIndex",Date)) q:Date=""  d
	.s Time=""
	.f  s Time=$O(^DHCPESpecial("DHCPE","DateIndex",Date,Time)) q:Time=""  d
	..s OEID=""
	..f  s OEID=$O(^DHCPESpecial("DHCPE","DateIndex",Date,Time,OEID)) q:OEID=""  d
	...s TimeInfo=$G(^DHCPESpecial("DHCPE","UserID",OEID))
	...s OldDate=$P(TimeInfo,"^",2)
	...s OldTime=$P(TimeInfo,"^",3)
	...i (OldDate'=Date)||(OldTime'=Time)  d
	....k ^DHCPESpecial("DHCPE","DateIndex",Date,Time,OEID)
	;^DHCPESpecial("DHCPE","DateIndex",Date,Time,OEID)
	;.k ^DHCPESpecial("DHCPE","UserID",OEID) 
	;d ##class(web.DHCPE.Temp).DealJY()
	
	
	s Date=63133
	f  s Date=$o(^DHCPERLT("0","DateOrder",Date)) q:(Date="")  d
	.s OEORIRowid=""
	.f  s OEORIRowid=$o(^DHCPERLT("0","DateOrder",Date,OEORIRowid)) q:OEORIRowid=""  d
	..s ItemMastID=$P(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1),"^",2)
	..s Flag=$G(^DHCPECTDataEx("DHCPEStationOrder","SignItem",ItemMastID))
	..q:Flag'="Y"
	..s Time="1200"
	..s $P(^DHCPESpecial("DHCPE","UserID",OEORIRowid),"^",2)=Date
	..s $P(^DHCPESpecial("DHCPE","UserID",OEORIRowid),"^",3)=Time
	..s ^DHCPESpecial("DHCPE","DateIndex",Date,Time,OEORIRowid)=""
	
	q
	.s user=+$g(^DHCPESpecial("DHCPE","UserID",OIID))
	.s:(user'="") UserName=$p($g(^SSU("SSUSR",user)),"^",2)
	.s OIID=OIID_"^"_CurStatus
	.s TCheckDate=$P($g(^DHCPESpecial("DHCPE","UserID",OIID)),"^",2)
	.s:TCheckDate'="" TCheckDate=$ZD(TCheckDate,3)
	
	s ID="0"
	f  s ID=$O(^DHCPEED(ID)) q:ID=""  d
	.s Detail=$P(^DHCPEED(ID,"Detail"),"^",1)
	.s Detail=##class(web.DHCPE.Public.Setting).Replace(Detail,"..","。")
	.s Detail=##class(web.DHCPE.Public.Setting).Replace(Detail,".","。")
	.s Detail=##class(web.DHCPE.Public.Setting).Replace(Detail,",","，")
	.s Length=$L(Detail)
	.w $E(Detail,Length,Length),!
	.i $E(Detail,Length,Length)'="。" s Detail=Detail_"。"
	.s $P(^DHCPEED(ID,"Detail"),"^",1)=Detail
}

ClassMethod ReSendInfo()
{
	;d ##class(web.DHCPE.Temp).ReSendInfo()
	s OEID=""
	f  s OEID=$O(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEID)) q:OEID=""  d
	.i $D(^DHCPERLT(0,"OEORI",OEID)) d
	..s obj=##class(User.OEOrdItem).%OpenId(OEID)
	..k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEID)
	q
	s Date=+$H
	s time=""
	f  s time=$O(^DHCPEIADM(0,"AdmDateTime",Date,time)) q:time=""  d
	.s adm=""
	.f  s adm=$O(^DHCPEIADM(0,"AdmDateTime",Date,time,adm)) q:adm=""  d
	..s PAADM=$P(^DHCPEIADM(adm),"^",1)
	..s status=$P(^DHCPEIADM(adm),"^",8)
	..q:status'="ARRIVED"
	..;w PAADM,!
	..d ##class(web.DHCPE.CRM.RisGateway).GetPAADM(PAADM, "ARRIVED")
	;##class(web.DHCPE.CRM.RisGateway).GetPAADM(4228109, "ARRIVED")
}

ClassMethod UpdateOldTar()
{
	;d ##class(web.DHCPE.Temp).UpdateOldTar()
	//s TaritemDR=$p($g(^DHCPEOEITEM(prtid,"OEITEM",PIOIRowid,"TARITEM",itmsub)),"^",1)
	s prtid=""
	f  s prtid=$O(^DHCPEOEITEM(prtid)) q:prtid=""  d
	.s PIOIRowid=""
	.f  s PIOIRowid=$O(^DHCPEOEITEM(prtid,"OEITEM",PIOIRowid)) q:PIOIRowid=""  d
	..i '$D(^DHCPEINVPRT(prtid)) d
	...k ^DHCPEOEITEM(prtid)
	..q:'$D(^DHCPEINVPRT(prtid))
	..;q
	..s PIOSID=$P(^DHCPEPreIADM(+PIOIRowid,"ORDITEM",$P(PIOIRowid,"||",2)),"^",2)
	..q:PIOSID=""
	..s SetID=$p($g(^DHCPEPreIADM(+PIOIRowid,"ORDENT",$P(PIOSID,"||",2))),"^",1)
	..s TarItemID=$G(^DHCPEDataEx("DHCPEBaseData","taritem",SetID))
	..s:TarItemID="" ^TempDHCPEUpdTar("NoTar",SetID)=$P(^ARCOS(SetID),"^",2)
	..q:TarItemID=""
	..s itmsub=""
	..f  s itmsub=$O(^DHCPEOEITEM(prtid,"OEITEM",PIOIRowid,"TARITEM",itmsub)) q:itmsub=""  d
	...s ^TempDHCPEUpdTar("Upd",prtid,PIOIRowid,itmsub)=$P(^DHCPEOEITEM(prtid,"OEITEM",PIOIRowid,"TARITEM",itmsub),"^",1)
	...s $P(^DHCPEOEITEM(prtid,"OEITEM",PIOIRowid,"TARITEM",itmsub),"^",1)=TarItemID
	...;w "NewTar:"_TarItemID_"^OldTar:"_$P(^DHCPEOEITEM(prtid,"OEITEM",PIOIRowid,"TARITEM",itmsub),"^",1),!
}

ClassMethod UpdateOrderInfo(OEOrderID, ArcimID, isDel As %String = 0)
{
	
	
	//$O(^DHCPECRMO(0,"OEORI",OrderItemID,0))
	s CrmID=$O(^DHCPECRMO(0,"OEORI",OEOrderID,0))
	q:CrmID="" ""
	s PreItemID=$P(^DHCPECRMO(CrmID),"^",2)
	q:PreItemID=""
	i isDel'=0{
		q ##class(web.DHCPE.PreItemList).IDeleteItem(+PreItemID,"PERSON",PreItemID,"")
	}
	&SQL(Update Sqluser.DHC_PE_PreIOrdItem set PIOI_ItmMast_DR = :ArcimID where PIOI_RowID=:PreItemID)
	q SQLCODE
}

ClassMethod UpdateXD()
{
	;d ##class(web.DHCPE.Temp).UpdateXD()
	s rltid="0"
	f  s rltid=$O(^DHCPERLT(rltid)) q:rltid=""  d
	.q:rltid="LabSpecNo"
	.s result=$P(^DHCPERLT(rltid),"^",4)
	.q:result'[("率,，")
	.s newresult=##class(web.DHCPE.Public.Setting).Replace(result,"率,，","律，")
	.s $P(^DHCPERLT(rltid),"^",4)=newresult
}

ClassMethod UpdateAP()
{
	;d ##class(web.DHCPE.Temp).UpdateAP()
	;s Name=$p($G(^DHCPEDataEx("DHCPEAD","Info",RowID)),"^",1)
	s ID=""
	f  s ID=$O(^DHCPEDataEx("DHCPEAD","Info",ID)) q:ID=""  d
	.s Name=$p($G(^DHCPEDataEx("DHCPEAD","Info",ID)),"^",1)
	.s Length=$L(Name,"(")
	.s CardNo=""
	.i Length>1 d
	..s CardNo=$P(Name,"(",Length)
	..s Name=$P(Name,"(",1,Length-1)
	.s $p(^DHCPEDataEx("DHCPEAD","Info",ID),"^",4)=CardNo
	.s $p(^DHCPEDataEx("DHCPEAD","Info",ID),"^",1)=Name
}

ClassMethod SendInfoToHH()
{
	;d ##class(web.DHCPE.Temp).SendInfoToHH()
	s IADM=0
	f  s IADM=$O(^DHCPEIADM(0,"Status","ARRIVED",IADM)) q:IADM=""  d
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.w ##class(web.DHCPE.CRM.Gateway).GetPatientInfoForHH(PAADM),!
}

ClassMethod CheckLocOrder()
{
	;d ##class(web.DHCPE.Temp).CheckLocOrder()
	s ArcimID=""
	f  s ArcimID=$O(^DHCPEStationOrder("Loc",ArcimID)) q:ArcimID=""  d
	.i '$D(^DHCPEST(0,"STORD_ARCIM",ArcimID)) d
	..d ##class(web.DHCPE.StationLoc).DeleteDetail(ArcimID)
	..w "LocHad:"_ArcimID_"^"_$P(^ARCIM(+ArcimID,1,1),"^",1)_"^"_$P(^ARCIM(+ArcimID,1,1),"^",3)_"^"_$P(^ARCIM(+ArcimID,1,1),"^",2),!
	s Sub=0
	f  s Sub=$O(^DHCPEST(7,"O",Sub)) q:Sub=""  d
	.s ArcimID=$P(^DHCPEST(7,"O",Sub),"^",1)
	.q:ArcimID=""
	.i '$D(^DHCPEStationOrder("Loc",ArcimID)) d
	..w "OrdHad:"_ArcimID_"^"_$P(^ARCIM(+ArcimID,1,1),"^",1)_"^"_$P(^ARCIM(+ArcimID,1,1),"^",3)_"^"_$P(^ARCIM(+ArcimID,1,1),"^",2),!
}

/// aaa
/// 看团体人数在那个里面有显示
/// d ##class(web.DHCPE.Temp).FXPersonTotalTemp(17)
ClassMethod FXPersonTotalTemp(PreGADM)
{
	//报告人员名单
	s split="^"
	s Type="Report"
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.s ^TMPGREPORT("DS", "TotalCount")=$G(^TMPGREPORT("DS", "TotalCount"))+1
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERName=$p(^PAPER(PAPMIdr,"ALL"),"^",1)
	.s PAPMIIPNo=$p(^PAPER(PAPMIdr,"PAT",1),"^",1)
	.s GSRowId=0
	.// DHC_PE_GeneralSummarize 总检结论
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM",IADMRowId,GSRowId)) Q:(""=GSRowId)  d
	..//DHC_PE_GSDiagnosis
	..s AuditUser=$p(^DHCPEGS(GSRowId,1),"^",7)
	..q:AuditUser=""
	..s ^renzwangTemp(PAPMIIPNo,Type)=PreIADM_split_PAPERName
	//预约人员名单
	s Type="PreADM"
	s Sub=0
	f  s Sub=$o(^DHCPEPreGADM(PreGADM,"Team",Sub)) q:Sub=""  d
	.s id=PreGADM_"||"_Sub
	.s iAdm=0
	.f  s iAdm=$o(^DHCPEPreIADM(0,"PGTeam",id,iAdm)) q:iAdm=""  d
	..s PIBI=$p(^DHCPEPreIADM(iAdm),"^",1)
	..s PAPMIIPNo=$p(^DHCPEPreIBI(PIBI),"^",1)
	..s PAPERName=$p(^DHCPEPreIBI(PIBI),"^",2)
	..s PEIADM=$o(^DHCPEIADM(0,"CRMADM",iAdm,0))
	..q:PEIADM=""
	..s PAADM=$p($G(^DHCPEIADM(PEIADM)),"^",1)
	..s RLTDR=$o(^DHCPERLT(0,"ADM",PAADM,0))
	..q:RLTDR=""
	..s ^renzwangTemp(PAPMIIPNo,Type)=iAdm_split_PAPERName
	//输出有差异人员名单
	w "有差异人员名单如下",!,!
	w "顺序号^登记号^ADM号^姓名^在那个类别中存在",!
	s RegNo=0
	s j=0
	f  s RegNo=$o(^renzwangTemp(RegNo))  q:RegNo=""  d
	.s i=0
	.s Type=""
	.f  s Type=$o(^renzwangTemp(RegNo,Type)) q:Type=""  d
	..s i=i+1
	..s wType=Type
	..s Info=$G(^renzwangTemp(RegNo,Type))
	.i i=1 d
	..s j=j+1
	..w j_split_RegNo_split_Info_split_wType
	//删除临时数据
	k ^renzwangTemp
	
	q ""
}

/// w ##class(web.DHCPE.Temp).splitLine("^癌胚抗原+甲胎蛋白^甲胎蛋白,癌胚抗原^2253780^站点名称^是否加项")
ClassMethod splitLine(vLine)
{
	s lstDesc=$P(vLine,"^",1)
	s laricmDesc=$P(vLine,"^",2)
	s lNotice=$P(vLine,"^",3)
	s lOEORILabEpisodeNo=$P(vLine,"^",4)
	s STName=$P(vLine,"^",5)
	s AddItem=$P(vLine,"^",6)
	s ^TMPPOI("GetPatOrdItemInfo","ItemOrder",$j)=+$g(^TMPPOI("GetPatOrdItemInfo","ItemOrder",$j))+1
	s ItemOrder=$g(^TMPPOI("GetPatOrdItemInfo","ItemOrder",$j))
	// 项目名称折行
	s iLLoop=1
	s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	s LineLength=2
	do{ 
		s strLine=$e(laricmDesc,1,LineLength)
		s laricmDesc=$e(laricmDesc,LineLength+1,$l(laricmDesc))
		s laricmDescs(iLLoop)=strLine
		s:($l(laricmDesc)=1) laricmDescs(iLLoop)=laricmDescs(iLLoop)_laricmDesc
		s:($l(laricmDesc)=1) laricmDesc=""
		s laricmDescs=iLLoop
		s iLLoop=iLLoop+1
		//s:(9=+LineLength) LineLength=7 //除第一行取9个字符,以下行取7个字符
	}
	while (laricmDesc'="")
	// 项目备注折行
	s iLLoop=1
	s LineLength=3
	do{ 
		s strLine=$e(lNotice,1,LineLength)
		s lNotice=$e(lNotice,LineLength+1,$l(lNotice))
		s lNotices(iLLoop)=strLine
		s:($l(lNotice)=1) lNotices(iLLoop)=lNotices(iLLoop)_lNotice
		s:($l(lNotice)=1) lNotice=""
		s lNotices=iLLoop
		s iLLoop=iLLoop+1
		//s:(28=+LineLength) LineLength=27 //除第一行取30个字符,以下行取28个字符
	}
	while (lNotice'="")
	
	s ret=""
	s iLLoop=1
	s prefix=""
	while (lNotices>=iLLoop)||(laricmDescs>=iLLoop){
		
	 i ""'=$G(laricmDescs(iLLoop)) d
	 .s ret=ret_lstDesc_"^"_prefix_$G(laricmDescs(iLLoop))
	 e  d
	 .s ret=ret_lstDesc_"^"_""
	 
	 i ""'=$G(lNotices(iLLoop)) d
	 .s ret=ret_"^"_$tr(prefix,"")_$G(lNotices(iLLoop))
	 .//_"^"_lOEORILabEpisodeNo
	 e  d
	 .s ret=ret_"^"_""
	 .//_"^"_lOEORILabEpisodeNo
	 //_"^"_STName_"^"_AddItem
	 //s ret=ret_"^"_ItemOrder_";"
	 
	 i iLLoop=1 d
	 .s ret=ret_"^"_lOEORILabEpisodeNo_"^"_ItemOrder_"^"_STName_"^"_AddItem_";"
	 e  d
	 . s ret=ret_"^^"_ItemOrder_"^^;"
	 
	 s:(7=+LineLength) strLine=""_strLine //除第一行取9个字符,以下行取7个字符
	 s lstDesc=""
	 s prefix=""
	 s iLLoop=iLLoop+1
	}
	Q ret
}

/// 测试库上设置的餐前餐后、注意事项更新到正式库上
/// d ##class(web.DHCPE.Temp).SetTempGlobal(0)
/// 0 得到   更新
ClassMethod SetTempGlobal(Flag)
{
	s st=0
	f  s st=$o(^DHCPEST(st)) q:st=""  d
	.s OrdSub=0
	.f  s OrdSub=$o(^DHCPEST(st,"O",OrdSub)) q:OrdSub=""  d
	..i Flag=0 d
	...s Diet=$p(^DHCPEST(st,"O",OrdSub),"^",2)
	...s Notice=$p(^DHCPEST(st,"O",OrdSub),"^",5)
	...s ^TempDHCPE(st_"||"_OrdSub)=Diet_"^"_Notice
	..e  d
	...s Diet=$p($G(^TempDHCPE(st_"||"_OrdSub)),"^",1)
	...s Notice=$p($G(^TempDHCPE(st_"||"_OrdSub)),"^",2)
	...s $p(^DHCPEST(st,"O",OrdSub),"^",2)=Diet
	...s $p(^DHCPEST(st,"O",OrdSub),"^",5)=Notice
	..
}

/// d ##class(web.DHCPE.IMPMenuAndCompont).SQLTest("websys","ComponentItems")
ClassMethod SQLTest(SchemaName, TableName)
{
	set rs = ##class(%ResultSet).%New("%SQL.Manager.Catalog:Fields")
	do rs.Execute(SchemaName,TableName)
	set longest = ""
	while rs.Next() {
	  	if rs.Get("COLUMN_NUMBER")'=1,rs.Get("HIDDEN")'="Yes" {
			;set cnt = cnt + 1
	  		set colname = rs.Get("FIELD_NAME")
	  		set Number=rs.Get("COLUMN_NUMBER")
	  		/*w rs.Nextcolname,!
	  		set datatype = rs.Get("DATATYPE")
	  		set colwidth = rs.Get("MAXLEN")
	  		set colwidth = $s(colwidth=0&(datatype["%Boolean"):3,1:17)
	  		set whole = colname_"^"_datatype_"^"_colwidth
	  		if $l(colname) > $l(longest) set longest = colname
			set properties(colname) = whole*/
	  	}
	}
	do rs.%Close()
}

/// w ##class(web.DHCPE.IMPMenuAndCompont).ZF("User.DHCPEGTeam",.items)
/// w ##class(web.DHCPE.IMPMenuAndCompont).ZF("User.DHCPEGADM",.items)
ClassMethod ZF(clsName As %String, ByRef items As %String) As %Status
{
	n (clsName,items)
	q:##class(%Library.ClassDefinition).%ExistsId(clsName)=0 0
	s clsDef=##class(%Library.ClassDefinition).%OpenId(clsName)
	s clsProList=clsDef.Properties
	f Num=1:1:clsProList.Count()
	{
		s clsPro=clsProList.GetAt(Num)
		s proSqlNumber=clsPro.SqlColumnNumber
		s proName=clsPro.Name
		q:clsPro.Cardinality="children"
		s items(+proSqlNumber)=proName
	}
	q 1
}

// d ##class(web.DHCPE.Temp).Test('65637',244)

ClassMethod Test(PreAdm, GSDRowId)
{
	
	s OrdSub=0
	f  s OrdSub=$O(^DHCPEPreIADM(PreAdm,"ORDITEM",OrdSub)) q:(OrdSub="")  d
	.s DietFlag=$P(^DHCPEPreIADM(PreAdm,"ORDITEM",OrdSub),"^",2)
	.s Stat=$P(^DHCPEPreIADM(PreAdm,"ORDITEM",OrdSub),"^",16)
	.q:Stat'="1"
	.s CrmOrderID=$O(^DHCPECRMO(0,"CRMORI",PreAdm_"||"_OrdSub,0))
	.q:CrmOrderID=""
	.s OrdItemID=$P(^DHCPECRMO(CrmOrderID),"^",1)
	.s Stat=$P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",13)
	.;q:Stat="6" ;执行的退出
	.q:(Stat="1")&&$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrdItemID)) ;谢绝检查的退出
	.s ItemMastID=$P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",2)
	.w ItemMastID,!
	.;q:ItemMastID=""   ;20140108
	.s STID=$O(^DHCPEST(0,"STORD_ARCIM",ItemMastID,0))
	
	
	q
	
	
	
	
	q:$g(EpisodeID)="" ""
	;s UserId=%session.Get("LOGON.USERID")
	s IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
	q:IAdm="" 0
	k ^DHCPEGenED("GetSummarize",EpisodeID)
	s loc=238 //%session.Get("LOGON.CTLOCID")
	s risStationStr="^"_$G(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	s labStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	s risStationStr=risStationStr_labStation_"^"
	s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	s sexStr=$P(ageSexStr,"^",2)
	s EDRowId=0
	
	f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
	.q:$D(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId))
	.s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
	.q:activeFlag'="Y"
	.s conditionFlag=$G(^DHCPEDataEx("DHCPEExpertDiagnosis","ConditionFlag",EDRowId))
	.s EDCRowId=0
	.s AllFlag=1 //是否满足所有条件
	.s PDFlag=0 //看是否设置了诊断条件0：没设置
	.f  s EDCRowId=$o(^DHCPEED(EDRowId,"EDC",EDCRowId)) q:(EDCRowId="")  d
	..;s Flag=1
	..s orderDetailStandardID=$P(^DHCPEED(EDRowId,"EDC",EDCRowId),"^",1)
	..s Normal=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",6)
	..q:Normal="Y"
	..s orderDetailID=$P(orderDetailStandardID,"||",1,2)
	..q:orderDetailID=""
	..s ItemType=$P($g(^DHCPEST(+orderDetailID,"OD",$P(orderDetailID,"||",2))),"^",2)
	..s curSex=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",1)
	
	..//s curSex=$P($g(^DHCPEST(+orderDetailID,"OD",$P(orderDetailID,"||",2))),"^",9)
	..q:(curSex'="N")&&(curSex'=sexStr)
	..;s PDFlag=1  //有设置条件
	..s risFlag=0
	..s:risStationStr[("^"_+orderDetailStandardID_"^") risFlag=1
	..d GetAllSummarize
	.s:(PDFlag=1)&&(AllFlag=1) ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
	
	
	s SQLCODE=0
	s EDRowId=0
	s UpdateDate=+$H
	s UpdateTime=$p($H,",",2) 
	f  s EDRowId=$o(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)) q:EDRowId=""  d
	.q:^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=0
	.s Advice=$p(^DHCPEED(EDRowId,"Detail"),"^",1)
	.s DisplayDesc=$p(^DHCPEED(EDRowId,"1"),"^",1)
	.w DisplayDesc_"^"_EDRowId,!
	.s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId)=DisplayDesc  //Add 20080728
	.i $g(DisplayDesc)="" s DisplayDesc="空"
	.s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",DisplayDesc,GSDRowId)=$h   //Add 20080728
	k ^DHCPEGenED("GetSummarize",EpisodeID)
	q SQLCODE

GetAllSummarize
	s:'$D(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID)) Flag=0
	If ItemType="N" Do CheckNumResult
	If ItemType="C" Do CheckNumResult
	If ItemType="T" Do CheckTextResult
	If ItemType="S" Do CheckTextResult
	q
	
CheckNumResult
	s Min=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",4)
	s Max=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",5)
	s rltID=0
	f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
	.s Flag=1
	.s PDFlag=1
	.s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
	.s:+rltValue<Min Flag=0,AllFlag=0
	.s:+rltValue>Max Flag=0,AllFlag=0
	.q:Flag=0
	.s:conditionFlag'="1" ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
	q
CheckTextResult
	s standardText=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",2)
	s rltID=0
	f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
	.s Flag=1
	.s PDFlag=1
	.s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
	.s:(rltValue'=standardText)&&(risFlag=0) Flag=0,AllFlag=0
	.s:(rltValue'[standardText)&&(risFlag=1) Flag=0,AllFlag=0
	.q:Flag=0
	.s:conditionFlag'="1" ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
	q
}

ClassMethod SendPacsInfo()
{
}

// d ##class(web.DHCPE.Temp).ImportEx()

ClassMethod ImportEx()
{
	s STRowId=""
	f  s STRowId=$O(^DHCPETempED(STRowId)) q:STRowId=""  d
	.s sub=0
	.f  s sub=$O(^DHCPETempED(STRowId,sub)) q:sub=""  d
	..//q:(STRowId="49")&&(sub<11)
	..s DiagnoseConclusion=$O(^DHCPETempED(STRowId,sub,""))
	..s EDA=$O(^DHCPETempED(STRowId,sub,DiagnoseConclusion,""))
	..s Detail=""
	..s oneSub=""
	..f  s oneSub=$O(^DHCPETempED(STRowId,sub,DiagnoseConclusion,EDA,oneSub)) q:oneSub=""  d
	...s oneDetail=$G(^DHCPETempED(STRowId,sub,DiagnoseConclusion,EDA,oneSub))
	...s oneDetail=..Test(oneDetail)
	...s Detail=Detail_oneDetail
	..s DiagnoseConclusion=..Test(DiagnoseConclusion)
	..s EDA=..Test(EDA,"1")
 	..s Code=+$O(^DHCPEED(0,"CODE",""),-1)+1
 	..s Code=##class(web.DHCPE.DHCPECommon).RegNoMask(Code)
 	..s Illness="Y"
 	..s CommonIllness="Y"
 	..&SQL(
 		INSERT INTO sqluser.DHC_PE_ExpertDiagnosis(
 			ED_Code,ED_DiagnoseConclusion,ED_Detail,ED_Illness,ED_CommonIllness,ED_Station_DR
 		) VALUES (
 			:Code,:DiagnoseConclusion,'',:Illness,:CommonIllness,:STRowId)
 		)
	..i SQLCODE'=0 d
	...w STRowId_"^"_sub
 	..q:SQLCODE'=0
 	..s EDRowID=%ROWID
 	..S $p(^DHCPEED(EDRowID,"Detail"),"^",1)=Detail
 	..//S $p(^DHCPEED(EDRowID,1),"^",1)=DiagnoseConclusion
 	..s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowID)="Y"
 	..d InsertEDAlias(EDRowID,EDA)
 	q 
InsertEDAlias(EDRowId,EDAlias)
	i EDAlias'=""
	{
		s i=$l(EDAlias,";")
		s j=1
		while(j<=i)
		{
			s EDAlia=$p(EDAlias,";",j)
			//if EDAlia="" continue
			s Strings="^"_EDRowId_"^"_EDAlia
			s SQLCODE=##class(web.DHCPE.DHCPEExpertDiagnosis).UpdateAlias(Strings,"0")
			s j=j+1
		}
	}
 	q
}

// d ##class(web.DHCPE.Temp).ChartTest(25)

ClassMethod ChartTest(ChartBook)
{
	Set ChartList=$LIST(^epr.ChartBookD(ChartBook),2)
	Set ListCount=$ListLength(ChartList)
	For i=1:1:ListCount Do
	.Set ChartId=$List(ChartList,i)
	.Set ChartId=$List(ChartId)
	.Set Chart=$List(^ooChartD(ChartId),4)
	.w ChartId_"^"_Chart,!
}

// d ##class(web.DHCPE.Temp).UpdatePosition("13||5","退休男")

// w ##class(web.DHCPE.Temp).UpdatePerson("13")

ClassMethod UpdatePerson(GID)
{
	s i=0
	s iadm=0
	s SQLCODE=0
	TSTART
	f  s iadm=$O(^DHCPEUpdatePersonTeam(iadm)) q:(iadm="")||(i>20)||(SQLCODE'=0)  d
	.s TeamID=$p(^DHCPEPreIADM(iadm),"^",3)
	.k ^DHCPEUpdatePersonTeam(iadm)
	.s SQLCODE=##Class(web.DHCPE.PreItemList).IInsOrd4NewPat(TeamID, iadm, 1642)
	.i ""=SQLCODE s SQLCODE=0
	.i SQLCODE'=0 w iadm,!
	.s i=i+1
	i SQLCODE=0{
		TCOMMIT
	    q "SUSS"_"^"_i
	}
	TROLLBACK
	q "ERR"
	w i,!
}

// d ##class(web.DHCPE.Temp).setlX()

ClassMethod setlX()
{
	s id=0
	f  s id=$O(^DHCPEINVPRT(id)) q:id=""  d
	.s amt=$p(^DHCPEINVPRT(id),"^",7)
	.q:amt<0
	.s aduits=..GetAudits(id)
	.d ##class(web.DHCPE.Cashier).GetFeeInfo(id,aduits,amt)
}

ClassMethod GetAudits(invid)
{
	s str=""
	s PBID=$P($g(^DHCPEINVPRT(invid)),"^",3)
	q:PBID="" ""
	s relateId=0
	f  s relateId=$o(^DHCPEPAPBR(0,"PBDR",PBID,relateId)) q:relateId=""  d
	.s preAuditId=$p($g(^DHCPEPAPBR(relateId)),"^",1)
	.q:preAuditId=""
	.i str="" d
	..s str=preAuditId
	.e  d
	...s str=str_","_preAuditId
	q str
}

// w ##class(web.DHCPE.Temp).SetExLoc("152")

ClassMethod SetExLoc(LocID)
{
	s SQLCODE=0
	s EDRowId=""
	f  s EDRowId=$o(^DHCPEED(EDRowId)) q:(EDRowId="")||(SQLCODE'=0)  d
	.&SQL(insert into sqluser.DHC_PE_EDLoc (EDL_ParRef,EDL_Loc_DR) values (:EDRowId,:LocID))
	q SQLCODE
}

// w ##class(web.DHCPE.Temp).ImportEXByLoc("152","52")

ClassMethod ImportEXByLoc(SourceLocID, TargetLocID)
{
	s SQLCODE=0
	TSTART
	s EDRowId=""
	f  s EDRowId=$o(^DHCPEED(0,"EDLOC",SourceLocID,EDRowId)) q:(EDRowId="")||(SQLCODE'=0)  d
	.s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
	.q:activeFlag'="Y"
	.&SQL(select * into :PLIST() from sqluser.DHC_PE_ExpertDiagnosis where ED_RowID=:EDRowId)
	.k PLIST(1)
	.&SQL(insert into sqluser.DHC_PE_ExpertDiagnosis values :PLIST())
	.q:SQLCODE'=0
	.s RowID=%ROWID
	.&SQL(insert into sqluser.DHC_PE_EDLoc (EDL_ParRef,EDL_Loc_DR) values (:RowID,:TargetLocID))
	.q:SQLCODE'=0
	.s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",RowID)="Y"
	.&SQL(insert into sqluser.DHC_PE_EDAlias (EDA_ED_DR,EDA_Text) select :RowID,EDA_Text from sqluser.DHC_PE_EDAlias where EDA_ED_DR=:EDRowId)
	.s:SQLCODE=100 SQLCODE=0
	TROLLBACK:SQLCODE'=0
	TCOMMIT:SQLCODE=0
	q SQLCODE
}

// d ##class(web.DHCPE.Temp).GlobalTest("""""")

ClassMethod GlobalTest(ValStr)
{
	n (ValStr)
	s GlobalStr="s temp=$O(^DHCPESetting("
	s EndStr="))"
	s Str=GlobalStr_ValStr_EndStr
	w "Str:"_Str,!
	x Str
	q:temp=""
	w "temp:"_temp,!
	w "ValStr:"_ValStr,!
	i ValStr="""""" d
	.w "aaaa",!
	.s ValStr1=""""_temp_""""
	e  d
	.w "bbb",!
	.s ValStr1=ValStr_","""_temp_""","""_""""
	w "ValStr1:"_ValStr1,!
	d ..GlobalTest(ValStr1)
}

ClassMethod TestCityStr(i)
{
	;w ##class(web.DHCPE.Temp).TestCityStr(1)
	s myrtn=""
	s CTProvinceDR=0
	f  s CTProvinceDR=$O(^CT("CIT",0,"ProvCode",CTProvinceDR)) q:CTProvinceDR=""  d
	.s Province=$P(^CT("PROV",CTProvinceDR),"^",2)
	.
	.i i<3 d
	..s Province=$P(Province,"-",i)
	..i myrtn="" d
	...s myrtn=Province
	..e  d
	...s myrtn=myrtn_"^"_Province
	.e  d
	..i myrtn="" d
	...s myrtn=" "
	..e  d
	...s myrtn=myrtn_"^"_""
	.s myCode=""
	.f  s myCode=$o(^CT("CIT",0,"ProvCode",CTProvinceDR, myCode))  q:(myCode="")  d
	..s myRowID=0
	..f  s myRowID=$o(^CT("CIT",0,"ProvCode",CTProvinceDR, myCode, myRowID))  q:(myRowID="")  d
	...;^CT("CIT",{CTCIT_RowId})
	...s myCode=$p(^CT("CIT",myRowID),"^",1)
	...s myDesc=$p(^CT("CIT",myRowID),"^",2)
	...s myDesc=$P(myDesc,"-",i)
	...i i>2 d ;取对应省份信息
	....s myDesc=Province
	....s myDesc=$P(myDesc,"-",i-2)
	...i myrtn="" d
	....s myrtn=myDesc
	...e  d
	....s myrtn=myrtn_"^"_myDesc
	s myrtn=$tr(myrtn," ")
	s ^wrz(i)=myrtn
	q myrtn
}

ClassMethod TestCity(i)
{
	;d ##class(web.DHCPE.Temp).TestCity()
	q ^wrz(i)
	s bb=""
	s Total=0
	s l=$L(^wrz(1),"^")
	f i=1:1:l d
	.s aa=$P(^wrz(3),"^",i)_$P(^wrz(1),"^",i)_"-"_$P(^wrz(4),"^",i)_$P(^wrz(2),"^",i)
	.s l=$L(aa)
	.s bb=bb_aa
	.s Total=Total+l
}

ClassMethod TestDiv()
{
	;d ##class(web.DHCPE.Temp).TestDiv()
	w "<HEAD>"
	w "<EXTHEALTH:EXT321></EXTHEALTH:EXT321>",!
	w "</HEAD>"
	w "<div id='Div'>",!
  	w "aaa"
	w "</div>",!
}

ClassMethod FindErrInv(ReportID)
{
	;d ##class(web.DHCPE.Temp).FindErrInv(2)
	s InvID=0
	f  s InvID=$O(^DHCPEINVPRT(0,"REPORT",ReportID,InvID)) q:InvID=""  d
	.s arrcp=$p(^DHCPEINVPRT(InvID),"^",4)
   .s paym="0"
   .f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d   
   ..s ss=^ARRCP(arrcp,"PAYM",paym)
   ..s pmdesc=""
   ..s paymode=$p(ss,"^",1)
	.s Amount=$P(^DHCPEINVPRT(InvID),"^",7)
	.s ReInvID=$P(^DHCPEINVPRT(InvID),"^",9)
	.i ReInvID'="" d
	..s Inv=ReInvID
	..s Flag=-1
	.e  d
	..s Inv=InvID
	..s Flag=1
	.s TarECID=0
	.s OneAmt=0
	.f  s TarECID=$O(^DHCPEDataEX("DHCPEInvice",Inv,TarECID)) q:TarECID=""  d
	..s TarAmount=TarECID*Flag
	..s OneAmt=OneAmt+TarAmount
	.i +OneAmt'=+Amount d
	..s Num=Amount-OneAmt
	..i Flag=1 d
	...s ^DHCPEDataEX("DHCPEInvice",Inv,TarECID)=^DHCPEDataEX("DHCPEInvice",Inv,TarECID)+Num
	...s ^DHCPEUserReportEx("CatFee",ReportID,TarECID,paymode,"Normal")=^DHCPEUserReportEx("CatFee",ReportID,TarECID,paymode,"Normal")+Num
	..e  d
	...s flag=0
	...s oldUser=$p($g(^DHCPEINVPRT(Inv)),"^",10)
	...s userID=$p($g(^DHCPEINVPRT(InvID)),"^",10)
	...i (oldUser'=userID)&&((paymode=4)||(paymode=15)) s flag=1
	...s oldReportID=$p($g(^DHCPEINVPRT(Inv)),"^",13)
	...i (oldReportID'=ReportID)&&((paymode=4)||(paymode=15)) s flag=1
	...i flag=0 d
	....s ^DHCPEUserReportEx("CatFee",ReportID,TarECID,paymode,"Refund")=^DHCPEUserReportEx("CatFee",ReportID,TarECID,paymode,"Refund")+Num
	...e  d
	....s ^DHCPEUserReportEx("CatFee",ReportID,TarECID,paymode,"Other")=^DHCPEUserReportEx("CatFee",ReportID,TarECID,paymode,"Other")+Num
	w "OVER"
}

ClassMethod FindErrItem(invid)
{
	;d ##class(web.DHCPE.Temp).FindErrItem(6)
	s j=1
	s c=$C(2)
	s CatJob=$j
	k ^DHCPECashierTemp("CatDesc",CatJob)
	s PBID=$p($g(^DHCPEINVPRT(invid)),"^",3)
	s preAuditIds=""
	s PAPBID=0
	f  s PAPBID=$o(^DHCPEPAPBR(0,"PBDR",PBID,PAPBID)) q:PAPBID=""  d
	.s PAID=$p(^DHCPEPAPBR(PAPBID),"^",1)
	.s preAuditIds=preAuditIds_","_PAID
	while(j<=$l(preAuditIds,",")){
		s preAuditId=$p(preAuditIds,",",j)
		s j=j+1
		continue:preAuditId=""
		;s auditAmount=auditAmount+$p($g(^DHCPEPreA(preAuditId)),"^",9)
		s preAdmId=0
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId=""))  d
		.s childsub=0
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub=""))  d
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",2)'=""	//判断是否是套餐中的项目
		..//q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
		..s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",1)
		..s arcitemDesc=$P(^ARCIM(+arcitmid,1,1),"^",2)
		..s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",14)
		..s PriceInfo=##class(web.DHCPE.PreItemList).GetOrderPrice(arcitmid,"",1)
		..i (+$P(PriceInfo,"^",1))=(+$P(PriceInfo,"^",2)) d
		...s relate=1
		..e  d
		...s relate=(+$P(PriceInfo,"^",2))/(+$P(PriceInfo,"^",1))
		..s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",12)
		..s FactAmount=+##class(web.DHCPE.Cashier).GetFactAmount("1",preAdmId_"||"_childsub,preAuditId)
		..q:FactAmount=0
		..s AmountTotal=0
		..s Flag=0
		..s FSub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub,0))
		..s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub,"FEE",FSub)),"^",2)
		..q:CurFact=0
		..s TarItem=0
		..f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
		...s StartDate=0
		...f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
		....s OLTID=0
		....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
		.....s EndDate=$p(^DHCOLT(OLTID),"^",5)
		.....q:(EndDate'="")&&(EndDate<CurDate)
		.....s qty=$p(^DHCOLT(OLTID),"^",3)
		.....s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"","","")   //得到当前计费项金额
		.....i (Amount'=0)&&(CurPrice'=0) d
		......s CurCatFee=(CurPrice/Amount)*CurFact*qty*relate
		.....e  d
		......s CurCatFee=CurFact
		.....s AmountTotal=AmountTotal+CurCatFee
		.....s OneInfo=##class(web.DHCPE.Cashier).GetTarOC(TarItem)
		.....s ECOneInfo=##class(web.DHCPE.Cashier).GetTarEC(TarItem)
		.....s ^DHCPECashierTemp("ECCatDesc",CatJob,$p(ECOneInfo,"^",1),$p(ECOneInfo,"^",2))=+$G(^DHCPECashierTemp("ECCatDesc",CatJob,$p(ECOneInfo,"^",1),$p(ECOneInfo,"^",2)))+CurCatFee
		.....s ^DHCPECashierTemp("ECCatDesc",CatJob,"AccFee",$p(ECOneInfo,"^",1),$p(ECOneInfo,"^",2))=+$G(^DHCPECashierTemp("ECCatDesc",CatJob,"AccFee",$p(ECOneInfo,"^",1),$p(ECOneInfo,"^",2)))+(CurPrice*qty)
		..w:+FactAmount'=+AmountTotal "Item:"_preAdmId_"||"_childsub_",ItemDesc:"_arcitemDesc_",Fee:"_FactAmount_",CFee:"_AmountTotal,!
	}
	w "OVER"
}

ClassMethod UpdateOneStatus(PAADM, UserID, LocID)
{
	;d ##class(web.DHCPE.Temp).Test(341128,1,424)
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s PreIADM=$P(^DHCPEIADM(IADM),"^",4)
	s Status=$P(^DHCPEIADM(IADM),"^",8)
	&SQL(update sqluser.DHC_PE_PreIADM set PIADM_Status=:Status where PIADM_RowID=:PreIADM)
	zn "DHC-DATA"
	Do presno3^aOET1(PAADM,UserID,LocID)
	zn "DHC-APP"
}

ClassMethod UpdateRegInfo(vDate As %String = "")
{
	;d ##class(web.DHCPE.Temp).UpdateRegInfo(3)
	i vDate="" s vDate=2
	s MinDate=+$H-vDate
	s Date=""
	f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date),-1) q:Date<MinDate  d
	.s Time=""
	.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:Time=""  d
	..s IADM=0
	..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:IADM=""  d
	...s IStatus=$P(^DHCPEIADM(IADM),"^",8)
	...s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	...s GADM=$P(^DHCPEIADM(IADM),"^",2)
	...s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	...s PStatus=$P(^DHCPEPreIADM(PIADM),"^",8)
	...s User=$P(^DHCPEPreIADM(PIADM),"^",21)
	...s Loc=$P(^DHCPEPreIADM(PIADM),"^",26)
	...i (IStatus'=PStatus)&&(IStatus="REGISTERED") d
	....;w "没登记:"_IADM,!
	....d ..UpdateOneStatus(PAADM, User, Loc)
	...s CRMGADM=$P(^DHCPEPreIADM(PIADM),"^",2)
	...s CRMGTeam=$P(^DHCPEPreIADM(PIADM),"^",3)
	...i (GADM="")&&(CRMGADM'="") d
	....s GADM=$O(^DHCPEGADM(0,"CRMGADM",CRMGADM,0))
	....s GTeam=""
	....i GADM'="" d
	.....s Team=""
	.....f  s Team=$O(^DHCPEGADM(GADM,"Team",Team)) q:(Team="")||(GTeam'="")  d
	......s CurCrmTeam=$P(^DHCPEGADM(GADM,"Team",Team),"^",2)
	......i CurCrmTeam=CRMGTeam d
	.......s GTeam=GADM_"||"_Team
	....;w "没团体:"_IADM_"团体:"_GADM_"分组:"_GTeam,!
	....&SQL(update sqluser.DHC_PE_IADM set IADM_GADM_DR=:GADM,IADM_GTeam_DR=:GTeam where IADM_RowID=:IADM)
	q "OVER"
}

/*
//验证收费分类金额和总金额是否一致

ClassMethod FeeInfoCheck(preAuditIds, totalFee)
{
	n (preAuditIds,totalFee)
	q:(preAuditIds="") 1
	s MAmount=0.03 ;允许的差额范围
	s Flag=0
	s j=1
	while(j<=$l(preAuditIds,",")){
		s preAuditId=$p(preAuditIds,",",j)
		s j=j+1
		continue:preAuditId=""
		s preAdmId=0
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId="")||(Flag=1))  d
		.s childsub=0
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub="")||(Flag=1))  d
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",2)'=""	//判断是否是套餐中的项目
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
		..s userID=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",11)
		..s date=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",12)
		..s time=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",13)
		..s orderQty=+$G(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",preAdmId_"||"_childsub))
		..i orderQty=0 s orderQty=1
		..s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",1)
		..s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",14)
		..//s PriceInfo=##class(web.DHCPE.PreItemList).GetOrderPrice(arcitmid,"",1)
		..//i (+$P(PriceInfo,"^",1))=(+$P(PriceInfo,"^",2)) d
		..//.s relate=1
		..//e  d
		..//.s relate=(+$P(PriceInfo,"^",2))/(+$P(PriceInfo,"^",1))
		..s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",12)
		..s GroupItemID=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",4)
		..i GroupItemID'="" d
		...s CurDate=$p($g(^DHCPEPreGADM(+GroupItemID,"Team",$p(GroupItemID,"||",2),"ORDITEM",$p(GroupItemID,"||",3))),"^",9)
		..s FactAmount=+..GetFactAmount("1",preAdmId_"||"_childsub)
		..//q:FactAmount=0
		..;s Flag=0
		..s OneFactAmount=0
		
		..s FSub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub,0))
		..s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub,"FEE",FSub)),"^",2)
		..//q:CurFact=0
		..s TarItem=0
		..f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
		...s StartDate=0
		...f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
		....s OLTID=0
		....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
		.....s EndDate=$p(^DHCOLT(OLTID),"^",5)
		.....q:(EndDate'="")&&(EndDate<CurDate)
		.....s qty=$p(^DHCOLT(OLTID),"^",3)
		.....s ADMFeeType=""
		.....//s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",preAdmId))
	    .....s ItemADMType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",preAdmId_"||"_childsub))
		.....s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ItemADMType,"")   //得到当前计费项金额
		.....i (Amount'=0)&&(CurPrice'=0) d
		......//i (Amount'=0) d
		......s CurCatFee=(CurPrice/Amount)*CurFact*qty*orderQty
		.....e  d
		......s CurCatFee=CurFact
		.....s OneFactAmount=OneFactAmount+CurCatFee
		.....s itmsub=+$O(^DHCPEOEITEMTemp(preAuditIds,"OEITEM",preAdmId_"||"_childsub,"TARITEM",""),-1)+1
		.....s ^DHCPEOEITEMTemp(preAuditIds,"OEITEM",preAdmId_"||"_childsub,"TARITEM",itmsub)=TarItem_"^"_$j((CurCatFee/(qty*orderQty)),3,2)_"^"_(qty*orderQty)_"^"_$j(CurCatFee,3,2)
		.....//w TarItem_"^"_(CurCatFee/(qty*orderQty))_"^"_(qty*orderQty)_"^"_CurCatFee,!
		.....s ^DHCPEOEITEMAccAccTemp(preAuditIds,"OEITEM",preAdmId_"||"_childsub,"TARITEM",itmsub)=TarItem_"^"_$p(CurPrice,"^")_"^"_(qty*orderQty)_"^"_($p(CurPrice,"^")*qty*orderQty)  //Yx
		..i $zabs(OneFactAmount-FactAmount)>MAmount s Flag=1
		..s OEORIROWID=""
		..s crmOrderID=$O(^DHCPECRMO(0,"CRMORI",preAdmId_"||"_childsub,0))
		..i crmOrderID'="" d
		...s OEORIROWID=$P(^DHCPECRMO(crmOrderID),"^",1)
		..s ^DHCPEOEITEMTemp(preAuditIds,"OEITEM",preAdmId_"||"_childsub)=OEORIROWID_"^"_$j((FactAmount/orderQty),3,2)_"^"_orderQty_"^"_$j(FactAmount,3,2)_"^"_arcitmid_"^"_userID_"^"_date_"^"_time
		q:Flag=1
		s preAdmId=0
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId)) q:((preAdmId="")||(Flag=1))  d
		.s childsub=0
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub)) q:((childsub="")||(Flag=1))  d
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		..s Amount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",7)
		..s CurDate=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",4)
		..s GroupEntID=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",2)
		..i GroupEntID'="" d
		...s CurDate=$P(^DHCPEPreGADM(+GroupEntID,"Team",$P(GroupEntID,"||",2),"ORDENT",$P(GroupEntID,"||",3)),"^",3)
		..s FactAmount=+..GetFactAmount("2",preAdmId_"||"_childsub)
		..s FSub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub,0))
		..s CurFact=+$p($G(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",FSub)),"^",2)
		..s userID=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",3)
		..s date=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",4)
		..s time=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",5)
		..s OneFactAmount=0
		..s ItemSub=0
		..f  s ItemSub=$o(^DHCPEPreIADM(0,"OrdEnt",preAdmId_"||"_childsub,preAdmId,ItemSub)) q:ItemSub=""  d
		...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",16)'=1
		...s arcitmid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",1)
		...s orderQty=+$G(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",preAdmId_"||"_ItemSub))
		...i orderQty=0 s orderQty=1
		...s ItemAmount=+$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",14)
		...q:ItemAmount=0
		...//s PriceInfo=##class(web.DHCPE.PreItemList).GetOrderPrice(arcitmid,"",1)
		...//i (+$P(PriceInfo,"^",1))=(+$P(PriceInfo,"^",2)) d
		...//.s relate=1
		...//e  d
		...//.s relate=(+$P(PriceInfo,"^",2))/(+$P(PriceInfo,"^",1))
		...s TarItem=0
		...f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
		....s StartDate=0
		....f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
		.....s OLTID=0
		.....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
		......s EndDate=$p(^DHCOLT(OLTID),"^",5)
		......q:(EndDate'="")&&(EndDate<CurDate)
		......s qty=$p(^DHCOLT(OLTID),"^",3)
		......s ADMFeeType=""
		......//s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",preAdmId))
		......s ItemADMType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",preAdmId_"||"_ItemSub))
		......s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ItemADMType,"")   //得到当前计费项金额
		......i Amount'=0 d
		.......i ItemAmount'=0 d
		........//s CurCatFee=(CurPrice/Amount)*qty*CurFact*relate
		........s CurCatFee=(CurPrice/Amount)*qty*CurFact*orderQty
		.......e  d
		........s CurCatFee=CurFact
		......e  d
		.......s CurCatFee=CurFact
		......s itmsub=+$O(^DHCPEOEITEMTemp(preAuditIds,"OEITEM",preAdmId_"||"_ItemSub,"TARITEM",""),-1)+1
		......s ^DHCPEOEITEMTemp(preAuditIds,"OEITEM",preAdmId_"||"_ItemSub,"TARITEM",itmsub)=TarItem_"^"_$j((CurCatFee/(qty*orderQty)),3,2)_"^"_(qty*orderQty)_"^"_$j(CurCatFee,3,2)
		......s ^DHCPEOEITEMAccAccTemp(preAuditIds,"OEITEM",preAdmId_"||"_ItemSub,"TARITEM",itmsub)=TarItem_"^"_$P(CurPrice,"^")_"^"_(qty*orderQty)_"^"_($p(CurPrice,"^")*qty*orderQty)  //yx
		...i Amount'=0 d
		....s FactAmount=(CurFact/Amount)*ItemAmount
		...e  d
		....s FactAmount=CurFact
		...s OneFactAmount=OneFactAmount+FactAmount
		...s OEORIROWID=""
		...s crmOrderID=$O(^DHCPECRMO(0,"CRMORI",preAdmId_"||"_ItemSub,0))
		...i crmOrderID'="" d
		....s OEORIROWID=$P(^DHCPECRMO(crmOrderID),"^",1)
		...s ^DHCPEOEITEMTemp(preAuditIds,"OEITEM",preAdmId_"||"_ItemSub)=OEORIROWID_"^"_$j((FactAmount/orderQty),3,2)_"^"_orderQty_"^"_$j(FactAmount,3,2)_"^"_arcitmid_"^"_userID_"^"_date_"^"_time
		..i $zabs(OneFactAmount-FactAmount)>MAmount s Flag=1
	}
	i Flag=1 d
	.k ^DHCPEOEITEMTemp(preAuditIds)
	.k ^DHCPEOEITEMAccAccTemp(preAuditIds)
	q Flag
}
*/
ClassMethod UpdateGInfo(vDate As %String = "")
{
	;d ##class(web.DHCPE.Temp).UpdateRegInfo(3)
	i vDate="" s vDate=2
	s MinDate=+$H-vDate
	s Date=""
	f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date),-1) q:Date<MinDate  d
	.s Time=""
	.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:Time=""  d
	..s IADM=0
	..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:IADM=""  d
	...s IStatus=$P(^DHCPEIADM(IADM),"^",8)
	...s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	...s GADM=$P(^DHCPEIADM(IADM),"^",2)
	...s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	...s PStatus=$P(^DHCPEPreIADM(PIADM),"^",8)
	...s User=$P(^DHCPEPreIADM(PIADM),"^",21)
	...s Loc=$P(^DHCPEPreIADM(PIADM),"^",26)
	...s CRMGADM=$P(^DHCPEPreIADM(PIADM),"^",2)
	...s CRMGTeam=$P(^DHCPEPreIADM(PIADM),"^",3)
	...q:CRMGADM=""
	...s NGADM=$O(^DHCPEGADM(0,"CRMGADM",CRMGADM,0))
	...q:NGADM=""
	...s NGTeam=""
	...s Team=""
	...f  s Team=$O(^DHCPEGADM(NGADM,"Team",Team)) q:(Team="")||(NGTeam'="")  d
	....s CurCrmTeam=$P(^DHCPEGADM(NGADM,"Team",Team),"^",2)
	....i CurCrmTeam=CRMGTeam d
	.....s NGTeam=NGADM_"||"_Team
	...&SQL(update sqluser.DHC_PE_IADM set IADM_GADM_DR=:NGADM,IADM_GTeam_DR=:NGTeam where IADM_RowID=:IADM)
}

Storage Default
{
<Data name="TempDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.TempD</DataLocation>
<DefaultData>TempDefaultData</DefaultData>
<IdLocation>^web.DHCP.TempD</IdLocation>
<IndexLocation>^web.DHCP.TempI</IndexLocation>
<StreamLocation>^web.DHCP.TempS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
