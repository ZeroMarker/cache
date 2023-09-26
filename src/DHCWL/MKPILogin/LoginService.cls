Class DHCWL.MKPILogin.LoginService Extends %RegisteredObject [ LegacyInstanceContext, Not ProcedureBlock ]
{

/// 	指标服务方法使用示例
/// 	s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
/// 	w loginService.LoginStart("KpiLogDefinition","demo")
/// 	w loginService.LoginContent("{MKPIIdList:'11,12,13'}")
/// 	w loginService.LoginEnd()
/// 			*********************************************私有方法**********************************************
Property login As DHCWL.MKPI.LoginInfo;

/// Creator:		LHH
/// CreatDate:		
/// Description:	日志的开始，类似于事务，有开始和结束。该方法完成日志的内容的初始化，
/// 					例如初始化好当前的日志日期，时间，根据loginTypeCode得到其rowid，new日志对象等等。
/// Table:			
/// Input:			loginTypeCode:日志类型编码,可取的值为{"KpiLogDefinition","KpiLogDataProcess","KpiLogDataQuery","KpiLogTaskErr"}; 
/// 					operator:用户名,使用者姓名;
/// 					writePreFlag:是否记录修改前数据标志,可取的值为{0(默认)为不记录, 1则记录};
/// Output:			
/// HowToUse:		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
/// 				s SQLCODE=loginService.LoginStart("KpiLogDefinition", "demo", 0)
/// Other:			私有方法
Method LoginStart(loginTypeCode As %String = "", operator As %String = "", writePreFlag As %Boolean = 0) As %Status
{
	;n (loginTypeCode,operator,writePreFlag)		;--
	n (%this,loginTypeCode,operator,writePreFlag)	;++modify by wz.2014-3-24.改成这个方式是为了支持2010之前的版本。
	q:loginTypeCode="" "日志类型不能为空"
	s loginTypeId=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||"_loginTypeCode)
	q:(loginTypeId="") "不存在该日志类型"
	s loginTypeObj=##class(DHCWL.MKPI.APPLibrary).%OpenId(loginTypeId)
	
	if ((writePreFlag=0)&&(..login'="")){
		d ..LoginEnd()
	}
	s ..login=##class(DHCWL.MKPI.LoginInfo).%New()
	s ..login.LoginTypeDr=loginTypeObj
	s:operator'="" ..login.Operator=operator
	s ..login.LoginDate=+$h
	s ..login.LoginSTime=$p($h,",",2)
	q $$$OK
}

/// Creator:		LHH
/// CreatDate:		
/// Description:	日志内容的写方法，该方法可以被多次调用，因为写日志是一个过程，某一次可能只写了一部分内容。
/// 					其中参数content为json格式的字符串，我们需要将json字符串解析出日志对象的属性及该属性的值。
/// Table:			
/// Input:			content:json格式的字符串;
/// Output:			
/// HowToUse:		s json=##class(DHCWL.util.Json).Json("id^name^mess")
/// 					s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
/// 					s SQLCODE=loginService.LoginContent(json)
/// Other:			私有方法
Method LoginContent(content As %Text = "") As %Status
{
	n (%this,content)
	q:((content="")) 0
	q:(..login="") 0
	d ##class(DHCWL.util.ClassMetadata).GetMetadataProperty("DHCWL.MKPI.LoginInfo",.proArr)
	d ..ResolveContent(content,.proValueArr)
	s pro="",exeStr=""
	f {
		s pro=$o(proValueArr(pro))
		q:(pro="")
		continue:('$d(proArr(pro)))
		if (exeStr=""){
			s exeStr="s ..login."_pro_"=proValueArr("""_pro_""")"
		}else{
			s exeStr=exeStr_",..login."_pro_"=proValueArr("""_pro_""")"
		}
	}
	if (exeStr'=""){
		x exeStr
	}
	q $$$OK
}

/// Creator:		LHH
/// CreatDate:		
/// Description:	回写日志，此时记录写日志的结束时间，
/// 					将方法LoginContent中写入的日志内容写回数据库，整个日志记录过程结束。
/// Table:			
/// Input:			
/// Output:			
/// HowToUse:		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
/// 				s SQLCODE=loginService.LoginEnd()
/// Other:			私有方法
Method LoginEnd() As %Status
{
	q:(..login="") 0
	s ..login.LoginETime=$p($h,",",2)
	q ..login.%Save()
}

/// 			*****************************************公有的类方法*************************************
/// Creator:		LHH
/// CreatDate:		
/// Description:	检查指标日志类型的编码是否已配置（首次使用才需要配置）
/// 					对编码表中指标日志类型的编码逐项检查，若某类型的指标日志类型不存在，则新建之
/// Table:			
/// Input:			
/// Output:			
/// HowToUse:		w ##class(DHCWL.MKPILogin.LoginService).IsLoginAppLibraryInited()
ClassMethod IsLoginAppLibraryInited() As %Status
{
	set zero=0, loginType=$zcvt("LoginType","U")
	if $d(^DHCWL.MKPI.APPLibraryI("AppForCodeI",loginType))
	{
		if '$d(^DHCWL.MKPI.APPLibraryI("AppForCodeI",loginType,$zcvt("KpiLogDefinition","U")))
		{
			s obj=##class(DHCWL.MKPI.APPLibrary).%New()
			s obj.AppFor="LoginType",obj.Code="KpiLogDefinition",obj.Name="指标定义日志",obj.Describe="用于记录指标定义变更的日志"
			w obj.%Save()_":KpiLogDefinition"_" is inserted",!
		}
		if '$d(^DHCWL.MKPI.APPLibraryI("AppForCodeI",loginType,$zcvt("KpiLogDataProcess","U")))
		{
			s obj=##class(DHCWL.MKPI.APPLibrary).%New()
			s obj.AppFor="LoginType",obj.Code="KpiLogDataProcess",obj.Name="数据处理日志",obj.Describe="用于记录指标数据变更的日志"
			w obj.%Save()_":KpiLogDataProcess"_" is inserted",!
		}
		if '$d(^DHCWL.MKPI.APPLibraryI("AppForCodeI",loginType,$zcvt("KpiLogDataQuery","U")))
		{
			s obj=##class(DHCWL.MKPI.APPLibrary).%New()
			s obj.AppFor="LoginType",obj.Code="KpiLogDataQuery",obj.Name="数据查询日志",obj.Describe="用于记录指标标准Query查询数据的日志"
			w obj.%Save()_":KpiLogDataQuery"_" is inserted",!
		}
		if '$d(^DHCWL.MKPI.APPLibraryI("AppForCodeI",loginType,$zcvt("KpiLogTaskErr","U")))
		{
			s obj=##class(DHCWL.MKPI.APPLibrary).%New()
			s obj.AppFor="LoginType",obj.Code="KpiLogTaskErr",obj.Name="任务错误日志",obj.Describe="用于记录指标任务执行时发生错误的日志"
			w obj.%Save()_":KpiLogTaskErr"_" is inserted",!
		}
		quit $$$OK
	}
	else{
		s ^DHCWL.MKPI.APPLibraryI("AppForCodeI",loginType)=""
		quit ##class(DHCWL.MKPILogin.LoginService).IsLoginAppLibraryInited()
	}
}

/// Creator:		LHH
/// CreatDate:		
/// Description:	将json串转换为数组
/// Table:			
/// Input:			content:json串; proValueArr:数组,存储转换后的值
/// Output:			
/// HowToUse:		d ##class(DHCWL.MKPILogin.LoginService).ResolveContent("{aa:10,bb:'HaHa',cc:""HeiHei""}",.arr)
ClassMethod ResolveContent(content As %Text = "", ByRef proValueArr)
{
	n (content,proValueArr)
	k proValueArr
	s content=##class(DHCWL.util.StringUtil).Trim(content)
	//将json格式解析为数组
	s proSIndex=0,proEIndex=-1,valSIndex=0,valEIndex=-1
	s len=$l(content),valueBrackets=""
	f i=1:1:len {
		s curChar=$e(content,i)
		if ((curChar="{")||(curChar="}")){
			if (proSIndex>proEIndex) s proSIndex=i+1
		}
		if ((curChar=":")&&(proSIndex>proEIndex)){
			s proEIndex=i-1,valSIndex=i+1,valEIndex=-1
			s pro=$e(content,proSIndex,proEIndex)
			if (pro'=""){
				if (($e(pro,1)="'")&&($e(pro,$l(pro))="'")){
					s pro=$e(pro,2,$l(pro)-1)
				}
				if (($e(pro,1)="""")&&($e(pro,$l(pro))="""")){
					s pro=$e(pro,2,$l(pro)-1)
				}
			}
			s proSIndex=0,proEIndex=-1
		}elseif (((curChar=","))&&(proSIndex>proEIndex)){
			s proSIndex=i+1
			if ((valSIndex>valEIndex)&&(valueBrackets="")){
				s valEIndex=i-1
				s value=$e(content,valSIndex,valEIndex)
				if (pro'=""){
					s proValueArr(pro)=value
				}
				s valSIndex=0,valEIndex=-1
			}
		}elseif ((curChar="""")&&(valEIndex=-1)){
			s valueBrackets="""",valEIndex=0,valSIndex=i+1
			continue
		}elseif ((curChar="'")&&(valEIndex=-1)){
			s valueBrackets="'",valEIndex=0,valSIndex=i+1
			continue
		}elseif ((curChar=valueBrackets)&&(valEIndex=0)){
			s valEIndex=i-1
			s value=$e(content,valSIndex,valEIndex)
			if (pro'=""){
				s proValueArr(pro)=value
			}
			s valSIndex=0,valEIndex=-1
		}
	}
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	将数组转换为json数据
/// Table:			
/// Input:			arr:待转换的数组
/// return:			json数据
/// HowToUse:		s arr("id")=1,arr("name")="JEFF",arr("nickName")="JEFF",json=##class(DHCWL.MKPILogin.LoginService).ArrayToJson(.arr)
ClassMethod ArrayToJson(ByRef arr) As DHCWL.util.Json
{
	n (arr)
	s tab="", tab=$o(arr(tab)), tabList="", valueList=""
	while(""'=tab){
		/// 组装json标签列表
		i (""=tabList) s tabList=tab
		e  s tabList=tabList_"^"_tab
		
		/// 组装json值列表
		i (""=valueList) s valueList="'"_$g(arr(tab))_"'"
		e  s valueList=valueList_"^'"_$g(arr(tab))_"'"
		s tab=$o(arr(tab))
	}
	
	/// 用定义的json标准格式初始化json容器
	s json=##class(DHCWL.util.Json).Json(tabList)
	/// 将组装好的json值列表有序的填充json容器
	d json.Insert(valueList)
	q json
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	将二维矩阵转换为json数据
/// Table:			
/// Input:			arrs:待转换的二维矩阵
/// return:			json数据
/// HowToUse:		s arr(1,"id")=1,arr(1,"name")="JEFF",arr(1,"nickName")="JEFF",arr(2,"id")=2,arr(2,"name")="JEFF2",arr(2,"nickName")="JEFF23",json=##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.arr)
ClassMethod MetrixToJson(ByRef arrs) As DHCWL.util.Json
{
	n (arrs)
	/// 处理二维矩阵转换为json数据(目前仅支持二维矩阵,对于二维数组尚不能很好支持)
	s tab="", nod="", nod=$o(arrs(nod)), tab=$o(arrs(nod,tab)), tabList="", valueList=""
	k valueArray	//edited by lhh
	while(""'=tab){
			/// 组装json标签列表
			i (""=tabList) s tabList=tab
			e  s tabList=tabList_"^"_tab
			s valueArray(tab)=""
			s tab=$o(arrs(nod,tab))
	}
	/// 用定义的json标准格式初始化json容器
	s json=##class(DHCWL.util.Json).Json(tabList)	
	s tab=$o(arrs(nod,""))
	
	while(""'=nod){
		s valueList="", tab=$o(arrs(nod,""))
		s property="" //edited by lhh20131105
		f {
			s property=$o(valueArray(property))
			q:property=""
			if ('$d(arrs(nod,property))){
				s value=""
			}else{
				s value=arrs(nod,property)
			}
			s:(value ["'") value=##class(DHCWL.util.StringUtil).ReplaceStr(value,"'","\'")
			i (""=valueList) s valueList="'"_value_"'"
			e  s valueList=valueList_"^'"_value_"'"
		}
		/*
		while(""'=tab){
			/// 组装json值列表
			i (""=valueList) s valueList="'"_$g(arrs(nod,tab))_"'"
			e  s valueList=valueList_"^'"_$g(arrs(nod,tab))_"'"
			s tab=$o(arrs(nod,tab))
		}
		if (tab=""){
			i (""=valueList) s valueList="''"
			e  s valueList=valueList_"^''"
		}*/
		/// 将组装好的json值列表有序的填充json容器
		d json.Insert(valueList)
		s nod=$o(arrs(nod))
	}
	q json
}

/// Creator:		LHH
/// CreatDate:		
/// Description:	查询指定时间段(可选)、指定类型、指定指标(可选)的日志信息
/// Table:			
/// Input:			loginTypeCode:日志类型编码,可取的值为{"KpiLogDefinition","KpiLogDataProcess","KpiLogDataQuery","KpiLogTaskErr"}; 
/// 				startDate:开始日期; endDate:结束日期;kpiId:
/// Output:			
/// HowToUse:		s json=##class(DHCWL.MKPILogin.LoginService).QueryLoginInfo("2013-10-10","2013-10-10","26","",15) 
ClassMethod QueryLoginInfo(startDate = "", endDate = "", loginTypeCode, kpiId = "", pageSize, start, end) As DHCWL.util.Json
{
	n (startDate, endDate, loginTypeCode, kpiId ,pageSize,start,end)
	q:(loginTypeCode="") 0
	//i (startDate'="")&&(endDate'="") s sDate=$zdh(startDate,3), eDate=$zdh(endDate,3)  //++//modify by wk~2017-03-03~公司时间控件标准化
	i (startDate'="")&&(endDate'="") s sDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(startDate),eDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	q:endDate<startDate 0
	s propertyList="ID^LoginDate^LoginSTime^LoginETime^Operator^LoginTypeDr^CalledFunction^MKPIIdList^PrePropertyList^PostPropertyList^ParaKpiRule^ParaFilterRule^ParaDateScope^ParaOther^OperateState^OtherContent"
	s len=$l(propertyList,"^"), counter=0
	
	s loginDate="" f  s loginDate=$o(^DHCWL.MKPI.LoginInfoI("LoginTypeDate",loginTypeCode,loginDate),-1) q:loginDate=""  d
	.q:($g(sDate)'="")&&($g(eDate)'="")&&((loginDate<$g(sDate))||(loginDate>$g(eDate))) 
	.s loginRowId="" f  s loginRowId=$o(^DHCWL.MKPI.LoginInfoI("LoginTypeDate",loginTypeCode,loginDate,loginRowId),-1) q:loginRowId=""  d
	..s iskpiIdIncluded="FALSE"	;指定的指标是否在当前的这条日志的指标列表(表DHCWL_MKPI.LoginInfo中的MKPIIdList)中
	..i (kpiId'="") d
	...s mkpiIdList=$lg(^DHCWL.MKPI.LoginInfoD(loginRowId),8)
	...s lenOfMkpiIdList=$l(mkpiIdList,",")
	...f pointer=1:1:lenOfMkpiIdList d
	....s currentMkpi=$p(mkpiIdList,",",pointer)
	....i (currentMkpi=kpiId) s iskpiIdIncluded="TRUE", pointer=lenOfMkpiIdList
	..q:(kpiId'="")&&(iskpiIdIncluded="FALSE")
	..s counter=counter+1
	..q:(""'=pageSize)&&((end<=counter)||(start>=counter))
	..s arrs(counter,"ID")=loginRowId
	..f nod=2:1:len d
	...s currentProperty=$p(propertyList,"^",nod)
	...s currentValue=$li(^DHCWL.MKPI.LoginInfoD(loginRowId),nod)
	...;i (nod=2) s currentValue=$zd(currentValue,3)   ////++//modify by wk~2017-03-03~公司时间控件标准化
	...i (nod=2) s currentValue=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(currentValue)
	...i (nod=3)||(nod=4) s currentValue=$zt(currentValue,1)
	...i (nod=6) s currentValue=$li(^DHCWL.MKPI.APPLibraryD(currentValue),4)
	...s arrs(counter,currentProperty)=$tr(currentValue,"^","∧")
	s ^||TEMPDHCWL("login","maxNum")=counter
	q:counter=0 counter
	q ##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.arrs)  //_"#"_counter
	;q:($d(arrs(1,"ID"))) ##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.z)
	q 0
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	将数组转换为字符串，仅用于日志记录
/// Table:			
/// Input:			arr:待转换的数组
/// return:			str数据
/// HowToUse:		s arr("name")="sad", arr("id")="007", arr("nickName")="super sad", arr("hobby")="swimming"
/// 				w ##class(DHCWL.MKPILogin.LoginService).ArrayToString(.arr)
ClassMethod ArrayToString(ByRef arr) As %String
{
	s rtnStr=""
	s nod="" f  s nod=$o(arr(nod)) q:nod=""  d
	.i (rtnStr="") s rtnStr=arr(nod)
	.e  s rtnStr=rtnStr_","_arr(nod)
	q rtnStr
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	取指标定义，并转换为字符串，仅用于日志记录
/// Table:			
/// Input:			kpiId:指标Id; .arr:接收返回指标定义的数组
/// return:			
/// HowToUse:		d ##class(DHCWL.MKPILogin.LoginService).GetKpiDefinition("6",.arr)
ClassMethod GetKpiDefinition(kpiId, ByRef arr)
{
	n (kpiId, arr)
	q:""=kpiId
	q:'$d(^DHCWL.MKPI.MKPID(kpiId))
	s arr("MKPICode")=$lg(^DHCWL.MKPI.MKPID(kpiId),2,"")
	s arr("MKPIName")=$lg(^DHCWL.MKPI.MKPID(kpiId),3,"")
	s arr("MKPIEXCode")=$lg(^DHCWL.MKPI.MKPID(kpiId),4,"")
	i $f(arr("MKPIEXCode"),"^") s arr("MKPIEXCode")=$tr(arr("MKPIEXCode"),"^","~")
	s arr("MKPIDesc")=$lg(^DHCWL.MKPI.MKPID(kpiId),5,"")
	s arr("MKPIRemark")=$lg(^DHCWL.MKPI.MKPID(kpiId),6,"")
	s arr("MKPIUpdateDate")=$lg(^DHCWL.MKPI.MKPID(kpiId),7,"")
	s arr("MKPIUser")=$lg(^DHCWL.MKPI.MKPID(kpiId),8,"")
	s arr("MKPICate")=$lg(^DHCWL.MKPI.MKPID(kpiId),9,"")
	s arr("MKPITypeDr")=$lg(^DHCWL.MKPI.MKPID(kpiId),10,"")
	s arr("MKPISectionFlag")=$lg(^DHCWL.MKPI.MKPID(kpiId),11,"")
	s arr("MKPIDataNod")=$lg(^DHCWL.MKPI.MKPID(kpiId),12,"")
	s arr("MKPIGlobalFlag")=$lg(^DHCWL.MKPI.MKPID(kpiId),13,"")
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	取指标维度定义，并转换为字符串，仅用于日志记录
/// Table:			
/// Input:			kpiDimId:指标维度Id; .arr:接收返回指标维度定义的数组
/// return:			
/// HowToUse:		d ##class(DHCWL.MKPILogin.LoginService).GetKpiDimDefinition("5",.arr)
ClassMethod GetKpiDimDefinition(kpiDimId, ByRef arr)
{
	n (kpiDimId, arr)
	q:""=kpiDimId
	q:'$d(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId))
	s arr("MKPIDimCode")=$li(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),2)
	s arr("MKPIDr")=$li(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),3)
	s arr("MKPIDimDes")=$li(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),4)
	s arr("MKPIDimDimDr")=$li(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
	//	MKPIDimOrder:指标的第几个指标维度
	s arr("MKPIDimOrder")=$li(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6)
	s arr("MKPIDimDeli")=$li(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),7)
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	取维度定义，并转换为字符串，仅用于日志记录
/// Table:			
/// Input:			dimId:维度Id; .arr:接收返回指标维度定义的数组
/// return:			
/// HowToUse:		d ##class(DHCWL.MKPILogin.LoginService).GetDimDefinition(5,.arr)
ClassMethod GetDimDefinition(dimId, ByRef arr)
{
	n (dimId, arr)
	q:""=dimId
	q:'$d(^DHCWL.MKPI.MKPIDimTypeD(dimId))
	s arr("KDTCode")=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),2,"")
	s arr("KDTName")=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),3,"")
	s arr("KDTEXCode")=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),4,"")
	s arr("KDTDesc")=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),5,"")
	s arr("KDTRemark")=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),6,"")
	s arr("KDTUpdateDate")=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),7,"")
	s arr("KDTUser")=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),8,"")
	s arr("KDTExeCode")=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),9,"")
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	比较两个数组，仅用于日志记录
/// Table:			
/// Input:			arrSource:源数组, arrDest:目标数组
/// return:			str:如果目标数组为空,返回源数组得到的字符串; 否则返回目标数组(目标数组和源数组之间不同的部分)得到的字符串
/// HowToUse:		w ##class(DHCWL.MKPILogin.LoginService).GetJsonStrByCompare(.arrS, .arrD)
ClassMethod GetJsonStrByCompare(ByRef arrSource, ByRef arrDest) As %String
{
	n (arrSource, arrDest)
	q:('$d(arrSource)) ""
	s rtnStr=""
	s fieldName=$o(arrSource(""))
	while(""'=fieldName){
			i ('$d(arrDest(fieldName)))
			{
				//	如果比较的目标数组为空，则返回源数组所有字段
				i (""=rtnStr) s rtnStr=fieldName_"："_arrSource(fieldName)
				e  s rtnStr=rtnStr_"，"_fieldName_"："_arrSource(fieldName) 
			}
			i ($d(arrDest(fieldName)))&&($d(arrSource(fieldName)))&&(arrSource(fieldName)'=arrDest(fieldName))
			{
				//	找出源数组中和目标数组所有不同的字段
				i (""=rtnStr) s rtnStr=fieldName_"："_arrDest(fieldName)
				e  s rtnStr=rtnStr_"，"_fieldName_"："_arrDest(fieldName)
			}
			s fieldName=$o(arrSource(fieldName))
		}
	q rtnStr
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	将数组转换为Json格式字符串，仅用于日志记录
/// Table:			
/// Input:			arr:执行记录
/// return:			rtnStr:Json格式字符串
/// HowToUse:		w ##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.arr)
ClassMethod ArrayToJsonStr(ByRef arr) As %String
{
	s rtnStr=""
	s fieldName=$o(arr(""))
	while(""'=fieldName)
	{
		/* --modify by wz.2014-6-21
		i (""=rtnStr) s rtnStr="{"_fieldName_":'"_arr(fieldName)_"'"
		e  s rtnStr=rtnStr_","_fieldName_":'"_arr(fieldName)_"'"
		*/
		i (""=rtnStr) s rtnStr="{"_fieldName_":'"_$TRANSLATE(arr(fieldName),":","：")_"'"
		e  s rtnStr=rtnStr_","_fieldName_":'"_$TRANSLATE(arr(fieldName),":","：")_"'"

		s fieldName=$o(arr(fieldName))
	}
	s rtnStr=rtnStr_"}"
	q rtnStr
}

ClassMethod aaaa(ff)
{
	n (ff)
	w ff
	q
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	抓取错误，仅用于日志记录
/// Table:			
/// Input:			execStr:执行记录
/// return:			
/// HowToUse:		d ##class(DHCWL.MKPILogin.LoginService).GetErrorInTask()
ClassMethod GetErrorInTask()
{
	n (kpiId,execStr,startDate,endDate,ContextLevel,errorOccured)
	//s execStr=$g(execStr)
	k ^TEMPDHCWLKPIDATA("S",$j)
	s fromDate=$g(startDate), toDate=$g(endDate)
	s errorOccured=1
	q:(0=$d(kpiId))
	s ^||TEMPDHCWLKPIDATA("Login",$j,"execStr",kpiId)=$g(execStr)
	s ^||TEMPDHCWLKPIDATA("Login",$j,"error",kpiId)=$ze
	s loginType=$g(^||TEMPDHCWLKPIDATA("Login",$j,"type"))
	do:$d(^TEMPDHCWL("KPI","CreatDate","progress","start")) ##class(DHCWL.util.DHCWLutilKPIDataBar).end(-1)
	//任务结束释放标志供后续任务继续执行
 	//add by lhh@20180704 start
 	d ##class(DHCWL.util.TaskUitl).Finish()
 	//add by lhh@20180704 end
	
	//	根据系统配置决定是否挂起整个指标任务
	s code="GlobalTaskSuspendCfg", value=""
	s obj=##class(DHCWL.SysService.SysVarService).GetObjBySysVarCode(code)
	i (""'=obj){
		s value=obj.SysVarValue
	}
	if ("Y"=value) {
		//s ^TEMPDHCWL("creatKpiDate",dataFlag)=-1
		i ($g(deeperContext)<$STACK) s deeperContext=$STACK
		if (""'=$g(ContextLevel))&&((ContextLevel+1=$STACK)) {
			w "执行语句："_execStr_"时发生错误:"_$ze,!
			i ($g(deeperContext)>=$STACK) d ##class(DHCWL.MKPILogin.LoginService).SetTaskErrLog()
			s $ze=""
			k ^||TEMPDHCWLKPIDATA("Login",$j)
			//set $ECODE=""		;需要挂起整个指标任务时，我们并不清除触发错误的相关参数，引起整个任务挂起。整个过程是很安全的
			
		}
	}else{
		;s ^TEMPDHCWL("creatKpiDate",dataFlag,"count")=^TEMPDHCWL("creatKpiDate",dataFlag,"count")+1
		;s ^TEMPDHCWL("creatKpiDate",dataFlag)=-1
		i ($g(deeperContext)<$STACK) s deeperContext=$STACK
		///	只在错误代码发生的最深一级上下文中记录日志
		if ($g(deeperContext)>=$STACK) {
			w "指标Id为："_kpiId_" 的指标生成数据过程中发生错误，已记入指标任务错误日志。"
			d ##class(DHCWL.MKPILogin.LoginService).SetTaskErrLog()
			k ^||TEMPDHCWLKPIDATA("Login",$j)
		}
		set $ECODE=""
		s $ze=""
	}
	quit
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	记录生成数据日志，仅用于日志记录
/// Table:			
/// Input:			
/// return:			
/// HowToUse:		d ##class(DHCWL.MKPILogin.LoginService).SetDataProcessLog()
ClassMethod SetDataProcessLog() As LoginService
{
	s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataProcess")
	s loginTypeDr=login("LoginTypeDr")
	d WriteLogRecord
	//s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("Login",$j,"kpiId",kpiId)) q:kpiId=""  d
 	//.s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDataProcess",kpiId)
 	//.q:(1'=shouldBeLogged)
 	//.d WriteLogRecord
 	
 	//i $d(^TEMPDHCWLKPIDATA("Login",$j,"over")) k ^TEMPDHCWLKPIDATA("Login",$j)
 	quit loginService
 	
WriteLogRecord
 	s login("CalledFunction")=$g(^||TEMPDHCWLKPIDATA("Login",$j,"CalledFunction"))
 	//s login("Operator")=""		//--modify by wz.2014-12-24
 	//add by wz.2014-12-23
	s loginOperator=""
	i $d(^||TEMPDHCWLKPIDATA("Login-OtherInfos",$j,"Operator")) s loginOperator=$g(^||TEMPDHCWLKPIDATA("Login-OtherInfos",$j,"Operator"))
	s login("Operator")=loginOperator	
 	
 	s login("MKPIIdList")=$g(^||TEMPDHCWLKPIDATA("Login",$j,"kpiIds"))
 	s login("ParaDateScope")="fromDate："_$g(^||TEMPDHCWLKPIDATA("Login",$j,"fromDate"))_"; toDate："_$g(^||TEMPDHCWLKPIDATA("Login",$j,"toDate"))
 	s login("OperateState")=$zt($p($h,",",2),3)
 	s login("ParaOther")=$g(^||TEMPDHCWLKPIDATA("Login",$j,"ParaOther"))
 	
 	s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
 	s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
 	s status=loginService.LoginStart("KpiLogDataProcess","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
 	s status=loginService.LoginContent(jsonStr)
 	s status=loginService.LoginEnd()
 	quit
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	记录指标任务日志，仅用于日志记录
/// Table:			
/// Input:			
/// return:			
/// HowToUse:		d ##class(DHCWL.MKPILogin.LoginService).SetTaskErrLog()
ClassMethod SetTaskErrLog()
{
	n (kpiId,execStr,fromDate,toDate)
	q:(""=kpiId)
	s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogTaskErr")
 	s loginTypeDr=login("LoginTypeDr")
	s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogTaskErr",kpiId)
 	q:(1'=shouldBeLogged)
 	d SetLogRecord
 	
 	//i $d(^TEMPDHCWLKPIDATA("Login",$j,"over")) k ^TEMPDHCWLKPIDATA("Login",$j)
 	quit
 	
SetLogRecord
 	s login("CalledFunction")=$g(^||TEMPDHCWLKPIDATA("Login",$j,"CalledFunction"))

 	//add by wz.2014-12-23
	s loginOperator=""
	i $d(^||TEMPDHCWLKPIDATA("Login-OtherInfos",$j,"Operator")) s loginOperator=$g(^||TEMPDHCWLKPIDATA("Login-OtherInfos",$j,"Operator"))
	s login("Operator")=loginOperator	
 	
 	s login("MKPIIdList")=$g(kpiId)
 	s login("ParaDateScope")="fromDate："_$g(fromDate)_"; toDate："_$g(toDate)
 	s login("OperateState")=$zt($p($h,",",2),3)
 	s login("ParaOther")=""
 	i ""'=$g(^||TEMPDHCWLKPIDATA("Login",$j,"error",kpiId))
 	{
		s login("OperateState")="error occured!"
 		s login("ParaOther")="执行语句："_$g(^||TEMPDHCWLKPIDATA("Login",$j,"execStr",kpiId))_"时，发生错误"_$g(^||TEMPDHCWLKPIDATA("Login",$j,"error",kpiId))
 	}
 	s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
 	s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
 	s status=loginService.LoginStart("KpiLogTaskErr","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
 	s status=loginService.LoginContent(jsonStr)
 	s status=loginService.LoginEnd()
 	quit
}

/// 	d ##class(DHCWL.MKPILogin.LoginService).StopLogRobot()
ClassMethod StopLogRobot()
{
	k ^||TEMPDHCWLKPIDATA("Login",$j)
	
	//add by wz.2014-12-24
	k ^||TEMPDHCWLKPIDATA("Login-OtherInfos",$j)
}

/// 		日志记录查询Query，用于给其他模块提供日志记录数据。先提供ResultSet形式数据
/// Creator:		JEFF
/// CreatDate:		2014-03-04
/// Description:	提供标准ResultSet数据的日志记录查询Query
/// Table:			DHCWL.MKPI_LoginInfo
/// Input:			fromDate, toDate, logType:日志类型编码,可取的值为{"KpiLogDefinition","KpiLogDataProcess","KpiLogDataQuery","KpiLogTaskErr"}; 
/// Output:			
/// Return:			
/// 	d ##class(%ResultSet).RunQuery("DHCWL.MKPILogin.LoginService","QueryLogRecord","2014-03-01","2014-03-06")
Query QueryLogRecord(fromDate As %String, toDate As %String, logType As %String = "") As %Query(ROWSPEC = "ID:%Integer,LoginDate:%String,LoginSTime:%String,LoginETime:%String,Operator:%String,LoginTypeDr:%String,CalledFunction:%String,MKPIIdList:%String,PrePropertyList:%String,PostPropertyList:%String,ParaKpiRule:%String,ParaFilterRule:%String,ParaDateScope:%String,ParaOther:%String,OperateState:%String,OtherContent:%String") [ SqlProc ]
{
}

ClassMethod QueryLogRecordExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, logType As %String = "") As %Status
{
	n (qHandle, fromDate, toDate, logType)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)

	q:fromDate="" $$$OK
	q:toDate="" $$$OK
	k ^TEMPDHCWL($j)
	
	s fromDate=$zdh(fromDate,3), toDate=$zdh(toDate,3)
	s propertyList="ID^LoginDate^LoginSTime^LoginETime^Operator^LoginTypeDr^CalledFunction^MKPIIdList^PrePropertyList^PostPropertyList^ParaKpiRule^ParaFilterRule^ParaDateScope^ParaOther^OperateState^OtherContent"
	s len=$l(propertyList,"^")
	
	//设置列标题
	s list=$ListFromString(propertyList,"^")
	d OutputRowAA
	
	s mLogType="" f  s mLogType=$o(^DHCWL.MKPI.LoginInfoI("LoginTypeDate",mLogType)) q:""=mLogType  d
	.q:(""'=logType)&&(logType'=mLogType)
	.s logDate="" f  s logDate=$o(^DHCWL.MKPI.LoginInfoI("LoginTypeDate",mLogType,logDate),-1) q:logDate=""  d
	..q:'((logDate<=toDate)&&(logDate>=fromDate))
	..s logRowId="" f  s logRowId=$o(^DHCWL.MKPI.LoginInfoI("LoginTypeDate",mLogType,logDate,logRowId),-1) q:logRowId=""  d
	...s list=$listbuild(logRowId)
	...s LoginDate="",LoginSTime="",LoginETime="",Operator="",LoginTypeDr="",CalledFunction=""
	...s MKPIIdList="",PrePropertyList="",PostPropertyList="",ParaKpiRule="",ParaFilterRule=""
	...s ParaDateScope="",ParaOther="",OperateState="",OtherContent=""
	...f nod=2:1:len d
	....s currentValue=$li(^DHCWL.MKPI.LoginInfoD(logRowId),nod)
	....i (nod=2) s currentValue=$zd(currentValue,3)
	....i (nod=3)||(nod=4) s currentValue=$zt(currentValue,3)
	....i (nod=6) s currentValue=$li(^DHCWL.MKPI.APPLibraryD(currentValue),4)
	....s $list(list,$listlength(list)+1)="'"_currentValue_"'"
	...d OutputRowAA
	Quit $$$OK
OutputRowAA
	//s data=$lb(ID,LoginDate,LoginSTime,LoginETime,Operator,LoginTypeDr,CalledFunction,MKPIIdList,PrePropertyList,PostPropertyList,ParaKpiRule,ParaFilterRule,ParaDateScope,ParaOther,OperateState,OtherContent)
 	Set data=list
 	k list
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryLogRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLogRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryLogRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLogRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     	王峥
/// CreatDate：    	2014-03-21
/// Description:： 根据代码获取指标id的串,用","分隔，支持模糊查找
/// Table：       DHCWL_MKPI.DHCWLMKPI
/// Input：       codeStr:kpi代码串,用","分隔
/// Output：      
/// Return：      成功返回kpi id串,否则返回""
/// Others：
ClassMethod GetKPIIdStrByCodeWithLike(codeStr) As %String
{
	n (codeStr) 
	q:codeStr="" ""
	s codeLen=$l(codeStr,",")
	s kpiStr=""
	f len=1:1:codeLen d
	.s code=$p(codeStr,",",len)
	.q:code=""
	.s kpiID=0
	.f  s kpiID=$o(^DHCWL.MKPI.MKPID(kpiID)) q:kpiID=""  d
	..s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiID),2)
	..q:$g(kpiCode)=""
	..q:($zcvt(kpiCode,"U") '[ $zcvt(code,"U"))
	..i kpiStr="" s kpiStr=kpiID
	..e  s kpiStr=kpiStr_","_kpiID
	q kpiStr
}

}
