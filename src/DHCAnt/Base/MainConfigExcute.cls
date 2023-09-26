/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 抗菌药物基本主配置表操作方法类
Class DHCAnt.Base.MainConfigExcute Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/*
	QP
	类方法说明
	1、流程方法
		GetProcess: 得到当前流程
		GetProcessNextNode: 得到当前流程的下一个流程
		GetProcessPrevNode: 得到当前流程的上一个流程
	2、Code方法
		GetIdByMCGCode: 得到当前mcgCode的Id
		GetValueByMCGCode: 根据mcgCode，得到其Value
		GetValuesJsonByParentCode: 根据parentCode，得到其Values对象
*/
/// CTOR: QP
/// DATE: 2020-03-10
/// DESC: 流程方法：得到当前流程
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetProcessNew("KSS3APPA",2)
ClassMethod GetProcessNew(processType As %String = "", InHosp As %String = "") As %String
{
	n (processType,InHosp)
	s mRtn=""
	s mcgId=""
	f  s mcgId=$o(^DHCAntBaseMainConfigI("MCGHospAndCode",InHosp,processType,mcgId)) q:mcgId=""  d
	.q:mRtn'=""
	.s mcgType=$p(^DHCAntBaseMainConfigD(mcgId),"^",1)
	.q:mcgType'="NEWPROCESS"
	.s mRtn=$p(^DHCAntBaseMainConfigD(mcgId),"^",9)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 流程方法：得到当前流程
/// IN  : processType
/// OUT : 
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetProcess("KSS3APPA")
ClassMethod GetProcess(processType As %String) As %String
{
	n (processType)
	s mRtn="A"
	s initStatus="A"
	s initNextNode=..GetProcessNextNode(initStatus, processType)
	i initNextNode'="" s mRtn=mRtn_","_initNextNode
	while initNextNode'="" {
		s initNextNode=..GetProcessNextNode(initNextNode, processType)
		i initNextNode'="" s mRtn=mRtn_","_initNextNode
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 流程方法：得到当前流程的下一个流程
/// IN  : A,processType
/// OUT : 
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetProcessNextNode("A","KSS3APPA")
ClassMethod GetProcessNextNode(curStatus As %String, processType As %String) As %String
{
	n (curStatus,processType)
	s mRtn=""
	s curStatusCode=processType_curStatus
	s curId=..GetIdByMCGCode(curStatusCode)
	q:curId="" mRtn
	s curMcgNext=$p(^DHCAntBaseMainConfigD(curId),"^",10)
	q:curMcgNext="" mRtn
	s curMcgNextActive=$p(^DHCAntBaseMainConfigD(curMcgNext),"^",5)
	q:curMcgNextActive'=1 mRtn	//未激活,无效
	s curMcgNextValue=$p(^DHCAntBaseMainConfigD(curMcgNext),"^",9)
	s mRtn=curMcgNextValue
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 流程方法：得到当前流程的上一个流程
/// IN  : S,processType
/// OUT : H
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetProcessPrevNode("A","KSS3APPNOA")
ClassMethod GetProcessPrevNode(curStatus As %String, processType As %String) As %String
{
	n (curStatus,processType)
	s mRtn=""
	s headNode="A",prevNode=""
	q:headNode=curStatus mRtn
	s nextNode=..GetProcessNextNode(headNode,processType)
	i nextNode=curStatus s mRtn=headNode
	while nextNode'="" {
		s prevNode=nextNode
		s nextNode=..GetProcessNextNode(nextNode,processType)
		i nextNode=curStatus s mRtn=prevNode
		q:nextNode=curStatus
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: mcgCode方法：得到当前mcgCode的Id
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetIdByMCGCode("VERSION","",1)
ClassMethod GetIdByMCGCode(mcgCode As %String, mcgHosp As %String = "", osFlag As %String = "") As %String
{
	n (mcgCode,mcgHosp,osFlag,%session)
	i osFlag'=1 {
		i mcgHosp="" s mcgHosp=%session.Get("LOGON.HOSPID")
		s mRtn=$o(^DHCAntBaseMainConfigI("MCGHospAndCode",mcgHosp,mcgCode,""))
	} else {
		s mRtn=$o(^DHCAntBaseMainConfigI("MCGCode",mcgCode,""))
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: mcgCode方法：根据mcgCode，得到其Value
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("ZBJ",2)
ClassMethod GetValueByMCGCode(mcgCode As %String, mcgHosp As %String = "") As %String
{
	n (mcgCode,mcgHosp,%session)
	s mRtn=""
	Q:mcgCode="" mRtn
	i mcgHosp="" s mcgHosp=%session.Get("LOGON.HOSPID")
	s curId=..GetIdByMCGCode(mcgCode,mcgHosp)
	q:curId="" mRtn
	s active=$p(^DHCAntBaseMainConfigD(curId),"^",5)
	q:active=0 mRtn
	s mRtn=$p(^DHCAntBaseMainConfigD(curId),"^",9)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: mcgCode方法：根据mcgCode，得到其Desc
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetDescByMCGCode("CONDOC")
ClassMethod GetDescByMCGCode(mcgCode As %String, InHosp = "") As %String
{
	n (mcgCode,%session)
	s mRtn=""
	s curId=..GetIdByMCGCode(mcgCode,InHosp)
	q:curId="" mRtn
	s mRtn=$p(^DHCAntBaseMainConfigD(curId),"^",4)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 得到系统级描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetOSDesc("PSTATUSA")
ClassMethod GetOSDesc(mcgCode As %String) As %String
{
	n (mcgCode)
	s mRtn=""
	s curId=$o(^DHCAntBaseMainConfigI("MCGCode",mcgCode,""))
	q:curId="" mRtn
	s mRtn=$p(^DHCAntBaseMainConfigD(curId),"^",4)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2017-03-10
/// DESC: mcgCode方法：根据mcgCode，得到其ControlType
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetControlTypeByMCGCode("KSS3APPA",2)
ClassMethod GetControlTypeByMCGCode(mcgCode As %String, InHosp As %String = "") As %String
{
	n (mcgCode,InHosp)
	s mRtn=""
	s curId=..GetIdByMCGCode(mcgCode,InHosp)
	q:curId="" mRtn
	s mRtn=$p(^DHCAntBaseMainConfigD(curId),"^",8)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: ParentCode方法：根据parentCode，得到其激活的ValueStr字符串
/// IN  : 
/// OUT : ValueStr 字符串：code^value!code1^value2
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetValueStrByParentCode("PARA")
ClassMethod GetValueStrByParentCode(parentCode As %String) As %String
{
	n (parentCode)
	s mRtn=""
	q:((parentCode="")||(parentCode="BASE")) mRtn
	
	s mcgId="",record=0
	f  s mcgId=$o(^DHCAntBaseMainConfigI("MCGParentCode",parentCode,mcgId)) q:mcgId=""  d
	.s mcgCode=$p(^DHCAntBaseMainConfigD(mcgId),"^",3)
	.s mcgValue=$p(^DHCAntBaseMainConfigD(mcgId),"^",9)
	.s mcgActive=$p(^DHCAntBaseMainConfigD(mcgId),"^",5)
	.q:mcgActive'=1	//未激活
	.s record=record+1
	.i mRtn="" s mRtn = mcgCode_"^"_mcgValue
	.e  s mRtn = mRtn_"!"_mcgCode_"^"_mcgValue
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: ParentCode方法：根据parentCode，得到其Values对象
/// IN  : 
/// OUT : Values 对象
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetValuesJsonByParentCode("PARA")
ClassMethod GetValuesJsonByParentCode(parentCode As %String) As %String
{
	n (parentCode)
	s mRtn=""
	q:((parentCode="")||(parentCode="BASE")) ##class(DHCAnt.Util.ConvertJson).GetNoDataJson()
	
	s mcgId="",record=0
	f  s mcgId=$o(^DHCAntBaseMainConfigI("MCGParentCode",parentCode,mcgId)) q:mcgId=""  d
	.s mcgCode=$p(^DHCAntBaseMainConfigD(mcgId),"^",3)
	.s mcgValue=$p(^DHCAntBaseMainConfigD(mcgId),"^",9)
	.s mcgActive=$p(^DHCAntBaseMainConfigD(mcgId),"^",5)
	.q:mcgActive'=1	//未激活
	.s tempData=##class(DHCAnt.Util.ConvertJson).GetDataJson(mcgCode,mcgValue)
	.s sperator=","
	.i record=0  d
	..s mRtn=##class(DHCAnt.Util.ConvertJson).GetDataStartJson()
	..s mRtn=mRtn_tempData
	.e  s mRtn=mRtn_sperator_tempData
	.s record=record+1
	s mRtn=mRtn_##class(DHCAnt.Util.ConvertJson).GetDataEndJson()
	Q mRtn
}

/// CTOR: QP
/// DATE: 2017-03-10
/// DESC: 获取最终审核科室
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetLastAuditLoc("KSS2APPU")
ClassMethod GetLastAuditLoc(mcgCode As %String) As %String
{
	n (mcgCode)
	i mcgCode'="" d
	.i mcgCode'["U" s mcgCode=mcgCode_"U"
	s mRtn=""
	s kss2Loc=..GetControlTypeByMCGCode("KSS2APPU")
	s kss3LocA=..GetControlTypeByMCGCode("KSS3APPAU")
	s kss3LocNOA=..GetControlTypeByMCGCode("KSS3APPNOAU")
	i mcgCode'="" s mRtn=..GetControlTypeByMCGCode(mcgCode)
	e  s mRtn="KSS2APP,"_kss2Loc_"!KSS3APPNOA,"_kss3LocNOA_"!KSS3APPA,"_kss3LocA
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-04-17
/// DESC: 根据code，设置Value值
/// IN  : 
/// OUT : 1(成功)/0(失败)
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).SetValueByMCGCode("CQMX","")
ClassMethod SetValueByMCGCode(mcgCode As %String, value As %String, forceFlag As %String = 0, mcgHosp = "") As %String
{
	n (mcgCode,value,forceFlag,mcgHosp,%session)
	s mRtn=0
	s curId=..GetIdByMCGCode(mcgCode)
	q:curId="" mRtn
	;s active=$p(^DHCAntBaseMainConfigD(curId),"^",5)
	;q:active=0 mRtn
	;s mRtn=$p(^DHCAntBaseMainConfigD(curId),"^",9)
	i mcgHosp="" s mcgHosp=%session.Get("LOGON.HOSPID")
	s a=##class(DHCAnt.Base.MainConfig).%OpenId(curId)
	s CQMX=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode(mcgCode,mcgHosp)
	i (forceFlag = 0) {
		i CQMX="" s CQMX=value
		e  d
		.i (","_CQMX_",")'[(","_value_",") d
		..i value'="" s CQMX=CQMX_","_value
		s a.MCGControlValue=CQMX
	} else {
		s a.MCGControlValue=value
	}
	s sc=a.%Save()
	If $$$ISERR(sc) {
		d a.%Close()
		Quit 0
	}
	d a.%Close()
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-02-21
/// DESC: 根据code，设置Value值
/// IN  : 
/// OUT : 1(成功)/0(失败)
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).SetValueByMCGCode("CQMX","")
ClassMethod SetValueByMCGCodeNew(mcgCode As %String, value As %String, forceFlag As %String = 0, mcgHosp = "") As %String
{
	n (mcgCode,value,forceFlag,mcgHosp,%session)
	s mRtn=0
	s curId=..GetIdByMCGCode(mcgCode,mcgHosp)
	i curId="" {
		s mRtn=..SaveMConfig(mcgCode,value,mcgHosp)
	} else {
		;s active=$p(^DHCAntBaseMainConfigD(curId),"^",5)
		;q:active=0 mRtn
		;s mRtn=$p(^DHCAntBaseMainConfigD(curId),"^",9)
		i mcgHosp="" s mcgHosp=%session.Get("LOGON.HOSPID")
		s a=##class(DHCAnt.Base.MainConfig).%OpenId(curId)
		s CQMX=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode(mcgCode,mcgHosp)
		i (forceFlag = 0) {
			i CQMX="" s CQMX=value
			e  d
			.i (","_CQMX_",")'[(","_value_",") d
			..i value'="" s CQMX=CQMX_","_value
			s a.MCGControlValue=CQMX
		} else {
			s a.MCGControlValue=value
		}
		s sc=a.%Save()
		If $$$ISERR(sc) {
			d a.%Close()
			Quit 0
		}
		d a.%Close()
	}
	Q 1
}

/// CTOR: QP
/// DATE: 2020-02-21
/// DESC: 根据code，设置Value值
/// IN  : 
/// OUT : 1(成功)/0(失败)
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).SetValueByMCGCode("CQMX","")
ClassMethod SaveMConfig(mcgCode, mcgValue, mcgHosp = "")
{
	n (mcgCode,mcgValue,mcgHosp)
	s ^TEMP("SaveMConfig")=$LB(mcgCode,mcgValue,mcgHosp)
	q:mcgCode="" "-2"
	i mcgHosp="" s mcgHosp=%session.Get("LOGON.HOSPID")
	s zeroArr="UPMYF,UPMZL"
	s zeroFlag=##class(DHCAnt.KSS.Common.Method).InArray(zeroArr,mcgCode)
	i zeroFlag=1 s mcgValue=0
	s a=##class(DHCAnt.Base.MainConfig).%New()
	s a.MCGType="PARAMATER"
	s a.MCGParentCode="PARA"
	s a.MCGCode=mcgCode
	;s a.MCGDesc=MCGDesc ;
	s a.MCGActive=1
	;s a.MCGDateFrom=MCGDateFrom
	;s a.MCGDateTo=MCGDateTo
	;s a.MCGControlType=MCGControlType
	s a.MCGControlValue=mcgValue
	;s a.MCGProcessNext=MCGProcessNext
	;s a.MCGStrB=MCGStrB
	;s a.MCGStrC=MCGStrC
	;s a.MCGStrD=MCGStrD
	s a.MCGHosp=mcgHosp
	s sc=a.%Save()
	If $$$ISERR(sc) {	//QP
		;d $system.OBJ.DisplayError(sc) 
		//TRollback
		Quit "-100"
	}
	s mRtn=a.%Id()
	d a.%Close()
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-02-26
/// DESC: 保存单条流程配置，新的存储方式
/// IN  : 
/// OUT : 1(成功)/0(失败)
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).SaveProcess("CQMX","")
ClassMethod SaveProcess(mcgCode, mcgValue, mcgHosp = "", finalDep = "", mcgDesc = "", id = "")
{
	n (mcgCode,mcgValue,mcgHosp,finalDep,mcgDesc,id)
	
	q:mcgCode="" "-2"
	i mcgHosp="" s mcgHosp=%session.Get("LOGON.HOSPID")
	i id="" {
		s a=##class(DHCAnt.Base.MainConfig).%New()
		s a.MCGType="NEWPROCESS"
		s a.MCGParentCode="BASE"
		s a.MCGCode=mcgCode
		i mcgDesc'="" s a.MCGDesc=mcgDesc 
		s a.MCGActive=1
		;s a.MCGDateFrom=MCGDateFrom
		;s a.MCGDateTo=MCGDateTo
		;s a.MCGControlType=MCGControlType
		i mcgValue["U" s a.MCGControlType=finalDep
		s a.MCGControlValue=mcgValue
		;s a.MCGProcessNext=MCGProcessNext
		;s a.MCGStrB=MCGStrB
		;s a.MCGStrC=MCGStrC
		;s a.MCGStrD=MCGStrD
		s a.MCGHosp=mcgHosp
	} else {
		s a=##class(DHCAnt.Base.MainConfig).%OpenId(id)
		s a.MCGControlValue=mcgValue
		s a.MCGControlType=finalDep
	}
	s sc=a.%Save()
	If $$$ISERR(sc) {	//QP
		;d $system.OBJ.DisplayError(sc) 
		//TRollback
		Quit "-100"
	}
	s mRtn=a.%Id()
	d a.%Close()
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-02-26
/// DESC: 保存多条流程配置，新的存储方式
/// IN  : 
/// OUT : 1(成功)/0(失败)
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).SaveMutiProcess("2")
ClassMethod SaveMutiProcess(mcgHosp = "")
{
	n (mcgHosp)
	i mcgHosp="" s mcgHosp=%session.Get("LOGON.HOSPID")
	//存在不保存
	q:$d(^DHCAntBaseMainConfigI("MCGHospAndType",mcgHosp,"NEWPROCESS")) 1
	s ProcessCodeArr="KSS2APP-A,F-非特抗药申请流程:KSS3APPNOA-A,F,H-特抗药无审核权限申请流程:KSS3APPA-A,H-特抗药有审核权限申请流程"
	s Len=$l(ProcessCodeArr,":")
	s mRtn=1
	TS
	f i=1:1:Len {
		Q:mRtn'=1
		s cStr=$p(ProcessCodeArr,":",i)
		s cCode=$p(cStr,"-",1)
		s cValue=$p(cStr,"-",2)
		s cDesc=$p(cStr,"-",3)
		s mRtn=..SaveProcess(cCode,cValue,mcgHosp,"",cDesc)
	}
	i mRtn'=1 {
		TRO
		Q "-200"	
	}
	TC
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-03-10
/// DESC: 获取系统参数值
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("MSGTIPURL")
ClassMethod GetOSValueByCode(mcgCode As %String, mcgHosp As %String = "") As %String
{
	n (mcgCode,mcgHosp,%session)
	s mRtn=""
	s curId=..GetIdByMCGCode(mcgCode,mcgHosp,1)
	q:curId="" mRtn
	s active=$p(^DHCAntBaseMainConfigD(curId),"^",5)
	q:active=0 mRtn
	s mRtn=$p(^DHCAntBaseMainConfigD(curId),"^",9)
	Q mRtn
}

}
