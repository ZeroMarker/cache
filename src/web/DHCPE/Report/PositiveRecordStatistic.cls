Class web.DHCPE.Report.PositiveRecordStatistic Extends %RegisteredObject
{

ClassMethod SetPositiveRecord(DeleteFlag As %String = "0", Job, DateBegin As %Library.String = "", DateEnd As %Library.String = "", SexM As %Library.String = "", SexF As %Library.String = "")
{
	q:(""=DateBegin)&(""=DateEnd) ""
	i DeleteFlag=1 d
	.k ^DHCPETMPPRS(Job)
	.k ^DHCPETMPPRSExport
	.i (""=DateBegin) d
	..s DateBegin=+$h
	.e  d
	..s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
	.i (""=DateEnd) d
	..s DateEnd=+$h
	.e  d
	..s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
	s i=0
	s AdmDate=DateBegin-1  
 	f  s AdmDate=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate)) Q:(""=AdmDate)||(AdmDate>DateEnd)||(i>4)  d
	.s i=i+1
	.s AdmTime=0
	.f  s AdmTime=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime)) Q:(""=AdmTime)  d
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime, IAdmRowId))  Q:(""=IAdmRowId)  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)
 	...q:LocFlag=1
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...q:'("ARRIVED"=Status)
	...s ReCheckFlag=##class(web.DHCPE.PreCommon).IsReCheck(IAdmRowId,"IADM")
	...q:ReCheckFlag'=0
	...s EpisodeID=$P($g(^DHCPEIADM(IAdmRowId)),"^",1)
	...q:EpisodeID=""
	...s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	...s sexStr=$P(ageSexStr,"^",2)
	...q:(SexM="On")&&(sexStr="F")
	...q:(SexF="On")&&(sexStr="M")
	...s ageStr=$P(ageSexStr,"^",1)
	...s ageArea=..GetAgeArea(30,80,10,ageStr)
	...s ^DHCPETMPPRS(Job,"Person","Total")=+$g(^DHCPETMPPRS(Job,"Person","Total"))+1
	...s ^DHCPETMPPRS(Job,"Person","Sex",sexStr)=+$g(^DHCPETMPPRS(Job,"Person","Sex",sexStr))+1
	...s ^DHCPETMPPRS(Job,"Person","AgeArea",ageArea)=+$g(^DHCPETMPPRS(Job,"Person","AgeArea",ageArea))+1
	...s ^DHCPETMPPRS(Job,"Person","SexAgeArea",sexStr,ageArea)=+$g(^DHCPETMPPRS(Job,"Person","SexAgeArea",sexStr,ageArea))+1
	...s RLTId=0
	...f  s RLTId=$o(^DHCPERLT(0,"ADM",EpisodeID,RLTId)) q:RLTId=""  d
	....s OEORIDR=$p(^DHCPERLT(RLTId),"^",9)
	....s ARCIMDR=$p(^DHCPERLT(RLTId),"^",2)
	....s STRowId=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,0))
	....q:STRowId=""
	....s ^DHCPETMPPRS(Job,"Person","OEORI",EpisodeID,OEORIDR)=ARCIMDR_"^"_STRowId
	...
	...s OEORDRowId=0
	...f  s OEORDRowId=$o(^DHCPETMPPRS(Job,"Person","OEORI",EpisodeID,OEORDRowId)) q:OEORDRowId=""  d
	....s ARCIMRowId=$p($g(^DHCPETMPPRS(Job,"Person","OEORI",EpisodeID,OEORDRowId)),"^",1)
	....s StationId=$p($g(^DHCPETMPPRS(Job,"Person","OEORI",EpisodeID,OEORDRowId)),"^",2)
	....s ARCIMDesc=$p(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1),"^",2)
	....s ^DHCPETMPPRS(Job,"Person","ARCIM","Total",StationId,ARCIMDesc)=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","Total",StationId,ARCIMDesc))+1
	....s ^DHCPETMPPRS(Job,"Person","ARCIM","Sex",StationId,ARCIMDesc,sexStr)=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","Sex",StationId,ARCIMDesc,sexStr))+1
	....s ^DHCPETMPPRS(Job,"Person","ARCIM","AgeArea",StationId,ARCIMDesc,ageArea)=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","AgeArea",StationId,ARCIMDesc,ageArea))+1
	....s ^DHCPETMPPRS(Job,"Person","ARCIM","SexAgeArea",StationId,ARCIMDesc,sexStr,ageArea)=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","SexAgeArea",StationId,ARCIMDesc,sexStr,ageArea))+1
	....s ^DHCPETMPPRSExport("Export","ARCIM","Sex",ARCIMRowId,sexStr)=+$g(^DHCPETMPPRSExport("Export","ARCIM","Sex",ARCIMRowId,sexStr))+1
	....s ^DHCPETMPPRSExport("Export","ARCIM","SexAgeArea",ARCIMRowId,sexStr,ageArea)=+$g(^DHCPETMPPRSExport("Export","ARCIM","SexAgeArea",ARCIMRowId,sexStr,ageArea))+1
	...d JudgeExpress
	q:(i<5)||(AdmDate>=DateEnd) ""
	q (AdmDate+1)_"^"_DateEnd
	q
JudgeExpress	
	s ID=0,Sequence=""
    f  s ID=$o(^User.DHCPEPositiveRecordI("TypeIndex","P",ID)) q:ID=""  d
    .s MSeq=$listget(^User.DHCPEPositiveRecordD(ID),4)
	.s FSeq=$listget(^User.DHCPEPositiveRecordD(ID),5)
	.i sexStr="M" s Sequence=MSeq
	.i sexStr="F" s Sequence=FSeq
	.i Sequence="" s Sequence="N"
	.s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","PR",ID,0))
	.i ExpressID'=""  d
	..s Express=""
	..s QuitFlag=0
	..s ExpressID=0
	..f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","PR",ID,ExpressID)) q:(ExpressID="")||(QuitFlag=1)  d
	...s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
	...;判断年龄范围
	...s AgeRange=obj.EAgeRange
	...s MinAge=$P(AgeRange,"-",1)
	...s:MinAge="" MinAge=0 
	...s MaxAge=$P(AgeRange,"-",2)
	...s:MaxAge="" MaxAge=120
	...;q:(ageStr<MinAge)||(ageStr>MaxAge)
	...;年龄End
	...s Express=Express_obj.EPreBracket
	...s ItemID=obj.EItemDRGetObjectId()
	...s NoBloodFlag=obj.ENoBloodFlag
	...s EDRowId=obj.ESourceID
	...s ItemID=##class(web.DHCPE.ResultEdit).GetUseItemID(EpisodeID,ItemID,EDRowId,NoBloodFlag)
	...i ItemID="" s ItemID="a||b"
	
	...i $D(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) d  ;;逐个判断此细项是否满足
	....s ItemType=obj.EItemDR.ODType
	....s Reference=obj.EReference
	....i Reference="" s Reference=obj.EODStandardDR.ODSTextVal
	....s Operator=obj.EOperator
	....s IsResult=0
	....s RLTID=0
	....f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")||(IsResult=1)  d
 	.....s Result=$P(^DHCPERLT(RLTID),"^",4)
 	.....s EDID=$P(^DHCPERLT(RLTID),"^",9)
 	.....i (ItemType="S")||(ItemType="T") d
 	......s Result=""""_Result_""""
 	......s Reference=""""_Reference_""""
 	.....s OneExpress=Result_Operator_Reference
 	.....s IsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
	...e  d  ;;没有结果设置为0
	....s IsResult=0
	...i ((ageStr<MinAge)||(ageStr>MaxAge)) s IsResult=0
	...s ExpressSex=obj.ESex
	...;;性别不符设置为0
	...s:(ExpressSex'="N")&&(ExpressSex'=sexStr) IsResult=0
	...s Express=Express_IsResult_obj.EAfterBracket_obj.ERelation
	...s:obj.ERelation="" QuitFlag=1
	..s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
	..i rStr d
	...s ^DHCPETMPPRS(Job,"Positive","Sex",ID,sexStr)=+$g(^DHCPETMPPRS(Job,"Positive","Sex",ID,sexStr))+1
	...s ^DHCPETMPPRS(Job,"Positive","SexAgeArea",ID,sexStr,ageArea)=+$g(^DHCPETMPPRS(Job,"Positive","SexAgeArea",ID,sexStr,ageArea))+1
	...s ^DHCPETMPPRSExport("Export","Positive","Sex",Sequence,ID,sexStr)=+$g(^DHCPETMPPRSExport("Export","Positive","Sex",Sequence,ID,sexStr))+1
	...s ^DHCPETMPPRSExport("Export","Positive","SexAgeArea",Sequence,ID,sexStr,ageArea)=+$g(^DHCPETMPPRSExport("Export","Positive","SexAgeArea",Sequence,ID,sexStr,ageArea))+1
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.PositiveRecordStatistic","QueryPositiveRecord","","")
Query QueryPositiveRecord(Job As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", SexM As %Library.String = "", SexF As %Library.String = "") As %Query(ROWSPEC = "ItmMast:%String,SexName:%String,ItmMastNum:%String,Age1Num:%String,Age2Num:%String,Age3Num:%String,Age4Num:%String,Age5Num:%String,Age6Num:%String,Age7Num:%String")
{
}

ClassMethod QueryPositiveRecordExecute(ByRef qHandle As %Binary, Job As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", SexM As %Library.String = "", SexF As %Library.String = "") As %Status
{
 	s ind=1
 	//s Job=$j
	Set repid=$I(^CacheTemp)
	i Job=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i (""=DateBegin)&(""=DateEnd)
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	} 

	i DateBegin'=""  s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
	i DateEnd'=""    s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
	s Sex=""
	f  s Sex=$o(^DHCPETMPPRS(Job,"Person","Sex",Sex)) q:Sex=""  d
	.s ItmMast="体检总人数",SexItmMastNum=0,Age1Num=0,Age2Num=0,Age3Num=0,Age4Num=0,Age5Num=0,Age6Num=0,Age7Num=0
	.s SexItmMastNum=+$g(^DHCPETMPPRS(Job,"Person","Sex",Sex))
	.i Sex="M" s SexName="男"
	.i Sex="F" s SexName="女"
	.s Age1Num=+$g(^DHCPETMPPRS(Job,"Person","SexAgeArea",Sex,"18-29"))
	.s Age2Num=+$g(^DHCPETMPPRS(Job,"Person","SexAgeArea",Sex,"30-39"))
	.s Age3Num=+$g(^DHCPETMPPRS(Job,"Person","SexAgeArea",Sex,"40-49"))
	.s Age4Num=+$g(^DHCPETMPPRS(Job,"Person","SexAgeArea",Sex,"50-59"))
	.s Age5Num=+$g(^DHCPETMPPRS(Job,"Person","SexAgeArea",Sex,"60-69"))
	.s Age6Num=+$g(^DHCPETMPPRS(Job,"Person","SexAgeArea",Sex,"70-79"))
	.s Age7Num=+$g(^DHCPETMPPRS(Job,"Person","SexAgeArea",Sex,"80及以上"))
	.s Data=$LB(ItmMast,SexName,SexItmMastNum,Age1Num,Age2Num,Age3Num,Age4Num,Age5Num,Age6Num,Age7Num)
	.d StatisticOut
	
	
	
	
	s STId=0
	f  s STId=$o(^DHCPETMPPRS(Job,"Person","ARCIM","Total",STId)) q:STId=""  d
	.s ItmMast="",ItmMastNum=0,MItmMastNum=0,FItmMastNum=0,Age1Num=0,Age2Num=0,Age3Num=0,Age4Num=0,Age5Num=0,Age6Num=0,Age7Num=0
	.f  s ItmMast=$o(^DHCPETMPPRS(Job,"Person","ARCIM","Total",STId,ItmMast)) q:ItmMast=""  d
	..s ItmMastNum=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","Total",STId,ItmMast))
	..s Sex=""
	..f  s Sex=$o(^DHCPETMPPRS(Job,"Person","ARCIM","Sex",STId,ItmMast,Sex)) q:Sex=""  d
	...s SexItmMastNum=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","Sex",STId,ItmMast,Sex))
	...i Sex="M" s SexName="男"
	...i Sex="F" s SexName="女"
	...s Age1Num=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","SexAgeArea",STId,ItmMast,Sex,"18-29"))
	...s Age2Num=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","SexAgeArea",STId,ItmMast,Sex,"30-39"))
	...s Age3Num=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","SexAgeArea",STId,ItmMast,Sex,"40-49"))
	...s Age4Num=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","SexAgeArea",STId,ItmMast,Sex,"50-59"))
	...s Age5Num=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","SexAgeArea",STId,ItmMast,Sex,"60-69"))
	...s Age6Num=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","SexAgeArea",STId,ItmMast,Sex,"70-79"))
	...s Age7Num=+$g(^DHCPETMPPRS(Job,"Person","ARCIM","SexAgeArea",STId,ItmMast,Sex,"80及以上"))
	...s Data=$LB(ItmMast,SexName,SexItmMastNum,Age1Num,Age2Num,Age3Num,Age4Num,Age5Num,Age6Num,Age7Num)
	...d StatisticOut
	
	//s Data=$LB("阳性记录名称","性别","阳性人数","","","","年龄分组","","","")
	s Data=$LB("阳性记录名称","性别","阳性人数","18-29","30-39","40-49","50-59","60-69","70-79","80及以上")
	d StatisticOut
	
	s PRID=0,PositiveNum=0,Age1Num=0,Age2Num=0,Age3Num=0,Age4Num=0,Age5Num=0,Age6Num=0,Age7Num=0
	f  s PRID=$o(^DHCPETMPPRS(Job,"Positive","Sex",PRID)) q:PRID=""  d
	.s Sex=""
	.s PositiveName=$list(^User.DHCPEPositiveRecordD(PRID),3)
	.f  s Sex=$o(^DHCPETMPPRS(Job,"Positive","Sex",PRID,Sex)) q:Sex=""  d
	..i Sex="M" s SexName="男"
	..i Sex="F" s SexName="女"
	..s PositiveNum=+$g(^DHCPETMPPRS(Job,"Positive","Sex",PRID,Sex))
	..s Age1Num=+$g(^DHCPETMPPRS(Job,"Positive","SexAgeArea",PRID,Sex,"18-29"))
	..s Age2Num=+$g(^DHCPETMPPRS(Job,"Positive","SexAgeArea",PRID,Sex,"30-39"))
	..s Age3Num=+$g(^DHCPETMPPRS(Job,"Positive","SexAgeArea",PRID,Sex,"40-49"))
	..s Age4Num=+$g(^DHCPETMPPRS(Job,"Positive","SexAgeArea",PRID,Sex,"50-59"))
	..s Age5Num=+$g(^DHCPETMPPRS(Job,"Positive","SexAgeArea",PRID,Sex,"60-69"))
	..s Age6Num=+$g(^DHCPETMPPRS(Job,"Positive","SexAgeArea",PRID,Sex,"70-79"))
	..s Age7Num=+$g(^DHCPETMPPRS(Job,"Positive","SexAgeArea",PRID,Sex,"80及以上"))
	..s Data=$LB(PositiveName,SexName,PositiveNum,Age1Num,Age2Num,Age3Num,Age4Num,Age5Num,Age6Num,Age7Num)
	..d StatisticOut
	
	;k ^DHCPETMPPRS(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

		
StatisticOut
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryPositiveRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPositiveRecordExecute ]
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

ClassMethod QueryPositiveRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPositiveRecordExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCPE.Report.PositiveRecordStatistic).Test()
ClassMethod Test()
{
	s Express="" 
	s obj=##class(User.DHCPEExpress).%OpenId(1476)
	s Express=Express_obj.EPreBracket
	s ItemID=obj.EItemDRGetObjectId()
	q ItemID
}

/// 获取年龄所在的区间
/// w ##class(web.DHCPE.Report.PositiveRecordStatistic).GetAgeArea(30,80,10,80)
ClassMethod GetAgeArea(aAgeFrom As %String = "", aAgeTo As %String = "", aAgeStep As %String = "", aAge As %String = "")
{

	
	s aAge=+$G(aAge)
	Q:(aAge>=+aAgeTo) "80及以上"
	q:aAge<18 "18岁以下"
	Q:(aAge<+aAgeFrom) "18-29"
	s n=(aAge-aAgeFrom)\aAgeStep 
	s LowerAgeArea=aAgeFrom+(aAgeStep*n) 
	s HeightAgeArea=aAgeFrom+(aAgeStep*(n+1))-1
	s:(HeightAgeArea>aAgeTo) HeightAgeArea=aAgeTo
	 
	Q LowerAgeArea_"-"_HeightAgeArea
}

ClassMethod ExportPositive(InString)
{
	q:InString="" ""
	s j=2
	s Sex=$p(InString,"^",1)
	;q:Sex=""   //wbg20140329
	s ret=""
   	while (j<=$l(InString,"^"))
   	{
	   	s (PersonNum,Age1Num,Age2Num,Age3Num,Age4Num,Age5Num,Age6Num,Age7Num)=0
	   	s PersonStr=""
		s ARCIMId=$p(InString,"^",j)
		s j=j+1
		continue:(ARCIMId="") 
		
		s ArcLength=$L(ARCIMId,"&")
		f Arci=1:1:ArcLength d
		.s OneId=$P(ARCIMId,"&",Arci)
		.s PersonNum=PersonNum+$g(^DHCPETMPPRSExport("Export","ARCIM","Sex",OneId,Sex))
		.s Age1Num=Age1Num+$g(^DHCPETMPPRSExport("Export","ARCIM","SexAgeArea",OneId,Sex,"18-29"))
		.s Age2Num=Age2Num+$g(^DHCPETMPPRSExport("Export","ARCIM","SexAgeArea",OneId,Sex,"30-39"))
		.s Age3Num=Age3Num+$g(^DHCPETMPPRSExport("Export","ARCIM","SexAgeArea",OneId,Sex,"40-49"))
		.s Age4Num=Age4Num+$g(^DHCPETMPPRSExport("Export","ARCIM","SexAgeArea",OneId,Sex,"50-59"))
		.s Age5Num=Age5Num+$g(^DHCPETMPPRSExport("Export","ARCIM","SexAgeArea",OneId,Sex,"60-69"))
		.s Age6Num=Age6Num+$g(^DHCPETMPPRSExport("Export","ARCIM","SexAgeArea",OneId,Sex,"70-79"))
		.s Age7Num=Age7Num+$g(^DHCPETMPPRSExport("Export","ARCIM","SexAgeArea",OneId,Sex,"80及以上"))
		s PersonStr=PersonNum_"@"_Age1Num_"@"_Age2Num_"@"_Age3Num_"@"_Age4Num_"@"_Age5Num_"@"_Age6Num_"@"_Age7Num
		s ret=ret_"^"_PersonStr
   	}
	
	q ret
}

ClassMethod ExportPositiveRecord(Sex)
{
	;q:Sex="" ""
	s ret=""
	s Sort=0
	f  s Sort=$o(^DHCPETMPPRSExport("Export","Positive","Sex",Sort)) q:Sort=""  d
	.q:Sort="N"
	.s PersonStr=""
	.s ID=0
	.f  s ID=$o(^DHCPETMPPRSExport("Export","Positive","Sex",Sort,ID)) q:ID=""  d
	..s (PersonNum,Age1Num,Age2Num,Age3Num,Age4Num,Age5Num,Age6Num,Age7Num)=0
	..s Desc=$listget(^User.DHCPEPositiveRecordD(ID),3)
	..s PersonNum=+$g(^DHCPETMPPRSExport("Export","Positive","Sex",Sort,ID,Sex))
	..s Age1Num=+$g(^DHCPETMPPRSExport("Export","Positive","SexAgeArea",Sort,ID,Sex,"18-29"))
	..s Age2Num=+$g(^DHCPETMPPRSExport("Export","Positive","SexAgeArea",Sort,ID,Sex,"30-39"))
	..s Age3Num=+$g(^DHCPETMPPRSExport("Export","Positive","SexAgeArea",Sort,ID,Sex,"40-49"))
	..s Age4Num=+$g(^DHCPETMPPRSExport("Export","Positive","SexAgeArea",Sort,ID,Sex,"50-59"))
	..s Age5Num=+$g(^DHCPETMPPRSExport("Export","Positive","SexAgeArea",Sort,ID,Sex,"60-69"))
	..s Age6Num=+$g(^DHCPETMPPRSExport("Export","Positive","SexAgeArea",Sort,ID,Sex,"70-79"))
	..s Age7Num=+$g(^DHCPETMPPRSExport("Export","Positive","SexAgeArea",Sort,ID,Sex,"80及以上"))
	..s PersonStr=Sort_"@"_Desc_"@"_""_"@"_PersonNum_"@"_Age1Num_"@"_Age2Num_"@"_Age3Num_"@"_Age4Num_"@"_Age5Num_"@"_Age6Num_"@"_Age7Num
	.s ret=ret_"^"_PersonStr
   
	
	q ret
}

}
