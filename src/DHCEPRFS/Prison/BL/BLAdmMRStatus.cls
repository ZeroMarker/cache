Class DHCEPRFS.Prison.BL.BLAdmMRStatus Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod UpdateEpisodeInfo(ADate As %String) As %String
{
	q:(ADate = "")
	s date = $zdh(ADate,3)
	s PAAdm =""
	for {
		s PAAdm = $o(^PAADMi("PAADM_AdmDate",date,PAAdm))
		q:(PAAdm = "")
		s patientID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(PAAdm)
		q:(patientID = "")
		s socialStatusID = $p($g(^PAPER(patientID,"PER",1)),"^",10)
		continue:(socialStatusID '=2)
		//是否是取消的就诊
		s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetVisitStatusByEpisode(PAAdm)
		continue:(flag = "c")
		continue:(flag = "C")
		s paadmType = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(PAAdm)
		s:(paadmType '= "") paadmType = $p(paadmType,"^",1)
		s paadmType = $ZCVT(paadmType,"U")
		continue:(paadmType = "I")
		d ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(PAAdm,"DHC")
		d ##class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",PAAdm,"50","","N","","","")
		
	}
	
	s episodeID = ""
	for {
		s episodeID = $o(^PAADMi("DischDate",date,episodeID))
		q:(episodeID = "")
		s patientID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(episodeID)
		q:(patientID = "")
		s socialStatusID = $p($g(^PAPER(patientID,"PER",1)),"^",10)
		continue:(socialStatusID '=2)
		//是否是取消的就诊
		s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetVisitStatusByEpisode(episodeID)
		continue:(flag = "c")
		continue:(flag = "C")
		s paadmType = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(episodeID)
		s:(paadmType '= "") paadmType = $p(paadmType,"^",1)
		s paadmType = $ZCVT(paadmType,"U")
		continue:(paadmType '= "I")
		d ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(episodeID,"DHC")
		d ##class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",episodeID,"50","","N","","","")
	}
}

}
