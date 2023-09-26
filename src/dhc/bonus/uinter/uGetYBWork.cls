/// 取医保结算工作量和医保上传工作量
Class dhc.bonus.uinter.uGetYBWork Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 	
/// 	
/// 		
/// 		
/// 	
/// w ##class(dhc.bonus.uinter.uGetPACSWork).GetPACSWork("2013-06-01","2013-06-30","42")
ClassMethod GetYBWork(mSDate As %String, mEDate As %String, sMethodDr As %String) As %String
{
	n (mSDate,mEDate,sMethodDr)
	s MethodDr=sMethodDr
	
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s sMonth="M"_Month
	w mSDate_":"_mEDate,!
	s YearMonth=Year_"-"_Month
	
	s mSDateH=$zdh(mSDate,3)
	s mEDateH=$zdh(mEDate,3)
	
	k ^BonusYBWork
	s num=0	
	f mDate=mSDateH:1:mEDateH	d
	.s InpayRowid=""
	.f  s InpayRowid=$o(^DHCINDIV("0","IDate",mDate,InpayRowid)) q:InpayRowid=""  d
	..s INPAUserDr= $p(^DHCINDIV(ReportDr),"^",21)	///	医保结算员
	..s DocCode="",DocName=""
	..i INPAUserDr'="" s DocCode=$p($g(^SSU("SSUSR",INPAUserDr)),"^",1)
	..i INPAUserDr'="" s DocName=$p($g(^SSU("SSUSR",INPAUserDr)),"^",2)
	..s DocDesc=DocCode_"^"_DocName
	..s INPAYFlag= $p(^DHCINDIV(ReportDr),"^",5)	///	医保结算标识
    ..s ^BonusYBWork("YBJS",DocDesc)=$g(^BonusYBWork("YBJS",DocDesc))+1
    
    s DocCode=""
	f  s DocCode=$o(^BonusYBWork("YBJS",DocCode)) q:DocCode=""  d
	.s sValue= $G(^BonusYBWork("YBJS",DocCode))
	.s ItemCode=""
	.s ItemName=""
	.s sDocName=""
	.s CalculateUnit=1
	.s sDocCode=$p(DocCode,"^",1)
	.s sDocName=$p(DocCode,"^",2)
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(BonusYear, BonusPeriod,BonusUnitCode, BonusUnitName , ExpendItemCode,ExpenItemName
		,ItemValue,CalculateUnit,InterLocMethodID ,CollectDate, State, UnitType) 
		values(:Year, :sMonth,:sDocCode, :sDocName , :ItemCode,:ItemName
		,:sValue,:CalculateUnit,:sMethodDr ,getdate(), 0, 9))	 
	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetYBWorkS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
