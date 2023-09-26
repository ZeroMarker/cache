Import SQLUser

Class DHCOLB.LicenseManage Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// /^%cspSession  %CSP.Session
/// 取得该服务器当前可用License
/// w ##class(DHCOLB.LicenseManage).GetAvailable()
ClassMethod GetAvailable() As %String
{
	s Ret=$system.License.LUAvailable() 
	q Ret
}

/// 取得该服务器最少可用License
/// w ##class(DHCOLB.LicenseManage).GetMinAvailable()
ClassMethod GetMinAvailable() As %String
{
	s Ret=$system.License.LUMinAvailable()
	s Ret=$system.License.LUAvailable()
	q Ret
}

/// 取得该服务器当前消耗的License
/// w ##class(DHCOLB.LicenseManage).GetCurrConsumed()
ClassMethod GetCurrConsumed() As %String
{
	s Ret=$system.License.LUConsumed()
	q Ret
}

/// 取得该服务器最多消耗的License
/// w ##class(DHCOLB.LicenseManage).GetMinAvailable()
ClassMethod GetMaxConsumed() As %String
{
	s Ret=$system.License.LUMaxConsumed()
	q Ret
}

/// 取得该服务器总的授权的用户连接上线
/// w ##class(DHCOLB.LicenseManage).GetUserLimit()
ClassMethod GetUserLimit() As %String
{
	s Ret=$system.License.GetUserLimit()
	q Ret
}

/// 取得该服务器总的授权的License
/// w ##class(DHCOLB.LicenseManage).GetKeyLicenseUnits()
ClassMethod GetKeyLicenseUnits() As %String
{
	s Ret=$system.License.KeyLicenseUnits()
	q Ret
}

/// 取得该服务器一个License的最大连接数
/// w ##class(DHCOLB.LicenseManage).GetMaxConnections()
ClassMethod GetMaxConnections() As %String
{
	s Ret=$system.License.MaxConnections()
	q Ret
}

/// 验证该客户端是否有链接,如果有链接,保持用此服务器
/// w ##class(DHCOLB.LicenseManage).GetConnection()
ClassMethod GetConnection(ClientIP As %String = "") As %String
{
	i ClientIP="" s ClientIP=$ZUTIL(67,15,$JOB)
	q:ClientIP="" 0
	s Ret=$system.License.ConnectionCount(ClientIP)
	s Ret=+Ret
	i Ret=0 s Ret=##class(DHCOLB.LicenseManage).GetBSConn("",ClientIP)
	s Ret=+Ret
	i Ret=0 s Ret=##class(DHCOLB.LicenseManage).GetServerClient("",ClientIP)
	s Ret=+Ret
	q Ret
}

/// 验证该客户端BS程序是否有链接,如果有链接,保持用此服务器
/// w ##class(DHCOLB.LicenseManage).GetBSConn()
ClassMethod GetBSConn(ServerIP As %String = "", ClientIP As %String = "") As %String
{
	s Ret=0
	i ClientIP="" s ClientIP=$ZUTIL(67,15,$JOB)
	q:ClientIP="" Ret
	i ServerIP="" d
	.s hostname=$ZU(54,0)
	.s ServerIP=$P($ZU(54,13,hostname),",")
	q:ServerIP="" Ret
	s ID=$O(^DHCOLBInfoi(0,"ServerClient",ServerIP,ClientIP,""))
	q:ID="" Ret
	s UserID=$P($G(^DHCOLBInfo(ID)),"^",7)
	i UserID'="" s Ret=$system.License.ConnectionCount(UserID)
	q Ret
}

/// 验证该客户端BS程序是否有链接,如果有链接,保持用此服务器
/// w ##class(DHCOLB.LicenseManage).GetServerClient()
ClassMethod GetServerClient(ServerIP As %String = "", ClientIP As %String = "") As %String
{
	s Ret=0
	i ClientIP="" s ClientIP=$ZUTIL(67,15,$JOB)
	q:ClientIP="" Ret
	i ServerIP="" d
	.s hostname=$ZU(54,0)
	.s ServerIP=$P($ZU(54,13,hostname),",")
	q:ServerIP="" Ret
	s ServerID=$O(^DHCOLBServeri(0,"ServerIP",ServerIP,""))
	q:ServerID="" Ret
	s ClientID=""
	f  s ClientID=$O(^DHCOLBClienti(0,"ServerDR",ServerID,ClientID)) q:ClientID=""  d
	.q:Ret>0
	.s ClientStr=$G(^DHCOLBClient(ClientID))
	.q:ClientStr=""
	.s ComputerIP=$P(ClientStr,"^",4)
	.i (ComputerIP'="")&&(ComputerIP=ClientIP) s Ret=1
	.q:Ret>0
	.s ComputerIPUpper=$P(ClientStr,"^",7)
	.s ComputerIPLower=$P(ClientStr,"^",8)
	.q:((ComputerIPUpper="")||(ComputerIPLower=""))
	.s IPLowerInt=+(..VerifyIP(ComputerIPLower))
	.s IPUpperInt=+(..VerifyIP(ComputerIPUpper))
	.s ClientIPInt=+(..VerifyIP(ClientIP))
	.i (ClientIPInt>IPLowerInt)&&(ClientIPInt<IPUpperInt) s Ret=1
	q Ret
}

/// 将IP换算成数值型
/// w ##class(DHCOLB.LicenseManage).VerifyIP("172.2.3.4")
ClassMethod VerifyIP(IPStr As %String = "") As %String
{
	q:$L(IPStr,".")'=4 0
	s Post1=$P(IPStr,".",1)
	s Post2=$P(IPStr,".",2)
	i $L(Post2)=2 s Post2="0"_Post2
	i $L(Post2)=1 s Post2="00"_Post2
	s Post3=$P(IPStr,".",3)
	i $L(Post3)=2 s Post3="0"_Post3
	i $L(Post3)=1 s Post3="00"_Post3
	s Post4=$P(IPStr,".",4)
	i $L(Post4)=2 s Post4="0"_Post4
	i $L(Post4)=1 s Post4="00"_Post4
	s IPInt=+(Post1_Post2_Post3_Post4)
	q IPInt
}

/// 取得访问当前服务器的终端信息
/// w ##class(DHCOLB.LicenseManage).GetServerConnections()
ClassMethod GetServerConnections(ServerIP As %String = "") As %String
{
	i ServerIP="" d
	.s hostname=$ZU(54,0)
	.s ServerIP=$P($ZU(54,13,hostname),",")
	s MemoryAll=0
	s MemoryUsedPercent=0
	s Connections=""
	s ProcessId=""
	f  s ProcessId=$o(^$JOB(ProcessId)) q:(ProcessId="")  d
	.s LinesConnection=ServerIP
	.//s ProcessObj=##class(%SYSTEM.Process).%OpenId(ProcessId)
	.//zn "%SYS"
	.//s ProcessObj=##class(SYS.Process).%OpenId(ProcessId)
	.//s ClientIP=ProcessObj.ClientIPAddressGet()
	.s ClientIP=$ZUTIL(67,15,ProcessId) 
	.//s MemoryAllocated=ProcessObj.MemoryAllocatedGet()
	.//s MemoryUsed=ProcessObj.MemoryUsedGet() 
	.//s State=ProcessObj.StateGet()
	.s StateCode=$ZUTIL(67,4,ProcessId)
	.s State="USE"
	.i StateCode=5 s State="READ"
	.i StateCode=6 s State="WRT"
	.i StateCode=14 s State="HANG"
	.//s ClientName=ProcessObj.ClientNodeNameGet()
	.s ClientName=$ZUTIL(67,12,ProcessId) 
	.//s ClientExe=ProcessObj.ClientExecutableNameGet()
	.s ClientExe=$ZUTIL(67,13,ProcessId)
	.//s NameSpace=ProcessObj.NameSpaceGet()
	.s NameSpace=$ZUTIL(67,6,ProcessId)
	.//s LinesExecuted=ProcessObj.LinesExecutedGet()
	.s LinesExecuted=$ZUTIL(67,8,ProcessId)
	.s RoutineName=$ZUTIL(67,5,ProcessId)
	.s GlobalReferences=$ZUTIL(67,9,ProcessId)
	.s UserName=$ZUTIL(67,11,ProcessId)
	.//d ProcessObj.%Close()
	.//zn "DHC-APP"
	.//s MemoryAll=MemoryAll+MemoryUsed
	.//s MemoryUsedPercent=MemoryUsedPercent+MemoryUsed/MemoryAll
	.q:ClientIP=""
	.s $P(LinesConnection,"|",2)=ClientIP
	.s $P(LinesConnection,"|",3)=State
	.//s ClientName=$$ALPHAUP^SSUTIL4(ClientName)
	.s $P(LinesConnection,"|",4)=ClientName
	.//s ClientExe=$$ALPHAUP^SSUTIL4(ClientExe)
	.s $P(LinesConnection,"|",5)=ClientExe
	.//s NameSpace=$$ALPHAUP^SSUTIL4(NameSpace)
	.s $P(LinesConnection,"|",6)=NameSpace
	.//s $P(LinesConnection,"|",7)=MemoryUsed_"KB"
	.i Connections="" s Connections=LinesConnection
	.e  s Connections=Connections_"!"_LinesConnection
	//s MemoryUsedPercent=MemoryUsedPercent*100
	//s MemoryUsedPercent=MemoryUsedPercent\1
	//s MemoryUsedPercent=MemoryUsedPercent_"%"
	//s MemoryAll=MemoryAll_"KB"
	//s MemoryAllocated=MemoryAllocated_"KB"
	q Connections
}

/// 取得访问当前服务器的信息
/// w ##class(DHCOLB.LicenseManage).GetServerInfo()
ClassMethod GetServerInfo(ServerIP As %String = "") As %String
{
	i ServerIP="" d
	.s hostname=$ZU(54,0)
	.s ServerIP=$P($ZU(54,13,hostname),",")
	s MemoryAll=0
	s MemoryUsedPercent=0
	s ServerInfo=""
	s ProcessId=""
	f  s ProcessId=$o(^$JOB(ProcessId)) q:(ProcessId="")  d
	.//s ProcessObj=##class(%SYSTEM.Process).%OpenId(ProcessId)
	.zn "%SYS"
	.s ProcessObj=##class(SYS.Process).%OpenId(ProcessId)
	.s ClientIP=ProcessObj.ClientIPAddressGet()
	.s MemoryAllocated=ProcessObj.MemoryAllocatedGet()
	.s MemoryUsed=ProcessObj.MemoryUsedGet()
	.d ProcessObj.%Close()
	.zn "dhc-app"
	.s MemoryAll=MemoryAll+MemoryUsed
	.s MemoryUsedPercent=MemoryUsedPercent+MemoryUsed/MemoryAll
	s MemoryUsedPercent=MemoryUsedPercent*100
	s MemoryUsedPercent=MemoryUsedPercent\1
	s MemoryUsedPercent=MemoryUsedPercent_"%"
	s MemoryUsedAll=MemoryAll_"KB"
	s MemoryAllocated=MemoryAllocated_"KB"
	s $P(ServerInfo,"|",1)=MemoryUsedAll
	s $P(ServerInfo,"|",2)=MemoryAllocated
	s $P(ServerInfo,"|",3)=MemoryUsedPercent
	q ServerInfo
}

/// 获取当前服务器正在使用的License
/// w ##Class(DHCOLB.LicenseManage).GetLicenseUsage()
ClassMethod GetLicenseUsage() As %String
{
	Do $System.License.DumpLocalAll()
	s CurrentDevice=$ZUTIL(12,$IO)
	s FileDirectory=$p(CurrentDevice,"|",1)
	q:FileDirectory="" ""
	s FileName=FileDirectory_"all.dmp"
	s FileContent=##Class(DHCOLB.LicenseManage).FileOperate(FileName)
	s LicenseUsage=..AddLicenseInfo(FileContent)
	q LicenseUsage
}

ClassMethod AddLicenseInfo(LicenseContent) As %String
{
	s hostname=$ZU(54,0)
	s ServerIP=$P($ZU(54,13,hostname),",")
	s LicenseUsage=LicenseContent
	s Title=$P(LicenseContent,"^",1)
	s Content=$P(LicenseContent,Title_"^",2)
	s NewTitle=Title_"|ComputerIP|LastConnDate|LastConnTime|ConnLoc|ConnGroup"
	s NewContent=""
	f i=1:1:$L(Content,"^") d
	.s LineCell=$P(Content,"^",i)
	.s UserId=$P(LineCell,"|",1)
	.s (ComputerIP,LastConnDate,LastConnTime,ConnLoc,ConnGroup)=""
	.s ID=$O(^DHCOLBInfoi(0,"ServerUser",ServerIP,UserId,""))
	.i ID'="" d
	..s InfoStr=$G(^DHCOLBInfo(ID))
	..q:InfoStr=""
	..s ComputerIP=$P(InfoStr,"^",4)
	..s LastConnDate=$P(InfoStr,"^",8)
	..i LastConnDate'="" s LastConnDate=$ZD(LastConnDate,3)
	..s LastConnTime=$P(InfoStr,"^",9)
	..i LastConnTime'="" s LastConnTime=$ZT(LastConnTime)
	..s ConnLoc=$P(InfoStr,"^",12)
	..i $P(ConnLoc,"-",2)'="" s ConnLoc=$P(ConnLoc,"-",2)
	..s ConnGroup=$P(InfoStr,"^",13)
	..i $P(ConnGroup,"-",2)'="" s ConnGroup=$P(ConnGroup,"-",2)
	.s LineCell=LineCell_"|"_ComputerIP_"|"_LastConnDate_"|"_LastConnTime_"|"_ConnLoc_"|"_ConnGroup
	.i NewContent="" s NewContent=LineCell
	.e  s NewContent=NewContent_"^"_LineCell
	.
	s LicenseUsage=NewTitle_"^"_NewContent
	q LicenseUsage
}

/// 文件信息读取
/// w ##Class(DHCOLB.LicenseManage).FileOperate("c:\cachesys\mgr\samples\all.dmp")
ClassMethod FileOperate(FileName As %String = "") As %String
{
	
	s ExistsFlag=##Class(%File).Exists(FileName)
	q:ExistsFlag'=1 ""
	s file=##class(%File).%New(FileName)
	d file.Open("R")
	s size=file.SizeGet()
	s FileContent=""
	s Contine=0
	f i=1:1:500 d
	.s Line=file.Read(size)
	.q:Line=""
	.s NewLine=""
	.f j=1:1:$L(Line," ") d
	..s LineCell=$P(Line," ",j)
	..q:LineCell=""
	..i NewLine'="" s NewLine=NewLine_"|"_LineCell
	..e  s NewLine=LineCell
	.s UserId=$P(NewLine,"|",1)
	.q:UserId="free"
	.i $L(NewLine,"|")<5 d
	..i FileContent="" s FileContent=NewLine_"|"
	..e  s FileContent=FileContent_"^"_NewLine_"|"
	..s Contine=1
	.e  d
	..i Contine=1 d
	...s FileContent=FileContent_NewLine
	...s Contine=0
	..e  d
	...i FileContent="" s FileContent=NewLine
	...e  s FileContent=FileContent_"^"_NewLine
	...s Contine=0
	d file.Close()
	q FileContent
}

}
