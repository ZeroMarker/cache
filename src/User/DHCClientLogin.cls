Class User.DHCClientLogin Extends %Persistent [ SqlRowIdName = DHCCL_Rowid, SqlTableName = DHC_ClientLogin, StorageStrategy = NewStorage1 ]
{

Property DHCCLComputerIp As %String [ SqlColumnNumber = 2, SqlFieldName = DHCCL_ComputerIp ];

Property DHCCLSessionId As %String [ SqlColumnNumber = 3, SqlFieldName = DHCCL_SessionId ];

Property DHCCLStatus As %String(DISPLAYLIST = ",Login,Logout", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",in,out") [ SqlColumnNumber = 4, SqlFieldName = DHCCL_Status ];

Property DHCCLComputerName As %String [ SqlColumnNumber = 6, SqlFieldName = DHCCL_ComputerName ];

Property DHCCLComputerMac As %String [ SqlColumnNumber = 7, SqlFieldName = DHCCL_ComputerMac ];

Property DHCCLUserAgent As %String(MAXLEN = 500) [ SqlColumnNumber = 8, SqlFieldName = DHCCL_UserAgent ];

Property DHCCLSysViewDr As %String [ SqlColumnNumber = 9, SqlFieldName = DHCCL_SysView_Dr ];

Property DHCCLToken As %String [ SqlColumnNumber = 10, SqlFieldName = DHCCL_Token ];

Property DHCCLOutType As %String(DISPLAYLIST = ",NormalExit,TimeOutExit", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",NE,TE") [ SqlColumnNumber = 11, SqlFieldName = DHCCL_OutType ];

Property DHCCLServerECPIP As %String [ SqlColumnNumber = 12, SqlFieldName = DHCCL_ServerECPIP ];

Index ComputerIpLogin On (DHCCLComputerIp, DHCCLStatus);

Method Construct(ip As %String, sessionid As %String, ComputerName As %String = "", ComputerMac As %String = "", UserAgent = "", SysViewDr = "", Token = "", ServerIp As %String = "") As %String
{
	s i%DHCCLComputerIp=ip
	s i%DHCCLSessionId=sessionid
	s i%DHCCLStatus="in"
	s i%DHCCLComputerName=ComputerName
	s i%DHCCLComputerMac=ComputerMac
	s i%DHCCLUserAgent=UserAgent
	s i%DHCCLSysViewDr = SysViewDr
	s i%DHCCLToken = Token
	s i%DHCCLServerECPIP = ServerIp
	q ..%Save()
}

Method Logout(OutType = "TE") As %String
{
	if (i%DHCCLStatus="out") Q 1
	s i%DHCCLStatus="out"
	s i%DHCCLOutType=OutType
	q ..%Save()
}

/// 退出二张表
ClassMethod LogoutById(Id, OutType = "TE")
{
	 Quit:Id'>0 "-1"
	 Do ##Class(web.SSUserLogin).SaveLogoffDateTime(Id)
	 Set obj2 = ##class(User.DHCClientLogin).%OpenId(Id)
	 If $IsObject(obj2) {
		Do obj2.Logout(OutType)
		Set obj2 = ""
	 }
	 q 0
}

/// 通过会话通退出,切换科室,串会话时有二个Session一样的记录
/// @param SessionId 会话Id
/// @param Count 循环次数--只有是当天inline类型才成置成out-影响同sessionid的记录条数
ClassMethod LogoutSession(SessionId, Count = 1)
{
	Set rtn = 0 
	Set Id2="",Ind=0
	Do{
	 	 Set Id2 = $O(^SST("LOG",0,"SessionId",SessionId,Id2),-1)
	 	 Set Ind = Ind + 1
	 	 Quit:Ind>Count
	 	 If (Id2>0)&&("in"=$p(^SST("LOG",Id2,"ADDR"),"^",3)) {
	 	 	set rtn = ..LogoutById(Id2)
	 	 }
	 }While(Id2>0)
	Quit rtn
}

/// 叫号屏显示在线医生
/// 通过计算机名 取 在线用户Id^科室Id$在线用户Id^科室Id
/// 
ClassMethod GetUserByClient(ComputerName)
{
	Quit:(ComputerName="") ""
	Set ComputerNameUp = $$upper^SSUTIL4(ComputerName)
	Set rtn = ""
	Set RowId = "",NowDate = +$h
	For {
		Set RowId = $O(^SST("LOG",0,"CName",ComputerNameUp,"in",RowId),-1)
		Quit:(RowId="")
		Set LogSessionId = $p(^SST("LOG",RowId,"ADDR"),"^",2)
		If (0=$data(^%cspSession(LogSessionId))){ 
			d ..LogoutById(RowId)
		}else{
			Set UserId = $P(^SST("LOG",RowId),"^",1)
			Set LocId = $P(^SST("LOG",RowId),"^",7)
			If rtn="" {
				Set rtn = UserId_"^"_LocId
			}else{
				Set rtn = rtn_"$"_UserId_"^"_LocId
			} 
		}
	}
	Quit rtn
}

ClassMethod GetCASLoginInfoByLog(reqTicket = "", paramsessionid = "")
{
	//南大二附方法写在了SessionLogon中，标版写在这吧，而且没必要增加Token的索引,走SessionId的索引应该即可
	/*
	n dhcclrowid,logusercode,logsessionid,loguserdr,loglocdr,loggroupdr
	if paramsessionid="" set paramsessionid=%session.SessionId
	set dhcclrowid=""
	for {
		set dhcclrowid=$o(^SST("LOG",0,"Token",reqTicket,dhcclrowid),-1)
		q:dhcclrowid=""
		set logsessionid=$p($g(^SST("LOG",dhcclrowid,"ADDR")),"^",2)
		q:logsessionid=paramsessionid
	} */
	if paramsessionid="" set paramsessionid=%session.SessionId
	if (paramsessionid="")||(reqTicket="") q ""
	set nowdate=+$h
	set dhcclrowid="" 
	for {
		set dhcclrowid=$o(^SST("LOG",0,"SessionId",paramsessionid,dhcclrowid),-1)
		q:dhcclrowid=""
		set logdate=$p($g(^SST("LOG",dhcclrowid)),"^",3)
		if nowdate>logdate {    ;今天之前的日志就不看了
			set dhcclrowid=""  
			q 
		}
		set logtoken=$p($g(^SST("LOG",dhcclrowid,"ADDR")),"^",8)
		q:logtoken=reqTicket   //ticket对上了
	}
	
	if dhcclrowid>0 {
		set loguserdr=$p($g(^SST("LOG",dhcclrowid)),"^",1)
		set logusercode=$p($g(^SSU("SSUSR",loguserdr)),"^",1)
		set loglocdr=$p($g(^SST("LOG",dhcclrowid)),"^",7)
		set loggroupdr=$p($g(^SST("LOG",dhcclrowid)),"^",10)
		//set ^cryze("bloglogininfo",reqTicket)=logusercode_"^"_loglocdr_"^"_loggroupdr
		if logusercode'="",loglocdr>0,loggroupdr>0 q logusercode_"^"_loglocdr_"^"_loggroupdr
	}
	q ""
}

/// 192.168.5.122^131G5sui00^out^wanghc-PC^A4:DB:30:A7:49:3C
/// @return 客户端信息
/// IP地址^会话ID^在线状态^计算机名^计算机MAC
/// ##class(User.DHCClientLogin).GetInfo()
ClassMethod GetInfo(RowId = "")
{
	/**
	*s obj = ##class(User.DHCClientLogin).%OpenId($g(%session.Data("LOGON.SSUSERLOGINID")),0)
	set mac = obj.DHCCLComputerMac
	set cmpname= obj.DHCCLComputerName
	set ip= obj.DHCCLComputerIp
	*/
	if (RowId="") && $d(%session) {
		Set RowId = $g(%session.Data("LOGON.SSUSERLOGINID"))
	}
	Quit:RowId>0 $G(^SST("LOG",RowId,"ADDR"))
	Quit ""
}

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="CNameIndex">
<Condition>
<![CDATA[($p({DHCCL_ComputerName},$c(1))'="")&&($p({DHCCL_ComputerName},$c(1))'="undefined")]]></Condition>
<ConditionFields>DHCCL_ComputerName</ConditionFields>
<Global>^SST</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHCCL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CName"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$upper^SSUTIL4({DHCCL_ComputerName})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCCL_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCCL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IPIndex">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHCCL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"IP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCCL_ComputerIp}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCCL_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCCL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Map1">
<Data name="DHCCL_ComputerIp">
<Delimiter>"^"</Delimiter>
<Node>"ADDR"</Node>
<Piece>1</Piece>
</Data>
<Data name="DHCCL_ComputerMac">
<Delimiter>"^"</Delimiter>
<Node>"ADDR"</Node>
<Piece>5</Piece>
</Data>
<Data name="DHCCL_ComputerName">
<Delimiter>"^"</Delimiter>
<Node>"ADDR"</Node>
<Piece>4</Piece>
</Data>
<Data name="DHCCL_OutType">
<Delimiter>"^"</Delimiter>
<Node>"ADDR"</Node>
<Piece>9</Piece>
</Data>
<Data name="DHCCL_ServerECPIP">
<Delimiter>"^"</Delimiter>
<Node>"ADDR"</Node>
<Piece>10</Piece>
</Data>
<Data name="DHCCL_SessionId">
<Delimiter>"^"</Delimiter>
<Node>"ADDR"</Node>
<Piece>2</Piece>
</Data>
<Data name="DHCCL_Status">
<Delimiter>"^"</Delimiter>
<Node>"ADDR"</Node>
<Piece>3</Piece>
</Data>
<Data name="DHCCL_SysView_Dr">
<Delimiter>"^"</Delimiter>
<Node>"ADDR"</Node>
<Piece>7</Piece>
</Data>
<Data name="DHCCL_Token">
<Delimiter>"^"</Delimiter>
<Node>"ADDR"</Node>
<Piece>8</Piece>
</Data>
<Data name="DHCCL_UserAgent">
<Delimiter>"^"</Delimiter>
<Node>"ADDR"</Node>
<Piece>6</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHCCL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCCL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="SessionIndex">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCCL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SessionId"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCCL_SessionId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCCL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCClientLoginS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
