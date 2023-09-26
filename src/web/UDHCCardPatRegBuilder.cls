/// 专门用来读卡和写卡信息的业务构建类
/// 1.患者基本信息
/// 2.卡信息
/// 3.帐户信息
/// 4.帐户中预交金信息
Class web.UDHCCardPatRegBuilder Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 保存Pat
/// Card
/// AccManager
/// 信息到数据库中
/// 
ClassMethod SavePCAInfoToServer(ConfigInfo As %String, PaPatInfo As %String, CardInfo As %String, AccInfo As %String, DepositInfo As %String, ExpStr As %String) As %String
{
	;步骤：
	;1. 对于传的String  进行 反序列化处理
	;2. 验证数据的来源，
	;3. 对数据加以 校验  实现校验规则；
	;	3.1 
	;4. 保存患者基本信息到数据库
	;5. 保存患者的卡信息到数据库
	;	5.1	根据卡类型配置 保存票据信息和费用信息
	;6. 保存患者帐户信息
	;	6.1  保存预交金信息
	;7. 返回 信息  
	;	7.1 组件 保存返回
	;	7.2 Web注册保存返回
}

}
