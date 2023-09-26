Class EMRservice.BL.AnySignLog Extends %RegisteredObject
{

/// w ##Class(EMRservice.BL.AnySignLog).GetValidSignID("25||577")	
ClassMethod GetValidSignID(InsID As %String) As %String
{
	s result = ""
	q:(InsID="") result
	s id = ""
	for{
		s id = $O(^DHCEMRI.AnySignLogI("IdxInsID", " "_InsID, id))
		q:(id="")
		s log = ##Class(EMRinstance.AnySignLog).%OpenId(id)
		if (log.IsValid=1)
		{
			s result = id
			q
		}		
	}
	q result
}

/// d ##Class(EMRservice.BL.AnySignLog).RevokeSign()
ClassMethod RevokeSign(InsID As %String)
{
	s result = ""
	q:(InsID="")
	s id = ""
	for
	{
		s id = $O(^DHCEMRI.AnySignLogI("IdxInsID", " "_InsID, id),-1)
		q:(id="")
		s log = ##Class(EMRinstance.AnySignLog).%OpenId(id)
		if (log.IsValid=1)
		{
			s log.IsValid=0
			d log.%Save()
		} 
		else 
		{
			q
		}	
	}
}

ClassMethod SaveSignInfo(InsID As %String, Algorithm As %String, EventCert As %String, SigValue As %String, TSValue As %String, Version As %String, BioFeature As %Stream, SignScript As %Stream, HeaderImage As %Stream, FingerPrint As %Stream, PlainText As %String, SignData As %Stream) As %String
{
	s $zt = "HandSignErr"
	
	s dt= $h
	s log = ##Class(EMRinstance.AnySignLog).%New()
	s log.IsValid = 1
	
	s log.CreateDate = $P(dt, "," , 1) 
	s log.CreateTime = $P(dt, "," , 2)
	s log.UpdateDate = $P(dt, "," , 1)
	s log.UpdateTime = $P(dt, "," , 2)
		
	s log.InsID = InsID

	s log.Algorithm  = Algorithm 
	//s log.BioFeature  = BioFeature
	d log.BioFeature.CopyFrom(BioFeature)
	s log.EventCert  = EventCert 
	s log.SigValue  = SigValue  
	s log.TSValue  = TSValue  
	s log.Version = Version
	
	//s log.SignScript  = SignScript
	//s log.FingerPrint  = FingerPrint
	d log.SignScript.CopyFrom(SignScript)
	d log.HeaderImage.CopyFrom(HeaderImage)
	d log.FingerPrint.CopyFrom(FingerPrint)	 
	s log.PlainText  = PlainText  
	
	//新增存储整个signdata
	d log.SignData.CopyFrom(SignData)	 
	
	s sc=log.%Save()
	if $$$ISERR(sc)
	{
	 	q "-1"
	}
	q log.%Id()
	
HandSignErr
	q "-1"
}

/// desc: 取ca签名 签名值和时间戳
/// create: duan
/// input: signID  CA.DigitalSignature表ID
/// debug:w ##Class(EMRservice.Ajax.anySign).GetCASignDetailByID(3176575)
ClassMethod GetCASignDetailByID(ASignID As %String)
{
	s result=""
	q:ASignID="" result
	s CAObj = ##class(CA.DigitalSignature).%OpenId(ASignID)
	q:CAObj="" result
	//签名值
	s signValue=CAObj.SignValue
	//时间戳
	s signTimeStamp=CAObj.SignTimeStamp
	s result = result_"{"
	s result = result_"""SignValue"":"""_signValue_""","
	s result = result_"""SignTimeStamp"":"""_signTimeStamp_""""
	s result = result_"}"
	s result = "["_result_"]"
	q result
}

}
