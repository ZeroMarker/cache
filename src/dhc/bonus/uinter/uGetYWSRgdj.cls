/// 采集医务收入数据，包括科室执行收入
/// Zhao LiGuo
/// 2014-06-03
Class dhc.bonus.uinter.uGetYWSRgdj Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// zhaoligu
/// 2014-06026	
/// w ##class(dhc.bonus.uinter.uGetYWSRgdj).GetItemRate("JSJMZG")
ClassMethod GetItemRate(ItemCode As %String) As %String
{
	n (ItemCode)
	s ordRate=0
	s excRate=0
	s ItemPrice=0
	
	i $D(^dhcbsSubItemI("SubsItemCode",ItemCode)) d
	.s itemRowid=""
	.s itemRowid=$O(^dhcbsSubItemI("SubsItemCode",ItemCode,itemRowid))
	.i itemRowid="" d
	..s itemRCode="D"
	.e  d
	..s itemRCode="D" _ itemRowid
	.i $D(^dhcbsSubExpendRateI("sbItem","G1",itemRCode)) d 
	..s rowid=0
	..s rowid=$O(^dhcbsSubExpendRateI("sbItem","G1",itemRCode,rowid))
	..i rowid="" d
	...s orderRate=0
	..e  d
	...s ordRate=$LI(^dhcbsSubExpendRateD(rowid),4) ;开单项目提取比例
	...s excRate=$LI(^dhcbsSubExpendRateD(rowid),6)  ;执行项目提取比例
	...s ItemPrice=$LI(^dhcbsSubExpendRateD(rowid),9)  ;项目单价
	...i ItemPrice'="" d
	....s ItemPrice = ItemPrice
	q ordRate_"^"_excRate_"^"_ItemPrice
}

/// zhaoligu
/// 2014-06026	
/// w ##class(dhc.bonus.uinter.uGetYWSRgdj).GetDeptSupID("H125")
ClassMethod GetDeptSupID(DeptCode As %String) As %String
{
	n (DeptCode)
	s SupDeptID=""
		
	i $D(^dhcbsBonusUnitI("BonusUnitCode",DeptCode)) d
	.s DeptID=""
	.s DeptID=$O(^dhcbsBonusUnitI("BonusUnitCode",DeptCode,DeptID))
	.S SupDeptID=$LI(^dhcbsBonusUnitD(DeptID),6)
	
	q SupDeptID
}

/// w ##class(dhc.bonus.uinter.uGetYWSRgdj).GetYWData("2016-01-01","2016-01-31",1)
ClassMethod GetYWData(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
	;s mSDate="2013-01-01"
	;s mEDate="2013-01-01"
	;s MethodDr=1
	n (mSDate,mEDate,MethodDr)
	q:mSDate="" ""
	q:mSDate="" ""
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	k ^TmpBonusSR
	s sMonth="M"_ Month	
	s YearMonth=Year _"-" _Month
	
	&sql(delete from  dhc_bonus_subs.BonusSubExpendCollect where BonusYear =:Year and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr )
		
	d ..GetIncomdatas(mSDate,mEDate,"ORDDATE")	//住院收入
	d ..GetIncomdatas(mSDate,mEDate,"FlagDate") //门诊收入
	d ..GetOperFee(mSDate,mEDate)               //手术收入
	d ..GetDeptItmjhcfee(mSDate,mEDate)         //出车收入
		
	
	;处理科室收入
	
	s nod="" f  s nod=$o(^TmpBonusSR(nod)) q:nod=""  d
	.;取开单总收入
	.i nod="PatDepIncome" d
	..s LocDr="" f  s LocDr=$o(^TmpBonusSR(nod,YM,LocDr)) q:LocDr=""  d
	...s TARTACDR="" f  s TARTACDR=$o(^TmpBonusSR(nod,YM,LocDr,TARTACDR)) q:TARTACDR=""  d
	....i $d(^CTLOC(LocDr)) s LocCode=$p(^CTLOC(LocDr),"^",1),LocDesc=$p(^CTLOC(LocDr),"^",2)
	....s Totalfee=$g(^TmpBonusSR(nod,YM,LocDr,TARTACDR))
	....s ItemCode="02001",ItemDesc="科室开单收入"
	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:LocDr,:LocDesc,:Year,:sMonth,:Totalfee,getdate(), 0,0,:MethodDr))
 	.;取执行总收入
	.i nod="RecDepIncome" d
	..s LocDr="" f  s LocDr=$o(^TmpBonusSR(nod,YM,LocDr)) q:LocDr=""  d
	...s TARTACDR="" f  s TARTACDR=$o(^TmpBonusSR(nod,YM,LocDr,TARTACDR)) q:TARTACDR=""  d
	....i $d(^CTLOC(LocDr)) s LocCode=$p(^CTLOC(LocDr),"^",1),LocDesc=$p(^CTLOC(LocDr),"^",2)
	....s Totalfee=$g(^TmpBonusSR(nod,YM,LocDr,TARTACDR))
	....i ((LocDr="220")||(LocDr="40")||(LocDr="44")||(LocDr="118")||(LocDr="45")||(LocDr="191")||(LocDr="41")||(LocDr="46")||(LocDr="219"))&&((TARTACDR="4")||(TARTACDR="16")||(TARTACDR="19")) d
	.....s ItemCode="02025",ItemDesc="检查科室材料收入"
	.....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:LocDr,:LocDesc,:Year,:sMonth,:Totalfee,getdate(), 0,0,:MethodDr))
	....e  d
	.....s ItemCode="02002",ItemDesc="科室执行收入"
	.....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:LocDr,:LocDesc,:Year,:sMonth,:Totalfee,getdate(), 0,0,:MethodDr))
 	.;取手术收入
	.i nod="operFee" d
	..s LocDr="" f  s LocDr=$o(^TmpBonusSR(nod,YM,LocDr)) q:LocDr=""  d
	...s TARTACDR="" f  s TARTACDR=$o(^TmpBonusSR(nod,YM,LocDr,TARTACDR)) q:TARTACDR=""  d
	....i $d(^CTLOC(LocDr)) s LocCode=$p(^CTLOC(LocDr),"^",1),LocDesc=$p(^CTLOC(LocDr),"^",2)
	....s operFee=$g(^TmpBonusSR(nod,YM,LocDr,TARTACDR))
	....s ItemCode="02003",ItemDesc="手术收入"
	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:LocDr,:LocDesc,:Year,:sMonth,:operFee,getdate(), 0,0,:MethodDr))
 	.;取出车收入
	.i nod="jhcfee" d
	..s LocDr="" f  s LocDr=$o(^TmpBonusSR(nod,YM,LocDr)) q:LocDr=""  d
	...s TARTACDR="" f  s TARTACDR=$o(^TmpBonusSR(nod,YM,LocDr,TARTACDR)) q:TARTACDR=""  d
	....i $d(^CTLOC(LocDr)) s LocCode=$p(^CTLOC(LocDr),"^",1),LocDesc=$p(^CTLOC(LocDr),"^",2)
	....s jhcfee=$g(^TmpBonusSR(nod,YM,LocDr,TARTACDR))
	....s ItemCode="02015",ItemDesc="出车收入"
	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,'999','急诊司机',:Year,:sMonth,:jhcfee,getdate(), 0,0,:MethodDr))
    q 0
}

ClassMethod GetMothDays(sMonth As %String) As %String
{
	n (sMonth)
	s rtn=30 
	i sMonth="M01" s rtn=31
	i sMonth="M02" s rtn=28
	i sMonth="M03" s rtn=31
	i sMonth="M04" s rtn=30
	i sMonth="M05" s rtn=31
	i sMonth="M06" s rtn=30
	i sMonth="M07" s rtn=31
	i sMonth="M08" s rtn=31
	i sMonth="M09" s rtn=30
	i sMonth="M010" s rtn=31
	i sMonth="M011" s rtn=30
	i sMonth="M012" s rtn=31
	q rtn
}

ClassMethod GetZDDoc(mOeordDr As %String) As %String
{
	s mReturn=""
	q:$g(mOeordDr)="" $g(mReturn)
	s mOrdDr=$p(mOeordDr,"||",1)
	s mOrdSubDr=$p(mOeordDr,"||",2)
	;q:($g(mOrdDr)="")!($g(mOrdSubDr)="") $g(mReturn)	
	s mAnraDr=$p($g(^OEORD(mOrdDr,"I",mOrdSubDr,4)),"^",9)
	q:$g(mAnraDr)="" $g(mReturn)
	;q:'$d(^DHCANOPArrange(mAnraDr)) $g(mReturn)
  	;s Anaestdr=$p($g(^DHCANOPArrange(mAnraDr)),"^",2)
  	s AnPaadmDr=$p(mAnraDr,"||",1)
  	s AnSubDr=$p(mAnraDr,"||",2)
  	s ANAOPChildsubM=0 
  	s ANAOPChildsubM=$o(^OR(AnPaadmDr,"ANA",AnSubDr,"OP",ANAOPChildsubM)) 
  	q:(AnPaadmDr="")!(AnSubDr="")!(ANAOPChildsubM="") $g(mReturn)   
  	s SurgeonDRM=+$p($g(^OR(AnPaadmDr,"ANA",AnSubDr,"OP",ANAOPChildsubM)),"^",8)      ;主刀医生
	q:$g(SurgeonDRM)="" $g(mReturn)
	s mReturn=$g(SurgeonDRM)
	q $g(mReturn)
}

ClassMethod GetConDoc(adm, oeordid) As %String
{
	//  取会诊执行医生接口     add  gsb  20110219
    //w ##class(web.DHCEagleTest).GetConDoc("78787","78763||496")
    s ConDoc="",ConDocId="",ConDocCode="",ConDocDesc=""
    q:$g(oeordid)="" ""
	s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_adm,id)) q:id=""  d
    .s a=^User.DHCConsultationD(id)
    .s OEORIRowId=$listget(a,15)
    .q:OEORIRowId'=oeordid
    .s ConDocId=$listget(a,12)
    .s ReqConDocId=$listget(a,20)
    .i (ConDocId="")&(ReqConDocId'="") s ConDocId=ReqConDocId
    i ConDocId'=""  d 
    .s ConDocCode=$P($g(^CTPCP(ConDocId,1)),"^",1)
    .s ConDocDesc=$P($g(^CTPCP(ConDocId,1)),"^",2)
    s ConDoc=ConDocCode_"^"_ConDocDesc
   q ConDoc
}

ClassMethod GetPatDoc(adm, OrdRowid, itemcat)
{
	s date=$P(^OEORD(+OrdRowid,"I",$p(OrdRowid,"||",2),1),"^",9)
    s time=$P(^OEORD(+OrdRowid,"I",$p(OrdRowid,"||",2),1),"^",10)  
	q:((adm="")!(date="")!(time)="") ""
	s patdoc="",flag="N",patdocstr=""
	s sttdate=""  f  s sttdate=$O(^PAADMi("TransDateTime1",adm,sttdate),-1) q:sttdate=""  d
	.s stttime=""  f  s stttime=$O(^PAADMi("TransDateTime1",adm,sttdate,stttime),-1)  q:stttime=""  d
	..s transubid="" f  s transubid=$O(^PAADMi("TransDateTime1",adm,sttdate,stttime,transubid)) q:(transubid="")!(flag="Y")  d
	...s ctLocid=$P(^PAADM(adm,"TRANS",transubid),"^",6)
	...q:ctLocid=""
	...s ctpdocid=$P(^PAADM(adm,"TRANS",transubid),"^",5)
	...q:ctpdocid=""
	...s patdoc=$p($g(^CTPCP(ctpdocid,1)),"^",1)
	...i patdoc'="" s patdocstr=patdoc
	...q:(date<sttdate)
	...q:(date=sttdate)&(time<stttime)&((itemcat'=63)&(itemcat'=99))
	...;b  ;2
	...i patdoc=""  s patdoc=patdocstr
	...s flag="Y"
	;w !,OrdRowid_"  "_$zd(date,3)_"  "_$zt(time,1)_"  "_patdoc_" "_$g(itemcat)
	q $g(patdoc)
}

/// d ##class(dhc.bonus.uinter.uGetYWSRgdj).GetIncomdatas("2016-01-01","2016-01-01","FlagDate")
ClassMethod GetIncomdatas(mSDate As %String, mEDate As %String, flag As %String)
{
	n (mSDate,mEDate,flag)
	q:mSDate="" ""
	q:mEDate="" ""
	q:flag=""
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s mSDate=$zdh(mSDate,3)
	s mEDate=$zdh(mEDate,3)
	
	f mDate=mSDate:1:mEDate	d
	.;w mDate,!
	.s mWLId=""
	.f  s mWLId=$o(^DHCWorkLoad(0,flag,mDate,mWLId)) q:mWLId=""  d
	..s mRecCTPDocDr="",mResDocDr="",mRecDoc="",mResDoc="",mPatType="",mTarNums="",mRecDoc=""
	..s mPaadmDr=$p(^DHCWorkLoad(mWLId),"^",12)	///	就诊号
    ..q:$g(mPaadmDr)=""
	..q:'$d(^PAADM(mPaadmDr))
	..s mPatType=$p(^DHCWorkLoad(mWLId),"^",4)	/// 病人类型
	..i flag="ORDDATE" Q:mPatType'="I"
	..i flag="FlagDate" Q:($G(mPatType)'="O")&&($G(mPatType)'="E")
	..s mPatDepDr=$p(^DHCWorkLoad(mWLId),"^",23)	///	RecDep_DR^1:执行科室、ResDep_DR^3:病人科室、PatDep_DR^23:下医嘱科室
	..s mRecDepDr=$p(^DHCWorkLoad(mWLId),"^",1)		///	接收科室代码
	..s mTarACDr=$p(^DHCWorkLoad(mWLId),"^",40)	///会计子分类
    ..s mTARTACDR=$p(^DHCTarC("AC",mTarACDr),"^",3) ///会计大类	

 	..i mTARTACDR="15" s mTARTACDR="2"
 	..i mTARTACDR="9" s mTARTACDR="8"
	..s mTotalPrice=$p(^DHCWorkLoad(mWLId),"^",16)	///	总金额
	..q:$g(mTotalPrice)=0
	
	..i (mPatDepDr'="")&&((mTARTACDR'="17")&&(mTARTACDR'="20")&&(mTARTACDR'="21")) d 
	...s ^TmpBonusSR("PatDepIncome",YM,mPatDepDr,mTARTACDR)=$g(^TmpBonusSR("PatDepIncome",YM,mPatDepDr,mTARTACDR))+mTotalPrice
	..i (mRecDepDr'="") d
	...s ^TmpBonusSR("RecDepIncome",YM,mRecDepDr,mTARTACDR)=$g(^TmpBonusSR("RecDepIncome",YM,mRecDepDr,mTARTACDR))+mTotalPrice
}

/// d ##class(dhc.bonus.uinter.uGetYWSRgdj).GetOperFee("2016-01-01","2016-01-01")
ClassMethod GetOperFee(mSDate As %String, mEDate As %String)
{
	n (mSDate,mEDate)
	q:mSDate="" ""
	q:mEDate="" ""
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s sDate=$zdh(mSDate,3)
	s eDate=$zdh(mEDate,3)
	s nod=""
    f date=sDate:1:eDate  d
	.s wlId=""  f  s wlId=$o(^DHCWorkLoad(0,"ORDDATE",date,wlId))  q:wlId=""  d
    ..s oecLoc=$p(^DHCWorkLoad(wlId),"^",23)           ;下医嘱科室
    ..q:(oecLoc'=50)
    ..s admId=$p($g(^DHCWorkLoad(wlId)),"^",12)
    ..s patDep=$p(^DHCWorkLoad(wlId),"^",3)            ;病人科室
    ..i patDep=76 d
    ...s oeori=$p($g(^DHCWorkLoad(wlId)),"^",21)
	...s ord=$p($g(oeori),"||",1)
	...s ordSub=$p($g(oeori),"||",2)
	...q:(ord="")||(ordSub="")
	...s ordDate=$P($G(^OEORD(ord,"I",ordSub,3)),"^",7)     ;下医嘱日期
	...s ordTime=$P($G(^OEORD(ord,"I",ordSub,1)),"^",17)	;下医嘱时间
	...s resDep=$P($G(^OEORD(ord,"I",ordSub,7)),"^",2)	    ;下医嘱科室
	...s ordExe=$o(^OEORD(ord,"I",ordSub,"X",""))
	...i ordExe=""  d
	...e  d
	....s ordDateE=$p($g(^OEORD(ord,"I",ordSub,"X",ordExe)),"^",1)	//要求执行日期
	....s ordTimeE=$p($g(^OEORD(ord,"I",ordSub,"X",ordExe)),"^",2)	//要求执行时间
	....i ((ordDate=$g(ordDateE))&($g(ordTimeE)<ordTime))!((ordDate>$g(ordDateE))) d
	....e  d
 	.....s ordTime=ordTimeE
 	.....s ordDate=ordDateE
    ...s patDep=$$GetCurrentA^DHCWLBuildKPIDataYBSY(admId,ordDate,ordTime,resDep,6,1) ; 获取转科前的科室  
    ..s price=$p(^DHCWorkLoad(wlId),"^",16)
    ..s tarACdr=$p(^DHCWorkLoad(wlId),"^",40)  ;指向DHC_TarAcctCate
    ..s tarTacDr=$p(^DHCTarC("AC",tarACdr),"^",3) ;指向DHC_TarAC
    ..q:((tarTacDr="4")||(tarTacDr="17")||(tarTacDr="20")||(tarTacDr="21"))  ///手术费除去材料收入、药品收入
	..s ^TmpBonusSR("operFee",YM,patDep,tarTacDr)=$g(^TmpBonusSR("operFee",YM,patDep,tarTacDr))+price //手费用术
}

/// d ##class(dhc.bonus.uinter.uGetYWSRgdj).GetDeptItmjhcfee("2016-01-01","2016-01-31")
ClassMethod GetDeptItmjhcfee(mSDate As %String, mEDate As %String)
{
	n (mSDate,mEDate)
	q:mSDate="" ""
	q:mEDate="" ""
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s sDate=$zdh(mSDate,3)
	s eDate=$zdh(mEDate,3)
	f date=sDate:1:eDate  d	
	.s wlId=0 f  s wlId=$o(^DHCWorkLoad(0,"ORDDATE",date,wlId)) q:wlId=""  d
	..s PatDepDr=$p($g(^DHCWorkLoad(wlId)),"^",3)     ;病人科室
	..s itemOrdDr=$p($g(^DHCWorkLoad(wlId)),"^",2)    ;医嘱项
	..i (itemOrdDr="2240||1")||(itemOrdDr="8187||1") d  ;救护车费
	...s fee=$p($g(^DHCWorkLoad(wlId)),"^",16)          ;费用
	...s ^TmpBonusSR("jhcfee",YM,PatDepDr,itemOrdDr)=$g(^TmpBonusSR("jhcfee",YM,PatDepDr,itemOrdDr))+fee
}

/// d ##class(dhc.bonus.uinter.uGetYWSRgdj).GetDeptsDirectCost("2016-01-01","2016-01-31","2")
ClassMethod GetDeptsDirectCost(mSDate As %String, mEDate As %String, MethodDr As %String)
{
	n (mSDate,mEDate,MethodDr)
	q:mSDate="" ""
	q:mEDate="" ""
	q:MethodDr="" ""
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s sMonth="M"_ Month	
	s YearMonth=Year _"-" _Month
	k ^TmpBonusZC("dhchs",YM)
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear =:Year 
	     and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr )
   
  	s stdate="" f stdate=$o(^DHCCAACCOUNTMONTHS(0,"Name",YearMonth,stdate)) q:stdate=""  d
 	.s Rowid="" f  s Rowid=$o(^DHCCABASEDATA(0,"Int",stdate,Rowid)) q:Rowid=""  d 
 	..s BaseDataObj=##class(dhc.ca.cache.data.BaseData).%OpenId(Rowid)
 	..s DeptDr=BaseDataObj.BaseDataservedDeptDr.%Id()
 	..s itemDr=BaseDataObj.BaseDataitemDr.%Id()
 	..q:(itemDr="3")||(itemDr="5")||(itemDr="9")
    ..s debit=BaseDataObj.BaseDatafee 
    ..s ^TmpBonusZC("dhchs",YM,DeptDr,itemDr)=$g(^TmpBonusZC("dhchs",YM,DeptDr,itemDr))+debit	
     ;处理科室支出
    s deptDr="" f  s deptDr=$o(^TmpBonusZC("dhchs",YM,deptDr)) q:deptDr=""  d 
    .s itemDr="" f  s itemDr=$o(^TmpBonusZC("dhchs",YM,deptDr,itemDr)) q:itemDr=""  d 
    ..q:'$d(^DHCCAUNITDEPTS(deptDr))
    ..s deptCode=$p(^DHCCAUNITDEPTS(deptDr),"^",1)
   	..s deptName=$p(^DHCCAUNITDEPTS(deptDr),"^",2)
  	..s datlsDr=##class(dhc.ca.cache.udata.uDataLevelSets).GetLevelItemsParRef("f001",itemDr)
  	..i (datlsDr="10") d
 	...s debit=$g(^TmpBonusZC("dhchs",YM,deptDr,itemDr)) 
 	...s ItemCode="02017",ItemDesc="人员成本"
 	...&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:deptCode,:deptName,:Year,:sMonth,:debit,getdate(), 0,0,:MethodDr))
 	..i (datlsDr="11")||(datlsDr="16") d
 	...s debit=$g(^TmpBonusZC("dhchs",YM,deptDr,itemDr)) 
 	...s ItemCode="02018",ItemDesc="可控成本"
 	...&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:deptCode,:deptName,:Year,:sMonth,:debit,getdate(), 0,0,:MethodDr))
}

/// d ##class(dhc.bonus.uinter.uGetYWSRgdj).GetDepTarAMCCate("2016-01-01","2016-01-31","4")
ClassMethod GetDepTarAMCCate(mSDate As %String, mEDate As %String, MethodDr As %String)
{
	n (mSDate,mEDate,MethodDr)
	q:mSDate="" ""
	q:mEDate="" ""
	q:MethodDr="" ""
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s sMonth="M"_ Month	
	s sDate=$zdh(mSDate,3)
	s eDate=$zdh(mEDate,3)
	s YM=Year_Month
	
	k ^TmpBonusMZSR
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear =:Year 
	     and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr )
	     
	f ordDate=sDate:1:eDate d
 	.s wlRowid=0 f  s wlRowid=$o(^DHCWorkLoad(0,"FlagDate",ordDate,wlRowid)) q:wlRowid=""  d
 	..s type=$p(^DHCWorkLoad(wlRowid),"^",4)        ;病人类型
 	..q:($G(type)'="O")&&($G(type)'="E")
 	..s resLoc=$p(^DHCWorkLoad(wlRowid),"^",23)      ;科室
	..s resdocdr=$p(^DHCWorkLoad(wlRowid),"^",19)    ;医生
	..s taritem=$p(^DHCWorkLoad(wlRowid),"^",22)     ;收费项目
	..s tarACdr=$p(^DHCWorkLoad(wlRowid),"^",40)     ;会计分类
	..s tarTacDr=$p(^DHCTarC("AC",tarACdr),"^",3)    ;指向DHC_TarAC
	..s totalPrice=$p(^DHCWorkLoad(wlRowid),"^",16) ;总费用
	..i tarTacDr="8" d
	...s ^TmpBonusMZSR("zlfee",YM,resLoc,resdocdr)=$g(^TmpBonusMZSR("zlfee",YM,resLoc,resdocdr))+totalPrice
	..i (tarTacDr="1")||(tarTacDr="3")||(tarTacDr="5")||(tarTacDr="12")||(tarTacDr="13")||(tarTacDr="14") d
	...s ^TmpBonusMZSR("tsjcfee",YM,resLoc,resdocdr)=$g(^TmpBonusMZSR("tsjcfee",YM,resLoc,resdocdr))+totalPrice
	..i (tarTacDr="21")&&(resdocdr'="595") d
	...s ^TmpBonusMZSR("zyfee",YM,resLoc,resdocdr)=$g(^TmpBonusMZSR("zyfee",YM,resLoc,resdocdr))+totalPrice
	..i (tarTacDr="10")||(taritem="2231")||(taritem="2232")||(taritem="2233")||(taritem="2234")||(taritem="2235") d
	...s ^TmpBonusMZSR("ghfee",YM,resLoc,resdocdr)=$g(^TmpBonusMZSR("ghfee",YM,resLoc,resdocdr))+totalPrice
	..i tarTacDr="17" d
	...s ^TmpBonusMZSR("xyfee",YM,resLoc,resdocdr)=$g(^TmpBonusMZSR("xyfee",YM,resLoc,resdocdr))+totalPrice
	
	s nod="" f  s nod=$o(^TmpBonusMZSR(nod)) q:nod=""  d
	.i nod="zlfee" d
	..s LocDr="" f  s LocDr=$o(^TmpBonusMZSR(nod,YM,LocDr)) q:LocDr=""  d
	...i $d(^CTLOC(LocDr)) s LocCode=$p(^CTLOC(LocDr),"^",1),LocDesc=$p(^CTLOC(LocDr),"^",2)
	...s DocDr="" f  s DocDr=$o(^TmpBonusMZSR(nod,YM,LocDr,DocDr)) q:DocDr=""  d
	....s Doccode=$p(^CTPCP(DocDr,1),"^",1)
	....s Docname=$p(^CTPCP(DocDr,1),"^",2)
	....s totalPrice=$g(^TmpBonusMZSR(nod,YM,LocDr,DocDr))
	....s ItemCode="02021",ItemDesc="治疗收入"
 	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:Doccode,:Docname,:Year,:sMonth,:totalPrice,getdate(), 0,0,:MethodDr))
 	.i nod="tsjcfee" d
	..s LocDr="" f  s LocDr=$o(^TmpBonusMZSR(nod,YM,LocDr)) q:LocDr=""  d
	...i $d(^CTLOC(LocDr)) s LocCode=$p(^CTLOC(LocDr),"^",1),LocDesc=$p(^CTLOC(LocDr),"^",2)
	...s DocDr="" f  s DocDr=$o(^TmpBonusMZSR(nod,YM,LocDr,DocDr)) q:DocDr=""  d
	....s Doccode=$p(^CTPCP(DocDr,1),"^",1)
	....s Docname=$p(^CTPCP(DocDr,1),"^",2)
	....s totalPrice=$g(^TmpBonusMZSR(nod,YM,LocDr,DocDr))*(0.4)
	....s ItemCode="02024",ItemDesc="特殊检查收入"
 	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:Doccode,:Docname,:Year,:sMonth,:totalPrice,getdate(), 0,0,:MethodDr))
 	.i nod="zyfee" d
	..s LocDr="" f  s LocDr=$o(^TmpBonusMZSR(nod,YM,LocDr)) q:LocDr=""  d
	...i $d(^CTLOC(LocDr)) s LocCode=$p(^CTLOC(LocDr),"^",1),LocDesc=$p(^CTLOC(LocDr),"^",2)
	...s DocDr="" f  s DocDr=$o(^TmpBonusMZSR(nod,YM,LocDr,DocDr)) q:DocDr=""  d
	....s Doccode=$p(^CTPCP(DocDr,1),"^",1)
	....s Docname=$p(^CTPCP(DocDr,1),"^",2)
	....s totalPrice=$g(^TmpBonusMZSR(nod,YM,LocDr,DocDr))*(0.25)
	....s ItemCode="02023",ItemDesc="中草药收入"
 	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:Doccode,:Docname,:Year,:sMonth,:totalPrice,getdate(), 0,0,:MethodDr))
 	.i nod="ghfee" d
	..s LocDr="" f  s LocDr=$o(^TmpBonusMZSR(nod,YM,LocDr)) q:LocDr=""  d
	...i $d(^CTLOC(LocDr)) s LocCode=$p(^CTLOC(LocDr),"^",1),LocDesc=$p(^CTLOC(LocDr),"^",2)
	...s DocDr="" f  s DocDr=$o(^TmpBonusMZSR(nod,YM,LocDr,DocDr)) q:DocDr=""  d
	....s Doccode=$p(^CTPCP(DocDr,1),"^",1)
	....s Docname=$p(^CTPCP(DocDr,1),"^",2)
	....s totalPrice=$g(^TmpBonusMZSR(nod,YM,LocDr,DocDr))
	....s ItemCode="02019",ItemDesc="挂号收入"
 	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:Doccode,:Docname,:Year,:sMonth,:totalPrice,getdate(), 0,0,:MethodDr))
 	.i nod="xyfee" d
	..s LocDr="" f  s LocDr=$o(^TmpBonusMZSR(nod,YM,LocDr)) q:LocDr=""  d
	...i $d(^CTLOC(LocDr)) s LocCode=$p(^CTLOC(LocDr),"^",1),LocDesc=$p(^CTLOC(LocDr),"^",2)
	...s DocDr="" f  s DocDr=$o(^TmpBonusMZSR(nod,YM,LocDr,DocDr)) q:DocDr=""  d
	....s Doccode=$p(^CTPCP(DocDr,1),"^",1)
	....s Docname=$p(^CTPCP(DocDr,1),"^",2)
	....s totalPrice=$g(^TmpBonusMZSR(nod,YM,LocDr,DocDr))
	....s ItemCode="02022",ItemDesc="西药收入"
 	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:Doccode,:Docname,:Year,:sMonth,:totalPrice,getdate(), 0,0,:MethodDr))
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetYWSRgdjS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
