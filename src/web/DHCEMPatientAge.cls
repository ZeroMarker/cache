Import SQLUser

Class web.DHCEMPatientAge Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Input:	Papmi:	Pa_PatMas.Papmi_RowId
/// 		Adm:	Pa_Adm.PAADM_RowId
/// 			ParamAdmDate:传入的出生日期，可不传
/// 			ParamAdmTime:传入的出生时间，可不传
/// 			ParamAdmDate,ParamAdmTime可不传入，如果不传入则按配置##class(web.UDHCJFAgeConfig).GetAgeConfig()走
/// 								如果传入，则不走配置##class(web.UDHCJFAgeConfig).GetAgeConfig()，以此日期和时间计算年龄
/// Output:	年龄显示字符串
/// Desc:	根据病人ID和就诊ID获取病人年龄
/// Debug:	w ##class(web.DobTime).GetPapmiAge(1)
ClassMethod GetPatAge(Papmi As %String, Adm As %String = "", ParamAdmDate As %String = "", ParamAdmTime As %String = "") As %String
{
	New (Papmi,Adm,ParamAdmDate,ParamAdmTime)
	Set ParamAdmDate=$g(ParamAdmDate)
	Set ParamAdmTime=$g(ParamAdmTime)
	Quit:Papmi="" "-1001"
	Quit:'$d(^PAPER(Papmi)) "-1001"

	;是否根据就诊时间算年龄
	//这个配置在Global^DHCIPBILL("JFAge",1)="N"
	Set isAdmFlag=..GetAgeConfig()   //乔庆澳
	Set controlFlag=""
	Set admDate=+$h,admTime=$p($h,",",2)
	
	If $d(^PAPER("DHC",Papmi,1)) {
		Set babybirstr=^PAPER("DHC",Papmi,1)
		Set birthDate=$p(babybirstr,"^",1)
		Set birthTime=$p(babybirstr,"^",2)
	} Else {
		Set babybirstr=$g(^PAPER(Papmi,"ALL"))
		Set birthDate=$p($g(^PAPER(Papmi,"ALL")),"^",6)
		Set birthTime=1
	
	}
	;防止虽然存在^PAPER("DHC",Papmi,1) 但是值为空的情况
	If birthDate="" {
		Set babybirstr=$g(^PAPER(Papmi,"ALL"))
		Set birthDate=$p($g(^PAPER(Papmi,"ALL")),"^",6)
		Set birthTime=0	
	}
	;如果配置成按就诊走，则取就诊时间
	If isAdmFlag="Y" {
		If (+Adm'=0) && ($d(^PAADM(Adm))) {
			Set admDate=$p(^PAADM(Adm),"^",6)
			Set admTime=$p(^PAADM(Adm),"^",7)
		}
	}
	;如果传入了日期和时间，则按传入的日期时间取年龄
	If ParamAdmDate'="" {
		Set controlFlag="Y" //传给web.UDHCJFCOMMON.DispPatAge方法，优先级最高
		Set:ParamAdmDate["-" ParamAdmDate=$zdh(ParamAdmDate,3)
		Set:ParamAdmTime[":" ParamAdmTime=$zth(ParamAdmTime)
		Set admDate=ParamAdmDate
		Set admTime=ParamAdmTime		
	}

	Set rtn=..DispPatAge(birthDate,admDate,birthTime,admTime,controlFlag)  //乔庆澳
	Set ageStr=$p(rtn,"||",1)
	
	Quit ageStr
}

/// Input:	birthDate:出生日期，admDate:就诊日期或当前日期
/// 			birthTime:出生时间，admTime:就诊时间或当前时间
/// 				controlFlag :此标志优先；此标志高于##class(web.UDHCJFAgeConfig).GetAgeConfig()配置
/// 							如果是Y，则不走这个配置##class(web.UDHCJFAgeConfig).GetAgeConfig()，走传入的日期和时间
/// 							其他走此配置##class(web.UDHCJFAgeConfig).GetAgeConfig()
/// Output:	日期字符串
/// Desc:	根据日期和时间获取年龄日期串 
/// 			此方法在住院登记和产品组接口时调用，修改请慎重:
/// 				1)web.UDHCJFIPReg.cls 2)UDHCJFIPReg.js
/// 				1)web.DHCBillInterface.cls
/// Debug:	w ##class(web.UDHCJFCOMMON).DispPatAge("2014-02-01","2014-03-01","","")	
ClassMethod DispPatAge(birthDate, admDate, birthTime, admTime, controlFlag As %String = "") As %String
{
	New (birthDate,admDate,birthTime,admTime,controlFlag)
	Set controlFlag=$g(controlFlag)
	//这里调配置，是因为住院登记时单调了这个方法
	Set isAdmFlag=..GetAgeConfig() //空的   //OK
	If (isAdmFlag'="Y")&(controlFlag'="Y") {
		Set admDate=+$h
		Set admTime=$p($h,",",2)	
	}
	;calInFlag：是否算满
	;如 1年零一天，显示2年还是1年，1：2年；0:1年
	Set calInFlag=0
	Set birthDate=$g(birthDate),admDate=$g(admDate)
	Set birthTime=$g(birthTime),admTime=$g(admTime)
	
	If birthDate["-" Set birthDate=$zdh(birthDate,3)
	If admDate["-" Set admDate=$zdh(admDate,3)
	If birthTime[":" Set birthTime=$zth(birthTime)
	If admTime[":" Set admTime=$zth(admTime)
	Set yearDr=$o(^DHCJFUOMSET(0,"Code","Y",""))
	Set monthDr=$o(^DHCJFUOMSET(0,"Code","M",""))
	Set dayDr=$o(^DHCJFUOMSET(0,"Code","D",""))
	Set hourDr=$o(^DHCJFUOMSET(0,"Code","H",""))
	Set ageRtn=..CalAgeNew(birthDate,admDate,birthTime,admTime)   //OK 
	
	Set jacRowId="0",flag=0
	For {	Set jacRowId=$o(^DHCJFAGECONFIG(jacRowId)) Quit:(jacRowId="")
		Set jacStVal=$p(^DHCJFAGECONFIG(jacRowId),"^",2)
		Set jacEndVal=$p(^DHCJFAGECONFIG(jacRowId),"^",5)
		Set jacStUom=$p(^DHCJFAGECONFIG(jacRowId),"^",3)
		Set jacEndUom=$p(^DHCJFAGECONFIG(jacRowId),"^",6)
		Set stUomCode=$p(^DHCJFUOMSET(jacStUom),"^",1)
		Set endUomCode=$p(^DHCJFUOMSET(jacEndUom),"^",1)
		Set jacDispUom=$p(^DHCJFAGECONFIG(jacRowId),"^",7)
		Set dispCode=$p(^DHCJFUOMSET(jacDispUom),"^",1)     /////ssssss
		Set flag=..checkRangeIn(ageRtn,birthDate, admDate,birthTime,admTime,jacStVal,jacEndVal,stUomCode,endUomCode,calInFlag)   //OK

		Quit:flag=1
	}
	If (flag=1) {
		Set jacDispUom=$p(^DHCJFAGECONFIG(jacRowId),"^",7)
		Set dispCode=$p(^DHCJFUOMSET(jacDispUom),"^",1)
		Set rtn=..dispAge(ageRtn,birthDate,admDate,birthTime,admTime,dispCode,calInFlag)  //OK
		Set desc=$p(rtn,"||",1)
		Set len=$l(rtn,"||")
		Set other=$p(rtn,"||",2,len)
	} Else {
		Set tmpY=$p(ageRtn,"^",1)
		Set tmpM=$p(ageRtn,"^",2)
		Set tmpD=$p(ageRtn,"^",3)
		Set tmpH=$p(ageRtn,"^",4)
		Set tmpMin=$p(ageRtn,"^",5)
		Set tmpS=$p(ageRtn,"^",6)
		If (calInFlag=1) {
			If ((tmpM'=0)||(tmpD'=0)||(tmpH'=0)||(tmpMin'=0)||(tmpS'=0)) {
				Set tmpY=tmpY+1
			}	
		}
		Set desc=tmpY_"岁"
		Set other=tmpY_"||"_""_"||"_""_"||"_""_"||"_""_"||"_""
	}
	
	Set tmpY=$p(ageRtn,"^",1)
	Set tmpM=$p(ageRtn,"^",2)
	Set tmpD=$p(ageRtn,"^",3)
	Set tmpH=$p(ageRtn,"^",4)
	Set tmpMin=$p(ageRtn,"^",5)
	Set tmpS=$p(ageRtn,"^",6)
	
	Set rtn=desc_"||"_tmpY_"||"_tmpM_"||"_tmpD_"||"_tmpH_"||"_tmpMin_"||"_tmpS
	Set rtn=rtn_"||"_other
	Quit rtn
}

/// Input:	IBirth:出生日期，IToday:当前日期或就诊日期
/// 				birthTime:出生时间，admTime:当前时间或就诊时间
/// Output:	reage:包含年月日时分秒的字符串	
/// Desc:	计算年龄，返回包含年月日时分秒的字符串
/// Debug:	w ##class(web.UDHCJFCOMMON).CalAgeNew("63223","63247","25201","25200")
ClassMethod CalAgeNew(IBirth As %String, IToday As %String, birthTime, admTime)
{
   	n (IBirth,IToday,birthTime,admTime)
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    s (AgeSec,AgeMin,AgeHour)=0
    i (birthTime'="")&&(admTime'="") d
	.s XbirthTime=$zt(birthTime)
	.s XadmTime=$zt(admTime)
	.s AgeHour=$p(XadmTime,":",1)-$p(XbirthTime,":",1)
	.s AgeMin=$p(XadmTime,":",2)-$p(XbirthTime,":",2)
	.s AgeSec=$p(XadmTime,":",3)-$p(XbirthTime,":",3)
	.i AgeSec<0 d
	..s AgeSec=AgeSec+60,AgeMin=AgeMin-1
	.i AgeMin<0 d
	..s AgeMin=AgeMin+60,AgeHour=AgeHour-1
	.i AgeHour<0 d
	..s AgeHour=AgeHour+24,AgeDay=AgeDay-1
	
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear

	
	s reage=$p(AgeYr,"|",12)_"^"_AgeMth_"^"_AgeDay_"^"_AgeHour_"^"_AgeMin_"^"_AgeSec
	q reage
}

/// Input:	ageStr, birthDate, admDate,birthTime,admTime, stVal, endVal, stCode, endCode,calInFlag
/// 			ageStr:为web.UDHCJFCOMMON.cls里CalAgeNew的返回值，格式为年^月^日^时^分^秒
/// 			birthDate, admDate,birthTime,admTime 出生日期时间、当前（就诊）的日期时间
/// 			stVal stCode：配置区间的开始值和开始单位 enVal endCode: 配置区间的结束值和结束单位
/// 			calInFlag:是否算满 1：表示算满 0：否 例：1年1分 ：在为1 的情况下为2年，0的情况为1年
/// OutPut:	0/1 1:表示在配置的区间内 0：表示不在	
/// Desc；	判断是否在配置的区间内 在web.UDHCJFCOMMON.cls里调用
ClassMethod checkRangeIn(ageStr, birthDate, admDate, birthTime, admTime, stVal, endVal, stCode, endCode, calInFlag As %String = "") As %String
{
	new (ageStr,birthDate, admDate,birthTime,admTime,stVal,endVal,stCode,endCode,calInFlag)
	Set stCode=$$ALPHAUP^SSUTIL4(stCode)
	Set endCode=$$ALPHAUP^SSUTIL4(endCode)
	
	If admDate["-" Set admDate=$zdh(admDate,3)
	If birthDate["-" Set birthDate=$zdh(birthDate,3)
	If birthTime[":" Set birthTime=$zth(birthTime)
	If admTime[":" Set admTime=$zth(admTime)
	If calInFlag="" Set calInFlag=0
	
	Set rangeDay=admDate-birthDate
	If (admTime'="")&&(birthTime'="")&&(+admTime<+birthTime) {
		Set rangeDay=rangeDay-1	
	}
	
	Set ageY=+$p(ageStr,"^",1)
	Set ageM=+$p(ageStr,"^",2)
	Set ageD=+$p(ageStr,"^",3)
	Set ageH=+$p(ageStr,"^",4)
	Set ageMin=+$p(ageStr,"^",5)
	Set ageS=+$p(ageStr,"^",6)
	
	Set rtn=0,addFlag=0
	If (stCode="Y") {
		If (ageY>=stVal) {
			Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"Y",calInFlag) 
			Set ageY=$p(val,"^",1)
			Set addFlag=$p(val,"^",2)
			
			If ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
				Set rtn=1	
			}
		}
		If (ageY=stVal) {
			If ((ageM=0)&&(ageD=0)&&(ageH=0)&&(ageMin=0)&&(ageS=0)) {
				Set rtn=1
			}	
		}
		
	} ElseIf (stCode="M") {
		Set month=ageM+(ageY*12)
		If (month>=stVal) {
			If (endCode="M") {
				Set val=..getActualCal(ageY,month,ageD,ageH,ageMin,ageS,endCode,calInFlag) 
				Set month=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((month<endVal)||((month=endVal)&&(addFlag=1))) {
					Set rtn=1
				}	
			}
			If (endCode="Y") {
				Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,endCode,calInFlag) 
				Set ageY=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
					Set rtn=1
				}
			}
		}
		If (month=stVal) {
			If ((ageD=0)&&(ageH=0)&&(ageMin=0)&&(ageS=0)) {
				Set rtn=1
			}
			If 
		}
		
	} ElseIf (stCode="D") {
		If (rangeDay>=stVal) {
			If (endCode="D") {
				Set val=..getActualCal(ageY,ageM,rangeDay,ageH,ageMin,ageS,endCode,calInFlag) 
				Set rangeDay=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				If ((rangeDay<endVal)||((rangeDay=endVal)&&(addFlag=1))) {
					Set rtn=1
				}	
			}
			If (endCode="M") {
				Set month=ageM+(ageY*12)
				Set val=..getActualCal(ageY,month,ageD,ageH,ageMin,ageS,endCode,calInFlag) 
				Set month=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((month<endVal)||((month=endVal)&&(addFlag=1))) {
					Set rtn=1
				}
			}
			If (endCode="Y") {
				Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,endCode,calInFlag) 
				Set ageY=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
					Set rtn=1
				}
			}
		}
		If (rangeDay=stVal) {
			If ((ageH=0)&&(ageMin=0)&&(ageS=0)) {
				Set rtn=1
			}
		}
	} ElseIf (stCode="H") {
		Set hour=(rangeDay*24)+ageH
		If (hour>=stVal) {
			If (endCode="H") {
				Set val=..getActualCal(ageY,ageM,ageD,hour,ageMin,ageS,endCode,calInFlag) 
				Set hour=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((hour<endVal)||((hour=endVal)&&(addFlag=1))) {
					Set rtn=1	
				}
			}
			If (endCode="D"){
				Set val=..getActualCal(ageY,ageM,rangeDay,ageH,ageMin,ageS,endCode,calInFlag) 
				Set rangeDay=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((rangeDay<endVal)||((rangeDay=endVal)&&(addFlag=1))) {
					Set rtn=1
				}
			}
			If (endCode="M") {
				Set month=ageM+(ageY*12)
				Set val=..getActualCal(ageY,month,ageD,ageH,ageMin,ageS,endCode,calInFlag) 
				Set month=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((month<endVal)||((month=endVal)&&(addFlag=1))) {
					Set rtn=1
				}	
			}
			If (endCode="Y") {
				Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,endCode,calInFlag) 
				Set ageY=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
					Set rtn=1
				}	
			}
		}
		If (hour=stVal) {
			If ((ageMin=0)&&(ageS=0)) {
				Set rtn=1
			}
		}
	} ElseIf (stCode="MIN") {
		Set min=((rangeDay*24)+ageH)*60+ageMin
		If (min>=stVal) {
			If (endCode="MIN") {
				Set val=..getActualCal(ageY,ageM,ageD,ageH,min,ageS,endCode,calInFlag) 
				Set min=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((min<endVal)||((min=endVal)&&(addFlag=1))) {
					Set rtn=1	
				}
			}
			If (endCode="H") {
				Set hour=(rangeDay*24)+ageH
				Set val=..getActualCal(ageY,ageM,ageD,hour,ageMin,ageS,endCode,calInFlag) 
				Set hour=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((hour<endVal)||((hour=endVal)&&(addFlag=1))) {
					Set rtn=1	
				}
			}
			If (endCode="D"){
				Set val=..getActualCal(ageY,ageM,rangeDay,ageH,ageMin,ageS,endCode,calInFlag) 
				Set rangeDay=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((rangeDay<endVal)||((rangeDay=endVal)&&(addFlag=1))) {
					Set rtn=1
				}	
			}
			If (endCode="M") {
				Set month=ageM+(ageY*12)
				Set val=..getActualCal(ageY,month,ageD,ageH,ageMin,ageS,endCode,calInFlag) 
				Set month=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((month<endVal)||((month=endVal)&&(addFlag=1))) {
					Set rtn=1
				}
			}
			If (endCode="Y") {
				Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,endCode,calInFlag) 
				Set ageY=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
					Set rtn=1
				}
			}
		}
		If (min=stVal) {
			If (ageS=0) {
				Set rtn=1	
			}
		}
	} ElseIf (stCode="S") {
		Set sec=((rangeDay*24)+ageH)*60*60+(ageMin*60)+ageS
		If (sec>=stVal) {
			If (endCode="S") {
				If (sec<endVal) {
					Set rtn=1	
				}	
			}
			If (endCode="MIN") {
				Set min=((rangeDay*24)+ageH)*60+ageMin
				Set val=..getActualCal(ageY,ageM,ageD,ageH,min,ageS,endCode,calInFlag) 
				Set min=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((min<endVal)||((min=endVal)&&(addFlag=1))) {
					Set rtn=1	
				}
			}
			If (endCode="H") {
				Set hour=(rangeDay*24)+ageH
				Set val=..getActualCal(ageY,ageM,ageD,hour,ageMin,ageS,endCode,calInFlag) 
				Set hour=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((hour<endVal)||((hour=endVal)&&(addFlag=1))) {
					Set rtn=1	
				}
			}
			If (endCode="D"){
				Set val=..getActualCal(ageY,ageM,rangeDay,ageH,ageMin,ageS,endCode,calInFlag) 
				Set rangeDay=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((rangeDay<endVal)||((rangeDay=endVal)&&(addFlag=1))) {
					Set rtn=1
				}	
			}
			If (endCode="M") {
				Set month=ageM+(ageY*12)
				Set val=..getActualCal(ageY,month,ageD,ageH,ageMin,ageS,endCode,calInFlag) 
				Set month=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((month<endVal)||((month=endVal)&&(addFlag=1))) {
					Set rtn=1
				}
			}
			If (endCode="Y") {
				Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,endCode,calInFlag) 
				Set ageY=$p(val,"^",1)
				Set addFlag=$p(val,"^",2)
				
				If ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
					Set rtn=1
				}
			}
		}
	}
	
	Quit rtn
}

ClassMethod getActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, code, calInFlag)
{
	New (ageY,ageM,ageD,ageH,ageMin,ageS,code,calInFlag)
	Set code=$$ALPHAUP^SSUTIL4(code)
	Set increaseFlag=0 //加1标志
	
	If code="Y" {
		If ((ageM'=0)||(ageD'=0)||(ageH'=0)||(ageMin'=0)||(ageS'=0))&&(calInFlag=1) {
			Set ageY=ageY+1
			Set increaseFlag=1
		}
		Set rtn=ageY_"^"_increaseFlag
	} ElseIf code="M" {
		If ((ageD'=0)||(ageH'=0)||(ageMin'=0)||(ageS'=0))&&(calInFlag=1) {
			Set ageM=ageM+1	
			Set increaseFlag=1
		}	
		Set rtn=ageM_"^"_increaseFlag
	} ElseIf code="D" {
		If ((ageH'=0)||(ageMin'=0)||(ageS'=0))&&(calInFlag=1) {
			Set ageD=ageD+1
			Set increaseFlag=1
		}
		Set rtn=ageD_"^"_increaseFlag
	} ElseIf code="H" {
		If ((ageMin'=0)||(ageS'=0))&&(calInFlag=1) {
			Set ageH=ageH+1
			Set increaseFlag=1
		}
		Set rtn=ageH_"^"_increaseFlag
	} ElseIf code="MIN" {
		If (ageS'=0)&&(calInFlag=1) {
			Set ageMin=ageMin+1	
			Set increaseFlag=1
		}
		Set rtn=ageMin_"^"_increaseFlag
	} ElseIf code="S" {
		Set ageS=ageS
		Set rtn=ageS_"^"_increaseFlag
	} Else {
		If ((ageM'=0)||(ageD'=0)||(ageH'=0)||(ageMin'=0)||(ageS'=0))&&(calInFlag=1) {
			Set ageY=ageY+1
			Set increaseFlag=1
		}
		Set rtn=ageY_"^"_increaseFlag
	}
	
	Quit rtn
}

/// Input:	ageStr, birthDate, admDate,birthTime,admTime, stVal, endVal, stCode, endCode,calInFlag
/// 			ageStr:为web.UDHCJFCOMMON.cls里CalAgeNew的返回值，格式为年^月^日^时^分^秒
/// 			birthDate, admDate,birthTime,admTime 出生日期时间、当前（就诊）的日期时间
/// 			stVal stCode：配置区间的开始值和开始单位 enVal endCode: 配置区间的结束值和结束单位
/// 			calInFlag:是否算满 1：表示算满 0：否 例：1年1分 ：在为1 的情况下为2年，0的情况为1年
/// OutPut:	显示的年龄串，格式为 "显示的年龄串||年||月||日||时||分||秒" 
/// 			例：如果配置为"时分",如果计算的实际年龄串ageStr="0^0^1^11^2^4" 
/// 				则调用该方法返回"35小时2分"_"||"_""_"||"_""_"||"_""_"||"_"35"_"||"_"2"_"||"_""
/// 				calInFlag=1时返回"35小时3分"_"||"_""_"||"_""_"||"_""_"||"_"35"_"||"_"3"_"||"_""
/// Desc；	按配置显示年龄 在web.UDHCJFCOMMON.cls里调用
ClassMethod dispAge(ageStr, birthDate, admDate, birthTime, admTime, dispCode, calInFlag) As %String
{
	New (ageStr,birthDate,admDate,birthTime,admTime,dispCode,calInFlag)
	Set dispCode=$$ALPHAUP^SSUTIL4(dispCode)

	If admDate["-" Set admDate=$zdh(admDate,3)
	If birthDate["-" Set birthDate=$zdh(birthDate,3)
	If birthTime[":" Set birthTime=$zth(birthTime)
	If admTime[":" Set admTime=$zth(admTime)
	
	Set rangeDay=admDate-birthDate
	If (admTime'="")&&(birthTime'="")&&(+admTime<+birthTime) {
		Set rangeDay=rangeDay-1	
	}
	
	Set ageY=+$p(ageStr,"^",1)
	Set ageM=+$p(ageStr,"^",2)
	Set ageD=+$p(ageStr,"^",3)
	Set ageH=+$p(ageStr,"^",4)
	Set ageMin=+$p(ageStr,"^",5)
	Set ageS=+$p(ageStr,"^",6)
	
	If (dispCode="Y") {
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"Y",calInFlag) 
		Set ageY=$p(val,"^",1)
		Set (ageM,ageD,ageH,ageMin,ageS)=""
		
		Set rtn=ageY_"岁"
	} ElseIf (dispCode="YMD") {
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"D",calInFlag) 
		Set ageD=$p(val,"^",1)
		Set (ageH,ageMin,ageS)=""
		
		Set rtn=ageY_"岁"_ageM_"月"_ageD_"天"
	} ElseIf (dispCode="YM") {
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"M",calInFlag) 
		Set ageM=$p(val,"^",1)
		Set (ageD,ageH,ageMin,ageS)=""
		
		Set rtn=ageY_"岁"_ageM_"月"
	} ElseIf (dispCode="M") {
		Set ageM=(ageY*12)+ageM
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"M",calInFlag) 
		Set ageM=$p(val,"^",1)
		Set (ageY,ageD,ageH,ageMin,ageS)=""
		
		Set rtn=ageM_"月"
	} ElseIf (dispCode="MDH") {
		Set ageM=(ageY*12)+ageM
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"H",calInFlag) 
		Set ageH=$p(val,"^",1)
		Set (ageY,ageMin,ageS)=""
		
		Set rtn=ageM_"月"_ageD_"天"_ageH_"小时"
	} ElseIf (dispCode="MD") {
		Set ageM=(ageY*12)+ageM
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"D",calInFlag) 
		Set ageD=$p(val,"^",1)
		Set (ageY,ageH,ageMin,ageS)=""
		
		Set rtn=ageM_"月"_ageD_"天"
	} ElseIf (dispCode="D") {
		Set ageD=rangeDay
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"D",calInFlag) 
		Set ageD=$p(val,"^",1)
		Set (ageY,ageM,ageH,ageMin,ageS)=""
		
		Set rtn=ageD_"天"
	} ElseIf (dispCode="DHM") {
		Set ageD=rangeDay
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"MIN",calInFlag) 
		Set ageMin=$p(val,"^",1)
		Set (ageY,ageM,ageS)=""
		
		Set rtn=ageD_"天"_ageH_"小时"_ageMin_"分"
	} ElseIf (dispCode="DH") {
		Set ageD=rangeDay
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"H",calInFlag) 
		Set ageH=$p(val,"^",1)
		Set (ageY,ageM,ageMin,ageS)=""
		
		Set rtn=ageD_"天"_ageH_"小时"
	} ElseIf (dispCode="H") {
		Set ageH=(rangeDay*24)+ageH
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"H",calInFlag) 
		Set ageH=$p(val,"^",1)
		Set (ageY,ageM,ageD,ageMin,ageS)=""
		
		Set rtn=ageH_"小时"
	} ElseIf (dispCode="HM") {
		Set ageH=(rangeDay*24)+ageH
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"MIN",calInFlag) 
		Set ageMin=$p(val,"^",1)
		Set (ageY,ageM,ageD,ageS)=""
		
		Set rtn=ageH_"小时"_ageMin_"分"
	} ElseIf (dispCode="MIN") {
		Set ageMin=(rangeDay*24)*60+(ageH*60)+ageMin
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"MIN",calInFlag) 
		Set ageMin=$p(val,"^",1)
		Set (ageY,ageM,ageD,ageS,ageH)=""
		
		Set rtn=ageMin_"分"
	} Else {
		Set val=..getActualCal(ageY,ageM,ageD,ageH,ageMin,ageS,"Y",calInFlag) 
		Set ageY=$p(val,"^",1)
		Set (ageM,ageD,ageH,ageMin,ageS)=""
		
		Set rtn=ageY_"年"
	}
	
	Set rtn=rtn_"||"_ageY_"||"_ageM_"||"_ageD_"||"_ageH_"||"_ageMin_"||"_ageS
	Quit rtn
}

/// Output:	Y/N ：Y为按就诊时间计算年龄
/// Desc:	年龄配置是走就诊时间还是走实时时间
/// Debug:	w ##class(web.UDHCJFAgeConfig).GetAgeConfig()
ClassMethod GetAgeConfig()
{
	Quit $g(^DHCIPBILL("JFAge",1))
}

}
