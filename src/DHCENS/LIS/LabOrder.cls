Class DHCENS.LIS.LabOrder Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "OrderList";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱Rowid
Property OrdID As %String(TRUNCATE = 1);

/// 检验号
Property LabNo As %String(TRUNCATE = 1);

/// 项目代码
Property TSCode As %String(TRUNCATE = 1);

/// 项目名称
Property TSName As %String(TRUNCATE = 1);

/// 价格
Property TSPrice As %String(TRUNCATE = 1);

/// 标本采集日期
Property CollectionDate As %String(TRUNCATE = 1);

/// 标本采集时间
Property CollectionTime As %String(TRUNCATE = 1);

/// 检验标本类型
Property SpecimenInfo As %String(TRUNCATE = 1);

/// 标本采集量
Property SpecimenVolume As %String(TRUNCATE = 1);

/// 检验申请医生
Property DoctorInfo As %String(TRUNCATE = 1);

/// 检验申请日期
Property RequestDate As %String(TRUNCATE = 1);

/// 检验申请时间
Property RequestTime As %String(TRUNCATE = 1);

/// 医嘱申请备注
Property Notes As %String(TRUNCATE = 1);

/// 收费状态
Property BillStatus As %String(TRUNCATE = 1);

ClassMethod GetOrderItem(rowid As %String) As DHCENS.LIS.LabOrder
{
	set objItem = ##class(DHCENS.LIS.LabOrder).%New()
	set oeid = $P(rowid,"||",1)
	set subid = $P(rowid,"||",2)
	
	set objItem.OrdID = oeid_"_"_subid
	set objItem.LabNo = $P($g(^OEORD(oeid,"I",subid,3)),"^",20)
	
	s ArcimID=$p($g(^OEORD(oeid,"I",subid,1)),"^",2)
	i (ArcimID'="")
	{
		s objItem.TSCode=..GetLabCode(ArcimID)
		s objItem.TSName=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)		
	}
	
	set dt = ..IfSpecColl(rowid)
	set objItem.CollectionDate = $P(dt,"^",2)
	set objItem.CollectionTime = $P(dt,"^",3)
	set objItem.SpecimenInfo=..GetSpecName(rowid)
	set DoctorDr=$p($g(^OEORD(oeid,"I",subid,1)),"^",11)
	i (DoctorDr'="")
	{
		set objItem.DoctorInfo=$p($g(^CTPCP(DoctorDr,1)),"^",1)_"@"_$p($g(^CTPCP(DoctorDr,1)),"^",2)
	}
    
	set objItem.RequestDate = $zd($p($g(^OEORD(oeid,"I",subid,1)),"^",9),3)
    set objItem.RequestTime = $zt($p($g(^OEORD(oeid,"I",subid,1)),"^",10))
    
    set prcstr=##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",ArcimID,$zdh(objItem.RequestDate,3),"","","","")
	set objItem.TSPrice=$p(prcstr,"^",1)
	
	set objItem.Notes = ""
	set objItem.BillStatus=##class(DHCENS.Method.BaseMethod).GetOrderBillStatus(rowid)

	Q objItem
}

/// 得到外部系统的检验项目代码
ClassMethod GetLabCode(ArcimID As %String) As %String
{
	q:ArcimID="" ""
	s temord=$o(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),"EXT",""),-1)
	s ExtCode="",RetCode=""
	i (temord'="")
	{
		s ExtCode=$p(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),"EXT",temord),"^",4)
	
		i (ExtCode'="")
		{
			s RetCode=$p($g(^TTAB("TS",ExtCode)),"\",3)
		}
	}
	q RetCode
}

ClassMethod IfSpecColl(oeoriId) As %String
{
	//w ##class(web.DHCLCNUREXCUTE).IfSpecColl("285073||29")
	s oeordId=$p(oeoriId,"||",1)
	s oeoriSub=$p(oeoriId,"||",2)
	q:(oeordId="")!(oeoriSub="") "N"
	
	s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	q:oeoreSub="" "N"		//OE_OrdExec无执行记录
	s oeoreId=oeoriId_"||"_oeoreSub
	s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,0))
	q:dhcoreId="" "N"		//DHC_OE_OrdExec无执行记录
	s specCollUser=$p($g(^DHCOrdExec(dhcoreId)),"^",12)		//采集人DHCORE_SpecCollUser
	s specCollDate=$p($g(^DHCOrdExec(dhcoreId)),"^",13)		//采集日期DHCORE_SpecCollDate
    s specCollTime=$p($g(^DHCOrdExec(dhcoreId)),"^",14)		//采集时间DHCORE_SpecCollTime
	q $g(specCollUser)_"^"_$zd($g(specCollDate),3)_"^"_$zt($g(specCollTime))
}

/// 通过医嘱号区的检验标本名称
ClassMethod GetSpecName(oerowid) As %String
{
	
    set OrdId=$P(oerowid,"||",1)
    set SubId=$P(oerowid,"||",2)
	s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
	s (SpecCode,SpecName)=""
	i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
	i $l(SpecCode),$d(^TTAB("SPEC",SpecCode)){
	s SpecName=$p(^TTAB("SPEC",SpecCode),"\",1)	
   }
   q SpecName
}

}
