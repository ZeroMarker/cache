/// CTOR: QP
/// DATE: 2022-06-25
/// DESC: CRO业务类
Class DHCDoc.GCP.BS.CRO Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2022-06-25
/// DESC: 保存
/// IN  : 
/// OUT : 
/// TABL:
/// EXEC: w ##class(DHCDoc.GCP.BS.CRO).Save(^TEMP("qiupeng",1), ^TEMP("qiupeng",2))
ClassMethod Save(MID As %String, CROInfo As %String) As %String
{
	s ^TEMP("qiupeng",1)=MID
	s ^TEMP("qiupeng",2)=CROInfo
	s index=""
	s rtn="1^保存成功！"
	Q:(CROInfo="")||(MID="") rtn
	K BaseParamArr
	f i=1:1:$l(CROInfo,$C(2)) {
		s oneStr=$p(CROInfo,$C(2),i)
		s BaseParamArr(i,"ID")=$p(oneStr,$C(1),1)
		s BaseParamArr(i,"CROCompany")=$p(oneStr,$C(1),2)
		s BaseParamArr(i,"CROContact")=$p(oneStr,$C(1),3)
		s BaseParamArr(i,"CROContactTel")=$p(oneStr,$C(1),4)
	}
	for {
		s index=$o(BaseParamArr(index))
		q:index=""
		m CurArr=BaseParamArr(index)
		s rtn=..SaveOne(MID,.CurArr)
		q:+rtn<0	
		
	}
	
	Q rtn
}

/// CTOR: QP
/// DATE: 2022-06-25
/// DESC: 保存
/// IN  : 
/// OUT : 
/// TABL:
/// EXEC: w ##class(DHCDoc.GCP.BS.CRO).Save(^TEMP("QIUP",1))
ClassMethod SaveOne(MID As %String, ByRef BaseParamArr) As %String
{
	s ID=..%GetArrField("ID",.BaseParamArr)
	i ID = "" {
		s SaveOBJ = ##class(User.DHCDocPilotProjectCRO).%New(MID)
		d SaveOBJ.CROParefSetObjectId(MID)
	} else  {
		s SaveOBJ = ##class(User.DHCDocPilotProjectCRO).%OpenId(ID)
	}
	s SaveOBJ.CROCompany=..%GetArrField("CROCompany",.BaseParamArr)
	s SaveOBJ.CROContact=..%GetArrField("CROContact",.BaseParamArr)
	s SaveOBJ.CROContactTel=..%GetArrField("CROContactTel",.BaseParamArr)
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		;d $system.OBJ.DisplayError(sc) 
		Quit "-1^保存失败！"
	}
	k SaveOBJ
	
	Q "1^保存成功！"
}

/// CTOR: QP
/// DATE: 2022-06-25
/// DESC: 获取数组字段值
ClassMethod %GetArrField(InCode As %String, ByRef TList, DefaultValue As %String = "") As %String
{
	Q:InCode="" DefaultValue
	Q:'$d(TList(InCode)) DefaultValue
	Q:$g(TList(InCode))="" DefaultValue
	Q $g(TList(InCode))
}

/// CTOR: QP
/// DATE: 2022-06-25
/// DESC: 删除
ClassMethod Delete(ID)
{
	Q:ID="" "-1^记录ID不存在"
	q:##class(User.DHCDocPilotProjectCRO).%ExistsId(ID)=0 "-1^数据库中不存在该记录"
	s sc=##class(User.DHCDocPilotProjectCRO).%DeleteId(ID)
	i $$$ISERR(sc) {
		s errCode="-101^删除失败"
		Q
	}

	q 0_"^"
}

/// CTOR: QP
/// DATE: 2022-06-25
/// DESC: 查询
/// IN  : 
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCP.BS.CRO","QryList","11")
Query QryList(InPID = "") As %Library.Query(ROWSPEC = "rowid,CROCompany,CROContact,CROContactTel")
{
}

ClassMethod QryListExecute(ByRef qHandle As %Library.Binary, InPID = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (InPID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s rowid=""
	for {
		s rowid=$o(^User.DHCDocPilotProjectCROI("CROParef",InPID,rowid))
		q:rowid=""
		s CROCompany=$lg(^User.DHCDocPilotProjectCROD(rowid),3)
		s CROContact=$lg(^User.DHCDocPilotProjectCROD(rowid),4)
		s CROContactTel=$lg(^User.DHCDocPilotProjectCROD(rowid),5)
		d OuputRow1
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OuputRow1
	set Data=$lb(rowid,CROCompany,CROContact,CROContactTel)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryListFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryListExecute ]
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

ClassMethod QryListClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryListFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
