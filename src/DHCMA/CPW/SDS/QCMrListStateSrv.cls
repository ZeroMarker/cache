Class DHCMA.CPW.SDS.QCMrListStateSrv Extends %Persistent [ Not ProcedureBlock, StorageStrategy = "" ]
{

/// w ##class(DHCMA.CPW.SDS.QCMrListStateSrv).ChangeMrlistSatus("undefined^Submit^9")
ClassMethod ChangeMrlistSatus(aInput As %String) As %String
{
	new (aInput)
	Set return=-1
	Set aMrlistID	= $p(aInput,"^",1) 
	Set aStatusCode	= $p(aInput,"^",2) 
	Set DocID		= $p(aInput,"^",3) 
	Set aRuleID		= $p(aInput,"^",4) 
	Set aResume		= $p(aInput,"^",5)
	Set Err="" 
	Quit:(aMrlistID="")||(aStatusCode="") return
	TS
		Set MFlg=##class(DHCMA.CPW.SDS.QCMrListSrv).UpdateMrStatus(aStatusCode,aMrlistID)
		if (MFlg<0) {
			TRO
			Quit Err_"病例信息保存错误！"
		}
		Set StateStr=aMrlistID_"^"_aStatusCode_"^"_DocID
		Set SFlg=##class(DHCMA.CPW.SD.QCMrListState).Update(StateStr)
		if (SFlg<0) {
			TRO
			Quit Err_"状态信息保存错误！"
		}
		if ((aRuleID'="")||(aResume'="")) {
			Set StateAliasStr=SFlg_"^"_aRuleID_"^"_aResume
			Set SAFlg=##class(DHCMA.CPW.SD.QCMrStateAlias).Update(StateAliasStr)
			if (SAFlg<0) {
				TRO
				Quit Err_"状态信息明细保存错误！"
			}
		}
	TC
	Quit Err
}

/// w ##class(DHCMA.CPW.SDS.QCMrListStateSrv).GetCurrStat(216)
ClassMethod GetCurrStat(MrListID As %String) As %String
{
	new (MrListID)
	Set QCCurrStateCode=""
	Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",MrListID,""),-1)
	Set QCCurrStatusID=MrListID_"||"_QCCurrStatusSubID
	Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
	Set:$IsObject(StatusObj) QCCurrStateCode=StatusObj.StateCode.BTCode	
	Quit QCCurrStateCode
}

Storage Default
{
<Data name="QCMrListStateSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SDS.QCMrListStaF9EDD</DataLocation>
<DefaultData>QCMrListStateSrvDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SDS.QCMrListStaF9EDD</IdLocation>
<IndexLocation>^DHCMA.CPW.SDS.QCMrListStaF9EDI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SDS.QCMrListStaF9EDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
