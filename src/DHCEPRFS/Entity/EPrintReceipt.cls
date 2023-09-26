Class DHCEPRFS.Entity.EPrintReceipt Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property PrintReceiptID As %String(TRUNCATE = 1);

/// 打印小票名称
Property PrintReceiptName As %String(TRUNCATE = 1);

/// 打印小票描述
Property PrintReceiptDesc As %String(TRUNCATE = 1);

/// 创建者
Property CreateMRUserID As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最后修改者
Property LastModifyMRUserID As %String(TRUNCATE = 1);

/// 最后修改日期
Property LastModifyDate As %Date;

/// 最后修改时间
Property LastModifyTime As %Time;

/// 打印小票模板内容
Property TempleContent As %String(MAXLEN = 1000000, TRUNCATE = 1);

/// 是否默认
Property IsDefault As %String(TRUNCATE = 1);

/// 类型 - CHARGE-收费小票 RECEIPT-收费凭据
Property Type As %String(TRUNCATE = 1);

/// 背景图
Property BackgroundImage As %GlobalBinaryStream;

}
