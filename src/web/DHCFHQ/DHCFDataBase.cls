/// 数据库维护
Class web.DHCFHQ.DHCFDataBase Extends %RegisteredObject
{

//Projection NewProjection1 As %Projection.Java(ROOTDIR = "e:\mystudy\mystudy\src");

// w ##class(%SYSTEM.OBJ).MakeClassDeployed("web.DHCFHQ.DHCFDataBase")

ClassMethod getConsole() As %Library.CharacterStream [ SqlProc ]
{
	s retStream=##class(%Library.GlobalCharacterStream).%New()
	
	s RetStr=$SYSTEM.Util.ManagerDirectory() 
	Set streamCconsole=##class(%FileCharacterStream).%New()
	Set streamCconsole.Filename=RetStr_"cconsole.log"
	d retStream.CopyFrom(streamCconsole)
	//d streamCconsole.rewind()
	//s retStr1 = streamCconsole.read(5000)
	//while (retstr1'="")  
	//{
	//	w retStr1
	//			d retStream.Write(retStr1)
	//			s retStr1 = streamCconsole.read(5000)
	//	}
	
	//GetReadOpenParameter(filename As %String, mode As %Integer, ByRef pos As %Integer) As %String
	d streamCconsole.%Close()
	//s RetStr=$SYSTEM.Util.NumberOfCPUs() 
	q retStream
}

ClassMethod getDiskSpace() As %String
{
   s colSep="&"
   s tmpOs=##class(%SYSTEM.Version).GetBuildOS() 
   s retStr="盘符"_"!right"_colSep_"可用空间(G)"_"!right"_colSep_"总空间(G)"_"!right"
   if tmpOs="UNIX" d
   .s freeSpace=0
   .s totalSpace=0
   .s disks=$g(^DiskS)
   .s diskNum=$l(disks,"^")
   .s i=0
   .if diskNum>1 d
   ..for  s i=i+1 q:i>diskNum  d
   ...s disk=$p(disks,"^",i)
   ...if $g(disk)'=""  d
   ....d ##class(%Library.File).GetDirectorySpace(disk,.freeSpace ,.totalSpace,2)
   ....s:(totalSpace>0) retStr=retStr_"@"_disk_colSep_freeSpace_colSep_totalSpace
   .else  d
   ..s disk=$SYSTEM.Util.ManagerDirectory()
   ..d ##class(%Library.File).GetDirectorySpace(disk,.freeSpace ,.totalSpace,2)
   ..s:(totalSpace>0) retStr=retStr_"@"_disk_colSep_freeSpace_colSep_totalSpace
   else  d
   .;d ##class(%Library.File).GetDirectorySpace(disk,.freeSpace ,.totalSpace,2)
   .s result = ##class(%ResultSet).%New("%Library.File:DriveList")
   .Set sc=result.Execute()  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
   .s flag="true" 
   .for  q:(flag'="true")  d
   ..s:(result.Next(.sc)=0) flag="End"
   ..q:flag'="true"
	..If $$$ISERR(sc) Quit 
	..s freeSpace=0
   	..s totalSpace=0
	..s disk=result.Data("Drive")
	..d ##class(%Library.File).GetDirectorySpace(disk,.freeSpace ,.totalSpace,2)
	..s:(totalSpace>0) retStr=retStr_"@"_disk_"!right"_colSep_$FN(freeSpace,"",2)_"!right"_colSep_$FN(totalSpace,"",2)_"!right"
   q retStr
}

ClassMethod getProcessInfo(process As %String) As %String
{
	s colSep="&"
	s sc=""
	zn "%sys"
	s proce=##CLASS(SYS.Process).%OpenId(.process)
	if $g(proce)'="" d
	.s ipAddress=proce.StartupClientIPAddress
	.s userName=proce.UserName
	.s maName=proce.ClientNodeName
	.s nameSpace=(proce.NameSpace)
	.s osUserName=(proce.OSUserName)
	.s clientExeName=(proce.ClientExecutableName) 
	.s routine=(proce.Routine)
	.s state=(proce.State)  
	.s device=(proce.OpenDevices),device=$tr(device,"//./null,","")
	.//w ipAddress_"^"_userName_"^"_maName_"^"_osName_"^"_clientExeName_"^"_routine_"^"_userInfo,!
	s proce=""
	zn "dhc-app"
	q $g(ipAddress)_colSep_$g(userName)_colSep_$g(maName)_colSep_$g(nameSpace)_"!right"_colSep_$g(osUserName)_colSep_$g(clientExeName)_colSep_$g(routine)_colSep_$g(state)_colSep_$g(device)
}

ClassMethod getProcessList() As %String
{
	s colSep="&"
	Set result=##class(%ResultSet).%New("%SYSTEM.License:ProcessList")
	Set sc=result.Execute()  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit retStr
	s i=0
	s retStr="IP"_colSep_"用户名"_colSep_"机器名"_colSep_"命名空间"_colSep_"操作名"_colSep_"EXE名"_colSep_"程序"_colSep_"壮态"_colSep_"设备"_colSep_"PID"_colSep_"Process"_colSep_"Type"_colSep_"连接"_colSep_"最大"_colSep_"CSPCon"_colSep_"UNIT"_colSep_"Active"_colSep_"Grace"
	
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit 
		if (result.Data("PID")>0) d
		.s i=i+1
		.s processInfo=..getProcessInfo(result.Data("PID"))
		.;s processInfo=" "_colSep_" "_colSep_" "
		.if (result.Data("Type")="User") d
		..s ^TempFhqP(1,(99-result.Data("MaxCon")),i)=$g(processInfo)_colSep_result.Data("PID")_colSep_result.Data("Process")_colSep_result.Data("Type")_colSep_result.Data("Con")_colSep_result.Data("MaxCon")_colSep_result.Data("CSPCon")_colSep_result.Data("LU")_colSep_result.Data("Active")_colSep_result.Data("Grace")
		.else  d
		..s ^TempFhqP(2,(99-result.Data("MaxCon")),i)=$g(processInfo)_colSep_result.Data("PID")_colSep_result.Data("Process")_colSep_result.Data("Type")_colSep_result.Data("Con")_colSep_result.Data("MaxCon")_colSep_result.Data("CSPCon")_colSep_result.Data("LU")_colSep_result.Data("Active")_colSep_result.Data("Grace")
	}
	s i=0
	for  s i=$o(^TempFhqP(i)) q:(i="")  d
	.s j=0
	.f  s j=$o(^TempFhqP(i,j)) q:(j="")  d
	..s num=0
	..f  s num=$o(^TempFhqP(i,j,num)) q:(num="")  d
	...if retStr'="" s retStr=retStr_"@"_^TempFhqP(i,j,num)
	...if retStr="" s retStr=^TempFhqP(i,j,num)
	k ^TempFhqP
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit retStr
	s aa=result.Close()
	Quit retStr
}

ClassMethod getUserListAll() As %String
{
	s colSep="&"
	Set result=##class(%ResultSet).%New("%SYSTEM.License:UserListAll")
	Set sc=result.Execute()  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit retStr
	s retStr="UserId"_colSep_"Type"_colSep_"Connects"_colSep_"Type"_colSep_"MaxCon"_colSep_"CSPCon"_colSep_"LU"_colSep_"Active"_colSep_"Grace"
	S i=0
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit 
		s i=i+1
		s FHQUSER((99-result.Data("MaxCon")),result.Data("UserId"),i)=result.Data("UserId")_colSep_result.Data("Type")_colSep_result.Data("Connects")_"!right "_result.Data("Type")_colSep_result.Data("MaxCon")_"!right "_result.Data("CSPCon")_colSep_result.Data("LU")_"!right "_result.Data("Active")_"!right "_result.Data("Grace")_"!right"
		//if retStr'="" s retStr=retStr_"@"_result.Data("UserId")_colSep_result.Data("Type")_colSep_result.Data("Connects")_"!right "_result.Data("Type")_colSep_result.Data("MaxCon")_"!right "_result.Data("CSPCon")_colSep_result.Data("LU")_"!right "_result.Data("Active")_"!right "_result.Data("Grace")_"!right"
		//if retStr="" s retStr=result.Data("UserId")_colSep_result.Data("Type")_colSep_result.Data("Connects")_"!right "_result.Data("Type")_colSep_result.Data("MaxCon")_"!right "_result.Data("CSPCon")_colSep_result.Data("LU")_"!right "_result.Data("Active")_"!right "_result.Data("Grace")_"!right"
	}
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit retStr
	s aa=result.Close()
	s i=0
	F  S i=$o(FHQUSER(i)) q:i=""  d
	.s UserId=""
	.f  s UserId=$o(FHQUSER(i,UserId)) q:UserId=""  d
	..s num=0
	..f  s num=$o(FHQUSER(i,UserId,num)) q:num=""  d
	...s retStr=retStr_"@"_FHQUSER(i,UserId,num)
	k FHQUSER
	Quit retStr
}

ClassMethod getUserList() As %String
{
	s colSep="&"
	k FHQUSER
	S i=0
	Set result=##class(%ResultSet).%New("%SYSTEM.License:UserList")
	Set sc=result.Execute()  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit retStr
	s retStr="用户"_colSep_"Type"_colSep_"连接!center"_colSep_"Type"_colSep_"最大!center"_colSep_"CSPCon"_colSep_"占用LICENSE!center"_colSep_"Active"_colSep_"Grace"
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit 
		s FHQUSER((99-result.Data("MaxCon")),result.Data("UserId"))=result.Data("UserId")_colSep_result.Data("Type")_colSep_result.Data("Connects")_"!right "_result.Data("Type")_colSep_result.Data("MaxCon")_"!right "_result.Data("CSPCon")_colSep_result.Data("LU")_"!right "_result.Data("Active")_"!right "_result.Data("Grace")_"!right"
		//if retStr'="" s retStr=retStr_"@"_result.Data("UserId")_colSep_result.Data("Type")_colSep_result.Data("Connects")_"!right "_result.Data("Type")_colSep_result.Data("MaxCon")_"!right "_result.Data("CSPCon")_colSep_result.Data("LU")_"!right "_result.Data("Active")_"!right "_result.Data("Grace")_"!right"
		//if retStr="" s retStr=result.Data("UserId")_colSep_result.Data("Type")_colSep_result.Data("Connects")_"!right "_result.Data("Type")_colSep_result.Data("MaxCon")_"!right "_result.Data("CSPCon")_colSep_result.Data("LU")_"!right "_result.Data("Active")_"!right "_result.Data("Grace")_"!right"
	}
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit retStr
	s aa=result.Close()
	F  S i=$o(FHQUSER(i)) q:i=""  d
	.s UserId=""
	.f  s UserId=$o(FHQUSER(i,UserId)) q:UserId=""  d
	..s retStr=retStr_"@"_FHQUSER(i,UserId)
	k FHQUSER
	Quit retStr
}

/// 获取数据库安装目录
ClassMethod getDataBaseDir() As %String
{
	s colSep="&"
	s RetStr=$SYSTEM.Util.ManagerDirectory() 
	q "安装目录"_colSep_RetStr
}

ClassMethod getNumOfCpu() As %String
{
	s colSep="&"
	s RetStr=$SYSTEM.Util.NumberOfCPUs() 
	q "CPU数量"_colSep_RetStr
}

ClassMethod getWijSize() As %String
{
	s colSep="&"
	s RetStr=$SYSTEM.Util.ManagerDirectory() 
	s fileSize=##class(%Library.File).GetFileSize(RetStr_"CACHE.WIJ")/(1024*1024)
	q "CACHE.WIJ"_colSep_$fn(fileSize,"",2)_"M"
}

ClassMethod getDataBaseList() As %String
{
	s currentNameSpace=$ZUTIL(5)
	zn "%sys"
	
	Set result=##class(%ResultSet).%New("Config.DataStorage:DatabaseDetail")
	Set sc=result.Execute()  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit retStr
	s i=0
	s colSep="&"
	s osName=##class(%SYSTEM.Version).GetBuildOS()

	s retStr="名称"_colSep_"目录"_colSep_"大小(M)!right"
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit 
		if $l(result.Data("Directory"),"/")>1  d
		.s fileSize=##class(%Library.File).GetFileSize(result.Data("Directory")_"/CACHE.DAT")/(1024*1024)
		else  d
		.s fileSize=##class(%Library.File).GetFileSize(result.Data("Directory")_"\CACHE.DAT")/(1024*1024)
		s retStr=retStr_"@"_result.Data("Name")_colSep_result.Data("Directory")_colSep_$FN(fileSize,"",2)_"!right"
	}
	s aa=result.Close()
	s currentNameSpace=$ZUTIL(5,currentNameSpace)
	Quit retStr
}

ClassMethod getLockList() As %String
{

	s colSep="&"
	Set result=##class(%ResultSet).%New("%SYS.LockQuery:List")
	Set sc=result.Execute()  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit retStr

	s retStr="DelKey"_colSep_"Owner"_colSep_"Mode!right"_colSep_"Flags"_colSep_"Counts"_colSep_"Sfn"_colSep_"LockString"_colSep_"FullReference"
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit 
		s retStr=retStr_"@"_result.Data("DelKey")_colSep_result.Data("Owner")_colSep_result.Data("Mode")_colSep_result.Data("Flags")_colSep_result.Data("Counts")_colSep_result.Data("Sfn")_colSep_result.Data("LockString")_colSep_result.Data("FullReference")
	}
	s aa=result.Close()
	Quit retStr
}

ClassMethod getTest(aaa As %String) As %String
{
	Quit aaa
}

ClassMethod getStringCommon(clsName, methodName As %String) As %String
{
	s retStr=""
	if (methodName="getDataBaseList")  d
	.s retStr=##class(web.DHCFHQ.DHCFDataBase).getDataBaseList()
	if (methodName="getUserList")  d
	.s retStr=##class(web.DHCFHQ.DHCFDataBase).getUserList()
	if (methodName="getUserListAll")  d
	.s retStr= ##class(web.DHCFHQ.DHCFDataBase).getUserListAll()
	if (methodName="getProcessList")  d
	.s retStr= ##class(web.DHCFHQ.DHCFDataBase).getProcessList()
	if (methodName="getLockList")  d
	.s retStr= ##class(web.DHCFHQ.DHCFDataBase).getLockList()
	if (methodName="getDiskSpace")  d
	.s retStr= ##class(web.DHCFHQ.DHCFDataBase).getDiskSpace()
	if (methodName="getDataBaseDir")  d
	.s retStr= ##class(web.DHCFHQ.DHCFDataBase).getDataBaseDir()
	if (methodName="getWijSize")  d
	.s retStr= ##class(web.DHCFHQ.DHCFDataBase).getWijSize()
	if (methodName="getLicense")  d
	.s retStr= ##class(web.DHCFHQ.DHCFDataBase).getLicense()
	Quit retStr
}

ClassMethod getLicense() As %String
{
	s ^fhqaaaa="ddddd"
	Set result=##class(%ResultSet).%New("%SYSTEM.License:Summary")
	Set sc=result.Execute()  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit retStr
	s retStr=""
    s colSep="&"
	While result.Next() {
		if retStr'="" s retStr=retStr_"@"_result.Data("License Unit Use")_colSep_result.Data("Local")_"!right"_colSep_result.Data("Distributed")_"!right"
		if retStr="" s retStr=result.Data("License Unit Use")_colSep_result.Data("Local")_"!right"_colSep_result.Data("Distributed")_"!right"
		
	}
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit retStr
	s aa=result.Close()
	Quit retStr
}

}
