Class web.DHCENS.STBLL.DOCU.METHOD.HOSDocumentContent Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod DocumentContent(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set documentContent=##class(%GlobalCharacterStream).%New()	
	d documentContent.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	if $p(Input,"^",1)="门诊病历" {
		set argOutMessage=##Class(%GlobalCharacterStream).%New()		
		set argInMessage=##Class(%GlobalCharacterStream).%New()
		d argInMessage.CopyFrom($p(Input,"^",2))		
		set argOutData=##Class(%GlobalCharacterStream).%New()		
		set RetrnValue = ##Class(EMRservice.BIEMRService).EMRDocumentSDServer(argInMessage,argOutMessage,.argOutData)
		d documentContent.CopyFrom(argOutData)
	}
	elseif $p(Input,"^",1)="00" {
		set stream=##class(web.DHCENS.STBLL.RIS.METHOD.ReportResult).GetReportInfo($p(Input,"^",2))
		d documentContent.CopyFrom(stream)
	}
	elseif $p(Input,"^",1)="99" {
		set stream=##class(web.DHCENS.STBLL.LIS.METHOD.ReportResult).LISReportResult($p(Input,"^",2))
		d documentContent.CopyFrom(stream)
	}
	elseif $p(Input,"^",1)="43" {
		// 获取文档头信息
		d documentContent.Write("<clinicalDocument>")
		set headerStream=##class(%GlobalCharacterStream).%New()
		set headerStream=##class(web.DHCENS.STBLL.EMR.METHOD.documentHeader).documentHeader($p(Input,"^",2))
		d documentContent.CopyFrom(headerStream)
		// 医政获取病案首页主体信息
		set stream= ##class(DHCMRQ.IO.ToEnsByMed).GetMQFrontPage("Coding","415807818",$p(Input,"^",2))
		d documentContent.CopyFrom(stream)
		d documentContent.Write("</clinicalDocument>")
	}
	
	Quit documentContent
Exception
	set documentContent=##class(%GlobalCharacterStream).%New()
	d documentContent.Write("-1^"_$ze)
	Quit documentContent
}

}
