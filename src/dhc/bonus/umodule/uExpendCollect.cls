Class dhc.bonus.umodule.uExpendCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.bonus.umodule.uExpendCollect).List("","",0,25,"2016-06","","0")
ClassMethod List(sortField, sortDir, start, limit, yearmonth, deptcode, Methord1) As %String
{
		n (sortField, sortDir, start, limit,yearmonth,deptcode,Methord1)
		
		s year=$p(yearmonth,"-",1)
		
	    s month=""_$p(yearmonth,"-",2)
	    s month1="M"_month
	    
	    s sqlStr="select b.Code1 ShowCode, BonusExpendCollectID ,DeptCode,b.Name,BonusYear||'-'||RIGHT(BonusPeriod,2) as yearperiod ,ItemCode,ItemName,AdjustMoney,ItemValue,CollectDate,Operator,"
	    _" CheckDate,CheckMan,a.state,Methord,IsValue,Methord"
	    _" from  dhc_bonus_module.BonusExpendCollect a , dhc_sync_data.Sync_Loc b where 1=1 and  b.Code0=a.DeptCode "
	    i yearmonth'="" s sqlStr=sqlStr_" and BonusYear='"_year_"' and BonusPeriod='"_month1_"'"
	    i deptcode '="" s sqlStr=sqlStr_" and ( b.Code1='"_deptcode_"' or b.Name like '%"_deptcode_"%' ) "
	    i ((Methord1 >0) && (Methord1 <90)) s sqlStr=sqlStr_" and Methord='"_Methord1_"' "
		i ((Methord1 =90)) s sqlStr=sqlStr_" and Methord is null "
	    //i Methord1=0 s sqlStr=sqlStr_" and Methord is not null "
	    k ^cwtemp
	    s ^cwtemp=sqlStr
		;s sqlStr=sqlStr_" order by Methord"
		
		s result=##class(%Library.ResultSet).%New()
		;s ^zlg12=sqlStr
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
			
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		
		s jsonTitle="rowid^ShowCode^deptcode^deptname^yearperiod^itemcode^itemname^itemvalue^adjustmoney^collectdate^"
			_"operator^checkdate^checkman^sstate^IsValue^MethordName"


		While(result.Next())
		{
		    s rowid =result.Data("BonusExpendCollectID")
		    s ShowCode = result.Data("ShowCode")
            s deptcode = result.Data("DeptCode")
            s deptname = result.Data("Name")
       		s yearperiod = result.Data("yearperiod")
			s itemcode =result.Data("ItemCode")    
			s itemname =result.Data("ItemName")         
			s itemvalue =$fn(result.Data("ItemValue"),"",2)
			s adjustmoney =$fn(result.Data("AdjustMoney"),"",2)       
			s collectdate =result.Data("CollectDate")
			s Methord=  result.Data("Methord")			
			i ((collectdate'="") &&(Methord'=4)&&(Methord'="")) s collectdate=$zdt(collectdate,3)
			s operator =result.Data("Operator")
			s checkdate = result.Data("CheckDate")
			i ((checkdate'="") &&(Methord'=4)) s checkdate=$zdt(checkdate,3)
			
			s checkman =result.Data("CheckMan")
			s state =result.Data("state")
		    s IsValue =result.Data("IsValue")
		    
		    i Methord1=0 s MethordName="全部成本数据"
		    i Methord=1 s MethordName="物资管理系统"
		    i Methord=2 s MethordName="人员工资系统"
		    i Methord=3 s MethordName="固定资产系统"
		    i Methord=4 s MethordName="预算报销系统"
		    i Methord1=90 s MethordName="EXCEL手动导入"
		    
			s sstate=""
			i state=0 s sstate="采集完成"
			i state=1 s sstate="审核完成"
			s tmp=rowid_"^"_ShowCode_"^"_deptcode_"^"_deptname_"^"_yearperiod_"^"_itemcode_"^"_itemname_"^"_itemvalue_"^"_adjustmoney_"^"_collectdate_"^"
			_operator_"^"_checkdate_"^"_checkman_"^"_sstate_"^"_IsValue_"^"_MethordName
			
			s count=count+1
			
		
			i (count>start)&(count<=end) d
			.d json.InsertRowData(tmp)
			
		}
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Others: w ##class(dhc.bonus.umodule.uExpendCollect).add("2016-06","100412300",4,01,1,"1")
ClassMethod add(yearmonth, deptname, methordname, itemname, value, usercode) As %String
{
	n (yearmonth,deptname, methordname,itemname, value,usercode)
	
	
	
	q:yearmonth="" 0
	s year=$p(yearmonth,"-",1)
	s datenow=$p($h,",",1)
	s month="M"_$p(yearmonth,"-",2)
	
	i $D(^dhcbsBonusUnitI("BonusUnitCode",deptname)) d
	.s rowid=0
	.s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",deptname,rowid))
	.s BonusUnitname=$LI(^dhcbsBonusUnitD(rowid),3)

	i $D(^dhcbsmdBonusExpendItemI("BonusItemCode",itemname)) d
	.s rowidd=0
	.s rowidd=$O(^dhcbsmdBonusExpendItemI("BonusItemCode",itemname,rowidd))
	.s Bonusitemname=$LI(^dhcbsmdBonusExpendItemD(rowidd),3)

	;w yearmonth_"^"_deptname_"^"_ methordname_"^"_itemname_"^"_value_"^"_usercode_"^"_BonusUnitname_"^"_rowid_"^"_rowidd_"^"_Bonusitemname,!
	
	&sql(insert into dhc_bonus_module.BonusExpendCollect (BonusYear,DeptCode,DeptName,BonusPeriod,Methord,ItemCode,ItemName,ItemValue,State,CollectDate, adjustMoney,FileName,IsValue,Operator)
	values(:year,:deptname,:BonusUnitname,:month,:methordname,:itemname,:Bonusitemname,0,0, :datenow,:value,'新增','Y',:usercode))
	q SQLCODE
}

/// w ##class(dhc.bonus.umodule.uExpendCollect).getDept(0,15,"")
ClassMethod getDept(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT code1 code ,Name FROM dhc_sync_data.Sync_Loc"
	i str'="" s sqlStr = sqlStr_" where Name  LIKE '%"_str_"%' "
	d result.Prepare(sqlStr)
	d result.Execute()
    //w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("code")
		s name = result.Data("Name")
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

/// 查询支出类别
/// 刘壮
/// w ##class(dhc.bonus.umodule.uExpendCollect).getItem(0,15,"")
ClassMethod getItem(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ItemCode,ItemName from dhc_bonus_module.BonusExpendItem where IsLast=1"
	i str'="" s sqlStr = sqlStr_" and ItemName  LIKE '%"_str_"%' "
	d result.Prepare(sqlStr)
	d result.Execute()
    //w sqlStr,!
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

//在这里主要是做一个适配器

/// // w ##class(dhc.bonus.umodule.uExpendCollect).collect("2016-06",4,"demo")
ClassMethod collect(yearmonth, MethodDr, user) As %String
{
	n (yearmonth,MethodDr, user)
	s year=$p(yearmonth,"-",1)
	s sMonth=$p(yearmonth,"-",2)
	s yearmonth=year _"-"_ sMonth
    q:year="" "年度为空"
	q:sMonth="" "月份为空"
    ;d ##class(dhc.bonus.umodule.uiterMain).InterMain(year,month,user,MethodDr)
    
    	s rtn=0
	//取物资系统的工资支出
	i MethodDr=2 d 
	.d ##class(dhc.bonus.umodule.GetHRWage).GetHRWage(year,sMonth,MethodDr,user)
	//取人事系统的物资支出
	i MethodDr=1 d 
	.d ##class(dhc.bonus.umodule.uGetDuraData).GetBonusDura(yearmonth,MethodDr,user)
	
	i MethodDr=3 d 
	.d ##class(dhc.bonus.umodule.GetEquiData).GetEquiData(year,sMonth,MethodDr,user)
	i MethodDr=4 d 
	.d ..uGetExpBudg(year,sMonth,MethodDr,user)
	
	//这里是获得固定资产的数据
	q 0
}

/// 作者：赵立国
/// 日期：2015-08-28
/// 功能：获取科室成本--支出报销
/// 参数：sYear：yyyy, sMonth：MM,userCode:demo
/// 用例: w ##class(dhc.bonus.umodule.uExpendCollect).uGetExpBudg("2015","06","zlg",4)
ClassMethod uGetExpBudg(sYear, sMonth, MethodDr, userCode) As %String
{
	n (sYear, sMonth,userCode,MethodDr)
	
	s mMoth="M"_sMonth
	s bDate=sYear_"-"_sMonth_"-01"
	i sMonth<12  d
	.s mm=sMonth+1
	.s m1=sYear_"-"_mm_"-01"
	.s m2=$zdh(m1,3)-1
	.s eDate=$zd(m2,3)
	e  d
	.s eDate=sYear_"-"_sMonth_"-31"
	
	
	s bDate1=$zdh(bDate,3)
	s eDate1=$zdh(eDate,3)
	s bDate2=$tr(bDate,"-","")
	s eDate2=$tr(eDate,"-","")
	s bDate3="'"_bDate1_"'"
	s eDate3="'"_eDate1_"'"
	;w bDate1_","_eDate1_","_sYear_","_MethodDr,!
	
	&SQL(DELETE FROM  dhc_bonus_module.BonusExpendCollect WHERE Methord=4 AND BonusYear =:sYear AND BonusPeriod=:mMoth)
	
	&SQL(
	insert into dhc_bonus_module.BonusExpendCollect(DeptCode,DeptName,BonusYear,
		BonusPeriod,ItemCode,ItemName,ItemValue,CollectDate,Operator,state,Methord,IsValue)
	select  a.PF_DeptDR->BDEPT_Code, a.PF_DeptDR->BDEPT_Name,:sYear,:mMoth,
	BID_Code ,BID_Name ,b.PF_ActPay ActPay,getdate() CollectDate,:userCode,0 state,:MethodDr,'Y' IsValue
	from herp_budg_data.BudgCtrlPayBillMain a,herp_budg_data.BudgCtrlPayBillDetail b,herp_budg_data.BudgItemDict c 
	where a.BudgCtrlPayBillMainID=b.PF_PayBillDR and b.PF_bItemCode=c.BID_Code and   c.BID_Year=:sYear
 	and PF_BillDate >=:bDate1 and PF_BillDate <=:eDate1 and LEFT(b.PF_PayBillDR->PF_YearMonth,4)=c.BID_Year
 	and (PF_ChkSatte=1 or PF_ChkSatte=3) 
 	
  	UNION all 
   	SELECT a.PayM_DeptDR->BDEPT_Code, a.PayM_DeptDR->BDEPT_Name,:sYear BonusYear,:mMoth BonusPeriod,
	c.BID_Code ,c.BID_Name ,PayD_ActPay ActPay,getdate() CollectDate,:userCode,0 state,4 Methord,'Y' IsValue
    FROM herp_budg_data.BudgPayBillMain a  ,herp_budg_data.BudgPayBillDetail b,herp_budg_data.BudgItemDict c 
	WHERE a.PayM_RowID =b.PayD_PayMDR AND b.PayD_ItemCode =c.BID_Code AND c.BID_Year=:sYear and
   ( (PayM_ChkState=3) or (PayM_ChkState=4)) AND LEFT(PayM_BillCode,8) >=:bDate2 AND LEFT(PayM_BillCode,8) <=:eDate2
 
	
 	)
 	//	group by a.PF_DeptDR->BDEPT_Code,BID_Code
 	// GROUP BY  a.PayM_DeptDR->BDEPT_Code,BID_Code
 	
 q 0
}

//w ##class(dhc.bonus.umodule.uExpendCollect).Update("6647","22","")

ClassMethod Update(rowid, value, IsVlaue) As %String
{
	n (rowid,value,IsVlaue)
	i value'="" d
	.s tabelname="dhc_bonus_module.BonusExpendCollect"
	.s ModiDate=$zd($h,3)
	.s ModiPerson="UnKnown"
	.s TableName="dhc_bonus_module.BonusExpendCollect"
	.s ItemCode=$list(^dhcbsmdBonusExpendCollectD(rowid),6)
	.s ItemName=$list(^dhcbsmdBonusExpendCollectD(rowid),7)
	.s OldValue=$list(^dhcbsmdBonusExpendCollectD(rowid),8)
	.s NewValue=value
	.s ReMark="dhc.bonus.module.bonusexpendcollect.csp"
	.s BonusUnit=$list(^dhcbsmdBonusExpendCollectD(rowid),3)
	.s DataType=2
	.&SQL(insert into   dhc_bonus_logs.BonusModiLog(ModiDate,ModiPerson,TableName,ItemCode,ItemName,OldValue,NewValue,ReMark,BonusUnit,DataType) 
	 VALUES (:ModiDate,:ModiPerson,:TableName,:ItemCode,:ItemName,:OldValue,:NewValue,:ReMark,:BonusUnit,:DataType) ) 
	 
    i IsVlaue'="" d
	.s tabelname="dhc_bonus_module.BonusExpendCollect"
	.s ModiDate=$zd($h,3)
	.s ModiPerson="Unknown"
	.s TableName="dhc_bonus_module.BonusExpendCollect"
	.s ItemCode=$list(^dhcbsmdBonusExpendCollectD(rowid),6)
	.s ItemName=$list(^dhcbsmdBonusExpendCollectD(rowid),7)
	.s OldValue=$list(^dhcbsmdBonusExpendCollectD(rowid),16)
	.s NewValue=IsVlaue
	.s ReMark="dhc.bonus.module.bonusexpendcollect.csp"
	.s BonusUnit=$list(^dhcbsmdBonusExpendCollectD(rowid),3)
	.s DataType=2
	.&SQL(insert into   dhc_bonus_logs.BonusModiLog(ModiDate,ModiPerson,TableName,ItemCode,ItemName,OldValue,NewValue,ReMark,BonusUnit,DataType) 
	 VALUES (:ModiDate,:ModiPerson,:TableName,:ItemCode,:ItemName,:OldValue,:NewValue,:ReMark,:BonusUnit,:DataType) ) 
	
	i value=""  s value=$list(^dhcbsmdBonusExpendCollectD(rowid),8)
	i IsVlaue="" s IsVlaue=$list(^dhcbsmdBonusExpendCollectD(rowid),16)
	&SQL(UPDATE  dhc_bonus_module.BonusExpendCollect(AdjustMoney,IsValue) VALUES (:value,:IsVlaue) where %ID=:rowid) 
	
	
	

	q SQLCODE
}

/// w ##class(dhc.bonus.umodule.uExpendCollect).getUnitCode(0,15,"CK")
ClassMethod getUnitCode(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT BonusWorkItemID,WorkItemName FROM dhc_bonus_module.BonusWorkItem"
	i str'="" s sqlStr = sqlStr_" where WorkItemName  LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
    //w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusWorkItemID")
		s name = result.Data("WorkItemName")
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

/// w ##class(dhc.bonus.umodule.uExpendCollect).insert(1,192,"张飞",2014,"03",10,22,1,2)
ClassMethod insert(deptcode, deptname, year, period, icode, iname, ivalue, collectdate, operator, checkdate, checkman, state) As %String
{
	n (deptcode,deptname,year,period,icode,iname,ivalue,adjustmoney,collectdate,operator,checkdate,checkman,state)
	i collectdate'="" s collectdate=$zdh(collectdate,8)
	i checkdate'="" s checkdate=$zdh(checkdate,8)
	&sql(insert into dhc_bonus_module.BonusExpendCollect 
	(DeptCode,
	DeptName,
	BonusYear,
	BonusPeriod,
	ItemCode,
	ItemName,
	ItemValue,
	CollectDate,
	Operator,
	CheckDate,
	CheckMan,
	state)
	values(:deptcode,:deptname,:year,:period,:icode,:iname,:ivalue,:collectdate,:operator,:checkdate,:checkman,:state) )
	
	


	q SQLCODE
}

//w ##class(dhc.bonus.umodule.uExpendCollect).excel("1001,妇产科,2014,03,1001,耗材支出,1000,2014-03-09,chenwen,2014-03-10,zhangsan,1")

ClassMethod excel(mydata) As %String
{
	n (mydata)
	
	s length=$L(mydata,",")
	s flag=0
	s deptcode=""
	s deptname=""
	s year=""
	s period=""
	s icode=""
	s iname=""
	s ivalue=""
	s collectdate=""
    s operator=""
    s checkdate=""
	s checkman=""
	s state=""
	for i=1:1:length
	{
		s flag=flag+1
		if flag=1{ s deptcode=$p(mydata,",",i)}
		elseif flag=2 {s deptname=$p(mydata,",",i)}
		elseif flag=3 {s year=$p(mydata,",",i)}
		elseif flag=4 {s period=$p(mydata,",",i)}
		elseif flag=5 {s icode=$p(mydata,",",i)}
		elseif flag=6 {s iname=$p(mydata,",",i)}
		elseif flag=7 {s ivalue=$p(mydata,",",i)}
		elseif flag=8 {s collectdate=$p(mydata,",",i)}
		elseif flag=9 {s operator=$p(mydata,",",i)}
		elseif flag=10 {s checkdate=$p(mydata,",",i)}
		elseif flag=11 {s checkman=$p(mydata,",",i)}
		elseif flag=12 {s state=$p(mydata,",",i)
		s flag=0 
		//w !," code "_code_" name "_name_" desc "_desc_" range "_range_" stop "_stop_" date "_date,!

		d ..insert(deptcode,deptname,year,period,icode,iname,ivalue,collectdate,operator,checkdate,checkman,state)
		}
		
		
	}
	
	


	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.u866B.uExpendCollectS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
