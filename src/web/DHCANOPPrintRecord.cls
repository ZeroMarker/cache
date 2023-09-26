Import SQLUser

Class web.DHCANOPPrintRecord Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindPrintRecord(stDate As %String, endDate As %String, opRoomId As %String = "", schLocId As %String = "", schPrType As %String = "", regNo As %String = "") As %Query(ROWSPEC = "tPatName:%String,tRegNo:%String,tOpName:%String,tOpDateTime:%String,tOpRoom:%String,tPrtTitle:%String,tLoc:%String,tPrStatus:%String,tNote:%String,tUser :%String,tPrDate:%String,tPrTime:%String,clprId: %String")
{
}

ClassMethod FindPrintRecordExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, opRoomId As %String = "", schLocId As %String = "", schPrType As %String = "", regNo As %String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
     k ^TMPANOP("PR",$j)
	i (stDate="")!(stDate="") s sDate=+$H,eDate=+$H
	e  s sDate=##Class(web.DHCANOPCom).ConvertToDateH(stDate),eDate=##Class(web.DHCANOPCom).ConvertToDateH(endDate)
    f date=sDate:1:eDate
    {  
     s opaId=""
     f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
	 .q:$d(^DHCANOPArrange(opaId))<1
	 .s opStDate=$P(^DHCANOPArrange(opaId),"^",14)
	 .s opStTime=$P(^DHCANOPArrange(opaId),"^",15)
	 .s tOpDateTime=$ZD(opStDate,4)_" "_$ZT(opStTime,2)
	 .s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
	 .q:adm=""
	 .s papmiId=$p($g(^PAADM(admId)),"^",1)
	 .s tRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	 .q:(tRegNo'=regNo)&(regNo'="")
	 .;s tMedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	 .s paadmtype=$p($g(^PAADM(admId)),"^",2)
	 .s tMedCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	 .;q:(tMedCareNo'=medCareNo)&(medCareNo'="")
	 .s tPatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	 .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	 .s i=0
	 .s tOpName=""
	 .s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d 
	 ..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)      
	 ..i opdr'=""  d 
	 ...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d   
	 ....i tOpName'="" s tOpName=tOpName_";"   
	 ....s tOpName=tOpName_$P($g(^ORC("OPER",+opdr)),"^",2) 
	 ..e  d
	 ...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
	 ....i tOpName'="" s tOpName=tOpName_";"
	 ....s tOpName=tOpName_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2)) 
	 ..s i=i+1
	 ..q:i>1 
	 .s tOpRoomDes=""
	 .s opRoomDr=$P(^DHCANOPArrange(opaId),"^",20)
	 .q:(opRoomDr'=opRoomId)&(opRoomId'="")
	 .i opRoomDr'="" s tOpRoom=$p($g(^DHCANC("OPRoom",opRoomDr)),"^",2)
	 .s clprId=""
	 .f  s clprId=$o(^DHCCLPrintRecord(0,"OPA",opaId,clprId))  q:(clprId="")  d
	 ..b
	 ..s str=^DHCCLPrintRecord(clprId)
	 ..s prDate=$li(str,1)
	 ..s tPrDate=$zd(prDate,4)
	 ..s prTime=$li(str,2)
	 ..s tPrTime=$zt(prTime,2)
	 ..s tPrtTitle=$li(str,7)
	 ..s prStatus=$li(str,9)
	 ..i prStatus="N" s tPrStatus="未上传"
	 ..i prStatus="U" s tPrStatus="上传成功"
	 ..i prStatus="E" s tPrStatus="上传失败"
	 ..s tNote=$li(str,10)
	 ..s userId=$li(str,11)
	 ..s tUser=$p($g(^SSU("SSUSR",userId)),"^",2)
	 ..s locId=$li(str,8)
	 ..q:(schLocId'=locId)&(schLocId'="")
	 ..s tLoc=$P($g(^CTLOC(locId)),"^",2)
	 ..s ^TMPANOP("PR",$j,opRoomDr,admId,clprId)=$lb(tPatName,tRegNo,tOpName,tOpDateTime,tOpRoom,tPrtTitle,tLoc,tPrStatus,tNote,tUser,tPrDate,tPrTime,clprId)
	 s sortId1="" 
	 f  s sortId1=$o(^TMPANOP("PR",$j,sortId1)) q:sortId1=""  d
	 .s sortId2="" 
	 .f  s sortId2=$o(^TMPANOP("PR",$j,sortId1,sortId2)) q:sortId2=""  d
	 ..s sortId3=""
	 ..f  s sortId3=$o(^TMPANOP("PR",$j,sortId1,sortId2,sortId3)) q:sortId3=""  d
	 ...d OutputPrintRecord
	 k ^TMPANOP("PR",$j)
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPrintRecord
    //Set Data=$lb(tPatName,tRegNo,tOpName,tOpDateTime,tOpRoom,tPrtTitle,tLoc,tPrStatus,tNote,tUser,tPrDate,tPrTime,clprId)
	Set ^CacheTemp(repid,ind)=^TMPANOP("PR",$j,sortId1,sortId2,sortId3)
	Set ind=ind+1
	Quit
}

ClassMethod FindPrintRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPrintRecordExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else  {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPrintRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPrintRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
