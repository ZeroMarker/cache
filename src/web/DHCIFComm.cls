Class web.DHCIFComm Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Logon(userid As %String, pinnumber As %String) As %String
{
    s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
  	s User=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(userid,"U"),""))
  	b
  	if User=""{
	  	 zn oldnamespace
         q "-3"
	  	} 
  	s pin=$$ENCR^SSUTIL2(pinnumber)
  	b
  	if pin=""{
	  	 zn oldnamespace
         q "-4"
	  	} 
	i pin'=$p(^SSU("SSUSR",User),"^",3) {
	  	 zn oldnamespace
		q "-4"
	}
	s ssgrp=$p(^SSU("SSUSR",User),"^",5)
	s DefLoc=$p(^SSU("SSUSR",User),"^",4)
	s UserName=$p(^SSU("SSUSR",User),"^",2)
	s UserID=$p(^SSU("SSUSR",User),"^")
	s DefLocDes=$p($G(^CTLOC(DefLoc)),"^",2)
	s DocID=$p(^SSU("SSUSR",User),"^",14)
   	zn oldnamespace 
	s LogonDep=..Getlogonctloc(User)
	if LogonDep="-1"{
		s LogonDep="logonctloc&LocDesc&rowid&$"_DefLocDes_"^"_DefLoc_"^&"
		}else{
			s LogonDep=LogonDep_DefLocDes_"^"_DefLoc_"^&"
			}
	q User_"^"_DefLoc_"^"_ssgrp_"^"_UserName_"^"_UserID_"^"_DocID_"@"_LogonDep
}

ClassMethod Getlogonctloc(UserId) As %String
{
	s retStr=..GetQueryData("web.DHCIFComm:logonctloc",UserId)
	q retStr
}

Query logonctloc(userid As %String) As %Query(ROWSPEC = "LocDesc:%String,rowid:%String")
{
}

ClassMethod logonctlocExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=""  f  s chl=$O(^SSU("SSUSR",userid,"OTHLL",chl)) q:chl=""  d
    .s loc=$P(^SSU("SSUSR",userid,"OTHLL",chl),"^",1)
    .s locdes=$p($G(^CTLOC(loc)),"^",2)
    .q:locdes=""
    .s tm(loc)=locdes
    .b
    s loc=""  f  s loc=$O(tm(loc)) q:loc=""  d
    .s locdes=tm(loc)
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(locdes,loc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod logonctlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = logonctlocExecute ]
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

ClassMethod logonctlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = logonctlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOrdStatCode(oeoriId)
{
	n (oeoriId)
	q:oeoriId="" "-1"
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
    s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
    s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^")
    s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	s curDateTimeVal=($h*100000)+$p($h,",",2)
	s xDateTimeVal=(xDate*100000)+xTime
	i ordStatCode["D",curDateTimeVal<xDateTimeVal s ordStatCode="PD" //已停止预停
	s oeoriEndDate=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",9)
    s oeoriEndTime=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",10)
	s endDateTimeVal=(oeoriEndDate*100000)+oeoriEndTime
	i ordStatCode["V",curDateTimeVal<endDateTimeVal s ordStatCode="TPD" //未停止预停	
	q ordStatCode
}

/// Creator:liulei
/// CreatDate:2010-04-22
/// Description:取门诊病人座位号
ClassMethod GetPatSeat(RegNo As %String) As %String
{
	q:RegNo="" "-1"
	s seatNo=""
	s CTLocID=0 
	f  s CTLocID=$O(^CTLOC(CTLocID)) q:CTLocID=""  d
	.s cttype=$P(^CTLOC(CTLocID),"^",13)
	.q:cttype'="E"
	.s SeatID="" f  s SeatID=$O(^User.DHCNurSySeatI("loc"," "_CTLocID,SeatID)) q:SeatID=""  d
	..s a=^User.DHCNurSySeatD(SeatID)
    ..s flag=$listget(a,7)
    ..q:flag="N"
    ..s id=""  s id=$O(^User.DHCNurSyPatRecI("seat"," "_CTLocID," "_SeatID," Y",id),-1)
    ..i id'="" d
	...s a=^User.DHCNurSyPatRecD(id)
	...s EpisodeID=$listget(a,3)
	...q:EpisodeID'=+EpisodeID
	...s Papmidr=$P($g(^PAADM(EpisodeID)),"^",1)
	...s PatRegNo=$P($g(^PAPER(Papmidr,"PAT",1)),"^",2)
	...q:PatRegNo'=RegNo
	...s seatNo=$listget(a,5)
	q seatNo
}

ClassMethod getarcimDetail(oew, chl) As %String
{
    //n (oew,chl,typ)
     s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
     s glno=$p($g(^OEORD(oew,"I",chl,11)),"^",39)  //关联  OEORI_OEORI_DR
     
	 s scrip=$P(arcimdr,"||")
	 s ver=$P(arcimdr,"||",2)
	 s arcimdes=$P(^ARCIM(scrip,ver,1),"^",2)
	 s packUomId=$P(^ARCIM(scrip,ver,8),"^",14)
	
	 //途径
	 s phcinId=$p($g(^OEORD(oew,"I",chl,2)),"^",7) ;OEORI_Instr_DR
     i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
     //频次
     s phcfrId=$p($g(^OEORD(oew,"I",chl,2)),"^",4)
     if phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
     //要素PHC_FREQ
     //if $G(phcfrCode)'="" s val("sttDateTime")=..FreqTime(phcfrCode)
     if phcfrId'="" s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
	 s doseQty=$p($g(^OEORD(oew,"I",chl,2)),"^",1)
     i doseQty'="" s unitUomId=$p($g(^OEORD(oew,"I",chl,2)),"^",3)
    // W !,doseQty,",",$G(unitUomId),",",chl
	 f rnum=1:1:$G(^OEORD(oew,"I",chl,"DEP",0))  d
	 .s val("notes")=$G(val("notes"))_$G(^OEORD(oew,"I",chl,"DEP",rnum))
     i $G(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
     s dose=$G(doseQty)_" "_$g(unitDesc)
     s val("doseQtyUnit")=$G(doseQty)_" "_$g(unitDesc)
     s phOrdQty=$p($g(^OEORD(oew,"I",chl,1)),"^",12)
     //i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
     b
     if $G(phcinDesc)'="" s dosequnit=..getphbasnum(unitUomId,doseQty,scrip,ver)
    //i (phOrdQty'="")&(unitDesc'="") s val("phOrdQtyUnit")=phOrdQty_" "_unitDesc
    i (phOrdQty'="") s PackNum=phOrdQty_" "_$G(unitDesc)
     s packUomQty=$p($g(^OEORD(oew,"I",chl,9)),"^",4)
     s packUomId=+packUomId
     i (packUomId'=0)&(packUomQty'="") d 
     .s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
     if packUomQty'="" s PackNum=$G(packUomQty)_" "_$G(packUomDesc)
     s val("phOrdQtyUnit")=PackNum
     s val("labNo")=$p($g(^OEORD(oew,"I",chl,3)),"^",20)
     s reclocId=$p($g(^OEORD(oew,"I",chl,3)),"^",6)
     i reclocId'="" s val("reclocDesc")=$P($p($g(^CTLOC(reclocId)),"^",2),"-",2)
     e   s val("reclocDesc")=""
     s oecprId=$p($g(^OEORD(oew,"I",chl,1)),"^",8)
     i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
     i oecprId'="" s PriorCode="^"_$p($g(^OECPR(oecprId)),"^",1)_"^"
     s OrdDate=$P($G(^OEORD(oew,"I",chl,1)),"^",9)  //stdat
     //i ("^S^OMST^"[PriorCode)&(dose'="") s OrdDate=OrdDate+1
     //打印执行单时长期药物开始时间加1 因为是提前摆药
     s OrdDate=$ZD(OrdDate,3) 
     s PrnDate=$ZD(+$H,3)_" "_$Zt($P($H,",",2))
     s SeqNo=$p($g(^OEORD(oew,"I",chl,3)),"^",4) //qshe add 05-08-22
     //i (SeqNo'="")&(+SeqNo'=0) d  //ypz 060925 error data protect
    // .s tmpSeqNo=$P(SeqNo,"||",2)
     //e  s tmpSeqNo=chl    //未打
    // s SeqNo=oew_tmpSeqNo 
     //if $G(dosequnit)'="" s val("doseQtyUnit")=dosequnit
	 s phcfrCode=""
     s Arcim=arcimdes_"|"_$G(val("doseQtyUnit"))_"|"_$G(phcinDesc)_"|"_SeqNo
     q Arcim
}

ClassMethod getphbasnum(dosunit, dosqty, scrip, ver) As %String
{
    //求剂量基本单位   149, 1000                 //540,1
    s drgfrm=$P(^ARCIM(scrip,ver,1),"^",12)
    s drg=+drgfrm,frm=$P(drgfrm,"||",2)
    q:+drgfrm=0 ""
    s basuom=$P(^PHCD(+drgfrm,"DF",frm,2),"^",4)
    if basuom=dosunit q ""
    s eqrw=0 f  s eqrw=$O(^PHCD(drg,"DF",frm,"EQ",eqrw)) q:eqrw=""  d
    .s equnit=$P(^PHCD(drg,"DF",frm,"EQ",eqrw),"^",1)
    .if equnit=dosunit d
    ..s eqval=$P(^PHCD(drg,"DF",frm,"EQ",eqrw),"^",2)
    if $G(eqval)'="" d
    .s num=dosqty/eqval
    .s ret=$FN(num,"",1)_$p($g(^CT("UOM",basuom)),"^",2)
    q ret
}

ClassMethod GetCurrAdm(RegNo) As %String
{
	//登记号转病人就诊号
  	n (RegNo)
  	q:RegNo="" "-1"
  	s nvar=""
	s ln=$L(RegNo)
	s le=10-ln
	s $P(nvar,"0",le)=RegNo
	s papmi=""
	s CurrAdm=0
	f  s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,papmi)) q:papmi=""  d
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s Adm=""
	.f  s Adm=$o(^PAPERdr(papmi,"ADM","O",Adm)) q:Adm=""  d  	
	..s Typ=$p(^PAADM(Adm),"^",2)
	..q:Typ'="O"
	..if Adm>CurrAdm  s CurrAdm=Adm
	if CurrAdm=0 s CurrAdm=""
	q CurrAdm
}

ClassMethod PatInfo(RegNo As %String) As %String
{
	//取病人信息(登记号、座位号、姓名)
	q:RegNo="" "-1"
	s Episodeid=..GetCurrAdm(RegNo)
	q:Episodeid="" "-1"
	s Papmidr=$P(^PAADM(Episodeid),"^",1)
	s PatName=$p($g(^PAPER(Papmidr,"ALL")),"^",1)
	s SeatNo=..GetPatSeat(RegNo)
	q Episodeid_"^"_SeatNo_"^"_PatName
}

ClassMethod InsertOrdItem(userId, oeordId, arcimId, oecprId, qty, userDeptId, anaId, anaOpId, billDesc, notes) As %String
{
	q:(userId="")!(oeordId="")!(arcimId="")!(oecprId="")!(userDeptId="") -1
	s oldNameSpace=$ZNSPACE
	s dataNameSpace=$LIST(^websys.ConfigurationD(1),12)
	zn dataNameSpace
    //w $zn,!
    //w userId_","_oeordId_","_arcimId_","_userDeptId_","_notes
	k PLIST
	s PLIST(4)=arcimId
	s PLIST(6)=userDeptId  ;OEORI_OrdDept_DR
	s PLIST(10)=1   ;OEC_OrderStatus：1核4停6执
	s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)
	s PLIST(14)=ctcpId  //careProvId ;OEORI_Doctor_DR:
	s PLIST(17)=+$h ;  OEORI_SttDat
	s PLIST(18)=$p($h,",",2)  ;OEORI_SttTim
	s PLIST(23)=oecprId   ;OEORI_Priority_DR:OEC_Priority：3临时，5长期
	s PLIST(29)=qty ;OEORI_PhQtyOrd
	s PLIST(45)=billDesc //OEORI_BillDesc
	s PLIST(55)="Y"  ;OEORI_CoverMainIns  Y
	s PLIST(56)="N"  ;OEORI_PortEquipReq  N
	s PLIST(57)="N"  ;OEORI_AdministerSkinTest N
	s PLIST(75)=userDeptId  //OEORI_RecDep_DR
	s PLIST(76)="TB" //OEORI_Billed

	s PLIST(77)=$$GetSeqNo(oeordId,+$h)  ;OEORI_SeqNo，每天排序//
	  
	s PLIST(81)=+$h    ;OEORI_Date
	s PLIST(90)=$p($h,",",2)    ;OEORI_TimeOrd
	s PLIST(106)=anaId
	s PLIST(107)=anaOpId
	s PLIST(111)="A" ;OEORI_ResultFlag A
	s PLIST(120)=userId ;OEORI_UserAdd
	s PLIST(121)=userDeptId  ;OEORI_UserDepartment_DR
	s PLIST(141)=userId ;OEORI_UserUpdate！
	s admId=+^OEORD(oeordId)
	s PLIST(161)=$p(^PAADM(admId),"^",4) //OEORI_AdmLoc_DR：病人科室
	s PLIST(53)=notes //OEORI_DepProcNotes
	s res=$$insert^MVBOEIT0(oeordId,"Y")
	zn oldNameSpace  ; Restore the namespace
	//s ^ypzTmp("app","in")=res_"/"_oeordId_"/"_%ROWID
	q res
GetSeqNo(oeordId,sttdate)
	;生成序列号,原来的程序有点累最
	;Set err=$$lastseq^MVBOEORD(ord,sttdate)
	;Set LastSeqNo=PLIST(1)
	Set LastSeqNo=$o(^OEORDi(0,"StDtSeqNo",oeordId,sttdate,""),-1)
    i LastSeqNo["." s LastSeqNo=$p(LastSeqNo,".")
	Set SeqNo=+LastSeqNo+1
	Q SeqNo
}

/// Creator:liulei
/// CreatDate:2010-05-14
/// Description: 取过敏记录
/// Table：PA_PatMas,PA_Allergy,PHC_Generic,PHC_Ingredient,PHC_DrgMast
/// Input：Adm:病人ID,BaseDate:时间段
/// Output
ClassMethod GetPatAllergy(Adm As %String) As %String
{
	s papmiId=+^PAADM(Adm) 
	s Value=""
    s chl=""  f  s chl=$o(^PAPER(papmiId,"ALG",chl)) q:chl=""  d
    .s InActive=$p(^PAPER(papmiId,"ALG",chl),"^",19)
    .i (InActive="N")  d
    ..s phcdfId=$p(^PAPER(papmiId,"ALG",chl),"^",27)
    ..s OBSD=$p(^PAPER(papmiId,"ALG",chl),"^",14)
    ..s OBST=$p(^PAPER(papmiId,"ALG",chl),"^",15)
    ..i phcdfId'="" d 
    ...s phcdfName=$p(^PHCD(phcdfId,1),"^",2)
    ...i phcdfName'="" s Value=phcdfName_"阳性"
    ..s AlgId=$p(^PAPER(papmiId,"ALG",chl),"^",9)
    ..i AlgId'="" s Value=$p(^PAC("ALG",AlgId),"^",2)_"过敏史"
    ..//通用名
    ..s ALGPHCGEDR=$p(^PAPER(papmiId,"ALG",chl),"^",4)
    ..i ALGPHCGEDR'="" d
    ...s ALGPHCGE=$p(^PHCGE("GE",ALGPHCGEDR),"^",2)
    ...i ALGPHCGE'="" s Value=ALGPHCGE_"阳性"
    q Value
}

ClassMethod CalAge(IBirth, IToday) As %String
{
	n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
	s IBirth=$g(IBirth),IToday=$g(IToday)
	i IBirth>2980000 s IBirth=""
	i IBirth<0 s IBirth=""
	q:'$G(IBirth) ""
	s XBirth=$ZD(IBirth)
	s XToday=$ZD(IToday)
	s AgeMth=XToday-XBirth
	s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
	s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
	s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
	s AgeYear=CurrYear-BirthYear
	;
	i AgeDay<0 d
	. s AgeMth=AgeMth-1
	. s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	. q:XToday'=2
	. s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	;
	s $P(AgeYr,"|",12)=AgeYear
	//s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q:AgeYear>0 AgeYear_"岁"
	q:AgeMth>0 AgeMth_"月"
	q AgeDay_"天"
}

ClassMethod GetQueryData(QueryName, Parr) As %String
{
   //通用Query数据查询
   n (QueryName,Parr)
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()
   //Execute the query
   if $L(Parr,"^")&(Parr'="")=1
   {
	   s sc = rset.Execute(Parr)
   }
   if (Parr="")
   {
	   Set sc = rset.Execute()
   }
   s QueryName=$TR(QueryName,":","&")

   // Now fetch the results
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
	        if rset.GetColumnName(col)="ItemData" continue
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
	        if rset.GetColumnName(col)="ItemData" continue
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_">"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>500  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 b
 q ret
}

ClassMethod GetPath()
{
	&sql(select pathtoreports into :reportPath from websys.configuration)
	q reportPath
}

}
