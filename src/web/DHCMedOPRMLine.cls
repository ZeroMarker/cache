Class web.DHCMedOPRMLine Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetLines(checkedLines As %String, ctlocRowID As %String, date As %String)
{
	n (checkedLines,ctlocRowID,date)
	;如果传入查询曲线项目为空，则默认查询所有
	i checkedLines=""   d
	.s startCode=""	
	.s endCode=""								//从空开始查询（查询所有）
	.s xCodeName=##class(web.DHCMedOPRMCommonFunc).GetXCodeNameStr(startCode,endCode)
	.s xCodeString=$p(xCodeName,$c(1),1)
	.s xNameString=$p(xCodeName,$c(1),2)
	.s checkedLines=xCodeString
	
	i date=""  d
	.s date="60943"								//如果传入查询时间为空值
	.;s date=$p($h,",",1)	
	;s:checkedLines="" checkedLines=##class(web.DHCMedOPRMPatInfo).GetXiString("")
	s iDate=date								//+$h 就诊日期11/09/2007
	s iTime=0 	     							//+$p($h,",",2)就诊截止时间
	s iDistance=5*60  							//时间间隔为5分钟
	s iTimeFrom=$zth("7:00:00",1)
	s iTimeTo=$zth("17:00:00",1)
	s lineColor=""
	;通过ctlocRowID获取SVG图标题日期和部门字符串
	s dateDepStr=##class(web.DHCMedOPRMCommonFunc).GetCtlocDesc(ctlocRowID)
	s sTitle=dateDepStr_"门诊量运营图"
	s iLines=0									//曲线条数
	s cLine=""									//每条线的描述
	s XLable=""									//X轴坐标上要显示数据的点
	s iPoints=0									//每条线总共数据点数
	s dLine=""									//所有线上数据集合
	s ret=iLines_$c(1)_sTitle_$c(1)_cLine_$c(1)_XLable_$c(1)_dLine
	;DHCMEDADMLOG(0,"DateSTP",{OperDate}
    q:'$d(^DHCMEDADMLOG(0,"DateSTP",iDate)) ret
		
	s tmpStatus=0
	f  s tmpStatus=$o(^DHCMEDADMLOG(0,"DateSTP",iDate,tmpStatus)) q:tmpStatus=""  d
	.s iLines=iLines+1
	.s cLine=cLine_##class(web.DHCMedOPRMCommonFunc).GetDesc(tmpStatus)_$c(3)_lineColor_$c(2)
	.s tmpCode=##class(web.DHCMedOPRMCommonFunc).GetCode(tmpStatus) 			//tmpCode指字母标志A1,A2....J
	.s TempLine=""
	.s iCount=0
	.s currTime=iTimeFrom
	.s tmpTime=0
	.f  s tmpTime=$o(^DHCMEDADMLOG(0,"DateSTP",iDate,tmpStatus,tmpTime)) q:tmpTime=""  d
	..//分时间段计数
	..//如果循环的时间变量超出当前时间段，则记录当前时间段数据，并将当前数据应该计入下一时间段
	..while (tmpTime>currTime){s TempLine=TempLine_iCount_$c(3),currTime=currTime+iDistance}
	..//记录最大时间值，用于最终计算时间段数，划分X坐标数
	..s:tmpTime>iTime iTime=tmpTime
	..s tmpPaadm=0
	..f  s tmpPaadm=$o(^DHCMEDADMLOG(0,"DateSTP",iDate,tmpStatus,tmpTime,tmpPaadm)) q:tmpPaadm=""  d
	...s PaadmCtloc=$p($g(^PAADM(tmpPaadm)),"^",4) //根据就诊号取科室代码
	...;w !,"tmpPaadm="_tmpPaadm_";PaadmCtloc="_PaadmCtloc
	...q:(ctlocRowID'="")&(ctlocRowID'=PaadmCtloc)		 //筛选与传入科室相同的就诊号
	...s admDate=$p($g(^PAADM(+tmpPaadm)),"^",6) //取出病人的就诊日期
	...s iCount=iCount+1
	.s TempLine=TempLine_iCount
	.s $p(dLine,$c(2),iLines)=TempLine
	.s ArrLine(tmpCode)=iLines 					//标明tmpCode（字母）与iLines（数字，第几条线）对应关系
		
	//根据最大时间值，计算X轴的坐标数和每个坐标点对应的时间
	s iPoints=1
	s XLable=$zt(iTimeFrom,2)_$c(3)
	s currTime=iTimeFrom
	do{
	  s currTime=currTime+iDistance
	  s iPoints=iPoints+1
	  s XLable=XLable_$zt(currTime,2)_$c(3)
	}while (currTime'>iTime)
	s XLable=$e(XLable,1,$l(XLable)-1)
	
	//下面代码解决曲线数据点不够时，曲线图降为零点问题
	//将各条线的长度统一格式为iPoints，长度不足部分，用最后的数据补全
	s tempDLine=""								//临时字符串，用于暂时存放补全后的dLine
	s totleLineNum=$l(dLine,$c(2))              //数据曲线总数
	f everyLineNum=1:1:totleLineNum  d  		
	.s everyLine=$p(dLine,$c(2),everyLineNum)   //得到每条曲线数据
	.s lineLength=$l(everyLine,$c(3))			//得到每条曲线点数
	.s lastNum=$p(everyLine,$c(3),lineLength)   //每条曲线最后一个数据
	.i lineLength<iPoints
	.f lackLineNum=lineLength:1:iPoints d
	..s everyLine=everyLine_$c(3)_lastNum
	.s tempDLine=tempDLine_everyLine_$c(2)
	s dLine=$e(tempDLine,1,$l(tempDLine)-1)		//此时dLine为A至J曲线总数据
	
	//从dLine中，将每条线的数据取出，放到ArrayLine数组中
	s beforeXStr=##class(web.DHCMedOPRMCommonFunc).GetXCodeNameStr("","X1") //得到A1到X1之前的业务项数据
	s beforeXCode=$p(beforeXStr,$c(1),1) 		//得到A1到X1之前的业务项代码
	s beforeLen=$l(beforeXCode,"^")
	f i=1:1:beforeLen d
	.s codeArr(i)=$p(beforeXCode,"^",i)
	.s dataLineStr(codeArr(i))=$p(dLine,$c(2),ArrLine(codeArr(i))) //将每条线的数据放到dataLineStr()数组中
	//以上代码实现下面代码功能
	;s dataLineStr("A1")=$p(dLine,$c(2),ArrLine("A1"))
	;A1.............I
	;s dataLineStr("J")=$p(dLine,$c(2),ArrLine("J"))
	
	
	s afterXStr=##class(web.DHCMedOPRMCommonFunc).GetXCodeNameStr("X","") //得到X1之后的业务项数据
	s afterXCode=$p(afterXStr,$c(1),1) 			//得到Xi之后的业务项代码
	s afterXDesc=$p(afterXStr,$c(1),2) 			//得到Xi之后的业务项描述
	s afterLen=$l(afterXCode,"^")
	f i=1:1:afterLen d
	.s xCodeArr(i)=$p(afterXCode,"^",i)
	.s xDesArr(i)=$p(afterXCode,"^",i)
	.s cLine=cLine_xDesArr(i)_$c(3)_lineColor_$c(2) //循环将Xi的曲线标题设置到cLine中
	
	//将A至X前每条线数据对应放入临时Global^CacheTemp中，
	//以便于调用公用方法BuildXLines获取Xi折线数据
   	k ^CacheTemp("MedOPRMLine",$j)
	f i=1:1:beforeLen d
	.s ^CacheTemp("MedOPRMLine",$j,codeArr(i))=dataLineStr(codeArr(i)) //以X前Code长度循环设置数据
	
	// “候诊曲线”
	s waitLine=""									//等候曲线字符串
	s formula="A1-A2^C"								//计算公式字符串
	s waitLine=##class(web.DHCMedOPRMCommonFunc).BuildXLines(formula,beforeXStr,iPoints)
	s dataLineStr("X1")=waitLine					//将候诊曲线数据放到dataLineStr数组中
	s iLines=iLines+1
	
	// “等候收费曲线”
	s waitChargeLine=""
	s formula="B-D1"
	s waitChargeLine=##class(web.DHCMedOPRMCommonFunc).BuildXLines(formula,beforeXStr,iPoints)
	s dataLineStr("X2")=waitChargeLine				//将等候收费曲线数据放到dataLineStr数组中
	s iLines=iLines+1

	// “等候取药曲线”
	s waitFetchLine=""
	s formula="D1-D2^E"
	s waitFetchLine=##class(web.DHCMedOPRMCommonFunc).BuildXLines(formula,beforeXStr,iPoints)
	s dataLineStr("X3")=waitFetchLine				//将等候取药曲线数据放到dataLineStr数组中
	s iLines=iLines+1
	
	//删除临时Global ^CacheTemp
	k ^CacheTemp("MedOPRMLine",$j)					
    
	s temp=""
	s cLineFinal=""
	s iLinesFinal=$l(checkedLines,"^")				//通过传入参数checkedLines确定曲线的最终条数
	for i=1:1:iLinesFinal d
	.s array(i)=$p(checkedLines,"^",i)
	s dLine=""
	f selectNum=1:1:iLinesFinal d
	.s code=array(selectNum)
	.s data=dataLineStr(code)    					//每条线的数据
	.s temp=temp_data_$c(2)
	.s rowId=##class(web.DHCMedOPRMCommonFunc).GetRowId(code)
	.s description=##class(web.DHCMedOPRMCommonFunc).GetDesc(rowId)
	.s cLineFinal=cLineFinal_description_$c(3)_lineColor_$c(2)
	s cLineFinal=$e(cLineFinal,1,$l(cLineFinal)-1)
	s dLine=$e(temp,1,$l(temp)-1)
	s ret=iLinesFinal_$c(1)_sTitle_$c(1)_cLineFinal_$c(1)_XLable_$c(1)_dLine
	q ret
}

}
