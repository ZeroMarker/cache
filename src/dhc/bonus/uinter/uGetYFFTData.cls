/// 药房发退药品统计
/// zhaoliguo 整理
/// 2013-04-16
Class dhc.bonus.uinter.uGetYFFTData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Description:用于提供给其它组接口用的查询
/// created by:gwj
/// date:2011-04-15 zw ^TMPDHCBONUS("201303","YFFTDATA")
/// w ##class(dhc.bonus.uinter.uGetYFFTData).GetYFFTData("2013-06-01","2013-06-30","5")
ClassMethod GetYFFTData(datefrom As %String, dateto As %String, MethodDr As %String) As %String
{
  q:datefrom="" ""
  q:dateto="" ""
  s Year=$p(datefrom,"-",1)
  s Month=$p(datefrom,"-",2)
  s YM=Year_Month
  s YearMonth=Year_"-"_Month
  k ^TMPDHCBONUS(YM,"YFFTDATA")
  s datefrom=$ZDH(datefrom,3)
  s dateto=$ZDH(dateto,3)
  k ^STWorkLoadTMP
    
  &sql(delete from dhc_bonus.test1)
 ; s ^zlgtmp("being")=datefrom_"^"_dateto_"^"_MethodDr
  ;w "beinging ....",!
  f pdate=datefrom:1:dateto d
  .q:$d(^DHCINTR(0,"Date",pdate))=0
  .s ret=..SetManuI(pdate)  //制剂加工   //update gsb 
  .s INTRId="" f  s INTRId=$o(^DHCINTR(0,"Date",pdate,INTRId)) q:INTRId=""  d
  ..s INTRTY=$p(^DHCINTR(INTRId),"^",1)            ;交易类型
  ..s INTRPO=$p(^DHCINTR(INTRId),"^",9)            ;交易指针
  ..i INTRTY="P" d
  ...s TrMSG="摆药 住院发药"
  ...s ret=..SetIPWLI(INTRPO)
  ..i INTRTY="Y" d
  ...s TrMSG="病人退药 住院"
  ...s ret=..SetIPWLO(INTRPO)
  ..i INTRTY="F" d
  ...s TrMSG="发放 门诊发药"
  ...s ret=..SetOPWLI(INTRPO)
  ..i INTRTY="H" d
  ...s TrMSG="病人退药 门诊"
  ...s ret=..SetOPWLO(INTRPO)
  ..i INTRTY="S" d
  ...s TrMSG="门诊非正常发药"
  ..i INTRTY="Z" d
  ...s TrMSG="门诊非正常退药"
  
  s index=0
  i $d(^STWorkLoadTMP("X"))'=0  d
  .s locsub="" f  s locsub=$o(^STWorkLoadTMP("X",locsub)) q:locsub=""  d
  ..s itmsub="" f  s itmsub=$o(^STWorkLoadTMP("X",locsub,itmsub)) q:itmsub=""  d
  ...s index=index+1
  ...s ^TMPDHCBONUS(YM,"YFFTDATA",index)=YearMonth_","_locsub_",,"_itmsub_","_$g(^STWorkLoadTMP("X",locsub,itmsub))
  ...s vls0=$g(^STWorkLoadTMP("X",locsub,itmsub))
  ...;&sql(insert into dhc_bonus.test1(f1,f2,f3,f4,f5) values(:YearMonth,:locsub,'',:itmsub,:vls0))
  
  i $d(^STWorkLoadTMP("Z"))'=0  d
  .s locsub="" f  s locsub=$o(^STWorkLoadTMP("Z",locsub)) q:locsub=""  d
  ..S usrsub="" f  s usrsub=$o(^STWorkLoadTMP("Z",locsub,usrsub)) q:usrsub=""  d
  ...s UserCode=$p(^SSU("SSUSR",usrsub),"^",1)
  ...s itmsub="" f  s itmsub=$o(^STWorkLoadTMP("Z",locsub,usrsub,itmsub)) q:itmsub=""  d
  ....s index=index+1
  ....s ^TMPDHCBONUS(YM,"YFFTDATA",index)=YearMonth_","_locsub_","_UserCode_","_itmsub_","_$g(^STWorkLoadTMP("Z",locsub,usrsub,itmsub))
  ....s vls1=$g(^STWorkLoadTMP("Z",locsub,usrsub,itmsub))
  ....;&sql(insert into dhc_bonus.test3(f1,f2,f3,f4,f5) values(:YearMonth,:locsub,:UserCode,:itmsub,:vls1))


  i $d(^STWorkLoadTMP("M"))'=0  d
  .s locsub="" f  s locsub=$o(^STWorkLoadTMP("M",locsub)) q:locsub=""  d
  ..s itmsub="" f  s itmsub=$o(^STWorkLoadTMP("M",locsub,itmsub)) q:itmsub=""  d
  ...s index=index+1
  ...s ^TMPDHCBONUS(YM,"YFFTDATA",index)=YearMonth_","_locsub_",,"_itmsub_","_$g(^STWorkLoadTMP("M",locsub,itmsub))
  ...s vls=$g(^STWorkLoadTMP("M",locsub,itmsub))
  ...;&sql(insert into dhc_bonus.test3(f1,f2,f3,f4,f5) values(:YearMonth,:locsub,'',:itmsub,:vls))

 /*
  ;------------以下为新加--------------------------------
  s Month="M" _ Month
  &sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:Month and InterLocMethodID =:MethodDr )
    
  	k ^TMPDHCBONUSYF

  	;统计药房【人员】工作量
	s num=""
	f  s num=$o(^TMPDHCBONUS(YM,"YFFTDATA",num)) q:num=""  d
	.s deptCode=$p(^TMPDHCBONUS(YM,"YFFTDATA",num),",",2) ;药房编码
	.i deptCode = "24"  s deptCode = "29"
	.s empCode=$p(^TMPDHCBONUS(YM,"YFFTDATA",num),",",3)  ;人员编码
	.s iCode=$p(^TMPDHCBONUS(YM,"YFFTDATA",num),",",4)  ;项目编码
	.s itemValue=$p(^TMPDHCBONUS(YM,"YFFTDATA",num),",",5)  ;项目数值
	.;&sql(insert into dhc_bonus.test1(f1,f2,f3,f4,f5) values(:deptCode,:empCode,:iCode,:itemValue,getdate()))
	.i iCode="I1" d
	..s ^TMPDHCBONUSYF(deptCode,iCode)=$G(^TMPDHCBONUSYF(deptCode,iCode))+itemValue
	
	.i empCode="" d
	..s sCode="06040" ; 药房人员工作量
	.e  d
	..s sCode=iCode
	.q:deptCode=172 
	.i empCode'="" d
	..i $D(^dhcbsBonusUnitI("BonusUnitCode",empCode)) d 
	...s rowid="" ; 
	...s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",empCode,rowid))
	...i rowid'="" d
	....s supDeptID=$LI(^dhcbsBonusUnitD(rowid),6) ;取上级单位ID 186=中药房
	....i supDeptID=186 d
	.....s ^TMPDHCBONUSYF(deptCode,sCode)=$G(^TMPDHCBONUSYF(deptCode,sCode))+itemValue
	..i sCode="I1" d
	...s ^TMPDHCBONUSYF(deptCode,sCode)=$G(^TMPDHCBONUSYF(deptCode,sCode))+itemValue
	.e  d
	..s ^TMPDHCBONUSYF(deptCode,sCode)=$G(^TMPDHCBONUSYF(deptCode,sCode))+itemValue
	.s ItemCode="",ItemDesc=""
	.i iCode="C11" s ItemCode ="06032",ItemDesc="中药房自煎味数"
	.i iCode="C12" s ItemCode ="06030",ItemDesc="中药房代煎味数"
	.i iCode="H11" s ItemCode ="06033",ItemDesc="中药房自煎副数"
	.i iCode="H12" s ItemCode ="06031",ItemDesc="中药房代煎副数"
	.i empCode'="" d
	..s DorName=""
	..i $D(^dhcbsBonusUnitI("BonusUnitCode",empCode)) d 
	...s rowid="" ; 
	...s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",empCode,rowid))
	...i rowid'="" d
	....s DorName=$LI(^dhcbsBonusUnitD(rowid),3)
	..s UnitType=5 ;数据类型工作量
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:empCode,:DorName,:Year, :Month,:itemValue,getdate(), 0,:UnitType,:MethodDr)
		)

	;插入【药房】工作量数据
	s deptCode=""
	f  s deptCode=$o(^TMPDHCBONUSYF(deptCode)) q:deptCode=""  d
	.s deptName=""
	.i $D(^dhcbsBonusUnitI("BonusUnitCode",deptCode)) d 
	..s rowid="" 
	..s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",deptCode,rowid))
	..i rowid'="" d
	...s deptName=$LI(^dhcbsBonusUnitD(rowid),3)
	.s itemCode=""
	.f  s itemCode=$o(^TMPDHCBONUSYF(deptCode,itemCode)) q:itemCode=""  d
	..s ItemCode="",ItemDesc=""
	
	..i itemCode="06040" d
	...s ItemCode="06040"
	...s ItemDesc="药房工作量" 
	...;i deptCode=24 s deptCode=29
	..i itemCode="C11" s ItemCode ="06032",ItemDesc="中药房自煎味数"
	..i itemCode="C12" s ItemCode ="06030",ItemDesc="中药房代煎味数"
	..i itemCode="H11" s ItemCode ="06033",ItemDesc="中药房自煎副数"
	..i itemCode="H12" s ItemCode ="06031",ItemDesc="中药房代煎副数"
	..i itemCode="I1" d 
	...s ItemCode ="06105"
	...s ItemDesc="炮制加工费"
	...;i deptCode=24 s deptCode=29
	
	..s itemValue=$G(^TMPDHCBONUSYF(deptCode,itemCode))
	
	..;w deptCode,!
	..s UnitType=5 ;数据类型工作量
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:deptCode,:deptName,:Year, :Month,:itemValue,getdate(), 0,:UnitType,:MethodDr)
		)

  */
  q index
}

/// 取制剂收入 62913
/// w ##class(dhc.bonus.uinter.uGetYFFTData).SetManuI("62913")
ClassMethod SetManuI(date As %String) As %String
{
  	;n (date)
  	
  	q:'$d(^DHCINMAN(0,"DATE",date)) ""
  	s INMANID=""
  	f  s INMANID=$o(^DHCINMAN(0,"DATE",date,INMANID))  q:INMANID=""  d
  	.s CtlocDr=$p(^DHCINMAN(INMANID),"^",3)
  	.;s ElseAmount=$p(^DHCINMAN(INMANID),"^",15)
  	.s ElseAmount=$p(^DHCINMAN(INMANID),"^",12)  ;update by boxidong 20130520
  	.i $d(^STWorkLoadTMP("M",CtlocDr,"I1"))=0  d
  	..S ^STWorkLoadTMP("M",CtlocDr,"I1")=ElseAmount
  	.E  D
  	..s OldAmt=^STWorkLoadTMP("M",CtlocDr,"I1")
  	..s NewAmt=OldAmt+ElseAmount
  	..s ^STWorkLoadTMP("M",CtlocDr,"I1")=NewAmt
  q 0
}

ClassMethod SetOPWLI(PHDISPEN As %String) As %String
{
  ;n (PHDISPEN)
  s mmm=$P(PHDISPEN,"||",1),ddd=$P(PHDISPEN,"||",2)
  q:'$d(^DHCPHDI(mmm,"PHDI",ddd)) ""
  s PHLDR=$p(^DHCPHDISP(mmm,1),"^",1)
  s CTLOC=$p(^DHCPHLOC(PHLDR),"^",1)
  i (CTLOC="32")!(CTLOC="33")  d
  .s OEORI=$p(^DHCPHDI(mmm,"PHDI",ddd),"^",5)
  .s QtyPack=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),9),"^",4)
  .i $d(^STWorkLoadTMP("X",CTLOC,"A1"))=0  d
  ..s ^STWorkLoadTMP("X",CTLOC,"A1")=1
  .e  d
  ..s OldQty=^STWorkLoadTMP("X",CTLOC,"A1")
  ..s NewQty=OldQty+1
  ..s ^STWorkLoadTMP("X",CTLOC,"A1")=NewQty
  i (CTLOC="31")!(CTLOC="172")  d ;草药
  .//----------------------------------------
  .s Prescno=$p(^DHCPHDISP(mmm,2),"^",1)
  .s Queid=$O(^PAQUE1(0,"PrescNo",Prescno,""))
  .i ((Queid'="")&&($d(^PAQUE1(Queid,"DHC")))) s jytype=$P(^PAQUE1(Queid,"DHC"),"^",15)
  .e  s jytype="其他"
  .i jytype["自煎"  s jytypeC="C11"
  .e  s jytypeC="C12"
  .i jytype["自煎"  s jytypeH="H11"
  .e  s jytypeH="H12"
  .//-----------------------------------------
  .s CUsr=$p(^DHCPHDISP(mmm,1),"^",3)
  .q:CUsr=""
  .s SSUsr=$p(^DHCPHPER(CUsr),"^",5)
  .s ret=..GetOPPrescInfo(PHDISPEN)
  .q:ret=""
  .s c1=$p(ret,"^",1)
  .s h1=$p(ret,"^",2)
  .i $d(^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeC))=0  d
  ..s ^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeC)=c1
  .e  d
  ..s Oldc1=^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeC)
  ..S Newc1=Oldc1+c1
  ..s ^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeC)=Newc1
  .i $d(^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeH))=0  d
  ..s ^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeH)=h1
  ..s ^STWorkLoadTMP("Z",CTLOC,SSUsr,"HPHD",mmm)=mmm
  .e  d
  ..i $d(^STWorkLoadTMP("Z",CTLOC,SSUsr,"HPHD",mmm))=0  d
  ...s Oldh1=^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeH)
  ...s Newh1=Oldh1+h1
  ...s ^STWorkLoadTMP("Z",CTLOC,SSUsr,"HPHD",mmm)=mmm
  ...S ^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeH)=Newh1
  q 0
}

ClassMethod SetOPWLO(PHRetI As %String) As %String
{
  ;n (PHRetI)
  s mmm=$P(PHRetI,"||",1),ddd=$P(PHRetI,"||",2)
  q:'$d(^DHCPHRTI(mmm,"RTI",ddd)) ""
  
  s PHLDR=$p(^DHCPHRET(mmm),"^",7)
  s CTLOC=$p(^DHCPHLOC(PHLDR),"^",1)
  q:(CTLOC'="32")&(CTLOC'="33") ""
  s RETQTY=$p(^DHCPHRTI(mmm,"RTI",ddd),"^",1)
  s oeori=$p(^DHCPHRTI(mmm,"RTI",ddd),"^",2)  ;DHC_PHRETITM
  s ReUnit=$p(^DHCPHRTI(mmm,"RTI",ddd),"^",4)
  s itmmast=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
  S INCI=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
  s BaseUOM=$p(^INCI(INCI,1),"^",10)
  s facrowid=""
  s facrowid=$o(^CT("CTCF",0,"UOM",ReUnit,BaseUOM,facrowid)) 
  i facrowid'="" d       
  .s fac=$p(^CT("CTCF",facrowid),"^",3)
  .s fac=$p(fac,$c(1))
  e  d
  .s fac=1
  s RETQTY=RETQTY/fac
  i $d(^STWorkLoadTMP("X",CTLOC,"B1"))=0  d
  .s ^STWorkLoadTMP("X",CTLOC,"B1")=1  ;RETQTY
  e  d
  .s OldQty=^STWorkLoadTMP("X",CTLOC,"B1")
  .s NewQty=OldQty+1  ;RETQTY
  .s ^STWorkLoadTMP("X",CTLOC,"B1")=NewQty
  q 0
}

ClassMethod SetIPWLI(PHDISPEN As %String) As %String
{
 ;n (PHDISPEN)
 q:PHDISPEN="" ""
 s mmm=$p(PHDISPEN,"||",1),ddd=$P(PHDISPEN,"||",2)
 s CTLOC=$p(^DHCPHAC(mmm),"^",1)
 S OrdType=$p(^DHCPHAC(mmm),"^",12)
 I OrdType="ZCY"  D
 .i (CTLOC="31")!(CTLOC="172")  d ;草药
 ..//----------------------------------------
 ..s phacsub=$O(^DHCPHAC(mmm,"I",""))
 ..s Prescno=$p(^DHCPHAC(mmm,"I",phacsub),"^",5)
 ..s Queid=$O(^PAQUE1(0,"PrescNo",Prescno,""))
 ..i ((Queid'="")&&($d(^PAQUE1(Queid,"DHC")))) s jytype=$P(^PAQUE1(Queid,"DHC"),"^",15)
 ..e  s jytype="其他"
 ..i jytype["自煎"  s jytypeC="C11"
 ..e  s jytypeC="C12"
 ..i jytype["自煎"  s jytypeH="H11"
 ..e  s jytypeH="H12"
 ..//-----------------------------------------
 ..s SSUsr=$p(^DHCPHAC(mmm),"^",13)
 ..q:SSUsr=""
 ..s ret=..GetPrescInfo(PHDISPEN)
 ..Q:ret=""
 ..s c1=$p(ret,"^",1)
 ..s h1=$p(ret,"^",2)
 ..i $d(^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeC))=0  d
 ...s ^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeC)=c1
 ..e  d
 ...s Oldc1=^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeC)
 ...S Newc1=Oldc1+c1
 ...s ^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeC)=Newc1
 ..i $d(^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeH))=0  d
 ...s ^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeH)=h1
 ...s ^STWorkLoadTMP("Z",CTLOC,SSUsr,"HPHD",mmm)=mmm
 ..e  d
 ...i $d(^STWorkLoadTMP("Z",CTLOC,SSUsr,"HPHD",mmm))=0  d
 ....s Oldh1=^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeH)
 ....s Newh1=Oldh1+h1
 ....s ^STWorkLoadTMP("Z",CTLOC,SSUsr,"HPHD",mmm)=mmm
 ....S ^STWorkLoadTMP("Z",CTLOC,SSUsr,jytypeH)=Newh1
 E  D
 .s oeori=$p(^DHCPHAC(mmm,"I",ddd),"^",7)
 .i CTLOC="35"  d  ;中心摆药室：发药量、退药量按药品基本单位（阿莫西林10粒，那么工作量就是10）。
 ..s bTrQty=$p(^DHCPHAC(mmm,"I",ddd),"^",6)				;基本单位数量
 ..i $d(^STWorkLoadTMP("X",CTLOC,"A1"))=0  d
 ...s ^STWorkLoadTMP("X",CTLOC,"A1")=bTrQty
 ..e  d
 ...s OldQty=^STWorkLoadTMP("X",CTLOC,"A1")
 ...s NewQty=OldQty+bTrQty
 ...s ^STWorkLoadTMP("X",CTLOC,"A1")=NewQty
 .I CTLOC="34"  d  ;病房西药房：根据发药单，退药单上的药品品种进行汇总统计。
 ..s INCIDR=$p(^DHCPHAC(mmm,"I",ddd),"^",4)     ;2
 ..i $d(^STWorkLoadTMP("X",CTLOC,"A1"))=0  d
 ...s ^STWorkLoadTMP("X",CTLOC,"A1")=1
 ...s ^STWorkLoadTMP("Xtmp",CTLOC,"AINC",mmm,INCIDR)=INCIDR
 ..e  d
 ...I $d(^STWorkLoadTMP("Xtmp",CTLOC,"AINC",mmm,INCIDR))=0  d
 ....s OldQty=^STWorkLoadTMP("X",CTLOC,"A1")
 ....s NewQty=OldQty+1
 ....s ^STWorkLoadTMP("X",CTLOC,"A1")=NewQty
 ....s ^STWorkLoadTMP("Xtmp",CTLOC,"AINC",mmm,INCIDR)=INCIDR
 q 0
}

ClassMethod SetIPWLO(PHRetI As %String) As %String
{
 ;n (PHRetI)
 q:PHRetI="" ""
 q:'$d(^PHARET(PHRetI)) ""
 s oeori=$p(^PHARET(PHRetI),"^",5)
 s PHALoc=$p(^PHARET(PHRetI),"^",8)
 q:(PHALoc'="34")&(PHALoc'="35") ""
 i PHALoc="35"  d  ;中心摆药室：发药量、退药量按药品基本单位（阿莫西林10粒，那么工作量就是10）。
 .s bTrQty=$p(^PHARET(PHRetI),"^",12)				;基本单位数量
 .i $d(^STWorkLoadTMP("X",PHALoc,"B1"))=0  d
 ..s ^STWorkLoadTMP("X",PHALoc,"B1")=bTrQty
 .e  d
 ..s OldQty=^STWorkLoadTMP("X",PHALoc,"B1")
 ..s NewQty=OldQty+bTrQty
 ..s ^STWorkLoadTMP("X",PHALoc,"B1")=NewQty
 i PHALoc="34"  d
 .s RetNo=$p(^PHARET(PHRetI),"^",16)    ;退药单号
 .s INCLB=$p(^PHARET(PHRetI),"^",6)
 .i $d(^STWorkLoadTMP("X",PHALoc,"B1"))=0  d
 ..s ^STWorkLoadTMP("X",PHALoc,"B1")=1
 ..s ^STWorkLoadTMP("Xtmp",PHALoc,"BINC",RetNo,INCLB)=INCLB
 .e  d
 ..I $d(^STWorkLoadTMP("Xtmp",PHALoc,"BINC",RetNo,INCLB))=0  d
 ...s OldQty=^STWorkLoadTMP("X",PHALoc,"B1")
 ...s NewQty=OldQty+1
 ...s ^STWorkLoadTMP("X",PHALoc,"B1")=NewQty
 ...s ^STWorkLoadTMP("Xtmp",PHALoc,"BINC",RetNo,INCLB)=INCLB
 q 0
}

ClassMethod GetDistinctItm(PHAID As %String) As %String
{
 ;n (PHAID) 
 s Num=0
 s csub="0" f  s csub=$o(^DHCPHAC(PHAID,"I",csub)) q:csub=""  d
 .s INCIDR=$p(^DHCPHAC(PHAID,"I",csub),"^",4)
 .i Num=0  d
 ..s INCISTR="^"_INCIDR_"^"
 ..s Num=Num+1
 .e  d
 ..i INCISTR'["^"_INCIDR_"^"  d
 ...s INCISTR=INCISTR_INCIDR_"^"
 ...s Num=Num+1
 q Num
}

ClassMethod GetOPPrescInfo(PHDISPEN As %String) As %String
{
 ;n (PHDISPEN) 
 s DNum=0,CNum=0
 s mmm=$P(PHDISPEN,"||",1),ddd=$P(PHDISPEN,"||",2)
 ;s PrescNo=$p(^DHCPHAC(PHAID,"I",csub),"^",5)
 ;S INCIDR=$p(^DHCPHDI(PHAID,"PHDI",csub),"^",1)
 S OEORI=$p(^DHCPHDI(mmm,"PHDI",ddd),"^",5)
 s DuratDR=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),2),"^",6)
 s DuraQty=0
 i DuratDR'=""  s DuraQty=$p(^PHCDU(DuratDR),"^",2)
 S ARCIM=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2)
 s ItemCat=$p(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1),"^",10)
 s CatDesc=""
 i ItemCat'=""  s CatDesc=$p(^ARC("IC",ItemCat),"^",2)
 q:(CatDesc="草药加工")!(CatDesc="草药材料") ""
 q "1^"_DuraQty
}

ClassMethod GetPrescInfo(PHDISPEN As %String) As %String
{
 ;n (PHDISPEN) 
 s DNum=0,CNum=0
 
 s mmm=$p(PHDISPEN,"||",1),ddd=$P(PHDISPEN,"||",2)
 s PrescNo=$p(^DHCPHAC(mmm,"I",ddd),"^",5)
 S INCIDR=$p(^DHCPHAC(mmm,"I",ddd),"^",4)
 S OEORI=$p(^DHCPHAC(mmm,"I",ddd),"^",7)
 s DuratDR=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),2),"^",6)
 s DuraQty=0
 i DuratDR'=""  s DuraQty=$p(^PHCDU(DuratDR),"^",2)
 S ARCIM=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2)
 s ItemCat=$p(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1),"^",10)
 s CatDesc=""
 i ItemCat'=""  s CatDesc=$p(^ARC("IC",ItemCat),"^",2)
 q:(CatDesc="草药加工")!(CatDesc="草药材料") ""
 
 q "1^"_DuraQty
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetYFFTDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
