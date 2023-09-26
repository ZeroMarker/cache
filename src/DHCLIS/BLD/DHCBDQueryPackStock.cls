Class DHCLIS.BLD.DHCBDQueryPackStock Extends %RegisteredObject
{

/// Creator：      baoguotao
/// CreatDate：    20160427
/// Description:： 查询库存预警
/// Table：        dbo.BDPackInItem,dbo.BDPackIn,dbo.BDPack,^dbo.SYSParameter
/// Input：        SupplierDR:血站DR，BdProductDR：血产品DR, BdGroupDR:血型DR
/// Output：       系统配置各血型的血产品当前库存,多级预警库存，最佳库存
/// d ##Class(%ResultSet).RunQuery("BLD.WS.BLL.DHCBDPackQuery","QryStockWarning","","","","","","","0","","","","","","","","1^^1^^1")	
Query QryStockWarning(SupplierDR, BdComponentDR, BdGroupDR, P3, P4, fWorkGroupDR, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "BloodComponentName,BdTypeName,BdpackCount,Stockwarning4,Stockwarning3,Stockwarning2,Stockwarning1,Beststock")
{
}

ClassMethod QryStockWarningExecute(ByRef qHandle As %Binary, SupplierDR, BdComponentDR, BdGroupDR, P3, P4, fWorkGroupDR, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s RowCount=0 
    s LabSN="DHC-LISDATA"
    s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
	k ^TMP($zn,repid,$j)
    s PackInDR="" f  s PackInDR=$o(^|LabSN|dbo.BDPackInItemsI("IndexMaster",PackInDR)) q:(PackInDR="")  d
    .s PackDR=""  f  s PackDR=$o(^|LabSN|dbo.BDPackInItemsI("IndexMaster",PackInDR,PackDR)) q:(PackDR="")  d
    ..s PackInItemsDR="" f  s PackInItemsDR=$o(^|LabSN|dbo.BDPackInItemsI("IndexMaster",PackInDR,PackDR,PackInItemsDR)) q:(PackInItemsDR="")  d
    ...s BDPackInData=$g(^|LabSN|dbo.BDPackInD(PackInDR))
    ...s PackInNo=$lg(BDPackInData,2)
    ...s Supplier=$lg(BDPackInData,3)
    ...i $l(SupplierDR),SupplierDR'=Supplier q
    ...s AddDate =$lg(BDPackInData,5)
    ...s BDPackData=$g(^|LabSN|dbo.BDPackD(PackDR)) 
    ...s AddTime =$lg(BDPackInData,6)
    ...s AddUserDR =$lg(BDPackInData,7) 
    ...s BDPackData=$g(^|LabSN|dbo.BDPackD(PackDR)) 
    ...s PackID=$lg(BDPackData,2) 
    ...s BloodProductDR=$lg(BDPackData,3)
    ...s BDProductData=$g(^|LabSN|dbo.BBBloodProductD(BloodProductDR)) 
    ...s BloodComponentDR=$lg(BDProductData,10)
    ...//过滤血成分
    ...i $l(BdComponentDR),BdComponentDR'=BloodComponentDR q 
    ...s BloodProduct=$lg(BDProductData,3)
    ...s BloodGroupDR=$lg(BDPackData,9)
    ...//过滤血型组
    ...i $l(BdGroupDR),BdGroupDR'=BloodGroupDR q 
    ...s WorkGroupDR=$lg(BDPackData,40)
    ...//过滤工作小组
    ...i $l(fWorkGroupDR),fWorkGroupDR'=WorkGroupDR q
    ...s BdType=BloodGroupDR
    ...s PackStatusDR=$lg(BDPackData,34) 
    ...s StatusStock=$lg(^|LabSN|dbo.BBPackStatusD(PackStatusDR),2)
    ...s PackStatus=$lg(^|LabSN|dbo.BBPackStatusD(PackStatusDR),3)
    ...//只查询库存状态血液
    ...i StatusStock '= "IN1" q
    ...s PackVolume=$lg(BDPackData,10)  
    ...s ^TMP($zn,repid,$j,"Count",BloodComponentDR,BdType)=PackVolume+$g(^TMP($zn,repid,$j,"Count",BloodGroupDR,BloodComponentDR))     
    ...s ^TMP($zn,repid,$j,"PackCount")=1+$g(^TMP($zn,repid,$j,"PackCount")) 
     
    i '$d(^TMP($zn,repid,$j,"PackCount")) Set qHandle=$lb(0,repid,0) Quit $$$OK
    s BloodComponentsCode="" f  s BloodComponentsCode=$o(^|LabSN|dbo.BBBloodComponentsI("IndexCode",BloodComponentsCode)) q:BloodComponentsCode=""  d
	.s BloodComponentDR=$o(^|LabSN|dbo.BBBloodComponentsI("IndexCode",BloodComponentsCode,""))
	.s BloodGroupCode="" f  s BloodGroupCode=$o(^|LabSN|dbo.BBBloodGroupI("IndexCode",BloodGroupCode)) q:BloodGroupCode=""  d
	..s BdType=$o(^|LabSN|dbo.BBBloodGroupI("IndexCode",BloodGroupCode,""))
	..i $l(BdGroupDR),BdGroupDR'=BdType q  //Add By SZW 20171011 过滤血型
	..s BdpackCount=0
	..i $d(^TMP($zn,repid,$j,"Count",BloodComponentDR,BdType)) s BdpackCount=^TMP($zn,repid,$j,"Count",BloodComponentDR,BdType) 
    ..s BloodComponentName=$lg(^|LabSN|dbo.BBBloodComponentsD(BloodComponentDR),3)
    ..s Stockwarning4="",Stockwarning3="",Stockwarning2="",Stockwarning1="",Leaststock="0" 
    ..s SYSParameterDR=$o(^|LabSN|dbo.SYSParameterI("IndexCode"," STOCKWARNING4"_BloodComponentDR_BdType," BLD"," BLD","")) 
    ..i $l(SYSParameterDR) d
    ...s Stockwarning4=$lg($g(^|LabSN|dbo.SYSParameterD(SYSParameterDR)),5)
    ...s Leaststock= Stockwarning4
    ..//未达到库存预警，退出
    ..i $l(Stockwarning4),BdpackCount>Stockwarning4 q 
    ..s SYSParameterDR=$o(^|LabSN|dbo.SYSParameterI("IndexCode"," STOCKWARNING3"_BloodComponentDR_BdType," BLD"," BLD","")) 
    ..i $l(SYSParameterDR) d
    ...s Stockwarning3=$lg($g(^|LabSN|dbo.SYSParameterD(SYSParameterDR)),5)
    ...s Leaststock= Stockwarning3
    ..s SYSParameterDR=$o(^|LabSN|dbo.SYSParameterI("IndexCode"," STOCKWARNING2"_BloodComponentDR_BdType," BLD"," BLD","")) 
    ..i $l(SYSParameterDR) d
    ...s Stockwarning2=$lg($g(^|LabSN|dbo.SYSParameterD(SYSParameterDR)),5)
    ...s Leaststock= Stockwarning2
    ..s SYSParameterDR=$o(^|LabSN|dbo.SYSParameterI("IndexCode"," STOCKWARNING1"_BloodComponentDR_BdType," BLD"," BLD","")) 
    ..i $l(SYSParameterDR) d
    ...s Stockwarning1=$lg($g(^|LabSN|dbo.SYSParameterD(SYSParameterDR)),5)
    ...s Leaststock= Stockwarning1 
    ..i ('$l(Stockwarning4)&&('$l(Stockwarning3))&&('$l(Stockwarning2))&&('$l(Stockwarning1))) q
    ..s BdTypeName=$lg(^|LabSN|dbo.BBBloodGroupD(BdType),3)
    ..//获取最近一个月平均用血量
    ..s AvgPackVol=..GetMonthBlood(BloodComponentDR,BdType)
    ..//最佳用血量=设置最低库存量+8*月平均用血量
    ..s Beststock= Leaststock+$NUMBER(8*AvgPackVol,0)
    ..d OutPut 
    
    k ^TMP($zn,repid,$j)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPut
	Set Data=$lb(BloodComponentName,BdTypeName,BdpackCount,Stockwarning4,Stockwarning3,Stockwarning2,Stockwarning1,Beststock)
    set ColFields="BloodComponentName,BdTypeName,BdpackCount,Stockwarning4,Stockwarning3,Stockwarning2,Stockwarning1,Beststock" 
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryStockWarningClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStockWarningExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryStockWarningFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStockWarningExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMonthBlood(fBloodComponent, fBdType) As %String
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s RowCount=0 
	k ^TMP($zn,repid,$j) 
	s total=0
	s nowDate=$p($h,",",1)
	s EndAccDate=$zd(nowDate-1,8)
	s SttAccDate=$zd(nowDate-31,8)
 
    s Date=$o(^dbo.BDPackTransactionI("IndexTransDate",EndAccDate),1)
    f  s Date=$o(^dbo.BDPackTransactionI("IndexTransDate",Date),-1) q:(Date="")||($l(SttAccDate)&&(Date<SttAccDate))  d
    .s PackTransDR="" f  s PackTransDR=$o(^dbo.BDPackTransactionI("IndexTransDate",Date,PackTransDR),-1) q:(PackTransDR="")  d 
    ..s TransactionDR=$lg($g(^dbo.BDPackTransactionD(PackTransDR)),6) 
    ..s TransactionStatusDR=$o(^dbo.BBTransactionStatusI("IndexTransaction",TransactionDR,"")) 
    ..i '$l(TransactionStatusDR) q 
    ..S TransactionStatus = $lg($g(^dbo.BBTransactionStatusD(TransactionStatusDR)),5) 
    ..s PackStatus =$lg($g(^dbo.BBPackStatusD(TransactionStatus)),2) 
    ..//只统计置血液状态为输用或待输用的事件
    ..i (PackStatus'="OUT0")&&(PackStatus'="OUT") q  
    ..s packDR= $lg($g(^dbo.BDPackTransactionD(PackTransDR)),2)
    ..s fPackID=$o(^TMP($zn,repid,$j,"DATA",packDR,"")) 
 	..i fPackID'="" q  
    ..s BDPackData=$g(^dbo.BDPackD(packDR))
    ..s PackStatusDR=$lg(BDPackData,34)
    ..s PackStatus =$lg($g(^dbo.BBPackStatusD(PackStatusDR)),2) 
    ..//只统计当前状态输用或待输用的血液
    ..i (PackStatus'="OUT0")&&(PackStatus'="OUT") q  
    ..s Supplier=$lg(BDPackData,12) 
    ..s PackID=$lg(BDPackData,2) 
    ..s BloodProductDR=$lg(BDPackData,3)
    ..s BDProductData=$g(^dbo.BBBloodProductD(BloodProductDR))   
    ..s BloodGroupDR=$lg(BDPackData,9)
    ..s BloodComponentDR=$lg(BDProductData,10) 
    ..//过滤血成分
    ..i $l(fBloodComponent)>0,fBloodComponent'=BloodComponentDR q
    ..s BdType=$lg(^dbo.BBBloodGroupD(BloodGroupDR),4) 
    ..//过滤血型组
    ..i $l(fBdType)>0,fBdType'=BdType q  
    ..s ^TMP($zn,repid,$j,"DATA",packDR,1)=PackID
    ..s PackVolume=$lg(BDPackData,10)       
    ..s total=total+PackVolume 
    s avgPackVol=total/31
    q avgPackVol
}

}
