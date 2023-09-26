Import sqluser

Class web.DHCSTMHUI.Common.Logistics Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 插入请求单物流表
/// Author:zhwh
/// Date:2014-08-20
/// Arguments:
///   inrq - 请求单主表RowId
///   user - 用户RowId
///   status -状态
///   remark- 备注
/// Return:
///   0 - success  
///   <0 - failure
/// w ##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus("4895","RD","","619")
ClassMethod CreateReqMoveStatus(inrq As %String, status As %String, remark As %String, user As %String, paramStr As %String = "") As %String
{
  n (inrq,status,remark,user,paramStr)
  s paramStr=$g(paramStr)
  s seq=..GetMoveSeqNo() //物流号
  s d=+$h
  s t=$p($h,",",2)
  i inrq="" q -1
  i status="" q -2
  i seq="" q -3
  &sql(insert into sqluser.DHC_INREQ_MoveStatus (M_INRQ_DR,M_SeqNo,M_MoveStatus,M_SSUSR_DR,M_Date,M_Time,M_Remark)
   values (:inrq,:seq,:status,:user,:d,:t,:remark))
  i SQLCODE'=0 q -10
  s AppName="DHCSTCOMMONM"
  s IfPortal=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"IfPortal",paramStr)
  q:IfPortal'="Y" 0
  s tUserName1=""
  s loginName=""  //根据用户的rowid 得到用户的code
  &sql(SELECT SSUSR_Initials,SSUSR_Name into :loginName , :tUserName1  FROM ss_user WHERE SSUSR_RowId=:user)
  //标题使用的用户名称
  s tUserName=""
  s proloccode="00"
  i status'="RD" d
  .&sql(select INRQ_SSUSR_DR->SSUSR_Name,INRQ_ReqLoc_DR->ctloc_code into :tUserName, :proloccode from IN_Request where INRQ_RowId=:inrq)
  e  d
  .s tUserName=tUserName1
  
  s thirdId=inrq
  s activityId=""
  s flowFlag=""
  s title=tUserName_"的请领单"
  s participantCode=""  //下一个操作者的code
  i status="RD" d //制作请领单  
  .s activityId="acti6c57ccac8200"  
  .s flowFlag="1" 
  .s participantCode="8a8185c5486497300148692e8099005e"
  i status="RA" d  //请求方审核
  .s activityId="acti6c5b21cc8200"  
  .s flowFlag="2"
  .s participantCode="8a8185c5486497300148692ec3150060"
  i status="EA" d  //供应方审核
  .s activityId="actid6fe471c860b"  
  .s flowFlag="2"
  .s participantCode="8a8185c54864973001486ca047cc006c"
  i status="RAN" d  //请求方审核拒绝
  .s activityId="acti6bf522148200"  
  .s flowFlag="4"
  i status="EAN" d  //供应方审核拒绝
  .s activityId="acti6bf522148200"  
  .s flowFlag="4"
  i status="IS" d   //库存转移保存
  .s activityId="acti5a31623c8452"  
  .s flowFlag="2"
  .s participantCode="8a8185c5486497300148692fd26f0064"
  i status="ID" d   //库存转移完成
  .s activityId="acti6ccd45548200"  
  .s flowFlag="2"
  .s participantCode="8a8185c5486497300148692fd26f0064"
  i status="IO" d //出库审核
  .s activityId="actib26eab58860b"  
  .s flowFlag="2"
  .s participantCode="8a8185c548794d9701487c0a7218000b"
  i status="IIR" d  //出库审核拒绝
  .s activityId="acti5a31623c8452"  
  .s flowFlag="4"
  .s participantCode="8a8185c54864973001486ca047cc006c"
  i status="II" d  //确认收货
  .s activityId="acti75a1169c8200"  
  .s flowFlag="5"
  .s participantCode=""
  i status="IIN" d  //确认收货拒绝
  .s activityId="acti5a31623c8452"  
  .s flowFlag="4"
  .s participantCode=""
  ;s str1 = "{""loginName"":""186"",""thirdId"":""""_:thirdId_"""",""systemCode"":""applay"",""businessCode"":""001"",""title"":"""_title_""",""participantCode"":"""_participantCode_""",""flowFlag"":"""_flowFlag_""",""activityId"":""_:activityId_""}"""
  s str1 ="loginName@"_loginName_"^thirdId@"_thirdId_"^systemCode@"_"applay"_"^businessCode@"_" 001"_"^title@"_title_"^supplyDep@"_proloccode_"^flowFlag@"_flowFlag_"^activityId@"_activityId
	 ///oa 对接
  i '$d(^$R("^DtPortal.OA.ApplyService.ApplyServiceHttpPort.1")) q 0   //判断该类是否存在,此处改为返回0.
  s str=..getPatInfo(str1)
  s soap=##class(DtPortal.OA.ApplyService.ApplyServiceHttpPort).%New()
  s ret=soap.ThirdSysApply(str)
  q 0
}

/// / s retStr="REGNO@"_regNo_"^LOC@"_ctlocDesc_"^ROOM@"_$g(room)_"^SEX@"_$g(sex)_"^PATNAME@"_$g(patName)_"^BEDCODE@"_$g(bedCode)_"^AGE@"_$g(age)_"岁^WARD@"_$g(wardDesc)_"^DIAG@"_diag_"^MedCareNo@"_MedCareNo_"^Telephone@"_homeTel_"^PatAddress@"_homeAddres_"^BirthDate@"_$ZD(birth,3)_"^BirthDate@"_$ZD(birth,3)_"^AdmDate@"_AdmDate_"^AdmTime@"_AdmTime_"^DischgDate@"_DischgDate_"^DischgTime@"_DischgTime_"^Nation@"_Nation_"^admreason@"_admreason_"^paersonLX@"_paersonLX_"^PAPEROccupationdesc@"_PAPEROccupationdesc_"^PAPERCTRLTDesc@"_PAPERCTRLTDesc_"^PAPERMaritalDesc@"_PAPERMaritalDesc
ClassMethod getPatInfo(patInfoStr)
{
	
	s infoNum=$l(patInfoStr,"^")
	s json=##class(%ArrayOfDataTypes).%New()
	f i=1:1:infoNum
	{
		s info=$p(patInfoStr,"^",i)
		continue:info=""
		s infoName=$p(info,"@",1)
		continue:infoName=""
		s infoValue=$p(info,"@",2)
		i infoValue["-" s infoValue=$p(infoValue,"-",2)
		d json.SetAt(infoValue,infoName)
	}
	
	q ##class(Nur.JSON).Encode(json)
}

/// 取物流号(目前暂时用"大流水号")
/// 
ClassMethod GetMoveSeqNo() As %String
{
  q $i(^DHCINREQMOVESEQ)
}

/// Description:取出相关菜单名称、授权科室的授权用户
/// Author:zhwh
/// Date:2014-09-11
/// Arguments:
///  menuname - 菜单名称
///  locid  - 科室rowid
/// Return:
///  授权用户串(使用";"分隔)
/// d ##class(web.DHCSTMHUI.Common.Logistics).InformUser("DHCSTM.DHCINScrap","153")
ClassMethod InformUser(menuname, locid) As %String
{
	n (menuname,locid)
	
    ;s menuname="DHCSTM.DHCINScrap"
    ;s locid=153
	s users=..GetAccessUserByMenu(menuname)
	w users,!
	s result=""
	q:users="" result

	f i=1:1:$l(users,"^") d
	.s user=$P(users,"^",i)
	.q:user=""
	.s locs=..UserLoc(user)
	.w locs,!
	.q:(locs_"^")'[("^"_locid_"^")
	.i result'="" s result=result_";"_user
	.e  s result=user
	q result
}

/// Description: 根据用户id取出其授权访问的科室,根据SSGroupStockLocation,缺省科室,其他登录科室
/// Author:zhwh
/// Date:214-09-11
/// Arguments:
///  user - 用户id
/// Return:
///  授权科室串("^"分隔,首尾用"^"修饰，如: "^101^34^44^" )
ClassMethod UserLoc(user As %String) As %String
{
  n (user)
  &sql(declare x1 cursor for 
    SELECT st_ctloc_dr FROM ss_groupstocklocations
	WHERE st_parref in (SELECT ssusr_group FROM ss_user WHERE SSUSR_Initials=:user) 
	UNION
	SELECT ssusr_defaultdept_dr FROM ss_user WHERE SSUSR_Initials =:user
	UNION
	SELECT othll_ctloc_Dr FROM SS_UserOtherLogonLoc WHERE othll_parref->SSUSR_Initials=:user
	)
  &sql(open x1)
  s locs=""
  f  &sql(fetch x1 into :loc) q:SQLCODE  d
  .s locs=locs_"^"_loc
  .
   &sql(close x1)
  i locs'="" s locs=locs_"^"
  q locs
}

/// Creator： wuqk
/// CreatDate： 2013-07-09
/// Description: 按菜单名称获取有权限的用户
/// Table： websys.Menu,User.SSUser,User.SSGroup,epr.GroupSettings
/// Input： MenuName:websys.Menu.Name
/// output: userList:User.SSUser.SSUSRInitials split by ^
/// w ##class(websys.CASService).GetAccessUserByMenu("DHCMedInfFeedBack")
/// 
ClassMethod GetAccessUserByMenu(MenuName As %String) As %String
{
	new (MenuName)
	set MenuID=$o(^websys.MenuI("UniqueNameIndex"," "_$zcvt(MenuName,"U"),0))
	quit:MenuID="" ""
	//检查各用户所属的安全组，按安全组构造用户列表
	set UserGrp=""
	set userID=0
	for {
		set userID=$o(^SSU("SSUSR",userID))
		quit:userID=""
		s objUser = ##class(User.SSUser).%OpenId(userID)
		s DefaultLoc=objUser.SSUSRDefaultDeptDR.CTLOCDesc
		s DefaultGrp = $s($IsObject(objUser.SSUSRGroup):objUser.SSUSRGroup.SSGRPDesc,1:"")
		s:DefaultGrp'="" UserGrp(objUser.SSUSRGroup.%Id(),userID)=objUser.SSUSRInitials //_"/"_objUser.SSUSRName

		s myCount = objUser.ChildSSUserOtherLogonLoc.Count()
		f myIdx=1:1:myCount{
			s objUserLoc=objUser.ChildSSUserOtherLogonLoc.GetAt(myIdx)
			//s myLoc=objUserLoc.OTHLLCTLOCDR.CTLOCDesc
			s myGroup=$s($IsObject(objUserLoc.OTHLLUserGroupDR):objUserLoc.OTHLLUserGroupDR.SSGRPDesc, 1:"")
			s:myGroup'="" UserGrp(objUserLoc.OTHLLUserGroupDR.%Id(),userID)=objUser.SSUSRInitials //_"/"_objUser.SSUSRName
		}
	}
    ; b
	//判断各安全组是否有指定菜单的权限
	set userList=""
	set groupid=0
	for {
		set groupid = $o(^SSU("SSGRP",groupid))
		quit:groupid=""
		set ms=0
		set eprRowid=$o(^ooGroupSettingsI("GroupDRIndex",groupid,0))
		set objEprGroup=##Class(epr.GroupSettings).%OpenId(+eprRowid,0)
		if $IsObject(objEprGroup){
			set security=objEprGroup.MenuSecurity
			if $zbitlen(security)>=+MenuID{
				set ms=$zbitget(security,+MenuID)
			}
			do objEprGroup.%Close()
			set objEprGroup=""
		}
		continue:ms=0
		//set groupDesc=$p(^SSU("SSGRP",groupid),"^",1)
		//w !,groupDesc,",groupid="_groupid
		set userID=0

		for {
			set userID=$o(UserGrp(groupid,userID))
			quit:userID=""
			//w !,"----"
			//w $g(UserGrp(groupid,userID))
			
			i userList="" d
			.set userList=$g(UserGrp(groupid,userID))_"^"_userList
			e  d
			.i ("^"_userList)'[("^"_$g(UserGrp(groupid,userID))_"^") d
			..set userList=$g(UserGrp(groupid,userID))_"^"_userList
		}
	}
	
	quit userList
}

}
