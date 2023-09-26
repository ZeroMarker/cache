/// Creator   : wk
/// CreatDate : 2018-11-02
/// Desc      : 主界面维护函数
Class web.DHCWL.V1.HomeTab.ProFunction Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-11-12
/// Desc      : 维护产品使用记录
/// Other   　：do ##class(web.DHCWL.V1.HomeTab.ProFunction).AddProRecord()
ClassMethod AddProRecord(proID)
{
	if $d(^web.DHCWL.V1.H7DB0.ProductListI("ID",$zcvt(proID,"U"))){
		s ID=$o(^web.DHCWL.V1.H7DB0.ProductListI("ID",$zcvt(proID,"U"),""))
		q:ID="" "获取产品失败"
		s time=$p($h,",",2)
		s count=$lg(^web.DHCWL.V1.H7DB0.ProductListD(ID),4)
		s count=count+1
		&sql(update web_DHCWL_V1_HomeTab.ProductList set UsageTime=:time,usageCount=:count where ID=:ID)
		if ($g(SQLCODE)=0){
			q "保存成功"
		}else{
			q "保存失败"_SQLCODE
		}
	}else{
		s time=$p($h,",",2)
		s date=$p($h,",",1)
		s count=1
		&sql(insert into web_DHCWL_V1_HomeTab.ProductList (ProID,UsageTime,UsageDate,usageCount) values(:proID,:time,:date,:count))
		if ($g(SQLCODE)=0){
			q "保存成功"
		}else{
			q "保存失败"_SQLCODE
		}
	}
}

/// Creator   : wk
/// CreatDate : 2018-11-02
/// Desc      : 获取常用产品列表
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.HomeTab.ProFunction","GetOftenPro")
Query GetOftenPro() As websys.Query(ROWSPEC = "proID:%String:产品ID") [ SqlProc ]
{
}

ClassMethod GetOftenProExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s sql="SELECT ID,ProID FROM web_DHCWL_V1_HomeTab.ProductList ORDER BY usageCount DESC"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		continue:ind>5
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ProID"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-11-02
/// Desc      : 获取最近产品列表
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.HomeTab.ProFunction","GetRecentPro")
Query GetRecentPro() As websys.Query(ROWSPEC = "proID:%String:产品ID") [ SqlProc ]
{
}

ClassMethod GetRecentProExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s sql="SELECT ID,ProID FROM web_DHCWL_V1_HomeTab.ProductList ORDER BY UsageDate DESC,UsageTime DESC"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		continue:ind>5
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ProID"))
		s ind=ind+1
	}
	Quit $$$OK
}

}
