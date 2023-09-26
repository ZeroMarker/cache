Import sqluser

Class web.DHCSTMVBSTTR Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod INSERT()
{
       ;insert table
  ;q PLIST(1)_"^"_PLIST(2)_"^"_PLIST(3)_"^"_PLIST(4)_"^"_PLIST(5)_"^"_PLIST(6)_"^"_PLIST(7)_"^"_PLIST(8)_"^"_PLIST(9)_"^"_PLIST(10)_"^"_PLIST(11)
  &sql(Insert Into DHC_InIsTrf
  (INIT_Date,INIT_Time,INIT_FrLoc_DR,INIT_ToLoc_DR,INIT_SSUSR_DR,
  INIT_Type,INIT_UserCompleted,INIT_Remarks,INIT_INRQ_DR,INIT_State,INIT_NO
  )
  Values(:PLIST(1),:PLIST(2),:PLIST(3),:PLIST(4),:PLIST(5),
  :PLIST(6),:PLIST(7),:PLIST(8),:PLIST(9),:PLIST(10),
  :PLIST(11)))
 Q SQLCODE
 
 /*
 INIT_OperationRemark,INIT_OperateType
 :PLIST(12),,:PLIST(13)
 */
}

ClassMethod DELETE(ID)
{
 q:$g(ID)="" 0
 &sql(Delete from DHC_INIsTrf where INIT_RowId=:ID)
 q SQLCODE
}

ClassMethod UpdateCpByNo(fed, TransNo, Remark)
{
 q:$g(TransNo)="" 0
 &sql(Update DHC_INIsTrf set INIT_UserCompleted=:fed,INIT_State=11  where INIT_NO=:TransNo)
 ;zdm,2009-04-09,增加错误记录
 i SQLCODE'=0  d
 .//s ret=$$SqlErrorRecord^DHCSTERROR("UpdateCpByNo^DHCSTMVBSTTR","no:"_TransNo,SQLCODE)
 q SQLCODE
 /*
 ,INIT_OperationRemark=:Remark
 
 /*/
}

ClassMethod UpdateChkByNo(TraNo, cuser, state)
{
 ;s TraNo="XYC20040623_01"
 ;s cuser="1706"
 ;s state="20"
 q:$g(TraNo)="" 0
 s cDate=$P($h,",",1)
 s cTime=$p($h,",",2)
 i state=21 d    ;check Ok , Check State and Complete State change to YES
         .s ActC="Y"
 e  d                             ;check No , Check State and Complete State change to NO
         .s ActC="N"

 &sql(Update DHC_INIsTrf set INIT_AckDate=:cDate,INIT_AckTime=:cTime,
                         INIT_AckUser_DR=:cuser,INIT_State=:state,
                         INIT_AcknowCompleted=:ActC,INIT_UserCompleted=:ActC
                          where INIT_NO=:TraNo)
 ;zdm,2009-04-08,增加错误记录
 i SQLCODE'=0  d
 .//s ret=$$SqlErrorRecord^DHCSTERROR("UpdateChkByNo^DHCSTMVBSTTR","no:"_TraNo,SQLCODE)
 q SQLCODE
}

/// Update DHC_INIsTrf?trans State change to Inchecking
ClassMethod UpdateInChkByNo(inTraNo, incuser, instate, inIsTrfDr)
{
 q:$g(inTraNo)="" 0
 s cDate=$P($h,",",1)
 s cTime=$p($h,",",2)
 &sql(Update DHC_INIsTrf set INIT_InAckDate=:cDate,INIT_InAckTime=:cTime,
                         INIT_InAckUser_DR=:incuser,INIT_State=:instate,INIT_IsTrf_DR=:inIsTrfDr
                          where INIT_NO=:inTraNo)
 ;zdm,2009-04-09,增加错误记录
 i SQLCODE'=0  d
 .//s ret=$$SqlErrorRecord^DHCSTERROR("UpdateInChkByNo","trno:"_inTraNo,SQLCODE)
 q SQLCODE
}

ClassMethod SelctByNo(TransNo)
{
 &sql(Select INIT_Date,INIT_Time,INIT_FrLoc_DR,INIT_ToLoc_DR,INIT_SSUSR_DR,INIT_INRQ_DR,INIT_No,INIT_UserCompleted
                  INTO :iDate,:iTime,:iFrLoc,:iToLoc,:iSSUSR,:iINRQ,:iNo,:iUserCompleted
          from DHC_InIsTrf where INIT_No=:TransNo)
 ;s iDate=$ZDH(iDate,3),iTime=$ZDT(ITime,)
 ;s iUserCompleted=$p(iUserCompleted,$c(1))
 s datas=iDate_"^"_iTime_"^"_iFrLoc_"^"_iToLoc_"^"_iSSUSR_"^"_iINRQ_"^"_iNo_"^"_iUserCompleted
 q:'SQLCODE datas
 q 0
}

ClassMethod Update(initno, data)
{
  ; update DHC_InIstrf
  ;
  n (initno,data)
  ;s data="XYK-西药库^YWB-医务部^^1^34"
  ;s initno="XYC20060516_014"
  s initno=$$ALPHAUP^SSUTIL4(initno) q:initno="" -1
  s rowid=$o(^DHCINIT(0,"No",initno,""))  q:rowid="" -1
  ;
  s dd=+$h  ; date
  s tt=$p($h,",",2)
  s frloc=$p(data,"^",1)  ; from loc
  s toloc=$p(data,"^",2)    ;to loc
  s reqno=$p(data,"^",3)   ; reqno
  s user=$p(data,"^",4)   ;user
  s Remarks=$p(data,"^",5)
  ;s typedr=$p(data,"^",6)   ;typedr
  s frlocdr=##class(web.DHCSTCOMMONSRV).LocToRowID(frloc) q:frlocdr="" -1
  s tolocdr=##class(web.DHCSTCOMMONSRV).LocToRowID(toloc) q:tolocdr="" -2
  s req=""
  i reqno'="" d
  . s reqno=$$ALPHAUP^SSUTIL4(reqno)
  . s req=$o(^INRQ(0,"No",reqno,""))
  //&sql(update dhc_inistrf set init_date=:dd,init_time=:tt,init_frloc_dr=:frlocdr,init_toloc_dr=:tolocdr,
  //     init_inrq_dr=:req,init_operationremark=:Remarks where init_rowid=:rowid)

  &sql(update dhc_inistrf set init_date=:dd,init_time=:tt,init_frloc_dr=:frlocdr,init_toloc_dr=:tolocdr,
        init_inrq_dr=:req where init_rowid=:rowid)


  q SQLCODE
}

ClassMethod IfLink(trno)
{
  ;2007-07-24 added
  n (trno)
  q:trno="" 0
  s trno=$$ALPHAUP^SSUTIL4(trno)
  s init=$o(^DHCINIT(0,"No",trno,""))
  q:init="" 0
  s frloc=$p(^DHCINIT(init),"^", 5)
  s toloc=$p(^DHCINIT(init),"^", 6)
   &sql(select * from CT_LocLinkLocation where link_parref=:frloc and link_ctloc_dr=:toloc)
  q:'SQLCODE 1
  q 0
}

ClassMethod UpdTrReqLoc(trno, reqloc)
{
 ///更新库存转移单请求科室
 ///trno ：转移单号,
 ///reqloc:请求科室
 ///zhwh,2008-08-31
 n (trno,reqloc)
 s trno=$$ALPHAUP^SSUTIL4(trno)
 s init=$o(^DHCINIT(0,"No",trno,""))
 q:init="" 0
 s locdr=##class(web.DHCSTCOMMONSRV).LocToRowID(reqloc)
 q:locdr="" 0
 &sql(update dhc_inistrf set init_toloc_dr=:locdr where init_rowid=:init)
 q:SQLCODE'=0 -1
 q 1
}

}
