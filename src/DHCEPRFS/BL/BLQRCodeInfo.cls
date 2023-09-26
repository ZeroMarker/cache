Class DHCEPRFS.BL.BLQRCodeInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:获得QR码中信息的所有备选项列表
/// Debuger:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQRCodeInfo","GetQRCodeInfo")
Query GetQRCodeInfo() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Description:%String,ClassName:%String,ClassProperty:%String,ClassPropertyType:%String,Enable:%String,Sequence:%Integer,CustemNoteInfo:%String")
{
	SELECT ID,Name,Description,ClassName,ClassProperty,ClassPropertyType,Enable,Sequence,CustemNoteInfo
	FROM DHCEPRFS_META.QRCodeInfo
	ORDER BY Sequence
}

/// debug: w ##class(DHCEPRFS.BL.BLQRCodeInfo).GetContent("20","4")
ClassMethod GetContent(AMREpisodeID, AMRItemID) As %String
{
	s content = ""
	s sequence = ""
	for {
		s sequence = $O(^DHCEPRFS.META.QRCodeInfoI("IdxEnableSequence"," TRUE",sequence))	
		q:(sequence="")
		s rowId = ""
		s rowId = $o(^DHCEPRFS.META.QRCodeInfoI("IdxEnableSequence"," TRUE",sequence,rowId))
		continue:(rowId = "")
		s obj = ##Class(DHCEPRFS.META.QRCodeInfo).%OpenId(rowId)
		continue:(obj = "")
		
		s className = obj.ClassName
		s classProperty = obj.ClassProperty
		s classPropertyType = obj.ClassPropertyType
		//s description = obj.Description
		s description = ""
		s contentOne = ..GetInfo(AMREpisodeID,AMRItemID,className,classProperty)
		if (classPropertyType = "Date")
		{
			s contentOne = $zd(contentOne,3)	
		}
		elseif (classPropertyType = "Time")
		{
			s contentOne = $zt(contentOne,3)	
		}
		if (content = "")
		{
			//s content = description_":"_contentOne
			s content = description_" "_contentOne
		}
		else
		{
			//s content = content_" "_description_":"_contentOne	
			s content = content_" "_description_" "_contentOne	
		}
	}
	q content
}

/// debug: w ##class(DHCEPRFS.BL.BLQRCodeInfo).GetInfo("2","11","DHCEPRFS.META.MRItem","Name")
/// debug: w ##class(DHCEPRFS.BL.BLQRCodeInfo).GetInfo("2","11","FilePath","FileLocalPath")
ClassMethod GetInfo(AMREpisodeID As %String, AMRItemID As %String, AClassName As %String, AClassProperty As %String) As %String
{
	if (AClassName = "DHCEPRFS.INST.MREpisode")
	{
		s cmdObj="obj=##class("_AClassName_").%OpenId("_AMREpisodeID_")"
    	s @cmdObj	
		s cmdProperty="obj."_AClassProperty 
		q @cmdProperty	
	}
	elseif (AClassName = "DHCEPRFS.INST.MRPatient")
	{
		s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
		s mrPatientID = objEpisode.MRPatientID
		s cmdObj="obj=##class("_AClassName_").%OpenId("_mrPatientID_")"
    	s @cmdObj	
		s cmdProperty="obj."_AClassProperty 
		q @cmdProperty 	
	}
	elseif (AClassName = "DHCEPRFS.META.MRItem")
	{
		s cmdObj="obj=##class("_AClassName_").%OpenId("_AMRItemID_")"
    	s @cmdObj	
		s cmdProperty="obj."_AClassProperty 
		q @cmdProperty 				
	}
	elseif (AClassName = "FilePath")
	{
		if (AClassProperty = "FileLocalPath")
		{
			q "$LocalPath$"	
		}
		elseif (AClassProperty = "FileMasterPath")
		{
			q "$MasterPath$"	
		}	
	}
	elseif (AClassName = "CustemNote")
	{
		s rowID = ""
		s rowID = $o(^DHCEPRFS.META.QRCodeInfoI("IdxClassName"," "_$zcvt(AClassName,"U")," "_$zcvt(AClassProperty,"U"),rowID))
		q:(rowID = "")
			
		s obj = ##class(DHCEPRFS.META.QRCodeInfo).%OpenId(rowID)
		q obj.CustemNoteInfo
	}
}

ClassMethod AddRow(AName As %String, ADescription As %String, AClassName As %String, AClassProperty As %String, AClassPropertyType As %String, ACustemNoteInfo As %String = "") As %String
{
	s maxSequence = $O(^DHCEPRFS.META.QRCodeInfoI("IdxSequence",""),-1)
	if (maxSequence = "" || maxSequence < 1)
	{
		s maxSequence = 0	
	}
	
	s obj = ##Class(DHCEPRFS.META.QRCodeInfo).%New()
	s obj.Name = AName
	s obj.Description = ADescription
	s obj.ClassName = AClassName
	s obj.ClassProperty = AClassProperty
	s obj.ClassPropertyType = AClassPropertyType
	s obj.Enable = "TRUE"
	s obj.CustemNoteInfo = ACustemNoteInfo
	s obj.Sequence = maxSequence + 1
	s sc = obj.%Save()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

ClassMethod UpdateRow(AID As %String, AName As %String, ADescription As %String, AClassName As %String, AClassProperty As %String, AClassPropertyType As %String, ACustemNoteInfo As %String = "") As %String
{
	s obj = ##Class(DHCEPRFS.META.QRCodeInfo).%OpenId(AID)
	s obj.Name = AName
	s obj.Description = ADescription
	s obj.ClassName = AClassName
	s obj.ClassProperty = AClassProperty
	s obj.ClassPropertyType = AClassPropertyType
	s obj.CustemNoteInfo = ACustemNoteInfo
	s sc = obj.%Save()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

ClassMethod DeleteRow(AID As %String) As %String
{
	s obj = ##Class(DHCEPRFS.META.QRCodeInfo).%OpenId(AID)
	s sequence = obj.Sequence
	d obj.%Close()
	s status = ##Class(DHCEPRFS.META.QRCodeInfo).%DeleteId(AID)
	s count = "0"
	
	//更新此项后其他项的sequence
	s rowId = ""
	for {
		s sequence = $O(^DHCEPRFS.META.QRCodeInfoI("IdxSequence",sequence))
		q:(sequence="")
		s rowId = $o(^DHCEPRFS.META.QRCodeInfoI("IdxSequence",sequence,rowId))
		continue:(rowId = "")
		s objBehind = ##Class(DHCEPRFS.META.QRCodeInfo).%OpenId(rowId)
		continue:(objBehind = "")
		
		s objBehind.Sequence = objBehind.Sequence - 1
		s status = objBehind.%Save()
		s:($$$ISOK(status)) count = "1"
		d objBehind.%Close()
	}
	q count
}

ClassMethod EnableRow(AID As %String) As %String
{
	s obj = ##Class(DHCEPRFS.META.QRCodeInfo).%OpenId(AID)
	s obj.Enable = "TRUE"
	s sc = obj.%Save()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

ClassMethod DisableRow(AID As %String) As %String
{
	s obj = ##Class(DHCEPRFS.META.QRCodeInfo).%OpenId(AID)
	s obj.Enable = "FALSE"
	s sc = obj.%Save()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

/// debug: w ##class(DHCEPRFS.BL.BLQRCodeInfo).MoveDownRow("7")
ClassMethod MoveDownRow(AID As %String) As %String
{
	s obj = ##Class(DHCEPRFS.META.QRCodeInfo).%OpenId(AID)
	s sequence = obj.Sequence
	
	//更新此项后的一项，和后面项互换sequence
	s rowIdBehind = $o(^DHCEPRFS.META.QRCodeInfoI("IdxSequence",(sequence + 1),""))
	if (rowIdBehind '= "")
	{
		s objBehind = ##Class(DHCEPRFS.META.QRCodeInfo).%OpenId(rowIdBehind)	
		s objBehind.Sequence = objBehind.Sequence - 1
		s status = objBehind.%Save()
		d objBehind.%Close()
	}
	s obj.Sequence = sequence + 1
	s sc = obj.%Save()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

/// debug: w ##class(DHCEPRFS.BL.BLQRCodeInfo).MoveUpRow("7")
ClassMethod MoveUpRow(AID As %String) As %String
{
	s obj = ##Class(DHCEPRFS.META.QRCodeInfo).%OpenId(AID)
	s sequence = obj.Sequence
	
	//更新此项前一项，和后面项互换sequence
	s rowIdFront = $o(^DHCEPRFS.META.QRCodeInfoI("IdxSequence",(sequence - 1),""))
	if (rowIdFront '= "")
	{
		s objFront = ##Class(DHCEPRFS.META.QRCodeInfo).%OpenId(rowIdFront)	
		s objFront.Sequence = objFront.Sequence + 1
		s status = objFront.%Save()
		d objFront.%Close()
	}
	s obj.Sequence = sequence - 1
	s sc = obj.%Save()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

}
