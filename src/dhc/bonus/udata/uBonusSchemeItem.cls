Class dhc.bonus.udata.uBonusSchemeItem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.bonus.udata.uBonusSchemeItem).List("","","","",0,25,8)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, type)
{
	n (searchField, searchValue, sortField, sortDir, start, limit,type)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusSchemeItem"
	
	s whereStr=" WHERE %ID>0 and IsValid=1 and BonusSchemeID="_type
	s sortStr=""
	s sortField1=""
	i sortField="rowid" d
	.s sortField="BonusSchemeItemID"
	
	
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY SchemeItemCode"
	
	i sortField="BonusItemTypeName" s sortStr=" ORDER BY BonusItemTypeID->BonusItemTypeName  "_sortDir
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()

	s jsonTitle="rowid|BonusSchemeID|BonusItemTypeID|BonusItemTypeName|SchemeItemCode|SchemeItemName|DataSource|BonusFormula|BonusFormulaDesc|BonusType|CalculatePriority|IsValid|UpdateDate"
	
	While(result.Next())
	{
		s rowid=result.Data("BonusSchemeItemID")
		s BonusSchemeID=result.Data("BonusSchemeID")
		s BonusItemTypeID=result.Data("BonusItemTypeID")
		
		s SchemeItemCode=result.Data("SchemeItemCode")
		s SchemeItemName=result.Data("SchemeItemName")
		s DataSource=result.Data("DataSource")
		s BonusFormula=result.Data("BonusFormula")
		s BonusFormulaDesc=result.Data("BonusFormulaDesc")
		s BonusType=result.Data("BonusType")		
		s CalculatePriority=result.Data("CalculatePriority")
		s IsValid=result.Data("IsValid")
		s UpdateDate=result.Data("UpdateDate")
		i UpdateDate'="" d
		.s UpdateDate=$zd(UpdateDate,3)
		
		s BonusItemTypeName=""
		if BonusItemTypeID'="" d
	    .s BonusItemTypeName=$list(^dhcbsBonusItemTypeD(BonusItemTypeID),3)
	    
		s tmp=rowid_"|"_BonusSchemeID_"|"_BonusItemTypeID_"|"_BonusItemTypeName_"|"_SchemeItemCode_"|"_SchemeItemName_"|"_DataSource_"|"_BonusFormula_"|"_BonusFormulaDesc_"|"_BonusType_"|"_CalculatePriority_"|"_IsValid_"|"_UpdateDate

		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count,"|")
 	k json
	q resultString
}

/// w ##class(dhc.bonus.udata.uBonusSchemeItem).IfRepCode("123",16)
ClassMethod IfRepCode(code, type) As %String
{
	n (code,type)
	s rowid=0	
	f  s rowid=$o(^dhcbsBonusSchemeItemI("SchemeItemCode",code,rowid)) q:(rowid="")||((rowid'="")&&($LIST(^dhcbsBonusSchemeItemD(rowid),2)=type))  d
	i rowid="" d  s rowid=0
	q rowid
}

/// w ##class(dhc.bonus.udata.uBonusSchemeItem).IfRepBonusType(5)
ClassMethod IfRepBonusType(schemeID) As %String
{
	n (schemeID)
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusSchemeItem where IsValid=1 and BonusSchemeID="_schemeID_" and BonusType=1"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("BonusSchemeItemID")
	}
	q rowid
}

//BonusFormulaDesc,BonusType,CalculatePriority,IsValid,UpdateDate

/// w ##class(dhc.bonus.udata.uBonusSchemeItem).Insert("35||45454|4545|2|^T05104^+^T06001|大手术急补助额+01指 标|2|1|1|2011-03-16")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpt"      //准备插入的数据为空,退出并返回dataEmpt
	
	k PLIST
	
	s BonusSchemeID=$p(data,"|",1)             
	i BonusSchemeID'="" s PLIST(2)=BonusSchemeID
	
	s BonusItemTypeID=$p(data,"|",2)
	i BonusItemTypeID'="" s PLIST(3)=BonusItemTypeID
	
	s SchemeItemCode=$p(data,"|",3)
	s rowid=..IfRepCode(SchemeItemCode,BonusSchemeID)
	q:rowid'=0 "1"
	
	i SchemeItemCode'="" d
	.s PLIST(4)=SchemeItemCode
	
	s SchemeItemName=$p(data,"|",4)
	i SchemeItemName'="" s PLIST(5)=SchemeItemName
	
	s DataSource=$p(data,"|",5)
	i DataSource'="" s PLIST(6)=DataSource
	
	s BonusFormula=$p(data,"|",6)
	i BonusFormula'="" s PLIST(7)=BonusFormula
	d ..addTargets(BonusFormula,BonusSchemeID)
	
	s BonusFormulaDesc=$p(data,"|",7)
	i BonusFormulaDesc'="" s PLIST(8)=BonusFormulaDesc
	
	s BonusType=$p(data,"|",8)
	s tmpBt=..IfRepBonusType(BonusSchemeID)
	q:(tmpBt'=0)&&(BonusType=1) "2"
	
	i BonusType'="" s PLIST(9)=BonusType
	
	s CalculatePriority=$p(data,"|",9)
	i CalculatePriority'="" s PLIST(10)=CalculatePriority
	
	s IsValid=$p(data,"|",10)
	i IsValid'="" s PLIST(11)=IsValid
	
	s UpdateDate=$p(data,"|",11)
	i UpdateDate'="" d
	.s UpdateDate=$zdh(UpdateDate,3)
	.s PLIST(12)=UpdateDate
	
	
	&SQL(INSERT INTO dhc_bonus_data.BonusSchemeItem VALUES PLIST())
	q SQLCODE
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

/// Others: w ##class(dhc.bonus.udata.uBonusSchemeItem).Update(181,"43|工作效率奖|0115|非药物治疗6|2||非药物治疗人数*非药物治疗人数提取额|2|1|1|2011-04-15")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	
	k PLIST
	q:rowid="" "EmptyRowid"
	q:data="" "EmptyData"
	
	
	s BonusSchemeID=$p(data,"|",1)             
	i BonusSchemeID'="" s PLIST(2)=BonusSchemeID
	
	s BonusItemTypeID=$p(data,"|",2)
	i BonusItemTypeID'="" s PLIST(3)=BonusItemTypeID
	
	
	s SchemeItemCode=$p(data,"|",3)
	s tmpRowid=..IfRepCode(SchemeItemCode,BonusSchemeID)
	q:(tmpRowid'=0)&&(tmpRowid'=rowid) "1"
	i SchemeItemCode'="" s PLIST(4)=SchemeItemCode
	
	s SchemeItemName=$p(data,"|",4)
	i SchemeItemName'="" s PLIST(5)=SchemeItemName

	
	s DataSource=$p(data,"|",5)
	i DataSource'="" s PLIST(6)=DataSource
	
	s BonusFormula=$p(data,"|",6)
	i BonusFormula'="" s PLIST(7)=BonusFormula
	;d ..addTargets(BonusFormula,BonusSchemeID)
	
	s BonusFormulaDesc=$p(data,"|",7)
	s PLIST(8)=BonusFormulaDesc
	
	s BonusType=$p(data,"|",8)
	s tmpBt=..IfRepBonusType(BonusSchemeID)
	q:(tmpBt'=0)&&(tmpBt'=rowid)&&(BonusType=1) "2"
	
	i BonusType'="" s PLIST(9)=BonusType
	
	s CalculatePriority=$p(data,"|",9)
	i CalculatePriority'="" s PLIST(10)=CalculatePriority
	
	s IsValid=$p(data,"|",10)
	i IsValid'="" s PLIST(11)=IsValid
	
	s UpdateDate=$p(data,"|",11)
	i UpdateDate'="" d
	.s UpdateDate=$zdh(UpdateDate,3)
	.s PLIST(12)=UpdateDate	

	&SQL(UPDATE dhc_bonus_data.BonusSchemeItem VALUES PLIST() where %ID>0 AND BonusSchemeItemID=:rowid)
	
	/*	
	s scheme=$list(^dhcbsBonusSchemeItemD(rowid),2)
	
	&SQL(delete from dhc_bonus_data.SchemeTarget where BonusSchemeID=:scheme)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusSchemeItem"
	s whereStr=" WHERE %ID>0 and IsValid=1 and BonusSchemeID="_scheme	
	s sqlStr=sqlStr_whereStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""	
	While(result.Next())
	{
		s rowid=result.Data("BonusSchemeItemID")
		s BonusFormula=result.Data("BonusFormula")
		d ..addTargets(BonusFormula,scheme)
	}        */
	
	
	q 0
}

/// w ##class(dhc.bonus.udata.uBonusSchemeItem).addTargets("^T005",16)
ClassMethod addTargets(bf, schemeDr) As %String
{
	n (bf,schemeDr)
	s t=..formu2Codes(bf)
	s r=t
	s cur=1
	f  s tC=$p(t,"^",cur) q:tC=""  d
	.s cur=cur+1
	.i (..findCodesInTarget(tC,schemeDr)'="") d
	..s r=r_"^"_..findCodesInTarget(tC,schemeDr)
	s TCs=..form(r)
	s cur=1
	f  s tC=$p(TCs,"^",cur) q:tC=""  d
	.s cur=cur+1
	.s tDr=""
	.s tDr=$o(^dhcbsBonusTargetI("BonusTargetCode",tC,tDr))
	.i ..IfRepDr(tDr,schemeDr)=0 d
	..k PLIST1
	..s PLIST1(2)=tDr
	..s PLIST1(3)=schemeDr
	..&SQL(INSERT INTO dhc_bonus_data.SchemeTarget VALUES PLIST1())
	q $$$OK
}

/// w ##class(dhc.bonus.udata.uBonusSchemeItem).formu2Codes("^T001^+^T002^+^T001")
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

/// w ##class(dhc.bonus.udata.uBonusSchemeItem).findCodesInTarget("005",16)
ClassMethod findCodesInTarget(code, schemeDr) As %String
{
	n (code,schemeDr)
	s r=""
	s dr=""
	;w code
	s dr=$o(^dhcbsBonusTargetI("BonusTargetCode",code,dr))
	q:dr="" ""
	
	i (2=$list(^dhcbsBonusTargetD(dr),7)) d
	.s formula=$list(^dhcbsBonusTargetD(dr),9)
	.s subCs=..formu2Codes(formula)
	.s cur=1
	.f  s sC=$p(subCs,"^",cur) q:sC=""  d
	..s cur=cur+1
	..s r=r_sC
	..s r=r_"^"_..findCodesInTarget(sC,schemeDr)
	e  i (3=$list(^dhcbsBonusTargetD(dr),7)) d   //dr,schemeDr
	.s sDr=$list(^dhcbsBonusTargetD(dr),14)
	.q:sDr=""
	.s sC=$list(^dhcbsBonusTargetD(sDr),2)
	.s r=r_sC
	.s r=r_"^"_..findCodesInTarget(sC,schemeDr)
	q r
}

/// Others: w ##class(dhc.bonus.udata.uBonusSchemeItem).targetCode2Dr("002")
ClassMethod targetCode2Dr(tcode) As %String
{
	n (tcode)
	s rowid=""
	s tmpPre=""
	s BTCode=""
	f  s rowid=$o(^dhcbsBonusTargetD(rowid)) q:(rowid="")||(BTCode=tcode)  d
	.s BTCode=$List(^dhcbsBonusTargetD(rowid),2)
	.s tmpPre=rowid
	i (rowid="")&&(BTCode'=tcode) d
	.s tmpPre=""
	q tmpPre
}

/// w ##class(dhc.bonus.udata.uBonusSchemeItem).Del(74)
ClassMethod Del(rowid) As %String
{
	/*
	n (rowid)
	k PLIST
	s PLIST(11)=0
	&SQL(UPDATE dhc_bonus_data.BonusSchemeItem VALUES PLIST() where %ID=:rowid)
	
	s scheme=$list(^dhcbsBonusSchemeItemD(rowid),2)
	
	&SQL(delete from dhc_bonus_data.SchemeTarget where BonusSchemeID=:scheme)
	
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusSchemeItem"
	s whereStr=" WHERE %ID>0 and IsValid=1 and BonusSchemeID="_scheme	
	s sqlStr=sqlStr_whereStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""	
	While(result.Next())
	{
		s rowid=result.Data("BonusSchemeItemID")
		s BonusFormula=result.Data("BonusFormula")
		d ..addTargets(BonusFormula,scheme)
	}
	
	q 0
	*/
	&SQL(DELETE FROM dhc_bonus_data.BonusSchemeItem WHERE %ID=:rowid)
	k PLIST
	s PLIST(12)=0
	q SQLCODE
}

/// w ##class(dhc.bonus.udata.uBonusSchemeItem).form("^sdf^^ss")
ClassMethod form(str) As %String
{
	n (str)
	s cur=$find(str,"^^")
	while(cur>0)
	{
		s str=$Extract(str,1,cur-2)_$Extract(str,cur,$length(str))
		s cur=$find(str,"^^")
	}
	q str
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusScheme660S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
