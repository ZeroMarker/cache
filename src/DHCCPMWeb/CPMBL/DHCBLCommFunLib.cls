/// 提供CPM的系统底层解析工作
Class DHCCPMWeb.CPMBL.DHCBLCommFunLib Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 提供的功能：
/// 1. 解析传入的参数 XML格式转化为^TMP  格式
/// 2. 获取类名的模糊查询
/// 3. 获取当前类下的Query列表
/// 4. 解析Query的输入参数
/// 5. 解析Query的输出参数
/// 6. 检索组件的类列表
/// 
ClassMethod GetClassList(ClassName As %String = "", ExpStr As %String = "") As DHCCPMWeb.CPMSevice.dataset.DHCLookClassDataSet
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetClassList(ClassName)
	n (ClassName,ExpStr)
	
	Set result=##class(DHCCPMWeb.CPMSevice.dataset.DHCLookClassDataSet).%New()
	i (ClassName="")
	{
		s ClassName="@#$"
	}
	Do result.SetArgs(ClassName)
	Quit result
}

/// 获取组件列表
/// 返回： ID:Name:ClassName:QueryName:DisplayType
ClassMethod GetCompList(CompName As %String, ExpStr As %String) As DHCCPMWeb.CPMSevice.dataset.DHCLookCompDataSet
{
	n (CompName,ExpStr)
	s myres=##class(DHCCPMWeb.CPMSevice.dataset.DHCLookCompDataSet).%New()
	
	d myres.SetArgs(CompName)
	q myres
}

/// 输入一个串，返回一个List对象
/// 可以用来拆分任何对字符串
ClassMethod GetParaList(InStr As %String = "", SplitStr As %String = "^") As %List
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetParaList("1^1^111")
	n (InStr,SplitStr)
	
	Set mylist=##class(%ListOfDataTypes).%New()
	
	q:((InStr="")!(SplitStr="")) mylist
	
	s myCount=$l(InStr,SplitStr)
	f i=1:1:myCount d
	.s myCurStr=$p(InStr,SplitStr,i)
	.s myCurStr=..Trim(myCurStr)
	.d mylist.Insert(myCurStr)
	
	q mylist
}

ClassMethod GetQInParaListBack1(ClassName As %String = "", QueryName As %String = "", ExpStr As %String) As %String
{
	;;没有转换，暂时不用
	;w ##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQInParaList("web.SSLuange","LookUp","")
	n (ClassName,QueryName, ExpStr)
	
	s myrtn=""
	
	q:((ClassName="")!(QueryName)) myrtn
	
	s myIsVal=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).IsValidClassName(ClassName)
	q:('myIsVal) myrtn
	s myIsVal=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).IsValidQueryName(ClassName,QueryName)
	q:('myIsVal) myrtn
	
	s myCID=ClassName_"||"_QueryName
	;s myobj=##class(%Dictionary.QueryDefinition).%OpenId(myCID)
	
	;q:('$IsObject(myobj)) myrtn
	
	;s myrtn=myobj.FormalSpec
	;d myobj.%Close()
	
	s rs=##class(%Library.ResultSet).%New(ClassName_":"_QueryName)
	s paramcnt=rs.GetParamCount()
	f j=1:1:paramcnt {
		s paramname=rs.GetParamName(j)
		s paratype=rs.GetColumnType(j)
		s:myrtn'="" myrtn=myrtn_","
		s myrtn=myrtn_paramname_":"_paratype
	}
	d rs.%Close()
	
	q myrtn
}

/// / 统一获取Query入参程序
ClassMethod GetQInParaList(ClassName As %String = "", QueryName As %String = "", ExpStr As %String) As %String
{
	/// 变成统一的参数名称:参数类型:默认值
	;w ##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQInParaListBack("web.DHCOPAdmFind","AdmQuery","")
	;w ##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQInParaList("web.DHCLONGTIMEORD","GetLongOrd","")
	n (ClassName,QueryName, ExpStr)
	
	s myrtn=""
	
	q:((ClassName="")!(QueryName)) myrtn
	
	s myIsVal=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).IsValidClassName(ClassName)
	q:('myIsVal) myrtn
	s myIsVal=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).IsValidQueryName(ClassName,QueryName)
	q:('myIsVal) myrtn
	
	s myCID=ClassName_"||"_QueryName
	s myobj=##class(%Dictionary.QueryDefinition).%OpenId(myCID,0)
	
	q:('$IsObject(myobj)) myrtn
	
	s myrtn=..ParseInParaByFormalSpec(myobj.FormalSpec)
	
	d myobj.%Close()
	
	q myrtn
}

/// 把函数、query的入参统一规整一下生成一个统一的字符串返回
/// ;变成统一的参数名称:参数类型:默认值:类型
ClassMethod ParseInParaByFormalSpec(fs As %String) As %String
{
	n (fs)
	
	q:(fs="") ""
	
	s mynewfs=""
	s myName=""
	s myType=""
	s myDefault=""
	s myPassBy=""
	
	s mylen=$l(fs,",")
	for myIdx=1:1:mylen {
		s:(mynewfs'="") mynewfs=mynewfs_","
		s myPassBy="Value"
		s myDefault=""
		s myCurpara=$p(fs,",",myIdx)
		i $e(myCurpara,1)="&"{
			s myPassBy="Reference"
			s myCurpara=$p(myCurpara,"&",2)
		}
		
		s myName=$p(myCurpara,":",1)
		s myType=$p(myCurpara,":",2)
		s:(myType="") myType="%String"
		i (myType["="){
			s myDefault=$p(myType,"=",2)
			s myType=$p(myType,"=",1)
		}
		i (myName["="){
			s myDefault=$p(myName,"=",2)
			s myName=$p(myName,"=",1)
		}
		
		s mynewfs=mynewfs_myName_":"_myType_":"_myDefault_":"_myPassBy
		;b	;; GetInParaByFormalSpec
	}
	
	q mynewfs
}

/// 统一获取类方法的入参列表
ClassMethod GetCMInParaList(ClassName As %String = "", ClassMethod As %String = "", ExpStr As %String) As %String
{
	/// 变成统一的参数名称:参数类型:默认值
	;w ##class(ext.websys.Broker).GetCMInParaList("ext.websys.Menu","ShowBarJson","")
	n (ClassName,ClassMethod, ExpStr)
	
	s myrtn=""
	
	q:((ClassName="")!(ClassMethod="")) myrtn
	
	s myIsVal=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).IsValidClassName(ClassName)
	
	q:('myIsVal) myrtn
	s myIsVal=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).IsValidMethodName(ClassName,ClassMethod)
	q:('myIsVal) myrtn
	
	s myCID=ClassName_"||"_ClassMethod
	s myobj=##class(%Dictionary.MethodDefinition).%OpenId(myCID,0)
	
	q:('$IsObject(myobj)) myrtn
	
	s myrtn=..ParseInParaByFormalSpec(myobj.FormalSpec)
	
	d myobj.%Close()
	
	q myrtn
}

/// 得到Query的输出参数生成一个串 Query输出列生成一个串
ClassMethod GetQOutParaList(ClassName As %String = "", QueryName As %String = "", ExpStr As %String) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQOutParaList("web.DHCLONGTIMEORD","GetLongOrd","")
	n (ClassName,QueryName, ExpStr)
	
	s myrtn=""
	
	q:((ClassName="")!(QueryName)) myrtn
	
	s myIsVal=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).IsValidClassName(ClassName)
	q:('myIsVal) myrtn
	s myIsVal=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).IsValidQueryName(ClassName,QueryName)
	q:('myIsVal) myrtn
	
	s myCID=ClassName_"||"_QueryName
	s myobj=##class(%Dictionary.QueryDefinition).%OpenId(myCID,0)
	;b	;
	i $IsObject(myobj){
		s myrtn=myobj.Parameters.GetAt("ROWSPEC")
		d myobj.%Close()
	}else{
		s myrtn=$g(^oddCOM(ClassName,"q",QueryName,"P","ROWSPEC"))
		;s x="s defrtn=##class("_ClassName_")."_QueryName_"GetInfo(.colinfo,.parminfo,.idinfo)"
		;x x
	}
	
	i (myrtn=""){
		;find definition
		s x="s defrtn=##class("_ClassName_")."_QueryName_"GetInfo(.colinfo,.parminfo,.idinfo)"
		x x
		b	;;execute
		s myrowspec=""
		i $g(colinfo)'=""{
			s mycollen=$ll(colinfo)
			for myIdx=1:1:mycollen {
				s mycolumninfo=$lg(colinfo,myIdx)
				s:(myrowspec'="") myrowspec=myrowspec_","
				s mycolname=$lg(mycolumninfo,1)
				s mycoltype=$lg(mycolumninfo,2)
				
				s myrowspec=myrowspec_""_mycolname_":"_mycoltype_":"_""
			}
		}
		b	;
		s myrtn=myrowspec
	}else{
		;myrtn
		;补一下 数据类型
		
		
	}
	
	q myrtn
}

ClassMethod GetQueryList(ClassName As %String = "", ExpStr As %String = "") As DHCCPMWeb.CPMSevice.dataset.DHCLookQueryDataSet
{
	;s rtn=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQueryList("web.DHCOPAdmFind","")
	n (ClassName, ExpStr)
	Set result=##class(DHCCPMWeb.CPMSevice.dataset.DHCLookQueryDataSet).%New()
	i (ClassName="")
	{
		s ClassName="@#$"
	}
	
	Do result.SetArgs(ClassName)
	
	Quit result
}

ClassMethod KillTMP() As %String
{
	k ^TMPCPMQInPara($j)
	k ^TMPCPMQOutPara($j)
	
	q 0
}

/// 解析XML文件流参数,生成一个Global
ClassMethod ParseXMLToTMP(ByRef XMLReader As %XML.String) As %String
{
}

ClassMethod Round(FNum As %String, Len As %String, RNum As %String) As %String
{
	;设置不同的舍入进制
	n (FNum,Len,RNum)
	;w ##class(web.DHCOPCommonFunLib).Round(12.678,2,6)
	
	s myNum=0
	i Len="" d
	.s Len=0
	
	s Len=+$g(Len)
	s FNum=+$g(FNum)
	s RNum=+$g(RNum)
	
	s myNum=$fn(FNum,"", Len)
	
	;求幂
	s myzp=$zpower(10,Len)
	
	;取整数取4舍五入,  增加了矫正
	s myRtnInt=$fn(((FNum*myzp*10)-(RNum-5))/10,"",0)
	
	s myNum=$fn((myRtnInt/myzp),"",Len)
	
	q myNum
}

/// 由Net端传入到Cache端数据转换
ClassMethod TransNICPara(NetInPara As %String) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara()
	n (NetInPara)
	
	s myrtn=""
	
	if (NetInPara=$c(0)){
		s myrtn=""
	}else{
		s myrtn=NetInPara
	}
	
	q myrtn
}

ClassMethod Trim(IStr As %String) As %String
{
	n (IStr)
	
	;s rtn=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).Trim("")
	
	s myStr=""
	i IStr=" " d
	.s IStr=""
	
	;Left Trim
	s mylen=$l(IStr)
	s myIdx=0
	s myCurStr=" "
	f i=1:1:mylen  q:(myCurStr'=" ")  d
	.s myIdx=i
	.s myCurStr=$e(IStr,i,i)
	
	s IStr=$e(IStr, myIdx, mylen)
	
	;Right Trim
	s mylen=$l(IStr)
	s myCurStr=" "
	s myIdx=0
	f i=mylen:-1:1  q:(myCurStr'=" ")  d
	.s myIdx=i
	.s myCurStr=$e(IStr,i,i)
	s IStr=$e(IStr, 1, myIdx)
	
	s myStr=IStr
	
	q myStr
}

ClassMethod IsValidClassName(classname As %String) As %Boolean
{
	q $s(+$$$comClassDefined(classname):1, 1:0)
}

ClassMethod IsValidQueryName(classname As %String, queryname As %String) As %Boolean
{
	q $s(+$$$comMemberDefined(classname,$$$cCLASSquery,queryname):1, 1:0)
}

}
