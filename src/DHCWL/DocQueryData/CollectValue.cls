Class DHCWL.DocQueryData.CollectValue Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      duh
/// CreatDate：    2016年1月28日 21:20:04
/// Description:： 根据接口取指标汇总数据
/// Table：        DHCWL_DocQuery.DHCWLDocKpiDef,DHCWL_DocQuery.DHCWLDocKpiRelKpi
/// Input：        userCode:医生code、DocOrHead:(医生、科主任)
/// Output：       docCode:医生指标CODE,docDesc:医生指标描述,sysCode:系统指标代码,cost:费用,docType:医生指标归类
/// Return：       
/// Others：       d ##class(%ResultSet).RunQuery("DHCWL.DocQueryData.CollectValue","GetDirectory","191","2022-08-01","2022-08-01","科主任") 
Query GetDirectory(logId As %String, startDate As %String, endDate As %String, DocOrHead As %String) As %Query(ROWSPEC = "docCode:%String,docDesc:%String,docCategory:%String,sysCode:%String,docType:%String,dDesc:%String,cost:%Float") [ SqlProc ]
{
}

ClassMethod GetDirectoryExecute(ByRef qHandle As %Binary, logId As %String, startDate As %String, endDate As %String, DocOrHead As %String) As %Status
{
	n (qHandle,startDate,endDate,logId,DocOrHead)
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWLDOC($j)
    k ^TEMPDHCWLDIM($j)
    k ^TEMPArray($j)
    k ^TEMPDHCWLEXP($j)
    k ^TEMPDHCWLDIR("SUMVALUE",$j)
    i startDate="" Q $$$OK
    i endDate="" Q $$$OK
 	s locDesc = $$GetLocDesc^DHCWLAnalysisMethod(logId)
 	d ##class(DHCWL.DocQueryData.GetDirectorKpiQuery).GetDocKpiCFG(locDesc,DocOrHead,.config)
	s docKpiId = ""  f  s docKpiId=$o(^DHCWL.DocQuery.DocKpiDefI("MDocKPIDefClass"," "_DocOrHead,docKpiId)) q:docKpiId=""  d
	.s docKpiCode = $list(^DHCWL.DocQuery.DocKpiDefD(docKpiId),2)
	.s conf = "" f  s conf = $o(config("list",conf)) q:conf=""  d
	..i conf=docKpiCode  d
	...s rule = $g(config("list",docKpiCode))
	...s sysCode = $p(rule,"^",4)
	...i sysCode'=""  d
	....d ##class(DHCWL.DocQueryData.GetDirectorKpiQuery).GetDirectorQuery(startDate,endDate,rule) 
	....s docCode = $p(rule,"^",1)  //DOC001
	....s docDesc = $p(rule,"^",2)  //药品收入
	....s docType = $p(rule,"^",3)	//I
	....s sysCode = $p(rule,"^",4)  //DH0004
	....s docCategory = $p(rule,"^",7)  
	....s docQueryRule = $p(rule,"^",5)  //DH0004:PatDoc.DocName
	....s otherRule = $p(rule,"^",6)
	....s dCode = ""  f  s dCode = $o(^TEMPDHCWL($j,"dValue",dCode)) q:dCode=""  d
	.....s dDim = ""  f  s dDim = $o(^TEMPDHCWL($j,"dValue",dCode,dDim)) q:dDim=""  d
	......s dDesc =$p(^CTPCP(dDim,1),"^",2)
	......s cost = $g(^TEMPDHCWL($j,"dValue",dCode,dDim))
	......d OutputRow2
	...e  d
	....s docCode = $p(rule,"^",1)  
	....s docDesc = $p(rule,"^",2)  
	....s docType = $p(rule,"^",3)	
	....s sysCode = $p(rule,"^",4) 
	....s docCategory = $p(rule,"^",7) 
	....s docQueryRule = $p(rule,"^",5)  
	....d ##class(DHCWL.DocQueryData.GetDirectorKpiQuery).resolveDirectorConfigMap(docCode, docQueryRule)
	....s cmpAppKpiCode="" f  s cmpAppKpiCode=$o(^TEMPDHCWLConfigMap("CmpKpi",cmpAppKpiCode)) q:cmpAppKpiCode=""  d   
	.....s exp = $g(^TEMPDHCWLConfigMap("CmpKpi",cmpAppKpiCode))
	.....d ##class(DHCWL.DocQueryData.GetDirectorKpiQuery).GetCalKpiValue(cmpAppKpiCode,exp)
	.....s docId = ""  f  s docId = $o(^TEMPDHCWLDIR("SUMVALUE",$j,cmpAppKpiCode,docId)) q:docId=""  d
	......s cost = $g(^TEMPDHCWLDIR("SUMVALUE",$j,cmpAppKpiCode,docId))
	......s dDesc = $p(^CTPCP(docId,1),"^",2)
	......d OutputRow2	
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow2
	;s data=$lb(docCode,cost)
 	Set ^CacheTemp(repid,ind)=$lb(docCode,docDesc,docCategory,sysCode,docType,dDesc,cost)
 	Set ind=ind+1
 	quit
ReturnZero
	q 0
}

ClassMethod GetDirectoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDirectoryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDirectoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDirectoryExecute ]
{
	n (AtEnd,qHandle,Row)
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

/// Creator：      duh
/// CreatDate：    2016年1月25日 14:02:08
/// Description:： 汇总系统指标值
/// Table：        DHCWL_MKPIService.MKPIQuery
/// Input：        
/// Output：       resolved:配置内容
///               
/// Return：       
/// Others：       d ##class(DHCWL.DocQueryData.GetDocKpiQuery).GetStandardQuery("2013-07-01","2013-07-31","DOC001^药品收入^I^DH0004^DH0004:PatDoc.DocCode^DH0004:([{PatDoc.DocCode}=0003]&&{AdmType}=I&&[{PatDep.LocDesc} = 外科一组])")
ClassMethod GetDirectorQuery(sDate, eDate, rule)
{
	n (sDate,eDate,rule)
	s docCode = $p(rule,"^",1)  
	s docDesc = $p(rule,"^",2)  
	s docType = $p(rule,"^",3)	
	s sysCode = $p(rule,"^",4) 
	s docQueryRule = $p(rule,"^",5)  
	s otherRule = $p(rule,"^",6)
	k ^TEMPDHCWL($j)
	set rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	set sc=rs.Execute(sysCode,sDate,eDate,,,otherRule)
    While rs.Next(.sc) { 
	s value=$g(rs.Data("value"))
	s kpiId = $g(rs.Data("kpiId"))
	s dimId = $g(rs.Data("dimId"))
	//q:$g(dimId)=""
	s wdId = ""  f  s wdId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,wdId)) q:wdId=""  d
	.s wdCode = $li(^DHCWL.MKPI.MKPIDimTypeD(wdId),2)
	.i wdCode="CTLOC"  d
	..s dimensions = "" f  s dimensions = $o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,wdId,dimensions)) q:dimensions=""  d
	...s order = $li(^DHCWL.MKPI.MKPIDimensionsD(dimensions),6)
	...s docDim = $p(dimId,",",order)
	...q:'$d(^CTPCP(docDim,1))
	...s ^TEMPDHCWL($j,"dValue",docCode,docDim)=$g(^TEMPDHCWL($j,"dValue",docCode,docDim))+value
	...s ^TEMPDHCWLDOC($j,"docValue",docCode,docDim)=$g(^TEMPDHCWLDOC($j,"docValue",docCode,docDim))+value
		}
}

ClassMethod resolveDirectorConfigMap(docCode, queryRule)
{
	n (docCode, queryRule)
	k ^TEMPDHCWLConfigMap
	s operatorMap("+")=""
	s operatorMap("-")=""
	s operatorMap("*")=""
	s operatorMap("/")=""
	s operatorMap("(")=""
	s operatorMap(")")=""	
	s ruleLength = $l(queryRule)
	s ^TEMPDHCWLConfigMap("CmpKpi",docCode) = queryRule
	f num = 1:1:ruleLength  d
	.s alph = $e(queryRule,num)
	.s op=""  f  s op=$o(operatorMap(op)) q:op=""  d
	..i alph =  op   d
	...s ^TEMPDHCWLConfigMap("CmpKpi",docCode,num) = alph
	q
}

/// 计算类指标计算
/// d ##class(DHCWL.DocQueryData.GetDocKpiQuery).GetStandardQuery("")
ClassMethod GetCalKpiValue(cmpAppKpiCode, exp)
{
	n (exp,cmpAppKpiCode)
	s $zt = "ReturnZero"
	s kpiLen = $l(exp)
	s ind = ""
	s num = ""  f  s num  = $o(^TEMPDHCWLConfigMap("CmpKpi",cmpAppKpiCode,num))  q:num=""  d
    .i $g(ind) = ""  s ind = num
    .e  s ind = $g(ind)_"^"_num //1^8^15^16^17^24^32
	s len = $l(ind,"^")
	s crea =1
	s incre = 2
	f lp = 1:1:len  d
	.i $p(ind,"^",1) = 1  d
	..i lp'=len  d    //不到最后一个
	...s first = $p(ind,"^",lp)
	...s second = $p(ind,"^",lp+1)
	...i (second-first)>1  d 
	....s arrays("CmpKpi",cmpAppKpiCode,crea) = $e(exp,first+1,second-1) 
	....s crea = crea+1
	...e  d   //到最后一个
	....i kpiLen '= $p(ind,"^",len)  d   //不以符号结尾
	.....s arrays("CmpKpi",cmpAppKpiCode,crea) = $e(exp,$p(ind,"^",len)+1,kpiLen) 
	.e  d   //首字母不是符号
	..i lp'=len  d    //不到最后一个
	...s first = $p(ind,"^",lp)
	...s second = $p(ind,"^",lp+1)
	...i (second-first)>1  d 
	....s arrays("CmpKpi",cmpAppKpiCode,incre) = $e(exp,first+1,second-1) 
	....s incre = incre+1
	..e  d   //最后一个
	...i kpiLen '= $p(ind,"^",len)  d   //不以符号结尾
	....s arrays("CmpKpi",cmpAppKpiCode,$g(incre)) = $e(exp,$p(ind,"^",len)+1,kpiLen)
	..s arrays("CmpKpi",cmpAppKpiCode,1) = $e(exp,1,$p(ind,"^",1)-1)
	s flag=0
	s increa = ""  f  s increa = $o(arrays("CmpKpi",cmpAppKpiCode,increa))  q:increa=""  d
	.s code = $g(arrays("CmpKpi",cmpAppKpiCode,increa))
	.s dimId = ""  f  s dimId = $o(^TEMPDHCWLDOC($j,"docValue",code,dimId)) q:dimId=""  d
	..s cValue=$g(^TEMPDHCWLDOC($j,"docValue",code,dimId)) ;$g(^TEMPDHCWL($j,"value",code)) 
	..i cValue = ""  s cValue = 0
	..i flag = 0  d
	...s tempExp= $REPLACE(exp,code,cValue)
	..i flag =1 d
	...s number =  $o(arrays("CmpKpi",cmpAppKpiCode,increa),-1)
	...s preCode = $g(arrays("CmpKpi",cmpAppKpiCode,number))
	...s test = $g(^TEMPDHCWLDIM($j,"codeExp",preCode,dimId))
	...s tempExp= $REPLACE(test,code,cValue)
	..s ^TEMPDHCWLEXP($j,"exp",cmpAppKpiCode,dimId) = tempExp
	..s ^TEMPDHCWLDIM($j,"codeExp",code,dimId) = tempExp
	.s flag=1
	d ##class(DHCWL.DocQueryData.CollectValue).GetExecuteValue()
}

/// d ##class(DHCWL.DocQueryData.GetDocKpiQuery).JudgeIllegal("(500-200)/0")
ClassMethod JudgeIllegal(str As %String)
{
	n (str)
	s illegal = 0
	s length = $l(str)
	f index = 1:1:length  d
	.i $e(str,index) = "/"  d
	..i ($e(str,index+1) = 0)!($e(str,index+1) = "")  s illegal = 1
	q illegal
}

/// Creator：      yw
/// CreatDate：    2015-06-24
/// Description:： 根据配置信息取得指标取数规则和过滤规则
/// Table：        DHCWL_DocQuery.DHCWLDocKpiDef,DHCWL_DocQuery.DHCWLDocKpiRelKpi
/// Input：        userID:用户ID
/// Output：       mDocKpiRelId:医生指标和系统关联表ID,mKPICode:指标代码,mDocKPIDefCode:医生指标代码,mDocKPIDefDesc:医生指标描述
///                mDocKPIDefType:医生指标类型,kpiRule:取数规则,kpiFilter:过滤规则
/// Return：       // "id:%String,kpiRule:%String,kpiFilter:%Text"
/// Others：       d ##class(%ResultSet).RunQuery("DHCWL.DocQueryData.GetDocKpiQuery","GetDocKpiRule","外科一组","科主任")
Query GetDocKpiRule(userCode, DocOrHead) As %Query(ROWSPEC = "AppDocRelId:%String,AppKpiCode:%String,AppKpiDes:%String,AppKpiType:%String,SysKpiCode:%String,SysKpiQueryRule:%String,SysKpiFilterRule:%String,mDocKPIDefCategory:%String") [ SqlProc ]
{
}

ClassMethod GetDocKpiRuleExecute(ByRef qHandle As %Binary, userCode, DocOrHead) As %Status
{
	n (qHandle, userCode,DocOrHead)
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
	s kpiRule=""
	s kpiFilter="" 
	s mDocKPIDr=0 f  s mDocKPIDr=$o(^DHCWL.DocQuery.DocKpiRelKpiI("MDocKPIDr",mDocKPIDr)) q:mDocKPIDr=""  d   //遍历关联表
	.s docClass = $list(^DHCWL.DocQuery.DocKpiDefD(mDocKPIDr),7)
	.i (docClass = DocOrHead)  d
	..s mDocKpiRelId=0 f  s mDocKpiRelId=$o(^DHCWL.DocQuery.DocKpiRelKpiI("MDocKPIDr",mDocKPIDr,mDocKpiRelId)) q:mDocKpiRelId=""  d   //关联表ID
	...s ^TEMPDHCWL($j,mDocKpiRelId)=""    //关联表ID
	s mDocKpiRelId=0 f  s mDocKpiRelId=$o(^TEMPDHCWL($j,mDocKpiRelId)) q:mDocKpiRelId=""  d
	.s kpiRule=""
	.s kpiFilter="" 
	.s docRelObj=##class(DHCWL.DocQuery.DocKpiRelKpi).%OpenId(mDocKpiRelId)   //通过ID返回一个具体的对象
	.;s mKpiObj=docRelObj.MKPIdr       //调用对象的MKPIDR属性取值，指标ID
	.;i $ISObject(mKpiObj) d
	..;s mKPICode=mKpiObj.MKPICode                      //指标代码
	.;e  s mKPICode=""
	.s mKPICode = $list(^DHCWL.DocQuery.DocKpiRelKpiD(mDocKpiRelId),13)
	.s mDocKpiObj=docRelObj.MDocKPIDr					//关联表DR,医生表ID
	.s mDocKPIDefCode=mDocKpiObj.MDocKPIDefCode       //医生指标代码
	.s mDocKPIDefDesc=mDocKpiObj.MDocKPIDefDesc       //医生指标描述
	.s mDocKPIDefType=mDocKpiObj.MDocKPIDefType
	.s mDocKPIDefCategory = mDocKpiObj.MDocKPIDefCategory
	.s mKPIDimCode=docRelObj.MKPIDim                  //指标维度代码
	.s dimPropCode=docRelObj.MDimProp                 //维度属性代码
	.s otherFilterRule=docRelObj.OtherFilterRule      //其它过滤表达
	.i kpiRule="" s kpiRule=mKPICode_":"_mKPIDimCode_"."_dimPropCode    //"DH0002:CTPCP.DocCode"
	.e  s kpiRule=kpiRule_"^"_mKPICode_":"_mKPIDimCode_"."_dimPropCode        //用户过滤表达式 
	.i otherFilterRule="" d
	..;i docKpiType = "" s userFilter1=mKPICode_":({"_mKPIDimCode_"."_dimPropCode_"}="_userCode
	..;e  s userFilter1=mKPICode_":({"_mKPIDimCode_"."_dimPropCode_"}="_userCode_")"    //--_"&&{AdmType}="_mDocKPIDefType
	..s userFilter1=mKPICode_":({"_mKPIDimCode_"."_dimPropCode_"}="_userCode_")"
	.e  d
	.. //K0008:([{CTLOC.LocDesc} \[ 1] && [{CTLOC.LocHospid} \[ 2])
	..;i docKpiType = ""  s userFilter1=mKPICode_":([{"_mKPIDimCode_"."_dimPropCode_"}="_userCode_"]"
	..;e  s userFilter1=mKPICode_":([{"_mKPIDimCode_"."_dimPropCode_"}="_userCode_"]"   //--"DH0002:({CTPCP.DocCode}=0003)"
	..s userFilter1=mKPICode_":([{"_mKPIDimCode_"."_dimPropCode_"}="_userCode_"]"
	.i otherFilterRule="" d
	..s userFilter2=otherFilterRule     //[{PatDep.LocDesc} = 外科二组] 
	.e  d 
	..s userFilter2=otherFilterRule_")"
	.s kpiFilter=userFilter1   //DH0002:({CTPCP.DocCode}=0003)"
    .i userFilter2'="" s kpiFilter=userFilter1_"&&"_userFilter2  //
    .i mKPICode="" s kpiRule="",kpiFilter=""
    .i mKPICode="" s kpiRule=otherFilterRule ;运算指标
    .//i kpiFilter '[")" s kpiFilter=kpiFilter_")"    //KD0003:({Doc.DocName}=0003)
	.d OutputRow1
    Quit $$$OK
            
OutputRow1   
    s data=$lb(mDocKpiRelId,mDocKPIDefCode,mDocKPIDefDesc,mDocKPIDefType,mKPICode,kpiRule,kpiFilter,mDocKPIDefCategory)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetDocKpiRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocKpiRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDocKpiRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocKpiRuleExecute ]
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

/// Creator：      yw
/// CreatDate：    2015-06-30
/// Description:： 按指定格式返回数据
/// Table：        DHCWL_DocQuery.DHCWLDocKpiDef,DHCWL_DocQuery.DHCWLDocKpiRelKpi
/// Input：        
/// Output：       resolved:配置内容
///               
/// Return：       
/// Others：       d ##class(DHCWL.DocQueryData.GetDocKpiQuery).GetDocKpiCFG("外科一组","","科主任")
/// Others：       d ##class(DHCWL.DocQueryData.GetDocKpiQuery).GetDocKpiCFG("0003","I","医生",.data)
ClassMethod GetDocKpiCFG(userCode, DocOrHead, ByRef configMap)
{
	n (userCode,configMap,DocOrHead)
	s configMap("list")="[]"
    //s docKpiType=""
	set rs=##class(%ResultSet).%New("DHCWL.DocQueryData.GetDirectorKpiQuery:GetDocKpiRule")   
	set sc=rs.Execute(userCode,DocOrHead)
	s num=0
	While rs.Next(.sc) { 
	    s num=num+1
	    s appKpiCode=$g(rs.Data("AppKpiCode"))   //DOC003
	    s appKpiDes=$g(rs.Data("AppKpiDes"))   //药占比
	    s appKpiType=$g(rs.Data("AppKpiType"))  //"I"
	    s appKpiCategory=$g(rs.Data("mDocKPIDefCategory"))
	    s sysKpiCode=$g(rs.Data("SysKpiCode")) // ""
	    s sysKpiQueryRule=$g(rs.Data("SysKpiQueryRule"))  // "DOC001/DOC002"
	    s sysKpiFilterRule=$g(rs.Data("SysKpiFilterRule"))  //")"
	    s configMap("list",appKpiCode) = appKpiCode_"^"_appKpiDes_"^"_appKpiType_"^"_sysKpiCode_"^"_sysKpiQueryRule_"^"_sysKpiFilterRule_"^"_appKpiCategory
    	;w $g(configMap("list",appKpiCode)),!
    }
    q
}

/// Others：       d ##class(DHCWL.DocQueryData.GetDirectorKpiQuery).GetExecuteValue()
ClassMethod GetExecuteValue()
{
	s cpCode = ""  f  s cpCode = $o(^TEMPDHCWLEXP($j,"exp",cpCode)) q:cpCode=""  d
	.s cpId = ""  f  s cpId = $o(^TEMPDHCWLEXP($j,"exp",cpCode,cpId)) q:cpId=""  d
	..;I cpCode = "HEAD006" w cpCode_","_cpId,!
	..s exp = $g(^TEMPDHCWLEXP($j,"exp",cpCode,cpId))
	..q:exp=""
	..s tempKpiValue=0
	..s ^TEMPDHCWLDIR("SUMVALUE",$j,cpCode,cpId)=$g(tempKpiValue)
	..s exeStr="s tempKpiValue="_exp
	..x exeStr
	..s ^TEMPDHCWLDIR("SUMVALUE",$j,cpCode,cpId)=$g(tempKpiValue)
}

}
