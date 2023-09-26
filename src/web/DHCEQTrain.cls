Class web.DHCEQTrain Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetTrainList(TrainDate As %String = "", TrainUser As %String = "", TrainTitle As %String = "", TrainEquip As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceID:%String,TTrainAddress:%String,TTrainDate:%String,TTrainUser:%String,TTrainTitle:%String,TTrainContent:%String,TRemark:%String,TTrainEquip:%String")
{
}

ClassMethod GetTrainListExecute(ByRef qHandle As %Binary, TrainDate, TrainUser, TrainTitle, TrainEquip) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s CurDate=0
	;i TrainDate'="" s CurDate=$ZDH(TrainDate,4)
	;日期格式统一调整    Modify by CSY 2017-03-02
	s CurDate=##Class(web.DHCEQCommon).TransValueToPage(TrainDate,"date")
	s SourceType="Train"
	s UserDefinedCode="DHCEQTrain"
	s UDRowID=$o(^DHCEQCCode("DHCEQCUserDefined",0,"Code",UserDefinedCode,0))
	s SourceID=0
	f  s SourceID=$o(^DHCEQUserDefinedInfo(0,"SourceType",SourceType,SourceID))  q:SourceID=""  d
	.s UDIRowID=0
	.f  s UDIRowID=$o(^DHCEQUserDefinedInfo(0,"SourceType",SourceType,SourceID,UDRowID,UDIRowID)) q:UDIRowID=""  d
	..d ResetVariablesGetTrainList
	..s Flag=0
	..s TRowID=UDIRowID
	..s TSourceID=$p($g(^DHCEQUserDefinedInfo(UDIRowID)),"^",2)
	..s UDLRowID=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",UDRowID,"F_TrainDate",0))
	..i UDLRowID'=""  d
	...s UDILRowID=$o(^DHCEQUserDefinedInfoList(0,"UserDefinedInfo",UDIRowID,UDLRowID,0))
	...s TTrainDate=$p($g(^DHCEQUserDefinedInfoList(UDILRowID)),"^",3)
	...i (CurDate'=0)&&(TTrainDate'=CurDate) s Flag=1
	...i TTrainDate'="" s TTrainDate=##Class(web.DHCEQCommon).TransValueToPage(TTrainDate,"date")
	..q:Flag'=0
	..s UDLRowID=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",UDRowID,"F_TrainAddress",0))
	..i UDLRowID'=""  d
	...s UDILRowID=$o(^DHCEQUserDefinedInfoList(0,"UserDefinedInfo",UDIRowID,UDLRowID,0))
	...s TTrainAddress=$p($g(^DHCEQUserDefinedInfoList(UDILRowID)),"^",3)
	..s UDLRowID=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",UDRowID,"F_TrainUser",0))
	..i UDLRowID'=""  d
	...s UDILRowID=$o(^DHCEQUserDefinedInfoList(0,"UserDefinedInfo",UDIRowID,UDLRowID,0))
	...s TTrainUser=$p($g(^DHCEQUserDefinedInfoList(UDILRowID)),"^",3)
	...i (TrainUser'="")&&(TTrainUser'[TrainUser) s Flag=1
	..q:Flag'=0
	..s UDLRowID=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",UDRowID,"F_TrainTitle",0))
	..i UDLRowID'=""  d
	...s UDILRowID=$o(^DHCEQUserDefinedInfoList(0,"UserDefinedInfo",UDIRowID,UDLRowID,0))
	...s TTrainTitle=$p($g(^DHCEQUserDefinedInfoList(UDILRowID)),"^",3)
	...i (TrainTitle'="")&&(TTrainTtile'[TrainTitle) s Flag=1
	..q:Flag'=0
	..s UDLRowID=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",UDRowID,"F_TrainEquip",0))
	..i UDLRowID'=""  d
	...s UDILRowID=$o(^DHCEQUserDefinedInfoList(0,"UserDefinedInfo",UDIRowID,UDLRowID,0))
	...s TTrainEquip=$p($g(^DHCEQUserDefinedInfoList(UDILRowID)),"^",3)
	...i (TrainEquip'="")&&(TTrainEquip'[TrainEquip) s Flag=1
	..q:Flag'=0
	..s UDLRowID=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",UDRowID,"F_TrainContent",0))
	..i UDLRowID'=""  d
	...s UDILRowID=$o(^DHCEQUserDefinedInfoList(0,"UserDefinedInfo",UDIRowID,UDLRowID,0))
	...s TTrainContent=$p($g(^DHCEQUserDefinedInfoList(UDILRowID)),"^",3)
	..s UDLRowID=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",UDRowID,"F_Remark",0))
	..i UDLRowID'=""  d
	...s UDILRowID=$o(^DHCEQUserDefinedInfoList(0,"UserDefinedInfo",UDIRowID,UDLRowID,0))
	...s TRemark=$p($g(^DHCEQUserDefinedInfoList(UDILRowID)),"^",3)
	..d OutputRowGetTrainList
	
	Quit $$$OK

OutputRowGetTrainList
	s Data=$lb(TRowID,TSourceID,TTrainAddress,TTrainDate,TTrainUser,TTrainTitle,TTrainContent,TRemark,TTrainEquip)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetTrainList
	s (TRowID,TSourceID,TTrainAddress,TTrainDate,TTrainUser,TTrainTitle,TTrainContent,TRemark,TTrainEquip)=""
	quit
}

ClassMethod GetTrainListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTrainListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTrainListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTrainListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
