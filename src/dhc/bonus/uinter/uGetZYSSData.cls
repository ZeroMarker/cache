/// 采集科室手术收入及工作量
/// Zhao LiGuo
/// 2013-04-21
Class dhc.bonus.uinter.uGetZYSSData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 结果保存在globle中：^DHCWLJXKH("OPData")
/// 住院科室手术工作量
/// GetLocOperDate^DHCWLYTJXKH("","")
/// w ##class(dhc.bonus.uinter.uGetZYSSData).GetZYSSData("2013-06-01","2013-06-30","6")
ClassMethod GetZYSSData(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
	n (mSDate,mEDate,MethodDr)
	k ^DHCWLTEST($j)
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s YearMonth=Year_"-"_Month
	k ^TMPDHCBONUS(YM,"ZYSSDATA")
	k ^TMPDHCBONUS("BONUSSS")
	s sMonth="M"_Month
	;s mSDate="2009-01-01"
	;s mEDate="2009-03-01"
	s mReturn=0
	q:+$g(mSDate)=0 mReturn
	q:+$g(mEDate)=0 mReturn
	///	^DHCANOPArrange(0,"AppDate",Date,dr)
	///	^DHCWLAnaesthesia(0,"Arrange",{WLAN_Arrange_Dr},{WLAN_Rowid})
	s mSdate=$zdh(mSDate,3)
	s mEdate=$zdh(mEDate,3)
	
	;s mjjny=$zd(mSdate,3)_"-"_$zd(mEdate,3)
	s mNum=0
	s mPLIST(mNum)="绩效年月^手术间号^手术名称^手术收入^手术开始日期^实际开始时间^手术结束日期^实际结束时间^主刀代码^第一助手代码^第二助手代码^第三助手代码^巡回护士代码^洗手护士代码^预定开始时间^手术取消标志"
	s mNum=mNum+1
	
	f date=mSdate:1:mEdate  d
	.s mAnrDr=0
	.f  s mAnrDr=$o(^DHCANOPArrange(0,"AppDate",date,mAnrDr)) q:$g(mAnrDr)=""  d
	..;w !,"mAnrDr"_mAnrDr
	..q:'$d(^DHCWLAnaesthesia(0,"Arrange",mAnrDr))
	..s mWLanDr=$o(^DHCWLAnaesthesia(0,"Arrange",mAnrDr,""),-1)
	..q:+$g(mWLanDr)=0
	..q:'$d(^DHCWLAnaesthesia(mWLanDr))
	..///	绩效年月	手术间号	手术名称	手术收入	手术开始日期	实际开始时间	手术结束日期	实际结束时间	
	..///	主刀代码	第一助手代码	第二助手代码	第三助手代码	巡回护士代码	洗手护士代码	预定开始时间	手术取消标志
	..s mOperRoom=$p(^DHCWLAnaesthesia(mWLanDr),"^",19)
	..q:$g(mOperRoom)=""
	..s mOperRoomDesc=$p(^DHCANC("OPRoom",mOperRoom),"^",2)
	..s mOperdr=$p(^DHCWLAnaesthesia(mWLanDr),"^",42)
	..s mOperName=$p(^ORC("OPER",mOperdr),"^",2)
	..///	费用暂缺
	..s mOperFee=..GetOperFee(mAnrDr)					////	手术相关费用
	..s mOperSdate=$p(^DHCWLAnaesthesia(mWLanDr),"^",10)
	..s mOperStime=$p(^DHCWLAnaesthesia(mWLanDr),"^",11)
	..s mOperEdate=$p(^DHCWLAnaesthesia(mWLanDr),"^",12)
	..s mOperEtime=$p(^DHCWLAnaesthesia(mWLanDr),"^",13)
	..s mOperDoc=$p(^DHCWLAnaesthesia(mWLanDr),"^",50)
	..s mOperAss1=$p(^DHCWLAnaesthesia(mWLanDr),"^",52)
	..s mOperAss2=$p(^DHCWLAnaesthesia(mWLanDr),"^",53)
	..s mOperAss3=$p(^DHCWLAnaesthesia(mWLanDr),"^",54)
	..s mCirnurse=$p(^DHCWLAnaesthesia(mWLanDr),"^",58)
	..////	三个字段目前缺省
	..s mXShnurse=$p(^DHCWLAnaesthesia(mWLanDr),"^",60)	///	暂取器械护士
	..s mYDstime=""					///		预定时间
	..s mSSSign=""					///		取消标志
	..////	预留接口取数
	..s mAdmDr=$p(^DHCWLAnaesthesia(mWLanDr),"^",1)
	..s mReturn="预留接口"
	..s mOperSdate=$zd(mOperSdate,3),mOperStime=$zt(mOperStime,1),mOperEdate=$zd(mOperEdate,3),mOperEtime=$zt(mOperEtime,1)
	
	..s sdate1=$zdh(mEDate,3)
	..s sdate2=$zdh(mOperSdate,3)
	..;当手术时间大约结束时间退出
	..q:sdate2>sdate1
	
	..s mYDstime=$zt(mYDstime,1)
	..i mOperDoc'="" d
	...s mOperDoc=$p($g(^CTPCP(mOperDoc,1)),"^",1)
	..i mOperAss1'="" d
	...s mOperAss1=$p($g(^CTPCP(mOperAss1,1)),"^",1)
	..i mOperAss2'="" d
	...s mOperAss2=$p($g(^CTPCP(mOperAss2,1)),"^",1)
	..i mOperAss3'="" d
	...s mOperAss3=$p($g(^CTPCP(mOperAss3,1)),"^",1)
	..i mCirnurse'="" d
	...s mCirnurse=$p($g(^CTPCP(mCirnurse,1)),"^",1)
	..i mXShnurse'="" d
	...s mXShnurse=$p($g(^CTPCP(mXShnurse,1)),"^",1)
	..s mOperName=##class(DHCENS.Common.Common).ReplaceStr(mOperName,","," ")
	..s mStr=YearMonth_","_$G(mOperRoomDesc)_","_$G(mOperName)_","_$G(mOperFee)
	..s mStr=$g(mStr)_","_$G(mOperSdate)_","_$G(mOperStime)_","_$G(mOperEdate)_","_$G(mOperEtime)
	..s mStr=$g(mStr)_","_$G(mOperDoc)_","_$G(mOperAss1)_","_$G(mOperAss2)_","_$G(mOperAss3)
	..s mStr=$g(mStr)_","_$G(mCirnurse)_","_$G(mXShnurse)_","_$G(mYDstime)_","_$G(mSSSign)
	..;s ^DHCWLTEST($j,mNum)=$g(mStr)
	..s ^TMPDHCBONUS(YM,"ZYSSDATA",mNum)=$g(mStr)
	..; 医师主刀次数，一助、二助、三助
	..i mOperDoc'="" d
	...s ^TMPDHCBONUS("BONUSSS","03081",mOperDoc)=$G(^TMPDHCBONUS("BONUSSS","03081",mOperDoc))+1
	..i mOperAss1'="" d
	...s ^TMPDHCBONUS("BONUSSS","03082",mOperAss1)=$G(^TMPDHCBONUS("BONUSSS","03082",mOperAss1))+1
	..i mOperAss2'="" d
	...s ^TMPDHCBONUS("BONUSSS","03083",mOperAss2)=$G(^TMPDHCBONUS("BONUSSS","03083",mOperAss2))+1
	..i mOperAss3'="" d
	...s ^TMPDHCBONUS("BONUSSS","03084",mOperAss3)=$G(^TMPDHCBONUS("BONUSSS","03084",mOperAss3))+1
	..; 手术室工作量统计
	..i mOperRoomDesc'="" d
	...s ^TMPDHCBONUS("BONUSSS","07030",mOperRoomDesc)=$G(^TMPDHCBONUS("BONUSSS","07030",mOperRoomDesc))+mOperFee
	...s ^TMPDHCBONUS("BONUSSS","07020",mOperRoomDesc)=$G(^TMPDHCBONUS("BONUSSS","07020",mOperRoomDesc))+1
	...;计算手术时间
	...;
	...s date1=$ZDH(mOperSdate,3),date2=$ZDH(mOperEdate,3)
	...s st1=mOperSdate_" "_mOperStime,st2=mOperEdate_" "_mOperEtime
	...s t1=$p($ZDTH(st1,3),",",2),t2=$P($ZDTH(st2,3),",",2)
	...s hours=date2-date1,st=t2-t1
	...;w date2_"/"_date1_"/"_t2_"/"_t1,!
	...s sj=(hours*86400+st)/3600
	...;i sj<0 w mStr,!
	...s ^TMPDHCBONUS("BONUSSS","07010",mOperRoomDesc)=$G(^TMPDHCBONUS("BONUSSS","07010",mOperRoomDesc))+sj
	
	...i mCirnurse'="" d
	....s ^TMPDHCBONUS("BONUSSS","07120",mCirnurse)=$G(^TMPDHCBONUS("BONUSSS","07120",mCirnurse))+sj
	...i mXShnurse'="" d
	....s ^TMPDHCBONUS("BONUSSS","07120",mXShnurse)=$G(^TMPDHCBONUS("BONUSSS","07120",mXShnurse))+sj
	
	..s mNum=$g(mNum)+1
	k ^DHCWLTEST($j)
	
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr )

	;插入手术工作量及手术室收入
	s itemCode=""
	f  s itemCode=$o(^TMPDHCBONUS("BONUSSS",itemCode)) q:itemCode=""  d
	.s DorCode=""
	.f  s DorCode=$o(^TMPDHCBONUS("BONUSSS",itemCode,DorCode)) q:DorCode=""  d
	..s itemValue=$G(^TMPDHCBONUS("BONUSSS",itemCode,DorCode))
	..s pCode=DorCode
	..i DorCode="1号手术间" s pCode="F2061" 
	..i DorCode="2号手术间" s pCode="F2062" 
	..i DorCode="3号手术间" s pCode="F2063" 
	..i DorCode="5号手术间" s pCode="F2065" 
	..i DorCode="6号手术间" s pCode="F2066" 
	..s DorName=""
	..i $D(^dhcbsBonusUnitI("BonusUnitCode",pCode)) d 
	...s rowid="" ; 
	...s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",pCode,rowid))
	...i rowid'="" d
	....s DorName=$LI(^dhcbsBonusUnitD(rowid),3)
	..s ItemDesc=""
	..i itemCode="03081" s ItemDesc="主刀次数" ; 
	..i itemCode="03082" s ItemDesc="一助次数" ; 
	..i itemCode="03083" s ItemDesc="二助次数" ; 
	..i itemCode="03084" s ItemDesc="三助次数" ; 
	..i itemCode="07010" s ItemDesc="手术用时" ; 
	..i itemCode="07020" s ItemDesc="手术刀次" ; 
	..i itemCode="07030" s ItemDesc="手术收入" ; 
	..i itemCode="07120" s ItemDesc="手术上台时间" ;
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:itemCode,:ItemDesc,:pCode,:DorName,:Year, :sMonth,:itemValue,getdate(), 0,1,:MethodDr)
		)	
	/*
	;插入手术上台时间
	s itemCode=""
	f  s itemCode=$o(^TMPDHCBONUS("BONUSSS",itemCode)) q:itemCode=""  d
	.s NurCode=""
	.f  s DorCode=$o(^TMPDHCBONUS("BONUSSS",itemCode,NurCode)) q:NurCode=""  d
	..s itemValue=$G(^TMPDHCBONUS("BONUSSS",itemCode,NurCode))
	..s pCode=NurCode 
	..s NurName=""
	..i $D(^dhcbsBonusUnitI("BonusUnitCode",pCode)) d 
	...s rowid="" ; 
	...s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",pCode,rowid))
	...i rowid'="" d
	....s NurName=$LI(^dhcbsBonusUnitD(rowid),3)
	..s ItemDesc=""
	..i itemCode="07120" s ItemDesc="手术上台时间" ; 
	
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:itemCode,:ItemDesc,:pCode,:NurName,:Year, :sMonth,:itemValue,getdate(), 0,1,:MethodDr)
		)
	*/
	q $g(mNum)
}

/// 		^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})
/// 		$$GetOperFee^DHCWLYTJXKH()
ClassMethod GetOperFee(mAnaDr As %String) As %String
{
	;n (mAnaDr)
	s mReturn=0
	q:$g(mAnaDr)="" $g(mReturn)
	q:'$d(^DHCANOPArrange(mAnaDr)) $g(mReturn) 
	
	////s mAdmID=123
	s mAdmID=$p(^DHCANOPArrange(mAnaDr),"^",1)
	q:$g(mAdmID)="" $g(mReturn)
	q:'$d(^PAADM(mAdmID)) $g(mReturn)
	
	s mAnaestDr=$p(^DHCANOPArrange(mAnaDr),"^",2)
	///	^DHCWorkLoad(0,"PAADM",
	s mId=0
	f  s mId=$o(^DHCWorkLoad(0,"PAADM",mAdmID,mId)) q:$g(mId)=""  d
	.q:'$d(^DHCWorkLoad(mId))
	.s mOeOrdDr=$p(^DHCWorkLoad(mId),"^",21)
	.s mOrdFirst=$P(mOeOrdDr,"||",1)
	.s mOrdSecon=$P(mOeOrdDr,"||",2)
	.q:+$g(mOrdFirst)=0
	.q:+$g(mOrdSecon)=0
	.s mOrdAnaeSin=$p($g(^OEORD(mOrdFirst,"I",mOrdSecon,4)),"^",9)
	.q:$g(mOrdAnaeSin)=""
	.q:$g(mOrdAnaeSin)'=$g(mAnaestDr)
	.s mWorkFee=$p(^DHCWorkLoad(mId),"^",16)
	.s mReturn=$g(mReturn)+$g(mWorkFee)
	;b	////lllllll
	q $g(mReturn)
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetZYSSDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
