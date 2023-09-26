Class BILL.CES.COM.DBEXCUTE Extends %RegisteredObject
{

/// 调用web.INSUEXCUTE类中方法转一下
/// w ##class(BILL.CES.COM.DBEXCUTE).Excute("BILL.CES.BL.Export","GetSSUserData","0","1000","","","","","","","","","","","","","","").Read()
/// w ##class(BILL.CES.COM.DBEXCUTE).Excute("BILL.CES.COM.MacManager","MacRegister","00:45:E2:0C:9D:65^A01^192.167.94.152^^114.242.246.235","","","","","","","","","","","","","","","").Read()
ClassMethod Excute(ClassName, MethodName, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) As %Stream.GlobalCharacter
{
	//quit ##class(web.INSUEXCUTE).Excute(ClassName, MethodName, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)
	/*
	set dicObj=##class(%Dictionary.CompiledMethod).%OpenId($this_"||"_"Excute")
	set args=$length(dicObj.FormalSpec,",")-2	//传递所有参数
	for pind=1:1:args{
		set args(pind)=@("p"_pind)
	}
	set dicObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassName_"||"_MethodName)
	set formalSpec=dicObj.FormalSpec
	if (formalSpec'["..."){
		set args=$length(formalSpec,",")	//按调用方法参数个数调用
	}
	quit $CLASSMETHOD(ClassName, MethodName, args...)
	*/
	set args(1)=p1,args(2)=p2,args(3)=p3,args(4)=p4
	set args(5)=p5,args(6)=p6,args(7)=p7,args(8)=p8
	set args(9)=p9,args(10)=p11,args(11)=p11,args(12)=p2
	set args(13)=p13,args(14)=p14,args(15)=p15,args(16)=p16
	set args=16
	set dicObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassName_"||"_MethodName)
	set formalSpec=dicObj.FormalSpec
	if (formalSpec=""){
		set args=0
	}else{
		if (formalSpec'["..."){
			set args=$length(formalSpec,",")	//按调用方法参数个数调用
		}
	}
	set exeStr="myrtn=##class("_ClassName_")"_"."_MethodName_"("
	for i=1:1:args{
		if i>1 set exeStr=exeStr_","
		set exeStr=exeStr_""""_args(i)_""""
	}
	
	set exeStr=exeStr_")"
	set @exeStr
	set myrtn=@"myrtn"
	
	set stream=##class(%Stream.GlobalCharacter).%New()
	if ($isobject(myrtn)){
		if ($CLASSNAME(myrtn)["Stream"){
			do stream.CopyFrom(myrtn)
		}
	}else{
		do stream.Write(myrtn)
	}
	quit stream
}

}
