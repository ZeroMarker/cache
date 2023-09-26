/// <H3>监控中心自动业务处理表达式处理函数库</H3>
/// <H4>创建者:李阳</H4>
Class DHCMed.CCService.AutoProcess.ExpEvaluation Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// <H3>功能：将监控表达式中高级用户可以阅读的类库名称转换成真正的类名</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>LibMethod</B>：调用类库的表达式，如#Package1.FunctionName([值1])</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 转换完成的表达式
ClassMethod TranslateToClassMethod(LibMethod)
{
	n (LibMethod)
	;q:LibMethod'["(" $lb("Error","调用类库方法有误，没有找到[(].",LibMethod) //不包含"("，显然有语法错误
	s tmp=$p(LibMethod,"(",1)
	;q:tmp'["." $lb("Error","只写了类库名没有写明函数名.",LibMethod) //不包含"."，类库描写不完整
	s tmp=$extract(tmp,2,$l(tmp))
	s LibName=""
	f i=1:1:($l(tmp,".")-1)  d
	.s:LibName'="" LibName=LibName_"."
	.s LibName=LibName_$p(tmp,".",i)
	s LibName=$$ALPHAUP^SSUTIL4(LibName)
	s MethodName=$p(tmp,".",$l(tmp,"."))
	q:(LibName="") $lb("Error","类库名为空.",LibName)
	q:(MethodName="") $lb("Error","函数名为空.",MethodName)
	s objPackage=##class(DHCMed.CC.MethodPackage).GetPackageByName(LibName)
	q:objPackage="" $lb("Error","没有登记该类库包,请检查.",LibName)
	s MethodName=$$ALPHAUP^SSUTIL4(MethodName)
	s objMethod=##class(DHCMed.CC.MethodInfo).GetMethodInfoByName(objPackage.%Id(),MethodName)
	s ret=""
	i objMethod=""  d
	.s ret=$lb("Error","没有登记该类库函数,请检查.",MethodName)
	.s objPackage=""
	.k objPackage
	q:ret'="" ret
	
	s ret=$lb("OK",$$GetMethodName(objMethod.ClassMethod),objMethod.DefaultReturnValue)
	s objMethod=""
	k objMethod
	s objPackage=""
	k objPackage
	q ret
	
GetMethodName(MethodName)
	n (MethodName)
	s classNameLen=..Instr(MethodName,").",1)
	s className=$extract(MethodName,1,classNameLen)
	;w "ClassName:"_className,!
	s MethodNameLen=..Instr(MethodName,"(",classNameLen)
	s methodName=$extract(MethodName,classNameLen+2,MethodNameLen-1)
	;w "MethodName:"_methodName,!
	q className_"."_methodName
}

/// <H3>功能：替换表达式中的逻辑关系表达式，将其转化为Cache的语句</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>exp</B>：需要转化的表达式</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 转换完成的表达式
ClassMethod ReplaceLogicalSymbol(exp)
{
	n (exp)
	s exp=..ReplaceString(exp,".and.","&&")
	s exp=..ReplaceString(exp,".or.","!")
	s exp=..ReplaceString(exp,".not","'")
	q exp
}

/// <H3>功能：替换表达式中的逻辑关系表达式，将其转化为Cache的语句</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>exp</B>：需要转化的表达式</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 转换完成的表达式
ClassMethod EvaExpression(exp)
{
		n (exp)
		s subExp=""
		s cnt=0
		s flag=0
		s flagEnd=0
		s testExp=""
		s retExp=""
		s arryErr=$lb("")
		s errCnt=0
		
		f i=1:1:$l(exp)  d
		.s char=$extract(exp,i,i)
		.s:char=$c(34) cnt=cnt+1
		.i ((char="#")&&(cnt-(cnt\2*2)=0))  d
		..s flag=1
		.i flag=1  d
		..s subExp=subExp_char
		.e  d
		..;s testExp=testExp_char //生成测试表达式
		..s retExp=retExp_char //生成最终表达式
		.i ((flag=1)&&(char="(")&&(cnt-(cnt\2*2)=0))  d  //获取从#到(中间的类库、方法名
		..s flag=0
		..s MethodSign=$p(subExp,"(",1)
		..;w:MethodSign'="" "调用函数："_MethodSign,!
		..s result=..TranslateToClassMethod(subExp)
		..i $li(result,1)="OK"  d
		...;w "类库调用的真实函数是："_$li(result,2),!
		...s classMethod=$li(result,2)
		...s tmp=""
		...s testExp=testExp_1
		...;f j=1:1:($l(classMethod,"(")-1)  d
		....;s:tmp'="" tmp=tmp_"("
		....;s tmp=tmp_$p(classMethod,"(",j)
		...;s subExp=..ReplaceString(subExp,$p(subExp,"(",1),tmp)
		...;w "最后生成的表达式为："_subExp,!
		...;s %ExtraData=$lb()
		...;s runResult=##class(DHCMed.CCService.System.MethodRunner).RunExpression(subExp)
		...;w "运行结果："_$li(runResult,1),!
		...;w "详细结果："_$li(runResult,2),!
		...;s testExp=testExp_1 ;$li(runResult,2)
		...s retExp=retExp_classMethod_"("
		..e  d
		...;w "出现了错误："_$li(result,2)_"  详细信息："_$li(result,3),!
		...s errCnt=errCnt+1
		...s $li(arryErr,errCnt)="表达式："_subExp_"出现了错误："_$li(result,2)_"  详细信息："_$li(result,3)
		..s subExp="" //一个解析过程结束，清空变量继续解析表达式
		;w "测试表达式："_testExp,!
		;s data=..TestExp(testExp)
		
		//获取最终结果
		s testExp=..ReplaceLogicalSymbol(testExp)
		s retExp=..ReplaceLogicalSymbol(retExp)
		s runResult=##class(DHCMed.CCService.System.MethodRunner).RunExpression(testExp)
		i $li(runResult,1)="Error"  d
		.s errCnt=errCnt+1
		.s $li(arryErr,errCnt)=exp_"    存在语法错误！"
		
		i errCnt=0  d
		.s retData=$lb("OK",retExp)
		e  d
		.s retData=$lb("Error")
		.f j=1:1:errCnt  d
		..s $li(retData,1+j)=$li(arryErr,j)
		
		q retData
}

ClassMethod TestExp(exp)
{
		n (exp)
		SET $ZTRAP="ERR"
		s exp="s x="_exp
		x exp
		s data=$lb("")
		s $li(data,1)="OK"
		s $li(data,2)=""
		q data
ERR
	s data=$lb("")
	s $li(data,1)="FAIL"
	s $li(data,2)="测试表达式时发生错误,请核查!详细信息:"_$ZError
	s $li(data,3)="测试表达式:"_exp
	q data
}

ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

ClassMethod Instr(exp, str, start)
{
		n (exp,str,start)
		//w %var,!
		q:str=""!exp="" -1
		s len=$l(str)
		s ret=-1
		f i=start:1:($l(exp)-len)  d
		.s tmp=$extract(exp,i,i+len-1)
		.i tmp=str  d
		..s ret=i
		..q
		q ret
}

/// 
/// <H3>功能：编译表达式，使其成为真正可以执行的Cache语法</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>exp</B>：需要转化的表达式</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 转换完成的表达式
ClassMethod CompileExpression(arryRule As %ListOfObjects)
{
	n (arryRule)
	s intRuleCount=arryRule.Count()
	s repid=$I(^CacheTemp)
	s ErrCnt=0
	s errArry=$lb("Error")
	f ruleCounter=1:1:intRuleCount  d
	.s objRuleItm=arryRule.GetAt(ruleCounter) //DHCMed.CC.SubjectItm
	.s objItmDic=##class(DHCMed.CC.ItemDic).GetObjById(objRuleItm.ItemDic)
	.q:$IsObject(objItmDic)=0  //Modified By LiYang 2011-10-03 如果没有关联数据，就跳过
	.s result=..EvaExpression(objItmDic.IDExpression)
	.i $li(result,1)="OK"  d
	..s ^CacheTemp(repid,"CC.CompiledExpression",objRuleItm.%Id())=$li(result,2) //将翻译成Cache语句的表达式存放入临时Global
	.e  d
	..f j=2:1:$ll(result)  d
	...s ErrCnt=ErrCnt+1
	...s $li(errArry,ErrCnt+1)=$li(result,j)
	
	s ret=$lb("")
	i ErrCnt=0  d
	.s $li(ret,1)="OK"
	.s $li(ret,2)=repid
	e  d
	.k ^CacheTemp(repid)
	q:ErrCnt=0 ret
	q:ErrCnt>0 errArry
}

ClassMethod Test()
{
		//w ##class(DHCMed.CCService.System.ExpEvaluation).Test()
		;s exp="(1*3)+(6+#BasePackage.Fn01(1,2)+400+#BasePackage.Fn01(8,2))*100"	
		s %PAADM=50729
		s %ExtraData=$lb()
		s exp="(#OrderLib.HasOrder(11029).and.#OrderLib.HasOrder(#OrderLib.HasOrder(11029)))"	
		s %var="var"
		s result=..EvaExpression(exp)
		;w "打印结果：",!
		f i=1:1:$ll(result)  d
		.;w $li(result,i),!
		q ""
}

}
