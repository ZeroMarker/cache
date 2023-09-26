Class DHCWL.DM.T.CubeMetrics Extends %Persistent
{

Property CubeBase As CubeBase [ Required ];

Property MetricPro As ThemeMetrics [ Required ];

Property SerialNumber As %Integer;

Index MainI On (CubeBase, MetricPro);

Trigger AftInsertTri [ Event = INSERT, Time = AFTER ]
{
	n id,sn,cubeId
	s id={%%ID}
	i id'="" d
	.s cubeId={CubeBase}
	.s sn=..ComputeSN(cubeId)
	.&sql(update DHCWL_DM_T.CubeMetrics set SerialNumber=:sn where ID=:id)
	.;d ##class(CubeDStructMap).AddDim(cubeId,id)
}

Trigger AftDeleteTri [ Event = DELETE, Time = AFTER ]
{
	n id,cubeId
	s id={%%ID}
	i id'="" d
	.s cubeId={CubeBase}
	.;d ##class(CubeDStructMap).DeleteDim(cubeId,id)
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    s ..SerialNumber=..ComputeSN(..CubeBase.%Id())
    ;d ##class(CubeDStructMap).AddDim(..CubeBase.%Id(),..%Id())
    q $$$OK
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
    ;s obj=##class(CubeDims).%Open(oid)
    ;q ##class(CubeDStructMap).DeleteDim(obj.CubeBase.%Id(),obj.%Id())
    q $$$OK
}

ClassMethod ComputeSN(cubeId) As %Integer
{
	q:'$d( ^DHCWL.DM.T.CubeMetricsI("MainI",cubeId) ) 1
	s max=0
	s dp="" f  s dp=$o( ^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,dp) ) q:dp=""  d
	.s id=$o( ^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,dp,"") )
	.s sn=+$lg(^DHCWL.DM.T.CubeMetricsD(id),4,0)
	.i sn>max s max=sn
	q max+1
}

ClassMethod Get(cubeId, themeMetricId) As CubeMetrics
{
	s obj=""
	i ( ($d(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId))) && ($d(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,themeMetricId))) ) d
	.s id=$o(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,themeMetricId,""))
	.s obj=##class(CubeMetrics).%OpenId(id)
	q obj
}

ClassMethod GetMetrics(cubeId) As %ListOfObjects
{
	s obj=""
	s list=##class(%ListOfObjects).%New()
	s metricId="" f  s metricId=$o(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,metricId)) q:metricId=""  d
	.s id=$o(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,metricId,""))
	.s obj=##class(CubeMetrics).%OpenId(id)
	.q:obj=""
	.d list.Insert(obj)
	q list
}

ClassMethod Add(ci, themeDimId)
{
	i ( ($d(^DHCWL.DM.T.CubeMetricsI("MainI",ci))) && ($d(^DHCWL.DM.T.CubeMetricsI("MainI",ci,themeDimId))) ) q $$$OK
	&sql(INSERT INTO DHCWL_DM_T.CubeMetrics(CubeBase,MetricPro)values(:ci,:themeDimId))
	i SQLCODE=0 q $$$OK
	q $$$ERROR("SQLCODE="_SQLCODE)
}

// w ##class(DHCWL.DM.T.CubeMetrics).GetFetchSelect(1)

ClassMethod GetFetchSelect(cubeId) As %String
{
	q:'$d(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId)) ""
	s sql="",num=0
	s re="" f  s re=$o(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,re)) q:re=""  d
	.s id=$o(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,re,""))
	.q:'$d(^DHCWL.DM.T.CubeMetricsD(id))
	.s cmobj=##class(CubeMetrics).%OpenId(id)
	.q:cmobj.MetricPro=""
	.s num=num+1
	.s:num>1 sql=sql_","
	.s sql=sql_cmobj.MetricPro.Code ;_" AS AGG"_cmobj.SerialNumber
	q sql
}

// w ##class(DHCWL.DM.T.CubeMetrics).ResolveExpression("c_a(a_1,b_2)-s(p_b+c('abc',1))")

// w ##class(DHCWL.DM.T.CubeMetrics).ResolveExpression("sum(Price)")

ClassMethod ResolveExpression(expression, ByRef funMapConfig = "") As %String
{
	d ..RecusiveResolveExpression(expression,.resolvedExp,.funMapConfig)
	q $g(resolvedExp,expression)
}

ClassMethod RecusiveResolveExpression2(expression, ByRef resolvedExp As %String, ByRef funMap = "") [ Private ]
{
	s expression=##class(DHCWL.DM.Util.StringUtil).Trim(expression)
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s posStack=##class(DHCWL.DM.Util.Stack).%New()
	s PS="(",PE=")",PSL=","
	s len=$l(expression),curChar="",preChar=""
	f i=1:1:len {
	  
	}
}

ClassMethod RecusiveResolveExpression(expression, ByRef resolvedExp As %String, ByRef funMap = "") [ Private ]
{
	s expression=##class(DHCWL.DM.Util.StringUtil).Trim(expression)
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s posStack=##class(DHCWL.DM.Util.Stack).%New()
	s PS="(",PE=")",PSL=","
	s FSP=1
	s len=$l(expression),curChar="",preChar=""
	s SLS="'",SLE="'"
	s funName=""
	f i=1:1:len {
	  s preChar=curChar
	  s curChar=$e(expression,i)
	  if ( (curChar=PS) && (stack.Peek()'=SLS) ){
			d stack.Push(curChar)
			d posStack.Push(i)
			s j=i
		  	s expe=0
		  	while (j>0 ){
			  	s j=j-1
			  	s cc=$e(expression,j)
			  	i (cc'="_") &&( ($ascii(cc)<=47) || ( ($ascii(cc)>=58) && ($ascii(cc)<=64) ) || ( ($ascii(cc)>=91) && ($ascii(cc)<=96) ) || ( ($ascii(cc)>=123) && ($ascii(cc)<=127) ) ){
				   s expe=j+1
				   s j=-1
			  	}
		  	}
		  	s j=expe
		  	s j2=expe
		  	while(j>0){
			  	s j=j-1
			  	s cc=$e(expression,j)
			    if (cc=" ")||(cc="_")||($ascii(cc)=9)||($ascii(cc)=10)||($ascii(cc)=11)||($ascii(cc)=12)||($ascii(cc)=13){
				 
			    }else{
				    s j2=j
				    s j=-1
			    }
		  	}
		  	s cc=$e(expression,j2)
			s funName=$e(expression,expe,i-1)
		  	if (cc="+")||(cc="-")||(cc="*")||(cc="/") s funName=cc_funName
			s sd=stack.Size()
			s j=i
			while (j<len){
				s j=j+1
				s cc=$e(expression,j)
				if ( (cc=PS) && (stack.Peek()'=SLS) ){
					d stack.Push(cc)
				}elseif ( (cc=PE) && (stack.Peek()'=SLS) && (stack.Peek()=PS) ){
					d stack.Pop()
					if (stack.Size()=sd || stack.Size()=0){
						s para=$e(expression,i+1,j-1)
						;w funName_":"_para,!
						k paramMapConfig
						d ..RecusiveResolveParam(para,.para2,.paramMapConfig)
						s funName=##class(DHCWL.DM.Util.StringUtil).Trim(funName)
						s funMap(funName)=""
						m funMap(funName,"P")=paramMapConfig
						s funName=$zcvt(funName,"U")
						s resolvedExp=$g(resolvedExp,"")_funName_":"_$g(para2,"")
						s i=j-1
						s j=len+1
					}
				}
			}
	  }elseif ( (curChar=PE) && (stack.Peek()'=SLS) && (stack.Peek()=PS)){
			d stack.Pop()
	  }elseif ( (curChar=SLS) && (stack.Peek()'=SLS)) {
		  d stack.Push(curChar)
	  }elseif ( (curChar=SLE) && (stack.Peek()=SLS)) {
		  d stack.Pop()
	  }
	}
}

ClassMethod RecusiveResolveParam(param, ByRef resolvedPara As %String, ByRef paramMap)
{
	q:param=""
	s param=param_" "
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s len=$l(param)
	s curChar="",preChar=""
	s SLS="'",SLE="'",PSL=",",FSP="(",FEP=")"
	s PSP=1,PEP=0
	f i=1:1:len {
		s preChar=curChar
	  	s curChar=$e(param,i)
	  	if ( (curChar=SLS) && (stack.Peek()'=SLS)){
		  	s PSP=i
		  	d stack.Push(curChar)
	  	}elseif ( (curChar=SLE) && (stack.Peek()=SLS)){
		  	d stack.Pop()
		  	s par=$e(param,PSP,i)
		  	s PSP=i+1
		  	s PEP=i
		  	s par=##class(DHCWL.DM.Util.StringUtil).Trim(par)
		  	if par'="" s resolvedPara=$g(resolvedPara,"")_par
		  	s pi=$i(paramMap)
		  	s paramMap(pi)=par
		  	;w "param:"_par,!
	  	}elseif(stack.Peek()'=SLS){
		  	if (curChar'="_") && ( ($ascii(curChar)<=47) || ( ($ascii(curChar)>=58) && ($ascii(curChar)<=64) ) || ( ($ascii(curChar)>=91) && ($ascii(curChar)<=96) ) || ( ($ascii(curChar)>=123) && ($ascii(curChar)<=127) ) ){
			  	s j=i
			  	s parans=0
			  	while(j>0){
				  	s j=j-1
				  	s cc=$e(param,j)
				  	i (cc'="_") && ( ($ascii(cc)<=47) || ( ($ascii(cc)>=58) && ($ascii(cc)<=64) ) || ( ($ascii(cc)>=91) && ($ascii(cc)<=96) ) || ( ($ascii(cc)>=123) && ($ascii(cc)<=127) ) ){
					  	s par=$e(param,j+1,i-1)
					  	s parans=j+1
					  	s j=-1
				  	}
			  	}
			  	if (parans>0){
				  	s j=i-1
				  	s j2=j
				  	while (j<len){
					  	s j=j+1
					  	s cc=$e(param,j)
					  	if (cc="_") || (cc=" ")||($ascii(cc)=9)||($ascii(cc)=10)||($ascii(cc)=11)||($ascii(cc)=12)||($ascii(cc)=13){
					  	}else{
						  	s j2=j
						  	s j=len+1
					  	}
				  	}
				  	s flag=0
				  	s j=j2
				  	if ($e(param,j)=FSP){
					  	s st=##class(DHCWL.DM.Util.Stack).%New()
					  	s j=j-1
					  	while (j<len ){
						  	s j=j+1
						  	s cc=$e(param,j)
						  	i ( (cc=FSP) && (st.Peek()'=SLS)){
							   d st.Push(cc) 	
						  	}elseif ( (cc=SLS) && ( st.Peek()'=SLS)){
							   d st.Push(cc) 	
						  	}elseif ( (cc=SLE) && ( st.Peek()=SLS)){
							   d st.Pop()	
						  	}elseif ( (cc=FEP) && (st.Peek()'=SLS) && (st.Peek()=FSP) ){
							  	d st.Pop()
							  	if (st.Size()=0){
								  	s j1=parans
								  	s j3=j1
								  	while(j1>0){
									  	s j1=j1-1
									  	s cc2=$e(param,j1)
									    if (cc2=" ")||($ascii(cc2)=9)||($ascii(cc2)=10)||($ascii(cc2)=11)||($ascii(cc2)=12)||($ascii(cc2)=13){
				 
									    }else{
										    s j3=j1
										    s j1=-1
									    }
								  	}
								  	s paraFexp=$e(param,parans,j)
								  	s cc2=$e(param,j3)
		  							if (cc2="+")||(cc2="-")||(cc2="*")||(cc2="/") s paraFexp=cc2_paraFexp
		  							
								  	d ..RecusiveResolveExpression(paraFexp,.resolvExp)
								  	s resolvedPara=$g(resolvedPara,"")_resolvExp
								  	s i=j
								  	s flag=1
							  		s j=len+1
							  	}
						  	}
					  	}
				  	}
				  	if flag=0 {
					  	if par'="" {
					  		;w "param:"_par,!
					  		s par=##class(DHCWL.DM.Util.StringUtil).Trim(par)
					  		if par'="" s resolvedPara=$g(resolvedPara,"")_par
						  	;s i=parans
						  	s pi=$i(paramMap)
		  	                s paramMap(pi)=par
					  	}
				  	}
			  	}
			  	
		  	}else{
			  	s PEP=i
		  	}
	  	}
	}
}

ClassMethod GetSelectColName(cubeId, metricId = "") As %List
{
	if (metricId'=""){
	  s metric=##class(CubeMetrics).%OpenId(metricId)
	  q:metric="" $lb()
	  s dt=8
	  if metric.MetricPro.DataType'="" s dt=metric.MetricPro.DataType.JDBCTypeCodeNum
	  s list= $lb(metric.MetricPro.Code,metric.SerialNumber,metricId,dt)	
	  s metric=""
	  q list
	}
	s list=$lb(),i=0
	q:'$d(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId)) list
	s exp="" f  s exp=$o(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,exp)) q:exp=""  d
	.s id=$o( ^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,exp,"") )
	.q:'$d(^DHCWL.DM.T.CubeMetricsD(id))
	.s i=i+1
	.s obj=##class(CubeMetrics).%OpenId(id)
	.s $list(list,i)=obj.MetricPro.Code
	.s i=i+1
	.s $list(list,i)=obj.SerialNumber
	.s i=i+1
	.s $list(list,i)=id
	.s i=i+1
	.s dt=8
	.i obj.MetricPro.DataType'="" d
	..s dt=obj.MetricPro.DataType.JDBCTypeCodeNum
	.s $list(list,i)=dt
	.s obj=""
	q list
}

ClassMethod GetMaxSN(cubeId) As %Integer
{
	s maxSN=0
	s proId="" f  s proId=$o(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,proId)) q:proId=""  d
	.s id=$o( ^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,proId,"") )
	.q:'$d(^DHCWL.DM.T.CubeMetricsD(id))
	.s sn=$lg(^DHCWL.DM.T.CubeMetricsD(id),4)
	.i maxSN<sn d
	..s maxSN=sn
	q maxSN
}

ClassMethod ToString(cubeId) As %String
{
	q:'$d(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId)) "[]"
	s str="",num=0
	s re="" f  s re=$o(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,re)) q:re=""  d
	.s id=$o(^DHCWL.DM.T.CubeMetricsI("MainI",cubeId,re,""))
	.q:'$d(^DHCWL.DM.T.CubeMetricsD(id))
	.s cmobj=##class(CubeMetrics).%OpenId(id)
	.q:cmobj.MetricPro=""
	.s num=num+1
	.s:num>1 str=str_","
	.s str=str_"{""code"":"""_cmobj.MetricPro.Code_""",""sn"":"_cmobj.SerialNumber_"}" ;_" AS AGG"_cmobj.SerialNumber
	q "["_str_"]"
}

Storage Default
{
<Data name="CubeMetricsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CubeBase</Value>
</Value>
<Value name="3">
<Value>MetricPro</Value>
</Value>
<Value name="4">
<Value>SerialNumber</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.CubeMetricsD</DataLocation>
<DefaultData>CubeMetricsDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.CubeMetricsD</IdLocation>
<IndexLocation>^DHCWL.DM.T.CubeMetricsI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.CubeMetricsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
