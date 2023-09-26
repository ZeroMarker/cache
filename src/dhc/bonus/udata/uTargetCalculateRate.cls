Class dhc.bonus.udata.uTargetCalculateRate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 指标计提系数设定
/// Creator: 王宏宇
/// CreatDate: 2011-1-6
/// Description: 查询符合条件的记录
/// Table: dhc.bonus.data.TargetCalculateRate
/// Input: UnitID-核算单元id,TargetID-指标ID,AuditingState-审核状态,searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.bonus.udata.uTargetCalculateRate).ListRec("1","","","","","","",0,10)
ClassMethod ListRec(SchemeID, UnitID, TargetID, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (SchemeID,UnitID, TargetID,searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="select TargetCalculateRateID,BonusUnitID,BonusTargetID,TargetUnit,ParameterTarget,AccountBase,StartLimit,EndLimit,StepSize,TargetRate,TargetDirection,b.BonusSchemeID,b.SchemeState"
	s sqlStr=sqlStr_" from dhc_bonus_data.TargetCalculateRate a,dhc_bonus_data.BonusScheme b"
	s whereStr=" WHERE a.IsValid=1 and a.BonusSchemeID=b.BonusSchemeID and a.BonusTargetID->DataSource in (3,6,7)"
	i SchemeID'="" s whereStr=whereStr_" and a.BonusSchemeID='"_SchemeID_"'"
	i UnitID="-1" s UnitID=""
	i UnitID'="" s whereStr=whereStr_" and BonusUnitID='"_UnitID_"'"
	i TargetID'="" s whereStr=whereStr_" and BonusTargetID='"_TargetID_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="TargetCalculateRateID"
	.i sortField="UnitName" s sortField1="BonusUnitID"
	.i sortField="TargetName" s sortField1="BonusTargetID"
	.i sortField="TargetUnitName" s sortField1="TargetUnit"
	.i sortField="ParameterTargetName" s sortField1="ParameterTarget"
	.i sortField="AccountBase" s sortField1="AccountBase"
	.i sortField="StartLimit" s sortField1="StartLimit"
	.i sortField="EndLimit" s sortField1="EndLimit"
	.i sortField="StepSize" s sortField1="StepSize"
	.i sortField="TargetRate" s sortField1="TargetRate"
	.i sortField="TargetDirection" s sortField1="TargetDirection"
	.i sortField="BonusSchemeName" s sortField1="BonusSchemeName"
	.i sortField="SchemeState" s sortField1="SchemeState"
	
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
	s end=start+limit
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^UnitID^UnitName^TargetID^TargetName^TargetUnit^TargetUnitName^ParameterTarget^ParameterTargetName^AccountBase^StartLimit^EndLimit^StepSize^TargetRate^TargetDirection^BonusSchemeID^BonusSchemeName^SchemeState"
	
	While(result.Next()){
	    s UnitName="",TargetIDName="",ParameterTargetName="",TargetUnitName="",BonusSchemeName=""
	    s rowid=result.Data("TargetCalculateRateID")
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
		//参数指标
		s ParameterTarget=result.Data("ParameterTarget")
		i ParameterTarget'="" d
		.i $D(^dhcbsBonusTargetD(ParameterTarget)) d
		..i $G(^dhcbsBonusTargetD(ParameterTarget))'="" d
		...s ParameterTargetName=$List(^dhcbsBonusTargetD(ParameterTarget),3)
	
		s AccountBase=result.Data("AccountBase")
		s StartLimit=result.Data("StartLimit")
		s EndLimit=result.Data("EndLimit")
		s StepSize=result.Data("StepSize")
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
			
		s tmp=rowid_"^"_UnitID_"^"_UnitName_"^"_TargetID_"^"_TargetName_"^"_TargetUnit_"^"_TargetUnitName_"^"_ParameterTarget_"^"_ParameterTargetName_"^"_AccountBase_"^"_StartLimit_"^"_EndLimit_"^"_StepSize_"^"_TargetRate_"^"_TargetDirection_"^"_BonusSchemeID_"^"_BonusSchemeName_"^"_SchemeState
		;w tmp,!
		s count=count+1
			i searchValue'="" d
			.q:(searchField="UnitName")&(UnitName'[searchValue)
			.q:(searchField="TargetName")&(TargetName'[searchValue)
			.q:(searchField="TargetUnitName")&(TargetUnit'[searchValue)
			.q:(searchField="ParameterTargetName")&(ParameterTargetName'[searchValue)
			.q:(searchField="AccountBase")&(AccountBase'[searchValue)
			.q:(searchField="StartLimit")&(StartLimit'[searchValue)
			.q:(searchField="EndLimit")&(EndLimit'[searchValue)
			.q:(searchField="StepSize")&(StepSize'[searchValue)
			.q:(searchField="TargetRate")&(TargetRate'[searchValue)
			.q:(searchField="TargetDirection")&(TargetDirection'[searchValue)
			.q:(searchField="BonusSchemeName")&(BonusSchemeName'[searchValue)
			.q:(searchField="SchemeState")&(SchemeState'[searchValue)
			
			
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
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
	s sqlStr = "select CalUnitID,CalUnitName from dhc_bonus_data.CalUnit where %ID>0 and IsValid=1 "
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
/// others:w ##class(dhc.bonus.udata.uTargetCalculateRate).STList(0,10,"","1")
ClassMethod STList(start, limit, str, SchemeID) As %String
{
    n (start, limit, str, SchemeID)

	s result = ##class(%Library.ResultSet).%New()
	
	s whereStr=""
	s sqlStr = "select b.BonusSchemeID, c.BonusTargetID,c.BonusTargetName "
	_" from dhc_bonus_data.BonusScheme a join dhc_bonus_data.SchemeTarget b on a.BonusSchemeID = b.BonusSchemeID "
	_" join   dhc_bonus_data.BonusTarget c on b.BonusTargetID = c.BonusTargetID"
	_"  where c.DataSource in (3,6,7) and c.IsValid=1 and a.BonusSchemeID ='"_SchemeID_"'"


	i str'="" s whereStr=whereStr_" and c.BonusTargetName like '%"_str_"%'"
	s sqlStr=sqlStr_whereStr

	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	
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
	s sqlStr = "select BonusSchemeID,BonusSchemeName from dhc_bonus_data.BonusScheme where %ID>0  and IsValid=1"
	i str'="" s sqlStr = sqlStr_" and BonusSchemeName LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusSchemeID")
		s name = result.Data("BonusSchemeName")
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
	s sqlStr = "select BonusSchemeID,BonusSchemeName from dhc_bonus_data.BonusScheme where %ID>0 and SchemeState <> 1 and IsValid=1"
	i str'="" s sqlStr = sqlStr_" and BonusSchemeName LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusSchemeID")
		s name = result.Data("BonusSchemeName")
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
/// CreatDate：2011-01-17
/// Description:插入数据
/// Table： dhc.bonus.data.TargetCalculateRate
/// Input：
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uTargetCalculateRate).Insert("2^1^1^11^12^-1^20^70^1^1^1")
ClassMethod Insert(data) As %String
{
	  n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s UnitID=$p(data,"^",1)
		s TargetID=$p(data,"^",2)
		s TargetUnit = $p(data,"^",3)
		s AccountBase = $p(data,"^",4)
		s StepSize = $p(data,"^",5)
		s TargetDirection = $p(data,"^",6)
		s StartLimit = $p(data,"^",7)
		s EndLimit = $p(data,"^",8)
		s TargetRate = $p(data,"^",9)
		s ParameterTarget=$p(data,"^",10)
		s SchemeID=$p(data,"^",11)
		s IsValid=$p(data,"^",12)
		s AuditingState=$p(data,"^",13)
		
		i IsValid=""    s IsValid=1
		i AuditingState="" s AuditingState=0
		s rowid=0
		i UnitID=-1 d
		.f  s rowid=$o(^dhcbsBonusSchemeUnitI("inxScheme",SchemeID,rowid)) q:rowid=""  d
		..s PLIST(2)=rowid
		..i TargetID'="" s PLIST(3)=TargetID
		..i TargetUnit'="" s PLIST(5)=TargetUnit
		..i StartLimit'="" s PLIST(6)=StartLimit
		..i EndLimit'="" s PLIST(7)=EndLimit
		..i TargetDirection'="" s PLIST(8)=TargetDirection
		..i StepSize'="" s PLIST(9)=StepSize
		..i AccountBase'="" s PLIST(10)=AccountBase
		..i TargetRate'="" s PLIST(11)=TargetRate
		..i IsValid'="" s PLIST(12)=IsValid
		..i AuditingState'="" s PLIST(17)=AuditingState
		..i ParameterTarget'="" s PLIST(19)=ParameterTarget
		..i SchemeID'="" s PLIST(20)=SchemeID
        ..&sql(INSERT INTO dhc_bonus_data.TargetCalculateRate VALUES PLIST())
        
        i UnitID'=-1 d
        .i UnitID'="" s PLIST(2)=UnitID
		.i TargetID'="" s PLIST(3)=TargetID
		.i TargetUnit'="" s PLIST(5)=TargetUnit
		.i StartLimit'="" s PLIST(6)=StartLimit
		.i EndLimit'="" s PLIST(7)=EndLimit
		.i TargetDirection'="" s PLIST(8)=TargetDirection
		.i StepSize'="" s PLIST(9)=StepSize
		.i AccountBase'="" s PLIST(10)=AccountBase
		.i TargetRate'="" s PLIST(11)=TargetRate
		.i IsValid'="" s PLIST(12)=IsValid
		.i AuditingState'="" s PLIST(17)=AuditingState
		.i ParameterTarget'="" s PLIST(19)=ParameterTarget
		.i SchemeID'="" s PLIST(20)=SchemeID
		.b
        .&sql(INSERT INTO dhc_bonus_data.TargetCalculateRate VALUES PLIST())
        
        q "OK"
}

/// Creator：王宏宇
/// CreatDate：2011-01-17
/// Description:修改数据
/// Table： dhc.bonus.data.TargetCalculateRate
/// Input：
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uTargetCalculateRate).Update(5,"2^1^2^2^12^-1^20^98^1^1")
ClassMethod Update(rowid, data) As %String
{
	 n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s UnitID=$p(data,"^",1)
		s TargetID=$p(data,"^",2)
		s TargetUnit = $p(data,"^",3)
		s AccountBase = $p(data,"^",4)
		s StepSize = $p(data,"^",5)
		s TargetDirection = $p(data,"^",6)
		s StartLimit = $p(data,"^",7)
		s EndLimit = $p(data,"^",8)
		s TargetRate = $p(data,"^",9)
		s ParameterTarget=$p(data,"^",10)
		s SchemeID=$p(data,"^",11)
	
		/**
		i IsValid=""    s IsValid=1
		i AuditingState="" s AuditingState=0
		**/
		s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
		
		i UnitID'="" s PLIST(2)=UnitID
		i TargetID'="" s PLIST(3)=TargetID
		i TargetUnit'="" s PLIST(5)=TargetUnit
			;i StartLimit'="" 
		s PLIST(6)=StartLimit
		;i EndLimit'="" 
		s PLIST(7)=EndLimit
		i TargetDirection'="" s PLIST(8)=TargetDirection
		;i StepSize'="" 
		s PLIST(9)=StepSize
		;i AccountBase'="" 
		s PLIST(10)=AccountBase
		;i TargetRate'="" 
		s PLIST(11)=TargetRate
		;i ParameterTarget'="" 
		s PLIST(19)=ParameterTarget
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
	
	;&SQL(Update dhc_bonus_data.TargetCalculateRate set IsValid=0 where %ID=:rowid)
	&SQL(delete from dhc_bonus_data.TargetCalculateRate where %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uTargetCalcu7F6S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
