/// Creator: 	bianshuai
/// CreateDate: 2016-04-11
/// Descript: 	公共类
Class web.DHCAPPCommonUtil Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:药学咨询列表
/// w ##Class(web.DHCAPPCommonUtil).QueryArcItemList("10","1","")
ClassMethod QueryArcItemList(rows As %String, page As %String, params As %String, code = "", HospID As %String = "") As %String
{
	n (rows,page,params,code,HospID)

	s End=page*rows  //结束行
	s Start=((page-1)*rows)+1     //开始行

	s pid=##Class(web.DHCAPPExaRepCom).NewPid()
	d ..killTmpGlobal(pid)
	
	s arcItmalise=$p(params,"^",1)  //名称/别名
	s arcItmCatID=$p(params,"^",2) //医嘱子类
	
	s OrderTypeStr="X^L"
	s Num=0,count=0
	for index=1:1:$l(OrderTypeStr,"^") {
		s OrderType=$p(OrderTypeStr,"^",index)
		s itemCatID=""
		f  s itemCatID=$o(^ARC("IC",0,"OrderType",OrderType,itemCatID)) q:itemCatID=""  d   /// sufan 2016/1/6 N - >X
		.q:(arcItmCatID'="")&(arcItmCatID'=itemCatID)
		.s itmmastid=""
		.f  s itmmastid=$o(^ARCIM(0,"ARCIC_DR",itemCatID,itmmastid)) q:itmmastid=""  d
		..s itmmastver=""
		..f  s itmmastver=$o(^ARCIM(0,"ARCIC_DR",itemCatID,itmmastid,itmmastver)) q:itmmastver=""  d
		...s arcimid=itmmastid_"||"_itmmastver
		...q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",arcimid,HospID)="N"
		...s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
		...s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
		...q:(arcItmalise'="")&(arcitmdesc'[arcItmalise)
		...q:($g(code)'="")&(arcitmcode'[code)
		...s ListData=arcimid_"^"_arcitmcode_"^"_arcitmdesc
		...s Num=Num+1
		...s ^TMP("DHCST","web.DHCAPPCommonUtil","QueryArcItemList",pid,Num)=ListData
	}
	
	
	i Num="0" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出空的json串
	q:Num="0" ""

	///转换数据为Json格式
	S ListTitle="arcimid^arcitmcode^arcitmdesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPCommonUtil","QueryArcItemList",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPCommonUtil","QueryArcItemList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:查询[注意事项模板字典]
/// w ##class(web.DHCAPPCommonUtil).jsonArcItemCat()
ClassMethod jsonArcItemCat(HospID As %String = "") As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ARCIC_RowId, ARCIC_Desc FROM Arc_ItemCat"
	s sqlStr = sqlStr_" Where ARCIC_OrderType='X' or ARCIC_OrderType='L' " /// X->N   sufan 2017/07/06
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowID = result.Data("ARCIC_RowId")
		s Desc = result.Data("ARCIC_Desc")
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",RowID,HospID)="N"
		s tmp=RowID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Descript:检查分类列表
/// w ##Class(web.DHCAPPCommonUtil).QueryArcCatList("10","1","")
/// zhouxin
ClassMethod QueryArcCatList(rows = 1, page = 10, desc = "") As %String
{
	n (rows,page,desc)
	s start=(page-1)*rows+1
    s end=page*rows
    s count=0
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
    w "{""rows"":["
	s cat=0
	f  s cat=$o(^DHCAPARCCA(cat)) q:cat=""  d
	.q:+cat=0
	.	
	.s tmpdesc=$p(^DHCAPARCCA(cat),"^",2)
	.q:(desc'="")&&(tmpdesc'[desc)
	.s count=count+1
	.q:count<start
	.q:count>end
    .w $case(count,start:"",:",") 
	.w jsonObj.FromObject(##class(User.DHCAppArcCat).%OpenId(cat)).Json()
	.
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:js 获取登录信息
/// w ##Class(web.DHCAPPCommonUtil).getHopDesc()
/// zhouxin
ClassMethod getHopDesc() As %String
{
	n (%session)
	q:'$d(%session) ""
	q:+%session.Get("LOGON.HOSPID")=0 ""
	w "<SCRIPT Language='JavaScript'> var LgHospDesc='"_$p(^CT("HOSP",%session.Get("LOGON.HOSPID")),"^",2)_"';</SCRIPT>"
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCAPPCommonUtil","QueryArcItemList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("APPCommonUtil"))
}

/// Descript:js 获取医院字典信息
/// Creator:LiangQiang
/// CreateDate:2016-04-21
/// w ##Class(web.DHCAPPCommonUtil).GetHospDs()
ClassMethod GetHospDs() As %String
{
	s count=0
	w "["
	s hosprowid=""
	f  s hosprowid=$o(^CT("HOSP",hosprowid)) q:hosprowid=""  d
	.q:hosprowid=0
	.s hospdesc=$p(^CT("HOSP",hosprowid),"^",2) 
	.s datefrom=$p(^CT("HOSP",hosprowid),"^",9) 
	.s dateto=$p(^CT("HOSP",hosprowid),"^",10)
	.i datefrom>$h q 
	.i dateto,dateto<$h q 
	.s tmp=hosprowid_"^"_hospdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description: 公共 (页面日期 转为 M中的日期数字)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-03
/// Table: 		 
/// Input:       页面日期  例如：2017-03-03、28/2/2017等
/// Output:  	 M中日期数字 64338
/// Others:	w ##class(web.DHCAPPCommonUtil).DateHtmlToLogical("2017-03-03")	
ClassMethod DateHtmlToLogical(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCAPPCommonDate=""
	s DHCAPPCommonDate=..%ZDH(date)
	q DHCAPPCommonDate
}

/// Description: 公共 (M中的日期数字 转为 demo配置日期)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-03
/// Table: 		 
/// Input:       M中日期数字 64345
/// Output:  	 demo配置的日期格式
/// Others:	w ##class(web.DHCAPPCommonUtil).DateLogicalToHtml("64345")	
ClassMethod DateLogicalToHtml(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCAPPCommonDate=""
	s DHCAPPCommonDate=..%ZD(date)
	q DHCAPPCommonDate
}

/// Description: 公共 (获取系统日期格式配置)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-22
/// @return 
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
/// Others:	w ##class(web.DHCAPPCommonUtil).DateFormat()
ClassMethod DateFormat()
{
	n
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY")&&(datesper="/") Quit 4
	i (dateformat="YMD")&&(datesper="-") Quit 3
	i (dateformat="MDY")&&(datesper="/") Quit 1
	Quit 4
}

}
