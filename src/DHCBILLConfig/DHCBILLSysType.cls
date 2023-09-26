Import SQLUSER

/// Creator: TangTao
/// CreateDate:	2013-01-13
/// Function: 门诊收费各分类的 添加、删除、修改
Class DHCBILLConfig.DHCBILLSysType Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCBILLConfig.DHCBILLSysType).Insert("d^d^测试1","TarNMrCate","1")
ClassMethod Insert(InsInfo, Flag, User)
{
	Kill PLIST
	Set TarCode=$p(InsInfo,"^",1)
	Set TarDesc=$p(InsInfo,"^",2)
	Set TarCateDr=$p(InsInfo,"^",3)
	Quit:((TarCode="")||(TarDesc="")) """"_"100数据不能为空"_""""
	
	Set rtn=0
	Set rtn=..CheckIsExists(TarCode, TarDesc, Flag)
	Quit:(+rtn'=0) rtn  ;判断添加、修改的项目代码和名称是否存在
	Set SQLCODE=0
	
	; TarCateDr不等于空，说明是维护子类，传进来的是desc
	; 之所以传desc进来有两个原因：
	; 1、单独修改某一行的时候，点击修改，当前行会可修改，如果大类所在列操作人员不去选，
	; 是获取不到对应ID的，这个时候如果这里不处理，保存不了ID
	; 2、选择了下拉框的内容以后，前台显示的还是textfield的值，不是valuefield的值。
	If (TarCateDr'="") Do
	.Set rtn=..CheckCateExists("", TarCateDr, Flag)
	.Set TarCateDr=$p(rtn,"^",2)
	Quit:(+rtn'=0) +rtn ;判断添加、修改的子类所属大类是否存在
	
	Set InsRowid=""
	;收费项目大类
	If Flag="TarCate" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.&sql(INSERT INTO DHC_TarCate VALUES PLIST())
	.Set InsRowid=%ROWID
	;收费项目子类
	If Flag="TarSubCate" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.Set PLIST(4)=TarCateDr
	.&sql(INSERT INTO DHC_TarSubCate VALUES PLIST())
	.Set InsRowid=%ROWID
	
	;住院费用大类
	If Flag="TarIC" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.&sql(INSERT INTO DHC_TarIC VALUES PLIST())
	.Set InsRowid=%ROWID
	;住院费用子类
	If Flag="TarInpatCate" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.Set PLIST(4)=TarCateDr
	.&sql(INSERT INTO DHC_TarInpatCate VALUES PLIST())
	.Set InsRowid=%ROWID

	;门诊费用大类
	If Flag="TarOC" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.&sql(INSERT INTO DHC_TarOC VALUES PLIST())
	.Set InsRowid=%ROWID
	;门诊费用子类
	If Flag="TarOutpatCate" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.Set PLIST(4)=TarCateDr
	.&sql(INSERT INTO DHC_TarOutpatCate VALUES PLIST())
	.Set InsRowid=%ROWID

	;项目核算大类
	If Flag="TarEC" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.&sql(INSERT INTO DHC_TarEC VALUES PLIST())
	.Set InsRowid=%ROWID
	;项目核算子类
	If Flag="TarEMCCate" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.Set PLIST(4)=TarCateDr
	.&sql(INSERT INTO DHC_TarEMCCate VALUES PLIST())
	.Set InsRowid=%ROWID

	;旧病历首页大类
	If Flag="TarMC" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.&sql(INSERT INTO DHC_TarMC VALUES PLIST())
	.Set InsRowid=%ROWID
	;旧病历首页子类
	If Flag="TarMRCate" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.Set PLIST(4)=TarCateDr
	.&sql(INSERT INTO DHC_TarMRCate VALUES PLIST())
	.Set InsRowid=%ROWID

	;会计大类
	If Flag="TarAC" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.&sql(INSERT INTO DHC_TarAC VALUES PLIST())
	.Set InsRowid=%ROWID
	;会计子类
	If Flag="TarAcctCate" Do
	.Set PLIST(2)=TarCode
	.Set PLIST(3)=TarDesc
	.Set PLIST(4)=TarCateDr
	.&sql(INSERT INTO DHC_TarAcctCate VALUES PLIST())
	.Set InsRowid=%ROWID

	;新病历首页大类
	If Flag="TarNMr" Do
	.Set RowID=$o(^DHCTarC("TMCNew",""),-1)
	.Set RowID=+$g(RowID)+1
	.Set ^DHCTarC("TMCNew",RowID)=TarCode_"^"_TarDesc
	.Set ^DHCTARMCNEW(0,"Code",TarCode,RowID)=""
	.Set ^DHCTARMCNEW(0,"Desc",TarDesc,RowID)=""
	.Set ^DHCTarC("TMCNew",0,"Code",TarCode,RowID)=""
	.Set ^DHCTarC("TMCNew",0,"Desc",TarDesc,RowID)=""
	.Set InsRowid=RowID

	;新病历首页子类
	If Flag="TarNMrCate" Do
	.Set RowID=$o(^DHCTarC("MCNew",""),-1)
	.Set RowID=+$g(RowID)+1
	.Set ^DHCTarC("MCNew",RowID)=TarCode_"^"_TarDesc_"^"_TarCateDr
	.Set ^DHCTARMRCATENEW(0,"Code",TarCode,RowID)=""
	.Set ^DHCTARMRCATENEW(0,"Desc",TarDesc,RowID)=""
	.Set ^DHCTarC("MCNew",0,"Code",TarCode,RowID)=""
	.Set ^DHCTarC("MCNew",0,"Desc",TarDesc,RowID)=""
	.Set ^DHCTarC("MCNew","0","TMCNew",RowID,TarCateDr)=""
	.Set InsRowid=RowID
	
	If (+SQLCODE=0) Do
	.//调用数据平台组接口留痕
	.Set Flag2="", UserTable="", TableDesc="", JsonStr="{}"
	.If Flag="TarCate" Do
	..Set Flag2="DHC_TarCate", UserTable="User.DHCTarCate", TableDesc="收费项目大类"
	..Set JsonStr="{TARCRowId:"_InsRowid_",TARCCode:"_TarCode_",TARCDesc:"_TarDesc_"}" 
	.If Flag="TarSubCate" Do
	..Set Flag2="DHC_TarSubCate",UserTable="User.DHCTarSubCate",TableDesc="收费项目子类"
	..Set JsonStr="{TARSCRowId:"_InsRowid_",TARSCCode:"_TarCode_",TARSCDesc:"_TarDesc_",TARSCTARCDR:"_TarCateDr_"}" 
	.If Flag="TarIC" Do
	..Set Flag2="DHC_TarIC",UserTable="User.DHCTarIC",TableDesc="住院费用大类"
	..Set JsonStr="{TARTICRowId:"_InsRowid_",TARTICCode:"_TarCode_",TARTICDesc:"_TarDesc_"}" 
	.If Flag="TarInpatCate" Do
	..Set Flag2="DHC_TarInpatCate",UserTable="User.DHCTarInpatCate",TableDesc="住院费用子类"
	..Set JsonStr="{TARICRowId:"_InsRowid_",TARICCode:"_TarCode_",TARICDesc:"_TarDesc_",TARICTARTICDR:"_TarCateDr_"}" 
	.If Flag="TarOC" Do
	..Set Flag2="DHC_TarOC",UserTable="User.DHCTarOC",TableDesc="门诊费用大类"
	..Set JsonStr="{TARTOCRowId:"_InsRowid_",TARTOCCode:"_TarCode_",TARTOCDesc:"_TarDesc_"}" 
	.If Flag="TarOutpatCate" Do
	..Set Flag2="DHC_TarOutpatCate",UserTable="User.DHCTarOutpatCate",TableDesc="门诊费用子类"
	..Set JsonStr="{TAROCRowId:"_InsRowid_",TAROCCode:"_TarCode_",TAROCDesc:"_TarDesc_",TAROCTARTOCDR:"_TarCateDr_"}" 
	.If Flag="TarEC" Do
	..Set Flag2="DHC_TarEC",UserTable="User.DHCTarEC",TableDesc="经济核算大类"
	..Set JsonStr="{TARTECRowId:"_InsRowid_",TARTECCode:"_TarCode_",TARTECDesc:"_TarDesc_"}" 
	.If Flag="TarEMCCate" Do
	..Set Flag2="DHC_TarEMCCate",UserTable="User.DHCTarEMCCate",TableDesc="经济核算子类"
	..Set JsonStr="{TARECRowId:"_InsRowid_",TARECCode:"_TarCode_",TARECDesc:"_TarDesc_",TARECTARTECDR:"_TarCateDr_"}" 
	.If Flag="TarMC" Do
	..Set Flag2="DHC_TarMC",UserTable="User.DHCTarMC",TableDesc="旧病案首页大类"
	..Set JsonStr="{TARTMCRowId:"_InsRowid_",TARTMCCode:"_TarCode_",TARTMCDesc:"_TarDesc_"}" 
	.If Flag="TarMRCate" Do
	..Set Flag2="DHC_TarMRCate",UserTable="User.DHCTarMRCate",TableDesc="旧病案首页子类"
	..Set JsonStr="{TARMCRowId:"_InsRowid_",TARMCCode:"_TarCode_",TARMCDesc:"_TarDesc_",TARMCTARTMCDR:"_TarCateDr_"}" 
	.If Flag="TarAC" Do
	..Set Flag2="DHC_TarAC",UserTable="User.DHCTarAC",TableDesc="会计费用大类"
	..Set JsonStr="{TARTACRowId:"_InsRowid_",TARTACCode:"_TarCode_",TARTACDesc:"_TarDesc_"}" 
	.If Flag="TarAcctCate" Do
	..Set Flag2="DHC_TarAcctCate",UserTable="User.DHCTarAcctCate",TableDesc="会计费用子类"
	..Set JsonStr="{TARACRowId:"_InsRowid_",TARACCode:"_TarCode_",TARACDesc:"_TarDesc_",TARACTARTACDR:"_TarCateDr_"}" 
	.If Flag="TarNMr" Do
	..Set Flag2="^DHCTarC(""TMCNew"")",UserTable="^DHCTarC(""TMCNew"")",TableDesc="新病案首页大类"
	..Set JsonStr="{TARTNMCRowId:"_InsRowid_",TARTNMCCode:"_TarCode_",TARTNMCDesc:"_TarDesc_"}" 
	.If Flag="TarNMrCate" Do
	..Set Flag2="^DHCTarC(""MCNew"")",UserTable="^DHCTarC(""MCNew"")",TableDesc="新病案首页子类"
	..Set JsonStr="{TARNMCRowId:"_InsRowid_",TARNMCCode:"_TarCode_",TARNMCDesc:"_TarDesc_",TARNMCTARTMCDR:"_TarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).Update("67^dddd^ddd^dd^床位费","TarSubCate",1)
ClassMethod Update(UpdInfo, Flag, User)
{
	Set rtn=0
	
	; TarCateDr不等于空，说明是维护子类，传进来的是desc
	; 之所以传desc进来有两个原因：
	; 1、单独修改某一行的时候，点击修改，当前行会可修改，如果大类所在列操作人员不去选，
	; 是获取不到对应ID的，这个时候如果这里不处理，保存不了ID
	; 2、选择了下拉框的内容以后，前台显示的还是textfield的值，不是valuefield的值。
	Set TarCateDr=$p(UpdInfo,"^",4)
	If TarCateDr'="" Do
	.Set rtn=..CheckCateExists("", TarCateDr, Flag)
	.Set $p(UpdInfo,"^",4)=$p(rtn,"^",2)
	Quit:(+rtn'=0) +rtn ;判断添加、修改的子类所属大类是否存在

	If Flag="TarCate" Do
	.Set rtn=..UpdateTarCate(UpdInfo,Flag,User)
	If Flag="TarSubCate" Do
	.Set rtn=..UpdateTarSubCate(UpdInfo,Flag,User)
	If Flag="TarIC" Do
	.Set rtn=..UpdateTarIC(UpdInfo,Flag,User)
	If Flag="TarInpatCate" Do
	.Set rtn=..UpdateTarInpatCate(UpdInfo,Flag,User)
	If Flag="TarOC" Do
	.Set rtn=..UpdateTarOC(UpdInfo,Flag,User)
	If Flag="TarOutpatCate" Do
	.Set rtn=..UpdateTarOutpatCate(UpdInfo,Flag,User)
	If Flag="TarEC" Do
	.Set rtn=..UpdateTarEC(UpdInfo,Flag,User)
	If Flag="TarEMCCate" Do
	.Set rtn=..UpdateTarEMCCate(UpdInfo,Flag,User)
	If Flag="TarMC" Do
	.Set rtn=..UpdateTarMC(UpdInfo,Flag,User)
	If Flag="TarMRCate" Do
	.Set rtn=..UpdateTarMRCate(UpdInfo,Flag,User)
	If Flag="TarAC" Do
	.Set rtn=..UpdateTarAC(UpdInfo,Flag,User)
	If Flag="TarAcctCate" Do
	.Set rtn=..UpdateTarAcctCate(UpdInfo,Flag,User)
	If Flag="TarNMr" Do
	.Set rtn=..UpdateTarNMr(UpdInfo,Flag,User)
	If Flag="TarNMrCate" Do
	.Set rtn=..UpdateTarNMrCate(UpdInfo,Flag,User)

	Quit rtn
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarCate("18^11^婴儿费","TarCate","1")
ClassMethod UpdateTarCate(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("CC",0,"Code",TarCode,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1001"
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("CC",0,"Desc",TarDesc,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarCate WHERE TARC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	&sql(UPDATE DHC_TarCate VALUES :PLIST() WHERE TARC_RowId=:TarRowid)
	If (SQLCODE=0) Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarCate",UserTable="User.DHCTarCate",TableDesc="收费项目大类",InsRowid=TarRowid
	.Set JsonStr="{TARCRowId:"_InsRowid_",TARCCode:"_TarCode_",TARCDesc:"_TarDesc_"}" 
	.Set JsonStrOld="{TARCRowId:"_InsRowid_",TARCCode:"_OldTarCode_",TARCDesc:"_OldTarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarSubCate("18^11^婴儿费","1")
ClassMethod UpdateTarSubCate(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	Set TarCateDr=$p(UpdInfo,"^",4)
	
	Set rowid1="", flag=0   ;修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("SC",0,"Code",TarCode,rowid1)) Quit:(rowid1="")  Do
	.Quit:(TarRowid=rowid1)
	.Set flag=$i(flag)
	Quit:(flag'=0) "-1001"
	
	Set rowid1="", flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("SC",0,"Desc",TarDesc,rowid1)) Quit:(rowid1="")  Do
	.Quit:(TarRowid=rowid1)
	.Set flag=$i(flag)
	Quit:flag'=0 "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarSubCate WHERE TARSC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	Set OldTarCateDr=PLIST(4)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	Set PLIST(4)=TarCateDr
	&sql(UPDATE DHC_TarSubCate VALUES :PLIST() WHERE TARSC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarSubCate",UserTable="User.DHCTarSubCate",TableDesc="收费项目子类",InsRowid=TarRowid
	.Set JsonStr="{TARSCRowId:"_InsRowid_",TARSCCode:"_TarCode_",TARSCDesc:"_TarDesc_",TARSCTARCDR:"_TarCateDr_"}" 
	.Set JsonStrOld="{TARSCRowId:"_InsRowid_",TARSCCode:"_OldTarCode_",TARSCDesc:"_OldTarDesc_",TARSCTARCDR:"_OldTarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarIC("18^11^婴儿费","1")
ClassMethod UpdateTarIC(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	
	Set rowid1="", flag=0   ;修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("TIC",0,"Code",TarCode,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=$i(flag)
	Quit:(flag'=0) "-1001"
	
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("TIC",0,"Desc",TarDesc,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=$i(flag)
	Quit:(flag'=0) "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarIC WHERE TARTIC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	&sql(UPDATE DHC_TarIC VALUES :PLIST() WHERE TARTIC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.//调用数据平台组接口留痕
	.Set Flag2="DHC_TarIC",UserTable="User.DHCTarIC",TableDesc="住院费用大类",InsRowid=TarRowid
	.Set JsonStr="{TARTICRowId:"_InsRowid_",TARTICCode:"_TarCode_",TARTICDesc:"_TarDesc_"}" 
	.Set JsonStrOld="{TARTICRowId:"_InsRowid_",TARTICCode:"_OldTarCode_",TARTICDesc:"_OldTarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarInpatCate("18^11^婴儿费","1")
ClassMethod UpdateTarInpatCate(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	Set TarCateDr=$p(UpdInfo,"^",4)
	
	Set rowid1="", flag=0   //修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("IC",0,"Code",TarCode,rowid1)) Quit:(rowid1="")  Do
	.Quit:TarRowid=rowid1
	.Set flag=$i(flag)
	Quit:(flag'=0) "-1001"
	
	Set rowid1="", flag=0   //修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("IC",0,"Desc",TarDesc,rowid1)) Quit:(rowid1="")  Do
	.Quit:TarRowid=rowid1
	.Set flag=$i(flag)
	Quit:(flag'=0) "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarInpatCate WHERE TARIC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	Set OldTarCateDr=PLIST(4)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	Set PLIST(4)=TarCateDr
	&sql(UPDATE DHC_TarInpatCate VALUES :PLIST() WHERE TARIC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarInpatCate",UserTable="User.DHCTarInpatCate",TableDesc="住院费用子类",InsRowid=TarRowid
	.Set JsonStr="{TARICRowId:"_InsRowid_",TARICCode:"_TarCode_",TARICDesc:"_TarDesc_",TARICTARTICDR:"_TarCateDr_"}" 
	.Set JsonStrOld="{TARICRowId:"_InsRowid_",TARICCode:"_OldTarCode_",TARICDesc:"_OldTarDesc_",TARICTARTICDR:"_OldTarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarOC("18^11^婴儿费","1")
ClassMethod UpdateTarOC(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	
	Set rowid1="", flag=0   //修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("TOC",0,"Code",TarCode,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=$i(flag)
	Quit:(flag'=0) "-1001"
	
	Set rowid1="", flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("TOC",0,"Desc",TarDesc,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=$i(flag)
	Quit:(flag'=0) "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarOC WHERE TARTOC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	&sql(UPDATE DHC_TarOC VALUES :PLIST() WHERE TARTOC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarOC",UserTable="User.DHCTarOC",TableDesc="门诊费用大类",InsRowid=TarRowid
	.Set JsonStr="{TARTOCRowId:"_InsRowid_",TARTOCCode:"_TarCode_",TARTOCDesc:"_TarDesc_"}" 
	.Set JsonStrOld="{TARTOCRowId:"_InsRowid_",TARTOCCode:"_OldTarCode_",TARTOCDesc:"_OldTarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarOutpatCate("18^11^婴儿费","1")
ClassMethod UpdateTarOutpatCate(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	Set TarCateDr=$p(UpdInfo,"^",4)
	
	Set rowid1="", flag=0   ;修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("OC",0,"Code",TarCode,rowid1)) Quit:(rowid1="")  Do
	.Quit:TarRowid=rowid1
	.Set flag=$i(flag)
	Quit:flag'=0 "-1001"
	Set rowid1="", flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("OC",0,"Desc",TarDesc,rowid1)) Quit:(rowid1="")  Do
	.Quit:TarRowid=rowid1
	.Set flag=$i(flag)
	Quit:flag'=0 "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarOutpatCate WHERE TAROC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	Set OldTarCateDr=PLIST(4)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	Set PLIST(4)=TarCateDr
	&sql(UPDATE DHC_TarOutpatCate VALUES :PLIST() WHERE TAROC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarOutpatCate",UserTable="User.DHCTarOutpatCate",TableDesc="门诊费用子类",InsRowid=TarRowid
	.Set JsonStr="{TAROCRowId:"_InsRowid_",TAROCCode:"_TarCode_",TAROCDesc:"_TarDesc_",TAROCTARTOCDR:"_TarCateDr_"}" 
	.Set JsonStrOld="{TAROCRowId:"_InsRowid_",TAROCCode:"_OldTarCode_",TAROCDesc:"_OldTarDesc_",TAROCTARTOCDR:"_OldTarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarEC("37^11111111^11111","TarEC","1")
ClassMethod UpdateTarEC(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	
	Set rowid1="", flag=0   ;修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("TEC",0,"Code",TarCode,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=$i(flag)
	Quit:(flag'=0) "-1001"
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("TEC",0,"Desc",TarDesc,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=$i(flag)
	Quit:flag'=0 "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarEC WHERE TARTEC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	&sql(UPDATE DHC_TarEC VALUES :PLIST() WHERE TARTEC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarEC",UserTable="User.DHCTarEC",TableDesc="经济核算大类",InsRowid=TarRowid
	.Set JsonStr="{TARTECRowId:"_InsRowid_",TARTECCode:"_TarCode_",TARTECDesc:"_TarDesc_"}" 
	.Set JsonStrOld="{TARTECRowId:"_InsRowid_",TARTECCode:"_OldTarCode_",TARTECDesc:"_OldTarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarEMCCate("18^11^婴儿费","1")
ClassMethod UpdateTarEMCCate(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	Set TarCateDr=$p(UpdInfo,"^",4)
	
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("EC",0,"Code",TarCode,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1001"
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("EC",0,"Desc",TarDesc,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarEMCCate WHERE TAREC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	Set OldTarCateDr=PLIST(4)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	Set PLIST(4)=TarCateDr
	&sql(UPDATE DHC_TarEMCCate VALUES :PLIST() WHERE TAREC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarEMCCate",UserTable="User.DHCTarEMCCate",TableDesc="经济核算子类",InsRowid=TarRowid
	.Set JsonStr="{TARECRowId:"_InsRowid_",TARECCode:"_TarCode_",TARECDesc:"_TarDesc_",TARECTARTECDR:"_TarCateDr_"}" 
	.Set JsonStrOld="{TARECRowId:"_InsRowid_",TARECCode:"_OldTarCode_",TARECDesc:"_OldTarDesc_",TARECTARTECDR:"_OldTarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarMC("37^11111111^11111","TarMC","1")
ClassMethod UpdateTarMC(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("TMC",0,"Code",TarCode,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1001"
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("TMC",0,"Desc",TarDesc,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarMC WHERE TARTMC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	&sql(UPDATE DHC_TarMC VALUES :PLIST() WHERE TARTMC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarMC",UserTable="User.DHCTarMC",TableDesc="旧病案首页大类",InsRowid=TarRowid
	.Set JsonStr="{TARTMCRowId:"_InsRowid_",TARTMCCode:"_TarCode_",TARTMCDesc:"_TarDesc_"}" 
	.Set JsonStrOld="{TARTMCRowId:"_InsRowid_",TARTMCCode:"_OldTarCode_",TARTMCDesc:"_OldTarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarMRCate("18^11^婴儿费","1")
ClassMethod UpdateTarMRCate(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	Set TarCateDr=$p(UpdInfo,"^",4)
	
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("MC",0,"Code",TarCode,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1001"
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("MC",0,"Desc",TarDesc,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarMRCate WHERE TARMC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	Set OldTarCateDr=PLIST(4)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	Set PLIST(4)=TarCateDr
	&sql(UPDATE DHC_TarMRCate VALUES :PLIST() WHERE TARMC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarMRCate",UserTable="User.DHCTarMRCate",TableDesc="旧病案首页子类",InsRowid=TarRowid
	.Set JsonStr="{TARMCRowId:"_InsRowid_",TARMCCode:"_TarCode_",TARMCDesc:"_TarDesc_",TARMCTARTMCDR:"_TarCateDr_"}" 
	.Set JsonStrOld="{TARMCRowId:"_InsRowid_",TARMCCode:"_OldTarCode_",TARMCDesc:"_OldTarDesc_",TARMCTARTMCDR:"_OldTarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarAC("37^11111111^11111","TarMC","1")
ClassMethod UpdateTarAC(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("TAC",0,"Code",TarCode,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1001"
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("TAC",0,"Desc",TarDesc,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarAC WHERE TARTAC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	&sql(UPDATE DHC_TarAC VALUES :PLIST() WHERE TARTAC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarAC",UserTable="User.DHCTarAC",TableDesc="会计费用大类",InsRowid=TarRowid
	.Set JsonStr="{TARTACRowId:"_InsRowid_",TARTACCode:"_TarCode_",TARTACDesc:"_TarDesc_"}" 
	.Set JsonStrOld="{TARTACRowId:"_InsRowid_",TARTACCode:"_OldTarCode_",TARTACDesc:"_OldTarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).TarAcctCate("18^11^婴儿费","1")
ClassMethod UpdateTarAcctCate(UpdInfo, Flag, User)
{
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	Set TarCateDr=$p(UpdInfo,"^",4)
	
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目代码,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("AC",0,"Code",TarCode,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1001"
	Set rowid1="",flag=0   ;修改时判断除了本ID意外是否有重复的项目名称,不能使用CheckIsExists方法,这里是判断全部,只适用于插入的时候判断
	For  Set rowid1=$o(^DHCTarC("AC",0,"Desc",TarDesc,rowid1)) Quit:rowid1=""  Do
	.Quit:TarRowid=rowid1
	.Set flag=flag+1
	Quit:flag'=0 "-1002"
	
	Kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarAcctCate WHERE TARAC_RowId=:TarRowid) 	
	Quit:SQLCODE'=0 SQLCODE
	Set OldTarCode=PLIST(2)
	Set OldTarDesc=PLIST(3)
	Set OldTarCateDr=PLIST(4)
	
	Kill PLIST
	Set PLIST(2)=TarCode
	Set PLIST(3)=TarDesc
	Set PLIST(4)=TarCateDr
	&sql(UPDATE DHC_TarAcctCate VALUES :PLIST() WHERE TARAC_RowId=:TarRowid)
	If SQLCODE=0 Do
	.; 调用数据平台组接口留痕
	.Set Flag2="DHC_TarAcctCate",UserTable="User.DHCTarAcctCate",TableDesc="会计费用子类",InsRowid=TarRowid
	.Set JsonStr="{TARACRowId:"_InsRowid_",TARACCode:"_TarCode_",TARACDesc:"_TarDesc_",TARACTARTACDR:"_TarCateDr_"}" 
	.Set JsonStrOld="{TARACRowId:"_InsRowid_",TARACCode:"_OldTarCode_",TARACDesc:"_OldTarDesc_",TARACTARTACDR:"_OldTarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarNMr("37^11111111^11111","TarMC","1")
ClassMethod UpdateTarNMr(UpdInfo, Flag, User)
{
	Set $ZT="UpdateTarNMrET"
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	
	Set rowid1="",flag1=0,flag2=0
	For  Set rowid1=$o(^DHCTarC("TMCNew",rowid1)) q:rowid1=""  d
	.Set Code=$p(^DHCTarC("TMCNew",rowid1),"^",1)
	.Set Desc=$p(^DHCTarC("TMCNew",rowid1),"^",2)
	.Quit:TarRowid=rowid1
	.If Code=TarCode Set flag1=1
	.If Desc=TarDesc Set flag2=1
	Quit:flag1'=0 "-1001"
	Quit:flag2'=0 "-1002"
	
	Set OldTarCode=$p(^DHCTarC("TMCNew",TarRowid),"^",1)
	Set OldTarDesc=$p(^DHCTarC("TMCNew",TarRowid),"^",2)
	Set ^DHCTarC("TMCNew",TarRowid)=TarCode_"^"_TarDesc
	
	;调用数据平台组接口留痕
	Set Flag2="^DHCTarC(""TMCNew"")",UserTable="^DHCTarC(""TMCNew"")",TableDesc="新病案首页大类",InsRowid=TarRowid
	Set JsonStr="{TARTNMCRowId:"_InsRowid_",TARTNMCCode:"_TarCode_",TARTNMCDesc:"_TarDesc_"}" 
	Set JsonStrOld="{TARTNMCRowId:"_InsRowid_",TARTNMCCode:"_OldTarCode_",TARTNMCDesc:"_OldTarDesc_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)
	
	Quit 0
UpdateTarNMrET
	Quit $ZERROR
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarNMrCate("18^11^婴儿费","1")
ClassMethod UpdateTarNMrCate(UpdInfo, Flag, User)
{
	Set $ZT="UpdateTarNMrCateET"
	Set TarRowid=$p(UpdInfo,"^",1)
	Set TarCode=$p(UpdInfo,"^",2)
	Set TarDesc=$p(UpdInfo,"^",3)
	Set TarCateDr=$p(UpdInfo,"^",4)
	
	Set rowid1="",flag1=0,flag2=0
	For  Set rowid1=$o(^DHCTarC("MCNew",rowid1)) q:rowid1=""  d
	.Set Code=$p(^DHCTarC("MCNew",rowid1),"^",1)
	.Set Desc=$p(^DHCTarC("MCNew",rowid1),"^",2)
	.Set MrNewDr=$p(^DHCTarC("MCNew",rowid1),"^",3)
	.Quit:TarRowid=rowid1
	.If Code=TarCode Set flag1=1
	.If Desc=TarDesc Set flag2=1
	Quit:flag1'=0 "-1001"
	Quit:flag2'=0 "-1002"
		
	Set OldTarCode=$p(^DHCTarC("MCNew",TarRowid),"^",1)
	Set OldTarDesc=$p(^DHCTarC("MCNew",TarRowid),"^",1)
	Set OldTarCateDr=$p(^DHCTarC("MCNew",TarRowid),"^",1)
	Set ^DHCTarC("MCNew",TarRowid)=TarCode_"^"_TarDesc_"^"_TarCateDr

	;调用数据平台组接口留痕
	Set Flag2="^DHCTarC(""MCNew"")",UserTable="^DHCTarC(""MCNew"")",TableDesc="新病案首页子类",InsRowid=TarRowid
	Set JsonStr="{TARNMCRowId:"_InsRowid_",TARNMCCode:"_TarCode_",TARNMCDesc:"_TarDesc_",TARNMCTARTMCDR:"_TarCateDr_"}" 
	Set JsonStrOld="{TARNMCRowId:"_InsRowid_",TARNMCCode:"_OldTarCode_",TARNMCDesc:"_OldTarDesc_",TARNMCTARTMCDR:"_OldTarCateDr_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)
	
	Quit 0
UpdateTarNMrCateET
	Quit $ZERROR
}

ClassMethod Delete(DeleteInfo, Flag, User)
{
	Set rtn=0
	If Flag="TarCate" d
	.Set rtn=..DeleteTarCate(DeleteInfo,Flag,User)
	If Flag="TarSubCate" d
	.Set rtn=..DeleteTarSubCate(DeleteInfo,Flag,User)
	If Flag="TarIC" d
	.Set rtn=..DeleteTarIC(DeleteInfo,Flag,User)
	If Flag="TarInpatCate" Do
	.Set rtn=..DeleteTarInpatCate(DeleteInfo,Flag,User)
	If Flag="TarOC" d
	.Set rtn=..DeleteTarOC(DeleteInfo,Flag,User)
	If Flag="TarOutpatCate" Do
	.Set rtn=..DeleteTarOutpatCate(DeleteInfo,Flag,User)
	If Flag="TarEC" d
	.Set rtn=..DeleteTarEC(DeleteInfo,Flag,User)
	If Flag="TarEMCCate" Do
	.Set rtn=..DeleteTarEMCCate(DeleteInfo,Flag,User)
	If Flag="TarMC" d
	.Set rtn=..DeleteTarMC(DeleteInfo,Flag,User)
	If Flag="TarMRCate" Do
	.Set rtn=..DeleteTarMRCate(DeleteInfo,Flag,User)
	If Flag="TarAC" d
	.Set rtn=..DeleteTarAC(DeleteInfo,Flag,User)
	If Flag="TarAcctCate" Do
	.Set rtn=..DeleteTarAcctCate(DeleteInfo,Flag,User)
	If Flag="TarNMr" d
	.Set rtn=..DeleteTarNMr(DeleteInfo,Flag,User)
	If Flag="TarNMrCate" Do
	.Set rtn=..DeleteTarNMrCate(DeleteInfo,Flag,User)
	Quit rtn
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarCate("39^32^测试费2","1")
ClassMethod DeleteTarCate(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("CC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("CC",RowID),"^",2)
	;^DHCTarC("SC",0,"TCC",{TARSC_TARC_DR},{TARSC_RowId})
	Quit:$d(^DHCTarC("SC",0,"TCC",RowID)) "-1001"	
	
	&sql(DELETE FROM DHC_TarCate WHERE TARC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarCate",UserTable="User.DHCTarCate",TableDesc="收费项目大类"
	.Set JsonStr="{TARCRowId:"_RowID_",TARCCode:"_TarCode_",TARCDesc:"_TarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarSubCate("39^32^测试费2","1")
ClassMethod DeleteTarSubCate(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("SC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("SC",RowID),"^",2)
	Set TarCateDr=$p(^DHCTarC("SC",RowID),"^",3)
	
	;^DHCTARI(0,"SC",{TARI_SubCate},{TARI_RowId})
	Quit:$d(^DHCTARI(0,"SC",RowID)) "-1001"	
	
	
	&sql(DELETE FROM DHC_TarSubCate WHERE TARSC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarSubCate",UserTable="User.DHCTarSubCate",TableDesc="收费项目子类"
	.Set JsonStr="{TARSCRowId:"_RowID_",TARSCCode:"_TarCode_",TARSCDesc:"_TarDesc_",TARSCTARCDR:"_TarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarIC("39^32^测试费2","1")
ClassMethod DeleteTarIC(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("TIC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("TIC",RowID),"^",2)
	
	Quit:$d(^DHCTarC("IC",0,"TIC",RowID)) "-1001"	
	
	&sql(DELETE FROM DHC_TarIC WHERE TARTIC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarIC",UserTable="User.DHCTarIC",TableDesc="住院费用大类"
	.Set JsonStr="{TARTICRowId:"_RowID_",TARTICCode:"_TarCode_",TARTICDesc:"_TarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType)DeleteTarInpatCate("39^32^测试费2","1")
ClassMethod DeleteTarInpatCate(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("IC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("IC",RowID),"^",2)
	Set TarCateDr=$p(^DHCTarC("IC",RowID),"^",3)
	
	Quit:$d(^DHCTARI(0,"IC",RowID)) "-1001"	
	
	&sql(DELETE FROM DHC_TarInpatCate WHERE TARIC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarInpatCate",UserTable="User.DHCTarInpatCate",TableDesc="住院费用子类"
	.Set JsonStr="{TARICRowId:"_RowID_",TARICCode:"_TarCode_",TARICDesc:"_TarDesc_",TARICTARTICDR:"_TarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarOC("39^32^测试费2","1")
ClassMethod DeleteTarOC(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("TOC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("TOC",RowID),"^",2)
	Quit:$d(^DHCTarC("OC",0,"TOC",RowID)) "-1001"
	&sql(DELETE FROM DHC_TarOC WHERE TARTOC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarOC",UserTable="User.DHCTarOC",TableDesc="门诊费用大类"
	.Set JsonStr="{TARTOCRowId:"_RowID_",TARTOCCode:"_TarCode_",TARTOCDesc:"_TarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarOutpatCate("39^32^测试费2","1")
ClassMethod DeleteTarOutpatCate(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("OC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("OC",RowID),"^",2)
	Set TarCateDr=$p(^DHCTarC("OC",RowID),"^",3)
	
	Quit:$d(^DHCTARI(0,"OC",RowID)) "-1001"	
	
	&sql(DELETE FROM DHC_TarOutpatCate WHERE TAROC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarOutpatCate",UserTable="User.DHCTarOutpatCate",TableDesc="门诊费用子类"
	.Set JsonStr="{TAROCRowId:"_RowID_",TAROCCode:"_TarCode_",TAROCDesc:"_TarDesc_",TAROCTARTOCDR:"_TarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarEC("39^32^测试费2","1")
ClassMethod DeleteTarEC(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("TEC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("TEC",RowID),"^",2)
	Quit:$d(^DHCTarC("EC",0,"TEC",RowID)) "-1001"
	&sql(DELETE FROM DHC_TarEC WHERE TARTEC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarEC",UserTable="User.DHCTarEC",TableDesc="经济核算大类"
	.Set JsonStr="{TARTECRowId:"_RowID_",TARTECCode:"_TarCode_",TARTECDesc:"_TarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)
	
	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarEMCCate("39^32^测试费2","1")
ClassMethod DeleteTarEMCCate(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("EC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("EC",RowID),"^",2)
	Set TarCateDr=$p(^DHCTarC("EC",RowID),"^",3)
	
	Quit:$d(^DHCTARI(0,"EC",RowID)) "-1001"	
	
	&sql(DELETE FROM DHC_TarEMCCate WHERE TAREC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarEMCCate",UserTable="User.DHCTarEMCCate",TableDesc="经济核算子类"
	.Set JsonStr="{TARECRowId:"_RowID_",TARECCode:"_TarCode_",TARECDesc:"_TarDesc_",TARECTARTECDR:"_TarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarMC("39^32^测试费2","1")
ClassMethod DeleteTarMC(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("TMC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("TMC",RowID),"^",2)
	
	Quit:$d(^DHCTarC("MC",0,"TMC",RowID)) "-1001"
	
	&sql(DELETE FROM DHC_TarMC WHERE TARTMC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarMC",UserTable="User.DHCTarMC",TableDesc="旧病案首页大类"
	.Set JsonStr="{TARTMCRowId:"_RowID_",TARTMCCode:"_TarCode_",TARTMCDesc:"_TarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarMRCate("39^32^测试费2","1")
ClassMethod DeleteTarMRCate(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("MC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("MC",RowID),"^",2)
	Set TarCateDr=$p(^DHCTarC("MC",RowID),"^",3)
	
	Quit:$d(^DHCTARI(0,"MR",RowID)) "-1001"	
	
	&sql(DELETE FROM DHC_TarMRCate WHERE TARMC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarMRCate",UserTable="User.DHCTarMRCate",TableDesc="旧病案首页子类"
	.Set JsonStr="{TARMCRowId:"_RowID_",TARMCCode:"_TarCode_",TARMCDesc:"_TarDesc_",TARMCTARTMCDR:"_TarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarAC("39^32^测试费2","1")
ClassMethod DeleteTarAC(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("TAC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("TAC",RowID),"^",2)
	Quit:$d(^DHCTarC("AC",0,"TAC",RowID)) "-1001"
	&sql(DELETE FROM DHC_TarAC WHERE TARTAC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarAC",UserTable="User.DHCTarAC",TableDesc="会计费用大类"
	.Set JsonStr="{TARTACRowId:"_RowID_",TARTACCode:"_TarCode_",TARTACDesc:"_TarDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarAcctCate("39^32^测试费2","1")
ClassMethod DeleteTarAcctCate(DeleteInfo, Flag, User)
{
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("AC",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("AC",RowID),"^",2)
	Set TarCateDr=$p(^DHCTarC("AC",RowID),"^",3)
	
	Quit:$d(^DHCTARI(0,"AC",RowID)) "-1001"	
	
	&sql(DELETE FROM DHC_TarAcctCate WHERE TARAC_RowId=:RowID)
	If SQLCODE=0 Do
	.Set Flag2="DHC_TarAcctCate",UserTable="User.DHCTarAcctCate",TableDesc="会计费用子类"
	.Set JsonStr="{TARACRowId:"_RowID_",TARACCode:"_TarCode_",TARACDesc:"_TarDesc_",TARACTARTACDR:"_TarCateDr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)

	Quit SQLCODE
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarMC("39^32^测试费2","1")
ClassMethod DeleteTarNMr(DeleteInfo, Flag, User)
{
	Set $ZT="DeleteTarNMrET"
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("TMCNew",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("TMCNew",RowID),"^",2)
	Quit:$d(^DHCTarC("MCNew",0,"TMCNew",RowID)) "-1001"
	
	Kill ^DHCTarC("TMCNew",RowID)
	Set Flag2="^DHCTarC(""TMCNew"")",UserTable="^DHCTarC(""TMCNew"")",TableDesc="新病案首页大类"
	Set JsonStr="{TARTNMCRowId:"_RowID_",TARTNMCCode:"_TarCode_",TARTNMCDesc:"_TarDesc_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,RowID ,"删除","D",JsonStr)

	Quit 0
DeleteTarNMrET
	Quit $ZERROR
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).DeleteTarNMrCate("39^32^测试费2","1")
ClassMethod DeleteTarNMrCate(DeleteInfo, Flag, User)
{
	Set $ZT="DeleteTarNMrCateET"
	Set RowID=$p(DeleteInfo,"^",1)
	Set TarCode=$p(^DHCTarC("MCNew",RowID),"^",1)
	Set TarDesc=$p(^DHCTarC("MCNew",RowID),"^",2)
	Set TarCateDr=$p(^DHCTarC("MCNew",RowID),"^",3)
	
	Quit:$d(^DHCTARI(0,"MCNew",RowID)) "-1001"	
	
	Kill ^DHCTarC("MCNew",RowID)
	Set Flag2="^DHCTarC(""MCNew"")",UserTable="^DHCTarC(""MCNew"")",TableDesc="新病案首页子类"
	Set JsonStr="{TARNMCRowId:"_RowID_",TARNMCCode:"_TarCode_",TARNMCDesc:"_TarDesc_",TARNMCTARTMCDR:"_TarCateDr_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc ,RowID, "删除", "D", JsonStr)

	Quit 0
DeleteTarNMrCateET
	Quit $ZERROR
}

ClassMethod CheckIsExists(Code, Desc, flag)
{
	Set errlog=0
	;收费项目大类
	If flag="TarCate" Do
	.If $D(^DHCTarC("CC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("CC",0,"Desc",Desc)) Set errlog="-1002"
	;收费项目子类
	If flag="TarSubCate" Do
	.If $D(^DHCTarC("SC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("SC",0,"Desc",Desc)) Set errlog="-1002"
	
	;住院费用大类
	If flag="TarIC" Do
	.If $D(^DHCTarC("TIC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("TIC",0,"Desc",Desc)) Set errlog="-1002"
	;住院费用子类
	If flag="TarInpatCate" Do
	.If $D(^DHCTarC("IC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("IC",0,"Desc",Desc)) Set errlog="-1002"

	;门诊费用大类
	If flag="TarOC" Do
	.If $D(^DHCTarC("TOC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("TOC",0,"Desc",Desc)) Set errlog="-1002"
	;门诊费用子类
	If flag="TarOutpatCate" Do
	.If $D(^DHCTarC("OC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("OC",0,"Desc",Desc)) Set errlog="-1002"

	;项目核算大类  
	If flag="TarEC" Do
	.If $D(^DHCTarC("TEC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("TEC",0,"Desc",Desc)) Set errlog="-1002"
	;项目核算子类
	If flag="TarEMCCate" Do
	.If $D(^DHCTarC("EC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("EC",0,"Desc",Desc)) Set errlog="-1002"

	;旧病历首页大类
	If flag="TarMC" Do
	.If $D(^DHCTarC("TMC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("TMC",0,"Desc",Desc)) Set errlog="-1002"
	;旧病历首页子类
	If flag="TarMRCate" Do
	.If $D(^DHCTarC("MC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("MC",0,"Desc",Desc)) Set errlog="-1002"

	;会计大类 
	If flag="TarAC" Do
	.If $D(^DHCTarC("TAC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("TAC",0,"Desc",Desc)) Set errlog="-1002"
	;会计子类
	If flag="TarAcctCate" Do
	.If $D(^DHCTarC("AC",0,"Code",Code)) Set errlog="-1001"
	.Quit:errlog'=0
	.If $D(^DHCTarC("AC",0,"Desc",Desc)) Set errlog="-1002"

	;新病历首页大类 
	If flag="TarNMr" Do
	.Set RowID=0
	.For  Set RowID=$o(^DHCTarC("TMCNew",RowID)) Quit:RowID=""  Do
	..Set MCCode=$p(^DHCTarC("TMCNew",RowID),"^",1)
	..Set MCDesc=$p(^DHCTarC("TMCNew",RowID),"^",2)
	..Quit:errlog'=0
	..If (MCCode=Code)&(Code'="") Set errlog="-1001"
	..If (MCDesc=Desc)&(Desc'="") Set errlog="-1002"
	;新病历首页子类
	If flag="TarNMrCate" Do
	.Set RowID=0
	.For  Set RowID=$o(^DHCTarC("MCNew",RowID)) Quit:RowID=""  Do
	..Set MRCode=$p(^DHCTarC("MCNew",RowID),"^",1)
	..Set MRDesc=$p(^DHCTarC("MCNew",RowID),"^",2)
	..Quit:errlog'=0
	..If (MRCode=Code)&(Code'="") Set errlog="-1001"
	..If (MRDesc=Desc)&(Desc'="") Set errlog="-1002"

	Quit errlog
}

/// 根据名称判断大类是否存在
ClassMethod CheckCateExists(Code, Desc, flag)
{
	Set errlog="-1003^"
	;收费项目大类
	If flag="TarSubCate" Do
	.If '$D(^DHCTarC("CC",0,"Desc",Desc)) Set errlog="-1003^"
	.Else  Do
	..Set Rowid=$o(^DHCTarC("CC",0,"Desc",Desc,""))
	..Set errlog="0^"_Rowid
	
	;住院费用大类
	If flag="TarInpatCate" Do
	.If '$D(^DHCTarC("TIC",0,"Desc",Desc)) Set errlog="-1003^"
	.Else  Do
	..Set Rowid=$o(^DHCTarC("TIC",0,"Desc",Desc,""))
	..Set errlog="0^"_Rowid

	;门诊费用大类
	If flag="TarOutpatCate" Do
	.If '$D(^DHCTarC("TOC",0,"Desc",Desc)) Set errlog="-1003^"
	.Else  Do
	..Set Rowid=$o(^DHCTarC("TOC",0,"Desc",Desc,""))
	..Set errlog="0^"_Rowid

	;项目核算大类  
	If flag="TarEMCCate" Do
	.If '$D(^DHCTarC("TEC",0,"Desc",Desc)) Set errlog="-1003^"
	.Else  Do
	..Set Rowid=$o(^DHCTarC("TEC",0,"Desc",Desc,""))
	..Set errlog="0^"_Rowid

	;旧病历首页大类
	If flag="TarMRCate" Do
	.If '$D(^DHCTarC("TMC",0,"Desc",Desc)) Set errlog="-1003^"
	.Else  Do
	..Set Rowid=$o(^DHCTarC("TMC",0,"Desc",Desc,""))
	..Set errlog="0^"_Rowid

	;会计大类 
	If flag="TarAcctCate" Do
	.If '$D(^DHCTarC("TAC",0,"Desc",Desc)) Set errlog="-1003^"
	.Else  Do
	..Set Rowid=$o(^DHCTarC("TAC",0,"Desc",Desc,""))
	..Set errlog="0^"_Rowid

	;新病历首页大类 
	If flag="TarNMrCate" Do
	.Set RowID=0
	.For  Set RowID=$o(^DHCTarC("TMCNew",RowID)) Quit:RowID=""  Do
	..Set MCDesc=$p(^DHCTarC("TMCNew",RowID),"^",2)
	..Quit:+errlog=0
	..If (MCDesc'=Desc)&(Desc'="") Set errlog="-1003^"
	..Else  Set errlog="0^"_RowID

	Quit errlog
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindUpdateDetail","TarCate")
Query FindUpdateDetail(CatDr As %String) As websys.Query(ROWSPEC = "DisCrp:%String,Date1:%String,Time1:%String,User1:%String,Code1:%String,Code2:%String,Desc1:%String,Desc2:%String,DrStr1:%String,DrStr2:%String,Table1:%String")
{
}

ClassMethod FindUpdateDetailExecute(ByRef qHandle As %Binary, CatDr As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
	If (CatDr="") Quit $$$OK
	
    Set CatDr1=$p(CatDr,"-",1)
    Set Operation=$p(CatDr,"-",2)
    If Operation="" Do
    .Set Date1="" 
    .For  Set Date1=$o(^DHCTarCateInsert(CatDr1,Date1)) Quit:Date1=""  Do
    ..Set Time1=""
    ..For  Set Time1=$o(^DHCTarCateInsert(CatDr1,Date1,Time1)) Quit:Time1=""  Do
    ...Set User1=""
    ...For  Set User1=$o(^DHCTarCateInsert(CatDr1,Date1,Time1,User1)) Quit:User1=""  Do
    ....Set Str=^DHCTarCateInsert(CatDr1,Date1,Time1,User1)
	....Set Table1=$p(Str,"^",1)
	....Set Code2=$p(Str,"^",2)
	....Set Code1=""
	....Set Desc2=$p(Str,"^",3)
	....Set Desc1=""
	....Set DrStr2=$p(Str,"^",4)
	....Set DrStr1=""
	....Set DisCrp="添加"
	....Do OutputRowFindUpdateDetail
    .Set Date1="" 
    .For  Set Date1=$o(^DHCTarCateUpdate(CatDr1,Date1)) Quit:Date1=""  Do
    ..Set Time1=""
    ..For  Set Time1=$o(^DHCTarCateUpdate(CatDr1,Date1,Time1)) Quit:Time1=""  Do
    ...Set User1=""
    ...For  Set User1=$o(^DHCTarCateUpdate(CatDr1,Date1,Time1,User1)) Quit:User1=""  Do
    ....Set Str=$g(^DHCTarCateUpdate(CatDr1,Date1,Time1,User1,1))
    ....Set Str1=$g(^DHCTarCateUpdate(CatDr1,Date1,Time1,User1,2))
    ....Set Str2=$g(^DHCTarCateUpdate(CatDr1,Date1,Time1,User1,3))
	....Set Table1=$p(Str,"^",1)
	....Set Code2=$p(Str,"^",3)
	....Set Desc2=$p(Str1,"^",3)
	....Set DrStr2=$p(Str2,"^",3)
	....Set Code1=$p(Str,"^",2)
	....Set Desc1=$p(Str1,"^",2)
	....Set DrStr1=$p(Str2,"^",2)
	....Set DisCrp="修改"
	....Do OutputRowFindUpdateDetail
    .Set Date1="" 
    .For  Set Date1=$o(^DHCTarCateDelete(CatDr1,Date1)) Quit:Date1=""  Do
    ..Set Time1=""
    ..For  Set Time1=$o(^DHCTarCateDelete(CatDr1,Date1,Time1)) Quit:Time1=""  Do
    ...Set User1=""
    ...For  Set User1=$o(^DHCTarCateDelete(CatDr1,Date1,Time1,User1)) Quit:User1=""  Do
    ....Set Str=^DHCTarCateDelete(CatDr1,Date1,Time1,User1)
	....Set Table1=$p(Str,"^",1)
	....Set Code1=$p(Str,"^",3)
	....Set Desc1=$p(Str,"^",4)
	....Set DrStr1=$p(Str,"^",5)
	....Set Code2=""
	....Set Desc2=""
	....Set DrStr2=""
	....Set DisCrp="删除"
	....Do OutputRowFindUpdateDetail

	Quit $$$OK

OutputRowFindUpdateDetail
	Set Data=$lb(DisCrp,Date1,Time1,User1,Code1,Code2,Desc1,Desc2,DrStr1,DrStr2,Table1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 查询项目大类
/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindTarCate","","","CC")
Query FindTarCate(Code As %String, Desc As %String, CateDr As %String, HospId As %String) As websys.Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod FindTarCateExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String, CateDr As %String, HospId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set ^TMP("FindTarCate")=$lb(Code, Desc, CateDr, HospId)
    Set Code=$g(Code),Desc=$g(Desc)
    
	Set RowID=0
	For  Set RowID=$O(^DHCTarC(CateDr,RowID)) Quit:(RowID="")  Do
	.Set ShowFlag=""
	.If (CateDr="CC") Do
	..Set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarCate", RowID, HospId)
	.Quit:(ShowFlag="N")
	.Do GetTarCate(RowID, Code, Desc)

	Quit $$$OK

GetTarCate(RowID, Code, Desc)
    Set TarCode=$p(^DHCTarC(CateDr,RowID),"^",1)
    Set TarDesc=$p(^DHCTarC(CateDr,RowID),"^",2)
    Quit:(TarCode'[Code)&&(Code'="")&&(TarCode'="")
    Quit:(TarDesc'[Desc)&&(Desc'="")&&(TarDesc'="")
    Set TarDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(TarDesc)
    Set TarCode=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(TarCode)
    Set TarDesc=##class(DHCBILLConfig.DHCBILLFIND).TR(TarDesc)
    Set TarCode=##class(DHCBILLConfig.DHCBILLFIND).TR(TarCode)
    Do OutputTarCate
    Quit
OutputTarCate
	Set Data=$lb(RowID,TarCode,TarDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 查询项目子类
/// TarCate  大类的ID
/// CateDr1  子表主map中global节点
/// CateDr2  子表中指向附表索引的global节点
/// CateDr3  主表主map中global节点
/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindTarSubCate","","","","AC","TAC","TAC")
Query FindTarSubCate(Code As %String, Desc As %String, TarCate As %String, CateDr1 As %String, CateDr2 As %String, CateDr3 As %String, HospId As %String) As websys.Query(ROWSPEC = "rowid:%String,code:%String,desc:%String,tarcatedrid:%String,tarcatedr:%String")
{
}

ClassMethod FindTarSubCateExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String, TarCate As %String, CateDr1 As %String, CateDr2 As %String, CateDr3 As %String, HospId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set Code=$g(Code),Desc=$g(Desc),TarCate=$g(TarCate)
	
	Set RowID=0
	For  Set RowID=$O(^DHCTarC(CateDr1,RowID)) Quit:(RowID="")  Do
	.Set ShowFlag=""
	.If (CateDr1="SC") Do
	..Set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarSubCate", RowID, HospId)
	.Quit:(ShowFlag="N")
	.Do GetTarSubCate(RowID, Code, Desc, TarCate)

	Quit $$$OK

GetTarSubCate(RowID, Code, Desc, TarCate)
    Set TarCode=$p(^DHCTarC(CateDr1,RowID),"^",1)
    Set TarDesc=$p(^DHCTarC(CateDr1,RowID),"^",2)
    Set TarCateDr=$p(^DHCTarC(CateDr1,RowID),"^",3)
    Quit:((TarDesc'[Desc)&(TarDesc'="")&&(Desc'=""))
    Quit:((TarCode'[Code)&(TarCode'="")&&(Code'=""))
    Quit:((TarCateDr'=TarCate)&&(TarCate'=""))
    Set TarCateDesc=""
    If (CateDr2="TCC") Do
    .Quit:(TarCateDr="")
    .Set TarCateDesc=$p($g(^DHCTarC(CateDr3,TarCateDr)),"^",2)
    Else  Do
    .Quit:(TarCateDr="")
    .Set TarCateDesc=$p($g(^DHCTarC(CateDr2,TarCateDr)),"^",2)
    Set TarCode=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(TarCode)
    Set TarDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(TarDesc)
    Set TarCateDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(TarCateDesc)
    Set TarCode=##class(DHCBILLConfig.DHCBILLFIND).TR(TarCode)
    Set TarDesc=##class(DHCBILLConfig.DHCBILLFIND).TR(TarDesc)
    Set TarCateDesc=##class(DHCBILLConfig.DHCBILLFIND).TR(TarCateDesc)
  
    Do OutputTarSubCate
    Quit
OutputTarSubCate
	Set Data=$lb(RowID,TarCode,TarDesc,TarCateDr,TarCateDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 新病案首页大类
/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindTarNMr","","")
Query FindTarNMr(Code As %String, Desc As %String) As websys.Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod FindTarNMrExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set Code=$g(Code),Desc=$g(Desc)
    If ((Code="")&(Desc="")) Do
	.Set RowID=0
	.For  Set RowID=$O(^DHCTarC("TMCNew",RowID)) Quit:RowID=""  Do
	..Do GetTarNMr(RowID)
	If (Code'="") Do
	.Set OldCode=Code,Code=$O(^DHCTARMCNEW(0,"Code",Code),-1)
	.If  Set Code=$O(^DHCTARMCNEW(0,"Code",Code)) Quit:(Code="")!($E(Code,1,$L(OldCode))'=OldCode)  Do
	..Set RowID=0
	..For  Set RowID=$o(^DHCTARMCNEW(0,"Code",Code,RowID)) Quit:RowID=""  Do
	...Do GetTarNMr(RowID) 
	Else  If Desc'="" d
	.Set OldDesc=Desc,Desc=$o(^DHCTARMCNEW(0,"Desc",Desc),-1)
	.For  Set Desc=$o(^DHCTARMCNEW(0,"Desc",Desc)) Quit:(Desc="")!($E(Desc,1,$L(OldDesc))'=OldDesc)  Do
	..Set RowID=0
	..For  Set RowID=$o(^DHCTARMCNEW(0,"Desc",Desc,RowID)) Quit:RowID=""  Do
	...Do GetTarNMr(RowID)

	Quit $$$OK

GetTarNMr(RowID)
    Set TarCode=$p(^DHCTarC("TMCNew",RowID),"^",1)
    Set TarDesc=$p(^DHCTarC("TMCNew",RowID),"^",2)
    Do OutputRowTarNMr
    Quit
OutputRowTarNMr
	Set Data=$lb(RowID,TarCode,TarDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 新病案首页子类
/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindTarNMrCate","","","")
Query FindTarNMrCate(Code As %String, Desc As %String, TarCate As %String) As websys.Query(ROWSPEC = "rowid:%String,code:%String,desc:%String,tarcatedrid:%String,tarcatedr:%String")
{
}

ClassMethod FindTarNMrCateExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String, TarCate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set Code=$g(Code),Desc=$g(Desc),TarCate=$g(TarCate)
    If ((Code="")&(Desc="")&(TarCate="")) Do
	.Set RowID=0
	.For  Set RowID=$O(^DHCTarC("MCNew",RowID)) Quit:RowID=""  Do
	..Do GetTarNMrCate(RowID)
	If Code'="" Do
	.Set OldCode=Code,Code=$O(^DHCTARMRCATENEW(0,"Code",Code),-1)
	.If  Set Code=$O(^DHCTARMRCATENEW(0,"Code",Code)) Quit:(Code="")!($E(Code,1,$L(OldCode))'=OldCode)  Do
	..Set RowID=0
	..For  Set RowID=$o(^DHCTARMRCATENEW(0,"Code",Code,RowID)) Quit:RowID=""  Do
	...d GetTarNMrCate(RowID) 
	Else  If Desc'="" d
	.Set OldDesc=Desc,Desc=$o(^DHCTARMRCATENEW(0,"Desc",Desc),-1)
	.For  Set Desc=$o(^DHCTARMRCATENEW(0,"Desc",Desc)) Quit:(Desc="")!($E(Desc,1,$L(OldDesc))'=OldDesc)  Do
	..Set RowID=0
	..For  Set RowID=$o(^DHCTARMRCATENEW(0,"Desc",Desc,RowID)) Quit:RowID=""  Do
	...Do GetTarNMrCate(RowID) 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetTarNMrCate(RowID)
    Set TarCode=$p(^DHCTarC("MCNew",RowID),"^",1)
    Set TarDesc=$p(^DHCTarC("MCNew",RowID),"^",2)
    Set TarCateDr=$p(^DHCTarC("MCNew",RowID),"^",3)
    Set TarCateDesc=$p($g(^DHCTarC("TMCNew",TarCateDr)),"^",2)
    Do OutputRowTarNMrCate
    Quit
OutputRowTarNMrCate
	Set Data=$lb(RowID,TarCode,TarDesc,TarCateDr,TarCateDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindUniom")
Query FindUniom() As websys.Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod FindUniomExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
	Set Rowid=0
	For  Set Rowid=$o(^CT("UOM",Rowid)) Quit:Rowid=""  Do
	.Set Desc=$p(^CT("UOM",Rowid),"^",2)
	.Do OutputRowUniom
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUniom
	Set Data=$lb(Rowid,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindEpisodeSubType","","",2)
Query FindEpisodeSubType(Code As %String, Desc As %String) As websys.Query(ROWSPEC = "RowID:%String,SUBTCode:%String,SUBTDesc:%String,SUBTAdmType:%String,SUBTDaySurgery:%String,SUBTFirstRegDayNight:%String,SUBTWaitTime:%String,SUBTNationCode:%String,SUBTDateFrom:%String,SUBTDateTo:%String,SUBTAdmType1:%String,SUBTDaySurgery1:%String")
{
}

ClassMethod FindEpisodeSubTypeExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1

    If ((Code="")&&(Desc="")) Do
	.Set RowID=0
	.For  Set RowID=$O(^PAC("SUBT",RowID)) Quit:(RowID="")  Do
	..Do GetEpisodeSubType(RowID)
	If (Code'="") Do
	.Set OldCode=Code, Code=$O(^PAC("SUBT",0,"Code",Code),-1)
	.If  Set Code=$O(^PAC("SUBT",0,"Code",Code)) Quit:(Code="")||($E(Code,1,$L(OldCode))'=OldCode)  Do
	..Set RowID=0
	..For  Set RowID=$o(^PAC("SUBT",0,"Code",Code,RowID)) Quit:(RowID="")  Do
	...Do GetEpisodeSubType(RowID) 
	Else  If (Desc'="") d
	.Set OldDesc=Desc, Desc=$o(^PAC("SUBT",0,"Desc",Desc),-1)
	.For  Set Desc=$o(^PAC("SUBT",0,"Desc",Desc)) Quit:(Desc="")||($E(Desc,1,$L(OldDesc))'=OldDesc)  Do
	..Set RowID=0
	..For  Set RowID=$o(^PAC("SUBT",0,"Desc",Desc,RowID)) Quit:(RowID="")  Do
	...Do GetEpisodeSubType(RowID)

	Quit $$$OK

GetEpisodeSubType(RowID)
    Set SUBTCode=$p(^PAC("SUBT",RowID),"^",1)
    Set SUBTDesc=$p(^PAC("SUBT",RowID),"^",2)
    Set SUBTAdmType=$p(^PAC("SUBT",RowID),"^",3)
    Set SUBTAdmType1=SUBTAdmType
    If (SUBTAdmType="O") Do
    .Set SUBTAdmType="OutPatient"
    If (SUBTAdmType="I") Do
    .Set SUBTAdmType="InPatient"
    If (SUBTAdmType="E") Do
    .Set SUBTAdmType="Emergency"
    If (SUBTAdmType="H") Do
    .Set SUBTAdmType="Health Promotion"
    Set SUBTDaySurgery=$p(^PAC("SUBT",RowID),"^",4)
    sET SUBTDaySurgery1=SUBTDaySurgery
    Set SUBTFirstRegDayNight=$p(^PAC("SUBT",RowID),"^",5)
    Set SUBTWaitTime=$p(^PAC("SUBT",RowID),"^",6)
    Set SUBTNationCode=$p(^PAC("SUBT",RowID),"^",7)
    Set SUBTDateFrom=$p(^PAC("SUBT",RowID),"^",8)
	Set SUBTDateTo=$p(^PAC("SUBT",RowID),"^",9)
	Quit:((+SUBTDateFrom>+$h)||((+SUBTDateTo'=0)&&(+SUBTDateTo<=+$h)))
    If (SUBTDateFrom'="") set SUBTDateFrom=##class(websys.Conversions).DateLogicalToHtml(SUBTDateFrom)
    If (SUBTDateTo'="") set SUBTDateTo=##class(websys.Conversions).DateLogicalToHtml(SUBTDateTo)
    Do OutputEpisodeSubType
    Quit
OutputEpisodeSubType
	Set Data=$lb(RowID,SUBTCode,SUBTDesc,SUBTAdmType,SUBTDaySurgery,SUBTFirstRegDayNight,SUBTWaitTime,SUBTNationCode,SUBTDateFrom,SUBTDateTo,SUBTAdmType1,SUBTDaySurgery1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindAdmReason","","")
Query FindAdmReason(Code As %String, Desc As %String, HospId As %String) As websys.Query(ROWSPEC = "RowID:%String,REACode:%String,READesc:%String,READateFrom:%String,READateTo:%String,REANationalCode:%String,REAAdmSource:%String")
{
}

ClassMethod FindAdmReasonExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String, HospId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set Code=$g(Code),Desc=$g(Desc)
    If ((Code="")&&(Desc="")) Do
	.Set RowID=0
	.For  Set RowID=$O(^PAC("ADMREA",RowID)) Quit:(RowID="")  Do
	..Do GetAdmReason(RowID)
	If (Code'="") Do
	.Set OldCode=Code, Code=$O(^PAC("ADMREA",0,"Code",Code),-1)
	.If  Set Code=$O(^PAC("ADMREA",0,"Code",Code)) Quit:(Code="")||($E(Code,1,$L(OldCode))'=OldCode)  Do
	..Set RowID=0
	..For  Set RowID=$o(^PAC("ADMREA",0,"Code",Code,RowID)) Quit:(RowID="")  Do
	...Do GetAdmReason(RowID) 
	Else  If (Desc'="") Do
	.Set OldDesc=Desc, Desc=$o(^PAC("ADMREA",0,"Desc",Desc),-1)
	.For  Set Desc=$o(^PAC("ADMREA",0,"Desc",Desc)) Quit:(Desc="")||($E(Desc,1,$L(OldDesc))'=OldDesc)  Do
	..Set RowID=0
	..For  Set RowID=$o(^PAC("ADMREA",0,"Desc",Desc,RowID)) Quit:(RowID="")  Do
	...Do GetAdmReason(RowID)
	Quit $$$OK

GetAdmReason(RowID)
	Set READata=$g(^PAC("ADMREA",RowID))
    Set REACode=$p(READata,"^",1)
    Set READesc=$p(READata,"^",2)
    Set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason", RowID, HospId)
	Quit:(ShowFlag="N")
    Set READateFrom=$p(READata,"^",3)
	Set READateTo=$p(READata,"^",4)
    Quit:((READateFrom'="")&&(READateFrom>+$h))
	Quit:((READateTo'="")&&(READateTo<+$h))
	Set READateFrom=##class(websys.Conversions).DateLogicalToHtml(READateFrom)
	Set READateTo=##class(websys.Conversions).DateLogicalToHtml(READateTo)
    Set REANationalCode=$p(READata,"^",5)
    Set REAAdmSource=$p(READata,"^",9)
    Do OutputAdmReason
    Quit
OutputAdmReason
	Set Data=$lb(RowID,REACode,READesc,READateFrom,READateTo,REANationalCode,REAAdmSource)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindBillCondition", "", "", 2)
Query FindBillCondition(ArcCat As %String, BillCondition As %String, HospId As %Stream) As websys.Query(ROWSPEC = "BCRowid:%String,BCSubCateDesc:%String,BCConditionDesc:%String,BCSubCate:%String,BCCondition:%String")
{
}

ClassMethod FindBillConditionExecute(ByRef qHandle As %Binary, ArcCat As %String, BillCondition As %String, HospId As %Stream) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1

	Set rtn=$$OPEN^DHCJFBC()
	Do{
		Set rtn=$$FETCH^DHCJFBC()
		Do OutputBillCondition(ArcCat, BillCondition)
	}While(rtn=0)
	Do CLOSE^DHCJFBC()
	
	Quit $$$OK
OutputBillCondition(ArcCat, BillCondition)
	Set (BCRowid, BCSubCate, BCCondition)=""
	Quit:$d(PLIST)=0
	Set BCRowid=PLIST(1)
	Set BCSubCate=PLIST(2)
	Set BCHospDR=PLIST(4)
	Quit:(BCHospDR'=HospId)
	Quit:(ArcCat'=BCSubCate)&&(BCSubCate'="")&&(ArcCat'="")
	Quit:(BCSubCate="")
	Quit:'$d(^ARC("IC",BCSubCate))
	Set BCSubCateDesc=$p(^ARC("IC",BCSubCate),"^",2)
	Set BCCondition=PLIST(3)
	Quit:((BillCondition'=BCCondition)&&(BCCondition'="")&&(BillCondition'=""))
	Set BCConditionDesc=$case(BCCondition,"OD":"下医嘱计费","OE":"医嘱执行计费","NE":"护士执行计费","CR":"发药计费",:"")
	Set BCSubCateDesc=##class(DHCBILLConfig.DHCBILLFIND).TR(BCSubCateDesc)
	Set BCSubCateDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(BCSubCateDesc)
	Set Data=$lb(BCRowid,BCSubCateDesc,BCConditionDesc,BCSubCate,BCCondition)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindItmCat")
Query FindItmCat(HospId As %String) As websys.Query(ROWSPEC = "RowID:%String,TarCode:%String,TarDesc:%String")
{
}

ClassMethod FindItmCatExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
	Set RowID=0
	For  Set RowID=$O(^ARC("IC",RowID)) Quit:(RowID="")  Do
	.Do GetItmCat(RowID)
	
	Quit $$$OK

GetItmCat(RowID)
	Set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat", RowID, HospId)
	Quit:(ShowFlag="N")
    Set TarCode=$p(^ARC("IC",RowID),"^",1)
    Set TarDesc=$p(^ARC("IC",RowID),"^",2)
	Set TarCode=##class(DHCBILLConfig.DHCBILLFIND).TR(TarCode)
	Set TarCode=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(TarCode)
	Set TarDesc=##class(DHCBILLConfig.DHCBILLFIND).TR(TarDesc)
	Set TarDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(TarDesc)
    Do OutputItmCat
    Quit
OutputItmCat
	Set Data=$lb(RowID,TarCode,TarDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// Debug: w ##class(DHCBILLConfig.DHCBILLSysType).InsertBillCondition("",5","CR","1")
ClassMethod InsertBillCondition(NewItmCat As %String, Condition As %String, User As %String, HospId As %String) [ ProcedureBlock = 1 ]
{
	Set rtn=0, NotInsertInfo=""
	
	Set EnablePMASystem=##class(BILL.Interface.Inside.AuthItemApply).GetEnablePMASystem()
	
	//+2018-03-02 ZhYW
	Quit:((Condition="CR")&&(..CheckContainDrugByArcGrp(NewItmCat)'=0)) -1004_"^"_"只有药品才能设置计费点为CR"
	
    Set Condition=$Case(Condition,"下医嘱计费":"OD","医嘱执行计费":"OE","护士执行计费":"NE","发药计费":"CR",:Condition)
    Quit:(Condition="") -1002_"^"_"计费点不存在，不能添加"
	
	Set ItmCatLen=$l(NewItmCat,",")
	For i=1:1:ItmCatLen {
		Set ItmCat=$p(NewItmCat,",",i)
		Continue:(ItmCat="")
		If ('$Number(ItmCat)) {
			Set rtn=-1001_"^"_"医嘱子类不存在，不能添加"
			Quit
		}
	}
	Quit:(+rtn) rtn
	
	If ('EnablePMASystem) {
		Set rtn=$$INSERTBC()
		Quit rtn
	}
	
	//+2023-03-20 ZhYW 向权力系统发送审批申请
	Set appJson=##class(%DynamicObject).%New()
	Set appJson.ItmCat=NewItmCat
	Set appJson.Condition=Condition
	Set appJson.HospId=HospId
	Set appJson.CURD="Insert"
	Set rtn=##class(BILL.Interface.Inside.AuthItemApply).SaveBillConditionApply(appJson.%ToJSON())   //向权力系统发送申请
    Quit rtn

INSERTBC()
	For i=1:1:ItmCatLen {
		Set ItmCat=$p(NewItmCat,",",i)
	    Continue:(+ItmCat=0)
		Set Flag=0
		Set Rowid=0
		While($o(^DHCTarC("BC",0,ItmCat,Rowid))) {
			Set Rowid=$o(^DHCTarC("BC",0,ItmCat,Rowid))
			Set HospDR=$p(^DHCTarC("BC",Rowid),"^",3)
	   		Continue:(HospDR'=HospId)
	    	Set ItmCatDesc=$p(^ARC("IC",ItmCat),"^",2)
	   		Set NotInsertInfo=$s((NotInsertInfo=""):ItmCatDesc,1:(NotInsertInfo_","_ItmCatDesc))
	   		Set Flag=1
		}
	    Continue:(+Flag)
	    &SQL(
	    	INSERT INTO DHC_BillCondition(
	    		BC_SubCate_Dr, BC_Condition, BC_Hosp_Dr
	    	)
	    	VALUES(
	    		:ItmCat, :Condition, :HospId
	    	)
	    )
	    Set rtn=SQLCODE
		If (+rtn) {
			Set rtn=rtn_"^"_$g(%msg)
			Quit
		}
		Set Flag2="DHC_BillCondition",UserTable="User.DHCBillCondition",TableDesc="医嘱计费点设置",InsRowid=%ROWID
		Set JsonStr="{BCRowId:"_InsRowid_",BCSubCateDr:"_ItmCat_",BCCondition:"_Condition_"}" 
		Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)
	}
	If (NotInsertInfo'="") Set rtn=-1003_"^"_"以下子类已维护计费点,不能添加,其他子类维护成功:"_NotInsertInfo
	
    Quit rtn
}

/// Debug: w ##class(DHCBILLConfig.DHCBILLSysType).UpdateBillCondition("1","19","OD","1","2")
ClassMethod UpdateBillCondition(RowID As %String, ItmCat As %String, Condition As %String, User As %String, HospId As %String) [ ProcedureBlock = 1 ]
{
	Set ^TMP("UpdateBillCondition")=$lb(RowID, ItmCat, Condition, User, HospId)
	Quit:(ItmCat[",") -1_"^"_"修改记录时只能选择一条进行修改，不可多选"
	
	Set EnablePMASystem=##class(BILL.Interface.Inside.AuthItemApply).GetEnablePMASystem()
	
	//+2018-03-02 ZhYW
	Quit:((Condition="CR")&&(..CheckContainDrugByArcGrp(ItmCat)'=0)) -1004_"^"_"只有药品才能设置计费点为CR"

    Set rtn=$$SELECT^DHCJFBC(RowID)
    If (+rtn) Quit rtn
    
    If '$d(^ARC("IC",ItmCat)) {
    	Set ItmCat=$o(^ARC("IC",0,"Desc",ItmCat,0))
    }
    Quit:(ItmCat="") -1001_"^"_"医嘱子类不存在，不能修改"
    
	Set Condition=$Case(Condition,"下医嘱计费":"OD","医嘱执行计费":"OE","护士执行计费":"NE","发药计费":"CR",:Condition)
    Quit:(Condition="") -1002_"^"_"计费点不存在，不能修改"

    Set OldItmCat=$g(PLIST(2))
    Set OldCondition=$g(PLIST(3))
    
    Set Flag=0
    If (OldItmCat'=ItmCat) {
	    Set myRowid=0
	    While($o(^DHCTarC("BC",0,ItmCat,myRowid))) {
		    Set myRowid=$o(^DHCTarC("BC",0,ItmCat,myRowid))
		 	Continue:(RowID=myRowid)
		    Set HospDR=$p(^DHCTarC("BC",myRowid),"^",3)
		    Continue:(HospDR'=HospId)
		    Set Flag=1
			Quit
		}
    }
    Quit:(+Flag) -1003_"^"_"医嘱子类已维护计费点，不能修改"
	
	If ('EnablePMASystem) {
		Set rtn=$$UPDATEBC()
		Quit rtn
	}
	
	//+2023-03-20 ZhYW 向权力系统发送审批申请
	Set appJson=##class(%DynamicObject).%New()
	Set appJson.ID=RowID
	Set appJson.ItmCat=ItmCat
	Set appJson.Condition=Condition
	Set appJson.HospId=HospId
	Set appJson.CURD="Update"
	Set rtn=##class(BILL.Interface.Inside.AuthItemApply).SaveBillConditionApply(appJson.%ToJSON())   //向权力系统发送申请
	Quit rtn
    
UPDATEBC()
	&SQL(
		UPDATE DHC_BillCondition
		SET BC_SubCate_Dr = :ItmCat, BC_Condition = :Condition
		WHERE %ID = :RowID
	)
	Set rtn=SQLCODE
	If (+rtn) Set rtn=rtn_"^"_$g(%msg)
    
	Set Flag2="DHC_BillCondition",UserTable="User.DHCBillCondition",TableDesc="医嘱计费点设置",InsRowid=RowID
	Set JsonStr="{BCRowId:"_InsRowid_",BCSubCateDr:"_ItmCat_",BCCondition:"_Condition_"}" 
	Set JsonStrOld="{BCRowId:"_InsRowid_",BCSubCateDr:"_OldItmCat_",BCCondition:"_OldCondition_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)
	Quit rtn
}

ClassMethod DeleteBillCondition(RowID, User)
{
	Set Date=+$h, Time=$p($h,",",2)
	Set Myrtn=$$SELECT^DHCJFBC(RowID)
	If (Myrtn'=0) Quit Myrtn
    Set ItmCat=PLIST(2)
    Set Condition=PLIST(3)

	Set Myrtn=$$DELETE^DHCJFBC(RowID)

	Set Flag2="DHC_BillCondition",UserTable="User.DHCBillCondition",TableDesc="医嘱计费点设置",InsRowid=RowID
	Set JsonStr="{BCRowId:"_InsRowid_",BCSubCateDr:"_ItmCat_",BCCondition:"_Condition_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "删除", "D", JsonStr)

	Quit Myrtn
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindTarEpisode")
Query FindTarEpisode(hospId As %String) As websys.Query(ROWSPEC = "TEPRowid:%String,TEPESTDR:%String,TEPESTDesc:%String,TEPPriceList:%String,TEPPriceListDr:%String,TEPStartDate:%String,TEPEndDate:%String,TEPESTDR:%String")
{
}

ClassMethod FindTarEpisodeExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
	Set rtn=$$OPEN^DHCJFTES()
	Do{
		Set rtn=$$FETCH^DHCJFTES()
		Do GetTarEpisode
	}WHILE rtn="0"
	Do CLOSE^DHCJFTES()

	Quit $$$OK
GetTarEpisode
	Quit:$d(PLIST)=0
	Set TEPRowid=PLIST(1)
	Set TEPESTDR=PLIST(2)
	Set TEPESTDesc=$s((+TEPESTDR'=0):$p($g(^PAC("SUBT",TEPESTDR)),"^",2),1:"")
	Set TEPPriceList=PLIST(3)
	Set TEPPriceListDr=""
	If (TEPPriceList="Price") Set TEPPriceListDr="P0"
	If (TEPPriceList="AlterPrice1") Set TEPPriceListDr="P1"
	If (TEPPriceList="AlterPrice2") Set TEPPriceListDr="P2"
	Set TEPStartDate=PLIST(4)
	Set TEPEndDate=PLIST(5)
	Set TEPHospDR=PLIST(6)
	Quit:(TEPHospDR'=hospId)
    Do OutputTarEpisode
    Quit
OutputTarEpisode
	Set Data=$lb(TEPRowid,TEPESTDR,TEPESTDesc,TEPPriceList,TEPPriceListDr,TEPStartDate,TEPEndDate,TEPESTDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).InsertTarEpisode("P0",6,"2014-06-10","",1)
ClassMethod InsertTarEpisode(Price As %String, Episode As %String, TepStDate As %String, TepEndDate As %String, User As %String, HospId As %String)
{
	
	Set Date=+$h
	Set Time=$p($h,",",2)
	
	Set Flag=0
	Set StDate=0
    For  Set StDate=$o(^DHCTAREP(0,"EP",Episode,StDate)) Quit:((StDate="")||(Flag'=0))  Do
    .Set Rowid=0
    .For  Set Rowid=$o(^DHCTAREP(0,"EP",Episode,StDate,Rowid)) Quit:((Rowid="")||(Flag'=0))  Do
    ..Set EndDate=$p(^DHCTAREP(Rowid),"^",4)
    ..Quit:((EndDate'="")&&(EndDate<+$h))
	..Set HospDR=$p(^DHCTAREP(Rowid),"^",5)
	..Quit:(HospDR'=HospId)
    ..Set Flag=1
   	Quit:(Flag'=0) """"_"-1004已有有效相同的就诊类别维护了标准价格,不可维护"_""""
   	
    Set TepStDate=##class(websys.Conversions).DateHtmlToLogical(TepStDate)
    Set TepEndDate=##class(websys.Conversions).DateHtmlToLogical(TepEndDate)
    Quit:((TepStDate>TepEndDate)&&(TepEndDate'="")) """"_"-1010开始日期不能大于结束日期"_""""
    
    Kill PLIST
    Set PLIST(2)=Episode
    Set PLIST(3)=Price
    Set PLIST(4)=TepStDate
    Set PLIST(5)=TepEndDate
    Set PLIST(6)=HospId
    Set Myrtn=$$INSERT^DHCJFTES()
    
    If (+Myrtn=0) Do
	.Set Flag2="DHC_TarEpisode",UserTable="User.DHCTarEpisode",TableDesc="病人类别与标准价格",InsRowid=%ROWID
	.Set JsonStr="{TEPRowId:"_InsRowid_",TEPESTDR:"_Episode_",TEPPriceList:"_Price_",TEPStartDate:"_TepStDate_",TEPEndDate:"_TepEndDate_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)
    
    Quit Myrtn
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarEpisode(40, "P2", 6, "2017-06-16", "", 1)
ClassMethod UpdateTarEpisode(TepRowid, Price, Episode, TepStDate, TepEndDate, User, HospId)
{
	
	set ^TMP("UpdateTarEpisode")=$lb(TepRowid, Price, Episode, TepStDate, TepEndDate, User, HospId)
	Set Date=+$h
	Set Time=$p($h,",",2)
    
    If '$d(^PAC("SUBT",Episode)) Do
    .Set Episode=$o(^PAC("SUBT",0,"Desc",$$ALPHAUP^SSUTIL4(Episode),0))
    Quit:(Episode="") "-1001"
    
	Set Price=$Case(Price,"P0":"P0","P1":"P1","P2":"P2","Price":"P0","AlterPrice1":"P1","AlterPrice2":"P2",:"")
    Quit:(Price="") "-1002"

	Set Flag=0
	Set StDate=0
    For  Set StDate=$o(^DHCTAREP(0,"EP",Episode,StDate)) Quit:((StDate="")||(Flag'=0))  Do
    .Set Rowid=0
    .For  Set Rowid=$o(^DHCTAREP(0,"EP",Episode,StDate,Rowid)) Quit:((Rowid="")||(Flag'=0))  Do
    ..Quit:(TepRowid=Rowid)
    ..Set EndDate=$p(^DHCTAREP(Rowid),"^",4)
    ..Quit:((EndDate'="")&&(EndDate<+$h))
	..Set HospDR=$p(^DHCTAREP(Rowid),"^",5)
	..Quit:(HospDR'=HospId)
	..Set Flag=1
	Quit:(Flag'=0) "-1004"
    
	Set Myrtn=$$SELECT^DHCJFTES(TepRowid)
    If (Myrtn'=0) Quit Myrtn
    Set OldEpisode=$g(PLIST(2))
    Set OldPrice=$g(PLIST(3))
    Set OldTepStDate=$g(PLIST(4))
    Set OldTepEndDate=$g(PLIST(5))

    Set TepStDate=##class(websys.Conversions).DateHtmlToLogical(TepStDate)
    Set TepEndDate=##class(websys.Conversions).DateHtmlToLogical(TepEndDate)
    Quit:((TepEndDate'="")&&(TepStDate>TepEndDate)) """"_"-1010开始日期不能大于结束日期"_""""
    
    Kill PLIST
    Set PLIST(2)=Episode
    Set PLIST(3)=Price
    Set PLIST(4)=TepStDate
    Set PLIST(5)=TepEndDate
    Set Myrtn=$$UPDATE^DHCJFTES(TepRowid)
    
    If (+Myrtn=0) Do
	.Set Flag2="DHC_TarEpisode",UserTable="User.DHCTarEpisode",TableDesc="病人类别与标准价格",InsRowid=TepRowid
	.Set JsonStr="{TEPRowId:"_InsRowid_",TEPESTDR:"_Episode_",TEPPriceList:"_Price_",TEPStartDate:"_TepStDate_",TEPEndDate:"_TepEndDate_"}" 
	.Set JsonStrOld="{TEPRowId:"_InsRowid_",TEPESTDR:"_OldEpisode_",TEPPriceList:"_OldPrice_",TEPStartDate:"_OldTepStDate_",TEPEndDate:"_OldTepEndDate_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)
    
    Quit Myrtn
}

ClassMethod DeleteTarEpisode(RowID, User)
{
	Set Date=+$h, Time=$p($h,",",2)
	Set Myrtn=$$SELECT^DHCJFTES(RowID)
	If (Myrtn'=0) Quit Myrtn

    Set Episode=PLIST(2)
    Set Price=PLIST(3)
    Set TepStDate=PLIST(4)
    Set TepEndDate=PLIST(5)
	Set Myrtn=$$DELETE^DHCJFTES(RowID)
	
    If (+Myrtn=0) Do
	.Set Flag2="DHC_TarEpisode",UserTable="User.DHCTarEpisode",TableDesc="病人类别与标准价格",InsRowid=RowID
	.Set JsonStr="{TEPRowId:"_InsRowid_",TEPESTDR:"_Episode_",TEPPriceList:"_Price_",TEPStartDate:"_TepStDate_",TEPEndDate:"_TepEndDate_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "删除", "D", JsonStr)

	Quit Myrtn
}

/// do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindTarFactor","2^^^^")
Query FindTarFactor(SHExpStr As %String) As websys.Query(ROWSPEC = "TFRowId:%String,TFAdmReaDesc:%String,TFPITDR:%String,TFTarSubCateDesc:%String,TFTARSCDR:%String,TFTarIDesc:%String,TFTARIDR:%String,TFStartDate:%String,TFEndDate:%String,TFDiscRate:%String,TFPayorRate:%String,TFAlterLevel:%String,TFAlterPayorRate:%String,TFRegFac:%String,TFUpDate:%String,TFUpTime:%String,TFUpUser:%String,TFRegFacDr:%String,TFTarCateDesc:%String,TFTARCDR:%String,TFADMTYPEDesc:%String,TFADMTYPE:%String,TFHospDr:%String,TFArcimDr:%String,TFArcimDesc:%String")
{
}

ClassMethod FindTarFactorExecute(ByRef qHandle As %Binary, SHExpStr As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    set ^TMP("FindTarFactor")=SHExpStr
	Set SHHospID=$P(SHExpStr,"^",1)
	Set SHRegID=$P(SHExpStr,"^",2)
	Set SHAdmReason=$P(SHExpStr,"^",3)
	Set SHSubCate=$P(SHExpStr,"^",4)
	Set SHTarDesc=$P(SHExpStr,"^",5)

	Set rtn=$$OPEN^DHCJFTFA()
	If (rtn=100) Quit $$$OK
	Do{
		Set rtn=$$FETCH^DHCJFTFA()
		Do GetTarFactor
	}WHILE rtn="0"
	Do CLOSE^DHCJFTFA()
	Quit $$$OK

GetTarFactor
	Quit:$d(PLIST)=0
	Set TFRowId=PLIST(1)				;ID
	Set TFPITDR=PLIST(2)				;PacAdmReason
	Set TFTARSCDR=PLIST(3)				;DHCTarSubCate
	Set TFTARIDR=PLIST(4)				;DHCTarItem
	Set TFStartDate=PLIST(5)
	Set TFEndDate=PLIST(6)
	Set TFDiscRate=PLIST(7)
	Set TFPayorRate=PLIST(8)
	Set TFAlterLevel=PLIST(9)
	Set TFAlterPayorRate=PLIST(10)
	Set TFRegFacDr=PLIST(11)
	Quit:((SHRegID'=TFRegFacDr)&&(SHRegID'=""))
	Set TFUpDate=PLIST(12)
	Set TFUpTime=PLIST(13)
	Set TFUpUser=PLIST(14)
	Set TFTARCDR=PLIST(15)
	Set TFADMTYPE=PLIST(16)
	Set TFHospDr=PLIST(17)
	Quit:(TFHospDr'=SHHospID)
	Set TFArcimDr=PLIST(18)
	Quit:((SHAdmReason'=TFPITDR)&&(SHAdmReason'=""))
	Quit:((SHSubCate'=TFTARSCDR)&&(SHSubCate'=""))
	Set TFAdmReaDesc=$s((+TFPITDR'=0):$p($g(^PAC("ADMREA",TFPITDR)),"^",2),1:"")
	Set TFTarSubCateDesc=$s((+TFTARSCDR'=0):$p($g(^DHCTarC("SC",TFTARSCDR)),"^",2),1:"")
	Set TFTarCateDesc=$s((+TFTARCDR'=0):$p($g(^DHCTarC("CC",TFTARCDR)),"^",2),1:"")
	Set TFTarIDesc=$s((+TFTARIDR'=0):$p($g(^DHCTARI(TFTARIDR)),"^",2),1:"")
	Quit:((TFTarIDesc'[SHTarDesc)&&(SHTarDesc'=""))
	Set TFRegFac=$s((+TFRegFacDr'=0):$p($g(^DHCRCD(+PLIST(11))),"^",2),1:"")

	Set TFADMTYPEDesc=$Case(TFADMTYPE,"E":"急诊","O":"门诊","I":"住院","H":"体检","A":"全部",:"全部")
	Set TFArcimDesc=$s((+TFArcimDr'=0):$p($g(^ARCIM(+TFArcimDr,1,1)),"^",2),1:"")
    Do OutputTarFactor
    Quit
OutputTarFactor
	Set Data=$lb(TFRowId,TFAdmReaDesc,TFPITDR,TFTarSubCateDesc,TFTARSCDR,TFTarIDesc,TFTARIDR,TFStartDate,TFEndDate,TFDiscRate,TFPayorRate,TFAlterLevel,TFAlterPayorRate,TFRegFac,TFUpDate,TFUpTime,TFUpUser,TFRegFacDr,TFTarCateDesc,TFTARCDR,TFADMTYPEDesc,TFADMTYPE,TFHospDr,TFArcimDr,TFArcimDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 保存病人折扣记账系数
/// w ##class(DHCBILLConfig.DHCBILLSysType).InsertTarFactor("^^^^2020-07-11^^0.2^^^^115^3^O^2^", 1)
ClassMethod InsertTarFactor(FactorStr, User)
{
	Set ^TMP("InsertTarFactor")=$lb(FactorStr, User)
	Set Date=+$h, Time=$p($h,",",2)
	Set Flag=0
	
	Set TFAdmReaDesc=$p(FactorStr,"^",2)
	Set TFTarSubCateDesc=$p(FactorStr,"^",3)
	Set TFTARIDR=$p(FactorStr,"^",4)
	Set TFStartDate=$p(FactorStr,"^",5)
	Set TFEndDate=$p(FactorStr,"^",6)
	Set TFDiscRate=$p(FactorStr,"^",7)
	Set TFPayorRate=$p(FactorStr,"^",8)
	Set TFAlterLevel=$p(FactorStr,"^",9)
	Set TFAlterPayorRate=$p(FactorStr,"^",10)
	Set TFRegFac=$p(FactorStr,"^",11)
	Set TFTarCateDesc=$p(FactorStr,"^",12)
	Set TFAdmType=$p(FactorStr,"^",13)
	Set TFHospDr=$p(FactorStr,"^",14)
	Set TFArcimDr=$p(FactorStr,"^",15)
	If (TFAdmType="") Set TFAdmType="A"
	Quit:((TFAdmReaDesc="")&&(TFRegFac="")) """"_"-1003^挂号优惠与就诊类型不能同时为空!"_""""
	
	If ((TFAdmReaDesc'="")&&('$d(^PAC("ADMREA",TFAdmReaDesc)))) {
		Set TFAdmReaDesc=$o(^PAC("ADMREA",0,"Desc",$$ALPHAUP^SSUTIL4(TFAdmReaDesc),0))
	}
	If ((TFTarCateDesc'="")&&('$d(^DHCTarC("CC",TFTarCateDesc)))) {
		Set TFTarCateDesc=$o(^DHCTarC("CC",0,"Desc",TFTarCateDesc,0))
	}
	Quit:((+TFTarCateDesc=0)&&(+TFTarSubCateDesc=0)&&(+TFTARIDR=0)) """"_"-1005^收费项目、子类、大类不能同时为空!"_""""
	
    Set TFStartDate=##class(websys.Conversions).DateHtmlToLogical(TFStartDate)
    Set TFEndDate=##class(websys.Conversions).DateHtmlToLogical(TFEndDate)
    
    Quit:((TFStartDate<=Date)||(TFStartDate="")) """"_"-1001^开始日期不能为空，且不能小于等于今日"_""""
    Quit:((TFEndDate<Date)&&(TFEndDate'="")) """"_"-1002^结束日期不能小于今日"_""""
    Quit:((TFStartDate>TFEndDate)&&(TFEndDate'="")) """"_"-1004^开始日期不能大于结束日期"_""""
    Quit:(+TFDiscRate>1) """"_"-1005^折扣系数维护不合法"_""""
    Quit:(+TFPayorRate>1) """"_"-1005^记账系数维护不合法"_""""
    Quit:(+TFAlterPayorRate>1) """"_"-1005^限额比例维护不合法"_""""
	Quit:((TFAlterLevel'="")&&(TFAlterPayorRate="")) """"_"-1005^维护了支付限额时需维护限额比例"_""""

    If (+TFTARIDR=0) Set TFTARIDR=""
    Kill PLIST
    Set PLIST(2)=TFAdmReaDesc
    Set PLIST(3)=TFTarSubCateDesc
    Set PLIST(4)=TFTARIDR
    Set PLIST(5)=TFStartDate
    Set PLIST(6)=TFEndDate
    Set PLIST(7)=TFDiscRate
    Set PLIST(8)=TFPayorRate
    Set PLIST(9)=TFAlterLevel
    Set PLIST(10)=TFAlterPayorRate
    Set PLIST(11)=TFRegFac
    Set PLIST(12)=Date
    Set PLIST(13)=Time
    Set PLIST(14)=User
    Set PLIST(15)=TFTarCateDesc
    Set PLIST(16)=TFAdmType
    Set PLIST(17)=TFHospDr
    Set PLIST(18)=TFArcimDr
    Set Myrtn=$$INSERT^DHCJFTFA()
	//TFRecConDr, TFUpdateDate, TFUpdateTime, TFUpdateUser
	Set Flag2="DHC_TarFactor",UserTable="User.DHCTarFactor",TableDesc="病人折扣记账系数表",InsRowid=%ROWID
	Set JsonStr="{TFRowId:"_InsRowid_",TFPITDR:"_TFAdmReaDesc_",TFTARSCDR:"_TFTarSubCateDesc
	Set JsonStr=JsonStr_",TFTARIDR:"_TFTARIDR_",TFStartDate:"_TFStartDate
	Set JsonStr=JsonStr_",TFEndDate:"_TFEndDate_",TFDiscRate:"_TFDiscRate
	Set JsonStr=JsonStr_",TFPayorRate:"_TFPayorRate_",TFAlterLevel:"_TFAlterLevel
	Set JsonStr=JsonStr_",TFAlterPayorRate:"_TFAlterPayorRate_",TFRecConDr:"_TFRegFac
	Set JsonStr=JsonStr_",TFUpdateDate:"_Date_",TFUpdateTime:"_Time
	Set JsonStr=JsonStr_",TFUpdateUser:"_User_",TFTARCDr:"_TFTarCateDesc
	Set JsonStr=JsonStr_",TFAdmType:"_TFAdmType_",TFHospDr:"_TFHospDr
	Set JsonStr=JsonStr_",TFArcimDr:"_TFArcimDr_"}"
	
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

    Quit """"_Myrtn_""""
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdateTarFactor("6^^^^2020-07-11^^0.3^^^^115^5^O^2^", 1)
ClassMethod UpdateTarFactor(FactorStr, User)
{
	Set ^TMP("UpdateTarFactor")=$lb(FactorStr, User)
	Set Date=+$h, Time=$p($h,",",2)
	Set Flag=0
	
	Set TFRowid=$p(FactorStr,"^",1)
	Set TFAdmReaDesc=$p(FactorStr,"^",2)
	Set TFTarSubCateDesc=$p(FactorStr,"^",3)
	Set TFTARIDR=$p(FactorStr,"^",4)
	Set TFStartDate=$p(FactorStr,"^",5)
	Set TFEndDate=$p(FactorStr,"^",6)
	Set TFDiscRate=$p(FactorStr,"^",7)
	Set TFPayorRate=$p(FactorStr,"^",8)
	Set TFAlterLevel=$p(FactorStr,"^",9)
	Set TFAlterPayorRate=$p(FactorStr,"^",10)
	Set TFRegFac=$p(FactorStr,"^",11)
	Set TFTarCateDesc=$p(FactorStr,"^",12)
	Set TFAdmType=$p(FactorStr,"^",13)
	Set TFHospDr=$p(FactorStr,"^",14)
	Set TFArcimDr=$p(FactorStr,"^",15)
	If (TFAdmType="") Set TFAdmType="A"
	
	Quit:((TFAdmReaDesc="")&&(TFRegFac="")) """"_"-1003^挂号优惠与就诊类型不能同时为空!"_""""
	
	If ((TFAdmReaDesc'="")&&('$d(^PAC("ADMREA",TFAdmReaDesc)))) {
		Set TFAdmReaDesc=$o(^PAC("ADMREA",0,"Desc",$$ALPHAUP^SSUTIL4(TFAdmReaDesc),0))
	}
	If ((TFTarCateDesc'="")&&('$d(^DHCTarC("CC",TFTarCateDesc)))) {
		Set TFTarCateDesc=$o(^DHCTarC("CC",0,"Desc",TFTarCateDesc,0))
	}
	Quit:((+TFTarCateDesc=0)&&(+TFTarSubCateDesc=0)&&(+TFTARIDR=0)) """"_"-1005^收费项目、子类、大类不能同时为空!"_""""
	    
    Set TFStartDate1=##class(websys.Conversions).DateHtmlToLogical(TFStartDate)
    Set TFEndDate1=##class(websys.Conversions).DateHtmlToLogical(TFEndDate)
    
    Set OldTFAdmReaDesc=$p(^DHCTARF(TFRowid),"^",1)
    Set OldTFTarSubCateDesc=$p(^DHCTARF(TFRowid),"^",2)
    Set OldTFTARIDR=$p(^DHCTARF(TFRowid),"^",3)
    Set OldTFStartDate=$p(^DHCTARF(TFRowid),"^",4)
    Set OldTFEndDate=$p(^DHCTARF(TFRowid),"^",5)
    Set OldTFDiscRate=$p(^DHCTARF(TFRowid),"^",6)
    Set OldTFPayorRate=$p(^DHCTARF(TFRowid),"^",7)
    Set OldTFAlterLevel=$p(^DHCTARF(TFRowid),"^",8)
    Set OldTFAlterPayorRate=$p(^DHCTARF(TFRowid),"^",9)
    Set OldTFRegFac=$p(^DHCTARF(TFRowid),"^",10)
    Set OldDate=$p(^DHCTARF(TFRowid),"^",11)
    Set OldTime=$p(^DHCTARF(TFRowid),"^",12)
    Set OldUser=$p(^DHCTARF(TFRowid),"^",13)
    Set OldTFTarCateDesc=$p(^DHCTARF(TFRowid),"^",14)
    Set OldTFAdmType=$p(^DHCTARF(TFRowid),"^",15)
    Set OldTFHospDr=$p(^DHCTARF(TFRowid),"^",16)
	Set OldTFArcimDr=$p(^DHCTARF(TFRowid),"^",17)
	
    Quit:(((TFStartDate1<=Date)&&(TFStartDate1'=OldTFStartDate))||(TFStartDate1="")) """"_"-1001^开始日期不能为空，且不能小于等于今日"_""""
    Quit:(((TFEndDate1<Date)&&(TFEndDate1'=OldTFEndDate))&&(TFEndDate1'="")&&(OldTFEndDate'="")) """"_"-1002^结束日期不能小于等于今日"_""""
    Quit:((TFStartDate1>TFEndDate1)&&(TFEndDate1'="")) """"_"-1004^开始日期不能大于结束日期"_""""
    Quit:((TFEndDate1<Date)&&(TFEndDate1'="")) """"_"-1010^结束日期不能小于当日"_""""
	Quit:(+TFDiscRate>1) """"_"-1005^折扣系数维护不合法"_""""
    Quit:(+TFPayorRate>1) """"_"-1005^记账系数维护不合法"_""""
    Quit:(+TFAlterPayorRate>1) """"_"-1005^限额比例维护不合法"_""""
    Quit:((TFAlterLevel'="")&&(TFAlterPayorRate="")) """"_"-1005^维护了支付限额时需维护限额比例"_""""

    If (+TFTARIDR=0) Set TFTARIDR=""
    Kill PLIST
    Set PLIST(2)=TFAdmReaDesc
    Set PLIST(3)=TFTarSubCateDesc
    Set PLIST(4)=TFTARIDR
    Set PLIST(5)=TFStartDate
    Set PLIST(6)=TFEndDate
    Set PLIST(7)=TFDiscRate
    Set PLIST(8)=TFPayorRate
    Set PLIST(9)=TFAlterLevel
    Set PLIST(10)=TFAlterPayorRate
    Set PLIST(11)=TFRegFac
    Set PLIST(12)=Date
    Set PLIST(13)=Time
    Set PLIST(14)=User
    Set PLIST(15)=TFTarCateDesc
    Set PLIST(16)=TFAdmType
    Set PLIST(18)=TFArcimDr
    Set Myrtn=$$UPDATE^DHCJFTFA(TFRowid)

	Set Flag2="DHC_TarFactor",UserTable="User.DHCTarFactor",TableDesc="病人折扣记账系数表",InsRowid=TFRowid
	Set JsonStr="{TFRowId:"_InsRowid_",TFPITDR:"_TFAdmReaDesc_",TFTARSCDR:"_TFTarSubCateDesc
	Set JsonStr=JsonStr_",TFTARIDR:"_TFTARIDR_",TFStartDate:"_TFStartDate
	Set JsonStr=JsonStr_",TFEndDate:"_TFEndDate_",TFDiscRate:"_TFDiscRate
	Set JsonStr=JsonStr_",TFPayorRate:"_TFPayorRate_",TFAlterLevel:"_TFAlterLevel
	Set JsonStr=JsonStr_",TFAlterPayorRate:"_TFAlterPayorRate_",TFRecConDr:"_TFRegFac
	Set JsonStr=JsonStr_",TFUpdateDate:"_Date_",TFUpdateTime:"_Time
	Set JsonStr=JsonStr_",TFUpdateUser:"_User_",TFTARCDr:"_TFTarCateDesc
	Set JsonStr=JsonStr_",TFAdmType:"_TFAdmType_",TFHospDr:"_TFHospDr
	Set JsonStr=JsonStr_",TFArcimDr:"_TFArcimDr_"}"
	
	Set JsonStrOld="{TFRowId:"_InsRowid_",TFPITDR:"_OldTFAdmReaDesc_",TFTARSCDR:"_OldTFTarSubCateDesc
	Set JsonStrOld=JsonStrOld_",TFTARIDR:"_OldTFTARIDR_",TFStartDate:"_OldTFStartDate
	Set JsonStrOld=JsonStrOld_",TFEndDate:"_OldTFEndDate_",TFDiscRate:"_OldTFDiscRate
	Set JsonStrOld=JsonStrOld_",TFPayorRate:"_OldTFPayorRate_",TFAlterLevel:"_OldTFAlterLevel
	Set JsonStrOld=JsonStrOld_",TFAlterPayorRate:"_OldTFAlterPayorRate_",TFRecConDr:"_OldTFRegFac
	Set JsonStrOld=JsonStrOld_",TFUpdateDate:"_OldDate_",TFUpdateTime:"_OldTime
	Set JsonStrOld=JsonStrOld_",TFUpdateUser:"_OldUser_",TFTARCDr:"_OldTFTarCateDesc
	Set JsonStrOld=JsonStrOld_",TFAdmType:"_OldTFAdmType_",TFHospDr:"_OldTFHospDr
	Set JsonStrOld=JsonStrOld_",TFArcimDr:"_OldTFArcimDr_"}"
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)
    Quit """"_Myrtn_""""
}

ClassMethod DeleteTarFactor(FactorStr, User)
{
	Set Date=+$h, Time=$p($h,",",2)
	Set Flag=0
	
	Set TFRowid=$p(FactorStr,"^",1)
	Set TFAdmReaDesc=$p(FactorStr,"^",2)
	Set TFTarSubCateDesc=$p(FactorStr,"^",3)
	Set TFTARIDR=$p(FactorStr,"^",4)
	Set TFStartDate=$p(FactorStr,"^",5)
	Set TFEndDate=$p(FactorStr,"^",6)
	Set TFDiscRate=$p(FactorStr,"^",7)
	Set TFPayorRate=$p(FactorStr,"^",8)
	Set TFAlterLevel=$p(FactorStr,"^",9)
	Set TFAlterPayorRate=$p(FactorStr,"^",10)
	Set TFRegFac=$p(FactorStr,"^",11)
	Set TFRegFac=$p(^DHCTARF(TFRowid),"^",10)
	Set TFUpDate=$p(^DHCTARF(TFRowid),"^",11)
	Set TFUpTime=$p(^DHCTARF(TFRowid),"^",12)
	Set TFUpUser=$p(^DHCTARF(TFRowid),"^",13)
    Kill PLIST
    Set Myrtn=$$DELETE^DHCJFTFA(TFRowid)

	Set Flag2="DHC_TarFactor",UserTable="User.DHCTarFactor",TableDesc="病人折扣记账系数表",InsRowid=TFRowid
	Set JsonStr="{TFRowId:"_InsRowid_",TFPITDR:"_TFAdmReaDesc_",TFTARSCDR:"_TFTarSubCateDesc
	Set JsonStr=JsonStr_",TFTARIDR:"_TFTARIDR_",TFStartDate:"_TFStartDate
	Set JsonStr=JsonStr_",TFEndDate:"_TFEndDate_",TFDiscRate:"_TFDiscRate
	Set JsonStr=JsonStr_",TFPayorRate:"_TFPayorRate_",TFAlterLevel:"_TFAlterLevel
	Set JsonStr=JsonStr_",TFAlterPayorRate:"_TFAlterPayorRate_",TFRecConDr:"_TFRegFac
	Set JsonStr=JsonStr_",TFUpdateDate:"_TFUpDate_",TFUpdateTime:"_TFUpTime
	Set JsonStr=JsonStr_",TFUpdateUser:"_TFUpUser_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "删除", "D", JsonStr)

    Quit Myrtn
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindCTHospital")
Query FindCTHospital() As websys.Query(ROWSPEC = "THospRowid:%String,THospCode:%String,THospDesc:%String")
{
}

ClassMethod FindCTHospitalExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set HospRowid="", HospCode="", HospDesc="全部"
	Do OutputCTHosp
	Set HospRowid=0
	For  Set HospRowid=$o(^CT("HOSP",HospRowid)) Quit:(HospRowid="")  Do
	.Set HospCode=$p(^CT("HOSP",HospRowid),"^",1)
	.Set HospDesc=$p(^CT("HOSP",HospRowid),"^",2)
	.Set HospCode=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(HospCode)
	.Set HospDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(HospDesc)
	.Do OutputCTHosp
	Quit $$$OK

OutputCTHosp
	Set Data=$lb(HospRowid,HospCode,HospDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).GetTarPara(2)
ClassMethod GetTarPara(HospId As %String)
{
	Set OutputStr=""
	Set rtn=$$OPEN^DHCJFTPA() 
	Do {
		Set rtn=$$FETCH^DHCJFTPA()
	    Do TarPara
	}while(rtn=0)
    Do CLOSE^DHCJFTPA()
    Quit """"_OutputStr_""""
TarPara
	Set ParaRowId=$g(PLIST(1))
	Set Price=$g(PLIST(2))
	Set Price=$Case(Price,"P0":"P0","P1":"P1","P2":"P2",:Price)
	Set Price=$Case(Price,"Price":"P0","AlterPrice1":"P1","AlterPrice2":"P2",:Price)
	Set DefPrice=Price
	Set DefEpiso=$g(PLIST(3))								;默认就诊类型
	Set DefAdmRea=$g(PLIST(4))								;默认收费类别
	Set DefFac=$g(PLIST(5))									;默认折扣方式
	Set DefFac=$Case(DefFac,"Patient":"P","Item":"I","P":"P","I":"I",:DefFac)
	
	Set DefMotherBorn=$g(PLIST(6))							;收费包含新生儿费用
	Set DefLinkInstrPrior=$g(PLIST(7))
	Set DefReBillMode=$g(PLIST(8))							;重新生成账单模式
	Set DefReBillMode=$Case(DefReBillMode,"All Order":"O","Billed Item":"B","O":"O","B":"B",:DefReBillMode)

	Set DefCharge=$g(PLIST(9))								;默认计费方式
	Set DefCharge=$Case(DefCharge,"All Order":"A","Changed Order":"C","A":"A","C":"C",:DefCharge)

	Set Condition=$g(PLIST(10))                             ;默认计费点
	Set Condition=$Case(Condition,"OD":"OD","OE":"OE","NE":"NE","RR":"RR",:Condition)
	Set Condition=$Case(Condition,"CR":"CR","SC":"SC","Order Entry or Discontinued":"OD",:Condition)
	Set Condition=$Case(Condition,"Order Executed":"OE","Nurse Executed":"NE","Result Return":"RR",:Condition)
	Set Condition=$Case(Condition,"Pharmacy Collected or Return":"CR","Specimen Collected":"SC",:Condition)
	Set DefBillCon=Condition
	Set DefOutStandDays=$g(PLIST(11))						;呆账时间
	Set DefPayMode=$$GetPayModeDesc^DHCJFTPA($g(PLIST(12)))	;默认支付方式
	Set DefLabTrakNameSpace=$g(PLIST(13))
	Set DefCashierCloseTime=$g(PLIST(14))					;计算时间
	Set DefAlertDeposit=$g(PLIST(15))						;押金预警线
	Set AgeCalcMode=$g(PLIST(16))                           ;年龄计算方式
	Set myHospDR=$g(PLIST(17))                              ;医院
	Quit:(myHospDR'=HospId)
	Set OutputStr=ParaRowId_"^"_DefPrice_"^"_DefEpiso_"^"_DefAdmRea_"^"_DefFac_"^"_DefMotherBorn
	Set OutputStr=OutputStr_"^"_DefLinkInstrPrior_"^"_DefReBillMode_"^"_DefCharge_"^"_DefBillCon_"^"_DefOutStandDays
	Set OutputStr=OutputStr_"^"_DefPayMode_"^"_DefLabTrakNameSpace_"^"_DefCashierCloseTime_"^"_DefAlertDeposit
	Set OutputStr=OutputStr_"^"_AgeCalcMode
	
	Quit OutputStr
}

/// w ##class(DHCBILLConfig.DHCBILLSysType).UpdatePara("{""ParaRowId"":""8"",""TMDefaultTariff"":""P0"",""TMBillCondition"":""OD"",""TMBillMode"":""C"",""TMDefaultInsType"":""1"",""TMReBillMode"":""O"",""TMDiscountType"":""P"",""TMNewBornToMother"":""Y"",""TMAgeCalcMode"":""Y"",""TMHospDR"":""2""}")
ClassMethod UpdatePara(jsonStr As %String) As %String
{
	Set ^TMP("UpdatePara")=jsonStr
	Set rtn=0
	Set jsonObj=##class(%DynamicAbstractObject).%FromJSON(jsonStr)
	
	Set OldDefPrice="", OldDefEpiso="", OldDefAdmRea="", OldDefFac=""
	Set OldDefMotherBorn="", OldDefReBillMode="", OldDefCharge="", OldDefBillCon=""
	Set OldDefAgeCalc=""
	
	ts
	If (+jsonObj.ParaRowId=0){   //Insert
		Set TarParamObj=##class(User.DHCTarPara).%New()
	}Else{
		Set TarParamObj=##class(User.DHCTarPara).%OpenId(+jsonObj.ParaRowId, 0)
		
		Set OldDefPrice=TarParamObj.TMDefaultTariff
		Set OldDefEpiso=TarParamObj.TMDefaultEpisodeType.%Id()
		Set OldDefAdmRea=TarParamObj.TMDefaultInsType.%Id()
		Set OldDefFac=TarParamObj.TMDiscountType
		Set OldDefMotherBorn=TarParamObj.TMNewBornToMother
		Set OldDefReBillMode=TarParamObj.TMReBillMode
		Set OldDefCharge=TarParamObj.TMBillMode
		Set OldDefBillCon=TarParamObj.TMBillCondition
		Set OldDefAgeCalc=TarParamObj.TMAgeCalcMode
	}
	
	Set TarParamObj.TMDefaultTariff=jsonObj.TMDefaultTariff
	Set DefEpiso=$o(^PAC("SUBT",0,"Code",1,0))
	Do TarParamObj.TMDefaultEpisodeTypeSetObjectId(DefEpiso) //普通病人
	Do TarParamObj.TMDefaultInsTypeSetObjectId(jsonObj.TMDefaultInsType)
	Set TarParamObj.TMDiscountType=jsonObj.TMDiscountType
	Set TarParamObj.TMNewBornToMother=jsonObj.TMNewBornToMother
	Set TarParamObj.TMReBillMode=jsonObj.TMReBillMode
	Set TarParamObj.TMBillMode=jsonObj.TMBillMode
	Set TarParamObj.TMBillCondition=jsonObj.TMBillCondition	
	Set TarParamObj.TMAgeCalcMode=jsonObj.TMAgeCalcMode
	//系统默认
	Do TarParamObj.TMDefaultPayModeSetObjectId($o(^CT("CTPM",0,"Code","CASH","")))
	Set TarParamObj.TMLinkInstrPrior="N"
	Do TarParamObj.TMHospDRSetObjectId(jsonObj.TMHospDR)

	set sc=TarParamObj.%Save()
	if $$$ISERR(sc) {
		tro
		Quit """"_$system.Status.GetErrorCodes(sc)_""""
	}
	tc
	Set ParaRowId=TarParamObj.%Id()
	do TarParamObj.%Close()

	// 记录日志
	Set DefPrice=TarParamObj.TMDefaultTariff
	Set DefAdmRea=TarParamObj.TMDefaultInsType
	Set DefFac=TarParamObj.TMDiscountType
	Set DefMotherBorn=TarParamObj.TMNewBornToMother
	Set DefReBillMode=TarParamObj.TMReBillMode
	Set DefCharge=TarParamObj.TMBillMode
	Set DefBillCon=TarParamObj.TMBillCondition	
	Set DefAgeCalc=TarParamObj.TMAgeCalcMode

	If (rtn=0) Do
	.Set Flag2="DHC_TarPara",UserTable="User.DHCTarPara", TableDesc="系统参数配置表", InsRowid=ParaRowId
	.Set JsonStr="{TMRowId:"_InsRowid_",TMDefaultTariff:"_DefPrice_",TMDefaultEpisodeType:"_DefEpiso
	.Set JsonStr=JsonStr_",TMDefaultInsType:"_DefAdmRea_",TMDiscountType:"_DefFac
	.Set JsonStr=JsonStr_",TMNewBornToMother:"_DefMotherBorn_",TMReBillMode:"_DefReBillMode
	.Set JsonStr=JsonStr_",TMBillMode:"_DefCharge_",TMBillCondition:"_DefBillCon
	.Set JsonStr=JsonStr_",TMAgeCalcMode:"_DefAgeCalc_"}"
	.Set JsonStrOld="{TMRowId:"_InsRowid_",TMDefaultTariff:"_OldDefPrice_",TMDefaultEpisodeType:"_OldDefEpiso
	.Set JsonStrOld=JsonStrOld_",TMDefaultInsType:"_OldDefAdmRea_",TMDiscountType:"_OldDefFac
	.Set JsonStrOld=JsonStrOld_",TMNewBornToMother:"_OldDefMotherBorn_",TMReBillMode:"_OldDefReBillMode
	.Set JsonStrOld=JsonStrOld_",TMBillMode:"_OldDefCharge_",TMBillCondition:"_OldDefBillCon
	.Set JsonStrOld=JsonStrOld_",TMAgeCalcMode:"_OldDefAgeCalc_"}"
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)
	
	Quit """"_rtn_""""
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLSysType","FindRegFactor",2)
Query FindRegFactor(HospId As %String) As websys.Query(ROWSPEC = "RCDRowID:%String,RCDCode:%String,RCDDesc:%String")
{
}

ClassMethod FindRegFactorExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
	Set RCDRowID=0
	While($o(^DHCRCD(RCDRowID))) {
		Set RCDRowID=$o(^DHCRCD(RCDRowID))
		Set RCDHospDR=$p($g(^DHCRCD(RCDRowID)),"^",18)
		Continue:(RCDHospDR'=HospId)
		Set RCDCode=$p(^DHCRCD(RCDRowID),"^",1)
		Set RCDDesc=$p(^DHCRCD(RCDRowID),"^",2)
		Do OutputRegFac
	}
	Quit $$$OK

OutputRegFac
	Set Data=$lb(RCDRowID,RCDCode,RCDDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// CateDr:子表主map中global节点
/// w ##class(DHCBILLConfig.DHCBILLSysType).GetTarCateBySubCate("7","SC")
ClassMethod GetTarCateBySubCate(TarSubCateDr As %String, CateDr As %String)
{
    New (TarSubCateDr, CateDr)
   	Quit:(TarSubCateDr="") ""
   	Set TarCateRowid=$p(^DHCTarC(CateDr,TarSubCateDr),"^",3)
   	Quit TarCateRowid
}

/// CateDr  子表主map中global节点
/// w ##class(DHCBILLConfig.DHCBILLSysType).GetTarCateByTarRowid("7","SC")
ClassMethod GetTarCateByTarRowid(TarRowid As %String, CateDr As %String)
{
    New (TarRowid, CateDr)
   	Quit:(TarRowid="") ""
   	Set TarSubCateDr=""
   	If (CateDr="SC") Set TarSubCateDr=$p(^DHCTARI(TarRowid),"^",4)
   	If (CateDr="AC") Set TarSubCateDr=$p(^DHCTARI(TarRowid),"^",5)
   	If (CateDr="MC") Set TarSubCateDr=$p(^DHCTARI(TarRowid),"^",6)
   	If (CateDr="IC") Set TarSubCateDr=$p(^DHCTARI(TarRowid),"^",14)
   	If (CateDr="OC") Set TarSubCateDr=$p(^DHCTARI(TarRowid),"^",15)
   	If (CateDr="EC") Set TarSubCateDr=$p(^DHCTARI(TarRowid),"^",16)
   	If (CateDr="MCNew") Set TarSubCateDr=$p(^DHCTARI(TarRowid),"^",30)
   	Set TarCateRowid=##class(DHCBILLConfig.DHCBILLSysType).GetTarCateBySubCate(TarSubCateDr, CateDr)
   	Quit TarCateRowid_"^"_TarSubCateDr
}

/// For 北京中日医院北区 其他项目不使用
/// w ##class(DHCBILLConfig.DHCBILLSysType).GetTarCat("","45","","AC","TAC","TAC")
ClassMethod GetTarCat(Rowid As %String, Code As %String, Desc As %String, CateDr1 As %String, CateDr2 As %String, CateDr3 As %String)
{
	If (Rowid'="") Do
	.Set Code=$p(^DHCTarC("SC",Rowid),"^",1)
	If (Desc'="") Do
	.Set Rowid=$o(^DHCTarC("SC",0,"Desc",Desc,0))
	.Quit:(Rowid="")
	.Set Code=$p(^DHCTarC("SC",Rowid),"^",1)
	Quit:(Code="") """"_""""
	
	Set NewRowid="", NewDesc="", NewCode=""
	Set rs=##Class(%ResultSet).%New("DHCBILLConfig.DHCBILLSysType:FindTarSubCate")
	If rs.QueryIsValid() { 
		Set Status=rs.Execute("", "", "", CateDr1, CateDr2, CateDr3)
		Set columns=rs.GetColumnCount()
		While rs.Next() {
			Set NewCode=rs.GetDataByName("code")
			If (Code=NewCode) {
				Set NewRowid=rs.GetDataByName("rowid")
				Set NewDesc=rs.GetDataByName("desc")
			}
		}
	}
	
	If (NewRowid="") Set NewRowid=""""_""""
	Quit NewRowid
}

ClassMethod SaveLogForOther(TableName As %String, ClassName As %String, ClassNameDesc As %String, ObjectReference As %String, ObjectDesc As %String, OperateType As %String, NewValue As %String, OldValue As %String = "")
{
	Set NewValue=..WriteEXTJson(NewValue)
	Set OldValue=..WriteEXTJson(OldValue)
	Do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(TableName, ClassName, ClassNameDesc, ObjectReference, ObjectDesc, OperateType, NewValue, OldValue)
	Quit
}

ClassMethod WriteEXTJson(JsonStr)
{
	Quit:(JsonStr="") JsonStr
	Set JsonStr=$replace(JsonStr,":",":""")
	Set JsonStr=$replace(JsonStr,",",""",")
	Set JsonStr=$replace(JsonStr,"}","""}")
	Quit JsonStr
}

ClassMethod WritejQueryJson(JsonStr)
{
	Quit:JsonStr="" JsonStr
	Set JsonStr=$replace(JsonStr,":",":""")
	Set JsonStr=$replace(JsonStr,",",""",")
	Set JsonStr=$replace(JsonStr,"}","""}")
	Set JsonStr=$replace(JsonStr,":",""":")
	Set JsonStr=$replace(JsonStr,"{","{""")
	Quit JsonStr
}

ClassMethod test123()
{
	s obj=##class(ext.util.JsonObject).%New()
	s pm=##class(User.DHCTarItem).%OpenId(10, 0)
	w obj.FromObject(pm).Json(),!
	q
}

/// Creator: ZhYW
/// CreatDate: 2018-03-02
/// Description: 判断医嘱子类是否都是药品和材料
/// Input: 医嘱子类RowId串
/// Return: =0:是, <>0:否
/// Debug: w ##class(DHCBILLConfig.DHCBILLSysType).CheckContainDrugByArcGrp()
ClassMethod CheckContainDrugByArcGrp(arcGrpDRStr As %String) As %String [ ProcedureBlock = 1 ]
{
	set rtn=0
	quit:(arcGrpDRStr="") rtn
	
	set count=$l(arcGrpDRStr,",")
	for i=1:1:count {
		set arcGrpDR=$p(arcGrpDRStr,",",i)
		continue:(+arcGrpDR=0)
		set ordCateType=$p($g(^ARC("IC",arcGrpDR)),"^",7)
		if (ordCateType'="R") {
			set rtn=1
			quit
		}
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-11-21
/// Description: 获取住院业务配置参数
/// Input: hospId: CT_Hospital.HOSP_RowId
/// Return: CF_BILL_IP.Param 表数据
/// Debug: w ##class(DHCBILLConfig.DHCBILLSysType).GetIPParamConfig(2)
ClassMethod GetIPParamConfig(hospId As %String) As %String [ ProcedureBlock = 1 ]
{
	set rowId=""
	set id=0
	while($o(^CF.BILL.IP.Param(id))) {
		set id=$o(^CF.BILL.IP.Param(id))
		set data=$g(^CF.BILL.IP.Param(id))
		continue:(data="")
		set hospDR=$p(data,"^",23)
		continue:(hospDR'=hospId)
		set rowId=id
		quit
	}
	set jsonStr=##class(web.DHCBillCommon).GetClsPropValById("CF.BILL.IP.Param", rowId)

	quit jsonStr
}

/// Creator: ZhYW
/// CreatDate: 2019-11-21
/// Description: 保存住院业务配置参数
/// Input: 
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(DHCBILLConfig.DHCBILLSysType).SaveIPParamConf(^TMP("SaveIPParamConf"))
ClassMethod SaveIPParamConf(jsonStr As %String) As %String [ ProcedureBlock = 1 ]
{
	set ^TMP("SaveIPParamConf")=jsonStr
	
	set EnablePMASystem=##class(BILL.Interface.Inside.AuthItemApply).GetEnablePMASystem()
	
	set jsonObj=##class(%DynamicObject).%FromJSON(jsonStr)
	set oldData="{}"
	
	if (+jsonObj.ID'=0) {
		set oldData=##class(web.DHCBillCommon).GetClsPropValById("CF.BILL.IP.Param", jsonObj.ID)
		set dataObj=##class(CF.BILL.IP.Param).%OpenId(jsonObj.ID, 0)
	}else {
		set dataObj=##class(CF.BILL.IP.Param).%New()
	}
	if ('$isObject(dataObj)) {
		do dataObj.%Close()
		quit -1_"^"_"对象不存在"
	}
	
	set rtn=0
	ts
	
	set dataObj.RegLnkPayDep=jsonObj.RegLnkPayDep
	//set dataObj.AbortDepRenewPrint=jsonObj.AbortDepRenewPrint
	set dataObj.MultiPrintInv=jsonObj.MultiPrintInv
	//set dataObj.AbortInvRenewPrint=jsonObj.AbortInvRenewPrint
	set dataObj.AccountFromDate=##class(websys.Conversions).DateHtmlToLogical(jsonObj.AccountFromDate)
	do dataObj.HospitalDRSetObjectId(jsonObj.HospitalDR)
	do dataObj.IntArcimDRSetObjectId(jsonObj.IntArcimDR)
	if ('EnablePMASystem) {
		do ##class(BILL.Interface.Inside.AuthItemApply).SetIPParamCfgDTO(.dataObj, jsonObj)
	}
	set sc=dataObj.%Save()
	do dataObj.%Close()
	set dataId=dataObj.%Id()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorText(sc)_"^"_$system.Status.GetErrorCodes(sc)
	}
	
	if ($tl>0) tc
	
	//调用数据平台组接口留痕
	set className="CF.BILL.IP.Param"
	set tableName=$g(^oddCOM(className,53))
	set classNameDesc="住院参数配置表"
	set newData=##class(web.DHCBillCommon).GetClsPropValById("CF.BILL.IP.Param", dataId)
	if (+jsonObj.ID'=0) {
		do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName, className, classNameDesc, dataId, "修改", "U", newData, oldData)
	}else {
		do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName, className, classNameDesc, dataId, "插入", "A", newData)
	}
	
	if (EnablePMASystem) {
		//+2023-03-28 ZhYW 向权力系统发送审批申请
		set appJson=##class(%DynamicObject).%New()
		set appJson.ID=dataId
		do ##class(BILL.Interface.Inside.AuthItemApply).SetIPParamCfgDTO(.appJson, jsonObj)
		set rtn=##class(BILL.Interface.Inside.AuthItemApply).SaveIPParamCfgApply(appJson.%ToJSON())   //向权力系统发送申请
	}
	
	quit rtn
}

}
