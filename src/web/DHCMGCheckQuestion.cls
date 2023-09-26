Class web.DHCMGCheckQuestion Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query CheckQuesSum(Type, CheckCode, QualDr, WardLoc, SEDate, Statu, question) As %Query(ROWSPEC = "CheckTyp,CheckDate,WardLoc,QualDesc,Score,CheckUser,Question,rw,PatName,Status,Reason,Method,Goal,Praise,Opinion,CheckId,ReMark")
{
}

ClassMethod CheckQuesSumExecute(ByRef qHandle As %Binary, Type, CheckCode, QualDr = "", WardLoc, SEDate, Statu, question) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGCheckQuestion","CheckQuesSum","","","","","2013-06-30^2013-07-06","","")
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TEMP("g201501081842001")=Type_"%"_CheckCode_"%"_QualDr_"%"_WardLoc_"%"_SEDate_"%"_Statu_"%"_question
 	//QualDr为一次检查的ID号，rw为一次检查当中的一条记录id
 	s stdate=$zdh($p(SEDate,"^",1),3)
    s eddate=$zdh($p(SEDate,"^",2),3)
    s CheckCode=$TR($ZConvert(CheckCode,"U")," ","")
 	//查房
 	s chktyp=$TR($ZConvert(CheckCode,"U")," ","")
    if (chktyp="NIGHTCHK") s CheckTyp="夜查房"
    if (chktyp="DAYCHK") s CheckTyp="随机督查"
    if (chktyp="NIGHTCHK") s CheckTyp="NIGHTCHK"
    if (chktyp="DAYCHK") s CheckTyp="DAYCHK"
	s ret=""
 	f date=stdate:1:eddate
 	{
	 	if chktyp=""
	 	{
			s chktyp=""  f  s chktyp=$o(^Nur.CheckRoomI("Check",date,chktyp)) q:chktyp=""  d
			.s loc="" f  s loc=$o(^Nur.CheckRoomI("Check",date,chktyp,loc)) q:loc=""  d
	    	..s qu=""  f  s qu=$O(^Nur.CheckRoomI("Check",date,chktyp,loc,qu)) q:qu=""  d
	    	...s rw=""  f  s rw=$O(^Nur.CheckRoomI("Check",date,chktyp,loc,qu,rw)) q:rw=""  d
	    	....//科室条件
	    	....s LocDr=$tr(loc," ","")
	    	....q:(LocDr'=WardLoc)&&(WardLoc'="")
	    	....;q:(Type'="")&&(Type'="MasterNur")
	    	....s Ward=$p(^CTLOC(LocDr),"^",2)
	    	....s a=##class(Nur.CheckRoom).%OpenId(rw)
	    	....q:(a.CheckQuestion="")&&(a.ReMark="")
	    	....q:(a.CheckQuestion'[question)&&(question'="")
	    	....//2013-06-28"转换百分制"     
	    	....s CheckUserT=a.CheckUser   //2013-7-2
	    	....;i a.CheckPat'="" s PatName=##Class(web.DHCMgQualCheck).getPatName(a.CheckPat)
	    	....s sumscore=##Class(DHCMGNUR.QuCheckWard).getScore(a.CheckQual)
	    	....s CheckUserT=a.CheckUser
	    	....s Score=a.Score
	    	....i sumscore'=0 s Score=$fnumber(Score/sumscore*100,"",1)
	    	....i a.CheckPat'="" s PatName=##Class(web.DHCMgQualCheck).getPatName(a.CheckPat)
	    	....s NurName=a.NightNur
	    	....s chekdate=$ZD(a.CheckDate,3)
	    	....s Question=a.CheckQuestion
	    	....s ReMark=a.ReMark
	    	....s QualDesc=a.CheckTyp
	    	....s TempQualDesc=$TR($ZConvert(a.CheckTyp,"U")," ","")
	    	....s QualDesc=$TR($ZConvert(QualDesc,"U")," ","")
	    	....s CheckTyp=QualDesc
	    	....s QualDesc=..GetQualDesc(rw)
	    	....i (QualDesc="") d
	    	.....if (TempQualDesc="NIGHTCHK") s QualDesc="夜查房"
	    	.....if (TempQualDesc="DAYCHK") s QualDesc="随机督查"
	    	....else  d
	    	.....if (QualDesc="NIGHTCHK") s QualDesc="夜查房"
	    	.....if (QualDesc="DAYCHK") s QualDesc="随机督查"
	    	....s Status=a.Status
	    	....q:(Statu'="")&&(Statu'=Status)
	    	....s statu="待处理"
     		....i Status=1 s statu="待处理"
     		....i Status=2 s statu="处理中"
     		....i Status=3 s statu="已解决"
     		....i Status=4 s statu="问题上诉"
     		....s id="",Reason="",Method="",Goal="",Praise="",Opinion="",CheckId=""
    		....s id=$o(^Nur.NurCheckSumLRI("CheckId"," "_rw," "_CheckTyp,""))
			....if id'="" s a=##class(Nur.NurCheckSumLR).%OpenId(id)  d
			.....s Reason=a.Reason
			.....s Method=a.Method
			.....s Goal=a.Goal
			.....s Praise=a.Praise
			.....s Opinion=a.Opinion
			.....s CheckId=a.CheckId
	    	....d OutputRow8
		}
		else
		{
	    	s loc="" f  s loc=$o(^Nur.CheckRoomI("Check",date," "_chktyp,loc)) q:loc=""  d
	    	.s qu=""  f  s qu=$O(^Nur.CheckRoomI("Check",date," "_chktyp,loc,qu)) q:qu=""  d
	    	..s rw=""  f  s rw=$O(^Nur.CheckRoomI("Check",date," "_chktyp,loc,qu,rw)) q:rw=""  d
	    	...//科室条件
	    	...s LocDr=$tr(loc," ","")
	    	...q:(LocDr'=WardLoc)&(WardLoc'="")
	    	...s Ward=$p(^CTLOC(LocDr),"^",2)
	    	...s a=##class(Nur.CheckRoom).%OpenId(rw)
	    	...;s ^TEMP("Type001")=Type
	    	...;q:(Type'="")&&(Type'="MasterNur")
	    	...q:(a.CheckQuestion="")&&(a.ReMark="")
	    	...q:(a.CheckQuestion'[question)&&(question'="")
	    	...//2013-06-28"转换百分制"
	    	...i a.CheckPat'="" s PatName=##Class(web.DHCMgQualCheck).getPatName(a.CheckPat)
	    	...s NurName=a.NightNur
	    	...s chekdate=$ZD(a.CheckDate,3)
	    	...s Question=a.CheckQuestion
	    	...s ReMark=a.ReMark
	    	...s Status=a.Status
	    	...//2013-09-25
	    	...s QualDesc=a.CheckTyp
	    	...s TempQualDesc=$TR($ZConvert(a.CheckTyp,"U")," ","")
	    	...s QualDesc=$TR($ZConvert(QualDesc,"U")," ","")
	    	...s QualDesc=..GetQualDesc(rw)
	    	...i (QualDesc="") d
	    	....if (TempQualDesc="NIGHTCHK") s QualDesc="夜查房" 
	    	....if (TempQualDesc="DAYCHK") s QualDesc="随机督查"
	    	...else  d
	    	....if (QualDesc="NIGHTCHK") s QualDesc="夜查房" 
	    	....if (QualDesc="DAYCHK") s QualDesc="随机督查"
	    	....if (chktyp="NIGHTCHK")	s CheckLevel="护理部"
     		...q:(Statu'="")&&(Statu'=Status)
     		...i Status=1 s statu="待处理"
     		...i Status=2 s statu="处理中"
     		...i Status=3 s statu="已解决"
     		...i Status=4 s statu="问题上诉"
     		...s id="",Reason="",Method="",Goal="",Praise="",Opinion="",CheckId=""
    		...s id=$o(^Nur.NurCheckSumLRI("CheckId"," "_rw," "_CheckTyp,""))
			...if id'="" s a=##class(Nur.NurCheckSumLR).%OpenId(id)  d
			....s Reason=a.Reason
			....s Method=a.Method
			....s Goal=a.Goal
			....s Praise=a.Praise
			....s Opinion=a.Opinion
			....s CheckId=a.CheckId
	    	...d OutputRow8
	    }
 	}
    //质控
     s ReMark=""
   	 s CheckTyp=""
   	 s CheckLevel=""
   	 s CheckCodeId=..getqualidstr(CheckCode)
   	 b ;110
     s QualDr=""  f  s QualDr=$O(^Nur.QualCheckRecI("QCheck",QualDr)) q:QualDr=""  d
 	 .s loc=""  f  s loc=$O(^Nur.QualCheckRecI("QCheck",QualDr,loc)) q:loc=""  d
 	 ..//科室条件
 	 ..q:($TR(loc," ","")'=WardLoc)&(WardLoc'="")
 	 ..s Chek=""  f  s Chek=$O(^Nur.QualCheckRecI("QCheck",QualDr,loc,Chek)) q:Chek=""  d
 	 ...;q:($TR(Chek," ","")'=CheckCode)&&(CheckCode'="")
 	 ...s Chekstr=$TR(Chek," ","")
 	 ...q:(CheckCodeId'[("^"_Chekstr_"^"))&&(CheckCode'="")
 	 ...b ;099090
 	 ...s rw=""  f  s rw=$O(^Nur.QualCheckRecI("QCheck",QualDr,loc,Chek,rw)) q:rw=""  d
     ....s LocDr=$tr(loc," ","")
     ....q:(LocDr'=WardLoc)&&(WardLoc'="")
     ....s Ward=$p(^CTLOC(LocDr),"^",2)
     ....s a=##class(Nur.QualCheckRec).%OpenId(rw)
     ....q:(a.CheckQuestion="")
     ....q:(a.CheckQuestion'[question)&&(question'="")
     ....//检查类型
     ....;q:(a.CheckTyp'=Type)&&(Type'="")
     ....q:(a.CheckTyp'=Type)&&(Type'="")
     ....s CheckLevel=a.CheckTyp
     ....i CheckLevel="Nur" s CheckLevel="护士长"
     ....i CheckLevel="LocNur" s CheckLevel="总护士长"
     ....i CheckLevel="MasterNur" s CheckLevel="护理部"
     ....s CheckTyp=$ZConvert(a.CheckCode,"U")
     ....//q:(a.CheckQual'=QualDr)&(QualDr'="")
     ....s CheckUser=$P(..getsuser(a.CheckUser),"!",2)
     ....;时间条件
     ....q:(a.CheckDate<stdate)!(a.CheckDate>eddate)
     ....s Score=a.Score_"/"_a.CompRate
     ....s PatName=a.CheckPat
     ....s chekdate=$ZD(a.CheckDate,3)
     ....;s qudr=##class(DHCMGNUR.QualCodeItem).getqualid(CheckCode)
     ....;s qudr=##class(DHCMGNUR.QualCodeItem).getqualid(Chek)    
     ....;s qual=##class(DHCMGNUR.QualCodeItem).%OpenId(qudr)
     ....s qual=##class(DHCMGNUR.QualCodeItem).%OpenId(Chekstr)
     ....s QualDesc=qual.QualDesc
     ....s patNameDesc=##class(web.DHCMgQualCheck).getPatName($P(a.CheckPat,"^",2))
     ....s Question="登记号:"_$p(a.CheckPat,"^",2)_"/"_patNameDesc_"  "_a.CheckQuestion
     ....s Status=a.Status
     ....q:(Statu'="")&&(Statu'=Status)
     ....i Status=1 s statu="待处理"
     ....i Status=2 s statu="处理中"
     ....i Status=3 s statu="已解决"
     ....i Status=4 s statu="问题上诉"
     ....s id="",Reason="",Method="",Goal="",Praise="",Opinion="",CheckId=""
     ....s id=$o(^Nur.NurCheckSumLRI("CheckId"," "_rw," "_CheckTyp,""))
	 ....if id'="" s a=##class(Nur.NurCheckSumLR).%OpenId(id)  d
	 .....s Reason=a.Reason
	 .....s Method=a.Method
	 .....s Goal=a.Goal
	 .....s Praise=a.Praise
	 .....s Opinion=a.Opinion
	 .....s CheckId=a.CheckId
     ....d OutputRow8
 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(CheckTyp,chekdate,Ward,QualDesc,Score,CheckUser,Question,rw,PatName,statu,$g(Reason),$g(Method),$g(Goal),$g(Praise),$g(Opinion),$g(CheckId),$g(ReMark))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckQuesSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckQuesSumExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckQuesSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckQuesSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetQualCodeExecute(ByRef qHandle As %Binary, sid As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TEMP("g07071425001")=sid
 	s ctlocDesc="夜查房",CtLocDr="NightChk"  d outtyp2	
 	s ctlocDesc="随机督查",CtLocDr="DayChk"  d outtyp2
 	s ctlocDesc="",CtLocDr=""
 	s id="" f  s id=$O(^DHCMGNUR.QualCodeItemD(id)) q:id=""  d
 	.s a=##class(DHCMGNUR.QualCodeItem).%OpenId(id)
	.s rw=id
	.;q:id=32
	.;q:((rw'=sid)&(sid'=""))
	.;b ;01
	.i sid="SafeCheck" q:(a.QualDesc'["核查")
	.i ((sid="SpecCheck")||(sid="QualCheck")) q:(a.QualDesc["安全核查")
	.s ret=""
	.;s ret=##class(DHCMGNUR.QualCodeItem).getVal(rw)
	.s ctlocDesc=a.QualDesc
	.s CtLocDr=a.QualCode
	.;s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ctlocDesc,CtLocDr)
	;set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetQualCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualCodeExecute ]
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

Query GetQualCode(sid As %String) As %Query(ROWSPEC = "QualDes,QualDr")
{
}

ClassMethod GetQualCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod getsuser(recuserId) As %String
{
  q:recuserId="" ""
  s User=$p($g(^SSU("SSUSR",recuserId)),"^",2)
  q recuserId_"!"_User
}

ClassMethod getVal(CheckId, CheckTyp) As %String
{
	//d ##Class(web.DHCMGCheckQuestion).getVal(26)
	s CheckTyp=$TR($ZConvert(CheckTyp,"U")," ","")
	s id=$o(^Nur.NurCheckSumLRI("CheckId"," "_CheckId," "_CheckTyp,""))
	if id'="" s a=##class(Nur.NurCheckSumLR).%OpenId(id)
	e  q:""
	i id'="" d
	.s Reason=a.Reason
	.s Method=a.Method
	.s Goal=a.Goal
	.s Praise=a.Praise
	.s Opinion=a.Opinion
	.s CheckId=a.CheckId
	.s ReadNurse=a.ReadNurse
	.s CheckReason=a.Reason
	.s ReasonNurse=a.ReasonNurse
	.s ReasonPat=a.ReasonPat
	.s ReasonEnv=a.ReasonEnv
	.s ReasonEpu=a.ReasonEpu
	.s ReasonThings=a.ReasonThings
	.;s ImagePath=a.ImagePath
	.s ret=$g(Reason)_"^"_$g(Method)_"^"_$g(Goal)_"^"_$g(Praise)_"^"_$g(Opinion)_"^"_$g(ReadNurse)
	.s ret=ret_"^"_$g(ReasonNurse)_"^"_$g(ReasonPat)_"^"_$g(ReasonEnv)_"^"_$g(ReasonEpu)_"^"_$g(ReasonThings)_"^"_$g(CheckId)_"^"_CheckReason
	.s ret=$tr(ret,$C(13,10),"_n")
	b
	if id'="" q ret
	e  q ""
}

ClassMethod getImages(CheckId, CheckTyp) As %String
{
	s ^mw123=CheckTyp
	s path=""
	if (CheckTyp="NIGHTCHK")!(CheckTyp="DAYCHK")  d
    .s a=##class(Nur.CheckRoom).%OpenId(CheckId)
    .s path=a.ImagePath
    if (CheckTyp="QUALCHECK")!(CheckTyp="QualCheck")!(CheckTyp["QUAL")  d
    .s a=##class(Nur.QualCheckRec).%OpenId(CheckId)
    .s path=a.ImagePath
    q path
}

ClassMethod GetQualDesc(QualId) As %String
{
	s ret=""
	s chktyp=""  f  s chktyp=$o(^Nur.CheckRoomItemI("item",chktyp)) q:chktyp=""  d
	.s id="" f  s id=$o(^Nur.CheckRoomItemI("item",chktyp,QualId,id)) q:id=""  d
	..s Qual=##class(Nur.CheckRoomItem).%OpenId(QualId_"||"_id)
	..q:Qual.CheckScore=""
	..s chktypPar=$p($tr(chktyp," ",""),"||",1)
	..s chktyprw=$p($tr(chktyp," ",""),"||",2)
	..s b=##class(DHCMGNUR.QuCheckWard).%OpenId(chktypPar)
	..b ;124
	..i (b.CheckFlag=0)||(b.CheckFlag="")  d
 	...s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(chktypPar_"||"_chktyprw)
	...s code=##class(DHCMGNUR.QualCodeItem).%OpenId(a.ItemLevel)
	...s qualdesc=code.QualDesc
	..i b.CheckFlag=1  d
 	...s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(chktypPar_"||"_chktyprw)
	...s chkitm=$lg(^DHCMGNUR.QuCheckWardD(chktypPar,"ChildSub",chktyprw),2)
	...s c=##class(DHCMGNUR.QuCheckProjectChild).%OpenId(chkitm)
	...s code=##class(DHCMGNUR.QualCodeItem).%OpenId(c.ItemLevel)
	...s qualdesc=code.QualDesc
	..i (ret'="")&&(ret'[qualdesc) s ret=ret_";"_qualdesc
	..i ret="" s ret=qualdesc
	q ret
}

ClassMethod GetQualPoint(QualId, Ptmp) As %String
{
	s ret="",Ptmp=""
	s chktyp=""  f  s chktyp=$o(^Nur.CheckRoomItemI("item",chktyp)) q:chktyp=""  d
	.s id="" f  s id=$o(^Nur.CheckRoomItemI("item",chktyp,QualId,id)) q:id=""  d
	..s Qual=##class(Nur.CheckRoomItem).%OpenId(QualId_"||"_id)
	..q:Qual.CheckScore=""
	..s a=##class(Nur.CheckRoom).%OpenId(QualId)
	..i $d(Ptmp(a.WardLoc)) s Ptmp(a.WardLoc)=Ptmp(a.WardLoc)+Qual.CheckScore
	..e  s Ptmp(a.WardLoc)=Qual.CheckScore
	q 0
}

Query CheckQuesSum2(STDate, SEDate, RealTypeCode, typ) As %Query(ROWSPEC = "desc,score")
{
}

ClassMethod CheckQuesSum2Execute(ByRef qHandle As %Binary, STDate, SEDate, RealTypeCode, typ) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGCheckQuestion","CheckQuesSum2","2014-03-01","2014-03-30","QUAL3")
	s ^donghua(1234)=STDate_"!!"_SEDate_"!!"_RealTypeCode_"!!"_typ
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//QualDr为一次检查的ID号，rw为一次检查当中的一条记录id
 	//s ^TMP("qu1")=$LB(QualDr,CheckCode,Type, WardLoc,SEDate,Statu,question)
 	//s ^TMP("qu")=SEDate
 	i STDate="" s stdate=$zdh($p($zd(+$h,3),"-",1)_"-"_$p($zd(+$h,3),"-",2)_"-01",3)
 	e  s stdate=$zdh(STDate,3)
 	i SEDate="" s eddate=+$h
 	e  s eddate=$zdh(SEDate,3)
 	 //s stdate=$zdh($p(STDate,"^",1),3)
    // s eddate=$zdh($p(SEDate,"^",2),3)
     s RealTypeCode=$ZConvert(RealTypeCode,"U")
    //质控
    i RealTypeCode'=""
    {
     s QualDr=""  f  s QualDr=$O(^Nur.QualCheckRecI("QCheck",QualDr)) q:QualDr=""  d
 	 .s loc=""  f  s loc=$O(^Nur.QualCheckRecI("QCheck",QualDr,loc)) q:loc=""  d
 	 ..//科室条件
 	 ..i loc'="" d
 	 ...s LocDr=$tr(loc," ","")
 	 ...s desc=$p(^CTLOC(LocDr),"^",2)
 	 ...s Chek=""  f  s Chek=$O(^Nur.QualCheckRecI("QCheck",QualDr,loc,Chek)) q:Chek=""  d
 	 ....q:($TR(Chek," ","")'=RealTypeCode)
 	 ....s score=0
 	 ....s rw=""  f  s rw=$O(^Nur.QualCheckRecI("QCheck",QualDr,loc,Chek,rw)) q:rw=""  d
 	 .....s a=##class(Nur.QualCheckRec).%OpenId(rw)
 	 .....q:(a.CheckDate<stdate)!(a.CheckDate>eddate)
 	 .....i a.Score<100 s score=score+1
 	 ..q:(score=0)
     ..d OutputRow9
    }else
    {
	 s QualDr=""  f  s QualDr=$O(^Nur.QualCheckRecI("QCheck",QualDr)) q:QualDr=""  d
 	 .s loc=""  f  s loc=$O(^Nur.QualCheckRecI("QCheck",QualDr,loc)) q:loc=""  d
 	 ..//科室条件
 	 ..i loc'="" d
 	 ...s LocDr=$tr(loc," ","")
 	 ...s desc=$p(^CTLOC(LocDr),"^",2)
 	 ...s Chek=""  f  s Chek=$O(^Nur.QualCheckRecI("QCheck",QualDr,loc,Chek)) q:Chek=""  d
 	 ....;q:($TR(Chek," ","")'=RealTypeCode)
 	 ....s score=0
 	 ....s rw=""  f  s rw=$O(^Nur.QualCheckRecI("QCheck",QualDr,loc,Chek,rw)) q:rw=""  d
 	 .....s a=##class(Nur.QualCheckRec).%OpenId(rw)
 	 .....q:(a.CheckDate<stdate)!(a.CheckDate>eddate)
 	 .....i a.Score<100 s score=score+1
 	 ..q:(score=0)
     ..d OutputRow9
	}
 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(desc,score)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckQuesSum2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckQuesSum2Execute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckQuesSum2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckQuesSum2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getPatNurInfo(par, checkcode) As %String
{
	//d ##class(web.DHCMGCheckQuestion).getPatNurInfo("175","QUALCHECK")
	i (checkcode="QUALCHECK")
	{
	s patName="",EpsID=""
	s Qual=##class(Nur.QualCheckRec).%OpenId(par)
	;q:Qual.CheckScore=""
	s patName=##class(web.DHCMgQualCheck).getPatName($P(Qual.CheckPat,"^",2))
	s EpsID=$P(Qual.CheckPat,"^",2)	
	q "("_patName_","_EpsID_")"
	}else
	{
		q ""
	}
}

ClassMethod getqualidstr(qcode) As %String
{
	q:qcode="" ""
	s qcode=$zcvt(qcode,"U")
   	s ret=""  
   	s Ver="" f  s Ver=$O(^DHCMGNUR.QualCodeItemI("Version"," "_qcode,Ver)) q:Ver=""  d
   	.s rw="" f  s rw=$O(^DHCMGNUR.QualCodeItemI("Version"," "_qcode,Ver,rw)) q:rw=""  d
   	..s ret=ret_"^"_rw
   	q ret_"^"
}

//查找病区病人

// w ##class(web.DHCNURPDAQUEXCUTE).GetQueryData("Nur.DataForPad:Findpat","1416")

ClassMethod FindpatExecute(ByRef qHandle As %Binary, getwardid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	//p8没有记录%session.Get("LOGON.WARDID") 只能传ctlocid过来
	s ctlocdr=getwardid
	i ctlocdr="" Set qHandle=$lb(0,repid,0) Quit $$$OK   //lrl
	s getwardid=$o(^PAWARD(0,"WARD_LocationDR",ctlocdr,""))
	//如果登陆的是治疗组 找关联病区
	i getwardid="" d
	.s linksub=0 f  s linksub=$o(^CTLOC(ctlocdr,"LINK",linksub)) q:linksub=""  d
	..s linkloc=$p(^CTLOC(ctlocdr,"LINK",linksub),"^",1)
	..i getwardid="" d
	...s getwardid=$o(^PAWARD(0,"WARD_LocationDR",linkloc,""))
	...//s ^lgltest("1003",ctlocdr,linksub)=getwardid
	i getwardid="" Set qHandle=$lb(0,repid,0) Quit $$$OK   //lgl
    s num=0
    s ind=1
    k ^TMP("IPBED",$j)
    s roomdr="" f  s roomdr=$o(^PAADMi("CurrWard",getwardid,roomdr)) q:roomdr=""  d
    .s admId=""      
    .f  s admId=$o(^PAADMi("CurrWard",getwardid,roomdr,admId)) q:admId=""  d
     ..q:'$d(^PAADM(admId))
     ..s curWardId=$p(^PAADM(admId),"^",70)        
     ..s admdate=$p(^PAADM(admId),"^",6)       
     ..s visitstatus=$p(^PAADM(admId),"^",20)
     ..q:visitstatus=""
     ..q:visitstatus="C"
     ..s papno=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
     ..s papname=$p(^PAPER(+^PAADM(admId),"ALL"),"^",1)
     ..s bedrowid=$p(^PAADM(admId),"^",73)
     ..q:bedrowid=""
     ..i bedrowid'=""  d  
     ...s wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
     ...s bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
     ..i $Number(bedname)'=""  s bedname=$Number(bedname)
     ..s patid=+^PAADM(admId)
     ..s mradm=$p(^PAADM(admId),"^",61)
     ..s arr(bedname)=papname_"/"_papno
     s beddesc="" f  s beddesc=$o(arr(beddesc)) q:beddesc=""  d
     .s tpapname=arr(beddesc)
     .Do OutputRowpat2
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputRowpat2
	set Data=$lb(tpapname,beddesc)
 	Set ^CacheTemp(repid,ind)=Data
 	s num=num+1
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod FindpatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindpatExecute ]
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

ClassMethod FindpatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindpatExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query Findpat(getwardid As %String) As %Query(ROWSPEC = "papname:%String,pabed:%String")
{
}

ClassMethod getQuestionsData(Par, QualTyp) As %String
{
	s Question=""
	i ((QualTyp="NightChk")!(QualTyp="DayChk"))
	{
		s obj=##class(Nur.CheckRoom).%OpenId(Par)
		s Question=obj.CheckQuestion
		
	}
	elseif((QualTyp="QualCheck")!(QualTyp="QualSelfCheck"))
	{
		s obj=##class(Nur.QualCheckRec).%OpenId(Par)
		s Question=obj.CheckQuestion
	}
	q Question
}

ClassMethod getStatus(Par, QualTyp) As %String
{
	s status=""
	i ((QualTyp="NightChk")!(QualTyp="DayChk"))
	{
		s obj=##class(Nur.CheckRoom).%OpenId(Par)
		s status=obj.Status
	}
	elseif((QualTyp="QualCheck")!(QualTyp="QualSelfCheck"))
	{
		s obj=##class(Nur.QualCheckRec).%OpenId(Par)
		s status=obj.Status
	}
	q status
}

}
