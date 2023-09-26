/// description: 大屏显示
Class web.DHCSTPIVAS.ScreenWardState Extends %RegisteredObject
{

/// creator: 	yunhaibao
/// createdate:	2018-03-21
/// description:初始化病区批次表格抬头
/// input:		配液中心Id
/// output:		
/// return:		json
/// others:		w ##class(web.DHCSTPIVAS.ScreenWardState).ColumnsWardState(101)
ClassMethod ColumnsWardState(locId)
{
	s retJson=""
	s title="field^title^width^halign^align"
	q:locId="" "[]"
	s field="wardId^病区Id^250^left^left^true"
	s retJson=##class(web.DHCSTJQUERYCOMMON).getJsonData(title_"^hidden",field,"^")
	s field="wardDesc^病区^250^left^left"
	s retJson=retJson_","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,field,"^")
	s psStateStr=##class(web.DHCSTPIVAS.Common).PivasLocStateList(locId)
	s psLen=$l(psStateStr,"^")
	f psI=1:1:psLen d
	.s psData=$p(psStateStr,"^",psI)
	.q:psData=""
	.s psId=$p(psData,",",1)
	.s psNumber=$p(psData,",",2)
	.s psDesc=$p(psData,",",3)
	.s field="psState"_psNumber_"^"_psDesc_"^100^left^left"
	.s retJson=retJson_","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,field,"^")
	s field="oeoreStoped^停止^100^left^left"
	s retJson=retJson_","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,field,"^")
	q "["_retJson_"]"
}

/// creator:	yunhaibao
/// createdate: 2018-03-27
/// description:配液大屏病区流程记录显示列表,仅用于显示当天用药处于各流程的数据
/// w ##class(web.DHCSTPIVAS.ScreenWardState).JsGetScreenWardState("10","1","248^1,2,3,4,5,6,临,空早,空晚")
ClassMethod JsGetScreenWardState(rows, page, inputStr)
{
	i page=0 s page=1
	s EndRow=page*rows  
	s StartRow=((page-1)*rows)+1 
	s retData=..CollectScreenWardStateByDose(inputStr)
	s pid=$p(retData,"^",1)
	q:(pid="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s locId=$p(inputStr,"^",1)
	s title="wardId^wardDesc"
	s psStateStr=##class(web.DHCSTPIVAS.Common).PivasLocStateList(locId)
	s psLen=$l(psStateStr,"^")
	f psI=1:1:psLen d
	.s psData=$p(psStateStr,"^",psI)
	.q:psData=""
	.s psNumber=$p(psData,",",2)
	.s title=title_"^"_"psState"_psNumber
	s title=title_"^"_"oeoreStoped"
	s psNumberStr=$p(title,"^",3,$l(title,"^"))
	s psNumberLen=$l(psNumberStr,"^")
	s wardId="",count=0
	f  s wardId=$o(^||TMP($ClassName(),pid,wardId)) q:wardId=""  d
	.q:+wardId=0
	.s wardDesc=$p(^PAWARD(wardId),"^",2)
	.s data=wardId_"^"_wardDesc
	.s psI=""
	.f psI=1:1:psNumberLen d
	..s psNumber=$p(psNumberStr,"^",psI)
	..q:psNumber=""
	..s psNumber=$replace(psNumber,"psState","")
	..s psStateCnt=+$g(^||TMP($ClassName(),pid,wardId,psNumber))
	..s data=data_"^"_psStateCnt
	.s count=count+1
	.q:(count<StartRow)||(count>EndRow) 
	.i count=StartRow d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,data,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,data,"^")
  	k ^||TMP($ClassName(),pid)
	i count>0   d
	.w "],""total"""_":"_count_"}"
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
}

/// Description: 统计用药日期内各流程总数
ClassMethod CollectScreenWardStateByDose(inputStr)
{
	s PivaLocId=$p(inputStr,"^",1)
	s BatNoStr=$p(inputStr,"^",2)
	q:PivaLocId="" ""
	q:BatNoStr="" ""
	s BatNoList=$lfs(BatNoStr,",")
	s pid=..NewPid()
	s startDate=+$h
	s endDate=+$h
	f calcuDate=startDate:1:endDate d
	.s pogId=""
	.f  s pogId=$o(^PIVA(0,"LOCORDDATE",PivaLocId,calcuDate,pogId)) q:pogId=""  d
	..q:+pogId=0
	..s PIVA=^PIVA(pogId)
	..s mDsp=$p(PIVA,"^",1)
	..s psId=$p(PIVA,"^",6)
	..s psNumber=$p(^PIVAS(psId),"^",1)
	..s psDesc=$p(^PIVAS(psId),"^",2)
	..s DHCOEDISQTY=^DHCOEDISQTY(mDsp)
	..s wardLocId=$p(DHCOEDISQTY,"^",22)
	..s mOeore=$p(DHCOEDISQTY,"^",3)
	..s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
	..q:(wardId="")
	..s batNo=$p(PIVA,"^",3)
	..
	..q:$lf(BatNoList,batNo)=0
	..// 过滤-批次
	..i '$d(^||TMP($ClassName(),pid,wardId,psNumber)) d
	...s ^||TMP($ClassName(),pid,wardId,psNumber)=1
	..e  s ^||TMP($ClassName(),pid,wardId,psNumber)=1+^||TMP($ClassName(),pid,wardId,psNumber)
	..s oeoreStat=##class(web.DHCSTPIVAS.Common).CheckOeoreStat(mOeore)
	..i oeoreStat'=1 d
	...s ^||TMP($ClassName(),pid,wardId,"oeoreStoped")=1+$g(^||TMP($ClassName(),pid,wardId,"oeoreStoped"))
	q pid
}

/// Description: 统计操作日期内各流程的总数
/// 			 依据具体需求,默认按用药日期CollectScreenWardStateByDose
ClassMethod CollectScreenWardState(inputStr)
{
	s PivaLocId=$p(inputStr,"^",1)
	s BatNoStr=$p(inputStr,"^",2)
	q:PivaLocId="" ""
	q:BatNoStr="" ""
	s BatNoList=$lfs(BatNoStr,",")
	s pid=..NewPid()
	s startDate=+$h
	s endDate=+$h 
	f calcuDate=startDate:1:endDate d
	.s psId=""
	.f  s psId=$o(^PIVA(0,"DATELOC",PivaLocId,calcuDate,psId)) q:psId=""  d
	..s psDesc=$p(^PIVAS(psId),"^",2)
	..s psNumber=$p(^PIVAS(psId),"^",1)
	..s pogId=""
	..f  s pogId=$o(^PIVA(0,"DATELOC",PivaLocId,calcuDate,psId,pogId)) q:pogId=""  d
	...q:+pogId=0
	...s mDsp=$p(^PIVA(pogId),"^",1)
	...s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	...s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
	...s batNo=$p(^PIVA(pogId),"^",3)
	...q:$lf(BatNoList,batNo)=0
	...// 过滤-批次
	...i '$d(^||TMP($ClassName(),pid,wardId,psNumber)) d
	....s ^||TMP($ClassName(),pid,wardId,psNumber)=1
	...e  s ^||TMP($ClassName(),pid,wardId,psNumber)=1+^||TMP($ClassName(),pid,wardId,psNumber)
	q pid
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"PIVA")
}

}
