Class web.DHCFOrdChange Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod OrdConfirm(Str As %String = "") As %String
{
	q:Str="" "参数为空"
 s del="^",RetStr=""
	s changetype=$p(Str,del,1),recloc=$p(Str,del,2),oeordid=$p(Str,del,3),userdr=$p(Str,del,4)
	k PLIST
	s changedate=+$h,changetime=$p($h,",",2)
	s:changetype="I" OrdStatus=6
	s:changetype="U" OrdStatus=1
	if changetype="I"  D
 .&sql(UPDATE SQLUSER.OE_ORDITEM SET OEORI_ItemStat_DR=:OrdStatus,OEORI_UserUpdate=:userdr,OEORI_UpdateDate=:changedate,OEORI_UpdateTime=:changetime WHERE oeori_rowid=:oeordid)
 .if $G(SQLCODE) S RetStr="更新记录失败,oeorditem"_" "_$g(%msg)
 .q:RetStr'=""
 .s PLIST(0)=oeordid,PLIST(3)=changedate,PLIST(4)=changetime,PLIST(5)=OrdStatus,PLIST(6)=userdr,PLIST(7)=""
 .&sql(INSERT INTO SQLUSER.OE_OrdStatus VALUES :PLIST())
 .if $G(SQLCODE) S RetStr="更新记录失败,OE_OrdStatus"_" "_$g(%msg)
 .q:RetStr'=""
	if changetype="U"  D
 .&sql(UPDATE SQLUSER.OE_ORDITEM SET OEORI_ItemStat_DR='1',OEORI_UserUpdate=:userdr,OEORI_UpdateDate=:changedate,OEORI_UpdateTime=:changetime WHERE oeori_rowid=:oeordid)
 .if $G(SQLCODE) S RetStr="更新记录失败,oeorditem"_" "_$g(%msg)
 .q:RetStr'="" 
 .s PLIST(0)=oeordid,PLIST(3)=changedate,PLIST(4)=changetime,PLIST(5)=OrdStatus,PLIST(6)=userdr,PLIST(7)=""
 .&sql(INSERT INTO SQLUSER.OE_OrdStatus VALUES :PLIST())
 .if $G(SQLCODE) S RetStr="更新记录失败,OE_OrdStatus"_" "_$g(%msg)
 .q:RetStr'=""
	q RetStr
}

}
