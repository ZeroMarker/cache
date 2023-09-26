/// 监听License使用
/// 系统部：谭宏辉
/// 日期：2022-08-19
Class DHCCSYS.LicenseMonitor Extends %RegisteredObject
{

/// 当License使用率大于预设值，导出License使用详情，并merge ^%cspSession信息
/// OutPutDir: 文件导出路径，LicenseUsedPct：License使用率(%)，DumpNum：保留几份文件，Interval：间隔时长，Duration: 持续时长
/// d ##class(DHCCSYS.LicenseMonitor).Dump()
ClassMethod Dump(OutPutDir As %String = "", LicenseUsedPct As %Integer = 90, DumpNum As %Integer = 3, Interval As %Integer = 15, Duration As %Integer = 86280) [ Language = objectscript ]
{
	if OutPutDir = "" {
		s OutPutDir = $SYSTEM.Util.ManagerDirectory()
	}
	s status=##class(%Library.File).CreateDirectoryChain(OutPutDir)
	if status = 0 {
		w "无法创建目录，请检查路径位置是否正确",!
		quit
	}
	
	d ..killTempCspSession()
	d ..deleteOutPutFile()
	
	s LUConsumedPercent = ..getLUConsumedPercent()
	s sum = 1
	s times = 1
	
	// 从任务执行，计算下当天还剩多少秒，避免任务没跑完，第二天任务挂起
	if (Duration = 86280) {
		s seconds = $p($h,",",2)
		s Duration = Duration - seconds
	}
		
	while ((sum <= DumpNum) && (times <= (Duration/Interval))){
		w "第"_times_"次check：",!
		if LUConsumedPercent >= LicenseUsedPct {
			;b
			w "第"_sum_"次dump："
			s FileName = "licensedump_"_$zd($h,3)_"_"_$TR($zt($p($h,",",2),1),":","-")_".txt"
			s OutPutFile = OutPutDir_FileName
			d ##class(%SYSTEM.License).DumpLocalInUse(OutPutFile)
			m ^TempCspSession($zd($h,3),$zt($p($h,",",2),1))=^%cspSession
			s ^TempOutPutFile($zd($h,3),$zt($p($h,",",2),1))=OutPutFile			
			
			s sum = sum +1
			w !,!
		}
		s times = times +1
		hang Interval
		s LUConsumedPercent = ..getLUConsumedPercent()
	}
	Quit $$$OK
}

/// 获取License使用率(%)
ClassMethod getLUConsumedPercent() As %Integer
{
	s LUAvailableCount=$SYSTEM.License.LUAvailable()	//可用License数
	s LUConsumedCount=$SYSTEM.License.LUConsumed() 	//已用License数
	s LUTotalCount=LUAvailableCount+LUConsumedCount 	//总License数
	s LUConsumedPercent=$Number(LUConsumedCount/LUTotalCount*100,0)	//已用License百分比
	return LUConsumedPercent
}

/// kill掉n天前的TempcspSessionglobal信息，避免导致temp库过大
/// w ##class(DHCCSYS.LicenseMonitor).killTempcspSession()
ClassMethod killTempCspSession(Days As %Integer = 7)
{
	k ^TempCspSession($zd($h-Days,3))
	Quit $$$OK
}

/// 删除掉n天前的LicenseDump的txt文件
/// w ##class(DHCCSYS.LicenseMonitor).deleteOutPutFile()
ClassMethod deleteOutPutFile(Days As %Integer = 7)
{
	s OutPutFileTime=""
	for {
		s OutPutFileTime=$o(^TempOutPutFile($zd($h-Days,3),OutPutFileTime))
		q:OutPutFileTime=""
		s OutPutFile=^TempOutPutFile($zd($h-Days,3),OutPutFileTime)
		q:OutPutFile=""
		d ##class(%Library.File).Delete(OutPutFile)
 	}
 	k ^TempOutPutFile($zd($h-Days,3))
	Quit $$$OK
}

}
