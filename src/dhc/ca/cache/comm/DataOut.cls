/// 名称: 数据导出
/// 描述: 各种数据导出的类方法
/// 编写者：许立新
/// 编写日期:2010-03-12
Class dhc.ca.cache.comm.DataOut Extends (%SerialObject, %Populate, %XML.Adaptor) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

Projection outputdata As %Projection.Java;

//myQuery = new CacheQuery(factory, classname, queryname);

//java.sql.Result ResultSet = myQuery.execute(parm1);

/// Creator：许立新
/// CreatDate：2010-03-12
/// Description: 用于奖金的收入数据查询
/// Table：dhc.ca.cache.data.InDistData
/// Input：intervalDr-核算区间
/// Output：resultset
/// Return：
/// Others：
/// 
Query ACCCFGLocQuery(parentRowId, cAcpLoc) As %Query(ROWSPEC = "tLoc:%String,tLocDr:%String,tRowId:%String")
{
}

ClassMethod ACCCFGLocQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ACCCFGLocQueryExecute ]
{
	// This fetch method should never have to change.
	// repid - Report ID
	// ind - sequence index which represents each row
	// Restore QHandle
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save Qhandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ACCCFGLocQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ACCCFGLocQueryExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ACCCFGLocQueryExecute(ByRef qHandle As %Binary, parentRowId, cAcpLoc) As %Status
{
	///do ResetVariables
	Set repid=$I(^CacheTemp)
	s ind=1
    
	s childSub="0"
	f  s childSub=$o(^DHCCAACCConfig(parentRowId,"CFGLoc",childSub)) q:childSub=""  d
	.i $d(^DHCCAACCConfig(parentRowId,"CFGLoc",childSub)) d
	..s myLocDr=$p(^DHCCAACCConfig(parentRowId,"CFGLoc",childSub),"^",1)
	..s myLoc=$p(^DHCCALoc(myLocDr),"^",2)
	..s myRowId=parentRowId_"||"_childSub
	..q:(cAcpLoc'="")&(myLoc'[cAcpLoc)
	..d OutputRow
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	set Data=$lb($g(myLoc),$g(myLocDr),$G(myRowId)) ;按顺序对应Query的传出参数
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

Storage Default
{
<StreamLocation>^dhc.ca.c.DataOutS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
