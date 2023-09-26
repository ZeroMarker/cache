Import sqluser

/// creator:yunhaibao
/// createdate:20160621
/// descirpiton:住院药房发药类别维护
Class web.DHCINPHA.DispType Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160621
/// descirpiton:获取发药类别查询列表
/// w ##class(web.DHCINPHA.DispType).jsQueryDispType(params)
ClassMethod jsQueryDispType(params = "")
{
	s HospId=$p(params,"^",1)
	s $zt="ErrorjsQueryDispType"
	s result=##class(%Library.ResultSet).%New("web.DHCSTPHADRUGGROUP:GetDispType")
	s sc=result.Execute(HospId)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1  //可做索引用
		I countrecords=1 d
		.w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	i countrecords>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	q ""
ErrorjsQueryDispType
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160621
/// descirpiton:获取发药类别对应的医嘱子类
/// w ##class(web.DHCINPHA.DispType).jsQueryArcItemCat("10^1")
ClassMethod jsQueryArcItemCat(params)
{
 	
	s dispcatid=$p(params,"^",1)
	s chkonly=$p(params,"^",2)
	s HospID=$p(params,"^",3)
	q:dispcatid=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	s $zt="ErrorjsQueryArcItemCat"
	s result=##class(%Library.ResultSet).%New("web.DHCSTPHADRUGGROUP:DrugOrdCat")
	s sc=result.Execute(dispcatid,chkonly,HospID)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1  //可做索引用
		I countrecords=1 d
		.w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	i countrecords>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	q ""
ErrorjsQueryArcItemCat
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160622
/// descirpiton:保存发药类别对应的医嘱子类
/// w ##class(web.DHCINPHA.DispType).SaveCatSub("4","312")
ClassMethod SaveCatSub(parref, ordcatdr)
{
	q:parref="" -1
	q:ordcatdr="" -2
	//确认修改,先删除已存在的维护
	ts
	&sql(delete from DHCStkDrugGrpItm where SDGI_OrderCat_DR=:ordcatdr)
	s insret=##class(web.DHCSTPHADRUGGROUP).InsertItm(parref,ordcatdr)
	i insret<0 tro
	q:insret<0 -3
	tc 
	q insret
}

/// creator:yunhaibao
/// createdate:20160622
/// descirpiton:保存药品类别明细满整支发药配置
/// others:因一个医嘱子类仅属于一个发药类别,因此直接按子类update即可
/// w ##class(web.DHCINPHA.DispType).SaveWholeDispConfig("4","312")
ClassMethod SaveWholeDispConfig(ordcatdr, flag)
{
  s dispcat=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,""))
  q:dispcat="" -1
  &SQL(UPDATE DHCStkDrugGrpItm SET SDGI_WholeFlag=:flag WHERE SDGI_OrderCat_DR=:ordcatdr)
  q SQLCODE
}

ClassMethod NewPid()
{
	q $i(^DHCSTPHARMACY("web.DHCINPHA.DispTypeType"))
}

}
