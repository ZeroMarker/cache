Class DHCWL.SysService.SysExecuteCode Extends %RegisteredObject [ LegacyInstanceContext, Not ProcedureBlock ]
{

/// 	s obj=##class(DHCWL.SysService.SysExecuteCode).BuildSysExecuteCodeObj("","TAS","CreatLastMonDataAt1^DHCWLAutoCreatMKPIData")
ClassMethod BuildSysExecuteCodeObj(id = "", execCodeType, execCodeWrite, execCodeCall = "", execCodeVersion = "", execCodeCUDate = "", execCodeCreator = "", execCodeGlobalFlag = "", execCodeApplicable = "", execCodeDesc = "", execCodeSubType = "", execCodeDefaultFlag = "") As DHCWL.MKPI.ExecuteCode
{
	b
	n (%this,id,execCodeType,execCodeWrite,execCodeCall,execCodeVersion,execCodeCUDate,execCodeCreator,execCodeGlobalFlag,execCodeApplicable,execCodeDesc,execCodeSubType,execCodeDefaultFlag)
	q:(""=execCodeType) "需要您指定执行代码类型！"
	q:(""=execCodeWrite) "需要您指定执行代码！"
	if (""=$g(id)){
		s obj=##class(DHCWL.MKPI.ExecuteCode).%New()
	}else{
		s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(id)
	}
	s obj.ExeCodeType=$g(execCodeType)
	s obj.ExeCodeWrite=$g(execCodeWrite)
	s obj.ExeCodeCall=$g(execCodeCall)
	s obj.ExeCodeVersion=$g(execCodeVersion)
	s obj.ExcCodeCUDate=$g(execCodeCUDate)
	s obj.ExeCodeCreator=$g(execCodeCreator)
	s obj.ExcCodeGlobalFlag=$g(execCodeGlobalFlag)
	s obj.ExcCodeApplicable=$g(execCodeApplicable)
	s obj.ExcCodeDescription=$g(execCodeDesc)
	s obj.ExcCodeSubType=$g(execCodeSubType)
	s obj.ExcCodeDefaultFlag=$g(execCodeDefaultFlag)
	q obj
}

ClassMethod AssertExistence(obj As DHCWL.MKPI.ExecuteCode) As %Boolean
{
	n (obj)
	q:(""=obj) 0
	s execCodeType=obj.ExeCodeType, execCodeSubType=obj.ExcCodeSubType
	s execCodeWrite=obj.ExeCodeWrite, execCodeVersion=obj.ExeCodeVersion
	q:(""=execCodeType)||(""=execCodeWrite) 0
	s rtnValue=0
	i (""'=execCodeSubType){
		s type=$zcvt(execCodeType,"U"), subType=$zcvt(execCodeSubType,"U")
		i $d(^DHCWL.MKPI.ExecuteCodeI("TypeSubType",type,subType)){
			s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType",type,subType,""))
			do{
				s lastExecCodeWrite=$lg(^DHCWL.MKPI.ExecuteCodeD(rowId),3)
				s lastExecCodeVersion=$lg(^DHCWL.MKPI.ExecuteCodeD(rowId),5)
				s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType",type,subType,rowId))
				continue:(execCodeWrite'=lastExecCodeWrite)||(execCodeVersion'=lastExecCodeVersion)
				s rtnValue=1, rowId=""
			}while(""'=rowId)
		}
	}else{
		//--modify  by wz.2014-3-25
		/*
		s type=$zcvt(execCodeType,"U")
		i $d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type)){
			s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,""))
			do{
				s lastExecCodeWrite=$lg(^DHCWL.MKPI.ExecuteCodeD(rowId),3)
				s lastExecCodeVersion=$lg(^DHCWL.MKPI.ExecuteCodeD(rowId),5)
				s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,rowId))
				continue:(execCodeWrite'=lastExecCodeWrite)||(execCodeVersion'=lastExecCodeVersion)
				s rtnValue=1, rowId=""
			}while(""'=rowId)
		}
		*/
		//++modify by wz.2014-3-25
		s type=$zcvt(execCodeType,"U")
		S execCodeWrite=$zcvt(execCodeWrite,"U")
		S execCodeWrite=" "_execCodeWrite
		i $d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,execCodeWrite)){
			s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,execCodeWrite,""))
			while ((rowId'="") && (rtnValue'=1)) {
				s lastExecCodeVersion=$lg(^DHCWL.MKPI.ExecuteCodeD(rowId),5)
				if (execCodeVersion=lastExecCodeVersion) {
					s rtnValue=1
				}
				s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,execCodeWrite,rowId))
			}
		}
	}
	q rtnValue
}

ClassMethod Insert(obj As DHCWL.MKPI.ExecuteCode) As %Status
{
	n (obj)
	q:(""=obj) "Insert需要一个DHCWL.MKPI.ExecuteCode对象"
	s ^JEFF("me")=obj.ExcCodeCUDate
	q:(##class(DHCWL.SysService.SysExecuteCode).AssertExistence(obj)) "该执行代码已经存在！"
	q obj.%Save()
}

ClassMethod Update(obj As DHCWL.MKPI.ExecuteCode) As %Status
{
	n (Id,obj)
	q:(""=obj) "Update需要一个DHCWL.MKPI.ExecuteCode对象"
	;q:'(##class(DHCWL.SysService.SysExecuteCode).AssertExistence(obj)) "该执行代码不存在！"	;-- modify by wz.2014-3-26
	q obj.%Save()
}

ClassMethod GetObjList(execCodeType = "", execCodeWrite = "", execCodeCall = "", execCodeVersion = "", execCodeCUDate = "", execCodeCreator = "", execCodeGlobalFlag = "", execCodeApplicable = "", execCodeDesc = "", execCodeSubType = "", execCodeDefaultFlag = "") As %ListOfObjects
{
	n (execCodeType,execCodeWrite,execCodeCall,execCodeVersion,execCodeCUDate,execCodeCreator,execCodeGlobalFlag,execCodeApplicable,execCodeDesc,execCodeSubType,execCodeDefaultFlag)
	s objList=##Class(%Library.ListOfObjects).%New()
	
	if (""'=execCodeType){
		if (""'=execCodeSubType){
			s type=$zcvt(execCodeType,"U"), subType=$zcvt(execCodeSubType,"U")
			i $d(^DHCWL.MKPI.ExecuteCodeI("TypeSubType",type,subType)){
				s rowId=""
				do{
					s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType",type,subType,rowId))
					s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(rowId)
					continue:(""=obj)
					continue:((""'=$g(execCodeWrite))&&(obj.ExeCodeWrite'=$g(execCodeWrite)))
					continue:((""'=$g(execCodeCall))&&(obj.ExeCodeCall'=$g(execCodeCall)))
					continue:((""'=$g(execCodeVersion))&&(obj.ExeCodeVersion'=$g(execCodeVersion)))
					continue:((""'=$g(execCodeCUDate))&&(obj.ExcCodeCUDate'=$g(execCodeCUDate)))
					continue:((""'=$g(execCodeCreator))&&(obj.ExeCodeCreator'=$g(execCodeCreator)))
					continue:((""'=$g(execCodeGlobalFlag))&&(obj.ExcCodeGlobalFlag'=$g(execCodeGlobalFlag)))
					continue:((""'=$g(execCodeApplicable))&&(obj.ExcCodeApplicable'=$g(execCodeApplicable)))
					continue:((""'=$g(execCodeDesc))&&(obj.ExcCodeDescription'=$g(execCodeDesc)))
					continue:((""'=$g(execCodeDefaultFlag))&&(obj.ExcCodeDefaultFlag'=$g(execCodeDefaultFlag)))
					i obj.ExcCodeCUDate s obj.ExcCodeCUDate=$zd(obj.ExcCodeCUDate,3)
					d objList.Insert(obj)
				}while(""'=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType",type,subType,rowId)))
			}
		}else{
			s type=$zcvt(execCodeType,"U")
			i $d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type)){
				s rowId=""
				do{
					s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,rowId))
					s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(rowId)
					continue:(""=obj)
					continue:((""'=$g(execCodeWrite))&&(obj.ExeCodeWrite'=$g(execCodeWrite)))
					continue:((""'=$g(execCodeCall))&&(obj.ExeCodeCall'=$g(execCodeCall)))
					continue:((""'=$g(execCodeVersion))&&(obj.ExeCodeVersion'=$g(execCodeVersion)))
					continue:((""'=$g(execCodeCUDate))&&(obj.ExcCodeCUDate'=$g(execCodeCUDate)))
					continue:((""'=$g(execCodeCreator))&&(obj.ExeCodeCreator'=$g(execCodeCreator)))
					continue:((""'=$g(execCodeGlobalFlag))&&(obj.ExcCodeGlobalFlag'=$g(execCodeGlobalFlag)))
					continue:((""'=$g(execCodeApplicable))&&(obj.ExcCodeApplicable'=$g(execCodeApplicable)))
					continue:((""'=$g(execCodeDesc))&&(obj.ExcCodeDescription'=$g(execCodeDesc)))
					continue:((""'=$g(execCodeSubType))&&(obj.ExcCodeSubType'=$g(execCodeSubType)))
					continue:((""'=$g(execCodeDefaultFlag))&&(obj.ExcCodeDefaultFlag'=$g(execCodeDefaultFlag)))
					i obj.ExcCodeCUDate s obj.ExcCodeCUDate=$zd(obj.ExcCodeCUDate,3)
					d objList.Insert(obj)
				}while(""'=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,rowId)))
			}
		}
	}else{
		s rowId=""
		do{
			s rowId=$o(^DHCWL.MKPI.ExecuteCodeD(rowId))
			s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(rowId)
			continue:(""=obj)
			continue:((""'=$g(execCodeType))&&(obj.ExeCodeType'=$g(execCodeType)))
			continue:((""'=$g(execCodeWrite))&&(obj.ExeCodeWrite'=$g(execCodeWrite)))
			continue:((""'=$g(execCodeCall))&&(obj.ExeCodeCall'=$g(execCodeCall)))
			continue:((""'=$g(execCodeVersion))&&(obj.ExeCodeVersion'=$g(execCodeVersion)))
			continue:((""'=$g(execCodeCUDate))&&(obj.ExcCodeCUDate'=$g(execCodeCUDate)))
			continue:((""'=$g(execCodeCreator))&&(obj.ExeCodeCreator'=$g(execCodeCreator)))
			continue:((""'=$g(execCodeGlobalFlag))&&(obj.ExcCodeGlobalFlag'=$g(execCodeGlobalFlag)))
			continue:((""'=$g(execCodeApplicable))&&(obj.ExcCodeApplicable'=$g(execCodeApplicable)))
			continue:((""'=$g(execCodeDesc))&&(obj.ExcCodeDescription'=$g(execCodeDesc)))
			continue:((""'=$g(execCodeSubType))&&(obj.ExcCodeSubType'=$g(execCodeSubType)))
			continue:((""'=$g(execCodeDefaultFlag))&&(obj.ExcCodeDefaultFlag'=$g(execCodeDefaultFlag)))
			i obj.ExcCodeCUDate s obj.ExcCodeCUDate=$zd(obj.ExcCodeCUDate,3)
			d objList.Insert(obj)
		}while(""'=$o(^DHCWL.MKPI.ExecuteCodeD(rowId)))
	}
	q objList
}

/// 	d ##class(DHCWL.SysService.SysExecuteCode).ObjToMetrix(obj,num,.arr)
ClassMethod ObjToMetrix(obj As DHCWL.MKPI.ExecuteCode, num, ByRef arr)
{
	n (obj,num,arr)
	q:(""=obj)||(""=num) ""
	s arr(num,"ExecCodeType")=obj.ExeCodeType
	s execCodewrite=$tr(obj.ExeCodeWrite,"^","∧")
	s arr(num,"ExecCodewrite")=execCodewrite
	s arr(num,"ExecCodeVersion")=obj.ExeCodeVersion
	s execCodeCall=$tr(obj.ExeCodeCall,"^","∧")
	s arr(num,"ExecCodeCall")=execCodeCall
	//i obj.ExcCodeCUDate s obj.ExcCodeCUDate=$zd(obj.ExcCodeCUDate,3)
	i obj.ExcCodeCUDate s obj.ExcCodeCUDate=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(obj.ExcCodeCUDate) 
	s arr(num,"ExecCodeCUDate")=obj.ExcCodeCUDate
	s arr(num,"ExecCodeCreator")=obj.ExeCodeCreator
	s arr(num,"ExecCodeGlobalFlag")=obj.ExcCodeGlobalFlag
	s arr(num,"ExecCodeApplicable")=obj.ExcCodeApplicable
	s arr(num,"ExecCodeDescription")=obj.ExcCodeDescription
	s arr(num,"ExecCodeSubType")=obj.ExcCodeSubType
	s arr(num,"ExecCodeDefaultFlag")=obj.ExcCodeDefaultFlag
	q
}

/// 	s json=##class(DHCWL.SysService.SysExecuteCode).QuerySysExecuteCode("")
ClassMethod QuerySysExecuteCode(execCodeType = "", execCodeWrite = "", execCodeCall = "", execCodeVersion = "", execCodeCUDate = "", execCodeCreator = "", execCodeGlobalFlag = "", execCodeApplicable = "", execCodeDesc = "", execCodeSubType = "", execCodeDefaultFlag = "") As DHCWL.util.Json
{
	n (execCodeType,execCodeWrite,execCodeCall,execCodeVersion,execCodeCUDate,execCodeCreator,execCodeGlobalFlag,execCodeApplicable,execCodeDesc,execCodeSubType,execCodeDefaultFlag)
	k execCodeArr
	
	if (""'=execCodeType){
		if (""'=execCodeSubType){
			//Index TypeSubType On (ExeCodeType, ExcCodeSubType);
			s type=$zcvt(execCodeType,"U"), subType=$zcvt(execCodeSubType,"U")
			s type=" "_type, subType=" "_subType		//++.add by wz.2014-4-8
			i $d(^DHCWL.MKPI.ExecuteCodeI("TypeSubType",type,subType)){
				s num=1
				s rowId=""
				do{
					s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType",type,subType,rowId))
					s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(rowId)
					continue:(""=obj)
					continue:((""'=$g(execCodeWrite))&&(obj.ExeCodeWrite'=$g(execCodeWrite)))
					continue:((""'=$g(execCodeCall))&&(obj.ExeCodeCall'=$g(execCodeCall)))
					continue:((""'=$g(execCodeVersion))&&(obj.ExeCodeVersion'=$g(execCodeVersion)))
					continue:((""'=$g(execCodeCUDate))&&(obj.ExcCodeCUDate'=$g(execCodeCUDate)))
					continue:((""'=$g(execCodeCreator))&&(obj.ExeCodeCreator'=$g(execCodeCreator)))
					continue:((""'=$g(execCodeGlobalFlag))&&(obj.ExcCodeGlobalFlag'=$g(execCodeGlobalFlag)))
					continue:((""'=$g(execCodeApplicable))&&(obj.ExcCodeApplicable'=$g(execCodeApplicable)))
					continue:((""'=$g(execCodeDesc))&&(obj.ExcCodeDescription'=$g(execCodeDesc)))
					continue:((""'=$g(execCodeDefaultFlag))&&(obj.ExcCodeDefaultFlag'=$g(execCodeDefaultFlag)))
					d ##class(DHCWL.SysService.SysExecuteCode).ObjToMetrix(obj,num,.execCodeArr)
					s execCodeArr(num,"ID")=rowId
					s num=num+1
				}while(""'=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType",type,subType,rowId)))
			}
		}else{
			s type=$zcvt(execCodeType,"U")
			i $d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type)){
				s num=1
				//s rowId=""		//--modify by wz.2014-4-7
				s codeWrite=""  	//++modify by wz.2014-4-7
				do{
					s codeWrite=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,codeWrite))
					q:codeWrite=""
					s rowId=""
					f {
						s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,codeWrite,rowId))
						q:rowId=""
						s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(rowId)
						continue:(""=obj)
						continue:((""'=$g(execCodeWrite))&&(obj.ExeCodeWrite'=$g(execCodeWrite)))
						continue:((""'=$g(execCodeCall))&&(obj.ExeCodeCall'=$g(execCodeCall)))
						continue:((""'=$g(execCodeVersion))&&(obj.ExeCodeVersion'=$g(execCodeVersion)))
						continue:((""'=$g(execCodeCUDate))&&(obj.ExcCodeCUDate'=$g(execCodeCUDate)))
						continue:((""'=$g(execCodeCreator))&&(obj.ExeCodeCreator'=$g(execCodeCreator)))
						continue:((""'=$g(execCodeGlobalFlag))&&(obj.ExcCodeGlobalFlag'=$g(execCodeGlobalFlag)))
						continue:((""'=$g(execCodeApplicable))&&(obj.ExcCodeApplicable'=$g(execCodeApplicable)))
						continue:((""'=$g(execCodeDesc))&&(obj.ExcCodeDescription'=$g(execCodeDesc)))
						continue:((""'=$g(execCodeSubType))&&(obj.ExcCodeSubType'=$g(execCodeSubType)))
						continue:((""'=$g(execCodeDefaultFlag))&&(obj.ExcCodeDefaultFlag'=$g(execCodeDefaultFlag)))
						d ##class(DHCWL.SysService.SysExecuteCode).ObjToMetrix(obj,num,.execCodeArr)
						s execCodeArr(num,"ID")=rowId
						s num=num+1	
										
					}
					//ExcCodeTypeI On (ExeCodeType As AlphaUp, ExeCodeWrite);
					/*
					s rowId=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,rowId))
					s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(rowId)
					continue:(""=obj)
					continue:((""'=$g(execCodeWrite))&&(obj.ExeCodeWrite'=$g(execCodeWrite)))
					continue:((""'=$g(execCodeCall))&&(obj.ExeCodeCall'=$g(execCodeCall)))
					continue:((""'=$g(execCodeVersion))&&(obj.ExeCodeVersion'=$g(execCodeVersion)))
					continue:((""'=$g(execCodeCUDate))&&(obj.ExcCodeCUDate'=$g(execCodeCUDate)))
					continue:((""'=$g(execCodeCreator))&&(obj.ExeCodeCreator'=$g(execCodeCreator)))
					continue:((""'=$g(execCodeGlobalFlag))&&(obj.ExcCodeGlobalFlag'=$g(execCodeGlobalFlag)))
					continue:((""'=$g(execCodeApplicable))&&(obj.ExcCodeApplicable'=$g(execCodeApplicable)))
					continue:((""'=$g(execCodeDesc))&&(obj.ExcCodeDescription'=$g(execCodeDesc)))
					continue:((""'=$g(execCodeSubType))&&(obj.ExcCodeSubType'=$g(execCodeSubType)))
					continue:((""'=$g(execCodeDefaultFlag))&&(obj.ExcCodeDefaultFlag'=$g(execCodeDefaultFlag)))
					d ##class(DHCWL.SysService.SysExecuteCode).ObjToMetrix(obj,num,.execCodeArr)
					s execCodeArr(num,"ID")=rowId
					s num=num+1
					*/
					
				}while(""'=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI",type,rowId)))
			}
		}
	}else{
		s num=1
		s rowId=""
		do{
			s rowId=$o(^DHCWL.MKPI.ExecuteCodeD(rowId))
			s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(rowId)
			continue:(""=obj)
			continue:((""'=$g(execCodeType))&&(obj.ExeCodeType'=$g(execCodeType)))
			continue:((""'=$g(execCodeWrite))&&(obj.ExeCodeWrite'=$g(execCodeWrite)))
			continue:((""'=$g(execCodeCall))&&(obj.ExeCodeCall'=$g(execCodeCall)))
			continue:((""'=$g(execCodeVersion))&&(obj.ExeCodeVersion'=$g(execCodeVersion)))
			continue:((""'=$g(execCodeCUDate))&&(obj.ExcCodeCUDate'=$g(execCodeCUDate)))
			continue:((""'=$g(execCodeCreator))&&(obj.ExeCodeCreator'=$g(execCodeCreator)))
			continue:((""'=$g(execCodeGlobalFlag))&&(obj.ExcCodeGlobalFlag'=$g(execCodeGlobalFlag)))
			continue:((""'=$g(execCodeApplicable))&&(obj.ExcCodeApplicable'=$g(execCodeApplicable)))
			continue:((""'=$g(execCodeDesc))&&(obj.ExcCodeDescription'=$g(execCodeDesc)))
			continue:((""'=$g(execCodeSubType))&&(obj.ExcCodeSubType'=$g(execCodeSubType)))
			continue:((""'=$g(execCodeDefaultFlag))&&(obj.ExcCodeDefaultFlag'=$g(execCodeDefaultFlag)))
			d ##class(DHCWL.SysService.SysExecuteCode).ObjToMetrix(obj,num,.execCodeArr)
			s execCodeArr(num,"ID")=rowId
			s num=num+1
		}while(""'=$o(^DHCWL.MKPI.ExecuteCodeD(rowId)))
	}
	q:($d(execCodeArr)) ##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.execCodeArr)
	q ""
}

ClassMethod GetExecuteCodeType() As %String
{
	q "['',''],['指标','KPI'],['维度属性','DIM'],['任务','TAS'],['区间','SEC']"
}

/// 描述: 检查特定类型及子类型的执行代码的默认执行标志是否是Y。
/// 参数: 	obj		任务执行代码对象
/// 	 	
/// 返回类型：	字符串
/// 返回值：	如果已存在默认执行代码为Y的就返回提示信息，否则返回“”
/// 编写者： 王峥
/// 编写日期:2014-4-15
/// s a=##class(DHCWL.Interface.Module).CreateReportKpiData(2,"2013-1-1","2013-1-10")
ClassMethod CheckedDefExeFlag(id As %String, obj As DHCWL.MKPI.ExecuteCode) As %String
{
	n (id,obj)
	s ret=""
	s bFlag=0
	s exeCodeType=obj.ExeCodeType
	s excCodeSubType=obj.ExcCodeSubType
	s excCodeDefaultFlag=obj.ExcCodeDefaultFlag
	s exeCodeWrite=obj.ExeCodeWrite
	s exeCodeType=$zcvt(exeCodeType,"U"), excCodeSubType=$zcvt(excCodeSubType,"U")
	q:(excCodeDefaultFlag'="Y") ret
	q:'$d(^DHCWL.MKPI.ExecuteCodeI("TypeSubType"," "_exeCodeType," "_excCodeSubType)) ret
	s rowid=""
	f {
		s rowid=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType"," "_exeCodeType," "_excCodeSubType,rowid))
		q:$g(rowid)=""
		q:ret'=""
		s defFlag=$lg(^DHCWL.MKPI.ExecuteCodeD(rowid),12)
		if ((defFlag="Y") && (id'=rowid)) s ret="在类型且子类型相同的执行代码中，只能存在一个是默认执行代码！"
	}
	q ret
}

}
