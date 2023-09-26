/// creator:	yunhaibao
/// createdate: 2018-07-09
/// description:Job方式掉后台
Class web.DHCST.Common.Job Extends %RegisteredObject
{

/// description: Job调后台临时存储的返回值
ClassMethod SetJobResult(pid, jobResult)
{
	q:pid="" ""
	s ^DHCSTJOBRESULT(pid)=jobResult
	q 0
}

/// description: 获取Job调后台临时存储的返回值,前台定时循环调用
ClassMethod GetJobResult(pid)
{
	q:pid="" ""
	s jobResult=$g(^DHCSTJOBRESULT(pid))
	k ^DHCSTJOBRESULT(pid)
	q jobResult
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
}

}
