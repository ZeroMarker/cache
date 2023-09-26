/// 名称: DHCMed.CR.BO.ExternalInterface
/// 描述: 外部接口解析
/// 编写者：wuqk
/// 编写日期: 2012-12-05
Class DHCMed.CR.BO.ExternalInterface Extends %RegisteredObject [ Not ProcedureBlock ]
{

Property ID As %String;

Property ItemCode As %String;

Property Arguments As %String;

/// 加载外部接口数据
/// w ##class(DHCMed.CR.BO.ExternalInterface).LoadData()
ClassMethod LoadData() As %String
{
	set repid = $h
	/* 从 session 中获取环境变量 */
	//set %USERID = %session.Get("LOGON.USERID")
	//set %GROUPID = %session.Get("LOGON.GROUPID")
	//set %CTLOCID = %session.Get("LOGON.CTLOCID")
	//set %HOSPID = %session.Get("LOGON.HOSPID")

	/* 从 request 中获取环境变量 */
	//set %PatientID = 1 //%request.Get("PatientID")
	//set %EpisodeID = %request.Get("EpisodeID")
	;m ^tmpcrf(repid,"%request")=%request.Data
	m ^tmpcrf("ExternalInterface",$j,repid,"%request")=%request.Data  //217
	
	/* request中的其它环境变量 */
	
	set Externals = %request.Get("Externals") //"SSUser," //
	
	set InterfaceList=##class(DHCMed.CR.Util.JsonObject).ObjectListFromJSON(Externals,"DHCMed.CR.BO.ExternalInterface")
	set ret = ""
	quit:InterfaceList="" "{"_ret_"}"
	
	;set JsonObject = ##class(DHCMed.CR.Util.JsonObject).%New() //217
	set cnt = InterfaceList.Count()
	
	
	for i=1:1:cnt {
		#dim objTemp As DHCMed.CR.BO.ExternalInterface
		set objTemp = InterfaceList.GetAt(i)
		set InterFaceCode = objTemp.ItemCode //$p(ExternalNames,",",i)
		continue:InterFaceCode=""
		set objInterface = ##class(DHCMed.CR.BO.InterService).getObjectByCode(InterFaceCode)
		continue:'$IsObject(objInterface)
		set InterfaceClassMethod = objInterface.InterfaceClassMethod
		
		//此处需要处理session数据
		;set Arguments = objTemp.Arguments  //objInterface.Arguments
		set Arguments = ..ParseArgument(objTemp.Arguments)  //objInterface.Arguments  217
		
		set strClassName = $p(InterfaceClassMethod,"||")
		set strMethodName = $p(InterfaceClassMethod,"||",2)
		kill obj
		set cosCode="s obj=$ZOBJCLASSMETHOD(strClassName,strMethodName"
		if Arguments'="" {
			set cosCode=cosCode_","_Arguments
		}
		set cosCode=cosCode_")"
		;set ^tmpcrf(repid,$i(^tmpcrf(repid)))=strClassName
		;set ^tmpcrf(repid,$i(^tmpcrf(repid)))=strMethodName
		;set ^tmpcrf(repid,$i(^tmpcrf(repid)))=cosCode
		set ^tmpcrf("ExternalInterface",$j,repid,$i(^tmpcrf(repid)))=strClassName
		set ^tmpcrf("ExternalInterface",$j,repid,$i(^tmpcrf(repid)))=strMethodName
		set ^tmpcrf("ExternalInterface",$j,repid,$i(^tmpcrf(repid)))=Arguments
		set ^tmpcrf("ExternalInterface",$j,repid,$i(^tmpcrf(repid)))=cosCode
		x cosCode
		if ret'="" {set ret=ret_","}
		if '$IsObject(obj) {
			set ret = ret_InterFaceCode_":{}"
		}
		else {
			set JsonObject = ##class(DHCMed.CR.Util.JsonObject).%New() //
			do JsonObject.FromObject(obj)
			set data=JsonObject.Json()
			set ret = ret_objTemp.ID_":"_data
			;set ^tmpcrf(repid,$i(^tmpcrf(repid)))=data
			set ^tmpcrf("ExternalInterface",$j,repid,$i(^tmpcrf(repid)))=data //
		}
	}
	quit "{"_ret_"}"
}

//[ Private ]

/// 解析参数值
/// w ##class(DHCMed.CR.BO.ExternalInterface).ParseArgument("1")
ClassMethod ParseArgument(Args As %String) As %String
{
	new (Args,%session)
	set values = ""
	quit:Args="" values
	
	set cnt = $l(Args,",")
	for i=1:1:cnt {
		set tmpArgument = $p(Args,",",i)
		if tmpArgument [ "%session." {
			set key = $p(tmpArgument,"%session.",2)
			if key'="" {
				set val = %session.Get(key)
			}
		}
		else{
			set val = tmpArgument
		}
		set values = values_""""_val_""","
	}
	set values = $e(values,1,$l(values)-1)
	quit values
}

}
