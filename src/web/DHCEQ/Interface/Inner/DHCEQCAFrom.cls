Class web.DHCEQ.Interface.Inner.DHCEQCAFrom Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// add by zy 2014-09-15  ZY0117
/// DHCCATOEQ
/// Description:成本核算组 
/// 
/// Description:导出成本数据记录 
/// Creator:cgg
/// CreateDate:090903 
/// 入参:   MonthStr    ;"2014-09"
/// 	   LocID       ;CT_LocID
/// 输出数据存在临时golbale中,golable节点如下：
///   ^DHCEQTemp("Gather","CA",MonthStr,LocID,CatID)=CatDesc^Fee
/// 例子:^DHCEQTemp("Gather","CA","2014-09",80,1)=医疗耗材^1000.00
/// d ##Class(web.DHCEQTest).GetOutCAData("2014-07","151")
ClassMethod GetOutCAData(MonthStr, LocID, CAitemDr)
{
	
	/* 暂时注释 JDL20150831 项目需有成本核算产品，才可用
  n (MonthStr,LocID,CAitemDr)
  k ^DHCCATOEQTemp("Gather","CA")
  ;;q:MonthStr="" $$$OK
  s RowId="" ,indeptdr="",data=""
  s LocCode="his"_LocID
  f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
  .q:RowId=0
  .s month=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
  .q:MonthStr'=month 
  .
  .s stMonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(RowId)
  .s stName=stMonObj.AccountMonthsname
  .s INFORowId=""  f  s INFORowId=$o(^DHCCAVOUCHDATAS(0,"Interval",RowId,INFORowId)) q:INFORowId=""  d  
  ..s VouchObj=##class(dhc.ca.cache.data.VouchDatas).%OpenId(INFORowId)
  ..s DeptDr=VouchObj.VouchDatasdeptDr.%Id()
  ..&sql(SELECT InDepts_deptDr into :indeptdr FROM dhc_ca_cache_data.InDepts WHERE InDepts_rowid =(SELECT OutDepts_parRef FROM dhc_ca_cache_data.OutDepts WHERE OutDepts_code =:LocCode))
  ..q:DeptDr'=indeptdr
  ..s unitObj=##class(dhc.ca.cache.data.UnitDepts).%OpenId(DeptDr)
  ..s unitdeptname=unitObj.UnitDeptsname
  ..s unitdeptcode=unitObj.UnitDeptscode
  ..s itemDr=VouchObj.VouchDatasitemDr.%Id()
  ..q:itemDr'=CAitemDr
  ..s allitemObj=##class(dhc.ca.cache.data.AllDataItems).%OpenId(itemDr)
  ..s itemcode=allitemObj.AllDataItemscode
  ..s itemname=allitemObj.AllDataItemsname
  ..s debit=VouchObj.VouchDatasdebit
  ..s data=unitdeptname_"^"_itemname_"^"_debit
  ..s ^DHCCATOEQTemp("Gather","CA",MonthStr,LocID,itemDr)=data
  q data
  
  */
  q ""
}

}
