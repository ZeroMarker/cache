Class DHCWL.util.CheckKpiData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:         wk
/// CreatDate:       2015-11-24
/// Description:     指标索引检查，指标数据或指标索引异常，重建索引
/// Table:          
/// Input: 			
/// Return:			如果存在错误，返回处理错误的信息
/// Others:			do ##class(DHCWL.util.CheckKpiData).CheckKpi()
ClassMethod CheckKpi(inFlag = 0, ByRef data)
{
	n (inFlag,data)
	s $zt="ErrorReturn"
 	s kpiName=""
 	s num=0
 	//通过指标索引找指标数据，如果找不到重做索引
 	for {	
	    s flag=0
	 	s kpiId=""
 	 	s kpiName=$o(^DHCWL.MKPI.MKPII("MKPIName",kpiName))
 	 	q:kpiName=""
 	 	for{
 	 		s kpiId=$o(^DHCWL.MKPI.MKPII("MKPIName",kpiName,kpiId))    
 	 		q:kpiId=""
 	 		s num=num+1
 	 		s sign=$d(^DHCWL.MKPI.MKPID(kpiId))
 	 		if sign=0{
	 			k ^DHCWL.MKPI.MKPII("MKPIName")
	 			Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPIName"))
	 			//w "已重建指标名索引",!
	 			s data("指标名索引错误","已解决,已重建指标名索引")=""
	 			s flag=1
	 			q
 	 		}
 	 	}
 	 	if (flag=1){
	 	 	q
 	 	}
 	}
 	//通过指标数据找指标索引，找不到重做索引
 	s kpiId=""
 	for{
	 	s sign=0
	 	s kpiId=$o(^DHCWL.MKPI.MKPID(kpiId))
	 	q:kpiId=""
	 	s kpiName=$lg(^DHCWL.MKPI.MKPID(kpiId),5,"")
	 	if ((kpiName="")||(kpiName=$c(0))){
	 		s cKpiName=""
	 		for{
		 		s cKpiName=$o(^DHCWL.MKPI.MKPII("MKPIName",cKpiName))
		 		q:cKpiName=""
		 		s cKpiId=""
		 		for{
			 		s cKpiId=$o(^DHCWL.MKPI.MKPII("MKPIName",cKpiName,cKpiId))
			 		q:cKpiId=""
			 		if (cKpiId=kpiId){
				 		s sign=1
				 		q
			 		}
		 		}
		 		if (sign=1){
		 			q
		 		}
	 		}
	 		if (sign=1){
		 		continue
	 		}else{
		 		k ^DHCWL.MKPI.MKPII("MKPIName")
		 		Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPIName"))
	 			//w "已重建指标名索引",!
	 			s data("指标名索引错误","已解决,已重建指标名索引")=""
		 		q
	 		}
	 	}
	 	s kpiName=$SYSTEM.SQL.ALPHAUP(kpiName)
	 	if ($d(^DHCWL.MKPI.MKPII("MKPIName",kpiName,kpiId))=0){
			k ^DHCWL.MKPI.MKPII("MKPIName")
	 		Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPIName"))
	 		//w "已重建指标名索引",!
	 		s data("指标名索引错误","已解决,已重建指标名索引")=""
	 		q
	 	}
 	}
 
 	//通过指标类型索引找指标数据，找不到重做索引
 	s kpiCate=""
 	s num=0
 	for {
		s flag=0
		s kpiId=""
 		s kpiCate=$o(^DHCWL.MKPI.MKPII("MKPICate",kpiCate))
 		q:kpiCate=""
 		for{
 			s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICate",kpiCate,kpiId))
 			q:kpiId=""
 			s num=num+1
 			s sign=$d(^DHCWL.MKPI.MKPID(kpiId))
 			if sign=0{
	 			k ^DHCWL.MKPI.MKPII("MKPICate")
	 			Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPICate"))
	 			//w "已重建指标类型索引",!
	 			s data("指标类型索引错误","已解决,已重建指标类型索引")=""
	 			s flag=1
	 			q
 			}
 		}
 		if (flag=1){
 			q
 		}
 	}
 	//通过指标数据找指标类型索引，找不到重做指标索引
 	s kpiId=""
 	for{
	 	s sign=0
	 	s kpiId=$o(^DHCWL.MKPI.MKPID(kpiId))
	 	q:kpiId=""
	 	s kpiCate=$lg(^DHCWL.MKPI.MKPID(kpiId),9,"")
	 	if ((kpiCate="")||(kpiCate=$c(0))){
	 		s cKpiCate=""
	 		for{
		 		s cKpiCate=$o(^DHCWL.MKPI.MKPII("MKPICate",cKpiCate))
		 		q:cKpiCate=""
		 		s cKpiId=""
		 		for{
			 		s cKpiId=$o(^DHCWL.MKPI.MKPII("MKPICate",cKpiCate,cKpiId))
			 		q:cKpiId=""
			 		if (cKpiId=kpiId){
				 		s sign=1
				 		q
			 		}
		 		}
		 		if (sign=1){
		 			q
		 		}
	 		}
	 		if (sign=1){
		 		continue
	 		}else{
		 		k ^DHCWL.MKPI.MKPII("MKPICate")
		 		Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPICate"))
	 	    	//w "已重建指标类型索引",!
	 	    	s data("指标类型索引错误","已解决,已重建指标类型索引")=""
		 		q
	 		}
	 	}
	 	if ($d(^DHCWL.MKPI.MKPII("MKPICate",kpiCate,kpiId))=0){
			k ^DHCWL.MKPI.MKPII("MKPICate")
	 		Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPICate"))
	 		//w "已重建指标类型索引",!
	 		s data("指标类型索引错误","已解决,已重建指标类型索引")=""
	 		q
	 	}
 	}
 
 	//通过指标编码索引找指标数据，找不到重做指标索引
 	s kpiCode=""
 	s num=0
 	for {
		s flag=0
		s kpiId=""
 		s kpiCode=$o(^DHCWL.MKPI.MKPII("MKPICode",kpiCode))
 		q:kpiCode=""
 		for{
 			s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICode",kpiCode,kpiId))
 			q:kpiId=""
 			s num=num+1
 			s sign=$d(^DHCWL.MKPI.MKPID(kpiId))
 			if sign=0{
	 			k ^DHCWL.MKPI.MKPII("MKPICode")
	 			Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPICode"))
	 			//w "已重建指标编码索引",!
	 			s data("指标编码索引错误","已解决,已重建指标编码索引")=""
	 			s flag=1
	 			q
 			}
 		}
 		if (flag=1){
	 		q
 		}
 	}
 	//通过指标数据找指标编码索引，找不到重做指标数据
 	s kpiId=""
 	for{
	 	s sign=0
	 	s kpiId=$o(^DHCWL.MKPI.MKPID(kpiId))
	 	q:kpiId=""
	 	s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2,"")
	 	if ((kpiCode="")||(kpiCode=$c(0))){
	 		s cKpiCode=""
	 		for{
		 		s cKpiCode=$o(^DHCWL.MKPI.MKPII("MKPICode",cKpiCode))
		 		q:cKpiCode=""
		 		s cKpiId=""
		 		for{
			 		s cKpiId=$o(^DHCWL.MKPI.MKPII("MKPICode",cKpiCode,cKpiId))
			 		q:cKpiId=""
			 		if (cKpiId=kpiId){
				 		s sign=1
				 		q
			 		}
		 		}
		 		if (sign=1){
		 			q
		 		}
	 		}
	 		if (sign=1){
		 		continue
	 		}else{
		 		k ^DHCWL.MKPI.MKPII("MKPICode")
		 		Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPICode"))
	 			//w "已重建指标编码索引",!
	 			s data("指标编码索引错误","已解决,已重建指标编码索引")=""
		 		q
	 		}
	 	}
	 	s kpiCode=$SYSTEM.SQL.ALPHAUP(kpiCode)
	 	if ($d(^DHCWL.MKPI.MKPII("MKPICode",kpiCode,kpiId))=0){
			k ^DHCWL.MKPI.MKPII("MKPICode")
	 		Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPICode"))
	 		//w "已重建指标编码索引",!
	 		s data("指标编码索引错误","已解决,已重建指标编码索引")=""
	 		q
	 	}
 	}
 	//通过指标取值方式索引匹配指标数据，如果无法匹配重做指标数据
 	s kpiValueType=""
 	s num=0
 	for {
		s flag=0
		s kpiId=""
 		s kpiValueType=$o(^DHCWL.MKPI.MKPII("MKPIValueType",kpiValueType))
 		q:kpiValueType=""
 		for{
 			s kpiId=$o(^DHCWL.MKPI.MKPII("MKPIValueType",kpiValueType,kpiId))
 			q:kpiId=""
 			s num=num+1
 			s sign=$d(^DHCWL.MKPI.MKPID(kpiId))
 			if sign=0{
	 			k ^DHCWL.MKPI.MKPII("MKPIValueType")
	 			Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPIValueType"))
	 			//w "已重建指标取值方式索引",!
	 			s data("指标取值方式索引错误","已解决,已重建指标取值方式索引")=""
	 			s flag=1
	 			q
 			}
 		}
 		if (flag=1){
	 		q
 		}
 	}
 	//w "共检查取值方式索引 "_num_" 条",!
 	//通过指标数据匹配指标取值方式索引，无法匹配重做指标索引
 	s kpiId=""
 	for{
	 	s sign=0
	 	s kpiId=$o(^DHCWL.MKPI.MKPID(kpiId))
	 	q:kpiId=""
	 	s kpiValueType=$lg(^DHCWL.MKPI.MKPID(kpiId),14,"")
	 	if ((kpiValueType="")||(kpiValueType=$c(0))){
	 		s cKpiValueType=""
	 		for{
		 		s cKpiValueType=$o(^DHCWL.MKPI.MKPII("MKPIValueType",cKpiValueType))
		 		q:cKpiValueType=""
		 		s cKpiId=""
		 		for{
			 		s cKpiId=$o(^DHCWL.MKPI.MKPII("MKPIValueType",cKpiValueType,cKpiId))
			 		q:cKpiId=""
			 		if (cKpiId=kpiId){
				 		s sign=1
				 		q
			 		}
		 		}
		 		if (sign=1){
		 		q
		 		}
	 		}
	 		if (sign=1){
		 		continue
	 		}else{
		 		k ^DHCWL.MKPI.MKPII("MKPIValueType")
		 		Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPIValueType"))
	 			//w "已重建指标取值方式索引",!
	 			s data("指标取值方式索引错误","已解决,已重建指标取值方式索引")=""
		 		q
	 		}
	 	}else{
			 s kpiValueType=" "_kpiValueType
	 	}
	 	if ($d(^DHCWL.MKPI.MKPII("MKPIValueType",kpiValueType,kpiId))=0){
			k ^DHCWL.MKPI.MKPII("MKPIValueType")
	 		Do ##class(DHCWL.MKPI.MKPI).%BuildIndices($ListBuild("MKPIValueType"))
	 		//w "已重建指标取值方式索引",!
	 		s data("指标取值方式索引错误","已解决,已重建指标取值方式索引")=""
	 		q
	 	}
 	}
 	if (inFlag=0){
	 	s errorType=""
	 	for{
		 	s errorType=$o(data(errorType))
		 	q:errorType=""
		 	s errorInfor=""
		 	s errorInfor=$o(data(errorType,errorInfor))
		 	w errorType_" "_errorInfor,!
	 	}
 	}
 
 	q
ErrorReturn
	W !,"ERROR!!!"
	q 0
}

/// Creator:         wk
/// CreatDate:       2015-11-24
/// Description:     指标执行代码检查，若指标执行代码不存在或m文件、相应方法不存在则提示
/// Table:          
/// Input: 			
/// Return:			返回不存在的执行代码list
/// Others:			do ##class(DHCWL.util.CheckKpiData).CheckKpiExCode()
ClassMethod CheckKpiExCode(inFlag = 0, ByRef data)
{
	s kpiId=""
 	k kpiExCodeList
 	k saveExCodeList
 	new $ETRAP
 	s $ETRAP="do ##class(DHCWL.util.CheckKpiData).printError()"
 	s kpiId=""
 	//modify by wk~2017-03-21~解决执行代码运行时间过长的问题,且不再支持指标执行代码没有设置的检查
 	for{
	 	s kpiId=$o(^DHCWL.MKPI.MKPID(kpiId))
	 	q:kpiId=""
	 	s exCode=$li(^DHCWL.MKPI.MKPID(kpiId),4)
	 	continue:(exCode="")||(exCode=$c(0))
	 	s saveExCodeList(exCode)=""
 	}
 	//s num=0
 	s exCode=""
 	for {
	 	//s num=num+1
	 	//s kpiId=$o(^DHCWL.MKPI.MKPID(kpiId))
	 	//q:kpiId=""
	 	//s exCode=$li(^DHCWL.MKPI.MKPID(kpiId),4)
	 	s exCode=$o(saveExCodeList(exCode))
	 	q:exCode=""
	 	s ^||TEMPDHCWL("WKTEST",$J,"saveExCode")=exCode
	 	if (exCode="")||(exCode=$c(0)){
	 		continue
	 	}
	 	s exeCode="s kpiDate=$$"_exCode_"()"
	 	x exeCode   //运行指标执行代码，如果报错，跳入错误处理并把错误执行代码保存
 	}
 	s getSaveExCode=""
 	if (inFlag=0) {
 		w "m文件、相应方法不存在或存在问题的执行代码是: ",!
 	}
 	for{
	 	s getSaveExCode=$o(^||TEMPDHCWL("WKTEST",$J,"saveExCode",getSaveExCode))
	 	q:getSaveExCode=""
	 	if inFlag=0 { 
	 		w getSaveExCode,!
	 	}else{
		 	s data("指标执行代码的文件或方法不存在",getSaveExCode)=""
	 	}
 	}
 	K ^TEMPDHCWL("WKTEST")
 	q
}

ClassMethod printError()
{
	s errorInfor=$p($ZERROR,"<",2)
	s errorInfor=$p(errorInfor,">",1)
	if (((errorInfor)="NOROUTINE")||((errorInfor)="NOLINE")){
		s saveExCode=^||TEMPDHCWL("WKTEST",$J,"saveExCode")

		if ($d(^||TEMPDHCWL("WKTEST",$J,"saveExCode",saveExCode))=0){
			s ^||TEMPDHCWL("WKTEST",$J,"saveExCode",saveExCode)=""
		}

		
	}
	s $ECODE=""
	q
}

/// Creator:         wk
/// CreatDate:       2015-11-24
/// Description:     半年区间半年任务检查
/// Table:          
/// Input: 			
/// Return:			当存在半年区间或者半年任务的时候返回处理信息list
/// Others:			do ##class(DHCWL.util.CheckKpiData).CheckKpiSectionFlag()
ClassMethod CheckKpiSectionFlag(inFlag = 0, ByRef data)
{
	s $zt="SecErrorReturn"
 	s taskId=""
 	for{
		s saveTaskId=taskId
	 	s taskId=$o(^DHCWL.MKPI.CreatDataTaskD(taskId))
	 	q:taskId=""
	 	s SectionFlag=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),6)
	 	if SectionFlag="HY"{    //存在半年任务删除
		 	set creatDataTaskObj=##class(DHCWL.MKPI.CreatDataTask).%OpenId(taskId)
		 	s result=##class(DHCWL.MKPI.CreatDataTask).%Delete(creatDataTaskObj.%Oid())
 		 	if result'=1{
	     		w "error"
	     		q
 		 	}
		 	s taskId=saveTaskId
	 	}
	 }
 	//存在半年区间删除，并将季的父区间修正
 	s secHYID=$o(^DHCWL.MKPI.SectionI("SecCode","HY",""))
 	if secHYID'=""{
	 	s secQID=$o(^DHCWL.MKPI.SectionI("SecCode","Q",""))
	 	s secYID=$o(^DHCWL.MKPI.SectionI("SecCode","Y",""))
	 	if (secQID="")||(secYID=""){
		 	s data("存在半年区间","请检查删除")=""
			q
	 	}else{
		 	&sql(update DHCWL_MKPI.DHCWLSection set Sec_DirectParent=:secYID where ID=:secQID)
		 	if (SQLCODE'=0){
			 	s data("存在半年区间","请检查删除")=""
			 	q
		 	}
		 	&sql(delete from DHCWL_MKPI.DHCWLSection where ID=:secHYID)
		 	if (SQLCODE'=0){
			 	s data("存在半年区间","请检查删除")=""
				 q
		 	}else{
			 	s data("存在半年区间","已删除")=""
		 	}
	 	}
 	}
 	q
SecErrorReturn
  W !,"ERROR!!!"
  q 0
}

/// Creator:         wk
/// CreatDate:       2015-11-24
/// Description:     区间维度属性的区间、执行代码检查
/// Table:          
/// Input: 			
/// Return:			返回区间维度属性的区间、执行代码的检查结果
/// Others:			do ##class(DHCWL.util.CheckKpiData).CheckSection()
ClassMethod CheckSection(inFlag = 0, ByRef data)
{
	 new $ETRAP
	 s $ETRAP="do ##class(DHCWL.util.CheckKpiData).getErrorExecCode()"
	 k sectionList
	 k sectionIdList
	 k sectionInforList
	 k sectionExecList
	 k sectionTaskList
	 k sectionErrorExeList
	 set Code=""
	 s Codes=""
	 set SectionPropertyId=""
	 s sectionId=""
	 for{
	 	s sectionId=$o(^DHCWL.MKPI.SectionD(sectionId))
		q:sectionId=""
		s sectionIdList(sectionId)=""
	 }
	 for{
		 set SectionPropertyId=$o(^DHCWL.MKPI.SectionPropertyD(SectionPropertyId))
		 q:SectionPropertyId=""
		 set Code=$lg(^DHCWL.MKPI.SectionPropertyD(SectionPropertyId),2,"")
		 continue:Code=""
		 set SecDimDr=$lg(^DHCWL.MKPI.SectionPropertyD(SectionPropertyId),6,"")
		 if ($d(sectionIdList(SecDimDr))=0){
		 	if ($d(sectionTaskList(Code))=0){
		 		s sectionTaskList(Code)=""
		 	}
		 	continue	
		 }
		 continue:$d(sectionList(Code))
		 s sectionList(Code)=""
	 }
	 s Code=""
	 //检查区间维度属性执行代码
	 for{
		 s Code=$o(sectionList(Code))
		 q:Code=""
		 s UpCode=$SYSTEM.SQL.ALPHAUP(Code)
		 s i=""
		 for {
			 s i=$o(sectionIdList(i))
			 q:i=""
			 s sign=$d(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",i,UpCode))
			 if sign=0{
				 if ($d(sectionInforList(i))){
				 	s sectionInforList(i)=sectionInforList(i)_","
				 }else{
					 s sectionInforList(i)=""
				 }
				 s sectionInforList(i)=sectionInforList(i)_Code
				 continue
			 }
			 s SectionPropertyId=""
			 s SectionPropertyId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",i,UpCode,SectionPropertyId))
			 s ExeCode=$lg(^DHCWL.MKPI.SectionPropertyD(SectionPropertyId),5,"")
			 if (ExeCode="")||(ExeCode=$c(0)){
				 if ($d(sectionExecList(i))){
				 	s sectionExecList(i)=sectionExecList(i)_","
				 }else{
					 s sectionExecList(i)=""
				 }
				 s sectionExecList(i)=sectionExecList(i)_Code
			 }
			 else{
				 s ^||TEMPDHCWL("WKCHECK",$J,"saveExCode")=ExeCode
				 s sectionInfor="s kpiDate=$$"_ExeCode_"()"
				 x sectionInfor
			 }
		 }
	 }
	 if (inFlag=0){
		 w "维度属性维护界面的code存在非法区间值的有："_Codes
		 s Code=""
		 for{
			 s Code=$o(sectionTaskList(Code))
			 q:Code=""
			 if ($o(sectionTaskList(Code))=""){
			 	w Code
			 }else{
			 	w Code_","
			 }
		 }
		 w !
	 }
	 //检查区间维度属性执行代码
	 s sectionId=""
	 for{
		 s sectionId=$o(sectionIdList(sectionId))
		 q:sectionId=""
		 s sectionDesc=$lg(^DHCWL.MKPI.SectionD(sectionId),4,"")
		 if ($d(sectionInforList(sectionId))=0){
		 	q
		 }
		 if (inFlag=0){
		 	w "维度属性维护界面的code不存在"_sectionDesc_"区间的有："_sectionInforList(sectionId),!
		 }else{
			 //modify by wk~20170321~不检查区间维度属性不存在的区间
			 //s data("区间维度属性不存在"_sectionDesc_"区间的code:",sectionInforList(sectionId))=""
		 }
	 }
	 s sectionId=""
	 for{
		 s sectionId=$o(sectionExecList(sectionId))
		 q:sectionId=""
		 s sectionDesc=$lg(^DHCWL.MKPI.SectionD(sectionId),4,"")
		 if ($d(sectionExecList(sectionId))=0){
		 	q
		 }
		 if (inFlag=0){
		 	w "维度属性维护界面的code"_sectionDesc_"不存在执行代码的有："_sectionExecList(sectionId),!
		 }else{
			 s data("区间维度属性"_sectionDesc_"区间中不存在执行代码的code有")=sectionExecList(sectionId)
		 }
	 }
	 if (inFlag=0){
	 	w "区间维度属性执行代码中m文件或相应方法不存在：",!
	 }
	 s exeCode=""
	 for {
		 s exeCode=$o(^||TEMPDHCWL("WKCHECK",$J,"saveExCode",exeCode))
		 q:exeCode=""
		 if ($o(^||TEMPDHCWL("WKCHECK",$J,"saveExCode",exeCode))=""){
	 	 	if (inFlag=0) {
	 	 		w exeCode
	 	 	}else{
		 	 	s data("区间维度属性执行代码中m文件或相应方法不存在",exeCode)=""
	 	 	}
	     }else{
		     if (inFlag=0) {
		 	 	w exeCode,!
		     }else{
			    s data("区间维度属性执行代码中m文件或相应方法不存在",exeCode)=""
		     }
	 	 }
	 }
	 k ^TEMPDHCWL("WKCHECK")
	 q
}

ClassMethod getErrorExecCode()
{
 	s errorInfor=$p($ZERROR,"<",2)
 	s errorInfor=$p(errorInfor,">",1)
 	if (((errorInfor)="NOROUTINE")||((errorInfor)="NOLINE")){
	 	s saveExCode=^||TEMPDHCWL("WKCHECK",$J,"saveExCode")
	 	if ($d(^||TEMPDHCWL("WKCHECK",$J,"saveExCode",saveExCode))=0){
	 		s ^||TEMPDHCWL("WKCHECK",$J,"saveExCode",saveExCode)=""
	 	}
 	}
 	s $ECODE=""
 	q
}

/// Creator:         wk
/// CreatDate:       2015-11-24
/// Description:     维度属性执行代码检查
/// Table:          
/// Input: 			
/// Return:			返回维度属性执行代码的检查结果
/// Others:			do ##class(DHCWL.util.CheckKpiData).CheckDimExeCode()
ClassMethod CheckDimExeCode(inFlag = 0, ByRef data)
{
	 new $ETRAP
	 s $ETRAP="do ##class(DHCWL.util.CheckKpiData).getErrorInfor()"
	 k dimIdList
	 k dimExeList
	 s dimDr=""
	 for{
	 	s dimDr=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimDr))
	 	q:dimDr=""
	 	s dimCode=""
	 	for{
	 		s dimCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimDr,dimCode))
	 		q:dimCode=""
	 		s dimId=""
	 		for{
	 			s dimId=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimDr,dimCode,dimId))
	 			q:dimId=""
	 			s dimExeCode=$lg(^DHCWL.MKPI.DimPropertyD(dimId),6,"")
	 			if (dimExeCode="")||(dimExeCode=$c(0)){
		 			if ($d(dimIdList(dimDr))=0){
			 			s dimIdList(dimDr)=""
		 			}
	 			}
	 			else{
		 			s ^||TEMPDHCWL("WKCHECKTEST",$J,"saveExCode")=dimExeCode
			 		s exCode="s kpiDate=$$"_dimExeCode_"()"
			 		x exCode
		 		}
	 		}
	 	}
	 }
	 s dimDr=""
	 s dimDrs=""
	 for{
		 s dimDr=$o(dimIdList(dimDr))
		 q:dimDr=""
		 if (dimDrs=""){
			 s dimDrs=dimDr
		 }else{
			 s dimDrs=dimDrs_","_dimDr
		 }
	 }
	 if (inFlag=0){
	 	w "维度属性执行代码为空的维度ID有：",!
	 	w dimDrs
	 }
	 if (inFlag=1){
		 s data("维度属性执行代码为空的维度ID有")=dimDrs
	 }else{
	 	w "维度属性执行代码m文件或相应方法不存在的有："
	 }
	 s exeCode=""
	 for{
		 s exeCode=$o(^||TEMPDHCWL("WKCHECKTEST",$J,"saveExCode",exeCode))
		 q:exeCode=""
		 if ($o(^||TEMPDHCWL("WKCHECKTEST",$J,"saveExCode",exeCode))=""){
			 if (inFlag=0){
		 	 	w exeCode
			 }else{
				 s data("维度属性执行代码m文件或相应方法不存在的有",exeCode)=""
			 }
		 }else{
			 if (inFlag=0){
			 	w exeCode,!
			 }else{
				 s data("维度属性执行代码m文件或相应方法不存在的有",exeCode)=""
			 }
		 }
	 }
	 k ^TEMPDHCWL("WKCHECKTEST")
	 q
}

ClassMethod getErrorInfor()
{
 	s errorInfor=$p($ZERROR,"<",2)
 	s errorInfor=$p(errorInfor,">",1)
 	if (((errorInfor)="NOROUTINE")||((errorInfor)="NOLINE")){
	 	s dimExeCode=^||TEMPDHCWL("WKCHECKTEST",$J,"saveExCode")
		if ($d(^||TEMPDHCWL("WKCHECKTEST",$J,"saveExCode",dimExeCode))=0){
	 		s ^||TEMPDHCWL("WKCHECKTEST",$J,"saveExCode",dimExeCode)=""
	 	}
 	}
 	s $ECODE=""
 	q
}

/// Creator:         wk
/// CreatDate:       2016-03-14
/// Description:     指标维度顺序检查
/// Table:          
/// Input: 			
/// Return:			返回指标维度顺序检查结果
/// Others:			do ##class(DHCWL.util.CheckKpiData).CheckKpiDimOrder()
ClassMethod CheckKpiDimOrder(inFlag = 0, ByRef data)
{
	k kpiDimList
	s kpiDimId=""
	for{
		s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId))
		q:kpiDimId=""
		s kpiDimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6,"")
		s kpiId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),3,"")
		if ((kpiDimOrder="")||(kpiDimOrder=" ")){
			s kpiDimList(kpiId)=""
		}
	}
	s kpi=""
	for{
		s kpi=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpi))
		q:kpi=""
		if ($d(kpiDimList(kpi))){
			continue
		}
		s order=""
		s i=1
		for{
			s order=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpi,order))
			q:order=""
			if (order'=i){
				s kpiDimList(kpi)=""
				q
			}
			s i=i+1
		}
	}
	s kpiId=""
	s kpiIds=""
	if ($o(kpiDimList(kpiId))'=""){
		if (inFlag=0){
			w "指标维度顺序有问题的指标："
		}
		for{
			s kpiId=$o(kpiDimList(kpiId))
			q:kpiId=""
			if (inFlag=0){
				w kpiId_" "
			}else{
				if (kpiIds=""){
					s kpiIds=kpiId
				}else{
					s kpiIds=kpiIds_","_kpiId
				}
			}
		}
	}else{
		if (inFlag=0){
			w "不存在维度顺序有问题的指标"
		}else{
			s data("不存在维度顺序有问题的指标")=""
		}
	}
	if (kpiIds'=""){
		s data("指标维度排列顺序有问题的指标")=kpiIds
	}
	q
}

/// Creator:         wk
/// CreatDate:       2016-03-14
/// Description:     用于query调用
/// Table:          
/// Input: 			
/// Return:			检查传入的m文件是否正确
/// Others:			do ##class(DHCWL.util.CheckKpiData).CheckKpiExCodetest()
ClassMethod CheckKpiExCodetest(exCode)
{
	//s kpiId=""
 	k kpiExCodeList
 	K ^||TEMPDHCWL("exeCodeError",$J)
 	new $ETRAP
 	s $ETRAP="do ##class(DHCWL.util.CheckKpiData).printErrorr()"
	s ^||TEMPDHCWL("exeCodeError",$J,"saveExCode")=exCode
	s exCode="s kpiDate=$$"_exCode_"()"
	x exCode
}

ClassMethod printErrorr()
{
	s errorInfor=$p($ZERROR,"<",2)
	s errorInfor=$p(errorInfor,">",1)
	if (((errorInfor)="NOROUTINE")||((errorInfor)="NOLINE")){
		s saveExCode=^||TEMPDHCWL("exeCodeError",$J,"saveExCode")
		if ($d(^||TEMPDHCWL("exeCodeError",$J,"saveExCode",saveExCode))=0){
			s ^||TEMPDHCWL("exeCodeError",$J,"saveExCode",saveExCode)=""
		}
	}
	s $ECODE=""
	q
}

}
