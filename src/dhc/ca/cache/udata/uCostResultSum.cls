/// Creator: 杨旭
/// CreatDate: 2010-03-22
/// Description: 数据类别码表维护
Class dhc.ca.cache.udata.uCostResultSum Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-22
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.CostResultSum
/// Input: intervalDr-月份ID;barnchFlag-枝叶标志;blDr-枝/叶Dr;self-直接成本;dist-分摊成本;cat-分录成本;sum-汇总;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(costSetsDr, intervalDr, barnchFlag, blDr, self, dist, cat, sum) As %String
{
	n (costSetsDr, intervalDr, barnchFlag, blDr, self, dist, cat, sum)
	
	&SQL(INSERT INTO dhc_ca_cache_data.CostResultSum (CostResultSum_parRef,CostResultSum_intervalDr,CostResultSum_branchFlag,CostResultSum_blDr,CostResultSum_self,CostResultSum_dist,CostResultSum_cat,CostResultSum_sum) VALUES (:costSetsDr, :intervalDr, :barnchFlag, :blDr, :self, :dist, :cat, :sum))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-22
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.CostResultSum
/// Input: intervalDr-月份ID;barnchFlag-枝叶标志;blDr-枝/叶Dr;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: 
ClassMethod ListRec(costSetsDr, intervalDr, barnchFlag, blDr)
{
	n (costSetsDr, intervalDr, barnchFlag, blDr)
	
	s sqlStr="SELECT CostResultSum_rowid,CostResultSum_intervalDr,CostResultSum_branchFlag,CostResultSum_blDr,CostResultSum_self,CostResultSum_dist,CostResultSum_cat,CostResultSum_sum FROM dhc_ca_cache_data.CostResultSum"
	
	s whereStr=" WHERE %ID>0"
	i intervalDr'="" s whereStr=whereStr_" AND CostResultSum_intervalDr='"_intervalDr_"' "
	i barnchFlag'="" s whereStr=whereStr_" AND CostResultSum_branchFlag='"_barnchFlag_"' "
	i blDr'="" s whereStr=whereStr_" AND CostResultSum_blDr='"_blDr_"' "
	i costSetsDr'="" s whereStr=whereStr_" AND CostResultSum_parRef='"_costSetsDr_"' "
	
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s resultString=""

	
	While(result.Next())
	{
		s self=result.Data("CostResultSum_self")
		s dist=result.Data("CostResultSum_dist")
		s cat=result.Data("CostResultSum_cat")
		s sum=result.Data("CostResultSum_sum")
		s resultString=self_"^"_dist_"^"_cat_"^"_sum
	}

	d result.Close()
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2010-03-22
/// Description: 删除记录
/// Table: dhc.ca.cache.data.CostResultSum
/// Input：intervalDr-月份ID;costSetsDr-分摊套ID;
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uCostResultSum).DelRec(5,1)
ClassMethod DelRec(intervalDr, costSetsDr) As %String
{
	n (intervalDr,costSetsDr)
	&SQL(DELETE FROM dhc_ca_cache_data.CostResultSum WHERE CostResultSum_intervalDr=:intervalDr and CostResultSum_parRef=:costSetsDr)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uCostResultSumS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
