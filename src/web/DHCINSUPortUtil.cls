Class web.DHCINSUPortUtil Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:ZhanMingChao
/// Description:把传入的对象转换为可以保存的adminfo字符串,如果不是User.INSUAdmInfo对象请自行修改
/// Input：Injson:对象
/// Output: 可以直接保存到adminfo表的字符串
/// CreatDate:20160622
/// Others: 
ClassMethod ObjAdminfoSerialize(inObj, ExpStr As %String) As %String [ Private ]
{
	s Adminfostr=""
	i $IsObject(inObj) d
	.s $p(Adminfostr,"^",2)=inObj.INADMAdmDr.%Id() ;inObj.INADMAdmDr
	.s $p(Adminfostr,"^",3)=inObj.INADMInsuId
	.s $p(Adminfostr,"^",4)=inObj.INADMCardNo
	.s $p(Adminfostr,"^",5)=inObj.INADMPatType
	.s $p(Adminfostr,"^",6)=inObj.INADMCardStatus
	.s $p(Adminfostr,"^",7)=inObj.INADMCompany
	.s $p(Adminfostr,"^",8)=inObj.INADMStates
	.s $p(Adminfostr,"^",9)=inObj.INADMCenter
	.s $p(Adminfostr,"^",10)=inObj.INADMAccount
	.s $p(Adminfostr,"^",11)=inObj.INADMAdmSeriNo
	.s $p(Adminfostr,"^",12)=inObj.INADMActiveFlag
	.s $p(Adminfostr,"^",13)=inObj.INADMAdmDate
	.s $p(Adminfostr,"^",14)=inObj.INADMAdmTime
	.s $p(Adminfostr,"^",15)=inObj.INADMAdmType
	.s $p(Adminfostr,"^",16)=inObj.INADMDeptDesc
	.s $p(Adminfostr,"^",17)=inObj.INADMInsuUser
	.s $p(Adminfostr,"^",18)=inObj.INADMIpTimes
	.s $p(Adminfostr,"^",19)=inObj.INADMInsuType
	.s $p(Adminfostr,"^",20)=inObj.INADMAdmCancelNo
	.s $p(Adminfostr,"^",21)=inObj.INADMOutDate
	.s $p(Adminfostr,"^",22)=inObj.INADMOutTime
	.s $p(Adminfostr,"^",23)=inObj.INADMOutUser
	.s $p(Adminfostr,"^",24)=inObj.INADMUserDr
	.s $p(Adminfostr,"^",25)=inObj.INADMFunDate
	.s $p(Adminfostr,"^",26)=inObj.INADMFunTime
	.s $p(Adminfostr,"^",27)=inObj.INADMXString1
	.s $p(Adminfostr,"^",28)=inObj.INADMXString2
	.s $p(Adminfostr,"^",29)=inObj.INADMXString3
	.s $p(Adminfostr,"^",30)=inObj.INADMXString4
	.s $p(Adminfostr,"^",31)=inObj.INADMXFloat1
	.s $p(Adminfostr,"^",32)=inObj.INADMXFloat2
	.s $p(Adminfostr,"^",33)=inObj.INADMXFloat3
	.s $p(Adminfostr,"^",34)=inObj.INADMXFloat4
	.s $p(Adminfostr,"^",35)=inObj.INADMXString5
	.s $p(Adminfostr,"^",36)=inObj.INADMXString6
	.s $p(Adminfostr,"^",37)=inObj.INADMXString7
	.s $p(Adminfostr,"^",38)=inObj.INADMXString8
	.s $p(Adminfostr,"^",39)=inObj.INADMXString9
	.s $p(Adminfostr,"^",40)=inObj.INADMXString10
	.s $p(Adminfostr,"^",41)=inObj.INADMXString11
	.s $p(Adminfostr,"^",42)=inObj.INADMXString12
	.s $p(Adminfostr,"^",43)=inObj.INADMXString13
	.s $p(Adminfostr,"^",44)=inObj.INADMXString14
	.s $p(Adminfostr,"^",45)=inObj.INADMXString15
	.s $p(Adminfostr,"^",46)=inObj.INADMXString16
	.s $p(Adminfostr,"^",47)=inObj.INADMXString17
	.s $p(Adminfostr,"^",48)=inObj.INADMXString18
	.s $p(Adminfostr,"^",49)=inObj.INADMXString19
	.s $p(Adminfostr,"^",50)=inObj.INADMXString20
	.s $p(Adminfostr,"^",51)=inObj.INADMInsuAdmInfoDr.%Id()
	q:(+inObj.INADMAdmDr=0) -1
	q Adminfostr
}

/// Creator:ZhanMingChao
/// Description:把传入的对象转换为可以保存的DIVIDE字符串,如果不是User.INSUDivide对象,请自行修改
/// Input：Injson:对象
/// Output: 可以直接保存到divide表的字符串
/// CreatDate:20160621
/// Others: 
ClassMethod ObjDivSerialize(inObj, ExpStr As %String) As %String [ Private ]
{
	s Divstr="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	i $IsObject(inObj) d
	.s $p(Divstr,"^",2)=inObj.INPAYAdmDr.%Id()
	.s $p(Divstr,"^",3)=inObj.INPAYAdmInfoDr.%Id()
	.s $p(Divstr,"^",4)=inObj.INPAYDHCpblDr.%Id()
	.;s $p(Divstr,"^",5)=inObj.INPAYDhcInvPrtDr.%Id() ;20180529
	.s $p(Divstr,"^",5)=inObj.INPAYDhcInvPrtDr
	.s $p(Divstr,"^",6)=inObj.INPAYFlag
	.s $p(Divstr,"^",7)=inObj.INPAYINSUDivideDr.%Id()
	.s $p(Divstr,"^",8)=inObj.INPAYbcbxf0
	.s $p(Divstr,"^",9)=inObj.INPAYdjlsh0
	.s $p(Divstr,"^",10)=inObj.INPAYbckbcs
	.s $p(Divstr,"^",11)=inObj.INPAYbqbm00
	.s $p(Divstr,"^",12)=inObj.INPAYbrnl00
	.s $p(Divstr,"^",13)=inObj.INPAYcardno
	.s $p(Divstr,"^",14)=inObj.INPAYcfxms0
	.s $p(Divstr,"^",15)=inObj.INPAYcrbcts
	.s $p(Divstr,"^",16)=inObj.INPAYgrzfe0
	.s $p(Divstr,"^",17)=inObj.INPAYiDate
	.s $p(Divstr,"^",18)=inObj.INPAYiTime
	.s $p(Divstr,"^",19)=inObj.INPAYid0000
	.s $p(Divstr,"^",20)=inObj.INPAYjjzfe0
	.s $p(Divstr,"^",21)=inObj.INPAYptbcts
	.s $p(Divstr,"^",22)=inObj.INPAYsUserDr
	.s $p(Divstr,"^",23)=inObj.INPAYsfrq00
	.s $p(Divstr,"^",24)=inObj.INPAYsfrxm0
	.s $p(Divstr,"^",25)=inObj.INPAYsfsj00
	.s $p(Divstr,"^",26)=inObj.INPAYsftsbz
	.s $p(Divstr,"^",27)=inObj.INPAYxbie00
	.s $p(Divstr,"^",28)=inObj.INPAYxming0
	.s $p(Divstr,"^",29)=inObj.INPAYzhzfe0
	.s $p(Divstr,"^",30)=inObj.INPAYzyksmc
	.s $p(Divstr,"^",31)=inObj.INPAYzylsh0
	.s $p(Divstr,"^",32)=inObj.INPAYInsuPay1
	.s $p(Divstr,"^",33)=inObj.INPAYInsuPay2
	.s $p(Divstr,"^",34)=inObj.INPAYInsuPay3
	.s $p(Divstr,"^",35)=inObj.INPAYInsuPay4
	.s $p(Divstr,"^",36)=inObj.INPAYInsuPay5
	.s $p(Divstr,"^",37)=inObj.INPAYZstr01
	.s $p(Divstr,"^",38)=inObj.INPAYZstr02
	.s $p(Divstr,"^",39)=inObj.INPAYZstr03
	.s $p(Divstr,"^",40)=inObj.INPAYZstr04
	.s $p(Divstr,"^",41)=inObj.INPAYZstr05
	.s $p(Divstr,"^",42)=inObj.INPAYZstr06
	.s $p(Divstr,"^",43)=inObj.INPAYZstr07
	.s $p(Divstr,"^",44)=inObj.INPAYZstr08
	.s $p(Divstr,"^",45)=inObj.INPAYZstr09
	.s $p(Divstr,"^",46)=inObj.INPAYZstr10
	.s $p(Divstr,"^",47)=inObj.INPAYInsuPay6
	.s $p(Divstr,"^",48)=inObj.INPAYInsuPay7
	.s $p(Divstr,"^",49)=inObj.INPAYInsuPay8
	.s $p(Divstr,"^",50)=inObj.INPAYInsuPay9
	.s $p(Divstr,"^",51)=inObj.INPAYInsuPay10
	.s $p(Divstr,"^",52)=inObj.INPAYZstr11
	.s $p(Divstr,"^",53)=inObj.INPAYZstr12
	.s $p(Divstr,"^",54)=inObj.INPAYZstr13
	.s $p(Divstr,"^",55)=inObj.INPAYZstr14
	.s $p(Divstr,"^",56)=inObj.INPAYZstr15
	.s $p(Divstr,"^",57)=inObj.INPAYZstr16
	.s $p(Divstr,"^",58)=inObj.INPAYZstr17
	.s $p(Divstr,"^",59)=inObj.INPAYZstr18
	.s $p(Divstr,"^",60)=inObj.INPAYZstr19
	.s $p(Divstr,"^",61)=inObj.INPAYZstr20
	.s $p(Divstr,"^",62)=inObj.INPAYZstr21
	.s $p(Divstr,"^",63)=inObj.INPAYZstr22
	.s $p(Divstr,"^",64)=inObj.INPAYZstr23
	.s $p(Divstr,"^",65)=inObj.INPAYZstr24
	.s $p(Divstr,"^",66)=inObj.INPAYZstr25
	.s $p(Divstr,"^",67)=inObj.INPAYZstr26
	.s $p(Divstr,"^",68)=inObj.INPAYZstr27
	.s $p(Divstr,"^",69)=inObj.INPAYZstr28
	.s $p(Divstr,"^",70)=inObj.INPAYZstr29
	.s $p(Divstr,"^",71)=inObj.INPAYZstr30
	q:(+inObj.INPAYbcbxf0=0) -1
	q Divstr
}

/// Creator:ZhanMingChao
/// Description:把传入的对象转换为可以保存的DIVIDE字符串
/// Input：Injson:对象,ExpStr:存储顺序是否一致标志^JSON标志^
/// Output: 可以直接保存到divide表的字符串
/// CreatDate:20151104 
/// Others: 
ClassMethod ObjtoDivStr(Injson, ExpStr As %String) As %String [ Private ]
{
	s inObj=""
	s jxFlag=0
	s DivStr="-1"
	s jxFlag=+$p(ExpStr,"^",2)
	i $IsObject(Injson) {
		s inObj=Injson	;说明传入的就是对象
		s DivStr=..ObjDivSerialize(Injson,ExpStr)
	}else{
		;JSON:
		i jxFlag=1 {
			s tmpobj=##class(User.INSUDivide).%New()	
			s inObj=##class(web.INSUCacheJSON).RtnObjectFromJSON(tmpobj,Injson)
			s DivStr=..ObjDivSerialize(inObj,ExpStr)
		}
		;XML
		i jxFlag=2 {
			s tmpobj=##class(User.INSUDivide).%New()	;如果是其它对象请替换到本行的User.INSUDivide
			s inObj=##class(web.INSUCacheXML).Deserialize(.tmpobj,"root",Injson) ;根据XML中根节点修改第二个参数
			;如果是其它对象,请自行转为User.INSUDivide对象后再调用ObjDivSerialize
			;s inObj=OtherOBJtoINSUDivide(inObj)
			s DivStr=..ObjDivSerialize(inObj,ExpStr)
		}
	}
	q DivStr
}

/// 把传入的字符串转换为可以保存的DIVIDE字符串
/// Creator:ZhanMingChao
/// Description:把传入的对象转换为可以保存的DIVIDE字符串
/// Input：InStr:字符串,ExpStr:存储顺序是否一致标志^JSON标志^
/// Output: 可以直接保存到divide表的字符串
/// CreatDate:20151104 
/// Others: 
ClassMethod BuildDivStr(InStr, ExpStr As %String) As %String [ Private ]
{
	q:$l(InStr,"^")<5 -1
	s divflag=+$p(ExpStr,"^",1)
	i divflag=1 {
		//说明存储顺序一致
		s Divstr=InStr
	}else{
		s Divstr=""
		s $p(Divstr,"^",75)=""
		s $p(Divstr,"^",2)=$p(InStr,"^",1)	;AdmDr
		s $p(Divstr,"^",10)=$p(InStr,"^",2)	;Totamt
		s $p(Divstr,"^",16)=$p(InStr,"^",3)	;grzfe
		s $p(Divstr,"^",20)=$p(InStr,"^",4)	;TCZF+ZHZF
		s $p(Divstr,"^",32)=$p(InStr,"^",5)	;TCZF
		s $p(Divstr,"^",29)=$p(InStr,"^",6)	;ZHZF
		s $p(Divstr,"^",6)="I"	;Flag
		s $p(Divstr,"^",37)=$p(InStr,"^",7)	;F（收费）,R（挂号）
		;以下根据项目情况增加
	}
	q Divstr
}

/// Creator:ZhanMingChao
/// Description:把传入的对象或字符串转换为可以直接保存到adminfo的字符串
/// Input：Injson:对象或用^分割的字符串,ExpStr:存储顺序是否一致标志^JSON标志^
/// 			如果是对象，必须是User.INSUAdmInfo
/// 			如果是字符串，顺序为,或者是和adminfo保存顺序一致
/// Output: 可以直接保存到adminfo表的字符串
/// CreatDate:20160622
/// Others: w ##class(web.DHCINSUPortUtil).AdminfoDecode("^^^^^","")
ClassMethod AdminfoDecode(InObj, ExpStr As %String) As %String
{
	s AdminfoStr=""
	s jsonXMLflag=+$p(ExpStr,"^",2)
	i ($IsObject(InObj))||(jsonXMLflag>0) d
	.s AdminfoStr=..ObjtoAdminfoStr(InObj,ExpStr)	;对象或者XML或者JSON
	e  d
	.s AdminfoStr=..BuildAdminfoStr(InObj,ExpStr)	;拼串方式
	q AdminfoStr
}

/// Creator:ZhanMingChao
/// Description:把传入的对象转换为可以保存的ADMINFO字符串
/// Input：Injson:对象,ExpStr:存储顺序是否一致标志^JSON标志^
/// Output: 可以直接保存到ADMINFO表的字符串
/// CreatDate:20160622
/// Others: 
ClassMethod ObjtoAdminfoStr(Injson, ExpStr As %String) As %String [ Private ]
{
	s inObj=""
	s jxFlag=0
	s AdminfoStr="-1"
	s jxFlag=+$p(ExpStr,"^",2)
	i $IsObject(Injson) {
		s inObj=Injson	;说明传入的就是对象
		s AdminfoStr=..ObjAdminfoSerialize(Injson,ExpStr)
	}else{
		;JSON:
		i jxFlag=1 {
			s tmpobj=##class(User.INSUAdmInfo).%New() ;如果是其它对象请修改本行	
			s inObj=##class(web.INSUCacheJSON).RtnObjectFromJSON(tmpobj,Injson)
			;如果是其它对象,请自行转为User.INSUAdmInfo对象后再调用ObjAdminfoSerialize
			;s inObj=OtherOBJtoINSUAdmInfo(inObj)
			s AdminfoStr=..ObjAdminfoSerialize(inObj,ExpStr)
		}
		;XML
		i jxFlag=2 {
			s tmpobj=##class(User.INSUAdmInfo).%New()	;如果是其它对象请替换掉本行的User.INSUAdmInfo
			s inObj=##class(web.INSUCacheXML).Deserialize(.tmpobj,"root",Injson) ;根据XML中根节点修改第二个参数
			;如果是其它对象,请自行转为User.INSUAdmInfo对象后再调用ObjAdminfoSerialize
			;s inObj=OtherOBJtoINSUAdmInfo(inObj)
			s AdminfoStr=..ObjAdminfoSerialize(inObj,ExpStr)
			b
		}
	}
	q AdminfoStr
}

/// 把传入的字符串转换为可以保存的adminfo字符串
/// Creator:ZhanMingChao
/// Description:把传入的对象转换为可以保存的DIVIDE字符串
/// Input：InStr:字符串,ExpStr:存储顺序是否一致标志^JSON标志^
/// Output: 可以直接保存到adminfo表的字符串
/// CreatDate:20160622
/// Others: 
ClassMethod BuildAdminfoStr(InStr, ExpStr As %String) As %String [ Private ]
{
	q:$l(InStr,"^")<5 -1
	s AdminfoStr=""
	s divflag=+$p(ExpStr,"^",1)
	i divflag=1 {
		//说明存储顺序一致
		s AdminfoStr=InStr
	}else{
		s AdminfoStr=""
		s $p(AdminfoStr,"^",55)=""
		s $p(AdminfoStr,"^",5)=$p(InStr,"^",1)  ;病人类型
		s $p(AdmInfoStr,"^",11)=$p(InStr,"^",2)  ;门诊流水号
		;s $p(AdmInfoStr,"^",10)=$p(InStr,"^",3)  ;科室编码
		s $p(AdmInfoStr,"^",16)=$p(InStr,"^",4)  ;科室编码
		s $p(AdmInfoStr,"^",15)=$p(InStr,"^",5)  ;挂号类别
		s $p(AdmInfoStr,"^",2)=$p(InStr,"^",6)  ;就诊表rowid
		s $p(AdmInfoStr,"^",35)=$p(InStr,"^",7) ;社保卡号加密串 
		s $p(AdmInfoStr,"^",12)="A"   ;ActiveFlag
		s $p(AdmInfoStr,"^",19)="BJ" 
		

		;其它自行补充
	}
	q AdminfoStr
}

/// Creator:ZhanMingChao
/// Description:把计费组传入的对象或字符串转换为可以直接保存到divide的字符串
/// Input：Injson:对象或用^分割的字符串,ExpStr:存储顺序是否一致标志^JSON标志^
/// 			如果是对象，必须是User.INSUDivide
/// 			如果是字符串，顺序为AdmDr^Totamt^grzfe^TCZF,ZHZF这几个属性,或者是和DIVIDE保存顺序一致
/// Output: 可以直接保存到divide表的字符串
/// CreatDate:20151104 
/// Others: w ##class(web.DHCINSUPortUtil).DivDecode("^^^^^","")
ClassMethod DivDecode(InObj, ExpStr As %String) As %String
{
	s jsonXMLflag=+$p(ExpStr,"^",2)
	i ($IsObject(InObj))||(jsonXMLflag>0) d
	.s Divstr=..ObjtoDivStr(InObj,ExpStr)	;对象或者XML或者JSON
	e  d
	.s Divstr=..BuildDivStr(InObj,ExpStr)	;拼串方式
	q Divstr
}

/// Creator:		ZhanMingchao
/// CreatDate    	20151104
/// Description：   UpdateINVPRTYBInfo
/// Table：       
/// Input：        	DivideStr:保存结算表的信息串
/// Output：      
/// Return：      	小于0不成功
/// ##class(web.DHCINSUPortUtil).UpdateINVPRTYBInfoByDivide(DivideStr,"")
ClassMethod UpdateINVPRTYBInfoByDivide(DivideStr, ExpStr) As %String
{
	q:$l(DivideStr,"^")<50 -1
	s DivID=$p(DivideStr,"^",1)
	s grzfe0=+$p(DivideStr,"^",16)
	s InsuPay10=+$p(DivideStr,"^",51)
	s InvPrtRowID=+$p(DivideStr,"^",5)
	s InsuPay1=+$p(DivideStr,"^",32)
	s zhzfe=+$p(DivideStr,"^",29)
	s paymodestr=##class(web.DHCINSUPort).GetPayModeDr()
	s BackString="0^"_DivID_"^"_(grzfe0+InsuPay10)_"^"_InvPrtRowID
	s BackString=BackString_$c(2)_$p(paymodestr,"^",2)_"^"_InsuPay1
	s BackString=BackString_$c(2)_$p(paymodestr,"^",3)_"^"_zhzfe
	;如果有其它支付方式就再增加
	q BackString
}

/// Creator:		ZhanMingchao
/// CreatDate    	20160622
/// Description：   BuildAdminfoRtnStr
/// Table：       
/// Input：        	adminfoRowid:adminfo表的rowid,DivideStr:保存结算表的信息串
/// Output：      
/// Return：      	小于0不成功
/// ##class(web.DHCINSUPortUtil).BuildAdminfoRtnStr(DivideStr,"")
ClassMethod BuildAdminfoRtnStr(adminfoRowid, DivStr, ExpStr) As %String
{
	q:$l(DivStr,"^")<50 -1
	q:adminfoRowid="" -1
	s grzfe0=+$p(DivStr,"^",16)
	s InsuPay10=+$p(DivStr,"^",51)
	s InvPrtRowID=+$p(DivStr,"^",5)
	s InsuPay1=+$p(DivStr,"^",32)
	s zhzfe=+$p(DivStr,"^",29)
	s paymodestr=##class(web.DHCINSUPort).GetPayModeDr()
	s BackString="0^"_adminfoRowid_"^"_(grzfe0+InsuPay10)_"^"_InvPrtRowID
	s BackString=BackString_$c(2)_$p(paymodestr,"^",2)_"^"_InsuPay1
	s BackString=BackString_$c(2)_$p(paymodestr,"^",3)_"^"_zhzfe
	;如果有其它支付方式就再增加
	q BackString
}

}
