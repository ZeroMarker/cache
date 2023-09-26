Class web.Entity.MKB.MKBBatchProcess Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

/// Creator：      	张云越
/// CreatDate：    	2019-08-28
/// Description:     批处理方法数据Entity
/// Table：          User.MKBBatchProcess
Parameter PersistentClassName = "web.Entity.MKB.MKBBatchProcess";

/// ID
Property ID As %String;

/// 方法描述
Property MethodDesc As %String;

/// 方法命令
Property MethodName As %String;

/// 参数说明
Property ArgDesc As %String;

/// 参数值
Property ArgValue As %String;

/// 标志
Property Flag As %String;

/// 导入标志
/// Property IFlag As %String;
/// 导出标志
/// Property EFlag As %String;

}
