Import sqluser

Class web.DHCSTCNTSADDREASON Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 增加点评原因
ClassMethod AddCommontReason(reacode, readesc, realevel, reawaycode) As %String
{
	
	s chkexist=0
	s rea=""
	f  s rea=$o(^DHCPCREASON(0,"Level",reawaycode,realevel,rea)) q:rea=""  d
	.s code=$p(^DHCPCREASON(rea),"^",1)
	.s desc=$p(^DHCPCREASON(rea),"^",2)
	.i code=reacode d
	..s chkexist=1
	.i desc=readesc s chkexist=2
	q:chkexist=1 -99
	q:chkexist=2 -98
	k PLIST
	s PLIST(2)=reacode
	s PLIST(3)=readesc
	s PLIST(4)=realevel
	s PLIST(5)=reawaycode
	
	&sql(INSERT INTO DHC_PHCNTSREASON VALUES :PLIST())
 	i SQLCODE'=0 q -1
 	q 0
}

/// 修改点评原因
ClassMethod UpdCommontReason(reacode, readesc, reasonID) As %String
{
	q:'$d(^DHCPCREASON(reasonID)) -1
	s realevel=$p(^DHCPCREASON(reasonID),"^",3)
	s reawaycode=$p(^DHCPCREASON(reasonID),"^",4)
	s chkexist=0
	s rea=""
	f  s rea=$o(^DHCPCREASON(0,"Level",reawaycode,realevel,rea)) q:rea=""  d
	.q:rea=reasonID
	.s code=$p(^DHCPCREASON(rea),"^",1)
	.s desc=$p(^DHCPCREASON(rea),"^",2)
	.i code=reacode d
	..s chkexist=1
	.i desc=readesc s chkexist=2
	q:chkexist=1 -99
	q:chkexist=2 -98
	&sql(update  DHC_PHCNTSREASON set PCR_Desc=:readesc,PCR_Code=:reacode where PCR_RowID=:reasonID )
 	i SQLCODE'=0 q -1
 	q 0
}

/// 删除点评原因
/// Modified by myq 20160819 仅删除原因关联关系，不删除原因数据
ClassMethod DelCommontReason(reasonID, realevel, reawaycode) As %String
{
	
	q:((reawaycode="")||(realevel="")||(reasonID="")) -1
    k ^DHCPCREASON(0,"Level",reawaycode,realevel,reasonID)
    q 0
}

ClassMethod QueryReasonByLevel(realevel, reawaycode) As %String
{
	s h=0
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s reasondr=""
	f  s reasondr=$o(^DHCPCREASON(0,"Level",reawaycode,realevel,reasondr)) q:reasondr=""  d
	.s reasoncode=$p(^DHCPCREASON(reasondr),"^",1)
	.s reasondesc=$p(^DHCPCREASON(reasondr),"^",2)
	.s h=h+1
    .s data=reasondesc_"^"_reasondr_"^"_reasoncode
    .s ^TMP("dhcpha","DHCSTCNTSADDREASON","QueryReasonByLevel",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSADDREASON","QueryReasonByLevel",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSADDREASON","QueryReasonByLevel",pid,h)
    .s reasondesc=$p(data,"^",1)
    .s reasondr=$p(data,"^",2)
    .s reasoncode=$p(data,"^",3)
    .
    .s reasoncode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reasoncode",reasoncode)
    .s reasondesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reasondesc",reasondesc)
	.s reasondr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("reasondrowid",reasondr)
	.
	.s tmpstr=reasoncode_reasondesc_reasondr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSADDREASON","QueryReasonByLevel",pid)
	
	q ""
}

/// Description:构造树形结构
/// Creator:LiangQiang
/// w ##class(web.DHCSTCNTSADDREASON).GetReaTreeData(0,0,6)
ClassMethod GetReaTreeData(level, id, waycode) As %String
{
	s currlevel=level+1
	w "["
	s reasondr=""
	f  s reasondr=$o(^DHCPCREASON(0,"Level",waycode,id,reasondr)) q:reasondr=""  d
	.q:'$d(^DHCPCREASON(reasondr))
	.s catdesc=$p(^DHCPCREASON(reasondr),"^",2)
	.s leafflag="false"
	.i '$D(^DHCPCREASON(0,"Level",waycode,reasondr))  s leafflag="true"
	.w "{"_"id:'"_reasondr_"',text:'"_catdesc_"',leaf:"_leafflag_",level:'"_currlevel_"'}"
	.s next=$o(^DHCPCREASON(0,"Level",waycode,id,reasondr))
	.i (+next'=0) w ","

	q "]"
}

}
