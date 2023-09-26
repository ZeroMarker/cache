/// 名称:	EMR.DOC.COM.CheckTool
/// 描述:	字符对比公用方法类
/// 编写者:	yejian
/// 编写日期: 	2021-2-22
/// 产品组：	电子病历产品组
Class EMR.DOC.COM.CheckTool Extends %RegisteredObject
{

ClassMethod GetFileName(aID As %String) As %String
{
 ;hhhhhhjjj
 
 s AOSString = ##class(%SYSTEM.Version).GetOS()
 s WindowsFlag =$Find(AOSString,"Windows") 
 S UNIXFlag =$Find(AOSString,"UNIX") 
	 set FilePath=$ZUTIL(12,"")_"Temp"
	 if '##Class(%Library.File).DirectoryExists(FilePath)
	 {
		 s Result = ##Class(%Library.File).CreateDirectoryChain(FilePath) 
	 }
	 
	 if (WindowsFlag>0) 
	 {
	   s FileNameStr = FilePath_"\"_$J_"_"_$tr(aID,"||","_")_".xml"
	   Quit FileNameStr	 
		 
		 }
	 if (UNIXFlag>0) 
	 {
	   s FileNameStr = FilePath_"/"_$J_".xml"
	   Quit FileNameStr	 
		 }
}

ClassMethod DetectGB(ACompStr As %String) As %String
{
 s HasGBStr="False"
  S ComLength = $L(ACompStr)
  for I=1:1:ComLength
  {Q:(HasGBStr="True")
	S GBStr= $E(ACompStr,I)  
	if (($A(GBStr)>=19968)&& ($A(GBStr)<=40869))||(($A(GBStr)>=63744)&& ($A(GBStr)<=64045))
	{ s HasGBStr="True"	 } 
	  }
	Q HasGBStr
}

ClassMethod CheckGBStrConTain(AVesselStr As %String, ACompStr As %String) As %String
{
  S Result = "False"
  S ComLength = $L(ACompStr)
  s HasConFlag= "True"
	 for I=1:1:ComLength 
     { S GBStr= $E(ACompStr,I)  
	   s GBConFlag= "False"
	   if (I=1)
	   { S ANewVesselStr = AVesselStr  }
        if (ANewVesselStr [GBStr)
        { s GBConFlag= "True"
	      S ANewVesselStr = $E(ANewVesselStr, $F(ANewVesselStr,GBStr),$L(ANewVesselStr))
	        }
		if (GBConFlag="False")
		{ s HasConFlag= "False"
		}
    }
	 if (HasConFlag="True")
	 { S Result ="True" 	 }
	  
  Quit Result
}

ClassMethod CheckGBContain(AVesselStr As %String, ACompStr As %String) As %String
{
  s conditionType=$ZCVT($P(ACompStr,"^",1),"U")
  s:((conditionType="2")||(conditionType="1")||(conditionType="0")||(conditionType="")||(conditionType="CODE")||(conditionType="ROWID")||(conditionType="DESC")) ACompStr=$P(ACompStr,"^",2)
  s Result = "False"
  S ComLength = $L(ACompStr)
  if (conditionType="2")
  {
	s VesselLength = $L(AVesselStr)	  
	q:(VesselLength<ComLength) Result
	s VesselStr = $e(AVesselStr,1,ComLength)
	q:(VesselStr '= ACompStr) Result
	s Result = "True"
  }elseif(conditionType = "1")
  {
	q:(AVesselStr '=  ACompStr) Result
	s Result = "True"
  }else
  { 
  s HasGBStr="False"
  for I=1:1:ComLength
  {
	S GBStr= $E(ACompStr,I)  
	if (($A(GBStr)>=19968)&& ($A(GBStr)<=40869))||(($A(GBStr)>=63744)&& ($A(GBStr)<=64045))
	{ s HasGBStr="True"	
	  Continue
	} 
  }
  if (HasGBStr="False")
  {
	if (AVesselStr [ ACompStr)
	{ s Result = "True"}
  }
  Elseif (HasGBStr="True")
  { 
  	 s HasConFlag= "True"
	 for I=1:1:ComLength 
     { S GBStr= $E(ACompStr,I)  
	   s GBConFlag= "False"
	   if (I=1)
	   { S ANewVesselStr = AVesselStr  }
       if (ANewVesselStr [GBStr)
       { 
       	  s GBConFlag= "True"
	      S ANewVesselStr = $E(ANewVesselStr, $F(ANewVesselStr,GBStr),$L(ANewVesselStr))
	   }
	   if (GBConFlag="False")
	    { 
	    	s HasConFlag= "False"
		}
    }
	if (HasConFlag="True")
	 { 
	 S Result ="True" 	 
	 }
	} 	
  }
  Quit Result
}

/// Desc:  		字符对比
/// Creator:    yejian
/// CreateDate: 2022-8-2
/// Input:      AVesselStr  AConditionType_"^"_AConditon 查询方式（0: 模糊搜索, 1: 精确搜索,2:左查询）
/// OutPut:     
/// Debug:			
ClassMethod CheckContain(AVesselStr, ACompStr, isGB)
{
  
  s conditionType=$ZCVT($P(ACompStr,"^",1),"U")
 s:((conditionType="2")||(conditionType="1")||(conditionType="0")||(conditionType="")||(conditionType="CODE")||(conditionType="ROWID")||(conditionType="DESC")) ACompStr=$P(ACompStr,"^",2)
  S Result = 0
  S ComLength = $L(ACompStr)
  if (conditionType="2")
  {
	s VesselLength = $L(AVesselStr)	  
	q:(VesselLength<ComLength) Result
	s VesselStr = $e(AVesselStr,1,ComLength)
	q:(VesselStr '= ACompStr) Result
	s Result = 1
  }elseif(conditionType = "1")
  {
	s AVesselStr=$ZSTRIP(AVesselStr,"*C")
	q:(AVesselStr '=  ACompStr) Result
	s Result = 1
  }else
  { 
  if 'isGB
  {
		if (AVesselStr [ ACompStr)
		{ s Result = 1}
	}
  Elseif isGB
  {s HasConFlag= "True"
	 for I=1:1:ComLength 
     { S GBStr= $E(ACompStr,I)  
	   s GBConFlag= "False"
	   if (I=1)
	   { S ANewVesselStr = AVesselStr  }
        if (ANewVesselStr [GBStr)
        { s GBConFlag= "True"
	      S ANewVesselStr = $E(ANewVesselStr, $F(ANewVesselStr,GBStr),$L(ANewVesselStr))
	      }
			if (GBConFlag="False")
			{ s HasConFlag= "False"	}
    }
	 if (HasConFlag="True")
	 { S Result =1 	 }
	} 	
  }
  Quit Result
}

ClassMethod testCheckGBContain()
{
  s aa="123S哈里平5"
  s bb="哈5里"
  s dd="哈里"
  s cc="3S哈里平5"
  s ee="123S哈5里平5"
  s gg="sdddddfff"
  s ff="sdf"
  s kk="sd"
  s kkk="ffff1"
  w ##class(EPRservice.BOStdDictionary).CheckGBContain(aa,bb) ,!	 
  w ##class(EPRservice.BOStdDictionary).CheckGBContain(aa,cc) ,!	 
  w ##class(EPRservice.BOStdDictionary).CheckGBContain(aa,dd) ,!	 
  w ##class(EPRservice.BOStdDictionary).CheckGBContain(ee,bb) ,!	 
  w ##class(EPRservice.BOStdDictionary).CheckGBContain(gg,ff) ,!	 
  w ##class(EPRservice.BOStdDictionary).CheckGBContain(gg,kk) ,!	 
  w ##class(EPRservice.Utility).CheckGBContain(gg,kkk) ,!
}

ClassMethod ParserStream()
{
  Set LefReserve ="<" 	
  Set RightReserve  =">"
  Set LefMidBracket ="["
  set ReghtMidBracket ="]"
  set ExclamationMark ="!"
  Set BeginFirstLefReserveFlag="Flase" //<
  Set BeginTwoExclamationFlag="Flase"  //!
  Set BeginThreeLefMidBracketFlag="Flase" //[
  Set BeginFourGimelFlag="Flase"  //C
  Set BeginFiveDeltaFlag="Flase" //D 
  Set BeginSixAlephFlag="Flase"  // A
  Set BeginSevenTauFlag="Flase" // T
  Set BeginEightAlephFlag="Flase" // A
  Set BeginNineDeltaFlag="Flase" // [
  
  Set EndFirstMidBracket="Flase"
  Set EndTwoMidBracket="Flase"
  Set EndThreeRightReserve="Flase"
}

ClassMethod icdtest(argTarget As %String)
{
	s hasGB=0
  S ComLength = $L(argTarget)
  for I=1:1:ComLength {
	S GBStr= $E(argTarget,I)  
	if (($A(GBStr)>=19968)&& ($A(GBStr)<=40869))||(($A(GBStr)>=63744)&& ($A(GBStr)<=64045))
	{s hasGB=1}
	q:(hasGB=1)
	}
	
	s rowid=""
	for {
		s rowid=$o(^MRC("ID",rowid))
		q:(rowid="")
		s code=$p($g(^MRC("ID",rowid)),"^",4)
		s desc=$p($g(^MRC("ID",rowid)),"^",2)
		s aliasRowid=0,alias=""
		for {
			s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
			q:(aliasRowid="")
			s alias=alias_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		}
		;w code_"^"_desc_"^"_alias,!
		if (hasGB=1) {
			if $$CheckContain(desc,argTarget,hasGB) {w code_"^"_desc_"^"_alias,!}
		}
		else {
			if $$CheckContain(desc,argTarget,hasGB)||$$CheckContain(code,argTarget,hasGB)||$$CheckContain(alias,argTarget,hasGB) {w code_"^"_desc_"^"_alias,!}
		}
	}
	
	
CheckContain(AVesselStr,ACompStr,isGB)
  S Result = 0
  S ComLength = $L(ACompStr)
  
  if 'isGB
  {
		if (AVesselStr [ ACompStr)
		{ s Result = 1}
	}
  Elseif isGB
  {s HasConFlag= "True"
	 for I=1:1:ComLength 
     { S GBStr= $E(ACompStr,I)  
	   s GBConFlag= "False"
	   if (I=1)
	   { S ANewVesselStr = AVesselStr  }
        if (ANewVesselStr [GBStr)
        { s GBConFlag= "True"
	      S ANewVesselStr = $E(ANewVesselStr, $F(ANewVesselStr,GBStr),$L(ANewVesselStr))
	      }
			if (GBConFlag="False")
			{ s HasConFlag= "False"	}
    }
	 if (HasConFlag="True")
	 { S Result =1 	 }
	} 	
  Quit Result
}

}
