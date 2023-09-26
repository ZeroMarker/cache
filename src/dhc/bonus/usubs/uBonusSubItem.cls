/// Creator: 阮成林
/// CreatDate: 2011-6-13
/// Description:奖金辅助项目维护
Class dhc.bonus.usubs.uBonusSubItem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：阮成林
/// CreatDate：2011-1-19
/// Description: 查询符合条件的奖金单元设置记录
/// Table：dhc.bonus.subs.BonusSubItem
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.usubs.uBonusSubItem).List("","","","",0,25,"1")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parent) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parent)
	
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0
	i parent'="" d
	.i $D(^dhcbsSubItemD(parent)) d
	..i $G(^dhcbsSubItemD(parent))'="" s tmpEnd=$L(^dhcbsSubItemD(parent),5)
	..e  s tmpEnd=0
	
	//SQL
	s sqlStr="select * from dhc_bonus_subs.BonusSubItem"
	s whereStr=" where %ID>0 and IsValid=1 "
	s whereStr=whereStr_" and SuperiorItemID ='"_parent_"'"

	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusSubItemID"
	
	.i sortField="code" s sortField1="SubItemCode"
	.i sortField="name" s sortField1="SubItemName"
	
	.i sortField="type" s sortField1="SubItemType"
	.i sortField="SuperiorItemID" s sortField1="SuperiorItemID"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by SubItemCode asc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr , !
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	;i (tmpEnd=0)||(parent=0) d
	d result.Prepare(sqlStr)
	d result.Execute()
	//取结构
	While(result.Next()){
		//集体初始化
		s ItemTypeName="",SuperiorItemName=""
		s rowid = result.Data("BonusSubItemID")
		
	
		s code = result.Data("SubItemCode")
		s name = result.Data("SubItemName")
		
		//项目属性
		s type = result.Data("SubItemType")
		i type=1 s ItemTypeName="收入项目"
		i type=2 s ItemTypeName="工作量项目"
		i type=3 s ItemTypeName="支出项目"
		
		
		
		//末端标志
		s LastStage = result.Data("LastStage")
		i LastStage=1 s Flag="true"
		i LastStage=0 s Flag="false"		
	
		//上级单元
		s parent = result.Data("SuperiorItemID")
		i parent'="" d
		.i $D(^dhcbsSubItemD(parent)) d
		..i $G(^dhcbsSubItemD(parent))'="" d
		...s SuperiorItemName=$List(^dhcbsSubItemD(parent),3)
		
		//单元级别
		//s level = result.Data("UnitLevel")
		
		s resultString=resultString_"{id:'"_rowid_"',type:'"_type_"',SubItemName:'"_ItemTypeName_"',code:'"_code_"',name:'"_name_"',ItemTypeName:'"_ItemTypeName_"',lastStage:'"_LastStage_"',parent:'"_parent_"',SuperiorItemName:'"_SuperiorItemName_"',leaf:"_Flag_",uiProvider:'col'},"
	}
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator：阮成林
/// CreatDate：2011-6-14
/// Description: 取出Combobox所许要的有效单位,作修改时获取上级项目ID
/// Table：dhc.dura.data.DictInvType
/// Input：start:开始记录位置;limit:记录条数;str:模糊查询字段
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.usubs.uBonusSubItem).itemListRec(0,10,"")
ClassMethod itemListRec(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT BonusSubItemID,SubItemName from dhc_bonus_subs.BonusSubItem where LastStage=0 and IsValid=1 "
	i str'="" s sqlStr = sqlStr_" and SubItemName like '%"_str_"%'"
	
	
	
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusSubItemID")
		s name = result.Data("SubItemName")

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

/// Creator: 阮成林
/// CreatDate: 2011-6-13
/// Description: 代码是否存在
/// Table：dhc.bonus.subs.BonusSubItem
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.usubs.uBonusSubItem).IfRepCode("001")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	;s rowid=0
	;&sql(select count(*) into :rowid from dhc_bonus_subs.BonusSubItem 
	;WHERE SubItemCode=:code AND IsValid=1)
	;s rowid=$o(^dhcbsSubItemI("SubsItemCode",code,rowid))
	;i rowid="" d  s rowid=0
	;q rowid
	
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubItem WHERE IsValid =1 AND SubItemCode ='"_code_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("BonusSubItemID")
	}
	q rowid
}

/// Creator: 阮成林
/// CreatDate: 2011-6-13
/// Description: 名称是否存在
/// Table：dhc.bonus.subs.onusSubItem
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.usubs.uBonusSubItem).IfRepName("医疗收入类")
ClassMethod IfRepName(name) As %String
{
	new (name)
	s rowid=0
	;s rowid=$o(^dhcbsSubItemI("SubsItemName",name,rowid))
	&sql(select count(*) into :rowid from dhc_bonus_subs.BonusSubItem 
	WHERE SubItemName=:name AND IsValid=1)
	
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：阮成林
/// CreatDate：2011-6-13
/// Description: 插入一条新数据
/// Table：dhc.bonus.subs.BonusSubItem
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.usubs.uBonusSubItem).InsertRec("22","33","1","","1")
ClassMethod InsertRec(code, name, type, parent, lastStage) As %String
{
	
	n (code, name, type,  parent,lastStage)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	//s rowid=..IfRepName(name)
	//q:rowid>0 "RepName"
	
	
	//s level=level+1
	//s parent=0
	s IsValid=1
	
	&sql(insert into dhc_bonus_subs.BonusSubItem (SubItemCode,SubItemName,SubItemType,SuperiorItemID,LastStage,IsValid) values(:code,:name,:type,:parent,:lastStage,:IsValid))
	q SQLCODE
}

/// Creator:阮成林
/// CreatDate:2011-1-17
/// Description:删除一条记录
/// Table:dhc.bonus.subs.BonusSubItem
/// Input:rowid-项目记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.bonus.usubs.uBonusSubItem).Delete(16)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	
	s flag="true"
	
	i $D(^dhcbsSubItemI("Parent",rowid)) d
	.s childRowid=0
	.f  s childRowid=$O(^dhcbsSubItemI("Parent",rowid,childRowid)) q:(childRowid="")||(flag="false")  d
	..i $D(^dhcbsSubItemD(childRowid)) d
	...s curr=$G(^dhcbsSubItemD(childRowid))
	...i curr'="" d
	....s active=$List(curr,7)
	....i active=1 d
	.....;有效标志
	.....s flag="false"
	
	i flag="true" d //
	.;&SQL(update dhc_bonus_subs.BonusSubItem set IsValid=0 where %ID=:rowid)
	.&SQL(delete from  dhc_bonus_subs.BonusSubItem where %ID=:rowid)
	q flag
}

/// Creator:阮成林
/// CreatDate:2011-6-14
/// Description:获取父节点(删除刷新功能)
/// Table:dhc.bonus.subs.BonusSubItem
/// Input:parent-奖金单元记录ID
/// Output: 
/// Return:返回父节点ID
/// Others:w ##class(dhc.bonus.udata.uBonusUnit).GetFatherNode(5)
ClassMethod GetFatherNode(parent) As %String
{
	n (parent)
	
	q:parent="" 0
	s parentID=0
	i $D(^dhcbsSubItemD(parent)) d
	.i $G(^dhcbsSubItemD(parent))'="" d
	..s parentID=$List(^dhcbsSubItemD(parent),6)
	q parentID
}

/// Creator：阮成林
/// CreatDate：2011-1-17
/// Description: 更新项目单元记录
/// Table：dhc.bonus.subs.BonusSubItem
/// Input：rowid-所在行号;
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.usubs.uBonusSubItem).Update(21,"")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	
	k PLIST
	
    //var data = code + "^" + name + "^" + type + "^" + parent + "^" + isEnd + "^" ;
	s code=$p(data,"^",1)        
	s rowId=..IfRepCode(code)
	q:(rowId'=0)&(rowId'=rowid) "RepCode"
	s PLIST(2)=code	
	
	s name=$p(data,"^",2)        
	//s rowId=..IfRepName(name)
   // q:(rowId'=0)&(rowId'=rowid) "RepName"
	s PLIST(3)=name	
	
	s type=$p(data,"^",3)
	s PLIST(4)=type	
	
	s parent=$p(data,"^",4)
	s PLIST(5)=parent
	
		
	s isEnd=$p(data,"^",5)
	s PLIST(6)=isEnd
	
	
	

	
	&sql(update dhc_bonus_subs.BonusSubItem values PLIST() where %ID=:rowid)
	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.usubs.uBonusSubItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
