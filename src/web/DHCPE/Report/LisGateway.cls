Class web.DHCPE.Report.LisGateway Extends %Persistent [ Not ProcedureBlock ]
{

ClassMethod GetLisDate(OrderDetailID, OEORIRowId)
{
   
    n (OrderDetailID,OEORIRowId)
    s NormalStr="",ResFlag="1",Unit="",RefRanges=""
    Set CTTCCode=$p($G(^DHCPEST(+OrderDetailID,"OD",$p(OrderDetailID,"||",2))),"^",10)
	q:CTTCCode=""
    Set TestSetRow=$p(^OEORD($P(OEORIRowId,"||",1),"I",$P(OEORIRowId,"||",2),3),"^",35)
 	Set labno=$Piece(TestSetRow,"||",1)
 	Set ts=$Piece(TestSetRow,"||",2)
 	Set tscnt=$Piece(TestSetRow,"||",3)
 	i TestSetRow'=""  Set RecDate=$P(^TEPI(labno,1,ts,tscnt),"\",21)
 	i ts'=""  d
    .If $Data(^TEPI(labno,1,ts,1,"DATA",CTTCCode,"Ranges")) Set NormalStr=$Get(^TEPI(labno,1,ts,1,"DATA",CTTCCode,"Ranges"))
    .If $Data(^TEPI(labno,1,ts,1,"DATA",CTTCCode)) Set ResFlag=$Piece(^TEPI(labno,1,ts,1,"DATA",CTTCCode),"\",2)
	.If ResFlag'=""  s ResFlag=0   //异常
 	.else  s ResFlag=1             //正常 
 	.If $Data(^TEPI(labno,1,ts,1,"DATA",CTTCCode,"Unit")) Set Unit=$Get(^TEPI(labno,1,ts,1,"DATA",CTTCCode,"Unit"))    
	q NormalStr_"^"_Unit_"^"_ResFlag
}

ClassMethod GetLisDate1(OrderDetailID, OEORIRowId)
{
   
    n (OrderDetailID,OEORIRowId)
    s NormalStr="",NormalFlag="1",Unit="",RefRanges="",labItemCode="",RecDate="",ResFlag=""
    s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
    s episodeNo=$p(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),3),"^",20)
	q:($g(episodeNo)="") "Error: EpisodeNo is Null!"
	s arcItemId=$p(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1),"^",2)
    i "MedTrak"=TrakVerison d
	.s arcos=$p(^OEORD(+ordItmId,"I",$p(OEORIRowId,"||",2),3),"^",10)
	.Quit:$g(arcos)="" 
	.s labItemCode=$P($G(^ARCOS(arcos)), "^", 11)
	
    i ((TrakVerison="TrakCare")&&($g(arcItemId)'="")) Set labItemCode=##Class(web.DHCPE.TransResult).GetLabExtCode("TrakCare",arcItemId)
    Set CTTCCode=$p($G(^DHCPEST(+OrderDetailID,"OD",$p(OrderDetailID,"||",2))),"^",10)
    q:labItemCode="" ""
	q:CTTCCode="" ""
 	i labItemCode'=""  d
    .If $Data(^TEPI(episodeNo,1,labItemCode,1,"DATA",CTTCCode,"Ranges")) Set RefRanges=$Get(^TEPI(episodeNo,1,labItemCode,1,"DATA",CTTCCode,"Ranges"))
 	.//Set LRang=$p(RefRanges,$c(1),1)
	.//Set HRang=$p(RefRanges,$c(1),2)
	.//If $l(LRang),$l(HRang) Set NormalStr=LRang_"-"_HRang
	.//Else  Set NormalStr=LRang
	.//If '$l(NormalStr)  Set NormalStr=##class(web.DHCLabTestCode).GetMultiScope(episodeNo,CTTCCode,RecDate)
    .If $Data(^TEPI(episodeNo,1,labItemCode,1,"DATA",CTTCCode)) Set ResFlag=$Piece(^TEPI(episodeNo,1,labItemCode,1,"DATA",CTTCCode),"\",2)
	.If ResFlag'=""  s NormalFlag=0   //异常
 	.else  s NormalFlag=1      //正常 
 	.If $Data(^TEPI(episodeNo,1,labItemCode,1,"DATA",CTTCCode,"Unit")) Set Unit=$Get(^TEPI(episodeNo,1,labItemCode,1,"DATA",CTTCCode,"Unit"))    
	q NormalStr_"^"_Unit_"^"_NormalFlag
}

Storage Default
{
<Data name="LisGatewayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.Report.LisGatewayD</DataLocation>
<DefaultData>LisGatewayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.Report.LisGatewayD</IdLocation>
<IndexLocation>^web.DHCPE.Report.LisGatewayI</IndexLocation>
<StreamLocation>^web.DHCPE.Report.LisGatewayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
