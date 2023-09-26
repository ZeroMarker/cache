Class web.DHCBldStatDischargePatient Extends %Persistent
{

/// 药敏分离统计
Parameter BUILD = 60;

/// D ##class(web.DHCBldStatDischargePatient).QueryDischargeData(+$H,+$H)
ClassMethod QueryDischargeData(DateS As %String, DateE As %String) As %String
{
  S DateS=$G(DateS),DateE=$G(DateE)
  S stAppFormIDPre=$TR($ZD(DateS,3),"-")_"000"
  S endAppFormIDPre=$TR($ZD(DateE,3),"-")_"000"
  //S DateS=$ZDH(DateS,3)
  //S DateE=$ZDH(DateE,3)
  D ##class(web.DHCBldStatBloodUse).QueryDischargeData(+$H-1,+$H-1)
  K ^TMP($zn,$j)
  TSTART
  S SQLCODE=0
  F Date=DateS:1:DateE  D
  .W Date,!
  .S AdmId="" F  S AdmId=$O(^PAADMi("DisDateT","I",Date,AdmId)) q:AdmId=""  d
  ..S DisDate=$ZD(Date,3)
  ..S DoctorId=$P(^PAADM(AdmId),"^",9)
  ..S AdmDate=$P(^PAADM(AdmId),"^",6)
  ..S AdmTime=$P(^PAADM(AdmId),"^",7)
  ..S AdmType=$P(^PAADM(AdmId),"^",2)
  ..S diagID=..GetDiagnosisID(..GetMRAdmID(AdmId))
  ..S (CurHospitalCode,locID,locCode,HospID)=""
  ..I $l(AdmId),$d(^PAADM(AdmId)) s locID=$P(^PAADM(AdmId),"^",4)
  ..I $l(locID) s HospID=$P(^CTLOC(locID),"^",22),locCode=$P(^CTLOC(locID),"^",1)
  ..I $l(HospID) s CurHospitalCode=$P(^CT("HOSP",HospID),"^",1) 
  ..S WardDr=$P(^PAADM(AdmId),"^",70)
  ..S WardDesc=##class(web.DHCBldCommonUse).GetWardDesc(WardDr)
  ..S PapmiDr=$P(^PAADM(AdmId),"^",1)
  ..S Name=$P(^PAPER(PapmiDr,"ALL"),"^",1)
  ..S SexDr=$P(^PAPER(PapmiDr,"ALL"),"^",7)
  ..S:SexDr="1" SexDr="男"
  ..S:SexDr="2" SexDr="女"
  ..S DOB=$P(^PAPER(PapmiDr,"ALL"),"^",6)
  ..S DOB=##class(web.DHCLabCommonUse).GetPatAgeByAdm(AdmId)
  ..S AGE=$P(DOB,$C(1),1)
  ..S Units=$P(DOB,$C(1),2)
  ..S:Units="0" DOB=AGE_" 岁"
  ..S:Units="1" DOB=AGE_" 月"
  ..S:Units="2" DOB=AGE_" 天"
  ..S:Units="3" DOB=AGE_" 小时"
  ..S Debtor=$P(^PAPER(PapmiDr,"PAT",1),"^",1)
  ..S BloodUsed=..BloodUsed(Debtor,AdmId)
  ..I BloodUsed=0 S BloodUsed="Y"
  ..I BloodUsed=1 S BloodUsed="N"
  ..//K PLIST
  ..//S PLIST(2)=Debtor
  ..//S PLIST(3)=AdmId
  ..//S PLIST(4)=Date
  ..//S PLIST(5)=locID
  ..//S PLIST(6)=WardDr
  ..//S PLIST(7)=DoctorId
  ..//S PLIST(8)=AdmType
  ..//S PLIST(9)=diagID
  ..//S PLIST(10)=BloodUsed
  ..I '$D(^lab.DHCBldStatDiagnoseD(AdmId)) D
  ...I SQLCODE=100 Q
  ...&SQL(INSERT INTO lab.DHC_BldStatDiagnose(DBSD_DebtorNo,DBSD_ADM,DBSD_DischargeDate,DBSD_LocationID,DBSD_WardID,DBSD_DoctorID,DBSD_AdmType,DBSD_DiagnoseID,DBSD_BloodUsed) Values(:Debtor,:AdmId,:Date,:locID,:WardDr,:DoctorId,:AdmType,:diagID,:BloodUsed))
  ...S PatBBPInfo=..GetPatBBP(AdmId)
  ...I '$L(PatBBPInfo) Q
  ...F i=1:1:$L(PatBBPInfo,",") D
  ....S BBPinfo=$P(PatBBPInfo,",")
  ....S ProductCode=$P(BBPinfo,"\",1)
  ....S ProductVolume=$P(BBPinfo,"\",2)
  ....I SQLCODE=100 Q
  ....I $D(^lab.DHCBldStatDiagnoseD(AdmId,"ChildDHCBldStatDiagnoseProduct",ProductCode)) Q
  ....&SQL(INSERT INTO lab.DHC_BldStatDiagnoseProduct(BDDP_ParRef,BDDP_ProductCode,BDDP_Volumn) Values(:AdmId,:ProductCode,:ProductVolume))
  I SQLCODE=0 TCOMMIT
  E  D  TROLLBACK
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
	..Q:'$l(TSRow)
	..S labno=$p(TSRow,"||",1)
	..S TS=$p(TSRow,"||",2)
	..S TSCnt=$p(TSRow,"||",3)
	..Q:'$l(TS) 
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
/// D ##Class(web.DHCBldStatDischargePatient)BloodUsedByVisitNumber()
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

Storage Default
{
<Data name="DHCBldStatDischargePatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatDD96FD</DataLocation>
<DefaultData>DHCBldStatDischargePatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatDD96FD</IdLocation>
<IndexLocation>^web.DHCBldStatDD96FI</IndexLocation>
<StreamLocation>^web.DHCBldStatDD96FS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
