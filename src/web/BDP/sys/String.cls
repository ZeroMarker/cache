/// 名称: User.BDPMenu
/// 描述: 基础数据平台字符数据类型扩展
/// 编写者：zhaocz
/// 编写日期: 2013-03-26
/// Use in place of %String for long text fields to avoid truncation !!
Class web.BDP.sys.String [ ClassType = datatype, ClientDataType = VARCHAR, OdbcType = VARCHAR, Not ProcedureBlock, SqlCategory = STRING ]
{

Parameter MAXLEN = 99999;

Parameter TRUNCATE;

}
