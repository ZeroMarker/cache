Import SQLUser

/// 病案编目查询
Class web.DHCWMRCircul.FrontPageQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 191;

ClassMethod QryNotFrontPageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNotFrontPageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNotFrontPageExecute(ByRef qHandle As %Binary, AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String, Recipient As %String = "", PrintFlag As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,4) 
	set OutPutTotal=0
	
	s ^ZF(11)=$lb(AdmLoc,AdmWard,AdmDoc,DateFrom,DateTo)
	q:(DateFrom="")||(DateTo="") $$$OK
	
	k ^CacheTemp("QryNotFrontPage",$zn,$j)
	f tmpDate=DateFrom:1:DateTo d
	.s Paadm=0
	.f  s Paadm=$o(^PAADMi("DischDate",tmpDate,Paadm)) q:Paadm=""  d
	..s tmpPaadm=$g(^PAADM(+Paadm))
	..q:tmpPaadm=""
	..q:$p(tmpPaadm,"^",75)'=""                //婴儿不算
	..s VisitStatus=$p(tmpPaadm,"^",20)        //就诊状态
	..q:VisitStatus'="D"                       //过滤掉召回的病人
	..q:$p(tmpPaadm,"^",2)'="I"                //过滤掉门诊走住院的病人
	..s tmpLoc=$p(tmpPaadm,"^",4)
	..q:(AdmLoc'="")&&(tmpLoc'=AdmLoc)         //出院科室
	..s tmpWard=$p(tmpPaadm,"^",70)
	..q:(AdmWard'="")&&(tmpWard'=AdmWard)      //出院病区
	..s tmpDoc=$p(tmpPaadm,"^",9)
	..q:(AdmDoc'="")&&(tmpDoc'=AdmDoc)         //主管医生
	..q:tmpLoc=""
	..;s Recipient=""
	..s tmpLoc=tmpLoc_"||"_tmpWard
	..s VolRowid=0
	..f  s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",+Paadm,VolRowid)) q:VolRowid=""  d
	...s VolStatus=$$DisplayNoFP(VolRowid,Recipient)
	...q:VolStatus=""
	...s ^CacheTemp("QryNotFrontPage",$zn,$j,tmpLoc)=(+$g(^CacheTemp("QryNotFrontPage",$zn,$j,tmpLoc)))+1
	...s ^CacheTemp("QryNotFrontPage",$zn,$j,tmpLoc,Paadm)=VolRowid
	
	s tmpLoc=0
	f  s tmpLoc=$o(^CacheTemp("QryNotFrontPage",$zn,$j,tmpLoc)) q:tmpLoc=""  d
	.s tmpLocDesc=$p($g(^CTLOC(+$p(tmpLoc,"||",1))),"^",2)
	.s:tmpLocDesc["-" tmpLocDesc=$p(tmpLocDesc,"-",2)
	.s tmpWardDesc=$p($g(^PAWARD(+$p(tmpLoc,"||",2))),"^",2)  //PAC_Ward
	.s WLocID=$p($g(^PAWARD(+$p(tmpLoc,"||",2))),"^",5)
	.s:WLocID'="" tmpWardDesc=$p($g(^CTLOC(+WLocID)),"^",2)
	.s:tmpWardDesc["-" tmpWardDesc=$p(tmpWardDesc,"-",2)
	.s Count=+$g(^CacheTemp("QryNotFrontPage",$zn,$j,tmpLoc))
	.s Data=$lb("---","---","---","---","---","---","----",tmpLocDesc_":"_Count,"---","---",Count,"---","---","---")
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.s Paadm=0
	.f  s Paadm=$o(^CacheTemp("QryNotFrontPage",$zn,$j,tmpLoc,Paadm)) q:Paadm=""  d
	..s tmpPaadm=$g(^PAADM(+Paadm))
	..q:tmpPaadm=""
	..s tmpDoc=$p(tmpPaadm,"^",9)
	..s Papmi=$p(tmpPaadm,"^",1)
	..s RegNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	..s VolRowid=+$g(^CacheTemp("QryNotFrontPage",$zn,$j,tmpLoc,Paadm))
	..s MrNo=""
	..if VolRowid'=0 d
	...s MainDr=$p($g(^DHCWMRVOL(VolRowid)),"^",1)
	...q:MainDr=""
	...s MrNo=$p($g(^DHCWMRMAIN(MainDr)),"^",2) //$p($g(^PAPER(+Papmi,"PAT",1)),"^",22)	
	..s:($p($g(^DHCMedHosptial(0)),"/",4)="ChengDu_HX") MrNo=$p(tmpPaadm,"^",81)
	..s PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	..s Sex=$p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	..s BirthDay=$p($g(^PAPER(+Papmi,"ALL")),"^",6)
	..s:BirthDay'="" BirthDay=$zd(BirthDay,3)
	..s Age=($p(($zd($h,3)),"-",1)-$p(BirthDay,"-",1))

	..s AdmDate=$zd($p(tmpPaadm,"^",6),3)
	..s DischDate=$p(tmpPaadm,"^",17)
	..s:DischDate'="" DischDate=$zd(DischDate,3)
	..s DocDesc=$p($g(^CTPCP(+tmpDoc)),"^",2)    //CT_CareProv
	..s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",+tmpDoc,0))  //SS_User
	..s:SSUserID'="" DocDesc=$p($g(^SSU("SSUSR",+SSUserID)),"^",2)
	..///wangCS 2011-07-08 修改
	..///^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
    ..set MVRowId=0
    ..f  s MVRowId=$o(^DHCWMRVOL(0,"VolAdm",+Paadm,MVRowId)) q:MVRowId=""  d
    ...set VolStatus=$$DisplayNoFP(MVRowId,Recipient)
	...set ToUser=$p($g(VolStatus),"^",6)   //接收人
	...set ToUser=$p($g(ToUser),"/",3)
	...q:(Recipient'="")&(ToUser'[Recipient)  //接收人不为空 过滤接收人
	...set Status=$p($g(VolStatus),"^",2)   //病案状态
	...set Status=$p($g(Status),"/",3)
	...Set OutPutTotal=OutPutTotal+1
	
	...s Data=$lb(RegNo,MrNo,PatName,Sex,BirthDay,AdmDate,DischDate,tmpLocDesc,tmpWardDesc,DocDesc,"---",ToUser,Status,Age)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	k ^CacheTemp("QryFrontPage",$zn,$j)
	w:PrintFlag'="Y" "<span style='font-size:medium; font-weight:bold;color:Red;'>数量:"_OutPutTotal_"</span>"
	Quit $$$OK
DisplayNoFP(MVRowId,Recipient)
    n (MVRowId,Recipient)
    set ret=""
    q:$p($g(^DHCWMRVOL(MVRowId)),"^",7)'="Y" ret
    q:$d(^DHCWMRFP(0,"VolumeDr",MVRowId)) ret   //已编目退出
    s ChildSub=0
	s ChildSub=$o(^DHCWMRVOL(MVRowId,"S",""),-1)
	q:ChildSub="" ret
	set VolStatus=##Class(web.DHCWMRVolumeCtl).GetVolStatus(+MVRowId,ChildSub)
	set ToUser=$p($g(VolStatus),"^",6)      //接收人
	set ToUser=$p($g(ToUser),"/",3)
	q:(Recipient'="")&(ToUser'[Recipient) ret  //接收人不为空 过滤接收人
	quit VolStatus
}

ClassMethod QryNotFrontPageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNotFrontPageExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:wangCS
/// CreateDate:2011-07-10
/// Description:打印、导出为编目病案
/// Input:Arguments Loc+"^"+Ward+"^"+Doc+"^"+DateFrom+"^"+DateTo+"^"+Recipient 科室^病区^医生^开始日期^结束日期^接收人
/// d ##Class(web.DHCWMRCircul.FrontPageQry).QryNotFrontPageToPrint("","^^^10/07/2001^10/07/2011^")
ClassMethod QryNotFrontPageToPrint(itmJS As %String = "", Arguments As %String = "") As %String
{
	n (itmJS,Arguments)
	s Total=0
	
	s Loc=$p($g(Arguments),"^",1) 
	s Ward=$p($g(Arguments),"^",2)
	s Doc=$p($g(Arguments),"^",3)
	s DataFrom=$p($g(Arguments),"^",4)
	s DataTo=$p($g(Arguments),"^",5)
	s Recipient=$p($g(Arguments),"^",6)
	
	s ds=##Class(%Library.ResultSet).%New("web.DHCWMRCircul.FrontPageQry:QryNotFrontPage")
	;s ^CacheTemp("DDDDD")=Loc_"||"_Ward_"||"_Doc_"||"_DataFrom_"||"_DataTo_"||"_Recipient
	d ds.Execute(Loc,Ward,Doc,DataFrom,DataTo,Recipient,"Y")
	s StartRow=4
	while(ds.Next())
	{
		s RegNo=ds.Data("RegNo")  //住院号
		s MrNo=ds.Data("MrNo")    //病案号
		s PatName=ds.Data("PatName") //病人姓名
		s Sex=ds.Data("Sex")       //性别
		s BirthDay=ds.Data("BirthDay")  //出生日期
		s AdmDate=ds.Data("AdmDate")    //入院日期
		s DischDate=ds.Data("DischDate") //出院日期
		s LocDesc=ds.Data("LocDesc")    //科室
		s WardDesc=ds.Data("WardDesc")  //病区
		s DocDesc=ds.Data("DocDesc")    //医生
		s Count=ds.Data("Count")        //数量
		s ToUser=ds.Data("ToUser")      //接收人
		s Status=ds.Data("Status")      //病案状态
		if ($ISVALIDNUM(Count))
		{
			s Total=+Count+Total
		}
		s ExcelRow=RegNo_$c(1)_MrNo_$c(1)_PatName_$c(1)_Sex_$c(1)_BirthDay_$c(1)_AdmDate_$c(1)_DischDate_$c(1)_LocDesc_$c(1)_WardDesc_$c(1)_DocDesc_$c(1)_Status_$c(1)_ToUser_$c(1)_Count
		
		s retVal=itmJS_"(xlSheet,'"_$ZCVT(ExcelRow,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retVal)#>
		s StartRow=StartRow+1
		
		
	}
	d ds.Close()
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	//s valCells="日期："_$zd($zdh(DataFrom,4),3)_" 至 "_$zd($zdh(DataTo,4),3)_"    合计:"_Count_"份"
	s valCells="日期："_$zd($zdh(DataFrom,4),3)_" 至 "_$zd($zdh(DataTo,4),3)_"    合计:"_Total_"份"
	s retval=itmJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

/// ****************************************************************
/// 功能说明   : 未编目查询
/// 入参       : 
/// AdmLoc     : 就诊科室
/// AdmWard    : 就诊病区
/// AdmDoc     : 就诊医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// 备注       : 
/// 程序调试   : w ##Class(%ResultSet).RunQuery("web.DHCWMRCircul.FrontPageQry","QryNotFrontPage","","","",62007,62908)
/// ****************************************************************
Query QryNotFrontPage(AdmLoc As %String = "", AdmWard As %String = "", AdmDoc As %String = "", DateFrom As %String = "", DateTo As %String = "", Recipient As %String = "", PrintFlag As %String = "") As %Query(ROWSPEC = "RegNo:%String,MrNo:%String,PatName:%String,Sex:%String,BirthDay:%String,AdmDate:%String,DischDate:%String,LocDesc:%String,WardDesc:%String,DocDesc:%String,Count:%String,ToUser:%String,Status:%String,Age:%String")
{
}

ClassMethod QryFrontPageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFrontPageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFrontPageExecute(ByRef qHandle As %Binary, AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	;s ^ZF(11)=$lb(AdmLoc,AdmWard,AdmDoc,DateFrom,DateTo)
	q:(DateFrom="")||(DateTo="") $$$OK
	
	k ^CacheTemp("QryFrontPage",$zn,$j)
	f tmpDate=DateFrom:1:DateTo d
	.s Paadm=0
	.f  s Paadm=$o(^PAADMi("DischDate",tmpDate,Paadm)) q:Paadm=""  d
	..s tmpPaadm=$g(^PAADM(+Paadm))
	..q:tmpPaadm=""
	..q:$p(tmpPaadm,"^",75)'=""                //婴儿不算
	..s VisitStatus=$p(tmpPaadm,"^",20)        //就诊状态
	..q:VisitStatus'="D"                       //过滤掉召回的病人
	..q:$p(tmpPaadm,"^",2)'="I"                //过滤掉门诊走住院的病人
	..s tmpLoc=$p(tmpPaadm,"^",4)
	..q:(AdmLoc'="")&&(tmpLoc'=AdmLoc)         //出院科室
	..s tmpWard=$p(tmpPaadm,"^",70)
	..q:(AdmWard'="")&&(tmpWard'=AdmWard)      //出院病区
	..s tmpDoc=$p(tmpPaadm,"^",9)
	..q:(AdmDoc'="")&&(tmpDoc'=AdmDoc)         //主管医生
	..q:tmpLoc=""
	..s tmpLoc=tmpLoc_"||"_tmpWard
	..s VolRowid=0
	..f  s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",+Paadm,VolRowid)) q:VolRowid=""  d
	...q:$p($g(^DHCWMRVOL(VolRowid)),"^",7)'="Y"
	...q:'$d(^DHCWMRFP(0,"VolumeDr",VolRowid))    //未编目退出
	...s ^CacheTemp("QryFrontPage",$zn,$j,tmpLoc)=(+$g(^CacheTemp("QryFrontPage",$zn,$j,tmpLoc)))+1
	...s ^CacheTemp("QryFrontPage",$zn,$j,tmpLoc,Paadm)=""
	
	s tmpLoc=0
	f  s tmpLoc=$o(^CacheTemp("QryFrontPage",$zn,$j,tmpLoc)) q:tmpLoc=""  d
	.s tmpLocDesc=$p($g(^CTLOC(+$p(tmpLoc,"||",1))),"^",2)
	.s:tmpLocDesc["-" tmpLocDesc=$p(tmpLocDesc,"-",2)
	.s tmpWardDesc=$p($g(^PAWARD(+$p(tmpLoc,"||",2))),"^",2)  //PAC_Ward
	.s WLocID=$p($g(^PAWARD(+$p(tmpLoc,"||",2))),"^",5)
	.s:WLocID'="" tmpWardDesc=$p($g(^CTLOC(+WLocID)),"^",2)
	.s:tmpWardDesc["-" tmpWardDesc=$p(tmpWardDesc,"-",2)
	.s Count=+$g(^CacheTemp("QryFrontPage",$zn,$j,tmpLoc))
	.s Data=$lb("---","---","---","---","---","---","---","---",tmpLocDesc_":"_Count,"---","---",Count,"---","---","---","---","---","---","---","---")
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.s Paadm=0
	.f  s Paadm=$o(^CacheTemp("QryFrontPage",$zn,$j,tmpLoc,Paadm)) q:Paadm=""  d
	..s tmpPaadm=$g(^PAADM(+Paadm))
	..q:tmpPaadm=""
	..s tmpLocID=$p(tmpPaadm,"^",4)
	..s tmpWardID=$p(tmpPaadm,"^",70)
	..s tmpDoc=$p(tmpPaadm,"^",9)
	..s Papmi=$p(tmpPaadm,"^",1)
	..s RegNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	..s MrNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	..s:($p($g(^DHCMedHosptial(0)),"/",4)="ChengDu_HX") MrNo=$p(tmpPaadm,"^",81)
	..s PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	..s Sex=$p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	..s BirthDay=$p($g(^PAPER(+Papmi,"ALL")),"^",6)
	..s:BirthDay'="" BirthDay=$zd(BirthDay,3)
	..s Age=($p(($zd($h,3)),"-",1)-$p(BirthDay,"-",1))
	..s AdmDate=$zd($p(tmpPaadm,"^",6),3)
	..s DischDate=$zd($p(tmpPaadm,"^",17),3)
	..s Days=((+$p(tmpPaadm,"^",17))-(+$p(tmpPaadm,"^",6)))  //住院天数
	..s DocDesc=$p($g(^CTPCP(+tmpDoc)),"^",2)    //CT_CareProv
	..s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",+tmpDoc,0))  //SS_User
	..s:SSUserID'="" DocDesc=$p($g(^SSU("SSUSR",+SSUserID)),"^",2)
	..s MainICD=..getFrontPageICD(Paadm,"D/1",1)  //主要诊断
	..s MainCode=$p(MainICD,$c(2),1)
	..s MainDesc=$p(MainICD,$c(2),2)
	..s MainResult=$p(MainICD,$c(2),3)  //出院情况
	..s OperInfo=""
	..s Operation="",Index=1  //手术
	..f  s Operation=..getFrontPageICD(Paadm,"O/1",Index) q:(Operation="")  d
	...s OperInfo=OperInfo_$lb(Operation)
	...s Index=Index+1
	..//s Operation="",Index=1  //操作
	..//f  s Operation=..getFrontPageICD(Paadm,"O/2",Index) q:(Operation="")  d
	..//.s OperInfo=OperInfo_$lb(Operation)
	..//.s Index=Index+1
	..i OperInfo="" d
	...s Data=$lb(RegNo,MrNo,PatName,Sex,BirthDay,AdmDate,DischDate,Days,tmpLocDesc,tmpWardDesc,DocDesc,"---",MainCode,MainDesc,MainResult,"---","---","---","---",Age)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	..e  d
	...f Index=1:1:$listlength(OperInfo) d
	....s Operation=$list(OperInfo,Index)
	....s OperCode=$p(Operation,$c(2),1)
	....s OperDesc=$p(Operation,$c(2),2)
	....s OperDate=$p(Operation,$c(2),3)
	....s OperDoc=$p($p(Operation,$c(2),4),"/",3)
	....s Data=$lb(RegNo,MrNo,PatName,Sex,BirthDay,AdmDate,DischDate,Days,tmpLocDesc,tmpWardDesc,DocDesc,"---",MainCode,MainDesc,MainResult,OperCode,OperDesc,OperDate,OperDoc,Age)
	....s ^CacheTemp(repid,ind)=Data
	....s ind=ind+1
	k ^CacheTemp("QryFrontPage",$zn,$j)
	
	Quit $$$OK
}

ClassMethod QryFrontPageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFrontPageExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:liulan
/// CreateDate:2013-04-26
/// Description:打印、导出已编目病案
/// Input:Arguments AdmLoc+"^"+AdmWard+"^"+AdmDoc+"^"+DateFrom+"^"+DateTo; 科室^病区^医生^开始日期^结束日期
/// d ##Class(web.DHCWMRCircul.FrontPageQry).QryFrontPageToPrint("","^^^62207^62908^")
ClassMethod QryFrontPageToPrint(itmJS As %String = "", Arguments As %String = "") As %String
{
	n (itmJS,Arguments)
	s Count=0
	
	s Loc=$p($g(Arguments),"^",1) 
	s Ward=$p($g(Arguments),"^",2)
	s Doc=$p($g(Arguments),"^",3)
	s DataFrom=$p($g(Arguments),"^",4)
	s DataTo=$p($g(Arguments),"^",5)
	
	s ds=##Class(%Library.ResultSet).%New("web.DHCWMRCircul.FrontPageQry:QryFrontPage")
	;s ^CacheTemp("DDDDD")=Loc_"||"_Ward_"||"_Doc_"||"_DataFrom_"||"_DataTo
	d ds.Execute(Loc,Ward,Doc,DataFrom,DataTo)
	b ;111
	s StartRow=4
	while(ds.Next())
	{
		b ;2
		s RegNo=ds.Data("RegNo")  //住院号
		s MrNo=ds.Data("MrNo")    //病案号
		s PatName=ds.Data("PatName") //病人姓名
		s Sex=ds.Data("Sex")       //性别
		s BirthDay=ds.Data("BirthDay")  //出生日期
		s AdmDate=ds.Data("AdmDate")    //入院日期
		s DischDate=ds.Data("DischDate") //出院日期
		s MainDesc=ds.Data("MainDesc")    //主要诊断
	    s MainResult=ds.Data("MainResult")  //出院情况
		s OperDesc=ds.Data("OperDesc")    //手术名称
		s OperDate=ds.Data("OperDate")        //手术日期
		s OperDoc=ds.Data("OperDoc")      //术者
		s LocDesc=ds.Data("LocDesc")      //科室
		s WardDesc=ds.Data("WardDesc")      //病区

		s ExcelRow=RegNo_$c(1)_MrNo_$c(1)_PatName_$c(1)_Sex_$c(1)_BirthDay_$c(1)_AdmDate_$c(1)_DischDate_$c(1)_MainDesc_$c(1)_MainResult_$c(1)_OperDesc_$c(1)_OperDate_$c(1)_OperDoc_$c(1)_LocDesc_$c(1)_WardDesc
		b ;111
		s retVal=itmJS_"(xlSheet,'"_$ZCVT(ExcelRow,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retVal)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
		
		
	}
	d ds.Close()
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	//s valCells="日期："_$zd($zdh(DataFrom,4),3)_" 至 "_$zd($zdh(DataTo,4),3)_"    合计:"_Count_"份"
	s valCells="日期："_$zd($zdh(DataFrom,4),3)_" 至 "_$zd($zdh(DataTo,4),3)_"    合计:"_Count_"份"
	s retval=itmJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

/// ****************************************************************
/// 功能说明   : 已编目查询
/// 入参       : 
/// AdmLoc     : 就诊科室
/// AdmWard    : 就诊病区
/// AdmDoc     : 就诊医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRCircul.FrontPageQry","QryFrontPage","","","","62207","62938")
/// ****************************************************************
Query QryFrontPage(AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "RegNo:%String,MrNo:%String,PatName:%String,Sex:%String,BirthDay:%String,AdmDate:%String,DischDate:%String,Days:%String,LocDesc:%String,WardDesc:%String,DocDesc:%String,Count:%String,MainCode:%String,MainDesc:%String,MainResult:%String,OperCode:%String,OperDesc:%String,OperDate:%String,OperDoc:%String,Age:%String")
{
}

ClassMethod QryOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperationExecute(ByRef qHandle As %Binary, OperLoc As %String, OperDoc As %String, DateFrom As %String, DateTo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//s ^ZF(11)=$lb(OperLoc,OperDoc,DateFrom,DateTo)
	q:(DateFrom="")||(DateTo="") $$$OK
	
	k ^CacheTemp("QryOperation",$zn,$j)
	f tmpDate=DateFrom:1:DateTo d
	.s Paadm=0
	.f  s Paadm=$o(^PAADMi("DischDate",tmpDate,Paadm)) q:Paadm=""  d
	..s tmpPaadm=$g(^PAADM(+Paadm))
	..q:tmpPaadm=""
	..q:$p(tmpPaadm,"^",75)'=""                //婴儿不算
	..s VisitStatus=$p(tmpPaadm,"^",20)        //就诊状态
	..q:VisitStatus'="D"                       //过滤掉召回的病人
	..q:$p(tmpPaadm,"^",2)'="I"                //过滤掉门诊走住院的病人
	..s VolRowid=0
	..f  s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",+Paadm,VolRowid)) q:VolRowid=""  d
	...q:$p($g(^DHCWMRVOL(VolRowid)),"^",7)'="Y"
	...q:'$d(^DHCWMRFP(0,"VolumeDr",VolRowid))    //未编目退出
	...s OperInfo=""
	...s Operation="",Index=1  //手术
	...f  s Operation=..getFrontPageICD(Paadm,"O/1",Index) q:(Operation="")  d
	....s OperInfo=OperInfo_$lb(Operation)
	....s Index=Index+1
	...s Operation="",Index=1  //操作
	...f  s Operation=..getFrontPageICD(Paadm,"O/2",Index) q:(Operation="")  d
	....s OperInfo=OperInfo_$lb(Operation)
	....s Index=Index+1
	...q:OperInfo=""     //没有手术 退出
	...f Index=1:1:$listlength(OperInfo) d
	....s Operation=$list(OperInfo,Index)
	....s OCode=$p(Operation,$c(2),1)
	....s ODesc=$p(Operation,$c(2),2)
	....s ODate=$p(Operation,$c(2),3)
	....s ODoc=$p($p(Operation,$c(2),4),"/",1)           //术者  ID/Code/Name
	....q:ODoc=""
	....q:(OperDoc'="")&&(OperDoc'=ODoc)
	....s ^CacheTemp("QryOperation",$zn,$j,ODoc)=(+$g(^CacheTemp("QryOperation",$zn,$j,ODoc)))+1
	....s ^CacheTemp("QryOperation",$zn,$j,ODoc,Paadm)=Operation
	
	s tmpDoc=0
	f  s tmpDoc=$o(^CacheTemp("QryOperation",$zn,$j,tmpDoc)) q:tmpDoc=""  d
	.s OperDocCode=$p($g(^SSU("SSUSR",+tmpDoc)),"^",1)
	.s OperDocDesc=$p($g(^SSU("SSUSR",+tmpDoc)),"^",2)
	.s Count=+$g(^CacheTemp("QryOperation",$zn,$j,tmpDoc))
	.s Data=$lb("---","---","---","---","---","---","---","---","---","---","---","---","---","---",OperDocCode,OperDocDesc,Count)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.s Paadm=0
	.f  s Paadm=$o(^CacheTemp("QryOperation",$zn,$j,tmpDoc,Paadm)) q:Paadm=""  d
	..s tmpPaadm=$g(^PAADM(+Paadm))
	..q:tmpPaadm=""
	..s Operation=$g(^CacheTemp("QryOperation",$zn,$j,+tmpDoc,+Paadm))
	..s OperCode=$p(Operation,$c(2),1)
	..s OperDesc=$p(Operation,$c(2),2)
	..s OperDate=$p(Operation,$c(2),3)
	..s tmpLocID=$p(tmpPaadm,"^",4)
	..s tmpWardID=$p(tmpPaadm,"^",70)
	..s tmpDocID=$p(tmpPaadm,"^",9)
	..s Papmi=$p(tmpPaadm,"^",1)
	..s RegNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	..s MrNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	..s:($p($g(^DHCMedHosptial(0)),"/",4)="ChengDu_HX") MrNo=$p(tmpPaadm,"^",81)
	..s PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	..s Sex=$p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	..s BirthDay=$p($g(^PAPER(+Papmi,"ALL")),"^",6)
	..s:BirthDay'="" BirthDay=$zd(BirthDay,3)
	..s AdmDate=$zd($p(tmpPaadm,"^",6),3)
	..s DischDate=$zd(tmpDate,3)
	..s Days=(tmpDate-(+$p(tmpPaadm,"^",6)))  //住院天数
	..s tmpLocID=$p(tmpPaadm,"^",4)
	..s tmpWardID=$p(tmpPaadm,"^",70)
	..s tmpLocDesc=$p($g(^CTLOC(+tmpLocID)),"^",2)
	..s:tmpLocDesc["-" tmpLocDesc=$p(tmpLocDesc,"-",2)
	..s tmpWardDesc=$p($g(^PAWARD(+tmpWardID)),"^",2)  //PAC_Ward
	..s WLocID=$p($g(^PAWARD(+tmpWardID)),"^",5)
	..s:WLocID'="" tmpWardDesc=$p($g(^CTLOC(+WLocID)),"^",2)
	..s:tmpWardDesc["-" tmpWardDesc=$p(tmpWardDesc,"-",2)
	..s DocDesc=$p($g(^CTPCP(+tmpDocID)),"^",2)    //CT_CareProv
	..s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",+tmpDocID,0))  //SS_User
	..s:SSUserID'="" DocDesc=$p($g(^SSU("SSUSR",+SSUserID)),"^",2)
	..s Data=$lb(RegNo,MrNo,PatName,Sex,BirthDay,AdmDate,DischDate,Days,tmpLocDesc,tmpWardDesc,DocDesc,OperCode,OperDesc,OperDate,"---","---","---")
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	k ^CacheTemp("QryOperation",$zn,$j)
	
	Quit $$$OK
}

ClassMethod QryOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperationExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ****************************************************************
/// 功能说明   : 手术编码查询
/// 入参       : 
/// OperLoc    : 手术科室
/// OperDoc    : 手术医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRCircul.FrontPageQry","QryOperation",Loc,Doc,DateFrom,DateTo)
/// ****************************************************************
Query QryOperation(OperLoc As %String, OperDoc As %String, DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "RegNo:%String,MrNo:%String,PatName:%String,Sex:%String,BirthDay:%String,AdmDate:%String,DischDate:%String,Days:%String,LocDesc:%String,WardDesc:%String,DocDesc:%String,OperCode:%String,OperDesc:%String,OperDate:%String,OperDocCode:%String,OperDocDesc:%String,Count:%String")
{
}

/// ***************************************************************************
/// 说明                  :取病案编目数据(诊断和手术)
/// 入参                  ：
/// 1-Paadm               : 就诊号
/// 2-GetType             : 类型
///        D/1            : 主要诊断
///        D/2            : 次要诊断
///        D/3            : 医院感染诊断
///        D/4            : 病理诊断
///        D/5            : 损伤、中毒的外部因素
///        D/6            : 门急诊诊断
///        D/7            : 入院诊断
///        O/1            : 手术
///        O/2            : 操作
/// 3-Index               : 第几条记录
/// 出参                  ：ret
///                       : 诊断返回值  ICD10$c(2)诊断描述$c(2)出院情况
///                       : 手术操作返回值  ICD10$c(2)手术名称$c(2)手术操作日期$c(2)术者$c(2)一助$c(2)二助$c(2)麻醉方式$c(2)愈合情况$c(2)麻醉师
/// 调试                  : w ##Class(web.DHCWMRCodingInterface).getFrontPageICD(Paadm,GetType,Index)
/// ***************************************************************************
ClassMethod getFrontPageICD(Paadm, GetType, Index)
{
	n (Paadm,GetType,Index)
	s ret=""
	q:Paadm="" ret
	q:GetType="" ret
	s ICDType=$p(GetType,"/",1)
	s OperType=$p(GetType,"/",2)
	s Index=+$g(Index)
	s:Index<1 Index=1
	q:(ICDType'="D")&&(ICDType'="O") ret
	q:(ICDType="D")&&(((+OperType)<1)||((+OperType)>7)) ret
	q:(ICDType="O")&&((OperType'="1")&&(OperType'="2")) ret
	
	;取卷
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	q:'$d(^DHCWMRVOL(0,"VolAdm",Paadm)) ret
	s tmpRowid="",VolRowid=""
	f  s tmpRowid=$o(^DHCWMRVOL(0,"VolAdm",Paadm,tmpRowid),-1) q:(((+tmpRowid)=0)||(VolRowid'=""))  d
	.q:$p($g(^DHCWMRVOL(+tmpRowid)),"^",7)'="Y"
	.s VolRowid=tmpRowid
	q:VolRowid="" ret
	
	;取首页
	;^DHCWMRFP(0,"VolumeDr",{VolumeDr},{RowId})
	q:'$d(^DHCWMRFP(0,"VolumeDr",VolRowid)) ret
	s FPRowid=$o(^DHCWMRFP(0,"VolumeDr",VolRowid,""),-1)
	q:FPRowid="" ret
	
	;取ICD列表
	;^DHCWMRFPICD(0,"FP",{FrontPageDr}
	q:'$d(^DHCWMRFPICD(0,"FP",FPRowid)) ret
	
	s FPICDRowid=0,index=1,sOut=""
	f  s FPICDRowid=$o(^DHCWMRFPICD(0,"FP",FPRowid,FPICDRowid)) q:(FPICDRowid="")||(index>Index)  d
	.s sICD=$g(^DHCWMRFPICD(FPICDRowid))
	.s sICDTypeDr=$p(sICD,"^",10)       ;ICD类型
	.s:sICDTypeDr'="" sICDTypeDic=##class(web.DHCWMRDictionaryCtl).GetDataById(sICDTypeDr)
	.s sICDType=$p(sICDTypeDic,"^",3)
	.q:sICDType'=ICDType
	.s OperTypeDr=$p(sICD,"^",14)     ;诊断/手术/操作类型
	.s sOperDic=""
	.s:OperTypeDr'="" sOperDic=##class(web.DHCWMRDictionaryCtl).GetDataById(OperTypeDr)
	.s sOperTypeCode=$p(sOperDic,"^",3)
	.q:sOperTypeCode'=OperType
	.i index=Index d
	..s:ICDType="D" sOut=$$BuildDisString(FPICDRowid)
	..s:ICDType="O" sOut=$$BuildOperString(FPICDRowid,OperType)
	.s index=index+1
	
	q sOut
	
BuildDisString(FPICDRowid)
    ;ICD10 $c(2) 诊断描述 $c(2) 出院情况
    n (FPICDRowid)
    s sOut=""
    s sICD=$g(^DHCWMRFPICD(FPICDRowid))
    s ICDDr=$p(sICD,"^",2)
    s ResultDr=$p(sICD,"^",3)
    s sICDDictionary=##class(web.DHCMedBaseICD).GetMyICDByRowId(ICDDr)
    q:sICDDictionary="" sOut
    s sResultDic=##class(web.DHCWMRDictionaryCtl).GetDataById(ResultDr)
    s ICD10=$p(sICDDictionary,"^",2)
    s ICDDesc=$p(sICDDictionary,"^",4)
    s ResultCode=$p(sResultDic,"^",3)
    s sOut=ICD10_$c(2)_ICDDesc_$c(2)_ResultCode
    q sOut
BuildOperString(FPICDRowid,OperType)
    ;ICD10$c(2)手术名称$c(2)手术操作日期$c(2)术者$c(2)一助$c(2)二助$c(2)麻醉方式$c(2)愈合情况$c(2)麻醉师
    n (FPICDRowid,OperType)
    s sOut=""
    s sICD=$g(^DHCWMRFPICD(FPICDRowid))
    s ICDDr=$p(sICD,"^",2)
    s OperDate=$zd(+$p(sICD,"^",13),3)
    s OperatorDr=$p(sICD,"^",4)
    s Ass1Dr=$p(sICD,"^",5)
    s Ass2Dr=$p(sICD,"^",6)
    s NarcTypeDr=$p(sICD,"^",7)
    s CloseUpDr=$p(sICD,"^",9)
    s NarcDocDr=$p(sICD,"^",8)
    s sICDDictionary=##class(web.DHCMedBaseICD).GetMyOperByRowId(ICDDr)
    q:sICDDictionary="" sOut
    
    s Operator=##class(web.DHCMedBaseCtl).GetUsrStr(OperatorDr)    ;2取代码 3取Name
    s Ass1=##class(web.DHCMedBaseCtl).GetUsrStr(Ass1Dr)            ;2取代码 3取Name
    s Ass2=##class(web.DHCMedBaseCtl).GetUsrStr(Ass2Dr)            ;2取代码 3取Name
    s NarcDoc=##class(web.DHCMedBaseCtl).GetUsrStr(NarcDocDr)      ;2取代码 3取Name
    s NarcType=##class(web.DHCWMRDictionaryCtl).GetDataById(NarcTypeDr)    ;麻醉方式 3代码 4描述
    s CloseUp=##class(web.DHCWMRDictionaryCtl).GetDataById(CloseUpDr)      ;切口愈合 3代码 4描述
    
    s ICD10=$p(sICDDictionary,"^",2)
    s ICDDesc=$p(sICDDictionary,"^",4)
    s:OperType="2" CloseUp=""
    s sOut=ICD10_$c(2)_ICDDesc_$c(2)_OperDate_$c(2)_Operator_$c(2)_Ass1_$c(2)_Ass2_$c(2)_NarcType_$c(2)_CloseUp_$c(2)_NarcDoc
    
    q sOut
}

}
