Class web.DHCRisCommFunctionNew Extends %RegisteredObject
{

ClassMethod formatDate(Date, i)
{
	q:Date="" ""
	if Date["-" s Date=$zdh(Date,3)
	if Date["/" s Date=$zdh(Date,4)
	q:i=0 Date
	q $zd(Date,i)
}

ClassMethod QueryExamItem(StrParam As %String, Start As %Integer, Limit As %Integer) As %String
{
	//w ##class(web.DHCRisCommFunctionNew).QueryExamItem("^^^402^^^^^^^^^false^^^^^^false^false^N^N^^^^^^^06/07/2016^06/07/2016^N^N^"_$c(2)_"64105"_$c(2)_"64105"_$c(2)_"1","0","25")
	s ^Temp("QueryExamItem")=$lb(StrParam,Start,Limit)
	s json = ##class(Code.JsonObj).%New()
	s count=0
	s end=Start+Limit
	
	s strCondition=$p(StrParam,$c(2),1)
	s StdDate=$p(StrParam,$c(2),2)
	s enddate=$p(StrParam,$c(2),3)
	s BookedType=$p(StrParam,$c(2),4)
	s ^Temp("bcy_query") = strCondition_","_StdDate_","_enddate_","_BookedType
	i $p(strCondition,"^",2)="0006221820" s ^Temp("bcy_querywbf") = strCondition_","_StdDate_","_enddate_","_BookedType
	
	set rset=##Class(%ResultSet).%New("web.DHCRisWorkBenchDoEx.QueryExamItem")
 	do rset.Execute(strCondition,StdDate,enddate,BookedType)
 	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s RowData=""
		For col = 1:1:columns {
			if col=1 set RowData=rset.GetData(col)
			e  s RowData=RowData_"^"_rset.GetData(col)
		}
		s count=$G(count)+1
		b ;
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(RowData)
	}
	d rset.Close()

	s Title="Tregno^TName^TSex^TAge^TDob^TDiagonse^TStudyNo^TstrOrderName^TDoctor^TstrAccessionNum^TstrDate^TstrTime^TAppointDate^TAppointstTime^TBookedDuration^TstrRegDate^TstrRegTime^TReportDoc^TReportVerifyDoc^TPatientStatus^Tpaadmdr^TOeorditemdr^TLocName^Tprice^TOEORIItemStatus^TBillStatus^TPatientType^TNum^TPerprice^TIndex^TRegEQ^TBookedRes^Tifbed^TReportStatus^TMainDoc^TAssDoc^TRegRoom^TEQroupDesc^TWardDesc^TNo^TRequired^THopeTime^TOrdStatus^TPatMasDR^TBodyPart^TWeight^TTelNo^TIPNO^TSentFilm^TBedCode^TSendPrint^HasImage^RecLocId^RecLoc^AutoInputFee^EndInputFee^Detail^RejectAppReason^BilledDesc^PinYin^ToDayOeItem^CostRecords^AppDate^UrgentFlag^TRegDoc^TEpissubtype^SGroupDesc^SGroupDR^AppointUser^AppBillView^AdmReason^ExterBK^BodyCode^AppBillNo^BKStudyNo^AccUsePrice^GetResultFlag"
	s resultString = json.getJsonData(Title,count)
	k json
	q resultString
}

//w ##class(web.DHCRisCommFunctionNew).GetRecDep("5050","","")

ClassMethod GetRecDep(USERID, Start, Limit)
{
	s ^Temp("GetRecDep")=$lb(USERID, Start, Limit)
	s Start=0
	s Limit=99
	s result = ##class(%Library.ResultSet).%New()
    s resultString = ""
    s count = 0
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()

	set rset=##Class(%ResultSet).%New("web.DHCRisCommFunction.QueryOtherLogLoc")
 	do rset.Execute(USERID)
	While (rset.Next()) {
			s Description=rset.GetData(1)
			s RowId=rset.GetData(2)
			s tmp=RowId_"^"_Description
    		s count = count+1
    		i (count>Start)&(count<=end) d
    		.d json.InsertRowData(tmp)
	}
	d rset.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

//w ##class(web.DHCRisCommFunctionNew).GetRisStatus("1","0",20)

ClassMethod GetRisStatus(USERID, Start, Limit)
{
	s ^Temp("SystemPatientStatus")=$lb(USERID, Start, Limit)
	s Start=0
	s Limit=99
	s result = ##class(%Library.ResultSet).%New()
    s resultString = ""
    s count = 0
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
	set rset=##Class(%ResultSet).%New("web.DHCRisCommFunction.QuerySystemPatientStatus")
 	do rset.Execute(USERID)
	While (rset.Next()) {
			s RowId=rset.GetData(2)
			s Description=rset.GetData(3)
			s tmp=RowId_"^"_Description
    		s count = count+1
    		i (count>Start)&(count<=end) d
    		.d json.InsertRowData(tmp)
	}
	d rset.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

ClassMethod ReadCardType()
{
	s Start=0
	s Limit=99
	s result = ##class(%Library.ResultSet).%New()
    s resultString = ""
    s count = 0
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
     
    k CardType  
    s myTypeID=""
    f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.if myDefault="Y" s CardType(0,myTypeID)=myTypeID_"^"_mydes
	.else  s CardType(1,myTypeID)=myTypeID_"^"_mydes

	s def="" f  s def=$o(CardType(def)) q:def=""  do
	.s myTypeID="" f  s myTypeID=$o(CardType(def,myTypeID)) q:myTypeID=""  do
	..s tmp=$g(CardType(def,myTypeID))
    ..s count = count+1
    ..i (count>Start)&(count<=end) d
    ..d json.InsertRowData(tmp)
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

ClassMethod GetCardTypeDefault(CardType) As %String
{
	s myval=""
	if CardType'=""  do
	.s myval=CardType_"^"_$g(^DHCCARDTYPEDef(CardType))
	q myval
}

// w ##class(web.DHCRisCommFunctionNew).GetRegNoByCardNo("3","0140066724")

ClassMethod GetRegNoByCardNo(CardType, CardNo) As %String
{
	s ^temp("GetRegNoByCardNo")=$lb(CardType,CardNo)
	s CFPAPMINo=""
	s CardType=""
	for
	{
		s CardType=$o(^DHCCARDi("CF",0,"CardTypeNo",CardType))
		q:(CardType="")
		s CFRowID="" f  s CFRowID=$o(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo,CFRowID)) q:CFRowID=""  do
		.s CFActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
		.q:CFActiveFlag'="N"
		.s CFCancleDate=$p(^DHCCARD("CF",CFRowID),"^",13)
		.q:(CFCancleDate'="")&&(CFCancleDate<+$h)
		.s CFPAPMINo=$p(^DHCCARD("CF",CFRowID),"^",6)
	}
	q CFPAPMINo
}

ClassMethod SetLockValue(Info, Userid)
{
	s ^DHCRisLockValue(Userid)=Info
	q 1
}

ClassMethod GetLockValue(Userid)
{
	q $g(^DHCRisLockValue(Userid))
}

//w ##class(web.DHCRisCommFunctionNew).GetDevice("1","0",20)

ClassMethod GetDevice(LocDR As %String, RoomDR As %String, Start, Limit) As %String
{
	s ^Temp("GetDevice")=$lb(LocDR, RoomDR, Start, Limit)
	s Start=0
	s Limit=99
	s result = ##class(%Library.ResultSet).%New()
    s resultString = ""
    s count = 0
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
	set rset=##Class(%ResultSet).%New("web.DHCRisCommFunction.QueryEQ")
 	do rset.Execute(LocDR,RoomDR)
	While (rset.Next()) {
			s rw=rset.GetData(1)
			s code=rset.GetData(2)
			s desc=rset.GetData(3)
			s tmp=rw_"^"_desc
    		s count = count+1
    		i (count>Start)&(count<=end) d
    		.d json.InsertRowData(tmp)
	}
	d rset.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

// //w ##class(web.DHCRisCommFunctionNew).GetCareProv("414","0",20)

ClassMethod GetCareProv(LocDR As %String, Start, Limit)
{
	s ^Temp("GetCareProv")=$lb(LocDR, Start, Limit)
	s Start=0
	s Limit=99
	s result = ##class(%Library.ResultSet).%New()
    s resultString = ""
    s count = 0
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
	set rset=##Class(%ResultSet).%New("web.DHCRisCommFunction.GetCareProv")
 	do rset.Execute(LocDR)
	While (rset.Next()) {
			s rw=rset.GetData(1)
			s desc=rset.GetData(2)
			s tmp=desc_"^"_rw
    		s count = count+1
    		i (count>Start)&(count<=end) d
    		.d json.InsertRowData(tmp)
	}
	d rset.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

ClassMethod QueryPatientBookedItem(EpsodeId As %String, Start As %Integer, Limit As %Integer) As %String
{
	//w ##class(web.DHCRisCommFunctionNew).QueryPatientBookedItem("321","0","999")
	s ^Temp("QueryExamItem")=$lb(EpsodeId,Start,Limit)
	s json = ##class(Code.JsonObj).%New()
	s count=0
	s end=Start+Limit
	set rset=##Class(%ResultSet).%New("web.DHCRisResourceApptSchudleEx.QueryPatientBookedItem")
 	do rset.Execute(EpsodeId)
 	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s RowData=""
		For col = 1:1:columns {
			if col=1 set RowData=rset.GetData(col)
			e  s RowData=RowData_"^"_rset.GetData(col)
		}
		s count=$G(count)+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(RowData)
	}
	d rset.Close()
	s Title="TBookedDate^TTimeDesc^TBooketTime^TstrOrderName^TLocDesc^TResourceDesc^TName^TRegNo^TOrdItemRowid^TMemo"
	s resultString = json.getJsonData(Title,count)
	k json
	q resultString
}

Storage Default
{
<Data name="DHCRisCommFunctionNewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCRisCommFunctionNewD</DataLocation>
<DefaultData>DHCRisCommFunctionNewDefaultData</DefaultData>
<IdLocation>^web.DHCRisCommFunctionNewD</IdLocation>
<IndexLocation>^web.DHCRisCommFunctionNewI</IndexLocation>
<StreamLocation>^web.DHCRisCommFunctionNewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
