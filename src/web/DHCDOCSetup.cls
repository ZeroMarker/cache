Class web.DHCDOCSetup Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod ArcimLookup(Str As %String) As %String
{
  Set retStr=""
  Set ALIASRowId=0 For  Set ALIASRowId=$O(^ARC("ALIAS",ALIASRowId)) Q:ALIASRowId=""  Do
  .Set ALIASText=$P($G(^ARC("ALIAS",ALIASRowId)),"^",6)
  .Set ALIASText=$ZCVT(ALIASText,"U")
  .Set Str=$ZCVT(Str,"U")
  .Q:ALIASText'[Str
  .Set ARCIMDR=$P($G(^ARC("ALIAS",ALIASRowId)),"^",1)
  .Q:ARCIMDR=""
  .Set ItemCat=$P($G(^ARCIM(+ARCIMDR,1,1)),"^",10)
  .Q:ItemCat=""
  .Set OrderType=$P($G(^ARC("IC",ItemCat)),"^",7)
  .Q:OrderType'="L"  //检验类型
  .Set ARCIMDesc=$P($G(^ARCIM(+ARCIMDR,1,1)),"^",2)
  .If retStr="" Set retStr=ARCIMDR_$c(1)_ARCIMDesc_"-"_ALIASText
  .Else  Set retStr=retStr_"^"_ARCIMDR_$c(1)_ARCIMDesc_"-"_ALIASText
  Q retStr
}

ClassMethod InsertArcCon(Par As %String) As %String
{
  //w ##class(web.DHCDOCSetup).InsertArcCon("1378||1^true^I^demo")
  Set ARCITEMRowid=$P(Par,"^",1)
  Set FlagStatus=$P(Par,"^",2)
  if FlagStatus="true" Set FlagStatus="Y"
  Else  Set FlagStatus="N"
  Set AdmType=$P(Par,"^",3)
  Set USERCODE=$P(Par,"^",4)
  Set ARCCONDate=+$h
  Set ARCCONTime=$P($h,",",2)
  Set ARCITEMDesc=$P($G(^ARCIM(+ARCITEMRowid,1,1)),"^",2)
  Set Remarks="用户:"_USERCODE_" 创建 "_ARCITEMDesc_" 非独立医嘱状态为: "_FlagStatus
  If AdmType'="" Set Remarks=Remarks_" 病人类型为 "_AdmType_" 为独立医嘱 "
  If $O(^DHCARCCON("ARCITEMDR",ARCITEMRowid,-1))'="" Q "100"
  &sql(Insert into SQLUSER.DHC_ARCConfine set ARCCON_ARCITEM_DR=:ARCITEMRowid,ARCCON_FLAG=:FlagStatus,ARCCON_PatType=:AdmType,ARCCON_Date=:ARCCONDate,ARCCON_Time=:ARCCONTime,ARCCON_User=:USERCODE,ARCCON_Remarks=:Remarks)
  Q SQLCODE
}

ClassMethod GetARCConfine(itmjs As %Library.String = "") As %String
{
  &sql(declare ARCCon cursor  for 
	   select distinct ARCCON_Rowid,ARCCON_ARCITEM_DR->ARCIM_Desc,ARCCON_FLAG,ARCCON_PatType,ARCCON_Date,ARCCON_Time,ARCCON_User,ARCCON_ARCITEM_DR
	          from SQLUser.DHC_ARCConfine)
  &sql(open ARCCon)
  For  &sql(fetch ARCCon into :ARCCONRowid,:ARCIMDesc,:ARCCONFLAG,:ARCCONPatType,:ARCCONDate,:ARCCONTime,:ARCCONUser,:ARCCONARCITEMDR) Q:SQLCODE  Do
  .Q:ARCCONRowid="ARCITEMDR"
  .Set val=ARCCONRowid_"^"_ARCIMDesc_"^"_ARCCONFLAG_"^"_ARCCONPatType_"^"_$ZD(ARCCONDate,3)_"^"_$ZT(ARCCONTime,3)_"^"_ARCCONUser_"^"_ARCCONARCITEMDR
  .Set retval=itmjs_"('"_$ZCVT(val,"O","JS")_"');"
  .&javascript<#(retval)#>
  q 0
}

ClassMethod UpdateARCConfine(Par As %String) As %String
{
  //w ##class(web.DHCDOCSetup).UpdateARCConfine("1341||1^^demo^true")
  Set ChangFlag=0
  Set ArcimRowid=$P(Par,"^",1)
  Set ARCCONPatType=$P(Par,"^",2)
  Set USERCODE=$P(Par,"^",3)
  Set Flag=$P(Par,"^",4)
  if Flag="true" Set Flag="Y" 
  Else  Set Flag="N"
  &sql(select ARCCON_PatType,ARCCON_FLAG,ARCCON_Remarks into :OldPatType,:OldFlag,:Remarks from SQLUser.DHC_ARCConfine where ARCCON_ARCITEM_DR=:ArcimRowid)
  If (OldPatType'=ARCCONPatType) Do
  .Set Remarks=Remarks_"^"_"用户:"_USERCODE_"将病人类型"_OldPatType_"改为"_ARCCONPatType
  .Set ChangFlag=1
  If (OldFlag'=Flag) Do
  .if ChangFlag=1 Set Remarks=Remarks_"将独立医嘱状态"_OldFlag_"改为"_Flag
  .Else  Set Remarks=Remarks_"^"_"用户:"_USERCODE_"将独立医嘱状态"_OldFlag_"改为"_Flag
  &Sql(Update SQLUser.DHC_ARCConfine Set ARCCON_PatType=:ARCCONPatType,ARCCON_FLAG=:Flag,ARCCON_User=:USERCODE,ARCCON_Remarks=:Remarks where ARCCON_ARCITEM_DR=:ArcimRowid)
  Q SQLCODE
}

ClassMethod GetSSGroupStr() As %String
{
   Set retStr=""
   Set SSGRPRowId=""  For  Set SSGRPRowId=$O(^SSU("SSGRP",SSGRPRowId)) Q:SSGRPRowId=""  Do
   .Set SSGRPDesc=$P($G(^SSU("SSGRP",SSGRPRowId)),"^",1)
   .If retStr="" Set retStr=SSGRPRowId_$c(1)_SSGRPDesc
   .Else  Set retStr=retStr_"^"_SSGRPRowId_$c(1)_SSGRPDesc
   Q retStr
}

ClassMethod GetTarSubCat(SSGroup As %String) As %String
{
  Set retStr=""
  &sql(declare TARSubCatFineCur cursor  for 
	   select DHCTARCAT_TarSubCate_DR,DHCTARCAT_TarSubCate_DR->TARSC_Desc from SQLUSER.DHC_TARSUBCAT_CONFINE where DHCTARCAT_SSGroup_DR=:SSGroup)
  &sql(open TARSubCatFineCur)
  For  &sql(fetch TARSubCatFineCur into :TARSCRowId,:TARSCDesc) Q:SQLCODE  Do
  .if retStr="" Set retStr=TARSCRowId_$c(1)_TARSCDesc
  .Else  Set retStr=retStr_"^"_TARSCRowId_$c(1)_TARSCDesc
  Q retStr
}

ClassMethod GetPriceItem(Str As %String, SubCat As %String) As %String
{
	//Set ^yjy(34)=Str_"^"_SubCat
	//w ##class(web.DHCDOCSetup).GetPriceItem("g","1")
	Set Str="%"_Str_"%"
	Set RetStr=""
	&sql(DECLARE ExamDetails CURSOR FOR  
	 select Top 50 TIA_TARI_DR,TIA_TARI_DR->TARI_DESC,TIA_TARI_DR->TARI_UOM into :TARIRowid,:TARIDESC,:UOMDR from SQLUSER.DHC_TarItemAlias where TIA_TARI_DR->TARI_SubCate=:SubCat and ((UCASE(tia_alias) like UCASE(:Str)) or (UCASE(tia_desc) like UCASE(:Str))))
	&sql(OPEN ExamDetails)
	for  &SQL(FETCH ExamDetails) QUIT:SQLCODE  Do
	.Q:TARIDESC=""
	.Q:TARIRowid=""
	.If RetStr="" Set RetStr=TARIRowid_$c(1)_TARIDESC
	.if RetStr'=""  Set RetStr=RetStr_"^"_TARIRowid_$c(1)_TARIDESC
	&sql(CLOSE ExamDetails)
	Q RetStr
}

ClassMethod InsertGroupTar(Par As %String) As %String
{
   Set GrouDescValue=$P(Par,"^",1)
   Set TarSubCateValue=$P(Par,"^",2)
   Set TarItemValue=$P(Par,"^",3)
   Set StrDate=+$h
   If $O(^DHCTARCON("SSGroup",GrouDescValue,TarItemValue,-1))'="" Q "100"
   &sql(insert into SQLUSER.DHC_TARITEM_CONFINE Set DHCTARCON_TarItem_DR=:TarItemValue,DHCTARCON_SSGroup_DR=:GrouDescValue,DHCTARCON_TarSubCate_DR=:TarSubCateValue,DHCTARCON_StrDate=:StrDate)
   Q SQLCODE
}

ClassMethod DelGroupTar(DHCTARCONRwoid As %String) As %String
{
   &sql(Delete from SQLUSER.DHC_TARITEM_CONFINE Where DHCTARCON_Rwoid=:DHCTARCONRwoid)
  Q SQLCODE
}

ClassMethod GetTarGroup(itmjs As %Library.String = "", SSGroup As %String) As %String
{
  &sql(declare TarGroup cursor  for 
	   select distinct DHCTARCON_Rwoid,DHCTARCON_TarItem_DR->TARI_Desc,DHCTARCON_SSGroup_DR->SSGRP_Desc,DHCTARCON_TarSubCate_DR->TARSC_Desc,DHCTARCON_StrDate,DHCTARCON_EndDate,DHCTARCON_SSGroup_DR
	          from SQLUser.DHC_TARITEM_CONFINE)
  &sql(open TarGroup)
  For  &sql(fetch TarGroup into DHCTARCONRwoid,DHCTARCONTarItemDR,DHCTARCONSSGroup,DHCTARCONTarSubCateDR,DHCTARCONStrDate,DHCTARCONEndDate,DHCTARCONSSGroupDR) Q:SQLCODE  Do
  .Q:DHCTARCONRwoid="SSGroup"
  .Q:DHCTARCONRwoid="TarSubCate"
  .Q:(SSGroup'="")&(SSGroup'=DHCTARCONSSGroupDR)
  .If DHCTARCONEndDate'="" Set DHCTARCONEndDate=$zd(DHCTARCONEndDate,3)
  .Set val=DHCTARCONRwoid_"^"_DHCTARCONTarItemDR_"^"_DHCTARCONSSGroup_"^"_DHCTARCONTarSubCateDR_"^"_$zd(DHCTARCONStrDate,3)_"^"_DHCTARCONEndDate
  .Set retval=itmjs_"('"_$ZCVT(val,"O","JS")_"');"
  .&javascript<#(retval)#>
  &sql(CLOSE TarGroup)
  q 0
}

ClassMethod GetUser(str As %String) As %String
{
  //w ##class(web.DHCDOCSetup).GetUser("00")
  if str="" Q "100"
  set retStr=""
  Set str=str_"%"
  &sql(declare SSSearch cursor  for 
	   select SSUSR_Initials,SSUSR_Name,SSUSR_Rowid  from SQLUSER.SS_user where SSUSR_Initials like :str)
  &sql(open SSSearch)
  For  &sql(fetch SSSearch into :Initi,:SSUSRName,:SSUSRRowid) Q:SQLCODE  Do
  .if retStr="" Set retStr=SSUSRRowid_$c(1)_SSUSRName_"-"_Initi
  .Else  Set retStr=retStr_"^"_SSUSRRowid_$c(1)_SSUSRName_"-"_Initi
  &sql(CLOSE SSSearch)
  Q retStr
}

ClassMethod AddUser(UserRwoid As %String) As %String
{
   if UserRwoid="" Q "101"	
   if $O(^DHCPLANAD("USER",UserRwoid,-1))'="" Q "100"
   &sql(Insert into SQLUSER.DHC_PlanAdminAuth set DHCPlanAd_SSUser_DR=:UserRwoid)
   Q SQLCODE
}

ClassMethod GetAllUser() As %String
{
  //w ##class(web.DHCDOCSetup).GetAllUser()
  set retStr=""
  &sql(declare AllUser1 cursor  for 
	   select DHCPlanAd_Rowid,DHCPlanAd_SSUser_DR->SSUSR_Name  from SQLUSER.DHC_PlanAdminAuth)
  &sql(open AllUser1)
  For  &sql(fetch AllUser1 into :DHCPlanAdRowid,:SSUSRName) Q:SQLCODE  Do
  .Q:SSUSRName=""
  .if retStr="" Set retStr=DHCPlanAdRowid_$c(1)_SSUSRName
  .Else  Set retStr=retStr_"^"_DHCPlanAdRowid_$c(1)_SSUSRName
  &sql(CLOSE AllUser1)
  Q retStr
}

ClassMethod GetCTLOC(selValue As %String) As %String
{
  Set retStr=""
  s AdmType="O"
  Set DHCPLANADCTLOC=$P(^DHCPLANAD(selValue),"^",3)
  s RowId=0 f  s RowId=$O(^PAC("ADMLOC",0,"AdmType",AdmType,RowId)) Q:RowId=""  d
  .Q:'$d(^RB("RES",0,"CTLOC",RowId))
  .Set flag=0
  .s CTDesc=$P($p($g(^CTLOC(RowId)),"^",2),"-",2) //s CTDesc=$P($p($g(^CTLOC(rowid)),"^",2),"-",2)
  .s CTAlias=$P($p($g(^CTLOC(RowId)),"^",2),"-",1)
  .s CTRowId=RowId
  .s CTCode=CTRowId
  .if DHCPLANADCTLOC'="" D
  ..for i=1:1:$L(DHCPLANADCTLOC,"!") d
  ...if $P(DHCPLANADCTLOC,"!",i)=CTRowId Set flag=1
  .if retStr="" Set retStr=CTRowId_$c(2)_flag_$c(1)_CTDesc
  .Else  Set retStr=retStr_"^"_CTRowId_$c(2)_flag_$c(1)_CTDesc
  Q retStr
}

ClassMethod UpDateCTLOCByUser(CTLOCRowid As %String, PLANRowid As %String) As %String
{
  &sql(update SQLUSER.DHC_PlanAdminAuth Set DHCPlanAd_CTLOC=:CTLOCRowid where DHCPlanAd_Rowid=:PLANRowid)
  Q SQLCODE
}

ClassMethod GetSSGroup() As %String
{
  set retStr=""
  &sql(declare SSGroupCur cursor  for 
	   select SSGRP_RowId,SSGRP_Desc from SQLUSER.SS_Group)
  &sql(open SSGroupCur)
  For  &sql(fetch SSGroupCur into :SSGRPRowId,:SSGRPDesc) Q:SQLCODE  Do
  .if retStr="" Set retStr=SSGRPRowId_$c(1)_SSGRPDesc
  .Else  Set retStr=retStr_"^"_SSGRPRowId_$c(1)_SSGRPDesc
 &sql(CLOSE SSGroupCur)  
  Q retStr
}

ClassMethod GetSubCatStr(SSGroupRowid As %String) As %String
{
  set retStr=""
  &sql(declare TARSubCatCur cursor  for 
	   select TARSC_RowId,TARSC_Desc from SQLUSER.DHC_TarSubCate)
  &sql(open TARSubCatCur)
  For  &sql(fetch TARSubCatCur into :TARSCRowId,:TARSCDesc) Q:SQLCODE  Do
  .Set flag=0
  .If $O(^DHCTARCATCON("SSGROUP",SSGroupRowid,TARSCRowId,-1))'="" Set flag=1
  .if retStr="" Set retStr=TARSCRowId_$c(2)_flag_$c(1)_TARSCDesc
  .Else  Set retStr=retStr_"^"_TARSCRowId_$c(2)_flag_$c(1)_TARSCDesc
  &sql(CLOSE TARSubCatCur)  
  Q retStr
}

ClassMethod TarSubCatUpdate(SSGroupRowid As %String, Par As %String) As %String
{
  //w ##class(web.DHCDOCSetup).TarSubCatUpdate("4","2!3!4")
  TStart
  &sql(Delete from SQLUSER.DHC_TARSUBCAT_CONFINE where DHCTARCAT_SSGroup_DR=:SSGroupRowid)
  for i=1:1:$L(Par,"!") d
  .Set SubcatDr=$P(Par,"!",i)
  .&sql(Insert into SQLUSER.DHC_TARSUBCAT_CONFINE set DHCTARCAT_SSGroup_DR=:SSGroupRowid,DHCTARCAT_TarSubCate_DR=:SubcatDr)
  if SQLCODE TRollback  q "-104"
  TC	
  Q 0
}

ClassMethod RisArcimLookUp(EnterStr As %String) As %String
{
  //w ##class(web.DHCDOCSetup).RisArcimLookUp("ct")
  set retStr=""
  Set Count=0
  Set EnterStr=EnterStr_"%"
  &sql(declare RISARCIMALIAS cursor  for 
	   select ALIAS_ARCIM_DR->ARCIM_Rowid,ALIAS_ARCIM_DR->ARCIM_DESC from SQLUSER.ARC_ALIAS where alias_text like UCASE(:EnterStr))
  &sql(open RISARCIMALIAS)
  For  &sql(fetch RISARCIMALIAS into :ARCIMDR,:ARCIMDESC) Q:SQLCODE  Do
  .Q:(ARCIMDR="")||(ARCIMDESC="")
  .Set ServMaterial=$P(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),7),"^",6)
  .Q:ServMaterial'="S"
  .Set Count=Count+1
  .Q:Count>50
  .if retStr="" Set retStr=ARCIMDR_$c(1)_ARCIMDESC
  .Else  Set retStr=retStr_"^"_ARCIMDR_$c(1)_ARCIMDESC
  &sql(CLOSE RISARCIMALIAS)  
  Q retStr
}

ClassMethod DHCRISBodyAdd(ArcimRowid As %String) As %String
{
  If ArcimRowid="" Q "-100"
  if $O(^DHCRISBODY("ARCIM",ArcimRowid,-1))'="" Q "100"
  &sql(Insert into SQLUSER.DHC_RISBODY Set DHCRISBody_ARCIM_DR=:ArcimRowid)
  Q SQLCODE
}

ClassMethod GetRISBodyInfo(itmjs As %Library.String = "") As %String
{
   &sql(declare RISBodyInfoCUR cursor  for 
	   select DHCRISBody_Rowid,DHCRISBody_ARCIM_DR->ARCIM_desc,DHCRISBody_ARCIM_DR,DHCRISBody_BODYDesc from SQLUSER.DHC_RISBODY
	   )
  &sql(open RISBodyInfoCUR)
  For  &sql(fetch RISBodyInfoCUR into BodyRowid,ARCIMdesc,ARCIMRwoid,BODYDesc) Q:SQLCODE  Do
  .Q:(ARCIMdesc="")||(ARCIMRwoid="")
  .Set val=BodyRowid_"^"_ARCIMdesc_"^"_ARCIMRwoid_"^"_BODYDesc
  .Set retval=itmjs_"('"_$ZCVT(val,"O","JS")_"');"
  .&javascript<#(retval)#>
  &sql(CLOSE RISBodyInfoCUR)
  q 0
}

ClassMethod UpdateRisBody(Pat As %String, BodyRowid As %String) As %String
{
  &sql(Update SQLUSER.DHC_RISBODY Set DHCRISBody_BODYDesc=:Pat where DHCRISBody_Rowid=:BodyRowid)
  Q SQLCODE
}

ClassMethod DelRisBody(BodyRowid As %String) As %String
{
  &sql(delete from SQLUSER.DHC_RISBODY where DHCRISBody_Rowid=:BodyRowid )
  Q SQLCODE
}

ClassMethod GetUserByConfig() As %String
{
  //d ##class(web.DHCDOCSetup).GetUserByConfig()
   Set myfile="c:\config.txt"
   Open myfile:("FR":100)
   Use myfile:() 
   Read var1
   Close myfile
   w var1
}

ClassMethod BodySystem(RequTypeSelValue As %String) As %String
{
  //w ##class(web.DHCDOCSetup).BodySystem("2")
  Set RetStr=""
  If $D(^Temp("DHCREQue",$J))  do
  .K ^Temp("DHCREQue",$J)
  Set DHCPBPChildsub=""  For  Set DHCPBPChildsub=$O(^DHCREQSYS(RequTypeSelValue,"S",DHCPBPChildsub)) Q:DHCPBPChildsub=""  Do
  .Set DHCPBPDesc=$P(^DHCREQSYS(RequTypeSelValue,"S",DHCPBPChildsub),"^",4)
  .Set Serno=$P(^DHCREQSYS(RequTypeSelValue,"S",DHCPBPChildsub),"^",6)
  .Set ^Temp("DHCREQue",$J,Serno)=DHCPBPDesc_"^"_RequTypeSelValue_"||"_DHCPBPChildsub
  if $D(^Temp("DHCREQue",$J)) Do
  .Set Serno=""  for  Set Serno=$O(^Temp("DHCREQue",$J,Serno)) Q:Serno=""  Do
  ..Set Rowid=$P(^Temp("DHCREQue",$J,Serno),"^",2)
  ..Set DHCPBPDesc=$P(^Temp("DHCREQue",$J,Serno),"^",1)
  ..If RetStr="" Set RetStr=Rowid_$c(1)_DHCPBPDesc
  ..Else  Set RetStr=RetStr_"^"_Rowid_$c(1)_DHCPBPDesc
  If $D(^Temp("DHCREQue",$J)) K ^Temp("DHCREQue",$J)
  Q RetStr
}

ClassMethod PACSArcimInertMethod(ArcimValue As %String, id As %String, Parent As %String, Level As %String) As %String
{
  If ArcimValue="" Q ""
  If id=""  Q ""
  Set id=$P(id,"B",2)
  If (Level=3)||(Level>3) Set Type="A" 
  Else  Set Type="P"
  &sql(insert into SQLUSER.DHC_PASCArcimConfig Set DHCPACS_ARCIM_DR=:ArcimValue,DHCPACS_Parent_DR=:Parent,DHCPACS_Type=:Type)
  Quit SQLCODE
}

ClassMethod GetUserLOC(UserDR As %String) As %String
{
  //w ##class(web.DHCDOCSetup).GetUserLOC("1732")
  Set retStr=""
  if $O(^DHCPLANAD("USER",UserDR,-1))="" Q ""
  Set DHCPLANADRowid=$O(^DHCPLANAD("USER",UserDR,-1))
  Set CTLOCStr=$P(^DHCPLANAD(DHCPLANADRowid),"^",3)
  for i=1:1:$L(CTLOCStr,"!") d
  .set CTLOCRowid=$P(CTLOCStr,"!",i)
  .Q:CTLOCRowid=""
  .Set CTName=$P(^CTLOC(CTLOCRowid),"^",2)
  .Q:CTName=""
  .if retStr="" set retStr=CTLOCRowid_$c(1)_$P(CTName,"-",2)_"-"_$P(CTName,"-",1)
  .Else  Set retStr=retStr_"^"_CTLOCRowid_$c(1)_$P(CTName,"-",2)_"-"_$P(CTName,"-",1)
  q retStr
}

ClassMethod GetPACSArcimMethod(itmjs As %Library.String = "") As %String
{
  Set RetStr=""
  Set DHCPACSParentDR=""  For  Set DHCPACSParentDR=$O(^DHCPACSARCIM("Parent",DHCPACSParentDR)) Q:DHCPACSParentDR=""  Do
  .Set DHCPACSROWID=""  For  Set DHCPACSROWID=$O(^DHCPACSARCIM("Parent",DHCPACSParentDR,DHCPACSROWID)) Q:DHCPACSROWID=""  Do
  ..Set ARCIMDR=$P(^DHCPACSARCIM(DHCPACSROWID),"^",3)
  ..Set ARCIMDesc=$P(^ARCIM(+ARCIMDR,1,1),"^",2)
  ..Set Type=$P(^DHCPACSARCIM(DHCPACSROWID),"^",5)
  ..Set RetStr=DHCPACSParentDR_"^"_DHCPACSROWID_"^"_ARCIMDesc_"^"_Type
  ..Set retval=itmjs_"('"_$ZCVT(RetStr,"O","JS")_"');"
  ..&javascript<#(retval)#> 
  Q "0"
}

ClassMethod OSSearch(EnterStr As %String) As %String
{
  //w ##class(web.DHCDOCSetup).OSSearch("bc")
  set retStr=""
  Set Count=0
  Set EnterStr=EnterStr_"%"
  &sql(declare RISARCOSLIAS cursor  for 
	   select alias_arcos_dr,alias_arcos_dr->ARCOS_DESC from SQLUSER.ARC_ALIAS where alias_type='ARCOS' and alias_text like UCASE(:EnterStr))
  &sql(open RISARCOSLIAS)
  For  &sql(fetch RISARCOSLIAS into :ARCOSDR,:ARCOSDESC) Q:SQLCODE  Do
  .Q:(ARCOSDR="")||(ARCOSDESC="")
  .Set OrdSubCat=$P(^ARCOS(ARCOSDR),"^",9)
  .Q:OrdSubCat'=341  //检查医嘱套的值是341
  .Set Count=Count+1
  .Q:Count>50
  .if retStr="" Set retStr=ARCOSDR_$c(1)_ARCOSDESC
  .Else  Set retStr=retStr_"^"_ARCOSDR_$c(1)_ARCOSDESC
  &sql(CLOSE RISARCOSLIAS)  
  Q retStr
}

ClassMethod GetOrderSet(ARCOSRowid As %String) As %String
{
  //w ##class(web.DHCDOCSetup).GetOrderSet("205")
  Set RetStr=""
  if ARCOSRowid="" Q ""
  if '$D(^ARCOS(ARCOSRowid)) Q ""
  Set ARCOSDateRowid=##class(web.DHCDocOrderEntry).GetOrderSetDate(ARCOSRowid)
  Set item=0 For  Set item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) Q:item=""  Set s=^(item) Do
  .Set ARCIMRowid=$P(s,"^",1)
  .Q:##class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
  .Set ARCOSItemQty=$p(s,"^",2)
  .if ARCOSItemQty="" s ARCOSItemQty=1
  .Set ArcimDesc=$P(^ARCIM(+ARCIMRowid,1,1),"^",2)
  .if RetStr="" Set RetStr=ARCIMRowid_$c(1)_ARCOSItemQty_$c(1)_ArcimDesc
  .Else  Set RetStr=RetStr_"^"_ARCIMRowid_$c(1)_ARCOSItemQty_$c(1)_ArcimDesc
  Q RetStr
}

ClassMethod DelPACSArcim(IdStr As %String) As %String
{
  If IdStr="" Q ""
  For i=1:1:$L(IdStr,"^") Do
  .Set DHCPACSROWID=$P(IdStr,"^",i)
  .&Sql(Delete from SQLUSER.DHC_PASCArcimConfig Where DHCPACS_ROWID=:DHCPACSROWID)
  Q SQLCODE
}

ClassMethod GetPACSArcim(ArcimStr As %String) As %String
{
  If ArcimStr="" Q ""
  Set RetStr=""
  For i=1:1:$L(ArcimStr,"^") Do
  .Set DHCPACSRowid=$P(ArcimStr,"^",i)
  .Set ArcimRowid=$P($g(^DHCPACSARCIM(DHCPACSRowid)),"^",3)
  .Q:ArcimRowid=""	
  .If RetStr="" Set RetStr=ArcimRowid
  .Else  Set RetStr=RetStr_"^"_ArcimRowid
  Q RetStr
}

ClassMethod GetAddArcimInfo(itmjs As %Library.String = "") As %String
{
  //w ##class(web.DHCDOCSetup).GetAddArcimInfo("205")
  Set RetStr=0
  Set DHCARCRowid=""
  For  Set DHCARCRowid=$O(^DHCPACSARCTOARC(DHCARCRowid)) Q:DHCARCRowid=""  Do
  .Q:DHCARCRowid="NorArcim"
  .Set ArcimRowid=$P(^DHCPACSARCTOARC(DHCARCRowid),"^",2)
  .Set AddArcimRowid=$P(^DHCPACSARCTOARC(DHCARCRowid),"^",3)
  .Set ArcimDesc=$P(^ARCIM(+ArcimRowid,1,1),"^",2)
  .Set AddArcimDesc=$P(^ARCIM(+AddArcimRowid,1,1),"^",2)
  .Set val=ArcimDesc_"^"_AddArcimDesc_"^"_DHCARCRowid_"^"_ArcimRowid_"^"_AddArcimRowid
  .Set retval=itmjs_"('"_$ZCVT(val,"O","JS")_"');"
  .&javascript<#(retval)#>
  Q RetStr
}

ClassMethod AddArcimInsert(ArcimRowid As %String, AddArcimRowid As %String) As %String
{
  If ArcimRowid="" Q ""
  If AddArcimRowid="" Q ""
  if $O(^DHCPACSARCTOARC("NorArcim",ArcimRowid,-1))'="" Q "100"
  &sql(Insert into SQLUSER.DHC_PACSArcimtoArcim Set DHCARC_Nor_Arcim_DR=:ArcimRowid,DHCARC_Add_Arcim_DR=:AddArcimRowid)
  Q SQLCODE
}

ClassMethod DelAddArcimInfo(DHCARCRowid As %String) As %String
{
  If DHCARCRowid="" Q ""
  &sql(Delete From SQLUSER.DHC_PACSArcimtoArcim where DHCARC_Rowid=:DHCARCRowid)
  Q SQLCODE
}

/// Add By 2009-7-8 Yanjiyan
ClassMethod DHCPACSSystemInfo(itmjs As %Library.String = "") As %String
{
  //w ##class(web.DHCDOCSetup).DHCPACSSystemInfo("f")
  Set RetStr=""
  Set PACSBODYRowid="" For  Set PACSBODYRowid=$O(^DHCREQSYS(PACSBODYRowid)) Q:PACSBODYRowid=""  Do
  .Set PACSBODYDesc=$P($G(^DHCREQSYS(PACSBODYRowid)),"^",2)
  .Set PACSBODYCode=$P($G(^DHCREQSYS(PACSBODYRowid)),"^",3)
  .Set RetStr=PACSBODYRowid_"^"_PACSBODYDesc_"^"_PACSBODYCode
  .Set retval=itmjs_"('"_$ZCVT(RetStr,"O","JS")_"');"
  .&javascript<#(retval)#> 
  Q "0"
}

ClassMethod DHCPACSSystemInsertMethod(desc As %String, Code As %String) As %String
{
  Set RetStr=""	
  Set PACSBODYRowid=""  For  Set PACSBODYRowid=$O(^DHCREQSYS(PACSBODYRowid)) Q:PACSBODYRowid=""  Do
  .Set PACSBODYDesc=$P($G(^DHCREQSYS(PACSBODYRowid)),"^",2)
  .Set PACSBODYCode=$P($G(^DHCREQSYS(PACSBODYRowid)),"^",3)
  .If PACSBODYDesc=desc Set RetStr="100"
  .If PACSBODYCode=Code Set RetStr="101"
  If RetStr'="" Q RetStr
  &Sql(Insert Into SQLUSER.DHC_RequeType Set REQType_Desc=:desc,REQType_Code=:Code)
  Q SQLCODE
}

ClassMethod DHCPACSSystemDeleteMethod(Rowid As %String) As %String
{
  If Rowid="" Q "102"
  &sql(Delete From SQLUSER.DHC_RequeType Where REQType_Rowid=:Rowid)
  Q SQLCODE
}

ClassMethod RequType() As %String
{
  //w ##class(web.DHCDOCSetup).RequType()
  Set Ret=""
  Set TypeRowid=""  For  Set TypeRowid=$O(^DHCREQSYS(TypeRowid)) Q:TypeRowid=""  Do
  .Set Typedesc=$P(^DHCREQSYS(TypeRowid),"^",2)
  .If Ret="" Set Ret=TypeRowid_$c(1)_Typedesc
  .Else  Set Ret=Ret_"^"_TypeRowid_$c(1)_Typedesc
  Q Ret
}

ClassMethod RequSysInsert(RequType As %String, RequSysDesc As %String) As %String
{
  //w ##class(web.DHCDOCSetup).RequSysInsert("2","bc")
  Set Flag=0
  Set sublen=0
  Set newSub=0
  Set DHCPBPChildsub=""  For  Set DHCPBPChildsub=$O(^DHCREQSYS(RequType,"S",DHCPBPChildsub)) Q:DHCPBPChildsub=""  Do
  .Set DHCPBPDesc=$P(^DHCREQSYS(RequType,"S",DHCPBPChildsub),"^",4)
  .Set sublen=sublen+1
  .If DHCPBPDesc=RequSysDesc Set Flag=1
  .If (DHCPBPChildsub'="") Set newSub=DHCPBPChildsub
  If Flag=1 Q "100"
  Set sublen=sublen+1
  Set newSub=newSub+1
  &sql(Insert into SQLUSER.DHC_RequSystem Set DHC_PBP_Desc=:RequSysDesc,DHC_PBP_ParRef=:RequType,DHC_PBP_Childsub=:newSub,DHC_PBP_No=:sublen)
  Q SQLCODE
}

ClassMethod RequSysSerNo(str As %String) As %String
{
  For i=1:1:$L(str,"^") Do
  .Set Rowid=$P(str,"^",i)
  .&sql(update SQLUSER.DHC_RequSystem Set DHC_PBP_No=:i where DHC_PBP_Rowid=:Rowid)
  Q SQLCODE
}

ClassMethod RequItemInsert(ArcimRowid As %String, SysRowid As %String) As %String
{
  //w  ##class(web.DHCDOCSetup).RequItemInsert("100||1","2||1")
  Set RetStr=""
  Set sublen=0
  Set NewSub=0
  Set RequTypeRRowid=$P(SysRowid,"||",1)
  Set SysChldRowid=$P(SysRowid,"||",2)
  Set PBIChildsub=""  For  Set PBIChildsub=$O(^DHCREQSYS(RequTypeRRowid,"S",SysChldRowid,"I",PBIChildsub)) Q:PBIChildsub=""  Do
  .Set PBIARCIMDR=$P(^DHCREQSYS(RequTypeRRowid,"S",SysChldRowid,"I",PBIChildsub),"^",4)
  .Set sublen=sublen+1
  .If PBIARCIMDR=ArcimRowid Set RetStr="100"
  .If PBIChildsub'="" Set NewSub=PBIChildsub
  If RetStr'="" Q RetStr
  Set sublen=sublen+1
  Set NewSub=NewSub+1
  &sql(Insert into SQLUSER.DHC_RequSysItem Set DHC_PBI_ParRef=:SysRowid,DHC_PBI_Childsub=:NewSub,DHC_PBI_ARCIMDR=:ArcimRowid,DHC_PBI_No=:sublen)
  Q SQLCODE
}

ClassMethod RequItemGetItem(SysRowid As %String) As %String
{
  //w  ##class(web.DHCDOCSetup).RequItemGetItem("2||3")
  Set RetStr=""
  Set RequTypeRRowid=$P(SysRowid,"||",1)
  Set SysChldRowid=$P(SysRowid,"||",2)
  If $D(^Temp("DHCREQueItem",$J)) do
  .K ^Temp("DHCREQueItem",$J)
  Set PBIChildsub=""  For  Set PBIChildsub=$O(^DHCREQSYS(RequTypeRRowid,"S",SysChldRowid,"I",PBIChildsub)) Q:PBIChildsub=""  Do
  .Set PBIARCIMDR=$P(^DHCREQSYS(RequTypeRRowid,"S",SysChldRowid,"I",PBIChildsub),"^",4)
  .Set PBINo=$P(^DHCREQSYS(RequTypeRRowid,"S",SysChldRowid,"I",PBIChildsub),"^",5)
  .Set ^Temp("DHCREQueItem",$J,PBINo)=SysRowid_"||"_PBIChildsub_"^"_PBIARCIMDR
  If $D(^Temp("DHCREQueItem",$J)) Do 
  .Set PBINo="" For  Set PBINo=$O(^Temp("DHCREQueItem",$J,PBINo)) Q:PBINo=""  Do
  ..Set ItemRowid=$P(^Temp("DHCREQueItem",$J,PBINo),"^",1)
  ..Set ItemArcimRowid=$P(^Temp("DHCREQueItem",$J,PBINo),"^",2)
  ..Set ItemDesc=$P(^ARCIM(+ItemArcimRowid,1,1),"^",2)
  ..Q:ItemDesc=""
  ..If RetStr="" Set RetStr=ItemRowid_$c(1)_ItemDesc
  ..Else  Set RetStr=RetStr_"^"_ItemRowid_$c(1)_ItemDesc
  If $D(^Temp("DHCREQueItem",$J)) Do  k ^Temp("DHCREQueItem",$J)
  Q RetStr
}

ClassMethod ItemSerNo(str As %String) As %String
{
   For i=1:1:$L(str,"^") Do
  .Set Rowid=$P(str,"^",i)
  .&sql(update SQLUSER.DHC_RequSysItem Set DHC_PBI_No=:i where DHC_PBI_Rowid=:Rowid)
  Q SQLCODE
}

ClassMethod RequSysDel(SysRowid As %String) As %String
{
  &sql(Delete from SQLUSER.DHC_RequSystem where DHC_PBP_Rowid=:SysRowid)	
  If (SQLCODE=0) Do
  .&sql(Delete from SQLUSER.DHC_RequSysItem where DHC_PBI_ParRef=:SysRowid)
  Set RequTypeRRowid=$P(SysRowid,"||",1)
  Set SysChldRowid=$P(SysRowid,"||",2)
  Set i=1
  If $D(^Temp("DHCREQueSysNo",$J)) do
  .k ^Temp("DHCREQueSysNo",$J)
  Set SysChldRowid="" For  Set SysChldRowid=$O(^DHCREQSYS(RequTypeRRowid,"S",SysChldRowid)) Q:SysChldRowid=""  Do
  .Set DHCPBPNo=$P(^DHCREQSYS(RequTypeRRowid,"S",SysChldRowid),"^",6)
  .Set ^Temp("DHCREQueSysNo",$J,DHCPBPNo)=RequTypeRRowid_"||"_SysChldRowid
  If $D(^Temp("DHCREQueSysNo",$J)) Do
  .Set Serno="" For  Set Serno=$O(^Temp("DHCREQueSysNo",$J,Serno)) Q:Serno=""  Do
  ..Set SysChldRowid=^Temp("DHCREQueSysNo",$J,Serno)
  ..&sql(update SQLUSER.DHC_RequSystem Set DHC_PBP_No=:i where DHC_PBP_Rowid=:SysChldRowid)
  ..Set i=i+1
  If $D(^Temp("DHCREQueSysNo",$J)) do
  .k ^Temp("DHCREQueSysNo",$J)
  Q SQLCODE
}

ClassMethod RequItemDel(ItemRowid As %String) As %String
{
  &sql(Delete from SQLUSER.DHC_RequSysItem where DHC_PBI_Rowid=:ItemRowid)
  If (SQLCODE=0) Do
  .Set RequTypeRRowid=$P(ItemRowid,"||",1)	
  .Set SysChldRowid=$P(ItemRowid,"||",2)
  .If $D(^Temp("DHCREItenSerno",$J)) do
  ..K ^Temp("DHCREItenSerno",$J)
  .Set PBIChildsub="" For  Set PBIChildsub=$O(^DHCREQSYS(RequTypeRRowid,"S",SysChldRowid,"I",PBIChildsub)) Q:PBIChildsub=""  Do
  ..Set PBINo=$P(^DHCREQSYS(RequTypeRRowid,"S",SysChldRowid,"I",PBIChildsub),"^",5)
  ..Set ^Temp("DHCREItenSerno",$J,PBINo)=RequTypeRRowid_"||"_SysChldRowid_"||"_PBIChildsub
  Set i=1
  If $D(^Temp("DHCREItenSerno",$J)) do
  .Set PBINo=""  For  Set PBINo=$O(^Temp("DHCREItenSerno",$J,PBINo))  Q:PBINo=""  Do
  ..Set PBIRowid=^Temp("DHCREItenSerno",$J,PBINo)
  ..&sql(update SQLUSER.DHC_RequSysItem Set DHC_PBI_No=:i where DHC_PBI_Rowid=:PBIRowid)
  ..Set i=i+1
  If $D(^Temp("DHCREItenSerno",$J)) do
  .K ^Temp("DHCREItenSerno",$J)
  Q SQLCODE
}

ClassMethod GetRequType(RequTypevalue As %String) As %String
{
  //w ##class(web.DHCDOCSetup).GetRequType("BC")
  Set Ret=""
  Set TypeRowid=""  For  Set TypeRowid=$O(^DHCREQSYS(TypeRowid)) Q:TypeRowid=""  Do
  .Set Typedesc=$P(^DHCREQSYS(TypeRowid),"^",2)
  .Set REQTypeCode=$P(^DHCREQSYS(TypeRowid),"^",3)
  .If REQTypeCode=RequTypevalue Set Ret=$G(TypeRowid)_"^"_Typedesc 
  Q Ret
}

ClassMethod TransArcim(ArcimStr As %String) As %String
{
  If ArcimStr="" Q ""
  Set Flag=0
  Set RetStr=""
  For i=1:1:$L(ArcimStr,"^") Do
  .Set ItemRowid=$P(ArcimStr,"^",i)
  .Set RequTypeRRowid=$P(ItemRowid,"||",1)	
  .Set SysChldRowid=$P(ItemRowid,"||",2)
  .Set PBIChildsub=$P(ItemRowid,"||",3)
  .Set ArcimRowid=$P(^DHCREQSYS(RequTypeRRowid,"S",SysChldRowid,"I",PBIChildsub),"^",4)
  .Q:ArcimRowid=""	
  .If $O(^DHCPACSARCTOARC("NorArcim",ArcimRowid,-1))'=""  Do
  ..Set ArcimAdd=$O(^DHCPACSARCTOARC("NorArcim",ArcimRowid,-1))
  ..If Flag=1 Set ArcimRowid=$P($G(^DHCPACSARCTOARC(ArcimAdd)),"^",3)
  ..Set Flag=1
  .If RetStr="" Set RetStr=ArcimRowid
  .Else  Set RetStr=RetStr_"^"_ArcimRowid
  Q RetStr
}

ClassMethod ReadCardTypeDefault() As %String
{
	///读取卡类型定义
	//w ##class(web.DHCDOCSetup).ReadCardTypeDefault()
	s myTypeID=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s RetStr=""
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.Q:myDefault="N"
	.Set RetStr=myval
	q RetStr
}

ClassMethod GetSpecMethod() As %String
{
 //d ##class(web.DHCDOCSetup).GetSpecMethod()
 Set RetStr=""
 Set SPECCode="" For  Set SPECCode=$O(^TTAB("SPEC",SPECCode)) Q:SPECCode=""  Do
 .Set SPECDesc=$P(^TTAB("SPEC",SPECCode),"\",1)
 .Set Flag=0
 .If $D(^DHCDOCLABSPEC(SPECCode)) Set Flag=1
 .If RetStr="" Set RetStr=SPECCode_$c(1)_SPECDesc_$c(1)_Flag
 .Else  Set RetStr=RetStr_$c(2)_SPECCode_$c(1)_SPECDesc_$c(1)_Flag
 Q RetStr
}

ClassMethod SaveSpec(id As %String) As %String
{
  K ^DHCDOCLABSPEC
  Set Blood=$P(id,$c(1),2)
  Set Blood1=$P(id,$c(1),3)
  Set RelocFlag=$P(id,$c(1),4)
  Set BloodFlag=$P(id,$c(1),5)
  Set id=$P(id,$c(1),1)

  For i=1:1:$L(id,",") Do
  .Set Spec=$P(id,",",i)
  .Q:Spec=""
  .Set ^DHCDOCLABSPEC(Spec)=""
  Set ^DHCDOCLABBlood=Blood
  Set ^DHCDOCLABBlood1=Blood1
  Set ^DHCDOCLABReloc=RelocFlag
  Set ^DHCDOCLABBloodStatus=BloodFlag
  Q 0
}

ClassMethod GetLabCTLOC() As %String
{
  //w ##class(web.DHCDOCSetup).GetLabCTLOC()
  Set RetStr=""
  Set CTLOCRowid="" For  Set CTLOCRowid=$O(^CTLOC(0,"LocType","E",CTLOCRowid)) Q:CTLOCRowid=""  Do
  .Set CTLOCDesc=$P($P($G(^CTLOC(CTLOCRowid)),"^",2),"-",2)
  .Q:CTLOCDesc=""
  .Set DepDR=$P($G(^CTLOC(CTLOCRowid)),"^",19)
  .Q:DepDR'="3"
  .Set Flag=0
  .If $D(^DHCDOCLABCTLOC(CTLOCRowid)) Set Flag=1
  .If RetStr="" Set RetStr=CTLOCRowid_$C(1)_CTLOCDesc_$C(1)_Flag
  .Else  Set RetStr=RetStr_$c(2)_CTLOCRowid_$C(1)_CTLOCDesc_$C(1)_Flag
  Q RetStr
}

ClassMethod SaveLABCTLOC(id As %String) As %String
{
  K ^DHCDOCLABCTLOC
  For i=1:1:$L(id,",") Do
  .Set CTLOCRowid=$P(id,",",i)
  .Q:CTLOCRowid=""
  .Set ^DHCDOCLABCTLOC(CTLOCRowid)=""
  Q 0
}

ClassMethod LisOSSearch(EnterStr As %String) As %String
{
  //w ##class(web.DHCDOCSetup).LisOSSearch("bc")
  set retStr=""
  Set Count=0
  Set EnterStr=EnterStr_"%"
  &sql(declare LisARCOSLIAS cursor  for 
	   select ALIAS_ARCIM_DR,alias_arcim_dr->ARCIM_DESC from SQLUSER.ARC_ALIAS where alias_type='ARCIM' and alias_text like UCASE(:EnterStr))
  &sql(open LisARCOSLIAS)
  For  &sql(fetch LisARCOSLIAS into :ARCOSDR,:ARCOSDESC) Q:SQLCODE  Do
  .Q:(ARCOSDR="")||(ARCOSDESC="")
  .Set Count=Count+1
  .Q:Count>50
  .if retStr="" Set retStr=ARCOSDR_$c(1)_ARCOSDESC
  .Else  Set retStr=retStr_"^"_ARCOSDR_$c(1)_ARCOSDESC
  &sql(CLOSE LisARCOSLIAS)  
  Q retStr
}

ClassMethod GetOSItem()
{
  Q 0
}

ClassMethod InsertItem(CTLOCRowid As %String, ArcimRowid As %String) As %String
{
 If $D(^DHCLRAi("CTLOC",CTLOCRowid,ArcimRowid)) Q "100"
 &sql(insert into SQLUSER.DHC_LisReLocArcim Set LRA_CTLOC_Dr=:CTLOCRowid,LRA_ARCIM_Dr=:ArcimRowid)	
 Q SQLCODE
}

ClassMethod ShowItem(CTLOCRowid As %String) As %String
{
 //w ##class(web.DHCDOCSetup).ShowItem("31")
 Set RetStr=""
 Set ArcimRowid="" For  Set ArcimRowid=$O(^DHCLRAi("CTLOC",CTLOCRowid,ArcimRowid))  Q:ArcimRowid=""  Do
 .Set ArcimDesc=$P(^ARCIM(+ArcimRowid,1,1),"^",2)
 .If RetStr="" Set RetStr=ArcimRowid_$C(1)_ArcimDesc
 .Else  Set RetStr=RetStr_"^"_ArcimRowid_$C(1)_ArcimDesc
 Q RetStr
}

ClassMethod DelArcim(CTLOCRowid As %String, ArcimRowid As %String) As %String
{
 &sql(Delete From SQLUSER.DHC_LisReLocArcim Where LRA_CTLOC_Dr=:CTLOCRowid And LRA_ARCIM_Dr=:ArcimRowid)
 Q SQLCODE
}

ClassMethod GetBloodCTloc(Str As %String) As %String
{
  //w ##class(web.DHCDOCSetup).GetBloodCTloc("j")
  Set RetStr=""
  Set CTLOCRowid="" For  Set CTLOCRowid=$O(^CTLOC(0,"LocType","E",CTLOCRowid)) Q:CTLOCRowid=""  Do
  .Set CTLOCDesc=$P($P($G(^CTLOC(CTLOCRowid)),"^",2),"-",2)
  .Set CTLOCCode=$P($P($G(^CTLOC(CTLOCRowid)),"^",2),"-",1)
  .Q:$ZCONVERT(CTLOCCode,"U")'[$ZCONVERT(Str,"U")
  .Q:CTLOCDesc=""
  .Set DepDR=$P($G(^CTLOC(CTLOCRowid)),"^",19)
  .Q:DepDR'="3"
  .Set Flag=0
  .;If $D(^DHCDOCLABCTLOC(CTLOCRowid)) Set Flag=1
  .If RetStr="" Set RetStr=CTLOCRowid_$C(1)_CTLOCDesc_$C(1)_Flag
  .Else  Set RetStr=RetStr_"^"_CTLOCRowid_$C(1)_CTLOCDesc_$C(1)_Flag
  Q RetStr
}

ClassMethod SaveBloodLoc(LocRowid As %String) As %String
{
   Set ^DHCBloodLoc(LocRowid)=""
   Q 0
}

ClassMethod FindBloodTaking() As %String
{
  //w ##class(web.DHCDOCSetup).FindBloodTaking()
  Set RetStr=""
  Set LocRowid="" For  Set LocRowid=$O(^DHCBloodLoc(LocRowid)) Q:LocRowid=""  Do
  .Q:'$D(^DHCBloodLoc(LocRowid))
  .Set CTLOCDesc=$P($P($G(^CTLOC(LocRowid)),"^",2),"-",2)
  .If RetStr="" Set RetStr=LocRowid_$c(1)_CTLOCDesc
  .Else  Set RetStr=RetStr_"^"_LocRowid_$c(1)_CTLOCDesc
  Q RetStr
}

ClassMethod DelBloodTaking(CTLOC As %String) As %String
{
  K ^DHCBloodLoc(CTLOC)
  Q 0
}

ClassMethod SaveBloodLinkCTLOC(SCTLOC As %String, ToCTLOC As %String) As %String
{
  if $D(^DHCBloodLoc(SCTLOC,ToCTLOC)) Q "100"
  Set ^DHCBloodLoc(SCTLOC,ToCTLOC)=""
  Q 0
}

ClassMethod LinkInfo(SCTLOC As %String) As %String
{
  if '$D(^DHCBloodLoc(SCTLOC)) Q ""
  Set RetStr=""
  Set Rowid="" For  Set Rowid=$O(^DHCBloodLoc(SCTLOC,Rowid)) Q:Rowid=""  Do
  .Set CTLOCDesc=$P($P($G(^CTLOC(Rowid)),"^",2),"-",2)
  .If RetStr="" Set RetStr=Rowid_$c(1)_CTLOCDesc
  .Else  Set RetStr=RetStr_"^"_Rowid_$c(1)_CTLOCDesc
  Q RetStr
}

ClassMethod DelLinkInfo(SCTLOC As %String, ItemCTLOC As %String) As %String
{
  if '$D(^DHCBloodLoc(SCTLOC,ItemCTLOC)) Q ""
  K ^DHCBloodLoc(SCTLOC,ItemCTLOC)
  Q 0
}

}
