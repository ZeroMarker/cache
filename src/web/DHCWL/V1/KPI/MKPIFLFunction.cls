/// Creator   : wk
/// CreatDate : 2018-05-22
/// Desc      : 指标类型维护
Class web.DHCWL.V1.KPI.MKPIFLFunction Extends %RegisteredObject
{

/// Creator    : wk
/// CreatDate  : 2018-05-18
/// Desc       : 获取指标类型信息
/// Table      : DHCWL_MKPI.DHCWLMKPIFL
/// Other      ：
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.MKPIFLFunction","GetMKPIFLQuery")
Query GetMKPIFLQuery(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,typeCode:%String:类型编码,typeName:%String:类型名称,typeDesc:%String:类型描述,typeCreator:%String:创建者,typeDate:%String:更新日期,typeRemark:%String:备注") [ SqlProc ]
{
}

ClassMethod GetMKPIFLQueryExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$ZCVT(filterValue,"U")
 	s sql="select ID,MKPIFL_Code,MKPIFL_Name,MKPIFL_Desc,MKPIFL_User,MKPIFL_UpdateDate,MKPIFL_Remark from DHCWL_MKPI.DHCWLMKPIFL"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s updateDate=rs.Data("MKPIFL_UpdateDate")
		if (updateDate){
			s updateDate=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(updateDate)
		}
		s code=rs.Data("MKPIFL_Code")
		s name=rs.Data("MKPIFL_Name")
		s desc=rs.Data("MKPIFL_Desc")
		s creator=rs.Data("MKPIFL_User")
		s remark=rs.Data("MKPIFL_Remark")
		continue:((filterValue'="")&&($zcvt(code,"U")'[filterValue)&&($zcvt(name,"U")'[filterValue)&&($zcvt(desc,"U")'[filterValue)&&($zcvt(creator,"U")'[filterValue)&&($zcvt(remark,"U")'[filterValue))
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),code,name,desc,creator,updateDate,remark)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-05-22
/// Desc      : 更新(新增、修改)指标类型信息
/// Other     : do ##class(web.DHCWL.V1.KPI.MKPIFLFunction).updateKPIFL()
ClassMethod updateKPIFL(ID As %String, typeCode As %String, typeName As %String, typeDesc As %String, typeCreator As %String, remark As %String)
{
	s MKPIFLCode=$g(typeCode)
	i MKPIFLCode="" q "分类代码不能为空！"
	i $g(typeName)="" q "维度分类名称不能为空！"
	s postId=$g(ID)
	s id=..GetKpiflByCode(MKPIFLCode)
	i (postId'="")&&(+id'=+postId) q "指标分类代码不能修改！"
	i (postId="")&&(+id'=0) q "指标分类代码不能重复！"
	//存在就打开表示更新，不存在表示是新建。
	if (+id=0) {
		s dimObj=##class(DHCWL.MKPI.MKPIFL).%New()
	}else {
		s dimObj=##class(DHCWL.MKPI.MKPIFL).%OpenId(id)
	}
	i (postId'="")&&(dimObj.MKPIFLCode'=MKPIFLCode) q "指标分类代码不能修改！"
	s dimObj.MKPIFLCode=$g(MKPIFLCode)
	s dimObj.MKPIFLName=$g(typeName)
	s dimObj.MKPIFLDesc=$g(typeDesc)
	s dimObj.MKPIFLUser=$g(typeCreator)
	s dimObj.MKPIFLRemark=$g(remark)
	//modify by wk~2017-03-09~公司时间控件标准化
	s dimObj.MKPIFLUpdateDate=$p($h,",",1)
	s sc=dimObj.%Save()
	i sc=1 q "更新成功"
	q "维度保存失败！"
}

/// Creator   : wk
/// CreatDate : 2018-05-22
/// Desc      : 指标类型通过编码获取ID
ClassMethod GetKpiflByCode(code) As %String
{
	q:code="" ""
	s id=$o(^DHCWL.MKPI.MKPIFLI("FLCode",$SYSTEM.SQL.ALPHAUP(code),""))
	q id
}

/// Creator   : wk
/// CreatDate : 2018-05-22
/// Desc      : 删除指标类型
/// Other     : do ##class(web.DHCWL.V1.KPI.MKPIFLFunction).DeleteKpifl()
ClassMethod DeleteKpifl(flCode) As %String
{
	s id=..GetKpiflByCode(flCode)
	i +id=0 q "指标类型不存在"
	s sc=##class(DHCWL.MKPI.MKPIFL).%DeleteId(id)
	i sc=1 q "删除成功"
	q "维度删除失败！"
}

}
