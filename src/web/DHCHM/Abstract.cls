/// 名称: web.DHCHM.Abstract
/// 描述: 所有类的抽象父类
/// 编写者：wuqk
/// 编写日期: 2010-03-24
/// --------------------------------------------------
/// Modified by wrz 2010-09-17
/// Add method SaveData保存单表数据
///            TransDateToPage  转换日期到界面
///            TransDateToDB  转换日期到数据库
///            getCurUser  得到当前操作员
/// Modified by zf 2022-04-22
/// Add method GetSession  获取Session值
Class web.DHCHM.Abstract Extends (%RegisteredObject, %XML.Adaptor) [ Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 默认分隔符
Parameter SEPARATE = "^";

/// 获取%Session的值，存储Global中，Terminal调试可以调用Global中值
/// 第一步：使用前需要设置^TMPPESession("SetUserID")=登录用户ID
/// 第二步：页面执行一遍程序，让程序自动获取Session的值，存储到Global中
/// w ##class(web.DHCHM.Abstract).GetSession("LOGON.USERID")
ClassMethod GetSession(aArgCode As %String) As %String
{
	New (aArgCode,%session)
	Set return=""
	Quit:aArgCode="" return
	
	If $d(%session){
		If aArgCode="SessionId" {
			Set return=%session.SessionId
		} Else {
			Set return=%session.Get(aArgCode)
		}
		
		If $g(^TMPPESession("SetUserID"))=%session.Get("LOGON.USERID") {
			//有效时间15分钟（900秒），超时重新设置
			If ($g(^TMPPESession("UpdateDate"))'=(+$h))||($p($h,",",2)-(+$g(^TMPPESession("UpdateTime")))>900) {
				Set ^TMPPESession("UpdateDate")=+$h
				Set ^TMPPESession("UpdateTime")=$p($h,",",2)
				
				Kill ^TMPPESession("Data")
				Set ^TMPPESession("Data","SessionId")=%session.SessionId
				Set ^TMPPESession("Data","CONTEXT")= %session.Get("CONTEXT")
				Set ^TMPPESession("Data","CASUSERNAME")= %session.Get("CASUSERNAME")
				Set ^TMPPESession("Data","COMPUTER_NAME")= %session.Get("COMPUTER_NAME")
				Set ^TMPPESession("Data","LICENSE.TC")= %session.Get("LICENSE.TC")
				Set ^TMPPESession("Data","LICSITE")= %session.Get("LICSITE")
				Set ^TMPPESession("Data","LOGON.ALLOWCOLUMNMANAGER")= %session.Get("LOGON.ALLOWCOLUMNMANAGER")
				Set ^TMPPESession("Data","LOGON.ALLOWLAYOUTMANAGER")= %session.Get("LOGON.ALLOWLAYOUTMANAGER")
				Set ^TMPPESession("Data","LOGON.CTLOCDESC")= %session.Get("LOGON.CTLOCDESC")
				Set ^TMPPESession("Data","LOGON.CTLOCID")= %session.Get("LOGON.CTLOCID")
				Set ^TMPPESession("Data","LOGON.GROUPDESC")= %session.Get("LOGON.GROUPDESC")
				Set ^TMPPESession("Data","LOGON.GROUPID")= %session.Get("LOGON.GROUPID")
				Set ^TMPPESession("Data","LOGON.HOSPDESC")= %session.Get("LOGON.HOSPDESC")
				Set ^TMPPESession("Data","LOGON.HOSPID")= %session.Get("LOGON.HOSPID")
				Set ^TMPPESession("Data","LOGON.LANGCODE")= %session.Get("LOGON.LANGCODE")
				Set ^TMPPESession("Data","LOGON.LANGID")= %session.Get("LOGON.LANGID")
				Set ^TMPPESession("Data","LOGON.LAYOUTMANAGER")= %session.Get("LOGON.LAYOUTMANAGER")
				Set ^TMPPESession("Data","LOGON.LICINFO")= %session.Get("LOGON.LICINFO")
				Set ^TMPPESession("Data","LOGON.PPMCAPTURE")= %session.Get("LOGON.PPMCAPTURE")
				Set ^TMPPESession("Data","LOGON.PPMDISPLAY")= %session.Get("LOGON.PPMDISPLAY")
				Set ^TMPPESession("Data","LOGON.REGION")= %session.Get("LOGON.REGION")
				Set ^TMPPESession("Data","LOGON.ROUND")= %session.Get("LOGON.ROUND")
				Set ^TMPPESession("Data","LOGON.ROUNDDESC")= %session.Get("LOGON.ROUNDDESC")
				Set ^TMPPESession("Data","LOGON.SITECODE")= %session.Get("LOGON.SITECODE")
				Set ^TMPPESession("Data","LOGON.SSUSERLOGINID")= %session.Get("LOGON.SSUSERLOGINID")
				Set ^TMPPESession("Data","LOGON.STYLESHEET")= %session.Get("LOGON.STYLESHEET")
				Set ^TMPPESession("Data","LOGON.TIMEOUT")= %session.Get("LOGON.TIMEOUT")
				Set ^TMPPESession("Data","LOGON.TRUSTDESC")= %session.Get("LOGON.TRUSTDESC")
				Set ^TMPPESession("Data","LOGON.TRUSTID")= %session.Get("LOGON.TRUSTID")
				Set ^TMPPESession("Data","LOGON.USERCODE")= %session.Get("LOGON.USERCODE")
				Set ^TMPPESession("Data","LOGON.USERID")= %session.Get("LOGON.USERID")
				Set ^TMPPESession("Data","LOGON.USERNAME")= %session.Get("LOGON.USERNAME")
				Set ^TMPPESession("Data","LOGON.WARDDESC")= %session.Get("LOGON.WARDDESC")
				Set ^TMPPESession("Data","LOGON.WARDID")= %session.Get("LOGON.WARDID")
				Set ^TMPPESession("Data","LogonAttempts")= %session.Get("LogonAttempts")
				Set ^TMPPESession("Data","PreviousUser")= %session.Get("PreviousUser")
				Set ^TMPPESession("Data","REMOTE_ADDR")= %session.Get("REMOTE_ADDR")
				Set ^TMPPESession("Data","SERVER_NAME")= %session.Get("SERVER_NAME")
				Set ^TMPPESession("Data","SYS.LANGID")= %session.Get("SYS.LANGID")
				Set ^TMPPESession("Data","SYS.TIMEOUT")= %session.Get("SYS.TIMEOUT")
				Set ^TMPPESession("Data","TITLE")= %session.Get("TITLE")
				Set ^TMPPESession("Data","XMONTHSSHORT")= %session.Get("XMONTHSSHORT")
			}
		}
	} Else {
		//有效时间15分钟（900秒），超时需重新设置
		If ($g(^TMPPESession("UpdateDate"))'=(+$h))||($p($h,",",2)-(+$g(^TMPPESession("UpdateTime")))>900) {
			Set return=""
			Write "体检%session值未设置或已超时",!
		} Else {
			If $d(^TMPPESession("Data",aArgCode)){
				Set return=$g(^TMPPESession("Data",aArgCode))
			} Else {
				Set return=""
				Write "体检%session值未设置",!
			}
		}
	}
	Quit return
}

/// 转换日期到界面
ClassMethod TransDateToPage(Date, Type As %String = "3") As %String
{
	n (Date,Type)
	q:Date="" ""
	q $ZD(Date,Type)
}

/// 转换日期到数据库"YYYY-mm-dd"
ClassMethod TransDateToDB(Date, Type As %String = "3") As %Numeric
{
	n (Date,Type)
	q:Date="" ""
	i +Date>5000 q Date
	q ##class(websys.Conversions).DateHtmlToLogical(Date)
	q $ZDH(Date,Type)
}

/// 获取当前登录人
ClassMethod getCurUser() As %String
{
	q ..GetSession("LOGON.USERID")
}

}
