Class dhc.bonus.udata.uBonusSchemeAdjust Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.bonus.udata.uBonusSchemeAdjust).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusSchemeAdjust a,dhc_bonus_data.SchemeAdjustTarget b"
	
	s whereStr=" WHERE  a.BonusSchemeAdjustID=b.BonusSchemeAdjustID"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="a.BonusSchemeAdjustID"
	.i sortField="BonusSchemeName" s sortField1="a.BonusSchemeAdjustID"
	.i sortField="BonusPeriod" s sortField1="a.BonusPeriod"
	.i sortField="BonusYear" s sortField1="a.BonusYear"
	.i sortField="AdjustDesc" s sortField1="a.AdjustDesc"
	.i sortField="AdjustDate" s sortField1="a.AdjustDate"
	.i sortField="BonusTargetName" s sortField1="a.BonusSchemeAdjustID"
	
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER by a.%id"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^BonusSchemeID^BonusSchemeCode^BonusSchemeName^BonusPeriod^BonusYear^AdjustDesc^AdjustDate^BonusTargetID^BonusTargetCode^BonusTargetName^rowid2"
	
	While(result.Next())
	{
		s BonusSchemeAdjustID=result.Data("BonusSchemeAdjustID")
		s BonusSchemeID=result.Data("BonusSchemeID")
		s BonusSchemeCode=$list(^dhcbsBonusSchemeD(BonusSchemeID),2)
		s BonusSchemeName=$list(^dhcbsBonusSchemeD(BonusSchemeID),3)
		s BonusSchemeState=$list(^dhcbsBonusSchemeD(BonusSchemeID),9)
		s BonusSchemeValid=$list(^dhcbsBonusSchemeD(BonusSchemeID),12)
		;w BonusSchemeState,",",BonusSchemeValid,!
		s BonusPeriod=result.Data("BonusPeriod")
		s BonusYear=result.Data("BonusYear")
		s AdjustDesc=result.Data("AdjustDesc")		
		s AdjustDate=result.Data("AdjustDate")
		i AdjustDate'="" d
		.s AdjustDate=$zd(AdjustDate,3)
		s SchemeAdjustTargetID=result.Data("SchemeAdjustTargetID")
		s BonusTargetID=result.Data("BonusTargetID")
		s BonusTargetCode=""
		s BonusTargetName=""
		i (BonusTargetID'="")&&($g(^dhcbsBonusTargetD(BonusTargetID))'="") d
		.s BonusTargetCode=$list(^dhcbsBonusTargetD(BonusTargetID),2)
		.s BonusTargetName=$list(^dhcbsBonusTargetD(BonusTargetID),3)
		
		s tmp=BonusSchemeAdjustID_"^"_BonusSchemeID_"^"_BonusSchemeCode_"^"_BonusSchemeName_"^"_BonusPeriod_"^"_BonusYear_"^"_AdjustDesc_"^"_AdjustDate_"^"_BonusTargetID_"^"_BonusTargetCode_"^"_BonusTargetName_"^"_SchemeAdjustTargetID
		/*
		i searchValue'="" d
		.q:(searchField="BonusSchemeID")&(BonusSchemeID'[searchValue)
		.q:(searchField="BonusSchemeCode")&(BonusSchemeCode'[searchValue)
		.q:(searchField="BonusSchemeName")&(BonusSchemeName'[searchValue)
		.q:(searchField="SchemeDesc")&(SchemeDesc'[searchValue)
		.q:(searchField="SchemeType")&(SchemeType'[searchValue)
		.q:(searchField="CreatePerson")&(CreatePerson'[searchValue)
		.q:(searchField="AdjustPerson")&(AdjustPerson'[searchValue)
		.q:(searchField="SchemeState")&(SchemeState'[searchValue)
		.q:(searchField="AdjustDate")&(AdjustDate'[searchValue)
		.q:(searchField="AuditingPerson")&(AuditingPerson'[searchValue)
		.q:(searchField="AuditingDate")&(AuditingDate'[searchValue)
		.q:(searchField="IsValid")&(IsValid'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d*/
		i (count>=start)&&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

//BonusSchemeID^BonusPeriod^BonusYear^AdjustDesc^AdjustDate^BonusTargetID

/// Others:w ##class(dhc.bonus.udata.uBonusSchemeAdjust).Insert("1^a^a^a^2010-02-22^1")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpt"      //准备插入的数据为空,退出并返回dataEmpt
	
	k PLIST
	
	s BonusSchemeID=$p(data,"^",1)             
	i BonusSchemeID'="" s PLIST(2)=BonusSchemeID
	
	//修改BonusSchemeState=2
	s $list(^dhcbsBonusSchemeD(BonusSchemeID),9)=2
	
	s BonusPeriod=$p(data,"^",2)
	i BonusPeriod'="" s PLIST(3)=BonusPeriod
	
	s BonusYear=$p(data,"^",3)
	i BonusYear'="" s PLIST(4)=BonusYear
	
	s AdjustDesc=$p(data,"^",4)
	i AdjustDesc'="" s PLIST(5)=AdjustDesc
	
	s AdjustDate=$p(data,"^",5)
	i AdjustDate'="" d
	.s AdjustDate=$zdh(AdjustDate,3)
	.s PLIST(6)=AdjustDate
	
	&SQL(INSERT INTO dhc_bonus_data.BonusSchemeAdjust VALUES PLIST())
	
	k PLIST
	
	s BonusSchemeAdjustID=%ROWID
	i BonusSchemeAdjustID'="" s PLIST(2)=BonusSchemeAdjustID
	
	s BonusTargetID=$p(data,"^",6)
	i BonusTargetID'="" s PLIST(3)=BonusTargetID
	
	&SQL(INSERT INTO dhc_bonus_data.SchemeAdjustTarget VALUES PLIST())
	
	q SQLCODE
}

/// Others: w ##class(dhc.bonus.udata.uBonusSchemeAdjust).Update(6,1,"1^11^2010^desc^2010-02-22^2")
ClassMethod Update(rowid, rowid2, data) As %String
{
	n (rowid,rowid2, data)
	k PLIST
	q:rowid="" "EmptyRowid"
	q:data="" "EmptyData"
	
	s BonusSchemeID=$p(data,"^",1)             
	i BonusSchemeID'="" s PLIST(2)=BonusSchemeID
	
	s BonusPeriod=$p(data,"^",2)
	i BonusPeriod'="" s PLIST(3)=BonusPeriod
	
	s BonusYear=$p(data,"^",3)
	i BonusYear'="" s PLIST(4)=BonusYear
	
	s AdjustDesc=$p(data,"^",4)
	i AdjustDesc'="" s PLIST(5)=AdjustDesc
	
	s AdjustDate=$p(data,"^",5)
	i AdjustDate'="" d
	.s AdjustDate=$zdh(AdjustDate,3)
	.s PLIST(6)=AdjustDate
	
	&SQL(UPDATE dhc_bonus_data.BonusSchemeAdjust VALUES PLIST() where %ID=:rowid)
	
	k PLIST
	
	s BonusSchemeAdjustID=rowid
	i BonusSchemeAdjustID'="" s PLIST(2)=BonusSchemeAdjustID
	
	s BonusTargetID=$p(data,"^",6)
	i BonusTargetID'="" s PLIST(3)=BonusTargetID
	
	&SQL(UPDATE dhc_bonus_data.SchemeAdjustTarget VALUES PLIST() where %ID=:rowid2)
	
	q SQLCODE
}

/// Others: w ##class(dhc.bonus.udata.uBonusSchemeAdjust).Del(6,1)
ClassMethod Del(rowid, rowid2) As %String
{
	n (rowid,rowid2)
	&SQL(DELETE FROM dhc_bonus_data.BonusSchemeAdjust WHERE %ID=:rowid)
	&SQL(DELETE FROM dhc_bonus_data.SchemeAdjustTarget WHERE %ID=:rowid2)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusScheme73CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
