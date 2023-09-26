/// Description: 将CRM中相关的体检登记信息传入His系统中，包括客户基本信息、体检登记信息和
/// 体检项目
/// Test: d ##class(web.DHCPE.TransAdmInfo).test()
/// ----------------------
/// modified 2006/5/31
/// description: add bloodType, Profession etc in function TranPatInfo
/// 
Class web.DHCPE.NewClass1 Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

Property crmRegId As %String(TRUNCATE = 1);

Property patCardId As %String(TRUNCATE = 1);

Property patId As %String(TRUNCATE = 1);

Property hisUserId As %String(TRUNCATE = 1);

/// 体检中心
Property hisLocId As %String(TRUNCATE = 1);

Property LABDB As %String(TRUNCATE = 1);

Property MEDDATA As %String(TRUNCATE = 1);

Property hisAdmId As %String(TRUNCATE = 1);

Property PEPATTYPE As %String(TRUNCATE = 1) [ InitialExpression = "公费" ];

Property PEREGDocId As %String(TRUNCATE = 1);

Property CRMGateway As web.DHCPE.CRM.IGateway;

Property STATUSVerifiedd As %String(TRUNCATE = 1) [ InitialExpression = "1" ];

Property STATUSStoped As %String(TRUNCATE = 1) [ InitialExpression = "4" ];

Property STATUSExecuted As %String(TRUNCATE = 1) [ InitialExpression = "6" ];

Property objHisIAdm As User.DHCPEIADM;

Method %OnNew(newName As %String) As %Status
{
	s ..MEDDATA=^DHCPESetting("NAMESPACE","MEDDATA")
	s ..LABDB=^DHCPESetting("NAMESPACE","LABDATA")
	s ..hisLocId=%session.Get("LOGON.CTLOCID")
	s ..PEREGDocId=^DHCPESetting("DHCPE","PhyExamDrId",..hisLocId)
	s ..PEPATTYPE=^DHCPESetting("DHCPE","PEPatType")
	s ..CRMGateway=##class(web.DHCPE.CRM.Factory).GetGateway()
	q $$$OK
}

/*
/// Description: 主程序
/// Return: 正常："", 错误：错误信息，　
/// crmRegIdNew--DHC_PE_PreIAdm的RowId  //MLH Modified by 2006-07-20
Method mainEntrance(crmRegIdNew As %String, hisUserId As %String = "") As %String
{
	s strErr=""
	s ..crmRegId=crmRegIdNew
	s ..hisUserId=hisUserId
	s ..objHisIAdm=##class(HandlerIAdm).GetAdmByCrmAdm(..crmRegId) //用DHC_PE_PreIAdm的RowId得到DHC_PE_IADM表 //MLH Modified by 2006-07-20
	//q:((..objHisIAdm.%Id()'="")&&(..objHisIAdm.IADMStatus'="REGISTERED")&&(..objHisIAdm.IADMStatus'="PREREG")) "Error:已经到达，重请登记请先取消到达!"
	q:((..objHisIAdm.%Id()'="")&&(..objHisIAdm.IADMStatus'="PREREG")) "Error:已经到达，重请登记请先取消到达!"
	//TStart
	w "/*-----------transBaseInfo", !
	s strErr=..transBaseInfo()  //插入DHC_PE_IADM表
	if strErr'=""  goto myError
	w "-----------TranPatInfo", !
	s strErr=..TranPatInfo() ////更新PA_PatMas和PA_Person表
	if strErr'=""  goto myError
	w "-----------Register", !
	s strErr= ..Register()   /////插入PA_ADM表
	if strErr'=""  goto myError
	w "------------InsertReport", !
	s strErr= ..InsertReport()  /////插入DHC_PE_Report表
	if strErr'=""  goto myError
	
	///w "-----------stopOldItems", !
	///s strErr=..stopOldItems()	 /////停医嘱
	///if strErr'=""  goto myError
	w "-----------InsertItems", ! 
	s strErr=..InsertItems()	 /////插入医嘱表
	if strErr'=""  goto myError
	
	//s ..objHisIAdm.IADMStatus="REGISTERED"  
	s ..objHisIAdm.IADMStatus="ARRIVED"  
	d ..objHisIAdm.%Save()
	
	d ..NotifyCRM()   /////传入CRM接口更新表dhc_pe_preiadm和dhc_pe_pregadm的状态
	w "--tranAdm End--",!,"*",!
	//TCommit	
	q strErr
	
myError
	//TRollback
	w "--tranAdm End--",!,"*",!
	q strErr
}



/// 保存挂号时间等基本信息
/// 插入DHC_PE_IADM表
Method transBaseInfo() [ Private ]
{
	s strErr=""	
	s regInfoCurrent=..CRMGateway.GetRegListByPatInf("REGID",..crmRegId) //crmRegId--DHC_PE_PreIAdm的RowId  //MLH Modified by 2006-07-20
	// return: ***$C(1)RegID^PatCardId^PreRegDate^RecordDate^IsAsCharged^Status^CountAmount^DiscountAmount^FinalAmount^PatNAME$C(1)...
	
	//-----从CRM中找到需要的挂号信息------
	q:(regInfoCurrent="") "Error: 从CRM中根据Regid不能取到正确的挂号记录 in transBaseInfo"
	
	s ..patCardId=$P(regInfoCurrent,"^",2)  ///patCardId--PAPMINo //MLH Modified by 2006-07-20
	s ..patId=..patNo2Id(..patCardId)
	s ..objHisIAdm.IADMRegDate=+$h
	s ..objHisIAdm.IADMAsCharged="N"
	i (+$P(regInfoCurrent,"^",5)=1)  s ..objHisIAdm.IADMAsCharged="Y"
	s ..objHisIAdm.IADMStatus=$P(regInfoCurrent,"^",6)
	s ..objHisIAdm.IADMAccountAmount=$p(regInfoCurrent,"^",7)
	s ..objHisIAdm.IADMDiscountedAmount=$p(regInfoCurrent,"^",8)
	s ..objHisIAdm.IADMFactAmount=$p(regInfoCurrent,"^",9)
	d ..objHisIAdm.%Save()
	
	q ""
}

/// 保存客人基本信息
/// 更新PA_Patmas表
Method TranPatInfo() [ Private ]
{
	//------从CRM中找到需要的客户信息--------
	s patInfoSource=..CRMGateway.GetMemberByID("HISCARDID",..patCardId) ///patCardId--PAPMINo //MLH Modified by 2006-07-20
	q:((patInfoSource="")||($l(patInfoSource,$C(1))>1)) "Error: 从CRM中不能取到正确的客户信息"
	
	//------调整His客户基本资料，进行保存-----	
	s specSource="patCardId^patName^Birthday^mobileNO^Address^corporator^CertCardNO^Gender^level"_"^Marital^Email^Zip^BloodType^Profession^Title^Race"
	s specTarget="patCardId^patName^Gender^Birthday^mobileNO^^^^CertCardNO^^corporator^Address"
	//00000101^bob^女^1972-04-12^147258369^^^公费^420111780101401^^工作单位^地址  
	s patInfoTarget=$$strReArrange^DHCPECommon(patInfoSource,specSource,specTarget,"^")
	//w !,patInfoSource,!,specSource
	//s ..objHisIAdm.IADMMemberLevel=$P(patInfoSource,"^",9)
	s $p(patInfoTarget,"^",8)=..PEPATTYPE 
	s ^lisatest("patInfoTarget")=patInfoTarget
	//s patInfoTarget="00000003^张大用^1^1981-07-01^13911011457^^^公费^1001145268700214^^北京移动^北京海淀区皂君庙13号"
	//s ret=##class(web.DHCOPReg).CommitPatDetail("","",patInfoTarget)	//Update表PA_PatMas和PA_Person //Modified by MLH2006-07-20
	///*************重要*******************
	s ret=##class(web.DHCPE.PEApp).CommitPatDetail("","",patInfoTarget)	//Update表PA_PatMas和PA_Person //Modified by MLH2006-07-20
	///**********************************
	q:(ret'="1") "ERROR:保存客人基本信息时出错 in TranPatInfo"
	
	s hisMarital=$p(patInfoSource,"^",9+1)
	s hisEmail=$p(patInfoSource,"^",9+2)
	s hisZip=$p(patInfoSource,"^",9+3)
	s hisBloodtype=$p(patInfoSource,"^",9+4)
	s hisProfession=$p(patInfoSource,"^",9+5)
	s hisTitle=$p(patInfoSource,"^",9+6)
	s hisRace=$p(patInfoSource,"^",9+7)
	
	s hisMaritalDr=$o(^CT("MAR",0,"Code",hisMarital,""))
	i $g(hisZip)'="" s hisZipDr=$o(^CT("ZIP",0,"Code",hisZip,""))
	i $g(hisBloodtypeDr)'="" s hisBloodtypeDr=$o(^PAC("BLDT",0,"Code",hisBloodtype,""))
	s hisPatId=$o(^PAPERi("PAPMI_PatNo",..patCardId,"0"))	
	s hisRemark=hisProfession_"<%1%>"_hisTitle_"<%1%>"_hisRace

	&sql(update sqluser.pa_patmas set papmi_email=:hisEmail where papmi_rowId=:hisPatId)
	&sql(update sqluser.pa_person set PAPER_Marital_DR=:hisMaritalDr
			, PAPER_Zip_DR=:hisZipDr, PAPER_BloodType_DR=:hisBloodtypeDr
		 where paper_rowid=:hisPatId)
	s ..objHisIAdm.IADMRemark=hisRemark
	
	q ""
}


/// ------进行挂号------------（只对新登记有用，更新时不调用此程序）　
Method Register() [ Private ]
{
	s retStr=""
	s IADMPAADM=..objHisIAdm.IADMPAADMDR
	if (IADMPAADM=""){	
		s hisAdmId=##Class(web.DHCPE.PEApp).PEPAADMBroker(, , ..patId, ..hisLocId, ..PEREGDocId, "", ..hisUserId)
		//d ##Class(web.DHCPE.PEApp).PEPAADMBroker("","",100,577,1112,"",10125)
		w "---debug: patId:"_..patId_"   hisLOCId:"_..hisLocId_"   PEREGDocId"_..PEREGDocId
		q:((hisAdmId="")||(hisAdmId=0)) "ERROR:An error occurs when registe！"
		s ..objHisIAdm.IADMPAADMDR=hisAdmId
		//s retStatus=..objHisIAdm.%Save()
		//s ..objHisIAdm.IADMMemberLevel="555"
		d ..objHisIAdm.%Save() //Modified by MLH
		//q:($$$ISOK(retStatus)'=1) "ERROR: An Error occurs in the HisIAdm.%Save()"
	}	
	s ..hisAdmId=..objHisIAdm.IADMPAADMDR
	q retStr
}

/// ------插一条报告状态记录-----------
Method InsertReport()
{
	s myReport=##Class(web.DHCPE.HandlerIAdm).GetReport("IADMID",..objHisIAdm.%Id())
	if (myReport.%Id()=""){
		s myReport.RPTStatus="NA"
		s myReport.RPTIADMDR= ..objHisIAdm
		s retStatus=myReport.%Save()
		q:($$$ISOK(retStatus)'=1) "ERROR: An Error occurs in the TransAdmInfo.InsertReport()"
	}
	q ""
}
*/
/// ------进行体检项目删除---------（只对已经登记过的记录有效）
Method stopOldItems() [ Private ]
{
	s retStr=""
	s ret=""
	s crmExamItems=..CRMGateway.GetExamItemsByRegId(..crmRegId)
	/// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...

	s docName=$p(^CTPCP(..PEREGDocId,1),"^",2)
	s ordStopInfo=..hisUserId_"^"_..PEREGDocId_"^"_docName
	//..ordStopSepc="userid^careprovider^careProviderName"
	s ordId=$o(^OEORD(0,"Adm",..hisAdmId,""))
	if (ordId'=""){
		s ordIChd=$o(^OEORD(ordId,"I","0"))
		while(ordIChd'=""){
			s hisOEItemDr=ordId_"||"_ordIChd
			s objOEItemMatch=##class(HandlerIAdm).GetItemMatch(hisOEItemDr,"HIS")
			s ordIStatus=$p(^OEORD(ordId,"I",ordIChd,1),"^",13)
			i ((objOEItemMatch.%Id()'="")&(ordIStatus'=..STATUSStoped)){
				s strCrmOEIID="^"_objOEItemMatch.CRMOCRMORI_$C(1)
				if ((crmExamItems_$C(1))'[strCrmOEIID){		//如果有hisOEOrdItem表中存在但在CRM传过来的串中不存在，才需要停
					i (ordIStatus=..STATUSExecuted){
						s retStr="ERROR: there are some OEITM have been executied! OEORDItemDr="_hisOEItemDr
						goto errHandler
					}
					
					s CurrentNS=$ZNSPACE
 					ZN ..MEDDATA		
					s ret=$$StopOrdItem^DHCOrdItem(hisOEItemDr,ordStopInfo)
					zn CurrentNS
				}
			}
			s ordIChd=$o(^OEORD(ordId,"I",ordIChd))
		}
	}
	q ""
errHandler
	q retStr
}

/*
/// -------插入体检项目------------
Method InsertItems() [ Private ]
{
	s crmExamItems=..CRMGateway.GetExamItemsByRegId(..crmRegId)
	/// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
	s i=1, hisItemsStr=""
	s retStr=""
	while(i<=$l(crmExamItems,$C(1))){
		s crmItem=$p(crmExamItems,$C(1),i)
		i (crmItem'=""){
			//hisItemSpec="ordItemID^qty^loc^price^Speciment^AdmReason"
			s crmOItemId=$p(crmItem,"^",4)
			s objOItemMatch=##class(HandlerIAdm).GetItemMatch(crmOItemId,"CRM")
			if (objOItemMatch.%Id()=""){
				s locId=$p(crmItem,"^",2)
				s arcItemId=$p(crmItem,"^",1)
				s locId=..GetReceiveLoc(..hisAdmId,arcItemId,locId)
				s hisItem=arcItemId_"^"_locId_"^"_$p(crmItem,"^",2)_"^^"
				s ret=0
				s ret=##class(web.DHCOPCashier).CashierInsertOrdItem(..hisAdmId, hisItem, ..hisUserId,..hisLocId, ..hisUserId)			
				s hisOItemId=$p(ret,"^",2)
				d ##class(web.DHCPE.HandlerIAdm).updateItemMatch(crmOItemId,hisOItemId,..objHisIAdm.%Id())
			}
		}
		s CurrentNS=$ZNSPACE
	 	ZN ..MEDDATA		
		Do presno^aOET1(..hisAdmId)
		ZN CurrentNS
		
		s i=i+1
	}
	
exitEnt	
	q retStr
}
*/
/// test: w ##class(web.DHCPE.TransAdmInfo).GetReceiveLoc(78700, "1482||1")
/// [Previously private]
ClassMethod GetReceiveLoc(paadmId, arcItemId, defLocId As %String = "") As %String
{
	s recLocId=""
	Set rset = ##class(%ResultSet).%New()
	Set rset.ClassName = "web.DHCOPItemMast"
	Set rset.QueryName = "AIMRecLoc"
	
	Do rset.Execute(paadmId, arcItemId)
	While (rset.Next()) 
     {
	     i recLocId=""  s recLocId=rset.Data("RecLocRID")
	     s isDef=(rset.Data("DefRecFlag"))
	     i isDef="Y" {
		 	s recLocId=rset.Data("RecLocRID")
		    quit
	     }
     }
     i recLocId=""  s recLocId=defLocId
     quit recLocId
}

/*
Method NotifyCRM() [ Private ]
{
	//s ret=..CRMGateway.ExamStatusNotify("PERSON",..crmRegId, "REGISTERED","") 
	s ret=..CRMGateway.ExamStatusNotify("PERSON",..crmRegId, "ARRIVED","") //Modified by MLH 20060826
	q ret
}
*/
/// test: w ##class(web.DHCPE.TransAdmInfo).patNo2Id("00130000")
/// 由登记号得到RowId
ClassMethod patNo2Id(patNO)
{
	s patId=$o(^PAPERi("PAPMI_PatNo",patNO,""))
	q patId
}

ClassMethod test()
{
	//crmRegIdNew As %String, hisUserId As %String = ""
	w !, ##Class(web.DHCPE.TransAdmInfo).main(6, 3566)
	//loc:577   doc1112    seqno3examfee4  regfee:5   user:10125
}

/*
/// crmRegIdNew--DHC_PE_PreIAdm的RowId  //MLH Modified by 2006-07-20
ClassMethod main(crmRegIdNew As %String, hisUserId As %String = "") As %String
{
	s ^lisatest("0724temp")=crmRegIdNew_"  "_hisUserId
	s myObj=##Class(TransAdmInfo).%New()
	s retStr= myObj.mainEntrance(crmRegIdNew, hisUserId)	
	q retStr
}
*/
/// ******************************************************************
/// Created by jdl
/// 判断个人所在的团体客户是否已经登记，如果未登记，则自动对该团体进行登记
/// w ##class(web.DHCPE.TransAdmInfo).CheckGAdmCreated(102)
ClassMethod CheckGAdmCreated(PIAdmId As %String)
{
	k IAdmID,PGAdmID,GAdmID,PGTeamID,GTeamID,childsub,result,err
	s GAdmID=""
	s err=0
	s PGAdmID=$p($g(^DHCPEPreIADM(PIAdmId)),"^",2)
	i PGAdmID="" q err    //个人不需要处理
	s GAdmID=$o(^DHCPEGADM(0,"CRMGADM",PGAdmID,""))
	if GAdmID=""
	{
		//生成组ADM
		s userid=%session.Get("LOGON.USERID")
		s locid=%session.Get("LOGON.CTLOCID")
		//s userid=3566
		//s locid=330
		///参数 grpIdNew?也是DHC_PE_PreGADM, grpRegIdNew指向DHC_PE_PreGADM
		//q "PGAdmID:"_PGAdmID_" userid:"_userid_" locid"_locid
		s err= ##class(web.DHCPE.TransGrpInfo).mainNew(PGAdmID,PGAdmID,userid,locid)
		if (err'="") q err
		s err=0
		s GAdmID=$o(^DHCPEGADM(0,"CRMGADM",PGAdmID,""))
		if (GAdmID="") 
		{	s err="生成团体ADM失败!"
		q err		}
	}
	s PGTeamID=$p($g(^DHCPEPreIADM(PIAdmId)),"^",3)
	if PGTeamID="" 
	{	s err="未找到预约分组记录!"
		q err		}
	s childsub=""
	s GTeamID=""
	f  s childsub=$o(^DHCPEGADM(GAdmID,"Team",childsub)) q:(childsub="")||(GTeamID'="")  d
	.i PGTeamID=$p($g(^DHCPEGADM(GAdmID,"Team",childsub)),"^",2) d
	..s GTeamID=GAdmID_"||"_childsub
	if GTeamID="" 
	{	s err="未找到登记分组记录!"
		q err		}
	s IAdmID= $o(^DHCPEIADM(0,"CRMADM",PIAdmId,""))
	//更新个人IADM的GADMDR
	&SQL(Update SQLUser.DHC_PE_IADM set IADM_GADM_DR=:GAdmID,IADM_GTeam_DR=:GTeamID
		Where IADM_RowId=:IAdmID)
	
	if SQLCODE
	{	s err="更新个人ADM的团体信息失败!  SQLCODE="_SQLCODE 				
		q err}
		
	&SQL(Update SQLUser.DHC_PE_PreAudit set PA_GIAdm=:GAdmID
		Where PA_AdmType="G" and PA_CrmAdm=:PGAdmID)	
	if SQLCODE<0
	{	s err="更新团体费用信息失败!  SQLCODE="_SQLCODE 				
		q err}
	
	q err
}

/// -------插入体检项目------------
/// [Previously private]
ClassMethod InsertItems1219bak(crmRegId, admId, iAdmId, userId, locId, MEDDATA)
{
	s crmExamItems=##class(web.DHCPE.CRM.Gateway).GetExamItemsByRegId(crmRegId)
	/// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
	s i=1  //, hisItemsStr=""
	s retStr=""
	Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
	while(i<=$l(crmExamItems,$C(1))){
		s crmItem=$p(crmExamItems,$C(1),i)
			i (crmItem'=""){
				//hisItemSpec="ordItemID^qty^loc^price^Speciment^AdmReason"
				s crmOItemId=$p(crmItem,"^",4)			
				s objOItemMatch=##class(HandlerIAdm).GetItemMatch(crmOItemId,"CRM")
				if (objOItemMatch.%Id()=""){
					s arcItemId=$p(crmItem,"^",1)
					s crmitemid=$p(crmItem,"^",4)
					s crmordent=$p($g(^DHCPEPreIADM($p(crmitemid,"||",1),"ORDITEM",$p(crmitemid,"||",2))),"^",2)
					s arcos1=""
					if crmordent'=""  d
					.//0926 renzwang   取标本名称错误
					.s arcos1=##class(web.DHCPE.PEApp).GetArcSets(crmordent,arcItemId)
					.//s arcos1=$p($g(^DHCPEPreIADM($p(crmordent,"||",1),"ORDENT",$p(crmordent,"||",2))),"^",1)
					.s ^DHCTemp("jdl","InsertOrdItem")="crmordent:"_crmordent_"  arcos:"_arcos1
					//s arcos=$p($g(^DHCPEPreIADM($p(crmitemid,"||",1),"ORDITEM",$p(crmitemid,"||",2))),"^",3)
					s locId=$g(locId)    //Add by MLH20070512
				
					//070816 renzwang
					//s locId=..GetReceiveLoc(admId,arcItemId,locId)
					s ldefLocId=$G(^DHCPESetting("DHCPE","PhyExamLocId"))
					s locId=##class(web.DHCPE.PreItemList).GetRecLoc(3,crmitemid)
					i locId="" s locId=..GetReceiveLoc(admId,arcItemId,ldefLocId)
					i ""=$G(^DHCPESetting("DHCPE","DefaultPAADM")) s ^DHCPESetting("DHCPE","DefaultPAADM")=admId
				
					if locId="" s locId=$p(crmItem,"^",2)
					s hisItem=arcItemId_"^1^"_locId_"^"_$p(crmItem,"^",2)_"^^^"_arcos1
					s ret=0
					if arcos1'="" s ^DHCTemp("jdl","InsertOrdItem","12")="##class(web.DHCPE.PEApp).InsertOrdItem("_admId_","_hisItem_","_userId_","_locId_","_userId_")"
					s ret=##class(web.DHCPE.PEApp).InsertOrdItem(admId, hisItem, userId,locId, userId)			
					s hisOItemId=$p(ret,"^",2)
					//b "before updateItemMatch"
					s gatewayCRM=##class(web.DHCPE.CRM.Factory).GetGateway()
					d gatewayCRM.updateItemMatch(crmOItemId,hisOItemId,iAdmId)				
				}
			}
			//Modified by MLH 20070608
			//s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
			//i TrakVerison="MedTrak" d
			s CurrentNS=$ZNSPACE
			//友谊的，安贞的非TLA医嘱
			ZN MEDDATA
			//Do presno^aOET1(admId)  //Modified by MLH 20071218
			Do presno^aOET1(admId)
			ZN CurrentNS
		s i=i+1
}
	q retStr
}

/// -------插入体检项目------------
/// [Previously private]
ClassMethod InsertItems(crmRegId, admId, iAdmId, userId, locId, MEDDATA)
{
   
     Set UserID=%session.Get("LOGON.USERID")
     s OrdLoc=""
     s OrdLoc=$p(^PAADM(admId),"^",4)
     s crmExamItems=##class(web.DHCPE.CRM.Gateway).GetExamItemsByRegId(crmRegId)
	/// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
	s i=1, hisItemsStr=""
	s retStr=""
	while(i<=$l(crmExamItems,$C(1))){
		s crmItem=$p(crmExamItems,$C(1),i)
		i (crmItem'=""){
			//hisItemSpec="ordItemID^qty^loc^price^Speciment^AdmReason"
			s crmOItemId=$p(crmItem,"^",4)			
			s objOItemMatch=##class(HandlerIAdm).GetItemMatch(crmOItemId,"CRM")
			if (objOItemMatch.%Id()=""){
				//w "crmOItemId:"_crmOItemId,!
				//s locId=$p(crmItem,"^",2)
				s arcItemId=$p(crmItem,"^",1)
				s crmitemid=$p(crmItem,"^",4)
				//s ^DHCTemp("jdl","InsertOrdItem")="crmitemid:"_crmitemid
				s crmordent=$p($g(^DHCPEPreIADM($p(crmitemid,"||",1),"ORDITEM",$p(crmitemid,"||",2))),"^",2)
		    
				s arcos1=""
				if crmordent'=""  d
				.
				.//0926 renzwang   取标本名称错误
				.
				.s arcos1=##class(web.DHCPE.PEApp).GetArcSets(crmordent,arcItemId)
				.//s arcos1=$p($g(^DHCPEPreIADM($p(crmordent,"||",1),"ORDENT",$p(crmordent,"||",2))),"^",1)
				.s ^DHCTemp("jdl","InsertOrdItem")="crmordent:"_crmordent_"  arcos:"_arcos1
				//s arcos=$p($g(^DHCPEPreIADM($p(crmitemid,"||",1),"ORDITEM",$p(crmitemid,"||",2))),"^",3)
				s locId=$g(locId)    //Add by MLH20070512
				
				//070816 renzwang
				//s locId=..GetReceiveLoc(admId,arcItemId,locId)
				s ldefLocId=%session.Get("LOGON.CTLOCID")
				s locId=##class(web.DHCPE.PreItemList).GetRecLoc(3,crmitemid)
				i locId="" s locId=..GetReceiveLoc(admId,arcItemId,ldefLocId)
				i ""=$G(^DHCPESetting("DHCPE","DefaultPAADM",ldefLocId)) s ^DHCPESetting("DHCPE","DefaultPAADM",ldefLocId)=admId
				
				if locId="" s locId=$p(crmItem,"^",2)
				s hisItem=arcItemId_"^1^"_locId_"^"_$p(crmItem,"^",2)_"^^^"_arcos1
				s ret=0
				if arcos1'="" s ^DHCTemp("jdl","InsertOrdItem","12")="##class(web.DHCPE.PEApp).InsertOrdItem("_admId_","_hisItem_","_userId_","_locId_","_userId_")"
				s ret=##class(web.DHCPE.PEApp).InsertOrdItem(admId, hisItem, userId,locId, userId)			
				s hisOItemId=$p(ret,"^",2)
				//b "before updateItemMatch"
				s gatewayCRM=##class(web.DHCPE.CRM.Factory).GetGateway()
				d gatewayCRM.updateItemMatch(crmOItemId,hisOItemId,iAdmId)
				d ##class(web.DHCPE.TransAdmInfo).InsertPISData(hisOItemId)
     				
			}
		}
		s i=i+1

	}
	
	
	 
		//Modified by MLH 20070608
		//s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
		//i TrakVerison="MedTrak" d
		s CurrentNS=$ZNSPACE
	 	ZN MEDDATA	
		Do presno1^aOET1(admId,UserID,OrdLoc)
		ZN CurrentNS
		//////////////////////////

	q retStr
}

/// -------插入体检项目------------
/// [Previously private]
ClassMethod InsertItemsAZ(crmRegId, admId, iAdmId, userId, locId, MEDDATA)
{
	s crmExamItems=##class(web.DHCPE.CRM.Gateway).GetExamItemsByRegId(crmRegId)
	/// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
	s i=1  //, hisItemsStr=""
	s retStr=""
	Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
	Set TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	while(i<=$l(crmExamItems,$C(2))){
		s TLAItem=$p(crmExamItems,$C(2),i)
		s ^lisatest("1219","TLAItem",i)=TLAItem
		s m=1
		while(m<=$l(TLAItem,$C(1))){
			s crmItem=$p(TLAItem,$C(1),m)
			i (crmItem'=""){
				//hisItemSpec="ordItemID^qty^loc^price^Speciment^AdmReason"
				s crmOItemId=$p(crmItem,"^",4)			
				s objOItemMatch=##class(HandlerIAdm).GetItemMatch(crmOItemId,"CRM")
				if (objOItemMatch.%Id()=""){
					s arcItemId=$p(crmItem,"^",1)
					s crmitemid=$p(crmItem,"^",4)
					s crmordent=$p($g(^DHCPEPreIADM($p(crmitemid,"||",1),"ORDITEM",$p(crmitemid,"||",2))),"^",2)
					s arcos1=""
					if crmordent'=""  d
					.//0926 renzwang   取标本名称错误
					.s arcos1=##class(web.DHCPE.PEApp).GetArcSets(crmordent,arcItemId)
					.//s arcos1=$p($g(^DHCPEPreIADM($p(crmordent,"||",1),"ORDENT",$p(crmordent,"||",2))),"^",1)
					.s ^DHCTemp("jdl","InsertOrdItem")="crmordent:"_crmordent_"  arcos:"_arcos1
					//s arcos=$p($g(^DHCPEPreIADM($p(crmitemid,"||",1),"ORDITEM",$p(crmitemid,"||",2))),"^",3)
					s locId=$g(locId)    //Add by MLH20070512
				
					//070816 renzwang
					//s locId=..GetReceiveLoc(admId,arcItemId,locId)
					s ldefLocId=$G(^DHCPESetting("DHCPE","PhyExamLocId"))
					s locId=##class(web.DHCPE.PreItemList).GetRecLoc(3,crmitemid)
					i locId="" s locId=..GetReceiveLoc(admId,arcItemId,ldefLocId)
					i ""=$G(^DHCPESetting("DHCPE","DefaultPAADM")) s ^DHCPESetting("DHCPE","DefaultPAADM")=admId
				
					if locId="" s locId=$p(crmItem,"^",2)
					s hisItem=arcItemId_"^1^"_locId_"^"_$p(crmItem,"^",2)_"^^^"_arcos1
					s ret=0
					if arcos1'="" s ^DHCTemp("jdl","InsertOrdItem","12")="##class(web.DHCPE.PEApp).InsertOrdItem("_admId_","_hisItem_","_userId_","_locId_","_userId_")"
					s SPEC=""
					i $G(crmOItemId)'="" d
					.s SPEC=$G(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",crmOItemId))
					.s SPEC=$p(SPEC,"^",1)
					i hisItem'="" s hisItem=hisItem_"^"_SPEC
					s ret=##class(web.DHCPE.PEApp).InsertOrdItem(admId, hisItem, userId,locId, userId)			
					s hisOItemId=$p(ret,"^",2)
					//b "before updateItemMatch"
					s gatewayCRM=##class(web.DHCPE.CRM.Factory).GetGateway()
					d gatewayCRM.updateItemMatch(crmOItemId,hisOItemId,iAdmId)				
				}
			}
			//Modified by MLH 20070608
			//s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
			//i TrakVerison="MedTrak" d
			s CurrentNS=$ZNSPACE
			//友谊的，安贞的非TLA医嘱
			If ((HosCode="YY")||((HosCode="AZ")&(i=1))){
				ZN MEDDATA
				Do presno^aOET1(admId)  //Modified by MLH 20071218
				ZN CurrentNS
			}
			//////////////////////////
			s m=m+1
		}
		//非友谊的，安贞的TLA医嘱
		If ((HosCode'="YY")||(HosCode="AZ")&(i=2)){
			If (TrakVerison="MedTrak") {
			 ZN MEDDATA	
			 Do presno^aOET1(admId)  //Modified by MLH 20071218
			 ZN CurrentNS	
			}
			If (TrakVerison="TrakCare"){
			 s ^lisatest("20080220","presno1^aOET1")=admId_"^"_userId_"^"_locId
			 ZN MEDDATA	
			 Do presno1^aOET1(admId,userId,locId)  //Modified by MLH 20080220
			 ZN CurrentNS	

			}
		}
		s i=i+1
	}
	q retStr
}

/// 保存挂号时间等基本信息
/// 插入DHC_PE_IADM表
/// [Previously private]
ClassMethod transBaseInfo(crmRegId, patNo, patId, iAdmId)
{
	s strErr=""		
	s regInfoCurrent=##class(web.DHCPE.CRM.Gateway).GetRegListByPatInf("REGID",crmRegId) //crmRegId--DHC_PE_PreIAdm的RowId  //MLH Modified by 2006-07-20
	// return: ***$C(1)preIAdmId_"^"_preIBId_"^"_PNo_"^"_PName_"^"_PSex_5"^"_PDOB_"^"_PGADMDR_"^"_PGTeamDR_"^"_BookDateBegin_"^"_BookDateEnd_10"^"_BookTime_"^"_PEDeskClerkDR_"^"_Status_"^"_AsCharged_"^"_AddOrdItem_15"^"_AddOrdItemLimit_"^"_AddOrdItemAmount_"^"_AddPhcItem_"^"_AddPhcItemLimit_"^"_AddPhcItemAmount_20"^"_IReportSend_"^"_DisChargedMode_"^"_Vip_"^"_DelayDate_"^"_Remark_25"^"_UpdateUserDR_"^"_UpdateDate$C(1)...
	
	//-----从CRM中找到需要的挂号信息------
	q:(regInfoCurrent="") "Error: 从CRM中根据Regid不能取到正确的挂号记录 in transBaseInfo"
	s iAdmId=$o(^DHCPEIADM(0,"CRMADM",crmRegId,""))
	s patNo=$P(regInfoCurrent,"^",3)  ///patCardId--PAPMINo //MLH Modified by 2006-07-20
	s patId=..patNo2Id(patNo)
	s iAdmDate=+$h
	s iAdmAsCharged="N"
	
	s CRMADM=$P(regInfoCurrent,"^",1)
	s AdmDate=+$h
	s AdmTime=$p($h,",",2)
	s AsCharged=$P(regInfoCurrent,"^",14)
	//s Status="ARRIVED"  Modified by MLH 20080418
	s Status="REGISTERED"
	s AddOrdItem=$P(regInfoCurrent,"^",15)
	s AddOrdItemLimit=$P(regInfoCurrent,"^",16)
	s AddOrdItemAmount=$P(regInfoCurrent,"^",17)
	s AddPhcItem=$P(regInfoCurrent,"^",18)
	s AddPhcItemLimit=$P(regInfoCurrent,"^",19)
	s AddPhcItemAmount=$P(regInfoCurrent,"^",20)
	s DisChargedMode=$P(regInfoCurrent,"^",22)
	s Remark=$P(regInfoCurrent,"^",25)
	
	i (+$P(regInfoCurrent,"^",14)=1) s iAdmAsCharged="Y"
	i iAdmId=""
	{
		&SQL(Insert Into sqluser.DHC_PE_IADM 
			(IADM_CRMADM,IADM_AdmDate,IADM_AdmTime,IADM_AsCharged,IADM_Status,IADM_AddOrdItem,IADM_AddOrdItemLimit,IADM_AddOrdItemAmount,IADM_AddPhcItem,IADM_AddPhcItemLimit,IADM_AddPhcItemAmount,IADM_DisChargedMode,IADM_Remark)
			Values (:CRMADM,:AdmDate,:AdmTime,:AsCharged,:Status,:AddOrdItem,:AddOrdItemLimit,:AddOrdItemAmount,:AddPhcItem,:AddPhcItemLimit,:AddPhcItemAmount,:DisChargedMode,:Remark)
			)
		if SQLCODE q "生成体检登记记录失败!       err:SQLCODE:"_SQLCODE
		s iAdmId=%ROWID
	}
	else
	{
		&SQL(update sqluser.DHC_PE_IADM set
			IADM_AdmDate=:AdmDate,IADM_AdmTime=:AdmTime,IADM_AsCharged=:AsCharged,
			IADM_Status=:Status,IADM_AddOrdItem=:AddOrdItem,IADM_AddOrdItemLimit=:AddOrdItemLimit,
			IADM_AddOrdItemAmount=:AddOrdItemAmount,IADM_AddPhcItem=:AddPhcItem,
			IADM_AddPhcItemLimit=:AddPhcItemLimit,IADM_AddPhcItemAmount=:AddPhcItemAmount,
			IADM_DisChargedMode=:DisChargedMode,IADM_Remark=:Remark Where IADM_RowId=:iAdmId)						
		if SQLCODE q "生成体检登记记录失败!       err:SQLCODE:"_SQLCODE
	}
	q ""
}

/// ------插一条报告状态记录-----------
ClassMethod InsertReport(iAdmId)
{
	s reportId=$o(^DHCPERPT(0,"IADM",iAdmId,""))
	i reportId=""
	{
		&SQL(Insert into sqluser.dhc_pe_report
			(RPT_IADM_DR,RPT_Status)
			Values (:iAdmId,"NA"))
		if SQLCODE q SQLCODE
	}	
	q ""
}

/// 保存客人基本信息
/// 更新PA_Patmas表
/// [Previously private]
ClassMethod TranPatInfoNew(patNo, PEPATTYPE)
{
	//------从CRM中找到需要的客户信息--------
	s objPat=##class(web.DHCPE.CRM.Gateway).GetPatientInfoByNo(patNo)
	q:objPat="" "Error: 从CRM中不能取到正确的客户信息"
	
	s dob=objPat.DOB
	i dob'=""  s dob=$zd(dob,3)
	s patInfo=objPat.PatientNo_"^"_objPat.PatientName_"^"_objPat.Sex_"^"_
	dob_"^"_objPat.MobilePhone_"^^^"_objPat.PatientType_"^"_objPat.IDNo_"^^"_objPat.Corporator_"^"_objPat.Address
	
	s ret=##class(web.DHCPE.PEApp).CommitPatDetail("","",patInfo)	//Update表PA_PatMas和PA_Person
	q:(ret'="1") "ERROR:保存客人基本信息时出错 in TranPatInfo"
	
	s hisPatId=objPat.PatientId
	s hisMarital=objPat.Marital
	s hisEmail=objPat.Email
	s hisZip=objPat.Zip
	s hisBloodtype=objPat.BloodType
	s hisZipDr=""
	i $g(hisZip)'="" s hisZipDr=$o(^CT("ZIP",0,"Code",hisZip,""))
	
	&sql(update sqluser.pa_patmas set papmi_email=:hisEmail where papmi_rowId=:hisPatId)
	q:SQLCODE "Error:更新体检人基本信息失败!"
	&sql(update sqluser.pa_person set PAPER_Marital_DR=:hisMarital
			, PAPER_Zip_DR=:hisZipDr, PAPER_BloodType_DR=:hisBloodtype
		 where paper_rowid=:hisPatId)
	q:SQLCODE "Error:更新体检人基本信息失败!"
	
	q ""
}

/// ------进行挂号------------（只对新登记有用，更新时不调用此程序）　
/// [Previously private]
ClassMethod Register(iAdmId, patId, locId, docId, userId, admId)
{
	s retStr=""
	i iAdmId="" q "没有传入体检登记号"
	
	s admId=$p($g(^DHCPEIADM(iAdmId)),"^",1)
	if admId=""
	{
		s admId=##Class(web.DHCPE.PEApp).PEPAADMBroker(, , patId, locId, docId, "", userId)
		q:((admId="")||(admId=0)) "ERROR:An error occurs when registe！"
	}
	&SQL(Update sqluser.DHC_PE_IAdm set IADM_PAADM_DR=:admId 
		Where IADM_RowId=:iAdmId)
	if SQLCODE q "更新体检登记记录的PAAdmDR失败"
	q ""
}

/// crmRegIdNew--DHC_PE_PreIAdm的RowId  
/// w ##class(web.DHCPE.TransAdmInfo).main(99,3566)
ClassMethod main(crmRegIdNew As %String, hisUserId As %String = "") As %String
{
	s result=##class(web.DHCPE.CRM.Gateway).CheckPEDate(crmRegIdNew,"I",+$h)
	s LimitDate=$g(^DHCPESetting("DHCPE","BookDateLimit"))
	i LimitDate="Yes"
	{
		if result'=0
		{
			if result=-1 q "还没有到预约日期!"
			q "预约已经过期!"
		}
	}
	s result=##class(web.DHCPE.CRM.Gateway).CheckCanArrive(crmRegIdNew,"I")
	if result'=0  q result
	b ;crmRegIdNew_"^"_hisUserId
	s retStr= ..mainEntranceNew(crmRegIdNew, hisUserId)	
	q retStr
}

/// Description: 主程序
/// Return: 正常："", 错误：错误信息，　
/// crmRegIdNew--DHC_PE_PreIAdm的RowId  //MLH Modified by 2006-07-20
/// w ##class(web.DHCPE.TransAdmInfo).mainEntranceNew(1628,1501)
ClassMethod mainEntranceNew(crmRegIdNew As %String, hisUserId As %String = "") As %String
{
	s strErr=""
	s (patNo,patId,iAdmId,admId)=""
	s locId=%session.Get("LOGON.CTLOCID")
	s docId=^DHCPESetting("DHCPE","PhyExamDrId",locId)
	s PEPATTYPE=^DHCPESetting("DHCPE","PEPatType")
	s MEDDATA=^DHCPESetting("NAMESPACE","MEDDATA")
	Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
	s TransFlag=0
	b ;crmRegIdNew
	s objIAdm=##class(HandlerIAdm).GetAdmByCrmAdm(crmRegIdNew) //用DHC_PE_PreIAdm的RowId得到DHC_PE_IADM表 //MLH Modified by 2006-07-20
	b ;objIAdm.IADMStatus
	b ;objIAdm.%Id()
	q:((objIAdm.%Id()'="")&&(objIAdm.IADMStatus'="PREREGED")) "Error:已经到达或尚未完成预约，操作失败!"
	
	s TransFlag=1
	TStart
	s strErr=..transBaseInfo(crmRegIdNew,.patNo,.patId,.iAdmId)  //插入DHC_PE_IADM表
	if strErr'=""  goto myError
	q:iAdmId="" "Error:没有返回体检登记记录"
	s strErr= ..InsertReport(iAdmId)  /////插入DHC_PE_Report表
	if strErr'=""  goto myError
	s TransFlag=1
	&SQL(Update sqluser.DHC_PE_PreAudit set PA_GIADM=:iAdmId Where PA_ADMType="I" and PA_CRMADM=:crmRegIdNew)
	if SQLCODE<0 s strErr="更新预约审核记录失败"
	
	if strErr'=""  goto myError
	TCommit
	b "before TranPatInfo"
	//s strErr=..TranPatInfo(patNo,PEPATTYPE) ////更新PA_PatMas和PA_Person表	
	//s strErr=..TranPatInfoNew(patNo,PEPATTYPE) ////更新PA_PatMas和PA_Person表	
	if strErr'=""  goto myError
	s ^zl("090406","strErr",2)=1_"^"_strErr
	b "before Register"
	s strErr= ..Register(iAdmId,patId,locId,docId,hisUserId,.admId)   /////插入PA_ADM表
	if strErr'=""  goto myError
	//s ^DHCTemp("jdltest")="##class(web.DHCPE.TransAdmInfo).InsertItems("_crmRegIdNew_","_admId_","_iAdmId_","_hisUserId_","_locId_","_MEDDATA_")"
	
	If HosCode'="AZ" Do
	.s strErr=..InsertItems(crmRegIdNew,admId,iAdmId,hisUserId,locId,MEDDATA)	 /////插入医嘱表
	Else  Do
	.s strErr=..InsertItemsAZ(crmRegIdNew,admId,iAdmId,hisUserId,locId,MEDDATA)	 /////插入医嘱表
	
	//s rtn=##class(web.DHCPE.PEApp).CreatePrescNo(admId)
	if strErr'=""  goto myError
	s ^zl("090406","strErr",3)=1_"^"_strErr
	s strErr=##class(web.DHCPE.CRM.GatewayDHC).InsertOEEnt(iAdmId)
	if strErr'=""  goto myError
	//Modified by MLH 20080418
	//s strErr=##class(web.DHCPE.CRM.Gateway).ExamStatusNotify("PERSON",crmRegIdNew, "ARRIVED","") 
	s strErr=##class(web.DHCPE.CRM.Gateway).ExamStatusNotify("PERSON",crmRegIdNew, "REGISTERED","") 
	i strErr="0" s strErr=""
	s ^zl("090406","strErr",4)=1_"^"_strErr
	s strErr=##class(web.DHCPE.TransAdmInfo).CheckGAdmCreated(crmRegIdNew)
	i strErr="0" s strErr=""
	q strErr
	
	
myError
	i TransFlag=1 TRollback
	q strErr
}

/// 确认加项医嘱 Create by MLH 20080422
ClassMethod ConfirmAddOrdItem(PIADMRowID As %String, UserID As %String = "") As %String
{
	Set strErr=""
	Set (patNo,patId,iAdmId,admId)=""
	Set LocID=%session.Get("LOGON.CTLOCID")
	Set PEPATTYPE=^DHCPESetting("DHCPE","PEPatType")
	Set MEDDATA=^DHCPESetting("NAMESPACE","MEDDATA")
	Set IAdmRowID=$o(^DHCPEIADM(0,"CRMADM",PIADMRowID,0))
	Quit:$g(IAdmRowID)=""
	Set ADMRowID=$p($g(^DHCPEIADM(IAdmRowID)),"^",1)
	Quit:$g(ADMRowID)=""
	Set strErr=..InsertItems(PIADMRowID,ADMRowID,IAdmRowID,UserID,LocID,MEDDATA)
	Quit:strErr'="" strErr
	Set strErr= ##class(web.DHCPE.OEOrdItem).TransOrder(IAdmRowID,"ARRIVED")
	Quit:strErr'="" strErr

	Quit strErr
}

/// 确认分组加项医嘱 Create by MLH 20080523
ClassMethod ConfirmAddOrdItemGT(PGTeamDR As %String, UserID As %String = "") As %String
{
	Set PIADMRowID=0
	For  Set PIADMRowID=$o(^DHCPEPreIADM(0,"PGTeam",PGTeamDR,PIADMRowID)) Quit:PIADMRowID=""  Do
	.Do ..ConfirmAddOrdItem(PIADMRowID,UserID)
	.
	Quit 0
}

/// d ##class(web.DHCPE.TransAdmInfo).InsertPISData("710431||18")
ClassMethod InsertPISData(OEORIID)
{
	//n (OEORIID)
	s ARCIMID=$P($G(^OEORD(+OEORIID,"I",$p(OEORIID,"||",2),1)),"^",2)
	s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMID, 0))
	q:STRowId="" 0
	s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMID, STRowId, 0))
	q:STORDChildSub="" 0
	s ReportFormat=$P(^DHCPEST(STRowId,"O",STORDChildSub),"^",4)
	q:ReportFormat'="RF_PIS" 0   //不是病理项目退出
	s PAADM=$p($G(^OEORD(+OEORIID)),"^",1)
	s TMInfo=..GetTMInfo(PAADM,OEORIID)
	s TSInfo=..GetTSInfo(OEORIID)
	s TWInfo=..GetTWInfo(PAADM)
	q ##class(web.DHCPisApplicationSheet).SetAllInfo(TMInfo , TSInfo,TWInfo)
}

//w ##class(web.DHCPE.TransAdmInfo).GetTMInfo(1,"1||1")

ClassMethod GetTMInfo(PAADM, OEORIID)
{
	//n (PAADM,OEORIID)
	s papmidr=$p($G(^PAADM(PAADM)),"^",1)
	s Name=$P($G(^PAPER(papmidr,"ALL")),"^",1)
	s SexDR=$P($G(^PAPER(papmidr,"ALL")),"^",7)
	s Birth=$P($G(^PAPER(papmidr,"ALL")),"^",6)
	s Tel=$P($G(^PAPER(papmidr,"PER",1)),"^",9)
	i Tel="" s Tel=$P($G(^PAPER(papmidr,"PER",1)),"^",11)
	i Tel="" s Tel=$P($G(^PAPER(papmidr,"PER",4)),"^",18)
	i Tel="" s Tel=$P($G(^PAPER(papmidr,"PER",4)),"^",21)
	s Address=$P($G(^PAPER(papmidr,"NOK")),"^",8)
	i Address="" s Address=$P($G(^PAPER(papmidr,"NOK")),"^",7)
	s RegNo=$P($G(^PAPER(papmidr,"PAT",1)),"^",1)
	s Medicare="其它,无," //$P($G(^PAPER(papmidr,"PAT",1)),"^",22)  //病历
	
	s Remark="无"  //补充说明
	
	s Type=$p($G(^PAADM(PAADM)),"^",2)
	s PatType=$p($G(^PAADM(PAADM)),"^",3)
	i PatType="" s PatType=$P($G(^PAPER(papmidr,"PER",1)),"^",10)
	s LocDR=$p($G(^PAADM(PAADM)),"^",4)
	s LocDesc=$P($G(^CTLOC(LocDR)),"^",2)
	s DocDR=$p($G(^PAADM(PAADM)),"^",9)
	s DocDesc=$P($G(^CTPCP(DocDR,1)),"^",2)
	s ADMNo=$p($G(^PAADM(PAADM)),"^",81)
	
	s Date=+$H
	s Time=$P($H,",",2)
	s BedNo=""
	s PatLoc=""
	s tmInfo="0^^"_PAADM_"^^^^^^^^3^^"_Type_"^"_
	     Name_"^^"_PatType_"^"_SexDR_"^"_Birth_"^"_
       Address_"^"_Medicare_"^^^^"_Remark_"^^"_
	     Date_"^"_Time_"^"_LocDesc_"^"_LocDR_"^"_DocDesc_"^"_DocDR_"^"_
	     OEORIID_"^"_RegNo_"^"_ADMNo_"^"_PatLoc_"^"_BedNo_"^^^^^1^^^^^^^^^^^^"_Tel
	q tmInfo
}

//插入标本信息

//w ##class(web.DHCPE.TransAdmInfo).GetTSInfo("1||1")

//

ClassMethod GetTSInfo(OEORIID)
{
	q "1^^宫颈刮片^^^^^@"
}

//插入妇科信息

//w ##class(web.DHCPE.TransAdmInfo).GetTWInfo("1||1")

//

ClassMethod GetTWInfo(PAADM)
{
	q ""
	q "末次月经"_"^"_"是否绝经"_"^"_"胎数"_"^"_"产数"_"^"
}

}
