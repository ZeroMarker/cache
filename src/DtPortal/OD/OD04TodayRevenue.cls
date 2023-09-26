Class DtPortal.OD.OD04TodayRevenue Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:胡发国
/// CreateDate:2015-08-15
/// Input:Date  (传入空时，取当天信息)
/// Output:已缴费病人数，未缴费病人数
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD04TodayRevenue","GetPatNum","")
Query GetPatNum(Date) As websys.Query(ROWSPEC = "FinishNum:%String,WaitingNum:%String")
{
}

ClassMethod GetPatNumExecute(ByRef qHandle As %Binary, Date) As %Status
{
    set repid=$I(^CacheTemp)
    set ind=1
	set qHandle=$lb(0,repid,0)
    set FinishNum=0,WaitingNum=0
    k ^TMP($j,"MZJF")
    k ^TEMP($j,"MZJF")
    
	i (Date="") s Date=+$h
	e  s Date=##class(websys.Conversions).DateHtmlToLogical(Date)
	
    ;统计已收费患者数量
    s PrtRowid=0  
    f  s PrtRowid=$o(^DHCINVPRT(0,"Date",Date,PrtRowid)) q:(PrtRowid="")  d
    .s PATID=$p(^DHCINVPRT(PrtRowid),"^",15)    
    .s PRTFairType=$p(^DHCINVPRT(PrtRowid),"^",34)
    .q:(PRTFairType'="F")                       //只统计门诊收费
    .s PRTFlag=$p(^DHCINVPRT(PrtRowid),"^",8)
    .q:(PRTFlag'="N")                          //正常收费
    .s ^TMP($j,"MZJF",PATID)=+$g(^TMP($j,"MZJF",PATID))+1    //查找患者是否存在过，存在过累加
	
	s patientid=""
    f  s patientid=$o(^TMP($j,"MZJF",patientid)) q:(patientid="")  d
    .s FinishNum=FinishNum+1
    
    ;统计未收费患者数量
    s PAADMRowid="0"
    f  s PAADMRowid=$o(^PAADMi("PAADM_AdmDate",Date,PAADMRowid)) q:(PAADMRowid="")  d
    .s PAADMType=$p(^PAADM(PAADMRowid),"^",2)
    .q:((PAADMType'="O")&&(PAADMType'="E"))  //增加显示急诊的，上面的已收费不能区分门诊急诊，这里也把急诊统计出来 20180224
    .s PAADMPAPMIDR=$p(^PAADM(PAADMRowid),"^",1)
    .s OEOREBilled=""   //没有初始化--bmz--portal
    .s OEORDRowId="0"
    .f  s OEORDRowId=$o(^OEORD(0,"Adm",PAADMRowid,OEORDRowId)) q:((OEORDRowId="")||(OEOREBilled="TB"))  d
    ..s OEORIChildsub="0"
    ..f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:(OEORIChildsub="")  d
    ...s OEOREBilled=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",5)
    ...i (OEOREBilled="TB")||(OEOREBilled="B") d
    ....s ^TEMP($j,"MZJF",PAADMPAPMIDR)=+$g(^TEMP($j,"MZJF",PAADMPAPMIDR))+1           //只统计未结算状态
    
    s Waitpatient=""
    f  s Waitpatient=$o(^TEMP($j,"MZJF",Waitpatient)) q:(Waitpatient="")  d
    .s WaitingNum=WaitingNum+1
	
	k ^TMP($j,"MZJF")
    k ^TEMP($j,"MZJF")

	d OutputRow
	quit $$$OK
 
OutputRow
    set Data=$lb(FinishNum,WaitingNum)
    set ^CacheTemp(repid,ind)=Data
    set ind=ind+1
	quit
}

}
