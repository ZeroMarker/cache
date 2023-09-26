/// 编译监控表达式
Class DHCMed.CCService.AutoProcess.CompileExpressLib Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMed.CCService.AutoProcess.CompileExpressLib).Test()
ClassMethod ExtractExpression(Expression As %String)
{
	n (Expression)
	Set Cnt=1
	Set resList=$lb("")
	Set intPos=1
	set a=1
	/*
	sssssssss
	For 
	{
		Set intPos=$Find(Expression,"#",1)
		Quit:intPos=0
		
	}*/
	w $$FindMethod(Expression),!
	Quit resList
FindMethod(Expression)
	n (Expression,resList)
	Set intStart=$Find(Expression,"#")-1
	Quit:intStart=0 "NOTHING"
	Set intEnd=$Find(Expression,"(",intStart)-1
	Quit:intEnd=0 "ERROR:没有左括号"
	Set NextMethodFlagPos=0 //嵌套函数标记 就是查找嵌套函数的“#”标记
	Set flag=0 //找到左括号,初始值为1表示上面从第一个左括号后面开始
	Set flagCnt=0 //左括号与右括号配对成功
	For {
		Quit:intEnd>$length(Expression)
		Set char=$extract(Expression,intEnd)
		Set:char="(" flag=1
		Set:char="(" flagCnt=flagCnt+1
		Set:char=")" flagCnt=flagCnt-1 
		Quit:(flagCnt=0)
		//w "第"_intEnd_"字符："_char,!
		Set intEnd=intEnd+1
	}
	Set intEnd=intEnd
	Set Exp=$Extract(Expression,intStart,intEnd)
	W "New Exp:"_Exp,!
	Set Pos=$ListLength(resList)
	Set OldExp=..ReplaceString(Expression,Exp,"{"_Pos_"}")
	Set $li(resList,Pos)=OldExp
	Set resList=resList_$lb(Exp)
	Set NextMethodFlagPos=$Find(Exp,"#",2)-1
	If (NextMethodFlagPos>0)
	{
		Set SubExp=$Extract(Exp,1,$Length(Exp))
		Set ret=$$FindMethod(SubExp)
	}
	Quit 1
}

ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1) {
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

ClassMethod Test()
{
	Set lst=..ExtractExpression("1+#OrderLib.HasOrder(#OrderLib.HasOrder(111))-2")
	For i=1:1:$ListLength(lst) {
		W i_":     "_$lg(lst,i),!
	}
	Quit "OK"
}

}
