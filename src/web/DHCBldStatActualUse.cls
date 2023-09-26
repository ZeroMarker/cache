Class web.DHCBldStatActualUse Extends %Persistent
{

Parameter BUILD = 60;

ClassMethod QueryBloodUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBloodUseExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
	Q $$$OK
}

/// Creator：     mcr
/// CreatDate：    20141203
/// Description:：实际用血统计：根据用血时间段(**)、科室、病区、医师、病人类型、医院来统计出科室（医师）、申请单数、全血、红细胞、血浆、血小板、自体血的用血量。并且也可以根据用血时间段、科室、医师来显示 各个科室或是每个医师的用血量（用柱图、折线图、叠加柱图、曲线图来显示）。
/// Table：        
/// Input：        DateS:起始日期,DateE:结束日期，DepCode：检验科科室代码,MachCode仪器代码为空全部检索，MachTG：仪器组代码为空全部检索，CliCode：医生申请科室代码为空全部检索，DocCode:医生工号为空全部检索，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       Debtor:登记号,PatName：病人姓名,SpeName：性别,PatAge：年龄,CliDepName：申请科室,Labno：检验号,TestName：医嘱名称,ColectDateTime:采集时间,RecevieDateTime:接收时间,AuthorDateTime:审核时间
/// Return：       无
/// Others：	                                                                                                                        
Query QueryBloodUse(DateS As %String, starttime As %String, DateE As %String, endtime As %String, CTLoc As %String, SupId As %String, PatType As %String, HospitalCode As %String, Flag As %String) As %Query(ROWSPEC = "Code:%String,TotalNum:%String,RBC:%String,FFP:%String,PLT:%String,CRYO:%String,WB:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

///   #Ibm3850@sjbb
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatActualUse","QueryBloodUse","2015-03-01 11:01:03","","2015-03-17 11:01:03","","","","","","1")
ClassMethod QueryBloodUseExecute(ByRef qHandle As %Binary, DateS As %String, starttime As %String, DateE As %String, endtime As %String, CTLoc As %String, SupId As %String, PatType As %String, HospitalCode As %String, Flag As %String) As %Status
{
	S repid=$I(^CacheTemp)
	I $G(ind)="" S ind=1
	S DateS=$G(DateS),starttime=$G(starttime),DateE=$G(DateE),endtime=$G(endtime),CTLoc=$G(CTLoc),SupId=$G(SupId),HospitalCode=$G(HospitalCode)
	S PatType=$G(PatType),Flag=$G(Flag)
	I CTLoc="null" S CTLoc=""
	S ^TMPmcr("QueryBloodUse")=$lb(DateS,starttime,DateE,endtime,CTLoc,SupId,PatType,HospitalCode,Flag)
	S Deli=$C(2)
	K ^TMP($ZN,$J)
    I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
    I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
	I $L(DateS," ")=2 S starttime=$P(DateS," ",2),DateS=$P(DateS," ",1)
	I $L(DateE," ")=2 S endtime=$P(DateE," ",2),DateE=$P(DateE," ",1)
	S:$L(DateS) DateS=$ZDH(DateS,3)
	S:$L(DateE) DateE=$ZDH(DateE,3)
	I $L(starttime) S starttime=$ZTH(starttime,3)
    I $L(endtime) S endtime=$ZTH(endtime,3) 
    S labdata=##Class(LIS.Core.Util).GetLabDataNS()
    S meddata=##Class(LIS.Core.Util).GetDataNS()
    //S:'$L(HospitalCode) HospitalCode=$O(^TTABi("CC",1,""))
    S:'$L(Flag) Flag=1
	S tBPGList="",vbTab=$C(9)
	I $L(DateS),$L(DateE){
			D QueryByDepartment
	}
	S Code="" F  S Code=$O(^TMP($ZN,$J,"Dep",Code))  Q:Code=""  D
	.S (TotalNum,Vol)=""
	.S ProGrp="" F  S ProGrp=$O(^TMP($ZN,$J,"Dep",Code,ProGrp))  Q:ProGrp=""  D
	..;S TotalNum=TotalNum+1
	..S Vol=$G(^TMP($ZN,$J,"Dep",Code,ProGrp))
	..S tBPGList=tBPGList_","_ProGrp_"\"_Vol
	..//b ;1
    .S tBPGList=##Class(web.DHCBldStatActualUse).BuildOutPutSeq(tBPGList)
  	.S RBC=$P(tBPGList,vbTab,1)
  	.S FFP=$P(tBPGList,vbTab,2)
  	.S PLT=$P(tBPGList,vbTab,3)
  	.S CRYO=$P(tBPGList,vbTab,4)
  	.S WB=$P(tBPGList,vbTab,5)
  	.;B ;002
    .S (Field1,Field2,Field3,Field4,Field5,tBPGList)=""
    .S Data=$lb(Code,TotalNum,RBC,FFP,PLT,CRYO,WB,Field1,Field2,Field3,Field4,Field5)
    .D Output  
    
    K ^TMP($ZN,$J)
    S qHandle=$lb(0,repid,0)
    Q $$$OK 
    
QueryByDepartment
  S row=0,PackNumber=0
  F kk=DateS:1:DateE D
  .S dd1=""  F  S dd1=$o(^TBBPi("TR-DateTime",kk,dd1))  Q:dd1=""  D
  ..I (kk=DateS)&(dd1<starttime) Q
  ..I (kk=DateE)&(dd1>endtime) Q
  ..S PackID=""  F  S PackID=$o(^TBBPi("TR-DateTime",kk,dd1,PackID))  Q:PackID=""  D
  ...S SecondId=""  F  S SecondId=$o(^TBBPi("TR-DateTime",kk,dd1,PackID,SecondId))  Q:SecondId=""  D
  ....;-----多医院-------->
  ....S BPCode=$p($g(^TBBP(PackID,SecondId)),"\",4),CurHospitalCode=""
  ....I $l(BPCode) S CurHospitalCode=$p(^TTAB("BB-BP",BPCode),"\",11)
  ....I $l(HospitalCode),$l(CurHospitalCode),CurHospitalCode'=HospitalCode Quit
  ....I $l(HospitalCode),'$l(CurHospitalCode),'$D(^TTABi("CC",1,HospitalCode)) Quit
  ....;------------------<
  ....S Sequence=""  F  S Sequence=$o(^TBBPi("TR-DateTime",kk,dd1,PackID,SecondId,Sequence))  Q:Sequence=""  D
  .....I $D(^TMP($ZN,$J,PackID,SecondId))'=0 D
  ......S zz=^TMP($ZN,$J,PackID,SecondId)
  ......I Sequence>zz S ^TMP($ZN,$J,PackID,SecondId)=Sequence
  .....E  D
  ......S ^TMP($ZN,$J,PackID,SecondId)=Sequence
  S Num=0
  S PackID=""  F  S PackID=$o(^TMP($ZN,$J,PackID))  Q:PackID=""  D
  .S SecondId=""  F  S SecondId=$o(^TMP($ZN,$J,PackID,SecondId))  Q:SecondId=""  D
  ..;删除的血袋处理
  ..I '$D(^TBBP(PackID,SecondId)) Q
  ..I ($D(^Dhcbbpackprice(PackID,SecondId))),($P(^Dhcbbpackprice(PackID,SecondId),"\",6)="Y") Q  
  ..S Sequence=^TMP($ZN,$J,PackID,SecondId)
  ..S sStock=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",8)
  ..S StockCode=$P(^TTAB("BB-ST",sStock),"\",2)
  ..I StockCode'="OUT" Q
  ..I StockCode'="OUT" Q
  ..S BloodProduct=$P(^TBBP(PackID,SecondId),"\",4)
  ..I $D(^TTAB("BB-BP",BloodProduct)) S ProductGroop=$P(^TTAB("BB-BP",BloodProduct),"\",21)
  ..S BloodProductName=""
  ..S:$D(^TTAB("BB-BP",BloodProduct)) BloodProductName=$P(^TTAB("BB-BP",BloodProduct),"\",1)
  ..S BloodGroup=$P(^TBBP(PackID,SecondId),"\",5)
  ..S PackVolume=$P(^TBBP(PackID,SecondId),"\",21) 
  ..S SupCode=$P(^TBBP(PackID,SecondId),"\",12)
  ..I SupId'="",SupId'=SupCode Q
  ..S InputPrice=0
  ..S:$D(^Dhcbbpackprice(PackID,SecondId)) InputPrice=$P(^Dhcbbpackprice(PackID,SecondId),"\",1)
  ..S add=""
  ..///增加接收血袋科室统计(转科)20120209 huhm
  ..S TSRowId=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",7)
  ..I '$L(TSRowId) Q
  ..S VisitNumber=$P(TSRowId,"||",1)
  ..S TestSet=$P(TSRowId,"||",2)
  ..S TestSetCnt=$P(TSRowId,"||",3)
  ..I '$D(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP",PackID,SecondId)) Q
  ..S Transfusion=$P(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP",PackID,SecondId),"\",3)
  ..I Transfusion'="T" Q
  ..S VisitNumber=$P(TSRowId,"||",1)
  ..S PackTrans=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)
  ..Q:PackTrans'="TRANS3"
  ..Q:PackTrans="TRANS5"
  ..Q:PackTrans="RTS"
  ..ZN labdata
  ..S add=$$GetPackToLoc^DHCBldCommon(TSRowId,PackID,SecondId)
  ..ZN "DHC-APP"
  ..I '$l(add) D
  ...S ep=$P(TSRowId,"||",1)
  ...I ep'="" D
  ....S add=$p(^TEPI(ep),"\",36)
  ....I $l(add) S add=$p(^TTAB("USLOC",add),"\",1)
  ....I add["-" S add=$p(add,"-",2)
  ...E  D
  ....S add=""
  ...I add="" D
  ....S sTrans=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)
  ....S add="未知科室-"_$p(^TTAB("BB-TR",sTrans),"\",1)
  ..;q:add'["保健科"
  ..;w add,ProductGroop,PackVolume,!
  ..I Flag="1" 
  ...S add=add
  ..E  D
  ...S add=$p(^TEPI($P(TSRowId,"||",1)),"\",13)
  ...I $L(add),$d(^TTAB("DR",add)) S add=$p($p(^TTAB("DR",add),"\",1),"(")
  ..I add["东区急诊内科急诊" W PackID,SecondId,!
  ..I '$D(^TMP($ZN,$J,"Dep",add,ProductGroop)) D
  ...S ^TMP($ZN,$J,"Dep",add,ProductGroop)=PackVolume
  ..E  D
  ...S ^TMP($ZN,$J,"Dep",add,ProductGroop)=+$G(^TMP($ZN,$J,"Dep",add,ProductGroop))+PackVolume
  ..S Num=Num+1
  ..S ^TMP("xq3",Num)=$lb(PackTrans,Transfusion,PackID,SecondId,PackVolume)
  Q 

Output
	S Data=$lb(Code,TotalNum,RBC,FFP,PLT,CRYO,WB,Field1,Field2,Field3,Field4,Field5)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod QueryBloodUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBloodUseExecute ]
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

ClassMethod BuildOutPutSeq(tBPGList As %String) As %String
{
	S tBPGList=$G(tBPGList)
	S res="",vbTab=$c(9),Vol=""
    /*
    I tBPGList["WB" D
	.F i=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",i)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="WB"
	..S res=$P(temRes,"\",2)_vbTab
	E  D
	.S res=Vol_vbTab
	*/
	I tBPGList["RC" D
	.F i=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",i)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="RC"
	..S res=$P(temRes,"\",2)_vbTab
	E  D
	.S res=Vol_vbTab

	I tBPGList["FFP" D
	.F j=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",j)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="FFP"
	..S res=res_$P(temRes,"\",2)_vbTab
	E  D
	.S res=res_Vol_vbTab

	I tBPGList["PLT" D
	.F k=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",k)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="PLT"
	..S res=res_$P(temRes,"\",2)_vbTab
	E  D
	.S res=res_Vol_vbTab
	I tBPGList["CRYO" D
	.F l=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",l)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="CRYO"
	..S res=res_$P(temRes,"\",2)_vbTab
	E  D
	.S res=res_Vol_vbTab
    I tBPGList["WB" D
	.F l=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",l)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="WB"
	..S res=res_$P(temRes,"\",2)_vbTab
	E  D
	.S res=res_Vol_vbTab
	Q res
}

ClassMethod BuildOutPutQSeq(TSRowId As %String) As %String
{
}

Storage Default
{
<Data name="DHCBldStatActualUseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatActualUseD</DataLocation>
<DefaultData>DHCBldStatActualUseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatActualUseD</IdLocation>
<IndexLocation>^web.DHCBldStatActualUseI</IndexLocation>
<StreamLocation>^web.DHCBldStatActualUseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
