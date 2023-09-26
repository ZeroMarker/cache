Class dhc.bonus.uinter.uGetPACSWork Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 说明：采集PACS工作量主接口
/// 作者：zhao liguo
/// 日期：20131115
/// 涉及：
/// 参数：mSDate:开始时间；mEDate：结束时间；sMethodDr：接口方法ID
/// 实例： w ##class(dhc.bonus.uinter.uGetPACSWork).GetPACSMain("2013-11-23","2013-11-26","42")
ClassMethod GetPACSMain(mSDate As %String, mEDate As %String, sMethodDr As %String) As %String
{
	n (mSDate,mEDate,sMethodDr)
	
	;删除重复采集数据
	d ..DeleteItem(mSDate,mEDate,sMethodDr)
	;采集医师报告数量、医师审核数量
	d ..GetPACSYSBG(mSDate,mEDate,sMethodDr)
	;采集技师拍片数量
	d ..GetPACSJSPP(mSDate,mEDate,sMethodDr)
	;;采集护士预约数量
	d ..GetPACSHSYY(mSDate,mEDate,sMethodDr)
	
	k ^BonusPACSWork
	k ^BonusPACSTemp
	
	q 0
}

/// 说明：采集PACS医师报告数量
/// 作者：zhao liguo
/// 日期：20130926
/// 参数：mSDate:开始时间；mEDate：结束时间；sMethodDr：接口方法ID
/// 实例： w ##class(dhc.bonus.uinter.uGetPACSWork).GetPACSYSBG("2013-06-13","2013-06-26","41")
ClassMethod GetPACSYSBG(mSDate As %String, mEDate As %String, sMethodDr As %String) As %String
{
	n (mSDate,mEDate,sMethodDr)
	s MethodDr=sMethodDr
	;s mSDate="2009-01-01"
	;s mEDate="2009-01-03"
	
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s sMonth="M"_Month
	;w mSDate_":"_mEDate,!
	s YearMonth=Year_"-"_Month
	
	s mSDateH=$zdh(mSDate,3)
	s mEDateH=$zdh(mEDate,3)
	
	k ^BonusPACSWork
	s num=0	
	f mDate=mSDateH:1:mEDateH	d
	.s ReportDr=""    
	.f  s ReportDr=$o(^DHCRBStudyi("ReportDate",mDate,ReportDr)) q:ReportDr=""  d
	..s OeordItmDR= $p($G(^DHCRBStudy("Report",ReportDr)),"^",15)	///	医嘱明细项目ID 
	..s MastrDR=$P(OeordItmDR,"||",1)
	..s MastrSub=$P(OeordItmDR,"||",2)
	
	..i OeordItmDR'="" s ItmMastDR= $p($G(^OEORD(MastrDR,"I",MastrSub,1)),"^",2)			//医嘱项目ID
	..s Subscript= $P(ItmMastDR,"||",1)
	..s Version= $P(ItmMastDR,"||",2)
	
	..s ARCIMCode="",ARCIMName=""
	..i ItmMastDR'="" s ARCIMCode=$p(^ARCIM(Subscript,Version,1),"^",1)	//项目编码
	..i ItmMastDR'="" s ARCIMName=$p(^ARCIM(Subscript,Version,1),"^",2)	//项目名称
	..s ItemDesc=ARCIMCode_"^"_ARCIMName
	
	..s ReportDocCode="",ReportDocName=""
	..s ReportDocDR= $p(^DHCRBStudy("Report",ReportDr),"^",8)	///	报告医师
	..i ReportDocDR'="" s ReportDocCode=$p($g(^SSU("SSUSR",ReportDocDR)),"^",1)
	..i ReportDocDR'="" s ReportDocName=$p($g(^SSU("SSUSR",ReportDocDR)),"^",2)
	..s rptDocDesc=ReportDocCode_"^"_ReportDocName
	
	..s VerifyDocCode="",VerifyDocName=""
	..s ReportDate= $p(^DHCRBStudy("Report",ReportDr),"^",9)		///	报告日期
	..s VerifyDocDR= $p(^DHCRBStudy("Report",ReportDr),"^",11)	///	审核医师
	..i VerifyDocDR'="" s VerifyDocCode=$p($g(^SSU("SSUSR",VerifyDocDR)),"^",1)
	..i VerifyDocDR'="" s VerifyDocName=$p($g(^SSU("SSUSR",VerifyDocDR)),"^",2)
	..s VerifyDate= $p(^DHCRBStudy("Report",ReportDr),"^",12)	///	审核日期
	..s vfyDocDesc=VerifyDocCode_"^"_VerifyDocName
	..;i VerifyDocCode="" w "审核医生="_ReportDr_"^"_VerifyDocDR_"完成",!
		
	..i ((ReportDocCode'="") && (ARCIMCode'="")) d
	...s ^BonusPACSWork("YSBG",YearMonth,rptDocDesc,ItemDesc)=$G(^BonusPACSWork("YSBG",YearMonth,rptDocDesc,ItemDesc))+1
	..i ((VerifyDocCode'="") && (ARCIMCode'="")) d
	...s ^BonusPACSWork("YSSH",YearMonth,vfyDocDesc,ItemDesc)=$G(^BonusPACSWork("YSSH",YearMonth,vfyDocDesc,ItemDesc))+1

	
		;;处理重复采集数据重复问题
	;&sql(delete from dhc_bonus_subs.PACSWorkLoadDetail where BonusYear=:Year and BonusPeriod=:sMonth and MethodID=:sMethodDr  )
	;&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:sMethodDr )
	
	k ^BonusPACSTemp
	;---------PACS医师报告数量---------------
	s DocCode=""
	f  s DocCode=$o(^BonusPACSWork("YSBG",YearMonth,DocCode)) q:DocCode=""  d
	.s ItemDESC=""
	.f  s ItemDESC=$o(^BonusPACSWork("YSBG",YearMonth,DocCode,ItemDESC)) q:ItemDESC=""  d
	..s sDocCode=$p(DocCode,"^",1), sDocName=$p(DocCode,"^",2)
	..s ItemCode=$p(ItemDESC,"^",1), ItemName=$p(ItemDESC,"^",2)
	..s sValue= $G(^BonusPACSWork("YSBG",YearMonth,DocCode,ItemDESC))
	..s ItemCode1="05511:报告数量"
	..s ItemName1="报告数量"
	..s excRate=..GetItemRate("PACSYSBG",ItemCode)
	..s ^BonusPACSTemp("YSBG",YearMonth,DocCode)=$g(^BonusPACSTemp("YSBG",YearMonth,DocCode))+(sValue*excRate)
	..;保存PACS工作量明细
	..&sql(insert into dhc_bonus_subs.PACSWorkLoadDetail(
		BonusYear,BonusPeriod,UnitCode,UnitName, ItemCode,ItemName,ItemValue, MethodID, 
		CollectDate, State,UnitType ,CalculateRate,ExecuteRate,BonusTargetCode)
		values(:Year, :sMonth,:sDocCode,:sDocName ,:ItemCode,:ItemName, :sValue,:sMethodDr
		,getdate(),0,4,0,:excRate ,:ItemCode1))	
	
	s DocCode=""
	f  s DocCode=$o(^BonusPACSTemp("YSBG",YearMonth,DocCode)) q:DocCode=""  d
	.s sDocCode=$p(DocCode,"^",1), sDocName=$p(DocCode,"^",2)
	.s sValue= $G(^BonusPACSTemp("YSBG",YearMonth,DocCode))
	.s ItemCode="05511"
	.s ItemName="报告数量"
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(
		BonusYear, BonusPeriod,BonusUnitCode, BonusUnitName , ExpendItemCode,ExpenItemName
		,ItemValue,InterLocMethodID ,CollectDate, State, UnitType) 
		values(:Year, :sMonth,:sDocCode, :sDocName , :ItemCode,:ItemName
		,:sValue,:sMethodDr ,getdate(), 0, 4))	
		
	;--------------PACS医师审核数量----------------
	s DocCode=""
	f  s DocCode=$o(^BonusPACSWork("YSSH",YearMonth,DocCode)) q:DocCode=""  d
	.s ItemDESC=""
	.f  s ItemDESC=$o(^BonusPACSWork("YSSH",YearMonth,DocCode,ItemDESC)) q:ItemDESC=""  d
	..s sDocCode=$p(DocCode,"^",1), sDocName=$p(DocCode,"^",2)
	..s ItemCode=$p(ItemDESC,"^",1), ItemName=$p(ItemDESC,"^",2)
	..s sValue= $G(^BonusPACSWork("YSSH",YearMonth,DocCode,ItemDESC))
	..s ItemCode1="05512:审核数量"
	..s ItemName1="审核数量"
	..s excRate=..GetItemRate("PACSYSSH",ItemCode)
	..s ^BonusPACSTemp("YSSH",YearMonth,DocCode)=$g(^BonusPACSTemp("YSSH",YearMonth,DocCode))+(sValue*excRate)
	..;保存PACS工作量明细
	..&sql(insert into dhc_bonus_subs.PACSWorkLoadDetail(
		BonusYear,BonusPeriod,UnitCode,UnitName, ItemCode,ItemName,ItemValue, MethodID, 
		CollectDate, State,UnitType ,CalculateRate,ExecuteRate,BonusTargetCode)
		values(:Year, :sMonth,:sDocCode,:sDocName ,:ItemCode,:ItemName, :sValue,:sMethodDr
		,getdate(),0,4,0,:excRate ,:ItemCode1))	
	
	s DocCode=""
	f  s DocCode=$o(^BonusPACSTemp("YSSH",YearMonth,DocCode)) q:DocCode=""  d
	.s sDocCode=$p(DocCode,"^",1), sDocName=$p(DocCode,"^",2)
	.s sValue= $G(^BonusPACSTemp("YSSH",YearMonth,DocCode))
	.s ItemCode="05512"
	.s ItemName="审核数量"
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(
		BonusYear, BonusPeriod,BonusUnitCode, BonusUnitName , ExpendItemCode,ExpenItemName
		,ItemValue,InterLocMethodID ,CollectDate, State, UnitType) 
		values(:Year, :sMonth,:sDocCode, :sDocName , :ItemCode,:ItemName
		,:sValue,:sMethodDr ,getdate(), 0, 4))	
	 
	q 0
}

/// 说明：采集PACS技师拍片数量
/// 作者：zhao liguo
/// 日期：20131115
/// 涉及：DHCRB_StudyDesc检查息表
/// 参数：mSDate:开始时间；mEDate：结束时间；sMethodDr：接口方法ID
/// 实例： w ##class(dhc.bonus.uinter.uGetPACSWork).GetPACSJSPP("2013-11-23","2013-11-26","42")
ClassMethod GetPACSJSPP(mSDate As %String, mEDate As %String, sMethodDr As %String) As %String
{
	n (mSDate,mEDate,sMethodDr)
	s MethodDr=sMethodDr
	;s mSDate="2009-01-01"
	;s mEDate="2009-01-03"
	
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s sMonth="M"_Month
	;w mSDate_":"_mEDate,!
	s YearMonth=Year_"-"_Month
	
	s mSDateH=$zdh(mSDate,3)
	s mEDateH=$zdh(mEDate,3)
	
	k ^BonusPACSWork
	
	
	s num=0	
	f mDate=mSDateH:1:mEDateH d
	.s ReportDr=""
	.;w mSDate _"^"_ mDate,!
	.f  s ReportDr=$o(^DHCRBStudyi("StudyEndDate",mDate,ReportDr)) q:ReportDr=""  d
	..;w "ReportDr:="_ReportDr,!
	..s ARCIMDesc=""
	..s StudyNo= $p(^DHCRBStudy("StudyDesc",ReportDr),"^",1)	///	检查号
	..q:$E(StudyNo,1,3)'="RIS"
	..;q:$E(StudyNo,1,30)'="RIS47050"
	..;w "StudyNo=" _mDate_"^"_StudyNo,!
	..s RegRowid=""
	..s RegRowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,RegRowid)) // DHCRB_RegInfo.%ID
	..s MainDocCode="",AssiDocCode="",MainDocDesc="",AssiDocDesc=""
	..s MainDocCode= $p(^DHCRBStudy("StudyDesc",ReportDr),"^",30)	///	主操作技师医师代码
	..s AssiDocCode= $p(^DHCRBStudy("StudyDesc",ReportDr),"^",31)	///	辅操作技师医师代码
	..s MainDocDR="",AssiDocDR=""
	..i MainDocCode'="" d
	...s MainDocDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",MainDocCode,MainDocDR))
	..i AssiDocCode'="" d
	...s AssiDocDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",AssiDocCode,AssiDocDR))
	..i MainDocDR'="" s MainDocName=$p($g(^SSU("SSUSR",MainDocDR)),"^",2)
	..i MainDocDR'="" s MainDocDesc=MainDocCode_"^"_MainDocName
	..i AssiDocDR'="" s AssiDocName=$p($g(^SSU("SSUSR",AssiDocDR)),"^",2)
	..i AssiDocDR'="" s AssiDocDesc=AssiDocCode_"^"_AssiDocName
	..s ReportDr1=""
	..i StudyNo'="" d
	...s ReportDr1=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,ReportDr1))
	...s OeordItmDR=""
	...i ReportDr1'="" d
	....s OeordItmDR= $p($g(^DHCRBStudy("Report",ReportDr1)),"^",15)	///	医嘱明细项目ID 
	...s MastrDR=$P(OeordItmDR,"||",1)
	...s MastrSub=$P(OeordItmDR,"||",2)
	...i OeordItmDR'="" s ItmMastDR= $p($g(^OEORD(MastrDR,"I",MastrSub,1)),"^",2)
	...s Subscript= $P(ItmMastDR,"||",1)
	...s Version= $P(ItmMastDR,"||",2)
	...s ARCIMCode="",ARCIMName=""
	...i ItmMastDR'="" s ARCIMCode=$p(^ARCIM(Subscript,Version,1),"^",1)	//项目编码
	...i ItmMastDR'="" s ARCIMName=$p(^ARCIM(Subscript,Version,1),"^",2)	//项目名称
	...i ARCIMCode'="" s ARCIMDesc=ARCIMCode _"^"_ARCIMName
	...;w "项目=ARCIMDesc,!
	..i ((MainDocDesc'="")&&(ARCIMDesc'="")) d ;主操作技师
	...s ^BonusPACSWork("JSPP",YearMonth,MainDocDesc,ARCIMDesc)=$G(^BonusPACSWork("JSPP",YearMonth,MainDocDesc,ARCIMDesc))+1
	..;i AssiDocDesc'="" d ;辅助操作技师
	...;s ^BonusPACSWork("JSPP",YearMonth,AssiDocDesc,ARCIMDesc)=$G(^BonusPACSWork("JSPP",YearMonth,AssiDocDesc,ARCIMDesc))+1

	;处理重复采集数据重复问题
	;&sql(delete from dhc_bonus_subs.PACSWorkLoadDetail 
	;	where BonusYear=:Year and BonusPeriod=:sMonth and MethodID=:sMethodDr  )
	
	k ^BonusPACSTemp
	s DocCode=""
	f  s DocCode=$o(^BonusPACSWork("JSPP",YearMonth,DocCode)) q:DocCode=""  d
	.s ItemDESC=""
	.f  s ItemDESC=$o(^BonusPACSWork("JSPP",YearMonth,DocCode,ItemDESC)) q:ItemDESC=""  d
	..s sDocCode=$p(DocCode,"^",1), sDocName=$p(DocCode,"^",2)
	..s ItemCode=$p(ItemDESC,"^",1), ItemName=$p(ItemDESC,"^",2)
	..s sValue= $G(^BonusPACSWork("JSPP",YearMonth,DocCode,ItemDESC))
	..s ItemCode1="05513:RIS拍片数量"
	..s ItemName1="拍片数量"
	..s excRate=..GetItemRate("PACSJSPP",ItemCode)
	..s ^BonusPACSTemp("JSPP",YearMonth,DocCode)=$g(^BonusPACSTemp("JSPP",YearMonth,DocCode))+(sValue*excRate)
	..;保存PACS工作量明细
	..&sql(insert into dhc_bonus_subs.PACSWorkLoadDetail(
		BonusYear,BonusPeriod,UnitCode,UnitName, ItemCode,ItemName,ItemValue, MethodID, 
		CollectDate, State,UnitType ,CalculateRate,ExecuteRate,BonusTargetCode)
		values(:Year, :sMonth,:sDocCode,:sDocName ,:ItemCode,:ItemName, :sValue,:sMethodDr
		,getdate(),0,4,0,:excRate ,:ItemCode1))	
	
	;处理重复采集数据重复问题
	;&sql(delete from dhc_bonus_subs.BonusSubExpendCollect 
	;	where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:sMethodDr )

	s DocCode=""
	f  s DocCode=$o(^BonusPACSTemp("JSPP",YearMonth,DocCode)) q:DocCode=""  d
	.s sDocCode=$p(DocCode,"^",1), sDocName=$p(DocCode,"^",2)
	.s sValue= $G(^BonusPACSTemp("JSPP",YearMonth,DocCode))
	.s ItemCode="05513"
	.s ItemName="拍片数量"
	
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(
		BonusYear, BonusPeriod,BonusUnitCode, BonusUnitName , ExpendItemCode,ExpenItemName
		,ItemValue,InterLocMethodID ,CollectDate, State, UnitType) 
		values(:Year, :sMonth,:sDocCode, :sDocName , :ItemCode,:ItemName
		,:sValue,:sMethodDr ,getdate(), 0, 4))	
		
	q 0
}

/// 说明：采集PACS护士预约数量
/// 作者：zhao liguo
/// 日期：20130926
/// 参数：mSDate:开始时间；mEDate：结束时间；sMethodDr：接口方法ID
/// 实例： w ##class(dhc.bonus.uinter.uGetPACSWork).GetPACSHSYY("2013-11-01","2013-11-30","42")
ClassMethod GetPACSHSYY(mSDate As %String, mEDate As %String, sMethodDr As %String) As %String
{
	n (mSDate,mEDate,sMethodDr)
	s MethodDr=sMethodDr
	;s mSDate="2009-01-01"
	;s mEDate="2009-01-03"
		
	s Year=$p(mSDate,"-",1)
	s Month=$p(mSDate,"-",2)
	s YM=Year_Month
	s sMonth="M"_Month
	s YearMonth=Year_"-"_Month
	
	s mSDateH=$zdh(mSDate,3)
	s mEDateH=$zdh(mEDate,3)
	
	k ^BonusPACSWork
	s num=0	
	f mDate=mSDateH:1:mEDateH	d
	.s ReportDr=""
	.f  s ReportDr=$o(^DHCPACRegInfoi("RegDate",mDate,ReportDr)) q:ReportDr=""  d
	..s StudyNo= $p(^DHCPACRegInfo(ReportDr),"^",2)	///	检验号
	..q:StudyNo=""
	..s DeptFlag=$E(StudyNo,1,2)
	..s HSDocDR= $p(^DHCPACRegInfo(ReportDr),"^",7)	///	预约护士
	..q:HSDocDR=1
	..s HSDocCode="",HSDocName="",HSDocDesc=""
	..i HSDocDR'="" d
	...s HSDocCode=$p($g(^SSU("SSUSR",HSDocDR)),"^",1) ;人员编码
	...s HSDocName=$p($g(^SSU("SSUSR",HSDocDR)),"^",2) ;人员名称
	...s HSDocDesc=HSDocCode_"^"_HSDocName
	...i ((DeptFlag="EC")||(DeptFlag="PS")||(DeptFlag="RI")) d
	....;w HSDocDR _":"_YearMonth_":"_DeptFlag_":"_HSDocDesc,!
	....s ^BonusPACSWork("HSYY",YearMonth,HSDocDesc,DeptFlag)=$G(^BonusPACSWork("HSYY",YearMonth,HSDocDesc,DeptFlag))+1
	
	;处理重复采集数据重复问题
	;&sql(delete from dhc_bonus_subs.PACSWorkLoadDetail 
	;	where BonusYear=:Year and BonusPeriod=:sMonth and MethodID=:sMethodDr  )
	
	k ^BonusPACSTemp
	s DocCode=""
	f  s DocCode=$o(^BonusPACSWork("HSYY",YearMonth,DocCode)) q:DocCode=""  d
	.s DeptFlag=""
	.f  s DeptFlag=$o(^BonusPACSWork("HSYY",YearMonth,DocCode,DeptFlag)) q:DeptFlag=""  d
	..s sDocCode=$p(DocCode,"^",1), sDocName=$p(DocCode,"^",2)
	..s sValue= $G(^BonusPACSWork("HSYY",YearMonth,DocCode,DeptFlag))
	..s ItemCode=DeptFlag
	..s ItemName=""
	..i DeptFlag="EC" s ItemName="心电脑电预约"
	..i DeptFlag="PS" s ItemName="病理预约"
	..i DeptFlag="RI" s ItemName="放射预约"
	
	..s ItemCode1="05514:预约数量"
	..s ItemName1="预约数量"
	..s excRate=1
	..s ^BonusPACSTemp("HSYY",YearMonth,DocCode)=$g(^BonusPACSTemp("HSYY",YearMonth,DocCode))+(sValue*excRate)
	..;保存PACS工作量明细
	..&sql(insert into dhc_bonus_subs.PACSWorkLoadDetail(
		BonusYear,BonusPeriod,UnitCode,UnitName, ItemCode,ItemName,ItemValue, MethodID, 
		CollectDate, State,UnitType ,CalculateRate,ExecuteRate,BonusTargetCode)
		values(:Year, :sMonth,:sDocCode,:sDocName ,:ItemCode,:ItemName, :sValue,:sMethodDr
		,getdate(),0,4,0,:excRate ,:ItemCode1))	
	
	;处理重复采集数据重复问题
	;&sql(delete from dhc_bonus_subs.BonusSubExpendCollect 
	;	where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:sMethodDr )

	s DocCode=""
	f  s DocCode=$o(^BonusPACSTemp("HSYY",YearMonth,DocCode)) q:DocCode=""  d
	.s sDocCode=$p(DocCode,"^",1), sDocName=$p(DocCode,"^",2)
	.s sValue= $G(^BonusPACSTemp("HSYY",YearMonth,DocCode))
	.s ItemCode="05514"
	.s ItemName="预约数量"
	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect(
		BonusYear, BonusPeriod,BonusUnitCode, BonusUnitName , ExpendItemCode,ExpenItemName
		,ItemValue,InterLocMethodID ,CollectDate, State, UnitType) 
		values(:Year, :sMonth,:sDocCode, :sDocName , :ItemCode,:ItemName
		,:sValue,:sMethodDr ,getdate(), 0, 4))	
	q 0
}

/// 说明：得到项目系数
/// 作者：zhao liguo
/// 日期：20131216
/// 参数：ItemType:项目类型；ItemCode：项目编码
/// 实例： w ##class(dhc.bonus.uinter.uGetPACSWork).GetItemRate("PACSJSPP","JC002013")
ClassMethod GetItemRate(ItemType As %String, ItemCode As %String) As %String
{
	n (ItemType,ItemCode)
	
	s GRowID=0
	&sql(select %ID INTO :GRowID from dhc_bonus_subs.BonusSubDeptGroup where DeptGroupCode=:ItemType)
	s GRowID="G"_GRowID
	s rate=0
	
	s DCode=""
	f  s DCode=$o(^dhcbsSubExpendRateI("sbItem",GRowID,DCode)) q:DCode=""  d
	.s itemID=$E(DCode,2,10)
	.s iCode=""
	.s iCode= $LIST(^dhcbsSubItemD(itemID),2)
	.i iCode=ItemCode d
	..s rowID=""
	..s rowID=$o(^dhcbsSubExpendRateI("sbItem",GRowID,DCode,rowID))
	..s rate=$LIST(^dhcbsSubExpendRateD(rowID),6)

	q rate
}

/// 说明：得到项目系数
/// 作者：zhao liguo
/// 日期：20131216
/// 参数：ItemType:项目类型；ItemCode：项目编码
/// 实例： w ##class(dhc.bonus.uinter.uGetPACSWork).GetItemRate("PACSJSPP","JC002013")
ClassMethod DeleteItem(mSDate As %String, mEDate As %String, sMethodDr As %String) As %String
{
	n (mSDate,mEDate,sMethodDr)
		
	s sYear=$p(mSDate,"-",1)
	s sMonth="M"_$p(mSDate,"-",2)
	
	;处理重复采集数据重复问题
	&sql(delete from dhc_bonus_subs.PACSWorkLoadDetail 
		where BonusYear=:sYear and BonusPeriod=:sMonth and MethodID=:sMethodDr  )

	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect 
		where BonusYear=:sYear and BonusPeriod=:sMonth and InterLocMethodID=:sMethodDr )

	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetPACSWorkS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
