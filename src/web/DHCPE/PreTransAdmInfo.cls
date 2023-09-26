Import SQLUser

Class web.DHCPE.PreTransAdmInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

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
	s ..PEREGDocId=^DHCPESetting("DHCPE","PhyExamDrId")
	s ..PEPATTYPE=^DHCPESetting("DHCPE","PEPatType")
	s ..CRMGateway=##class(web.DHCPE.CRM.Factory).GetGateway()
	q $$$OK
}

/// test: w ##class(web.DHCPE.TransAdmInfo).GetReceiveLoc(64090, "12529||1")
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
	     s isDef=rset.Data("DefRecFlag")
	     i isDef="Y" {
		 	s recLocId=rset.Data("RecLocRID")
		    quit
	     }
     }
     i recLocId=""  s recLocId=defLocId
     quit recLocId
}

/// **************************************************************************
/// Modified By jdl
/// -------  ------------
/// s ret=##class(web.DHCPE.PreTransAdmInfo).PreADMInsertItems(9710,"3737||3","8570||1",10612)
/// 
/// d taiObj.PreADMInsertItems(9710,"3737||3","8570||1",10612)
Method PreADMInsertItems(ahisAdmId, acrmOItemId, aarcItemId, ahisUserId)
{
	s ..hisAdmId=ahisAdmId	// PA_ADM.{ PAADM_rowId }=DHC_PE_IADM.{ IADM_PAADM_DR }
	s ..hisUserId=ahisUserId
	s ..hisLocId=%session.Get("LOGON.CTLOCID")
	s objOItemMatch=##class(HandlerIAdm).GetItemMatch(acrmOItemId,"CRM")
	b // w objOItemMatch
	if (objOItemMatch.%Id()=""){
	
		s arcitemprice=$p(aarcItemId,"&",2)
		s aarcItemId=$p(aarcItemId,"&",1)
		s ldefLocId=$G(%session.Get("LOGON.CTLOCID"))
		
		//070816 renzwang
		//s lrecLocId=..GetReceiveLoc(..hisAdmId,aarcItemId,ldefLocId)
		s lrecLocId=##class(web.DHCPE.PreItemList).GetRecLoc(3,acrmOItemId)
		i lrecLocId="" s lrecLocId=##class(web.DHCPE.TransAdmInfo).GetReceiveLoc(..hisAdmId,aarcItemId,ldefLocId)
		b // w ldefLocId_"  "_lrecLocId
		
		//add by jdl  Get arcos1
		s crmordent=$p($g(^DHCPEPreIADM($p(acrmOItemId,"||",1),"ORDITEM",$p(acrmOItemId,"||",2))),"^",2)
		s arcos1=""
		if crmordent'=""  d
		.//0926 renzwang   取标本名称错误
		.s arcos1=##class(web.DHCPE.PEApp).GetArcSets(crmordent,aarcItemId)
		.//s arcos1=$p($g(^DHCPEPreIADM($p(crmordent,"||",1),"ORDENT",$p(crmordent,"||",2))),"^",1)
		.s ^DHCTemp("jdl","InsertOrdItem")="crmordent:"_crmordent_"  arcos:"_arcos1
		
		
		s hisItem=aarcItemId_"^1^"_lrecLocId_"^"_arcitemprice_"^^^"_arcos1
				
		s ret=0
		b // CashierInsertOrdItem Begin
		//s ^DHCTemp("jdl","preInsertOrdItem")="##class(web.DHCPE.PEApp).InsertOrdItem("_..hisAdmId_","_hisItem_","_..hisUserId_","_..hisLocId_","_..hisUserId_")"
		s SPEC=""
		i $G(acrmOItemId)'="" d
		.s SPEC=$G(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",acrmOItemId))
		.s SPEC=$p(SPEC,"^",1)
		i hisItem'="" s hisItem=hisItem_"^"_SPEC
		s ret=##class(web.DHCPE.PEApp).InsertOrdItem(..hisAdmId, hisItem, ..hisUserId,..hisLocId, ..hisUserId)			
		b // w ret

		s hisOItemId=$p(ret,"^",2)
		
		s iAdmId=$o(^DHCPEIADM(0,"PAADM",ahisAdmId,0))
		s gatewayCRM=##class(web.DHCPE.CRM.Factory).GetGateway()
		d gatewayCRM.updateItemMatch(acrmOItemId,hisOItemId,iAdmId)
		
		//add by jdl
		s iAdmId=$o(^DHCPEIADM(0,"PAADM",ahisAdmId,0))
		if iAdmId'="" d ##class(web.DHCPE.CRM.GatewayDHC).InsertOEEnt(iAdmId)
		d ##class(web.DHCPE.OEOrdItem).TransOrder(iAdmId,"ARRIVED")
	}
		//Modified by MLH 20070608
		s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
		s MEDDATA=$g(^DHCPESetting("DHCPE","MEDDATA"))
		//i TrakVerison="MedTrak" d
		//.//s CurrentNS=$ZNSPACE
		//.//ZN MEDDATA	
		//.//Do presno^aOET1(..hisAdmId)
		//.//ZN CurrentNS
		////////////////////////

	Q ""
}

/// w ##class(web.DHCPE.PreTransAdmInfo).test()
ClassMethod test()
{
	s taiObj=##class(web.DHCPE.PreTransAdmInfo).%New()
	s PAADMDR="5748025"
	s newId="99||2"
	s arcItemId="23026||1"
	s UpdateUserId="3566" // pe003
	s ret=taiObj.PreADMInsertItems(PAADMDR,newId,arcItemId,UpdateUserId)
}

/// w ##class(web.DHCPE.PreTransAdmInfo).UpdateOldDataRecLoc()
ClassMethod UpdateOldDataRecLoc()
{
	s IADM=0
	s SQLCODE=0
	TSTART
	f  s IADM=$o(^DHCPEPreIADM(IADM)) q:(IADM="")||(SQLCODE'=0)  d
	.s Sub=0
	.f  s Sub=$o(^DHCPEPreIADM(IADM,"ORDITEM",Sub)) q:(Sub="")||(SQLCODE'=0)  d
	..s IPreItem=IADM_"||"_Sub
	..s TPreItem=$p(^DHCPEPreIADM(IADM,"ORDITEM",Sub),"^",4)
	..s ARCItem=$p(^DHCPEPreIADM(IADM,"ORDITEM",Sub),"^",1)
	..s CRMOrderID=$o(^DHCPECRMO(0,"CRMORI",IPreItem,0))
	..i CRMOrderID'="" d
	...s OrderID=$p(^DHCPECRMO(CRMOrderID),"^",1)
	...s RecLoc=$P(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",6)
	..e  d
	...s RecLoc=##class(web.DHCPE.PreItemList).GetRecLoc(1,ARCItem)
	..i TPreItem'="" d
	...&SQL(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_ItemRecLoc_DR=:RecLoc where PGTOI_RowID=:TPreItem)
	..i SQLCODE'=0 s SQLCODE="TPreItem:"_SQLCODE
	..q:SQLCODE'=0
	..&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_ItemRecLoc_DR=:RecLoc  where PIOI_RowID=:IPreItem)
	i SQLCODE'=0
	{
		TROLLBACK
		q "ERR:"_SQLCODE
	}
	s GADM=0
	//^DHCPEPreGADM(DHC_PE_PreGADM.PGADM_Rowid,’Team’,PGT_ChildSub,’ ORDITEM’,PGTOI_ChildSub)

	f  s GADM=$o(^DHCPEPreGADM(GADM)) q:(GADM="")||(SQLCODE'=0)  d
	.s TADM=0
	.f  s TADM=$o(^DHCPEPreGADM(GADM,"Team",TADM)) q:(TADM="")||(SQLCODE'=0)  d
	..s Sub=0
	..f  s Sub=$o(^DHCPEPreGADM(GADM,"Team",TADM,"ORDITEM",Sub)) q:(Sub="")||(SQLCODE'=0)  d
	...s RecLoc=$p(^DHCPEPreGADM(GADM,"Team",TADM,"ORDITEM",Sub),"^",14)
	...q:RecLoc'=""
	...s ARCItemID=$p(^DHCPEPreGADM(GADM,"Team",TADM,"ORDITEM",Sub),"^",1)
	...s RecLoc=##class(web.DHCPE.PreItemList).GetRecLoc(1,ARCItem)
	...s TPreItem=GADM_"||"_TADM_"||"_Sub
	...&SQL(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_ItemRecLoc_DR=:RecLoc where PGTOI_RowID=:TPreItem)
	i SQLCODE'=0
	{
		TROLLBACK
		q "ERR2:"_SQLCODE
	}
	TCOMMIT
	q "SUCCESS"
}

/*
/// -------  ------------
/// s ret=##class(web.DHCPE.PreTransAdmInfo).PreADMInsertItems(9710,"3737||3","8570||1",10612)
/// 
/// d taiObj.PreADMInsertItems(9710,"3737||3","8570||1",10612)
Method PreADMInsertItems(ahisAdmId, acrmOItemId, aarcItemId, ahisUserId)
{
	s ..hisAdmId=ahisAdmId	// PA_ADM.{ PAADM_rowId }=DHC_PE_IADM.{ IADM_PAADM_DR }
	s ..hisUserId=ahisUserId
	//s ..hisLocId=%session.Get("LOGON.CTLOCID")
	s objOItemMatch=##class(HandlerIAdm).GetItemMatch(acrmOItemId,"CRM")
	b // w objOItemMatch
	if (objOItemMatch.%Id()=""){
	
		s ldefLocId=%session.Get("LOGON.CTLOCID")
		
		s lrecLocId=..GetReceiveLoc(..hisAdmId,aarcItemId,ldefLocId)
		b // w ldefLocId_"  "_lrecLocId
		s hisItem=aarcItemId_"^"_lrecLocId_"^"_ldefLocId_"^^"
				
		s ret=0
		s ret=##class(web.DHCOPCashier).CashierInsertOrdItem(..hisAdmId, hisItem, ..hisUserId,..hisLocId, ..hisUserId, "")			
		b // w ret
		s hisOItemId=$p(ret,"^",2)
		d ##class(web.DHCPE.HandlerIAdm).updateItemMatch(acrmOItemId,hisOItemId)
	}
	
	s CurrentNS=$ZNSPACE
	ZN ..MEDDATA
	Do presno^aOET1(..hisAdmId)
	ZN CurrentNS
	Q ""
}
*/
Storage Default
{
<Data name="PreTransAdmInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRMGateway</Value>
</Value>
<Value name="3">
<Value>LABDB</Value>
</Value>
<Value name="4">
<Value>MEDDATA</Value>
</Value>
<Value name="5">
<Value>PEPATTYPE</Value>
</Value>
<Value name="6">
<Value>PEREGDocId</Value>
</Value>
<Value name="7">
<Value>STATUSExecuted</Value>
</Value>
<Value name="8">
<Value>STATUSStoped</Value>
</Value>
<Value name="9">
<Value>STATUSVerifiedd</Value>
</Value>
<Value name="10">
<Value>crmRegId</Value>
</Value>
<Value name="11">
<Value>hisAdmId</Value>
</Value>
<Value name="12">
<Value>hisLocId</Value>
</Value>
<Value name="13">
<Value>hisUserId</Value>
</Value>
<Value name="14">
<Value>objHisIAdm</Value>
</Value>
<Value name="15">
<Value>patCardId</Value>
</Value>
<Value name="16">
<Value>patId</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.PreTransAdmInfoD</DataLocation>
<DefaultData>PreTransAdmInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCP.PreTransAdmInfoD</IdLocation>
<IndexLocation>^web.DHCP.PreTransAdmInfoI</IndexLocation>
<StreamLocation>^web.DHCP.PreTransAdmInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
