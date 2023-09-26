/// Creator: 刘洋
/// CreatDate: 2011-1-19
/// Description:奖金核算单元维护
Class dhc.bonus.udata.uBonusUnit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：刘洋
/// CreatDate：2011-1-19
/// Description: 查询符合条件的奖金单元设置记录
/// Table：dhc.bonus.data.BonusUnit
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusUnit).List("","","","",0,25,"0")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parent) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parent)
	
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0
	i parent'="" d
	.i $D(^dhcbsBonusUnitD(parent)) d
	..i $G(^dhcbsBonusUnitD(parent))'="" s tmpEnd=$L(^dhcbsBonusUnitD(parent),8)
	..e  s tmpEnd=0
	
	//SQL
	s sqlStr="select BonusUnitID,BonusUnitCode,EmployeeNo,BonusUnitName,Spell,UnitFlag,SuperiorUnitID,UnitLevel,LastStage,UpdateDate,IsValid,BonusUnitTypeID"
		_" ,sumUnitID as mID,sumUnitID->BonusUnitName sumUnitName,startdate "
		_" from dhc_bonus_data.BonusUnit"
	s whereStr=" where %ID>0 and IsValid=1 "
	s whereStr=whereStr_" and SuperiorUnitID ='"_parent_"'"

	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusUnitID"
	
	.i sortField="code" s sortField1="BonusUnitCode"
	.i sortField="name" s sortField1="BonusUnitName"
	.i sortField="EmployeeNo" s sortField1="EmployeeNo"
	 
	.i sortField="UnitFlagName" s sortField1="UnitFlag"
	.i sortField="SuperiorUnitName" s sortField1="SuperiorUnitID"
	.i sortField="UnitLevel" s sortField1="UnitLevel"
	.i sortField="LastStage" s sortField1="LastStage"
	.i sortField="UpdateDate" s sortField1="UpdateDate"
	.i sortField="BonusUnitTypeName" s sortField1="BonusUnitTypeID"

	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by BonusUnitCode asc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	//w sqlStr,!
	;k ^zlgtemp
	;s ^zlgtemp=sqlStr
	
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	;i (tmpEnd=0)||(parent=0) d
	d result.Prepare(sqlStr)
	d result.Execute()
	//取结构
	While(result.Next()){
		//集体初始化
		s UnitFlagName="",SuperiorUnitName="",BonusUnitTypeName=""
		s rowid = result.Data("BonusUnitID")
		
		//单元属性
		s UnitFlag = result.Data("UnitFlag")
		i UnitFlag=0 s UnitFlagName="单元分组"
		i UnitFlag=1 s UnitFlagName="核算科室"
		i UnitFlag=2 s UnitFlagName="医疗组"
		i UnitFlag=3 s UnitFlagName="核算人员"
		i UnitFlag=4 s UnitFlagName="his科室"
		
			
		s code = result.Data("BonusUnitCode")
		s name = result.Data("BonusUnitName")
		s Spell = result.Data("Spell")
		s sumUnitID = result.Data("mID")
		s sumUnitName = result.Data("sumUnitName")
		s startdate = result.Data("StartDate")
		
		//单元类别
		s BonusUnitTypeDr = result.Data("BonusUnitTypeID")
		s EmployeeNo = result.Data("EmployeeNo")
		
		i BonusUnitTypeDr'="" d
		.i $D(^dhcbsBonusUnitTypeD(BonusUnitTypeDr)) d
		..i $G(^dhcbsBonusUnitTypeD(BonusUnitTypeDr))'="" d
		...s BonusUnitTypeName=$List(^dhcbsBonusUnitTypeD(BonusUnitTypeDr),3)
		
		//末端标志
		s LastStage = result.Data("LastStage")
		i LastStage=1 s Flag="true"
		i LastStage=0 s Flag="false"		
	
		//上级单元
		s SuperiorUnitName=""
		s parent = result.Data("SuperiorUnitID")
		i parent'="" d
		.i $D(^dhcbsBonusUnitD(parent)) d
		..i $G(^dhcbsBonusUnitD(parent))'="" d
		...s SuperiorUnitName=$List(^dhcbsBonusUnitD(parent),3)
		
		//单元级别
		s level = result.Data("UnitLevel")
		
		//s resultString=resultString_"{id:'"_rowid_"',UnitFlagName:'"_UnitFlagName_"',EmployeeNo:'"_EmployeeNo_"',code:'"_code_"',name:'"_name_"',Spell:'"_Spell_"',BonusUnitTypeDr:'"_BonusUnitTypeDr_"',BonusUnitTypeName:'"_BonusUnitTypeName_"',LastStage:'"_LastStage_"',parent:'"_parent_"',SuperiorUnitName:'"_SuperiorUnitName_"',level:'"_level_"',leaf:"_Flag_",uiProvider:'col',UnitFlagDr:"_UnitFlag_"},"
	
		s resultString=resultString_"{id:'"_rowid_"',ufn:'"_UnitFlagName_"',mid:'"_sumUnitID_"',mn:'"_sumUnitName_"',cd:'"_code_"',nm:'"_name_"',btr:'"_BonusUnitTypeDr_"',btn:'"_BonusUnitTypeName_"',ls:'"_LastStage_"',parent:'"_parent_"',lv:'"_level_"',leaf:"_Flag_",uiProvider:'col',UnitFlagDr:"_UnitFlag_",sn:'"_SuperiorUnitName_"',sd:'"_startdate _"'},"
		//_"',sn:'"_SuperiorUnitName 
	}
	s resultString=resultString_"]"
	d result.Close()
	//s ^aa=resultString
	q resultString
	//q "[{id:'370',UnitFlagName:'科室',EmployeeNo:'',code:'10',name:'收费处',Spell:'',BonusUnitTypeDr:'22',BonusUnitTypeName:'收费处',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:1},{id:'371',UnitFlagName:'科室',EmployeeNo:'',code:'11',name:'住院处',Spell:'',BonusUnitTypeDr:'23',BonusUnitTypeName:'住院处',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:1},{id:'114',UnitFlagName:'',EmployeeNo:'',code:'01',name:'临床科室',Spell:'',BonusUnitTypeDr:'13',BonusUnitTypeName:'临床科室',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:0},{id:'115',UnitFlagName:'',EmployeeNo:'',code:'02',name:'医技科室',Spell:'',BonusUnitTypeDr:'14',BonusUnitTypeName:'医技科室',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:0},{id:'324',UnitFlagName:'科室',EmployeeNo:'',code:'03',name:'药剂科',Spell:'',BonusUnitTypeDr:'15',BonusUnitTypeName:'药剂科',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:1},{id:'364',UnitFlagName:'科室',EmployeeNo:'',code:'04',name:'药品库房',Spell:'',BonusUnitTypeDr:'16',BonusUnitTypeName:'药品药房',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:1},{id:'365',UnitFlagName:'科室',EmployeeNo:'',code:'05',name:'制剂室',Spell:'',BonusUnitTypeDr:'17',BonusUnitTypeName:'制剂室',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:1},{id:'366',UnitFlagName:'科室',EmployeeNo:'',code:'06',name:'体检中心',Spell:'',BonusUnitTypeDr:'18',BonusUnitTypeName:'体检中心',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:1},{id:'367',UnitFlagName:'科室',EmployeeNo:'',code:'07',name:'社区医疗',Spell:'',BonusUnitTypeDr:'19',BonusUnitTypeName:'社区医疗',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:1},{id:'368',UnitFlagName:'科室',EmployeeNo:'',code:'08',name:'门诊治疗室',Spell:'',BonusUnitTypeDr:'20',BonusUnitTypeName:'门诊治疗室',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:1},{id:'369',UnitFlagName:'科室',EmployeeNo:'',code:'09',name:'传统疗法门诊',Spell:'',BonusUnitTypeDr:'21',BonusUnitTypeName:'传统疗法中心',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:1},]"
}

/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusUnit
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusUnit).IfRepCode("001")
ClassMethod IfRepCode(code, parent) As %String
{
	new (code,parent)
	s rowid=0
	
	&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.BonusUnit	WHERE BonusUnitCode=:code AND SuperiorUnitID=:parent and IsValid=1)
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 名称是否存在
/// Table：dhc.bonus.data.BonusUnit
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusUnit).IfRepName("医疗收入类")
ClassMethod IfRepName(name, parent) As %String
{
	new (name,parent)
	s rowid=0
	
	&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.BonusUnit
	WHERE BonusUnitName=:name AND SuperiorUnitID=:parent AND IsValid=1)
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：刘洋
/// CreatDate：2011-1-17
/// Description: 获取科室类别
/// Table：dhc.bonus.data.BonusUnitType
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uBonusUnit).unitType(0,10,"管","")
ClassMethod unitType(start, limit, str, unitFlag) As %String
{
	n (start, limit, str,unitFlag)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT BonusUnitTypeID,UnitTypeName from dhc_bonus_data.BonusUnitType where IsValid=1"
	i str'="" s sqlStr = sqlStr_" and UnitTypeName like '%"_str_"%'"
	
	if unitFlag="单元分组" d
	.s sqlStr =sqlStr_" and IsDeptmentType =1 "
	if unitFlag="医疗组" d
	.s sqlStr =sqlStr_" and IsMedicalGroup =1 "
	if unitFlag="核算人员" d
	.s sqlStr =sqlStr_" and IsPersonType =1 "	
	
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusUnitTypeID")
		s name = result.Data("UnitTypeName")

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

/// Creator：刘洋
/// CreatDate：2011-1-17
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusUnit
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusUnit).InsertRec("13","眼科","yk","1","1","1","1","1")
ClassMethod InsertRec(code, name, EmployeeNo, unitFlag, unitType, lastStage, parent, level, sumunit, startDate) As %String
{
	
	n (code,name,EmployeeNo,unitFlag,unitType,lastStage,parent, level,sumunit,startDate)
	
	s rowid=0
	s rowid=..IfRepCode(code,parent)
	q:rowid>0 "RepCode"
	s rowid=0
	s rowid=..IfRepName(name,parent)
	q:rowid>0 "RepName"
	
	s EmployeeNo=code
	
	s level=level+1
	s IsValid=1
	i lastStage=1 s level=3
	s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	s UpdateDate=$zdh(UpdateDate,3)

	&sql(insert into dhc_bonus_data.BonusUnit (BonusUnitCode,BonusUnitName,EmployeeNo,UnitFlag,SuperiorUnitID,UnitLevel,LastStage,UpdateDate,IsValid,BonusUnitTypeID,sumUnitID,startDate) values(:code,:name,:EmployeeNo,:unitFlag,:parent,:level,:lastStage,:UpdateDate,:IsValid,:unitType,:sumunit,:startDate))
	q SQLCODE
}

/// Creator:刘洋
/// CreatDate:2011-1-17
/// Description:删除奖金单元记录
/// Table:dhc.bonus.data.BonusUnit
/// Input:rowid-奖金单元记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.bonus.udata.uBonusUnit).Delete(33)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	//q:$G(^dhcbsBonusUnitI("Parent",rowid)) "childNode"
	//==========================
	//^dhcbsBonusUnitI("Parent",2,5)
	s flag="true"
	
	i $D(^dhcbsBonusUnitI("Parent",rowid)) d
	.s childRowid=0
	.f  s childRowid=$O(^dhcbsBonusUnitI("Parent",rowid,childRowid)) q:(childRowid="")||(flag="false")  d
	..i $D(^dhcbsBonusUnitD(childRowid)) d
	...s curr=$G(^dhcbsBonusUnitD(childRowid))
	...i curr'="" d
	....s active=$List(curr,10)
	....i active=1 d
	.....;有效标志
	.....s flag="false"
	
	i flag="true" d //
	.&SQL(update dhc_bonus_data.BonusUnit set IsValid=0 where %ID=:rowid)
	
	q flag

	
	//==========================
	
	//s rowId=0
	//s rowId=$G(^dhcbsBonusUnitI("Parent",rowid))
	
	//s isvalid=$List(^dhcbsBonusUnitD(rowId),6)
	//i rowId="" d  s rowId=0

	
	
	/*
	//寻找上级节点的ID
	s parentID=$List(^dhcbsBonusUnitD(rowid),6)
	
	//1.删除本条记录
	//&SQL(delete from dhc_bonus_data.BonusUnit where %ID=:rowid)
	&sql(update dhc_bonus_data.BonusUnit set IsValid=0 where %ID=:rowid)
	s str=SQLCODE
	
	//2.如果该条记录的上级没有其他子节点,则将上级节点修改成一个子节点
	i $D(^dhcbsBonusUnitI("Parent",parentID)) d
	.;不做任何处理
	e  d
	.i parentID'=0 d
	..&SQL(update dhc_bonus_data.BonusUnit set LastStage = 1 where %ID=:parentID)
	..s str=SQLCODE
	
	q str
	*/
}

/// Creator:刘洋
/// CreatDate:2011-1-17
/// Description:获取父节点(删除刷新功能)
/// Table:dhc.bonus.data.BonusUnit
/// Input:parent-奖金单元记录ID
/// Output: 
/// Return:返回父节点ID
/// Others:w ##class(dhc.bonus.udata.uBonusUnit).GetFatherNode(5)
ClassMethod GetFatherNode(parent) As %String
{
	n (parent)
	
	q:parent="" 0
	s parentID=0
	i $D(^dhcbsBonusUnitD(parent)) d
	.i $G(^dhcbsBonusUnitD(parent))'="" d
	..s parentID=$List(^dhcbsBonusUnitD(parent),6)
	q parentID
}

/// Creator：刘洋
/// CreatDate：2011-1-17
/// Description: 更新奖金单元记录
/// Table：dhc.bonus.data.BonusUnit
/// Input：rowid-所在行号;
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusUnit).Update(21,"")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	s ^zlgtem1=data
	k PLIST
	//s rowId=0
	//s rowId=..IfRepCode(code)
	//q:rowId>0 "RepCode"
	
	//s rowId=..IfRepName(name)
    //q:rowId>0 "RepName"
    
	s code=$p(data,"^",1)        
	s rowId=..IfRepCode(code)
	q:(rowId'=0)&(rowId'=rowid) "RepCode"
	
	s PLIST(2)=code	
	
	s name=$p(data,"^",2)        
	s rowId=..IfRepName(name)
   // q:(rowId'=0)&(rowId'=rowid) "RepName"
	s PLIST(3)=name	
	
	s EmployeeNo=$p(data,"^",3)
	s PLIST(12)=EmployeeNo	
	
	s flag=$p(data,"^",4)
	s PLIST(5)=flag 
	
	s typeDr=$p(data,"^",5)
	s PLIST(11)=typeDr 
	
	
	s isEnd=$p(data,"^",6)
	s PLIST(8)=isEnd
	
	s parent=$p(data,"^",7)
	s PLIST(6)=parent
	
	s level=$p(data,"^",8)
	s PLIST(7)=level
	
	s sumdr=$p(data,"^",9)
	s PLIST(13)=sumdr
	
	s inHDate=$p(data,"^",10)
	s PLIST(14)=inHDate
	
	s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	s UpdateDate=$zdh(UpdateDate,3)
	s PLIST(9)=UpdateDate
	k ^zlgtmp
	s ^zlgtmp=rowid_"^"_parent
	q:rowid=parent "RepCode1"
	
	&sql(update dhc_bonus_data.BonusUnit values PLIST() where %ID=:rowid)
	
	q SQLCODE
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-25
/// Description: 获取末级核算单元
/// Table: dhc_bonus_data.BonusUnit
/// Input: sUnitFlag-核算单元类别 1：科室、2：医疗组、3：人员、空：全部
/// Output: 
/// Return: 末级核算单元
/// Others: w ##class(dhc.bonus.udata.uBonusUnit).GetLastUnit("1","0","0","10")       
ClassMethod GetLastUnit(sUnitFlag, LastStage, start, limit) As %Integer
{
	n (sUnitFlag,LastStage, start, limit)

	s sqlStr="select BonusUnitID,BonusUnitName,BonusUnitTypeID->UnitTypeName from dhc_bonus_data.BonusUnit"
	s sqlStr=sqlStr_" where  LastStage="_LastStage_" and IsValid=1 "
	;if sUnitFlag'="" d
	 .;s sqlStr=sqlStr_" and UnitFlag="_sUnitFlag
	
	s sqlStr=sqlStr_" order by  BonusUnitTypeID,SuperiorUnitID,BonusUnitName"
	
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=1
	s end=start+limit-1
	
	//BonusUnitID,BonusUnitName
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	d json.InsertRowData("-1^全部")
	While(result.Next()){
		s rowid = result.Data("BonusUnitID")
		s name = result.Data("BonusUnitName")
		s UnitTypeName = result.Data("UnitTypeName")

		s tmp=rowid_"^"_name_"_"_UnitTypeName
		;w tmp,!
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
	q resultString
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-25
/// Description: 获取末级核算单元
/// Table: dhc_bonus_data.BonusUnit
/// Input: sUnitFlag-核算单元类别 1：科室、2：医疗组、3：人员、空：全部
/// Output: 
/// Return: 末级核算单元
/// Others: w ##class(dhc.bonus.udata.uBonusUnit).GetUnitList("","0","44","0","10")       
ClassMethod GetUnitList(sUnitFlag, LastStage, str, start, limit) As %Integer
{
	n (sUnitFlag,LastStage,str, start, limit)

	s sqlStr="select BonusUnitID,BonusUnitName,BonusUnitTypeID->UnitTypeName from dhc_bonus_data.BonusUnit"
	s sqlStr=sqlStr_" where  LastStage="_LastStage_" and IsValid=1 "
	if sUnitFlag'="" d
	 .s sqlStr=sqlStr_" and  UnitFlag="_sUnitFlag
	if str'="" d
	.s sqlStr=sqlStr_" and  (BonusUnitCode like '%"_str_"%' or BonusUnitName like '%"_str_"%')"
	
	
	s sqlStr=sqlStr_" order by  BonusUnitTypeID,SuperiorUnitID,BonusUnitName"
	
	;s ^zlgsql=sqlStr 
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=1
	s end=start+limit-1
	
	//BonusUnitID,BonusUnitName
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	d json.InsertRowData("-1^全部")
	While(result.Next()){
		s rowid = result.Data("BonusUnitID")
		s name = result.Data("BonusUnitName")
		s UnitTypeName = result.Data("UnitTypeName")

		s tmp=rowid_"^"_name_"_"_UnitTypeName
		;w tmp,!
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
	q resultString
}

/// Creator：zhao liguo
/// CreatDate：2011-3-18
/// Description: 查询发放奖金的科室人员
/// Table：dhc_bonus_data.BonusUnit
/// Input：sUnitID-核算单元ID;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusUnit).GetUnitEmp(63)
ClassMethod GetUnitEmp(sUnitID) As %String
{
	n (sUnitID)
	//SQL select BonusEmployeeID,EmployeeCode,EmployeeName
	//
	s sqlStr=" select BonusUnitID AS BonusEmployeeID, BonusUnitCode as EmployeeCode,BonusUnitName EmployeeName from  dhc_bonus_data.BonusUnit "
	s sqlStr = sqlStr_"  where  IsValid=1 and UnitFlag in(2,3) and SuperiorUnitID ="_sUnitID

			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0

	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	
	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusEmployeeID")
		s code = result.Data("EmployeeCode")
		s name = result.Data("EmployeeName")
		s tmp=rowid_"^"_name
		

		
		d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：zhao liguo
/// CreatDate：2011-3-18
/// Description: 查询发放奖金的科室人员
/// Table：dhc_bonus_data.BonusUnit
/// Input：sUnitID-核算单元ID;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusUnit).GetUnitByUnitFlag(4,0,5)
ClassMethod GetUnitByUnitFlag(UnitFlag, start, limit) As %String
{
	n (UnitFlag, start, limit)
	//SQL select BonusEmployeeID,EmployeeCode,EmployeeName
	//
	s sqlStr=" select BonusUnitID , BonusUnitCode ,BonusUnitName  from  dhc_bonus_data.BonusUnit "
	s sqlStr = sqlStr_"  where  IsValid=1 and  UnitFlag ="_UnitFlag

	;w sqlStr,!		
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString = ""
	s end = start+limit
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	
	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusUnitID")
		s code = result.Data("BonusUnitCode")
		s name = result.Data("BonusUnitName")
		s tmp=rowid_"^"_name
		

		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：zhao liguo
/// CreatDate：2011-3-18
/// Description: 查询发放奖金的科室人员
/// Table：dhc_bonus_data.BonusUnit
/// Input：sUnitID-核算单元ID;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusUnit).GetUnitBySuper(179,0,5)
ClassMethod GetUnitBySuper(UnitSuperID, start, limit) As %String
{
	n (UnitSuperID, start, limit)
	//SQL select BonusEmployeeID,EmployeeCode,EmployeeName
	//
	s sqlStr=" select BonusUnitID , BonusUnitCode ,BonusUnitName  from  dhc_bonus_data.BonusUnit "
	s sqlStr = sqlStr_"  where  IsValid=1 and  SuperiorUnitID ="_UnitSuperID

	;w sqlStr,!		
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString = ""
	s end = start+limit
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	s tmp=-1_"^"_"科室下所有单元"
	d json.InsertRowData(tmp)
	
	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusUnitID")
		s code = result.Data("BonusUnitCode")
		s name = result.Data("BonusUnitName")
		s tmp=rowid_"^"_name
		

		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uBonusUnitS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
