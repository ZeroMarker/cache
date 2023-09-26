Class CIS.AN.CA.AnySign Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action", 1), "")
	
	if (action="SaveSignInfo")
	{
		d ..SaveSignInfo()
	} 
	elseif (action="GetSequenceId") 
	{
		d ..GetSequenceId()
	} 
	elseif (action="GetAnySignLocation") 
	{
		d ..GetAnySignLocation()
	}
	else 
	{
		w ""
	}
	Quit $$$OK
}

/// s ^CF("CA","AnySignLocation")= "14.18.158.147:20943"
/// d ##Class(EMRservice.Ajax.anySign).GetAnySignLocation()
ClassMethod GetAnySignLocation()
{
	w "{""Value"":"""_$G(^CF("CA","AnySignLocation"))_"""}"
	q
}

/// d ##Class(EMRservice.Ajax.anySign).GetSequenceId()
ClassMethod GetSequenceId()
{
	s $zt = "Error"
	s ret = 1
	if $d(^CF("CA","HandSignSequenceId"))
	{
		s ret = ^CF("CA","HandSignSequenceId") + 1
		s ^CF("CA","HandSignSequenceId") = ret
	} 
	else
	{
		s ^CF("CA","HandSignSequenceId") = 1
	}
	w "{""Value"":"""_ret_"""}"
	q	
Error	
	w "{""Err"":"""_$zerror_"""}"
	q
}

ClassMethod SaveSignInfo() As %String
{
	 
	s $zt = "Error"
	
	s recordSheetId = $g(%request.Data("RecordSheet", 1), "")
	s signCode=$g(%request.Data("SignCode", 1), "")
	s algorithm = $g(%request.Data("Algorithm", 1), "")
	s bioFeature = ..getReqStream("BioFeature")
	s eventCert = $g(%request.Data("EventCert", 1), "")
	s sigValue = $g(%request.Data("SigValue", 1), "")
	s tsValue = $g(%request.Data("TSValue", 1), "")
	s version = $g(%request.Data("Version", 1), "")
 
	s signScript = ..getReqStream("SignScript")
	s headerImage = ..getReqStream("HeaderImage")
	s fingerprint = ..getReqStream("Fingerprint")
	
	s signData = ..getReqStream("SignData")
	s plainText = $g(%request.Data("PlainText", 1), "")
	s updateUser=$g(%request.Data("UpdateUser", 1), "")
	s ret = ..SaveAnySign(recordSheetId, signCode,updateUser,
			algorithm, eventCert, sigValue, tsValue, version, bioFeature , 
			signScript, headerImage, fingerprint, plainText,signData)
			
	w ret
	q 
Error	
	w "E^"_$ze
	q
}

ClassMethod SaveOpinionSignInfo() As %String
{
	 
	s $zt = "Error"
	
	s recordSheetId = $g(%request.Data("RecordSheet", 1), "")
	s signCode=$g(%request.Data("SignCode", 1), "")
 
	s signScript = ..getReqStream("SignScript")
	s updateUser=$g(%request.Data("UpdateUser", 1), "")
	s ret = ..SaveOpinionSign(recordSheetId, signCode,updateUser,signScript)
			
	w ret
	q 
Error	
	w "E^"_$ze
	q
}

ClassMethod SaveAnySign(recordSheetId As %String, signCode As %String, updateUser As %String, Algorithm As %String, EventCert As %String, SigValue As %String, TSValue As %String, Version As %String, BioFeature As %Stream, SignScript As %Stream, HeaderImage As %Stream, FingerPrint As %Stream, PlainText As %String, SignData As %Stream) As %String
{
	s $zt = "HandSignErr"
	tstart
	set anySignId=""
	&sql(select %ID into :anySignId from CIS_AN.PatSignature where RecordSheet=:recordSheetId and SignCode=:signCode and IsValid=1)
	if (##class(CIS.AN.PatSignature).%ExistsId(anySignId))
	{
		set anySign=##class(CIS.AN.PatSignature).%OpenId(anySignId)
		set anySign.IsValid=0
		set anySign.UpdateUser=updateUser
		set anySign.UpdateDate=+$h
		set anySign.UpdateTime=$p($h,",",2)
		set sc=anySign.%Save()
		if ($System.Status.IsError(sc))
		{
			trollback
			quit "E^"_$System.Status.GetErrorText(sc)	
		}	
	}
	s dt= $h
	s log = ##Class(CIS.AN.PatSignature).%New()
	s log.IsValid = 1
	
	s log.SignDate=+$h
	s log.SignTime=$p($h,",",2)
		
	s log.RecordSheet = ##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	s log.SignCode=signCode
	s log.Algorithm  = Algorithm
	d log.BioFeature.CopyFrom(BioFeature)
	s log.EventCert  = EventCert 
	s log.SignValue  = SigValue  
	s log.TSValue  = TSValue  
	s log.Version = Version
	
	//s log.SignScript  = SignScript
	//s log.FingerPrint  = FingerPrint
	d log.SignScript.CopyFrom(SignScript)
	d log.HeaderImage.CopyFrom(HeaderImage)
	d log.FingerImage.CopyFrom(FingerPrint)	 
	s log.HashData  = PlainText  
	s log.UpdateUser=updateUser
	s log.UpdateDate=+$h
	s log.UpdateTime=$p($h,",",2)
	
	//新增存储整个signdata
	d log.SignData.CopyFrom(SignData)	 
	
	s sc=log.%Save()
	if $$$ISERR(sc)
	{
		trollback
	 	q "E^"_$System.Status.GetErrorText(sc)
	}
	tcommit
	q "S^"_log.%Id()
	
HandSignErr
	trollback
	q "E^"_$ze
}

/// 保存患者批注笔迹
ClassMethod SaveOpinionSign(recordSheetId As %String, signCode As %String, updateUser As %String, SignScript As %Stream) As %String
{
	s $zt = "HandSignErr"
	tstart
	set anySignId=""
	&sql(select %ID into :anySignId from CIS_AN.PatSignature where RecordSheet=:recordSheetId and SignCode=:signCode and IsValid=1)
	if (##class(CIS.AN.PatSignature).%ExistsId(anySignId))
	{
		set anySign=##class(CIS.AN.PatSignature).%OpenId(anySignId)
		set anySign.IsValid=0
		set anySign.UpdateUser=updateUser
		set anySign.UpdateDate=+$h
		set anySign.UpdateTime=$p($h,",",2)
		set sc=anySign.%Save()
		if ($System.Status.IsError(sc))
		{
			trollback
			quit "E^"_$System.Status.GetErrorText(sc)	
		}	
	}
	s dt= $h
	s log = ##Class(CIS.AN.PatSignature).%New()
	s log.IsValid = 1
	
	s log.SignDate=+$h
	s log.SignTime=$p($h,",",2)
		
	s log.RecordSheet = ##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	s log.SignCode=signCode
	d log.SignScript.CopyFrom(SignScript) 
	s log.UpdateUser=updateUser
	s log.UpdateDate=+$h
	s log.UpdateTime=$p($h,",",2)	 
	
	s sc=log.%Save()
	if $$$ISERR(sc)
	{
		trollback
	 	q "E^"_$System.Status.GetErrorText(sc)
	}
	tcommit
	q "S^"_log.%Id()
	
HandSignErr
	trollback
	q "E^"_$ze
}

ClassMethod getReqStream(reqParamName) As %String
{
	s reqValue = $g(%request.Data(reqParamName,1),"")
	s reqStream = ##Class(%Library.GlobalCharacterStream).%New()
	q:(reqValue="") reqStream
	
	s clsReq = $e(reqValue,1,50)
	if ($f(clsReq,"CharacterStream")>1)
	{
		d reqStream.CopyFrom(reqValue)
	}
	else
	{
		d reqStream.Write(reqValue)
	}	
	q reqStream
}

/// d ##Class(EMRservice.Ajax.anySign).OutPutHandSignJS()
ClassMethod OutPutHandSignJS()
{
	s HandSign=$g(^CF("CA","HandSign"))
    q:("Y"'=HandSign)	
	
	s caCompany = $g(^CF("CA","CAHandSignCompany"))
	s:(caCompany = "") caCompany=##Class(CA.DigitalSignatureService).GetCACompany()	

	w "<script type='text/javascript' src='../scripts/emr/js/handSign_"_caCompany_".js'>",!
    w "</script>",!
}

ClassMethod GetAnySignImage(recordSheetId As %String, signCodeStr As %String) As %String
{
	set signCodeCount=$l(signCodeStr,","),readLen=1000
	for i=1:1:signCodeCount
	{
		set signCode=$p(signCodeStr,",",i)
		set signImage="",fingerImage="",anySignId=""
		&sql(select %ID into :anySignId from CIS_AN.PatSignature where RecordSheet=:recordSheetId and SignCode=:signCode and IsValid=1)
		if (##class(CIS.AN.PatSignature).%ExistsId(anySignId))
		{
			w signCode_$c(0)
			set anySign=##class(CIS.AN.PatSignature).%OpenId(anySignId)
			do anySign.SignScript.Rewind()
			while(anySign.SignScript.AtEnd=0)
			{
				w anySign.SignScript.Read(.readLen)	
			}
			w $c(0)	
			do anySign.FingerImage.Rewind()
			while(anySign.FingerImage.AtEnd=0)
			{
				w anySign.FingerImage.Read(.readLen)	
			}
		}
		else
		{
			w signCode_$c(0)_signImage_$c(0)_fingerImage	
		}
		
		w:(i'=signCodeCount) $c(1)
	}
	
	quit ""
}

ClassMethod TestDemo() As %String
{
	w "Test测试"
}

}
