/// 认为防并发调用工具类。开始任务之前先申请锁，防止任务同时执行，任务执行成功或者异常报错后在释放其资源，供后续任务继续执行。
/// 首先调用Try，若返回true则认为可以继续执行，否则认为终止。
/// 任务执行结束后或出现异常调用Finish
/// created by lihaihong@20180704
Class DHCWL.util.TaskUitl Extends %RegisteredObject
{

// d ##class(DHCWL.util.TaskUitl).Try()

ClassMethod Try(node = "1") As %Boolean
{
	s:$g(node,"")="" node="1"
	//ts
	lock +^DHCWL.util.TaskLockInfoD(node)#"S":6
	if ($g(^DHCWL.util.TaskLockInfoD(node),"N")="Y")&&($g(^DHCWL.util.TaskLockInfoD(node,1),0)=+$h){
		s ^||TEMPDHCWLKPIDATA("Login",$j,"fromDate")=$zd(+$h,3)
		s ^||TEMPDHCWLKPIDATA("Login",$j,"toDate")=$zd(+$h,3)
		s ^||TEMPDHCWLKPIDATA("Login",$j,"type")="KpiLogTaskErr"
		s ^||TEMPDHCWLKPIDATA("Login",$j,"CalledFunction")="任务正在运行中（同一时间只能运行一个任务）,任务标示："_node
		s loginService=##class(DHCWL.MKPILogin.LoginService).SetDataProcessLog()
		d loginService.LoginEnd()
 		d ##class(DHCWL.MKPILogin.LoginService).StopLogRobot()
		lock -^DHCWL.util.TaskLockInfoD(node)#"S"
		//tc
		q 0
	}else{
		lock +^DHCWL.util.TaskLockInfoD(node):6
		s ^DHCWL.util.TaskLockInfoD(node)="Y"
		s ^DHCWL.util.TaskLockInfoD(node,1)=+$h
		lock -^DHCWL.util.TaskLockInfoD(node)
		lock -^DHCWL.util.TaskLockInfoD(node)#"S"
		//tc
	}
	q 1
}

// d ##class(DHCWL.util.TaskUitl).Finish()

ClassMethod Finish(node = "1")
{
	s:$g(node,"")="" node="1"
	k ^DHCWL.util.TaskLockInfoD(node)
}

}
