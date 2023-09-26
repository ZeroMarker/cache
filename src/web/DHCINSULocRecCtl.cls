/// 医保科室上传记录操作类
/// DingSH
/// 2018-09-25
Class web.DHCINSULocRecCtl Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 保存
/// w ##class(web.DHCINSULocRecCtl).Save( "^1^419900^419900^1001^9001^ZZB^1^1^2018-09-25^17:58:00^李双^1^2018-09-26^10:30^1^^^^^^^")
ClassMethod Save(InString As %String) As %String
{
	
	n (InString)
	
	q:InString="" "-1^入参串为空"
	s Id=$P(InString,"^",1)
	i +Id=0 d
	.s obj=##class(User.INSULocRec).%New()
	e  d
	.s obj=##class(User.INSULocRec).%OpenId(Id)
	
	i +$P(InString,"^",2)>0 d
	.s objInLoc=##class(User.INSULocInfo).%OpenId($P(InString,"^",2))
	e  d
	.s objInLoc=##class(User.INSULocInfo).%New()
   ;b ;001
	s obj.INLCRCTDr=objInLoc                                    ;	医保科室信息指针
    s obj.INLCRCenter=$P(InString,"^",3)                        ;	医保中心统筹区编码
    s obj.INLCRStates=$P(InString,"^",4)                        ;	医保中心行政区划代码
    s obj.INLCRSeriNo=$P(InString,"^",5)                        ;	申请流水号
    s obj.INLCRBusiNo=$P(InString,"^",6)                        ;	发送方交易流水号
    s obj.INLCRInsuType=$P(InString,"^",7)                      ;	医保类型
    
    /*i +$P(InString,"^",8) >0 d
    .s objUser=##class(User.SSUser).%OpenId($P(InString,"^",8))
    e  d
    .s objUser=##class(User.SSUser).%New()
    ;b ;01
    s obj.INLCRHSPUserDr=objUser  */                              ;	医院审批人
    
    do obj.INLCRHSPUserDrSetObjectId(+$P(InString,"^",8))
    
    s obj.INLCRHSPFlag=$P(InString,"^",9)                       ;	医院审批状态
    s:$P(InString,"^",10)'="" $P(InString,"^",10)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",10))
    s:$P(InString,"^",11)'="" $P(InString,"^",11)=$zth($P(InString,"^",11))
    i $P(InString,"^",10)'="" d
    .s obj.INLCRHSPDate=$P(InString,"^",10)                      ;	医院审批日期
    i $P(InString,"^",11)'="" d
    .s obj.INLCRHSPTime=$P(InString,"^",11)                      ;	医院审批时间
    s obj.INLCRISPUserDr=$P(InString,"^",12)                     ;	医保审批人
    s obj.INLCRISPFlag=$P(InString,"^",13)                       ;	医保审批状态
    s:$P(InString,"^",14)'="" $P(InString,"^",14)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",14))  
    s:$P(InString,"^",15)'="" $P(InString,"^",15)=$zth($P(InString,"^",15))
    i $P(InString,"^",14)'="" d
    .s obj.INLCRISPDate=$P(InString,"^",14)                      ;	医保审批日期
    i $P(InString,"^",15)'="" d
    s obj.INLCRISPTime=$P(InString,"^",15)                       ;	医保审批时间
    
    /*i +$P(InString,"^",16) >0 d
    .s objUser=##class(User.SSUser).%OpenId($P(InString,"^",16))
    e  d
    .s objUser=##class(User.SSUser).%New()
    s obj.INLCRUserDr=objUser */;	经办人
    
      do obj.INLCRUserDrSetObjectId(+$P(InString,"^",16))
    
    ;b ;02
    s:$P(InString,"^",17)'="" $P(InString,"^",17)=##class(websys.Conversions).DateHtmlToLogical($P(InString,"^",17)) 
    s:$P(InString,"^",18)'="" $P(InString,"^",18)=$zth($P(InString,"^",18))
    s:$P(InString,"^",17)="" $P(InString,"^",17)=+$H
    s:$P(InString,"^",18)="" $P(InString,"^",18)=$P($H,",",2)
   
    s obj.INLCRDate=$P(InString,"^",17)                       ;	经办日期
    s obj.INLCRTime=$P(InString,"^",18)                       ;	经办时间
    
    s obj.INLCRExtStr01=$P(InString,"^",19)                   ;	扩展01
    s obj.INLCRExtStr02=$P(InString,"^",20)                   ;	扩展02
    s obj.INLCRExtStr03=$P(InString,"^",21)                   ;	扩展03
    s obj.INLCRExtStr04=$P(InString,"^",22)                   ;	扩展04
    s obj.INLCRExtStr05=$P(InString,"^",23)                   ;	扩展05
	s obj.INLCRHospDr=$P(InString,"^",24)                   ;	扩展05
	
	s status=obj.%Save()
    s Id=obj.%Id()
    
    s ErrMsg=""
    If $$$ISERR(status)  Do DecomposeStatus^%apiOBJ(status,.err,"-d") For i=1:1:err s ErrMsg=ErrMsg_err(i) 
    q:ErrMsg'="" "-1^保存医保科室上传记录表失败Err:"_ErrMsg
 
    ;b ;1
    d obj.%Close()
	
    q Id
}

ClassMethod BuildINLocRecInfo(InRowid, InsuType, UserDr, HospDr, ExpStr, InLocId = "") As %String
{
}

/// 生成科室上传记录信息
/// w ##class(web.DHCINSULocRecCtl).BuildINLocRecInfo("","00A",1,2,"430111^430111^^^^^")
ClassMethod BuildInLocRecByInLocId(InLocId, upFlg = "", InsuType, UserDr, HospDr, ExpStr) As %String
{
	n (InLocId,upFlg,InsuType,UserDr,HospDr,ExpStr)
	
	s Flag=-1
	q:HospDr="" "-1!入参医院指针不能为空"
	q:InsuType="" "-1!入参医保类型不能为空"
	q:InLocId="" "-1!入参医保科室表Rowid不能为空"
	s rowid="",tmpINRowid=""
	for {
		    s rowid=$O(^DHCINLCR("0","CTDR",InLocId,rowid),-1)
		    q:rowid=""
		    s tInsuType=""
		    s tInsuType=$P(^DHCINLCR(rowid),"^",6)
		    s tHospDr=$P(^DHCINLCR(rowid),"^",23)
		    s tupFlg=$P(^DHCINLCR(rowid),"^",8)
			Continue:+tupFlg=3  // 撤销状态要重新生成一条记录
		    Continue:(upFlg'="")&&(tupFlg'=upFlg)
		    Continue:tInsuType'=InsuType
		    Continue:tHospDr'=HospDr 
		    s tmpINRowid=rowid
	  }
  b ;ttttt
  s InLocRecInfo="^^^^^^^^^^^^^^^^^^^^^^"	   
  i tmpINRowid > 0 
  {
		 
    s InLocRecInfo = ..GetLocRecById(tmpINRowid)
		 
   }     
 ;s InLocRecInfo ="^1^419900^419900^1001^9001^ZZB^1^1^2018-09-25^17:58:00^李双^1^2018-09-26^10:30^1^^^^^^^"
 s $P(InLocRecInfo,"^",1)=tmpINRowid
 s $P(InLocRecInfo,"^",2)=InLocId                 ;医保科室信息指针
 s $P(InLocRecInfo,"^",3)=$P($g(ExpStr),"^",1)    ;医保中心统筹区编码
 s $P(InLocRecInfo,"^",4)=$P($g(ExpStr),"^",2)    ;医保中心行政区划代码
 //s $P(InLocRecInfo,"^",5)=""                      ;申请流水号 
 //s $P(InLocRecInfo,"^",6)=""                      ;发送方交易流水号
 s $P(InLocRecInfo,"^",7)=InsuType                ;医保类型
 s $P(InLocRecInfo,"^",8)=UserDr                  ;医院审批人
 //s $P(InLocRecInfo,"^",9)=""                      ;医院审批状态
 //s $P(InLocRecInfo,"^",10)=""                     ;医院审批日期
 //s $P(InLocRecInfo,"^",11)=""                     ;医院审批时间
 //s $P(InLocRecInfo,"^",12)=""                     ;医保审批人
 //s $P(InLocRecInfo,"^",13)=""                     ;医保审批状态
 //s $P(InLocRecInfo,"^",14)=""                     ;医保审批日期
 //s $P(InLocRecInfo,"^",15)=""                     ;医保审批时间
 s $P(InLocRecInfo,"^",16)=UserDr                   ;经办人
 //s $P(InLocRecInfo,"^",17)=""                     ;经办日期
 //s $P(InLocRecInfo,"^",18)=""                     ;经办时间
 s $P(InLocRecInfo,"^",19)=$P($g(ExpStr),"^",3)       ;扩展01
 s $P(InLocRecInfo,"^",20)=$P($g(ExpStr),"^",4)       ;扩展02
 s $P(InLocRecInfo,"^",21)=$P($g(ExpStr),"^",5)       ;扩展03
 s $P(InLocRecInfo,"^",22)=$P($g(ExpStr),"^",6)       ;扩展04
 s $P(InLocRecInfo,"^",23)=$P($g(ExpStr),"^",7)       ;扩展05
 s $P(InLocRecInfo,"^",24)=HospDr                     ;扩展05
 s NId=""    
 s NId=..Save(InLocRecInfo)
 b ;InLocRecInfo
 q NId
}

/// 查询科室信息(Query) 
/// d ##Class(%ResultSet).RunQuery("web.DHCINSULocRecCtl","QryInLocRecInfo","1","00A","2")
Query QryInLocRecInfo(InLocRowid As %String, InsuType As %String, HospDr As %String) As %Query(ROWSPEC = "TInd,TRowid,TCTDr,TCenterNo,TStates,TSeriNo,TBusiNo,TInsuType,TInsuTypeDesc,THSPUserDr,THSPUserCode,THSPUserName,THSPFlag,THSPDate,THSPTime,TISPUserDr,TISPFlag,TISPDate,TISPTime,TUserDr,TUserCode,TUserName,TDate,TTime,TExtStr02,TExtStr03,TExtStr04,TExtStr05")
{
}

ClassMethod QryInLocRecInfoExecute(ByRef qHandle As %Binary, InLocRowid As %String, InsuType As %String, HospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
   s Flag=""
   s ^TEMPQ("R")=InLocRowid_"^"_InsuType_"^"_HospDr
    if (InLocRowid'="")
     {
	 s id=""
     for 
     {    
	      s id=$O(^DHCINLCR(0,"CTDR",InLocRowid,id))
	      q:id=""
	      s tInsuType=$P(^DHCINLCR(id),"^",6)
	      continue:((tInsuType'=InsuType)&&(InsuType'=""))
	     If ##class(User.INSULocRec).%ExistsId(id)
	      {
	        s objInLocRec=##class(User.INSULocRec).%OpenId(id)
		    Continue:'$IsObject(objInLocRec.INLCRCTDr)
		    s tHospDr=""
		    s DeptDr=objInLocRec.INLCRCTDr.INLCIDeptDr.%Id()
		    s:DeptDr'="" tHospDr=$P(^CTLOC(DeptDr),"^",22)
	        Continue:tHospDr'=HospDr 
           }
		  d BuildInLocRec
	      s Flag=1
	  
     }
	  
 
	   
    }
    
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
    
BuildInLocRec   
 	s (TInd,TRowid,TCTDr,TCenterNo,TStates,TSeriNo,TBusiNo,TInsuType,TInsuTypeDesc,THSPUserDr,THSPUserCode,THSPUserName,THSPFlag,THSPDate,THSPTime,TISPUserDr,TISPFlag,TISPDate,TISPTime,TUserDr,TUserCode,TUserName,TDate,TTime,TExtStr02,TExtStr03,TExtStr04,TExtStr05)=""
    s TRowid=objInLocRec.%Id()
    if $IsObject(objInLocRec.INLCRCTDr) d
    .s TCTDr=objInLocRec.INLCRCTDr.%Id()
    s TCenterNo=objInLocRec.INLCRCenter
    s TStates=objInLocRec.INLCRStates
    s TSeriNo=objInLocRec.INLCRSeriNo
    s TBusiNo=objInLocRec.INLCRBusiNo
    s TInsuType=objInLocRec.INLCRInsuType
    ;s TInsuTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",TInsuType,4)
    s TInsuTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",TInsuType,4,HospDr)	;upt 20220613 HanZH
    if $IsObject(objInLocRec.INLCRHSPUserDr) d
    .s THSPUserDr=objInLocRec.INLCRHSPUserDr.%Id()
    s THSPUserCode=objInLocRec.INLCRHSPUserDr.SSUSRInitials
    s THSPUserName=objInLocRec.INLCRHSPUserDr.SSUSRName
    s THSPFlag=objInLocRec.INLCRHSPFlag
    ;s THSPFlag=$case(THSPFlag,"0":"已撤销","1":"已上传","2":"已变更",:"未上传")	;add HanZH 20220613	copy by ZhangYX
    s THSPFlag=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DeptUpldStas"_InsuType,THSPFlag,4,HospDr) ;upt 20220615 HanZH 新增字典配置
	
    s:+objInLocRec.INLCRHSPDate'=0 THSPDate=##class(websys.Conversions).DateLogicalToHtml(objInLocRec.INLCRHSPDate)
    s:+objInLocRec.INLCRHSPTime'=0 THSPTime=$zt(objInLocRec.INLCRHSPTime)
    s TISPUserDr=objInLocRec.INLCRISPUserDr
    i TISPUserDr'="" d
    .s TISPUserDr=$p($g(^SSU("SSUSR",TISPUserDr)),"^",2)	;add HanZH 20220613	copy by ZhangYX
    s TISPFlag=objInLocRec.INLCRISPFlag
    ;s TISPFlag=$case(TISPFlag,"0":"已撤销","1":"已上传","2":"已变更",:"其他")	;add HanZH 20220613	copy by ZhangYX
    s TISPFlag=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DeptUpldStas"_InsuType,TISPFlag,4,HospDr) ;upt 20220615 HanZH 新增字典配置
    s:+objInLocRec.INLCRISPDate'=0 TISPDate=##class(websys.Conversions).DateLogicalToHtml(objInLocRec.INLCRISPDate)  
    s:+objInLocRec.INLCRISPTime'=0 TISPTime=$zt(objInLocRec.INLCRISPTime)
    if $IsObject(objInLocRec.INLCRUserDr) d
    .s TUserDr=objInLocRec.INLCRUserDr.%Id()
    .s TUserCode=objInLocRec.INLCRUserDr.SSUSRInitials
    .s TUserName=objInLocRec.INLCRUserDr.SSUSRName
    s:+objInLocRec.INLCRDate'=0 TDate=##class(websys.Conversions).DateLogicalToHtml(objInLocRec.INLCRDate)   
    s:+objInLocRec.INLCRTime'=0 TTime=$zt(objInLocRec.INLCRTime)
    s TExtStr01=objInLocRec.INLCRExtStr01 
    s TExtStr02=objInLocRec.INLCRExtStr02 
    s TExtStr03=objInLocRec.INLCRExtStr03 
    s TExtStr04=objInLocRec.INLCRExtStr04 
    s TExtStr05=objInLocRec.INLCRExtStr05
    d BuildLocRecQry
    q 

BuildLocRecQry
   
    set Data=$lb(ind,TRowid,TCTDr,TCenterNo,TStates,TSeriNo,TBusiNo,TInsuType,TInsuTypeDesc,THSPUserDr,THSPUserCode,THSPUserName,THSPFlag,THSPDate,THSPTime,TISPUserDr,TISPFlag,TISPDate,TISPTime,TUserDr,TUserCode,TUserName,TDate,TTime,TExtStr02,TExtStr03,TExtStr04,TExtStr05)
 	Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	q
}

ClassMethod QryInLocRecInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInLocRecInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInLocRecInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInLocRecInfoExecute ]
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

/// w ##class(web.DHCINSULocRecCtl).GetLocRecById(1)
ClassMethod GetLocRecById(Id As %String) As %String
{
	n (Id)
	
	q:Id="" "-1!"
	
	q:'$d(^DHCINLCR(Id)) "-1!"
	
	s GetLocRecById=$g(^DHCINLCR(Id))
	
	i $p(GetLocRecById,"^",9)'="" d
	.s $p(GetLocRecById,"^",9)=$zd($p(GetLocRecById,"^",9),3)
	
	i $p(GetLocRecById,"^",10)'="" d
	.s $p(GetLocRecById,"^",10)=$zt($p(GetLocRecById,"^",10))
	
	i $p(GetLocRecById,"^",13)'="" d
	.s $p(GetLocRecById,"^",13)=$zd($p(GetLocRecById,"^",13),3)
	
	i $p(GetLocRecById,"^",14)'="" d
	.s $p(GetLocRecById,"^",14)=$zt($p(GetLocRecById,"^",14))
	
	i $p(GetLocRecById,"^",16)'="" d
	.s $p(GetLocRecById,"^",16)=$zd($p(GetLocRecById,"^",16),3)
	
	i $p(GetLocRecById,"^",17)'="" d
	.s $p(GetLocRecById,"^",17)=$zt($p(GetLocRecById,"^",17))
	
	s GetLocRecById="1!"_Id_"^"_GetLocRecById
	q GetLocRecById
}

/// 更新医保科室上传记录
/// add	Hanzh 20220613 copy by ZhangYX
/// w ##class(web.DHCINSULocRecCtl).UpdateLocRecById("1","3401","1^^^^^^")
ClassMethod UpdateLocRecById(Id As %String, Infno As %String, ExpStr As %String, HospDr As %String, InsuType As %String) As %String
{
	n (Id,Infno,ExpStr,HospDr,InsuType)
	
	//s Flag=$case(Infno,"3401":"1","3401A":"1","3402":"2","3403":"0",:"")
	s Flag=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DeptUpldStasToInfnoCon"_InsuType,Infno,6,HospDr) ;upt 20220615 HanZH 新增字典配置
	s rtn="-1"
	
	q:Flag="" rtn
	
	s ISPUserDr=$p(ExpStr,"^",1)
	s ISPDate=$p(ExpStr,"^",2)
	s ISPTime=$p(ExpStr,"^",3)
	s HSPDate=$p(ExpStr,"^",4)
	s HSPTime=$p(ExpStr,"^",5)
	
	i ISPDate="" d
	.s ISPDate=+$h
	e            d
	.s ISPDate=$zdh(ISPDate,3)
	
	i ISPTime="" d
	.s ISPTime=$p($h,",",2)
	e            d
	.s ISPTime=$zt(ISPTime)
	
	i HSPDate="" d
	.s HSPDate=+$h
	e            d
	.s HSPDate=$zdh(HSPDate,3)
	
	i HSPTime="" d
	.s HSPTime=$p($h,",",2)
	e            d
	.s HSPTime=$zt(HSPTime)
		
	&sql(update SQLUser.INSU_LocRec set 
		INLCR_HSPFlag=:Flag,
		INLCR_ISPFlag=:Flag,
		INLCR_ISPDate=:ISPDate,
		INLCR_ISPTime=:ISPTime,
		INLCR_HSPDate=:HSPDate,
		INLCR_HSPTime=:HSPTime,
		INLCR_ISPUserDr=:ISPUserDr 
	where INLCR_Rowid=:Id)
	
	q SQLCODE
}

/// 获取科室上传记录信息
/// add	Hanzh 20220613 copy by ZhangYX
/// w ##class(web.DHCINSULocRecCtl).GetCTLocInfo()
ClassMethod GetCTLocInfo() As %String
{
	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	
	s Ret="<Response><ResultCode>-1</ResultCode><ErrorMsg>未找到信息 </ErrorMsg></Response>"
	d objstream.Write(Ret)

	s Ret="<Response><ResultCode>0</ResultCode>"
    d objstream.Clear()
	d objstream.Write(Ret)
	
	s RowId=0
	s i=1
	f  s RowId=$o(^DHCINLCI(RowId)) q:(RowId="")  d
    .s Info=$g(^DHCINLCI(RowId))
    .s hospdeptcode=$p(Info,"^",1)	              ;医院科室编码
    .s caty=$p(Info,"^",5)                        ;科别
    .q:caty=""
    .s hospdeptname=$p(Info,"^",2)		          ;医院科室名称
    .s begntime=$p(Info,"^",22)                   ;开始时间
    .q:begntime=""
    .s endtime=$p(Info,"^",24)                    ;结束时间
    .s:begntime'="" begntime=$zd(begntime,3)
    .s:endtime'="" endtime=$zd(endtime,3)
    .s itro=$p($p(Info,"^",31),"|",1)             ;简介
    .q:itro=""
    
    .s deptrespername=$p(Info,"^",14)             ;科室负责人
    .q:deptrespername=""
    .s deptrespertel=$p(Info,"^",15)              ;科室负责人电话
    .q:deptrespertel=""
    .s deptmedservscp=$p($p(Info,"^",31),"|",2)   ;科室医疗服务范围
    .s deptestbdat=$p(Info,"^",9)                 ;科室成立日期
    .q:deptestbdat=""
    
    .s:deptestbdat'="" deptestbdat=$zd(deptestbdat,3)
    .s aprvbedcnt=$p(Info,"^",7)                  ;批准床位数量
    .q:aprvbedcnt=""
    .s hicrtfbedcnt=$p(Info,"^",8)                ;医保认可床位数 
    .s poolareano=""                              ;统筹区编号
    .s flag=""
    .s INLCRRowid=""             
    .s INLCRRowid=$o(^DHCINLCR("0","CTDR",RowId,INLCRRowid),-1)
    .i INLCRRowid'="" d
    ..s poolareano=$p($g(^DHCINLCR(INLCRRowid)),"^",2)
  	..s flag=$p($g(^DHCINLCR(INLCRRowid)),"^",8)
  	.q:(flag="1")||(flag="2")                      //已上传，已变更的不能再次上传
    .q:poolareano=""
    
    .s drpsncnt=$p(Info,"^",10)                    ;医师人数
    .q:drpsncnt=""
    .s pharpsncnt=$p(Info,"^",12)                  ;药师人数
    .q:pharpsncnt=""
    .s nurspsncnt=$p(Info,"^",13)                  ;护士人数
    .q:nurspsncnt=""
    .s tecnpsncnt=$p(Info,"^",11)                  ;技师人数
    .q:tecnpsncnt=""
    .s memo=$p(Info,"^",30)                        ;备注
       	
   	.//<------------------循环写xml 开始-------------------------------//
	.s Ret="<Row>"
	.s Ret=Ret_"<Number>"_i_"</Number>"                               ;序号
	.s Ret=Ret_"<hosp_dept_codg>"_hospdeptcode_"</hosp_dept_codg>"    ;医院科室编码
	.s Ret=Ret_"<caty>"_caty_"</caty>"                           ;科别
	.s Ret=Ret_"<hosp_dept_name>"_hospdeptname_"</hosp_dept_name>"    ;医院科室名称
	.s Ret=Ret_"<begntime>"_begntime_"</begntime>"                    ;开始时间
	.s Ret=Ret_"<endtime>"_endtime_"</endtime>"                       ;结束时间
	.s Ret=Ret_"<itro>"_itro_"</itro>"                                ;简介
	.s Ret=Ret_"<dept_resper_name>"_deptrespername_"</dept_resper_name>"           ;科室负责人
	.s Ret=Ret_"<dept_resper_tel>"_deptrespertel_"</dept_resper_tel>"              ;科室负责人电话
	.s Ret=Ret_"<dept_med_serv_scp>"_deptmedservscp_"</dept_med_serv_scp>"         ;科室医疗服务范围
	.s Ret=Ret_"<dept_estbdat>"_deptestbdat_"</dept_estbdat>"           ;科室成立日期	
	.s Ret=Ret_"<aprv_bed_cnt>"_aprvbedcnt_"</aprv_bed_cnt>"            ;批准床位数量
	.s Ret=Ret_"<hi_crtf_bed_cnt>"_hicrtfbedcnt_"</hi_crtf_bed_cnt>"    ;医保认可床位数 
	.s Ret=Ret_"<poolarea_no>"_poolareano_"</poolarea_no>"              ;统筹区编号     
	.s Ret=Ret_"<dr_psncnt>"_drpsncnt_"</dr_psncnt>"                    ;医师人数
	.s Ret=Ret_"<phar_psncnt>"_pharpsncnt_"</phar_psncnt>"              ;药师人数
	.s Ret=Ret_"<nurs_psncnt>"_nurspsncnt_"</nurs_psncnt>"              ;护士人数
	.s Ret=Ret_"<tecn_psncnt>"_tecnpsncnt_"</tecn_psncnt>"              ;技师人数
	.s Ret=Ret_"<memo>"_memo_"</memo>"                                  ;备注
	.s Ret=Ret_"<INLCR_Rowid>"_INLCRRowid_"</INLCR_Rowid>"              ;科室上传记录表rowid
	.s Ret=Ret_"</Row>"
	.s ^CacheTemp("StrToXML",i)=Ret
	.d objstream.Write(Ret)
	.s i=i+1
	.//<------------------循环写xml结束  -------------------------------//
	
	s Ret="</Response>"
	d objstream.Write(Ret)
	b //1 
	q objstream.Read(objstream.Size)
}

}
