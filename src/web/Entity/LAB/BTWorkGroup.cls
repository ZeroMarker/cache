/// 名称:标准版检验-工作组
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2019-11-6
Class web.Entity.LAB.BTWorkGroup Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTWorkGroup";

// RowId

Property RowID As %String;

// 代码

Property Code As %String;

// 名称

Property CName As %String;

// 检验科室

Property DepartmentDR As %String;

// 负责人

Property Leader As %String;

// 联系电话

Property Telephone As %String;

// 是否显示操作者

Property ShowOperator As %String;

// 是否双签字

Property DoubleCheck As %String;

// 报告模版

Property ReportTempl As %String;

// 所在房间

Property RoomDR As %String;

// WHONET 导出文件路径

Property WPath As %String;

// 序号

Property Sequence As %String;

// Active

Property Active As %String;

// 实验室类型(N 常规,C 细胞学,H 组织,M 微生物,B 血库)

Property LabType As %String;

// 是否开启电子签名

Property IsCALogin As %String;

// 是否显示设置框

Property IsShowSet As %String;

// 自动锁时间

Property LockUserSecond As %String;

// 荒诞报告临床

Property IsUnacceptToClinical As %String;

// 关联工作组

Property LinkWorkGroupDR As %String;

}
