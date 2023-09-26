Class DHCWL.DM.Util.FunctionCall Extends %RegisteredObject
{

Property FunctionConfig As DHCWL.DM.T.FunctionConfig;

Property FunctionInstance As DHCWL.DM.Function.FunctionInterface;

Property PassedParams As %List;

Property ParasNum As %Integer;

Property IsRoutine As %Boolean;

Property RoutineCall As %String;

Property DynamicParaConfig As %List;

Property DynamicParaLen As %Integer;

// d ##class(DHCWL.DM.Util.FunctionCall).Test()

ClassMethod Test()
{
	s funCall=##class(FunctionCall).%New("filter:daterange",$lb("2017-04-07","2017-04-10"))
	s list=funCall.Call()
	w $lts(list)
}

ClassMethod Test1()
{
	s funCall=##class(FunctionCall).%New("filter:startWith",$lb("Aa"))
	s ts=$p($h,",",2)
	s params=$lb()
	s v= funCall.Call($lb("aAab"))
	w "v="_v
}

// d ##class(DHCWL.DM.Util.FunctionCall).Test2()

ClassMethod Test2()
{
	S obj=##CLASS(DHCWL.DM.Function.Filter.StartWith).%New($LIST($LB("Aa"),1))
	s ts=$p($h,",",2)
	s params=$lb()
	f i=1:1:9999999 d
	.s $list(params,1)="Aadf"
	.d obj.Eval(params)
	w "Spend time:"_($p($h,",",2)-ts)_"s"
}

// d ##class(DHCWL.DM.Util.FunctionCall).Test3()

ClassMethod Test3(code = "")
{
	s funCall=##class(FunctionCall).%New("DYCDIMPRO:Test",$lb(code))
	s v=funCall.Call($lb("2017-04-07"))
	w "v="_v
}

// d ##class(DHCWL.DM.Util.FunctionCall).Test4()

ClassMethod Test4(code = "")
{
	s funCall=##class(FunctionCall).%New("STICDIMPRO:Test2",$lb(code))
	s v=funCall.Call()
	w "v="_v
}

Method %OnNew(funName As %String, params As %List = "") As %Status [ Private, ServerOnly = 1 ]
{
	s ..FunctionConfig=##class(DHCWL.DM.T.FunctionConfig).GetByPath(funName)
	q:..FunctionConfig="" $$$ERROR("Can't get function:"_funName)
	s:params="" params=$lb()
	s len=$ll(params)
	s defParams=..FunctionConfig.Parameters()
	;q:len>defParams.Count() $$$ERROR("Passed parameters is "_len_" but "_funName_" defined paremeters is "+defParams.Count())
	s len2=defParams.Count()
	s dynPara=$lb(),dynParaCount=0
	f i=1:1:len2 {
	  s para=defParams.GetAt(i)
	  s paraType=para.ParamType.GetPath()
	  i paraType="PARAM:CONSTANTINITPASS"{
	  	s pv=$lg(params,i,"")
	  	s:pv="" pv=para.DefaultValue
	  	s $list(params,i)=pv
	  }else{
		s dynParaCount=dynParaCount+1
		s $list(dynPara,dynParaCount)=i
	  }
	}
	s ..DynamicParaConfig=dynPara
	s ..DynamicParaLen=dynParaCount
	s ..PassedParams=params
	/*s len=$ll(params),cparams=""
	f i=1:1:len d
	.q:$lg(params,i,"")=""
	.s:i>1 cparams=cparams_","
	.s cparams=cparams_"$list(..PassedParams,"_i_")"
	*/
	s funType=..FunctionConfig.SubType
	i ((funType="MR")||(funType="MO")) {
	  s ..RoutineCall=..FunctionConfig.CallExpression
	  s ..IsRoutine=1
	}else{
	  ;s exeStr="s ..FunctionInstance="_..FunctionConfig.InitCallExpression_"("_$g(cparams,"")_")"
	  s exeStr="s ..FunctionInstance="_..FunctionConfig.InitCallExpression_"(..PassedParams)"
	  x exeStr
	  d ..FunctionInstance.BeforeWork()
	  s ..IsRoutine=0
	}
	q $$$OK
}

Method Call(runtimeParams As %List = "") As %DataType
{
  i ..IsRoutine=1 {
	s v=""
	s para=..PassedParams
	i ..DynamicParaLen>0{
	  f i=1:1:..DynamicParaLen{
		s di=$lg(..DynamicParaConfig,i)
		s $list(para,di)=$lg(runtimeParams,di,"")
	  }
	}
    x ( "(in,out) {s out="_..RoutineCall_"(in)}",para,.v)
    q v
  }
  q ..FunctionInstance.Eval(runtimeParams)
}

Method GetFunction() As DHCWL.DM.Function.FunctionInterface [ CodeMode = expression ]
{
..FunctionInstance
}

Method Close()
{
	i ..IsRoutine=1 {
	}else{
	  d:..FunctionInstance'="" ..FunctionInstance.AfterWork()
	  s ..FunctionInstance=""
	}
}

}
