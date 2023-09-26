/// 2015-08-13
/// xzy
/// 处理号 卡号 住院号
Class web.DHCEkgNo Extends %RegisteredObject
{

// 登记号长度

Parameter RegNoLength = 10;

// 卡号长度

Parameter CardNoLength = 10;

// 住院号长度

Parameter InNoLength = 6;

// 根据卡号获取登记号

ClassMethod getRegNoByCardNo(CardNo As %String) As %String
{
	//// w ##class(web.DHCEkgNo).getRegNoByCardNo("000000000001")
	quit:CardNo="" ""
    set CardRowId=0,RegNo=""
    f  set CardRowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardRowId)) q:CardRowId=""  d
    .set RegNo=$p(^DHCCARD("CF",CardRowId),"^",6) //取病人的登记号
    .set flag=$p(^DHCCARD("CF",CardRowId),"^",10)
    .quit:flag'="N"
    quit RegNo
}

// 根据住院号获取登记号

ClassMethod getRegNoByInNo(InNo As %String) As %String
{
	//// w ##class(web.DHCEkgNo).getRegNoByInNo("500100")
	quit:InNo=""
    set papmiId=0,RegNo=""
    set papmiId=$O(^PAPERi("Medicare1",InNo,papmiId))
    quit:papmiId="" ""
    set itemStr=$g(^PAPER(papmiId,"PAT",1))
    quit:itemStr="" ""
    set RegNo=$p(itemStr,"^",1)
    if RegNo="" set RegNo=$p(itemStr,"^",2)
    quit RegNo
}

// ==================================================================

// w ##class(web.DHCEkgService).getRegNoByPatName("岑秀娣","93")

// 通过姓名找登记号

ClassMethod getRegNoByPatName(InName As %String, ExmLocID As %String) As %String
{
	s Isfirst=1
	s flag="N"
	s InName=$ZCONVERT(InName,"U")
	s GetName=InName 
	s RegNo=""
	s RegNoRtn=""
	;w !,"sss"
	do 
	{
		if InName="" s flag="Y" q
		if (GetName'[InName) s flag="Y" q
		s GetName=$ZCONVERT(GetName,"U")
	    
		s NoRowid=0 f  s NoRowid=$o(^PAPERi("PAPER_PatName",GetName,NoRowid))  q:NoRowid=""  d
		.s paadmtype="" f  s paadmtype=$o(^PAPERdr(NoRowid,"ADM",paadmtype)) q:paadmtype=""  d
		..s paadmrowid=0 f  s paadmrowid=$o(^PAPERdr(NoRowid,"ADM",paadmtype,paadmrowid)) q:paadmrowid=""  d
		...s OrderRowid=0 f  s OrderRowid=$o(^OEORD(0,"Adm",paadmrowid,OrderRowid)) q:OrderRowid=""  d
		....s itemsub=0  f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:itemsub=""  d
		.....s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)   ;
		.....s oeorditemdr=OrderRowid_"||"_itemsub 
		.....q:(reploc'=ExmLocID)&(ExmLocID'="")
		.....s bQLoc=..IsQueryLoc(ExmLocID,reploc)
		.....q:(bQLoc=0)
		.....;s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
		.....;q:(InIsFindDate="true")&(Date1<StdDate)!(Date1>EndDate)
		.....;s bOut="N"  ;是否已经输出
		.....;s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords=""
		.....s paadmdr=$p(^OEORD(OrderRowid),"^",1)
		.....;s NoticeSignInfo=..CheckNoticeSignInfo(paadmdr) 
		.....;s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr)
	    .....if (paadmdr'="") do
	    ......if $d(^PAADM(paadmdr)) do
	    .......s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	    .......s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
	    .......if RegNoRtn="" s RegNoRtn=RegNo
	    .......else  if RegNoRtn'[RegNo set RegNoRtn=RegNoRtn_"^"_RegNo
	    .....;s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	    .....;s GetRegNo=$p(PatInfo,"^",1)
	    
		s GetName=$o(^PAPERi("PAPER_PatName",GetName)) 
	}while ((GetName'="")&(flag'="Y"))
	
	quit RegNoRtn
}

ClassMethod IsQueryLoc(LogInLocId As %String, OrditemRecLocId As %String) As %Integer
{
	 s bFind=0
	 s LinkSub=0 f  s LinkSub=$o(^CTLOC(LogInLocId,"LINK",LinkSub)) q:LinkSub=""  d    
     .s LinkLocDr=$p(^CTLOC(LogInLocId,"LINK",LinkSub),"^",1)
     .i LinkLocDr=OrditemRecLocId  s bFind=1
  
     i bFind=0 d
     .i OrditemRecLocId=LogInLocId  s bFind=1 
    
     q bFind
}

// ==================================================================

// 获取登记号长度

ClassMethod getRegNoLength() As %String
{
    quit ..#RegNoLength
}

// 获取卡号长度

ClassMethod getCardNoLength() As %String
{
    quit ..#CardNoLength
}

// 获取住院号长度

ClassMethod getInNoLength() As %String
{
    quit ..#InNoLength
}

// w ##class(web.DHCEkgNo).getFullNo("127","10")

ClassMethod getFullNo(number As %String, len As %String) As %String
{
	if number="" quit number
	
	set rtnNo=number
    set numberLen=$length(number)
    if ((+numberLen)>=(+len)) do
    .set rtnNo = number
    else  do
    .set diffLen=(+len)-(+numberLen)
    .set o=""
    .for i=1:1:diffLen do
    ..set o=o_"0"
    .set rtnNo=o_number
    
    quit rtnNo
}

ClassMethod numberIsContainRegNo(number As %String) As %String
{
	if number["^RegNo" quit "1"
	quit "0"
}

ClassMethod numberIsContainCardNo(number As %String) As %String
{
	if number["^CardNo" quit "1"
	quit "0"
}

ClassMethod numberIsContainMedCareNo(number As %String) As %String
{
	if number["^MedCareNo" quit "1"
	quit "0"
}

}
