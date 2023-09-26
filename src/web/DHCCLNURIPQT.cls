Import SQLUser

/// 用于设置操作
Class web.DHCCLNURIPQT Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 128;

ClassMethod GetHead(Typ = "CQSYD") As %String
{
	n (Typ)
	s valStr=""
	if '$D(^DHCCLNurseExec("VarSetColumnPrt",Typ)) q "           医嘱|4000^剂量|1000^整包装数|1000^操作时间|1000^护士签字|1000^病人或家属签字|1600"
	s i=1
	s no=""  f  s no=$O(^DHCCLNurseExec("VarSetColumnPrt",Typ,no)) q:no=""  d
	.s caption=$P(^DHCCLNurseExec("VarSetColumnPrt",Typ,no),"|")
	.s len=$P(^DHCCLNurseExec("VarSetColumnPrt",Typ,no),"|",2)
	.s $P(valStr,"^",i)=caption_"|"_len
	.s i=i+1
	q valStr
}

Query SSGROUP(desc As %String) As %Query(ROWSPEC = "Group:%String,ID:%String")
{
}

ClassMethod SSGROUPExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	 
 	s rw=""  f  s rw=$O(^SSU("SSGRP",rw)) q:rw=""  d
 	.s GrpDesc=$P(^SSU("SSGRP",rw),"^",1)
 	.q:(GrpDesc'[desc)&(desc'="")
    .d Output4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
Output4
	s Data=$lb(GrpDesc,rw)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod SSGROUPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SSGROUPExecute ]
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

ClassMethod SSGROUPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SSGROUPExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod SyCard(oeorid) As %String
{
	s userid=$G(%session.Data("LOGON.USERID"))
	n (oeorid,userid)
	s oew=$P(oeorid,"||")
	s oewsub=$P(oeorid,"||",2)
	s oeoridr=oew_"||"_oewsub
	//s armastdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
	//s armastdes=
	s i=2
	s n=1
	q:$D(^DHCNurseSyd(userid,oew,oewsub)) ""
	s arc=..getarcim(oew,oewsub)
	s mainarc=arc
	s StDate=$ZD($P($G(^OEORD(oew,"I",oewsub,1)),"^",9),3)
	//s StTime=$P($G(^OEORD(oew,"I",oewsub,1)),"^",10) 

	s $P(sycd,"!",1)=$P(arc,"^",1)  //q:chl="" 
	s ^DHCNurseSyd(userid,oew,oewsub)=""
	s chl="" f  s chl=$O(^OEORDi(0,"OEORI",oew,oeoridr,chl)) q:chl=""  d
	.s arc=..getarcim(oew,chl)      //s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
	.if i<4 s $P(sycd,"!",i)=oewsub_"."_(i-1)_" "_$P(arc,"^",1)
	.s ^DHCNurseSyd(userid,oew,chl)=""
	.s i=i+1
	.if i>4 d 
	..s $P(fstr,"!",n)=oewsub_"."_(i-2)_" "_$P(arc,"^",1)
	..s n=n+1
	s sr=..PatInfo(oeoridr)
	s PatName=$P(sr,"^",5)
	s BedCode=$P(sr,"^",7)
	s Loc=$P(sr,"^",2)
	
    s $P(sycd,"^",2)=PatName
    s $P(sycd,"^",3)=BedCode	
    s $P(sycd,"^",4)=$G(ExCpt)	
    s $P(sycd,"^",5)=$G(ExeDate)_" "_$g(ExeTime)	
    s $P(sycd,"^",6)=Loc
    s $P(sycd,"^",7)=StDate
    if $G(fstr)'="" d
    .s $P(fstr,"^",2)=PatName
    .s $P(fstr,"^",3)=BedCode	
    .s $P(fstr,"^",4)=$G(ExCpt)	
    .s $P(fstr,"^",5)=$G(ExeDate)_" "_$g(ExeTime)	
    .s $P(fstr,"^",6)=Loc
    .s $P(fstr,"^",7)=StDate
    q $G(sycd)_"@"_$G(fstr)
}

ClassMethod getarcim(oew, chl) As %String
{
  
    n (oew,chl)
     s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
	 s scrip=$P(arcimdr,"||")
	 s ver=$P(arcimdr,"||",2)
	 s arcimdes=$P(^ARCIM(scrip,ver,1),"^",2)
	 //途径
	 s phcinId=$p($g(^OEORD(oew,"I",chl,2)),"^",7) ;OEORI_Instr_DR
     i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
     //频次
     s phcfrId=$p($g(^OEORD(oew,"I",chl,2)),"^",4)
     if phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
     //要素PHC_FREQ
     if phcfrId'="" s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
	 s doseQty=$p($g(^OEORD(oew,"I",chl,2)),"^",1)
     i doseQty'="" s unitUomId=$p($g(^OEORD(oew,"I",chl,2)),"^",3)
    // W !,doseQty,",",$G(unitUomId),",",chl
     i $G(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
     s dose=$G(doseQty)_" "_$g(unitDesc)
     s oecprId=$p($g(^OEORD(oew,"I",chl,1)),"^",8)
     i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
     s Arcim=arcimdes_"|"_$G(dose)_"|"_$G(phcfrCode)_"|"_$G(phcinDesc)_"|"_$G(phfactor)   //_"^"_$G(oecprDesc)
     q Arcim
}

ClassMethod PatInfo(oeorid) As %String
{
  //病人基本信息
   n (oeorid)
   q:$g(oeorid)="" ""
   if $G(oeorid)'=""
   {
     s aa=$P(oeorid,"||",2)
     if aa'=""
      {
	     s oeordId=$P(oeorid,"||",1)
	     s admId=$p($g(^OEORD(oeordId)),"^",1)
      }
      else
      {
	     s admId=oeorid
	  }
   }
   q:'$d(^PAADM(admId)) ""
    //s papmiId=+^PAADM(admId)
   s papmiId=$P($G(^PAADM(admId)),"^",1)
   s PatType=$P($G(^PAADM(admId)),"^",2) //wkz071017
   // s ^TT(admId)=oeorid_"^"_oeordId
	s ctlocdr=$P(^PAADM(admId),"^",4)
	s doc=$P(^PAADM(admId),"^",9)
	if doc'=""  s docdes=$P(^CTPCP(doc,1),"^",2)
    //if ctlocdr'="" s ctloc=$P(^CTLOC(ctlocdr),"^",2)    //wkz  071023  S
    if ctlocdr'="" s ctloc=$P(^CTLOC(ctlocdr),"^",1)
    //s ctloc1=$P(ctloc,"-",2)
    //i ctloc1'="" s ctloc=ctloc1                        //wkz  071023  E
    s roomdr=$P(^PAADM(admId),"^",69)
    if (roomdr'="") s room=$P(^PAROOM(roomdr),"^",2)
    s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    if $D(^PAPER(papmiId,"PAT",3)) s Bah=$P(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    S homeaddres=$G(^PAPER(papmiId,"PER","ADD")) // 住址
    s hometel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
    s worktel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    if curWardId'="" s WardDes=$P((curWardId),"^",1)
    if (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=##class(web.DHCLCNUREXCUTE).CalAge(birth,+$h)
    s age=$P(age,"Y",1)
    //s str=regno_"^"_$G(ctloc)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel_"^"_$G(docdes)   //wkz071017
    s str=regno_"^"_$G(ctloc)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel_"^"_$G(docdes)_"^"_PatType   
   q str
}

ClassMethod GetLabInterFaceData(RowId)
{
 n (RowId)
  s HisID=RowId
  s PatInfo=..PatInfo(RowId)
  s Ord=+RowId
  s OrdSub=$P(RowId,"||",2)
  s ItmmAst=$p($g(^OEORD(Ord,"I",OrdSub,1)),"^",2)
  s Ar=+ItmmAst,ArSub=$P(ItmmAst,"||",2)
  s ChargeItemID=$P(^ARCIM(Ar,ArSub,1),"^",1) 
  s PatType=$P(PatInfo,"^",13)
  if PatType="I" s PatType="1"
  if PatType="O" s PatType="2"
  if PatType="E" s PatType="3"
  s OutPatID=$P(PatInfo,"^",14)
  s InPatID=$P(PatInfo,"^",1)
  s ChargeType=""
  s PatName=$P(PatInfo,"^",5)
  s PatSex=$P(PatInfo,"^",4)
  if PatSex="男" s PatSex="1"
  if PatSex="女" s PatSex="2"
  s PatAge=$P(PatInfo,"^",8)
  s PatNation=""
  s ABO=""
  s RH=""
  s PatDept=$P(PatInfo,"^",2)    //WKZ 071023
  //s PatDept=$P(PatInfo,"^",15)
  s PatWard=$P(PatInfo,"^",9)
  s PatBed=$P(PatInfo,"^",7)
  s PatBed=$P(PatBed,"床")     //wkz  071025
  s Especial=""
  s Inspected=""
  s Infection=""
  s Diagnoses=""
  s MedicalRecord=""
  s ReqDept=""
  s ReqTime=""
  s ReqPerson=""
  s ExeDept=""
  s ExeTime=""
  
  s oeordId=$p(HisID,"||",1)                            //  WKZ   S
  s docId=""
  s doctorId=""
  s doctor=""
  s defDepId=""
  s defDepDesc=""
  s admId=$p($g(^OEORD(oeordId)),"^",1)  
  s docId=$p(^PAADM(admId),"^",9)
  i $l(docId),$d(^CTPCP(docId)) d
  .s doctorId=$p(^CTPCP(docId,1),"^",1)
  .s doctor=$p(^CTPCP(docId,1),"^",2)
  //s ExePerson=doctorId
  s ReqPerson=doctorId                  
  s SampleClass=$G(^OEORD(Ord,"I",OrdSub,"DEP",1))      //  WKZ   E
  
  s ExePerson=""
  s PrintDept=""
  s PrintTime=""
  s PrintPerson=""
  //s SampleClass=""
  s SamplingPos=""
  s SamplingDept=""
  s SamplingTime=""
  s SamplingPerson=""
  s ReceiveDept=""
  s ReceiveTime=""
  s ReceivePerson=""
  s ReqState="0"
  s Remark=""
  s ChargeState=""
  s ChargeTime=""
  s ChargePerson=""
  s ChargeItemUniteFlag=""
  s HisID1=$p(HisID,"||",1)      //wkz  071017 S
  s HisID2=$p(HisID,"||",2)
  s HisID=HisID1_"@"_HisID2
  //s HisID=$e(HisID,"||","@")   //wkz  071017 E
  s RetStr=HisID_"|"_PatType_"|"_OutPatID_"|"_InPatID_"|"_ChargeType_"|"_PatName_"|"_PatSex_"|"_PatAge_"|"_PatNation_"|"_ABO_"|"_RH_"|"_PatDept_"|"_PatWard_"|"_PatBed_"|"_Especial_"|"_Inspected_"|"_Infection_"|"_Diagnoses_"|"_MedicalRecord_"|"_ReqDept_"|"_ReqTime_"|"_ReqPerson_"|"_ExeDept_"|"_ExeTime_"|"_ExePerson_"|"_PrintDept_"|"_PrintTime_"|"_PrintPerson_"|"_SampleClass_"|"_SamplingPos_"|"_SamplingDept_"|"_SamplingTime_"|"_SamplingPerson_"|"_ReceiveDept_"|"_ReceiveTime_"|"_ReceivePerson_"|"_ReqState_"|"_Remark_"|"_ChargeItemID_"|"_ChargeState_"|"_ChargeTime_"|"_ChargePerson_"|"_ChargeItemUniteFlag_"|"
  //s ^wwjlab($j,InPatID,ExeTime)=RetStr
  s ^T0=RetStr
 q RetStr
}

}
