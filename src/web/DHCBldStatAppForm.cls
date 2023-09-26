Class web.DHCBldStatAppForm Extends %Persistent
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
Query QueryBloodUse(DateS As %String, starttime As %String, DateE As %String, endtime As %String, CTLoc As %String, SupId As %String, PatType As %String, HospitalCode As %String, Flag As %String) As %Query(ROWSPEC = "Code:%String,CTLocDesc:%String,TotalNum:%String,RBC:%String,FFP:%String,PLT:%String,CRYO:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

///   #Ibm3850@sjbb
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatAppForm","QueryBloodUse","2015-02-01 09:03:02","","2015-03-17 09:03:02","","","","","","1")
ClassMethod QueryBloodUseExecute(ByRef qHandle As %Binary, DateS As %String, starttime As %String, DateE As %String, endtime As %String, CTLoc As %String, SupId As %String, PatType As %String, HospitalCode As %String, Flag As %String) As %Status
{
	S repid=$I(^CacheTemp)
	I $G(ind)="" S ind=1
	S DateS=$G(DateS),starttime=$G(starttime),DateE=$G(DateE),endtime=$G(endtime),CTLoc=$G(CTLoc),SupId=$G(SupId),HospitalCode=$G(HospitalCode)
	S PatType=$G(PatType),Flag=$G(Flag)
	I CTLoc="null" S CTLoc=""
	S FileName="DHCBldStatBloodUse"
	S ^TMPmcr("QueryBloodUse")=$lb(DateS,starttime,DateE,endtime,CTLoc,SupId,PatType,HospitalCode,Flag)
	S Deli=$C(2)
	//b ;12
	K ^TMP($ZN,$J),^TMP(FileName,$J)
    I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
    I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
	I $L(DateS," ")=2 S starttime=$P(DateS," ",2),DateS=$P(DateS," ",1)
	I $L(DateE," ")=2 S endtime=$P(DateE," ",2),DateE=$P(DateE," ",1)
	I $L(starttime) S starttime=$ZTH(starttime,3)
    I $L(endtime) S endtime=$ZTH(endtime,3) 
    S labdata=##Class(LIS.Core.Util).GetLabDataNS()
    S meddata=##Class(LIS.Core.Util).GetDataNS()
    //S:'$L(HospitalCode) HospitalCode="QYFYZY"
    S:'$L(Flag) Flag=1
	S tBPGList="",vbTab=$C(9)
	S TimeS=""
    S TimeE=""
	I $L(DateS," ")=2 S TimeS=$P(DateS," ",2),DateS=$P(DateS," ",1)
	I $L(DateE," ")=2 S TimeE=$P(DateE," ",2),DateE=$P(DateE," ",1)
	I $L(TimeS) S TimeS=$ZTH(TimeS,1)
	I $L(TimeE) S TimeE=$ZTH(TimeE,1)
	I DateS?4N1"-"1.2N1"-"1.2N D
	.S DateS=$ZDH(DateS,3)
	E  S DateS=+H
	I DateE?4N1"-"1.2N1"-"1.2N D
	.S DateE=$ZDH(DateE,3)
    E  S DateE=+$H
 	S stAppFormIDPre=$TR($ZD(DateS,3),"-")_"000"
	S endAppFormIDPre=$TR($ZD(DateE,3),"-")_"000"
	I $L(DateS),$L(DateE){
			D QueryAppFormByDate
	}
	S Code="" F  S Code=$O(^TMP(FileName,$J,"Dep","AllReq",Code))  Q:Code=""  D
	.S (TotalNum,Num)=0,Vol=""
	.S ProGrp="" F  S ProGrp=$O(^TMP(FileName,$J,"Dep","AllReq",Code,ProGrp))  Q:ProGrp=""  D
	..;S TotalNum=TotalNum+1
	..S Vol=$G(^TMP(FileName,$J,"Dep","AllReq",Code,ProGrp))
	..S tBPGList=tBPGList_","_ProGrp_"\"_Vol
	..S Num=$$GetReqAppFormNum(Code,ProGrp)
	..S TotalNum=TotalNum+Num
    .S tBPGList=##Class(web.DHCBldStatActualUse).BuildOutPutSeq(tBPGList)
  	.S RBC=$P(tBPGList,vbTab,1)
  	.S FFP=$P(tBPGList,vbTab,2)
  	.S PLT=$P(tBPGList,vbTab,3)
  	.S CRYO=$P(tBPGList,vbTab,4)
  	.;B ;002
    .S (Field1,Field2,Field3,Field4,Field5,tBPGList)=""
    .//I '$L(TotalNum) S TotalNum=0
    .S CTLocDesc=$P(^CTLOC(Code),"^",2)
    .I $L(CTLocDesc,"-")=2 S CTLocDesc=$P(CTLocDesc,"-",2)
    .S Data=$lb(Code,CTLocDesc,TotalNum,RBC,FFP,PLT,CRYO,Field1,Field2,Field3,Field4,Field5)
    .D Output  
    
    K ^TMP($ZN,$J)
    S qHandle=$lb(0,repid,0)
    Q $$$OK 
GetReqAppFormNum(Code,ProGrp)
 S AppFormID=""
 S num=0
 F  S AppFormID=$O(^TMP(FileName,$J,"Dep","AllActAppForm",Code,ProGrp,AppFormID)) Q:AppFormID=""  D
 .S num=num+1
 Q num    
QueryAppFormByDate
    
    S isQuit=0
    S curAppFormID=$O(^DHCBLDAPPFORM(stAppFormIDPre),-1)
    F  S curAppFormID=$O(^DHCBLDAPPFORM(curAppFormID)) Q:('$L(curAppFormID))!(isQuit=1)  D
    .Q:$E(curAppFormID,1,8)'?8N
    .S curDate=$ZDH($E(curAppFormID,1,4)_"-"_$E(curAppFormID,5,6)_"-"_$E(curAppFormID,7,8),3)
    .Q:curDate<DateS
    .S:DateE<curDate isQuit=1
    .Q:isQuit=1
    .Q:'$D(^DHCBLDAPPFORM(curAppFormID,"F"))
    .Q:'$D(^DHCBLDAPPFORM(curAppFormID,"OPERATION",1,"SA"))
    .Q:'$D(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH"))
    .S UserCode=$O(^DHCBLDAPPFORM(curAppFormID,"OPERATION",1,"SA",""))
    .S CheckUserCode=$O(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH",""))
    .S ReqTime=$P($G(^DHCBLDAPPFORM(curAppFormID,"OPERATION",1,"SA",UserCode)),"\",5)
    .//I (curDate=DateS),ReqTime<TimeS Q
    .//I (curDate=DateE),ReqTime>TimeE Q
    .S curFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",2)
    .S Debtor=$P(^DHCBLDAPPFORM(curAppFormID,"P"),"\",15)
    .S CTLocID=$P(^DHCBLDAPPFORM(curAppFormID,"P"),"\",22)
    .S CTLocCode=$P(^CTLOC(CTLocID),"^",1)
	.I $L(CTLoc),CTLoc'=CTLocCode Q
	.S WardID=$P(^DHCBLDAPPFORM(curAppFormID,"P"),"\",13)
    .S WardCode=$P(^PAWARD(WardID),"^",1)
    .//输血类型 例如手术输血
    .S curTansFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",4)
    .//所有类型，手术类型
    .S VolType="All"
    .//W curAppFormID,!
    .S ProductGrp=##class(web.DHCBldStatBloodUse).GetProductGrp(curAppFormID,VolType)
    .I '$L(ProductGrp) Q
    .//S ^TMP($ZN,$J,"Dep","AllDebtor",CTLocID,ProductGrp,Debtor)=""
    .//S ^TMP($ZN,$J,"Dep","AllAppForm",CTLocID,ProductGrp,curAppFormID)=""
    Q

Output
	S Data=$lb(Code,CTLocDesc,TotalNum,RBC,FFP,PLT,CRYO,Field1,Field2,Field3,Field4,Field5)
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
	Q res
}

ClassMethod BuildOutPutQSeq(TSRowId As %String) As %String
{
}

Storage Default
{
<Data name="DHCBldStatAppFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatAppFormD</DataLocation>
<DefaultData>DHCBldStatAppFormDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatAppFormD</IdLocation>
<IndexLocation>^web.DHCBldStatAppFormI</IndexLocation>
<StreamLocation>^web.DHCBldStatAppFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
