Include %sySystem

/// 获取IRIS指标数据以Prometheus格式输出
Class DHCCSYS.MetricsPrometheus Extends (%RegisteredObject, %XML.Adaptor)
{

/// 数据库产品名
Parameter PRODUCT = {$ZCONVERT($p(##class(%SYSTEM.Version).GetProduct()," ",1),"L")};

/// 数据库产品名
Parameter PRODUCTVERSION = {$zv};

/// 换行符
Parameter NL = {$c(10)};

/// 双引号
Parameter QUTA = {$c(34)};

/// Most recently measured number of Global references per second.
Property GloRefsPerSec As %Numeric;

/// Number of Global references since system startup.
Property GloRefs As %Integer;

/// Number of Global Sets and Kills since system startup.
Property GloSets As %Integer;

/// Number of routine loads and saves since system startup.
Property RouRefs As %Integer;

/// Number of logical block requests since system startup.
Property LogicalReads As %Integer;

/// Number of physical block read operations since system startup.
Property DiskReads As %Integer;

/// Number of physical block write operations since system startup
Property DiskWrites As %Integer;

/// Most recently measured cache efficiency (Global references / (physical reads + writes))
Property CacheEfficiency As %Numeric;

/// Summary status of ECP application servers connected to this system.
Property ECPAppServer As %String;

/// Most recently measured ECP application server traffic in bytes/second.
Property ECPAppSrvRate As %Numeric;

/// Summary status of ECP data servers this system is connected to.
Property ECPDataServer As %String;

/// Most recently measured ECP data server traffic in bytes/second.
Property ECPDataSrvRate As %Numeric;

/// Summary status of shadow connections on this data source. Values from SYS.Shadowing class queries.
Property ShadowSource As %String;

/// Summary status of shadows configured on this shadow server. Values from SYS.Shadowing class queries.
Property ShadowServer As %String;

/// Elapsed time since this system was started.
Property SystemUpTime As %String;

/// Date and time of last system backup.
Property LastBackup As %String;

/// Indicates whether there is a reasonable amount of diskspace available for database files.
/// Possible values are "Normal", "Warning" (<5MB) or "Troubled" (<2MB)
Property DatabaseSpace As %String;

/// Indicates the current status of the database journaling.
/// Possible values are "Normal", "Disabled", "Suspended", "Frozen", "Paused", "Unknown".
Property JournalStatus As %String;

/// Indicates whether there is a reasonable amount of diskspace available for journal files.
/// Possible values are "Normal", "Warning" (<250MB) or "Troubled" (<50MB)
Property JournalSpace As %String;

/// Number of entries written to the system journal since system startup.
Property JournalEntries As %Integer;

/// Indicates the current status of the system Lock Table based on percentage used.
/// Possible values are "Normal", "Warning" (>85%) or "Troubled" (>95%)
Property LockTable As %String;

/// Indicates the current status of the system Write Daemon.
/// Possible values are "Normal" or "Troubled" (based on lack of movement in queue)
Property WriteDaemon As %String;

/// Most recent number of running processes.
Property Processes As %Integer;

/// Most recent number of CSP sessions.
Property CSPSessions As %Integer;

/// Number of serious alerts that have been raised.
Property SeriousAlerts As %Integer;

/// Number of application errors that have been logged.
Property ApplicationErrors As %Integer;

/// Maximum allowed license units for this system.
Property LicenseLimit As %Integer;

/// Text description of license type for this system.
Property LicenseType As %String;

/// Current count of license units being used.
Property LicenseCurrent As %Numeric;

/// Highest count of license units used.
Property LicenseHigh As %Numeric;

/// License usage as a percentage of available license units.
Property LicenseCurrentPct As %Numeric;

/// Highest license usage as a percentage of available license units.
Property LicenseHighPct As %Numeric;

/// Indicates whether there is a reasonable amount of diskspace available for database files.
/// Possible values are 0:"Normal", 1:"Warning" (<5MB) or 2:"Troubled" (<2MB)
Property DatabaseSpaceStatusValue As %Integer;

/// Indicates whether there is a reasonable amount of diskspace available for journal files.
/// Possible values are 0:"Normal", 1:"Warning" (<250MB) or 2:"Troubled" (<50MB)
Property JournalSpaceStatusValue As %Integer;

/// Indicates the current status of the system Lock Table based on percentage used.
/// Possible values are 0:"Normal", 1:"Warning" (>85%) or 2:"Troubled" (>95%)
Property LockTableStatusValue As %Integer;

/// Indicates the current status of the system Write Daemon.
/// Possible values are 0:"Normal" or 2:"Troubled" (based on lack of movement in queue)
Property WriteDaemonStatusValue As %Integer;

/// Indicates the current status of the database journaling.
/// Possible values are 0:"Normal", 3:"Disabled", 4:"Suspended", 5:"Frozen", 6:"Paused", 7:"Unknown".
Property JournalStatusValue As %Integer;

/// 数据库运行时长(秒)
Property SystemUptimeSeconds As %Integer;

/// 开放性事务
/// 0:正常，1:异常
Property OpenTransaction As %Integer;

/// 24小时内的备份
/// 0:正常，1:异常
Property TodayBackupSucess As %Integer;

/// 当前时间-上次全备时间的差值(秒)
Property NowToLastFullBackupSeconds As %Integer;

/// 最近全备文件大小
Property LastFullBackupSizeMb As %Integer;

/// shadow状态
/// 0:正常，1:异常
Property ShadowServerStatusOk As %Integer;

/// mirror状态
/// 0:正常，1:异常
Property MirrorStatusOk As %Integer;

/// MissingMirroredDatabases数
Property MissingMirroredDatabasesCount As %Integer;

/// 当天journal数
Property TodayJrnCount As %Integer;

/// Locks数
Property LocksCount As %Integer;

/// WaitLocks数
Property WaitLocksCount As %Integer;

/// TaskMgrLockErr是否报错
/// 0:无报错，1：有报错
Property TaskMgrLockErr As %Integer;

/// 当天任务执行错误数
Property TodayTasksErrCount As %Integer;

// sensor----------------------------------------------

/// ECP开放性事务数
Property ECPTransOpenCount As %Integer;

/// 开放性事务数
Property TransOpenCount As %Integer;

/// CPU使用率(percent)
Property CpuUsage As %Numeric;

/// Global引用数(每秒)
Property GlobalRefsPerSec As %Integer;

/// Global Set Kill总数
Property GlobalSetKill As %Integer;

/// Global Set Kill数(每秒)
Property GlobalSetKillPerSec As %Integer;

/// Journal条目数(每秒)
Property JournalEntriesPerSec As %Integer;

/// Journal增长速率
Property JournalGrowthRate As %Integer;

/// 锁表空间使用率(percent)
Property LockTablePercentFull As %Numeric;

/// 逻辑块请求数(每秒)
Property LogicalBlockRequestsPerSec As %Integer;

/// 分页空间使用率(percent)
Property PageSpacePercentUsed As %Numeric;

/// 物理内存使用率(percent)
Property PhysMemPercentUsed As %Numeric;

/// 物理块读数
Property PhysicalBlockReads As %Integer;

/// 物理块读数(每秒)
Property PhysicalBlockReadsPerSec As %Integer;

/// 物理块写数
Property PhysicalBlockWrites As %Integer;

/// 物理块写数(每秒)
Property PhysicalBlockWritesPerSec As %Integer;

/// 程序执行命令数
Property RoutineCommands As %Integer;

/// 程序执行命令数(每秒)
Property RoutineCommandsPerSec As %Integer;

/// 程序加载数
Property RoutineLoads As %Integer;

/// 程序加载数(每秒)
Property RoutineLoadsPerSec As %Integer;

/// 程序引用数
Property RoutineRefs As %Integer;

/// 程序引用数(每秒)
Property RoutineRefsPerSec As %Integer;

/// WdPass值
Property WdPass As %Integer;

/// 系统分区空间使用率%
Property SysPartitionPct As %Integer;

/// 其他分区空间最大使用率%
Property OthPartitionMostPct As %Integer;

/// Instantiate the class and fill in current values for all properties.
ClassMethod Sample() As DHCCSYS.MetricsPrometheus
{
	d $system.OBJ.MakeClassDeployed("DHCCSYS.MetricsPrometheus")
	s obj = ..%New()
	
	new $namespace
	set $namespace = "%SYS"
	s ref = ##class(SYS.Stats.Dashboard).Sample()
	
	s obj.ApplicationErrors = ref.ApplicationErrors
	s obj.CSPSessions = ref.CSPSessions
	s obj.CacheEfficiency = ref.CacheEfficiency
	s obj.DiskReads = ref.DiskReads
	s obj.DiskWrites = ref.DiskWrites
	s obj.ECPAppSrvRate = ref.ECPAppSrvRate
	s obj.ECPDataSrvRate = ref.ECPDataSrvRate
	s obj.GloRefs = ref.GloRefs
	s obj.GloRefsPerSec = +ref.GloRefsPerSec
	s obj.GloSets = ref.GloSets
	s obj.JournalEntries = ref.JournalEntries
	s obj.LicenseCurrent = ref.LicenseCurrent
	s obj.LicenseCurrentPct = ref.LicenseCurrentPct
	s obj.LicenseHigh = ref.LicenseHigh
	s obj.LicenseHighPct = ref.LicenseHighPct
	s obj.LicenseLimit = ref.LicenseLimit
	s obj.LogicalReads = ref.LogicalReads
	s obj.Processes = ref.Processes
	s obj.RouRefs = ref.RouRefs
	s obj.SeriousAlerts = ref.SeriousAlerts
	
	s obj.DatabaseSpace = ref.DatabaseSpace
	s obj.JournalSpace = ref.JournalSpace
	s obj.LockTable = ref.LockTable
	s obj.WriteDaemon = ref.WriteDaemon
	s obj.JournalStatus = ref.JournalStatus
	
	s obj.ECPAppServer = ref.ECPAppServer
	s obj.ECPDataServer = ref.ECPDataServer
	s obj.LastBackup = ref.LastBackup
	s obj.LicenseType = ref.LicenseType
	s obj.ShadowServer = ref.ShadowServer
	s obj.ShadowSource = ref.ShadowSource
	s obj.SystemUpTime = ref.SystemUpTime
	
	
	s obj.DatabaseSpaceStatusValue = ..setStatusStrToStatusValue(ref.DatabaseSpace)
	s obj.JournalSpaceStatusValue = ..setStatusStrToStatusValue(ref.JournalSpace)
	s obj.LockTableStatusValue = ..setStatusStrToStatusValue(ref.LockTable)
	s obj.WriteDaemonStatusValue = ..setStatusStrToStatusValue(ref.WriteDaemon)
	s obj.JournalStatusValue = ..setStatusStrToStatusValue(ref.JournalStatus)
	
	s obj.SystemUptimeSeconds = $p($zh,".",1)
	
	s obj.OpenTransaction = ..checkOpenTransactionStatus()
	s obj.TodayBackupSucess = ..getTodayBackupSucess()
	s obj.NowToLastFullBackupSeconds = ..getNowToLastFullBackupSeconds()
	
	s obj.ShadowServerStatusOk = ..isOkMetric(ref.ShadowServer)
	s obj.MirrorStatusOk = ..getMirrorOkStatus()
	s obj.TodayJrnCount = +$p(##class(%SYS.Journal.System).GetCurrentFileName(),".",2)
	s obj.TodayTasksErrCount = ..getTodayTasksErrCount()
	
	d obj.getLocksCount()
	d obj.getPartitionPct()
	d obj.getMissingMirroredDatabasesCount()
	
	d obj.getSensors()
	
	
	
	QUIT obj
}

/// 将状态字符串转换成数值
ClassMethod setStatusStrToStatusValue(StatusStr As %String)
{
	s StatusValue = 0
	
	if ( StatusStr = "Normal" ) {
		s StatusValue = 0
	} elseif ( StatusStr = "Warning" ) {
		s StatusValue = 1
	} elseif ( StatusStr = "Troubled" ) {
		s StatusValue = 2
	} elseif ( StatusStr = "Disabled" ) {
		s StatusValue = 3
	} elseif ( StatusStr = "Suspended" ) {
		s StatusValue = 4
	} elseif ( StatusStr = "Frozen" ) {
		s StatusValue = 5
	} elseif ( StatusStr = "Paused" ) {
		s StatusValue = 6
	} elseif ( StatusStr = "Unknown" ) {
		s StatusValue = 7
	} else {
		s StatusValue = 8
	}
	
	q StatusValue
}

/// 检查事务状态
/// 事务超过24小时返回1异常，否则返回0正常
ClassMethod checkOpenTransactionStatus()
{
	s rs = ##class(%ResultSet).%New("%SYS.Journal.Transaction:List:0")
 	s sc = rs.Execute(rs)
 	s TimeStamp = $zdt($h,-2)
 	s minStartTime = TimeStamp
 	For {
            Quit:'rs.Next()
            ;s Pid = tRS.Get("Pid")
            s StartTime = $zdt(rs.Get("StartTime"),-2)
            if (StartTime < minStartTime)
            {
	            s minStartTime = StartTime
            }
        }
        
        ;w minStartTime,!
     
     s TimeDifference = TimeStamp - minStartTime
     //24*3600=86400
     if (TimeDifference > 86400)
     {
	     q 1
     }else
     {
	     q 0
     }
}

/// 获取最后一次备份时间，转化成时间戳
/// w ##class(DHCCSYS.MetricsPrometheus).getLastBackupTimeStamp()
ClassMethod getLastBackupTimeStamp()
{
	s obj=##class(SYS.Stats.Dashboard).Sample()
	s LastBackupStr=obj.LastBackup
	if (LastBackupStr = "")
	{
		s LastBackupTimeStamp=0
	}else
	{
		s LastBackupTimeStamp=$zdt($zdth(LastBackupStr,5),-2)
	}
	q LastBackupTimeStamp
}

/// 获取最后一次备份时间，和当前时间对比，如果是一天内的，返回0正常，否则返回1异常
/// w ##class(DHCCSYS.MetricsPrometheus).getTodayBackupSucess()
ClassMethod getTodayBackupSucess()
{
	s TimeStamp = $zdt($h,-2)
	s LastBackupTimeStamp=..getLastBackupTimeStamp()
	s TimeDifference = TimeStamp-LastBackupTimeStamp
	if (TimeDifference < 86400)
	{
		q 0
	}else
	{
		q 1
	}
}

/// 获取当前时间-上次全备时间的差值
/// w ##class(DHCCSYS.MetricsPrometheus).getNowToLastFullBackupSeconds()
ClassMethod getNowToLastFullBackupSeconds()
{
	s TimeStamp = $zdt($h,-2)
	s LastBackupTimeStamp=..getLastBackupTimeStamp()
	s TimeDifference = TimeStamp-LastBackupTimeStamp
	
	q TimeDifference
}

/// 获取指标状态值
/// OK返回0，其他状态返回1
/// w ##class(DHCCSYS.MetricsPrometheus).isOkMetric("OK")
ClassMethod isOkMetric(metricInput As %String)
{
	s metric=""
	s metric=metricInput
	//判断为空情况，添加shadow配置，删除配置后，获取到的就是空
	if (metric="OK") || (metric="")
	{
		q 0
	}else
	{
		q 1
	}
}

/// 获取Mirror状态值
/// 正常返回0，异常返回1
/// w ##class(DHCCSYS.MetricsPrometheus).getMirrorStatus()
ClassMethod getMirrorOkStatus()
{
	s status=""
	s status=##class(%SYSTEM.Mirror).GetStatus()
	//(status="NOTINIT") || (status="PRIMARY") || (status="BACKUP") || (status="CONNECTED")
	if ($match(status,"NOTINIT|PRIMARY|BACKUP|CONNECTED"))
	{
		q 0
	}else
	{
		q 1
	}
}

/// 获取MissingMirroredDatabases的总数
/// w ##class(DHCCSYS.MetricsPrometheus).getMissingMirroredDatabases()
Method getMissingMirroredDatabasesCount()
{
	new $namespace
	set $namespace = "%SYS"
	
	s Counts=0
	;s MissingMirroredDatabases = ##class(%ResultSet).RunQuery("SYS.Mirror","MissingMirroredDatabases")
		
	s Rset=##class(%ResultSet).%New("SYS.Mirror:MissingMirroredDatabases")
	d Rset.Execute()
	Quit:$$$ISERR(Rset)
	while Rset.Next(){
		;w Rset.Get("Name")
		s Counts=Counts + 1
	}
	s ..MissingMirroredDatabasesCount = Counts
}

/// 获取锁的总数
Method getLocksCount()
{
	s Counts=0
	s waitLockCount = 0
	s ..TaskMgrLockErr = 1
	s Rset=##class(%ResultSet).%New("%SYS.LockQuery:Detail")
	d Rset.Execute()
	Quit:$$$ISERR(Rset)
	while Rset.Next(){
		;w Rset.Get("Owner")_": "_Rset.Get("Counts")_": "_Rset.Get("WaiterMode")_": "_Rset.Get("FullReference")_": "_Rset.Get("LockString"),!
		s Counts=Counts + Rset.Get("Counts")
		if Rset.Get("LockString") = "^TASKMGR" {
			s ..TaskMgrLockErr = 0
		}
		if Rset.Get("WaiterPID"){
			s waiterPidStr = Rset.Get("WaiterPID")
			s waitLockCount = $l(waiterPidStr,",")
		}
	}
	s ..LocksCount = Counts
	s ..WaitLocksCount = waitLockCount
}

/// 获取当天任务执行错误数
/// w ##class(DHCCSYS.MetricsPrometheus).getTodayTasksErrCount()
ClassMethod getTodayTasksErrCount()
{
	s Counts=0
	s Rset=##class(%ResultSet).%New("%SYS.Task.History:TaskHistoryForDay")
	d Rset.Execute()
	Quit:$$$ISERR(Rset)
	while Rset.Next(){
		;w Rset.Get("Last Start")_" "_Rset.Get("Task")_" "_Rset.Get("Status"),!
		
		;if ( Rset.Get("Status") '= "1" ){
		if ( Rset.Get("%ER Error #") '= "" ){
			;w Rset.Get("%ER Error #"),!
			;w Rset.Get("%ER Date"),!
			s Counts=Counts + 1
		}
	}
	q Counts
}

/// 获取Caché内置Sensors获取多个指标
Method getSensors()
{
	new $namespace
	set $namespace = "%SYS"
	
	//s SensorObj = ##class(SYS.Monitor.SystemSensors).%New()
	s SensorObj = ##class(SYS.Monitor.SAM.Sensors).%New()
	d SensorObj.GetSensors()
	s ..CpuUsage = SensorObj.SAMValues("CPUUsage")
	s ..PhysMemPercentUsed = SensorObj.SAMValues("PhysMemPercentUsed")
	//s ..ECPTransOpenCount = SensorObj.SAMValues("ECPTransOpenCount")
	s ..TransOpenCount = SensorObj.SAMValues("TransOpenCount")
	s ..GlobalRefsPerSec = SensorObj.SAMValues("GloRefPerSec")
	//s ..GlobalSetKill = SensorObj.SAMValues("GloUpdatePerSec")
	s ..GlobalSetKillPerSec = SensorObj.SAMValues("GloUpdatePerSec")
	s ..JournalEntriesPerSec = SensorObj.SAMValues("JrnEntryPerSec")
	//s ..JournalGrowthRate = SensorObj.SAMValues("JournalGrowthRate")
	s ..LockTablePercentFull = SensorObj.SAMValues("SMHPercentFull","Lock Table")
	//s ..LogicalBlockRequestsPerMin = SensorObj.SAMValues("LogicalBlockRequestsPerMin")
	s ..PageSpacePercentUsed = SensorObj.SAMValues("PageSpacePercentUsed")
	//s ..PhysicalBlockReads = SensorObj.SAMValues("PhysicalBlockReads")
	s ..PhysicalBlockReadsPerSec = SensorObj.SAMValues("PhysReadsPerSec")
	//s ..PhysicalBlockWrites = SensorObj.SAMValues("PhysicalBlockWrites")
	s ..PhysicalBlockWritesPerSec = SensorObj.SAMValues("PhysWritesPerSec")
	//s ..RoutineCommands = SensorObj.SAMValues("RoutineCommands")
	//s ..RoutineCommandsPerMin = SensorObj.SAMValues("RoutineCommandsPerMin")
	//s ..RoutineLoads = SensorObj.SAMValues("RoutineLoads")
	//s ..RoutineLoadsPerMin = SensorObj.SAMValues("RoutineLoadsPerMin")
	//s ..RoutineRefs = SensorObj.SAMValues("RoutineRefs")
	//s ..RoutineRefsPerMin = SensorObj.SAMValues("RoutineRefsPerMin")
	//s ..WdPass = SensorObj.SAMValues("WDPass")
	
	/// 汇总数据库基本信息
	s HostName=$zu(54,0)
	s HostIP=$p($zu(54,13,$zu(54,0)),",",1)
	w ..#PRODUCT_"_info{"
	_"productname="_..#QUTA_..#PRODUCT_..#QUTA
	_",hostname="_..#QUTA_HostName_..#QUTA
	_",hostip="_..#QUTA_HostIP_..#QUTA
	//_",productversion="_..#QUTA_..#PRODUCTVERSION_..#QUTA
	//_",cpuusage="_..#QUTA_..CpuUsage_..#QUTA
	//_",physmemused="_..#QUTA_..PhysMemPercentUsed_..#QUTA
	//_",syspartitionpct="_..#QUTA_..SysPartitionPct_..#QUTA
	//_",othpartitionmostpct="_..#QUTA_..OthPartitionMostPct_..#QUTA
	//_",ecptransopencount="_..#QUTA_..ECPTransOpenCount_..#QUTA
	//_",transopencount="_..#QUTA_..TransOpenCount_..#QUTA
	//_",locktabperc="_..#QUTA_..LockTablePercentFull_..#QUTA
	//_",pagespacepercused="_..#QUTA_..PageSpacePercentUsed_..#QUTA
	//_",wdpass="_..#QUTA_..WdPass_..#QUTA
	//_",apperrs="_..#QUTA_..ApplicationErrors_..#QUTA
	//_",cspSessions="_..#QUTA_..CSPSessions_..#QUTA
	//_",licencurperc="_..#QUTA_..LicenseCurrentPct_..#QUTA
	//_",process="_..#QUTA_..Processes_..#QUTA
	//_",seriousalerts="_..#QUTA_..SeriousAlerts_..#QUTA
	//_",shadservstatus="_..#QUTA_..ShadowServerStatusOk_..#QUTA
	//_",sysuptimesec="_..#QUTA_..SystemUptimeSeconds_..#QUTA
	//_",todaybacksucess="_..#QUTA_..TodayBackupSucess_..#QUTA
	//_",todayjrncount="_..#QUTA_..TodayJrnCount_..#QUTA
	//_",todaytaskerrcount="_..#QUTA_..TodayTasksErrCount_..#QUTA
	//_",systemuptime="_..#QUTA_..SystemUpTime_..#QUTA
	//_",taskmgrlockerr="_..#QUTA_..TaskMgrLockErr_..#QUTA	
	_"} 1"_..#NL
	
	/* 备份添加上主机名 */
	w ..#PRODUCT_"_today_backup_sucess{"
	_"hostname="_..#QUTA_HostName_..#QUTA
	_"} "_..TodayBackupSucess_..#NL
	
	w ..#PRODUCT_"_now_to_last_full_backup_seconds{"
	_"hostname="_..#QUTA_HostName_..#QUTA
	_"} "_..getNowToLastFullBackupSeconds()_..#NL
}

/// 获取备份盘信息
/// d ##class(DHCCSYS.MetricsPrometheus).getBackupInfo()
ClassMethod getBackupInfo()
{
	new $namespace
	set $namespace = "%SYS"
	
	s backupInfo=##class(Backup.General).GetLastFullBackupInfo()
	if backupInfo'="" {
		s sep=$e($p(backupInfo,".",2),1,2)
		s backupFile=$p(backupInfo,sep,2)
		
		if backupFile="" {
			q
		}
		
		s OSType=##class(%SYSTEM.Version).GetBuildOS()
		if OSType="Windows"{
			s sep = "\"
			s backupDir=$p(backupFile,sep,1,*-1)_sep
			s backupDir=$REPLACE(backupDir,"\","\\")
		}else{
			s sep = "/"
			s backupDir=$p(backupFile,sep,1,*-1)_sep
		}
		
		s sc=##class(%Library.File).GetDirectorySpace(backupDir,.FreeSpace,.TotalSpace,1)
		
		;w $g(FreeSpace),!, $g(TotalSpace),!
		w ..#PRODUCT_"_backup_free_space_mb{id="_..#QUTA_"Backup"_..#QUTA
		_",dir="_..#QUTA_backupDir_..#QUTA_"} "_$g(FreeSpace)_..#NL
		
		w ..#PRODUCT_"_backup_total_space_mb{id="_..#QUTA_"Backup"_..#QUTA
		_",dir="_..#QUTA_backupDir_..#QUTA_"} "_$g(TotalSpace)_..#NL
		b
	}
}

/// 获取库文件信息
/// d ##class(DHCCSYS.MetricsPrometheus).getDatabaseInfo()
ClassMethod getDatabaseInfo()
{
	new $namespace
	set $namespace = "%SYS"
	
	#;	convert all sizes from SYS.Database query to MB
	#define MBYTES(%v)  $s($f(%v,"EB"):+%v*1073741824,$f(%v,"TB"):+%v*1048576,$f(%v,"GB"):+%v*1024,1:+%v)
	
	s dbRS = ##class(%Library.ResultSet).%New("SYS.Database:FreeSpace")
	
	d dbRS.Execute("*",0)
	while dbRS.%Next(){
		w ..#PRODUCT_"_db_free_space_mb{id="_..#QUTA_dbRS.%Get("DatabaseName")_..#QUTA
		_",dir="_..#QUTA_$REPLACE(dbRS.%Get("Directory"),"\","\\")_..#QUTA_"} "_$$$MBYTES(dbRS.%Get("Available"))_..#NL
	}
	
	d dbRS.Execute("*",0)
	while dbRS.%Next(){
		w ..#PRODUCT_"_db_size_mb{id="_..#QUTA_dbRS.%Get("DatabaseName")_..#QUTA
		_",dir="_..#QUTA_$REPLACE(dbRS.%Get("Directory"),"\","\\")_..#QUTA_"} "_$$$MBYTES(dbRS.%Get("Size"))_..#NL
	}
	
	d dbRS.Execute("*",0)
	while dbRS.%Next(){
		w ..#PRODUCT_"_directory_free_space_mb{id="_..#QUTA_dbRS.%Get("DatabaseName")_..#QUTA
		_",dir="_..#QUTA_$REPLACE(dbRS.%Get("Directory"),"\","\\")_..#QUTA_"} "_dbRS.%Get("DiskFreeSpaceNum")_..#NL
	}
	
	d dbRS.Execute("*",0)
	while dbRS.%Next(){
		s sc=##class(%Library.File).GetDirectorySpace(dbRS.%Get("Directory"),.FreeSpace,.TotalSpace,1)
		w ..#PRODUCT_"_directory_total_space_mb{id="_..#QUTA_dbRS.%Get("DatabaseName")_..#QUTA
		_",dir="_..#QUTA_$REPLACE(dbRS.%Get("Directory"),"\","\\")_..#QUTA_"} "_TotalSpace_..#NL
	}
}

/// 获取journal信息
/// d ##class(DHCCSYS.MetricsPrometheus).getJournalInfo()
ClassMethod getJournalInfo()
{
	new $namespace
	set $namespace = "%SYS"
	
	s IrisMgrDir=$SYSTEM.Util.ManagerDirectory()
	s WIJDir=^CONFIG("config","wijdir")

	// WIJ
	if WIJDir="" {
		s WIJFile=IrisMgrDir_$ZCONVERT(..#PRODUCT,"U")_".WIJ"
		s WIJDir=IrisMgrDir
	}else {
		s WIJFile=WIJDir_$ZCONVERT(..#PRODUCT,"U")_".WIJ"
	}

	s WIJFileSize=##class(%Library.File).GetFileSize(WIJFile)/(1024*1024)
	b
	
	s sc=##class(%Library.File).GetDirectorySpace(WIJDir,.FreeSpace,.TotalSpace,1)
	
	// Journal
	s PrimaryJrnDir=##class(%SYS.Journal.System).GetPrimaryDirectory()
	s AlternateJrnDir=##class(%SYS.Journal.System).GetAlternateDirectory()
	
	s sc1=##class(%Library.File).GetDirectorySpace(PrimaryJrnDir,.PFreeSpace,.PTotalSpace,1)
	s sc2=##class(%Library.File).GetDirectorySpace(AlternateJrnDir,.AFreeSpace,.ATotalSpace,1)
	
	
	// 输出
	// size
	w ..#PRODUCT_"_jrn_size_mb{id="_..#QUTA_"WIJ"_..#QUTA
		_",dir="_..#QUTA_$REPLACE(WIJDir,"\","\\")_..#QUTA_"} "_$g(WIJFileSize)_..#NL
		
	// free space
	w ..#PRODUCT_"_jrn_free_space_mb{id="_..#QUTA_"WIJ"_..#QUTA
		_",dir="_..#QUTA_$REPLACE(WIJDir,"\","\\")_..#QUTA_"} "_$g(FreeSpace)_..#NL
		
	w ..#PRODUCT_"_jrn_free_space_mb{id="_..#QUTA_"primary"_..#QUTA
		_",dir="_..#QUTA_$REPLACE(PrimaryJrnDir,"\","\\")_..#QUTA_"} "_$g(PFreeSpace)_..#NL
		
	w ..#PRODUCT_"_jrn_free_space_mb{id="_..#QUTA_"secondary"_..#QUTA
		_",dir="_..#QUTA_$REPLACE(AlternateJrnDir,"\","\\")_..#QUTA_"} "_$g(AFreeSpace)_..#NL
		
	// total space
	w ..#PRODUCT_"_jrn_total_space_mb{id="_..#QUTA_"WIJ"_..#QUTA
		_",dir="_..#QUTA_$REPLACE(WIJDir,"\","\\")_..#QUTA_"} "_$g(TotalSpace)_..#NL
		
	w ..#PRODUCT_"_jrn_total_space_mb{id="_..#QUTA_"primary"_..#QUTA
		_",dir="_..#QUTA_$REPLACE(PrimaryJrnDir,"\","\\")_..#QUTA_"} "_$g(PTotalSpace)_..#NL
		
	w ..#PRODUCT_"_jrn_total_space_mb{id="_..#QUTA_"secondary"_..#QUTA
		_",dir="_..#QUTA_$REPLACE(AlternateJrnDir,"\","\\")_..#QUTA_"} "_$g(ATotalSpace)_..#NL
}

/// 获取数据库基本信息
/// s obj=##class(DHCCSYS.MetricsPrometheus).%New()
/// d obj.getInstanceInfo()
ClassMethod getInstanceInfo()
{
	s HostName=$zu(54,0)
	s HostIP=$p($zu(54,13,$zu(54,0)),",",1)
	w ..#PRODUCT_"_info{"
	_"productname="_..#QUTA_..#PRODUCT_..#QUTA
	_",hostname="_..#QUTA_HostName_..#QUTA
	_",hostip="_..#QUTA_HostIP_..#QUTA
	_",dir="_..#QUTA_"c:\\intersystemscache\\mgr\\"_..#QUTA
	_"} 1"_..#NL
	;b
}

/// 获取分区信息
/// d ##class(DHCCSYS.MetricsPrometheus).ShowPartitionsInfo()
ClassMethod ShowPartitionsInfo()
{
    s stmt = ##class(%SQL.Statement).%New()
    s status = stmt.%PrepareClassQuery("%File","DriveList")
    
    if $$$ISERR(status) { 
        d $system.OBJ.DisplayError(status)
        q  
    }
    
    s resultSet = stmt.%Execute(1) 
    while resultSet.%Next() {
        s drive= resultSet.%Get("Drive")
        s sc=##class(%Library.File).GetDirectorySpace(drive,.freeSpace,.totalSpace,1)
        
        // free space
		w ..#PRODUCT_"_drive_free_space_mb{"_"drive="_..#QUTA_$REPLACE(drive,"\","\\")_..#QUTA_"} "_$g(freeSpace)_..#NL
		
		// total space
		w ..#PRODUCT_"_drive_total_space_mb{"_"drive="_..#QUTA_$REPLACE(drive,"\","\\")_..#QUTA_"} "_$g(totalSpace)_..#NL
    }
    q ""
}

/// 获取系统分区、其他分区最大使用率%
Method getPartitionPct()
{
    s stmt = ##class(%SQL.Statement).%New()
    s status = stmt.%PrepareClassQuery("%File","DriveList")
    
    if $$$ISERR(status) { 
        d $system.OBJ.DisplayError(status)
        q  
    }
    
    s ..SysPartitionPct = 0
    s ..OthPartitionMostPct = 0
    
    s resultSet = stmt.%Execute(1) 
    while resultSet.%Next() {
        s drive = resultSet.%Get("Drive")
        
        TRY {
			s sc = ##class(%Library.File).GetDirectorySpace(drive,.freeSpace,.totalSpace,1)
			if (drive = "c:\") || (drive = "/") {
	        	s ..SysPartitionPct = $DECIMAL(1-(freeSpace/totalSpace),3)*100
        	} 
        	else{
	        	s OthPartitionPct = $DECIMAL(1-(freeSpace/totalSpace),3)*100
	        	if OthPartitionPct > ..OthPartitionMostPct {
		        	s ..OthPartitionMostPct = OthPartitionPct
	        	}
        	}
		}CATCH exp {
			q
		} 
        
    }
    q ""
}

/// Json转Prometheus格式: {"name":"hxey_ics_license_used","tags":[{"name":"","value":""}],"desc":"已用License数","value":0}
/// w ##class(DHCCSYS.MetricsPrometheus).jsonToPrometheus({"name":"hxey_ics_license_used","tags":[{"name":"","value":""}],"desc":"已用License数","value":0})
ClassMethod jsonToPrometheus(json) As %String
{
    s retStr = ""
    s name=json.name
    s desc=json.desc
    s value=json.value
    s tags=json.tags

    s retStr = retStr_"# HELP "_name_" "_desc
    s retStr = retStr_$CHAR(10)
    s retStr = retStr_"# TYPE "_name_" gauge"
    s retStr = retStr_$CHAR(10)
    if (tags.%Size()=0) {
        s retStr = retStr_name_" "_value
        s retStr = retStr_$CHAR(10)
    } else {
        s retStr = retStr_name_"{"
        s iter2=tags.%GetIterator()
        while iter2.%GetNext(.key, .tag) { 
            s tagName=$REPLACE(tag.name,"""","")
            s tagValue=$REPLACE(tag.value,"""","")
            s retStr = retStr_tagName_"="""_tagValue_""","
        }

        s retStr = retStr_"} "_value
        s retStr = retStr_$CHAR(10)
    }
    return retStr
}

/// 获取production队列等待数量
/// d ##class(DHCCSYS.MetricsPrometheus).getEnsQueue()
ClassMethod getEnsQueue()
{
	s namespace=""
	for { 
	s namespace=$o(^%SYS("Ensemble","InstalledNamespace",namespace)) 
	q:namespace=""
	
	new $namespace
	s $namespace = namespace
	
	if (##class(%Dictionary.CompiledClass).%ExistsId("Ens.Queue")) {
        Set statement=##class(%SQL.Statement).%New(1)
        Set sc=statement.%PrepareClassQuery("Ens.Queue","Enumerate")
        Set rset=statement.%Execute()
        while (rset.%Next()) {
            s name = rset.%Get("Name")
            s count = rset.%Get("Count")
            
            w ..#PRODUCT_"_ens_queue_wait_count{namespace="_..#QUTA_$namespace_..#QUTA
		_",name="_..#QUTA_name_..#QUTA_"} "_count_..#NL
        }
    }
	}
}

/// 获取最近全备文件大小（MB）
Method getLastFullBackupSize()
{
	s lastfullbackupinfo = ##class(Backup.General).GetLastFullBackupInfo()
	s lastfullbackupcbksize=0
	s lastfullbackupcbk = $lg(lastfullbackupinfo,$ll(lastfullbackupinfo))
	if ##class(%File).Exists(lastfullbackupcbk) {
		s lastfullbackupcbksize = ##class(%File).GetFileSize(lastfullbackupcbk)
		s lastfullbackupcbksize = $Decimal(lastfullbackupcbksize/1024/1024,2)
	}else{
		s lastfullbackupcbksize = 0
	}
	s ..LastFullBackupSizeMb = lastfullbackupcbksize
}

}
