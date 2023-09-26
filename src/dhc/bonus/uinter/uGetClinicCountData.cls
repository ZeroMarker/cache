Class dhc.bonus.uinter.uGetClinicCountData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// creator:赵伟
/// time:2014年6月3日17:52:28
/// others: w ##class(dhc.bonus.uinter.uGetClinicCountData).MRDynaALLData("2014-06-01","2014-06-30",6)
ClassMethod MRDynaALLData(startdate, enddate, MethodDr) As %Status
{
	n (startdate, enddate, MethodDr)
    q:startdate="" 1
    q:enddate="" 1
    k ^TEMPDHCWL($j)
    k ^mTEMPDHCWLTEST($j)
    s Year=$p(startdate,"-",1)
	s Month=$p(enddate,"-",2)
	s sMonth="M"_ Month
    ;b	///	1111111
    s grploc=28    //科室子组ID  35
    d GetDepSubLocDetail23(grploc)	///	^DHCWLCFG("GRP",mGroupDr,"SUBGRP",mSubDr)
    ;b	////	22222
    i (startdate="")&(enddate="") Set qHandle=$lb(0,repid,0)
    i (startdate="")&(enddate="")  q $$$OK
    i startdate="" s startdate=$zd(+$h-1,3)
    i enddate="" s enddate=$zd(+$h-1,3)
    s startdate=$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s sDate=startdate
    s eDate=enddate
    
    
    	//导入数据前清除
	s sMonth="M"_Month
	;w Year_":"_sMonth_":"_MethodDr,!
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr )
    
    ;b		///	门诊部分
    f mDate=sDate:1:eDate d
    .s mRegRowid=0 
    .f  s mRegRowid=$o(^DHCWorkRegReport(0,"ADMDATE",mDate,mRegRowid)) q:mRegRowid=""  d
    ..;b	///111
    ..s mPaadmdr=$p(^DHCWorkRegReport(mRegRowid),"^",15)
    ..q:'$d(^PAADM(mPaadmdr))
    ..s mAdmType=$p(^PAADM(mPaadmdr),"^",2)
    ..s PAADMVisitStatus=$p(^PAADM(mPaadmdr),"^",20)
    ..Q:PAADMVisitStatus="C"
    ..s mPapmidr=$p(^PAADM(mPaadmdr),"^",1)
    ..s mDepRowid=$p(^DHCWorkRegReport(mRegRowid),"^",5)
    ..s mCount=$p(^DHCWorkRegReport(mRegRowid),"^",29)
    ..s mRegNum=$p(^DHCWorkRegReport(mRegRowid),"^",29)
	..s mWrNum=$p(^DHCWorkRegReport(mRegRowid),"^",31)
	..s WRText4=$p(^DHCWorkRegReport(mRegRowid),"^",34)
	..s ESSDesc=""
	..if WRText4'="" set ESSDesc=$P($G(^RBC("SESS",WRText4)),"^",2)
	..s mCaNum=($g(mWrNum)-$g(mRegNum))/2
	..s mCount=$g(mRegNum)+$g(mCaNum)
	..s SSPaperDr=$p($g(^PAADM(mPaadmdr,1)),"^",7)  ///add yu  判断病人医保类型
	..Q:SSPaperDr=""
	..Q:'$d(^DHCWLSSCFG(0,"SS",SSPaperDr)) 
    ..q:$g(mDepRowid)=""
    ..;w "mCount="_mCount,!
    ..s mSatSubDr=mDepRowid
	..;s mSatSubDr=$g(^mTEMPDHCWLTEST($j,"SubLocDetail",mDepRowid))
	..q:$g(mSatSubDr)=""
	..s ^TEMPDHCWL($j,"output",mSatSubDr,"mOpTotNum")=$g(^TEMPDHCWL($j,"output",mSatSubDr,"mOpTotNum"))+$g(mCount)
	..i $g(mAdmType)="O" d
	...if ESSDesc'["急诊" d
	....s ^TEMPDHCWL($j,"output",mSatSubDr,"mOpNum")=$g(^TEMPDHCWL($j,"output",mSatSubDr,"mOpNum"))+$G(mCount)
	...if ESSDesc["急诊" d
	....s ^TEMPDHCWL($j,"output",mSatSubDr,"mEpNum")=$g(^TEMPDHCWL($j,"output",mSatSubDr,"mEpNum"))+1
	..i $g(mAdmType)="E" d
	...s ^TEMPDHCWL($j,"output",mSatSubDr,"mEpNum")=$g(^TEMPDHCWL($j,"output",mSatSubDr,"mEpNum"))+$G(mCount)
	...i $d(^PAPERi("DecDate",mDate,mPapmidr)) d
	....s ^TEMPDHCWL($j,"output",mSatSubDr,"mEpSwNum")=$g(^TEMPDHCWL($j,"output",mSatSubDr,"mEpSwNum"))+$G(mCount)
	..;i $g(mAdmType)="H" d
	..;.s ^TEMPDHCWL($j,"output",mSatSubDr,"mHpJcNum")=$g(^TEMPDHCWL($j,"output",mSatSubDr,"mHpJcNum"))+$G(mCount)
	..;i $g(mDepRowid)=286 d ///  体检数据
	..i '$d(^TEMPDHCWL($j,"hpdate",mDate)) d ///  体检数据
	...;b	///hphphp1111	
	...q:$d(^TEMPDHCWL($j,"hpdate",mDate))
	...;s mHpJcNum=$$GetDateHpData23($zd(mDate,3))
	...s mHpJcNum=$$GetHpNum($zd(mDate,3),$zd(mDate,3))
	...;s mHpJcNum=1231
	...s ^TEMPDHCWL($j,"output",87,"mHpJcNum")=$g(^TEMPDHCWL($j,"output",87,"mHpJcNum"))+$G(mHpJcNum)
	...s ^TEMPDHCWL($j,"hpdate",mDate)=1
	...;b	////hohhppp
	..///	^PAPERi("DecDate",date,PARowId)
	..s mLgNum=1
	..s mJzlgStr=$$GetJZLG23(mPaadmdr)  
	..s mLgOrdStr=$$GetZYPatInfor23(mDate,mPaadmdr,mDepRowid)    ///add yu    增加科室，判断医嘱发生科室
	..s mJzlgStr=$g(mJzlgStr)_"^"_$g(mLgOrdStr)
	..i mDepRowid=369 ;w "mDepRowid="_mDepRowid_"ESSDesc="_ESSDesc,!
	..i (mDepRowid=369)&(mJzlgStr["留观")  d
	...;b ;;;k
	..i $g(mLgOrdStr)'="ERR" s mLgNum=$g(^mTEMPDHCWLTEST($j,"MM",mPaadmdr))
	..q:$g(mJzlgStr)'["留观"
	..s ^TEMPDHCWL($j,"output",mSatSubDr,"mSrNum")=$g(^TEMPDHCWL($j,"output",mSatSubDr,"mSrNum"))+$g(mLgNum)
	..i $g(mJzlgStr)["死亡"
	...s ^TEMPDHCWL($j,"output",mSatSubDr,"mSrSwNum")=$g(^TEMPDHCWL($j,"output",mSatSubDr,"mSrSwNum"))+$g(mLgNum)
	
	

    s subgrpdr=0 f  s subgrpdr=$o(^DHCWLCFG("GRP",grploc,"SUBGRP",subgrpdr)) q:subgrpdr=""  d
    .s grpdr=grploc_"||"_subgrpdr
    .s mGrpSubDr=0
    .f  s mGrpSubDr=$o(^DHCWLCFGR("SUBGRPDEP","SUBGRP",grpdr,mGrpSubDr)) q:$g(mGrpSubDr)=""  d
    ..s mDepDr=$p($g(^DHCWLCFGR("SUBGRPDEP",mGrpSubDr)),"^",3)
    ..;下面这个是干嘛用的
    ..;q:'$d(^TEMPDHCWL($j,"output",mDepDr))
    ..;s mLocDesc=$p(^DHCWLCFG("GRP",grploc,"SUBGRP",subgrpdr),"^",2)
    ..s mLocDesc=$p(^CTLOC(mDepDr),"^",2)
    ..s mJGNum=""
    ..s mOpTotNum=$g(^TEMPDHCWL($j,"output",mDepDr,"mOpTotNum"))
    ..s mOpNum=$g(^TEMPDHCWL($j,"output",mDepDr,"mOpNum"))
    ..s mEpNum=$g(^TEMPDHCWL($j,"output",mDepDr,"mEpNum"))
    ..s mEpSwNum=$g(^TEMPDHCWL($j,"output",mDepDr,"mEpSwNum"))
    ..s mSrNum=$g(^TEMPDHCWL($j,"output",mDepDr,"mSrNum"))
    ..i +$g(mSrNum)=0 s mSrNum=""
    ..s mSrSwNum=$g(^TEMPDHCWL($j,"output",mDepDr,"mSrSwNum"))
    ..s mHpJcNum=$g(^TEMPDHCWL($j,"output",mDepDr,"mHpJcNum"))
    ..s mOEpPer=$g(^TEMPDHCWL($j,"output",mDepDr,"mOEpPer"))
    ..i +$g(mOpTotNum)'=0 d
    ...s mOEpPer=$fn(100*($g(mEpNum)+$G(mOpNum))/$g(mOpTotNum),"",2)
    ..s mEpSwPer=$g(^TEMPDHCWL($j,"output",mDepDr,"mEpSwPer"))
    ..i +$g(mEpNum)'=0 d
    ...s mEpSwPer=$fn(100*($g(mEpSwNum))/$g(mEpNum),"",2)
    ..s mGcsSwPer=$g(^TEMPDHCWL($j,"output",mDepDr,"mGcsSwPer"))
    ..i +$g(mSrNum)'=0 d
    ...s mGcsSwPer=$fn(100*($g(mSrSwNum))/$g(mSrNum),"",2)
    ..///	输出传
    ..s mOpDataStr=$g(mLocDesc)_"^"_$G(mJGNum)_"^"_$G(mOpTotNum)_"^"_$G(mOpNum)_"^"_$G(mEpNum)_"^"_$G(mEpSwNum)
    ..s mOpDataStr=$g(mOpDataStr)_"^"_$G(mSrNum)_"^"_$G(mSrSwNum)_"^"_$G(mHpJcNum)_"^"_$G(mOEpPer)_"^"_$G(mEpSwPer)_"^"_$G(mGcsSwPer)
    ..;s mDataStr=$g(mDataStr)_"^"_$G(mSrNum)_"^"_$G(mHpJcNum)_"^"_$G(mOEpPer)_"^"_$G(mEpSwPer)_"^"_$G(mGcsSwPer)
    ..S ^TEMPDHCWL($j,"outputOpall",mLocDesc)=$G(mOpDataStr)
    ..;w $g(mDepDr)_"^"_$g(mLocDesc)_"^"_$G(mOpNum),!
    ..s DeptDr=mDepDr,DeptDesc=mLocDesc
   	..s ItemCode="05010",ItemDesc="门诊人次",ItemValue=$g(mOpTotNum)
   	..;i DeptDr="220"||"113" s ItemValue
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:DeptDr,:DeptDesc,:Year,:sMonth,:ItemValue,getdate(), 0,0,:MethodDr)
		)
    
    ;b	///	住院部分
    ;s sDate=$zdh("2009-03-01",3)
    ;s eDate=$zdh("2009-03-01",3)
    s grploc=28    //科室子组ID  35
    d GetDepSubLocDetail23(grploc)	///	^DHCWLCFG("GRP",mGroupDr,"SUBGRP",mSubDr)
    
    ///	^MRIPdaily("MRIPloc",9,"MRIPdate",
    s mWardDr=0
	f  s mWardDr=$o(^MRIPdaily("MRIPloc",mWardDr)) q:$g(mWardDr)=""  d
	.f mDate=sDate:1:eDate  d
	..s mMRId=0
	..f  s mMRId=$o(^MRIPdaily("MRIPloc",mWardDr,"MRIPdate",mDate,mMRId)) q:$g(mMRId)=""  d
	...;w !,"mWardDr--"_mWardDr_"--"_sDate_"--"_eDate
	...s mYyrs=$p($g(^MRIPdaily(mMRId)),"^",13)
	...s mRyrs=$p($g(^MRIPdaily(mMRId)),"^",8)
	...s mZrrs=$p($g(^MRIPdaily(mMRId)),"^",9)
	...s mZcrs=$p($g(^MRIPdaily(mMRId)),"^",12)
	...s mXyrs=$p($g(^MRIPdaily(mMRId)),"^",18)
	...s mGdcs=$p($$BedNum23(mDate,"Loc",mWardDr),"^",1)
	...;s mGlobleName="^TEMPDHCWL()"
	...;s mSaveStr
	...;s mWardLocDr=$p($g(^PAWARD(mWardDr)),"^",5)
	...s mWardLocDr=mWardDr
	...q:$g(mWardLocDr)=""
	...s mSatSumDr=$g(^mTEMPDHCWLTEST($j,"SubLocDetail",mWardLocDr))
	...; 关键修改
	...s mSatSumDr=mWardLocDr
	...q:$g(mSatSumDr)=""
	...;w !,"mWardLocDr--"_mWardLocDr ;_"--mYyrs--"_mYyrs_"--mXyrs--"_mXyrs
	...;b	///bbbb
	...i '$d(^TEMPDHCWL($j,"BedNums",mWardDr)) d
	....s ^TEMPDHCWL($j,"output",mSatSumDr,"mGdsycs")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mGdsycs"))+$g(mGdcs)
	....s ^TEMPDHCWL($j,"BedNums",mWardDr)=1
	...i $g(mDate)=$g(sDate) d
	....s ^TEMPDHCWL($j,"output",mSatSumDr,"mQcyyrs")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mQcyyrs"))+$g(mYyrs)
	...s ^TEMPDHCWL($j,"output",mSatSumDr,"mQnryrs")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mQnryrs"))+$g(mRyrs)
	...s ^TEMPDHCWL($j,"output",mSatSumDr,"mQnzrrs")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mQnzrrs"))+$g(mZrrs)
	...s ^TEMPDHCWL($j,"output",mSatSumDr,"mZwtkrs")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mZwtkrs"))+$g(mZcrs)
	...i $g(mDate)=$g(eDate) d
	....s ^TEMPDHCWL($j,"output",mSatSumDr,"mQmxyrs")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mQmxyrs"))+$g(mXyrs)
	...s ^TEMPDHCWL($j,"output",mSatSumDr,"mSjkfcs")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mSjkfcs"))+$g(mGdcs)
	...s ^TEMPDHCWL($j,"output",mSatSumDr,"mSjzycs")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mSjzycs"))+$g(mXyrs)
	...
	...
    ;s sDate=$zdh("2009-09-01",3)
    ;s eDate=$zdh("2009-09-11",3)
    ;治愈未愈好转死亡其它
	f mDate=sDate:1:eDate  d
	.s mMRBaseId=0
    .f  s mMRBaseId=$o(^DHCMRBase(0,"MR_DIS_DATE",mDate,mMRBaseId)) q:$g(mMRBaseId)=""  d
	..s mMainOperName=$P($g(^DHCMRBase(mMRBaseId)),"^",70)
    ..s mCyqk=$P($g(^DHCMRBase(mMRBaseId)),"^",40)
    ..;s mCyqkDesc=$Case(mCyqk,1:"mZyrs",2:"mHzrs",3:"mWyrs",4:"mSwrs",5:"mQtrs",:"mZyrs")
    ..;s mCyqkDesc=$Case(mCyqk,"治愈":"mZyrs","好转":"mHzrs","未愈":"mWyrs","死亡":"mSwrs","其他":"mQtrs",:"mZyrs")
    ..s mCyqkDesc=$Case(mCyqk,1:"mZyrs",2:"mHzrs",3:"mWyrs",4:"mSwrs",5:"mQtrs",:"mZyrs")
	..s mDisDepDr=$P($g(^DHCMRBase(mMRBaseId)),"^",31)
	..q:$g(mDisDepDr)=""
	..;s mSatSumDr=$g(^mTEMPDHCWLTEST($j,"SubLocDetail",mDisDepDr))
	..s mSatSumDr=mDisDepDr
	..q:$g(mSatSumDr)=""
	..;Q:$g(mSatSumDr)=1		///	测试
	..s mAdmDate=$P($g(^DHCMRBase(mMRBaseId)),"^",26)
	..s mZyts=$g(mDate)-$g(mAdmDate)+1
	..i $g(mZyts)<1 s mZyts=1
	..s mTotleFee=$P($g(^DHCMRBase(mMRBaseId)),"^",78)
	..;w !,"mTotleFee--"_mTotleFee
	..s mRescuNum=$p($g(^DHCMRBase(mMRBaseId)),"^",55)
	..s mResSucNum=$p($g(^DHCMRBase(mMRBaseId)),"^",56)
	..i $g(mMainOperName)'=""  d
	...s ^TEMPDHCWL($j,"output",mSatSumDr,"mOperNum")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mOperNum"))+1
	..s ^TEMPDHCWL($j,"output",mSatSumDr,"mCyrszj")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mCyrszj"))+1
	..i $g(mCyqkDesc)'="mQtrs"  d
	...s ^TEMPDHCWL($j,"output",mSatSumDr,"mCyrsxj")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mCyrsxj"))+1
	..s ^TEMPDHCWL($j,"output",mSatSumDr,mCyqkDesc)=$g(^TEMPDHCWL($j,"output",mSatSumDr,mCyqkDesc))+1
	..s ^TEMPDHCWL($j,"output",mSatSumDr,"mCyzzyz")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mCyzzyz"))+$g(mZyts)
	..s ^TEMPDHCWL($j,"output",mSatSumDr,"mCyzzyfy")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mCyzzyfy"))+$g(mTotleFee)
	..s ^TEMPDHCWL($j,"output",mSatSumDr,"mRescuNum")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mRescuNum"))+$g(mRescuNum)
	..s ^TEMPDHCWL($j,"output",mSatSumDr,"mResSucNum")=$g(^TEMPDHCWL($j,"output",mSatSumDr,"mResSucNum"))+$g(mResSucNum)
	.
	
	/*
    s subgrpdr=0 f  s subgrpdr=$o(^DHCWLCFG("GRP",grploc,"SUBGRP",subgrpdr)) q:subgrpdr=""  d
    .s grpdr=grploc_"||"_subgrpdr
    .s mGrpSubDr=0
    .f  s mGrpSubDr=$o(^DHCWLCFGR("SUBGRPDEP","SUBGRP",grpdr,mGrpSubDr)) q:$g(mGrpSubDr)=""  d
    ..s mDepDr=$p($g(^DHCWLCFGR("SUBGRPDEP",mGrpSubDr)),"^",3)
    ..w "what"_'$d(^TEMPDHCWL($j,"output",mDepDr))
    ..;q:'$d(^TEMPDHCWL($j,"output",mDepDr))
    ..;s mLocDesc=$p(^DHCWLCFG("GRP",grploc,"SUBGRP",subgrpdr),"^",2)
    ..s mLocDesc=$p(^CTLOC(mDepDr),"^",2)
    ..w "mDepDr"_mDepDr_"mLocDesc"_mLocDesc,!
    ..s subgrpdr=mDepDr
    ..;w "mDepDr--"_mDepDr_"subgrpddr--"_subgrpdr
    
    ..s mGdsycs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mGdsycs"))
    
    ..s mQcyyrs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mQcyyrs"))
    ..s mQnryrs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mQnryrs"))
    ..s mQnzrrs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mQnzrrs"))
    ..i +$g(mQnzrrs)=0 s mQnzrrs=""
    ..s mCyrszj=$g(^TEMPDHCWL($j,"output",subgrpdr,"mCyrszj"))
    ..s mCyrsxj=$g(^TEMPDHCWL($j,"output",subgrpdr,"mCyrsxj"))
    ..s mZyrs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mZyrs"))
    ..s mHzrs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mHzrs"))
    ..s mWyrs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mWyrs"))
    ..s mSwrs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mSwrs"))
    ..s mQtrs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mQtrs"))
    ..s mZwtkrs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mZwtkrs"))
    ..i +$g(mZwtkrs)=0 s mZwtkrs=""
    ..s mQmxyrs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mQmxyrs"))
    ..s mSjkfcs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mSjkfcs"))
    ..s mSjzycs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mSjzycs"))
    ..s mCyzzyz=$g(^TEMPDHCWL($j,"output",subgrpdr,"mCyzzyz"))
    
    ..w "科室->"_subgrpdr_" 描述 "_mLocDesc ;_" 期内入院人数 "_mQnryrs_" 出院人数总计 "_mCyrszj_" 出院病人小计 "_mCyrsxj
    ..w "实际开放总床日数"_mSjkfcs_"实际占用总床日数"_mSjzycs_" 出院者占用总床日数 "_mCyzzyz,!
	*/
  	

	
	s first=0,second=0
    s subgrpdr=0 f  s subgrpdr=$o(^DHCWLCFG("GRP",grploc,"SUBGRP",subgrpdr)) q:subgrpdr=""  d
    .s grpdr=grploc_"||"_subgrpdr
    .s mGrpSubDr=0
    .f  s mGrpSubDr=$o(^DHCWLCFGR("SUBGRPDEP","SUBGRP",grpdr,mGrpSubDr)) q:$g(mGrpSubDr)=""  d
    ..s mDepDr=$p($g(^DHCWLCFGR("SUBGRPDEP",mGrpSubDr)),"^",3)
    ..;q:'$d(^TEMPDHCWL($j,"output",mDepDr))
    ..;s mLocDesc=$p(^DHCWLCFG("GRP",grploc,"SUBGRP",subgrpdr),"^",2)
    ..s mLocDesc=$p(^CTLOC(mDepDr),"^",2)
    ..s mGdsycs=$g(^TEMPDHCWL($j,"output",mDepDr,"mGdsycs"))
    ..s mQcyyrs=$g(^TEMPDHCWL($j,"output",mDepDr,"mQcyyrs"))
    ..s mQnryrs=$g(^TEMPDHCWL($j,"output",mDepDr,"mQnryrs"))
    ..s mQnzrrs=$g(^TEMPDHCWL($j,"output",mDepDr,"mQnzrrs"))
    ..i +$g(mQnzrrs)=0 s mQnzrrs=""
    ..s mCyrszj=$g(^TEMPDHCWL($j,"output",mDepDr,"mCyrszj"))
    ..s mCyrsxj=$g(^TEMPDHCWL($j,"output",mDepDr,"mCyrsxj"))
    ..s mZyrs=$g(^TEMPDHCWL($j,"output",mDepDr,"mZyrs"))
    ..s mHzrs=$g(^TEMPDHCWL($j,"output",mDepDr,"mHzrs"))
    ..s mWyrs=$g(^TEMPDHCWL($j,"output",mDepDr,"mWyrs"))
    ..s mSwrs=$g(^TEMPDHCWL($j,"output",mDepDr,"mSwrs"))
    ..s mQtrs=$g(^TEMPDHCWL($j,"output",mDepDr,"mQtrs"))
    ..s mZwtkrs=$g(^TEMPDHCWL($j,"output",mDepDr,"mZwtkrs"))
    ..i +$g(mZwtkrs)=0 s mZwtkrs=""
    ..s mQmxyrs=$g(^TEMPDHCWL($j,"output",mDepDr,"mQmxyrs"))
    ..s mSjkfcs=$g(^TEMPDHCWL($j,"output",mDepDr,"mSjkfcs"))
    ..s mSjzycs=$g(^TEMPDHCWL($j,"output",mDepDr,"mSjzycs"))
    ..s mCyzzyz=$g(^TEMPDHCWL($j,"output",mDepDr,"mCyzzyz"))
    ..;此处与20140805被赵伟修改
    ..i mDepDr="220" s mCyrszj=$g(mCyrszj)+$g(mZwtkrs)
    ..i mDepDr="113" s mCyrszj=$g(mCyrszj)+$g(mZwtkrs)
    ..i mDepDr="465" s mCyrszj=$g(mCyrszj)+$g(mZwtkrs)
    ..;w "科室->"_mDepDr_" 描述 "_mLocDesc_" 期内入院人数 "_mQnryrs_" 出院人数总计 "_mCyrszj_" 出院病人小计 "_mCyrsxj
    ..
    ..;w "实际开放总床日数"_mSjkfcs_"实际占用总床日数"_mSjzycs_" 出院者占用总床日数 "_mCyzzyz,!
    ..s DeptDr=mDepDr,DeptDesc=mLocDesc
	..s ItemCode="05020",ItemDesc="入院人数",ItemValue=$g(mQnryrs)
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:DeptDr,:DeptDesc,:Year,:sMonth,:ItemValue,getdate(), 0,0,:MethodDr)
		)
	..s ItemCode="05040",ItemDesc="出院人数",ItemValue=$g(mCyrszj)
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:DeptDr,:DeptDesc,:Year,:sMonth,:ItemValue,getdate(), 0,0,:MethodDr)
		)
	..s ItemCode="05050",ItemDesc="出院患者占用床日数",ItemValue=$g(mCyzzyz)
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:DeptDr,:DeptDesc,:Year,:sMonth,:ItemValue,getdate(), 0,0,:MethodDr)
		)
	..s ItemCode="05051",ItemDesc="患者占用床日数",ItemValue=$g(mSjzycs)
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:DeptDr,:DeptDesc,:Year,:sMonth,:ItemValue,getdate(), 0,0,:MethodDr)
		)
	..s ItemCode="05052",ItemDesc="实际开放床日总数",ItemValue=$g(mSjkfcs)
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemCode,:ItemDesc,:DeptDr,:DeptDesc,:Year,:sMonth,:ItemValue,getdate(), 0,0,:MethodDr)
		)
 	/*

    .s mZyl=""
    .i +$g(mCyrsxj)'=0 d
    ..s mZyl=$fn(100*$g(mZyrs)/$g(mCyrsxj),"",2)
    ..i +$g(mZyl)=0 s mZyl=""
    .s mHzl=""
    .i +$g(mCyrsxj)'=0 d
    ..s mHzl=$fn(100*$g(mHzrs)/$g(mCyrsxj),"",2)
    ..i +$g(mHzl)=0 s mHzl=""
    .s mBsl=""
    .i +$g(mCyrsxj)'=0 d
    ..s mBsl=$fn(100*$g(mSwrs)/$g(mCyrsxj),"",2)
    ..i +$g(mBsl)=0 s mBsl=""
    .s mBczzcs=$g(^TEMPDHCWL($j,"output",subgrpdr,"mBczzcs"))
    .i +$g(mGdsycs)'=0 s mBczzcs=$fn($g(mCyrszj)/$g(mGdsycs),"",2)
    .i +$g(mBczzcs)=0 s mBczzcs=""
    .s mPjbcgzr=eDate-sDate+1
    .i +$g(mSjkfcs)'=0 d
    ..s mPjbcgzr=$fn($g(mSjzycs)*$g(mPjbcgzr)/$g(mSjkfcs),"",2)
    .e  d
    ..s mPjbcgzr=0
    .;s mPjbcgzr=$fn($g(mSjzycs)/$g(mPjbcgzr),"",2)
    .s mSjbcsyl=0
    .i +$g(mSjkfcs)'=0 s mSjbcsyl=$fn(100*$g(mSjzycs)/$g(mSjkfcs),"",2)
    .i +$g(mSjbcsyl)=0 s mSjbcsyl=""
    .s mCypjzyr=0
    .i +$g(mCyrszj)'=0 s mCypjzyr=$fn($g(mCyzzyz)/$g(mCyrszj),"",2)
    .i +$g(mCypjzyr)=0 s mCypjzyr=""
    .s mCyzzyfy=$g(^TEMPDHCWL($j,"output",subgrpdr,"mCyzzyfy"))
    .s mRjfy=0
    .i +$g(mCyrszj)'=0 s mRjfy=$fn($g(mCyzzyfy)/$g(mCyrszj),"",2)
    .i +$g(mRjfy)=0 s mRjfy=""
    .s mOperNum=$g(^TEMPDHCWL($j,"output",subgrpdr,"mOperNum"))
    .s mRescuNum=$g(^TEMPDHCWL($j,"output",subgrpdr,"mRescuNum"))
    .s mResSucNum=$g(^TEMPDHCWL($j,"output",subgrpdr,"mResSucNum"))
    .s mResPer=+$g(^TEMPDHCWL($j,"output",subgrpdr,"mOperNum"))
    .s mResPer=0
    .i +$g(mRescuNum)'=0 s mResPer=$fn(100*$g(mResSucNum)/$g(mRescuNum),"",2)
    .i +$g(mResPer)=0 s mResPer=""
    .;Do OutRow23
    .s mInDataStr=$G(mLocDesc)_"^"_$G(mGdsycs)_"^"_$G(mQcyyrs)_"^"_$G(mQnryrs)_"^"_$G(mQnzrrs)_"^"_$G(mCyrszj)
    .s mInDataStr=$g(mInDataStr)_"^"_$G(mCyrsxj)_"^"_$G(mZyrs)_"^"_$G(mHzrs)_"^"_$G(mWyrs)_"^"_$G(mSwrs)
    .s mInDataStr=$g(mInDataStr)_"^"_$G(mQtrs)_"^"_$G(mZwtkrs)_"^"_$G(mQmxyrs)_"^"_$G(mSjkfcs)_"^"_$G(mSjzycs)
    .s mInDataStr=$g(mInDataStr)_"^"_$G(mCyzzyz)_"^"_$G(mZyl)_"^"_$G(mHzl)_"^"_$G(mBsl)_"^"_$G(mBczzcs)
    .s mInDataStr=$g(mInDataStr)_"^"_$G(mPjbcgzr)_"^"_$G(mSjbcsyl)_"^"_$G(mCypjzyr)_"^"_$G(mCyzzyfy)_"^"_$G(mRjfy)
    .s mInDataStr=$g(mInDataStr)_"^"_$G(mOperNum)_"^"_$G(mRescuNum)_"^"_$G(mResSucNum)_"^"_$G(mResPer)
    .S ^TEMPDHCWL($j,"outputInall",mLocDesc)=$G(mInDataStr)
    
    s subgrpdr=0 f  s subgrpdr=$o(^DHCWLCFG("GRP",grploc,"SUBGRP",subgrpdr)) q:subgrpdr=""  d
    .s grpdr=grploc_"||"_subgrpdr
    .s mLocDesc=$p(^DHCWLCFG("GRP",grploc,"SUBGRP",subgrpdr),"^",2)
    .s mData1=$g(^TEMPDHCWL($j,"outputOpall",mLocDesc))
    .s mData2=$g(^TEMPDHCWL($j,"outputInall",mLocDesc))
    .s mLocDesc=$P($g(mData1),"^",1)
    .s mJGNum=$P($g(mData1),"^",2)
    .s mOpTotNum=$P($g(mData1),"^",3)
    .s mOpNum=$P($g(mData1),"^",4)
    .s mEpNum=$P($g(mData1),"^",5)
    .s mEpSwNum=$P($g(mData1),"^",6)
    .s mSrNum=$P($g(mData1),"^",7)
    .s mSrSwNum=$P($g(mData1),"^",8)
    .s mHpJcNum=$P($g(mData1),"^",9)
    .s mOEpPer=$P($g(mData1),"^",10)
    .s mEpSwPer=$P($g(mData1),"^",11)
    .s mGcsSwPer=$P($g(mData1),"^",12)
    .///	zhu住院部分
    .s mGdsycs=$P($g(mData2),"^",2)
    .s mQcyyrs=$P($g(mData2),"^",3)
    .s mQnryrs=$P($g(mData2),"^",4)
    .s mQnzrrs=$P($g(mData2),"^",5)
    .s mCyrszj=$P($g(mData2),"^",6)
    .s mCyrsxj=$P($g(mData2),"^",7)
    .s mZyrs=$P($g(mData2),"^",8)
    .s mHzrs=$P($g(mData2),"^",9)
    .s mWyrs=$P($g(mData2),"^",10)
    .s mSwrs=$P($g(mData2),"^",11)
    .s mQtrs=$P($g(mData2),"^",12)
    .s mZwtkrs=$P($g(mData2),"^",13)
    .s mQmxyrs=$P($g(mData2),"^",14)
    .s mSjkfcs=$P($g(mData2),"^",15)
    .s mSjzycs=$P($g(mData2),"^",16)
    .s mCyzzyz=$P($g(mData2),"^",17)
    .s mZyl=$P($g(mData2),"^",18)
    .s mHzl=$P($g(mData2),"^",19)
    .s mBsl=$P($g(mData2),"^",20)
    .s mBczzcs=$P($g(mData2),"^",21)
    .s mPjbcgzr=$P($g(mData2),"^",22)
    .s mSjbcsyl=$P($g(mData2),"^",23)
    .s mCypjzyr=$P($g(mData2),"^",24)
    .s mCyzzyfy=$P($g(mData2),"^",25)
    .s mRjfy=$P($g(mData2),"^",26)
    .s mOperNum=$P($g(mData2),"^",27)
    .s mRescuNum=$P($g(mData2),"^",28)
    .s mResSucNum=$P($g(mData2),"^",29)
    .s mResPer=$P($g(mData2),"^",30)
    .s mMRDays=eDate-sDate+1
    .;w "mRjfy="_mRjfy,!
    .Do OutRow23
	;s Data=$lb(mLocDesc,,,,,,,,,,,,,,,,,,,,,,,,,,,,,)
    Set qHandle=$lb(0,repid,0)
    ;k ^TEMPDHCWL($j)
    ;k ^mTEMPDHCWLTEST($j)
    
 	Quit $$$OK
 	*/
 	quit 0
OutRow23
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
	s Data=$lb(mLocDesc,mJGNum,mOpTotNum,mOpNum,mEpNum,mEpSwNum,mSrNum,mSrSwNum,mHpJcNum,mOEpPer,mEpSwPer,mGcsSwPer,mGdsycs,mQcyyrs,mQnryrs,mQnzrrs,mCyrszj,mCyrsxj,mZyrs,mHzrs,mWyrs,mSwrs,mQtrs,mZwtkrs,mQmxyrs,mSjkfcs,mSjzycs,mCyzzyz,mZyl,mHzl,mBsl,mBczzcs,mPjbcgzr,mSjbcsyl,mCypjzyr,mCyzzyfy,mRjfy,mOperNum,mRescuNum,mResSucNum,mResPer,mMRDays)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
GetOperNums23()
	n (mMRBase)
	
	q
	
GetHpNum(mSDate,mEDate)
	n (mSDate,mEDate)
	;s mSDate=$zdh("2012-06-02",3)
	;s mEDate=$zdh("2012-06-02",3)
	s mSDate=$zdh(mSDate,3)
	s mEDate=$zdh(mEDate,3)
	s mReturn=0
	f mDate=mSDate:1:mEDate d
	.s mAdmDr=0
	.f  s mAdmDr=$o(^PAADMi("PAADM_AdmDate",mDate,mAdmDr)) q:$g(mAdmDr)=""  d
	..s mAdmType=$p(^PAADM(mAdmDr),"^",2)
	..s mAdmDepDr=$p(^PAADM(mAdmDr),"^",4)
	..s DeptName=$P(^CTLOC(mAdmDepDr),"^",2)
	..Q:DeptName'["体检"
	..q:$g(mAdmDepDr)'=286
	..Q:mAdmType'="H"
	..s mReturn=$g(mReturn)+1
	q $g(mReturn)
 
GetDateHpData23(mDate)
	n (mDate)
	s mReturn=0
	q:$g(mDate)="" $g(mReturn)
	s mDate=$zdh(mDate,3)
	
	i $d(^DHCWLSaveHpData("HpSaveData",mDate))  d
	.s mReturn=$g(^DHCWLSaveHpData("HpSaveData",mDate,643))
	
	q +$g(mReturn)
 	///		 取急诊留观
GetJZLG23(EpisodeID)
	n (EpisodeID)
	s mReturn="VisitStr"
	i EpisodeID="" q $g(mReturn)
	s avsId=""
	f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId),-1) q:$g(avsId)=""  d
	.q:avsId=""
	.s pvsId=$P(^DHCADMVisitStatus(avsId),"^",2)
	.s mVisitStatus=$P(^DHCPACVisitStatus(pvsId),"^",2)
	.s mReturn=$g(mReturn)_"^"_$g(mVisitStatus)
   	q $g(mReturn) 
GetZYPatInfor23(date,Admid,mDepRowid)     ;J儿科急诊观察床位费
 	n (date,Admid,mDepRowid)
 	i $d(^DHCWLLGPatInfor(Admid)) d
 	.s mDatainfo=$G(^DHCWLLGPatInfor(Admid))
 	.s ^mTEMPDHCWLTEST($j,"MM",Admid)=$p($g(mDatainfo),"!",2)
 	.s mReturn=$p($g(mDatainfo),"!",1)
 	q:$d(^DHCWLLGPatInfor(Admid)) $g(mReturn)
 	k ^mTEMPDHCWLTEST($j,"MM",Admid)
 	s mFlag=0
 	s mReturn="ERR"
 	s mNum=0
 	s OEORDRowId="" f  s OEORDRowId=$o(^OEORD(0,"Adm",Admid,OEORDRowId)) q:OEORDRowId=""  d
 	.s oeorsubid="" f  s oeorsubid=$o(^OEORDi(0,"StDt",date,OEORDRowId,oeorsubid)) q:oeorsubid=""  d
 	..s ItmMastDR=$p(^OEORD(OEORDRowId,"I",oeorsubid,1),"^",2)
 	..s mItmQuaty=$p(^OEORD(OEORDRowId,"I",oeorsubid,1),"^",12)
 	..s mDeptDR=$p(^OEORD(OEORDRowId,"I",oeorsubid,1),"^",3)
 	..Q:mDepRowid'=mDeptDR
 	..s mItmMastF=$p(ItmMastDR,"||",1)
 	..s mItmMastS=$p(ItmMastDR,"||",2)
 	..s mItmMastDesc=$p(^ARCIM(mItmMastF,mItmMastS,1),"^",2)        ;指定要退出的项目	//	^ARCIM({ARCIM_Subscript},{ARCIM_Version})
 	..i $g(mItmMastDesc)="急诊观察床位费" d
 	...;w !,"Admid--"_Admid_"---"_mItmMastDesc
 	...q:$g(mFlag)>0
 	...s mFlag=1
 	...s mReturn="儿科^留观"
 	...s mNum=$g(mNum)+$g(mItmQuaty)
 	...s ^mTEMPDHCWLTEST($j,"MM",Admid)=$g(mItmQuaty)+$g(^mTEMPDHCWLTEST($j,"MM",Admid))
 	..i $g(mItmMastDesc)["急诊监护费" d
 	...;w !,"Admid--"_Admid_"---"_mItmMastDesc
 	...s mFlag=1
 	...s mReturn="大留观^留观"
 	...s mNum=1
 	...s ^mTEMPDHCWLTEST($j,"MM",Admid)=1
 	s ^DHCWLLGPatInfor(Admid)=$g(mReturn)_"!"_$G(^mTEMPDHCWLTEST($j,"MM",Admid))
 	q $g(mReturn)

	///	globle名称	存储元素	存储值	存储标志
 	///	SaveData^aaadhcwanvdsltest()
SaveData23(mGlobleName,mStr,mValue,mIndex)
	n (mGlobleName,mStr,mValue,mIndex)
	;s mStr="w^a^n^v^d^s^l"
	;s mValue="123"
	;s mIndex="output"
	;s mGlobleName="^TempWanvdsl()"
	q:($g(mGlobleName)="")&($g(mStr)="")&($g(mValue)="")&($g(mIndex)="")
	s mA=$p($g(mGlobleName),")",1)_"$j,"_"mIndex"
	s mLen=$l(mStr,"^")
	f i=1:1:mLen d
	.s mDt=$p($g(mStr),"^",i)
	.s mDst="s mDt="_mDt
	.s mA=$g(mA)_","""_mDt_""""
	.s mB=$g(mA)_")"
	.;s mDcx="s mC=+$g("_mB_")"
	.;x mDcx
	.;w !,"mDcx---"_mC
	.;s mDbx="s "_mB_"=mC+mValue"
	.s mDbx="s "_mB_"=$g("_mB_")+mValue"
	.x mDbx
	q 	
	


BedNum23(Date,LocOrWardFlag,LocOrWardId)
 ;w $$BedNum^DHCMRIPday("61354","Ward","1") 
 n (Date,LocOrWardFlag,LocOrWardId,MRRowId,Return,MRGDNum,MRSYNum,MRBZNum)
 s MRRowId=""
 s Return=0_"^"_0_"^"_0
 i $d(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId))  d
 .s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One
 e  d
 .s Date=$o(^DHCMRBed(0,LocOrWardFlag,LocOrWardId,"Date",Date),-1)
 .i Date'="" s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One Or No Exist
 q:MRRowId="" Return
 s MRGDNum=$p(^DHCMRBed(MRRowId),"^",3)   //固定
 s MRSYNum=$p(^DHCMRBed(MRRowId),"^",4)    //现有
 s MRBZNum=$p(^DHCMRBed(MRRowId),"^",5)    //备注
 s Return=MRGDNum_"^"_MRSYNum_"^"_MRBZNum
 q Return
GetDepSubLocDetail23(mGroupDr)
	n (mGroupDr)
	k ^mTEMPDHCWLTEST($j,"SubLocDetail")
	q:$g(mGroupDr)=""
	q:'$d(^DHCWLCFG("GRP",mGroupDr))
	;b	//
	s mSubDr=0
	f  s mSubDr=$o(^DHCWLCFG("GRP",mGroupDr,"SUBGRP",mSubDr)) q:$g(mSubDr)=""  d
	.s mGroupSubDr=$g(mGroupDr)_"||"_$g(mSubDr)
	.s mSubDepId=0
	.f  s mSubDepId=$o(^DHCWLCFGR("SUBGRPDEP","SUBGRP",mGroupSubDr,mSubDepId)) q:$g(mSubDepId)=""  d
	..s mDepDr=$p($g(^DHCWLCFGR("SUBGRPDEP",mSubDepId)),"^",3) 
	..i mDepDr'="" d
	..s ^mTEMPDHCWLTEST($j,"SubLocDetail",mDepDr)=mSubDr
	q
}

ClassMethod GetDepSubLocDetail15(mGroupDr)
{
	n (mGroupDr)
	q:$g(mGroupDr)=""
	q:'$d(^DHCWLCFG("GRP",mGroupDr))
	;b	//
	s mSubDr=0
	f  s mSubDr=$o(^DHCWLCFG("GRP",mGroupDr,"SUBGRP",mSubDr)) q:$g(mSubDr)=""  d
	.s mGroupSubDr=$g(mGroupDr)_"||"_$g(mSubDr)
	.s mSubDepId=0
	.f  s mSubDepId=$o(^DHCWLCFGR("SUBGRPDEP","SUBGRP",mGroupSubDr,mSubDepId)) q:$g(mSubDepId)=""  d
	..s mDepDr=$p($g(^DHCWLCFGR("SUBGRPDEP",mSubDepId)),"^",3) 
	..i mDepDr'="" d
	..s ^mTEMPDHCWLTEST($j,"SubLocDetail",mDepDr)=mSubDr
	q
}

ClassMethod BedNum15(Date, LocOrWardFlag, LocOrWardId)
{
 ;w $$BedNum^DHCMRIPday("61354","Ward","1") 
 n (Date,LocOrWardFlag,LocOrWardId,MRRowId,Return,MRGDNum,MRSYNum,MRBZNum)
 s MRRowId=""
 s Return=0_"^"_0_"^"_0
 i $d(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId))  d
 .s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One
 e  d
 .s Date=$o(^DHCMRBed(0,LocOrWardFlag,LocOrWardId,"Date",Date),-1)
 .i Date'="" s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One Or No Exist
 q:MRRowId="" Return
 s MRGDNum=$p(^DHCMRBed(MRRowId),"^",3)
 s MRSYNum=$p(^DHCMRBed(MRRowId),"^",4)
 s MRBZNum=$p(^DHCMRBed(MRRowId),"^",5)
 s Return=MRGDNum_"^"_MRSYNum_"^"_MRBZNum
 q Return
}

Storage Default
{
<StreamLocation>^dhc.bonus1BEE.uGetClinicC5ECBS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
