Import sqluser

/// Descript:   案例收藏
/// Creator:    shy
/// CreateDate: 2022-3-30
Class web.DHCPrescCaseCollection Extends %RegisteredObject
{

/// 获取作用域Combobox-主题
/// Input: 
/// Debug: d ##class(web.DHCPrescCaseCollection).GetThemeData()
/// Output:
ClassMethod GetThemeData() As %String
{
	w "["
	s count=0

	s id=""   f  s id=$o(^PHA.PREADT.CaseCollect5C3BD(id))   q:id=""  d
	.q:($lg(^PHA.PREADT.CaseCollect5C3BD(id),2)'=1)||($lg(^PHA.PREADT.CaseCollect5C3BD(id),3)'=1)
	.s Code= id
	.s Desc= $lg(^PHA.PREADT.CaseCollect5C3BD(id),4)
	.s listData=Code_"^"_Desc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("id^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",listData)	

	w "]"
	
	q ""
}

/// 获取作用域Combobox-级别
/// Input: 
/// Debug: d ##class(web.DHCPrescCaseCollection).GetLevelData()
/// Output:
ClassMethod GetLevelData() As %String
{
	w "["
	s count=0

	s id=""   f  s id=$o(^PHA.PREADT.CaseCollect5C3BD(id))   q:id=""  d
	.q:($lg(^PHA.PREADT.CaseCollect5C3BD(id),2)'=1)||($lg(^PHA.PREADT.CaseCollect5C3BD(id),3)'=2)
	.s Code= id
	.s Desc= $lg(^PHA.PREADT.CaseCollect5C3BD(id),4)
	.s listData=Code_"^"_Desc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("id^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",listData)	

	w "]"
	
	q ""
}

/// Creator：      Sunhuiyong
/// CreatDate：    2022-3-31
/// Desc:         
/// Input: G L U D
/// Debug: w ##class(web.DHCPrescCaseCollection).GetScopeValueDate("G")
/// Output:
ClassMethod GetScopeValueDate(type As %String, text, q) As %String
{
	s HospDr = %session.Get("LOGON.HOSPID") ///不管前台给的，直接从session中获取
	//s HospDr =2
	i type="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	Q:type="" ""
	if (type="G")
	{
	w "["
	s count=0
	s phId=0
	f  s phId=$o(^SSU("SSGRP",phId)) q:phId=""  d
	.i $d(^SSU("SSGRP",phId,"HOSP")) d
	..i $d(^SSU("SSGRP",phId,"HOSP",0,"Hosp",HospDr)) d
	...s SAHospDesc=$P(^SSU("SSGRP",phId),"^",1)
	...s activeFlag = $p(^SSU("SSGRP",phId),"^",151)
	...s stDate = $p(^SSU("SSGRP",phId),"^",153)
	...s endDate = $p(^SSU("SSGRP",phId),"^",154)
	...Q:(stDate>+$h)&(stDate'="")
	...Q:(endDate'="")&&(endDate<+$h) 
	...Q:(activeFlag'="")&&(activeFlag'="Y")      
	...s tmp=phId_"^"_SAHospDesc
	...q:(text'="")&(text'=SAHospDesc)
	...q:(q'="")&(SAHospDesc'[q)
	...s count = count+1
	...i count=1 d
	....w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	...e  d
	....w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	.else  d
	.i '$d(^SSU("SSGRP",phId,"HOSP",0,"Hosp")) d
	..s SAHospDesc=$P(^SSU("SSGRP",phId),"^",1) ///安全组
	..s activeFlag = $p(^SSU("SSGRP",phId),"^",151)
	..s stDate = $p(^SSU("SSGRP",phId),"^",153)
	..s endDate = $p(^SSU("SSGRP",phId),"^",154)
	..Q:(stDate>+$h)&(stDate'="")
	..Q:(endDate'="")&&(endDate<+$h) 
	..Q:(activeFlag'="")&&(activeFlag'="Y")  
	..s tmp=phId_"^"_SAHospDesc
	..q:(text'="")&(text'=SAHospDesc)
	..q:(q'="")&(SAHospDesc'[q)
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	w "]"
	
	q ""
	 
	 }elseif (type="L")
	 {
		s str=..ListLoc(text,q)	 
     }elseif(type="U")
     {
	    s str=..ListUser(text,q)	
	 }elseif(type="P")
	 {
		s str=..ListPrv(text,q)	 
	 }else
	 {
		s str=..ListDHC()
	 }
	
	 q ""
}

/// Creator：      Sunhuiyong
/// CreatDate：    2020-01-20
/// Description：  下拉列表显示
/// Table：        CT_Loc
/// Return
/// d ##class(web.DHCPrescCaseCollection).ListLoc("L","") 
ClassMethod ListLoc(text, q)
{
	 s HospDr = %session.Get("LOGON.HOSPID") ///不管前台给的，直接从session中获取
	 s q=$ZCONVERT(q,"U")
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "["
	 s count=0
	 s phId=0
     f  s phId=$o(^CTLOC(phId)) q:phId=""  d
	 .s Code=$P(^CTLOC(phId),"^",1)
	 .s LocDesc = $P(^CTLOC(phId),"^",2) ///科室
	 .s CTLOCHosDR=$P(^CTLOC(phId),"^",22)
	 .s ContactName=$p(^CTLOC(phId),"^",43)
	 .s dateFrom = $p(^CTLOC(phId),"^",24)
	 .s dateActiveTo = $p(^CTLOC(phId),"^",25)
	 .s activeFlag = $p(^CTLOC(phId),"^",14)
	 .Q:(dateFrom>+$h)&(dateFrom'="")
	 .Q:(dateActiveTo'="")&&(dateActiveTo<+$h) 
	 .Q:(activeFlag'="")&&(activeFlag'="Y")      
	 .i (CTLOCHosDR=HospDr)!(CTLOCHosDR="")  d
	 ..s tmp=phId_"^"_LocDesc
	 ..;q:(text'="")&(text'=Code)
	 ..;q:(q'="")&(Code'[q)
	 ..Q:(LocDesc'[q)&&($ZCONVERT(ContactName,"U")'[q)
 	 ..s count = count+1
	 ..i count=1 d
	 ...w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 ..e  d
	 ...w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 w "]"
	 q ""
}

/// Creator：      Sunhuiyong
/// CreatDate：    2020-01-20
/// Description：  下拉列表显示
/// Table：        SS_User
/// Return
/// d ##class(web.DHCPrescCaseCollection).ListUser() 人员
ClassMethod ListUser(text, q)
{
 	s HospDr = 2 ;%session.Get("LOGON.HOSPID") ///不管前台给的，直接从session中获取
	 w "["
	 s count=0
	 s phId=0
     f  s phId=$o(^SSU("SSUSR",phId)) q:phId=""  d
     .s Code=$P(^SSU("SSUSR",phId),"^",1)
     .s SSUSRHosDR=$P(^SSU("SSUSR",phId),"^",98)
     .s activeFlag = $p(^SSU("SSUSR",phId),"^",19)
     .s stDate = $p(^SSU("SSUSR",phId),"^",96)
     .s endDate = $p(^SSU("SSUSR",phId),"^",97)
     .Q:(stDate>+$h)&(stDate'="")
	 .Q:(endDate'="")&&(endDate<+$h) 
	 .Q:(activeFlag'="")&&(activeFlag'="Y")  
     .i (SSUSRHosDR=HospDr)!(SSUSRHosDR="")  d
	 ..s Codename=$P(^SSU("SSUSR",phId),"^",2)
	 ..s Code=Codename_" ("_Code_")"
	 ..s tmp=phId_"^"_Codename
	 ..q:(text'="")&(text'=Code)
	 ..q:(q'="")&(Code'[q)
	 ..s count = count+1
	 ..i count=1 d
	 ...w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 ..e  d
	 ...w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 w "]"
	 q ""
}

/// Creator：      Sunhuiyong
/// CreatDate：    2020-01-20
/// Description：  下拉列表显示
/// Table：        ListPrv
/// Return
/// d ##class(web.DHCPrescCaseCollection).ListPrv()
ClassMethod ListPrv(text, q)
{
 	w "["
	 s count=0
	 s phId=0
     f  s phId=$o(^CT("CPT",phId)) q:phId=""  d
     .s Code=$P(^CT("CPT",phId),"^",1)
     .s Name=$P(^CT("CPT",phId),"^",2)
	 .s tmp=phId_"^"_Name
	 .s count = count+1
	 .i count=1 d
	 ..w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 .e  d
	 ..w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	 w "]"
	 q ""
}

/// Creator：      Sunhuiyong
/// CreatDate：    2020-1-20
/// Description：  下拉列表显示
/// d ##class(web.DHCPrescCaseCollection).ListDHC()
ClassMethod ListDHC()
{
	s count=0
	w "["
	s hosprowid=""
	f  s hosprowid=$o(^CT("HOSP",hosprowid)) q:hosprowid=""  d
	.q:hosprowid=0
	.s hospdesc=$p(^CT("HOSP",hosprowid),"^",2) 
	.s tmp=hosprowid_"^"_hospdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Creator：      Sunhuiyong[修改sufan 2023-04-24]
/// CreatDate：    2022-3-31
/// Description：  案例收藏业务保存
/// w ##class(web.DHCPrescCaseCollection).InsertCase("102^59^P^231^18/05/2023^18/05/2023^20725^2","1638")
ClassMethod InsertCase(Params, AuditId)
{
	s Err=0
	s Res=0
	s ^temptest("AuditId") = $lb(Params, AuditId)
	ts

	//判断是否已被收藏，已收藏则更新数据，未收藏则收藏数据
	s themeId = $p(Params,"^",1) 
	s levelId = $p(Params,"^",2)
	s lgUserId = $p(Params,"^",7)  
	s lgHospId = $p(Params,"^",8)
	s collectId = "" 
	s collectId = ..CollectSave(themeId_"^"_levelId_"^"_lgUserId_"^"_lgHospId,AuditId)
	s:+collectId<=0 Err = collectId 
	i +collectId<=0 tro
	Q:Err<0 Err
	//PHA_PREADT.CaseCollectShare
	s CollectShareID=..SaveCollectShare(Params,collectId)
	s:CollectShareID<0 Err = CollectShareID 
	i CollectShareID<0 tro 
	Q:Err<0 Err
	
	//PHA_PREADT.CaseCollectShareItem
	s Err=..SaveCollectShareItem(Params,CollectShareID)
	i Err'=0 tro
	Q:Err'=0 Err

	TC
	
	Q Err
}

/// Creator：      Lidong  [修改sufan 2023-04-24]
/// CreatDate：    2022-4-11
/// Description：  案例收藏业务保存
/// w ##class(web.DHCPrescCaseCollection).CollectSave("53^56^18887^2","1371")
ClassMethod CollectSave(Params, AuditId)
{
	s Err = 0
	s themeId = $p(Params,"^",1) 	 //收藏主题
	s levelId = $p(Params,"^",2)   //收藏级别
	s lgUserId = $p(Params,"^",3)  //收藏人
	s hospId = $p(Params,"^",4)	 //医院
	s collectId = ""   ;$o(^PHA.PREADT.CaseCollectI("UserAudit",lgUserId,AuditId,""))
	ts
	i collectId'=""  d
	.s Err=..UpdateCollectItemTheme(collectId,themeId,hospId)
	.Q:Err'=0
	.s Err=..UpdateCollectItemLevel(collectId,levelId,hospId)
	.Q:Err'=0
	e  d
	.s collectId = ..SaveCollection(Params,AuditId)
	.s:collectId<0 Err = collectId
	.Q:Err<0
	.s Err=..SaveCollectItemTheme(collectId,themeId,hospId)
	.i Err<0 tro
	.Q:Err<0
	.s Err=..SaveCollectItemLevel(levelId,collectId,hospId)
	.i Err<0 tro
	.Q:Err<0
	i Err<0 tro
	Q:Err<0 Err

	TC
	
	Q +collectId
}

/// Creator：      Lidong[修改sufan 2023-04-24]
/// CreatDate：    2022-4-11
/// Description：  案例分享业务保存
/// w ##class(web.DHCPrescCaseCollection).ShareSave("D^2^24/04/2023^24/04/2023^18887","1371")
ClassMethod ShareSave(Params, AuditId)
{
	s Err=0
	s Res=0
	s lgUserId = $p(Params,"^",5)
	s collectId = $p(Params,"^",6)
	//判断主题是否已被收藏，只有收藏才能分享，否则提示先收藏
	;s collectId = $o(^PHA.PREADT.CaseCollectI("UserAudit",lgUserId,AuditId,""))
	Q:collectId="" "-7"
	ts
	
	s CollectShareID=..SaveCollectionShare(Params,collectId)
	s:CollectShareID<0 Err = CollectShareID
	i Err<0 tro
	Q:Err<0 "-5"
	//PHA_PREADT.CaseCollectShareItem
	s Err=..SaveCollectionShareItem(Params,CollectShareID)
	i Err'=0 tro
	Q:Err'=0 "-6"
	tc
	
	Q Err
}

/// Creator：      Sunhuiyong
/// CreatDate：    2022-3-31
/// Description：  主题是否存在，不存在则保存为新主题
/// w ##class(web.DHCPrescCaseCollection).CheckUpdateTheme("高危药品")
ClassMethod CheckUpdateTheme(Theme)
{
	s res=""
	i '$d(^PHA.PREADT.CaseCollect5C3BI("Desc"," "_Theme))  d
	.&SQL(INSERT INTO PHA_PREADT.CaseCollectPropValue VALUES('1','1',:Theme))
	s res=$o(^PHA.PREADT.CaseCollect5C3BI("Desc"," "_Theme,""))
	q res
}

/// Creator：      Sunhuiyong`
/// CreatDate：    2022-3-31
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).SaveCollect("特殊人群^1^D^2^2022-04-07^2022-04-07^10213","3251")
ClassMethod SaveCollect(Params, AuditId)
{
	s ModuleDr=1                 //智能审方
	s Collect="Y"                //收藏结果 Y  N
	s LgUserID=$p(Params,"^",7)  //收藏人
	s Date=+$h           //收藏日期
	s Time=$p($h,",",2)     //收藏时间
	&SQL(
		 INSERT INTO PHA_PREADT.CaseCollect (
			PCC_Module_Dr,PCC_Master_Dr,PCC_Collect,PCC_User,PCC_Date,PCC_Time
		) VALUES (
			:ModuleDr,:AuditId,:Collect,:LgUserID,:Date,:Time
		)
	)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator：      Sunhuiyong
/// CreatDate：    2022-3-31
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).SaveCollectItem("")
ClassMethod SaveCollectItemTheme(CollectID, ThemeID, hospId)
{
	s ThemeParID=$o(^CT.PHA.PREADT.DicTypeI("Code","COLLECT",hospId,""))
	&SQL(
		  insert into PHA_PREADT.CaseCollectItem (
			PCCI_Par_Dr,PCCI_Prop_Dr,PCCI_Value_Dr
		) values (
			:CollectID, :ThemeParID, :ThemeID
		)
	)
	Q SQLCODE
}

/// Creator：      Sunhuiyong
/// CreatDate：    2022-3-31
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).SaveCollectItem("")
ClassMethod SaveCollectItemLevel(LevelID, CollectID, hospId)
{
	s LevelParID=$o(^CT.PHA.PREADT.DicTypeI("Code","COLLECTLEV",hospId,""))      			 //级别DR
	&SQL(
		  insert into PHA_PREADT.CaseCollectItem (
			PCCI_Par_Dr,PCCI_Prop_Dr,PCCI_Value_Dr
		) values (
			:CollectID, :LevelParID, :LevelID
		)
	)
	Q SQLCODE
}

/// Creator：      Sunhuiyong
/// CreatDate：    2022-3-31
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).SaveCollectShare("特殊人群^1^D^2^2022-04-08^2022-04-08^10213","3283")
ClassMethod SaveCollectShare(Params, CollectID)
{
	s StartDate=##class(web.DHCPRESCCommonUtil).DateHtmlToLogical($p(Params,"^",5))  //开始日期
	s EndDate=##class(web.DHCPRESCCommonUtil).DateHtmlToLogical($p(Params,"^",6))    //结束日期
	
	&SQL(
		  insert into PHA_PREADT.CaseCollectShare (
			PCCS_Collect_Dr,PCCS_StDate,PCCS_EdDate
		) values (
			:CollectID, :StartDate, :EndDate
		)
	)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator：      Sunhuiyong
/// CreatDate：    2022-3-31
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).SaveCollectShareItem("")
ClassMethod SaveCollectShareItem(Params, CollectShareID)
{
	s ShreGrp=$p(Params,"^",3)     //分享组
	s ShareUit=$p(Params,"^",4)    //分享单位
	
	&SQL(
		  insert into PHA_PREADT.CaseCollectShareItem (
			PCCSI_Par_Dr,PCCSI_Type,PCCSI_Pointer
		) values (
			:CollectShareID, :ShreGrp, :ShareUit
		)
	)
	Q SQLCODE
}

/// Creator：      Lidong
/// CreatDate：    2022-4-11
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).SaveCollection("特殊人群^1^10213","3251")
ClassMethod SaveCollection(Params, AuditId)
{
	s ModuleDr=1                 //智能审方
	s Collect="Y"                //收藏结果 Y  N
	s LgUserID=$p(Params,"^",3)  //收藏人
	s Date=+$h           //收藏日期
	s Time=$p($h,",",2)     //收藏时间
	&SQL(
		 INSERT INTO PHA_PREADT.CaseCollect (
			PCC_Module_Dr,PCC_Master_Dr,PCC_Collect,PCC_User,PCC_Date,PCC_Time
		) VALUES (
			:ModuleDr,:AuditId,:Collect,:LgUserID,:Date,:Time
		)
	)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator：      Lidong
/// CreatDate：    2022-4-11
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).CheckCollect(3283)
ClassMethod CheckCollect(AuditId)
{
	s Status= ""
	&SQL(
		  select PCC_Collect  into :Status from PHA_PREADT.CaseCollect
		  where PCC_Master_Dr =  :AuditId
	)
	q Status
}

/// Creator：      Lidong
/// CreatDate：    2022-4-11
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).SaveCollectionShare("D^2^2022-04-08^2022-04-08^10213","3283")
ClassMethod SaveCollectionShare(Params, CollectID)
{
	
	s StartDate = ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical($p(Params,"^",3))	//开始日期
	s EndDate= ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical($p(Params,"^",4))      //结束日期
	&SQL(
		  insert into PHA_PREADT.CaseCollectShare (
			PCCS_Collect_Dr,PCCS_StDate,PCCS_EdDate
		) values (
			:CollectID, :StartDate, :EndDate
		)
	)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator：      Lidong
/// CreatDate：    2022-4-11
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).SaveCollectionShareItem("D^2^2022-04-08^2022-04-08^10213","3283")
ClassMethod SaveCollectionShareItem(Params, CollectShareID)
{
	s ShreGrp=$p(Params,"^",1)     //分享组
	s ShareUit=$p(Params,"^",2)    //分享单位
	
	&SQL(
		  insert into PHA_PREADT.CaseCollectShareItem (
			PCCSI_Par_Dr,PCCSI_Type,PCCSI_Pointer
		) values (
			:CollectShareID, :ShreGrp, :ShareUit
		)
	)
	Q SQLCODE
}

/// Creator：      Lidong
/// CreatDate：    2022-4-11
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).GetCollectID(3330)
ClassMethod GetCollectID(AuditId)
{
	s CollectID= ""
	&SQL(
		  select ID  into :CollectID from PHA_PREADT.CaseCollect
		  where PCC_Master_Dr =  :AuditId
	)
	q CollectID
}

/// Creator：      Sunhuiyong
/// CreatDate：    2022-3-31
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).QueryCollectShare("1638","20725")
ClassMethod QueryCollectShare(AuditId, LgUserID)
{
	w "["
	s count=0
	s ^temptest("Params") = $lb(AuditId, LgUserID)
	s ID="" f  s ID=$o(^PHA.PREADT.CaseCollectI("UserAudit",LgUserID,AuditId,ID)) q:ID=""  d
	.s User=$lg(^PHA.PREADT.CaseCollectD(ID),5)         //收藏人
	.s CollectDate=$lg(^PHA.PREADT.CaseCollectD(ID),6)  //收藏日期
	.s CollectDate=##class(web.DHCPRESCCommonUtil).DateLogicalToHtml(CollectDate)
	.s CollectTime=$lg(^PHA.PREADT.CaseCollectD(ID),7)  //收藏时间
	.s:CollectTime'="" CollectTime=$zt(CollectTime)
	.s AttributeTValue="",AttributeLValue=""
	.s CollectItemID="" 
	.f  s CollectItemID=$o(^PHA.PREADT.CaseCollectItemI("Collect",ID,CollectItemID)) q:CollectItemID=""  d
	..s CollectPropID=$lg(^PHA.PREADT.CaseCollectItemD(CollectItemID),3)	//PHA_PREADT.CaseCollectItem
	..s CollectPropValID=$lg(^PHA.PREADT.CaseCollectItemD(CollectItemID),4)  //属性指针 PHA_PREADT.CaseCollectItem
	..s Attribute = $lg(^CT.PHA.PREADT.DicTypeD(CollectPropID),2)
	..s AttributeValue=$lg(^CT.PHA.PREADT.DicItemD(CollectPropValID),3)     //属性值 PHA_PREADT.CaseCollectPropValue
	..s:Attribute="COLLECT" AttributeTValue=AttributeValue
	..s:Attribute="COLLECTLEV" AttributeLValue=AttributeValue
	..s CollectShareID=""
	.f  s CollectShareID=$o(^PHA.PREADT.CaseCollectShareI("Collect",ID,CollectShareID)) q:CollectShareID=""  d
	..s collectId = $lg(^PHA.PREADT.CaseCollectShareD(CollectShareID),2)
	..s Start=$lg(^PHA.PREADT.CaseCollectShareD(CollectShareID),3)   //开始日期
	..s StartDate=##class(web.DHCPRESCCommonUtil).DateLogicalToHtml(Start)
	..s End=$lg(^PHA.PREADT.CaseCollectShareD(CollectShareID),4)     //结束日期
	..s EndDate=##class(web.DHCPRESCCommonUtil).DateLogicalToHtml(End)
	..s CollectShareItemID=""
	..f  s CollectShareItemID=$o(^PHA.PREADT.CaseCollect58C1I("CaseCollectShare",CollectShareID,CollectShareItemID))  q:CollectShareItemID=""  d
	...s Type=$lg(^PHA.PREADT.CaseCollect58C1D(CollectShareItemID),3)       //类型 lidong
	...s:Type="D" Type="全院"
	...s:Type="L" Type="科室"
	...s:Type="G" Type="安全组"
	...s:Type="U" Type="人员"
	...s:Type="P" Type="职称"
	...s Pointer=$lg(^PHA.PREADT.CaseCollect58C1D(CollectShareItemID),4)    //指向ID  暂时先写ID,需要改为按类型加载描述 lidong
	...s:Type="全院" Pointer =$p(^CT("HOSP",Pointer),"^",2)
	...s:Type="科室" Pointer =$P(^CTLOC(Pointer),"^",2)
	...s:Type="安全组" Pointer =$P(^SSU("SSGRP",Pointer),"^",1)
	...s:Type="人员" Pointer =$P(^SSU("SSUSR",Pointer),"^",2)
	...s:Type="职称" Pointer =$P($g(^CT("CPT",Pointer)),"^",2)
	..s ListData=User_"^"_CollectDate_"^"_CollectTime_"^"_StartDate_"^"_EndDate_"^"_Type_"^"_Pointer_"^"_AttributeTValue_"^"_AttributeLValue
	..s ListTitle="User^CollectDate^CollectTime^StartDate^EndDate^Type^Pointer^AttributeTValue^AttributeLValue"
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	Q ""
}

/// Creator：      Lidong
/// CreatDate：    2022-4-12
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).UpdateCollectItemTheme("")
/// $lg(^PHA.PREADT.CaseCollect5C3BD(3334),3)
ClassMethod UpdateCollectItemTheme(CollectID, ThemeID, hospId)
{
	s ThemeParID=$o(^CT.PHA.PREADT.DicTypeI("Code","COLLECT",hospId,""))
	&SQL(
		  update PHA_PREADT.CaseCollectItem 
		  set PCCI_Value_Dr= :ThemeID
		  where PCCI_Par_Dr = :CollectID and PCCI_Prop_Dr=:ThemeParID
	)
	Q SQLCODE
}

/// Creator：      Lidong
/// CreatDate：    2022-4-12
/// Description：  
/// w ##class(web.DHCPrescCaseCollection).UpdateCollectItemLevel("")
ClassMethod UpdateCollectItemLevel(CollectID, LevelID, hospId)
{
	s LevelParID=$o(^CT.PHA.PREADT.DicTypeI("Code","COLLECTLEV",hospId,""))  			 //级别DR
	
	
	&SQL(
		  update PHA_PREADT.CaseCollectItem 
		  set PCCI_Value_Dr= :LevelID
		  where PCCI_Par_Dr = :CollectID and PCCI_Prop_Dr=:LevelParID
	)
	Q SQLCODE
}

}
