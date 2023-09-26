/// 医保医师信息操作类
/// DingSH
/// 2018-9-25
Class web.DHCINSUCareProvCtl Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 保存
/// w ##class(web.DHCINSUCareProvCtl).Save("1^1049^关再凤^2^^男^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^1^2018-12-18^11:10:20^^^^^")
ClassMethod Save(InString As %String) As %String
{
	
	n (InString,%session)
	q:InString="" "-1^入参串为空"
	s hospdr=""
	s:($g(%session)'="") hospdr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s Id=$P(InString,"^",1)
	i +Id=0 d
	.s Id=..CheckCareProv($P(InString,"^",2),hospdr)
	.s $P(InString,"^",1) = Id

	i +Id=0 d
	.s obj=##class(User.INSUCareProvInfo).%New()
	e  d
	.;s obj=##class(User.INSUCareProvInfo).%OpenId(Id)
	.s obj=##class(User.INSUCareProvInfo).%OpenId(Id,0)	;upt 20220610 HanZH
	;b ;0
	s obj.INCPICPCode=$P(InString,"^",2)                 ;	医师编号
    s obj.INCPICPName=$P(InString,"^",3)                 ;	医师名称
    s obj.INCPIIDType=$P(InString,"^",4)                 ;	证件类型
    s obj.INCPIIDNo=$P(InString,"^",5)                   ;	证件号码
    s obj.INCPISex=$P(InString,"^",6)                    ;	性别
    s obj.INCPINation=$P(InString,"^",7)                 ;	民族
    s obj.INCPIBOD=$P(InString,"^",8)                    ;  出生日期
    s obj.INCPITelNo=$P(InString,"^",9)                  ;  联系电话
       
    ;i +$P(InString,"^",10) >0 d
    ;.s objLoc=##class(User.CTLoc).%OpenId($P(InString,"^",10))
    ;e  d
    ;.s objLoc="" ;##class(User.CTLoc).%New()
    ;s obj.INCPIDeptDr=objLoc                              ;	科室Dr
    do obj.INCPIDeptDrSetObjectId($P(InString,"^",10))	  ; 科室Dr	upt 20220610 HanZH
    s obj.INCPIDeptCode=$P(InString,"^",11)               ; 科室编码
    s obj.INCPIDeptDesc=$P(InString,"^",12)               ; 科室名称
    
    s obj.INCPIJobTitle=$P(InString,"^",13)               ;	职称(级别)
    s obj.INCPIAdminPost=$P(InString,"^",14)              ; 行政职务
    s obj.INCPIAcadePost=$P(InString,"^",15)              ;	学术职务
    s obj.INCPICollege=$P(InString,"^",16)                ;	毕业院校
    s obj.INCPIEducation=$P(InString,"^",17)              ;	学历
    s obj.INCPIProfession=$P(InString,"^",18)             ;	所学专业
    s obj.INCPIPatType=$P(InString,"^",19)                ;	医院人员类别
    s obj.INCPIAppoitNo=$P(InString,"^",20)               ;	医院聘书编码
    
    s obj.INCPIMSQCNo=$P(InString,"^",21)                 ;	资格证书编码
    s obj.INCPIMSQCMajor=$P(InString,"^",22)              ;	资格证专业
    s obj.INCPIMSQCType=$P(InString,"^",23)               ;	资格证类别
    
    s obj.INCPIMCNo=$P(InString,"^",24)                   ;	执业证书编码
    s obj.INCPIMCType=$P(InString,"^",25)                 ;	执业类别
    s obj.INCPIMCMajor=$P(InString,"^",26)                ;	执业范围(专业)
    s:$P(InString,"^",27)'="" $P(InString,"^",27)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",27))   
    s:$P(InString,"^",28)'="" $P(InString,"^",28)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",28))  
    s obj.INCPIMSQCStDate=$P(InString,"^",27)             ;	执业开始时间
    s obj.INCPIMSQCEdDate=$P(InString,"^",28)             ;	执业结束时间
    
    s obj.INCPIMajorDiags=$P(InString,"^",29)               ;	主治疾病内容
    s obj.INCPIMajorDiagType=$P(InString,"^",30)               ;	疾病种类
    s obj.INCPIMSQCRegDate=$P(InString,"^",31)               ;	执业证书注册日期
    s obj.INCPIMSQCMultiFlag=$P(InString,"^",32)               ;	是否多点执业
    s obj.INCPIMSQCAddr1=$P(InString,"^",33)               ;	第一执业地点
    s obj.INCPIMSQCAddr2=$P(InString,"^",34)               ;	第二执业地点
    s obj.INCPIMSQCAddr3=$P(InString,"^",35)               ;	第三执业地点
    s obj.INCPIMSQCAddrN=$P(InString,"^",36)               ;	其他执业注册地 可填写多个,以|隔开
    s obj.INCPIDoctLevel=$P(InString,"^",37)               ;	医师级别
    s obj.INCPINurseLevel=$P(InString,"^",38)               ;	护师级别
    s obj.INCPIMediPrescFlag=$P(InString,"^",39)               ;	医保处方权
    s obj.INCPIOpTsPrescFlag=$P(InString,"^",40)               ;	门诊特殊病开单标识
    s obj.INCPIInsuDoctFlag=$P(InString,"^",41)               ;	医保医师标识
    s:$P(InString,"^",42)'="" $P(InString,"^",42)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",42))   
    s:$P(InString,"^",43)'="" $P(InString,"^",43)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",43)) 
 
    s obj.INCPIStDate=$P(InString,"^",42)               ;	备案开始日期
    s obj.INCPIEdDate=$P(InString,"^",43)               ;	备案结束日期
    
    s obj.INCPIActFlag=$P(InString,"^",44)               ;	有效标识
    s obj.INCPIMediPatype=$P(InString,"^",45)               ;	卫生技术人员类别
   
   
    ;i +$P(InString,"^",46) >0 d
    ;.s objUser=##class(User.SSUser).%OpenId($P(InString,"^",46))
    ;e  d
    ;.s objUser=##class(User.SSUser).%New()
    ;s obj.INCPIUserDr=objUser                            ;	经办人
    do obj.INCPIUserDrSetObjectId($P(InString,"^",46))	  ; 经办人	upt 20220610 HanZH
    
    s:$P(InString,"^",47)'="" $P(InString,"^",47)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",47))
    s:$P(InString,"^",48)'="" $P(InString,"^",48)=$zth($P(InString,"^",48))
    s:$P(InString,"^",47)="" $P(InString,"^",47)=+$H
    s:$P(InString,"^",48)="" $P(InString,"^",48)=$P($H,",",2)
    s obj.INCPIDate=$P(InString,"^",47)                  ;	经办日期
    s obj.INCPITime=$P(InString,"^",48)                  ;	经办时间
    s obj.INCPIExtStr01=$P(InString,"^",49)              ;	扩展01
    s obj.INCPIExtStr02=$P(InString,"^",50)              ;	扩展02
    s obj.INCPIExtStr03=$P(InString,"^",51)              ;	扩展03
    s obj.INCPIExtStr04=$P(InString,"^",52)              ;	扩展04
    s obj.INCPIExtStr05=$P(InString,"^",53)              ;	扩展05
    s:hospdr="" hospdr=$P(InString,"^",54)
    s obj.INCPIHospDr =hospdr
    s status=obj.%Save()
    s Id=obj.%Id()
    
    s ErrMsg=""
    If $$$ISERR(status)  Do DecomposeStatus^%apiOBJ(status,.err,"-d") For i=1:1:err s ErrMsg=ErrMsg_err(i) 
    q:ErrMsg'="" "-1^保存医保医师信息表失败Err:"_ErrMsg
 
    ;b ;1
    d obj.%Close()
	
    q Id
}

/// 同步生成医师信息
/// w ##class(web.DHCINSUCareProvCtl).SynBuildINCPInfo("","","",1,"2","")
ClassMethod SynBuildINCPInfo(InRowid, CPCode, CPDesc, UserDr, HospDr, ExpStr) As %String
{
	n (InRowid,CPCode, CPDesc,UserDr,HospDr,ExpStr,%session)
	b ;00
	s Flag=-1,SuccNum=0,FailNum=0
	q:HospDr="" "-1!入参医院指针不能为空"
	s GroupHospId=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_CareProvInfo",HospDr)
	//s HospDr=""
	s ^TEMP("SYNBCP")=InRowid_","_CPCode_","_CPDesc_","_UserDr_","_HospDr_","_ExpStr
	if ((InRowid="")||(CPCode="")||(CPDesc=""))
	{
		s Flag=0
	}
	
	if InRowid'=""
	{
	s tmpINRowid=InRowid		
	s tCPCode=$P(^DHCINCPI(InRowid),"^",1)
	s tCPCode=$$ALPHAUP^SSUTIL4(tCPCode)
	s id=""
	s id=$O(^CTPCP(0,"Code",tCPCode,""),-1)
	If ##class(User.CTCareProv).%ExistsId(id)
	{
	   ;s objCP=##class(User.CTCareProv).%OpenId(id)
	   s objCP=##class(User.CTCareProv).%OpenId(id,0)	;upt 20220610 HanZH
	   s HospChildsub=0,TFlag="N"
	   f  s HospChildsub=$O(^CTPCP(id,"HOSP",HospChildsub))  q:(HospChildsub="")!(TFlag="Y")  d
	   .s tHospDr = $P(^CTPCP(id,"HOSP",HospChildsub),"^",1)
	   .q:tHospDr'=GroupHospId
	   .s TFlag="Y"
	   s tHospDr=""
	   q:TFlag="N"
     }
	d BuildCP
	s Flag=1
		
	}
	
    if CPCode'="" {
	 s id=""
	 s CPCode1=$$ALPHAUP^SSUTIL4(CPCode)
     for 
     {
	     s id=$O(^CTPCP(0,"Code",CPCode1,id))
	     q:id=""
	     b ;01
	     If ##class(User.CTCareProv).%ExistsId(id)
	     {
		    ;s objCP=##class(User.CTCareProv).%OpenId(id)
	   		s objCP=##class(User.CTCareProv).%OpenId(id,0)	;upt 20220610 HanZH
		    s rowid="",tmpINRowid=""
		    s rowid=$O(^DHCINCPI("0","CPCode",CPCode1,""),-1)
		    s tmpINRowid=rowid
		    s HospChildsub=0,TFlag="N"
	        f  s HospChildsub=$O(^CTPCP(id,"HOSP",HospChildsub))  q:(HospChildsub="")!(TFlag="Y")  d
		    .s tHospDr = $P(^CTPCP(id,"HOSP",HospChildsub),"^",1)
		    .q:tHospDr'=GroupHospId
		    .s TFlag="Y"
		    s tHospDr=""
		    Continue:TFlag="N"
		  }
		  ;b ;0001
		  d BuildCP
	      s Flag=1
	  }
     
   
    }
     
     if CPDesc'="" {
	 s id=""
	 s CPDesc1=$$ALPHAUP^SSUTIL4(CPDesc)
     for 
     {
	     s id=$O(^CTPCP(0,"Desc",CPDesc1,id))
	     q:id=""
	     If ##class(User.CTCareProv).%ExistsId(id)
	     {
		    ;s objCP=##class(User.CTCareProv).%OpenId(id)
	   		s objCP=##class(User.CTCareProv).%OpenId(id,0)	;upt 20220610 HanZH
		    s rowid="",tmpINRowid=""
		     s rowid=$O(^DHCINCPI("0","CPDesc",CPDesc1,""),-1)
		    s tmpINRowid=rowid
		    s HospChildsub=0,TFlag="N"
	        f  s HospChildsub=$O(^CTPCP(id,"HOSP",HospChildsub))  q:(HospChildsub="")!(TFlag="Y")  d
		    .s tHospDr = $P(^CTPCP(id,"HOSP",HospChildsub),"^",1)
		    .q:tHospDr'=GroupHospId
		    .s TFlag="Y"
		    s tHospDr=""
		    Continue:TFlag="N"
		  }
		  d BuildCP
	      s Flag=1
	  }
     
   
    }
    
    //全部同步
    b ;00
    i +Flag=0
    {   s id=""
	    for  
        {
	      s id=$O(^CTPCP(id)) 
	      q:id=""
	     If ##class(User.CTCareProv).%ExistsId(id)
	     {
		    ;s objCP=##class(User.CTCareProv).%OpenId(id)
	   		s objCP=##class(User.CTCareProv).%OpenId(id,0)	;upt 20220610 HanZH
		   
		  
		    s tCPCode=$$ALPHAUP^SSUTIL4(objCP.CTPCPCode)
		    s rowid="",tmpINRowid=""
		    s rowid=$O(^DHCINCPI("0","CPCode",tCPCode,""),-1)
		    s tmpINRowid=rowid
		    s HospChildsub=0,TFlag="N"
	        f  s HospChildsub=$O(^CTPCP(id,"HOSP",HospChildsub))  q:(HospChildsub="")!(TFlag="Y")  d
		    .s tHospDr = $P(^CTPCP(id,"HOSP",HospChildsub),"^",1)
		    .q:tHospDr'=GroupHospId
		    .s TFlag="Y"
		    Continue:TFlag="N"
		    d BuildCP
	        s Flag=1
		  }
	  }
	    
	 }
     
	
	q 0_"!总共:"_(SuccNum+FailNum)_",成功:"_SuccNum_",失败:"_FailNum
BuildCP
 s InStr="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    ;+2019-7-30 tangzf 医院授权判断 start
    //s TmpHospital=""
    //s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("CT_CareProv",id,"",TmpHospital,"Y")
	//q:(CheckHosipitalSession'="Y") ; 该院区无权查看该数据
	;+2019-7-30 tangzf 医院授权判断 end
 q:objCP.CTPCPCode=""  
 b ;ww
 s $P(InStr,"^",1)=tmpINRowid
 s $P(InStr,"^",2)=objCP.CTPCPCode         ;01-医师编号
 s $P(InStr,"^",3)=objCP.CTPCPDesc         ;02-医师姓名
 s $P(InStr,"^",4)="01"                    ;03-证件类型 
 s $P(InStr,"^",5)=""                      ;04-证件号码
 s $P(InStr,"^",6)=""                      ;05-性别
 s $P(InStr,"^",7)=""                      ;06-民族
 s $P(InStr,"^",8)=objCP.CTPCPDOB          ;07-出生日期
 s $P(InStr,"^",9)=""                      ;08-联系电话
 s $P(InStr,"^",10)=""                     ;09-科室Dr
 s $P(InStr,"^",11)=""                     ;10-科室编码
 s $P(InStr,"^",12)=""                     ;11-科室名称
 s $P(InStr,"^",13)=objCP.CTPCPTitle       ;12-职称（级别）
 s $P(InStr,"^",14)=""                     ;13-行政职务
 s $P(InStr,"^",15)=""                     ;14-学术职务
 s $P(InStr,"^",16)=""                     ;15-毕业院校
 s $P(InStr,"^",17)=""                     ;16-学历
 s $P(InStr,"^",18)=""                     ;17-所学专业
 s $P(InStr,"^",19)=""                     ;18-医院人员类别
 s $P(InStr,"^",20)=""                     ;19-医院聘书编号
 s $P(InStr,"^",21)=""                     ;20-资格证书编码
 s $P(InStr,"^",22)=""                     ;21-资格证专业
 s $P(InStr,"^",23)=""                     ;22-资格证类别
 s $P(InStr,"^",24)=objCP.CTPCPSMCNo       ;23-执业证书编码
 s $P(InStr,"^",25)=""                     ;24-执业类别
 s $P(InStr,"^",26)=""                     ;25-执业范围（专业）
 s $P(InStr,"^",27)=""                      ;26-执业开始时间
 s $P(InStr,"^",28)=""                     ;27-执业结束时间
 s $P(InStr,"^",29)=""                     ;28-主治疾病内容
 s $P(InStr,"^",30)=""                     ;29-疾病种类
 s $P(InStr,"^",31)=""                      ;30-执业证书注册日期
 s $P(InStr,"^",32)=""                     ;31-是否多点执业
 s $P(InStr,"^",33)=""                    ;32-第一执业地点
 s $P(InStr,"^",34)=""                     ;33-第二执业地点
 s $P(InStr,"^",35)=""                    ;34-第三执业地点
 s $P(InStr,"^",36)=""                     ;35-其它执业注册地
 s $P(InStr,"^",37)=objCP.CTPCPLevel                      ;36-医师级别
 s $P(InStr,"^",38)=""                         ;37-护师级别
 s $P(InStr,"^",39)=""                         ;38-医保处方权
 s $P(InStr,"^",40)=""                         ;39-门诊特殊病开单标志
 s $P(InStr,"^",41)=""                         ;40-医保医师标志
 s $P(InStr,"^",42)=""                         ;41-备案开始日期
 s $P(InStr,"^",43)=""                         ;42-备案结束日期
 s $P(InStr,"^",44)=""                         ;43-有效标志
 s $P(InStr,"^",45)=""                         ;44-卫生技术人员类别
 s $P(InStr,"^",46)=UserDr                     ;45-经办人
 s $P(InStr,"^",47)=""                         ;46-经办日期
 s $P(InStr,"^",48)=""                         ;47-经办时间
 s $P(InStr,"^",39)=$P($g(ExpStr),"^",2)       ;48-扩展01
 s $P(InStr,"^",50)=$P($g(ExpStr),"^",3)       ;49-扩展02
 s $P(InStr,"^",51)=$P($g(ExpStr),"^",4)       ;50-扩展03
 s $P(InStr,"^",52)=$P($g(ExpStr),"^",5)       ;51-扩展04
 s $P(InStr,"^",53)=$P($g(ExpStr),"^",6)       ;52-扩展05
 s $P(InStr,"^",54)=GroupHospId                ;53-院区
 s NId=""     
 s NId=..Save(InStr)
 //b ;save
 i (+NId>0)
  {
   s SuccNum=SuccNum+1
   }
  else 
  {
	 s FailNum=FailNum+1
   }
 d objCP.%Close()
 q
}

/// 查询科室信息(Query) 
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUCareProvCtl","QryInCPInfo","","","2")
Query QryInCPInfo(InRowid As %String, KeyWords As %String, HospDr As %String) As %Query(ROWSPEC = "TInd,TRowid,TCPCode::医师编号,TCPName::医师姓名,TIDType::证件类型,TIDTypeDesc::证件类型描述,TIDNo::证件号码,TSex::性别,TNation::民族,TBOD::出生日期,TTelNo::联系电话,TDeptDr::科室Dr,TDeptCode::科室编码,TDeptDesc::科室名称,TJobTitle::职称,TAdminPost::行政职务,TAcadePost::学术职务,TCollege::毕业院校,TEducation::学历,TProfession::专业,TPatType::人员类别,TAppoitNo::医院聘书编码,TMSQCNo::资格证书编码,TMSQCMajor::资格证专业,TMSQCType::资格证类别,TMCNo::执业证书编码,TMCType::执业类别,TMCMajor::执业专业,TMSQCStDate::执业开始时间,TMSQCEdDate::执业结束时间,TMajorDiags::主治疾病内容,TMajorDiagType::疾病种类,TMSQCRegDate::执业证书注册日期,TMSQCMultiFlag::是否多点执业,TMSQCAddr1::第一执业地点,TMSQCAddr2::第二执业地点,TMSQCAddr3::第三执业地点,TMSQCAddrN::其它执业注册地,TDoctLevel::医师级别,TNurseLevel::护师级别,TMediPrescFlag::医保处方权,TOpTsPrescFlag::门诊特殊病开单标志,TInsuDoctFlag::医保医师标志,TStDate::备案开始日期,TEdDate::备案结束日期,TActFlag::有效标志,TMediPatype::卫生技术人员类别,TUserDr::经办人Dr,TUserCode::经办人工号,TUserName::经办人,TDate::经办日期,TTime::经办时间,TExtStr01::扩展01,TExtStr02::扩展02,TExtStr03::扩展03,TExtStr04::扩展04,TExtStr05::扩展05,THospDr::院区ID")
{
}

ClassMethod QryInCPInfoExecute(ByRef qHandle As %Binary, InRowid As %String, KeyWords As %String, HospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	s ^TEMP("QCP")=InRowid_"^"_KeyWords_"^"_HospDr
   s GroupHospId=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_CareProvInfo",HospDr)
   s Flag=""
   if InRowid'=""
	{		
	If ##class(User.INSUCareProvInfo).%ExistsId(InRowid)
	{
	   ;s objInCP=##class(User.INSUCareProvInfo).%OpenId(InRowid)
	   s objInCP=##class(User.INSUCareProvInfo).%OpenId(InRowid,0)	;upt 20220610 HanZH
		     
     }
	d BuildQryCP
	s Flag=1	
	}
	
    if ((KeyWords'="")&&(+Flag=0)) {
	
	 s CPCode1=$$ALPHAUP^SSUTIL4(KeyWords)
	 s tCPCode=""
     for 
     {    
	      s tCPCode=$O(^DHCINCPI(0,"CPCode",tCPCode))
	      q:tCPCode=""
	      CONTINUE:tCPCode'[CPCode1
	      s id=""
	      for{   
		  s id=$O(^DHCINCPI(0,"CPCode",tCPCode,id))
	      q:id=""
	     If ##class(User.INSUCareProvInfo).%ExistsId(id)
	      {
	        ;s objInCP=##class(User.INSUCareProvInfo).%OpenId(id)
	   		s objInCP=##class(User.INSUCareProvInfo).%OpenId(id,0)	;upt 20220610 HanZH
		     
           }
		  d BuildQryCP
	      s Flag=1
	  }
     }
	  
	  if (+Flag=0)
	  {
		s CPDesc1=$$ALPHAUP^SSUTIL4(KeyWords)
		s tCPDesc=""  
	   for 
       {    
          
	      s tCPDesc=$O(^DHCINCPI(0,"CPDesc",tCPDesc))
	      q:tCPDesc=""
	      CONTINUE:tCPDesc'[CPDesc1
	      s id=""
	      for{   
	      
		  s id=$O(^DHCINCPI(0,"CPDesc",tCPDesc,id))
	      q:id=""
	 
	     If ##class(User.INSUCareProvInfo).%ExistsId(id)
	      {
	        ;s objInCP=##class(User.INSUCareProvInfo).%OpenId(id)
	   		s objInCP=##class(User.INSUCareProvInfo).%OpenId(id,0)	;upt 20220610 HanZH
		     
           }
		  d BuildQryCP
	      s Flag=1
	  }
		  ;b ;1
	  }
     
	 } 
	 
	 
	  if (+Flag=0)
	  {
		s PYMKeyWords=$$ALPHAUP^SSUTIL4(KeyWords)
		s tCPDesc=""  
	   for 
       {    
	      s tCPDesc=$O(^DHCINCPI(0,"CPDesc",tCPDesc))
	      q:tCPDesc=""
	      s pym=##class(web.DHCINSUPort).GetCNCODE(tCPDesc,4 ,"")
	      CONTINUE:pym'[PYMKeyWords
	      s id=""
	      for{   
	    
		  s id=$O(^DHCINCPI(0,"DeptDesc",tCPDesc,id))
	      q:id=""
	     If ##class(User.INSUCareProvInfo).%ExistsId(id)
	      {
	        ;s objInCP=##class(User.INSUCareProvInfo).%OpenId(id)
	  		s objInCP=##class(User.INSUCareProvInfo).%OpenId(id,0)	;upt 20220610 HanZH
		     
           }
		  d BuildQryCP
	      s Flag=1
	  }
		  
	  }
     
	 }    
	   
    }
    

    if ((InRowid="")&&(KeyWords=""))
    {
	    s id=0
	    for{
		    s id=$O(^DHCINCPI(id))
		    q:id=""
	      If ##class(User.INSUCareProvInfo).%ExistsId(id)
	     {
		   	;s objInCP=##class(User.INSUCareProvInfo).%OpenId(id)
	   		s objInCP=##class(User.INSUCareProvInfo).%OpenId(id,0)	;upt 20220610 HanZH
		    ;Continue:'$IsObject(objInLoc.INLCIDeptDr)
		    ;s tHospDr=""
		    ;s DeptDr=objInLoc.INLCIDeptDr.%Id()
		    ;s:DeptDr'="" tHospDr=$P(^CTLOC(DeptDr),"^",22)
		    ;b ;002
	        ;Continue:tHospDr'=HospDr 
		    d BuildQryCP
		    
		    }
	    }
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
    
BuildQryCP 
 	s (TRowid,TCPCode,TCPName,TIDType,TIDTypeDesc,TIDNo,TSex,TNation,TBOD,TTelNo,TDeptDr,TDeptCode,TDeptDesc,TJobTitle,TAdminPost,TAcadePost,TCollege,TEducation,TProfession,TPatType,TAppoitNo,TMSQCNo,TMSQCMajor,TMSQCType,TMCNo,TMCType,TMCMajor,TMSQCStDate,TMSQCEdDate,TMajorDiags,TMajorDiagType,TMSQCRegDate,TMSQCMultiFlag,TMSQCAddr1,TMSQCAddr2,TMSQCAddr3,TMSQCAddrN,TDoctLevel,TNurseLevel,TMediPrescFlag,TOpTsPrescFlag,TInsuDoctFlag,TStDate,TEdDate,TActFlag,TMediPatype,TUserDr,TUserCode,TUserName,TDate,TTime,TExtStr01,TExtStr02,TExtStr03,TExtStr04,TExtStr05,THospDr)=""
    s TRowid=objInCP.%Id()
    s TCPCode=objInCP.INCPICPCode
    s TCPName=objInCP.INCPICPName 
    s TIDType=objInCP.INCPIIDType
    s TIDTypeDesc=objInCP.INCPIIDType
    s:TIDType="01" TIDTypeDesc="身份证"
    s TIDNo=objInCP.INCPIIDNo
    s TSex=objInCP.INCPISex
    s TNation=objInCP.INCPINation
    s TBOD=objInCP.INCPIBOD
    s TTelNo=objInCP.INCPITelNo
    
    if $IsObject(objInCP.INCPIDeptDr) d
    .s TDeptDr=objInCP.INCPIDeptDr.%Id() 
    
    s TDeptCode=objInCP.INCPIDeptCode
    s TDeptDesc=objInCP.INCPIDeptDesc
    s TJobTitle=objInCP.INCPIJobTitle
    s TAdminPost=objInCP.INCPIAdminPost
    s TAcadePost=objInCP.INCPIAcadePost
    s TCollege=objInCP.INCPICollege
    s TEducation=objInCP.INCPIEducation
    s TProfession=objInCP.INCPIProfession
    s TPatType=objInCP.INCPIPatType
    s TAppoitNo=objInCP.INCPIAppoitNo
    s TMSQCNo=objInCP.INCPIMSQCNo
    s TMSQCMajor=objInCP.INCPIMSQCMajor
    s TMSQCType=objInCP.INCPIMSQCType
    s TMCNo=objInCP.INCPIMCNo
    s TMCType=objInCP.INCPIMCType
    s TMCMajor=objInCP.INCPIMCMajor
    s TMSQCStDate=objInCP.INCPIMSQCEdDate
    s:+TMSQCStDate'=0 TMSQCStDate=##class(websys.Conversions).DateLogicalToHtml(TMSQCStDate) 
    s TMSQCEdDate=objInCP.INCPIMSQCEdDate
    s:+TMSQCEdDate'=0 TMSQCEdDate=##class(websys.Conversions).DateLogicalToHtml(TMSQCEdDate) 
    s TMajorDiags=objInCP.INCPIMajorDiags
    s TMajorDiagType=objInCP.INCPIMajorDiagType
    s TMSQCRegDate=objInCP.INCPIMSQCRegDate
    s TMSQCMultiFlag=objInCP.INCPIMSQCMultiFlag
    s TMSQCAddr1=objInCP.INCPIMSQCAddr1
    s TMSQCAddr2=objInCP.INCPIMSQCAddr2
    s TMSQCAddr3=objInCP.INCPIMSQCAddr3
    s TMSQCAddrN=objInCP.INCPIMSQCAddrN
    s TDoctLevel=objInCP.INCPIDoctLevel
    s TNurseLevel=objInCP.INCPINurseLevel
    s TMediPrescFlag=objInCP.INCPIMediPrescFlag
    s TOpTsPrescFlag=objInCP.INCPIOpTsPrescFlag
    s TInsuDoctFlag=objInCP.INCPIInsuDoctFlag
    s TStDate=objInCP.INCPIStDate
    s:+TStDate'=0 TStDate=##class(websys.Conversions).DateLogicalToHtml(TStDate)   
    s TEdDate=objInCP.INCPIEdDate
    s:+TEdDate'=0 TEdDate=##class(websys.Conversions).DateLogicalToHtml(TEdDate)   
    s TActFlag=objInCP.INCPIActFlag 
    s TMediPatype=objInCP.INCPIMediPatype
    if $IsObject(objInCP.INCPIUserDr) d
    .s TUserDr=objInCP.INCPIUserDr.%Id()
    .s TUserCode=objInCP.INCPIUserDr.SSUSRInitials
    .s TUserName=objInCP.INCPIUserDr.SSUSRName
    s TDate=##class(websys.Conversions).DateLogicalToHtml(objInCP.INCPIDate) 
    s TTime=$zt(objInCP.INCPITime)
    s TExtStr01=objInCP.INCPIExtStr01
    s TExtStr02=objInCP.INCPIExtStr02
    s TExtStr03=objInCP.INCPIExtStr03
    s TExtStr04=objInCP.INCPIExtStr04
    s TExtStr05=objInCP.INCPIExtStr05
  	;+2019-7-30 tangzf 医院授权判断 start
  	//s TmpHospital=objInCP.INCPIHospDr
	//s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("INSU_CareProvInfo",TRowid,"",TmpHospital)
	//q:(CheckHosipitalSession'="Y") ; 该院区无权查看该数据
	;+2019-7-30 tangzf 医院授权判断 end
    s THospDr=objInCP.INCPIHospDr //DingSH 20201115
	q:GroupHospId'=THospDr
    d BuildCPQry
    q 

BuildCPQry
    set Data=$lb(i,TRowid,TCPCode,TCPName,TIDType,TIDTypeDesc,TIDNo,TSex,TNation,TBOD,TTelNo,TDeptDr,TDeptCode,TDeptDesc,TJobTitle,TAdminPost,TAcadePost,TCollege,TEducation,TProfession,TPatType,TAppoitNo,TMSQCNo,TMSQCMajor,TMSQCType,TMCNo,TMCType,TMCMajor,TMSQCStDate,TMSQCEdDate,TMajorDiags,TMajorDiagType,TMSQCRegDate,TMSQCMultiFlag,TMSQCAddr1,TMSQCAddr2,TMSQCAddr3,TMSQCAddrN,TDoctLevel,TNurseLevel,TMediPrescFlag,TOpTsPrescFlag,TInsuDoctFlag,TStDate,TEdDate,TActFlag,TMediPatype,TUserDr,TUserCode,TUserName,TDate,TTime,TExtStr01,TExtStr02,TExtStr03,TExtStr04,TExtStr05,tHospDr)
 	Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	q
}

ClassMethod QryInCPInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInCPInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInCPInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInCPInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 描述： .Net获取待上传医师和记录信息
///  output:进程号^待上传记录条数
ClassMethod QryCareProvAndRecInfo(InRowid, InRecRowid, InsuType, Flag, ExpStr) As %String
{
}

/// 描述：根据进程号和序号获取医师和记录信息
/// outpur:医师信息|医师记录信息$医师记录信息
ClassMethod GetCareProvAndRecInfoFromCachetmp(JobId, index) As %String
{
}

/// w ##class(web.DHCINSUCareProvCtl).CheckCareProv("HS02",2)
ClassMethod CheckCareProv(CPCode, HospDr) As %String
{
	
	 n (CPCode,HospDr)
	 s INRowid = "",id=""
	 s CPCode1=$$ALPHAUP^SSUTIL4(CPCode)
     for 
     {
	        s id=$O(^CTPCP(0,"Code",CPCode1,id))
	        q:(id="")!(+INRowid'=0)
		    s rowid=""
		    s rowid=$O(^DHCINCPI("0","CPCode",CPCode1,""),-1)
		    Continue:+rowid=0
		    s tHospDr=$P($g(^DHCINCPI(rowid)),"^",53)
		    if (tHospDr="") {
			    s dpid=$P($g(^CTPCP(id,3)),"^",3) 
			    s:dpid'="" tHospDr=$P(^CTLOC(dpid),"^",22)
			    }
	        Continue:(tHospDr'=HospDr) 
	        s INRowid=rowid
     }
	q INRowid
}

}
