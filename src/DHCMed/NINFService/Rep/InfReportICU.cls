/// 名称: DHCMed.NINFService.Rep.InfReportICU
/// 描述: 重症监护插管信息
/// 编写者：zhufei
/// 编写日期: 2012-12-28
Class DHCMed.NINFService.Rep.InfReportICU Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-12-28
/// Description:  取重症监护插管信息
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input：       DHCMed.NINF.Rep.InfReportICU.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportICU).GetSubRec(1)
ClassMethod GetSubRec(aRepID As %String) As DHCMed.NINF.Rep.InfReportICU
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",aRepID,"ICU",SubID))
		Quit:SubID=""
		Set return=return_$c(1)_aRepID_"||"_SubID
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-12-28
/// Description:  取重症监护插管信息
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input：       DHCMed.NINF.Rep.InfReportICU.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportICU).GetSubObj(1)
ClassMethod GetSubObj(aId As %String) As DHCMed.NINF.Rep.InfReportICU
{
	New (aId)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportICU).GetObjById(aId)
	If $IsObject(obj) {
		Set return=obj
	} Else {
		Set obj=##Class(DHCMed.NINF.Rep.InfReportICU).%New()
		If obj'="" Do obj.%Close()
		set return=obj
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-12-28
/// Description:  取重症监护插管信息 字段值
///               主要处理"List"类型数据
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input：       DHCMed.NINF.Rep.InfReportICU.ID
/// Return：      返回String
/// w ##class(DHCMed.NINFService.Rep.InfReportICU).GetFieldById(1,"InfPathogeny")
ClassMethod GetFieldById(aId As %String, aFieldName As %String) As %String
{
	New (aId,aFieldName)
	Set return=""
	Quit:(aId="")||(aFieldName="") return
	
	Set $ZT="GetFieldByIdErr"
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportICU).GetObjById(aId)
	Quit:'$IsObject(obj) return
	
	If aFieldName="InfPathogeny" {
		For ind=1:1:obj.InfPathogeny.Count() {
			Set objDic=obj.InfPathogeny.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_$c(1)_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	} Else {
		Set valExpress="Set return=obj."_aFieldName
		X valExpress
	}
	
	Quit return
	
GetFieldByIdErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2012-12-28
/// Description:  删除重症监护插管信息
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportICU).DelSubRec(1)
ClassMethod DelSubRec(aId As %String) As %String
{
	New (aId)
	Set return=##Class(DHCMed.NINF.Rep.InfReportICU).DeleteById(aId)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-12-28
/// Description:  保存重症监护插管信息
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input：       
/// Return：      返回ID
/// w ##class(DHCMed.NINFService.Rep.InfReportICU).SaveSubRec("","")
ClassMethod SaveSubRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveSubRecErr"
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Set CHR3=$p(aSeparate,",",3)
	Quit:(CHR1="")||(CHR2="")||(CHR3="") return
	
	Set RepID=$p(aInput,CHR1,1)
	Quit:RepID="" return
	Quit:'$d(^DHCMed.NINF("InfRep",RepID)) return
	
	Set IntubateDate=$p(aInput,CHR1,4)
	;Set:IntubateDate["-" IntubateDate=$zdh(IntubateDate,3)
	Set:IntubateDate'="" IntubateDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(IntubateDate)
	Set IntubateTime=$p(aInput,CHR1,5)
	Set:IntubateTime[":" IntubateTime=$zth(IntubateTime,1)
	Set ExtubateDate=$p(aInput,CHR1,6)
	;Set:ExtubateDate["-" ExtubateDate=$zdh(ExtubateDate,3)
	Set:ExtubateDate'="" ExtubateDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ExtubateDate)
	Set ExtubateTime=$p(aInput,CHR1,7)
	Set:ExtubateTime[":" ExtubateTime=$zth(ExtubateTime,1)
	Set InfDate=$p(aInput,CHR1,11)
	;Set:InfDate["-" InfDate=$zdh(InfDate,3)
	Set:InfDate'="" InfDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(InfDate)
	
	Set $p(aInput,CHR1,4)=IntubateDate
	Set $p(aInput,CHR1,5)=IntubateTime
	Set $p(aInput,CHR1,6)=ExtubateDate
	Set $p(aInput,CHR1,7)=ExtubateTime
	Set $p(aInput,CHR1,11)=InfDate
	
	Set return=##Class(DHCMed.NINF.Rep.InfReportICU).Update(aInput,aSeparate)
	Quit return
	
SaveSubRecErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-12-28
/// Description:  查询重症监护插管信息
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReportICU","QrySubRec","15","39","VAP")
Query QrySubRec(aReportID As %String, aEpisodeID As %String, aTypeCode As %String) As %Query(ROWSPEC = "IndRec:%String,RepID:%String,SubID:%String,IsChecked:%String,DataSource:%String,IntubateTypeID:%String,IntubateTypeDesc:%String,IntubateDate:%String,IntubateTime:%String,IntubateDateTime:%String,ExtubateDate:%String,ExtubateTime:%String,ExtubateDateTime:%String,IntubatePlaceID:%String,IntubatePlaceDesc:%String,IntubateUserTypeID:%String,IntubateUserTypeDesc:%String,IntubateUserID:%String,IntubateUserDesc:%String,IsInfection:%String,InfDate:%String,InfPyIDs:%String,InfPyDescs:%String,InfPyValues:%String,PICCIntubatePosID:%String,PICCIntubatePosDesc:%String,PICCIntubateSizeID:%String,PICCIntubateSizeDesc:%String,PICCIntubateTypeID:%String,PICCIntubateTypeDesc:%String,PICCIntubateNumID:%String,PICCIntubateNumDesc:%String,PICCIntubateRegionID:%String,PICCIntubateRegionDesc:%String,PICCExtubateReasonID:%String,PICCExtubateReasonDesc:%String,UCUrineBagTypeID:%String,UCUrineBagTypeDesc:%String,VAPIntubateTypeID:%String,VAPIntubateTypeDesc:%String,INFSymptomID:%String,INFSymptomDesc:%String") [ SqlProc ]
{
}

ClassMethod QrySubRecExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String, aTypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set TypeID="",TypeCode=""
	Set objType=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFICUIntubateType",aTypeCode,"")
	If $IsObject(objType) {
		Set TypeID=objType.%Id()
		Set TypeCode=objType.Code
	}
	Quit:(TypeID="")||(TypeCode="") $$$OK
	
	If aReportID'="" {
		Set objRep=##class(DHCMed.NINF.Rep.InfReport).GetObjById(aReportID)
		Quit:'$IsObject(objRep) $$$OK
		Set aEpisodeID=objRep.EpisodeID
	}
	Quit:aEpisodeID="" $$$OK
	
	Set ICUIntubateList=""
	Set listICU=##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResults(aEpisodeID,TypeCode)
	For indICU=1:1:listICU.Count() {
		Set objICU=listICU.GetAt(indICU)
		Continue:'$IsObject(objICU)
		Set DataSource=objICU.DataSource
		Set ICUIntubateList=ICUIntubateList_$lb(DataSource)
	}
	
	Set RepIntubateList=""
	If aReportID'="" {
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"ICU",xSubID))
			Quit:xSubID=""
			
			Set ReportID=aReportID_"||"_xSubID
			Set objICU=##class(DHCMed.NINF.Rep.InfReportICU).GetObjById(ReportID)
			Continue:'$IsObject(objICU)
			
			Set SubData=..BuildSubData(ReportID,TypeID)
			Continue:SubData=""
			
			Set DataSource=objICU.DataSource
			If $listfind(ICUIntubateList,DataSource)>0 {
				Set RepIntubateList=RepIntubateList_$lb(DataSource)
			}
			Set IsChecked=1
			
			Set ^CacheTemp(repid,ind)=$lb(ind,aReportID,xSubID,IsChecked,DataSource)_SubData
			Set ind=ind+1
		}
	}
	
	For indICU=1:1:listICU.Count() {
		Set objICU=listICU.GetAt(indICU)
		Continue:'$IsObject(objICU)
		
		Set DataSource=objICU.DataSource
		Continue:($listfind(RepIntubateList,DataSource)>0)
		Set IsChecked=0
		
		Set IntubateTypeID=objICU.IntubateType.Code
		Set IntubateTypeDesc=objICU.IntubateType.Desc
		Set IntubateDate=objICU.IntubateDate
		Set IntubateTime=objICU.IntubateTime
		Set IntubateDateTime=""
		If IntubateDate'="" {
			//Set IntubateDate=$zd(+IntubateDate,3)
			//Set IntubateTime=$zt(+IntubateTime,2)
			Set:IntubateDate["-" IntubateDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml($zdh(IntubateDate,3))
			Set IntubateTime=$zt($zth(IntubateTime),2)
			Set IntubateDateTime=IntubateDate_" "_IntubateTime
		}
		Set ExtubateDate=objICU.ExtubateDate
		Set ExtubateTime=objICU.ExtubateTime
		Set ExtubateDateTime=""
		If ExtubateDate'="" {
			//Set ExtubateDate=$zd(+ExtubateDate,3)
			//Set ExtubateTime=$zt(+ExtubateTime,2)
			Set:ExtubateDate["-" ExtubateDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml($zdh(ExtubateDate,3))
			Set ExtubateTime=$zt($zth(ExtubateTime),2)
			Set ExtubateDateTime=ExtubateDate_" "_ExtubateTime
		}
		
		Set Data=$lb(ind,aReportID,"",IsChecked,DataSource)
		Set Data=Data_$lb(IntubateTypeID,IntubateTypeDesc)
		Set Data=Data_$lb(IntubateDate,IntubateTime,IntubateDateTime)
		Set Data=Data_$lb(ExtubateDate,ExtubateTime,ExtubateDateTime)
		Set Data=Data_$lb("","","","","","","","","","","","","","","","","","","","","","","","","","","")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QrySubRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySubRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubRecExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildSubData(aReportID As %String, aTypeID As %String) As %String
{
	New (aReportID,aTypeID)
	Set return=""
	
	Set $ZT="BuildSubDataErr"
	
	Set objICU=##class(DHCMed.NINF.Rep.InfReportICU).GetObjById(aReportID)
	Quit:'$IsObject(objICU) return
	
	Set (IntubateTypeID,IntubateTypeDesc)=""
	Set (IntubateDate,IntubateTime,IntubateDateTime,ExtubateDate,ExtubateTime,ExtubateDateTime)=""
	Set (IntubatePlaceID,IntubatePlaceDesc)=""
	Set (IntubateUserTypeID,IntubateUserTypeDesc,IntubateUserID,IntubateUserDesc)=""
	Set (IsInfection,InfDate,InfPyIDs,InfPyDescs,InfPyValues)=""
	Set (PICCIntubatePosID,PICCIntubatePosDesc,PICCIntubateSizeID,PICCIntubateSizeDesc)=""
	Set (PICCIntubateTypeID,PICCIntubateTypeDesc,PICCIntubateNumID,PICCIntubateNumDesc)=""
	Set (PICCIntubateRegionID,PICCIntubateRegionDesc,PICCExtubateReasonID,PICCExtubateReasonDesc)=""
	Set (UCUrineBagTypeID,UCUrineBagTypeDesc)=""
	Set (VAPIntubateTypeID,VAPIntubateTypeDesc)=""
	
	If $IsObject(objICU.IntubateType) {
		Set IntubateTypeID=objICU.IntubateType.%Id()
		Set IntubateTypeDesc=objICU.IntubateType.Description
	}
	Quit:(aTypeID'="")&&(aTypeID'=IntubateTypeID) return
	Set IntubateDate=objICU.IntubateDate
	Set IntubateTime=objICU.IntubateTime
	If IntubateDate'="" {
		Set IntubateDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+IntubateDate)
		Set IntubateTime=$zt(+IntubateTime,2)
		Set IntubateDateTime=IntubateDate_" "_IntubateTime
	}
	Set ExtubateDate=objICU.ExtubateDate
	Set ExtubateTime=objICU.ExtubateTime
	If ExtubateDate'="" {
		Set ExtubateDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+ExtubateDate)
		Set ExtubateTime=$zt(+ExtubateTime,2)
		Set ExtubateDateTime=ExtubateDate_" "_ExtubateTime
	}
	If $IsObject(objICU.IntubatePlace) {
		Set IntubatePlaceID=objICU.IntubatePlace.%Id()
		Set IntubatePlaceDesc=objICU.IntubatePlace.Description
	}
	If $IsObject(objICU.IntubateUserType) {
		Set IntubateUserTypeID=objICU.IntubateUserType.%Id()
		Set IntubateUserTypeDesc=objICU.IntubateUserType.Description
	}
	Set IntubateUser=objICU.IntubateUser
	Set objIntubateUser=##class(DHCMed.Base.SSUser).GetObjById(IntubateUser)
	If $IsObject(objIntubateUser) {
		Set IntubateUserID=objIntubateUser.Rowid
		Set IntubateUserDesc=objIntubateUser.Name
	}
	Set InfDate=objICU.InfDate
	Set:InfDate'="" InfDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InfDate)
	Set IsInfection=$s(InfDate'="":"是",1:"否")
	Set InfPyIDs="",InfPyDescs=""
	Set objInfPyList=objICU.InfPathogeny
	If $IsObject(objInfPyList) {
		For indPy=1:1:objInfPyList.Count() {
			Set objInfPy=objInfPyList.GetAt(indPy)
			Continue:'$IsObject(objInfPy)
			Set InfPyID=objInfPy.PathogenyID
			Set InfPyDesc=objInfPy.PathogenyDesc
			Set InfPyDesc=$tr(InfPyDesc,$c(1),"")
			Set InfPyDesc=$tr(InfPyDesc,$c(2),"")
			Set InfPyIDs=InfPyIDs_$c(1)_InfPyID
			Set InfPyDescs=InfPyDescs_$c(1)_InfPyDesc
			Set InfPyValues=InfPyValues_$c(1)_InfPyID_$c(2)_InfPyDesc
		}
		Set:InfPyIDs'="" InfPyIDs=$e(InfPyIDs,2,$l(InfPyIDs))
		Set:InfPyDescs'="" InfPyDescs=$e(InfPyDescs,2,$l(InfPyDescs))
		Set:InfPyValues'="" InfPyValues=$e(InfPyValues,2,$l(InfPyValues))
	}
	
	If $IsObject(objICU.PICCIntubatePos) {
		Set PICCIntubatePosID=objICU.PICCIntubatePos.%Id()
		Set PICCIntubatePosDesc=objICU.PICCIntubatePos.Description
	}
	If $IsObject(objICU.PICCIntubateSize) {
		Set PICCIntubateSizeID=objICU.PICCIntubateSize.%Id()
		Set PICCIntubateSizeDesc=objICU.PICCIntubateSize.Description
	}
	If $IsObject(objICU.PICCIntubateType) {
		Set PICCIntubateTypeID=objICU.PICCIntubateType.%Id()
		Set PICCIntubateTypeDesc=objICU.PICCIntubateType.Description
	}
	If $IsObject(objICU.PICCIntubateNum) {
		Set PICCIntubateNumID=objICU.PICCIntubateNum.%Id()
		Set PICCIntubateNumDesc=objICU.PICCIntubateNum.Description
	}
	If $IsObject(objICU.PICCIntubateRegion) {
		Set PICCIntubateRegionID=objICU.PICCIntubateRegion.%Id()
		Set PICCIntubateRegionDesc=objICU.PICCIntubateRegion.Description
	}
	If $IsObject(objICU.PICCExtubateReason) {
		Set PICCExtubateReasonID=objICU.PICCExtubateReason.%Id()
		Set PICCExtubateReasonDesc=objICU.PICCExtubateReason.Description
	}
	
	If $IsObject(objICU.UCUrineBagType) {
		Set UCUrineBagTypeID=objICU.UCUrineBagType.%Id()
		Set UCUrineBagTypeDesc=objICU.UCUrineBagType.Description
	}
	
	If $IsObject(objICU.VAPIntubateType) {
		Set VAPIntubateTypeID=objICU.VAPIntubateType.%Id()
		Set VAPIntubateTypeDesc=objICU.VAPIntubateType.Description
	}
	//Add BY LiYang 2014-04-11 增加感染症状字段
	If $IsObject(objICU.INFSymptom) {
		Set INFSymptomID=objICU.INFSymptom.%Id()
		Set INFSymptomDesc=objICU.INFSymptom.Description
	}
	
	Set return=$lb(IntubateTypeID,IntubateTypeDesc)
	Set return=return_$lb(IntubateDate,IntubateTime,IntubateDateTime,ExtubateDate,ExtubateTime,ExtubateDateTime)
	Set return=return_$lb(IntubatePlaceID,IntubatePlaceDesc)
	Set return=return_$lb(IntubateUserTypeID,IntubateUserTypeDesc,IntubateUserID,IntubateUserDesc)
	Set return=return_$lb(IsInfection,InfDate,InfPyIDs,InfPyDescs,InfPyValues)
	Set return=return_$lb(PICCIntubatePosID,PICCIntubatePosDesc,PICCIntubateSizeID,PICCIntubateSizeDesc)
	Set return=return_$lb(PICCIntubateTypeID,PICCIntubateTypeDesc,PICCIntubateNumID,PICCIntubateNumDesc)
	Set return=return_$lb(PICCIntubateRegionID,PICCIntubateRegionDesc,PICCExtubateReasonID,PICCExtubateReasonDesc)
	Set return=return_$lb(UCUrineBagTypeID,UCUrineBagTypeDesc)
	Set return=return_$lb(VAPIntubateTypeID,VAPIntubateTypeDesc)
	Set return=return_$lb(INFSymptomID,INFSymptomDesc) //Add BY LiYang 2014-04-11 增加感染症状字段
	
	Quit return
	
BuildSubDataErr
	Quit ""
}

}
