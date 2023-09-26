/// 医保科室信息操作类
/// DingSH
/// 2018-9-25
Class web.DHCINSULocInfoCtl Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 保存
/// w ##class(web.DHCINSULocInfoCtl).Save("^FYLC020^肝胆外科[分院]^2^1101^1101^179^50^60^20^20^15^15^30^韩梅梅^18939067660^康康^18700990001^0^1^1^1009^2016-01-12^13:00:09^^^1^1^^^^^^^^")
/// w ##class(web.DHCINSULocInfoCtl).Save("3^ZYJZ003^急诊儿科门诊^1^儿科专业^A50.04^41^0^0^2022-06-01^0^0^0^0^admin^13012344321^^^^^^^H36011100214^2019-01-01^^^^1^1^2022-06-15^15:45:45^^急诊^^^^^2")
ClassMethod Save(InString As %String) As %String
{
	n (InString)
	q:InString="" "-1^入参串为空"
	s hospdr=""
	s:($g(%session)'="") hospdr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s Id=$P(InString,"^",1)
	i +Id=0 d
	.s Id=..CheckInLocInfo($P(InString,"^",2),hospdr)
	.s $P(InString,"^",1) = Id
	i +Id=0 d
	.s obj=##class(User.INSULocInfo).%New()
	e  d
	.;s obj=##class(User.INSULocInfo).%OpenId(Id)
	.s obj=##class(User.INSULocInfo).%OpenId(Id,0)	;upt 20220609 HanZH
	;b ;0
	s obj.INLCIDeptCode=$P(InString,"^",2)               ;	医院科室编码
    s obj.INLCIDeptDesc=$P(InString,"^",3)               ;	医院科室名称
    s obj.INLCIDeptType=$P(InString,"^",4)               ;	科室类型
    s obj.INLCIStandDeptCode=$P(InString,"^",5)          ;	标准科室编码
    s obj.INLCIProfessionDeptCode=$P(InString,"^",6)     ;	专业科室代码 
    ;i +$P(InString,"^",7) >0 d
    ;.s objLoc=##class(User.CTLoc).%OpenId($P(InString,"^",7))
    ;e  d
    ;.s objLoc=##class(User.CTLoc).%New()
    ;s obj.INLCIDeptDr=objLoc                            ;	科室Dr
    do obj.INLCIDeptDrSetObjectId($P(InString,"^",7))	 ; 科室Dr	upt 20220609 HanZH
    s obj.INLCISPBedNum=$P(InString,"^",8)               ; 批准床位数量
    s obj.INLCISJBedNum=$P(InString,"^",9)               ;	实际开放床位数量
    s obj.INLCIDeptSetUpDate=$P(InString,"^",10)         ;	科室成立时间
    s obj.INLCIDoctorNum=$P(InString,"^",11)             ;	医师数量
    s obj.INLCITechnicianNum=$P(InString,"^",12)          ;	技师数量
    s obj.INLCIPharmacistNum=$P(InString,"^",13)         ;	药师数量
    s obj.INLCINurseNum=$P(InString,"^",14)              ;	护理人员数量
    s obj.INLCIDeptHead=$P(InString,"^",15)              ;	科室负责人
    s obj.INLCIDeptHeadTelNo=$P(InString,"^",16)         ;	科室负责人联系电话
    s obj.INLCINurseHead=$P(InString,"^",17)             ;	病区护士长姓名
    s obj.INLCINurseHeadTelNo=$P(InString,"^",18)        ;	病区护士长联系电话
    s obj.INLCIIsKeyDept=$P(InString,"^",19)             ;	是否重点科室
    s obj.INLCIKeyDeptLevel=$P(InString,"^",20)          ;	重点科室等级
    s obj.INLCIIsAllowFee=$P(InString,"^",21)            ;	该科室是否发生费用
    s obj.INLCIHospCode=$P(InString,"^",22)              ;	医院机构编码
    s:$P(InString,"^",23)'="" $P(InString,"^",23)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",23))  
    s:$P(InString,"^",24)'="" $P(InString,"^",24)=$zth($P(InString,"^",24))
    s:$P(InString,"^",23)="" $P(InString,"^",23)=+$H
    s:$P(InString,"^",24)="" $P(InString,"^",24)=$P($H,",",2)
    s:$P(InString,"^",25)'="" $P(InString,"^",25)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",25)) 
    s:$P(InString,"^",26)'="" $P(InString,"^",26)=$zth($P(InString,"^",26))
    s obj.INLCIStDate=$P(InString,"^",23)                ;	开始日期
    s obj.INLCIStTime=$P(InString,"^",24)                ;	开始时间
    i $P(InString,"^",25)'="" d
    .s obj.INLCIEdDate=$P(InString,"^",25)                ;	结束日期
    i $P(InString,"^",26)'="" d
    .s obj.INLCIEdTime=$P(InString,"^",26)                ;	结束时间
    s obj.INLCIActFlag=$P(InString,"^",27)               ;	有效标志
    //b ;0
    ;i +$P(InString,"^",28) >0 d
    ;.s objUser=##class(User.SSUser).%OpenId($P(InString,"^",28))
    ;e  d
    ;.s objUser=##class(User.SSUser).%New()
    ;s obj.INLCIUserDr=objUser                            ;	经办人
    do obj.INLCIUserDrSetObjectId($P(InString,"^",28))	 ;	经办人	upt 20220609 HanZH
    s:$P(InString,"^",29)'="" $P(InString,"^",29)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",29)) 
    s:$P(InString,"^",30)'="" $P(InString,"^",30)=$zth($P(InString,"^",30))
    s:$P(InString,"^",29)="" $P(InString,"^",29)=+$H
    s:$P(InString,"^",30)="" $P(InString,"^",30)=$P($H,",",2)
    s obj.INLCIDate=$P(InString,"^",29)                  ;	经办日期
    s obj.INLCITime=$P(InString,"^",30)                  ;	经办时间
    s obj.INLCIRemark=$P(InString,"^",31)                ;	备注   
    s obj.INLCIExtStr01=$P(InString,"^",32)              ;	扩展01
    s obj.INLCIExtStr02=$P(InString,"^",33)              ;	扩展02
    s obj.INLCIExtStr03=$P(InString,"^",34)              ;	扩展03
    s obj.INLCIExtStr04=$P(InString,"^",35)              ;	扩展04
    s obj.INLCIExtStr05=$P(InString,"^",36)              ;	扩展05
    s:hospdr="" hospdr=$P(InString,"^",37)
    s obj.INLCIHospDr = hospdr
    s status=obj.%Save()
    s Id=obj.%Id()
    
    s ErrMsg=""
    If $$$ISERR(status)  Do DecomposeStatus^%apiOBJ(status,.err,"-d") For i=1:1:err s ErrMsg=ErrMsg_err(i) 
    q:ErrMsg'="" "-1^保存医保科室信息表失败Err:"_ErrMsg
 
    ;b ;1
    d obj.%Close()
	
    q Id
}

// 获取科室就诊类型

// w ##class(web.DHCINSULocInfoCtl).GetCTAdmType(4)

// 使用表 PAC_AdmTypeLocation

ClassMethod GetCTAdmType(LocDr) As %String
{
 
      ;O 门诊  E急诊   I 住院 H 体检 
    S AdmType="-1"
    q:LocDr="" AdmType
    q:'$d(^CTLOC(LocDr)) AdmType
    //b ;01
     ;^PAC("ADMLOC",0,"AdmType",{ADMLOC_AdmType},{ADMLOC_CTLOC_DR},{ADMLOC_RowId})
	s AdmLocDr=""
	s AdmLocDr=$O(^PAC("ADMLOC",0,"AdmType","O",LocDr,""),-1)
	q:+AdmLocDr'=0 "O"
	
	s AdmLocDr=""
	s AdmLocDr=$O(^PAC("ADMLOC",0,"AdmType","E",LocDr,""),-1)
	q:+AdmLocDr'=0 "E"
	
	s AdmLocDr=""
	s AdmLocDr=$O(^PAC("ADMLOC",0,"AdmType","I",LocDr,""),-1)
	q:+AdmLocDr'=0 "I"
	
	s AdmLocDr=""
	s AdmLocDr=$O(^PAC("ADMLOC",0,"AdmType","H",LocDr,""),-1)
	q:+AdmLocDr'=0 "H"
	
	q AdmType
}

/// 获取科室审核状态
/// add	Hanzh 20220613 copy by ZhangYX
/// w ##class(web.DHCINSULocInfoCtl).GetActiveFlag(249)
ClassMethod GetActiveFlag(id) As %String
{
	 s ActiveFlag="N"
	 s Dateto=$P(^CTLOC(id),"^",25)    //截至日期
	 s DateFrom=$P(^CTLOC(id),"^",24)  //开始日期
	 q:(Dateto'="")&&(Dateto<+$h) ActiveFlag     //截至日期小于当前日期
	 q:(DateFrom'="")&&(DateFrom>+$h) ActiveFlag  //开始日期大于当前日期
	 s ActiveFlag="Y"
	 q ActiveFlag
}

/// 同步生成科室信息
/// w ##class(web.DHCINSULocInfoCtl).SynBuildINLocInfo("","","","1","2","^^^^^","00A")
ClassMethod SynBuildINLocInfo(InRowid, LocCode, LocDesc, UserDr, HospDr, ExpStr, InsuType, LocDrStr = "") As %String
{
	n (InRowid, LocCode, LocDesc,UserDr,HospDr,ExpStr,InsuType,LocDrStr)
	s ^temp("SynBuildINLocInfo")=$lb(InRowid, LocCode, LocDesc,UserDr,HospDr,ExpStr,InsuType,LocDrStr)

	s Flag=-1,SuccNum=0,FailNum=0,AdmType="",Rtn=-1
	q:HospDr="" "-1!入参医院指针不能为空"
	s GroupHospId=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_LocInfo",HospDr)
	if ((InRowid="")||(LocCode="")||(LocDesc="") ||(LocDrStr="") )
	{
		s Flag=0
	}

	if InRowid'=""
	{
		s INRowid = InRowid		
		s LocId=$P(^DHCINLCI(InRowid),"^",6)
		s tHospDr=""
		s:LocId'="" tHospDr=$P(^CTLOC(LocId),"^",22)
		q:tHospDr'=GroupHospId Rtn
		s AdmType=..GetCTAdmType(LocId)
		q:+AdmType<0 Rtn
		s ActiveFlag=..GetActiveFlag(LocId)	;add	Hanzh 20220613 copy by ZhangYX
		q:ActiveFlag="N" Rtn
		d BuildLoc
		s Flag=1
	}
    if LocCode'="" {
	 s LocId=""
	 s LocCode1=$$ALPHAUP^SSUTIL4(LocCode)
     for 
     {
	     s LocId=$O(^CTLOC(0,"Code",LocCode1,LocId))
	     q:LocId=""
		 s INRowid=""
		 s INRowid = $O(^DHCINLCI("0","DeptDr",LocId,""),-1)
		 s tHospDr=""
		 s tHospDr=$P(^CTLOC(LocId),"^",22)
		 Continue:tHospDr'=GroupHospId  
		 s AdmType=..GetCTAdmType(LocId)
		 Continue:+AdmType<0
		 s ActiveFlag=..GetActiveFlag(LocId)	;add	Hanzh 20220613 copy by ZhangYX	
		 Continue:ActiveFlag="N"
		 d BuildLoc
	     s Flag=1
	  }
    }
     if LocDesc'="" {
	 s LocId=""
	 s LocDesc1=$$ALPHAUP^SSUTIL4(LocDesc)
     for 
     {
	        s LocId=$O(^CTLOC(0,"Desc",LocDesc1,LocId))
	        q:LocId=""
		    s INRowid=""
		    s INRowid = $O(^DHCINLCI("0","DeptDr",LocId,""),-1)
		    s tHospDr=""
	        s tHospDr=$P(^CTLOC(LocId),"^",22)
	        Continue:tHospDr'=GroupHospId  
	        s AdmType=..GetCTAdmType(LocId)
			b ;AdmType
	        Continue:+AdmType<0
	        s ActiveFlag=..GetActiveFlag(LocId)	;add	Hanzh 20220613 copy by ZhangYX
	    	Continue:ActiveFlag="N"
		    d BuildLoc
	        s Flag=1
	  }
    }
    if LocDrStr '="" {
	  s LocDrStrCnt = $l(LocDrStr,"^")
      f LocDrStrIdx=1:1:LocDrStrCnt
	   {
            s LocId = $P(LocDrStr,"^",LocDrStrIdx)
			q:LocId=""
		    s INRowid=""
		    s INRowid = $O(^DHCINLCI("0","DeptDr",LocId,""),-1)
	        s AdmType=..GetCTAdmType(LocId)
			b ;AdmType
	        Continue:+AdmType<0
	        s ActiveFlag=..GetActiveFlag(LocId)	
			b ;ActiveFlag
	    	Continue:ActiveFlag="N"
		    d BuildLoc
	        s Flag=1
	   }
	}
    //全部同步
    b ;00
    i +Flag=0
    {   s LocId=""
	    for  
        {
	      s LocId=$O(^CTLOC(LocId)) 
	      q:LocId=""
		  ;b ;0
		  s INRowid=""
		  s INRowid=$O(^DHCINLCI("0","DeptDr",LocId,""),-1)
		  s tHospDr=""
		  s tHospDr=$P(^CTLOC(LocId),"^",22)
		  Continue:tHospDr'=GroupHospId  
		  s AdmType=..GetCTAdmType(LocId)
		  Continue:+AdmType<0
		  s ActiveFlag=..GetActiveFlag(LocId)	;add	Hanzh 20220613 copy by ZhangYX
		  Continue:ActiveFlag="N"
		  d BuildLoc
		  s Flag=1
	  }
	 }
     
	q 0_"!总共:"_(SuccNum+FailNum)_",成功:"_SuccNum_",失败:"_FailNum
BuildLoc

 //s InStr="^FYLC020^肝胆外科[分院]^2^1101^1101^179^50^60^20^20^15^15^30^韩梅梅^18939067660^康康^18700990001^0^1^1^1009^2016-01-12^13:00:09^^^1^1^^^^^^^^"
 S InStr=""
 s $P(InStr,"^",1)=INRowid
 //判断是否已经上传过
 s INRecRowid="",HspFlag=""
 i +INRowid >0 {
     s INRecRowid=$o(^DHCINLCR("0","HOSP",HospDr,"CTDR",INRowid,INRecRowid),-1)
	 i INRecRowid'=""{
       s HspFlag=$p($g(^DHCINLCR(INRecRowid)),"^",8) //INLCRHSPFlag
	 }
 }
 b ;1
 q:(+HspFlag'=0)&&(+HspFlag'=2) "1"                    //0:未上传,1:已上传,2:变更,3:撤销
 s locData = ##class(%ArrayOfDataTypes).%New()
 s locData = ..GetCTLOCDataById(LocId,HospDr,InsuType) //DingSH 20221202
 s $P(InStr,"^",2)=locData.GetAt("hosp_dept_codg")
 s $P(InStr,"^",3)=locData.GetAt("hosp_dept_name")
 s $P(InStr,"^",4)=$case(AdmType,"I":"2",:"1")                    ;1、门诊；2、住院、3、门诊&住院 
 s $P(InStr,"^",5)=locData.GetAt("catyDesc")	 	              ;医保科室描述
 s $P(InStr,"^",6)=locData.GetAt("caty")                           ;医保科室代码
 s $P(InStr,"^",7)=LocId
 s $P(InStr,"^",8)=+locData.GetAt("aprv_bed_cnt")                  ;批准床位数量
 s $P(InStr,"^",9)=+locData.GetAt("hi_crtf_bed_cnt")               ;医保认可床位数
 s $P(InStr,"^",10)=locData.GetAt("dept_estbdat")                  ;科室成立时间
 s $P(InStr,"^",11)=+locData.GetAt("dr_psncnt")                    ;医师数量
 s $P(InStr,"^",12)=+locData.GetAt("tecn_psncnt")                  ;技师数量
 s $P(InStr,"^",13)=+locData.GetAt("phar_psncnt")                  ;药师数量
 s $P(InStr,"^",14)=+locData.GetAt("nurs_psncnt")                  ;护理人员数量
 s $P(InStr,"^",15)=locData.GetAt("dept_resper_name")              ;科室负责人
 s $P(InStr,"^",16)=locData.GetAt("dept_resper_tel")               ;科室负责人联系电话
 s $P(InStr,"^",17)=""                                             ;病区护士长姓名
 s $P(InStr,"^",18)=""                                             ;病区护士长联系电话
 s $P(InStr,"^",19)=0                                              ;是否重点科室
 s $P(InStr,"^",20)=0                                              ;重点科室等级
 s $P(InStr,"^",21)=0                                              ;该科室是否发生费用
 s $P(InStr,"^",22)=locData.GetAt("fixmedins_code")                ;定点机构编码
 s $P(InStr,"^",23)=##class(websys.Conversions).DateHtmlToLogical(locData.GetAt("begntime"))     ;开始日期
 s $P(InStr,"^",24)=""                          ;开始时间
 s $P(InStr,"^",25)=##class(websys.Conversions).DateHtmlToLogical(locData.GetAt("endtime"))     ;结束日期
 s $P(InStr,"^",26)=""                          ;结束时间
 s $P(InStr,"^",27)=1                           ;有效标志
 s $P(InStr,"^",28)=UserDr                      ;经办人
 s $P(InStr,"^",29)=""                          ;经办日期
 s $P(InStr,"^",30)=""                          ;经办时间
 s $P(InStr,"^",31)=locData.GetAt("memo")       ;备注
 s $P(InStr,"^",32)=locData.GetAt("itro")_"|"_locData.GetAt("dept_med_serv_scp")     ;简介|科室医疗服务范围
 s $P(InStr,"^",33)=$P($g(ExpStr),"^",3)       ;扩展02
 s $P(InStr,"^",34)=$P($g(ExpStr),"^",4)       ;扩展03
 s $P(InStr,"^",35)=$P($g(ExpStr),"^",5)       ;扩展04
 s $P(InStr,"^",36)=$P($g(ExpStr),"^",6)       ;扩展05
 s $P(InStr,"^",37)=GroupHospId
 s NId=""     
 s NId=..Save(InStr)
 i (+NId>0)
  {
   s SuccNum=SuccNum+1
   }
  else 
  {
	 s FailNum=FailNum+1
   }
 q NId
}

/// 查询科室信息(Query) 
/// d ##Class(%ResultSet).RunQuery("web.DHCINSULocInfoCtl","QryInLocInfo","","急诊内科门诊","2")
Query QryInLocInfo(InRowid As %String, KeyWords As %String, HospDr As %String) As %Query(ROWSPEC = "TInd,TRowid,TDeptCode::科室代码,TDeptDesc::科室名称,TDeptType::科室类型,TStandDeptCode::标准科室代码,TProfessionDeptCode::专业科室代码,TDeptDr::科室Dr,TSPBedNum::审批床位数,TSJBedNum::实际床位数,TDeptSetUpDate::科室成立时间,TDoctorNum::医师数据,TTechnicianNum::技师数量,TPharmacistNum::药师数量,TNurseNum::护师数量,TDeptHead::科室负责人,TDeptHeadTelNo::科室负责人电话,TNurseHead::病区护士长,TNurseHeadTelNo::病区护士长电话,TIsKeyDept::是否重点科室,TKeyDeptLevel::重点科室等级,TIsAllowFee::科室是否发生费用,THospCode::医院机构编码,TStDate::开始日期,TStTime::开始时间,TEdDate::结束日期,TEdTime::结束时间,TActFlag::有效标识,TUserDr::经办人Dr,TUserCode::经办人工号,TUserName::经办人,TDate::经办日期,TTime::经办时间,TRemark::备注,TExtStr01::扩展01,TExtStr02::扩展02,TExtStr03::扩展03,TExtStr04::扩展04,TExtStr05::扩展05,Titro,Tmedservscp,Tpoolareano")
{
}

ClassMethod QryInLocInfoExecute(ByRef qHandle As %Binary, InRowid As %String, KeyWords As %String, HospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	s ^TEMP("Q")=InRowid_"^"_KeyWords_"^"_HospDr
 	
   s GroupHospId=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_LocInfo",HospDr)
   s Flag=""
   if InRowid'=""
	{		
	If ##class(User.INSULocInfo).%ExistsId(InRowid)
	{
	   ;s objInLoc=##class(User.INSULocInfo).%OpenId(InRowid)
	   s objInLoc=##class(User.INSULocInfo).%OpenId(InRowid,0) ;upt 20220609 HanZH
		     
     }
	d BuildInLoc
	s Flag=1	
	}
	
    if ((KeyWords'="")&&(+Flag=0)) {
	
	 s LocCode1=$$ALPHAUP^SSUTIL4(KeyWords)
	 s DeptCode=""
     for 
     {    
	      s DeptCode=$O(^DHCINLCI(0,"DeptCode",DeptCode))
	      q:DeptCode=""
	      CONTINUE:DeptCode'[LocCode1
	      s id=""
	      for{   
	      
		  s id=$O(^DHCINLCI(0,"DeptCode",DeptCode,id))
	      q:id=""
	     If ##class(User.INSULocInfo).%ExistsId(id)
	      {
	        ;s objInLoc=##class(User.INSULocInfo).%OpenId(id)
	   		s objInLoc=##class(User.INSULocInfo).%OpenId(id,0) ;upt 20220609 HanZH
		    s tHospDr=""
		    s DeptDr=objInLoc.INLCIDeptDrGetObjectId()
		    s:DeptDr'="" tHospDr=$P(^CTLOC(DeptDr),"^",22)
		     ;b ;002
	        Continue:tHospDr'=GroupHospId  
           }
		  d BuildInLoc
	      s Flag=1
	  }
     }
	  
	  if (+Flag=0)
	  {
		s LocDesc1=$$ALPHAUP^SSUTIL4(KeyWords)
		s DeptDesc=""  
		b ;01
	   for 
       {    
          
	      s DeptDesc=$O(^DHCINLCI(0,"DeptDesc",DeptDesc))
	      q:DeptDesc=""
	      ;b ;02
	      CONTINUE:DeptDesc'[LocDesc1
	      b ;03
	      s id=""
	      for{   
	      
		  s id=$O(^DHCINLCI(0,"DeptDesc",DeptDesc,id))
	      q:id=""
	      b ;04
	     If ##class(User.INSULocInfo).%ExistsId(id)
	      {
	        ;s objInLoc=##class(User.INSULocInfo).%OpenId(id)
	   		s objInLoc=##class(User.INSULocInfo).%OpenId(id,0) ;upt 20220609 HanZH
		    s tHospDr=""
		    s DeptDr=objInLoc.INLCIDeptDrGetObjectId()
		    s:DeptDr'="" tHospDr=$P(^CTLOC(DeptDr),"^",22)
		     ;b ;002
	        Continue:tHospDr'=GroupHospId 
           }
		  d BuildInLoc
	      s Flag=1
	  }
		  ;b ;1
	  }
     
	 } 
	 
	  if (+Flag=0)
	  {
		s PYMKeyWords=$$ALPHAUP^SSUTIL4(KeyWords)
		s DeptDesc=""  
	   for 
       {    
	      s DeptDesc=$O(^DHCINLCI(0,"DeptDesc",DeptDesc))
	      q:DeptDesc=""
	      s pym=##class(web.DHCINSUPort).GetCNCODE(DeptDesc,4 ,"")
	      CONTINUE:pym'[PYMKeyWords
	      s id=""
	      for{   
	    
		  s id=$O(^DHCINLCI(0,"DeptDesc",DeptDesc,id))
	      q:id=""
	     If ##class(User.INSULocInfo).%ExistsId(id)
	      {
	        ;s objInLoc=##class(User.INSULocInfo).%OpenId(id)
	   		s objInLoc=##class(User.INSULocInfo).%OpenId(id,0) ;upt 20220609 HanZH
		    s tHospDr=""
		    s DeptDr=objInLoc.INLCIDeptDrGetObjectId()
		    s:DeptDr'="" tHospDr=$P(^CTLOC(DeptDr),"^",22)
		     ;b ;002
	        Continue:tHospDr'=GroupHospId 
           }
		  d BuildInLoc
	      s Flag=1
	  }
		  
	  }
     
	 }    
	   
    }
    

    if ((InRowid="")&&(KeyWords=""))
    {
	    ;b ;01
	    s id=""
	    for{
		    s id=$O(^DHCINLCI(id))
		    ;b ;02
	        q:id=""
	      If ##class(User.INSULocInfo).%ExistsId(id)
	     {
		   	;s objInLoc=##class(User.INSULocInfo).%OpenId(id)
	   		s objInLoc=##class(User.INSULocInfo).%OpenId(id,0) ;upt 20220609 HanZH
		    Continue:'$IsObject(objInLoc.INLCIDeptDr)
		    s tHospDr=""
		    s DeptDr=objInLoc.INLCIDeptDrGetObjectId()
		    s:DeptDr'="" tHospDr=$P(^CTLOC(DeptDr),"^",22)
		     ;b ;002
	        Continue:tHospDr'=GroupHospId 
		    d BuildInLoc
		    
		    }
	    }
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
    
BuildInLoc   
 	s (TRowid,TDeptCode,TDeptDesc,TDeptType,TStandDeptCode,TProfessionDeptCode,TDeptDr,TSPBedNum,TSJBedNum,TDeptSetUpDate,TDoctorNum,TTechnicianNum,TPharmacistNum,TNurseNum,TDeptHead,TDeptHeadTelNo,TNurseHead,TNurseHeadTelNo,TIsKeyDept,TKeyDeptLevel,TIsAllowFee,THospCode,TStDate,TStTime,TEdDate,TEdTime,TActFlag,TUserDr,TUserCode,TUserName,TDate,TTime,TRemark,TExtStr01,TExtStr02,TExtStr03,TExtStr04,TExtStr05)=""
    
    s TRowid=objInLoc.%Id()
    s TDeptCode=objInLoc.INLCIDeptCode
    s TDeptDesc=objInLoc.INLCIDeptDesc
    s TDeptType=objInLoc.INLCIDeptType
    s TDeptType=$CASE(TDeptType,"1":"门诊","2":"住院","3":"门诊&住院",:"其他")
    s TStandDeptCode=objInLoc.INLCIStandDeptCode
    s TProfessionDeptCode=objInLoc.INLCIProfessionDeptCode
    if $IsObject(objInLoc.INLCIDeptDr) d
    .s TDeptDr=objInLoc.INLCIDeptDr.%Id()
    s TSPBedNum=objInLoc.INLCISPBedNum
    s TSJBedNum=objInLoc.INLCISJBedNum
    s TDeptSetUpDate=objInLoc.INLCIDeptSetUpDate
    s TDoctorNum=objInLoc.INLCIDoctorNum
    s TTechnicianNum=objInLoc.INLCITechnicianNum
    s TPharmacistNum=objInLoc.INLCIPharmacistNum
    s TNurseNum=objInLoc.INLCINurseNum
    s TDeptHead=objInLoc.INLCIDeptHead
    s TDeptHeadTelNo=objInLoc.INLCIDeptHeadTelNo
    s TNurseHead=objInLoc.INLCINurseHead
    s TNurseHeadTelNo=objInLoc.INLCINurseHeadTelNo
    s TIsKeyDept=objInLoc.INLCIIsKeyDept 
    s TKeyDeptLevel=objInLoc.INLCIKeyDeptLevel
    s TIsAllowFee=objInLoc.INLCIIsAllowFee 
    s THospCode=objInLoc.INLCIHospCode 
    b ;qry
    s:+objInLoc.INLCIStDate'=0 TStDate=##class(websys.Conversions).DateLogicalToHtml(objInLoc.INLCIStDate)
    s:+objInLoc.INLCIStTime'=0 TStTime=$zt(objInLoc.INLCIStTime)
    s:+objInLoc.INLCIEdDate'=0 TEdDate=##class(websys.Conversions).DateLogicalToHtml(objInLoc.INLCIEdDate)
    s:+objInLoc.INLCIEdTime'=0 TEdTime=$zt(objInLoc.INLCIEdTime) 
    s TActFlag=objInLoc.INLCIActFlag
    if $IsObject(objInLoc.INLCIUserDr) d
    .s TUserDr=objInLoc.INLCIUserDr.%Id()
    .s TUserCode=objInLoc.INLCIUserDr.SSUSRInitials
    .s TUserName=objInLoc.INLCIUserDr.SSUSRName
    s TDate=##class(websys.Conversions).DateLogicalToHtml(objInLoc.INLCIDate) 
    s TTime=$zt(objInLoc.INLCITime)
    s TRemark=objInLoc.INLCIRemark
    s TExtStr01=objInLoc.INLCIExtStr01 
    s TExtStr02=objInLoc.INLCIExtStr02 
    s TExtStr03=objInLoc.INLCIExtStr03 
    s TExtStr04=objInLoc.INLCIExtStr04 
    s TExtStr05=objInLoc.INLCIExtStr05
    ;st add Hanzh 20220613 copy by ZhangYX
    ;s Titro=$P(TExtStr01,"|",1)
    s Titro=objInLoc.INLCIExtStr01
    ;s Tmedservscp=$P(TExtStr01,"|",2)
    s Tmedservscp=objInLoc.INLCIExtStr02
    s Tpoolareano=""
    s INLCRRowid=""             
    s INLCRRowid=$o(^DHCINLCR("0","CTDR",TRowid,INLCRRowid),-1)
    i INLCRRowid'="" d
    .s Tpoolareano=$p($g(^DHCINLCR(INLCRRowid)),"^",2)
    ;ed add Hanzh 20220613 copy by ZhangYX
    d BuildLocQry
    q 

BuildLocQry
   
    set Data=$lb(i,TRowid,TDeptCode,TDeptDesc,TDeptType,TStandDeptCode,TProfessionDeptCode,TDeptDr,TSPBedNum,TSJBedNum,TDeptSetUpDate,TDoctorNum,TTechnicianNum,TPharmacistNum,TNurseNum,TDeptHead,TDeptHeadTelNo,TNurseHead,TNurseHeadTelNo,TIsKeyDept,TKeyDeptLevel,TIsAllowFee,THospCode,TStDate,TStTime,TEdDate,TEdTime,TActFlag,TUserDr,TUserCode,TUserName,TDate,TTime,TRemark,TExtStr01,TExtStr02,TExtStr03,TExtStr04,TExtStr05,Titro,Tmedservscp,Tpoolareano)
 	Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	q
}

ClassMethod QryInLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInLocInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInLocInfoExecute ]
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

/// 审核科室信息
/// w ##class(web.DHCINSULocInfoCtl).CheckInLocInfo("ZYZY017",2)
ClassMethod CheckInLocInfo(LocCode, HospDr) As %String
{
	 n (LocCode,HospDr)
	 s id="",INRowid=""
	 s LocCode1=$$ALPHAUP^SSUTIL4(LocCode)
     for 
     {
	        s id=$O(^CTLOC(0,"Code",LocCode1,id))
	        q:(id="")!(+INRowid'=0)
		    s rowid=""
		    s rowid=$O(^DHCINLCI("0","DeptDr",id,""),-1)
		    Continue:+rowid=0
		    s tHospDr=$P($g(^DHCINLCI(rowid)),"^",36)
		    i (tHospDr=""){
	           s tHospDr=$P(^CTLOC(id),"^",22)
		    }
	        Continue:tHospDr'=HospDr  
		   s INRowid=rowid
		
	      
	  }
	  q INRowid
}

/// 根据科室ID获取科室信息
/// add	Hanzh 20220613 copy by ZhangYX
/// w ##class(web.DHCINSULocInfoCtl).GetLocInfoById(1)
ClassMethod GetLocInfoById(Id As %String) As %String
{
	n (Id)
	q:Id="" "-1!"
	q:'$d(^DHCINLCI(Id)) "-1!"
	s GetLocInfoById=$g(^DHCINLCI(Id))
	i $p(GetLocInfoById,"^",9)'="" d
	.s $p(GetLocInfoById,"^",9)=$zd($p(GetLocInfoById,"^",9),3)
	i $p(GetLocInfoById,"^",22)'="" d
	.s $p(GetLocInfoById,"^",22)=$zd($p(GetLocInfoById,"^",22),3)
	i $p(GetLocInfoById,"^",23)'="" d
	.s $p(GetLocInfoById,"^",23)=$zt($p(GetLocInfoById,"^",23))
	i $p(GetLocInfoById,"^",24)'="" d
	.s $p(GetLocInfoById,"^",24)=$zd($p(GetLocInfoById,"^",24),3)
	i $p(GetLocInfoById,"^",25)'="" d
	.s $p(GetLocInfoById,"^",25)=$zt($p(GetLocInfoById,"^",25))
	i $p(GetLocInfoById,"^",28)'="" d
	.s $p(GetLocInfoById,"^",28)=$zd($p(GetLocInfoById,"^",28),3)
	i $p(GetLocInfoById,"^",29)'="" d
	.s $p(GetLocInfoById,"^",29)=$zt($p(GetLocInfoById,"^",29))
	s GetLocInfoById="1!"_Id_"^"_GetLocInfoById
	q GetLocInfoById
}

/// 查询科室信息(Query) 
/// d ##Class(%ResultSet).RunQuery("web.DHCINSULocInfoCtl","QryCTLocInfo","ZYMZ002","","","00A","","2")
/// output 医院科室编码，国家科室代码，国家科室名称，开始时间，结束时间，简介，科室负责人姓名，科室负责人电话，是否医技科室，科室医疗服务范围，科室成立日期，医疗服务类型，诊疗科目类别，批准床位数量，医保认可床位数，统筹区编号，医师人数，药师人数，护士人数，技师人数,备注 上传状态,上传人,上传日期,上传时间,上传科室Id,上传科室记录Id
Query QryCTLocInfo(hospDeptCodg As %String, hospDeptName As %String, caty As %String, hiType As %String, upStatus As %String, hospDr As %String) As %Query(ROWSPEC = "ind,hosp_dept_codg,hosp_dept_name,caty,catyDesc,begntime,endtime,itro,dept_resper_name,dept_resper_tel,dept_med_serv_scp,dept_estbdat,aprv_bed_cnt,hi_crtf_bed_cnt,poolarea_no,dr_psncnt,phar_psncnt,nurs_psncnt,tecn_psncnt,memo,up_status,up_user,up_date,up_time,ctLocId,inlocId,inlocRecId,dicRowid")
{
}

ClassMethod QryCTLocInfoExecute(ByRef qHandle As %Binary, hospDeptCodg As %String, hospDeptName As %String, caty As %String, hiType As %String, upStatus As %String, hospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	s ^TEMP("QryLocInfo")=$lb(hospDeptCodg,hospDeptName,caty,hiType,upStatus,hospDr)
    s GroupHospId=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("CT_Loc",hospDr)
    s Flag=""
    if ((hospDeptCodg'="")) {
			s tmphospDeptCodg=$$ALPHAUP^SSUTIL4(hospDeptCodg)
			s DeptCode=$P(tmphospDeptCodg,1,*-1)
			for 
			{    
				s DeptCode = $O(^CTLOC(0,"Code",DeptCode))
				q:DeptCode=""
				CONTINUE:DeptCode'[tmphospDeptCodg
				b ;dept
				s DeptDr=""
				for{   
						s DeptDr=$O(^CTLOC(0,"Code",DeptCode,DeptDr))
						q:DeptDr=""
						s AdmType =..GetCTAdmType(DeptDr)
						continue:+AdmType<0
						s tHospDr=$P(^CTLOC(DeptDr),"^",22)
						Continue:tHospDr'=GroupHospId  
						d BuildCTLoc
						s Flag=1
				}
				
			}
     }
	  
	  if (+Flag=0)&&(hospDeptName'="")
	  {
			s tmphospDeptName=$$ALPHAUP^SSUTIL4(hospDeptName)
			s DeptDesc=$P(tmphospDeptName,1,*-1)
			b ;01
	   		for 
			{    
				
				s DeptDesc=$O(^CTLOC(0,"Desc",DeptDesc))
				q:DeptDesc=""
				CONTINUE:DeptDesc'[tmphospDeptName
				s DeptDr=""
				for{   
				
						s DeptDr=$O(^CTLOC(0,"Desc",DeptDesc,DeptDr))
						q:DeptDr=""
						s AdmType =..GetCTAdmType(DeptDr)
						continue:+AdmType<0
						s tHospDr=$P(^CTLOC(DeptDr),"^",22)
						Continue:tHospDr'=GroupHospId 
						d BuildCTLoc
				        s Flag=1
				}
				
			}
		  ;b ;1
	  }
    if (+Flag=0)
	  {
			s tmphospDeptName=$$ALPHAUP^SSUTIL4(hospDeptName)
			b ;01
			s DeptDr=""
	   		for 
			{    
				
				s DeptDr=$o(^CTLOC(DeptDr)) 
				q:DeptDr=""
				s AdmType =..GetCTAdmType(DeptDr)
				continue:+AdmType<0
				s tHospDr=$P(^CTLOC(DeptDr),"^",22)
				Continue:tHospDr'=GroupHospId 
				d BuildCTLoc
				s Flag=1
			}
		  ;b ;1
	  }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
BuildCTLoc   
	s (thospDeptCodg,tcaty,tcatyDesc,thospDeptName,tbegntime,tendtime,itro,tdeptResperName,tdeptResperTel,tdeptMedServScp,tdeptEstbdat,taprvBedCnt,thiCrtfBedCnt,tpoolareaNo,tdrPsncnt,tpharPsncnt,tnursPsncnt,ttecnPsncnt,tmemo,tupStatus,tupUser,tupDate,tupTime,tctLocId,tinlocId,tinlocRecId,dicRowid) = ""
    s ctLocInfoAry = ##class(%ArrayOfDataTypes).%New()
	//b ;ttttt
    s ctLocInfoAry = ..GetCTLOCDataById(DeptDr)
	///up_status,up_user,up_date,up_time,,inlocId,inlocRecId
	s tctLocId = DeptDr
    s thospDeptCodg = ctLocInfoAry.GetAt("hosp_dept_codg")
	q:(hospDeptCodg'="")&&(thospDeptCodg'[hospDeptCodg)
	s thospDeptName = ctLocInfoAry.GetAt("hosp_dept_name")
	q:(hospDeptName'="")&&(thospDeptName'[hospDeptName)
	s tupStatus="" //上传状态 INLCR_ISPFlag
    s tinlocId = ""
    s tinlocId = $O(^DHCINLCI("0","DeptDr",tctLocId,""),-1)
    i +tinlocId>0 {
		s tcaty = $P(^DHCINLCI(tinlocId),"^",5)
		s tcatyDesc = $P(^DHCINLCI(tinlocId),"^",6)
		s tinlocRecId=$o(^DHCINLCR("0","CTDR",tinlocId,tinlocRecId),-1)
		i +tinlocRecId > 0 {
			s tpoolareaNo=$p($g(^DHCINLCR(tinlocRecId)),"^",2)
			//s tupStatus=$p($g(^DHCINLCR(tinlocRecId)),"^",12)  //上传状态 INLCR_ISPFlag
			s tupStatus=$p($g(^DHCINLCR(tinlocRecId)),"^",8)  //上传状态 INLCR_HSPFlag
			s tupUser = $p($g(^DHCINLCR(tinlocRecId)),"^",15)
			s tupDate = $p($g(^DHCINLCR(tinlocRecId)),"^",16)
			s:tupDate'="" tupDate = $zd(tupDate,3)
			s tupTime = $p($g(^DHCINLCR(tinlocRecId)),"^",17)
			s:tupTime'="" tupTime = $zt(tupTime)
			s titro = $p($g(^DHCINLCR(tinlocRecId)),"^",16)
		}
    }
	s dicData=##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon"_hiType,thospDeptCodg,0,hospDr)
	//b ;dicData
	s tcaty = $P(dicData,"^",6)
	s tcatyDesc=$P(dicData,"^",7)
	//b ;caty
	q:(caty'="")&&(caty'=tcaty)
	s tbegntime= ctLocInfoAry.GetAt("begntime")
	s tendtime= ctLocInfoAry.GetAt("endtime")
	s titro = ctLocInfoAry.GetAt("itro")
	s tdeptResperName = ctLocInfoAry.GetAt("dept_resper_name")
	s tdeptResperTel = ctLocInfoAry.GetAt("dept_resper_tel")
	s tdeptMedServScp = ctLocInfoAry.GetAt("dept_med_serv_scp")
	s tdeptEstbdat = ctLocInfoAry.GetAt("dept_estbdat")
	s taprvBedCnt = ctLocInfoAry.GetAt("aprv_bed_cnt")
	s thiCrtfBedCnt = ctLocInfoAry.GetAt("hi_crtf_bed_cnt")
	if ctLocInfoAry.GetAt("poolarea_no")'=""{
       s tpoolareaNo = ctLocInfoAry.GetAt("poolarea_no")
	}
	if tpoolareaNo="" {
		
	}
	s tdrPsncnt = ctLocInfoAry.GetAt("dr_psncnt")
	s tpharPsncnt = ctLocInfoAry.GetAt("phar_psncnt")
	s tnursPsncnt = ctLocInfoAry.GetAt("nurs_psncnt")
	s ttecnPsncnt = ctLocInfoAry.GetAt("tecn_psncnt")
	s tmemo = ctLocInfoAry.GetAt("memo")
	q:(upStatus'="")&&(+tupStatus'=+upStatus)
    s tupStatus=$case(+tupStatus,0:"未上传",1:"已上传",2:"已变更",3:"撤销",:"其他")
    s dicRowid=$o(^DHCINDID("0","ITypeCode","deptCon00A",thospDeptCodg,""))
    d BuildCTLocQry
    q 

BuildCTLocQry
   
    set Data=$lb(ind,thospDeptCodg,thospDeptName,tcaty,tcatyDesc,tbegntime,tendtime,titro,tdeptResperName,tdeptResperTel,tdeptMedServScp,tdeptEstbdat,taprvBedCnt,thiCrtfBedCnt,tpoolareaNo,tdrPsncnt,tpharPsncnt,tnursPsncnt,ttecnPsncnt,tmemo,tupStatus,tupUser,tupDate,tupTime,tctLocId,tinlocId,tinlocRecId,dicRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	q
}

ClassMethod QryCTLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCTLocInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCTLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCTLocInfoExecute ]
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

/// 根据rowid获取科室信息,返回DataArray
/// 2022-11-15
/// LocData.GetAt("hosp_dept_codg")     ;医院科室编码
/// 	LocData.GetAt("caty")           ;科别 /医保科室描述
/// 	LocData.GetAt("hosp_dept_name") ;医院科室名称
/// 	LocData.GetAt("begntime")       ;开始时间  yyyy-mm-dd
/// 	LocData.GetAt("endtime")        ;结束时间  yyyy-mm-dd
/// 	LocData.GetAt("itro")           ;简介
/// 	LocData.GetAt(,"dept_resper_name") ;科室负责人姓名
/// 	LocData.GetAt("dept_resper_tel")   ;科室负责人电话
/// 	LocData.GetAt("dept_med_serv_scp") ;科室医疗服务范围
/// 	LocData.GetAt("dept_estbdat")      ;科室成立日期 
/// 	LocData.GetAt("aprv_bed_cnt")      ;批准床位数量
/// 	LocData.GetAt("hi_crtf_bed_cnt")   ;医保认可床位数
///     LocData.GetAt("poolarea_no")       ;统筹区编号
/// 	LocData.GetAt("dr_psncnt")         ;医师人数
/// 	LocData.GetAt("phar_psncnt")       ;药师人数
/// 	LocData.GetAt("nurs_psncnt")       ;护士人数
///     LocData.SetAt("tecn_psncnt")           ;技师人数
///     LocData.GetAt("memo")                  ;备注
///     LocData.GetAt("hospDr")                ;院区
///     LocData.GetAt("catyDesc")              ;科别描述/医保科室描述
///     LocData.GetAt("locRowid")              ;科室Rowid
///  zw ##class(web.DHCINSULocInfoCtl).GetCTLOCDataById(39,2,"00A")
ClassMethod GetCTLOCDataById(rowid, hospDr = "", expStr = "") As %ArrayOfDataTypes
{
	q:rowid="" ""
	n (rowid,hospDr,expStr)
	s hospdeptcodg=$p($g(^CTLOC(rowid)),"^",1)		//1医院科室编码
	s caty=""								        //2科别
	s hospdeptname=$p($g(^CTLOC(rowid)),"^",2)		//3医院科室名称
	s begntime=$p($g(^CTLOC(rowid)),"^",24)			//4开始时间
	s:begntime'="" begntime=$zd(begntime,3)			//yyyy-mm-dd
	s endtime=$p($g(^CTLOC(rowid)),"^",25)			//5结束时间
	s:endtime'="" endtime=$zd(endtime,3)			//yyyy-mm-dd
	s itro=$p($g(^CTLOC(rowid,"EXT")),"^",1)		//6简介
	s deptrespername=$p($g(^CTLOC(rowid)),"^",54)	//科主任
	s:deptrespername'="" deptrespername=$p($g(^SSU("SSUSR",deptrespername)),"^",2)	//7科室负责人姓名
	s deptrespertel=$p($g(^CTLOC(rowid)),"^",40)		//8科室负责人电话
	s deptmedservscp=$p($g(^CTLOC(rowid,"EXT")),"^",13)		//9科室医疗服务范围
	s deptestbdat=begntime								//10科室成立日期
	s aprvbedcnt=$p($g(^CTLOC(rowid,"EXT")),"^",3)		//11批准床位数量
	s hicrtfbedcnt=$p($g(^CTLOC(rowid,"EXT")),"^",4)	//12医保认可床位数
	s poolareano=$p($g(^CTLOC(rowid,"EXT")),"^",5)		//13统筹区编号
	s drpsncnt=$p($g(^CTLOC(rowid,"EXT")),"^",6)		//14医师人数
	s pharpsncnt=$p($g(^CTLOC(rowid,"EXT")),"^",7)		//15药师人数
	s nurspsncnt=$p($g(^CTLOC(rowid,"EXT")),"^",8)		//16护士人数
	s tecnpsncnt=$p($g(^CTLOC(rowid,"EXT")),"^",9)		//17技师人数
	s memo=$p($g(^CTLOC(rowid,"EXT")),"^",15)  			//18备注
	i hospDr = "" {
		s hospDr = $p($g(^CTLOC(rowid)),"^",22)			// 院区
	}
	s hiType=$P(expStr,"^",1)                                            
	s dicData = ##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon"_hiType,hospdeptcodg,0,hospDr)	;医保科室代码
	s caty = $P(dicData,"^",6)
    s catyDesc = $P(dicData,"^",7)
    i poolareano=""
    {
	   s dicData = ##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_hiType,"InsuCenterNo",0,hospDr)	;
	   s poolareano = $P(dicData,"^",4)   
	 }
	 
	s fixmedinscode = ##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_hiType,"InsuHospCode",4,hospDr)
	s LocData=##class(%ArrayOfDataTypes).%New()
	d LocData.SetAt(hospdeptcodg,"hosp_dept_codg")
	d LocData.SetAt(caty,"caty")
	d LocData.SetAt(hospdeptname,"hosp_dept_name")
	d LocData.SetAt(begntime,"begntime")
	d LocData.SetAt(endtime,"endtime")
	d LocData.SetAt(itro,"itro")
	d LocData.SetAt(deptrespername,"dept_resper_name")
	d LocData.SetAt(deptrespertel,"dept_resper_tel")
	d LocData.SetAt(deptmedservscp,"dept_med_serv_scp")
	d LocData.SetAt(deptestbdat,"dept_estbdat")
	d LocData.SetAt(aprvbedcnt,"aprv_bed_cnt")
	d LocData.SetAt(hicrtfbedcnt,"hi_crtf_bed_cnt")
	d LocData.SetAt(poolareano,"poolarea_no")
	d LocData.SetAt(drpsncnt,"dr_psncnt")
	d LocData.SetAt(pharpsncnt,"phar_psncnt")
	d LocData.SetAt(nurspsncnt,"nurs_psncnt")
	d LocData.SetAt(tecnpsncnt,"tecn_psncnt")
	d LocData.SetAt(memo,"memo")
	d LocData.SetAt(hospDr,"hospDr")
	d LocData.SetAt(hiType,"hiType")
	d LocData.SetAt(catyDesc,"catyDesc")
	d LocData.SetAt(rowid,"locRowid")
	d LocData.SetAt(fixmedinscode,"fixmedins_code")
	q LocData
}

/// 获取科室上传信息集合
/// 获取0:未上传,1:已上传:2:变更 
/// w ##class(web.DHCINSULocInfoCtl).GetCTLocInfo("ZYMZ002^^0^1^2^00A^")
/// 科室Dr串(^分割),医保上传上传记录Rowid串(^分割),上传标识^操作员指针^院区^医保类型
/// 20221202
ClassMethod GetCTLocInfo(DeptDrStr As %String = "", InLocRecDrStr As %String = "", ExpStr) As %Stream.GlobalCharacter
{
	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	s upFlag=$P(ExpStr,"^",1)  //0:未上传,1:已上传:2:变更
	s userDr=$P(ExpStr,"^",2)
	s hospDr=$P(ExpStr,"^",3)
	s hiType=$P(ExpStr,"^",4)
	q:((+upFlag = 1)||(+upFlag=2))&&(+InLocRecDrStr="") "-1^变更或撤销医保科室上传记录Rowid不能为空"
   //待上传数据同步到 INSU_LocInfo
   If ((+upFlag = 0)) {
       s rtnFlg = ##class(web.DHCINSULocInfoCtl).SynBuildINLocInfo("","","",userDr,hospDr,"^^^^^",hiType,DeptDrStr)
   }
   //待上传记录统筹区编码
   s mdtrtareaAdmvs =##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_hiType,"InsuCenterNo",4,hospDr)	;
   b ;DeptDrStr
   //查询待上传记录
   if (DeptDrStr'="")&&(+upFlag = 0)  {
       s DeptDrStrCnt = $l(DeptDrStr,"^")
       for DeptDrStrIdx = 1 : 1 : DeptDrStrCnt {
         s DeptDr = $P(DeptDrStr,"^",DeptDrStrIdx)
		 s RowId = ""
		 for {
			 s RowId=$o(^DHCINLCI("0","DeptDr",DeptDr,RowId)) 
			 b  ;RowId
			 q:(RowId="")
             d BuidCTLoc
		   }
	   }
	 }
	 b ;locrec
	//查询待上传记录（全部）
   if (DeptDrStr="")&&(+upFlag = 0){
	 s RowId=""
	 for {
		 s RowId = $o(^DHCINLCI(RowId))
         q:RowId="" 
         d BuidCTLoc
	 }
   }

   //查询已上传或变更记录
   i ((+upFlag=1)||(+upFlag=2)||(+upFlag=3)){
	    s InLocRecDrStrCnt=$l(InLocRecDrStr,"^")
		for InLocRecDrStrIdx=1:1:InLocRecDrStrCnt {
          s INLCRRowid = $p(InLocRecDrStr,"^",InLocRecDrStrIdx)
	      s RowId=$p($g(^DHCINLCR(INLCRRowid)),"^",1) //Insu_locinfo.rowid
          If ((+upFlag = 2)) {
            s rtnFlg = ##class(web.DHCINSULocInfoCtl).SynBuildINLocInfo(RowId,"","",userDr,hospDr,"^^^^^",hiType,"")
          }
	      d BuidCTLoc
		}
	   }
	b ;objstream
	q objstream
BuidCTLoc
	s InLocInfo=$g(^DHCINLCI(RowId))
	b ;InLocInfo
	s caty=$p(InLocInfo,"^",5)                        ;科别
	q:caty=""
	s tmpFlg=""
	i ((+upFlag = 0)){
	  s INLCRRowid=##class(web.DHCINSULocRecCtl).BuildInLocRecByInLocId(RowId,"",hiType,userDr,hospDr,mdtrtareaAdmvs_"^"_mdtrtareaAdmvs_"^^^^^")
	}
	b ;INLCRRowid
	q:+INLCRRowid<=0 
	b ;tmpupFlag
	s tmpupFlag=$p($g(^DHCINLCR(INLCRRowid)),"^",8)    ;0:未上传 ,1:已上传 2:变更,3 撤销
	q:(+upFlag=0)&&((+tmpupFlag'=0))                   ;查询需上传数据    
	q:(+upFlag=2)&&(+tmpupFlag'=2)                     ;查询需变更数据   
	q:(+upFlag=3)&&((+tmpupFlag'=1)&&(+tmpupFlag'=2))  ;查询需撤销数据
	s poolareano=""                                    ;统筹区编号
    s poolareano=$p($g(^DHCINLCR(INLCRRowid)),"^",2)
	q:poolareano=""
	s hospdeptcode=$p(InLocInfo,"^",1)	               ;医院科室编码
	s hospdeptname=$p(InLocInfo,"^",2)		           ;医院科室名称
	s begntime=$p(InLocInfo,"^",22)                    ;开始时间
	q:begntime=""                                      ;科室成立时间
	s endtime=$p(InLocInfo,"^",24)                     ;结束时间
	s:begntime'="" begntime=$zd(begntime,3)
	s:endtime'="" endtime=$zd(endtime,3)
	s itro=$p($p(InLocInfo,"^",31),"|",1)              ;简介
	//q:itro=""
	b ;INLCRRowid12
	s deptrespername=$p(InLocInfo,"^",14)              ;科室负责人
	//q:deptrespername=""
	s deptrespertel=$p(InLocInfo,"^",15)               ;科室负责人电话
	//q:deptrespertel=""
	s deptmedservscp=$p($p(InLocInfo,"^",31),"|",2)    ;科室医疗服务范围
	s deptestbdat=$p(InLocInfo,"^",9)                  ;科室成立日期
	//q:deptestbdat=""
	//s:deptestbdat'="" deptestbdat=$zd(deptestbdat,3)
	s aprvbedcnt=$p(InLocInfo,"^",7)                    ;批准床位数量
	//q:aprvbedcnt=""
	s hicrtfbedcnt=$p(InLocInfo,"^",8)                  ;医保认可床位数 
	s drpsncnt=$p(InLocInfo,"^",10)                     ;医师人数
	//q:drpsncnt=""
	s pharpsncnt=$p(InLocInfo,"^",12)                   ;药师人数
	//q:pharpsncnt=""
	s nurspsncnt=$p(InLocInfo,"^",13)                   ;护士人数
	//q:nurspsncnt=""
	s tecnpsncnt=$p(InLocInfo,"^",11)                   ;技师人数
	//q:tecnpsncnt=""
	s memo=$p(InLocInfo,"^",30)                         ;备注
	s RowObj = ##class(INSU.Utils.COM.Object).%New()
	s DataObj = ##class(INSU.Utils.COM.Object).%New()
	s DataObj."hosp_dept_codg" = hospdeptcode                ;医院科室编码
	s DataObj."caty" = caty                                  ;科别
	s DataObj."hosp_dept_name" = hospdeptname                  ;医院科室名称
	s DataObj."begntime" = begntime                          ;开始时间
	s DataObj."endtime" = endtime                            ;结束时间
	s DataObj."itro" = itro                                  ;简介
	s DataObj."dept_resper_name" = deptrespername              ;科室负责人
	s DataObj."dept_resper_tel" = deptrespertel                ;科室负责人电话
	s DataObj."dept_med_serv_scp" = deptmedservscp              ;科室医疗服务范围
	s DataObj."dept_estbdat" = deptestbdat                    ;科室成立日期	
	s DataObj."aprv_bed_cnt" = aprvbedcnt                      ;批准床位数量
	s DataObj."hi_crtf_bed_cnt" = hicrtfbedcnt                  ;医保认可床位数 
	s DataObj."poolarea_no" = poolareano                      ;统筹区编号     
	s DataObj."dr_psncnt" = drpsncnt                          ;医师人数
	s DataObj."phar_psncnt" = pharpsncnt                      ;药师人数
	s DataObj."nurs_psncnt" = nurspsncnt                      ;护士人数
	s DataObj."tecn_psncnt" = tecnpsncnt                      ;技师人数
	s DataObj."memo" = memo                                  ;备注
	s RowObj.data = DataObj    
	s RowObj."INLCRRowid" = INLCRRowid                       ;科室上传记录表rowid                   
	s RowStr = RowObj.ToJSON()
	d objstream.WriteLine(RowStr)
	b ;INLCRRowid222
    q
}

/// 医保科室管理：科室信息修改时调用
/// 入参：DeptDr:CT_Loc.Rowid
/// 出参：0 或 小于0程序异常
/// 使用场景：科室/病区维护修改后调用此接口(基础数据平台组)
/// w ##class(web.DHCINSULocInfoCtl).UptLocFlag(39)
ClassMethod UptLocFlag(DeptDr) As %String
{
	s $zt = "UptLocFlagEx"
	    s UptLocFlag=0
        s InLocRowid=""
		s InLocRowid=$O(^DHCINLCI("0","DeptDr",DeptDr,""),-1)
		q:+InLocRowid=0 UptLocFlag
		s InLocRecRowid=$O(^DHCINLCR("0","CTDR",InLocRowid,""),-1)
		q:+InLocRecRowid=0 UptLocFlag
		s upFlag = $p(^DHCINLCR(InLocRecRowid),"^",8)
		q:+upFlag'=1 UptLocFlag 
		#dim NewLocAry As %ArrayOfDataTypes 
		#dim UpedLocAry As %ArrayOfDataTypes 
      
		s UpedLocAry = ..GetINLOCDataById(InLocRecRowid)          //已上传科室信息
		q:'$isObject(UpedLocAry) UptLocFlag
	    s hospDr = UpedLocAry.GetAt("hospDr")
		s hiType = UpedLocAry.GetAt("hiType")
		s NewLocAry = ..GetCTLOCDataById(DeptDr,hospDr,hiType)     //新科室信息
		s HSPFlag=0
		b ;hhhh
         f Newidx=1:1:NewLocAry.Count() {
			do NewLocAry.GetNext(.key)
			s NewVal = NewLocAry.GetAt(key)
			s UpedVal = UpedLocAry.GetAt(key) //有一个不相等的认为变更了
			b ;UpedVal
			i NewVal'=UpedVal {
                  s HSPFlag=2
				  b ;diff
				  q 
			} 
			
		}
	   b ;HSPFlag
	   q:+HSPFlag=0 UptLocFlag
	   s HSPDate=+$h
	   s HSPTime=$p($h,",",2)
       s HSPUserDr =$P(^CTLOC(DeptDr),"^",98)
      &sql(update SQLUser.INSU_LocRec set 
		   INLCR_HSPFlag=:HSPFlag,
		   INLCR_HSPDate=:HSPDate,
		   INLCR_HSPTime=:HSPTime,
		   INLCR_HSPUserDr=:HSPUserDr 
	     where INLCR_Rowid=:InLocRecRowid)
		q SQLCODE
UptLocFlagEx
  s $zt=""
  b ;UptLocFlagEx
  q "-99^程序异常"
}

/// 根据医保科室上传记录Rowid获取上传的科室信息
/// 2022-11-15
///     LocData.GetAt("hosp_dept_codg")     ;医院科室编码
/// 	LocData.GetAt("caty")           ;科别 /医保科室描述
/// 	LocData.GetAt("hosp_dept_name") ;医院科室名称
/// 	LocData.GetAt("begntime")       ;开始时间  yyyy-mm-dd
/// 	LocData.GetAt("endtime")        ;结束时间  yyyy-mm-dd
/// 	LocData.GetAt("itro")           ;简介
/// 	LocData.GetAt(,"dept_resper_name") ;科室负责人姓名
/// 	LocData.GetAt("dept_resper_tel")   ;科室负责人电话
/// 	LocData.GetAt("dept_med_serv_scp") ;科室医疗服务范围
/// 	LocData.GetAt("dept_estbdat")      ;科室成立日期 
/// 	LocData.GetAt("aprv_bed_cnt")      ;批准床位数量
/// 	LocData.GetAt("hi_crtf_bed_cnt")   ;医保认可床位数
///     LocData.GetAt("poolarea_no")       ;统筹区编号
/// 	LocData.GetAt("dr_psncnt")         ;医师人数
/// 	LocData.GetAt("phar_psncnt")       ;药师人数
/// 	LocData.GetAt("nurs_psncnt")       ;护士人数
///     LocData.SetAt("tecn_psncnt")           ;技师人数
///     LocData.GetAt("memo")                  ;备注
///     LocData.GetAt("hospDr")                ;院区
///     LocData.GetAt("catyDesc")              ;科别描述/医保科室描述
///     LocData.GetAt("locRowid")              ;科室Rowid
/// w ##class(web.DHCINSULocInfoCtl).GetINLOCDataById(100)
ClassMethod GetINLOCDataById(LocRecRowid) As %ArrayOfDataTypes
{
	n (LocRecRowid)

	q:+LocRecRowid=0 ""
    s INLCRData = $g(^DHCINLCR(LocRecRowid))
	s InLocRowid= $p(INLCRData,"^",1)     
	q:+InLocRowid=0 ""
    s INLCIData=$g(^DHCINLCI(InLocRowid))
	s locRowid =$p(INLCIData,"^",6)	                 //CTLoc科室Rowid
	s hospdeptcodg=$p(INLCIData,"^",1)		         //1医院科室编码
	s caty=$p(INLCIData,"^",5)		                 //2医保科室编码
	s hospdeptname=$p(INLCIData,"^",2)		         //3医院科室名称
	s begntime=$p(INLCIData,"^",22)			         //4开始时间 yyyy-mm-dd
	s:begntime'="" begntime=$zd(begntime,3)	             
	s endtime=$p(INLCIData,"^",24)			         //5结束时间 yyyy-mm-dd
	s:endtime'="" endtime=$zd(endtime,3)	
	s itro=$P($p(INLCIData,"^",31),"|",1)			  //6简介
	s deptrespername=$p(INLCIData,"^",14)		      //7科主任7科室负责人姓名
	s deptrespertel=$p(INLCIData,"^",15)		      //8科室负责人电话
	s deptmedservscp=$P($p(INLCIData,"^",31),"|",2)	  //9科室医疗服务范围
	s deptestbdat=$p(INLCIData,"^",9)				 //10科室成立日期
	s aprvbedcnt=$p(INLCIData,"^",7)			     //11批准床位数量
	s hicrtfbedcnt=$p(INLCIData,"^",8)		         //12医保认可床位数
	s poolareano=$p(INLCRData,"^",2)			     //13统筹区编号
	s drpsncnt=$p(INLCIData,"^",10)			         //14医师人数
	s pharpsncnt=$p(INLCIData,"^",12)	             //15药师人数
	s nurspsncnt=$p(INLCIData,"^",13)		         //16护士人数
	s tecnpsncnt=$p(INLCIData,"^",11)		         //17技师人数
	s memo=$p(INLCIData,"^",30)			             //18备注
	s hiType=$p(INLCRData,"^",6)			         //医保类型
	s hospDr = $p(INLCRData,"^",23)	                // 院区                                      
    s catyDesc = $P(INLCIData,"^",4)                 //2医保科室代码描述
	s fixmedinscode =$p(INLCIData,"^",21)
	s LocData=##class(%ArrayOfDataTypes).%New()
	d LocData.SetAt(hospdeptcodg,"hosp_dept_codg")
	d LocData.SetAt(caty,"caty")
	d LocData.SetAt(hospdeptname,"hosp_dept_name")
	d LocData.SetAt(begntime,"begntime")
	d LocData.SetAt(endtime,"endtime")
	d LocData.SetAt(itro,"itro")
	d LocData.SetAt(deptrespername,"dept_resper_name")
	d LocData.SetAt(deptrespertel,"dept_resper_tel")
	d LocData.SetAt(deptmedservscp,"dept_med_serv_scp")
	d LocData.SetAt(deptestbdat,"dept_estbdat")
	d LocData.SetAt(aprvbedcnt,"aprv_bed_cnt")
	d LocData.SetAt(hicrtfbedcnt,"hi_crtf_bed_cnt")
	d LocData.SetAt(poolareano,"poolarea_no")
	d LocData.SetAt(drpsncnt,"dr_psncnt")
	d LocData.SetAt(pharpsncnt,"phar_psncnt")
	d LocData.SetAt(nurspsncnt,"nurs_psncnt")
	d LocData.SetAt(tecnpsncnt,"tecn_psncnt")
	d LocData.SetAt(memo,"memo")
	d LocData.SetAt(hospDr,"hospDr")
	d LocData.SetAt(hiType,"hiType")
	d LocData.SetAt(catyDesc,"catyDesc")
	d LocData.SetAt(locRowid,"locRowid")
	d LocData.SetAt(fixmedinscode,"fixmedins_code")
	q LocData
}

}
