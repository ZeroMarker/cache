/// 名称: DHCWL.DataQuery.Serv
/// 描述: 服务类
/// 编写者：王峥
/// 编写日期: 2017-6
Class DHCWL.DataQuery.Serv Extends %RegisteredObject
{

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   查询所有业务类型
/// Table：       	DHCWL_DataQuery.BusinessType
/// Input：         	无
/// Output：        	无
/// Return：        	描述，编码
/// Others
ClassMethod GetBusinessType(ByRef inParam, ByRef outParam) As DHCWL.util.Json
{
	s sql="SELECT Descript,Code FROM DHCWL_DataQuery.BusinessType"
		
	s jsonPro="Descript,Code"

	s qryName="%DynamicQuery:SQL"	
	s json=##class(DHCWL.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,0,0,jsonPro)	

	q json
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   得到指定业务类型所包含的指标的角色的编码和描述
/// Table：       	DHCWL_MKPI.DHCWLMKPIDim，DHCWL_MKPI.DHCWLSection
/// Input：         	业务类型编码
/// Output：        	无
/// Return：        	编码，描述
/// Others
ClassMethod GetDimRoleByBusinessType(ByRef inParam, ByRef outParam) As %String
{
	s businessCode=$g(inParam("businessCode"))
	//得到指标关联的基础维度
	s sql="SELECT DISTINCT MKPIDim_Code, MKPIDim_Code || '-'|| MKPIDim_Des as Descript, 'role' AS type FROM DHCWL_MKPI.DHCWLMKPIDim "
	s sql=sql_"WHERE MKPI_Dr IN ( "
	s sql=sql_"SELECT ID FROM DHCWL_MKPI.DHCWLMKPI WHERE MKPI_Code IN (SELECT KPICode FROM DHCWL_DataQuery.BTSub WHERE BusinessTypeCode='"_businessCode_"'))"
	s sql=sql_"UNION  "
	s sql=sql_"SELECT Sec_Code AS MKPIDim_Code, Sec_Code || '-'|| Sec_Name as Descript , 'section' AS type FROM DHCWL_MKPI.DHCWLSection  "
	s sql=sql_"WHERE ID IN (  "
	s sql=sql_"SELECT DISTINCT MKPI_SectionFlag FROM DHCWL_MKPI.DHCWLMKPI WHERE MKPI_Code IN (SELECT KPICode FROM DHCWL_DataQuery.BTSub  "
	s sql=sql_"WHERE BusinessTypeCode='"_businessCode_"'))	 "
	
	
	s qryName="%DynamicQuery:SQL"	
	s rs=##class(%Library.ResultSet).%New(qryName)
	d rs.Prepare(sql)
	d rs.Execute()
	
	s inx=0
	While(rs.Next()){
			s code=rs.Data("MKPIDim_Code")
			s desc=rs.Data("Descript")
			s type=rs.Data("type")
			s inx=inx+1
			s outParam(inx,code)=desc_$C(2)_type
	}
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   得到指定角色的维度名称和维度编码
/// Table：       	DHCWL_MKPI.DHCWLDimProperty
/// Input：         	角色编码
/// Output：        	无
/// Return：        	编码，名称
/// Others
ClassMethod GetDimProByRole(ByRef inParam, ByRef outParam) As %String
{
	s roleCode=$g(inParam("roleCode"))
	s type=$g(inParam("type"))
	//角色属性
	s sql="SELECT DimPro_Name, DimPro_Code FROM DHCWL_MKPI.DHCWLDimProperty WHERE DimPro_DimDr IN ("
	s sql=sql_"SELECT DISTINCT MKPIDim_DimDr FROM DHCWL_MKPI.DHCWLMKPIDim WHERE MKPIDim_Code='"_roleCode_"'  )"	
	
	if type="section" {	//区间属性
		s sql="SELECT SecDimPro_Name As DimPro_Name, SecDimPro_Code As DimPro_Code FROM DHCWL_MKPI.DHCWLSectionProperty WHERE SecDimPro_DimDr IN ("
		s sql=sql_"SELECT ID FROM DHCWL_MKPI.DHCWLSection WHERE Sec_Code='"_roleCode_"'  )"
	}
	//w !,sql
	s qryName="%DynamicQuery:SQL"	
	s rs=##class(%Library.ResultSet).%New(qryName)
	d rs.Prepare(sql)
	d rs.Execute()
	
	While(rs.Next()){
			s code=rs.Data("DimPro_Code")
			s desc=rs.Data("DimPro_Name")
			s outParam(code)=code_"-"_desc
	}
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   得到指定区间维度的维度名称和维度编码
/// Table：       	DHCWL_MKPI.DHCWLSectionProperty
/// Input：         	角色编码
/// Output：        	无
/// Return：        	编码，名称
/// Others
ClassMethod GetSecProByRole(ByRef inParam, ByRef outParam) As %String
{
	s secCode=$g(inParam("secCode"))

	s sql="SELECT SecDimPro_Code, SecDimPro_Name FROM DHCWL_MKPI.DHCWLSectionProperty WHERE SecDimPro_DimDr=("
	S sql=sql_"SELECT ID FROM DHCWL_MKPI.DHCWLSection WHERE Sec_Code='"_secCode_"' )"
	//w !,sql
	s qryName="%DynamicQuery:SQL"	
	s rs=##class(%Library.ResultSet).%New(qryName)
	d rs.Prepare(sql)
	d rs.Execute()
	
	While(rs.Next()){
			s code=rs.Data("SecDimPro_Code")
			s desc=rs.Data("SecDimPro_Name")
			s outParam(code)=code_"-"_desc
	}
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   查询指定业务类型和维度及未被选择的指标
/// Table：       	DHCWL.MKPI.MKPIDimensions，DHCWL.MKPI.Section，DHCWL.MKPI.MKPI
/// Input：         	业务类型编码，维度编码，需要剔除的指标编码
/// Output：        	无
/// Return：        	指标编码，描述，角色
/// Others			查询出指定业务类型和指定维度的指标，然后剔除一部分指标（$p(args,$C(2),3)），剩下的
/// 					指标信息返回
Query QryOptionalKPI(args As %String) As %Query(ROWSPEC = "code:%String,descript:%String,role:%String")
{
}

ClassMethod QryOptionalKPIExecute(ByRef qHandle As %Binary, args As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	k ^||TEMPDHCWL
	
	s dimCodes=$p(args,$C(2),1)
	s businessType=$p(args,$C(2),2)
	
	//已选择过的指标
	s selectedKpis=$p(args,$C(2),3)
	
	s dimLen=$l(dimCodes,",")
	f i=1:1:dimLen {
		s dimC=$p(dimCodes,",",i)
		if $g(dimC)'="" s ^||TEMPDHCWL("DIMCODE",dimC)=""	
	}
	
	//已选择过的指标,保存到global中
	s selectedKLen=$l(selectedKpis,",")
	f i=1:1:selectedKLen {
		s kpiCode=$p(selectedKpis,",",i)
		if $g(kpiCode)'="" s ^||TEMPDHCWL("SELECTEDKPICODE",kpiCode)=""	
		
	}

	//1、找出业务类型下的所有指标及角色
	s KPICode=0
	f {
		s KPICode=$o(^DHCWL.DataQuery.BTSubI("BTCodeKPICode",businessType,KPICode))
		q:$g(KPICode)=""
		
		continue:$d(^||TEMPDHCWL("SELECTEDKPICODE",KPICode))	//这个指标已经被选择了就跳过
		s KPIID=$o(^DHCWL.MKPI.MKPII("MKPICode",$SYSTEM.SQL.ALPHAUP(KPICode),0))
		s dimC=""
		s OPTIONALKPI=0
		f {
			s dimC=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",KPIID,dimC))
			q:$g(dimC)=""
			s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",KPIID,dimC,""))
			s role=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),2)
			s ^||TEMPDHCWL("KPI",KPIID,"ROLES",role)=""
		}
		s ^||TEMPDHCWL("KPI",KPIID,"CODE")=KPICode
		
		//指标的区间维度
		s sectionDr=$lg(^DHCWL.MKPI.MKPID(KPIID),11)
		s sectionCode="$"_$lg(^DHCWL.MKPI.SectionD(sectionDr),2)
		s ^||TEMPDHCWL("KPI",KPIID,"SECCODE",sectionCode)=""		
		
	}

	//2、根据用户选择的角色，对指标进行过滤
	s KPIID=""
	f {
		s KPIID=$O(^||TEMPDHCWL("KPI",KPIID))	
		q:$g(KPIID)=""
		s role=""
		s optional=1
		f {
			s role=$o(^||TEMPDHCWL("DIMCODE",role))
			q:role=""
			/*
			if '$d(^||TEMPDHCWL("KPI",KPIID,"ROLES",role)) {
				s optional=0
				q
			}
			*/
			if '$d(^||TEMPDHCWL("KPI",KPIID,"ROLES",role)) && ('$d(^||TEMPDHCWL("KPI",KPIID,"SECCODE",role))) {
				s optional=0
				q
			}
		}
		if optional=1 s ^||TEMPDHCWL("OPTIONALKPI",KPIID)=""
	}
	
	//3、把过滤后的指标输出
	s KPIID=""
	f {
		s KPIID=$O(^||TEMPDHCWL("OPTIONALKPI",KPIID))	
		q:$g(KPIID)=""
		s roles=""
		s r=""
		f {
			s r=$o(^||TEMPDHCWL("KPI",KPIID,"ROLES",r))
			q:$g(r)=""
			if roles="" s roles=r
			else  s roles=roles_","_r	
		}		
		s script=$lg(^DHCWL.MKPI.MKPID(KPIID),3)
		s code=^||TEMPDHCWL("KPI",KPIID,"CODE")
		s Data=$lb(code, script, roles)

		Do OutRow		
	}

	k ^||TEMPDHCWL
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryOptionalKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOptionalKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOptionalKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOptionalKPIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   查询指定业务类型和维度角色的指标
/// Table：       	DHCWL.MKPI.MKPIDimensions，DHCWL.MKPI.Section，DHCWL.MKPI.MKPI
/// Input：         	业务类型编码，维度编码
/// Output：        	无
/// Return：        	描述，基础维度编码，角色编码，类型
/// Others			
ClassMethod getOptionalRoleOfFilter(ByRef inParam, ByRef outParam) As %String
{
	k ^||TEMPDHCWL
	
	s dimCodes=inParam("roleCode")
	s businessType=inParam("businessType")
	
	s dimLen=$l(dimCodes,",")
	f i=1:1:dimLen {
		s dimC=$p(dimCodes,",",i)
		if $g(dimC)'="" s ^||TEMPDHCWL("DIMCODE",dimC)=""	
		
	}
	
	
	//1、找出业务类型下的所有指标及角色
	s KPICode=0
	f {
		s KPICode=$o(^DHCWL.DataQuery.BTSubI("BTCodeKPICode",businessType,KPICode))
		q:$g(KPICode)=""
		
		s KPIID=$o(^DHCWL.MKPI.MKPII("MKPICode",$SYSTEM.SQL.ALPHAUP(KPICode),0))
		s dimC=""
		//s OPTIONALKPI=0
		f {
			//指标所有的角色
			s dimC=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",KPIID,dimC))
			q:$g(dimC)=""
			s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",KPIID,dimC,""))
			s role=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),2)
			s dimTypeDr=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),5)
			s dimTypeCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimTypeDr),2)
			s roleDesc=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),4)
			s ^||TEMPDHCWL("KPI",KPIID,"ROLES",role)=role_"-"_roleDesc
			s ^||TEMPDHCWL("KPI",KPIID,"DIMTYPE",role)=dimTypeCode		
		}
		
		//指标的区间维度
		s sectionDr=$lg(^DHCWL.MKPI.MKPID(KPIID),11)
		//s sectionCode=$lg(^DHCWL.MKPI.SectionD(sectionDr),2)
		s sectionCode="$"_$lg(^DHCWL.MKPI.SectionD(sectionDr),2)
		s ^||TEMPDHCWL("KPI",KPIID,"SECCODE",sectionCode)=""
	}


	//2、根据用户选择的角色，对指标进行过滤
	s KPIID=""
	f {
		s KPIID=$O(^||TEMPDHCWL("KPI",KPIID))	
		q:$g(KPIID)=""
		s role=""
		s optional=1
		f {
			s role=$o(^||TEMPDHCWL("DIMCODE",role))
			q:role=""
			if '$d(^||TEMPDHCWL("KPI",KPIID,"ROLES",role)) && ('$d(^||TEMPDHCWL("KPI",KPIID,"SECCODE",role))) {
				s optional=0
				q
			}
		}
		if optional=1 s ^||TEMPDHCWL("OPTIONALKPI",KPIID)=""
	}
	
	//3、把过滤后指标的角色输出
	s cnt=0
	s KPIID=""
	f {
		s KPIID=$O(^||TEMPDHCWL("OPTIONALKPI",KPIID))	
		q:$g(KPIID)=""
		s roles=""
		s r=""

		f {
			s r=$o(^||TEMPDHCWL("KPI",KPIID,"ROLES",r))
			q:$g(r)=""
			if '$d(^||TEMPDHCWL("OPTIONALROLE",r)) {
				s ^||TEMPDHCWL("OPTIONALROLE",r)=""
				s cnt=cnt+1
				s outParam(cnt,"DESC")=^||TEMPDHCWL("KPI",KPIID,"ROLES",r)
				S outParam(cnt,"DIMCODE")=^||TEMPDHCWL("KPI",KPIID,"DIMTYPE",r)	
				S outParam(cnt,"ROLECODE")=r	
				S outParam(cnt,"TYPE")="role"
			}
		}		
	}
	
	
	//add by wz.2015-1-27.增加区间维度
	s KPIID=""
	f {
		s KPIID=$O(^||TEMPDHCWL("OPTIONALKPI",KPIID))	
		q:$g(KPIID)=""
		s kpiSecFlag=$lg(^DHCWL.MKPI.MKPID(KPIID),11)
		s secData=$g(^DHCWL.MKPI.SectionD(kpiSecFlag))
		i $g(secData)'="" {
			s secCode=$lg(secData,2)
			s secDesc=$lg(secData,4)
			
			if '$d(^||TEMPDHCWL("OPTIONALDATETYPE",secCode)) {
				s ^||TEMPDHCWL("OPTIONALDATETYPE",secCode)=""
				s cnt=cnt+1
				s outParam(cnt,"DESC")=secCode_"-"_secDesc
				S outParam(cnt,"DIMCODE")=secCode	
				S outParam(cnt,"ROLECODE")=secCode
				S outParam(cnt,"TYPE")="sec"
			}			
			
		}
	}
		
	k ^||TEMPDHCWL
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   查询指标的维度角色
/// Table：       	DHCWL.MKPI.MKPIDimensions，DHCWL.MKPI.Section，DHCWL.MKPI.MKPI
/// Input：         	指标编码
/// Output：        	无
/// Return：        	描述，基础维度编码，角色编码，类型
/// Others	
ClassMethod getKpiRole(ByRef inParam, ByRef outParam) As %String
{
	k ^||TEMPDHCWL
	
	s KPICode=inParam("kpiCode")

	s KPIID=$o(^DHCWL.MKPI.MKPII("MKPICode",$SYSTEM.SQL.ALPHAUP(KPICode),0))
	s dimC=""
	s cnt=1
	f {
		//指标所有的角色
		s dimC=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",KPIID,dimC))
		q:$g(dimC)=""
		s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",KPIID,dimC,""))
		s role=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),2)
		s dimTypeDr=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),5)
		s dimTypeCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimTypeDr),2)
		s roleDesc=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),4)
		s ^||TEMPDHCWL("KPI",KPIID,"ROLES",role)=role_"-"_roleDesc
		s ^||TEMPDHCWL("KPI",KPIID,"DIMTYPE",role)=dimTypeCode	
		
		s outParam(cnt,"DESC")=role_"-"_roleDesc
		S outParam(cnt,"DIMCODE")=dimTypeCode
		S outParam(cnt,"ROLECODE")=role
		S outParam(cnt,"TYPE")="role"
		s cnt=cnt+1			
	}
	
	//指标的区间维度
	s kpiSecFlag=$lg(^DHCWL.MKPI.MKPID(KPIID),11)
	s secData=$g(^DHCWL.MKPI.SectionD(kpiSecFlag))
	i $g(secData)'="" {
		s secCode=$lg(secData,2)
		s secDesc=$lg(secData,4)
		
		if '$d(^||TEMPDHCWL("OPTIONALDATETYPE",secCode)) {
			s ^||TEMPDHCWL("OPTIONALDATETYPE",secCode)=""
			s cnt=cnt+1
			s outParam(cnt,"DESC")=secCode_"-"_secDesc
			S outParam(cnt,"DIMCODE")=secCode	
			S outParam(cnt,"ROLECODE")=secCode
			S outParam(cnt,"TYPE")="sec"
		}			
		
	}
	
	k ^||TEMPDHCWL
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   查询指标系统提供的所有过滤函数
/// Table：       	DHCWL_MKPI.SysFilterFunc
/// Input：         	
/// Output：        	无
/// Return：        	过滤函数编码和描述
/// Others
ClassMethod getFilterFun() As DHCWL.util.Json
{
	s sql="SELECT FilterFunc_Code AS code, FilterFunc_FuncDesc AS descript FROM DHCWL_MKPI.SysFilterFunc"
		
	s jsonPro="code,descript"

	s qryName="%DynamicQuery:SQL"	
	//s json=##class(DHCWL.RptMgmt.Util).GetJsonByQry(qryName,"",sql,0,0,jsonPro)	
	s json=##class(DHCWL.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,0,0,jsonPro)	
	q json
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   查询指定维度及属性的可选值
/// Table：       	
/// Input：         	维度编码，属性编码，查询值
/// Output：        	
/// Return：        	可选值
/// Others
Query QryOptionalProValue(args As %String) As %Query(ROWSPEC = "value:%String")
{
}

ClassMethod QryOptionalProValueExecute(ByRef qHandle As %Binary, args As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	k ^||TEMPDHCWL
	
	s dimCode=$p(args,$C(2),1)
	s proCode=$p(args,$C(2),2)
	s searchV=$p(args,$C(2),3)
	
	s dimCodeStr=dimCode_":"_proCode

	s rs=##class(%ResultSet).%New("DHCWL.Interface.MkpiData:QryDimValuesByDimType")
	s sc=rs.Execute(dimCodeStr)
	While rs.Next(.sc){
		//s dimType=$g(rs.Data("dimType"))
		//s dimIDV=$g(rs.Data("dimIDV")) 
		s dimProV=$g(rs.Data("dimProV"))
		if $g(searchV)'="" {
			continue:(dimProV'[searchV)
		}
		continue:$g(dimProV)=""
		s ^||TEMPDHCWL("VALUE",dimProV)=""
	}
	
	s dimProV=""
	f {
		s dimProV=$o(^||TEMPDHCWL("VALUE",dimProV))	
		q:$g(dimProV)=""
		s Data=$lb(dimProV)
		d OutRow2
	}
	

	k ^||TEMPDHCWL
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow2
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryOptionalProValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOptionalProValueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOptionalProValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOptionalProValueExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
