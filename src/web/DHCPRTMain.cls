Import SQLUSER

Class web.DHCPRTMain Extends %Persistent [ Not ProcedureBlock ]
{

/// Creator:qqa
/// Descript:打印模板保存
/// w ##class(web.DHCPRTMain).SaveOrUpdate("^Index1^测试打印模板^50^50^1")
ClassMethod SaveOrUpdate(Params, HospDr)
{
	n (Params,HospDr)
	s MARowID = $p(Params,"^",1)
	s PrtCode = $p(Params,"^",2)
	s PrtDesc = $p(Params,"^",3)
	s PrtWidth = $p(Params,"^",4)
	s PrtHeight = $p(Params,"^",5)
	s PrtType = $p(Params,"^",6)
	s PrtLine = $p(Params,"^",7)
	s:PrtLine="" PrtLine=12
	s CreatorDate=+$h
	s CreatorTime=$p($h,",",2)
	
	s IsHasID=##class(web.DHCPRTMain).IsHasTempCode(PrtCode)
	q:((MARowID="")&&(IsHasID'=0))||((MARowID'="")&&(MARowID'=IsHasID)) -2
	s Ret=""
	i MARowID="" d
	.&sql(INSERT INTO DHC_PRTMain (MA_Code, MA_Desc, MA_Width, MA_Height, MA_CreateDate, MA_CreateTime, MA_Type,MA_LineNum) 
		VALUES (:PrtCode,:PrtDesc,:PrtWidth,:PrtHeight,:CreatorDate,:CreatorTime,:PrtType,:PrtLine))
	.s Ret=SQLCODE
	i MARowID'="" d
	.&sql(UPDATE DHC_PRTMain SET MA_Code=:PrtCode,MA_Desc=:PrtDesc,MA_Width=:PrtWidth,MA_Height=:PrtHeight,
		MA_CreateDate=:CreatorDate,MA_CreateTime=:CreatorTime,MA_Type=:PrtType ,MA_LineNum=:PrtLine
		WHERE MA_RowID=:MARowID)
	.s Ret=SQLCODE
	Q:Ret'=0
	S MARowID=$o(^DHCPRTMA(0,"Code",$$ALPHAUP^SSUTIL4(PrtCode),""))
	s hospflag=##Class(web.DHCADVCOMMON).SaveHOSP("DHC_PRTMain",MARowID,HospDr)
	q:hospflag'=0 -3
	q Ret
}

/// Creator:qqa
/// Descript:打印模板保存
/// w ##class(web.DHCPRTMain).JsonListPrtTemp()
ClassMethod JsonListPrtTemp(q, Type)
{
	n (q,Type)
	w "["
	s Count=0
	s MARowID=""
	f  s MARowID = $o(^DHCPRTMA(0,"IindexType",Type,MARowID)) q:MARowID=""  d
	.s MACode=$p(^DHCPRTMA(MARowID),"^",1)
	.
	.q:(q'="")&&(MACode'[q)
	.s Count=Count+1
	.s ItmData = MARowID_"^"_MACode
	.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",ItmData)
	w "]"
	q ""
}

/// Creator:qqa
/// Descript:打印模板保存
/// w ##class(web.DHCPRTMain).JsonList(60,1,"")
ClassMethod JsonList(rows As %String, page As %String, Code = "", Desc = "", HospDr)
{
	n (rows,page,Code,Desc,HospDr)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Count=0
	s ItmTitle="MARowID^MACode^MADesc^MAWidth^MAHeight^Type^LineNum"
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() 
	s MARowID=0
	f  s MARowID=$o(^DHCPRTMA(MARowID)) q:MARowID=""  d
	.s MACode=$p(^DHCPRTMA(MARowID),"^",1)
	.q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("DHC_PRTMain",MARowID,HospDr,"")'="Y"
	.q:(Code'="")&&(MACode'[Code)
	.s MADesc=$p(^DHCPRTMA(MARowID),"^",2)
	.q:(Desc'="")&&(MADesc'[Desc)
	.s MAWidth=$p(^DHCPRTMA(MARowID),"^",3)
	.s MAHeight=$p(^DHCPRTMA(MARowID),"^",4)
	.s Type=$p(^DHCPRTMA(MARowID),"^",7)
	.s LineNum=$p(^DHCPRTMA(MARowID),"^",8)
	.s Count=Count+1
	.
	.Q:(Count<Start)||(Count>End)
	.w $case(Count,Start:"",:",")
	.s ItmData = MARowID_"^"_MACode_"^"_MADesc_"^"_MAWidth_"^"_MAHeight_"^"_Type_"^"_LineNum
	.
	.W ##class(web.DHCEMJsonCommon).getJsonData(ItmTitle,ItmData)
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// Creator:qqa
/// Descript:打印模板获取
/// w ##class(web.DHCPRTMain).GetTmpData("9")
ClassMethod GetTmpData(MARowID, MACode = "")
{
	n (MARowID,MACode)
	q ..GetTmpDataNew(MARowID,MACode)
}

/// Creator:qqa
/// Descript:打印模板获取
/// w ##class(web.DHCPRTMain).GetTmpDataNew("55")
ClassMethod GetTmpDataNew(MARowID, MACode = "")
{
	n (MARowID,MACode)

	s:(MARowID="")&&(MACode'="") MARowID=$o(^DHCPRTMA(0,"Code",$$ALPHAUP^SSUTIL4(MACode),""))
	q:MARowID="" ""
	s MACode=$p(^DHCPRTMA(MARowID),"^",1)
	s MADesc=$p(^DHCPRTMA(MARowID),"^",2)
	s MAWidth=$p(^DHCPRTMA(MARowID),"^",3)
	s MAHeight=$p(^DHCPRTMA(MARowID),"^",4)
	s Type=$p(^DHCPRTMA(MARowID),"^",7)
	s Line=$p(^DHCPRTMA(MARowID),"^",8)
	
	
	;描述的数据量过于庞大。不再用变量存储，直接输出
	s StreamId=$p(^DHCPRTMA(MARowID),"^",9)
	
	if ((StreamId="")||($l(StreamId)>200)){
		q ##class(web.DHCPRTMain).GetTmoDataNoStream(MARowID, MACode)	
	}
	
	s ItmData = MARowID_"&&"_MACode_"&&"_MADesc_"&&"_MAWidth_"&&"_MAHeight_"&&"_Type_"&&"_Line	
	w ItmData_"&&"
	i (StreamId'=""){
		s StreamId=##Class(ext.util.String).Replace(StreamId,"$c(94)", "^")
		s StreamObject=##class(%GlobalCharacterStream).%Open(StreamId)
	
		while ('StreamObject.AtEnd){
			w StreamObject.Read()
		}
	}
	q ""
}

ClassMethod GetTmoDataNoStream(MARowID, MACode = "")
{
	n (MARowID,MACode)
	s:(MARowID="")&&(MACode'="") MARowID=$o(^DHCPRTMA(0,"Code",$$ALPHAUP^SSUTIL4(MACode),""))
	q:MARowID="" ""
	s MACode=$p(^DHCPRTMA(MARowID),"^",1)
	s MADesc=$p(^DHCPRTMA(MARowID),"^",2)
	s MAWidth=$p(^DHCPRTMA(MARowID),"^",3)
	s MAHeight=$p(^DHCPRTMA(MARowID),"^",4)
	s Type=$p(^DHCPRTMA(MARowID),"^",7)
	s Line=$p(^DHCPRTMA(MARowID),"^",8)
	
	
	s ItmData = MARowID_"&&"_MACode_"&&"_MADesc_"&&"_MAWidth_"&&"_MAHeight_"&&"_Type_"&&"_Line
	w ItmData_"&&"
	
	;描述的数据量过于庞大。不再用变量存储，直接输出
	s Sub=0
	f  s Sub=$o(^DHCPRTMA(MARowID,"I",Sub)) q:Sub=""  d
	.w $p(^DHCPRTMA(MARowID,"I",Sub),"^",1)
	;兼容老的主表存储
	i '$d(^DHCPRTMA(MARowID,"I")) d
	.w $p(^DHCPRTMA(MARowID),"^",9)
	.w $p(^DHCPRTMA(MARowID),"^",10)
	.w $p(^DHCPRTMA(MARowID),"^",11)
	.w $p(^DHCPRTMA(MARowID),"^",12)
	q ""
}

ClassMethod GetTmpDataNoPrintData(MARowID)
{
	q:MARowID="" ""
	s MACode=$p(^DHCPRTMA(MARowID),"^",1)
	s MADesc=$p(^DHCPRTMA(MARowID),"^",2)
	s MAWidth=$p(^DHCPRTMA(MARowID),"^",3)
	s MAHeight=$p(^DHCPRTMA(MARowID),"^",4)
	s Type=$p(^DHCPRTMA(MARowID),"^",7)
	s Line=$p(^DHCPRTMA(MARowID),"^",8)
	s Data = MARowID_"&&"_MACode_"&&"_MADesc_"&&"_MAWidth_"&&"_MAHeight_"&&"_Type_"&&"_Line
	q Data
}

/// Creator:qqa
/// Descript:Code是否已经存在
/// Return:	1:存在 0:不存在
/// w ##class(web.DHCPRTMain).IsHasTempCode("aaa")
ClassMethod IsHasTempCode(MACode)
{
	n (MACode)
	s MARowID=$o(^DHCPRTMA(0,"Code",$$ALPHAUP^SSUTIL4(MACode),""))
	q +MARowID
}

/// Creator:qqa
/// Descript:打印模板保存
/// w ##class(web.DHCPRTMain).GetTmpData()
ClassMethod SaveHtml(MARowID, MALineNum, MAWidth, Html = "", Html1 = "", Html2 = "", Html3 = "")
{
	n (MARowID,MALineNum,MAWidth,Html,Html1,Html2,Html3)
	s Ret=0
	ts
	s Ret=##class(web.DHCPRTMain).SaveHtmlMain(MARowID,MALineNum,MAWidth)
	tro:Ret'=0
	q:Ret'=0 Ret
	
	s Ret=##class(web.DHCPRTMain).DeleteHtmlItem(MARowID)
	tro:Ret'=0
	q:Ret'=0 Ret
	
	s Ret=##class(web.DHCPRTMain).SaveHtmlItem(MARowID,Html)
	tro:Ret'=0
	q:Ret'=0 Ret
	
	s:Html1'="" Ret=##class(web.DHCPRTMain).SaveHtmlItem(MARowID,Html1)
	tro:Ret'=0
	q:Ret'=0 Ret
	
	s:Html2'="" Ret=##class(web.DHCPRTMain).SaveHtmlItem(MARowID,Html2)
	tro:Ret'=0
	q:Ret'=0 Ret
	
	s:Html3'="" Ret=##class(web.DHCPRTMain).SaveHtmlItem(MARowID,Html3)
	tro:Ret'=0
	q:Ret'=0 Ret
	
	tc
	q Ret
}

/// Creator:qqa
/// Descript:打印模板保存
/// w ##class(web.DHCPRTMain).SaveHtmlNew(55,12,197,"qqa")
ClassMethod SaveHtmlNew(MARowID, MALineNum, MAWidth, Html = "")
{
	n (MARowID,MALineNum,MAWidth,Html)

	s StreamObject="",StreamId=""
	s:MARowID'="" StreamId=$p(^DHCPRTMA(MARowID),"^",9)
	
	i ($l(StreamId)<100)&&(StreamId'=""){
		s StreamId=##Class(ext.util.String).Replace(StreamId,"$c(94)", "^")
		s StreamObject=##class(%GlobalCharacterStream).%Open(StreamId)
	}
	i ('$IsObject(StreamObject)){
		s StreamObject=##class(%GlobalCharacterStream).%New()
	}
	
	i ('$IsObject(Html)){
		d StreamObject.Write(Html)
	}
	i ($IsObject(Html)){
		while('Html.AtEnd){
			s ItmHtml=Html.Read()
			d StreamObject.Write(ItmHtml)
		}
	}
	

	ts
	
	s Ret=StreamObject.%Save()
	tro:Ret'=1
	q:Ret'=1 "保存流数据错误!"
	
	s StreamId=StreamObject.GetStreamId()
	s StreamId=##Class(ext.util.String).Replace(StreamId,"^", "$c(94)")
	
	&sql(UPDATE DHC_PRTMain SET MA_LineNum=:MALineNum,MA_Width=:MAWidth,MA_Text=:StreamId WHERE MA_RowID=:MARowID)
	tro:SQLCODE'=0
	q:SQLCODE'=0 "保存主表数据错误!"
	
	tc
	q 0
}

/// Creator:qqa
/// Descript:打印模板保存
/// w ##class(web.DHCPRTMain).GetTmpData()
ClassMethod SaveHtmlMain(MARowID, MALineNum, MAWidth)
{
	n (MARowID,MALineNum,MAWidth)
	&sql(UPDATE DHC_PRTMain SET MA_LineNum=:MALineNum,MA_Width=:MAWidth WHERE MA_RowID=:MARowID)
	q SQLCODE
}

/// Creator:qqa
/// Descript:打印模板删除子表
/// w ##class(web.DHCPRTMain).DeleteHtmlItem()
ClassMethod DeleteHtmlItem(MARowID)
{
	n (MARowID)
	s Sub=$o(^DHCPRTMA(MARowID,"I",""),-1)+1
	q:Sub=1 0
	&sql(DELETE DHC_PRTMainItem WHERE MAI_ParRef_Dr =:MARowID)
	q SQLCODE
}

/// Creator:qqa
/// Descript:打印模板保存
/// w ##class(web.DHCPRTMain).GetTmpData()
ClassMethod SaveHtmlItem(MARowID, Html = "")
{
	n (MARowID,Html)
	s Sub=$o(^DHCPRTMA(MARowID,"I",""),-1)+1
	&sql(INSERT INTO DHC_PRTMainItem (MAI_ParRef_Dr,MAI_ChildSub,MAI_Text) VALUES (:MARowID,:Sub,:Html))
	q SQLCODE
}

/// Creator:qqa
/// Descript:打印模板删除
/// w ##class(web.DHCPRTMain).DelTmpData(5)
ClassMethod DelTmpData(MARowID)
{
	n (MARowID)
	&sql(DELETE DHC_PRTMain WHERE MA_RowID=:MARowID)
	s hospflag=##Class(web.DHCADVCOMMON).DeleteHospitals("DHC_PRTMain",MARowID)
	q:hospflag'=1 -3
	q SQLCODE
}

Storage Default
{
<Data name="DHCPRTMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPRTMainD</DataLocation>
<DefaultData>DHCPRTMainDefaultData</DefaultData>
<IdLocation>^web.DHCPRTMainD</IdLocation>
<IndexLocation>^web.DHCPRTMainI</IndexLocation>
<StreamLocation>^web.DHCPRTMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
