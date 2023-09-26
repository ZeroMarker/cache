Class DHCWL.BaseDataQuery.RaqInterface Extends %RegisteredObject
{

/*
Query GetRowbasedStatData(rptID As %String, startDate As %String, endDate As %String, queryconf As %String) As %Query(ROWSPEC = "rowNO:%Integer,colName:%String,colPos:%Integer,value:%String") [ SqlProc ]
{
}
*/
Query GetRowbasedStatData(rptID As %String, startDate As %String, endDate As %String, queryconf As %String) As %Query(ROWSPEC = "row:%String,col:%String,value:%String") [ SqlProc ]
{
}

ClassMethod GetRowbasedStatDataExecute(ByRef qHandle As %Binary, rptID As %String, startDate As %String, endDate As %String, queryconf As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	
	//读取报表配置数据
	d ..GetRowbasedCfgByID(rptID,.aryCfgData)
	s aryCfgData("rptcfg","startDate")=startDate
	s aryCfgData("rptcfg","endDate")=endDate	
	s aryCfgData("rptcfg","queryconf")=queryconf
	s dsID=aryCfgData("DScfg","ID")
	s ds=##class(DHCWL.BaseDataQuery.DS).%OpenId(dsID)
	//准备查询
	d ds.QryPrepare(.aryCfgData)
	
	//执行查询
	s sc=ds.QryExecute(.aryCfgData)
	
	//
	s rowNO=1
	//循环取值
	While(ds.QryNext()){
		if 0 {
			s colCnt=ds.QryGetColumnCount()
			f i=1:1:colCnt {
				s name=ds.QryGetColumnHeader(i)
				s value=ds.QryGetAt(i)
				s Data=$lb(rowNO,name,i,value)
				d OuputRow1
			}
		}else{
			d ds.Outputs(rowNO,repid,.ind,.aryCfgData)
			
		}
		s rowNO=rowNO+1
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetRowbasedStatDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRowbasedStatDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetRowbasedStatDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRowbasedStatDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// s dsID=aryCfgData("DScfg","ID")

ClassMethod GetRowbasedCfgByID(rptID As %String, ByRef aryCfgData) As %String
{
	//1、得到报表配置项
	s rptObj=##class(DHCWL.BaseDataQuery.Rpt).%OpenId(rptID)
	s qryObj=rptObj.QryObjDr
	s qryID=qryObj.%Id()
	s DSObj=qryObj.DataSrcDr
	s DSID=DSObj.%Id()
	s rptName=rptObj.Name
	s rptCode=rptObj.Code
	s dateItemID=""
	if $ISOBJECT(rptObj.DateItemDr) s dateItemID=rptObj.DateItemDr.%Id()
	s aryCfgData("rptcfg","Name")=rptName		//主题路径
	s aryCfgData("rptcfg","Code")=rptCode		//主题路径
	s aryCfgData("rptcfg","dateItemID")=dateItemID
	s aryCfgData("rptcfg","ShowType")=rptObj.ShowType //报表类型
	s aryCfgData("qrycfg","ID")=qryID	//查询对象名称
	s aryCfgData("DScfg","ID")=DSID			
	
	//2、得到统计项配置项
	s list=rptObj.GetItems()
	s cnt=list.Count()
	f i=1:1:cnt {
		s obj=list.GetAt(i)	
		s name=obj.Name
		s code=obj.Code
		s type=obj.Type
		s exp=obj.Exp
		s aryCfgData("rptItemcfg","order",i,"Name")=name
		s aryCfgData("rptItemcfg","order",i,"Code")=code
		s aryCfgData("rptItemcfg","order",i,"Type")=type
		s aryCfgData("rptItemcfg","order",i,"Exp")=exp
		s aryCfgData("rptItemcfg","order",i,"Format")=##class(DHCWL.BaseDataQuery.RItemFm).GetFormatByItemID(obj.%Id())
	}
	
		//2、得到查询项配置项
	for qryitemtype="维度","度量" {
		s list=qryObj.GetItems(qryitemtype)
		s cnt=list.Count()
		f i=1:1:cnt {
			s obj=list.GetAt(i)	
			s name=obj.Name
			s code=obj.Code
			s type=obj.Type
			s createType=obj.CreateType
			s exp=obj.Exp
			s dataType=obj.DataType
			s aryCfgData("qryItemcfg","Code",code,"Name")=name
			s aryCfgData("qryItemcfg","Code",code,"Type")=type
			s aryCfgData("qryItemcfg","Code",code,"Exp")=exp
			s aryCfgData("qryItemcfg","Code",code,"CreateType")=createType
			s aryCfgData("qryItemcfg","Code",code,"DataType")=dataType	
		}
	}

	
	q ""
}

/// 
/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   返回汇总查询数据，被被润乾调用调用
/// Table：       	无
/// Input：         qryObjName：查询对象名称
/// 					paramRows：行显示项，
/// 					inPamRows：行显示项入参，
/// 					paramCols：列显示项，
/// 					inPamCols：列显示项入参，
/// 					paramMeasure：度量项，
/// 					paramMeasureDesc：度量项描述，
/// 					daterangeItem：日期口径，
/// 					daterangeStart：统计开始日期，
/// 					daterangeEnd：统计结束日期 ， 
/// 					filterIDs：过滤项 ， 
/// 					filterOperas：过滤操作符， 
/// 					filterValues：过滤值 ， 
/// 					inPamfilter：过滤项入参				
/// Output：        row1,row2,row3,row4,row5：行1-行5
/// 					col1,col2,col3,col4,col5：列1-列5
/// 					measureDesc：度量描述
/// 					measure：度量描述
/// Return：        
/// Others：
Query QryGetRptTitle(rptID As %String) As %Query(ROWSPEC = "rptTitle:%String") [ SqlProc ]
{
}

ClassMethod QryGetRptTitleExecute(ByRef qHandle As %Binary, rptID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if rptID'="" {
		s rptObj=##class(DHCWL.BaseDataQuery.Rpt).GetById(rptID)
		s name=rptObj.Name
		if name="tempSysRpt" s name="临时预览"
		s Data=$lb(name)
		d OuputRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryGetRptTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetRptTitleExecute ]
{
	Quit $$$OK
}

ClassMethod QryGetRptTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetRptTitleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
