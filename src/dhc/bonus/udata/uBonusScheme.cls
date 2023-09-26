Class dhc.bonus.udata.uBonusScheme Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.bonus.udata.uBonusScheme).List("SchemeType","1","","",0,25,"","")
/// Others: w ##class(dhc.bonus.udata.uBonusScheme).List("SchemeType","","","",0,25,"","")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, type, state)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,type,state)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusScheme"
	
	s whereStr=" WHERE %ID>0 and IsValid=1 "
	i type'="" d
	.s whereStr=whereStr_" and SchemeType="_type
	i (state="0")||(state="1")||(state="2") d
	.s whereStr=whereStr_" and SchemeState="_state
	i state="3" d
	.s whereStr=whereStr_" and SchemeState!=1"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.;i sortField="rowid" s sortField1="BonusSchemeID"
	.i sortField="code" s sortField1="BonusSchemeCode"
	.i sortField="name" s sortField1="BonusSchemeName"
	.i sortField="desc" s sortField1="SchemeDesc"
	.i sortField="auditingDate" s sortField1="AuditingDate"
	.i sortField="type" s sortField1="SchemeType"
	.i sortField="schemeState" s sortField1="SchemeState"
	.i sortField="Priority" s sortField1="Priority"
	i (sortField'="") && (sortField'="rowid")  d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY SchemeType,BonusSchemeCode,Priority"
	
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
	s jsonTitle="rowid^code^name^desc^SchemeTypeID^SchemeTypeName^createPerson^adjustPerson^schemeState^adjustDate^auditingPerson^auditingDate^isValid^Priority^CalculateFlag"
	
	While(result.Next())
	{
		s BonusSchemeID=result.Data("BonusSchemeID")
		s BonusSchemeCode=result.Data("BonusSchemeCode")
		s BonusSchemeName=result.Data("BonusSchemeName")
		s SchemeDesc=result.Data("SchemeDesc")
		
		s SchemeType=result.Data("SchemeType")
		//w SchemeType,!
		s SchemeTypeName= $LIST( ^dhcbsSchemeTypeD(SchemeType),3)
		
		s CreatePerson=result.Data("CreatePerson")
		s AdjustPerson=result.Data("AdjustPerson")
		s SchemeState=result.Data("SchemeState")		
		s AdjustDate=result.Data("AdjustDate")
		i AdjustDate'="" d
		.s AdjustDate=$zd(AdjustDate,3)
		s AuditingPerson=result.Data("AuditingPerson")
		s AuditingDate=result.Data("AuditingDate")
		i AuditingDate'="" d
		.s AuditingDate=$zd(AuditingDate,3)
		s IsValid = result.Data("IsValid")
		s Priority  = result.Data("Priority")
		
		s CalculateFlag  = result.Data("CalculateFlag")
		i CalculateFlag="1"  s CalculateFlag="独立核算"
		i CalculateFlag="2"  s CalculateFlag="混合核算"
	
		s tmp=BonusSchemeID_"^"_BonusSchemeCode_"^"_BonusSchemeName_"^"_SchemeDesc_"^"_SchemeType_"^"_SchemeTypeName_"^"_CreatePerson_"^"_AdjustPerson_"^"_SchemeState_"^"_AdjustDate_"^"_AuditingPerson_"^"_AuditingDate_"^"_IsValid_"^"_Priority_"^"_CalculateFlag
		
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
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.udata.uBonusScheme).IfRepCode(12)
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusScheme where IsValid=1 and BonusSchemeCode='"_code_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("BonusSchemeID")
	}
	q rowid
}

/// Others:w ##class(dhc.bonus.udata.uBonusScheme).Insert("1^Name1^Desc1^1^CP1^AP1^1^2010-02-22^AP1^2010-02-22^1")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpt"      //准备插入的数据为空,退出并返回dataEmpt
	
	k PLIST
	
	s Code=$p(data,"^",1)           
	s tmpDr=..IfRepCode(Code)
	q:tmpDr'=0 "1"     
	i Code'="" s PLIST(2)=Code
	
	s Name=$p(data,"^",2)
	i Name'="" s PLIST(3)=Name
	
	s Desc=$p(data,"^",3)
	i Desc'="" s PLIST(4)=Desc
	
	s Type=$p(data,"^",4)
	i Type'="" s PLIST(5)=Type
	
	s CreatePerson=$p(data,"^",5)
	i CreatePerson'="" s PLIST(6)=CreatePerson
	
	s AdjustPerson=$p(data,"^",6)
	i AdjustPerson'="" s PLIST(7)=AdjustPerson
	
	s SchemeState=$p(data,"^",7)
	i SchemeState'="" s PLIST(8)=SchemeState
	
	s AdjustDate=$p(data,"^",8)	
	i AdjustDate'="" d
	.s AdjustDate=$zdh(AdjustDate,3)
	.s PLIST(9)=AdjustDate
	
	s AuditingPerson=$p(data,"^",9)
	i AuditingPerson'="" s PLIST(10)=AuditingPerson
	
	s AuditingDate=$p(data,"^",10)
	i AuditingDate'="" d
	.s AuditingDate=$zdh(AuditingDate,3)
	.s PLIST(11)=AuditingDate
	
	s IsValid=$p(data,"^",11)
	i IsValid'="" s PLIST(12)=IsValid
	
	s priority=$p(data,"^",12)
	i priority'="" s PLIST(13)=priority
	
	s CalculateFlag=$p(data,"^",13)
    i CalculateFlag'="" s PLIST(16)=CalculateFlag
	
	
	&SQL(INSERT INTO dhc_bonus_data.BonusScheme VALUES PLIST())
	q SQLCODE
}

/// Others: w ##class(dhc.bonus.udata.uBonusScheme).Update(10,"cs07^测试7^测试7^2^demo^^0^^^^1^1^2")
/// Others: w ##class(dhc.bonus.udata.uBonusScheme).Update(10,"cs07^测试77^测试7^2^demo^^0^^^^1^1^混合核算")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	k PLIST
	q:rowid="" "EmptyRowid"
	q:data="" "EmptyData"
	
	s Code=$p(data,"^",1)    
	s tmpDr=..IfRepCode(Code)
	q:(tmpDr'=0)&&(tmpDr'=rowid) "1"               
	i Code'="" s PLIST(2)=Code
	
	s Name=$p(data,"^",2)
	i Name'="" s PLIST(3)=Name
	
	s Desc=$p(data,"^",3)
	;i Desc'="" 
	s PLIST(4)=Desc
	
	s Type=$p(data,"^",4)
	i Type'="" s PLIST(5)=Type
	
	s CreatePerson=$p(data,"^",5)
	i CreatePerson'="" s PLIST(6)=CreatePerson
	
	s AdjustPerson=$p(data,"^",6)
	i AdjustPerson'="" s PLIST(7)=AdjustPerson
	
	s SchemeState=$p(data,"^",7)
	i SchemeState'="" s PLIST(8)=SchemeState
	
	s AdjustDate=$p(data,"^",8)
	i AdjustDate'="" d
	.s AdjustDate=$zdh(AdjustDate,3)
	.s PLIST(9)=AdjustDate
	
	s AuditingPerson=$p(data,"^",9)
	i AuditingPerson'="" s PLIST(10)=AuditingPerson
	
	s AuditingDate=$p(data,"^",10)
	i AuditingDate'="" d
	.s AuditingDate=$zdh(AuditingDate,3)
	.s PLIST(11)=AuditingDate
	
	s IsValid=$p(data,"^",11)
	i IsValid'="" s PLIST(12)=IsValid
	
    s priority=$p(data,"^",12)
	;i priority'="" s PLIST(13)=priority
	s PLIST(13)=priority
	
	s CalculateFlag=$p(data,"^",13)
    ;i CalculateFlag'="" s PLIST(16)=CalculateFlag
    i CalculateFlag="独立核算" d
	.s CalculateFlag="1"
	.s PLIST(16)=CalculateFlag
	i CalculateFlag="混合核算" d
	.s CalculateFlag="2"
	.s PLIST(16)=CalculateFlag
	e  d
	.s PLIST(16)=CalculateFlag
    
	;s ^gjtemp0726=rowid_","_data
	
	&SQL(UPDATE dhc_bonus_data.BonusScheme VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// 删除
/// Others: w ##class(dhc.bonus.udata.uBonusScheme).Del(rowid)
ClassMethod Del(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM dhc_bonus_data.BonusScheme WHERE %ID=:rowid)
	k PLIST
	s PLIST(16)=0
	q SQLCODE
}

/// Others: w ##class(dhc.bonus.udata.uBonusScheme).Audit(16,"demo","2009-09-09")
ClassMethod Audit(rowid, person, date) As %String
{
	n (rowid,person,date)
	k PLIST
	q:rowid="" "EmptyRowid"
	
	s PLIST(8)=1
	s PLIST(10)=person
	s date=$zdh(date,3)
	s PLIST(11)=date
	&SQL(UPDATE dhc_bonus_data.BonusScheme VALUES PLIST() where %ID=:rowid)
	/*
	&SQL(DELETE FROM dhc_bonus_data.SchemeTarget where BonusSchemeID=:rowid)
	
	s TCs=..findCodes(rowid)
	s cur=2
	f  s tC=$p(TCs,"^",cur) q:tC=""  d
	.s cur=cur+1
	.s tDr=..targetCode2Dr(tC)
	.i ..IfRepDr(tDr,rowid)=0 d
	..k PLIST
	..s PLIST(2)=tDr
	..s PLIST(3)=rowid
	..&SQL(INSERT INTO dhc_bonus_data.SchemeTarget VALUES PLIST())
	*/
	q 0
}

ClassMethod cancelAudit(rowid, person, date) As %String
{
	n (rowid,person,date)
	k PLIST
	q:rowid="" "EmptyRowid"
	
	s PLIST(8)=0
	s PLIST(10)=person
	s date="" ;$zdh(date,3)
	s PLIST(11)=date
	&SQL(UPDATE dhc_bonus_data.BonusScheme VALUES PLIST() where %ID=:rowid)

	q 0
}

/// w ##class(dhc.bonus.udata.uBonusScheme).IfRepDr(27,16)
ClassMethod IfRepDr(tDr, sDr) As %String
{
	n (tDr,sDr)
	s rowid=""
	s flag=0
	s tarDr=""
	s schDr=""
	f  s rowid=$o(^dhcbsSchemeTargetD(rowid)) q:(rowid="")||((tarDr=tDr)&&(schDr=sDr))  d
	.s tarDr=$list(^dhcbsSchemeTargetD(rowid),3)
	.s schDr=$list(^dhcbsSchemeTargetD(rowid),2)
	.;w tarDr,",",schDr,!
	i (tarDr=tDr)&&(schDr=sDr) d
	.s flag=1
	q flag
}

/// w ##class(dhc.bonus.udata.uBonusScheme).formu2Codes("^T001^+^T002^+^T001")
ClassMethod formu2Codes(formula) As %String
{
	n (formula)
	s cur=2
	s tmpP=""
	s tmpTs=""
	f  s tmpP=$p(formula,"^",cur) q:tmpP=""  d
	.s cur=cur+1
	.s tmpT=$p(tmpP,"T",2)
	.if tmpT'="" d
	..i tmpTs="" d
	...s tmpTs=tmpT
	..e  d
	...s tmpTs=tmpTs_"^"_tmpT
	q tmpTs
}

/// Others: w ##class(dhc.bonus.udata.uBonusScheme).findCodesInTarget("005",16)
ClassMethod findCodesInTarget(code, schemeDr) As %String
{
	n (code,schemeDr)
	s r=""
	s dr=..targetCode2Dr(code)
	;w dr,",",$list(^dhcbsBonusTargetD(dr),7),!
	i (2=$list(^dhcbsBonusTargetD(dr),7)) d
	.s formula=$list(^dhcbsBonusTargetD(dr),9)
	.s subCs=..formu2Codes(formula)
	.s cur=1
	.f  s sC=$p(subCs,"^",cur) q:sC=""  d
	..s cur=cur+1
	..s r=r_sC
	..s r=r_"^"_..findCodesInTarget(sC,schemeDr)
	e  i (3=$list(^dhcbsBonusTargetD(dr),7)) d   //dr,schemeDr
	.;s sDr=$list(^dhcbsBonusTargetD(dr),14)
	.;s sC=$list(^dhcbsBonusTargetD(sDr),2)
	.;s r=r_sC
	.;s r=r_"^"_..findCodesInTarget(sC,schemeDr)
	.;w dr,",",schemeDr,!
	.s tmpD=""
	.f  s tmpD=$o(^dhcbsTargetCalculateRateI("TargetScheme",dr,schemeDr,tmpD)) q:tmpD=""  d
	..;w tmpD,!
	..s sDr= $list(^dhcbsTargetCalculateRateD(tmpD),19)
	..s sC=$list(^dhcbsBonusTargetD(sDr),2)
	..s r=r_sC
	..s r=r_"^"_..findCodesInTarget(sC,schemeDr)
	q r
}

/// Others: w ##class(dhc.bonus.udata.uBonusScheme).findCodesInScheme(16)
ClassMethod findCodesInScheme(schemeDr) As %String
{
	n (schemeDr)
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusSchemeItem WHERE %ID>0 and IsValid=1 and BonusSchemeID="_schemeDr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s r=""
	While(result.Next())
	{
		s BonusFormula=result.Data("BonusFormula")
		i BonusFormula'="" d
		.s r=r_"^"_..formu2Codes(BonusFormula)
	}
	q r
}

/// Others: w ##class(dhc.bonus.udata.uBonusScheme).findCodes(16)
ClassMethod findCodes(schemeDr) As %String
{
	n (schemeDr)
	s t=..findCodesInScheme(schemeDr)
	s r=t
	s cur=2
	f  s tC=$p(t,"^",cur) q:tC=""  d
	.s cur=cur+1
	.i ..findCodesInTarget(tC,schemeDr)'="" d
	..s r=r_"^"_..findCodesInTarget(tC,schemeDr)
	q r
}

/// Others: w ##class(dhc.bonus.udata.uBonusScheme).targetCode2Dr("")
ClassMethod targetCode2Dr(code) As %String
{
	n (code)
	s rowid=""
	s tmpPre=""
	s BTCode=""
	f  s rowid=$o(^dhcbsBonusTargetD(rowid)) q:(rowid="")||(BTCode=code)  d
	.s BTCode=$List(^dhcbsBonusTargetD(rowid),2)
	.s tmpPre=rowid
	i (rowid="")&&(BTCode'=code) d
	.s tmpPre=""
	q tmpPre
}

ClassMethod schemeTargetInsert(targetDr, schemeDr) As %String
{
	n (targetDr,schemeDr)
	
	k PLIST
	
 	s PLIST(2)=targetDr
	s PLIST(3)=schemeDr
	
	&SQL(INSERT INTO dhc_bonus_data.SchemeTarget VALUES PLIST())
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-03-24
/// Description: 查询奖金方案项类别
/// Table: dhc.bonus.data.BonusItemType
/// Input: Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusScheme).BonusItemTypeList(0,25)
ClassMethod BonusItemTypeList(start, limit)
{
	n ( start, limit)
	
	s sqlStr="select BonusItemTypeID,BonusItemTypeName from dhc_bonus_data.BonusItemType where %ID>0 and IsValid=1 "
	
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
		s rowid=result.Data("BonusItemTypeID")
		s name=result.Data("BonusItemTypeName")
		
		s tmp=rowid_"^"_name
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: zhaoliguo
/// CreatDate: 2016-08-31
/// Description: 查询奖金自定义函数
/// Input: Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uBonusScheme).funlist(0,25)
ClassMethod funlist(start, limit)
{
	n ( start, limit)
	
	s sqlStr="SELECT FunCode , FunName  FROM dhc_bonus_data.BonusCalcFunction WHERE IsValid=1 "
	
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="funCode^funName"
	
	While(result.Next())
	{
		s funCode=result.Data("FunCode")
		s funName=result.Data("FunName")
		
		s tmp=funCode_"^"_funName
	
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
<StreamLocation>^dhc.bonus.udata.uBonusSchemeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
