Class web.DHCENS.STBLL.EMPI.METHOD.PaCard Extends (%RegisteredObject, %XML.Adaptor)
{

/// test: w ##class(web.DHCENS.STBLL.EMPI.METHOD.PaCard).PaCardByRegNo("0000000040")
ClassMethod PaCardByRegNo(RegNo As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set patRowId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),""))
	set CardRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",patRowId,""),-1)
	set stream=##class(%GlobalCharacterStream).%New()
	if CardRowID'="" {
		set stream=..PaCard(CardRowID)
	}
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// 服务编码	T0005
/// 服务名称	建卡
/// 服务所在类	web.DHCENS.STBLL.EMPI.METHOD.PaCard
/// 方法名称	CreateCard
/// 方法入参	卡号
/// 2016-06-14   lipan
/// test: w ##class(web.DHCENS.STBLL.EMPI.METHOD.PaCard).PaCard("43507")
ClassMethod PaCard(CFRowid As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PaCard).%New()
	
#;	s CFRowid=$o(^DHCCARDi("CF",0,"CardNo",$g(CardNo),""))
	if ((CFRowid="")||($d(^DHCCARD("CF",CFRowid))=0)){
		d body.CreateCards.Insert(Obj)
		set request.body=body
		do request.XMLExportToStream(.stream)
		quit stream
	}
	
	s patRowId=$p($g(^DHCCARD("CF",CFRowid)),"^",4)
    s Obj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
    s cardTypeDr=$p($g(^DHCCARD("CF",CFRowid)),"^",16)
	s:cardTypeDr'="" Obj.PATCardType=$p(^DHCCARDTYPEDef(cardTypeDr),"^",2)
	s Obj.PATCardNum=$p($g(^DHCCARD("CF",CFRowid)),"^",2)
	s userid=$p($g(^DHCCARD("CF",CFRowid)),"^",9)
	s:userid'="" Obj.UpdateUserCode=$p($g(^SSU("SSUSR",userid)),"^",2)
	s Update=$p($g(^DHCCARD("CF",CFRowid)),"^",7)
	s:Update'="" Obj.UpdateDate=$zd(Update,3)
	s UpTime=$p($g(^DHCCARD("CF",CFRowid)),"^",8)
	s:UpTime'="" Obj.UpdateTime=$zt(UpTime,1)

	d body.CreateCards.Insert(Obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
