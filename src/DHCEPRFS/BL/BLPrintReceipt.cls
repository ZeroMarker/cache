Class DHCEPRFS.BL.BLPrintReceipt Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod SetDefault(AID As %String, AType As %String = "CHARGE") As %String
{
	s obj = ##class(DHCEPRFS.META.PrintReceipt).%OpenId(AID) 
	s type = obj.Type
	q:(type '= AType) "-2"
	
	TSTART
	s $zt = "OnSetDefaultErrorHandler"
	
	//清除之前的默认
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.PrintReceiptI("IdxIsDefault"," "_AType," Y",rowID))	
	
	if (rowID '= "")
	{
		s objOld = ##class(DHCEPRFS.META.PrintReceipt).%OpenId(rowID)
		s objOld.IsDefault = ""
		s status = objOld.%Save()
		if ('$$$ISOK(status))
		{
			TROLLBACK
			q ""
		}
	}

	s obj.IsDefault = "Y"
	s status = obj.%Save()
	if ('$$$ISOK(status))
	{
		TROLLBACK
		q ""
	}

	TCOMMIT
	q obj.%Id()	

OnSetDefaultErrorHandler
	TROLLBACK
	q ""
}

ClassMethod Update(AID As %String, AMRUserID As %String, AText As %String) As %String
{
	s obj = ##class(DHCEPRFS.META.PrintReceipt).%OpenId(AID)
	s obj.LastModifyMRUserID = AMRUserID
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.TempleContent = AText
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod UpdateIncludeImage(Apara As DHCEPRFS.Entity.EPrintReceipt) As %String
{
	s obj = ##class(DHCEPRFS.META.PrintReceipt).%OpenId(Apara.PrintReceiptID)
	s obj.LastModifyMRUserID = Apara.LastModifyMRUserID
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.TempleContent = Apara.TempleContent
	s obj.BackgroundImage = Apara.BackgroundImage
	s obj.Type = Apara.Type
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod Add(AMRUserID As %String, AText As %String, AType As %String = "CHARGE") As %String
{
	s obj = ##class(DHCEPRFS.META.PrintReceipt).%New()
	s obj.CreateMRUserID = AMRUserID
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyMRUserID = AMRUserID
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.PrintReceiptName = "PrintReceipt-"_$p($h,",",1)_"-"_$p($h,",",2)
	s obj.PrintReceiptDesc = "PrintReceipt-"_$p($h,",",1)_"-"_$p($h,",",2)
	s obj.TempleContent = AText
	s obj.IsDefault = ""
	s obj.Type = AType
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// debug: w ##class(DHCEPRFS.BL.BLPrintReceipt).GetBackGroundImage(2)
ClassMethod GetBackGroundImage(APrintReceiptID As %String) As DHCEPRFS.Entity.EPrintReceipt
{
	s obj = ##class(DHCEPRFS.META.PrintReceipt).%OpenId(APrintReceiptID)
	s entity = ##class(DHCEPRFS.Entity.EPrintReceipt).%New()
	s entity.BackgroundImage = obj.BackgroundImage
	s entity.PrintReceiptID = APrintReceiptID
	q entity
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLPrintReceipt","GetPrintReceiptList")
Query GetPrintReceiptList() As %Query(ROWSPEC = "ID:%String,PrintReceiptName:%String,PrintReceiptDesc:%String,IsDefault:%String,TempleContent:%String,Type:%String,TypeDesc:%String")
{
}

ClassMethod GetPrintReceiptListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.PrintReceiptD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.META.PrintReceipt).%OpenId(rowID)
		d OutPutRow	
	}

	Quit $$$OK
OutPutRow
	s ID = rowID
	s PrintReceiptName = obj.PrintReceiptName
	s PrintReceiptDesc = obj.PrintReceiptDesc
	s IsDefault = obj.IsDefault
	s TempleContent = obj.TempleContent
	s Type = obj.Type
	s TypeDesc = ""
	if (Type = "CHARGE")
	{
		s TypeDesc = "收费小票"	
	}
	elseif (Type = "RECEIPT")
	{
		s TypeDesc = "缴费凭证"	
	}
	
 	s data = $lb(ID,PrintReceiptName,PrintReceiptDesc,IsDefault,TempleContent,Type,TypeDesc)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetPrintReceiptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintReceiptListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrintReceiptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintReceiptListExecute ]
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

}
