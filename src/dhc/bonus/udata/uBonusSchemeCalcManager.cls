/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-13
/// Description: 科室奖金核算管理
Class dhc.bonus.udata.uBonusSchemeCalcManager Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhao liguo
/// CreatDate: 2011-01-13
/// Description: 查询奖金核算情况
/// Table: dhc.bonus.data.UnitBonusPay
/// Input: bonusYear-核算年度； bonusPeriod-核算期间；Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).GetUnitBonusPay("2014","M01",0,25)
ClassMethod GetUnitBonusPay(bonusYear, bonusPeriod, start, limit) As %String
{
	
	n (bonusYear,bonusPeriod,start,limit)
	s sqlStr=""
	s sqlStr=sqlStr_" select a.UnitBonusPayID,b.BonusSchemeCode,b.BonusSchemeName,'"_bonusYear_"' as BonusYear"
	s sqlStr=sqlStr_" ,Case when Left('"_bonusPeriod_"',1)='M' then right('"_bonusPeriod_"',2)_'月份'  when Left('"_bonusPeriod_"',1)='Q' then right('"_bonusPeriod_"',2)_'季度'   when'H01'='"_bonusPeriod_"' then  '上半年'"
	s sqlStr=sqlStr_"  when'"_bonusPeriod_"'='H02' then  '下半年' when Left('"_bonusPeriod_"',1)='Y' then '' end as BonusPeriod"
	s sqlStr=sqlStr_" ,Case a.IsAuditing when null then '未核算' else '已核算'  end as CalcState ,a.UpdateDate"
	s sqlStr=sqlStr_" ,Case when a.IsAuditing=0 or a.IsAuditing= null then '未审核' else '已审核'  end as  IsAuditing ,a.AuditingDate"
	s sqlStr=sqlStr_" ,Case when a.IsPay = 0 or a.IsPay = null then '未发放' else '已发放' end as IsPay ,PayDate"
	s sqlStr=sqlStr_" from dhc_bonus_data.UnitBonusPay  a  right join dhc_bonus_data.BonusScheme b on a.BonusSchemeID = b.BonusSchemeID"
	s sqlStr=sqlStr_" and a.BonusYear='"_bonusYear_"' and BonusPeriod='"_bonusPeriod_"'"
	s sqlStr=sqlStr_" where b. IsValid=1 and b.SchemeState=1	"

	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^BonusSchemeCode^BonusSchemeName^BonusYear^BonusPeriod^CalcState^UpdateDate^IsAuditing^AuditingDate^IsPay^PayDate"
	
	While(result.Next()){
			s rowid=result.Data("UnitBonusPayID")
		s BonusSchemeCode=result.Data("BonusSchemeCode")	
		s BonusSchemeName=result.Data("BonusSchemeName")
		s BonusYear=result.Data("BonusYear")
		s BonusPeriod=result.Data("BonusPeriod")
		s CalcState=result.Data("CalcState")
		s UpdateDate=result.Data("UpdateDate")
		s IsAuditing=result.Data("IsAuditing")
			
		s AuditingDate=result.Data("AuditingDate")
		if (AuditingDate'="")  d
		.s AuditingDate = $zd(AuditingDate,3)
		
		s IsPay=result.Data("IsPay")
		s PayDate=result.Data("PayDate")
		if (PayDate'="")  d
		.s PayDate = $zd(PayDate,3)
	
		s tmp=rowid_"^"_BonusSchemeCode_"^"_BonusSchemeName_"^"_BonusYear_"^"_BonusPeriod_"^"_CalcState_"^"_UpdateDate_"^"_IsAuditing_"^"_AuditingDate_"^"_IsPay_"^"_PayDate
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-13
/// Description: 奖金核算审核
/// Table: dhc.bonus.data.UnitBonusPay
/// Input: rowid-主键;IsPay-是否审核，0:不审核，1:审核;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.BonusSchemeCalcManager).UnitBonusPayAuditing(2,1)
ClassMethod UnitBonusPayAuditing(rowid, IsAuditing) As %String
{
		
	n (rowid,IsAuditing)
		
	k PLIST
	q:rowid="" "EmptyRecData"
	q:IsAuditing="" "EmptyRecData"
	
	s PLIST(9)=IsAuditing
	s PLIST(10)=$P($H,",",1)
		
	&SQL(update dhc_bonus_data.UnitBonusPay VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-13
/// Description: 奖金核算发放
/// Table: dhc.bonus.data.UnitBonusPay
/// Input: rowid-主键;IsPay-是否发放，0:不发放，1:发放;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.BonusSchemeCalcManager).UnitBonusPay(2,1)
ClassMethod UnitBonusPay(rowid, IsPay) As %String
{
		
	n (rowid,IsPay)
		
	k PLIST
	q:rowid="" "EmptyRecData"
	q:IsPay="" "EmptyRecData"
		
	s PLIST(11)=IsPay
	s PLIST(12)=$P($H,",",1)
		
	&SQL(update dhc_bonus_data.UnitBonusPay VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-18
/// Description: 奖金核算明细动态标题
/// Table: dhc.bonus.data.BonusScheme
/// Input: SchemeCode-奖金方案编码
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).GetGridTitle("0204")
ClassMethod GetGridTitle(SchemeCode) As %String
{
	n (SchemeCode)
	s rowid= 0
	
	s sqlStr=" select 'dataIndex'_ b.BonusSchemeItemID as  IndexName,b.SchemeItemName title"
	s sqlStr=sqlStr_" from dhc_bonus_data.BonusScheme a  join dhc_bonus_data.BonusSchemeItem  b on a.BonusSchemeID = b.BonusSchemeID"
	s sqlStr=sqlStr_" where a.IsValid=1 and b.IsValid=1 and a.BonusSchemeCode='"_SchemeCode_"'  order by  b.SchemeItemCode "
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^IndexName^title"
	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	
	d json.InsertRowData("0^SuperUnitName^所属科室")
	d json.InsertRowData("0^BonusUnit^核算单元")
	d json.InsertRowData("0^UnitTypeName^单元类别")
	While(result.Next()){
		s rowid =rowid+1
		s dataIndex=result.Data("IndexName")
		s title=result.Data("title")
		
		s tmp = rowid_"^"_dataIndex_"^"_title
		d json.InsertRowData(tmp)
		s count=count+1	
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-18
/// Description: 奖金核算明细动态数据
/// Table: dhc.bonus.data.BonusScheme
/// Input: SchemeCode-奖金方案编码,BonusYear-核算年度,BonusPeriod-核算期间
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).GetUnitBonusDetail("0206","2012","M01",0,25)
ClassMethod GetUnitBonusDetailOrig(schemeCode, BonusYear, BonusPeriod, start, limit) As %String
{
	n (schemeCode,BonusYear,BonusPeriod, start, limit)
		s rowid= 0
	
	s sqlStr=" select d.BonusUnitName,'dataIndex'_ b.BonusSchemeItemID  as  IndexName,b.SchemeItemName,e.BonusValue,e.BonusType"
	_" ,SuperiorUnitID->BonusUnitName SuperUnitName,d.BonusUnitTypeID->UnitTypeName"
	
	s sqlStr=sqlStr_" from dhc_bonus_data.BonusScheme a right join dhc_bonus_data.BonusSchemeItem  b on a.BonusSchemeID = b.BonusSchemeID"
	s sqlStr=sqlStr_" join dhc_bonus_data.BonusSchemeUnit c on   a.BonusSchemeID = c.BonusSchemeID"
	
	s sqlStr=sqlStr_" join dhc_bonus_data.BonusUnit d on   c.BonusUnitID = d.BonusUnitID"
	s sqlStr=sqlStr_"  join dhc_bonus_data.UnitBonusDetail  e on   e.BonusUnitID = d.BonusUnitID   and e.BonusSchemeItemID=b.BonusSchemeItemID"
	s sqlStr=sqlStr_"  and e.BonusYear='"_BonusYear_"' and e.BonusPeriod='"_BonusPeriod_"'"
	//s sqlStr=sqlStr_" and e.BonusUnitID in ( select distinct BonusUnitID from dhc_bonus_data.UnitBonusDetail"
	//s sqlStr=sqlStr_" where BonusSchemeID->BonusSchemeCode='"_schemeCode_"'  and BonusType=1 and BonusValue<>0)"
	s sqlStr=sqlStr_"  where a.IsValid=1  and a.BonusSchemeCode='"_schemeCode_"'"
	s sqlStr=sqlStr_"   order by SuperiorUnitID->BonusUnitName,d.BonusUnitName, b.SchemeItemCode "
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^IndexName^title"
	
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s sTitle =""
	s sValue =""
	s unittmp=""
	
	s count=0
	s resultString=""
	s end=start+limit-1
	s hj=0
	
	While(result.Next()){
		s rowid =rowid+1
		s dataIndex=result.Data("IndexName")
		s title=result.Data("SchemeItemName")
		s BonusValue=result.Data("BonusValue")
		s BonusType = result.Data("BonusType") 
		s BonusValue=$fn(BonusValue,"",2)
		s unitname=result.Data("BonusUnitName")
		s UnitTypeName = result.Data("UnitTypeName")
		s SuperUnitName = result.Data("SuperUnitName")
		
		;w rowid_"^"_dataIndex_"^"_title_"^"_BonusValue_"^"_BonusType_"^"_unitname_"^"_UnitTypeName_"^"_SuperUnitName,!
		
		;i ((BonusType=1) && (BonusValue'="0.00"))
		
		if unittmp="" {
			s unittmp=unitname
			s sTitle ="BonusUnit"
			s sValue =unitname
			}
		
		if unittmp=unitname
		{
			s unittmp=unitname
			s sTitle =sTitle_"^" _dataIndex
			s sValue = sValue_"^" _BonusValue
			s hj =hj+BonusValue
		}else{
			i hj'=0 d
			.i (count>=start)&(count<=end) d
			..d json.InsertRowData(sValue)
			.s count=count+1	
			
			s hj=0
			s unittmp=unitname
			s sTitle ="SuperUnitName^BonusUnit^UnitTypeName^"_dataIndex
			s sValue =SuperUnitName_"^"_unitname_"^"_UnitTypeName_"^"_BonusValue
			
				}
		}
	
	
		i sValue="" d
		.s sValue =" ^0"
		
		i sTitle="" d 
		.s sTitle="BonusUnit^dataIndex0"
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(sValue)
		s count=count+1	

	d result.Close()
	s resultString = json.getJsonData(sTitle,count)
 	k json
	q resultString
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-18
/// Description: 奖金核算明细动态数据
/// Table: dhc.bonus.data.BonusScheme
/// Input: SchemeCode-奖金方案编码,BonusYear-核算年度,BonusPeriod-核算期间
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).GetUnitBonusDetail("1004","2016","M01",0,25)
ClassMethod GetUnitBonusDetail(schemeCode, BonusYear, BonusPeriod, start, limit) As %String
{
	n (schemeCode,BonusYear,BonusPeriod, start, limit)
		s rowid= 0
	
	s sqlStr=" select d.BonusUnitName,'dataIndex'_ b.BonusSchemeItemID  as  IndexName,b.SchemeItemName,e.BonusValue,e.BonusType"
	_" ,d.SuperiorUnitID->BonusUnitName SuperUnitName,d.BonusUnitTypeID->UnitTypeName"
	
	s sqlStr=sqlStr_" from dhc_bonus_data.BonusScheme a right join dhc_bonus_data.BonusSchemeItem  b on a.BonusSchemeID = b.BonusSchemeID"
	s sqlStr=sqlStr_" join dhc_bonus_data.BonusSchemeUnit c on   a.BonusSchemeID = c.BonusSchemeID"
	
	s sqlStr=sqlStr_" join dhc_bonus_data.BonusUnit d on   c.BonusUnitID = d.BonusUnitID"
	s sqlStr=sqlStr_"  join dhc_bonus_data.UnitBonusDetail  e on   e.BonusUnitID = d.BonusUnitID   and e.BonusSchemeItemID=b.BonusSchemeItemID"
	s sqlStr=sqlStr_"  and e.BonusYear='"_BonusYear_"' and e.BonusPeriod='"_BonusPeriod_"'"
	//s sqlStr=sqlStr_" and e.BonusUnitID in ( select distinct BonusUnitID from dhc_bonus_data.UnitBonusDetail"
	//s sqlStr=sqlStr_" where BonusSchemeID->BonusSchemeCode='"_schemeCode_"'  and BonusType=1 and BonusValue<>0)"
	s sqlStr=sqlStr_"  where a.IsValid=1  and a.BonusSchemeCode='"_schemeCode_"'"
	s sqlStr=sqlStr_"   order by d.SuperiorUnitID->BonusUnitName,d.BonusUnitName, b.SchemeItemCode "
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^IndexName^title"
	
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s sTitle =""
	s sValue =""
	s unittmp=""
	
	s count=0
	s resultString=""
	s end=start+limit-1
	s hj=0

	While(result.Next()){
		s rowid =rowid+1
		s dataIndex=result.Data("IndexName")
		s title=result.Data("SchemeItemName")
		s BonusValue=result.Data("BonusValue")
		s BonusType = result.Data("BonusType") 
		s BonusValue=$fn(BonusValue,",",2)
		s unitname=result.Data("BonusUnitName")
		s UnitTypeName = result.Data("UnitTypeName")
		s SuperUnitName = result.Data("SuperUnitName")
		;w UnitTypeName,!
		if unittmp="" {
			s unittmp=unitname
			s sTitle ="SuperUnitName^BonusUnit^UnitTypeName"
			s sValue =SuperUnitName_"^"_unitname_"^"_UnitTypeName
			}
		if unittmp=unitname
		{
			;s unittmp=unitname
			s sTitle =sTitle_"^" _dataIndex
			s sValue = sValue_"^" _BonusValue
			i BonusValue'=0 s hj=BonusValue
			
		}else{
			i hj'=0 d
			.i (count>=start)&(count<=end) d
			..;w sValue,!
			..d json.InsertRowData(sValue)
			.s count=count+1	
			
			s hj=BonusValue
			s unittmp=unitname
			s sTitle ="SuperUnitName^BonusUnit^UnitTypeName^"_dataIndex
			s sValue =SuperUnitName_"^"_unitname_"^"_UnitTypeName_"^"_BonusValue	
		
		     }
		}
	
		i sValue="" d
		.s sValue =" ^0"
		i sTitle="" d 
		.s sTitle="BonusUnit^dataIndex0"
    ;d json.InsertRowData(sValue)
	i count<=end d json.InsertRowData(sValue)
	s count=count+1

	///----
	d result.Close()
	s resultString = json.getJsonData(sTitle,count)
 	k json
	q resultString
}

/***
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
*/
/// Creator: zhao liguo
/// CreatDate: 2011-03-11
/// Description: 查询奖金核算明细
/// Table: dhc.bonus.data.UnitBonusDetail
/// Input: bonusYear-核算年度； bonusPeriod-核算期间；Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).BonusDetailQuery("05","2011","M01",0,25)
ClassMethod BonusDetailQuery(BonusSchemeCode, bonusYear, bonusPeriod, start, limit) As %String
{
	
	n (BonusSchemeCode,bonusYear,bonusPeriod,start,limit)
	s sqlStr=""
	s sqlStr=sqlStr_" select BonusYear,BonusPeriod,a.BonusUnitID,a.BonusUnitID->BonusUnitName,b.SchemeItemName,"
	s sqlStr=sqlStr_" case  when b.DataSource=1  then '录入' when b.DataSource=2  then '公式' end as DataSource,"
	s sqlStr=sqlStr_"  BonusFormula,BonusFormulaDesc,a.BonusValue  from  dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusSchemeItem b"
	
	s sqlStr=sqlStr_" where  a.BonusSchemeItemID = b.BonusSchemeItemID and"
	s sqlStr=sqlStr_"   b.BonusSchemeID->BonusSchemeCode ='"_BonusSchemeCode_"'"
	s sqlStr=sqlStr_" and a.BonusYear='"_bonusYear_"' and BonusPeriod='"_bonusPeriod_"'"


	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//BonusYear
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="BonusUnitName^SchemeItemName^BonusYear^BonusPeriod^DataSource^BonusValue^BonusFormulaDesc^BonusFormula"
	
	While(result.Next()){
		s BonusUnitName=result.Data("BonusUnitName")
		s BonusUnitID =result.Data("BonusUnitID")
		
		s SchemeItemName=result.Data("SchemeItemName")	
		s BonusYear=result.Data("BonusYear")
		s BonusPeriod=result.Data("BonusPeriod")
		
		s DataSource=result.Data("DataSource")
		s BonusValue=result.Data("BonusValue")
		s BonusFormulaDesc=result.Data("BonusFormulaDesc")
		s BonusFormula=result.Data("BonusFormula")
		s spara =BonusUnitID_"^"_BonusYear_"^"_BonusPeriod
		w "spara:"_spara,!
		
		s smula=""
		w "BonusFormula:"_BonusFormula,!
		if DataSource="公式" {
			for i=2:1:$L(BonusFormula,"^") {
				s tvalue=0
				s svalue=0
				s sList(i)= $P(BonusFormula,"^",i)
				
				///T:奖金指标编码
				if $E(sList(i),1,1)="T" {
					
						s tcode= $E(sList(i),2,$L(sList(i)))
						w "tpara:"_tcode,!
						
						s tvalue =##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetValue(tcode,spara)
						s smula= smula_tvalue
					
					}elseif $E(sList(i),1,1)="S" {
						
						s scode= $E(sList(i),2,$L(sList(i)))
						w "spara:"_scode,!
						
						s svalue =##class(dhc.bonus.udata.uBonusSchemeCalculate).GetSchemeItemVale(scode,spara)
						s smula= smula_svalue
					}else{
						s smula= smula_sList(i)
						}
					
			}
		}
		;w "------------------smula:"_smula,!
		s tmp=BonusUnitName_"^"_SchemeItemName_"^"_BonusYear_"^"_BonusPeriod_"^"_DataSource_"^"_BonusValue_"^"_BonusFormulaDesc_"^"_BonusFormula
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:李明忠
/// CreatDate: 2012-03-30
/// Description: 审核过的奖金数据下发到科室进行二次分配
/// Table:dhc_bonus_data.BonusIssuedMain,dhc_bonus_data.BonusIssuedDetail
/// Input:schemCode-核算方案代码;year-核算年度;period-核算期间
/// Output: 
/// Return: 返回下发成功与否标识
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).DeptBonusIsseued("0101","2015","M03","demo")
ClassMethod DeptBonusIsseued(schemCode, year, period, userCode) As %String
{
	n (schemCode,year,period,userCode)
	    	
	q:schemCode="" ""
	q:year="" ""
	q:period="" ""
	s %ROWID=0
	s sm=$E(period,2,3)
	s year1=year
	
	i sm>1 d
	.s period1=sm-1
	.i period1<10 d
	..s period1="M0" _ period1
	.e  d 
	..s period1="M" _ period1
	e  d
	.s period1="M12"
	.s year1=year-1
	
	;w year1 _","_ period1,!
	
	;s UnitIdArry(i)=
	;&sql(delete from dhc_bonus_data.BonusIssuedDetail where BonusUnitID in(:userCode))
	;q SQLCODE
	&sql(delete from dhc_bonus_data.BonusIssuedDetail where BonusIssuedMainID in
	(select %ID from dhc_bonus_data.BonusIssuedMain where   BonusYear = :year and  BonusPeriod =:period and BonusSchemeID->BonusSchemeCode=:schemCode)  )

	&sql(delete from dhc_bonus_data.BonusIssuedMain where   BonusYear = :year and  BonusPeriod =:period and BonusSchemeID->BonusSchemeCode=:schemCode)
   /*
    &sql( insert into dhc_bonus_data.BonusIssuedMain( BonusSchemeID, BonusUnitID,SupBonusUnitID, BonusYear,
 		 BonusPeriod, SchemeItemID, ResultBonus , DataStatus,IssuedDate,IssuedPerson,UnitFlag) 
 		 select BonusSchemeID, BonusUnitID->SumUnitID ,BonusUnitID->SumUnitID->SuperiorUnitID SupBonusUnitID, BonusYear, BonusPeriod
  		,BonusSchemeItemID,sum(BonusValue) bvalue,0 DataStatus,getdate(),'' IssuedPerson, 1 UnitFlag
 		 from dhc_bonus_data.UnitBonusDetail
  		where  BonusYear = :year and  BonusPeriod =:period and BonusSchemeItemID->BonusType=2 and BonusValue<>0
   		AND BonusSchemeID->BonusSchemeCode=:schemCode
  	 	group by BonusSchemeID, BonusUnitID->SumUnitID ,BonusUnitID->SumUnitID->SuperiorUnitID , BonusYear, BonusPeriod  ,BonusSchemeItemID
		)
	*/	
	&sql(insert into dhc_bonus_data.BonusIssuedMain( BonusSchemeID, BonusUnitID,SupBonusUnitID, BonusYear,
 		 BonusPeriod, SchemeItemID, ResultBonus , DataStatus,IssuedPerson,UnitFlag,payBalance,IssuedDate) 
	 SELECT BonusSchemeID, SumUnitID, SupBonusUnitID, BonusYear, BonusPeriod, BonusSchemeItemID,sum(bvalue) bvalue
 		 , DataStatus, IssuedPerson, UnitFlag, sum(payBalance) AS payBalance,getdate()
 		 FROM (
 		 select BonusSchemeID, BonusUnitID->SumUnitID ,BonusUnitID->SumUnitID->SuperiorUnitID SupBonusUnitID, :year BonusYear,:period BonusPeriod
  		,BonusSchemeItemID,sum(BonusValue) bvalue,0 DataStatus,'' IssuedPerson, 1 UnitFlag,0 payBalance
 		 from dhc_bonus_data.UnitBonusDetail
  		where  BonusYear = :year and  BonusPeriod =:period and BonusSchemeItemID->BonusType=2 
   		AND BonusSchemeID->BonusSchemeCode=:schemCode
  	 	group by BonusSchemeID, BonusUnitID->SumUnitID ,BonusUnitID->SumUnitID->SuperiorUnitID , BonusYear, BonusPeriod  ,BonusSchemeItemID
        UNION all
 		SELECT BonusSchemeID, BonusUnitID->SumUnitID ,BonusUnitID->SumUnitID->SuperiorUnitID SupBonusUnitID,:year BonusYear,:period BonusPeriod
  		,SchemeItemID,0 bvalue,0 DataStatus,'' IssuedPerson, 1 UnitFlag,isnull(PayBalance,0)+isnull(ResultBonus,0)- isnull(PayBonus,0) payBalance
 		from dhc_bonus_data.BonusIssuedMain
		where  BonusYear = :year1 and  BonusPeriod =:period1 and SchemeItemID->BonusType=2 
   		AND BonusSchemeID->BonusSchemeCode=:schemCode
   		) AS jj
   		GROUP BY BonusSchemeID, SumUnitID, SupBonusUnitID, BonusYear, BonusPeriod, BonusSchemeItemID, 
   		 DataStatus, IssuedPerson, UnitFlag
	)
	;w "SQLCODE="_SQLCODE,!
		
	s mID=%ROWID

	&sql(insert into dhc_bonus_data.BonusIssuedDetail(BonusIssuedMainID,BonusUnitID,IssuedBonus, AdjustBonus, ResultBonus,SchemeItemID,
 		 SuperiorUnitID, SupUnitName,BonusUnitCode,BonusUnitName, UpdateDate, BonusYear, BonusPeriod)
 		SELECT :mID BonusIssuedMainID,a.BonusUnitID,0 IssuedBonus,0 AdjustBonus,0 ResultBonus,c.BonusSchemeItemID,
 		 a.SumUnitID SuperiorUnitID,a.SumUnitID->BonusUnitName SupUnitName,a.BonusUnitCode,a.BonusUnitName
 		 ,getdate() UpdateDate,:year BonusYear,:period BonusPeriod
 		  from dhc_bonus_data.bonusUnit a,dhc_bonus_data.BonusSchemeUnit b,dhc_bonus_data.BonusSchemeItem c
         where a.SumUnitID=b.BonusUnitID AND b.BonusSchemeID=c.BonusSchemeID AND c.BonusType=2
         AND b.BonusSchemeID->BonusSchemeCode=:schemCode
         AND a.UnitFlag=3)


		//获取下发用户 zlg1617
	s userName =..getUserName(userCode)
	s Issdate = $ZD($h,3)_" "_$ZT($P($h,",",2),3)
	//w userName,!
	&SQL(update dhc_bonus_data.UnitBonusMain set IsPay=1,IssuedPerson=:userName,IssuedDate=:Issdate where BonusYear=:year and BonusPeriod=:period and BonusSchemeID->BonusSchemeCode=:schemCode)
    
	q 0
}

/// Creator:李明忠
/// CreatDate: 2012-03-30
/// Description: 审核过的奖金数据下发到科室进行二次分配
/// Table:dhc_bonus_data.BonusIssuedMain,dhc_bonus_data.BonusIssuedDetail
/// Input:schemCode-核算方案代码;year-核算年度;period-核算期间
/// Output: 
/// Return: 返回下发成功与否标识
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).Down("0205","2012","M01","fhq")
ClassMethod Down(schemCode, year, period, userCode) As %String
{
	n (schemCode,year,period,userCode)
	
	q:schemCode="" ""
	q:year="" ""
	q:period="" ""
	
	;w "开始 "_$ZT($P($h,",",2),3),!
	
	//获取方案ID
	s schemId = ..getSchemId(schemCode)
	q:schemId="" ""
	//获取方案类别
	s schemTypeName = ..getSchemType(schemCode)
	q:schemTypeName="" ""
	//获取下发用户
	s userName = ..getUserName(userCode)
	
	k ^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j)
	k ^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j)
	s dataState = 1
	
	i schemTypeName = "人员奖金核算" d
	.i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,period)) d
	..s unitId = 0
	..f  s unitId = $O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,period,unitId)) q:unitId=""  d
	...s parentId = ..getParentId(unitId)
	...q:parentId=""
	...i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,period,unitId,schemId)) d
	....s itemId = 0
	....f  s itemId = $O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,period,unitId,schemId,itemId)) q:itemId=""  d
	.....s ItemType=0
	.....i $D(^dhcbsBonusSchemeItemD(itemId)) d
	......s ItemType=$List(^dhcbsBonusSchemeItemD(itemId),9)
	......;w "zlg:="_itemId_"^"_ItemType,!
	.....q:ItemType'="2"    ;奖金项目类型未发放项目的才下发  
	.....s rowid=0
	.....f  s rowid = $O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,period,unitId,schemId,itemId,rowid)) q:rowid=""  d
	......i $D(^dhcbsUnitBonusDetailD(rowid)) d
	.......s value=$fn($List(^dhcbsUnitBonusDetailD(rowid),8),"",2)
	.......i $D(^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,parentId,itemId)) d
	........s ^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,parentId,itemId)=^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,parentId,itemId)+value
	.......e  d
	........s ^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,parentId,itemId)=value
	.......i $D(^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j,year,period,schemId,parentId,unitId,itemId)) d
	........s ^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j,year,period,schemId,parentId,unitId,itemId) = ^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j,year,period,schemId,parentId,unitId,itemId)+value
	.......e  d
	........s ^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j,year,period,schemId,parentId,unitId,itemId)=value
	e  d //科室奖金核算
	.;w "zlg 科室奖金核算",!
	.i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,period)) d
	..s unitId = 0
	..f  s unitId = $O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,period,unitId)) q:unitId=""  d
	...s personIdStr = ..getPerson(unitId)
	...i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,period,unitId,schemId)) d
	....s itemId = 0
	....f  s itemId = $O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,period,unitId,schemId,itemId)) q:itemId=""  d
	.....s rowid=0
	.....f  s rowid = $O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,period,unitId,schemId,itemId,rowid)) q:rowid=""  d
	......i $D(^dhcbsUnitBonusDetailD(rowid)) d
	.......s value=$fn($List(^dhcbsUnitBonusDetailD(rowid),8),"",2)
	.......i $D(^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,unitId,itemId)) d
	........s ^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,unitId,itemId)=^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,unitId,itemId)+value
	.......e  d
	........s ^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,unitId,itemId)=value
	.......;科室存在的话,则处理人员数据
	.......f i=1:1:$L(personIdStr,"^") d
	........s ^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j,year,period,schemId,unitId,$P(personIdStr,"^",i),itemId)=0
	
	s Issdate = $ZD($h,3)_" "_$ZT($P($h,",",2),3)
	//插入数据主表
	i $D(^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId)) d
	.s unitId=0
	.f  s unitId = $O(^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,unitId)) q:unitId=""  d
	..s itemId=0
	..f  s itemId = $O(^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,unitId,itemId)) q:itemId=""  d
	...s value = ^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j,year,period,schemId,unitId,itemId)
	...;w schemId_"^"_unitId_"^"_year_"^"_period_"^"_itemId_"^"_value_"^"_dataState_"^"_Issdate_"^"_userName,!
	...&SQL(insert into dhc_bonus_data.BonusIssuedMain(BonusSchemeID,SupBonusUnitID,BonusYear,BonusPeriod,SchemeItemID,ResultBonus,DataStatus,IssuedDate,IssuedPerson) values(:schemId,:unitId,:year,:period,:itemId,:value,:dataState,:Issdate,:userName))


	//插入数据明细表
	i $D(^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j,year,period,schemId)) d
	.s unitId=0
	.f  s unitId = $O(^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j,year,period,schemId,unitId)) q:unitId=""  d
	..s personId=0
	..f  s personId = $O(^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j,year,period,schemId,unitId,personId)) q:personId=""  d
	...s itemId=0
	...f  s itemId = $O(^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j,year,period,schemId,unitId,personId,itemId)) q:itemId=""  d
	....;获取数据主表的ID
	....s mainId = ..getMainId(year,period,schemId,unitId,itemId)
	....q:mainId=""
	....s value = ^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j,year,period,schemId,unitId,personId,itemId)
	....&SQL(insert into dhc_bonus_data.BonusIssuedDetail(BonusIssuedMainID,BonusUnitID,SchemeItemID,IssuedBonus) values(:mainId,:personId,:itemId,:value))
	
	k ^DHCCBONUSDOWNTEMP("dhc","bonus","down",$j)
	k ^DHCCBONUSDOWNTEMP("dhc","bonus","down","person",$j)
	
	&SQL(update dhc_bonus_data.UnitBonusMain set IsPay=1,IssuedPerson=:userName,IssuedDate=:Issdate where BonusYear=:year and BonusPeriod=:period and BonusSchemeID=:schemId)
	;w "结束 "_$ZT($P($h,",",2),3),!
	q 0
}

/// Creator:李明忠
/// CreatDate: 2012-03-30
/// Description: 获取方案类别
/// Table:dhc_bonus_data.BonusScheme
/// Input:schemCode-核算方案代码
/// Output: 
/// Return: 返回方案类别名称
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).getSchemType("0101")
ClassMethod getSchemType(schemCode) As %String
{
	n (schemCode)
	q:schemCode="" ""
	
	s SchemeTypeName=""
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select SchemeTypeName from dhc_bonus_data.BonusSchemeType where BonusSchemeTypeID = (select SchemeType from dhc_bonus_data.BonusScheme where BonusSchemeCode = '"_schemCode_"')")
	d result.Execute()
	
	While(result.Next()){
		s SchemeTypeName=result.Data("SchemeTypeName")
	}
	q SchemeTypeName
}

/// Creator:李明忠
/// CreatDate: 2012-03-30
/// Description: 获取方案ID
/// Table:dhc_bonus_data.BonusScheme
/// Input:schemCode-核算方案代码
/// Output: 
/// Return: 返回方案ID
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).getSchemId("0101")
ClassMethod getSchemId(schemCode) As %String
{
	n (schemCode)
	q:schemCode="" ""
	
	s schemID=""
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select BonusSchemeID from dhc_bonus_data.BonusScheme where BonusSchemeCode = '"_schemCode_"'")
	d result.Execute()
	
	While(result.Next()){
		s schemID=result.Data("BonusSchemeID")
	}
	q schemID
}

/// Creator:李明忠
/// CreatDate: 2012-03-30
/// Description: 根据核算单元找上级
/// Table:dhc_bonus_data.BonusUnit
/// Input:unitId-核算单元ID
/// Output: 
/// Return: 返回单元ID
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).getParentId("0101")
ClassMethod getParentId(unitId) As %String
{
	n (unitId)
	q:unitId="" ""
	
	s parentID=""
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select SuperiorUnitID from dhc_bonus_data.BonusUnit where BonusUnitID="_unitId)
	d result.Execute()
	
	While(result.Next()){
		s parentID=result.Data("SuperiorUnitID")
	}
	q parentID
}

/// Creator:李明忠
/// CreatDate: 2012-03-30
/// Description:获取用户名称
/// Table:sqlUser
/// Input:userCode-用户代码
/// Output: 
/// Return: 返回用户名称
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).getUserName("fhq")
ClassMethod getUserName(userCode) As %String
{
	n (userCode)
	q:userCode="" ""
	
	s userName=""
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select SSUSR_Name from ss_User where SSUSR_Initials='"_userCode_"'")
	d result.Execute()
	
	While(result.Next()){
		s userName=result.Data("SSUSR_Name")
	}
	q userName
}

/// Creator:李明忠
/// CreatDate: 2012-03-30
/// Description:根据核算科室获取该科室下的人员
/// Table:sqlUser
/// Input:userCode-用户代码
/// Output: 
/// Return: 返回用户名称
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).getPerson()
ClassMethod getPerson(unitId) As %String
{
	n (unitId)
	q:unitId="" ""
	
	s str=""
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select BonusUnitID from dhc_bonus_data.BonusUnit where SuperiorUnitID="_unitId)
	d result.Execute()
	
	While(result.Next()){
		s personId=result.Data("BonusUnitID")
		i str="" s str=personId
		e  s str = str_"^"_personId
	}
	q str
}

/// Creator:李明忠
/// CreatDate: 2012-03-30
/// Description:获取数据主表的ID
/// Table:sqlUser
/// Input:year-年度;period-期间;schemId-方案;unitId-科室ID;itemId-项目ID
/// Output: 
/// Return: 返回数据主表的ID
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).getMainId()
ClassMethod getMainId(year, period, schemId, unitId, itemId) As %String
{
	n (year,period,schemId,unitId,itemId)
	q:year="" ""
	q:period="" ""
	q:schemId="" ""
	q:unitId="" ""
	q:itemId="" ""
	
	s mainId=0
	s mainId = $O(^dhcbsIssuedMainI("GetMainId",schemId,unitId,year,period,itemId,mainId))
	
	q mainId
}

/// Others: w ##class(dhc.bonus.udata.uBonusSchemeCalcManager).test('0101','2016','M03','demo')
ClassMethod test(schemCode, year, period, userCode) As %String
{
	n (schemCode,year,period,userCode)
	    	
	q:schemCode="" ""
	q:year="" ""
	q:period="" ""
	s %ROWID=0
	
	;s UnitIdArry(i)=
	;&sql(delete from dhc_bonus_data.BonusIssuedDetail where BonusUnitID in(:userCode))
	;q SQLCODE
	&sql(delete from dhc_bonus_data.BonusIssuedDetail where BonusIssuedMainID in
	
	(select %ID from dhc_bonus_data.BonusIssuedMain where   BonusYear = :year and  BonusPeriod =:period and BonusSchemeID->BonusSchemeCode=:schemCode)  )

	&sql(delete from dhc_bonus_data.BonusIssuedMain where   BonusYear = :year and  BonusPeriod =:period and BonusSchemeID->BonusSchemeCode=:schemCode)
   
	//	&sql(insert into dhc_bonus_data.BonusUnit (BonusUnitCode,BonusUnitName,EmployeeNo,UnitFlag,SuperiorUnitID,UnitLevel,LastStage,UpdateDate,IsValid,BonusUnitTypeID) values(:code,:name,:EmployeeNo,:unitFlag,:parent,:level,:lastStage,:UpdateDate,:IsValid,:unitType))

    &sql(   insert into dhc_bonus_data.BonusIssuedMain( BonusSchemeID, BonusUnitID,SupBonusUnitID, BonusYear,
 		 BonusPeriod, SchemeItemID, ResultBonus , DataStatus,IssuedDate,IssuedPerson,UnitFlag) 
 		 select BonusSchemeID, BonusUnitID->SumUnitID ,BonusUnitID->SumUnitID->SuperiorUnitID SupBonusUnitID, BonusYear, BonusPeriod
  		,BonusSchemeItemID,sum(BonusValue) bvalue,0 DataStatus,getdate(),'' IssuedPerson, 1 UnitFlag
 		 from dhc_bonus_data.UnitBonusDetail
  		where  BonusYear = :year and  BonusPeriod =:period and BonusSchemeItemID->BonusType=2 and BonusValue<>0
   		AND BonusSchemeID->BonusSchemeCode=:schemCode
  	 	group by BonusSchemeID, BonusUnitID->SumUnitID ,BonusUnitID->SumUnitID->SuperiorUnitID , BonusYear, BonusPeriod  ,BonusSchemeItemID
		)
	s mID=%ROWID
	//W mID,!
	;q:mID=0 0
	&sql(insert into dhc_bonus_data.BonusIssuedDetail(BonusIssuedMainID,BonusUnitID,IssuedBonus, AdjustBonus, ResultBonus,SchemeItemID,
 		 SuperiorUnitID, SupUnitName,BonusUnitCode,BonusUnitName, UpdateDate, BonusYear, BonusPeriod)
 		  select :mID mID,BonusUnitID ,BonusValue ,0 AdjustBonus, BonusValue ResultBonus,BonusSchemeItemID,BonusUnitID->SumUnitID
         ,BonusUnitID->SumUnitID->BonusUnitName,BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName,getdate(),BonusYear, BonusPeriod
         from dhc_bonus_data.UnitBonusDetail
         where  BonusYear = :year and  BonusPeriod =:period and BonusSchemeItemID->BonusType=2
         AND BonusSchemeID->BonusSchemeCode=:schemCode)


		//获取下发用户
	s userName =..getUserName(userCode)
	s Issdate = $ZD($h,3)_" "_$ZT($P($h,",",2),3)
	//w userName,!
	&SQL(update dhc_bonus_data.UnitBonusMain set IsPay=1,IssuedPerson=:userName,IssuedDate=:Issdate where BonusYear=:year and BonusPeriod=:period and BonusSchemeID->BonusSchemeCode=:schemCode)
    
	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusScheme8FFS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
