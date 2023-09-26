Import SQLUSER

/// Creator: TangTao
/// CreateDate:	2013-01-13
/// Function: 查询收费项明细
Class DHCBILLConfig.DHCBILLFIND Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindTarItem","ffsy","","2")
Query FindTarItem(alias As %String, str As %String, HospID As %String, LangId As %String = "") As websys.Query(ROWSPEC = "rowid:%String,code:%String,desc:%String,TarUomDesc:%String,TarPrice:%Float,TarActiveFlag:%String,TarSubCateDesc:%String,TarAcctCateDesc:%String,TarInpatCateDesc:%String,TarOutpatCateDesc:%String,TarEMCCateDesc:%String,TarMRCateDesc:%String,TarNewMRCateDesc:%String,TarSpecialFlag:%String,TarExternalCode:%String,TarChargeBasis:%String,TarInsuIPName:%String,TarInsuOPName:%String,TarEngName:%String,SubCate:%String,AccCate:%String,IcCate:%String,OcCate:%String,EcCate:%String,MrCate:%String,NewMrCate:%String,TCreateUser:%String,TCreateDate:%String,TCreateTime:%String")
{
}

ClassMethod FindTarItemExecute(ByRef qHandle As %Binary, alias As %String, str As %String, HospID As %String, LangId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set ^TMP("FindTarItem")=$lb(alias, str, HospID)
    Set subCateStr=$p(str,$c(2),1)   //子类串
    Set cateStr=$p(str,$c(2),2)      //大类串
    Set tarCate=$p(cateStr,"^",1)    //收费项目大类
	kill %TarItmAry
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	//按别名查询
	Do open^DHCJFFIND("", "", alias, subCateStr, HospID, "")
	Do {
		Set rtn=$$fetch^DHCJFFIND("", "", alias, subCateStr, HospID, "")
	    Do GetTariInfo()
	}While(rtn=0)
	//按代码查询
	Do open^DHCJFFIND(alias, "", "", subCateStr, HospID, "")
	Do {
		Set rtn=$$fetch^DHCJFFIND(alias, "", "", subCateStr, HospID, "")
	    Do GetTariInfo()
	}While(rtn=0)
	//按名称查询
	Do open^DHCJFFIND("", alias, "", subCateStr, HospID, "")
	Do {
		Set rtn=$$fetch^DHCJFFIND("", alias, "", subCateStr, HospID, "")
	    Do GetTariInfo()
	}While(rtn=0)
	
    Do close^DHCJFFIND()
	Quit $$$OK
GetTariInfo()
	Set (code1,desc1,TarUomDesc,TarPrice,TarActiveFlag,TarSubCateDesc,TarAcctCateDesc,TarInpatCateDesc,TarOutpatCateDesc,TarEMCCateDesc,TarMRCateDesc,TarNewMRCateDesc,TarSpecialFlag,TarExternalCode,TarChargeBasis,TarInsuIPName,TarInsuOPName,TarEngName,rowid,SubCate,AccCate,IcCate,OcCate,EcCate,MrCate,NewMrCate)=""
	Quit:'$d(PLIST)
	Set code1=PLIST(1)
	Set desc1=PLIST(2)
	Set desc1=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", desc1, LangId)
	Set TarUomDesc=PLIST(3)
	Set TarPrice=PLIST(4)
	Set TarActiveFlag=PLIST(12)
	Set TarSubCateDesc=PLIST(5)
	Set TarAcctCateDesc=PLIST(6)
	Set TarInpatCateDesc=PLIST(7)
	Set TarOutpatCateDesc=PLIST(8)
	Set TarEMCCateDesc=PLIST(9)
	Set TarMRCateDesc=PLIST(10)
	Set TarNewMRCateDesc=PLIST(20)
	Set TarSpecialFlag=PLIST(11)
	Set TarExternalCode=PLIST(13)
	Set TarChargeBasis=PLIST(16)
	Set TarInsuIPName=PLIST(18)
	Set TarInsuOPName=PLIST(19)
	Set TarEngName=PLIST(17)
	Set rowId=PLIST(14)
	Quit:($d(%TarItmAry(rowId)))
	Set %TarItmAry(rowId)=""
	Set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarItem", rowId, HospID)
	Quit:(ShowFlag="N")
	
	Set SubCate=$s((TarSubCateDesc'=""):$o(^DHCTarC("SC",0,"Desc",TarSubCateDesc,"")),1:"")
	Set myTarCate=$s((+SubCate'=0):$p($g(^DHCTarC("SC",SubCate)),"^",3))
	Quit:((tarCate'="")&&(tarCate'=myTarCate))
	Set AccCate=$s((TarAcctCateDesc'=""):$o(^DHCTarC("AC",0,"Desc",TarAcctCateDesc,"")),1:"")
	Set IcCate=$s((TarInpatCateDesc'=""):$o(^DHCTarC("IC",0,"Desc",TarInpatCateDesc,"")),1:"")
	Set OcCate=$s((TarOutpatCateDesc'=""):$o(^DHCTarC("OC",0,"Desc",TarOutpatCateDesc,"")),1:"")
	Set EcCate=$s((TarEMCCateDesc'=""):$o(^DHCTarC("EC",0,"Desc",TarEMCCateDesc,"")),1:"")
	Set MrCate=$s((TarMRCateDesc'=""):$o(^DHCTarC("MC",0,"Desc",TarMRCateDesc,"")),1:"")
	//新病案首页子分类
	Set NewMrCate=$s((TarNewMRCateDesc'=""):$o(^DHCTARMRCATENEW(0,"Desc",TarNewMRCateDesc,"")),1:"")
	
	Set TarItmData=$g(^DHCTARI(rowId))	
	Set TRAIActiveFlag=$p(TarItmData,"^",7)
	Quit:(TRAIActiveFlag="N")
	Set TARIStartDate=$p(TarItmData,"^",11)
	Set TARIEndDate=$p(TarItmData,"^",12)
	Quit:((TARIStartDate'="")&&(TARIStartDate>+$h))
	Quit:((TARIEndDate'="")&&(TARIEndDate<+$h))
	Set CreateUser=$p(TarItmData,"^",21)
	Set CreateUser=$s((CreateUser'=""):$p(^SSU("SSUSR",CreateUser),"^",2),1:"")
	Set CreateDate=$p(TarItmData,"^",22)
	Set CreateDate=##class(websys.Conversions).DateLogicalToHtml(CreateDate)
	Set CreateTime=$p(TarItmData,"^",23)
	Set CreateTime=##class(websys.Conversions).TimeLogicalToHtml(CreateTime)

	/*
	Set code1=..TR(code1)
	Set desc1=..TR(desc1)
	Set TarExternalCode=..TR(TarExternalCode)
	Set TarChargeBasis=..TR(TarChargeBasis)
	Set TarInsuIPName=..TR(TarInsuIPName)
	Set TarInsuOPName=..TR(TarInsuOPName)
	Set TarEngName=..TR(TarEngName)

	Set code1=..EvalJSON(code1)	
	Set desc1=..EvalJSON(desc1)	
	Set TarExternalCode=..EvalJSON(TarExternalCode)	
	Set TarChargeBasis=..EvalJSON(TarChargeBasis)	
	Set TarInsuIPName=..EvalJSON(TarInsuIPName)
	Set TarInsuOPName=..EvalJSON(TarInsuOPName)
	Set TarEngName=..EvalJSON(TarEngName)
	*/
	
	Do OutputTarItem
	Quit
OutputTarItem
	Set Data=$lb(rowId,code1,desc1,TarUomDesc,TarPrice,TarActiveFlag,TarSubCateDesc,TarAcctCateDesc,TarInpatCateDesc,TarOutpatCateDesc,TarEMCCateDesc,TarMRCateDesc,TarNewMRCateDesc,TarSpecialFlag,TarExternalCode,TarChargeBasis,TarInsuIPName,TarInsuOPName,TarEngName,SubCate,AccCate,IcCate,OcCate,EcCate,MrCate,NewMrCate,CreateUser,CreateDate,CreateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 2013-01-12
/// tangtao
/// 处理数据的不可见字符，ASCii表中前33位是不可见字符
/// Ext 前台在处理含不可见字符的json数据时处理不了，查询不会显示数据，不会报错。
ClassMethod TR(Info)
{
	Quit:(Info="") ""
	For i=0:1:32 Do
	.Set Info=$tr(Info,$c(i),"")
	.For j=0:1:32 Do
	..Set Info=$tr(Info,$c(i,j),"")
	
	Quit Info
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindTarPrice",867,2,1)
Query FindTarPrice(TarRowid, HospID, Guser) As websys.Query(ROWSPEC = "TPRowId:%String,TPStartDate:%String,TPEndDate:%String,TPPrice:%String,TPLimitedPrice:%String,TPPayorRate:%String,TPUpdateUser:%String,TPUpdateDate:%String,TPUpdateTime:%String,TPAdjustNo:%String,TPDiscRate:%String,TPPatInsType:%String,TPAlterPrice1:%String,TPAlterPrice2:%String,TPHospitalDR:%String")
{
}

ClassMethod FindTarPriceExecute(ByRef qHandle As %Binary, TarRowid, HospID, Guser) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	If (TarRowid="")  Quit $$$OK
	Do OPEN^DHCJFTITMP(TarRowid,HospID)
	Do{
		Set rtn=$$FETCH^DHCJFTITMP(TarRowid,HospID)
	    Do GetTariPrice
	}While(rtn=0)
    Do CLOSE^DHCJFTITMP()

	Quit $$$OK
GetTariPrice
	Set (TPTARIParRef, TPRowId, TPChildSub, TPStartDate, TPEndDate, TPPrice)=""
	Set (TPLimitedPrice, TPPayorRate, TPUpdateUser, TPUpdateDate, TPUpdateTime)=""
	Set (TPAdjustNo, TPDiscRate, TPPatInsType, TPAlterPrice1, TPAlterPrice2, TPHospitalDR)=""
	Quit:'$d(PLIST)
	Set TPRowId=PLIST(1)
	Set TPStartDate=PLIST(3)
	Set TPEndDate=PLIST(4)
	Set TPPrice=PLIST(5)
	Set TPPrice=$fn(TPPrice,"N")
	Set TPLimitedPrice=PLIST(6)
	Set TPLimitedPrice=$fn(TPLimitedPrice,"N")
	Set TPPayorRate=PLIST(7)
	Set TPUpdateUser=PLIST(8)
	Set TPUpdateDate=PLIST(9)
	Set TPUpdateTime=PLIST(10)
	Set TPAdjustNo=PLIST(11)
	Set TPDiscRate=PLIST(12)
	Set TPPatInsType=PLIST(13)
	Set TPPatInsType=$s((+TPPatInsType'=0):$p($g(^PAC("ADMREA",TPPatInsType)),"^",2),1:"")
	Set TPAlterPrice1=PLIST(14)
	Set TPAlterPrice2=PLIST(15)
	Set TPHospitalDR=PLIST(16)
	Do OutputTarPrice
	Quit
OutputTarPrice
	set Data=$lb(TPRowId,TPStartDate,TPEndDate,TPPrice,TPLimitedPrice,TPPayorRate,TPUpdateUser,TPUpdateDate,TPUpdateTime,TPAdjustNo,TPDiscRate,TPPatInsType,TPAlterPrice1,TPAlterPrice2,TPHospitalDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindUniom")
Query FindUniom() As websys.Query(ROWSPEC = "Rowid:%String,UOMDesc:%String")
{
}

ClassMethod FindUniomExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    Set Rowid=0
	For  Set Rowid=$o(^CT("UOM",Rowid)) Quit:(Rowid="")  Do
	.Set UOMDesc=$p(^CT("UOM",Rowid),"^",2)
	.Set UOMDesc=..TR(UOMDesc)
	.Set UOMDesc=..EvalJSON(UOMDesc)
	.Do OutputUniom
    
	quit $$$OK
OutputUniom
	set Data=$lb(Rowid,UOMDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// w ##class(DHCBILLConfig.DHCBILLFIND).GetTarItem(5015)
ClassMethod GetTarItem(TarRowid)
{
	New (TarRowid)
	Quit:(TarRowid="") ""
	Set TarInfo=^DHCTARI(TarRowid)
	Set TarCode=$p(TarInfo,"^",1)
	Set TarDesc=$p(TarInfo,"^",2)
	Set TarUom=$p(TarInfo,"^",3)
	Set TarSubCate=$p(TarInfo,"^",4)
	Set TarAccCate=$p(TarInfo,"^",5)
	Set TarMrCate=$p(TarInfo,"^",6)
	Set TarActFlag=$p(TarInfo,"^",7)
	Set TarStdate=$p(TarInfo,"^",11)
	Set TarEndDate=$p(TarInfo,"^",12)
	Set TarExtCode=$p(TarInfo,"^",13)
	Set TarInpatCate=$p(TarInfo,"^",14)
	Set TarOutpatCate=$p(TarInfo,"^",15)
	Set TarEmcCate=$p(TarInfo,"^",16)
	Set TarSpecialFlag=$p(TarInfo,"^",17)
	Set TarInsuName=$p(TarInfo,"^",18) 
	Set TarEngName=$p(TarInfo,"^",19) 
	Set TarChargeBasis=$p(TarInfo,"^",20)
	Set TarNewMrCate=$p(TarInfo,"^",30)
	
	Set (TarUomDesc,TarSubCateDesc,TarAccCateDesc,TarMrCateDesc)=""
	Set (TarInpatCateDesc,TarOutpatCateDesc,TarEmcCateDesc,TarNewMrCateDesc)=""
	If (TarUom'="") Set TarUomDesc=$p(^CT("UOM",TarUom),"^",2)
	If (TarSubCate'="") Set TarSubCateDesc=$p(^DHCTarC("SC",TarSubCate),"^",2)
	If (TarAccCate'="") Set TarAccCateDesc=$p(^DHCTarC("AC",TarAccCate),"^",2)
	If (TarMrCate'="") Set TarMrCateDesc=$p(^DHCTarC("MC",TarMrCate),"^",2)
	If (TarInpatCate'="") Set TarInpatCateDesc=$p(^DHCTarC("IC",TarInpatCate),"^",2)
	If (TarOutpatCate'="") Set TarOutpatCateDesc=$p(^DHCTarC("OC",TarOutpatCate),"^",2)
	If (TarEmcCate'="") Set TarEmcCateDesc=$p(^DHCTarC("EC",TarEmcCate),"^",2)
	If (TarNewMrCate'="") Set TarNewMrCateDesc=$p(^DHCTarC("MCNew",TarNewMrCate),"^",2)

	If TarStdate'="" Set TarStdate=$zd(TarStdate,3)
	If TarEndDate'="" Set TarStdate=$zd(TarEndDate,3)
	
	; 北京老年医院新加
	Set TarExpRowid=$o(^DHCTARIEXPINFO(0,"TARI",TarRowid,0))
	Set (TarExpYJPTBM)=""
	If (TarExpRowid'="") Do
	.Set TarExpYJPTBM=$p(^DHCTARIEXPINFO(TarExpRowid),"^",33)

	Set TarCode=..TR(TarCode)
	Set TarDesc=..TR(TarDesc)
	Set TarInsuName=..TR(TarInsuName)
	Set TarEngName=..TR(TarEngName)
	Set TarChargeBasis=..TR(TarChargeBasis)
	Set TarCode=..EvalJSON(TarCode)	
	Set TarDesc=..EvalJSON(TarDesc)	
	Set TarInsuName=..EvalJSON(TarInsuName)	
	Set TarEngName=..EvalJSON(TarEngName)	
	Set TarChargeBasis=..EvalJSON(TarChargeBasis)	

	Set Output=TarCode_"^"_TarDesc_"^"_TarUom_"^"_TarUomDesc_"^"_TarSubCate_"^"_TarSubCateDesc ;1-6
	Set Output=Output_"^"_TarAccCate_"^"_TarAccCateDesc_"^"_TarMrCate_"^"_TarMrCateDesc_"^"_TarActFlag ;7-11
	Set Output=Output_"^"_TarStdate_"^"_TarEndDate_"^"_TarExtCode_"^"_TarInpatCate_"^"_TarInpatCateDesc ;12-16
	Set Output=Output_"^"_TarOutpatCate_"^"_TarOutpatCateDesc_"^"_TarEmcCate_"^"_TarEmcCateDesc_"^"_TarSpecialFlag_"^"_TarInsuName	;17-22
	Set Output=Output_"^"_TarEngName_"^"_TarChargeBasis_"^"_TarNewMrCate_"^"_TarNewMrCateDesc	;23-26
	Set Output=Output_"^"_TarExpYJPTBM_"^"_TarExpRowid 	;27-28
	
	;返回值这里不能修改格式，""""，json串需要返回双引号
	Quit """"_Output_""""
}

/// w ##class(DHCBILLConfig.DHCBILLFIND).GetTarItemForCls(5015)
ClassMethod GetTarItemForCls(TarRowid)
{
	New (TarRowid)
	Quit:TarRowid="" ""
	Set TarInfo=^DHCTARI(TarRowid)
	Set TarCode=$p(TarInfo,"^",1)
	Set TarDesc=$p(TarInfo,"^",2)
	Set TarUom=$p(TarInfo,"^",3)
	Set TarSubCate=$p(TarInfo,"^",4)
	Set TarAccCate=$p(TarInfo,"^",5)
	Set TarMrCate=$p(TarInfo,"^",6)
	Set TarActFlag=$p(TarInfo,"^",7)
	Set TarStdate=$p(TarInfo,"^",11)
	Set TarEndDate=$p(TarInfo,"^",12)
	Set TarExtCode=$p(TarInfo,"^",13)
	Set TarInpatCate=$p(TarInfo,"^",14)
	Set TarOutpatCate=$p(TarInfo,"^",15)
	Set TarEmcCate=$p(TarInfo,"^",16)
	Set TarSpecialFlag=$p(TarInfo,"^",17)
	Set TarInsuName=$p(TarInfo,"^",18) 
	Set TarEngName=$p(TarInfo,"^",19) 
	Set TarChargeBasis=$p(TarInfo,"^",20)
	Set TarNewMrCate=$p(TarInfo,"^",30)
	
	Set (TarUomDesc,TarSubCateDesc,TarAccCateDesc,TarMrCateDesc)=""
	Set (TarInpatCateDesc,TarOutpatCateDesc,TarEmcCateDesc,TarNewMrCateDesc)=""
	If TarUom'="" Set TarUomDesc=$p(^CT("UOM",TarUom),"^",2)
	If TarSubCate'="" Set TarSubCateDesc=$p(^DHCTarC("SC",TarSubCate),"^",2)
	If TarAccCate'="" Set TarAccCateDesc=$p(^DHCTarC("AC",TarAccCate),"^",2)
	If TarMrCate'="" Set TarMrCateDesc=$p(^DHCTarC("MC",TarMrCate),"^",2)
	If TarInpatCate'="" Set TarInpatCateDesc=$p(^DHCTarC("IC",TarInpatCate),"^",2)
	If TarOutpatCate'="" Set TarOutpatCateDesc=$p(^DHCTarC("OC",TarOutpatCate),"^",2)
	If TarEmcCate'="" Set TarEmcCateDesc=$p(^DHCTarC("EC",TarEmcCate),"^",2)
	If TarNewMrCate'="" Set TarNewMrCateDesc=$p(^DHCTarC("MCNew",TarNewMrCate),"^",2)

	If TarStdate'="" Set TarStdate=$zd(TarStdate,3)
	If TarEndDate'="" Set TarStdate=$zd(TarEndDate,3)
	
	; 北京老年医院新加
	Set TarExpRowid=$o(^DHCTARIEXPINFO(0,"TARI",TarRowid,0))
	Set (TarExpYJPTBM)=""
	If TarExpRowid'="" Do
	.Set TarExpYJPTBM=$p(^DHCTARIEXPINFO(TarExpRowid),"^",33)

	Set Output=TarCode_"^"_TarDesc_"^"_TarUom_"^"_TarUomDesc_"^"_TarSubCate_"^"_TarSubCateDesc ;1-6
	Set Output=Output_"^"_TarAccCate_"^"_TarAccCateDesc_"^"_TarMrCate_"^"_TarMrCateDesc_"^"_TarActFlag ;7-11
	Set Output=Output_"^"_TarStdate_"^"_TarEndDate_"^"_TarExtCode_"^"_TarInpatCate_"^"_TarInpatCateDesc ;12-16
	Set Output=Output_"^"_TarOutpatCate_"^"_TarOutpatCateDesc_"^"_TarEmcCate_"^"_TarEmcCateDesc_"^"_TarSpecialFlag_"^"_TarInsuName	;17-22
	Set Output=Output_"^"_TarEngName_"^"_TarChargeBasis_"^"_TarNewMrCate_"^"_TarNewMrCateDesc	;23-26
	Set Output=Output_"^"_TarExpYJPTBM_"^"_TarExpRowid 	;27-28
	
	;返回值这里不能修改格式，""""，json串需要返回双引号
	Quit """"_Output_""""
}

/// w ##class(DHCBILLConfig.DHCBILLFIND).UpdateTarInfo($P(^TMP("tt"),"%",1),$P(^TMP("tt"),"%",2),$P(^TMP("tt"),"%",3))
ClassMethod UpdateTarInfo(TarInfo, UserRowid, ExpStr)
{
	Set ^TMP("UpdateTarInfo")=TarInfo_"%"_UserRowid_"%"_ExpStr

	Set TarRowid=$p(TarInfo,"^",1)
	Set NewTarCode=$p(TarInfo,"^",2)
	Quit:NewTarCode="" """"_"代码错误^"_""""
	Set NewTarDesc=$p(TarInfo,"^",3)
	Quit:NewTarDesc="" """"_"名称错误^"_""""
	Set NewTarInsuname=$p(TarInfo,"^",4)
	Set NewTarUniom=$p(TarInfo,"^",5)
	Quit:NewTarUniom="" """"_"单位错误^"_""""
	Set NewTarExternalCode=$p(TarInfo,"^",6)
	Set NewTarActiveFlag=$p(TarInfo,"^",7)
	;If NewTarActiveFlag="true" Set NewTarActiveFlag="Y"
	;Else  Set NewTarActiveFlag="N"
	Set NewTarEngName=$p(TarInfo,"^",8)
	Set NewTarSpecialFlag=$p(TarInfo,"^",9)
	;If NewTarSpecialFlag="true" Set NewTarSpecialFlag="Y"
	;Else  Set NewTarSpecialFlag="N"
	Set NewTarChargeBasis=$p(TarInfo,"^",10)
	Set NewTarIPCate=$p(TarInfo,"^",11)
	Set NewTarOPCate=$p(TarInfo,"^",12)
	Set NewTarEMCCate=$p(TarInfo,"^",13)
	Set NewTarMRCate=$p(TarInfo,"^",14)
	Set NewTarNMRCate=$p(TarInfo,"^",15)
	Set NewTarACCate=$p(TarInfo,"^",16)
	Set NewTarSCCate=$p(TarInfo,"^",17)
	Set NewAvailDateTime=$p(TarInfo,"^",18)
	Set NewExpirationDateTime=$p(TarInfo,"^",19)
	Set NewTarExpYJPTBM=$p(TarInfo,"^",20)
	;Quit:NewTarIPCate="" """"_"住院费用子类错误^"_""""
	;Quit:NewTarOPCate="" """"_"门诊费用子类错误^"_""""
	;Quit:NewTarEMCCate="" """"_"经济核算子类错误^"_""""
	;Quit:NewTarMRCate="" """"_"旧病案首页子类错误^"_""""
	;Quit:NewTarNMRCate="" """"_"新病案首页子类错误^"_""""
	;Quit:NewTarACCate="" """"_"收费会计子类错误^"_""""
	;Quit:NewTarSCCate="" """"_"收费项目子类错误^"_""""
	If ((NewTarIPCate="")!(NewTarOPCate="")!(NewTarEMCCate="")!(NewTarMRCate="")!(NewTarNMRCate="")!(NewTarACCate="")!(NewTarSCCate="")) Do
	.Set NewTarActiveFlag="N" ; 分类有为空的置成无效
	Set NewAvailDateTime1=$tr($tr($tr(NewAvailDateTime," "),"-"),":")
	Set NewExpirationDateTime1=$tr($tr($tr(NewExpirationDateTime," "),"-"),":")
	Quit:((NewAvailDateTime1'="")&(NewExpirationDateTime1'="")&(NewAvailDateTime1>NewExpirationDateTime1)) """"_"生效日期不能大于失效日期^"_""""
	; 旧收费项信息
	Set OldInfo=..GetTarItemForCls(TarRowid)
	Set OldInfo=$tr(OldInfo,"""","")
	Set OldTarCode=$p(OldInfo,"^",1)
	Set OldTarDesc=$p(OldInfo,"^",2)
	Set OldTarInsuname=$p(OldInfo,"^",22)
	Set OldTarUniom=$p(OldInfo,"^",3)
	Set OldTarExternalCode=$p(OldInfo,"^",14)
	Set OldTarActiveFlag=$p(OldInfo,"^",11)
	Set OldTarEngName=$p(OldInfo,"^",23)
	Set OldTarSpecialFlag=$p(OldInfo,"^",21)
	Set OldTarChargeBasis=$p(OldInfo,"^",24)
	Set OldTarIPCate=$p(OldInfo,"^",15)
	Set OldTarOPCate=$p(OldInfo,"^",17)
	Set OldTarEMCCate=$p(OldInfo,"^",19)
	Set OldTarMRCate=$p(OldInfo,"^",9)
	Set OldTarNMRCate=$p(OldInfo,"^",25)
	Set OldTarACCate=$p(OldInfo,"^",7)
	Set OldTarSCCate=$p(OldInfo,"^",5)
	Set OldTarStDate=$p(OldInfo,"^",12)
	Set OldTarExpYJPTBM=$p(OldInfo,"^",27)
	Set TarExpRowid=$p(OldInfo,"^",28)
	
	Set UpdFlag=0
	If (NewTarCode'=OldTarCode) Set UpdFlag=UpdFlag_"^"_1
	If (NewTarDesc'=OldTarDesc) Set UpdFlag=UpdFlag_"^"_2
	If (NewTarInsuname'=OldTarInsuname) Set UpdFlag=UpdFlag_"^"_3
	If (NewTarUniom'=OldTarUniom) Set UpdFlag=UpdFlag_"^"_4
	If (NewTarExternalCode'=OldTarExternalCode) Set UpdFlag=UpdFlag_"^"_5
	If (NewTarActiveFlag'=OldTarActiveFlag) Set UpdFlag=UpdFlag_"^"_6
	If (NewTarEngName'=OldTarEngName) Set UpdFlag=UpdFlag_"^"_7
	If (NewTarSpecialFlag'=OldTarSpecialFlag) Set UpdFlag=UpdFlag_"^"_8
	If (NewTarChargeBasis'=OldTarChargeBasis) Set UpdFlag=UpdFlag_"^"_9
	If (NewTarIPCate'=OldTarIPCate) Set UpdFlag=UpdFlag_"^"_10
	If (NewTarOPCate'=OldTarOPCate) Set UpdFlag=UpdFlag_"^"_11
	If (NewTarEMCCate'=OldTarEMCCate) Set UpdFlag=UpdFlag_"^"_12
	If (NewTarMRCate'=OldTarMRCate) Set UpdFlag=UpdFlag_"^"_13
	If (NewTarNMRCate'=OldTarNMRCate) Set UpdFlag=UpdFlag_"^"_14
	If (NewTarACCate'=OldTarACCate) Set UpdFlag=UpdFlag_"^"_15
	If (NewTarSCCate'=OldTarSCCate) Set UpdFlag=UpdFlag_"^"_16
	If (NewTarExpYJPTBM'=OldTarExpYJPTBM) Set UpdFlag=UpdFlag_"^"_17
	Set rtn=""
	If (NewTarCode'=OldTarCode) Do
	.Set rtn=$$judgecode^DHCJFTITM(NewTarCode)
	Quit:rtn'="" """"_"代码不唯一^"_""""
	if (NewTarDesc'=OldTarDesc) Do
	.Set rtn=$$judgedesc^DHCJFTITM(NewTarDesc)
	Quit:rtn'="" """"_"名称不唯一^"_""""

	Quit:UpdFlag=0 """"_"没有需要更新的修改信息^"_""""
	Set rtn=0

	Set NewTarAvailDate=+$h,NewTarAvailTime=$p($h,",",2)
	Set NewTarExpirationDate="",NewTarExpirationTime=""
	If NewAvailDateTime'="" Do
	.Set NewTarAvailDate=$p(NewAvailDateTime," ",1)
	.Set NewTarAvailTime=$p(NewAvailDateTime," ",2)
	.Set NewTarAvailDate=$zdh(NewTarAvailDate,3)
	.Set NewTarAvailTime=$zth(NewTarAvailTime,1)
	If NewExpirationDateTime'="" Do
	.Set NewTarExpirationDate=$p(NewExpirationDateTime," ",1)
	.Set NewTarExpirationTime=$p(NewExpirationDateTime," ",2)
	.Set NewTarExpirationDate=$zdh(NewTarExpirationDate,3)
	.Set NewTarExpirationTime=$zth(NewTarExpirationTime,1)

	Set TarInfo=TarRowid_"^"_NewTarCode_"^"_NewTarDesc_"^"_NewTarUniom_"^"_NewTarSCCate		;1-5
	Set TarInfo=TarInfo_"^"_NewTarACCate_"^"_NewTarOPCate_"^"_NewTarEMCCate_"^"_NewTarMRCate	;6-9
	Set TarInfo=TarInfo_"^"_NewTarSpecialFlag_"^"_NewTarActiveFlag_"^"_""_"^"_""				;10-13
	Set TarInfo=TarInfo_"^"_""_"^"_""_"^"_""_"^"_NewTarExternalCode							;14-17
	Set TarInfo=TarInfo_"^"_NewTarIPCate_"^"_NewTarInsuname_"^"_NewTarEngName_"^"_NewTarChargeBasis	;18-21
	; 新病案号不放在这里更新,后台M里面是直接查询的表，但是新住院分类没有字段，是写在global里的
	Set TarInfo=TarInfo_"^"_NewTarNMRCate											;22-31
	Set UpExpStr=NewTarAvailDate_"^"_NewTarAvailTime_"^"_NewTarExpirationDate_"^"_NewTarExpirationTime_"^2"_"^"_UserRowid
	Set rtn=$$UPDATE^DHCJFTITM(TarInfo,UserRowid,UpExpStr)
	;Set rtn=$$UPDATE^DHCJFTITM(TarInfo,UserRowid)
	If rtn=0 Do
	.Do UpdateTarItemBL^DHCJFMCNEW(TarRowid,NewTarNMRCate,UserRowid)

	; Had Exp table
	If ((rtn=0)&(TarExpRowid'="")) Do
	.Kill PLIST
	.Set PLIST(33)=NewTarExpYJPTBM
	.&sql(update DHC_TaritemExpInfo Values PLIST() WHERE TariExp_RowID=:TarExpRowid)
	.s rtn=SQLCODE
	; Don't have Exp table
	If ((rtn=0)&(TarExpRowid="")) Do
	.Kill PLIST
	.Set PLIST(13)=TarRowid
	.Set PLIST(33)=NewTarExpYJPTBM
	.&sql(insert into DHC_TaritemExpInfo Values PLIST())
	.s rtn=SQLCODE
	.s TariExpRowID=$g(%ROWID)
	
	If (rtn=0) Do
	.Set Flag2="DHC_TarItem",UserTable="User.DHCTarItem",TableDesc="收费项目表",InsRowid=TarRowid
	.Set JsonStr="{TARIRowId:"""_InsRowid_""",TARICode:"""_NewTarCode_""",TARIDesc:"""_NewTarDesc
	.Set JsonStr=JsonStr_""",TARIUOM:"""_NewTarUniom_""",TARISubCate:"""_NewTarSCCate_""",TARIAcctCate:"""_NewTarACCate
	.Set JsonStr=JsonStr_""",TARIOutpatCate:"""_NewTarOPCate_""",TARIEMCCate:"""_NewTarEMCCate_""",TARIMRCate:"""_NewTarMRCate
	.Set JsonStr=JsonStr_""",TARISpecialFlag:"""_NewTarSpecialFlag_""",TARIActiveFlag:"""_NewTarActiveFlag_""",TARIStartDate:"""_+$h
	.Set JsonStr=JsonStr_""",TARIEndDate:"""_""_""",TARIPrice:"""_""_""",TARIAlterPrice1:"""_""
	.Set JsonStr=JsonStr_""",TARIAlterPrice2:"""_""_""",TARIExternalCode:"""_NewTarExternalCode_""",TARIInpatCate:"""_NewTarIPCate
	.Set JsonStr=JsonStr_""",TARIInsuName:"""_NewTarInsuname_""",TARIEngName:"""_NewTarEngName_""",TARIChargeBasis:"""_NewTarChargeBasis_"""}" 
	.Set JsonStrOld="{TARIRowId:"""_InsRowid_""",TARICode:"""_OldTarCode_""",TARIDesc:"""_OldTarDesc
	.Set JsonStrOld=JsonStrOld_""",TARIUOM:"""_OldTarUniom_""",TARISubCate:"""_OldTarSCCate_""",TARIAcctCate:"""_OldTarACCate
	.Set JsonStrOld=JsonStrOld_""",TARIOutpatCate:"""_OldTarOPCate_""",TARIEMCCate:"""_OldTarEMCCate_""",TARIMRCate:"""_OldTarMRCate
	.Set JsonStrOld=JsonStrOld_""",TARISpecialFlag:"""_OldTarSpecialFlag_""",TARIActiveFlag:"""_OldTarActiveFlag_""",TARIStartDate:"""_OldTarStDate
	.Set JsonStrOld=JsonStrOld_""",TARIEndDate:"""_""_""",TARIPrice:"""_""_""",TARIAlterPrice1:"""_""
	.Set JsonStrOld=JsonStrOld_""",TARIAlterPrice2:"""_""_""",TARIExternalCode:"""_OldTarExternalCode_""",TARIInpatCate:"""_OldTarIPCate
	.Set JsonStrOld=JsonStrOld_""",TARIInsuName:"""_OldTarInsuname_""",TARIEngName:"""_OldTarEngName_""",TARIChargeBasis:"""_OldTarChargeBasis_"""}" 
	.Do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)

	Set rtn=""""_rtn_""""
	Quit rtn
}

/// w ##class(DHCBILLConfig.DHCBILLFIND).InsertTarInfo($P(^TMP("tt"),"%",1),$P(^TMP("tt"),"%",2),$P(^TMP("tt"),"%",3))
ClassMethod InsertTarInfo(TarInfo, UserRowid, ExpStr)
{
	Set ^TMP("InsertTarInfo")=TarInfo_"%"_UserRowid_"%"_ExpStr

	Set NewTarCode=$p(TarInfo,"^",2)
	Quit:NewTarCode="" """"_"代码错误^"_""""
	Set rtn=$$judgecode^DHCJFTITM(NewTarCode)
	Quit:rtn'="" """"_"代码不唯一^"_""""
	Set NewTarDesc=$p(TarInfo,"^",3)
	Quit:NewTarDesc="" """"_"名称错误^"_""""
	Set rtn=$$judgedesc^DHCJFTITM(NewTarDesc)
	Quit:rtn'="" """"_"名称不唯一^"_""""
	Set NewTarInsuname=$p(TarInfo,"^",4)
	Set NewTarUniom=$p(TarInfo,"^",5)
	Quit:NewTarUniom="" """"_"单位错误^"_""""
	Set NewTarExternalCode=$p(TarInfo,"^",6)
	Set NewTarActiveFlag=$p(TarInfo,"^",7)
	;If NewTarActiveFlag="true" Set NewTarActiveFlag="Y"
	;Else  Set NewTarActiveFlag="N"
	Set NewTarEngName=$p(TarInfo,"^",8)
	Set NewTarSpecialFlag=$p(TarInfo,"^",9)
	;If NewTarSpecialFlag="true" Set NewTarSpecialFlag="Y"
	;Else  Set NewTarSpecialFlag="N"
	Set NewTarChargeBasis=$p(TarInfo,"^",10)
	Set NewTarIPCate=$p(TarInfo,"^",11)
	Set NewTarOPCate=$p(TarInfo,"^",12)
	Set NewTarEMCCate=$p(TarInfo,"^",13)
	Set NewTarMRCate=$p(TarInfo,"^",14)
	Set NewTarNMRCate=$p(TarInfo,"^",15)
	Set NewTarACCate=$p(TarInfo,"^",16)
	Set NewTarSCCate=$p(TarInfo,"^",17)
	Set NewAvailDateTime=$p(TarInfo,"^",18)
	Set NewExpirationDateTime=$p(TarInfo,"^",19)
	Set NewTarExpYJPTBM=$p(TarInfo,"^",20)
	;Quit:NewTarIPCate="" """"_"住院费用子类错误^"_""""
	;Quit:NewTarOPCate="" """"_"门诊费用子类错误^"_""""
	;Quit:NewTarEMCCate="" """"_"经济核算子类错误^"_""""
	;Quit:NewTarMRCate="" """"_"旧病案首页子类错误^"_""""
	;Quit:NewTarNMRCate="" """"_"新病案首页子类错误^"_""""
	;Quit:NewTarACCate="" """"_"收费会计子类错误^"_""""
	;Quit:NewTarSCCate="" """"_"收费项目子类错误^"_""""
	If ((NewTarIPCate="")!(NewTarOPCate="")!(NewTarEMCCate="")!(NewTarMRCate="")!(NewTarNMRCate="")!(NewTarACCate="")!(NewTarSCCate="")) Do
	.Set NewTarActiveFlag="N" ; 分类有为空的置成无效
	Set NewAvailDateTime1=$tr($tr($tr(NewAvailDateTime," "),"-"),":")
	Set NewExpirationDateTime1=$tr($tr($tr(NewExpirationDateTime," "),"-"),":")
	Quit:((NewAvailDateTime1'="")&(NewExpirationDateTime1'="")&(NewAvailDateTime1>NewExpirationDateTime1)) """"_"生效日期不能大于失效日期^"_""""

	Set NewTarAvailDate=+$h,NewTarAvailTime=$p($h,",",2)
	Set NewTarExpirationDate="",NewTarExpirationTime=""
	If NewAvailDateTime'="" Do
	.Set NewTarAvailDate=$p(NewAvailDateTime," ",1)
	.Set NewTarAvailTime=$p(NewAvailDateTime," ",2)
	.Set NewTarAvailDate=$zdh(NewTarAvailDate,3)
	.Set NewTarAvailTime=$zth(NewTarAvailTime,1)
	If NewExpirationDateTime'="" Do
	.Set NewTarExpirationDate=$p(NewExpirationDateTime," ",1)
	.Set NewTarExpirationTime=$p(NewExpirationDateTime," ",2)
	.Set NewTarExpirationDate=$zdh(NewTarExpirationDate,3)
	.Set NewTarExpirationTime=$zth(NewTarExpirationTime,1)

	Set TarInfo=""_"^"_NewTarCode_"^"_NewTarDesc_"^"_NewTarUniom_"^"_NewTarSCCate		;1-5
	Set TarInfo=TarInfo_"^"_NewTarACCate_"^"_NewTarOPCate_"^"_NewTarEMCCate_"^"_NewTarMRCate	;6-9
	Set TarInfo=TarInfo_"^"_NewTarSpecialFlag_"^"_NewTarActiveFlag_"^"_+$h_"^"_""				;10-13
	Set TarInfo=TarInfo_"^"_""_"^"_""_"^"_""_"^"_NewTarExternalCode							;14-17
	Set TarInfo=TarInfo_"^"_NewTarIPCate_"^"_NewTarInsuname_"^"_NewTarEngName_"^"_NewTarChargeBasis	;18-21
	Set TarInfo=TarInfo_"^"_NewTarNMRCate											;22-31
	
	K PLIST
	Set PLIST(2)=$p(TarInfo,"^",2)
	Set PLIST(3)=$p(TarInfo,"^",3)
	Set PLIST(4)=$p(TarInfo,"^",4)
	Set PLIST(5)=$p(TarInfo,"^",5)
	Set PLIST(6)=$p(TarInfo,"^",6)
	Set PLIST(7)=$p(TarInfo,"^",7)
	Set PLIST(8)=$p(TarInfo,"^",8)
	Set PLIST(9)=$p(TarInfo,"^",9)
	Set PLIST(10)=$p(TarInfo,"^",10)
	Set PLIST(11)=$p(TarInfo,"^",11)
	Set PLIST(12)=$p(TarInfo,"^",12)
	Set PLIST(13)=$p(TarInfo,"^",13)
	Set PLIST(14)=$p(TarInfo,"^",14)
	Set PLIST(15)=$p(TarInfo,"^",15)
	Set PLIST(16)=$p(TarInfo,"^",16)
	Set PLIST(17)=$p(TarInfo,"^",17)
	Set PLIST(18)=$p(TarInfo,"^",18)
	Set PLIST(19)=$p(TarInfo,"^",19)
	Set PLIST(20)=$p(TarInfo,"^",20)
	Set PLIST(21)=$p(TarInfo,"^",21)
	Set PLIST(22)=$p(TarInfo,"^",22)
	Set PLIST(23)=UserRowid
	Set PLIST(24)=+$h
	Set PLIST(25)=$p($h,",",2)
	
	Set UpExpStr=NewTarAvailDate_"^"_NewTarAvailTime_"^"_NewTarExpirationDate_"^"_NewTarExpirationTime_"^2"_"^"_UserRowid

	Set rtn=$$INSERTNEW^DHCJFTITM(UpExpStr)
	;Set rtn=$$INSERT^DHCJFTITM()
	Set TarRowid=""
	IF rtn=0 Do
	.Set TarRowid=PLIST(1)
	.Do UpdateTarItemBL^DHCJFMCNEW(TarRowid,NewTarNMRCate,UserRowid)

	If ((rtn=0)&(TarRowid'="")) Do
	.Set TarAlias=##class(web.DHCINSUPort).GetCNCODE(NewTarDesc,4,"")
	.Kill PLIST
	.Set PLIST(2)=TarRowid
	.Set PLIST(3)=NewTarDesc
	.Set PLIST(4)=TarAlias
	.Set AliasRtn="AliasErr"
	.Set AliasRowid=""
	.If (TarAlias'=0)&(TarAlias'="") Do
	..Set AliasRtn=$$INSERT^DHCJFTITMA()
	.If ((AliasRtn'=0)&(AliasRtn'="AliasErr")) s AliasRtn="AliasErr:"_AliasRtn
	.Set rtn=AliasRtn
	.Set AliasRowid=%ROWID
	
	If ((rtn=0)&(TarRowid'="")) Do
	.Kill PLIST
	.Set PLIST(13)=TarRowid
	.Set PLIST(33)=NewTarExpYJPTBM
	.&sql(insert into DHC_TaritemExpInfo Values PLIST())
	.Set rtn=SQLCODE
	.Set TariExpRowID=$g(%ROWID)
	
	If rtn=0 Do
	.Set Flag2="DHC_TarItem",UserTable="User.DHCTarItem",TableDesc="收费项目表",InsRowid=TarRowid
	.Set JsonStr="{TARIRowId:"""_InsRowid_""",TARICode:"""_NewTarCode_""",TARIDesc:"""_NewTarDesc
	.Set JsonStr=JsonStr_""",TARIUOM:"""_NewTarUniom_""",TARISubCate:"""_NewTarSCCate_""",TARIAcctCate:"""_NewTarACCate
	.Set JsonStr=JsonStr_""",TARIOutpatCate:"""_NewTarOPCate_""",TARIEMCCate:"""_NewTarEMCCate_""",TARIMRCate:"""_NewTarMRCate
	.Set JsonStr=JsonStr_""",TARISpecialFlag:"""_NewTarSpecialFlag_""",TARIActiveFlag:"""_NewTarActiveFlag_""",TARIStartDate:"""_+$h
	.Set JsonStr=JsonStr_""",TARIEndDate:"""_""_""",TARIPrice:"""_""_""",TARIAlterPrice1:"""_""
	.Set JsonStr=JsonStr_""",TARIAlterPrice2:"""_""_""",TARIExternalCode:"""_NewTarExternalCode_""",TARIInpatCate:"""_NewTarIPCate
	.Set JsonStr=JsonStr_""",TARIInsuName:"""_NewTarInsuname_""",TARIEngName:"""_NewTarEngName_""",TARIChargeBasis:"""_NewTarChargeBasis_"""}" 
	.Do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"插入","A",JsonStr)

	.Set Flag2="DHC_TarItemAlias",UserTable="User.DHCTarItemAlias",TableDesc="收费项目别名表",InsRowid=AliasRowid
	.Set JsonStr="{TIARowId:"""_InsRowid_""",TIATARIDR:"""_TarRowid_""",TIADesc:"""_NewTarDesc_""",TIAAlias:"""_TarAlias_"""}" 
	.Do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"插入","A",JsonStr)

	If rtn=0 Set rtn=rtn_"^"_TarRowid
	else  Set rtn=rtn_"^"
	Set rtn=""""_rtn_""""

	Quit rtn
}

///  w ##class(DHCBILLConfig.DHCBILLFIND).InsertTarUBI(1879,8)
ClassMethod InsertTarUBI(TarRowid, TariExpRowID)
{
	Kill ePLIST
	Set UBIRowid=$o(^DHCTARIUBI(0,"TARI",TarRowid,""),-1)
	Quit:UBIRowid="" -100
	&sql(SELECT * INTO ePLIST() FROM DHC_TaritemExpInfo WHERE TariExp_RowID= :TariExpRowID) 
	Set Err=0,ConRowID=""
	Set i="" 
	For  Set i=$o(ePLIST(i)) Quit:i=""  Do
	.Quit:i=0
	.Set ePLIST(i)=""_"^"_ePLIST(i)
	; 插日志子表
	Set i="",tablename="DHC_TaritemExpInfo"
	For  Set i=$o(ePLIST(i)) Quit:i=""  Do  Quit:(Err'=0)!($g(ConRowID)="")
	.Set a="PLIST("_i_")"
	.If i=1 Set ConRowID="rowid"
	.Quit:i=1
	.Set ConRowID=""
	.If $d(^DHCTARITEMFIELDCONFIG(0,"Plist",tablename,a)) Do
	..Set ConRowID=$o(^DHCTARITEMFIELDCONFIG(0,"Plist",tablename,a,""),-1)
	.If $g(ConRowID)="" Set SQLCODE=-100
	.Kill PLIST
	.Set PLIST(0)=UBIRowid
	.Set UpItmCodeDr=$g(ConRowID),PLIST(3)=$g(UpItmCodeDr)
	.Set UpOldInfo=$p(ePLIST(i),"^",1),PLIST(4)=UpOldInfo
	.Set UpNewInfo=$p(ePLIST(i),"^",2),PLIST(5)=UpNewInfo
	.&SQL(insert into DHC_TaritemBaseUpdDetail values PLIST())
	.Set Err=Err+SQLCODE
	Quit Err
}

/// w ##class(DHCBILLConfig.DHCBILLFIND).InsertTarPrice("5186^1^2014-09-16^^111^^^^^",1,2)
ClassMethod InsertTarPrice(TPInfo, Guser, HopID)
{
	Set ^TMP("InsertTarPrice")=TPInfo_"$"_Guser_"$"_HopID
	Set TarRowid=$p(TPInfo,"^",1)
	Set AdmReason=$p(TPInfo,"^",2)
	Quit:AdmReason="" """"_"收费类型不能为空^"_""""
	Set StDate=$p(TPInfo,"^",3)
	Quit:StDate="" """"_"开始日期不能为空^"_""""
	If StDate["-" Set StDate=$zdh(StDate,3)
	Set EndDate=$p(TPInfo,"^",4)
	If EndDate["-" Set EndDate=$zdh(EndDate,3)
	Set Price=$p(TPInfo,"^",5)
	Set AlertPrice1=$p(TPInfo,"^",6)
	Set AlertPrice2=$p(TPInfo,"^",7)
	Set LimitPrice=$p(TPInfo,"^",8)
	Set DisRate=$p(TPInfo,"^",9)
	Set PayOrShareRate=$p(TPInfo,"^",10)
	Set PriceConfig=$$GetTariPriceRowID^DHCJFTITMP(TarRowid,HopID)
	Quit:((PriceConfig'="")&(StDate<=+$h)) """"_"已有价格,调价开始日期不允许早于或等于当前日期^"_""""
	
	Kill PLIST
	Set PLIST(1)=TarRowid
	Set PLIST(3)=StDate
	Set PLIST(4)=EndDate
	Set PLIST(5)=Price
	Set PLIST(6)=LimitPrice
	Set PLIST(7)=PayOrShareRate
	Set PLIST(8)=Guser
	Set PLIST(9)=+$h
	Set PLIST(10)=$p($h,",",2)
	Set PLIST(11)=""
	Set PLIST(12)=DisRate
	Set PLIST(13)=AdmReason
	Set PLIST(14)=AlertPrice1
	Set PLIST(15)=AlertPrice2
	Set PLIST(16)=HopID

	Set rtn=$$INSERT^DHCJFTITMP()
	
	Set TPRowid=""
	If rtn=0 Do
	.Set TPRowid=PLIST(1)
	.Set rtn=rtn_"^"_TPRowid
	Else  Set rtn=rtn_"^"
	
	If +rtn=0 Do
	.Set Flag2="DHC_TarItemPrice",UserTable="User.DHCTarItemPrice",TableDesc="收费项目价格表",InsRowid=TPRowid
	.Set JsonStr="{TPTARIParRef:"_TarRowid_",TPRowId:"_InsRowid_",TPStartDate:"_StDate
	.Set JsonStr=JsonStr_",TPEndDate:"_EndDate_",TPPrice:"_Price_",TPLimitedPrice:"_LimitPrice
	.Set JsonStr=JsonStr_",TPPayorRate:"_PayOrShareRate_",TPUpdateUser:"_Guser_",TPUpdateDate:"_+$h
	.Set JsonStr=JsonStr_",TPUpdateTime:"_$p($h,",",2)_",TPAdjustNo:"_""_",TPDiscRate:"_DisRate
	.Set JsonStr=JsonStr_",TPPatInsType:"_AdmReason_",TPAlterPrice1:"_AlertPrice1_",TPAlterPrice2:"_AlertPrice2
	.Set JsonStr=JsonStr_",TPHospitalDR:"_HopID_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"插入","A",JsonStr)

	Set rtn=""""_rtn_""""
	Quit rtn
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindTarAlias",17)
Query FindTarAlias(TarRowid) As websys.Query(ROWSPEC = "TIARowId:%String,TarRowid:%String,TIADESC:%String,TIAAlias:%String")
{
}

ClassMethod FindTarAliasExecute(ByRef qHandle As %Binary, TarRowid) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
	If (TarRowid="")  Quit $$$OK
	Do OPEN^DHCJFTITMA(TarRowid)
	Do{
		Set rtn=$$FETCH^DHCJFTITMA(TarRowid)
	    Do GetTarAlias
	}while(rtn=0)
    Do CLOSE^DHCJFTITMP()

	Quit $$$OK
GetTarAlias
	Set (TIARowId, TIADESC, TIAAlias)=""
	Quit:$d(PLIST)=0
	Quit:PLIST=1
	Set TIARowId=PLIST(1)
	Set TarRowid=PLIST(2)
	Set TIADESC=PLIST(3)
	Set TIAAlias=PLIST(4)
	Do OutputRowA
	Quit
OutputRowA
	Set TIADESC=..EvalJSON(TIADESC)
	Set TIAAlias=..EvalJSON(TIAAlias)
	set Data=$lb(TIARowId, TarRowid, TIADESC, TIAAlias)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 查询收费项目别名
ClassMethod GetItemAlias(Rowid)
{
	New (Rowid)
	Set aliasrowid="",AliasStr=""
	For  Set aliasrowid=$o(^DHCTARAL("A",Rowid,aliasrowid)) Quit:aliasrowid=""  Do
	.Quit:aliasrowid=0
	.Set Alias=$p(^DHCTARAL(aliasrowid),"^",3)
	.If AliasStr="" Set AliasStr=aliasrowid_"&"_Alias
	.Else  Set AliasStr=AliasStr_"^"_aliasrowid_"&"_Alias
	
	Set outputstr="{results:["
	Set printLine=0,totalCount=0
	Set AliasStrlen=$l(AliasStr,"^")
	For i=1:1:AliasStrlen Do
	.Set Alias=$p(AliasStr,"^",i)
	.Set dataTmpStr="'Alias'"_":'"_$p(Alias,"&",2)_"'"_","_"'AliasID'"_":'"_$p(Alias,"&",1)_"'"
	.Set printLine=printLine+1 		
	.If printLine=1 Set outputstr=outputstr_"{"_dataTmpStr_"}"
	.Else  Set outputstr=outputstr_",{"_dataTmpStr_"}"
	.Set totalCount=totalCount+1
	Set outputstr=outputstr_"],totalCount:"_totalCount_"}"
	Quit outputstr
}

/// 添加收费项目别名
ClassMethod InsertAlias(AliasDesc, TariRowid, Guser, Hosp)
{
	Kill PLIST
	Set TarDesc=$p(^DHCTARI(TariRowid),"^",2)
	Set PLIST(2)=TariRowid
	Set PLIST(3)=TarDesc
	Set PLIST(4)=AliasDesc
	Set rtn=$$INSERT^DHCJFTITMA()
	If rtn=0 Do
	.Set AliasRowid=%ROWID
	.Set Flag2="DHC_TarItemAlias",UserTable="User.DHCTarItemAlias",TableDesc="收费项目别名表",InsRowid=AliasRowid
	.Set JsonStr="{TIARowId:"_InsRowid_",TIATARIDR:"_TariRowid_",TIADesc:"_TarDesc_",TIAAlias:"_AliasDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"插入","A",JsonStr)

	.;Set UserName=$p(^SSU("SSUSR",Guser),"^",2)
	.;Set UserInit=$p(^SSU("SSUSR",Guser),"^",1)
	.;Set ^DHCInsertAlias(Hosp,"Insert",$zd(+$h,3),$zt($p($h,",",2),1),UserName_"("_UserInit_")")="DHC_TarItemAlias"_"^"_TariRowid_"^"_TarDesc_"^"_AliasDesc
	Quit rtn
}

/// 修改收费项目别名
ClassMethod UpdateAlias(AliasRowid, AliasDesc, Guser, Hosp)
{
	Set ^TMP("tt")=AliasRowid_","_AliasDesc_","_Guser_","_Hosp
	Kill PLIST
	Set TarRowid=$p(^DHCTARAL(AliasRowid),"^",1)
	Set TarDesc=$p(^DHCTARAL(AliasRowid),"^",2)
	Set OldAliasDesc=$p(^DHCTARAL(AliasRowid),"^",3)    ;旧别名
	Set OldTarRowid=TarRowid
	Set OldTarDesc=TarDesc

	Set PLIST(2)=TarRowid
	Set PLIST(3)=TarDesc
	Set PLIST(4)=AliasDesc      ;新别名
	Set rtn=$$UPDATE^DHCJFTITMA(AliasRowid)
	If rtn=0 Do
	.Set Flag2="DHC_TarItemAlias",UserTable="User.DHCTarItemAlias",TableDesc="收费项目别名表",InsRowid=AliasRowid
	.Set JsonStr="{TIARowId:"_InsRowid_",TIATARIDR:"_TarRowid_",TIADesc:"_TarDesc_",TIAAlias:"_AliasDesc_"}" 
	.Set JsonStrOld="{TIARowId:"_InsRowid_",TIATARIDR:"_OldTarRowid_",TIADesc:"_OldTarDesc_",TIAAlias:"_OldAliasDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)
	.;Set UserName=$p(^SSU("SSUSR",Guser),"^",2)
	.;Set UserInit=$p(^SSU("SSUSR",Guser),"^",1)
	.;Set ^DHCInsertAlias(Hosp,"Update",$zd(+$h,3),$zt($p($h,",",2),1),UserName_"("_UserInit_")")="DHC_TarItemAlias"_"^"_TarRowid_"^"_TarDesc_"^"_OldAliasDesc_"^"_AliasDesc
	Quit rtn
}

/// 删除收费项目别名
ClassMethod DeleteAlias(AliasRowid, Guser, Hosp)
{
	Kill PLIST
	Set TarRowid=$p(^DHCTARAL(AliasRowid),"^",1)
	Set TarDesc=$p(^DHCTARAL(AliasRowid),"^",2)
	Set AliasDesc=$p(^DHCTARAL(AliasRowid),"^",3)
	Set rtn=$$DELETE^DHCJFTITMA(AliasRowid)
	If rtn=0 Do
	.Set Flag2="DHC_TarItemAlias",UserTable="User.DHCTarItemAlias",TableDesc="收费项目别名表",InsRowid=AliasRowid
	.Set JsonStr="{TIARowId:"_InsRowid_",TIATARIDR:"_TarRowid_",TIADesc:"_TarDesc_",TIAAlias:"_AliasDesc_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"删除","D",JsonStr)
	.;Set UserName=$p(^SSU("SSUSR",Guser),"^",2)
	.;Set UserInit=$p(^SSU("SSUSR",Guser),"^",1)
	.;Set ^DHCInsertAlias(Hosp,"Delete",$zd(+$h,3),$zt($p($h,",",2),1),UserName_"("_UserInit_")")="DHC_TarItemAlias"_"^"_TarRowid_"^"_TarDesc_"^"_AliasDesc
	Quit rtn
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindArcItm","","A00N001","","","",2)
Query FindArcItm(ArcAlias, ArcCode, OrderCat, ArcDesc, ArcItemcat, HospID) As websys.Query(ROWSPEC = "TArcCode:%String,TArcDesc:%String,TOrderCat:%String,TArcItmCat:%String,TBillCat:%String,TPriority:%String,TArcRowid:%String,TPHCIndr:%String,TArcPrice:%String,TOwn:%String,TStDate:%String,TEndDate:%String,Tjob:%String")
{
}

ClassMethod FindArcItmExecute(ByRef qHandle As %Binary, ArcAlias, ArcCode, OrderCat, ArcDesc, ArcItemcat, HospID) As %Status
{
	Set Guser=$G(%session.Data("LOGON.USERID"))
	s ^TMP("tt")=ArcAlias_","_ArcCode_","_OrderCat_","_ArcDesc_","_ArcItemcat_","_HospID_","_Guser
	Set repid=$I(^CacheTemp)
	Set ind=1
	Kill PLIST,P3
	Kill ^TMP("FindArcItm",Guser)
	Set today=+$H,job=$j
	Set desc=$$ALPHAUP^SSUTIL4(ArcAlias)
	Set code=$$ALPHAUP^SSUTIL4(ArcCode)
	If ArcDesc'="" Set ArcDesc="%"_ArcDesc_"%"
	Else  Set ArcDesc="%"
	If ((OrderCat="")!(OrderCat=0)) Set ordtype="%"
	Else  Set ordtype=$p(^OEC("ORCAT",OrderCat),"^",2)
	If ((ArcItemcat="")!(ArcItemcat=0)) Set itmcatpye="%"
	Else  Set itmcatpye=$p(^ARC("IC",ArcItemcat),"^",2)

	&sql(declare alias cursor for
		select distinct(alias_arcim_dr),alias_arcim_dr->arcim_code,alias_arcim_dr->arcim_desc,
			alias_arcim_dr->ARCIM_ItemCat_DR->arcic_ordcat_dr->orcat_desc,
			alias_arcim_dr->ARCIM_ItemCat_DR->arcic_desc,
			alias_arcim_dr->arcim_billsub_dr->arcsg_desc,
			alias_arcim_dr->arcim_rowid,alias_arcim_dr->arcim_defpriority_dr,
			alias_arcim_dr->arcim_phcdf_dr->phcdf_phcin_dr from arc_alias
		where alias_arcim_dr->arcim_code %STARTSWITH :code
			and $$ALPHAUP^SSUTIL4(alias_text) %STARTSWITH :desc and
			alias_arcim_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_desc like:ordtype and 
			alias_arcim_dr->arcim_itemcat_dr->ARCIC_Desc like:itmcatpye  
			and alias_arcim_dr->arcim_desc like:ArcDesc)
	&sql(open alias)
	Set m=1
	For  &sql(fetch alias into :arcim,:alcode,:aldesc,:algrp,:algrpsub,:alsub,:alrowid,:prior,:yf) Quit:SQLCODE  Do
	.Set arcim=$p(arcim,$c(1))
	.Set orderprice=+$$GetOrderPrice^DHCPRICE("","",arcim,today,"","","","",HospID)
	.Set PLIST(m)=alcode_"^"_$g(aldesc)_"^"_algrp_"^"_algrpsub_"^"_alsub_"^"_$p(prior,$c(1))_"^"_$p(alrowid,$c(1))_"^"_$p(yf,$C(1))_"^"_orderprice
	.Set m=m+1
	&sql(close alias)
	Set P3=m-1
	If P3<=0 Set qHandle=$lb(0,repid,0) Quit $$$OK
	Set Num=P3
	For i=1:1:P3 Do
	.Set ArcInfo=PLIST(i)
	.Set TArcCode=$p(ArcInfo,"^",1)
	.Set TArcDesc=$p(ArcInfo,"^",2)
	.Set TOrderCat=$p(ArcInfo,"^",3)
	.Set TArcItmCat=$p(ArcInfo,"^",4)
	.Set TBillCat=$p(ArcInfo,"^",5)
	.Set TPriority=$p(ArcInfo,"^",6)
	.Set TArcRowid=$p(ArcInfo,"^",7)
	.Set TPHCIndr=$p(ArcInfo,"^",8)
	.Set TArcPrice=$p(ArcInfo,"^",9)
	.Set TArcCode=..EvalJSON(TArcCode)
	.Set TArcDesc=..EvalJSON(TArcDesc)
	.Set TOrderCat=..EvalJSON(TOrderCat)
	.Set TPriority=..EvalJSON(TPriority)
	.Set TPHCIndr=..EvalJSON(TPHCIndr)
	.Set TArcItmCat=..EvalJSON(TArcItmCat)
	.Set TBillCat=..EvalJSON(TBillCat)
	.Set Own=$p($g(^ARCIM(+TArcRowid,+$p(TArcRowid,"||",2),7)),"^",13)
	.Set StDate=$p($p($g(^ARCIM(+TArcRowid,+$p(TArcRowid,"||",2),1)),"^",13),"Z",1)
	.Set EndDate=$p($g(^ARCIM(+TArcRowid,+$p(TArcRowid,"||",2),7)),"^",1)
	.If StDate'="" Set StDate=$zd(StDate,3)
	.If EndDate'="" Set EndDate=$zd(EndDate,3)
	.Do OutputRowArc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowArc
	Set ^TMP("FindArcItm",Guser,job,ind)=TArcCode_"^"_TArcDesc_"^"_TOrderCat_"^"_TArcItmCat_"^"_TBillCat_"^"_TPriority_"^"_TArcRowid_"^"_TPHCIndr_"^"_TArcPrice_"^"_Own_"^"_StDate_"^"_EndDate
	Set Data=$lb(TArcCode,TArcDesc,TOrderCat,TArcItmCat,TBillCat,TPriority,TArcRowid,TPHCIndr,TArcPrice,Own,StDate,EndDate,job)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindArcByTar",10,2)
Query FindArcByTar(TarRowid, HospID) As websys.Query(ROWSPEC = "TArcCode:%String,TArcDesc:%String,TOrderCat:%String,TArcItmCat:%String,TBillCat:%String,TPriority:%String,TArcRowid:%String,TPHCIndr:%String,TArcPrice:%String,TOwn:%String,TStDate:%String,TEndDate:%String")
{
}

ClassMethod FindArcByTarExecute(ByRef qHandle As %Binary, TarRowid, HospID) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	If (TarRowid="")  Quit $$$OK
	Kill ArcArray
	Set tStDate=""
	For  Set tStDate=$o(^DHCOLT(0,"TAR",TarRowid,tStDate)) Quit:tStDate=""  Do
	.Quit:tStDate=0
	.Set OLTRowid=""
	.For  Set OLTRowid=$o(^DHCOLT(0,"TAR",TarRowid,tStDate,OLTRowid)) Quit:OLTRowid=""  Do
	..Quit:OLTRowid=0
	..Set ArcRowid=$p(^DHCOLT(OLTRowid),"^",1)
	..Quit:$d(ArcArray(ArcRowid))
	..Set (TArcCode,TArcDesc,TOrderCat,TArcItmCat,TBillCat,TPriority,TArcRowid,TPHCIndr,TArcPrice)=""
	..Set TArcRowid=ArcRowid
	..Set TArcCode=$p(^ARCIM(+ArcRowid,$p(ArcRowid,"||",2),1),"^",1)
	..Set TArcDesc=$p(^ARCIM(+ArcRowid,$p(ArcRowid,"||",2),1),"^",2)
	..Set TBillCat=$p(^ARCIM(+ArcRowid,$p(ArcRowid,"||",2),1),"^",9)
	..Set TBillCatDesc=""
	..If TBillCat'="" Set TBillCatDesc=$p(^ARCBG(+TBillCat,"SG",$p(TBillCat,"||",2)),"^",2)
	..Set TArcItmCat=$p(^ARCIM(+ArcRowid,$p(ArcRowid,"||",2),1),"^",10)
	..Set TArcItmCatDesc=""
	..If TArcItmCat'="" Set TArcItmCatDesc=$p(^ARC("IC",TArcItmCat),"^",2)
	..Set TOrderCat="",TOrderCatDesc=""
	..If TArcItmCat'="" Set TOrderCat=$p(^ARC("IC",TArcItmCat),"^",8)
	..If TOrderCat'="" Set TOrderCatDesc=$p(^OEC("ORCAT",TOrderCat),"^",2)
	
	..Set TPriority=$p(^ARCIM(+ArcRowid,$p(ArcRowid,"||",2),8),"^",22)
	..Set TPHCIndr=$p(^ARCIM(+ArcRowid,$p(ArcRowid,"||",2),1),"^",12)
	..Set TPHCIndrDr=""
	..If TPHCIndr'="" Set TPHCIndrDr=$p(^PHCD(+TPHCIndr,"DF",$p(TPHCIndr,"||",2),1),"^",5)
	..Set Own=$p($g(^ARCIM(+ArcRowid,+$p(ArcRowid,"||",2),7)),"^",13)
	..Set StDate=$p($p($g(^ARCIM(+ArcRowid,+$p(ArcRowid,"||",2),1)),"^",13),"Z",1)
	..Set EndDate=$p($g(^ARCIM(+ArcRowid,+$p(ArcRowid,"||",2),7)),"^",1)
	..If StDate'="" Set StDate=$zd(StDate,3)
	..If EndDate'="" Set EndDate=$zd(EndDate,3)
	..Set TArcPrice=+$$GetOrderPrice^DHCPRICE("","",ArcRowid,+$h,"","","","",HospID)
	
	..Set TArcCode=..EvalJSON(TArcCode)
	..Set TArcDesc=..EvalJSON(TArcDesc)
	..Set TOrderCat=..EvalJSON(TOrderCat)
	..Set TPriority=..EvalJSON(TPriority)
	..Set TPHCIndr=..EvalJSON(TPHCIndr)
	..Set ArcArray(ArcRowid)=""
	..Do OutputRowArcByTar

	Quit $$$OK
OutputRowArcByTar
	Set Data=$lb(TArcCode,TArcDesc,TOrderCatDesc,TArcItmCatDesc,TBillCatDesc,TPriority,TArcRowid,TPHCIndrDr,TArcPrice,Own,StDate,EndDate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindOrdCat","ArcItmCat",1)
Query FindOrdCat(CateFlag, OrdCatDr As %String = "") As websys.Query(ROWSPEC = "OrcRowid:%String, OrdCode:%String, OrdCat:%String")
{
}

ClassMethod FindOrdCatExecute(ByRef qHandle As %Binary, CateFlag, OrdCatDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Set ^TMP("tt")=CateFlag_","_OrdCatDr
	If OrdCatDr=0 Set OrdCatDr=""
	If CateFlag="OrdCat" Do
	.Set Rowid=""
	.For  Set Rowid=$o(^OEC("ORCAT",Rowid)) Quit:Rowid=""  Do
	..Set OrdCode=$p(^OEC("ORCAT",Rowid),"^",1)
	..Set OrdCat=$p(^OEC("ORCAT",Rowid),"^",2)
	..Do OutputRowOrd
	If CateFlag="ArcItmCat" Do
	.Set Rowid=""
	.For  Set Rowid=$o(^ARC("IC",Rowid)) Quit:Rowid=""  Do
	..Set OrdCode=$p(^ARC("IC",Rowid),"^",1)
	..Set OrdCat=$p(^ARC("IC",Rowid),"^",2)
	..Set ArcOrdCat=$p(^ARC("IC",Rowid),"^",8)
	..Quit:((OrdCatDr'="")&(ArcOrdCat'="")&(OrdCatDr'=ArcOrdCat))
	..Do OutputRowOrd
	
	Quit $$$OK
OutputRowOrd
	Set OrdCode=..EvalJSON(OrdCode)	
	Set OrdCat=..EvalJSON(OrdCat)	
	Set Data=$lb(Rowid,OrdCode,OrdCat)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindTarByArc","11009||1", 2)
Query FindTarByArc(ArcRowid, HospID) As websys.Query(ROWSPEC = "TarCode:%String,TarDesc:%String,TarQty:%String,TarStDate:%String,TarEndDate:%String,TarYF:%String,TarPrority:%String,Oltrowid:%String,TarRowid:%String,YFRowid:%String,PriorityRowid:%String,TarPrice:%String")
{
}

ClassMethod FindTarByArcExecute(ByRef qHandle As %Binary, ArcRowid, HospID) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)	
	Set ind=1
	Kill PLIST
	Set num=0
	Set today=+$H
	&sql(declare taricur cursor for
		select olt_tariff_dr,olt_tariff_dr->tari_code,olt_tariff_dr->tari_desc,
			olt_qty,olt_startdate,olt_enddate,olt_inst_dr,olt_inst_dr->phcin_desc1,
			olt_priority_dr,olt_priority_dr->oecpr_desc,olt_rowid
		from  dhc_orderlinktar  
		where olt_arcim_dr=:ArcRowid)
	&sql(open taricur)
	For  &sql(fetch taricur into:tarirowid,:taricode,:taridesc,:qty,:stdate,:enddate,:yfrowid,:yfdesc,:priorrowid,:priordesc,:oltrowid)  q:SQLCODE  d
	.Set num=num+1
	.Set enddate1=enddate
	.If +stdate'="0" d  s stdate=$zd(stdate,3)
	.If +enddate'="0" d  s enddate=$zd(enddate,3)
	.Set itemprice=+$$GetItmPrice^DHCPRICE(tarirowid,today,"","","",HospID)
	.Set PLIST(num)=taricode_"^"_taridesc_"^"_qty_"^"_stdate_"^"_enddate_"^"_yfdesc_"^"_priordesc_"^"_oltrowid_"^"_tarirowid_"^"_yfrowid_"^"_priorrowid_"^"_itemprice
	&sql(close taricur)
	Set PLIST=num
	If PLIST<=0 Set qHandle=$lb(0,repid,0) Quit $$$OK
	Set Num=PLIST
	For i=1:1:Num Do
	.Set TarInfo=PLIST(i)
	.Set TarCode=$p(TarInfo,"^",1)
	.Set TarDesc=$p(TarInfo,"^",2)
	.Set TarQty=$p(TarInfo,"^",3)
	.Set TarStDate=$p(TarInfo,"^",4)
	.Set TarEndDate=$p(TarInfo,"^",5)
	.Set TarYF=$p(TarInfo,"^",6)
	.Set TarPrority=$p(TarInfo,"^",7)
	.Set Oltrowid=$p(TarInfo,"^",8)
	.Set TarRowid=$p(TarInfo,"^",9)
	.Set YFRowid=$p(TarInfo,"^",10)
	.Set PriorityRowid=$p(TarInfo,"^",11)
	.Set TarPrice=$p(TarInfo,"^",12)
	.If $p(TarPrice,".",1)="" Set TarPrice="0"_TarPrice
	.Set TarCode=..EvalJSON(TarCode)
	.Set TarDesc=..EvalJSON(TarDesc)
	.Set TarYF=..EvalJSON(TarYF)
	.Set TarPrority=..EvalJSON(TarPrority)
	.Do OutputRowArcTar
	
	Quit $$$OK
OutputRowArcTar
	Set Data=$lb(TarCode,TarDesc,TarQty,TarStDate,TarEndDate,TarYF,TarPrority,Oltrowid,TarRowid,YFRowid,PriorityRowid,TarPrice)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindInstru")
Query FindInstru() As websys.Query(ROWSPEC = "InstruRowid:%String,InstruDesc:%String")
{
}

ClassMethod FindInstruExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Do findinstru^DHCJFFIND
	If P5=0 Set qHandle=$lb(0,repid,0) Quit $$$OK
	Set (InstruRowid,InstruDesc)=""
	Do OutputRowInstru
	For i=1:1:P5 d
	.Do list^DHCJFFIND(i)
	.Set InstruInfo=PLIST(i)
	.Set InstruRowid=$p(InstruInfo,"^",1)
	.Set InstruDesc=$p(InstruInfo,"^",2)
	.Do OutputRowInstru
	
	Quit $$$OK
OutputRowInstru
	Set InstruDesc=..EvalJSON(InstruDesc)
	Set Data=$lb(InstruRowid,InstruDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindPriority")
Query FindPriority() As websys.Query(ROWSPEC = "PriorityRowid:%String,PriorityDesc:%String")
{
}

ClassMethod FindPriorityExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Do findprior^DHCJFFIND
	If P5=0 Set qHandle=$lb(0,repid,0) Quit $$$OK
	Set (PriorityRowid,PriorityDesc)=""
	Do OutputRowPrio
	For i=1:1:P5 d
	.Do list^DHCJFFIND(i)
	.Set PriorityInfo=PLIST(i)
	.Set PriorityRowid=$p(PriorityInfo,"^",1)
	.Set PriorityDesc=$p(PriorityInfo,"^",2)
	.Do OutputRowPrio
	
	Quit $$$OK
OutputRowPrio
	Set PriorityDesc=..EvalJSON(PriorityDesc)
	Set Data=$lb(PriorityRowid,PriorityDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// w ##class(DHCBILLConfig.DHCBILLFIND).InsertOrderLinkTar("1||1^11^2014-07-25^^12^1.04^^",1,2)
ClassMethod InsertOrderLinkTar(OLTInto, Guser, HospID)
{
	Set ^TMP("tt")=OLTInto
	Set ArcRowid=$p(OLTInto,"^",1)
	Set TarRowid=$p(OLTInto,"^",2)
	Set StDate=$p(OLTInto,"^",3)
	Set EndDate=$p(OLTInto,"^",4)
	Set Qty=$p(OLTInto,"^",5)
	Set Price=$p(OLTInto,"^",6)
	Set Instru=$p(OLTInto,"^",7)
	Set Priority=$p(OLTInto,"^",8)
	
	If StDate["-" Set StDate=$zdh(StDate,3)
	If EndDate["-" Set EndDate=$zdh(EndDate,3)
	Set CurDate=+$h
	Do jugeitmnum^DHCJFOLT(ArcRowid,TarRowid)
	Set JudgeNum=P9
	;Quit:JudgeNum>0 """"_"收费项目不能重复添加!"_""""
	Set OrderFlag=$$GetOrdLinkTar^DHCJFTITMP(ArcRowid)
	Quit:((OrderFlag="Y")&(StDate<=CurDate)) """"_"开始日期要晚于当天"_""""

	Kill PLIST
	Set PLIST(2)=ArcRowid
	Set PLIST(3)=TarRowid
	Set PLIST(4)=Qty
	Set PLIST(5)=StDate
	Set PLIST(6)=EndDate
	Set PLIST(7)=Instru
	Set PLIST(8)=Priority
	Set rtn=$$INSERT^DHCJFOLT()
	
	If +rtn=0 Do
	.Set Flag2="DHC_OrderLinkTar",UserTable="User.DHCOrderLinkTar",TableDesc="医嘱项关联收费项表",InsRowid=%ROWID
	.Set JsonStr="{OLTRowId:"_InsRowid_",OLTARCIMDR:"_ArcRowid_",OLTTariffDR:"_TarRowid
	.Set JsonStr=JsonStr_",OLTQty:"_Qty_",OLTStartDate:"_StDate_",OLTEndDate:"_EndDate
	.Set JsonStr=JsonStr_",OLTInstDR:"_Instru_",OLTPriorityDR:"_Priority_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"插入","A",JsonStr)
	
	Set rtn=""""_rtn_""_""""
	Quit rtn
}

/// w ##class(DHCBILLConfig.DHCBILLFIND).UpdateOrderLinkTar("1||1^11^2014-07-25^^12^1.04^^^7185",1,2)
ClassMethod UpdateOrderLinkTar(OLTInto, Guser, HospID)
{
	Set ^TMP("tt")=OLTInto
	Set ArcRowid=$p(OLTInto,"^",1)
	Set TarRowid=$p(OLTInto,"^",2)
	Set StDate=$p(OLTInto,"^",3)
	Set EndDate=$p(OLTInto,"^",4)
	Set Qty=$p(OLTInto,"^",5)
	Set Price=$p(OLTInto,"^",6)
	Set Instru=$p(OLTInto,"^",7)
	Set Priority=$p(OLTInto,"^",8)
	Set OLTRowid=$p(OLTInto,"^",9)
	Set OldQty=$p(^DHCOLT(OLTRowid),"^",3)
	
	Set OrderFlag=$$GetOrdLinkTar^DHCJFTITMP(ArcRowid)
	Quit:((OrderFlag="Y")&(Qty'=OldQty)) """"_"医嘱项已使用,数量不能修改"_""""

	If StDate["-" Set StDate=$zdh(StDate,3)
	If EndDate["-" Set EndDate=$zdh(EndDate,3)
	Set CurDate=+$h
	Quit:((EndDate<CurDate)&(OrderFlag="Y")) """"_"结束日期不能早于当天"_""""

	Set OldArcRowid=$p(^DHCOLT(OLTRowid),"^",1)
	Set OldTarRowid=$p(^DHCOLT(OLTRowid),"^",2)
	Set OldQty=$p(^DHCOLT(OLTRowid),"^",3)
	Set OldStDate=$p(^DHCOLT(OLTRowid),"^",3)
	Set OldEndDate=$p(^DHCOLT(OLTRowid),"^",4)
	Set OldInstru=$p(^DHCOLT(OLTRowid),"^",5)
	Set OldPriority=$p(^DHCOLT(OLTRowid),"^",6)

	Kill PLIST
	Set PLIST(2)=ArcRowid
	Set PLIST(3)=TarRowid
	Set PLIST(4)=Qty
	Set PLIST(5)=StDate
	Set PLIST(6)=EndDate
	Set PLIST(7)=Instru
	Set PLIST(8)=Priority
	Set rtn=$$UPDATE^DHCJFOLT(OLTRowid)
	
	If +rtn=0 Do
	.Set Flag2="DHC_OrderLinkTar",UserTable="User.DHCOrderLinkTar",TableDesc="医嘱项关联收费项表",InsRowid=OLTRowid
	.Set JsonStr="{OLTRowId:"_InsRowid_",OLTARCIMDR:"_ArcRowid_",OLTTariffDR:"_TarRowid
	.Set JsonStr=JsonStr_",OLTQty:"_Qty_",OLTStartDate:"_StDate_",OLTEndDate:"_EndDate
	.Set JsonStr=JsonStr_",OLTInstDR:"_Instru_",OLTPriorityDR:"_Priority_"}" 
	.Set JsonStrOld="{OLTRowId:"_InsRowid_",OLTARCIMDR:"_OldArcRowid_",OLTTariffDR:"_OldTarRowid
	.Set JsonStrOld=JsonStrOld_",OLTQty:"_OldQty_",OLTStartDate:"_OldStDate_",OLTEndDate:"_OldEndDate
	.Set JsonStrOld=JsonStrOld_",OLTInstDR:"_OldInstru_",OLTPriorityDR:"_OldPriority_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"修改","U",JsonStr,JsonStrOld)
	Set rtn=""""_rtn_""_""""
	Quit rtn
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindTarUpdInfo")
Query FindTarUpdInfo(StDate, EndDate) As websys.Query(ROWSPEC = "TarDesc:%String,TarUpPro:%String,TarOldInfo:%String,TarNewInfo:%String,TarUpDate:%String,TarUpTime:%String,TarUpUser:%String,TarRowid:%String")
{
}

ClassMethod FindTarUpdInfoExecute(ByRef qHandle As %Binary, StDate, EndDate) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	If ((StDate="")||(EndDate=""))  Quit $$$OK
	
	Set Num=$$FindTariUpdInfo^DHCJFFIND(StDate,EndDate)
	If (Num=0) Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	For i=1:1:Num d
	.Do list^DHCJFFIND(i)
	.Set UpdInfo=PLIST(i)
	.Set TarDesc=$p(UpdInfo,"^",2)
	.Set TarUpPro=$p(UpdInfo,"^",3)
	.Set TarOldInfo=$p(UpdInfo,"^",4)
	.Set TarNewInfo=$p(UpdInfo,"^",5)
	.Set TarUpDate=$p(UpdInfo,"^",6)
	.Set TarUpTime=$p(UpdInfo,"^",7)
	.Set TarUpUser=$p(UpdInfo,"^",8)
	.Set TarRowid=$p(UpdInfo,"^",9)
	.Do OutputRowUpt

	Quit $$$OK
OutputRowUpt
	Set Data=$lb(TarDesc,TarUpPro,TarOldInfo,TarNewInfo,TarUpDate,TarUpTime,TarUpUser,TarRowid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOrderLinkTarInfo(Guser, job, HospID)
{
	Kill ^TMP("OrderLinkTar",Guser,job)
	Kill ^TMP("OrderLinkTar1",Guser,job)
	Set Rowid=""
	For  Set Rowid=$o(^TMP("FindArcItm",Guser,job,Rowid)) Quit:Rowid=""  Do
	.Quit:Rowid=0
	.Set ArcRowid=$p(^TMP("FindArcItm",Guser,job,Rowid),"^",7)
	.Do ..GetTarInfoByArc(ArcRowid,HospID,Rowid,Guser,job)
	
	Set ^TMP("OrderLinkTar1",Guser,job,1)="医嘱项代码^医嘱名称^医嘱大类^医嘱子类^医嘱项价格^收费项代码^收费项名称^收费项数量^开始日期^结束日期^收费项价格"
	Set Rowid="",Count=2
	For  Set Rowid=$o(^TMP("OrderLinkTar",Guser,job,Rowid)) Quit:Rowid=""  Do
	.Quit:Rowid=0
	.Set Sub=""
	.For  Set Sub=$o(^TMP("OrderLinkTar",Guser,job,Rowid,Sub)) Quit:Sub=""  Do
	..Quit:Sub=0
	..Set ^TMP("OrderLinkTar1",Guser,job,Count)=^TMP("OrderLinkTar",Guser,job,Rowid,Sub)
	..Set Count=Count+1
	
	Set Num=$o(^TMP("OrderLinkTar1",Guser,job,""),-1)
	Kill ^TMP("OrderLinkTar",Guser,job)
	
	Quit Num
}

ClassMethod GetTarInfoByArc(ArcRowid, HospID, Rowid, Guser, job)
{
	Set TArcCode=$p(^TMP("FindArcItm",Guser,job,Rowid),"^",1)
	Set TArcDesc=$p(^TMP("FindArcItm",Guser,job,Rowid),"^",2)
	Set TOrderCat=$p(^TMP("FindArcItm",Guser,job,Rowid),"^",3)
	Set TArcItmCat=$p(^TMP("FindArcItm",Guser,job,Rowid),"^",4)
	Set TArcPrice=$p(^TMP("FindArcItm",Guser,job,Rowid),"^",9)
	set Row=0
	set rs=##Class(%ResultSet).%New("DHCBILLConfig.DHCBILLFIND:FindTarByArc")
	If rs.QueryIsValid() { 
		Set Status=rs.Execute(ArcRowid,HospID)
		Set columns = rs.GetColumnCount()
		While rs.Next() {
			Set Row=Row+1
			Set TarCode=rs.GetDataByName("TarCode")
			Set TarDesc=rs.GetDataByName("TarDesc")
			Set TarQty=rs.GetDataByName("TarQty")
			Set TarStDate=rs.GetDataByName("TarStDate")
			Set TarEndDate=rs.GetDataByName("TarEndDate")
			Set TarPrice=rs.GetDataByName("TarPrice")
			If Row=1 {
				Set ^TMP("OrderLinkTar",Guser,job,Rowid,Row)=TArcCode_"^"_TArcDesc_"^"_TOrderCat_"^"_TArcItmCat_"^"_TArcPrice
				Set ^TMP("OrderLinkTar",Guser,job,Rowid,Row)=^TMP("OrderLinkTar",Guser,job,Rowid,Row)_"^"_TarCode_"^"_TarDesc_"^"_TarQty_"^"_TarStDate_"^"_TarEndDate_"^"_TarPrice
			}else{
				Set ^TMP("OrderLinkTar",Guser,job,Rowid,Row)=""_"^"_""_"^"_""_"^"_""_"^"_""
				Set ^TMP("OrderLinkTar",Guser,job,Rowid,Row)=^TMP("OrderLinkTar",Guser,job,Rowid,Row)_"^"_TarCode_"^"_TarDesc_"^"_TarQty_"^"_TarStDate_"^"_TarEndDate_"^"_TarPrice
			}
		}
	}
	Quit
}

ClassMethod GetLinkData(Guser, job, num)
{
	q ^TMP("OrderLinkTar1",Guser,job,num)
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindUpBaseInfo","","","","2015-10-30^2015-10-30","^","^","","2","1")
Query FindUpBaseInfo(TarAlias, TarCode, TarDesc, AvailDate, ExpirationDate, UpdDate, TarRowid, HospID, Guser) As websys.Query(ROWSPEC = "TTarRowid:%String,TUBIRowid:%String,TTarDesc:%String,TUBIAvailDate:%String,TUBIAvailTime:%String,TUBIExpirationDate:%String,TUBIExpirationTime:%String,TUBIUpdDate:%String,TUBIUpdTime:%String,TUBIUpdUser:%String,TUBIUpdHospDesc:%String")
{
}

ClassMethod FindUpBaseInfoExecute(ByRef qHandle As %Binary, TarAlias, TarCode, TarDesc, AvailDate, ExpirationDate, UpdDate, TarRowid, HospID, Guser) As %Status
{
	Set ^TMP("tt")=TarAlias_","_TarCode_","_TarDesc_","_AvailDate_","_ExpirationDate_","_UpdDate_","_TarRowid_","_HospID_","_Guser
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set AvailDateS=$p(AvailDate,"^",1)
	Set AvailDateE=$p(AvailDate,"^",2)
	Set ExpirationDateS=$p(ExpirationDate,"^",1)
	Set ExpirationDateE=$p(ExpirationDate,"^",2)
	Set UpdDateS=$p(UpdDate,"^",1)
	Set UpdDateE=$p(UpdDate,"^",2)
	
	If AvailDateS'="" Set AvailDateS=$zdh(AvailDateS,3)
	If AvailDateE'="" Set AvailDateE=$zdh(AvailDateE,3)
	If ExpirationDateS'="" Set ExpirationDateS=$zdh(ExpirationDateS,3)
	If ExpirationDateE'="" Set ExpirationDateE=$zdh(ExpirationDateE,3)
	If UpdDateS'="" Set UpdDateS=$zdh(UpdDateS,3)
	If UpdDateE'="" Set UpdDateE=$zdh(UpdDateE,3)
	
	If TarRowid'="" Do
	.Set UBIRowid=""
	.For  Set UBIRowid=$o(^DHCTARIUBI(0,"TARI",TarRowid,UBIRowid)) Quit:UBIRowid=""  Do
	..Quit:UBIRowid=0
	..Do GetUBIInfo(UBIRowid)
	Else  Do
	.Set TarRowid=""
	.For  Set TarRowid=$o(^DHCTARIUBI(0,"TARI",TarRowid)) Quit:TarRowid=""  Do
	..Quit:TarRowid=0
	..Set UBIRowid=""
	..For  Set UBIRowid=$o(^DHCTARIUBI(0,"TARI",TarRowid,UBIRowid)) Quit:UBIRowid=""  Do
	...Quit:UBIRowid=0
	...Set TarRowid=$p(^DHCTARIUBI(UBIRowid),"^",1)
	...Set Code=$p(^DHCTARI(TarRowid),"^",1)
	...Set Desc=$p(^DHCTARI(TarRowid),"^",2)
	...Set AliasSub="",Count=0
	...If '$d(^DHCTARAL("A",TarRowid)) Set Count=1
	...For  Set AliasSub=$o(^DHCTARAL("A",TarRowid,AliasSub)) Quit:AliasSub=""  Do
	....Quit:AliasSub=0
	....Set Alias=$p(^DHCTARAL(AliasSub),"^",3)
	....Quit:((Alias'[TarAlias)&(TarAlias'=""))
	....Set Count=Count+1
	...b
	...Quit:((Count=0)!((TarCode'="")&(Code'[TarCode))!((TarDesc'="")&(Desc'[TarDesc)))
	...Do GetUBIInfo(UBIRowid)
	Quit $$$OK
	
GetUBIInfo(UBIRowid)
	Set UBIAvailDate=$p(^DHCTARIUBI(UBIRowid),"^",2)
	Set UBIAvailTime=$p(^DHCTARIUBI(UBIRowid),"^",3)
	Set UBIExpirationDate=$p(^DHCTARIUBI(UBIRowid),"^",4)
	Set UBIExpirationTime=$p(^DHCTARIUBI(UBIRowid),"^",5)
	Set UBIUpdDate=$p(^DHCTARIUBI(UBIRowid),"^",6)
	Set UBIUpdTime=$p(^DHCTARIUBI(UBIRowid),"^",7)
	Set UBIUpdUser=$p(^DHCTARIUBI(UBIRowid),"^",8)
	Set UBIUpdHospDr=$p(^DHCTARIUBI(UBIRowid),"^",9)

	Quit:(AvailDateS'="")&(UBIAvailDate<AvailDateS)
	Quit:(AvailDateE'="")&(UBIAvailDate>AvailDateE)
	Quit:(ExpirationDateS'="")&(UBIExpirationDate<ExpirationDateS)
	Quit:(ExpirationDateE'="")&(UBIExpirationDate>ExpirationDateE)
	Quit:(UpdDateS'="")&(UBIUpdDate<UpdDateS)
	Quit:(UpdDateE'="")&(UBIUpdDate>UpdDateE)
	Quit:(HospID'="")&(UBIUpdHospDr'=HospID)

	If UBIAvailDate'="" Set UBIAvailDate=$zd(UBIAvailDate,3)
	If UBIExpirationDate'="" Set UBIExpirationDate=$zd(UBIExpirationDate,3)
	If UBIUpdDate'="" Set UBIUpdDate=$zd(UBIUpdDate,3)
	If UBIAvailTime'="" Set UBIAvailTime=$zt(UBIAvailTime)
	If UBIExpirationTime'="" Set UBIExpirationTime=$zt(UBIExpirationTime)
	If UBIUpdTime'="" Set UBIUpdTime=$zt(UBIUpdTime)
	Set UBIUpdUser=$p(^SSU("SSUSR",UBIUpdUser),"^",2)
	Set UBIUpdHospDesc=""
	If UBIUpdHospDr'="" Set UBIUpdHospDesc=$p(^CT("HOSP",UBIUpdHospDr),"^",2)
	Set tTarDesc=$p(^DHCTARI(TarRowid),"^",2)
	Do OutputRowUBI
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUBI
	Set Data=$lb(TarRowid,UBIRowid,tTarDesc,UBIAvailDate,UBIAvailTime,UBIExpirationDate,UBIExpirationTime,UBIUpdDate,UBIUpdTime,UBIUpdUser,UBIUpdHospDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLFIND","FindUpBaseDetail",15)
Query FindUpBaseDetail(UBIRowid) As websys.Query(ROWSPEC = "TUBDRowid:%String,TUBDItemDesc:%String,TUBDOldInfo:%String,TUBDNewInfo:%String,TFlag:%String")
{
}

ClassMethod FindUpBaseDetailExecute(ByRef qHandle As %Binary, UBIRowid) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set UBDSub=0
	For  Set UBDSub=$o(^DHCTARIUBI(UBIRowid,"D",UBDSub)) Quit:UBDSub=""  Do
	.Set UBDRowid=UBIRowid_"||"_UBDSub
	.Set UBDItemCode=$p(^DHCTARIUBI(UBIRowid,"D",UBDSub),"^",3)
	.Set UBDItemDesc=$p(^DHCTARITEMFIELDCONFIG(UBDItemCode),"^",2)
	.Quit:((UBDItemCode=11)!(UBDItemCode=12)!(UBDItemCode=13)!(UBDItemCode=14)!(UBDItemCode=15))
	.Set UBDOldInfo=$p(^DHCTARIUBI(UBIRowid,"D",UBDSub),"^",4)
	.Set UBDNewInfo=$p(^DHCTARIUBI(UBIRowid,"D",UBDSub),"^",5)
	.If UBDItemCode="3" Do	;单位
	..If UBDOldInfo'="" Set UBDOldInfo=$p(^CT("UOM",UBDOldInfo),"^",2)
	..If UBDNewInfo'="" Set UBDNewInfo=$p(^CT("UOM",UBDNewInfo),"^",2)
	.If UBDItemCode="4" Do	;收费项目子类
	..If UBDOldInfo'="" Set UBDOldInfo=$p(^DHCTarC("SC",UBDOldInfo),"^",2)
	..If UBDNewInfo'="" Set UBDNewInfo=$p(^DHCTarC("SC",UBDNewInfo),"^",2)
	.If UBDItemCode="5" Do	;会计费用子类
	..If UBDOldInfo'="" Set UBDOldInfo=$p(^DHCTarC("AC",UBDOldInfo),"^",2)
	..If UBDNewInfo'="" Set UBDNewInfo=$p(^DHCTarC("AC",UBDNewInfo),"^",2)
	.If UBDItemCode="6" Do	;门诊费用子类
	..If UBDOldInfo'="" Set UBDOldInfo=$p(^DHCTarC("OC",UBDOldInfo),"^",2)
	..If UBDNewInfo'="" Set UBDNewInfo=$p(^DHCTarC("OC",UBDNewInfo),"^",2)
	.If UBDItemCode="7" Do	;经济核算子类
	..If UBDOldInfo'="" Set UBDOldInfo=$p(^DHCTarC("EC",UBDOldInfo),"^",2)
	..If UBDNewInfo'="" Set UBDNewInfo=$p(^DHCTarC("EC",UBDNewInfo),"^",2)
	.If UBDItemCode="8" Do	;病案首页子类
	..If UBDOldInfo'="" Set UBDOldInfo=$p(^DHCTarC("MC",UBDOldInfo),"^",2)
	..If UBDNewInfo'="" Set UBDNewInfo=$p(^DHCTarC("MC",UBDNewInfo),"^",2)
	.If UBDItemCode="17" Do	;住院费用子类
	..If UBDOldInfo'="" Set UBDOldInfo=$p(^DHCTarC("IC",UBDOldInfo),"^",2)
	..If UBDNewInfo'="" Set UBDNewInfo=$p(^DHCTarC("IC",UBDNewInfo),"^",2)
	.If UBDItemCode="21" Do	;新病案首页子类
	..If UBDOldInfo'="" Set UBDOldInfo=$p(^DHCTarC("MCNew",UBDOldInfo),"^",2)
	..If UBDNewInfo'="" Set UBDNewInfo=$p(^DHCTarC("MCNew",UBDNewInfo),"^",2)
	
	.If UBDItemCode="68" Do ; 创建人
	..If UBDOldInfo'="" Set UBDOldInfo=$p(^SSU("SSUSR",UBDOldInfo),"^",2)
	..If UBDNewInfo'="" Set UBDNewInfo=$p(^SSU("SSUSR",UBDNewInfo),"^",2)
	.If UBDItemCode="69" Do ; 创建日期
	..If UBDOldInfo'="" Set UBDOldInfo=$zd(UBDOldInfo,3)
	..If UBDNewInfo'="" Set UBDNewInfo=$zd(UBDNewInfo,3)
	.If UBDItemCode="70" Do ; 创建时间
	..If UBDOldInfo'="" Set UBDOldInfo=$zt(UBDOldInfo)
	..If UBDNewInfo'="" Set UBDNewInfo=$zt(UBDNewInfo)
	.Set Flag=1
	.If UBDOldInfo=UBDNewInfo Set Flag=0
	.Do OutputRowUBD
	Quit $$$OK
OutputRowUBD
	Set Data=$lb(UBDRowid,UBDItemDesc,UBDOldInfo,UBDNewInfo,Flag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// w ##class(DHCBILLConfig.DHCBILLFIND).EvalJSON("")
ClassMethod EvalJSON(instr As %String) As %String
{
	n (instr)
	s mystr = instr
	q:(mystr="") mystr
	;s mystr = ..Replace(mystr,"\", "\\")
	;s mystr = ..Replace(mystr,"'", "\'")
	;s mystr = ..Replace(mystr,"""", "\""")
	;s mystr = ..Replace(mystr,$c(13), "")
	;s mystr = ..Replace(mystr,$c(10), "")
	
	s mystr=##class(web.UDHCJFBaseCommon).Replace(mystr,"\", "\\")
	s mystr=##class(web.UDHCJFBaseCommon).Replace(mystr,"'", "\'")
	s mystr=##class(web.UDHCJFBaseCommon).Replace(mystr,"""", "\""")
	s mystr=##class(web.UDHCJFBaseCommon).Replace(mystr,$c(13), "")
	s mystr=##class(web.UDHCJFBaseCommon).Replace(mystr,$c(10), "")
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	k myary
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

}
