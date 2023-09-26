Class dhc.bonus.umodule.uBonusIncomeCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// others:w ##class(dhc.bonus.umodule.uBonusIncomeCollect).List("","",0,10,"2016-03","","","","2")
ClassMethod List(sortField, sortDir, start, limit, yearmonth, deptcode, Excutedeptcode, tariffType, sickType) As %String
{
	n (sortField, sortDir, start, limit,yearmonth,deptcode,Excutedeptcode,tariffType,sickType)
	
	;w sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_yearmonth_"^"_deptcode_"^"_Excutedeptcode_"^"_tariffType_"^"_sickType,!
	
	q:yearmonth="" 0
	s year=$p(yearmonth,"-",1)
	s bonusyear=year_"-"_$p(yearmonth,"-",2)

	s month="M"_$p(yearmonth,"-",2)
	
	s sqlStr=""
	_" SELECT a.%ID rowid ,BonusYear,BonusPeriod,b.ItemCode,b.ItemName  ,c.BonusUnitName MakeBillDeptCode , d.BonusUnitName ExecuteDeptCode ,e.BonusUnitName SickDeptCode  , SickType , IncomeMoney , adjustMoney , State , a.UpdateDate "
	_" ,ChiefDoctorCode,MakeBillDoctorCode,ExecuteDoctorCode "
	_" FROM dhc_bonus_module.BonusIncomeCollect a,dhc_bonus_module.BonusIncItem b"
	_" ,dhc_bonus_data.bonusUnit c,dhc_bonus_data.bonusUnit d,dhc_bonus_data.bonusUnit e"
	_" where a.IncomeItemCode=*b.ItemCode AND a.MakeBillDeptCode=*c.bonusUnitCode AND a.ExecuteDeptCode=*d.bonusUnitCode AND a.SickDeptCode=e.bonusUnitCode "
	_" and BonusYear='"_year_"' and BonusPeriod='"_month_"'"


	s whereStr=""
	i tariffType'="" s whereStr=whereStr_" and IncomeItemCode='"_tariffType_"'"
	i deptcode'="" s whereStr=whereStr_" and MakeBillDeptCode='"_deptcode_"'"
	i Excutedeptcode'="" s whereStr=whereStr_" and ExecuteDeptCode='"_Excutedeptcode_"'"
	i sickType'="" s whereStr=whereStr_" and sickType='"_sickType_"'"
	
	s sqlStr=sqlStr_whereStr
	k ^zlgtm
	s ^zlgtm=sqlStr
	;w ^zlgtm
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^incomeitemcode^bonusyear^bonusperiod^makebilldeptcode^executedeptcode^sickdeptcode^sicktype^chiefdoctorcode^makebilldoctorcode^executedoctorcode^incomemoney^adjustMoney^state^updatedate"
	While(result.Next())
	{
	s bonussubincomecollectid= result.Data("rowid")
	s incomeitemcode= result.Data("ItemCode")_":"_result.Data("ItemName")

	//s bonusyear= result.Data("BonusYear")
	s bonusperiod= result.Data("BonusPeriod")
	
	
	s makebilldeptcode= result.Data("MakeBillDeptCode")
	s executedeptcode= result.Data("ExecuteDeptCode")
	s sickdeptcode= result.Data("SickDeptCode")

	s sicktype= result.Data("SickType")
	i sicktype=1 s sicktype="门诊"
	i sicktype=2 s sicktype="住院"
	i sicktype=3 s sicktype="急诊"
	i sicktype=4 s sicktype="体检"
	i sicktype=9 s sicktype="其它" ;
	s chiefdoctorcode= result.Data("ChiefDoctorCode")
	s makebilldoctorcode= result.Data("MakeBillDoctorCode")
	
	s executedoctorcode= result.Data("ExecuteDoctorCode")
	
	s incomemoney= result.Data("IncomeMoney")
	s incomemoney=$fn(incomemoney,",","2")
	s adjustMoney= result.Data("adjustMoney")
	  
	s adjustMoney=$fn(adjustMoney,",","2")
	s state= result.Data("State")
	i state=0 s state="采集完成"
	i state=1 s state="计算完成"
	
	s updatedate= result.Data("UpdateDate")
	;s updatedate=$zd(updatedate,3)

	s temp=bonussubincomecollectid_"^"_incomeitemcode_"^"_bonusyear_"^"_bonusperiod_"^"_makebilldeptcode_"^"_executedeptcode_"^"_sickdeptcode_"^"_sicktype_"^"_chiefdoctorcode_"^"_makebilldoctorcode_"^"_executedoctorcode_"^"_incomemoney_"^"_adjustMoney_"^"_state_"^"_updatedate
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// 作者：刘壮
/// 日期：2016-06-05
/// 功能：编辑”调整金额“
/// 参数：BonusSubIncomeCollectID, adjustmoney
/// w ##class(dhc.bonus.umodule.uBonusIncomeCollect).Update("64070","1") 
ClassMethod Update(rowid, adjustMoney) As %String
{
	n (rowid, adjustMoney)
	&sql(update dhc_bonus_module.BonusIncomeCollect set adjustMoney = :adjustMoney where BonusSubIncomeCollectID = :rowid)
	q 0
}

/// 作者：刘壮
/// 日期：2016-08-10
/// 功能：编辑”调整金额“
/// 参数：yearmonth, incomeitemcode, makebilldeptcode, sickdeptcode, sicktype1, chiefdoctorcode, makebilldoctorcode, executedeptcode, updatedate, adjustmoney
/// w ##class(dhc.bonus.umodule.uBonusIncomeCollect).add("2016","","","","","","222") 
ClassMethod add(yearmonth, incomeitemcode, makebilldeptcode, sickdeptcode, sicktype1, chiefdoctorcode, makebilldoctorcode, executedeptcode, updatedate, adjustmoney) As %String
{
	n (yearmonth,incomeitemcode,makebilldeptcode,sickdeptcode,sicktype1,chiefdoctorcode,makebilldoctorcode,executedeptcode,updatedate, adjustmoney)
	q:yearmonth="" 0
	s year=$p(yearmonth,"-",1)

	s month="M"_$p(yearmonth,"-",2)
	&sql(insert into dhc_bonus_module.BonusIncomeCollect (BonusYear,IncomeItemCode,BonusPeriod,MakeBillDeptCode,SickDeptCode,SickType,ChiefDoctorCode,MakeBillDoctorCode,ExecuteDeptCode,IncomeMoney,State,UpdateDate, adjustMoney,FileName)
	values(:year,:incomeitemcode,:month,:makebilldeptcode,:sickdeptcode,:sicktype1,:chiefdoctorcode,:makebilldoctorcode,:executedeptcode,0,0, Getdate(),:adjustmoney,'新增'))
	q SQLCODE
}

/// others:w ##class(dhc.bonus.umodule.uBonusIncomeCollect).collect("2014-01-01","2014-01-30","传染科门诊","04")
/// others:w ##class(dhc.bonus.umodule.uBonusIncomeCollect).collect("2014-03-01","2014-03-31","传染科门诊","04")
ClassMethod collect(startdate, enddate, deptcode, tariffType) As %String
{
	n (startdate,enddate, deptcode, tariffType)
	s year=$p(startdate,"-",1)
	s month=""_$p(startdate,"-",2)
	//w month,!
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	s updatedate=$p($h,",",1)

	s delStr="DELETE FROM dhc_bonus_module.BonusIncomeCollect"
	_" WHERE BonusYear='"_year_"' AND BonusPeriod='"_month _"'"
	s whereStr=""
	i tariffType'="" s whereStr=whereStr_" and IncomeItemCode='"_tariffType_"'"
	i deptcode'="" s whereStr=whereStr_" and MakeBillDeptCode='"_deptcode_"'"
	s delStr= delStr_whereStr
	//w delStr,!
	
	
	s sqlStr="INSERT INTO dhc_bonus_module.BonusIncomeCollect (IncomeItemCode, BonusYear, BonusPeriod, MakeBillDeptCode, ExecuteDeptCode, SickDeptCode, SickType,  IncomeMoney, State, UpdateDate)"
	_" SELECT Dhc_workload.WorkLoad_TarEC_Dr,"_year_",'"_month_"',dhc_workload.WorkLoad_PatDep_DR AS makebilldeptcode,dhc_workload.WorkLoad_RecDep_DR AS executedeptcode,dhc_workload. WorkLoad_ResDep_DR,decode(Dhc_workload.WorkLoad_Type,'O',1,'I',2,'E',3,'H',4,9),sum(WorkLoad_TotalPrice),0 state,"_updatedate
	_"  FROM DHC_WorkLoad WHERE WorkLoad_FlagDate between "_startdate_" and "_enddate
	s whereStr=""
	i deptcode'="" s whereStr=whereStr_" and dhc_workload.WorkLoad_PatDep_DR='"_deptcode_"'"
	i tariffType'="" s whereStr=whereStr_" and Dhc_workload.WorkLoad_TarEC_Dr='"_tariffType_"'"
	s groupStr=" group by WorkLoad_TarEC_Dr,WorkLoad_PatDep_DR,WorkLoad_RecDep_DR,WorkLoad_ResDep_DR,WorkLoad_Type "
	s sqlStr=sqlStr_whereStr_groupStr
	k ^cwtempAgain
	s ^cwtempAgain=1
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(delStr)
	d result.Execute()
	d result.Close()
	d result.Prepare(sqlStr)
	d result.Execute()
	d result.Close()

 	k json
 
	q 0
}

/// 作者：赵立国
/// 日期：2015-08-19
/// 功能：采集his收入
/// 参数：startdate, enddate
/// others:w ##class(dhc.bonus.umodule.uBonusIncomeCollect).uGetIncCollectYJS("2016-01")
ClassMethod uGetIncCollectYJS(date) As %String
{
	n (date)

	q:date=""	
	s ^zlg11=date
	s Year=$p(date,"-",1)
	s Month=$p(date,"-",2)
	s stDate=Year_"-"_Month_"-"_1
	i Month'=12 d
	.s eMonth=Month+1
	.s mdDate=Year_"-"_eMonth_"-"_1
	.s result=$zdh(mdDate,3)
	.s result=result-1
	.s eDate=$zd(result,3)
	e  i Month=12 d
	.s eYear=Year+1
	.s eMonth=1
	.s mdDate=eYear_"-"_eMonth_"-"_1
	.s result=$zdh(mdDate,3)
	.s result=result-1
	.s eDate=$zd(result,3)

	s BonusPeriod="M"_Month
	s YM=Year_Month
	s mSDate=$zdh(stDate,3)
	s mEDate=$zdh(eDate,3)
	k ^BonusYjsTemp("O")
	k ^BonusYjsTemp("I")
	
	s sMonth="M"_ Month
	s YearMonth=Year _"-" _Month
	k ^cwtemp
	
	&sql(delete from   dhc_bonus_module.BonusIncomeCollect WHERE BonusYear=:Year AND BonusPeriod=:BonusPeriod )
	;处理住院收入
	s num=0	
	f mDate=mSDate:1:mEDate	d
	.s ItemCode=""
	.;w $zd(mDate,3),!
	.s sDate= $zd(mDate,3)
	.f  s ItemCode=$o(^herpinterHisChargeDataII("IncDataI",sDate,ItemCode)) q:ItemCode=""  d
	..;s ItemCode=$tr(ItemCode," ","")
	..s mkDeptCode=""
	..;W "ItemCode="_ItemCode,!
	..f  s mkDeptCode=$o(^herpinterHisChargeDataII("IncDataI",sDate,ItemCode,mkDeptCode)) q:mkDeptCode=""  d
	...s mkDeptCode1=..uGetDetpID(mkDeptCode)
	...s exDeptCode=""
	...f  s exDeptCode=$o(^herpinterHisChargeDataII("IncDataI",sDate,ItemCode,mkDeptCode,exDeptCode)) q:exDeptCode=""  d
	....s exDeptCode1=..uGetDetpID(exDeptCode)
	....i exDeptCode1="999999" d
	.....s ^cwtemp=exDeptCode_"^"_$g(^cwtemp)
	....s skDeptCode=""  
	....f  s skDeptCode=$o(^herpinterHisChargeDataII("IncDataI",sDate,ItemCode,mkDeptCode,exDeptCode,skDeptCode)) q:skDeptCode=""  d
	.....s skDeptCode1=..uGetDetpID(skDeptCode)
	.....s rowid=""
	.....f  s rowid=$o(^herpinterHisChargeDataII("IncDataI",sDate,ItemCode,mkDeptCode,exDeptCode,skDeptCode,rowid)) q:rowid=""  d

	......i rowid'="" d
	.......s IncSum=$li(^herpinterHisChargeDataID(rowid),22)
	.......;w "I="_ItemCode_","_mkDeptCode1_","_exDeptCode1_","_skDeptCode1,!
	.......s ItemCode1=$tr(ItemCode," ","")
	.......s ^BonusYjsTemp("I",ItemCode1,mkDeptCode1,exDeptCode1,skDeptCode1)=$G(^BonusYjsTemp("I",ItemCode1,mkDeptCode1,exDeptCode1,skDeptCode1))+IncSum
	
	;处理门诊收入
	s num=0	
	f mDate=mSDate:1:mEDate	d
	.s ItemCode=""
	.;w $zd(mDate,3),!
	.s sDate= $zd(mDate,3) 
	.f  s ItemCode=$o(^herpinterHisChargeDataOI("IncDataO",sDate,ItemCode)) q:ItemCode=""  d
	..;s ItemCode=$tr(ItemCode," ","")
	..s mkDeptCode=""
	..;W "ItemCode="_ItemCode,!
	..f  s mkDeptCode=$o(^herpinterHisChargeDataOI("IncDataO",sDate,ItemCode,mkDeptCode)) q:mkDeptCode=""  d
	...s mkDeptCode1=..uGetDetpID(mkDeptCode)
	...s exDeptCode=""
	...f  s exDeptCode=$o(^herpinterHisChargeDataOI("IncDataO",sDate,ItemCode,mkDeptCode,exDeptCode)) q:exDeptCode=""  d
	....s exDeptCode1=..uGetDetpID(exDeptCode)
	....i exDeptCode1="999999" d
	.....s ^cwtemp=exDeptCode_"^"_$g(^cwtemp)
	....s skDeptCode=""
	....f  s skDeptCode=$o(^herpinterHisChargeDataOI("IncDataO",sDate,ItemCode,mkDeptCode,exDeptCode,skDeptCode)) q:skDeptCode=""  d
	.....s skDeptCode1=..uGetDetpID(skDeptCode)
	.....s rowid=""
	.....f  s rowid=$o(^herpinterHisChargeDataOI("IncDataO",sDate,ItemCode,mkDeptCode,exDeptCode,skDeptCode,rowid)) q:rowid=""  d
	......i rowid'="" d
	.......s IncSum=$li(^herpinterHisChargeDataOD(rowid),22)
	.......s ItemCode1=$tr(ItemCode," ","")
	.......s ^BonusYjsTemp("O",ItemCode1,mkDeptCode1,exDeptCode1,skDeptCode1)=$G(^BonusYjsTemp("O",ItemCode1,mkDeptCode1,exDeptCode1,skDeptCode1))+IncSum
	
	.......;i ((exDeptCode1="101121800") ||(exDeptCode1="101221800")) d
	........;i (ItemCode1'="1")&&(ItemCode1'="2") d
	.........;w "o="_ ItemCode_","_mkDeptCode1_","_exDeptCode1_","_skDeptCode1_","_IncSum,!
	
	
	
	s dataType=""
	f  s dataType=$o(^BonusYjsTemp(dataType)) q:dataType=""   d
	.s ItemCode=""
	.f  s ItemCode=$o(^BonusYjsTemp(dataType,ItemCode)) q:ItemCode=""  d
	..s mkDeptCode=""
	..;W "ItemCode="_ItemCode,!
	..f  s mkDeptCode=$o(^BonusYjsTemp(dataType,ItemCode,mkDeptCode)) q:mkDeptCode=""  d
	...s exDeptCode=""
	...f  s exDeptCode=$o(^BonusYjsTemp(dataType,ItemCode,mkDeptCode,exDeptCode)) q:exDeptCode=""  d
	....s skDeptCode=""
	....f  s skDeptCode=$o(^BonusYjsTemp(dataType,ItemCode,mkDeptCode,exDeptCode,skDeptCode)) q:skDeptCode=""  d
	.....s sValue=$G(^BonusYjsTemp(dataType,ItemCode,mkDeptCode,exDeptCode,skDeptCode))
	.....i ((exDeptCode="101121800") ||(exDeptCode="101221800")) d
	......i ((dataType="I")&&(ItemCode'="1")) d
	.......;w "Insert="_dataType_","_ItemCode_","_mkDeptCode_","_exDeptCode_","_skDeptCode_","_sValue,!
	.....i dataType="O" s SickType=1
	.....i dataType="I" s SickType=2
	.....&sql(INSERT INTO dhc_bonus_module.BonusIncomeCollect (IncomeItemCode, BonusYear, BonusPeriod, MakeBillDeptCode, ExecuteDeptCode, SickDeptCode, SickType, IncomeMoney, State, UpdateDate, operator)	values(:ItemCode, :Year, :BonusPeriod, :mkDeptCode, :exDeptCode, :skDeptCode, :SickType,:sValue, 0, Getdate(), "system"))


	q 0
}

/// 作者：赵立国
/// 日期：2015-08-20
/// 功能：转换His科室编码为标准的9位科室编码
/// 参数：DeptCode:his科室编码
/// others:w ##class(dhc.bonus.umodule.uBonusIncomeCollect).uGetDetpID("299")
ClassMethod uGetDetpID(DeptCode) As %String
{
  n (DeptCode)
  q:DeptCode="" "999999999"
  s code0=""
  s DetpName=""
  s UnitDr=""
  s UnitDr=$O(^dhcsyncLocI("Code2Idx",DeptCode,UnitDr))
  ;w "zlg1="_UnitDr,!
  i UnitDr'="" d
  .s code0=$Li(^dhcsyncLocD(UnitDr),22)
  .s DetpName=$Li(^dhcsyncLocD(UnitDr),3)
  
  ;s UnitDr1=""
  ;s UnitDr1=$O(^dhcbsBonusUnitI("BonusUnitCode",code0,UnitDr1))
  i code0="" d
  .s code0="999999"
  
  q code0  ;_":"_DetpName
}

/// description : 查找科室
/// w ##class(dhc.bonus.umodule.uBonusIncomeCollect).getDept(0,15,"CK")
ClassMethod getDept(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT %ID CTLOC_RowID,BonusUnitCode,BonusUnitName FROM dhc_bonus_data.bonusUnit"
	i str'="" s sqlStr = sqlStr_" where BonusUnitCode  LIKE '%"_str_"%'"_" OR BonusUnitName LIKE '%"_str_"%' and IsValid=1"
	d result.Prepare(sqlStr)
	d result.Execute()
    //w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusUnitCode")
		s name = result.Data("BonusUnitName")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// description : 查找病人类别
/// w ##class(dhc.bonus.umodule.uBonusIncomeCollect).getSickType(0,15,"")
ClassMethod getSickType(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT IncomeItemCode ,sickType FROM dhc_bonus_module.BonusIncomeCollect where 1=1 "
	i str'="" s sqlStr = sqlStr_" and  sickType like '%"_str_"%'  "
	d result.Prepare(sqlStr)
	d result.Execute()
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("IncomeItemCode")
		s name = result.Data("sickType")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// description : 查找收费类别
/// w ##class(dhc.bonus.umodule.uBonusIncomeCollect).getIncomeItemType(0,15,"")
ClassMethod getIncomeItemType(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ItemCode ,ItemName FROM dhc_bonus_module.BonusIncItem where 1=1 "
	i str'="" s sqlStr = sqlStr_" and  ItemName like '%"_str_"%'  "
	d result.Prepare(sqlStr)
	d result.Execute()
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("ItemCode")
		s name = result.Data("ItemName")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus866B.uBonusIncom44E4S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
