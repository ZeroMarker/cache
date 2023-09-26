Class web.DHCDocExceedReason Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query DHCExceedReason(ExceedType As %String, ExceedCode As %String, ExceedDesc As %String, HospID = "") As %Query(ROWSPEC = "ExceedID:%String,TExceedCode:%String,TExceedDesc:%String,TExceedFromDate:%String,TExceedEndDate:%String,TExceedType:%String")
{
}

ClassMethod DHCExceedReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCExceedReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// desc 输出所有超限原因
ClassMethod DHCExceedReasonExecute(ByRef qHandle As %Binary, ExceedType As %String, ExceedCode As %String, ExceedDesc As %String, HospID = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocExceedReason","DHCExceedReason")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ExceedCode=$ZCVT(ExceedCode,"U")
	s ExceedDesc=$ZCVT(ExceedDesc,"U")
	set (TID,TReason,ValidSttDate,ValidEndDate)=""
 	s ExceedID=0  f  s ExceedID=$O(^DHCDocExceedReason(ExceedID)) Q:ExceedID=""  d
 	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHCDoc_ExceedReason",ExceedID,HospID)
 	.s ExceedStr=$G(^DHCDocExceedReason(ExceedID))
 	.Q:ExceedStr=""
 	.s TExceedCode=$P(ExceedStr,"^",1)
	.q:(ExceedCode'="")&&($ZCVT(TExceedCode,"U")'=ExceedCode)
 	.s TExceedDesc=$P(ExceedStr,"^",2)
	.q:(ExceedDesc'="")&&($ZCVT(TExceedDesc,"U")'=ExceedDesc)
 	.s TExceedType=$P(ExceedStr,"^",3)
 	.Q:(ExceedType'="")&(TExceedType'=ExceedType)
 	.s TExceedFromDate=$P(ExceedStr,"^",4)
 	.if TExceedFromDate'="" s TExceedFromDate=..%ZD(TExceedFromDate) //$ZD(TExceedFromDate,4)
 	.s TExceedEndDate=$P(ExceedStr,"^",5)
 	.if TExceedEndDate'="" s TExceedEndDate=..%ZD(TExceedEndDate) //$ZD(TExceedEndDate,4)
	.Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ExceedID,TExceedCode,TExceedDesc,TExceedFromDate,TExceedEndDate,TExceedType)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	quit
}

ClassMethod DHCExceedReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCExceedReasonExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

/// 插入
/// w ##class(web.DHCDocExceedReason).Insert($G(^Tempzong("Insert")))
ClassMethod Insert(str As %String, HospID = "") As %String
{
	s (ExceedCode,ExceedDesc,ExceedFromDate,ExceedEndDate,ExceedType)=""
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHCDoc_ExceedReason",HospID)
	s ExceedCode=$P(str,"^",1)
	s ExceedDesc=$P(str,"^",2)
	s ExceedType=$P(str,"^",3)
	s ExceedFromDate=$P(str,"^",4)
	if ExceedFromDate'="" s ExceedFromDate=..%ZDH(ExceedFromDate) //$ZDH(ExceedFromDate,4)
	s ExceedEndDate=$P(str,"^",5)
	if ExceedEndDate'="" s ExceedEndDate=..%ZDH(ExceedEndDate) //$ZDH(ExceedEndDate,4)
	s ID=""
	&sql(select DHCExceed_RowID into:ID from sqluser.DHCDoc_ExceedReason where DHCExceed_Code=:ExceedCode and DHCExceed_Desc=:ExceedDesc)
	q:ID'="" ",记录重复!"
	&sql(insert sqluser.DHCDoc_ExceedReason 
	(DHCExceed_Code,DHCExceed_Desc,DHCExceed_Type,DHCExceed_FromDate,DHCExceed_EndDate)
	values (:ExceedCode,:ExceedDesc,:ExceedType,:ExceedFromDate,:ExceedEndDate) 
	 )
	if 'SQLCODE{
		d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHCDoc_ExceedReason",$p(%ROWID,$c(1)),HospID)
	}
	q SQLCODE
}

/// 更新
ClassMethod Update(ID As %String, str As %String) As %String
{
	s ^Tempzong("Update")=ID_","_str
	s (ExceedCode,ExceedDesc,ExceedFromDate,ExceedEndDate,ExceedType)=""
	s ExceedCode=$P(str,"^",1)
	s ExceedDesc=$P(str,"^",2)
	s ExceedType=$P(str,"^",3)
	s ExceedFromDate=$P(str,"^",4)
	if ExceedFromDate'="" s ExceedFromDate=..%ZDH(ExceedFromDate) //$ZDH(ExceedFromDate,4)
	s ExceedEndDate=$P(str,"^",5)
	if ExceedEndDate'="" s ExceedEndDate=..%ZDH(ExceedEndDate) //$ZDH(ExceedEndDate,4)
	s SelID=""
	&sql(select DHCExceed_RowID into:SelID from sqluser.DHCDoc_ExceedReason where DHCExceed_Code=:ExceedCode and DHCExceed_Desc=:ExceedDesc and DHCExceed_RowID<>:ID)
	q:SelID'="" ",记录重复!"
	&sql(Update sqluser.DHCDoc_ExceedReason 
	(DHCExceed_Code,DHCExceed_Desc,DHCExceed_Type,DHCExceed_FromDate,DHCExceed_EndDate)
	values (:ExceedCode,:ExceedDesc,:ExceedType,:ExceedFromDate,:ExceedEndDate)
	where DHCExceed_RowID=:ID
	 )
	q SQLCODE
}

/// 删除
ClassMethod Delete(ID As %String) As %String
{
	&sql(Delete sqluser.DHCDoc_ExceedReason where DHCExceed_RowID=:ID)
	q SQLCODE
}

ClassMethod GetExceedStr(EsceedType As %String = "", DataType As %String = "", HospID = "") As %String
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set langid=..%LanguageID()
	s Rtn="" 
	s ExceedID=0  f  s ExceedID=$O(^DHCDocExceedReason(ExceedID)) Q:ExceedID=""  d
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHCDoc_ExceedReason",ExceedID,HospID)
 	.s ExceedStr=$G(^DHCDocExceedReason(ExceedID))
 	.Q:ExceedStr=""
 	.s ExceedCode=$P(ExceedStr,"^",1)
 	.s ExceedDesc=$P(ExceedStr,"^",2)
 	.Set ExceedDesc= ##class(User.DHCDocExceedReason).GetTranByDesc("DHCExceedDesc",ExceedDesc,langid)
 	.s ExceedDesc=##class(web.DHCDocUtil).EvalJSON(ExceedDesc)
 	.s ExceedType=$P(ExceedStr,"^",3)
 	.s ExceedFromDate=$P(ExceedStr,"^",4)
 	.Q:(EsceedType'="")&&(EsceedType'=ExceedType)
 	.Q:(ExceedFromDate'="")&(ExceedFromDate>+$H)
 	.s ExceedEndDate=$P(ExceedStr,"^",5)
 	.Q:(ExceedEndDate'="")&(ExceedEndDate<+$H)
 	.i DataType="json" d
 	..i Rtn="" s Rtn=ExceedID_":"_ExceedDesc
 	..else  s Rtn=Rtn_";"_ExceedID_":"_ExceedDesc
 	.else  d
	..i Rtn="" s Rtn=ExceedID_$C(1)_ExceedDesc
	..e  s Rtn=Rtn_"^"_ExceedID_$C(1)_ExceedDesc
	q Rtn
}

/// 获取对应别人类型的超限天数限制
/// ##class(web.DHCDocExceedReason).GetExceedDate("O")
ClassMethod GetExceedDate(AdmType As %String) As %String
{
	Q ..%GetConfig("ExceedDate_"_AdmType)
	
	Q:AdmType="" 0
	s DateNUm=+$G(^DHCDocExceedReason(0,AdmType))
	Q DateNUm
}

/// 设置对应别人类型的超限天数限制
ClassMethod SetExceedDate(AdmType As %String, DateNum As %String) As %String
{
	Q:AdmType="" "-1"
	s ^DHCDocExceedReason(0,AdmType)=DateNum
	Q 0
}

}
