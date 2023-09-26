/// 医保医师上传记录操作类
/// DingSH
/// 2018-9-25
Class web.DHCINSUCareProvRecCtl Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 保存
/// w ##class(web.DHCINSUCareProvRecCtl).Save( "^1^419900^419900^1001^9001^ZZB^1^1^2018-09-25^17:58:00^李双^1^2018-09-26^10:30^1^^^^^^^")
ClassMethod Save(InString As %String) As %String
{
	
	n (InString)
	q:InString="" "-1^入参串为空"
	s Id=$P(InString,"^",1)
	i +Id=0 d
	.s obj=##class(User.INSUCareProvRec).%New()
	e  d
	.;s obj=##class(User.INSUCareProvRec).%OpenId(Id)
	.s obj=##class(User.INSUCareProvRec).%OpenId(Id,0)	;upt 20220610 HanZH
	
	/*i +$P(InString,"^",2)>0 d
	.s objInCarP=##class(User.INSUCareProvInfo).%OpenId($P(InString,"^",2))
	e  d
	.s objInCarP=##class(User.INSUCareProvInfo).%New()
   */
	d obj.INCPRCPDrSetObjectId($P(InString,"^",2))               ;	医保医师信息指针
    s obj.INCPRCenter=$P(InString,"^",3)                        ;	医保中心统筹区编码
    s obj.INCPRStates=$P(InString,"^",4)                        ;	医保中心行政区划代码
    s obj.INCPRSeriNo=$P(InString,"^",5)                        ;	申请流水号
    s obj.INCPRBusiNo=$P(InString,"^",6)                        ;	发送方交易流水号
    s obj.INCPRInsuType=$P(InString,"^",7)                      ;	医保类型
    /*i +$P(InString,"^",8) >0 d
    .s objUser=##class(User.SSUser).%OpenId($P(InString,"^",8))
    e  d
    .s objUser=##class(User.SSUser).%New()*/
    ;b ;01
    d obj.INCPRHSPUserDrSetObjectId($P(InString,"^",8))           ;	医院审批人
    s obj.INCPRHSPFlag=$P(InString,"^",9)                       ;	医院审批状态
    s:$P(InString,"^",10)'="" $P(InString,"^",10)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",10)) 
    s:$P(InString,"^",11)'="" $P(InString,"^",11)=$zth($P(InString,"^",11))
    i $P(InString,"^",10)'="" d
    .s obj.INCPRHSPDate=$P(InString,"^",10)                      ;	医院审批日期
    i $P(InString,"^",11)'="" d
    .s obj.INCPRHSPTime=$P(InString,"^",11)                      ;	医院审批时间
    s obj.INCPRISPUserDr=$P(InString,"^",12)                     ;	医保审批人
    s obj.INCPRISPFlag=$P(InString,"^",13)                       ;	医保审批状态
    s:$P(InString,"^",14)'="" $P(InString,"^",14)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",14))
    s:$P(InString,"^",15)'="" $P(InString,"^",15)=$zth($P(InString,"^",15))
    i $P(InString,"^",14)'="" d
    .s obj.INCPRISPDate=$P(InString,"^",14)                      ;	医保审批日期
    i $P(InString,"^",15)'="" d
    s obj.INCPRISPTime=$P(InString,"^",15)                       ;	医保审批时间
    /*i +$P(InString,"^",16) >0 d
    .s objUser=##class(User.SSUser).%OpenId($P(InString,"^",16))
    e  d
    .s objUser=##class(User.SSUser).%New()
    s obj.INCPRUserDr=objUser ;	经办人
    */
    d obj.INCPRUserDrSetObjectId($P(InString,"^",16))             ;	经办人
    ;b ;02
    s:$P(InString,"^",17)'="" $P(InString,"^",17)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",17)) 
    s:$P(InString,"^",18)'="" $P(InString,"^",18)=$zth($P(InString,"^",18))
    s:$P(InString,"^",17)="" $P(InString,"^",17)=+$H
    s:$P(InString,"^",18)="" $P(InString,"^",18)=$P($H,",",2)
   
    s obj.INCPRDate=$P(InString,"^",17)                       ;	经办日期
    s obj.INCPRTime=$P(InString,"^",18)                       ;	经办时间
    
    s obj.INCPRExtStr01=$P(InString,"^",19)                   ;	扩展01
    s obj.INCPRExtStr02=$P(InString,"^",20)                   ;	扩展02
    s obj.INCPRExtStr03=$P(InString,"^",21)                   ;	扩展03
    s obj.INCPRExtStr04=$P(InString,"^",22)                   ;	扩展04
    s obj.INCPRExtStr05=$P(InString,"^",23)                   ;	扩展05
     s obj.INCPRHospDr=$P(InString,"^",24)                   ;	扩展05

	
	s status=obj.%Save()
    s Id=obj.%Id()
    
    s ErrMsg=""
    If $$$ISERR(status)  Do DecomposeStatus^%apiOBJ(status,.err,"-d") For i=1:1:err s ErrMsg=ErrMsg_err(i) 
    q:ErrMsg'="" "-1^保存医保医师上传记录表失败Err:"_ErrMsg
 
    ;b ;1
    d obj.%Close()
	
    q Id
}

/// 生成医保医师上传记录信息
/// w ##class(web.DHCINSUCareProvRecCtl).BuildINCPRecInfo"","ZZB",1,2,"555555^555555^^^^^")
ClassMethod BuildINCPRecInfo(InRowid, InsuType, UserDr, HospDr, ExpStr) As %String
{
	n (InRowid,InsuType,UserDr,HospDr,ExpStr,%session)
	
	s Flag=-1,SuccNum=0,FailNum=0
	q:HospDr="" "-1!入参医院指针不能为空"
	q:InsuType="" "-1!入参医保类型不能为空"
	s Center=$P($G(ExpStr),"^",1)
	s States=$P($G(ExpStr),"^",2)
	q:Center="" "-1!入参医保中心代码不能为空"
    q:States="" "-1!入参行政地区代码不能为空"	  
	s GroupHospId=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_CareProvInfo",HospDr)
	if ((InRowid=""))
	{
		s Flag=0
	}
	
	if InRowid'=""
	{
	s tmpINRowid=InRowid		
	s id=$P(^DHCINCPR(InRowid),"^",1)
	If ##class(User.INSUCareProvInfo).%ExistsId(id)
	{
	   ;s objInCP=##class(User.INSUCareProvInfo).%OpenId(id)
	   s objInCP=##class(User.INSUCareProvInfo).%OpenId(id,0)	;upt 20220610 HanZH	
	   s tHospDr=objInCP.INCPIHospDr
	   q:tHospDr'=GroupHospId  
     }
	d BuildCPRc
	s Flag=1
		
	}
	
    //全部同步
    b ;00
    i +Flag=0
    {   s id=""
	    for  
        {
	      s id=$O(^DHCINCPI(id)) 
	      q:id=""
	    
	     If ##class(User.INSUCareProvInfo).%ExistsId(id)
	     {  
	        s tHospDr=$P($g(^DHCINCPI(id)),"^",53)
		    Continue:tHospDr'=GroupHospId
		    ;s objInCP=##class(User.INSUCareProvInfo).%OpenId(id)
	   		s objInCP=##class(User.INSUCareProvInfo).%OpenId(id,0)	;upt 20220610 HanZH	
		    s rowid="",tmpINRowid=""
		    for{
		    s rowid=$O(^DHCINCPR("0","INCPDR",id,rowid))
		    q:rowid=""
		    s tInsuType=""
		    s tInsuType=$P(^DHCINCPR(rowid),"^",6)
		    Continue:tInsuType'=InsuType
		    s tCenter=$P(^DHCINCPR(rowid),"^",2)
		    Continue:tCenter'=Center
		    s tStates=$P(^DHCINCPR(rowid),"^",3)
		    Continue:tStates'=States
		   
		    s tmpINRowid=rowid
		    }
		    ;Continue:'$IsObject(objInCP.INCPIDeptDr)
		    ;s tHospDr=""
		    ;s DeptDr=objInLoc.INLCIDeptDr.%Id()
		    ;s:DeptDr'="" tHospDr=$P(^CTLOC(DeptDr),"^",22)
		    ;b ;01
	        ;Continue:tHospDr'=HospDr 
		    d BuildCPRc
	        s Flag=1
		  }
	  }
	    
	 }
     
	q 0_"!总共:"_(SuccNum+FailNum)_",成功:"_SuccNum_",失败:"_FailNum
BuildCPRc
 ;s InStr="^1^419900^419900^1001^9001^ZZB^1^1^2018-09-25^17:58:00^李双^1^2018-09-26^10:30^1^^^^^^^"
 ;+2019-7-30 tangzf 医院授权判断 start
  	s TmpHospital=objInCP.INCPIHospDr
  	s GrpHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_CareProvInfo",HospDr)  
  	q:HospDr'=GrpHospDr   
	;s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("INSU_CareProvInfo",tmpINRowid,"",TmpHospital)
	;q:(CheckHosipitalSession'="Y") ; 该院区无权查看该数据
 ;+2019-7-30 tangzf 医院授权判断 end
 s InStr="^^^^^^^^^^^^^^^^^^^^^^"
 s $P(InStr,"^",1)=tmpINRowid
 s $P(InStr,"^",2)=objInCP.%Id()           ;医保医师信息指针
 s $P(InStr,"^",3)=$P($g(ExpStr),"^",1)    ;医保中心统筹区编码
 s $P(InStr,"^",4)=$P($g(ExpStr),"^",2)    ;医保中心行政区划代码
 s $P(InStr,"^",5)=""                      ;申请流水号 
 s $P(InStr,"^",6)=""                      ;发送方交易流水号
 s $P(InStr,"^",7)=InsuType            ;医保类型
 s $P(InStr,"^",8)=UserDr                  ;医院审批人
 s $P(InStr,"^",9)=""                      ;医院审批状态
 s $P(InStr,"^",10)=""                     ;医院审批日期
 s $P(InStr,"^",11)=""                     ;医院审批时间
 s $P(InStr,"^",12)=""                     ;医保审批人
 s $P(InStr,"^",13)=""                     ;医保审批状态
 s $P(InStr,"^",14)=""                     ;医保审批日期
 s $P(InStr,"^",15)=""                     ;医保审批时间
 s $P(InStr,"^",16)=UserDr                 ;经办人
 s $P(InStr,"^",17)=""                     ;经办日期
 s $P(InStr,"^",18)=""                     ;经办时间
 s $P(InStr,"^",19)=$P($g(ExpStr),"^",3)       ;扩展01
 s $P(InStr,"^",20)=$P($g(ExpStr),"^",4)       ;扩展02
 s $P(InStr,"^",21)=$P($g(ExpStr),"^",5)       ;扩展03
 s $P(InStr,"^",22)=$P($g(ExpStr),"^",6)       ;扩展04
 s $P(InStr,"^",23)=$P($g(ExpStr),"^",7)       ;扩展05
 s $P(InStr,"^",24)=HospDr     ;Hosp
 s NId=""     
 s NId=..Save(InStr)
 ;b ;011
 i (+NId>0)
  {
   s SuccNum=SuccNum+1
   }
  else 
  {
	 s FailNum=FailNum+1
   }
 d objInCP.%Close()
 q
}

/// 查询上传记录信息(Query) 
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUCareProvRecCtl","QryInCPRecInfo","199","ZZB","2")
Query QryInCPRecInfo(InCPRowid As %String, InsuType As %String, HospDr As %String) As %Query(ROWSPEC = "TInd,TRowid,TCPDr,TCenterNo,TStates,TSeriNo,TBusiNo,TInsuType,TInsuTypeDesc,THSPUserDr,THSPUserCode,THSPUserName,THSPFlag,THSPDate,THSPTime,TISPUserDr,TISPFlag,TISPDate,TISPTime,TUserDr,TUserCode,TUserName,TDate,TTime,TExtStr02,TExtStr03,TExtStr04,TExtStr05,THospDr")
{
}

ClassMethod QryInCPRecInfoExecute(ByRef qHandle As %Binary, InCPRowid As %String, InsuType As %String, HospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
   s Flag=""
   ;s ^TEMPQ("R")=InLocRowid_"^"_InsuType_"^"_HospDr
    if (InCPRowid'="")
     {
	 s id=""
     for 
     {    
	      s id=$O(^DHCINCPR(0,"INCPDR",InCPRowid,id))
	      q:id=""
	      s tInsuType=$P(^DHCINCPR(id),"^",6)
	      continue:((tInsuType'=InsuType)&&(InsuType'=""))
	     If ##class(User.INSUCareProvRec).%ExistsId(id)
	      {
	        ;s objInCPRec=##class(User.INSUCareProvRec).%OpenId(id)
	  		s objInCPRec=##class(User.INSUCareProvRec).%OpenId(id,0)	;upt 20220610 HanZH	
		    Continue:'$IsObject(objInCPRec.INCPRCPDr)
		    ;s tHospDr=""
		    ;s DeptDr=objInLocRec.INLCRCTDr.INLCIDeptDr.%Id()
		    ;s:DeptDr'="" tHospDr=$P(^CTLOC(DeptDr),"^",22)
	        ;Continue:tHospDr'=HospDr 
           }
		  d BuildInCPRec
	      s Flag=1
	  
     }
	  
 
	   
    }
    
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
    
BuildInCPRec   
 	s (TInd,TRowid,TCPDr,TCenterNo,TStates,TSeriNo,TBusiNo,TInsuType,TInsuTypeDesc,THSPUserDr,THSPUserCode,THSPUserName,THSPFlag,THSPDate,THSPTime,TISPUserDr,TISPFlag,TISPDate,TISPTime,TUserDr,TUserCode,TUserName,TDate,TTime,TExtStr02,TExtStr03,TExtStr04,TExtStr05)=""
  	 ;+2019-7-30 tangzf 医院授权判断 start
  	s TmpHospital=objInCPRec.INCPRHospDr
	s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("INSU_CareProvRec",objInCPRec.%Id(),"",TmpHospital)
	q:(CheckHosipitalSession'="Y") ; 该院区无权查看该数据
 	;+2019-7-30 tangzf 医院授权判断 end
    s TRowid=objInCPRec.%Id()
    if $IsObject(objInCPRec.INCPRCPDr) d
    .s TCPDr=objInCPRec.INCPRCPDr.%Id()
    s TCenterNo=objInCPRec.INCPRCenter
    s TStates=objInCPRec.INCPRStates
    s TSeriNo=objInCPRec.INCPRSeriNo
    s TBusiNo=objInCPRec.INCPRBusiNo
    s TInsuType=objInCPRec.INCPRInsuType
    s TInsuTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",TInsuType,4)
    if $IsObject(objInCPRec.INCPRHSPUserDr) d
    .s THSPUserDr=objInCPRec.INCPRHSPUserDr.%Id()
    .s THSPUserCode=objInCPRec.INCPRHSPUserDr.SSUSRInitials
    .s THSPUserName=objInCPRec.INCPRHSPUserDr.SSUSRName
    s THSPFlag=objInCPRec.INCPRHSPFlag
    s:+objInCPRec.INCPRHSPDate'=0 THSPDate=##class(websys.Conversions).DateLogicalToHtml(objInCPRec.INCPRHSPDate)
    s:+objInCPRec.INCPRHSPTime'=0 THSPTime=$zt(objInCPRec.INCPRHSPTime)
    s TISPUserDr=objInCPRec.INCPRISPUserDr
    s TISPFlag=objInCPRec.INCPRISPFlag
    s:+objInCPRec.INCPRISPDate'=0 TISPDate=##class(websys.Conversions).DateLogicalToHtml(objInCPRec.INCPRISPDate) 
    s:+objInCPRec.INCPRISPTime'=0 TISPTime=$zt(objInCPRec.INCPRISPTime)
    if $IsObject(objInCPRec.INCPRUserDr) d
    .s TUserDr=objInCPRec.INCPRUserDr.%Id()
    .s TUserCode=objInCPRec.INCPRUserDr.SSUSRInitials
    .s TUserName=objInCPRec.INCPRUserDr.SSUSRName
    s:+objInCPRec.INCPRDate'=0 TDate=##class(websys.Conversions).DateLogicalToHtml(objInCPRec.INCPRDate) 
    s:+objInCPRec.INCPRTime'=0 TTime=$zt(objInCPRec.INCPRTime)
    s TExtStr01=objInCPRec.INCPRExtStr01 
    s TExtStr02=objInCPRec.INCPRExtStr02 
    s TExtStr03=objInCPRec.INCPRExtStr03 
    s TExtStr04=objInCPRec.INCPRExtStr04 
    s TExtStr05=objInCPRec.INCPRExtStr05
    s THospDr =objInCPRec.INCPRHospDr
    d BuildInCPRecQry
    q 

BuildInCPRecQry
   
    set Data=$lb(ind,TRowid,TCPDr,TCenterNo,TStates,TSeriNo,TBusiNo,TInsuType,TInsuTypeDesc,THSPUserDr,THSPUserCode,THSPUserName,THSPFlag,THSPDate,THSPTime,TISPUserDr,TISPFlag,TISPDate,TISPTime,TUserDr,TUserCode,TUserName,TDate,TTime,TExtStr02,TExtStr03,TExtStr04,TExtStr05,THospDr)
 	Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	q
}

ClassMethod QryInCPRecInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInCPRecInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInCPRecInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInCPRecInfoExecute ]
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

}
