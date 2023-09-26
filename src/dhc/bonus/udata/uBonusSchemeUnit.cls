Class dhc.bonus.udata.uBonusSchemeUnit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock, StorageStrategy = "" ]
{

/// Others: w ##class(dhc.bonus.udata.uBonusSchemeUnit).GetUnitList(204,0,10)
ClassMethod GetUnitList(supUnitID, start, limit)
{
	n (supUnitID,start,limit)

	s sqlStr="SELECT %ID rowid,BonusUnitCode,BonusUnitName FROM dhc_bonus_data.BonusUnit WHERE 1=1"
	i supUnitID'=-1 s sqlStr=sqlStr_" AND  SuperiorUnitID="_supUnitID
    ;i str'="" s sqlStr=sqlStr_" AND  BonusUnitName LIKE '%"_str_"%'  "
	s result=##class(%Library.ResultSet).%New()
	;w sqlStr,!

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	While(result.Next())
	{
		s rowid=result.Data("rowid")
		s code=result.Data("BonusUnitCode")
		s name=result.Data("BonusUnitName")
		
		s tmp=rowid_"^"_code_"_"_name
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
    k json
	q resultString
}

/// Others: w ##class(dhc.bonus.udata.uBonusSchemeUnit).BonusUnitList("","","","",0,10,1)
ClassMethod BonusUnitList(searchField, searchValue, sortField, sortDir, start, limit, type)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,type)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusUnit"
	s whereStr=""
	i type=1 d
	.s whereStr=" WHERE %ID>0 and IsValid=1 and LastStage=0 and BonusUnitTypeID="_type
	e  d
	.s whereStr=" WHERE %ID>0 and IsValid=1 and LastStage=1 and BonusUnitTypeID="_type
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY cast( BonusUnitCode as int)"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	;w sqlStr,!
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	While(result.Next())
	{
		s rowid=result.Data("BonusUnitID")
		s code=result.Data("BonusUnitCode")
		s name=result.Data("BonusUnitName")
		
		s tmp=rowid_"^"_code_"_"_name
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 k json
	q resultString
}

/// Others: w ##class(dhc.bonus.udata.uBonusSchemeUnit).BonusUnitTypeList("","","","",0,25)
ClassMethod BonusUnitTypeList(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusUnitType"
	
	s whereStr=" WHERE %ID>0 and IsValid=1"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY Cast(UnitTypeCode as int)"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	While(result.Next())
	{
		s rowid=result.Data("BonusUnitTypeID")
		s name=result.Data("UnitTypeName")
		s UnitTypeCode=result.Data("UnitTypeCode")
		
		s tmp=rowid_"^"_UnitTypeCode_"_"_name
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 k json
	q resultString
}

/// w ##class(dhc.bonus.udata.uBonusSchemeUnit).Del(4)
ClassMethod Del(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_bonus_data.BonusSchemeUnit WHERE %ID=:rowid)

	q SQLCODE
}

/// w ##class(dhc.bonus.udata.uBonusSchemeUnit).IfRep(13,1)
ClassMethod IfRep(schemeDr, unitDr) As %String
{
	n (schemeDr,unitDr)
	s rowid=0	
	s sdr=0
	s udr=0
	s pre=0
	f  s rowid=$o(^dhcbsBonusSchemeUnitD(rowid)) q:(rowid="")||((sdr=schemeDr)&&(udr=unitDr))  d
	.s sdr=$list(^dhcbsBonusSchemeUnitD(rowid),2)
	.s udr=$list(^dhcbsBonusSchemeUnitD(rowid),3)
	.s pre=rowid
	i (rowid="")&&'((sdr=schemeDr)&&(udr=unitDr)) d
	.s pre=0
	q pre
}

/// w ##class(dhc.bonus.udata.uBonusSchemeUnit).Insert("1^1")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpt"      //准备插入的数据为空,退出并返回dataEmpt
	
	k PLIST
	
	s BonusSchemeID=$p(data,"^",1)             
	i BonusSchemeID'="" s PLIST(2)=BonusSchemeID
	
	s BonusUnitID=$p(data,"^",2)
	i BonusUnitID'="" s PLIST(3)=BonusUnitID
	
	s tmpDr=..IfRep(BonusSchemeID,BonusUnitID)
	q:tmpDr'=0 "1"
	
	&SQL(INSERT INTO dhc_bonus_data.BonusSchemeUnit VALUES PLIST())
	q SQLCODE
}

/// w ##class(dhc.bonus.udata.uBonusSchemeUnit).List("","","","",0,25,1)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, scheme)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,scheme)
	
	s sqlStr="SELECT b.SuperiorUnitID,b.SuperiorUnitID->BonusUnitName supUnitName"
	_",b.BonusUnitCode,b.BonusUnitName,a.* FROM dhc_bonus_data.BonusSchemeUnit"
	_" a,dhc_bonus_data.BonusUnit b where a.BonusUnitID= b.BonusUnitID"
	s whereStr=" and a.%ID>0 and a.BonusSchemeID="_scheme
	s sortStr=""
	s sortField1=""
	s sortField="" 

	i sortField'="" d
	.i sortField="BonusUnitCode" s sortField1=" BonusUnitID->BonusUnitCode"
	.i sortField="BonusUnitName" s sortField1="BonusUnitID->BonusUnitName"
	.i sortField="BonusUnitTypeName" s sortField1="BonusUnitTypeID->UnitTypeName"
	.i sortField="SuperUnitName" s sortField1="BonusUnitID->SuperiorUnitID"
	
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY BonusSchemeID, b.BonusUnitID"
	
	s sqlStr=sqlStr_whereStr_sortStr
	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()

	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^BonusSchemeID^BonusSchemeCode^BonusSchemeName^BonusUnitID^BonusUnitCode^BonusUnitName^BonusUnitTypeID^BonusUnitTypeName^SuperUnitName^SuperiorUnitID"
	
	While(result.Next())
	{
		s BonusSchemeUnitID=result.Data("BonusSchemeUnitID")
		s BonusSchemeID=result.Data("BonusSchemeID")
		s BonusSchemeCode=$list(^dhcbsBonusSchemeD(BonusSchemeID),2)
		s BonusSchemeName=$list(^dhcbsBonusSchemeD(BonusSchemeID),3)
		s BonusUnitID=result.Data("BonusUnitID")
		s supUnitName=result.Data("supUnitName")
		s SuperiorUnitID=result.Data("SuperiorUnitID")

		s BonusUnitCode=result.Data("BonusUnitCode") 
		s BonusUnitName=result.Data("BonusUnitName") 
		s SuperUnitName=""
		s SuperUnitName=result.Data("supUnitName")
		s BonusUnitTypeID=$list(^dhcbsBonusUnitD(BonusUnitID),11)
		s BonusUnitTypeName=""
	
		i BonusUnitTypeID>0 d
		.s BonusUnitTypeName=$list(^dhcbsBonusUnitTypeD(BonusUnitTypeID),3)
		
		s tmp=BonusSchemeUnitID_"^"_BonusSchemeID_"^"_BonusSchemeCode_"^"_BonusSchemeName_"^"_BonusUnitID_"^"_BonusUnitCode_"^"_BonusUnitName_"^"_BonusUnitTypeID_"^"_BonusUnitTypeName_"^"_SuperUnitName_"^"_SuperiorUnitID
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 k json
	q resultString
}

/// w ##class(dhc.bonus.udata.uBonusSchemeUnit).Update(2741,"3^848")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	k PLIST
	q:rowid="" "EmptyRowid"
	q:data="" "EmptyData"
	
	s BonusSchemeID=$p(data,"^",1)             
	//i BonusSchemeID'="" s PLIST(2)=BonusSchemeID
	
	s BonusUnitID=$p(data,"^",2)
	i BonusUnitID'="" s PLIST(3)=BonusUnitID
	
	s tmpRowid=..IfRep(BonusSchemeID,BonusUnitID)
	q:(tmpRowid'=0)&&(tmpRowid'=rowid) "1"
		
	&SQL(UPDATE dhc_bonus_data.BonusSchemeUnit VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusScheme671S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
