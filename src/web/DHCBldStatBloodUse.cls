Class web.DHCBldStatBloodUse Extends %Persistent
{

/// 药敏分离统计
Parameter BUILD = 60;

/// W ##Class(web.DHCBldStatDischargePatient).BloodUsedByVisitNumber() 根据检验号判断病人是否输血
/// W ##Class(web.DHCBldStatDischargePatient).BloodUsed() 根据Adm号判断病人是否输血
/// W ##Class(web.DHCBldStatDischargePatient).GetPatBBP() 根据Adm号判断病人的输血血袋
/// D ##class(web.DHCBldStatBloodUse).QueryDischargeData(+$H-1,+$H-1)
ClassMethod QueryDischargeData(DateS As %String, DateE As %String) As %String
{
  S DateS=$G(DateS),DateE=$G(DateE)
  S stAppFormIDPre=$TR($ZD(DateS,3),"-")_"000"
  S endAppFormIDPre=$TR($ZD(DateE,3),"-")_"000"
  //S DateS=$ZDH(DateS,3)
  //S DateE=$ZDH(DateE,3)
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"
  //TSTART
  S HospitalCode=""
  S SQLCODE=0
  S row=0,PackNumber=0
  F iDate=DateS:1:DateE D
  .W $ZD(iDate,3),!
  .S iTime=""  F  S iTime=$O(^TBBPi("TR-DateTime",iDate,iTime))  Q:iTime=""  D
  ..//I (iDate=DateS)&(iTime<starttime) Q
  ..//I (iDate=DateE)&(iTime>endtime) Q
  ..S PackID=""  F  S PackID=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID))  Q:PackID=""  D
  ...S SecondId=""  F  S SecondId=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID,SecondId))  Q:SecondId=""  D
  ....;-----多医院-------->
  ....S BPCode=$p($g(^TBBP(PackID,SecondId)),"\",4)
  ....I $L(BPCode) S HospitalCode=$p(^TTAB("BB-BP",BPCode),"\",11)
  ....S Sequence=""  F  S Sequence=$O(^TBBPi("TR-DateTime",iDate,iTime,PackID,SecondId,Sequence))  Q:Sequence=""  D
  .....S ^TPack("Hosp",PackID,SecondId)=HospitalCode_"\"_iDate
  .....I $D(^TMP($ZN,$J,PackID,SecondId))'=0 D
  ......S zz=^TMP($ZN,$J,PackID,SecondId)
  ......I Sequence>zz S ^TMP($ZN,$J,PackID,SecondId)=Sequence
  .....E  D
  ......S ^TMP($ZN,$J,PackID,SecondId)=Sequence
  S Num=0
  S PackID=""  F  S PackID=$O(^TMP($ZN,$J,PackID))  Q:PackID=""  D
  .S SecondId=""  F  S SecondId=$O(^TMP($ZN,$J,PackID,SecondId))  Q:SecondId=""  D
  ..;删除的血袋处理
  ..I '$D(^TBBP(PackID,SecondId)) Q
  ..I ($D(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId))),($P(^[sLabNameSpace]Dhcbbpackprice(PackID,SecondId),"\",6)="Y") Q  
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
  ..S ProductVolume=$P(^TBBP(PackID,SecondId),"\",21) 
  ..S ProductCode=$P(^TBBP(PackID,SecondId),"\",4)
  ..S ProductCode=PackID_"||"_SecondId
  ..S HospitalCode=$P($G(^TPack("Hosp",PackID,SecondId)),"\",1)
  ..S iDate=$P($G(^TPack("Hosp",PackID,SecondId)),"\",2)
  ..///增加接收血袋科室统计(转科)20120209 huhm
  ..S TSRowId=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",7)
  ..I '$L(TSRowId) Q
  ..S VisitNumber=$P(TSRowId,"||",1)
  ..S TestSet=$P(TSRowId,"||",2)
  ..S TestSetCnt=$P(TSRowId,"||",3)
  ..S AdmId=$P($P(^TEPI(VisitNumber),"\",37),",",2)
  ..I '$L(AdmId) Q
  ..S DoctorId=$P(^PAADM(AdmId),"^",9)
  ..S AdmDate=$P(^PAADM(AdmId),"^",6)
  ..S AdmTime=$P(^PAADM(AdmId),"^",7)
  ..S AdmType=$P(^PAADM(AdmId),"^",2)
  ..S diagID=..GetDiagnosisID(..GetMRAdmID(AdmId))
  ..S (locID,locCode,HospID)=""
  ..I $l(AdmId),$d(^PAADM(AdmId)) s locID=$P(^PAADM(AdmId),"^",4)
  ..I $l(locID) S HospID=$P(^CTLOC(locID),"^",22),locCode=$P(^CTLOC(locID),"^",1)
  ..I $l(HospID) S HospitalCode=$P(^CT("HOSP",HospID),"^",1) 
  ..S WardDr=$P(^PAADM(AdmId),"^",70)
  ..S WardDesc=##class(web.DHCBldCommonUse).GetWardDesc(WardDr)
  ..S PapmiDr=$P(^PAADM(AdmId),"^",1)
  ..S Debtor=$P(^PAPER(PapmiDr,"PAT",1),"^",1)
  ..S Name=$P(^PAPER(PapmiDr,"ALL"),"^",1)
  ..S SexDr=$P(^PAPER(PapmiDr,"ALL"),"^",7)
  ..S BloodUsed="Y"
  ..I '$D(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP",PackID,SecondId)) Q
  ..S Transfusion=$P(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP",PackID,SecondId),"\",3)
  ..I Transfusion'="T" Q
  ..S VisitNumber=$P(TSRowId,"||",1)
  ..S PackTrans=$P(^TBBP(PackID,SecondId,"TRAN",Sequence),"\",1)
  ..Q:PackTrans'="TRANS3"
  ..Q:PackTrans="TRANS5"
  ..Q:PackTrans="RTS"
  ..//W SQLCODE,AdmId,",",PackID,",",SecondId,!
  ..//I SQLCODE'=0 Q
  ..I '$D(^lab.DHCBldStatBloodUseD(AdmId)) D
  ...&SQL(INSERT INTO lab.DHC_BldStatBloodUse(DBSD_DebtorNo,DBSD_ADM,DBSD_TransDate,DBSD_LocationID,DBSD_WardID,DBSD_DoctorID,DBSD_AdmType,DBSD_DiagnoseID,DBSD_BloodUsed) Values(:Debtor,:AdmId,:iDate,:locID,:WardDr,:DoctorId,:AdmType,:diagID,:BloodUsed))
  ...W "--->",SQLCODE,",",Debtor,AdmId,",",iDate,",",locID,",",WardDr,",",DoctorId,",",AdmType,",",diagID,",",BloodUsed,!
  ..//I SQLCODE'=0 Q
  ..S BDDPSequence=$O(^lab.DHCBldStatBloodUseD(AdmId,"ChildDHCBldStatDiagnoseProduct",ProductCode,""))
  ..I '$D(^lab.DHCBldStatBloodUseD(AdmId,"ChildDHCBldStatDiagnoseProduct",ProductCode)) D
  ...&SQL(INSERT INTO lab.DHC_BldStatBloodUseProduct(BDDP_ParRef,BDDP_ProductCode,BDDP_Volumn,BDDP_Hospital) Values(:AdmId,:ProductCode,:ProductVolume,:HospitalCode))
  ...//b ;121
  //I SQLCODE=0 TCOMMIT
  //E  D  TROLLBACK
  Q
}

/// Creator：      Qiuxianfu
/// CreatDate：    20141215
/// Description:： 根据adm号获取病人输血血袋
/// Table：        无
/// Input：        adm号
/// Output：       
/// Return：       
/// Others：       无
/// W ##Class(web.DHCBldStatDischargePatient).BloodUsed()
ClassMethod GetPatBBP(AdmId As %String) As %String
{
	S AdmId=$G(AdmId)
	S PatBBPInfo=""
	S OrdId="" F  S OrdId=$O(^OEORD(0,"Adm",AdmId,OrdId)) Q:OrdId=""  D
	.S OrdSubId="" F  S OrdSubId=$O(^OEORDi(0,"LabNotRead",OrdId,OrdSubId)) Q:OrdSubId=""  D
	..S TSRow=$P(^OEORD(OrdId,"I",OrdSubId,3),"^",35)
	..Q:'$L(TSRow)
	..S labno=$p(TSRow,"||",1)
	..S TS=$p(TSRow,"||",2)
	..S TSCnt=$p(TSRow,"||",3)
	..Q:'$L(TS) 
	..Q:'$D(^TTAB("TS",TS,"XM")) 
	..S PackId="" F  S PackId=$O(^TEPI(labno,1,TS,TSCnt,"BBP",PackId)) Q:PackId=""  D
	...S SubId="" F  S SubId=$O(^TEPI(labno,1,TS,TSCnt,"BBP",PackId,SubId)) Q:SubId=""  D
	....S PackStr=$g(^TBBP(PackId,SubId))
    ....S XMStus=$g(^TEPI(labno,1,TS,TSCnt,"BBP",PackId,SubId))
    ....S PackStus=$p(XMStus,"\",3)
    ....I PackStus'="T" Q 
    ....S ProductCode=$P(PackStr,"\",4)
    ....S Volume=$P(PackStr,"\",21)
    ....S PatBBPInfo=PatBBPInfo_ProductCode_"\"_Volume_","
    I $L(PatBBPInfo)>2 S PatBBPInfo=$E(PatBBPInfo,1,$L(PatBBPInfo))
    Q PatBBPInfo
}

/// Creator：      Qiuxianfu
/// CreatDate：    20141213
/// Description:： 根据登记号，adm号获取病人是否输过血
/// Table：        无
/// Input：        登记号
/// Output：       是否发血标志
/// Return：       0：输血，1：未输血
/// Others：       无
/// W ##Class(web.DHCBldStatDischargePatient).BloodUsed()
ClassMethod BloodUsed(Debtor As %String, AdmId As %String) As %String
{
	S Debtor=$G(Debtor),AdmId=$G(AdmId)
	S BloodUsed=1
	S curAppFormID=""
	F  S curAppFormID=$O(^DHCBLDAPPFORMi(0,"DEBTOR",Debtor,curAppFormID)) Q:'$L(curAppFormID)  D
	.S AdmID=$P(^DHCBLDAPPFORM(curAppFormID,"P"),"\",16)
	.I $L(AdmId),AdmID'=AdmId Q
	.S AdmNo=""
	.F  S AdmNo=$O(^TIND(5,AdmId,AdmNo)) Q:'$L(AdmNo)  D
	..S VisitNumber=""
	..F  S VisitNumber=$O(^TIND(5,AdmId,AdmNo,VisitNumber)) Q:'$L(VisitNumber)!(BloodUsed=0)  D
	...S BloodUsed=..BloodUsedByVisitNumber(VisitNumber)
    Q BloodUsed
}

/// Creator：      Qiuxianfu
/// CreatDate：    20141213
/// Description:： 根据检验号获取病人是否输过血
/// Table：        无
/// Input：        登记号
/// Output：       是否发血标志
/// Return：       0：输血，1：未输血
/// Others：       无
/// D ##Class(web.DHCBldStatDischargePatient).BloodUsedByVisitNumber()
ClassMethod BloodUsedByVisitNumber(VisitNumber As %String) As %String
{
	S VisitNumber=$G(VisitNumber)
	S TestSet=""
	S ret=1
	F  S TestSet=$O(^TEPI(VisitNumber,1,TestSet)) Q:'$L(TestSet)  D
	.S TestSetCnt=""
	.F  S TestSetCnt=$O(^TEPI(VisitNumber,1,TestSet,TestSetCnt)) Q:'$L(TestSetCnt)  D
	..I '$D(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP")) Q
	..S PackId=""
	..F  S PackId=$O(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP",PackId)) Q:'$L(PackId)  D
	...S PackSubId=""
	...F  S PackSubId=$O(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP",PackId,PackSubId)) Q:'$L(PackSubId)  D
	....S Transfusion=$P(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP",PackId,PackSubId),"\",3)
	....I Transfusion="T" S ret=0
    Q ret
}

ClassMethod GetMRAdmID(admID As %String) As %String
{
	S admID=$G(admID)
	Q:'$L(admID) ""
    Q $P($G(^PAADM(admID)),"^",61)
}

ClassMethod GetDiagnosisID(MRAdmID As %String) As %String
{
	//^MRC("DTYP",2)	=	"M^主诊断^N"
	S MRAdmID=$G(MRAdmID)
    Q:'$L(MRAdmID) MRAdmID
    S diag=0,ret="",all=""
    F {
		S diag=$O(^MR(MRAdmID,"DIA",diag))
		Q:'$L(diag)
		//Q:(diag="")!(ret'="")
		S diagID=$P($G(^MR(MRAdmID,"DIA",diag)),"^",1)   		//ICD代码
		S diagStatusID=$P($G(^MR(MRAdmID,"DIA",diag)),"^",9)  	//诊断状态
		S diagRemark=$P($G(^MR(MRAdmID,"DIA",diag,"DES",1)),"^",1)
		S diagStatus=""
		I $L(diagStatusID) {
			S diagStatus=$P($G(^MRC("DSTAT",diagStatusID)),"^",2)	
		}
		S diagTypeID=$G(^MR(MRAdmID,"DIA",diag,"TYP",1))		//诊断类型
		S diagTypeCode=""
		S diagTypeDesc=""
		I $L(diagTypeID) {
			S diagTypeCode=$P($G(^MRC("DTYP",diagTypeID)),"^",1)
			S diagTypeDesc=$P($G(^MRC("DTYP",diagTypeID)),"^",2)
		}
		I (diagTypeCode="M")||(diagTypeDesc["主诊断"),$L(diagRemark) {
			S:$L(diagRemark) ret=ret_diagRemark_","
		}
		S:$L(diagRemark) all=all_diagRemark_","
		Continue:'$L(diagID)
		//S diagDesc=$P($G(^MRC("ID",diagID)),"^",4)
		S diagDesc=diagID 
		S:diagDesc["-" diagDesc=$P(diagDesc,"-",2)
		Continue:'$L(diagDesc)
		
		I (diagTypeCode="M")||(diagTypeDesc["主诊断"),$L(diagDesc) {
			S:$L(diagDesc) ret=ret_diagDesc_","
		}
		S:$L(diagDesc) all=all_diagDesc_","
	}
	S:'$L(ret) ret=all
	S ret=$E(ret,1,$L(ret)-1)
    S ret=$P(ret,",",1)
    Q ret
}

/// Creator：		Qxf
/// CreateDate：		2014-12-26
/// Description：	根绝输血申请单号获取该病人的各成分血的申请血量，实际输血量，
/// Table：			DHC_BldAppFormOrders
/// Input：			appFormID:申请单编号，VolType类型 ALL:所有类型，"":仅手术类型
/// Output：			无
/// Return：			ret:血成分
/// Others：			无
/// W ##class(web.DHCBldStatBloodUse).GetProductGrp(20141225001)
ClassMethod GetProductGrp(AppFormID As %String, VolType As %String) As %String
{
    S AppFormID=$G(AppFormID),VolType=$G(VolType)
    S ret=""
    S FileName="DHCBldStatBloodUse"
    S num=0
    Q:'$L(AppFormID) ret
    S dFlag=$D(^DHCBLDAPPFORM(AppFormID,"ORDER"))
    Q:dFlag=0 ret
    K LIST
    S ordRowID="",tDeli=$C(2)
    F  S ordRowID=$O(^DHCBLDAPPFORM(AppFormID,"ORDER",ordRowID)) Q:ordRowID=""  D
    .S tData=$g(^DHCBLDAPPFORM(AppFormID,"ORDER",ordRowID))
    .Q:'$L(tData)
    .S OrderDesc=$P(tData,"\",2)
    .S Status=$P(tData,"\",3)
    .S LabNo=$P(tData,"\",4)
    .I '$L(LabNo) S LabNo=$P($g(^OEORD(+ordRowID,"I",$p(ordRowID,"-",2),3)),"^",20)
    .S TestSet=$P(tData,"\",5)
    .S Amount=$P(tData,"\",6)
    .S Unit=$P(tData,"\",7)
    .S OrderDetails=$P(tData,"\",8)
    .S ABO=$P(tData,"\",9)
    .S Rh=$P(tData,"\",10)
    .S Remark=$P(tData,"\",11)
    .S Sequence=$P(tData,"\",12)
    .S num=num+1
    .S LIST(num)=ordRowID_tDeli_OrderDesc_tDeli_Status_tDeli_LabNo_tDeli_TestSet_tDeli
    .S LIST(num)=LIST(num)_Amount_tDeli_Unit_tDeli_OrderDetails_tDeli_ABO_tDeli_Rh_tDeli
    .S LIST(num)=LIST(num)_Remark_tDeli_Sequence_tDeli
    S PatInfo=..GetPatInfoByAppID(AppFormID)
    S CTLoc=$P(PatInfo,"\",3)
    S WardID=$P(PatInfo,"\",12)
    S DoctorCode=$P(PatInfo,"\",23)
    S LIST=$O(LIST(""),-1) 
    S Deli=$C(2)
    S ordersVolume=0
    S labRowIDs=""
    S RetValue=""
    K plReqProductGrp,plActProductGrp,plGrp
    S num=""
    S XMTestSetFlag=0
    F   {
	    S num=$O(LIST(num))
	    Q:'$L(num)
	    S order=LIST(num)
	    Continue:'$L(order)
	    S OeordRowId=$P(order,Deli,1)
	    S labRowID=..GetOrderLabRowID(OeordRowId)
	    ;Continue:'$L(labRowID)
	    S TestSet=$P(labRowID,"||",2)
	    I $L(TestSet) S XMTestSetFlag='$D(^TTAB("TS",TestSet,"XM"))
	    S orderDesc=$P(order,Deli,2)
	    ;Continue:XMTestSetFlag'=0
	    S XMTestSet=0
	    Continue:orderDesc["血型复查"
	    Continue:orderDesc["血型复检"
	    Continue:orderDesc["血型鉴定"
	    S:orderDesc["红细胞" proGrpDesc="RC",XMTestSet=1
        S:orderDesc["血小板" proGrpDesc="PLT",XMTestSet=1
    	S:orderDesc["血浆" proGrpDesc="FFP",XMTestSet=1
    	S:orderDesc["冷沉淀" proGrpDesc="CRYO",XMTestSet=1
    	S:orderDesc["全血" proGrpDesc="WB",XMTestSet=1
    	Continue:XMTestSet=0
	    S ReqVolume=+$P(order,Deli,6)
	    //I proGrpDesc="FFP" b ;1
	    //S ordersVolume=ordersVolume+volume
	    ///一张申请单只申请一种制品，处理一张申请单申请多种成分及制品以及在一张申请单上发多种制品
	    //..科室
	    I $D(^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"Req",CTLoc,proGrpDesc))
	    {
	    	S ^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"Req",CTLoc,proGrpDesc)=^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"Req",CTLoc,proGrpDesc)+ReqVolume
	    	
	    }
	    Else
	    {
		    S ^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"Req",CTLoc,proGrpDesc)=ReqVolume
		}
	    //..病区
	    I $D(^TMP("DHCBldStatBloodUse",$J,"Ward",VolType_"Req",WardID,proGrpDesc))
	    {
	    	S ^TMP("DHCBldStatBloodUse",$J,"Ward",VolType_"Req",WardID,proGrpDesc)=^TMP("DHCBldStatBloodUse",$J,"Ward",VolType_"Req",WardID,proGrpDesc)+ReqVolume
	    	
	    }
	    Else
	    {
		    S ^TMP("DHCBldStatBloodUse",$J,"Ward",VolType_"Req",WardID,proGrpDesc)=ReqVolume
		}
	    //..医生
	    I $D(^TMP("DHCBldStatBloodUse",$J,"Doctor",VolType_"Req",DoctorCode,proGrpDesc))
	    {
	    	S ^TMP("DHCBldStatBloodUse",$J,"Doctor",VolType_"Req",DoctorCode,proGrpDesc)=^TMP("DHCBldStatBloodUse",$J,"Doctor",VolType_"Req",DoctorCode,proGrpDesc)+ReqVolume
	    	
	    }
	    Else
	    {
		    S ^TMP("DHCBldStatBloodUse",$J,"Doctor",VolType_"Req",DoctorCode,proGrpDesc)=ReqVolume
		}
	    //W ReqVolume,order,!
	    Continue:labRowIDs[labRowID
	    S labRowIDs=labRowIDs_labRowID_","
	    
	}
	I $L(labRowIDs),XMTestSetFlag'=0 S RetValue=..BloodUsedByLabRowID(labRowIDs,CTLoc,WardID,DoctorCode,VolType,AppFormID,proGrpDesc)
    //K ^TMP("DHCBldStatBloodUse",$J)
    //W CTLoc,"+",RetValue,"+",proGrpDesc,"+",ReqVolume,!
    I '$L(labRowIDs) S proGrpDesc=""
    S ret=proGrpDesc
    Q ret
}

/// Creator：      Qiuxianfu
/// CreatDate：    20141213
/// Description:： 根据检验报告ID获取病人是否输过血量，分制品及成分
/// Table：        无
/// Input：        登记号
/// Output：       "成分\制品\容量，"
/// Return：       
/// Others：       无
/// D ##Class(web.DHCBldStatDischargePatient).BloodUsedByVisitNumber()
ClassMethod BloodUsedByLabRowID(labRowIDs As %String, CTLoc As %String, WardID As %String, DoctorCode As %String, VolType As %String, AppFormID As %String, proGrpDesc As %String) As %String
{
	S labRowIDs=$G(labRowIDs),CTLoc=$G(CTLoc),VolType=$G(VolType),AppFormID=$G(AppFormID),proGrpDesc=$G(proGrpDesc)
	S ret=1
	S FileName="DHCBldStatBloodUse"
	S ^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"ActAppForm",CTLoc,proGrpDesc,AppFormID)=""
	S ^TMP("DHCBldStatBloodUse",$J,"Ward",VolType_"ActAppForm",WardID,proGrpDesc,AppFormID)=""
	S ^TMP("DHCBldStatBloodUse",$J,"Doctor",VolType_"ActAppForm",DoctorCode,proGrpDesc,AppFormID)=""
	F i=1:1:$L(labRowIDs,",")
	{
		S labRowID=$P(labRowIDs,",",i)
		Continue:'$L(labRowID)
		S VisitNumber=$P(labRowID,"||",1)
		S VisitNumber=$G(VisitNumber)
		S TestSet=""
		S Deli1="\"
		S Deli2=","
		S RetValue=""
		S PatDebtor=$P(^TEPI(VisitNumber),"\",18)
		S ^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"ActUsed",CTLoc,proGrpDesc,PatDebtor)=""
		S ^TMP("DHCBldStatBloodUse",$J,"Ward",VolType_"ActUsed",WardID,proGrpDesc,PatDebtor)=""
		S ^TMP("DHCBldStatBloodUse",$J,"Doctor",VolType_"ActUsed",DoctorCode,proGrpDesc,PatDebtor)=""
		F  S TestSet=$O(^TEPI(VisitNumber,1,TestSet)) Q:'$L(TestSet)  D
		.S TestSetCnt=""
		.F  S TestSetCnt=$O(^TEPI(VisitNumber,1,TestSet,TestSetCnt)) Q:'$L(TestSetCnt)  D
		..I '$D(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP")) Q
		..S PackId=""
		..F  S PackId=$O(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP",PackId)) Q:'$L(PackId)  D
		...S PackSubId=""
		...F  S PackSubId=$O(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP",PackId,PackSubId)) Q:'$L(PackSubId)  D
		....S Transfusion=$P(^TEPI(VisitNumber,1,TestSet,TestSetCnt,"BBP",PackId,PackSubId),"\",3)
		....I Transfusion'="T" Q
		....S ret=0
		....S ActualVolume=$P(^TBBP(PackId,PackSubId),"\",21)
		....//W PackId,"+",ActualVolume,! ;13
		....S ProductCode=$P(^TBBP(PackId,PackSubId),"\",4)
		....S ProductDesc=$P(^TTAB("BB-BP",ProductCode),"\",1)
		....S ProductGrpCode=$P(^TTAB("BB-BP",ProductCode),"\",21)
		....S ProductGrpDesc=$P(^TTAB("BB-PG",ProductGrpCode),"\",1)
		....//..科室
		....I $D(^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"Actual",CTLoc,ProductGrpCode)) D
		.....S ^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"Actual",CTLoc,ProductGrpCode)=^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"Actual",CTLoc,ProductGrpCode)+ActualVolume
		....E  D
		.....S ^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"Actual",CTLoc,ProductGrpCode)=ActualVolume
		....//W PackId,"+",^TMP("DHCBldStatBloodUse",$J,"Dep",VolType_"Actual",CTLoc,ProductGrpCode),"+",ActualVolume,!
		....//..病区
		....I $D(^TMP("DHCBldStatBloodUse",$J,"Ward",VolType_"Actual",WardID,ProductGrpCode)) D
		.....S ^TMP("DHCBldStatBloodUse",$J,"Ward",VolType_"Actual",WardID,ProductGrpCode)=^TMP("DHCBldStatBloodUse",$J,"Ward",VolType_"Actual",WardID,ProductGrpCode)+ActualVolume
		....E  D
		.....S ^TMP("DHCBldStatBloodUse",$J,"Ward",VolType_"Actual",WardID,ProductGrpCode)=ActualVolume
	    ....//..医生
	    ....I $D(^TMP("DHCBldStatBloodUse",$J,"Doctor",VolType_"Actual",DoctorCode,ProductGrpCode)) D
		.....S ^TMP("DHCBldStatBloodUse",$J,"Doctor",VolType_"Actual",DoctorCode,ProductGrpCode)=^TMP("DHCBldStatBloodUse",$J,"Doctor",VolType_"Actual",DoctorCode,ProductGrpCode)+ActualVolume
		....E  D
		.....S ^TMP("DHCBldStatBloodUse",$J,"Doctor",VolType_"Actual",DoctorCode,ProductGrpCode)=ActualVolume
	}
	Q ret
}

/// Creator：		Qxf
/// CreateDate：		2014-12-26
/// Description：	获取病人检验报告ID
/// Table：			
/// Input：			orderRowID:医嘱ID
/// Output：			无
/// Return：			ret:记录数量
/// Others：			无
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

/// Creator：		Qxf
/// CreateDate：		2014-12-26
/// Description：	根据申请单ID获取病人所在科室，病区，姓名，性别，年龄，登记号，血型
/// Table：			
/// Input：			AppFormID:申请单ID
/// Output：			无
/// Return：			ret:记录数量
/// Others：			无
/// W ##class(web.DHCBldStatBloodUse).GetPatInfoByAppID(20141225001)
ClassMethod GetPatInfoByAppID(AppFormID As %String) As %String
{
    S AppFormID=$g(AppFormID)
    S tDeli="\"
    S ret=""
    Q:'$L(AppFormID) ret
    Q:$D(^DHCBLDAPPFORM(AppFormID,"P"))=0 ret
    S patData=$g(^DHCBLDAPPFORM(AppFormID,"P"))
    //S DoctorCode=""
    S DoctorCode=$O(^DHCBLDAPPFORM(AppFormID,"OPERATION",2,"CH",""))
    Q:'$L(patData) ret
	S patRegNo=$P(patData,"\",15)
    S admID=$P(patData,"\",16)
    S roomDr=$P(patData,"\",25)
    S patRoom=..GetRoomDesc(roomDr)
    S patSex=$P(patData,"\",3)
    S patName=$P(patData,"\",2)
    S safetyNetCardNo=""
    S patBed=$P(patData,"\",14)
    S patBirth=$P(patData,"\",5)
    S patAge=$P(patData,"\",4)
    S curWardDr=$P(patData,"\",13)
    S patWardDesc=..GetWardDesc(curWardDr)
    S patHomeAddress=$P(patData,"\",18)
    S patHomeTel=$P(patData,"\",19)
    S patWorkTel=""
    S patMobileTel=$P(patData,"\",20)
    S patCardID=$P(patData,"\",6)
    S patType=$P(patData,"\",1)
    S patTypeDesc=..GetPatTypeDesc(patType)
    S patCountryDesc=$P(patData,"\",17)
    S patNationDesc=$P(patData,"\",21)
    S patDiagnos=$P(patData,"\",24)
    S patProvinceDesc=""
    S patApanageType=$P(patData,"\",7)
    S patLocDr=$P(patData,"\",22)
    S patLocDesc=..GetLocationDesc(patLocDr)
    S patBodyWeight=$P(patData,"\",8)
    S patHeight=$P(patData,"\",9)
    S patBldPressure=$P(patData,"\",10)
    S patPulse=$P(patData,"\",11)
    S patBodyTemper=$P(patData,"\",12)
    S bldGroupABO=$P(patData,"\",26)
    S bldGroupRH=$P(patData,"\",27)
    S bldGroupOther=$P(patData,"\",28)
    S patMedicare=$P(patData,"\",29)
    ///1登记号,2Amd号,3科室ID,4科室描叙,5房号,6性别,7姓名,8,9床号,10出生年月,
    ///11年龄,12病区ID,13病区描叙,14住址,15电话,16病人类型ID,17病人类型描叙
    ///18诊断,19ABO,20RH,21,22住院号,23医生Code
    S retStr=patRegNo_tDeli_admID_tDeli_patLocDr_tDeli_patLocDesc_tDeli_patRoom_tDeli_patSex_tDeli_patName_tDeli
    S retStr=retStr_safetyNetCardNo_tDeli_patBed_tDeli_patBirth_tDeli_patAge_tDeli_curWardDr_tDeli_patWardDesc_tDeli
    S retStr=retStr_patHomeAddress_tDeli_patHomeTel_tDeli_patType_tDeli_patTypeDesc_tDeli
    S retStr=retStr_patDiagnos_tDeli_bldGroupABO_tDeli_bldGroupRH_tDeli_bldGroupOther_tDeli_patMedicare_tDeli_DoctorCode_tDeli
    Q retStr
}

ClassMethod GetRoomDesc(ID As %String) As %String
{
    S ID=$g(ID)
    S ret=""
    Q:'$l(ID) ret
    
    S ret=$P($g(^PAROOM(ID)),"^",2)
    Q ret
}

ClassMethod GetWardDesc(ID As %String) As %String
{
	S ID=$g(ID)
    S ret=""
    Q:'$l(ID) ret
    S ret=$P($g(^PAWARD(ID)),"^",2)
    S:ret["-" ret=$P(ret,"-",2)
    Q ret
}

ClassMethod GetPatTypeDesc(ID As %String) As %String
{
	S ID=$g(ID)
    S ret=""
    Q:'$l(ID) ret
    
    S:ID="O" ret="门诊"
    S:ID="I" ret="住院"
    S:ID="E" ret="急诊"
    
    Q ret
}

ClassMethod GetLocationDesc(ID As %String) As %String
{
     S ret=""
     Q:'$l(ID) ret
     S ret=$P($g(^CTLOC(ID)),"^",2) 
     S:ret["-" ret=$P(ret,"-",2)
     Q ret
}

Storage Default
{
<Data name="DHCBldStatBloodUseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatBloodUseD</DataLocation>
<DefaultData>DHCBldStatBloodUseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatBloodUseD</IdLocation>
<IndexLocation>^web.DHCBldStatBloodUseI</IndexLocation>
<StreamLocation>^web.DHCBldStatBloodUseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
