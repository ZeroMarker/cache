Class EMRservice.BL.BLEmrExportSectionData Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取模板数据结构
/// w ##Class(EMRservice.BL.BLEmrExportSectionData).exportSectionData("16","S005")
ClassMethod exportSectionData(aTemplateID As %String, aSectionCode As %String, aCtlocID As %String = "") As %GlobalBinaryStream
{
	s ItemsSet=##Class(%GlobalBinaryStream).%New()
	q:((aTemplateID="")||(aSectionCode="")) ItemsSet
	
	s rowTemver = ""
    for
    {
		s rowTemver = $o(^DHCEMRI.InstanceDataI("IdxListNoTemplateIDVersion",aTemplateID,rowTemver))
		q:(rowTemver="")
		s rowListNo = ""
		for
	    {
			s rowListNo = $o(^DHCEMRI.InstanceDataI("IdxListNoTemplateIDVersion",aTemplateID,rowTemver,rowListNo))
			q:(rowListNo ="")
			s ECRowID = ""
			for
		    {
				s ECRowID = $o(^DHCEMRI.InstanceDataI("IdxListNoTemplateIDVersion",aTemplateID,rowTemver,rowListNo,ECRowID))
				q:(ECRowID ="")
				s inRowID = ""
				for
			    {
					s inRowID = $o(^DHCEMRI.InstanceDataI("IdxListNoTemplateIDVersion",aTemplateID,rowTemver,rowListNo,ECRowID,inRowID))
					q:(inRowID ="")
					s instanceID = ECRowID _"||"_ inRowID
					
				 	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
					q:(objInstanceData = "")
					continue:((objInstanceData.Status = "UnSave")||(objInstanceData.Status = "Delete"))
					if (aCtlocID'="")
					{
						s auserID = objInstanceData.CreateUser
						s UserLocID=$p($g(^SSU("SSUSR",auserID)),"^",4)
						continue:(aCtlocID '= UserLocID)
					}
					

					s rowID = ""
					for
					{
						s rowID = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_instanceID," " _aSectionCode,rowID))
						q:(rowID = "")
						s objSection = ##Class(EMRinstance.ISectionDesc).%OpenId(rowID)
						q:(objSection ="")
						s strText = objSection.Text.Read(32000)
						;s strText = $zcvt(strText,"O","XML")
				    	;s strItem = $zcvt(strItem,"O","UTF8")  
						d ItemsSet.Write(strText)
						d ItemsSet.WriteLine("")
						d ItemsSet.WriteLine("")
					}
					
					
			    }
		    }
	    }
	}
	s strMeName =  "recordSectionExport"
	;d ItemsSet.OutputToDevice()
	d ..exPortToXml(ItemsSet,strMeName)
	q ItemsSet
}

// d ##Class(EMRservice.BL.BLEmrExportSectionData).exPortToXml("","12")

ClassMethod exPortToXml(sourceA As %AbstractStream, nameA As %String)
{
	s objstreamF=##class(%FileCharacterStream).%New()
	s objstreamF.Filename="D:\xml\"_nameA_"_.txt"
	d objstreamF.TranslateTableSet("UTF8")
	d objstreamF.CopyFrom(sourceA)
	d objstreamF.SaveStream()
	d objstreamF.%Close()
}

}
