Class DHCWL.DocQueryData.GetDocKpiDetail Extends %RegisteredObject [ Not ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("DHCWL.DocQueryData.GetDocKpiDetail","GetGrpValue","AspectTest","0003","2013-06-01","2013-09-01")

//d ##class(%ResultSet).RunQuery("DHCWL.DocQueryData.GetDocKpiDetail","GetGrpValue","DOC001","0003","2013-06-01","2013-09-01")

Query GetGrpValue(docCode As %String, userCode As %String, startDate As %String, endDate As %String) As %Query(ROWSPEC = "dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod GetGrpValueExecute(ByRef qHandle As %Binary, docCode As %String, userCode As %String, startDate As %String, endDate As %String) As %Status
{
	n (qHandle,docCode ,userCode ,startDate,endDate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
    s mDocKPIDr = $o(^DHCWL.DocQuery.DocKpiDefI("MDocKPIDefCode",$zcvt(docCode,"u"),"")) //医生指标id
    s mDocKpiRelId = $o(^DHCWL.DocQuery.DocKpiRelKpiI("MDocKPIDr",mDocKPIDr,"")) //关联表id
    s filterCon = $list(^DHCWL.DocQuery.DocKpiRelKpiD(mDocKpiRelId),5)  //过滤规则
    s sysKpiCode = $list(^DHCWL.DocQuery.DocKpiRelKpiD(mDocKpiRelId),13)  //系统指标code 
    s sysId =$o(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(sysKpiCode,"u"),""))  //获取系统指标id
	s kpiRule=""
	s kpiFilter="" 
	s docRelObj=##class(DHCWL.DocQuery.DocKpiRelKpi).%OpenId(mDocKpiRelId)   //通过ID返回一个具体的对象
	s mKPICode = $list(^DHCWL.DocQuery.DocKpiRelKpiD(mDocKpiRelId),13)
	s mDocKpiObj=docRelObj.MDocKPIDr					//关联表DR,医生表ID
	s mDocKPIDefCode=mDocKpiObj.MDocKPIDefCode       //医生指标代码
	s mDocKPIDefDesc=mDocKpiObj.MDocKPIDefDesc       //医生指标描述
	s mDocKPIDefType=mDocKpiObj.MDocKPIDefType
	s mKPIDimCode=docRelObj.MKPIDim                  //指标维度代码
	s dimPropCode=docRelObj.MDimProp                 //维度属性代码
	s otherFilterRule=docRelObj.OtherFilterRule      //其它过滤表达
	i kpiRule="" d 
	.s kpiRule=mKPICode_":"_mKPIDimCode_"."_dimPropCode    //"DH0002:CTPCP.DocCode"
	e  s kpiRule=kpiRule_"^"_mKPICode_":"_mKPIDimCode_"."_dimPropCode        //用户过滤表达式 
	i otherFilterRule="" d
	.s userFilter1=mKPICode_":({"_mKPIDimCode_"."_dimPropCode_"}="_userCode_")"
	e  d
	.s userFilter1=mKPICode_":([{"_mKPIDimCode_"."_dimPropCode_"}="_userCode_"]"
	i otherFilterRule="" d
	.s userFilter2=otherFilterRule     //[{PatDep.LocDesc} = 外科二组] 
	e  d 
	.s userFilter2=otherFilterRule_")"
	s kpiFilter=userFilter1   //DH0002:({CTPCP.DocCode}=0003)"
    i userFilter2'="" s kpiFilter=userFilter1_"&&"_userFilter2  //
    i mKPICode="" s kpiRule="",kpiFilter=""
    i mKPICode="" s kpiRule=otherFilterRule ;运算指标
    s order = ##class(DHCWL.DocQueryData.GetDocKpiDetail).GetDimOrder(sysId,filterCon)
    set rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	set sc=rs.Execute(sysKpiCode,startDate,endDate,,,kpiFilter)
    While rs.Next(.sc) { 
    s dimId = $g(rs.Data("dimId"))
    s dimDesc = $p($g(rs.Data("dimDesc")),",",order)
    ;s dimDesc = $g(rs.Data("dimDesc"))
	s value=$g(rs.Data("value"))
	d outputRow1	
	}
    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow1
 s row=$listbuild(dimDesc,value)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetGrpValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGrpValueExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGrpValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGrpValueExecute ]
{
	n (qHandle,Row,AtEnd)
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

//d ##class(DHCWL.DocQueryData.GetDocKpiDetail).GetDimOrder("1210","[{TarEc.TARECDesc} \[ 西药费,中成药费,中草药费] && [{PaType.Name} = 住院]")

//d ##class(DHCWL.DocQueryData.GetDocKpiDetail).GetDimOrder("1214","[{TarEc.TARECDesc} \[ 西药费,中成药费,中草药费]")

//获取对应指标的纬度节点顺序

ClassMethod GetDimOrder(sysId, filterCon) As %String
{
	n (sysId,filterCon)
	d ##class(DHCWL.DocQueryData.GetDocKpiDetail).ResovleFilterRule(filterCon)
	s num = 0 f  s num = $o(^TEMPDHCWL($j,"filter",num)) q:num=""  d
    .s wdCode = $p($g(^TEMPDHCWL($j,"filter",num)),".",1)
    .s ^TEMPDHCWL($j,"wd",wdCode)=""
	s sql = "SELECT MKPIDim_Code, MKPIDim_DimDr,MKPIDim_Order FROM DHCWL_MKPI.DHCWLMKPIDim WHERE MKPI_Dr="_sysId
 	s rs = ##class(%ResultSet).%New()
 	s sc = rs.Prepare(sql)
 	s sc = rs.Execute()
 	while rs.Next() {
	 s dimdimDr = rs.Data("MKPIDim_DimDr") 
     s dimCode = $list(^DHCWL.MKPI.MKPIDimTypeD(dimdimDr),2)
     s dimOrder = rs.Data("MKPIDim_Order")
	 i (dimCode="TarEC")!(dimCode="TARSC")!(dimCode="TARAC")!(dimCode="TARIC")!(dimCode="TARMC")!(dimCode="TAROC")!(dimCode="TARSC")!(dimCode="TAREC")   d //需要标准的纬度code这里做过滤
	 .s dimdimCode = rs.Data("MKPIDim_Code")   //纬度的code和对应的纬度ID找到，然后去找顾虑条件，如果有匹配到的则成功
	 .i $d(^TEMPDHCWL($j,"wd",dimdimCode))   d //匹配一种(核算分类，会计分类等)
	 ..s mDimOrd = dimOrder
	 }
	 q $g(mDimOrd)
}

/// w ##class(DHCWL.DocQueryData.GetDocKpiDetails).ResovleFilterRule("[{TarEc.TARECDesc} \[ 西药费,中成药费,中草药费] && [{PaType.Name} =住院]")
ClassMethod ResovleFilterRule(filterStr As %Text) As %AbstractArray
{
	n (filterStr)
	s dimArray=##class(%ArrayOfDataTypes).%New()
	q:filterStr="" dimArray
	s logAnd="&&",logOr="||",ProS="{",ProE="}",indNum=1
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr)
	s len=$l(filterStr,logAnd)
	f i=1:1:len {
		s dataStr=$P(filterStr,logAnd,i)
		i (dataStr [ logOr){
			f j=1:1:$l(dataStr,logOr) {
				s expStr=$P(dataStr,logOr,j)
				continue:((expStr '[ ProS)||(expStr '[ ProE))
				s dimProStr=..ResovleFilterData(expStr)
				s ^TEMPDHCWL($j,"filter",indNum) = dimProStr
				s indNum=indNum+1
			}
		}else{
			continue:((dataStr '[ ProS)||(dataStr '[ ProE))
			s dimProStr=..ResovleFilterData(dataStr)
			s ^TEMPDHCWL($j,"filter",indNum) = dimProStr
			s indNum=indNum+1
		}
	}
}

/// w ##class(DHCWL.DocQueryData.GetDocKpiDetails).ResovleFilterData("[{TarEc.TARECDesc} \[ 西药费,中成药费,中草药费]")
ClassMethod ResovleFilterData(filterStr As %Text) As %String
{
	n (filterStr)

	q:filterStr="" ""
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"[")
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"]")
	s filterStr=##class(DHCWL.util.StringUtil).EscapeStr(filterStr,"[","\")
	s filterStr2=$zcvt(filterStr,"U")
	s choiceFilter="",ind=0,best=0,bestFilter=""
	f {
		s choiceFilter=$o(^DHCWL.MKPI.SysFilterFuncI("Code",choiceFilter))
		q:choiceFilter=""
		s choiceFilter2=##class(DHCWL.util.StringUtil).Trim(choiceFilter)
		if (($l(choiceFilter2)>best)&&($f(filterStr2,choiceFilter2)>0)){
			s best=$l(choiceFilter2),bestFilter=choiceFilter2
			s ind=$f(filterStr2,choiceFilter2)
		}
	}
	q:ind=0 dimArray
	s choiceFilter=bestFilter
	s dimPro=$e(filterStr,1,(ind-$l(choiceFilter)-1))
	;s splitChoice = $p(filterStr,choiceFilter,2)
	;s splitValue=##class(DHCWL.util.StringUtil).Trim(splitChoice)
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro)
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"{")
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"}")
	q dimPro
}

}
