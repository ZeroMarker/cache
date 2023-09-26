Class web.DHCMedOPRMPie Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
/生成SVG饼图数据方法
/d ##class(web.DHCSVGData).GetSVGPie("")
*/
ClassMethod GetSVGPie(checkedLines, ctlocRowID, date)
{
	;^DHCMEDADMS(0,"CODE",{Code},{Rowid})
	s xNameString=""
	i checkedLines=""  d
	.s startCode="X"
	.s endCode=""
	.s xCodeName=##class(web.DHCMedOPRMCommonFunc).GetXCodeNameStr(startCode,endCode)
	.s xCodeString=$p(xCodeName,$c(1),1)
	.s xNameString=$p(xCodeName,$c(1),2)
	.s checkedLines=xCodeString
	
	
	s len=$l(checkedLines,"^")
	f i=1:1:len  d
	.s xCode(i)=$p(checkedLines,"^",i)
	.s rowId=##class(web.DHCMedOPRMCommonFunc).GetRowId(xCode(i))
	.s xName(i)=##class(web.DHCMedOPRMCommonFunc).GetDesc(rowId)
	;w !,"checkedLines"_checkedLines
	
	s data=##class(web.DHCMedOPRMLine).GetLines(checkedLines,ctlocRowID,date) //复用web.DHCMedOPRMLine中的方法
	s dLine=$p(data,$c(1),5)
	f i=1:1:len  d  
	.s everyLine=$p(dLine,$c(2),i)
	.s length=$l(everyLine,$c(3))
	.s lastNum=$p(everyLine,$c(3),length)
	.s array(i)=lastNum
	.s xName(i)=xName(i)_":"_lastNum 			//将人数显示在描述后面
	;通过ctlocRowID获取SVG图标题日期和部门字符串
	s dateDepStr=##class(web.DHCMedOPRMCommonFunc).GetCtlocDesc(ctlocRowID) 
	s sTitle=dateDepStr_"等候患者构成"			//饼图标题
	
	s iPies="1"									//饼图数量
	s cPie=""									//并图下方显示的文字
	s XLable=""
	s iParts=len								//每个饼图组成部分数目
	s dPie=""
	
	f part=1:1:iParts d
	.s XLable=XLable_xName(part)_$c(3)_""_$c(2)
	f index=1:1:iPies d
	.s cPie=cPie_" "_$c(2)
	.s TempPie=""
	.f part=1:1:iParts d
	..s TempPie=TempPie_array(part)_$c(3)
	.s TempPie=$e(TempPie,1,$l(TempPie)-1)
	.s dPie=dPie_TempPie_$c(2)
	
	s cPie=$e(cPie,1,$l(cPie)-1)
	s XLable=$e(XLable,1,$l(XLable)-1)
	s dPie=$e(dPie,1,$l(dPie)-1)
	s chkLinesFinal=checkedLines
	s ret=iPies_$c(1)_sTitle_$c(1)_cPie_$c(1)_XLable_$c(1)_dPie_$c(1)_chkLinesFinal
	q ret
}

}
