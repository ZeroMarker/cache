Class DHCLIS.DHCBTQuery Extends %RegisteredObject
{

Query QueryDoctor(HospID, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

/// Creator：      sunzhiwen
/// CreatDate：    
/// Description:： 根据医院查询病人信息
/// Table：        
/// Input：        
/// Others：  d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTQuery","QueryDoctor","2","149","","","","2","","","","","","","","","")     
ClassMethod QueryDoctorExecute(ByRef qHandle As %Binary, HospID, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	
	i $l(HospID) s CurHospitalCode=$p(^CT("HOSP",HospID),"^",1) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(CurHospitalCode),""))
	i '$l($g(HospitalDR)) s HospitalDR = $o(^dbo.BTHospitalD(""))
	
	s HisCode=""
	for {
		s HisCode = $o(^dbo.BTDoctorI("IndexHISCode",HospitalDR,HisCode))
		q:'$l(HisCode)
		s DoctorDR=""
		for {
			s DoctorDR=$o(^dbo.BTDoctorI("IndexHISCode",HospitalDR,HisCode,DoctorDR))
			q:DoctorDR=""
			s DoctorData = $g(^dbo.BTDoctorD(DoctorDR))
			s CName = $lg(DoctorData,3)
			s Code = $lg(DoctorData,2)
			s Data = $lb(DoctorDR,Code,CName)
			d OutputRow
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
OutputRow
	s iLen=$LISTLENGTH(Data)
	f i=1:1:iLen s $LI(Data,i)=$tr($LI(Data,i),$c(0))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryDoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDoctorExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryDoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDoctorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryLocation(HospID, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

/// Creator：      sunzhiwen
/// CreatDate：    
/// Description:： 根据登记号，申请科室，申请病区查询
/// Table：        
/// Input：        就诊号,病员号
/// Return：       函数返回值的说明
/// Others：  d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTQuery","QueryLocation","2","149","","","","2","","","","","","","","","")     
ClassMethod QueryLocationExecute(ByRef qHandle As %Binary, HospID, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	s ^TempWangLi("lis")=HospID
	i $l(HospID) s CurHospitalCode=$p(^CT("HOSP",HospID),"^",1)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(CurHospitalCode),""))
	b
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	s tCode=""
	for {
		s tCode = $o(^dbo.BTLocationI("IndexCode",HospitalDR,tCode))
		q:tCode=""
	
		s LocationDR = $o(^dbo.BTLocationI("IndexCode",HospitalDR,tCode,""))
		i '$l(LocationDR) q
		s LocationData = $g(^dbo.BTLocationD(LocationDR))
		s RowID=LocationDR
		s Active = $lg(LocationData,11)
		//b ;LocationData
		//i Active=0 q
		s CName = $lg(LocationData,3)
		s Code = $lg(LocationData,2)
		s Data=$lb(RowID,Code,CName)
		d OutputRow
	}
	
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
OutputRow
	s iLen=$LISTLENGTH(Data)
	f i=1:1:iLen s $LI(Data,i)=$tr($LI(Data,i),$c(0))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocationExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryWard(fLocationDR, fHospitalDR, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

/// Creator：      sunzhiwen
/// CreatDate：    
/// Description:： 根据科室查询病区信息
/// Table：        
/// Input：        
/// Others：  d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTQuery","QueryWard","2","149","","","","2","","","","","","","","","")     
ClassMethod QueryWardExecute(ByRef qHandle As %Binary, fLocationDR, fHospitalDR, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	i $l(fLocationDR) {
		s WardDR=""
		for {
			s WardDR = $o(^dbo.BTWardI("IndexLocation",fLocationDR,WardDR))
			q:WardDR=""
			s WardData= $g(^dbo.BTWardD(WardDR))
			s CName=$lg(WardData,3)
			s Code=$lg(WardData,2)
			s Data = $lb(WardDR,Code,CName)
			d OutputRow
		}
	}
	else 
	{
		s WardDR="0"
		for {
			s WardDR = $o(^dbo.BTWardD(WardDR))
			q:WardDR=""
			s WardData= $g(^dbo.BTWardD(WardDR))
			s CName=$lg(WardData,3)
			s Code=$lg(WardData,2)
			s LocationDR=$lg(WardData,5),HospitalDR=""
			i $l(LocationDR) s HospitalDR=$lg(^dbo.BTLocationD(LocationDR),4)
			i $l(fHospitalDR),fHospitalDR'=HospitalDR Continue
			s Data = $lb(WardDR,Code,CName)
			d OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
OutputRow
	s iLen=$LISTLENGTH(Data)
	f i=1:1:iLen s $LI(Data,i)=$tr($LI(Data,i),$c(0))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：xuzhiguo
/// 先找出所有医院  根据医院入参 遍历当前院区数据 然后遍历关联院区（院区code为当前院区） 临时记录数据（根据院区） 判断 然后输出
/// CreatDate：20210721
/// Description:： 外部代码、标本代码、标本描述、管代码、管描述、检验分组（合管规则）、所属院区code 、是否默认（Y/N)
/// Input：        
/// Output：(Code,SpecimenCode,Specimen,ContainerCode,TestSetGroupCode,HospitalCode,IsDefault)
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTQuery","QryTestSetInfo","","","","","","","","","","","","","","","8280^1^0^12^1")
Query QryTestSetInfo(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "Code,SpecimenCode,Specimen,ContainerCode,ContainerDesc,TestSetGroupCode,HospitalCode,IsDefault")
{
}

ClassMethod QryTestSetInfoExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	
	s ^MMP("QryTestSetInfo")=$LB(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	Set repid=$I(^CacheTemp)
 	Set ind =1
 	s RowCount=0 
 	
 	k ^TMPLIS($zn,$j,"DATA")
 	
 	//遍历医院	dbo.BTHospital
 	s HospitalDRs=""
 	s HosCode="" f  s HosCode=$o(^dbo.BTHospitalI("IndexCode",HosCode)) q:HosCode=""  d
 	.s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",HosCode,""))
 	.q:'$l(HospitalDR)
 	.s Active=$lg($g(^dbo.BTHospitalD(HospitalDR)),11)
 	.i (Active'=1) q
 	.i $l(HospitalDRs) s HospitalDRs=HospitalDRs_"^"_HospitalDR
 	.e  s HospitalDRs=HospitalDR
 	
 	//遍历归属医院
 	i $l(HospitalDRs) d
 	.f i=1:1:$l(HospitalDRs) d
 	..s HospitalDR=$p(HospitalDRs,"^",i)
 	..q:'$l(HospitalDR)
 	..s HospitalCode=$lg($g(^dbo.BTHospitalD(HospitalDR)),2)
 	..s IHospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),12)
 	..i $l(IHospitalDR) s HospitalDR=IHospitalDR
 	..d QryInfo
 	
 	//遍历当前医院特殊维护的数据
 	i $l(HospitalDRs) d
 	.f i=1:1:$l(HospitalDRs) d
 	..s HospitalDR=$p(HospitalDRs,"^",i)
 	..q:'$l(HospitalDR)
 	..s HospitalCode=$lg($g(^dbo.BTHospitalD(HospitalDR)),2)
 	..s IHospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),12)
 	..q:'$l(IHospitalDR)
 	..i (IHospitalDR=HospitalDR) q
 	..d QryInfo
 	
 	s HospitalCode="" f  s HospitalCode=$o(^TMPLIS($zn,$j,"DATA",HospitalCode)) q:HospitalCode=""  d
 	.s Code="" f  s Code=$o(^TMPLIS($zn,$j,"DATA",HospitalCode,Code)) q:Code=""  d
 	..s SpecimenCode="" f  s SpecimenCode=$o(^TMPLIS($zn,$j,"DATA",HospitalCode,Code,SpecimenCode)) q:SpecimenCode=""  d
 	...s Data=$g(^TMPLIS($zn,$j,"DATA",HospitalCode,Code,SpecimenCode))
 	...S ^CacheTemp(repid,ind)=Data
	...S ind=ind+1
 	
 	k ^TMPLIS($zn,$j,"DATA")
 	

	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
	
QryInfo
	s Code=""
 	f  s Code=$o(^dbo.BTTestSetI("IndexCodeHosp",Code)) q:Code=""  d
 	.s TestSetDR="" f  s TestSetDR=$o(^dbo.BTTestSetI("IndexCodeHosp",Code,HospitalDR,TestSetDR)) q:TestSetDR=""  d
 	..s TestSetData=$g(^dbo.BTTestSetD(TestSetDR)) 
 	..s Active=$lg(TestSetData,18)
 	..i Active'=1 q
 	..s CName=$lg(TestSetData,3)
 	..s TestSetGroupDR=$o(^dbo.BTTestSetGroupLinksI("IndexTestSet",TestSetDR,""))
 	..s TestSetGroupCode=""
 	..i $l(TestSetGroupDR) d
 	...s TestSetGroupCode=$lg($g(^dbo.BTTestSetGroupD(TestSetGroupDR)),2)
 	...i $lg($g(^dbo.BTTestSetGroupD(TestSetGroupDR)),6)'=1 s TestSetGroupCode=""
 	..s SpecimenDR="" f  s SpecimenDR=$o(^dbo.BTTestSetSpecimenI("IndexMaster",TestSetDR,SpecimenDR)) q:SpecimenDR=""  d
 	...s TSSpecimenDR="" f  s TSSpecimenDR=$o(^dbo.BTTestSetSpecimenI("IndexMaster",TestSetDR,SpecimenDR,TSSpecimenDR)) q:TSSpecimenDR=""  d
 	....s TSSpecimenData=$g(^dbo.BTTestSetSpecimenD(TSSpecimenDR))
 	....s IsDefault=$lg(TSSpecimenData,6)
 	....i IsDefault=1 s IsDefault="Y"
 	....e  s IsDefault="N"
 	....s ContainerDR=$lg(TSSpecimenData,4)
 	....s (ContainerCode,ContainerDesc)=""
 	....i $l(ContainerDR) d
 	.....s ContainerCode=$lg($g(^dbo.BTContainerD(ContainerDR)),2)
 	.....s ContainerDesc=$lg($g(^dbo.BTContainerD(ContainerDR)),3)
 	....s SpecimenCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
 	....s Specimen=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
 	....d OutPut
	q
	 
OutPut
	i $d(^TMPLIS($zn,$j,"DATA",HospitalCode,Code,SpecimenCode)) q
	s Data=$lb(Code,SpecimenCode,Specimen,ContainerCode,ContainerDesc,TestSetGroupCode,HospitalCode,IsDefault)
	s ^TMPLIS($zn,$j,"DATA",HospitalCode,Code,SpecimenCode)=Data
	/*s RowCount=RowCount+1
	s Data=$lb(Code,SpecimenCode,Specimen,ContainerCode,ContainerDesc,TestSetGroupCode,HospitalCode,IsDefault)
	S ^CacheTemp(repid,ind)=Data
	Set ind=ind+1*/
	q
}

ClassMethod QryTestSetInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestSetInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
