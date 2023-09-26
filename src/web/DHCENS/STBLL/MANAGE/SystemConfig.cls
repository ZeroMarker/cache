Class web.DHCENS.STBLL.MANAGE.SystemConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.MANAGE.SystemConfig).HospitalDict()
ClassMethod HospitalDict(Input As %String = "") As %String
{
	s $ZT="Err"
	if Input=""
	{
	s sql="select * from SQLUser.CT_Hospital"
	s rset=##class(%ResultSet).%New()
	d rset.Prepare(sql)
	s sc=rset.Execute()
	i $$$ISERR(sc) {
		s arr=##class(%DynamicArray).%New()
		s ret=arr.%ToJSON()
		q ret
		}
	s arr=##class(%DynamicArray).%New()
	While(rset.Next())   {
		s code=rset.Data("HOSP_Code")
		s desc=rset.Data("HOSP_Desc")
		s obj=##class(%DynamicObject).%New()
		s obj.code=code
		s obj.desc=desc
		d arr.%Push(obj)
		}
	}
	else
	{
		s len=$l(Input,",")
		s code1=""
		for i=1:1:len
		{
			s code=$p(Input,",",i)
			if code1="" s code1="'"_code_"'"
			else  s code1=code1_","_"'"_code_"'"
		}
		s sql="SELECT CTLOC_Hospital_DR FROM ct_loc WHERE ctloc_code IN("_code1_") GROUP BY CTLOC_Hospital_DR "
		s rset=##class(%ResultSet).%New()
		d rset.Prepare(sql)
		s sc=rset.Execute()
		i $$$ISERR(sc) {
			s arr=##class(%DynamicArray).%New()
			s ret=arr.%ToJSON()
			q ret
		}
		s arr=##class(%DynamicArray).%New()
		s num=0,hospCode="",hospDesc=""
		While(rset.Next())   {	
			s num=num+1
			s hospDr=rset.Data("CTLOC_Hospital_DR")
			s:hospDr'="" hospCode=$p($g(^CT("HOSP",hospDr)),"^",1)
			s:hospDr'="" hospDesc=$p($g(^CT("HOSP",hospDr)),"^",2)
		}
		if num=1
		{
			s arr=##class(%DynamicArray).%New()
			s obj=##class(%DynamicObject).%New()
			s obj.code=hospCode
			s obj.desc=hospDesc
			d arr.%Push(obj)
		}
		else
		{
			q "[]"
		}
	}

	q arr.%ToJSON()
Err
	s arr=##class(%DynamicArray).%New()
	s ret=arr.%ToJSON()
	q ret
}

/// w ##class(web.DHCENS.STBLL.MANAGE.SystemConfig).WorkGroupDict()
ClassMethod WorkGroupDict() As %String
{
	s $ZT="Err"
	s sql="select * from SQLUser.Ens_WorkGroup"
	s rset=##class(%ResultSet).%New()
	d rset.Prepare(sql)
	s sc=rset.Execute()
	i $$$ISERR(sc) {
		s arr=##class(%DynamicArray).%New()
		s ret=arr.%ToJSON()
		q ret
		}
	s arr=##class(%DynamicArray).%New()
	While(rset.Next())   {
		s code=rset.Data("workGroup_Code")
		s desc=rset.Data("workGroup_Desc")
		s obj=##class(%DynamicObject).%New()
		s obj.code=code
		s obj.desc=desc
		d arr.%Push(obj)
		}
	q arr.%ToJSON()
Err
	s arr=##class(%DynamicArray).%New()
	s ret=arr.%ToJSON()
	q ret
}

/// Input：desc^hospital^mode^status
/// Description：系统配置信息查询
/// Table：User.EnsApiSysConfig
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.MANAGE.SystemConfig","SystemConfigData","^^all^Y")
Query SystemConfigData(Input As %String = "") As %Query(ROWSPEC = "systemcode:%String,systemdesc:%String,systemversion:%String,hospital:%String,systemmode:%String,workgroup:%String,status:%String,deptcode:%String,deptdesc:%String")
{
}

ClassMethod SystemConfigDataExecute(ByRef QHandle As %Binary, Input As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	s systemcode="",systemdesc="",systemversion="",hospital="",systemmode="",workgroup="",status=""
	s conditionSysDesc=$p(Input,"^",1)
	s conditionHospital=$p(Input,"^",2)
	s conditionSysMode=$p(Input,"^",3)
	s conditionStatus=$p(Input,"^",4)
	s conditionStr=""
	if conditionSysDesc'=""  s sc=..GetCondition(.conditionStr,"system_Desc",conditionSysDesc,"=")
	if (conditionHospital'="")&&(conditionHospital'="all")  s sc=..GetCondition(.conditionStr,"system_Hospital",conditionHospital,"=")
	if (conditionSysMode'="")&&(conditionSysMode'="all")   s sc=..GetCondition(.conditionStr,"system_DBMode",conditionSysMode,"=")
	if (conditionStatus'="")&&(conditionStatus'="all")  s sc=..GetCondition(.conditionStr,"system_Status",conditionStatus,"=")
	s sql="select system_Code,system_Desc,system_Version,system_Hospital,system_DBMode,system_WorkGroup,system_Status,system_DeptCode from SQLUser.Ens_ApiSysConfig"
	if conditionStr'="" s sql=sql_" "_conditionStr
	s ^TempRecord("sql")=sql
	s rset=##class(%ResultSet).%New()
	d rset.Prepare(sql)
	s sc=rset.Execute()
	i $$$ISERR(sc) {
		s arr=##class(%DynamicArray).%New()
		s ret=arr.%ToJSON()
		q ret
		}
	s arr=##class(%DynamicArray).%New()
	While(rset.Next())   {
		s systemcode=rset.Data("system_Code")
		s systemdesc=rset.Data("system_Desc")
		s systemversion=rset.Data("system_Version")
		s hospital=rset.Data("system_Hospital")
		s systemmode=rset.Data("system_DBMode")
		s workgroup=rset.Data("system_WorkGroup")
		s status=rset.Data("system_Status")
		s deptcodelist=rset.Data("system_DeptCode")
		s len=$LENGTH(deptcodelist,",")
		s deptdesclist=""
		f i=1:1:len {
			s deptcode=$p(deptcodelist,",",i)
			continue:deptcode=""
			s ctlocrowid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(deptcode),""))
			continue:+ctlocrowid=0
			s deptdesc=$p($g(^CTLOC(ctlocrowid)),"^",2)
			if deptdesclist'="" s deptdesclist=deptdesclist_","_deptdesc
			else  s deptdesclist=deptdesc
			}
		set ^CacheTemp(repid,ind)=$lb(systemcode,systemdesc,systemversion,hospital,systemmode,workgroup,status,deptcodelist,deptdesclist)
		set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod SystemConfigDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = SystemConfigDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SystemConfigDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SystemConfigDataExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 系统代码^系统描述^版本^院区^模式^产品组^状态^科室代码
/// PIS^病理^v1.0^DHSZHYYZY^C-PIS^Y^ZYYJ013
/// w ##class(web.DHCENS.STBLL.MANAGE.SystemConfig).SystemConfig("liytest1^liy测试1^^2^分库^1^Y^")
ClassMethod SystemConfig(Input As %String = "") As %String
{
	s $ZT="Err"
	s systemCode=$p(Input,"^",1)
	s systemDesc=$p(Input,"^",2)
	s systemVersion=$p(Input,"^",3)
	s hospital=$p(Input,"^",4)
	s systemMode=$p(Input,"^",5)
	s workGroup=$p(Input,"^",6)
	s status=$p(Input,"^",7)
	s deptcode=$p(Input,"^",8)
	s deptcode=$Replace($Replace($Replace(deptcode,"[",""),"]",""),$c(34),"")
	if systemVersion="" s systemVersion="Default"
	s sc=1
	if $D(^Config.ENS.EnsApiSysConfigI("PKSystemConfig",systemCode,hospital,systemVersion)) {
		s rowid=$o(^Config.ENS.EnsApiSysConfigI("PKSystemConfig",systemCode,hospital,systemVersion,""))
		s systemObj=##class(User.EnsApiSysConfig).%OpenId(rowid)
		s systemObj.systemDesc=systemDesc
		s systemObj.systemDBMode=systemMode
		s systemObj.systemWorkGroup=workGroup
		s systemObj.systemStatus=status
		s systemObj.systemDeptCode=deptcode
		s sc=systemObj.%Save()
		if sc'=1 s message=$SYSTEM.Status.GetErrorText(sc)
		else  s message="更新成功"
		s retObj=##class(%Library.DynamicObject).%New()
		s retObj.retval=+sc
		s retObj.retinfo=message
		s ret=retObj.%ToJSON()
		}
	else {
		s systemObj=##class(User.EnsApiSysConfig).%New()
		s systemObj.systemCode=systemCode
		s systemObj.systemDesc=systemDesc
		if systemVersion'="" s systemObj.systemVersion=systemVersion
		s systemObj.systemHospital=hospital
		s systemObj.systemDBMode=systemMode
		s systemObj.systemWorkGroup=workGroup
		s systemObj.systemStatus=status
		s systemObj.systemDeptCode=deptcode
		s sc=systemObj.%Save()
		if (sc=1)&&(systemMode="分库") {
			s functionObj=##class(User.EnsSubApiSysConfig).%New()
			s functionObj.systemCode=systemCode
			s functionObj.systemHospital=hospital
			if systemVersion'="" s functionObj.systemVersion=systemVersion
			s functionObj.systemFuncCode="DefaultFunction"
			s functionObj.systemFuncDesc="默认功能"
			s sc1=functionObj.%Save()
			if sc1'=1 s sc=sc1
			}
		if sc'=1 s message=$SYSTEM.Status.GetErrorText(sc)
		else  s message="写入成功"
		s retObj=##class(%Library.DynamicObject).%New()
		s retObj.retval=+sc
		s retObj.retinfo=message
		s ret=retObj.%ToJSON()
		}
	q ret
Err
	s retObj=##class(%Library.DynamicObject).%New()
	s retObj.retval=-1
	s retObj.retinfo=$SYSTEM.Status.GetErrorText($ZE)
	s ret=retObj.%ToJSON()
	q ret
}

ClassMethod GetCondition(ByRef conditionStr As %String, colName As %String, colValue As %String, type As %String) As %String
{
	set $zt="Exception"
	/// 对所有的条件进行去空格服务和替换null值
	set value=$tr(colValue,$c(0),"")
	set value=$replace(value,"null","")
	set value=$replace(value,"NULL","")
	set type=$zcvt(type,"L")
	if (colName="")
	{
		Quit 0_"^未输入字段名称"
	}
	if (value="")
	{
		Quit 0_"^入参为空"
	}
	if type="in" {
		set value=$replace(value,"||","','")
		set value="('"_value_"')"
	}
	elseif type="like"{
		s value="'%"_value_"%'"
	}else {
		set value="'"_value_"'"
		}
	if (conditionStr="")
	{
		set conditionStr="where"_" "_colName_" "_type_" "_value
	}else{
		set conditionStr=conditionStr_" and"_" "_colName_" "_type_" "_value
		
	}
	Quit 1	
Exception	
	Quit 0
}

/// w ##class(web.DHCENS.STBLL.MANAGE.SystemConfig).SystemList()
ClassMethod SystemList() As %String
{
	s $ZT="Err"
	s arr=##class(%Library.DynamicArray).%New()
	s desc=""
	f {
		s desc=$o(^Config.ENS.EnsApiSysConfigI("systemDescIndex",desc))
		q:desc=""
		s obj=##class(%Library.DynamicObject).%New()
		s obj.desc=desc
		d arr.%Push(obj)
		}
	q arr.%ToJSON()
Err
	s arr=##class(%Library.DynamicArray).%New()
	s ret=arr.%ToJSON()
	q ret
}

/// w ##class(web.DHCENS.STBLL.MANAGE.SystemConfig).EnsSystemList()
ClassMethod EnsSystemList() As %String
{
	s sysrowid=""
	s arr=##class(%Library.DynamicArray).%New()
	f {
		s sysrowid=$o(^Config.ENS.EnsSystemD(sysrowid))
		q:sysrowid=""
		s syscode=$LG(^Config.ENS.EnsSystemD(sysrowid),2)
		s sysdesc=$LG(^Config.ENS.EnsSystemD(sysrowid),3)
		s sysstatus=$LG(^Config.ENS.EnsSystemD(sysrowid),4)
		continue:sysstatus'="Y"
		s obj=##class(%Library.DynamicObject).%New()
		s obj.code=syscode
		s obj.desc=sysdesc
		d arr.%Push(obj)
		}
	q arr.%ToJSON()
}

/// w ##class(web.DHCENS.STBLL.MANAGE.SystemConfig).CTLocList()
ClassMethod CTLocList(Input As %String = "") As %String
{
	s deptrowid=""
	s arr=##class(%Library.DynamicArray).%New()
	f {
		s deptrowid=$o(^CTLOC(deptrowid))
		q:deptrowid=""
		s HospDr=$p($g(^CTLOC(deptrowid)),"^",22),HospCode=""
		s:HospDr'="" HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
		continue:(Input'="")&&(Input'=HospCode)
		s depttypecode=$p($g(^CTLOC(deptrowid)),13)
		continue:(depttypecode="D")||(depttypecode="DI")||(depttypecode="C")||(depttypecode="O")
		s deptcode=$p($g(^CTLOC(deptrowid)),"^",1)
		s deptdesc=$p($g(^CTLOC(deptrowid)),"^",2)
		continue:(deptcode="")||(deptdesc="")
		s obj=##class(%Library.DynamicObject).%New()
		s obj.code=deptcode
		s obj.desc=deptdesc
		d arr.%Push(obj)
		}
	q arr.%ToJSON()
}

/// w ##class(web.DHCENS.STBLL.MANAGE.SystemConfig).TargetList()
ClassMethod TargetList() As %String
{
	s sysfuncrowid=""
	s arr=##class(%Library.DynamicArray).%New()
	f {
		s sysfuncrowid=$o(^Config.ENS.EnsSubApiSysConfigD(sysfuncrowid))
		q:sysfuncrowid=""
		s systemcode=$LG(^Config.ENS.EnsSubApiSysConfigD(sysfuncrowid),2)
		s hospital=$LG(^Config.ENS.EnsSubApiSysConfigD(sysfuncrowid),3)
		s systemversion=$LG(^Config.ENS.EnsSubApiSysConfigD(sysfuncrowid),4)
		s sysfunccode=$LG(^Config.ENS.EnsSubApiSysConfigD(sysfuncrowid),5)
		s sysfuncdesc=$LG(^Config.ENS.EnsSubApiSysConfigD(sysfuncrowid),6)
		continue:(systemcode="")||(hospital="")||(systemversion="")
		s apisysrowid=$o(^Config.ENS.EnsApiSysConfigI("PKSystemConfig",systemcode,hospital,systemversion,""))
		continue:+apisysrowid=0
		s apisysstatus=$LG(^Config.ENS.EnsApiSysConfigD(apisysrowid),8)
		continue:apisysstatus'="Y"
		s apisysdesc=$LG(^Config.ENS.EnsApiSysConfigD(apisysrowid),3)
		s sysdbmode=$LG(^Config.ENS.EnsApiSysConfigD(apisysrowid),6)
		s obj=##class(%Library.DynamicObject).%New()
		s obj.rowid=sysfuncrowid
		s obj.code=systemcode
		s obj.desc=apisysdesc
		s obj.functioncode=sysfunccode
		s obj.functiondesc=sysfuncdesc
		s obj.hospital=hospital
		s obj.version=systemversion
		s obj.mode=sysdbmode
		d arr.%Push(obj)
		}
	q arr.%ToJSON()
}

/// Input：desc^hospital^mode^status
/// Description：系统功能配置查询
/// Table：User.EnsSubApiSysConfig
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.MANAGE.SystemConfig","SysFunctionData","systemcode^hospital^version")
Query SysFunctionData(Input As %String = "") As %Query(ROWSPEC = "functioncode:%String,functiondesc:%String")
{
}

ClassMethod SysFunctionDataExecute(ByRef QHandle As %Binary, Input As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	s systemcode="",hospital="",systemversion=""
	s systemcode=$p(Input,"^",1)
	s hospital=$p(Input,"^",2)
	s systemversion=$p(Input,"^",3)
	q:(systemcode="")||(hospital="")||(systemversion="") $$$OK
	s functioncode=""
	f {
		s functioncode=$o(^Config.ENS.EnsSubApiSysConfigI("PKFunctionCode",systemcode,hospital,systemversion,functioncode))
		q:functioncode=""
		s functionid=$o(^Config.ENS.EnsSubApiSysConfigI("PKFunctionCode",systemcode,hospital,systemversion,functioncode,""))
		if +functionid'=0 s functiondesc=$LG(^Config.ENS.EnsSubApiSysConfigD(functionid),6)
		set ^CacheTemp(repid,ind)=$lb(functioncode,functiondesc)
		set ind=ind+1
		}
	Quit $$$OK
}

ClassMethod SysFunctionDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = SysFunctionDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SysFunctionDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SysFunctionDataExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 配置系统功能
/// 操作类型(add/edit/del)|systemcode^hospital^version^functioncode^functiondesc
ClassMethod SystemFuncConfig(Input As %String = "") As %String
{
	
	s $ZT="err"
	s operType=$p(Input,"|",1)
	s paramStr=$p(Input,"|",2)
	if (operType="")||(paramStr="") {
		s jsonObj=##class(%DynamicObject).%New()
		s jsonObj.resultcode=-1
		s jsonObj.resultcontent="请求参数为空"
		q jsonObj.%ToJSON()
	}
	s systemCode=$p(paramStr,"^",1)
	s hospital=$p(paramStr,"^",2)
	s version=$p(paramStr,"^",3)
	if version="" s version="Default"
	s functionCode=$p(paramStr,"^",4)
	s functionDesc=$p(paramStr,"^",5)
	s sc=1
	if '$D(^Config.ENS.EnsApiSysConfigI("PKSystemConfig",systemCode,hospital,version)) {
		s jsonObj=##class(%DynamicObject).%New()
		s jsonObj.resultcode=-1
		s jsonObj.resultcontent="请先维护系统信息"
		q jsonObj.%ToJSON()
	}
	if operType="add" {
		if $D(^Config.ENS.EnsSubApiSysConfigI("PKFunctionCode",systemCode,hospital,version,functionCode)) {
			s jsonObj=##class(%DynamicObject).%New()
			s jsonObj.resultcode=-1
			s jsonObj.resultcontent="当前功能代码已存在"
			q jsonObj.%ToJSON()
			} 
		else {
			s subTableObj=##class(User.EnsSubApiSysConfig).%New()
			s subTableObj.systemCode=systemCode
			s subTableObj.systemHospital=hospital
			s subTableObj.systemVersion=version
			s subTableObj.systemFuncCode=functionCode
			s subTableObj.systemFuncDesc=functionDesc
			s sc=subTableObj.%Save()
			}
		}
	elseif operType="edit" {
		if '$D(^Config.ENS.EnsSubApiSysConfigI("PKFunctionCode",systemCode,hospital,version,functionCode)) {
			s jsonObj=##class(%DynamicObject).%New()
			s jsonObj.resultcode=-1
			s jsonObj.resultcontent="当前功能代码不存在"
			q jsonObj.%ToJSON()
			} 
		else {
			s subTabRowId=$o(^Config.ENS.EnsSubApiSysConfigI("PKFunctionCode",systemCode,hospital,version,functionCode,""))
			if +subTabRowId'=0 {
				s subTableObj=##class(User.EnsSubApiSysConfig).%OpenId(subTabRowId)
				s subTableObj.systemFuncDesc=functionDesc
				s sc=subTableObj.%Save()
				}
			}
		}
	elseif operType="del" {
		if '$D(^Config.ENS.EnsSubApiSysConfigI("PKFunctionCode",systemCode,hospital,version,functionCode)) {
			s jsonObj=##class(%DynamicObject).%New()
			s jsonObj.resultcode=-1
			s jsonObj.resultcontent="当前功能代码不存在"
			q jsonObj.%ToJSON()
			} 
		else {
			s subTabRowId=$o(^Config.ENS.EnsSubApiSysConfigI("PKFunctionCode",systemCode,hospital,version,functionCode,""))
			if +subTabRowId'=0 {
				&sql(DELETE FROM SQLUser.Ens_SubApiSysConfig WHERE %ID=:subTabRowId)
				if (SQLCODE'=0)&&(SQLCODE'=100) s sc=0
				}
			}
		}
	else {
		s jsonObj=##class(%DynamicObject).%New()
		s jsonObj.resultcode=-1
		s jsonObj.resultcontent="未定义的操作类型"
		q jsonObj.%ToJSON()
		}
	if sc=1 {
		s jsonObj=##class(%DynamicObject).%New()
		s jsonObj.resultcode=0
		s jsonObj.resultcontent="成功"
		q jsonObj.%ToJSON()
		}
	else {
		s jsonObj=##class(%DynamicObject).%New()
		s jsonObj.resultcode=-1
		s jsonObj.resultcontent="失败"
		q jsonObj.%ToJSON()
		}
err
	s jsonObj=##class(%DynamicObject).%New()
	s jsonObj.resultcode=-1
	s jsonObj.resultcontent=$SYSTEM.Status.GetErrorText($ZE)
	q jsonObj.%ToJSON()
}

}
