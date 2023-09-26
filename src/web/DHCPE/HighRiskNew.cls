Class web.DHCPE.HighRiskNew Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.HighRiskNew", "SearchHighRiskED")
Query SearchHighRiskED(LocID As %String = "") As %Query(ROWSPEC = "TEDID:%String,TEDDesc:%String,TEDDetail:%String")
{
}

ClassMethod SearchHighRiskEDExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s EDID=0
	f  s EDID=$o(^DHCPEED(EDID)) q:EDID=""  d
	.d GetOneInfoDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfoDetail
	s THighRisk=$P($G(^DHCPEED(EDID,"1")),"^",8)
	q:THighRisk'="Y"
	//s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ED",EDID)       
  	//q:LocFlag=1 
	//s Active=$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDID))
	//q:($g(Active)="N")
	/***多院区 start***/
	s LocShowDFlag=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(EDID,LocID)
    q:LocShowDFlag'="Y"
	s Active=$p($g(^DHCPEED(EDID,1)),"^",13)
    s:Active="" Active="Y"
    /***多院区 end***/
    q:Active="N"
	s EDDetail=$P($G(^DHCPEED(EDID,"Detail")),"^",1)
	s EDDesc=$P($G(^DHCPEED(EDID,"1")),"^",1)
	d FindBuildDetail
	q 	
FindBuildDetail      
	set Data=$lb(EDID,EDDesc,EDDetail)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchHighRiskEDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchHighRiskEDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchHighRiskEDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchHighRiskEDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 高危信息查询
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.HighRiskNew", "SearchHighRisk","2020-02-10","2020-02-11","",3520,"N")
Query SearchHighRisk(StartDate As %String = "", EndDate As %String = "", GroupID As %String = "", EDIDs As %String = "", ResultFlag As %String = "N", IfSolve As %String = "", VIPLevel As %String = "", Name As %String = "", ContractID As %String = "", CRMFlag As %String = "", HospID As %String = "", txtRegNo As %String = "") As %Query(ROWSPEC = "TEDID:%String,TPAADM:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TGroup:%String,TDepart:%String,TTel:%String,TEDDesc:%String,TEDResult:%String,TMessageDetail:%String,THadSend:%String,TSend:%String,TCheckDate:%String,TSendDate:%String,TSourceID:%String,TVIPLevel:%String,TVIPLevelID:%String,TEDDetail:%String,TCRMFlag:%String,TCrmFinishFlag:%String,TItem:%String,THHRDate:%String,THHUser:%String,TSendUser:%String,TAduitUser:%String")
{
}

ClassMethod SearchHighRiskExecute(ByRef qHandle As %Binary, StartDate, EndDate, GroupID, EDIDs, ResultFlag As %String = "N", IfSolve As %String = "", VIPLevel As %String = "", Name As %String = "", ContractID As %String = "", CRMFlag As %String = "", HospID As %String = "", txtRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i (StartDate="")&&(EndDate="")&&(GroupID="")&&(Name="")&&(ContractID="")&&(txtRegNo="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ^TMP("DHCPE","SearchHighRisk")=$lb(StartDate,EndDate,GroupID,EDIDs,ResultFlag,IfSolve,VIPLevel,Name,ContractID,CRMFlag,HospID,txtRegNo)
	S Name=$$ALPHAUP^SSUTIL4(Name)
	s job=$j
	k ^DHCPEHighRiskOrder(job)
	k ^TempDHCPEExportRecord(job)
	s User=%session.Get("LOGON.USERID")
	s ExportName="DHCPEHighRisk"
	k ^TempDHCPEExportCommon(User,ExportName)
	
	i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	i StartDate="" s StartDate=1
	i EndDate="" s EndDate=+$H
	s Include=1
	i Name'=""
	{
		s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",Name),-1)
		f  s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",PatNameIndex)) q:(PatNameIndex="")||(PatNameIndex'[Name)  d
		.s PIBIDR=0
		.f  s PIBIDR=$o(^DHCPEPreIBI(0,"Name",PatNameIndex,PIBIDR)) q:PIBIDR=""  d
		..s id=0
		..f  s id=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,id)) q:id=""  d
		...s IADM=$O(^DHCPEIADM(0,"CRMADM",id,0))
		...q:IADM=""
		...d GetHighRiskInfo
	
	}
	elseif txtRegNo'=""
	{
		s PIBIDR=0
		f  s PIBIDR=$o(^DHCPEPreIBI(0,"PAPMINo",txtRegNo,PIBIDR)) q:PIBIDR=""  d
		.s id=0
		.f  s id=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,id)) q:id=""  d
		..s IADM=$O(^DHCPEIADM(0,"CRMADM",id,0))
		..q:IADM=""
		..d GetHighRiskInfo
	
	}
	elseif +GroupID'="0"
	{
		s GTeamID=""
		f  s GTeamID=$O(^DHCPEIADM(0,"GADM",GroupID,GTeamID)) q:GTeamID=""  d
		.s IADM=""
		.f  s IADM=$O(^DHCPEIADM(0,"GADM",GroupID,GTeamID,IADM)) q:IADM=""  d
		..d GetHighRiskInfo
	}
	elseif ContractID'=""
	{
		s CurPreGroupID=0
		f  s CurPreGroupID=$O(^DHCPEPreGADM(0,"Contract",ContractID,CurPreGroupID)) q:CurPreGroupID=""  d
		.s CurGroupID=$O(^DHCPEGADM(0,"CRMGADM",CurPreGroupID,0))
		.s GTeamID=""
		.f  s GTeamID=$O(^DHCPEIADM(0,"GADM",CurGroupID,GTeamID)) q:GTeamID=""  d
		..s IADM=""
		..f  s IADM=$O(^DHCPEIADM(0,"GADM",CurGroupID,GTeamID,IADM)) q:IADM=""  d
		...d GetHighRiskInfo
	}
	else{
		s Date=StartDate-1
		f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>EndDate)  d
		.s Time=""
		.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
		..s IADM=""
		..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:(IADM="")  d
		...d GetHighRiskInfo
		
	}
	s GADM="",Order=1
	f  s GADM=$o(^DHCPEHighRiskOrder(job,GADM)) q:(GADM="")  d
	.s VIP=""
	.f  s VIP=$o(^DHCPEHighRiskOrder(job,GADM,VIP)) q:(VIP="")  d
	..s No=0
	..f  s No=$o(^DHCPEHighRiskOrder(job,GADM,VIP,No)) q:(No="")  d
	...s Data=$g(^DHCPEHighRiskOrder(job,GADM,VIP,No))
	...s Order=Order+1
	...s PAADM=$lg(Data,2)
	...i $lg(Data,7)'="" s PatType=$lg(Data,7)
	...e  s PatType=$lg(Data,18)
	...i $D(^TempDHCPEExportRecord(job,PAADM)) d
	....s OldOrder=$G(^TempDHCPEExportRecord(job,PAADM))
	....s $P(^TempDHCPEExportCommon(User,ExportName,OldOrder),"^",8)=$P(^TempDHCPEExportCommon(User,ExportName,OldOrder),"^",8)_";"_$lg(Data,11)
	....s $P(^TempDHCPEExportCommon(User,ExportName,OldOrder),"^",9)=$P(^TempDHCPEExportCommon(User,ExportName,OldOrder),"^",9)_";"_$lg(Data,19)
	
	...e  d
	....s ^TempDHCPEExportRecord(job,PAADM)=Order
	....s ^TempDHCPEExportCommon(User,ExportName,Order)=$lg(Data,4)_"^"_$lg(Data,5)_"^"_$lg(Data,6)_"^"_$lg(Data,3)_"^"_$lg(Data,7)_"/"_$lg(Data,18)_"^"_$lg(Data,8)_"^"_$lg(Data,9)_"^"_$lg(Data,11)_"^"_$lg(Data,20)_"^"_$lg(Data,13)
 	...Set ^CacheTemp(repid,Order)=Data
 	
 	k ^DHCPEHighRiskOrder(job)
	k ^TempDHCPEExportRecord(job)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetHighRiskInfo
	 s TCRMFlag="",TCrmFinishFlag=""
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM)
  	q:LocFlag=1 
  	s Status=$P($g(^DHCPEIADM(IADM)),"^",8)
  	q:Status'="ARRIVED"
  	s VIPInfo=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM", IADM)
  	q:(VIPLevel'="")&&(VIPLevel'=+VIPInfo)
  	s TVIPLevel=$P(VIPInfo,"^",2)
  	s VIP=+VIPInfo
  	
  	s:(VIP="") VIP=0
  	s TPAADM=$P($g(^DHCPEIADM(IADM)),"^",1)
  	
  	s AduitUser=""
  	s gSSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(TPAADM)
  	i gSSID'="" s AduitUser=$p($g(^DHCPEGS(gSSID,1)),"^",5)
	i AduitUser'="" s AduitUser=$p($g(^SSU("SSUSR",AduitUser)),"^",2)

  	s TGroup=$P($g(^DHCPEIADM(IADM)),"^",2)
  	q:("0"'=+GroupID)&(GroupID'=TGroup) 
    q:("ALLI"=GroupID)&(""'=TGroup)
    q:("ALLG"=GroupID)&(""=TGroup)
  	
  	s GADM=TGroup
  	
  	s:(GADM="") GADM=0
  	i TGroup'="" d
  	.s GBI=$P($g(^DHCPEGADM(TGroup)),"^",1)
  	.i GBI'="" s TGroup=$P($g(^DHCPEGBI(GBI)),"^",2)
  	s TDepart=##class(web.DHCPE.PreCommon).GetPosition("IADM",IADM)
  	s TCheckDate=$P($g(^DHCPEIADM(IADM)),"^",5)
  	s:TCheckDate'="" TCheckDate=##class(websys.Conversions).DateLogicalToHtml(TCheckDate)
  	s PaPatID=$P($g(^PAADM(TPAADM)),"^",1)
  	s BaseInfo=##class(web.DHCPE.DocPatientFind).GetBaseInfo(PaPatID,HospID)
  	
	s TRegNo=$P(BaseInfo,"^",1)
	s TName=$P(BaseInfo,"^",2)
	s TSex=$P(BaseInfo,"^",8)
	s TAge=$P(BaseInfo,"^",6)
	s TTel=$P(BaseInfo,"^",5)
	s EDIDLength=$L(EDIDs,"^")
	f i=1:1:EDIDLength  d
	.s TEDID=$P(EDIDs,"^",i)
	.q:TEDID=""
	.s TEDDesc=$P($G(^DHCPEED(TEDID,"1")),"^",1)
	.s TEDDetail=$P($G(^DHCPEED(TEDID,"Detail")),"^",1)
	.s TEDDetail=##class(web.DHCPE.Public.Setting).Replace(TEDDetail," ","")
	.s Flag=..AdmIsHighRisk(TPAADM,TEDID)
	.q:Flag=0
	.;s TEDResult=##class(web.DHCPE.ReportGetInfor).GetAdviceResult(TEDID,TPAADM)
	.s TEDResult=..GetHighRiskResult(TEDID,TPAADM)
	.s TEDResult=##class(web.DHCPE.Public.Setting).Replace(TEDResult,$C(13),"")
	.s TEDResult=##class(web.DHCPE.Public.Setting).Replace(TEDResult," ","")
	.;s TEDResult=TEDID_"^"_TPAADM
	.s TSendDate=""
	.s TSend="0"
	.s THadSend="0"
	.s TMessageDetail=""
	.;i $D(^User.DHCPENewSendMessageI("TypeSourceIndex","RC",TPAADM_","_TEDID)) d
	.i $D(^User.DHCPEHighRiskResultD("Ex",TPAADM_","_TEDID,"RC")) d
	..s THadSend="1"
	..s MessageID="" ;$O(^User.DHCPENewSendMessageI("TypeSourceIndex","RC",TPAADM_","_TEDID,""))
	..s TMessageDetail="" ;$LG(^User.DHCPENewSendMessageD(MessageID),2)
	..s TSendDate=$P($G(^User.DHCPEHighRiskResultD("Ex",TPAADM_","_TEDID,"RC")),",",1) //$LG(^User.DHCPENewSendMessageD(MessageID),3)
	..s:TSendDate'="" TSendDate=##class(websys.Conversions).DateLogicalToHtml(TSendDate)
	..s TSendUser=$P($G(^User.DHCPEHighRiskResultD("Ex",TPAADM_","_TEDID,"RC")),",",3) 
	..i TSendUser'="" s TSendUser=$p($g(^SSU("SSUSR",TSendUser)),"^",2)

	.s TMessageDetail=""
	.;i $D(^User.DHCPENewSendMessageI("TypeSourceIndex","TRC",TPAADM_","_TEDID)) d
	.i $D(^User.DHCPEHighRiskResultD("Ex",TPAADM_","_TEDID,"TRC")) d
	..s:THadSend=1 THadSend="3"
	..s:THadSend=0 THadSend="2"
	..s MessageID="" ;$O(^User.DHCPENewSendMessageI("TypeSourceIndex","TRC",TPAADM_","_TEDID,""))
	..s TMessageDetail="" ;$LG(^User.DHCPENewSendMessageD(MessageID),2)
	..s TSendDate=$P($G(^User.DHCPEHighRiskResultD("Ex",TPAADM_","_TEDID,"TRC")),",",1) //$LG(^User.DHCPENewSendMessageD(MessageID),3)
	..s:TSendDate'="" TSendDate=##class(websys.Conversions).DateLogicalToHtml(TSendDate)
	..s TSendUser=$P($G(^User.DHCPEHighRiskResultD("Ex",TPAADM_","_TEDID,"TRC")),",",3) 
	..i TSendUser'="" s TSendUser=$p($g(^SSU("SSUSR",TSendUser)),"^",2)

	.s:THadSend="0" TSend="1"
	.s:THadSend="1" TSend="0"
	.s:THadSend="2" TSend="0"
	.s:THadSend="3" TSend="0"
	.s SourceID=""
	.q:(TSend="0")&&(IfSolve="2")
	.q:(TSend="1")&&(IfSolve="1")
	.d FindHighRiskBuild
	i ResultFlag="Y" d
	.q:Include=0
	.s TEDDesc=""
	.s SourceID=0
	.f  s SourceID=$O(^User.DHCPEHighRiskResultI("PAAdmIndex",TPAADM,SourceID)) q:SourceID=""  d
	..s obj=##class(User.DHCPEHighRiskResult).%OpenId(SourceID)
	..d ResultHighRisk
	
	q
ResultHighRisk
	
	s Item=obj.HRROEOrdItemDR.OEORIItmMastDR.ARCIMDesc
	s Stream=obj.HRREDDetail
	s len=Stream.SizeGet()
    d Stream.Rewind()
	s TEDResult = Stream.Read(len)
	s TCRMFlag=""
	s TCRMFlag=obj.HRRCRMFlag
	q:(CRMFlag="Y")&&(CRMFlag'=TCRMFlag)
	s THHRDate=obj.HRRDate
	s:THHRDate'="" THHRDate=##class(websys.Conversions).DateLogicalToHtml(THHRDate)
	s THHRTime=obj.HRRTime
	s:THHRTime'="" THHRTime=$zt(THHRTime)
	i THHRDate'="" s THHRDate=THHRDate_" "_THHRTime
	s THHUser=obj.HRRUserDR.SSUSRName

	s TSendDate=""
	s THadSend="0"
	s TSend="1"
	s TMessageDetail=""
	s TEDDetail=""
	;i $D(^User.DHCPENewSendMessageI("TypeSourceIndex","HR",SourceID)) d
	i $D(^User.DHCPEHighRiskResultD("Ex",SourceID,"HR")) d
	.s THadSend="1"
	.;s MessageID="" //$O(^User.DHCPENewSendMessageI("TypeSourceIndex","HR",SourceID,""))
	.s MessageID=$O(^User.DHCPENewSendMessageI("TypeSourceIndex","HR",SourceID,""))
	.i MessageID'="" d
	..;s TMessageDetail="" //$LG(^User.DHCPENewSendMessageD(MessageID),2)
	..s TMessageDetail=$LG(^User.DHCPENewSendMessageD(MessageID),2)
	..s TSendDate=$P($G(^User.DHCPEHighRiskResultD("Ex",SourceID,"HR")),",",1)
	..s TSendDate=$P($G(^User.DHCPEHighRiskResultD("Ex",SourceID,"HR")),",",1)
	..s:TSendDate'="" TSendDate=##class(websys.Conversions).DateLogicalToHtml(TSendDate)
	i $D(^User.DHCPEHighRiskResultD("Ex",SourceID,"THR")) d
	.;i $D(^User.DHCPENewSendMessageI("TypeSourceIndex","THR",SourceID)) d
	.s:THadSend=1 THadSend="3"
	.s:THadSend=0 THadSend="2"
	.;s MessageID="" ;$O(^User.DHCPENewSendMessageI("TypeSourceIndex","THR",SourceID,""))
	.;s TMessageDetail="" ;$LG(^User.DHCPENewSendMessageD(MessageID),2)
	.;s TSendDate=$P($G(^User.DHCPENewSendMessageI("TypeSourceIndex","THR",SourceID)),",",1)
	.s MessageID=$O(^User.DHCPENewSendMessageI("TypeSourceIndex","THR",SourceID,""))
	.i MessageID'="" d
	..s TMessageDetail=$LG(^User.DHCPENewSendMessageD(MessageID),2)
	..s TSendDate=$P($G(^User.DHCPEHighRiskResultD("Ex",SourceID,"THR")),",",1)
	..s:TSendDate'="" TSendDate=##class(websys.Conversions).DateLogicalToHtml(TSendDate)

	s:THadSend="0" TSend="1"
	s:THadSend="1" TSend="0"
	s:THadSend="2" TSend="0"
	s:THadSend="3" TSend="0"
	q:(TSend="0")&&(IfSolve="2")
	q:(TSend="1")&&(IfSolve="1")
	d FindHighRiskBuild
	
	q 	
FindHighRiskBuild
	i TMessageDetail="" d
	.s TMessageDetail="尊敬的"_TName_"您好:"
	.s:TEDResult'="" TMessageDetail=TMessageDetail_"您本次体检存在如下危险数据,"_TEDResult_"."
	.s:TEDDetail'="" TMessageDetail=TMessageDetail_"建议您,"_TEDDetail   
	s:THadSend=1 THadSend="短信"
	s:THadSend=2 THadSend="电话"
	s:THadSend=3 THadSend="短信+电话"
	s:THadSend=0 THadSend=""
	s TCrmFinishFlag=""
	s TCrmFinishFlag=..GetCrmFinishFlag(SourceID)
    s TEDDetail=TEDDesc_":"_TEDDetail
	set Data=$lb(TEDID,TPAADM,TRegNo,TName,TSex,TAge,TGroup,TDepart,TTel,TEDDesc,TEDResult,TMessageDetail,THadSend,TSend,TCheckDate,TSendDate,SourceID,TVIPLevel,+VIPInfo,TEDDetail,TCRMFlag,TCrmFinishFlag,Item,THHRDate,THHUser,TSendUser,AduitUser)
 	s ^DHCPEHighRiskOrder(job,GADM,VIP,ind)=Data
 	;s ^TempDHCPEExportCommon(User,ExportName,ind)=TName_"^"_TSex_"^"_TAge_"^"_TRegNo_"^"_TGroup_"^"_TDepart_"^"_TTel_"^"_TEDResult_"^"_""_"^"_THadSend
 	Set ind=ind+1
 	
 	q
}

ClassMethod SearchHighRiskFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchHighRiskExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchHighRiskClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchHighRiskExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AdmIsHighRisk(EpisodeID As %String, HighRiskID) As %String
{
	;w ##class(web.DHCPE.HighRiskNew).AdmIsHighRisk("3746498","3549")
	q:$g(EpisodeID)="" ""
	s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	s sexStr=$P(ageSexStr,"^",2)
	s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",HighRiskID,0))
	q:ExpressID="" 0  //没有高危条件退出
	s Express=""
	s ExpressID=0
	f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",HighRiskID,ExpressID)) q:ExpressID=""  d
	.s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
	.s Express=Express_obj.EPreBracket
	.s ItemID=obj.EItemDRGetObjectId()
	.s ItemID=##class(web.DHCPE.ResultEdit).GetUseItemID(EpisodeID,ItemID,HighRiskID)
	.i ItemID="" s ItemID="a||b"
	.s ItemType=obj.EItemDR.ODType
	.i $D(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) d  ;;逐个判断此细项是否满足
	..s Reference=obj.EReference
	..i Reference="" s Reference=obj.EODStandardDR.ODSTextVal
	..s Operator=obj.EOperator
	..s IsResult=0
	..s RLTID=0
	..f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")||(IsResult=1)  d
 	...s Result=$P(^DHCPERLT(RLTID),"^",4)
 	...s EDID=$P(^DHCPERLT(RLTID),"^",9)
 	
 	...i (ItemType="S")||(ItemType="T") d
 	....s Result=""""_Result_""""
 	....s Reference=""""_Reference_""""
 	
 	...s OneExpress=Result_Operator_Reference
 	...s IsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
	...;w:IsResult=1 Result_"^"_ItemID,!
	.e  d  ;;没有结果设置为0
	..s IsResult=0
	.s ExpressSex=obj.ESex
	.;性别不符设置为0
	.s:(ExpressSex'="N")&&(ExpressSex'="")&&(ExpressSex'=sexStr) IsResult=0
	.s Express=Express_IsResult_obj.EAfterBracket_obj.ERelation
	s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
	q rStr
}

ClassMethod SaveHighRisk(ID, Str)
{
	//DHC_PE_HighRiskResult
	s Date=+$H
	s Time=$P($H,",",2)
	s UserID=%session.Get("LOGON.USERID")
	if ID="" d
	.s obj=##class(User.DHCPEHighRiskResult).%New()
	.d obj.HRRPAAdmSetObjectId($P(Str,"^",1))
	.d obj.HRROEOrdItemDRSetObjectId($P(Str,"^",2))
	e  d
	.s obj=##class(User.DHCPEHighRiskResult).%OpenId(ID)
	d obj.HRREDDetail.Write($P(Str,"^",3))
	s obj.HRRDate=Date
	s obj.HRRTime=Time
	s obj.HRRActive="Y"
	d obj.HRRUserDRSetObjectId(UserID)
	s obj.HRRCRMFlag=$P(Str,"^",4)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.HighRiskNew", "HighRiskByPAADM",3577459)

Query HighRiskByPAADM(PAADM As %String = "", OrderItemID As %String = "") As %Query(ROWSPEC = "TID:%String,TItem:%String,TDetail:%String,TSendFlag:%String,TOrderItemID:%String,TSendDate:%String,TCRMFlag:%String,Tcontent:%String")
{
}

ClassMethod HighRiskByPAADMExecute(ByRef qHandle As %Binary, PAADM As %String = "", OrderItemID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	i (PAADM="")&&(OrderItemID="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s SourceID=0
	f  s SourceID=$O(^User.DHCPEHighRiskResultI("PAAdmIndex",PAADM,SourceID)) q:SourceID=""  d
	.s obj=##class(User.DHCPEHighRiskResult).%OpenId(SourceID)
	.s TOrderItemID=obj.HRROEOrdItemDRGetObjectId()
	.s THRRCRMFlag=obj.HRRCRMFlag
	.s Item=obj.HRROEOrdItemDR.OEORIItmMastDR.ARCIMDesc
	.s Stream=obj.HRREDDetail
	.s len=Stream.SizeGet()
    .d Stream.Rewind()
	.s Detail = Stream.Read(len)
	.s SendFlag=0
	.s TSendDate="",content=""
	.s MessageID=$O(^User.DHCPENewSendMessageI("TypeSourceIndex","HR",SourceID,""))
	.i MessageID'="" d
	..s SendFlag="1"
	..;s TSendDate=$LG(^User.DHCPENewSendMessageD(MessageID),10)
	..s TSendDate=$LG(^User.DHCPENewSendMessageD(MessageID),6)
	..s:TSendDate'="" TSendDate=##class(websys.Conversions).DateLogicalToHtml(TSendDate)
	..s:Detail="" Detail=$LG(^User.DHCPENewSendMessageD(MessageID),2)
	..s content=$LG(^User.DHCPENewSendMessageD(MessageID),2)
	.;s:$D(^User.DHCPENewSendMessageI("TypeSourceIndex","HR",SourceID)) SendFlag=1
	.I SendFlag="0" S SendFlag="未发送"
	.I SendFlag="1" S SendFlag="已发送"
	.d HighRiskByPAADM
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 	
HighRiskByPAADM
	set Data=$lb(SourceID,Item,Detail,SendFlag,TOrderItemID,TSendDate,THRRCRMFlag,content)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod HighRiskByPAADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HighRiskByPAADMExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod HighRiskByPAADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HighRiskByPAADMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutIfSolveToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='IfSolve' id='IfSolve' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>  </option>",!
	s selected=""
	s:DefaultValue=1 selected="selected"
	w "<option value='"_"1"_"' "_selected_">"_"已处理"_"</option>",!
	s selected=""
	s:DefaultValue=2 selected="selected"
	w "<option value='"_"2"_"' "_selected_">"_"未处理"_"</option>",!	
	w "</select>",!
	Quit $$$OK
}

ClassMethod SaveOtherRecord(OtherID, UserID)
{
	//ID^Type$ID2^Type2
	s Length=$L(OtherID,"$")
	f i=1:1:Length d
	.s OneInfo=$P(OtherID,"$",i)
	.s ID=$P(OneInfo,"^",1)
	.q:ID=""
	.s Type=$P(OneInfo,"^",2)
	.s ^User.DHCPEHighRiskResultD("Ex",ID,Type)=$H_","_UserID
	q ""
}

ClassMethod GetHighRiskResult(EDRowId, EpisodeID)
{
	;3549^4073151
	;w ##class(web.DHCPE.HighRiskNew).GetHighRiskResult(3549,4073151)
	s ret=""
	s Job=$J
	k ^TempDHCPE(Job,"EDRelate",EDRowId)
	s curLoc=$P($G(^PAADM(EpisodeID)),"^",4)
	//s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	//s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",curLoc))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",curLoc))

	s myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	s myAge=$p(myStr,"^",1)
	s mySex=$p(myStr,"^",2)
	s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,0))
	i ExpressID'=""  d
	.s Express=""
	.s ExpressID=0
	.f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,ExpressID)) q:ExpressID=""  d
	..s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
	..s ItemID=obj.EItemDRGetObjectId()
	..s ItemID=##class(web.DHCPE.ResultEdit).GetUseItemID(EpisodeID,ItemID,EDRowId)
	..q:ItemID=""
	..;q:$D(^TempDHCPE(Job,"EDRelate",EDRowId,ItemID))
	..s ItemDesc=obj.EItemDR.ODDesc
	..s Operator=obj.EOperator
	..s Reference=obj.EReference
	..i Reference="" s Reference=obj.EODStandardDR.ODSTextVal
	..s OneResult=""
	..i $D(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) d  ;;逐个判断此细项是否满足
	...;s ^TempDHCPE(Job,"EDRelate",EDRowId,ItemID)=""
	...s RLTID=0
	...f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")  d
 	....s NormalFlag=$P(^DHCPERLT(RLTID),"^",7)
 	....q:NormalFlag=1
 	....s ODID=$P(^DHCPERLT(RLTID),"^",3)
	....s ODType=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",2)
	....s Result=$P(^DHCPERLT(RLTID),"^",4)
	....i (ODType="S")||(ODType="T") d
 	.....s Result=""""_Result_""""
 	.....s Reference=""""_Reference_""""
	....s OneExpress=Result_Operator_Reference
	....b ;OneExpress
 	....s IsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
 	....q:IsResult=0
 	....s Unit=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Unit"))
 	....s Ranges=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Ranges"))
 	....s:Ranges'="" Ranges=Ranges_" "_Unit
 	....s:Ranges'="" Result=Result_" "_Unit_"("_Ranges_")"
 	....i OneResult="" d
 	.....s OneResult=Result
 	....e  d
 	.....s OneResult=OneResult_";"_Result
 	....;得到检验异常箭头
 	....i LabStation=+ODID d
 	.....s NormalResult=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Ranges"))
 	.....s ODUnit=$G(^DHCPEDataEx("DHCPEResult",RLTID,"Unit"))
 	....e  d
 	.....s NormalResult=##class(web.DHCPE.ResultEdit).GetNormal(ODID,mySex,myAge)
 	.....s ODUnit=$P($g(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",4)
	....s TSInfo="1"
	....s:(ODType="N")||(ODType="C") TSInfo=##class(web.DHCPE.TransResult).GetLabResultArrow(NormalResult,OneResult)
	....s:TSInfo="2" TSInfo="↑"
	....s:TSInfo="0" TSInfo="↓"
	....s:TSInfo'="1" OneResult=OneResult_" "_TSInfo
 	...s:OneResult'="" OneResult=ItemDesc_"："_OneResult
 	..q:OneResult=""
 	..i ret=""  d
 	...s ret=$C(13)_"               "_OneResult
 	..e  d
 	...s ret=ret_$C(13)_"               "_OneResult
 	k ^TempDHCPE(Job,"EDRelate",EDRowId)
 	q ret
}

ClassMethod SaveCRMInfo(ID, CRMInfo, UserID)
{
	s Sort=$I(^DHCPEDataEx("CRMInfo",ID))
	s ^DHCPEDataEx("CRMInfo",ID,Sort)=CRMInfo_"^"_UserID_"^"_$H
	q 0
}

ClassMethod GetCrmFinishFlag(ID)
{
	q:ID="" 0
	q:$D(^DHCPEDataEx("CrmFinish",ID)) 1
	q 0
}

ClassMethod CrmFinish(ID, UserID)
{
	i $D(^DHCPEDataEx("CrmFinish",ID)) d
	.k ^DHCPEDataEx("CrmFinish",ID)
	e  d
	.s ^DHCPEDataEx("CrmFinish",ID)=UserID_"^"_$H
	q 0
}

Query FindCRMInfo(SourceID As %Library.String = "") As %Query(ROWSPEC = "TID:%String,TSort:%String,TDate:%String,TTime:%String,TCRMInfo:%String,TUser:%String")
{
}

ClassMethod FindCRMInfoExecute(ByRef qHandle As %Binary, SourceID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (""=SourceID) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s TID=SourceID
 	s TSort=""
 	f  s TSort=$O(^DHCPEDataEx("CRMInfo",SourceID,TSort)) q:TSort=""  d
 	.s val=$G(^DHCPEDataEx("CRMInfo",SourceID,TSort))
 	.s TDate=$p($P(val,"^",3),",",1)
 	.s:TDate'="" TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
 	.s TTime=$p($P(val,"^",3),",",2)
 	.s:TTime'="" TTime=$ZT(TTime)
 	.s TCRMInfo=$P(val,"^",1)
 	.s TUser=$P(val,"^",2)
 	.s:TUser'="" TUser=$P(^SSU("SSUSR",TUser),"^",2)
	.d Build	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build      
	set Data=$lb(TID,TSort,TDate,TTime,TCRMInfo,TUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCRMInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCRMInfoExecute ]
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

ClassMethod FindCRMInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCRMInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DeleteCRMInfo(SourceInfo)
{
	s SourceID=$P(SourceInfo,"^",1)
	s Sort=$P(SourceInfo,"^",2)
	k ^DHCPEDataEx("CRMInfo",SourceID,Sort)
	q 0
}

Storage Default
{
<Data name="HighRiskNewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.HighRiskNewD</DataLocation>
<DefaultData>HighRiskNewDefaultData</DefaultData>
<IdLocation>^web.DHCPE.HighRiskNewD</IdLocation>
<IndexLocation>^web.DHCPE.HighRiskNewI</IndexLocation>
<StreamLocation>^web.DHCPE.HighRiskNewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
