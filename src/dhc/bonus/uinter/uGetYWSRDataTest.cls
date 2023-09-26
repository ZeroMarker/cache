/// 采集医务收入数据，包括科室执行收入
/// Zhao LiGuo
/// 2014-06-03
Class dhc.bonus.uinter.uGetYWSRDataTest Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
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
	..s itemRCode="D"_itemRowid
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

/// w ##class(dhc.bonus.uinter.uGetYWSRgdj).GetYWData("2015-07-01","2015-07-31",2)
/// w ##class(dhc.bonus.uinter.uGetYWSRgdj).GetYWData("2015-06-01","2015-06-30",2)
ClassMethod GetYWData(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
	n (mSDate,mEDate,MethodDr)
	q:mSDate="" ""
	q:mSDate="" ""
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s mSDate=$zdh(mSDate,3)
	s mEDate=$zdh(mEDate,3)
	k ^TempBonusYwsr(YM)	
	s sMonth="M"_ Month
	s YearMonth=Year _"-" _Month

	s num=0	
	f mDate=mSDate:1:mEDate	d
	.;w mDate,!
	.s mWLId=""
	.f  s mWLId=$o(^DHCWorkLoad(0,"ORDDATE",mDate,mWLId)) q:mWLId=""  d
	..s mRecCTPDocDr="",mResDocDr="",mRecDoc="",mResDoc="",mPatType="",mTarNums="",mRecDoc=""
	..s mPaadmDr=$p(^DHCWorkLoad(mWLId),"^",12)	                     ///就诊号
    ..q:$g(mPaadmDr)=""
	..q:'$d(^PAADM(mPaadmDr))
	..;s arcimrowid=$p(^DHCWorkLoad(mWLId),"^",2)
	..;s itemcat=$P(^ARCIM(+arcimrowid,$p(arcimrowid,"||",2),1),"^",10)
	..;s OrdRowid=$p(^DHCWorkLoad(mWLId),"^",21)
	..;s mPatType=$p(^DHCWorkLoad(mWLId),"^",4)	                    /// 病人类型
	..;s mOrdDate=$p($zd(mDate,3),"-",1)_"-"_$p($zd(mDate,3),"-",2)	///费用日期
	..;s mOrdDate=$zd(mDate,3)	///	费用日期
	..;s mAdmDate=$p(^PAADM(mPaadmDr),"^",6)
	..;s mAdmDate=$zd(mAdmDate,3)	                               ///就诊日期
	..;s mARPBill=$p(^DHCWorkLoad(mWLId),"^",20)	                   ///帐单号
	..s mPatDepDr=$p(^DHCWorkLoad(mWLId),"^",23)	               ///RecDep_DR^1:执行科室、ResDep_DR^3:病人科室、PatDep_DR^23:下医嘱科室
	..s mResDepDr=$p(^DHCWorkLoad(mWLId),"^",3)	                   ///病人科室
	..s mRecDepDr=$p(^DHCWorkLoad(mWLId),"^",1)		               ///接收科室代码(执行科室)
	..s mPatDepDR =$p(^DHCWorkLoad(mWLId),"^",23)                   ///开单科室
	..s mPaadmDR =$p(^DHCWorkLoad(mWLId),"^",12)	               ///就诊表ID
	..s mTarOutDR=$p(^DHCWorkLoad(mWLId),"^",44)	               ///门诊分类DHC_TarOut_DR
	..s TarocDR ="",TarocDesc=""
	..q:mTarOutDR=65  //高值耗材不要
	..s:mTarOutDR'="" TarocDR=$p(^DHCTarC("OC",mTarOutDR),"^",3)  ///门诊分类主表ID
	..s:TarocDR'="" TarocDesc=$p(^DHCTarC("TOC",TarocDR),"^",2)   ///门诊分类名称
    ..;s mTarNums=$p(^DHCWorkLoad(mWLId),"^",15)		///	医嘱数量
	..s mTotalPrice=$p(^DHCWorkLoad(mWLId),"^",16)	///	总金额
	..;^PAADM({PA_Adm.PAADM_RowID},"TRANS",{TRANS_Childsub}
	
	..;床位费37、取暖降温费42、诊查费46 如果执行科室是病区，则把费用加到病人科室
	..i (TarocDR=1)||(TarocDR=37)||(TarocDR=42)||(TarocDR=46) d
	...i $p(^CTLOC(mRecDepDr),"^",13)="W" d
	....s excRate = ..GetRate(mResDepDr,TarocDR,"Z")
    ....s ^TempBonusYwsr(YM,"HSSRZX",mResDepDr,TarocDR,TarocDesc_"[执行]")=+$G(^TempBonusYwsr(YM,"HSSRZX",mResDepDr,TarocDR,TarocDesc_"[执行]"))+(mTotalPrice*excRate)
    ...e  d
    ....s excRate = ..GetRate(mRecDepDr,TarocDR,"Z")
    ....s ^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,TarocDR,TarocDesc_"[执行]")=+$G(^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,TarocDR,TarocDesc_"[执行]"))+(mTotalPrice*excRate)
	
	..;手术室的费用用开单科室提，开单提1，然后判断开单科室和执行科室如果不是一个核算单元的，我们
	..;给病人科室提0.2，执行科室提0.8.如果开单科室和执行科室一致，我们给病人科室提1，执行科室不提
	..e  i (TarocDR=43) d
	...s ^TempBonusYwsr(YM,"HSSRKD",mPatDepDr,TarocDR,TarocDesc_"[开单]")=$G(^TempBonusYwsr(YM,"HSSRKD",mPatDepDr,TarocDR,TarocDesc_"[开单]"))+mTotalPrice
	...i +..IsSameUnitByRowId(mPatDepDr_"^"_mRecDepDr)'=0 d
	....s ^TempBonusYwsr(YM,"HSSRKD",mResDepDr,TarocDR,TarocDesc_"[病人]")=$G(^TempBonusYwsr(YM,"HSSRKD",mResDepDr,TarocDR,TarocDesc_"[病人]"))+(mTotalPrice*0.2)
	....s ^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,TarocDR,TarocDesc_"[执行]")=$G(^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,TarocDR,TarocDesc_"[执行]"))+(mTotalPrice*0.2)
	...e  d
	....s ^TempBonusYwsr(YM,"HSSRKD",mResDepDr,TarocDR,TarocDesc_"[病人]")=$G(^TempBonusYwsr(YM,"HSSRKD",mResDepDr,TarocDR,TarocDesc_"[病人]"))+mTotalPrice
	
	..e  d
	...;获取开单计提比例
	...s ordRate = ..GetRate(mResDepDr,TarocDR,"K")
	...;i (TarocDR=43)&('((mRecDepDr=139)||(mRecDepDr=189)||(mRecDepDr=346)||(mRecDepDr=85))) s ordRate=0
	...s ^TempBonusYwsr(YM,"HSSRKD",mResDepDr,TarocDR,TarocDesc_"[开单]")=$G(^TempBonusYwsr(YM,"HSSRKD",mResDepDr,TarocDR,TarocDesc_"[开单]"))+(mTotalPrice*ordRate)
	...q:(TarocDR=43)&((mResDepDr=122)||(mResDepDr=255)||(mResDepDr=50)||(mResDepDr=59)) ;消化内科手术费不双提
	...q:(TarocDR=43)&((mResDepDr=106)||(mResDepDr=147)||(mResDepDr=33)||(mResDepDr=60)) ;消化内科手术费不双提
	...;获取执行计提比例
	...s excRate = ..GetRate(mRecDepDr,TarocDR,"Z")
	...i (TarocDR=43)&('((mRecDepDr=139)||(mRecDepDr=189)||(mRecDepDr=346)||(mRecDepDr=85)||(mRecDepDr=59)||(mRecDepDr=60))) s excRate=0
	...i (mResDepDr=mRecDepDr)&(TarocDR=43) s excRate=0   //(手术费)本科室执行的只计算开单费
	...i $p(^CTLOC(mRecDepDr),"^",13)="W" d 
	....s ^TempBonusYwsr(YM,"HSSRZX",mResDepDr,TarocDR,TarocDesc_"[执行]")=+$G(^TempBonusYwsr(YM,"HSSRZX",mResDepDr,TarocDR,TarocDesc_"[执行]"))+(mTotalPrice*excRate)
	...e  d
	....s ^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,TarocDR,TarocDesc_"[执行]")=+$G(^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,TarocDR,TarocDesc_"[执行]"))+(mTotalPrice*excRate)
    ...i (TarocDR=36)||(TarocDR=46) d  ;挂号费剩余部分(30%)做单项奖
    ....s Proportion = 0.3
    ....s TarocDRTem="DX36" 
    ....i (mRecDepDr=111)||(mRecDepDr=67) s Proportion=0.5,TarocDRTem="DXJZ36"  ;急诊内科、急诊外科挂号费提50%
    ....s ^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,TarocDRTem,TarocDesc_"[执行]")=+$G(^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,TarocDRTem,TarocDesc_"[执行]"))+(mTotalPrice*Proportion)
	...i (mRecDepDr=139)||(mRecDepDr=189)||(mRecDepDr=346)||(mRecDepDr=85) d  ;手术室手术费提10%到病人科室做单项奖，麻醉费提50%到手术室
	....;i (TarocDR=43) d ;手术费单项奖金=执行科室是麻醉科、手术室，计提0.1
	.....;s ^TempBonusYwsr(YM,"HSSRZX",mResDepDr,"DX"_TarocDR,TarocDesc_"[执行]")=+$G(^TempBonusYwsr(YM,"HSSRZX",mResDepDr,"DX"_TarocDR,TarocDesc_"[执行]"))+(mTotalPrice*0.1)
    ....i ((TarocDR=40)&&((mRecDepDr=85)||(mRecDepDr=189))) d ;麻醉费单项=执行科室是麻醉科、手术室，计提0.05
    .....s ^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,"DX"_TarocDR,TarocDesc_"[执行]")=+$G(^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,"DX"_TarocDR,TarocDesc_"[执行]"))+(mTotalPrice*0.05)
	...;59	内镜室(消化),60	内镜室(呼吸),麻醉费
	...i ((mRecDepDr=59)||(mRecDepDr=60))&&(TarocDR=40) d  
	....s ^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,"DX"_TarocDR,TarocDesc_"[执行]")=+$G(^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,"DX"_TarocDR,TarocDesc_"[执行]"))+(mTotalPrice*0.1)
	...;i (TarocDR=38) d  ;护理费提5%做单项奖
	....;s ^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,"DX"_TarocDR,TarocDesc_"[执行]")=+$G(^TempBonusYwsr(YM,"HSSRZX",mRecDepDr,"DX"_TarocDR,TarocDesc_"[执行]"))+(mTotalPrice*0.05)

	//删除已采集的同类数据
    &sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr )
	//开单收入
	s Deptdr = ""
	f  s Deptdr = $O(^TempBonusYwsr(YM,"HSSRKD",Deptdr)) q:Deptdr=""  d
	.s TarocDR =""
	.f  s TarocDR = $O(^TempBonusYwsr(YM,"HSSRKD",Deptdr,TarocDR)) q:TarocDR=""  d
	..s TarocDesc =""
	..f  s TarocDesc = $O(^TempBonusYwsr(YM,"HSSRKD",Deptdr,TarocDR,TarocDesc)) q:TarocDesc=""  d
	...s itemValue = +$G(^TempBonusYwsr(YM,"HSSRKD",Deptdr,TarocDR,TarocDesc))
	...s TempDept=Deptdr      ;下面改变Deptdr的值，会影响循环
	...i ((TarocDR=38)||(TarocDR=45)||(TarocDR=47))&((Deptdr=76)||(Deptdr=113)) s Deptdr = 121  ;20150612 伽马刀 护理费、氧气费、治疗费、加到神经外科
	...s ResDesc=$p(^CTLOC(Deptdr),"^",2)
	...i itemValue '= 0 d
	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:TarocDR,:TarocDesc,:Deptdr,:ResDesc,:Year, :sMonth,:itemValue,getdate(), 0,0,:MethodDr)	)
	....i ((TarocDR=38)||(TarocDR=43)) d ;护理费提5%做单项奖,手术费提10%
	.....s TarocDRDX  ="DX"_TarocDR
	.....i TarocDR=38 s itemValueDX=itemValue*0.05
	.....i TarocDR=43 s itemValueDX=itemValue*0.1
	.....;zlg 20150818 手术室的手术单项奖=只取执行麻醉费的0.05，不取收费费
	.....i (Deptdr=85)||(Deptdr=189) s itemValueDX=itemValue*0
	
	.....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:TarocDRDX,:TarocDesc,:Deptdr,:ResDesc,:Year, :sMonth,:itemValueDX,getdate(), 0,0,:MethodDr)	)
	...s Deptdr=TempDept
	//执行收入
	s Deptdr = ""
	f  s Deptdr = $O(^TempBonusYwsr(YM,"HSSRZX",Deptdr)) q:Deptdr=""  d
	.s TarocDR =""
	.f  s TarocDR = $O(^TempBonusYwsr(YM,"HSSRZX",Deptdr,TarocDR)) q:TarocDR=""  d
	..s TarocDesc =""
	..f  s TarocDesc = $O(^TempBonusYwsr(YM,"HSSRZX",Deptdr,TarocDR,TarocDesc)) q:TarocDesc=""  d
	...s itemValue = +$G(^TempBonusYwsr(YM,"HSSRZX",Deptdr,TarocDR,TarocDesc))
	...s TempDept=Deptdr      ;下面改变Deptdr的值，会影响循环
	...i ((TarocDR=38)||(TarocDR=45)||(TarocDR=47))&((Deptdr=76)||(Deptdr=113)) s Deptdr = 121  ;20150612 伽马刀 护理费、氧气费、治疗费、加到神经外科
	...s ResDesc=$p(^CTLOC(Deptdr),"^",2)
	...i itemValue '= 0 d
	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:TarocDR,:TarocDesc,:Deptdr,:ResDesc,:Year, :sMonth,:itemValue,getdate(), 0,0,:MethodDr))
	....i ((TarocDR=38)||(TarocDR=43)) d ;护理费提5%做单项奖,手术费提10%,麻醉费5%
	.....s TarocDRDX  ="DX"_TarocDR
	.....i TarocDR=38 s itemValueDX=itemValue*0.05
	.....i TarocDR=43 s itemValueDX=itemValue*0.1
	.....q:(Deptdr'=85)
	.....q:(Deptdr'=189) ; ;除去麻醉科室、手术科室
	.....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:TarocDRDX,:TarocDesc,:Deptdr,:ResDesc,:Year, :sMonth,:itemValueDX,getdate(), 0,0,:MethodDr)	)
	
	....i (TarocDR="DX40") d ;麻醉费5%
	.....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:TarocDRDX,:TarocDesc,:Deptdr,:ResDesc,:Year, :sMonth,:itemValueDX,getdate(), 0,0,:MethodDr)	)
	
	
	
	...s Deptdr=TempDept
	q 0
}

/// 通过RowId判断所传入科室是否是同一个奖金核算单元（科室个数可以任意）
/// w ##class(dhc.bonus.uinter.uInterMain).IsSameUnitByRowId("1^2^3")
ClassMethod IsSameUnitByRowId(data) As %String
{
 n (data)
 s temprowid=""
 FOR x=1:1 {
    s RowId = $p(data,"^",x) 
    q:RowId=""
    ;w "x"_x_"="_RowId,!
    s RowId="H"_RowId
    continue:RowId=""
    s SuperRowId=""
    
   	s UnitCode=RowId
   	;w "UnitCode="_UnitCode,!
	i $D(^dhcbsBonusUnitI("BonusUnitCode",UnitCode)) d
	.s rowid=""
	.s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",UnitCode,rowid))
	.;w "rowid="_rowid,!
	.s SuperRowId=$LIST(^dhcbsBonusUnitD(rowid),6)
	.;w RowId_","_SuperRowId,!
	
    continue:SuperRowId=""
    i temprowid="" s temprowid=SuperRowId
    i temprowid'=SuperRowId d
    .s temprowid="NN"
    .q
    
  }
 q:temprowid="NN" 0
 q 1
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

/// 获取开单科室计提比例或执行科室计提比例
/// HisDept:His 科室ID，Class:所要获取比例的项目ID Type:要获取的比例类型 "K"为开单，"Z"为执行
/// w ##class(dhc.bonus.uinter.uGetYWSRgdj).GetRate(4,1,"k")
/// w ##class(dhc.bonus.uinter.uGetYWSRgdj).GetRate(227,90,"k")
ClassMethod GetRate(HisDept, Class, Type)
{
  n (HisDept,Class,Type)
  q:HisDept="" 0
  q:Class="" 0
  q:Type="" 0
  s Rate=0
  ///根据His科室找其在奖金核算单元表中的ID,如果其不再奖金系统中，就不采集这个科室数据
  s HisDept = "H"_HisDept
  s BonusUnitId = "",SuperUnitId=""
  s BonusUnitId = $O(^dhcbsBonusUnitI("BonusUnitCode",HisDept,BonusUnitId)) 
  q:BonusUnitId="" 0
  i BonusUnitId '= "" d
  .s BonusUnitId = "D"_BonusUnitId 
  ;w "aaaa",!
  ;获取开单、执行计提比例
  i $D(^dhcbsSubItemI("SubsItemCode",Class)) d
  .s itemRowid=""
  .s itemRowid=$O(^dhcbsSubItemI("SubsItemCode",Class,itemRowid))
  .i itemRowid="" d
  ..s itemRCode="D"
  .e  d
  ..s itemRCode="D" _ itemRowid
  .;w BonusUnitId_"^"_itemRCode,!
  .;如果单独给此核算单元设置了开单和执行计提比例，则取单独设置的值
  .i $D(^dhcbsSubExpendRateI("sbItem",BonusUnitId,itemRCode)) d 
  ..;w "bbbb"_BonusUnitId_"^"_itemRCode,!
  ..s rowid=0
  ..s rowid=$O(^dhcbsSubExpendRateI("sbItem",BonusUnitId,itemRCode,rowid))
  ..i rowid="" d
  ...;w "bbbb",!
  ...s Rate=0
  ..e  d
  ...i Type="K" s Rate=$LI(^dhcbsSubExpendRateD(rowid),4) ;开单项目提取比例
  ...i Type="Z" s Rate=$LI(^dhcbsSubExpendRateD(rowid),6)  ;执行项目提取比例
  .e  i $D(^dhcbsSubExpendRateI("sbItem",0,itemRCode)) d
  ..;w "cccc"_itemRCode,! 
  ..s rowid=""
  ..s rowid=$O(^dhcbsSubExpendRateI("sbItem",0,itemRCode,rowid))
  ..;w "hh"_rowid,!
  ..i rowid="" d
  ...s Rate=0
  ..e  d
  ...;w $LI(^dhcbsSubExpendRateD(rowid),4),!
  ...i Type="K" s Rate=$LI(^dhcbsSubExpendRateD(rowid),4) ;开单项目提取比例
  ...i Type="Z" s Rate=$LI(^dhcbsSubExpendRateD(rowid),6)  ;执行项目提取比例
  ...;w "jjj"_Rate,!

  q Rate
}

/// 获取外协基金等
/// w ##class(dhc.bonus.uinter.uGetYWSRgdj).GetDxDataWX("2015-05-01","2015-05-31",3)
ClassMethod GetDxDataWX(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
	n (mSDate,mEDate,MethodDr)
	q:mSDate="" ""
	q:mSDate="" ""
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s mSDate=$zdh(mSDate,3)
	s mEDate=$zdh(mEDate,3)
	k ^TempBonusDX(YM)	
	s sMonth="M"_ Month
	s YearMonth=Year _"-" _Month
	f mDate=mSDate:1:mEDate	d
    .s AdmDr = ""
    .f  s AdmDr=$O(^PAADMi("DischDate",mDate,AdmDr)) q:AdmDr=""  d
    ..q:'$d(^PAADM(AdmDr)) 
    ..s DepCodeDR=$p(^PAADM(AdmDr),"^",4) 
    ..s ReasonDr  = $p(^PAADM(AdmDr,1),"^",7)        //获取病人类型表ID
    ..i ReasonDr '="" s PacDesc= $P(^PAC("ADMREA",ReasonDr),"^",2) //病人类型
    ..i PacDesc["自费" d
    ...s Count = ..GetPaCost(AdmDr)
    ...i Count>=2000 d ;w AdmDr_"++"_Count_"++"_ReasonDr,!
    ....s ^TempBonusDX(YM,"DX04053",DepCodeDR)=$G(^TempBonusDX(YM,"DX04053",DepCodeDR))+100
    ....s ^TempBonusDX(YM,"DX04090",DepCodeDR)=$G(^TempBonusDX(YM,"DX04090",DepCodeDR))+200
   	//删除已采集的同类数据
  &sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and (ExpendItemCode ='DX04053' OR ExpendItemCode ='DX04090') )
  s ItemCode = ""
  f  s ItemCode = $O(^TempBonusDX(YM,ItemCode)) q:ItemCode=""  d
  .s Deptdr = ""
  .f  s Deptdr = $O(^TempBonusDX(YM,ItemCode,Deptdr)) q:Deptdr=""  d
  ..s itemValue=+$G(^TempBonusDX(YM,ItemCode,Deptdr))
  ..s ResDesc=$p(^CTLOC(Deptdr),"^",2)
  ..s ItemDesc = "外协基金"
  ..i ItemCode="DX04053" s ItemDesc = "病房收治人次"
  ..i itemValue '= 0 d
  ...;w MethodDr_"^"_Year_"^"_sMonth_"^"_ItemCode_"^"_ItemDesc_"^"_Deptdr_"^"_ResDesc,!
  ...&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:Deptdr,:ResDesc,:Year,:sMonth,:itemValue,getdate(),0,0,:MethodDr))
  
 q SQLCODE
}

/// 获取入院相关的单项奖
/// w ##class(dhc.bonus.uinter.uGetYWSRgdj).GetDxData("2015-06-01","2015-06-30",3)
ClassMethod GetDxData(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
   
	n (mSDate,mEDate,MethodDr)
	q:mSDate="" ""
	q:mSDate="" ""
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s mSDate=$zdh(mSDate,3)
	s mEDate=$zdh(mEDate,3)
	k ^TempBonusDX(YM)	
	s sMonth="M"_ Month
	s YearMonth=Year _"-" _Month
	s Time =0
    s num=0	
    ;^DHCDocIPBK(0,"CreateDateTimeState",{CreateDate},{CreateTime},{CurrentStateID},{RowID})
    ;^DHCDocIPBK(0,"BookingDate",{BookingDate},{RowID})
    ; s IpBookDr=$O(^DHCDocIPBK(0,"BookingDate",mDate,Time,8,IpBookDr)) q:IpBookDr=""  d
    ;f Time=0:1:86399  d
    s count =0
   f mDate=mSDate:1:mEDate	d
   .s IpBookDr="" 
   .f  s IpBookDr=$O(^DHCDocIPBK(0,"BookingDate",mDate,IpBookDr)) q:IpBookDr=""  d
   ..q:'$d(^DHCDocIPBK(IpBookDr)) 
   ..;w IpBookDr,!
   ..s PatDept= $p(^DHCDocIPBK(IpBookDr),"^",13)    //住院病人所在科室
   ..s AdmDr  = $p(^DHCDocIPBK(IpBookDr),"^",2)     //就诊表ID
   ..s EpisodIDTo=$p(^DHCDocIPBK(IpBookDr),"^",3) 
   ..q:EpisodIDTo=""
   ..;w IpBookDr_"++"_EpisodIDTo,!
   ..;i PatDept=106 s count=count+1
   ..s PaadmType = $p(^PAADM(AdmDr),"^",2)          //病人就诊类型 I:住院 O:门诊 E:急诊 H:体检
   ..s PaadmDepDr= $p(^PAADM(AdmDr),"^",4)          //入院科室
   ..s ReasonDr  = $p(^PAADM(AdmDr,1),"^",7)        //获取病人类型表ID
   ..i ReasonDr '="" s PacDesc= $P(^PAC("ADMREA",ReasonDr),"^",2) //病人类型
   ..;i (PaadmDepDr'=111)&(PaadmDepDr'=67)&(PatDept=106) s count=count+1
   ..i (PaadmDepDr'=111)&(PaadmDepDr'=67) s ^TempBonusDX(YM,"DX04051",PatDept)=$G(^TempBonusDX(YM,"DX04051",PatDept))+50
   ..i (PaadmDepDr=111)||(PaadmDepDr=67) s ^TempBonusDX(YM,"DX04052",PatDept)=$G(^TempBonusDX(YM,"DX04052",PatDept))+60
    /*
   ..;i PaadmType = "O" d
   ...;s ^TempBonusDX(YM,"DX04051",PaadmDepDr)=$G(^TempBonusDX(YM,"DX04051",PaadmDepDr))+50
   ...;i (PaadmDepDr=67)||(PaadmDepDr=111) d
   ....;s ^TempBonusDX(YM,"DX04051",PaadmDepDr)=$G(^TempBonusDX(YM,"DX04051",PaadmDepDr))+10
   ....;i PatDept=227  s ^TempBonusDX(YM,"DX04051",PaadmDepDr)=$G(^TempBonusDX(YM,"DX04051",PaadmDepDr))+140
   ..;i PacDesc["自费"  d ;s ^TempBonusDX(YM,"DX04052",PatDept)=$G(^TempBonusDX(YM,"DX04052",PatDept))+300
   ..;s count=+..GetPaCost(AdmDr)
   ..;w AdmDr_"++"_count,!
   ..;i count>1999 d            
   ...;s ^TempBonusDX(YM,"DX04053",PatDept)=$G(^TempBonusDX(YM,"DX04053",PatDept))+100
   ...;s ^TempBonusDX(YM,"DX04090",PatDept)=$G(^TempBonusDX(YM,"DX04090",PatDept))+200
  100块提做为单项奖，200块做为外协基金，这个钱是有前提的（就是出院病人出去药品和材料外其他费用大于等于2000的）*/
  ;w count,!
	//删除已采集的同类数据
  &sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr )
  s ItemCode = ""
  f  s ItemCode = $O(^TempBonusDX(YM,ItemCode)) q:ItemCode=""  d
  .s Deptdr = ""
  .f  s Deptdr = $O(^TempBonusDX(YM,ItemCode,Deptdr)) q:Deptdr=""  d
  ..s itemValue=+$G(^TempBonusDX(YM,ItemCode,Deptdr))
  ..s ResDesc=$p(^CTLOC(Deptdr),"^",2)
  ..s ItemDesc = "入院科室单项"
  ..i ItemCode="DX04051" s ItemDesc = "门诊转住院单项"
  ..i itemValue '= 0 d
  ...;w MethodDr_"^"_Year_"^"_sMonth_"^"_ItemCode_"^"_ItemDesc_"^"_Deptdr_"^"_ResDesc,!
  ...&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:Deptdr,:ResDesc,:Year,:sMonth,:itemValue,getdate(),0,0,:MethodDr))
  
 q SQLCODE
}

/// ^DHCWorkLoad(0,"PAADM",{WorkLoad_PAADM_DR},{WorkLoad_Rowid})
/// 根据病人就诊信息，获取病人费用
ClassMethod GetPaCost(PAADMDR) As %String
{
 n (PAADMDR)
 
 s count=0
 s mWLId=""
 f  s mWLId=$o(^DHCWorkLoad(0,"PAADM",PAADMDR,mWLId)) q:mWLId=""  d
 .s mTarOutDR=$p(^DHCWorkLoad(mWLId),"^",44)	               ///门诊分类DHC_TarOut_DR
 .s TarocDR ="",TarocDesc=""
 .q:mTarOutDR=65  //高值耗材不要  
 .s:mTarOutDR'="" TarocDR=$p(^DHCTarC("OC",mTarOutDR),"^",3)  ///门诊分类主表ID
 .s:TarocDR'="" TarocDesc=$p(^DHCTarC("TOC",TarocDR),"^",2)   ///门诊分类名称
 .s mTotalPrice=$p(^DHCWorkLoad(mWLId),"^",16)	///	总金额
 .q:(TarocDR=1)||(TarocDR=14)||(TarocDR=17)||(TarocDR=18)     //除去材料费和药品费
 .s count=count+mTotalPrice
 q count
}

/// w ##class(dhc.bonus.uinter.uGetYWSRgdj).Test()
ClassMethod Test()
{
   s Deptdr =""
    f  s Deptdr = $O(^TempBonusYwsr(201410,"HSSRKD",Deptdr)) q:Deptdr=""  d
	.w Deptdr,!	
	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus1BEE.uGetYWSRDat9103S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
