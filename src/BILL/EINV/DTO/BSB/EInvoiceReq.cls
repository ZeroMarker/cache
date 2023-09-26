/// 博思v2.0版本开票
Class BILL.EINV.DTO.BSB.EInvoiceReq Extends %RegisteredObject
{

/// batchNo	批次号	String	32	是	整个单位唯一）
Property batchNo As %String(TRUNCATE = 1, XMLNAME = "batchNo");

/// totalCount	总笔数	Number	10	是	最大支持 99
Property totalCount As %String(TRUNCATE = 1, XMLNAME = "totalCount");

/// serialList	流水详情	节点	不限	是	
Property serialList As list Of BILL.EINV.DTO.BSB.EInvoiceserialList;

/// systemNoise	系统标识	String	32	是	由票据云分配
Property systemNoise As %String(TRUNCATE = 1, XMLNAME = "systemNoise");

/// agencyId	单位识别码	String	32	是	由票据云分配
Property agencyId As %String(TRUNCATE = 1, XMLNAME = "agencyId");

}
