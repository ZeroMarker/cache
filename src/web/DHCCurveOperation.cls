/// 产程图
Class web.DHCCurveOperation Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 产时记录打印表格内容
/// d ##class(%ResultSet).RunQuery("web.DHCCurveOperation","GetPrintRec","521")
ClassMethod GetPrintRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Episode=$P(parr,"!",1)
 	k TMPRECPRINT
 	Set rw="" For  Set rw=$O(^Nur.DHCNURPregRecI("Adm"," "_Episode,rw)) Quit:rw=""  Do
 	.s a=##class(Nur.DHCNURPregRec).%OpenId(rw)
 	.s birthMark=a.DHCPregComment
 	.q:birthMark="Y"
 	.s recDate=a.DHCPregDate
 	.s recTime=a.DHCPregTime
 	.s recDateTime=$zd(recDate,3)_" "_$zt(recTime,2)
 	.s recDate=$zd(recDate,3)
 	.s recTime=$zt(recTime,2)
 	.s blood=a.DHCPregBlood
 	.s puls=a.DHCPregPuls
 	.s method=a.DHCPregMethod
 	.s fetalHeart=a.DHCPregFetalHeart
 	.s frequency=a.DHCPregFrequency
 	.s pipe=a.DHCPregPipe
 	.s wombwidth=a.DHCPregWombwidth
 	.s membrane=a.DHCPregMembrane
 	.s position=a.DHCPregPosition
 	.s firstsight=a.DHCPregFirstSight
 	.s prorpv=a.DHCPregPRorPV
 	.s userid=a.DHCPregUserID  
 	.s exception=a.DHCPregException
 	.s handle=a.DHCPregHandle   
 	.s user=userid
 	.s:$d(^SSU("SSUSR",userid)) user=$P(^SSU("SSUSR",userid),"^",2)
 	.s aa="RecDateTime|"_recDateTime_"^RecDate|"_recDate_"^RecTime|"_recTime_"^Blood|"_blood_"^Puls|"_puls_"^Method|"_method_"^FetalHeart|"_fetalHeart
 	.s aa=aa_"^Frequency|"_frequency_"^Wombwidth|"_wombwidth_"^Pipe|"_pipe_"^Membrane|"_membrane_"^Position|"_position_"^Exception|"_exception_"^Handle|"_handle
 	.s aa=aa_"^FirstSight|"_firstsight_"^PRorPV|"_prorpv_"^User|"_user
 	.s TMPRECPRINT(recDate,recTime)=aa
 	
 	s date="" f  s date=$o(TMPRECPRINT(date)) q:date=""  d
 	.s time="" f  s time=$o(TMPRECPRINT(date,time)) q:time=""  d
 	..s aa=TMPRECPRINT(date,time)
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowtyp
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPrintRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintRecExecute ]
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

ClassMethod GetPrintRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPrintRec(parr1 As %String) As %Query(ROWSPEC = "aa")
{
}

/// 检查是否存在宫缩时间
ClassMethod HasContraDateTime(EpisodeID As %String) As %String
{
	q:$g(EpisodeID)="" 0
	Set rw=$O(^Nur.DHCNurCurveI("Adm"," "_EpisodeID,""))
	q:rw="" 0
	Set a=##class(Nur.DHCNurCurve).%OpenId(rw)
	Set date=a.DHCCurveContraDate
	q:date="" 0
	q 1
}

/// 按登记号查找患者
ClassMethod PatientEpsoides(input As %String) As %String
{
	//w ##class(web.DHCCurveOperation).PatientEpsoides("<Request><PatNo>0000000046</PatNo></Request>")
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.PatientList).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set PatNo=myCurveObj.PatNo
	Quit:PatNo="" "<Response><ResultCode>"_1_"</ResultCode><ErrorMsg>登记号不能为空</ErrorMsg></Response>"
     s PapmiRow=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	Quit:PapmiRow="" "<Response><ResultCode>"_1_"</ResultCode><ErrorMsg>登记号不存在</ErrorMsg></Response>"
	 s EPRowid=$o(^PAPERdr(PapmiRow,"ADM","I",""))
	Quit:EPRowid="" "<Response><ResultCode>"_1_"</ResultCode><ErrorMsg>无住院记录</ErrorMsg></Response>"
	Set XmlStr="<Response><ResultCode>"_0_"</ResultCode><ErrorMsg></ErrorMsg>"
	Set PatName=$P(^PAPER(PapmiRow,"ALL"),"^",1)
	s episode="" f  s episode=$o(^PAPERdr(PapmiRow,"ADM","I",episode)) q:episode=""  d
	.Set PapmiDr=$P(^PAADM(episode),"^",1)
	.s motherAdm=$P(^PAADM(episode),"^",75)
	.q:motherAdm'=""
	.Set AdmDate=$P($g(^PAADM(episode)),"^",6)         //入院日期
	.Set DepCodeDR=$P($G(^PAADM(episode)),"^",4)
	.q:DepCodeDR=""
	.b //1
	.Set DepCode=$P($G(^CTLOC(DepCodeDR)),"^",1)
	.Set TMP(AdmDate)=DepCode_"^"_episode_"^"_$ZD(AdmDate,3)
	b //2
	Set rw="" For  Set rw=$O(TMP(rw)) Quit:rw=""  do
	.Set DepCode=$P(TMP(rw),"^",1)                    //就诊科室
	.Set Episode=$P(TMP(rw),"^",2)                    //病人就诊号
	.Set admDate=$P(TMP(rw),"^",3)                     //就诊日期
	.Set PatNo=PatNo                   //病人登记号
	.Set Name=PatName                  //病人姓名
	.Set BedDr=$P($P($G(^PAADM(Episode)),"^",73),"||",2)
	.q:BedDr=""
	.Set BedCode=$P($G(^PAWARD(+BedDr,"BED",BedDr)),"^",1)
	.Set XmlStr=XmlStr_"<PatInfo><BedCode>"_BedCode_"</BedCode><PatName>"_Name_"</PatName><Episode>"_Episode_"</Episode><PatNo>"_PatNo_"</PatNo><PatAge></PatAge></PatInfo>"
    Set XmlStr=XmlStr_"</Response>"
    Quit XmlStr
}

// 根据日期选择打印

/// 病区所有患者
ClassMethod PatientList(input As %String) As %String
{
	//w ##class(web.DHCCurveOperation).PatientList("<Request><CTLocId>20</CTLocId></Request>")
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.PatientList).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set CTLocId=myCurveObj.CTLocId
	Quit:CTLocId="" "<Response><ResultCode>"_1_"</ResultCode><ErrorMsg>科室ID不能为空</ErrorMsg></Response>"
	s locType=$p($g(^CTLOC(CTLocId)),"^",13)
	i (locType'="W") {		
		s num=0
		i locType="E" d   //科室为医生科室,获取关联的病区
		.s sub=0 f  s sub=$O(^CTLOC(CTLocId,"LINK",sub)) q:sub=""  d
		..s linkLocID=$P(^CTLOC(CTLocId,"LINK",sub),"^",1)
		..s linkLocType=$p($g(^CTLOC(linkLocID)),"^",13)
		..q:linkLocType'="W"
		..s linkWardID=$o(^PAWARD(0,"WARD_LocationDR",linkLocID,0))
		..q:linkWardID=""
		..s WardId=linkWardID
		..d getPatInfo
	}
	else{
		Set WardId=$O(^PAWARD(0,"WARD_LocationDR",CTLocId,""))
		Quit:WardId="" "<Response><ResultCode>"_1_"</ResultCode><ErrorMsg>没有找到科室对应的病区</ErrorMsg></Response>"
		d getPatInfo
	}	
	Set XmlStr="<Response><ResultCode>"_0_"</ResultCode><ErrorMsg></ErrorMsg>"
	s XmlStr=XmlStr_"<CTLocCode>"_$p(^CTLOC(CTLocId),"^",2)_"</CTLocCode>"
	
	Set rw="" For  Set rw=$O(Bed(rw)) Quit:rw=""  do
	.Set y="" For  Set y=$O(Bed(rw,y)) q:y=""  do
	..Set x="" For  Set x=$O(Bed(rw,y,x)) q:x=""  do
	...Set BedCode=$P(Bed(rw,y,x),"^",1)                    //床号
	...Set Name=$P(Bed(rw,y,x),"^",2)                       //病人姓名
	...Set Episode=$P(Bed(rw,y,x),"^",3)                    //病人就诊号
	...Set PatNo=$P(Bed(rw,y,x),"^",4)                      //病人登记号
	...Set PatAge=$P(Bed(rw,y,x),"^",5)                     //病人年龄
	...Set XmlStr=XmlStr_"<PatInfo><BedCode>"_BedCode_"</BedCode><PatName>"_Name_"</PatName><Episode>"_Episode_"</Episode><PatNo>"_PatNo_"</PatNo><PatAge>"_PatAge_"</PatAge></PatInfo>"
    Set XmlStr=XmlStr_"</Response>"
    Quit XmlStr
getPatInfo
	Set RoomDr="" For  Set RoomDr=$O(^PAADMi("CurrWard",WardId,RoomDr)) Quit:RoomDr=""  do
	.Set Episode="" For  Set Episode=$O(^PAADMi("CurrWard",WardId,RoomDr,Episode)) Quit:Episode=""  do
	..Set VistStatus=$P(^PAADM(Episode),"^",20)
	..Quit:VistStatus="D"
	..Set PapmiDr=$P(^PAADM(Episode),"^",1)
	..s motherAdm=$P(^PAADM(Episode),"^",75)
	..q:motherAdm'=""
	..s papmiId=+$g(^PAADM(Episode))
    ..q:papmiId=""
	..s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	..q:sex'="女"
	..Set PatName=$P(^PAPER(PapmiDr,"ALL"),"^",1)
	..Set PatNo=$P(^PAPER(PapmiDr,"PAT",1),"^",1) 
    ..Set IBirth=$P($g(^PAPER(PapmiDr,"ALL")),"^",6)
	..Set AdmDate=$P($g(^PAADM(Episode)),"^",6)         //入院日期
	..;Set PatAge=..CalAge(IBirth,AdmDate) 
	..s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PapmiDr,Episode)
	..q:(+PatAge=0)                           
	..Set BedDr=$P($G(^PAADM(Episode)),"^",73) ;$P(,"||",2)
	..q:BedDr=""
	..Set BedCode=$P($G(^PAWARD(+BedDr,"BED",$P(BedDr,"||",2))),"^",1)
	..s x=$p($g(^PAWARD(WardId,"BED",BedDr)),"^",15)
    ..s y=$p($g(^PAWARD(WardId,"BED",BedDr)),"^",16)
    ..s:x="" x=" "_BedDr
    ..s:y="" y=" "_WardId
    ..s Bed(WardId,y,x)=BedCode_"^"_PatName_"^"_Episode_"^"_PatNo_"^"_PatAge
    
    s pregnancyID="" f  s pregnancyID=$o(^PAPRGi("DEL_DeliveryRoom",CTLocId,pregnancyID)) q:pregnancyID=""  d
	.s sub=0 f  s sub=$o(^PAPRGi("DEL_DeliveryRoom",CTLocId,pregnancyID,"DEL",sub)) q:sub=""  d
	..s Episode=$p($g(^PAPRG(pregnancyID,"DEL",sub)),"^",1)
	..Set VistStatus=$P(^PAADM(Episode),"^",20)
	..Quit:VistStatus="D"
	..Set PapmiDr=$P(^PAADM(Episode),"^",1)
	..s motherAdm=$P(^PAADM(Episode),"^",75)
	..q:motherAdm'=""
	..s papmiId=+$g(^PAADM(Episode))
    ..q:papmiId=""
	..s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	..q:sex'="女"
	..Set PatName=$P(^PAPER(PapmiDr,"ALL"),"^",1)
	..Set PatNo=$P(^PAPER(PapmiDr,"PAT",1),"^",1) 
    ..Set IBirth=$P($g(^PAPER(PapmiDr,"ALL")),"^",6)
	..Set AdmDate=$P($g(^PAADM(Episode)),"^",6)         //入院日期
	..;Set PatAge=..CalAge(IBirth,AdmDate) 
	..s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PapmiDr,Episode)
	..q:(+PatAge=0)                           
	..Set BedDr=$P($G(^PAADM(Episode)),"^",73) ;$P(,"||",2)
	..q:BedDr=""
	..Set BedCode=$P($G(^PAWARD(+BedDr,"BED",$P(BedDr,"||",2))),"^",1)
	..s x=$p($g(^PAWARD(WardId,"BED",BedDr)),"^",15)
    ..s y=$p($g(^PAWARD(WardId,"BED",BedDr)),"^",16)
    ..s:x="" x=" "_BedDr
    ..s:y="" y=" "_WardId
    ..s Bed(WardId,y,x)=BedCode_"^"_PatName_"^"_Episode_"^"_PatNo_"^"_PatAge
	q
}

ClassMethod GetContraDT(Episode) As %String
{
	s ret=""
	Set rw=$O(^Nur.DHCNurCurveI("Adm"," "_Episode,""))  
	If rw'="" d                 //有产程基本信息
	.Set a=##class(Nur.DHCNurCurve).%OpenId(rw)
	.s ret=a.DHCCurveContraDate_"^"_a.DHCCurveContraTime 
	q ret
}

ClassMethod GetPatInfo(Episode) As %String
{
	//w ##class(web.DHCCurveOperation).GetPatInfo(11)
	Set PapmiDr=$P(^PAADM(Episode),"^",1)
	Set PatName=$P(^PAPER(PapmiDr,"ALL"),"^",1)
	Set PatNo=$P(^PAPER(PapmiDr,"PAT",1),"^",1) 
    Set IBirth=$P($g(^PAPER(PapmiDr,"ALL")),"^",6)
	Set AdmDate=$P($g(^PAADM(Episode)),"^",6)         //入院日期
	;Set PatAge=..CalAge(IBirth,AdmDate)  
	Set PatAge=##class(web.DHCBillInterface).GetPapmiAge(PapmiDr,Episode) 
	Set rw=$O(^Nur.DHCNurCurveI("Adm"," "_Episode,""))  
	If rw'="" d                 //有产程基本信息
	.Set a=##class(Nur.DHCNurCurve).%OpenId(rw)
	.s pregCount=a.DHCCurvePregnancy
	.s birthCount=a.BirthCount
	.i a.DHCCurveContraDate'="" d
	..s contrastartDate=$zd(a.DHCCurveContraDate,3)
	..s contrastartTime=$zt(a.DHCCurveContraTime,1) 
	..s contrastartStr=$p(contrastartDate,"-",1)_"年"_$p(contrastartDate,"-",2)_"月"_$p(contrastartDate,"-",3)_"日  "_$p(contrastartTime,":",1)_"时"_$p(contrastartTime,":",2)_"分"
	.i a.PlacentaOutDate'="" d
	..s span=a.PlacentaOutDate*86400+a.PlacentaOutTime-(a.DHCCurveContraDate*86400)-a.DHCCurveContraTime
	..s spanHour=span\3600
	..s spanMinute=(span#3600)\60
	..s birthSpan=spanHour_"小时"_spanMinute_"分"
	.Set rw=$O(^Nur.DHCNURPregRecI("Adm"," "_Episode,"")) 
	.if rw'=""  d 
	..Set PregDate=$zd($List(^Nur.DHCNURPregRecD(rw),3),3)
	..s RecStartDate=$p(PregDate,"-",1)_"年"_$p(PregDate,"-",2)_"月"_$p(PregDate,"-",3)_"日"
     s Bah=##class(web.DHCWMRService).IGetMrNoByEpisodeID(Episode)
     ;i $g(Bah)="" s Bah= $P(^PAPER(PapmiDr,"PAT",3),"^",4) 
     s PatName="姓名:"_PatName_"   年龄:"_PatAge_"   孕产次:"_$g(pregCount)_"孕"_$g(birthCount)_"产"
     s CurrHosp = ..GetHospital(Episode)
     q "Bah|"_Bah_"^PatName|"_PatName_"^contraDate|"_$g(contrastartStr)_"^BirthSpan|"_$g(birthSpan)_"^RecDate|"_$g(RecStartDate)_"^HOSP|"_$g(CurrHosp)
}

/// 产时记录表基本信息
ClassMethod GetRecTitle(Episode) As %String
{
	//w ##class(web.DHCCurveOperation).GetPatInfo(11)
	Set PapmiDr=$P(^PAADM(Episode),"^",1)
	Set PatName=$P(^PAPER(PapmiDr,"ALL"),"^",1)
	Set PatNo=$P(^PAPER(PapmiDr,"PAT",1),"^",1) 
    Set IBirth=$P($g(^PAPER(PapmiDr,"ALL")),"^",6)
	Set AdmDate=$P($g(^PAADM(Episode)),"^",6)         //入院日期
	;Set PatAge=..CalAge(IBirth,AdmDate)  
	Set PatAge=##class(web.DHCBillInterface).GetPapmiAge(PapmiDr,Episode)
	s PatInfo="姓名:"_PatName_"  年龄:"_PatAge
	s BirthPredict="预产期:"
	Set rw=$O(^Nur.DHCNurCurveI("Adm"," "_Episode,""))  
	If rw'="" d                 //有产程基本信息
	.Set a=##class(Nur.DHCNurCurve).%OpenId(rw)
	.s pregCount=a.DHCCurvePregnancy
	.s birthCount=a.BirthCount
	.s PatInfo=PatInfo_"   孕次:"_pregCount_"  产次:"_birthCount
	.s birthPredictdate=a.PredictPreg
	.s year=$P(birthPredictdate,"-",1)
	.s month=$P(birthPredictdate,"-",2)
	.s day=$P(birthPredictdate,"-",3)
	.i $ISVALIDNUM(year)=1 d
	 ..i year'=""  s BirthPredict=BirthPredict_year_"年 "
	 ..i month'=""  s BirthPredict=BirthPredict_month_"月 "
	 ..i day'=""  s BirthPredict=BirthPredict_day_"日"
	.e  s BirthPredict=BirthPredict_birthPredictdate
	
	s Bah=##class(web.DHCWMRService).IGetMrNoByEpisodeID(Episode)
	i $g(Bah)="" s Bah= $P(^PAPER(PapmiDr,"PAT",3),"^",4) 
	
	s CurrHosp = ..GetHospital(Episode)
    q "Bah@病案号:"_Bah_"^PatInfo@"_PatInfo_"^BirthPredict@"_BirthPredict_"^HOSP@"_CurrHosp
}

ClassMethod GetHospital(Episode) As %String
{
	q:Episode="" ""
	s CurrHosp =""
	s PAADMDepCodeDR = $p($g(^PAADM(Episode)),"^",4)
	i PAADMDepCodeDR '= "" d 
	.S CurrHospDR = $p($g(^CTLOC(PAADMDepCodeDR)),"^",22)
	.s CurrHosp = $p($g(^CT("HOSP",CurrHospDR)),"^",2)
	q CurrHosp
}

ClassMethod CalAge(IBirth, IToday) As %String
{
	n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
	Set IBirth=$G(IBirth),IToday=$G(IToday)
	If IBirth>2980000 Set IBirth=""
	If IBirth<0 Set IBirth=""
	Quit:'$G(IBirth) ""
	Set XBirth=$ZD(IBirth)
	Set XToday=$ZD(IToday)
	Set AgeMth=XToday-XBirth
	Set AgeDay=$P(XToday,"/",2)-$P(XBirth,"/",2)
	Set CurrYear=$P(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
	Set BirthYear=$P(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
	Set AgeYear=CurrYear-BirthYear
	If AgeDay<0 do
	.Set AgeMth=AgeMth-1
	.Set AgeDay=AgeDay+$P("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	.Quit:XToday'=2
	.Set:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	If AgeMth<0 Set AgeMth=AgeMth+12,AgeYear=AgeYear-1
	If AgeYear'=0 Set ret=AgeYear_"岁"
	If (AgeYear=0)&&(AgeMth'=0) Set ret=AgeMth_"月"
	If (AgeYear=0)&&(AgeMth=0) Set ret=AgeDay_"日"
	Quit ret
}

/// 读病人产程基本信息（右上）
ClassMethod GetPatPregnancy(input) As %String
{
	//w ##class(web.DHCCurveOperation).GetPatPregnancy("<Request><Episode>5160058</Episode></Request>")
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.GetPatPregnancy).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set Episode=myCurveObj.Episode
	Set XmlStr="<Response><ResultCode>"_1_"</ResultCode><ErrorMsg></ErrorMsg>"
	Set rw="" For  Set rw=$O(^Nur.DHCNurCurveI("Adm"," "_Episode,rw)) Quit:rw=""  do
	.s a=##class(Nur.DHCNurCurve).%OpenId(rw)
	.Set Pregnancy=a.DHCCurvePregnancy
	.Set ContraDate=a.DHCCurveContraDate
	.Set ContraTime=a.DHCCurveContraTime
	.s BirthDate=a.BirthDate
	.s BirthTime=a.BirthTime
	.i BirthDate'="" s BirthDate=$ZD(BirthDate,3)
	.i BirthTime'="" s BirthTime=$ZT(BirthTime,1)
	.s BirthCount=a.BirthCount
	.s PredictDate=a.PredictPreg
	.s PlacentaOutDate=a.PlacentaOutDate
	.s PlacentaOutTime=a.PlacentaOutTime
	.i PlacentaOutDate'="" s PlacentaOutDate=$ZD(PlacentaOutDate,3)
	.i PlacentaOutTime'="" s PlacentaOutTime=$ZT(PlacentaOutTime,1)
	.Set XmlStr="<Response><ResultCode>"_0_"</ResultCode><ErrorMsg></ErrorMsg><Pregnancy>"_Pregnancy_"</Pregnancy><ContraDateTime>"_$ZD(ContraDate,3)_" "_$ZT(ContraTime,1)_"</ContraDateTime><BirthDateTime>"_BirthDate_" "_BirthTime_"</BirthDateTime><PlacentaOut>"_PlacentaOutDate_" "_PlacentaOutTime _"</PlacentaOut><PredictDate>"_PredictDate_"</PredictDate><BirthCount>"_BirthCount_"</BirthCount>"
    Set XmlStr=XmlStr_"</Response>"
    Quit XmlStr
}

/// 保存病人产程基本信息（右上）
ClassMethod SavePatCurve(input) As %String
{
	//d ##class(web.DHCCurveOperation).SavePatCurve("<Request><Episode>5628769</Episode><Pregnancy>1</Pregnancy><ContraDateTime>2013-9-23 21:51</ContraDateTime><UserID>3502</UserID><BirthDateTime> </BirthDateTime><BirthCount>1</BirthCount><PredictPreg></PredictPreg><PlacentaOut>2013-9-24</PlacentaOut></Request>")
	s ^lf(111)=input
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.SavePatCurve).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set Episode=myCurveObj.Episode
	Set Pregnancy=myCurveObj.Pregnancy
	Set ContraDateTime=myCurveObj.ContraDateTime
	Set UserID=myCurveObj.UserID
	Set BirthDateTime=myCurveObj.BirthDateTime
	Set BirthCount=myCurveObj.BirthCount
	set PredictDate=myCurveObj.PredictPreg
	set PlacentaOut=myCurveObj.PlacentaOut
	set result=..CompareDateTime(myCurveObj.ContraDateTime,myCurveObj.PlacentaOut)
	If result="1"
	{
		Set Msg="保存失败:宫缩开始时间必须小于胎盘娩出时间"
		Set XmlStr="<Response><ResultCode>"_result_"</ResultCode><ErrorMsg>"_Msg_"</ErrorMsg></Response>"
	Quit XmlStr
		}
	Set ret=##Class(Nur.DHCNurCurve).Save(Episode,Pregnancy,ContraDateTime,UserID,BirthCount,BirthDateTime,PredictDate,PlacentaOut)
	If ret=0 Set Msg="保存成功"
	Else  Set Msg="保存失败"
	Set XmlStr="<Response><ResultCode>"_ret_"</ResultCode><ErrorMsg>"_Msg_"</ErrorMsg></Response>"
	Quit XmlStr
}

/// 保存病人表格记录（右下）
ClassMethod SavePatContration(input) As %String
{
	//保存行记录
	// w ##class(web.DHCCurveOperation).SavePatContration("<Request><Value>PregMethod|^PregUserID|26</Value><Episode>11</Episode></Request>")
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.SavePatContration).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set Value=myCurveObj.Value
	Set Episode=myCurveObj.Episode
	Set ret=##Class(Nur.DHCNURPregRec).Save(Value,Episode)
	If ret=0 Set Msg=""
	Else  Set Msg="id"
	s PregDr=$p(ret,"^",1)
	s UserName=$p(ret,"^",2)
	Set XmlStr="<Response><ResultCode>"_PregDr_"</ResultCode><UserName>"_UserName_"</UserName><ErrorMsg>"_Msg_"</ErrorMsg></Response>"
	Quit XmlStr
}

/// 取病人表格记录（右下）
ClassMethod GetPatCurveBak(input) As %String
{
	//取行记录
	//d ##class(web.DHCCurveOperation).GetPatCurve("<Request><Episode>5593823</Episode></Request>")
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.GetPatCurve).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set Episode=myCurveObj.Episode
	
	Set rw1="" For  Set rw1=$O(^Nur.DHCNURPregRecI("Adm"," "_Episode,rw1)) Quit:rw1=""  Do
	.b //for
	.Set PregDate=$List(^Nur.DHCNURPregRecD(rw1),3)
	.Set PregTime=$List(^Nur.DHCNURPregRecD(rw1),4)
	.;q:(PregDate="")||(PregTime="")
	.Set Blood=$List(^Nur.DHCNURPregRecD(rw1),5)
	.Set Puls=$List(^Nur.DHCNURPregRecD(rw1),6)
	.Set Method=$List(^Nur.DHCNURPregRecD(rw1),7)
	.Set FetalHeart=$List(^Nur.DHCNURPregRecD(rw1),8)
	.Set Frequency=$List(^Nur.DHCNURPregRecD(rw1),9)
	.Set Pipe=$List(^Nur.DHCNURPregRecD(rw1),10)
	.Set Wombwidth=$List(^Nur.DHCNURPregRecD(rw1),11)
	.Set Membrane=$List(^Nur.DHCNURPregRecD(rw1),12)
	.Set Position=$List(^Nur.DHCNURPregRecD(rw1),13)
	.Set FirstSight=$List(^Nur.DHCNURPregRecD(rw1),14)
	.Set PRorPV=$List(^Nur.DHCNURPregRecD(rw1),15)
	.Set Exception=$List(^Nur.DHCNURPregRecD(rw1),16)
	.Set Handle=$List(^Nur.DHCNURPregRecD(rw1),17)
	.Set UserID=$List(^Nur.DHCNURPregRecD(rw1),18)
	.s UserID=..GetUserName(UserID)
	.Set Comment=$List(^Nur.DHCNURPregRecD(rw1),19)
	.b //2
	.Set TMPContration(PregDate,PregTime)=Blood_"^"_Puls_"^"_Method_"^"_FetalHeart_"^"_Frequency_"^"_Pipe_"^"_Wombwidth_"^"_Membrane_"^"_Position_"^"_FirstSight_"^"_PRorPV_"^"_Exception_"^"_Handle_"^"_UserID_"^"_Comment_"^"_rw1
	b //TMPContration
	Set XmlStr="<Response><ResultCode>"_0_"</ResultCode><ErrorMsg></ErrorMsg>"
	Set d="" For  Set d=$O(TMPContration(d)) Quit:d=""  do
	.Set t="" For  Set t=$O(TMPContration(d,t))  Quit:t=""  do
	..Set Date=$ZD(d,3)
	..Set Time=$ZT(t,2)
	..s tempData=TMPContration(d,t)
	..Set Blood=$p(tempData,"^",1)
	..Set Puls=$p(tempData,"^",2)
	..Set Method=$p(tempData,"^",3)
	..Set FetalHeart=$p(tempData,"^",4)
	..Set Frequency=$p(tempData,"^",5)
	..Set Pipe=$p(tempData,"^",6)
	..Set Wombwidth=$p(tempData,"^",7)
	..Set Membrane=$p(tempData,"^",8)
	..Set Position=$p(tempData,"^",9)
	..Set FirstSight=$p(tempData,"^",10)
	..Set PRorPV=$p(tempData,"^",11)
	..Set Exception=$p(tempData,"^",12)
	..Set Handle=$p(tempData,"^",13)
	..Set UserID=$p(tempData,"^",14)
	..Set Comment=$p(tempData,"^",15)
	..Set PregDr=$p(tempData,"^",16)
	..Set XmlStr=XmlStr_"<Contration><PregDateTime>"_Date_" "_Time_"</PregDateTime><PregDate>"_Date_"</PregDate><PregTime>"_Time_"</PregTime><PregComment>"_Comment_"</PregComment><PregBlood>"_Blood_"</PregBlood><PregPuls>"_Puls_"</PregPuls><PregMethod>"_Method_"</PregMethod><PregFetalHeart>"_FetalHeart_"</PregFetalHeart><PregFrequency>"_Frequency_"</PregFrequency><PregPipe>"_Pipe_"</PregPipe><PregWombwidth>"_Wombwidth_"</PregWombwidth><PregMembrane>"_Membrane_"</PregMembrane><PregPosition>"_Position_"</PregPosition><PregFirstSight>"_FirstSight_"</PregFirstSight><PregPRorPV>"_PRorPV_"</PregPRorPV><PregException>"_Exception_"</PregException><PregHandle>"_Handle_"</PregHandle><PregUserID>"_UserID_"</PregUserID><PregDr>"_PregDr_"</PregDr></Contration>"
	Set XmlStr=XmlStr_"</Response>"
    Quit XmlStr
}

/// update 20180920 改成流返回避免超长报错
/// 取病人表格记录（右下）
ClassMethod GetPatCurve(input) As %GlobalCharacterStream
{
	//取行记录
	//d ##class(web.DHCCurveOperation).GetPatCurve("<Request><Episode>5593823</Episode></Request>")
	s ret=##class(%GlobalCharacterStream).%New()
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.GetPatCurve).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set Episode=myCurveObj.Episode
	
	Set rw1="" For  Set rw1=$O(^Nur.DHCNURPregRecI("Adm"," "_Episode,rw1)) Quit:rw1=""  Do
	.b //for
	.Set PregDate=$List(^Nur.DHCNURPregRecD(rw1),3)
	.Set PregTime=$List(^Nur.DHCNURPregRecD(rw1),4)
	.;q:(PregDate="")||(PregTime="")
	.Set Blood=$List(^Nur.DHCNURPregRecD(rw1),5)
	.Set Puls=$List(^Nur.DHCNURPregRecD(rw1),6)
	.Set Method=$List(^Nur.DHCNURPregRecD(rw1),7)
	.Set FetalHeart=$List(^Nur.DHCNURPregRecD(rw1),8)
	.Set Frequency=$List(^Nur.DHCNURPregRecD(rw1),9)
	.Set Pipe=$List(^Nur.DHCNURPregRecD(rw1),10)
	.Set Wombwidth=$List(^Nur.DHCNURPregRecD(rw1),11)
	.Set Membrane=$List(^Nur.DHCNURPregRecD(rw1),12)
	.Set Position=$List(^Nur.DHCNURPregRecD(rw1),13)
	.Set FirstSight=$List(^Nur.DHCNURPregRecD(rw1),14)
	.Set PRorPV=$List(^Nur.DHCNURPregRecD(rw1),15)
	.Set Exception=$List(^Nur.DHCNURPregRecD(rw1),16)
	.Set Handle=$List(^Nur.DHCNURPregRecD(rw1),17)
	.Set UserID=$List(^Nur.DHCNURPregRecD(rw1),18)
	.s UserID=..GetUserName(UserID)
	.Set Comment=$List(^Nur.DHCNURPregRecD(rw1),19)
	.b //2
	.Set TMPContration(PregDate,PregTime)=Blood_"^"_Puls_"^"_Method_"^"_FetalHeart_"^"_Frequency_"^"_Pipe_"^"_Wombwidth_"^"_Membrane_"^"_Position_"^"_FirstSight_"^"_PRorPV_"^"_Exception_"^"_Handle_"^"_UserID_"^"_Comment_"^"_rw1
	b //TMPContration
	d ret.Write("<Response><ResultCode>"_0_"</ResultCode><ErrorMsg></ErrorMsg>")
	Set d="" For  Set d=$O(TMPContration(d)) Quit:d=""  do
	.Set t="" For  Set t=$O(TMPContration(d,t))  Quit:t=""  do
	..Set Date=$ZD(d,3)
	..Set Time=$ZT(t,2)
	..s tempData=TMPContration(d,t)
	..Set Blood=$p(tempData,"^",1)
	..Set Puls=$p(tempData,"^",2)
	..Set Method=$p(tempData,"^",3)
	..Set FetalHeart=$p(tempData,"^",4)
	..Set Frequency=$p(tempData,"^",5)
	..Set Pipe=$p(tempData,"^",6)
	..Set Wombwidth=$p(tempData,"^",7)
	..Set Membrane=$p(tempData,"^",8)
	..Set Position=$p(tempData,"^",9)
	..Set FirstSight=$p(tempData,"^",10)
	..Set PRorPV=$p(tempData,"^",11)
	..Set Exception=$p(tempData,"^",12)
	..Set Handle=$p(tempData,"^",13)
	..Set UserID=$p(tempData,"^",14)
	..Set Comment=$p(tempData,"^",15)
	..Set PregDr=$p(tempData,"^",16)
	..d ret.Write("<Contration><PregDateTime>"_Date_" "_Time_"</PregDateTime><PregDate>"_Date_"</PregDate><PregTime>"_Time_"</PregTime><PregComment>"_Comment_"</PregComment><PregBlood>"_Blood_"</PregBlood><PregPuls>"_Puls_"</PregPuls><PregMethod>"_Method_"</PregMethod><PregFetalHeart>"_FetalHeart_"</PregFetalHeart><PregFrequency>"_Frequency_"</PregFrequency><PregPipe>"_Pipe_"</PregPipe><PregWombwidth>"_Wombwidth_"</PregWombwidth><PregMembrane>"_Membrane_"</PregMembrane><PregPosition>"_Position_"</PregPosition><PregFirstSight>"_FirstSight_"</PregFirstSight><PregPRorPV>"_PRorPV_"</PregPRorPV><PregException>"_Exception_"</PregException><PregHandle>"_Handle_"</PregHandle><PregUserID>"_UserID_"</PregUserID><PregDr>"_PregDr_"</PregDr></Contration>")
	d ret.Write("</Response>")
    Quit ret
}

/// 删除病人表格记录（右下）
ClassMethod DelPatContration(input) As %String
{
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.DelPatContration).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set ContraDr=myCurveObj.ContraDr
	Set ret=##Class(Nur.DHCNURPregRec).%DeleteId(ContraDr)
	If ret=0 Set Msg="删除失败"
	Else  Set Msg="删除成功"
	Set XmlStr="<Response><ResultCode>"_ret_"</ResultCode><ErrorMsg>"_Msg_"</ErrorMsg></Response>"
	Quit XmlStr
}

/*ClassMethod SavePatPreg(input) As %String
{
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.SavePatPreg).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set Value=myCurveObj.Value
	Set Interval=myCurveObj.Interval
	Set Episode=myCurveObj.Episode
	Set ret=##Class(Nur.DHCPregnancy).Save(Value,Interval,Episode)
	If ret=0 Set Msg="保存成功"
	Else  Set Msg="保存失败"
	Set XmlStr="<Response><ResultCode>"_ret_"</ResultCode><ErrorMsg>"_Msg_"</ErrorMsg></Response>"
	Quit XmlStr
}

ClassMethod DelPatPreg(input) As %String
{
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.DelPatPreg).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set PregDr=myCurveObj.PregDr
	Set ret=##Class(Nur.DHCPregnancy).%DeleteId(PregDr)
	If ret=0 Set Msg="删除失败"
	Else  Set Msg="删除成功"
	Set XmlStr="<Response><ResultCode>"_ret_"</ResultCode><ErrorMsg>"_Msg_"</ErrorMsg></Response>"
	Quit XmlStr
}
*/
/// 读取要画在产程图上的数据
/// w ##class(web.DHCCurveOperation).GetPatAllGraphData("<Request><Episode>521</Episode></Request>")
ClassMethod GetPatAllGraphData(input) As %String
{
	;s ^lf("input=")=input
	;w ##class(web.DHCCurveOperation).GetPatAllGraphData("<Request><Episode>104</Episode></Request>")
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.GetPatAllContration).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set Episode=myCurveObj.Episode
	b //11
	Set XmlStr="<Response><ResultCode>"_1_"</ResultCode><ErrorMsg>没有数据</ErrorMsg></Response>"
    Set rw="" For  Set rw=$O(^Nur.DHCNURPregRecI("Adm"," "_Episode,rw)) Quit:rw=""  Do
    .b //222
	.s a=##class(Nur.DHCNURPregRec).%OpenId(rw)
	.Set ContraDate=a.DHCPregDate
	.Set ContraTime=a.DHCPregTime
	.Set Wombwidth=a.DHCPregWombwidth
	.Set Foetusposition=a.DHCPregFirstSight
	.s Blood=a.DHCPregBlood
	.s FetalHeart=a.DHCPregFetalHeart
	.s Frequency=a.DHCPregFrequency
	.s Exception=a.DHCPregException
	.s Handle=a.DHCPregHandle
	.s UserId=a.DHCPregUserID
	.s BirthMark=a.DHCPregComment
	.s Puls=a.DHCPregPuls
	.s Membrane=a.DHCPregMembrane
	.s:$d(^SSU("SSUSR",UserId)) UserId=$P(^SSU("SSUSR",UserId),"^",2)
	.i BirthMark="Y"  d
	 .. s TMPContration(ContraDate,ContraTime)=ContraDate_"^"_ContraTime_"^BirthMark"_"^BirthMark^^^^^^"
	.q:BirthMark="Y"
	
	 .i (Wombwidth'="")&&(Foetusposition'="")  d
	  ..S TMPContration(ContraDate,ContraTime)=ContraDate_"^"_ContraTime_"^"_Wombwidth_"^"_Foetusposition_"^"_Blood_"^"_FetalHeart_"^"_Frequency_"^"_Exception_"^"_Handle_"^"_UserId_"^"_Puls_"^"_Membrane
   Set rw=$O(^Nur.DHCNurCurveI("Adm"," "_Episode,""))
	If (rw'="")&&($g(UserId)'="")  d 
	 .Set a=##class(Nur.DHCNurCurve).%OpenId(rw)
	 .s birthDate=a.BirthDate
	 .s birthTime=a.BirthTime
	 .i (birthDate'="")&&(birthTime'="") d
	  ..s TMPContration(birthDate,birthTime)=birthDate_"^"_birthTime_"^BirthMark"_"^BirthMark^^^^^^"
   s reci=$O(TMPContration(""))
    Quit:reci="" XmlStr
    ;Quit:hasBirthMark=0 XmlStr
    Set XmlStr="<Response><ResultCode>"_0_"</ResultCode><ErrorMsg></ErrorMsg>"
    s Interval="-1"
    s drawRecCount=0
    s recCount=0
     Set date="" 
     F  S date=$O(TMPContration(date)) Quit:date=""  Do
       .s time=""
       .F  S time=$O(TMPContration(date,time)) Quit:time=""  Do
        ..s recCount= recCount+1
        ..s Wombwidth=$P(TMPContration(date,time),"^",3)
        ..i Wombwidth="BirthMark" s drawRecCount=recCount
    Set date="" 
   
   s firstDate=$O(TMPContration(date))
   b //1
    F  S date=$O(TMPContration(date)) Quit:date=""  Do
      .s time=""
      .s normal=1
      .i $O(TMPContration(firstDate,time))'="" d
      ..s firstTime=$O(TMPContration(firstDate,time))
      ..s firstWombwidth=$P(TMPContration(firstDate,firstTime),"^",3)
      ..i firstWombwidth>=8  d
      ...s normal=0
      ...s XmlStr="<Response><ResultCode>"_1_"</ResultCode><ErrorMsg>超过24小时</ErrorMsg>"
      .q:normal=0
      .F  S time=$O(TMPContration(date,time)) Quit:(time="")  Do
        ..s ContraTime=$zt($P(TMPContration(date,time),"^",2),2)
        ..i Interval="-1" d
          ...s recDate=$p(TMPContration(date,time),"^",1)
          ...s recTime=$p(TMPContration(date,time),"^",2)
          ...s contraDT=..GetContraDT(Episode)
          ...s contraDate=$P(contraDT,"^",1)
          ...s contraTime=$P(contraDT,"^",2)
          ...s span=(recDate-contraDate)*86400+(recTime-contraTime)
          ...s Interval=(span\3600)+1
        ..e  s Interval=(Interval+1)
	    ..Set Wombwidth=$P(TMPContration(date,time),"^",3)
	    ..Set Foetusposition=$P(TMPContration(date,time),"^",4)
	    ..s Blood=$P(TMPContration(date,time),"^",5)
	    ..s FetalHeart=$P(TMPContration(date,time),"^",6)
	    ..s Frequency=$P(TMPContration(date,time),"^",7)
	    ..s Exception=$P(TMPContration(date,time),"^",8)
	    ..s Handle=$P(TMPContration(date,time),"^",9)
	    ..s UserId=$P(TMPContration(date,time),"^",10)
	    ..s Puls=$P(TMPContration(date,time),"^",11)
	    ..s PregMembrane=$P(TMPContration(date,time),"^",12)
	    
	    ..Set XmlStr=XmlStr_"<Contration><ContraTime>"_ContraTime_"</ContraTime><ContraWombwidth>"_Wombwidth_"</ContraWombwidth><ContraFoetusposition>"_Foetusposition_"</ContraFoetusposition><ContraInterval>"_Interval_"</ContraInterval><PregBlood>"_Blood_"</PregBlood><ContraFetalHeart>"_FetalHeart_"</ContraFetalHeart><PregFetalHeart>"_FetalHeart_"</PregFetalHeart><PregFrequency>"_Frequency_"</PregFrequency><PregException>"_Exception_"</PregException><PregHandle>"_Handle_"</PregHandle><PregUserID>"_UserId_"</PregUserID><PregPuls>"_Puls_"</PregPuls><PregMembrane>"_Membrane_"</PregMembrane></Contration>"
    Set XmlStr=XmlStr_"</Response>"
	Quit XmlStr
}

/// 取病人表格里的所有记录（右下）
ClassMethod GetPatAllContration(input) As %String
{
	;w ##class(web.DHCCurveOperation).GetPatAllContration("<Request><Episode>11</Episode></Request>")
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.GetPatAllContration).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set Episode=myCurveObj.Episode
	Set XmlStr="<Response><ResultCode>"_1_"</ResultCode><ErrorMsg>没有数据</ErrorMsg></Response>"
    Set rw="" For  Set rw=$O(^Nur.DHCNURPregRecI("Adm"," "_Episode,rw)) Quit:rw=""  Do
	.Set ContraDate=$List(^Nur.DHCNURPregRecD(rw),3)
	.Set ContraTime=$List(^Nur.DHCNURPregRecD(rw),4)
	.Set Wombwidth=$List(^Nur.DHCNURPregRecD(rw),11)
	.Set Foetusposition=$List(^Nur.DHCNURPregRecD(rw),14)
	.q:(Wombwidth="")||(Foetusposition="")
	.Set TMPContration(ContraDate,ContraTime)=ContraDate_"^"_ContraTime_"^"_Wombwidth_"^"_Foetusposition
   
   s reci=$O(TMPContration(""))
    Quit:reci="" XmlStr
    Set XmlStr="<Response><ResultCode>"_0_"</ResultCode><ErrorMsg></ErrorMsg>"
    s Interval="-1"
    Set date="" 
    F  S date=$O(TMPContration(date)) Quit:date=""  Do
      .s time=""
      .F  S time=$O(TMPContration(date,time)) Quit:time=""  Do
        ..i Interval="-1" d
          ...s recDate=$p(TMPContration(date,time),"^",1)
          ...s recTime=$p(TMPContration(date,time),"^",2)
          ...s contraDT=..GetContraDT(Episode)
          ...s contraDate=$P(contraDT,"^",1)
          ...s contraTime=$P(contraDT,"^",2)
          ...s span=(recDate-contraDate)*86400+(recTime-contraTime)
          ...s Interval=span\3600
        ..e  s Interval=(Interval+1)
	    ..Set Wombwidth=$P(TMPContration(date,time),"^",3)
	    ..Set Foetusposition=$P(TMPContration(date,time),"^",4)
	    ..Set XmlStr=XmlStr_"<Contration><ContraTime>"_""_"</ContraTime><ContraWombwidth>"_Wombwidth_"</ContraWombwidth><ContraFoetusposition>"_Foetusposition_"</ContraFoetusposition><ContraInterval>"_Interval_"</ContraInterval></Contration>"
    Set XmlStr=XmlStr_"</Response>"
	Quit XmlStr
}

/*ClassMethod GetPatAllPreg(input) As %String
{
	;w ##class(web.DHCCurveOperation).GetPatAllPreg()
	;s input="<Request><Episode>271</Episode></Request>"
	Set XmlStr=""
	Set myCurveObj=##Class(web.DHCEntity.Curve.GetPatAllPreg).%New()
	Do myCurveObj.XMLNodeDeserialize(.myCurveObj,"Request",input)
	Set Episode=myCurveObj.Episode
	Set XmlStr="<Response><ResultCode>"_1_"</ResultCode><ErrorMsg>没有数据</ErrorMsg></Response>"
	Set rw="" For  Set rw=$O(^Nur.DHCNURPregRecI("Adm"," "_Episode,rw)) Quit:rw=""  Do
	.Set PregDate=$List(^Nur.DHCNURPregRecD(rw),3)
	.Set PregTime=$List(^Nur.DHCNURPregRecD(rw),4)
	.Set Blood=$List(^Nur.DHCNURPregRecD(rw),5)
	.Set Puls=$List(^Nur.DHCNURPregRecD(rw),6)
	.Set FetalHeart=$List(^Nur.DHCNURPregRecD(rw),8)
	.Set Frequency=$List(^Nur.DHCNURPregRecD(rw),9)
	.Set Exception=$List(^Nur.DHCNURPregRecD(rw),16)
	.Set Handle=$List(^Nur.DHCNURPregRecD(rw),17)
	.Set UserID=$List(^Nur.DHCNURPregRecD(rw),18)
	.s span=PregDate
	.Set PregInterval=$List(^Nur.DHCNURPregRecD(rw),8)
	.Set TMPPregnancy(PregInterval)=PregDate_"^"_PregTime_"^"_Blood_"^"_FetalHeart_"^"_Frequency_"^"_Handle_"^"_UserID
    Quit:$G(PregInterval)="" XmlStr
    Set XmlStr="<Response><ResultCode>"_0_"</ResultCode><ErrorMsg></ErrorMsg>"
    Set dr="" For  Set dr=$O(TMPPregnancy(dr)) Quit:dr=""  Do
    .Set PregTime=$ZT($P(TMPPregnancy(dr),"^",2),2)
    .Set Blood=$P(TMPPregnancy(dr),"^",3)
    .Set FetalHeart=$P(TMPPregnancy(dr),"^",4)
    .Set Frequency=$P(TMPPregnancy(dr),"^",5)
    .Set Handle=$P(TMPPregnancy(dr),"^",6)
    .Set UserID=$P(TMPPregnancy(dr),"^",7)
    .Set XmlStr=XmlStr_"<Pregnancy><PregTime>"_PregTime_"</PregTime><PregBlood>"_Blood_"</PregBlood><PregFetalHeart>"_FetalHeart_"</PregFetalHeart><PregFrequency>"_Frequency_"</PregFrequency><PregHandle>"_Handle_"</PregHandle><PregUserID>"_UserID_"</PregUserID><PregInterval>"_dr_"</PregInterval></Pregnancy>"
	Set XmlStr=XmlStr_"</Response>"
	Quit XmlStr
}*/
ClassMethod GetUserName(UserID As %String) As %String
{
	q:UserID="" 0
	s name=$P($g(^SSU("SSUSR",UserID)),"^",2)
	q name
}

/// 无纸化接口，表格有记录返回1
/// 据分娩室要求，表格有记录是必有产时记录，没有娩出标记
/// 或第一条宫口的记录>=8时不画产程图（CSP中判断是否画产程图）
ClassMethod HasBirthGraph(Episode As %String) As %String
{
	//w ##class(web.DHCCurveOperation).HasBirthGraph(5593823)
	s birthGraphFlag=0
	 Set rw=$O(^Nur.DHCNURPregRecI("Adm"," "_Episode,""))
	 i rw'="" d
	  .s birthGraphFlag=1
	q birthGraphFlag
}

/// 返回1表示有娩出标记且第一条宫口的记录<8时
/// 否则返回0（不画产程图）
ClassMethod IsNormalBirth(Episode As %String) As %String
{
	//w ##class(web.DHCCurveOperation).IsNormalBirth(5884002)
	//w ##class(web.DHCCurveOperation).IsNormalBirth(5628769)
	//对数据排序
	s hasBirthMark=0
	s normalFlag=0
	 Set rw="" For  Set rw=$O(^Nur.DHCNURPregRecI("Adm"," "_Episode,rw)) Quit:rw=""  Do
	.s a=##class(Nur.DHCNURPregRec).%OpenId(rw)
	.Set ContraDate=a.DHCPregDate
	.Set ContraTime=a.DHCPregTime
	.Set Wombwidth=a.DHCPregWombwidth
	.Set Foetusposition=a.DHCPregFirstSight
	.s BirthMark=a.DHCPregComment
	.i BirthMark="Y"  d
	 .. s TMPContration(ContraDate,ContraTime)=ContraDate_"^"_ContraTime_"^BirthMark"
	 ..s hasBirthMark=1
	.q:BirthMark="Y"
	 .i (Wombwidth'="")&&(Foetusposition'="")  d
	  ..S TMPContration(ContraDate,ContraTime)=ContraDate_"^"_ContraTime_"^"_Wombwidth
   Set rw=$O(^Nur.DHCNurCurveI("Adm"," "_Episode,""))
	If (rw'="")&&($g(UserId)'="")  d 
	 .Set a=##class(Nur.DHCNurCurve).%OpenId(rw)
	 .s birthDate=a.BirthDate
	 .s birthTime=a.BirthTime
	 .i (birthDate'="")&&(birthTime'="") d
	  ..s TMPContration(birthDate,birthTime)=birthDate_"^"_birthTime_"^BirthMark"
	  ..s hasBirthMark=1
	  b //1
	q:(hasBirthMark=0) 0
  Set date="" 
   s firstDate=$O(TMPContration(date))
    F  S date=$O(TMPContration(date)) Quit:(date="")  Do
      .s time=""
      .i $O(TMPContration(firstDate,time))'="" d
      ..s firstTime=$O(TMPContration(firstDate,time))
      ..s firstWombwidth=$P(TMPContration(firstDate,firstTime),"^",3)
      ..i firstWombwidth<8  d 
      ...s normalFlag=1 //第一条宫口小于8
      .q:normalFlag=0
      .F  S time=$O(TMPContration(date,time)) Quit:(time="")  Do
	    ..Set Wombwidth=$P(TMPContration(date,time),"^",3)
	    ..i Wombwidth="BirthMark"  s normalFlag=1  //娩出标记
	q normalFlag
}

/// 签名验证返回XML格式的病人基本信息
ClassMethod GetPatInfoXML(Episode) As %String
{
	s RecMainXML=""
    Set rw="" For  Set rw=$O(^Nur.DHCNurCurveI("Adm"," "_Episode,rw)) Quit:rw=""  Do
 	     .b //1
 	     .s a=##class(Nur.DHCNurCurve).%OpenId(rw)
 	     .s b=##class(web.DHCEntity.Curve.DHCNurBirthPatInfo).%New()
 	     .s b.BirthCount= a.BirthCount
 	     .s b.BirthDate=a.BirthDate
 	     .s b.BirthTime=a.BirthTime
 	     .s b.DHCCurveAdm=a.DHCCurveAdm
 	     .s b.DHCCurveContraDate=a.DHCCurveContraDate
 	     .s b.DHCCurveContraTime=a.DHCCurveContraTime
 	     .s b.DHCCurvePregnancy=a.DHCCurvePregnancy
 	     .s b.DHCCurveUserID=a.DHCCurveUserID
 	     .s b.PlacentaOutDate=a.PlacentaOutDate
 	     .s b.PlacentaOutTime= a.PlacentaOutTime
 	     .s b.PredictPreg=a.PredictPreg
 	    .d b.XMLExportToString(.RecMainXML)	
 	
 	q RecMainXML
}

/// 签名验证返回基本信息的签名和证书
ClassMethod GetPatInfoSigned(Episode) As %String
{
	//w ##class(web.DHCCurveOperation).GetPatInfoSigned("5630105")
	s signedRet=""
	s rw=$o(^User.DHCNurRecSignI("AdmTyp"," "_Episode," DHCNURBIRTHINFO",""),-1)
	b
	i rw'="" d
	 .s a=##class(User.DHCNurRecSign).%OpenId(rw)
	 .s signedRet=a.SVRecMainSignCert_"&&&&"_a.SVRecMainSignValue
	q signedRet
}

/// 签名验证返回XML格式的病人表格记录
ClassMethod GetBirthRec(Episode As %String, rw As %String) As %String
{
	s RecMainXML=""
    i $D(^Nur.DHCNURPregRecI("Adm"," "_Episode,rw))'=0  d
 	     .b //1
 	     .s a=##class(Nur.DHCNURPregRec).%OpenId(rw)
 	     .s b=##class(web.DHCEntity.Curve.DHCNurBirthRec).%New()
 	     .s b.DHCPregBlood= a.DHCPregBlood
 	     .s b.DHCPregDate=a.DHCPregDate
 	     .s b.DHCPregException=a.DHCPregException
 	     .s b.DHCPregFetalHeart=a.DHCPregFetalHeart
 	     .s b.DHCPregFirstSight=a.DHCPregFirstSight
 	     .s b.DHCPregFrequency=a.DHCPregFrequency
 	     .s b.DHCPregHandle=a.DHCPregHandle
 	     .s b.DHCPregMembrane=a.DHCPregMembrane
 	     .s b.DHCPregMethod=a.DHCPregMethod
 	     .s b.DHCPregPipe= a.DHCPregPipe
 	     .s b.DHCPregPosition=a.DHCPregPosition
 	     .s b.DHCPregPRorPV=a.DHCPregPRorPV
 	     .s b.DHCPregPuls=a.DHCPregPuls
 	     .s b.DHCPregTime=a.DHCPregTime
 	     .s b.DHCPregUserID=a.DHCPregUserID
 	     .s b.DHCPregWombwidth=a.DHCPregWombwidth
 	     .s b.DHCPregComment=a.DHCPregComment
 	    .d b.XMLExportToString(.RecMainXML)	
 	
 	q RecMainXML
}

/// 签名验证返回一条表格数据的签名和证书
ClassMethod GetBirthRecSigned(Episode, rw) As %String
{
	
	s signedRet=""
	s rw=$o(^User.DHCNurRecSignI("AdmTyp"," "_Episode," DHCNURBIRTHREC"_rw,""),-1)
	b
	i rw'="" d
	 .s a=##class(User.DHCNurRecSign).%OpenId(rw)
	 .s signedRet=a.SVRecMainSignCert_"&&&&"_a.SVRecMainSignValue
	q signedRet
}

/// 比较宫缩开始时间和胎盘娩出时间大小
/// a:宫缩开始时间 b：胎盘娩出时间
/// a>b :输出1
ClassMethod CompareDateTime(a = "", b = "") As %String
{
	s $zt="error"
	q:(a=" ")!(b=" ") "0"
	s adate=$zdh($p(a," ",1),3)
	s atime=$zth($p(a," ",2),2)
	s bdate=$zdh($p(b," ",1),3)
	s btime=$zth($p(b," ",2),2)
	if (((adate=bdate)&&(atime>btime))!(adate>bdate))
	{ 
	 q "1"
	}
	else
	{
		q "0"
		}
error
  q "0"
}

}
