/// <H3>为TimeLine提供明细数据</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建者：2012-08-17</H4>
Class DHCMed.CCService.IntegratedCtrl.TimeLineService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Close(objResult As DHCMed.CC.CtlResult, XDate As %String, XTime As %String)
{
	New (objResult,XDate,XTime)
	Set return=0
	Quit:(XDate="")||(XTime="") return
	Quit:'$IsObject(objResult) return
	
	Set $ZT="CloseErr"
	
	Set return="-100"
	Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(objResult.KeyWord)
	Quit:'$IsObject(objKeyword) return
	
	Set return="-200"
	Set DataTypeCode=objKeyword.TimeLineCode
	Quit:DataTypeCode="" return
	
	Set EpisodeID=objResult.EpisodeID
	Set ObjectID=objResult.ObjectID
	
	Set return="-300"
	Quit:'$d(^icare.ClinicalRepositoryI("IndexAct"," "_EpisodeID,DataTypeCode," "_ObjectID)) return
	Quit:$d(^icare.ClinicalRepositoryI("IndexAct"," "_EpisodeID,DataTypeCode," "_ObjectID,"060102")) return
	
	Set return="-400"
	Set objActType=##Class(icare.ClinicalDataTypeAct).%OpenId("060102")
	If objActType'="" Do objActType.%Close()
	Quit:'$IsObject(objActType) return
	Set objDataType=##Class(icare.ClinicalDataType).%OpenId(DataTypeCode)
	If objDataType'="" Do objDataType.%Close()
	Quit:'$IsObject(objDataType) return
	
	Set return="-500"
	Set ActCode=$o(^icare.ClinicalRepositoryI("IndexAct"," "_EpisodeID,DataTypeCode," "_ObjectID,""))
	Quit:ActCode="" return
	
	Set return="-600"
	Set RepositoryID="",objRepository=""
	For {
		Set RepositoryID=$O(^icare.ClinicalRepositoryI("IndexAct"," "_EpisodeID,DataTypeCode," "_ObjectID,ActCode,RepositoryID),-1)
		Quit:(RepositoryID="")||(objRepository'="")
		
		Set objRepository=##Class(icare.ClinicalRepository).%OpenId(RepositoryID)
		Continue:'$IsObject(objRepository)
		If objRepository'="" Do objRepository.%Close()
	}
	Quit:'$IsObject(objRepository) return
	
	Set NewRep=##Class(icare.ClinicalRepository).%New()
	Set NewRep.ActCode=objActType
	Set NewRep.DataTypeCode=objDataType
	Set NewRep.EpisodeID=EpisodeID
	Set NewRep.ObjectID=ObjectID
	Set NewRep.ActDate=XDate
	Set NewRep.ActTime=XTime
	Set NewRep.CareProviderID=objRepository.CareProviderID
	Set NewRep.DataValue=objRepository.DataValue
	Set NewRep.Parameters=objRepository.Parameters
	Set NewRep.PatientID=objRepository.PatientID
	Set NewRep.Summary=objRepository.Summary
	Set sc=NewRep.%Save()
    If $system.Status.IsError(sc) {    
	   //Do $system.OBJ.DisplayError(sc)
	   Set return=-1
    } Else {
	   Set return=NewRep.%Id()
    }
    
	Quit return
	
CloseErr
	Quit -999
}

ClassMethod Update(objResult As DHCMed.CC.CtlResult)
{
	New (objResult)
	
	Set $ZT="UpdateErr"
	
	Quit:$IsObject(objResult)=0 -1
	
	Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(objResult.KeyWord)
	Quit:$IsObject(objKeyword)=0 -2
	
	Set objTimeLineDataType=##class(icare.ClinicalDataType).%OpenId(objKeyword.TimeLineCode)	
	Quit:$IsObject(objTimeLineDataType)=0 -3
	If objTimeLineDataType'="" Do objTimeLineDataType.%Close()
	
	Set ActCode=$o(^icare.ClinicalDataTypeActI("IndexDataTypeCode",objTimeLineDataType.Code,""))
	Set objTimeLineDataTypeAct=##class(icare.ClinicalDataTypeAct).%OpenId(ActCode)
	Quit:$IsObject(objTimeLineDataTypeAct)=0 -4
	If objTimeLineDataTypeAct'="" Do objTimeLineDataTypeAct.%Close()
	
	set obj=##class(icare.ClinicalRepository).%New()
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objResult.EpisodeID)
	If objAdm'="" Do objAdm.%Close()
	Set obj.PatientID=objAdm.PatientID
	Set obj.EpisodeID=objResult.EpisodeID
	Set obj.ActDate=objResult.ActDate
	Set obj.ActTime=objResult.ActTime
	Set obj.Summary=objResult.Summary
	Set obj.DataValue=objResult.DataValue
	Set obj.ObjectID=objResult.ObjectID
	Set obj.Parameters=objResult.Parameters		//update by lyh 2012-11-28      //objResult.Parameters
	Set obj.DataTypeCode=objTimeLineDataType
	Set obj.ActCode=objTimeLineDataTypeAct
	
	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objResult.UserID)
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	Set obj.CareProviderID=objUser.CtpcpDr
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {    //检查删除是否成功
		//Do $system.OBJ.DisplayError(sc)
		Set return=-101
	} Else {
		Set return=obj.%Id()
	}
	
	Quit return
	
UpdateErr
	Quit -999
}

/// w ##Class(DHCMed.CCService.IntegratedCtrl.TimeLineService).DeleteByAdm(15,$zdh("2009-01-01",3),22885)
ClassMethod DeleteByAdm(aSubjectID As %String, aCtlDate As %String, aEpisodeID As %String)
{
	New (aSubjectID, aCtlDate, aEpisodeID)
	Quit:(aSubjectID="")||(aCtlDate="")||(aEpisodeID="") 0
	
	Set $ZT="DeleteByAdmErr"
	
	Set ItemID=0,Count=0
	For {
		Set ItemID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",aSubjectID,1,ItemID))
		Quit:ItemID=""
		
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		
		Set KeyWordID=""
		Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(objItemDic.IDSubCatDr)
		If $IsObject(objSubCat) {
			Set KeyWordID=objSubCat.ISCKeywordID
		}
		Continue:KeyWordID=""
		Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(KeyWordID)
		Continue:'$IsObject(objKeyword)
		Set TimeLineCode=objKeyword.TimeLineCode
		Continue:TimeLineCode=""
		
		Set xRowID=""
		For {
			Set xRowID=$o(^icare.ClinicalRepositoryI("IndexEpisodeID"," "_aEpisodeID,TimeLineCode,xRowID))
			Quit:xRowID=""
			
			Set objRepository=##class(icare.ClinicalRepository).%OpenId(xRowID)
			Continue:'$IsObject(objRepository)
			If objRepository'="" Do objRepository.%Close()
			Continue:objRepository.ActDate'=aCtlDate
			
			Set sc=##class(icare.ClinicalRepository).%DeleteId(xRowID)
			If $system.Status.IsError(sc) {            //检查删除是否成功
		   		Do $system.OBJ.DisplayError(sc)
			}
		}
	}
	
	Quit 1
	
DeleteByAdmErr
	Quit -999
}

}
