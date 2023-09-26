Class web.DHCEQ.query.DHCEQPictureList Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/*
ClassMethod GetPictureList(Start = 0, Limit = 40, PicRowID As %String = "")
{
	s json = ##class(Code.JsonObj).%New()
	s count = 0
	s end = Start+Limit
	
	
	d BuildDataGetPictureList
	
	s resultString = json.getJsonData("RowId^PicName^PicListSort^Suffix^DefaultFlag",count)
    k json
    q resultString
	Quit $$$OK
BuildDataGetPictureList
	
	s PLRowID=""
	f  s PLRowID=$o(^DHCEQPictureList(PLRowID)) q:PLRowID=""  d
	.q:$p($g(^DHCEQPictureList(PLRowID)),"^",1)'=PicRowID
	.d ResetVariablesGetPictureList
	.d GetListInfo
	.d OutputRowGetPictureList
	quit
GetListInfo
	s TRowID=PLRowID
	s TPicName=$p($g(^DHCEQPicture(PicRowID)),"^",13)
	s TPicSort=$p($g(^DHCEQPictureList(PLRowID)),"^",4)
	s TSuffix=$p($g(^DHCEQPictureList(PLRowID)),"^",2)
	s TDefaultFlag=$p($g(^DHCEQPictureList(PLRowID)),"^",3)
	s:TDefaultFlag=$c(0) TDefaultFlag="false"
	quit
OutputRowGetPictureList
	s Data=TRowID_"^"_TPicName_"^"_TPicSort_"^"_TSuffix_"^"_TDefaultFlag
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(Data)
	quit
ResetVariablesGetPictureList
	s (TRowID,TPicName,TPicSort,TSuffix,TDefaultFlag)=""
	quit
}

/// 2015-06-18 QW
/// 描述:GetPictureList
/// /d ##class(%ResultSet).RunQuery("web.DHCEQ.query.DHCEQPictureList","GetPictureList","","","","")
Query GetPictureList(EquipDR As %String, SourceType As %String, SourceID As %String, PLID As %String) As %Query(ROWSPEC = "PTRowID:%String,PTPictureNo:%String,PTRemark:%String,PTPath:%String,PTPicName:%String,PLRowID:%String,PLSuffix:%String,PLPicSort:%String,PLUpLoadFlag:%String")
{
}

ClassMethod GetPictureListExecute(ByRef qHandle As %Binary, EquipDR As %String, SourceType As %String, SourceID As %String, PLID As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetList
	Quit $$$OK
	
BuildDataGetList
	i EquipDR'=""  
	{
		f  s rowid=$o(^DHCEQPicture(0,"Equip",EquipDR,rowid)) q:rowid=""  d
		.d ResetVariables
		.q:$p($g(^DHCEQPicture(rowid)),"^",7)="2"
		.s PTRowID=rowid
		.d GetPictureInfo
		.d GetPictureListInfo

	}
	if (SourceType'="")&&(SourceID'="")
	{
		f  s rowid=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,rowid)) q:rowid=""  d
		.d ResetVariables
		.q:$p($g(^DHCEQPicture(rowid)),"^",7)="2"
		.s PTRowID=rowid
		.d GetPictureInfo
		.d GetPictureListInfo

	}
	if ((EquipDR="")&&(SourceType="")&&(SourceID="")) 
	{
		f  s rowid=$o(^DHCEQPicture(rowid)) q:rowid=""  d
		.d ResetVariables
		.q:$p($g(^DHCEQPicture(rowid)),"^",7)="2"
		.s PTRowID=rowid
		.d GetPictureInfo
		.d GetPictureListInfo
		
	}
	quit
GetPictureListInfo
	f  s PLRowID=$o(^DHCEQPictureList(0,"Picture",PTRowID,PLRowID)) q:PLRowID=""  d
	.q:(PLID'="")&&(PLID'=PLRowID)
	.s PLSuffix=$p($g(^DHCEQPictureList(PLRowID)),"^",3)
	.s PLPicSort=$p($g(^DHCEQPictureList(PLRowID)),"^",2)
	.s PLUpLoadFlag=$p($g(^DHCEQPictureList(PLRowID)),"^",13)
	.d OutputRowGetPicture
	quit
GetPictureInfo
	s PTPictureNo=$p($g(^DHCEQPicture(PTRowID)),"^",2)
	s PTRemark=$p($g(^DHCEQPicture(PTRowID)),"^",3)
	s PTPath=$p($g(^DHCEQPicture(PTRowID)),"^",4)
	s PTPicName=$p($g(^DHCEQPicture(PTRowID)),"^",13)
	quit
OutputRowGetPicture
	s Data=$lb(PTRowID,PTPictureNo,PTRemark,PTPath,PTPicName,PLRowID,PLSuffix,PLPicSort,PLUpLoadFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariables
	s (PTRowID,PTPictureNo,PTRemark,PTPath,PTPicName)=""
	s (PLRowID,PLSuffix,PLPicSort,PLUpLoadFlag)=""
	quit
}

ClassMethod GetPictureListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPictureListExecute ]
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

ClassMethod GetPictureListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPictureListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}
*/
}
