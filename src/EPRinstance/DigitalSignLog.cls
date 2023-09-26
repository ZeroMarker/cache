/// 电子病历数字签名扩展记录
Class EPRinstance.DigitalSignLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

// 签名是否有效，保存，更新模板，选择模板都会导致失效

Property SignID As %String(TRUNCATE = 1);

Property UsrID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property PrintDocID As %String(TRUNCATE = 1);

Property EPRNum As %String(TRUNCATE = 1);

Property InsIDs As %String(TRUNCATE = 1);

Property ContentHash As %String(TRUNCATE = 1);

Property IsValid As %Boolean;

Index Idx On (EpisodeID, PrintDocID, EPRNum);

/// 取最后一次签名
ClassMethod GetLastSign(episodeID As %String, printDocID As %String, eprNum As %String) As %String
{
	s id=""
	s id=$O(^DHCEPRI.DigitalSignLogI("Idx", " "_episodeID, " "_printDocID, " "_eprNum, id), -1)
	q id
}

/// EPRinstance.DigitalSignLog
ClassMethod GetValidSign(episodeID As %String, printDocID As %String, eprNum As %String) As %String
{
	s id=..GetLastSign(episodeID, printDocID, eprNum)
	q:""=id ""
	s log=##Class(EPRinstance.DigitalSignLog).%OpenId(id)
	q:(log.IsValid=0) ""
	q id
}

ClassMethod SetSignUnvalid(signLogID As %String)
{
	s log=##Class(EPRinstance.DigitalSignLog).%OpenId(signLogID)
	s id=""
	s episodeID=log.EpisodeID
	s printDocID=log.PrintDocID
	s eprNum=log.EPRNum
	s log=""
	for {
		s id=$O(^DHCEPRI.DigitalSignLogI("Idx", " "_episodeID, " "_printDocID, " "_eprNum, id), -1)
		q:(id="") 
		//w id,!
		s log=##Class(EPRinstance.DigitalSignLog).%OpenId(id)
		if (log '= "")
		{
			s log.IsValid=0
			d log.%Save()
			s log=""
		}
	}
	d ##Class(EPRservice.BLHandWrittenSign).SetSignUnvalid(episodeID, printDocID, eprNum)
}

/// 查询病历签名值的状态
/// 0 无签名；1 有效签名；2签名失效
ClassMethod GetSignStatus(episodeID As %String, printDocID As %String, eprNum As %String) As %String
{
	s id=..GetLastSign(episodeID, printDocID, eprNum)
	q:""=id "0"
	s log=##Class(EPRinstance.DigitalSignLog).%OpenId(id)
	q:(log.IsValid=0) "2"
	q "1"
}

/// 取指定用户对指定病历的最后一次签名
ClassMethod GetUsrLastSignedDateTime(episodeID As %String, printDocID As %String, eprNum As %String, usrID As %String) As %String
{
	s result=""
	s id=""
	for {
		s id=$O(^DHCEPRI.DigitalSignLogI("Idx", " "_episodeID, " "_printDocID, " "_eprNum, id), -1)
		q:(id="") 				
		s log=##Class(EPRinstance.DigitalSignLog).%OpenId(id)
		if (usrID=log.UsrID) 
		{
			s SignID=log.SignID
			s log=""
			s Signature=##Class(CA.DigitalSignature).%OpenId(SignID) 
			s result=$zd(Signature.CreateDate,3)_" "_$zt(Signature.CreateTime,1)
			s Signature=""
			q
		}
	}
	q result
}

/// d ##Class(EPRinstance.DigitalSignLog).Test()
ClassMethod Test()
{
	w ##Class(EPRinstance.DigitalSignLog).GetUsrLastSignDateTime(201869,-1,1,5872)
	//w $O(^EPRI.DigitalSignLogI("Idx", " 201869", " -1", " 1", 4), -1)
}

/// 之前的数据有问题，请执行此方法来补全数据
/// 请确认之前的数据时保存在^EPRI，而非^DHCEPRI
///  d ##Class(EPRinstance.DigitalSignLog).handleOleData()
ClassMethod handleOleData()
{
	s id=""
	for {
		s id=$O(^EPRI.DigitalSignLogD(id))
		q:(id="") 
		w id,!
		s log=##Class(EPRinstance.DigitalSignLog).%OpenId(id)
		if (log '= "")
		{
			if (2=$Length(log.PrintDocID, "^"))
		    {
			    s printDocID=log.PrintDocID
			    s log.PrintDocID = $Piece(printDocID, "^",1)
				s log.EPRNum = $Piece(printDocID, "^",2)
			}
			
			if (($C(0)=log.InsIDs)||(""=log.InsIDs))
			{
				s log.InsIDs=##Class(EPRservice.BLDigitalSignature).GetInstanceIDs(log.UsrID, log.PrintDocID, log.EpisodeID) 
			}
			d log.%Save()
			s log=""
		}
	}
}

Storage Default
{
<Data name="DigitalSignLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ContentHash</Value>
</Value>
<Value name="3">
<Value>InsIDs</Value>
</Value>
<Value name="4">
<Value>PrintDocID</Value>
</Value>
<Value name="5">
<Value>SignID</Value>
</Value>
<Value name="6">
<Value>EpisodeID</Value>
</Value>
<Value name="7">
<Value>UsrID</Value>
</Value>
<Value name="8">
<Value>EPRNum</Value>
</Value>
<Value name="9">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.DigitalSignLogD</DataLocation>
<DefaultData>DigitalSignLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.DigitalSignLogD</IdLocation>
<IndexLocation>^DHCEPRI.DigitalSignLogI</IndexLocation>
<StreamLocation>^DHCEPRI.DigitalSignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
