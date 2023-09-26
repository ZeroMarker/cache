Class DHCDoc.Interface.Inside.IOT.InOrderInfo Extends %RegisteredObject
{

/// date:2019-09-09
/// desc:互联互通共享文档【2.52.1住院医嘱表（DHCENSCDA.User.CDA.C0052Info）】
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.IOT.InOrderInfo","GetC0052Info","2019-09-10","2019-09-10","")
ClassMethod GetC0052InfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Hospital As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	set qHandle = $lb(0,repid,0)
	s StartDate=$ZDH(StartDate,3)
	s EndDate=$ZDH(EndDate,3)
	s (AdmID,DocumentID,HDSD0014117,HDSD00141171,OrderSn)=""
	for Date=StartDate:1:EndDate {
		s orderParref=""
		for {
			s orderParref=$O(^OEORDi(0,"StDt",Date,orderParref))
			q:orderParref=""
			s AdmID=$P(^OEORD(orderParref),"^",1)
			s PAADMType=$p($g(^PAADM(AdmID)),"^",2)
			continue:(PAADMType'="I")
			s orderId = 0 
			for{
				s orderId = $O(^OEORDi(0,"StDt",Date,orderParref,orderId))
				q:orderId=""
				s AdmID=$P(^OEORD(orderParref),"^",1) ///就诊ID号	AdmID
				s DocumentID=orderParref_"||"_orderId  ///文档唯一编号	DocumentID
				Set Doctor=$P($g(^PAADM(AdmID)),"^",9)
				If Doctor'="" {
					Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
					s HDSD0014117=$P($g(^CTPCP(Doctor,1)),"^",1 ) ///就诊医生签名代码	HDSD0014117
					s HDSD00141171=$P($g(^CTPCP(Doctor,1)),"^",2)  ///就诊医生签名
				}
				///医嘱号(电子申请单号)	OrderSn""
				s OrderSn=orderParref_"||"_orderId  ///医嘱号(电子申请单号)
				d OutputRow1
				}
			}
		}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(AdmID,DocumentID,HDSD0014117,HDSD00141171,OrderSn)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetC0052InfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetC0052InfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
       Set AtEnd=1
	   Set Row=""
    }Else{Set Row=^CacheTemp(repid,ind)}
    s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetC0052InfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetC0052InfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetC0052Info(StartDate As %String, EndDate As %String, Hospital As %String) As %Query(ROWSPEC = "AdmID,DocumentID,HDSD0014117,HDSD00141171,OrderSn")
{
}

}
