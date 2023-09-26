Class dhc.bonus.umodule.uBonusWorkItem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Weijiangtao
/// CreatDate: 2015-04-14
/// Description: 查询符合条件的记录
/// Table: dhc.bonus.module.BonusWorkItem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.umodule.uBonusWorkItem).ListRec("大样","455","","","","","",0,4)
ClassMethod ListRec(typnam, itmnam, active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (typnam, itmnam, active, searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT a.BonusWorkItemID,b.ItemTypeName,a.WorkItemCode,a.WorkItemName,a.ItemPrice,a.State,AuditingPerson,a.AuditingDate" 
                 _" FROM dhc_bonus_module.BonusWorkItem a,dhc_bonus_module.WorkItemType b"
                 _" WHERE a.WorkItemTypeID=b.WorkItemTypeID"
				 
	    s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="BonusWorkItemID"
		.i sortField="itemtype" s sortField1="ItemTypeName"
		.i sortField="code" s sortField1="WorkItemCode"
		.i sortField="name" s sortField1="WorkItemName"
		.i sortField="price" s searchField1="ItemPrice"
		.i sortField="state" s searchField1="State"
		.i sortField="auditperson" s searchField1="AuditingPerson"
		.i sortField="auditdate" s searchField1="AuditingDate"
		
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		;e  d
		.;s sortStr=" ORDER BY %ID DESC"
		
		i typnam'="" d
		.s sqlStr=sqlStr_" and b.ItemTypeCode='"_typnam_"'"
		i itmnam'="" d
		.s sqlStr=sqlStr_" and (a.WorkItemName like '%"_itmnam_"%' or a.WorkItemCode like '%"_itmnam_"%' ) "
		
		s sqlStr=sqlStr_sortStr
		;w sqlStr,!
		k ^zlgtem
		s ^zlgtem=sqlStr
		
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		s jsonTitle="rowid^itemtype^code^name^price^state^auditperson^auditdate"
		
		While(result.Next())
		{
			s rowid=result.Data("BonusWorkItemID")
			s itemtype=result.Data("ItemTypeName")
			s code=result.Data("WorkItemCode")
			s name=result.Data("WorkItemName")
			s price=result.Data("ItemPrice")
			s state=result.Data("State")
			i state=0   s state="未审核"
		    i state=1   s state="已审核"
			s auditperson=result.Data("AuditingPerson")
			s auditdate=result.Data("AuditingDate")
			
			
			i auditdate'="" s auditdate = $zd(auditdate,3)
			s tmp=rowid_"^"_itemtype_"^"_code_"^"_name_"^"_price_"^"_state_"^"_auditperson_"^"_auditdate
			s count=count+1
			
			i searchValue'="" d
			.q:(searchField="itemtype")&(itemtype'[searchValue)
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			.q:(searchField="price")&(price'[searchValue)
			.q:(searchField="state")&(state'[searchValue)
			.q:(searchField="auditperson")&(auditperson'[searchValue)
			.q:(searchField="auditdate")&(auditdate'[searchValue)
			
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

/// Creator: weijiangtao
/// CreatDate:  2015-04-14
/// Description: 插入新记录
/// Table: dhc.bonus.module.BonusWorkItem
/// Input: data-待插入的数据(itemtype^code^name^price^state^auditperson^auditdate)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.bonus.umodule.uBonusWorkItem).InsertRec(02,1001,"小样11",1000,1,"大样",2015-02-02)
ClassMethod InsertRec(itemtype, code, name, price, state) As %String
{
		n (itemtype,code,name,price,state)
		&sql(insert into dhc_bonus_module.BonusWorkItem(WorkItemTypeID,WorkItemCode,WorkItemName,ItemPrice,State,IsValid) values (:itemtype,:code,:name,:price,0,1))
		q SQLCODE
}

/// Creator: weijiangtao
/// CreatDate: 2015-04-14
/// Description: 更新记录
/// Table: dhc.bonus.module.BonusWorkItem
/// Input: rowid-数据行号;data-待插入的数据(itemtype^code^name^price^state^auditperson^auditdate);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.bonus.umodule.uBonusWorkItem).UpdateRec1(28,"",2,"今天早上测试的","","","","")
ClassMethod UpdateRec1(rowid, itemtype, code, name, price, state, auditperson, auditdate) As %String
{
		n (rowid, itemtype, code, name, price, state, auditperson, auditdate)
		kill PLIST
		
		;s ^zlg11=rowid_","_ itemtype_","_  code_","_  name_","_  price_","_  state_","_  auditperson_","_  auditdate
		i itemtype'= "" s PLIST(2)=itemtype
		i code'= ""        s PLIST(3)=code 
		i name '= ""        s PLIST(4)=name 
		i price'= ""       s PLIST(5)=price 
		s tmp=$zd($h,3)
		s PLIST(6)=$ZDH(tmp,3)
		i auditperson '= "" s PLIST(8)=auditperson
		i auditdate'= "" d
		.s PLIST(9)=$ZDH(auditdate,3)
		i state'= ""       s PLIST(10)=state
		
		
			
		&SQL(UPDATE dhc_bonus_module.BonusWorkItem VALUES PLIST() where %ID=:rowid)
		
		q SQLCODE
}

/// Creator: weijiangtao
/// CreatDate: 2015-04-14
/// Description: 代码是否存在
/// Table: dhc.bonus.module.BonusWorkItem
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.bonus.umodule.uBonusWorkItem).IfRepCode("201006")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCBonusWorkItemCode(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: weijiangtao
/// CreatDate: 2015-04-14
/// Description: 名称是否存在
/// Table: dhc.bonus.module.BonusWorkItem
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.bonus.umodule.uBonusWorkItem).IfRepName("小样")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCBonusWorkItemName(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator:weijiangtao
/// CreatDate:2015-04-14
/// Description:删除数据
/// Table:dhc.bonus.module.BonusWorkItem
/// Input:rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.bonus.umodule.uBonusWorkItem).Delete(3)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM dhc_bonus_module.BonusWorkItem WHERE %ID=:rowid)
	q SQLCODE
}

/// creator:weijiangtao
/// CreatDate:2015-04-17
/// Description:查询数据
/// Table:dhc.bonus.module.BonusWorkItem
/// Input:rowid
/// Output: 
/// Return:返回执行查询语句后的SQLCODE
/// Others:w ##class(dhc.bonus.umodule.uBonusWorkItem).WorkItemTypeList("","","",0,6)
ClassMethod WorkItemTypeList(str, searchValue, sortField, start, limit) As %String
{
			n (str, searchValue, sortField, start, limit)
		
		s sqlStr="select ItemTypeCode,ItemTypeName from dhc_bonus_module.WorkItemType where %ID>0" 
				
	    s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="WorkItemTypeID"
		.i sortField="itemtype" s sortField1="ItemTypeName"
		
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		;e  d
		.;s sortStr=" ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		;w sqlStr,!
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		s jsonTitle="rowid^itemtype"
		
		While(result.Next())
		{
			s rowid=result.Data("ItemTypeCode")
			s itemtype=result.Data("ItemTypeName")
			
			
			s tmp=rowid_"^"_itemtype
			s count=count+1
			
			i searchValue'="" d
			.q:(searchField="itemtype")&(itemtype'[searchValue)
			
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

/// creator:weijiangtao
/// CreatDate:2015-04-20
/// Description:审核数据
/// Table:dhc.bonus.module.BonusWorkItem
/// Input:rowid
/// Output: 
/// Return:返回执行查询语句后的SQLCODE
/// Others:w ##class(dhc.bonus.umodule.uBonusWorkItem).CheckList(6)
ClassMethod CheckList(rowid, username) As %String
{
		n (rowid,username)
		
		s date = $P($h,",",1)	
		&SQL(Update dhc_bonus_module.BonusWorkItem set State=1,AuditingPerson=:username,Auditingdate=:date where %ID=:rowid)
    	
		q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u866B.uBonusWorkItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
