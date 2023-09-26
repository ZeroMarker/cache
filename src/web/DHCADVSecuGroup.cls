Import SQLUSER

Class web.DHCADVSecuGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2017-12-10
/// Description:： 保存或者新增 安全小组字典
/// Table：        DHC_AdvSecuGroup 
/// Input：	       SECUCode：代码
///                SECUDesc：描述
///                SECUActiveFlag：是否可用             
///                SECUHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
  		 s SECUCode=$p(str,"^",1)
		 s SECUDesc=$p(str,"^",2)
		 s SECUActiveFlag=$p(str,"^",3)
		 s SECUHospDr=$p(str,"^",4)
		 s SECUHospDrID=$p(str,"^",5)
		 s ID=$p(str,"^",6)

		 i +ID=0 
		 { 
		 	 s obj=##class(User.DHCAdvSecuGroup).%New()
		 	 s obj.SECUHospDr=##class(User.CTHospital).%OpenId(SECUHospDr)
		 	 Q:$d(^DHCADVSECUG(0,"code",SECUCode)) 1
		 	
		 }else{
			 s obj=##class(User.DHCAdvSecuGroup).%OpenId(ID)
			 q:(SECUActiveFlag'=obj.SECUActiveFlag)&&($d(^DHCADREVTWFGR(0,"TypePointer",5,ID))) 2
			 i +SECUHospDr=0 d
			 .s obj.SECUHospDr=##class(User.CTHospital).%OpenId(SECUHospDrID)
			 e  d
			 .s obj.SECUHospDr=##class(User.CTHospital).%OpenId(SECUHospDr)
			 
			 s isIN=0
			 i $d(^DHCADVSECUG(0,"code",SECUCode)) d
			 .s IDUP=$O(^DHCADVSECUG(0,"code",SECUCode,""))
			 .q:IDUP=ID
			 .s isIN=1
			 q:isIN=1 1
			  }
	
		 s obj.SECUCode=SECUCode
		 s obj.SECUDesc=SECUDesc
		 s obj.SECUActiveFlag=SECUActiveFlag

	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SaveSecuGro(params)
{
  
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-12-10
/// Description:： 分页显示安全小组字典
/// Table：        DHC_AdvSecuGroup 
/// Input：	      page：当前页数
///               rows：每页条数    
/// d ##class(web.DHCADVSecuGroup).ListSecuGro(,,"","","")
ClassMethod ListSecuGro(page = 1, rows = 10, SECUCode, SECUDesc, hospID, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s Id=""
		f  s Id=$o(^DHCADVSECUG(Id)) q:Id=""  d
		.q:Id=0
		.s code=$p(^DHCADVSECUG(Id),"^",1)
		.s desc=$p(^DHCADVSECUG(Id),"^",2)
		.s SECUHospDr=$p(^DHCADVSECUG(Id),"^",3)
		.s SECUActiveFlag=$p(^DHCADVSECUG(Id),"^",4)
		.s HospDesc=""
		.i SECUHospDr'="" s HospDesc=$P($g(^CT("HOSP",SECUHospDr)),"^",2)
		.s tmp=Id_"^"_code_"^"_desc_"^"_SECUActiveFlag_"^"_HospDesc_"^"_SECUHospDr
		.q:(SECUCode'="")&(code'[SECUCode)
		.q:(SECUDesc'="")&(desc'[SECUDesc)
		.q:(hospID'="")&(hospID'=SECUHospDr) //hxy 2019-07-23
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmPatHistory).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^SECUCode^SECUDesc^SECUActiveFlag^SECUHospDr^SECUHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-12-10
/// Description:： 查找一条安全小组字典,以json形式返回
/// Table：        DHC_AdvSecuGroup 
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCADVSecuGroup).FindSecuGro(1)
ClassMethod FindSecuGro(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCAdvSecuGroup).%OpenId(Id)).Json()
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-12-10
/// Description:： 删除安全小组字典
/// Table：        DHC_AdvSecuGroup 
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveSecuGro(Id)
{
	  q:+Id=0 -1
	  q:$d(^DHCADREVTWFGR(0,"TypePointer",5,Id)) -2
	  s obj=##class(User.DHCAdvSecuGroup).%DeleteId(Id)
	  s UserDr=""
	  f  s UserDr=$o(^DHCADVSECUGU(0,"GroupUser",Id,UserDr)) q:UserDr=""  d
	  .s GUId=""
	  .f  s GUId=$o(^DHCADVSECUGU(0,"GroupUser",Id,UserDr,GUId)) quit:GUId=""  d 
	  ..q:GUId=0
	  ..s q=..RemoveSecuGroU(GUId)
	  .
	  
	  q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-12-10
/// Description:： 删除安全小组人员
/// Table：        DHC_AdvSecuGroupUser 
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
/// d ##class(web.DHCADVSecuGroup).RemoveSecuGroU(17)
ClassMethod RemoveSecuGroU(Id)
{
  
	  q:+Id=0 -1
	  s GrpDr=$p(^DHCADVSECUGU(Id),"^",1)
	  s UserDr=$p(^DHCADVSECUGU(Id),"^",2)
	  s SECUWardDr=""
	  f  s SECUWardDr=$o(^DHCADVSECUGUW(0,"GroupUserWard",GrpDr,UserDr,SECUWardDr)) q:SECUWardDr=""  d
	  .i SECUWardDr'="" s SECUWard=$P($g(^PAWARD(SECUWardDr)),"^",1)
	  .s GUWId=""
	  .f  s GUWId=$o(^DHCADVSECUGUW(0,"GroupUserWard",GrpDr,UserDr,SECUWardDr,GUWId)) quit:GUWId=""  d 
	  ..q:GUWId=0
	  ..s obj=##class(User.DHCAdvSecuGroupUserWard).%DeleteId(GUWId)
	  .
	  //删除人员时，同时删掉关联的科室 sufan 2018-05-22
	  s SECULocDr=""
	  for  s SECULocDr=$o(^DHCADVSECUGUL(0,"GroupUserLoc",GrpDr,UserDr,SECULocDr))  q:SECULocDr=""  d
	  .s SECUId=""
	  .for  s SECUId=$o(^DHCADVSECUGUL(0,"GroupUserLoc",GrpDr,UserDr,SECULocDr,SECUId))  q:SECUId=""  d
	  ..q:SECUId=0
	  ..s obj=##class(User.DHCAdvSecuGroupUserLoc).%DeleteId(SECUId)
	  s obj=##class(User.DHCAdvSecuGroupUser).%DeleteId(Id)
	  q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-12-10
/// Description:： 删除分管病区字典
/// Table：        DHC_AdvSecuGroupUserWard 
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveSecuGroUW(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCAdvSecuGroupUserWard).%DeleteId(Id)
	  q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-12-10
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMPatHistory).ListIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-12-12
/// Description：  人员下拉列表显示
/// Table：        SS_User
/// Return
/// d ##class(web.DHCADVSecuGroup).ListUser(,,"",2,"")
ClassMethod ListUser(page = 1, rows = 10, text, SECURowId, q, HospID)
{
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s HospDr=$p($g(^DHCADVSECUG(+SECURowId)),"^",3) //hxy 2020-03-19 add
	 w "{""rows"":["
	 s count=0
	 s phId=0
     f  s phId=$o(^SSU("SSUSR",phId)) q:phId=""  d
     .s Code=$P(^SSU("SSUSR",phId),"^",1)
	 .s Codename=$P(^SSU("SSUSR",phId),"^",2)
	 .s Code=Codename_" ("_Code_")"
	 .s tmp=phId_"^"_Code
	 .q:(text'="")&(text'=Code)
	 .q:(q'="")&($$ALPHAUP^SSUTIL4(Code)'[$$ALPHAUP^SSUTIL4(q))
	 .q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("SS_User",phId,HospID)'="Y"  ///2021-06-16 cy 多院区
	 .s count = count+1
	 .q:count<start
 	 .q:count>end
 	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      yangjiabao
/// CreatDate：    2021-04-28
/// Description:   保存 安全小组人员表
/// Table：        DHC_AdvSecuGroupUser 
/// Input：	       SECUGrpDr,SECUUserDr,SECULeadFlag
/// Return：       保存成功 0，其他 失败
///  d ##class(web.DHCADVSecuGroup).SaveOrUpdateGU("1^1^ ^")
ClassMethod SaveOrUpdateGU(str)
{
     s CurLeadFlag="" //hxy 2018-02-07   
	 s SECUGrpDr=$p(str,"^",1)
	 s SECUUserDr=$p(str,"^",2)
	 s SECULeadFlag=$p(str,"^",4)
	 s SECURowID=$p(str,"^",5)
     i SECUUserDr=0 q 2
     if (+SECURowID=0){
	     s obj=##class(User.DHCAdvSecuGroupUser).%New()
	     Q:$d(^DHCADVSECUGU(0,"GroupUser",SECUGrpDr,SECUUserDr)) 1
		 i SECULeadFlag="Y" d //hxy 只允许存在一个组长
		 .s CurLeadFlag=..GetLeadFlag(SECUGrpDr)
		 Q:CurLeadFlag="Y" 3  //hxy ed
		 s obj.SECUUserDr=##class(User.SSUser).%OpenId(SECUUserDr) 
		 s obj.SECULeadFlag=SECULeadFlag

	     }  
     else{
	      s obj=##class(User.DHCAdvSecuGroupUser).%OpenId(SECURowID)
	      s OldUser=$p($g(^DHCADVSECUGU(SECURowID)),"^",2)	     
			if (obj.SECULeadFlag=SECULeadFlag){
				Q:$d(^DHCADVSECUGU(0,"GroupUser",SECUGrpDr,SECUUserDr)) 1
				s obj.SECUUserDr=##class(User.SSUser).%OpenId(SECUUserDr)
			}else {					
				;Q:$d(^DHCADVSECUGU(0,"GroupUser",SECUGrpDr,SECUUserDr)) 1
				  i SECULeadFlag="Y" d //hxy 只允许存在一个组长
				.s CurLeadFlag=..GetLeadFlag(SECUGrpDr)
				Q:CurLeadFlag="Y" 3
				s obj.SECULeadFlag=SECULeadFlag
				s obj.SECUUserDr=##class(User.SSUser).%OpenId(SECUUserDr)
			}
			s UpdOtherFlag=..UpdSecLocWardData(SECUGrpDr,OldUser,SECUUserDr)
			q:UpdOtherFlag'=0 -99
	     }	 
	 s obj.SECUGrpDr=##class(User.DHCAdvSecuGroup).%OpenId(SECUGrpDr)
     s sc=obj.%Save()   
	 ;i $$$ISERR(sc) q -2
	 q 0
}

/// Description: 修改大科人员后同步修改关联的科室、病区的指向人员数据
/// Creator:     CongYue
/// CreateDate:  2022-01-22
/// Others: 	 d ##class(web.DHCADVSecuGroup).UpdSecLocWardData()
ClassMethod UpdSecLocWardData(SecuGroupDr, OldUserDr, NewUserDr) As %String
{
	
	TS
	// 修改大科人员后同步修改关联的科室 指向人员 数据
	I $d(^DHCADVSECUGUL(0,"GroupUserLoc",SecuGroupDr,OldUserDr)) D
	.&SQL(Update DHC_AdvSecuGroupUserLoc set SECUGUL_User_Dr=:NewUserDr Where SECUGUL_Grp_Dr=:SecuGroupDr And SECUGUL_User_Dr=:OldUserDr)
	I +$g(SQLCODE)'=0 tro
	Q:+$g(SQLCODE)'=0 SQLCODE

	// 修改大科人员后同步修改关联的病区 指向人员 数据
	I $d(^DHCADVSECUGUW(0,"GroupUserWard",SecuGroupDr,OldUserDr)) D
	.&SQL(Update DHC_AdvSecuGroupUserWard set SECU_User_Dr=:NewUserDr Where SECU_Grp_Dr=:SecuGroupDr And SECU_User_Dr=:OldUserDr)
	I +$g(SQLCODE)'=0 tro
	Q:+$g(SQLCODE)'=0 SQLCODE
	TC
	
	Q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2018-02-07
/// Description:   遍历确定是否已有组长
/// Table：        DHC_AdvSecuGroupUser 
/// Input：	       SECUGrpDr
/// Return：       LeadFlag 
ClassMethod GetLeadFlag(GrpDr)
{
	s GUId="",LeadFlag=""
	f  s GUId=$o(^DHCADVSECUGU(GUId)) q:GUId=""  d
	.q:GUId=0
	.s SECUGrpDr=$p($g(^DHCADVSECUGU(GUId)),"^",1)
	.q:SECUGrpDr'=GrpDr
	.s SECULeadFlag=$p($g(^DHCADVSECUGU(GUId)),"^",3)
	.i SECULeadFlag="Y" s LeadFlag="Y"
	q LeadFlag
}

/// Creator：      huaxiaoying
/// CreatDate：    2018-02-07
/// Description:   判断组长是否能更新，能则更新
/// Table：        DHC_AdvSecuGroupUser 
/// Input：	       Id, LeadFlag
/// Return：        
ClassMethod UpdateGUByLeadFlag(Id, LeadFlag)
{
	s CurLeadFlag=""
	i LeadFlag="Y" d
	.s SECUGrpDr=$p($g(^DHCADVSECUGU(Id)),"^",1)
	.i SECUGrpDr'="" s CurLeadFlag=..GetLeadFlag(SECUGrpDr)
	Q:CurLeadFlag="Y" 3  
	&SQL(Update DHC_AdvSecuGroupUser Set SECU_LeadFlag=:LeadFlag Where SECUGU_RowId =:Id)
	q SQLCODE
}

ClassMethod saveSecuGU(params)
{
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdateGU(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-12-12
/// Description：  病区下拉列表显示
/// Table：        Pac_ward
/// Return
/// d ##class(web.DHCADVSecuGroup).ListWard(,,"","")
ClassMethod ListWard(page = 1, rows = 10, text, q, HospID)
{
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s:q'="" q=$zcvt(q,"U")
	 w "{""rows"":["
	 s count=0
	 s phId=0
     f  s phId=$o(^PAWARD(phId)) q:phId=""  d
     .s Code=$P($g(^PAWARD(phId)),"^",1)
     .s Desc=$P($g(^PAWARD(phId)),"^",2)
     .q:Desc=""
     .s Flag=$P($g(^PAWARD(phId)),"^",6)
     .q:Flag="N"
     .s StDate=$p($g(^PAWARD(phId)),"^",7)  //开始日期  sufan 2018-05-22
     .q:(StDate'="")&&(StDate>+$h)
     .s EndDate=$p($g(^PAWARD(phId)),"^",9) //结束日期  sufan 2018-05-22
     .q:(EndDate'="")&&(EndDate<+$h)
     .s QuitCode=##class(web.DHCINSUPort).GetCNCODE(Desc,4,"")   ///sufan 2018-06-06
     .s QuitCode=$zcvt(QuitCode,"U")  
     .s LocDr=$P($g(^PAWARD(phId)),"^",5)
	 .q:(text'="")&&(text'=Desc)
	 .q:(q'="")&&((QuitCode_Desc)'[q)
	 .q:##class(web.DHCADVCOMMON).GetHospShowDataFlagSpecial("CT_Loc",LocDr,HospID,"","DHC_ADVSecuGroup")'="Y"
	 .S:Desc["-" Desc=$p(Desc,"-",2)
	 .s tmp=phId_"^"_Desc
	 .s count = count+1
	 .q:count<start
 	 .q:count>end
 	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-12-12
/// Description:   保存 安全小组分管病区表
/// Table：        DHC_AdvSecuGroupUserWard 
/// Input：	       SECURowId,SECUUserDr,SECULeadFlag
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdateGUW(str)
{
	 s Drs=$p(str,"^",1)
	 s SECUGrpDr=$p(Drs,"*",1)
	 s SECUUserDr=$p(Drs,"*",2)
	 s SECUWardDr=$p(str,"^",2)
     i SECUWardDr=0 q 2
    
	 s obj=##class(User.DHCAdvSecuGroupUserWard).%New()
	 Q:$d(^DHCADVSECUGUW(0,"GroupUserWard",SECUGrpDr,SECUUserDr,SECUWardDr)) 1
	 s obj.SECUGrpDr=##class(User.DHCAdvSecuGroup).%OpenId(SECUGrpDr)
	 s obj.SECUUserDr=##class(User.SSUser).%OpenId(SECUUserDr)  
	 s obj.SECUWardDr=##class(User.PACWard).%OpenId(SECUWardDr) 
     s sc=obj.%Save()   
	 ;i $$$ISERR(sc) q -2
	 q 0
}

ClassMethod saveSecuGUW(params)
{
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdateGUW(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-12-12
/// Description:   界面输出
/// Table：        DHC_AdvSecuGroupUser 
/// Input：	       Id
/// Return：       Str
/// d ##class(web.DHCADVSecuGroup).ToHtml(1)
ClassMethod ToHtml(GrpDr)
{
	s GUId="",Str="",WardStr=""
	f  s GUId=$o(^DHCADVSECUGU(GUId)) q:GUId=""  d
	.q:GUId=0
	.s SECUGrpDr=$p($g(^DHCADVSECUGU(GUId)),"^",1)
	.q:SECUGrpDr'=GrpDr
	.s SECUUserDr=$p($g(^DHCADVSECUGU(GUId)),"^",2)
	.i SECUUserDr'="" s UserDesc=$p($g(^SSU("SSUSR",SECUUserDr)),"^",2)
	.s SECULeadFlag=$p($g(^DHCADVSECUGU(GUId)),"^",3)
	.s WardStr=..GetSecuGUW(GrpDr,SECUUserDr)
	.s LocStr=..GetSecuGUL(GrpDr,SECUUserDr)  ;2018-01-12 cy 科室
	.s Str=Str_GUId_"^"_UserDesc_"^"_SECULeadFlag_"^"_GrpDr_"*"_SECUUserDr_"^"_WardStr_"^"_LocStr_"!!"
	q """"_Str_""""
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-12-13
/// Description:   界面输出
/// Table：        DHC_AdvSecuGroupUserWard
/// Input：	       
/// Return：       html
/// d ##class(web.DHCADVSecuGroup).GetSecuGUW(1,25)
ClassMethod GetSecuGUW(GrpDr, UserDr)
{
	/*s GUWId="",WardStr="",SECUWard=""
	f  s GUWId=$o(^DHCADVSECUGUW(GUWId)) q:GUWId=""  d
	.q:GUWId=0
	.s SECUGrpDr=$p($g(^DHCADVSECUGUW(GUWId)),"^",1)
	.s SECUUserDr=$p($g(^DHCADVSECUGUW(GUWId)),"^",2)
	.Q:((SECUGrpDr'=GrpDr)&(SECUUserDr'=UserDr))
	.s SECUWardDr=$p($g(^DHCADVSECUGUW(GUWId)),"^",3)
	.i SECUWardDr'="" s SECUWard=$P($g(^PAWARD(SECUWardDr)),"^",1)
	.s WardStr=WardStr_GUWId_"*"_SECUWard_"^"
	q """"_GrpDr_"*"_UserDr_"^"_WardStr_""""*/
	s SECUWardDr="",WardStr="",SECUWard=""
	f  s SECUWardDr=$o(^DHCADVSECUGUW(0,"GroupUserWard",GrpDr,UserDr,SECUWardDr)) q:SECUWardDr=""  d
	.i SECUWardDr'="" s SECUWard=$P($g(^PAWARD(SECUWardDr)),"^",2)
	.s:SECUWard["-" SECUWard=$p(SECUWard,"-",2)
	.s GUWId=""
	.f  s GUWId=$o(^DHCADVSECUGUW(0,"GroupUserWard",GrpDr,UserDr,SECUWardDr,GUWId)) quit:GUWId=""  d 
	..q:GUWId=0
	..s WardStr=WardStr_GUWId_"*"_SECUWard_"||"
	.
	q WardStr
}

/// Creator：      congyue
/// CreatDate：    2018-01-12
/// Description：  科室下拉列表显示
/// Table：        CT_Loc
/// Return
/// d ##class(web.DHCADVSecuGroup).ListLoc(,,"","")
ClassMethod ListLoc(page = 1, rows = 10, text, q, HospID)
{
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s:q'="" q=$zcvt(q,"U")

	 w "{""rows"":["
	 s count=0
	 s phId=0
     f  s phId=$o(^CTLOC(phId)) q:phId=""  d
     .s Code=$P($g(^CTLOC(phId)),"^",1)
     .s Desc=$P($g(^CTLOC(phId)),"^",2)
     .s ContactName=$P($g(^CTLOC(phId)),"^",43)
     .s ContactName=$zcvt(ContactName,"U")  
     .s WardFalg=$P($g(^CTLOC(phId)),"^",5)	 /// 病区标识
     .q:(WardFalg'="")&&(WardFalg="Y")
     .s StDate=$P($g(^CTLOC(phId)),"^",24)   ///开始日期 sufan 2018-05-22
     .q:(StDate'="")&&(StDate>+$h)
     .s EndDate=$P($g(^CTLOC(phId)),"^",25)   ///结束日期 sufan 2018-05-22
     .q:(EndDate'="")&&(EndDate<+$h)
	 .q:(text'="")&&(text'=Desc)
	 .q:(q'="")&&((Desc_ContactName)'[q)
	 .;q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("CT_Loc",phId,HospID)'="Y" ///2021-06-16 cy 多院区
	 .q:##class(web.DHCADVCOMMON).GetHospShowDataFlagSpecial("CT_Loc",phId,HospID,"","DHC_ADVSecuGroup")'="Y"
	 .s:Desc["-" Desc=$p(Desc,"-",2)
	 .s tmp=phId_"^"_Desc
	 .s count = count+1
	 .q:count<start
 	 .q:count>end
 	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      congyue
/// CreatDate：    2018-01-12
/// Description:   保存 安全小组分管科室表
/// Table：        DHC_AdvSecuGroupUserLoc   
/// Input：	       SECUGULGrpDr,SECUGULUserDr,SECUGULLocDr
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdateGUL(str)
{
	 s Drs=$p(str,"^",1)
	 s SECUGULGrpDr=$p(Drs,"*",1)
	 s SECUGULUserDr=$p(Drs,"*",2)
	 s SECUGULLocDr=$p(str,"^",2)
     i SECUGULLocDr=0 q 2
    
	 s obj=##class(User.DHCAdvSecuGroupUserLoc).%New()
	 Q:$d(^DHCADVSECUGUL(0,"GroupUserLoc",SECUGULGrpDr,SECUGULUserDr,SECUGULLocDr)) 1
	 s obj.SECUGULGrpDr=##class(User.DHCAdvSecuGroup).%OpenId(SECUGULGrpDr)
	 s obj.SECUGULUserDr=##class(User.SSUser).%OpenId(SECUGULUserDr)  
	 s obj.SECUGULLocDr=##class(User.CTLoc).%OpenId(SECUGULLocDr) 
     s sc=obj.%Save()   
	 ;i $$$ISERR(sc) q -2
	 q 0
}

ClassMethod saveSecuGUL(params)
{
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdateGUL(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      congyue
/// CreatDate：    2018-01-12
/// Description:   界面输出
/// Table：        DHC_AdvSecuGroupUserLoc
/// Input：	       
/// Return：       html
/// d ##class(web.DHCADVSecuGroup).GetSecuGUL(1,25)
ClassMethod GetSecuGUL(GrpDr, UserDr)
{
	s SECUGULLocDr="",LocStr="",SECUGULLoc=""
	f  s SECUGULLocDr=$o(^DHCADVSECUGUL(0,"GroupUserLoc",GrpDr,UserDr,SECUGULLocDr)) q:SECUGULLocDr=""  d
	.i SECUGULLocDr'="" s SECUGULLoc=$P($g(^CTLOC(SECUGULLocDr)),"^",2)
	.s:SECUGULLoc["-" SECUGULLoc=$p(SECUGULLoc,"-",2)
	.s GULId=""
	.f  s GULId=$o(^DHCADVSECUGUL(0,"GroupUserLoc",GrpDr,UserDr,SECUGULLocDr,GULId)) quit:GULId=""  d 
	..q:GULId=0
	..s LocStr=LocStr_GULId_"*"_SECUGULLoc_"||"
	.
	q LocStr
}

/// Creator：      congyue
/// CreatDate：    2018-01-12
/// Description:： 删除分管科室字典
/// Table：        DHC_AdvSecuGroupUserLoc 
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveSecuGroUL(Id)
{
	  q:+Id=0 -1
	  s obj=##class(User.DHCAdvSecuGroupUserLoc).%DeleteId(Id)
	  q 0
}

/// Creator：      yangjiabao
/// CreatDate：    2021-04-28
/// Description:： 根据ID查询小组人员
/// Table：        DHC_AdvSecuGroupUser 
/// Input：	      Id：rowid
/// Return:SECUGrpDr安全小组id,SECUUserDr安全小组人员id,SECULeadFlag是否是组长,SECUUser人员名称,id:Roiw
/// d ##class(web.DHCADVSecuGroup).selUser(84)
ClassMethod selUser(id)
{
	s count=1
	q:id="" -1
	w "{""rows"":["
	s SECUGrpDr=$P($g(^DHCADVSECUGU(id)),"^",1)
	s SECUUserDr=$P($g(^DHCADVSECUGU(id)),"^",2)
	s SECULeadFlag=$P($g(^DHCADVSECUGU(id)),"^",3)

	s SECUUser=$P($g(^SSU("SSUSR",SECUUserDr)),"^",2)
	s tmp=SECUGrpDr_"^"_SECUUserDr_"^"_SECULeadFlag_"^"_SECUUser_"^"_id 
	w ##class(web.DHCAPPJsonCommon).getJsonData("SECUGrpDr^SECUUserDr^SECULeadFlag^SECUUser^SECURowID",tmp)
	w "],""total"":"_count_"}"
	q ""
}

}
