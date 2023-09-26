Class web.DHCQtVolItem Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getDocloc(funname As %String) As %String
{
  //w ##class(web.DHCQtVolItem).getDocloc()
  s rowid=""
  f  s rowid=$o(^PAC("ADMLOC",0,"AdmType","I",rowid))  q:rowid=""  d
  .q:($d(^CTLOC(rowid))=0)
  .s a=$P(^CTLOC(rowid),"^")
  .s c=$P(^CTLOC(rowid),"^",2)
  .q:c=""
  .s rtnval=funname_"('"_$ZCVT($g(rowid),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
  .&javascript<#(rtnval)#>
  .//w !,b
  q 0
}

ClassMethod getDocloc1(funname As %String) As %String
{
	//w ##class(web.DHCQtVolItem).getDocloc1()
 s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 .s a=$P(^CTLOC(rw),"^")
 .q:a["病区"
 .q:a["工作量用"
 .q:a["停用"
 .q:a["室"
 .q:a["库"
 .q:a["门诊"
 .q:a["办"
 .q:a["处"
 .q:a["队"
 .q:a["药房"
 .q:a["挂号"
 .//q:a[""
 .s c=$P(^CTLOC(rw),"^",2)
 .q:c=""
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0
}

ClassMethod Wardgetloc(funname As %String) As %String
{
 s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 .s a=$P(^CTLOC(rw),"^",2)
 .q:a'["护理单元"
 .q:a["工作量用"
 .q:a["停用"
 .s c=$P(^CTLOC(rw),"^",2)
 .q:c=""
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0
}

ClassMethod Save(parr As %String, id As %String) As %String
{
	//s ^TMP("aaa")=$lb(code, desc , flag, WardId , VisibleFlag )
  	s ^TMP("parr")=parr
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	if id=""
	{
	s a=##class(User.DHCQtVolItem).%New()
	}else
	{
	 s a=##class(User.DHCQtVolItem).%OpenId(id)
	}
	if $G(tmp("NurStopFlag"))=""  s tmp("NurStopFlag")="N"
	if $D(tmp("NurMedicalcode")) s a.Code=tmp("NurMedicalcode")
	if $D(tmp("NurMedicalDesc")) s a.ItmDesc=tmp("NurMedicalDesc")
	if $D(tmp("NurStopFlag")) s a.StopFlag=tmp("NurStopFlag")
	if $D(tmp("NurQualityUnit")) s a.QualityUnit=tmp("NurQualityUnit")
	if $D(tmp("NurVolUnit")) s a.VolUnit=tmp("NurVolUnit")
	if $D(tmp("NurRowid")) s a.ARCItmRowid=tmp("NurRowid")
	if $D(tmp("NurConvertScale")) s a.ConvertScale=tmp("NurConvertScale")
	if $D(tmp("NurUnit")) s a.UnitDesc=tmp("NurUnit")
	//if $D(tmp("WardId")) s a.WardId=..getlocward(tmp("WardId"))
	//s a.AllVisible="N"
	d a.%Save()
	q 0
}

ClassMethod QVDelete(id As %String) As %String
{
   s a=##class(User.DHCQtVolItem).%DeleteId(id)
	q 0
}

ClassMethod QVItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QVItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QVItemExecute(ByRef qHandle As %Binary, Code As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
	s id=""
	s ret=""
	f {
	 s id=$O(^User.DHCQtVolItemD(id))
	/// s id=1
	 q:id=""
	 s ret=..getVal(id)
	 //w !,id
	 d OutRowtyp
  	}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QVItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QVItemExecute ]
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

Query QVItem(Code As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod getVal(id) As %String
{
	s ret=""
	b
	if id'=""
	{
	s a=##class(User.DHCQtVolItem).%OpenId(id)
	
	s tmp("NurMedicalcode")=a.Code
	s tmp("NurMedicalDesc")=a.ItmDesc
	s tmp("StopFlag")=a.StopFlag
	s tmp("NurQualityUnit")=a.QualityUnit
	s tmp("NurVolUnit")=a.VolUnit
	s tmp("NurConvertScale")=a.ConvertScale
	s tmp("NurRowid")=a.ARCItmRowid
	s tmp("NurUnit")=a.UnitDesc
	s tmp("Nurrw")=id
	
	s k=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

ClassMethod Patinfo(Adm As %String) As %String
{
		   s CurrentBedDR=""
		   s VisitStatus=""
		   s VisitStatus=$P(^PAADM(Adm),"^",20)
		   i VisitStatus="D" d  //出院病人取转床最后一条记录的床号
           .s chl="" f  s chl=$o(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
	       ..s CurrentBedDRTMP=$p(^PAADM(Adm,"TRANS",chl),"^",8)
	       ..i CurrentBedDRTMP'="" s CurrentBedDR=CurrentBedDRTMP
           i VisitStatus="A" s CurrentBedDR=$P(^PAADM(Adm),"^",73)   //在院病人取PA_adm表里的记录,因为存在在等待区未入床的情况所以不能取转床最后一条记录
	       q:CurrentBedDR="" ""
	       s Papmidr=$P(^PAADM(Adm),"^",1)
	       s ctlocdr=$P(^PAADM(Adm),"^",4)
	       s ctlocdesc=$P(^CTLOC(ctlocdr),"^",2)
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       s Sexdr=$P(^PAPER(Papmidr,"ALL"),"^",7)
	       s sex=$P(^CT("SEX",Sexdr),"^",2) 
	       s bedchl=$P(CurrentBedDR,"||",2)
	       s Ward=$P(CurrentBedDR,"||",1)
	       s wardloc=$P(^PAWARD(Ward),"^",5) //s name="F",cttypdes="NURSE"

	       s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       s pstop=$P(^PAWARD(Ward,"BED",bedchl),"^",15)
	       s psleft=$P(^PAWARD(Ward,"BED",bedchl),"^",16)
	       s adm(Bed)=Adm_"#"_Name_"#"_Bed_"#"_$G(ctlocdesc)_"#"_$G(wardloc)_"#"_pstop_"#"_psleft_"#"_RegNo_"#"_sex
         q adm(Bed)
}

ClassMethod getTemp(funname As %String) As %String
{
 
 s temp(1)="40"
 s temp(2)="39"
 s temp(3)="38"
 s temp(4)="37"
 s temp(5)="36"
 s temp(6)="35"
 s rw="" f  s rw=$O(temp(rw)) q:rw=""  d
 .s a=temp(rw)
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(a),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0
}

// 取住院患者体温单大便3日未解的函数

ClassMethod getPat3Datedejecta(MRADMRowId As %String, Date As %String) As %String
{
	//w ##class(web.DHCQtVolItem).getPat3Datedejecta("10831021","62731")
	s oneflag=0,twoflag=0,threeflag=0
	s OneDate="",TwoDate="",ThreeDate=""
	s OBSChildsub="" f  s OBSChildsub=$o(^MR(MRADMRowId,"OBS",0,"Date",Date,12,OBSChildsub)) q:OBSChildsub=""  d
	.i ((OneDate="")!(OneDate=0)) s OneDate=$P($G(^MR(MRADMRowId,"OBS",OBSChildsub)),"^",2)
	.//w !,$P($G(^MR(MRADMRowId,"OBS",OBSChildsub)),"^",2)_"@@"_OneDate
	
	s OBSChildsub="" f  s OBSChildsub=$o(^MR(MRADMRowId,"OBS",0,"Date",Date-1,12,OBSChildsub)) q:OBSChildsub=""  d
	.i ((TwoDate="")!(TwoDate=0)) s TwoDate=$P($G(^MR(MRADMRowId,"OBS",OBSChildsub)),"^",2)
	.//w !,$P($G(^MR(MRADMRowId,"OBS",OBSChildsub)),"^",2)_"@!"_TwoDate

    s OBSChildsub="" f  s OBSChildsub=$o(^MR(MRADMRowId,"OBS",0,"Date",Date-2,12,OBSChildsub)) q:OBSChildsub=""  d
	.i ((ThreeDate="")!(ThreeDate=0)) s ThreeDate=$P($G(^MR(MRADMRowId,"OBS",OBSChildsub)),"^",2)
	.//w !,$P($G(^MR(MRADMRowId,"OBS",OBSChildsub)),"^",2)_"!!"_ThreeDate
   
	i ((OneDate="")!(OneDate=0)) s oneflag=1
	i ((TwoDate="")!(TwoDate=0)) s twoflag=1
	i ((ThreeDate="")!(ThreeDate=0)) s threeflag=1
	
	//w !,oneflag_"&&"_twoflag_"&&"_threeflag
	
	s retunflag=oneflag&&twoflag&&threeflag
	q retunflag
}

// 取入床日或者入院日期

ClassMethod GetPatInPatDays(Adm As %String) As %String
{
	//w ##class(web.DHCQtVolItem).GetPatInPatDays("10924871")
	s ret="",DHCADMDate=""
    s NowDate=$p($h,",",1)
	s PAADMAdmDate=$p(^PAADM(Adm),"^",6)  //入院日期
	s QTRECRowID=$o(^DHCADMQTREC("adm",Adm,""))
	i $g(QTRECRowID)'="" d
	.s DHCADMDate=$p(^DHCADMQTREC("QTREC",QTRECRowID),"^",2)  //按医务处要求取入床时间
	i (DHCADMDate=0) s DHCADMDate=PAADMAdmDate  //如果没有入床时间那么取入院时间
    i DHCADMDate'="" s ret=DHCADMDate
    e  s ret=PAADMAdmDate
    q ret
}

Query NurIntegratedQueryData(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod NurIntegratedQueryDataExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCQtVolItem","NurIntegratedQueryData","2012-10-02^2012-11-30^undefined^脉搏<=60^^undefined^false^undefined")
    k ^tmpquery
	s aa=""
	s StartDate=$p(Parr,"^",1)
	s EndDate=$p(Parr,"^",2)
	s ctloc=$p(Parr,"^",3)
	s plussel=$p(Parr,"^",4)
	i plussel="undefined" s plussel=""
	s BloodPresssel=$p(Parr,"^",5)
	i BloodPresssel="undefined" s BloodPresssel=""
    s Breathsel=$p(Parr,"^",6)
	i Breathsel="undefined" s Breathsel=""
	s dejectaCheck=$p(Parr,"^",7)
	s BloodSZPresssel=$p(Parr,"^",8)
	i BloodSZPresssel="undefined" s BloodSZPresssel=""
	
	//s tmperature=$p(Parr,"^",4)
	s ctlocdesc=$p(ctloc,"-",2)
	s ctloc=$p(ctloc,"-",1)_$p(ctloc,"-",2)
	s WARDRowID=""
	i ctloc'="" s WARDRowID=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(ctloc),WARDRowID))
	
	i StartDate["-" s StartDate=$ZDH(StartDate,3)
	i StartDate["/" s StartDate=$ZDH(StartDate,4)
	i EndDate["-" s EndDate=$ZDH(EndDate,3)
	i EndDate["/" s EndDate=$ZDH(EndDate,4)
	//s AdmRowId="" f  s AdmRowId=$o(^PAADMi("PAADM_Type","I",AdmRowId)) q:AdmRowId=""  d
	//.s AdmStatus=$p(^PAADM(AdmRowId),"^",20)
	//.q:AdmStatus'="A"
	//.s CURRENTWARDDR=$p(^PAADM(AdmRowId),"^",70)
	//.s HospitalWard=$p($g(^PAWARD(CURRENTWARDDR)),"^",2)
	//.q:(ctloc'="")&&(HospitalWard'=ctloc)
	if WARDRowID'=""
	{
	s room="" 
	f  s room=$O(^PAADMi("CurrWard",WARDRowID,room)) q:room=""  d
	.s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",WARDRowID,room,RowId)) q:RowId=""  d
	..s VistStatus=$P(^PAADM(RowId),"^",20)
	..q:VistStatus="D"
	..s MRADMROWId=$P(^PAADM(RowId),"^",61)
	..s P1="",P2=""
	..for StrDate=StartDate:1:EndDate  d
	...s itmdr="" f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr)) q:itmdr=""  d
	....s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr,chl)) q:chl=""  d
	.....s tempvalue=""
	.....s tempvalue=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	.....//q:(plussel'="")&&(plussel="脉搏<=60")&&(itmdr=10)&&(tempvalue>60)
	.....//q:(plussel'="")&&(plussel="脉搏=>100")&&(itmdr=10)&&(tempvalue<100)
	.....//q:(BloodPresssel'="")&&(BloodPresssel="血压<=60")&&(itmdr=16)&&(tempvalue>60)
	.....//q:(BloodPresssel'="")&&(BloodPresssel="血压>=140")&&(itmdr=16)&&(tempvalue<140)
	.....s time=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",4)
	.....q:time=""
	.....s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
	.....q:itmcode=""
	.....//i itmdr=14 s P1=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	.....//i itmdr=10 s P2=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	.....s ^tmpquery($j,RowId,StrDate,time,itmcode)=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	s PatRowId="" f  s PatRowId=$O(^tmpquery($j,PatRowId)) q:PatRowId=""  d
	.s cc=""
	.s pinfo=..Patinfo(PatRowId)
	.q:pinfo=""
	.s Name=$P(pinfo,"#",2)
	.s Bed=$P(pinfo,"#",3)
	.s PatRegNo=$P(pinfo,"#",8)
	.s Depctloc=$P(pinfo,"#",4)
	.s SEXDesc=$P(pinfo,"#",9)
	.s cc=cc_"RegNo"_"|"_PatRegNo_"^"_"PatName"_"|"_Name_"^"_"DHCNurSex"_"|"_SEXDesc_"^"_"DHCNurLoc"_"|"_$p(Depctloc,"-",2)_"^"_"DHCNurWard"_"|"_ctlocdesc_"^"_"BedCode"_"|"_Bed_"^"
	.s curDate="" f  s curDate=$O(^tmpquery($j,PatRowId,curDate)) q:curDate=""  d
	..s cc=cc_"RecDate"_"|"_$zd(curDate,3)_"^"
	..s curTime="" f  s curTime=$O(^tmpquery($j,PatRowId,curDate,curTime)) q:curTime=""  d
	...s bb="",aa="",plusvalue="",BloodPressvalue="",Breathvalue=""
	...s aa=cc
	...s bb=bb_"RecTime"_"|"_$zt(curTime,1)_"^"
	...s curCode=""  f  s curCode=$O(^tmpquery($j,PatRowId,curDate,curTime,curCode)) q:curCode=""  d
	....s tempvalue1=""
	....i (plussel'="")&&(curCode="Item7") s plusvalue=^tmpquery($j,PatRowId,curDate,curTime,curCode)
	....i (BloodPresssel'="")&&(curCode="Item5") s BloodPressvalue=^tmpquery($j,PatRowId,curDate,curTime,curCode)
	....i (BloodSZPresssel'="")&&(curCode="Item6") s BloodSZPressvalue=^tmpquery($j,PatRowId,curDate,curTime,curCode)
	....i (Breathsel'="")&&(curCode="Item4") s Breathvalue=^tmpquery($j,PatRowId,curDate,curTime,curCode)
	....s bb=bb_curCode_"|"_^tmpquery($j,PatRowId,curDate,curTime,curCode)_"^"
	...s aa=aa_bb
	...//s aa=aa_curCode_"|"_tmp(PatRowId,curDate,curTime,curCode)_"^"
	...s PatMRADMROWId=$P(^PAADM(PatRowId),"^",61)
	...s InPatDate=..GetPatInPatDays(PatRowId)  //这里判断病人入床日和入院日期,如果入床入院小于3日则不计算大便次数
	...i ((curDate-InPatDate)>3) s flag=..getPat3Datedejecta(PatMRADMROWId,curDate)
	...e  s flag=0
	...q:(flag=0)&&(dejectaCheck="true")
	...q:(plussel'="")&&($g(plusvalue)="")
	...q:(BloodPresssel'="")&&($g(BloodPressvalue)="")
	...q:(BloodSZPresssel'="")&&($g(BloodSZPressvalue)="")
	...q:(Breathsel'="")&&($g(Breathvalue)="")
	...q:(plussel'="")&&(plussel="脉搏<=60")&&(plusvalue>60)
	...q:(plussel'="")&&(plussel="脉搏=>100")&&(plusvalue<100)
	...q:(BloodPresssel'="")&&(BloodPresssel="收缩压>=140")&&(BloodPressvalue<140)
	...q:(BloodPresssel'="")&&(BloodPresssel="收缩压<=90")&&(BloodPressvalue>90)
	...q:(BloodSZPresssel'="")&&(BloodSZPresssel="舒张压>=90")&&(BloodSZPressvalue<90)
	...q:(BloodSZPresssel'="")&&(BloodSZPresssel="舒张压<=60")&&(BloodSZPressvalue>60)
	...q:(Breathsel'="")&&(Breathsel="呼吸<=16")&&(Breathvalue>16)
	...q:(Breathsel'="")&&(Breathsel="呼吸>=20")&&(Breathvalue<20)
	...do OutPatDetail

	}
	else 
	{
     s WARDRowID=""  f  s WARDRowID=$O(^PAADMi("CurrWard",WARDRowID)) q:WARDRowID=""  d
     .s room="" f  s room=$O(^PAADMi("CurrWard",WARDRowID,room)) q:room=""  d
     ..s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",WARDRowID,room,RowId)) q:RowId=""  d
	 ...s VistStatus=$P(^PAADM(RowId),"^",20)
	 ...q:VistStatus="D"
	 ...s MRADMROWId=$P(^PAADM(RowId),"^",61)
	 ...s P1="",P2=""
	 ...for StrDate=StartDate:1:EndDate  d
	 ....s itmdr="" f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr)) q:itmdr=""  d
	 .....s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr,chl)) q:chl=""  d
	 ......s time=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",4)
	 ......q:time=""
	 ......s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
	 ......q:itmcode=""
	 ......//i itmdr=14 s P1=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	 ......//i itmdr=10 s P2=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	 ......s ^tmpquery($j,RowId,StrDate,time,itmcode)=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	s PatRowId="" f  s PatRowId=$O(^tmpquery($j,PatRowId)) q:PatRowId=""  d
	.s cc=""
	.s pinfo=..Patinfo(PatRowId)
	.q:pinfo=""
	.s Name=$P(pinfo,"#",2)
	.s Bed=$P(pinfo,"#",3)
	.s PatRegNo=$P(pinfo,"#",8)
	.s Depctloc=$P(pinfo,"#",4)
	.s SEXDesc=$P(pinfo,"#",9)
	.s ctloc=$P($P(^PAWARD($P(^PAADM(PatRowId),"^",70)),"^",2),"-",2)
	.s cc=cc_"RegNo"_"|"_PatRegNo_"^"_"PatName"_"|"_Name_"^"_"DHCNurSex"_"|"_SEXDesc_"^"_"DHCNurLoc"_"|"_$p(Depctloc,"-",2)_"^"_"DHCNurWard"_"|"_ctloc_"^"_"BedCode"_"|"_Bed_"^"
	.s curDate="" f  s curDate=$O(^tmpquery($j,PatRowId,curDate)) q:curDate=""  d
	..s cc=cc_"RecDate"_"|"_$zd(curDate,3)_"^"
	..s curTime="" f  s curTime=$O(^tmpquery($j,PatRowId,curDate,curTime)) q:curTime=""  d
	...s bb="",aa="",plusvalue="",BloodPressvalue="",Breathvalue=""
	...s aa=cc
	...s bb=bb_"RecTime"_"|"_$zt(curTime,1)_"^"
	...s curCode=""  f  s curCode=$O(^tmpquery($j,PatRowId,curDate,curTime,curCode)) q:curCode=""  d
	....s tempvalue1=""
	....i (plussel'="")&&(curCode="Item7") s plusvalue=^tmpquery($j,PatRowId,curDate,curTime,curCode)
	....i (BloodPresssel'="")&&(curCode="Item5") s BloodPressvalue=^tmpquery($j,PatRowId,curDate,curTime,curCode)
	....i (BloodSZPresssel'="")&&(curCode="Item6") s BloodSZPressvalue=^tmpquery($j,PatRowId,curDate,curTime,curCode)
	....i (Breathsel'="")&&(curCode="Item4") s Breathvalue=^tmpquery($j,PatRowId,curDate,curTime,curCode)
	....s bb=bb_curCode_"|"_^tmpquery($j,PatRowId,curDate,curTime,curCode)_"^"
	...s aa=aa_bb
	...//s aa=aa_curCode_"|"_tmp(PatRowId,curDate,curTime,curCode)_"^"
	...s PatMRADMROWId=$P(^PAADM(PatRowId),"^",61)
    ...s InPatDate=..GetPatInPatDays(PatRowId)  //这里判断病人入床日和入院日期,如果入床入院小于3日则不计算大便次数
	...i ((curDate-InPatDate)>3) s flag=..getPat3Datedejecta(PatMRADMROWId,curDate)
	...e  s flag=0
	...q:(flag=0)&&(dejectaCheck="true")
	...q:(plussel'="")&&($g(plusvalue)="")
	...q:(BloodPresssel'="")&&($g(BloodPressvalue)="")
	...q:(BloodSZPresssel'="")&&($g(BloodSZPressvalue)="")
	...q:(Breathsel'="")&&($g(Breathvalue)="")
	...q:(plussel'="")&&(plussel="脉搏<=60")&&(plusvalue>60)
	...q:(plussel'="")&&(plussel="脉搏=>100")&&(plusvalue<100)
	...q:(BloodPresssel'="")&&(BloodPresssel="收缩压>=140")&&(BloodPressvalue<140)
	...q:(BloodPresssel'="")&&(BloodPresssel="收缩压<=90")&&(BloodPressvalue>90)
	...q:(BloodSZPresssel'="")&&(BloodSZPresssel="舒张压>=90")&&(BloodSZPressvalue<90)
	...q:(BloodSZPresssel'="")&&(BloodSZPresssel="舒张压<=60")&&(BloodSZPressvalue>60)
	...q:(Breathsel'="")&&(Breathsel="呼吸<=16")&&(Breathvalue>16)
	...q:(Breathsel'="")&&(Breathsel="呼吸>=20")&&(Breathvalue<20)
	...do OutPatDetail
	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod NurIntegratedQueryDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NurIntegratedQueryDataExecute ]
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

ClassMethod NurIntegratedQueryDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NurIntegratedQueryDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetPatTempData(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetPatTempDataExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCQtVolItem","GetPatTempData","2011-10-10^2011-10-11^EBHKBQ-保9F耳鼻喉科病区^36")
	s aa=""
	s StartDate=$p(Parr,"^",1)
	s EndDate=$p(Parr,"^",2)
	s ctloc=$p(Parr,"^",3)
	s tmperature=$p(Parr,"^",4)
	s ctlocdesc=$p(ctloc,"-",2)
	s ctloc=$p(ctloc,"-",1)_$p(ctloc,"-",2)
	s WARDRowID=""
	i ctloc'="" s WARDRowID=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(ctloc),WARDRowID))
	
	i StartDate["-" s StartDate=$ZDH(StartDate,3)
	i StartDate["/" s StartDate=$ZDH(StartDate,4)
	i EndDate["-" s EndDate=$ZDH(EndDate,3)
	i EndDate["/" s EndDate=$ZDH(EndDate,4)
	//s AdmRowId="" f  s AdmRowId=$o(^PAADMi("PAADM_Type","I",AdmRowId)) q:AdmRowId=""  d
	//.s AdmStatus=$p(^PAADM(AdmRowId),"^",20)
	//.q:AdmStatus'="A"
	//.s CURRENTWARDDR=$p(^PAADM(AdmRowId),"^",70)
	//.s HospitalWard=$p($g(^PAWARD(CURRENTWARDDR)),"^",2)
	//.q:(ctloc'="")&&(HospitalWard'=ctloc)
	if WARDRowID'=""
	{
	s room="" 
	f  s room=$O(^PAADMi("CurrWard",WARDRowID,room)) q:room=""  d
	.s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",WARDRowID,room,RowId)) q:RowId=""  d
	..s VistStatus=$P(^PAADM(RowId),"^",20)
	..q:VistStatus="D"
	..s MRADMROWId=$P(^PAADM(RowId),"^",61)
	..//w !,StartDate_"^"_EndDate
	..for StrDate=StartDate:1:EndDate  d
	...s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,14,chl)) q:chl=""  d
	....s aa=""
	....s time=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",4)
	....q:time=""
	....s P1=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	....q:P1<tmperature
	....s pinfo=..Patinfo(RowId)
	....q:pinfo=""
	....s Name=$P(pinfo,"#",2)
	....s Bed=$P(pinfo,"#",3)
	....s PatRegNo=$P(pinfo,"#",8)
	....s Depctloc=$P(pinfo,"#",4)
	....s SEXDesc=$P(pinfo,"#",9)
	....s aa=aa_"RegNo"_"|"_PatRegNo_"^"_"PatName"_"|"_Name_"^"_"DHCNurXB"_"|"_SEXDesc_"^"_"DHCNurKS"_"|"_$p(Depctloc,"-",2)_"^"_"DHCNurBQ"_"|"_ctlocdesc_"^"_"BedCode"_"|"_Bed_"^"_"RecDate"_"|"_$zd(StrDate,3)_"^"_"RecTime"_"|"_$zt(time,3)_"^"_"Item1"_"|"_P1_"^"
	....do OutPatDetail
	}
	else 
	{
    s WARDRowID=""  f  s WARDRowID=$O(^PAADMi("CurrWard",WARDRowID)) q:WARDRowID=""  d
	.s room="" f  s room=$O(^PAADMi("CurrWard",WARDRowID,room)) q:room=""  d
	..s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",WARDRowID,room,RowId)) q:RowId=""  d
	...s VistStatus=$P(^PAADM(RowId),"^",20)
	...q:VistStatus="D"
	...s MRADMROWId=$P(^PAADM(RowId),"^",61)
	...for StrDate=StartDate:1:EndDate  d
	....s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,14,chl)) q:chl=""  d
	.....s aa=""
	.....s time=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",4)
	.....q:time=""
	.....s P1=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	.....q:P1<tmperature
	.....s pinfo=..Patinfo(RowId)
	.....q:pinfo=""
	.....s Name=$P(pinfo,"#",2)
	.....s Bed=$P(pinfo,"#",3)
	.....s PatRegNo=$P(pinfo,"#",8)
	.....s Depctloc=$P(pinfo,"#",4)
	.....s SEXDesc=$P(pinfo,"#",9)
	.....s ctloc=$P($P(^PAWARD($P(^PAADM(RowId),"^",70)),"^",2),"-",2)
	.....s aa=aa_"RegNo"_"|"_PatRegNo_"^"_"PatName"_"|"_Name_"^"_"DHCNurXB"_"|"_SEXDesc_"^"_"DHCNurKS"_"|"_$p(Depctloc,"-",2)_"^"_"DHCNurBQ"_"|"_ctloc_"^"_"BedCode"_"|"_Bed_"^"_"RecDate"_"|"_$zd(StrDate,3)_"^"_"RecTime"_"|"_$zt(time,3)_"^"_"Item1"_"|"_P1_"^"
	.....do OutPatDetail
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod GetPatTempDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatTempDataExecute ]
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

ClassMethod GetPatTempDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatTempDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
