Class dhc.bonus.uinter.uGetKSZYData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 	结果保存在globle中：^DHCWLJXKH("DocOPMR",mNum)
/// 	绩效年月^责任中心^员工代码^项目^项目值
/// 		3111 门诊人次   3213 照顾床日数 	C17 收住院病人数
/// 		科室（医生）门诊、住院工作量
/// 	$$GetLocMRInfor^DHCWLYTJXKH("","")
/// w ##class(dhc.bonus.uinter.uGetKSZYData).GetKSZYData("2013-09-01","2013-09-30","8")
ClassMethod GetKSZYData(mSDate As %String, mEDate As %String, sMethodDr As %String) As %String
{
	n (mSDate,mEDate,sMethodDr)
	s MethodDr=sMethodDr
	;s mSDate="2009-01-01"
	;s mEDate="2009-01-03"
	k ^DHCWLTEST($j)
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	
	s sMonth="M"_Month
	
	s YearMonth=Year_"-"_Month
	k ^TMPBONUSKSZY(YM,"KSZYDATA")
	s sDate=$zdh(mSDate,3)
	s eDate=$zdh(mEDate,3)
	////	^DHCWorkRegReport(0,"ADMDATE",{WR_ADMDate},{WR_rowid})
	////	门诊工作量
	////	
	f date=sDate:1:eDate  d
	.s mRegId=0
	.f  s mRegId=$o(^DHCWorkRegReport(0,"ADMDATE",date,mRegId)) q:$g(mRegId)=""  d
	..q:'$d(^DHCWorkRegReport(mRegId))
	..s mLocDr=$p(^DHCWorkRegReport(mRegId),"^",5)
	..s mDocDr1=$p(^DHCWorkRegReport(mRegId),"^",6)
	..s mDocDr=$p(^CTPCP(mDocDr1,1),"^",1)
	..s mRegNum=$p(^DHCWorkRegReport(mRegId),"^",29)
	..q:($g(mLocDr)="")!($g(mDocDr)="")
	..;s ^DHCWLTEST($j,"YL001",mLocDr,mDocDr)=$g(^DHCWLTEST($j,"YL001",mLocDr,mDocDr))+$g(mRegNum)
	..s ^DHCWLTEST($j,"3111",mLocDr,mDocDr)=$g(^DHCWLTEST($j,"3111",mLocDr,mDocDr))+$g(mRegNum)
	
	///	 住院工作量
	d ..GetMRDate(mSDate,mEDate)
	d ..GetTJYSGZL(mSDate,mEDate)
	
	///	输出	 
	s mNum=0
	s mPLIST(mNum)="绩效年月^责任中心^员工代码^项目^项目值"
	s mNum=1
	;s mjjny=$zd(sDate,3)_"-"_$zd(eDate,3)
	
	s mType=""
	f  s mType=$o(^DHCWLTEST($j,mType)) q:$g(mType)=""  d
	.s mFirst=0
	.f  s mFirst=$o(^DHCWLTEST($j,mType,mFirst)) q:$g(mFirst)=""  d
	..s mSecon=0
	..f  s mSecon=$o(^DHCWLTEST($j,mType,mFirst,mSecon)) q:$g(mSecon)=""  d
	...s mData=$g(^DHCWLTEST($j,mType,mFirst,mSecon))
	...q:+$g(mData)=0
	...s mLocdesc=$p(^CTLOC(mFirst),"^",1)
	...s mPLIST(mNum)=$g(YearMonth)_","_$g(mFirst)_","_$g(mSecon)_","_$g(mType)_","_$g(mData)
	...s ^TMPBONUSKSZY(YM,"KSZYDATA",mNum)=$g(mPLIST(mNum))
	...;w !,^TMPDHCENSJX(YM,"KSZYDATA",mNum)
	...s mNum=$g(mNum)+1
	...s aa=$g(mData)+$g(aa)
	k ^DHCWLTEST($j)
	
	//导入前清楚原数据
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID =:MethodDr )
	
	k ^TMPBONUSKSZYSF
	;统计
	s num=""
	f  s num=$o(^TMPBONUSKSZY(YM,"KSZYDATA",num)) q:num=""  d
	.s deptCode=$p(^TMPBONUSKSZY(YM,"KSZYDATA",num),",",2) ;科室编码
	.s empCode=$p(^TMPBONUSKSZY(YM,"KSZYDATA",num),",",3)  ;人员编码
	.s iCode=$p(^TMPBONUSKSZY(YM,"KSZYDATA",num),",",4)  ;项目编码
	.s itemValue=$p(^TMPBONUSKSZY(YM,"KSZYDATA",num),",",5)  ;项目数值
	
	.s sCode=iCode

	.s ^TMPBONUSKSZYSF(empCode,sCode)=$G(^TMPBONUSKSZYSF(empCode,sCode))+itemValue
	
	/*
	
	.s ItemCode="",ItemDesc=""
	.i iCode="3111" s ItemCode ="03021",ItemDesc="门诊人数"
	.i iCode="3213" s ItemCode ="03031",ItemDesc="照顾床日数"
	.i iCode="C17" s ItemCode ="03043",ItemDesc="收住院人数"	
	.i empCode'="" d
	..s DorName=""
	..i $D(^dhcbsBonusUnitI("BonusUnitCode",empCode)) d 
	...s rowid="" ; 
	...s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",empCode,rowid))
	...i rowid'="" d
	....s DorName=$LI(^dhcbsBonusUnitD(rowid),3)
	..s UnitType=7 ;数据类型工作量
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:empCode,:DorName,:Year, :Month,:itemValue,getdate(), 0,:UnitType,:MethodDr)
		)
	
	*/   
	
	//----------------------------------------------------
	
	s DorCode="" 
	f  s DorCode=$O(^TMPBONUSKSZYSF(DorCode)) q:DorCode=""  d
	.s ItemCode=""
	.f  s ItemCode=$O(^TMPBONUSKSZYSF(DorCode,ItemCode)) q:ItemCode=""  d
    ..s DorName=""
	..i $D(^dhcbsBonusUnitI("BonusUnitCode",DorCode)) d 
	...s rowid="" 
	...s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",DorCode,rowid))
	...i rowid'="" d
	....s DorName=$LI(^dhcbsBonusUnitD(rowid),3)
	
	..s itemValue=$G(^TMPBONUSKSZYSF(DorCode,ItemCode))
	
	..i ItemCode="3111" d
	...s ItemNo ="03021",ItemDesc="门诊人数"
	...s SupDorName = $LI(^dhcbsBonusUnitD(rowid),6)
	...;i SupDorName = "217"  d  //肾病科血透组
    ..q:((SupDorName="217")&&(ItemCode="3111"))

	..i ItemCode="3213" s ItemNo ="03031",ItemDesc="照顾床日数"
	..i ItemCode="C17" s ItemNo ="03043",ItemDesc="收住院人数"
	..s UnitType=7 ;数据类型工作量
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemNo,:ItemDesc,:DorCode,:DorName,:Year, :sMonth,:itemValue,getdate(), 0,:UnitType,:MethodDr)
		)
		
	s Code1="" 
	f  s Code1=$O(^dhcbsBonusUnitI("BonusUnitCode",Code1)) q:Code1=""  d
	.s rowid1=""
	.f  s rowid1=$O(^dhcbsBonusUnitI("BonusUnitCode",Code1,rowid1)) q:rowid1=""  d
    ..s SupDorName1=""
    ..i rowid1'="" d
    ...s SupDorName1 = $LI(^dhcbsBonusUnitD(rowid1),6)
    ...i SupDorName1 = "217"  d  //肾病科血透组
    ....s itemValue1 = "1",ItemNo1 ="03021",ItemDesc1="门诊人数"
    ....s DorName1=$LI(^dhcbsBonusUnitD(rowid1),3)
    ....s DorCode1=$LI(^dhcbsBonusUnitD(rowid1),2)
    ....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemNo1,:ItemDesc1,:DorCode1,:DorName1,:Year, :sMonth,:itemValue1,getdate(), 0,:UnitType,:MethodDr)
		)	
	
	q $g(mNum)
}

ClassMethod GetMRDate(mSDate As %String, mEDate As %String) As %String
{
	;n (mSDate,mEDate)
	;s mSDate="2009-01-01"
	;s mEDate="2009-01-03"
	s mSDate=$zdh(mSDate,3)
	s mEDate=$zdh(mEDate,3)
	k ^DHCWLTEST11($j,"MRTEST")
	s mLocId=0
	f  s mLocId=$o(^MRIPdaily("MRIPWARD",mLocId)) q:$g(mLocId)=""  d
	.f date=mSDate:1:mEDate d
	..s mMRIPID=0
	..
	..f  s mMRIPID=$o(^MRIPdaily("MRIPWARD",mLocId,"MRIPDATE",date,mMRIPID)) q:$G(mMRIPID)=""  d
	...;w !,"mMRIPID"_mMRIPID
	...s mRyrs=$p(^MRIPdaily(mMRIPID),"^",8)
	...s mMRIPDetail=0
	...///	^DHCMRIPDetail(0,"IPDayDr",{IPDE_MRIPDay_Dr},"Type",{IPDE_Type}
 	...///	"Paadm",{IPDE_PAADM_Dr},{IPDE_Rowid}) 
 	...///	^DHCMRIPDetail(0,"IPDay",{IPDE_MRIPDay_Dr},{IPDE_Rowid})
 	...f  s mMRIPDetail=$o(^DHCMRIPDetail(0,"IPDay",mMRIPID,mMRIPDetail)) q:$g(mMRIPDetail)=""  d
 	....s mPatType=$p(^DHCMRIPDetail(mMRIPDetail),"^",2)
 	....;w !,"mPatType--"_mPatType
 	....q:($g(mPatType)'="ZYRS")&($g(mPatType)'="RYRS")
 	....s mAdmDr=$p(^DHCMRIPDetail(mMRIPDetail),"^",1)
 	....;w !,"mPamAdmDrr---"_mAdmDr
 	....q:'$d(^PAADM(mAdmDr))
 	....s mPatDocDr=$p(^PAADM(mAdmDr),"^",9)
 	....;w !,"mPatDocDr---"_mPatDocDr
 	....q:$g(mPatDocDr)=""
 	....q:'$d(^CTPCP(mPatDocDr,1))
 	....s mPatDoc=$p(^CTPCP(mPatDocDr,1),"^",1)
 	....;w !,"mPatDocDr"_$g(mPatDocDr)_"^"_$g(mAdmDr)
 	....;s ^DHCWLTEST11($j,"MRTEST",mPatDocDr,mAdmDr)=+$g(^DHCWLTEST11($j,"MRTEST",mPatDocDr,mAdmDr))+1
 	....;s ^DHCWLTEST11($j,"MRTEST",mPatDocDr)=$g(^DHCWLTEST11($j,"MRTEST",mPatDocDr))+1
	....s locid=$p(^PAWARD(mLocId),"^",5)
	....i $g(mPatType)="ZYRS" d
	.....;s ^DHCWLTEST($j,"YL002",locid,mPatDoc)=$g(^DHCWLTEST($j,"YL002",locid,mPatDoc))+1
	.....s ^DHCWLTEST($j,"3213",locid,mPatDoc)=$g(^DHCWLTEST($j,"3213",locid,mPatDoc))+1
	....s mAdmDate=$p(^PAADM(mAdmDr),"^",6)
	....;i $g(mPatType)="RYRS" d
	.....;s ^DHCWLTEST($j,"YL003",locid,mPatDoc)=$g(^DHCWLTEST($j,"YL003",locid,mPatDoc))+1
	q
}

//d ##class(dhc.bonus.uinter.uGetKSZYData).GetTJYSGZL("","")

ClassMethod GetTJYSGZL(mSDate As %String, mEDate As %String) As %String
{
	s sttdate=$zdh(mSDate,3)
	s enddate=$zdh(mEDate,3)
	
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s YearMonth=Year_"-"_Month
	
	i (sttdate="")&(enddate="")&(sttdate>enddate) q
	s admdate=""
	f admdate=sttdate:1:enddate d
	.s adm=""
	.f  s adm=$o(^PAADMi("PAADM_AdmDate",admdate,adm)) q:adm=""  d
    ..s patype=$p(^PAADM(adm),"^",2)
    ..q:patype'="I"
    ..s patStat=$p(^PAADM(adm),"^",20)
    ..q:patStat="C"
    ..s patdisdate=$p(^PAADM(adm),"^",17)
    ..s RefDocID=$p(^PAADM(adm),"^",82)
    ..q:RefDocID=""
    ..s RefDocCode="",DocLocid=""
    ..s RefDocCode=$p($g(^PAC("REFD",RefDocID)),"^",1)
    ..s Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",RefDocCode,""))
    ..s DocLocid=$p(^SSU("SSUSR",Userid),"^",4)
    ..s num=1
	..i (patdisdate'="")&(patdisdate-admdate<=3) s num=0
	..s ^DHCWLTEST($j,"C17",DocLocid,RefDocCode)=+$g(^DHCWLTEST($j,"C17",DocLocid,RefDocCode))+num
	q
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetKSZYDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
