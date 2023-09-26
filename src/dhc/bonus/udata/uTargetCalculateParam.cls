Class dhc.bonus.udata.uTargetCalculateParam Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 计提系数设定
/// Creator: 王宏宇
/// CreatDate: 2011-1-6
/// Description: 查询符合条件的记录
/// Table: dhc.bonus.data.TargetCalculateRate
/// Input: UnitID-核算单元id,TargetID-指标ID,AuditingState-审核状态,searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.bonus.udata.uTargetCalculateParam).ListRec(1,"","","BonusUnitTypeID","","rowid","DESC",0,3,"")
ClassMethod ListRec(SchemeID, UnitID, TargetID, searchField, searchValue, sortField, sortDir, start, limit, unitSuperID) As %String
{
	n (SchemeID,UnitID, TargetID,searchField, searchValue, sortField, sortDir, start, limit,unitSuperID)
	
	;k ^zlgtmp
	;s ^zlgtmp=SchemeID_","_UnitID_","_TargetID_","_searchField
	;_","_searchValue_","_sortField_","_sortDir_","_start_","_limit_","_unitSuperID
	
	s sqlStr="select TargetCalculateRateID,BonusUnitID,BonusUnitID->BonusUnitTypeID,BonusUnitID->BonusUnitTypeID->UnitTypeName,BonusTargetID,TargetUnit"
	_",TargetRate,TargetDirection,b.BonusSchemeID,b.SchemeState,BonusUnitID->EmployeeNo"
	_" ,BonusUnitID->SuperiorUnitID->BonusUnitName unitSuperName"
	_" from dhc_bonus_data.TargetCalculateRate a,dhc_bonus_data.BonusScheme b"
	s whereStr=" WHERE a.IsValid=1 and a.BonusSchemeID=b.BonusSchemeID and a.BonusTargetID->DataSource=4 "
	i SchemeID'="" s whereStr=whereStr_" and a.BonusSchemeID='"_SchemeID_"'"
	i UnitID>0 s whereStr=whereStr_" and BonusUnitID='"_UnitID_"'"
	i TargetID'="" s whereStr=whereStr_" and BonusTargetID='"_TargetID_"'"
	i searchField="BonusUnitTypeID" d
	.i searchValue'="" d
	..s whereStr=whereStr_" and BonusUnitID->BonusUnitTypeID="_searchValue
	i unitSuperID>0 d
	.s whereStr=whereStr_" and BonusUnitID->SuperiorUnitID="_unitSuperID
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="TargetCalculateRateID"
	.i sortField="UnitName" s sortField1="BonusUnitID"
	.i sortField="TargetName" s sortField1="BonusTargetID"
	.i sortField="TargetUnitName" s sortField1="TargetUnit"
	.i sortField="TargetRate" s sortField1="TargetRate"
	.i sortField="TargetDirection" s sortField1="TargetDirection"
	.i sortField="BonusSchemeName" s sortField1="BonusSchemeName"
	.i sortField="SchemeState" s sortField1="SchemeState"
	.i sortField="unitSuperName" s sortField1="SuperiorUnitID->BonusUnitName"
	
	
	.i sortField="UnitTypeName" s sortField1=" BonusUnitID->BonusUnitTypeID->UnitTypeName"
	
   i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"

	
	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr,!	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	//标题
	s jsonTitle="rowid^UnitID^UnitName^UnitTypeID^UnitTypeName^TargetID^TargetName^TargetUnit^TargetUnitName^TargetRate^TargetDirection^BonusSchemeID^BonusSchemeName^SchemeState^unitSuperName"
	
	While(result.Next()){
	    s UnitName="",TargetIDName="",TargetUnitName="",BonusSchemeName=""
	    s rowid=result.Data("TargetCalculateRateID")
	    s EmployeeNo= result.Data("EmployeeNo")
	    s unitSuperName = result.Data("unitSuperName")
	    
		//核算单元
		s UnitID=result.Data("BonusUnitID")
		i UnitID'="" d
		.i $D(^dhcbsBonusUnitD(UnitID)) d
		..i $G(^dhcbsBonusUnitD(UnitID))'="" d
		...s UnitName=$LIST(^dhcbsBonusUnitD(UnitID),3)
		
		//指标单元
		s TargetID=result.Data("BonusTargetID")
		i TargetID'="" d
		.i $D(^dhcbsBonusTargetD(TargetID)) d
		..i $G(^dhcbsBonusTargetD(TargetID))'="" d
		...s TargetName=$List(^dhcbsBonusTargetD(TargetID),3)
	   //计量单位
		s TargetUnit=result.Data("TargetUnit")
		i TargetUnit'="" d
		.i $D(^dhcbsCalUnitD(TargetUnit)) d
		..i $G(^dhcbsCalUnitD(TargetUnit))'="" d
		...s TargetUnitName=$List(^dhcbsCalUnitD(TargetUnit),3)
		
		//核算单元类别
		s UnitTypeName=result.Data("UnitTypeName")
		s BonusUnitTypeID=result.Data("BonusUnitTypeID")
		
		s TargetRate=result.Data("TargetRate")
		s TargetDirection=result.Data("TargetDirection")
		s BonusSchemeID=result.Data("BonusSchemeID")
		s SchemeState=result.Data("SchemeState")
		i BonusSchemeID'="" d
		.i $D(^dhcbsBonusSchemeD(BonusSchemeID)) d
		..i $G(^dhcbsBonusSchemeD(BonusSchemeID))'="" d
		...s BonusSchemeName=$List(^dhcbsBonusSchemeD(BonusSchemeID),3)
		
			i TargetDirection=1 s TargetDirection="正向"
			i TargetDirection=-1 s TargetDirection="负向"
			
			i SchemeState=0 s SchemeState="新增"
			i SchemeState=1 s SchemeState="审核完成"
			i SchemeState=2 s SchemeState="方案调整"
			
		s tmp=rowid_"^"_UnitID_"^"_UnitName_"^"_BonusUnitTypeID_"^"_UnitTypeName_"^"_TargetID_"^"_TargetName_"^"_TargetUnit_"^"_TargetUnitName_"^"_TargetRate_"^"_TargetDirection_"^"_BonusSchemeID_"^"_BonusSchemeName_"^"_SchemeState_"^"_unitSuperName
		;w tmp,!
		/*
			i searchValue'="" d
			.q:(searchField="UnitName")&(UnitName'[searchValue)
			.q:(searchField="TargetName")&(TargetName'[searchValue)
			.q:(searchField="TargetUnitName")&(TargetUnit'[searchValue)
			.q:(searchField="TargetRate")&(TargetRate'[searchValue)
			.q:(searchField="TargetDirection")&(TargetDirection'[searchValue)
			.q:(searchField="BonusSchemeName")&(BonusSchemeName'[searchValue)
			.q:(searchField="SchemeState")&(SchemeState'[searchValue)
		
			
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
				*/
			;w start_"^"_count_"^"_end,!
			i (count>=start)&(count<=end) d
			.;w "ssss="_start_"^"_count_"^"_end,!
			.d json.InsertRowData(tmp)		
			s count=count+1
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator：王宏宇
/// CreatDate：2011-1-17
/// Description: 取出Combobox所许要的计量单位
/// Table：dhc_bonus_data.CalUnit
/// Input：start:开始记录位置;limit:记录条数;str:模糊查询字段
/// Output：
/// Return：有效单位字符串
/// Others: w ##class(dhc.bonus.udata.uTargetCalculateRate).CalList(0,10,"er")
ClassMethod CalList(start, limit, str) As %String
{
    n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CalUnitID,CalUnitName from dhc_bonus_data.CalUnit where %ID>0  and IsValid=1 "
	i str'="" s sqlStr = sqlStr_" and CalUnitName LIKE '"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("CalUnitID")
		s name = result.Data("CalUnitName")
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

/// Creator：王宏宇
/// CreatDate：2010-11-16
/// Description: 根据奖金方案查询奖金指标
/// Table：dhc_bonus_data.SchemeTarget
/// Input：start:开始记录位置;limit:记录条数;SchemeID:奖金方案ID
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uTargetCalculateParam).STList(0,10,"","36")
ClassMethod STList(start, limit, str, SchemeID) As %String
{
    n (start, limit, str, SchemeID)

	s result = ##class(%Library.ResultSet).%New()
	
	s whereStr=""
	s sqlStr = "select b.BonusSchemeID, c.BonusTargetID,c.BonusTargetName "
	_" from dhc_bonus_data.BonusScheme a join dhc_bonus_data.SchemeTarget b on a.BonusSchemeID = b.BonusSchemeID "
	_" join   dhc_bonus_data.BonusTarget c on b.BonusTargetID = c.BonusTargetID where c.DataSource in (4,6) and c.IsValid=1 and a.BonusSchemeID ="_SchemeID


	i str'="" s whereStr=whereStr_" and c.BonusTargetName like '%"_str_"%'"
	s sqlStr=sqlStr_whereStr

	d result.Prepare(sqlStr)
	d result.Execute()
	//w sqlStr,!
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	
	s tmp="^全部"
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	
	While(result.Next()){
	s BonusTargetID = result.Data("BonusTargetID")
	i BonusTargetID'="" d
	.i $D(^dhcbsBonusTargetD(BonusTargetID)) d
	..i $G(^dhcbsBonusTargetD(BonusTargetID))'="" d
	...s TargetName=$List(^dhcbsBonusTargetD(BonusTargetID),3)
	
	s tmp=BonusTargetID_"^"_TargetName
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
	k json
	q resultString
}

/// Creator：王宏宇
/// CreatDate：2011-1-17
/// Description: 根据核算指标查询所许要的参数指标
/// Table：dhc.bonus.data.BonusTarget
/// Input：start:开始记录位置;limit:记录条数;str:模糊查询字段
/// Output：
/// Return：有效单位字符串
/// Others: w ##class(dhc.bonus.udata.uTargetCalculateRate).TargetList(0,10,"小","5")
ClassMethod TargetList(start, limit, str, TargetID) As %String
{
    n (start, limit, str, TargetID)

	s result = ##class(%Library.ResultSet).%New()
	
	s whereStr=""
	s sqlStr = "select BonusTargetID,BonusTargetName from dhc_bonus_data.BonusTarget a where a.BonusTargetID = (select ParameterTarget from dhc_bonus_data.BonusTarget where BonusTargetID='"_TargetID_"' ) or '' = (select case when ParameterTarget= null then '' else ParameterTarget end as dd from dhc_bonus_data.BonusTarget where BonusTargetID='"_TargetID_"')"


	i str'="" s whereStr=whereStr_" and BonusTargetName like '%"_str_"%'"
	s sqlStr=sqlStr_whereStr

	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
	
	
	s BonusTargetID = result.Data("BonusTargetID")
	i BonusTargetID'="" d
	.i $D(^dhcbsBonusTargetD(BonusTargetID)) d
	..i $G(^dhcbsBonusTargetD(BonusTargetID))'="" d
	...s TargetName=$List(^dhcbsBonusTargetD(BonusTargetID),3)
	
	
	
	s tmp=BonusTargetID_"^"_TargetName
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
	k json
	q resultString
}

/// 查询combobox
/// Creator：王宏宇
/// CreatDate：2011-1-12
/// Description: 取出Combobox所许要的奖金方案
/// Table：dhc_bonus_data.BonusScheme
/// Input：start:开始记录位置;limit:记录条数;str:模糊查询字段
/// Output：
/// Return：有效单位字符串
/// Others: w ##class(dhc.bonus.udata.uTargetCalculateRate).GetScheme(0,10,"")
ClassMethod GetScheme(start, limit, str) As %String
{
    n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select BonusSchemeID,BonusSchemeCode ,BonusSchemeName from dhc_bonus_data.BonusScheme where %ID>0  and IsValid=1"
	i str'="" s sqlStr = sqlStr_" and BonusSchemeName LIKE '%"_str_"%'"
	
	 s sqlStr = sqlStr_" order by SchemeType,BonusSchemeCode "
	d result.Prepare(sqlStr)
	d result.Execute()
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusSchemeID")
		s code = result.Data("BonusSchemeCode")
		s name = result.Data("BonusSchemeName")
		
		s tmp=rowid_"^"_code_":"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json 	
 	q resultString
}

/// 添加修改combobox
/// Creator：王宏宇
/// CreatDate：2011-1-12
/// Description: 取出Combobox所许要的奖金方案
/// Table：dhc_bonus_data.BonusScheme
/// Input：start:开始记录位置;limit:记录条数;str:模糊查询字段
/// Output：
/// Return：有效单位字符串
/// Others: w ##class(dhc.bonus.udata.uTargetCalculateRate).GetScheme(0,10,"")
ClassMethod GetScheme1(start, limit, str) As %String
{
    n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select BonusSchemeID,BonusSchemeCode ,BonusSchemeName from dhc_bonus_data.BonusScheme where %ID>0 and SchemeState <> 1 and IsValid=1"
	i str'="" s sqlStr = sqlStr_" and BonusSchemeName LIKE '%"_str_"%'"
	 s sqlStr = sqlStr_" order by SchemeType,BonusSchemeCode "
	d result.Prepare(sqlStr)
	d result.Execute()
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusSchemeID")
		s code = result.Data("BonusSchemeCode")
		s name = result.Data("BonusSchemeName")
		s tmp=rowid_"^"_code_":"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json 	
 	q resultString
}

/// Creator：王宏宇
/// CreatDate：2011-01-17
/// Description:插入数据
/// Table： dhc.bonus.data.TargetCalculateRate
/// Input：
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uTargetCalculateParam).Insert("-2^66^1^1^9887^36^9")
ClassMethod Insert(data) As %String
{
	 n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		
		s UnitID=$p(data,"^",1)
		s TargetID=$p(data,"^",2)
		s TargetUnit = $p(data,"^",3)
		s TargetDirection = $p(data,"^",4)
		s TargetRate = $p(data,"^",5)
		s SchemeID=$p(data,"^",6)
		s UnitTypeID = $p(data,"^",7)
		
		s IsValid=$p(data,"^",8)
		s AuditingState=$p(data,"^",9)
		s AccountBase=$p(data,"^",10)
		
		s sum=0
	    s sum=..IfRepScheme(UnitID,TargetID,SchemeID)
	    q:sum>0 "RepScheme"
	    
		q:UnitID="" 0
		q:TargetID="" 0
		
		i IsValid=""    s IsValid=1
		i AuditingState="" s AuditingState=0
		i AccountBase=""   s AccountBase=0
		
		i UnitID'="" s PLIST(2)=UnitID
		i TargetID'="" s PLIST(3)=TargetID
		i TargetUnit'="" s PLIST(5)=TargetUnit
		i TargetDirection'="" s PLIST(8)=TargetDirection
		i AccountBase'="" s PLIST(10)=AccountBase
		i TargetRate'="" s PLIST(11)=TargetRate
		i IsValid'="" s PLIST(12)=IsValid
		i AuditingState'="" s PLIST(17)=AuditingState
		i SchemeID'="" s PLIST(20)=SchemeID
     
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "insert into dhc_bonus_data.TargetCalculateRate(BonusUnitID,BonusTargetID,RateType,TargetUnit,TargetDirection,StepSize,TargetRate,IsValid,AuditingState,AccountBase,BonusSchemeID) "
	s sqlValue=" select  BonusUnitID,"_TargetID_" as BonusTargetID,4 RateType,"_TargetUnit_" TargetUnit,"_
		TargetDirection_" TargetDirection,1 StepSize,"_TargetRate_"TargetRate,1 IsValid,0 AuditingState,0 AccountBase,"_
		SchemeID_" BonusSchemeID "
	 
	 s sqlValue=sqlValue_" from dhc_bonus_data.BonusSchemeUnit "
	 
	 s sqlWhere=" where BonusUnitID>0 and BonusSchemeID="_SchemeID
	 
	 if UnitID>0 d
	 .s sqlWhere=sqlWhere_ " AND BonusUnitID="_UnitID
	 
	 if UnitID="-2" d
	 .s sqlWhere=sqlWhere_"  AND BonusUnitID->BonusUnitTypeID= "_UnitTypeID
	 
	 s sqlStr=sqlStr_sqlValue_sqlWhere
	 
	 s sqlDel=" delete from dhc_bonus_data.TargetCalculateRate "
	 s sqlDel=sqlDel_sqlWhere_" and BonusTargetID="_TargetID
	 
	 //w sqlStr,!
	// w sqlDel,!
	 
	//d result.Prepare(sqlDel)
	//d result.Execute()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
        q SQLCODE
}

/// 判断添加指标是否重复
/// others:w ##class(dhc.bonus.udata.uTargetCalculateParam).IfRepScheme(29,99,2)
ClassMethod IfRepScheme(UnitID, TargetID, SchemeID) As %String
{
	n (UnitID,TargetID,SchemeID)
	s sum=0
	
	&sql(SELECT count(*) into :sum FROM dhc_bonus_data.TargetCalculateRate
	WHERE BonusUnitID=:UnitID and BonusTargetID=:TargetID and BonusSchemeID=:SchemeID AND IsValid=1)

	i sum="" d  s sum=0
	q sum
}

/// 判断添加指标是否重复
/// others:w ##class(dhc.bonus.udata.uTargetCalculateParam).UpRepScheme("",29,99,2)
ClassMethod UpRepScheme(rowid, UnitID, TargetID, SchemeID) As %String
{
	n (rowid,UnitID,TargetID,SchemeID)
	s sum=0
	
	&sql(SELECT count(*) into :sum FROM dhc_bonus_data.TargetCalculateRate
	WHERE BonusUnitID=:UnitID and BonusTargetID=:TargetID and BonusSchemeID=:SchemeID AND IsValid=1 and TargetCalculateRateID not in (:rowid))

	i sum="" d  s sum=0
	q sum
}

/// Creator：zhaoliguo
/// CreatDate：2011-03-31
/// Description:数据修改
/// Table： dhc.bonus.data.TargetCalculateRate
/// Input：
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uTargetCalculateParam).Update(835,"853^45^6^1^4258.24^16^4")
ClassMethod Update(rowid, data) As %String
{
		n (rowid,data)
		
		q:rowid="" "EmptyRecData"
		q:data="" "EmptyRecData"
		
		s UnitID=$p(data,"^",1)
		s TargetID=$p(data,"^",2)
		s TargetUnit = $p(data,"^",3)
		s TargetDirection = $p(data,"^",4)
		s TargetRate = $p(data,"^",5)
		s SchemeID=$p(data,"^",6)
		s BonusUnitTypeID=$p(data,"^",7)
		s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
		
		s sum=0
	    s sum=..UpRepScheme(rowid,UnitID,TargetID,SchemeID)
	    q:sum>0 "RepScheme"
		
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "Update dhc_bonus_data.TargetCalculateRate "_ 
	"set  TargetRate="_TargetRate_", BonusTargetID="_TargetID_" ,TargetUnit="_TargetUnit_",TargetDirection="_TargetDirection_",UpdateDate='"_UpdateDate_"'"_",BonusUnitID='"_UnitID_"'"

	if UnitID>0 d
	.s sqlWhere=" where %ID="_rowid
	 
	if UnitID="-1" d
	.s sqlWhere=" where BonusSchemeID="_SchemeID  _" AND BonusTargetID="_TargetID
	 
	 if UnitID="-2" d
	 .s sqlWhere=" where BonusSchemeID="_SchemeID _" AND BonusTargetID="_TargetID_" AND BonusUnitID->BonusUnitTypeID="_BonusUnitTypeID

	 s sqlStr=sqlStr_sqlWhere
	// w sqlStr,!
	// w sqlDel,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
    q SQLCODE
}

/// Creator：王宏宇
/// CreatDate：2011-01-17
/// Description:修改数据
/// Table： dhc.bonus.data.TargetCalculateRate
/// Input：
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uTargetCalculateRate).Update(5,"2^1^2^2^12^-1^20^98^1^1")
ClassMethod Update11(rowid, data) As %String
{
	 n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s UnitID=$p(data,"^",1)
		s TargetID=$p(data,"^",2)
		s TargetUnit = $p(data,"^",3)
		s TargetDirection = $p(data,"^",4)
		s TargetRate = $p(data,"^",5)
		s SchemeID=$p(data,"^",6)
	
		/**
		i IsValid=""    s IsValid=1
		i AuditingState="" s AuditingState=0
		**/
		s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
		
		i UnitID'="" s PLIST(2)=UnitID
		i TargetID'="" s PLIST(3)=TargetID
		i TargetUnit'="" s PLIST(5)=TargetUnit
		i TargetDirection'="" s PLIST(8)=TargetDirection
		i TargetRate'="" s PLIST(11)=TargetRate
		i UpdateDate'="" s PLIST(18)=UpdateDate

        &sql(Update dhc_bonus_data.TargetCalculateRate VALUES PLIST() where %ID=:rowid)
      q SQLCODE
}

///  Creator：王宏宇
///  CreatDate：2011-01-17
///  Description:删除数据
///  Table： dhc.bonus.data.TargetCalculateRate
///  Input：
///  Output：
///  Return：有效单位字符串
///  others：w ##class(dhc.bonus.udata.uTargetCalculateRate).Delete()
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_bonus_data.TargetCalculateRate where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.udata.uTargetCalculateParam).SUnitTypLis(0,10)
/// 根据单元类别查询
ClassMethod SUnitTypLis(start, limit) As %String
{
	n (start, limit)
	//SQL
	s sqlStr="SELECT BonusUnitTypeID,UnitTypeCode,UnitTypeName, "_
	"  IsDeptmentType,IsMedicalGroup,IsPersonType,IsValid  "_
	" from dhc_bonus_data.BonusUnitType where  IsValid =1"
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	

	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	s tmp="^全部"
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusUnitTypeID")
		
		s name = result.Data("UnitTypeName")
		
		s tmp=rowid_"^"_name
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	q resultString
}

/// Creator：王宏宇
/// CreatDate：2010-11-16
/// Description: 根据奖金方案查询核算单元
/// Table：dhc_bonus_data.SchemeTarget
/// Input：start:开始记录位置;limit:记录条数;SchemeID:奖金方案ID
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uTargetCalculateParam).SUList(0,10,"","10","2","")
ClassMethod SUList(start, limit, str, SchemeID, BonusUnitTypeID, unitSuperID) As %String
{
    n (start, limit, str, SchemeID,BonusUnitTypeID,unitSuperID)

	s result = ##class(%Library.ResultSet).%New()
	
	
	s sqlStr = "select BonusSchemeUnitID, BonusSchemeID,BonusUnitID,BonusUnitID->BonusUnitName,BonusUnitID->EmployeeNo"
	_" from dhc_bonus_data.BonusSchemeUnit "
	s whereStr=" WHERE %ID>0  AND BonusUnitID>0 "
	s whereStr=whereStr_" and  BonusSchemeID='"_SchemeID_"' "
	i str'="" s whereStr = whereStr_" and (BonusUnitID->BonusUnitName LIKE '%"_str_"%' or BonusUnitID->EmployeeNo LIKE '%"_str_"%')"
	i BonusUnitTypeID'="" s whereStr = whereStr_" and BonusUnitID->BonusUnitTypeID= "_BonusUnitTypeID
	i unitSuperID>0 s whereStr = whereStr_" and BonusUnitID->SuperiorUnitID="_unitSuperID
	
	s sqlStr=sqlStr_whereStr_" order by BonusUnitID->BonusUnitName"
	
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	
	if SchemeID'="" d
	.s tmp="-1"_"^"_"所有方案单元"
	.d json.InsertRowData(tmp)
	.s count = count+1
	
	if BonusUnitTypeID'="" d
	.s tmp="-2"_"^"_"所有类别单元"
	.d json.InsertRowData(tmp)
	.s count = count+1
	
	While(result.Next()){
	s UnitName=""
	
	s BonusUnitID = result.Data("BonusUnitID")
	;w BonusUnitID,!
	i BonusUnitID'="" d
	.i $D(^dhcbsBonusUnitD(BonusUnitID)) d
	..i $G(^dhcbsBonusUnitD(BonusUnitID))'="" d
	...s UnitName=$LIST(^dhcbsBonusUnitD(BonusUnitID),3)
	...;w UnitName,!
	
	s EmployeeNo = result.Data("EmployeeNo")
	
	
	s tmp=BonusUnitID_"^"_UnitName_"-"_EmployeeNo
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
<StreamLocation>^dhc.bonus.u5C1.uTargetCalcu85BS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
