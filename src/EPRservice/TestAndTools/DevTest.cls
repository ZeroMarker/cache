Class EPRservice.TestAndTools.DevTest Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod testmr() As %String
{
	//地坛测试 取统计组袁旭出院日期接口
	
	w ##Class(EPRservice.HISInterface.PatientInfoAssist).DisDateTimeMR(7,"DHC-DATA","DiTan")
}

ClassMethod CheckCharLength(argChar As %String, argLength As %Integer) As %String
{
	q:($d(argChar)=0)||($d(argLength)=0)||(argChar="")||(argLength="") ""

	/// get the length of argChar in GB character set, that is, a GB character's length is 2
	;b "s"
	s charLength=$l($zcvt(argChar,"O","GB"))
	s length=$l(argChar)
	q:(charLength'>argLength) argChar
	;q:(length<4) ""
	q:(length<4) $e(argChar,1,argLength)
	if argLength<=4
	{
		s getLength = argLength - 1
		s endString = "."	
	}
	else
	{
		s getLength = argLength - 4
		s endString = "...."	
	}

	if charLength - length > argLength - 4
	{
		q $e(argChar,1,getLength/2)_endString
	}
	else
	{
		q $e(argChar,1,getLength -(charLength - length))_endString
	}
	q argChar
}

/// ##Class(EPRservice.TestAndTools.DevTest).InterfgetPrivPatType(1)
ClassMethod InterfgetPrivPatType(argAdmId As %String) As %String
{
	;b "s"
	s Type=""
	
	//取取系统参数 医院名称
	s Hospital=""
	s Hospital=##Class(EPRservice.HISInterface.PatientInfoAssist).HospitalName()
	q:(Hospital="") ""


	//取系统参数 模板权限字典表ID
 	//TemplatePrivPatTypeStr
 	s TypeStr=""
 	;s TypeStr="^1^2^3^@^1^2^3^||^4^5^6^@^4^5^6^||^7^8^9^@^7^8^9^"
 	s TypeStr=##class(EPRmeta.SysOption).GetOptionValueByName("TemplatePrivPatTypeStr")	
 	q:(TypeStr="") ""
 	
 	
 	//取界面单元的数据
 	if Hospital="DiTan" 
 	{
	 	
	}
    elseif  Hospital="HeFei" 
    {

 		s scatterCode = "病人类型.病人类型选择.病人类别#TYPE:Simple#TID:200#TVER:0#SCODE:I0001#VTYPE:C"
		s Type = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,scatterCode)
		s Type=$tr(Type,"Null")
		q:(Type="") ""
	}	
	

	// 取病人所在当前科室RowId
	s Dept = "",i=""
	s Dept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(argAdmId)
	q:(dept="") ""
	s Dept =$p($g(Dept),"^",1)
	
	
	//实现不同科室使用不同的病历类型
	s Return=""
	s TypeStrCount=""
	s TypeStrCount=$l(TypeStr,"||")

	f i=1:1:TypeStrCount
	{
		s TypeSubStr=$p($g(TypeStr),"||",i)
		s TypeSubStrLoc=$p($g(TypeSubStr),"@",1)
		s TypeSubStrItemCode=$p($g(TypeSubStr),"@",2)

		i ($f(TypeSubStrLoc,"^"_Dept_"^")'=0)&&($f(TypeSubStrItemCode,"^"_Type_"^")'=0)
		{ 
		  s Return="1" 
		  q
		}
	}
	
    i Return="1" 
    { q Type }
    else 
    { q "" }
}

}
