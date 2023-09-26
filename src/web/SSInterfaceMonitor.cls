Class web.SSInterfaceMonitor Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 187;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INTMON_RowId";

Parameter SQLDESCRIPTION = "INTMON_RowId";

Parameter SQLROWID = "INTMON_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// SA 24.10.02 - Method implemented for log 29789, to be called from SSInterfaceMonitor.List->Start/Stop field.
ClassMethod StartStopInterface(compref As %Library.String, ByRef id As %Library.String = "")
{
}

/// Log 46439 - AI - 22-10-2004 : Add logic to build the two messages for new rejections and errors.
/// Log 39102 - AI - 12-09-2003 : Method to call UpdateFromSSHL7 Method for all Interfaces.
/// 			To be called from Refresh Link on SSInterfaceMonitor.List, and at the end of StartStopInterface method.
ClassMethod UpdateAllInterfaces()
{
}

/// Log 46439 - AI - 22-10-2004 : Add logic to build the two messages for new rejections and errors.
/// cjb 05/03/2005 51198 - changed this methd quite a bit.  removed sql and optimised the code to speed it up a bit.  Orig method commented out below, but can be removed after a while if there are no probs
ClassMethod UpdateFromSSHL7(intcode As %Library.String = "", ByRef rejmsg As %Library.String, ByRef errmsg As %Library.String)
{
}

/*
ClassMethod UpdateFromSSHL7(intcode As %Library.String = "", ByRef rejmsg As %Library.String, ByRef errmsg As %Library.String)
{
 n existinglasterr,existinglastdate,existinglastseq
 s (introw, status, intstdate, intsttime, active, lastdate, lasttime, intcount, queuecnt, rejdate, rejtime, rejcnt)=""
 &SQL(	SELECT INT_RowId
 		INTO :introw
 		FROM SQLUser.SS_Interface
 		WHERE INT_Code = :intcode)
 q:introw=""

 &SQL(	SELECT *
 		INTO :INTM()
 		FROM SQLUser.SS_InterfaceMonitor
 		WHERE INTMON_RowId = :introw)
 s updins=$s(SQLCODE=0:"U",1:"I")
 s active=$g(INTM(6))
 k INTM

 ; extract start date, time and number of messages since last start
 &SQL(	SELECT HL7_DateStarted, HL7_TimeStarted, HL7_MessageCount, HL7_DateLastMessage, HL7_TimeLastMessage
 		INTO :intstdate, :intsttime, :intcount, :lastdate, :lasttime
 		FROM SQLUser.SS_HL7
 		WHERE HL7_RowId = :intcode)

 ; extract most recent rejection and number of un-acked rejections
 s (rejcnt,rejdate,rejtime,first)="",code=##Class(%Collation).AlphaUp(intcode)
 s rej="" f  s rej=$o(^OEHLi("LinkID",code,rej),-1) q:rej=""  d
 .s (dateack,daterej,timerej)=""
 . &SQL(SELECT HL7_DateAcknow, HL7_DateReceived, HL7_TimeReceived INTO :dateack, :daterej, :timerej FROM SQLUser.OE_HL7Messages WHERE HL7_RowId = :rej)
 .i dateack="" s rejcnt=rejcnt+1
 .i 'first s rejdate=daterej,rejtime=timerej,first=1
 
 ; Log 46439 - AI - 22-10-2004 : Add logic to build the two messages for new rejections and errors.
 ; Rejections
 s latestrej=$o(^OEHLi("LinkID",code,""),-1)
 i $g(^SST("INT",introw,"LATEST","REJ"))<latestrej d
 . s rejmsg=rejmsg_$s(rejmsg'="":"^",1:"")_intcode
 s ^SST("INT",introw,"LATEST","REJ")=latestrej
 
 ; Errors
 ; Log 48774 - AI - 10-01-2005 : The previous way we did the "check for new errors" was terrible and slow.
 ;                Setting now done when an error message is created. We just check if the node exists.
 ;s existinglasterr=$g(^SST("INT",introw,"LATEST","ERR"))
 ;s existinglastdate=$p(existinglasterr,"*",1)
 ;s existinglastseq=$p(existinglasterr,"*",2)
 ;s found=0
 ;s lasterr=""
 ;s date="" f  s date=$o(^SSHL7(intcode,"TRACE",date),-1) q:date=""  q:date<existinglastdate  q:found  d
 ;. s seq="" f  s seq=$o(^SSHL7(intcode,"TRACE",date,seq),-1) q:seq=""  q:((date=existinglastdate)&(seq<existinglastseq))  q:found  d
 ;. . i $p(^SSHL7(intcode,"TRACE",date,seq),"^",3)="ERR" d
 ;. . . s lasterr=date_"*"_seq
 ;. . . s found=1
 ;i $g(^SST("INT",introw,"LATEST","ERR"))<lasterr d
 ;. s errmsg=errmsg_$s(errmsg'="":"^",1:"")_intcode
 ;i lasterr'="" s ^SST("INT",introw,"LATEST","ERR")=lasterr
 
 i $d(^SST("INT",introw,"LATEST","ERR")) d
 . s errmsg=errmsg_$s(errmsg'="":"^",1:"")_intcode
 . k ^SST("INT",introw,"LATEST","ERR")
 ; end Log 48774
 ; end Log 46439
 
 ; number of messages in outbound queue
 s (queuecnt,x)="" f  s x=$o(^SSHL7(intcode,"QUEUE",x)) q:x=""  d
 .i $d(^SSHL7(intcode,"QUEUE",x))>10 s queuecnt=queuecnt+1

 ; check connection status
 l ^SSHL7(intcode,"LOCK"):1 s status=$s($t:"D",1:"U")
 l -^SSHL7(intcode,"LOCK")
 ; SB: 21/05/03 - we shouldn't change this flag when refreshing as it will interfere with the starting/stopping process.
 ;s active=$s(status="D":"N",1:"Y")
 ;s active=..checkConnStatus(intcode)

 k PLIST
 s PLIST(2)=$g(introw),PLIST(3)=$g(status),PLIST(4)=$g(intstdate),PLIST(5)=$g(intsttime),PLIST(6)=$g(active)
 s PLIST(7)=$g(lastdate),PLIST(8)=$g(lasttime),PLIST(9)=$g(intcount),PLIST(10)=$g(queuecnt)
 s PLIST(11)=$g(rejdate),PLIST(12)=$g(rejtime),PLIST(13)=$g(rejcnt)

 i updins="I" d
 . &SQL(INSERT INTO SQLUser.SS_InterfaceMonitor VALUES :PLIST())

 i updins="U" d
 .s PLIST(1)=introw
 . &SQL(UPDATE SQLUser.SS_InterfaceMonitor VALUES :PLIST() WHERE INTMON_RowId = :introw)
}
*/
/// Log 46439 - AI - 22-10-2004 : Add logic to build the two messages for new rejections and errors.
ClassMethod checkConnStatus(intcode As %Library.String = "") As %Library.String
{
}

}
