Import SQLUser

Class web.DHCOutPrescComments Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 任晓娜 增加 Query
/// 查询并显示所有门诊处方
/// 护士已经执行过的？
/// 遍历门诊发药表，以及发药子表，孙表呢？查出所有处方。
/// d ##class(%ResultSet).RunQuery("web.DHCOutPrescComments","MZCF","2008-07-15","2008-07-18")
ClassMethod MZCFExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, CDoctorName As %String, Alias As %String, RandNum As %String, RandPer As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	q:StartDate="" $$$OK
 	q:EndDate="" $$$OK
 	k ^TMP("DHCST",$zn,"MZCF",repid)
 	s RandNum=+RandNum
 	s RandPer=+RandPer
 	q:(RandNum'>0)&((RandPer'>0)!(RandPer>50)) $$$OK
 	i RandPer'=0 d
 	.s RandPer=RandPer/100
 	s iNum=-1
 	s oNum=0
 	s sd=StartDate
 	s ed=EndDate
    s presccRowid=""
    s LastPres=""
	f dd=sd:1:ed  d
	.s phdRowID=0
	.s LocDr=0
	.f  s LocDr=$o(^DHCPHDISPi(dd,LocDr)) q:LocDr=""  d
	..f  s phdRowID=$o(^DHCPHDISPi(dd,LocDr,phdRowID)) q:phdRowID=""  d
	...s phdiRowId=0
	...;只显示已经发药的处方
	...s fyFlag=$p(^DHCPHDISP(phdRowID),"^",4)
	...Q:fyFlag'=1
	...f  s phdiRowId=$o(^DHCPHDI(phdRowID,"PHDI",phdiRowId)) q:phdiRowId=""  d
	....q:'$d(^DHCPHDI(phdRowID,"PHDI",phdiRowId))
	....s oeoriDR=$p(^DHCPHDI(phdRowID,"PHDI",phdiRowId),"^",5)  //OE_OrdItem
	....s ord=$p(oeoriDR,"||",1)  //医嘱表
	....s chl=$p(oeoriDR,"||",2)  //医嘱明细表
	....s adm=$p(^OEORD(ord),"^",1)     //PA_Adm
	..../// 登记号
	....S pat=##class(web.DHCSTPIVA).GetPat(adm)
	....S ipno=$P(pat,"^",1)
	....s durdesc=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",3) ;用药疗程
	....s instrdr=$p(^OEORD(ord,"I",chl,2),"^",7)
	....i instrdr="" s instr="*"
	....e  s instr=$p(^PHCIN(instrdr),"^",2)
	....i $f(instr,"-") s instr=$p(instr,"-",2)					;用法
	....s qty=$p(^DHCPHDI(phdRowID,"PHDI",phdiRowId),"^",4)   //门诊发药量=总量
	....s admDoctorDR=$p(^PAADM(adm),"^",9)
	....s papersonDR=$p(^PAADM(adm,1),"^",21)  //PA_Person的rowid
	....s doctor=..getOrdDoctor(ord_"||"_chl) //开方医生
	....Q:(CDoctorName'="")&(doctor'=CDoctorName)
	....S papmi=$p(^PAADM(adm),"^",1)
    ....S TPAPMIAllergy=""  //##class(web.DHCSTPIVA).GetPAAllergyStr(papmi,"") //过敏史
	....s paname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
    ....s pasex=$p(^PAPER(papmi,"ALL"),"^",7 ) 
    ....i pasex'="" s pasex=$p(^CT("SEX",pasex),"^",2)  ;性别
    ....s dob=$p(^PAPER(papmi,"ALL"),"^", 6)
    ....s paage=$fn(((+$h)-dob)/365,"",0)       ;年龄
	....s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	....;已经点评过的处方，不再这里显示
	....Q:$o(^DHCPRESCC(0,"PRESC","PRESCNO",prescno,presccRowid))'=""
	....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	....s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	....s catGrp=..GetIncStkCatGrp(inci)
	....q:catGrp="ZCY"	//中草药处方不显示
	....s inciDesc=$p(^INCI(inci,1),"^",2)
	....;Q:(Alias'="")&(inciDesc'=Alias)
	....s ifcontain=..IfContainAlias(prescno,Alias)  //如果包含了查询条件的处方,那么都显示整个处方的所有药品.
	....Q:ifcontain=0
	....s OrderFreqRowid=$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    ....s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2) ;
    ....;任晓娜 11月11日 光棍节 增加地坛的需求  频率
    ....s freq=""
    ....i OrderFreqRowid'="" s freq=$p($g(^PHCFR(OrderFreqRowid)),"^",3)  ;频率
    ....;任晓娜 增加完毕
    ....s OrderDurRowid=$p($g(^OEORD(ord,"I",chl,2)),"^",6) ;OEORI_Durat_DR
    ....s OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2) ;
    ....s NumTimes=OrderFreqFactor*OrderDurFactor ;频次
	....s dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) ;剂量
	....s doseuom=""
	....s dosuomID=$p(^OEORD(ord,"I",chl,2),"^",3)
	....i dosuomID'="" d
	.....s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	....i adm'="" s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") //诊断
	....s doctorlocdr=$p(^OEORD(ord,"I",chl,7),"^",2)
    ....s doctorloc=$p(^CTLOC(doctorlocdr),"^",2)   //科室
    ....s Data1=$lb(prescno,oeoriDR,inciDesc,dosage,doseuom,doctor,diagnose,doctorloc,TPAPMIAllergy,ipno,paname,pasex,paage,durdesc,instr,qty,freq)
    ....s oNum=oNum+1
    ....i prescno'=LastPres d
    .....s iNum=iNum+1
    ....s ^TMP("DHCST",$zn,"MZCF",repid,iNum,oNum)=Data1
    ....s LastPres=prescno
    ....//Do OutputRow
    q:iNum=-1 $$$OK
    q:iNum=0 $$$OK	///只有一条数据
    i (RandNum=0)&(RandPer'=0) s RandNum=iNum*RandPer
    s RandNum=+$p(RandNum,".",1)
    i (RandNum/iNum)>0.5 s RandNum=+$p(iNum/2,".",1)
    q:RandNum=0 $$$OK
    s maxRandNum=iNum+1
    s minRandNum=maxRandNum-RandNum+1
    f i=maxRandNum:-1:minRandNum d
    .s x=$R(i)
    .s y=""
    .f  s y=$o(^TMP("DHCST",$zn,"MZCF",repid,x,y)) q:y=""  d
    ..s Data=^TMP("DHCST",$zn,"MZCF",repid,x,y)
    ..d OutputRow
    .k ^TMP("DHCST",$zn,"MZCF",repid,x)
    .m ^TMP("DHCST",$zn,"MZCF",repid,x)=^TMP("DHCST",$zn,"MZCF",repid,i-1)
    k ^TMP("DHCST",$zn,"MZCF",repid)
    Quit $$$OK
OutputRow
	//set Data=$lb(prescno,oeoriDR,inciDesc,dosage,doseuom,doctor,diagnose,doctorloc,TPAPMIAllergy,ipno,paname,pasex,paage,durdesc,instr,qty,freq)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

Query MZCF(StartDate As %String, EndDate As %String, CDoctorName As %String, Alias As %String, RandNum As %String, RandPer As %String) As %Query(ROWSPEC = "Tprescno:%String,ToeoriDR:%String,TinciDesc:%String,Tdosage:%String,Tdoseuom:%String,Tdoctor:%String,Tdiagnose:%String,Tdoctorloc:%String,TTPAPMIAllergy:%String,Tipno:%String,Tpaname:%String,Tpasex:%String,Tpaage:%String,Tdurdesc:%String,Tinstr:%String,Tqty:%String,Tfreq:%String")
{
}

ClassMethod MZCFFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MZCFExecute ]
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

ClassMethod MZCFClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MZCFExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 任晓娜 增加 Query2
/// 查询已经点评过的处方，按照合格和不合格来选择
/// 并且要显示出不合格的原因。
/// 遍历门诊发药表，以及发药子表，孙表呢？查出所有处方。
/// d ##class(%ResultSet).RunQuery("web.DHCOutPrescComments","MZCF","2008-07-15","2008-07-18")
ClassMethod MZCFSearchExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, SelectYes As %String, SelectNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

 	q:StartDate="" $$$OK
 	q:EndDate="" $$$OK
 	 		
 	s sd=StartDate //  $zdh(StartDate,4)
 	s ed=EndDate  //$zdh(EndDate,4)	
    //s tmpPrescno="0"
    s presccRowid=""
	;f  s phdRowID=$o(^DHCPHDISP(phdRowID)) q:phdRowID=""  d
	f dd=sd:1:ed  d
	.s phdRowID=0
	.s LocDr=0
	.f  s LocDr=$o(^DHCPHDISPi(dd,LocDr)) q:LocDr=""  d
	..f  s phdRowID=$o(^DHCPHDISPi(dd,LocDr,phdRowID)) q:phdRowID=""  d
	...;b //1
	...s phdiRowId=0
	...f  s phdiRowId=$o(^DHCPHDI(phdRowID,"PHDI",phdiRowId)) q:phdiRowId=""  d
	....;s cfNo=$p(^DHCPHDI(phdRowID,"PHDI",phdiRowId),"^",9)
	....;b //2
	....//q:'$d(^DHCPHDI(phdRowID,"PHDI",phdiRowId))
	....//s papmiDR=$p(^DHCPHDI(phdRowID,"PHDI",phdiRowId),"^",2)  //PA_PatMas 居然字段为空
	....//s adm=$o(^PAPERdr(papmiDR,"ADM","O",adm))  //PA_Adm
	....q:'$d(^DHCPHDI(phdRowID,"PHDI",phdiRowId))
	....s oeoriDR=$p(^DHCPHDI(phdRowID,"PHDI",phdiRowId),"^",5)  //OE_OrdItem
	....
	....s ord=$p(oeoriDR,"||",1)  //医嘱表
	....s chl=$p(oeoriDR,"||",2)  //医嘱明细表
	
	....s adm=$p(^OEORD(ord),"^",1)     //PA_Adm
	..../// 登记号
	....S pat=##class(web.DHCSTPIVA).GetPat(adm)
	....S ipno=$P(pat,"^",1)
	....s durdesc=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",3) ;用药疗程
	....s instrdr=$p(^OEORD(ord,"I",chl,2),"^",7)
	....i instrdr="" s instr="*"
	....e  s instr=$p(^PHCIN(instrdr),"^",2)
	....i $f(instr,"-") s instr=$p(instr,"-",2)					;用法
	....s qty=$p(^DHCPHDI(phdRowID,"PHDI",phdiRowId),"^",4)   //门诊发药量=总量
	....
	....s admDoctorDR=$p(^PAADM(adm),"^",9)
	....s papersonDR=$p(^PAADM(adm,1),"^",21)  //PA_Person的rowid
	....s doctor=$p(^CTPCP(admDoctorDR,1),"^",2)  //CT_CareProv  医生
	....S papmi=$p(^PAADM(adm),"^",1)
    ....S TPAPMIAllergy=""  //##class(web.DHCSTPIVA).GetPAAllergyStr(papmi,"") //过敏史
	....
	....s paname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
    ....s pasex=$p(^PAPER(papmi,"ALL"),"^",7 ) 
    ....i pasex'="" s pasex=$p(^CT("SEX",pasex),"^",2)  ;性别
    ....s dob=$p(^PAPER(papmi,"ALL"),"^", 6)
    ....s paage=$fn(((+$h)-dob)/365,"",0)       ;年龄
	....
	....;s inclbDR=$p(^DHCPHDI(phdRowID,"PHDI",phdiRowId),"^",1)   //INC_ItmLcBt
	....s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	....;只显示点评过的处方
	....Q:$o(^DHCPRESCC(0,"PRESC","PRESCNO",prescno,0))=""
	....s presccRowid=$o(^DHCPRESCC(0,"PRESC","PRESCNO",prescno,0))
	....s reason=""
	....s reasonDR=$p(^DHCPRESCC(presccRowid),"^",7)
	....Q:(SelectYes="on")&(SelectNo="")&(reasonDR'="")  ;合格
	....Q:(SelectYes="")&(SelectNo="on")&(reasonDR="")   ;不合格
	....;Q:(SelectYes="on")&(SelectNo="on")               ;全部显示
	....Q:(SelectYes="")&(SelectNo="")                   ;全部不显示
	....i reasonDR'="" d
	.....s reason="不合格:"_$p(^DHCCOMM(reasonDR),"^",1)
	....e  d
	.....s reason="合格"
	....//s ^NANA("prescno"_phdRowID_"||"_phdiRowId)=prescno_"TMPPRE:"_tmpPrescno
	....;i tmpPrescno=prescno  d
	.....;s tmpPrescno=prescno
	.....;s prescno=""  //一样的处方号不显示
	....;e  d
	.....;s tmpPrescno=prescno
	....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	....s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	....s inciDesc=$p(^INCI(inci,1),"^",2)
	....
	....s OrderFreqRowid=$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    ....s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2) ;
    ....s OrderDurRowid=$p($g(^OEORD(ord,"I",chl,2)),"^",6) ;OEORI_Durat_DR
    ....s OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2) ;
    ....s NumTimes=OrderFreqFactor*OrderDurFactor ;频次
	....s dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) ;剂量
	....s doseuom=""
	....s dosuomID=$p(^OEORD(ord,"I",chl,2),"^",3)
	....i dosuomID'="" d
	.....s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	....i adm'="" s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") //诊断
	....s doctorlocdr=$p(^OEORD(ord,"I",chl,7),"^",2)
    ....s doctorloc=$p(^CTLOC(doctorlocdr),"^",2)   //科室
	....//s ctlocDR=$p(^DHCPHDI(phdRowID,"PHDI",phdiRowId),"^",7)  //CT_Loc 就诊科室
	....//s uom=$p(^DHCPHDI(phdRowID,"PHDI",phdiRowId),"^",8)   // CT_UOM 单位
    ....Do OutputRow2
    
    Quit $$$OK
 	
OutputRow2
	set Data=$lb(prescno,oeoriDR,inciDesc,dosage,doseuom,doctor,diagnose,doctorloc,TPAPMIAllergy,ipno,paname,pasex,paage,durdesc,instr,qty,reason)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

Query MZCFSearch(StartDate As %String, EndDate As %String, SelectYes As %String, SelectNo As %String) As %Query(ROWSPEC = "Tprescno:%String,ToeoriDR:%String,TinciDesc:%String,Tdosage:%String,Tdoseuom:%String,Tdoctor:%String,Tdiagnose:%String,Tdoctorloc:%String,TTPAPMIAllergy:%String,Tipno:%String,Tpaname:%String,Tpasex:%String,Tpaage:%String,Tdurdesc:%String,Tinstr:%String,Tqty:%String,Treason:%String")
{
}

ClassMethod MZCFSearchFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MZCFSearchExecute ]
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

ClassMethod MZCFSearchClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MZCFSearchExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 任晓娜
/// 用户点评合格或者不合格的时候，对表中插入点评记录。
ClassMethod InsComments(prescNo As %String, person As %String, result As %String, reason As %String) As %String
{
 k PLIST
 //f i=0:1:13 s PLIST(i)=""
 //s ch=$o(^INRQ(reqrowid,"RQI",""),-1)+1
 ;
 s orda=0
 s PLIST(1) = "" //rowid
 s orda=$o(^OEORD(0,"PrescNo",prescNo,orda))
 s oeoriDate=$p(^OEORD(orda),"^",2) //医嘱日期
 s PLIST(2) = +$h           //commentsDate
 s PLIST(3) = person //
 s PLIST(4) = reason
 s PLIST(5) = result
 s PLIST(6) = $p($h,",",2)  //commentsTime
 s PLIST(7) = oeoriDate
 s PLIST(8) = prescNo

 &sql(insert into DHC_PrescComments values :PLIST() ) ;
 q SQLCODE
}

//Query OperReason(stype) As %SQLQuery(CONTAINID = 1)

//{

//SELECT PCR_CommentsReason,DHC_CommentsReason_RowID FROM DHC_CommentsReason

//}

/// 不合格的原因
ClassMethod getOrdDoctor(oeori) As %String
{
  ;开单医生,2007-07-23,zdm
  n (oeori)
  q:oeori="" ""
  
  s docdr=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),7)),"^",1)
  q:docdr="" ""
  s doctor=$p(^SSU("SSUSR",docdr),"^",2)
  q doctor
}

/// 任晓娜
/// 增加。判断处方号，下的所有药品，是否含有查询条件中包含的那一个药品，
/// 若包含，返回1，则表示该处方所有药品都显示；若不包含，返回0，则表示该处方所有药品都不显示。
ClassMethod IfContainAlias(prescNumber, AliasDesc) As %String
{
    q:AliasDesc="" 1
    s sameNumber=0
    s phdRowIDa=0
	f  s phdRowIDa=$o(^DHCPHDISPi("PRESCNO",prescNumber,phdRowIDa)) q:phdRowIDa=""  d
	.s phdiRowIda=0
	.;只显示已经发药的处方
	.s fyFlaga=$p(^DHCPHDISP(phdRowIDa),"^",4)
	.Q:fyFlaga'=1
	.f  s phdiRowIda=$o(^DHCPHDI(phdRowIDa,"PHDI",phdiRowIda)) q:phdiRowIda=""  d
	..s oeoriDRa=$p(^DHCPHDI(phdRowIDa,"PHDI",phdiRowIda),"^",5)  //OE_OrdItem
	..s orda=$p(oeoriDRa,"||",1)  //医嘱表
	..s chla=$p(oeoriDRa,"||",2)  //医嘱明细表
	..s arcimida=$p(^OEORD(orda,"I",chla,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s incia=$o(^INCI(0,"ARCIM_DR",$p(arcimida,"||",1),"") ) q:incia=""  //医嘱名称
	..s inciDesca=$p(^INCI(incia,1),"^",2)
	..;Q:(Alias'="")&(inciDesc'=Alias)
	..i (AliasDesc'="")&(inciDesca=AliasDesc) s sameNumber=1
	..i (AliasDesc="") s sameNumber=1
	q sameNumber
}

/// Creator:	zhouyg
/// CreatDate:	2011-11-22
/// Description:获得库存项的类组信息
/// Table:		INC_Itm，DHC_StkCatGrpRelations
/// Input:		库存项ID
/// Return:		类组代码
ClassMethod GetIncStkCatGrp(InciID) As %String
{
	 n (InciID)
	 Q:InciID="" ""
	 s inccatID=$p($g(^INCI(InciID,2)),"^",2)
	 q:inccatID="" ""
	 s scgID=$o(^DHCSCG("STKCAT",inccatID,""))
	 q:scgID="" ""
	 s scgcode=$p(^DHCSCG(scgID),"^",1)
	 q scgcode
}

ClassMethod OperReasonExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	s ReasonID="0"
 	f  s ReasonID=$o(^DHCCOMM(ReasonID)) q:ReasonID=""  d
    .s ReasonDesc=$p(^DHCCOMM(ReasonID),"^",1)
    .set Data=$lb(ReasonID,ReasonDesc)
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
    Quit $$$OK
}

Query OperReason() As %Query(ROWSPEC = "tbReasonID:%String,tbReasonDesc:%String")
{
}

ClassMethod OperReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OperReasonExecute ]
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

ClassMethod OperReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OperReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
