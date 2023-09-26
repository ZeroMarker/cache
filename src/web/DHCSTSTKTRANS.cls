Import SQLUser

Class web.DHCSTSTKTRANS Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod HandleStk(inclb, qty, uom, locdr, sprice, pointer, intrno, user) As %String
{
 ;inclb - 批次rowid
 ;qty - 数量(和uom 相应的数量) - 数量应根据业务类型区分正还是负
 ;uom - 单位rowid
 ;locdr - 科室rowid
 ;sprice - 售价(和uom 相应的售价)
 ;pointer - 业务记录的rowid
 ;intrno - 业务记录的业务号，如发药单号
 ;user - 用户rowid
 ;
 tstart
 s ret=0
 s ret=..InsTrans(inclb,qty,uom,locdr,sprice,pointer,intrno,user)
 i ret<0 trollback
 q:ret<0 -1
 tcommit
 q 0
}

ClassMethod InsTrans(inclb, qty, uom, locdr, sprice, pointer, intrno, user) As %String
{
 ; This routine is used to handle the stock qty of Table Dhc_LocDailytotal and Dhc_LocBtDailytotal when dispensing .
 ;
 n (inclb,qty,uom,locdr,sprice,pointer,intrno,user)
 q:inclb="" -1
 q:locdr="" -2
 s inci=+inclb,locdr=+locdr
 q:inci<0 -11
 s qty=+qty
 s buom=$p(^INCI(inci,1),"^",10)  q:buom="" -3
 s fac=+$$CONVFAC^ST01(uom,buom)
 s bqty=qty*fac
 s mrowid=##class(web.DHCSTLOCDTOTAL).UpdateMainByID(inci,bqty,locdr)
 q:mrowid="" -4
 s detrowid=##class(web.DHCSTLOCBTDTOTAL).UpdateDayBT(inclb,bqty,mrowid)
 q:detrowid="" -5
 ; Insert transaction data 
 k PLIST
 f i=1:1:16 s PLIST(i)=""
 s PLIST(2)=+qty*sprice                                                  ;INTR_Amount
 s PLIST(3)=+sprice                                                       ;INTR_AveragePrice
 s PLIST(4)=uom ;                           ;INTR_CTUOM_DR
 s PLIST(5)=$p($h,",",1)                                                  ;INTR_Date
 s PLIST(6)=""                                                            ;INTR_GLBatch_DR
 s PLIST(7)=inci ;                            ;INTR_INCI_DR
 s PLIST(8)=inclb                                                                                                              ;INTR_INCLB_DR
 s PLIST(9)=intrno                                                         ;INTR_No
 s PLIST(10)=pointer                                                     ;INTR_Pointer
 s PLIST(11)=+qty                                                        ;INTR_Qty
 s PLIST(12)=+user                                                       ;INTR_SSUSR_DR
 s PLIST(13)=$p($h,",",2)                                                 ;INTR_Time
 s PLIST(14)="P"                                                        ;INTR_Type
 s PLIST(15)="N"                                                          ;INTR_UpdBalFlag       
 s PLIST(16)="N"                                                          ;INTR_UpdFlag
 &sql(insert into DHC_Intrans values PLIST() )
 q:SQLCODE'=0 -6
 q +%ROWID
}

}
