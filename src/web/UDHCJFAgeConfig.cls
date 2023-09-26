Import SQLUser

Class web.UDHCJFAgeConfig Extends BILL.COM.Abstract
{

/// ">=^0^8,<^12^8,8,1"
/// Debug: w ##class(web.DHCJFAgeConfig).INSERT(">=^0^8","<^1^9","8",1)
ClassMethod INSERT(stValStr As %String, endValStr As %String, dispStr As %String, guser As %String, hospId As %String) As %String
{
	set $zt="ERROR"
	
	set stOper=$p(stValStr,"^",1)
	set stVal=$p(stValStr,"^",2)
	set stUomDr=$p(stValStr,"^",3)
	set endOper=$p(endValStr,"^",1)
	set endVal=$p(endValStr,"^",2)
	set endUomDr=$p(endValStr,"^",3)
	set disUomDr=dispStr
	if (stOper="") set stOper=">="
	if (endOper="") set endOper="<"
	//判断值的正确性
	set rtn=..Judge(stValStr, endValStr)
	if (+rtn) quit rtn

	set stUomCode=$p(^DHCJFUOMSET(stUomDr),"^",1)
	set endUomCode=$p(^DHCJFUOMSET(endUomDr),"^",1)
	set stConvSec=..GetSecFromUom(stVal, stUomCode)
	set endConvSec=..GetSecFromUom(endVal, endUomCode)
	if ((stConvSec="-1")||(endConvSec="-1")) {
		quit -101
	}
	//判断值的连续性
	set lastRowId=..GetLastRowId(hospId)
	if (lastRowId'="") {
		set jacEndVal=$p(^DHCJFAGECONFIG(lastRowId),"^",5)
		set jacEndUom=$p(^DHCJFAGECONFIG(lastRowId),"^",6)
		set jacNote1=$p(^DHCJFAGECONFIG(lastRowId),"^",15)
		if (+stConvSec'=+jacNote1) {
			set stVal=jacEndVal
			set stUomDr=jacEndUom
		}
	}
	
	ts
	
	&SQL(
		INSERT INTO DHC_JFAgeConfig (
			JAC_StartOperator, JAC_StartVal, JAC_StartUom, JAC_EndOperator, JAC_EndVal,
			JAC_EndUom, JAC_ActiveFlag, JAC_DisPlayUom, JAC_AddUser_Dr, JAC_Note1,
			JAC_Note2, JAC_Hosp_Dr
		)
		VALUES (
			:stOper, :stVal, :stUomDr, :endOper, :endVal,
			:endUomDr, 'Y', :disUomDr, :guser, :stConvSec,
			:endConvSec, :hospId
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

ClassMethod DeleteConfig(stValStr As %String, endValStr As %String, dispStr As %String, rowId As %String, guser As %String, hospId As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=..Judge(stValStr, endValStr)
	if (+rtn) quit rtn  //判断
	
	set stOper=$p(stValStr,"^",1)
	set stVal=$p(stValStr,"^",2)
	set stUomDr=$p(stValStr,"^",3)
	set endOper=$p(endValStr,"^",1)
	set endVal=$p(endValStr,"^",2)
	set endUomDr=$p(endValStr,"^",3)
	set disUomDr=dispStr
	quit:'$d(^DHCJFAGECONFIG(rowId)) -501
	
	set prevRowId=..GetPrevRowId(rowId, hospId)    //上一个配置Id
	set nextRowId=..GetNextRowId(rowId, hospId)    //下一个配置Id
	
	ts
	
	&SQL(DELETE FROM DHC_JFAgeConfig WHERE %ID = :rowId)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)

	set lastUomDr=$o(^DHCJFUOMSET(0,"Code","Y",""))
	set lastVal=0, stConvSec=0
	if (+prevRowId'=0) {
		set lastVal=$p(^DHCJFAGECONFIG(prevRowId),"^",5)
		set lastUomDr=$p(^DHCJFAGECONFIG(prevRowId),"^",6)
		set lastCode=$s((+lastUomDr'=0):$p($g(^DHCJFUOMSET(lastUomDr)),"^",1),1:"")
		set stConvSec=$p(^DHCJFAGECONFIG(prevRowId),"^",14)
		if (+stConvSec=-1) {
			set stConvSec=..GetSecFromUom(lastVal, lastCode)
		}
	}
	if (nextRowId>0) {
		&SQL(
			UPDATE DHC_JFAgeConfig
			SET JAC_StartVal = :lastVal, JAC_StartUom = :lastUomDr, JAC_UpdateUser_Dr = :guser,
				JAC_UpdateDate = CONVERT(DATE, NOW()), JAC_UpdateTime = CONVERT(TIME, NOW()),JAC_Note1 = :stConvSec
			WHERE %ID = :nextRowId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Debug: w ##class(web.UDHCJFAgeConfig).UpdateConfig(">=^0^8", "<^2^9", "8", 1, 1, 2)
ClassMethod UpdateConfig(stValStr As %String, endValStr As %String, dispStr As %String, rowId As %String, guser As %String, hospId As %String)
{
	set $zt="ERROR"
	
	quit:'$d(^DHCJFAGECONFIG(rowId)) -501
	set rtn=..Judge(stValStr, endValStr)
	if (+rtn) quit rtn  //判断
	
	set stOper=$p(stValStr,"^",1)
	set stVal=$p(stValStr,"^",2)
	set stUomDr=$p(stValStr,"^",3)
	set endOper=$p(endValStr,"^",1)
	set endVal=$p(endValStr,"^",2)
	set endUomDr=$p(endValStr,"^",3)
	set disUomDr=dispStr
	
	set stUomCode=$p(^DHCJFUOMSET(stUomDr),"^",1)
	set endUomCode=$p(^DHCJFUOMSET(endUomDr),"^",1)
	set stConvSec=..GetSecFromUom(stVal, stUomCode)
	set endConvSec=..GetSecFromUom(endVal, endUomCode)
	if (stConvSec="-1")||(endConvSec="-1") {
		quit -101
	}
	set nextRowId=..GetNextRowId(rowId, hospId)
	if (nextRowId'="") {
		set nextEndVal=$p(^DHCJFAGECONFIG(nextRowId),"^",5)
		set nextEndUom=$p(^DHCJFAGECONFIG(nextRowId),"^",6)
		set nextEndCode=$s((+nextEndUom'=0):$p(^DHCJFUOMSET(nextEndUom),"^",1),1:"")
		set nextNote2=$p(^DHCJFAGECONFIG(nextRowId),"^",15)
		if (nextNote2="-1") {
			set nextNote2=..GetSecFromUom(nextEndVal, nextEndUom)
		}
		if (nextNote2="-1") {
			quit -101
		}
		if (+endConvSec>=+nextNote2) {
			quit -102
		}
	}
	
	ts

	&SQL(
		UPDATE DHC_JFAgeConfig
		SET JAC_EndVal = :endVal, JAC_EndUom = :endUomDr, JAC_DisPlayUom = :disUomDr, JAC_UpdateUser_Dr = :guser,
			JAC_UpdateDate = CONVERT(DATE, NOW()), JAC_UpdateTime = CONVERT(TIME, NOW()), JAC_Note2 = :endConvSec
		WHERE %ID = :rowId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	set nextRowId=..GetNextRowId(rowId, hospId)
	if (nextRowId>0) {
		&SQL(
			UPDATE DHC_JFAgeConfig
			SET JAC_StartVal = :endVal, JAC_StartUom = :endUomDr, JAC_UpdateUser_Dr = :guser,
				JAC_UpdateDate = CONVERT(DATE, NOW()), JAC_UpdateTime = CONVERT(TIME, NOW()),JAC_Note1 = :endConvSec
			WHERE %ID = :nextRowId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// add hu
/// Description: 判读值的大小比较
/// Debug: w ##class(web.UDHCJFAgeConfig).Judge(">=^156^5","<^300^6")
ClassMethod Judge(stValStr, endValStr)
{
	set ^TMP("Judge")=$lb(stValStr, endValStr)
	set stOper=$p(stValStr,"^",1)
	set stVal=$p(stValStr,"^",2)
	set stUomDr=$p(stValStr,"^",3)
	set endOper=$p(endValStr,"^",1)
	set endVal=$p(endValStr,"^",2)
	set endUomDr=$p(endValStr,"^",3)
	
	if ('$d(^DHCJFUOMSET(stUomDr))) quit -100
	if ('$d(^DHCJFUOMSET(endUomDr))) quit -100  //不存在该单位
	if ('$d(^DHCJFUOMSET(endUomDr))) quit -100
	set stUomCode=$p(^DHCJFUOMSET(stUomDr),"^",1)
	set endUomCode=$p(^DHCJFUOMSET(endUomDr),"^",1)
	if (endVal>365) {
		quit -104
	}
	if (endUomCode="D")&&(endVal>28) {
		quit -104  //默认天数不能超过28天,涉及到月份的天数问题
	}
	if (endUomCode="H")&&(endVal>(24*28)) {
		quit -104
	}
	if (endUomCode="Min")&&(endVal>(60*24*28)) {
		quit -104
	}
	set stConvSec=..GetSecFromUom(stVal, stUomCode)
	set endConvSec=..GetSecFromUom(endVal, endUomCode)
	if ((stConvSec=-1)||(endConvSec=-1)) {
		quit -101
	}
	if (+stConvSec>=+endConvSec) {
		quit -102
	}
	if ((stOper'=">=")||(endOper'="<")) {
		quit -103
	}
	
	quit 0
}

/// Creator: hujunbin
/// CreatDate: 2014-04-22
/// Description: 从分、时、天等转换成秒S
/// Input: value:要转换的值	code:要转换的单位
/// Return: rtn:转换成的值	如果为-1则表示不存在要转换的单位
/// Debug: w ##class(web.DHCJFAgeConfig).GetSecFromUom(1,"Y")
ClassMethod GetSecFromUom(value, code) As %String
{
	set tmpYearConv=365*24*60*60
	set tmpMonthConv=30*24*60*60
	set tmpDayConv=24*60*60
	set tmpHourConv=60*60
	set tmpMinConv=60
	set code=$$ALPHAUP^SSUTIL4(code)
	if (" Y YEAR "[(" "_code_" ")) {
		set rtn=value*tmpYearConv
	} elseif (" M MON MONTH "[(" "_code_" ")) {
		set rtn=value*tmpMonthConv
	} elseif (" D DAY "[(" "_code_" ")) {
		set rtn=value*tmpDayConv
	} elseif (" H HOUR "[(" "_code_" ")) {
		set rtn=value*tmpHourConv
	} elseif (" MIN MINUTE "[(" "_code_" ")) {
		set rtn=value*tmpMinConv
	} else {
		set rtn=-1
	}
	
	quit rtn
}

/// Creator: hujunbin
/// CreatDate: 2014-04-22
/// Description: 从秒转换成其他单位的值
/// Input: value:要转换的值 code:要转换的单位
/// Return:	rtn:转换的值 -1表示不存在要转换的单位
/// Debug:	w ##class(web.DHCJFAgeConfig).GetUomFromSec(1,"Y")
ClassMethod GetUomFromSec(value, code)
{
	set tmpYearConv=365*24*60*60
	set tmpMonthConv=30*24*60*60
	set tmpDayConv=24*60*60
	set tmpHourConv=60*60
	set tmpMinConv=60
	set (rtnY,rtnMon,rtnD,rtnH,rtnMin)=0
	set code=$$ALPHAUP^SSUTIL4(code)
	if ((code="Y")||(code="YEAR")) {
		set rtnY=value\tmpYearConv
		set rtn=rtnY_"岁"
	} elseif (code="YM") {
		set rtnY=value\tmpYearConv
		set rtnMon=(value-(rtnY*tmpYearConv))\tmpMonthConv
		set rtn=rtnY_"岁"_rtnMon_"月"
	} elseif ((code="M")||(code="MONTH")) {
		set rtnMon=value\tmpMonthConv
		set rtn=rtnMon_"月"
	} elseif (code="MD") {
		set rtnMon=value\tmpMonthConv
		set rtnD=(value-(rtnMon*tmpMonthConv))\tmpDayConv
		set rtn=rtnMon_"月"_rtnD_"天"
	} elseif ((code="D")||(code="DAY")) {
		set rtnD=value\tmpDayConv
		set rtn=rtnD_"天"
	} elseif (code="DH") {
		set rtnD=value\tmpDayConv
		set rtnH=(value-(rtnD*tmpDayConv))\tmpHourConv
		set rtn=rtnD_"天"_rtnH_"小时"
	} elseif ((code="H")||(code="HOUR")) {
		set rtnH=value\tmpHourConv
		set rtn=rtnH_"小时"
	} elseif (code="DHM") {
		set rtnD=value\tmpDayConv
		set rtnH=(value-(rtnD*tmpDayConv))\tmpHourConv
		set rtnMin=(value-(rtnD*tmpDayConv)-(rtnH*tmpHourConv))\tmpMinConv
		set rtn=rtnD_"天"_rtnH_"小时"_rtnMin_"分"
	} elseif (code="HM") {
		set rtnH=value\tmpHourConv
		set rtnMin=(value-(rtnH*tmpHourConv))\tmpMinConv
		set rtn=rtnH_"小时"_rtnMin_"分"
	} elseif ((code="MIN")||(code="MINUTE")) {
		set rtnMin=value\tmpMinConv
		set rtn=rtnMin_"分"
	} else {
		set rtnY=value\tmpYearConv
		set rtn=rtnY_"岁"
	}
	
	quit rtn_"^"_rtnY_"^"_rtnMon_"^"_rtnD_"^"_rtnH_"^"_rtnMin
}

/// add hu 2014-04-01
/// Debug: w ##class(web.UDHCJFAgeConfig).GetLastValStr(2)
ClassMethod GetLastValStr(hospId As %String) As %String
{
	set stVal="", stUomDr="", stUomDesc=""
	set lastRowId=..GetLastRowId(hospId)
	if (lastRowId="") {
		set myStUomDr=0
		while ($o(^DHCJFUOMSET(0,"Code","MIN",myStUomDr))&&(stUomDr="")) {
			set myStUomDr=$o(^DHCJFUOMSET(0,"Code","MIN",myStUomDr))
			set uomData=$g(^DHCJFUOMSET(myStUomDr))
			continue:(uomData="")
			set isActive=$p(uomData,"^",3)
			continue:(isActive'="Y")
			set stUomDr=myStUomDr
			set uomDesc=$p(uomData,"^",2)
		}
		if (stUomDr="") {
			set rtn="-1^^^"    //没有配置小时的单位
		} else {
			set stVal=0
			set stUomDr=stUomDr
			set stUomDesc=uomDesc
			set rtn=0_"^"_stVal_"^"_stUomDr_"^"_stUomDesc
		}
	} else {
		set stVal=$p($g(^DHCJFAGECONFIG(lastRowId)),"^",5)
		set stUomDr=$p($g(^DHCJFAGECONFIG(lastRowId)),"^",6)
		set stUomDesc=$s((+stUomDr'=0):$p($g(^DHCJFUOMSET(stUomDr)),"^",2),1:"")
		set rtn=0_"^"_stVal_"^"_stUomDr_"^"_stUomDesc
	}
	
	quit rtn
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFAgeConfig","GetAgeConfig")
Query GetAgeConfig(hospId As %String) As websys.Query(ROWSPEC = "TrowId,Toperator1:%String,TstartVal:%String,TstUomDR:%String,TstartUom:%String,Toperator2:%String,TendVal:%String,TendUomDR:%String,TendUom:%String,TdispUomDR:%String,TdisplayVal:%String,TSemantics:%String")
{
}

ClassMethod GetAgeConfigExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
	set repid=$i(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
 	set jacRowId=0
 	while($o(^DHCJFAGECONFIG(jacRowId))) {
	 	set jacRowId=$o(^DHCJFAGECONFIG(jacRowId))
		set cfgData=$g(^DHCJFAGECONFIG(jacRowId))
	 	continue:(cfgData="")
		set hospDR=$p(cfgData,"^",20)
		continue:(hospDR'=hospId)
	 	set stOper=$p(cfgData,"^",1)
		set stVal=$p(cfgData,"^",2)
		set stUomDr=$p(cfgData,"^",3)
	 	set endOper=$p(cfgData,"^",4)
		set endVal=$p(cfgData,"^",5)
		set endUomDr=$p(cfgData,"^",6)
		set dispUomDr=$p(cfgData,"^",7)
		set stUomDesc=$s((+stUomDr'=0):$p($g(^DHCJFUOMSET(stUomDr)),"^",2),1:"")
		set endUomDesc=$s((+endUomDr'=0):$p($g(^DHCJFUOMSET(endUomDr)),"^",2),1:"")
		set dispUomDesc=$s((+dispUomDr'=0):$p($g(^DHCJFUOMSET(dispUomDr)),"^",2),1:"")
	 	//语义
		set semantics=stOper_stVal_stUomDesc_","_endOper_endVal_endUomDesc_",显示("_dispUomDesc_")"
	 	do OutputCfgList
	}
 	
 	quit $$$OK
 	
OutputCfgList
	set Data=$lb(jacRowId,stOper,stVal,stUomDr,stUomDesc,endOper,endVal,endUomDr,endUomDesc,dispUomDr,dispUomDesc,semantics)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: hujunbin
/// CreatDate: 14.12.13
/// Description: 判断是否在配置的区间内 在web.UDHCJFCOMMON.cls里调用
/// Input: ageStr, birthDate, admDate,birthTime,admTime, stVal, endVal, stCode, endCode,calInFlag
/// 			ageStr:为web.UDHCJFCOMMON.cls里CalAgeNew的返回值，格式为年^月^日^时^分^秒
/// 			birthDate, admDate,birthTime,admTime 出生日期时间、当前（就诊）的日期时间
/// 			stVal stCode：配置区间的开始值和开始单位 enVal endCode: 配置区间的结束值和结束单位
/// 			calInFlag:是否算满 1：表示算满 0：否 例：1年1分 ：在为1 的情况下为2年，0的情况为1年
/// Return:	0/1 1:表示在配置的区间内 0：表示不在	
ClassMethod CheckRangeIn(ageStr, birthDate, admDate, birthTime, admTime, stVal, endVal, stCode, endCode, calInFlag As %String = "") As %String
{
	set stCode=$$ALPHAUP^SSUTIL4(stCode)
	set endCode=$$ALPHAUP^SSUTIL4(endCode)
	
	set admDate=##class(websys.Conversions).DateHtmlToLogical(admDate)
	set birthDate=##class(websys.Conversions).DateHtmlToLogical(birthDate)
	set birthTime=##class(websys.Conversions).TimeHtmlToLogical(birthTime,1)
	set admTime=##class(websys.Conversions).TimeHtmlToLogical(admTime,1)
	if (calInFlag="") set calInFlag=0
	
	set rangeDay=admDate-birthDate
	if (admTime'="")&&(birthTime'="")&&(+admTime<+birthTime) {
		set rangeDay=rangeDay-1
	}
	
	set ageY=+$p(ageStr,"^",1)
	set ageM=+$p(ageStr,"^",2)
	set ageD=+$p(ageStr,"^",3)
	set ageH=+$p(ageStr,"^",4)
	set ageMin=+$p(ageStr,"^",5)
	set ageS=+$p(ageStr,"^",6)
	
	set rtn=0, addFlag=0
	if (stCode="Y") {
		if (ageY>=stVal) {
			set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "Y", calInFlag) 
			set ageY=$p(val,"^",1)
			set addFlag=$p(val,"^",2)
			
			if ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
				set rtn=1	
			}
		}
		if (ageY=stVal) {
			if ((ageM=0)&&(ageD=0)&&(ageH=0)&&(ageMin=0)&&(ageS=0)) {
				set rtn=1
			}	
		}
		
	} elseif (stCode="M") {
		set month=ageM+(ageY*12)
		if (month>=stVal) {
			if (endCode="M") {
				set val=..GetActualCal(ageY, month, ageD, ageH, ageMin, ageS, endCode, calInFlag) 
				set month=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((month<endVal)||((month=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
			if (endCode="Y") {
				set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, endCode, calInFlag) 
				set ageY=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
		}
		if (month=stVal) {
			if ((ageD=0)&&(ageH=0)&&(ageMin=0)&&(ageS=0)) {
				set rtn=1
			}
		}
		
	} elseif (stCode="D") {
		if (rangeDay>=stVal) {
			if (endCode="D") {
				set val=..GetActualCal(ageY, ageM, rangeDay, ageH, ageMin, ageS, endCode, calInFlag) 
				set rangeDay=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				if ((rangeDay<endVal)||((rangeDay=endVal)&&(addFlag=1))) {
					set rtn=1
				}	
			}
			if (endCode="M") {
				set month=ageM+(ageY*12)
				set val=..GetActualCal(ageY, month, ageD, ageH, ageMin, ageS, endCode, calInFlag) 
				set month=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((month<endVal)||((month=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
			if (endCode="Y") {
				set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, endCode, calInFlag) 
				set ageY=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
		}
		if (rangeDay=stVal) {
			if ((ageH=0)&&(ageMin=0)&&(ageS=0)) {
				set rtn=1
			}
		}
	} elseif (stCode="H") {
		set hour=(rangeDay*24)+ageH
		if (hour>=stVal) {
			if (endCode="H") {
				set val=..GetActualCal(ageY, ageM, ageD, hour, ageMin, ageS, endCode, calInFlag) 
				set hour=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((hour<endVal)||((hour=endVal)&&(addFlag=1))) {
					set rtn=1	
				}
			}
			if (endCode="D"){
				set val=..GetActualCal(ageY, ageM, rangeDay, ageH, ageMin, ageS, endCode, calInFlag) 
				set rangeDay=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((rangeDay<endVal)||((rangeDay=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
			if (endCode="M") {
				set month=ageM+(ageY*12)
				set val=..GetActualCal(ageY, month, ageD, ageH, ageMin, ageS, endCode, calInFlag) 
				set month=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((month<endVal)||((month=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
			if (endCode="Y") {
				set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, endCode, calInFlag) 
				set ageY=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
					set rtn=1
				}	
			}
		}
		if (hour=stVal) {
			if ((ageMin=0)&&(ageS=0)) {
				set rtn=1
			}
		}
	} elseif (stCode="MIN") {
		set min=((rangeDay*24)+ageH)*60+ageMin
		if (min>=stVal) {
			if (endCode="MIN") {
				set val=..GetActualCal(ageY, ageM, ageD, ageH, min, ageS, endCode, calInFlag) 
				set min=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((min<endVal)||((min=endVal)&&(addFlag=1))) {
					set rtn=1	
				}
			}
			if (endCode="H") {
				set hour=(rangeDay*24)+ageH
				set val=..GetActualCal(ageY, ageM, ageD, hour, ageMin, ageS, endCode, calInFlag) 
				set hour=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((hour<endVal)||((hour=endVal)&&(addFlag=1))) {
					set rtn=1	
				}
			}
			if (endCode="D"){
				set val=..GetActualCal(ageY, ageM, rangeDay, ageH, ageMin, ageS, endCode, calInFlag) 
				set rangeDay=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((rangeDay<endVal)||((rangeDay=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
			if (endCode="M") {
				set month=ageM+(ageY*12)
				set val=..GetActualCal(ageY, month, ageD, ageH, ageMin, ageS, endCode, calInFlag) 
				set month=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((month<endVal)||((month=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
			if (endCode="Y") {
				set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, endCode, calInFlag) 
				set ageY=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
		}
		if (min=stVal) {
			if (ageS=0) {
				set rtn=1	
			}
		}
	} elseif (stCode="S") {
		set sec=((rangeDay*24)+ageH)*60*60+(ageMin*60)+ageS
		if (sec>=stVal) {
			if (endCode="S") {
				if (sec<endVal) {
					set rtn=1	
				}	
			}
			if (endCode="MIN") {
				set min=((rangeDay*24)+ageH)*60+ageMin
				set val=..GetActualCal(ageY, ageM, ageD, ageH, min, ageS, endCode, calInFlag) 
				set min=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((min<endVal)||((min=endVal)&&(addFlag=1))) {
					set rtn=1	
				}
			}
			if (endCode="H") {
				set hour=(rangeDay*24)+ageH
				set val=..GetActualCal(ageY, ageM, ageD, hour, ageMin, ageS, endCode, calInFlag) 
				set hour=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((hour<endVal)||((hour=endVal)&&(addFlag=1))) {
					set rtn=1	
				}
			}
			if (endCode="D"){
				set val=..GetActualCal(ageY, ageM, rangeDay, ageH, ageMin, ageS, endCode, calInFlag) 
				set rangeDay=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((rangeDay<endVal)||((rangeDay=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
			if (endCode="M") {
				set month=ageM+(ageY*12)
				set val=..GetActualCal(ageY, month, ageD, ageH, ageMin, ageS, endCode, calInFlag) 
				set month=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((month<endVal)||((month=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
			if (endCode="Y") {
				set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, endCode, calInFlag) 
				set ageY=$p(val,"^",1)
				set addFlag=$p(val,"^",2)
				
				if ((ageY<endVal)||((ageY=endVal)&&(addFlag=1))) {
					set rtn=1
				}
			}
		}
	}
	
	quit rtn
}

/// Creator: hujunbin
/// CreatDate: 2014-12-13
/// Description；按配置显示年龄
/// Input: ageStr:为web.UDHCJFCOMMON.cls里CalAgeNew的返回值，格式为年^月^日^时^分^秒
/// 	   birthDate, admDate, birthTime, admTime 出生日期时间、当前（就诊）的日期时间
/// 	   dispCode：配置区间的显示单位
/// 	   calInFlag:是否算满 1：表示算满 0：否 例：1年1分 ：在为1 的情况下为2年，0的情况为1年
/// Return:	显示的年龄串，格式为 "显示的年龄串||年||月||日||时||分||秒" 
/// 		 例：如果配置为"时分",如果计算的实际年龄串ageStr="0^0^1^11^2^4" 
/// 		     则调用该方法返回"35小时2分"_"||"_""_"||"_""_"||"_""_"||"_"35"_"||"_"2"_"||"_""
/// 		     calInFlag=1时返回"35小时3分"_"||"_""_"||"_""_"||"_""_"||"_"35"_"||"_"3"_"||"_""
/// Other: 在web.UDHCJFCOMMON.cls里调用
ClassMethod DispAge(ageStr As %String, birthDate As %String, admDate As %String, birthTime As %String, admTime As %String, dispCode As %String, calInFlag As %String, langId As %String = "") As %String
{
	set dispCode=$$ALPHAUP^SSUTIL4(dispCode)

	set admDate=##class(websys.Conversions).DateHtmlToLogical(admDate)
	set birthDate=##class(websys.Conversions).DateHtmlToLogical(birthDate)
	set birthTime=##class(websys.Conversions).TimeHtmlToLogical(birthTime,1)
	set admTime=##class(websys.Conversions).TimeHtmlToLogical(admTime, 1)
	
	set rangeDay=admDate-birthDate
	if (admTime'="")&&(birthTime'="")&&(+admTime<+birthTime) {
		set rangeDay=rangeDay-1
	}
	
	set ageY=+$p(ageStr,"^",1)
	set ageM=+$p(ageStr,"^",2)
	set ageD=+$p(ageStr,"^",3)
	set ageH=+$p(ageStr,"^",4)
	set ageMin=+$p(ageStr,"^",5)
	set ageS=+$p(ageStr,"^",6)
	
	set dispAgeYr=##class(websys.Translation).Get("Bill.Com.Age", "岁", langId)
	set dispAgeMth=##class(websys.Translation).Get("Bill.Com.Age", "月", langId)
	set dispAgeDay=##class(websys.Translation).Get("Bill.Com.Age", "天", langId)
	set dispAgeHr=##class(websys.Translation).Get("Bill.Com.Age", "小时", langId)
	set dispAgeMin=##class(websys.Translation).Get("Bill.Com.Age", "分", langId)
	
	if (dispCode="Y") {
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "Y", calInFlag) 
		set ageY=$p(val,"^",1)
		set (ageM,ageD,ageH,ageMin,ageS)=""
		
		set rtn=ageY_dispAgeYr
	} elseif (dispCode="YMD") {
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "D", calInFlag) 
		set ageD=$p(val,"^",1)
		set (ageH,ageMin,ageS)=""
		
		set rtn=ageY_dispAgeYr_ageM_dispAgeMth_ageD_dispAgeDay
	} elseif (dispCode="YM") {
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "M", calInFlag) 
		set ageM=$p(val,"^",1)
		set (ageD,ageH,ageMin,ageS)=""
		
		set rtn=ageY_dispAgeYr_ageM_dispAgeMth
	} elseif (dispCode="M") {
		set ageM=(ageY*12)+ageM
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "M", calInFlag) 
		set ageM=$p(val,"^",1)
		set (ageY,ageD,ageH,ageMin,ageS)=""
		
		set rtn=ageM_dispAgeMth
	} elseif (dispCode="MDH") {
		set ageM=(ageY*12)+ageM
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "H", calInFlag) 
		set ageH=$p(val,"^",1)
		set (ageY,ageMin,ageS)=""
		
		set rtn=ageM_dispAgeMth_ageD_dispAgeDay_ageH_dispAgeHr
	} elseif (dispCode="MD") {
		set ageM=(ageY*12)+ageM
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "D", calInFlag) 
		set ageD=$p(val,"^",1)
		set (ageY,ageH,ageMin,ageS)=""
		
		set rtn=ageM_dispAgeMth_ageD_dispAgeDay
	} elseif (dispCode="D") {
		set ageD=rangeDay
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "D", calInFlag) 
		set ageD=$p(val,"^",1)
		set (ageY,ageM,ageH,ageMin,ageS)=""
		
		set rtn=ageD_dispAgeDay
	} elseif (dispCode="DHM") {
		set ageD=rangeDay
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "MIN", calInFlag) 
		set ageMin=$p(val,"^",1)
		set (ageY,ageM,ageS)=""
		
		set rtn=ageD_dispAgeDay_ageH_dispAgeHr_ageMin_dispAgeMin
	} elseif (dispCode="DH") {
		set ageD=rangeDay
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "H", calInFlag)
		set ageH=$p(val,"^",1)
		set (ageY,ageM,ageMin,ageS)=""
		
		set rtn=ageD_dispAgeDay_ageH_dispAgeHr
	} elseif (dispCode="H") {
		set ageH=(rangeDay*24)+ageH
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "H", calInFlag)
		set ageH=$p(val,"^",1)
		set (ageY,ageM,ageD,ageMin,ageS)=""
		
		set rtn=ageH_dispAgeHr
	} elseif (dispCode="HM") {
		set ageH=(rangeDay*24)+ageH
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "MIN", calInFlag) 
		set ageMin=$p(val,"^",1)
		set (ageY,ageM,ageD,ageS)=""
		
		set rtn=ageH_dispAgeHr_ageMin_dispAgeMin
	} elseif (dispCode="MIN") {
		set ageMin=(rangeDay*24)*60+(ageH*60)+ageMin
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "MIN", calInFlag) 
		set ageMin=$p(val,"^",1)
		set (ageY,ageM,ageD,ageS,ageH)=""
		
		set rtn=ageMin_dispAgeMin
	} elseif (dispCode="YD") {
		//+2022-04-29 ZhYW 
		set ageD=rangeDay-(ageY*365)
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "D", calInFlag) 
		set ageD=$p(val,"^",1)
		set (ageM,ageH,ageMin,ageS)=""
		
		set rtn=ageY_dispAgeYr_ageD_dispAgeDay
	} else {
		set val=..GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, "Y", calInFlag) 
		set ageY=$p(val,"^",1)
		set (ageM,ageD,ageH,ageMin,ageS)=""
		
		set rtn=ageY_dispAgeYr
	}
	
	set rtn=rtn_"||"_ageY_"||"_ageM_"||"_ageD_"||"_ageH_"||"_ageMin_"||"_ageS
	quit rtn
}

ClassMethod GetActualCal(ageY, ageM, ageD, ageH, ageMin, ageS, code, calInFlag)
{
	set code=$$ALPHAUP^SSUTIL4(code)
	set increaseFlag=0   //加1标志
	
	if (code="Y") {
		if ((ageM'=0)||(ageD'=0)||(ageH'=0)||(ageMin'=0)||(ageS'=0))&&(calInFlag=1) {
			set ageY=ageY+1
			set increaseFlag=1
		}
		set rtn=ageY_"^"_increaseFlag
	} elseif (code="M") {
		if ((ageD'=0)||(ageH'=0)||(ageMin'=0)||(ageS'=0))&&(calInFlag=1) {
			set ageM=ageM+1	
			set increaseFlag=1
		}	
		set rtn=ageM_"^"_increaseFlag
	} elseif (code="D") {
		if ((ageH'=0)||(ageMin'=0)||(ageS'=0))&&(calInFlag=1) {
			set ageD=ageD+1
			set increaseFlag=1
		}
		set rtn=ageD_"^"_increaseFlag
	} elseif (code="H") {
		if ((ageMin'=0)||(ageS'=0))&&(calInFlag=1) {
			set ageH=ageH+1
			set increaseFlag=1
		}
		set rtn=ageH_"^"_increaseFlag
	} elseif (code="MIN") {
		if (ageS'=0)&&(calInFlag=1) {
			set ageMin=ageMin+1	
			set increaseFlag=1
		}
		set rtn=ageMin_"^"_increaseFlag
	} elseif (code="S") {
		set ageS=ageS
		set rtn=ageS_"^"_increaseFlag
	} else {
		if ((ageM'=0)||(ageD'=0)||(ageH'=0)||(ageMin'=0)||(ageS'=0))&&(calInFlag=1) {
			set ageY=ageY+1
			set increaseFlag=1
		}
		set rtn=ageY_"^"_increaseFlag
	}
	
	quit rtn
}

/// Creator: hujunbin
/// CreatDate: 2015-01-08
/// Description: 年龄配置是走就诊时间还是走实时时间
/// Return: 1:按当前时间 2:按就诊时间 3:按分床时间(限住院)
/// Debug: w ##class(web.UDHCJFAgeConfig).GetAgeConfig()
ClassMethod GetAgeConfig(HospId As %String) As %String
{
	set CalcMode=1
	set Conf=##class(web.DHCBillCommon).GetTarParaId(HospId)
	if (+Conf>0) {
		set CalcMode=$p($g(^DHCTarC("CF",Conf)),"^",15)
	}
	quit CalcMode
}

/// Creator: tangzf
/// CreatDate: 2020-03-21
/// Description: 获取最后一次配置
/// Input: 
/// Return: 
/// Debug: w ##class(web.UDHCJFAgeConfig).GetLastRowId()
ClassMethod GetLastRowId(hospId As %String) As %String
{
	set lastRowId=""
	set rowId=""
	while($o(^DHCJFAGECONFIG(rowId),-1)) {
		set rowId=$o(^DHCJFAGECONFIG(rowId),-1)
		set cfgData=$g(^DHCJFAGECONFIG(rowId))
		continue:(cfgData="")
		set hospDR=$p(cfgData,"^",20)
		continue:(hospDR'=hospId)
		set lastRowId=rowId
		quit
	}

	quit lastRowId
}

/// Creator: tangzf
/// CreatDate: 2020-03-21
/// Description: 获取上一个配置
/// Input: 
/// Return: DHC_JFAgeConfig.RowId
/// Debug: w ##class(web.UDHCJFAgeConfig).GetPrevRowId()
ClassMethod GetPrevRowId(ageCfgId As %String, hospId As %String) As %String
{
	set prevRowId=""
	set myRowId=ageCfgId
	while($o(^DHCJFAGECONFIG(myRowId),-1)) {
		set myRowId=$o(^DHCJFAGECONFIG(myRowId),-1)
		set cfgData=$g(^DHCJFAGECONFIG(myRowId))
		continue:(cfgData="")
		set hospDR=$p(cfgData,"^",20)
		continue:(hospDR'=hospId)
		set prevRowId=myRowId
		quit
	}
	
	quit prevRowId
}

/// Creator: tangzf
/// CreatDate: 2020-03-21
/// Description: 获取下一个配置
/// Return: DHC_JFAgeConfig.RowId
/// Debug: w ##class(web.UDHCJFAgeConfig).GetNextRowId()
ClassMethod GetNextRowId(ageCfgId As %String, hospId As %String) As %String
{
	set nextRowId=""
	set myRowId=ageCfgId
	while($o(^DHCJFAGECONFIG(myRowId))) {
		set myRowId=$o(^DHCJFAGECONFIG(myRowId))
		set cfgData=$g(^DHCJFAGECONFIG(myRowId))
		continue:(cfgData="")
		set hospDR=$p(cfgData,"^",20)
		continue:(hospDR'=hospId)
		set nextRowId=myRowId
		quit
	}
	quit nextRowId
}

}
