/// 采集科室成本不可计价物资
/// Zhao LiGuo
/// 2013-04-15
Class dhc.bonus.uinter.uGetWZLYData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// CreatDate:2011-04-15
/// Description:统计科室领用
/// Table:DHC_InTrans
/// Input:科室领用信息
/// w ##class(dhc.bonus.uinter.uGetWZLYData).GetWZLYData("2013-06-01","2013-06-30",2)
ClassMethod GetWZLYData(dateFrom, dateTo, MethodDr)
{
 //按转移出库时间统计
 ;n (dateFrom,dateTo)
 q:dateFrom="" ""
 q:dateTo="" ""
 s Year=$p(dateFrom,"-",1)
 s Month=$p(dateTo,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s dateFrom=$zdh(dateFrom,3)
 s dateTo=$zdh(dateTo,3)
 
 k ^TMPDHCBONUS(YM,"WZLYDATA")
 s num=0
 &sql(delete from  dhc_bonus.test4)
 f dt=dateFrom:1:dateTo  d
 .s trid=""
 .f  s trid=$o(^DHCINTR(0,"TypeDate","T",dt,trid))  q:trid=""  d
 ..s inclb=$p(^DHCINTR(trid),"^",7)
 ..s pointer=$p(^DHCINTR(trid),"^",9)
 ..s grptype=..GetItmStkGrpType(+inclb)
 ..q:grptype'="M"
 ..s init=+pointer
 ..s chl=$p(pointer,"||",2)
 ..q:'$d(^DHCINIT(init))
 ..s frloc=$p(^DHCINIT(init),"^",5)
 ..s recloc=$p(^DHCINIT(init),"^",6)
 ..q:'$d(^DHCINIT(init,"ITI",chl))
 ..s qty=$p(^DHCINIT(init,"ITI",chl),"^",1)
 ..s truom=$p(^DHCINIT(init,"ITI",chl),"^",7)
 ..s amt=$p(^DHCINIT(init,"ITI",chl),"^",16)
 ..s rp=$p(^DHCINIT(init,"ITI",chl),"^",15)
 ..s buom=$p(^INCI(+inclb,1),"^",10)
 ..s buomdesc=$p(^CT("UOM",buom),"^",2)
 ..s fac=..UOMFac(truom,buom)
 ..s bqty=qty*fac
 ..s brp=rp/fac
 ..s incsc=$p(^INCI(+inclb,2),"^",2)
 ..s stkcat=$p(^INC("SC",incsc),"^",2)
 ..s ordcat=..GetArcItmCat(+inclb)
 ..i ordcat="材料"  d
 ...s billflag="Y"
 ..e  d
 ...s billflag="N"
 ..;q:billflag'="N" ;取不可计价材料
 ..;w "billflag="_billflag,!
 ..s incicode=$p(^INCI(+inclb,1),"^",1)
 ..s incidesc=$p(^INCI(+inclb,1),"^",2)
 
  ..i recloc=11 d ;处理接收科室为"物资供应科"的操作
 ...s a=recloc
 ...s recloc=frloc
 ...s frloc=a
 ...s amt=amt*-1
 
 ..s data=YearMonth_","_recloc_","_stkcat_","_incicode_","_brp_","_buomdesc_","_bqty_","_amt_","_billflag_","_frloc
 ..;&sql(insert into dhc_bonus.test4(f1,f2,f3,f4,f5,f6,f7,f8,f9,f10) values(:YearMonth,:recloc,:stkcat,:incicode,:brp,:buomdesc,:bqty,:amt,:billflag,:frloc))
 ..s num=num+1
 ..i ((recloc'="") && (billflag'="")) d
 ...s ^TMPDHCBONUS(YM,"WZLYDATA",billflag,recloc)=$G(^TMPDHCBONUS(YM,"WZLYDATA",billflag,recloc))+amt
 
 ;---------------------取特殊科室的执行收入----------------------------------
 s PWKZXSR=0,GCKZXSR=0,SBKZXSR=0,FSKZXSR=0,PWBL=0,GCBL=0,SBBL=0,FSBL=0
 s ResLoc=""
	f  s ResLoc=$o(^TMPDHCBONUSYW(YM,"YWSRDEPT",ResLoc)) q:ResLoc=""  d
	.;i $d(^CTLOC(ResLoc)) S ResCode=$p(^CTLOC(ResLoc),"^",1),ResDesc=$p(^CTLOC(ResLoc),"^",2)
	.s itemValue=$G(^TMPDHCBONUSYW(YM,"YWSRDEPT",ResLoc))
	.;w itemValue,!
	.i (ResLoc=39) || (ResLoc=79) || (ResLoc=98) || (ResLoc=99) || (ResLoc=131)  d
	..s PWKZXSR = PWKZXSR+itemValue
	.i (ResLoc=40) || (ResLoc=157)  d
	..s GCKZXSR = GCKZXSR+itemValue
	.i (ResLoc=44) || (ResLoc=75) || (ResLoc=100) || (ResLoc=101) || (ResLoc=135)  d
	..s SBKZXSR = SBKZXSR+itemValue
	.i (ResLoc=193) || (ResLoc=194)|| (ResLoc=195)  d
	..s FSKZXSR = FSKZXSR+itemValue
 i (PWKZXSR+GCKZXSR)'="0"  d
 .s PWBL = PWKZXSR/(PWKZXSR+GCKZXSR)
 .s GCBL = GCKZXSR/(PWKZXSR+GCKZXSR)
 e  d
 .s PWBL=0
 .s GCBL=0
 
 i (PWKZXSR+GCKZXSR)'="0"  d
 .s SBBL = SBKZXSR/(SBKZXSR+FSKZXSR)
 .s FSBL = FSKZXSR/(SBKZXSR+FSKZXSR)
 e  d
 .s SBBL=0
 .s FSBL=0
 ;---------------------以下为新加部分--------------------
 
 s sMonth="M"_Month
 s itemcode="010905"
 &sql(delete from dhc_bonus_subs.BonusSubExpendCollect 
 	where BonusYear=:Year and BonusPeriod=:sMonth  and InterLocMethodID=:MethodDr )

 s ItemCode="010905",ItemDesc="不可计价材料" ;
 ;插入科室不可计价材料
 s sv=0,gysValue=0,blkValue=0,jykValue=0,PWK=0,GCK=0,SBK=0,FSK=0,PWKValue=0,SBKValue=0
 s bflag=""
 f  s bflag=$o(^TMPDHCBONUS(YM,"WZLYDATA",bflag)) q:bflag=""  d
 .s ResLoc=""
 .f  s ResLoc=$o(^TMPDHCBONUS(YM,"WZLYDATA",bflag,ResLoc)) q:ResLoc=""  d
 ..i bflag="N" d  ;取不可计价物资
 ...i $d(^CTLOC(ResLoc)) S ResCode=$p(^CTLOC(ResLoc),"^",1),ResDesc=$p(^CTLOC(ResLoc),"^",2)
 ...s itemValue=$G(^TMPDHCBONUS(YM,"WZLYDATA",bflag,ResLoc))
 ...;i ResLoc'=171 d
 ...q:ResLoc=171 ;产房
 ...q:ResLoc=66  ;检验室
 ...q:ResLoc=65  ;病理科
 ...q:ResLoc=39  ;普外科
 ...q:ResLoc=79
 ...q:ResLoc=98
 ...q:ResLoc=99
 ...q:ResLoc=131
 ...q:ResLoc=44   ;肾病科
 ...q:ResLoc=75
 ...q:ResLoc=100
 ...q:ResLoc=101
 ...q:ResLoc=135
 ...&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:ResLoc,:ResDesc,:Year, :sMonth,:itemValue,getdate(), 0,0,:MethodDr)	)
 ..;CF-产房
 ..i ResLoc=171 d
 ...s sv=sv+$G(^TMPDHCBONUS(YM,"WZLYDATA",bflag,ResLoc))
 ..;供应室
 ..i ResLoc=12 d
 ...s gysValue=gysValue+$G(^TMPDHCBONUS(YM,"WZLYDATA",bflag,ResLoc))
 ..;病理科室全成本ID=65
 ..i ResLoc=65 d
 ...s blkValue=blkValue+$G(^TMPDHCBONUS(YM,"WZLYDATA",bflag,ResLoc))
 ..;检验科室全成本ID=66
 ..i ResLoc=66 d
 ...s jykValue=jykValue+$G(^TMPDHCBONUS(YM,"WZLYDATA",bflag,ResLoc))
 
 ..i bflag="N" d
 ...;普外科全成本ID=131 
 ...i ((ResLoc=131) || (ResLoc=39) || (ResLoc=79) || (ResLoc=98) || (ResLoc=99)) d
 ....s PWKValue=PWKValue+$G(^TMPDHCBONUS(YM,"WZLYDATA","N",ResLoc))
 
 ...;肾病科全成本ID=135
 ...i ((ResLoc=135) || (ResLoc=44) || (ResLoc=75) || (ResLoc=100) || (ResLoc=101)) d
 ....s SBKValue=SBKValue+$G(^TMPDHCBONUS(YM,"WZLYDATA","N",ResLoc))
 
 ;按比例分配
 s PWK= PWKValue*PWBL
 s GCK= PWKValue*GCBL
 S SBK= SBKValue*SBBL
 s FSK= SBKValue*FSBL
 
 //添加产房的科室成本，包括计价和不计价
 s ItemCode="010905",ItemDesc="产房科室成本" ;
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,'171','CF-产房',:Year, :sMonth,:sv,getdate(), 0,0,:MethodDr)	)
 //添加供应室的科室成本，包括计价和不计价
 s ItemCode="09310",ItemDesc="一次性消毒数量" ;
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,'12','供应室',:Year, :sMonth,:gysValue,getdate(), 0,0,:MethodDr)	)
 //添加病理的科室成本，包括计价和不计价
 s ItemCode="010905",ItemDesc="科室材料成本" ;
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,'65','病理科',:Year, :sMonth,:blkValue,getdate(), 0,0,:MethodDr)	)
 //添加检验科的科室成本，包括计价和不计价
 s ItemCode="010905",ItemDesc="科室材料成本" ;
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,'66','检验室',:Year, :sMonth,:jykValue,getdate(), 0,0,:MethodDr)	)

  //添加普外科的科室成本
 s ItemCode="010905",ItemDesc="不可计价物资" ;
 ;w PWK,!
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,'131','普外科',:Year, :sMonth,:PWK,getdate(), 0,0,:MethodDr)	)
 		
 //添加肛肠科的科室成本
 s ItemCode="010905",ItemDesc="不可计价物资" ;
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,'40','肛肠科',:Year, :sMonth,:GCK,getdate(), 0,0,:MethodDr)	)
 		
 //添加肾病科的科室成本
 s ItemCode="010905",ItemDesc="不可计价物资" ;
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,'135','肾病科',:Year, :sMonth,:SBK,getdate(), 0,0,:MethodDr)	)
 		
 //添加风湿科的科室成本
 s ItemCode="010905",ItemDesc="不可计价物资" ;
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,'193','风湿病科',:Year, :sMonth,:FSK,getdate(), 0,0,:MethodDr)	) 


 
	;65 66
	
 q num
}

ClassMethod GetWZLYDatabak(dateFrom, dateTo)
{
  //按转移入库审核时间统计
 ;n (dateFrom,dateTo)
 q:dateFrom="" ""
 q:dateTo="" ""
 s Year=$p(dateFrom,"-",1)
 s Month=$p(dateTo,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 k ^TMPDHCBONUS(YM,"WZLYDATA")
  s dateFrom=$zdh(dateFrom,3)
 s dateTo=$zdh(dateTo,3)
 s num=0
 f dt=dateFrom:1:dateTo  d
 .s trid=""
 .f  s trid=$o(^DHCINTR(0,"TypeDate","K",dt,trid))  q:trid=""  d
 ..s inclb=$p(^DHCINTR(trid),"^",7)
 ..s pointer=$p(^DHCINTR(trid),"^",9)
 ..s grptype=..GetItmStkGrpType(+inclb)
 ..q:grptype'="M"
 ..s init=+pointer
 ..s chl=$p(pointer,"||",2)
 ..q:'$d(^DHCINIT(init))
 ..s recloc=$p(^DHCINIT(init),"^",6)
 ..q:'$d(^DHCINIT(init,"ITI",chl))
 ..s qty=$p(^DHCINIT(init,"ITI",chl),"^",1)
 ..s truom=$p(^DHCINIT(init,"ITI",chl),"^",7)
 ..s amt=$p(^DHCINIT(init,"ITI",chl),"^",16)
 ..s rp=$p(^DHCINIT(init,"ITI",chl),"^",15)
 ..s buom=$p(^INCI(+inclb,1),"^",10)
 ..s buomdesc=$p(^CT("UOM",buom),"^",2)
 ..s fac=..UOMFac(truom,buom)
 ..s bqty=qty*fac
 ..s brp=rp/fac
 ..s incsc=$p(^INCI(+inclb,2),"^",2)
 ..s stkcat=$p(^INC("SC",incsc),"^",2)
 ..s ordcat=..GetArcItmCat(+inclb)
 ..i ordcat="材料"  d
 ...s billflag="Y"
 ..e  d
 ...s billflag="N"
 ..s incicode=$p(^INCI(+inclb,1),"^",1)
 ..s incidesc=$p(^INCI(+inclb,1),"^",2)
 ..
 ..s data=YearMonth_","_recloc_","_stkcat_","_incicode_","_brp_","_buomdesc_","_bqty_","_amt_","_billflag
 ..s num=num+1
 ..i '$d(^TMPDHCBONUS(YM,"WZLYDATA",num))  d
 ...s ^TMPDHCBONUS(YM,"WZLYDATA",num)=data
 ...;w !,^TMPDHCENSJX(YM,"WZLYDATA",num)
 ..e  d
 ...s $p(^TMPDHCBONUS(YM,"WZLYDATA"),",",6)=+$p(^TMPDHCBONUS(YM,"WZLYDATA"),",",6)+bqty
 ...s $p(^TMPDHCBONUS(YM,"WZLYDATA"),",",7)=+$p(^TMPDHCBONUS(YM,"WZLYDATA"),",",7)+amt
 q num
}

ClassMethod GetArcItmCat(inci As %String) As %String
{
 ;n (inci)
 q:inci="" ""
 s arcim=$p(^INCI(inci,1),"^",3)
 s sub=+arcim
 s ver=$p(arcim,"||",2)
 s itemcat=$p(^ARCIM(sub,ver,1),"^",10)
 q:itemcat="" ""
 s ordcat=$p(^ARC("IC",itemcat),"^",8)
 q:ordcat="" ""
 s desc=$p(^OEC("ORCAT",ordcat),"^",2) 
 q desc
}

/// Creator:ZhangDongMei;
/// CreatDate:2009-2-12
/// Description:库存项对应的类组类型：D,M
/// Table:DHC_StkCatGroup
/// Input:库存项id
/// Return:
ClassMethod GetItmStkGrpType(inciid As %String) As %String
{
 ;n (inciid)
 q:inciid="" ""
 s itmcat=$p(^INCI(inciid,2),"^",2)
 q:itmcat="" ""
 s scgid=$o(^DHCSCG("STKCAT",itmcat,""))
 q:scgid="" ""
 s scgtype=$p(^DHCSCG(scgid),"^",3)
 q $g(scgtype)
}

ClassMethod UOMFac(fr As %String, to As %String) As %String
{
 ;n (fr,to)
 q:fr=to 1    ;if from-uom is as same as to-uom then return 1
 s rowid=""
 s rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid)) 
 i rowid'="" d       
 .s fac=$p(^CT("CTCF",rowid),"^",3)
 .s fac=$p(fac,$c(1))
 e  d
 .s fac=1
 q $g(fac)
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetWZLYDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
