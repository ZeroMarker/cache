/// 面向纳龙的接口
/// web.DHCEkg.NDEY.NL.Service4NaLong
Class web.DHCEkg.NDEY.NL.Service4NaLong Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "Service4NaLong";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Creator：      yyl
/// CreatDate：    2020-5-12
/// Modify: 	   
/// ModifyDate：   
/// Description:   通过数据文件名称查询数据处理结果
/// Input：        FileName:文件名称
/// Return：       
/// Others：
/// w ##class(web.DHCEkg.NDEY.NL.Service4NaLong).GetDataDealResult("<Request><FileName>1010_201805241329533843</FileName></Request>")
ClassMethod GetDataDealResult(paramInfo As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s $ZT="ERRORGetDealResult"
	new $namespace
	s CurrentSpace=$znspace
	s rtnStream=##class(%GlobalCharacterStream).%New()
	s response=##class(web.DHCEkg.NDEY.NL.Dict.Response).%New()
	s header=##class(web.DHCEkg.NDEY.NL.Dict.Header).%New()
	s header.MessageID=$system.Util.CreateGUID()
	s header.SourceSystem="EKG"
	s response.Header=header
	s body=##class(web.DHCEkg.NDEY.NL.Dict.Body).%New()
	s resultCode="-1"
	s resultContent="查询失败，未能成功解析入参"
	s ^tmpDHCEKG("GetDataDealResult",$zd($h,3),$p($zdt($h,3)," ",2),"param")=paramInfo
	s reader1=##class(%XML.Reader).%New()
	s sc1=reader1.OpenString(paramInfo)
	d reader1.Correlate("Request","web.DHCEkg.NDEY.NL.Dict.Request")
	
	while reader1.Next(.obj,.sc)
	{
		s FileName=obj.Body.FileName
		s ^tmpDHCEKG("GetDataDealResult",$zd($h,3),$p($zdt($h,3)," ",2),"FileName")=FileName
		b ; w FileName
		if (FileName'="")&&(FileName'=$c(0))
		{
			i FileName['".NLECG" s FileName=$p(FileName,".NLECG",1)
			i FileName['".info" s FileName=$p(FileName,".info",1)
			s FileName=$zcvt(FileName,"u")
			do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
			s recordId=""
			s recordId=$o(^dbo.tblRecord4NalongI("idxFileName"," "_FileName,recordId))
			if (recordId'="")
			{
				s recordInfo=$g(^dbo.tblRecord4NalongD(recordId))
				s DealResult=$listget(recordInfo,9)
				s Extend=$listget(recordInfo,10)
				i DealResult="处理成功" s resultCode="0"
				s resultContent=DealResult_"："_Extend
			}
			else
			{
				s resultContent="未查询到数据处理记录"
			}
			zn CurrentSpace
		}
		else
		{
			s resultContent="查询失败，入参文件名为空"
		}
	}
	s body.ResultCode=resultCode
	s body.ResultContent=resultContent
	s response.Body=body
	s Status=response.XMLExportToStream(.stream)						
	d rtnStream.MoveToEnd()
	d rtnStream.CopyFrom(stream)
	s ^tmpDHCEKG("GetDataDealResult",$zd($h,3),$p($zdt($h,3)," ",2),"rtn")=rtnStream.Read()
	d rtnStream.Rewind()
	b ; d rtnStream.OutputToDevice()
	q rtnStream
	
ERRORGetDealResult1
	Set ErrorMsg=$ZE
	s ^ERRORGetDealResult($zd($h,3),$zt($p($h,",",2)))=ErrorMsg
	
	s rtnStream=##class(%GlobalCharacterStream).%New()
	s obj=##class(web.DHCEkg.NDEY.Dict.Response).%New()
	s obj.ResultCode="-1"
	s obj.ResultContent="查询发生异常"
	s Status=obj.XMLExportToStream(.stream)						
	d rtnStream.MoveToEnd()
	d rtnStream.CopyFrom(stream)
	b ; d rtnStream.OutputToDevice()
	q rtnStream
	
ERRORGetDealResult
	s $ZT=""
	Set ErrorMsg=$ZE
	s ^ERRORGetDealResult($zd($h,3),$zt($p($h,",",2)))=ErrorMsg
	
	s rtnStream=##class(%GlobalCharacterStream).%New()
	d rtnStream.Write("<Response><Header><SourceSystem>EKG</SourceSystem><MessageID></MessageID></Header>")
	d rtnStream.Write("<Body><ResultCode>-1</ResultCode><ResultContent>查询发生异常</ResultContent></Body></Response>")
	
	b ; d rtnStream.OutputToDevice()
	q rtnStream
}

}
