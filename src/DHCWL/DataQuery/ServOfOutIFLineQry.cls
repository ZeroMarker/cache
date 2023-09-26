Class DHCWL.DataQuery.ServOfOutIFLineQry Extends DHCWL.DataQuery.ServOfOutputIF
{

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	行式报表输出接口
/// Table：       	无
/// Input：         单元格数据
/// Output： 
/// Return：
Method DoOutput(ByRef aryOutV)
{
	/*
	s aryOutV("rowInx")=rowInx
	s aryOutV("cellDesc")=cellDesc
	s aryOutV("cellOrder")=colOrder
	s aryOutV("cellValue")=cellValue
	s aryOutV("cellValueType")="string"
	s aryOutV("colType")="dim"	
	*/
	
	//s repid=aryOutCfg("repid")
	//s ind=aryOutCfg("ind")
	s repid=..aryOutCfg.GetAt("repid")
	s ind=..aryOutCfg.GetAt("ind")
	
	s col=aryOutV("cellDesc")_","_aryOutV("cellOrder")
	s row=aryOutV("rowInx")
	
 
    
	s value=aryOutV("cellValue")_","_aryOutV("cellValueType")
	/*
	if $d(aryOutV("showFormat")) {
		s showFormat=aryOutV("showFormat")
		if showFormat="#" s decimal=0
		else  if showFormat="#.0" s decimal=1
		else  if showFormat="#.00" s decimal=2
		else  if showFormat="#.000" s decimal=3
		else  if showFormat="#.0000" s decimal=4
		s value=$FNUMBER(aryOutV("cellValue"),"",decimal)_","_aryOutV("cellValueType")
	}
	*/
	s colIsAggregate=""
	if $d(aryOutV("colIsAggregate")) s colIsAggregate=aryOutV("colIsAggregate")
	s value=value_","_colIsAggregate
	s showFormat=""
	if $d(aryOutV("showFormat")) s showFormat=aryOutV("showFormat")
	s value=value_","_showFormat
	//aryOutV("showFormat")=showFormat
	s data=$lb(row,col,value)
	
	Set ^CacheTemp(repid,ind)=data
	s ind=ind+1
	d ..aryOutCfg.SetAt(ind,"ind")
}

}
