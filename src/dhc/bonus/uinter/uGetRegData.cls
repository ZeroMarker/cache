/// 挂号工作量采集
Class dhc.bonus.uinter.uGetRegData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// others: w ##class(dhc.bonus.uinter.uGetRegData).GetRegData("2014","03","4")
ClassMethod GetRegData(sYear As %String, sMonth As %String, sMethodDr As %String) As %String
{
	n (sYear,sMonth,sMethodDr)
	s ym=sYear_"-"_sMonth 
	s MethodDr=sMethodDr
  	s days = ..GetMothDays(sMonth)
  	s startDate = sYear_"-"_sMonth_"-"_"01"
  	s endDate = sYear_"-"_sMonth_"-"_days
  	s sMonth= "M"_sMonth
  	
  	s Stdate = $ZDH(startDate,3)
  	s Endate = $ZDH(endDate,3)
	//导入数据前清除
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:sYear and 
	     BonusPeriod=:sMonth and InterLocMethodID=:MethodDr 
	     )
 
 	k ^tempbsglxx
 	s sum=0
	s deptCodeHos="AAAAAAAAAA"
 	f day=Stdate:1:Endate  d
 	.s wrdr=0 f  s wrdr=$o(^DHCWorkRegReport(0,"ADMDATE",day,wrdr)) q:wrdr=""  d
 	..s admDr=$p(^DHCWorkRegReport(wrdr),"^",15)    //就诊号
 	..s DeptDr=$p($g(^DHCWorkRegReport(wrdr)),"^",5) //所挂科室dr
 	..s RegTypeDR=$p(^DHCWorkRegReport(wrdr),"^",34)  //挂号类别dr
 	..s Count=$p($g(^DHCWorkRegReport(wrdr)),"^",29) //挂号人次
 	..i DeptDr'=""&RegTypeDR'="" d
 	...S ^tempbsglxx(ym,DeptDr,RegTypeDR)=$G(^tempbsglxx(ym,DeptDr,RegTypeDR))+Count
	
 
 	s DeptDr=""
 	f  s DeptDr=$o(^tempbsglxx(ym,DeptDr)) q:DeptDr=""  d
 	.s RegTypeDR=""
 	.f  s RegTypeDR=$o(^tempbsglxx(ym,DeptDr,RegTypeDR)) q:RegTypeDR=""  d
 	..i DeptDr'="" d
 	...s DeptID=$o(^dhcbsBonusUnitI("BonusUnitCode","H"_DeptDr,""))
 	...i DeptID'="" d
 	....s BonusUnitName=$LI(^dhcbsBonusUnitD(DeptID),3)
 	....s BonusUnitCode=$LI(^dhcbsBonusUnitD(DeptID),2)
 	..s RegTypeName=""
 	..i RegTypeDR'="" d
 	...s RegTypeID=$O(^dhcbsSubItemI("SubsItemCode",RegTypeDR,""))
 	...i RegTypeID'="" d
 	....s RegTypeName=$LI(^dhcbsSubItemD(RegTypeID),3)
 	....s RegTypeCode=$LI(^dhcbsSubItemD(RegTypeID),2)
 	....s RegTypeID1="D"_RegTypeID
 	....s RegRateID=$O(^dhcbsSubExpendRateI("sbItem","G2",RegTypeID1,""))
 	....i RegRateID'="" d
 	.....s ExecuteRate=$LI(^dhcbsSubExpendRateD(RegRateID),6)
  	..s Count=$G(^tempbsglxx(ym,DeptDr,RegTypeDR))
 	..s fee=Count*ExecuteRate
 	..i RegTypeID'="" d
 	...&sql(
          insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,
          BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,
          UnitType,InterLocMethodID) values('02020',:RegTypeName,:BonusUnitCode,:BonusUnitName,:sYear,:sMonth,:fee,getDate(),0,0,:sMethodDr)
          ) 	
 	/*w "ym "_ym_"DeptDr "_DeptDr_"RegType "_RegType_"Count "_Count ,!*/
          
          
 	q 0
}

ClassMethod GetMothDays(sMonth As %String) As %String
{
	n (sMonth)
	s rtn=30 
	i sMonth="01" s rtn=31
	i sMonth="02" s rtn=28
	i sMonth="03" s rtn=31
	i sMonth="04" s rtn=30
	i sMonth="05" s rtn=31
	i sMonth="06" s rtn=30
	i sMonth="07" s rtn=31
	i sMonth="08" s rtn=31
	i sMonth="09" s rtn=30
	i sMonth="10" s rtn=31
	i sMonth="11" s rtn=30
	i sMonth="12" s rtn=31
	
	q rtn
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetRegDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
