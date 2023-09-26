/// 采集医务收入数据，包括科室执行收入、科室护理收入、医师收入
/// Zhao LiGuo
/// 2013-04-11
Class dhc.bonus.uinter.uGetYWSRData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.uinter.uGetYWSRData).GetYWData("2014-02-01","2014-03-01",1)
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
	s mSDate=$zdh(mSDate,3)
	s mEDate=$zdh(mEDate,3)
	k ^TMPDHCBONUSYW(YM)
	k ^TMPDHCBONUSYW("FPZJ")

	s sMonth="M"_ Month
	
	s YearMonth=Year _"-" _Month
	
	;w "begin "_mSDate_":"_mEDate,! ;
	;w ":"_MethodDr,!
	;&sql(delete from  dhc_bonus_subs.BonusSubExpendCollectDoc where BonusYear=:Year and BonusPeriod=:sMonth )
	
	&sql(delete from  dhc_bonus_subs.workload where YearMonth =:YearMonth )
	s num=0	
	f mDate=mSDate:1:mEDate	d
	.s mWLId=""
	.f  s mWLId=$o(^DHCWorkLoad(0,"ORDDATE",mDate,mWLId)) q:mWLId=""  d
	..s mRecCTPDocDr="",mResDocDr="",mRecDoc="",mResDoc="",mPatType="",mTarNums="",mRecDoc=""
	..s mPaadmDr=$p(^DHCWorkLoad(mWLId),"^",12)	///	就诊号
    ..q:$g(mPaadmDr)=""
	..q:'$d(^PAADM(mPaadmDr))
	..s arcimrowid=$p(^DHCWorkLoad(mWLId),"^",2)
	..s itemcat=$P(^ARCIM(+arcimrowid,$p(arcimrowid,"||",2),1),"^",10)
	..s OrdRowid=$p(^DHCWorkLoad(mWLId),"^",21)
	..s mPatType=$p(^DHCWorkLoad(mWLId),"^",4)	/// 病人类型
	..s mOrdDate=$p($zd(mDate,3),"-",1)_"-"_$p($zd(mDate,3),"-",2)	///	费用日期
	..;s mOrdDate=$zd(mDate,3)	///	费用日期

	..s mAdmDate=$p(^PAADM(mPaadmDr),"^",6)
	..;s mAdmDate=$p($zd(mAdmDate,3),"-",1)_"-"_$p($zd(mAdmDate,3),"-",2)	///	就诊日期
	..s mAdmDate=$zd(mAdmDate,3)	///	就诊日期
	
	..s mARPBill=$p(^DHCWorkLoad(mWLId),"^",20)		///	帐单号
	..s mPatDepDr=$p(^DHCWorkLoad(mWLId),"^",23)	///	开单科室代码
	..s mRecDepDr=$p(^DHCWorkLoad(mWLId),"^",1)		///	接收科室代码
	..s mTarItemDr=$p(^DHCWorkLoad(mWLId),"^",22)	
	..s mTarItemCode=$p(^DHCTARI(mTarItemDr),"^",1) ///	收费项目代码
	..s mTarItemDesc=$p(^DHCTARI(mTarItemDr),"^",2) ///	收费项目名称
	
	..s TarItmEMCCateDr=$p(^DHCTARI(mTarItemDr),"^",16)
	..s:TarItmEMCCateDr'="" TarItmEMCCate=$p(^DHCTarC("EC",TarItmEMCCateDr),"^",1)
	..s mResDocDr=$p(^DHCWorkLoad(mWLId),"^",19)
	..i mResDocDr'="" s mResDoc=$p($g(^CTPCP(mResDocDr,1)),"^",1)   ///	开单大夫代码
	..e  s mResDoc=""
	..;s mRecDocDr=$p(^DHCWorkLoad(mWLId),"^",18)
	..s mRecUserDr=$p($g(^OEORD(+OrdRowid,"I",$p(OrdRowid,"||",2),6)),"^",4)
	..s mRecUserCode=""
	..i mRecUserDr'="" s mRecUserCode=$p($g(^SSU("SSUSR",mRecUserDr)),"^",1)        //update 20111107
	..;i mRecCTPDocDr'="" s mRecDocDr=$p($g(^SSU("SSUSR",mRecCTPDocDr)),"^",14)
	..;e  s mRecDocDr=""
	..///	手术相关费用  执行医生取主刀医生  ch 20110125
	..s mOeOrdDr=$p(^DHCWorkLoad(mWLId),"^",21)
	..s mZDDocDr=..GetZDDoc(mOeOrdDr)
	..s mRecCTPCode=""
	..i $g(mZDDocDr)'="" d
	...;s mRecDocDr=$g(mZDDocDr)
	...////----  ch 20110125
	...i mZDDocDr'="" s mRecCTPCode=$p($g(^CTPCP(mZDDocDr,1)),"^",1)   ///	执行大夫代码
	...e  s mRecCTPCode=""
	..i mRecCTPCode'="" s mRecDoc=mRecCTPCode
	..e  s mRecDoc=mRecUserCode                   //update 2011-11-07
    ..s ConDoc0=""
    ..i arcimrowid="9977||1"  d
	...s ConDoc0=..GetConDoc(mPaadmDr,OrdRowid)
	..s ConDoc0=$p(ConDoc0,"^",1)
	..i ConDoc0'=""  s mRecDoc=ConDoc0
    ..//i mRecDoc="" d
	..//.i mPatType="I"   d 
	..//..s mRecDoc=..GetPatDoc(mPaadmDr,OrdRowid,itemcat)
	..//.e  d
	..//..s patdocid=$P(^PAADM(mPaadmDr),"^",9)
	..//..s mRecDoc=$p($g(^CTPCP(patdocid,1)),"^",1)
	..s mexeflag=""
	..s:mRecDoc'="" mexeflag="1"
	..s marcbillsubdr=$P(^ARCIM(+arcimrowid,$p(arcimrowid,"||",2),1),"^",9)
	..i (mPatType'="I")&(marcbillsubdr="12||1")   d    //update gsb 门诊诊查费取病人医生
	...s patdocid=$P(^PAADM(mPaadmDr),"^",9)
	...s mRecDoc=$p($g(^CTPCP(patdocid,1)),"^",1)
	..//s:mRecDoc="" mRecDoc=mResDoc
	..s mTarNums=$p(^DHCWorkLoad(mWLId),"^",15)		///	医嘱数量
	..s mTotalPrice=$p(^DHCWorkLoad(mWLId),"^",16)	///	总金额
	..;w mTotalPrice_"<-"
	..q:$g(mTotalPrice)=0
	..s num=num+1
	..;w mTotalPrice_"<-"," ",num," ",mARPBill," ",mPaadmDr," ",mOrdDate," ",mAdmDate," ",mPatType," ",mPatDepDr," ",mRecDepDr," ",mTarItemCode," ",mResDoc," ",mTarNums," ",mTotalPrice," ",mexeflag," ",mRecDoc," ",TarItmEMCCate,!

	..s ^TMPDHCENSJX(YM,"YWSRDATA",num)=mARPBill_","_mPaadmDr_","_mOrdDate_","_mAdmDate_","_mPatType_","_mPatDepDr_","_mRecDepDr_","_mTarItemCode_","_mResDoc_","_mTarNums_","_mTotalPrice_","_mexeflag_","_$g(mRecDoc)_","_TarItmEMCCate
	..&sql(insert into dhc_bonus_subs.workload(ItemCode,ItemName, OrdDate, AdmDate, PatType, PatDepDr,RecDepDr,ResDoc,RecDoc,TarNums, TotalPrice,TarItmEMCCate, Flag,UpdateDate,YearMonth) 	values(:mTarItemCode,:mTarItemDesc,:mOrdDate, :mAdmDate, :mPatType, :mPatDepDr,:mRecDepDr,:mResDoc,:mRecDoc,:mTarNums, :mTotalPrice,:TarItmEMCCate, 'PERF2',getdate(),:YearMonth))
	..;------------以下为新增加-------------------------------
	..i mTarItemDr'="" d
	..s ordRate=0
	..s excRate=0
	..s excRate=0
	..s itemDr=0
	..s hlRate=0
	
	..i $D(^dhcbsSubItemI("SubsItemCode",mTarItemCode)) d
	...s itemRowid=""
	...s itemRowid=$O(^dhcbsSubItemI("SubsItemCode",mTarItemCode,itemRowid))
	...i itemRowid="" d
	....s itemRCode="D"
	...e  d
	....s itemRCode="D" _ itemRowid
	...i $D(^dhcbsSubExpendRateI("sbItem","G1",itemRCode)) d 
	....s rowid=0
	....s rowid=$O(^dhcbsSubExpendRateI("sbItem","G1",itemRCode,rowid))
	....i rowid="" d
	.....s orderRate=0
	....e  d
	.....s ordRate=$LI(^dhcbsSubExpendRateD(rowid),4)
	.....s excRate=$LI(^dhcbsSubExpendRateD(rowid),6)
	...s ordprice=mTotalPrice*ordRate
	...s excprice=mTotalPrice*excRate
	
	...s ordTotal=mTotalPrice*1
	...s excTotal=mTotalPrice*0.1
	
	...s CalculateRate=ordRate
	...s ExecuteRate=excRate
	
	...; 执行工作量分
	...i mRecDepDr'="" d
	....s ^TMPDHCBONUSYW(YM,"YWSRDEPT",mRecDepDr)=$G(^TMPDHCBONUSYW(YM,"YWSRDEPT",mRecDepDr))+excprice ;确定用的不是ExecuteRate
	....;&sql(insert into dhc_bonus.test5(f1,f2, f3, f4, f5, f6,f7,f8,f9, f10,f11, f12,f13,f14,f15) values(:mTarItemCode,:mTarItemDesc,:mOrdDate, :mAdmDate, :mPatType, :mPatDepDr,:mRecDepDr,:mResDoc,:mRecDoc,:mTarNums, :mTotalPrice,:TarItmEMCCate, '执行收入',getdate(),:YearMonth))
	
	...; 开单工作量分
	...i mPatDepDr'="" d
	....;w "mRecDepDr"_mPatDepDr,!
	....s ^TMPDHCBONUSYW(YM,"YWSRCALDEPT",mPatDepDr)=$G(^TMPDHCBONUSYW(YM,"YWSRCALDEPT",mPatDepDr))+ordprice
	
		
	...;科室执行收入 
	...i mRecDepDr'="" d
	....;w "mRecDepDr"_mRecDepDr,!
	....s ^TMPDHCBONUSYW(YM,"YWSRDEPTTOTAL",mRecDepDr)=$G(^TMPDHCBONUSYW(YM,"YWSRDEPTTOTAL",mRecDepDr))+excTotal ;确定用的不是ExecuteRate
	....;&sql(insert into dhc_bonus.test5(f1,f2, f3, f4, f5, f6,f7,f8,f9, f10,f11, f12,f13,f14,f15) values(:mTarItemCode,:mTarItemDesc,:mOrdDate, :mAdmDate, :mPatType, :mPatDepDr,:mRecDepDr,:mResDoc,:mRecDoc,:mTarNums, :mTotalPrice,:TarItmEMCCate, '执行收入',getdate(),:YearMonth))
	
	...;科室开单收入
	...;需要新加入	//YWSRCALDEPT 一个标示而已
	...i mPatDepDr'="" d
	....;w "mRecDepDr"_mPatDepDr,!
	....s ^TMPDHCBONUSYW(YM,"YWSRCALDEPTTOTAL",mPatDepDr)=$G(^TMPDHCBONUSYW(YM,"YWSRCALDEPTTOTAL",mPatDepDr))+ordTotal
	

	;q num

	//导入数据前清除
	s sMonth="M"_Month
	;w Year_":"_sMonth_":"_MethodDr,!
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr )

	
	;执行工作量分
	s ResLoc=""
	f  s ResLoc=$o(^TMPDHCBONUSYW(YM,"YWSRDEPT",ResLoc)) q:ResLoc=""  d
	.i $d(^CTLOC(ResLoc)) S ResCode=$p(^CTLOC(ResLoc),"^",1),ResDesc=$p(^CTLOC(ResLoc),"^",2)
	.s itemValue=$G(^TMPDHCBONUSYW(YM,"YWSRDEPT",ResLoc))
	.s ItemCode="02011",ItemDesc="执行工作量分"
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:ResLoc,:ResDesc,:Year, :sMonth,:itemValue,getdate(), 0,0,:MethodDr)
		)

	;开单工作量分？？？？？？？？？？//开单工作量分
	s PatLoc=""
	f  s PatLoc=$o(^TMPDHCBONUSYW(YM,"YWSRCALDEPT",PatLoc)) q:PatLoc=""  d
	.i $d(^CTLOC(PatLoc)) S ResCode=$p(^CTLOC(PatLoc),"^",1),ResDesc=$p(^CTLOC(PatLoc),"^",2)
	.s itemValue=$G(^TMPDHCBONUSYW(YM,"YWSRCALDEPT",PatLoc))
	.s ItemCode="02010",ItemDesc="开单工作量分"
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:PatLoc,:ResDesc,:Year, :sMonth,:itemValue,getdate(), 0,0,:MethodDr)
		)
		
		
	;插入科室执行收入
	s ResLoc=""
	f  s ResLoc=$o(^TMPDHCBONUSYW(YM,"YWSRDEPTTOTAL",ResLoc)) q:ResLoc=""  d
	.i $d(^CTLOC(ResLoc)) S ResCode=$p(^CTLOC(ResLoc),"^",1),ResDesc=$p(^CTLOC(ResLoc),"^",2)
	.s itemValue=$G(^TMPDHCBONUSYW(YM,"YWSRDEPTTOTAL",ResLoc))
	.s ItemCode="01031",ItemDesc="科室执行收入"
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:ResLoc,:ResDesc,:Year, :sMonth,:itemValue,getdate(), 0,0,:MethodDr)
		)

	;插入科室开单收入？？？？？？？？？？
	s PatLoc=""
	f  s PatLoc=$o(^TMPDHCBONUSYW(YM,"YWSRCALDEPTTOTAL",PatLoc)) q:PatLoc=""  d
	.i $d(^CTLOC(PatLoc)) S ResCode=$p(^CTLOC(PatLoc),"^",1),ResDesc=$p(^CTLOC(PatLoc),"^",2)
	.s itemValue=$G(^TMPDHCBONUSYW(YM,"YWSRCALDEPTTOTAL",PatLoc))
	.s ItemCode="01030",ItemDesc="科室开单收入"
	.;w " ItemCode ="_ItemCode_" ItemCode ="_ItemDesc_" ResLoc ="_ResLoc_" ResDesc ="_ResDesc_" Year ="_Year_" sMonth ="_sMonth_" itemValue ="_itemValue_" MethodDr ="_MethodDr,!
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:PatLoc,:ResDesc,:Year, :sMonth,:itemValue,getdate(), 0,0,:MethodDr)
		)
	
			
	
	

	q num
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

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetYWSRDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
