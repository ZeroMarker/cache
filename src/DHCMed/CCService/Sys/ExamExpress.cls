/// 名称: DHCMed.CCService.Sys.ExamExpress
/// 描述: 监控表达式解析主题程序
/// 编写者：zhufei
/// 编写日期: 2011-03-11
Class DHCMed.CCService.Sys.ExamExpress Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Sys.ExamExpress).Test()
ClassMethod Test()
{
	New
	Set CtrlItem=12
	Set %EpisodeID=128
	Set %PatientID=235617
	Set %PAADM=%EpisodeID
	Set %Patient=%PatientID
	Set %ZIndex=$zn
	Set %JIndex=$j
	
	Set return=..Main(CtrlItem)
	Write "return="_##Class(DHCMed.CCService.Lib.Common).GetListToString(return,"///"),!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2011-03-11
/// Description:  监控表达式解析主题程序
/// Table：       
/// Input：       ItemID: 监控项目ID
/// Return：      返回监控结果
/// w ##class(DHCMed.CCService.Sys.ExamExpress).Main("")
ClassMethod Main(argItemID As %String) As %String
{
	New (argItemID,%EpisodeID,%PatientID,%PAADM,%Patient,%ZIndex,%JIndex)
	Set return="",ItemDesc=""
	Quit:argItemID="" return
	
	Set $ZT="MainErr"
	
	Set %ExtraData=$lb("")
	Set %ExtraDataCnt=0
	Set %ErrorData=$lb("")
	Set %ErrorDataCnt=0
	
	Set Score=$g(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",0,argItemID,"ItmScore"))
	Set Expression=$g(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",0,argItemID,"ItmExp"))
	Set ItemDesc=$g(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",0,argItemID,"ItmDesc"))
	//Modified By LiYang 2012-04-12 传出其他系统需要的附加数据
	Set Resume=$g(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",0,argItemID,"Resume"))
	If Expression="" {
		Set Score=$g(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",1,argItemID,"ItmScore"))
		Set Expression=$g(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",1,argItemID,"ItmExp"))
		Set ItemDesc=$g(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",1,argItemID,"ItmDesc"))
		Set Resume=$g(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",1,argItemID,"Resume"))
	}
	Quit:(Expression="")||(ItemDesc="") return
	Set exp="Set CtrlRst=("_Expression_")"
	Xecute exp
	;w !,Resume
	//Modified By LiYang 2012-07-04处理升级后的类库
	Set arryExtra=$lb("")
	Set intPos=1
	Set intCnt=$ll(%ExtraData)
	For i=1:1:intCnt
	{
		Set item=$lg(%ExtraData,i)
		Continue:item=""
		Set $li(arryExtra,intPos)=$p(item,$c(3),1)
		Set intPos=intPos+1
	}
	//Set return=$lb(ItemDesc,+Score,CtrlRst,%ExtraData,%ErrorData,Resume)
	Set return=$lb(ItemDesc,+Score,CtrlRst,arryExtra,%ErrorData,Resume)
	;zw ^TMP(%ZIndex,%JIndex)
	Quit return
	
MainErr
	Set return=$lb(ItemDesc,-999,1,"",$lb(argItemID_"///"_%EpisodeID_"///"_%PatientID_"///"_$ZERROR_"///"_exp))
	Quit return
}

/// w ##Class(DHCMed.CCService.Sys.ExamExpress).changeExpression(exp)
ClassMethod changeExpression(argExp As %String) As %String
{
	New (argExp)
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
			Set strClassMethod=$p(strClassMethod,"(",1)_"("_$p(strClassMethod,"(",2)_"("
			If strClassMethod="" {
				Set strLeft=strLeft_"#"
			}Else{
				Set strLeft=strLeft_strClassMethod
				Set strRight=$e(strRight,$l(strCenter)+2,$l(strRight))
			}
		}Else{
			Set strLeft=strLeft_"#"
		}
		Set return=return_strLeft
		//w "strLeft2="_strLeft,!
		//w "strCenter2="_strCenter,!
		//w "strRight2="_strRight,!!
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
	New (argMethod)
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
	New (argMethod)
	Set return=""
	Quit:argMethod="" return
	
	Set className=$p(argMethod,".",1)
	Set methodName=$p(argMethod,".",2)
	Set className=$$ALPHAUP^SSUTIL4(className)
	Set methodName=$$ALPHAUP^SSUTIL4(methodName)
	Quit:(className="")||(methodName="") return
	
	Set objPackage=##class(DHCMed.CC.MethodPackage).GetPackageByName(className)
	Quit:'$IsObject(objPackage) return
	Set PackageID=objPackage.%Id()
	Set objMethod=##class(DHCMed.CC.MethodInfo).GetMethodInfoByName(PackageID,methodName)
	Quit:'$IsObject(objMethod) return
	
	Set return=objMethod.ClassMethod
	Quit return
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
