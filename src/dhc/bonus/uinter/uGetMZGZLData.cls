Class dhc.bonus.uinter.uGetMZGZLData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 门诊工作量接口
/// w ##class(dhc.bonus.uinter.uGetMZGZLData).GetMZGZLData("2013-03-02","2013-03-2","3")
ClassMethod GetMZGZLData(sttdate As %String, enddate As %String, sMethodDr As %String) As %String
{
	n (sttdate,enddate,sMethodDr)
	s MethodDr=sMethodDr
    s CurrentDate=sttdate
	s CurrentY=$p(CurrentDate,"-",1) 
	s CurrentM=$p(CurrentDate,"-",2)
	s CurrentD=$p(CurrentDate,"-",3)
	s YMD=CurrentY_CurrentM_CurrentD
	s Month= "M"_CurrentM
	
	s sttdate=$zdh(sttdate,3)
    s enddate=$zdh(enddate,3)
    
 
 	k ^TMPBONUSMZGZL
 	k ^TMPBONUSMZSF
  	f pdate=sttdate:1:enddate d
  	.s hisDr=""
  	.f  s hisDr=$o(^DHCOPInsFootI(0,"Date",pdate,hisDr)) q:hisDr=""  d //结算表
  	..q:'$d(^DHCOPInsFoot(hisDr))
  	..s footInfo=$g(^DHCOPInsFoot(hisDr))
  	..s footUser=$p(footInfo,"^",8) ;HIS_User 结算人
  	..s footDate=$p(footInfo,"^",2) ;HIS_Date 结算日期
  	..s prtDr=""
  	..f  s prtDr=$o(^DHCINVPRT(0,"Report",hisDr,prtDr)) q:prtDr=""  d
  	...q:'$d(^DHCINVPRT(prtDr))
  	...s invInfo=$g(^DHCINVPRT(prtDr))
  	...s prtFairType=$p(invInfo,"^",34)   ;PRT_FairType(F:收费，R:挂号)
  	...s prtUser=$p(invInfo,"^",21)   ;PRT_Usr 收费员
  	...s userCode=$p(^SSU("SSUSR",prtUser),"^",1)
  	...s prtFlag=$p(invInfo,"^",8)      ;PRT_Flag 发票状态
  	...s prtInvNO=$p(invInfo,"^",14)    ;PRT_inv   发票号
  	...s prtInitDr=$p(invInfo,"^",13)   ;PRT_initInv_DR  指向被作废或红冲的发票Rowid
  	...s prtAcount=$p(invInfo,"^",1)
 	...i ((prtFlag="N")&(prtFairType="F")) s ^TMPBONUSMZGZL(pdate,userCode,1)=+$g(^TMPBONUSMZGZL(pdate,userCode,1))+1
  	...i ((prtFlag'="N")&(prtInitDr="")&(prtFairType="F")) s ^TMPBONUSMZGZL(pdate,userCode,1)=+$g(^TMPBONUSMZGZL(pdate,userCode,1))+1
  	...i ((prtFlag'="N")&(prtInitDr'="")&(prtFairType="F")) s ^TMPBONUSMZGZL(pdate,userCode,2)=+$g(^TMPBONUSMZGZL(pdate,userCode,2))+1
  
  	...i ((prtFlag="N")&(prtInitDr="")&(prtFairType="R")) s ^TMPBONUSMZGZL(pdate,userCode,3)=+$g(^TMPBONUSMZGZL(pdate,userCode,3))+1
  	...i ((prtFlag'="N")&(prtInitDr="")&(prtFairType="R")) s ^TMPBONUSMZGZL(pdate,userCode,3)=+$g(^TMPBONUSMZGZL(pdate,userCode,3))+1
  	...i ((prtFlag'="N")&(prtInitDr'="")&(prtFairType="R")) s ^TMPBONUSMZGZL(pdate,userCode,4)=+$g(^TMPBONUSMZGZL(pdate,userCode,4))+1

	k ^TMPBONUSMZGZL(YMD,"MZGZLDATA")
  	s prtDate="",num=0
  	f  s prtDate=$o(^TMPBONUSMZGZL(prtDate)) q:prtDate=""  d 
  	.;s HandDate=$zd(prtDate,3)
  	.;s prtDate=$o(^TMPBONUSMZGZL(prtDate))
  	.s userCode=""
  	.f  s userCode=$o(^TMPBONUSMZGZL(prtDate,userCode)) q:userCode=""  d
  	..s SInvNum=+$g(^TMPBONUSMZGZL(prtDate,userCode,1))
  	..s TInvNum=+$g(^TMPBONUSMZGZL(prtDate,userCode,2))
  	..s SRegNum=+$g(^TMPBONUSMZGZL(prtDate,userCode,3))
  	..s TRegNum=+$g(^TMPBONUSMZGZL(prtDate,userCode,4))
  	..s num=num+1
  	..;&sql(insert into dhc_bonus.test4(f1,f2,f3,f4,f5,f6) values (:HandDat,:userCode,:SInvNum,:TInvNum,:SRegNum,:TRegNum))
  	..;s ^TMPBONUSMZGZL(YMD,"MZGZLDATA",num)=HandDate_","_userCode_","_SInvNum_","_TInvNum_","_SRegNum_","_TRegNum
  	
  	..s MZGZL08090=$G(^TMPBONUSMZGZL(YMD,"MZGZL08090",userCode))+SRegNum+TRegNum 
  	..s ^TMPBONUSMZSF(YMD,"MZGZL08090",userCode)=$G(^TMPBONUSMZSF(YMD,"MZGZL08090",userCode))+MZGZL08090
  	
  	..s MZGZL08091=$G(^TMPBONUSMZGZL(YMD,"MZGZL08091",userCode))+SInvNum+TInvNum  
  	..s ^TMPBONUSMZSF(YMD,"MZGZL08091",userCode)=$G(^TMPBONUSMZSF(YMD,"MZGZL08091",userCode))+MZGZL08091
  	
  	..;s ^TMPBONUSMZSF(YMD,"MZGZL08090",userCode)=$G(^TMPBONUSMZGZL(YMD,"MZGZL08090",userCode))+SRegNum+TRegNum 
  	..;s ^TMPBONUSMZSF(YMD,"MZGZL08091",userCode)=+$G(^TMPBONUSMZGZL(YMD,"MZGZL08091",userCode))+SInvNum+TInvNum
  	
  	
  	
	//导入数据前清除
	;s sMonth="M"_Month
	s itemcode="08090"
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:CurrentY and BonusPeriod=:Month and ExpendItemCode =:itemcode )
	s itemcode="08091"
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:CurrentY and BonusPeriod=:Month and ExpendItemCode =:itemcode )
	
	
  	;插入挂退号数量
	s userCode=""
	f  s userCode=$o(^TMPBONUSMZSF(YMD,"MZGZL08090",userCode)) q:userCode=""  d
	.s DorName=""
	.i $D(^dhcbsBonusUnitI("BonusUnitCode",userCode)) d 
	..s rowid="" ; s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode","PFKPTH",rowid))
	..s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",userCode,rowid))
	..i rowid'="" d
	...s DorName=$LI(^dhcbsBonusUnitD(rowid),3)
	.s itemValue=$G(^TMPBONUSMZSF(YMD,"MZGZL08090",userCode))
	.s ItemCode="08090",ItemDesc="挂退号数量" ; 
	.s UnitType=5
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:userCode,:DorName,:CurrentY, :Month,:itemValue,getdate(), 0,:UnitType,:MethodDr)
		)


    ;插入收费次数
	s userCode=""
	f  s userCode=$o(^TMPBONUSMZSF(YMD,"MZGZL08091",userCode)) q:userCode=""  d
	.s DorName=""
	.i $D(^dhcbsBonusUnitI("BonusUnitCode",userCode)) d 
	..s rowid="" ; s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode","PFKPTH",rowid))
    ..s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",userCode,rowid))
	..i rowid'="" d
	...s DorName=$LI(^dhcbsBonusUnitD(rowid),3)
	.s itemValue=$G(^TMPBONUSMZSF(YMD,"MZGZL08091",userCode))
	.s ItemCode="08091",ItemDesc="收费次数" ; 
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:userCode,:DorName,:CurrentY, :Month,:itemValue,getdate(), 0,1,:MethodDr)
		)

  	
	q num
}

Storage Default
{
<StreamLocation>^dhc.bonus.uin649.uGetMZGZLDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
