Class DHCEPRFS.BL.BLRecordCheck Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Desc:保存设置
/// Creator:canyxu
/// CreateDate:2013-08-02
/// Input: DHCEPRFS.Entity.RecordCheck
/// Output: DHCEPRFS.META.RecordCheck 的ID
ClassMethod SetRecordCheck(ERecordCheck As DHCEPRFS.Entity.RecordCheck) As %String
{
	s result = ""
	if ((ERecordCheck.ID '= "") && ($d(^DHCEPRFS.META.RecordCheckD(ERecordCheck.ID))))
	{
		s obj = ##Class(DHCEPRFS.META.RecordCheck).%OpenId(ERecordCheck.ID)
	}
	elseif ($d(^DHCEPRFS.META.RecordCheckI("IdxCheckName"," "_$zcvt(ERecordCheck.CheckName,"U"))) > 0)
	{
		s ID = $o(^DHCEPRFS.META.RecordCheckI("IdxCheckName"," "_$zcvt(ERecordCheck.CheckName,"U"),""))
		s obj = ##Class(DHCEPRFS.META.RecordCheck).%OpenId(ID)
	}
	else
	{
		s obj = ##Class(DHCEPRFS.META.RecordCheck).%New()
	}
	s obj.CheckName = ERecordCheck.CheckName
	s obj.CheckDesc = ERecordCheck.CheckDesc
	s obj.CheckURL = ERecordCheck.CheckURL
	s obj.CheckType = ERecordCheck.CheckType
	s obj.IsValid = ERecordCheck.IsValid
	s obj.Sequence = ERecordCheck.Sequence
	s sc = obj.%Save()
	if ($$$ISOK(sc)) 
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:根据类型输出配置项
/// Creator:canyxu
/// CreateDate:2013-08-02
/// Input: AType 类型
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLRecordCheck","GetValueByType","Left")
Query GetValueByType(AType As %String) As %Query(ROWSPEC = "ID:%String,CheckName:%String,CheckDesc:%String,CheckURL:%String,CheckType:%String,Sequence:%String")
{
}

ClassMethod GetValueByTypeExecute(ByRef qHandle As %Binary, AType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	q:(AType = "") $$$OK
	s AType = $zcvt(AType,"U")
	
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRFS.META.RecordCheckI("IdxSequence"," "_AType,sequence))
		q:(sequence = "") 
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.RecordCheckI("IdxSequence"," "_AType,sequence,rowID))
			q:(rowID = "")
			
			s obj = ##Class(DHCEPRFS.META.RecordCheck).%OpenId(rowID)
			q:(obj = "")
			continue:(obj.IsValid '= "Y")&&(obj.IsValid '= "1")
			
			s CheckName = obj.CheckName
			s CheckDesc = obj.CheckDesc
			s CheckURL = obj.CheckURL
			s CheckType = obj.CheckType
			s Sequence = obj.Sequence
			
			s data = $lb(rowID,CheckName,CheckDesc,CheckURL,CheckType,Sequence)
			s ^CacheTemp(repid,ind)=data
			s ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetValueByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetValueByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetValueByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetValueByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Debug: w ##Class(DHCEPRFS.BL.BLRecordCheck).GetValueByTypeStr("Left")
ClassMethod GetValueByTypeStr(Atype As %String) As %String
{
	s result = ""
	s dt = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLRecordCheck:GetValueByType")
	d dt.Execute(Atype)
	While (dt.Next()) {
		s result = result_"$"
		s result = result_dt.Data("CheckName")_"^"_dt.Data("CheckDesc")_"^"_dt.Data("CheckURL")
	}
	s result = $e(result,2,$l(result))
	q result
}

/// Debug: w ##Class(DHCEPRFS.BL.BLRecordCheck).GetCountByTypeStr("Left")
ClassMethod GetCountByTypeStr(Atype As %String) As %Integer
{
	s count = 0
	s dt = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLRecordCheck:GetValueByType")
	d dt.Execute(Atype)
	While (dt.Next()) {
		s count = count + 1
	}
	q count
}

/// Debug: w ##Class(DHCEPRFS.BL.BLRecordCheck).SetValue()
ClassMethod SetValue(CheckName As %String, CheckDesc As %String, CheckType As %String, CheckURL As %String, Sequence As %String) As %String
{
	s Eobj = ##Class(DHCEPRFS.Entity.RecordCheck).%New()
	s Eobj.CheckName = CheckName
	s Eobj.CheckDesc = CheckDesc
	s Eobj.CheckType = CheckType
	s Eobj.CheckURL = CheckURL
	s Eobj.IsValid = "1"
	s Eobj.Sequence = Sequence
	s result = ..SetRecordCheck(Eobj)
	q result
}

}
