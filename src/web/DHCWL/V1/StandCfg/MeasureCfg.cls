/// Creator   : wk
/// CreatDate : 2018-10-17
/// Desc      : 度量管理
Class web.DHCWL.V1.StandCfg.MeasureCfg Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-10-17
/// Desc      : 获取度量表格数据
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.StandCfg.MeasureCfg","GetMeasure","")
Query GetMeasure(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,name:%String:编码,value:%String:描述,statDate:%String:统计口径,statItem:%String:统计项,group:%String:数据源") [ SqlProc ]
{
}

ClassMethod GetMeasureExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="SELECT ID,Mea_Code,Mea_Desc,Measure_CalItem,Mea_CalDesc,Mea_StaCal,Mea_StaDesc,Mea_DataSource,Mea_DsDesc FROM DHCWL_MeasureDimrole.DHCWLMeasure ORDER BY Mea_DataSource,Mea_StaCal"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s code=rs.Data("Mea_Code")
		s desc=rs.Data("Mea_Desc")
		s calDesc=rs.Data("Mea_CalDesc")
		if (calDesc'=""){
			s cal=rs.Data("Measure_CalItem")_":"_rs.Data("Mea_CalDesc")
		}else{
			s cal=rs.Data("Measure_CalItem")
		}
		s staDesc=rs.Data("Mea_StaDesc")
		if (staDesc'=""){
			s sta=rs.Data("Mea_StaCal")_":"_rs.Data("Mea_StaDesc")
		}else{
			s sta=rs.Data("Mea_StaCal")
		}
		s ds=rs.Data("Mea_DsDesc")
		s dsCode=rs.Data("Mea_DataSource")
		s:ds="" ds=dsCode
		continue:((filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(cal,"U") '[ filterValue)&&($zcvt(sta,"U") '[ filterValue)&&($zcvt(ds,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,code,desc,sta,cal,ds)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-10-17
/// Desc      : 加载数据源下拉框
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.StandCfg.MeasureCfg","GetDS","")
Query GetDS(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,dsCode:%String:数据源编码,dsDesc:%String:数据源描述") [ SqlProc ]
{
}

ClassMethod GetDSExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="SELECT ID,Ds_PackName,Ds_TableName,Ds_Desc FROM DHCWL_MeasureDimrole.DSource WHERE Ds_VoidFlag IS NULL"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s dsID=rs.Data("ID")
		s dsCode=rs.Data("Ds_PackName")_"."_rs.Data("Ds_TableName")
		s dsDesc=rs.Data("Ds_Desc")
		continue:((filterValue'="")&&($zcvt(dsCode,"U") '[ filterValue)&&($zcvt(dsDesc,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(dsID,dsCode,dsDesc)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-10-17
/// Desc      : 加载统计项下拉框
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.StandCfg.MeasureCfg","GetStatItem","")
Query GetStatItem(filterValue As %String = "") As websys.Query(ROWSPEC = "code:%String:编码,desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetStatItemExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="SELECT DsItem_Name,DsItem_Desc FROM DHCWL_MeasureDimrole.DSItem WHERE DsItem_ItemType='度量' AND DsItem_VoidFlag IS NULL"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s name=rs.Data("DsItem_Name")
		s desc=rs.Data("DsItem_Desc")
		continue:((filterValue'="")&&($zcvt(name,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(name,desc)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-10-17
/// Desc       : 获取统计口径下拉框
/// Other      : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.StandCfg.MeasureCfg","GetStatDate","")
Query GetStatDate(filterValue As %String = "") As websys.Query(ROWSPEC = "code:%String:编码,desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetStatDateExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="SELECT DsItem_Name,DsItem_Desc FROM DHCWL_MeasureDimrole.DSItem WHERE DsItem_ItemType='口径' AND DsItem_VoidFlag IS NULL"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s name=rs.Data("DsItem_Name")
		s desc=rs.Data("DsItem_Desc")
		continue:((filterValue'="")&&($zcvt(name,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(name,desc)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-10-17
/// Desc      : 新增度量
/// Other     : do ##class(web.DHCWL.V1.StandCfg.MeasureCfg).AddMeasure()
ClassMethod AddMeasure(code, desc, ds, item, date)
{
	s code=code
	s dataSource=ds
	s calItem=item
	s meastaCal=date
	s desc=desc
	s creator=$g(%session.Data("LOGON.USERNAME"))
	s result=##class(DHCWL.MeasureDimroleData.FunctionModule).AddMeasure(code,dataSource,calItem,meastaCal,desc,creator)
	q:result="ok" "保存成功"
	q result
}

/// Creator   : wk
/// CreatDate : 2018-10-17
/// Desc      : 修改度量信息
/// Other     : do ##class(web.DHCWL.V1.StandCfg.MeasureCfg).ModifyMeasure()
ClassMethod ModifyMeasure(ID, desc)
{
	s desc=desc
	s ID=ID
	s result=##class(DHCWL.MeasureDimroleData.FunctionModule).ModifyMeasure(ID,desc)
	q:result="ok" "修改成功"
	q result
}

/// Creator:         wk
/// CreatDate:       2018-10-17
/// Description:     作废度量
/// Others:			d ##class(web.DHCWL.V1.StandCfg.MeasureCfg).DeleteMeasure("")
ClassMethod DeleteMeasure(meaID)
{
	s date=$p($h,",",1)
	s result="删除失败"
	q:'$d(^DHCWL.MeasureDimrole.MeasureD(meaID)) "未找到相关度量"
	s flag=0
	s kpiID=""
	for {
		s kpiID=$o(^DHCWL.MKPI.MKPIMeasureI("MKPIMeaI",kpiID))
		q:kpiID=""
		s ID=""
		for {
			s ID=$o(^DHCWL.MKPI.MKPIMeasureI("MKPIMeaI",kpiID,ID))
			q:ID=""
			if (ID=meaID){
				s flag=1
			}
		}
	}
	q:flag=1 "有指标关联了这个度量,不能删除"
	&sql(delete from DHCWL_MeasureDimrole.DHCWLMeasure where ID=:meaID)
	i SQLCODE=0{
		s result="删除成功"
	}
	q result
}

}
