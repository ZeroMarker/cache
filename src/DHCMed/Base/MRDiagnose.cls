/// 名称: DHCMed.Base.MRDiagnose
/// 描述: 就诊诊断表(MR_Diagnos)的业务封装，定义常用属性和方法
/// 编写者：lyh
/// 编写日期: 2010-04-08
Class DHCMed.Base.MRDiagnose Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 诊断表Id  MRDIA_RowId
Property Rowid As %Integer;

/// ICD指针 MRDIA_ICDCode_DR  指向 MRC_Icddx
Property ICDCodeDr As %Integer;

/// ICD9代码 MRCID_ICD9CM_Code
Property ICD9CMCode As %String(TRUNCATE = 1);

/// ICD描述 MRCID_Desc
Property ICDDesc As %String(TRUNCATE = 1);

/// 下诊断医生指针 MRDIA_DocCode_DR  指向 CT_CareProv	
Property DocCodeDr As %Integer;

/// 医护人员代码 CTPCP_Code
Property CTPCPCode As %String(TRUNCATE = 1);

/// 医护人员描述 CTPCP_Desc
Property CTPCPDesc As %String(TRUNCATE = 1);

//  /Property CTCPTActiveFlag As %String;

/// 医护人员类型指针 CTPCP_CarPrvTp_DR 指向 CT_CarPrvTp
/// 医护人员类型代码 CTCPT_Code
/// 医护人员类型描述 CTCPT_Desc
Property CTCPTDesc As %String(TRUNCATE = 1);

/// 医护人员类型是否有效 CTCPT_ActiveFlag
/// 医护人员类型 CTCPT_InternalType DOCTOR、NURSE
Property CTCPTInternalType As %String(TRUNCATE = 1);

/// 下诊断日期	MRDIA_Date              	
Property DiaDate As %Library.Date;

/// 下诊断时间  MRDIA_Time              		
Property DiaTime As %Library.Time;

/// 是否有效  MRDIA_Active            		
Property IsActive As %Boolean;

/// 症状指针 MRDIA_SignSym_DR 指向 MRC_DiagnosSignSymptom		
Property SignSymDr As %Integer;

/// 症状描述(文本描述) MRDIA_AliasDiagText     		
Property AliasDiagText As %String(TRUNCATE = 1);

/// Add By LiYang 2016-08-07 诊断类别ID 指向MRC_DiagnosType
Property DiaTypeID As %String;

/// Add By LiYang 2016-08-07 诊断类别代码 
Property DiaTypeCode As %String;

/// Add By LiYang 2016-08-07 诊断类别描述
Property DiaTypeDesc As %String;

/// Creator：     lyh
/// CreatDate：   2010-04-08
/// Description:  将对象格式化为字符串
/// Table：       MR_Diagnos、CT_CareProv
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:ICDCodeDr 3:DocCodeDr 4:CTPCPCode 5:CTPCPDesc 6:CTCPTDesc
/// 			  7:CTCPTInternalType 8:DiaDate 9:DiaTime 10:IsActive 11:SignSymDr 12:AliasDiagText 13:ICD9CMCode 14:ICDDesc
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..Rowid_separete_..ICDCodeDr_separete_..DocCodeDr_separete_..CTPCPCode_separete_..CTPCPDesc
	set return=return_separete_..CTCPTDesc_separete_..CTCPTInternalType_separete_..DiaDate_separete_..DiaTime
	set return=return_separete_..IsActive_separete_..SignSymDr_separete_..AliasDiagText_separete_..ICD9CMCode_separete_..ICDDesc
	quit return
}

/// Creator：     lyh
/// CreatDate：   2010-04-08
/// Description:  根据MR_Diagnos.MRDIA_RowId取诊断信息
/// Table：       MR_Diagnos、CT_CareProv、CT_CarPrvTp
/// Input：       DiaId    MR_Diagnos.MRDIA_RowId
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(DiaId As %String) As DHCMed.Base.MRDiagnose
{
	new (DiaId)
	set return=""
	//quit:DiaId="" return
	set MRAdmId=$p($g(DiaId),"||",1)
	set MRDIACsub=$p($g(DiaId),"||",2)
	quit:MRAdmId="" return
	quit:MRDIACsub="" return
	quit:'$d(^MR(MRAdmId,"DIA",MRDIACsub)) return

	set obj=##Class(DHCMed.Base.MRDiagnose).%New()
	set obj.Rowid=+DiaId
	set obj.ICDCodeDr=$p($g(^MR(MRAdmId,"DIA",MRDIACsub)),"^",1)
	set obj.ICD9CMCode=$p($g(^MRC("ID",+obj.ICDCodeDr)),"^",4)
	s:+obj.ICDCodeDr=0 obj.ICD9CMCode=""
	set obj.ICDDesc=$p($g(^MRC("ID",+obj.ICDCodeDr)),"^",2)
	set:obj.ICDDesc="" obj.ICDDesc=$g(^MR(MRAdmId,"DIA",MRDIACsub,"DES",1)) 
	set obj.DocCodeDr=$p($g(^MR(MRAdmId,"DIA",MRDIACsub)),"^",4)
	set obj.CTPCPCode=$p($g(^CTPCP(+obj.DocCodeDr,1)),"^",1)
	set obj.CTPCPDesc=$p($g(^CTPCP(+obj.DocCodeDr,1)),"^",2)
	set CarPrvTpDr=$p($g(^CTPCP(+obj.DocCodeDr,1)),"^",4)
	;set obj.CTCPTCode=$p($g(^CT("CPT",+obj.CarPrvTpDr)),"^",1)
	set obj.CTCPTDesc=$p($g(^CT("CPT",+CarPrvTpDr)),"^",2)
	;set obj.CTCPTActiveFlag=$p($g(^CT("CPT",+obj.CarPrvTpDr)),"^",3)
	set obj.CTCPTInternalType=$p($g(^CT("CPT",+CarPrvTpDr)),"^",4)
	set obj.DiaDate=$p($g(^MR(MRAdmId,"DIA",MRDIACsub)),"^",7)
	set obj.DiaTime=$p($g(^MR(MRAdmId,"DIA",MRDIACsub)),"^",8)
	set obj.IsActive=$p($g(^MR(MRAdmId,"DIA",MRDIACsub)),"^",34)
	set obj.SignSymDr=$p($g(^MR(MRAdmId,"DIA",MRDIACsub)),"^",10)
	set obj.AliasDiagText=$p($g(^MR(MRAdmId,"DIA",MRDIACsub)),"^",23)
	
	//Add By LiYang 2016-08-07 增加中医诊断判断
	Set obj.DiaTypeID=$g(^MR(MRAdmId,"DIA",MRDIACsub,"TYP",1))
	Set t=$g(^MRC("DTYP",+obj.DiaTypeID))
	Set obj.DiaTypeCode=$p(t,"^",1)
	Set obj.DiaTypeDesc=$p(t,"^",2)
	
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     lyh
/// CreatDate：   2010-04-08
/// Description:  根据MR_Diagnos.MRDIA_RowId取诊断信息
/// Table：       MR_Diagnos
/// Input：       DiaId    MR_Diagnos.MRDIA_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.MRDiagnose).GetStringById("5||25")
ClassMethod GetStringById(DiaId As %String, separete As %String) As %String
{
	new (DiaId,separete)
	set return=""
	set obj=..GetObjById(DiaId)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     lyh
/// CreatDate：   2010-04-08
/// Description:  根据paadm取诊断信息
/// Table：       MR_Diagnos
/// Input：       paadm    PA_Adm.PAADM_RowID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.MRDiagnose).GetByPaadm(1)
ClassMethod GetByPaadm(paadm) As %String
{
	new (paadm)
	set return=""
	quit:+paadm="" return
	set PAADMMainMRADMDR=$p($g(^PAADM(+paadm)),"^",61)
	quit:+PAADMMainMRADMDR="" return
	
	set rowid=$o(^MR(+PAADMMainMRADMDR,"DIA",0))
	while rowid'="" {
		set return=return_..GetStringById(+PAADMMainMRADMDR_"||"_+rowid,"")_$c(1)
		set rowid=$o(^MR(PAADMMainMRADMDR,"DIA",rowid))		
	}
	quit return
}

Storage Default
{
<Data name="MRDiagnoseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.Base.MRDiagnoseD</DataLocation>
<DefaultData>MRDiagnoseDefaultData</DefaultData>
<IdLocation>^DHCMed.Base.MRDiagnoseD</IdLocation>
<IndexLocation>^DHCMed.Base.MRDiagnoseI</IndexLocation>
<StreamLocation>^DHCMed.Base.MRDiagnoseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
