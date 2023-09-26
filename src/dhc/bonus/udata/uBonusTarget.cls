Class dhc.bonus.udata.uBonusTarget Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.bonus.udata.uBonusTarget).ListInScheme("","","","",0,25,"","","","","48")
ClassMethod ListInScheme(searchField, searchValue, sortField, sortDir, start, limit, btc, btn, ds, tt, scheme)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,btc,btn,ds,tt,scheme)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusTarget a, dhc_bonus_data.SchemeTarget b"
	s whereStr=" WHERE IsValid=1 and a.BonusTargetID=b.BonusTargetID and b.BonusSchemeID='"_scheme_"'"
	s sortStr=""
	s sortField1=""
	i sortField="rowid" d
	.s sortField="BonusTargetID"
	i sortField="TargetTypeName" d
	.s sortField="TargetTypeID"
	i sortField="CalUnitName" d
	.s sortField="CalUnitID"
	i sortField="ParameterTargetName" d
	.s sortField="ParameterTarget"
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY b.BonusTargetID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid|BonusTargetCode|BonusTargetName|CalUnitID|CalUnitName|TargetTypeID|TargetTypeName|TargetSpell|DataSource|TargetDesc|CalculateFormula|CalculateDesc|CalculatePriority|TargetProperty|RateType|ParameterTarget|IsValid|AuditingState|AuditingDate|UpdateDate|ParameterTargetName"
	
	While(result.Next())
	{
		
		s BonusTargetID=result.Data("BonusTargetID")
		s BonusTargetCode=result.Data("BonusTargetCode")
		s BonusTargetName=result.Data("BonusTargetName")
		//w "BonusTargetName:"_BonusTargetName,!
		s CalUnitID=result.Data("CalUnitID")
		s CalUnitName=$list(^dhcbsCalUnitD(CalUnitID),3)
		s TargetTypeID=result.Data("TargetTypeID")
		s TargetTypeName=$list(^dhcbsTargetTypeD(TargetTypeID),3)
		s TargetSpell=result.Data("TargetSpell")
		s DataSource=result.Data("DataSource")
		s TargetDesc=result.Data("TargetDesc")		
		s CalculateFormula=result.Data("CalculateFormula")
		s CalculateDesc=result.Data("CalculateDesc")
		s CalculatePriority=result.Data("CalculatePriority")
		s TargetProperty=result.Data("TargetProperty")
		s RateType=result.Data("RateType")
		s ParameterTarget=result.Data("ParameterTarget")	
		s ParameterTargetName=""
		i ParameterTarget'="" d
		.i $d(^dhcbsBonusTargetD(ParameterTarget)) 
		..s ParameterTargetName=$list($g(^dhcbsBonusTargetD(ParameterTarget)),3)
		s IsValid=result.Data("IsValid")
		s AuditingState=result.Data("AuditingState")
		s AuditingDate=result.Data("AuditingDate")
		i AuditingDate'="" d
		.s AuditingDate=$zd(AuditingDate,3)
		s UpdateDate=result.Data("UpdateDate")
		i UpdateDate'="" d
		.s UpdateDate=$zd(UpdateDate,3)
	
		s tmp=BonusTargetID_"|"_BonusTargetCode_"|"_BonusTargetName_"|"_CalUnitID_"|"_CalUnitName_"|"_TargetTypeID_"|"_TargetTypeName_"|"_TargetSpell_"|"_DataSource_"|"_TargetDesc_"|"_CalculateFormula_"|"_CalculateDesc_"|"_CalculatePriority_"|"_TargetProperty_"|"_RateType_"|"_ParameterTarget_"|"_IsValid_"|"_AuditingState_"|"_AuditingDate_"|"_UpdateDate_"|"_ParameterTargetName
		//w "tmp:"_tmp,!
		
		i (btc'="")||(btn'="")||(ds'="")||(tt'="") d
		.q:(BonusTargetCode'[btc)||(BonusTargetName'[btn)||(DataSource'[ds)||(TargetTypeID'[tt)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count,"|")
 	k json
	q resultString
}

/// Creator: zhaoliguo
/// CreatDate: 2011-03-27
/// Description: 查询人员奖金核算
/// Table: dhc_bonus_data.BonusTarget
/// Input: targetType-指标类别;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusTarget).BonusTargertList("",0,25)
ClassMethod BonusTargertList(targetType, start, limit)
{
	n ( targetType,start, limit)
	
	s sqlStr=" select TargetTypeID,BonusTargetID,BonusTargetCode,BonusTargetName from dhc_bonus_data.BonusTarget "_
	" WHERE %ID>0 and IsValid=1"
	if targetType'=""  d
	.s sqlStr=sqlStr_" AND TargetTypeID ="_targetType

	s sqlStr=sqlStr_" order by BonusTargetCode"
	
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid|BonusTargetCode|BonusTargetName"
	i (targetType="")&(start=0) d
	.d json.InsertRowData("D1"_"|"_"LastMonth"_"|"_"上月")
	.d json.InsertRowData("D2"_"|"_"ThisMonth"_"|"_"本月")
	While(result.Next())
	{
		s rowid=result.Data("BonusTargetID")
		s BonusTargetCode=result.Data("BonusTargetCode")
		s BonusTargetName=result.Data("BonusTargetName")
		
	
		s tmp=rowid_"|"_BonusTargetCode_"|"_BonusTargetName
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count,"|")
 	k json
	q resultString
}

/// Creator: zhaoliguo
/// CreatDate: 2011-07-27
/// Description: 按奖金指标数据来源查询指标
/// Table: dhc_bonus_data.BonusTarget
/// Input: targetType-指标类别;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusTarget).GetTargetBySource("1",0,25)
ClassMethod GetTargetBySource(dataSource, targetType, start, limit)
{
	n ( dataSource,targetType,start, limit)
	
	s sqlStr=" select DataSource,BonusTargetID,BonusTargetCode,BonusTargetName from dhc_bonus_data.BonusTarget "_
	" WHERE %ID>0 and IsValid=1"
	if dataSource'=""  d
	.s sqlStr=sqlStr_" AND DataSource ="_dataSource
	if targetType'=""  d
	.s sqlStr=sqlStr_" AND TargetTypeID ="_targetType
	
	s sqlStr=sqlStr_" order by BonusTargetCode"
	
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid|code|name"
	
	While(result.Next())
	{
		s rowid=result.Data("BonusTargetID")
		s BonusTargetCode=result.Data("BonusTargetCode")
		s BonusTargetName=result.Data("BonusTargetName")
		s tmp=rowid_"|"_BonusTargetCode_"|"_BonusTargetName
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count,"|")
 	k json
	q resultString
}

/// Others: w ##class(dhc.bonus.udata.uBonusTarget).List("","","","",0,5,"","","","")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, btc, btn, ds, tt)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,btc,btn,ds,tt)
	
	s sqlStr="SELECT TargetTypeID->TargetTypeName,* FROM dhc_bonus_data.BonusTarget"

	//.q:(BonusTargetCode'[btc)||(BonusTargetName'[btn)||(DataSource'[ds)||(TargetTypeID'[tt)
	s whereStr=" WHERE %ID>0 and IsValid=1"
	i btc'="" d
	.s whereStr = whereStr_" and BonusTargetCode like '"_btc_"%'"
	i tt'="" d 
	.s whereStr = whereStr_" and TargetTypeID = '"_tt_"'" 
	i ds'="" d 
	.s whereStr = whereStr_" and DataSource = '"_ds_"'" 
	i btc'="" d 
	.s whereStr = whereStr_" and BonusTargetCode like '"_btc_"%'" 
	i btn'="" d 
	.s whereStr = whereStr_" and BonusTargetName like '%"_btn_"%'" 
	
	
	s sortStr=""
	s sortField1=""
	i sortField="rowid" d
	.s sortField="BonusTargetID"
	i sortField="BonusTargetCode" d
	.s sortField="BonusTargetCode"
		
	i sortField="TargetTypeName" d
	.s sortField="TargetTypeID"
	i sortField="CalUnitName" d
	.s sortField="CalUnitID"
	i sortField="ParameterTargetName" d
	.s sortField="ParameterTarget"
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY TargetTypeID,BonusTargetCode"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	k ^zlgtem
	s ^zlgtem=sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid|BonusTargetCode|BonusTargetName|CalUnitID|CalUnitName|TargetTypeID|TargetTypeName|TargetSpell|DataSource|TargetDesc|CalculateFormula|CalculateDesc|CalculatePriority|TargetProperty|RateType|ParameterTarget|IsValid|AuditingState|AuditingDate|UpdateDate|ParameterTargetName|calFlagId|calFlagName|TargetNameType|InitValue|MaxValue"
	
	While(result.Next())
	{
		s BonusTargetID=result.Data("BonusTargetID")
		s BonusTargetCode=result.Data("BonusTargetCode")
		s BonusTargetName=result.Data("BonusTargetName")
		s CalUnitID=result.Data("CalUnitID")
		s CalUnitName=$list($g(^dhcbsCalUnitD(CalUnitID)),3)
		s TargetTypeID=result.Data("TargetTypeID")
		s TargetTypeName=$list($g(^dhcbsTargetTypeD(TargetTypeID)),3)
		s TargetSpell=result.Data("TargetSpell")
		s DataSource=result.Data("DataSource")
		s TargetDesc=result.Data("TargetDesc")		
		s CalculateFormula=result.Data("CalculateFormula")
		s CalculateDesc=result.Data("CalculateDesc")
		s CalculatePriority=result.Data("CalculatePriority")
		s TargetProperty=result.Data("TargetProperty")
		s RateType=result.Data("RateType")
		s ParameterTarget=result.Data("ParameterTarget")
		s TargetTypeName=result.Data("TargetTypeName")
			
		s ParameterTargetName=""
		s ParameterTargetCode=""
		i ParameterTarget'="" d
		.i $d(^dhcbsBonusTargetD(ParameterTarget)) d
		..s ParameterTargetCode=$list($g(^dhcbsBonusTargetD(ParameterTarget)),2)
		..s ParameterTargetName=$list($g(^dhcbsBonusTargetD(ParameterTarget)),3)
		..s ParameterTargetName=ParameterTargetName_"_"_ParameterTargetCode
		s IsValid=result.Data("IsValid")
		s AuditingState=result.Data("AuditingState")
		s AuditingDate=result.Data("AuditingDate")
		i AuditingDate'="" d
		.s AuditingDate=$zd(AuditingDate,3)
		s UpdateDate=result.Data("UpdateDate")
		i UpdateDate'="" d
		.s UpdateDate=$zd(UpdateDate,3)
		
		s calFlagName="无级别"
		s calFlagId=result.Data("calFlag")
		i calFlagId="0" s calFlagName="无级别"
		i calFlagId=1 s calFlagName="人员级别"
		i calFlagId=2 s calFlagName="科室级别"
		
		s InitValue=result.Data("InitValue")
		s MaxValue=result.Data("MaxValue")
	
		s tmp=BonusTargetID_"|"_BonusTargetCode_"|"_BonusTargetName_"|"_CalUnitID_"|"_CalUnitName_"|"_TargetTypeID
		_"|"_TargetTypeName_"|"_TargetSpell_"|"_DataSource_"|"_TargetDesc_"|"_CalculateFormula_"|"_CalculateDesc
		_"|"_CalculatePriority_"|"_TargetProperty_"|"_RateType_"|"_ParameterTarget_"|"_IsValid_"|"_AuditingState
		_"|"_AuditingDate_"|"_UpdateDate_"|"_ParameterTargetName_"|"_calFlagId_"|"_calFlagName_"|"_TargetTypeName_"_"_BonusTargetName_"|"_InitValue
		_"|"_MaxValue
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count,"|")
 	k json
	q resultString
}

/// w ##class(dhc.bonus.udata.uBonusTarget).IfRepCode(12)
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusTarget where IsValid=1 and BonusTargetCode='"_code_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("BonusTargetID")
	}
	q rowid
}

/// w ##class(dhc.bonus.udata.uBonusTarget).IfRepName("b")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusTarget where IsValid=1 and BonusTargetName='"_name_"'"
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("BonusTargetID")
	}
	q rowid
}

//CalculatePriority|TargetProperty|RateType|ParameterTarget|IsValid|AuditingState|AuditingDate|UpdateDate

/// Others:w ##class(dhc.bonus.udata.uBonusTarget).Insert("a|a|1|1|a|1|a|a|a|1|1|1|1|1|1|2010-02-22|2010-02-22")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpt"      //准备插入的数据为空,退出并返回dataEmpt
	
	k PLIST
	
	s BonusTargetCode=$p(data,"|",1)          
	s tmpDr=..IfRepCode(BonusTargetCode)
	q:tmpDr'=0 "1"   
	i BonusTargetCode'="" s PLIST(2)=BonusTargetCode
	
	s BonusTargetName=$p(data,"|",2)
	//s tmpDr=..IfRepName(BonusTargetName)
	//q:tmpDr'=0 "2"  
	i BonusTargetName'="" s PLIST(3)=BonusTargetName
	
	s CalUnitID=$p(data,"|",3)
	i CalUnitID'="" s PLIST(4)=CalUnitID
	
	s TargetTypeID=$p(data,"|",4)
	i TargetTypeID'="" s PLIST(5)=TargetTypeID
	
	s TargetSpell=$p(data,"|",5)
	i TargetSpell'="" s PLIST(6)=TargetSpell
	
	s DataSource=$p(data,"|",6)
	i DataSource'="" s PLIST(7)=DataSource
	
	s TargetDesc=$p(data,"|",7)
	i TargetDesc'="" s PLIST(8)=TargetDesc
	
	s CalculateFormula=$p(data,"|",8)	
	i CalculateFormula'="" d
	.s PLIST(9)=CalculateFormula
	
	s CalculateDesc=$p(data,"|",9)
	i CalculateDesc'="" s PLIST(10)=CalculateDesc
	
	s CalculatePriority=$p(data,"|",10)
	i CalculatePriority'="" d
	.s PLIST(11)=CalculatePriority
	
	s TargetProperty=$p(data,"|",11)
	i TargetProperty'="" s PLIST(12)=TargetProperty
	
	s RateType=$p(data,"|",12)             
	i RateType'="" s PLIST(13)=RateType
	
	s ParameterTarget=$p(data,"|",13)
	i ParameterTarget'="" s PLIST(14)=ParameterTarget
	
	s IsValid=$p(data,"|",14)
	i IsValid'="" s PLIST(15)=IsValid
	
	s AuditingState=$p(data,"|",15)
	i AuditingState'="" s PLIST(16)=AuditingState
	
	s AuditingDate=$p(data,"|",16)
	i AuditingDate'="" d
	.s AuditingDate=$zdh(AuditingDate,3)
	.s PLIST(17)=AuditingDate
	
	s UpdateDate=$p(data,"|",17)
	i UpdateDate'="" d
	.s UpdateDate=$zdh(UpdateDate,3)
	.s PLIST(18)=UpdateDate
	
	s calFlag=$p(data,"|",18)
	i calFlag'="" s PLIST(19)=calFlag
	
	s InitValue=$p(data,"|",19)
	i InitValue'="" s PLIST(20)=InitValue
	
	s MaxValue=$p(data,"|",20)
	i MaxValue'="" s PLIST(21)=MaxValue
	
	&SQL(INSERT INTO dhc_bonus_data.BonusTarget VALUES PLIST())
	q SQLCODE
}

/// Others: w ##class(dhc.bonus.udata.uBonusTarget).Update(1,"b|b|2|2|a|1|a|a|a|1|1|1|1|1|1|2010-02-22|2010-02-22")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	k ^zlgtmp
	s ^zlgtmp=data
	
	k PLIST
	q:rowid="" "EmptyRowid"
	q:data="" "EmptyData"
	
	s BonusTargetCode=$p(data,"|",1)   
	s tmpDr=..IfRepCode(BonusTargetCode)
	q:(tmpDr'=0)&&(tmpDr'=rowid) "1"      
	i BonusTargetCode'="" s PLIST(2)=BonusTargetCode
	
	s BonusTargetName=$p(data,"|",2)
	//s tmpDr=..IfRepName(BonusTargetName)
	//q:(tmpDr'=0)&&(tmpDr'=rowid) "2"  
	i BonusTargetName'="" s PLIST(3)=BonusTargetName
	
	s CalUnitID=$p(data,"|",3)
	i CalUnitID'="" s PLIST(4)=CalUnitID
	
	s TargetTypeID=$p(data,"|",4)
	i TargetTypeID'="" s PLIST(5)=TargetTypeID
	
	s TargetSpell=$p(data,"|",5)
	i TargetSpell'="" s PLIST(6)=TargetSpell
	
	s DataSource=$p(data,"|",6)
	i DataSource'="" s PLIST(7)=DataSource
	
	s TargetDesc=$p(data,"|",7)
	;i TargetDesc'="" s PLIST(8)=TargetDesc
	s PLIST(8)=TargetDesc
	
	s CalculateFormula=$p(data,"|",8)	
	i CalculateFormula'="" d
	.s PLIST(9)=CalculateFormula
	
	s CalculateDesc=$p(data,"|",9)
	i CalculateDesc'="" s PLIST(10)=CalculateDesc
	
	s CalculatePriority=$p(data,"|",10)
	i CalculatePriority'="" d
	.s PLIST(11)=CalculatePriority
	
	s TargetProperty=$p(data,"|",11)
	i TargetProperty'="" s PLIST(12)=TargetProperty
	
	s RateType=$p(data,"|",12)             
	i RateType'="" s PLIST(13)=RateType
	
	s ParameterTarget=$p(data,"|",13)
	i ParameterTarget'="" s PLIST(14)=ParameterTarget
	
	s IsValid=$p(data,"|",14)
	i IsValid'="" s PLIST(15)=IsValid
	
	s AuditingState=$p(data,"|",15)
	i AuditingState'="" s PLIST(16)=AuditingState
	
	s AuditingDate=$p(data,"|",16)
	i AuditingDate'="" d
	.s AuditingDate=$zdh(AuditingDate,3)
	.s PLIST(17)=AuditingDate
	
	s UpdateDate=$p(data,"|",17)
	i UpdateDate'="" d
	.s UpdateDate=$zdh(UpdateDate,3)
	.s PLIST(18)=UpdateDate
	
	s calFlag=$p(data,"|",18)
	i calFlag'="" s PLIST(19)=calFlag
	
	s InitValue=$p(data,"|",19)
	;i InitValue'="" s PLIST(20)=InitValue
	s PLIST(20)=InitValue
	
	s MaxValue=$p(data,"|",20)
	;i MaxValue'="" s PLIST(21)=MaxValue
	s PLIST(21)=MaxValue
	
	&SQL(UPDATE dhc_bonus_data.BonusTarget VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/*
// Others: w ##class(dhc.bonus.udata.uBonusTarget).Del(2)
ClassMethod Del(rowid) As %String
{
	n (rowid)
	//&SQL(DELETE FROM dhc_bonus_data.BonusTarget WHERE %ID=:rowid)
	s TargetCode=$list(^dhcbsBonusTargetD(rowid),",",2)
	
	s sqlStr="select %ID rowid from dhc_bonus_data.SchemeTarget WHERE BonusTargetID="_rowid_" and BonusTargetID->IsValid = 1"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid1=""
	;w sqlStr,!
	While(result.Next()){
	
		s rowid1=result.Data("rowid")
		;w "0000",!
	}
	;w "rowid1:"_rowid1,!
	q:rowid1'="" "1" 
	
	
	k PLIST
	s PLIST(15)=0
	&SQL(UPDATE dhc_bonus_data.BonusTarget VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}


/// w ##class(dhc.bonus.udata.uBonusTarget).IfRepTargetCode("02002")
ClassMethod IfRepTargetCode(TargetCode) As %String
{
	n (TargetCode)
	//dhc.bonus.data.SchemeTarget
	s sqlStr="select %ID rowid from dhc_bonus_data.SchemeTarget WHERE BonusTargetID->BonusTargetCode='"_TargetCode_"'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid1="aa"
	w sqlStr,!
	While(result.Next()){
	
		s rowid1=result.Data("rowid")
		w "0000",!
	}
	
	d result.Close()
	
	q rowid1
}
*/
/// Others: w ##class(dhc.bonus.udata.uBonusTarget).Del(9)
ClassMethod Del(rowid) As %String
{
	n (rowid)
	s TargetCode=$list(^dhcbsBonusTargetD(rowid),2)
	;w "TargetCode:"_TargetCode,!
	s tmpDr=..IfRepTargetCode(TargetCode)
	;W "tmpDr:"_tmpDr,!
	q:tmpDr'=0 "1" 
	k PLIST
	s PLIST(15)=0
	&SQL(UPDATE dhc_bonus_data.BonusTarget VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.udata.uBonusTarget).IfRepTargetCode("01010")
ClassMethod IfRepTargetCode(TargetCode) As %String
{
	n (TargetCode)

	s sqlStr="select * from dhc_bonus_data.BonusSchemeItem WHERE BonusFormula LIKE '%"_TargetCode_"%' AND IsValid=1"

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	;w sqlStr,!
	While(result.Next()){

	s rowid=result.Data("BonusSchemeItemID")

	}

	d result.Close()

	q rowid
}

/// Others: w ##class(dhc.bonus.udata.uBonusTarget).TargetTypeList("","","","",0,25)
ClassMethod TargetTypeList(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.TargetType"
	
	_" WHERE %ID>0 and IsValid=1 order by cast(TargetTypeCode as int)"

	
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^TargetTypeCode^TargetTypeName^IsValid"
	
	While(result.Next())
	{
		s TargetTypeID=result.Data("TargetTypeID")
		s TargetTypeCode=result.Data("TargetTypeCode")
		s TargetTypeName=result.Data("TargetTypeName")
		s IsValid=result.Data("IsValid")
		
		s tmp=TargetTypeID_"^"_TargetTypeCode_"^"_TargetTypeCode_"_"_TargetTypeName_"^"_IsValid
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Others: w ##class(dhc.bonus.udata.uBonusTarget).CalUnitList("","","","",0,25)
ClassMethod CalUnitList(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.CalUnit"
	
	s whereStr=" WHERE %ID>0 and IsValid=1"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^CalUnitCode^CalUnitName^IsValid"
	
	While(result.Next())
	{
		s CalUnitID=result.Data("CalUnitID")
		s CalUnitCode=result.Data("CalUnitCode")
		s CalUnitName=result.Data("CalUnitName")
		s IsValid=result.Data("IsValid")
		
		s tmp=CalUnitID_"^"_CalUnitCode_"^"_CalUnitName_"^"_IsValid
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// 获取奖金核算单元
/// Others: w ##class(dhc.bonus.udata.uBonusTarget).GetUnit("",0,25)
ClassMethod GetUnit(str, start, limit)
{
	n (str,start,limit)
	
	s sqlStr="SELECT BonusUnitID,BonusUnitCode,BonusUnitName FROM dhc_bonus_data.BonusUnit WHERE BonusUnitCode NOT LIKE 'H%'"
            _"AND SuperiorUnitID<>0"
	
	i str'="" s sqlStr=sqlStr_" AND (BonusUnitName like '%"_str _"%' OR BonusUnitCode like '%"_str _"%') "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	While(result.Next())
	{
		s BonusUnitID=result.Data("BonusUnitID")
		s BonusUnitName=result.Data("BonusUnitName")	
		s tmp=BonusUnitID_"^"_BonusUnitName
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// 获取奖金方案下的核算单元
/// Others: w ##class(dhc.bonus.udata.uBonusTarget).GetUnit1("",1,0,25)
ClassMethod GetUnit1(str, Schemerowid, start, limit)
{
	n (str,Schemerowid,start,limit)
	s sqlStr="SELECT BonusUnitID,BonusUnitID->BonusUnitName as BonusUnitName  FROM dhc_bonus_data.BonusSchemeUnit WHERE BonusSchemeID=:Schemerowid"
	
	i str'="" s sqlStr=sqlStr_" AND (BonusUnitID->BonusUnitName like '%"_str _"%') "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	While(result.Next())
	{
		s BonusUnitID=result.Data("BonusUnitID")
		s BonusUnitName=result.Data("BonusUnitName")	
		s tmp=BonusUnitID_"^"_BonusUnitName
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uBonusTargetS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
