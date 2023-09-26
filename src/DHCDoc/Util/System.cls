/// creator:lixu
/// date:2021-05-07
/// desc:常用系统相关方法
Class DHCDoc.Util.System Extends Encryption
{

/****************************************************** 系统类相关方法 **************************************************/
/// Desc: 获取时间戳
/// time: 本地日期时间(机器码)、integer:(0/1)是否精确毫秒
/// w ##class(DHCDoc.Util.System).GetTimeStamp()
ClassMethod GetTimeStamp(time = "", integer = "0") As %Integer
{
	if time=""{
		;默认采用UTC时间
		s time=$ZTS
	}else{
		;本地时间转为UTC时间
		s time=$SYSTEM.Util.LocalWithZTIMEZONEtoUTC(time)
	}
	i integer'=0{
		s time=$p(time,".",1)
	}
	q ((($piece(time,",")-47117)*86400+$piece(time,",",2))*1000)\1
}

/// Desc: 解析时间戳
/// w ##class(DHCDoc.Util.System).ParseTimeStamp()
ClassMethod ParseTimeStamp(Timestamp As %Float)
{
	q:+Timestamp=0 ""
	s Timestamp=Timestamp/1000
	s UTCDate=Timestamp\86400+47117
	s UTCTime=Timestamp#86400
	;UTC时间转为本地
	s LocalStamp=$SYSTEM.Util.UTCtoLocalWithZTIMEZONE(UTCDate_","_UTCTime)
	q LocalStamp
}

/// Desc: 设置文件只读(需先导出要设置的文件，以备后面需修改使用)
/// w ##class(DHCDoc.Util.System).SetDeployed("web.Test1")
ClassMethod SetDeployed(Class As %String) As %String
{
	if Class'="" {
		d $system.OBJ.MakeClassDeployed(Class)
	}
	q ""
}

/// Desc: 判断类是否存在
/// w ##class(DHCDoc.Util.System).IsValidClassName("DHCDoc.Util.ListData")
ClassMethod IsValidClassName(ClassName) As %Boolean
{
	q:($d(^oddCOM(ClassName))) $$$YES
	q $$$NO
}

/// Desc: 判断类是否存在
/// w ##class(DHCDoc.Util.System).IsValidClassName1("DHCDoc.Util.ListData")
ClassMethod IsValidClassName1(ClassName As %String) As %Boolean
{
    if '##class(%Dictionary.CompiledClass).%ExistsId(ClassName) {
        q $$$NO
    }
    q $$$OK
}

/// Desc: 判断类方法是否存在
/// w ##class(DHCDoc.Util.System).IsValidMethodName("DHCDoc.Util.ListData","%Set")
ClassMethod IsValidMethodName(ClassName, MethodName) As %Boolean
{
	q:$d(^oddCOM(ClassName,"m",MethodName)) $$$YES
	q $$$NO
}

/// Desc: 判断类中是否存在某个属性
/// w ##class(DHCDoc.Util.System).IsValidProperty("DHCDoc.Util.ListData","%xmlParentNode")
ClassMethod IsValidProperty(ClassName, PropertyName) As %Boolean
{
	q:($d(^oddCOM(ClassName,"a",PropertyName))) $$$YES
	q:(##class(%Dictionary.PropertyDefinition).%ExistsId(ClassName_"||"_PropertyName)) $$$YES 
	q $$$NO
}

/// Desc: 获取客户端IP
ClassMethod GetOutLocalIP() As %String
{
	q ##class(%SYSTEM.Process).ClientIPAddress()
}

/// Desc: 获取服务器IP
ClassMethod GetInLocalIP() As %String
{
	q $p($zu(54,13,$zu(54,0)),",",1 )
}

/// Desc: 获取License信息
ClassMethod ShowLicenseInfo() As %Boolean
{
	d ##class(%SYSTEM.License).ShowCounts()
}

/****************************************************** 进程类相关方法 **************************************************/
/// Desc: 停止当前进程所有break断点
/// w ##class(DHCDoc.Util.System).StopBreak()
ClassMethod StopBreak() As %String
{
	d ##class(%SYSTEM.Process).BreakMode(0)
	q ""
}

/// Desc: 开启当前进程所有break断点
/// w ##class(DHCDoc.Util.System).StopBreak()
ClassMethod StartBreak() As %String
{
	d ##class(%SYSTEM.Process).BreakMode(1)
	q ""
}

/// Desc: 设置当前进程的session数据
/// input：ExptStr:用户ID^安全组ID^科室ID^医院ID(可扩展)^病区ID^默认语言^登录SessionID^^
/// 与DHCDoc.Util.RegisteredObject->%SessionStr保持一致
/// d ##class(DHCDoc.Util.System).SetSession("1^95^29^2")
ClassMethod SetSession(ExptStr As %String) As %String
{
	s %session=##class(%CSP.Session).%New("dhcdocreset")
	d %session.Unlock()
	s UserID=$p(ExptStr,"^",1)
	s GroupID=$p(ExptStr,"^",2)
	s LocID=$p(ExptStr,"^",3)
	s HospID=$p(ExptStr,"^",4)
	s WARDID=$p(ExptStr,"^",5)
	s LANGID=$p(ExptStr,"^",6)
	s SSUSERLOGINID=$p(ExptStr,"^",7)
	s %session.Data("LOGON.USERID")=UserID
	s %session.Data("LOGON.CTLOCID")=LocID
	s %session.Data("LOGON.GROUPID")=GroupID
	s %session.Data("LOGON.HOSPID")=HospID
	s %session.Data("LOGON.WARDID")=WARDID
    s %session.Data("LOGON.LANGID")=LANGID
    s %session.Data("LOGON.SSUSERLOGINID")=SSUSERLOGINID
	
	i UserID'="" d
	.s UserCode=$p(^SSU("SSUSR",UserID),"^",1)
	.s UserDesc=$p(^SSU("SSUSR",UserID),"^",2)
	.s %session.Data("LOGON.USERCODE")=UserCode
	.s %session.Data("LOGON.USERNAME")=UserDesc
	i LocID'="" d
	.s LocCode=$p(^CTLOC(LocID),"^",1)
	.s LocDesc=$p(^CTLOC(LocID),"^",2)
	.s %session.Data("LOGON.CTLOCCODE")=LocCode
	.s %session.Data("LOGON.CTLOCDESC")=LocDesc
	i GroupID'="" d
	.s GroupCode=$p(^SSU("SSGRP",GroupID),"^",1)
	.s GroupDesc=$p(^SSU("SSGRP",GroupID),"^",2)
	.s %session.Data("LOGON.GROUPCODE")=GroupCode
	.s %session.Data("LOGON.GROUPDESC")=GroupDesc
	i HospID'="" d
	.s HospCode=$p(^CT("HOSP",HospID),"^",1)
	.s HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s %session.Data("LOGON.HOSPCODE")=HospCode
	.s %session.Data("LOGON.HOSPDESC")=HospDesc
	q ""
}

/// Desc: 清除当前进程的session数据
/// d ##class(DHCDoc.Util.System).DeleteSession()
ClassMethod DeleteSession(SessionId = "") As %String
{
	s:SessionId="" SessionId="dhcdocreset"		;兼容token模式
	d ##class(%CSP.Session).%DeleteId(SessionId)
	k %session
	q ""
}

/// Desc: 获取会话ID
/// d ##class(DHCDoc.Util.System).GetCSPSessionID()
ClassMethod GetCSPSessionID() As %String
{
	s EnableToken=0
	s ExitMethod=..IsValidMethodName("websys.StandardTypeItem","GetIdFromCodeOrDescription")
	if ExitMethod{
		s EnableToken=##class(websys.StandardTypeItem).GetIdFromCodeOrDescription("websys","EnableToken")	
	}
	if EnableToken{
		;启用了Token管理
		s CSPSessionID=$g(%session.SessionId)
	}else{
		s CSPSessionID=##class(%SYSTEM.Process).CSPSessionID()
	}
	Q CSPSessionID
}

/// Desc: 拷贝会话ID的session数据
/// d ##class(DHCDoc.Util.System).GetSessionByCSPSessionID("gbGKcuIA4I")
ClassMethod GetSessionByCSPSessionID(SessionId) As %String
{
	if SessionId'="" {
		s ind=$o(^%cspSession(SessionId,""))
		if ind'="" {
			s %session=##class(%CSP.Session).%New("dhcdocreset")
			d %session.Unlock()
			m %session.Data=^%cspSession(SessionId,ind)
			s %session.Data("LOGON.GROUPMENUS")=""		;安全组菜单此处不展示
		}else{
			;token模式 需改为MWToken值获取 ^BSP.SYS.Token 
			if $d(^BSP.SYS.Token(SessionId)){
				;s %session=##class(%CSP.Session).%New("dhcdocreset")
				s %session=##class(%CSP.Session).%New(SessionId)		;会话ID		
				d %session.Unlock()
				m %session.Data=^BSP.SYS.Token(SessionId,0)
				s %session.Data("LOGON.GROUPMENUS")=""		;安全组菜单此处不展示
			}
		}
	}
	q ""
}

/// Desc: 展示当前进程的Session数据
/// d ##class(DHCDoc.Util.System).DisplaySession()
ClassMethod DisplaySession() As %String
{
	if $d(%session),$d(%session.Data) {
		m Data=%session.Data	
		zw Data
	}
	q ""
}

/// Desc: 设置当前进程的request数据
/// s data("Name",1)="李华"
/// s data("Sex",1)="男"
/// d ##class(DHCDoc.Util.System).SetRequest("",.data)
/// d ##class(DHCDoc.Util.System).SetRequest("EpisodeID=1&PatientID=1&Name=李华&Sex=男")
ClassMethod SetRequest(keyValueStr, ByRef Data = "") As %String
{
	s %request=##class(%CSP.Request).%New()
	f len=1:1:$l(keyValueStr,"&"){
		s item=$p(keyValueStr,"&",len)
		s itemKey=$p(item,"=",1)	
		s itemValue=$p(item,"=",2)
		continue:itemKey=""
		d %request.Set(itemKey,itemValue)
	}
	i $d(Data){
		m %request.Data=Data
	}
	q ""
}

/// Desc: 清除当前进程的request数据
/// d ##class(DHCDoc.Util.System).DeleteRequest()
ClassMethod DeleteRequest() As %String
{
	k %request
	q ""
}

/// Desc: 展示当前进程的request数据
/// d ##class(DHCDoc.Util.System).DisplayRequest()
ClassMethod DisplayRequest() As %String
{
	i $d(%request)&&($d(%request.Data)){
		m data=%request.Data
		zw data
	}
	q ""
}

/// Desc: 设置当前进程的日期，可用于特殊调试(程序中取系统日期)
/// Note: 只是修改了日期，时间还是当前时间
/// Input: Date 空或0: 设置为当前日期，其他：需要调整的日期
/// d ##class(DHCDoc.Util.System).SetProcessDate("2022-02-14")
ClassMethod SetProcessDate(Date = "") As %String
{
	s Date=$SYSTEM.SQL.DATE(Date)
	s Date=$zabs(+Date)		;取绝对值
	d ##class(%SYSTEM.Process).FixedDate(Date)
	q ""
}

/// Desc: 获取进程用户信息
/// d ##class(DHCDoc.Util.System).GetProcessInfo()
ClassMethod GetProcessInfo()
{
	;计算机名
	s Computer=##class(%SYS.System).GetNodeName()	
	;用户名
	s UserName=##class(%SYSTEM.Process).UserName()	
	;当前例程进行的最后一个 DO 或用户定义调用的调用例程名
	s CallingRoutine=##class(%SYSTEM.Process).CallingRoutine()	
	;发起链接的IP
	s ClientIP=##class(%SYSTEM.Process).ClientIPAddress()	
	;CSP会话ID
	s CSPSessionID=##class(%SYSTEM.Process).CSPSessionID()	
	w 
	q ""
}

/// Desc: 获取方法调用来源信息(需要有陷阱，如果有new，$zu(41)需要放在new之前)
/// Note: 如果方法里面有SQL操作语句，会记录不到调用参数
/// w ##class(DHCDoc.Util.System).GetStackSouce(1)
ClassMethod GetStackSouce(Souce) As %String
{
	s $zt="GetStackSouceErr"
	s n = $zu(41)
	;n (Souce,n)
	
	s CurNamespace=$zutil(5)
	s SouceInfo = $zu(41,n-2)		
	s ClassMethod = $p(SouceInfo,"^",2,3)
	s Parameter = $p(SouceInfo,"^",5)
	
	q ClassMethod_" & "_Parameter_" & "_CurNamespace
	
GetStackSouceErr
	q "GetStackSouceErr："_$ze
}

/// Desc: 获取调用堆栈信息
/// w ##class(DHCDoc.Util.System).GetStackInfo()
ClassMethod GetStackInfo(Info) As %String
{
	;add by gry V8.4
	s PLACE="",MCODE=""
	kill tmpStackAry
	
	s levelDeep=$STACK(-1)
	f loop=0:1:levelDeep { 
		s tp=$STACK(loop)
		continue:(tp="")||(tp="XECUTE")
		s cp=$STACK(loop,"PLACE")
		continue:(cp="")||(cp["%SYS")||(cp["%CSP")
		s stackCls=$p($p(cp,"^",2)," ",1)
		s stackMth=$p(cp,"+",1)
		;continue:$p($p(cp,"^",2)," ",1)=$zn
		;s cs=$STACK(loop,"MCODE")
		i stackCls'="" {
			continue:$d(tmpStackAry(stackCls))
			s tmpStackAry(stackCls)=""
		}
		i PLACE="" s PLACE=$tr(cp,"^"," & ")
		e  s PLACE=PLACE_"!!"_$tr(cp,"^"," & ")
    }
    ;只获取600长度的堆栈信息
    s PlaceLen=$l(PLACE)
    i PlaceLen>600 s PLACE=$e(PLACE,1,600)
	q PLACE
}

/*********************************** 数据加解密相关方法: 已迁移至DHCDoc.Util.Encryption.cls **************************************************/
/// Desc：解密CSP加密的方法密文
/// Input: CipherText：加密后的密文
/// Debug：w ##class(DHCDoc.Util.System).MethodDecrypt("IqgCJBlVJt5CnGbqT2x53vyQ5aWVumvnG3iZLuBfrz225wUBRWP1CqipIrr6im3v")
ClassMethod MethodDecrypt(CipherText) As %String
{
	Q ##class(DHCDoc.Util.Encryption).MethodDecrypt(CipherText)
}

/****************************************************** 格式化、字符串、日期等相关方法 **************************************************/
/// Desc: 自动左补零(不够长度的左补零，否则原值返回)
/// w ##class(DHCDoc.Util.System).LeftAutoZero("5",10)
ClassMethod LeftAutoZero(Num As %String, Length As %String = "10")
{
	q:(+Length=0) Num
	s Num=$tr($j(Num,Length)," ",0)
	q Num
}

/// Desc: 格式化数字
/// Input: number:数字、flag:格式值("U/D/I":向上/向下/取整)、decimal:保留小数位数
/// w ##class(DHCDoc.Util.System).FormatNumber(".6")
ClassMethod FormatNumber(number, flag = "", decimal = "")
{
	s retnum=number
	s flag=$zcvt(flag,"U")
	i (flag="U")||(flag="UP") {
		s retnum=$SYSTEM.SQL.CEILING(retnum)		;向上取整
	}
	i (flag="D")||(flag="DOWN") {
		s retnum=$SYSTEM.SQL.FLOOR(retnum)			;向下取整
	}
	i (flag="I")||(flag="INTEGER"){
		s retnum=+$p(retnum,".")
	}
	i (flag="")||(decimal'=""){
		i (+decimal=0){
			s retnum=$fn(retnum,"N")
		}else{
			s retnum=$fn(retnum,"N",decimal)
		}
	}
	q retnum
}

/// Desc: 判断是否是整数
/// w ##class(DHCDoc.Util.System).IsInteger(".6")
ClassMethod IsInteger(str As %String) As %Boolean
{
	q:($number(str, "I") = "") $$$NO
	q $$$YES
}

/// Desc: 转换为钱格式
/// w ##class(DHCDoc.Util.System).ConvertMoneyFomat("99999.6",2)
ClassMethod ConvertMoneyFomat(num, zeroNum)
{
	q $fn(num, ",", zeroNum)
}

/// Desc: 数字转大写人民币
/// w ##class(DHCDoc.Util.System).RMBConvert("1000000.06")
ClassMethod RMBConvert(num As %Integer) As %Integer
{
	Q ##class(web.DHCOPINVCons).RMBConvert(num)
}

/// Desc: 日期类相关
/// w ##class(DHCDoc.Util.System).GetDateInfo()
ClassMethod GetDateInfo()
{
	;当前日期所属月的最后一天
	s LastMeth=##class(%SYSTEM.SQL).LASTDAY(+$h)
	;当前日期所属周数
	s WEEK=##class(%SYSTEM.SQL).WEEK(+$h)
	;当前日期所属月
	s MONTH=##class(%SYSTEM.SQL).MONTH(+$h)
	;当前日期所属年
	s YEAR=##class(%SYSTEM.SQL).YEAR(+$h)
	
	;判断日期时间差
	s DateDiff=$SYSTEM.SQL.DATEDIFF("hh", $zdt($zts,3), $zdt($h,3))	;相差小时数
	s DateDiff=$SYSTEM.SQL.DATEDIFF("ss", $h-1, $zdt($h,3))			;相差秒数
	
	;调整日期
	s PreMonthDate=$SYSTEM.SQL.DATEADD("mm",-1,$h)	;上一个月的今天
	s LastMonthDate=$SYSTEM.SQL.DATEADD("mm",1,$h)	;下一个月的今天
	q ""
}

/// Desc: 判断两个日期时间的差值(默认小时)
/// input：DateF/DateT: "1990-04-25 21:00:00"
/// 	   HourFlag("D/H/M/S":天/小时/分钟/秒)：返回差值单位,默认小时
/// 	   Integer("U/D/I":向上/向下/取整)：返回整数标识
/// 	   Decimal:保留小数位数(默认2位小数)
/// w ##class(DHCDoc.Util.System).GetDiffSecond("2021-06-01 21:00:00",$zdt($h,3))
/// w ##class(DHCDoc.Util.System).GetDiffSecond("2021-06-01 21:00:00","65897,83966")
ClassMethod GetDiffSecond(DateF As %DateTime, DateT As %DateTime, HourFlag = "H", Integer = "", Decimal = "2") As %Float
{
	s HourFlag=$zcvt(HourFlag,"U")
	s DiffNum=0
	s DiffSecond = $SYSTEM.SQL.DATEDIFF("ss", DateF, DateT)			;相隔秒数
	s Dividend=60*60							;小时
	i HourFlag="D" s Dividend=24*Dividend 		;天
	e  i HourFlag="M" s Dividend=60				;分钟	
	e  i HourFlag="S" s Dividend=1				;秒
	s DiffNum=DiffSecond/Dividend
	s DiffNum=..FormatNumber(DiffNum,Integer,Decimal)
	q DiffNum
}

/// Desc: 获取两个日期之间的年月日数(可用于知道出生日期取年月日数据)
/// Input: DateF:开始日期、DateT:截至日期
/// Output: 年^月^日
/// w ##class(DHCDoc.Util.System).GetDiffYearMonth(65013,+$h)
ClassMethod GetDiffYearMonth(DateF As %String, DateT As %String)
{
	s DiffInfo=$$CalAge^at182(DateF,DateT,"","","")
	s DiffYear=$p(DiffInfo,"|",12)
	s DiffMonth=$p(DiffInfo,"|",13)
	s DiffDays=$p(DiffInfo,"|",14)
	
	Q DiffYear_"^"_DiffMonth_"^"_DiffDays
}

/// Desc: 判断是否是中文
/// w ##class(DHCDoc.Util.System).IsChinese("｛{")
ClassMethod IsChinese(Char)
{
	Quit:(($a(Char)>=19968) && ($a(Char)<=40869)) 1
	Quit:("￥…｛｝。，？”“《》：！——-、；（）"[Char) 1
	Quit 0
}

/// Desc: 获取字符串中的汉字内容
/// w ##class(DHCDoc.Util.System).GetChinese("hello world 欢迎世界 123")
ClassMethod GetChinese(Str As %String) As %String
{
	s str = $zstrip(Str, "*ANP")
	q str
}

/// Desc: 获取字符串中的数字内容
/// w ##class(DHCDoc.Util.System).GetNumber("hello world 欢迎世界 123")
ClassMethod GetNumber(Str As %String) As %String
{
	s str = $zstrip(Str, "*E'N")
	q str
}

/// Desc: 去除字符串首尾空格，中间保留
/// w ##class(DHCDoc.Util.System).Trim(" a b c ")
ClassMethod Trim(Str As %String, All = 0) As %String [ Language = basic ]
{
	if All=1 Then
		return Replace(Str," ","")
	End if
	return Trim(Str)
}

/// Desc: 去除字符串中的空格(默认只去除首尾空格)
/// Input: Str:字符串、All:1:去除全部空格
/// w ##class(DHCDoc.Util.System).Trim1(" a b c ")
ClassMethod Trim1(Str As %String, All = 0) As %String
{
	if All=1{
		return $zstrip(Str, "*", " ")	
	}
	return $zstrip(Str, "<>", " ")
}

/// Desc: 高效重复字符串
/// w ##class(DHCDoc.Util.System).Repeat("ab",3)
ClassMethod Repeat(target As %String, num As %Integer) As %String
{
	s str = ""
  	s $p(str, target, num) = target
  	Q str
}

/// Desc: 汉字转拼音大写
/// w ##class(DHCDoc.Util.System).ToChineseSpell("yyy--东华软件医疗事业部")
ClassMethod ToChineseSpell(Str)
{
	Q ##class(ext.util.String).ToChineseSpell(Str)
}

/// Desc: Json字符串转义
/// w ##class(DHCDoc.Util.System).EvalJSON("yy'y\东{华软件医疗事业部")
ClassMethod EvalJSON(Str)
{
	;Q $zcvt(Str,"O","JSON")
	Q ##class(ext.util.String).EvalJSONNew(Str)
}

/// Desc: 将多个数组组合为一个新数组
/// s a={"a":1},b={"b":2}
/// d ##class(DHCDoc.Util.System).ExtendObjects(a,b)
/// w a.%ToJSON()
ClassMethod ExtendObjects(ByRef target As %DynamicObject, pArgs...) As %DynamicObject
{
    if $d(target),$IsObject(target),(target.%IsA("%DynamicObject")){
	    
	}else{
		s target=##class(%DynamicObject).%New()	
	}
    for i=1:1:pArgs {
        set arg = pArgs(i)
        if ($IsObject(arg) && arg.%IsA("%DynamicObject")) {
            set iter = arg.%GetIterator()
            while iter.%GetNext(.key, .value) {
                do target.%Set(key,value,arg.%GetTypeOf(key))
            }
        }
    }
    q target
}

/// Desc: 将列表字段或字段串和值转为动态对象
/// 当数据量大时(上千条)动态对象效率不及DHCDoc.Util.ArrayData对象的效率
/// s Obj=##class(DHCDoc.Util.ArrayData).%New()
/// s Value=$lb(1,2,3)
/// s Key=$lb("First","Second","Thrid")
/// d ##class(DHCDoc.Util.Common).SetObjByListStr(.Obj,Value,Key)
ClassMethod SetObjByListStr(ByRef Obj, ValueStr, KeyStr, ListFlag = "Y", VDelimiter = "^", KDelimiter = "^")
{
	i ListFlag="Y"{
		f len=1:1:$ll(KeyStr) {
			s key=$lg(KeyStr,len)
			q:key=""
			s val=$lg(ValueStr,len)
			d Obj.%Set(key,val)
		}
	}else{
		f len=1:1:$l(KeyStr,KDelimiter) {
			s key=$p(KeyStr,KDelimiter,len)
			q:key=""
			s val=$p(ValueStr,VDelimiter,len)	
			d Obj.%Set(key,val)
		}
	}
	q ""
}

/****************************************************** 工程相关方法 **************************************************/
/// Desc: 查询所有项目工程
/// w ##class(DHCDoc.Util.System).FindPrj()
ClassMethod FindPrj() As %String
{
	;查询所有Project
	Set rset=##class(%ResultSet).%New("%Studio.Project:ProjectList")
	do rset.Execute()
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s ID=rset.Data("ID")
		s Name=rset.Data("Name")
		s LastModified=rset.Data("LastModified")
		w ID_"："_Name_"："_LastModified ,!
	}
	q ""
}

/// Desc: 查询项目工程下的文件
/// w ##class(DHCDoc.Util.System).FindPrjItem("DHCDocLXCommon")
ClassMethod FindPrjItem(PrjName) As %String
{
	;查询Project下的项目
	Set rset=##class(%ResultSet).%New("%Studio.Project:ProjectItemsList")
	do rset.Execute(PrjName)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s ID=rset.Data("ID")
		s Name=rset.Data("Name")
		s Type=rset.Data("Type")
		s Package=rset.Data("Package")
		s CSPApp=rset.Data("CSPApp")
		w ID_"："_Name_"："_Type_"："_Package_"："_CSPApp,!
	}
	q ""
}

/// Desc: 导出项目工程
/// w ##class(DHCDoc.Util.System).ExportPrj("DHCDocLXCommon","DHCDoclxPrj.xml","C:\李旭")
ClassMethod ExportPrj(PrjName, XMlName, Path = "") As %String
{
	;导出工程的文件
	q:(PrjName="")||(XMlName="") ""
	s Obj=##class(%Studio.Project).%OpenId(PrjName)
	s:Path'="" XMlName=Path_"\"_XMlName
	s ret=Obj.Export(XMlName,"",0)
	q ""
}

/// Desc: 导出项目工程下的文件(每个文件对应一个xml,注意：路径需要有自动写入权限)
/// w ##class(DHCDoc.Util.System).ExportPrjItem("DHCDocLXCommon","D:\李旭")
ClassMethod ExportPrjItem(PrjName, Path = "") As %String
{
	q:PrjName="" "无对应的工程："_PrjName 
	
	s:Path="" Path="C:\ExportPrjItem\"
	s AllName=""
	
	;查询Project下的项目
	Set Obj=##class(%Studio.Project).%New()
	Set rset=##class(%ResultSet).%New("%Studio.Project:ProjectItemsList")
	do rset.Execute(PrjName)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s name=rset.Data("Name")
		s type=rset.Data("Type")
		k list
		i ##class(%RoutineMgr).Exists(name_$Select(type="CLS"||(type="PKG")||(type="DIR"):"."_type,1:"")) {
			s list(name_$Select(type="CLS"||(type="PKG"):"."_type,1:""))=""
			
			;记录导出的文件名
			i AllName="" s AllName=name_$Select(type="CLS"||(type="PKG"):"."_"cls",1:"")
			e  s AllName=AllName_$c(1)_name_$Select(type="CLS"||(type="PKG"):"."_"cls",1:"")
			
			;特殊处理xml名字
			i type="CSP" {
				s name=$replace(name,"/","_")
				i name[".csp" s name=$p(name,"_",*)
			}
			i type="CLS" {
				i name["web." s name=$p(name,".",2,*)
				i name["User." s name="User\"_$p(name,".",2,*)
			}
			
			s XMlName=name_".xml"
			s:Path'="" XMlName=Path_"\"_XMlName
			s ret=Obj.ExportList(XMlName,.list)
		}
	}
	i AllName'=""{
		s filename="log.txt"
		s:Path'="" filename=Path_"\"_filename
		s file=##class(%File).%New(filename)
		d file.Open("WSN")
		f len=1:1:$l(AllName,$c(1)) d
		.s name=$p(AllName,$c(1),len)
		.d file.WriteLine(name)	
		d file.Close()	
	}else{
		w "无对应的工程："_PrjName ,!
	}


	q ""
}

/// Desc: 查询DHC-APP下的一级包
/// 参考：##class(%CSP.Documatic).RenderPackageInfo()
/// w ##class(DHCDoc.Util.System).FindFirstPackName("DHCDoc")
ClassMethod FindFirstPackName(packagename = "") As %String
{
	Set showInternal=##class(%CSP.Documatic).ShowInternal()
	Set seed = ""
	Set:packagename'="" seed = $ZCVT(packagename,"U")_"."
	Set dots = $L(seed,".")
	Set key = $O(^rINDEXCLASS(seed),1,data)
	While ((key '= "")&&($E(key,1,$L(seed)) = seed)) {
		If ('$ListGet(data,4)||(showInternal)) {
			Set tName = $LG(data,2)
			Set tIsPkg = $L(tName,".") - dots // same number of dots = class
			If (tIsPkg) {
				Set tName = $P(tName,".",1,dots)
				If (tName'["%")&&($D(^rINDEXCLASS($ZCVT(tName,"U")))) {
					#; class with same name as package
					#; add to list with * appended
					Set tList(tName_"*") = 0
				}
			}
			Set:(tName'["%")&&(tName'="") tList(tName) = tIsPkg
		}
		Set key = $O(^rINDEXCLASS(key),1,data)
	}
	;输出为json,供VSCode中使用
	s packname=""
	f  s packname=$o(tList(packname)) q:packname=""  d
	.w """**/"_packname_""": true," ,!
	q ""
}

/****************************************************** 未分类方法 **************************************************/
/// Desc: 判断当前是否存在事务
/// w ##class(DHCDoc.Util.System).IsIntrans()
ClassMethod IsIntrans() As %Boolean
{
	;也可使用$tl判断当前事务层级
	&sql(%INTRANSACTION)
	q:'SQLCODE $$$YES
	q $$$NO
}

/// Desc: 把Query变成表
/// w ##class(DHCDoc.Util.System).QueryToTable()
ClassMethod QueryToTable(query, tablename)
{
 	d $SYSTEM.SQL.QueryToTable(query, tablename ,0)
}

/// Desc: 根据类名获取sql表名
/// w ##class(DHCDoc.Util.System).GetTableName("User.PAAdm")
ClassMethod GetTableName(ClassName As %String) As %String
{
	Q:(..IsValidClassName(ClassName))=0 "-1^类不存在"
	Q ##class(%Dictionary.ClassDefinition).%OpenId(ClassName).SqlTableName
}

/// Desc: 获取程序运行的时间
/// w ##class(DHCDoc.Util.System).GetRunTime("DHCDoc.Util.System","GetTimeStamp")
ClassMethod GetRunTime(ClassName, MethodName, Input...) As %String
{
	Q:(..IsValidMethodName(ClassName,MethodName))=0 "-1^类方法不存在"
	
	s t1 = $zh
	d $classmethod(ClassName, MethodName, Input...)
	q $zh - t1
}

/// Desc: 获取方法中write的值，转为流输出
/// 	 (需注意：调用的方法中如果使用了new，则需要加入：%ISCJSONStream)
/// w ##class(DHCDoc.Util.System).GetWriteStream(.a,"web.DHCAPPSeePatPacs","GetLisInspectOrdNew",1,10,"16^15^2021-10-13^2021-11-12^12175^^^^")
ClassMethod GetWriteStream(ByRef pStream As %Stream.Object, ClassName As %String, MethodName As %String, Input...) As %Status [ ProcedureBlock = 0 ]
{
	new (pStream,ClassName,MethodName,Input)
	
	#dim ex As %Exception.AbstractException
	#dim tSC As %Status = $$$OK
	#dim tRedirected, tWasRedirected As %Boolean = 0
	#dim tInitIO, tOldMnemonic

	Try {
		Set tWasRedirected = 0
		Set tOldMnemonic = ""
		Set:'$IsObject($G(pStream)) pStream=##class(%Stream.TmpBinary).%New()
		Set tInitIO = $IO
		Set tWasRedirected = ##class(%Library.Device).ReDirectIO()
		Set tOldMnemonic = ##class(%Library.Device).GetMnemonicRoutine()
		Set %ISCJSONStream = pStream
		Use tInitIO::("^"_$ZNAME)
		Set tRedirected = 1
		Do ##class(%Library.Device).ReDirectIO(1)
		Do $CLASSMETHOD(ClassName,MethodName,Input...)
	} Catch ex { 
		Set tSC = ex.AsStatus()
	}
	If tRedirected && ##class(%Library.Device).ReDirectIO(0) {
		Use tInitIO
	}
	If ($get(tOldMnemonic) '= "") {
		Set tOldMnemonic = "^"_tOldMnemonic
		Use tInitIO::(tOldMnemonic)
	}
	If $get(tWasRedirected) {
		Do ##class(%Library.Device).ReDirectIO(1)
	}
	If $$$ISOK(tSC) {
		Do pStream.Rewind()
	}
	Quit tSC

#; Public entry points for redirection - any changes made here should
#; also be reflected in redirects() in the jsonSQLProvider class
wstr(s)	Do %ISCJSONStream.Write(s) Quit
wchr(a) Do %ISCJSONStream.Write($char(a)) Quit
wnl 	Do %ISCJSONStream.WriteLine() Quit
wff 	Do %ISCJSONStream.WriteLine() Quit
wtab(n) Do %ISCJSONStream.Write($J("",$S(n>$X:n-$X,1:0))) Quit
rstr(len,time) Quit ""
rchr(time) Quit ""
}

/// 生成PDF
/// d ##class(DHCDoc.Util.System).CreatePDF()
ClassMethod CreatePDF()
{
	zn "SAMPLES"
	do ##class(ZENDemo.Home).CreateDemoData() 
	s rpt1=##class(ZENApp.MyReport).%New()
	s rpt1.RepeatingElement="SalesRep"
	s rpt1.CountRepeatingElement=5
	s rpt1.SplitAndMerge=1
	s rpt1.Month=1
	s Status=rpt1.GenerateReport("c:\temp\MyReport1.pdf",0)
	d $System.Status.DisplayError(Status)
	w $System.Status.DisplayError(Status)
	zn "DHC-APP"
}

/***
  **Description      :间接加锁业务表,用以替换$$LOCK^SSLOCK
  **Author           :tanjishan
  **Time             :2022/11/29
  **debugger         :##Class(DHCDoc.Util.System).LOCK("OE_Order",1,1,"41:35:23")
  **Parameter        :BASETAB,自定义表名
  						ROWID,
						User,用户
						Comp,客户端特征编码
  **Returns          :-1:成功，其他:失败
***/
ClassMethod LOCK(BASETAB, ROWID, User As %String = "", Comp As %String = "") As %String
{
	q:$g(ROWID)="" -1
	s User=$g(User),Comp=$g(Comp)
	s (user,name,doc,ext,s)=""
	L +^DBLock(BASETAB,ROWID):0
	if '$TEST {
		s ss=$g(^DBLock(BASETAB,ROWID)),user=$p(ss,"^"),comp=$p(ss,"^",2)
		s s=$g(^SSU("SSUSR",+user)),name=$p(s,"^",2),doc=$p(s,"^",14),ext=$p($g(^CTPCP(+doc,2)),"^",2)
		Q name_"^"_ext_"^"_comp
	}
	s ^DBLock(BASETAB,ROWID)=User_"^"_Comp
	Q -1
}

/***
  **Description      :默认立即解锁，不需要等待事务结束,用以替换$$LOCKCLR^SSLOCK
  **Author           :tanjishan
  **Time             :2022/11/29
  **debugger         :w ##Class(DHCDoc.Util.System).LOCKCLR("OE_Order",1)
  **Parameter        :BASETAB,自定义表名
  						ROWID,
						LockType,是否立即解锁,具体是否需要重写该变量，请结合实际业务考虑！！
  **Returns          :%String
***/
ClassMethod LOCKCLR(BASETAB, ROWID, LockType As %String = "I") As %String
{
	q:$g(ROWID)="" -1
	if (LockType="I"){
		L -^DBLock(BASETAB,ROWID)#LockType
	}else{
		L -^DBLock(BASETAB,ROWID)
	}
	k ^DBLock(BASETAB,ROWID)

	Q -1
}

}
