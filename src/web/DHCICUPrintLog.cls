Class web.DHCICUPrintLog Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SavePrintLog(icuaId As %String, code As %String, date As %String, time As %String, pageNo As %String, userId As %String) As %String
{
	set printLog=##class(User.DHCICUPrintLog).%New()
	set printLog.IcuaId=icuaId
	set printLog.Code=code
	set printLog.PrintDate=##Class(web.DHCANOPCom).ConvertToDateH(date)
	set printLog.PrintTime=##Class(web.DHCANOPCom).ConvertToTimeH(time)
	set printLog.PageNo=pageNo
	set printLog.UserId=userId
	set sc=printLog.%Save()
	if ($System.Status.IsError(sc))
	{
		set saveResult="E^"_$System.Status.GetErrorText(sc)	
	}
	else
	{
		set saveResult="S^"_printLog.%Id()
	}
	quit saveResult
}

ClassMethod DeleteLogDetails(logId As %String) As %String
{
	&sql(delete from SQLUSER.DHC_ICU_PrintLogDetails where PrintLogId=:logId)
	quit SQLCODE
}

/// w ##Class(web.DHCICUPrintLog).SavePrintLogDetails("14","L","{X=1125,Y=90}","{X=1125,Y=692}","","","255,0,0,0","1","")
/// w ##Class(web.DHCICUPrintLog).SavePrintLogDetails("26","S","{X=1125,Y=90}","{X=1125,Y=692}","","","255,0,0,0","1","")
ClassMethod SavePrintLogDetails(logId As %String, type As %String, point1 As %String = "", point2 As %String = "", point3 As %String = "", textNote As %String = "", style As %String = "", color As %String, width As %String = "", heigh As %String = "", textFont As %String = "", templateCode As %String = "") As %String
{
	;set ^TMPWxx("SavePrintLogDetails")=logId_"^"_type_"^"_startPoint_"^"_endPoint_"^"_textNote_"^"_style_"^"_color_"^"_lineWidth_"^"_textFont
	set PrintLogDetails=##class(User.DHCICUPrintLogDetails).%New()
	set PrintLogDetails.PrintLogId=logId
	set PrintLogDetails.Type=type
	set PrintLogDetails.Point1=point1
	set PrintLogDetails.Point2=point2
	set PrintLogDetails.Point3=point3
	set PrintLogDetails.TextNote=textNote
	set PrintLogDetails.Style=style
	set PrintLogDetails.Color=color
	set PrintLogDetails.Width=width
	set PrintLogDetails.Heigh=heigh
	set PrintLogDetails.TextFont=textFont
	set PrintLogDetails.TemplateCode=templateCode
	set sc=PrintLogDetails.%Save()
	if ($System.Status.IsError(sc))
	{
		set saveResult="E^"_$System.Status.GetErrorText(sc)	
	}
	else
	{
		set saveResult="S^"_PrintLogDetails.%Id()
	}
	quit saveResult
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUPrintLog","LoadPrintDetails",14,1,2)
Query LoadPrintDetails(icuaId As %String, code As %String, startNo As %String, endNo As %String, needtype As %String) As %Query(ROWSPEC = "pageNo,point1,point2,point3,note,style,color,width,heigh,font,templateCode")
{
}

ClassMethod LoadPrintDetailsExecute(ByRef qHandle As %Binary, icuaId As %String, code As %String, startNo As %String, endNo As %String, needtype As %String) As %Status
{
 	set repid=$i(^CacheTemp)
 	set ind=1
 	for no=startNo:1:endNo 
 	{
	 	set lastlogId=""
	 	set logId="" 
	 	for 
	 	{
		    set logId=$order(^User.DHCICUPrintLogI("IIcuaId"," "_icuaId,logId))
		    quit:logId=""	
		    set templateCode=$list(^User.DHCICUPrintLogD(logId),2)
		    continue:templateCode'=code
		    set pageNo=$list(^User.DHCICUPrintLogD(logId),5)
		    continue:pageNo'=no
		    set lastlogId=logId
		 	
		}
		continue:lastlogId=""
		set detailsId=""
		for
		{
			set detailsId=$order(^User.DHCICUPrintLogDetailsI("IPrintLogId"," "_lastlogId,detailsId))
			quit:detailsId=""
			set PrintLogDetails=##class(User.DHCICUPrintLogDetails).%OpenId(detailsId)
			set type=PrintLogDetails.Type
			continue:needtype'=type
			set point1=PrintLogDetails.Point1
			set point2=PrintLogDetails.Point2
			set point3=PrintLogDetails.Point3
			set note=PrintLogDetails.TextNote
			set style=PrintLogDetails.Style
			set color=PrintLogDetails.Color
			set width=PrintLogDetails.Width
			set heigh=PrintLogDetails.Heigh
			set font=PrintLogDetails.TextFont
			set templateCode=PrintLogDetails.TemplateCode
			set pageNo=no
			;w !,type_"^"_startPoint_"^"_endPoint_"^"_textNote_"^"_style_"^"_color_"^"_lineWidth_"^"_textFont
			do OutPutDetails
		}
	 	
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutDetails
	set Data=$lb(pageNo,point1,point2,point3,note,style,color,width,heigh,font,templateCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod LoadPrintDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoadPrintDetailsExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LoadPrintDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoadPrintDetailsExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod GetLastPageNo(icuaId As %String, code As %String) As %String
{
	set pageNo=1
	set lastlogId=""
	set logId="" 
	for 
	{
		set logId=$order(^User.DHCICUPrintLogI("IIcuaId"," "_icuaId,logId))
		quit:logId=""	
		set templateCode=$list(^User.DHCICUPrintLogD(logId),2)
		continue:templateCode'=code
		set lastlogId=logId
		 	
	}
	quit:lastlogId="" pageNo
	set pageNo=$list(^User.DHCICUPrintLogD(lastlogId),5)
	
	quit pageNo
}

}
