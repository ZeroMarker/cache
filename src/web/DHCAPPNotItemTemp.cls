Import sqluser

/// Descript:   注意事项模板字典维护类
/// Creator:    bianshuai
/// CreateDate: 2016-04-11
Class web.DHCAPPNotItemTemp Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	注意事项模板字典
/// w ##class(web.DHCAPPNotItemTemp).saveItmTemp("8^000003^测试000003^N^65")
ClassMethod saveItmTemp(ItmTempDataList As %String) As %String
{
	n (ItmTempDataList)
	s Len=$L(ItmTempDataList,"$$")
	s Err=0
	f i=1:1:Len q:Err'=0  d
	.s ItmTempStr=$p(ItmTempDataList,"$$",i)
	.s Err=..CheckRepeat(ItmTempStr)   /// 重复性判断
	.q:Err'=0
	.i $p(ItmTempStr,"^",1) ="" d
	..s Err=..insertItmTemp(ItmTempStr)
	.e  d
	..s Err=..updateItmTemp(ItmTempStr)
	q Err
}

/// Descript:	增加 注意事项模板字典
/// w ##class(web.DHCAPPNotItemTemp).insertItmTemp("")
ClassMethod insertItmTemp(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s Code=$p(ItmTempStr,"^",2)   	///代码
	s Desc=$p(ItmTempStr,"^",3)   	///描述
	s ActFlag=$p(ItmTempStr,"^",4)  ///不可用标志
	s HospID=$p(ItmTempStr,"^",5)   ///医院ID
 	&SQL(INSERT INTO DHC_AppItemTemp(AIT_Code, AIT_Desc, AIT_ActiveFlag, AIT_Hosp_Dr) VALUES(:Code,:Desc,:ActFlag,:HospID))
 	q SQLCODE
}

/// Descript:	更新 注意事项模板字典
/// w ##class(web.DHCAPPNotItemTemp).updateItmTemp("")
ClassMethod updateItmTemp(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s Code=$p(ItmTempStr,"^",2)   	///代码
	s Desc=$p(ItmTempStr,"^",3)   	///描述
	s ActFlag=$p(ItmTempStr,"^",4)  ///不可用标志
	s HospID=$p(ItmTempStr,"^",5)   ///医院ID
	&SQL(Update DHC_AppItemTemp Set AIT_Code=:Code,AIT_Desc=:Desc,AIT_ActiveFlag=:ActFlag,AIT_Hosp_Dr=:HospID WHERE AIT_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除 注意事项模板字典
/// w ##class(web.DHCAPPNotItemTemp).delItmTemp("1")
ClassMethod delItmTemp(ID As %String) As %String
{
	N (ID)
	Q:$d(^DHCAPARCNO(0,"TEMP",ID)) "-1"   /// 是否与医嘱项关联
	&SQL(Delete From DHC_AppItemTemp Where AIT_RowID=:ID)
	Q SQLCODE
}

/// Descript:	检查医嘱项注意事项表
/// w ##class(web.DHCAPPNotItemTemp).saveItmTempD("^13^EEEEEE")
ClassMethod saveItmTempD(ItmTempDataList As %String) As %String
{
	n (ItmTempDataList)
	s ItmTempDataList=$replace(ItmTempDataList,$c(10),"<br>")
	s Len=$L(ItmTempDataList,"$$")
	s Err=0
	f i=1:1:Len q:Err'=0  d
	.s ItmTempStr=$p(ItmTempDataList,"$$",i)
	.i $p(ItmTempStr,"^",1) ="" d
	..s Err=..insItmTempD(ItmTempStr)
	.e  d
	..s Err=..updItmTempD(ItmTempStr)
	q Err
}

/// Descript:	增加 检查医嘱项注意事项表
/// w ##class(web.DHCAPPNotItemTemp).insItmTempD("")
ClassMethod insItmTempD(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s aitID=$p(ItmTempStr,"^",2)   	///DHC_AppItemTemp ID
	s notes=$p(ItmTempStr,"^",3)   	///注意事项
	s childSub=$o(^DHCAPITMTE(aitID,"D",""),-1)+1
 	&SQL(INSERT INTO DHC_AppItemTempD(AIT_Temp_ParRef, AIT_ChlidSub ,AIT_Text) VALUES(:aitID,:childSub,:notes))
 	q SQLCODE
}

/// Descript:	更新 检查医嘱项注意事项表
/// w ##class(web.DHCAPPNotItemTemp).updItmTempD("")
ClassMethod updItmTempD(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s aitDetID=$p(ItmTempStr,"^",1)   	///ID
	s notes=$p(ItmTempStr,"^",3)   		///注意事项
	&SQL(Update DHC_AppItemTempD Set AIT_Text=:notes WHERE AIT_RowID=:aitDetID)
 	q SQLCODE
}

/// Descript:	删除 检查医嘱项注意事项表
/// w ##class(web.DHCAPPNotItemTemp).delItmTempD("1")
ClassMethod delItmTempD(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_AppItemTempD Where AIT_RowID=:ID)
	Q SQLCODE
}

/// Descript:查询[注意事项模板字典]
/// w ##class(web.DHCAPPNotItemTemp).QueryAppItemTemp("12","1","")
ClassMethod QueryAppItemTemp(rows As %String, page As %String, params As %String, HospID As %String = "") As %String
{
	N (rows,page,params,HospID)
	s End = page*rows
	s Start=(page-1)*rows+1
	
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s h=0,count=0
	s aitID="0"
	f  s aitID=$o(^DHCAPITMTE(aitID)) q:aitID=""  d
	.s aitCode=$p(^DHCAPITMTE(aitID),"^",1)    //代码
	.s aitDesc=$p(^DHCAPITMTE(aitID),"^",2)    //描述
	.s aitActCode=$p(^DHCAPITMTE(aitID),"^",3) //可用标志
	.s aitActDesc=$s(aitActCode="Y":"是",aitActCode="N":"否",1:"")
	.s aitHospID=$p(^DHCAPITMTE(aitID),"^",4)  //医院
	.q:(HospID'="")&(HospID'=aitHospID) 
	.s aitHospDesc=""
	.s:aitHospID'="" aitHospDesc=$p(^CT("HOSP",aitHospID),"^",2)
	.s h=h+1
	.s ListData=aitID_"^"_aitCode_"^"_aitDesc_"^"_aitActCode_"^"_aitActDesc_"^"_aitHospID_"^"_aitHospDesc
	.s ^TMP("DHCST","web.DHCAPPNotItemTemp","QueryAppItemTemp",pid,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="aitID^aitCode^aitDesc^aitActCode^aitActDesc^aitHospID^aitHospDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPNotItemTemp","QueryAppItemTemp",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPNotItemTemp","QueryAppItemTemp",pid,index))
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
/// w ##class(web.DHCAPPNotItemTemp).QueryAppItemTempD("12","1","")
ClassMethod QueryAppItemTempD(rows As %String, page As %String, aitID As %String) As %String
{
	N (rows,page,aitID)
	s End = page*rows
	s Start=(page-1)*rows+1
	
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s h=0,count=0
	s CH=""
	f  s CH=$o(^DHCAPITMTE(aitID,"D",CH)) q:CH=""  d
	.s aitNotes=$p(^DHCAPITMTE(aitID,"D",CH),"^",1)    //注意事项
	.s h=h+1
	.s ListData=aitID_"||"_CH_"^"_aitNotes
	.s ^TMP("DHCST","web.DHCAPPNotItemTemp","QueryAppItemTempD",pid,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 
	
	///转换数据为Json格式
	S ListTitle="aitDetID^aitNotes"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPNotItemTemp","QueryAppItemTempD",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPNotItemTemp","QueryAppItemTempD",pid,index))
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
/// w ##class(web.DHCAPPNotItemTemp).jsonNoteItemTemp("")
ClassMethod jsonNoteItemTemp(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AIT_RowID, AIT_Desc FROM DHC_AppItemTemp WHERE AIT_ActiveFlag= 'Y' and AIT_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowID = result.Data("AIT_RowID")
		s Desc = result.Data("AIT_Desc")
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

/// w ##Class(web.DHCAPPNotItemTemp).GetItemTempNotes("10")
ClassMethod GetItemTempNotes(aitID As %String) As %String
{
	n (aitID)
	s ListTitle="itemTempId^itemTempDesc"
	if ('$D(^DHCAPITMTE(aitID))){
		w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,"^")
		Q ""
	} 
	s CH=""
	s CH=$o(^DHCAPITMTE(aitID,"D",CH))
	if (CH=""){
		w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,"^")
		Q ""
	}
	s aitNotes=$p(^DHCAPITMTE(aitID,"D",CH),"^",1)    //注意事项
	s ListData=aitID_"||"_CH_"^"_aitNotes	
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:检查代码、描述是否重复
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	N (ItmTempStr)
	s aitID=$p(ItmTempStr,"^",1)   		///ID
	s aitCode=$p(ItmTempStr,"^",2)   	///代码
	s aitDesc=$p(ItmTempStr,"^",3)   	///描述
	s HospID=$p(ItmTempStr,"^",5)   ///医院ID
	/// 新记录
	q:(aitID="")&($d(^DHCAPITMTE(0,"Code",$$ALPHAUP^SSUTIL4(aitCode),HospID))) "-1"
	q:(aitID="")&($d(^DHCAPITMTE(0,"Desc",$$ALPHAUP^SSUTIL4(aitDesc),HospID))) "-2"
	q:aitID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCAPITMTE(aitID)),"^",1)    //代码
	s Desc=$p($g(^DHCAPITMTE(aitID)),"^",2)    //描述
	q:(aitCode'=Code)&($d(^DHCAPITMTE(0,"Code",$$ALPHAUP^SSUTIL4(aitCode),HospID))) "-3"
	q:(aitDesc'=Desc)&($d(^DHCAPITMTE(0,"Desc",$$ALPHAUP^SSUTIL4(aitDesc),HospID))) "-4"
	q 0
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCAPPNotItemTemp","QueryAppItemTemp",pid)
	k ^TMP("DHCST","web.DHCAPPNotItemTemp","QueryAppItemTempD",pid)
	q ""
}

}
