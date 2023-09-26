Class web.DHCPE.Report.QueryResult Extends %RegisteredObject
{

ClassMethod SetAdmInfo(Job, ArgValue, ArgValue2)
{
	s StartDate=$P(ArgValue,"^",1)
	s EndDate=$P(ArgValue,"^",2)
	s MinAge=$P(ArgValue,"^",3)
	s MaxAge=$P(ArgValue,"^",4)
	s Sex=$P(ArgValue,"^",5)
	s GroupID=$P(ArgValue,"^",6)
	s SetsID=$P(ArgValue,"^",7)
	s:SetsID'="" SetsID="$"_SetsID_"$"
	i ArgValue2="" d
	.s Arg2Length=0
	e  d
	.s Arg2Length=$L(ArgValue2,"^")
	
	i (GroupID'="")&&(GroupID'="ALLG")&&(GroupID'="ALLI") d
	.i StartDate="" d
	..s StartDate=1
	.e  d
	..s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	.i EndDate="" d
	..s EndDate=+$H
	.e  d
	..s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	.s GroupLength=$L(GroupID,"$")
	.f Groupi=1:1:GroupLength d
	..s OneGroupID=$P(GroupID,"$",Groupi)
	..s GTeamID=""
	..f  s GTeamID=$O(^DHCPEIADM(0,"GADM",OneGroupID,GTeamID)) q:(GTeamID="")  d
	...s IAdmRowId=0
	...f  s IAdmRowId=$O(^DHCPEIADM(0,"GADM",OneGroupID,GTeamID,IAdmRowId)) q:(IAdmRowId="")  d
	....d SetOneInfo
	e  d
	.s OneGroupID=GroupID
	.i StartDate="" d
	..s StartDate=1
	.e  d
	..s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	.i EndDate="" d
	..s EndDate=+$H
	.e  d
	..s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	.;w StartDate_"^"_EndDate
	.s AdmDate=StartDate-1
    .f  s AdmDate=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate)) Q:(""=AdmDate)||(AdmDate>EndDate)  d
	..s AdmTime=0
	..f  s AdmTime=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime)) Q:(""=AdmTime)  d
	...s IAdmRowId=0
	...f  s IAdmRowId=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime, IAdmRowId))  Q:(""=IAdmRowId)  d
	....s RAdmID=IAdmRowId
	....d SetOneInfo
	q
SetOneInfo
	;s RCount=RCount+1
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)
 	q:LocFlag=1
	s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	q:'("ARRIVED"=Status)
	s ReCheckFlag=##class(web.DHCPE.PreCommon).IsReCheck(IAdmRowId,"IADM")
	q:ReCheckFlag'=0
	s EpisodeID=$P($g(^DHCPEIADM(IAdmRowId)),"^",1)
	s PaPatID=$P(^PAADM(EpisodeID),"^",1)
	s tempSex=$P(^PAPER(PaPatID,"ALL"),"^",7)
	s tempAge=$P(^PAPER(PaPatID,"ALL"),"^",6)
	s CAdmDate=$P(^PAADM(EpisodeID),"^",6)
	s:tempAge'="" myAge=##class(web.DHCLCNUREXCUTE).CalAge(tempAge,CAdmDate)
	s myAge=$P(myAge,"Y",1)
	q:(Sex'="")&&(Sex'=tempSex)
	q:(MinAge'="")&&(MinAge>myAge)
	q:(MaxAge'="")&&(MaxAge<myAge)
	s CurGroupID=$P($g(^DHCPEIADM(IAdmRowId)),"^",2)
	q:(OneGroupID="ALLG")&&(CurGroupID="")
	q:(OneGroupID="ALLI")&&(CurGroupID'="")
	q:(+OneGroupID'=0)&&(OneGroupID'=CurGroupID)
	q:CAdmDate>EndDate
	q:CAdmDate<StartDate
	s PreIADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	q:(SetsID'="")&&(SetsID'[("$"_..GetPreSets(PreIADM)_"$"))
	s ^DHCPEQueryResultTempAdm(Job,IAdmRowId)=""
}

// w ##class(web.DHCPE.Report.QueryResult).SetResultRecord(0,"53$5918","21/09/2014^^^^^^","13")

ClassMethod SetResultRecord(StartAdmId As %String = "0", Job, ArgValue As %Library.String = "", ArgValue2 As %Library.String = "", LocID As %String = "")
{
	i StartAdmId=0{
		k ^DHCPEQueryResultTemp(Job)
		k ^DHCPEQueryResultTempAdm(Job)
		d ..SetAdmInfo(Job, ArgValue, ArgValue2)
		s RAdmID=$O(^DHCPEQueryResultTempAdm(Job,""))
		s:RAdmID'="" RAdmID=RAdmID-1
		q RAdmID
	}
	
	s StartDate=$P(ArgValue,"^",1)
	s EndDate=$P(ArgValue,"^",2)
	s MinAge=$P(ArgValue,"^",3)
	s MaxAge=$P(ArgValue,"^",4)
	s Sex=$P(ArgValue,"^",5)
	s GroupID=$P(ArgValue,"^",6)
	s SetsID=$P(ArgValue,"^",7)
	s:SetsID'="" SetsID="$"_SetsID_"$"
	i ArgValue2="" d
	.s Arg2Length=0
	e  d
	.s Arg2Length=$L(ArgValue2,"^")
	s RCount=0
	s RAdmID=""
	s IAdmRowId=StartAdmId
	f  s IAdmRowId=$O(^DHCPEQueryResultTempAdm(Job,IAdmRowId)) q:(IAdmRowId="")||(RCount>9)  d
	.s RCount=RCount+1
	.s RAdmID=IAdmRowId
	.d SetOneInfo
	
	b ;RCount RAdmID
	q:(RCount<10) ""
	q RAdmID
SetOneInfo
	s EpisodeID=$P($g(^DHCPEIADM(IAdmRowId)),"^",1)
	s PaPatID=$P(^PAADM(EpisodeID),"^",1)
	s tempSex=$P(^PAPER(PaPatID,"ALL"),"^",7)
	s tempAge=$P(^PAPER(PaPatID,"ALL"),"^",6)
	s CAdmDate=$P(^PAADM(EpisodeID),"^",6)
	s:tempAge'="" myAge=##class(web.DHCLCNUREXCUTE).CalAge(tempAge,CAdmDate)
	s myAge=$P(myAge,"Y",1)
	//体检总人数
	s Total=$I(^DHCPEQueryResultTemp(Job,"0","ALL"))
	s ^DHCPEQueryResultTemp(Job,"0","ALL","Detail",IAdmRowId)=""
	//各年龄段总人数
	s ageArea=##class(web.DHCPE.Report.PositiveRecordStatistic).GetAgeArea(30,80,10,myAge)
	s Total=$I(^DHCPEQueryResultTemp(Job,"0",ageArea))
	s ^DHCPEQueryResultTemp(Job,"0",ageArea,"Detail",IAdmRowId)=""
	//每个查询条件总人数
	f i=1:1:Arg2Length  d
	.s PID=$P(ArgValue2,"^",i)
	.d JudgeExpress
	q
JudgeExpress
	s sexStr="M"
	
	//s SetSex=$G(^DHCPESetting("DHCPE","DefPatientType"))
	s SetSex=$G(^DHCPESetting("DHCPE","DefPatientType",LocID))

	i tempSex=$P(SetSex,"^",4) s sexStr="F"
	s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","PR",PID,0))
	i ExpressID'=""  d
	.s Express=""
	.s QuitFlag=0
	.s ExpressID=0
	.f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","PR",PID,ExpressID)) q:(ExpressID="")||(QuitFlag=1)  d
	..s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
	..s Express=Express_obj.EPreBracket
	..s ItemID=obj.EItemDRGetObjectId()
	..s NoBloodFlag=""
	..;s NoBloodFlag=obj.ENoBloodFlag
	..s ItemID=..GetUseItemID(EpisodeID, ItemID,NoBloodFlag)
	..i ItemID="" s ItemID="a||b"
	..i $D(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) d  ;;逐个判断此细项是否满足
	...s ItemType=obj.EItemDR.ODType
	...s Reference=obj.EReference
	...s:Reference[("NULL") IsResult="1"
	...q:Reference[("NULL")
	...i Reference="" s Reference=obj.EODStandardDR.ODSTextVal
	...s Operator=obj.EOperator
	...s IsResult=0
	...s RLTID=0
	...f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")||(IsResult=1)  d
 	....s Result=$P(^DHCPERLT(RLTID),"^",4)
 	....s EDID=$P(^DHCPERLT(RLTID),"^",9)
 	....i (ItemType="S")||(ItemType="T") d
 	.....s Result=""""_Result_""""
 	.....s Reference=""""_Reference_""""
 	....s OneExpress=Result_Operator_Reference
 	....s IsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
	..e  d  ;;没有结果设置为0
	...;s Reference=obj.EReference
	...s IsResult=0
	..s ExpressSex=obj.ESex
	..;;性别不符设置为0
	..s:(ExpressSex'="N")&&(ExpressSex'=sexStr) IsResult=0
	..s Express=Express_IsResult_obj.EAfterBracket_obj.ERelation
	..s:obj.ERelation="" QuitFlag=1
	.s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
	.i rStr d
	..s Total=$I(^DHCPEQueryResultTemp(Job,PID,"ALL"))
	..s ^DHCPEQueryResultTemp(Job,PID,"ALL","Detail",IAdmRowId)=""
	..s Total=$I(^DHCPEQueryResultTemp(Job,PID,ageArea))
	..s ^DHCPEQueryResultTemp(Job,PID,ageArea,"Detail",IAdmRowId)=""
	e  d
	.s Total=$I(^DHCPEQueryResultTemp(Job,PID,"ALL"))
	.s ^DHCPEQueryResultTemp(Job,PID,"ALL","Detail",IAdmRowId)=""
	.s Total=$I(^DHCPEQueryResultTemp(Job,PID,ageArea))
	.s ^DHCPEQueryResultTemp(Job,PID,ageArea,"Detail",IAdmRowId)=""
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.PositiveRecordStatistic","QueryResult","","")
Query QueryResult(ArgValue As %Library.String = "", ArgValue2 As %Library.String = "", Job As %String = "") As %Query(ROWSPEC = "ItmMast:%String,ItmMastNum:%String,Age0Num:%String,Age1Num:%String,Age2Num:%String,Age3Num:%String,Age4Num:%String,Age5Num:%String,Age6Num:%String,Age7Num:%String,TID:%String")
{
}

ClassMethod QueryResultExecute(ByRef qHandle As %Binary, ArgValue As %Library.String = "", ArgValue2 As %Library.String = "", Job As %String = "") As %Status
{
 	s ind=1
 	//s Job=%session.Get("LOGON.USERID")
 	//k ^DHCPEQueryResultTemp(Job)
	Set repid=$I(^CacheTemp)
	//w Job
	
	s ID=""
	f  s ID=$O(^DHCPEQueryResultTemp(Job,ID)) q:ID=""  d
	.i ID="0" d
	..s PositiveName="体检总人数"
	.e  d
	..s PositiveName=$LG(^User.DHCPEPositiveRecordD(ID),3)
	.s PositiveNum=$G(^DHCPEQueryResultTemp(Job,ID,"ALL"))
	.s Age0Num=$G(^DHCPEQueryResultTemp(Job,ID,"18岁以下"))
	.s Age1Num=$G(^DHCPEQueryResultTemp(Job,ID,"18-29"))
	.s Age2Num=$G(^DHCPEQueryResultTemp(Job,ID,"30-39"))
	.s Age3Num=$G(^DHCPEQueryResultTemp(Job,ID,"40-49"))
	.s Age4Num=$G(^DHCPEQueryResultTemp(Job,ID,"50-59"))
	.s Age5Num=$G(^DHCPEQueryResultTemp(Job,ID,"60-69"))
	.s Age6Num=$G(^DHCPEQueryResultTemp(Job,ID,"70-79"))
	.s Age7Num=$G(^DHCPEQueryResultTemp(Job,ID,"80及以上"))
	.s Data=$LB(PositiveName,PositiveNum,Age0Num,Age1Num,Age2Num,Age3Num,Age4Num,Age5Num,Age6Num,Age7Num,ID)
	.d StatisticOut
	//k ^DHCPEQueryResultTemp(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
		
StatisticOut
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResultExecute ]
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

ClassMethod QueryResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResultExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutResultDetail(PID, Range, LocID As %String = "")
{
	//s Job=%session.Get("LOGON.USERID")
	
	s Job=%session.Get("LOGON.CTLOCID")_"$"_%session.Get("LOGON.USERID")
	k ^DHCPEOutResultDetailTemp(Job)
	k ^DHCPEOutResultItemTemp(Job)
	//s SetSex=$G(^DHCPESetting("DHCPE","DefPatientType"))
	s SetSex=$G(^DHCPESetting("DHCPE","DefPatientType",LocID))
	w "<Table border=1 width=100% id='ResultTable'>"
	s i=0
	s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","PR",PID,0))
	i ExpressID'=""  d
	.s ExpressID=0
	.f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","PR",PID,ExpressID)) q:(ExpressID="")  d
	..s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
	..s ItemID=obj.EItemDRGetObjectId()
	..s NoBloodFlag=""
	..;s NoBloodFlag=obj.ENoBloodFlag
	..q:ItemID=""
	..s i=i+1
	..//Job  StationSort  ItemSort  医嘱ID  DetailSort  = 细项个数 
	..s ^DHCPEOutResultDetailTemp(Job,0,0,0,i,ItemID)=NoBloodFlag
	//Job  StationSort  ItemSort  医嘱ID = 细项个数
	s ^DHCPEOutResultItemTemp(Job,0,0,0)=i
	
	s ArcimID=""
	f  s ArcimID=$O(^User.DHCPEPositiveRecordD(PID,"Item",ArcimID)) q:ArcimID=""  d
	.s STID=$o(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	.q:STID=""
	.s STSort=$P(^DHCPEST(STID),"^",4)
	.s ItemSort=$I(^DHCPEOutResultItemTemp(Job,STSort))
	.s i=0
	.s Sequence=""
	.f  s Sequence=$O(^DHCPEODR(0,"Sequence",ArcimID,Sequence)) q:Sequence=""  d
	..s RowId=""
	..f  s RowId=$O(^DHCPEODR(0,"Sequence",ArcimID,Sequence,RowId)) q:RowId=""  d
	...s ItemID=$P($g(^DHCPEODR(RowId)),"^",2)
	...s i=i+1
	...s SpecName=##class(web.DHCPE.PreItemList).GetDefaultSpecName(ArcimID, 1)
	...s NoBloodFlag="Y"
	...s:SpecName[("血") NoBloodFlag="N"
	...s ^DHCPEOutResultDetailTemp(Job,STSort,ItemSort,ArcimID,Sequence,ItemID)=NoBloodFlag	
	.q:i=0
	.s ^DHCPEOutResultItemTemp(Job,STSort,ItemSort,ArcimID)=i
	w "<TR align='center'><TD colspan=6>基本信息</TD>"
	s ColNum=$G(^DHCPEOutResultItemTemp(Job,0,0,0))
	w:ColNum>0 "<TD colspan="_ColNum_">设置条件</TD>"
	s STSort=0
	f  s STSort=$O(^DHCPEOutResultItemTemp(Job,STSort)) q:STSort=""  d
	.s ItemSort=""
	.f  s ItemSort=$O(^DHCPEOutResultItemTemp(Job,STSort,ItemSort)) q:ItemSort=""  d
	..s ArcimID=""
	..f  s ArcimID=$O(^DHCPEOutResultItemTemp(Job,STSort,ItemSort,ArcimID)) q:ArcimID=""  d
	...s ColNum=$G(^DHCPEOutResultItemTemp(Job,STSort,ItemSort,ArcimID))
	...s ArcimDesc=$P(^ARCIM(+ArcimID,1,1),"^",3)
	...w "<TD colspan="_ColNum_">"_ArcimDesc_"</TD>"
	
	
	
	w "</TR>"
	w "<TR><TD>登记号</TD><TD>姓名</TD><TD>性别</TD><TD>年龄</TD><TD>体检日期</TD><TD>电话</TD>"
	s STSort=""
	f  s STSort=$O(^DHCPEOutResultDetailTemp(Job,STSort)) q:STSort=""  d
	.s ItemSort=""
	.f  s ItemSort=$O(^DHCPEOutResultDetailTemp(Job,STSort,ItemSort)) q:ItemSort=""  d
	..s ArcimID=""
	..f  s ArcimID=$O(^DHCPEOutResultDetailTemp(Job,STSort,ItemSort,ArcimID)) q:ArcimID=""  d
	...s Sequence=""
	...f  s Sequence=$O(^DHCPEOutResultDetailTemp(Job,STSort,ItemSort,ArcimID,Sequence)) q:Sequence=""  d
	....s ItemID=""
	....f  s ItemID=$O(^DHCPEOutResultDetailTemp(Job,STSort,ItemSort,ArcimID,Sequence,ItemID)) q:ItemID=""  d
	.....s ODDesc=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2)),"^",1)
	.....w "<TD>"_ODDesc_"</TD>"
	w "</TR>"
	
	s AdmID=0
	f  s AdmID=$O(^DHCPEQueryResultTemp(Job,PID,Range,"Detail",AdmID)) q:AdmID=""  d
	.s EpisodeID=$P($g(^DHCPEIADM(AdmID)),"^",1)
	.s PaPatID=$P(^PAADM(EpisodeID),"^",1)
	.s PAPMINo=$P(^PAPER(PaPatID,"PAT",1),"^",1)
	.s AdmDate=$P(^PAADM(EpisodeID),"^",6)
	.s tempSex=$P(^PAPER(PaPatID,"ALL"),"^",7)
	.s sexStr="M"
	.i tempSex=$P(SetSex,"^",4) s sexStr="F"
	.s tempAge=$P(^PAPER(PaPatID,"ALL"),"^",6)
	.s Name=$P(^PAPER(PaPatID,"ALL"),"^",1)
	.s telH=$p(^PAPER(PaPatID,"PER",1),"^",11)
	.s:tempAge'="" myAge=##class(web.DHCLCNUREXCUTE).CalAge(tempAge,AdmDate)
	.s myAge=$P(myAge,"Y",1)
	.s mySex=$P(^CT("SEX",tempSex),"^",2)
	.s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	
	.s:telH="" telH="&nbsp;"
	.w "<TR><TD>"_PAPMINo_"</TD><TD>"_Name_"</TD><TD>"_mySex_"</TD><TD>"_myAge_"</TD><TD>"_AdmDate_"</TD><TD>"_telH_"</TD>"
	
	.s STSort=""
	.f  s STSort=$O(^DHCPEOutResultDetailTemp(Job,STSort)) q:STSort=""  d
	..s ItemSort=""
	..f  s ItemSort=$O(^DHCPEOutResultDetailTemp(Job,STSort,ItemSort)) q:ItemSort=""  d
	...s ArcimID=""
	...f  s ArcimID=$O(^DHCPEOutResultDetailTemp(Job,STSort,ItemSort,ArcimID)) q:ArcimID=""  d
	....s Sequence=""
	....f  s Sequence=$O(^DHCPEOutResultDetailTemp(Job,STSort,ItemSort,ArcimID,Sequence)) q:Sequence=""  d
	.....s ItemID=""
	.....f  s ItemID=$O(^DHCPEOutResultDetailTemp(Job,STSort,ItemSort,ArcimID,Sequence,ItemID)) q:ItemID=""  d
	......s NoBloodFlag=$G(^DHCPEOutResultDetailTemp(Job,STSort,ItemSort,ArcimID,Sequence,ItemID))
	......s UseItemID=..GetUseItemID(EpisodeID, ItemID,NoBloodFlag)
	......i UseItemID="" s UseItemID="a||b"
	......s Result="&nbsp;"
	......s RLTID=0
	......f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,UseItemID,RLTID)) q:(RLTID="")  d
 	.......s CurArcID=$P(^DHCPERLT(RLTID),"^",2)
	.......q:(CurArcID'=ArcimID)&&(ArcimID'=0)
 	.......s Result=$P(^DHCPERLT(RLTID),"^",4)
 	......w "<TD>"_Result_"</TD>"
	
	
	.w "</TR>"
	w "</Table>"
	k ^DHCPEOutResultDetailTemp(Job)
	k ^DHCPEOutResultItemTemp(Job)
}

ClassMethod GetUseItemID(PAADM, ItemID, NoBloodFlag)
{
	//q:$D(^DHCPERLT(0,"PAADM_OD",PAADM,ItemID)) ItemID
	s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	q:(+ItemID'=LabStation) ItemID
	s ret=""
	s ODDesc=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2)),"^",1)
	s ODDesc=$$ALPHAUP^SSUTIL4(ODDesc)
	s ODSub=0
	f  s ODSub=$O(^DHCPEST(0,"OD_Desc",ODDesc,LabStation,ODSub)) q:(ODSub="")||(ret'="")  d
	.s CurItemID=LabStation_"||"_ODSub
	.s RltID=0
	.f  s RltID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,CurItemID,RltID)) q:(RltID="")||(ret'="")  d
	..;只显示血的结果
	..s OEORIRowId=$P(^DHCPERLT(RltID),"^",9)
	..s SpecimenType=##class(web.DHCPE.BarPrint).GetSpecName(OEORIRowId)
	..q:(SpecimenType'[("血"))&&(NoBloodFlag="N")
	..q:(SpecimenType[("血"))&&(NoBloodFlag="Y")
	..s ret=CurItemID
	q ret
}

ClassMethod GetPreSets(PreIADM)
{
	s PreSetsID=""
	s SetsSub=0
	f  s SetsSub=$O(^DHCPEPreIADM(PreIADM,"ORDENT",SetsSub)) q:SetsSub=""  d
	.s Stat=$P(^DHCPEPreIADM(PreIADM,"ORDENT",SetsSub),"^",9)
	.q:Stat'="1"
	.s OneSetsID=$P(^DHCPEPreIADM(PreIADM,"ORDENT",SetsSub),"^",1)
	.i PreSetsID="" d
	..s PreSetsID=OneSetsID
	.e  d
	..s PreSetsID=PreSetsID_"$"_OneSetsID
	q PreSetsID
}

}
