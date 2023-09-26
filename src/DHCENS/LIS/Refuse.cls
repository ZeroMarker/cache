Class DHCENS.LIS.Refuse Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "RefuseReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

ClassMethod Refuse(inputs As %String) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s obj=##class(DHCENS.LIS.Refuse).%New()
    s Len=$L(inputs,"/")   
    for i=1:1:Len
    {
	    s input=$P(inputs,"/",i)
        s RowId=$P(input,"^",2)
        s RowId=##class(DHCENS.Method.BaseMethod).ReplaceStr(RowId,"_","||")
        ;s LabNo=$P(input,"^",1)
        s RefuseReason=$P(input,"^",3)
        s ExeInfo=$P(input,"^",4)
   		;传入的检验号有可能是第三方的检验号，而HIS中处理的是自己的检验号，所以统一传统HIS检验号
   		s LabNo = $P($g(^OEORD(+RowId,"I",$P(RowId,"||",2),3)),"^",20)
   		;先根据医嘱去的医嘱的外部代码，再根据医嘱外部代码去的LIS的检验项目代码（第三方的医嘱码）
   		s ExtCode=##class(DHCIntergration.OLISInfoCommon).GetEXTCodebyOrdId(RowId)
   		s TSCode=$p($g(^TTAB("TS",ExtCode)),"\",3)
   		s flag=##class(DHCIntergration.ILISOrderControl).RejectSample(LabNo,TSCode,RefuseReason,ExeInfo) 
     	q:flag'=0
    }

    if (flag=0)
    {
	    s obj.ResultCode="0"
	    s obj.ResultContent="成功"
    }
    else
    {
	    s obj.ResultCode=flag
	    s obj.ResultContent="失败"
	}
    
	d obj.XMLExportToStream(.Xml)
	s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
	q objStream
	
SendMessageET
    tro
    zn "dhc-app"
    s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response><RefuseReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.LIS.Refuse程序异常</ResultContent></RefuseReturn></Response>")
	q objStream
}

}
