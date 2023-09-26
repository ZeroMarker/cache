Class web.DHCBldStatTotalPackIn Extends %Persistent
{

/// 药敏分离统计
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
	Q $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatTotalPackIn","QuerySampleStatistics","2014-12-01 11:38:42","2014-12-03 11:38:42","","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, BGFlag As %String, USERCODE As %String, HospitalCode As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(DateS) S DateS=+$H-1,DateS=$ZD(DateS,3)
  I '$L(DateE) S DateE=+$H,DateE=$ZD(DateE,3)
  I '$L(USERCODE) S USERCODE="demo"
  S ^TMP("xq1")=DateS_","_DateE_","_SupplierId_","_ProductCode_","_GroupCode_","_productGroupCode_","_BGFlag_","_HospitalCode
  S HospitalCode=$G(HospitalCode)
  S HospitalDesc=""
  //S HospitalCode=$O(^TTABi("CC",1,""))
  I '$L(HospitalCode) S HospitalCode=""
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  k ^TMP($zn,$j,"TotalIn")
  S total=0,totalValume=0,HospitalCode=$g(HospitalCode)
  S TimeS=$P(DateS," ",2)
  S TimeE=$P(DateE," ",2)
  S DateS=$ZDH(DateS,3)
  S DateE=$ZDH(DateE,3)
  S TimeS=$ZTH(TimeS,1)
  S TimeE=$ZTH(TimeE,1)
  S ProductCode=$tr(ProductCode," ")
  S GroupCode=$tr(GroupCode," ")
  F iDate=DateS:1:DateE D
  .S iTime=""  F  S iTime=$o(^TBBPi("DateTimeRec",iDate,iTime))  Q:iTime=""  D
  ..I (iDate=DateS)&(iTime<TimeS) Q
  ..I (iDate=DateE)&(iTime>DateE) Q
  ..S PackID=""  F  S PackID=$o(^TBBPi("DateTimeRec",iDate,iTime,PackID))  Q:PackID=""  D
  ...S SecondId=""  F  S SecondId=$o(^TBBPi("DateTimeRec",iDate,iTime,PackID,SecondId))  Q:SecondId=""  D
  ....;删除的血袋处理
  ....I '$D(^TBBP(PackID,SecondId)) Q
  ....I ($D(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId))),($P(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId),"\",6)="Y") Q  
  ....S BloodProduct=$P(^TBBP(PackID,SecondId),"\",4)
  ....;-----多医院-------->
  ....S BPCode=$p($g(^TBBP(PackID,SecondId)),"\",4),CurHospitalCode=""
  ....I $L(BPCode) s CurHospitalCode=$p(^TTAB("BB-BP",BPCode),"\",11)
  ....I $L(HospitalCode),$L(CurHospitalCode),CurHospitalCode'=HospitalCode Quit
  ....I $L(HospitalCode),'$L(CurHospitalCode),'$d(^TTABi("CC",1,HospitalCode)) Quit
  ....;------------------<
  ....S BloodGroup=$P(^TBBP(PackID,SecondId),"\",5)
  ....S PackVolume=$P(^TBBP(PackID,SecondId),"\",21)
  ....S SupCode=$P(^TBBP(PackID,SecondId),"\",12)
  ....;血成分
  ....I $L(BloodProduct),$d(^TTAB("BB-BP",BloodProduct)) s ProductGroup=$P(^TTAB("BB-BP",BloodProduct),"\",21)
  ....I $L(productGroupCode),productGroupCode'=ProductGroup Q
  ....I SupCode'="" s SupDesc=$P(^TTAB("BB-SUP",SupCode),"\",1)
  ....S PackVolume=$P(^TBBP(PackID,SecondId),"\",21)
  ....S bldProductUnit=$P($G(^TTAB("BB-BP",BloodProduct,"REM",1)),"&",1)
  ....S rate=+bldProductUnit
  ....S:rate=0 rate=1
  ....S PackVolume=PackVolume*rate
  ....S:rate>1 bldProductUnit=$P(bldProductUnit,rate,2)
  ....S tranStatus=$P(^TBBP(PackID,SecondId),"\",2)
  ....//Q:(tranStatus'="ISS")&(tranStatus'="STOCK")
  ....S SupCode=$P(^TBBP(PackID,SecondId),"\",12)
  ....I SupCode'="" s SupDesc=$P(^TTAB("BB-SUP",SupCode),"\",1)
  ....I (ProductCode'="")&(ProductCode'=BloodProduct) Q
  ....I (GroupCode'="")&(GroupCode'=BloodGroup) Q
  ....I (SupplierId'="")&(SupplierId'=SupCode) Q
  ....I BGFlag=1,$L(ProductGroup) s BloodProduct=ProductGroup  ;血成份统计
  ....S inStoreType="普通入库"
  ....S:$P($G(^Dhcbbpackprice(PackID,SecondId)),"\",5)="Y" inStoreType="拆分入库"
  ....S curTotalPackNum=+$P($G(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType,tranStatus,PackVolume)),"^",1)
  ....S curTotalPackVolume=+$P($G(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType,tranStatus,PackVolume)),"^",2)
  ....S $P(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType,tranStatus,PackVolume),"^",1)=curTotalPackNum+1
  ....S $P(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType,tranStatus,PackVolume),"^",2)=curTotalPackVolume+PackVolume
  ....S:$L(bldProductUnit) $P(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType,tranStatus,PackVolume),"^",3)=bldProductUnit
  
  K PLIST
  S BloodProduct="",deli=$C(2),ret=0,P8=0,P9=0,totalSumNum=0,totalSumVol=0
  F  S BloodProduct=$O(^TMP($zn,$j,"TotalIn",BloodProduct)) Q:'$L(BloodProduct)  D
  .S bldProductDesc=$P($G(^TTAB("BB-BP",BloodProduct)),"\",1)
  .I '$L(bldProductDesc) D
  ..S bldProductDesc=$P($G(^TTAB("BB-PG",BloodProduct)),"\",1)
  .S BloodGroup="",bldProSumNum=0,bldProSumVol=0
  .F  S BloodGroup=$O(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup)) Q:'$L(BloodGroup)  D 
  ..S bldGrpDesc=$P($G(^TTAB("BB-BG",BloodGroup)),"\",1)
  ..S inStoreType=""
  ..F  S inStoreType=$O(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType)) Q:'$L(inStoreType)  D
  ...S tranStatus="",bldSumNum=0,bldSumVol=0
  ...F  S tranStatus=$O(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType,tranStatus)) Q:'$L(tranStatus)  D 
  ....S statusDesc=$P($G(^TTAB("BB-ST",tranStatus)),"\",1)
  ....S PackVolume=""
  ....F  S PackVolume=$O(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType,tranStatus,PackVolume)) Q:'$L(PackVolume)  D
  .....S curTotalPackNum=$P($G(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType,tranStatus,PackVolume)),"^",1)
  .....S curTotalPackVolume=$P($G(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType,tranStatus,PackVolume)),"^",2)
  .....S bldProductUnit=$P($G(^TMP($zn,$j,"TotalIn",BloodProduct,BloodGroup,inStoreType,tranStatus,PackVolume)),"^",3)
  .....S record=bldProductDesc_deli_bldGrpDesc_deli_inStoreType_deli_statusDesc_deli_PackVolume_deli_bldProductUnit_deli_curTotalPackNum_deli_curTotalPackVolume_deli
  .....//S ret=ret+1,PLIST(ret)=record
  .....S OPutbldSumNum=curTotalPackNum
  .....S OPutbldSumVol=curTotalPackVolume
  .....S (Field1,Field2,Field3,Field1,Field5)=""
  .....S Data=$lb(bldProductDesc,bldGrpDesc,inStoreType,statusDesc,PackVolume,bldProductUnit,OPutbldSumNum,OPutbldSumVol,HospitalDesc,Field1,Field2,Field3,Field1,Field5)
  .....D Output
  .....S bldSumNum=bldSumNum+curTotalPackNum,bldSumVol=bldSumVol+curTotalPackVolume
  ..S record=bldProductDesc_deli_bldGrpDesc_deli_"小计"_deli_"小计"_deli_"小计"_deli_"小计"_deli_bldSumNum_deli_bldSumVol_deli
  ..S Xj="小计"
  ..S inStoreType=Xj,statusDesc=Xj,PackVolume=Xj,bldProductUnit=Xj,OPutbldSumNum=bldSumNum,OPutbldSumVol=bldSumVol
  ..//S ret=ret+1,PLIST(ret)=record
  ..S (Field1,Field2,Field3,Field1,Field5)=""
  ..S Data=$lb(bldProductDesc,bldGrpDesc,inStoreType,statusDesc,PackVolume,bldProductUnit,OPutbldSumNum,OPutbldSumVol,HospitalDesc,Field1,Field2,Field3,Field1,Field5)
  ..D Output
  ..S bldProSumNum=bldProSumNum+bldSumNum,bldProSumVol=bldProSumVol+bldSumVol
  .S record=bldProductDesc_deli_"合计"_deli_"合计"_deli_"合计"_deli_"合计"_deli_"合计"_deli_bldProSumNum_deli_bldProSumVol_deli
  .//S ret=ret+1,PLIST(ret)=record
  .S Hj="合计" 
  .S bldGrpDesc=Hj,inStoreType=Hj,statusDesc=Hj,PackVolume=Hj,bldProductUnit=Hj,OPutbldSumNum=bldProSumNum,OPutbldSumVol=bldProSumVol
  .S (Field1,Field2,Field3,Field1,Field5)=""
  .S Data=$lb(bldProductDesc,bldGrpDesc,inStoreType,statusDesc,PackVolume,bldProductUnit,OPutbldSumNum,OPutbldSumVol)
  .D Output
  .S totalSumNum=totalSumNum+bldProSumNum,totalSumVol=totalSumVol+bldProSumVol
  K ^TMP($zn,$j,"TotalIn")
  S qHandle=$lb(0,repid,0)
  Q $$$OK
 
Output
	S Data=$lb(bldProductDesc,bldGrpDesc,inStoreType,statusDesc,PackVolume,bldProductUnit,OPutbldSumNum,OPutbldSumVol,HospitalDesc,Field1,Field2,Field3,Field1,Field5)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod QuerySampleStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
 	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$O(^CacheTemp(repid,ind))
 	I ind="" 
 	{				// if there are no more rows, finish fetching
 		S AtEnd=1
 		S Row=""
 	}
 	Else      
 	{	// fetch row
 		S Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140331
/// Description:： 样本数统计
/// Table：        
/// Input：        DateS:起始日期,DateE:结束日期，DepCode：检验科科室代码,MachCode仪器代码为空全部检索，MachTG：仪器组代码为空全部检索，CliCode：医生申请科室代码为空全部检索，DocCode:医生工号为空全部检索，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       Debtor:登记号,PatName：病人姓名,SpeName：性别,PatAge：年龄,CliDepName：申请科室,Labno：检验号,TestName：医嘱名称,ColectDateTime:采集时间,RecevieDateTime:接收时间,AuthorDateTime:审核时间
/// Return：       无
/// Others：
Query QuerySampleStatistics(DateS As %String, DateE As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, BGFlag As %String, USERCODE As %String, HospitalCode As %String) As %Query(ROWSPEC = "bldProductDesc:%String,bldGrpDesc:%String,inStoreType:%String,statusDesc:%String,PackVolume:%String,bldProductUnit:%String,OPutbldSumNum:%String,OPutbldSumVol:%String,HospitalDesc:%String,Field1:%String,Field2:%String,Field3:%String,Field1:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatTotalPackInDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatTotalPackInD</DataLocation>
<DefaultData>DHCBldStatTotalPackInDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatTotalPackInD</IdLocation>
<IndexLocation>^web.DHCBldStatTotalPackInI</IndexLocation>
<StreamLocation>^web.DHCBldStatTotalPackInS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
