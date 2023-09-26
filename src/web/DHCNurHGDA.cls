Class web.DHCNurHGDA Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 医保结算未打发票
/// d ##class(%ResultSet).RunQuery("web.DHCNurHGDA","GetGuserbyID","2014-03-01","2014-05-01")
Query GetGuserbyID(SttDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "RegNo:%String,PatName:%String,InsuType:%String,BillDr:%String,Guser:%String,Date:%String")
{
}

ClassMethod GetGuserbyIDExecute(ByRef qHandle As %Binary, SttDate As %String = "", EndDate As %String) As %Status
{
	//Set repid=$I(^CacheTemp)
 	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
 	
	i $g(SttDate)="" s SttDate=+$H
	i $g(EndDate)="" s EndDate=+$H
	s SttDate=$zdh(SttDate,3)
	s EndDate=$zdh(EndDate,3)
	s YBDate=""
	f YBDate=SttDate:1:EndDate d
	.s INPAYRowid=""
	.f  s INPAYRowid=$O(^DHCINDIV(0,"IDate",YBDate,INPAYRowid))  q:INPAYRowid=""  d
	..s FLag=$p(^DHCINDIV(INPAYRowid),"^",5)
	..q:FLag'="I"
	..s ADMDr=$p(^DHCINDIV(INPAYRowid),"^",1) //就诊号
	..q:$g(ADMDr)=""
	..s AdmType=$p($g(^PAADM(ADMDr)),"^",2)
	..q:AdmType'="I"
    ..s AdmInfoDr=$p(^DHCINDIV(INPAYRowid),"^",2)
    ..q:AdmInfoDr=""
	..s InsuType=$p($g(^DHCINADM(AdmInfoDr)),"^",18)
    ..i InsuType="HFN" s InsuType="新农合"
    ..i InsuType="HF"  s InsuType="市医保"
    ..i InsuType="AH"  s InsuType="省医保"
    ..i InsuType="ANY"  s InsuType="异地医保"
    ..i InsuType="AHB"  s InsuType="省保建委"
	..s BillDr=$p(^DHCINDIV(INPAYRowid),"^",3) //账单号
	..q:BillDr=""
	..s BillFlag=$p($g(^DHCPB(BillDr)),"^",16)
	..q:BillFlag="P"
	..s PAPMIDr=$P(^PAADM(ADMDr),"^",1)  
	..s RegNo=$p(^PAPER(PAPMIDr,"PAT",1),"^",1) //登记号
	..s PatName=$p(^PAPER(PAPMIDr,"ALL"),"^",1) //姓名
    ..s UserID=$p(^DHCINDIV(INPAYRowid),"^",21)  //审核人员姓名
    ..q:UserID="SYS"
    ..s Guser=$P(^SSU("SSUSR",UserID),"^",2)
    ..s Date=$p(^DHCINDIV(INPAYRowid),"^",16) //操作时间
    ..s Date=$zd(Date,3)
	..Do OutputRow1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	Set Data=$lb(RegNo,PatName,InsuType,BillDr,Guser,Date)
	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	Quit
}

ClassMethod GetGuserbyIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGuserbyIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGuserbyIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGuserbyIDExecute ]
{
}

//d ##class(%ResultSet).RunQuery("web.DHCNurHGDA","ProblemOfProportion","2013-11-01","2013-11-30","NightChk")

Query ProblemOfProportion(startDate, endDate, typ) As %Query(ROWSPEC = "desc,score") [ SqlProc ]
{
}

ClassMethod ProblemOfProportionExecute(ByRef qHandle As %Binary, startDate, endDate, typ) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ^TMP("qu")=$LB( CheckTyp,QualDr, WardLoc)
 	i startDate="" s stdate=$zdh($p($zd(+$h,3),"-",1)_"-"_$p($zd(+$h,3),"-",2)_"-01",3)
 	e  s stdate=$zdh(startDate,3)
 	i endDate="" s endate=+$h
 	e  s endate=$zdh(endDate,3)
 	//s ^mw2013=startDate_"^"_endDate_"^"_typ
 	i typ="" s typ="NightChk"
 	s typ=$ZConvert(typ,"U")
 	
 	
 	for date=stdate:1:endate
 	{
	 	s id=""
	 	f  s id=$O(^Nur.CheckRoomI("ProblemDA",date," "_typ,id)) q:id=""  d
	 	.s nu=##class(web.DHCMGCheckQuestion).GetQualDesc(id)
	 	.q:nu=""
	 	.s l=$L(nu,"^")
	 	.f i=1:1:l  d
	 	..s hh=$P(nu,";",i)
	 	..i $D(temp(hh)) d
	 	...s temp(hh)=temp(hh)+1
	 	..e  d
	 	...s temp(hh)=1

	}
	
	    s idd=""
	 	s sumscore=0
	 	f  s idd=$O(temp(idd)) q:idd=""  d
	 	.s score=temp(idd)
		.s sumscore=sumscore+score
		 s idd=""
	 	f  s idd=$O(temp(idd)) q:idd=""  d
	 	.s desc=idd
	 	.s score=temp(idd)
		.d OutputRow8
		
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(desc,score)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ProblemOfProportionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProblemOfProportionExecute ]
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

ClassMethod ProblemOfProportionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProblemOfProportionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//d ##class(%ResultSet).RunQuery("web.DHCNurHGDA","ProblemOfWardPoint","2013-11-01","2013-11-30","NightChk")

Query ProblemOfWardPoint(startDate, endDate, typ) As %Query(ROWSPEC = "desc,score")
{
}

ClassMethod ProblemOfWardPointExecute(ByRef qHandle As %Binary, startDate, endDate, typ) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ^TMP("qu")=$LB( CheckTyp,QualDr, WardLoc)
 	
 	s typ=$ZConvert(typ,"U")
 	s stdate=$zdh(startDate,3)
 	s endate=$zdh(endDate,3)
 	for date=stdate:1:endate
 	{
	 	s id=""
	 	f  s id=$O(^Nur.CheckRoomI("ProblemDA",date," "_typ,id)) q:id=""  d
	 	.k Ptmp
	 	.s Ptmp=""
	 	.s nu=##class(web.DHCMGCheckQuestion).GetQualPoint(id,.Ptmp)
		.s WardId="" f  s WardId=$o(Ptmp(WardId)) q:WardId=""  d
		..i $d(temp(WardId)) s temp(WardId)=temp(WardId)+Ptmp(WardId)
		..e  s temp(WardId)=Ptmp(WardId)
	}
	
	    s idd=""
	 	s sumscore=0
	 	f  s idd=$O(temp(idd)) q:idd=""  d
	 	.s score=temp(idd)
		.s sumscore=sumscore+score
		 s idd=""
	 	f  s idd=$O(temp(idd)) q:idd=""  d
	 	.s desc=$p(^CTLOC(idd),"^",2)
	 	.s score=temp(idd)
		.d OutputRow8 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(desc,score)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ProblemOfWardPointFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProblemOfWardPointExecute ]
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

ClassMethod ProblemOfWardPointClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProblemOfWardPointExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//w ##class(web.DHCNurHGDA).getProblemOfProportion("2013-11-01","2013-11-30","NightChk")

ClassMethod getProblemOfProportion(startDate, endDate, typ) As %String
{
  
    s typ=$ZConvert(typ,"U")
 	s stdate=$zdh(startDate,3)
 	s endate=$zdh(endDate,3)
 	for date=stdate:1:endate
 	{
	 	s id=""
	 	f  s id=$O(^Nur.CheckRoomI("ProblemDA",date," "_typ,id)) q:id=""  d
	 	.s nu=##class(web.DHCMGCheckQuestion).GetQualDesc(id)
	 	.q:nu=""
	 	.s l=$L(nu,"^")
	 	.f i=1:1:l  d
	 	..s hh=$P(nu,";",i)
	 	..i $D(temp(hh)) d
	 	...s temp(hh)=temp(hh)+1
	 	..e  d
	 	...s temp(hh)=1

	}
	s idd=""
    s sumscore=0
    f  s idd=$O(temp(idd)) q:idd=""  d
	.s score=temp(idd)
	.s sumscore=sumscore+score
	s idd=""
	s parrStr=""
	f  s idd=$O(temp(idd)) q:idd=""  d
	.s desc=idd
	.s score=temp(idd)
	.i parrStr=""  d
	..s parrStr=desc_":"_score
	.e  d
	..s parrStr=parrStr_"^"_desc_":"_score
   q parrStr
}

//数据统计

//d ##Class(%ResultSet).RunQuery("web.DHCNurHGDA","GetDataStatistics","2013-11-01","2013-11-30","1036","")

ClassMethod GetDataStatisticsExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", wardid = "", itemcode = "") As %Status
{
	//s StDate=$zdh(StDate,3)
    //s EndDate=$zdh(EndDate,3)
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i StDate="" s StDate=$zdh($p($zd(+$h,3),"-",1)_"-"_$p($zd(+$h,3),"-",2)_"-01",3)
 	e  s StDate=$zdh(StDate,3)
 	i EndDate="" s EndDate=+$h
 	e  s EndDate=$zdh(EndDate,3)
	
	s chktyp=""  f  s chktyp=$o(^Nur.CheckRoomItemI("item",chktyp)) q:chktyp=""  d
	.s QualId="" f  s QualId=$o(^Nur.CheckRoomItemI("item",chktyp,QualId)) q:QualId=""  d
	..s id="" f  s id=$o(^Nur.CheckRoomItemI("item",chktyp,QualId,id)) q:id=""  d
	...s Qual=##class(Nur.CheckRoomItem).%OpenId(QualId_"||"_id)
	...q:(Qual.CheckScore="")||(Qual.CheckScore=0)
	...s Check=##class(Nur.CheckRoom).%OpenId(QualId)
	...q:(Check.CheckDate<StDate)||(Check.CheckDate>EndDate)
	...s CheckDate="",WardDesc="",QuestionDesc="",QuestionCode="",QuestionType="",Point="",CheckNurse="",QuestionTypeId=""
	...s Point=Qual.CheckScore
	...s CheckQuestion=Qual.CheckMem
	...s CheckNurse=Qual.CheckPeople
	...s CheckDate=$zd(Check.CheckDate,3)
	...s Ward=Check.WardLoc
	...s WardDesc=$p(^CTLOC(Ward),"^",2)
	...q:(Ward'=wardid)&&(wardid'="")
	...s chktypPar=$p($tr(chktyp," ",""),"||",1)
	...s chktyprw=$p($tr(chktyp," ",""),"||",2)
	...s Score=Check.Score
	...s sumscore=##Class(DHCMGNUR.QuCheckWard).getScore(chktypPar)
	...i sumscore'=0 s Score=$fnumber(Score/sumscore*100,"",1)
	...s b=##class(DHCMGNUR.QuCheckWard).%OpenId(chktypPar)
	...i (b.CheckFlag=0)||(b.CheckFlag="")  d
	....s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(chktypPar_"||"_chktyprw)
	....s code=##class(DHCMGNUR.QualCodeItem).%OpenId(a.ItemLevel)
	....s QuestionDesc=a.CheckItem.ItemDesc
	....s QuestionType=code.QualDesc
	....s QuestionTypeId=a.ItemLevel
	....s QuestionCode=a.CheckItem.ItemCode
	...i b.CheckFlag=1  d
	....s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(chktypPar_"||"_chktyprw)
	....s chkitm=$lg(^DHCMGNUR.QuCheckWardD(chktypPar,"ChildSub",chktyprw),2)
	....s c=##class(DHCMGNUR.QuCheckProjectChild).%OpenId(chkitm)
	....s code=##class(DHCMGNUR.QualCodeItem).%OpenId(c.ItemLevel)
	....s QuestionDesc=c.CheckItem.ItemDesc
	....s QuestionType=code.QualDesc
	....s QuestionTypeId=c.ItemLevel
	....s QuestionCode=c.CheckItem.ItemCode
	...q:(QuestionCode'=itemcode)&&(itemcode'="")
	...d outtyp3
	s tmpchktyp=""
	s chktyp=""  f  s chktyp=$o(^Nur.CheckRoomItemI("item",chktyp)) q:chktyp=""  d
	.q:(tmpchktyp'="")&&(tmpchktyp=$p($p(chktyp," ",2),"||",1))
	.s tmpchktyp=$p($p(chktyp," ",2),"||",1)
	.s QualId="" f  s QualId=$o(^Nur.CheckRoomItemI("item",chktyp,QualId)) q:QualId=""  d
	..s Check=##class(Nur.CheckRoom).%OpenId(QualId)
	..q:Check.ReMark=""
	..q:(Check.CheckDate<StDate)||(Check.CheckDate>EndDate)
	..s CheckDate="",WardDesc="",QuestionDesc="",QuestionCode="",QuestionType="",Point="",CheckNurse="",QuestionTypeId=""
	..s Point=0
	..s CheckQuestion=Check.ReMark
	..s CheckNurse=""
	..s CheckDate=$zd(Check.CheckDate,3)
	..s Ward=Check.WardLoc
	..s WardDesc=$p(^CTLOC(Ward),"^",2)
	..q:(Ward'=wardid)&&(wardid'="")
	..s chktypPar=$p($tr(chktyp," ",""),"||",1)
	..s chktyprw=$p($tr(chktyp," ",""),"||",2)
	..s Score=Check.Score
	..s sumscore=##Class(DHCMGNUR.QuCheckWard).getScore(chktypPar)
	..i sumscore'=0 s Score=$fnumber(Score/sumscore*100,"",1)   ///////
	..s b=##class(DHCMGNUR.QuCheckWard).%OpenId(chktypPar)	
	..i (b.CheckFlag=0)||(b.CheckFlag="")  d
	...s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(chktypPar_"||"_chktyprw)
	...s code=##class(DHCMGNUR.QualCodeItem).%OpenId(a.ItemLevel)
	...s QuestionDesc=a.CheckItem.ItemDesc
	...s QuestionType=code.QualDesc
	...s QuestionTypeId=a.ItemLevel
	...s QuestionCode=a.CheckItem.ItemCode
	..i b.CheckFlag=1  d
	...s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(chktypPar_"||"_chktyprw)
	...s chkitm=$lg(^DHCMGNUR.QuCheckWardD(chktypPar,"ChildSub",chktyprw),2)
	...s c=##class(DHCMGNUR.QuCheckProjectChild).%OpenId(chkitm)
	...s code=##class(DHCMGNUR.QualCodeItem).%OpenId(c.ItemLevel)
	...s QuestionDesc=c.CheckItem.ItemDesc
	...s QuestionType=code.QualDesc
	...s QuestionTypeId=c.ItemLevel
	...s QuestionCode=c.CheckItem.ItemCode
	..q:(QuestionCode'=itemcode)&&(itemcode'="")
	..d outtyp3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp3
	set Data=$lb(CheckDate,WardDesc,QuestionDesc,QuestionCode,QuestionType,CheckQuestion,Point,Score,CheckNurse,QuestionTypeId,Ward)
	;set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDataStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataStatisticsExecute ]
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

Query GetDataStatistics(StDate As %String, EndDate As %String, wardid As %String, itemcode As %String) As %Query(ROWSPEC = "CheckDate,WardDesc,QuestionDesc,QuestionCode,QuestionType,CheckQuestion,Point,Score,CheckNurse,QualId,WardId") [ SqlProc ]
{
}

ClassMethod GetDataStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

//d ##Class(%ResultSet).RunQuery("web.DHCNurHGDA","GetLevelsCareData","2014-03-11","2014-03-11","","")

//fengjihuli

Query GetLevelsCareData1111(StDate As %String, EndDate As %String, wardid As %String, itemcode As %String) As %Query(ROWSPEC = "WardDesc,QuestionDesc,QuestionCode,QuestionTypeCode,CheckQuestion,tempItemCount,PerNumber,countNumber,Score,PerComp,QualId,WardId")
{
}

ClassMethod GetLevelsCareData1111Execute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", wardid = "", itemcode = "") As %Status
{
	//s StDate=$zdh(StDate,3)
    //s EndDate=$zdh(EndDate,3)
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i StDate="" s StDate=$zdh($p($zd(+$h,3),"-",1)_"-"_$p($zd(+$h,3),"-",2)_"-01",3)
 	e  s StDate=$zdh(StDate,3)
 	i EndDate="" s EndDate=+$h
 	e  s EndDate=$zdh(EndDate,3)
	
	s chktyp=""  f  s chktyp=$o(^Nur.QualCheckRecI("QCheck",chktyp)) q:chktyp=""  d
	.s CTLocID="" f  s CTLocID=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID)) q:CTLocID=""  d
	..s WardDesc="",QuestionDesc="",QuestionCode="",QuestionTypeCode="",CheckQuestion="",tempItemCount="",PerNumber="",countNumber="",Score="",PerComp="",QualId="",WardId=""
	..s CTDesc=$tr(CTLocID," ","")
	..s WardDesc=$p(^CTLOC(CTDesc),"^",2)         //同一科室
	..s SumScore=0
	..;b ;1234
	..s CheckCode="" f  s CheckCode=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode)) q:CheckCode=""  d

	...q:($TR(CheckCode," ","")'="QUAL3")      //分级护理    Qual3护理文件书写
	...s id="" f  s id=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode,id)) q:id=""  d
	....s QualCheckThing=##class(Nur.QualCheckRec).%OpenId(id)
	....q:(QualCheckThing.CheckDate<StDate)||(QualCheckThing.CheckDate>EndDate)
	....s PerNumber=PerNumber+1    //科室检查人数，即病人数
	....q:(QualCheckThing.Score="")||(QualCheckThing.Score=0)
	....i (QualCheckThing.Score<100) s countNumber=countNumber+1  //有扣分的人  即合计
	....s SumScore=QualCheckThing.Score+SumScore                          //分数
	....s PerComp=QualCheckThing.CompRate              //完成率
	....i (QualCheckThing.CheckQuestion'="") s CheckQuestion=CheckQuestion_"^"_QualCheckThing.CheckQuestion   ///wentimiaoshu
	....;s QualBigItem=(^DHCMGNUR.QualCodeItemI("Version"," "_QualCheckThing.CheckCode))   
	....s TmpAddSum=0 f  s TmpAddSum=TmpAddSum+1 q:TmpAddSum=77  d
	.....s QualCheckChildThing=##class(Nur.QualCheckRecChild).%OpenId(id_"||"_TmpAddSum)
	.....i (QualCheckChildThing.CheckComplete="未完成") d
	......s CheckArrany=QualCheckChildThing.CheckItem
	......s arrStore(CTLocID,CheckArrany)=$G(arrStore(CTLocID,CheckArrany))+1
	......s CodeItemSubThing=##class(DHCMGNUR.QualCodeItemSub).%OpenId(CheckArrany)
	......;s QuestionRes=CodeItemSubThing.ItemDedStand     //扣分原因
	......;s QuestionTypeCode=CodeItemSubThing.ItemCode
	......;s QuestionTypeDesc=CodeItemSubThing.ItemDesc    //扣分条目
	......s QuestionUpItemCode=CodeItemSubThing.ItemLevel     //上级条目
	......s arrItemStore(CheckArrany)=CodeItemSubThing.ItemCode_":"_CodeItemSubThing.ItemDesc_":"_CodeItemSubThing.ItemDedStand_":"_QuestionUpItemCode
	..s CheckArranyList=""  f  s CheckArranyList=$O(arrStore(CTLocID,CheckArranyList)) q:CheckArranyList=""  d
	...s tempItemCount=tempItemCount_"^"_arrStore(CTLocID,CheckArranyList)
	...s QuestionDesc=QuestionDesc_"^"_$P(arrItemStore(CheckArranyList),":",2)
    ...s QuestionCode=QuestionCode_"^"_$P(arrItemStore(CheckArranyList),":",1)
    ...b ;321
    ...s QuestionTypeCode=QuestionTypeCode_"^"_$P(arrItemStore(CheckArranyList),":",4)
	..s QualId="QUAL3"
	..s WardId=CTDesc
	..q:PerNumber=""
	..s Score=$fnumber((SumScore+0)/(PerNumber+0),"",1)
    ..d outtyp3
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp3
	set Data=$lb(WardDesc,QuestionDesc,QuestionCode,QuestionTypeCode,CheckQuestion,tempItemCount,PerNumber,countNumber,Score,PerComp,QualId,WardId)
	;set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLevelsCareData1111Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLevelsCareData1111Execute ]
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

ClassMethod GetLevelsCareData1111Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLevelsCareData1111Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

//d ##Class(%ResultSet).RunQuery("web.DHCNurHGDA","GetEveryOneQualData","2014-09-01","2014-09-30","","")

//护理文书

Query GetEveryOneQualData(StDate As %String, EndDate As %String, wardid As %String, itemcode As %String) As %Query(ROWSPEC = "ID,CheckDate,WardDesc,QuestionDesc,QuestionCode,QuestionTypeDesc,QuestionTypeCode,CheckQuestion,CheckPatName,Score,PerComp,QualId,WardId,CheckPat") [ SqlProc ]
{
}

ClassMethod GetEveryOneQualDataExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", wardid = "", itemcode = "") As %Status
{
     //s StDate=$zdh(StDate,3)
    //s EndDate=$zdh(EndDate,3)
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i StDate="" s StDate=$zdh($p($zd(+$h,3),"-",1)_"-"_$p($zd(+$h,3),"-",2)_"-01",3)
 	e  s StDate=$zdh(StDate,3)
 	i EndDate="" s EndDate=+$h
 	e  s EndDate=$zdh(EndDate,3)
	
	s chktyp=""  f  s chktyp=$o(^Nur.QualCheckRecI("QCheck",chktyp)) q:chktyp=""  d
	.s CTLocID="" f  s CTLocID=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID)) q:CTLocID=""  d
	..s CTDesc=$tr(CTLocID," ","")
	..s WardId=CTDesc
	..s WardDesc=$p(^CTLOC(CTDesc),"^",2)         //同一科室
	..s CheckCode="" f  s CheckCode=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode)) q:CheckCode=""  d
	...q:($TR(CheckCode," ","")'="QUAL3")      //分级护理    Qual3护理文件书写
	...s id="" f  s id=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode,id)) q:id=""  d
	....s CheckQuestion="",QuestionCode="",QuestionDesc="",QuestionTypeCode="",QuestionTypeDesc=""
	....s QualCheckThing=##class(Nur.QualCheckRec).%OpenId(id)
	....q:(QualCheckThing.CheckDate<StDate)||(QualCheckThing.CheckDate>EndDate)
	....s CheckDate=$zd(QualCheckThing.CheckDate,3)      //核查日期
	....s QualId="QUAL3"
	....s ID=id   //ID
	....s CheckPatName=##class(web.DHCMgQualCheck).getPatName($P(QualCheckThing.CheckPat,"^",2))
	....s Score=QualCheckThing.Score                        //分数
	....s PerComp=QualCheckThing.CompRate              //完成率
	....s CheckPat=$P(QualCheckThing.CheckPat,"^",2)  //住院号
	....;w !,CheckPat
	....i CheckPat="null" s CheckPat=""          
	....i Score="100" d
	.....i wardid="" s HD=2000
	.....else  q:(wardid'=WardId)
	.....i itemcode="" s HD=3000
	.....else  q:(QualCheckThing.CheckQuestion="")
	.....d outtyp3
	.....q
	....s TmpAddSum=1 f  s TmpAddSum=$o(^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSum)) q:TmpAddSum=""  d
	.....s a=^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSum)
	.....q:$ListGet(a,6)'="未完成"
	.....i wardid="" s HD=2000
	.....else  q:(wardid'=WardId)
	.....s CheckQuestion=$ListGet(a,3)
	.....s CodeItemSubThing=##class(DHCMGNUR.QualCodeItemSub).%OpenId($ListGet(a,2))
	.....s QuestionCode=CodeItemSubThing.ItemCode
	.....s QuestionDesc=CodeItemSubThing.ItemDesc    //扣分条目
	.....s QuestionTypeCode=CodeItemSubThing.ItemLevel     //上级条目
	.....s TmpAddSumSub=1 f  s TmpAddSumSub=$o(^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSumSub)) q:TmpAddSumSub=""  d
	......s b=^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSumSub)
	......q:$ListGet(b,6)'=""
	......s QualCheckChildUp=##class(DHCMGNUR.QualCodeItemSub).%OpenId($ListGet(b,2))
	......q:(QualCheckChildUp.ItemCode'=QuestionTypeCode)
	......s QuestionTypeDesc=QualCheckChildUp.ItemDesc
	.....i itemcode="" s HD=3000
	.....else  q:QuestionCode'=itemcode
	.....d outtyp3
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp3
	set Data=$lb(ID,CheckDate,WardDesc,QuestionDesc,QuestionCode,QuestionTypeDesc,QuestionTypeCode,CheckQuestion,CheckPatName,Score,PerComp,QualId,WardId,CheckPat)
	;set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEveryOneQualDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEveryOneQualDataExecute ]
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

ClassMethod GetEveryOneQualDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEveryOneQualDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

//d ##Class(%ResultSet).RunQuery("web.DHCNurHGDA","GetEveryOneQualDataP","2014-09-01","2014-09-30","","")

//护理文书完成率

Query GetEveryOneQualDataP(StDate As %String, EndDate As %String, wardid As %String, itemcode As %String) As %Query(ROWSPEC = "WardDesc,avgScore,avgPerComp,countPerson") [ SqlProc ]
{
}

ClassMethod GetEveryOneQualDataPExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", wardid = "", itemcode = "") As %Status
{
     //s StDate=$zdh(StDate,3)
    //s EndDate=$zdh(EndDate,3)
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i StDate="" s StDate=$zdh($p($zd(+$h,3),"-",1)_"-"_$p($zd(+$h,3),"-",2)_"-01",3)
 	e  s StDate=$zdh(StDate,3)
 	i EndDate="" s EndDate=+$h
 	e  s EndDate=$zdh(EndDate,3)
	
	s chktyp=""  f  s chktyp=$o(^Nur.QualCheckRecI("QCheck",chktyp)) q:chktyp=""  d
	.s CTLocID="" f  s CTLocID=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID)) q:CTLocID=""  d
	..s CTDesc=$tr(CTLocID," ","")
	..s WardId=CTDesc
	..s countscore=0
	..s countPerComp=0
	..s countPerson=0
	..s WardDesc=$p(^CTLOC(CTDesc),"^",2)         //同一科室
	..s CheckCode="" f  s CheckCode=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode)) q:CheckCode=""  d
	...q:($TR(CheckCode," ","")'="QUAL3")      //分级护理    Qual3护理文件书写
	...s id="" f  s id=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode,id)) q:id=""  d
	....s CheckQuestion="",QuestionCode="",QuestionDesc="",QuestionTypeCode="",QuestionTypeDesc=""
	....s QualCheckThing=##class(Nur.QualCheckRec).%OpenId(id)
	....q:(QualCheckThing.CheckDate<StDate)||(QualCheckThing.CheckDate>EndDate)
	....s CheckDate=$zd(QualCheckThing.CheckDate,3)      //核查日期
	....s QualId="QUAL3"
	....s ID=id   //ID
	....s CheckPatName=##class(web.DHCMgQualCheck).getPatName($P(QualCheckThing.CheckPat,"^",2))
	....s Score=QualCheckThing.Score                        //分数
	....s PerComp=QualCheckThing.CompRate             //完成率
	....i Score="100" d
	.....i wardid="" s HD=2000
	.....else  q:(wardid'=WardId)
	.....i itemcode="" s HD=3000
	.....else  q:(QualCheckThing.CheckQuestion="")
	.....s countscore=countscore+Score
	.....s countPerComp=countPerComp+PerComp
	.....s countPerson=countPerson+1
	.....q
	....s TmpAddSum=1 f  s TmpAddSum=$o(^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSum)) q:TmpAddSum=""  d
	.....s a=^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSum)
	.....;w !,a
	.....q:$ListGet(a,6)'="未完成"
	.....i wardid="" s HD=2000
	.....else  q:(wardid'=WardId)
	.....s CheckQuestion=$ListGet(a,3)
	.....s CodeItemSubThing=##class(DHCMGNUR.QualCodeItemSub).%OpenId($ListGet(a,2))
	.....s QuestionCode=CodeItemSubThing.ItemCode
	.....s QuestionDesc=CodeItemSubThing.ItemDesc    //扣分条目
	.....s QuestionTypeCode=CodeItemSubThing.ItemLevel     //上级条目
	.....s TmpAddSumSub=1 f  s TmpAddSumSub=$o(^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSumSub)) q:TmpAddSumSub=""  d
	......s b=^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSumSub)
	......q:$ListGet(b,6)'=""
	......w !,b
	......s QualCheckChildUp=##class(DHCMGNUR.QualCodeItemSub).%OpenId($ListGet(b,2))
	......q:(QualCheckChildUp.ItemCode'=QuestionTypeCode)
	......s QuestionTypeDesc=QualCheckChildUp.ItemDesc
	.....i itemcode="" s HD=3000
	.....else  q:QuestionCode'=itemcode
	.....s countscore=countscore+Score
	.....s countPerComp=countPerComp+PerComp
	.....s countPerson=countPerson+1
	..i countPerson'=0  d
	...set avgScore=countscore/countPerson
	...set avgPerComp=countPerComp/countPerson
	...set avgScore=$FN(avgScore,"p",2)
	...set avgPerComp=$FN(avgPerComp,"p",2)_"%"
	...d outtyp3
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp3
	set Data=$lb(WardDesc,avgScore,avgPerComp,countPerson)
	;set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEveryOneQualDataPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEveryOneQualDataPExecute ]
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

ClassMethod GetEveryOneQualDataPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEveryOneQualDataPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

//d ##Class(%ResultSet).RunQuery("web.DHCNurHGDA","GetEveryOneQualDataT","2014-09-01","2014-09-30","","")

/// 护理文书条目统计
Query GetEveryOneQualDataT(StDate As %String, EndDate As %String, wardid As %String, itemcode As %String) As %Query(ROWSPEC = "ItemCode,count,ItemDesc,ItemLevel,ItemLevelDesc,ItemValue,ItemValueDesc") [ SqlProc ]
{
}

ClassMethod GetEveryOneQualDataTExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", wardid = "", itemcode = "") As %Status
{
     //s StDate=$zdh(StDate,3)
    //s EndDate=$zdh(EndDate,3)
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i StDate="" s StDate=$zdh($p($zd(+$h,3),"-",1)_"-"_$p($zd(+$h,3),"-",2)_"-01",3)
 	e  s StDate=$zdh(StDate,3)
 	i EndDate="" s EndDate=+$h
 	e  s EndDate=$zdh(EndDate,3)
 	
    s rid=""
    f  s rid=$o(^DHCMGNUR.QualCodeItemD(rid))  q:rid=""  d
    .s aa=##class(DHCMGNUR.QualCodeItem).%OpenId(rid)
    .s QualCode=aa.QualCode
    .q:QualCode'="Qual3"
    .s rowid=""
    .f  s rowid=$o(^DHCMGNUR.QualCodeItemSubD(rid,rowid)) q:rowid=""  d
    ..s rowID=rid_"||"_rowid
    ..s bb=##class(DHCMGNUR.QualCodeItemSub).%OpenId(rowID)
    ..s ItemCode=bb.ItemCode
    ..s count(ItemCode)=0
    
    
	
	s chktyp=""  f  s chktyp=$o(^Nur.QualCheckRecI("QCheck",chktyp)) q:chktyp=""  d
	.s CTLocID="" f  s CTLocID=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID)) q:CTLocID=""  d
	..s CTDesc=$tr(CTLocID," ","")
	..s WardId=CTDesc
	..s countscore=0
	..s countPerComp=0
	..s countPerson=0
	..s WardDesc=$p(^CTLOC(CTDesc),"^",2)         //同一科室
	..s CheckCode="" f  s CheckCode=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode)) q:CheckCode=""  d
	...q:($TR(CheckCode," ","")'="QUAL3")      //分级护理    Qual3护理文件书写
	...s id="" f  s id=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode,id)) q:id=""  d
	....s CheckQuestion="",QuestionCode="",QuestionDesc="",QuestionTypeCode="",QuestionTypeDesc=""
	....s QualCheckThing=##class(Nur.QualCheckRec).%OpenId(id)
	....q:(QualCheckThing.CheckDate<StDate)||(QualCheckThing.CheckDate>EndDate)
	....s CheckDate=$zd(QualCheckThing.CheckDate,3)      //核查日期
	....s QualId="QUAL3"
	....s ID=id   //ID
	....s CheckPatName=##class(web.DHCMgQualCheck).getPatName($P(QualCheckThing.CheckPat,"^",2))
	....s Score=QualCheckThing.Score                        //分数
	....s PerComp=QualCheckThing.CompRate             //完成率
	....i Score="100" d
	.....i wardid="" s HD=2000
	.....else  q:(wardid'=WardId)
	.....i itemcode="" s HD=3000
	.....else  q:(QualCheckThing.CheckQuestion="")
	.....s countscore=countscore+Score
	.....s countPerComp=countPerComp+PerComp
	.....s countPerson=countPerson+1
	.....q
	....s TmpAddSum=1 f  s TmpAddSum=$o(^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSum)) q:TmpAddSum=""  d
	.....s a=^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSum)
	.....;w !,a
	.....q:$ListGet(a,6)'="未完成"
	.....i wardid="" s HD=2000
	.....else  q:(wardid'=WardId)
	.....s CheckQuestion=$ListGet(a,3)
	.....s CodeItemSubThing=##class(DHCMGNUR.QualCodeItemSub).%OpenId($ListGet(a,2))
	.....s QuestionCode=CodeItemSubThing.ItemCode
	.....s count(QuestionCode)=count(QuestionCode)+1
	.....s QuestionDesc=CodeItemSubThing.ItemDesc    //扣分条目
	.....s QuestionTypeCode=CodeItemSubThing.ItemLevel     //上级条目
	.....s TmpAddSumSub=1 f  s TmpAddSumSub=$o(^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSumSub)) q:TmpAddSumSub=""  d
	......s b=^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSumSub)
	......q:$ListGet(b,6)'=""
	......;w !,b
	......s QualCheckChildUp=##class(DHCMGNUR.QualCodeItemSub).%OpenId($ListGet(b,2))
	......q:(QualCheckChildUp.ItemCode'=QuestionTypeCode)
	......s QuestionTypeDesc=QualCheckChildUp.ItemDesc
	.....i itemcode="" s HD=3000
	.....else  q:QuestionCode'=itemcode
	.....s countscore=countscore+Score
	.....s countPerComp=countPerComp+PerComp
	.....s countPerson=countPerson+1
	..i countPerson'=0  d
	...set avgScore=countscore/countPerson
	...set avgPerComp=countPerComp/countPerson
	...set avgScore=$FN(avgScore,"p",2)
	...set avgPerComp=$FN(avgPerComp,"p",2)_"%"
	
	 s rid=""
    f  s rid=$o(^DHCMGNUR.QualCodeItemD(rid))  q:rid=""  d
    .s aa=##class(DHCMGNUR.QualCodeItem).%OpenId(rid)
    .s QualCode=aa.QualCode
    .q:QualCode'="Qual3"
    .s rowid=""
    .f  s rowid=$o(^DHCMGNUR.QualCodeItemSubD(rid,rowid)) q:rowid=""  d
    ..s rowID=rid_"||"_rowid
    ..s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(rowID)
    ..s temp=""
    ..d ..setTmp(ret,.temp)
    ..s flag= temp("MinLevel") ;$ListGet(ret,MinLevel)
    ..q:flag'="Y"
    ..s bb=##class(DHCMGNUR.QualCodeItemSub).%OpenId(rowID)
    ..s ItemCode=bb.ItemCode   //问题代码
    ..s ItemDesc=bb.ItemDesc   //问题描述
    ..s ItemLevel=bb.ItemLevel //二级代码
    ..s ItemValue=bb.ItemValue //一级代码
    ..s ItemLevelDesc=""
    ..s ItemValueDesc=""
    ..s rrid=""
    ..f  s rrid=$o(^DHCMGNUR.QualCodeItemSubD(rid,rrid)) q:rrid=""  d
    ...s cc=##class(DHCMGNUR.QualCodeItemSub).%OpenId(rid_"||"_rrid)
    ...i cc.ItemCode=ItemLevel  s ItemLevelDesc=cc.ItemDesc
    ...i cc.ItemCode=ItemValue  s ItemValueDesc=cc.ItemDesc
    ..d outtyp3
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp3
	set Data=$lb(ItemCode,count(ItemCode),ItemDesc,ItemLevel,ItemLevelDesc,ItemValue,ItemValueDesc)
	;set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEveryOneQualDataTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEveryOneQualDataTExecute ]
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

ClassMethod GetEveryOneQualDataTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEveryOneQualDataTExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

//分级护理

Query GetLevelsCareData(StDate As %String, EndDate As %String, wardid As %String, itemcode As %String) As %Query(ROWSPEC = "ID,CheckDate,WardDesc,QuestionDesc,QuestionCode,QuestionTypeDesc,QuestionTypeCode,CheckQuestion,CheckPatName,Score,PerComp,QualId,WardId") [ SqlProc ]
{
}

ClassMethod GetLevelsCareDataExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", wardid = "", itemcode = "") As %Status
{
	//s StDate=$zdh(StDate,3)
    //s EndDate=$zdh(EndDate,3)
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i StDate="" s StDate=$zdh($p($zd(+$h,3),"-",1)_"-"_$p($zd(+$h,3),"-",2)_"-01",3)
 	e  s StDate=$zdh(StDate,3)
 	i EndDate="" s EndDate=+$h
 	e  s EndDate=$zdh(EndDate,3)
	
	s chktyp=""  f  s chktyp=$o(^Nur.QualCheckRecI("QCheck",chktyp)) q:chktyp=""  d
	.s CTLocID="" f  s CTLocID=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID)) q:CTLocID=""  d
	..s CTDesc=$tr(CTLocID," ","")
	..s WardId=CTDesc
	..s WardDesc=$p(^CTLOC(CTDesc),"^",2)         //同一科室
	..s CheckCode="" f  s CheckCode=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode)) q:CheckCode=""  d
	...q:($TR(CheckCode," ","")'="QUAL2")      //分级护理    Qual3护理文件书写
	...s id="" f  s id=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode,id)) q:id=""  d
	....s CheckQuestion="",QuestionCode="",QuestionDesc="",QuestionTypeCode="",QuestionTypeDesc=""
	....s QualCheckThing=##class(Nur.QualCheckRec).%OpenId(id)
	....q:(QualCheckThing.CheckDate<StDate)||(QualCheckThing.CheckDate>EndDate)
	....s CheckDate=$zd(QualCheckThing.CheckDate,3)      //核查日期
	....s QualId="QUAL2"
	....s ID=id   //ID
	....s CheckPatName=##class(web.DHCMgQualCheck).getPatName($P(QualCheckThing.CheckPat,"^",2))
	....s Score=QualCheckThing.Score                        //分数
	....s PerComp=QualCheckThing.CompRate              //完成率
	....i Score="100" d
	.....i wardid="" s HD=2000
	.....else  q:(wardid'=WardId)
	.....i itemcode="" s HD=3000
	.....else  q:(QualCheckThing.CheckQuestion="")
	.....d outtyp3
	.....q
	....s TmpAddSum=1 f  s TmpAddSum=$o(^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSum)) q:TmpAddSum=""  d
	.....s a=^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSum)
	.....q:$ListGet(a,6)'="未完成"
	.....i wardid="" s HD=2000
	.....else  q:(wardid'=WardId)
	.....s CheckQuestion=$ListGet(a,3)
	.....s CodeItemSubThing=##class(DHCMGNUR.QualCodeItemSub).%OpenId($ListGet(a,2))
	.....s QuestionCode=CodeItemSubThing.ItemCode
	.....s QuestionDesc=CodeItemSubThing.ItemDesc    //扣分条目
	.....s QuestionTypeCode=CodeItemSubThing.ItemLevel     //上级条目
	.....s TmpAddSumSub=1 f  s TmpAddSumSub=$o(^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSumSub)) q:TmpAddSumSub=""  d
	......s b=^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSumSub)
	......q:$ListGet(b,6)'=""
	......s QualCheckChildUp=##class(DHCMGNUR.QualCodeItemSub).%OpenId($ListGet(b,2))
	......q:(QualCheckChildUp.ItemCode'=QuestionTypeCode)
	......s QuestionTypeDesc=QualCheckChildUp.ItemDesc
	.....i itemcode="" s HD=3000
	.....else  q:QuestionCode'=itemcode
	.....d outtyp3
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp3
	set Data=$lb(ID,CheckDate,WardDesc,QuestionDesc,QuestionCode,QuestionTypeDesc,QuestionTypeCode,CheckQuestion,CheckPatName,Score,PerComp,QualId,WardId)
	;set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLevelsCareDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLevelsCareDataExecute ]
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

ClassMethod GetLevelsCareDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLevelsCareDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

//d ##Class(%ResultSet).RunQuery("web.DHCNurHGDA","GetEveryOneQualDataWCL","2014-03-11","2014-03-11","","")

//护理文书完成率统计

Query GetEveryOneQualDataWCL(StDate As %String, EndDate As %String, wardid As %String, itemcode As %String) As %Query(ROWSPEC = "ID,CheckDate,season,WardDesc,flag1,flag2,flag3,CheckPatName,Score,PerComp,QualId,WardId")
{
}

ClassMethod GetEveryOneQualDataWCLExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", wardid = "", itemcode = "") As %Status
{
     //s StDate=$zdh(StDate,3)
    //s EndDate=$zdh(EndDate,3)
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i StDate="" s StDate=$zdh($p($zd(+$h,3),"-",1)_"-"_$p($zd(+$h,3),"-",2)_"-01",3)
 	e  s StDate=$zdh(StDate,3)
 	i EndDate="" s EndDate=+$h
 	e  s EndDate=$zdh(EndDate,3)
	
	s chktyp=""  f  s chktyp=$o(^Nur.QualCheckRecI("QCheck",chktyp)) q:chktyp=""  d
	.s CTLocID="" f  s CTLocID=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID)) q:CTLocID=""  d
	..s CTDesc=$tr(CTLocID," ","")
	..s WardId=CTDesc
	..s WardDesc=$p(^CTLOC(CTDesc),"^",2)         //同一科室
	..s CheckCode="" f  s CheckCode=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode)) q:CheckCode=""  d
	...q:($TR(CheckCode," ","")'="QUAL3")      //分级护理    Qual3护理文件书写
	...s id="" f  s id=$o(^Nur.QualCheckRecI("QCheck",chktyp,CTLocID,CheckCode,id)) q:id=""  d
	....s flag1="" ,flag2="",flag3=""
	....s CheckQuestion="",QuestionCode="",QuestionDesc="",QuestionTypeCode="",QuestionTypeDesc=""
	....s QualCheckThing=##class(Nur.QualCheckRec).%OpenId(id)
	....q:(QualCheckThing.CheckDate<StDate)||(QualCheckThing.CheckDate>EndDate)
	....s CheckDate=$zd(QualCheckThing.CheckDate,3)      //核查日期
	....s month=$p(CheckDate,"-",2)
	....if (month<4) s season="1季度"
	....e  if (month<7) s season="2季度"
	....e  if (month<10) s season="3季度"
	....e  s season="4季度"
	....s QualId="QUAL3"
	....s ID=id   //ID
	....s CheckPatName=##class(web.DHCMgQualCheck).getPatName($P(QualCheckThing.CheckPat,"^",2))
	....s Score=QualCheckThing.Score                        //分数
	....s PerComp=QualCheckThing.CompRate              //完成率
	....i Score="100" d
	.....i wardid="" s HD=2000
	.....else  q:(wardid'=WardId)
	.....i itemcode="" s HD=3000
	.....else  q:(QualCheckThing.CheckQuestion="")
	.....;d outtyp3
	.....q
	....s TmpAddSum=1 f  s TmpAddSum=$o(^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSum)) q:TmpAddSum=""  d
	.....s a=^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSum)
	.....q:$ListGet(a,6)'="未完成"
	.....i wardid="" s HD=2000
	.....else  q:(wardid'=WardId)
	.....s CheckQuestion=$ListGet(a,3)
	.....s CodeItemSubThing=##class(DHCMGNUR.QualCodeItemSub).%OpenId($ListGet(a,2))
	.....s QuestionCode=CodeItemSubThing.ItemCode
	.....s QuestionDesc=CodeItemSubThing.ItemDesc    //扣分条目
	.....s QuestionTypeCode=CodeItemSubThing.ItemLevel     //上级条目
	.....s TmpAddSumSub=1 f  s TmpAddSumSub=$o(^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSumSub)) q:TmpAddSumSub=""  d
	......s b=^Nur.QualCheckRecD(ID,"ChildRec",TmpAddSumSub)
	......q:$ListGet(b,6)'=""
	......s QualCheckChildUp=##class(DHCMGNUR.QualCodeItemSub).%OpenId($ListGet(b,2))
	......q:(QualCheckChildUp.ItemCode'=QuestionTypeCode)
	......s QuestionTypeDesc=QualCheckChildUp.ItemDesc
	.....i itemcode="" s HD=3000
	.....else  q:QuestionCode'=itemcode
	.....s Code1=$p(QuestionCode,".",1),Code2=$p(QuestionCode,".",2)
	.....if Code1=1 s flag1="是"
	.....if (Code1=3)&&(Code2=1) s flag2="是"
	.....if (Code1=3)&&(Code2=2) s flag3="是"
	....d outtyp3
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp3
	set Data=$lb(ID,CheckDate,season,WardDesc,flag1,flag2,flag3,CheckPatName,Score,PerComp,QualId,WardId)
	;set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEveryOneQualDataWCLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEveryOneQualDataWCLExecute ]
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

ClassMethod GetEveryOneQualDataWCLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEveryOneQualDataWCLExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod MasterNurChkCountExecute(ByRef qHandle As %Binary, stdate As %String, edate As %String) As %Status
{
 ///d ##Class(%ResultSet).RunQuery("web.DHCNurHGDA","MasterNurChkCount","2014-07-01","2014-07-31")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	  //s parr="2013-07-02^2013-07-02"
    //s stdate=$P(parr,"^",1)
    //s edate=$P(parr,"^",2)
    s typ="NightChk"
    //s typ=$ZConvert(typ,"U")
    if $L(stdate)'=5 set stdate=$zdh(stdate,3)
	if $L(edate)'=5 set edate=$zdh(edate,3)

    
	f date=stdate:1:edate
 	{
	  s p=""
	  f { 
	     s p=$O(^DHCMGNUR.QuCheckWardI("CheckDate",date,p))
	     q:p=""	     
	     s a=##class(DHCMGNUR.QuCheckWard).%OpenId(p)
	     if (typ'=a.CheckTyp) continue
	    s l=a.CheckUsers.Count()
	    s userstr=""
	    for i=1:1:l
	    {
		  	s rw=a.CheckUsers.GetAt(i)
		  	s User=$p($g(^SSU("SSUSR",rw)),"^",2)
		  	i $D(arr(User)) s arr(User)=arr(User)+1
		  	e  s arr(User)=1
			} 
	   }
	}
	s name="" f  s name=$o(arr(name)) q:name=""  d 
	.d OutRowtyp
  Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(name,arr(name))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MasterNurChkCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MasterNurChkCountExecute ]
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

ClassMethod MasterNurChkCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MasterNurChkCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query MasterNurChkCount(stdate As %String, edate As %String) As %Query(ROWSPEC = "NurseName,Count") [ SqlProc ]
{
}

ClassMethod setTmp(parr, tmp) As %String
{
	;w ##class(web.DHCNurRstNurInfo).setTmp(parr,.tmp)
	q:parr=""
	s tmp=""
	s l=$L(parr,"^")
	f i=1:1:l d
	.s item=$P(parr,"^",i)
	.q:item=""
	.s key=$P(item,"|",1)
	.s desc = $P(item,"|",2)
	.s tmp(key)=desc
	q 0
}

Storage Default
{
<Data name="DHCNurHGDADefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNurHGDAD</DataLocation>
<DefaultData>DHCNurHGDADefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCNurHGDAD</IdLocation>
<IndexLocation>^web.DHCNurHGDAI</IndexLocation>
<StreamLocation>^web.DHCNurHGDAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
