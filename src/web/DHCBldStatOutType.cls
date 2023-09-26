Class web.DHCBldStatOutType Extends %Persistent
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
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatOutType","QuerySampleStatistics","2015-03-10 11:44:00","2015-03-17 11:44:00","","","","","","0","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, HospitalCode As %String, BGFlag As %String, TransType As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  S ^TMP("xq1")=$lb(DateS,DateE,SupplierId,ProductCode,GroupCode,productGroupCode,HospitalCode,BGFlag,TransType,USERCODE)
  I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
  I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
  I TransType="null" S TransType=""
  I ProductCode="null" S ProductCode=""
  I GroupCode="null" S GroupCode=""
  I productGroupCode="null" S productGroupCode=""
  S TimeS=""
  S TimeE=""
  I $L(DateS) S TimeS=$P(DateS," ",2),DateS=$P(DateS," ",1)
  I $L(DateE) S TimeE=$P(DateE," ",2),DateE=$P(DateE," ",1)
  I $L(TimeS) S TimeS=$ZTH(TimeS,1)
  I $L(TimeE) S TimeE=$ZTH(TimeE,1)
  I '$L(USERCODE) S USERCODE="demo"
  S HospitalCode=$G(HospitalCode)
  S HospitalDesc=""
  //S HospitalCode=$O(^TTABi("CC",1,""))
  I $L(HospitalCode) S HospitalDesc=$P(^TTAB("CC",HospitalCode),"\",1)
  S TransType=$G(TransType)
  K ^TMP($zn,$j,"OUT"),^TMP($zn,$j,"TotalOut")
  S stockstatus="OUTIN-0"
  S BGFlag=$G(BGFlag)
  S DateS=$ZDH(DateS,3)
  S DateE=$ZDH(DateE,3)
  S total=0,totalValume=0
  F iDate=DateS:1:DateE D
  .S iTime=""  F  S iTime=$O(^TBBPi("TR-DateTime",iDate,iTime))  Q:iTime=""  D
  ..I (iDate=DateS)&(iTime<TimeS) q
  ..I (iDate=DateE)&(iTime>TimeE) q
  ..S PackID=""  F  S PackID=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID))  Q:PackID=""  D
  ...S SecondId=""  F  S SecondId=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID,SecondId))  Q:SecondId=""  D
  ....I '$D(^TBBP(PackID,SecondId)) Q
  ....;-----多医院-------->
  ....S BPCode=$p($G(^TBBP(PackID,SecondId)),"\",4),CurHospitalCode=""
  ....I $L(BPCode) S CurHospitalCode=$p(^TTAB("BB-BP",BPCode),"\",11)
  ....I $L(HospitalCode),$L(CurHospitalCode),CurHospitalCode'=HospitalCode Quit
  ....//i $L(HospitalCode),'$L(CurHospitalCode),'$D(^TTABi("CC",1,HospitalCode)) Quit
  ....;------------------<
  ....S Sequence=""  F  S Sequence=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID,SecondId,Sequence))  Q:Sequence=""  D
  .....I $D(^TMP($zn,$j,"OUT",PackID,SecondId))'=0 D
  ......S zz=^TMP($zn,$j,"OUT",PackID,SecondId)
  ......I Sequence>zz S ^TMP($zn,$j,"OUT",PackID,SecondId)=Sequence
  .....E  D
  ......S ^TMP($zn,$j,"OUT",PackID,SecondId)=Sequence
  b ;123
  S Num=0
  S PackID=""  F  S PackID=$O(^TMP($zn,$j,"OUT",PackID))  Q:PackID=""  D
  .S SecondId=""  F  S SecondId=$O(^TMP($zn,$j,"OUT",PackID,SecondId))  Q:SecondId=""  D
  ..;删除的血袋处理
  ..I '$D(^TBBP(PackID,SecondId)) Q
  ..I ($D(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId))),($P(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId),"\",6)="Y") Q  
  ..S Sequence=^TMP($zn,$j,"OUT",PackID,SecondId)
  ..S sStock=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",8)
  ..;<------------------------------------------20140805
  ..S OutType=$p(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)
  ..//I $L(TransType),$L(OutType),OutType'=TransType Q
  ..;<------------------------------------------
  ..S StockCode=$P(^TTAB("BB-ST",sStock),"\",2)
  ..I stockstatus'[StockCode Q
  ..S BloodProduct=$P(^TBBP(PackID,SecondId),"\",4)
  ..S BloodGroup=$P(^TBBP(PackID,SecondId),"\",5)
  ..;血成分
  ..I $L(BloodProduct),$D(^TTAB("BB-BP",BloodProduct)) S ProductGroup=$P(^TTAB("BB-BP",BloodProduct),"\",21)
  ..I $L(productGroupCode),productGroupCode'=ProductGroup Q
  ..S PackVolume=$P(^TBBP(PackID,SecondId),"\",21)
  ..//I PackID="=0160214703166" S ^TMP("qxf",PackID,SecondId)=PackVolume
  ..I $L(TransType),$L(OutType),OutType'=TransType Q
  ..S Num=Num+1
  ..//S ^TMP("xqq",Num)=$lb(PackID,SecondId,PackVolume)
  ..S SupCode=$P(^TBBP(PackID,SecondId),"\",12)
  ..I SupCode'="" S SupDesc=$P(^TTAB("BB-SUP",SupCode),"\",1)
  ..I (ProductCode'="")&(ProductCode'=BloodProduct) Q
  ..I (GroupCode'="")&(GroupCode'=BloodGroup) Q
  ..I (SupplierId'="")&(SupplierId'=SupCode) Q
  ..S total=total+1
  ..S totalValume=totalValume+PackVolume
  ..S bldSumNum=1
  ..I BGFlag=0 S PackVolume=1
  ..;I BGFlag=1,$L(ProductGroup) S BloodProduct=ProductGroup  ;血成份统计
  ..S ^TMPBGll("1",total)=$lb(BloodProduct,BloodGroup)
  ..I '$D(^TMP($zn,$j,"TotalOut",BloodProduct,OutType)) D
  ...S ^TMP($zn,$j,"TotalOut",BloodProduct,OutType)=bldSumNum_"^"_PackVolume
  ..E  D
  ...S bldSumNum=$P(^TMP($zn,$j,"TotalOut",BloodProduct,OutType),"^",1)+1
  ...S PackVolume=$P(^TMP($zn,$j,"TotalOut",BloodProduct,OutType),"^",2)+PackVolume
  ...S ^TMP($zn,$j,"TotalOut",BloodProduct,OutType)=bldSumNum_"^"_PackVolume
  k PLIST
  S k=0
  //S bldProductDesc="血制品/血成分",TRANOutType="过期处理",TRAN1OutType="直接发血",TRAN2OutType="出库操作"
  //S TRAN3OutType="正常发血",TRAN4OutType="非消耗出库",TRAN5OutType="院区血袋转出",TRAN6OutType="退回血站",QTOutType="其他"
  //S OPutbldSumNum="",OPutbldSumVol=""
  //S (Field1,Field2,Field3,Field4,Field5)=""
  //S Field5=HospitalDesc
  //S Data=$lb(bldProductDesc,TRANOutType,TRAN1OutType,TRAN2OutType,TRAN3OutType,TRAN4OutType,TRAN5OutType,TRAN6OutType,QTOutType,OPutbldSumNum,OPutbldSumVol,Field1,Field2,Field3,Field4,Field5)
  //D Output
  b ;11
  S bp="" F  S bp=$O(^TMP($zn,$j,"TotalOut",bp)) Q:bp=""  D
  .I $D(^TTAB("BB-BP",bp)) S bldProductDesc=$P(^TTAB("BB-BP",bp),"\",1)
  .;I BGFlag=1,$D(^TTAB("BB-PG",bp)) S bldProductDesc=$G(^TTAB("BB-PG",bp))
  .S (bldSumNum,bldGrpDesc,OPutbldSumNum,OPutbldSumVol,TRANOutType,TRAN1OutType,TRAN2OutType,TRAN3OutType,TRAN4OutType,TRAN5OutType,TRAN6OutType,QTOutType)=""
  .S OutType="" F  S OutType=$O(^TMP($zn,$j,"TotalOut",bp,OutType)) Q:OutType=""  D
  ..S bldSumNum=$P($G(^TMP($zn,$j,"TotalOut",bp,OutType)),"^",1)
  ..I BGFlag=1 S bldSumNum=$P($G(^TMP($zn,$j,"TotalOut",bp,OutType)),"^",2)
  ..I OutType="TRANS" D
  ...S TRANOutType=bldSumNum
  ..E  I OutType="TRANS1" D
  ...S TRAN1OutType=bldSumNum
  ..E  I OutType="TRANS2" D
  ...S TRAN2OutType=bldSumNum
  ..E  I OutType="TRANS3" D
  ...S TRAN3OutType=bldSumNum
  ..E  I OutType="TRANS4" D
  ...S TRAN4OutType=bldSumNum
  ..E  I OutType="TRANS5" D
  ...S TRAN5OutType=bldSumNum
  ..E  I OutType="TRANS6" D
  ...S TRAN6OutType=bldSumNum
  ..E  D
  ...S QTOutType=bldSumNum
  ..S OPutbldSumNum=OPutbldSumNum+bldSumNum
  ..s bldSumVol=$P($G(^TMP($zn,$j,"TotalOut",bp,OutType)),"^",2)
  ..S OPutbldSumVol=OPutbldSumVol+bldSumVol
  .S (Field1,Field2,Field3,Field4,Field5)=""
  .S Field5=HospitalDesc
  .;S Field1=bp
  .S Data=$lb(bldProductDesc,TRANOutType,TRAN1OutType,TRAN2OutType,TRAN3OutType,TRAN4OutType,TRAN5OutType,TRAN6OutType,QTOutType,OPutbldSumNum,OPutbldSumVol,Field1,Field2,Field3,Field4,Field5)
  .D Output
  K ^TMP($zn,$j,"TotalOut"),^TMP($zn,$j,"Out")
  S qHandle=$lb(0,repid,0)
  Q $$$OK
 
Output
    S Data=$lb(bldProductDesc,TRANOutType,TRAN1OutType,TRAN2OutType,TRAN3OutType,TRAN4OutType,TRAN5OutType,TRAN6OutType,QTOutType,OPutbldSumNum,OPutbldSumVol,Field1,Field2,Field3,Field4,Field5)
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
Query QuerySampleStatistics(DateS As %String, DateE As %String, SupplierId As %String, ProductCode As %String, GroupCode As %String, productGroupCode As %String, HospitalCode As %String, BGFlag As %String, TransType As %String, USERCODE As %String) As %Query(ROWSPEC = "bldProductDesc:%String,TRANOutType:%String,TRAN1OutType:%String,TRAN2OutType:%String,TRAN3OutType:%String,TRAN4OutType:%String,TRAN5OutType:%String,TRAN6OutType:%String,QTOutType:%String,OPutbldSumNum:%String,OPutbldSumVol:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatOutTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatOutTypeD</DataLocation>
<DefaultData>DHCBldStatOutTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatOutTypeD</IdLocation>
<IndexLocation>^web.DHCBldStatOutTypeI</IndexLocation>
<StreamLocation>^web.DHCBldStatOutTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
