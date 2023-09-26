/// Creator    :     wk
/// CreatDate  :     2018-08-30
/// Description:	 报表列明细配置
Class web.DHCWL.V1.MRIPDay.MRIPDayDetailFun Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 获取报表列明细数据
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayDetailFun","GetRptDetail")
Query GetRptDetail(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述,type:%String:维度属性") [ SqlProc ]
{
}

ClassMethod GetRptDetailExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
	
	s:filterValue'="" filterValue=$ZCVT(filterValue,"U") 
	set sql="SELECT t1.OPTLDetailItem_RowID,t1.OPTLDetailItem_Code,t1.OPTLDetailItem_Desc,t2.KPIDetailItem_DimProCode FROM DHCWL_MRIPDay.OPTLDetailItem t1,DHCWL_MRIPDay.KPIDetailItem t2 WHERE t1.OPTLDetailItem_RowID=t2.KPIDetailItem_OPTLDetailItemDR"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()

	While(rs.Next()){

		s rowID=rs.Data("OPTLDetailItem_RowID")
		s code=rs.Data("OPTLDetailItem_Code")
		s desc=rs.Data("OPTLDetailItem_Desc")
		s dimProCode=rs.Data("KPIDetailItem_DimProCode")
		continue:(filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(dimProCode,"U") '[ filterValue)
		s ^CacheTemp(repid,ind)=$lb(rowID,code,desc,dimProCode)
		s ind=ind+1
	}

	d rs.Close() 
    
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 获取维度属性信息
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayDetailFun","GetDimPro")
Query GetDimPro() As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,name:%String:名称,desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetDimProExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    
    
	//1、得到出入转明细指标的维度属性的ID,编码，描述
	set sql="SELECT ID,DimPro_Code,DimPro_Name,DimPro_Desc FROM DHCWL_MKPI.DHCWLDimProperty WHERE DimPro_DimDr IN (SELECT ID FROM DHCWL_MKPI.DHCWLMKPIDimType WHERE KDT_CODE='MRIPDetail') ORDER BY ID"

	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()

	While(rs.Next()){

		s ID=rs.Data("ID")
		s code=rs.Data("DimPro_Code")
		s name=rs.Data("DimPro_Name")
		s desc=rs.Data("DimPro_Desc")
		s ^CacheTemp(repid,ind)=$lb(ID,code,name,desc)
		s ind=ind+1
	}

	d rs.Close()
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 新增报表列明细
/// Other     : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayDetailFun).AddOPTLDetail
ClassMethod AddOPTLDetail(code, desc, dimProCode, dimProID, dimType As %String = "")
{
	s itemCode=code
	s itemDesc=desc
	s dimProCode=dimProCode
	s dimProDR=dimProID
	s dimType=dimType
	q:($d(^DHCWL.MRIPDay.OPTLDetailItemI("OPTLDetailItemCodeIndex",code))) "编码已存在,请重新填写"
	s tempCode="",flag=""
	for {
		s tempCode=$o(^DHCWL.MRIPDay.OPTLDetailItemI("OPTLDetailItemCodeIndex",tempCode))
		q:tempCode=""
		if ($zcvt(code,"U")=$zcvt(tempCode,"U")){
			s flag=1
			q
		}
	}
	q:flag=1 "编码已存在,请重新填写"
	if dimType="" s dimType="KPIDetailItem"
	tstart
	//1.1新增可选明细统计项
	&sql(insert into DHCWL_MRIPDay.OPTLDetailItem (OPTLDetailItem_Code,OPTLDetailItem_Desc,OPTLDetailItem_Type) 
	values (:itemCode,:itemDesc,:dimType))
	i +$g(SQLCODE)=0 {
		//1.2新增指标类可选明细统计项
		&sql(insert into DHCWL_MRIPDay.KPIDetailItem (KPIDetailItem_OPTLDetailItemDR,KPIDetailItem_DimProDR,KPIDetailItem_DimProCode) 
		values (:%ROWID,:dimProDR,:dimProCode))
		i +$g(SQLCODE)=0 {
			tcommit
			q "新增成功"
		}else {
			trollback
		  	q "操作失败！"_SQLCODE	
		}	
	}
	else {
		trollback
		q "'操作失败！"_SQLCODE	
	
	}
}

/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 修改报表列明细
/// Other     : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayDetailFun).ModifyOPTLDetail
ClassMethod ModifyOPTLDetail(ID, desc)
{
	s itemDesc=desc
	//更新明细统计项
	&sql(update DHCWL_MRIPDay.OPTLDetailItem set OPTLDetailItem_Desc=:itemDesc where OPTLDetailItem_RowID=:ID)
	i +$g(SQLCODE)=0 {
		q "更新成功"
	}else {
	  	q "操作失败！"_SQLCODE	
	}
}

/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 删除报表列明细
/// Other     : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayDetailFun).DeleteOPTLDetail
ClassMethod DeleteOPTLDetail(ID)
{
	s OPTLDetailItemRowid=ID
	//1、查看是否有报表使用到这个统计项
	s ret=##class(DHCWL.MRIPDay.MripDayService).FindDetailRptDescByDtlID(OPTLDetailItemRowid)
	if ret'="" {
		s TipMsg="要删除的明细统计项被下面报表使用："_ret_" 。请先从这些报表中移除该明细统计项。"
		q TipMsg	
	}else{
		tstart
		//2、删除统计项
		s ret=##class(DHCWL.MRIPDay.MripDayService).DelDtlRpt(OPTLDetailItemRowid)
		if ret=0 {
			tcommit
			q "删除成功"
		}else{
			trollback
			q "删除失败"
		}
	}
}

}
