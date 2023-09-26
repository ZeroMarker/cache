Import sqluser

Class web.DHCSTMHUI.HVMatOrdItmRet Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "HVMatOrdItm";

/// 保存
/// w ##class(web.DHCSTMHUI.HVMatOrdItmRet).Save("42||272^8a819ec16c279bde016c27dc4b480016")
ClassMethod Save(DataStr) As %String
{
	n (DataStr)
	s Oeori=$p(DataStr,"^",1)
	s BarCode=$p(DataStr,"^",2)
	
	s HVMId="",Qty=1,Rp=0,Sp=0
	&sql(SELECT %ID,ORI_Qty,ORI_Rp,ORI_Sp
		INTO :HVMId,:Qty,:Rp,:Sp
		FROM DHC_HVMat_OrdItm
		WHERE ORI_OEORI_DR=:Oeori AND ORI_BarCode=:BarCode)
	i SQLCODE=100 s HVMId=""
	i HVMId="" q 0			;没有发放记录的,直接退出
	
	s RpAmt=Rp*Qty,SpAmt=Sp*Qty
	
	s VendorId=$p(^DHCHVMORI(HVMId,1),"^",17)
	s InciId=$p(^DHCHVMORI(HVMId,1),"^",34)
	s Oeord=$p(Oeori,"||",1),OeoriCh=$p(Oeori,"||",2)
	s OeoriXDate=$p(^OEORD(Oeord,"I",OeoriCh,3),"^",34)
	s OeoriXTime=$p(^OEORD(Oeord,"I",OeoriCh,2),"^",15)
	s Date=+$h,Time=$p($h,",",2)
	
	s obj=##class(User.DHCHVMatOrdItmRet).%New()
	d obj.ORIRORIDRSetObjectId(HVMId)
	d obj.ORIRAPCVMDRSetObjectId(VendorId)
	s obj.ORIRBarCode=BarCode
	d obj.ORIRINCIDRSetObjectId(InciId)
	d obj.ORIROEORIDRSetObjectId(Oeori)
	s obj.ORIROEORIDate=OeoriXDate
	s obj.ORIROEORITime=OeoriXTime
	s obj.ORIRQty=Qty
	s obj.ORIRRp=Rp
	s obj.ORIRRpAmt=RpAmt
	s obj.ORIRSp=Sp
	s obj.ORIRSpAmt=SpAmt
	s obj.ORIRDate=Date
	s obj.ORIRTime=Time
	s Sc=obj.%Save()
	i $$$ISERR(Sc) s Ret=-1 q Ret
	s RowId=obj.%Id()
	
	q RowId
}

}
