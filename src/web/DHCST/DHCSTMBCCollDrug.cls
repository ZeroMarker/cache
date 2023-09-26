Import sqluser

/// Descript:煎药室相关程序
/// Creater:    wyx
/// CreateDate: 2014-09-30
Class web.DHCST.DHCSTMBCCollDrug Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// 取下一个状态
ClassMethod GetNextStat(mbscdr As %String, type As %String) As %String
{
	N (mbscdr,type)
	Q:mbscdr="" ""
	Q:'$D(^DHCMBCS(mbscdr)) ""
	S mbcnumber=$P(^DHCMBCS(mbscdr),"^",1)
	S nextnumber=$O(^DHCMBCS(0,"FN",type,"Y",mbcnumber))
	Q:nextnumber="" ""
	S nextmbcs=$O(^DHCMBCS(0,"TYPENUMBER",type,nextnumber,""))
	Q nextmbcs_"^"_nextnumber
}

//w ##class(web.DHCST.DHCSTMBCCollDrug).RecSave("O15072000012",1056)

ClassMethod RecSave(Prescno As %String, User As %String)
{
  n (Prescno,User)	
  q:Prescno="" -10 //处方号为空
  s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno)
  s jycook=$p(retstr,"^",7) //煎药方式
  s facotor=$p(retstr,"^",2) //剂数
  q:'$d(^OEORD(0,"PrescNo",Prescno)) -40  //先不存在
  q:'$d(^DHCPHDISPi("PRESCNO",Prescno))&&'$d(^DHCPHAC(0,"Prescno",Prescno)) -50  //再未发药
  s Phdr=$o(^DHCPHDISPi("PRESCNO",Prescno,""))
  i Phdr'="" d
  .s type="O"  //状态类型
  .s Papmi=$p(^DHCPHDISP(Phdr),"^",7)
  .s Phdi=$o(^DHCPHDI(Phdr,"PHDI",""))
  .s orditm=$p(^DHCPHDI(Phdr,"PHDI",Phdi),"^",5)
  .s ord=$p(orditm,"||",1)
  .s itm=$p(orditm,"||",2)
  .s AdmId=+$P(^OEORD(ord),"^",1) //adm号
  .s fyrowid=Phdr   //发药id
  .s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7)  //医嘱日期
  .s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
  .s deplocdr=$p(^PAADM(AdmId),"^",4) //患者就诊科室
  e  d
  .s PhaId=$o(^DHCPHAC(0,"Prescno",Prescno,""))
  .s PhaItmId=$o(^DHCPHAC(0,"Prescno",Prescno,PhaId,""))
  .i PhaId'="" d
  ..s type="I"   //状态类型
  ..s AdmId=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",3)  //adm号
  ..s fyrowid=PhaId   //发药id
  ..s orditm=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",7)  //
  ..s ord=$p(orditm,"||",1)
  ..s itm=$p(orditm,"||",2)
  ..s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7) //医嘱日期
  ..s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
  ..s WardId=$p(^DHCPHAC(PhaId),"^",4)  //患者病区
  ..s deplocdr=$p(^PAWARD(WardId),"^",5)  	;病区对应的CT_Loc记录
  s mbcrowid=$o(^DHCMBC(0,"PRESCNO",Prescno,""))
  q:mbcrowid'="" -30 //已经扫描
  s state="10" //收药状态number
  s statedr=$O(^DHCMBCS(0,"TYPENUMBER",type,state,""))
  &sql(insert into DHCST_MBCCollDrug(MBC_PrescNo,MBC_Adm_Dr,MBC_Facotor,MBC_Pointer,MBC_State_Dr,MBC_OrdDate,MBC_OrdTime,MBC_Type,MBC_LocDr) values(:Prescno,:AdmId,:facotor,:fyrowid,:statedr,:orddate,:ordtime,:type,:deplocdr))
  q:SQLCODE'=0 SQLCODE
  s Parref=$p(%ROWID,$c(1))
  s ChildSub=1
  s Date=+$h
  s Time=$p($h,",",2)
  &sql(insert into DHCST_MBCCollDrugItem(MBCI_Parref,MBCI_ChildSub,MBCI_DateUser_Dr,MBCI_Date,MBCI_Time,MBCI_State_Dr) values(:Parref,:ChildSub,:User,:Date,:Time,:statedr))
  q:SQLCODE'=0 SQLCODE  
  
  q 0
}

//煎药更新

//w ##class(web.DHCST.DHCSTMBCCollDrug).DecSave("O15072100001",1056)

ClassMethod DecSave(Prescno As %String, User As %String)
{
  n (Prescno,User)
  q:Prescno="" -10 //处方号为空
  q:'$d(^OEORD(0,"PrescNo",Prescno)) -50  //先不存在
  q:'$d(^DHCPHDISPi("PRESCNO",Prescno))&&'$d(^DHCPHAC(0,"Prescno",Prescno)) -60  //再未发药
  s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno) 
  s jycook=$p(retstr,"^",7) //煎药方式
  s facotor=$p(retstr,"^",2) //剂数
  s Phdr=$o(^DHCPHDISPi("PRESCNO",Prescno,""))
  i Phdr'="" d
  .s type="O"  //状态类型
  .s Papmi=$p(^DHCPHDISP(Phdr),"^",7)
  .s Phdi=$o(^DHCPHDI(Phdr,"PHDI",""))
  .s orditm=$p(^DHCPHDI(Phdr,"PHDI",Phdi),"^",5)
  .s ord=$p(orditm,"||",1)
  .s itm=$p(orditm,"||",2)
  .s AdmId=+$P(^OEORD(ord),"^",1) //adm号
  .s fyrowid=Phdr   //发药id
  .s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7)  //医嘱日期
  .s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
  .s deplocdr=$p(^PAADM(AdmId),"^",4) //患者就诊科室
  e  d
  .s PhaId=$o(^DHCPHAC(0,"Prescno",Prescno,""))
  .s PhaItmId=$o(^DHCPHAC(0,"Prescno",Prescno,PhaId,""))
  .i PhaId'="" d
  ..s type="I"   //状态类型
  ..s AdmId=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",3)  //adm号
  ..s fyrowid=PhaId   //发药id
  ..s orditm=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",7)  //
  ..s ord=$p(orditm,"||",1)
  ..s itm=$p(orditm,"||",2)
  ..s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7) //医嘱日期
  ..s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
  ..s WardId=$p(^DHCPHAC(PhaId),"^",4)  //患者病区
  ..s deplocdr=$p(^PAWARD(WardId),"^",5)  	;病区对应的CT_Loc记录
  s mbcrowid=$o(^DHCMBC(0,"PRESCNO",Prescno,""))
  q:mbcrowid="" -30 //未收药
  s stateold=$p(^DHCMBC(mbcrowid),"^",5)
  s statedescold=$p(^DHCMBCS(stateold),"^",1)
  s nextmbcstr=..GetNextStat(stateold,type) //下一状态
  s nextmb=$p(nextmbcstr,"^",2)
  s nextmbrowid=$p(nextmbcstr,"^",1)
  s nextmbdesc=$p($g(^DHCMBCS(nextmbrowid)),"^",2)
  q:nextmb'=30 -40_"^"_nextmbdesc //下一状态不是煎药状态
  //q:statedescold'=10 -40 //非收药状态
  s state="30" //煎药状态number
  s statedr=$O(^DHCMBCS(0,"TYPENUMBER",type,state,""))
  &sql(update DHCST_MBCCollDrug set MBC_State_Dr=:statedr where MBC_RowId=:mbcrowid)
  s Parref=mbcrowid
  s ChildSub=$o(^DHCMBC(mbcrowid,"I",""),-1)+1
  s Date=+$h
  s Time=$p($h,",",2)
  &sql(insert into DHCST_MBCCollDrugItem(MBCI_Parref,MBCI_ChildSub,MBCI_DateUser_Dr,MBCI_Date,MBCI_Time,MBCI_State_Dr) values(:Parref,:ChildSub,:User,:Date,:Time,:statedr))
  q:SQLCODE'=0 SQLCODE   
  q 0
}

//煎药完成更新

//w ##class(web.DHCST.DHCSTMBCCollDrug).DecSaveCom("O14021201553",1771)

ClassMethod DecSaveCom(Prescno As %String, User As %String)
{
  n (Prescno,User)
  q:Prescno="" -10 //处方号为空
  q:'$d(^OEORD(0,"PrescNo",Prescno)) -50  //先不存在
  q:'$d(^DHCPHDISPi("PRESCNO",Prescno))&&'$d(^DHCPHAC(0,"Prescno",Prescno)) -60  //再未发药  
  s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno)
  s jycook=$p(retstr,"^",7) //煎药方式
  //q:jycook'["代" -20 //非代煎处方
  
  s facotor=$p(retstr,"^",2) //剂数
  s Phdr=$o(^DHCPHDISPi("PRESCNO",Prescno,""))
  i Phdr'="" d
  .s type="O"  //状态类型
  .s Papmi=$p(^DHCPHDISP(Phdr),"^",7)
  .s Phdi=$o(^DHCPHDI(Phdr,"PHDI",""))
  .s orditm=$p(^DHCPHDI(Phdr,"PHDI",Phdi),"^",5)
  .s ord=$p(orditm,"||",1)
  .s itm=$p(orditm,"||",2)
  .s AdmId=+$P(^OEORD(ord),"^",1) //adm号
  .s fyrowid=Phdr   //发药id
  .s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7)  //医嘱日期
  .s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
  .s deplocdr=$p(^PAADM(AdmId),"^",4) //患者就诊科室
  e  d
  .s PhaId=$o(^DHCPHAC(0,"Prescno",Prescno,""))
  .s PhaItmId=$o(^DHCPHAC(0,"Prescno",Prescno,PhaId,""))
  .i PhaId'="" d
  ..s type="I"   //状态类型
  ..s AdmId=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",3)  //adm号
  ..s fyrowid=PhaId   //发药id
  ..s orditm=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",7)  //
  ..s ord=$p(orditm,"||",1)
  ..s itm=$p(orditm,"||",2)
  ..s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7) //医嘱日期
  ..s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
  ..s WardId=$p(^DHCPHAC(PhaId),"^",4)  //患者病区
  ..s deplocdr=$p(^PAWARD(WardId),"^",5)  	;病区对应的CT_Loc记录
  s mbcrowid=$o(^DHCMBC(0,"PRESCNO",Prescno,""))
  q:mbcrowid="" -30 //未收药
  s stateold=$p(^DHCMBC(mbcrowid),"^",5)
  s statedescold=$p(^DHCMBCS(stateold),"^",1)
  s nextmbcstr=..GetNextStat(stateold,type) //下一状态
  s nextmb=$p(nextmbcstr,"^",2)
  q:nextmb'=50 -40 //下一状态不是煎药完成
  //q:statedescold'=40 -40 //非煎药登记打印状态
  s state="50" //煎药完成状态number
  s statedr=$O(^DHCMBCS(0,"TYPENUMBER",type,state,""))
  &sql(update DHCST_MBCCollDrug set MBC_State_Dr=:statedr where MBC_RowId=:mbcrowid)
  s Parref=mbcrowid
  s ChildSub=$o(^DHCMBC(mbcrowid,"I",""),-1)+1
  s Date=+$h
  s Time=$p($h,",",2)
  &sql(insert into DHCST_MBCCollDrugItem(MBCI_Parref,MBCI_ChildSub,MBCI_DateUser_Dr,MBCI_Date,MBCI_Time,MBCI_State_Dr) values(:Parref,:ChildSub,:User,:Date,:Time,:statedr))
  q:SQLCODE'=0 SQLCODE  
  
  q 0
}

//门诊接收

//w ##class(web.DHCST.DHCSTMBCCollDrug).InPhaSave("O14112700004",590)

ClassMethod InPhaSave(Prescno As %String, User As %String)
{
  n (Prescno,User)
  q:Prescno="" -10 //处方号为空
  q:'$d(^OEORD(0,"PrescNo",Prescno)) -50  //先不存在
  q:'$d(^DHCPHDISPi("PRESCNO",Prescno))&&'$d(^DHCPHAC(0,"Prescno",Prescno)) -60  //再未发药
  s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno)
  
  s jycook=$p(retstr,"^",7) //煎药方式
  //q:jycook'["代" -20 //非代煎处方
  
  s facotor=$p(retstr,"^",2) //剂数
  s Phdr=$o(^DHCPHDISPi("PRESCNO",Prescno,""))
  i Phdr'="" d
  .s type="O"  //状态类型
  .s Papmi=$p(^DHCPHDISP(Phdr),"^",7)
  .s Phdi=$o(^DHCPHDI(Phdr,"PHDI",""))
  .s orditm=$p(^DHCPHDI(Phdr,"PHDI",Phdi),"^",5)
  .s ord=$p(orditm,"||",1)
  .s itm=$p(orditm,"||",2)
  .s AdmId=+$P(^OEORD(ord),"^",1) //adm号
  .s fyrowid=Phdr   //发药id
  .s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7)  //医嘱日期
  .s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
  .s deplocdr=$p(^PAADM(AdmId),"^",4) //患者就诊科室
  e  d
  .s PhaId=$o(^DHCPHAC(0,"Prescno",Prescno,""))
  .s PhaItmId=$o(^DHCPHAC(0,"Prescno",Prescno,PhaId,""))
  .i PhaId'="" d
  ..s type="I"   //状态类型
  ..s AdmId=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",3)  //adm号
  ..s fyrowid=PhaId   //发药id
  ..s orditm=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",7)  //
  ..s ord=$p(orditm,"||",1)
  ..s itm=$p(orditm,"||",2)
  ..s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7) //医嘱日期
  ..s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
  ..s WardId=$p(^DHCPHAC(PhaId),"^",4)  //患者病区
  ..s deplocdr=$p(^PAWARD(WardId),"^",5)  	;病区对应的CT_Loc记录
  s mbcrowid=$o(^DHCMBC(0,"PRESCNO",Prescno,""))
  q:mbcrowid="" -30 //未收药
  s stateold=$p(^DHCMBC(mbcrowid),"^",5)
  s statedescold=$p(^DHCMBCS(stateold),"^",1)
  s nextmbcstr=..GetNextStat(stateold,type) //下一状态
  s nextmb=$p(nextmbcstr,"^",2)
  b //55
  q:nextmb'=60 -40 //下一状态不是门诊接收
  //q:statedescold'=50 -40 
  s state="60" //门诊接收状态number
  s statedr=$O(^DHCMBCS(0,"TYPENUMBER",type,state,""))
  &sql(update DHCST_MBCCollDrug set MBC_State_Dr=:statedr where MBC_RowId=:mbcrowid)
  s Parref=mbcrowid
  s ChildSub=$o(^DHCMBC(mbcrowid,"I",""),-1)+1
  s Date=+$h
  s Time=$p($h,",",2)
  &sql(insert into DHCST_MBCCollDrugItem(MBCI_Parref,MBCI_ChildSub,MBCI_DateUser_Dr,MBCI_Date,MBCI_Time,MBCI_State_Dr) values(:Parref,:ChildSub,:User,:Date,:Time,:statedr))
  q:SQLCODE'=0 SQLCODE  
  
  q 0
}

//门诊发放

ClassMethod OutPhaSave(Prescno, User)
{
  n (Prescno,User)
  q:Prescno="" -10 //处方号为空
  q:'$d(^OEORD(0,"PrescNo",Prescno)) -50  //先不存在
  q:'$d(^DHCPHDISPi("PRESCNO",Prescno))&&'$d(^DHCPHAC(0,"Prescno",Prescno)) -60  //再未发药
  s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno)
  
  s jycook=$p(retstr,"^",7) //煎药方式
  //q:jycook'["代" -20 //非代煎处方
  
  s facotor=$p(retstr,"^",2) //剂数
  s Phdr=$o(^DHCPHDISPi("PRESCNO",Prescno,""))
  i Phdr'="" d
  .s type="O"  //状态类型
  .s Papmi=$p(^DHCPHDISP(Phdr),"^",7)
  .s Phdi=$o(^DHCPHDI(Phdr,"PHDI",""))
  .s orditm=$p(^DHCPHDI(Phdr,"PHDI",Phdi),"^",5)
  .s ord=$p(orditm,"||",1)
  .s itm=$p(orditm,"||",2)
  .s AdmId=+$P(^OEORD(ord),"^",1) //adm号
  .s fyrowid=Phdr   //发药id
  .s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7)  //医嘱日期
  .s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
  .s deplocdr=$p(^PAADM(AdmId),"^",4) //患者就诊科室
  e  d
  .s PhaId=$o(^DHCPHAC(0,"Prescno",Prescno,""))
  .s PhaItmId=$o(^DHCPHAC(0,"Prescno",Prescno,PhaId,""))
  .i PhaId'="" d
  ..s type="I"   //状态类型
  ..s AdmId=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",3)  //adm号
  ..s fyrowid=PhaId   //发药id
  ..s orditm=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",7)  //
  ..s ord=$p(orditm,"||",1)
  ..s itm=$p(orditm,"||",2)
  ..s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7) //医嘱日期
  ..s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
  ..s WardId=$p(^DHCPHAC(PhaId),"^",4)  //患者病区
  ..s deplocdr=$p(^PAWARD(WardId),"^",5)  	;病区对应的CT_Loc记录
  s mbcrowid=$o(^DHCMBC(0,"PRESCNO",Prescno,""))
  q:mbcrowid="" -30 //未收药
  s stateold=$p(^DHCMBC(mbcrowid),"^",5)
  s statedescold=$p(^DHCMBCS(stateold),"^",1)
  s nextmbcstr=..GetNextStat(stateold,type) //下一状态
  s nextmb=$p(nextmbcstr,"^",2)
  s nextmbrowid=$p(nextmbcstr,"^",1)
  s nextmbdesc=$p($g(^DHCMBCS(nextmbrowid)),"^",2)
  q:nextmb'=70 -40_"^"_nextmbdesc //下一状态不是煎药状态
  //q:statedescold'=50 -40 
  s state="70" //门诊发放状态number
  s statedr=$O(^DHCMBCS(0,"TYPENUMBER",type,state,""))
  &sql(update DHCST_MBCCollDrug set MBC_State_Dr=:statedr where MBC_RowId=:mbcrowid)
  s Parref=mbcrowid
  s ChildSub=$o(^DHCMBC(mbcrowid,"I",""),-1)+1
  s Date=+$h
  s Time=$p($h,",",2)
  &sql(insert into DHCST_MBCCollDrugItem(MBCI_Parref,MBCI_ChildSub,MBCI_DateUser_Dr,MBCI_Date,MBCI_Time,MBCI_State_Dr) values(:Parref,:ChildSub,:User,:Date,:Time,:statedr))
  q:SQLCODE'=0 SQLCODE  
  
  q 0
}

/// Description:构造树形结构
/// Creator:wyx
/// w ##class(web.DHCST.DHCSTMBCCollDrug).GetCatTreeData("0","0",10,1771)
ClassMethod GetCatTreeData(catdr, level, Number, UserI) As %String
{
	;s ^tmpcatdr=catdr_"^"_level
	//s Number=10 //收药状态
	s currlevel=level+1
	s pid=..NewPid()
	w "["
	s mbcid=""
	s Stateid=""
	f  s Stateid=$o(^DHCMBCS(0,"NUMBER",Number,Stateid)) q:Stateid=""  d
	.s locdr=""
	.f  s locdr=$o(^DHCMBC(0,"STATELOC",Stateid,locdr)) q:locdr=""  d
	..s leafflag="true"
	..s Locdesc=$p(^CTLOC(locdr),"^",2)
	..s mbcid=""
	..f  s mbcid=$o(^DHCMBC(0,"STATELOC",Stateid,locdr,mbcid)) q:mbcid=""  d
	...s prescno=$p(^DHCMBC(mbcid),"^",1)
	...q:'$d(^OEORD(0,"PrescNo",prescno))
	...s mbcsub=$o(^DHCMBC(0,"ITMSTATE",Stateid,mbcid,""))
	...s User=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1)
	...q:(UserI'="")&(UserI'=User)
	...s expandflag="true"
	...s checkflag="false"
	...q:$d(^TMPDHCSTMBCREC(pid,locdr))
	...s ^TMPDHCSTMBCREC(pid,locdr)=""
	...w "{"_"id:'"_locdr_"',text:'"_Locdesc_"',leaf:"_leafflag_",level:'"_currlevel_"',expanded:"_expandflag_"}"
	...w ","
	k ^TMPDHCSTMBCREC(pid)
	q "]"
}

/// w ##class(web.DHCST.DHCSTMBCCollDrug).GetChild(27,10,1056)
ClassMethod GetChild(locIdInput, Number, UserI) As %String
{
	Set json = ##class(Code.JsonObj).%New()
	q:locIdInput="" ""
	s num=0
	s Stateid=""
	i locIdInput=0 d
	.f  s Stateid=$o(^DHCMBCS(0,"NUMBER",Number,Stateid)) q:Stateid=""  d
	..s locdr=""
	..f  s locdr=$o(^DHCMBC(0,"STATELOC",Stateid,locdr)) q:locdr=""  d
	...s mbcid=""
	...f  s mbcid=$o(^DHCMBC(0,"STATELOC",Stateid,locdr,mbcid)) q:mbcid=""  d
	....s Locdesc=$p(^CTLOC(locdr),"^",2)
	....s Adm=$p(^DHCMBC(mbcid),"^",2)
	....q:Adm=""
	....S PatientID=$P($G(^PAADM(Adm)),"^",1)
	....q:PatientID=""
    ....s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	....s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //患者姓名
	....s Prescno=$p(^DHCMBC(mbcid),"^",1)
	....q:'$d(^OEORD(0,"PrescNo",Prescno))  
	....s Stateid=$p(^DHCMBC(mbcid),"^",5)
	....s Statedesc=$p(^DHCMBCS(Stateid),"^",2)
	....s mbcsub=$o(^DHCMBC(0,"ITMSTATE",Stateid,mbcid,""))
	....s User=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1)
	....q:(UserI'="")&(UserI'=User)
	....s data=mbcid_"^"_Locdesc_"^"_PatNo_"^"_PatName_"^"_Prescno_"^"_Statedesc
	....s num=num+1
	....d json.InsertRowData(data)
	e  d
	.f  s Stateid=$o(^DHCMBCS(0,"NUMBER",Number,Stateid)) q:Stateid=""  d
	..s mbcid=""
	..f  s mbcid=$o(^DHCMBC(0,"STATELOC",Stateid,locIdInput,mbcid)) q:mbcid=""  d
	...s Locdesc=$p(^CTLOC(locIdInput),"^",2)
	...s Adm=$p(^DHCMBC(mbcid),"^",2)
	...S PatientID=$P($G(^PAADM(Adm)),"^",1)
	...q:PatientID=""
    ...s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	...s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //患者姓名
	...s Prescno=$p(^DHCMBC(mbcid),"^",1)
	...q:'$d(^OEORD(0,"PrescNo",Prescno))  
	...s Stateid=$p(^DHCMBC(mbcid),"^",5)
	...s Statedesc=$p(^DHCMBCS(Stateid),"^",2)
	...s mbcsub=$o(^DHCMBC(0,"ITMSTATE",Stateid,mbcid,""))
	...s User=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1)
	...q:(UserI'="")&(UserI'=User)
	...s data=mbcid_"^"_Locdesc_"^"_PatNo_"^"_PatName_"^"_Prescno_"^"_Statedesc
	...s num=num+1
	...d json.InsertRowData(data)
	
	s DetailInfo=json.getJsonData("MBCId^PatLoc^PatNo^PatName^Prescno^State",num)
	k json
	q DetailInfo
}

/// 门诊发放数据查询
/// w ##class(web.DHCST.DHCSTMBCCollDrug).GetOutPhaPresc(0,10,1771)
ClassMethod GetOutPhaPresc(Prescno, Number, UserI) As %String
{
	
	Set json = ##class(Code.JsonObj).%New()
	q:Prescno="" ""
	s num=0
	s Stateid=""
	s mbcid=$o(^DHCMBC(0,"PRESCNO",Prescno,""))
	q:mbcid="" ""
	s locdr=$p(^DHCMBC(mbcid),"^",9)
	s Locdesc=$p(^CTLOC(locdr),"^",2)
	s Adm=$p(^DHCMBC(mbcid),"^",2)
	S PatientID=$P($G(^PAADM(Adm)),"^",1)
	q:PatientID="" ""
    s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //患者姓名
	s Prescno=$p(^DHCMBC(mbcid),"^",1)
	s Stateid=$p(^DHCMBC(mbcid),"^",5)
	s Statedesc=$p(^DHCMBCS(Stateid),"^",2)
	s mbcsub=$o(^DHCMBC(0,"ITMSTATE",Stateid,mbcid,""))
	s User=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1)
	q:(UserI'="")&(UserI'=User)
	s data=mbcid_"^"_Locdesc_"^"_PatNo_"^"_PatName_"^"_Prescno_"^"_Statedesc
	s num=num+1
	d json.InsertRowData(data)
	
	s DetailInfo=json.getJsonData("MBCId^PatLoc^PatNo^PatName^Prescno^State",num)
	k json
	q DetailInfo
}

/// 门诊发放数据明细查询
/// w ##class(web.DHCST.DHCSTMBCCollDrug).GetOutPhaPrescDetail("O15072000012")
ClassMethod GetOutPhaPrescDetail(Prescno) As %String
{
	
	Set json = ##class(Code.JsonObj).%New()
	q:Prescno="" ""
	s num=0
	s mbcid=$o(^DHCMBC(0,"PRESCNO",Prescno,""))
	q:mbcid="" ""
    s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno)
    s jycook=$p(retstr,"^",7) //煎药方式
   s facotor=$p(retstr,"^",2) //剂数
   s phdrow=$o(^DHCPHDISPi("PRESCNO",Prescno,""))
   i phdrow'="" d
   .s type="O"  //状态类型
   .s Papmi=$p(^DHCPHDISP(phdrow),"^",7)
   .s phdi=""
   .f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:phdi=""  d
   ..s qty=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",4 )
   ..s oeori=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
   ..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,"")) 
   ..s qty=$p(^DHCOEDISQTY(dsp),"^",2)
   ..s ord=+oeori
   ..s itm=$p(oeori,"||",2)
   ..s freq="",freq2=""
   ..s freqdr=+$p(^OEORD(ord,"I",itm,2),"^",4)
   ..i freqdr'=0 d
   ...i $d(^PHCFR(freqdr)) d
   ....s freq=$p(^PHCFR(freqdr),"^",1)  ;用药频率
   ....s freq2=$p(^PHCFR(freqdr),"^",2)  ;用药频率
   ..s inst="",inst2=""
   ..s instdr=+$p(^OEORD(ord,"I",itm,2),"^",7)
   ..i instdr'=0 d
   ...i $d(^PHCIN(instdr)) d
   ....s inst=$p(^PHCIN(instdr),"^",2)  ;用法 
   ....s inst2=$p(^PHCIN($p(^OEORD(ord,"I",itm,2),"^",7)),"^",3)  ;用法 
   ..s phdur=""
   ..s phdudr=+$p(^OEORD(ord,"I",itm,2),"^",6)
   ..i phdudr'=0 d
   ...i $d(^PHCDU(phdudr)) d
   ....s phdur=$p(^PHCDU(phdudr),"^",1) ;用药疗程
   ..s dosage=$p(^OEORD(ord,"I",itm,2),"^",1) ;用药剂量
   ..s dosageuomdr=$p(^OEORD(ord,"I",itm,2),"^",3)
   ..s dosageuom=""
   ..s:dosageuomdr'="" dosageuom=$p(^CT("UOM",dosageuomdr),"^",2)   ;剂量单位 
   ..s totalprice=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",3)
   ..s price=totalprice/qty
   ..s price=$fn(price,"",4)
   ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) 
   ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""
   ..s incidsec=$p(^INCI(inci,1),"^",2)
   ..s incicode=$p(^INCI(inci,1),"^",1)
   ..s unit=""
   ..;add by lq
   ..s basuomdr=+$p(^INCI(inci,1),"^",10)
   ..s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
   ..i dispuomdr'="" d
   ...s confac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,basuomdr)
   ...s qty=qty/confac
   ...s unit=$p($g(^CT("UOM",dispuomdr)),"^",2)
   ..e  d
   ...s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(inci,qty)
   ...s qty=$p(qtyinfo,"^",1)
   ...s unit=$p(qtyinfo,"^",2)
   ..s skintest=""
   ..s skinflag=##class(web.DHCOutPhCommon).SkinTest(ord_"||"_itm)
   ..i (skinflag'<0)&(skinflag'="") s skintest="(-)"
   ..i skinflag=-1 s skintest="(+)"
   ..i skinflag=-6 s skintest="( )"
   ..s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(ord_"||"_itm)
   ..//s tmpsting=incidsec_skinflag_"^"_qty_"^"_unit_"^"_dosage_""_dosageuom_"^"_inst_"^"_freq_"^"_phdur_"^"_price_"^"_totalprice_"^"_skintest_"^"_ordremark
   ..s data=incicode_"^"_incidsec_"^"_qty_"^"_unit
   ..s num=num+1
   ..d json.InsertRowData(data)
	s DetailInfo=json.getJsonData("DrugCode^DrugDesc^DrugQty^DrugUom",num)
	k json
	q DetailInfo
}

//门诊煎药类别转换

//w ##class(web.DHCST.DHCSTMBCCollDrug).TransTypePresc("O14112700004")

ClassMethod TransTypePresc(Prescno, UserId)
{
  q:..CheckIfZCY(Prescno)=0 -10 //非中草药处方
  s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno)
  s jycook=$p(retstr,"^",7) //煎药方式
  q:jycook'["自" -20 //非自煎处方
  //s ret=..InsertJYBillOrder(Prescno,UserId)
  //q:ret'=0 -30
  s queid=$o(^PAQUE1(0,"PrescNo",Prescno,""))
  q:'$d(^PAQUE1(queid,"DHC")) 0 ;过滤非中草药
  s $p(^PAQUE1(queid,"DHC"),"^",15)="代煎" ;方式
  q 0
}

//门诊煎药类别转换数据查询

//w ##class(web.DHCST.DHCSTMBCCollDrug).GetTransTypePresc("O15072100014")

ClassMethod GetTransTypePresc(Prescno)
{
   Set json = ##class(Code.JsonObj).%New()
   s phard="" 
   s num=0
   s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno)
   s jycook=$p(retstr,"^",7) //煎药方式
   s patadm=##class(web.DHCOutPhDisp).getadm(Prescno)
   s patloc=+$p(^PAADM(patadm),"^",4)
   s Locdesc=$p(^CTLOC(patloc),"^",2)
   f  s phard=$o(^DHCPHARi("PRESCNO",Prescno,phard)) q:phard=""  d
   .s prt=$p(^DHCPHARW(phard),"^",1)
   .q:prt=""
   .q:'$d(^DHCINVPRT(prt))
   .s papmi=$p(^DHCINVPRT(prt),"^",15)
   .s PatNo=$p(^PAPER(papmi,"PAT",1),"^",2)
   .s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
   .s data=Locdesc_"^"_PatNo_"^"_PatName_"^"_Prescno_"^"_jycook
   .s num=num+1
   .d json.InsertRowData(data)
	s DetailInfo=json.getJsonData("PatLoc^PatNo^PatName^Prescno^jycook",num)
	k json
	q DetailInfo
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("DHCSTMBCCollDrug"))
}

//收药/煎药打印更新

//0^1056^10^2015-11-10^10:51:18

//w ##class(web.DHCST.DHCSTMBCCollDrug).PrintUpdate(0,1056,10,"2015-11-10","10:51:18")

ClassMethod PrintUpdate(locIdInput, UserI, Number, Pdate, Ptime) As %String
{
    n (locIdInput, UserI, Number,Pdate,Ptime)
    s Stateid="",error=0
    s Pdate=$zdh(Pdate,3)
    s Ptime=$zth(Ptime)
    s PrintDate=Pdate
    s PrintTime=Ptime
    i locIdInput=0 d
	.f  s Stateid=$o(^DHCMBCS(0,"NUMBER",Number,Stateid)) q:Stateid=""  d
	..s locdr=""
	..f  s locdr=$o(^DHCMBC(0,"STATELOC",Stateid,locdr)) q:locdr=""  d
	...s mbcid=""
	...f  s mbcid=$o(^DHCMBC(0,"STATELOC",Stateid,locdr,mbcid)) q:mbcid=""  d
	....s Locdesc=$p(^CTLOC(locdr),"^",2)
	....s Adm=$p(^DHCMBC(mbcid),"^",2)
	....S PatientID=$P($G(^PAADM(Adm)),"^",1)
	....q:PatientID=""
	....q:'$d(^PAPER(PatientID))
    ....s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	....s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //患者姓名
	....s Prescno=$p(^DHCMBC(mbcid),"^",1)
	....s Stateid=$p(^DHCMBC(mbcid),"^",5)
	....s Statedesc=$p(^DHCMBCS(Stateid),"^",2)
	....s type=$p(^DHCMBC(mbcid),"^",8)
	....s nextmbcstr=..GetNextStat(Stateid,type)
	....s nextmbsdr=$p(nextmbcstr,"^",1)
	....s mbcsub=$o(^DHCMBC(0,"ITMSTATE",Stateid,mbcid,""),-1)
	....s User=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1)
	....q:(UserI'="")&(UserI'=User)
	....tstart
	....&sql(update DHCST_MBCCollDrug set MBC_State_Dr=:nextmbsdr where MBC_RowId=:mbcid)
	....i SQLCODE'=0 s error=1
	....i SQLCODE'=0 trollback
	....q:error'=0
	....s Parref=mbcid
    ....s ChildSub=mbcsub+1
    ....s Date=+$h
    ....s Time=$p($h,",",2)
	....&sql(insert into DHCST_MBCCollDrugItem(MBCI_Parref,MBCI_ChildSub,MBCI_DateUser_Dr,MBCI_Date,MBCI_Time,MBCI_State_Dr,MBCI_PrintDate,MBCI_PrintTime) values(:Parref,:ChildSub,:User,:Date,:Time,:nextmbsdr,:PrintDate,:PrintTime))
    ....i SQLCODE'=0 s error=1
	....i error'=0 trollback
	....q:error'=0
	....tcommit
	e  d
	.f  s Stateid=$o(^DHCMBCS(0,"NUMBER",Number,Stateid)) q:Stateid=""  d
	..s mbcid=""
	..f  s mbcid=$o(^DHCMBC(0,"STATELOC",Stateid,locIdInput,mbcid)) q:(mbcid="")||(error'=0)  d
	...s Locdesc=$p(^CTLOC(locIdInput),"^",2)
	...s Adm=$p(^DHCMBC(mbcid),"^",2)
	...S PatientID=$P($G(^PAADM(Adm)),"^",1)
	...q:PatientID=""
	...q:'$d(^PAPER(PatientID))
    ...s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	...s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //患者姓名
	...s Prescno=$p(^DHCMBC(mbcid),"^",1)
	...s Stateid=$p(^DHCMBC(mbcid),"^",5)
	...s Statedesc=$p(^DHCMBCS(Stateid),"^",2)
	...s type=$p(^DHCMBC(mbcid),"^",8)
	...s nextmbcstr=..GetNextStat(Stateid,type)
	...s nextmbsdr=$p(nextmbcstr,"^",1)
	...s mbcsub=$o(^DHCMBC(0,"ITMSTATE",Stateid,mbcid,""),-1)
	...s User=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1)
	...q:(UserI'="")&(UserI'=User)
	...tstart
	...&sql(update DHCST_MBCCollDrug set MBC_State_Dr=:nextmbsdr where MBC_RowId=:mbcid)
	...i SQLCODE'=0 s error=1
	...i SQLCODE'=0 trollback
	...q:error'=0
	...s Parref=mbcid
       ...s ChildSub=mbcsub+1
       ...s Date=+$h
       ...s Time=$p($h,",",2)
	...&sql(insert into DHCST_MBCCollDrugItem(MBCI_Parref,MBCI_ChildSub,MBCI_DateUser_Dr,MBCI_Date,MBCI_Time,MBCI_State_Dr,MBCI_PrintDate,MBCI_PrintTime) values(:Parref,:ChildSub,:User,:Date,:Time,:nextmbsdr,:PrintDate,:PrintTime))
       ...i SQLCODE'=0 s error=1
	...i error'=0 trollback
	...q:error'=0
	...tcommit
	...
       q:error'=0 error
       q 0
}

/// 检索煎药室综合查询用
/// w ##class(web.DHCST.DHCSTMBCCollDrug).jsDHCSTMBCCOllDrug
ClassMethod jsDHCSTMBCCOllDrug(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
 n (StrParam,Start,Limit,Sort,Dir)
 s qPar=Sort_"^"_Dir
 q:StrParam="" ""
 s StartDate=$p(StrParam,"&",1)
 s StartTime=$p(StrParam,"&",2) 
 s EndDate=$p(StrParam,"&",3) 
 s EndTime=$p(StrParam,"&",4)
 s AUser=$p(StrParam,"&",5) //操作人
 s PatLoc=$p(StrParam,"&",6) //科室
 s Prescno=$p(StrParam,"&",7) //处方号
 s State=$p(StrParam,"&",8) //状态串以"^"分割
 ;
 i StartTime[":" s StartTime=$zth(StartTime)
 i EndTime[":" s EndTime=$zth(EndTime)
 q:StartDate="" ""
 q:EndDate="" ""
 s StartDate=$zdh(StartDate,3)
 s EndDate=$zdh(EndDate,3)
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCSTMBCCollDrug:GetMBCCOllDrug")
 s sc= result.Execute(qPar,StartDate,StartTime,EndDate,EndTime,AUser,PatLoc,Prescno,State,"")
 
 i $$$ISERR(sc) q ""
 s colNum=result.GetColumnCount()
 s end = Start+Limit
 	i $$$ISERR(sc) q ""
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s pid=..NewPid()
	Set $ZT="ERRORjsDHCSTMBCCOllDrug"	
	s h=0
	While(result.Next())
	{ 
	    s data=""
	    f i=1:1:colNum d
  		.i data="" s data=result.%GetData(i)
		.e   s data=data_"^"_result.%GetData(i)

	    s h=h+1
	    s index=h  //排序
	    s ^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrug",pid,"index",index)=data 
	 }
      s maxrow=h
	i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    s counSpAmtSum=0,freSpAmtSum=0,adjSpAmtSum=0
    f  s h=$o(^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrug",pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrug",pid,"index",h)
    .s MBCId=$p(data,"^",1)
    .s PatLoc=$p(data,"^",2)
    .s PatNo=$p(data,"^",3)
    .s PatName=$p(data,"^",4)
    .s Prescno=$p(data,"^",5)
    .s State=$p(data,"^",6)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage 

    .s MBCId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("MBCId",MBCId)    
       .s PatLoc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatLoc",PatLoc)
       .s PatNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatNo",PatNo)
       .s PatName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatName",PatName)
	.s Prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Prescno",Prescno)
      .s State=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("State",State)
      .
      .s tmpstr=MBCId_PatLoc_PatNo_PatName_Prescno_State
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	k ^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrug",pid) 
     
    q ""
 
 
 
ERRORjsDHCSTMBCCOllDrug
    //遇报错,则先kill TMP
    Set Method="##class(web.DHCST.DHCSTMBCCollDrug),jsDHCSTMBCCOllDrug"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrPar_")"_","_$ZE
	k ^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrug",pid)    
    q ""
}

/// 煎药综合查询使用
/// Author:wyx
/// Date:2014-09-17
/// Argu:
///   qPar  -查询参数(排序列^排序方向)
///   inst -
///   ManGrp -
/// Return:
Query GetMBCCOllDrug(qPar As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, AUser As %String, PatLoc As %String, Prescno As %String, State As %String, Type As %String) As %Query(ROWSPEC = "mbcid:%String,PatLoc:%String,PatNo:%String,PatName:%String,Prescno:%String,Statedesc:%String")
{
}

//d ##class(%ResultSet).RunQuery("web.DHCST.DHCSTMBCCollDrug","GetMBCCOllDrug","Rowid^ASC")

ClassMethod GetMBCCOllDrugExecute(ByRef qHandle As %Binary, qPar As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, AUser As %String, PatLoc As %String, Prescno As %String, State As %String, Type As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    s Sort=$p(qPar,"^",1)
    s Dir=$p(qPar,"^",2)
    i StartDate["-" s StartDate=$zdh(StartDate,3)
    i EndDate["-" s EndDate=$zdh(EndDate,3)
    i StartDate["/" s StartDate=$zdh(StartDate,4)
    i EndDate["/" s EndDate=$zdh(EndDate,4)
    f date=StartDate:1:EndDate d
    .s mbcid=""
    .f  s mbcid=$o(^DHCMBC(0,"ITMDATE",date,mbcid)) q:mbcid=""  d 
    ..s mbcsub=$o(^DHCMBC(0,"ITMDATE",date,mbcid,""),-1) d 
    ..s User=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1) 
    ..s Time=$p(^DHCMBC(mbcid,"I",mbcsub),"^",3)
    ..s Statdr=$p(^DHCMBC(mbcid,"I",mbcsub),"^",4)
    ..q:(date=StartDate)&(StartTime>Time)&(StartTime'="")
    ..q:(date=EndDate)&(EndTime<Time)&(EndTime'="")
    ..q:(AUser'="")&(AUser'=User)
    ..s ret=0
    ..i State'="" s ret=..CheckState(State,Statdr)
    ..q:(ret=0)&(State'="")
    ..s Adm=$p(^DHCMBC(mbcid),"^",2)
    ..S PatientID=$P($G(^PAADM(Adm)),"^",1)
    ..q:PatientID=""
    ..s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
    ..s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //患者姓名
    ..s PrescnoM=$p(^DHCMBC(mbcid),"^",1)
    ..q:(Prescno'="")&(PrescnoM'=Prescno)
    ..s Stateid=$p(^DHCMBC(mbcid),"^",5)
    ..s Statedesc=$p(^DHCMBCS(Stateid),"^",2)
    ..s type=$p(^DHCMBC(mbcid),"^",8)
    ..b //1
    ..q:(Type'="")&(type'=Type)
    ..i type="O" s Statedesc=Statedesc_"(门诊)"
    ..e  s Statedesc=Statedesc_"(住院)" 
    ..s locdr=$p(^DHCMBC(mbcid),"^",9)
    ..q:(PatLoc'="")&&(PatLoc'=locdr)
    ..s Locdesc=$p(^CTLOC(locdr),"^",2)
    ..d OutPutRow
	
 Quit $$$OK
OutPutRow
 s Data=$lb(mbcid,Locdesc,PatNo,PatName,PrescnoM,Statedesc)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod GetMBCCOllDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMBCCOllDrugExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetMBCCOllDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMBCCOllDrugExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod CheckState(StateIn, Statdr)
{
  s cnt=$l(StateIn,"^")
  s ret=0
  f num=1:1:cnt q:ret>0  d
  .s instate=$p(StateIn,"^",num)
  .i Statdr=instate s ret=1
  .	
 q ret
}

/// 取处方的全部历史操作记录
/// Author:wyx
/// Date:2014-10-15
/// Arguments: 开始行,限制行,煎药主表id
/// Return: 信息串
/// w ##class(web.DHCST.DHCSTMBCCollDrug).jsGetAllPrescMBC(start,limit,MBCid)
ClassMethod jsGetAllPrescMBC(Start As %String, Limit As %String, mbcid As %String) As %String
{
 n (Start,Limit,mbcid)
 s endpage=Start+Limit  //结束行
 s stpage=Start+1 //开始行
 s h=0
 s pid=..NewPid()
 Set $ZT="ERRORjsGetAllPrescMBC"
 s h=0
 s mbcsub=""
 f  s mbcsub=$o(^DHCMBC(mbcid,"I",mbcsub)) q:mbcsub=""  d
 .s Adm=$p(^DHCMBC(mbcid),"^",2)
 .S PatientID=$P($G(^PAADM(Adm)),"^",1)
 .q:PatientID=""
 .s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
 .s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //患者姓名
 .s Prescno=$p(^DHCMBC(mbcid),"^",1)
 .s locdr=$p(^DHCMBC(mbcid),"^",9)
 .s PatLoc=$p(^CTLOC(locdr),"^",2)
 .s Stateid=$p(^DHCMBC(mbcid,"I",mbcsub),"^",4)
 .s Statedesc=$p(^DHCMBCS(Stateid),"^",2)
 .s type=$p(^DHCMBC(mbcid),"^",8)
 .i type="O" s Statedesc=Statedesc_"(门诊)"
 .e  s Statedesc=Statedesc_"(住院)"
 .s date=$p(^DHCMBC(mbcid,"I",mbcsub),"^",2)
 .s Userdr=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1)
 .s Userdesc=$p(^SSU("SSUSR",Userdr),"^",2)
 .s time=$p(^DHCMBC(mbcid,"I",mbcsub),"^",3)
 .s date=$zd(date,3)
 .s time=$zt(time)
 .s mbcitmid=mbcid_"||"_mbcsub
 .s data=mbcitmid_"^"_PatLoc_"^"_PatNo_"^"_PatName_"^"_Prescno_"^"_Statedesc_"^"_Userdesc_"^"_date_"^"_time
 .s h=h+1
 .s ^TMP("DHCST","DHCSTMBCCollDrug","jsGetAllPrescMBC",pid,"index",h)=data
 
 q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
 s maxrow=h
 i endpage>maxrow s endpage=maxrow
 s count=0
 s h=""
 f  s h=$o(^TMP("DHCST","DHCSTMBCCollDrug","jsGetAllPrescMBC",pid,"index",h)) q:h=""  d
 .s data=^TMP("DHCST","DHCSTMBCCollDrug","jsGetAllPrescMBC",pid,"index",h)
 .s MBCItmId=$p(data,"^",1)
 .s PatLoc=$p(data,"^",2)
 .s PatNo=$p(data,"^",3)
 .s PatName=$p(data,"^",4)
 .s Prescno=$p(data,"^",5)
 .s State=$p(data,"^",6)
 .s User=$p(data,"^",7)
 .s UDate=$p(data,"^",8)
 .s UTime=$p(data,"^",9)
 .s count=count+1
 .q:count<stpage
 .q:count>endpage
 .s MBCItmId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("MBCItmId",MBCItmId)
 .s PatLoc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatLoc",PatLoc)
 .s PatNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatNo",PatNo)
 .s PatName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatName",PatName)
 .s Prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Prescno",Prescno)
 .s State=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("State",State)
 .s User=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("User",User)
 .s UDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("UDate",UDate)
 .s UTime=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("UTime",UTime)
 .s tmpstr=MBCItmId_PatLoc_PatNo_PatName_Prescno_State_User_UDate_UTime
 .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
 .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
 .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
 .i count=stpage w startString
 .i count<endpage w firstrow
 .i count=endpage w lastrow
 k ^TMP("DHCST","DHCSTMBCCollDrug","jsGetAllPrescMBC",pid)
 q ""
 
ERRORjsGetAllPrescMBC
    //遇报错,则先kill TMP
    Set Method=	"##class(web.DHCST.DHCSTMBCCollDrug).jsGetAllPrescMBC"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_mbcid_")"_","_$ZE
	k ^TMP("DHCST","DHCSTMBCCollDrug","jsGetAllPrescMBC",pid)    
    q ErrorMsg
}

/// Descript:根据处方号获得处方类型
/// Creater:wyx 
/// CreateDate: 2014-10-21
/// Input:  处方号 
/// Output:     
/// Return：0 门诊，1 住院
ClassMethod GetPrescType(Prescno) As %String
{
    n (Prescno)
    s retstr=""
    q:Prescno="" "" //处方号为空
    s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno)
    s jycook=$p(retstr,"^",7) //煎药方式
    //q:jycook'["代" "" //非代煎处方
    s phdr=$o(^DHCPHDISPi("PRESCNO",Prescno,""))
    i phdr'="" s retstr=0_"^"_phdr
    s PhaId=$o(^DHCPHAC(0,"Prescno",Prescno,""))
    i PhaId'="" s retstr=1_"^"_PhaId
    q retstr
}

ClassMethod GetPrescOutInfo(Phdrowid)
{
	s PrescNo=$p(^DHCPHDISP(Phdrowid,2),"^",1)
	s phdphl=$p(^DHCPHDISP(Phdrowid,1),"^",1)
	s ret=##class(web.DHCOutPhPrint).GetPrtPrescInfo(PrescNo,phdphl)
	s queaddinfo=##class(web.DHCST.DHCSTMBCCollDrug).Getpaqueaddinfo(PrescNo) //lq 2008-03-05 取中草药处方信息	
    s dreat=$p(queaddinfo,"^",7) //是否当日服用
    s jzcnt=$p(queaddinfo,"^",3) ////煎煮次数
    s jztime=$p(queaddinfo,"^",4) //煎煮时间
    s qzfre=$p(queaddinfo,"^",5) //;取汁量
    s ret=$p(ret,"!!",1)_"^"_jzcnt_"^"_jztime_"^"_qzfre_"!!"_$p(ret,"!!",2)
	q ret
}

/// w ##class(web.DHCST.DHCSTMBCCollDrug).GetPrescInInfo("I15110400033")	
ClassMethod GetPrescInInfo(Prescno)
{
   q:Prescno="" ""
   q:'$d(^DHCPHAC(0,"Prescno",Prescno)) ""
   s PhaId=$o(^DHCPHAC(0,"Prescno",Prescno,""))
   s PhaItmId=$o(^DHCPHAC(0,"Prescno",Prescno,PhaId,""))
   s AdmId=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",3)  //adm号
   s WardId=$p(^DHCPHAC(PhaId),"^",4)  //患者病区
   s WardDesc=$p(^PAWARD(WardId),"^",2)
   s bed=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",8)
   S PAPMIID=$P($G(^PAADM(AdmId)),"^",1)
   //s PatName=$p($g(^PAPER(PAPMIID,"ALL")),"^",1) //患者姓名
   s MedNo=##Class(web.DHCWMRService).IGetMrTypeInfo(AdmId)
   s MedNo=$P(MedNo,"^",1)
   s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno)
   s fsqty=$p(retstr,"^",2) //付数
   s notes=$p(retstr,"^",6) //备注
   s queaddinfo=##class(web.DHCST.DHCSTMBCCollDrug).Getpaqueaddinfo(Prescno) //lq 2008-03-05 取中草药处方信息	
   s dreat=$p(queaddinfo,"^",7) //是否当日服用
   s jzcnt=$p(queaddinfo,"^",3) ////煎煮次数
   s jztime=$p(queaddinfo,"^",4) //煎煮时间
   s qzfre=$p(queaddinfo,"^",5) //;取汁量
   s oedis=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",7)
   s tmp=##class(web.DHCSTPCHCOLLPRN).getOrdItm(oedis)
   s instruction=$p(tmp,"^",6) //口服还是外用
   s tmp=##class(web.DHCSTPCHCOLLPRN).getPaNo(AdmId)
   s paname=$p(tmp,"^",2)
   s pasex=$p(tmp,"^",3)
   s ordsdate=$p(retstr,"^",4)
   s ordxdate=$p(retstr,"^",5)
   //s YyDate=ordsdate_"-"_ordxdate
   s YyDate="至"_ordxdate
   s ret=paname_"^"_fsqty_"^"_WardDesc_"^"_bed_"^"_MedNo_"^"_YyDate_"^"_dreat_"^"_instruction_"^"_notes_"^"_jzcnt_"^"_jztime_"^"_qzfre
   q ret
}

/// 检索煎药登记数据，打印使用
/// Author:wyx
/// Date:2014-09-17
/// Argu:
///   qPar  -查询参数(排序列^排序方向)
///   inst -
///   ManGrp -
/// Return:
Query GetMBCCOllDrugReg(StartDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, AUser As %String, Prescno As %String, locid As %String, State As %String) As %Query(ROWSPEC = "PatName:%String,PrescnoM,fsqty:%String,Instruc:%String,FDrug:%String,LDrug:%String,WrDrug:%String,emergency:%String,Uway:%String,notes:%String") [ SqlProc ]
{
}

//w ##class(%ResultSet).RunQuery("web.DHCST.DHCSTMBCCollDrug","GetMBCCOllDrugReg","2015-11-10","2015-11-10","","","","","",40)

ClassMethod GetMBCCOllDrugRegExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, AUser As %String, Prescno As %String, locid As %String, State As %String) As %Status
{
    
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    s pid=..NewPid()
    
    i StartDate["-" s StartDate=$zdh(StartDate,3)
    i EndDate["-" s EndDate=$zdh(EndDate,3)
    i StartDate["/" s StartDate=$zdh(StartDate,4)
    i EndDate["/" s EndDate=$zdh(EndDate,4)
     i StartTime[":" s StartTime=$zth(StartTime)
   i EndTime[":" s EndTime=$zth(EndTime)
    
    f date=StartDate:1:EndDate d
    .s mbcid=""
    .f  s mbcid=$o(^DHCMBC(0,"PRINTDATE",date,mbcid)) q:mbcid=""  d 
    ..s mbcsub=$o(^DHCMBC(0,"PRINTDATE",date,mbcid,""),-1) d 
    ..s User=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1) 
    ..s Time=$p(^DHCMBC(mbcid,"I",mbcsub),"^",6)
    ..s Statdr=$p(^DHCMBC(mbcid,"I",mbcsub),"^",4)
    ..q:(date=StartDate)&(StartTime>Time)&(StartTime'="")
    ..q:(date=EndDate)&(EndTime<Time)&(EndTime'="")
    ..//s stateold=$p(^DHCMBC(mbcid),"^",5)
    ..s statedescold=$p(^DHCMBCS(Statdr),"^",1)
    ..//q:statedescold'="40" //煎药登记状态
    ..q:(State'="")&(statedescold'=State)
    ..q:(AUser'="")&(AUser'=User)
    ..s Adm=$p(^DHCMBC(mbcid),"^",2)
    ..S PatientID=$P($G(^PAADM(Adm)),"^",1)
    ..q:PatientID=""
    ..s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
    ..s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //患者姓名
    ..s PrescnoM=$p(^DHCMBC(mbcid),"^",1)
    ..q:(Prescno'="")&(PrescnoM'=Prescno)
    ..s Stateid=$p(^DHCMBC(mbcid),"^",5)
    ..s Statedesc=$p(^DHCMBCS(Stateid),"^",2)
    ..s type=$p(^DHCMBC(mbcid),"^",8)
    ..i type="O" s Statedesc=Statedesc_"(门诊)"
    ..e  s Statedesc=Statedesc_"(住院)" 
    ..s locdr=$p(^DHCMBC(mbcid),"^",9)
    ..i locid=0 s locid=""
    ..
    ..q:(locid'="")&&(locid'=locdr)
    ..//s Locdesc=$p(^CTLOC(locdr),"^",2)
    ..s retstr=##class(web.DHCOutPhPrint).Getpaque(PrescnoM)
    ..s queaddinfo=##class(web.DHCST.DHCSTMBCCollDrug).Getpaqueaddinfo(PrescnoM) //lq 2008-03-05 取中草药处方信息	
    ..//s Instruc=$p(retstr,"^",1) //用法
    ..s orditm=""
    ..i type="O" d
    ...s Phdr=$p(^DHCMBC(mbcid),"^",4)
    ...s Phdi=$o(^DHCPHDI(Phdr,"PHDI",""))
    ...q:+Phdi=0
    ...s orditm=$p(^DHCPHDI(Phdr,"PHDI",Phdi),"^",5)
    ..e  d
    ...s PhaId=$p(^DHCMBC(mbcid),"^",4)
    ...s PhaItmId=$o(^DHCPHAC(0,"Prescno",PrescnoM,PhaId,""))
    ...q:+PhaItmId=0
    ...s orditm=$p(^DHCPHAC(PhaId,"I",PhaItmId),"^",7) 
    ...
    ..s tmp=##class(web.DHCSTPCHCOLLPRN).getOrdItm(orditm)
    ..s Instruc=$p(tmp,"^",6) //口服还是外用
    ..i Instruc ["外" s Instruc="外用"
    ..e  s Instruc="口服"
    ..s fsqty=$p(retstr,"^",2) //付数
    ..s notes=$p(retstr,"^",6) //备注
    ..s dreat=$p(queaddinfo,"^",7) //是否当日服用
    ..s emergency=$p(queaddinfo,"^",8) //是否当日服用//急煎标志
    ..i emergency="Y" s emergency="是"
    ..e  s emergency="否"
    ..s retpid=..GetPrescMarkInc(PrescnoM)
    ..s xjstr=""
    ..s hxst=""
    ..s bjstr=""
    ..s cyjstr=""
    ..i $d(^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"xj")) s xjstr=^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"xj")
    ..i $d(^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"hx")) s hxst=^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"hx")
    ..i $d(^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"bj")) s bjstr=^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"bj")
    ..i $d(^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"cyj")) s cyjstr=^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"cyj")
    ..s FDrug=xjstr //先煎
    ..s LDrug=hxst //后下
    ..s WrDrug=bjstr //包煎
    ..s Uway=cyjstr
    ..d OutPutRowReg
 k ^TMP("web","DHCST","DHCSTMBCCollDrug",pid)	
 Quit $$$OK
OutPutRowReg
 s Data=$lb(PatName,PrescnoM,fsqty,Instruc,FDrug,LDrug,WrDrug,emergency,Uway,notes)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod GetMBCCOllDrugRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMBCCOllDrugRegExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetMBCCOllDrugRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMBCCOllDrugRegExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 检索煎药室登记查询用
/// w ##class(web.DHCST.DHCSTMBCCollDrug).jsDHCSTMBCCOllDrugReg
ClassMethod jsDHCSTMBCCOllDrugReg(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
 n (StrParam,Start,Limit,Sort,Dir)
 s qPar=Sort_"^"_Dir
 q:StrParam="" ""
 s StartDate=$p(StrParam,"&",1)
 s StartTime=$p(StrParam,"&",2) 
 s EndDate=$p(StrParam,"&",3) 
 s EndTime=$p(StrParam,"&",4)
 s AUser=$p(StrParam,"&",5) //操作人
 s PatLoc=$p(StrParam,"&",6) //科室
 s Prescno=$p(StrParam,"&",7) //处方号
 s State=$p(StrParam,"&",8) //状态串以"^"分割
 ;
 i StartTime[":" s StartTime=$zth(StartTime)
 i EndTime[":" s EndTime=$zth(EndTime)
 q:StartDate="" ""
 q:EndDate="" ""
 s StartDate=$zdh(StartDate,3)
 s EndDate=$zdh(EndDate,3)
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCSTMBCCollDrug:GetMBCCOllDrugRegQuery")
 //s sc= result.Execute(StartDate,EndDate,StartTime,EndTime,AUser,Prescno,PatLoc,State)
 s sc= result.Execute(qPar,StartDate,StartTime,EndDate,EndTime,AUser,PatLoc,Prescno,State)
 i $$$ISERR(sc) q ""
 s colNum=result.GetColumnCount()
 s end = Start+Limit
 	i $$$ISERR(sc) q ""
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s pid=..NewPid()
	Set $ZT="ERRORjsDHCSTMBCCOllDrugReg"	
	s h=0
	While(result.Next())
	{ 
	    s data=""
	    f i=1:1:colNum d
  		.i data="" s data=result.%GetData(i)
		.e   s data=data_"^"_result.%GetData(i)

	    s h=h+1
	    s index=h  //排序
	    s ^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrugReg",pid,"index",index)=data 
	 }
      s maxrow=h
	i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    s counSpAmtSum=0,freSpAmtSum=0,adjSpAmtSum=0
    f  s h=$o(^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrugReg",pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrugReg",pid,"index",h)
    .s MBCId=$p(data,"^",1)
    .s PatLoc=$p(data,"^",2)
    .s PatNo=$p(data,"^",3)
    .s PatName=$p(data,"^",4)
    .s Prescno=$p(data,"^",5)
    .s State=$p(data,"^",6)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage 

    .s MBCId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("MBCId",MBCId)    
       .s PatLoc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatLoc",PatLoc)
       .s PatNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatNo",PatNo)
       .s PatName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatName",PatName)
	.s Prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Prescno",Prescno)
      .s State=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("State",State)
      .
      .s tmpstr=MBCId_PatLoc_PatNo_PatName_Prescno_State
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	k ^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrugReg",pid) 
     
    q ""
 
 
 
ERRORjsDHCSTMBCCOllDrugReg
    //遇报错,则先kill TMP
    Set Method="##class(web.DHCST.DHCSTMBCCollDrug),jsDHCSTMBCCOllDrugReg"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrPar_")"_","_$ZE
	k ^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrugReg",pid)    
    q ""
}

/// 煎药登记查询使用
/// Author:wyx
/// Date:2014-09-17
/// Argu:
///   qPar  -查询参数(排序列^排序方向)
///   inst -
///   ManGrp -
/// Return:
Query GetMBCCOllDrugRegQuery(qPar As %String, StartDate As %String, EndDate As %String, AuditFlag As %String, InciIn As %String, WardId As %String, StartTime As %String, EndTime As %String, MedNoTxt As %String, PatNameIn As %String, AUserIn As %String, PatLocIn As %String, MDocIn As %String, ADocIn As %String, BeyondE As %String) As %Query(ROWSPEC = "mbcid:%String,PatLoc:%String,PatNo:%String,PatName:%String,Prescno:%String,Statedesc:%String")
{
}

//d ##class(%ResultSet).RunQuery("web.DHCST.DHCSTKNarcotic","GetMBCCOllDrugRegQuery","Rowid^ASC")

ClassMethod GetMBCCOllDrugRegQueryExecute(ByRef qHandle As %Binary, qPar As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, AUser As %String, PatLoc As %String, Prescno As %String, State As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    
    s Sort=$p(qPar,"^",1)
    s Dir=$p(qPar,"^",2)
    i StartDate["-" s StartDate=$zdh(StartDate,3)
    i EndDate["-" s EndDate=$zdh(EndDate,3)
    i StartDate["/" s StartDate=$zdh(StartDate,4)
    i EndDate["/" s EndDate=$zdh(EndDate,4)
    f date=StartDate:1:EndDate d
    .s mbcid=""
    .f  s mbcid=$o(^DHCMBC(0,"PRINTDATE",date,mbcid)) q:mbcid=""  d 
    ..s mbcsub=$o(^DHCMBC(0,"PRINTDATE",date,mbcid,""),-1) d 
    ..s User=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1) 
    ..s Time=$p(^DHCMBC(mbcid,"I",mbcsub),"^",3)
    ..s Statdr=$p(^DHCMBC(mbcid,"I",mbcsub),"^",4)
    ..s statedescold=$p(^DHCMBCS(Statdr),"^",1)
    ..q:(statedescold'=State)&&(State'="")
    ..q:(date=StartDate)&(StartTime>Time)&(StartTime'="")
    ..q:(date=EndDate)&(EndTime<Time)&(EndTime'="")
    ..q:(AUser'="")&(AUser'=User)
    ..s ret=0
    ..//i State'="" s ret=..CheckState(State,Statdr)
    ..//q:(ret=0)&(State'="")
    ..//s stateold=$p(^DHCMBC(mbcid),"^",5)
    ..//s statedescold=$p(^DHCMBCS(stateold),"^",1)
    ..s Adm=$p(^DHCMBC(mbcid),"^",2)
    ..S PatientID=$P($G(^PAADM(Adm)),"^",1)
    ..q:PatientID=""
    ..s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
    ..s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //患者姓名
    ..s PrescnoM=$p(^DHCMBC(mbcid),"^",1)
    ..q:(Prescno'="")&(PrescnoM'=Prescno)
    ..s Stateid=$p(^DHCMBC(mbcid),"^",5)
    ..s Statedesc=$p(^DHCMBCS(Stateid),"^",2)
    ..s type=$p(^DHCMBC(mbcid),"^",8)
    ..i type="O" s Statedesc=Statedesc_"(门诊)"
    ..e  s Statedesc=Statedesc_"(住院)" 
    ..s locdr=$p(^DHCMBC(mbcid),"^",9)
    ..q:(PatLoc'="")&&(PatLoc'=locdr)
    ..s Locdesc=$p(^CTLOC(locdr),"^",2)
    ..d OutPutRowRegQuery
	
 Quit $$$OK
OutPutRowRegQuery
 s Data=$lb(mbcid,Locdesc,PatNo,PatName,PrescnoM,Statedesc)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod GetMBCCOllDrugRegQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMBCCOllDrugRegQueryExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetMBCCOllDrugRegQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMBCCOllDrugRegQueryExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetZCYMark(prescno)
{
 
 s ord=""	
 s ord=$o(^OEORD(0,"PrescNo",$$ALPHAUP^SSUTIL4(prescno),""))
 s ori="",phspecinstr=""
 f  s ori=$o(^OEORD(ord,"I",ori)) q:ori=""  d
 .q:ori=0
 .q:'$d(^OEORD(ord,"I",ori,2))
 .q:$p(^OEORD(ord,"I",ori,2),"^",8)=""
 .q:phspecinstr[$p(^OEORD(ord,"I",ori,2),"^",8)
 .i phspecinstr=""  d
 ..s phspecinstr=$p(^OEORD(ord,"I",ori,2),"^",8)        ;中草药医嘱的备注
 .e  d
 ..s phspecinstr=phspecinstr_","_$p(^OEORD(ord,"I",ori,2),"^",8)
 q phspecinstr
}

ClassMethod GetPrescMarkInc(prescno)
{
 q:prescno="" ""
 q:'$d(^OEORD(0,"PrescNo",$$ALPHAUP^SSUTIL4(prescno))) ""
 s ord=""	
 s ord=$o(^OEORD(0,"PrescNo",$$ALPHAUP^SSUTIL4(prescno),""))
 s ori="",phspecinstr=""
 s pid=..NewPid()
 f  s ori=$o(^OEORD(ord,"I",ori)) q:ori=""  d
 .q:ori=0
 .q:'$d(^OEORD(ord,"I",ori,2))
 .q:$p(^OEORD(ord,"I",ori,2),"^",8)=""
 .q:phspecinstr[$p(^OEORD(ord,"I",ori,2),"^",8)
 .s itmmast=$p(^OEORD(ord,"I",ori,1),"^",2)
 .s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
 .s incidesc=$p(^INCI(inci,1),"^",2)
 .s phspecin=$p(^OEORD(ord,"I",ori,2),"^",8)        ;中草药医嘱的备注
 .i phspecin["先煎" d
 ..i '$d(^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"xj")) d
 ...s ^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"xj")=incidesc
 ..e  d
 ...s ^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"xj")=^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"xj")_","_incidesc
 .i phspecin["后下" d
 ..i '$d(^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"hx")) d
 ...s ^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"hx")=incidesc
 ..e  d
 ...s ^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"hx")=^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"hx")_","_incidesc
 .i phspecin["包煎" d
 ..i '$d(^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"bj")) d
 ...s ^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"bj")=incidesc
 ..e  d
 ...s ^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"bj")=^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"bj")_","_incidesc
 .i (phspecin["冲服")||(phspecin["另煎")||(incidesc["阿胶")||(incidesc["鹿角胶")||(incidesc["龟甲胶") d
 ..i '$d(^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"cyj")) d
 ...s ^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"cyj")=incidesc
 ..e  d
 ...s ^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"cyj")=^TMP("web","DHCST","DHCSTMBCCollDrug",pid,"cyj")_","_incidesc
 ..
 q pid
}

/// 检索煎药室住院查询用
/// w ##class(web.DHCST.DHCSTMBCCollDrug).jsDHCSTMBCCOllDrugInpha
ClassMethod jsDHCSTMBCCOllDrugInpha(Start As %Integer, Limit As %Integer, StrParam As %String) As %String
{
 n (StrParam,Start,Limit)
 q:StrParam="" ""
 s StartDate=$p(StrParam,"&",1)
 s StartTime=$p(StrParam,"&",2) 
 s EndDate=$p(StrParam,"&",3) 
 s EndTime=$p(StrParam,"&",4)
 s AUser=$p(StrParam,"&",5) //操作人
 s PatLoc=$p(StrParam,"&",6) //科室
 s Prescno=$p(StrParam,"&",7) //处方号
 s State=$p(StrParam,"&",8) //状态串以"^"分割
 ;
 i StartTime[":" s StartTime=$zth(StartTime)
 i EndTime[":" s EndTime=$zth(EndTime)
 q:StartDate="" ""
 q:EndDate="" ""
 s StartDate=$zdh(StartDate,3)
 s EndDate=$zdh(EndDate,3)
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCSTMBCCollDrug:GetMBCCOllDrugInpha")
 s sc= result.Execute(StartDate,StartTime,EndDate,EndTime,AUser,PatLoc,Prescno,State,"I")
 
 i $$$ISERR(sc) q ""
 s colNum=result.GetColumnCount()
 s end = Start+Limit
 	i $$$ISERR(sc) q ""
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s pid=..NewPid()
	Set $ZT="ERRORjsDHCSTMBCCOllDrugInpha"	
	s h=0
	While(result.Next())
	{ 
	    s data=""
	    f i=1:1:colNum d
  		.i data="" s data=result.%GetData(i)
		.e   s data=data_"^"_result.%GetData(i)

	    s h=h+1
	    s index=h  //排序
	    s ^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrugInpha",pid,"index",index)=data 
	 }
      s maxrow=h
	i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    s counSpAmtSum=0,freSpAmtSum=0,adjSpAmtSum=0
    f  s h=$o(^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrugInpha",pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrugInpha",pid,"index",h)
    .s MBCId=$p(data,"^",1)
    .s LocWard=$p(data,"^",2)
    .s PatNo=$p(data,"^",3)
    .s MedNo=$p(data,"^",4)
    .s BedNo=$p(data,"^",5)
    .
    .s PatName=$p(data,"^",6)
    .s Prescno=$p(data,"^",7)
    .s FsQty=$p(data,"^",8)
    .s State=$p(data,"^",9)
    .s dreat=$p(data,"^",10)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage 

    .s MBCId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("MBCId",MBCId)    
       .s LocWard=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("LocWard",LocWard)
       .s PatNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatNo",PatNo)
       .s MedNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("MedNo",MedNo)
       .s BedNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("BedNo",BedNo)
       .
       .s PatName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PatName",PatName)
	.s Prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Prescno",Prescno)
      .s FsQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("FsQty",FsQty)
      .s State=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("State",State)
      .s dreat=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("dreat",dreat)
      .s tmpstr=MBCId_LocWard_PatNo_MedNo_BedNo_PatName_Prescno_FsQty_State_dreat
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	k ^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrugInpha",pid) 
     
    q ""
 
 
 
ERRORjsDHCSTMBCCOllDrugInpha
    //遇报错,则先kill TMP
    Set Method="##class(web.DHCST.DHCSTMBCCollDrug),jsDHCSTMBCCOllDrugInpha"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrPar_")"_","_$ZE
	k ^TMP("DHCST","DHCSTMBCCollDrug","jsDHCSTMBCCOllDrugInpha",pid)    
    q ""
}

/// 煎药住院查询打印使用
/// Author:wyx
/// Date:2014-11-03
/// Argu:
///   qPar  -查询参数(排序列^排序方向)
///   inst -
///   ManGrp -
/// Return:
Query GetMBCCOllDrugInpha(StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, AUser As %String, PatWard As %String, Prescno As %String, State As %String, Type As %String) As %Query(ROWSPEC = "mbcid:%String,Locdesc:%String,PatNo:%String,MedNo:%String,BedNo:%String,PatName:%String,PrescnoM:%String,FsQty:%String,Statedesc:%String,dreat:%String") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.DHCST.DHCSTMBCCollDrug","GetMBCCOllDrugInpha",)

ClassMethod GetMBCCOllDrugInphaExecute(ByRef qHandle As %Binary, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, AUser As %String, PatWard As %String, Prescno As %String, State As %String, Type As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    
    i StartDate["-" s StartDate=$zdh(StartDate,3)
    i EndDate["-" s EndDate=$zdh(EndDate,3)
    i StartDate["/" s StartDate=$zdh(StartDate,4)
    i EndDate["/" s EndDate=$zdh(EndDate,4)
    f date=StartDate:1:EndDate d
    .s mbcid=""
    .f  s mbcid=$o(^DHCMBC(0,"ITMDATE",date,mbcid)) q:mbcid=""  d 
    ..s mbcsub=$o(^DHCMBC(0,"ITMDATE",date,mbcid,""),-1) d 
    ..s User=$p(^DHCMBC(mbcid,"I",mbcsub),"^",1) 
    ..s Time=$p(^DHCMBC(mbcid,"I",mbcsub),"^",3)
    ..s Statdr=$p(^DHCMBC(mbcid,"I",mbcsub),"^",4)
    ..s Statdr2=$p(^DHCMBCS(Statdr),"^",1)
    ..q:(date=StartDate)&(StartTime>Time)&(StartTime'="")
    ..q:(date=EndDate)&(EndTime<Time)&(EndTime'="")
    ..q:(AUser'="")&(AUser'=User)
    ..q:(State'=Statdr2)&(State'="")
    ..s Adm=$p(^DHCMBC(mbcid),"^",2)
    ..S PatientID=$P($G(^PAADM(Adm)),"^",1)
    ..q:PatientID=""
    ..s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
    ..s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //患者姓名
    ..s PrescnoM=$p(^DHCMBC(mbcid),"^",1)
    ..q:(Prescno'="")&(PrescnoM'=Prescno)
    ..s Stateid=$p(^DHCMBC(mbcid),"^",5)
    ..s Statedesc=$p(^DHCMBCS(Stateid),"^",2)
    ..s type=$p(^DHCMBC(mbcid),"^",8)
    ..q:(Type'="")&(type'=Type)
    ..i type="O" s Statedesc=Statedesc_"(门诊)"
    ..e  s Statedesc=Statedesc_"(住院)" 
    ..s locdr=$p(^DHCMBC(mbcid),"^",9)
    ..s PatLoc=""
    ..i PatWard'="" s PatLoc=$p(^PAWARD(PatWard),"^",5) //病区对应的ctloc的id
    ..q:(PatLoc'="")&&(PatLoc'=locdr)
    ..s Locdesc=$p(^CTLOC(locdr),"^",2)
    ..//b //3
    ..//s depWard=$o(^PAWARD(0,"WARD_LocationDR",locdr,""))  	;科室对应的病区
    ..//s depWarddesc=$p(^PAWARD(depWard),"^",2)
    ..s retstr=..GetPrescInInfo(PrescnoM)
    ..s FsQty=$p(retstr,"^",2)
    ..s depWarddesc=$p(retstr,"^",3)
    ..s BedNo=$p(retstr,"^",4)
    ..s MedNo=$p(retstr,"^",5)
    ..s dreat=$p(queaddinfo,"^",7) //是否当日服用
    ..i dreat="Y" s dreat="是"
    ..e  s dreat="否"
    ..d OutPutRowInpha
	
 Quit $$$OK
OutPutRowInpha
 s Data=$lb(mbcid,Locdesc,PatNo,MedNo,BedNo,PatName,PrescnoM,FsQty,Statedesc,dreat)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod GetMBCCOllDrugInphaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMBCCOllDrugInphaExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetMBCCOllDrugInphaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMBCCOllDrugInphaExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod CheckIfZCY(prescno)
{
 s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
 q:'$d(^PAQUE1(queid,"DHC")) 0 ;过滤非中草药
 q 1
}

//安贞医院煎药费插入示例

// ;s Adm=11896379   ;随机提取

//;s OrdItemStr="280||1"_"^"_副数_"^"_396_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""    

// ；副数随机提取，其他的都是固定值

//;s User="1706"    ；登陆用户ID

//;s Loc="294"     ；固定值

//;s LABDATA="trnlabdata"   ；固定值

//;s DocUserId="1706"    ；登陆用户ID

//;s InsType=1   ;固定值

ClassMethod InsertJYBillOrder(Prescno, UserId)
{
 s Adm=##class(web.DHCOutPhDisp).getadm(Prescno)	
 s retstr=##class(web.DHCOutPhPrint).Getpaque(Prescno)
 s jsnum=$p(retstr,"^",2) //剂数
 s User=UserId    //登陆用户ID
 s DocUserId=UserId    //登陆用户ID
 //以下变量为安贞参数
 s OrdItemStr="280||1"_"^"_jsnum_"^"_396_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""  //副数提取，其他的都是固定值   
 s Loc="294"     //固定值
 s LABDATA="trnlabdata"   //固定值
 s InsType=1   ;固定值
 zn "dhc-medsrc"	
 s ret=$$InsertOrderItem^DHCDocInterface(Adm,OrdItemStr,User,Loc,LABDATA,DocUserId,InsType)
 zn "dhc-app"	
 q:ret'["^" -1
 q 0
}

/// lxz 医生站使用获得处方打印信息
/// w ##class(web.DHCST.DHCSTMBCCollDrug).GetPrtPrescInfoDoc("O14112700007","")
ClassMethod GetPrtPrescInfoDoc(PrescNo As %String, phdphl As %String)
{
   s patstring=""  //处方信息(含患者基本信息)
   s medstring=""  //医嘱信息
   s phdrow="" 
   f  s phdrow=$o(^PAQUE1(0,"PrescNo",PrescNo,phdrow)) q:phdrow=""  d
   .s tmpphdphl=$p(^PAQUE1(phdrow),"^",4)
   .q:(tmpphdphl'=phdphl)&&(phdphl'="")
   .s papmi=""
   .s adm=+$p(^PAQUE1(phdrow),"^",3)
   .s papmi=$P(^PAADM(adm),"^",1)
   .s perno=$p(^PAPER(papmi,"PAT",1),"^",2)
   .s pname=$p(^PAPER(papmi,"ALL"),"^",1)
   .s ptel=$p(^PAPER(papmi,"PER",1),"^",11)
   .s paddress=$p($g(^PAPER(papmi,"PER",4)),"^",18)
   .s getage=##class(web.DHCOutPhCommon).GetAge(papmi) 
   .//s getage=##class(web.DHCSTKUTIL).GetAge(papmi,adm) //年龄统一调用接口wyx 2015-01-29
   .s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
   .s sex=$p(^CT("SEX",sexdr),"^",2)
   .s company=$p(^PAPER(papmi,"PER",4),"^",18) //工作单位
   .s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""),-1)
   .s cardNo=""
   .i cfRowId'="" s cardNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
   .s admord=$o(^OEORD(0,"PrescNo",PrescNo,""))
   .s admdate=""
   .s admdate=$p(^PAADM(adm),"^",6)
   .i admdate'="" s admdate=$zd(admdate,3)
   .;s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",")
   .s patW=##class(web.DHCOutPhCommon).GetPatWeight(adm)
   .s deplocdr=$p(^PAADM(adm),"^",4)
   .s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
   .i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
   .s pyname=""
   .s fyname=""
   .s pydate=""
   .s fydate=""
   .s sysdate=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
   .;
   .;s phl=$p(^DHCPHDISP(phdrow,1),"^",1)
   .;s phlocdr=$p(^DHCPHLOC(phl),"^",1)
   .s recloc=$p(^CTLOC(tmpphdphl),"^",2) 
   .s slow="",slowdesc=""  //慢性病标志
   .i $F(recloc,"-") s recloc=$p(recloc,"-",2)
   .s PayTypexy="",billtypedesc=""
   .s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",")
   .;s phwdr=$p(^DHCPHDISP(phdrow),"^",4)
   .;i phwdr'="" d 
   .;.i $D(^DHCPHWIN(phwdr)) s phwindesc=$p(^DHCPHWIN(phwdr),"^",1)
   .//s presctitle=##class(web.DHCOutPhTQDisp).GetPrescTitle(PrescNo)
   .;
   .s retstr=##class(web.DHCOutPhPrint).Getpaque(PrescNo)
   .s queinst=$p(retstr,"^",1)
   .s quefac=$p(retstr,"^",2) 
   .s queqty=$p(retstr,"^",3)
   .s quedate=$p(retstr,"^",4)
   .s quexdate=$p(retstr,"^",5)
   .s quenote=$p(retstr,"^",6)  
   .s quecook=$p(retstr,"^",7)
   .s docstr=##class(web.DHCOutPhCommon).GetOrdDoc(PrescNo,tmpphdphl)
   .s docctloc=$p(docstr,"^",1)
   .s doctor=$p(docstr,"^",2)
   .s orddate=$p(docstr,"^",3)
   .s doctorcode=$p(^CTPCP($o(^CTPCP(0,"Decs",doctor,"")),1),"^",1)
   .//s presctitle=..GetPrescTitleSJZ(PrescNo,adm,docctloc)
   .;------------------------------------------------------------yunhaibao20130419添加费别>
   .S PayType=""
   .S SocialStatusID=$P(^PAPER(papmi,"PER",1),"^",10)
   .S YlzNo=$P(^PAPER(papmi,"ALL"),"^",19) //医疗证号
   .S WorkAdd=$P(^PAPER(papmi,"PER",4),"^",18) //工作地点
   .I SocialStatusID'="" S PayType=$P($G(^CT("SS",SocialStatusID)),"^",2) //病人的身份 //^CT("SS",1)="01^自费",^CT("SS",2)="02^省医保",^CT("SS",3)="03^市医保",^CT("SS",12)="04^公费医疗",^CT("SS",13)="05^省企业离休
   .i PayType="" d
   ..s PayType=$p(^PAADM(adm,1),"^",7)
   ..s:(PayType'="")&&($d(^PAC("ADMREA",PayType))) PayType=$p($g(^PAC("ADMREA",PayType)),"^",2) //处方类型，比如医保病人开的自费的处方此字段为自费，^CT("SS",1)为医保
   .;--------------------------------------------------------------yunhaibao20130419,中药处方附加信息和发药类别>
   .s queaddinfo=..Getpaqueaddinfo(PrescNo) ;获取中草药附加信息
   .s phatypecode=..GetArcItmCatByPresc(PrescNo)  ;医嘱子类
   .s phatyperid=$o(^ARC("IC",0,"Code",phatypecode,""))
   .s phatypedesc=$p(^ARC("IC",phatyperid),"^",2)
   .i billtypedesc'="" s PayType=billtypedesc
   .;s remark=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark($p(oedis,"||",1,2))
   .;----------------------------------------------------------------------------->
   .s patstring=perno_"^"_pname_"^"_getage_"^"_sex_"^"_diagnodesc_"^"_patW_"^"_pyname_"^"_fyname_"^"_pydate_"^"_fydate_"^"_sysdate_"^"_recloc_"^"_company_"^"_admdate_"^"_cardNo_"^"_PrescNo_"^"_deplocdesc_"^"_""_"^"_ptel_"^"_paddress_"^"_quecook_"^"_queqty_"^"_""_"^"_docctloc_"^"_doctor
   .s patstring=patstring_"^"_queinst_"^"_quefac_"^"_queqty_"^"_quedate_"^"_quexdate_"^"_quenote_"^"_orddate_"^"_PayType_"^"_queaddinfo_"^"_phatypedesc_"^"_doctorcode_"^"_""_"^"_YlzNo_"^"_WorkAdd
   .;
   .s Sub=0
   .f  s Sub=$O(^OEORD(0,"PrescNo",PrescNo,admord,Sub)) Q:Sub=""  d
   ..s ord=admord s itm=Sub
   ..s freq=$p(^PHCFR($p(^OEORD(ord,"I",itm,2),"^",4)),"^",1)  ;用药频率
   ..s inst=$p(^PHCIN($p(^OEORD(ord,"I",itm,2),"^",7)),"^",2)  ;用法 
   ..s phdur=$p(^PHCDU($p(^OEORD(ord,"I",itm,2),"^",6)),"^",1) ;用药疗程
   ..s specinstr=$p(^OEORD(ord,"I",itm,2),"^",8) ;中草药处方每味药备注  
   ..s dosage=$p(^OEORD(ord,"I",itm,2),"^",1) ;用药剂量
   ..s dosageuomdr=$p(^OEORD(ord,"I",itm,2),"^",3)
   ..s dosageuom=""
   ..s:dosageuomdr'="" dosageuom=$p(^CT("UOM",dosageuomdr),"^",2)   ;剂量单位 
   ..s OrdStr=..GetNoPayFee(adm,ord_"||"_itm)
   ..b ;OrdStr
   ..s totalprice=$p(OrdStr,"^",3)
   ..s price=$p(OrdStr,"^",8)
   ..s price=$fn(price,"",4)
   ..s qty=$P(OrdStr,"^",4)
   ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) 
   ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""
   ..s genedesc=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 		//通用名
   ..s incidsec=genedesc
   ..i genedesc="" s incidsec=$p(^INCI(inci,1),"^",2)
   ..i incidsec [ "-"  s incidsec=$p(incidsec,"-",2)
   ..s unit=""
   ..s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(inci,qty)
   ..s qty=$p(qtyinfo,"^",1)
   ..s unit=$p(qtyinfo,"^",2)
   ..s unit=$P(OrdStr,"^",5)
   ..s skintest=""
   ..s skinflag=##class(web.DHCOutPhCommon).SkinTest(ord_"||"_itm)
   ..i (skinflag'<0)&(skinflag'="") s skintest="(-)"
   ..i skinflag=-1 s skintest="(+)"
   ..i skinflag=-6 s skintest="( )"
   ..s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(ord_"||"_itm)
   ..s itmmast=""
   ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
   ..s drgform=$p(^ARCIM(+itmmast,$p(itmmast,"||",2),1),"^",12)
   ..s phcform="",phfact="",factdesc=""
   ..s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci) 	        //规格
   ..i drgform'=""  d
   ...s phcform=$p(^PHCD($p(drgform,"||",1),"DF",$p(drgform,"||",2),1),"^",1)
   ...s phfact=$p(^PHCD($p(drgform,"||",1),2),"^",4)
   ..s phcform=##class(web.DHCSTCOMMONSRV).GetForm(inci) 			//剂型
   ..i phfact'="" d
   ...i $d(^PHMNF(phfact)) d
   ....s factdesc=$p(^PHMNF(phfact),"^",1)      ;yunhaibao20130417,产地
   ..s tmpsting=incidsec_"^"_qty_"^"_unit_"^"_dosage_""_dosageuom_"^"_inst_"^"_freq_"^"_phdur_"^"_price_"^"_totalprice_"^"_skintest_"^"_ordremark_"^"_factdesc_"^"_specinstr_"^"_phcform_"^"_Specifaction
   ..b 
   ..i medstring="" d
   ...s medstring=tmpsting
   ..e  d
   ...s medstring=medstring_"@"_tmpsting
   ..
   ..
   q patstring_"!!"_medstring
}

/// creater	lxz
/// desc 	获得病人未结算的钱,门诊使用.(输入OrderIDInput为医嘱项返回医嘱详细信息)
/// AdmID w ##class(web.DHCDocOrderEntry).GetNoPayFee(3485)
/// web.DHCDocOrderCommon 中使用显示卡消费
ClassMethod GetNoPayFee(AdmRowID, OrderIDInput As %String = "") As %String
{
	s OrderID=$O(^OEORD(0,"Adm",AdmRowID,0))
	Q:OrderID="" 0
	s PatType=$P(^PAADM(AdmRowID),"^",2)
	if OrderIDInput=""
	{
		s PriceSum=0
		s SubID=0
		f  s SubID=$O(^OEORD(OrderID,"I",SubID)) Q:SubID=""  d
		.s GetStr=$$GetMesage(OrderID,SubID,PatType,AdmRowID)
		.s OrderSum=$P(GetStr,"^",3)
		.s PriceSum=PriceSum+OrderSum
		Q PriceSum
	}
	else
	{
		
		s OrderID=+OrderIDInput
		s SubID=$P(OrderIDInput,"||",2) 
		Q:((OrderID="")||(SubID="")) ""
		s GetStr=$$GetMesage(OrderID,SubID,PatType,AdmRowID)
		Q GetStr
	}
GetMesage(OrderID,SubID,PatType,AdmRowID)
	s ArcimID=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",2)
	s OrderName=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",2)  ;
	s statcode="V"
	s TtemStat=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",13) ;OEORI_Billed
	i TtemStat'="" d
	.s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
	Q:($g(statcode)'="V")&&(OrderIDInput="") ""
	s OrderBilled=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",5) ;OEORI_Billed
	Q:(OrderBilled="P")&&(OrderIDInput="") ""
	s OrderDoseUOMRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",3) ;OEORI_Unit_DR
	s ARCIMPHCDFDR=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",12) ;OEORI_ItmMast_DR->ARCIM_PHCDF_DR
	s OrderDoseQty=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",1) ;OEORI_DoseQty
	s InsType=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",18) ;OEORI_BBExtCode
	s OrderSttDate=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",9) ;OEORI_SttDat
	s OrderPriorRowid=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",8) ; OEORI_Priority_dr
	s OrderInstrRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",7) ; OEORI_Instr_DR
	s OrderLinkTo=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",1)  ;OEORI_LinkToOrder
	s OEORIPrice=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",25)  ;OEORI_Price 自定义价格
	s OrderRecDepRowid=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",6) ;OEORI_RecDep_DR
	s OrderRecDep=""
	if OrderRecDepRowid'="" s OrderRecDep=$P(^CTLOC(OrderRecDepRowid),"^",2)
	if OrderRecDep["-" s OrderRecDep=$P(OrderRecDep,"-",2)
	s OrderBillTypeRowid=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",18) ;OEORI_BBExtCode
	s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	s OrderType=""
	if ItemCatDr'="" d
	.s OrderType=$P(^ARC("IC",ItemCatDr),"^",7) ; OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType
	s OrderPackQty=$P($G(^OEORD(OrderID,"I",SubID,9)),"^",4) ;OEORIQtyPackUOM
	s ARCIMBillingUOM=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),8),"^",14) 
	s OrderPackUOM=""
	if ARCIMBillingUOM'="" d
	.s OrderPackUOM=$P(^CT("UOM",ARCIMBillingUOM),"^",2)  ;OEORI_ItmMast_DR->ARCIM_BillingUOM_DR->CTUOM_Desc
	s OrderPrescNo=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",14) ;OEORI_PrescNo
	s OrderFreqRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",4) ; OEORI_PHFreq_DR
	s OrderDurRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",6) ;OEORI_Durat_DR
	s PriorRowid=""
	s InstrRowid=""
	s LinkTo=""
	s OEPrice=""
	s OrderBillType=""
	s Qty=..CalDose(OrderDoseUOMRowid,ARCIMPHCDFDR,OrderDoseQty)
	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, InsType, ArcimID, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,OrderRecDepRowid)
	s OrderPrice=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s OrderPrice=$fn($P(retPrice,"^",1),"",4)
	i OEORIPrice'="" s OrderPrice=OEORIPrice  ;如果自定义价格存在则使用自定义价格
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P($G(^PAC("ADMREA",OrderBillTypeRowid)),"^",2)
	i OrderDoseQty'="" d
	. i OrderDoseQty<1 s OrderDoseQty="0"_$number(OrderDoseQty)
	 i OrderType'="R" d
	 .s DoseqtySum=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",12)
	 .s OrderPackQty=DoseqtySum
	 ;s OrderPackUOM=$p(OrderPackUOM,"(",1)
	 s OrderSum=OrderPackQty*OrderPrice
	 i OrderPackQty'="" d
	 . i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
	 s DepProcNotes=$g(^OEORD(OrderID,"I",SubID,"DEP",1))
	;医嘱ID，医嘱名称，医嘱价格，医嘱数量，数量单位，接收科室，处方号，
	 if (((OrderPackQty=0)||(OrderPackQty=""))&&(OrderType="R"))  d  ;如果没有填数量则自动计算数量
	.s Qty=..CalDose12(OrderDoseUOMRowid,ARCIMPHCDFDR,OrderDoseQty)
	.s OrderPackQty=+Qty*$P(^PHCFR(OrderFreqRowid),"^",2)*$P(^PHCDU(OrderDurRowid),"^",2)
	.s OrderSum=OrderPackQty*OrderPrice
	.s OrderPackUOM=$P(Qty,"^",2)
	s OrderSum=$fn(OrderSum,"",4)
	s Str=OrderID_"||"_SubID_"^"_OrderName_"^"_OrderSum_"^"_OrderPackQty_"^"_OrderPackUOM_"^"_OrderRecDep_"^"_OrderPrescNo_"^"_OrderPrice
    Q Str
}

/// Creator       lixiangzong
/// CreatDate     2012.06.07
/// Description	  计算医嘱的基本数量     
/// Input         uom;计量单位ID     drgform：药学项ID   doseqty计量
/// Return        返回基本数量_"^"_单位
/// Others  w ##class(web.DHCOEOrdItem).CalDose("121","858||1","1")
ClassMethod CalDose12(uom As %String, drgform As %String, doseqty As %String) As %String
{
 s ^TempzongYUI=uom_"^"_drgform_"^"_doseqty
 n (uom,drgform,doseqty)
 q:(+doseqty=0)!(+uom=0) ""
 s eqUom=""
 i drgform'="" d        ; Pharmacy item is only efiended dose equivilent
 .s drgform1=+drgform,drgform2=$p(drgform,"||",2)
 .q:(drgform1="")!(drgform2="")
 .s bsUOMph=$p(^PHCD(drgform1,"DF",drgform2,2),"^",4)    ;Pharmacy base UOM
 .i uom'=bsUOMph d                                       ;Table - PHC_FormDoseEquiv
 ..s leq=0 f  s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",leq)) q:leq=""  d  q:eqUom=uom
 ...s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
 ...s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
 i (+eqUom'=0)&(+uom'=0)&(eqUom=uom) d
 .s qty1=doseqty\eqqty,qty2=(doseqty#eqqty)/eqqty
 .s doseqty=qty1+qty2
 ;原来是进位为整数?现在保留小数
 s DeductPartia=""
 i drgform=""  q ""_"^"_""   //LGQ add
 if $D(^PHCD(drgform1,"DF",drgform2,"DHC")) d
 .s DeductPartia=$p($g(^PHCD(drgform1,"DF",drgform2,"DHC")),"^",1)
 if DeductPartia'="1" s doseqty=doseqty\1+$s(doseqty#1:1,1:0)
 ;s DeductPartia=$p($g(^PHCD(drgform1,"DF",drgform2,2)),"^",6)
 ;if DeductPartia'="Y" s doseqty=doseqty\1+$s(doseqty#1:1,1:0)
 s UomDesc=$P(^CT("UOM",bsUOMph),"^",2)
 q doseqty_"^"_UomDesc
}

/// Creator?      周志强
/// CreatDate?    2009.02.20
/// Description:? 计算医嘱的基本数量
/// Table?        
/// Input?        DoseQty:剂量      PHCFRrow:频次指针   PHCDUrow?疗程指针
/// Prior:优先级指针  SttDate:开始日期    EndDate:截止日期
/// Return?       返回基本数量
/// Others?
ClassMethod CalDose(uom As %String, drgform As %String, doseqty As %String) As %String
{
	
 n (uom,drgform,doseqty)
 q:(+doseqty=0)!(+uom=0) ""
 s eqUom=""
 i drgform'="" d        ; Pharmacy item is only efiended dose equivilent
 .s drgform1=+drgform,drgform2=$p(drgform,"||",2)
 .q:(drgform1="")!(drgform2="")
 .s bsUOMph=$p(^PHCD(drgform1,"DF",drgform2,2),"^",4)    ;Pharmacy base UOM
 .i uom'=bsUOMph d                                       ;Table - PHC_FormDoseEquiv
 ..s leq=0 f  s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",leq)) q:leq=""  d  q:eqUom=uom
 ...s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
 ...s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
 i (+eqUom'=0)&(+uom'=0)&(eqUom=uom) d
 .s qty1=doseqty\eqqty,qty2=(doseqty#eqqty)/eqqty
 .s doseqty=qty1+qty2
 ;*/ 12/11/2000 Grace
 ;原来是进位为整数?现在保留小数
 i drgform'="" d    
 .s DeductPartia=""
 .if $D(^PHCD(drgform1,"DF",drgform2,"DHC")) d
 ..s DeductPartia=$p($g(^PHCD(drgform1,"DF",drgform2,"DHC")),"^",1)
 .if DeductPartia'="1" s doseqty=doseqty\1+$s(doseqty#1:1,1:0)
 ;s DeductPartia=$p($g(^PHCD(drgform1,"DF",drgform2,2)),"^",6)
 ;if DeductPartia'="Y" s doseqty=doseqty\1+$s(doseqty#1:1,1:0)
 q doseqty
}

ClassMethod Getpaqueaddinfo(prescno As %String) As %String
{
   ;获得中草药信息附加信息 PA_Que1 
   n (prescno)
   q:prescno="" ""
   s queid=""
   s questr=""
   s jptime="",hhtype="",jzcnt="",jztime="",qzfre="",jceat="",dreat="",jjflag=""
   s i=1
   f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
   .q:'$d(^PAQUE1(queid,"DHC")) 
   .s jptime=$P(^PAQUE1(queid,"DHC"),"^",25) ;浸泡时间
   .s hhtype=$P(^PAQUE1(queid,"DHC"),"^",26) ;文火或武火
   .s jzcnt=$P(^PAQUE1(queid,"DHC"),"^",27) ;煎煮次数
   .s jztime=$P(^PAQUE1(queid,"DHC"),"^",28) ;煎煮时间
   .s qzfre=$P(^PAQUE1(queid,"DHC"),"^",29) ;取汁量
   .s jceat=$P(^PAQUE1(queid,"DHC"),"^",30) ;分几次服用
   .s dreat=$P(^PAQUE1(queid,"DHC"),"^",31) ;当日服用
   .s jjflag=$P(^PAQUE1(queid,"DHC"),"^",22) ;急煎
   s questr=jptime_"^"_hhtype_"^"_jzcnt_"^"_jztime_"^"_qzfre_"^"_jceat_"^"_dreat_"^"_jjflag
   q $g(questr)
}

ClassMethod GetArcItmCatByPresc(prescno)
{
 ;w ##class(web.DHCOutPhTQDisp).GetArcItmCatByPresc("O13041800005")
 s ord="",ordsub=""
 s ord=$o(^OEORD(0,"PrescNo",prescno,ord))
 q:ord="" 0
 s ordsub=$o(^OEORD(0,"PrescNo",prescno,ord,ordsub))
 q:ordsub="" 0
 ;s arcitmmast=$p(^OEORD(0,"PrescNo",prescno,ord,ordsub,1),2)
 s arcitmmast=$p(^OEORD(ord,"I",ordsub,1),"^",2)
 s sub=$p(arcitmmast,"||",1)
 s ver=$p(arcitmmast,"||",2)
 s arcic=$p(^ARCIM(sub,ver,1),"^",10  ) q:arcic="" ""
 s ordsubcatcode=$p(^ARC("IC",arcic),"^",1)
 q ordsubcatcode
}

}
