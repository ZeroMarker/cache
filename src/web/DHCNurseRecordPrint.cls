Class web.DHCNurseRecordPrint Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod GetPatDiag(Adm As %String, Code As %String) As %String
{
	s PatDiag=""
	q:Adm="" ""
	s parentId="" s parentId=$O(^NurEmr.DHCMgEmrDataI("Episode"," "_Adm,parentId),-1)
	q:parentId="" ""
	s chl="" s chl=$O(^NurEmr.DHCMgEmrDataD(parentId,"ParentID",chl),-1)
	q:chl="" ""
	s DataId=parentId_"||"_chl
	s rw="" s rw=$O(^NurEmr.NurEmrDataSchI("EmrData",DataId,rw),-1)
	q:rw="" ""
	s id="" s id=$O(^NurEmr.NurEmrDataSchItmI("Itm"," "_Code,rw,id),-1)
	q:id="" "" 
	s PatDiag=$list(^NurEmr.NurEmrDataSchD(rw,"ChildSch",id),3)
	q PatDiag
}

ClassMethod GetPrCareRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    //s parr="338155^2010-07-02^0:00^2010-07-18^0:00"
   // s ^tmp("nn")=parr
 	s Adm=$P(parr,"!",1)
 	s stdate=$ZDH($P(parr,"!",2),3)
 	if $P(parr,"!",4)'="" s eddate=$ZDH($P(parr,"!",4),3)
 	e  s eddate=$P($H,",")
 	s StTime=$ZTH($P(parr,"!",3))
 	if $P(parr,"!",5)'="" s EndTime=$ZTH($P(parr,"!",5))
 	e  s EndTime=$P($H,",",2)
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))

 	s rw=""  s rw=$O(^Nur.DHCNurSurgeryNurseRecD(par,rw)) 
     if rw'=""  
     {
        s arr=^Nur.DHCNurSurgeryNurseRecD(par,rw)
        s fdate=$listget(arr,4),ftime=$listget(arr,6)
    }
    s fdatetim=..GetAbsTime(fdate_","_ftime)
    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	//s stdate=cdate
 	//s eddate=$P($H,",",1)
 	//s dep=parr
 	     b  //dd

 	 f date=stdate:1:eddate
 	 {
        s tim="" f  s tim=$O(^Nur.DHCNurSurgeryNurseRecI("CareDatTim",date,tim)) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurSurgeryNurseRecI("CareDatTim",date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurSurgeryNurseRecD(par,rw)
        ..s cdate=$listget(arr,4),ctime=$listget(arr,6)
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..b //ll
        ..//除了第一条 和打印记录相同的过滤掉
        ..if (fdatetim'=cdatetime)&(cdatetime=stdatetime) q
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
        ..b //hh
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime)
		..s Temperature=$listget(arr,16)
		..s HeartRate=$listget(arr,8)
		..s Breath=$listget(arr,3)
		..s HPressure=$listget(arr,7)
		..s LPressure=$listget(arr,9)
		..s SPO2=$listget(arr,14)
		..s Wound=$listget(arr,21)
		..s SetTubeName=$listget(arr,15)
		..s TubeTend=$listget(arr,20)
		..s TractName=$listget(arr,19)
		..s TractStatus=$listget(arr,18)
		..s TractAmount=$listget(arr,17)
		..s NurQt=$listget(arr,10)
		..s CaseMeasure=$listget(arr,5) //
		..s CareDate=cdate,CareTime=ctime
		..d OutRowtyp
	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb( CareDate_"/"_CareTime,Temperature, HeartRate, Breath, HPressure_"/"_ LPressure, SPO2,  Wound, SetTubeName, TubeTend, TractName, TractStatus, TractAmount, NurQt ,CaseMeasure)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPrCareRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrCareRecExecute ]
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

ClassMethod GetPrCareRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrCareRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPrCareRec(parr As %String) As %Query(ROWSPEC = "CareDateTim,Temperature, HeartRate, Breath,Pressure, SPO2, Wound, SetTubeName, TubeTend, TractName,  TractStatus,TractAmount, NurQt ,CaseMeasure")
{
}

ClassMethod GetHead(adm) As %String
{
 //    s retStr="REGNO@"_regNo_"
       //^LOC@"_ctlocDesc_
      // "^ROOM@"_$g(room)
     //  _"^SEX@"_$g(sex)_
     //  "^PATNAME@"_$g(patName)_
     //  "^BEDCODE@"_$g(bedCode)
     //  _"^AGE@"_$g(age)_"岁
     //  ^WARD@"_$g(wardDesc)_
     //  "^DIAG@"_diag_
     //  "^MedCareNo@"_MedCareNo
    //s diag=..GetPatDiag(adm,"S116")
    s diag=""
    s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_adm,""),-1)
	i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	s diag=$tr(diag,";",",")
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")
	s diag="hhh"
    s patinfo=##class(web.DHCMGNurComm).PatInfo(adm)
    s loc=$P(patinfo,"^",2),ward=$P(patinfo,"^",8),pname=$P(patinfo,"^",5),bed=$P(patinfo,"^",6),diag=$p($P(patinfo,"^",9),"@",2),regno=$P(patinfo,"^",1)
    s sex=$P(patinfo,"^",4),age=$P(patinfo,"^",7)  
    s EncryptLevel=$P(patinfo,"^",25),PatLevel=$P(patinfo,"^",26)
	s papmiId=+^PAADM(adm)
    //s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s MedCareNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(adm) //调用病案接口取病案号
    i MedCareNo="-2" q "病案卷不存在"
    i MedCareNo="-1" q "获取病案号失败"
    //取护士录入的最新一条诊断
	//s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_adm,""),-1)
	//i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	//e  s diag=""
	//如果床位为空取转科记录最后一条
	s BedCode=$P(bed,"@",2)
    if BedCode="" 
    {
		s chl="" f  s chl=$O(^PAADM(adm,"TRANS",chl),-1) q:(chl="")!(BedCode'="")  d
		.s bedDr=$P(^PAADM(adm,"TRANS",chl),"^",8)
		.q:bedDr=""
		.s BedCode=$p($g(^PAWARD($P(bedDr,"||",1),"BED",$P(bedDr,"||",2))),"^",1)
	}
    s ret="床号:"_BedCode_"   姓名:"_$P(pname,"@",2)_"   性别:"_$P(sex,"@",2)_"   年龄:"_$P(age,"@",2)_"   诊断:"_diag_"  ID号:"_$P(regno,"@",2)_"  住院号:"_MedCareNo_" 病人密级:"_$p(EncryptLevel,"@",2)_" 病人级别:"_$p(PatLevel,"@",2)_"^科室:"_$P(ward,"@",2)
    ;s ret="床号:"_BedCode_"&nbsp;&nbsp;&nbsp;姓名:"_$P(pname,"@",2)_"&nbsp;&nbsp;&nbsp;性别:"_$P(sex,"@",2)_"&nbsp;&nbsp;&nbsp;年龄:"_$P(age,"@",2)_"&nbsp;&nbsp;&nbsp;诊断:"_diag_"&nbsp;&nbsp;&nbsp;ID号:"_$P(regno,"@",2)_"&nbsp;&nbsp;&nbsp;住院号:"_MedCareNo_"&nbsp;&nbsp;&nbsp;^科室:"_$P(ward,"@",2)
    q ret
}

// 南方医院 距离加宽

ClassMethod GetHeadAddNbsp(adm) As %String
{
 //    s retStr="REGNO@"_regNo_"
       //^LOC@"_ctlocDesc_
      // "^ROOM@"_$g(room)
     //  _"^SEX@"_$g(sex)_
     //  "^PATNAME@"_$g(patName)_
     //  "^BEDCODE@"_$g(bedCode)
     //  _"^AGE@"_$g(age)_"岁
     //  ^WARD@"_$g(wardDesc)_
     //  "^DIAG@"_diag_
     //  "^MedCareNo@"_MedCareNo
    //s diag=..GetPatDiag(adm,"S116")
    s diag=""
    s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_adm,""),-1)
	i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	s diag=$tr(diag,";",",")
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")
	s diag="hhh"
    s patinfo=##class(web.DHCMGNurComm).PatInfo(adm)
    s loc=$P(patinfo,"^",2),ward=$P(patinfo,"^",8),pname=$P(patinfo,"^",5),bed=$P(patinfo,"^",6),diag=$p($P(patinfo,"^",9),"@",2),regno=$P(patinfo,"^",1)
    s sex=$P(patinfo,"^",4),age=$P(patinfo,"^",7), admDate=$P(patinfo,"^",15)
    s EncryptLevel=$P(patinfo,"^",25),PatLevel=$P(patinfo,"^",26)
	s papmiId=+^PAADM(adm)
    //s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s MedCareNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(adm) //调用病案接口取病案号
    i MedCareNo="-2" q "病案卷不存在"
    i MedCareNo="-1" q "获取病案号失败"
    //取护士录入的最新一条诊断
	//s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_adm,""),-1)
	//i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	//e  s diag=""
	//如果床位为空取转科记录最后一条
	s BedCode=$P(bed,"@",2)
    if BedCode="" 
    {
		s chl="" f  s chl=$O(^PAADM(adm,"TRANS",chl),-1) q:(chl="")!(BedCode'="")  d
		.s bedDr=$P(^PAADM(adm,"TRANS",chl),"^",8)
		.q:bedDr=""
		.s BedCode=$p($g(^PAWARD($P(bedDr,"||",1),"BED",$P(bedDr,"||",2))),"^",1)
	}
    ;s ret="床号:"_BedCode_"   姓名:"_$P(pname,"@",2)_"   性别:"_$P(sex,"@",2)_"   年龄:"_$P(age,"@",2)_"   诊断:"_diag_"  ID号:"_$P(regno,"@",2)_"  住院号:"_MedCareNo_" 病人密级:"_$p(EncryptLevel,"@",2)_" 病人级别:"_$p(PatLevel,"@",2)_"^科室:"_$P(ward,"@",2)
    s ret="床号:"_BedCode_"&nbsp;&nbsp;&nbsp;姓名:"_$P(pname,"@",2)_"&nbsp;&nbsp;&nbsp;性别:"_$P(sex,"@",2)_"&nbsp;&nbsp;&nbsp;年龄:"_$P(age,"@",2)_"&nbsp;&nbsp;&nbsp;诊断:"_diag_"&nbsp;&nbsp;&nbsp;ID号:"_$P(regno,"@",2)_"&nbsp;&nbsp;&nbsp;住院号:"_MedCareNo_"&nbsp;&nbsp;&nbsp;^科室:"_$P(ward,"@",2)_"&nbsp;&nbsp;&nbsp;入院时间:"_$P(admDate,"@",2)
    q ret
}

/// 通用护理记录打印
/// 2010-09-16
ClassMethod GetCareRecCommExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	//s parr="2!2011-01-07!11:15!!!DHCNURXH2"
 	//d ##class(%ResultSet).RunQuery("web.DHCNurseRecordPrint","GetCareRecComm","")
	s Adm=$P(parr,"!",1)
	s RecTyp=$P(parr,"!",6)
	s stdate=$P(parr,"!",2)
	s StTime=$P(parr,"!",3)
	s RecTyp=$ZConvert(RecTyp,"U")

	if stdate=""
	{
		s arr=##class(Nur.DHCNursePrintRec).getstdatetim(RecTyp,Adm)
		//"0^0^"_stdate_"^"_stim_"^^"
		s stdate=$P(arr,"^",3)
		s StTime=$P(arr,"^",4)
	}
	s stdate=$ZDH(stdate,3)
	s StTime=$ZTH(StTime,3)
 	if $P(parr,"!",2)'="" s stdate=$ZDH($P(parr,"!",2),3)
 	if $P(parr,"!",4)'="" s eddate=$ZDH($P(parr,"!",4),3)
 	e  s eddate=$P($H,",")
 	if $P(parr,"!",3)'="" s StTime=$ZTH($P(parr,"!",3))
 	if $P(parr,"!",5)'="" s EndTime=$ZTH($P(parr,"!",5))
 	e  s EndTime=$P($H,",",2)
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	//s RecTyp=$P(parr,"!",6)
 	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
    s fdatetim=""
	s dat="" f  s dat=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat)) q:(dat="")!(fdatetim'="")  d
    .s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim)) q:(tim="")!(fdatetim'="")  d
    ..s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim,par,rw)) q:(rw="")!(fdatetim'="")  d
    ...s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
    ...s fdate=$listget(arr,3),ftime=$listget(arr,4)
    ...s fdatetim=..GetAbsTime($G(fdate)_","_$G(ftime))
	//血压及显示到病情变化列
	s ret=##class(Nur.DHCNurseRecSet).getSet(RecTyp)
	s PartInProperty=$P(ret,"^",3)
	s PartInNameProperty=$P(PartInProperty,"&",1)
	s PartInAmountProperty=$P(PartInProperty,"&",2)
	s PartOutProperty=$P(ret,"^",4)
	s PartOutNameProperty=$P(PartOutProperty,"&",1)
	s PartOutAmountProperty=$P(PartOutProperty,"&",2)
	s Pressure=$P(ret,"^",5)
	s CaseMeasureItem=$P(ret,"^",7)

	f date=stdate:1:eddate
	{
        s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim)) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurseRecSubD(par,rw)
        ..s cdate=$listget(arr,3),ctime=$listget(arr,4)
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..b //ll
        ..//除了第一条 和打印记录相同的过滤掉
        ..if (fdatetim'=cdatetime)&(cdatetime=stdatetime) q
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
        ..b //hh
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime)
		..//作废护理记录不打印
		..s reccanceluserId=$listget(arr,67)
		..q:reccanceluserId'=""
		..s a1="Item1",@a1=$listget(arr,7),b1="Item1"
		..s a2="Item2",@a2=$listget(arr,18),b2="Item2"
		..s a3="Item3",@a3=$listget(arr,29),b3="Item3"
		..s a4="Item4",@a4=$listget(arr,40),b4="Item4"
		..s a5="Item5",@a5=$listget(arr,51),b5="Item5"
		..s a6="Item6",@a6=$listget(arr,53),b6="Item6"
		..s a7="Item7",@a7=$listget(arr,54),b7="Item7"
		..s a8="Item8",@a8=$listget(arr,55),b8="Item8"
		..s a9="Item9",@a9=$listget(arr,56),b9="Item9"
		..s a10="Item10",@a10=$listget(arr,8),b10="Item10"
		..s a11="Item11",@a11=$listget(arr,9),b11="Item11"
		..s a12="Item12",@a12=$listget(arr,10),b12="Item12"
		..s a13="Item13",@a13=$listget(arr,11),b13="Item13"
		..s a14="Item14",@a14=$listget(arr,12),b14="Item14"
		..s a15="Item15",@a15=$listget(arr,13),b15="Item15"
		..s a16="Item16",@a16=$listget(arr,14),b16="Item16"
		..s a17="Item17",@a17=$listget(arr,15),b17="Item17"
		..s a18="Item18",@a18=$listget(arr,16),b18="Item18"
		..s a19="Item19",@a19=$listget(arr,17),b19="Item19"
		..s a20="Item20",@a20=$listget(arr,19),b20="Item20"
		..s a21="Item21",@a21=$listget(arr,20),b21="Item21"
		..s a22="Item22",@a22=$listget(arr,21),b22="Item22"
		..s a23="Item23",@a23=$listget(arr,22),b23="Item23"
		..s a24="Item24",@a24=$listget(arr,23),b24="Item24"
		..s a25="Item25",@a25=$listget(arr,24),b25="Item25"
		..s a26="Item26",@a26=$listget(arr,25),b26="Item26"
		..s a27="Item27",@a27=$listget(arr,26),b27="Item27"
		..s a28="Item28",@a28=$listget(arr,27),b28="Item28"
		..s a29="Item29",@a29=$listget(arr,28),b29="Item29"
		..s a30="Item30",@a30=$listget(arr,30),b30="Item30"
		..s a31="Item31",@a31=$listget(arr,31),b31="Item31"
		..s a32="Item32",@a32=$listget(arr,32),b32="Item32"
		..s a33="Item33",@a33=$listget(arr,33),b33="Item33"
		..s a34="Item34",@a34=$listget(arr,34),b34="Item34"
		..s a35="Item35",@a35=$listget(arr,35),b35="Item35"
		..s a36="Item36",@a36=$listget(arr,36),b36="Item36"
		..s a37="Item37",@a37=$listget(arr,37),b37="Item37"
		..s a38="Item38",@a38=$listget(arr,38),b38="Item38"
		..s a39="Item39",@a39=$listget(arr,39),b39="Item39"
		..s a40="Item40",@a40=$listget(arr,41),b40="Item40"
		..s a41="Item41",@a41=$listget(arr,42),b41="Item41"
		..s a42="Item42",@a42=$listget(arr,43),b42="Item42"
		..s a43="Item43",@a43=$listget(arr,44),b43="Item43"
		..s a44="Item44",@a44=$listget(arr,45),b44="Item44"
		..s a45="Item45",@a45=$listget(arr,46),b45="Item45"
		..s a46="Item46",@a46=$listget(arr,47),b46="Item46"
		..s a47="Item47",@a47=$listget(arr,48),b47="Item47"
		..s a48="Item48",@a48=$listget(arr,49),b48="Item48"
		..s a49="Item49",@a49=$listget(arr,50),b49="Item49"
		..s a50="Item50",@a50=$listget(arr,52),b50="Item50"
		..s CaseMeasure=$listget(arr,5)
		..s CareDate=cdate,CareTime=ctime
		..s CareDate=$P(CareDate,"-",2)_"-"_$P(CareDate,"-",3)
		..s CareTime=$P(CareTime,":",1)_":"_$P(CareTime,":",2)
		..s recuserId=$listget(arr,59)
		..i recuserId'="" s User=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		..e  s User=""
		..s recaudituserId=$listget(arr,64)
		..i recaudituserId'="" s AuditUser=$p($g(^SSU("SSUSR",recaudituserId)),"^",2)
		..e  s AuditUser=""
		..i AuditUser'="" d
		...s User=User_" "_AuditUser
		..s DiagnosDr=$listget(arr,60)
		..////出入量分项//不打印只显示
		..//s InOutDr=$listget(arr,6)
		..//i InOutDr'="" d
		..//.s @PartInNameProperty="入液量分项="
		..//.s @PartInAmountProperty=##class(Nur.DHCNurPatSumInOutSub).GetSubInOutt(InOutDr_"^I")
		..//.s @PartOutNameProperty="出液量分项="
		..//.s @PartOutAmountProperty=##class(Nur.DHCNurPatSumInOutSub).GetSubInOutt(InOutDr_"^O")
		..f ii=1:1:$L(Pressure,"&") d
		...s PressureItem=$P(Pressure,"&",ii)
		...q:PressureItem=""
		...s HPressure=$P(PressureItem,"/",1)
		...s LPressure=$P(PressureItem,"/",2)
		...i HPressure'="",LPressure'="",@LPressure'="" s @HPressure=@HPressure_"/"_@LPressure
		..s nurse=""
		..f ii=1:1:$L(CaseMeasureItem,"&") d
		...s nurseItem=$P($P(CaseMeasureItem,"&",ii),"!",1)
		...q:nurseItem=""
		...s nurseItemDesc=$P($P(CaseMeasureItem,"&",ii),"!",2)
		...s nurseCare=@nurseItem
		...if nurseCare'="" s nurse=nurse_nurseItemDesc_":"_nurseCare_" "
		..s CaseMeasure=nurse_CaseMeasure
		..s Item1=@b1,Item2=@b2,Item3=@b3,Item4=@b4,Item5=@b5,Item6=@b6,Item7=@b7,Item8=@b8,Item9=@b9,Item10=@b10
		..s Item11=@b11,Item12=@b12,Item13=@b13,Item14=@b14,Item15=@b15,Item16=@b16,Item17=@b17,Item18=@b18,Item19=@b19,Item20=@b20
		..s Item21=@b21,Item22=@b22,Item23=@b23,Item24=@b24,Item25=@b25,Item26=@b26,Item27=@b27,Item28=@b28,Item29=@b29,Item30=@b30
		..s Item31=@b31,Item32=@b32,Item33=@b33,Item34=@b34,Item35=@b35,Item36=@b36,Item37=@b37,Item38=@b38,Item39=@b39,Item40=@b40
		..s Item41=@b41,Item42=@b42,Item43=@b43,Item44=@b44,Item45=@b45,Item46=@b46,Item47=@b47,Item48=@b48,Item49=@b49,Item50=@b50
		..d OutRowtyp
	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(CareDate,CareTime,Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20,Item21,Item22,Item23,Item24,Item25,Item26,Item27,Item28,Item29,Item30,Item31,Item32,Item33,Item34,Item35,Item36,Item37,Item38,Item39,Item40,Item41,Item42,Item43,Item44,Item45,Item46,Item47,Item48,Item49,Item50,CaseMeasure,User,DiagnosDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCareRecCommFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareRecCommExecute ]
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

ClassMethod GetCareRecCommClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareRecCommExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCareRecComm(parr1 As %String) As %Query(ROWSPEC = "CareDate,CareTime,Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20,Item21,Item22,Item23,Item24,Item25,Item26,Item27,Item28,Item29,Item30,Item31,Item32,Item33,Item34,Item35,Item36,Item37,Item38,Item39,Item40,Item41,Item42,Item43,Item44,Item45,Item46,Item47,Item48,Item49,Item50,CaseMeasure,User,DiagnosDr") [ SqlProc ]
{
}

/// 	母婴同室新生儿护理观察记录标题
/// 	2010-09-30
ClassMethod GetHeadBaby(adm) As %String
{
    //w ##class(web.DHCNurseRecordPrint).GetHeadBaby("341895")
    s motherAdmId=$P(^PAADM(adm),"^",75)
    q:motherAdmId="" "^请选择新生儿!^"
    s motherInfo=##class(web.DHCMGNurComm).PatInfo(motherAdmId)
    s motherName=$P(motherInfo,"^",5)
    s patinfo=##class(web.DHCMGNurComm).PatInfo(adm)
    s sex=$P(patinfo,"^",4),bed=$P(patinfo,"^",6),regno=$P(patinfo,"^",1)
    //放到RHead中,LHead判断了"诊断"两字
    s ret="^母亲姓名:"_$P(motherName,"@",2)_"    婴儿性别:"_$P(sex,"@",2)_"    床号:"_$P(bed,"@",2)_"    登记号:"_$P(regno,"@",2)_"^"
    q ret
}

}
