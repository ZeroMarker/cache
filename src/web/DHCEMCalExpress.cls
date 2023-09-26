Class web.DHCEMCalExpress Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEMCalExpress).changeExpression("(#BP.CheckSBP()<30).and.(#BP.CheckSBP()>250)")
ClassMethod changeExpression(argExp As %String) As %String
{
		
		n (argExp)
		Set return=""
		Quit:argExp="" return
		Set $ZT="changeExpressionErr"
		Set (strLeft,strCenter,strRight)=""
		Set strRight=argExp
		For ind=1:1:$l(argExp,"#")-1
		{
			Set strLeft=$p(strRight,"#",1)
			Set strRight=$e(strRight,$l(strLeft)+2,$l(strRight))
			Set strCenter=$p(strRight,"(",1)
			//w "strLeft1="_strLeft,!
			//w "strCenter1="_strCenter,!
			//w "strRight1="_strRight,!!
			If ($l(strCenter,".")=2)&&(..checkMethod(strCenter)>0) {
				Set strClassMethod=..getClassMethod(strCenter)  //如:  A.B( --> ##AAA.BBB()
				//w "strClassMethod="_strClassMethod,! 
				Set strClassMethod=$p(strClassMethod,")",1)_")"_$p(strClassMethod,")",2)
				//w $p(strClassMethod,")",2),!
				//w "strClassMethod2="_strClassMethod,!  

				Set strLeft=strLeft_strClassMethod
				Set strRight=$e(strRight,$l(strCenter)+2,$l(strRight))

			}Else{
				Set strLeft=strLeft_"#"
			}
			Set return=return_strLeft
		}
		Set return=return_strRight
		Set return=..ReplaceString(return,".and.","&&")
		Set return=..ReplaceString(return,".or.","||")
		Set return=..ReplaceString(return,".not","!")
		Set return=..ReplaceString(return,"[","""")
		Set return=..ReplaceString(return,"]","""")
	
		Quit return
	
changeExpressionErr
		Write "Error:"_$ZERROR,!
		Quit ""
}

ClassMethod checkMethod(argMethod As %String) As %String
{
		n (argMethod)
		Set return=1
		Quit:argMethod="" return
		For i=1:1:$l(argMethod)
		{
			Set tmp=$e(argMethod,i,i)
			Continue:tmp="."
			Set tmpASCII=$ASCII(tmp)
			If ((tmpASCII<48)||((tmpASCII>57)&&(tmpASCII<65))||((tmpASCII>90)&&(tmpASCII<97))||(tmpASCII>122)){
				Set return=-1
				Quit
			}
		}
		Quit return
}

ClassMethod getClassMethod(argMethod As %String) As %String
{
		n (argMethod)
		//s method=$$ALPHAUP^SSUTIL4(argMethod)
		//w argMethod,!
		s lfl=$o(^DHCEMLFL(0,"Code",argMethod,""))
		q:lfl="" ""
		
		Quit $p(^DHCEMLFL(lfl),"^",3)
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

}
