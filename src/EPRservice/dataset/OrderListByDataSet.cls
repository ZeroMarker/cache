/// 名称：EPRservice.dataset.OrderListByDataSet
/// 描述：根据"就诊号","开始时间(医嘱)","结束时间(医嘱)",等查询一段时间内的医嘱
/// 创建者：Candyxu
/// 创建时间：2011-08-19
Class EPRservice.dataset.OrderListByDataSet Extends %XML.DataSet [ Not ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/OrderListByDataSet";

/// The class name that contains the query for typed DataSet
/// Parameter CLASSNAME = "web.DHCFOrdGetEPR";
/// Parameter QUERYNAME = "GetOrdByAdm";
Parameter CLASSNAME = "EPRservice.BLL.OrderData.BLOrderData.BLOrderData";

Parameter QUERYNAME = "GetOrdFlagByKSS";

}
