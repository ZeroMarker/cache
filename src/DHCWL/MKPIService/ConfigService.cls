/// 名称: DHCWL.MKPIService.ConfigService
/// 描述: 对各个配置表的维护操作
/// 编写者：ban
/// 编写日期:2012-03-30
/// 
Class DHCWL.MKPIService.ConfigService Extends %RegisteredObject [ Not ProcedureBlock ]
{

//w ##class(DHCWL.MKPIService.ConfigService).InsertMonth("200901","2009-01","2009年1月","2009-01-01","2009-01-31","","","Y","2","")   

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 插入表DHCWL_MKPI.DHCWLKPIMonths操作
/// Table：       DHCWL_MKPI.DHCWLKPIMonths
/// Input：       code:代码,name:名称,desc:描述,startDate:区间开始日期,endDate:区间结束日期,user:操作用户,remark:备注,calFlag:计算标志,section:对应区间,monthDr:汇总区间
/// Output：      
/// Return：      成功返回1,否则返回0
/// Others：   
ClassMethod InsertMonth(code, name, desc, startDate, endDate, user, remark, calFlag, section, monthDr) As %Status
{
	n (code, name, desc, startDate, endDate, user, remark, calFlag, section, monthDr) 
	s startDate=$s(+startDate=0:"",1:$zdh(startDate,3))
	s endDate=$s(+endDate=0:"",1:$zdh(endDate,3))
	
	s PLIST(2)=code	//KPIM_Code
	s PLIST(3)=name	//KPIM_Name
	s PLIST(4)=desc	//KPIM_Desc
	s PLIST(5)=startDate	//KPIM_StartDate
	s PLIST(6)=endDate	//KPIM_EndDate
	s PLIST(7)=user	//KPIM_User
	s PLIST(8)=+$h	//KPIM_UpdateDate
	s PLIST(9)=remark	//KPIM_Remark
	s PLIST(10)=calFlag	//KPIM_CalFlag
	s PLIST(11)=section	//KPIM_SectionFlag
	s PLIST(12)=monthDr	//KPIM_Month_Dr
	
	&sql(insert into DHCWL_MKPI.DHCWLKPIMonths
	(KPIM_Code, KPIM_Name, KPIM_Desc, KPIM_StartDate, KPIM_EndDate, KPIM_User, 
	KPIM_UpdateDate, KPIM_Remark,KPIM_CalFlag, KPIM_SectionFlag, KPIM_Month_Dr) 
	values(:code,:name,:desc,:startDate,:endDate,:user
	,:PLIST(8),:remark,:calFlag,:section,:monthDr))
	
	;i code="2008Q4" b
	;&sql(insert into DHCWL_MKPI.DHCWLKPIMonths values PLIST())	
	q:SQLCODE=0 1
	q 0
}

//w ##class(DHCWL.MKPIService.ConfigService).GetMonthByCode("200801") 

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 根据代码获取区间id
/// Table：       DHCWL_MKPI.DHCWLKPIMonths
/// Input：       code:代码
/// Output：      
/// Return：      成功返回区间id,否则返回0
/// Others：
ClassMethod GetMonthByCode(code) As %String
{
	n (code)
	q ##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(code,"DHCWL.MKPI.Months")
	q:code="" 0
	q:('$d(^DHCWL.MKPI.MonthsI("Code",code)))&&('$d(^DHCWL.MKPI.MonthsI("Code"," "_code))) 0	
	s monthId=$o(^DHCWL.MKPI.MonthsI("Code",code,""))
	i monthId="" s monthId=$o(^DHCWL.MKPI.MonthsI("Code"," "_code,""))
	q monthId
}

//w ##class(DHCWL.MKPIService.ConfigService).GetMonthStrByCode("200811,200812")

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 根据代码获取区间id的串,用","分隔
/// Table：       DHCWL_MKPI.DHCWLKPIMonths
/// Input：       nameStr:名称串,用","分隔
/// Output：      
/// Return：      成功返回区间id串,否则返回""
/// Others：
ClassMethod GetMonthStrByCode(codeStr) As %String
{
	n (codeStr)
	s monthStr=""
	q:codeStr="" monthStr
	s codeLen=$l(codeStr,",")
	f len=1:1:codeLen d
	.s code=$p(codeStr,",",len)	
	.s monthId=..GetMonthByCode(code)
	.q:+monthId=0
	.i monthStr="" s monthStr=monthId
	.e  s monthStr=monthStr_","_monthId
	q monthStr
}

//w ##class(DHCWL.MKPIService.ConfigService).GetMonthByName("2009-01")

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 根据名称获取区间id
/// Table：       DHCWL_MKPI.DHCWLKPIMonths
/// Input：       name:名称
/// Output：      
/// Return：      成功返回区间id,否则返回0
/// Others：
ClassMethod GetMonthByName(name) As %String
{
	
	n (name)
	q ##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(name,"DHCWL.MKPI.Months")
	q:name="" 0
	q:('$d(^DHCWL.MKPI.MonthsI("Name"," "_name)))&&('$d(^DHCWL.MKPI.MonthsI("Name",name))) 0	
	s monthId=$o(^DHCWL.MKPI.MonthsI("Name",name,""))
	i monthId="" s monthId=$o(^DHCWL.MKPI.MonthsI("Name"," "_name,""))
	
	q monthId
}

//w ##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName("2008-11,2008-12")

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 根据名称获取区间id的串,用","分隔
/// Table：       DHCWL_MKPI.DHCWLKPIMonths
/// Input：       nameStr:名称串,用","分隔
/// Output：      
/// Return：      成功返回区间id串,否则返回""
/// Others：
ClassMethod GetMonthStrByName(nameStr) As %String
{
	n (nameStr)
	s monthStr=""
	q:nameStr="" monthStr
	s nameLen=$l(nameStr,",")
	f len=1:1:nameLen d
	.s name=$p(nameStr,",",len)	
	.s monthId=..GetMonthByName(name)
	.q:+monthId=0
	.i monthStr="" s monthStr=monthId
	.e  s monthStr=monthStr_","_monthId
	q monthStr
}

//w ##class(DHCWL.MKPIService.ConfigService).GetKPIByName(" MZDocGhf--_@#te st人")

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 根据代码获取KPI id
/// Table：       DHCWL.MKPI.MKPI
/// Input：       code:kpi代码
/// Output：      
/// Return：      成功返回区间id,否则返回0
/// Others：
ClassMethod GetKPIByName(code) As %String
{
	
	n (code)
	q ##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(code,"DHCWL.MKPI.MKPI")  //用此方法替代@20130530
	q:code="" 0
	i $d(^DHCWL.MKPI.MKPID(code)) q code
	s code=$zcvt(code,"U")
	q:'$d(^DHCWL.MKPI.MKPII("MKPICode"," "_code))&&('$d(^DHCWL.MKPI.MKPII("MKPICode",code))) 0	
	s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICode",code,""))
	i kpiId="" s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICode"," "_code,""))
	
	q kpiId
}

ClassMethod GetKPIByDes(desc) As DHCWL.MKPI.MKPI
{
	
	n (desc)
	q:desc="" 0
	s flag=0
	s id=0 f  s id=$o(^DHCWL.MKPI.MKPID(id)) q:id=""  d
	.s kpi=##class(DHCWL.MKPI.MKPI).%OpenId(id)
	.s kpiDes=kpi.MKPIDesc
	.i kpiDes=desc s flag=1 q
	i flag q kpi  e  q ""
	q:'$d(^DHCWL.MKPI.MKPII("MKPICode"," "_code))&&('$d(^DHCWL.MKPI.MKPII("MKPICode",code))) 0	
	s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICode",code,""))
	i kpiId="" s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICode"," "_code,""))
	
	q kpiId
}

/// w ##class(DHCWL.MKPIService.ConfigService).GetDimIdByCode("RegLocOpNums")
ClassMethod GetDimIdByCode(code) As %String
{
	n (code)
	q:code="" ""
	q:$d(^DHCWL.MKPI.MKPIDimTypeD(code)) code
	s code=$zcvt(code,"U")
	q $o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",code,""))
}

/// w ##class(DHCWL.MKPIService.ConfigService).GetDimProIdByCode("RegLocOpNums")
ClassMethod GetDimProIdByCode(code) As %String
{
	n (code)
	q:code="" ""
	q ##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(code,"DHCWL.MKPI.DimProperty")
	q:$d(^DHCWL.MKPI.DimPropertyD(code)) code
	s code=$zcvt(code,"U")
	q $o(^DHCWL.MKPI.DimPropertyI("CodeI",code,""))
}

//w ##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode("RegLocOpNums,RegDocOpNums")

/// Creator：      ban
/// CreatDate：    2012-07-05
/// Description:： 根据代码获取指标id的串,用","分隔
/// Table：       DHCWL_MKPI.DHCWLMKPI
/// Input：       codeStr:kpi代码串,用","分隔
/// Output：      
/// Return：      成功返回kpi id串,否则返回""
/// Others：
ClassMethod GetKPIIdStrByCode(codeStr) As %String
{
	n (codeStr) 
	q:codeStr="" ""
	s codeLen=$l(codeStr,",")
	s kpiStr=""
	f len=1:1:codeLen d
	.s code=$p(codeStr,",",len)
	.s kpiId=..GetKPIByName(code)
	.q:+kpiId=0
	.i kpiStr="" s kpiStr=kpiId
	.e  s kpiStr=kpiStr_","_kpiId
	q kpiStr
}

/// w ##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.sec)
/// Creator：      lhh
/// CreatDate：    2013-02-23
/// Description:： 返回区间为由粗到细的粒度顺序
/// Table：       DHCWL_MKPI.DHCWLSECTION
/// Input：       
/// Output：      若区间顺序维护正确，返回1，反正返回0。sec数组为返回的区间由粗粒度到细粒度的详细
/// Others：
ClassMethod GetSectionMaxToMin(ByRef sec) As %Integer
{
	n (sec)
	s list="",num=0
	s secId=""  f  s secId=$o(^DHCWL.MKPI.SectionD(secId)) q:secId=""  d
	.s num=num+1
	.s parentId=$lg(^DHCWL.MKPI.SectionD(secId),8,"")
	.s:parentId=$c(0) parentId=""
	.s list(secId,"P")=$g(parentId),list("POS",secId)=0,list("WZ",num,secId,"P")=$g(parentId)
	s headNode=0,tailNode=0,wrongFlag=0
	f i=1:1:num {
		s node=$o(list("WZ",i,""))
		if (list("WZ",i,node,"P")="")||(list("WZ",i,node,"P")=$c(0))||(list("WZ",i,node,"P")=0) {
			i tailNode'=0 {
				s wrongFlag=1
				q
			}
			s tailNode=node
		}
		s parentId=list("WZ",i,node,"P")
		i (parentId'="")&&($d(list("POS",parentId))&&(parentId'=0)) {
			s list("POS",parentId)=list("POS",parentId)+1
		}
	}
	q:wrongFlag=1 0
	q:tailNode=0 0
	s i=0
	f {
		s i=$o(list("POS",i))
		q:i=""
		i list("POS",i)=0 {
			i headNode'=0 {
				s wrongFlag=1
				q
			}
			s headNode=i
		}
	}
	q:wrongFlag=1 0
	q:headNode=0 0
	s node=headNode,level=num,nodeNum=1
	//头节点和尾节点找到后开始遍历list
	d {
		s pre=node
		s node=list(node,"P")
		s sec(level,pre,"P")=node
		s sec(level,pre,"C")=$lg(^DHCWL.MKPI.SectionD(pre),2,"")
		s sec(level,pre,"N")=$lg(^DHCWL.MKPI.SectionD(pre),4,"")
		//add by wz.2014-4-10
		s exeSubType=sec(level,pre,"C")
		s sec(level,pre,"E")=..GetDefExeCode("TAS",exeSubType)
		
		s level=level-1,nodeNum=nodeNum+1
	}while((node'=0)&&(node'=""))
	q (nodeNum-1)=num
}

//d ##class(DHCWL.MKPIService.ConfigService).ClearKPISYSConfigData()

/// Creator：      ban
/// CreatDate：    2012-04-01
/// Description:： 清除KPI相关维护区间以及汇总数据
/// Table：       DHCWL_MKPI.DHCWLKPIMonths,DHCWL.MKPI.DeptKPIData,DHCWL.MKPI.MKPIData
/// Input：       
/// Output：      
/// Return：      
/// Others：
ClassMethod ClearKPISYSConfigData() As %Status
{
	;k ^DHCWL.MKPI.SectionD
	;k ^DHCWL.MKPI.SectionI
	;k ^DHCWL.MKPI.MonthsD
	;k ^DHCWL.MKPI.MonthsI
	;k ^DHCWL.MKPI.MKPIFLD
	;k ^DHCWL.MKPI.MKPIFLI
	;k ^DHCWL.MKPI.MKPID
	;k ^DHCWL.MKPI.MKPII
	;k ^DHCWL.MKPI.MKPIDimTypeD
 	;k ^DHCWL.MKPI.MKPIDimTypeI
	k ^DHCWL.MKPI.MKPIDataD
	k ^DHCWL.MKPI.MKPIDataI
    k ^DHCWL.MKPI.DeptKPIDataD
	k ^DHCWL.MKPI.DeptKPIDataI
	;k ^DHCWL.MKPI.CreatDataTaskD
	;k ^DHCWL.MKPI.CreatDataTaskI
	
	q 1
}

/// Creator：      wangzheng
/// CreatDate：    2014-04-10
/// Description:： 得到默认执行代码
/// Table：       
/// Input：       
/// Output：      
/// Return：      
/// Others：
/// d ##class(DHCWL.MKPIService.ConfigService).GetDefExeCode("TAS","D")
ClassMethod GetDefExeCode(exeType As %String, exeSubType As %String) As %String
{
	n (exeType,exeSubType)
	s defCodeID=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType"," "_exeType," "_exeSubType,""))
	s version=-1
	s ret=""
	f {
		q:$g(defCodeID)=""
		if ($lg(^DHCWL.MKPI.ExecuteCodeD(defCodeID),12,"")="Y") {
			s vsn=$lg(^DHCWL.MKPI.ExecuteCodeD(defCodeID),5,"0")
			if +$g(vsn)>version {
				s version=vsn
				s ret=$lg(^DHCWL.MKPI.ExecuteCodeD(defCodeID),3,"")
			}
		}
		s defCodeID=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType"," "_exeType," "_exeSubType,defCodeID))
	}
	q ret
}

}
