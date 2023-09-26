Import sqluser

Class web.DHCSTMHUI.DHCRetAspAmount Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 插入一条数据到DHC_RetAspAmount
/// Author:zhwh
/// Date:2013-08-01
/// Arguments:
///  sdata - 数据串:批次rowid^数量^售价差异^售价差额^进价差^进价差额^用户rowid^业务RowId^业务代码
/// Return:
///  0 -成功
///  <0 - 失败
ClassMethod Insert(sdata As %String) As RtnObj
{
	 N (sdata)
	 s RtnObj=##class(RtnObj).%New()
	 K PLIST
	 s inclb=$p(sdata,"^",1)
	 s inci=+inclb
	 s locdr=$p(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	 s qty=$p(sdata,"^",2)
	 s spdiff=$p(sdata,"^",3)
	 s spamtdiff=$p(sdata,"^",4)
	 s rpdiff=$p(sdata,"^",5)
	 s rpamtdiff=$p(sdata,"^",6)
	 s usr=$p(sdata,"^",7)
	 s pointer=$p(sdata,"^",8)
	 s type=$p(sdata,"^",9) 
	 s uom=$p(sdata,"^",10) 
	 
	 S PLIST(2)=inci	//RETA_INCI_DR
	 S PLIST(3)=locdr	//RETA_CTLOC_DR
	 S PLIST(4)=+spdiff	//RETA_AdjPrice
	 S PLIST(5)=+qty	//RETA_Qty
	 S PLIST(6)=+spamtdiff	//RETA_Amount
	 S PLIST(7)=usr	//RETA_SSUSR_DR
	 S PLIST(8)=+$h				//RETA_Date
	 S PLIST(9)=$p($h,",",2) 	//RETA_Time
	 S PLIST(10)=pointer	//RETA_Pointer
	 S PLIST(11)=type	//RETA_Type
	 S PLIST(12)=+rpdiff	//RETA_RpDiff
	 S PLIST(13)=+rpamtdiff	//RETA_RpAmt
	 S PLIST(14)=uom	//RETA_Uom_DR
	 s PLIST(15)=inclb  //RETA_INCLB_DR
	 
	 &SQL(Insert Into DHC_RetAspAmount Values :PLIST())
	 i SQLCODE='0 d RtnObj.Err(-11,"","记录损益失败!")
	 q RtnObj
}

/// description:删除退货损益数据
/// input:明细id,业务类型
/// W ##class(web.DHCSTMHUI.DHCRetAspAmount).delete("R","7||1")
ClassMethod Delete(type, pointer)
{
	n (pointer,type)
	q:type="" "-1^业务类型为空!"
	q:pointer="" "-2^业务类型指针为空!"
	q:'$d(^DHCRETA(0,"TypePointer",type,pointer)) 0
	s retasprowid=$o(^DHCRETA(0,"TypePointer",type,pointer,""),-1)  //业务+指针确定唯一记录
	&SQL(DELETE FROM DHC_RetAspAmount WHERE RETA_RowId=:retasprowid)
	q:SQLCODE "-3^删除损益数据失败!"
	q SQLCODE
}

}
