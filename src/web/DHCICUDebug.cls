Import SQLUser

Class web.DHCICUDebug Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      	whl
/// CreatDate：    	2014-03-19
/// Description： 	判断监护记录是否有有效数据
/// Table：        	DHC_ICU_Order
/// Input：        	icuaId
/// Output：       是Y否N效
/// Return：       	对应为"Y"的已分余液
ClassMethod CheckValidICUAID(icuaId As %String = "") As %String
{
	s height=$p($g(^DHCICUArrange(icuaId)),"^",24) ;身高
	s weight=$p($g(^DHCICUArrange(icuaId)),"^",25) ;体重

    s ResidentCtcpDr=$p($g(^DHCICUArrange(icuaId)),"^",28) ;住院医生
	s AttendingCtcpDr=$p($g(^DHCICUArrange(icuaId)),"^",29) ;主治医生
    s IsHaveValidOrder="N"
    s IsHaveValidIcuaid="N"
    s tmpIcuoId="",userid=""
    f  s tmpIcuoId=$o(^DHCICUOrder(0,"Arr",icuaId,tmpIcuoId)) q:tmpIcuoId=""  d
			.s userid=$p(^DHCICUOrder(tmpIcuoId),"^",4) ;
			.q:userid="" 
			.q:("NE"'[$p(^DHCICUOrder(tmpIcuoId),"^",25)) ;
			.s IsHaveValidOrder="Y"
	i (IsHaveValidOrder="Y")&(height'="")&(weight'="")  s IsHaveValidIcuaid="Y"	 
	b ;"1111"	
	q IsHaveValidIcuaid
}

ClassMethod test(icuaId As %String = "") As %String
{
   s IsValid="N"
	s IsValid=##class(web.DHCICUOrder).CheckValidICUAID(icuaId)
	q:IsValid="N"
}

// d ##class(%ResultSet).RunQuery("web.DHCCLCScore","FindICUArrangeScoreTest","2014-02-01","2014-03-01","","56","","","")

Query FindICUArrangeScoreTest(fromDate As %String, toDate As %String, needRegNo As %String = "", ctlocId As %String = "", icuaStatusCode As %String = "", papmiMedicare As %String = "", papmiName As %String = "", needGroupId As %String = "", inward As %String = "", atward As %String = "") As %Query(ROWSPEC = "WardInDateTime:%String,WardOutDateTime:%String,RegNo:%String,PatName:%String,IcuWardDesc:%String,Status:%String,BedCode:%String,DiagDesc:%String,CurWardDesc:%String,icuaId:%String,EpisodeID:%String,MediCareNo:%String,WardInOutNote:%String,InApacheScore:%String,InSofaScore:%String,OutApacheScore:%String,OutSofaScore:%String,ResidentCtcp:%String,AttendingCtcp:%String,Temper:%String,HR:%String,RR:%String,PaO2:%String,AaDO2ifFiO250:%String,ApachePH:%String,SerumNa:%String,Serumk:%String,CreatinineARF2:%String,Hematocrit:%String,WBCcount:%String,age:%String,CHP:%String,GCS:%String,EyeOpening:%String,VerbalResponse:%String,MotorResponse:%String,FiO2:%String,NBP:%String,ARFValue:%String,bedusedays:%String,death:%String,In24hours:%String")
{
}

ClassMethod FindICUArrangeScoreTestExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, needRegNo As %String = "", ctlocId As %String = "", icuaStatusCode As %String = "", papmiMedicare As %String = "", papmiName As %String = "", needGroupId As %String = "", inward As %String = "True", atward As %String = "False") As %Status
{
	s TemperID="6370",HRID="6372",RRID="6386",PaO2ID="6373",AaDO2ifFiO250ID="6374",ApachePHID="6375",SerumNaID="6377",SerumkID="6378",CreatinineARF2ID="6379",HematocritID="6380",WBCcountID="6381",CHPID="6384",GCSID="6382",FiO2ID="5578",NBPID="6597"
	s TemperScoreID="6389",HRScoreID="6391",RRScoreID="6392",PaO2ScoreID="6393",AaDO2ifFiO250ScoreID="6394",ApachePHScoreID="6395",SerumNaScoreID="6397",SerumkScoreID="6398",CreatinineARF2ScoreID="6400",HematocritScoreID="6401",WBCcountScoreID="6402",CHPScoreID="6412",GCSScoreID="",FiO2ScoreID="6419",NBPScoreID="6390"
	s Temper="",HR="",RR="",PaO2="",AaDO2ifFiO250="",ApachePH="",SerumNa="",Serumk="",CreatinineARF2="",Hematocrit="",WBCcount="",age="",CHP="",GCS="",FiO2="",NBP=""
	s inTemperScore="",inHRScore="",inRRScore="",inPaO2Score="",inAaDO2ifFiO250Score="",inApachePHScore="",inSerumNaScore="",inSerumkScore="",inCreatinineARF2Score="",inHematocritScore="",inWBCcountScore="",ageScore="",inCHPScore="",inGCSScore="",inFiO2Score="",inNBPScore=""
	s outTemperScore="",outHRScore="",outRRScore="",outPaO2Score="",outAaDO2ifFiO250Score="",outApachePHScore="",outSerumNaScore="",outSerumkScore="",outCreatinineARF2Score="",outHematocritScore="",outWBCcountScore="",outCHPScore="",outGCSScore="",outFiO2Score="",outNBPScore=""
	s inTemperValue="",inHRValue="",inRRValue="",inPaO2Value="",inAaDO2ifFiO250Value="",inApachePHValue="",inSerumNaValue="",inSerumkValue="",inCreatinineARF2Value="",inHematocritValue="",inWBCcountValue="",ageValue="",inCHPValue="",inGCSValue="",inFiO2Value="",inNBPValue=""
	s outTemperValue="",outHRValue="",outRRValue="",outPaO2Value="",outAaDO2ifFiO250Value="",outApachePHValue="",outSerumNaValue="",outSerumkValue="",outCreatinineARF2Value="",outHematocritValue="",outWBCcountValue="",outCHPValue="",outGCSValue="",outFiO2Value="",outNBPValue=""
	s ageScore="",ageScoreID="6410",ageID="6383"
	s apcheID="6385",SofaID="5453"	
	s EyeOpeningValueID="6403",  VerbalResponseValueID="6405", MotorResponseValueID="6407", EyeOpeningScoreID="6404",  VerbalResponseScoreID="6406", MotorResponseScoreID="6408"
	s inEyeOpening="",  inVerbalResponse="", inMotorResponse="", outEyeOpening="",  outVerbalResponse="", outMotorResponse=""
	s EyeOpening="",  VerbalResponse="", MotorResponse=""
	s inEyeOpeningValue="",  inVerbalResponseValue="", inMotorResponseValue="", inEyeOpeningScore="",  inVerbalResponseScore="", inMotorResponseScore=""
	s outEyeOpeningValue="",  outVerbalResponseValue="", outMotorResponseValue="", outEyeOpeningScore="",  outVerbalResponseScore="", outMotorResponseScore=""
	s inApacheScore="",inSofaScore="",outApacheScore="",outSofaScore="",startTime="",startDate="",startDateTime=""
  	s ARFID="6399",inARFValue="",outARFValue="",ARFValue=""
  	s death="",In24hours=""
  	s IsValid="N"
  	Set repid=$I(^CacheTemp)
  	s needGroupId=315
  	s atward=atward
  	s ^TEMPLLL("atward")=atward
	If $g(ind)="" Set ind=1
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s EpisodeIDList=""
 	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr")=EpisodeIDList
	s ifSingle="N"
	i needRegNo="",papmiMedicare="",papmiName="" s ifSingle="Y",tBodySquare=""

	;s ctlocId=39
	
	s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
	s icuaBedList="",icuward="",linkLocIdStrTemp=""
	s linkLocIdStrTemp=##class(web.DHCClinicCom).GetLinkLocId(ctlocId)_"^"_ctlocId

    i linkLocIdStrTemp["39" s ctlocId=39 
	i linkLocIdStrTemp["88" s ctlocId=88 
	s linkLocIdStr=##class(web.DHCClinicCom).GetLinkLocId(ctlocId)_"^"_ctlocId

	s wardIdStr=""
	f i=1:1:$l(linkLocIdStr,"^") d
		.s curLocId=$p(linkLocIdStr,"^",i)
		.q:curLocId=""
		.s curWardId=$o(^PAWARD(0,"WARD_LocationDR",curLocId,0))
		.q:curWardId=""
		.i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		.s wardIdStr=wardIdStr_curWardId
	//$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId
	k icuaIdList
	//时间段进病区
	i ifSingle="Y", needRegNo="" d
		.s icuaBedList=""
		.f date=fromDate:1:toDate d
			..s icuaId=""
			..f  s icuaId=$o(^DHCICUArrange(0,"SDate",date,icuaId)) q:icuaId=""  d
				...;q:'$d(^DHCICUArrange(icuaId))
				...//w icuaId,!
				...s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
				...q:("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^")
				...s curEpisodeID=+^DHCICUArrange(+icuaId)
				...;q:$p($g(^PAADM(curEpisodeID)),"^",73)=""
    			...i ("^"_EpisodeIDList_"^")'[curEpisodeID s EpisodeIDList=EpisodeIDList_"^"_curEpisodeID
    			...s icuaIdList(icuaId)=""
    //时间段在病区	
   	;k ^TEMPWWW("atward")	
    i (atward="True"), needRegNo="" d
		.s icuaBedList=""
		.s ^TEMPWWW("atward")=atward
		.f date=fromDate:1:toDate d
			..s icuaId=""
			..f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d
				...;q:'$d(^DHCICUArrange(icuaId))
				...//w icuaId,!
				...s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
				...q:("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^")
				...s curEpisodeID=+^DHCICUArrange(+icuaId)
				...;q:$p($g(^PAADM(curEpisodeID)),"^",73)=""
    			...i ("^"_EpisodeIDList_"^")'[curEpisodeID s EpisodeIDList=EpisodeIDList_"^"_curEpisodeID
    			...s icuaIdList(icuaId)=""
	//w EpisodeIDList
	i needRegNo'="" s EpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID(needRegNo,"")
	s icuaId=""
	f  s icuaId=$o(icuaIdList(icuaId)) q:icuaId=""  d
		.//w icuaId,!		
	    .s IsValid=##class(web.DHCICUOrder).CheckValidICUAID(icuaId)
	    .q:IsValid="N"
		.s curIcuaStatusCode=$p($g(^DHCICUArrange(+icuaId)),"^",18)
		.q:curIcuaStatusCode=""	;20120625
		.s leavePat=1
		.s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
		.q:EpisodeID=""
		.s patHeight=$p(^DHCICUArrange(icuaId),"^",24)
		.s patWeight=$p(^DHCICUArrange(icuaId),"^",25)
		.s tBodySquare=0 //..Sqr((patHeight*patWeight)/3600)
		.;q:(icuaStatusCode'="")&(curIcuaStatusCode'=icuaStatusCode)
		.s startDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)
		.s startTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
		.s startDateTime=startDate+(startTime/100000)
		.s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
		.s inWardDateTimeStr=##class(web.DHCClinicCom).GetWardInDateTime(EpisodeID,startDate,startTime," ")
		.s inWardDate=startDate,inWardTime=startTime
		.i inWardDateTimeStr'=" " d
			..s inWardDate=##class(web.DHCClinicCom).ConvertToDateH($p(inWardDateTimeStr," "))
			..s inWardTime=##class(web.DHCClinicCom).ConvertToTimeH($p(inWardDateTimeStr," ",2))
		.s inWardDateTime=inWardDate+(inWardTime/100000)
		.s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
		.s curDateTime=$h+($p($h,",",2)/100000)
		.s curDate=($p($h,",",1))
		.s wardInOutNote=""
		.i outDateTime="" d
			..s duration=curDateTime-inWardDateTime
			..i duration>1 s wardInOutNote=$p(duration,".")_"天(在院)"
			..e  s wardInOutNote="<1天(在院)"
		.e  d
			..s outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
			..s outDateTime=outDate+(outTime/100000)
			..s leavePat=0
			..s duration=outDateTime-inWardDateTime
			..i duration>1 s wardInOutNote=$p(duration,".")_"天"
			..e  s wardInOutNote="<1天"
		.i outDateTime="" s outDate=+$h,outTime=$p($h,",",2)
		.e  d
			..s outDate=$p(outDateTime,".",1)
			..s outTime=(outDateTime-outDate)*100000
			..//s outDate=$zd(outDate,3)
					
			
		
		.s fromD=##class(web.DHCClinicCom).ConvertToDateH($p(fromDate," "))
		.s fromT=##class(web.DHCClinicCom).ConvertToTimeH($p(fromDate," ",2))
		.s fromDT=fromD+(fromT/100000)    
        .s toD=##class(web.DHCClinicCom).ConvertToDateH($p(toDate," "))
		.s toT=##class(web.DHCClinicCom).ConvertToTimeH($p(toDate," ",2))
	    .s toDT=toD+(toT/100000)  
	    .;b ;"toDT"     
	    .s icuidtest="1738"
		.i outDateTime="" d
            ..i (fromDT<inWardDateTime)&(curDateTime<toDT)  d
              ...i icuaId=icuidtest  b ;"1"
			  ...s duration=curDate-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i (fromDT<inWardDateTime)&(curDateTime>toDT)  d
			  ...i icuaId=icuidtest  b ;"2"
		      ...s duration=toDT-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i (fromDT>inWardDateTime)&(curDateTime>toDT)  d
			   ...i icuaId=icuidtest  b ;"3"
		       ...s duration=toD-fromD
			   ...i duration>1 s bedusedays=$p(duration,".")
			   ...e  s bedusedays="0"
			..e  i (fromDT>inWardDateTime)&(curDateTime<toDT)  d
			   ...i icuaId=icuidtest  b ;"3"
		       ...s duration=curDate-fromD
			   ...i duration>1 s bedusedays=$p(duration,".")
			   ...e  s bedusedays="0"
		.e  d
            ..i (fromDT<inWardDateTime)&(outDateTime<toDT)  d
              ...i icuaId=icuidtest  b ;"4"
			  ...s duration=outDate-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i (fromDT<inWardDateTime)&(outDateTime>toDT)  d
			  ...i icuaId=icuidtest  b ;"5"
		      ...s duration=toD-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i (fromDT>inWardDateTime)&(outDateTime>toDT)  d
			  ...i icuaId=icuidtest  b ;"6"
		      ...s duration=toD-fromD
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i (fromDT>inWardDateTime)&(outDateTime<toDT)  d
			  ...i icuaId=icuidtest  b ;"7"
		      ...s duration=outDate-fromDT+2
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"  
			  
			  
			  
		.i icuaId=icuidtest  b ;"8"		
			
		.s birth=$p($g(^PAPER(EpisodeID,"ALL")),"^",6)
		.s age=##class(web.DHCClinicCom).CalAge(birth,$h)
		.s inApacheScore=##class(web.DHCICUOrder).GetOrderValueByIdAndDate(apcheID,icuaId,inWardDate,inWardDate+1)
		.s outApacheScore=##class(web.DHCICUOrder).GetOrderValueByIdAndDate(apcheID,icuaId,outDate-1,outDate+1)
		.s inSofaScore=##class(web.DHCICUOrder).GetOrderValueByIdAndDate(SofaID,icuaId,inWardDate,inWardDate+1)
		.s outSofaScore=##class(web.DHCICUOrder).GetOrderValueByIdAndDate(SofaID,icuaId,outDate-1,outDate+1)
        
		.s AttendingCtcp=""
		.s inTemperValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inHRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inRRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inPaO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inAaDO2ifFiO250Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inApachePHValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inSerumNaValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inSerumkValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inCreatinineARF2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inHematocritValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inWBCcountValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inCHPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inGCSValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inFiO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inNBPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inARFValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ARFID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inEyeOpeningValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inVerbalResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inMotorResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")

        .s ageScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,ageScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inTemperScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inTemperScore'="" s inTemperScore=inTemperScore_"分"
		.s inHRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inHRScore'="" s inHRScore=inHRScore_"分"
		.s inRRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inRRScore'="" s inRRScore=inRRScore_"分"
		.s inPaO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inPaO2Score'="" s inPaO2Score=inPaO2Score_"分"
		.s inAaDO2ifFiO250Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inAaDO2ifFiO250Score'="" s inAaDO2ifFiO250Score=inAaDO2ifFiO250Score_"分"
		.s inApachePHScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inApachePHScore'="" s inApachePHScore=inApachePHScore_"分"
		.s inSerumNaScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inSerumNaScore'="" s inSerumNaScore=inSerumNaScore_"分"
		.s inSerumkScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inSerumkScore'="" s inSerumkScore=inSerumkScore_"分"
		.s inCreatinineARF2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inCreatinineARF2Score'="" s inCreatinineARF2Score=inCreatinineARF2Score_"分"
		.s inHematocritScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inHematocritScore'="" s inHematocritScore=inHematocritScore_"分"
		.s inWBCcountScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inWBCcountScore'="" s inWBCcountScore=inWBCcountScore_"分"
		.s inCHPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inCHPScore'="" s inCHPScore=inCHPScore_"分"
		.s inGCSScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inGCSScore'="" s inGCSScore=inGCSScore_"分"
		.s inFiO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inFiO2Score'="" s inFiO2Score=inFiO2Score_"分"
		.s inNBPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inNBPScore'="" s inNBPScore=inNBPScore_"分"
		
		.s inEyeOpeningScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inEyeOpeningScore'="" s inEyeOpeningScore=inEyeOpeningScore_"分"
		.s inVerbalResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inVerbalResponseScore'="" s inVerbalResponseScore=inVerbalResponseScore_"分"
		.s inMotorResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inMotorResponseScore'="" s inMotorResponseScore=inMotorResponseScore_"分"


		.s outTemperValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outHRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outRRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outPaO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outAaDO2ifFiO250Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outApachePHValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outSerumNaValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outSerumkValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outCreatinineARF2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outHematocritValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outWBCcountValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outCHPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s outGCSValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outFiO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outNBPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outARFValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ARFID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outEyeOpeningValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s outVerbalResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s outMotorResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		
		
		.s outTemperScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outTemperScore'="" s outTemperScore=outTemperScore_"分"
		.s outHRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outHRScore'="" s outHRScore=outHRScore_"分"
		.s outRRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outRRScore'="" s outRRScore=outRRScore_"分"
		.s outPaO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outPaO2Score'="" s outPaO2Score=outPaO2Score_"分"
		.s outAaDO2ifFiO250Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outAaDO2ifFiO250Score'="" s outAaDO2ifFiO250Score=outAaDO2ifFiO250Score_"分"
		.s outApachePHScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outApachePHScore'="" s outApachePHScore=outApachePHScore_"分"
		.s outSerumNaScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outSerumNaScore'="" s outSerumNaScore=outSerumNaScore_"分"
		.s outSerumkScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outSerumkScore'="" s outSerumkScore=outSerumkScore_"分"
		.s outCreatinineARF2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outCreatinineARF2Score'="" s outCreatinineARF2Score=outCreatinineARF2Score_"分"
		.s outHematocritScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outHematocritScore'="" s outHematocritScore=outHematocritScore_"分"
		.s outWBCcountScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outWBCcountScore'="" s outWBCcountScore=outWBCcountScore_"分"
		.s outCHPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outCHPScore'="" s outCHPScore=outCHPScore_"分"
		.s outGCSScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outGCSScore'="" s outGCSScore=outGCSScore_"分"
		.s outFiO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outFiO2Score'="" s outFiO2Score=outFiO2Score_"分"
		.s outNBPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outNBPScore'="" s outNBPScore=outNBPScore_"分"
	    
	    .s outEyeOpeningScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outEyeOpeningScore'="" s outEyeOpeningScore=outEyeOpeningScore_"分"
		.s outVerbalResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outVerbalResponseScore'="" s outVerbalResponseScore=outVerbalResponseScore_"分"
		.s outMotorResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outMotorResponseScore'="" s outMotorResponseScore=outMotorResponseScore_"分"

        .;i icuaId=2043 w inTemperValue ! outTemperValue b ;"5"
		.;i outDate-inWardDate<2 s inApacheScore="-",inSofaScore="-",inTemperValue="",inHRValue="",inRRValue="",inPaO2Value="",inAaDO2ifFiO250Value="",inApachePHValue="",inSerumNaValue="",inSerumkValue="",inCreatinineARF2Value="",inHematocritValue="",inWBCcountValue="",ageValue="",inCHPValue="",inGCSValue="",inFiO2Value="",inNBPValue=""
        .;i outDate-inWardDate<2 s inTemperScore="",inHRScore="",inRRScore="",inPaO2Score="",inAaDO2ifFiO250Score="",inApachePHScore="",inSerumNaScore="",inSerumkScore="",inCreatinineARF2Score="",inHematocritScore="",inWBCcountScore="",ageScore="",inCHPScore="",inGCSScore="",inFiO2Score="",inNBPScore=""
        .s ^TEMPWHL(EpisodeID)=EpisodeID_"^"_ctlocId
        .s ret=##class(web.DHCCLCScore).FindResidentAndAttendingCtcp(EpisodeID,ctlocId)
		.s ResidentCtcp=##class(web.DHCCLScore).GetUserName($p($g(^DHCICUArrange(+icuaId)),"^",28)) ;$p(ret,"^",1)
		.s AttendingCtcp=##class(web.DHCCLScore).GetUserName($p($g(^DHCICUArrange(+icuaId)),"^",29)) ;$p(ret,"^",2)
		.i ResidentCtcp="" s ResidentCtcp=$p(ret,"^",1)
		.i AttendingCtcp="" s AttendingCtcp=$p(ret,"^",2)
		.s FGF="_"
		.s Temper=inTemperValue_FGF_inTemperScore_"@"_outTemperValue_FGF_outTemperScore
		.s HR=inHRValue_FGF_inHRScore_"@"_outHRValue_FGF_outHRScore
		.s RR=inRRValue_FGF_inRRScore_"@"_outRRValue_FGF_outRRScore
		.s PaO2=inPaO2Value_FGF_inPaO2Score_"@"_outPaO2Value_FGF_outPaO2Score
		.s AaDO2ifFiO250=inAaDO2ifFiO250Value_FGF_inAaDO2ifFiO250Score_"@"_outAaDO2ifFiO250Value_FGF_outAaDO2ifFiO250Score
		.s ApachePH=inApachePHValue_FGF_inApachePHScore_"@"_outApachePHValue_FGF_outApachePHScore
		.s SerumNa=inSerumNaValue_FGF_inSerumNaScore_"@"_outSerumNaValue_FGF_outSerumNaScore
		.s Serumk=inSerumkValue_FGF_inSerumkScore_"@"_outSerumkValue_FGF_outSerumkScore
		.s CreatinineARF2=inCreatinineARF2Value_FGF_inCreatinineARF2Score_"@"_outCreatinineARF2Value_FGF_outCreatinineARF2Score
		.s Hematocrit=inHematocritValue_FGF_inHematocritScore_"@"_outHematocritValue_FGF_outHematocritScore
		.s WBCcount=inWBCcountValue_FGF_inWBCcountScore_"@"_outWBCcountValue_FGF_outWBCcountScore
		.s age=age_FGF_ageScore_"分"
		.s CHP=inCHPValue_FGF_inCHPScore_"@"_outCHPValue_FGF_outCHPScore
		.s GCS=inGCSValue_"分"_"@"_outGCSValue_"分"
		.s FiO2=inFiO2Value_FGF_inFiO2Score_"@"_outFiO2Value_FGF_outFiO2Score
		.s NBP=inNBPValue_FGF_inNBPScore_"@"_outNBPValue_FGF_outNBPScore

        .s EyeOpening=inEyeOpeningValue_FGF_inEyeOpeningScore_"@"_outEyeOpeningValue_FGF_outEyeOpeningScore
        .s VerbalResponse=inVerbalResponseValue_FGF_inVerbalResponseScore_"@"_outVerbalResponseValue_FGF_outVerbalResponseScore
        .s MotorResponse=inMotorResponseValue_FGF_inMotorResponseScore_"@"_outMotorResponseValue_FGF_outMotorResponseScore
		.s ARFValue=inARFValue
		.s icuaEndDate=$p($g(^DHCICUArrange(+icuaId)),"^",7)
		.i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/7:after end date?"
		.s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
		.s icuWardDesc=$P($g(^PAWARD(+icuBedId)),"^",2)
		.s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
		.s curWardDesc=$P($g(^PAWARD(+curWardId)),"^",2)
		.s icuBedSub=$p(icuBedId,"||",2)
		.s bedCode=$p($g(^PAWARD(+icuBedId,"BED",+icuBedSub)),"^",1)
		.i bedCode="" s bedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
		.s papmiId=$p($g(^PAADM($p(^DHCICUArrange(icuaId),"^",1))),"^",1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.;病案号
		.s deathoutDate=$p(^PAPER(papmiId,"ALL"),"^",13) //死亡日期
		.s deathoutTime=$p(^PAPER(papmiId,"ALL"),"^",8) //死亡时间
        .i (deathoutDate'="")&(deathoutTime'="") s death="是"
        .e  s death="否"
        .s In24hours=##class(web.DHCCLScore).GetFYQ(icuaId,fromDate,24)
 		.;s medicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	    .s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	    .s medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
		.s wardInDateTime=""
		.i startDate'="" d
			..s wardInDateTime=$zd(startDate,3)
			..s startTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
			..s wardInDateTime=wardInDateTime_" "_$zt(startTime,2)
		.s wardOutDateTime=""
		.i icuaEndDate'="" d
			..//s wardOutDateTime=$zd(icuaEndDate,3)
			..//s endTime=+$p($g(^DHCICUArrange(+icuaId)),"^",9)
			..//s wardOutDateTime=wardOutDateTime_" "_$zt(endTime)
		.;病人姓名
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s status=$p($g(^DHCICUArrange(+icuaId)),"^",18)
		.;病人诊断
		.s diagDesc=""
		.s tDiagdr=$p($g(^DHCICUArrange(+icuaId)),"^",20)
		.s num=$l(tDiagdr,"|")
		.f k=1:1:num  d
			..s Diagdr=$p(tDiagdr,"|",k)
			..q:Diagdr=""
			..i diagDesc="" s diagDesc=$p(^MRC("ID",Diagdr),"^",2)
			..e  s diagDesc=diagDesc_";"_$p(^MRC("ID",Diagdr),"^",2)
		.i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/10:OK!"
		.s tICUANormalStartDate=##class(web.DHCClinicCom).ConvertToDate($p(^DHCICUArrange(icuaId),"^",22),"")
		.s tICUANormalStartTime=##class(web.DHCClinicCom).ConvertToTime($p(^DHCICUArrange(icuaId),"^",23),"")
		.i outDateTime'="" s wardOutDateTime=$zd(outDate,3)_" "_$zt(outTime,2)
		.i $p(icuWardDesc,"-",2)'="" s icuWardDesc=$p(icuWardDesc,"-",2)
		.i $p(curWardDesc,"-",2)'="" s curWardDesc=$p(curWardDesc,"-",2)
		.;ADD mfc 20140207导出病人评分汇总项
		.;s ^tempICUScore(+icuBedId,icuaId)=patName_"^"_regNo_"^"_icuWardDesc_"^"_bedCode_"^"_wardInOutNote_"^"_wardInDateTime_"^"_inApacheScore_"^"_wardOutDateTime_"^"_outApacheScore_"^"_curWardDesc_"^"_icuaId
		.s tmpList((+icuBedId)_leavePat_bedCode,EpisodeID_"."_+icuaId)=$lb(wardInDateTime,wardOutDateTime,regNo,patName,icuWardDesc,status,bedCode,diagDesc,curWardDesc,icuaId,EpisodeID,medicareNo,wardInOutNote,inApacheScore,inSofaScore,outApacheScore,outSofaScore,ResidentCtcp,AttendingCtcp,Temper,HR,RR,PaO2,AaDO2ifFiO250,ApachePH,SerumNa,Serumk,CreatinineARF2,Hematocrit,WBCcount,age,CHP,GCS,EyeOpening,VerbalResponse,MotorResponse,FiO2,NBP,ARFValue,bedusedays,death,In24hours)
	    .;b ;"56"
	s bedCode=0,curWardId=""
	;f  s curWardId=$o(tmpList(curWardId)) q:curWardId=""  d
	f  s bedCode=$o(tmpList(bedCode)) q:bedCode=""  d 
		.s icuaId=0
		.f  s icuaId=$o(tmpList(bedCode,icuaId)) q:icuaId=""  d
			..d OutputRoww
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoww
	set Data=tmpList(bedCode,icuaId) //$lb(wardInDateTime,wardOutDateTime,regNo,patName,admLocDesc,status,bedCode,diagDesc,wardDesc,icuaId,EpisodeID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUArrangeScoreTestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUArrangeScoreTestExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUArrangeScoreTestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUArrangeScoreTestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      	whl
/// CreatDate：    	2014-03-27
/// Description： 	判断监护记录是否有有效数据
/// Table：        	DHC_ICU_Order
/// Input：        	userID,LocID
/// Output：       是Y否N
/// Return：       
ClassMethod CheckUserIfAtLoc(userID As %String = "", LocID As %String = "") As %String
{
	s objSSUser=$g(^SSU("SSUSR",+userID))
	q:objSSUser="" "N"
	s CareProvID=$p(objSSUser,"^",14)
	q:CareProvID="" "N"
	;s UserCode=$p(objSSUser,"^",1)
	;s UserDesc=$p(objSSUser,"^",2)
    ;s CareProvCode=$p($g(^CTPCP(+CareProvID,1)),"^",1)
    ;s CareProvDesc=$p($g(^CTPCP(+CareProvID,1)),"^",2)    	
   	q:(LocID'="")&&('$d(^RB("RES",0,"CTPCP",+CareProvID,LocID))) "N"
   	q "Y"
}

/// 入参：科室ctlocId, 重症病人icuaId, 开始日期startDate, 开始时间startTime, 结束日期endDate, 结束时间endTime, 是否发送ifSend
/// icuaId和ctlocId不能同时为空，icuaId优先级高;开始时间为""，默认前一天日期，结束日期为"",默认当天。
ClassMethod GetTemperatureData(ctlocId, icuaId, startDate, startTime, endDate, endTime, ifSend = "Y") As %Library.String
{
	//w ##class(web.DHCICUOrder).GetTemperatureData("",2798,"2014-05-06","00:00","2014-05-06","23:00")
	s retStr=0
	q:(ctlocId="")&(icuaId="") "数据为空!"
	s arrangeList=""
	s icuaIdList=icuaId
	i icuaIdList="" d
		.s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList("", "", ctlocId)
	q:icuaIdList="" retStr
	k timeList,mainSummaryList
	s icuctId="",summaryTime=0,arrangeList=""
	f  s icuctId=$o(^DHCICUC("Temperature",icuctId)) q:icuctId=""  d //配置时间体温单参数
		.s icuctList=^DHCICUC("Temperature",icuctId)
		.s icucriCode=$li(icuctList,1)
		.s IcucriList(icucriCode)=$li(icuctList,2)_"^"_$li(icuctList,6)_"^"_$li(icuctList,7)
		.s icuctType=$li(icuctList,8)
		.i icuctType="A" d
		..f i=1:1:$li(icuctList,3) d
				...s time=i*86400/$li(icuctList,3)+$li(icuctList,4)
				...i time'<86400 s time=time-86400
				...i '$d(arrangeList(time)) s arrangeList(time)=icucriCode
				...e  s arrangeList(time)=arrangeList(time)_"^"_icucriCode
		.;w "icucriId="_icucriCode_"^"_icuctType,!
		.s icucriId=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,""))
		.q:icucriId=""
		.i ($p($g(^DHCICUC("RecordItem",icucriId)),"^",12)="")&(icuctType="R") d
		    ..s icucriCode=$p(^DHCICUC("RecordItem",icucriId),"^",1)
			..f i=1:1:$li(icuctList,3) d
				...s time=i*86400/$li(icuctList,3)+$li(icuctList,4)
				...i time'<86400 s time=time-86400
				...i '$d(baseTimeList(time)) s baseTimeList(time)=icucriCode
				...e  s baseTimeList(time)=baseTimeList(time)_"^"_icucriCode
				...;w time_":"_baseTimeList(time),!
		.e  i ($p($g(^DHCICUC("RecordItem",icucriId)),"^",12)'="")&(icuctType="R") d
		    ..s icucriCode=$p(^DHCICUC("RecordItem",icucriId),"^",1)
			..s mainSummaryList($p(^DHCICUC("RecordItem",icucriId),"^",12))=icucriCode
			..;w icucriId_":",!
			..s summaryTime=$li(icuctList,4)
	i startDate="" s startDate=$h-1
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
		
	k sumList
	s wardCtlocId=ctlocId
	i wardCtlocId="" s wardCtlocId=##Class(web.DHCICUCom).GetWardCtlocId("",icuaId)
	s icucioiId=0
	f  s icucioiId=$o(^DHCICUC("IOItem",0,"Ctloc",wardCtlocId,icucioiId)) q:icucioiId=""  d
		.q:'$d(^DHCICUC("IOItem",icucioiId))
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",7)'="Y"
		.s mainIcucioiId=$p(^DHCICUC("IOItem",icucioiId),"^",9) //icucioiMainIcucioiId
		.q:mainIcucioiId=""
		.q:'$d(mainSummaryList(mainIcucioiId))
		.s mainIcucriId=mainSummaryList(mainIcucioiId)
		.s sumList(mainIcucriId)=0
		.i '$d(sumList(mainIcucriId,icucioiId)) s sumList(mainIcucriId,icucioiId)=$p(^DHCICUC("IOItem",icucioiId),"^",4)
		.e  s sumList(mainIcucriId,icucioiId)=sumList(mainIcucriId,icucioiId)_"^"_$p(^DHCICUC("IOItem",icucioiId),"^",4)
		.;w mainIcucriId_" mainIcucriId:"_icucioiId_","_sumList(mainIcucriId,icucioiId),!
	
	s $ZT="ERROR"
	k ^TMPICU("Temperature",$j)
	s seqNum=0
	f curDate=startDate:1:endDate d
		.q:curDate=""
		.s time=""
		.f  s time=$o(baseTimeList(time)) q:time=""  d
			..q:(curDate=startDate)&(time<startTime)
			..q:(curDate=endDate)&(time'<endTime)
			..f i=1:1:$l(icuaIdList,"^") d
				...s icuaId=$p(icuaIdList,"^",i)
				...q:icuaId=""
				...s num=..GetICUOrderDataByTime(icuaId, curDate, time, baseTimeList(time), .IcucriList)
				...//i num>0 w num_","_curDate_"/"_time_"/"_baseTimeList(time),!
	
	f curDate=startDate:1:endDate d
	.q:curDate=""
	.s time=""
	.f  s time=$o(arrangeList(time)) q:time=""  d
	..q:(curDate=startDate)&(time<startTime)
	..q:(curDate=endDate)&(time'<endTime)
	..f i=1:1:$l(icuaIdList,"^") d
	...s icuaId=$p(icuaIdList,"^",i)
	...q:icuaId=""
	...w time,arrangeList,!
	...i ("^"_arrangeList(time)_"^")[("^"_"PatHeight"_"^") s ^TMPICU("Temperature",$j,icuaId,curDate,time,"PatHeight")=$p(^DHCICUArrange(icuaId),"^",24)
	...i ("^"_arrangeList(time)_"^")[("^"_"PatWeight"_"^") s ^TMPICU("Temperature",$j,icuaId,curDate,time,"PatWeight")=$p(^DHCICUArrange(icuaId),"^",25)

	f curDate=startDate:1:endDate d
		.f i=1:1:$l(icuaIdList) d
			..s icuaId=$p(icuaIdList,"^",i)
			..q:icuaId=""
			..s icuoSttTime=""
			..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
				...q:(curDate=startDate)&(icuoSttTime<summaryTime) //开始时间入
				...q:(curDate=endDate)&(icuoSttTime'<summaryTime)
				...s summaryDate=curDate
				...i icuoSttTime'<summaryTime s summaryDate=curDate+1
				...s sttDateTime=curDate+(icuoSttTime/100000)
				...s icuoId=""
				...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
					....q:'$d(^DHCICUOrder(icuoId))
					....q:"ICDRU"[$p(^DHCICUOrder(icuoId),"^",25) 
					....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
					....s arcimId=$p(^DHCICUOrder(icuoId),"^",9)
					....q:(icucriId="")&(arcimId="")
					....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
					....q:mainIcuoId'=""
					....s mainIcucriId=""
					....f  s mainIcucriId=$o(sumList(mainIcucriId)) q:mainIcucriId=""  d
						.....s icucioiId=""
						.....f  s icucioiId=$o(sumList(mainIcucriId,icucioiId)) q:icucioiId=""  d
							......q:(("^"_sumList(mainIcucriId,icucioiId)_"^")'[("^"_icucriId_"^"))
							......s tmpStr=$g(^TMPICU("Temperature",$j,icuaId,summaryDate,summaryTime,mainIcucriId))+..GetSumValue(icucioiId,icuoId)
							......s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",4) //最后时间用户
							......s ^TMPICU("Temperature",$j,icuaId,summaryDate,summaryTime,mainIcucriId)=tmpStr
							......//w icuoId_"/"_mainIcucriId_"/"_curDate_" "_icuoSttTime_" sum:"_tmpStr,!
	
	//i $d(^DHCICUSendTemperture(icuaId,curDate,curTime))>0 s ifSent="Y"
	q:ifSend'="Y" retStr
	s icuaId=""
	f  s icuaId=$o(^TMPICU("Temperature",$j,icuaId)) q:icuaId=""  d
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.s date=""
		.f  s date=$o(^TMPICU("Temperature",$j,icuaId,date)) q:date=""  d
			..s time=""
			..f  s time=$o(^TMPICU("Temperature",$j,icuaId,date,time)) q:time=""  d
				...s icucriId=""
				...f  s icucriId=$o(^TMPICU("Temperature",$j,icuaId,date,time,icucriId)) q:icucriId=""  d
					....s qty=$p(^TMPICU("Temperature",$j,icuaId,date,time,icucriId),"^",1)
					....s qtyASBP=$p($g(^TMPICU("Temperature",$j,icuaId,date,time,"ASBP")),"^",1)
					....s qtyADBP=$p($g(^TMPICU("Temperature",$j,icuaId,date,time,"ADBP")),"^",1)
     				....i (qtyASBP'="")&(icucriId="NSBP") s qty=qtyASBP
					....i (qtyADBP'="")&(icucriId="NDBP") s qty=qtyADBP
					....i (qtyASBP'="")&&(qtyADBP'="") ;w "qtyASBP="_qtyASBP_"qtyADBP="_qtyADBP_"^"_date_"^"_time ,!
					....s userId=$p(^TMPICU("Temperature",$j,icuaId,date,time,icucriId),"^",2)
					....;q:'$d(IcucriList(icucriId))
					....;w icucriId,!
					....s obItemId=$p(IcucriList(icucriId),"^",1)
					....q:obItemId=""
					....w "insert:"_EpisodeID_","_obItemId_","_$zd(date,3)_","_$zt(time)_","_userId_","_qty_","_icucriId ,!
					....q:date<10000
					....s insertDate=date,insertTime=time
					....i insertTime=0 s insertDate=insertDate-1,insertTime=86399
					....s retStr=##class(web.DHCTHREEE).InsertData(EpisodeID,obItemId,$zd(insertDate,3),$zt(insertTime),userId,qty)

	q retStr
ERROR	; 
	q $ZE	           //得到系统返回的错误消息
 	//Quit "-1"
}

ClassMethod GetICUOrderDataByTime(icuaId As %String, date As %String, time As %String, icucriIdStr As %String, curIcucriList As %String) As %Library.String
{
	s num=0
	q:icuaId="" num
	q:icucriIdStr="" num
	;b ;"GetICUOrderDataByTime"
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s icuoId=""
	f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,icuoId)) q:icuoId=""  d
		.q:'$d(^DHCICUOrder(icuoId))
		.q:"ICDRU"[$p(^DHCICUOrder(icuoId),"^",25)  //状态P视为普通
		.s icucriId=$p(^DHCICUOrder(icuoId),"^",2)	//ICUO_ComOrd_Dr
		.s icucriId=$p(^DHCICUC("RecordItem",icucriId),"^",1)
		.q:icucriId=""
		.q:("^"_icucriIdStr_"^")'[("^"_icucriId_"^")	//接口未定义
		.;w "icuoId="_icuoId_" icucriId="_icucriId,!
		.s num=num+1
		.s ^TMPICU("Temperature",$j,icuaId,date,time,icucriId)=$p(^DHCICUOrder(icuoId),"^",11)_"^"_$p(^DHCICUOrder(icuoId),"^",4)
		.q:'$d(curIcucriList(icucriId))
		.q:$p(curIcucriList(icucriId),"^",3)=""
		.i $p(^DHCICUOrder(icuoId),"^",11)'<$p(curIcucriList(icucriId),"^",2) d
			..s addDate=date,addTime=time+$p(curIcucriList(icucriId),"^",3)
			..q:addTime<time
			..i addTime'<86400 d
				...s addTime=addTime-86400
				...s addDate=addDate+1
			..s addIcuoId=""
			..f  s addIcuoId=$o(^DHCICUOrder(0,"SttDateTime",addDate,icuaId,addTime,addIcuoId)) q:addIcuoId=""  d
				...q:'$d(^DHCICUOrder(addIcuoId))
				...q:$p(^DHCICUOrder(addIcuoId),"^",2)'=icucriId
				...q:"ICDRU"[$p(^DHCICUOrder(addIcuoId),"^",25)  //状态P视为普通
				...w addDate_"/"_addTime_"/"_addIcuoId,!
				...s ^TMPICU("Temperature",$j,icuaId,addDate,addTime,icucriId)=$p(^DHCICUOrder(addIcuoId),"^",11)_"^"_$p(^DHCICUOrder(addIcuoId),"^",4)
				...s num=num+1
	q num
}

ClassMethod GetSumValue(icucioiId, icuoId, value = "") As %String
{
	q:(icucioiId="")!(icuoId="") 0
	q:'$d(^DHCICUC("IOItem",icucioiId)) 0
	q:$p(^DHCICUC("IOItem",icucioiId),"^",7)'="Y" 0
	//q:'$d(^DHCICUC("RecordItem",icucriId)) 0
	q:$p(^DHCICUC("IOItem",icucioiId),"^",10)="TimePoint" 1
	i value="" d
		.i $p(^DHCICUC("IOItem",icucioiId),"^",12)="Qty" s value=$p(^DHCICUOrder(icuoId),"^",11)
		.i $p(^DHCICUC("IOItem",icucioiId),"^",12)="Volume" s value=$p(^DHCICUOrder(icuoId),"^",28)
	q:$p(^DHCICUC("IOItem",icucioiId),"^",11)="" value
	q $fn($p(^DHCICUC("IOItem",icucioiId),"^",11)*value,"",4)
}

// 获取主治医生管床医生某时间范围内的

ClassMethod FindResidentAndAttendingCtcp(paadm As %String, locid As %String, STDate As %String, STTime As %String) As %String
{
	k ^TEMPWHL("ResidentAndAttending")
    s ResidentCtcp="",AttendingCtcp="",rowid="",ResidentCtcpName="",AttendingCtcpName="",LocID=""
    s ResidentCtcpDr="",ResidentCtcpDr="",ctcpLocID="",tempsecend=0
	f  s rowid=$o(^PAADM(paadm,"TRANS",rowid)) q:rowid=""  d
	.s LocID=$p(^PAADM(paadm,"TRANS",rowid),"^",6)
	.;q:LocID'=locid
	.s TRANSMain=$p(^PAADM(paadm,"TRANS",rowid),"^",13)
	.s TRANSSTDate=$p(^PAADM(paadm,"TRANS",rowid),"^",1)
	.s TRANSSTTime=$p(^PAADM(paadm,"TRANS",rowid),"^",2)
	.s tempsecend=##class(web.DHCClinicCom).CalculateDuration(TRANSSTDate,TRANSSTTime,STDate,STTime,"S")
	.s secend=##class(web.DHCClinicCom).CalculateDuration(TRANSSTDate,TRANSSTTime,STDate,STTime,"S")
	.s ResidentCtcpDr=$p(^PAADM(paadm,"TRANS",rowid),"^",5) //主治医生
	.q:ResidentCtcpDr=""
	.s ctcpLocID=$p($g(^SSU("SSUSR",ResidentCtcpDr)),"^",4)
	.s AttendingCtcpName=##class(web.DHCDocInPatientList).GetHadeUniteDoc(ResidentCtcpDr,LocID)
	.s ResidentCtcpName=$P($g(^CTPCP(ResidentCtcpDr,1)),"^",2)
	.s ^TEMPWHL("ResidentAndAttending",$j,paadm,secend)= ResidentCtcpName_"^"_AttendingCtcpName
	.w ResidentCtcpName_"^"_AttendingCtcpName_"^"_$zd(TRANSSTDate)_"^"_$zt(TRANSSTTime)_"^"_$zd(STDate)_"^"_$zt(STTime)_"^"_secend,!
     s secend= $O(^TEMPWHL("ResidentAndAttending",$j,paadm,""),-1)
     q ^TEMPWHL("ResidentAndAttending",$j,paadm,secend)
}

// 打印抗生素

ClassMethod PrintAnti()
{
	// w ##class(web.DHCICUDebug).PrintAnti()
	/*
	w "MICU认为是抗生素而HIS认为是非抗生素的药品:",!
	s count=0
	s sub="" f  s sub=$O(^DHCANICUDEBUG("drug",sub))  q:sub=""  d
	.s arcimId=sub
	.i 1 d
	..s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
	..s count=count+1
	..;w count," ",sub," ",arcimDesc,!
	..s Tmp(+sub)=arcimDesc
	
	d Print
	k Tmp
	*/
	//
	w "HIS认为是抗生素而MICU认为是非抗生素的药品:",!
	s count=0
	s mArcId=0  f  s mArcId=$O(^ARCIM(mArcId)) q:mArcId=""  d
	.s subArcId=0  f  s subArcId=$O(^ARCIM(mArcId,subArcId)) q:subArcId=""  d
	..s arcimId=mArcId_"||"_subArcId
	..;s isAnti=$$IsAntibiotics(arcimId)
	..s isAnti=##class(web.DHCICUOrder).IsAntibiotic(arcimId)
	..i (isAnti) d
	...s arcimDesc=$p($g(^ARCIM(mArcId,subArcId,1)),"^",2)
	...s count=count+1
	...;w count," ",arcimId," ",arcimDesc,!
	...s Tmp(+arcimId)=arcimDesc
	d Print
	q "over"

IsAntibiotics(arcimId)
	s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcimId)
	q:PoisonRowid="" 0
	i PoisonRowid'="" s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
	s isAnti=0
	i ((PoisonCode="KSS1")||(PoisonCode="KSS2")||(PoisonCode="KSS3")) s isAnti=1
	q isAnti
Print
	s count=0
	s sub="" f  s sub=$O(Tmp(sub)) q:sub=""  d
	.s count=count+1
	.w count," ",sub," ",Tmp(sub),!
}

ClassMethod GetBalance(icuaId, fromDate, fromTime, toDate, toTime)
{
	// W ##class(web.DHCICUDebug).GetBalance(icuaId,fromDate,fromTime,toDate,toTime)
	i '$ISVALIDNUM(fromDate) s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	i '$ISVALIDNUM(fromTime) s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	i '$ISVALIDNUM(toDate) s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	i '$ISVALIDNUM(toTime) s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	s inVol=0,outVol=0
	s sub="" f  s sub=$O(^DHCICUC("IOItem",0,"Ctloc",88,sub)) q:sub=""  d
	.s itemStr=^DHCICUC("IOItem",sub)
	.s icucriId=$p(itemStr,"^",4)
	.q:icucriId=""
	.q:$d(TMPRecord(icucriId)) // 配置中是一种平衡一个配置向,一个常用医嘱ID会对应多条记录
	.
	.s TMPRecord(icucriId)=icucriId
	.s code=$p(itemStr,"^",2)
	.s flag=$p(itemStr,"^",3)
	.s value=##class(web.DHCICUOrder).GetLastValueList(icuaId,icucriId,fromDate,fromTime,toDate,toTime,1000*1000,1,"Sum")
	.q:value=""
	.w flag_" "_sub_" "_code_"("_icucriId_")"_":"_value,!
	.i flag="I" s inVol=+value+inVol
	.e  s outVol=+value+outVol
	q inVol_"/"_outVol
}

// 根据就诊号打印出所有检验、检查医嘱

ClassMethod GetLabRes(EpisodeID)
{
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" // 未开医嘱
	// 根据名称查找码表ID
	s mArcId=""  f  s mArcId=$O(^ARCIM(mArcId)) q:mArcId=""  d
	.s subArcId=""  f  s subArcId=$O(^ARCIM(mArcId,subArcId)) q:subArcId=""  d
	..s arcimId=mArcId_"||"_subArcId
	..
	// 根据医嘱码表索查找所开医嘱
}

ClassMethod TestStandardCodeIndex()
{
	// w ##class(web.DHCICUDebug).TestStandardCodeIndex()
	k ^tmpicudebug("StandCode")
	k ^tmpicudebug("Code")
	s sub="" f  s sub=$O(^TTAB("TC",sub)) q:sub=""  d
	.s itemStr=$g(^TTAB("TC",sub))
	.s standCode=$p(itemStr,"\",18)
	.s abbCode=$p(itemStr,"\",12)
	.w abbCode,!
	.q:abbCode=""
	.s ^tmpicudebug("StandCode",abbCode)=sub
	.s ^tmpicudebug("Code",abbCode)=sub
	q "OK"
}

/// 根据SVR修改SVRI
ClassMethod ModifySVRI(srcId, dstId)
{
	// w ##class(web.DHCICUDebug).ModifySVRI(5572,5556)
	s date="" f  s date=$O(^DHCICUOrder(0,"RecordItem",srcId,date),-1) q:(date="")  d
	.s icuaId ="" f  s icuaId=$O(^DHCICUOrder(0,"RecordItem",srcId,date,icuaId)) q:(icuaId="")  d
	..s time ="" f  s time=$O(^DHCICUOrder(0,"RecordItem",srcId,date,icuaId,time)) q:(time="")  d
	...s sub ="" f  s sub=$O(^DHCICUOrder(0,"RecordItem",srcId,date,icuaId,time,sub)) q:(sub="")  d
	....s editFlag=$p($g(^DHCICUOrder(sub)),"^",5)
	....q:($zabs(+$h-date)<=30)
	....q:editFlag=""
	....q:"NE"[editFlag
	....s svr=$p($g(^DHCICUOrder(sub)),"^",11)
	....;获取这个时间点的BSA数据
	....s bsa=##class(web.DHCICUOrder).GetRecordValueByScope(icuaId,6737,date,time,0)
	....s value=svr*bsa
	....q:bsa<=0
	....w "Time"_$zd(date)," ",$zt(time)," SVR:",svr,"BSA:",bsa,"SVRI:",value,!
	....;b ////Start insert ///
	....w ##class(web.DHCICUCom).Insert2ICUOrder(icuaId, dstId, date, time,value, "")
	q "what"
}

/// 取检验数据
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的显示分类ancvcCodeStr(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
Query FindIcuLab(icuaId As %String, startDate As %String, endDate As %String, ancvcCodeStr As %String = "", testCodeStr As %String(MAXLEN=20000) = "", EpisodeID As %String = "", ctlocId As %String = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,RecordCatId,DocUserId,AncoDesc,ArcimDesc,ArrangeId,Frequency,OeoriNote,Abbreviate,OrderItemNote,ParaItemId,durationDay") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUView","FindIcuLab",745,$h-10,$h,"Lab","WBC^HCT^RBC^ALT")
ClassMethod FindIcuLabExecute(ByRef qHandle As %Binary, icuaId As %String, startDate As %String, endDate As %String, ancvcCodeStr As %String = "", testCodeStr As %String(MAXLEN=20000) = "", EpisodeID As %String = "", ctlocId As %String = "") As %Status
{
	s firstDT=$h
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	
	k ^TMPICU("Lab",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=0
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=83999
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	
	s icucriIdStr="",ancvcIdStr=""
	i ancvcCodeStr'="" d
		.f i=1:1:$l(ancvcCodeStr,"^") d
			..s ancvcCode=$p(ancvcCodeStr,"^",i)
			..q:ancvcCode=""
			..s $p(ancvcIdStr,"^",i)=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
	w ancvcIdStr,!
	
	s curDateTime=$h+($p($h,",",2)/100000)
	s bloodGasStr="PH^PCO2^PO2^HCO3-^LAC^K+^NA+^GLU^CA++^SO2^GAP"
	s icuaIdList=icuaId
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:EpisodeID=""
		.f j=1:1:$l(ancvcCodeStr,"^") d
			..s ancvcCode=$p(ancvcCodeStr,"^",j)
			..q:ancvcCode=""
			..s ancvcId=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
			..q:ancvcId=""
			..s icuaStartDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
			..i icuaStartDate<startDate s icuaStartDate=startDate
			..s seq=0,ifByDateTime="Y"
			..f k=1:1:$l(testCodeStr,"^") d
				...s testCode=$p(testCodeStr,"^",k)
				...q:testCode=""
				...i ("^"_bloodGasStr_"^")[("^"_testCode_"^") d
					....w "------------",testCode,!
					....s icucriId=$o(^DHCICUC("RecordItem",0,"Code",testCode,""))
					....q:icucriId=""
					....f date=startDate:1:endDate d
						.....s time=""
						.....f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")  d
							......s icuoId=""
							......f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
								.......q:'$d(^DHCICUOrder(icuoId))
								.......s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
								.......s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
								.......s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
								.......s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
								.......s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
								.......s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
								.......s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
								.......q:"I"[mainIcuoEditFlag //旧版本ICD
								.......s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
								.......s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
								.......q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) //开始时间点不计
								.......q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) //结束时间点计入
								.......s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
								.......q:(icucriId="")&(ancvcId="")
								.......
								.......s curId=icuoId //s tmpStr=icuoId_"^"
								.......s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
								.......s curUserId=$p(^DHCICUOrder(icuoId),"^",4) // tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
								.......s curStartDate=$zd(icuoStartDate,3) //s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"			//ICUO_StartDate
								.......s curStartTime=$zt(icuoStartTime) //s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
								.......s curEndDate=$zd(icuoEndDate,3) //s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
								.......s curEndTime=$zt(icuoEndTime) //s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
								.......s curNote=$p(^DHCICUOrder(icuoId),"^",10) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
								.......s curQty=$p(^DHCICUOrder(icuoId),"^",11) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
								.......
								.......s uomId=$p(^DHCICUOrder(icuoId),"^",12)
								.......s ancvcDesc=""
								.......i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
								.......s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
								.......s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
								.......s curEditFlag=$p(^DHCICUOrder(icuoId),"^",25) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
								.......s curDocUserId=$p(^DHCICUOrder(icuoId),"^",27) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
								.......s icuoSource=$p(^DHCICUOrder(icuoId),"^",29) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
								.......s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
								.......s curAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
								.......s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38) //s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47
								.......s oreGroup=""
								.......s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
								.......s curId=icuoId
								.......s icuodSub=0
								.......s ^TMPICU("Lab",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_testCode_"l",+icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,ancvcId,icuoSpeed,curDocUserId,icucriDesc,arcimDesc,icuaId,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoIcupiDr)
					....
					....
				...e  d
					....s testQtyStr=##class(web.DHCClinicCom).GetTestResult(EpisodeID, "", "", testCode, startDate, startTime, endDate, endTime, 0)
					....//w startDate_"/"_endDate_"/",!
					....//w "/"_testQtyStr_"/",!
					....f l=1:1:$l(testQtyStr,"#") d
						.....s testQty=$p(testQtyStr,"#",l)
						.....w "testQty="_testQty,!
						.....q:testQty=""
						.....q:$$GetLabData("Y")<0
	s count=0
	s icuaId="" f  s icuaId=$o(^TMPICU("Lab",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^TMPICU("Lab",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Lab",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^TMPICU("Lab",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             	....s Data=^TMPICU("Lab",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....d OutputIcuLab
	             	....s count=count+1
	w count,"/"_firstDT,"/"_$h,!
	b 
 	s qHandle=$lb(0,repid,0)
	q $$$OK
	
GetLabData(ifByDateTime = "")
	//s curIcuoId=0,icuoId=""
	//f  s curIcuoId=$o(^DHCICUOrder(0,"OEORE",oeoreId,icuaId,"")) q:icuoId=""  d
	//	.q:"ICD"[$p(^DHCICUOrder(curIcuoId),"^",25)
	//	.s icuoId=curIcuoId
	
	s icuoStartDate=$p($g(testQty),"\",4)
	q:icuoStartDate<1 -3
	s icuoStartTime=$p($g(testQty),"\",5)
	s icuoEndDate=icuoStartDate
	s icuoEndTime=icuoStartTime
	s icuoUpdateDate=icuoStartDate
	s icuoUpdateTime=icuoStartTime
	s arcimId=testCode

	i (icuoEndDate=icuoStartDate)&(icuoEndTime<icuoStartTime) s icuoEndTime=icuoStartTime

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	w icuoEndDate_"/"_icuoStartDate_"/"_icuoEndTime_"/"_icuoStartTime,!
	//w icuoStartDateTime_"/"_icuoEndDateTime_"/"_sttDateTime_"/"_icuoStartTime,"/"_icuoEndTime,!
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	
	s curId="" //icuoId
	s curIcucriId="" //icucriId
	s curUserId="" //$p($g(^DHCICUOrder(+icuoId)),"^",4)
	s curStartDate=$zd(icuoStartDate,3)
	s curStartTime=$zt(icuoStartTime)
	s curEndDate=$zd(icuoEndDate,3)
	s curEndTime=$zt(icuoEndTime)
	s curNote=$p($g(testQty),"\",1)
	s curQty="" //
	s unitUomId="" 
	
	s uomId=""
	s icucriId=0,icuoId=0
	s ancvcDesc="",oeorditemStr=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	s curUpdateDate=$zd(icuoUpdateDate,3)
	s curUpdateTime=$zt(icuoUpdateTime)
	s curEditFlag=$p($g(^DHCICUOrder(+icuoId)),"^",25)
	s curDocUserId=$p($g(^DHCICUOrder(+icuoId)),"^",27)
	s icuoSource=$p($g(^DHCICUOrder(+icuoId)),"^",29)
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)
	s arcimDesc="" //$p($g(^ARCIM(+arcimId,1,1)),"^",2)
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s prcfrDesc=$p(oeorditemStr,"^",15)
	s oeoriNote=$p(oeorditemStr,"^",17)
	s curAbbreviate=$p($g(^DHCICUOrder(+icuoId)),"^",34)
	s curAbbreviate=""
	s icuoOrdItemNote=$p($g(^DHCICUOrder(+icuoId)),"^",35)
	s icuoIcupiDr=$p($g(^DHCICUOrder(+icuoId)),"^",38)
	
	s oreGroup=""
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curId=icuoId
	s icuodSub=0
	s ^TMPICU("Lab",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_testCode_"l",+icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,ancvcId,icuoSpeed,curDocUserId,icucriDesc,arcimDesc,icuaId,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoIcupiDr)
	q 0

OutputIcuLab
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindIcuLabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuLabExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIcuLabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuLabExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// 

// 输出DHC_ICU_CollectData表中血压有问题的数据

ClassMethod LogErrorIBP()
{
	// w ##class(web.DHCICUDebug).LogErrorIBP()
	k ^tmpdebug("dtj-Collect")
	s index=0
	s icuaId="" f  s icuaId=$O(^DHCICUArrange(0,"CData",icuaId),-1) q:((icuaId="")||(index>2000))  d
	.s date="" f  s date=$O(^DHCICUArrange(0,"CData",icuaId,date),-1) q:date=""  d
	..s time="" f  s time=$O(^DHCICUArrange(0,"CData",icuaId,date,time),-1) q:time=""  d
	...
	...s sub="" f  s sub=$O(^DHCICUArrange(0,"CData",icuaId,date,time,sub)) q:sub=""  d
	....
	....s itemStr=$g(^DHCICUArrange(icuaId,"C",sub))
	....s itemId=$p(itemStr,"^",1)
	....q:itemId'=5337
	....s sys=$p(itemStr,"^",5)
	....s dia=##class(web.DHCICUOrder).FindCollectData(icuaId,date,time,5338)
	....s mean=##class(web.DHCICUOrder).FindCollectData(icuaId,date,time,5339)
	....s calMean=(sys*(1/4))+(dia*(3/4))
	....
	....i ((mean>=sys)||(mean<=dia)) d
	.....
	.....s str=sub_"icuaId:"_icuaId_"  "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)_"  "_sys_"/"_dia_"/"_mean
	.....w str,!
	.....s dateStr=##class(web.DHCClinicCom).ConvertToDate(date)
	.....s ^tmpdebug("dtj-Collect",dateStr,icuaId,index)=str
	.....s index=index+1
	q "Over"
}

// 从DHC_ICU_Order表中查找出血压参数有问题的数据(平均压不与舒张压和收缩压推导出的值一至的值)

ClassMethod LogErrorIBPData()
{
	// w ##class(web.DHCICUDebug).LogErrorIBPData()
	k ^tmpdebug("dtj")
	s recordId=5337 ;有创收缩压 
	s index=1
	s date="" f  s date=$O(^DHCICUOrder(0,"RecordItem",recordId,date),-1) q:date=""  d
	.s icuaId="" f  s icuaId=$O(^DHCICUOrder(0,"RecordItem",recordId,date,icuaId)) q:icuaId=""  d
	..s time="" f  s time=$O(^DHCICUOrder(0,"RecordItem",recordId,date,icuaId,time)) q:time=""  d
	...s sub="" f  s sub=$O(^DHCICUOrder(0,"RecordItem",recordId,date,icuaId,time,sub)) q:sub=""  d
	....s itemStr=$g(^DHCICUOrder(sub))
	....s source=$p(itemStr,"^",29)
	....q:source'="I"
	....s flag=$p(itemStr,"^",25)
	....q:((flag'="N")&&(flag'="E"))
	....
	....s sys=$p(itemStr,"^",11)
	....s dia=..FindICUOrder(icuaId,date,time,5338)
	....s mean=..FindICUOrder(icuaId,date,time,5339)
	....s calMean=(sys*(.2783560660445082556))+(dia*(.7966618808327351041))
	....s abs=$zabs(calMean-mean)
	....i ((mean>=sys)||(mean<=dia)) d
	.....
	.....s str=index_":  icuaId:"_icuaId_"  "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)_"  "_sys_"/"_dia_"/"_mean
	.....w str,!
	.....s ^tmpdebug("dtj",icuaId,date,index)=str
	.....s index=index+1
	q "Over"
}

ClassMethod FindICUOrder(icuaId, date, time, dstRecordId)
{
	s value="",recordId=""
	s sub="" f  s sub=$O(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,sub)) q:((sub="")||(dstRecordId=recordId))  d
	.s itemStr=$g(^DHCICUOrder(sub))
	.s source=$p(itemStr,"^",29)
	.;q:source'="I"
	.s flag=$p(itemStr,"^",25)
	.q:((flag'="N")&&(flag'="E"))
	.s value=$p(itemStr,"^",11)
	.s recordId=$p(itemStr,"^",2)
	i dstRecordId'=recordId s value=""
	q value
}

// 是否是有效的数据

ClassMethod IsValidNBP(icuaId, recordItemId, date, time, sys, dia, mean)
{
	// w ##class(web.DHCICUDebug).IsValidNBP(icuaId,recordItemId,date,time,value)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s isValid=0
	s NBPs="NSBP",NBPd="NDBP",NBPm="NMBP"
	i $g(^DHCCLSet("ICU","NBPs"))'="" s NBPs=$g(^DHCCLSet("ICU","NBPs"))
	i $g(^DHCCLSet("ICU","NBPd"))'="" s NBPs=$g(^DHCCLSet("ICU","NBPd"))
	i $g(^DHCCLSet("ICU","NBPm"))'="" s NBPs=$g(^DHCCLSet("ICU","NBPm"))
	
	s code=$p($g(^DHCICUC("RecordItem",recordItemId)),"^",1)
	
	i ((code=NBPs)||(code=NBPd)||(code=NBPm)) d
	.s lastValue=$g(^tmpdhcicudebug("NBP",icuaId,code))
	.i lastValue'=value d
	..s ^tmpdhcicudebug("NBP",icuaId,code,date,time)=value
	..s ^tmpdhcicudebug("NBP",icuaId,code,date,time,$h)=value
	..s isValid=1
	..
	q isValid
}

/// 获取病人的历次sofa评分
/// w ##class(web.DHCICUDebug).GetSofaToTal("2014-12-1","2014-12-04","28")
ClassMethod GetSofaToTal(inquiryFromDate, inquiryToDate, IcuDept) As %String
{
	;SOFATotal_"^"_PaO2V_"^"_PaO2ScoreV_"^"_SoterocyteV_"^"_SoterocyteScoreV_"^"_HematoidinV_"^"_HematoidinScoreV_"^"_HypotensionV_"^"_HypotensionScoreV_"^"_GCSV_"^"_CNSV_"^"_CreatinineAndUrineV_"^"_CreatinineAndUrineScoreV
	q:inquiryFromDate=""
	q:inquiryToDate=""
	k ^tmpICUGetSofa,^tmpICUGetSofaNew
	s inquiryFromDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryFromDate)
	s inquiryToDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryToDate)
	s icucriCodeList="SOFATotal"_"^"_"SOFAPaO2/FiO2"_"^"_"SOFAPaO2/FiO2Score"_"^"_"SOFASoterocyte"_"^"_"SOFASoterocyteScore"_"^"_"SOFAHematoidin"_"^"_"SOFAHematoidinScore"_"^"_"SOFAHypotension"_"^"_"SOFAHypotensionScore"_"^"_"SOFAGCS"_"^"_"SOFACNS"_"^"_"SOFACreatinineAndUrine"_"^"_"SOFACreatinineAndUrineScore"
	s icucriId=""	
	f i=1:1:$l(icucriCodeList,"^") d
	.s icucriCode=$p(icucriCodeList,"^",i)
	.i icucriCode'=+icucriCode s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode(icucriCode)
	.q:icucriId=""	
	.s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)	
	.q:icucriDataField=""
	.f aSdate=inquiryFromDate:1:inquiryToDate d
	..s icuaId=0
	..f  s icuaId=$o(^DHCICUOrder(0,"RecordItem",icucriId,aSdate,icuaId)) q:(icuaId="")  d
	...q:'$d(^DHCICUArrange(icuaId))
	...s PatDept=$p($g(^DHCICUArrange(+icuaId)),"^",2)
	...q:(PatDept'="")&(("^"_PatDept_"^")'[("^"_(+IcuDept)_"^"))
	...;q:##class(web.DHCICUOrder).CheckValidICUAID(icuaId)="N" //判断数据是否有效	
	...s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	...s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	...s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	...q:oeordId=""
	...s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	...s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)	
	...;s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	...s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	...s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	...s icuBed=$P($g(^PAWARD(+icuBedId,"BED",+$P(icuBedId,"||",2))),"^",1)
	...s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	...s birDate=$p($g(^PAPER(papmiId,"ALL")),"^",6),value=$zd(birDate,3) //出生日期
	...;w icucriId_"/"_aSdate_"/"_icuaId,!
	...s stTime=0, icucriDesc="",patInfo="",recordValue=""
	...f  s stTime=$o(^DHCICUOrder(0,"RecordItem",icucriId,aSdate,icuaId,stTime)) q:(stTime="")  d
	....;b ;5
	....s icuoId=0
	....f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,aSdate,icuaId,stTime,icuoId)) q:(icuoId="")  d	
	.....s viewCatDr=$p(^DHCICUOrder(icuoId),"^",16)			
	.....q:(viewCatDr'="")&&(viewCatDr'="233")
	.....q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)	
	.....s date=$p(^DHCICUOrder(icuoId),"^",5)
	.....s time=$p(^DHCICUOrder(icuoId),"^",6)
	.....;w b ;2
	.....q:(date<aSdate)
	.....q:(date>inquiryToDate)
	.....s value=##class(web.DHCICUOrder).GetRecordValueSingle(icuoId,$p($g(^DHCICUC("RecordItem",icucriId)),"^",24),"","")
	.....;q:value=""	
	.....s criDesc=$p(^DHCICUC("RecordItem",icucriId),"^",2)
	.....;q:criDesc=""
	.....i recordValue="" s recordValue=criDesc_"^"_value
	.....e  s recordValue=recordValue_"^"_criDesc_"^"_value
	.....;i icucriDesc="" s icucriDesc=criDesc	
	.....s icucriDesc=icucriDesc_"^"_criDesc
	.....s patInfo=patName_"^"_regNo_"^"_papmiMedicare_"^"_PatDept_"^"_icuBed_"^"_patSex
	...s ^tmpICUGetSofa(icuaId,aSdate,i,icucriId)=$zd(aSdate,3)_"^"_patInfo_"^"_recordValue
	..;i 
	...;w $g(^tmpICUGetSofa(icuaId,aSdate,icucriId))
	.;s ^tmpIcuCriIDList(i)=	icucriId
	s icuaId=0
	f  s icuaId=$o(^tmpICUGetSofa(icuaId)) q:(icuaId="")  d
	.s aSdate=0
	.f  s aSdate=$o(^tmpICUGetSofa(icuaId,aSdate)) q:(aSdate="")  d
	..s sqoNo=0,sofaTotalV="",patInfo="",tmpsqoNo=0
	..f  s sqoNo=$o(^tmpICUGetSofa(icuaId,aSdate,sqoNo)) q:(sqoNo="")  d
	...s emptyIf=0	
	...i ((sqoNo-tmpsqoNo)>1) d
	....i sofaTotalV'="" s sofaTotalV=sofaTotalV_"^"
	....s emptyIf=1
	....f j=1:1:(sqoNo-tmpsqoNo-1) d
	.....s sofaTotalV=sofaTotalV_"^"_"^"	
	...i (icuaId=745)&&(aSdate=63436)&&(sqoNo=8) w sofaTotalV,!
	...s tmpsqoNo=sqoNo		
	...s icucriId=0
	...f  s icucriId=$o(^tmpICUGetSofa(icuaId,aSdate,sqoNo,icucriId)) q:(icucriId="")  d
	....s tmppatInfo=$g(^tmpICUGetSofa(icuaId,aSdate,sqoNo,icucriId))
	....s stDate=$p(tmppatInfo,"^",1)
	....s patName=$p(tmppatInfo,"^",2)
	....s regNo=$p(tmppatInfo,"^",3)
	....s papmiMedicare=$p(tmppatInfo,"^",4)
	....s PatDept=$p(tmppatInfo,"^",5)
	....s icuBed=$p(tmppatInfo,"^",6)
	....s patSex=$p(tmppatInfo,"^",7)
	....s totalDesc=$p(tmppatInfo,"^",8)
	....s totalValue=$p(tmppatInfo,"^",9)
	....s patInfo=stDate_"^"_patName_"^"_regNo_"^"_papmiMedicare_"^"_PatDept_"^"_icuBed_"^"_patSex	
	....i emptyIf=0 d 
	.....i sofaTotalV="" s sofaTotalV=totalDesc_"^"_totalValue
	.....e  s sofaTotalV=sofaTotalV_"^"_totalDesc_"^"_totalValue
	....e  d
	.....s sofaTotalV=sofaTotalV_totalDesc_"^"_totalValue
	...;w sofaTotalV,!
	..s ^tmpICUGetSofaNew(icuaId,aSdate)=patInfo_"^"_sofaTotalV
	q "OK"
	/*q:inquiryFromDate=""
	q:inquiryToDate=""
	k ^tmpICUGetSofa
	s inquiryFromDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryFromDate)
	s inquiryToDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryToDate)
	f aSdate=inquiryFromDate:1:inquiryToDate d
	.s icuaId=""	
	.f  s icuaId=$o(^DHCICUArrange(0,"SDate",aSdate,icuaId)) q:icuaId=""  d
	..q:'$d(^DHCICUArrange(icuaId))
	..s PatDept=$p($g(^DHCICUArrange(+icuaId)),"^",2)	
	..q:(PatDept'="")&(("^"_PatDept_"^")'[("^"_(+IcuDept)_"^"))
	..q:##class(web.DHCICUOrder).CheckValidICUAID(icuaId)="N" //判断数据是否有效	
	..s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	..q:oeordId=""
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)	
	..s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	..s icuBed=$P($g(^PAWARD(+icuBedId,"BED",+$P(icuBedId,"||",2))),"^",1)
	..s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	..s birDate=$p($g(^PAPER(papmiId,"ALL")),"^",6),value=$zd(birDate,3) //出生日期
	..
	..s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..q:inDateTime=""
	..s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..i outDateTime="" s outDate=+$h,outTime=$p($h,",",2),outDateTime=outDate_"^"_outTime	
	..s retStr=$$FindIcuInquiryByWardId(icuaId, PatDept, EpisodeID ,regNo,papmiMedicare,patName,icuBed,patSex,inDateTime,outDateTime,aSdate,inquiryToDate)
	q "OK"
FindIcuInquiryByWardId(icuaId, PatDept, EpisodeID ,regNo,papmiMedicare,patName,icuBed,patSex,inDateTime,outDateTime,aSdate,inquiryToDate)	
	s inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	s outDate=$p(outDateTime,"^"),outTime=$p(outDateTime,"^",2)
	s stdate=inDate,viewCatDr=""
	s icuoId=0
	f  s IcuoId=$o(^DHCICUOrder(0,"Arr",icuaId,icuoId)) q:(icuoId="")  d
		.i icuoId=36923526 b ;0
		.s viewCatDr=$p(^DHCICUOrder(icuoId),"^",16)
		.i viewCatDr=233 b ;1		
		.q:(viewCatDr'="")&&(viewCatDr'="233")
		.;s userid=$p(^DHCICUOrder(icuoId),"^",4)
		.;q:userid=""	
		.q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
		.b ;2
		.s date=$p(^DHCICUOrder(icuoId),"^",5)
		.s time=$p(^DHCICUOrder(icuoId),"^",6)
		.b ;3
		.q:(date<aSdate)
		.q:(date>inquiryToDate)
		.b ;4
		.;q:(date<inDate)
		.;q:(date>outDate)
		.;q:(date=inDate)&(time<inTime)
		.;q:(date=outDate)&(time>outTime)
		.i icuaId=4701 w $zd(inDate,3)_"/"_$zt(inTime,2)_":"_$zd(outDate,3)_"/"_$zt(outTime,2)_":"_$zd(date,3)_"/"_$zt(time,2),!					
		.s SOFATotal=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFATotal",stdate,inTime,stdate+1,inTime,"First","","","","") //SOFA评分
		.s PaO2V=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFAPaO2/FiO2",stdate,inTime,stdate+1,inTime,"First","","","","") //氧合指数
		.s PaO2ScoreV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFAPaO2/FiO2Score",stdate,inTime,stdate+1,inTime,"First","","","","") //分数：呼吸
		.s SoterocyteV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFASoterocyte",stdate,inTime,stdate+1,inTime,"First","","","","") //血小板
		.s SoterocyteScoreV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFASoterocyteScore",stdate,inTime,stdate+1,inTime,"First","","","","") //分数：凝血
		.s HematoidinV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFAHematoidin",stdate,inTime,stdate+1,inTime,"First","","","","") //胆红素
		.s HematoidinScoreV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFAHematoidinScore",stdate,inTime,stdate+1,inTime,"First","","","","") //分数：肝脏
		.s HypotensionV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFAHypotension",stdate,inTime,stdate+1,inTime,"First","","","","") //低血压
		.s HypotensionScoreV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFAHypotensionScore",stdate,inTime,stdate+1,inTime,"First","","","","") //分数：心血管
		.s GCSV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFAGCS",stdate,inTime,stdate+1,inTime,"First","","","","") //Glasgow昏迷评分
		.s CNSV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFACNS",stdate,inTime,stdate+1,inTime,"First","","","","") //分数：CNS
		.s CreatinineAndUrineV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFACreatinineAndUrine",stdate,inTime,stdate+1,inTime,"First","","","","") //肌酐umol/L
		.s CreatinineAndUrineScoreV=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFACreatinineAndUrineScore",stdate,inTime,stdate+1,inTime,"First","","","","") //分数：肾脏
		.s stdate=stdate+1
		.s ^tmpICUGetSofa(IcuoId)=$zd(stdate,3)_"^"_patName_"^"_regNo_"^"_papmiMedicare_"^"_PatDept_"^"_icuBed_"^"_patSex_"^"_inDateTime_"^"_outDateTime_"^"_SOFATotal_"^"_PaO2V_"^"_PaO2ScoreV_"^"_SoterocyteV_"^"_SoterocyteScoreV_"^"_HematoidinV_"^"_HematoidinScoreV_"^"_HypotensionV_"^"_HypotensionScoreV_"^"_GCSV_"^"_CNSV_"^"_CreatinineAndUrineV_"^"_CreatinineAndUrineScoreV
		.;w $g(^tmpICUGetSofa(IcuoId)) 
	q 0*/
}

// 备份ICU码表数据

ClassMethod BakICUConfigData(tag = "")
{
	// w ##class(web.DHCICUDebug).BakICUConfigData("bak")
	i tag'="" s date=tag
	e  s date=$h
	w "Kill:"_"^dhcicuanbak(""dhcicuc"","""_date_""")",!
	k ^dhcicuanbak("dhcicuc",date)
	w "开始导DHCICUC",!
	m ^dhcicuanbak("dhcicuc",date,"IOItem")=^DHCICUC("IOItem")
	m ^dhcicuanbak("dhcicuc",date,"Level")=^DHCICUC("Level")
	m ^dhcicuanbak("dhcicuc",date,"OrdReason")=^DHCICUC("OrdReason")
	m ^dhcicuanbak("dhcicuc",date,"OrdMapping")=^DHCICUC("OrdMapping")
	m ^dhcicuanbak("dhcicuc",date,"Property")=^DHCICUC("Property")
	m ^dhcicuanbak("dhcicuc",date,"RecordItem")=^DHCICUC("RecordItem")
	m ^dhcicuanbak("dhcicuc",date,"SItem")=^DHCICUC("SItem")
	m ^dhcicuanbak("dhcicuc",date,"Stat")=^DHCICUC("Stat")
	m ^dhcicuanbak("dhcicuc",date,"Temperature")=^DHCICUC("Temperature")
	m ^dhcicuanbak("dhcicuc",date,"VSCat")=^DHCICUC("VSCat")
	m ^dhcicuanbak("dhcicuc",date,"ViewCat")=^DHCICUC("ViewCat")
	w "开始导DHCICUPara",!
	k ^dhcicuanbak("dhcicupara",date)
	m ^dhcicuanbak("dhcicupara",date,1)=^DHCICUPara(1)
	m ^dhcicuanbak("dhcicupara",date,2)=^DHCICUPara(2)
	m ^dhcicuanbak("dhcicupara",date,3)=^DHCICUPara(3)
	m ^dhcicuanbak("dhcicupara",date,4)=^DHCICUPara(4)
	w "开始导DHCICUCLC",!
	k ^dhcicuanbak("dhccl",date)	  
	m ^dhcicuanbak("dhccl",date,"Hospital")=^DHCCLC("Hospital") 
	m ^dhcicuanbak("dhccl",date,"MedicalSafety")=^DHCCLC("MedicalSafety") 
	m ^dhcicuanbak("dhccl",date,"Score")=^DHCCLC("Score")
	m ^dhcicuanbak("dhccl",date,"ScoreLink")=^DHCCLC("ScoreLink")
	w "开始导DHCANC(CType)",!
	k ^dhcicuanbak("dhcanc",date)	
	m ^dhcicuanbak("dhcanc",date,"CType")=^DHCANC("CType")
	q "Over"
}

// 导入ICU码表数据 正式库不要使用！！

ClassMethod LoadICUConfigData(tag)
{
	// w ##class(web.DHCICUDebug).LoadICUConfigData(tag)
	w "继续将会Kill掉所以配置，请三思!!!! 继续请输入：g,并按回车",!
	b // 危险啊，按g，回车继续，按Ctrl+C退出
	
	i tag'="" s date=tag
	e  s date=$h
	s dateTime=##class(web.DHCClinicCom).ConvertToDate(+$h)_##class(web.DHCClinicCom).ConvertToTime($p($h,",",2))
	w "备份ICU",!
	w "结点:",dateTime,!
	w ##class(web.DHCICUDebug).BakICUConfigData(dateTime)
	w "Kill:"_"^DHCICUC",!
	k ^DHCICUC
	w "Kill:"_"^DHCICUPara",!
	k ^DHCICUPara(1)
	k ^DHCICUPara(2)
	k ^DHCICUPara(3)
	w "Kill:"_"^DHCCLC",!
	k ^DHCCLC
	w "开始导DHCICUC",!
	m ^DHCICUC("IOItem")=^dhcicuanbak("dhcicuc",date,"IOItem")
	m ^DHCICUC("Level")=^dhcicuanbak("dhcicuc",date,"Level")
	m ^DHCICUC("OrdReason")=^dhcicuanbak("dhcicuc",date,"OrdReason")
	m ^DHCICUC("OrdMapping")=^dhcicuanbak("dhcicuc",date,"OrdMapping")
	m ^DHCICUC("Property")=^dhcicuanbak("dhcicuc",date,"Property")
	m ^DHCICUC("RecordItem")=^dhcicuanbak("dhcicuc",date,"RecordItem")
	m ^DHCICUC("SItem")=^dhcicuanbak("dhcicuc",date,"SItem")
	m ^DHCICUC("Stat")=^dhcicuanbak("dhcicuc",date,"Stat")
	m ^DHCICUC("Temperature")=^dhcicuanbak("dhcicuc",date,"Temperature")
	m ^DHCICUC("VSCat")=^dhcicuanbak("dhcicuc",date,"VSCat")
	m ^DHCICUC("ViewCat")=^dhcicuanbak("dhcicuc",date,"ViewCat")
	w "开始导DHCICUPara",!
	m ^DHCICUPara(1)=^dhcicuanbak("dhcicupara",date,1)
	m ^DHCICUPara(2)=^dhcicuanbak("dhcicupara",date,2)
	m ^DHCICUPara(3)=^dhcicuanbak("dhcicupara",date,3)
	m ^DHCICUPara(4)=^dhcicuanbak("dhcicupara",date,4)
	w "开始导DHCICUCLC",!	  
	m ^DHCCLC("Hospital")=^dhcicuanbak("dhcclc",date,"Hospital")
	m ^DHCCLC("MedicalSafety")=^dhcicuanbak("dhcclc",date,"MedicalSafety")
	m ^DHCCLC("Score")=^dhcicuanbak("dhcclc",date,"Score")
	m ^DHCCLC("ScoreLink")=^dhcicuanbak("dhcclc",date,"ScoreLink")
	w "开始导DHCANC"
	k ^DHCANC("CType")
	m ^DHCANC("CType")=^dhcicuanbak("dhcanc",date,"CType")
	q "Over"
}

ClassMethod HDUpdate()
{
	// w ##class(web.DHCICUDebug).HDUpdate(seqNo)
	s seqNo="14010"
		
	d ..InsertICURecordItem("CRRTDevType","设备类型","V","249",6075,.seqNo)
	d ..InsertICURecordItem("PBP_METHOD","血液净化方式","V","249",6075,.seqNo)
	d ..InsertICURecordItem("BloodPumpSeed","血泵速","V","249",6075,.seqNo)
	d ..InsertICURecordItem("FormerDiluent","前稀释液(设置)","V","249",6075,.seqNo)
	d ..InsertICURecordItem("DiluentAfter","后稀释液(设置)","V","249",6075,.seqNo)
	d ..InsertICURecordItem("EffluentSet","废液(设置)","V","249",6075,.seqNo)
	d ..InsertICURecordItem("DialysisRate","透析速率(设置)","V","249",6075,.seqNo)
	d ..InsertICURecordItem("FluidReplacementFlowSet","置换液(设置)","V","249",6075,.seqNo)
	d ..InsertICURecordItem("UltrafiltrationRateSet","超滤率(设置)(ml/hr)","V","249",6075,.seqNo)
	d ..InsertICURecordItem("WeightBalanceSet","病人脱水量(设置)","V","249",6075,.seqNo)
	
	d ..InsertICURecordItem("TMP","TMP(mmHg)","V","249",6075,.seqNo)
	d ..InsertICURecordItem("ArterialPressure-CRRT","动脉压","V","249",6075,.seqNo)
	d ..InsertICURecordItem("VenousPressure-CRRT","回路压","V","249",6075,.seqNo)
	
	
	d ..InsertICURecordItem("PreBloodCumulated","血泵前泵总量","V","249",6075,.seqNo)
	d ..InsertICURecordItem("PreReplacementCumulated","前稀释液总量","V","249",6075,.seqNo)
	d ..InsertICURecordItem("PostReplacementCumulated","后稀释液总量","V","249",6075,.seqNo)
	d ..InsertICURecordItem("EffluentCumulated","废液总量","V","249",6075,.seqNo)
	d ..InsertICURecordItem("DialysisCumulated","透析液总量","V","249",6075,.seqNo)
	d ..InsertICURecordItem("FluidReplacementFlowCumlat","置换液总量","V","249",6075,.seqNo)
	d ..InsertICURecordItem("WeightBalanceCumulated","病人脱水总量","V","249",6075,.seqNo)

	d ..InsertICURecordItem("PreBlood","血泵前泵","V","249",6075,.seqNo,"PreBloodCumulated")
	d ..InsertICURecordItem("UltrafiltrationRateAct","超滤率(实际)","V","249",6075,.seqNo)
	d ..InsertICURecordItem("PreReplacement","前稀释液","V","249",6075,.seqNo,"PreReplacementCumulated")
	d ..InsertICURecordItem("PostReplacement","后稀释液","V","249",6075,.seqNo,"PostReplacementCumulated")
	d ..InsertICURecordItem("FluidReplacement","置换液","V","249",6075,.seqNo,"FluidReplacementFlowCumlat")
	d ..InsertICURecordItem("Dialysis","透析液","V","249",6075,.seqNo,"DialysisCumulated")
	d ..InsertICURecordItem("5%NaHCO3","5%NaHCO3","V","249",6075,.seqNo,"DialysisCumulated")
	d ..InsertICURecordItem("Effluent","废液","V","249",6075,.seqNo,"EffluentCumulated")
	d ..InsertICURecordItem("WeightBalance","病人脱水量","V","249",6075,.seqNo,"WeightBalanceCumulated")
	d ..InsertICURecordItem("Warning","Warning","V","249",6075,.seqNo)
	d ..InsertICURecordItem("Malfunction","Malfunction","V","249",6075,.seqNo)
	d ..InsertICURecordItem("Caution","Caution","V","249",6075,.seqNo)
	d ..InsertICURecordItem("Advisory","Advisory","V","249",6075,.seqNo)

	s seqNo="14010",viewCat=222
	// 添加ICU一病房的模板参数
	d ..AddParaItemConfigByTempId(1,viewCat,.seqNo)
	// 添加ICU二病房的模板参数
	d ..AddParaItemConfigByTempId(2,viewCat,.seqNo)
	
	
	
	// 添加出入量项目
	s locId=56
	d ..AddIOItemConfig(56)
	d ..AddIOItemConfig(2166)
	
	
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"CRRTDevType","CRRTDevType")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"Mode_Set","PBP_METHOD")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"REPLACEMENT_PRE_FLOW","FormerDiluent")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"REPLACEMENT_POST_FLOW","DiluentAfter")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"EFFLUENT_FLOW","EffluentSet")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"DIALYSATE_FLOW","DialysisRate")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"PRE_BLOOD_CUMULATED","PreBloodCumulated")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"REPLACEMENT_PRE_CUMULAT","PreReplacementCumulated")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"REPLACEMENT_POST_CUMLAT","PostReplacementCumulated")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"REPLACEMENT_POST","PostReplacementCumulated")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"EFFLUENT_CUMULATED","EffluentCumulated")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"DIALYSATE_CUMULATED","DialysisCumulated")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"BLOOD_FLOW","BloodPumpSeed")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"TMP","TMP")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"ACCESS_PRESSURE","ArterialPressure-CRRT")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"RETURN_PRESSURE","VenousPressure-CRRT")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"FluidReplacementFlowSet","FluidReplacementFlowSet")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"FluidReplacementFlowCumlat","FluidReplacementFlowCumlat")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"PT_WEIGHT_CUMULATED","WeightBalanceCumulated")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"PT_WEIGHT_BALANCE","WeightBalanceSet")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"UFR","UltrafiltrationRateSet")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"Warning","Warning")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"Malfunction","Malfunction")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"Caution","Caution")
	d ##class(web.DHCICUDebug).InsertCollectTypeItem(9,"Advisory","Advisory")
	q "Over"
}

ClassMethod AddIOItemConfig(locId)
{
	// w ##class(web.DHCICUDebug).AddIOItemConfig(56)
	// xueyejinghuapingheng
	&sql(SELECT ICUCIOI_RowId into:CRRTBalanceId FROM DHC_ICUC_IOItem WHERE ICUCIOI_Ctloc_Dr=:locId AND ICUCIOI_Code='xueyejinghuapingheng')
	&sql(SELECT ICUCIOI_RowId into:totalBalanceId FROM DHC_ICUC_IOItem WHERE ICUCIOI_Ctloc_Dr=:locId AND ICUCIOI_Code='TotalBalance')
	&sql(SELECT ICUCIOI_RowId into:totalInId FROM DHC_ICUC_IOItem WHERE ICUCIOI_Ctloc_Dr=:locId AND ICUCIOI_Code='TotalIn')
	&sql(SELECT ICUCIOI_RowId into:totalOutId FROM DHC_ICUC_IOItem WHERE ICUCIOI_Ctloc_Dr=:locId AND ICUCIOI_Code='TotalOut')
	d ..InsertIOItem("PreBlood","PreBlood","血泵前泵","I","222",locId,totalInId)
	d ..InsertIOItem("PreReplacement","PreReplacement","前稀释液","I","222",locId,totalInId)
	d ..InsertIOItem("PostReplacement","PostReplacement","后稀释液","I","222",locId,totalInId)
	d ..InsertIOItem("5%NaHCO3","5%NaHCO3","5%NaHCO3","I","222",locId,totalInId)
	d ..InsertIOItem("Dialysis","Dialysis","透析液","I","222",locId,totalInId)
	d ..InsertIOItem("Effluent","Effluent","废液","O","222",locId,totalOutId)
	// 添加平衡项目
	d AddIOItems("-CRRT",CRRTBalanceId)
	d AddIOItems("-Total",totalBalanceId)
	q "Over"
AddIOItems(type,mainId)
	i mainId'="" d
	.d ..InsertIOItem("PreBlood"_type,"PreBlood","血泵前泵","I","222",locId,mainId)
	.d ..InsertIOItem("PreReplacement"_type,"PreReplacement","前稀释液","I","222",locId,mainId)
	.d ..InsertIOItem("PostReplacement"_type,"PostReplacement","后稀释液","I","222",locId,mainId)
	.d ..InsertIOItem("Dialysis"_type,"Dialysis","透析液","I","222",locId,mainId)
	.d ..InsertIOItem("5%NaHCO3"_type,"5%NaHCO3","5%NaHCO3","I","222",locId,mainId)
	.d ..InsertIOItem("Effluent-"_type,"Effluent","废液","O","222",locId,mainId)
	
	q 0
}

ClassMethod AddParaItemConfigByTempId(tempId, viewCat, seqNo)
{
	d ..InsertParaItem(tempId,"CRRTDevType","设备类型","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"PBP_METHOD","血液净化方式","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"BloodPumpSeed","血泵速","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"FormerDiluent","前稀释液(设置)","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"DiluentAfter","后稀释液(设置)","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"EffluentSet","废液(设置)","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"DialysisRate","透析速率(设置)","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"FluidReplacementFlowSet","置换液(设置)","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"UltrafiltrationRateSet","超滤率(设置)(ml/hr)","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"WeightBalanceSet","病人脱水量(设置)","V",viewCat,6075,.seqNo)
	
	d ..InsertParaItem(tempId,"TMP","TMP(mmHg)","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"ArterialPressure-CRRT","动脉压","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"VenousPressure-CRRT","静脉压","V",viewCat,6075,.seqNo)
	
	d ..InsertParaItem(tempId,"PreBlood","血泵前泵","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"UltrafiltrationRateAct","超滤率(实际)","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"PreReplacement","前稀释液","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"PostReplacement","后稀释液","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"Effluent","废液","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"Dialysis","透析液","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"FluidReplacement","置换液","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"5%NaHCO3","5%碳酸氢钠","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"WeightBalance","病人脱水量","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"Warning","Warning","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"Malfunction","Malfunction","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"Caution","Caution","V",viewCat,6075,.seqNo)
	d ..InsertParaItem(tempId,"Advisory","Advisory","V",viewCat,6075,.seqNo)
	
	// 设置模板属性
	d ..AddICUParaItemDetails(tempId,"CRRTDevType")
	d ..AddICUParaItemDetails(tempId,"PBP_METHOD")
	d ..AddICUParaItemDetails(tempId,"BloodPumpSeed")
	d ..AddICUParaItemDetails(tempId,"FormerDiluent")
	d ..AddICUParaItemDetails(tempId,"DiluentAfter")
	d ..AddICUParaItemDetails(tempId,"EffluentSet")
	d ..AddICUParaItemDetails(tempId,"DialysisRate")
	d ..AddICUParaItemDetails(tempId,"FluidReplacementFlowSet")
	d ..AddICUParaItemDetails(tempId,"UltrafiltrationRateSet")
	
	d ..AddICUParaItemDetails(tempId,"TMP")
	d ..AddICUParaItemDetails(tempId,"ArterialPressure-CRRT")
	d ..AddICUParaItemDetails(tempId,"VenousPressure-CRRT")
	
	d ..AddICUParaItemDetails(tempId,"PreBlood")
	d ..AddICUParaItemDetails(tempId,"UltrafiltrationRateAct")
	d ..AddICUParaItemDetails(tempId,"PreReplacement")
	d ..AddICUParaItemDetails(tempId,"PostReplacement")
	d ..AddICUParaItemDetails(tempId,"5%NaHCO3")
	d ..AddICUParaItemDetails(tempId,"Effluent")
	d ..AddICUParaItemDetails(tempId,"Dialysis")
	d ..AddICUParaItemDetails(tempId,"FluidReplacement")
	d ..AddICUParaItemDetails(tempId,"WeightBalance")
	d ..AddICUParaItemDetails(tempId,"Warning")
	d ..AddICUParaItemDetails(tempId,"Malfunction")
	d ..AddICUParaItemDetails(tempId,"Caution")
	d ..AddICUParaItemDetails(tempId,"Advisory")
}

ClassMethod AddICUParaItemDetails(tempId, code)
{
	// w ##class(web.DHCICUDebug).AddICUParaItemDetails(tempId, code)
	&sql(SELECT ICUPI_RowId into:IcuParaItemId FROM DHC_ICU_ParaItem WHERE ICUPI_Parref=:tempId AND ICUPI_Code=:code)
	s ICUPIDICUCPDr=5
    &sql(SELECT COUNT(*) into:count FROM DHC_ICU_ParaItemDetail WHERE ICUPID_Parref=:IcuParaItemId and ICUPID_ICUCP_Dr=:ICUPIDICUCPDr)
    
    i count=0 d
    .d ##class(web.DHCICUPara).AddICUParaItemDetails(ICUPIDICUCPDr,"true",IcuParaItemId)
    e  w code,"有模板属性",!
}

ClassMethod InsertICURecordItem(code, desc, type, viewCat, mainItem = "", seqNo = "", summaryCode = "", dateType = "N", dataField = "Qty", max = 99999, min = 0, icuApply = "Y")
{
	w "seqNo:"_seqNo,!
	s seqNo=seqNo+0.01
	s recordItemId=$O(^DHCICUC("RecordItem",0,"Code",code,""))
	s summaryId=""
	i summaryCode'="" s summaryId=$O(^DHCICUC("RecordItem",0,"Code",summaryCode,""))
	
	i (recordItemId'="") d
	.w code,"已存在",!
	.d ..UpdateICURecordItem(code,desc,type,viewCat,seqNo,summaryId,mainItem)
	e  d
	.
    .d ..InsertSQLItem(code,desc,type,viewCat,seqNo,dateType,mainItem,summaryId,dataField,max,min,icuApply)
    .;w "添加:",code,!
}

ClassMethod InsertParaItem(tempId, code, desc, type, viewCat, mainItem = "", seqNo = "", dateType = "N", dataField = "Qty", max = 99999, min = 0, icuApply = "Y")
{
	s count=0
	s seqNo=seqNo+0.01
	s recordItemId=$O(^DHCICUC("RecordItem",0,"Code",code,""))
    &sql(SELECT COUNT(*) into:count FROM DHC_ICU_ParaItem WHERE ICUPI_Parref=:tempId AND ICUPI_Code=:code)
    i count>0 d
    .
    .&sql(UPDATE DHC_ICU_ParaItem SET ICUPI_Desc=:desc ,ICUPI_SeqNo=:seqNo,ICUPI_ComOrd_Dr=:recordItemId,ICUPI_ViewCat_Dr=:viewCat WHERE ICUPI_Parref=:tempId AND ICUPI_Code=:code)
    .w "Update ParaItem:",desc,":",seqNo,!
    e  d
    .&sql(INSERT INTO DHC_ICU_ParaItem(ICUPI_Parref,ICUPI_Code,ICUPI_Desc,ICUPI_ComOrd_Dr,ICUPI_SeqNo,ICUPI_ViewCat_Dr) VALUES(:tempId,:code,:desc,:recordItemId,:seqNo,:viewCat))
    .w "Insert ParaItem:",code,!
}

ClassMethod InsertSQLItem(code, desc, type, viewCat, seqNo, dateType, mainItem, summaryId, Qty, max, min, icuApply)
{
	&SQL(INSERT INTO DHC_ICUC_RecordItem(ICUCRI_Code,ICUCRI_Desc,ICUCRI_Type,ICUCRI_ViewCat_Dr,ICUCRI_SortNo,ICUCRI_DataType,ICUCRI_MainICUCRI_Dr,ICUCRI_SummaryICUCRI_Dr,ICUCRI_DataField,ICUCRI_Max,ICUCRI_Min,ICUCRI_IcuApply) values(:code,:desc,:type,:viewCat,:seqNo,:dateType,:mainItem,:summaryId,:Qty,:max,:min,:icuApply))
	q:$g(SQLCODE)=0 %ROWID
	q $g(SQLCODE)
}

ClassMethod UpdateICURecordItem(code, desc, type, viewCat, seqNo, summaryId, mainItem)
{
	&SQL(UPDATE DHC_ICUC_RecordItem SET ICUCRI_Desc=:desc,ICUCRI_Type=:type,ICUCRI_ViewCat_Dr=:viewCat,ICUCRI_MainICUCRI_Dr=:mainItem,ICUCRI_SortNo=:seqNo,ICUCRI_SummaryICUCRI_Dr=:summaryId,ICUCRI_Max=NULL,ICUCRI_Min=NULL WHERE ICUCRI_Code=:code)
}

ClassMethod InsertIOItem(code, recordItemCode, desc, type, viewCat, locId, mainItemId, active = "Y", strategy = "HourAndTotal", multiple = "1", valueField = "Qty")
{
	s recordItemId=$O(^DHCICUC("RecordItem",0,"Code",recordItemCode,""))
	s code=code_"-"_locId
	i type="I" s multiple=1
	e  s multiple=-1
	&sql(SELECT COUNT(*) into:count FROM DHC_ICUC_IOItem WHERE ICUCIOI_Code=:code)
    i count>0 d
    .&sql(update DHC_ICUC_IOItem set ICUCIOI_Multiple=:multiple,ICUCIOI_Desc=:desc,ICUCIOI_MainICUCIOI_Dr=:mainItemId,ICUCIOI_ComOrd_Dr=:recordItemId where ICUCIOI_Code=:code)
	e  d
	.&sql(Insert Into DHC_ICUC_IOItem(ICUCIOI_MainICUCIOI_Dr,ICUCIOI_Code, ICUCIOI_Desc, ICUCIOI_Type, ICUCIOI_ComOrd_Dr, ICUCIOI_ViewCat_Dr, ICUCIOI_Active, ICUCIOI_Ctloc_Dr, ICUCIOI_Strategy, ICUCIOI_Multiple, ICUCIOI_ValueField) VALUES (:mainItemId,:code,:desc,:type,:recordItemId,:viewCat,:active,:locId,:strategy,:multiple,:valueField))
}

ClassMethod InsertCollectTypeItem(parentId, itemName, recordItemCode)
{
	// w ##class(web.DHCICUDebug).InsertCollectTypeItem(parentId,itemName,recordItemId)
	s recordItemId=$O(^DHCICUC("RecordItem",0,"Code",recordItemCode,""))
	w "recordItemId:",recordItemId,!
	&sql(SELECT COUNT(*) into:rowId FROM DHC_ANC_CollectTypeItem WHERE ANCCTI_Parref=:parentId)
	s rowId=rowId+2
	&sql(SELECT COUNT(*) into:count FROM DHC_ANC_CollectTypeItem WHERE ANCCTI_Parref=:parentId and ANCCTI_ChannelNo=:itemName)
	i count>0 d
	.&sql(update DHC_ANC_CollectTypeItem set ANCCTI_ComOrd_Dr=:recordItemId where ANCCTI_Parref=:parentId and ANCCTI_ChannelNo=:itemName)
	.w "update:",itemName,!
	e  d
	.
	.&sql(INSERT INTO DHC_ANC_CollectTypeItem(ANCCTI_Parref,ANCCTI_ChildSub,ANCCTI_ComOrd_Dr,ANCCTI_ChannelNo,ANCCTI_Active) values(:parentId,:rowId,:recordItemId,:itemName,'Y'))
	q "0"
}

ClassMethod GenScoreData(locId, fromData, toDate)
{
	// w ##class(web.DHCICUDebug).GenScoreData(locId,fromData,toDate)
	s fromData=##class(web.DHCClinicCom).ConvertToDateH(fromData)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	f date=fromData:1:toDate d
	.w "Gen Score:",##class(web.DHCClinicCom).ConvertToDate(fromData),!
	.
	.d EveryHour(locId,date)
	q "Over"
EveryHour(locId,date)
	s iDate=0
	f i=1:1:23 d
	.s hour=1
	.d ##class(web.DHCICUOrder).ProcessScore(date,iDate,hour,locId)
	q
}

/// 获取长期医嘱的停止日期时间20150318whl
/// w ##class(web.DHCICUDebug).GetOrderDT("5717217||1073||1")
/// 获取长期医嘱的停止日期时间20150318whl
ClassMethod GetOrderDT(oeoreId As %String) As %String
{
	
	s oeoriSub=$p(oeoreId,"||",2)
	s oeordId=+oeoreId
	s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
	s oecprCode=""
    i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1)
    q:(oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT") "" 
	s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
    s xDate=$zdt($p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34),3)
    s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
    s xDate=##class(web.DHCClinicCom).ConvertToDate(xDate)
    s xTime= ##class(web.DHCClinicCom).ConvertToTime(xTime)
   b ;"1"
	q xDate_" "_xTime
}

/// ICU三甲统计指标接口
ClassMethod GetICUStatisticsData(InquiryID As %String, desc As %String, type As %String = "", note As %String = "") As %GlobalCharacterStream
{

	s retStr=##class(%GlobalCharacterStream).%New()
	d retStr.Rewind()
	d retStr.Write("<Response>")
    s InquiryID=InquiryID

    s datefildstr=^DHCICUInquiry(39,0)
    s descIndex=$l($p(datefildstr,desc),"^")
    s sub=0
    f  s sub=$O(^DHCICUInquiry(39,0)) q:sub=""  d
        .s value=^DHCICUInquiry(39,sub)
        .w value ,!
	s Xml=##class(%GlobalCharacterStream).%New()
	s ret=obj.XMLExportToStream(.Xml,"PatInfo")
	q:ret=0
	d retStr.CopyFrom(Xml)
	q
}

// w ##class(web.DHCICUDebug).GetICUStatisticsDataTest(39,"登记号","","")

ClassMethod GetICUStatisticsDataTest(InquiryID As %String, desc As %String, dataField As %String = "", note As %String = "") As %String
{
    s datefildstr=^DHCICUInquiry(InquiryID,0)
    s descIndex=$l($p(datefildstr,desc),"^")
    s retstr=""
    s count=0
    s sumstr=0
    s sub=0
    f  s sub=$O(^DHCICUInquiry(InquiryID,sub)) q:(sub="")!(sub="F")  d
        .s value=^DHCICUInquiry(InquiryID,sub)
        .s singevalue=$p(value,"^",descIndex) 
        .i dataField="count" d
        ..i singevalue=note s count=count+1
        .i dataField="sum" d
        ..s sumstr=sumstr+singevalue
      w sumstr
    q count
}

ClassMethod GetId(pId)
{
	// w ##class(web.DHCICUDebug).GetId(1898261)
	s sub=0,icuaId=0
	f  s sub=$o(^DHCICUArrange(sub)) q:(sub="")  d
	.;i sub=157 b "s"
	.s arrangeStatus=$p($g(^DHCICUArrange(sub)),"^",18)
	.;q:arrangeStatus'="M"
	.s EpisodeID=$p(^DHCICUArrange(sub),"^",1)
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	.s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	.s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	.s medCareNo=$$UPPER^SSUTIL4(medCareNo)
	.i medCareNo=$$UPPER^SSUTIL4(pId) s icuaId=sub 
	q icuaId
}

ClassMethod InsertCollectData(icuaId, recordItemId, startDate, startTime, value = "", note = "", updateDate = "", updateTime = "")
{
	// w ##class(web.DHCICUCom).InsertCollectData(icuaId,recordItemId,startDate,startTime,value,note)
	s count=""
	i updateDate="" s updateDate=$p($h,",",1)
	i updateTime="" s updateTime=$p($h,",",2)
	
	i startDate'=+startDate s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	i startTime'=+startTime s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	i updateDate'=+updateDate s updateDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
	i updateTime'=+updateTime s updateTime=##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
	
	&sql(SELECT COUNT(ICUCD_StartDate) INTO :count 
        FROM DHC_ICU_CollectData where ICUCD_Parref=:icuaId and ICUCD_ComOrd_Dr=:recordItemId and ICUCD_StartDate=:startDate and ICUCD_StartTime=:startTime)
	s res=""
	
	i count>=1 d
	.; 当值(ICUCD_Note,ICUCD_Qty)与不同时修改;否则不修改
	.s note="11"
	.&SQL(update DHC_ICU_CollectData set ICUCD_Note=:note,ICUCD_Qty=:value, ICUCD_UpdateDate=:updateDate,ICUCD_UpdateTime=:updateTime 
	where ICUCD_Parref=:icuaId and ICUCD_ComOrd_Dr=:recordItemId and 
	ICUCD_StartDate=:startDate and ICUCD_StartTime=:startTime and 
	((ICUCD_Note is null and :note<>"") or (ICUCD_Note is not null and ICUCD_Note<>:note) or 
	(ICUCD_Qty is null and :value<>"") or (ICUCD_Qty is not null and ICUCD_Qty<>:value)))
	.i SQLCODE=0 s res="Updated" // 当前时间点已经有数据
	.e  i SQLCODE=100 s res="SameData"
	e  d
	.&SQL(INSERT INTO DHC_ICU_CollectData(ICUCD_Parref,ICUCD_ComOrd_Dr,ICUCD_StartDate,ICUCD_StartTime,ICUCD_UpdateDate,ICUCD_UpdateTime,ICUCD_Note,ICUCD_Qty) values(:icuaId,:recordItemId,:startDate,:startTime,:updateDate,:updateTime,:note,:value))
	.
	.i SQLCODE=0 s res=$g(%ROWID)
	.e  s res="Error"_SQLCODE_" value["_value_"]["_note_"]"
	
	q res
}

ClassMethod InsertCollectData2(icuaId, recordItemId, startDate, startTime, value = "", note = "", updateDate = "", updateTime = "")
{
	// w ##class(web.DHCICUCom).InsertCollectData(icuaId,recordItemId,startDate,startTime,value,note)
	s count="",rowId=""
	i updateDate="" s updateDate=$p($h,",",1)
	i updateTime="" s updateTime=$p($h,",",2)
	
	i startDate'=+startDate s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	i startTime'=+startTime s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	i updateDate'=+updateDate s updateDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
	i updateTime'=+updateTime s updateTime=##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
	
	&sql(SELECT COUNT(ICUCD_StartDate),ICUCD_RowId INTO :count,:rowId 
        FROM DHC_ICU_CollectData where ICUCD_Parref=:icuaId and ICUCD_ComOrd_Dr=:recordItemId and ICUCD_StartDate=:startDate and ICUCD_StartTime=:startTime)
	s res=""
	b ////
	i count>=1 d
	.b ; 当值(ICUCD_Note,ICUCD_Qty)与不同时修改;否则不修改
	.
	.//&SQL(update DHC_ICU_CollectData set ICUCD_Note=:note,ICUCD_Qty=:value, ICUCD_UpdateDate=:updateDate,ICUCD_UpdateTime=:updateTime 
	.//where ICUCD_Parref=:icuaId and ICUCD_RowId=:rowId)
	.s res="Updated" // 当前时间点已经有数据
	.e  i SQLCODE=100 s res="SameData"
	e  d
	.&SQL(INSERT INTO DHC_ICU_CollectData(ICUCD_Parref,ICUCD_ComOrd_Dr,ICUCD_StartDate,ICUCD_StartTime,ICUCD_UpdateDate,ICUCD_UpdateTime,ICUCD_Note,ICUCD_Qty) values(:icuaId,:recordItemId,:startDate,:startTime,:updateDate,:updateTime,:note,:value))
	.
	.i SQLCODE=0 s res=$g(%ROWID)
	.e  s res="Error"_SQLCODE_" value["_value_"]["_note_"]"
	b //
	q res
}

// 5380：剂量

// 以前老的数据只要剂量的有值就可以，前台就能显示出来，没必要所有的都把剂量加上

// w ##class(web.DHCICUDebug).UpdateIcuDoseSpeed(538,"2015-07-26","2015-07-26")

ClassMethod UpdateIcuDoseSpeed(needIcuaId = "", startDate = "", endDate = "")
{
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)

	f date=startDate:1:endDate d
		.s icuaId=""
		.f  s icuaId=$o(^DHCICUOrder(0,"RecordItem",5380,date,icuaId)) q:(icuaId="")  d
			..q:(needIcuaId'="")&(needIcuaId'=icuaId)
			..s time=""
			..f  s time=$o(^DHCICUOrder(0,"RecordItem",5380,date,icuaId,time)) q:(time="")  d
				...s icuoId=""
				...f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",5380,date,icuaId,time,icuoId)) q:(icuoId="")  d
					....s curDoseSpeed=$p(^DHCICUOrder(+icuoId),"^",40)
					....q:+curDoseSpeed'=0
					....s doseSpeed=##class(web.DHCICUOrder).GetDoseSpeed(icuoId)
					....//i doseSpeed="" w doseSpeed,"/"_icuoId,!
					....s $p(^DHCICUOrder(+icuoId),"^",40)=doseSpeed
	q "ok"
}

// 导出采集数据

ClassMethod OutputCollectData(fromIcuaId = 0, toIcuaId = "", wardId = "") As %String
{
	 //w ##class(web.DHCICUDebug).OutputCollectData(7725,7725,33)
	i fromIcuaId="",toIcuaId'="" s fromIcuaId=toIcuaId-1
	s icuaId=fromIcuaId-1
	f  s icuaId=$o(^DHCICUArrange(icuaId)) q:(icuaId="")!(icuaId>toIcuaId)  d
		.q:'$d(^DHCICUArrange(icuaId))
		.q:(+$p($g(^DHCICUArrange(icuaId)),"^",4)'=wardId)
		.q:##class(web.DHCICUOrder).CheckValidICUAID(icuaId)="N"
		.//w icuaId,!
		.s icuaLeaveDate=$p($g(^DHCICUArrange(icuaId)),"^",44)
		.s fileName="/tmp/CollectData"_icuaId_".txt"
		.w $h_"/"_fileName,!
		.set file=##class(%File).%New(fileName)
		.set existsFlag=##class(%File).Exists(fileName)
		.if existsFlag'=1 d file.Open("N")
		.d file.Close()
		.Set stream=##class(%FileCharacterStream).%New()
		.s stream.Filename=fileName
		.d stream.Clear()
		.s icucdSub=0
		.f  s icucdSub=$o(^DHCICUArrange(icuaId,"C",icucdSub)) q:icucdSub=""  d
			..s icucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)
			..s icucriDesc=$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)
			..q:icucriDesc=""
			..s date=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)
			..s time=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3),2)
			..s note=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4)
			..s qty=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5)
			..s writeStr=icucriDesc_"^"_date_"^"_time_"^"_note_"^"_qty
			..d stream.MoveToEnd()
			..d stream.WriteLine(writeStr)
		.//计算尿量
		.s startDate=$p(^DHCICUArrange(icuaId),"^",6)
		.s icuaLeaveDate=$p($g(^DHCICUArrange(icuaId)),"^",44)
		.s urineVolId=6096,urineVolDesc=$p(^DHCICUC("RecordItem",urineVolId),"^",2)
		.//w startDate_"/"_icuaLeaveDate_"/"_urineVolId,!
		.s date=startDate-1
		.f  s date=$o(^DHCICUOrder(0,"RecordItem",urineVolId,date)) q:(date="")!((icuaLeaveDate'="")&(date>icuaLeaveDate))  d	
			..s time=""
			..f  s time=$o(^DHCICUOrder(0,"RecordItem",urineVolId,date,icuaId,time)) q:(time="")  d	
				...s icuoId=""
				...f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",urineVolId,date,icuaId,time,icuoId)) q:(icuoId="")  d
					....q:'$d(^DHCICUOrder(icuoId))		
					....q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
					....s curDate=$zd($p(^DHCICUOrder(icuoId),"^",5),3)
					....s curTime=$zt($p(^DHCICUOrder(icuoId),"^",6),2)
					....s qty=$p(^DHCICUOrder(icuoId),"^",11)
					....s writeStr=urineVolDesc_"^"_curDate_"^"_curTime_"^^"_qty
					....//w writeStr,!
					....d stream.MoveToEnd()
					....d stream.WriteLine(writeStr)
		.d stream.SaveStream()
		.s d=stream.Size
	w $h
	q 0
}

/// 导出监护记录和采集数据
ClassMethod OutputICUAData(fromIcuaId = 0, toIcuaId = "", wardId = "", fromDate = "") As %String
{
	//w ##class(web.DHCICUDebug).OutputICUAData(7725,7725,33,"2016-5-4")
	//w ##class(web.DHCICUDebug).OutputICUAData(1,1725,33,"2016-5-4")
	i fromIcuaId="",toIcuaId'="" s fromIcuaId=toIcuaId-1
	i fromIcuaId'="",toIcuaId="" s toIcuaId=fromIcuaId
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s icuaId=fromIcuaId-1
	f  s icuaId=$o(^DHCICUArrange(icuaId)) q:(icuaId="")!(icuaId>toIcuaId)  d
		.q:'$d(^DHCICUArrange(icuaId))
		.q:(wardId'="")&(+$p($g(^DHCICUArrange(icuaId)),"^",4)'=wardId)
		.q:##class(web.DHCICUOrder).CheckValidICUAID(icuaId)="N"
		.s outDate=+$h
		.i fromDate'="" d
			..s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
			..i outDateTime'="" s outDate=$p(outDateTime,"^") 
		.q:(fromDate'="")&(fromDate>outDate)
		.//w icuaId,!
		.s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
		.q:icupId=""
		.q:'$d(^DHCICUPara(icupId))
		.s icucdSub=0
		.f  s icucdSub=$o(^DHCICUArrange(icuaId,"C",icucdSub)) q:icucdSub=""  d
			..s icucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)
			..q:icucriId=""
			..s icucriDesc=$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)
			..q:icucriDesc=""
			..s date=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)
			..s time=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3),2)
			..s dataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
			..i dataField="Note" s value=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4)
			..e  s value=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5)
			..s writeStr=icucriDesc_"^"_date_"^"_time_"^"_value_"^"
			..//w "icucriId="_icuaId_","_date_","_time_","_icucriId,!
			..s ^TmpICUExportData(icuaId,date,time,0,0,icucriId)=writeStr
		.//icuOrder
		.w "icuaId="_icuaId
		.s startDate=$p(^DHCICUArrange(icuaId),"^",6)
		.s icuaLeaveDate=$p($g(^DHCICUArrange(icuaId)),"^",44)
		.s icuoId=0
		.f  s icuoId=$o(^DHCICUOrder(0,"Arr",icuaId,icuoId)) q:icuoId=""  d
			..q:'$d(^DHCICUOrder(icuoId))		
			..q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
			..s date=$zd($p(^DHCICUOrder(icuoId),"^",5),3)
			..s time=$zt($p(^DHCICUOrder(icuoId),"^",6),2)
			..s icucriId=$p(^DHCICUOrder(icuoId),"^",2)
			..s icupiId=$p(^DHCICUOrder(icuoId),"^",38)
			..i icupiId="" s icupiId=0
			..s icupiSub=$p(icupiId,"||",2)
			..s mainIcupiId=$p($g(^DHCICUPara(+icupId,"I",+icupiSub)),"^",19)
			..i mainIcupiId="" s mainIcupiId=icupiId,isMain=1
			..e  s isMain=0
			..q:'$d(^DHCICUPara(icupId,"I",+icupiSub))
			..s desc=$p(^DHCICUPara(icupId,"I",+icupiSub),"^",14)
			..i desc="" s desc=$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)
			..//w icuoId_","_date_","_time_","_mainIcupiId_","_icupiId_","_icucriId,!
			..s value=##class(web.DHCICUOrder).GetRecordValueSingle(icuoId)
			..q:icucriId=""
			..s writeStr=desc_"^"_date_"^"_time_"^"_value_"^"_isMain
			..s ^TmpICUExportData(icuaId,date,time,mainIcupiId,icupiId,icucriId)=writeStr
		.s fileName="/tmp/ICUData"_icuaId_".txt"
		.w "  "_$h_" "_fileName,!
		.set file=##class(%File).%New(fileName)
		.set existsFlag=##class(%File).Exists(fileName)
		.if existsFlag'=1 d file.Open("N")
		.d file.Close()
		.Set stream=##class(%FileCharacterStream).%New()
		.s stream.Filename=fileName
		.d stream.Clear()
		.s date=""
		.f  s date=$o(^TmpICUExportData(icuaId,date)) q:date=""  d
			..s time=""
			..f  s time=$o(^TmpICUExportData(icuaId,date,time)) q:time=""  d
				...s mainIcupiId=""
				...f  s mainIcupiId=$o(^TmpICUExportData(icuaId,date,time,mainIcupiId)) q:mainIcupiId=""  d
					....s icupiId=""
					....f  s icupiId=$o(^TmpICUExportData(icuaId,date,time,mainIcupiId,icupiId)) q:icupiId=""  d
						.....s icucriId=""
						.....f  s icucriId=$o(^TmpICUExportData(icuaId,date,time,mainIcupiId,icupiId,icucriId)) q:icucriId=""  d
							......s writeStr=^TmpICUExportData(icuaId,date,time,mainIcupiId,icupiId,icucriId)
							......d stream.MoveToEnd()
							......d stream.WriteLine(writeStr)
		.d stream.SaveStream()
		.s d=stream.Size
	w $h
	q 0
}

/// 保存基线资料基础疾病描述
/// w ##class(web.DHCICUDebug).updateICUUnderlyingDisease("2015-9-16","2015-9-16",7506,39)
ClassMethod updateICUUnderlyingDisease(startDate As %String = "", endDate As %String = "", icuaId As %String = "", ctlocId As %String = "") As %String
{
	s retStr=0
	s icuUDStr="5^7^8^9^10^11^12^13^14^15^16^17^18^19^20^21^22^23^24^25^26^27^28^33^35^36^37^38^39^40^41^42^43^44^45^46^47^48^49^50^51^52^53^54^55^56"
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	f date=startDate:1:endDate d
	.s aId=""
	.f  s aId=$o(^DHCICUArrange(0,"SDate",date,aId)) q:aId=""  d
	..q:'$d(^DHCICUArrange(aId))
	..q:(icuaId'="")&&(icuaId'=aId)
	..s patLocId=+$p($g(^DHCICUArrange(aId)),"^",2)
	..q:(ctlocId'="")&&(ctlocId'=patLocId)
	..s icuSurgeryType=$p($g(^DHCICUArrange(aId)),"^",30)
	..w aId_"/"_ctlocId_"/"_icuSurgeryType,!
	..s icuudId="",chronicHealthPoint=""
	..f  s icuudId=$o(^DHCICUUnderlyingDisease(0,"ICUA",aId,icuudId)) q:icuudId=""   d
	...s clcudId=$lg(^DHCICUUnderlyingDisease(icuudId),2)
	...q:clcudId=""
	...q:$lg(^DHCCLC("UnderlyingDisease",clcudId),2)=""	
	...						
	...q:("^"_icuUDStr_"^")'[("^"_clcudId_"^") //包含基础疾病	
	...
	...i icuSurgeryType="N" s chronicHealthPoint="伴器官衰竭无手术"
	...e  i icuSurgeryType="B" s chronicHealthPoint="伴器官衰竭并接受常规手术"
	...e  i icuSurgeryType="E" s chronicHealthPoint="伴器官衰竭并接受急诊手术"
	...e  s chronicHealthPoint="无器官衰竭"
	...	
	..i (icuSurgeryType'="")&&(chronicHealthPoint="") s chronicHealthPoint="无器官衰竭"
	..w aId_"/"_icuSurgeryType_"/"_chronicHealthPoint,!
	..s $p(^DHCICUArrange(aId),"^",27)=chronicHealthPoint
	..s retStr=1
	q retStr
}

/// 循环安排表icuaId自动插入评分项目
/// w ##class(web.DHCICUDebug).autoInsertICUScore("2015-9-16","2015-9-16","","39","APACHEII","APACHEII",1)
ClassMethod autoInsertICUScore(startDate As %String = "", endDate As %String = "", icuaId As %String = "", ctlocId As %String = "", needClcsId As %String = "", ancvcId As %String = "", ifDebug = 1) As %String
{
	s retStr=""
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	f date=startDate:1:endDate d
	.s aId=""
	.f  s aId=$o(^DHCICUArrange(0,"SDate",date,aId)) q:aId=""  d
		..q:'$d(^DHCICUArrange(aId))
		..q:(icuaId'="")&&(icuaId'=aId)
		..s patLocId=+$p($g(^DHCICUArrange(aId)),"^",2)
		..q:(ctlocId'="")&&(ctlocId'=patLocId)
		..s ifValidIcuId=##class(web.DHCICUOrder).CheckValidICUAID(aId)
		..q:ifValidIcuId="N" //判断数据是否有效
		..s retStr=##class(web.DHCCLScore).AutoAddScoreOrderByHour("","",aId,"",needClcsId,ancvcId,"",ifDebug)
	q retStr
}

/// 根据病案号获取icuaId
ClassMethod GetIcuadBymedRecordNo(medRecordNo)
{
	// w ##class(web.DHCICUDebug).GetIcuadBymedRecordNo(medRecordNo)
	s icuaId=""
	s sub="" f  s sub=$o(^DHCICUArrange(sub),-1) q:((sub="")||(icuaId'=""))  d
	.s EpisodeID=$p(^DHCICUArrange(sub),"^",1)
	.q:EpisodeID="" ;数据有问题
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.q:papmiId="" ;数据有问题
	.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	.s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	.s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	.s medCareNo=$$UPPER^SSUTIL4(medCareNo)
	.i medCareNo=$$UPPER^SSUTIL4(medRecordNo) s icuaId=sub 
	q icuaId
}

}
