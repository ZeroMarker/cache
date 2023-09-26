/// 名称: DHCWL.DataQuery.ServOfCSP
/// 描述: 针对CSP的服务类
/// 编写者：王峥
/// 编写日期: 2017-6
Class DHCWL.DataQuery.ServOfCSP Extends %RegisteredObject
{

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   查询报表明细配置数据
/// Table：       	DHCWL_DataQuery.ReportCfg，DHCWL_DataQuery.ReportSubCfg
/// Input：         	报表编码
/// Output：        	类型，描述，表达式，编码
/// Return：        	方法执行正确返回空，执行错误返回错误代码
/// Others
ClassMethod GetJsonOfRptDetailData(ByRef inParam, ByRef outParam) As %String
{
	s $zt="Err"
	//k outParam
	s ret=""
	s rptCode=inParam("rptCode")
	s Code=""
	s Descript=""
	s RptType=""
	s BusinessType=""

	&sql(SELECT Code, Descript, RptType ,BusinessType into :Code,:Descript,:RptType,:BusinessType FROM DHCWL_DataQuery.ReportCfg WHERE Code = :rptCode)

	if SQLCODE'=0 {
		w "{success:true,tip:'ok',MSG:'FAIL'}"
		q "没有查询到报表："_rptCode
	}
	/*
	s rptsub=""
	s subID=0
	f {
		s subID=$o(^DHCWL.DataQuery.ReportSubCfgI("InxRptCode",Code,subID))
		q:$g(subID)=""
		
		i rptsub'="" s rptsub=rptsub_","
		s newObj=##class(DHCWL.DataQuery.ReportSubCfg).%OpenId(subID)
		s descript=newObj.Descript
		s itemType=newObj.Type
		
		s tmpRptsub=""
		if newObj.%ClassName()="RptSubDimCfg" {
			s code=newObj.Code
			s dimOrMeasure="维度"
			//s Order	=newObj.Order	
			s tmpRptsub="{type:'"_itemType_"',descript:'"_descript_"',code:'"_code_"',dimOrMeasure:'"_dimOrMeasure_"'}"	
		}elseif newObj.%ClassName()="RptSubMeasureCfg" {
			s code=newObj.Code	
			s dimOrMeasure="度量"	
			s IsAggregate=newObj.IsAggregate
			//s Order	=newObj.Order
			s showFormat=newObj.ShowFormat
			if $g(showFormat)="" s showFormat="#"
			s tmpRptsub="{type:'"_itemType_"',descript:'"_descript_"',code:'"_code_"',dimOrMeasure:'"_dimOrMeasure_"',IsAggregate:'"_IsAggregate_"',showFormat:'"_showFormat_"'}"	
		}elseif newObj.%ClassName()="RptSubFilterCfg" {
			s Express=newObj.Express
			s tmpRptsub="{type:'"_itemType_"',descript:'"_Express_"',Express:'"_Express_"'}"		
			
		}elseif newObj.%ClassName()="RptSubSItemCfg" {
			s code=newObj.Code
			s value=newObj.Value
			s tmpRptsub="{type:'"_itemType_"',descript:'"_descript_"',value:'"_value_"',code:'"_code_"'}"	
		}
			
	
		s rptsub=rptsub_tmpRptsub
	}
	
	s outParam("jsonStr")="{success:true,tip:'ok',MSG:'SUCESS',cfgData:{Code:'"_Code_"',Descript:'"_Descript_"',RptType:'"_RptType_"',BusinessType:'"_BusinessType_"',rptsub:["_rptsub_"]}}"
	*/
	
	s rptsub=""
	s subID=0
	f {
		s subID=$o(^DHCWL.DataQuery.ReportSubCfgI("InxRptCode",Code,subID))
		q:$g(subID)=""
		
		i rptsub'="" s rptsub=rptsub_","
		s newObj=##class(DHCWL.DataQuery.ReportSubCfg).%OpenId(subID)
		s descript=newObj.Descript
		s itemType=newObj.Type
		
		s tmpRptsub=""
		if newObj.%ClassName()="RptSubDimCfg" {
			s code=newObj.Code
			s dimOrMeasure="维度"
			//s Order	=newObj.Order	
			s tmpRptsub="{""type"":"""_itemType_""",""descript"":"""_descript_""",""code"":"""_code_""",""dimOrMeasure"":"""_dimOrMeasure_"""}"	
		}elseif newObj.%ClassName()="RptSubMeasureCfg" {
			s code=newObj.Code	
			s dimOrMeasure="度量"	
			s IsAggregate=newObj.IsAggregate
			//s Order	=newObj.Order
			s showFormat=newObj.ShowFormat
			if $g(showFormat)="" s showFormat="#"
			s tmpRptsub="{""type"":"""_itemType_""",""descript"":"""_descript_""",""code"":"""_code_""",""dimOrMeasure"":"""_dimOrMeasure_""",""IsAggregate"":"""_IsAggregate_""",""showFormat"":"""_showFormat_"""}"	
		}elseif newObj.%ClassName()="RptSubFilterCfg" {
			s Express=newObj.Express
			s tmpRptsub="{""type"":"""_itemType_""",""descript"":"""_Express_""",""Express"":"""_Express_"""}"		
			
		}elseif newObj.%ClassName()="RptSubSItemCfg" {
			s code=newObj.Code
			s value=newObj.Value
			s tmpRptsub="{""type"":"""_itemType_""",""descript"":"""_descript_""",""value"":"""_value_""",""code"":"""_code_"""}"	
		}
			
	
		s rptsub=rptsub_tmpRptsub
	}
	
	s outParam("jsonStr")="{""success"":true,""tip"":""ok"",""MSG"":""SUCESS"",""cfgData"":{""Code"":"""_Code_""",""Descript"":"""_Descript_""",""RptType"":"""_RptType_""",""BusinessType"":"""_BusinessType_""",""rptsub"":["_rptsub_"]}}"
		
	q ""
Err
	if ret="" s ret="获取报表明细配置失败:"_$ZERROR
	q ret
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   根据角色得到基础维度
/// Table：       	DHCWL.MeasureDimrole.DimRole，DHCWL.MKPI.MKPIDimType
/// Input：         	角色编码
/// Output：        	
/// Return：        	维度编码
/// Others
ClassMethod GetDimTypeFromRole(roleCode As %String) As %String
{
	
	s ret=##class(DHCWL.MeasureDimroleData.FunctionModule).GetDimByDimRole(roleCode)
	s ret=$p(ret,":",2)
	q ret
	/*
	s ret=""
	if $d(^DHCWL.MeasureDimrole.DimRoleI("Code"," "_roleCode)) {
		s roleID=$o(^DHCWL.MeasureDimrole.DimRoleI("Code"," "_roleCode,0))
		s dimTypeID=$lg(^DHCWL.MeasureDimrole.DimRoleD(roleID),5)
	
		if $d(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID)) {
			s ret=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID),2)
		}
	}
	
	q ret
	*/
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   得到报表配置总览数据
/// Table：       	DHCWL.DataQuery.ReportCfg
/// Input：         	报表编码
/// Output：        	
/// Return：        	描述，类型，编码，表达式
/// Others
ClassMethod GetRptCfgBriefInfo(ByRef inArgs, ByRef outArgs) As %String
{
	s $zt="ErrProc"
	s rptCode=inArgs("rptCode")
	s rowid=$o(^DHCWL.DataQuery.ReportCfgI("InxCode",rptCode,0))
	s newObj=##class(DHCWL.DataQuery.ReportCfg).%OpenId(rowid)
	q:'$IsObject(newObj) "不能打开报表"_rptCode
	
	s rptDesc=newObj.Descript
	s rptBusinessType=newObj.BusinessType
	s rptType=$CASE(newObj.RptType,"grpRpt":"行式报表","crossRpt":"交叉报表")
	s rptUser=newObj.UserID
	d newObj.%Close()
	
	/*
	s rptsub=""
	s subID=0
	f {
		s subID=$o(^DHCWL.DataQuery.ReportSubCfgI("InxRptCode",rptCode,subID))
		q:$g(subID)=""
		s newObj=##class(DHCWL.DataQuery.ReportSubCfg).%OpenId(subID)	
		
		s descript=newObj.Descript
		s type=$CASE(newObj.Type,"col":"列条件","row":"行条件","measure":"度量","filter":"过滤","searchitem":"查询项")
		
		if newObj.Type="filter" s descript=newObj.Express
		i rptsub'="" s rptsub=rptsub_","
		if newObj.Type="searchitem" {
			s rptsub=rptsub_"{descript:'"_descript_"',itemCls:'"_type_"',code:'"_newObj.Code_"',value:'"_newObj.Value_"'}"	
		}else{
			s rptsub=rptsub_"{descript:'"_descript_"',itemCls:'"_type_"'}"	
		}
	}
	
	s briefInfo="cfgData:{rptDesc:'"_rptDesc_"',rptBusinessType:'"_rptBusinessType_"',rptType:'"_rptType_"',rptUser:'"_rptUser_"',rptsub:["_rptsub_"]}"
	s outArgs("briefInfo")=briefInfo
	
	*/
	s rptsub=""
	s subID=0
	f {
		s subID=$o(^DHCWL.DataQuery.ReportSubCfgI("InxRptCode",rptCode,subID))
		q:$g(subID)=""
		s newObj=##class(DHCWL.DataQuery.ReportSubCfg).%OpenId(subID)	
		
		s descript=newObj.Descript
		s type=$CASE(newObj.Type,"col":"列条件","row":"行条件","measure":"度量","filter":"过滤","searchitem":"查询项")
		
		if newObj.Type="filter" s descript=newObj.Express
		i rptsub'="" s rptsub=rptsub_","
		if newObj.Type="searchitem" {
			s rptsub=rptsub_"{""descript"":"""_descript_""",""itemCls"":"""_type_""",""code"":"""_newObj.Code_""",""value"":"""_newObj.Value_"""}"	
		}else{
			s rptsub=rptsub_"{""descript"":"""_descript_""",""itemCls"":"""_type_"""}"	
		}
	}
	
	s briefInfo="""cfgData"":{""rptDesc"":"""_rptDesc_""",""rptBusinessType"":"""_rptBusinessType_""",""rptType"":"""_rptType_""",""rptUser"":"""_rptUser_""",""rptsub"":["_rptsub_"]}"
	s outArgs("briefInfo")=briefInfo	q ""
	
ErrProc
	q $ZERROR
}

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:：   得到指定业务类型的所有指标
/// Table：       	DHCWL_DataQuery.BTSub
/// Input：         	业务类型编码，查询值
/// Output：        	KPICode指标编码,name名称,desc描述,type类型,kpiDim基础维度,sec区间,author作者
/// Return：        	
/// Others
Query QryGetKPIByBT(args As %String) As %Query(ROWSPEC = "code:%String,name:%String,descript:%String,type:%String,kpiDim:%String,sec:%String,author:%String")
{
}

ClassMethod QryGetKPIByBTExecute(ByRef qHandle As %Binary, args As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	k ^||TEMPDHCWL
	
	s btCode=$p(args,$C(2),1)
	s searchV=$p(args,$C(2),2)
	
	/*
	SELECT MKPI_Code,MKPI_Name,MKPI_Desc,MKPI_Cate->MKPIFL_Name,
	(SELECT XMLAGG(MKPIDim_Des || ';') FROM DHCWL_MKPI.DHCWLMKPIDim WHERE MKPI_Dr=t1.ID ) AS kpiDim,
	MKPI_SectionFlag->Sec_Name,MKPI_User 
	FROM DHCWL_MKPI.DHCWLMKPI t1
	WHERE MKPI_Code IN (SELECT KPICode FROM DHCWL_DataQuery.BTSub WHERE BusinessTypeCode='Iincome')	
	*/	
	s KPICode=""
	f {
		s KPICode=$o(^DHCWL.DataQuery.BTSubI("BTCodeKPICode",btCode,KPICode))
		q:$g(KPICode)=""
		s btSubID=0
		f {
			s btSubID=$o(^DHCWL.DataQuery.BTSubI("BTCodeKPICode",btCode,KPICode,btSubID))
			q:btSubID=""
			s ^||TEMPDHCWL("btSubID",btSubID)=""
		}
	}
	
	s btSubID=""
	f {
		s btSubID=$o(^||TEMPDHCWL("btSubID",btSubID))
		q:$g(btSubID)=""
		
		s KPICode=$lg(^DHCWL.DataQuery.BTSubD(btSubID),3)
		s alphaKPICode=$SYSTEM.SQL.ALPHAUP(KPICode)
		s KPIID=$o(^DHCWL.MKPI.MKPII("MKPICode",alphaKPICode,""))
		i KPIID="" S KPIID=$o(^DHCWL.MKPI.MKPII("MKPICode"," "_alphaKPICode,""))
		s name=$lg(^DHCWL.MKPI.MKPID(KPIID),5)
		s desc=$lg(^DHCWL.MKPI.MKPID(KPIID),3)
		s cateDr=$lg(^DHCWL.MKPI.MKPID(KPIID),9)
		s secFlagDr=$lg(^DHCWL.MKPI.MKPID(KPIID),11)
		s author=$lg(^DHCWL.MKPI.MKPID(KPIID),8)
	
		s type=""
		if $g(cateDr)'="" {
			s type=$lg(^DHCWL.MKPI.MKPIFLD(cateDr),5)
			
		}
		
		s sec=""
		if $g(secFlagDr)'="" {
			s sec=$lg(^DHCWL.MKPI.SectionD(secFlagDr),4)
		}
		s kpiDim=""
		s dimOrder=0
		f {
			s dimOrder=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",KPIID,dimOrder))
			q:dimOrder=""
		
			s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",KPIID,dimOrder,""))
			s dimDesc=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),4)
			if kpiDim="" s kpiDim=dimDesc
			else  s kpiDim=kpiDim_";"_dimDesc
		}
	
		if searchV'="" {
			s seared=(name[searchV) + (desc[searchV) +(author[searchV)  + (type[searchV) +(sec[searchV) + (kpiDim[searchV) +(KPICode[searchV) 
			continue:seared<1
		}
		s Data=$lb(KPICode,name,desc,type,kpiDim,sec,author)
		Do OutRow		
		
	}
			
		

	
	k ^||TEMPDHCWL
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryGetKPIByBTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetKPIByBTExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGetKPIByBTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetKPIByBTExecute ]
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
/// Description:：   得到不属于任何业务类型的所有指标
/// Table：       	DHCWL_DataQuery.BTSub
/// Input：         	业务类型编码，查询值
/// Output：        	KPICode指标编码,name名称,desc描述,type类型,kpiDim基础维度,sec区间,author作者
/// Return：        	
/// Others
Query QryGetAllUncollectKPI(args As %String) As %Query(ROWSPEC = "code:%String,name:%String,descript:%String,type:%String,kpiDim:%String,sec:%String,author:%String")
{
}

ClassMethod QryGetAllUncollectKPIExecute(ByRef qHandle As %Binary, args As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	k ^||TEMPDHCWL
	
	//s btCode=$p(args,$C(2),1)
	s searchV=$p(args,$C(2),2)
	
	s KPIID=""
	f {
		s KPIID=$o(^DHCWL.MKPI.MKPID(KPIID))
		q:$g(KPIID)=""
		s KPICode=$lg(^DHCWL.MKPI.MKPID(KPIID),2)
		continue:$d(^DHCWL.DataQuery.BTSubI("KPICodeBTCode",KPICode))	//如果已经被配置过了，就不能再被配置了。
		s name=$lg(^DHCWL.MKPI.MKPID(KPIID),5)
		s desc=$lg(^DHCWL.MKPI.MKPID(KPIID),3)
		s cateDr=$lg(^DHCWL.MKPI.MKPID(KPIID),9)
		s secFlagDr=$lg(^DHCWL.MKPI.MKPID(KPIID),11,"null")
		s author=$lg(^DHCWL.MKPI.MKPID(KPIID),8)
	
		if $g(cateDr)="" {
			s type=""
		}else{
			s type=$lg(^DHCWL.MKPI.MKPIFLD(cateDr),5)
		}
		
		if $g(secFlagDr)="" {
			s sec=""
		}else{
			s sec=$lg(^DHCWL.MKPI.SectionD(secFlagDr),4,"")
		}
		
		s kpiDim=""
		s dimOrder=0
		f {
			s dimOrder=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",KPIID,dimOrder))
			q:dimOrder=""
		
			s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",KPIID,dimOrder,""))
			s dimDesc=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),4)
			if kpiDim="" s kpiDim=dimDesc
			else  s kpiDim=kpiDim_";"_dimDesc
		}
	
		if searchV'="" {
			///
			///s seared=(name[searchV) + (desc[searchV) +(author[searchV)  + (type[searchV) +(sec[searchV) + (kpiDim[searchV) +(KPICode[searchV) 
			s seared=##class(DHCWL.CommonUtil.FilterUtil).LikeCase(name,searchV) + ##class(DHCWL.CommonUtil.FilterUtil).LikeCase(desc,searchV) + ##class(DHCWL.CommonUtil.FilterUtil).LikeCase(author,searchV)  + ##class(DHCWL.CommonUtil.FilterUtil).LikeCase(type,searchV)  + ##class(DHCWL.CommonUtil.FilterUtil).LikeCase(sec,searchV)  + ##class(DHCWL.CommonUtil.FilterUtil).LikeCase(kpiDim,searchV)+ ##class(DHCWL.CommonUtil.FilterUtil).LikeCase(KPICode,searchV)
			continue:seared<1
		}
		s Data=$lb(KPICode,name,desc,type,kpiDim,sec,author)
		Do OutRow		

	}
	
	k ^||TEMPDHCWL
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryGetAllUncollectKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetAllUncollectKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGetAllUncollectKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetAllUncollectKPIExecute ]
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
