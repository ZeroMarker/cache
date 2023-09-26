/// Description: insert group's information into PaADM
/// test: w ##class(web.DHCPE.TransGrpAsADM).Main(27, 10125, 577, 10125) //(gAdmId , userId , regLocId ,regDocId )
Class web.DHCPE.TransGrpAsADM Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

Property objGAdm As User.DHCPEGADM;

Property objGBaseInfo As User.DHCPEGBaseInfo;

Property RegLocId As %String(TRUNCATE = 1);

Property RegDocId As %String(TRUNCATE = 1);

Property UserId As %String(TRUNCATE = 1);

Method MainEntrance(gAdmId As %String, userId As %String, regLocId As %String, regDocId As %String) As %String
{
	s retStr=""
	s ..objGAdm=##class(User.DHCPEGADM).%OpenId(gAdmId)
	s ..objGBaseInfo=..objGAdm.GADMGBIDR
	s ..RegLocId=regLocId
	s ..RegDocId=regDocId
	s ..UserId=userId
	//b //0724InsertPatMas
	s retStr=retStr_..InsertPatMas()
	i retStr'="" goto exit
	//b //0724InsertAdm
	s retStr=retStr_..InsertGAdm()
	i retStr'="" goto exit
	//b //0724InsertOEItem
	s retStr=retStr_..InsertOEItem()
	i retStr'="" goto exit
	
exit
	q retStr
}

// 插入团体代表的费用医嘱

Method InsertPatMas() As %String [ Private ]
{
	q:..objGBaseInfo.GBIPAPMIDR'="" ""
	s nextNo=..GetNextPatNO()
	//00000101^bob^女^1972-04-12^147258369^^^公费^420111780101401^^工作单位^地址  
	//"patCardId^patName^Gender^Birthday^mobileNO^^^^CertCardNO^corporator^Address"
	s patInfo=nextNo_"^"_..objGBaseInfo.GBIDesc_"^男^1900-1-1^^^^公费^^^^"
	s ret=##class(web.DHCOPReg).CommitPatDetail("","",patInfo)
	
	q:(ret'="1") "  ERROR:保存客人基本信息时出错"
	
	s patId=##class(web.DHCPE.TransAdmInfo).patNo2Id(nextNo)	
	s ..objGBaseInfo.GBIPAPMIDR=patId
	s retStatus=..objGBaseInfo.%Save()
	//b
	q:($$$ISOK(retStatus)'=1) "  ERROR: An Error occurs in objGBaseInfo.%Save() in web.DHCPE.TransGrpAsADM.InsertPatMas"
	
	q ""
}

Method InsertGAdm() As %String [ Private ]
{
	q:..objGAdm.GADMDelegateADMDR'="" "ERROR: objGAdm.GADMDelegateADMDR is null in InsertAdm^"_$zn
	//b //0724InsertAdm1111111111111
	s patId=..objGBaseInfo.GBIPAPMIDR
	q:(patId="") "ERROR: PatCardId is null, in InsertAdm^"_$zn
	s hisAdmId=##Class(web.DHCPE.PEApp).PEPAADMBroker(, , patId, ..RegLocId, ..RegDocId, "", ..UserId)
	//b //0724InsertAdm222222222222
	//d ##Class(web.DHCPE.PEApp).PEPAADMBroker("","",100,577,1112,"",10125)
	b:((hisAdmId="")||(hisAdmId=0)) ;"InsertAdm"
	q:((hisAdmId="")||(hisAdmId=0)) "  ERROR:An error occurs when registe in  web.DHCPE.TransGrpAsADM.InsertAdm"
	
	s ..objGAdm.GADMDelegateADMDR=hisAdmId	
	s retStatus=..objGAdm.%Save()
	q:($$$ISOK(retStatus)'=1) "  ERROR: An Error occurs in the HisIAdm.%Save()  in  web.DHCPE.TransGrpAsADM.InsertAdm"
	
	q ""
}

Method InsertOEItem() As %String [ Private ]
{
	s OEIId=""
	s amdId=..objGAdm.GADMDelegateADMDR
	s CurLoc=$P($G(^PAADM(amdId)),"^",4)
	//s arcItemId=^DHCPESetting("DHCPE","Group'sOEArcItemId")
	s arcItemId=^DHCPESetting("DHCPE","Group'sOEArcItemId",CurLoc)

	&sql(select oeori_rowid into :OEIId FROM SQLUSER.OE_ORDItem where oeori_oeord_parref->oeord_ADM_dr=:amdId)
	q:OEIId'="" ""
	//hisItemSpec="ordItemID^qty^loc^price^Speciment^AdmReason"
	s itemInfo=arcItemId_"^1^"_..RegLocId_"^"_..objGAdm.GADMAccountAmount_"^^"
	//s ^Bob("temp",$zn,"OEItemInfo")=itemInfo
	s ret=##class(web.DHCPE.PEApp).InsertOrdItem(amdId, itemInfo, ..UserId,..RegLocId, ..UserId)
	//return "0^48786||1"
	b:($p(ret,"^",2))'[("||") ;"  ERROR: in web.DHCPE.TransGrpAsADM.InsertOEItem"
	
	q ""
}

/// test: w ##class(web.DHCPE.TransGrpAsADM).GetNextPatNO()
ClassMethod GetNextPatNO() As %String
{
	s nextNo=$g(^DHCPE("Others","GroupNextAdmNO"))
	i nextNo=""  s nextNo=^DHCPESetting("DHCPE","GroupPatNO_Begin")
	s newNo=+nextNo
	s newNo=newNo+1
	s newNo=$e("00000000",1,8-$l(newNo))_newNo
	s ^DHCPE("Others","GroupNextAdmNO")=newNo
	q nextNo
}

/// return: "":correct, else: error information
ClassMethod Main(gAdmId As %String, userId As %String, regLocId As %String, regDocId As %String) As %String
{
	s ^lisatest("0724TransGrpAsADM")=gAdmId_"^"_userId_"^"_regLocId_"^"_regDocId
	s obj=##class(web.DHCPE.TransGrpAsADM).%New()
	s ret=obj.MainEntrance(gAdmId , userId , regLocId ,regDocId )
	q ret
}

/// ******************************************************************
/// follow add by jdl
/// 插入PA_Patmas表--团体代表
/// GBaseInfoID:DHC_PE_GBaseInfo-->GBI_RowId
ClassMethod InsertPatMasNew(GBaseInfoID) As %String
{
	s (patid,gdesc)=""
	if GBaseInfoID=""  
	{q "未传入团体基本信息ID!"
	}
	&SQL(Select GBI_PAPMI_DR,GBI_Desc into :patid,:gdesc from SQLUSER.DHC_PE_GBaseInfo
	 	Where GBI_RowId=:GBaseInfoID
		)
	if %ROWCOUNT '=1 q "找不到相应的团体基本信息!"
	if (patid="")
	{
		s nextNo=..GetNextPatNO()
		s patInfo=nextNo_"^"_gdesc_"^男^1900-1-1^^^^公费^^^^"
		s ret=##class(web.DHCOPReg).CommitPatDetail("","",patInfo)
		q:(ret'="1") "  ERROR:保存客人基本信息时出错!"
		s patid=##class(web.DHCPE.TransAdmInfo).patNo2Id(nextNo)
		&SQL(Update SQLUSER.DHC_PE_GBaseInfo set GBI_PAPMI_DR=:patid 
			Where GBI_RowId=:GBaseInfoID )
		if SQLCODE q "更新团体基本信息失败!"
	}
	q patid
}

/// 插入表PA_ADM--团体代表
/// GAdmID: SQLUSER.DHC_PE_GADM-->GADM_RowID
/// patid:DHC_PE_GBaseInfo-->GBI_PAPMI_DR
/// regLocId:登记科室
/// regDocId：登记医生
/// userId：操作人员
ClassMethod InsertGAdmNew(GAdmID, patid, regLocId, regDocId, userId) As %String
{
	s delegateAdmId=""
	if (patid="") q "未传入客人基本信息ID!"
	&SQL(Select GADM_DelegateADM_DR into :delegateAdmId
		from SQLUSER.DHC_PE_GADM
	 	Where GADM_RowId=:GAdmID
		)
	if %ROWCOUNT '=1 q "找不到相应的团体登记信息!"
	if (delegateAdmId="")
	{
		s delegateAdmId=##Class(web.DHCPE.PEApp).PEPAADMBroker(, , patid, regLocId, regDocId, "", userId)
		q:((delegateAdmId="")||(delegateAdmId=0)) "  ERROR:An error occurs when registe in  web.DHCPE.TransGrpAsADM.InsertAdm"
		&SQL(Update SQLUSER.DHC_PE_GADM set GADM_DelegateADM_DR=:delegateAdmId 
			Where GADM_RowId=:GAdmID )
		if SQLCODE q "更新团体基本信息失败!"
	}
	q delegateAdmId
}

/// 插入团体代表的费用医嘱
/// admid: SQLUSER.DHC_PE_GADM-->GADM_DelegateADM_DR
/// amount:团体体检最终金额
/// regLocId:登记科室
/// regDocId：登记医生
/// userId：操作人员
ClassMethod InsertOEItemNew(admid, amount, regLocId, regDocId, userId) As %String
{
	s OEIId=""
	if (admid="") q "未传入客人登记信息ID!"
	s CurLoc=$P($G(^PAADM(admid)),"^",4)
	//s arcItemId=$g(^DHCPESetting("DHCPE","Group'sOEArcItemId"))
	s arcItemId=$g(^DHCPESetting("DHCPE","Group'sOEArcItemId",CurLoc))

	if (arcItemId="") q "没有设置团体客户体检的医瞩项!"
	&SQL(select arcim_rowid into :arcItemId from SQLUSER.arc_itmmast where arcim_rowid=:arcItemId)
	if (arcItemId="") q "设置的团体客户体检的医瞩项不存在!"
	
	&sql(select oeori_rowid into :OEIId FROM SQLUSER.OE_ORDItem where oeori_oeord_parref->oeord_ADM_dr=:admid)
	q:OEIId'="" ""
	//hisItemSpec="ordItemID^qty^loc^price^Speciment^AdmReason"
	s itemInfo=arcItemId_"^1^"_regLocId_"^"_amount_"^^"
	//s ^Bob("temp",$zn,"OEItemInfo")=itemInfo
	s ret=##class(web.DHCPE.PEApp).InsertOrdItem(admid, itemInfo,userId,regLocId,userId)
	//return "0^48786||1"
	if ($p(ret,"^",2))'[("||") q "生成团体体检医瞩失败!"
}

}
