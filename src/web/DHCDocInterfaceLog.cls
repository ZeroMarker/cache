/// 2022-04-09
/// 医生站接口日志相关类
Class web.DHCDocInterfaceLog Extends DHCDoc.Util.RegisteredObject
{

/// 允许超时次数(每天)
Parameter TimeOutNum = 3;

/// 日志保留时间(天)
Parameter LogKeepDay = 3;

/************************************* 医生站日志注册界面相关 Start ****************************************/
/// Creater：李旭
/// Date：2022-04-09
/// Desc：校验代码在接口注册或日志注册中是否唯一，并返回存在另一表中的ID
/// Input: FRowId:表ID、FCode:校验代码、Source:(Method/Log):来源
/// Output：-1/0^描述^存在另一表ID: 失败/成功^描述
/// Debug：w ##class(web.DHCDocInterfaceLog).CheckInterfaceCode("","doc.ord.GetDisChargeNeedArcimStr")
ClassMethod CheckInterfaceCode(FRowId, FCode, Source) As %String
{
	s Code=0
	s (Desc,RowId)=""
	s Source=$zcvt(Source,"U")
	if (Source="METHOD"){
		s MethodRowId=$o(^User.DocInterfaceMethodI("methodCode",FCode,0))
		if (MethodRowId'=""){
			s MethodInfo=$g(^User.DocInterfaceMethodD(MethodRowId))
			s MethodCode=$lg(MethodInfo,2)
			s MethodDesc=$lg(MethodInfo,3)
			i (FRowId'="")&&(MethodRowId'=FRowId) s Code="-1"
			i (FRowId="") s Code="-1"
			i Code="-1"{
				s Desc="代码已被医生站接口注册，接口代码："_MethodCode_" 接口名称："_MethodDesc
			}
		}
		;获取代码在日志表中的ID
		s RowId=$o(^CF.DOC.Interface.LogRegistI("LogCode",FCode,0))
	}elseif(Source="LOG"){
		s LogRowId=$o(^CF.DOC.Interface.LogRegistI("LogCode",FCode,0))
		if (LogRowId'=""){
			s LogInfo=$g(^CF.DOC.Interface.LogRegistD(LogRowId))
			s LogCode=$lg(LogInfo,3)
			s LogDesc=$lg(LogInfo,4)
			i (FRowId'="")&&(LogRowId'=FRowId) s Code="-1"
			i (FRowId="") s Code="-1"
			i Code="-1"{
				s Desc="代码已被医生站接口日志注册，日志代码："_LogCode_" 日志名称："_LogDesc
			}
		}
		;获取代码在方法注册中的ID
		s RowId=$o(^User.DocInterfaceMethodI("methodCode",FCode,0))
	}
	Q Code_"^"_Desc_"^"_RowId
}

/// Creater：李旭
/// Date：2022-04-09
/// Desc：保存注册方法时，自动注册日志代码
/// Input: LogInfo：日志信息串(^)
/// Output：-1/0^描述：失败/成功^描述
/// Debug：w ##class(web.DHCDocInterfaceLog).AutoLogRegistInfo("12^SOAP^Emergency.GetHisPatientInfo^危急重症一体化产品:获取患者信息^OPDoc^Y^第三方^")
ClassMethod AutoLogRegistInfo(LogInfo As %String, JsonInfo = "") As %String
{
	s $zt="AutoLogRegistInfo"
	s ^templx("AutoLogRegistInfo")=$lb(LogInfo,JsonInfo)
	s RowId=$p(LogInfo,"^",1)
	s LogType=$p(LogInfo,"^",2)
	s LogCode=$p(LogInfo,"^",3)
	s LogDesc=$p(LogInfo,"^",4)
	s ProductLine=$p(LogInfo,"^",5)
	s LogFlag=$p(LogInfo,"^",6)
	s ProductLinkGroup=$p(LogInfo,"^",7)
	s LogNote=$p(LogInfo,"^",8)
	
	i RowId'=""{
		;联动更新日志注册中的记录日志标识
		&SQL(UPDATE CF_DOC_Interface.LogRegist SET Log_Flag=:LogFlag WHERE %ID=:RowId)
	}else{
		;插入日志注册表
		k PLIST
		s PLIST(2)=LogType
		s PLIST(3)=LogCode
		s PLIST(4)=LogDesc
		s PLIST(5)=ProductLine
		s PLIST(6)="Y"
		s PLIST(7)=LogFlag
		s PLIST(8)=ProductLinkGroup
		&SQL(INSERT INTO CF_DOC_Interface.LogRegist VALUES :PLIST())
	}
	if SQLCODE {
		Q "-1^插入表失败SQLCode:"_SQLCODE_": "_$g(%msg)
	}
	s RowId=$p(%ROWID,$c(1))
	Q "0^"_RowId

AutoLogRegistInfo
	s $zt=""
	q "-1^"_$ze
}

/// Creater：李旭
/// Date：2022-04-09
/// Desc：保存接口日志注册方法
/// Input: LogInfo:日志信息Json串、JsonInfo:可扩展Json串(待用)
/// Output：-1/0^描述: 失败/成功^描述/表ID
/// Debug：w ##class(web.DHCDocInterfaceLog).SaveLogRegistInfo($lg(^templx("SaveLogRegistInfo"),1))
ClassMethod SaveLogRegistInfo(LogInfo As %String, JsonInfo = "") As %String
{
	s $zt="SaveLogRegistInfo"
	s ^templx("SaveLogRegistInfo")=$lb(LogInfo,JsonInfo)
	
	s LogObj={}.%FromJSON(LogInfo)
	s LogID=LogObj.LogID
	s LogType=LogObj.LogType
	s LogCode=LogObj.LogCode
	s LogDesc=LogObj.LogDesc
	s LogProductLine=LogObj.productLine
	s LogStatus=LogObj.LogStatus
	s LogFlag=LogObj.LogFlag
	s LogProductLinkGroup=LogObj.productLinkGroup
	s LogNote=LogObj.LogNote
	s LogDays=LogObj.LogDays
	s LogSuccessJson=LogObj.LogSuccessJson
	s LogJsonStr=LogInfo
	s LogSuccess=""
	i LogSuccessJson'="" {
		s LogSuccessObj={}.%FromJSON(LogSuccessJson)
		i $IsObject(LogSuccessObj.%Get(0)){
			s key=LogSuccessObj.%Get(0)."key"
			s value=LogSuccessObj.%Get(0)."value"
			s desc=LogSuccessObj.%Get(0)."desc"
			s FixedFlag=LogSuccessObj.%Get(0)."FixedFlag"
			if (FixedFlag=0){
				if (key'="")&&(value'=""){
					s LogSuccess="$p(ret,"_key_","_value_")="_desc
				}else{
					s LogSuccess="ret="_desc
				}
			}else{
				s LogSuccess=key_"="_value
			}
		}
	}
	s UniqueStr=..CheckInterfaceCode(LogID,LogCode,"Log")
	Q:(+UniqueStr'=0) $p(UniqueStr,"^",1,2)
	s MethodRowId=$p(UniqueStr,"^",3)
	
	;用对象方式保存，如果保存失败，则计数器不会回滚，所以此处使用SQL方式
	k PLIST
	s PLIST(2)=LogType
	s PLIST(3)=LogCode
	s PLIST(4)=LogDesc
	s PLIST(5)=LogProductLine
	s PLIST(6)=LogStatus
	s PLIST(7)=LogFlag
	s PLIST(8)=LogProductLinkGroup
	s PLIST(9)=LogNote
	s PLIST(12)=LogJsonStr
	s PLIST(14)=LogDays
	s PLIST(15)=LogSuccess
	s PLIST(16)=LogSuccessJson
	
	if LogID=""{
		&SQL(INSERT INTO CF_DOC_Interface.LogRegist VALUES :PLIST())
	}else{
		&SQL(UPDATE CF_DOC_Interface.LogRegist VALUES :PLIST() WHERE %ID=:LogID)
	}
	if SQLCODE {
		Q "-1^插入表失败SQLCode:"_SQLCODE_": "_$g(%msg)
	}
	s LogID=$p(%ROWID,$c(1))
	
	;自动同步方法注册界面中的日志标识
	i MethodRowId'=""{
		&SQL(UPDATE SQLUser.Doc_InterfaceMethod SET interface_LogFalg =:LogFlag WHERE %ID=:MethodRowId)
	}
	Q "0^"_LogID

SaveLogRegistInfo
	s $zt=""
	q "-1^"_$ze
}

/// Creater：李旭
/// Date：2022-04-09
/// Desc：删除接口日志表
/// Input: Input:日志ID^.
/// Output：-1/0^描述: 失败/成功^描述/表ID
/// Debug：w ##class(web.DHCDocInterfaceLog).DeleteLogRegistInfo(11)
ClassMethod DeleteLogRegistInfo(Input As %String) As %String
{
	s $zt="DeleteLogRegistInfo"
	s RowId=$p(Input,"^",1)
	
	&SQL(DELETE CF_DOC_Interface.LogRegist WHERE %ID=:RowId)
	if SQLCODE {
		Q "-1^删除失败SQLCode:"_SQLCODE_": "_$g(%msg)
	}
	Q "0^成功"
	
DeleteLogRegistInfo
	s $zt=""
	Q "-1^"_$ze
}

/// Creater：李旭
/// Date：2022-04-09
/// Desc：更新接口日志表,日志标识
/// Input: Input:日志ID^日志标识^
/// Output：-1/0^描述: 失败/成功^描述/表ID
/// Debug：w ##class(web.DHCDocInterfaceLog).UpdateLogRegistInfo(1)
ClassMethod UpdateLogRegistInfo(Input As %String) As %String
{
	s $zt="UpdateLogRegistInfo"
	s RowId=$p(Input,"^",1)
	s LogFlag=$p(Input,"^",2)
	s LogFlag=$case(LogFlag,"Y":"Y",:"N")
	Q:(+RowId=0) "-1^缺少表ID"

	k PLIST
	s PLIST(7)=LogFlag
	&SQL(UPDATE CF_DOC_Interface.LogRegist VALUES :PLIST() WHERE %ID=:RowId)
	if SQLCODE {
		Q "-1^更新表失败SQLCode:"_SQLCODE_": "_$g(%msg)
	}
	
	;自动同步方法注册界面中的日志标识
	s LogCode=$lg(^CF.DOC.Interface.LogRegistD(RowId),3)
	s MethodRowId=$o(^User.DocInterfaceMethodI("methodCode",LogCode,0))
	if (MethodRowId'=""){
		&SQL(UPDATE SQLUser.Doc_InterfaceMethod SET interface_LogFalg =:LogFlag WHERE %ID=:MethodRowId)
	}
	Q "0^修改成功"
	
UpdateLogRegistInfo
	s $zt=""
	Q "-1^"_$ze
}

Query FindLogRegist(Input) As websys.Query(ROWSPEC = "ID,LogType,LogCode,LogDesc,ProductLine,LogStatus,LogFlag,LogProductLinkGroup,LogNote,InsertDate,InsertTime") [ SqlProc ]
{
}

/// Creater：李旭
/// Date：2022-04-09
/// Desc：接口日志列表信息查询
/// Input: Input:日志类型^日志Code^日志描述^日志状态^日志标识^产品线.
/// Output：
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCDocInterfaceLog","FindLogRegist","")
ClassMethod FindLogRegistExecute(ByRef qHandle As %Binary, Input) As %Status
{
    s ^templx("FindLogRegist")=$lb(Input)
    s ind=1
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    
    s FLogType=$p(Input,"^",1)
    s FLogCode=$p(Input,"^",2)
    s FLogDesc=$p(Input,"^",3)
    s FStatues=$p(Input,"^",4)
    s FLogFlag=$p(Input,"^",5)
	s FProductLine=$p(Input,"^",6)
    
    s ID=0
    for {
		s ID=$o(^CF.DOC.Interface.LogRegistD(ID))
		Q:ID=""
		s LogInfo=$g(^CF.DOC.Interface.LogRegistD(ID))
		s LogType=$lg(LogInfo,2)
		s LogCode=$lg(LogInfo,3)
		s LogDesc=$lg(LogInfo,4)
		s ProductLine=$lg(LogInfo,5)
		s LogStatus=$lg(LogInfo,6)
		s LogFlag=$lg(LogInfo,7)
		s LogProductLinkGroup=$lg(LogInfo,8)
		s LogNote=$lg(LogInfo,9)
		s InsertDate=$lg(LogInfo,10)
		s InsertTime=$lg(LogInfo,11)
		s LogJsonStr=$lg(LogInfo,12)
		s:InsertDate'="" InsertDate=$zd(InsertDate,3)
		s:InsertTime'="" InsertTime=$zt(InsertTime,1)

		continue:(FProductLine'="")&&(("#"_FProductLine_"#")'[("#"_ProductLine_"#"))
		continue:(FLogType'="")&&(FLogType'="ALL")&&(FLogType'=LogType)
		continue:(FLogCode'="")&&(FLogCode'=LogCode)
		continue:(FLogDesc'="")&&(LogDesc'[FLogDesc)
		continue:(FStatues'="")&&(FStatues'="ALL")&&(FStatues'[LogStatus)
		continue:(FLogFlag'="")&&(FLogFlag'="ALL")&&(FLogFlag'=LogFlag)
		
		d FindLogRegistOut
	}
    
    q $$$OK

FindLogRegistOut    	
	s Data=$lb(ID,LogType,LogCode,LogDesc,ProductLine,LogStatus,LogFlag,LogProductLinkGroup,LogNote,InsertDate,InsertTime)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q ""
}

/// Creater：李旭
/// Date：2022-04-09
/// Desc：通过日志表ID获取日志表具体信息
/// Input: Input:日志ID^
/// Output：Json串
/// Debug：w ##class(web.DHCDocInterfaceLog).GetLogRegistInfo(1)
ClassMethod GetLogRegistInfo(Input) As %String
{
	s FRowID=$p(Input,"^",1)
	Q:FRowID="" "{}"
	Q:$g(^CF.DOC.Interface.LogRegistD(FRowID))="" "{}"

	s LogInfo=$g(^CF.DOC.Interface.LogRegistD(FRowID))
	s Obj={}
	s Obj.LogType=$lg(LogInfo,2)
	s Obj.LogCode=$lg(LogInfo,3)
	s Obj.LogDesc=$lg(LogInfo,4)
	s Obj.ProductLine=$lg(LogInfo,5)
	s Obj.LogStatus=$lg(LogInfo,6)
	s Obj.LogFlag=$lg(LogInfo,7)
	s Obj.LogProductLinkGroup=$lg(LogInfo,8)
	s Obj.LogNote=$lg(LogInfo,9)
	s Obj.LogDays=$lg(LogInfo,14)
	s Obj.LogSuccess=$lg(LogInfo,15)
	s Obj.LogSuccessJson=$lg(LogInfo,16)
	s Json=Obj.%ToJSON()
	q Json
}

/************************************* 医生站保存接口日志数据相关 Start ****************************************/
/// Creater：李旭
/// Date：2022-04-10
/// Desc：记录日志序号
/// Debug：w ##class(web.DHCDocInterfaceLog).SetLogSeqNo()
ClassMethod SetLogSeqNo() As %String
{
	s LogSeqNo=$I(^DOC.Interface.Log("LogSeqNo"))
	s ^||TempInterfaceLog("LogSeqNo")=LogSeqNo
	q 0
}

/// Creater：李旭
/// Date：2022-04-10
/// Desc: 获取日志序号
/// Debug：w ##class(web.DHCDocInterfaceLog).GetLogSeqNo()
ClassMethod GetLogSeqNo() As %String
{
	s LogSeqNo=$g(^||TempInterfaceLog("LogSeqNo"))
	i LogSeqNo="" s LogSeqNo="A"_$I(^DOC.Interface.Log("LogSeqNo"))
	q LogSeqNo
}

/// Creater：李旭
/// Date：2022-04-10
/// Desc: 把入参数据组织为流输出，参数之间以 $c(28) 拼接
/// Input: Params:入参数据
/// Output：流
ClassMethod GetParamsStream(Params...) As %Stream.GlobalCharacter
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	for len=1:1:$g(Params,0){
		s Input=$g(Params(len),"<NULL>")
		d:len>1 Stream.Write($c(28))
		if $IsObject(Input){
			d Input.Rewind()
			d Stream.CopyFrom(Input)
		}else{
			d Stream.Write(Input)
		}
	}	
	q Stream
}

/// Creater：李旭
/// Date：2022-04-10
/// Desc: 记录调用日志
/// Input: LogCode:日志代码
/// 	   JsonStr:扩展参数(Json格式{"NodeSeqNo":"节点序号","NodeDesc":"节点描述"})
/// 	   OutParams:返回参数(可为流)
/// 	   InParams:入参串信息
/// OutPut: -1/0^描述: 失败/成功^描述	   
/// Debug：w ##class(web.DHCDocInterfaceLog).SaveInterfaceLog("doc.ord.GetDisChargeNeedArcimStr","","测试2","asdfadsfnj","最后医为")
ClassMethod SaveInterfaceLog(LogCode, JsonStr, OutParams, InParams...) As %String
{
	s $zt="SaveInterfaceLog"
	s ^templx("SaveInterfaceLog")=$lb(LogCode,JsonStr,OutParams)
	
	s RowId=$o(^CF.DOC.Interface.LogRegistI("LogCode",LogCode,0))
	Q:RowId="" "-1^日志代码不存在："_LogCode
	s LogInfo=$g(^CF.DOC.Interface.LogRegistD(RowId))
	s LogType=$lg(LogInfo,2)
	s LogDesc=$lg(LogInfo,4)
	s LogFlag=$lg(LogInfo,7)
	Q:LogFlag'="Y" "-1^日志代码不需记录日志"
	
	;获取调用来源信息
	s IP=$ZUTIL(67,15,$JOB)
	s Computer=##class(%SYS.System).GetNodeName()
	s UserName=##class(%SYSTEM.Process).UserName()
	s SessionInfo=..GetSessionInfo()
    s StackInfo=..GetStackInfo()
    s InvokeInfo=$p($zu(41,$zu(41)-2),"^",1,4)
	s ComputerInfo="IP:"_IP_$c(28)_"Computer:"_Computer_$c(28)_"UserName:"_UserName
	s InvokeInfo="SessionInfo:"_SessionInfo_$c(28)_"InvokeInfo:"_InvokeInfo_$c(28)_"StackInfo:"_StackInfo
	
	s InStream=..GetParamsStream(InParams...)	;组织入参流
	i LogType="HIS" {
		;异步写法不能有流入参，此处通过读取字符串
		s InParams=InStream.Read(30000)
		if $IsObject(OutParams){
			s OutParams=OutParams.Read(30000)
		}
		job ..SaveInterfaceLogInfo(RowId,InParams,OutParams,JsonStr,InvokeInfo,ComputerInfo)::2
	}else{
		do ..SaveInterfaceLogInfo(RowId,InStream,OutParams,JsonStr,InvokeInfo,ComputerInfo)
	}
	q "0^成功"
	
SaveInterfaceLog
	q "-1^"_$ze
}

/// Creater：李旭
/// Date：2022-04-10
/// Desc: 保存调用日志信息(可异步调用，避免数据回滚，推荐调用SaveInterfaceLog)
/// Input:  LogRegID: 日志注册表ID
/// 		InStream: 入参串信息(入参之间$c(28)拼接，可为流)
/// 		OutStream：返回参数(可为流)
/// 	    JsonStr: 扩展参数(Json格式{"NodeSeqNo":"节点序号","NodeDesc":"节点描述"})
/// 	    InvokeInfo: 调用信息
/// 	    ComputerInfo: 电脑信息
/// OutPut: -1/0^描述: 失败/成功^描述	   
/// Debug：w ##class(web.DHCDocInterfaceLog).SaveInterfaceLog()
ClassMethod SaveInterfaceLogInfo(LogRegID, InStream, OutStream, JsonStr, InvokeInfo, ComputerInfo) As %String
{
	s $zt="SaveInterfaceLogInfo"
	s ^templx("SaveInterfaceLogInfo")=$lb(LogRegID, InStream, OutStream, JsonStr, InvokeInfo, ComputerInfo)
	
	s LogRegInfo=$g(^CF.DOC.Interface.LogRegistD(LogRegID))
	s LogType=$lg(LogRegInfo,2)
	s LogCode=$lg(LogRegInfo,3)
	s LogDesc=$lg(LogRegInfo,4)
	s LogSuccess=$lg(LogRegInfo,15)
	s LogSuccessJson=$lg(LogRegInfo,16)
	
	s InStream=..GetParamsStream(InStream)	
	s OutStream=..GetParamsStream(OutStream)
	s (NodeSeqNo,NodeDesc)=""
	i JsonStr'=""{
		s JsonObj={}.%FromJSON(JsonStr)
		s NodeSeqNo=JsonObj."NodeSeqNo"		;节点序号
		s NodeDesc=JsonObj."NodeDesc"		;节点描述
	}
	i NodeSeqNo="" s NodeSeqNo=..GetLogSeqNo()
	
	;判断返回值(只读取3000字节)
	s OverTime=0,Success="N"
	s OutStr=OutStream.Read(3000)
	d OutStream.Rewind()
	i OutStr["网络请求超时" s OverTime=1
	s Success=$p(..CheckSuccessStr(LogRegID,OutStr),"^",1)
	
	TS
	s Obj=##class(DOC.Interface.Log).%New()
	s Obj.LogCode=LogCode
	s Obj.LogDesc=LogDesc
	s Obj.NodeDesc=NodeDesc
	s Obj.NodeSeqno=NodeSeqNo
	d Obj.InParams.CopyFrom(InStream)
	d Obj.OutParams.CopyFrom(OutStream)
	s Obj.ComputerInfo=ComputerInfo
	s Obj.InvokeInfo=InvokeInfo
	s Obj.SuccStatus=Success
	s Obj.LogType=LogType
	
	s sc = Obj.%Save()
	If $$$ISERR(sc) {
		TRO
		s SQLCode=$System.Status.StatusToSQLCODE(sc) 
		Q "-1^插入表失败:"_SQLCode
	}
	TC
	s LogID=Obj.%Id()
	s Obj=""
	
	i OverTime=1{
		d ..AutoStopMethodStatus(LogID)
	}
	q "0^"_LogID

SaveInterfaceLogInfo
	s $zt=""
	q "-1^"_$ze
}

/// Creater：李旭
/// Date：2022-04-10
/// Desc:  根据日志记录判断是否自动停止接口注册
/// Input: LogID:接口日志ID
/// Output：-1/0^描述: 失败/成功^描述	  
/// w ##class(web.DHCDocInterfaceLog).AutoStopMethodStatus(50)
ClassMethod AutoStopMethodStatus(LogID)
{
	s ^templx("AutoStopMethodStatus")=$lb(LogID)
	s LogCode=$lg(^DOC.Interface.LogD(LogID),2)
	Q:LogCode="" "-1^无对应日志ID:"_LogID
	
	s CuDate=+$h				
	s (OverFlag,OverNum)=0
	s methodStatus="Y"
	s MethodRowID=$o(^User.DocInterfaceMethodI("methodCode",LogCode,""))
	i MethodRowID'=""{
		s MethodInfo=$g(^User.DocInterfaceMethodD(MethodRowID))
		s HAutoSwitch=$lg(MethodInfo,28)
		s UpdateDate=$lg(MethodInfo,39)
		s UpdateTime=$lg(MethodInfo,40)
		i HAutoSwitch="Y"{
			s HTimeOutNum=$lg(MethodInfo,26)
			i HTimeOutNum="" s HTimeOutNum=..#TimeOutNum
			i HTimeOutNum>0{
				;判断当日是否已超过允许次数
				s PreLogID=""
				for {
					s PreLogID=$o(^DOC.Interface.LogI("LogCode",CuDate,LogCode,PreLogID),-1)
					Q:(PreLogID="")||(OverFlag=1)
					s InsertTime=$lg(^DOC.Interface.LogD(PreLogID),10)
					s DiffSecond = $SYSTEM.SQL.DATEDIFF("ss", UpdateDate_","_UpdateTime, CuDate_","_InsertTime)	;相隔秒数
					Continue:(InsertTime<0)
					s OverNum=OverNum+1
					s:OverNum>HTimeOutNum OverFlag=1
				}
				s:OverFlag=1 methodStatus="N"
			}
		}
	}
	
	;自动停用接口方法运行状态
	i (methodStatus="N")&&(MethodRowID'=""){
		&SQL(UPDATE SQLUser.Doc_InterfaceMethod SET method_Status ="N", AutoStop="Y", StopLogID=:LogID WHERE %ID=:MethodRowID)
		if SQLCODE {
			Q "-1^插入表失败SQLCode:"_SQLCODE_": "_$g(%msg)
		}
	}
	Q "0^"_"成功"
}

/// Creater：李旭
/// Date：2022-04-10
/// Desc: 通过会话ID获取Session串
/// Output:用户ID^科室ID^安全组ID^医院ID^应用程序IP^登录IP地址^会话ID^在线状态^计算机名^计算机MAC
/// w ##class(web.DHCDocInterfaceLog).GetStackInfo()
ClassMethod GetSessionInfo() As %String
{
	s SessionInfo=""
	s CSPSessionID=##class(%SYSTEM.Process).CSPSessionID()
	i CSPSessionID'=""{
		s ind=$o(^%cspSession(CSPSessionID,""))
		i ind'="" {
			s SUserID=$g(^%cspSession(CSPSessionID,ind,"LOGON.USERID"))
			s SLocID=$g(^%cspSession(CSPSessionID,ind,"LOGON.CTLOCID"))
			s SGroupID=$g(^%cspSession(CSPSessionID,ind,"LOGON.GROUPID"))
			s SHospID=$g(^%cspSession(CSPSessionID,ind,"LOGON.HOSPID"))
			s SIP=$g(^%cspSession(CSPSessionID,ind,"REMOTE_ADDR"))
			s SSUSERLOGINID=$g(^%cspSession(CSPSessionID,ind,"LOGON.SSUSERLOGINID"))		;调用基础平台方法获取客户端信息
			i SSUSERLOGINID'="" s LogonInfo=$p($g(^SST("LOG",SSUSERLOGINID,"ADDR")),"^",1,5)
			s SessionInfo=SUserID_"^"_SLocID_"^"_SGroupID_"^"_SHospID_"^"_SIP_"^"_$g(LogonInfo)
		}
	}
	q SessionInfo
}

/// Creater：李旭
/// Date：2022-04-10
/// Desc:  获取调用堆栈信息
/// w ##class(web.DHCDocInterfaceLog).GetStackInfo()
ClassMethod GetStackInfo() As %String
{
	s StackInfo="",MCODE=""
	kill tmpStackAry
	
	s levelDeep=$STACK(-1)
	f loop=0:1:levelDeep { 
		s tp=$STACK(loop)
		continue:(tp="")||(tp="XECUTE")
		s cp=$STACK(loop,"PLACE")
		continue:(cp="")||(cp["%SYS")||(cp["%CSP")
		s stackCls=$p($p(cp,"^",2)," ",1)
		s stackMth=$p(cp,"+",1)
		i stackCls'="" {
			continue:$d(tmpStackAry(stackCls))
			s tmpStackAry(stackCls)=""
		}
		i StackInfo="" s StackInfo=$tr(cp,"^"," & ")
		e  s StackInfo=StackInfo_"!!"_$tr(cp,"^"," & ")
    }
    ;只获取600长度的堆栈信息
    s PlaceLen=$l(StackInfo)
    i PlaceLen>600 s StackInfo=$e(StackInfo,1,600)
	q StackInfo
}

/************************************* 医生站接口日志查询相关 Start ****************************************/
Query GetLogListData(StDateTime, EndDateTime, Input) As websys.Query(ROWSPEC = "ID,LogCode,LogDesc,NodeDesc,NodeSeqno,InsertDate,InsertTime,MethodID,MClassName,MMethodName,MMethodType,IP,SessionInfo,UserID,LocID,GroupID,HospID,UserDesc,LocDesc,GroupDesc,HospDesc,LogStatus,LogType") [ SqlProc ]
{
}

/// Creater：李旭
/// Date：2022-04-16
/// Desc：接口日志列表信息查询
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCDocInterfaceLog","GetLogListData","2022-04-16 18:46:51","2022-04-17 00:46:51","^^ALL^undefined")
ClassMethod GetLogListDataExecute(ByRef qHandle As %Binary, StDateTime, EndDateTime, Input) As %Status
{
    s ^templx("GetLogListData")=$lb(StDateTime,EndDateTime, Input)
    s ind=1
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s StDateTime=$zdth(StDateTime,..%DateFormat(),1)
    s EndDateTime=$zdth(EndDateTime,..%DateFormat(),1)
    s StDate=$p(StDateTime,",",1)
    s StTime=$p(StDateTime,",",2)
    s EndDate=$p(EndDateTime,",",1)
    s EndTime=$p(EndDateTime,",",2)
    Q:(StDate="")||(EndDate="") $$$OK

	s FLogCode=$p(Input,"^",1)
	s FLogDesc=$p(Input,"^",2)
	s FStatus=$p(Input,"^",3)
	s FLogContent=$p(Input,"^",4)
	s FLogType=$p(Input,"^",5)
	
	for Date=StDate:1:EndDate{
		s Time=0	;按照时间查询,第一天从开始时间查
		i (Date=StDate)&&(StTime>1) s Time=StTime-1	
		for	{
			s Time=$o(^DOC.Interface.LogI("InsertTime",Date,Time))
			Q:(Time="")
			Q:(EndTime'="")&&(Date=EndDate)&&(Time>EndTime)
			
			s ID=0
			i (FLogCode'=""){
				for {
					s ID=$o(^DOC.Interface.LogI("InsertDateTime",Date,Time,FLogCode,ID))
					Q:ID=""
					do GetLogListData
				}
			}else{
				for {
					s ID=$o(^DOC.Interface.LogI("InsertTime",Date,Time,ID))
					Q:ID=""
					do GetLogListData
				}
			}
		}
	}
	
	;倒叙输出
	s Sum=""
	for {
		s Sum=$o(^||DocLogInfo(Sum),-1)
		Q:Sum=""
		s Data=$g(^||DocLogInfo(Sum))
		s ^CacheTemp(repid,ind)=Data
		s ind=ind+1
	}
	k ^||DocLogInfo
	
    q $$$OK
    
GetLogListData
	s LogData=$g(^DOC.Interface.LogD(ID))
	Q:LogData=""
	;校验参数内容
	s ParamExist=0
	i FLogContent'="" d
	.s ParamExist=+(..CheckParamsExistFalg(ID,FLogContent))
	Q:ParamExist'=0
	s LogCode=$lg(LogData,2)
	s LogDesc=$lg(LogData,3)
	Q:(FLogDesc'="")&&(LogDesc'[FLogDesc)
	s NodeDesc=$lg(LogData,4)
	s NodeSeqno=$lg(LogData,5)
	s InIndex=$lg(LogData,6)
	s OutIndex=$lg(LogData,7)
	s LogStatus=$lg(LogData,8)
	Q:(FStatus'="ALL")&&(FStatus'=LogStatus)
	s InsertDate=$lg(LogData,9)
	s InsertTime=$lg(LogData,10)
	s InsertDate=..%ZD(InsertDate)
	s InsertTime=..%ZT(InsertTime)
	s ComputerInfo=$lg(LogData,11)
	s InvokeInfo=$lg(LogData,12)
	s LogType=$lg(LogData,15)
	Q:(FLogType'="ALL")&&(FLogType'=LogType)
	
	s (MClassName,MMethodName,MMethodType,SessionInfo,UserID,LocID,GroupID,HospID,UserDesc,LocDesc,GroupDesc,HospDesc)=""
	s MethodID=$o(^User.DocInterfaceMethodI("methodCode",LogCode,0))
	i MethodID'=""{
		;获取接口注册信息
		s MClassName=$lg(^User.DocInterfaceMethodD(MethodID),10)
		s MMethodName=$lg(^User.DocInterfaceMethodD(MethodID),11)
		s MMethodType=$lg(^User.DocInterfaceMethodD(MethodID),12)
	}
	s IP=$p($p(ComputerInfo,$c(28),1),"IP:",2)
	s SessionStr=$p($p(InvokeInfo,$c(28),1),"SessionInfo:",2)
	i SessionStr'=""{
		s UserID=$p(SessionStr,"^",1)
		s LocID=$p(SessionStr,"^",2)
		s GroupID=$p(SessionStr,"^",3)
		s HospID=$p(SessionStr,"^",4)
		s:UserID'="" UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)
		s:LocID'="" LocDesc=$p($g(^CTLOC(LocID)),"^",2)
		s:GroupID'="" GroupDesc=$p($g(^SSU("SSGRP",GroupID)),"^",1)
		s:HospID'="" HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
		s LogIP=$p(SessionStr,"^",6)
		s LogMac=$p(SessionStr,"^",10)
		s:LogIP'="" IP=LogIP
		s SessionInfo=UserDesc_"、"_LocDesc_"、"_GroupDesc_"、"_HospDesc
	}
	s Data=$lb(ID,LogCode,LogDesc,NodeDesc,NodeSeqno,InsertDate,InsertTime,MethodID,MClassName,MMethodName,MMethodType,IP,SessionInfo,UserID,LocID,GroupID,HospID,UserDesc,LocDesc,GroupDesc,HospDesc,LogStatus,LogType)   
	s Count=$I(^||DocLogInfo)
	s ^||DocLogInfo(Count)=Data
	q ""
}

/// Creater：李旭
/// Date：2022-04-16
/// Desc：校验日志内容是否存在入参及出参串中
/// Input: RowID:日志表ID、FLogContent:需匹配内容
/// Output: -1/0^描述: 失败/成功^描述	   
/// Debug：w ##class(web.DHCDocInterfaceLog).CheckParamsExistFalg(21,"云南省临沧市临翔区凤翔街道")
ClassMethod CheckParamsExistFalg(RowID, FLogContent) As %String
{
	Q:(FLogContent="") "0^匹配成功"
	s Obj=##class(DOC.Interface.Log).%OpenId(RowID,0)
 	if '$IsObject(Obj) Q "-1^不存在对象"
	
	s ExistFlag="-1"
	s InParams=Obj.InParams
	s OutParams=Obj.OutParams
	s Obj=""
	
	;此处会存在一个问题，如搜索的内容恰巧被分成两次读取，暂没处理方法
	While ('InParams.AtEnd) {
		s tmpStr=InParams.Read(30000) 
		continue:tmpStr=""
		i tmpStr[FLogContent s ExistFlag=0
		Q:ExistFlag=0
	}
	Q:ExistFlag=0 "0^匹配成功"
	
	While ('OutParams.AtEnd) {
		s tmpStr=OutParams.Read(30000) 
		Continue:tmpStr=""
		i tmpStr[FLogContent s ExistFlag=0
		Q:ExistFlag=0
	}
	Q:ExistFlag=0 "0^匹配成功"
	Q "-1^没找到匹配内容"
}

/// Creater：李旭
/// Date：2022-04-16
/// Desc：获取日志入参及出参信息(用于界面查询详细信息)
/// Input: RowID:日志表ID、InStr:入参简略信息、OutStr:出参简略信息
/// Debug：w ##class(web.DHCDocInterfaceLog).GetLogListDetail(1)
ClassMethod GetLogListDetail(RowID, ByRef InStr = "", ByRef OutStr = "") As %Stream.GlobalCharacter
{
	s Obj=##class(DOC.Interface.Log).%OpenId(RowID,0)
 	if '$IsObject(Obj) Q ""
 	s LogCode=Obj.LogCode
 	s InParams=Obj.InParams
 	s OutParams=Obj.OutParams
 	s InvokeInfo=Obj.InvokeInfo
 	s (Obj,MethodInfo,MethodType,ClassName,MethodName)=""
 	
 	s MethodID=$o(^User.DocInterfaceMethodI("methodCode",LogCode,0))
	i MethodID'=""{
		;获取接口注册信息
		s ClassName=$lg(^User.DocInterfaceMethodD(MethodID),10)
		s MethodName=$lg(^User.DocInterfaceMethodD(MethodID),11)
		s MethodType=$lg(^User.DocInterfaceMethodD(MethodID),12)
		s MethodInfo=MethodType_": "_ClassName_".cls --> "_MethodName
	}
	
	;因为入参或出参中可能有特殊json格式，所以以$c(29)拼接直接输出
	s Detail=MethodID_$c(29)_MethodInfo_$c(29)_InvokeInfo
	w Detail_$c(29)
	d InParams.OutputToDevice() 	;入参信息串
	w $c(29)
	d OutParams.OutputToDevice() 	;出参信息串
	w $c(29)
	w MethodType_$c(29)_ClassName_$c(29)_MethodName
	Q ""
	
	w "{""MethodID"":"""_MethodID_""",""MethodInfo"":"""_MethodInfo
	w """,""InParams"":"""
	d InParams.OutputToDevice() 
	w """,""OutParams"":"""
	d OutParams.OutputToDevice() 
	w """,""InvokeInfo"":"""_InvokeInfo
	w """}"
	Q ""
}

/// Creater：李旭
/// Date：2022-04-23
/// Desc：通过日志返回信息，校验接口是否成功
/// Input: LogRegID：注册日志ID、OutStr：返回信息串
/// Output: "Y/N^":"成功/失败^"
/// w ##class(web.DHCDocInterfaceLog).CheckSuccessStr(20,1)
ClassMethod CheckSuccessStr(LogRegID, OutStr)
{
	s $zt="CheckSuccessStr"
	s ^templx("CheckSuccessStr")=LogRegID_","_OutStr

	s LogRegInfo=$g(^CF.DOC.Interface.LogRegistD(LogRegID))
	s LogSuccess=$lg(LogRegInfo,15)
	s LogSuccessJson=$lg(LogRegInfo,16)
	Q:(LogSuccess="")||(LogSuccessJson="") "N^"
	
	s FixedFlag=0, Sucess="N"
	s Obj={}.%FromJSON(LogSuccessJson)
	i $IsObject(Obj.%Get(0)){
		s FixedFlag=Obj.%Get(0)."FixedFlag"
	}
	if (FixedFlag=0){
		;分隔符判断
		s @"ret"=OutStr
		s Expression="s rtn=("_LogSuccess_")"
		x Expression
		s rtn=@"rtn"
		i rtn=1 s Sucess="Y"
	}else{
		;固定值判断
		s Code=$p(LogSuccess,"=",1)
		s Val=$p(LogSuccess,"=",2)
		s FirstStr=$e(OutStr,1,1)
		i FirstStr="<" {
			;当成XML处理
			s CheckVal=$p($p(OutStr,"</"_Code_">",1),"<"_Code_">",2)
			i CheckVal=Val s Sucess="Y"
		}else{
			;当成JSON串处理
			i OutStr[(""""_Code_""":"""_Val_"""") s Sucess="Y"
		}	
	}
	Q Sucess_"^"
	
CheckSuccessStr
	q "N^"
}

/// Creater：李旭
/// Date：2022-04-23
/// Desc： 清除日志记录数据,默认只保留7天内数据(用于挂任务)
/// w ##class(web.DHCDocInterfaceLog).ClearLogInfo()
ClassMethod ClearLogInfo()
{
	s CuDate=+$h, LogID=0
	for {
		s LogID=$o(^DOC.Interface.LogD(LogID))
		Q:LogID=""
		
		s LogCode=$lg(^DOC.Interface.LogD(LogID),2)
		s InsertDate=$lg(^DOC.Interface.LogD(LogID),9)
		s LogDays=""
		i LogCode'="" {
			s LogRegID=$o(^CF.DOC.Interface.LogRegistI("LogCode",LogCode,0))
			i LogRegID'="" s LogDays=$lg(^CF.DOC.Interface.LogRegistD(LogRegID),14)
		}
		s:(+LogDays=0) LogDays=..#LogKeepDay
		Continue:(InsertDate+LogDays)>CuDate
		
		;进行删除数据
		&SQL(DELETE DOC_Interface.Log WHERE %ID=:LogID)
	}
	q 0
}

}
