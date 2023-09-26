Import SQLUser

/// 病案基础查询
Class web.DHCWMRCircul.PatPaadmQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 170;

ClassMethod QryRegInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRegInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRegInfoExecute(ByRef qHandle As %Binary, AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String, AdmStatus As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(DateFrom="")||(DateTo="") $$$OK
	
	k ^CacheTemp($zn,$j,"QryRegInfo")
	f tmpDate=DateFrom:1:DateTo d
	.s tmpTime=0
	.f  s tmpTime=$o(^PAADMi("TypeDate","I",tmpDate,tmpTime)) q:tmpTime=""  d
	..s Paadm=0
	..f  s Paadm=$o(^PAADMi("TypeDate","I",tmpDate,tmpTime,Paadm)) q:Paadm=""  d
	...s tmpPaadm=$g(^PAADM(+Paadm))
	...q:tmpPaadm=""
	...q:$p(tmpPaadm,"^",75)'=""                //婴儿不算
	...s VisitStatus=$p(tmpPaadm,"^",20)        //就诊状态
	...q:(AdmStatus'="")&&(("|"_AdmStatus_"|")'[("|"_VisitStatus_"|"))
	...s:VisitStatus="A" VisitStatus="在院"
	...s:VisitStatus="D" VisitStatus="出院"
	...s:VisitStatus="C" VisitStatus="退院"
	...s:VisitStatus="P" VisitStatus="预约"
	...s tmpLoc=$p(tmpPaadm,"^",4)
	...q:(AdmLoc'="")&&(tmpLoc'=AdmLoc)         //出院科室
	...s tmpWard=$p(tmpPaadm,"^",70)
	...q:(AdmWard'="")&&(tmpWard'=AdmWard)      //出院病区
	...s tmpDoc=$p(tmpPaadm,"^",9)
	...q:(AdmDoc'="")&&(tmpDoc'=AdmDoc)         //主管医生
	...
	...s Papmi=$p(tmpPaadm,"^",1)
	...s RegNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	...s MrNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	...s:($p($g(^DHCMedHosptial(0)),"/",4)="ChengDu_HX") MrNo=$p(tmpPaadm,"^",81)
	...s PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	...s Sex=$p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	...s BirthDay=$p($g(^PAPER(+Papmi,"ALL")),"^",6)
	...s:BirthDay'="" BirthDay=$zd(BirthDay,3)
	...s AdmDate=$zd($p(tmpPaadm,"^",6),3)
	...s DischDate=$p(tmpPaadm,"^",17)
	...s:DischDate'="" DischDate=$zd(DischDate,3)
	...s LocDesc=$p($g(^CTLOC(+tmpLoc)),"^",2)
	...s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	...s WardDesc=$p($g(^PAWARD(+tmpWard)),"^",2)  //PAC_Ward
	...s WLocID=$p($g(^PAWARD(+tmpWard)),"^",5)
	...s:WLocID'="" WardDesc=$p($g(^CTLOC(+WLocID)),"^",2)
	...s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	...s DocDesc=$p($g(^CTPCP(+tmpDoc)),"^",2)    //CT_CareProv
	...s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",+tmpDoc,0))  //SS_User
	...s:SSUserID'="" DocDesc=$p($g(^SSU("SSUSR",+SSUserID)),"^",2)
	...s Age=$s(((BirthDay'="")&&(AdmDate'="")):((+AdmDate)-(+BirthDay)),1:"")
	...s Data=$lb(RegNo,MrNo,PatName,Sex,BirthDay,Age,AdmDate,DischDate,LocDesc,WardDesc,DocDesc,Paadm,Papmi,VisitStatus)
	...s:MrNo="" MrNo="00"
	...s ^CacheTemp($zn,$j,"QryRegInfo",MrNo,Paadm)=Data
	
	// 按病案号排序
	s tmpMrNo=""
	f  s tmpMrNo=$o(^CacheTemp($zn,$j,"QryRegInfo",tmpMrNo)) q:tmpMrNo=""  d
	.s tmpPaadm=0
	.f  s tmpPaadm=$o(^CacheTemp($zn,$j,"QryRegInfo",tmpMrNo,tmpPaadm)) q:tmpPaadm=""  d
	..s Data=$g(^CacheTemp($zn,$j,"QryRegInfo",tmpMrNo,tmpPaadm))
	..k ^CacheTemp($zn,$j,"QryRegInfo",tmpMrNo,tmpPaadm)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	k ^CacheTemp($zn,$j,"QryRegInfo")
	
	Quit $$$OK
}

ClassMethod QryRegInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRegInfoExecute ]
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
/// 功能说明   : 入院病人信息查询
/// 入参       : 
/// AdmLoc     : 就诊科室
/// AdmWard    : 就诊病区
/// AdmDoc     : 就诊医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// AdmStatus  : 就诊状态
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRCircul.PatPaadmQry","QryRegInfo",Loc,Ward,Doc,DateFrom,DateTo,AdmStatus)
/// ****************************************************************
Query QryRegInfo(AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String, AdmStatus As %String) As %Query(ROWSPEC = "RegNo:%String,MrNo:%String,PatName:%String,Sex:%String,BirthDay:%String,Age:%String,AdmDate:%String,DischDate:%String,LocDesc:%String,WardDesc:%String,DocDesc:%String,Paadm:%String,Papmi:%String,VisitStatus:%String")
{
}

ClassMethod QryDischInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDischInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDischInfoExecute(ByRef qHandle As %Binary, AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(DateFrom="")||(DateTo="") $$$OK
	
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
	..
	..s Papmi=$p(tmpPaadm,"^",1)
	..s RegNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	..s MrNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	..s:($p($g(^DHCMedHosptial(0)),"/",4)="ChengDu_HX") MrNo=$p(tmpPaadm,"^",81)
	..s PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	..s Sex=$p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	..s BirthDay=$p($g(^PAPER(+Papmi,"ALL")),"^",6)
	..s:BirthDay'="" BirthDay=$zd(BirthDay,3)
	..s AdmDate=$zd($p(tmpPaadm,"^",6),3)
	..s DischDate=$p(tmpPaadm,"^",17)
	..s:DischDate'="" DischDate=$zd(DischDate,3)
	..s LocDesc=$p($g(^CTLOC(+tmpLoc)),"^",2)
	..s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	..s WardDesc=$p($g(^PAWARD(+tmpWard)),"^",2)  //PAC_Ward
	..s WLocID=$p($g(^PAWARD(+tmpWard)),"^",5)
	..s:WLocID'="" WardDesc=$p($g(^CTLOC(+WLocID)),"^",2)
	..s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	..s DocDesc=$p($g(^CTPCP(+tmpDoc)),"^",2)    //CT_CareProv
	..s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",+tmpDoc,0))  //SS_User
	..s:SSUserID'="" DocDesc=$p($g(^SSU("SSUSR",+SSUserID)),"^",2)
	..s Age=$s(((BirthDay'="")&&(AdmDate'="")):((+AdmDate)-(+BirthDay)),1:"")
	..s AdmTimes=0
	..s VolID=0
	..f  s VolID=$o(^DHCWMRVOL(0,"VolAdm",Paadm,VolID)) q:(VolID="")||(AdmTimes>0)  d
	...q:$p($g(^DHCWMRVOL(VolID)),"^",7)'="Y"
	...s AdmTimes=+$p($g(^DHCWMRVOL(VolID)),"^",9)
	..
	..s Data=$lb(RegNo,MrNo,PatName,Sex,BirthDay,Age,AdmDate,DischDate,LocDesc,WardDesc,DocDesc,Paadm,Papmi,AdmTimes)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryDischInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDischInfoExecute ]
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
/// 功能说明   : 出院病人信息查询
/// 入参       : 
/// AdmLoc     : 就诊科室
/// AdmWard    : 就诊病区
/// AdmDoc     : 就诊医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRCircul.PatPaadmQry","QryDischInfo",Loc,Ward,Doc,DateFrom,DateTo)
/// ****************************************************************
Query QryDischInfo(AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "RegNo:%String,MrNo:%String,PatName:%String,Sex:%String,BirthDay:%String,Age:%String,AdmDate:%String,DischDate:%String,LocDesc:%String,WardDesc:%String,DocDesc:%String,Paadm:%String,Papmi:%String,AdmTimes:%String")
{
}

ClassMethod StatDischPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatDischPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod StatDischPatientExecute(ByRef qHandle As %Binary, AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(DateFrom="")||(DateTo="") $$$OK
	
	k ^CacheTemp("StatDischPat",$zn,$j)
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
	..s ^CacheTemp("StatDischPat",$zn,$j,tmpLoc)=(+$g(^CacheTemp("StatDischPat",$zn,$j,tmpLoc)))+1
	..q:tmpDoc=""
	..s ^CacheTemp("StatDischPat",$zn,$j,tmpLoc,tmpDoc)=(+$g(^CacheTemp("StatDischPat",$zn,$j,tmpLoc,tmpDoc)))+1
	
	s tmpLoc=0
	f  s tmpLoc=$o(^CacheTemp("StatDischPat",$zn,$j,tmpLoc)) q:tmpLoc=""  d
	.s tmpLocDesc=$p($g(^CTLOC(+$p(tmpLoc,"||",1))),"^",2)
	.s:tmpLocDesc["-" tmpLocDesc=$p(tmpLocDesc,"-",2)
	.s tmpWardID=$p($g(^PAWARD(+$p(tmpLoc,"||",2))),"^",5)    //CT_Loc 病区
	.s tmpWardDesc=$p($g(^CTLOC(+tmpWardID)),"^",2)
	.s:tmpWardDesc["-" tmpWardDesc=$p(tmpWardDesc,"-",2)
	.s tmpCount=$g(^CacheTemp("StatDischPat",$zn,$j,tmpLoc))
	.s Data=$lb(tmpLocDesc,tmpWardDesc,"---",tmpCount,$p(tmpLoc,"||",1),$p(tmpLoc,"||",2),AdmDoc,DateFrom,DateTo)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.s tmpDoc=0
	.f  s tmpDoc=$o(^CacheTemp("StatDischPat",$zn,$j,tmpLoc,tmpDoc)) q:tmpDoc=""  d
	..s tmpDocDesc=$p($g(^CTPCP(+tmpDoc)),"^",2)    //CT_CareProv
	..s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",+tmpDoc,0))  //SS_User
	..s:SSUserID'="" tmpDocDesc=$p($g(^SSU("SSUSR",+SSUserID)),"^",2)
	..s tmpCount=$g(^CacheTemp("StatDischPat",$zn,$j,tmpLoc,tmpDoc))
	..s Data=$lb("---","---",tmpDocDesc,tmpCount,$p(tmpLoc,"||",1),$p(tmpLoc,"||",2),tmpDoc,DateFrom,DateTo)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	k ^CacheTemp("StatDischPat",$zn,$j)
	
	Quit $$$OK
}

ClassMethod StatDischPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatDischPatientExecute ]
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
/// 功能说明   : 出院病人信息查询
/// 入参       : 
/// AdmLoc     : 就诊科室
/// AdmWard    : 就诊病区
/// AdmDoc     : 就诊医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRCircul.PatPaadmQry","StatDischPatient",Loc,Ward,Doc,DateFrom,DateTo)
/// ****************************************************************
Query StatDischPatient(AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "LocDesc:%String,WardDesc:%String,DocDesc:%String,Count:%String,AdmLoc:%String,AdmWard:%String,AdmDoc:%String,DateFrom:%String,DateTo:%String")
{
}

/// w ##Class(web.DHCWMRCircul.PatPaadmQry).QryRegInfoToPrint(itmjs,strArguments)
ClassMethod QryRegInfoToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	s AdmLoc=$p(strArguments,"^",1)
	s AdmWard=$p(strArguments,"^",2)
	s AdmDoc=$p(strArguments,"^",3)
	s DateFrom=$p(strArguments,"^",4)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s DateTo=$p(strArguments,"^",5)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s AdmStatus=$p(strArguments,"^",6)
	
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRCircul.PatPaadmQry:QryRegInfo")
	d ds.Execute(AdmLoc,AdmWard,AdmDoc,DateFrom,DateTo,AdmStatus)
	s StartRow=4
	while(ds.Next())
	{
		s RegNo=ds.Data("RegNo")
		s MrNo=ds.Data("MrNo")
		s PatName=ds.Data("PatName")
		s Sex=ds.Data("Sex")
		s BirthDay=ds.Data("BirthDay")
		s AdmDate=ds.Data("AdmDate")
		s DischDate=ds.Data("DischDate")
		s LocDesc=ds.Data("LocDesc")
		s WardDesc=ds.Data("WardDesc")
		s DocDesc=ds.Data("DocDesc")
		s Paadm=ds.Data("Paadm")
		s Papmi=ds.Data("Papmi")
		s VisitStatus=ds.Data("VisitStatus")
		
		//登记号,病案号,病人姓名,性别,出生日期,入院日期,科室,状态
		s valCells=RegNo_$c(1)_MrNo_$c(1)_PatName_$c(1)_Sex_$c(1)_BirthDay_$c(1)_AdmDate_$c(1)_LocDesc_$c(1)_VisitStatus
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	s Status=""
	s:AdmStatus["A" Status=Status_"[正常]"
	s:AdmStatus["C" Status=Status_"[退院]"
	s valCells="统计日期："_$zd(DateFrom,3)_" 至 "_$zd(DateTo,3)_"       "_Status
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

/// w ##Class(web.DHCWMRCircul.PatPaadmQry).QryDischInfoToPrint(itmjs,strArguments)
ClassMethod QryDischInfoToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	s AdmLoc=$p(strArguments,"^",1)
	s AdmWard=$p(strArguments,"^",2)
	s AdmDoc=$p(strArguments,"^",3)
	s DateFrom=$p(strArguments,"^",4)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s DateTo=$p(strArguments,"^",5)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRCircul.PatPaadmQry:QryDischInfo")
	d ds.Execute(AdmLoc,AdmWard,AdmDoc,DateFrom,DateTo)
	s StartRow=4
	while(ds.Next())
	{
		s RegNo=ds.Data("RegNo")
		s MrNo=ds.Data("MrNo")
		s PatName=ds.Data("PatName")
		s Sex=ds.Data("Sex")
		s BirthDay=ds.Data("BirthDay")
		s AdmDate=ds.Data("AdmDate")
		s DischDate=ds.Data("DischDate")
		s LocDesc=ds.Data("LocDesc")
		s WardDesc=ds.Data("WardDesc")
		s DocDesc=ds.Data("DocDesc")
		s Paadm=ds.Data("Paadm")
		s Papmi=ds.Data("Papmi")
		s AdmTimes=ds.Data("AdmTimes")
		
		//登记号,病案号,住院次数,姓名,性别,出生日期,入院日期,出院日期,科室
		s valCells=RegNo_$c(1)_MrNo_$c(1)_AdmTimes_$c(1)_PatName_$c(1)_Sex_$c(1)_BirthDay_$c(1)_AdmDate_$c(1)_DischDate_$c(1)_LocDesc
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	s valCells="统计日期："_$zd(DateFrom,3)_" 至 "_$zd(DateTo,3)
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

/// w ##Class(web.DHCWMRCircul.PatPaadmQry).StatDischPatientToPrint(itmjs,strArguments)
ClassMethod StatDischPatientToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	s AdmLoc=$p(strArguments,"^",1)
	s AdmWard=$p(strArguments,"^",2)
	s AdmDoc=$p(strArguments,"^",3)
	s DateFrom=$p(strArguments,"^",4)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s DateTo=$p(strArguments,"^",5)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRCircul.PatPaadmQry:StatDischPatient")
	d ds.Execute(AdmLoc,AdmWard,AdmDoc,DateFrom,DateTo)
	s StartRow=4
	while(ds.Next())
	{
		s LocDesc=ds.Data("LocDesc")
		s WardDesc=ds.Data("WardDesc")
		s DocDesc=ds.Data("DocDesc")
		s Count=ds.Data("Count")
		
		//科室,病区,主管医生,数量
		s valCells=LocDesc_$c(1)_WardDesc_$c(1)_DocDesc_$c(1)_Count
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	s valCells="统计日期："_$zd(DateFrom,3)_" 至 "_$zd(DateTo,3)
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

}
