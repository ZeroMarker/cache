Class dhc.bonus.umodule.uWorkItemTarget Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Weijiangtao
/// CreatDate: 2015-04-22
/// Description: 查询符合条件的记录
/// Table: dhc.bonus.module.WorkItemTargetMap
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.umodule.uWorkItemTarget).ListRec("","","","","","","",0,4)
ClassMethod ListRec(bontarnam, itmnam, active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (bontarnam, itmnam, active, searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT WorkItemTargetMapID,BonusTargetID->BonusTargetName as targetname,BonusWorkItemID->WorkItemName as workitemname,ItemRate,UpdateDate" 
                 _" FROM dhc_bonus_module.WorkItemTargetMap where 1=1"
				 
	    s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="WorkItemTargetMapID"
		.i sortField="bonustarget" s sortField1="targetname"
		.i sortField="workitem"  s sortField1="workitemname"
		.i sortField="auditdate" s searchField1="UpdateDate"
		
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		;e  d
		.;s sortStr=" ORDER BY %ID DESC"
		
		i bontarnam'="" d
		.s sqlStr=sqlStr_" and BonusTargetID='"_bontarnam_"'"
		i itmnam'="" d
		.s sqlStr=sqlStr_" and BonusWorkItemID->WorkItemName='"_itmnam_"'"
		
		s sqlStr=sqlStr_sortStr
		;w sqlStr,!
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		s jsonTitle="rowid^bonustarget^workitem^ItemRate^auditdate"
		
		While(result.Next())
		{
			s rowid=result.Data("WorkItemTargetMapID")
			s bonustarget=result.Data("targetname")
			s workitem=result.Data("workitemname")
			s auditdate=result.Data("UpdateDate")
			s ItemRate=result.Data("ItemRate")
		
			s tmp=rowid_"^"_bonustarget_"^"_workitem_"^"_ItemRate_"^"_auditdate
			s count=count+1
			;w auditdate,!
			i searchValue'="" d
			.q:(searchField="bonustarget")&(bonustarget'[searchValue)
			.q:(searchField="workitem")&(workitem'[searchValue)
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
/// CreatDate:  2015-04-21
/// Description: 插入新记录
/// Table: dhc.bonus.module.WorkItemTargetMap
/// Input: data-待插入的数据(bonustarget^workitem^auditdate)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.bonus.umodule.uWorkItemTarget).InsertRec(1,5,2015-02-02)
ClassMethod InsertRec(bonustarget, workitem, ItemRate) As %String
{
		n (bonustarget,workitem,auditdate,ItemRate)
		
		;s auditdate = $zdh(auditdate,3)
	
		s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
		&sql(INSERT INTO dhc_bonus_module.WorkItemTargetMap(BonusTargetID,BonusWorkItemID,UpdateDate,ItemRate) 
		values (:bonustarget,:workitem,:UpdateDate,:ItemRate))


		q SQLCODE
}

/// Creator: weijiangtao
/// CreatDate: 2015-04-22
/// Description: 更新记录
/// Table: dhc.bonus.module.WorkItemTargetMap
/// Input: rowid-数据行号;data-待插入的数据(bonustarget^workitem^auditdate);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.bonus.umodule.uWorkItemTarget).UpdateRec1(1,3,3,2015-02-02)
ClassMethod UpdateRec1(rowid, bonustarget, workitem, ItemRate) As %String
{
		n (rowid, bonustarget, workitem,ItemRate)
		
		i bonustarget = ""    s bonustarget=$list(^dhcbsmdWorkItemTargetMapD(rowid),2)
		i workitem = ""       s workitem = $list(^dhcbsmdWorkItemTargetMapD(rowid),3)
		i ItemRate= ""       s ItemRate = $list(^dhcbsmdWorkItemTargetMapD(rowid),4)
		s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
			
		&SQL(UPDATE dhc_bonus_module.WorkItemTargetMap(BonusTargetID,BonusWorkItemID,UpdateDate,ItemRate) values (:bonustarget,:workitem,:UpdateDate,:ItemRate) where %ID=:rowid)
		q SQLCODE
}

/// Creator: weijiangtao
/// CreatDate: 2015-04-22
/// Description: 代码是否存在
/// Table: dhc.bonus.module.WorkItemTargetMap
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.bonus.umodule.uWorkItemTarget).IfRepCode("科室扶持补助",33)
ClassMethod IfRepCode(bontar, workitem) As %String
{
	n (bontar,workitem)
	s rowid=0
	s rowid=$o(^dhcbsmdWorkItemTargetMapI(0,"dhcbsmdWorkitemBonusTarget",bontar,workitem,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator:weijiangtao
/// CreatDate:2015-04-22
/// Description:删除数据
/// Table:dhc.bonus.module.WorkItemTargetMap
/// Input:rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.bonus.umodule.uWorkItemTarget).Delete(3)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM dhc_bonus_module.WorkItemTargetMap WHERE %ID=:rowid)
	q SQLCODE
}

/// creator:weijiangtao
/// CreatDate:2015-04-21
/// Description:查询数据
/// Table:dhc_bonus_data.BonusTarget
/// Input:rowid
/// Output: 
/// Return:返回执行查询语句后的SQLCODE
/// Others:w ##class(dhc.bonus.umodule.uWorkItemTarget).BonusTargetList("","","",0,6)
ClassMethod BonusTargetList(str, searchValue, sortField, start, limit) As %String
{
			n (str, searchValue, sortField, start, limit)
		
		s sqlStr="SELECT BonusTargetID,BonusTargetName FROM dhc_bonus_data.BonusTarget where DataSource=9" 
				
	    s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="BonusTargetID"
		.i sortField="bonustarget" s sortField1="BonusTargetName"
		
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
		s jsonTitle="rowid^bonustarget"
		
		While(result.Next())
		{
			s rowid=result.Data("BonusTargetID")
			s bonustarget=result.Data("BonusTargetName")
			
			
			s tmp=rowid_"^"_bonustarget
			s count=count+1
			
			i searchValue'="" d
			.q:(searchField="bonustarget")&(bonustarget'[searchValue)
			
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
/// CreatDate:2015-04-22
/// Description:查询数据
/// Table:dhc_bonus_module.BonusWorkItem
/// Input:rowid
/// Output: 
/// Return:返回执行查询语句后的SQLCODE
/// Others:w ##class(dhc.bonus.umodule.uWorkItemTarget).WorkItemList("","","",0,6)
ClassMethod WorkItemList(str, searchValue, sortField, start, limit) As %String
{
		n (str, searchValue, sortField, start, limit)
		
		s sqlStr="SELECT BonusWorkItemID,WorkItemName FROM dhc_bonus_module.BonusWorkItem where %ID>0" 
				
	    s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="BonusWorkItemID"
		.i sortField="workitem" s sortField1="WorkItemName"
		
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
		s jsonTitle="rowid^workitem"
		
		While(result.Next())
		{
			s rowid=result.Data("BonusWorkItemID")
			s workitem=result.Data("WorkItemName")
			
			
			s tmp=rowid_"^"_workitem
			s count=count+1
			
			i searchValue'="" d
			.q:(searchField="workitem")&(workitem'[searchValue)
			
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

Storage Default
{
<StreamLocation>^dhc.bonus866B.uWorkItemTa66DBS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
