Class DHCENS.LIS.GetAmountOfTube Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Response";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ErrorMsg As %String(TRUNCATE = 1);

/// 管子数量
Property Amount As %String(TRUNCATE = 1);

ClassMethod GetAmountOfTube(input As %String) As %GlobalCharacterStream
{
	s reqStream=..GetRequestStream(input)
	//调用第三方webservice
	s resultStream=""
	//解析webservice返回结果
	;s amount=..GetAmount(resultStream)
	s objStream=##class(%GlobalBinaryStream).%New()
	do objStream.Write(3)
	
	Quit objStream
}

ClassMethod GetLabCodeByOrdId(OrdID As %String) As %String
{
	s ArcimID=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",2)
	q:ArcimID="" ""
	s temord=$o(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),"EXT",""),-1)
	s ExtCode="",RetCode=""
	i (temord'="")
	{
		s ExtCode=$p(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),"EXT",temord),"^",4)
	
		i (ExtCode'="")
		{
			s RetCode=$p($g(^TTAB("TS",ExtCode)),"\",3)
		}
	}
	q RetCode
}

ClassMethod GetRequestStream(Rowids As %String) As %GlobalCharacterStream
{
	set RowidLen=$L(Rowids,"^")
	
	//产生向LIS发送请求的数据流
	s reqStream=##class(%GlobalCharacterStream).%New()
	do reqStream.Write("<Request><Orders>")
	
	for i=1:1:RowidLen
	{
		s rowid=$P(Rowids,"^",i)
		s LabCode=..GetLabCodeByOrdId(rowid)
		do reqStream.Write("<ArcimCode>")
		do reqStream.Write(LabCode)
		do reqStream.Write("</ArcimCode>")
	}
	
	do reqStream.Write("</Orders></Request>")

    Quit reqStream
}

ClassMethod GetAmount(Input As %GlobalBinaryStream) As %String
{
    Set Amount=""	
    Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Response","DHCENS.LIS.GetAmountOfTube")
	
	While reader.Next(.obj,.sc) 
	{
		Set Amount=obj.Amount
	}
	
	Quit Amount
}

}
