Class DHCWL.DocQueryData.SaveData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// //////////////////////////////////////////////
/// ////////////////////////////// 
/// Creator：      yw
/// CreatDate：    2015-06
/// Description:： 增加医生指标ID
/// Table：       DHCWL.DocQueryData.SaveData
/// Input：       data：医生指标数组
/// Output：      
/// Return：      
/// Others：      w ##class(DHCWL.DocQueryData.SaveData).DocKpiInsert("test")
ClassMethod DocKpiInsert(ByRef data) As %String
{
	n (data)
	q:data("MDocKPIDefCode")="" "医生指标代码不能为空！"
	//首先判断医生指标代码是否已经存在。
	i $d(^DHCWL.DocQuery.DocKpiDefI("MDocKPIDefCode",$zcvt(data("MDocKPIDefCode"),"U")))  q "医生指标代码"_data("MDocKPIDefCode")_"已经存在!"
	s docKpi=##class(DHCWL.DocQuery.DocKpiDef).%New()
	s docKpi.MDocKPIDefCode=$g(data("MDocKPIDefCode"))
	s:$g(data("MDocKPIDefDesc"))'="" docKpi.MDocKPIDefDesc=$g(data("MDocKPIDefDesc"))
	s:$g(data("MDocKPIDefType"))'="" docKpi.MDocKPIDefType=data("MDocKPIDefType")
	s:$g(data("MDocKPIDefClass"))'="" docKpi.MDocKPIDefClass=data("MDocKPIDefClass")
	s:$g(data("MDocKPIDefCategory"))'="" docKpi.MDocKPIDefCategory=data("MDocKPIDefCategory")
	//s:+$g(data("MDocKPIUpdateDate"))'=0 docKpi.MDocKPIUpdateDate=$zdh(data("MDocKPIUpdateDate"),3)
	s:+$g(data("MDocKPIUpdateDate"))'=0 docKpi.MDocKPIUpdateDate=##class(websys.Conversions).DateHtmlToLogical(data("MDocKPIUpdateDate"))
	s sc=docKpi.%Save()
	i sc=1 q "ok"
	e  q "wrong"
}

/// Creator：      yw
/// CreatDate：    2015-06
/// Description:： 更新医生指标
/// Table：       DHCWL.DocQuery.DocKpiDef
/// Input：       data：医生指标数组
/// Output：      
/// Return：      更新状态
/// Others：      w ##class(DHCWL.DocQueryData.SaveData).ConsUpdate(id,.data)
ClassMethod DocKpiUpdate(id, ByRef data)
{
	n (id,data)
	q:data("MDocKPIDefCode")="" "医生指标代码不能为空！"
	s docKpi=##class(DHCWL.DocQuery.DocKpiDef).%OpenId(id)
	i docKpi=""  q "不存在该医生指标，请重选！"
	s code = docKpi.MDocKPIDefCode
	q:code'=$g(data("MDocKPIDefCode")) "医生指标代码不能修改"
	s:$g(data("MDocKPIDefCode"))'="" docKpi.MDocKPIDefCode=$g(data("MDocKPIDefCode"))
	s docKpi.MDocKPIDefDesc=$g(data("MDocKPIDefDesc"))
	s docKpi.MDocKPIDefType=$g(data("MDocKPIDefType"))
	s docKpi.MDocKPIDefClass=$g(data("MDocKPIDefClass"))
	s docKpi.MDocKPIDefCategory=$g(data("MDocKPIDefCategory"))
	s:+$g(data("MDocKPIUpdateDate"))'=0 docKpi.MDocKPIUpdateDate=##class(websys.Conversions).DateHtmlToLogical(data("MDocKPIUpdateDate"))
	s sc=docKpi.%Save()
	i sc=1 q "ok"
	e  q "wrong"
}

/// Creator：      yw
/// CreatDate：    2015-06
/// Description:： 删除用户医生指标
/// Table：       DHCWL.DocQuery.DocKpiDef
/// Input：       id：医生指标id
/// Output：      
/// Return：      删除状态
/// Others：      w ##class(DHCWL.DocQueryData.SaveData).ConsDelete(id)
ClassMethod DocKpiDelete(id) As %String
{
	n (id)
	q:id="" "请选择删除已经存在的医生指标！"
	s relId = $o(^DHCWL.DocQuery.DocKpiRelKpiI("MDocKPIDr",id,""))
	q:relId'="" "请先删除医生指标对照关系"
	s sc=##class(DHCWL.DocQuery.DocKpiDef).%DeleteId(id)
	i sc=1  q "ok"
	e  q "删除失败！"
}

/// Creator：      yw
/// CreatDate：    2015-06
/// Description:： 保存医生指标、系统指标、指标维度、维度属性、过滤规则
/// Table：        DHCWL_DocQuery.DHCWLDocKpiDef,DHCWL_DocQuery.DHCWLDocKpiRelKpi
/// Input：        data：医生指标数组
/// Output：      
/// Return：      
/// Others：      w ##class(DHCWL.DocQueryData.SaveData).AddDocAppRel(.a)
ClassMethod AddDocAppRel(ByRef data) As %String
{
	n (data)
	q:data("MDocKPIDr")="" "医生指标代码不能为空！"
	//q:data("MKPIdr")="" "系统指标代码不能为空！"
	//q:data("MKPIDim")="" "指标维度不能为空！"
	//q:data("MDimProp")="" "维度属性不能为空！"
	
    s mKPIdr=""
	i $d(^DHCWL.DocQuery.DocKpiRelKpiI("MDocKPIDr",data("MDocKPIDr")))  q "医生指标对应关系已经存在!"
	s docKpiRel=##class(DHCWL.DocQuery.DocKpiRelKpi).%New()
	s docKPIDr=$g(data("MDocKPIDr"))
	s:$g(data("MDocKPIDr"))'="" docKpiRel.MDocKPIDr=##class(DHCWL.DocQuery.DocKpiDef).%OpenId(docKPIDr)
	i data("MKPIdr")'="" s mKPIdr=$O(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(data("MKPIdr"),"U"),""))
	//i mKPIdr'="" s docKpiRel.MKPIdr=##class(DHCWL.MKPI.MKPI).%OpenId(mKPIdr)
	s docKpiRel.MKPIDim=$g(data("MKPIDim"))
	s docKpiRel.MDimProp=$g(data("MDimProp"))
	s docKpiRel.MKPICode=$g(data("MKPIdr"))
	//s otherFilterRule=$tr($g(data("OtherFilterRule")),"##","&&")
	//s docKpiRel.OtherFilterRule=otherFilterRule
	s sc=docKpiRel.%Save()
	i sc=1 q "ok"
	e  q "wrong"
}

/// Creator：      yw
/// CreatDate：    2015-06
/// Description:： 删除用户医生指标
/// Table：       DHCWL.DocQuery.DocKpiDef
/// Input：       id：医生指标id
/// Output：      
/// Return：      删除状态
/// Others：      w ##class(DHCWL.DocQueryData.SaveData).ConsDelete(id)
ClassMethod DelDocAppRel(id) As %String
{
	n (id)
	q:id="" "请选择删除医生指标关联的系统指标！"
	s sc=##class(DHCWL.DocQuery.DocKpiRelKpi).%DeleteId(id)
	i sc=1  q "ok"
	e  q "删除失败！"
}

/// Creator：     yw
/// CreatDate：   2015-06
/// Description： 根据医生指标查找
/// Table：       DHCWL_DocQuery.DHCWLDocKpiRelKpi
/// Input：       docKpiId：医生指标ID
/// Output：      
/// Return：      ret：指标维度、维度属性、过滤表达式
/// Others：      w ##class(DHCWL.DocQueryData.SaveData).GetDocKpiRel(8)
/// KpiCode:({CTPCP.UserID}=@parUserID)
ClassMethod GetDocKpiRel(docKpiId) As %String
{
	n (docKpiId)
	s ret="",ret1="",ret2=""
	s mKPIdr="",mKPIDim="",mDimProp="",otherFilterRule=""
	s ^TEMPDHCWLDH("123") = docKpiId
	&sql(select MKPI_Dim,MDim_Prop,OtherFilter_Rule into:mKPIDim,:mDimProp,:otherFilterRule from DHCWL_DocQuery.DHCWLDocKpiRelKpi where MDocKPI_Dr=:docKpiId)
    i SQLCODE=0 d 
    .i mKPIdr'="" s obj=##class(DHCWL.MKPI.MKPI).%OpenId(mKPIdr)
    .s kpiCode=obj.MKPICode
    .s ret1=kpiCode_"({"_mKPIDim_"."_mDimProp_"}=@parUserID)"
    .s ret2=otherFilterRule
	.s ret=ret1_"#"_ret2
	q ret
}

// d ##class(DHCWL.DocQueryData.SaveData).upDateKpiDef("16","1")

ClassMethod addKpiDef(id, calExp) As %String
{
	n (id,calExp)
	&sql(insert into DHCWL_DocQuery.DHCWLDocKpiRelKpi(MDocKPI_Dr,OtherFilter_Rule) values(:id,:calExp))
	i SQLCODE = 0 q "true"_"^"_"保存成功"
 	e  q "true"_"^"_"保存失败"
}

// d ##class(DHCWL.DocQueryData.SaveData).updateKpiDef("16","1")

ClassMethod updateKpiDef(id, calExp) As %String
{
	n (id,calExp)
	&sql(update  DHCWL_DocQuery.DHCWLDocKpiRelKpi set OtherFilter_Rule = :calExp where MDocKPI_Dr = :id)
	i SQLCODE = 0 q "true"_"^"_"修改成功"
 	e  q "true"_"^"_"修改失败"
}

ClassMethod updateFilterRule(dKpiId, filterRule) As %String
{
	n (dKpiId,filterRule)
	i filterRule["\" s filterRule=$REPLACE(filterRule,"\","\\\")
	&sql(update  DHCWL_DocQuery.DHCWLDocKpiRelKpi set OtherFilter_Rule = :filterRule where MDocKPI_Dr = :dKpiId)
	i SQLCODE = 0 q "true"_"^"_"修改成功"
 	e  q "true"_"^"_"修改失败"
}

/// 返回表的记录总数
/// w ##class(DHCWL.DocQueryData.SaveData).GetTableCount("DHCWL.MSingle.Stock")
ClassMethod GetTableCount(className As %String) As %String
{
        s tableName=##class(DHCWL.util.GetSetService).GetTableName(className)  
	    s sql = "SELECT count(*) cNum FROM "_tableName
 		s rs = ##class(%Library.ResultSet).%New()
 		s sc = rs.Prepare(sql)
 		s sc = rs.Execute()
 		While(rs.Next()){
			s count = rs.Data("cNum")
 		}
		d rs.Close()
		q count
}

/// w ##class(DHCWL.DocQueryData.SaveData).findDim(946)
ClassMethod findDim(kpiCode, MDocKpiDefClass) As %String
{
	  s MSkpiId=$o(^DHCWL.MKPI.MKPII("MKPICode",kpiCode,"")) 
      s dimdimDr=""  f  s dimdimDr =$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",MSkpiId,dimdimDr)) q:dimdimDr=""  d
      .s kdtCode = $list(^DHCWL.MKPI.MKPIDimTypeD(dimdimDr),2)
      .i (kdtCode="CTPCP")&&(MDocKpiDefClass="医生")  d
      ..s dimId = "" f  s dimId =$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",MSkpiId,dimdimDr,dimId)) q:dimId=""  d
	  ...s dimCode = $list(^DHCWL.MKPI.MKPIDimensionsD(dimId),2)
	  ...s dimPro = "DocCode"
	  .i (kdtCode="CTLOC")&&(MDocKpiDefClass="科主任")  d
      ..s dimId = "" f  s dimId =$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",MSkpiId,dimdimDr,dimId)) q:dimId=""  d
	  ...s dimCode = $list(^DHCWL.MKPI.MKPIDimensionsD(dimId),2)
	  ...s dimPro = "LocDesc"
	  //w $g(dimCode)_"^"_$g(dimPro),!
	  q $g(dimCode)_"^"_$g(dimPro)
}

}
