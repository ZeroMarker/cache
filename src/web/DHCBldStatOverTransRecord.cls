Class web.DHCBldStatOverTransRecord Extends %Persistent
{

Parameter BUILD = 60;

ClassMethod QueryOverTransRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOverTransRecordExecute ]
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
/// Others：	                                                                                                                         (,,,,,,,,,RBC1,RBC2,FFP1,FFP2																															
Query QueryOverTransRecord(DateS As %String, DateE As %String, CTLoc As %String, TansFormType As %String, HospitalCode As %String, ProductGroup As %String) As %Query(ROWSPEC = "patName:%String,patSex:%String,patAge:%String,patRegNo:%String,patMedicare:%String,CTLocDesc:%String,patWardDesc:%String,lstSaveUserDesc:%String,patDiagnos:%String,RBC1:%String,RBC2:%String,FFP1:%String,FFP2:%String,Field1:%String,Field2:%String,Field3:%String,Field4:%String,Field5:%String") [ SqlProc ]
{
}

/// Query的执行方法
///   #Ibm3850@sjbb
/// D ##class(%ResultSet).RunQuery("web.DHCBldStatOverTransRecord","QueryOverTransRecord","2014-12-12 12:30:49","2014-12-13 12:30:49","","","","")
ClassMethod QueryOverTransRecordExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, CTLoc As %String, TansFormType As %String, HospitalCode As %String, ProductGroup As %String) As %Status
{
	S repid=$I(^CacheTemp)
	I $G(ind)="" S ind=1
	S DateS=$G(DateS),DateE=$G(DateE),CTLoc=$G(CTLoc),TansFormType=$G(TansFormType),HospitalCode=$G(HospitalCode),ProductGroup=$G(ProductGroup)
	I CTLoc="null" S CTLoc=""
	S ^TMPmcr("Query11")=$lb(DateS,DateE,CTLoc,TansFormType,HospitalCode,ProductGroup)
	//S:'$L(HospitalCode) HospitalCode="QYFYZY"
    I '$L(DateS) S qHandle=$lb(0,repid,0) Q $$$OK
    I '$L(DateE) S qHandle=$lb(0,repid,0) Q $$$OK
    I '$L(DateS) S DateS=$ZD($P(+$H,","),3)
    I '$L(DateE) S DateE=$ZD($P($H,","),3)
    I TansFormType="null" S TansFormType=""
    I CTLoc="null" S CTLoc=""
	S Deli=$C(2)
	S TimeS=$P(DateS," ",2)
	S TimeE=$P(DateE," ",2)
    S DateS=$P(DateS," ",1)
	S DateE=$P(DateE," ",1)
	I $L(TimeS) S TimeS=$ZTH(TimeS,1)
	I $L(TimeE) S TimeE=$ZTH(TimeE,1)
	I DateS?4N1"-"1.2N1"-"1.2N D
	.S DateS=$ZDH(DateS,3)
	E  S DateS=+H
	I DateE?4N1"-"1.2N1"-"1.2N D
	.S DateE=$ZDH(DateE,3)
    E  S DateE=+H
 	S stAppFormIDPre=$TR($ZD(DateS,3),"-")_"000"
	S endAppFormIDPre=$TR($ZD(DateE,3),"-")_"000"
	S tBPGList="",vbTab=$C(9)
	S (labdata,meddata)=""
	I $L(DateS),$L(DateE){
			D QueryOverTransRecordByDate 
	}
	S num=""  F  S num=$O(^TMP($ZN ,$J,"QueryOverTransRecord",num))  Q:num=""  D
	.Q:'$L(^TMP($ZN ,$J,"QueryOverTransRecord",num))
	.S Data=$G(^TMP($ZN ,$J,"QueryOverTransRecord",num))
	.S PatBasicInfo=$P(Data,"#",1)
	.S tBPGList=$P(Data,"#",2)
  	.S (patName,patSex,patAge,patRegNo,patMedicare,CTLocDesc,patWardDesc,lstSaveUserDesc,patDiagnos)=""
  	.S patName=$P(PatBasicInfo,Deli,1)
  	.S patSex=$P(PatBasicInfo,Deli,2)
  	.S patAge=$P(PatBasicInfo,Deli,3)
  	.S patRegNo=$P(PatBasicInfo,Deli,4)
  	.S patMedicare=$P(PatBasicInfo,Deli,5)
  	.//W PatBasicInfo,!
  	.I $L(patRegNo),'$L(patMedicare) D
  	..S PAPERid=$O(^PAPERi("PAPMI_PatNo",patRegNo,""))
  	..I '$L(PAPERid) Q
  	..I $D(^PAPER(PAPERid,"PAT",1)) S patMedicare=$P(^PAPER(PAPERid,"PAT",1),"^",22)
  	..I patMedicare="0" S patMedicare=""
  	.S CTLocDesc=$P(PatBasicInfo,Deli,6)
  	.S patWardDesc=$P(PatBasicInfo,Deli,7)
  	.S lstSaveUserDesc=$P(PatBasicInfo,Deli,8)
  	.S patDiagnos=$P(PatBasicInfo,Deli,9)
  	.I $L(ProductGroup),tBPGList'[ProductGroup Q
  	.S tBPGList=##Class(web.DHCBldStatOverTransRecord).BuildOutPutSeq(tBPGList)
  	.S RBC1=$P(tBPGList,vbTab,1)
  	.S RBC2=$P(tBPGList,vbTab,2)
  	.S FFP1=$P(tBPGList,vbTab,3)
  	.S FFP2=$P(tBPGList,vbTab,4)
    .S (Field1,Field2,Field3,Field4,Field5,tBPGList)=""
    .S Data=$lb(patName,patSex,patAge,patRegNo,patMedicare,CTLocDesc,patWardDesc,lstSaveUserDesc,patDiagnos,RBC1,RBC2,FFP1,FFP2,Field1,Field2,Field3,Field4,Field5)
    .D Output  
    K ^TMP($ZN,$J)
    S qHandle=$lb(0,repid,0)
    Q $$$OK 
  
QueryOverTransRecordByDate
    S isQuit=0,index=1
    S curAppFormID=$O(^DHCBLDAPPFORM(stAppFormIDPre),-1)
    F  S curAppFormID=$O(^DHCBLDAPPFORM(curAppFormID)) Q:('$L(curAppFormID))!(isQuit=1)  D
    .Q:$E(curAppFormID,1,8)'?8N
    .S curDate=$ZDH($E(curAppFormID,1,4)_"-"_$E(curAppFormID,5,6)_"-"_$E(curAppFormID,7,8),3)
    .Q:curDate<DateS
    .S:DateE<curDate isQuit=1
    .Q:isQuit=1
    .Q:'$D(^DHCBLDAPPFORM(curAppFormID,"F"))
    .Q:'$D(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH"))
    .S UserCode=$O(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH",""))
    .S AuthTime=$P($G(^DHCBLDAPPFORM(curAppFormID,"OPERATION",2,"CH",UserCode)),"\",5)
    .I (curDate=DateS),AuthTime<TimeS Q
    .I (curDate=DateE),AuthTime>TimeE Q
    .S curFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",2)
    .S curTansFormType=$P($G(^DHCBLDAPPFORM(curAppFormID,"F")),"\",4)
    .Q:$L(TansFormType)&(curTansFormType'=TansFormType)
    .S appInfo=##Class(web.DHCBldStatOverTransRecord).GetAppFormInfo(curAppFormID,labdata,meddata,CTLoc,HospitalCode)
    .Q:$L(appInfo,"#")<2
    .S:$L(appInfo) ^TMP($ZN ,$J,"QueryOverTransRecord",index)=appInfo
    .S index=index+1
    Q 
    
Output
	S Data=$lb(patName,patSex,patAge,patRegNo,patMedicare,CTLocDesc,patWardDesc,lstSaveUserDesc,patDiagnos,RBC1,RBC2,FFP1,FFP2,Field1,Field2,Field3,Field4,Field5)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod QueryOverTransRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOverTransRecordExecute ]
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

///   W ##Class(web.DHCBldStatOverTransRecord).GetAppFormInfo("20141203007","","","","")
ClassMethod GetAppFormInfo(appFormID As %String, labdata = "", meddata = "", CTLoc, HospitalCode) As %String
{
    S appFormID=$G(appFormID),labdata=$G(labdata),CTLoc=$G(CTLoc),HospitalCode=$G(HospitalCode)
    S ret="",deli=$C(2),AppFormInfo="",TempRes=""
    Q:'$L(appFormID) ret
    Q:'$D(^DHCBLDAPPFORM(appFormID)) ret
    S:'$L(labdata) labdata=##Class(LIS.Core.Util).GetLabDataNS()
    S:'$L(meddata) meddata=##Class(LIS.Core.Util).GetDataNS()
    S CurNameSpace=$ZUTIL(5)
    K ^TMP($ZN,$J,"OEORD")
    ZN meddata
    S appFormBasicData=$$GetAppFormBasicInfo^DHCUtlBldAppForm(appFormID)
    S patBasicData=$$GetPatInfo^DHCUtlBldAppFormCore(appFormID,"")
    S ordersData=$$GetAllOrders^DHCUtlBldAppForm(appFormID,"","")
    ZN CurNameSpace
    S patRegNo=$P(patBasicData,deli,1)
    ;Q:patRegNo'="0001221873" ret
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
    S patLocDr=$P(patBasicData,deli,24)  ;得到开医嘱的登陆科室
    s CurHospitalCode="",HospID=""
    S CTLocCode=$P(^CTLOC(patLocDr),"^",1)
    I $L(CTLoc),$L(CTLocCode),CTLocCode'=CTLoc Q ret
    I $L(patLocDr) S HospID=$P(^CTLOC(patLocDr),"^",22)
    I $L(HospID) S CurHospitalCode=$p(^CT("HOSP",HospID),"^",1)
    I $L(HospitalCode),$L(CurHospitalCode),CurHospitalCode'=HospitalCode Q ret
	S CTLocDesc=$P(^CTLOC(patLocDr),"^",2)
	S fieldDeli=$C(3),recordDeli=$C(2)
    S bldBankProc="",proGrpDesc=""
    S (ordersDesc,ordersVolume,ordersUnit,labno,labRowIDs,OrderInfo,bldProductInfo)=""
    F i=1:1:$L(ordersData,recordDeli) {
	    S order=$P(ordersData,recordDeli,i)
	    Continue:'$L(order)
	    S orderRowID=$P(order,fieldDeli,1)
	    S labRowID=##Class(web.DHCBldStatOverTransRecord).GetOrderLabRowID(orderRowID)
	    S:$L(labRowID) labRowIDs=labRowIDs_labRowID_","
	    S orderDesc=$P(order,fieldDeli,2)
	    Continue:orderDesc["血型复检"
	    Continue:orderDesc["血型复查"
	    Continue:orderDesc["自体"
	    S:orderDesc["红细胞" proGrpDesc="RC"
        S:orderDesc["血小板" proGrpDesc="PLT"
    	S:orderDesc["血浆" proGrpDesc="FFP"
    	S:orderDesc["冷沉淀" proGrpDesc="CRYO"
    	S:orderDesc["全血" proGrpDesc="WB"
	    S ordervolume=+$P(order,fieldDeli,6)
	    S unit=$P(order,fieldDeli,7)
	    Continue:(unit="次")
	    I '$D(^TMP($ZN,$J,"OEORD",proGrpDesc)){
			S ^TMP($ZN,$J,"OEORD",proGrpDesc)=ordervolume
	    }ELSE {
		    S ^TMP($ZN,$J,"OEORD",proGrpDesc)=+^TMP($ZN,$J,"OEORD",proGrpDesc)+ordervolume
		}		
	}
	S bldProductInfo=##Class(web.DHCBldStatOverTransRecord).GetTransBldProducts(labRowIDs,labdata,proGrpDesc)
	S AppFormInfo=patName_deli_patSex_deli_patAge_deli_patRegNo_deli_patMedicare_deli_CTLocDesc_deli_patWardDesc_deli_lstSaveUserDesc_deli_patDiagnos
	//w bldProductInfo,!
	S BPG=0,num=1
	//I patRegNo="0000000017" W patMedicare
	F j=1:1:$L(bldProductInfo,",") {
		S TempStr=$P(bldProductInfo,",",j)
		S TempBpg=$P(TempStr,"\",1),TempTransVol=+$P(TempStr,"\",2)
		Continue:'$L(TempBpg)
		Continue:'$D(^TMP($ZN,$J,"OEORD",TempBpg))
		S ordervolume=+$G(^TMP($ZN,$J,"OEORD",TempBpg))
		I (TempTransVol>ordervolume){
			S TempRes=TempRes_TempBpg_"\"_ordervolume_"\"_TempBpg_"\"_TempTransVol_","
		}
	}
	S:$L(TempRes) ret=AppFormInfo_"#"_TempRes
	//I patRegNo="0000000017" W ret,"^",TempRes,!
	Q ret
}

///   w ##Class(web.DHCBldStatOverTransRecord).BuildOutPutSeq("FFP\500\FFP\520,")
ClassMethod BuildOutPutSeq(tBPGList As %String) As %String
{
	S tBPGList=$G(tBPGList)
	S res="",vbTab=$c(9),Vol=""
	I tBPGList["RC" D
	.F i=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",i)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="RC"
	..S res=$P(temRes,"\",2)_vbTab_$P(temRes,"\",4)_vbTab
	E  D
	.S res=Vol_vbTab_Vol_vbTab

	I tBPGList["FFP" D
	.F j=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",j)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="FFP"
	..S res=res_$P(temRes,"\",2)_vbTab_$P(temRes,"\",4)_vbTab
	E  D
	.S res=res_Vol_vbTab_Vol_vbTab

	I tBPGList["PLT" D
	.F k=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",k)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="PLT"
	..S res=res_$P(temRes,"\",2)_vbTab_$P(temRes,"\",4)_vbTab
	E  D
	.S res=res_Vol_vbTab_Vol_vbTab
	
	I tBPGList["CRYO" D
	.F l=1:1:$L(tBPGList,",")  D
	..S temRes=$P(tBPGList,",",l)
	..S bgg=$P(temRes,"\",1)
	..Q:bgg'="CRYO"
	..S res=res_$P(temRes,"\",2)_vbTab_$P(temRes,"\",4)_vbTab
	E  D
	.S res=res_Vol_vbTab_Vol_vbTab
	Q res
}

//获取医嘱对应的检验RowID

///  W ##Class(web.DHCBldStatOverTransRecord).GetOrderLabRowID("7312192||X005||1","")
ClassMethod GetOrderLabRowID(orderRowID As %String) As %String
{
	S orderRowID=$G(orderRowID)
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

///  W ##Class(web.DHCBldStatOverTransRecord).GetTransBldProducts("7285738||X011||1,7285738||X005||1,","","")
ClassMethod GetTransBldProducts(labRowIDs As %String, labdata As %String, proGrpDesc) As %String
{
    S labRowIDs=$G(labRowIDs),labdata=$G(labdata),proGrpDesc=$G(proGrpDesc)
    S:'$L(labdata) labdata="labdata"
    S ret="",TransInfo=""
    K ^TMP($ZN,$J,"PROGRP")
    S bldProductDesc="",bldProductVolume="",bldProductUnit=""
    F i=1:1:$L(labRowIDs,",") {
		S labRowID=$P(labRowIDs,",",i)
		Continue:'$L(labRowID)
		S labno=$P(labRowID,"||",1)
		S tsCode=$P(labRowID,"||",2)
		S tsCnt=$P(labRowID,"||",3)
		Continue:('$L(labno))||('$L(tsCode))||('$L(tsCnt)) 
		S packMainID=""
		F {
			S packMainID=$O(^|labdata|TEPI(labno,1,tsCode,tsCnt,"BBP",packMainID))
			Q:'$L(packMainID)
			S packSubID=""
			F {
				S packSubID=$O(^|labdata|TEPI(labno,1,tsCode,tsCnt,"BBP",packMainID,packSubID))
				Q:'$L(packSubID)
				S packData=$G(^|labdata|TBBP(packMainID,packSubID))
				S packStatus=$P(^|labdata|TEPI(labno,1,tsCode,tsCnt,"BBP",packMainID,packSubID),"\",3)
				Continue:packStatus'="T"
				S storeStatus=$P(packData,"\",3)
				Continue:storeStatus'="OUT"
				S bldProCode=$P(packData,"\",4)
				I $L(bldProCode),$D(^TTAB("BB-BP",bldProCode)) S ProductGroop=$P(^TTAB("BB-BP",bldProCode),"\",21)
				;W ProductGroop,!
				;Continue:ProductGroop'=ProductGroop
				S bldProdDesc="",bldProUnit=""
				I $L(bldProCode) { 
					S bldProdDesc=$P($G(^|labdata|TTAB("BB-BP",bldProCode)),"\",1)
					S bldProUnit=$P($G(^|labdata|TTAB("BB-BP",bldProCode,"REM",1)),"&",1)
				}
				S bldProBldGrpID=$P(packData,"\",5)
				S bldProBldGrpDesc=""
				S:$L(bldProBldGrpID) bldProBldGrpDesc=$P($G(^|labdata|TTAB("BB-BG",bldProBldGrpID)),"\",1)
				S bldProVolume=$P(packData,"\",21)
				I '$D(^TMP($ZN,$J,"PROGRP",ProductGroop)){
						S ^TMP($ZN,$J,"PROGRP",ProductGroop)=bldProVolume
				}ELSE{
					    S ^TMP($ZN,$J,"PROGRP",ProductGroop)=+^TMP($ZN,$J,"PROGRP",ProductGroop)+bldProVolume
				}
			}	
		}
	}
	S pbg=""
	F {
		S pbg=$O(^TMP($ZN,$J,"PROGRP",pbg))
	    Q:'$L(pbg)
		S Vol=+$G(^TMP($ZN,$J,"PROGRP",pbg))
		S TransInfo=TransInfo_pbg_"\"_Vol_","	
	}
	S:$L(TransInfo) ret=TransInfo
	Q ret
}

Storage Default
{
<Data name="DHCBldStatOverTransRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatOverTransRecordD</DataLocation>
<DefaultData>DHCBldStatOverTransRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatOverTransRecordD</IdLocation>
<IndexLocation>^web.DHCBldStatOverTransRecordI</IndexLocation>
<StreamLocation>^web.DHCBldStatOverTransRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
