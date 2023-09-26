Class DHCWL.DataQuery.ServOfOutIFCrossQry Extends DHCWL.DataQuery.ServOfOutputIF
{

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	交叉报表输出接口
/// Table：       	无
/// Input：         单元格数据
/// Output： 
/// Return：
Method DoOutput(ByRef aryOutV)
{
	s repid=..aryOutCfg.GetAt("repid")
	s ind=..aryOutCfg.GetAt("ind")
	
	s col=""
	s row=""
		
	f i=1:1:5 {
		s colcell=$g(aryOutV("COLORDER",i,"value"))
		if col="" s col=colcell
		else  s col=col_","_colcell			//生成列信息
		
		s rowcell=$g(aryOutV("ROWORDER",i,"value"))
		if row="" s row=rowcell
		else  s row=row_","_rowcell			//生成行信息
	}
	
	s order=$o(aryOutV("MEASUREORDER",""))
	s desc=$g(aryOutV("MEASUREORDER",order,"desc"))
	s value=$g(aryOutV("MEASUREORDER",order,"value"))
	s showFormat=$g(aryOutV("MEASUREORDER",order,"showFormat"))
	
	//页面不支持，先加上
	/*
	s decimal=0
	if $g(value)'="" {
		if showFormat="#" s decimal=0
		else  if showFormat="#.0" s decimal=1
		else  if showFormat="#.00" s decimal=2
		else  if showFormat="#.000" s decimal=3
		else  if showFormat="#.0000" s decimal=4
		s value=$FNUMBER(value,"",decimal)
	}
	*/
	
	
	
	s measure=order_","_desc_","_value_","_showFormat		//生成度量信息
	
	s data=$lb(row,col,measure)
	
	Set ^CacheTemp(repid,ind)=data
	s ind=ind+1
	d ..aryOutCfg.SetAt(ind,"ind")
}

}
