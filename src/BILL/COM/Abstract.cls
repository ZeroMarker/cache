/// 名称: BILL.COM.Abstract.cls
/// 描述: 计费组继承的抽象类
/// 编写者：ZhYW
/// 编写日期: 2021-04-27
/// 产品组：计费医保组
Class BILL.COM.Abstract Extends %RegisteredObject [ Abstract ]
{

/// Creator: ZhYW
/// CreatDate: 2021-04-27
/// Description: 异常处理
/// Input: 
/// Return: 100^错误信息
/// Debug: w ##class(BILL.COM.Abstract).AppException()
ClassMethod AppException() As %String
{
	if ($tl>0) tro     //如果存在事务，回滚事务
	set $zt=""         //去除错误方法关联，此句必须写
	lock               //解去当前进程内所有锁
	do ..LogEvent()    //记录异常日志
	quit 100_"^"_$tr($ze,"^<>","＾＜＞")
}

/// Creator: ZhYW
/// CreatDate: 2021-04-27
/// Description: 异常日志保存
/// Input: 
/// Return: 
/// Debug: do ##class(BILL.COM.Abstract).LogEvent()
ClassMethod LogEvent() As %String
{
	set myDate=+$h
 	set count=$o(^BILLSYSERROR($this,myDate,""),-1)+1
 	set ^BILLSYSERROR($this,myDate,count)=100_"^"_"<ERROR>"_$ze_"  "_$h
	quit
}

}
