/// creater			lixiangzong
/// desc			插入DHCQueue子表DHCQueueStatus相关方法
/// date			2012.05.28
Class web.DHCQueueStatus Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// D ##CLASS(web.DHCQueueStatus).TestSQL(177)
ClassMethod TestSQL(parref As %String)
{
	kill PLIST
    &SQL(UPDATE SQLUser.DHCQueue SET QueStateDr=3 WHERE ID=177)

	Q
}

/// creater			guorongyong
/// desc			插入/更新DHCQueue表记录,队列状态改变调用的触发程序
/// date			2013.09.22
ClassMethod OnTrigger(parref As %String, type As %String) As %Status
{
	b ;type
	;s $zt="QueueStatusErr"
	s rtn=1
	s ParObj=##class(User.DHCQueue).%OpenId(parref)
	if $ISOBJECT(ParObj) {
		if type="TAfterIns" {
			s DocDr=ParObj.QueDocDrGetObjectId()
			s Status=ParObj.QueStateDrGetObjectId()
			s UpUserID=ParObj.OperuseridGetObjectId()
			s param=parref_"^"_DocDr_"^"_Status_"^"_UpUserID
			s rtn=..InsertDHCqueueStatus(param)
			i rtn=0 s rtn=1
			else  s rtn="ERROR"_rtn
		}
		if type="TAfterUpd" {
			B ;TAfterUpd 1
			s UpUserID=""
			s NewStatus=""
			i $g(%e(16)) {
				s OldStatus=$g(%e(16))
				s NewStatus=$g(%d(16))
				s UpUserID=$g(%d(2))
			}else{
				s OldStatus=-1
				s NewStatus=ParObj.QueStateDrGetObjectId()
				s UpUserID=ParObj.OperuseridGetObjectId()
			}
			i OldStatus-NewStatus { 
				s DocDr=ParObj.QueDocDrGetObjectId()
				s Status=NewStatus ;ParObj.QueStateDrGetObjectId()
				;s UpUserID=ParObj.OperuseridGetObjectId()
				if (UpUserID="")&&($d(%session)){
					s UpUserID=%session.Get("LOGON.USERID")	
				}
				s param=parref_"^"_DocDr_"^"_Status_"^"_UpUserID
				s rtn=..InsertDHCqueueStatus(param)
				B ;TAfterUpd 2
				i rtn=0 s rtn=1
				else  s rtn="ERROR"_rtn
				if rtn=1 d ..UpdateAdmTime(parref, NewStatus)
			}
		}
	}

	Q rtn
QueueStatusErr
	Q 0
}

/// creater			lixiangzong
/// desc			插入DHCQueue字表记录队列状态改变(复诊，续诊等病人数据的丢失)
/// date			2012.05.28
/// w ##class(web.DHCQueueStatus).InsertDHCqueueStatus("8^9^8^7")
ClassMethod InsertDHCqueueStatus(insertinfo)
{
 s QSParRef=$p(insertinfo,"^",1)
 i QSParRef="" Q -1
 s QSDocDr=$p(insertinfo,"^",2)
 s QSStatus=$p(insertinfo,"^",3)
 s QSUpUserID=$p(insertinfo,"^",4)
 ;当队列中还没有置医师则指定挂号所挂医生
 if ((QSDocDr="")||(QSDocDr="0")) s QSDocDr=$P($G(^DHCQueueStatus(QSParRef,1)),"^",3)
 s QSDate=..%SysDate()
 s QSTime=..%SysTime()
 TStart
   &sql(insert into sqluser.DHCQueueStatus(QS_ParRef,QS_Date,QS_Time,QS_DocDr,QS_Status,QS_UpUserID) 
   values(:QSParRef,:QSDate,:QSTime,:QSDocDr,:QSStatus,:QSUpUserID))
   b ;DHCQueueStatus
   i SQLCODE=0 D
	.TCommit  
   e  d
	.Trollback
   q SQLCODE
}

/// creater			lixiangzong
/// desc			补全没有就诊医生的数据
/// date			2012.05.28
/// w ##class(web.DHCQueueStatus).UpdateDHCqueue("8^9^8^7^6^5")
ClassMethod UpdateDHCqueue()
{
	s DHCQueueRowID=0 s Sub=1 s NO=1
	f  s DHCQueueRowID=$O(^User.DHCQueueD(DHCQueueRowID)) Q:(DHCQueueRowID="")  d
	.s QueStr=$G(^User.DHCQueueD(DHCQueueRowID))
	.s QueStateDr=$List(QueStr,14)
	.&sql(select PersName into :PersName from sqluser.dhcperstate where ID=:QueStateDr)
	.Q:PersName'="到达"
	.s QueDocDr=$List(QueStr,5)
	.Q:QueDocDr'=""
	.s QuePAadmDr=$List(QueStr,11)
	.s mrrowid=$p(^PAADM(QuePAadmDr),"^",61)
	.s DocDr="" 
	.s subrowid=0
	.i mrrowid'="" d
	..f  s subrowid=$o(^MR(mrrowid,"DIA",subrowid)) q:((subrowid="")||(DocDr'=""))  d 
	...s DocDr=$P(^MR(mrrowid,"DIA",subrowid),"^",4)
	.i DocDr=""  d
	..s OrderID=$O(^OEORD(0,"Adm",QuePAadmDr,0))
	..s OrderIDChild=0
	..i OrderID'=""  d
	...f  s OrderIDChild=$O(^OEORD(OrderID,"I",OrderIDChild)) Q:((OrderIDChild="")||(DocDr'=""))  d
	....s DocDr=$P(^OEORD(OrderID,"I",OrderIDChild,1),"^",11)
	.i DocDr'="" d
	..s $List(^User.DHCQueueD(DHCQueueRowID),5)=DocDr
	.e  d
	..S ^TempDHCQueueDoc("NULL",Sub)=DHCQueueRowID
	..s Sub=Sub+1
	.Q:DocDr=""
	.s ^TempDHCQueueDoc("OK",NO)=DHCQueueRowID
	.s NO=NO+1
	.s QueDate=$ZD($List(QueStr,3),4)
	.s QueDepDr=$List(QueStr,4)
	.s QueDocDr=$List(QueStr,5)
	.s QueName=$List(QueStr,9)
	Q "OK"
}

/// creater			lixiangzong
/// desc			查询因号别维护问题没有队列用户状态
/// input			PAADMID
/// date			2012.06.08
/// w ##class(web.DHCQueueStatus).GetOutQueStatus("211468")
ClassMethod GetOutQueStatus(PAADMID)
{
	
	Q:PAADMID="" ""
	s DocDr="" 
	s (Statu,Username,DocName)=""
	;查询最后一条医嘱医生
	s OrderID=$O(^OEORD(0,"Adm",PAADMID,0))
	s OrderIDChild=0
	i OrderID'=""  d
    .f  s OrderIDChild=$O(^OEORD(OrderID,"I",OrderIDChild)) Q:(OrderIDChild="")  d
	..s DocDr=$P(^OEORD(OrderID,"I",OrderIDChild,1),"^",11)
	
	;如果没有医嘱医生查询最后一条诊断 医生
	i DocDr=""  d
	.s mrrowid=$p($G(^PAADM(PAADMID)),"^",61)
	.s subrowid=0
	.i mrrowid'=""  d
	..f  s subrowid=$o(^MR(mrrowid,"DIA",subrowid)) q:((subrowid=""))  d 
	...s DocDr=$P(^MR(mrrowid,"DIA",subrowid),"^",4)
	
	i DocDr'=""  d
	.s DocName=$P($G(^CTPCP(DocDr,1)),"^",2)
	.s Statu="到达"
	.s Username=DocName
	
	i DocDr=""  d
	.s refuser=$p($g(^PAADM(PAADMID,2)),"^",69)
	.i refuser'="" d
	..s Statu="退号"
	..s Username=$p($g(^SSU("SSUSR",refuser)),"^",1)
	..s DocNameID=$p($g(^PAADM(PAADMID)),"^",9)
	..if DocNameID'="" s DocName=$P($G(^CTPCP(DocNameID,1)),"^",2)
	.e  d
	..s createuser=$p($g(^PAADM(PaadmRowid)),"^",43)
	..i createuser="" d
	...s createuser=$G(^CreaterUserBF(PaadmRowid)) 
    ...s $p(^PAADM(PaadmRowid),"^",43)=createuser
    ..s Statu="等候"
    ..i createuser'="" s Username=$p($g(^SSU("SSUSR",createuser)),"^",1)
    ..s DocNameID=$p($g(^PAADM(PAADMID)),"^",9)
	..if DocNameID'="" s DocName=$P($G(^CTPCP(DocNameID,1)),"^",2)
    Q Statu_"^"_Username_"^"_DocName
}

/// create 20200120 by yl
/// input: QueID(对列表id), ChangeStatus(修改后的状态)
/// 首次报到(置等候状态)/到达 修改就诊时间
/// debug:w ##class(web.DHCQueueStatus).UpdateAdmTime("272","4")
/// config:^DHCDocConfig("AllocAndArriveUpdateAdmTime")  医生站设置->首次报到/到达重置就诊时间
ClassMethod UpdateAdmTime(QueID As %String, NewStatus As %String, CurLogonHosp As %String = "") As %String
{
	s ^tempqujian("UpdateAdmTime")=QueID_","_NewStatus_","_CurLogonHosp
	s AllocAndArriveUpdateAdmTime=..%GetConfig("AllocAndArriveUpdateAdmTime",CurLogonHosp)
	if AllocAndArriveUpdateAdmTime'=1 {
		q 0
	}
	&sql(select PersName into :PersName from sqluser.dhcperstate where ID=:NewStatus)
	s ret="-100"
	b ;yl-01
	if (($g(PersName)="等候")!($g(PersName)="到达")) {
		;修改后状态为"等候"或"到达"
		&sql(select count(*) into :Sum from sqluser.DHCQueueStatus where QS_ParRef=:QueID and QS_Status=:NewStatus)
		&sql(select count(*) into :AllSum from sqluser.DHCQueueStatus where QS_ParRef=:QueID)
		if $g(Sum)=1,$g(AllSum)>1 {	
			;Sum=1 则为首次,AllSum>1 挂号直接置等候不处理
			s AdmId=$lg(^User.DHCQueueD(QueID),11)
			s AdmDate=..%SysDate()
			s AdmTime=..%SysTime()
			Set OrderId=$o(^OEORD(0,"Adm",AdmId,0))
			if (OrderId'=""){
				s sub="0"
				for  {
					Set sub=$o(^OEORD(OrderId,"I",sub)) Quit:sub=""  
					s ItmMastrowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
	 				s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ItmMastrowid,CurLogonHosp)
	 				continue:(checkrtn'="NotRegFee")
	 				s ItemStat=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
					continue:ItemStat=""
	 				s ItemStatCode=$p(^OEC("OSTAT",ItemStat),"^",1)
	 				continue:((ItemStatCode'="V")&&(ItemStatCode'="E"))
	 				s StartDate=$p(^OEORD(OrderId,"I",sub,1),"^",9)
					s StartTime=$p(^OEORD(OrderId,"I",sub,1),"^",10)
					b ;09334dd
					if (StartDate<AdmDate){
						s AdmDate=StartDate
						s AdmTime=StartTime
						}
					if ((StartDate=AdmDate)&&(StartTime<AdmTime)){
						s AdmTime=StartTime
						}
				}
				
				}
				b ;09334
			s AdmObj=##class(User.PAAdm).%OpenId(AdmId)
			if $IsObject(AdmObj)&&(AdmDate=AdmObj.PAADMAdmDate) {
				s AdmObj.PAADMAdmDate=AdmDate
				s AdmObj.PAADMAdmTime=AdmTime
				s sc=AdmObj.%Save()
				i $$$ISERR(sc) {
					s ret="-101^更新失败"
				}else {
					s ret="0^更新失败"
				}
			}
			d AdmObj.%Close()
		}
	}
	q ret
}

}
