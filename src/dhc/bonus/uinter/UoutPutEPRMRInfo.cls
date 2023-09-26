/// 用于跟出院有关的指标
Class dhc.bonus.uinter.UoutPutEPRMRInfo Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).outPutEPRMRInfo("2014-07-26","2014-08-25",2)
ClassMethod outPutEPRMRInfo(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
 n (mSDate,mEDate,sMethodDr)
 
 	s flag=0
	s startDate=$zdh(mSDate,3)
	s endDate=$zdh(mEDate,3)
	
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s YearMonth=Year_"-"_Month
    s sMonth="M"_Month

    s loc="" F  S loc=$o(^MRIPdaily("MRIPloc",loc)) q:loc=""  d 
    .s rs="0",rstotal="0"
    .f date=startDate:1:endDate d
    ..s mriprid="" s mriprid=$o(^MRIPdaily("MRIPloc",loc,"MRIPdate",date,mriprid)) q:mriprid=""  d
    ...s rs=$p(^MRIPdaily(mriprid),"^",26)
    ...s rstotal=$p(^MRIPdaily(mriprid),"^",26)+$g(rstotal)
    .w loc_"++"_rstotal,!
    
   
	s startDate=$zdh(mSDate,3)
	s endDate=$zdh(mEDate,3)
	s flag="OK",KpiCode="0136", deptCodeHos="AAAAAAAAAA"			
	f date=startDate:1:endDate d
	.s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",date,mrId)) q:mrId=""  d
	..s loc=$p(^MRIPdaily(mrId),"^",7)      //科室
	..q:loc=""
	..s Dimension=deptCodeHos_","_loc       //维度：全院,科室
	..s cyzyzcs=0							
	..s rowid="" f  s rowid=$o(^DHCMRIPDetail(0,"IPType",mrId,"CYRS",rowid)) q:rowid=""  d
 	...s admid=$p(^DHCMRIPDetail(rowid),"^",1)
	...s paadmDate=$P(^PAADM(admid),"^",6)
	...s paadmDisDate=$P(^PAADM(admid),"^",17)		//以最终结算时间为准
	...i $g(paadmDisDate)="" s paadmDisDate=+$h
	...s zyts=paadmDisDate-paadmDate
	...i zyts<=0 s zyts=1
	...s cyzyzcs=cyzyzcs+zyts       	            //出院患者占用总床日数
	...s coun = ..CountZYTS(admid)
	...s ^TMPDHCBONUS("CYZZYCR",loc) = $G(^TMPDHCBONUS("CYZZYCR",loc)) + coun
	...;s result= $$CreatTempGlobal^DHCEBIVInterCommon(Dimension,KpiCode,cyzyzcs) 
	...;i result'="OK"  s flag=result
  
 q 0
}

/// 住院天数
ClassMethod GetInDays(Admid) As %String
{
	n (Admid)
	s Return=0
	Q:'$D(^PAADM(Admid)) $g(Return)
	s AdmDate=$P(^PAADM(Admid),"^",6)
	s AdmDisDate=$P(^PAADM(Admid),"^",17)
	i (+$g(AdmDate)'=0)&&(+$g(AdmDisDate)'=0) d
	.s Return=$g(AdmDisDate)-$g(AdmDate)
	Q $g(Return)
}

/// 计算住院天数
ClassMethod CountZYTS(adid) As %String
{
	
 s admdate=$p(^PAADM(adid),"^",6)  ;入院日期	
 s disdate=$p(^PAADM(adid),"^",59) ;出院日期	
 i +$G(disdate)=0 s zyts=+$h-admdate+1  ;住院天数
 e  s zyts=disdate-admdate+1 
 i $G(zyts)<0 s zyts=+$h-admdate+1  ;住院天数

 q $G(zyts)
}

/// 
///  功能：表DHCMRBed，获得科室/病区的实际床位数	
ClassMethod BedNum(Date, LocOrWardFlag, LocOrWardId) As %String
{
	n (Date, LocOrWardFlag, LocOrWardId)
 	s MRRowId=""
 	s Return=0_"^"_0_"^"_0
 	i $d(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId))  d
	.s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) 
 	e  d
 	.s Date=$o(^DHCMRBed(0,LocOrWardFlag,LocOrWardId,"Date",Date),-1)
 	.i Date'="" s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) 
 	q:MRRowId="" Return
 	s MRGDNum=$p(^DHCMRBed(MRRowId),"^",3)
 	s MRSYNum=$p(^DHCMRBed(MRRowId),"^",4)
	s MRBZNum=$p(^DHCMRBed(MRRowId),"^",5)
	s Return=MRGDNum_"^"_MRSYNum_"^"_MRBZNum
	q Return
}

/// Descript:入院人数、病历份数、住院床日、开放床日、使用床日
/// Input:Stdate-开始日期,Endate-结束日期
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).GetInpatients("2014-07-26","2014-08-25",1) 
ClassMethod GetInpatients(Stdate As %String, Endate As %String, MethodDr As %String) As %String
{
 n (Stdate,Endate,MethodDr)
 s deptCodeHos="AAAAAAAAAA"  			

 s Year=$p(Endate,"-",1)
 s Month=$p(Endate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 
 ;s ^hahah = 0
 s Stdate=$zdh(Stdate,3)
 s Endate=$zdh(Endate,3)  
 ;"RYRC" 入院人次 "CYRS" 出院人次 "ks"
 k ^TMPDHCBONUS(YM)
 s loctype="Loc"			//按照科室统计科室入院人数 loc 按照病区统计 Ward 
 s kpiCode="his_ryrs", kpiName="入院人数"
 i loctype="Loc" s Piece=7   //按照科室统计
 f day=Stdate:1:Endate  d
 .d ..InOutDetial(day,"KS","ZCKS",YM)    //科室转出
 .d ..InOutDetial(day,"KS","ZRKS",YM)    //科室转入
 .s ipdr=0 f  s ipdr=$o(^MRIPdaily("MRIP_DATE",day,ipdr)) q:ipdr=""  d
 ..s locdr=$p(^MRIPdaily(ipdr),"^",Piece) 
 ..q:locdr="" 
 ..;w locdr_"++"_ipdr,!
 ..s ryrs=$p(^MRIPdaily(ipdr),"^",8)    //入院人数
 ..s cyrs=$p(^MRIPdaily(ipdr),"^",5)    //出院人数
 ..s sjzycr=$p(^MRIPdaily(ipdr),"^",26) //实际占床日  
 ..s xyrs=$p(^MRIPdaily(ipdr),"^",18) //现有人数  
 ..s msjkfcr=$p(..BedNum(day,"Loc",locdr),"^",1) //实际开放床日
 ..;i msjkfcr = 0 s sjzycr=0
 ..s ^TMPDHCBONUS(YM,"RYRC",locdr) = $G(^TMPDHCBONUS(YM,"RYRC",locdr)) + ryrs     ;入院人数
 ..s ^TMPDHCBONUS(YM,"CYRS",locdr) = $G(^TMPDHCBONUS(YM,"CYRS",locdr)) + cyrs     ;出院人数
 ..s ^TMPDHCBONUS(YM,"SJZYCR",locdr)= $G(^TMPDHCBONUS(YM,"SJZYCR",locdr)) + xyrs  ;实际占床日
 ..s ^TMPDHCBONUS(YM,"SJKFCR",locdr)= $G(^TMPDHCBONUS(YM,"SJKFCR",locdr))+msjkfcr ;实际开放床日
 ..i $G(cyrs) '= "" d
 ...s IPDERowid="" f  s IPDERowid=$o(^DHCMRIPDetail(0,"IPType",ipdr,"CYRS",IPDERowid)) q:IPDERowid=""  d
 ....s mAdmId=$P(^DHCMRIPDetail(IPDERowid),"^",1)
 ....s InDays = 0
 ....s paadmDate=$P(^PAADM(mAdmId),"^",6)
 ....s paadmDisDate=$P(^PAADM(mAdmId),"^",59)
 ....i $g(paadmDisDate)="" s paadmDisDate=+$h
 ....s InDays=paadmDisDate-paadmDate+1
 ....i InDays<=0 s InDays=1
 ....;w InDays,!
 ....s ^TMPDHCBONUS(YM,"CYZZYCR",locdr) = $G(^TMPDHCBONUS(YM,"CYZZYCR",locdr)) + InDays ;出院者占用床日

 
 
 &sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode IN ('0300020','0300100','0200020','0200010','0300060') )

 s IndCode = "0300020"
 s IndName = "入院人次"
 s DeptDr = ""
 f  s DeptDr = $O(^TMPDHCBONUS(YM,"RYRC",DeptDr))   q:DeptDr=""  d
 .s ryrs = $G(^TMPDHCBONUS(YM,"RYRC",DeptDr))
 .;w DeptDr_"++"_pjzycr,!
 .s ResDesc = $P(^CTLOC(DeptDr),"^",1)
 .;w Year_sMonth_ResDesc_ryrs,!
 .&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	   values(:IndCode,:IndName,:DeptDr,:ResDesc,:Year, :sMonth,:ryrs,getdate(), 0,0,:MethodDr))
		
 ///病历份数=出院人次 前面的工程师建指标时有重复，病历份数有两个0300100，0600480 数据上传时再分开
 
 s IndCode= "0300100"
 s IndName= "病历份数"
 s DeptDr = ""
 f  s DeptDr = $O(^TMPDHCBONUS(YM,"CYRS",DeptDr))   q:DeptDr=""  d
 .s cyrc = $G(^TMPDHCBONUS(YM,"CYRS",DeptDr))
 .s ResDesc = $P(^CTLOC(DeptDr),"^",1)
 .s pjzycr = 0
 .i cyrc '= 0 s pjzycr = $G(^TMPDHCBONUS(YM,"CYZZYCR",DeptDr))/cyrc
 .&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	   values(:IndCode,:IndName,:DeptDr,:ResDesc,:Year, :sMonth,:cyrc,getdate(), 0,0,:MethodDr))
 .&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	   values('0200020','平均住院床日实际值',:DeptDr,:ResDesc,:Year, :sMonth,:pjzycr,getdate(), 0,0,:MethodDr))

 ///住院床日 0300060 0600470 床位使用率实际值=住院床日/实际开放床日0200010 ^TMPDHCBONUS(YM,"SJZYCR",locdr) SJKFCR
 s DeptDr = ""
 f  s DeptDr = $O(^TMPDHCBONUS(YM,"SJZYCR",DeptDr))   q:DeptDr=""  d 
 .s zycr = $G(^TMPDHCBONUS(YM,"SJZYCR",DeptDr))
 .s ResDesc = $P(^CTLOC(DeptDr),"^",1)
 .s cwsyl= 0
 .;i $G(^TMPDHCBONUS(YM,"SJKFCR",DeptDr))'=0 w zycr/$G(^TMPDHCBONUS(YM,"SJKFCR",DeptDr)),!
 .i $G(^TMPDHCBONUS(YM,"SJKFCR",DeptDr))'=0 s cwsyl = zycr/$G(^TMPDHCBONUS(YM,"SJKFCR",DeptDr))
 .&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	   values('0300060','住院床日',:DeptDr,:ResDesc,:Year, :sMonth,:zycr,getdate(), 0,0,:MethodDr))
 .&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	   values('0200010','床位使用率实际值',:DeptDr,:ResDesc,:Year, :sMonth,:cwsyl,getdate(), 0,0,:MethodDr))
 ///科室转入、科室转出
  ;^TMPDHCBONUS(201408,"KS","ZRKS",) ^TMPDHCBONUS(201408,"KS","ZCKS",)
 s DeptDr = ""
 f  s DeptDr = $O(^TMPDHCBONUS(YM,"KS","ZRKS",DeptDr))   q:DeptDr=""  d 
 .s kszr = $G(^TMPDHCBONUS(YM,"KS","ZRKS",DeptDr))
 .s ResDesc = $P(^CTLOC(DeptDr),"^",1)
 .&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	   values('0100002','科室转入',:DeptDr,:ResDesc,:Year, :sMonth,:kszr,getdate(), 0,0,:MethodDr))

 s DeptDr = ""
 f  s DeptDr = $O(^TMPDHCBONUS(YM,"KS","ZCKS",DeptDr))   q:DeptDr=""  d 
 .s kszc = $G(^TMPDHCBONUS(YM,"KS","ZCKS",DeptDr))
 .s ResDesc = $P(^CTLOC(DeptDr),"^",1)
 .&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	   values('0100003','科室转出',:DeptDr,:ResDesc,:Year, :sMonth,:kszc,getdate(), 0,0,:MethodDr))
 k ^TMPDHCBONUS(YM)
 q 0
}

/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).GetregHoldData("2013-08-26","2014-09-25") 
ClassMethod GetregHoldData(Stdate, Endate) As %String
{
 n (Stdate,Endate)
 s deptCodeHos="AAAAAAAAAA"  //全院的单元代码为 AAAAAAAAAA			
 
 k ^TMPDHCBONUS("201409","SYRC")
 s Stdate=$zdh(Stdate,3)
 s Endate=$zdh(Endate,3)
 
 f date=Stdate:1:Endate d
 .q:'$d(^User.DHCBeforeRegI("DateDeptDoc"," "_date))
 .;w "sdcf",!
 .s deptDr=0
 .f  s deptDr=$o(^User.DHCBeforeRegI("DateDeptDoc"," "_date,deptDr)) q:deptDr=""  d
 ..s docDr=0
 ..f  s docDr=$o(^User.DHCBeforeRegI("DateDeptDoc"," "_date,deptDr,docDr)) q:docDr=""  d
 ...s beforeID=0,flag=""
 ...f  s beforeID=$o(^User.DHCBeforeRegI("DateDeptDoc"," "_date,deptDr,docDr,beforeID)) q:beforeID=""  d
 ....;b
 ....q:'$d(^User.DHCBeforeRegD(beforeID))
 ....s flag=$List($g(^User.DHCBeforeRegD(beforeID)),5)
 ....q:flag=1
 ....s ^TMPDHCBONUS("201409","SYRC",deptDr)=$G(^TMPDHCBONUS("201409","SYRC",deptDr))+1
 ....;s Dimension=deptCodeHos_","_$tr(deptDr," ","")
 ....;s result=$$CreatTempGlobal^DHCEBIVInterCommon(Dimension,"2157",1)
 q 0
}

/// 挂号人次、急诊人次     门诊人次:0300010  急诊人次:0300030 
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).RegistNumber("2014-08-26","2014-09-25",5) 
ClassMethod RegistNumber(Stdate As %String, Endate As %String, MethodDr As %String) As %String
{

 n (Stdate,Endate,MethodDr)	
 s Year=$p(Endate,"-",1)
 s Month=$p(Endate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 
 s Stdate=$zdh(Stdate,3)
 s Endate=$zdh(Endate,3) 
 ;挂号人次
 k ^TMPDHCBONUS(YM,"GHRC")
 s deptCodeHos="AAAAAAAAAA"  //全院的单元代码为 AAAAAAAAAA
 
 /**	
 f date=Stdate:1:Endate d
 .s regID=0
 .f  s regID=$o(^DHCWorkRegReport(0,"ADMDATE",date,regID)) q:regID=""  d
 ..s admType="",admRef="",Dimension="",admStatusDesc="",SpecialistYN="",Count=0,RegisFee=""
 ..i $d(^DHCWorkRegReport(regID)) d
 ...i $g(^DHCWorkRegReport(regID))'="" d
 ....s mLocDr=$p(^DHCWorkRegReport(regID),"^",5)
 ....s mDocDr1=$p(^DHCWorkRegReport(regID),"^",6)
 ....s mDocDr=$p(^CTPCP(mDocDr1,1),"^",1)
 ....q:($g(mLocDr)="")!($g(mDocDr)="")
 ....s admDr=$p(^DHCWorkRegReport(regID),"^",15)  //就诊号 
 ....s admRes=$p(^DHCWorkRegReport(regID),"^",9) //预约
 ....s Count=$p($g(^DHCWorkRegReport(regID)),"^",29) //挂号人次
 ....s admStatus=$p(^DHCWorkRegReport(regID),"^",7) //病人身份 取医保
 
 ....i admStatus'="" d
 .....i $d(^DHCWLSSCFG(admStatus)) d
 ......s admStatusDesc=^DHCWLSSCFG(admStatus)
 ....i admDr'="" d
 .....i $d(^PAADM(admDr)) d
 ......s deptDr=$p(^PAADM(admDr),"^",4)  //2013-12-02 add
 ......s docDr=$p(^PAADM(admDr),"^",9)    //2013-12-02 add
 ......s admType=$p($g(^PAADM(admDr)),"^",2) //挂号类别
 ......s admRef=$p($g(^PAADM(admDr)),"^",56) //初复诊
 ......s RegisFee=$O(^User.DHCRegistrationFeeI("ADM"," "_admDr,""))
 ....i docDr'="" d
 .....i $d(^CTPCP(docDr,1)) d
 ......s SpecialistYN=$p($g(^CTPCP(docDr,1)),"^",16) //是否为主任、主治医师
 ....i (deptDr'="")&&(docDr'="") d
 .....s Dimension=deptCodeHos_","_deptDr_","_docDr
 ....e  i (deptDr'="") d
 .....s Dimension=deptCodeHos_","_deptDr_","_docDr
 ....i RegisFee'="" d
 .....s RegfeeArcDr=$List(^User.DHCRegistrationFeeD(RegisFee),3)
 ....;s KPICodes="0300010"            //挂号人次
 ....;i admType="E" d              //急诊人次
 .....;s KPICodes="0300030"   ;s KPICodes="0128"_","_KPICodes
 ....;w admType_"++",!
 ....s ^TMPDHCBONUS(YM,"GHRC",deptDr) = $G(^TMPDHCBONUS(YM,"GHRC",deptDr)) + Count
 **/
 //s Counts=$p(^DHCWorkLoad(WLRowid),"^",15)
 	f date=Stdate:1:Endate  d
	.s mRegId=0
	.f  s mRegId=$o(^DHCWorkRegReport(0,"ADMDATE",date,mRegId)) q:$g(mRegId)=""  d
	..q:'$d(^DHCWorkRegReport(mRegId))
	..s mLocDr=$p(^DHCWorkRegReport(mRegId),"^",5)     //所挂科室dr
	..s mDocDr1=$p(^DHCWorkRegReport(mRegId),"^",6)
	..s RegTypeDR=$p(^DHCWorkRegReport(mRegId),"^",34) //挂号类别dr
	..s mDocDr=$p(^CTPCP(mDocDr1,1),"^",1)
	..s mRegNum=$p(^DHCWorkRegReport(mRegId),"^",29)   //挂号人次
	..s ttt=$p(^DHCWorkRegReport(mRegId),"^",31)    //挂退号
	..;w mRegNum_"++"_ttt,!
	..q:($g(mLocDr)="")!($g(mDocDr)="")!($g(RegTypeDR)="")
	..s ^TMPDHCBONUS(YM,"GHRC",mLocDr) = $G(^TMPDHCBONUS(YM,"GHRC",mLocDr)) + $g(mRegNum)
   
 &sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode in ( '0300010','0300030') )
 s DeptDr = ""
 f  s DeptDr = $O(^TMPDHCBONUS(YM,"GHRC",DeptDr))   q:DeptDr=""  d
 . s IndCode = "0300010"
 .s IndName = "门诊人次"
 .s ghrc = $G(^TMPDHCBONUS(YM,"GHRC",DeptDr))
 .i DeptDr = 54 d
 ..s IndCode = "0300030"
 ..s IndName = "急诊人次"
 .s ResDesc = $P(^CTLOC(DeptDr),"^",1)
 .&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:IndCode,:IndName,:DeptDr,:ResDesc,:Year, :sMonth,:ghrc,getdate(), 0,0,:MethodDr)
		)
 /*
 f OrdDate=StartDay:1:EndDay d
 .s Ratio=$$GetRegFeeRatioFromDate^DHCWLRegStat(OrdDate)
 .s RRatio=$p(Ratio,"^",1)
 .s DRatio=$p(Ratio,"^",2)
 .s Cons=$p(Ratio,"^",3)
 .f  s RegTypeRowid=$o(^CTLOC(0,"LocType","OR",RegTypeRowid)) q:RegTypeRowid=""  d
 ..;*************************************************************************************************************
 ..;修改根据不同的医院取挂号类别
 ..;edit by 2005-10-24
 ..;q:'$d(^CHBCi("RegFee","Room",RegTypeRowid))
 ..;s RegOfArcimDr=0
 ..;s RegOfArcimDr=$O(^CHBCi("RegFee","Room",RegTypeRowid,RegOfArcimDr))
 ..s RegOfArcimDr=$$TransRegTypeToARCIM^DHCWLReg(HosRowid,RegTypeRowid)
 ..;*************************************************************************************************************
 ..s WLRowid=0
 ..f  s WLRowid=$o(^DHCWorkLoad(0,"DateItemOrd",OrdDate,RegOfArcimDr,WLRowid)) q:WLRowid=""  d
 ...s DayFlag=$p(^DHCWorkLoad(WLRowid),"^",20)   ;帐单号?在挂号的时候存的是上下午的标志?-1为上午?-2为下午?其他为0
 ...s RegDepDr=$p(^DHCWorkLoad(WLRowid),"^",1)   ;病人的挂号科室
 ...i RegDepDr="" s RegDepDr=99999
 ...s RegDocDr=$p(^DHCWorkLoad(WLRowid),"^",18)  ;病人的挂号医生
 ...i RegDocDr="" s RegDocDr=99999
 ...s Counts=$p(^DHCWorkLoad(WLRowid),"^",15)    ;挂号次数
 */		
		

 q 0
}

/// 日期：2015-08-7
/// 作者：zlg
/// 说明：采集科室门诊、住院收入，规则见《直接收入核算规则表》
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).MedicineIncome2("2014-02-01","2014-02-27",9)  
ClassMethod MedicineIncome2(Stdate As %String, Endate As %String, MethodDr As %String) As %String
{
	
 n (Stdate,Endate,MethodDr)	
 s Year=$p(Endate,"-",1)
 s Month=$p(Endate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 
 ;s startDate=$zdh(Stdate,3)
 ;s endDate=$zdh(Endate,3)
 ;"ZXYSR" 中西药收入 "KSZJSR" 科室直接收入
 k ^TMPDHCBONUS(YM,"ZXYSR")
 k ^TMPDHCBONUS(YM,"O")	
 k ^TMPDHCBONUS(YM,"I")	
 k ^TMPDHCBONUS(YM,"KSZJSR")
 k ^TMPDHCBONUS(YM,"TJSS")
 s deptCodeHos="AAAAAAAAAA"  //全院的单元代码为 AAAAAAAAAA
 s SDate=$zdh(Stdate,3)
 s EDate=$zdh(Endate,3)
 s Price=0
 s count = 0
 
 f OrdDate=SDate:1:EDate d
 .s WLRowid=0
 .f  s WLRowid=$o(^DHCWorkLoad(0,"FlagDate",OrdDate,WLRowid)) q:WLRowid=""  d
 ..s RecDep=$p(^DHCWorkLoad(WLRowid),"^",1) ;接收科室
 ..s ResLoc=$p(^DHCWorkLoad(WLRowid),"^",3) ;病人科室
 ..s PatLoc=$p(^DHCWorkLoad(WLRowid),"^",23) ;开医嘱科室
 ..s PAADMType=$p(^DHCWorkLoad(WLRowid),"^",4) ;病人类型
 ..q:PAADMType="E"
 ..q:PAADMType="H"
 ..;q:PAADMType="I"
 ..s ResDocId=$p($g(^DHCWorkLoad(WLRowid)),"^",25)  ;病人医师
 ..i ResDocId="" s ResDocId="999999"
 ..s Price=$p(^DHCWorkLoad(WLRowid),"^",16)
 ..s TarCateSc=$p(^DHCWorkLoad(WLRowid),"^",41)    ;核算子分类
 ..i TarCateSc="" s TarCateSc="999999"
 ..s Dimension=deptCodeHos_","_ResLoc_","_ResDocId      //全院，科室、医生 
 ..s KpiCodes="0117" 	//门诊总收入
 ..i TarCateSc="" s Eccatdesc=""
 ..i TarCateSc'="" s Eccatdesc=$p($g(^DHCTarC("EC",TarCateSc)),"^",2)      //名称
  
 ..s supDeptID="" 

 ..;门诊收入
 ..i ((PAADMType = "I") ) d 
 ...;-----门诊收入规则------	
 ... s RecDepYM="YM"_RecDep ;医疗组门诊科室
 ...s supDeptID=..GetSupDeptID(RecDepYM)	
 	
 ...i ((Eccatdesc="CT费")||(Eccatdesc="中药费")||(Eccatdesc="会诊费")) d ;增加其他？？？？
 ....I supDeptID="?????" d ;社区卫生科室ID
 .....s ^TMPDHCBONUS("MZ1",YM,supDeptID) = $G(^TMPDHCBONUS("MZ1",YM,supDeptID))+Price
 ....e  d
 .....i supDeptID'="" d
 ......s ^TMPDHCBONUS("YM1",YM,supDeptID) = $G(^TMPDHCBONUS("YM1",YM,supDeptID))+(Price*0.1)
  ...i ((Eccatdesc="机械材料子新")||(Eccatdesc="消化组材料")||(Eccatdesc="器械材料")) d ;增加其他？？？？
 ....I supDeptID="?????" d ;药品配送科ID
 .....s ^TMPDHCBONUS("YM1",YM,supDeptID) = $G(^TMPDHCBONUS("YM1",YM,supDeptID))+(Price*0.1)
 ....e  d
 .....i supDeptID'="" d
 ......s ^TMPDHCBONUS("YM2",YM,supDeptID) = $G(^TMPDHCBONUS("YM2",YM,supDeptID))+sumJe
  
 ...s RecDepHM="HM"_RecDep ;护理组门诊科室
 ...s supDeptID=..GetSupDeptID(RecDepYM)
 ...i ((Eccatdesc="CT费")||(Eccatdesc="中药费")||(Eccatdesc="会诊费")) d ;增加其他？？？？
 ....;------处理护理组科室收入-------
 ....I supDeptID="?????" d ;社区卫生科室ID
 .....s ^TMPDHCBONUS("HM1",YM,supDeptID) = $G(^TMPDHCBONUS("HM1",YM,supDeptID))+Price
 ....e  d
 .....i supDeptID'="" d
 ......s ^TMPDHCBONUS("HM1",YM,supDeptID) = $G(^TMPDHCBONUS("HM1",YM,supDeptID))+(Price*0.1)
 ...i ((Eccatdesc="机械材料子新")||(Eccatdesc="消化组材料")||(Eccatdesc="器械材料")) d ;增加其他？？？？
 ....I supDeptID="?????" d ;药品配送科ID
 .....s ^TMPDHCBONUS("HM1",YM,supDeptID) = $G(^TMPDHCBONUS("HM1",YM,supDeptID))+(Price*0.1)
 ....e  d
 .....i supDeptID'="" d
 ......s ^TMPDHCBONUS("HM2",YM,supDeptID) = $G(^TMPDHCBONUS("HM2",YM,supDeptID))+sumJe

  
  
  
 q 0
}

/// 日期：2015-08-7
/// 作者：zlg
/// 说明：取上级科室ID
/// 参数：科室编码
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).GetSupDeptID("66")  
ClassMethod GetSupDeptID(DeptCode As %String) As %String
{
	n (DeptCode)
		
	q:DeptCode ""
 	i $D(^dhcbsBonusUnitI("BonusUnitCode",DeptCode)) d 
 	.s rowid="" ; 
 	.s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",DeptCode,rowid))
 	.i rowid'="" d
 	..s supDeptID=$LI(^dhcbsBonusUnitD(rowid),6) ;取上级单位ID
}

/// 中药费  西药费 
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).MedicineIncome("2014-02-01","2014-02-27",9)  
ClassMethod MedicineIncome(Stdate As %String, Endate As %String, MethodDr As %String) As %String
{
	
 n (Stdate,Endate,MethodDr)	
 s Year=$p(Endate,"-",1)
 s Month=$p(Endate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 
 ;s startDate=$zdh(Stdate,3)
 ;s endDate=$zdh(Endate,3)
 ;"ZXYSR" 中西药收入 "KSZJSR" 科室直接收入
 k ^TMPDHCBONUS(YM,"ZXYSR")
 k ^TMPDHCBONUS(YM,"O")	
 k ^TMPDHCBONUS(YM,"I")	
 k ^TMPDHCBONUS(YM,"KSZJSR")
 k ^TMPDHCBONUS(YM,"TJSS")
 s deptCodeHos="AAAAAAAAAA"  //全院的单元代码为 AAAAAAAAAA
 s SDate=$zdh(Stdate,3)
 s EDate=$zdh(Endate,3)
 s Price=0
 s count = 0
 
 f OrdDate=SDate:1:EDate d
 .s WLRowid=0
 .f  s WLRowid=$o(^DHCWorkLoad(0,"FlagDate",OrdDate,WLRowid)) q:WLRowid=""  d
 ..s RecDep=$p(^DHCWorkLoad(WLRowid),"^",1) ;接收科室
 ..s ResLoc=$p(^DHCWorkLoad(WLRowid),"^",3) ;病人科室
 ..s PatLoc=$p(^DHCWorkLoad(WLRowid),"^",23) ;开医嘱科室
 ..s PAADMType=$p(^DHCWorkLoad(WLRowid),"^",4) ;病人类型
 ..q:PAADMType="E"
 ..q:PAADMType="H"
 ..;q:PAADMType="I"
 ..s ResDocId=$p($g(^DHCWorkLoad(WLRowid)),"^",25)  ;病人医师
 ..i ResDocId="" s ResDocId="999999"
 ..s Price=$p(^DHCWorkLoad(WLRowid),"^",16)
 ..s TarCateSc=$p(^DHCWorkLoad(WLRowid),"^",41)    ;核算子分类
 ..i TarCateSc="" s TarCateSc="999999"
 ..s Dimension=deptCodeHos_","_ResLoc_","_ResDocId      //全院，科室、医生 
 ..s KpiCodes="0117" 	//门诊总收入
 ..i TarCateSc="" s Eccatdesc=""
 ..i TarCateSc'="" s Eccatdesc=$p($g(^DHCTarC("EC",TarCateSc)),"^",2)      //名称
 ..i Eccatdesc["草药" d
 ...s ^TMPDHCBONUS(YM,"ZXYSR",PatLoc,"0100006^中药费") = $G(^TMPDHCBONUS(YM,"ZXYSR",PatLoc,"0100006^中药费"))+Price
 ...s ^TMPDHCBONUS(YM,"ZXYSR",PatLoc,"0200050^中药使用实际值") = $G(^TMPDHCBONUS(YM,"ZXYSR",PatLoc,"0200050^中药使用实际值"))+Price
 ...;如果是住院病人中药使用实际值要算两次给开单科室和住院科室都加
 ...i PAADMType = "I" s ^TMPDHCBONUS(YM,"ZXYSR",ResLoc,"0200050^中药使用实际值") = $G(^TMPDHCBONUS(YM,"ZXYSR",ResLoc,"0200050^中药使用实际值"))+Price
 ..i ((Eccatdesc["西药")||(Eccatdesc["成药"))&(RecDep'=94) s ^TMPDHCBONUS(YM,"ZXYSR",PatLoc,"0100005^西\成药费") = $G(^TMPDHCBONUS(YM,"ZXYSR",PatLoc,"0100005^西\成药费"))+Price
 ..;以下global数据不对时方便查找错误，分开统计各类数据（门诊、住院，西药，草药，成药）
 ..i (Eccatdesc["成药")&(RecDep'=94) s ^TMPDHCBONUS(YM,PAADMType,$P(^CTLOC(PatLoc),"^",1),"CY") = $G(^TMPDHCBONUS(YM,PAADMType,$P(^CTLOC(PatLoc),"^",1),"CY"))+Price
 ..i Eccatdesc["西药" s ^TMPDHCBONUS(YM,PAADMType,$P(^CTLOC(PatLoc),"^",1),"XY") = $G(^TMPDHCBONUS(YM,PAADMType,$P(^CTLOC(PatLoc),"^",1),"XY"))+Price
 ..i Eccatdesc["草药" s ^TMPDHCBONUS(YM,PAADMType,$P(^CTLOC(PatLoc),"^",1),"ZY") = $G(^TMPDHCBONUS(YM,PAADMType,$P(^CTLOC(PatLoc),"^",1),"ZY"))+Price
 ..;i Eccatdesc["手术" s count = count+Price
 ..;i Eccatdesc["草药" s ^TMPDHCBONUS(YM,PAADMType,$P(^CTLOC(RecDep),"^",1),"")=$G(^TMPDHCBONUS(YM,PAADMType,$P(^CTLOC(RecDep),"^",1),"test"))+Price
 ..;特检费，手术费
 ..;i RecDep = 29 w Eccatdesc_"++",!
 ..s temstr = ..JudgeConditions(Eccatdesc,1)
 ..i temstr = "Y" d
 ...s tempIndic = "0100007^特检费"
 ...i ..JudgeConditions(RecDep,2) = "YY" s tempIndic = "0100008^手术费"
 ...s ^TMPDHCBONUS(YM,"TJSS",RecDep,tempIndic) = $G(^TMPDHCBONUS(YM,"TJSS",RecDep,tempIndic))+Price 
 ..;科室直接收入和月度综合目标完成情况类似只是有些费用要乘特定比例
 ..s ^TMPDHCBONUS(YM,"KSZJSR",RecDep,"0200030^月度综合")=$G(^TMPDHCBONUS(YM,"KSZJSR",RecDep,"0200030^月度综合"))+Price
 ..;s ^TMPDHCBONUS(YM,"KSZJSR",RecDep,"0200030^月度综合目标完成情况实际值")=$G(^TMPDHCBONUS(YM,"KSZJSR",RecDep,"0100001^月度综合目标完成情况实际值"))+Price
 ..;门诊收入处理
 ..;i (Eccatdesc["材料")||(Eccatdesc["西药")||(Eccatdesc["成药")||(Eccatdesc["血费") d

 ..i ((Eccatdesc="机械材料子新")||(Eccatdesc="消化组材料")||(Eccatdesc="医技放射材料")||(Eccatdesc="医技检验材料")||(Eccatdesc="介入类材料")||(Eccatdesc="电生理系统(材料)")||(Eccatdesc="妇产科材料")||(Eccatdesc="冠脉系统(材料)")||(Eccatdesc="介入类公共材料")||(Eccatdesc="口腔类材料")||(Eccatdesc="麻醉类材料")||(Eccatdesc="泌尿类材料")||(Eccatdesc="消化组材料")||(Eccatdesc="脑血管系统(材料)")||(Eccatdesc="普外类材料")||(Eccatdesc="烧伤类材料")||(Eccatdesc="神经外材料")||(Eccatdesc="肾组类材料")||(Eccatdesc="手足外材料")||(Eccatdesc="透析材料")||(Eccatdesc="先心系统(材料)")||(Eccatdesc="消化系统(材料)")||(Eccatdesc="心外科材料")||(Eccatdesc="胸外科材料")||(Eccatdesc="血管外材料")||(Eccatdesc="血管外系统(材料)")||(Eccatdesc="医技病理材料")||(Eccatdesc="医技超声材料")||(Eccatdesc="医疗收入(公用类材料)")||(Eccatdesc="医疗收入(骨伤类材料)")||(Eccatdesc="医疗收入(介入类公共材料)")||(Eccatdesc="医疗收入(脑血管系统)")||(Eccatdesc="医疗收入(眼科类材料)")||(Eccatdesc="中医类材料")||(Eccatdesc="公用类材料")||(Eccatdesc="监护室材料")||(Eccatdesc="眼科类材料")||(Eccatdesc="内分泌类材料")||(Eccatdesc="器械材料")||(Eccatdesc="耳鼻喉科材料")||(Eccatdesc="血费")||(Eccatdesc="中成药费")||(Eccatdesc="西药费")||(Eccatdesc="骨伤类材料"))  d
 ...s Price = Price*0.1 
 ...s ^TMPDHCBONUS(YM,"KSZJSR",RecDep,"0100001^科室直接收入")=$G(^TMPDHCBONUS(YM,"KSZJSR",RecDep,"0100001^科室直接收入"))+Price
 ..i ((Eccatdesc="CT费") || (Eccatdesc="中药费")|| (Eccatdesc="会诊费")||(Eccatdesc="动态心电图费") || (Eccatdesc="化验费") || (Eccatdesc="床位费")|| (Eccatdesc="心电图费")||(Eccatdesc="手术") || (Eccatdesc="高压氧舱治疗")|| (Eccatdesc="煎药费")|| (Eccatdesc="电生理系统")||(Eccatdesc="防疫费") || (Eccatdesc="挂号") || (Eccatdesc="脑电图费")|| (Eccatdesc="取暖")||(Eccatdesc="院内专家挂号费") || (Eccatdesc="院外专家挂号费")|| (Eccatdesc="中草药")|| (Eccatdesc="理疗费")||(Eccatdesc="病理费") || (Eccatdesc="介入手术费") || (Eccatdesc="碎石费")|| (Eccatdesc="空调费")||(Eccatdesc="核磁费")|| (Eccatdesc="检查费")|| (Eccatdesc="治疗费")||(Eccatdesc="手术设备使用费") || (Eccatdesc="肠镜") || (Eccatdesc="胃镜")|| (Eccatdesc="诊疗费")||(Eccatdesc="超声检查费") || (Eccatdesc="透析费")|| (Eccatdesc="接生费")|| (Eccatdesc="放射")) d
 ...s ^TMPDHCBONUS(YM,"KSZJSR",RecDep,"0100001^科室直接收入")=$G(^TMPDHCBONUS(YM,"KSZJSR",RecDep,"0100001^科室直接收入"))+Price
 ..;i (Eccatdesc["材料") w RecDep_"++"_PatLoc,!
 
 ///急诊科和急诊科病区还有一部分直接收入从其他地方来
 s Counts = 0
 ;w SDate,EDate,!
 s Counts = ..DHCWLGetIPFeeNow(SDate,EDate)
 ;w Counts,!
 ;w count,!
 // CT费 
 // 心电图室 14 
   ;w ..JudgeConditions("三维适形放疗费 ",1)
 &sql(delete from dhc_bonus_subs.BonusSubExpendCollect  where BonusYear=:Year and BonusPeriod=:sMonth AND InterLocMethodID=:MethodDr)
 ///插入中西药收入
 s dept = ""
 f  s dept = $O(^TMPDHCBONUS(YM,"ZXYSR",dept)) q:dept=""  d
 .s IndNameCode = ""
 .f  s IndNameCode = $O(^TMPDHCBONUS(YM,"ZXYSR",dept,IndNameCode)) q:IndNameCode=""  d
 ..s IndCode = $p(IndNameCode,"^",1)
 ..s IndName = $p(IndNameCode,"^",2)
 ..s itemValue= $G(^TMPDHCBONUS(YM,"ZXYSR",dept,IndNameCode))
 ..i IndCode = "0100007" s itemValue = itemValue * 0.5
 ..i IndCode = "0100005" s itemValue = itemValue * 0.1
 ..s ResDesc = $P(^CTLOC(dept),"^",1)  
 ..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	values(:IndCode,:IndName,:dept,:ResDesc,:Year, :sMonth,:itemValue,getdate(), 0,0,:MethodDr))
  
 ///插入特检费、手术费	
 s dept = ""
 f  s dept = $O(^TMPDHCBONUS(YM,"TJSS",dept)) q:dept=""  d
 .s IndNameCode = ""
 .f  s IndNameCode = $O(^TMPDHCBONUS(YM,"TJSS",dept,IndNameCode)) q:IndNameCode=""  d
 ..s IndCode = $p(IndNameCode,"^",1)
 ..s IndName = $p(IndNameCode,"^",2)
 ..i IndCode = "0100006" s itemValue = itemValue * 0.3
 ..i IndCode = "0100008" s itemValue = itemValue * 0.5
 ..s itemValue= $G(^TMPDHCBONUS(YM,"TJSS",dept,IndNameCode))
 ..s ResDesc = $P(^CTLOC(dept),"^",1)  
 ..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:IndCode,:IndName,:dept,:ResDesc,:Year, :sMonth,:itemValue,getdate(), 0,0,:MethodDr))
 
 ///插入科室直接收入，月度综合目标完成情况实际值
 s dept = ""
 f  s dept = $O(^TMPDHCBONUS(YM,"KSZJSR",dept)) q:dept=""  d
 .s IndNameCode = ""
 .f  s IndNameCode = $O(^TMPDHCBONUS(YM,"KSZJSR",dept,IndNameCode)) q:IndNameCode=""  d
 ..s IndCode = $p(IndNameCode,"^",1)
 ..s IndName = $p(IndNameCode,"^",2)
 ..s itemValue= $G(^TMPDHCBONUS(YM,"KSZJSR",dept,IndNameCode))
 ..;急诊科，急诊科病区的科室直接收入加上从病人当天费用统计报表中查出来的数据
 ..i (IndCode = "0100001")&((dept=54)||(dept=102)) s itemValue = itemValue+Counts
 ..s ResDesc = $P(^CTLOC(dept),"^",1)  
 ..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:IndCode,:IndName,:dept,:ResDesc,:Year, :sMonth,:itemValue,getdate(), 0,0,:MethodDr))
 
 q 0
}

/// 特检费，手术费的一些额外判断条件
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).JudgeConditions("88",1) 
/// 高压氧 热疗室 放疗室 碎石室 透析室 介入室 手术室  59 188 87 129 93 88 29
/// CT费 病理费 肠镜 超声检查费 动态心电图费  放射 高压氧舱治疗  核磁费 化验费 检查费 介入手术费
/// 普通放疗费  三维适形放疗费  手术 碎石费  透析费  胃镜 心电图费
ClassMethod JudgeConditions(data As %String, type As %String) As %String
{
 n (data,type)
 q:type="" 0
 q:data="" 0
 s str = 0
 i type = 1 d
 .i (data["CT费")||(data["病理费")||(data["肠镜")||(data["超声检查费")||(data["放射")||(data["高压氧舱治疗")||(data["核磁费")||(data["化验费")||(data["检查费")||(data["介入手术费")||(data["普通放疗费")||(data["三维适形放疗费")||(data["手术")||(data["碎石费")||(data["透析费")||(data["胃镜")||(data["心电图费") d
 ..s str = "Y"
 e  d 
 .i (data=59)||(data=188)||(data=87)||(data=129)||(data=93)||(data=88)||(data=29) d
 ..s str = "YY"
 q str
}

//转入转出

ClassMethod InOutDetial(date As %String, type As %String, strvar As %String, YM As %String) As %String
{
 n (date,type,strvar,YM)
 s MRIProwid="" f  s MRIProwid=$o(^MRIPdaily("MRIP_DATE",date,MRIProwid)) q:MRIProwid=""  d
 .s rowid="" f  s rowid=$o(^DHCMRIPDetail(0,"IPType",MRIProwid,strvar,rowid)) q:rowid=""  d
 ..s admid=$p(^DHCMRIPDetail(rowid),"^",1)
 ..s MRIPDayrowid=$p(^DHCMRIPDetail(rowid),"^",3)
 ..i type="BF" d
 ...s locdr=$p(^MRIPdaily(MRIPDayrowid),"^",19)
 ...q:locdr=""
 ..e  d
 ...s locdr=$p(^MRIPdaily(MRIPDayrowid),"^",7)
 ...q:locdr=""
 ..q:$g(locdr)=""
 ..i strvar="ZCKS" d
 ...i '$d(^TMPDHCBONUS(YM,type,"ZCKS",locdr)) d
 ....s ^TMPDHCBONUS(YM,type,"ZCKS",locdr)=1 ;s ^TMPDHCBONUS(YM,type,"ZCKS",locdr,admid)=1  ;转出病房
 ...e  d
 ....s ^TMPDHCBONUS(YM,type,"ZCKS",locdr)=$g(^TMPDHCBONUS(YM,type,"ZCKS",locdr))+1  ;转出病房
 ...s ^TMPDHCBONUS(YM,type,"ZCKS",locdr,admid,"ZRKS")=locdr
 ..i strvar="ZRKS" d
 ...i '$d(^TMPDHCBONUS(YM,type,"ZRKS",locdr)) d
 ....s ^TMPDHCBONUS(YM,type,"ZRKS",locdr)=1  ;转入病房
 ...e  d
 ....s ^TMPDHCBONUS(YM,type,"ZRKS",locdr)=$g(^TMPDHCBONUS(YM,type,"ZRKS",locdr))+1  ;转出病房
 ...s ^TMPDHCBONUS(YM,type,"ZRKS",locdr,admid,"ZCKS")=locdr 
 ..;下面部分暂时没用到
 ..i strvar="KNZC" d
 ...i '$d(^TMPDHCBONUS(YM,type,"KNZC",locdr)) d
 ....s ^TMPDHCBONUS(YM,type,"KNZC",locdr)=1  ;转出病房
 ...e  d
 ....s ^TMPDHCBONUS(YM,type,"KNZC",locdr)=$g(^TMPDHCBONUS(YM,type,"KNZC",locdr))+1  ;转出病房
 ...s ^TMPDHCBONUS(YM,type,"KNZC",locdr,admid,"KNZR")=locdr
 ..i strvar="KNZR" d
 ...i '$d(^TMPDHCBONUS(YM,type,"KNZR",locdr)) d
 ....s ^TMPDHCBONUS(YM,type,"KNZR",locdr)=1  ;转入病房
 ...e  d
 ....s ^TMPDHCBONUS(YM,type,"KNZR",locdr)=$g(^TMPDHCBONUS(YM,type,"KNZR",locdr))+1  ;转出病房
 ...s ^TMPDHCBONUS(YM,type,"KNZR",locdr,admid,"KNZC")=locdr 
 q 0
}

/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).Getsjzycr("2014-07-26","2014-08-25","XYRS",2)
ClassMethod Getsjzycr(datefrom As %String, dateto As %String, canshu1 As %String, canshu2 As %String) As %String
{
 n (datefrom,dateto,canshu1,canshu2)

 s Year=$p(datefrom,"-",1)
 s Month=$p(dateto,"-",2)
 s YM=Year_Month
 s datefrom = $zdh(datefrom,3)
 s dateto   = $zdh(dateto,3)
 q:canshu1="SWRS"
 
 s loc="" F  S loc=$o(^MRIPdaily("MRIPloc",loc)) q:loc=""  d 
 .s rs="0",rstotal="0"
 .f date=datefrom:1:dateto d
 ..s mriprid="" s mriprid=$o(^MRIPdaily("MRIPloc",loc,"MRIPdate",date,mriprid)) q:mriprid=""  d
 ...i canshu1="YYRS" d
 ....s mrid=$o(^MRIPdaily("MRIPloc",loc,"MRIPdate",datefrom,""))
 ....q:mrid=""
 ....;w "sdfgdfgh"_"++",!
 ....i rs="0" s rs=$p(^MRIPdaily(mrid),"^",canshu2)+$g(rs)
 ...i ($g(^DHCWLInitStat("Hospital"))=49)!($g(^DHCWLInitStat("Hospital"))=29)!($g(^DHCWLInitStat("Hospital"))=33)!(($g(^DHCWLInitStat("Hospital"))=23)) d  ;28
 ....i canshu1="SYCS" s rs=$p(..BedNum(date,"Loc",loc),"^",2)+$g(rs)
 ....;i canshu1="GDCS" s rs=$p($$BedNum(date,"Loc",loc),"^",1)+$g(rs)
 ....i canshu1="GDCS" s rs=$p(..BedNum(date,"Loc",loc),"^",1)
 ...e  d 
 ....i canshu1="SYCS" S rs=$p(^MRIPdaily(mriprid),"^",canshu2)+$g(rs)
 ....i canshu1="GDCS" S rs=$p(^MRIPdaily(mriprid),"^",canshu2)+$g(rs)
 ...i canshu1="XYRS" s rs=$p(^MRIPdaily(mriprid),"^",canshu2),rstotal=$p(^MRIPdaily(mriprid),"^",canshu2)+$g(rstotal)
 ...i canshu1="XYRS" w loc_"++"_mriprid_"++"_rs,! ; "sdfgdfgh2123"_"++",!
 ...i (canshu1'="YYRS")&(canshu1'="XYRS")&(canshu1'="SYCS")&(canshu1'="GDCS")&(canshu1'="QNJC")  d
 ....s rs=$p(^MRIPdaily(mriprid),"^",canshu2)+$g(rs) ;人数
 .;q:(depidvar'=0)&('$d(^TEMPDHCWL($j,"GetLoc",loc)))   ;winy20090204
 .;s tLoc=$g(^TEMPDHCWL($j,"GetLoc",loc))  //Get SubGroup Edit by yxs 20090609
 .;q:tLoc=""
 .s ^TEMPDHCWL(YM,"KS",canshu1,loc)=$g(^TEMPDHCWL($j,"KS",canshu1,loc))+$g(rs)
 .i canshu1="XYRS"  d
 ..;w loc_"++"_rstotal,!
 ..s ^TEMPDHCWL(YM,"KS","XYRSTOTAL",loc)=rstotal
 ..s ^TEMPDHCWL(YM,"KS","XYRSTOTAL")=$g(^TEMPDHCWL($j,"KS","XYRSTOTAL"))+rstotal 
 q 0
}

/// 取消毒包和手术包的数量
/// 
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).GetCSSDPackg("2014-01-01","2014-01-31","6")
ClassMethod GetCSSDPackg(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
	n (mSDate,mEDate,MethodDr)
	s Year=$p(mEDate,"-",1)
	s Month=$p(mEDate,"-",2)
	s YearMonth=Year_Month
	s sMonth="M"_ Month
	
	s OrdinaryPackg= 0
	s SurgeryPackg = 0 
    
    &sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode in ( '0600422','0600424') )
    s sqlStr="select d.CSSDYM_YearMonth as YearMonthName,e.CSSDPC_PackClassName,"
            _"sum(b.CSSDPAD_OutQty) as OutQty "
            _"from CSSD_PackageApply a, "
            _"CSSD_PackageApplyDetail b,"
            _"CSSD_Package c,"
            _"CSSD_YearMonth d,"
            _"cssd_packageclass e"
            _" where a.CSSDPA_No=b.CSSDPAD_Parref and c.CSSDP_Rowid=*b.CSSDPAD_PackageDr " 
            _" and d.ID=a.CSSDPA_YearMonth and e.ID=c.CSSDP_PackClassdr and a.CSSDPA_Flag>1 "
            _" and d.CSSDYM_YearMonth='"_YearMonth_"'"
            _" group by e.CSSDPC_PackClassName "
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
    s OutQty = "" 
    s PkName = ""
	While(result.Next())
	{
	   s OutQty = result.Data("OutQty")
	   s PkName = result.Data("CSSDPC_PackClassName")
       ;w PkName_OutQty,!
       ;w "sdfsf",!
       s IndCode = "0600422"
       s IndName = "普通消毒包"
       
       i PkName [ "手术器械包" d 
       .s IndCode = "0600424"
       .s IndName =	"手术消毒包"
       &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:IndCode,:IndName,'58','供应室',:Year, :sMonth,:OutQty,getdate(), 0,0,:MethodDr)
		)
	}
  q SQLCODE
}

/// 跟单据数有关的指标
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).DocumentNumber("2014-08-26","2014-09-25",8)
ClassMethod DocumentNumber(Stdate As %String, EDate As %String, MethodDr As %String) As %String
{
 n (Stdate,EDate,MethodDr)	
 s Year=$p(EDate,"-",1)
 s Month=$p(EDate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 s SDate=$zdh(Stdate,3)
 s EDate=$zdh(EDate,3)
 k ^TMP($j,"dhcpha","GetZYYPFac")
 s facsum=0 ;代煎剂数
 s ws=0     ;统计味数
 s numoutque=0 ;出院带药张数
 s numoutfac=0 ;出院带药剂数
 s num =0
 s num1 = 0
 s num2 = 0
 s cfzs = 0
 s pha = ""
 s PresNumber1 =0  ;住院药房发药数
 s PresNumber2 =0  ;中药房处方数
 
 f  s pha=$o(^DHCPHAC(0,"PHA",pha)) q:pha=""  d
 .f date=SDate:1:EDate d
 ..s phac=""
 ..f  s phac=$o(^DHCPHAC(0,"PHA",pha,"DATE",date,phac)) q:phac=""  d
 ...i pha = 79 s PresNumber1 = PresNumber1 +..SumRegnoFromDispNO(phac)  
 ...i pha = 94 s PresNumber2 = PresNumber2 +..SumRegnoFromDispNO(phac) 
 ...s ch = ""
 ...f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
 ....s prescno=$p(^DHCPHAC(phac,"I",ch),"^",5)  ;处方号
 ....;i pha = 79 s num1=num1+1	//发药品种次(住院药房)
 ....;i pha = 94 s num =num+1    //发药品种次(中药房)
 ....s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))	
 ....q:queid=""   	
 ....q:'$d(^PAQUE1(queid,"DHC")) ;过滤非中草药	
 ....s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)	  
 ....;s num2 = num2 +1 ;w oedis,!
 ....s ws=ws+1
 ....q:$d(^TMP($j,"dhcpha","GetZYYPFac",prescno))
 ....s num1=num1+1
 ....s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
 ....s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
 ....s num2=facotor+num2
 ....s priority=$p(^OECPR($p(^OEORD(+oedis,"I",$p(oedis,"||",2),1),"^",8)),"^",1)
 ....i priority="OUT" d
 .....s numoutfac=numoutfac+facotor
 .....s numoutque=numoutque+1
 .....s qty=$p(^DHCPHAC(phac,"I",ch),"^",6)
 .....s price=$p(^DHCPHAC(phac,"I",ch),"^",9)
 .....s amtout=qty*price
 ....s cookmode=$p(^PAQUE1(queid,"DHC"),"^",15)
 ....i cookmode ["代煎" d
 .....s num=num+1
 .....s facsum=facsum+facotor
 ....s ^TMP($j,"dhcpha","GetZYYPFac",prescno)=""
 .;w facsum_"^"_num_"^"_num1_"^"_num2_"^"_ws_"^"_numoutque_"^"_numoutfac,!
 ;w num_"++"_num1_"++"_num2,!
 ;w PresNumber1_"++"_PresNumber2,!
 
 &sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode in ('0600420','0600410','0600390') )
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600420','住院药房发药数',79,'住院药房',:Year, :sMonth,:PresNumber1,getdate(), 0,0,:MethodDr))
 
 s MZXY = ..QueryGZLNewExecute(80,SDate,EDate,"","")
 s MZCY = ..QueryGZLNewExecute(94,SDate,EDate,"","")
 ;w MZ_"++"_MZCY,!
 s ZYCFS = 0
 s ZYCFS = MZCY+PresNumber2
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600410','中药处方数',94,'中药房',:Year, :sMonth,:ZYCFS,getdate(), 0,0,:MethodDr))
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600390','西药房处方数',80,'门诊药房',:Year, :sMonth,:MZXY,getdate(), 0,0,:MethodDr))
 q 0
}

ClassMethod SumRegnoFromDispNO(phac)
{
 ;获取某张发药单上不同登记号数
 n (phac)
 q:phac="" ""
 s num=0
 s tmpadm=""
 s ch=""
 f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
 .s adm=$p(^DHCPHAC(phac,"I",ch),"^",3)
 .i tmpadm'=adm d
 ..s num=num+1
 .s tmpadm=adm
 q num
}

/// 
/// 收款处相关指标 收款处预交金月收支余额  收款处(收费单据数)
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).CollectIndic("2014-08-26","2014-09-25",8)
ClassMethod CollectIndic(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
	
 n (mSDate,mEDate,MethodDr)
 
 s Year=$p(mEDate,"-",1)
 s Month=$p(mEDate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 s mSDate=$zdh(mSDate,3)
 s mEDate=$zdh(mEDate,3)
 s hospDr = ""
 s guserDr = ""
 ;w mSDate_"++"_mEDate,!
 s (accAllNumTotal,accAllSumTotal,accSFNumTotal,accSFSumTotal,accTFNumTotal,accTFSumTotal,prtAllNumTotal,prtAllSumTotal,prtZFNumTotal,prtZFSumTotal,prtHCNumTotal,prtHCSumTotal,ybSumTotal,ybZFSumTotal,ybHCSumTotal,ybPayAmtTotal,ybShareAmtTotal,ybNumTotal)=0
 f pdate=mSDate:1:mEDate d
 .s hisDr=""
 .f  s hisDr=$o(^DHCOPInsFootI(0,"Date",pdate,hisDr)) q:hisDr=""  d //结算表
 ..q:'$d(^DHCOPInsFoot(hisDr))
 ..s footInfo=$g(^DHCOPInsFoot(hisDr))
 ..s footUser=$p(footInfo,"^",8) ;HIS_User 结算人
 ..s footDate=$p(footInfo,"^",2) ;HIS_Date 结算日期
 ..s footTime=$p(footInfo,"^",7) ;HIS_Time 结算时间
 ..s footStDate=$p(footInfo,"^",5) ;HIS_StartDate 结算开始日期
 ..s footStTime=$p(footInfo,"^",6) ;HIS_StartTime 结算开始时间
 ..s footEndDate=$p(footInfo,"^",3) ;HIS_EndDate 结算结束日期
 ..s footEndTime=$p(footInfo,"^",4) ;HIS_EndTime 结算结束时间
 ..s footHospDr=$p(footInfo,"^",66) ;HIS_HospitalDR 医院Dr
 ..q:((hospDr'="")&(hospDr'=footHospDr)) ;按医院过滤 
 ..q:((guserDr'="")&(guserDr'=footUser))     ;按收费员过滤
 ..;取预交金信息
 ..;d ..ClearTMP1(footUser,job) //清除臨時
 ..s (accAllNum,accAllSum,accSFNum,accSFSum,accTFNum,accTFSum)=0
 ..s accid=""
 ..f  s accid=$o(^DHCACDi("AccM",0,"PDFootDR",hisDr,accid)) q:accid=""  d
 ...s preSub=""
 ...f  s preSub=$o(^DHCACDi("AccM",0,"PDFootDR",hisDr,accid,"AccPD",preSub)) q:preSub=""  d
 ....s preStr=$g(^DHCACD("AccM",accid,"AccPD",preSub))
 ....s preType=$p(preStr,"^",1) ;AccPD_Type(Pay||P缴款 Refund||R退费 Trans||T转帐 Foot||F结算帐户的缴退款)
 ....s preSum=$p(preStr,"^",2)  ;AccPD_PreSum 缴款额度
 ....s accNO=$p(preStr,"^",6) ;AccPD_BillNum 票据号
 ....i preType["P" d       
 .....s accAllNum=accAllNum+1
 .....s accAllSum=accAllSum+(+preSum)
 .....s accSFNum=accSFNum+1
 .....s accSFSum=accSFSum+(+preSum)
 .....s accAllNumTotal=accAllNumTotal+1
 .....s accAllSumTotal=accAllSumTotal+(+preSum)
 .....;s ^hahah =accAllNumTotal_"++"_accAllSumTotal
 .....s accSFNumTotal=accSFNumTotal+1
 .....s accSFSumTotal=accSFSumTotal+(+preSum)
 .....;s ^TMP("MZJF","YJHZA",footUser,job,accNO)=accNO ;保存收据号,用于后边的统计
 .....;s ^TMP("MZJF","YJHZS",footUser,job,accNO)=accNO
 ....i ((preType["R")!(preType["F"))  d
 .....;s ^TMP("MZJF","YJHZA",footUser,job,accNO)=accNO
 .....;s ^TMP("MZJF","YJHZT",footUser,job,accNO)=accNO
 .....s accAllNum=accAllNum+1
 .....s accAllSum=accAllSum+(+preSum)
 .....s accTFNum=accTFNum+1
 .....s accTFSum=accTFSum+(+preSum)
 .....s accAllNumTotal=accAllNumTotal+1
 .....s accAllSumTotal=accAllSumTotal+(+preSum)
 .....s accTFNumTotal=accTFNumTotal+1
 .....s accTFSumTotal=accTFSumTotal+(+preSum)
 ;w accAllNumTotal_"++"_accAllSumTotal,!
 
 &sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode in ('0600360','0600340'))
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600360','收款处预交金月收支余额',30,'收款处',:Year, :sMonth,:accAllSumTotal,getdate(), 0,0,:MethodDr))
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600340','收款处(收费单据数)',30,'收款处',:Year, :sMonth,:accAllNumTotal,getdate(), 0,0,:MethodDr))
 q 0
}

/// 
/// 住院处(结算单据数) 别的组的代码
/// 这个值是记录别的组查的数据条数，所以直接用别人已写好的代码
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).Inhospital("2014-08-26","2014-08-31",8)
ClassMethod Inhospital(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
	
 n (mSDate,mEDate,MethodDr)
	
 s Year=$p(mEDate,"-",1)
 s Month=$p(mEDate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 s mSDate=$zdh(mSDate,3)
 s mEDate=$zdh(mEDate,3)
 s (admqkid,PatDisDiagID,wdr,locid,wardid,Adres,deposit) = ""

 s PatFeeAll = 0
 s PatDepositAll = 0
 s PatRemainAll = 0
 s num = 0
 s ind=1
 f disdate=mSDate:1:mEDate  d
 .s prtrowid="" f  s prtrowid=$o(^DHCINVPRTZY(0,"DATE",disdate,prtrowid))  q:prtrowid=""  d
 ..s adm=$p(^DHCINVPRTZY(prtrowid),"^",4)
 ..s ADMNO=$P(^PAADM(adm),"^",81)
 ..s PaitentID=$p(^PAADM(adm),"^",1)
 ..s CategoryID=$p(^PAADM(adm),"^",5) //add by ywb 2012-12-25 入院情况7
 ..q:(admqkid'=CategoryID)&(admqkid'="")
 ..i CategoryID'="" s Category=$p(^PAC("ADMCAT",CategoryID),"^",2)
 ..s admDocDr=$p(^PAADM(adm),"^",9)
 ..i admDocDr'="" s admDoc=$p(^CTPCP(admDocDr,1),"^",2) //主管医生
 ..s MRAdm=$p(^PAADM(adm),"^",61)
 ..s papmidr=$P(^PAADM(adm),"^",1)
 ..s PAID=$P($g(^PAPER(papmidr,"ALL")),"^",9)           //身份证号
 ..s patDisDiag=##class(web.UDHCJFBaseCommon).GetPatDiagnos(MRAdm,"DIS") //出院诊断
 ..s patDisDiagCode=$p(patDisDiag,"^",2)
 ..s patDisDiag=$p(patDisDiag,"^",3)    
 ..q:(PatDisDiagID'=patDisDiag)&&(PatDisDiagID'="")    // add by yjz 2014-03-27
 ..s patPreDiag=##class(web.UDHCJFBaseCommon).GetPatDiagnos(MRAdm,"PRE") //入院诊断
 ..s patPreDiag=$p(patPreDiag,"^",3)
 ..s wrrantname=""
 ..f  s wdr=$o(^DHCWARRANT(0,"ADM",adm,wdr)) q:wdr=""  d
 ...s ss=^DHCWARRANT(wdr)
 ...s wrrantname=$p(ss,"^",9)   
    
 ..// add by wl
 ..s decease=$p(^PAPER(PaitentID,"ALL"),"^",12)  ;死亡状态
 ..i decease="Y" s decease="死亡"
 ..e  s decease="正常" 
 ..s Paplinkphone=$P($G(^PAPER(PaitentID,"PER",1)),"^",11) 
 ..s invflag=$p(^DHCINVPRTZY(prtrowid),"^",8)
 ..q:invflag="A"
 ..;s patdiag=..getpatdiag(adm,grp)         ;add 2008-02-14  病人诊断
 ..s dep=$p(^PAADM(adm),"^",4),currward=$p(^PAADM(adm),"^",70)
 ..s admtype=$p(^PAADM(adm),"^",2)
 ..s visitstatus=$p(^PAADM(adm),"^",20)
 ..q:visitstatus="C"
 ..q:(locid'="")&(locid'=dep)
 ..q:(wardid'="")&(wardid'=currward)
 ..s CodingUpdateUser=$p(^PAADM(adm,2),"^",92)
 ..i $g(CodingUpdateUser)="" s ConfirmFlag="N"
 ..e  s ConfirmFlag="Y" 
 ..i ConfirmFlag="Y"  s Tconfirmflag="已审核"
 ..i ConfirmFlag="N"  s Tconfirmflag="未审核"
 ..i currward'=""  d
 ...s patward=$p(^PAWARD(currward),"^",2)
 ..e  d
 ...s patward=""
 ..s papmi=$p(^PAADM(adm),"^",1),patname=$p(^PAPER(papmi,"ALL"),"^",1),patregno=$p(^PAPER(papmi,"PAT",1),"^",1)
 ..s sexid=$p(^PAPER(papmi,"ALL"),"^",7),sex=$p(^CT("SEX",sexid),"^",2)
 ..s zyno=$p(^PAPER(papmi,"PAT",1),"^",22)
 ..i $d(^PAPER(papmi,"PER","ADD",1))  d
 ...s Address=^PAPER(papmi,"PER","ADD",1)  ;地址   add 2008-02-15  by lc
 ..q:(Address'[Adres)                     ;add 2014-7-21 by yangjianzhi
 ..s admdate=$zd($p(^PAADM(adm),"^",6),3),dischdate=$zd($p(^PAADM(adm),"^",17),3),disc="Yes"
 ..i (dischdate'="") s Indays=$zdh(dischdate,3)-$zdh(admdate,3)   //住院天数
 ..s dischtime=$zt($p(^PAADM(adm),"^",18)),meddisc=$p(^PAADM(adm),"^",63)
 ..i meddisc="Y"  s meddisc="Yes"
 ..s meddiscdate=$p(^PAADM(adm),"^",59),meddisctime=$p(^PAADM(adm),"^",60)
 ..i meddiscdate'=""  s meddiscdate=$zd(meddiscdate,3)
 ..i meddisctime'=""  s meddisctime=$zt(meddisctime)
    
 ..s recnum=""
 ..s JieSuanDate=""
 ..s JieSuanTime=""
 ..i $g(prtrowid)'="" s recnum=$p(^DHCINVPRTZY(prtrowid),"^",1) 
 ..i recnum'="" d
 ...i $d(^DHCINVPRTZY(0,"INV",recnum)) d
 ....s prt=$o(^DHCINVPRTZY(0,"INV",recnum,""))
 ....q:'$d(^DHCINVPRTZY(prt))
 ....s st=$p(^DHCINVPRTZY(prt),"^",8)
 ....s JieSuanDate=$zd($p(^DHCINVPRTZY(prt),"^",2),3)
 ....s JieSuanTime=$zt($p(^DHCINVPRTZY(prt),"^",3),1)
    
 ..s patloc=$p(^CTLOC(dep),"^",2),bedid=$p(^PAADM(adm),"^",73)
 ..i bedid'=""  d  s patbed=$p(^PAWARD(+bedid,"BED",$p(bedid,"||",2)),"^",1)
 ..e  d  s patbed=""
 ..s patfee=$p(^DHCINVPRTZY(prtrowid),"^",6)
 ..s arpbl=$p(^DHCINVPRTZY(prtrowid),"^",5)
 ..s rcptno=$p(^DHCINVPRTZY(prtrowid),"^",1)
 ..s deposit=##class(web.UDHCJFBaseCommon).arpbldeposit(arpbl) 
 ..s remain=deposit-patfee ;ywb 2012
 ..s PatFeeAll=PatFeeAll+patfee
 ..s PatDepositAll=PatDepositAll+deposit
 ..s PatRemainAll=PatRemainAll+remain
 ..s inv=$o(^DHCINVPRTZY(0,"AR",arpbl,""),-1)
 ..i (inv'="")&&($d(^DHCINVPRTZY(inv)))  d
 ...s prtdate=$p($g(^DHCINVPRTZY(inv)),"^",2)
 ...s:prtdate'="" prtdate=$zd(prtdate,3) 
 ...s prttime=$p($g(^DHCINVPRTZY(inv)),"^",3)
 ...s:prttime'="" prttime=$zt(prttime) 
 ..s admreas=$p(^PAADM(adm,1),"^",7)
 ..s num=num+1
 ;w num,!


 &sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode in ('0600330'))
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600330','住院处(结算单据数)',4,'住院处',:Year, :sMonth,:num,getdate(), 0,0,:MethodDr))
 
 q 0
}

/// 获取检验相关指标
/// 取数代码取自 TestCodeStat^DHCLtkStatistic LABSRC命名空间下
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).inspection("2014-07-26","2014-08-25",3)
ClassMethod inspection(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
 n (mSDate,mEDate,MethodDr)
 
 s HospitalCode = "东营二院"
 s MachineCode =""
 s MachineGPCode = ""
 s Year=$p(mEDate,"-",1)
 s Month=$p(mEDate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 s mSDate=$zdh(mSDate,3)
 s mEDate=$zdh(mEDate,3)
  s ^hahah =0
  s MachineCode = "LXT180"
  s DateType =1
  k ^TMPDHCBONUS("JYDC") 
  f date=mSDate:1:mEDate d
  .f tim="" f  s tim=$o(^TDAY(10,date,tim)) q:tim=""  d
  ..s ptype="" f  s ptype=$o(^TDAY(10,date,tim,ptype)) q:ptype=""  d
  ...s VisitNumber="" f  s VisitNumber=$o(^TDAY(10,date,tim,ptype,"N",VisitNumber)) q:VisitNumber=""  d
  ....Set CurHospitalCode=$Piece(^TEPI(VisitNumber),"\",26)
  ....If $Length(HospitalCode),$l(CurHospitalCode),CurHospitalCode'=HospitalCode Quit
  ....i $l(HospitalCode),'$l(CurHospitalCode),'$d(^TTABi("CC",1,HospitalCode)) Quit
  ....s TestsetDr="" f  s TestsetDr=$o(^TDAY(10,date,tim,ptype,"N",VisitNumber,TestsetDr)) q:TestsetDr=""  d
  .....s TestSetCounter="" f  s TestSetCounter=$o(^TDAY(10,date,tim,ptype,"N",VisitNumber,TestsetDr,TestSetCounter))  q:TestSetCounter=""  d
  ......s AuthosizeTime=$p(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",5) * 60
  ......;w TestsetDr_"++"_TestSetCounter,!
  ......;s ^hahah = ^hahah+1
  ......;i TestsetDr ="F0011" w TestsetDr_"++"_TestSetCounter,!
  ......s ii="" f  s ii=$o(^TTAB("TS",TestsetDr,0,ii))  q:ii=""  d 
  .......s TestCode=$p(^TTAB("TS",TestsetDr,0,ii),"\",8)
  .......i '$l(TestCode) q 
  .......i $e(TestCode,2,5)="9999" q  ;去掉备注
  .......s TestName=$p(^TTAB("TC",TestCode),"\",1)
  .......s type=$p(^TTAB("TC",TestCode),"\",3)
  .......;i TestCode = "L0200"  s ^hahah = ^hahah+1 ;w AuthosizeTime_"++",! ;s ^hahah = ^hahah+1
  .......;w VisitNumber_"++"_TestsetDr_"++"_TestSetCounter,!
  .......s MachineC=$p(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  .......;w MachineC,!
  .......;i $l(MachineCode),MachineCode'=MachineC q
  .......;i $l(MachineGPCode),$l(MachineCode),'$d(^TMIF(MachineCode,"TG",MachineGPCode,"TS",TestsetDr)) q
  .......s Result=$p($g(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter,"DATA",TestCode)),"\",1)
  .......i Result="" q  ;结果为空时不统计
  .......;i TestCode ="F0040" w MachineC_"++"_TestSetCounter,!
  .......s ^hahah = ^hahah+1 ;i TestCode ="F0040" s ^hahah = ^hahah+1
  .......;根据检查项代码获取指标,这部分比较费时间，把方法GetIndicatCode()写入同一个类，下面for循环去掉可能会好点。但又必须舍去其他方面性能，跟据具体情况适当选择吧。
  .......;s Indicatorstr = ##Class(dhc.bonus.uinter.uGetYWSRData).GetIndicatCode(TestCode)
  .......s Indicatorstr =..GetIndicatCode(TestCode)
  .......s n = $p(Indicatorstr,"||",1)
  .......;i n >1 w Indicatorstr,!
  .......i n > 0 d
  ........f i=2:1:n+1 d
  .........s Indicators = $p(Indicatorstr,"||",i)
  .........;w Indicators,! ;i TestCode ="L0201" w Indicators,!
  .........s ^TMPDHCBONUS("JYDC",Indicators)=$G(^TMPDHCBONUS("JYDC",Indicators))+1

  
 &sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode in ('0600060','0600070','0600080'))
 s jy1 = $G(^TMPDHCBONUS("JYDC","0600060^检验1档"))  
 s jy2 = $G(^TMPDHCBONUS("JYDC","0600070^检验2档"))  
 s jy3 = $G(^TMPDHCBONUS("JYDC","0600080^检验3档")) 

 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600060','检验1档',158,'检验科',:Year, :sMonth,:jy1,getdate(), 0,0,:MethodDr))
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600070','检验2档',158,'检验科',:Year, :sMonth,:jy2,getdate(), 0,0,:MethodDr))
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600080','检验3档',158,'检验科',:Year, :sMonth,:jy3,getdate(), 0,0,:MethodDr))
	
 q 0
}

/// 根据医嘱项获取指标
/// 返回值：指标代码^指标名称
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).GetIndicatCode("A06158")  A121120WFY177
ClassMethod GetIndicatCode(ItemCode) As %String
{
 n (ItemCode)
   s n = 0
   s str = ""
   s rowid = "" 
   f  s rowid = $O(^dhcbsSubItemI("SubsIsVaItemCode",1,ItemCode,rowid)) q:rowid=""  d
   .s SuperiorItemID = $List(^dhcbsSubItemD(rowid),5)
   .s code = $List(^dhcbsSubItemD(SuperiorItemID),2)
   .s name = $List(^dhcbsSubItemD(SuperiorItemID),3)
   .s str = str_"||"_code_"^"_name
   .s n = n+1
   s str = n_str
   /*
   ;因下面这段代码速度慢，故重新建索引“SubsIsVaItemCode”，改用上面代码
   s sqlStr="SELECT SuperiorItemID->SubItemCode code ,SuperiorItemID->SubItemName name "
           _" FROM dhc_bonus_subs.BonusSubItem WHERE IsValid= 1 and SubItemCode = '"_ItemCode_"'"
          
    s n = 0
    s str = ""
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
    ;s OutQty = "" 
    ;s PkName = ""
	While(result.Next())
	{
	  s code = result.Data("code")
	  s name = result.Data("name")
	  s str = str_"||"_code_"^"_name
	  s n = n+1
	}
	s str = n_str
	*/
 q str
}

/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).test("63425","63433","6")2014-08-26 2014-09-03
ClassMethod test(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
	n (mSDate,mEDate,MethodDr)
  ;s ^hahah = 0
  s MachineCode = "LXT180"
  s DateType =1
  k ^TMPDHCBONUS("JYDC") 
  f date=mSDate:1:mEDate d
  .f tim="" f  s tim=$o(^TDAY(10,date,tim)) q:tim=""  d
  ..s ptype="" f  s ptype=$o(^TDAY(10,date,tim,ptype)) q:ptype=""  d
  ...s VisitNumber="" f  s VisitNumber=$o(^TDAY(10,date,tim,ptype,"N",VisitNumber)) q:VisitNumber=""  d
  ....s TestsetDr="" f  s TestsetDr=$o(^TDAY(10,date,tim,ptype,"N",VisitNumber,TestsetDr)) q:TestsetDr=""  d
  .....s TestSetCounter="" f  s TestSetCounter=$o(^TDAY(10,date,tim,ptype,"N",VisitNumber,TestsetDr,TestSetCounter))  q:TestSetCounter=""  d
  ......;w TestsetDr_"++"_TestSetCounter,!
  ......;s ^hahah = ^hahah+1
  ......;i TestsetDr ="F0011" w TestsetDr_"++"_TestSetCounter,!
  ......s ii="" f  s ii=$o(^TTAB("TS",TestsetDr,0,ii))  q:ii=""  d 
  .......s TestCode=$p(^TTAB("TS",TestsetDr,0,ii),"\",8)
  .......i '$l(TestCode) q 
  .......i $e(TestCode,2,5)="9999" q  ;去掉备注
  .......s TestName=$p(^TTAB("TC",TestCode),"\",1)
  .......s type=$p(^TTAB("TC",TestCode),"\",3)
  .......;w VisitNumber_"++"_TestsetDr_"++"_TestSetCounter,!
  .......s MachineC=$p(^TEPI(VisitNumber,1,TestsetDr,TestSetCounter),"\",27)
  .......;w MachineC,!
  .......;i $l(MachineCode),MachineCode'=MachineC q
  .......;i TestCode ="F0040" w MachineC_"++"_TestSetCounter,!
  .......;i TestCode ="F0040" s ^hahah = ^hahah+1
  .......;根据检查项代码获取指标
  .......s Indicatorstr = ##Class(dhc.bonus.uinter.uGetYWSRData).GetIndicatCode(TestCode)
  .......s n = $p(Indicatorstr,"||",1)
  .......i n > 0 d
  ........f i=2:1:n+1 d
  .........s Indicators = $p(Indicatorstr,"||",i)
  .........;i TestCode ="L0201" w Indicators,!
  .........s ^TMPDHCBONUS("JYDC",Indicators)=$G(^TMPDHCBONUS("JYDC",Indicators))+1

  
 &sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode in ('0600060','0600070','0600080'))
 s jy1 = $G(^TMPDHCBONUS("JYDC","0600060^检验1档"))  
 s jy2 = $G(^TMPDHCBONUS("JYDC","0600070^检验2档"))  
 s jy3 = $G(^TMPDHCBONUS("JYDC","0600080^检验3档")) 

 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600060','检验1档',158,'检验科',:Year, :sMonth,:jy1,getdate(), 0,0,:MethodDr))
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600070','检验2档',158,'检验科',:Year, :sMonth,:jy2,getdate(), 0,0,:MethodDr))
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600080','检验3档',158,'检验科',:Year, :sMonth,:jy3,getdate(), 0,0,:MethodDr))
 
 
  ;.i DateType="1" d ..ByRecDate(date,"TC")
  /*
  .e  d ByAuthDate(date,"TC")
  s P0=0,num=0,P1=0
  s tc="" f  s tc=$o(^TMP($zn,$j,"TCList",tc))  q:tc=""  d
  .s num=num+1
  .s TestName=$p(^TTAB("TC",tc),"\",1)
  .s type=$p(^TTAB("TC",tc),"\",3)
  .;s PLIST(num)=$c(9)_num_$c(9)_tc_$c(9)_TestName_$c(9)_type_$c(9)_$g(^TMP($zn,$j,"TCList",tc))
	
	
	s admqkid = ""
	s PatDisDiagID = ""
	s wdr=""
	s locid = ""
	s wardid= ""
	s Adres = ""
	s PatFeeAll = 0
	s deposit = ""
	s PatDepositAll = 0
	s PatRemainAll = 0
	s ^hahah = 0
	 i (1=1) d
    .;s ^hahah = 888
    .s ind=1
    .f disdate=mSDate:1:mEDate  d
    ..s prtrowid="" f  s prtrowid=$o(^DHCINVPRTZY(0,"DATE",disdate,prtrowid))  q:prtrowid=""  d
    ...s adm=$p(^DHCINVPRTZY(prtrowid),"^",4)
    ...;s kjywflag=..GetKJYWFlag(adm)              //-------------------------7
    ...;i kjywflag=1 s kjywflagdesc="是" 
    ...;e  s kjywflagdesc="否"
    ...s ADMNO=$P(^PAADM(adm),"^",81)
    ...;s MRDiagnos=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(adm,"/")
    ...s PaitentID=$p(^PAADM(adm),"^",1)
    ...s CategoryID=$p(^PAADM(adm),"^",5) //add by ywb 2012-12-25 入院情况7
    ...q:(admqkid'=CategoryID)&(admqkid'="")
    ...i CategoryID'="" s Category=$p(^PAC("ADMCAT",CategoryID),"^",2)
    ...s admDocDr=$p(^PAADM(adm),"^",9)
    ...i admDocDr'="" s admDoc=$p(^CTPCP(admDocDr,1),"^",2) //主管医生
    ...s MRAdm=$p(^PAADM(adm),"^",61)
    ...s papmidr=$P(^PAADM(adm),"^",1)
    ...s PAID=$P($g(^PAPER(papmidr,"ALL")),"^",9)           //身份证号
    ...s patDisDiag=##class(web.UDHCJFBaseCommon).GetPatDiagnos(MRAdm,"DIS") //出院诊断
    ...s patDisDiagCode=$p(patDisDiag,"^",2)
    ...s patDisDiag=$p(patDisDiag,"^",3)    
    ...q:(PatDisDiagID'=patDisDiag)&&(PatDisDiagID'="")    // add by yjz 2014-03-27
    ...s patPreDiag=##class(web.UDHCJFBaseCommon).GetPatDiagnos(MRAdm,"PRE") //入院诊断
    ...s patPreDiag=$p(patPreDiag,"^",3)
    ...s wrrantname=""
    ...f  s wdr=$o(^DHCWARRANT(0,"ADM",adm,wdr)) q:wdr=""  d
    ....s ss=^DHCWARRANT(wdr)
    ....s wrrantname=$p(ss,"^",9)   
    
    ...// add by wl
    ...s decease=$p(^PAPER(PaitentID,"ALL"),"^",12)  ;死亡状态
    ...i decease="Y" s decease="死亡"
    ...e  s decease="正常" 
    ...s Paplinkphone=$P($G(^PAPER(PaitentID,"PER",1)),"^",11) 
    ...s invflag=$p(^DHCINVPRTZY(prtrowid),"^",8)
    ...q:invflag="A"
    ...;s patdiag=..getpatdiag(adm,grp)         ;add 2008-02-14  病人诊断
    ...s dep=$p(^PAADM(adm),"^",4),currward=$p(^PAADM(adm),"^",70)
    ...s admtype=$p(^PAADM(adm),"^",2)
    ...s visitstatus=$p(^PAADM(adm),"^",20)
    ...q:visitstatus="C"
    ...q:(locid'="")&(locid'=dep)
    ...q:(wardid'="")&(wardid'=currward)
    ...s CodingUpdateUser=$p(^PAADM(adm,2),"^",92)
    ...i $g(CodingUpdateUser)="" s ConfirmFlag="N"
    ...e  s ConfirmFlag="Y" 
    ...i ConfirmFlag="Y"  s Tconfirmflag="已审核"
    ...i ConfirmFlag="N"  s Tconfirmflag="未审核"
    ...i currward'=""  d
    ....s patward=$p(^PAWARD(currward),"^",2)
    ...e  d
    ....s patward=""
    ...s papmi=$p(^PAADM(adm),"^",1),patname=$p(^PAPER(papmi,"ALL"),"^",1),patregno=$p(^PAPER(papmi,"PAT",1),"^",1)
    ...b:(patname="李开明") ;1
    ...s sexid=$p(^PAPER(papmi,"ALL"),"^",7),sex=$p(^CT("SEX",sexid),"^",2)
    ...s zyno=$p(^PAPER(papmi,"PAT",1),"^",22)
    ...i $d(^PAPER(papmi,"PER","ADD",1))  d
    ....s Address=^PAPER(papmi,"PER","ADD",1)  ;地址   add 2008-02-15  by lc
    ...q:(Address'[Adres)                     ;add 2014-7-21 by yangjianzhi
    ...s admdate=$zd($p(^PAADM(adm),"^",6),3),dischdate=$zd($p(^PAADM(adm),"^",17),3),disc="Yes"
    ...i (dischdate'="") s Indays=$zdh(dischdate,3)-$zdh(admdate,3)   //住院天数
    ...s dischtime=$zt($p(^PAADM(adm),"^",18)),meddisc=$p(^PAADM(adm),"^",63)
    ...i meddisc="Y"  s meddisc="Yes"
    ...s meddiscdate=$p(^PAADM(adm),"^",59),meddisctime=$p(^PAADM(adm),"^",60)
    ...i meddiscdate'=""  s meddiscdate=$zd(meddiscdate,3)
    ...i meddisctime'=""  s meddisctime=$zt(meddisctime)
    
    ...s recnum=""
    ...s JieSuanDate=""
    ...s JieSuanTime=""
    ...i $g(prtrowid)'="" s recnum=$p(^DHCINVPRTZY(prtrowid),"^",1) 
    ...i recnum'="" d
    ....i $d(^DHCINVPRTZY(0,"INV",recnum)) d
    .....s prt=$o(^DHCINVPRTZY(0,"INV",recnum,""))
    .....q:'$d(^DHCINVPRTZY(prt))
    .....s st=$p(^DHCINVPRTZY(prt),"^",8)
    .....s JieSuanDate=$zd($p(^DHCINVPRTZY(prt),"^",2),3)
    .....s JieSuanTime=$zt($p(^DHCINVPRTZY(prt),"^",3),1)
    
    ...s patloc=$p(^CTLOC(dep),"^",2),bedid=$p(^PAADM(adm),"^",73)
    ...i bedid'=""  d  s patbed=$p(^PAWARD(+bedid,"BED",$p(bedid,"||",2)),"^",1)
    ...e  d  s patbed=""
    ...s patfee=$p(^DHCINVPRTZY(prtrowid),"^",6)
    ...s arpbl=$p(^DHCINVPRTZY(prtrowid),"^",5)
    ...s rcptno=$p(^DHCINVPRTZY(prtrowid),"^",1)
    ...s deposit=##class(web.UDHCJFBaseCommon).arpbldeposit(arpbl) 
    ...s remain=deposit-patfee ;ywb 2012
    ...s PatFeeAll=PatFeeAll+patfee
    ...s PatDepositAll=PatDepositAll+deposit
    ...s PatRemainAll=PatRemainAll+remain
    ...s inv=$o(^DHCINVPRTZY(0,"AR",arpbl,""),-1)
    ...i (inv'="")&&($d(^DHCINVPRTZY(inv)))  d
    ....s prtdate=$p($g(^DHCINVPRTZY(inv)),"^",2)
    ....s:prtdate'="" prtdate=$zd(prtdate,3) 
    ....s prttime=$p($g(^DHCINVPRTZY(inv)),"^",3)
    ....s:prttime'="" prttime=$zt(prttime) 
    ...s admreas=$p(^PAADM(adm,1),"^",7)
    ...s:(admreas'="")&&($d(^PAC("ADMREA",admreas))) admreas=$p($g(^PAC("ADMREA",admreas)),"^",2)
    ...w patname,! ;新增
    ...s ^hahah=^hahah+1
   */ /*
    ...s curDate=$zd($h,3)
    ...s dobDate=$zd($p($g(^PAPER(papmi,"ALL")),"^",6),3)
    ...s patAge=##class(web.DHCDTHealthCommon).GetAgeDesc(dobDate,curDate)
    ...s patNum=$p($g(^PAPER(papmi,"PER",4)),"^",8)
    ...d GetRecordComment(adm)
    ...i invflag="N" s num=num+1
	*/
	/*
	s hospDr = ""
	s guserDr = ""
	s job=$j
 s (accAllNumTotal,accAllSumTotal,accSFNumTotal,accSFSumTotal,accTFNumTotal,accTFSumTotal,prtAllNumTotal,prtAllSumTotal,prtZFNumTotal,prtZFSumTotal,prtHCNumTotal,prtHCSumTotal,ybSumTotal,ybZFSumTotal,ybHCSumTotal,ybPayAmtTotal,ybShareAmtTotal,ybNumTotal)=0
 f pdate=mSDate:1:mEDate d
 .s hisDr=""
 .f  s hisDr=$o(^DHCOPInsFootI(0,"Date",pdate,hisDr)) q:hisDr=""  d //结算表
 ..q:'$d(^DHCOPInsFoot(hisDr))
 ..s footInfo=$g(^DHCOPInsFoot(hisDr))
 ..s footUser=$p(footInfo,"^",8) ;HIS_User 结算人
 ..s footDate=$p(footInfo,"^",2) ;HIS_Date 结算日期
 ..s footTime=$p(footInfo,"^",7) ;HIS_Time 结算时间
 ..s footStDate=$p(footInfo,"^",5) ;HIS_StartDate 结算开始日期
 ..s footStTime=$p(footInfo,"^",6) ;HIS_StartTime 结算开始时间
 ..s footEndDate=$p(footInfo,"^",3) ;HIS_EndDate 结算结束日期
 ..s footEndTime=$p(footInfo,"^",4) ;HIS_EndTime 结算结束时间
 ..s footHospDr=$p(footInfo,"^",66) ;HIS_HospitalDR 医院Dr
 ..q:((hospDr'="")&(hospDr'=footHospDr)) ;按医院过滤 
 ..q:((guserDr'="")&(guserDr'=footUser))     ;按收费员过滤
 ..;取预交金信息
 ..;d ..ClearTMP1(footUser,job) //清除臨時
 ..s (accAllNum,accAllSum,accSFNum,accSFSum,accTFNum,accTFSum)=0
 ..s accid=""
 ..f  s accid=$o(^DHCACDi("AccM",0,"PDFootDR",hisDr,accid)) q:accid=""  d
 ...s preSub=""
 ...f  s preSub=$o(^DHCACDi("AccM",0,"PDFootDR",hisDr,accid,"AccPD",preSub)) q:preSub=""  d
 ....s preStr=$g(^DHCACD("AccM",accid,"AccPD",preSub))
 ....s preType=$p(preStr,"^",1) ;AccPD_Type(Pay||P缴款 Refund||R退费 Trans||T转帐 Foot||F结算帐户的缴退款)
 ....s preSum=$p(preStr,"^",2)  ;AccPD_PreSum 缴款额度
 ....s accNO=$p(preStr,"^",6) ;AccPD_BillNum 票据号
 ....i preType["P" d       
 .....s accAllNum=accAllNum+1
 .....s accAllSum=accAllSum+(+preSum)
 .....s accSFNum=accSFNum+1
 .....s accSFSum=accSFSum+(+preSum)
 .....s accAllNumTotal=accAllNumTotal+1
 .....s accAllSumTotal=accAllSumTotal+(+preSum)
 .....;s ^hahah =accAllNumTotal_"++"_accAllSumTotal
 .....s accSFNumTotal=accSFNumTotal+1
 .....s accSFSumTotal=accSFSumTotal+(+preSum)
 .....s ^TMP("MZJF","YJHZA",footUser,job,accNO)=accNO ;保存收据号,用于后边的统计
 .....s ^TMP("MZJF","YJHZS",footUser,job,accNO)=accNO
 ....i ((preType["R")!(preType["F"))  d
 .....s ^TMP("MZJF","YJHZA",footUser,job,accNO)=accNO
 .....s ^TMP("MZJF","YJHZT",footUser,job,accNO)=accNO
 .....s accAllNum=accAllNum+1
 .....s accAllSum=accAllSum+(+preSum)
 .....s accTFNum=accTFNum+1
 .....s accTFSum=accTFSum+(+preSum)
 .....s accAllNumTotal=accAllNumTotal+1
 .....s accAllSumTotal=accAllSumTotal+(+preSum)
 .....s accTFNumTotal=accTFNumTotal+1
 .....s accTFSumTotal=accTFSumTotal+(+preSum)
 w accAllNumTotal_"++"_accAllSumTotal,!
	
	*//*
	zn "PACS"
	s str = ##class(HerpBonusPacsInterface.BodyPart).BodyPart("CS20121108018")
	zn "DHC-APP"
	w str,!
	
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YearMonth=Year_Month
	s sMonth="M"_ Month
	
	s OrdinaryPackg= 0
	s SurgeryPackg = 0 
    
    ;&sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode in ( '0600422','0600424') )
    s sqlStr="select * from BODYPART"
          
    
	s result=##class(%Library.ResultSet).%New()
	zn "PACS"
	d result.Prepare(sqlStr)
	zn "dhc-APP"
	d result.Execute()
    s OutQty = "" 
    s PkName = ""
	While(result.Next())
	{
		s OutQty = result.Data("BP_DESC")
	  w "asdf",!
	}
  q OutQty
  */
  q 0
}

ClassMethod ByRecDate(date, FindFlag)
{
  s date=$g(date),FindFlag=$g(FindFlag)
  s HospitalCode = "东营二院"
  s timeFlag = "Y"
  f tim="" f  s tim=$o(^TDAY(10,date,tim)) q:tim=""  d
  .s ptype="" f  s ptype=$o(^TDAY(10,date,tim,ptype)) q:ptype=""  d
  ..s VisitNumber="" f  s VisitNumber=$o(^TDAY(10,date,tim,ptype,"N",VisitNumber)) q:VisitNumber=""  d
  ...;//医院代码控制?----DaiYi----
  ...Set CurHospitalCode=$Piece(^TEPI(VisitNumber),"\",26)
  ...If $Length(HospitalCode),$l(CurHospitalCode),CurHospitalCode'=HospitalCode Quit
  ...i $l(HospitalCode),'$l(CurHospitalCode),'$d(^TTABi("CC",1,HospitalCode)) Quit
  ...//-----------------------------
  ...s TestsetDr="" f  s TestsetDr=$o(^TDAY(10,date,tim,ptype,"N",VisitNumber,TestsetDr)) q:TestsetDr=""  d
  ....s TestSetCounter="" f  s TestSetCounter=$o(^TDAY(10,date,tim,ptype,"N",VisitNumber,TestsetDr,TestSetCounter))  q:TestSetCounter=""  d
  .....s ttime=tim * 60
  .....;i (timeFlag="Y"),(date=startdate),(ttime<starttime) q
  .....;i (timeFlag="Y"),(date=enddate),(ttime>endtime) q
  .....w FindFlag_"++"_TestsetDr_"++"_TestSetCounter,!
  .....s ^hahah=^hahah+1 ;w FindFlag_"++"_TestsetDr_"++"_TestSetCounter,!  i TestsetDr ="F0011"
  .....;i FindFlag="TC" d TestCodeSum(VisitNumber,TestsetDr,TestSetCounter)
  .....;i FindFlag="TS" d SetSampleInfo(VisitNumber,TestsetDr,TestSetCounter)
  .....;i FindFlag="Sample" d SampleMerge(VisitNumber,TestsetDr,TestSetCounter)
  q
}

/// 清除统计预交金号段时用到的临时Global
ClassMethod ClearTMP1(guser, job)
{
	n (guser,job)
	k ^TMP("MZJF","YJHZA",guser,job)
    k ^TMP("MZJF","YJHZS",guser,job)
    k ^TMP("MZJF","YJHZT",guser,job)
    k ^TMP("EPInvDailyHand/No",guser,"AllYJ","no")
    k ^TMP("EPInvDailyHand/No",guser,"SYJ","no")
    k ^TMP("EPInvDailyHand/No",guser,"TYJ","no")
}

/*
/// StartDate,EndDate,displocrowid,StatType,CheckUser
ClassMethod QueryWork(datef, datet, pha, stattype, checkuser)
{
	;s datef="2004-04-02"
	;s datet="2004-04-02"
	;s pha="ZYYF-住院药房"

	k ^TMP($j,"WORK")
	k ^TMP($j,"mPLIST")
	;s datef=$ZDH(datef,3)
	;s datet=$ZDH(datet,3)
	q:pha="" 0
	q:stattype="" 0
	;
	n oper,counts,amt
	s counts="",amt=""
	;---发药
	f date=datef:1:datet d
	. s phacid=""
	. f  s phacid=$o(^DHCPHAC(0,"PHA",pha,"DATE",date,phacid)) q:phacid=""  d
	. . s str=..GetZYYPFac(phacid)
	. . s num1=$p(str,"^",1) ;代煎剂数
	. . s num2=$p(str,"^",2) ;代煎处方张数
	. . s num3=$p(str,"^",3) ; 处方张数
	. . s num4=$p(str,"^",4)  ;处方剂数
	. . s num5=$p(str,"^",5)  ;味数
	. . s num6=$p(str,"^",6)  ;出院带药张数
	. . s num7=$p(str,"^",7)  ;出院带药张数
	. . s num8=..QueOutAmt(phacid) ;出院带药金额
	. . s num3=..SumRegnoFromDispNO(phacid)
	. . 
	. . s warddr=$p(^DHCPHAC(phacid),"^",4)
	. . s oper=$p(^DHCPHAC(phacid),"^",5) ;按发药人
	. . s cuserdr=$p(^DHCPHAC(phacid),"^",13)
	. . s counts=$p(^DHCPHAC(phacid),"^",9)
	. . s dispno=$p(^DHCPHAC(phacid),"^",14)
	. . s amt=..DispAmt(phacid)
	. . ;
	. . s ch=$o(^DHCPHAC(phacid,"I","")) 
	. . ;s oeori=$p(^DHCPHAC(phacid,"I", ch),"^",7)
	. . ;s oewarddr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",3)
	. . s adm=$p(^DHCPHAC(phacid,"I",ch),"^",3)
    . . s collward=$p(^PAADM(adm),"^",70)
	. . i warddr="" s warddr=collward ;特殊科室转病区
	. . ;
	. .i stattype="2" d
	. ..i warddr="" d
	. ...s oper="其他"
	. ..e  d
	. ...s oper=$p($g(^PAWARD(warddr)),"^",2)
	. ...i oper="" s oper="其他"
	. ...e  d
	. ....i $f(oper,"-") s oper=$p(oper,"-",2)
	. . 
	. . q:(checkuser=1)&(cuserdr="")
	. . i checkuser=1 s oper=cuserdr  ;按第二发药人
	. . 
	. . i $d(^TMP($j,"WORK",oper))  d
	. . . s $p(^TMP($j,"WORK",oper),"^",1)=$p(^TMP($j,"WORK",oper),"^",1)+counts
	. . . s $p(^TMP($j,"WORK",oper),"^",2)=$p(^TMP($j,"WORK",oper),"^",2)+amt
	. . . s $p(^TMP($j,"WORK",oper),"^",3)=$p(^TMP($j,"WORK",oper),"^",3)+num1
	. . . s $p(^TMP($j,"WORK",oper),"^",4)=$p(^TMP($j,"WORK",oper),"^",4)+num2
	. . . s $p(^TMP($j,"WORK",oper),"^",5)=$p(^TMP($j,"WORK",oper),"^",5)+num3
	. . . s $p(^TMP($j,"WORK",oper),"^",6)=$p(^TMP($j,"WORK",oper),"^",6)+num4
	. . . s $p(^TMP($j,"WORK",oper),"^",7)=$p(^TMP($j,"WORK",oper),"^",7)+num5
	. . . s $p(^TMP($j,"WORK",oper),"^",12)=$p(^TMP($j,"WORK",oper),"^",12)+num6
	. . . s $p(^TMP($j,"WORK",oper),"^",13)=$p(^TMP($j,"WORK",oper),"^",13)+num7
	. . . s $p(^TMP($j,"WORK",oper),"^",14)=$p(^TMP($j,"WORK",oper),"^",14)+num8
	. . e  d
	. . . s ^TMP($j,"WORK",oper)=counts_"^"_amt_"^"_num1_"^"_num2_"^"_num3_"^"_num4_"^"_num5_"^"_0_"^"_0_"^"_0_"^"_0_"^"_num6_"^"_num7_"^"_num8
	. . i '$d(^TMP($j,"WORK",oper,dispno)) d 
	. . .s (^TMP($j,"WORK",oper,dispno))=""
	.
	;---退药 LQ
	s QueNum=1 ;处方张数
	s FacNum=0 ;处方剂数
	k ^TMP($j,"dhcpha","GetZYYPRet")
	f date=datef:1:datet d
	.s phret=""
	.f  s phret=$o(^PHARET(0,"RECLOC",pha,date,phret))  q:phret=""  d
	..s oper=$p(^PHARET(phret),"^",3)
	..s retno=$p(^PHARET(phret),"^",7)
	..s retchl=""
 	..f  s retchl=$o(^PHARET(phret,"I",retchl)) q:retchl=""  d
	...s retamt=$p(^PHARET(phret,"I",retchl),"^",5)
	...s dodis=$p(^PHARET(phret,"I",retchl),"^",13)
	...s wardlocID=$p(^PHARET(phret),"^",6)
	...s phacid=$p(^DHCOEDISQTY(dodis),"^",14)
	...s cuserdr=$p(^DHCPHAC(+phacid),"^",13)
	...s oedis=$p(^PHARET(phret,"I",retchl),"^",1) 
	...q:oedis=""
 	...s ord=$p(oedis,"||",1)
 	...s chl=$p(oedis,"||",2)
	...;--草药部分
	...s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	...
	...s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
	...i (queid'="")&&($d(^PAQUE1(queid,"DHC"))) d 
    ....s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
    ....s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
    ....s FacNum=facotor
    ...; 
	...
	...i wardlocID="" 
    ...
	...i stattype="2" d
	....i wardlocID="" d
	.....s adm=$p(^DHCPHAC(+phacid,"I", $p(phacid,"||",2)),"^",3)
    .....s collward=$p(^PAADM(adm),"^",70)
    .....s oper=$p($g(^PAWARD(collward)),"^",2)  ;特殊科室转病区
	....e  d
	.....s oper=$p(^CTLOC(wardlocID),"^",2)
	....i oper="" s oper="其他"
	....e  d
	.....i $f(oper,"-") s oper=$p(oper,"-",2)
	...
	...q:(checkuser=1)&(cuserdr="")
	...i checkuser=1 s oper=cuserdr  ;按第二发药人
	...
	...i '$d(^TMP($j,"WORK",oper)) d
	....s ^TMP($j,"WORK",oper)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_1_"^"_retamt_"^"_QueNum_"^"_FacNum_"^"_0_"^"_0_"^"_0
	...e  d
	....s $p(^TMP($j,"WORK",oper),"^",8)=$p(^TMP($j,"WORK",oper),"^",8)+1  ;退药品种数
    ....s $p(^TMP($j,"WORK",oper),"^",9)=$p(^TMP($j,"WORK",oper),"^",9)+retamt ;退药金额
    ...
    ....i '$d(^TMP($j,"dhcpha","GetZYYPRet",prescno)) d
    .....s $p(^TMP($j,"WORK",oper),"^",10)=$p(^TMP($j,"WORK",oper),"^",10)+1 ;退药处方张数
    .....s $p(^TMP($j,"WORK",oper),"^",11)=$p(^TMP($j,"WORK",oper),"^",11)+FacNum ;退药处方剂数
    ...
    ...i (queid'="")&&($d(^PAQUE1(queid,"DHC"))) d 
    ....s ^TMP($j,"dhcpha","GetZYYPRet",prescno)=""
    ...
    ...i '$d(^TMP($j,"WORK",oper,retno)) d 
	....s (^TMP($j,"WORK",oper,retno))=""
    .
    ;---合计	
	s oper="" 
	s i=0
	f  s oper=$o(^TMP($j,"WORK",oper)) q:oper=""  d
	.s dispno=""
	.s num=0
	.f  s dispno=$o(^TMP($j,"WORK",oper,dispno)) q:dispno=""  d
	..s num=num+1
	.i stattype="1" d
	..s operno=$p(^SSU("SSUSR",oper),"^",1)
	..s opername=$p(^SSU("SSUSR",oper),"^",2)
	.i stattype="2" d
	..s operno=""
	..s opername=oper
	.s i=i+1
	.s info1=$g(operno)_"^"_$g(opername)_"^"_$p(^TMP($j,"WORK",oper),"^",1)_"^"_$p(^TMP($j,"WORK",oper),"^",2)_"^"_num_"^"_$p(^TMP($j,"WORK",oper),"^",3)_"^"_$p(^TMP($j,"WORK",oper),"^",4)_"^"_$p(^TMP($j,"WORK",oper),"^",5)_"^"_$p(^TMP($j,"WORK",oper),"^",6)_"^"_$p(^TMP($j,"WORK",oper),"^",7)_"^"_$p(^TMP($j,"WORK",oper),"^",8)_"^"_$p(^TMP($j,"WORK",oper),"^",9)
	.s info2=$p(^TMP($j,"WORK",oper),"^",10)_"^"_$p(^TMP($j,"WORK",oper),"^",11)_"^"_$p(^TMP($j,"WORK",oper),"^",12)_"^"_$p(^TMP($j,"WORK",oper),"^",13)_"^"_$p(^TMP($j,"WORK",oper),"^",14)
	.s info=info1_"^"_info2
	.s ^TMP($j,"mPLIST",i)=info
	k ^TMP($j,"WORK")
	k ^TMP($j,"dhcpha","GetZYYPFac")
	k ^TMP($j,"dhcpha","GetZYYPRet")
	q i
}
*/

//这些代码是从别的组拿过来的，直接用了

// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).QueryGZLNewExecute("80","63425","63455","","")

ClassMethod QueryGZLNewExecute(ctloc As %String, CDateSt As %String, CDateEnd As %String, CStTime As %String, CEndTime As %String) As %String
{
     Set repid=$I(^CacheTemp)
	 s ind=1
	 ;i ctloc="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s phloc=""
	 s phloc=$o(^DHCPHLOCi("LOC",ctloc,""))
	 ;i phloc=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s stdate="",enddate=""
	 s sttime="",endtime=""
	 s sttime=CStTime,endtime=CEndTime
	 ;i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	 ;i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	 s stdate=CDateSt,enddate=CDateEnd
	 ;i stdate>enddate Set QHandle=$lb(0,repid,0) Quit $$$OK
	 
	 s cyflag=""
	 
	 s cyflag=$p(^DHCPHLOC(phloc),"^",6)
	 k ^DHCPHPWinPer($j)
	 
	 ;s ^hahah = 0
     ;d ##class(%ResultSet).RunQuery("web.DHCOutPhRetrieve","QueryGZLNew","80","63425","63455","","")
	 ;s ^hahah = ctloc_"++"_CDateSt_"++"_CDateEnd_"++"_CStTime
	 //发药
	 f intrdate=stdate:1:enddate  d
	 .s intr=""
	 .f  s intr=$o(^DHCINTR(0,"TypeDate","F",intrdate,intr)) q:intr=""  d
	 ..s inclb=$p(^DHCINTR(intr),"^",7)
	 ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	 ..q:intrloc'=ctloc
	 ..s phdclb=$p(^DHCINTR(intr),"^",9)
	 ..s phdrow=$p(phdclb,"||",1)
	 ..s phdi=$p(phdclb,"||",2)
	 ..s phwrow=""
	 ..
	 ..q:'$d(^DHCPHDISP(phdrow,1))
	 ..s phwrow=+$p(^DHCPHDISP(phdrow,1),"^",4)
	 ..s intrtime=$p(^DHCINTR(intr),"^",3)
	 ..;q:(intrdate=stdate)&(intrtime<sttime)&(sttime'="")
	 ..;q:(intrdate=enddate)&(intrtime>endtime)&(endtime'="")
	 ..s presc=$p(^DHCPHDISP(phdrow,2),"^",1)
	 ..s phdfydr=+$p(^DHCPHDISP(phdrow,1),"^",2)
	 ..s cyfs=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",9)
	 ..s amt=$p(^DHCINTR(intr),"^",8)
	 ..i $D(^DHCPHPWinPer($j,phdfydr)) d
	 ...s $p(^DHCPHPWinPer($j,phdfydr),"^",1)=+$p(^DHCPHPWinPer($j,phdfydr),"^",1)+amt //发药金额
	 ...s $p(^DHCPHPWinPer($j,phdfydr),"^",2)=+$p(^DHCPHPWinPer($j,phdfydr),"^",2)+1   //发药量(品种数)
	 ...
	 ...i '$D(^DHCPHPWinPer($j,phdfydr,presc)) d
	 ....s $p(^DHCPHPWinPer($j,phdfydr),"^",3)=+($p(^DHCPHPWinPer($j,phdfydr),"^",3))+1  //发药处方数
	 ....s ^hahah= ^hahah +1
	 ....s $p(^DHCPHPWinPer($j,phdfydr),"^",4)=+($p(^DHCPHPWinPer($j,phdfydr),"^",4))+cyfs  //草药付数
	 ....s ^DHCPHPWinPer($j,phdfydr,presc)=""
	 ..e  d
	 ...s ^DHCPHPWinPer($j,phdfydr,presc)=""
	 ...s ^DHCPHPWinPer($j,phdfydr)=amt_"^"_"1"_"^"_"1"_"^"_cyfs_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	 ..
     //配药
     f phddate=stdate:1:enddate  d
	 .s phdrow=""
	 .f  s phdrow=$o(^DHCPHDISPi(phddate,phloc,phdrow)) q:phdrow=""  d
	 ..s phwrow=""
	 ..s phwrow=+$p(^DHCPHDISP(phdrow,1),"^",4)
	 ..s phdpyflag="",phdfyflag=""
	 ..s phdfyflag=$p(^DHCPHDISP(phdrow),"^",4)
	 ..s phdpyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	 ..s phdpydr="",phdfydr="",phdtime=""
	 ..s phdtime=+$p(^DHCPHDISP(phdrow,1),"^",7)
	 ..q:(phddate=stdate)&(phdtime<sttime)&(sttime'="")
	 ..q:(phddate=enddate)&(phdtime>endtime)&(endtime'="")
	 ..s presc="",prescrow="",jytype=""
	 ..s presc=$p(^DHCPHDISP(phdrow,2),"^",1)
	 ..s phdpydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	 ..s phdi="0",cyfs=1,phdmoney=0
	 ..f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:(phdi="")!(phdi="0")  d
	 ...s phdimoney=0
	 ...s phdimoney=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",3)
	 ...s cyfs=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",9)
	 ...i cyfs=0  s cyfs=1
	 ...s phdimoney=$p(phdimoney,$c(1),1)
	 ...//s phdmoney=phdmoney+phdimoney  
	 ...i $d(^DHCPHPWinPer($j,phdpydr))  d
	 ....//s ^lq(phdpydr,phdrow)=phdimoney
	 ....s $p(^DHCPHPWinPer($j,phdpydr),"^",5)=+$p(^DHCPHPWinPer($j,phdpydr),"^",5)+phdimoney //配药金额
	 ....s $p(^DHCPHPWinPer($j,phdpydr),"^",7)=+$p(^DHCPHPWinPer($j,phdpydr),"^",7)+1  //配药品种数
	 ....i '$d(^DHCPHPWinPer($j,phdpydr,"py",presc))  d 
	 .....s $p(^DHCPHPWinPer($j,phdpydr),"^",6)=+$p(^DHCPHPWinPer($j,phdpydr),"^",6)+1  //配药处方数
	 .....s ^DHCPHPWinPer($j,phdpydr,"py",presc)=""
	 ....
	 ...e  d
	 ....s ^DHCPHPWinPer($j,phdpydr,"py",presc)=""
	 ....//s ^lq(phdpydr,phdrow,phdi)=phdimoney
	 ....s ^DHCPHPWinPer($j,phdpydr)=0_"^"_0_"^"_0_"^"_0_"^"_phdimoney_"^"_1_"^"_1 _"^"_0_"^"_0_"^"_0_"^"_0
	 	 
     //退药 
    f intrdate=stdate:1:enddate  d
    .s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypeDate","H",intrdate,intr)) q:intr=""  d
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    ..q:intrloc'=ctloc
    ..s phreti=$p(^DHCINTR(intr),"^",9)
    ..s phretrow=+phreti
    ..s retper=+$p(^DHCPHRET(phretrow),"^",8)
    ..s phrettime=+$p(^DHCINTR(intr),"^",3)
    ..q:(sttime'="")&(intrdate=stdate)&(phrettime<sttime)
    ..q:(sttime'="")&(intrdate=enddate)&(phrettime>endtime)
    ..s phretchid=$p(phreti,"||",2)
    ..s retori=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",2)
    ..s phretmoney=$p(^DHCINTR(intr),"^",8)
    ..s phdi=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",7)
    ..s phd=$p(phdi,"||",1)
    ..s phdsub=$p(phdi,"||",2)
	..s cyfs=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",9)
	..s presc=$p(^DHCPHDISP(phd,2),"^",1)
	..
    ..i $D(^DHCPHPWinPer($j,retper)) d
	...s $p(^DHCPHPWinPer($j,retper),"^",8)=+$p(^DHCPHPWinPer($j,retper),"^",8)+phretmoney //退药金额
	...s $p(^DHCPHPWinPer($j,retper),"^",9)=+$p(^DHCPHPWinPer($j,retper),"^",9)+1   //退药量(品种数)
	...i '$D(^DHCPHPWinPer($j,retper,"ret",presc)) d
	....s $p(^DHCPHPWinPer($j,retper),"^",10)=+($p($g(^DHCPHPWinPer($j,retper)),"^",10))+1  //退药处方数
	....s $p(^DHCPHPWinPer($j,retper),"^",11)=+($p($g(^DHCPHPWinPer($j,retper)),"^",11))+cyfs  //退药草药付数
	....s ^DHCPHPWinPer($j,retper,"ret",presc)=""
	..e  d
	...s ^DHCPHPWinPer($j,retper,"ret",presc)=""
	...s ^DHCPHPWinPer($j,retper)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_phretmoney_"^"_1_"^"_1_"^"_cyfs
     
     //非正常发药
     
 	f intrdate=stdate:1:enddate  d
    .s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypeDate","S",intrdate,intr)) q:intr=""  d
    ..s phundclb=$p(^DHCINTR(intr),"^",9)
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    ..q:intrloc'=ctloc
    ..s phundrow=+phundclb
    ..s phuser=+$p(^DHCPHUND(phundrow),"^",10)
    ..s newwinpos=""
    ..s phundtime=""
    ..s phundtime=+$p(^DHCPHUND(phundrow),"^",12)
    ..q:(sttime'="")&(intrdate=stdate)&(phundtime<sttime)
    ..q:(sttime'="")&(intrdate=enddate)&(phundtime>endtime)
    ..s phunditm=$p(phundclb,"||",2)
    ..s undinci=+$p(^DHCPHUND(phundrow,"I",phunditm),"^",2)
    ..s ctuom=+$p(^DHCPHUND(phundrow,"I",phunditm),"^",1)
    ..s qty=+$p(^DHCINTR(intr),"^",6)
    ..s money=$p(^DHCINTR(intr),"^",8)
    ..s price=$p(^DHCINTR(intr),"^",14)
    ..s ^lq(intr)=money
    ..i $D(^DHCPHPWinPer($j,phuser)) d
	...s $p(^DHCPHPWinPer($j,phuser),"^",1)=+$p(^DHCPHPWinPer($j,retper),"^",1)+money //非正常发药金额
	...s $p(^DHCPHPWinPer($j,phuser),"^",2)=+$p(^DHCPHPWinPer($j,retper),"^",2)+1   //非正常发药量(品种数)
	..e  d
	...s ^DHCPHPWinPer($j,phuser)=money_"^"_1_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
     
    //非正常退药
  	f intrdate=stdate:1:enddate  d
    .s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypeDate","Z",intrdate,intr)) q:intr=""  d
    ..s phunretrowid=$p(^DHCINTR(intr),"^",9)
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    ..q:intrloc'=ctloc
    ..s phunrrow=+phunretrowid
    ..s phunditm=$p(phunretrowid,"||",2)
    ..s phuser=+$p(^DHCPHUNR(phunrrow),"^",11)
    ..s phunrtime=""
    ..s phunrtime=+$p(^DHCPHUNR(phunrrow),"^",12)
    ..q:(sttime'="")&(intrdate=stdate)&(phunrtime<sttime)
    ..q:(sttime'="")&(intrdate=enddate)&(phunrtime>endtime)
    ..s unrinci=+$p(^DHCPHUNRI(phunrrow,"I",phunditm),"^",2)
    ..s ctuom=+$p(^DHCPHUNRI(phunrrow,"I",phunditm),"^",1)
    ..s qty=+$p(^DHCINTR(intr),"^",6)
    ..s money=$p(^DHCINTR(intr),"^",8)
    ..i $D(^DHCPHPWinPer($j,phuser)) d
	...s $p(^DHCPHPWinPer($j,phuser),"^",8)=+$p(^DHCPHPWinPer($j,retper),"^",8)+money //非正常退药金额
	...s $p(^DHCPHPWinPer($j,phuser),"^",9)=+$p(^DHCPHPWinPer($j,retper),"^",9)+1   //非正常退药量(品种数)
	..e  d
	...s ^DHCPHPWinPer($j,phuser)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_money_"^"_1_"^"_0_"^"_0
     
     //合计输出
    
	 s phw=""
	 s n=0
	 s hjpyrc=0,hjfyrc=0,hjpyje=0,hjfyje=0,hjpyl=0,hjfyl=0
	 s hjtyrc=0,hjtyje=0,hjtyl=0,hjfyfs=0,hjpyfs=0,hjtyfs=0
	 s hjjyfs=0,hjjycf=0
     s phdper=""
	 f  s phdper=$o(^DHCPHPWinPer($j,phdper)) q:phdper=""  d
     .s phwfyrc=0,phwpyrc=0,phwfyje=0,phwpyje=0,phwpycount=0,phwfycount=0
     .q:phdper=0
     .s jyfs=0,jycf=0
     .s tyrc=0,tyje=0,tyl=0,pyfs=0,fyfs=0,tyfs=0
     .s phwpyrc=$p(^DHCPHPWinPer($j,phdper),"^",6)  //配药处方
     .s phwpyje=$p(^DHCPHPWinPer($j,phdper),"^",5)  //配药金额
     .s phwfyrc=$p(^DHCPHPWinPer($j,phdper),"^",3)  //发药处方
     .s phwfyje=$p(^DHCPHPWinPer($j,phdper),"^",1)  //发药金额
     .//s phwpyje=$fn(phwpyje,"",2)    
     .//s phwfyje=$fn(phwfyje,"",2)     
     .s phwpycount=$p(^DHCPHPWinPer($j,phdper),"^",7) //配药量
     .s phwfycount=$p(^DHCPHPWinPer($j,phdper),"^",2) //发药量
     .s tyrc=$p(^DHCPHPWinPer($j,phdper),"^",10) //退药处方数
     .s tyje=$p(^DHCPHPWinPer($j,phdper),"^",8) //退药金额
     .s tyl=$p(^DHCPHPWinPer($j,phdper),"^",9)  //退药量
     .s pyfs=0  //$p(^DHCPHPWinPer($j,phdper),"^",10)  
     .s fyfs=$p(^DHCPHPWinPer($j,phdper),"^",4)  //发药付数
     .s tyfs=$p(^DHCPHPWinPer($j,phdper),"^",11)  //退药付数
     .s jyfs=0 //$p(^DHCPHPWinPer($j,phdper),"^",15)
     .s jycf=0 //$p(^DHCPHPWinPer($j,phdper),"^",16)
     .
     .s hjpyrc=hjpyrc+phwpyrc
     .s hjfyrc=hjfyrc+phwfyrc
     .s hjpyje=hjpyje+phwpyje
     .s hjfyje=hjfyje+phwfyje
     .//s hjpyje=$fn(hjpyje,"",2) 
     .//s hjfyje=$fn(hjfyje,"",2) 
     .s hjpyl=hjpyl+phwpycount
     .s hjfyl=hjfyl+phwfycount
     .s hjtyrc=hjtyrc+tyrc
     .s hjtyje=hjtyje+tyje
     .s hjtyl=hjtyl+tyl
     .s hjpyfs=hjpyfs+pyfs
     .s hjfyfs=hjfyfs+fyfs
     .s hjtyfs=hjtyfs+tyfs
     .s hjjyfs=hjjyfs+jyfs
     .s hjjycf=hjjycf+jycf
     .s phwdesc="",phdpname=""
     .s phdpname=$p(^DHCPHPER(phdper),"^",2)
     .i phdpname["#" s phdpname=$p(phdpname,"#",2)
    
      /*
     .set Data=$lb(phdpname,phwpyrc,phwfyrc,$fn(phwpyje,"",2),$fn(phwfyje,"",2),phwpycount,phwfycount,tyrc,tyje,tyl,pyfs,fyfs,tyfs,jyfs,jycf)
     .Set ^CacheTemp(repid,ind)=Data	
     .Set ind=ind+1
     if ind>1 d
     .set Data=$lb("合计",hjpyrc,hjfyrc,$fn(hjpyje,"",2),$fn(hjfyje,"",2),hjpyl,hjfyl,hjtyrc,hjtyje,hjtyl,hjpyfs,hjfyfs,hjtyfs,hjjyfs,hjjycf)
     .Set ^CacheTemp(repid,ind)=Data	
     .Set ind=ind+1
     Set QHandle=$lb(0,repid,0)
     Quit $$$OK
     */
     q hjfyrc
}

/// DSA 由两部分组成，手术列表中查出的已完成的手术个数和门诊医嘱项为输卵管介入治疗的医嘱个数
/// 第一部分直接对别的组已经写好的代码加了个判断是否已完成之后计数,第二部分直接统计相关医嘱个数
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).DSA("2014-08-26","2014-09-25","6")2014-08-26 2014-09-03
ClassMethod DSA(sdate As %String, edate As %String, MethodDr As %String) As %String
{
 n (sdate,edate,MethodDr)
 s Year=$p(edate,"-",1)
 s Month=$p(edate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 s sdate=$zdh(sdate,3)
 s edate=$zdh(edate,3)
 s (oproom,oprFloorId,stat,appType,MedCareNo,Dept,patWardId,paidType)=""
 s userLocTyp = "OP"
 s LogUserType = "OPNURSE"
 s ifAllLoc = "N"
 s userLocIdStr = "120^88" 
 s DsaCount = 0
  ;s ^hahah=0
 f date=sdate:1:edate
    {   
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s opdate="",oproomdes="",regNo="",patName="",diag="",sex="",yy="",age="",opdes="",locdes="",opd="",mzdoc="",anmethod="",xsh="",xch="",OPCategory=""
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		.s openddate=$P(^DHCANOPArrange(opaId),"^",16)
		.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		.s opmem=$P(^DHCANOPArrange(opaId),"^",19)        	//WKZ 071109
		.i openddate<=opstdate s openddate=""
		.i openddate'=""  s openddate=##class(web.DHCANOPCom).ConvertToDate(openddate) //$ZD(openddate,3)_" " 20131014wq
		.i opendtime'=""  s opendtime=$ZT(opendtime,2)
		.i opsttime'=""  s opsttime=$ZT(opsttime,2)
		.s opdatestr=##class(web.DHCANOPCom).ConvertToDate(opstdate)_" "_opsttime_"~"_openddate_opendtime
		.s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)         //wkz 071225 S
		.s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
		.i opAppdate'=""  s opAppdate=##class(web.DHCANOPCom).ConvertToDate(opAppdate) //$ZD(opAppdate,3)  20131014wq
		.s opApptimeQuery=""
		.i opApptime'=""  d
		..s opApptimeQuery=+opApptime
		..s opApptime=$ZT(opApptime,2)
		.s OpAppDateStr=$G(opAppdate)_"  "_$G(opApptime)  	 //wkz 071225 E
		.s arrTime=$P(^DHCANOPArrange(opaId),"^",8)
		.s arrDate=$P(^DHCANOPArrange(opaId),"^",7)
		.i arrTime'=""  d 	//安排时间不为空
		..s opdate=$ZD(arrDate,3)_" "_$ZT(arrTime,2)
		.e  s opdate=$ZD(opstdate,3)_" "_opsttime
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		.q:(oproomdr'=oproom)&(oproom'="")
		.i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
		.e  s floorId=""
		.i floorId'="" s oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
		.e  s oprFloor=""
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,1)=oprFloorId_"/"_floorId
		.q:(oprFloorId'="")&(oprFloorId'=floorId)
		.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
		.i (sdate=edate)&(opordno'="")&(opordno=1)&(arrTime="") s opdate="8:30"
		.e  i (sdate'=edate)&(opordno'="")&(opordno=1)&(arrTime="") s opdate=$ZD(opstdate,3)_" "_"8:30"  
		.e  i (sdate=edate)&(opordno'="")&(opordno=1)&(arrTime'="") s opdate=$ZT(arrTime,2)
		.e  i (sdate'=edate)&(opordno'="")&(opordno=1)&(arrTime'="") s opdate=$ZD(opstdate,3)_" "_opsttime
		.s tmpDateStr=opordno
		.i +tmpDateStr=0 s tmpDateStr=""
		.e  s tmpDateStr=tmpDateStr-1
		.s tmpDateStr="接台"_tmpDateStr
		.i sdate'=edate s tmpDateStr=$p(opdate," ")_" "_oproomdes_tmpDateStr
		.e  s tmpDateStr=oproomdes_tmpDateStr
		.i (opordno'="")&(opordno'=1) s opdate=tmpDateStr 
		.s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
		.q:adm=""
		.s bedCode="",inPatNo="",admreason=""
		.s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
		.s curWardId=$p($g(^PAADM(adm)),"^",70)  
		.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
		.i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
		.s inPatNo=$p($g(^PAADM(adm)),"^",29)
		.s admreasondr=$p($g(^PAADM(adm,1)),"^",7)
		.i admreasondr'="" s admreason=$p(^PAC("ADMREA",admreasondr),"^",2)
		.s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)			//OPA_PATestHBsAg  	免疫乙肝表面抗原
		.s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)			//OPA_PATestHCVAb 	免疫丙型肝炎抗体
		.s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)			//OPA_PATestHivAb 	免疫艾滋病毒抗体
		.s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)			//OPA_PATestTPAb 	免疫梅毒
		.s qt=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)			//OPA_PATestOther	检其它阴阳性
		.i yg="阳性(+)" s yy="乙肝阳性"
		.i bg="阳性(+)" s yy=yy_"丙肝阳性"_" "
		.i az="阳性(+)" s yy=yy_"艾滋病阳性"_" "
		.i md="阳性(+)" s yy=yy_"梅毒阳性"_" "
		.i qt="阳性(+)" s yy=yy_"其他阳性"_" "
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,2)=userLocTyp_"/"_opaStatus_"/"_curWardId
		.q:(opaStatus="")&(userLocTyp'="E")
		.s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
		.q:(stat'="")&(stat'=opaStatus)
		.s status=""
		.s opaStatusQuery=2
		.;i opaStatus="A" d
		..;s status="申请"
		..;s opaStatusQuery=1
		.;i (opaStatusQuery'=1) d
		..;s opApptimeQuery="A"
		.;i (opaStatus="D")&(opaPatStatus'="I") d
		..;s status="拒绝"
		..;s opaStatusQuery=3
		.;i opaStatus="R" s status="安排"
		.;i opaStatus="N" s status="非预约"
		.;i opaStatus="I" s status="术中"
		.;i opaStatus="P" s status="恢复室"
		.;i opaStatus="L" s status="术毕"
		.;i opaStatus="F" s status="完成"
		.;s ^hahah = ^hahah+1
		.i (opaStatus="D")&(opaPatStatus="I") s status="撤销"
		.q:(opaStatus="N")&(appType="")
		.q:(opaStatus'="N")&(appType="RegNotApp")
		.s groupDesc= "Demo Group"  ;%session.Data("LOGON.GROUPDESC")
		.q:(opaStatus="D")&(opaPatStatus="I")&(groupDesc'="住院医生")&(groupDesc'="Inpatient Doctor")
		.s papmiId=$p($g(^PAADM(admId)),"^",1)
		.s paadmtype=$p($g(^PAADM(admId)),"^",2)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
		.q:(medCareNo'=MedCareNo)&(MedCareNo'="")
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		.;s age=..CalAge(birth,opstdate)
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s admLocId=$p($g(^PAADM(adm)),"^",4)
		.q:admLocId=""
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.//w Dept_"/"_opaId_"/"_admLocId_"/"_appLocId_"/"_locdes_";"
		.s qFlag=1
		.i (LogUserType'="ANDOCTOR")&(LogUserType'="ANNURSE")&(LogUserType'="OPNURSE")&(ifAllLoc="Y") s qFlag=0
		.;q:(Dept'[appLocId)&(Dept'="")&(Dept'[admLocId)&(admLocId'="")
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,4)=Dept_"/"_appLocId_"/"_admLocId
		.q:(("^"_Dept_"^")'[("^"_appLocId_"^"))&(Dept'="")&(("^"_Dept_"^")'[("^"_admLocId_"^"))&(admLocId'="")&(qFlag)
		.i +appLocId=0 s appLocId=admLocId
		.i +appLocId=0 s locdes=""
		.e  s locdes=$P($g(^CTLOC(appLocId)),"^",2)
		.i (appLocId'="")&(admLocId'=appLocId)&(paadmtype'="O") s locdes=locdes_"(借)"
		.i $l(locdes,"-")>1 s locdes=$p(locdes,"-",2)
		.i paadmtype="O" s locdes=locdes_"(门)"
		.e  s locdes=locdes_"/"_bedCode
		.s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
		.i jz="E" s jzstat="急诊"
		.e  s jzstat="择期"
		.;;;;最后手术登记存放的时间，20120607+dyl
		.s anaTheatreInDate=$p(^OR(adm,"ANA",chl),"^",39)
		.i anaTheatreInDate'="" s anaTheatreInDate=$zd(anaTheatreInDate,3)
		.e  s anaTheatreInDate=opstdate
		.s anaTheatreInTime=$p(^OR(adm,"ANA",chl),"^",40)
		.i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,2)
		.e  s anaTheatreInTime=opsttime
		.i opaStatus="F" s opdatestr=anaTheatreInDate_" "_anaTheatreInTime_"~"_openddate_opendtime
		.;;;;;;
		.s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					;ANA_Anaesthetist_Dr 
		.i mzdr'="" d
		..s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)
		.e  s mzdoc=""
		.s mzsupdr=$P(^OR(adm,"ANA",chl),"^",7)        				;ANA_Supervisor_DR ///ck091203  
		.i mzsupdr'="" d
		..s mzsupdoc=##class(web.DHCANOPCom).GetNameById(mzsupdr)
		.e  s mzsupdoc=""
		.s anDocAss=""
		.s ass=0,surgeonDesc=""
		.f  s ass=$o(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)) q:ass=""  d    //麻醉医师
		..s mzzsdr=$p($g(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)),"^",1)
		..q:mzzsdr=""
		..i anDocAss="" d
		...s anDocAss=##class(web.DHCANOPCom).GetNameById(mzzsdr)
		..e  d
		...s anDocAss=anDocAss_" "_##class(web.DHCANOPCom).GetNameById(mzzsdr)
		.i anDocAss'="" s mzdoc=mzdoc_","_anDocAss
		.s mzNurseId=$P(^OR(adm,"ANA",chl),"^",8)
		.i mzNurseId'="" d
		..s anNurse=##class(web.DHCANOPCom).GetNameById(mzNurseId)
		.e  s anNurse=""
		.s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)
		.s anmethod=""
		.i anmthdr'="" d
			..s anmetNum=$l(anmthdr,"|")
			..f i=1:1:anmetNum d
				...s anmetId=$p(anmthdr,"|",i)
				...q:anmetId=""
				...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
				...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
				...i anmethod="" s anmethod=anmetDesc
				...e  i (anmethod'="")&(anmethod'[anmetDesc) s anmethod=anmethod_","_anmetDesc
				...e  i (anmethod'="")&(anmethod[anmetDesc) s anmethod=anmethod
		.s anCompDesc=""                                        		//+ wxl 090316 合并疾病
		.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) q:(subchl="")  d
		..s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
		..q:AnCompDr=""
		..i anCompDesc="" s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
		..e  s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)	   
		.s i=0
		.s prediag="",diamen=""
			.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d ///ck091117
				..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
				..i opdr'=""  d   //ck091210
					...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     ///ck091117
					....i opdes'="" s opdes=opdes_";"     ///ck091117
					....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)     ///ck091117
				..e  d
					...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
					....i opdes'="" s opdes=opdes_";"
					....s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))    ///ck091210
		..s i=i+1
		..q:i>1   ///ck091117
		..s sub=subchl
		..;手术部位
		..s bodsIdList=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",24) 	 //ypz 070418 	手术部位
	    ..s bodsList="",bodsDesc=""
	    ..i bodsIdList'="" d
		    ...s bodsIdNum=$l(bodsIdList,"|")
		    ...f j=1:1:bodsIdNum d
			    ....s bodsId=$p(bodsIdList,"|",j)
			    ....q:bodsId=""
			    ....s bodsDesc2=$p($g(^OEC("BODS",+bodsId)),"^",2)
			    ....i bodsDesc="" s bodsDesc=bodsDesc2
			    ....e  s bodsDesc=bodsDesc_"|"_bodsDesc2   
		..;;;
		..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
		..s opd=""
		..//i docdr'="" s opd=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
		..i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
		..e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //CK 091210 手术医生备注(外来手术医生)
		..s surgeonDesc=opd   
		..s predigdrS=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)   		;ANAOP_PreopDiag_DR 术前诊断字符串  zhangtao add
		..s num=$l(predigdrS,"|")
		..f pi=1:1:num d
		...s predigdr=$p(predigdrS,"|",pi)
		...i predigdr'=""  d
		....s prediag=$P(^MRC("ID",predigdr),"^",2)
		...s $p(diag,",",pi)=$G(prediag)
		...e  d
		....i $g(^OR(adm,"ANA",chl,"TXT",2))'="" d 
		.....s diamen=$p(^OR(adm,"ANA",chl,"TXT",2),"|",pi)  	//ck091210 麻醉表存放诊断备注ANA_Notes
		.....s $p(diag,",",pi)=$G(diamen)            //zhangtao add
		..s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) 		;ANAOP_CTLOC_DR
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,5)=userLocIdStr_"/"_operLocId_"/"_admLocId_"/"_appLocId
		.s ^TempLm("Anop",opaId)=userLocIdStr_"/"_operLocId_"/"_admLocId_"/"_appLocId
		.q:(("^"_userLocIdStr_"^")'[("^"_+operLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+appLocId_"^"))&(qFlag)  //ypz 070318
		.;q:(("^"_userLocIdStr_"^")'[("^"_+operLocId_"^"))
		.s i=0
		.q:sub=""
		..s i=i+1
		.s ash=""
		.
		.s assDocNum=2 //最多显示的助手人数
		.i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)'="" s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
		.s p=0
		.s list=0,asName=""
		.s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42) //手动填写OPA_OpDocNote（实习医生1;实习医生2...|主刀|一助|二助|三助|四助|五助...）
		.s len=$l(opaDocNote,"|")
		.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",sub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
		..s asdr=$P(^OR(adm,"ANA",chl,"OP",sub,"ASS",as),"^",1)
		..s p=p+1
		..q:asdr=""
		..//s asName=asName_"^"_$P(^CTPCP(asdr,1),"^",2)
		..s asName=asName_"^"_##class(web.DHCANOPCom).GetNameById(asdr)
		.i len>assDocNum+2 s len=assDocNum+2
		.f getLen=3:1:len  d
		..i $p(opaDocNote,"|",getLen)'=""  d
		...s getName=$p(opaDocNote,"|",getLen)
		..e  d
		...s list=list+1
		...s getName=$p(asName,"^",list+1)
		..s ash=ash_" "_getName
		.
		.s p=0  ;洗手
		.s xs=0 f  s xs=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs)) q:(xs="")!(p=3)  d
		..q:xs>20
		..s xsdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs),"^",1)
		..q:xsdr=""
		..s p=p+1
		..//s xsh=xsh_" "_$TR($P(^CTPCP(xsdr,1),"^",2)," ","")  ;
		..s xsh=xsh_" "_##class(web.DHCANOPCom).GetNameById(xsdr)
		.s p=0  ;巡回
		.s xc=0 f  s xc=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc)) q:(xc="")!(p=3)   d
		..q:xc>20
		..s xchdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc),"^",1)
		..q:xchdr=""
		..s p=p+1
		..//s xch=$G(xch)_" "_$TR($P($G(^CTPCP(xchdr,1)),"^",2)," ","")  
		..s xch=$G(xch)_" "_##class(web.DHCANOPCom).GetNameById(xchdr)  
		.s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)		//OPA_ScrubNurseNote	器械护士备注 	
		.s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)		//OPA_CirculNurseNote	巡回护士备注
		.;s j=j+1
		.s opd=opd_","_$G(ash)
		.s sortOpRoomDesc=oproomdes
		.i oproomdes="" s oproomdes="无"
		.s sortOpaSeq=opordno
		.i opordno="" s opordno="未排" ;Do OutRow2
		.s NeedAnaesthetist=$p($G(^DHCANOPArrange(opaId)),"^",44)
		.
		.s oprFloor=""
		.//i NeedAnaesthetist'="Y" s oprFloor="不需要"
		.//e  d
			..q:"D"[opaStatus
			..s para="M^149^麻醉会诊意见"
			..s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
			..i eprRet=0 s oprFloor="未写麻醉会诊意见! "
			..s para="M^151^麻醉知情同意书"
			..s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
			..i eprRet=0 s oprFloor=oprFloor_"未写麻醉知情同意书! "
			..q:"AR"[opaStatus
			..i "I"[opaStatus s oprFloor=oprFloor_"未完成麻醉记录单! "
			..e  d
				...s anoId=$o(^DHCANOrder(0,"OPApp",opaId,""))
				...i anoId="" s oprFloor=oprFloor_"未写麻醉记录单! "
			..q:"I"[opaStatus
			..s para="M^153^麻醉术后访视记录"
			..s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
			..i eprRet=0 s oprFloor=oprFloor_"未写麻醉术后访视记录! "
		.
		.s operInstrumentId=$P(^DHCANOPArrange(opaId),"^",30)
		.i operInstrumentId'="" s operInstrument=$P($G(^DHCANC("Instrument",operInstrumentId)),"^",2)
		.e  s operInstrument=""
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
		.s anaSub=$P(anaId,"||",2)
		.;手术体位
		.s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
		.i operPositionId'="" s operPosition=$P($G(^ORC("OPPOS",operPositionId)),"^",2)
		.e  s operPosition=""
		.s OPCategory="",OPCategoryId=""
		.;s OPCategoryId=$p(^ORC("OPER",opdr),"^",7)
		.i opdr'="" s OPCategoryId=$p($g(^ORC("OPER",opdr)),"^",7)
		.i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
		.s isAddInstrument=$P($G(^DHCANOPArrange(opaId)),"^",31)
		.s instrumentDr=$P($G(^DHCANOPArrange(opaId)),"^",30)
		.i instrumentDr'="" s instrument=$P($G(^DHCANC("Instrument",instrumentDr)),"^",2)
		.e  s instrument=""
		.s patWardId1=$P($G(^DHCANOPArrange(opaId)),"^",32)
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,6)=patWardId1_"/"_patWardId
		.q:(patWardId'="")&(patWardId'=patWardId1)
		.i patWardId1'="" s patWard=$P($G(^PAWARD(patWardId1)),"^",2)
		.e  s patWard=""
		.s estiOperDuration=$P($G(^DHCANOPArrange(opaId)),"^",37)
		.i estiOperDuration'="" s estiOperDuration=$ZT(estiOperDuration,2)
		.s preDiscussDate=$P($G(^DHCANOPArrange(opaId)),"^",38)
		.s preDiscussDate=$ZD(preDiscussDate,4)
		.s isExCirculation=$P($G(^DHCANOPArrange(opaId)),"^",36)
		.s bloodTypId=$P(^DHCANOPArrange(opaId),"^",11)
		.i (+bloodTypId'=0)&($d(^PAC("BLDT",+bloodTypId))) s bloodType=$P($G(^PAC("BLDT",bloodTypId)),"^",2)
		.e  s bloodType="不详"
		.s opDocNote=$P($G(^DHCANOPArrange(opaId)),"^",42)
		.s anDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
		.s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)
		.s AnaesthesiaID=$P($G(^DHCANOPArrange(opaId)),"^",2)
		.s retReasonId=$P($G(^DHCANOPArrange(opaId)),"^",35)
		.i opaStatus'="D" s retReasonId=""	;20120613+dyl
		.i retReasonId'=""  s retReason=$p(^ORC("SUSP",retReasonId),"^",2)   //+ ck091212 手术拒绝原因
		.e  s retReason=""
		.s anaDoctorOrd=$p($G(^DHCANOPArrange(opaId)),"^",48)     	//+ ck091212 麻醉医生收费状态
		.i anaDoctorOrd="Y"  s anaDoctorOrd="Y"
		.e  s anaDoctorOrd="N"
		.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,7)=paidType_"/"_anaDoctorOrd_"/"_LogUserType
		.q:(paidType="Y")&(LogUserType="ANDOCTOR")&(anaDoctorOrd="N") //ck 20100303修改
		.q:(paidType="N")&(LogUserType="ANDOCTOR")&(anaDoctorOrd="Y")
		.s anaNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",49)      	//+ ck091212 麻醉护士收费状态
		.i anaNurseOrd="Y"  s anaNurseOrd="Y"
		.e  s anaNurseOrd="N"
		.q:(paidType="Y")&(LogUserType="ANNURSE")&(anaNurseOrd="N")    //ck 20100303修改
		.q:(paidType="N")&(LogUserType="ANNURSE")&(anaNurseOrd="Y")
		.s opNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",50)       	//+ ck091212 手术护士收费状态
		.i opNurseOrd="Y"  s opNurseOrd="Y"
		.e  s opNurseOrd="N"
		.q:(paidType="Y")&(LogUserType="OPNURSE")&(opNurseOrd="N") //ck 20100303修改
		.q:(paidType="N")&(LogUserType="OPNURSE")&(opNurseOrd="Y")
		.;s tPacuBedId=$P($G(^DHCANOPArrange(opaId)),"^",47)		 	//OPA_PacuBed_Dr	麻醉恢复床
		.;i tPacuBedId'="" s tPacuBed=$p(^DHCANC("OPRoom",tPacuBedId),"^",2)
		.;e  s tPacuBed=""
		.;s PACUInDate=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",6) 	//OPA_PACUInDate	入恢复室日期
		.;i PACUInDate'="" s PACUInDate=$zd(PACUInDate,3)
		.;s PACUInTime=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",7) 	//OPA_PACUInTime	入恢复室时间
		.;i PACUInTime'="" s PACUInTime=$zt(PACUInTime)
		.;s PACUInDateTime=PACUInDate_" "_PACUInTime
		.
		.;i sortOpRoomDesc="" s sortOpRoomDesc=0
		.;i sortOpaSeq<10 s sortOpaSeq=0_sortOpaSeq
		.;s opaSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)	//OPA_SeqNote
		.;s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54)	//OPA_AppLoc_Dr
		.;s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
		.;s tDocArriveTime=$P(^DHCANOPArrange(opaId),"^",46)
		.;i tDocArriveTime'="" s tDocArriveTime=##class(web.DHCANOPCom).ConvertToTime(tDocArriveTime)
		.i opaStatus="F" s DsaCount = DsaCount+1 ;s ^hahah = ^hahah+1
		
}
    s DsaCountO = 0
	f mDate=sdate:1:edate	d
	.s mWLId=""
	.f  s mWLId=$o(^DHCWorkLoad(0,"ORDDATE",mDate,mWLId)) q:mWLId=""  d
	..s mRecCTPDocDr="",mResDocDr="",mRecDoc="",mResDoc="",mPatType="",mTarNums="",mRecDoc=""
	..s mPaadmDr=$p(^DHCWorkLoad(mWLId),"^",12)	///	就诊号
    ..q:$g(mPaadmDr)=""
	..q:'$d(^PAADM(mPaadmDr))
	..s ItemOrdDR= $p(^DHCWorkLoad(mWLId),"^",2)    ///医嘱项
	..s mPatType = $p(^DHCWorkLoad(mWLId),"^",4)	///病人类型
	..q:mPatType'="O"
	..s mTarNums=$p(^DHCWorkLoad(mWLId),"^",15)		///	医嘱数量
	..;根据医嘱项，获取医嘱项代码
	..s Item = $$GetArcInfoByDr^HERPBONUSCOMMON(ItemOrdDR)
    ..i $P(Item,"^",1)= "A03319" s DsaCountO = DsaCountO+mTarNums 
 ;w DsaCount,!
 ;w DsaCountO,!
 s DsaCount = DsaCount+DsaCountO
 &sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode in ('0600380'))
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	  values('0600380','DSA','88','介入室',:Year, :sMonth,:DsaCount,getdate(), 0,0,:MethodDr))
 
 q 0
}

/// 药占比
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).MedicProportion("2014-07-26","2014-08-25",11)
ClassMethod MedicProportion(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
 n (mSDate,mEDate,MethodDr)		
 s temp = ..GetDepKPIKJYWSRExecute(mSDate,mEDate,"I",MethodDr)
 ;;药占比只算住院的，不算门诊和急诊
 ;s temp = ..GetDepKPIKJYWSRExecute(mSDate,mEDate,"O,E",MethodDr)
 q 0
}

/// 用于计算药占比（别的组的代码）
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).GetDepKPIKJYWSRExecute("2014-07-26","2014-08-25","I")
ClassMethod GetDepKPIKJYWSRExecute(startDate As %String, endDate As %String, pattype As %String, MethodDr As %String) As %String
{
	n (startDate,endDate,pattype,MethodDr)
	
	;s ^hahah = startDate_"++"_endDate_"++"_dept_"++"_kpiCodeStrZb_"++"_type_"++"_pattype_"++"_hospid_"++"_kdstr
	;2014-10-16++2014-11-21++++GetLocFee,GetLocYLFee,GetLocYaoFee,GetLocXYaoFee,GetKJYWFee++D++I++++
	;2014-10-16++2014-11-21++++GetLocFee,GetLocYLFee,GetLocYaoFee,GetLocXYaoFee,GetKJYWFee++D++O,E++++
	;++2014-11-21++2014-11-21++++GetLocFee,GetLocYLFee,GetLocYaoFee,GetLocXYaoFee,GetKJYWFee++D++O,E++++
    s dept = ""
    s hospid= ""
    s kdstr = ""
    s type ="D"
    s kpiCodeStrZb ="GetLocFee,GetLocYLFee,GetLocYaoFee,GetLocXYaoFee,GetKJYWFee"
	q:startDate="" 
	q:endDate=""
	q:type="" 
    q:pattype="" 
    s Year=$p(endDate,"-",1)
    s Month=$p(endDate,"-",2)
    s YearMonth=Year_"-"_Month
    s sMonth="M"_Month
    ;s kdstr="193,406,1040,1041,1042"
    &sql(DELETE FROM dhc_bonus_subs.BonusSubExpendCollect WHERE BonusYear =:Year AND BonusPeriod =:sMonth AND ExpendItemCode in ('0200060'))
    k ^temp($j)
	i pattype="I" s pattypeNa="住院"
	i $F(","_"O,E"_",",","_pattype_",")'=0   s pattypeNa="门诊"
	s monIdStr=""
 	i type="D"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	i type="M"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	i type="Q"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudQd(startDate,endDate)
	i type="Y"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudYear(startDate,endDate)
	
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	
 	q:monIdStr="" 1
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1 1
	q:'$d(data) 1
	
	d SplitMulitData10(dept,,.deptData)
	d SplitMulitData10(pattype,,.pattypeData)
	d SplitMulitData10(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData10(hospid,,.hospidData)
	d SplitMulitData10(kdstr,,.kdstrData)
	
	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId="",value=0
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimIdnod=0
	..f  s dimIdnod=$o(data(monId,kpiId,dimIdnod)) q:dimIdnod=""  d
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))

	...s value=+$g(data(monId,kpiId,dimIdnod))
    ...s dimId=$p(dimIdnod,",",1)
    ...s jztype=$p(dimIdnod,",",2) 
    ...i $li(^DHCWL.MKPI.MKPID(kpiId),2)'="GetKJYWFee"  s kdloc=$p(dimIdnod,",",3)  ;2013-04-17
    ...i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetKJYWFee"  s kdloc=$p(dimIdnod,",",7)  ;2013-04-17 
   	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimId="") 
	...q:(dept'="")&&('$d(deptData(dimId)))
	...//判断类型是否为所选类型
	...q:(pattype'="")&&(jztype="") 
	...q:(pattype'="")&&('$d(pattypeData(jztype)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimId)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   

	...i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocFee" s ^temp($j,dimId,"GetLocFee")=$g(^temp($j,dimId,"GetLocFee"))+value 	//总收入
	...i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocYLFee" s ^temp($j,dimId,"GetLocYLFee")=$g(^temp($j,dimId,"GetLocYLFee"))+value	//医疗收入
	...i (kdstr="" && ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocYaoFee")) s ^temp($j,dimId,"GetLocYaoFee")=$g(^temp($j,dimId,"GetLocYaoFee"))+value	//药品收入  ;2013-04-17 麻醉科开单的不算
	...i (kdstr="" && ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocXYaoFee"))  s ^temp($j,dimId,"GetLocXYaoFee")=$g(^temp($j,dimId,"GetLocXYaoFee"))+value //西药收入  ;2013-04-17 麻醉科开单的不算
	...i (kdstr="" && ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetKJYWFee")) s ^temp($j,dimId,"GetKJYWFee")=$g(^temp($j,dimId,"GetKJYWFee"))+value //抗菌药物收入  ;2013-04-17 麻醉科开单的不算
    ...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocYaoFee")) s ^temp($j,dimId,"GetLocYaoFee")=$g(^temp($j,dimId,"GetLocYaoFee"))+value	//药品收入  ;2013-04-17 麻醉科开单的不算
	...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocXYaoFee"))  s ^temp($j,dimId,"GetLocXYaoFee")=$g(^temp($j,dimId,"GetLocXYaoFee"))+value //西药收入  ;2013-04-17 麻醉科开单的不算
	...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetKJYWFee")) s ^temp($j,dimId,"GetKJYWFee")=$g(^temp($j,dimId,"GetKJYWFee"))+value //抗菌药物收入  ;2013-04-17 麻醉科开单的不算
	...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")'=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocYaoFee")) s ^temp($j,dimId,"GetLocYaoFeeMZ")=$g(^temp($j,dimId,"GetLocYaoFeeMZ"))+value	//药品收入  ;2013-04-17 麻醉科开单
	...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")'=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocXYaoFee"))  s ^temp($j,dimId,"GetLocXYaoFeeMZ")=$g(^temp($j,dimId,"GetLocXYaoFeeMZ"))+value //西药收入  ;2013-04-17 麻醉科开单
	...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")'=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetKJYWFee")) s ^temp($j,dimId,"GetKJYWFeeMZ")=$g(^temp($j,dimId,"GetKJYWFeeMZ"))+value //抗菌药物收入  ;2013-04-17 麻醉科开单


    s dimId=0 f  s dimId=$o(^temp($j,dimId)) q:dimId=""  d
    .s ZSR=$g(^temp($j,dimId,"GetLocFee")) q:ZSR=0
    .s YLSR=$g(^temp($j,dimId,"GetLocYLFee"))
    .s YPSR=$g(^temp($j,dimId,"GetLocYaoFee"))
    .s XYSR=$g(^temp($j,dimId,"GetLocXYaoFee"))
    .s KJYWSR=$g(^temp($j,dimId,"GetKJYWFee"))
    .s MZYPSR=$g(^temp($j,dimId,"GetLocYaoFeeMZ"))
    .s MZKJYWSR=$g(^temp($j,dimId,"GetKJYWFeeMZ"))
    .s MedicPortion = YPSR/ZSR
    .d OutPutRow10
     ;药占比YPSR/ZSR
    k ^temp($j)
	;0200060^药占比率实际值
	q 0
OutPutRow10
    i $d(^CTLOC(dimId))  d  
    .s dimDesc1=$P($G(^CTLOC(dimId)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    . &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values('0200060','药占比率实际值',:dimId,:dimDesc,:Year,:sMonth,:MedicPortion,getdate(), 0,0,:MethodDr))
    ;w dimId,dimDesc,pattypeNa,ZSR,YLSR,YPSR,MZYPSR,XYSR,KJYWSR,MZKJYWSR,hospna,!
	;s Data=$lb(dimId,dimDesc,pattypeNa,ZSR,YLSR,YPSR,MZYPSR,XYSR,KJYWSR,MZKJYWSR,hospna)
    ;s ^CacheTemp(repid,ind)=Data 
 	;s ind=ind+1
	q

SplitMulitData10(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

/// 抗菌药物使用统计
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).PatAntiDrugInfo("2014-07-01","2014-08-07",11)
ClassMethod PatAntiDrugInfo(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
 n (mSDate,mEDate,MethodDr)	
 s Year=$p(mEDate,"-",1)
 s Month=$p(mEDate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 
 k ^TMPDHCBONUS("KJYWSY") 	
 d ..GetPatAntiDrugInfo(mSDate,mEDate)
 ;^TMPDHCBONUS("KJYWSY","总人数",)
 
 &sql(delete from dhc_bonus_subs.BonusSubExpendCollect  where BonusYear=:Year and BonusPeriod=:sMonth AND ExpendItemCode='0200070')
 ///插入中西药收入
 s dept = ""
 f  s dept = $O(^TMPDHCBONUS("KJYWSY","总人数",dept)) q:dept=""  d
 .s RS = $G(^TMPDHCBONUS("KJYWSY","总人数",dept))
 .s KJ = $G(^TMPDHCBONUS("KJYWSY","抗菌药物使用",dept))
 .i (RS'=0)&(RS'="") s BL = KJ/RS
 .s ResDesc = $P(^CTLOC(dept),"^",1)
 .&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	values('0200070','抗生素使用实际值',:dept,:ResDesc,:Year, :sMonth,:BL,getdate(), 0,0,:MethodDr))
 q 0
}

//抗菌药物使用统计

//别的组代码

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatAntiDrugInfo","2014-07-01","2014-08-07","I","","")	

//w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).GetPatAntiDrugInfo("2014-07-01","2014-08-07")

ClassMethod GetPatAntiDrugInfo(SDate As %String, EDate As %String) As %String
{
	n (SDate,EDate)

   
   s pattype= "I" 
   s hospid = "" 
   s deptid = ""
   
    q:SDate="" 
 	q:EDate="" 
 	q:pattype="" 
    
    k ^temp($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	d SplitMulitData2(deptid,,.deptidData)
	d SplitMulitData2(hospid,,.hospidData)
	
	f DisDate=SDate:1:EDate d
	.s ts="",PADRowid=0 
	.i pattype="I" d
	..f  s PADRowid=$o(^DHCWLPADI(0,"DisDate",DisDate,PADRowid)) q:PADRowid=""  d
	...s admdr=$p(^DHCWLPADI(PADRowid),"^",1)    ;PAADMDR
    ...s admtype=$p(^DHCWLPADI(PADRowid),"^",2)    ;类型
    ...q:$F(","_pattype_",",","_admtype_",")=0  
    ...s admdate=$p(^DHCWLPADI(PADRowid),"^",3)  ;入院日期
    ...;s disdate=$p(^DHCWLPADI(PADRowid),"^",4) ;出院日期
    ...s dept=$p(^DHCWLPADI(PADRowid),"^",5)  ;出院科室
    ...//判断科室是否为所选科室
    ...q:(deptid'="")&&(dept="")  ;20130313add
	...q:(deptid'="")&&('$d(deptidData(dept))) ;20130313add
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dept)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="")  
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    ...s AntiFlag=$p(^DHCWLPADI(PADRowid),"^",9)  ;q:AntiFlag'=1 ;抗菌药物使用标志
    ...s AntiDDD=$p(^DHCWLPADI(PADRowid),"^",12)  ;抗菌药物总DDD值
    ...s OperHealLeve=$p(^DHCWLPADI(PADRowid),"^",26) ;q:OperHealLeve'=1 ;主手术切口愈合等级
    ...s OperPreTime=$p(^DHCWLPADI(PADRowid),"^",27) ;q:OperPreTime'=1 ;术前预防使用抗菌药物时间
    ...s OperConTime=$p(^DHCWLPADI(PADRowid),"^",28) ;q:OperConTime'=1 ;手术预防使用抗菌药物持续时间
    ...s EtiExaFlag=$p(^DHCWLPADI(PADRowid),"^",29) ;病原学检查标志
    ...s IsMedAnti=$p(^DHCWLPADI(PADRowid),"^",30)  ;基本治疗使用标志
    
    ...s SpMedAnti=$p(^DHCWLPADI(PADRowid),"^",32)  ;特殊抗菌药物治疗使用标志
    ...s SpAntFlag=$p(^DHCWLPADI(PADRowid),"^",17)  ;特殊抗菌药物使用标志
    ...s SpAntDDD=$p(^DHCWLPADI(PADRowid),"^",20)  ;特殊抗菌药物总DDD值
    
    ...s LimMedAnti=$p(^DHCWLPADI(PADRowid),"^",31)  ;限制抗菌药物治疗使用标志
    ...s LimAntFlag=$p(^DHCWLPADI(PADRowid),"^",33)  ;限制抗菌药物使用标志
    ...s LimAntDDD=$p(^DHCWLPADI(PADRowid),"^",34)  ;限制抗菌药物总DDD值
    ...s OperPre2h=$p(^DHCWLPADI(PADRowid),"^",35)  ;I类切口手术预防使用抗菌药物在术前0.5-2h内给药
    ...s ^temp($j,"总人数",dept)=$g(^temp($j,"总人数",dept))+1
    ...i (AntiFlag="1")  s ^temp($j,"抗菌药物使用",dept)=$g(^temp($j,"抗菌药物使用",dept))+1
    ...i ((AntiFlag="1") && (SpAntFlag="1"))  s ^temp($j,"特殊使用抗菌药物",dept)=$g(^temp($j,"特殊使用抗菌药物",dept))+1
    ...i ((AntiFlag="1") && (LimAntFlag="1"))  s ^temp($j,"限制使用抗菌药物",dept)=$g(^temp($j,"限制使用抗菌药物",dept))+1
    ...i ((AntiFlag="1")  && (IsMedAnti="1") && (SpMedAnti="1"))  s ^temp($j,"特殊使用抗菌药物治疗",dept)=$g(^temp($j,"特殊使用抗菌药物治疗",dept))+1  ;2013-01-22 lxc add 
    ...i ((AntiFlag="1")  && (IsMedAnti="1") && (LimMedAnti="1"))  s ^temp($j,"限制使用抗菌药物治疗",dept)=$g(^temp($j,"限制使用抗菌药物治疗",dept))+1 ;2013-01-22 lxc add 
    ...i (OperHealLeve="1") s ^temp($j,"1类切口总",dept)=$g(^temp($j,"1类切口总",dept))+1
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (+OperPreTime'=0)) s ^temp($j,"1类切口预防",dept)=$g(^temp($j,"1类切口预防",dept))+1
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (OperConTime="1") && (+OperPreTime'=0)) s ^temp($j,"1类切口预防抗菌药物时间≤24h",dept)=$g(^temp($j,"1类切口预防抗菌药物时间≤24h",dept))+1   ;2013-01-22 lxc xiugai 
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (OperPre2h="1") && (+OperPreTime'=0)) s ^temp($j,"1类切口预防抗菌药物时间在0.5-2h内",dept)=$g(^temp($j,"1类切口预防抗菌药物时间在0.5-2h内",dept))+1 ;2013-01-22 lxc xiugai   
    ...i ((AntiFlag="1") && (IsMedAnti="1")) s ^temp($j,"同期使用抗菌药物总例数",dept)=$g(^temp($j,"同期使用抗菌药物总例数",dept))+1
    ...i ((AntiFlag="1") && (EtiExaFlag="1") && (IsMedAnti="1")) s ^temp($j,"病原学检查送检例数",dept)=$g(^temp($j,"病原学检查送检例数",dept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (SpAntFlag="1") && (EtiExaFlag="1") && (SpMedAnti="1")) s ^temp($j,"特殊使用抗菌药物患者病原学检查送检例数",dept)=$g(^temp($j,"特殊使用抗菌药物患者病原学检查送检例数",dept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (LimAntFlag="1") && (EtiExaFlag="1") && (LimMedAnti="1")) s ^temp($j,"限制使用抗菌药物患者病原学检查送检例数",dept)=$g(^temp($j,"限制使用抗菌药物患者病原学检查送检例数",dept))+1
    
    ...s ^temp($j,"DDD",dept)=$g(^temp($j,"DDD",dept))+AntiDDD
    ...i ((AntiFlag="1") && (SpAntFlag="1")) s ^temp($j,"特殊使用抗菌药物DDD",dept)=$g(^temp($j,"特殊使用抗菌药物DDD",dept))+SpAntDDD
    ...s ts=DisDate-admdate
    ...i ts=0 s ts=1
    ...s ^temp($j,"人天数",dept)=$g(^temp($j,"人天数",dept))+ts
	
	...i ((AntiFlag="1") && (+OperPreTime'=0)) s ^temp($j,"预防使用抗菌药物",dept)=$g(^temp($j,"预防使用抗菌药物",dept))+1  ;2013-04-25 lxc add 潍坊项目
	...i ((AntiFlag="1") && (OperPre2h="1") && (+OperPreTime'=0)) s ^temp($j,"预防抗菌药物时间在0.5-2h内",dept)=$g(^temp($j,"预防抗菌药物时间在0.5-2h内",dept))+1 ;2013-04-25 lxc add 潍坊项目
	
	.e  d
	..f  s PADRowid=$o(^DHCWLPADI(0,"AdmDate",DisDate,PADRowid)) q:PADRowid=""  d
    ...s admdr=$p(^DHCWLPADI(PADRowid),"^",1)    ;PAADMDR
    ...s admtype=$p(^DHCWLPADI(PADRowid),"^",2)    ;类型
    ...q:$F(","_pattype_",",","_admtype_",")=0  
    ...s admdate=$p(^DHCWLPADI(PADRowid),"^",3)  ;入院日期
    ...;s disdate=$p(^DHCWLPADI(PADRowid),"^",4) ;出院日期
    ...s dept=$p(^DHCWLPADI(PADRowid),"^",5) ;出院科室
	...//判断科室是否为所选科室
    ...q:(deptid'="")&&(dept="")  ;20130313add
	...q:(deptid'="")&&('$d(deptidData(dept))) ;20130313add
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dept)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...;s hospna=$P($G(^CT("HOSP",hospid)),"^",2)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   

    ...s AntiFlag=$p(^DHCWLPADI(PADRowid),"^",9) ;抗菌药物使用标志
    ...s AntiDDD=$p(^DHCWLPADI(PADRowid),"^",12)  ;抗菌药物总DDD值
    ...s OperHealLeve=$p(^DHCWLPADI(PADRowid),"^",26) ;主手术切口愈合等级
    ...s OperPreTime=$p(^DHCWLPADI(PADRowid),"^",27) ;术前预防使用抗菌药物时间
    ...s OperConTime=$p(^DHCWLPADI(PADRowid),"^",28) ;手术预防使用抗菌药物持续时间
    ...s EtiExaFlag=$p(^DHCWLPADI(PADRowid),"^",29) ;病原学检查标志
    ...s IsMedAnti=$p(^DHCWLPADI(PADRowid),"^",30)  ;基本治疗使用标志
    
    ...s SpMedAnti=$p(^DHCWLPADI(PADRowid),"^",32)  ;特殊抗菌药物治疗使用标志
    ...s SpAntFlag=$p(^DHCWLPADI(PADRowid),"^",17)  ;特殊抗菌药物使用标志
    ...s SpAntDDD=$p(^DHCWLPADI(PADRowid),"^",20)  ;特殊抗菌药物总DDD值
    
    ...s LimMedAnti=$p(^DHCWLPADI(PADRowid),"^",31)  ;限制抗菌药物治疗使用标志
    ...s LimAntFlag=$p(^DHCWLPADI(PADRowid),"^",33)  ;限制抗菌药物使用标志
    ...s LimAntDDD=$p(^DHCWLPADI(PADRowid),"^",34)  ;限制抗菌药物总DDD值
    ...s OperPre2h=$p(^DHCWLPADI(PADRowid),"^",35)  ;I类切口手术预防使用抗菌药物在术前0.5-2h内给药
    
    ...s ^temp($j,"总人数",dept)=$g(^temp($j,"总人数",dept))+1
    ...i (AntiFlag="1")  s ^temp($j,"抗菌药物使用",dept)=$g(^temp($j,"抗菌药物使用",dept))+1
    ...i ((AntiFlag="1") && (SpAntFlag="1"))  s ^temp($j,"特殊使用抗菌药物",dept)=$g(^temp($j,"特殊使用抗菌药物",dept))+1
    ...i ((AntiFlag="1") && (LimAntFlag="1"))  s ^temp($j,"限制使用抗菌药物",dept)=$g(^temp($j,"限制使用抗菌药物",dept))+1
    ...i ((AntiFlag="1")  && (IsMedAnti="1") && (SpMedAnti="1"))  s ^temp($j,"特殊使用抗菌药物治疗",dept)=$g(^temp($j,"特殊使用抗菌药物治疗",dept))+1  ;2013-01-22 lxc add 
    ...i ((AntiFlag="1")  && (IsMedAnti="1") && (LimMedAnti="1"))  s ^temp($j,"限制使用抗菌药物治疗",dept)=$g(^temp($j,"限制使用抗菌药物治疗",dept))+1 ;2013-01-22 lxc add 
    ...i (OperHealLeve="1") s ^temp($j,"1类切口总",dept)=$g(^temp($j,"1类切口总",dept))+1
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (+OperPreTime'=0)) s ^temp($j,"1类切口预防",dept)=$g(^temp($j,"1类切口预防",dept))+1
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (OperConTime="1") && (+OperPreTime'=0)) s ^temp($j,"1类切口预防抗菌药物时间≤24h",dept)=$g(^temp($j,"1类切口预防抗菌药物时间≤24h",dept))+1   ;2013-01-22 lxc xiugai 
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (OperPre2h="1") && (+OperPreTime'=0)) s ^temp($j,"1类切口预防抗菌药物时间在0.5-2h内",dept)=$g(^temp($j,"1类切口预防抗菌药物时间在0.5-2h内",dept))+1 ;2013-01-22 lxc xiugai   
    ...i ((AntiFlag="1") && (IsMedAnti="1")) s ^temp($j,"同期使用抗菌药物总例数",dept)=$g(^temp($j,"同期使用抗菌药物总例数",dept))+1
    ...i ((AntiFlag="1") && (EtiExaFlag="1") && (IsMedAnti="1")) s ^temp($j,"病原学检查送检例数",dept)=$g(^temp($j,"病原学检查送检例数",dept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (SpAntFlag="1") && (EtiExaFlag="1") && (SpMedAnti="1")) s ^temp($j,"特殊使用抗菌药物患者病原学检查送检例数",dept)=$g(^temp($j,"特殊使用抗菌药物患者病原学检查送检例数",dept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (LimAntFlag="1") && (EtiExaFlag="1") && (LimMedAnti="1")) s ^temp($j,"限制使用抗菌药物患者病原学检查送检例数",dept)=$g(^temp($j,"限制使用抗菌药物患者病原学检查送检例数",dept))+1
    
    ...s ^temp($j,"DDD",dept)=$g(^temp($j,"DDD",dept))+AntiDDD
    ...i ((AntiFlag="1") && (SpAntFlag="1")) s ^temp($j,"特殊使用抗菌药物DDD",dept)=$g(^temp($j,"特殊使用抗菌药物DDD",dept))+SpAntDDD
    ...s ts=DisDate-admdate
    ...i ts=0 s ts=1
    ...s ^temp($j,"人天数",dept)=$g(^temp($j,"人天数",dept))+ts
    
    ...i ((AntiFlag="1") && (+OperPreTime'=0)) s ^temp($j,"预防使用抗菌药物",dept)=$g(^temp($j,"预防使用抗菌药物",dept))+1  ;2013-04-25 lxc add 潍坊项目
	...i ((AntiFlag="1") && (OperPre2h="1") && (+OperPreTime'=0)) s ^temp($j,"预防抗菌药物时间在0.5-2h内",dept)=$g(^temp($j,"预防抗菌药物时间在0.5-2h内",dept))+1 ;2013-04-25 lxc add 潍坊项目
	   
    s type=0 f  s type=$o(^temp($j,type)) q:type=""  d
    .s dept=0 f  s dept=$o(^temp($j,type,dept)) q:dept=""  d
    ..s outdata=$g(^temp($j,type,dept)) 
    ..d OutputRow2
    
    k ^temp($j)
 	q $$$OK	
OutputRow2
    i $d(^CTLOC(dept)) d
    .s hos=$P($G(^CTLOC(dept)),"^",22)
    .s patdesc1=$p(^CTLOC(dept),"^",2) ;病人科室desc
    .i patdesc1 [ "-" s patdesc=$p(patdesc1,"-",2)
    .e  s patdesc=patdesc1
    ;w type,dept,patdesc,outdata,hospna,!
    s ^TMPDHCBONUS("KJYWSY",type,dept) =$G(^TMPDHCBONUS("KJYWSY",type,dept))+outdata
    ;s Data=$lb(type,dept,patdesc,outdata,hospna)
    ;s ^CacheTemp(repid,ind)=Data
 	;s ind=ind+1
SplitMulitData2(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 	
	q 0
}

/// 获取接转病人人次
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).ContactPatient("2014-07-26","2014-08-25",3)
ClassMethod ContactPatient(mSDate As %String, mEDate As %String, MethodDr As %String) As %String
{
 n (mSDate,mEDate,MethodDr)
	
 s Year=$p(mEDate,"-",1)
 s Month=$p(mEDate,"-",2)
 s YM=Year_Month
 s YearMonth=Year_"-"_Month
 s sMonth="M"_Month
 s mSDate=$zdh(mSDate,3)
 s mEDate=$zdh(mEDate,3)
 s jzbrrc = 0
 s jzbrrc = ..QueryBookByDateLoc(mSDate,mEDate)
 ;w jzbrrc,!
 &sql(delete from dhc_bonus_subs.BonusSubExpendCollect  where BonusYear=:Year and BonusPeriod=:sMonth AND ExpendItemCode='0300070')
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect(ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 	values('0300070','接转病人人次','54','急诊科门诊',:Year, :sMonth,:jzbrrc,getdate(), 0,0,:MethodDr))
 
 q 0
}

//获取接转病人人次

// 别的组代码 类web.DHCDocIPBookingCtl   函数QueryBookByDateLoc 

//w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).QueryBookByDateLoc("63469","63469")

ClassMethod QueryBookByDateLoc(FromDate As %String, ToDate As %String) As %String
{
	n (FromDate, ToDate)
	s (CtLoc, State,RegNo, PacWardId,DocCreateBookId) = ""
	s OrderOrCreateDate=1
	;, CtLoc As %String, State As %String, RegNo As %String = "", PacWardId As %String = "", DocCreateBookId As %String
	//DocCreateBookId As %String,OrderOrCreateDate As %String
	;s ^hahah = 0 ;FromDate_"++"_ToDate_"++"_CtLoc_"++"_State_"++"_RegNo_"++"_PacWardId_"++"_DocCreateBookId_"++"_OrderOrCreateDate
	s Count =0
    ;63469++63469++++++++++++1
	s ^Tempzong=FromDate_"^"_ToDate_"^"_RegNo
	if (((FromDate'="")&&(ToDate'=""))){
	//quit:(FromDate="")!(ToDate="") $$$OK
	set RowID = ""
	set tmpDate = ""
    Set repid=$I(^CacheTemp)
	s ind=1
	set:FromDate["/" FromDate = $zdh(FromDate, 4)
	set:ToDate["/" ToDate = $zdh(ToDate, 4)
	if (+OrderOrCreateDate=1){
	for tmpDate=FromDate:1:ToDate
	{
		set RowID = ""
		while 1
		{ 
		   
			set RowID = $o(^DHCDocIPBK(0,"BookingDate", tmpDate, RowID))
			quit:RowID=""
			set strData = $g(^DHCDocIPBK(RowID))
			if (DocCreateBookId'="") set UsserId=$p(^DHCDocIPBK(RowID),"^",6) q:UsserId'=DocCreateBookId
			continue:($p(strData,"^",8)'=State)&(State'="") //状态校验
			//set IP =$g(^PAADM(+$p(strData,"^",3)))
			//set IPLocID = $p(IP, "^", 4)
			//continue:(IPLocID'=CtLoc)&(CtLoc'="") //Location校验
			s patientId=$p(strData,"^",1)
			continue:patientId=""
			s patientNo=$P($G(^PAPER(patientId,"PAT",1)),"^",1)
			
			continue:(RegNo'=patientNo)&(RegNo'="")
			continue:($p(strData,"^",11)'=PacWardId)&(PacWardId'="")&($p(strData,"^",11)'="")
			s ctLocStr=""
			i PacWardId'="" d
			.s PacWardCTLoc=$P($G(^PAWARD(PacWardId)),"^",5)
			.i PacWardCTLoc'="" d
			..s ctLocId="" f  s ctLocId=$O(^CTLOC(PacWardCTLoc,"LINK",0,"Loc",ctLocId)) q:ctLocId=""  d
			...i ctLocStr="" s ctLocStr=ctLocId
			...e  s ctLocStr=ctLocStr_"^"_ctLocId
			s isPacWardLink=1
			i (ctLocStr'="")&($p(strData,"^",13)'="") d
			.s linkNum=$L(ctLocStr,"^")
			.f iii=1:1:linkNum d
			..i $P(ctLocStr,"^",iii)=$p(strData,"^",13) s isPacWardLink=0
			continue:(PacWardId'="")&isPacWardLink
			//continue:(ctLocStr'="")&($p(strData,"^",13)'="")&($P(ctLocStr,$p(strData,"^",13))="")
			continue:($p(strData,"^",13)'=CtLoc)&(CtLoc'="")&(CtLoc'="115")
			set ^CacheTemp(repid, ind) = $$BuildQueryBookInfo(RowID,patientId)
			;s tem=$$BuildQueryBookInfo(RowID,patientId)
			s Count = Count+$$BuildQueryBookInfo(RowID,patientId)
			set ind = ind + 1
			}
		}
	}
	/*
	if (+OrderOrCreateDate=2)
	{
		for tmpDate=FromDate:1:ToDate
		{set CreateTime=0 f  set CreateTime= $o(^DHCDocIPBK(0,"CreateDateTimeState",tmpDate,CreateTime)) q:CreateTime=""  d 
			.set CurrentStateID=0 f  set CurrentStateID= $o(^DHCDocIPBK(0,"CreateDateTimeState",tmpDate,CreateTime,CurrentStateID)) q:CurrentStateID=""  d
			..set RowID="" f  set RowID= $o(^DHCDocIPBK(0,"CreateDateTimeState",tmpDate,CreateTime,CurrentStateID,RowID)) q:RowID=""  d
			...quit:RowID=""
			...set strData = $g(^DHCDocIPBK(RowID))
			...if (DocCreateBookId'="") set UsserId=$p(^DHCDocIPBK(RowID),"^",6) q:UsserId'=DocCreateBookId
			...continue:($p(strData,"^",8)'=State)&(State'="") //状态校验
			...//set IP =$g(^PAADM(+$p(strData,"^",3)))
			...//set IPLocID = $p(IP, "^", 4)
			...//continue:(IPLocID'=CtLoc)&(CtLoc'="") //Location校验
			...s patientId=$p(strData,"^",1)
			...continue:patientId=""
			...s patientNo=$P($G(^PAPER(patientId,"PAT",1)),"^",1)
			...continue:(RegNo'=patientNo)&(RegNo'="")
			...continue:($p(strData,"^",11)'=PacWardId)&(PacWardId'="")&($p(strData,"^",11)'="")
			...s ctLocStr=""
			...i PacWardId'="" d
			....s PacWardCTLoc=$P($G(^PAWARD(PacWardId)),"^",5)
			....i PacWardCTLoc'="" d
			.....s ctLocId="" f  s ctLocId=$O(^CTLOC(PacWardCTLoc,"LINK",0,"Loc",ctLocId)) q:ctLocId=""  d
			......i ctLocStr="" s ctLocStr=ctLocId
			......e  s ctLocStr=ctLocStr_"^"_ctLocId
			...s isPacWardLink=1
			...i (ctLocStr'="")&($p(strData,"^",13)'="") d
			....s linkNum=$L(ctLocStr,"^")
			....f iii=1:1:linkNum d
			.....i $P(ctLocStr,"^",iii)=$p(strData,"^",13) s isPacWardLink=0
			...continue:(PacWardId'="")&isPacWardLink
			...//continue:(ctLocStr'="")&($p(strData,"^",13)'="")&($P(ctLocStr,$p(strData,"^",13))="")
			...continue:($p(strData,"^",13)'=CtLoc)&(CtLoc'="")&(CtLoc'="115")
			...set ^CacheTemp(repid, ind) = $$BuildQueryBookInfo(RowID,patientId)
			...set ind = ind + 1
		
			}
		}
		*/
	}
 else
	{	
		quit:RegNo="" 
			set RowID="" f  set RowID= $o(^DHCDocIPBK(RowID)) q:RowID=""  d
			.set strData = $g(^DHCDocIPBK(RowID))
			.if (DocCreateBookId'="") set UsserId=$p(^DHCDocIPBK(RowID),"^",6) q:UsserId'=DocCreateBookId
			.q:($p(strData,"^",8)'=State)&(State'="") //状态校验
			.//set IP =$g(^PAADM(+$p(strData,"^",3)))
			.//set IPLocID = $p(IP, "^", 4)
			.//continue:(IPLocID'=CtLoc)&(CtLoc'="") //Location校验
			.s patientId=$p(strData,"^",1)
			.q:patientId=""
			.s patientNo=$P($G(^PAPER(patientId,"PAT",1)),"^",1)
			.q:(RegNo'=patientNo)&(RegNo'="")
			.q:($p(strData,"^",11)'=PacWardId)&(PacWardId'="")&($p(strData,"^",11)'="")
			.s ctLocStr=""
			.i PacWardId'="" d
			..s PacWardCTLoc=$P($G(^PAWARD(PacWardId)),"^",5)
			..i PacWardCTLoc'="" d
			...s ctLocId="" f  s ctLocId=$O(^CTLOC(PacWardCTLoc,"LINK",0,"Loc",ctLocId)) q:ctLocId=""  d
			....i ctLocStr="" s ctLocStr=ctLocId
			....e  s ctLocStr=ctLocStr_"^"_ctLocId
			.s isPacWardLink=1
			.i (ctLocStr'="")&($p(strData,"^",13)'="") d
			..s linkNum=$L(ctLocStr,"^")
			..f iii=1:1:linkNum d
			..i $P(ctLocStr,"^",iii)=$p(strData,"^",13) s isPacWardLink=0
			.q:(PacWardId'="")&isPacWardLink
			.//continue:(ctLocStr'="")&($p(strData,"^",13)'="")&($P(ctLocStr,$p(strData,"^",13))="")
			.q:($p(strData,"^",13)'=CtLoc)&(CtLoc'="")&(CtLoc'="115")
			.set ^CacheTemp(repid, ind) = $$BuildQueryBookInfo(RowID,patientId)
			.;d $$BuildQueryBookInfo(RowID,patientId)
			.set ind = ind + 1
		}
		
	;Set qHandle=$lb(0,repid,0)
	Quit Count
BuildQueryBookInfo(BookID,patientId)
	n (BookID,patientId)
	s ^Tempzong=patientId
	set strData = $g(^DHCDocIPBK(BookID))
	//取到预约日期
	set dtBookingDate=$ZD($ZDH($P(##class(web.DHCDocIPBookingCtl).GetIPBookByID(BookID),"^",11),4),3)
	//取得卡号
	
	s patNo=##class(web.DHCDocCommon).GetCardNoByPAPER("LAST","",patientId,"")
	
	set Patient = ##class(web.DHCDocIPBBaseCtl).GetPatInfo(+$p(strData, "^", 1))
	set OP = ##class(web.DHCDocIPBBasePaadmCtl).GetAdmInfo(+$p(strData,"^",2))
	s OPCTLocDesc=""
	if OP'="" d
	.set OPCTLocId=$p($g(^PAADM(+OP)),"^",4) 
	.set OPCTLocDesc=$P($G(^CTLOC(OPCTLocId)),"^",2)
	;w OPCTLocDesc,!
	;i OPCTLocDesc["急诊" s ^hahah = ^hahah+1
	i OPCTLocDesc["急诊" q 1
	/*
	Set IP = ##class(web.DHCDocIPBBasePaadmCtl).GetAdmInfo(+$p(strData,"^",3))
	set Doctor = ##class(web.DHCDocIPBBaseCtl).GetUsrStr(+$p(strData, "^", 7))
	set User = ##class(web.DHCDocIPBBaseCtl).GetUsrStr(+$p(strData, "^", 6))
	set State = $g(^DHCDocIPBDIC(+$p(strData, "^", 8)))
    Set ^temp("DHCDocIPBooking",State)=""
	set DiagnoseID=$p(strData, "^", 14) //add by lxf 2008-11-12
	set data = $lb("")
	set $li(data, 1) = BookID
	set $li(data, 2) = $p(Patient, $c(2), 23)
	set $li(data, 3) = $p(Patient, $c(2), 22)
	set $li(data, 4) = $p(Patient, $c(2), 1)
	set $li(data, 5) = $p(Patient, $c(2), 2)
	set $li(data, 6) = $p(Patient, $c(2), 4)
	set $li(data, 7) = $p(OP, "^", 4)
	//set $li(data, 8) = $p($p(IP, "^", 7),"/",2)
	set ctLocId=$p(strData, "^", 13)
	if ctLocId'="" s ctLocDesc=$P($G(^CTLOC(ctLocId)),"^",2)
	e  s ctLocDesc=""
	set $li(data, 8)=$G(ctLocDesc)
	set $li(data, 9) = $p(IP, "^", 9)
	set $li(data, 10) = $p(Doctor, "/", 3)
	set $li(data, 11) = $p(User, "/", 3)
	set $li(data, 12) = $p(State, "^", 2)
	set $li(data, 13) = $p(Patient, $c(2), 11) //工作单位
	set $li(data, 14) = $p(Patient, $c(2), 18) //地址
	set $li(data, 15) = $p(Patient, $c(2), 5) //身份证号
	set $li(data, 16) = ..GetBookItemByItemCode(BookID, "Days") //与预计住院天数
	;set $li(data, 17) = ..GetBookItemByItemCode(BookID, "Diagnose") //门诊诊断
	i DiagnoseID'="" set $li(data, 17) = ..GetMRDiagnosByID(DiagnoseID) //门诊诊断 modify by lxf 2008-11-12
	set $li(data, 18) = $p(strData, "^", 2)
	set wardId=$p(strData, "^", 11)
	if wardId'="" Set wardDesc=$P($G(^PAWARD(wardId)),"^",2)
	e  set wardDesc=""
	set $li(data, 19) = $G(wardDesc)
	//set $li(data, 20) = $p(strData, "^", 12)
	i wardId'="" d
	.s bedState=..GetPacBedState(wardId)
	.i bedState=0 set $li(data, 20) ="满"
	.e  set $li(data, 20) ="空"
	e  set $li(data, 20) =""
	set $li(data, 21) = $ZD($p(strData, "^", 10),3)
	set $li(data, 22) = ..GetBookItemByItemCode(BookID, "IPDeposit") //预交金
	set $li(data, 23) =dtBookingDate  //预约日期
	set $li(data, 24) =patNo	//卡号
	set $li(data, 25) =OPCTLocDesc //开住院证科室（门诊）
	*/
	quit 0
}

/// 科室直接收入，急诊科需要加上报表入院当天费用中的一部分
/// 这个方法取自于类web.DHCWLGetIPFeeNow  Query web.DHCWLGetIPFeeNow
/// w ##class(dhc.bonus.uinter.UoutPutEPRMRInfo).DHCWLGetIPFeeNow("63440","63440") 2014-09-10
ClassMethod DHCWLGetIPFeeNow(startDate As %String, endDate As %String) As %String
{
 n (startDate,endDate)
 s Count = 0
 k ^TEMPDHCWLKPIDATA("S",$j)
 q:startDate="" 0
 q:endDate="" 0
 ;s startDate=$zdh(startDate,3)
 ;s endDate=$zdh(endDate,3)
 f ordDate=startDate:1:endDate d
 .s mBookID=0  f  s mBookID=$o(^DHCDocIPBK(0,"BookingDate",ordDate,mBookID)) q:(mBookID="")  d
 ..s mBookDoc=$p($g(^DHCDocIPBK(mBookID)),"^",7)
 ..s mAdm=$p($g(^DHCDocIPBK(mBookID)),"^",3)
 ..s mOPAdm=$p($g(^DHCDocIPBK(mBookID)),"^",2)
 ..s mBookLoc=$p($g(^PAADM(mOPAdm)),"^",4)
 ..q:mBookLoc'=54
 ..q:mAdm=""
 ..;w !,mBookDoc_"##"_mBookLoc_"##"_mAdm
 ..s mWLID=0  f  s mWLID=$o(^DHCWorkLoad(0,"ORDDATE",ordDate,mWLID)) q:(mWLID="")  d
 ...q:($p($g(^DHCWorkLoad(mWLID)),"^",12)'=mAdm)
 ...s mTarec=$p(^DHCWorkLoad(mWLID),"^",41)
 ...s mFee=$p(^DHCWorkLoad(mWLID),"^",16)
 ...s ^TEMPDHCWLKPIDATA("S",$j,mBookLoc,mBookDoc,mAdm,mTarec)=$g(^TEMPDHCWLKPIDATA("S",$j,mBookLoc,mBookDoc,mAdm,mTarec))+$g(mFee)
 s mBookLoc=0 f  s mBookLoc=$o(^TEMPDHCWLKPIDATA("S",$j,mBookLoc)) q:mBookLoc=""  d
 .s mLoc=$p($g(^CTLOC(mBookLoc)),"^",1)
 .s mBookDoc=0 f  s mBookDoc=$o(^TEMPDHCWLKPIDATA("S",$j,mBookLoc,mBookDoc)) q:mBookDoc=""  d
 ..s mDoc=$p($g(^SSU("SSUSR",mBookDoc)),"^",2)
 ..s mAdm=0 f  s mAdm=$o(^TEMPDHCWLKPIDATA("S",$j,mBookLoc,mBookDoc,mAdm)) q:mAdm=""  d
 ...s mPapmidr=$p($g(^PAADM(mAdm)),"^",1)
 ...s mWard=$p($g(^PAADM(mAdm)),"^",70)
 ...i mWard'="" s mWarddesc=$p($g(^PAWARD(mWard)),"^",2)
 ...e  s mWarddesc="Null"
 ...s mPatName=$p($g(^PAPER(mPapmidr,"ALL")),"^",1)
 ...s mTarec=0 f  s mTarec=$o(^TEMPDHCWLKPIDATA("S",$j,mBookLoc,mBookDoc,mAdm,mTarec)) q:mTarec=""  d
 ....s TAREC=$p(^DHCTarC("EC",mTarec),"^",2)
 ....s mFee=$g(^TEMPDHCWLKPIDATA("S",$j,mBookLoc,mBookDoc,mAdm,mTarec))
 ....;w mLoc,mWarddesc,mDoc,mPatName,TAREC,mFee,!  ;d OutputRow
 ....i (TAREC["手术")||(TAREC["高压氧舱治疗")||(TAREC["介入手术费")||(TAREC["碎石费") d     
 .....s Count=Count+(mFee*0.5)
 ....i (TAREC["CT费")||(TAREC["超声检查费")||(TAREC["放射")||(TAREC["核磁费")||(TAREC["化验费")||(TAREC["心电图费")||(TAREC["病理费")||(TAREC["肠镜")||(TAREC["胃镜") d     
 .....s Count=Count+(mFee*0.3)

 q Count
}

Storage Default
{
<StreamLocation>^dhc.bonus1BEE.UoutPutEPRMR7FFS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
