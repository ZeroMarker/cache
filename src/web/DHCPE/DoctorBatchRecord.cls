/// 医生批量录入
Class web.DHCPE.DoctorBatchRecord Extends %Persistent
{

/// w ##class(web.DHCPE.DoctorBatchRecord).BatchSaveResult()
ClassMethod BatchSaveResult(ArrivedDate As %String = "", CheckDate As %String = "", DocID As %String = "", GroupID As %String = "", LocID As %String = "") As %String
{
	s ErrNum=0
	s AuditErrNum=0
	s SussNum=0
	s AuditSussNum=0
	s ErrRegNo=""
	
	i ArrivedDate'="" s ArrivedDate=##class(websys.Conversions).DateHtmlToLogical(ArrivedDate) 
	i $g(ArrivedDate)="" s ArrivedDate=+$H
	
	i CheckDate'="" s CheckDate=##class(websys.Conversions).DateHtmlToLogical(CheckDate) 
	I $g(CheckDate)="" s CheckDate=+$H

	s:DocID="" DocID=%session.Get("LOGON.USERID")
	s:GroupID="" GroupID=%session.Get("LOGON.GROUPID")
	s:LocID="" LocID=%session.Get("LOGON.CTLOCID")
	
	s AutoSaveCount=$I(^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate))
	s ^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount)=$H
	
	s Time=0
	f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",ArrivedDate,Time)) q:Time=""  d
	.s IADM=0
	.f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",ArrivedDate,Time,IADM)) q:IADM=""  d
	..s Status=$p($g(^DHCPEIADM(IADM)),"^",8)
	..q:Status'="ARRIVED"
	..s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)
	..q:LocFlag=1
	..s PatID=$P($g(^PAADM(PAADM)),"^",1)
	..s RegNo=$P($g(^PAPER(PatID,"PAT",1)),"^",1)
	..s OEOrdID=$O(^OEORD(0,"Adm",PAADM,0))
	..q:OEOrdID=""
	..s StationIDs=""
	..s ItemSub=0
	..f  s ItemSub=$O(^OEORD(OEOrdID,"I",ItemSub)) q:ItemSub=""  d
	...s ArcItemID=$P($g(^OEORD(OEOrdID,"I",ItemSub,1)),"^",2)
	...q:ArcItemID=""
	...s Stat=$P($g(^OEORD(OEOrdID,"I",ItemSub,1)),"^",13)
	...q:Stat="4"
	...;s StationID=$o(^DHCPEST(0,"STORD_ARCIM",ArcItemID,0))
	...
	.../***根据医嘱获取站点ID(多院区) start***/
	...s StOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcItemID,LocID)
	...s StationID=$p(StOrderDR,"||",1)
	...q:StationID=""
	.../***根据医嘱获取站点ID(多院区) end***/
	...
	...;s Flag=$g(^DHCPECFDataEx("ChartAssign",DocID,LocID,GroupID,"Write",StationID))
	...;q:Flag'="Y"
	...
	.../*******医生权限（可写等）-多院区 start*******/
	...s ParRef=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp"," "_LocID," "_DocID," "_GroupID,0))
	...q:ParRef=""
    ...s CANoActive=$lg($g(^CF.PE.ChartAssignD(ParRef)),6)
	...q:CANoActive="N"
	...s IsInDoc=$lg($g(^CF.PE.ChartAssignD(ParRef)),5) //是否住院医生
	...q:IsInDoc="Y"
	...s Sub=$o(^CF.PE.ChartAssignI("DTL","IdxOfStation",ParRef,StationID,0)) 
	...q:Sub=""
	...s WriteFlag=$lg($g(^CF.PE.ChartAssignD(ParRef,"DTL",Sub)),4) //可写权限
	...q:WriteFlag'="Y"
	.../*******医生权限（可写等）-多院区 end*******/
	...
	...s OEID=OEOrdID_"||"_ItemSub
	...q:$d(^DHCPERLT(0,"OEORI",OEID))
	...s ResultStr=..GetDefaultResult(OEID)
	...q:ResultStr=""
	...s Ret=##class(web.DHCPE.ResultNew).SaveResult(ResultStr,DocID,"",CheckDate)
	...i +Ret=-1 d
	....s ErrNum=ErrNum+1
	....s ErrRegNo=ErrRegNo_"^"_RegNo
	....s ^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount,"Err",PAADM,"Save",OEID)=Ret
	...i +Ret=0 d
	....s SussNum=SussNum+1
	....s ^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount,"Suss",PAADM,"Save",OEID)=""
	....i StationIDs="" d
	.....s StationIDs=StationID
	....e  d
	.....s StationIDs=StationIDs_"^"_StationID
	..q:StationIDs=""
	..s StationLength=$L(StationIDs,"^")
	..f j=1:1:StationLength d
	...s StationID=$P(StationIDs,"^",j)
	...s Ret=##class(web.DHCPE.ResultEdit).AuditStationS(PAADM, StationID, "Submit", DocID)
	...i Ret'=0 d
	....s ^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount,"Err",PAADM,"Audit",StationID)=Ret
	....s AuditErrNum=AuditErrNum+1
	...e  d
	....s ^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount,"Suss",PAADM,"Audit",StationID)=""
	....s AuditSussNum=AuditSussNum+1
	q ErrNum_"^"_SussNum_"^"_AuditErrNum_"^"_AuditSussNum_ErrRegNo
}

ClassMethod GetDefaultResult(OrdItemID)
{
	s ResultStr=""
	s ArcItemID=$P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",2)
	s Sequence=""
	f  s Sequence=$O(^DHCPEODR(0,"Sequence",ArcItemID,Sequence)) q:Sequence=""  d
	.s RowId=""
	.f  s RowId=$O(^DHCPEODR(0,"Sequence",ArcItemID,Sequence,RowId)) q:RowId=""  d
	..s ODID=$P($g(^DHCPEODR(RowId)),"^",2)
	..s ODType=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",2)
	..q:ODType="N"
	..i (ODType="S")||(ODType="T") d
	...s Default=##class(web.DHCPE.ResultEdit).GetNormal(ODID,"M","17")
	..e  d
	...s Default=""
	..s OneStr=OrdItemID_"^"_ODID_"^"_Default
	..i ResultStr="" d
	...s ResultStr=OneStr
	..e  d
	...s ResultStr=ResultStr_$C(1)_OneStr
	q ResultStr
}

Query RecordQuery(ArrivedDate As %Library.String = "", ShowErr As %Library.String = "") As %Query(ROWSPEC = "TPAADM:%String,TRecordNum:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TGroup:%String,TDepart:%String,TErrInfo:%String,CZType:%String")
{
}

ClassMethod RecordQueryExecute(ByRef qHandle As %Binary, ArrivedDate As %Library.String = "", ShowErr As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	if ArrivedDate=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	I ArrivedDate'="" S ArrivedDate=##class(websys.Conversions).DateHtmlToLogical(ArrivedDate) 
	s ind=1
	s DocID=%session.Get("LOGON.USERID")
 	s AutoSaveCount=""
 	f  s AutoSaveCount=$O(^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount),-1) q:AutoSaveCount=""  d
 	.s Type=""
 	.f  s Type=$O(^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount,Type)) q:Type=""  d
 	..;q:(ShowErr="on")&&(Type'="Err")
 	..q:(ShowErr="checked")&&(Type'="Err")
 	..s TypeDesc=""
 	..i Type="Err" s TypeDesc="错误"
 	..i Type="Suss" s TypeDesc="成功"
 	..s TRecordNum="第"_AutoSaveCount_"次,"_TypeDesc
	..s PAADM=""
 	..f  s PAADM=$O(^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount,Type,PAADM)) q:PAADM=""  d
 	...d ClearInfo
 	...s TPAADM=PAADM
 	...s PapmiDR=$p($g(^PAADM(PAADM)),"^",1)
 	...q:PapmiDR=""
 	...s TRegNo=$P(^PAPER(PapmiDR,"PAT",1),"^",1)
 	...s TName=$P(^PAPER(PapmiDR,"ALL"),"^",1)
 	...s TSex=$P(^PAPER(PapmiDR,"ALL"),"^",7)
 	...s:TSex'="" TSex=$P(^CT("SEX",TSex),"^",2)
 	...;s TDob=$P(^PAPER(PapmiDR,"ALL"),"^",6)
 	...;s:TDob'="" TDob=$P(##class(web.DHCLCNUREXCUTE).CalAge(TDob,+$H),"Y",1)
 	...s TDob=##class(web.DHCBillInterface).GetPapmiAge(PapmiDR,PAADM)
 	...s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	...s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
	...s GADM=$p(^DHCPEPreIADM(PreIADM),"^",2)
	...i GADM'=""  d
	....s GBaseRowID=$p(^DHCPEPreGADM(GADM),"^")
	....s TGroup=$p(^DHCPEPreGBI(GBaseRowID),"^",2)
	...e  d
	....s TGroup=""
 	...s TDepart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))
 	...s OEID=""
 	...f  s OEID=$O(^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount,Type,PAADM,"Save",OEID)) q:OEID=""  d
 	....s CZType="录入结果"
 	....s ArcimID=$P(^OEORD(+OEID,"I",$P(OEID,"||",2),1),"^",2)
 	....s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcimID)
 	....s ArrInfo=$G(^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount,Type,PAADM,"Save",OEID))
 	....i ArrInfo="" d
 	.....s TErrInfo=ArcimDesc
 	....e  d
 	.....s TErrInfo=ArcimDesc_$P(ArrInfo,"^",2)
 	....d RecordBuild
	...s STID=""
 	...f  s STID=$O(^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount,Type,PAADM,"Audit",STID)) q:STID=""  d
 	....s CZType="科室提交"
 	....s ArcimDesc=$P(^DHCPEST(+STID),"^",2)
 	....s ArrInfo=$G(^DHCPEDataEx("AutoSaveResult",DocID,ArrivedDate,AutoSaveCount,Type,PAADM,"Audit",STID))
 	....i ArrInfo="" d
 	.....s TErrInfo=ArcimDesc
 	....e  d
 	.....s TErrInfo=ArcimDesc_..GetErrInfo(ArrInfo)
 	....d RecordBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ClearInfo
	s (TPAADM,TRegNo,TName,TSex,TDob,TGroup,TDepart,TErrInfo,CZType)=""
	q
RecordBuild      
	set Data=$lb(TPAADM,TRecordNum,TRegNo,TName,TSex,TDob,TGroup,TDepart,TErrInfo,CZType)
 	s TRecordNum=""
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod RecordQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RecordQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod RecordQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RecordQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetErrInfo(ErrCode)
{
	q:ErrCode="NoApp" "存在未执行的项目"
	q ErrCode
}

ClassMethod BatchAuditGen(ArrivedDate As %String = "", AuditDate As %String = "", DocID As %String = "", MainDoctor As %String = "", NoResultFlag As %String = "") As %String
{
	s ErrNum=0
	s AuditErrNum=0
	s SussNum=0
	s ErrRegNo=""

	i ArrivedDate'="" s ArrivedDate=##class(websys.Conversions).DateHtmlToLogical(ArrivedDate) 
	i $g(ArrivedDate)="" s ArrivedDate=+$H
	
	i AuditDate'="" s AuditDate=##class(websys.Conversions).DateHtmlToLogical(AuditDate) 
	I $g(AuditDate)="" s AuditDate=+$H
	
	s:DocID="" DocID=%session.Get("LOGON.USERID")
	s:MainDoctor="" MainDoctor="N"
	
	s AutoSaveCount=$I(^DHCPEDataEx("AutoAudit",MainDoctor,DocID,ArrivedDate))
	s ^DHCPEDataEx("AutoAudit",MainDoctor,DocID,ArrivedDate,AutoSaveCount)=$H
	
	s Time=0
	f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",ArrivedDate,Time)) q:Time=""  d
	.s IADM=0
	.f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",ArrivedDate,Time,IADM)) q:IADM=""  d
	..s Status=$p($g(^DHCPEIADM(IADM)),"^",8)
	..q:Status'="ARRIVED"
	..s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	..s LocID=$P($g(^PAADM(PAADM)),"^",4)
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,LocID)
	..q:LocFlag=1
	..s PapmiDR=$p($g(^PAADM(PAADM)),"^",1)
 	..q:PapmiDR=""
 	..s TRegNo=$P($g(^PAPER(PapmiDR,"PAT",1)),"^",1)
	..i MainDoctor="N" d  ;初检汇总所有结果
	...s ret=##class(web.DHCPE.ResultDiagnosis).IsCanSumResult(PAADM)
	...s:(NoResultFlag'="1")&&(ret'=0) ret="NoResult"
	...q:(NoResultFlag'="1")&&(ret'=0)
	...s ret=##class(web.DHCPE.ResultDiagnosis).UpdateStationS(PAADM,"0","")
	...s ret=$P(ret,"^",1)
	...q:ret="HadAudit" ;已初检退出
	...i ret'=0 d ;记录初检错误信息
	....s ErrNum=ErrNum+1
	....s ErrRegNo=ErrRegNo_"^"_TRegNo
	....s ^DHCPEDataEx("AutoAudit",MainDoctor,DocID,ArrivedDate,AutoSaveCount,"Err",PAADM)=ret
	..e  d
	...i $D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)) d  ;已复检
	....s ret="HadAudit"
	...e  d
	....s SSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
	....i SSID="" d
	.....s ret="NoAudit" ;未初检
	....e  d
	.....s AuditUser=$p($g(^DHCPEGS(SSID,1)),"^",5)
	.....i AuditUser="" d
	......s ret="NoAudit" ;未初检
	.....e  d
	......s ret=0
	..q:ret'=0
	..s ret=##class(web.DHCPE.ResultDiagnosis).AuditStationS(PAADM, "Submit", "0",MainDoctor)
	..q:ret="HadAudit"
	..q:ret="NoAudit"
	..q:ret="ReMainNoAudit"
	..q:ret="NoResult"
	..i ret'=0 d
	...s ErrNum=ErrNum+1
	...s ErrRegNo=ErrRegNo_"^"_TRegNo
	...s ^DHCPEDataEx("AutoAudit",MainDoctor,DocID,ArrivedDate,AutoSaveCount,"Err",PAADM)=ret
	..e  d
	...s SussNum=SussNum+1
	...s ^DHCPEDataEx("AutoAudit",MainDoctor,DocID,ArrivedDate,AutoSaveCount,"Suss",PAADM)=ret
	q ErrNum_"^"_SussNum_ErrRegNo
}

Query AuditRecordQuery(ArrivedDate As %Library.String = "", ShowErr As %Library.String = "", MainDoctor As %String = "N") As %Query(ROWSPEC = "TPAADM:%String,TRecordNum:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TGroup:%String,TDepart:%String,TErrInfo:%String")
{
}

ClassMethod AuditRecordQueryExecute(ByRef qHandle As %Binary, ArrivedDate As %Library.String = "", ShowErr As %Library.String = "", MainDoctor As %String = "N") As %Status
{
	Set repid=$I(^CacheTemp)
	if ArrivedDate=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	I ArrivedDate'="" S ArrivedDate=##class(websys.Conversions).DateHtmlToLogical(ArrivedDate) 
	s:MainDoctor="" MainDoctor="N"
	

	s ind=1
	s DocID=%session.Get("LOGON.USERID")
 	s AutoSaveCount=""
 	
 	f  s AutoSaveCount=$O(^DHCPEDataEx("AutoAudit",MainDoctor,DocID,ArrivedDate,AutoSaveCount),-1) q:AutoSaveCount=""  d
 	.s Type=""
 	.f  s Type=$O(^DHCPEDataEx("AutoAudit",MainDoctor,DocID,ArrivedDate,AutoSaveCount,Type)) q:Type=""  d
 	..q:(ShowErr="1")&&(Type'="Err")
 	..s TypeDesc=""
 	..i Type="Err" s TypeDesc="错误"
 	..i Type="Suss" s TypeDesc="成功"
 	..s TRecordNum="第"_AutoSaveCount_"次,"_TypeDesc
 	..s PAADM=""
 	..f  s PAADM=$O(^DHCPEDataEx("AutoAudit",MainDoctor,DocID,ArrivedDate,AutoSaveCount,Type,PAADM)) q:PAADM=""  d
 	...d AuditClearInfo
 	...s TPAADM=PAADM
 	...s PapmiDR=$p($g(^PAADM(PAADM)),"^",1)
 	...q:PapmiDR=""
 	...s TRegNo=$P(^PAPER(PapmiDR,"PAT",1),"^",1)
 	...s TName=$P(^PAPER(PapmiDR,"ALL"),"^",1)
 	...s TSex=$P(^PAPER(PapmiDR,"ALL"),"^",7)
 	...s:TSex'="" TSex=$P(^CT("SEX",TSex),"^",2)
 	...;s TDob=$P(^PAPER(PapmiDR,"ALL"),"^",6)
 	...;s:TDob'="" TDob=$P(##class(web.DHCLCNUREXCUTE).CalAge(TDob,+$H),"Y",1)
 	...s TDob=##class(web.DHCBillInterface).GetPapmiAge(PapmiDR,PAADM)
 	...s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	...s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
	...s GADM=$p(^DHCPEPreIADM(PreIADM),"^",2)
	...i GADM'=""  d
	....s GBaseRowID=$p(^DHCPEPreGADM(GADM),"^")
	....s TGroup=$p(^DHCPEPreGBI(GBaseRowID),"^",2)
	...e  d
	....s TGroup=""
 	...s TDepart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))
 	...d AuditRecordBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
AuditClearInfo
	s (TPAADM,TRegNo,TName,TSex,TDob,TGroup,TDepart,TErrInfo)=""
	q
AuditRecordBuild      
	set Data=$lb(TPAADM,TRecordNum,TRegNo,TName,TSex,TDob,TGroup,TDepart,TErrInfo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod AuditRecordQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AuditRecordQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AuditRecordQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AuditRecordQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="DoctorBatchRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.DoctorBatchRecordD</DataLocation>
<DefaultData>DoctorBatchRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.DoctorBatchRecordD</IdLocation>
<IndexLocation>^web.DHCPE.DoctorBatchRecordI</IndexLocation>
<StreamLocation>^web.DHCPE.DoctorBatchRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
