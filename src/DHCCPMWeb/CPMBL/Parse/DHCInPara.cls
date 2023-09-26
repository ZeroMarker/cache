/// 解析XML格式的数据
Class DHCCPMWeb.CPMBL.Parse.DHCInPara Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod IPToTMPG(DataType As %String, IPData, ExpStr As %String) As %String
{
	;s mystr="<Code>12</Code>"
	;w ##class(DHCCPMWeb.CPMBL.Parse.DHCInPara).IPToTMPG("String",mystr,"")
	;w ##class(DHCCPMWeb.CPMBL.Parse.DHCInPara).IPToTMPG("File",mystr,"")
	n (DataType,IPData, ExpStr)
	
	s myrtn=..KTMP()
	
	if (DataType="String"){
		s myobj=##class(DHCCPMWeb.CPMBL.Parse.DHCIPByString).%New()
	}elseif(DataType="Stream"){
		s myobj=##class(DHCCPMWeb.CPMBL.Parse.DHCIPByStream).%New()
	}elseif(DataType="File"){
		s myobj=##class(DHCCPMWeb.CPMBL.Parse.DHCIPByFile).%New()
	}else{
		s myobj=##class(DHCCPMWeb.CPMBL.Parse.DHCIPByString).%New()
	}
	
	s myrtn=myobj.InParaToTMP(IPData)
	
	q myrtn
}

Method InParaToTMP(IPData) As %String
{
	b	;;;Para
	q 0
}

ClassMethod KTMP() As %String
{
	;d ##class(DHCCPMWeb.CPMBL.Parse.DHCInPara).KTMP()
	k ^TMPCPMPrintPara($j,"IP")
	;
	k ^TMPCPMPrintPara($j,"IP", "COMDT")
	
	q 0
}

Method XMLDeserialize(XMLStr As %String) As %String
{
	;DHCCPMWeb.CPMSevice.entity.IPParas
	n (XMLStr)
	
	s myrtn=0
	
	s myobj=##class(DHCCPMWeb.CPMSevice.entity.IPParas).%New()
	
	d myobj.XMLNodeDeserialize(.myobj, "IPParas",XMLStr)
	
	s myCount = myobj.IPPara.Count()
	
	f i=1:1:myCount {
		s mypara=myobj.IPPara.GetAt(i)
		s myEName=mypara.EName
		s myEValue=mypara.EValue

		if (myEValue=$c(0))
		{
			s myEValue=""
		}
		
		///如果是时间类型的
		//if (mypara.EDataType="string")
		//{
		//}
		///如果是时间类型的
		if ($ZConvert(mypara.EDataType, "U")="TIME")
		{
			if (myEValue[":")
			{
				s myEValue= $zth(myEValue)
			}
		}
		///日期类型
		if ($ZConvert(mypara.EDataType, "U")="DATE")
		{
			if (myEValue["-")
			{
				s myEValue= $zdh(myEValue,3)
			}
			if (myEValue["/")
			{
				s myEValue=$zdh(myEValue, 4)
			}
		}
		
		
		if (myEName'=""){
			s ^TMPCPMPrintPara($j,"IP",myEName)=myEValue
		}
		d mypara.%Close()
	}
	d myobj.%Close()
	
	q myrtn
}

Method XMLDeserializeOld(ByRef reader As %XML.TextReader) As %String
{
	;^TMPCPMPrintPara($j,"")=""
	s myrtn=0
	
	while reader.Read()
	{
		if ((reader.NodeType = "element")&(reader.Name="TxtPara"))
		{
			s myName=reader.Name
			if (reader.AttributeCount'=0){
				s myEName=""
				s myEValue=""
				if reader.MoveToAttributeName("EName"){
					s myEName=reader.Value
				}
				
				if reader.MoveToAttributeName("EValue"){
					s myEValue=reader.Value
					if (myEValue["-")
					{
						s myEValue= $zdh(myEValue,3)
					}
					if (myEValue["/")
					{
						s myEValue=$zdh(myEValue, 4)
					}
				}
				if (myEName'=""){
					s ^TMPCPMPrintPara($j,"IP",myEName)=myEValue
				}
			}
		}
		
	 	if (reader.NodeType = "endelement")
	 	{
		 	
		}
		if (reader.NodeType="chars")
		{
			
		}
	}
	q myrtn
}

}
