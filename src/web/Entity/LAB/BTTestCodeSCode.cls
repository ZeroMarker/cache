/// 名称:标准版检验-标准码
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-3-9
Class web.Entity.LAB.BTTestCodeSCode Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTTestCodeSCode";

// rowid

Property RowID As %String;

// 代码

Property SCode As %String;

// 名称

Property TCName As %String;

// 类型

Property SpecimenType As %String;

// 序号

Property Sequence As %String;

// 激活

Property Active As %String;

}
