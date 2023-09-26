Class dhc.bonus.uinter.uGetTJWorkData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 普通体检科工作量采集
/// w ##class(dhc.bonus.uinter.uGetTJWorkData).GetTJPT("2014","M09",9)
ClassMethod GetTJPT(sYear As %String, sMonth As %String, MethodDr As %String) As %String
{
	
	n (sYear,sMonth,MethodDr)
	q:sYear="" ""
	q:sMonth="" ""
	s sMonth=$E(sMonth,2,3)
	s sMonth1="M" _sMonth

	;w "sMonth1="_sYear_","_sMonth_","_MethodDr,!
	s startDate=sYear_"-" _ sMonth _"-01"
	i sMonth="12" d
	.s sYear=sYear+1
	.s sMonth="01"
	e  d
	.s sMonth=sMonth+1
	i sMonth<10 s sMonth="0" _ sMonth
	s endDate=sYear _"-"_ sMonth _"-01"
	
	
	s YM=sYear_sMonth
	;w "startDate="_startDate,!
	s mSDate=$zdh(startDate,3)
	s mEDate=$zdh(endDate,3)-1
	
	
	s num=0	
	f mDate=mSDate:1:mEDate	d
	.s mWLId=""
	.f  s mWLId=$o(^PAADMi("PAADM_AdmDate",mDate,mWLId)) q:mWLId=""  d
	..s AdmType=$p(^PAADM(mWLId),"^",2)	///就诊类型 H:体检
	..i AdmType="H" d
	...s num=num+1
	;57:D0401_体检科；55：普通体检数量
	&sql(  INSERT INTO dhc_bonus_data.BonusTargetCollect(
	BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod, DataSource, TargetValue, UpdateDate, Remark,InterLocMethodID)
	values(55,57,:sYear,:sMonth1,1,:num,getdate(),"普通体检人次",:MethodDr))
	
	;w num,!
	;q num
}

/// 体检工作量采集
ClassMethod GetTJWorkData(TJYear As %String, TJMonth As %String, MethodDr As %String) As %String
{
	n (TJYear,TJMonth,MethodDr)
	s TJDate=TJYear_"-"_TJMonth
	s Month= "M"_TJMonth
	s sYear = TJYear
	s smonth="M" _TJMonth
	
	;k ^lwhtmp
	;s ^lwhtmp=TJDate_"^"_Month_"^"_TJMonth
  	;w TJDate ,!
   	;q TJDate_"^"_Month_"^"_TJMonth
	//导入数据前清除体检所有数据
	
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:sYear and 
	     BonusPeriod=:Month and InterLocMethodID=:MethodDr 
	     )

  	//插入体检的执行工作量	
    &sql(
         insert into dhc_bonus_subs.BonusSubExpendCollect
         (ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear,BonusPeriod,ItemValue,InterLocMethodID,CollectDate,State,UnitType,ItemNum,ItemPrice)
		 select '06010','体检执行工作量分',b.BonusUnitCode,b.BonusUnitName,:sYear,:Month,(a.TJItemJE)*(d.ExecuteRate),:MethodDr ,getdate(),0,0,a.TJItemNums,cast((a.TJItemJE/a.TJItemNums) as decimal(18,2))
         from dhc_bonus_subs.BonusTJData a,dhc_bonus_data.BonusUnit b,dhc_bonus_subs.BonusSubItem c,dhc_bonus_subs.BonusSubExpendRate d
         where 'T' _ convert(int,a.ZXDeptCode) =b.BonusUnitCode and a.TJDate=:TJDate
         and a.TJItemCode=c.SubItemCode and d.BonusSubItem='D' _ c.BonusSubItemID and d.BonusUnit='G4'
    )
    //插入体检的开单工作量
    &sql(
         insert into dhc_bonus_subs.BonusSubExpendCollect
         (ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear,BonusPeriod,ItemValue,InterLocMethodID,CollectDate,State,UnitType,ItemNum,ItemPrice)
		 select '06011','体检开单工作量分',b.BonusUnitCode,b.BonusUnitName,:sYear,:Month,(a.TJItemJE)*(d.CalculateRate),:MethodDr,getdate(),0,0,a.TJItemNums,cast((a.TJItemJE/a.TJItemNums) as decimal(18,2))
         from dhc_bonus_subs.BonusTJData a,dhc_bonus_data.BonusUnit b,dhc_bonus_subs.BonusSubItem c,dhc_bonus_subs.BonusSubExpendRate d
         where 'T' _ convert(int,a.ZXDeptCode) =b.BonusUnitCode and a.TJDate=:TJDate
         and a.TJItemCode=c.SubItemCode and d.BonusSubItem='D' _ c.BonusSubItemID and d.BonusUnit='G4'
    )
   	//体检执行收入
    &sql(
         insert into dhc_bonus_subs.BonusSubExpendCollect
         (ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear,BonusPeriod,ItemValue,InterLocMethodID,CollectDate,State,UnitType,ItemNum,ItemPrice)
		 select '06013','体检执行收入',b.BonusUnitCode,b.BonusUnitName,:sYear,:Month,a.TJItemJE,:MethodDr,getdate(),0,0,a.TJItemNums,cast((a.TJItemJE/a.TJItemNums) as decimal(18,2))
         from dhc_bonus_subs.BonusTJData a,dhc_bonus_data.BonusUnit b,dhc_bonus_subs.BonusSubItem c
         where 'T' _ convert(int,a.ZXDeptCode) =b.BonusUnitCode and a.TJDate=:TJDate
         and a.TJItemCode=c.SubItemCode 
    )
    //体检开单收入
     &sql(
         insert into dhc_bonus_subs.BonusSubExpendCollect
         (ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear,BonusPeriod,ItemValue,InterLocMethodID,CollectDate,State,UnitType,ItemNum,ItemPrice)
		 select '06012','体检开单收入',b.BonusUnitCode,b.BonusUnitName,:sYear,:Month,a.TJItemJE,:MethodDr,getdate(),0,0,a.TJItemNums,cast((a.TJItemJE/a.TJItemNums) as decimal(18,2))
         from dhc_bonus_subs.BonusTJData a,dhc_bonus_data.BonusUnit b,dhc_bonus_subs.BonusSubItem c
         where 'T' _ convert(int,a.ZXDeptCode) =b.BonusUnitCode and a.TJDate=:TJDate
         and a.TJItemCode=c.SubItemCode 
    )
    &SQL(delete from dhc_bonus_subs.WorkLoad where Flag='TJ' and YearMonth=:TJDate)
    &sql(
   	 insert into dhc_bonus_subs.WorkLoad    (ItemCode,ItemName,PatDepDr,RecDepDr,TarNums,TarPrice,PatRate,RecRate,TotalPrice,Flag,UpdateDate,YearMonth)
   	 select a.TJItemCode,b.SubItemName,58,a.ZXDeptCode,sum(a.TJItemNums),(a.TJItemJE/a.TJItemNums),(d.CalculateRate*(a.TJItemJE/a.TJItemNums)),
   		 (d.ExecuteRate*(a.TJItemJE/a.TJItemNums)),sum(a.TJItemJE),'TJ',getdate(),a.TJDate
		from dhc_bonus_subs.BonusTJData a,dhc_bonus_subs.BonusSubItem b,dhc_bonus_data.BonusUnit c,dhc_bonus_subs.BonusSubExpendRate d
		where a.TJItemCode=b.SubItemCode and 'T' _ convert(int,a.ZXDeptCode)=c.BonusUnitCode
		and 'D' _ b.BonusSubItemID=d.BonusSubItem and BonusUnit='G4' and a.TJDate=:TJDate
		group by a.TJItemCode,a.ZXDeptCode,a.ZXDeptName,a.TJItemName,a.TJDate
    )
   
    s MethodDr1=99999
    s smonth="M" _TJMonth
    //删除当前月份体检数量
    &sql(delete FROM dhc_bonus_data.BonusTargetCollect
	WHERE BonusUnitID=58 AND BonusTargetID=16 AND BonusYear=:TJYear AND BonusPeriod=:smonth )
	//删除当前月份体检收入
	&sql(delete FROM dhc_bonus_data.BonusTargetCollect
	WHERE BonusUnitID=58 AND BonusTargetID=41 AND BonusYear=:TJYear AND BonusPeriod=:smonth )
	
	//插入体检数量
	&sql(  INSERT INTO dhc_bonus_data.BonusTargetCollect(
	BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod, DataSource, TargetValue, UpdateDate, Remark,InterLocMethodID)
	select 16 AS BonusTargetID,b.BonusUnitID,LEFT(CheakDate,4),'M' _ right(CheakDate,2),1,CheakNums,getdate(),'TJSL',:MethodDr1
	 from  dhc_bonus_subs.BonusTJPersonCount a,dhc_bonus_data.BonusUnit b
	WHERE a.DeptCode=b.BonusUnitCode and b.BonusUnitID=58
	AND a.CheakDate=:TJDate)
	
	//插入VIP体检科室收入
    &sql(  INSERT INTO dhc_bonus_data.BonusTargetCollect(
	BonusTargetID, BonusUnitID,  BonusYear, BonusPeriod, DataSource, TargetValue, UpdateDate, Remark,InterLocMethodID)
		 SELECT 41 BonusTargetID,58 BonusUnitID,:TJYear,:smonth,1 ,sum(TJItemJE) je ,getdate(),'TJSR',:MethodDr1
		  from dhc_bonus_subs.BonusTJData
	 WHERE TJDate=:TJDate)
	 //体检人次
	
    d ##class(dhc.bonus.uinter.uGetTJWorkData).GetTJPT(TJYear,smonth,MethodDr)	
	q 123
}

Storage Default
{
<StreamLocation>^dhc.bonus.u1BEE.uGetTJWorkDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
