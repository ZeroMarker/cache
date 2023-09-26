Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2016-04-25
/// Descript: 	新版登记注册和预检分诊类
Class web.DHCADVStatTemp Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCADVStatTemp).Save("#$aa#$bb#$cc")
ClassMethod Save(Params)
{
	n (Params)
	s STRowID = $p(Params,"#$",1)
	s STForNameDr = $p(Params,"#$",2)
	s STTempName = $p(Params,"#$",3)
	s STTempInfo = $p(Params,"#$",4)
	s STTempInfo = $tr(STTempInfo,"^",$c(2))
	
	Q:(+STRowID="0")&&($d(^DHCADVST(0,"TempName",$$ALPHAUP^SSUTIL4(STTempName)))) "-1"
	
	s TempName=""
	i +STRowID'=0  s TempName=$p(^DHCADVST(STRowID),"^",2)    
	Q:(TempName'="")&&(TempName'=STTempName)&&($d(^DHCADVST(0,"TempName",$$ALPHAUP^SSUTIL4(STTempName)))) "-1"
	i STRowID="" d
	.&sql(INSERT INTO DHC_AdvStatTemp (ST_ForName_Dr, ST_TempName, ST_TempInfo) 
		VALUES (:STForNameDr,:STTempName,:STTempInfo))
	
	i STRowID'="" d
	.&sql(UPDATE DHC_AdvStatTemp SET ST_ForName_Dr=:STForNameDr, ST_TempName=:STTempName,
		ST_TempInfo=:STTempInfo WHERE ST_RowID=:STRowID) 
		
	q SQLCODE
}

ClassMethod Delete(StRowID)
{
	&sql(DELETE DHC_AdvStatTemp WHERE ST_RowID=:StRowID)
	q SQLCODE
}

/// Descript:  datagrid 数据
/// Input :Params
/// 
/// w ##Class(web.DHCADVStatTemp).GetJsonList("0")
ClassMethod GetJsonList(ForNameID) As %String
{
	n (ForNameID)
	s Del="""",Count=0
	w "{"_Del_"rows"_Del_":"
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s listObj=##class(%ListOfObjects).%New()
	
	s StRowID = ""
	f  s StRowID = $o(^DHCADVST(0,"IndexFormName",ForNameID,StRowID)) q:StRowID=""  d
	.s DymObj = ##class(web.DHCAPPJsonObject).%New()
	.s StTempName = $p(^DHCADVST(StRowID),"^",2)
	.s StTempInfo = $p(^DHCADVST(StRowID),"^",3)   //!!分割Itm,##分割itm
	.s StTempInfo = $tr(StTempInfo,$c(2),"^")
	.s StatTypeXInfo=$p(StTempInfo,"!!",1)
	.s StatTypeXVal = $p(StatTypeXInfo,"##",1)
	.s StatTypeXText = $p(StatTypeXInfo,"##",2)
	.s StatTypeYInfo = $p(StTempInfo,"!!",2)
	.s StatTypeYVal = $p(StatTypeYInfo,"##",1)
	.s StatTypeYText = $p(StatTypeYInfo,"##",2)
	.s StatDataInfo=$p(StTempInfo,"!!",3)
	.s StatDataVal = $p(StatDataInfo,"##",1)
	.s StatDatText = $p(StatDataInfo,"##",2)
	.s StatTypeInfo=$p(StTempInfo,"!!",4)
	.s StatTypeVal = $p(StatTypeInfo,"##",1)
	.s StatTypeText = $p(StatTypeInfo,"##",2)
	.d DymObj.Put("StRowID",StRowID)
	.d DymObj.Put("StTempName",StTempName)
	.d DymObj.Put("StatTypeXVal",StatTypeXVal)
	.d DymObj.Put("StatTypeXText",StatTypeXText)
	.d DymObj.Put("StatTypeYVal",StatTypeYVal)
	.d DymObj.Put("StatTypeYText",StatTypeYText)
	.d DymObj.Put("StatDataVal",StatDataVal)
	.d DymObj.Put("StatDatText",StatDatText)
	.d DymObj.Put("StatTypeVal",StatTypeVal)
	.d DymObj.Put("StatTypeText",StatTypeText)
	.s Count=Count+1
	.d listObj.Insert(DymObj)
	w jsonObj.ListToJson(listObj)
	w ","_Del_"total"_Del_":"_Count_"}"
	q ""
}

/// w ##class(web.DHCADVStatTemp).GetTempList("1")
ClassMethod GetTempList(FormNameID)
{
	n (FormNameID)
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s listObj=##class(%ListOfObjects).%New()
	i FormNameID'="" d
	.s StRowID=""
	.f  s StRowID= $o(^DHCADVST(0,"IndexFormName",FormNameID,StRowID)) q:StRowID=""  d
	..s STTempName = $p(^DHCADVST(StRowID),"^",2)
	..s STTempInfo = $p(^DHCADVST(StRowID),"^",3)
	..s STTempInfo = $tr(STTempInfo,$c(2),"^")
	..d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",STTempInfo).Put("text",STTempName))
	w jsonObj.ListToJson(listObj)	
	q ""
}

}
