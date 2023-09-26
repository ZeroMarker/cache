Import SQLUser

Class web.DHCPE.HighRisk Extends %RegisteredObject
{

ClassMethod GenAdmHighRisk(EpisodeID As %String) As %String
{
	;w ##class(web.DHCPE.HighRisk).GenAdmHighRisk("273155")
	q:$g(EpisodeID)="" ""
	s UserId=%session.Get("LOGON.USERID")
	;s loc=%session.Get("LOGON.CTLOCID")
	s loc=##class(web.DHCPE.DHCPECommon).GetEDloc()
	s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	s sexStr=$P(ageSexStr,"^",2)
	k ^DHCPEGenED("GetSummarize",EpisodeID)
	k ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID)
	k ^TempDHCPERecomm("AutoSummarizeRecomm","NoRelate",EpisodeID)
	s curLoc=$P($G(^PAADM(EpisodeID)),"^",4)
	//s risStationStr="^"_$G(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	//s labStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	s risStationStr="^"_$G(^DHCPESetting("DHCPE","StationId_Ris",curLoc))_"^"
	s labStation=$G(^DHCPESetting("DHCPE","StationId_Lab",curLoc))

	s risStationStr=risStationStr_labStation_"^"
	s EDRowId=0
	s Job=$J
	k ^TempDHCPE("Sort",Job)
	d ##class(web.DHCPE.ResultEdit).GetEDSort(EpisodeID,Job)
	f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
	.q:$D(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId))
	.s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
	.q:activeFlag'="Y"
	.s HighRiskFlag=$P(^DHCPEED(EDRowId,1),"^",8)
	.q:HighRiskFlag'="Y"
	.s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,0))
	.i ExpressID'=""  d
	..s Express=""
	..s ExpressID=0
	..f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,ExpressID)) q:ExpressID=""  d
	...s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
	...s Express=Express_obj.EPreBracket
	...s ItemID=obj.EItemDRGetObjectId()
	...i $D(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) d  ;;逐个判断此细项是否满足
	....s Reference=obj.EReference
	....i Reference="" s Reference=obj.EODStandardDR.ODSTextVal
	....s Operator=obj.EOperator
	....s IsResult=0
	....s RLTID=0
	....f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")||(IsResult=1)  d
 	.....s Result=$P(^DHCPERLT(RLTID),"^",4)
 	.....s EDID=$P(^DHCPERLT(RLTID),"^",9)
 	.....s OneExpress=Result_Operator_Reference
 	.....s IsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
	.....s ^TempDHCPERecomm(Job,EDRowId,RLTID)=""
	...e  d  ;;没有结果设置为0
	....s IsResult=0
	...s ExpressSex=obj.ESex
	...;性别不符设置为0
	...s:(ExpressSex'="N")&&(ExpressSex'=sexStr) IsResult=0
	...s Express=Express_IsResult_obj.EAfterBracket_obj.ERelation
	..s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
	..i rStr d
	...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
	...s Sort=$G(^TempDHCPE("Sort",Job,EDID))
	...i Sort="" s Sort=1
	...s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
	
	k ^TempDHCPE("Sort",Job)
	s UpdateDate=+$H
	s UpdateTime=$p($H,",",2)
	s Flag=0
	s ID=""
	f  s ID=$O(^User.DHCPEHighRiskResultD("PAAdmIndex",EpisodeID,ID)) q:ID=""  d
	.s HighRiskID=$LG(^User.DHCPEHighRiskResultD(ID),3)
	.q:HighRiskID=""
	.&SQL(Update Sqluser.DHC_PE_HighRiskResult set HRR_Active='N' where ID=:ID)
	.s ^TempDHCPEHighRisk(Job,HighRiskID)=ID
	s EDRowId=0
	f  s EDRowId=$o(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)) q:EDRowId=""  d
	.q:^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=0
	.s Advice=$p(^DHCPEED(EDRowId,"Detail"),"^",1)
	.s Advice=##class(web.DHCPE.DHCPEExpertDiagnosis).GetKeyReplaceStr(EpisodeID,EDRowId)
	.s DisplayDesc=$p(^DHCPEED(EDRowId,"1"),"^",1)
	.i $D(^TempDHCPEHighRisk(Job,EDRowId)) d
	..s ID=$G(^TempDHCPEHighRisk(Job,EDRowId))
	..s obj=##class(User.DHCPEHighRiskResult).%OpenId(ID)
	.e  d
	..s obj=##class(User.DHCPEHighRiskResult).%New()
	.s obj.HRRActive="Y"
	.s obj.HRREDDetail=Advice
	.d obj.HRREDDRSetObjectId(EDRowId)
	.d obj.HRRPAAdmSetObjectId(EpisodeID)
	.s obj.HRRDate=UpdateDate
	.s obj.HRRTime=UpdateTime
	.d obj.HRRUserDRSetObjectId(UserId)
	.d obj.childDetail.Clear()
	.s RLTID=0
	.f  s RLTID=$O(^TempDHCPERecomm(Job,EDRowId,RLTID)) q:RLTID=""  d
	..s ChildObj=##class(User.DHCPEHighRiskDetail).%New()
	..d ChildObj.HRDResultDRSetObjectId(RLTID)
	..d obj.childDetail.Insert(ChildObj)
	.s sc=obj.%Save()
	.s ID=obj.%Id()
	.d obj.%Close()
	.i $System.Status.IsError(sc) d
	..s Flag=-1
	.q:Flag=-1
	
	k ^DHCPEGenED("GetSummarize",EpisodeID)
	k ^TempDHCPEHighRisk(Job)
	k ^TempDHCPERecomm(Job)
	q Flag

GetAllSummarize
	s:'$D(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID)) Flag=0,AllFlag=0
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
	.s EDID=$P(^DHCPERLT(rltID),"^",9)
	.s ^TempDHCPERecomm(Job,EDRowId,rltID)="Y"
	.i conditionFlag'="1" d
	..s Sort=$G(^TempDHCPE("Sort",Job,EDID))
	..i Sort="" s Sort=1
	..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
	..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=1
	..s ^TempDHCPERecomm(Job,EDRowId,rltID)="Y"
	..;s ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID,rltID)="Y"
	q
CheckTextResult
	s standardText=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",2)
	s StrFlag=0
	s rltID=0
	f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
	.s Flag=1
	.s PDFlag=1
	.s rltValue=$P($g(^DHCPERLT(rltID)),"^",4) 
	.// 对于选择类型： 如果一个细项对应多个选择项结果，则没有与诊断关联的选择项，不标记
	.//s:(rltValue'=standardText)&&(risFlag=0) Flag=0 ,^TempDHCPERecomm("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0  
	.//s:(rltValue'[standardText)&&(risFlag=1) Flag=0 ,^TempDHCPERecomm("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0
	.s:(rltValue'=standardText)&&(ItemType="S") Flag=0  ;,^TempDHCPERecomm("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0  
	.s:(rltValue'[standardText)&&(ItemType="T") Flag=0  ;,^TempDHCPERecomm("AutoSummarizeRecomm","NoRelate",EpisodeID,rltID)=1 //,AllFlag=0
	
	.q:Flag=0
	.s ^TempDHCPERecomm(Job,EDRowId,rltID)="Y"
	.s StrFlag=1
	.s EDID=$P(^DHCPERLT(rltID),"^",9)
	.i conditionFlag'="1" d
	..s Sort=$G(^TempDHCPE("Sort",Job,EDID))
	..i Sort="" s Sort=1
	..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId,"Sort")=Sort
	..s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=1
	..;s ^DHCPEDataEx("AutoSummarizeRecomm",EpisodeID,rltID)="Y"
 	s:StrFlag=0 AllFlag=0
	q
}

// 得到高危编码

ClassMethod GetMaxCode()
{
  
	/*
	s Code=0
	s Code=$O(^DHCPEDataEx("DHCPEHighRisk",""),-1)
	i Code="" s Code=0
	s Code=+Code+1
	q Code
	*/
	s Code=0
	&SQL(select max(HRT_Code) into :Code from sqluser.DHC_PE_HighRiskType)
	i Code="" s Code=0
	s Code=+Code+1
	s Code=$E("00000000",1,8-$l(Code))_Code
	q Code
}

ClassMethod SaveHighRisk(String)
{
	/*
	s Code=$p(String,"^",1)
	s Desc=$p(String,"^",2)
	s ^DHCPEDataEx("DHCPEHighRisk",Code)=Desc
	q ""
	*/
	s SQLCODE=0
	s Code=$p(String,"^",1)
	s Desc=$p(String,"^",2)
	s Express=$p(String,"^",3)
	s RowID=$p(String,"^",4)
	if RowID="" {
	&SQL(insert into sqluser.DHC_PE_HighRiskType(HRT_Code,HRT_Desc,HRT_Express)
		values (:Code,:Desc,:Express))
 	}
 	else {
	 
	 &SQL(update sqluser.DHC_PE_HighRiskType set HRT_Code=:Code,HRT_Desc=:Desc ,HRT_Express=:Express where HRT_RowId=:RowID)

	}

	i SQLCODE'=0 q "操作失败!"
	q SQLCODE
}

ClassMethod DeleteHighRisk(RowID)
{
	
	 s SQLCODE=0
	&SQL(DELETE FROM sqluser.DHC_PE_HighRiskType where HRT_RowId=:RowID)

	q SQLCODE
}

ClassMethod AddCondition(String)
{
   
	s Num=$p(String,"^",1)
	s Code=$p(String,"^",2)
	s Desc=$p(String,"^",3)
	s OrderDetailRowId=$p(String,"^",4)
	s StandardRowId=$p(String,"^",5)
	s TextValue=$p(String,"^",6)
	s Min=$p(String,"^",7)
	s Max=$p(String,"^",8)
	s Sex=$p(String,"^",9)
	s AgeMin=$p(String,"^",10)
	s AgeMax=$p(String,"^",11)
	i Num=""  d
	.s Num=$o(^DHCPEDataEx("DHCPEHighRisk",Code,""),-1)
	.s Num=Num+1
    s ^DHCPEDataEx("DHCPEHighRisk",Code,Num,OrderDetailRowId)=StandardRowId_"^"_TextValue_"^"_Min_"^"_Max_"^"_Sex_"^"_AgeMin_"^"_AgeMax
    q ""
}

Query HighRiskCondition(Code As %Library.String = "") As %Query(ROWSPEC = "Code:%String,Num:%String,Station:%String,StationDesc:%String,DetailID:%String,DetailDesc:%String,StandardRowId:%String,Standard:%String,Min:%String,Max:%String,SexDesc:%String,AgeMin:%String,AgeMax:%String,DetailType:%String")
{
}

ClassMethod HighRiskConditionExecute(ByRef qHandle As %Binary, Code As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	if Code=""
	{Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
		}
 	s ind=1
 	s Num=0
 	f  s Num=$o(^DHCPEDataEx("DHCPEHighRisk",Code,Num)) q:Num=""  d
 	.s DetailRowId=0
 	.f  s DetailRowId=$o(^DHCPEDataEx("DHCPEHighRisk",Code,Num,DetailRowId)) q:DetailRowId=""  d
	..s CurData=$g(^DHCPEDataEx("DHCPEHighRisk",Code,Num,DetailRowId))
	..s DetailDesc=$p(^DHCPEST($p(DetailRowId,"||",1),"OD",$p(DetailRowId,"||",2)),"^",1)
	..s DetailType=$p(^DHCPEST($p(DetailRowId,"||",1),"OD",$p(DetailRowId,"||",2)),"^",2)
	..s Standard=$p(CurData,"^",1)
	..s StandardDesc=""
	..i DetailType="S"  d
	...i Standard'=""  s StandardDesc=$p(^DHCPEST($p(Standard,"||",1),"OD", $p(Standard,"||",2),"ODS",$p(Standard,"||",3)) ,"^",2)
	..i DetailType="T" s StandardDesc=$p(CurData,"^",2)
	..s Min=$p(CurData,"^",3)
	..s Max=$p(CurData,"^",4)
	..s Sex=$p(CurData,"^",5)
	..s AgeMin=$p(CurData,"^",6)
	..s AgeMax=$p(CurData,"^",7)
	..s StationRowID=$P(DetailRowId,"||",1)
	..s StationDesc=$p(^DHCPEST(StationRowID),"^",2)
	..d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	set Data=$lb(Code,Num,StationRowID,StationDesc,DetailRowId,DetailDesc,Standard,StandardDesc,Min,Max,Sex,AgeMin,AgeMax,DetailType)
	s ^lisatest("Data")=Data
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod HighRiskConditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HighRiskConditionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod HighRiskConditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HighRiskConditionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query HighRiskBaseInfo(Desc As %Library.String = "") As %Query(ROWSPEC = "Code:%String,Desc:%String,Express:%String,RowID:%String")
{
}

ClassMethod HighRiskBaseInfoExecute(ByRef qHandle As %Binary, Desc As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	/*
 	s HighRiskCode=0
 	f  s HighRiskCode=$o(^DHCPEDataEx("DHCPEHighRisk",HighRiskCode))  q:HighRiskCode=""  d
 	.s HighRiskDesc=$G(^DHCPEDataEx("DHCPEHighRisk",HighRiskCode))
 	.q:(Desc'="")&&(HighRiskDesc'[Desc)
	.d Find
	*/
	//$list(^aa,1)
	s id=0
	f  s id=$o(^DHCPEHRType(id)) q:id=""  d
	.s obj=##class(User.DHCPEHighRiskType).%OpenId(id)
	.s Code=obj.Code
	.s Desc=obj.Desc
	.s Express=obj.Express
	.d Find	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Find
	set Data=$lb(Code,Desc,Express,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod HighRiskBaseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HighRiskBaseInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod HighRiskBaseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HighRiskBaseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(web.DHCPE.HighRisk).SetConditionFlag

ClassMethod SetConditionFlag(Code, Flag)
{
	s ^DHCPEDataEx("DHCPEHighRiskCondition","ConditionFlag",Code)=Flag
	q ""
}

// d ##class(web.DHCPE.HighRisk).GetHighRiskFlag("633")

/* 用于协和
ClassMethod GetHighRiskFlag(PAADM)
{
   
	q:$g(PAADM)="" ""
	k ^DHCPEDataEx("DHCPEHighRiskFlag",PAADM) //判断是否为高危
	k ^DHCPEDataEx("DHCPEHighRiskRemind",PAADM)  //进入随访列表
	k ^DHCPEDataEx("DHCPEHighRiskFlag","NoRelate",PAADM)  //一个细项对应对个结果，用于记录没有设置高危的选择项目
	s UserId=%session.Get("LOGON.USERID")
	s IAdm=$O(^DHCPEIADM(0,"PAADM",PAADM,""))
	q:IAdm="" 0
	s AgeSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(PAADM)
	s SexStr=$P(AgeSexStr,"^",2)
	s AgeStr=$P(AgeSexStr,"^",1)
	s RisStationStr="^"_$G(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	s risStationStr=RisStationStr_LabStation_"^"
	
	s EDRowId=0
	s Code=0
	f  s Code=$o(^DHCPEDataEx("DHCPEHighRisk",Code)) q:Code=""  d
	.s conditionFlag=$G(^DHCPEDataEx("DHCPEHighRiskCondition","ConditionFlag",Code))
	.s AllFlag=1  //是否满足所有条件
	.s PDFlag=0  //看是否设置了诊断条件0：没设置
	.s Num=0
	.f  s Num=$o(^DHCPEDataEx("DHCPEHighRisk",Code,Num)) q:Num=""  d
	..s DetailID=0
	..f  s DetailID=$o(^DHCPEDataEx("DHCPEHighRisk",Code,Num,DetailID))  q:DetailID=""  d
	...s CurData=$G(^DHCPEDataEx("DHCPEHighRisk",Code,Num,DetailID))
	...s ItemType=$P($g(^DHCPEST(+DetailID,"OD",$P(DetailID,"||",2))),"^",2)
	...s risFlag=0
	...s:risStationStr[("^"_+DetailID_"^") risFlag=1
	...s StandardDesc=""
	...s StandardRowId=$p(CurData,"^",1)
	...s TextValue=$p(CurData,"^",2)
	...s Min=$p(CurData,"^",3)
	...s Max=$p(CurData,"^",4)
	...s Sex=$p(CurData,"^",5)
	...s AgeMin=$p(CurData,"^",6)
	...s AgeMax=$p(CurData,"^",7)
	...q:(Sex'="N")&&(Sex'=SexStr)
	...q:(AgeMin'="")&&(AgeMin>AgeStr)
	...q:(AgeMax'="")&&(AgeMax<AgeStr)
	...If ItemType="N" Do CheckNumResult
	...If ItemType="C" Do CheckNumResult
	...If ItemType="T" Do CheckTextResult
	...If ItemType="S" Do CheckTextResult
	.i (PDFlag=1)&&(AllFlag=1) d
	..d ..AllHighRisk(PAADM,Code,AgeStr,SexStr,UserId)
	q ""
	
CheckNumResult
	
	s rltID=0
	f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,DetailID,rltID)) q:rltID=""  d
	.s Flag=1
	.s PDFlag=1
	.s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
	.s:+rltValue<Min Flag=0,AllFlag=0
	.s:+rltValue>Max Flag=0,AllFlag=0
	.q:Flag=0
	.i conditionFlag'="1" d
	..s ^DHCPEDataEx("DHCPEHighRiskFlag",PAADM,rltID)="1"
	..s ^DHCPEDataEx("DHCPEHighRiskRemind",PAADM,rltID)=$H_"^"_UserId
	
	q
CheckTextResult
	s StrFlag=0
	s rltID=0
	f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,DetailID,rltID)) q:rltID=""  d
	.s Flag=1
	.s PDFlag=1
	.s rltValue=$P($g(^DHCPERLT(rltID)),"^",4) 
	.i StandardRowId'=""  s StandardDesc=$p(^DHCPEST($p(StandardRowId,"||",1),"OD", $p(StandardRowId,"||",2),"ODS",$p(StandardRowId,"||",3)) ,"^",2)
	.// 对于选择类型
	.i ItemType="T"  s standardText=TextValue
	.i ItemType="S"  s standardText=StandardDesc
	.s:(rltValue'=standardText)&&(risFlag=0) Flag=0 ,  ^DHCPEDataEx("DHCPEHighRiskFlag","NoRelate",PAADM,rltID)=1 //,AllFlag=0  
	.s:(rltValue'[standardText)&&(risFlag=1) Flag=0 , ^DHCPEDataEx("DHCPEHighRiskFlag","NoRelate",PAADM,rltID)=1 //,AllFlag=0
	.q:Flag=0
	.s StrFlag=1
	.i conditionFlag'="1" d
	..s ^DHCPEDataEx("DHCPEHighRiskFlag",PAADM,rltID)="1"
	..s ^DHCPEDataEx("DHCPEHighRiskRemind",PAADM,rltID)=$H_"^"_UserId
 	s:StrFlag=0 AllFlag=0
	q
}
*/

/*
ClassMethod GetHighRiskFlag(EpisodeID As %String, GSRowId As %String) As %String
{

	q:$g(EpisodeID)="" ""
	s SQLCODE=0
	s UserId=%session.Get("LOGON.USERID")
	s IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
	q:IAdm="" 0
	k ^DHCPEGenED("GetHighRiskFlag",UserId,EpisodeID)
	s loc=%session.Get("LOGON.CTLOCID")
	s risStationStr="^"_$G(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	s labStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	s risStationStr=risStationStr_labStation_"^"
	s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	s sexStr=$P(ageSexStr,"^",2)
	s id=0
	f  s id=$o(^DHCPEHRType(id)) q:id=""  d
	.s obj=##class(User.DHCPEHighRiskType).%OpenId(id)
	.s Code=obj.Code
	.s Desc=obj.Desc
	.s Express=obj.Express
	.q:Express=""
	.s FinalExpress=Express
	.s i=$L(Express,"[")
	.f j=2:1:i  d
	..s orderDetailStandardID=$P(Express,"[",j)
	..s orderDetailStandardID=$P(orderDetailStandardID,"]",1)
	..q:'$D(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)))
	..s Normal=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",6)
	..s orderDetailID=$P(orderDetailStandardID,"||",1,2)
	..q:orderDetailID=""
	..s ItemType=$P($g(^DHCPEST(+orderDetailID,"OD",$P(orderDetailID,"||",2))),"^",2)
	..s curSex=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",1)
	..q:(curSex'="N")&&(curSex'=sexStr)
	..s PDFlag=0 ;是否存在细项对应的结果，不存在但做不满足处理
	..s OneFlag=0  ;不满足   结果中没有这个细项当作不满足的
	..d GetAllSummarize
	..s FinalExpress=##class(web.DHCPE.Public.Setting).Replace(FinalExpress,"["_orderDetailStandardID_"]",OneFlag)
	.s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(FinalExpress)
	i 'rStr  d
	.k ^DHCPEGenED("GetHighRiskFlag",UserId,EpisodeID)
	
	
	s EDRowId=0
	s UpdateDate=+$H
	s UpdateTime=$p($H,",",2) 
	s RLTRowID=0
	f  s RLTRowID=$o(^DHCPEGenED("GetHighRiskFlag",UserId,EpisodeID,RLTRowID)) q:RLTRowID=""  d
	.s ParSSRowId=0
	.f  s ParSSRowId=$o(^DHCPESS(0,"RLT",RLTRowID,ParSSRowId)) q:ParSSRowId=""  d
	..s SSRChildSub=0
	..f  s SSRChildSub=$o(^DHCPESS(0,"RLT",RLTRowID,ParSSRowId,SSRChildSub)) q:SSRChildSub=""  d
	...s SSRowID=ParSSRowId_"||"_SSRChildSub
	...s GSRParRef=0
	...f  s GSRParRef=$o(^DHCPEGS(0,"SSRDR",SSRowID,GSRParRef)) q:GSRParRef=""  d
	....s GSRChildSub=0
	....f  s GSRChildSub=$o(^DHCPEGS(0,"SSRDR",SSRowID,GSRParRef,GSRChildSub)) q:GSRChildSub=""  d
	.....s GSRowID=GSRParRef_"||"_GSRChildSub
	.....&SQL(update sqluser.DHC_PE_GSResult set GSR_HighRiskFlag="Y" where GSR_RowId=:GSRowID)
	//k ^DHCPEGenED("GetSummarize",UserId,EpisodeID)
	q SQLCODE

GetAllSummarize
	q:'$D(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID))
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
	.s:+rltValue<Min Flag=0
	.s:+rltValue>Max Flag=0
	.q:Flag=0
	.s OneFlag=1  ;满足,1
	.s ^DHCPEGenED("GetHighRiskFlag",UserId,EpisodeID,rltID)=1
	q
CheckTextResult
	s standardText=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",2)
	s rltID=0
	f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
	.s Flag=1
	.s PDFlag=1
	.s rltValue=$P($g(^DHCPERLT(rltID)),"^",4) 
	.// 对于选择类型： 如果一个细项对应多个选择项结果，则没有与诊断关联的选择项，不标记
	.s:(rltValue'=standardText)&&(ItemType="S") Flag=0  
	.s:(rltValue'[standardText)&&(ItemType="T") Flag=0
	.q:Flag=0
	.s OneFlag=1  ;满足
	.s ^DHCPEGenED("GetHighRiskFlag",UserId,EpisodeID,rltID)=1
	
	q
}
*/
ClassMethod AllHighRisk(PAADM, HighRiskCode, AgeStr, SexStr, UserId)
{
   

    s Num=0
	f  s Num=$o(^DHCPEDataEx("DHCPEHighRisk",HighRiskCode,Num)) q:Num=""  d
	.s DetailID=0
	.f  s DetailID=$o(^DHCPEDataEx("DHCPEHighRisk",HighRiskCode,Num,DetailID))  q:DetailID=""  d
	..s CurData=$G(^DHCPEDataEx("DHCPEHighRisk",HighRiskCode,Num,DetailID))
	..s ItemType=$P($g(^DHCPEST(+DetailID,"OD",$P(DetailID,"||",2))),"^",2)
	..s ItemType=$P($g(^DHCPEST(+DetailID,"OD",$P(DetailID,"||",2))),"^",2)
    ..s StandardRowId=$p(CurData,"^",1)
	..s TextValue=$p(CurData,"^",2)
	..s Min=$p(CurData,"^",3)
	..s Max=$p(CurData,"^",4)
	..s Sex=$p(CurData,"^",5)
	..s AgeMin=$p(CurData,"^",6)
	..s AgeMax=$p(CurData,"^",7)
	..q:(Sex'="N")&&(Sex'=SexStr)
	..q:(AgeMin'="")&&(AgeMin>AgeStr)
	..q:(AgeMax'="")&&(AgeMax<AgeStr)
	..s rltID=0
	..f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,DetailID,rltID)) q:rltID=""  d
	...q:$D(^DHCPEDataEx("DHCPEHighRiskFlag","NoRelate",PAADM,rltID))
	...s ^DHCPEDataEx("DHCPEHighRiskFlag",PAADM,rltID)="1"
	...s ^DHCPEDataEx("DHCPEHighRiskRemind",PAADM,rltID)=$H_"^"_UserId
}

ClassMethod ChangeHighRiskRemind(RLTRowID, Flag)
{
   q:RLTRowID="" "结果ID数据出错"
	s PAADM=$P(^DHCPERLT(RLTRowID),"^",1)
	q:PAADM="" "PAADM数据出错"
	&SQL(Update SQLUser.DHC_PE_Result set RLT_FollowUpFlag=:Flag Where RLT_RowId= :RLTRowID)
	q ""
}

ClassMethod ChangeHighRiskFlag(RLTRowID, HighRiskFlag)
{
   	
	q:RLTRowID="" "结果ID数据出错"
	s PAADM=$P(^DHCPERLT(RLTRowID),"^",1)
	q:PAADM="" "PAADM数据出错"
	&SQL(Update SQLUser.DHC_PE_Result set RLT_HighRiskFlag=:HighRiskFlag Where RLT_RowId= :RLTRowID)

	
	
	q ""
}

// test: d ##class(%ResultSet).RunQuery("web.DHCPE.HighRisk","GetEDiagnosisByAlias","hh")

// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEIAdm","GetEDiagnosisByAlias","")

Query GetEDiagnosisByAlias(HighDiagnosis As %Library.String = "") As %Query(ROWSPEC = "HIDDEN:%String, Detail:%String, DiagnoseConclusion:%String, Code:%String")
{
}

ClassMethod GetEDiagnosisByAliasExecute(ByRef qHandle As %Binary, HighDiagnosis As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s Desc=$ZCVT(HighDiagnosis,"U")
	s CurUser=%session.Get("LOGON.USERID")
	//s CurUser=2873
	S HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
	s ind=1
 	i Desc=""
 	{
	 	s EDID=0
	 	f  s EDID=$o(^DHCPEED(EDID)) q:EDID=""  d
	 	.s RowId=EDID
	 	.s User=$p(^DHCPEED(EDID,1),"^",2)
	 	.d SetDataGetEDiagnosisByAlias
	 
 	}
 	else
 	{
	 	s RowIds="^"
		s TextDesc=$O(^DHCPEEDA(0,"Alias",Desc),-1)
	 	f  s TextDesc=$O(^DHCPEEDA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
		.s ARowId=0
		.f  s ARowId=$O(^DHCPEEDA(0,"Alias",TextDesc,ARowId)) q:ARowId=""  d
		..s RowId=$p($g(^DHCPEEDA(ARowId)),"^",1)
		..q:RowId=""
		..q:RowIds[("^"_RowId_"^")
		..s RowIds=RowIds_RowId_"^"
		..
		..s User=$p($g(^DHCPEED(RowId,1)),"^",2)
		..d SetDataGetEDiagnosisByAlias
	
	 	s TextDesc=$O(^DHCPEED(0,"CODE",Desc),-1)
	 	f  s TextDesc=$O(^DHCPEED(0,"CODE",TextDesc)) Q:((""=TextDesc)||(TextDesc'[Desc))  d
		.s RowId=0
		.f  s RowId=$O(^DHCPEED(0,"CODE",TextDesc,RowId)) q:RowId=""  d
		..q:RowId=""
		..q:RowIds[("^"_RowId_"^")
		..s RowIds=RowIds_RowId_"^"
		..s User=$p(^DHCPEED(RowId,1),"^",2)
		..d SetDataGetEDiagnosisByAlias

	 	s TextDesc=$O(^DHCPEED(0,"Conclusion",Desc),-1)
	 	f  s TextDesc=$O(^DHCPEED(0,"Conclusion",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
		.s RowId=0
		.f  s RowId=$O(^DHCPEED(0,"Conclusion",TextDesc,RowId)) q:RowId=""  d
		..q:RowId=""
		..q:RowIds[("^"_RowId_"^")
		..s RowIds=RowIds_RowId_"^"
		..d SetDataGetEDiagnosisByAlias
 	}
   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetDataGetEDiagnosisByAlias

	s (Detail,DC,Code)=""
	Set Cancle=0
	q:RowId=""
	s:$g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",RowId))'="Y" Cancle=1
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ED",RowId)         //Add by 090702
  	q:LocFlag=1 
	s Detail=$P($G(^DHCPEED(RowId,"Detail")),"^",1)
	s DC=$P($G(^DHCPEED(RowId,"1")),"^",1)
	s Code=$P($G(^DHCPEED(RowId,"1")),"^",6)
	s StationID=$P($G(^DHCPEED(RowId,"1")),"^",7)
	s User=$p(^DHCPEED(RowId,1),"^",2)   //Add
	s EDCRelate=$o(^DHCPEEDCR(0,"EDDR",RowId,0))
	q:EDCRelate=""
    s EDCRowID=$P(^DHCPEEDCR(EDCRelate),"^",2)
    q:EDCRowID=""
    q:'$d(^DHCPEDataEx("DHCPEDiagnosisLevel",EDCRowID))   //诊断级别设置不需要预警退出
    q:$G(^DHCPEDataEx("DHCPEDiagnosisLevel",EDCRowID))'="Y"
	d GetEDiagnosisByAlias
	q	
GetEDiagnosisByAlias      
	set Data=$lb(RowId, DC, Detail, Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetEDiagnosisByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEDiagnosisByAliasExecute ]
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

ClassMethod GetEDiagnosisByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEDiagnosisByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.HighRisk","QueryHighRiskData","")

/* 用于协和
Query QueryHighRiskData(RegNo As %Library.String = "", Name As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", TeamID As %Library.String = "", StationRowId As %Library.String = "", OrderDetailRowId As %Library.String = "", HighDiagnosisID As %Library.String = "") As %Query(ROWSPEC = "IADM:%String, RegNo:%String, PatName:%String, HighRiskItem:%String,HighRiskDiagnosis:%String, ADMDate:%String,PatSex:%String,PatAge:%String")
{
}

ClassMethod QueryHighRiskDataExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", Name As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", TeamID As %Library.String = "", StationRowId As %Library.String = "", OrderDetailRowId As %Library.String = "", HighDiagnosisID As %Library.String = "") As %Status
{

  	s ind=1
  	Set repid=$I(^CacheTemp)
	i DateBegin=""  s DateBegin=+$H
	i DateEnd=""  s DateEnd=+$H
	if RegNo'="" d
	.s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	.s PIBIDR=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	.q:PIBIDR=""
	.s PreIADM=0
	.f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,PreIADM)) q:PreIADM=""  d
	..s IADMDR=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	..q:IADMDR=""
	..d GetHighRiskInfo
	else  if GroupDR'=""  d
	.s TeamDR=0
	.f  s TeamDR=$o(^DHCPEIADM(0,"GADM",GroupDR,TeamDR)) q:TeamDR=""  d
	..q:(TeamID'="")&&(TeamID'=TeamDR)
	..s IADMDR=0
	..f  s IADMDR=$o(^DHCPEIADM(0,"GADM",GroupDR,TeamDR,IADMDR)) q:IADMDR=""  d
	...d GetHighRiskInfo
	else  if Name'="" d
	.s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",Name),-1)
	.f  s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",PatNameIndex)) q:(PatNameIndex="")||(PatNameIndex'[Name)  d
	..s PIBIDR=0
	..f  s PIBIDR=$o(^DHCPEPreIBI(0,"Name",PatNameIndex,PIBIDR)) q:PIBIDR=""  d
	...s PreIADM=0
	...f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,PreIADM)) q:PreIADM=""  d
	....s IADMDR=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	....q:IADMDR=""
	....d GetHighRiskInfo
	else  d
	.s Date=DateBegin-1
	.f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date))  q:Date=""  d
	..s Time=0
	..f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time))  q:Time=""  d
	...s IADMDR=0
	...f  s IADMDR=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADMDR)) q:IADMDR=""  d
	....d GetHighRiskInfo

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetHighRiskInfo
	s PAADM=$P(^DHCPEIADM(IADMDR),"^",1)
	q:PAADM=""
	s PIADM=$P(^DHCPEIADM(IADMDR),"^",4)
	q:PIADM=""
	s GADM=$P(^DHCPEIADM(IADMDR),"^",2)
	s AdmDate=$P(^DHCPEIADM(IADMDR),"^",5)
	i AdmDate'="" s AdmDate=$zd(AdmDate,3)
	q:(GroupDR'="")&&(GroupDR'=GADM)
	s Team=$P(^DHCPEIADM(IADMDR),"^",3)
	q:(TeamID'="")&&(TeamID'=Team)
	q:PIADM=""
	s PIBIRowID=$P(^DHCPEPreIADM(PIADM),"^",1)
	q:PIBIRowID=""
	s PatRegNo=$p(^DHCPEPreIBI(PIBIRowID),"^",1)
	s PatName=$p(^DHCPEPreIBI(PIBIRowID),"^",2)
	q:(Name'="")&&(PatName'[Name)
	s Age=""
	s BOD=$p($g(^DHCPEPreIBI(PIBIRowID)),"^",4)
	i BOD'="" s Age=$P(##class(web.DHCLCNUREXCUTE).CalAge(BOD,+$H),"Y",1) //$P(##class(web.DHCLCNUREXCUTE))
	s SEX=$p($g(^DHCPEPreIBI(PIBIRowID)),"^",3)
	i SEX'="" s SEX=$P(^CT("SEX",SEX),"^",2)
	s ResultStr="",HighRiskDiagnosis=""
	s RLTRowID=0
	f  s RLTRowID=$o(^DHCPEDataEx("DHCPEHighRiskRemind",PAADM,RLTRowID))  q:RLTRowID=""  d
 	.s Result=$p($g(^DHCPERLT(RLTRowID)),"^",4)
 	.s DetailID=$p($g(^DHCPERLT(RLTRowID)),"^",3)
 	.q:DetailID=""
 	.s CurrStation=$p(DetailID,"||",1)
	.q:(StationRowId'="")&&(StationRowId'=CurrStation)
 	.q:(OrderDetailRowId'="")&&(OrderDetailRowId'=DetailID)
	.s DetailDesc=$p($g(^DHCPEST(+DetailID,"OD",$p(DetailID,"||",2))),"^",1)
	.i ResultStr=""  s ResultStr=DetailDesc_":"_Result
	.else  s ResultStr=ResultStr_" "_DetailDesc_":"_Result
	s HighRiskDiagnosis=..GetHighRiskDiagnosis(PAADM,HighDiagnosisID)
   q:(((StationRowId'="")||(OrderDetailRowId'=""))&&(ResultStr=""))
   q:(HighDiagnosisID'="")&&(HighRiskDiagnosis="")
   q:(ResultStr="")&&(HighRiskDiagnosis="")
   d GetEDiagnosisByAlias
   q
GetEDiagnosisByAlias      

	set Data=$lb(IADMDR,PatRegNo, PatName, ResultStr, HighRiskDiagnosis,AdmDate,Age,SEX)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryHighRiskDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHighRiskDataExecute ]
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

ClassMethod QueryHighRiskDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHighRiskDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}
*/
Query QueryHighRiskData(RegNo As %Library.String = "", Name As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", TeamID As %Library.String = "", StationRowId As %Library.String = "", OrderDetailRowId As %Library.String = "", HighDiagnosisID As %Library.String = "") As %Query(ROWSPEC = "IADM:%String, RegNo:%String, PatName:%String,ARCIMDesc:%String,DetailDesc:%String, HighRiskItem:%String,NormalRange:%String,HighRiskDiagnosis:%String, ADMDate:%String,PatSex:%String,PatAge:%String,RLTRowID:%String")
{
}

ClassMethod QueryHighRiskDataExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", Name As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", TeamID As %Library.String = "", StationRowId As %Library.String = "", OrderDetailRowId As %Library.String = "", HighDiagnosisID As %Library.String = "") As %Status
{

  	s ind=1
  	Set repid=$I(^CacheTemp)
	i DateBegin=""  s DateBegin=+$H
	i DateEnd=""  s DateEnd=+$H
	if RegNo'="" d
	.s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	.s PIBIDR=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	.q:PIBIDR=""
	.s PreIADM=0
	.f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,PreIADM)) q:PreIADM=""  d
	..s IADMDR=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	..q:IADMDR=""
	..d GetHighRiskInfo
	else  if GroupDR'=""  d
	.s TeamDR=0
	.f  s TeamDR=$o(^DHCPEIADM(0,"GADM",GroupDR,TeamDR)) q:TeamDR=""  d
	..q:(TeamID'="")&&(TeamID'=TeamDR)
	..s IADMDR=0
	..f  s IADMDR=$o(^DHCPEIADM(0,"GADM",GroupDR,TeamDR,IADMDR)) q:IADMDR=""  d
	...d GetHighRiskInfo
	else  if Name'="" d
	.s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",Name),-1)
	.f  s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",PatNameIndex)) q:(PatNameIndex="")||(PatNameIndex'[Name)  d
	..s PIBIDR=0
	..f  s PIBIDR=$o(^DHCPEPreIBI(0,"Name",PatNameIndex,PIBIDR)) q:PIBIDR=""  d
	...s PreIADM=0
	...f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,PreIADM)) q:PreIADM=""  d
	....s IADMDR=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	....q:IADMDR=""
	....d GetHighRiskInfo
	else  d
	.s Date=DateBegin-1
	.f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date))  q:Date=""  d
	..s Time=0
	..f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time))  q:Time=""  d
	...s IADMDR=0
	...f  s IADMDR=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADMDR)) q:IADMDR=""  d
	....d GetHighRiskInfo

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetHighRiskInfo
	s PAADM=$P(^DHCPEIADM(IADMDR),"^",1)
	q:PAADM=""
	//d ##Class(web.DHCPE.TransResult).TransMain(PAADM)  
	s ^zl("PAADM",PAADM)=PAADM
	s PIADM=$P(^DHCPEIADM(IADMDR),"^",4)
	q:PIADM=""
	s GADM=$P(^DHCPEIADM(IADMDR),"^",2)
	s AdmDate=$P(^DHCPEIADM(IADMDR),"^",5)
	i AdmDate'="" s AdmDate=$zd(AdmDate,3)
	q:(GroupDR'="")&&(GroupDR'=GADM)
	s Team=$P(^DHCPEIADM(IADMDR),"^",3)
	q:(TeamID'="")&&(TeamID'=Team)
	q:PIADM=""
	s PIBIRowID=$P(^DHCPEPreIADM(PIADM),"^",1)
	q:PIBIRowID=""
	s PatRegNo=$p(^DHCPEPreIBI(PIBIRowID),"^",1)
	s PatName=$p(^DHCPEPreIBI(PIBIRowID),"^",2)
	q:(Name'="")&&(PatName'[Name)
	s Age=""
	s BOD=$p($g(^DHCPEPreIBI(PIBIRowID)),"^",4)
	i BOD'="" s Age=$P(##class(web.DHCLCNUREXCUTE).CalAge(BOD,+$H),"Y",1) //$P(##class(web.DHCLCNUREXCUTE))
	s SEX=$p($g(^DHCPEPreIBI(PIBIRowID)),"^",3)
	i SEX'="" s SEXDesc=$P(^CT("SEX",SEX),"^",2)
	s ResultStr="",HighRiskDiagnosis=""
	s RLTRowID=0 
	f  s RLTRowID=$o(^DHCPERLT("0","HighRiskFlag","Y","ADM",PAADM,RLTRowID)) Q:RLTRowID=""  d
	.//是否随访
	.s FollowUpFlag=$p($g(^DHCPERLT(RLTRowID)),"^",13)
	.q:FollowUpFlag'="Y"
 	.s Result=$p($g(^DHCPERLT(RLTRowID)),"^",4)
 	.s DetailID=$p($g(^DHCPERLT(RLTRowID)),"^",3)
 	.q:DetailID=""
 	.s DetailDesc=$p($G(^DHCPEST(+DetailID,"OD",$p(DetailID,"||",2))),"^",1)
 	.s CurrStation=$p(DetailID,"||",1)
	.q:(StationRowId'="")&&(StationRowId'=CurrStation)
 	.q:(OrderDetailRowId'="")&&(OrderDetailRowId'=DetailID)
 	.s ARCIMDR=$p($g(^DHCPERLT(RLTRowID)),"^",2)
 	.s ARCIMDesc=""
 	.i ARCIMDR'="" d
	.s ARCIMDesc=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",2) 
    .s NormalResult=##class(web.DHCPE.ResultEdit).GetNormal(DetailID,SEX,Age)
    .d PutOut
   q
PutOut      

	set Data=$lb(IADMDR,PatRegNo, PatName,ARCIMDesc,DetailDesc, Result,NormalResult, HighRiskDiagnosis,AdmDate,Age,SEX,RLTRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryHighRiskDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHighRiskDataExecute ]
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

ClassMethod QueryHighRiskDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHighRiskDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHighRiskDiagnosis(PAADM, HighDiagnosisID)
{
	
	
	Set IAdm=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	Quit:IAdm="" ""
	s GSRowID=$o(^DHCPEGS(0,"IADM",IAdm,0))
	q:GSRowID="" ""
	s GSDiagnosisStr=""
	s ChildSub=0
	f  s ChildSub=$o(^DHCPEGS(GSRowID,"Diagnosis",ChildSub)) q:ChildSub=""  d
	.s GSDRowID=GSRowID_"||"_ChildSub
	.s EDCRowID=$G(^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",GSDRowID))
	.q:EDCRowID=""
	.q:'$d(^DHCPEDataEx("DHCPEDiagnosisLevel",EDCRowID))   //诊断级别设置不需要预警退出
	.q:$G(^DHCPEDataEx("DHCPEDiagnosisLevel",EDCRowID))'="Y"
	.s EDDR=$p(^DHCPEGS(GSRowID,"Diagnosis",ChildSub),"^",1)
	.q:EDDR=""
	.q:(HighDiagnosisID'="")&&(HighDiagnosisID'=EDDR)
	.s DC=$P($G(^DHCPEED(EDDR,"1")),"^",1)
	.i GSDiagnosisStr="" s GSDiagnosisStr=DC
	.else  s GSDiagnosisStr=GSDiagnosisStr_","_DC
	q GSDiagnosisStr
}

// d ##class(web.DHCPE.HighRisk).GetHighRiskFlag("1702")

ClassMethod GetHighRiskFlag(RLTRowID) As %String
{
	
	s SQLCODE=0
	q:$g(RLTRowID)="" SQLCODE
	s EpisodeID=$p(^DHCPERLT(RLTRowID),"^",1)
	s curLoc=$P($G(^PAADM(EpisodeID)),"^",4)
	
	//s risStationStr="^"_$G(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	//s labStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	
	s risStationStr="^"_$G(^DHCPESetting("DHCPE","StationId_Ris",curLoc))_"^"
	s labStation=$G(^DHCPESetting("DHCPE","StationId_Lab",curLoc))

	s risStationStr=risStationStr_labStation_"^"
	s EpisodeID=$p(^DHCPERLT(RLTRowID),"^",1)
	s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	s sexStr=$P(ageSexStr,"^",2)
	s ageStr=$P(ageSexStr,"^",1)
	s Result=$p($G(^DHCPERLT(RLTRowID)),"^",4)
	s ODDR=$p($g(^DHCPERLT(RLTRowID)),"^",3)
	
	s RLTNormal=$p(^DHCPERLT(RLTRowID),"^",7)
	s OldHighRiskFlag=$p(^DHCPERLT(RLTRowID),"^",12)
	Q:(OldHighRiskFlag'="Y")&&(RLTNormal="1") SQLCODE
	q:ODDR="" SQLCODE
	s ItemType=$P($g(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2))),"^",2)
	s HighRiskFlag=0
	s ODSChildSub=0
	f  s ODSChildSub=$o(^DHCPEST(+ODDR,"OD", $p(ODDR,"||",2),"ODS",ODSChildSub)) q:(ODSChildSub="")||(HighRiskFlag=1)  d
	.s ODStandardID=ODDR_"||"_ODSChildSub
	.//不是危机值数据不参与对比
	.q:$D(^DHCPEDataEx("DHCPEODStandard","HighRiskFlag",ODStandardID))&&($G(^DHCPEDataEx("DHCPEODStandard","HighRiskFlag",ODStandardID)))
	.q:'$D(^DHCPEDataEx("DHCPEODStandard","HighRiskFlag",ODStandardID))
	.s curSex=$P(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2),"ODS",ODSChildSub),"^",1)
	.s curAgeMin=$P(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2),"ODS",ODSChildSub),"^",7)
	.s curAgeMax=$P(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2),"ODS",ODSChildSub),"^",8)
	.i curSex=""  s curSex="N"
	.q:(curSex'="N")&&(curSex'=sexStr)
	.q:(curAgeMin'="")&&(curAgeMin>ageStr)
	.q:(curAgeMax'="")&&(curAgeMax<ageStr)  
	.s Flag=1
	.If (ItemType="N")||(ItemType="C") Do 
	..s Min=$P(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2),"ODS",ODSChildSub),"^",4)
	..s Max=$P(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2),"ODS",ODSChildSub),"^",5)
	..i (Result["<")  s Result=$p(Result,"<",2)
	..i (Result[">")  s Result=$p(Result,">",2)
	..s:(Min'="")&&(+Result<Min) Flag=0
	..s:(Max'="")&&(+Result>Max) Flag=0
	.If (ItemType="T")||(ItemType="S") Do 
	..s standardText=$P(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2),"ODS",ODSChildSub),"^",2)
	..// 对于选择类型： 如果一个细项对应多个选择项结果，则没有与诊断关联的选择项，不标记
	..s:(Result'=standardText)&&(ItemType="S") Flag=0  
	..s:(Result'[standardText)&&(ItemType="T") Flag=0
	.i Flag=1  s HighRiskFlag=1
	.else  s HighRiskFlag=0
	.i HighRiskFlag="1"  d
	..&SQL(Update SQLUser.DHC_PE_Result set RLT_HighRiskFlag='Y',RLT_FollowUpFlag='Y'  Where RLT_RowId= :RLTRowID)
	.else  d
	..&SQL(Update SQLUser.DHC_PE_Result set RLT_HighRiskFlag='N',RLT_FollowUpFlag='N' Where RLT_RowId= :RLTRowID)

	q SQLCODE
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.HighRisk","HighRiskQuery","1542","")

Query HighRiskQuery(LocID As %String = "", HighRiskDesc As %String = "") As %SQLQuery(ROWSPEC = "THighRiskID:%String, THighRiskDesc:%String, THighRiskAdvice:%String")
{
 Select EDL_ParRef,EDL_ParRef->ED_DiagnoseConclusion,EDL_ParRef->ED_Detail 
 from Sqluser.DHC_PE_EDLoc
 where EDL_ParRef->ED_DiagnoseConclusion %STARTSWITH :HighRiskDesc
 		and EDL_Loc_DR=:LocID and EDL_ParRef->ED_HighRisk='Y'
}

Query QueryHighRisk(StartDate As %Library.String = "", EndDate As %Library.String = "", GroupID As %Library.String = "", HighRiskID As %Library.String = "", ODDR As %Library.String = "", ResultFlag As %Library.String = "") As %Query(ROWSPEC = "TRegNo:%String, TName:%String, TSex:%String,TTel:%String,THighRisk:%String, THadSendMessage:%String,TMessageTemplate:%String,TResult:%String, TSend:%String,TGroupDesc:%String,TID:%String,TDate:%String")
{
}

ClassMethod QueryHighRiskExecute(ByRef qHandle As %Binary, StartDate As %Library.String = "", EndDate As %Library.String = "", GroupID As %Library.String = "", HighRiskID As %Library.String = "", ODDR As %Library.String = "", ResultFlag As %Library.String = "") As %Status
{
	s ind=1
	set repid=$I(^CacheTemp)
	i ResultFlag'="" d
 	.s ResultFlag="Y"
  	e  d
  	.s ResultFlag="N"
  	i StartDate="" s StartDate=1
  	i EndDate="" s EndDate=+$H
  	
  	i ResultFlag="Y" d
  	.i GroupID'="" d
  	..s TeamDR=""
  	..f  s TeamDR=$O(^DHCPEIADM(0,"GADM",GroupID,TeamDR)) q:TeamDR=""  d
  	...s IADM=0
  	...f  s IADM=$O(^DHCPEIADM(0,"GADM",GroupID,TeamDR,IADM)) q:IADM=""  d
  	....s PAADM=$P(^DHCPEIADM(IADM),"^",1)
  	....q:PAADM=""
  	....s RltID=0
  	....f  s RltID=$O(^DHCPERLT(0,"HighRiskFlag","Y","ADM",PAADM,RltID)) q:RltID=""  d
  	.....d GetDataByResult
  	.e  d
  	..s Date=StartDate-1
  	..f  s Date=$O(^DHCPERLT(0,"DateADM",Date)) q:(Date="")||(Date>EndDate)  d
  	...f PAADM=""
  	...f  s PAADM=$O(^DHCPERLT(0,"DateADM",Date,PAADM)) q:PAADM=""  d
  	....s RltID=0
  	....f  s RltID=$O(^DHCPERLT(0,"DateADM",Date,PAADM,RltID)) q:RltID=""  d
  	.....d GetDataByResult
  	e  d
  	.i GroupID'="" d
  	..s TeamDR=""
  	..f  s TeamDR=$O(^DHCPEIADM(0,"GADM",GroupID,TeamDR)) q:TeamDR=""  d
  	...s IADM=0
  	...f  s IADM=$O(^DHCPEIADM(0,"GADM",GroupID,TeamDR,IADM)) q:IADM=""  d
  	....s PAADM=$P(^DHCPEIADM(IADM),"^",1)
  	....q:PAADM=""
  	....s HighRiskDR=0
  	....f  s HighRiskDR=$O(^User.DHCPEHighRiskResultI("PAAdmIndex",PAADM,HighRiskDR)) q:HighRiskDR=""  d
  	.....d GetDataByHighRiskDR
  	.e  d
  	..s Date=StartDate-1
  	..f  s Date=$O(^User.DHCPEHighRiskResultI("DateIndex",Date)) q:(Date="")||(Date>EndDate)  d
  	...s Time=0
  	...f  s Time=$O(^User.DHCPEHighRiskResultI("DateIndex",Date,Time)) q:(Time="")  d
  	....s HighRiskDR=0
  	....f  s HighRiskDR=$O(^User.DHCPEHighRiskResultI("DateIndex",Date,Time,HighRiskDR)) q:(HighRiskDR="")  d
 	.....d GetDataByHighRiskDR
 	set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetDataByHighRiskDR
	d ClearInfo
	s Adm=$LG(^User.DHCPEHighRiskResultD(HighRiskDR),2)
	s Flag=$LG(^User.DHCPEHighRiskResultD(HighRiskDR),5)
	q:Flag'="Y"
	s Info=##class(web.DHCPE.AdmRecordManager).GetBaseInfo(Adm)
	;PatName_"^"_Sex_"^"_Birth_"^"_IDCard_"^"_RegNo_"^"_Tel_"^"_Group
	s TRegNo=$P(Info,"^",5)
	s TName=$P(Info,"^",1)
	s TSex=$P(Info,"^",2)_"("_$P(Info,"^",3)_")"
	s TTel=$P(Info,"^",6)
	s TGroupDesc=$P(Info,"^",7)
	s THadSendMessage="0"
	i $D(^User.DHCPENewSendMessageI("TypeSourceIndex","HR",HighRiskDR)) d
	.s THadSendMessage="1"
	s TID=HighRiskDR_"^HR"
	
	s TDate=$LG(^User.DHCPEHighRiskResultD(HighRiskDR),7)
	q:TDate<StartDate
	q:TDate>EndDate
	s:TDate'="" TDate=$ZD(TDate,3)
	s THighRisk=""
	s HighRisk=$LG(^User.DHCPEHighRiskResultD(HighRiskDR),3)
	i HighRisk'="" d
	.s THighRisk=$P(^DHCPEED(HighRisk,1),"^",1)
	.s THighRisk=THighRisk_":"_$LG(^User.DHCPEHighRiskResultD(HighRiskDR),4)
	e  d
	.s THighRisk=$LG(^User.DHCPEHighRiskResultD(HighRiskDR),4)
	s TResult=""
	s Sub=0
	f  s Sub=$O(^User.DHCPEHighRiskResultD(HighRiskDR,"childDetail",Sub)) q:Sub=""  d
	.s RltID=$LG(^User.DHCPEHighRiskResultD(HighRiskDR,"childDetail",Sub),2)
	.s OrderDetailID=$P(^DHCPERLT(RltID),"^",3)
	.s OrderDetailDesc=$P(^DHCPEST(+OrderDetailID,"OD",$P(OrderDetailID,"||",2)),"^",1)
	.i TResult="" d
	..s TResult=OrderDetailDesc_":"_$P(^DHCPERLT(RltID),"^",4)
	.e  d
	..s TResult=TResult_";"_OrderDetailDesc_":"_$P(^DHCPERLT(RltID),"^",4)
	s:THadSendMessage="0" TSend="1"
	s:THadSendMessage="1" TSend="0"
	d PutOut2
	q
GetDataByResult
	d ClearInfo
	s Adm=$P(^DHCPERLT(RltID),"^",1)
	s HighRiskFlag=$P(^DHCPERLT(RltID),"^",12)
	q:HighRiskFlag'="Y"
	s Info=##class(web.DHCPE.AdmRecordManager).GetBaseInfo(Adm)
	;PatName_"^"_Sex_"^"_Birth_"^"_IDCard_"^"_RegNo_"^"_Tel_"^"_Group
	s TRegNo=$P(Info,"^",5)
	s TName=$P(Info,"^",1)
	s TSex=$P(Info,"^",2)_"("_$P(Info,"^",3)_")"
	s TTel=$P(Info,"^",6)
	s TGroupDesc=$P(Info,"^",7)
	s THadSendMessage="0"
	i $D(^User.DHCPENewSendMessageI("TypeSourceIndex","RR",RltID)) d
	.s THadSendMessage="1"
	s TID=RltID_"^RR"
	s OrderDetailID=$P(^DHCPERLT(RltID),"^",3)
	s OrderDetailDesc=$P(^DHCPEST(+OrderDetailID,"OD",$P(OrderDetailID,"||",2)),"^",1)
	s TResult=OrderDetailDesc_":"_$P(^DHCPERLT(RltID),"^",4)
	s TDate=$P(^DHCPERLT(RltID),"^",6)
	q:TDate<StartDate
	q:TDate>EndDate
	s:TDate'="" TDate=$ZD(TDate,3)
	
	s THighRisk=""
	i $D(^User.DHCPEHighRiskDetailI("ResultDRIndex",RltID)) d
	.s HighRiskDR=$O(^User.DHCPEHighRiskDetailI("ResultDRIndex",RltID,0))
	.s HighRisk=$LG(^User.DHCPEHighRiskResultD(HighRiskDR),3)
	.s Flag=$LG(^User.DHCPEHighRiskResultD(HighRiskDR),5)
	.q:Flag="N"
	.i HighRisk'="" d
	..s THighRisk=$P(^DHCPEED(HighRisk,1),"^",1)
	..s THighRisk=THighRisk_":"_$LG(^User.DHCPEHighRiskResultD(HighRiskDR),4)
	.e  d
	..s THighRisk=$LG(^User.DHCPEHighRiskResultD(HighRiskDR),4)
	s:THadSendMessage="0" TSend="1"
	s:THadSendMessage="1" TSend="0"
	d PutOut2
	q
ClearInfo
	s (TRegNo, TName, TSex,TTel,THighRisk, THadSendMessage,TMessageTemplate,TResult, TSend,TGroupDesc,TID,TDate)=""
	q
PutOut2     
	s TMessageTemplate="尊敬的"_TName_"您好:"
	s:TResult'="" TMessageTemplate=TMessageTemplate_"您本次体检存在如下危险数据,"_TResult_"."
	s:THighRisk'="" TMessageTemplate=TMessageTemplate_"建议您,"_THighRisk
	
	set Data=$lb(TRegNo, TName, TSex,TTel,THighRisk, THadSendMessage,TMessageTemplate,TResult, TSend,TGroupDesc,TID,TDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryHighRiskFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHighRiskExecute ]
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

ClassMethod QueryHighRiskClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHighRiskExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
