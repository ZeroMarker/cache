/// 名称:医保住院审批相关类方法
/// 描述:医保住院申请和医保住院审批相关函数
/// 编写者：JinShuai1010
/// 编写日期:2023/01/12
/// 产品组：计费医保
/// Table：登记审批表
/// 存储医保登记前 由操作员提交申请 医保办填写审批信息
Class web.DHCINSURegAppr Extends %RegisteredObject
{

/// Creator：JinShuai1010
/// CreatDate：2023/01/12
/// Description: 申请一条审批记录
/// Table：登记审批表 INSU_MI.RegAppr
/// Input：患者信息串: 就诊号^登记号^住院号^申请类型^申请流水号^住院科室^住院病区^申请费别^审批后费别^医疗类别^
///        生育类别^计划生育手术类别^病种审批类别^备注^审批角色^审批状态^审批日期^审批时间^审批人^申请日期^申请时间^申请人^院区
/// Output：生成的登记审批表ID 
/// Return：
/// Others：w ##class(web.DHCINSURegAppr).Apply("^141^0000000016^101020^1^^内分泌^1^1^3^1^1^1^1^备注^1^0^2022-03-01^16:30^1^2022-03-01^18:30^1^2")
ClassMethod Apply(InString As %String) As %String
{
	 q:InString="" 	 
	 s AdmDr=$p(InString,"^",2)
	 s AppSeriNo=##class(web.DHCINSURegAppr).CreateAppSeriNo(AdmDr)
	 i AppSeriNo'=""    d
	 .s $p(InString,"^",6)=AppSeriNo
	 s rtnStr = $$Insert^DHCINSURegAppr(InString)
	 q rtnStr
}

/// Creator：JinShuai1010
/// CreatDate：2023/01/12
/// Description: 更新审批状态,或直接增加一条审批通过
/// Table：登记审批表 INSU_MI.RegAppr
/// Input：患者信息串: 就诊号^登记号^住院号^申请类型^申请流水号^住院科室^住院病区^申请费别^审批后费别^医疗类别^
///        生育类别^计划生育手术类别^病种审批类别^备注^审批角色^审批状态^审批日期^审批时间^审批人^申请日期^申请时间^申请人^院区
/// Output：生成的登记审批表ID 
/// Return：
/// Others：  w ##class(web.DHCINSURegAppr).Update("^141^0000000016^101020^1^^内分泌^1^1^3^1^1^1^1^备注^1^0^2022-03-01^16:30^1^2022-03-01^18:30^1^2")
ClassMethod Update(InString As %String) As %String
{
	 q:InString="" 
	 s AdmDr=$p(InString,"^",2)
	 s AppSeriNo=##class(web.DHCINSURegAppr).CreateAppSeriNo(AdmDr)
	 i AppSeriNo'=""    d
	 .s $p(InString,"^",6)=AppSeriNo
	 s rtnStr = $$Update^DHCINSURegAppr(InString)
	 q rtnStr
}

/// Creator：JinShuai1010
/// CreatDate：2023/01/12
/// Description: 查询医保登记审批信息 
/// Input：RegNo:登记号，IPRecordNo:住院号，SDate:开始日期，EDate:结束日期
/// Output：病人的审批信息
/// Return：登记审批表ID:RegID,PaadmID:ADMDR,登记号:Regno,住院号:IPRegNo,申请类型:AppType,申请流水号:AppNo,是否登记：IfReg,是否结算：IfAcct,
///         姓名：Name,性别：Sex,年龄：Age,住院科室:LocDr,住院病区:Ward,申请费别:ApprReaId,审批后费别:ChkedReaId,备注:Memo,医疗类别:MedType,
///         生育类别:MatnType,计划生育手术类别:BirCtrlType,病例查看：IllHistory,上传资料：UpFile,审批状态：ApprStas,审批角色：ApprRole,
///         审批日期：ApprDate,审批人：Apprer,申请日期：AppyDate,申请人：Appyer, 审批原因：AppyReason,申请类型代码：AppTypeCodes,
///         审批角色代码：ApprRoleCode,审批结果代码：ApprStasCode,费别代码：ApprReaIdCode,修改后费别代码：ChkedReaIdCode,审批人Id：ApprerId,申请人Id：AppyerId
/// Others：d ##Class(%ResultSet).RunQuery("web.DHCINSURegAppr","GetRegApprInfo","","","","")
Query GetRegApprInfo(RegNo As %String, IPRecordNo As %String, SDate As %String, EDate As %String, AdmDr As %String, ApprStats As %String, Hosptal As %String) As %Query(ROWSPEC = "RegID:%String,ADMDR:%String,Regno:%String,IPRegNo:%String,AppType:%String,AppNo:%String,IfReg:%String,IfAcct:%String,Name:%String,Sex:%String,Age:%String,LocDr:%String,Ward:%String,ApprReaId:%String,ChkedReaId:%String,Memo:%String,MedType:%String,MatnType:%String,BirCtrlType:%String,IllHistory:%String,UpFile:%String,ApprStas:%String,ApprRole:%String,ApprDate:%String,Apprer:%String,AppyDate:%String,Appyer:%String,AppyReasondesc:%String,AppTypeCode:%String,ApprRoleCode:%String,ApprStasCode:%String,ApprReaIdCode:%String,ChkedReaIdCode:%String,ApprerId:%String,AppyerId:%String,MedTypeCode:%String,MatnTypeCode:%String,BirCtrlTypeCode:%String,AppyReasonCode:%String,AppMemo:%String,VisitStatus::%String") [ SqlProc ]
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSURegAppr","GetRegApprInfo","","","2023-04-14","2023-04-14","","","2")
ClassMethod GetRegApprInfoExecute(ByRef qHandle As %Binary, RegNo As %String, IPRecordNo As %String, SDate As %String, EDate As %String, AdmDr As %String, ApprStats As %String, Hosptal As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)	
	s StDate=##class(websys.Conversions).DateHtmlToLogical(SDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EDate)
	s Flag=0
    //当入参，有就诊号时快速查询
	i (AdmDr'="")&&(+Flag=0)                                       
	  {
		  
		  s RegID=""
		  s RegID=$O(^INSU.MI.RegApprI("IdxAdmDr",AdmDr,RegID),-1) 
		  s Regstr=$$GetINSURegApprById^DHCINSURegAppr(RegID) 
	      s Regno=$p(Regstr,"^",4)
		  s IPRegNo=$p(Regstr,"^",5)
		  s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
		  q:Hosptal'=HospDr
		  s ADMDR=AdmDr
		  d BuildData
		  s Flag=1
		}
    //当入参，有登记号时快速查询
    i (RegNo'="")&&(+Flag=0) 
	{
		  s RegID=""
		  s RegID=$O(^INSU.MI.RegApprI("IdxRegNo",RegNo,RegID),-1) 
		  s Regstr=$$GetINSURegApprById^DHCINSURegAppr(RegID)
		  s Regno=RegNo
		  s IPRegNo=$p(Regstr,"^",5)
		  s ADMDR=$p(Regstr,"^",2)
		  s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(ADMDR)
		  q:Hosptal'=HospDr
		  d BuildData
		  s Flag=1
		
		}
    //当入参，有住院号时快速查询    
	i (IPRecordNo'="")&&(+Flag=0) 
	{
		  s RegID=""
		  s RegID=$O(^INSU.MI.RegApprI("IdxIPRecordNo",IPRecordNo,RegID),-1) 
		  s Regstr=$$GetINSURegApprById^DHCINSURegAppr(RegID) 
	      s Regno=$p(Regstr,"^",4)
		  s IPRegNo=IPRecordNo
		  s ADMDR=$p(Regstr,"^",2)
		  s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(ADMDR)
		  q:Hosptal'=HospDr
		  d BuildData
		  s Flag=1
		}      	
    i +Flag=0
      {
	      s date= StDate
          f 
          {
	           s RegID=""
               f 
               { 
                   s RegID=$O(^INSU.MI.RegApprI("IdxAppyDate",date,RegID))   
                   q:RegID=""
	               s Regstr=$$GetINSURegApprById^DHCINSURegAppr(RegID)
	               s Reg=$p(Regstr,"^",4)
	               continue:Reg=""
	               continue:(RegNo'="")&&(Reg'=RegNo)
	               s Regno=Reg
	               s ADMDR=$p(Regstr,"^",2)
	               s ApprStas=$p(Regstr,"^",19) //审批结果
	               i ApprStats'=""
	               {
		               continue:ApprStats'=ApprStas
		               }
		           continue:ADMDR=""
	               s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(ADMDR)
	               q:Hosptal'=HospDr
                   s IPRegNo=$p(Regstr,"^",5) //住院号
                   continue:(IPRecordNo'="")&&(IPRegNo'=IPRecordNo)
                   d BuildData
                   s Flag=1
                }
                s date=date+1
                q:date>EndDate
           }
       }
	Quit $$$OK
BuildData
    s AppType=$p(Regstr,"^",6) //申请类型
    s RegId=$p(Regstr,"^",1)
    s VisitStatus=$p(^PAADM(ADMDR),"^",20) //adm 状态  //upt 20230407 JinS1010
    s VisitStatus=$case(VisitStatus,"C":"退院","A":"在院","D":"出院","P":"预约",:VisitStatus)  //upt 20230407 JinS1010
    s LastRegAndAppMemo=##class(web.DHCINSURegAppr).SelectRegId(ADMDR)
	s LastReg=$p(LastRegAndAppMemo,"^",1)
    //不是最后一条记录时退出
	q:LastReg'=RegId
    s AppTypeCodes=AppType
    s AppType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("app_type00A",AppType,"4",HospDr) //获取申请类型描述
    s AppNo=$p(Regstr,"^",7) //申请流水号
    s admdr=$p(Regstr,"^",2) 
    s Paperstr=##class(web.DHCINSURegAppr).GetPatientInfo(admdr)
    s IfReg=$p(Paperstr,"^",2)
    s IfAcct=$p(Paperstr,"^",3)
    s Name=$p(Paperstr,"^",4)
    s Sex=$p(Paperstr,"^",5)
    s Age=$p(Paperstr,"^",6)
    s LocDr=$p(Regstr,"^",9) //住院科室
    s Ward=$p(Regstr,"^",10) //住院护理单元
    s ApprReaId=$p(Regstr,"^",11) //费别
    s ApprReaIdCode=ApprReaId
    s AdmReaData=""
    s:ApprReaId'="" AdmReaData=$g(^PAC("ADMREA",ApprReaId))	
	s ApprReaId=$p(AdmReaData,"^",2)
    s ChkedReaId=$p(Regstr,"^",12) //修改后费别
    s ChkedReaIdCode=ChkedReaId
    s ChkedAdmReaData=""
    s:ChkedReaId'="" ChkedAdmReaData=$g(^PAC("ADMREA",ChkedReaId))
    s ChkedReaId=$p(ChkedAdmReaData,"^",2)
    s MedType=$p(Regstr,"^",13) //医疗类别
    s MedTypeCode=MedType
    s MedType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_type00A",MedType,"4",HospDr)
    s MatnType=$p(Regstr,"^",14) //生育类别
    s MatnTypeCode=MatnType
    s MatnType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("matn_type00A",MatnType,"4",HospDr)
    s BirCtrlType=$p(Regstr,"^",15) //计划生育手术类别
    s BirCtrlTypeCode=BirCtrlType
    s BirCtrlType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("birctrl_type00A",BirCtrlType,"4",HospDr)
    s AppyReason=$p(Regstr,"^",16) //病种审批选项/审批原因                 
    //当病种审批原因或生育类别为空时，说明是一条申请记录，医保办备注应该为空。
    i (AppyReason="")&&(MatnType="")   d
    .s AppMemo=$p(LastRegAndAppMemo,"^",2) //申请备注   
    .s Memo=""                             //备注
    e                 d
    .s AppMemo=$p(LastRegAndAppMemo,"^",2) //申请备注
    .s Memo=$p(Regstr,"^",17)              //备注
    s AppyReasonCode=AppyReason
    s AppyReasonLength=$Length(AppyReason,",")
    s AppyReasondesc=""
    b ;AppyReason
    f i=1:1:AppyReasonLength  d
    .s ReasonIndex=$p(AppyReason,",",i)   
    .i ReasonIndex="7"   d
    ..s ReasonMemo=$p(Regstr,"^",17)
    ..s desc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("dise_appr_type00A",ReasonIndex,"4",HospDr)
    ..s AppyReasondesc=AppyReasondesc_","_desc_":"_ReasonMemo
    .e                   d
    ..s desc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("dise_appr_type00A",ReasonIndex,"4",HospDr)
    ..s AppyReasondesc=AppyReasondesc_","_desc
    ..b ;AppyReasondesc   1
    s AppyReasondesc=$Piece(AppyReasondesc,",",2,AppyReasonLength+1)
    b ;AppyReasondesc
    s IllHistory=""    
    s UpFile=""
    s ApprStas=$p(Regstr,"^",19) //审批结果  
    s ApprStasCode=ApprStas
    s ApprStas=##class(web.INSUDicDataCom).GetDicByCodeAndInd("appr_stas00A",ApprStas,"4",HospDr)    
    s ApprRole=$p(Regstr,"^",18)
    s ApprRoleCode=ApprRole
    s ApprRole=##class(web.INSUDicDataCom).GetDicByCodeAndInd("appr_role00A",ApprRole,"4",HospDr)
    s ApprDate=$p(Regstr,"^",20)_" "_$p(Regstr,"^",21) //审批日期
    s Apprer=$p(Regstr,"^",22) //审批人
    s ApprerId=$p(Regstr,"^",22) //审批人id
    s:Apprer'="" Apprer=$p( ##class(web.DHCINSUBase).GetUserStr(Apprer),"^",1)
    s AppyDate=$p(Regstr,"^",23)_" "_$p(Regstr,"^",24) //申请日期
    s Appyer=$p(Regstr,"^",25) //提交人
    s AppyerId=$p(Regstr,"^",25) //提交人
    
    s:Appyer'="" Appyer=$p(##class(web.DHCINSUBase).GetUserStr(Appyer),"^",1)
    s Data=$lb(RegID,ADMDR,Regno,IPRegNo,AppType,AppNo,IfReg,IfAcct,Name,Sex,Age,LocDr,Ward,ApprReaId,ChkedReaId,Memo,MedType,MatnType,BirCtrlType,IllHistory,UpFile,ApprStas,ApprRole,ApprDate,Apprer,AppyDate,Appyer,AppyReasondesc,AppTypeCodes,ApprRoleCode,ApprStasCode,ApprReaIdCode,ChkedReaIdCode,ApprerId,AppyerId,MedTypeCode,MatnTypeCode,BirCtrlTypeCode,AppyReasonCode,AppMemo,VisitStatus) 
    s ^CacheTemp(repid,ind)=Data  
    s ind=ind+1
    q
}

ClassMethod GetRegApprInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegApprInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRegApprInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegApprInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// Creator：JinShuai1010
/// CreatDate：2023/01/12
/// Description: 根据就诊号生成申请流水号
/// Input：paadm的rowid
/// Output：申请流水号
/// Others：w ##class(web.DHCINSURegAppr).CreateAppSeriNo("19") 
ClassMethod CreateAppSeriNo(AdmDr As %String) As %String
{
	s $zt="CreateAppSeriNoEx"
	q:AdmDr="" 
	s result=""	
	s RegStr = $$GetINSURegApprAdmDr^DHCINSURegAppr(AdmDr)
	i RegStr<0  d
	.s result=AdmDr_"||"_"1"
	e           d
	.s ApprStas=$p(RegStr,"^",19)
	.s AppSeriNo=$p($p(RegStr,"^",7),"||",2)
	.i ApprStas="2"  d
	..s AppSeriNo=AppSeriNo+1
	..s result=AdmDr_"||"_AppSeriNo
	.e          d
	..s result=""
	q result
CreateAppSeriNoEx
 s $zt=""
 b ;CreateAppSeriNoEx
 q "-99^程序异常："_$ze
}

/// Creator：JinShuai1010
/// CreatDate：2023/01/12
/// Description: 根据就诊号获取病人的基本信息 
/// Input：AdmDr:就诊号
/// Output：就诊信息串
/// Return：登记号^是否登记^是否结算^姓名^年龄^性别^审批前费别^住院科室^住院号^住院护理单元^审批结果^申请流水号^审批前费别代码
/// Others：w ##class(web.DHCINSURegAppr).GetPatientInfo("3")
ClassMethod GetPatientInfo(AdmDr As %String) As %String
{
	s $zt="GetPatientInfoEx"
	q:AdmDr="" "-1^就诊号为空"
	s result=""	
    s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
    q:HospDr="" "-1^院区为空"
    s INSUAdmInfostr= ##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(AdmDr)
    i INSUAdmInfostr<0   d
    .s IsReg="否" 
    .s IsDivide="否"
    e                    d
    .s ActiveFlag=$p(INSUAdmInfostr,"^",12)
    .i (ActiveFlag="A")||(ActiveFlag="O")  d
    ..s IsReg="是"
    ..s CheckFlag=##class(web.DHCINSUPort).CheckBillStatus(AdmDr, "")
    ..i CheckFlag="0"   d
    ...s IsDivide="是"
    ..e                 d
    ...s IsDivide="否"
    .e                                     d
    ..s IsReg="否"
    ..s IsDivide="否"
    s RegStr = $$GetINSURegApprAdmDr^DHCINSURegAppr(AdmDr)
    q:RegStr="" result
	s ApprStas=$p(RegStr,"^",19)                                     //审批结果	
	s Appno=$p($p(RegStr,"^",7),"||",2)	                             //申请流水号             
	s PatientInfo=##class(web.DHCINSUPatInfo).GetPatInfoByAdm(AdmDr)
    q:PatientInfo="" result
	s Regno=$p(PatientInfo,"^",2)
	s Name=$p(PatientInfo,"^",3)
	s Age=$p(PatientInfo,"^",4)
	s Sex=$p(PatientInfo,"^",5)
	s IpNo=$p(PatientInfo,"^",15)
	s PatientStr=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmID(AdmDr) 
	q:PatientStr="" result
    s ApprReaIdCode=$p(PatientStr,"^",28)                     //取费别描述                      
	s ApprReaId=$p(PatientStr,"^",29)                         //取费别
	s Loc=$p(PatientStr,"^",5)
	s Ward= $p(PatientStr,"^",18)
	s result=Regno_"^"_IsReg_"^"_IsDivide_"^"_Name_"^"_Age_"^"_Sex_"^"_ApprReaId_"^"_Loc_"^"_IpNo_"^"_
	         Ward_"^"_ApprStas_"^"_Appno_"^"_ApprReaIdCode	
	q result	
GetPatientInfoEx
 s $zt=""
 b ;
 q "-99^程序异常："_$ze
}

/// Creator：JinShuai1010
/// CreatDate：2023/02/21
/// Description: 根据卡号获取病人的登记号
/// Input：AdmNo:就诊号
/// Output：AdmDr:就诊号
/// Return：AdmDr:就诊号
/// Others：w ##class(web.DHCINSURegAppr).GetAdmInfoByAdmNo("IP0000000026")
ClassMethod GetAdmInfoByAdmNo(AdmNo As %String) As %String
{
	q:AdmNo="" ""
	s rtn=$P( $$GetAdmInfoByAdmNo^DHCINSUPatInfo(AdmNo),"^",1)
	q rtn
}

/// Creator：JinShuai1010
/// CreatDate：2023/01/12
/// Description: 查询病人最新审批信息的ID和申请记录备注
/// Input：AdmDr:就诊号
/// Output：申请记录ID，最新记录的审批ID
/// Others：w ##class(web.DHCINSURegAppr).SelectRegId("68")       
ClassMethod SelectRegId(AdmDr As %String) As %String
{
    s $zt="SelectRegIdEx"
	q:AdmDr="" "-1^就诊号为空"
	s RegID=""
	s result=""
	s AppyId=$O(^INSU.MI.RegApprI("IdxAdmDr",AdmDr,RegID))
	S AppyMemo=$p($$GetINSURegApprById^DHCINSURegAppr(AppyId),"^",17)	 
    f  s RegID=$O(^INSU.MI.RegApprI("IdxAdmDr",AdmDr,RegID))  q:RegID=""  d	 
	 .s Regstr=$$GetINSURegApprById^DHCINSURegAppr(RegID)
	 .s result=$p(Regstr,"^",1)	 
	 q result_"^"_AppyMemo
SelectRegIdEx
 s $zt=""
 b ;SelectRegIdEx
 q "-99^程序异常："_$ze
}

/// Creator：JinShuai1010
/// CreatDate：2023/01/12
/// Description: 查询单个病人审批信息 
/// Input：AdmDr:就诊号
/// Output：病人的审批信息
/// Return：登记审批表ID:RegID,PaadmID:ADMDR,登记号:Regno,住院号:IPRegNo,申请类型:AppType,申请流水号:AppNo,是否登记：IfReg,是否结算：IfAcct,
///         姓名：Name,性别：Sex,年龄：Age,住院科室:LocDr,住院病区:Ward,申请费别:ApprReaId,审批后费别:ChkedReaId,备注:Memo,医疗类别:MedType,
///         生育类别:MatnType,计划生育手术类别:BirCtrlType,病例查看：IllHistory,上传资料：UpFile,审批状态：ApprStas,审批角色：ApprRole,
///         审批日期：ApprDate,审批人：Apprer,申请日期：AppyDate,申请人：Appyer, 审批原因：AppyReason,申请类型代码：AppTypeCodes,,费别代码：ApprReaIdCode,
///         修改后费别代码：ChkedReaIdCode,审批结果代码：ApprStasCode,审批角色代码：ApprRoleCode
/// Others：d ##Class(%ResultSet).RunQuery("web.DHCINSURegAppr","GetRegAppyInfo","7737","2")
Query GetRegAppyInfo(AdmDr As %String, Hosptal As %String) As %Query(ROWSPEC = "RegID:%String,ADMDR:%String,Regno:%String,IPRegNo:%String,AppType:%String,AppNo:%String,IfReg:%String,IfAcct:%String,Name:%String,Sex:%String,Age:%String,LocDr:%String,Ward:%String,ApprReaId:%String,ChkedReaId:%String,Memo:%String,MedType:%String,MatnType:%String,BirCtrlType:%String,IllHistory:%String,UpFile:%String,ApprStas:%String,ApprRole:%String,ApprDate:%String,Apprer:%String,AppyDate:%String,Appyer:%String,AppyReasondesc:%String,AppTypeCode:%String,ApprReaIdCode:%String,ChkedReaIdCode:%String,ApprStasCode:%String,ApprRoleCode:%String,OptUser:%String") [ SqlProc ]
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSURegAppr","GetRegAppyInfo","68","2")
ClassMethod GetRegAppyInfoExecute(ByRef qHandle As %Binary, AdmDr As %String, Hosptal As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)	
	s RegID=""
    f  s RegID=$O(^INSU.MI.RegApprI("IdxAdmDr",AdmDr,RegID),-1) q:RegID=""  d
	.s Regstr=$$GetINSURegApprById^DHCINSURegAppr(RegID)
	.s Reg=$p(Regstr,"^",4)
	.s Regno=Reg
	.s ADMDR=$p(Regstr,"^",2)
	.s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(ADMDR)
	.q:Hosptal'=HospDr
	.s IPRegNo=$p(Regstr,"^",5) //住院号
    .s AppType=$p(Regstr,"^",6) //申请类型
    .s AppTypeCode=AppType
    .s AppType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("app_type00A",AppType,"4",HospDr) //获取申请类型描述
    .s AppNo=$p(Regstr,"^",7) //申请流水号
    .s admdr=$p(Regstr,"^",2) 
    .s Paperstr=##class(web.DHCINSURegAppr).GetPatientInfo(admdr)
    .s IfReg=$p(Paperstr,"^",2)
    .s IfAcct=$p(Paperstr,"^",3)
    .s Name=$p(Paperstr,"^",4)
    .s Sex=$p(Paperstr,"^",5)
    .s Age=$p(Paperstr,"^",6)
    .s LocDr=$p(Regstr,"^",9) //住院科室
    .s Ward=$p(Regstr,"^",10) //住院护理单元
    .s ApprReaId=$p(Regstr,"^",11) //费别
    .s ApprReaIdCode=ApprReaId
    .s AdmReaData=""
    .s:ApprReaId'="" AdmReaData=$g(^PAC("ADMREA",ApprReaId))	
	.s ApprReaId=$p(AdmReaData,"^",2)
    .s ChkedReaId=$p(Regstr,"^",12) //修改后费别
    .s ChkedReaIdCode=ChkedReaId
    .s ChkedAdmReaData=""
    .s:ChkedReaId'="" ChkedAdmReaData=$g(^PAC("ADMREA",ChkedReaId))
    .s ChkedReaId=$p(ChkedAdmReaData,"^",2)
    .s Memo=$p(Regstr,"^",17) //备注
    .s MedType=$p(Regstr,"^",13) //医疗类别
    .s MedType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_type00A",MedType,"4",HospDr)
    .s MatnType=$p(Regstr,"^",14) //生育类别
    .s MatnType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("matn_type00A",MatnType,"4",HospDr)
    .s BirCtrlType=$p(Regstr,"^",15) //计划生育手术类别
    .s BirCtrlType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("birctrl_type00A",BirCtrlType,"4",HospDr)
    .s AppyReason=$p(Regstr,"^",16) //病种审批选项/审批原因
    .s AppyReasonLength=$Length(AppyReason,",")
    .s AppyReasondesc=""
    .b ;AppyReasonLength
    .f i=1:1:AppyReasonLength  d
    ..s ReasonIndex=$p(AppyReason,",",i)   
    ..i ReasonIndex="7"   d
    ...s ReasonMemo=$p(Regstr,"^",17)
    ...s desc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("dise_appr_type00A",ReasonIndex,"4",HospDr)
    ...s AppyReasondesc=AppyReasondesc_","_desc_":"_ReasonMemo
    ..e                   d
    ...s desc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("dise_appr_type00A",ReasonIndex,"4",HospDr)
    ...s AppyReasondesc=AppyReasondesc_","_desc
    .s AppyReasondesc=$Piece(AppyReasondesc,",",2,AppyReasonLength+1)
    .b ;AppyReasondesc
    
    .s AppyReason=##class(web.INSUDicDataCom).GetDicByCodeAndInd("dise_appr_type00A",AppyReason,"4",HospDr)
    .s IllHistory=""
    .s UpFile=""
    .s ApprStas=$p(Regstr,"^",19) //审批结果
    .s ApprStasCode=ApprStas
    .s ApprStas=##class(web.INSUDicDataCom).GetDicByCodeAndInd("appr_stas00A",ApprStas,"4",HospDr)
    .s ApprRole=$p(Regstr,"^",18)   //审批角色
    .s ApprRoleCode=ApprRole
    .s ApprRole=##class(web.INSUDicDataCom).GetDicByCodeAndInd("appr_role00A",ApprRole,"4",HospDr)
    .s ApprDate=$p(Regstr,"^",20)_" "_$p(Regstr,"^",21) //审批日期
    .s Apprer=$p(Regstr,"^",22) //审批人
    .s:Apprer'="" Apprer=$p( ##class(web.DHCINSUBase).GetUserStr(Apprer),"^",1)
    .s AppyDate=$p(Regstr,"^",23)_" "_$p(Regstr,"^",24) //申请日期
    .s OptUser=Apprer
    .s Appyer=$p(Regstr,"^",25) //提交人
    .s:Appyer'="" AppyDate=AppyDate
    .s:Appyer'="" Appyer=$p( ##class(web.DHCINSUBase).GetUserStr(Appyer),"^",1)
    .s OptUser=Appyer
    .d BuildData
   
    Quit $$$OK
BuildData
    s Data=$lb(RegID,ADMDR,Regno,IPRegNo,AppType,AppNo,IfReg,IfAcct,Name,Sex,Age,LocDr,Ward,ApprReaId,ChkedReaId,Memo,MedType,MatnType,BirCtrlType,IllHistory,UpFile,ApprStas,ApprRole,ApprDate,Apprer,AppyDate,Appyer,AppyReasondesc,AppTypeCode,ApprReaIdCode,ChkedReaIdCode,ApprStasCode,ApprRoleCode,OptUser) 
    s ^CacheTemp(repid,ind)=Data  
    s ind=ind+1
    q
}

ClassMethod GetRegAppyInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegAppyInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRegAppyInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegAppyInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

}
