Class web.DHCBldAppFromStat Extends %Persistent
{

Parameter BUILD = 60;

ClassMethod QueryAppFormClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppFormExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
	Q $$$OK
}

/// Creator：     mcr
/// CreatDate：    20141203
/// Description:： 申请用血统计(科室（医师）、申请单数量、全血的申请量、红细胞申请量、血浆的申请量、血小板的申请量、自体血的申请量)
/// Table：        
/// Input：        DateS:起始日期,DateE:结束日期，DepCode：检验科科室代码,MachCode仪器代码为空全部检索，MachTG：仪器组代码为空全部检索，CliCode：医生申请科室代码为空全部检索，DocCode:医生工号为空全部检索，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       Debtor:登记号,PatName：病人姓名,SpeName：性别,PatAge：年龄,CliDepName：申请科室,Labno：检验号,TestName：医嘱名称,ColectDateTime:采集时间,RecevieDateTime:接收时间,AuthorDateTime:审核时间
/// Return：       无
/// Others：	                                                                                                                          (Code,Desc,TotalNum,RBC,FFP,PLT,CRYO,Field1,Field2,Field3,Field4,Field5)																																
Query QueryAppForm(DateS As %String, DateE As %String, CTLoc As %String, TansFormType As %String, HospitalCode As %String, TransDate As %String, Flag As %String, ABORH As %String, ProductGroup As %String, AppFormStatus As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String,TotalNum:%String,RBC:%String,FFP:%String,PLT:%String,CRYO:%String,WB:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

/// Query的执行方法
///   #Ibm3850@sjbb
/// D ##class(%ResultSet).RunQuery("web.DHCBldAppFromStat","QueryAppForm","2015-03-22 15:42:43","2015-03-23 15:42:43","","","","1","1","","","")
ClassMethod QueryAppFormExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, CTLoc As %String, TansFormType As %String, HospitalCode As %String, TransDate As %String, Flag As %String, ABORH As %String, ProductGroup As %String, AppFormStatus As %String) As %Status
{
	S repid=$I(^CacheTemp)
	I $G(ind)="" S ind=1
	S DateS=$G(DateS),DateE=$G(DateE),CTLoc=$G(CTLoc),TansFormType=$G(TansFormType),HospitalCode=$G(HospitalCode)
	S Flag=$G(Flag),TransDate=$G(TransDate),ABO=$G(ABO),RH=$G(RH)
	S ^TMPmcr("QuerForm")=$lb(DateS,DateE,CTLoc,TansFormType,HospitalCode,TransDate,Flag,ABORH,ProductGroup,AppFormStatus)
	I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
    I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
    I ABORH="APOS" S ABO="A型",RH="阳性"
    I ABORH="BPOS" S ABO="B型",RH="阳性"
    I ABORH="ABPOS" S ABO="AB型",RH="阳性"
    I ABORH="OPOS" S ABO="O型",RH="阳性"
    I ABORH="ANEG" S ABO="A型",RH="阴性"
    I ABORH="BNEG" S ABO="B型",RH="阴性"
    I ABORH="ABNEG" S ABO="AB型",RH="阴性"
    I ABORH="ONEG" S ABO="O型",RH="阴性"
    I ABORH="A" S ABO="A型",RH=""
    I ABORH="B" S ABO="A型",RH=""
    I ABORH="AB" S ABO="A型",RH=""
    I ABORH="O" S ABO="A型",RH=""
    I ABORH="null" S ABO="",RH=""
    I ABORH="DC" S ABO="DC",RH="DC"
    I ProductGroup="null" S ProductGroup=""
    I AppFormStatus="null" S AppFormStatus=""
    I CTLoc="null" S CTLoc=""
    S TimeS=""
    S TimeE=""
    S AppFormDesc=""
    I AppFormStatus="R" S AppFormStatus="",AppFormDesc="已接收"
	S Deli=$C(2)
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
	S tBPGList="",vbTab=$C(9)
	//S:'$L(HospitalCode) HospitalCode="QYFYZY"
    S:'$L(Flag) Flag=1
	S (labdata,meddata)=""
	I TransDate=2 {
		    D QueryAppFormByTransDate
	}ELSEIF$L(DateS),$L(DateE){
			D QueryAppFormByDate 
	}
	S Code="" F  S Code=$O(^TMP($ZN,$J,Code))  Q:Code=""  D
	.S Desc="" F  S Desc=$O(^TMP($ZN,$J,Code,Desc))  Q:Desc=""  D
	..S TotalNum=0
	..S ProGrp="" F  S ProGrp=$O(^TMP($ZN,$J,Code,Desc,ProGrp))  Q:ProGrp=""  D
	...S Vol=0
	...I $L(ProductGroup),ProductGroup'=ProGrp Q
	...S num="" F  S num=$O(^TMP($ZN,$J,Code,Desc,ProGrp,num))  Q:num=""  D
	....S TotalNum=TotalNum+1
	....S Vol=Vol+$G(^TMP($ZN,$J,Code,Desc,ProGrp,num))
	...S tBPGList=tBPGList_","_ProGrp_"\"_Vol
    ..S tBPGList=##Class(web.DHCBldAppFromStat).BuildOutPutSeq(tBPGList)
    ..//W Desc,TotalNum,!
  	..S RBC=$P(tBPGList,vbTab,1)
  	..S FFP=$P(tBPGList,vbTab,2)
  	..S PLT=$P(tBPGList,vbTab,3)
  	..S CRYO=$P(tBPGList,vbTab,4)
  	..S WB=$P(tBPGList,vbTab,5)
    ..S (Field1,Field2,Field3,Field4,Field5,tBPGList)=""
    ..S Data=$lb(Code,Desc,TotalNum,RBC,FFP,PLT,CRYO,WB,Field1,Field2,Field3,Field4,Field5)
    ..D Output  
    K ^TMP($ZN,$J)
    S qHandle=$lb(0,repid,0)
    Q $$$OK 

QueryAppFormByTransDate
    S isQuit=0,index=0
    S curDate=$O(^DHCBLDAPPFORMi(0,"TRANSDATE",DateS),-1)
    F  S curDate=$O(^DHCBLDAPPFORMi(0,"TRANSDATE",curDate)) Q:('$L(curDate))!(isQuit=1)  D
    .Q:curDate<DateS
    .S:DateE<curDate isQuit=1
    .Q:isQuit=1
    .S curAppFormID=""
    .F  S curAppFormID=$O(^DHCBLDAPPFORMi(0,"TRANSDATE",curDate,curAppFormID)) Q:'$L(curAppFormID)  D
    ..Q:'$D(^DHCBLDAPPFORM(curAppFormID,"F"))
    ..S ReserveTime=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",6)
    ..I (curDate=DateS),ReserveTime<TimeS Q
    ..I (curDate=DateE),ReserveTime>TimeE Q
    ..S curFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",2)
    ..S curTansFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",4)
    ..S curFormStatus=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",3)
    ..I $L(AppFormStatus),AppFormStatus'=curFormStatus Q
    ..Q:$L(TansFormType)&(curTansFormType'=TansFormType)
    ..S appInfo=##Class(web.DHCBldAppFromStat).GetAppFormInfo(curAppFormID,labdata,meddata,CTLoc,HospitalCode,TansFormType,Flag,ABO,RH,AppFormDesc)
    ..Q:$L(appInfo,$c(2))<4
    ..S (AppFormID,CTLocCode,CTLocDesc,ProductGroop,volume)=""
    ..S AppFormID=$P(appInfo,$C(2),1)
    ..S CTLocCode=$P(appInfo,$C(2),2)
    ..S CTLocDesc=$P(appInfo,$C(2),3)
    ..S ProductGroop=$P(appInfo,$C(2),4)
    ..S volume=$P(appInfo,$C(2),5)
    ..I '$D(^TMP($ZN,$J,CTLocCode,CTLocDesc,ProductGroop,index))  D
    ...S ^TMP($ZN,$J,CTLocCode,CTLocDesc,ProductGroop,index)=+volume
    ...S index=index+1
    ..E  D 
    ...S ^TMP($ZN,$J,CTLocCode,CTLocDesc,ProductGroop,index)=+$G(^TMP($ZN,$J,CTLocCode,CTLocDesc,ProductGroop,index))+volume
    ...S index=index+1
    Q 
QueryAppFormByDate
    S isQuit=0,index=1
    S curAppFormID=$O(^DHCBLDAPPFORM(stAppFormIDPre),-1)
    F  S curAppFormID=$O(^DHCBLDAPPFORM(curAppFormID)) Q:('$L(curAppFormID))!(isQuit=1)  D
    .Q:$E(curAppFormID,1,8)'?8N
    .S curDate=$ZDH($E(curAppFormID,1,4)_"-"_$E(curAppFormID,5,6)_"-"_$E(curAppFormID,7,8),3)
    .//B ;001
    .Q:curDate<DateS
    .S:DateE<curDate isQuit=1
    .Q:isQuit=1
    .Q:'$D(^DHCBLDAPPFORM(curAppFormID,"F"))
    .Q:'$D(^DHCBLDAPPFORM(curAppFormID,"OPERATION",1,"SA"))
    .S UserCode=$O(^DHCBLDAPPFORM(curAppFormID,"OPERATION",1,"SA",""))
    .S ReqTime=$P($G(^DHCBLDAPPFORM(curAppFormID,"OPERATION",1,"SA",UserCode)),"\",5)
    .I (curDate=DateS),ReqTime<TimeS Q
    .I (curDate=DateE),ReqTime>TimeE Q
    .S curFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",2)
    .S curTansFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",4)
    .S curFormStatus=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",3)
    .I $L(AppFormStatus),AppFormStatus'=curFormStatus Q
    .Q:$L(TansFormType)&(curTansFormType'=TansFormType)
    .S appInfo=##Class(web.DHCBldAppFromStat).GetAppFormInfo(curAppFormID,labdata,meddata,CTLoc,HospitalCode,TansFormType,Flag,ABO,RH,AppFormDesc)
    .//W appInfo,!
    .Q:$L(appInfo,$c(2))<4
    .S (AppFormID,CTLocCode,CTLocDesc,ProductGroop,volume)=""
    .S AppFormID=$P(appInfo,$C(2),1)
    .S CTLocCode=$P(appInfo,$C(2),2)
    .S CTLocDesc=$P(appInfo,$C(2),3)
    .S ProductGroop=$P(appInfo,$C(2),4)
    .S volume=$P(appInfo,$C(2),5)
    .I '$D(^TMP($ZN,$J,CTLocCode,CTLocDesc,ProductGroop,index))  D
    ..S ^TMP($ZN,$J,CTLocCode,CTLocDesc,ProductGroop,index)=+volume
    ..S index=index+1
    .E  D 
    ..S ^TMP($ZN,$J,CTLocCode,CTLocDesc,ProductGroop,index)=+$G(^TMP($ZN,$J,CTLocCode,CTLocDesc,ProductGroop,index))+volume
    ..S index=index+1
    Q 
    
Output
	S Data=$lb(Code,Desc,TotalNum,RBC,FFP,PLT,CRYO,WB,Field1,Field2,Field3,Field4,Field5)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod QueryAppFormFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppFormExecute ]
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

///   W ##Class(web.DHCBldAppFromStat).GetAppFormInfo("20141203001","","")
ClassMethod GetAppFormInfo(appFormID As %String, labdata = "", meddata = "", CTLoc, HospitalCode, TansFormType, Flag, ABO, RH, AppFormDesc) As %String
{
    S appFormID=$G(appFormID),labdata=$G(labdata),CTLoc=$G(CTLoc),HospitalCode=$G(HospitalCode),TansFormType=$G(TansFormType)
    S ABO=$G(ABO),RH=$G(RH)
    S Flag=$G(Flag)
    S ret="",deli=$C(2)
    Q:'$L(appFormID) ret
    Q:'$D(^DHCBLDAPPFORM(appFormID)) ret
    S:'$L(labdata) labdata=##Class(LIS.Core.Util).GetLabDataNS()
    S:'$L(meddata) meddata=##Class(LIS.Core.Util).GetDataNS()
    ZN meddata
    S appFormBasicData=$$GetAppFormBasicInfo^DHCUtlBldAppForm(appFormID)
    S patBasicData=$$GetPatInfo^DHCUtlBldAppFormCore(appFormID,"")
    S ordersData=$$GetAllOrders^DHCUtlBldAppForm(appFormID,"","")
    ZN "DHC-APP"
    S patRegNo=$P(patBasicData,deli,1)
    S patSex=$P(patBasicData,deli,5)
    S patName=$P(patBasicData,deli,6)
    S patBed=$P(patBasicData,deli,8)
    S patAge=$P(patBasicData,deli,10)
    S patWardDesc=$P(patBasicData,deli,11)
    S patTypeDesc=$P(patBasicData,deli,18)
    S patDiagnos=$P(patBasicData,deli,21)
    S lstSaveUserCode=$P(appFormBasicData,deli,19)
    S lstSaveUserDesc=$P(appFormBasicData,deli,20)
    S patMedicare=$P(patBasicData,deli,35)
    S appFormID=$P(appFormBasicData,deli,1)
    S AppABORequest=$P(patBasicData,deli,32)
    S AppRHRequest=$P(patBasicData,deli,33)
    I $L(ABO),ABO'="DC",$L(AppABORequest),AppABORequest'=ABO Q ret
    I $L(RH),RH'="DC",$L(AppRHRequest),AppRHRequest'[RH Q ret
    I ABO="DC",AppABORequest'="待测" Q ret
    S curTansFormType=$P($G(^DHCBLDAPPFORM(appFormID,"F")),"\",4)
    I $L(TansFormType),$L(curTansFormType)&(curTansFormType'=TansFormType) Q ret
    S patLocDr=$P(patBasicData,deli,24)  ;得到开医嘱的登陆科室
    s CurHospitalCode="",HospID=""
    S patLocCode=$P(^CTLOC(patLocDr),"^",1)
    I $L(CTLoc),$L(patLocCode),patLocCode'=CTLoc Q ret
    I $L(patLocDr) S HospID=$P(^CTLOC(patLocDr),"^",22)
    I $L(HospID) S CurHospitalCode=$p(^CT("HOSP",HospID),"^",1)
    I $L(HospitalCode),$L(CurHospitalCode),CurHospitalCode'=HospitalCode Q ret
	S CTLocDesc=$P(^CTLOC(patLocDr),"^",2)
	S fieldDeli=$C(3),recordDeli=$C(2)
    S bldBankProc="",proGrpDesc=""
    S (ordersDesc,ordersVolume,ordersUnit,labno,labRowIDs)=""
    b ;1
    F i=1:1:$L(ordersData,recordDeli) {
	    S order=$P(ordersData,recordDeli,i)
	    Continue:'$L(order)
	    S OeordRowId=$P(order,fieldDeli,1)
	    S labRowID=..GetOrderLabRowID(OeordRowId)
	    S:$L(labRowID) labRowIDs=labRowIDs_labRowID_","
	    S orderDesc=$P(order,fieldDeli,2)
	    Continue:orderDesc["血型复"
	    Continue:orderDesc["血型鉴定"
	    S:orderDesc["红细胞" proGrpDesc="RC"
        S:orderDesc["血小板" proGrpDesc="PLT"
    	S:orderDesc["血浆" proGrpDesc="FFP"
    	S:orderDesc["冷沉淀" proGrpDesc="CRYO"
    	S:orderDesc["全血" proGrpDesc="WB"
	    S volume=+$P(order,fieldDeli,6)
	    S ordersVolume=ordersVolume+volume
	}
	b ;2
	I $L(AppFormDesc),'$L(labRowIDs) Q ret
	Q:'$L(proGrpDesc) ret
	I Flag="1"  D
	.S ret=appFormID_recordDeli_patLocDr_recordDeli_CTLocDesc_recordDeli_proGrpDesc_recordDeli_volume
	E  D
	.S ret=appFormID_recordDeli_lstSaveUserCode_recordDeli_lstSaveUserDesc_recordDeli_proGrpDesc_recordDeli_volume
	Q ret
}

ClassMethod GetOrderLabRowID(orderRowID As %String) As %String
{
    S orderRowID=$G(orderRowID),deli="||"
    S:orderRowID["-" deli="-"
    S orderID=$P(orderRowID,"-",1)
    S orderSubID=$P(orderRowID,"-",2)
    S ret=""
    Q:'$L(orderID) ret
    Q:'$L(orderSubID) ret
    S data3=$G(^OEORD(orderID,"I",orderSubID,3))
    Q:'$L(data3) ret
    S ret=$P(data3,"^",35) 
    Q ret
}

Storage Default
{
<Data name="DHCBldAppFromStatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldAppFromStatD</DataLocation>
<DefaultData>DHCBldAppFromStatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldAppFromStatD</IdLocation>
<IndexLocation>^web.DHCBldAppFromStatI</IndexLocation>
<StreamLocation>^web.DHCBldAppFromStatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
