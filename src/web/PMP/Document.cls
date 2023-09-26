Import sqluser

/// Creat  zzp
/// date:2015-05-15
/// description: 档案管理类
Class web.PMP.Document Extends (%RegisteredObject, DHCPM.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creat  zzp
/// date:2015-05-20
/// description: 同步操作记录(公用方法)
/// input1:  TabMessage(TabName:表名@@TabRowid:记录的表Rowid@@TabType:操作类型(Add/Update/Delete/Other)@@IP:操作的ip地址)
/// input2:  OldValue(用@@区分)  Add 时该值可以为空
/// input3:  NewValue(用@@区分)
/// input4:  TabFieldName(用@@区分)   注意：input2,input3,input4完全对应
/// oupput:  1:成功
/// Other:   w ##class(web.PMP.Document).PMPOperatingRecord("PMP_Company@@1@@Update@@192.168.1.13","2015051401@@东华软件股份公司@@北京市海淀区资金数码园3号楼东华合创大厦","2015051401@@东华软件股份公司@@北京市海淀区资金数码园3号楼东华合创大厦","PC_Code@@PC_Desc@@PC_Address")
/// Other:   w ##class(web.PMP.Document).PMPOperatingRecord("PMP_Company@@1@@Add@@192.168.1.13","","2015051401@@东华软件股份公司@@北京市海淀区资金数码园3号楼东华合创大厦","PC_Code@@PC_Desc@@PC_Address")
/// Other:   w ##class(web.PMP.Document).PMPOperatingRecord("PMP_Company@@1@@Delete@@192.168.1.13","","","")
ClassMethod PMPOperatingRecord(TabMessage As %Text, OldValue As %Text, NewValue As %Text, TabFieldName As %Text) As %String
{
	s ret=""
	;s ^Temp("PMPOperatingRecord")=OldValue_"^"_NewValue_"^"_TabFieldName
	s UserId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	s UpdateDate=+$h,UpdateTime=$p($h,",",1),Revelance=""
	q:(TabMessage="")||($l(TabMessage,"@@")'=4) "-1"
	q:$l(NewValue,"@@")'=$l(TabFieldName,"@@") "-2"
	q:(OldValue'="")&($L(OldValue,"@@")'=$L(NewValue,"@@")) "-3"
	s TabName=$p($g(TabMessage),"@@",1)
	s TabRowid=$p($g(TabMessage),"@@",2)
	s TabType=$p($g(TabMessage),"@@",3)
	s IP=$p($g(TabMessage),"@@",4)
	f id=1:1:$l(TabFieldName,"@@")  d
	.s (TempOldValue,TempNewValue,TempTabFieldName)=""
	.i OldValue'="" s TempOldValue=$p(OldValue,"@@",id)
	.s TempNewValue=$p(NewValue,"@@",id)
	.s TempTabFieldName=$p(TabFieldName,"@@",id)
	.d InsertValue
	q ret
InsertValue
    Ts
    s object=##Class(User.PMPOperatingRecord).%New()
    i TabName'="" s object.PORTabName=TabName
    i TabRowid'="" s object.PORTabRowid=TabRowid
    i TabType'="" s object.PORType=TabType
    i TempTabFieldName'="" s object.PORFieldName=TempTabFieldName
    i TempOldValue'="" s object.POROldVlaue=TempOldValue
    i TempNewValue'="" s object.PORNewValue=TempNewValue
    s object.PORUpdateUser=UserId
    s object.PORUpdateDate=UpdateDate
    s object.PORUpdateTime=UpdateTime
    i IP'="" s object.PORIP=IP
    i id'="1" d
    .s objectRevelance=##Class(User.PMPOperatingRecord).%OpenId(Revelance)
    .s object.PORRevelance=objectRevelance
    s rc=object.%Save()
	if (rc)
	{
		Tc
		i id="1" s Revelance=object.%Id()
	}
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取公司详细数据
/// input:  type()
/// output: String "CompanyGridRowid^CompanyGridCode^CompanyGridDesc^CompanyGridAddress^CompanyGridPhone^CompanyGridWebsite^CompanyGridEmail^CompanyGridLawPerson^CompanyGridType^CompanyGridListing^CompanyGridPhone1^CompanyGridPhone2^CompanyGridPostCdoe^CompanyGridEmail1^CompanyGridEmail2^CompanyGridFlag^CompanyGridRemark^CompanyGridCreatUser^CompanyGridCreatDate^CompanyGridCreatTime"
/// others:
ClassMethod CompanyGridStoreold(InPut As %Text)
{
 s i=0 
 s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
 ;s ^CacheTemp("CompanyGridStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s id=0
 f  s id=$o(^PMPCompany(id)) q:id=""  d
 .s (CompanyGridRowid,CompanyGridCode,CompanyGridDesc,CompanyGridAddress,CompanyGridPhone,CompanyGridWebsite,CompanyGridEmail,CompanyGridLawPerson,CompanyGridType,CompanyGridListing,CompanyGridPhone1,CompanyGridPhone2,CompanyGridPostCdoe,CompanyGridEmail1,CompanyGridEmail2,CompanyGridFlag,CompanyGridRemark,CompanyGridCreatUser,CompanyGridCreatDate,CompanyGridCreatTime)=""
 .s CompanyGridCode=$p($G(^PMPCompany(id)),"^",1)
 .q:CompanyGridCode=""
 .s CompanyGridRowid=id
 .s CompanyGridDesc=$p($G(^PMPCompany(id)),"^",2)
 .s CompanyGridAddress=$p($G(^PMPCompany(id)),"^",3)
 .s CompanyGridPhone=$p($G(^PMPCompany(id)),"^",4)
 .s CompanyGridWebsite=$p($G(^PMPCompany(id)),"^",7)
 .s CompanyGridEmail=$p($G(^PMPCompany(id)),"^",12)
 .s CompanyGridLawPerson=$p($G(^PMPCompany(id)),"^",9)
 .s CompanyGridTypeid=$p($G(^PMPCompany(id)),"^",10)
 .i CompanyGridTypeid'="" s CompanyGridType=$p(^PMPDictionary(CompanyGridTypeid),"^",2)
 .s CompanyGridListingid=$p($G(^PMPCompany(id)),"^",11)
 .s CompanyGridListing=$select(CompanyGridListingid="Y":"上市",CompanyGridListingid="N":"未上市",CompanyGridListingid="":"其他")
 .s CompanyGridPhone1=$p($G(^PMPCompany(id)),"^",5)
 .s CompanyGridPhone2=$p($G(^PMPCompany(id)),"^",6)
 .s CompanyGridPostCdoe=$p($G(^PMPCompany(id)),"^",8)
 .s CompanyGridEmail1=$p($G(^PMPCompany(id)),"^",13)
 .s CompanyGridEmail2=$p($G(^PMPCompany(id)),"^",14)
 .s CompanyGridFlagid=$p($G(^PMPCompany(id)),"^",30)
 .q:CompanyGridFlagid'="Y"
 .s CompanyGridFlag=$select(CompanyGridFlagid="Y":"有效",CompanyGridFlagid="N":"无效",CompanyGridFlagid="":"无效")
 .s CompanyGridRemark=$p($G(^PMPCompany(id)),"^",31)
 .s CompanyGridCreatUserid=$p($G(^PMPCompany(id)),"^",15)
 .i CompanyGridCreatUserid'="" s CompanyGridCreatUser=##Class(web.PMP.Document).SSUSER(CompanyGridCreatUserid)
 .i IndependentUserRet'="Y" s CompanyGridCreatUserid=+CompanyGridCreatUserid
 .S CompanyGridCreatDate=$p($G(^PMPCompany(id)),"^",16)
 .i CompanyGridCreatDate'="" s CompanyGridCreatDate=$zd(CompanyGridCreatDate,3)
 .s CompanyGridCreatTime=$p($G(^PMPCompany(id)),"^",17)
 .i CompanyGridCreatTime'="" s CompanyGridCreatTime=$zt(CompanyGridCreatTime)
 .;s namedesc=##Class(web.DHCINSUPort).GetCNCODE(desc,4,"")_desc
 .;q:(InPut'="")&(namedesc'[InPut)
 .s i=i+1
 .s tmp=CompanyGridRowid_"^"_CompanyGridCode_"^"_CompanyGridDesc_"^"_CompanyGridAddress_"^"_CompanyGridPhone_"^"_CompanyGridWebsite_"^"_CompanyGridEmail_"^"_CompanyGridLawPerson_"^"_CompanyGridType_"^"_CompanyGridListing_"^"_CompanyGridPhone1_"^"_CompanyGridPhone2_"^"_CompanyGridPostCdoe_"^"_CompanyGridEmail1_"^"_CompanyGridEmail2_"^"_CompanyGridFlag_"^"_CompanyGridRemark_"^"_CompanyGridCreatUser_"^"_CompanyGridCreatDate_"^"_CompanyGridCreatTime
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("CompanyGridRowid^CompanyGridCode^CompanyGridDesc^CompanyGridAddress^CompanyGridPhone^CompanyGridWebsite^CompanyGridEmail^CompanyGridLawPerson^CompanyGridType^CompanyGridListing^CompanyGridPhone1^CompanyGridPhone2^CompanyGridPostCdoe^CompanyGridEmail1^CompanyGridEmail2^CompanyGridFlag^CompanyGridRemark^CompanyGridCreatUser^CompanyGridCreatDate^CompanyGridCreatTime",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取公司类型
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod CompanyMenuTypeStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("CompanyMenuTypeStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","CompanyType",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取公司是否上市
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod CompanyMenuListingStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("CompanyMenuListingStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 f id=1:1:3  d
 .s RowId=$select(id="1":"Other",id="2":"Y",id="3":"N")
 .s Description=$select(id="1":"其他",id="2":"已上市",id="3":"未上市")
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取产品类型
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ProductTypeStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ProductTypeStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","ProductType",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取供应商
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ProductSupplierStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ProductSupplierStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=0
 f  s RowId=$o(^PMPCompany(RowId)) q:RowId=""  d
 .s CompanyGridCode=$p($G(^PMPCompany(RowId)),"^",1)
 .s CompanyGridFlagid=$p($G(^PMPCompany(RowId)),"^",30)
 .q:CompanyGridFlagid'="Y"
 .q:CompanyGridCode=""
 .s CompanyGridDesc=$p($G(^PMPCompany(RowId)),"^",2)
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(CompanyGridDesc,4,"")_CompanyGridDesc
 .s i=i+1
 .s tmp=RowId_"^"_CompanyGridDesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取产品数据
/// input:  ProductCode , ProductDesc , ProductSupplier , ProductType
/// output: String ProductGridRowid,ProductGridCode,ProductGridDesc,ProductGridType,ProductGridTypeid,ProductGridVersions,ProductGridStandard,ProductGridSupplier,ProductGridSupplierid,ProductGridProducer,ProductGridProducerid,ProductGridCount,ProductGridUnit,ProductGridUnitid,ProductGridPrice,ProductGridTotalPrice,ProductGridPData,ProductGridPTime,ProductGridPUser,ProductGridPUserid,ProductGridGData,ProductGridGTime,ProductGridGUser,ProductGridGUserid,ProductGridDate,ProductGridTime,ProductGridUser,ProductGridRemark
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","ProductGridStore","","","","")
Query ProductGridStore(ProductCode As %String, ProductDesc As %String, ProductSupplier As %String, ProductType As %String) As websys.Query(ROWSPEC = "ProductGridRowid:%String,ProductGridCode:%String,ProductGridDesc:%String,ProductGridType:%String,ProductGridTypeid:%String,ProductGridVersions:%String,ProductGridStandard:%String,ProductGridSupplier:%String,ProductGridSupplierid:%String,ProductGridProducer:%String,ProductGridProducerid:%String,ProductGridCount:%String,ProductGridUnit:%String,ProductGridUnitid:%String,ProductGridPrice:%String,ProductGridTotalPrice:%String,ProductGridPData:%String,ProductGridPTime:%String,ProductGridPUser:%String,ProductGridPUserid:%String,ProductGridGData:%String,ProductGridGTime:%String,ProductGridGUser:%String,ProductGridGUserid:%String,ProductGridDate:%String,ProductGridTime:%String,ProductGridUser:%String,ProductGridRemark:%String")
{
}

ClassMethod ProductGridStoreExecute(ByRef qHandle As %Binary, ProductCode As %String, ProductDesc As %String, ProductSupplier As %String, ProductType As %String) As %Status
{
	;s ^zzp("ProductGridStore",$h)=ProductCode_"^"_ProductDesc_"^"_ProductSupplier_"^"_ProductType
	Set repid=$I(^CacheTemp)
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	Set qHandle=$lb(0,repid,0)
    s ind=1
    i ProductCode'="" s ProductCode=$$ALPHAUP^SSUTIL4($tr(ProductCode," "))
    i ProductDesc'="" s ProductDesc=$$ALPHAUP^SSUTIL4($tr(ProductDesc," "))
    i ProductDesc'="" s ProductDesc=##Class(web.DHCINSUPort).GetCNCODE(ProductDesc,4,"")
    s ProductGridRowid="" f  s ProductGridRowid=$o(^PMPProduct(ProductGridRowid)) q:ProductGridRowid=""  d
    .s (ProductGridCode,ProductGridDesc,ProductGridType,ProductGridTypeid,ProductGridVersions,ProductGridStandard,ProductGridSupplier,ProductGridSupplierid,ProductGridProducer,ProductGridProducerid,ProductGridCount,ProductGridUnit,ProductGridUnitid,ProductGridPrice,ProductGridTotalPrice,ProductGridPData,ProductGridPTime,ProductGridPUser,ProductGridPUserid,ProductGridGData,ProductGridGTime,ProductGridGUser,ProductGridGUserid,ProductGridDate,ProductGridTime,ProductGridUser,ProductGridRemark)=""
    .s ProductGridCode=$P(^PMPProduct(ProductGridRowid),"^",1)
    .q:ProductGridCode=""
    .q:$P(^PMPProduct(ProductGridRowid),"^",25)="N"
    .q:(ProductCode'="")&($$ALPHAUP^SSUTIL4(ProductGridCode)'[ProductCode)
    .s ProductGridDesc=$P(^PMPProduct(ProductGridRowid),"^",2)
    .s desc=##Class(web.DHCINSUPort).GetCNCODE(ProductGridDesc,4,"")_ProductGridDesc
    .q:(ProductDesc'="")&(desc'[ProductDesc)
    .s ProductGridTypeid=$P(^PMPProduct(ProductGridRowid),"^",4)
    .q:(ProductType'="")&(ProductGridTypeid'=ProductType)
    .i ProductGridTypeid'="" s ProductGridType=$p($G(^PMPDictionary(ProductGridTypeid)),"^",2)
    .s ProductGridVersions=$P(^PMPProduct(ProductGridRowid),"^",5)
    .s ProductGridStandard=$P(^PMPProduct(ProductGridRowid),"^",11)
    .s ProductGridSupplierid=$P(^PMPProduct(ProductGridRowid),"^",3)
    .q:(ProductSupplier'="")&(ProductGridSupplierid'=ProductSupplier)
    .i ProductGridSupplierid'="" s ProductGridSupplier=$p($G(^PMPCompany(ProductGridSupplierid)),"^",2)
    .s ProductGridProducerid=$P(^PMPProduct(ProductGridRowid),"^",6)
    .i ProductGridProducerid'="" s ProductGridProducer=$p($G(^PMPCompany(ProductGridProducerid)),"^",2)
    .s ProductGridCount=$P(^PMPProduct(ProductGridRowid),"^",7)
    .s ProductGridUnitid=$P(^PMPProduct(ProductGridRowid),"^",8)
    .i ProductGridUnitid'="" s ProductGridUnit=$p($G(^PMPDictionary(ProductGridUnitid)),"^",2)
    .s ProductGridPrice=$P(^PMPProduct(ProductGridRowid),"^",9)
    .s ProductGridTotalPrice=$P(^PMPProduct(ProductGridRowid),"^",10)
    .s ProductGridPData=$P(^PMPProduct(ProductGridRowid),"^",12)
    .i ProductGridPData'="" s ProductGridPData=$zd(ProductGridPData,3)
    .s ProductGridPTime=$P(^PMPProduct(ProductGridRowid),"^",13)
    .i ProductGridPTime'="" s ProductGridPTime=$zt(ProductGridPTime)
    .s ProductGridPUserid=$P(^PMPProduct(ProductGridRowid),"^",14)
    .i ProductGridPUserid'="" s ProductGridPUser=##Class(web.PMP.Document).SSUSER(ProductGridPUserid)
    .i IndependentUserRet'="Y" s ProductGridPUserid=+ProductGridPUserid
    .S ProductGridGData=$P(^PMPProduct(ProductGridRowid),"^",15)
    .i ProductGridGData'="" s ProductGridGData=$zd(ProductGridGData,3)
    .s ProductGridGTime=$P(^PMPProduct(ProductGridRowid),"^",16)
    .i ProductGridGTime'="" s ProductGridGTime=$zt(ProductGridGTime)
    .s ProductGridGUserid=$P(^PMPProduct(ProductGridRowid),"^",17)
    .i ProductGridGUserid'="" s ProductGridGUser=##Class(web.PMP.Document).SSUSER(ProductGridGUserid)
    .i IndependentUserRet'="Y" s ProductGridGUserid=+ProductGridGUserid
    .s ProductGridDate=$P(^PMPProduct(ProductGridRowid),"^",18)
    .i ProductGridDate'="" s ProductGridDate=$zd(ProductGridDate,3)
    .s ProductGridTime=$P(^PMPProduct(ProductGridRowid),"^",19)
    .i ProductGridTime'="" s ProductGridTime=$zt(ProductGridTime)
    .s ProductGridUserid=$P(^PMPProduct(ProductGridRowid),"^",20)
    .i ProductGridUserid'="" s ProductGridUser=##Class(web.PMP.Document).SSUSER(ProductGridUserid)
    .i IndependentUserRet'="Y" s ProductGridUserid=+ProductGridUserid
    .s ProductGridRemark=$P(^PMPProduct(ProductGridRowid),"^",24)
    .d OutputRow1
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow1
    s Data=$lb(ProductGridRowid,ProductGridCode,ProductGridDesc,ProductGridType,ProductGridTypeid,ProductGridVersions,ProductGridStandard,ProductGridSupplier,ProductGridSupplierid,ProductGridProducer,ProductGridProducerid,ProductGridCount,ProductGridUnit,ProductGridUnitid,ProductGridPrice,ProductGridTotalPrice,ProductGridPData,ProductGridPTime,ProductGridPUser,ProductGridPUserid,ProductGridGData,ProductGridGTime,ProductGridGUser,ProductGridGUserid,ProductGridDate,ProductGridTime,ProductGridUser,ProductGridRemark)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取产品单位
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ProductMenuUnitStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ProductMenuUnitStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","Unit",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同状态
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ContractStatusStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ContractStatusStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","ContractStatus",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同数据
/// input:  ContractCode,ContractName,ContractMenu,ContractStatus
/// output: String ContractGridRowid,ContractGridCode,ContractGridDesc,ContractGridGroup,ContractGridGroupid,ContractGridType,ContractGridTypeid,ContractGridPrincipal,ContractGridContractDate,ContractGridContractTime,ContractGridEffectiveDate,ContractGridEffectiveTime,ContractGridStatus,ContractGridStatusid,ContractGridFParty,ContractGridFPartyid,ContractGridFUser,ContractGridSParty,ContractGridSPartyid,ContractGridSUser,ContractGridTParty,ContractGridTPartyid,ContractGridTUser,ContractGridModeE,ContractGridModeEid,ContractGridCondeM,ContractGridCondeMid,ContractGridSource,ContractGridSourceid,ContractGridDepartment,ContractGridTotalMone,ContractGridFinishDate,ContractGridFinishTime,ContractGridMenu,ContractGridAbnormal,ContractGridPigeonhol,ContractGridElecticC,ContractGridRemark,ContractGridDate,ContractGridTime,ContractGridUser
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","ContractGridStore","","","","")
Query ContractGridStore(ContractCode As %String, ContractName As %String, ContractMenu As %String, ContractStatus As %String) As websys.Query(ROWSPEC = "ContractGridRowid:%String,ContractGridCode:%String,ContractGridDesc:%String,ContractGridGroup:%String,ContractGridGroupid:%String,ContractGridType:%String,ContractGridTypeid:%String,ContractGridPrincipal:%String,ContractGridContractDate:%String,ContractGridContractTime:%String,ContractGridEffectiveDate:%String,ContractGridEffectiveTime:%String,ContractGridStatus:%String,ContractGridStatusid:%String,ContractGridFParty:%String,ContractGridFPartyid:%String,ContractGridFUser:%String,ContractGridSParty:%String,ContractGridSPartyid:%String,ContractGridSUser:%String,ContractGridTParty:%String,ContractGridTPartyid:%String,ContractGridTUser:%String,ContractGridModeE:%String,ContractGridModeEid:%String,ContractGridCondeM:%String,ContractGridCondeMid:%String,ContractGridSource:%String,ContractGridSourceid:%String,ContractGridDepartment:%String,ContractGridTotalMone:%String,ContractGridFinishDate:%String,ContractGridFinishTime:%String,ContractGridMenu:%String,ContractGridAbnormal:%String,ContractGridPigeonhol:%String,ContractGridElecticC:%String,ContractGridRemark:%String,ContractGridDate:%String,ContractGridTime:%String,ContractGridUser")
{
}

ClassMethod ContractGridStoreExecute(ByRef qHandle As %Binary, ContractCode As %String, ContractName As %String, ContractMenu As %String, ContractStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
    ;s ^CacheTemp("ContractGridStore")=ContractCode_"^"_ContractName_"^"_ContractMenu_"^"_ContractStatus
    i ContractCode'="" s ContractCode=$$ALPHAUP^SSUTIL4($tr(ContractCode," "))
    i ContractName'="" s ContractName=$$ALPHAUP^SSUTIL4($tr(ContractName," "))
    ;i ContractCode'="" s ContractCode=##Class(web.DHCINSUPort).GetCNCODE(ContractCode,4,"")
    i ContractName'="" s ContractName=##Class(web.DHCINSUPort).GetCNCODE(ContractName,4,"")
    s ContractGridRowid="" f  s ContractGridRowid=$o(^PMPContract(ContractGridRowid)) q:ContractGridRowid=""   d
    .s (ContractGridCode,ContractGridDesc,ContractGridGroup,ContractGridGroupid,ContractGridType,ContractGridTypeid,ContractGridPrincipal,ContractGridContractDate,ContractGridContractTime,ContractGridEffectiveDate,ContractGridEffectiveTime,ContractGridStatus,ContractGridStatusid,ContractGridFParty,ContractGridFPartyid,ContractGridFUser,ContractGridSParty,ContractGridSPartyid,ContractGridSUser,ContractGridTParty,ContractGridTPartyid,ContractGridTUser,ContractGridModeE,ContractGridModeEid,ContractGridCondeM,ContractGridCondeMid,ContractGridSource,ContractGridSourceid,ContractGridDepartment,ContractGridTotalMone,ContractGridFinishDate,ContractGridFinishTime,ContractGridMenu,ContractGridAbnormal,ContractGridPigeonhol,ContractGridElecticC,ContractGridRemark,ContractGridDate,ContractGridTime,ContractGridUser)=""
    .s ContractGridCode=$p(^PMPContract(ContractGridRowid),"^",1)
    .q:ContractGridCode=""  
    .q:$p(^PMPContract(ContractGridRowid),"^",36)="N"
    .q:(ContractCode'="")&($$ALPHAUP^SSUTIL4(ContractGridCode)'[ContractCode)
    .s ContractGridDesc=$p(^PMPContract(ContractGridRowid),"^",2)
    .s desc=##Class(web.DHCINSUPort).GetCNCODE(ContractGridDesc,4,"")_ContractGridDesc
    .q:(ContractName'="")&(desc'[ContractName)
    .s ContractGridMenu=$p(^PMPContract(ContractGridRowid),"^",19)
    .q:(ContractMenu'="")&(ContractGridMenu'[ContractMenu)
    .s ContractGridStatusid=$p(^PMPContract(ContractGridRowid),"^",18)
    .q:(ContractStatus'="")&(ContractGridStatusid'=ContractStatus)
    .i ContractGridStatusid'="" s ContractGridStatus=$p($G(^PMPDictionary(ContractGridStatusid)),"^",2)
    .s ContractGridGroupid=$p(^PMPContract(ContractGridRowid),"^",3)
    .i ContractGridGroupid'="" s ContractGridGroup=$p($G(^PMPDictionary(ContractGridGroupid)),"^",2)
    .s ContractGridTypeid=$p(^PMPContract(ContractGridRowid),"^",4)
    .i ContractGridTypeid'="" s ContractGridType=$p($G(^PMPDictionary(ContractGridTypeid)),"^",2)
    .s ContractGridPrincipal=$p(^PMPContract(ContractGridRowid),"^",5)
    .s ContractGridContractDate=$p(^PMPContract(ContractGridRowid),"^",7)
    .s ContractGridContractTime=$p(^PMPContract(ContractGridRowid),"^",8)
    .s ContractGridEffectiveDate=$p(^PMPContract(ContractGridRowid),"^",14)
    .s ContractGridEffectiveTime=$p(^PMPContract(ContractGridRowid),"^",15)
    .i ContractGridContractDate'="" s ContractGridContractDate=$zd(ContractGridContractDate,3)
    .i ContractGridContractTime'="" s ContractGridContractTime=$zt(ContractGridContractTime)
    .i ContractGridEffectiveDate'="" s ContractGridEffectiveDate=$zd(ContractGridEffectiveDate,3)
    .i ContractGridEffectiveTime'="" s ContractGridEffectiveTime=$zt(ContractGridEffectiveTime)
    .s ContractGridFPartyid=$p(^PMPContract(ContractGridRowid),"^",21)
    .s ContractGridSPartyid=$p(^PMPContract(ContractGridRowid),"^",22)
    .s ContractGridTPartyid=$p(^PMPContract(ContractGridRowid),"^",23)
    .i ContractGridFPartyid'="" s ContractGridFParty=$p(^PMPCompany(ContractGridFPartyid),"^",2)
    .i ContractGridSPartyid'="" s ContractGridSParty=$p(^PMPCompany(ContractGridSPartyid),"^",2)
    .i ContractGridTPartyid'="" s ContractGridTParty=$p(^PMPCompany(ContractGridTPartyid),"^",2)
    .s ContractGridFUser=$p(^PMPContract(ContractGridRowid),"^",24)
    .s ContractGridSUser=$p(^PMPContract(ContractGridRowid),"^",25)
    .s ContractGridTUser=$p(^PMPContract(ContractGridRowid),"^",26)
    .s ContractGridModeEid=$p(^PMPContract(ContractGridRowid),"^",11)
    .i ContractGridModeEid'="" s ContractGridModeE=$p($G(^PMPDictionary(ContractGridModeEid)),"^",2)
    .s ContractGridCondeMid=$p(^PMPContract(ContractGridRowid),"^",12)
    .i ContractGridCondeMid'="" s ContractGridCondeM=$p($G(^PMPDictionary(ContractGridCondeMid)),"^",2)
    .s ContractGridSourceid=$p(^PMPContract(ContractGridRowid),"^",13)
    .i ContractGridSourceid'="" s ContractGridSource=$p($G(^PMPDictionary(ContractGridSourceid)),"^",2)
    .s ContractGridDepartment=$p(^PMPContract(ContractGridRowid),"^",6)
    .s ContractGridTotalMone=$p(^PMPContract(ContractGridRowid),"^",9)
    .s ContractGridCurrencyid=$p(^PMPContract(ContractGridRowid),"^",10)
    .i ContractGridCurrencyid'="" s ContractGridCurrency=$p($G(^PMPDictionary(ContractGridCurrencyid)),"^",2)
    .s ContractGridFinishDate=$p(^PMPContract(ContractGridRowid),"^",16)
    .s ContractGridFinishTime=$p(^PMPContract(ContractGridRowid),"^",17)
    .i ContractGridFinishDate'="" s ContractGridFinishDate=$zd(ContractGridFinishDate,3)
    .i ContractGridFinishTime'="" s ContractGridFinishTime=$zt(ContractGridFinishTime)
    .s ContractGridAbnormal=$p(^PMPContract(ContractGridRowid),"^",27)
    .s ContractGridPige=$p(^PMPContract(ContractGridRowid),"^",28)
    .s ContractGridPigeonhol=$select(ContractGridPige="Y":"已归档",ContractGridPige="N":"未归档",ContractGridPige="":"其他")
    .s ContractGridElecticC=$p(^PMPContract(ContractGridRowid),"^",29)
    .s ContractGridRemark=$p(^PMPContract(ContractGridRowid),"^",20)
    .s ContractGridDate=$p(^PMPContract(ContractGridRowid),"^",30)
    .s ContractGridTime=$p(^PMPContract(ContractGridRowid),"^",31)
    .s ContractGridUserid=$p(^PMPContract(ContractGridRowid),"^",32)
    .i ContractGridDate'="" s ContractGridDate=$zd(ContractGridDate,3)
    .i ContractGridTime'="" s ContractGridTime=$zt(ContractGridTime)
    .i ContractGridUserid'="" s ContractGridUser=##Class(web.PMP.Document).SSUSER(ContractGridUserid)
    .i IndependentUserRet'="Y" s ContractGridUserid=+ContractGridUserid
    .d OutputRow2
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow2
    s Data=$lb(ContractGridRowid,ContractGridCode,ContractGridDesc,ContractGridGroup,ContractGridGroupid,ContractGridType,ContractGridTypeid,ContractGridPrincipal,ContractGridContractDate,ContractGridContractTime,ContractGridEffectiveDate,ContractGridEffectiveTime,ContractGridStatus,ContractGridStatusid,ContractGridFParty,ContractGridFPartyid,ContractGridFUser,ContractGridSParty,ContractGridSPartyid,ContractGridSUser,ContractGridTParty,ContractGridTPartyid,ContractGridTUser,ContractGridModeE,ContractGridModeEid,ContractGridCondeM,ContractGridCondeMid,ContractGridSource,ContractGridSourceid,ContractGridDepartment,ContractGridTotalMone,ContractGridFinishDate,ContractGridFinishTime,ContractGridMenu,ContractGridAbnormal,ContractGridPigeonhol,ContractGridElecticC,ContractGridRemark,ContractGridDate,ContractGridTime,ContractGridUser)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同分组
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ContractGroupStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ContractGroupStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","ContractGroup",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同类型
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ContractMenuTypeStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ContractMenuTypeStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","ContractType",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同履行方式
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ContractMenuModeEStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ContractMenuModeEStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","ModeExecution",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同签订方式
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ContractMenuCModeStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ContractMenuCModeStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","ConcludeMode",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同采购来源
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ContractMenuSourceStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ContractMenuSourceStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","Source",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同币种
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ContractMenuCurrencyStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ContractMenuCurrencyStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","Currency",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同关联的模块信息
/// input:  type()
/// output: ContractModeRowid,ContractModeCode,ContractModeDesc,ContractModeStandby3,ContractModeProduct,ContractModeAging,ContractModeStatus,ContractModePlanDate,ContractModePlanTime,ContractModeActDate,ContractModeActTime,ContractModeRemark
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","ContractModeStore","","","1")
Query ContractModeStore(ContractModeCod As %String, ContractModeName As %String, ContractModRowid As %String) As websys.Query(ROWSPEC = "ContractModeRowid:%String,ContractModeCode:%String,ContractModeDesc:%String,ContractModeStandby3:%String,ContractModeProduct:%String,ContractModeAging:%String,ContractModeStatus:%String,ContractModePlanDate:%String,ContractModePlanTime:%String,ContractModeActDate:%String,ContractModeActTime:%String,ContractModeRemark:%String")
{
}

ClassMethod ContractModeStoreExecute(ByRef qHandle As %Binary, ContractModeCod As %String, ContractModeName As %String, ContractModRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    i ContractModeCod'="" s ContractModeCod=$$ALPHAUP^SSUTIL4($tr(ContractModeCod," "))
    i ContractModeCod'="" s ContractModeCod=##Class(web.DHCINSUPort).GetCNCODE(ContractModeCod,4,"")
    i ContractModeName'="" s ContractModeName=$$ALPHAUP^SSUTIL4($tr(ContractModeName," "))
    i ContractModeName'="" s ContractModeName=##Class(web.DHCINSUPort).GetCNCODE(ContractModeName,4,"")
    ;s ^CacheTemp("ContractModeStore")=ContractModeCod_"^"_ContractModeName_"^"_ContractModRowid
    q:ContractModRowid="" $$$OK
    s ContractModeRowid="" f  s ContractModeRowid=$o(^PMPContractModei("CONTRACT",ContractModRowid,ContractModeRowid)) q:ContractModeRowid=""  d
    .s (ContractModeCode,ContractModeDesc,ContractModeStandby3,ContractModeProduct,ContractModeAging,ContractModeStatus,ContractModePlanDate,ContractModePlanTime,ContractModeActDate,ContractModeActTime,ContractModeRemark)=""
    .s moderowid=$p(^PMPContractMode(ContractModeRowid),"^",2)
    .q:moderowid=""
    .s ContractModeCode=$p(^PMPModule(moderowid),"^",1)
    .q:(ContractModeCod'="")&(##Class(web.DHCINSUPort).GetCNCODE(ContractModeCode,4,"")'[ContractModeCod)
    .s ContractModeDesc=$p(^PMPModule(moderowid),"^",2)
    .s desc=##Class(web.DHCINSUPort).GetCNCODE(ContractModeDesc,4,"")_ContractModeDesc
    .q:(ContractModeName'="")&(desc'[ContractModeName)
    .s ContractModeStandby3id=$p(^PMPModule(moderowid),"^",18)
    .i ContractModeStandby3id'="" s ContractModeStandby3=$P(^PMPProduct(ContractModeStandby3id),"^",2)
    .S ContractModeProductid=$p(^PMPModule(moderowid),"^",7)
    .i ContractModeProductid'="" s ContractModeProduct=$p($G(^PMPDictionary(ContractModeProductid)),"^",2)
    .s ContractModeAgingid=$p(^PMPContractMode(ContractModeRowid),"^",20)
    .i ContractModeAgingid'=""   d
    ..s ContractModeAgingidd=$p(^PMPContractAging(ContractModeAgingid),"^",2)
    ..i ContractModeAgingidd'="" s ContractModeAging=$p($G(^PMPDictionary(ContractModeAgingidd)),"^",2)
    .s ContractModeStatusid=$p(^PMPModule(moderowid),"^",10)
    .i ContractModeStatusid'="" s ContractModeStatus=$p($G(^PMPDictionary(ContractModeStatusid)),"^",2)
    .s ContractModePlanDate=$p(^PMPModule(moderowid),"^",6)
    .i ContractModePlanDate'="" s ContractModePlanDate=$zd(ContractModePlanDate,3)
    .s ContractModePlanTime=$p(^PMPModule(moderowid),"^",27)
    .i ContractModePlanTime'="" s ContractModePlanTime=$zt(ContractModePlanTime)
    .s ContractModeActDate=$p(^PMPModule(moderowid),"^",4)
    .i ContractModeActDate'="" s ContractModeActDate=$zd(ContractModeActDate,3)
    .s ContractModeActTime=$p(^PMPModule(moderowid),"^",28)
    .i ContractModeActTime'="" s ContractModeActTime=$zt(ContractModeActTime)
    .s ContractModeRemark=$p(^PMPContractMode(ContractModeRowid),"^",19)
    .d OutputRow3
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow3
    s Data=$lb(ContractModeRowid,ContractModeCode,ContractModeDesc,ContractModeStandby3,ContractModeProduct,ContractModeAging,ContractModeStatus,ContractModePlanDate,ContractModePlanTime,ContractModeActDate,ContractModeActTime,ContractModeRemark)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取未关联的模块
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod ContractModeNStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("ContractModeNStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPModule(RowId)) q:RowId=""  d
 .q:($p($G(^PMPModule(RowId)),"^",25)'="")
 .s Description=$p($G(^PMPModule(RowId)),"^",2)
 .q:Description=""
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-17
/// description: 获取合同详细标题目录
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).ContractTitle(1)
ClassMethod ContractTitle(ContractRowid As %String) As %String
{
	;s ^CacheTemp("ContractTitle")=ContractRowid 
	q:ContractRowid="" "[]"
	set json=""
	s leve=$o(^PMPContractDetailsi("LEVEL",ContractRowid,""))
	s sub="" f  s sub=$o(^PMPContractDetailsi("LEVEL",ContractRowid,leve,sub)) q:sub=""  d
	.s:json'="" json=json_","
	.s id=ContractRowid_"||"_sub
	.s text=$p(^PMPContractDetails(ContractRowid,sub),"^",2)
	.s json=json_"{"_"""id"":"""_id_""",""text"":"""_text_""","
	.s json=json_"""iconCls"":""icon-pro"","
	.s subjson=##class(web.PMP.Document).SubJson(ContractRowid,id,leve)
	.i subjson="[]"  d
	..s json=json_"""leaf"":true"
	.e  d
	..s json=json_"""expanded"":true,""leaf"":false,""children"":"_subjson
	.s json=json_"}"
	quit "["_json_"]"
}

ClassMethod SubJson(ContractRowid As %String, idd As %String, leve As %String) As %String
{
	new (ContractRowid,idd,leve)
	set json="" 
	s subid=$o(^PMPContractDetailsi("LevelvFather",ContractRowid,idd,""))
	while (subid'="") {
		s:json'="" json=json_","
		s id=ContractRowid_"||"_subid
		s text=$p(^PMPContractDetails(ContractRowid,subid),"^",2)
		s json=json_"{"_"""id"":"""_id_""",""text"":"""_text_""","
		s json=json_"""iconCls"":""icon-pro"","
		s subjson=##Class(web.PMP.Document).SubJson(ContractRowid,id,leve) 
		i subjson="[]"  d
		.s json=json_"""leaf"":true"
		e  d
	    .s json=json_"""expanded"":true,""leaf"":false,""children"":"_subjson
	    s json=json_"}"
	    s subid=$o(^PMPContractDetailsi("LevelvFather",ContractRowid,idd,subid))
		}
		q "["_json_"]"
}

/// Creat  zzp
/// date:2015-05-17
/// description: 根据合同详细表rowid获取合同详细内容和当前标题级别
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).ContractTitle(1)
ClassMethod ContractDetailsMenu(Rowid As %String) As %Text
{
	s ret=""
	q:Rowid="" ret
	s menu=$p(^PMPContractDetails(+Rowid,$p(Rowid,"||",2)),"^",5)
	s leve=$p(^PMPContractDetails(+Rowid,$p(Rowid,"||",2)),"^",3)
	s ret=menu_"@@"_leve
	q ret
}

/// Creat  zzp
/// date:2015-05-18
/// description: 获取合同列表
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod CAgingContractStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("CAgingContractStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPContract(RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPContract(RowId)),"^",2)
 .q:$p($G(^PMPContract(RowId)),"^",36)="N"
 .q:Description=""
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取工期
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod CAgingAgingStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("CAgingAgingStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","Aging",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-18
/// description: 获取合同工期信息
/// input:  type()
/// output: CAgingGRowid,CAgingGContract,CAgingGContractid,CAgingGAging,CAgingGAgingid,CAgingGCode,CAgingGDesc,CAgingGStatus,CAgingGStatusid,CAgingGPlanStartDate,CAgingGPlanStartTime,CAgingGStartDate,CAgingGStartTime,CAgingGPlanEndDate,CAgingGPlanEndTime,CAgingGEndDate,CAgingGEndTime,CAgingGCreatUser,CAgingGCreatDate,CAgingGCreatTime,CAgingGRemark
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","QueryContractAging","1","","","")
Query QueryContractAging(CAgingContract As %String, CAgingAging As %String, CAgingCode As %String, CAgingDesc As %String) As websys.Query(ROWSPEC = "CAgingGRowid:%String,CAgingGContract:%String,CAgingGContractid:%String,CAgingGAging:%String,CAgingGAgingid:%String,CAgingGCode:%String,CAgingGDesc:%String,CAgingGStatus:%String,CAgingGStatusid:%String,CAgingGPlanStartDate:%String,CAgingGPlanStartTime:%String,CAgingGStartDate:%String,CAgingGStartTime:%String,CAgingGPlanEndDate:%String,CAgingGPlanEndTime:%String,CAgingGEndDate:%String,CAgingGEndTime:%String,CAgingGCreatUser:%String,CAgingGCreatDate:%String,CAgingGCreatTime:%String,CAgingGRemark:%String")
{
}

ClassMethod QueryContractAgingExecute(ByRef qHandle As %Binary, CAgingContract As %String, CAgingAging As %String, CAgingCode As %String, CAgingDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
    q:CAgingContract="" $$$OK
    ;s ^Temp("QueryContractAging")=CAgingContract_"^"_CAgingAging_"^"_CAgingCode_"^"_CAgingDesc
    i CAgingCode'="" s CAgingCode=$$ALPHAUP^SSUTIL4($tr(CAgingCode," "))
    i CAgingCode'="" s CAgingCode=##Class(web.DHCINSUPort).GetCNCODE(CAgingCode,4,"")
    i CAgingDesc'="" s CAgingDesc=$$ALPHAUP^SSUTIL4($tr(CAgingDesc," "))
    i CAgingDesc'="" s CAgingDesc=##Class(web.DHCINSUPort).GetCNCODE(CAgingDesc,4,"")
    s sub="" f  s sub=$o(^PMPContractAgingi("Contract",CAgingContract,sub)) q:sub=""  d
    .s (CAgingGRowid,CAgingGContract,CAgingGContractid,CAgingGAging,CAgingGAgingid,CAgingGCode,CAgingGDesc,CAgingGStatus,CAgingGStatusid,CAgingGPlanStartDate,CAgingGPlanStartTime,CAgingGStartDate,CAgingGStartTime,CAgingGPlanEndDate,CAgingGPlanEndTime,CAgingGEndDate,CAgingGEndTime,CAgingGCreatUser,CAgingGCreatDate,CAgingGCreatTime,CAgingGRemark)=""
    .s CAgingGContractid=CAgingContract
    .s CAgingGContract=$p(^PMPContract(CAgingGContractid),"^",2)
    .s CAgingGRowid=CAgingGContractid_"||"_sub
    .s CAgingGAgingid=$p(^PMPContractAging(sub),"^",2)
    .q:(CAgingAging'="")&(CAgingGAgingid'=CAgingAging)
    .i CAgingGAgingid'="" s CAgingGAging=$p($G(^PMPDictionary(CAgingGAgingid)),"^",2)
    .s CAgingGCode=$p(^PMPContractAging(sub),"^",3)
    .q:(CAgingCode'="")&(##Class(web.DHCINSUPort).GetCNCODE(CAgingGCode,4,"")'[CAgingCode)
    .s CAgingGDesc=$p(^PMPContractAging(sub),"^",4)
    .s desc=##Class(web.DHCINSUPort).GetCNCODE(CAgingGDesc,4,"")_CAgingGDesc
    .q:(CAgingDesc'="")&(desc'[CAgingDesc)
    .s CAgingGStatusid=$p(^PMPContractAging(sub),"^",5)
    .i CAgingGStatusid'="" s CAgingGStatus=$p($G(^PMPDictionary(CAgingGStatusid)),"^",2)
    .s CAgingGPlanStartDate=$p(^PMPContractAging(sub),"^",27)
    .i CAgingGPlanStartDate'="" s CAgingGPlanStartDate=$zd(CAgingGPlanStartDate,3)
    .s CAgingGPlanStartTime=$p(^PMPContractAging(sub),"^",28)
    .i CAgingGPlanStartTime'="" s CAgingGPlanStartTime=$zt(CAgingGPlanStartTime)
    .s CAgingGStartDate=$p(^PMPContractAging(sub),"^",6)
    .i CAgingGStartDate'="" s CAgingGStartDate=$zd(CAgingGStartDate,3)
    .s CAgingGStartTime=$p(^PMPContractAging(sub),"^",7)
    .i CAgingGStartTime'="" s CAgingGStartTime=$zt(CAgingGStartTime)
    .s CAgingGPlanEndDate=$p(^PMPContractAging(sub),"^",29)
    .i CAgingGPlanEndDate'="" s CAgingGPlanEndDate=$zd(CAgingGPlanEndDate,3)
    .s CAgingGPlanEndTime=$p(^PMPContractAging(sub),"^",30)
    .i CAgingGPlanEndTime'="" s CAgingGPlanEndTime=$zt(CAgingGPlanEndTime)
    .s CAgingGEndDate=$p(^PMPContractAging(sub),"^",8)
    .i CAgingGEndDate'="" s CAgingGEndDate=$zd(CAgingGEndDate,3)
    .s CAgingGEndTime=$p(^PMPContractAging(sub),"^",9)
    .i CAgingGEndTime'="" s CAgingGEndTime=$zt(CAgingGEndTime)
    .s CAgingGCreatUserid=$p(^PMPContractAging(sub),"^",15)
    .i CAgingGCreatUserid'="" s CAgingGCreatUser=##Class(web.PMP.Document).SSUSER(CAgingGCreatUserid)
    .i IndependentUserRet'="Y" s CAgingGCreatUserid=+CAgingGCreatUserid
    .s CAgingGCreatDate=$p(^PMPContractAging(sub),"^",13)
    .i CAgingGCreatDate'="" s CAgingGCreatDate=$zd(CAgingGCreatDate,3)
    .s CAgingGCreatTime=$p(^PMPContractAging(sub),"^",14)
    .i CAgingGCreatTime'="" s CAgingGCreatTime=$zt(CAgingGCreatTime)
    .s CAgingGRemark=$p(^PMPContractAging(sub),"^",26)
    .d OutputRow4
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow4
    s Data=$lb(CAgingGRowid,CAgingGContract,CAgingGContractid,CAgingGAging,CAgingGAgingid,CAgingGCode,CAgingGDesc,CAgingGStatus,CAgingGStatusid,CAgingGPlanStartDate,CAgingGPlanStartTime,CAgingGStartDate,CAgingGStartTime,CAgingGPlanEndDate,CAgingGPlanEndTime,CAgingGEndDate,CAgingGEndTime,CAgingGCreatUser,CAgingGCreatDate,CAgingGCreatTime,CAgingGRemark)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同关联的模块信息
/// input:  type()
/// output: ContractModeRowid,ContractModeCode,ContractModeDesc,ContractModeStandby3,ContractModeProduct,ContractModeAging,ContractModeStatus,ContractModePlanDate,ContractModePlanTime,ContractModeActDate,ContractModeActTime,ContractModeRemark
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","QueryCAgingModule","","","1||1")
Query QueryCAgingModule(ContractModeCod As %String, ContractModeName As %String, ContractModRowid As %String) As websys.Query(ROWSPEC = "ContractModeRowid:%String,ContractModeCode:%String,ContractModeDesc:%String,ContractModeStandby3:%String,ContractModeProduct:%String,ContractModeAging:%String,ContractModeStatus:%String,ContractModePlanDate:%String,ContractModePlanTime:%String,ContractModeActDate:%String,ContractModeActTime:%String,ContractModeRemark:%String")
{
}

ClassMethod QueryCAgingModuleExecute(ByRef qHandle As %Binary, ContractModeCod As %String, ContractModeName As %String, ContractModRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    i ContractModeCod'="" s ContractModeCod=$$ALPHAUP^SSUTIL4($tr(ContractModeCod," "))
    i ContractModeCod'="" s ContractModeCod=##Class(web.DHCINSUPort).GetCNCODE(ContractModeCod,4,"")
    i ContractModeName'="" s ContractModeName=$$ALPHAUP^SSUTIL4($tr(ContractModeName," "))
    i ContractModeName'="" s ContractModeName=##Class(web.DHCINSUPort).GetCNCODE(ContractModeName,4,"")
    ;s ^CacheTemp("QueryCAgingModule")=ContractModeCod_"^"_ContractModeName_"^"_ContractModRowid
    q:ContractModRowid="" $$$OK
    S ASING=$P(ContractModRowid,"||",2)
    s CAgingGAgingid=$p(^PMPContractAging(ASING),"^",2)
    s sub="" f  s sub=$o(^PMPContractAgingMode(ASING,sub)) q:sub=""  d
    .s moderowid=$p($g(^PMPContractAgingMode(ASING,sub)),"^",2)
    .q:moderowid=""
    .s ContractModeRowid=ContractModRowid_"||"_moderowid
    .s ContractModeCode=$p(^PMPModule(moderowid),"^",1)
    .q:(ContractModeCod'="")&(##Class(web.DHCINSUPort).GetCNCODE(ContractModeCode,4,"")'[ContractModeCod)
    .s ContractModeDesc=$p(^PMPModule(moderowid),"^",2)
    .s desc=##Class(web.DHCINSUPort).GetCNCODE(ContractModeDesc,4,"")_ContractModeDesc
    .q:(ContractModeName'="")&(desc'[ContractModeName)
    .s ContractModeStandby3id=$p(^PMPModule(moderowid),"^",18)
    .i ContractModeStandby3id'="" s ContractModeStandby3=$P(^PMPProduct(ContractModeStandby3id),"^",2)
    .S ContractModeProductid=$p(^PMPModule(moderowid),"^",7)
    .i ContractModeProductid'="" s ContractModeProduct=$p($G(^PMPDictionary(ContractModeProductid)),"^",2)
    .s ContractModeAgingid=$p(^PMPContractAging(ASING),"^",2)
    .i ContractModeAgingid'="" s ContractModeAging=$p($G(^PMPDictionary(ContractModeAgingid)),"^",2)
    .s ContractModeStatusid=$p(^PMPModule(moderowid),"^",10)
    .i ContractModeStatusid'="" s ContractModeStatus=$p($G(^PMPDictionary(ContractModeStatusid)),"^",2)
    .s ContractModePlanDate=$p(^PMPModule(moderowid),"^",6)
    .i ContractModePlanDate'="" s ContractModePlanDate=$zd(ContractModePlanDate,3)
    .s ContractModePlanTime=$p(^PMPModule(moderowid),"^",27)
    .i ContractModePlanTime'="" s ContractModePlanTime=$zt(ContractModePlanTime)
    .s ContractModeActDate=$p(^PMPModule(moderowid),"^",4)
    .i ContractModeActDate'="" s ContractModeActDate=$zd(ContractModeActDate,3)
    .s ContractModeActTime=$p(^PMPModule(moderowid),"^",28)
    .i ContractModeActTime'="" s ContractModeActTime=$zt(ContractModeActTime)
    .s ContractModeRemark=$p($g(^PMPContractAgingMode(ASING,sub)),"^",4)
    .d OutputRow5
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow5
    s Data=$lb(ContractModeRowid,ContractModeCode,ContractModeDesc,ContractModeStandby3,ContractModeProduct,ContractModeAging,ContractModeStatus,ContractModePlanDate,ContractModePlanTime,ContractModeActDate,ContractModeActTime,ContractModeRemark)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取工期状态
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod CAStratusStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("CAStratusStore")=InPut
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","AgingStatus",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zhangsong
/// date:2015-05-15
/// description:文档交接管理->文档级别字典获取
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod DocumentLevelStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("DocumentLevelStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","DocumentLevel",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_"|"_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zhangsong
/// date:2015-05-15
/// description: 文档交接管理->文档分组字典获取
/// input:  type()
/// output: String RowId,Description
/// others:w ##class(web.PMP.Document).DocumentGroupStore()
ClassMethod DocumentGroupStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("DocumentGroupStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","DocumentLevel",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_"|"_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 获取合同关联的模块且还未关联工期
/// input:  type()
/// output: String RowId,Description
/// others:
ClassMethod CAModeStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("CAModeStore",$h)=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId="" f  s RowId=$o(^PMPModule(RowId)) q:RowId=""  d
 .q:(InPut'="")&($p($G(^PMPModule(RowId)),"^",25)'=+InPut)
 .s Description=$p($G(^PMPModule(RowId)),"^",2)
 .q:Description=""
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-19
/// description: 获取目录树标题
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).DirectoryTree(206)
ClassMethod DirectoryTree(Type As %String) As %String
{
	;s ^CacheTemp("DirectoryTree")=Type 
	q:Type="" "[]"
	set json="" 
	s leve=$o(^PMPDirectoryTreei("LEVE",Type,""))
	s sub="" f  s sub=$o(^PMPDirectoryTreei("LEVE",Type,leve,sub)) q:sub=""  d
	.s:json'="" json=json_","
	.s id=sub
	.s text=$p(^PMPDirectoryTree(sub),"^",3)
	.s json=json_"{"_"""id"":"""_id_""",""text"":"""_text_""","
	.s json=json_"""iconCls"":""icon-pro"","
	.s subjson=##class(web.PMP.Document).DirectoryTreeSubJson(Type,id,leve)
	.i subjson="[]"  d
	..s json=json_"""leaf"":true"
	.e  d
	..s json=json_"""expanded"":true,""leaf"":false,""children"":"_subjson
	.s json=json_"}"
	quit "["_json_"]"
}

ClassMethod DirectoryTreeSubJson(ContractRowid As %String, idd As %String, leve As %String) As %String
{
	new (ContractRowid,idd,leve)
	set json=""
	s subid=$o(^PMPDirectoryTreei("FatherLeve",ContractRowid,idd,""))
	while (subid'="") {
		s:json'="" json=json_","
		s id=subid
		s text=$p(^PMPDirectoryTree(subid),"^",3)
		s json=json_"{"_"""id"":"""_id_""",""text"":"""_text_""","
		s json=json_"""iconCls"":""icon-pro"","
		s subjson=##Class(web.PMP.Document).DirectoryTreeSubJson(ContractRowid,id,leve) 
		i subjson="[]"  d
		.s json=json_"""leaf"":true"
		e  d
	    .s json=json_"""expanded"":true,""leaf"":false,""children"":"_subjson
	    s json=json_"}"
	    s subid=$o(^PMPDirectoryTreei("FatherLeve",ContractRowid,idd,subid))
		}
		q "["_json_"]"
}

/// Creat  zzp
/// date:2015-05-19
/// description: 获取计划任务数据
/// input:  type()
/// output: ContractModeRowid,ContractModeCode,ContractModeDesc,ContractModeStandby3,ContractModeProduct,ContractModeAging,ContractModeStatus,ContractModePlanDate,ContractModePlanTime,ContractModeActDate,ContractModeActTime,ContractModeRemark
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","PlanGridStore","4","","")
Query PlanGridStore(PlanRowid As %String, PlanCode As %String, PlanDesc As %String) As websys.Query(ROWSPEC = "PPPGridRowid:%String,PPPGridCode:%String,PPPGridDesc:%String,PPPGridPlanStartDate:%String,PPPGridPlanStartTime:%String,PPPGridStartDate:%String,PPPGridStartTime:%String,PPPGridPlanEndDate:%String,PPPGridPlanEndTime:%String,PPPGridEndDate:%String,PPPGridEndTime:%String,PPPGridStatus:%String,PPPGridStatusid:%String,PPPGridImprovment:%String,PPPGridImprovmentid:%String,PPPGridJobLogg:%String,PPPGridJobLoggid:%String,PPPGridModule:%String,PPPGridModuleid:%String,PPPGridContractAging:%String,PPPGridContractAgingid:%String,PPPGridContract:%String,PPPGridContractid:%String,PPPGridAdjuc:%String,PPPGridMenu:%String,PPPGridRemark:%String")
{
}

ClassMethod PlanGridStoreExecute(ByRef qHandle As %Binary, PlanRowid As %String, PlanCode As %String, PlanDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    i PlanCode'="" s PlanCode=$$ALPHAUP^SSUTIL4($tr(PlanCode," "))
    i PlanCode'="" s PlanCode=##Class(web.DHCINSUPort).GetCNCODE(PlanCode,4,"")
    i PlanDesc'="" s PlanDesc=$$ALPHAUP^SSUTIL4($tr(PlanDesc," "))
    i PlanDesc'="" s PlanDesc=##Class(web.DHCINSUPort).GetCNCODE(PlanDesc,4,"")
    q:PlanRowid="" $$$OK
    s PPPGridRowid="" f  s PPPGridRowid=$o(^PMPProjectPlani("Type",PlanRowid,PPPGridRowid)) q:PPPGridRowid=""  d
    .s (PPPGridCode,PPPGridDesc,PPPGridPlanStartDate,PPPGridPlanStartTime,PPPGridStartDate,PPPGridStartTime,PPPGridPlanEndDate,PPPGridPlanEndTime,PPPGridEndDate,PPPGridEndTime,PPPGridStatus,PPPGridStatusid,PPPGridImprovment,PPPGridImprovmentid,PPPGridJobLogg,PPPGridJobLoggid,PPPGridModule,PPPGridModuleid,PPPGridContractAging,PPPGridContractAgingid,PPPGridContract,PPPGridContractid,PPPGridAdjuc,PPPGridMenu,PPPGridRemark)=""
    .s PPPGridCode=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",1)
    .q:PPPGridCode=""
    .q:(PlanCode'="")&($$ALPHAUP^SSUTIL4(PPPGridCode)'[PlanCode)
    .s PPPGridDesc=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",2)
    .s desc=##Class(web.DHCINSUPort).GetCNCODE(PPPGridDesc,4,"")_PPPGridDesc
    .q:(PlanDesc'="")&(desc'[PlanDesc)
    .s PPPGridPlanStartDate=..Date($p($g(^PMPProjectPlan(PPPGridRowid)),"^",5))
    .S PPPGridPlanStartTime=..Time($p($g(^PMPProjectPlan(PPPGridRowid)),"^",6))
    .s PPPGridStartDate=..Date($p($g(^PMPProjectPlan(PPPGridRowid)),"^",9))
    .S PPPGridStartTime=..Time($p($g(^PMPProjectPlan(PPPGridRowid)),"^",10))
    .S PPPGridPlanEndDate=..Date($p($g(^PMPProjectPlan(PPPGridRowid)),"^",7))
    .s PPPGridPlanEndTime=..Time($p($g(^PMPProjectPlan(PPPGridRowid)),"^",8))
    .S PPPGridEndDate=..Date($p($g(^PMPProjectPlan(PPPGridRowid)),"^",11))
    .S PPPGridEndTime=..Time($p($g(^PMPProjectPlan(PPPGridRowid)),"^",12))
    .s PPPGridStatusid=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",13)
    .s PPPGridStatus=..Dictionary(PPPGridStatusid)
    .s PPPGridImprovmentid=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",32)
    .i PPPGridImprovmentid'="" s PPPGridImprovment=$p(^PMPImprovementList(PPPGridImprovmentid),"^",2)
    .s PPPGridJobLoggid=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",33)
    .i PPPGridJobLoggid'="" s PPPGridJobLogg=$p(^PMPJobLogging(PPPGridJobLoggid),"^",1)
    .S PPPGridModuleid=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",34)
    .I PPPGridModuleid'="" S PPPGridModule=$p(^PMPModule(PPPGridModuleid),"^",2)
    .s PPPGridContractAgingid=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",35)
    .i PPPGridContractAgingid'=""  S PPPGridContractAging=..Dictionary($p(^PMPContractAging(PPPGridContractAgingid),"^",2))
    .s PPPGridContractid=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",36)
    .i PPPGridContractid'="" s PPPGridContract=$p(^PMPContract(PPPGridContractid),"^",2)
    .s PPPGridAdjuc=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",37)
    .i $d(^PMPImproveAdjuncti("Improve",PPPGridRowid,"PMP_ProjectPlan")) s PPPGridAdjuc="Y"
    .s PPPGridMenu=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",4)
    .s PPPGridRemark=$p($g(^PMPProjectPlan(PPPGridRowid)),"^",15)
    .d OutputRow6
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow6
    s Data=$lb(PPPGridRowid,PPPGridCode,PPPGridDesc,PPPGridPlanStartDate,PPPGridPlanStartTime,PPPGridStartDate,PPPGridStartTime,PPPGridPlanEndDate,PPPGridPlanEndTime,PPPGridEndDate,PPPGridEndTime,PPPGridStatus,PPPGridStatusid,PPPGridImprovment,PPPGridImprovmentid,PPPGridJobLogg,PPPGridJobLoggid,PPPGridModule,PPPGridModuleid,PPPGridContractAging,PPPGridContractAgingid,PPPGridContract,PPPGridContractid,PPPGridAdjuc,PPPGridMenu,PPPGridRemark)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-19
/// description: 公共日期转换方法
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).Date("63324")
ClassMethod Date(Input As %String) As %String
{
	s ret=""
	i Input'="" S ret=$zd(Input,3)
	Q ret
}

/// Creat  zzp
/// date:2015-05-19
/// description: 公共时间转换方法
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).Date("63324")
ClassMethod Time(Input As %String) As %String
{
	s ret=""
	i Input'="" S ret=$zt(Input)
	Q ret
}

/// Creat  zzp
/// date:2015-05-19
/// description: 公共字典转换方法
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).Dictionary("1")
ClassMethod Dictionary(Input As %String) As %String
{
	s ret=""
	q:Input="" ""
	i (Input'="")&&($d(^PMPDictionary(Input))) S ret=$p($G(^PMPDictionary(Input)),"^",2)
	Q ret
}

/// Creat  zzp
/// date:2015-05-19
/// description: 用户名称转换
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).SSUSER("1")
ClassMethod SSUSER(Input As %String) As %String
{
	s ret=""
	i Input["||" s ret=$p(^PMPProjectUser($p(Input,"||",2)),"^",22)
	i (Input'["||")&&($d(^SSU("SSUSR",+Input))) Set ret=$p(^SSU("SSUSR",+Input),"^",2)
	Q ret
}

/// Creat  zzp
/// date:2015-05-19
/// description: 用户名称转换
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).SSUSER("1")
ClassMethod SSUSER1(Input As %String) As %String
{
	s ret=""
	i Input["||" s ret=$p(^PMPProjectUser($p(Input,"||",2)),"^",22)
	i (Input'["||")&&($d(^SSU("SSUSR",+Input))) Set ret=$p(^SSU("SSUSR",+Input),"^",1)
	Q ret
}

/// Creat  zzp
/// date:2015-05-15
/// description: 计划状态数据
/// input:  type()
/// output: String RowId,Description
/// others:w ##class(web.PMP.Document).PPPMenuStatusStore()
ClassMethod PPPMenuStatusStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("PPPMenuStatusStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","PlanStatus",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_"|"_Description
 .s i=i+1
 .s tmp=RowId_"^"_namedesc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 计划工作记录下拉
/// input:  type()
/// output: String RowId,Description
/// others:w ##class(web.PMP.Document).PPPJobStore()
ClassMethod PPPJobStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("PPPJobStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPJobLogging(RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPJobLogging(RowId)),"^",1)
 .q:Description=""
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_"|"_Description
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-15
/// description: 计划工期下拉
/// input:  type()
/// output: String RowId,Description
/// others:w ##class(web.PMP.Document).PPPMenuContractAgingStore("")
ClassMethod PPPMenuContractAgingStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("PPPMenuContractAgingStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPContractAging(RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPContractAging(RowId)),"^",4)
 .q:Description=""
 .s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_"|"_Description
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zzp
/// date:2015-05-20
/// description: 获取模块需求
/// input:  type()
/// output: ContractModeRowid,ContractModeCode,ContractModeDesc,ContractModeStandby3,ContractModeProduct,ContractModeAging,ContractModeStatus,ContractModePlanDate,ContractModePlanTime,ContractModeActDate,ContractModeActTime,ContractModeRemark
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","ModeuleImproStore","4","","","2015-04-01T00:00:00","")
Query ModeuleImproStore(ModeuleIMRowid As %String, ModeuleImproCode As %String, ModeuleImproDesc As %String, ModeuleImproSdate As %String, ModeuleImproEdate As %String) As websys.Query(ROWSPEC = "MIGridRowid:%String,MIGridCode:%String,MIGridDesc:%String,MIGridType:%String,MIGridMenu:%String,MIGridStatus:%String,MIGridCreatDate:%String,MIGridCrectUser:%String,MIGridSituation:%String,MIGridStandby3:%String,MIGridEmergency:%String,MIGridTel:%String,MIGridAdjunctFlag:%String,MIGridApp:%String")
{
}

ClassMethod ModeuleImproStoreExecute(ByRef qHandle As %Binary, ModeuleIMRowid As %String, ModeuleImproCode As %String, ModeuleImproDesc As %String, ModeuleImproSdate As %String, ModeuleImproEdate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    ;s ^Temp("ModeuleImproStore",$h)=ModeuleIMRowid_"^"_ModeuleImproCode_"^"_ModeuleImproDesc_"^"_ModeuleImproSdate_"^"_ModeuleImproEdate
    i ModeuleImproCode'="" s ModeuleImproCode=$$ALPHAUP^SSUTIL4($tr(ModeuleImproCode," "))
    i ModeuleImproCode'="" s ModeuleImproCode=##Class(web.DHCINSUPort).GetCNCODE(ModeuleImproCode,4,"")
    i ModeuleImproDesc'="" s ModeuleImproDesc=$$ALPHAUP^SSUTIL4($tr(ModeuleImproDesc," "))
    i ModeuleImproDesc'="" s ModeuleImproDesc=##Class(web.DHCINSUPort).GetCNCODE(ModeuleImproDesc,4,"")
    q:ModeuleIMRowid="" $$$OK
    i ModeuleImproSdate'="" s ModeuleImproSdate=$zdh(ModeuleImproSdate,3)
    i ModeuleImproEdate'="" s ModeuleImproEdate=$zdh(ModeuleImproEdate,3)
    i (ModeuleImproSdate'="")&(ModeuleImproEdate="") s ModeuleImproEdate=+$h
    i (ModeuleImproEdate'="")&(ModeuleImproSdate="") s ModeuleImproSdate=$o(^PMPImprovementListi("CreateDate",""))
    i ModeuleImproSdate'=""  d
    .f date=ModeuleImproSdate:1:ModeuleImproEdate  d
    ..s MIGridRowid="" f  s MIGridRowid=$o(^PMPImprovementListi("CreateDate",date,MIGridRowid)) q:MIGridRowid=""  d
    ...q:('$d(^PMPImprovementListi("Module",ModeuleIMRowid,MIGridRowid)))
    ...D ..PMPImprovementList(MIGridRowid)
    ...D OutputRow7
    e  d
    .s MIGridRowid="" f  s MIGridRowid=$o(^PMPImprovementListi("Module",ModeuleIMRowid,MIGridRowid)) q:MIGridRowid=""  d
    ..d ..PMPImprovementList(MIGridRowid)
    ..d OutputRow7
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow7
    s desc=##Class(web.DHCINSUPort).GetCNCODE(MIGridDesc,4,"")_MIGridDesc
    q:(ModeuleImproCode'="")&($$ALPHAUP^SSUTIL4(MIGridCode)'[ModeuleImproCode)
    q:(ModeuleImproDesc'="")&(desc'[ModeuleImproDesc)
    s Data=$lb(MIGridRowid,MIGridCode,MIGridDesc,MIGridType,MIGridMenu,MIGridStatus,MIGridCreatDate,MIGridCrectUser,MIGridSituation,MIGridStandby3,MIGridEmergency,MIGridTel,MIGridAdjunctFlag,MIGridApp)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-20
/// description: 根据需求rowid获取该条数数据的详细信息
/// input:  Rowid
/// output: ContractModeRowid,ContractModeCode,ContractModeDesc,ContractModeStandby3,ContractModeProduct,ContractModeAging,ContractModeStatus,ContractModePlanDate,ContractModePlanTime,ContractModeActDate,ContractModeActTime,ContractModeRemark
ClassMethod PMPImprovementList(Rowid As %String) As %String
{
	s (MIGridCode,MIGridDesc,MIGridType,MIGridMenu,MIGridStatus,MIGridCreatDate,MIGridCrectUser,MIGridSituation,MIGridStandby3,MIGridEmergency,MIGridTel,MIGridAdjunctFlag,MIGridApp)=""
	s object=##Class(User.PMPImprovementList).%OpenId(Rowid)
	s MIGridCode=object.IPMLCode
	s MIGridDesc=object.IPMLName
	s MIGridType=..Dictionary($p(^PMPImprovementList(Rowid),"^",31))
	s MIGridMenu=object.IPMLMenu
	s MIGridStatus=..Dictionary($p(^PMPImprovementList(Rowid),"^",28))
	s MIGridCreatDate=..Date(object.IPMLCreateDate)_" "_..Time(object.IPMLCreateTime)
	s MIGridCrectUser=..SSUSER($p(^PMPImprovementList(Rowid),"^",15))
	s MIGridSituation=object.IPMLSituation
	s MIGridStandby3=object.IPMLStandby3
	s MIGridEmergency=..Dictionary($p(^PMPImprovementList(Rowid),"^",18))
	s MIGridTel=object.IPMLCreateTel
	s MIGridAdjunctFlag=object.IPMLAdjunctFlag
	i $D(^PMPImprovementAppraisal(Rowid)) s MIGridApp="Y"
	q
}

/// Creat  zzp
/// date:2015-05-21
/// description: 获取目录树数据
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).DirTree("208")
ClassMethod DirTree(InPut As %String) As %Text
{
	s ^CacheTemp("DirTree")=InPut
	q:InPut="" "[]" 
	set json=""
	q:'$d(^PMPDirectoryTreei("LEVE",InPut))
	s one=$o(^PMPDirectoryTreei("LEVE",InPut,""))
	s sub="" f  s sub=$o(^PMPDirectoryTreei("LEVE",InPut,one,sub)) q:sub=""  d
	.s:json'="" json=json_","
	.s id=sub
	.s text=$p(^PMPDirectoryTree(sub),"^",3)
	.s json=json_"{"_"""id"":"""_id_""",""text"":"""_text_""","
	.s json=json_"""iconCls"":""icon-pro"","
	.s subjson=##class(web.PMP.Document).DirTreeSubJson(InPut,id)
	.i subjson="[]"  d
	..s json=json_"""leaf"":true"
	.e  d
	..s json=json_"""expanded"":true,""leaf"":false,""children"":"_subjson
	.s json=json_"}"
	quit "["_json_"]"
}

ClassMethod DirTreeSubJson(sub As %String, treesub As %String) As %String
{
	new (sub,treesub)
	set json=""
	s subid=$o(^PMPDirectoryTreei("FatherLeve",sub,treesub,""))
	while (subid'="") {
		s:json'="" json=json_","
		s id=subid
		s text=$p(^PMPDirectoryTree(subid),"^",3)
		s json=json_"{"_"""id"":"""_id_""",""text"":"""_text_""","
		s json=json_"""iconCls"":""icon-pro"","
		s subjson=##Class(web.PMP.Document).DirTreeSubJson(sub,id) 
		i subjson="[]"  d
		.s json=json_"""leaf"":true"
		e  d
	    .s json=json_"""expanded"":true,""leaf"":false,""children"":"_subjson
	    s json=json_"}"
	    s subid=$o(^PMPDirectoryTreei("FatherLeve",sub,treesub,subid))
		}
		q "["_json_"]"
}

/// Creat  zzp
/// date:2015-05-22
/// description: 获取合同附件列表
/// input:  type()
/// output: ContractModeRowid,ContractModeCode,ContractModeDesc,ContractModeStandby3,ContractModeProduct,ContractModeAging,ContractModeStatus,ContractModePlanDate,ContractModePlanTime,ContractModeActDate,ContractModeActTime,ContractModeRemark
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","ContracAdjunctStore","19","Work")
Query ContracAdjunctStore(ContracAdjunctRowid As %String, Contract As %String) As websys.Query(ROWSPEC = "ConAdRowid:%String,ConAdName:%String,ConAdFileType:%String,ConAdDate:%String,ConAdUser:%String,ConAdType:%String,ConAdFtpName:%String,ConAdFalg:%String")
{
}

ClassMethod ContracAdjunctStoreExecute(ByRef qHandle As %Binary, ContracAdjunctRowid As %String, Contract As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    ;s ^Temp("ContracAdjunctStore",$h)=ContracAdjunctRowid_"^"_Contract
    q:Contract="" $$$OK
    s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
    s id="" f  s id=$o(^PMPImproveAdjuncti("Affilation",Contract,id)) q:id=""  d
    .s (ConAdRowid,ConAdName,ConAdFileType,ConAdDate,ConAdUser,ConAdType,ConAdFtpName,ConAdFalg)=""
    .s conid=$p(^PMPImprovementAdjunct(id),"^",2)
    .q:conid'=ContracAdjunctRowid
    .s ConAdFalg="Y"
    .S ConAdFtpName=$p(^PMPImprovementAdjunct(id),"^",7)
    .S ConAdType=$p(^PMPImprovementAdjunct(id),"^",1)
    .S ConAdUserid=$p(^PMPImprovementAdjunct(id),"^",13)
    .i ConAdUserid["||" s ConAdUser=$p(^PMPProjectUser($p(ConAdUserid,"||",2)),"^",22)
	.i ConAdUserid'["||" set ConAdUser=$p(^SSU("SSUSR",+ConAdUserid),"^",2)
	.i IndependentUserRet="Y" s ConAdUserid=+ConAdUserid
    .S ConAdDate=..Date($p(^PMPImprovementAdjunct(id),"^",11))_" "_..Time($p(^PMPImprovementAdjunct(id),"^",12))
    .s ConAdName=$p(^PMPImprovementAdjunct(id),"^",4)
    .s ConAdFileType=$p(ConAdName,".",$l(ConAdName,"."))
    .s ConAdRowid=ContracAdjunctRowid_"||"_id
    .d OutputRow8
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow8
    s Data=$lb(ConAdRowid,ConAdName,ConAdFileType,ConAdDate,ConAdUser,ConAdType,ConAdFtpName,ConAdFalg)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-22
/// description: 判断新文件名
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).AddFileName("")
ClassMethod AddFileName(InPut As %String) As %String
{
	s ret=""
	q:InPut="" ret
	s date=..Date(+$h)_" "_..Time($p($h,",",2))
	s User=%session.Data("LOGON.USERNAME")
	s type=$p(InPut,".",$L(InPut,"."))
	S flag="Contract"
	s ret=User_"^"_type_"^"_flag_"^"_date
	q ret
}

/// Creat  zhagnsong
/// date:2015-05-19
/// description: 公共日期转换方法 ODBC -> Cache
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).Date("2015-05-30")
ClassMethod RDate(Input As %String) As %String
{
	s ret=""
	i Input'="" S ret=$zdh(Input,3)
	Q ret
}

/// Creat  Zhangsong
/// date:2015-05-19
/// description: 公共时间转换方法 ODBC -> Cache
/// input:  type()
/// output: 
/// others:w ##class(web.PMP.Document).Date("00:00:00")
ClassMethod RTime(Input As %String) As %String
{
	s ret=""
	i Input'="" S ret=$zth(Input)
	Q ret
}

/// Creat  zzp
/// date:2015-05-24
/// description: 工期计划数据新增、更新操作
/// input:  InPut(CAAddRowidValue+"^"+CAAddFlagValue+"^"+CACodeValue+"^"+CADescValue+"^"+CAAgingNameValue+"^"+CAStatusValue+"^"+CAPlanStartDateValue+"^"+CAPlanStratTimeValue+"^"+CAStartDateValue+"^"+CAStartTimeValue+"^"+CAPlanEndDateValue+"^"+CAPlanEndTimeValue+"^"+CAEndDateValue+"^"+CAEndTimeValue+"^"+CAContractNameValue),Menu,IP
/// input          数据id                操作标识         工期编码        工期名称         合同工期             工期状态           计划开始日期            计划开始时间            实际开始日期          实际开始时间        计划结束日期             计划结束时间        实际结束日期        实际结束时间         合同名称         备注 IP地址
/// output:  ret  1:操作成功,  失败代码
/// others:w ##class(web.PMP.Document).AddUpdateContractAging("","","")
ClassMethod AddUpdateContractAging(InPut As %Text, Menu As %Text, IP As %String) As %String
{
	s ret=""
	s Date=+$h,Time=$p($h,",",2)
	s UserId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	;s ^Temp("AddUpdateContractAging",$H)=InPut_"@@"_Menu_"@@"_UserId
	q:$l(InPut,"^")'="15" "-1"
	s CAAddRowidValue=$p(InPut,"^",1)
	s CAAddFlagValue=$p(InPut,"^",2)
	s CACodeValue=$p(InPut,"^",3)
	s CADescValue=$p(InPut,"^",4)
	s CAAgingNameValue=$p(InPut,"^",5)
	s CAStatusValue=$p(InPut,"^",6)
	s CAPlanStartDateValue=..RDate($p(InPut,"^",7))
	s CAPlanStratTimeValue=..RTime($p(InPut,"^",8))
	s CAStartDateValue=..RDate($p(InPut,"^",9))
	s CAStartTimeValue=..RTime($p(InPut,"^",10))
	s CAPlanEndDateValue=..RDate($p(InPut,"^",11))
	s CAPlanEndTimeValue=..RTime($p(InPut,"^",12))
	s CAEndDateValue=..RDate($p(InPut,"^",13))
	s CAEndTimeValue=..RTime($p(InPut,"^",14))
	s CAContractNameValue=$p(InPut,"^",15)
	i CAAddFlagValue="Add" d AddContractAging
	i CAAddFlagValue="Update" d UpdateContractAging
	q ret
AddContractAging
    Ts
    s object=##Class(User.PMPContractAging).%New()
    i CAContractNameValue'=""  d
    .s objectContract=##Class(User.PMPContract).%OpenId(CAContractNameValue)
    .s object.PCTAContract=objectContract
    i CAAgingNameValue'=""  d
    .s objectAging=##Class(User.PMPDictionary3).%OpenId(CAAgingNameValue)
    .s object.PCTAAging=objectAging
    i CACodeValue'="" s object.PCTACode=CACodeValue
    i CADescValue'="" s object.PCTADesc=CADescValue
    i CAStatusValue'=""  d
    .s objectStatus=##Class(User.PMPDictionary3).%OpenId(CAStatusValue)
    .s object.PCTAStatus=objectStatus
    i CAPlanStartDateValue'="" s object.PCTAPlanStartDate=CAPlanStartDateValue
    i CAPlanStratTimeValue'="" s object.PCTAPlanStartTime=CAPlanStratTimeValue
    i CAStartDateValue'="" s object.PCTAStartDate=CAStartDateValue
    i CAStartTimeValue'="" s object.PCTAStartTime=CAStartTimeValue
    i CAPlanEndDateValue'="" s object.PCTAPlanEndDate=CAPlanEndDateValue
    i CAPlanEndTimeValue'="" s object.PCTAPlanEndTime=CAPlanEndTimeValue
    i CAEndDateValue'="" s object.PCTAEndDate=CAEndDateValue
    i CAEndTimeValue'="" s object.PCTAEndTime=CAEndTimeValue
    i UserId'=""  d
    .s object.PCTACreatUser=UserId
    .s object.PCTAUpdateUser=UserId
    i Date'="" s object.PCTACreatDate=Date,object.PCTAUpdateDate=Date
    i Time'="" s object.PCTACreatTime=Time,object.PCTAUpdateTime=Time
    i Menu'="" s object.PCTARemark=Menu
    s sc=object.%Save()
    i sc{
	    Tc
	    s id=object.%Id()
	    s TabMessage="PMP_ContractAging"_"@@"_id_"@@"_"Add"_"@@"_IP
	    s OldValue="",NewValue=Date_"@@"_Time_"@@"_UserId_"@@"_Date_"@@"_Time_"@@"_UserId,TabFieldName="PCTA_CreatDate@@PCTA_CreatTime@@PCTA_CreatUser@@PCTA_UpdateDate@@PCTA_UpdateTime@@PCTA_UpdateUser"
	    i CAContractNameValue'=""  s NewValue=NewValue_"@@"_CAContractNameValue,TabFieldName=TabFieldName_"@@PCTA_Contract"
	    i CAAgingNameValue'="" s NewValue=NewValue_"@@"_CAAgingNameValue,TabFieldName=TabFieldName_"@@PCTA_Aging"
	    i CACodeValue'="" s NewValue=NewValue_"@@"_CACodeValue,TabFieldName=TabFieldName_"@@PCTA_Code"
	    i CADescValue'="" s NewValue=NewValue_"@@"_CADescValue,TabFieldName=TabFieldName_"@@PCTA_Desc"
	    i CAStatusValue'="" s NewValue=NewValue_"@@"_CAStatusValue,TabFieldName=TabFieldName_"@@PCTA_Status"
	    i CAPlanStartDateValue'="" s NewValue=NewValue_"@@"_CAPlanStartDateValue,TabFieldName=TabFieldName_"@@PCTA_PlanStartDate"
	    i CAPlanStratTimeValue'="" s NewValue=NewValue_"@@"_CAPlanStratTimeValue,TabFieldName=TabFieldName_"@@PCTA_PlanStartTime"
	    i CAStartDateValue'="" s NewValue=NewValue_"@@"_CAStartDateValue,TabFieldName=TabFieldName_"@@PCTA_StartDate"
	    i CAStartTimeValue'="" s NewValue=NewValue_"@@"_CAStartTimeValue,TabFieldName=TabFieldName_"@@PCTA_StartTime"
	    i CAPlanEndDateValue'="" s NewValue=NewValue_"@@"_CAPlanEndDateValue,TabFieldName=TabFieldName_"@@PCTA_PlanEndDate"
	    i CAPlanEndTimeValue'="" s NewValue=NewValue_"@@"_CAPlanEndTimeValue,TabFieldName=TabFieldName_"@@PCTA_PlanEndTime"
	    i CAEndDateValue'="" s NewValue=NewValue_"@@"_CAEndDateValue,TabFieldName=TabFieldName_"@@PCTA_EndDate"
	    i CAEndTimeValue'="" s NewValue=NewValue_"@@"_CAEndTimeValue,TabFieldName=TabFieldName_"@@PCTA_EndTime"
	    i Menu'="" s NewValue=NewValue_"@@"_Menu,TabFieldName=TabFieldName_"@@PCTA_Remark"
	    d ##class(web.PMP.Document).PMPOperatingRecord(TabMessage,OldValue,NewValue,TabFieldName)
	    }
	else{
		Tro
		}
	s ret=sc
    q ret
UpdateContractAging
    Ts
    s object=##Class(User.PMPContractAging).%OpenId($p(CAAddRowidValue,"||",2))
    s TabMessage="PMP_ContractAging"_"@@"_$p(CAAddRowidValue,"||",2)_"@@"_"Update"_"@@"_IP
	s OldValue=object.PCTAUpdateDate_"@@"_object.PCTAUpdateTime_"@@"_object.PCTAUpdateUser,NewValue=Date_"@@"_Time_"@@"_UserId,TabFieldName="PCTA_UpdateDate@@PCTA_UpdateTime@@PCTA_UpdateUser"
    i CAContractNameValue'=object.PCTAContract  s OldValue=OldValue_"@@"_object.PCTAContract,NewValue=NewValue_"@@"_CAContractNameValue,TabFieldName=TabFieldName_"@@PCTA_Contract"
    i CAAgingNameValue'=object.PCTAAging s OldValue=OldValue_"@@"_object.PCTAAging,NewValue=NewValue_"@@"_CAAgingNameValue,TabFieldName=TabFieldName_"@@PCTA_Aging"
    i CACodeValue'=object.PCTACode s OldValue=OldValue_"@@"_object.PCTACode,NewValue=NewValue_"@@"_CACodeValue,TabFieldName=TabFieldName_"@@PCTA_Code"
    i CADescValue'=object.PCTADesc s OldValue=OldValue_"@@"_object.PCTADesc,NewValue=NewValue_"@@"_CADescValue,TabFieldName=TabFieldName_"@@PCTA_Desc"
    i CAStatusValue'=object.PCTAStatus s OldValue=OldValue_"@@"_object.PCTAStatus,NewValue=NewValue_"@@"_CAStatusValue,TabFieldName=TabFieldName_"@@PCTA_Status"
	i CAPlanStartDateValue'=object.PCTAPlanStartDate s OldValue=OldValue_"@@"_object.PCTAPlanStartDate,NewValue=NewValue_"@@"_CAPlanStartDateValue,TabFieldName=TabFieldName_"@@PCTA_PlanStartDate"
	i CAPlanStratTimeValue'=object.PCTAPlanStartTime s OldValue=OldValue_"@@"_object.PCTAPlanStartTime,NewValue=NewValue_"@@"_CAPlanStratTimeValue,TabFieldName=TabFieldName_"@@PCTA_PlanStartTime"
	i CAStartDateValue'=object.PCTAStartDate s OldValue=OldValue_"@@"_object.PCTAStartDate,NewValue=NewValue_"@@"_CAStartDateValue,TabFieldName=TabFieldName_"@@PCTA_StartDate"
	i CAStartTimeValue'=object.PCTAStartTime s OldValue=OldValue_"@@"_object.PCTAStartTime,NewValue=NewValue_"@@"_CAStartTimeValue,TabFieldName=TabFieldName_"@@PCTA_StartTime"
	i CAPlanEndDateValue'=object.PCTAPlanEndDate s OldValue=OldValue_"@@"_object.PCTAPlanEndDate,NewValue=NewValue_"@@"_CAPlanEndDateValue,TabFieldName=TabFieldName_"@@PCTA_PlanEndDate"
	i CAPlanEndTimeValue'=object.PCTAPlanEndTime s OldValue=OldValue_"@@"_object.PCTAPlanEndTime,NewValue=NewValue_"@@"_CAPlanEndTimeValue,TabFieldName=TabFieldName_"@@PCTA_PlanEndTime"
	i CAEndDateValue'=object.PCTAEndDate s OldValue=OldValue_"@@"_object.PCTAEndDate,NewValue=NewValue_"@@"_CAEndDateValue,TabFieldName=TabFieldName_"@@PCTA_EndDate"
	i CAEndTimeValue'=object.PCTAEndTime s OldValue=OldValue_"@@"_object.PCTAEndTime,NewValue=NewValue_"@@"_CAEndTimeValue,TabFieldName=TabFieldName_"@@PCTA_EndTime"
	i Menu'=object.PCTARemark s OldValue=OldValue_"@@"_object.PCTARemark,NewValue=NewValue_"@@"_Menu,TabFieldName=TabFieldName_"@@PCTA_Remark"
    i CAContractNameValue'=""  d
    .s objectContract=##Class(User.PMPContract).%OpenId(CAContractNameValue)
    .s object.PCTAContract=objectContract
    i CAAgingNameValue'=""  d
    .s objectAging=##Class(User.PMPDictionary3).%OpenId(CAAgingNameValue)
    .s object.PCTAAging=objectAging
    s object.PCTACode=CACodeValue
    s object.PCTADesc=CADescValue
    i CAStatusValue'=""  d
    .s objectStatus=##Class(User.PMPDictionary3).%OpenId(CAStatusValue)
    .s object.PCTAStatus=objectStatus
    i CAStatusValue="" s object.PCTAStatus=CAStatusValue
    s object.PCTAPlanStartDate=CAPlanStartDateValue
    s object.PCTAPlanStartTime=CAPlanStratTimeValue
    s object.PCTAStartDate=CAStartDateValue
    s object.PCTAStartTime=CAStartTimeValue
    s object.PCTAPlanEndDate=CAPlanEndDateValue
    s object.PCTAPlanEndTime=CAPlanEndTimeValue
    s object.PCTAEndDate=CAEndDateValue
    s object.PCTAEndTime=CAEndTimeValue
    i UserId'=""  d
    .s object.PCTAUpdateUser=UserId
    s object.PCTAUpdateDate=Date
    s object.PCTAUpdateTime=Time
    s object.PCTARemark=Menu
    s sc=object.%Save()
    i sc{
	    Tc
	    d ##class(web.PMP.Document).PMPOperatingRecord(TabMessage,OldValue,NewValue,TabFieldName)
	    }
	else{
		Tro
		}
	s ret=sc
    q ret
}

/// Creat  zzp
/// date:2015-05-24
/// description: 根据模块名称获取模块id
/// input:  模块名称
/// output: 模块id
/// others:w ##class(web.PMP.Document).ModeId("居民医保")
ClassMethod ModeId(InPut As %String) As %String
{
	s ret=""
	q:InPut="" ""
	i $d(^PMPModulei("Desc",InPut)) s ret=$o(^PMPModulei("Desc",InPut,""))
	q ret
}

/// Creat  zzp
/// date:2015-05-24
/// description: 模块明细更新、新增操作
/// input:  ModeString(CAModeRowidValue+"^"+CAModeFlagValue+"^"+CAAgingModeNameValue),CAAgingModeRemarkValue,ip
///                      记录id               标志                 模块名称                备注            操作ip
/// output:  
/// others:w ##class(web.PMP.Document).ModeAddUpdateAging("1||1^Add^3","说地方到时候和","192.168.1.3")
ClassMethod ModeAddUpdateAging(ModeString As %Text, CAAgingModeRemarkValue As %Text, ip As %String) As %String
{
	;s ^Temp("ModeAddUpdateAging",$H)=ModeString_"@@"_CAAgingModeRemarkValue_"@@"_ip
	s ret=""
	s Date=+$h,Time=$p($h,",",2)
	s UserId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	q:$l(ModeString,"^")'="3" ""
	S CAModeRowidValue=$P(ModeString,"^",1)
	s Agingrowid=$p(CAModeRowidValue,"||",2)
	S CAModeFlagValue=$P(ModeString,"^",2)
	S CAAgingModeNameValue=$P(ModeString,"^",3)
	i (CAAgingModeNameValue'="")&&(CAAgingModeNameValue<1)  s CAAgingModeNameValue=..ModeId(CAAgingModeNameValue)
	i CAModeFlagValue="Add" d AddModeAging
	i CAModeFlagValue="Update" d UpDateModeAging
	q ret
AddModeAging
    q:$d(^PMPContractAgingModei("MODE",+CAModeRowidValue,CAAgingModeNameValue)) "-1"
    Ts
    &sql(insert into sqluser.PMP_ContractAgingMode (PCTA_ParRef,PCAM_Mode,PCAM_Remark,PCAM_Date,PCAM_Time,PCAM_User,PCAM_UpdateDate,PCAM_UpdateTime,PCAM_UpdateUser) values (:Agingrowid,:CAAgingModeNameValue,:CAAgingModeRemarkValue,:Date,:Time,:UserId,:Date,:Time,:UserId))
    i $g(SQLCODE){
	    Tro
	    }
	 else{
		 Tc
		 s id=%ROWID
		 s TabMessage="PMP_ContractAgingMode"_"@@"_id_"@@"_"Add"_"@@"_ip
	     s OldValue="",NewValue=Date_"@@"_Time_"@@"_UserId_"@@"_Date_"@@"_Time_"@@"_UserId,TabFieldName="PCAM_Date@@PCAM_Time@@PCAM_User@@PCAM_UpdateDate@@PCAM_UpdateTime@@PCAM_UpdateUser"
	     i CAAgingModeNameValue'="" s NewValue=NewValue_"@@"_CAAgingModeNameValue,TabFieldName=TabFieldName_"@@PCAM_Mode"
		 i CAAgingModeRemarkValue'="" s NewValue=NewValue_"@@"_CAAgingModeRemarkValue,TabFieldName=TabFieldName_"@@PCAM_Remark"
		 d ##class(web.PMP.Document).PMPOperatingRecord(TabMessage,OldValue,NewValue,TabFieldName)
		 }
     i $g(SQLCODE)="0" s ret="1"
     i $g(SQLCODE)'="0" s ret=$g(SQLCODE)
     q ret
UpDateModeAging
    q:$d(^PMPContractAgingModei("MODE",+CAModeRowidValue,CAAgingModeNameValue)) "-1"
    s rowid=$p(CAModeRowidValue,"||",1)_"||"_$p(CAModeRowidValue,"||",2)
    s oldDate=$p(^PMPContractAgingMode($p(CAModeRowidValue,"||",1),$p(CAModeRowidValue,"||",2)),"^",8)
    s oldTime=$p(^PMPContractAgingMode($p(CAModeRowidValue,"||",1),$p(CAModeRowidValue,"||",2)),"^",9)
    s oldUser=$p(^PMPContractAgingMode($p(CAModeRowidValue,"||",1),$p(CAModeRowidValue,"||",2)),"^",10)
    s TabMessage="PMP_ContractAgingMode"_"@@"_rowid_"@@"_"Update"_"@@"_ip
	s OldValue=oldDate_"@@"_oldTime_"@@"_oldUser,NewValue=Date_"@@"_Time_"@@"_UserId,TabFieldName="PCAM_UpdateDate@@PCAM_UpdateTime@@PCAM_UpdateUser"
    s mode=$p(^PMPContractAgingMode($p(CAModeRowidValue,"||",1),$p(CAModeRowidValue,"||",2)),"^",2)
    i mode'=CAAgingModeNameValue s OldValue=OldValue_"@@"_mode,NewValue=NewValue_"@@"_CAAgingModeNameValue,TabFieldName=TabFieldName_"@@PCAM_Mode"
    s oldMenu=$p(^PMPContractAgingMode($p(CAModeRowidValue,"||",1),$p(CAModeRowidValue,"||",2)),"^",4)
    i oldMenu'=CAAgingModeRemarkValue s OldValue=OldValue_"@@"_oldMenu,NewValue=NewValue_"@@"_CAAgingModeRemarkValue,TabFieldName=TabFieldName_"@@PCAM_Remark"
    Ts
    &SQL(Update sqluser.PMP_ContractAgingMode set PCAM_Mode=:CAAgingModeNameValue,PCAM_Remark=:CAAgingModeRemarkValue,PCAM_UpdateDate=:Date,PCAM_UpdateTime=:Time,PCAM_UpdateUser=:UserId where PCAM_Rowid =:rowid)
    i $g(SQLCODE){
	    Tro
	    }
	else{
		Tc
		d ##class(web.PMP.Document).PMPOperatingRecord(TabMessage,OldValue,NewValue,TabFieldName)
		}
    i $g(SQLCODE)="0" s ret="1"
    i $g(SQLCODE)'="0" s ret=$g(SQLCODE) 
    q ret
}

/// Creat  zzp  
/// date:2015-05-24
/// description: 获取文档管理界树形结构加载的类型id
/// input:  
/// output: String 
/// others: w ##class(web.PMP.Document).DocunmentStree()
ClassMethod DocunmentStree() As %String
{
	s ret="208"
	i $d(^PMPSysConfigure("Type","DocunmentStree"))  d
	.s rowid=$o(^PMPSysConfigure("Type","DocunmentStree",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-24
/// description: 获取文档管理界面初始化是否显示全部数据
/// input:  
/// output: 1：全部显示，0：不显示  默认全显示
/// others: w ##class(web.PMP.Document).DocunmentStart()
ClassMethod DocunmentStart() As %String
{
	s ret="0"
	i $d(^PMPSysConfigure("Type","DocunmentStart"))  d
	.s rowid=$o(^PMPSysConfigure("Type","DocunmentStart",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-24
/// description: 获取文档管理界面默认加载类型
/// input:  
/// output: String 
/// others: w ##class(web.PMP.Document).DocumentType()
ClassMethod DocumentType() As %String
{
	s ret="myself^0"
	i $d(^PMPSysConfigure("Type","DocumentType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","DocumentType",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	i (ret'="myself")&(ret'="share")&(ret'="receive") s ret="myself^0"
	i ret="myself" s ret="myself^0"
	i ret="share" s ret="share^1"
	i ret="receive" s ret="receive^2"
	q ret
}

/// Creat  zzp
/// date:2015-05-24
/// description: 获取文件信息
/// input:  type()
/// output: DocumentGridRowid,DocumentGridDesc,DocumentGridCode,DocumentGridStatus,DocumentGridCreatUser,DocumentGridCreatDate,DocumentGridGroup,DocumentGridLevel,DocumentGridDownloadsCount,DocumentGridReceive,ContractGridEffectiveDate,ContractGridEffectiveTime,DocumentGridFtpName,DocumentGridSize,DocumentGridType,DocumentGridShare
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","DocumentDetailStore","7","myself","")
Query DocumentDetailStore(DocumentID As %String, DocumentType As %String, DocumentName As %String) As websys.Query(ROWSPEC = "DocumentGridRowid:%String,DocumentGridDesc:%String,DocumentGridCode:%String,DocumentGridStatus:%String,DocumentGridCreatUser:%String,DocumentGridCreatDate:%String,DocumentGridCreatTime:%String,DocumentGridGroup:%String,DocumentGridLevel:%String,DocumentGridDownloadsCount:%String,DocumentGridReceive:%String,DocumentGridFtpName:%String,DocumentGridSize:%String,DocumentGridType:%String,DocumentGridShare:%String")
{
}

ClassMethod DocumentDetailStoreExecute(ByRef qHandle As %Binary, DocumentID As %String, DocumentType As %String, DocumentName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    ;s ^Temp("DocumentDetailStore",$h)=DocumentID_"^"_DocumentType_"^"_DocumentName
    s UserId=%session.Data("LOGON.USERID")
    s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
    q:DocumentType="" $$$OK
    s starttype=..DocunmentStart()
    q:(DocumentID="")&(starttype="0") $$$OK
    i DocumentID=""  d
    .i DocumentType="myself"  d
    ..s DocumentGridRowid="" f  s DocumentGridRowid=$o(^PMPDocumenti("User",UserId,DocumentGridRowid)) q:DocumentGridRowid=""  d
    ...Q:$p(^PMPDocument(DocumentGridRowid),"^",29)'="Y"
    ...d DocumentDetail
    ...d OutputRow9
    .i DocumentType="share"  d
    ..s DocumentGridRowid="" f  s DocumentGridRowid=$o(^PMPDocumenti("Share","Y",DocumentGridRowid)) q:DocumentGridRowid=""  d
    ...Q:$p(^PMPDocument(DocumentGridRowid),"^",29)'="Y"
    ...d DocumentDetail
    ...d OutputRow9
    .i DocumentType="receive"  d
    ..s DocumentGridRowid="" f  s DocumentGridRowid=$o(^PMPDocumenti("Receive","Y",DocumentGridRowid)) q:DocumentGridRowid=""  d
    ...Q:$p(^PMPDocument(DocumentGridRowid),"^",29)'="Y"
    ...q:(DocumentType="share")&($p(^PMPDocument(DocumentGridRowid),"^",24)'="Y")
	...q:(DocumentType="receive")&&($p(^PMPDocument(DocumentGridRowid),"^",4)'="Y")&&('$d(^PMPDocumentReceivei("ReceiveUser",DocumentGridRowid,UserId)))
	...q:(DocumentType="myself")&(UserId'=$p(^PMPDocument(DocumentGridRowid),"^",5))
    ...d DocumentDetail
    ...d OutputRow9
    e  d
    .s DocumentGridRowid="" f  s DocumentGridRowid=$o(^PMPDocumenti("Contents",DocumentID,DocumentGridRowid)) q:DocumentGridRowid=""  d
    ..Q:$p(^PMPDocument(DocumentGridRowid),"^",29)'="Y"
    ..;q:$p(^PMPDocument(DocumentGridRowid),"^",5)'=UserId
    ..q:(DocumentType="share")&($p(^PMPDocument(DocumentGridRowid),"^",24)'="Y")
    ..q:(DocumentType="receive")&&($p(^PMPDocument(DocumentGridRowid),"^",4)'="Y")&&'$d(^PMPDocumentReceivei("ReceiveUser",DocumentGridRowid,UserId))
    ..d DocumentDetaild()
    ..d OutputRow9
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
DocumentDetaild()
    s (DocumentGridDesc,DocumentGridCode,DocumentGridStatus,DocumentGridCreatUser,DocumentGridCreatDate,DocumentGridCreatTime,DocumentGridGroup,DocumentGridLevel,DocumentGridDownloadsCount,DocumentGridReceive,DocumentGridFtpName,DocumentGridSize,DocumentGridType,DocumentGridShare)=""
	s DocumentGridDesc=$p(^PMPDocument(DocumentGridRowid),"^",2)
	s DocumentGridCode=$p(^PMPDocument(DocumentGridRowid),"^",1)
	s DocumentGridStatus=..Dictionary($p(^PMPDocument(DocumentGridRowid),"^",9))
	s DocumentGridCreatUser=..SSUSER($p(^PMPDocument(DocumentGridRowid),"^",5))
	s DocumentGridCreatDate=..Date($p(^PMPDocument(DocumentGridRowid),"^",6))
	s DocumentGridCreatTime=..Time($p(^PMPDocument(DocumentGridRowid),"^",7))
	s DocumentGridGroup=..Dictionary($p(^PMPDocument(DocumentGridRowid),"^",3))
	s DocumentGridLevel=..Dictionary($p(^PMPDocument(DocumentGridRowid),"^",8))
	s DocumentGridDownloadsCount=$p(^PMPDocument(DocumentGridRowid),"^",10)
	s DocumentGridReceive=$p(^PMPDocument(DocumentGridRowid),"^",4)  ;UserId
	I (DocumentGridReceive="Y")&&($d(^PMPDocumentReceivei("ReceiveUser",DocumentGridRowid,UserId)))  D
	.S SUB=$O(^PMPDocumentReceivei("ReceiveUser",DocumentGridRowid,UserId,""))
	.S TYPE=$P(^PMPDocumentReceive(DocumentGridRowid,SUB),"^",9)
	.I TYPE="N" S DocumentGridReceive="N"
	I (DocumentGridReceive="Y")&&('$d(^PMPDocumentReceivei("ReceiveUser",DocumentGridRowid,UserId))) S DocumentGridReceive="N"
	s DocumentGridFtpName=$p(^PMPDocument(DocumentGridRowid),"^",28)
	s DocumentGridSize=$p(^PMPDocument(DocumentGridRowid),"^",26)
	s DocumentGridType=$p(^PMPDocument(DocumentGridRowid),"^",27)
	s DocumentGridShare=$p(^PMPDocument(DocumentGridRowid),"^",24)
	q 
DocumentDetail
    s (DocumentGridDesc,DocumentGridCode,DocumentGridStatus,DocumentGridCreatUser,DocumentGridCreatDate,DocumentGridCreatTime,DocumentGridGroup,DocumentGridLevel,DocumentGridDownloadsCount,DocumentGridReceive,DocumentGridFtpName,DocumentGridSize,DocumentGridType,DocumentGridShare)=""
	s DocumentGridDesc=$p(^PMPDocument(DocumentGridRowid),"^",2)
	s DocumentGridCode=$p(^PMPDocument(DocumentGridRowid),"^",1)
	s DocumentGridStatus=..Dictionary($p(^PMPDocument(DocumentGridRowid),"^",9))
	s DocumentGridCreatUser=..SSUSER($p(^PMPDocument(DocumentGridRowid),"^",5))
	s DocumentGridCreatDate=..Date($p(^PMPDocument(DocumentGridRowid),"^",6))
	s DocumentGridCreatTime=..Time($p(^PMPDocument(DocumentGridRowid),"^",7))
	s DocumentGridGroup=..Dictionary($p(^PMPDocument(DocumentGridRowid),"^",3))
	s DocumentGridLevel=..Dictionary($p(^PMPDocument(DocumentGridRowid),"^",8))
	s DocumentGridDownloadsCount=$p(^PMPDocument(DocumentGridRowid),"^",10)
	s DocumentGridReceive=$p(^PMPDocument(DocumentGridRowid),"^",4)
	I (DocumentGridReceive="Y")&&($d(^PMPDocumentReceivei("ReceiveUser",DocumentGridRowid,UserId)))  D
	.S SUB=$O(^PMPDocumentReceivei("ReceiveUser",DocumentGridRowid,UserId,""))
	.S TYPE=$P(^PMPDocumentReceive(DocumentGridRowid,SUB),"^",9)
	.I TYPE="N" S DocumentGridReceive="N"
	I (DocumentGridReceive="Y")&&('$d(^PMPDocumentReceivei("ReceiveUser",DocumentGridRowid,UserId))) S DocumentGridReceive="N"
	s DocumentGridFtpName=$p(^PMPDocument(DocumentGridRowid),"^",28)
	s DocumentGridSize=$p(^PMPDocument(DocumentGridRowid),"^",26)
	s DocumentGridType=$p(^PMPDocument(DocumentGridRowid),"^",27)
	s DocumentGridShare=$p(^PMPDocument(DocumentGridRowid),"^",24)
	q 
OutputRow9
    q:(DocumentName'="")&(DocumentGridDesc'[DocumentName)
    s Data=$lb(DocumentGridRowid,DocumentGridDesc,DocumentGridCode,DocumentGridStatus,DocumentGridCreatUser,DocumentGridCreatDate,DocumentGridCreatTime,DocumentGridGroup,DocumentGridLevel,DocumentGridDownloadsCount,DocumentGridReceive,DocumentGridFtpName,DocumentGridSize,DocumentGridType,DocumentGridShare)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-24
/// description: 获取文件信息
/// input:  type()
/// output: DocumentGridRowid,DocumentGridDesc,DocumentGridCode,DocumentGridStatus,DocumentGridCreatUser,DocumentGridCreatDate,DocumentGridGroup,DocumentGridLevel,DocumentGridDownloadsCount,DocumentGridReceive,ContractGridEffectiveDate,ContractGridEffectiveTime,DocumentGridFtpName,DocumentGridSize,DocumentGridType,DocumentGridShare
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","AddDoFileGridStore","")
Query AddDoFileGridStore(Input As %String) As websys.Query(ROWSPEC = "AddDoFileGridRowid:%String,AddDoFileGridDesc:%String,AddDoFileGridCode:%String,AddDoFileGridSize:%String,AddDoFileGridType:%String,AddDoFileUrl:%String")
{
}

ClassMethod AddDoFileGridStoreExecute(ByRef qHandle As %Binary, Input As %String) As %Status
{
	;s ^Temp("AddDoFileGridStore")=""
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    q:Input="" $$$OK
    s (AddDoFileGridRowid,AddDoFileGridDesc,AddDoFileGridCode,AddDoFileGridSize,AddDoFileGridType,AddDoFileUrl)=""
    d OutputRow10
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow10
    s Data=$lb(AddDoFileGridRowid,AddDoFileGridDesc,AddDoFileGridCode,AddDoFileGridSize,AddDoFileGridType,AddDoFileUrl)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp
/// date:2015-05-25
/// description: 获取文件信息
/// input:  type+"^"+nodeid+"^"+ip+"^"+recuser+"^"+FileShire+"^"+ret1+"^"+"PMP_Document"+"^"+FileUrl+"^"+AddDoFileGridSize
/// input:  类型     树形节点id ip     接收用户    是否分享    新文件名      操作类型        源文件        文件大小
/// output: 
/// others: d ##Class(web.PMP.Document).AddDocumentFile("","")
ClassMethod AddDocumentFile(InPut As %Text, Menu As %Text) As %String
{
	;s ^Temp("AddDocumentFile")=InPut
	s ret="",NewCode=""
	s Date=+$h,Time=$p($h,",",2)
	s Datenew=$zd(+$h,8)
	s UserId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	s typ=$p(InPut,"^",1)
	s nodeid=$p(InPut,"^",2)
	s ip=$p(InPut,"^",3)
	s recuser=$p(InPut,"^",4)
	s FileShire=$p(InPut,"^",5)
	s ret1=$p(InPut,"^",6)
	s Flag=$p(InPut,"^",7)
	s FileUrl=$p(InPut,"^",8)
	s AddDoFileGridSize=$p(InPut,"^",9)
	s Status=..DocumentStatus()
	s OldeCode=$o(^PMPDocumenti("Code",""),-1)
	i OldeCode[Datenew  s NewCode=OldeCode+1
	i OldeCode'[Datenew s NewCode=Datenew_"0001"
	Ts
	s object=##Class(User.PMPDocument).%New()
	s object.PDMCode=NewCode
	s object.PDMDesc=$p(FileUrl,"\",$l(FileUrl,"\"))
	i recuser'="" s object.PDMReceive="Y"
	i recuser="" s object.PDMReceive="N"
	s object.PDMCreatUser=UserId
	s object.PDMCreatDate=Date
	s object.PDMCreatTime=Time
	s objectStatus=##Class(User.PMPDictionary3).%OpenId(Status)
	s object.PDMStatus=objectStatus
	s object.PDMDownloadsCount=0
	i FileShire="true" s object.PDMShare="Y"
	i FileShire'="true" s object.PDMShare="N"
	s objecttree=##Class(User.PMPDirectoryTree).%OpenId(nodeid)
	s object.PDMContents=objecttree
	s object.PDMSize=AddDoFileGridSize
	s object.PDMType=$p(FileUrl,".",$l(FileUrl,"."))
	s object.PDMFtpName=ret1
	s object.PDMRemark=Menu
	s object.PDMDelete="Y"
	s sc=object.%Save()
	i sc{
		Tc
		s rowid=object.%Id()
		if (recuser'="") {
			f no=1:1:$l(recuser,",")  d
			.s userrowid=$p(recuser,",",no)
			.&sql(insert into sqluser.PMP_DocumentReceive (PDM_ParRef,PDMR_ReceiveUser,PDMR_CreatDate,PDMR_CreatTime,PDMR_CreatUser,PDMR_Type,PDMR_DownloadsType,PDMR_Remark) values (:rowid,:userrowid,:Date,:Time,:UserId,'N','N',:Menu))
			}
		D ##class(DHCPM.Application.PMApply).AdjunctAll(FileUrl,ret1,rowid,"PMP_Document",ip)
		}
    else{
	    Tro
	    }
	 s ret=sc
	 q ret
}

/// Creat  zzp  
/// date:2015-05-25
/// description: 获取文档管理界面新建记录时候状态初始值
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).DocumentStatus()
ClassMethod DocumentStatus() As %String
{
	s ret="209"
	i $d(^PMPSysConfigure("Type","DocumentStatus"))  d
	.s rowid=$o(^PMPSysConfigure("Type","DocumentStatus",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-25
/// description: 修改文件管理下载次数
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).DownloadsCount("")
ClassMethod DownloadsCount(Rowid As %String) As %String
{
	s ret=""
	q:Rowid="" ""
	s UserId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	Ts
	s object=##Class(User.PMPDocument).%OpenId(Rowid)
	s object.PDMDownloadsCount=object.PDMDownloadsCount+1
	s sc=object.%Save()
	i sc{
		Tc
		i $d(^PMPDocumentReceivei("ReceiveUser",Rowid,UserId)) d
		.s sub=Rowid_"||"_$o(^PMPDocumentReceivei("ReceiveUser",Rowid,UserId,""))
		.&sql(Update SQLUser.PMP_DocumentReceive set PDMR_DownloadsType='Y' where PCAM_Rowid=:sub)
		}
    else{
	    Tro
	    }
	s ret=sc
	q ret
}

/// Creat  zzp  
/// date:2015-05-25
/// description: 文档共享
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).PDMShare("","")
ClassMethod PDMShare(Rowid As %String, Type As %String) As %String
{
	s ret=""
	q:(Rowid="")||(Type="") ""
	Ts
	s object=##Class(User.PMPDocument).%OpenId(Rowid)
	i Type="Y" s object.PDMShare="Y"
	i Type="N" s object.PDMShare="N"
	s sc=object.%Save()
	i sc{
		Tc
		}
	else{
		Tro
		}
	s ret=sc
	q ret
}

/// Creat  zzp  
/// date:2015-05-25
/// description: 文件接收操作
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).PDMReceive("")
ClassMethod PDMReceive(Rowid As %String) As %String
{
	s ret=""
	q:Rowid="" ""
	s UserId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	Ts 
	q:'$d(^PMPDocumentReceivei("ReceiveUser",Rowid,UserId))
	s sub=Rowid_"||"_$o(^PMPDocumentReceivei("ReceiveUser",Rowid,UserId,""))
	&sql(Update SQLUser.PMP_DocumentReceive set PDMR_Type='Y' where PCAM_Rowid=:sub)
	i ($G(SQLCODE)="0"){
		Tc
		}
	else{
		Tro
		}
	i $G(SQLCODE)="0" s ret="1"
	i $G(SQLCODE)'="0" s ret=$G(SQLCODE)
	q ret
}

/// / lzt   start********************
/// Creat  lzt
/// date:2015-05-20
/// description: 插入合同数据
/// input:  input
/// output: 1 成功 
/// others:w ##class(web.PMP.Document).ContractAdd("")
ClassMethod ContractAdd(input As %Text) As %String
{
	q:input="" "input"
	s ret=-1
	s Date=+$h,Time=$p($h,",",2)
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	//解析入参******Start
	s actionFlag=$p(input,"^",2)
	s ContractRowid=$p(input,"^",1)
	s ContractMenuCode=$p(input,"^",3)
	s ContractMenuDesc=$p(input,"^",4)
	s ContractMenuGroup=$p(input,"^",5)
	s ContractMenuType=$p(input,"^",6)
	s ContractMenuPrincipal=$p(input,"^",7)
	s ContractMenuContractDate=$p(input,"^",8)
	s ContractMenuContractTime=$p(input,"^",9)
	s ContractMenuEffectiveDate=$p(input,"^",10)
	s ContractMenuEffectiveTime=$p(input,"^",11)
	s ContractMenuStatus=$p(input,"^",12)
	s ContractMenuFirstParty=$p(input,"^",13)
	s ContractMenuFirstUser=$p(input,"^",14)
	s ContractMenuSecondParty=$p(input,"^",15)
	s ContractMenuSecondUser=$p(input,"^",16)
	s ContractMenuThirdParty=$p(input,"^",17)
	s ContractMenuThirdUser=$p(input,"^",18)
	s ContractMenuModeE=$p(input,"^",19)
	s ContractMenuCMode=$p(input,"^",20)
	s ContractMenuSource=$p(input,"^",21)
	s ContractMenuDepartment=$p(input,"^",22)
	s ContractMenuTotalMoney=$p(input,"^",23)
	s ContractMenuCurrency=$p(input,"^",24)
	s ContractMenuFinishDate=$p(input,"^",25)
	s ContractMenuFinishTime=$p(input,"^",26)
	s ContractMenuMenu=$p(input,"^",27)
	s ContractMenuAbnormal=$p(input,"^",28)
	s ContractMenuRemark=$p(input,"^",29)
	s ipAdress=$p(input,"^",30)
	//解析入参******End
	d AddContract   //插入合同数据
	q ret
	;d AddOperatingRecord
AddContract
	Ts
	i actionFlag="Add" s object=##Class(User.PMPContract).%New()
	i (actionFlag="Update")&&(ContractRowid'="") d
	.s object=##Class(User.PMPContract).%OpenId(ContractRowid)
	.s oldValue=object.PCTCode_"@@"_object.PCTDesc_"@@"_object.PCTGroup_"@@"_object.PCTType_"@@"_object.PCTPrincipal
	.s oldValue=oldValue_"@@"_object.PCTDate_"@@"_object.PCTTime_"@@"_object.PCTEffectiveDate_"@@"_object.PCTEffectiveTime
	.s oldValue=oldValue_"@@"_object.PCTStatus_"@@"_object.PCTFirstParty_"@@"_object.PCTFirstUser_"@@"_object.PCTSecondParty
	.s oldValue=oldValue_"@@"_object.PCTSecondUser_"@@"_object.PCTThirdParty_"@@"_object.PCTThirdUser_"@@"_object.PCTModeExecution
	.s oldValue=oldValue_"@@"_object.PCTConcludeMode_"@@"_object.PCTSource_"@@"_object.PCTDepartment_"@@"_object.PCTTotalMoney
	.s oldValue=oldValue_"@@"_object.PCTCurrency_"@@"_object.PCTFinishDate_"@@"_object.PCTFinishTime_"@@"_object.PCTMenu_"@@"_object.PCTAbnormal_"@@"_object.PCTRemark_"@@"_object.PCTStandby1
	
	
	s object.PCTUser=userId
	s object.PCTUpdateUser=userId
	s object.PCTCode=ContractMenuCode
	s object.PCTDesc=ContractMenuDesc
	s objGroup=##Class(User.PMPDictionary3).%OpenId(ContractMenuGroup)
	s object.PCTGroup=objGroup
	s objType=##Class(User.PMPDictionary3).%OpenId(ContractMenuType)
	s object.PCTType=objType
	s:ContractMenuPrincipal'="" object.PCTPrincipal=ContractMenuPrincipal
	s:ContractMenuDepartment'="" object.PCTDepartment=ContractMenuDepartment
    i ContractMenuContractDate'=""  d
    .s object.PCTContractDate=$zdh(ContractMenuContractDate,3)
    e  d
    .s object.PCTContractDate=ContractMenuContractDate
	i ContractMenuContractTime'=""  d
	.s object.PCTContractTime=$zth(ContractMenuContractTime,1)
	e  d
	.s object.PCTContractTime=ContractMenuContractTime
	s object.PCTTotalMoney=ContractMenuTotalMoney
	s objCurrency=##Class(User.PMPDictionary3).%OpenId(ContractMenuCurrency)
	s object.PCTCurrency=objCurrency
	s objModeE=##Class(User.PMPDictionary3).%OpenId(ContractMenuModeE)
	s object.PCTModeExecution=objModeE
	s objCMode=##Class(User.PMPDictionary3).%OpenId(ContractMenuCMode)
	s object.PCTConcludeMode=objCMode
	s objCMode=##Class(User.PMPDictionary3).%OpenId(ContractMenuSource)
	s object.PCTSource=objCMode
	i ContractMenuEffectiveDate'=""  d
	.s object.PCTEffectiveDate=$zdh(ContractMenuEffectiveDate,3)
	e  d
	.s object.PCTEffectiveDate=ContractMenuEffectiveDate
	i ContractMenuEffectiveTime'="" d
	.s object.PCTEffectiveTime=$zth(ContractMenuEffectiveTime,1)
	e  d
	.s object.PCTEffectiveTime=ContractMenuEffectiveTime
	i ContractMenuFinishDate'="" d
	.s object.PCTFinishDate=$zdh(ContractMenuFinishDate,3)
	e  d
	.s object.PCTFinishDate=ContractMenuFinishDate
	i ContractMenuFinishTime'=""  d
	.s object.PCTFinishTime=$zth(ContractMenuFinishTime,1)
	e  d
	.s object.PCTFinishTime=ContractMenuFinishTime
	s objStatus=##Class(User.PMPDictionary3).%OpenId(ContractMenuStatus)
	s object.PCTStatus=objStatus
	s object.PCTMenu=ContractMenuMenu
	s:ContractMenuRemark'="" object.PCTRemark=ContractMenuRemark
	s objFirstParty=##Class(User.PMPCompany).%OpenId(ContractMenuFirstParty)
	s object.PCTFirstParty=objFirstParty
	s:ContractMenuFirstUser'="" object.PCTFirstUser=ContractMenuFirstUser
	s objSecondParty=##Class(User.PMPCompany).%OpenId(ContractMenuSecondParty)
	s object.PCTSecondParty=objSecondParty
	s:ContractMenuSecondUser'="" object.PCTSecondUser=ContractMenuSecondUser
	i ContractMenuThirdParty'="" d 
	.s objThirdParty=##Class(User.PMPCompany).%OpenId(ContractMenuThirdParty)
	.s object.PCTThirdParty=objThirdParty
	s:ContractMenuThirdUser'="" object.PCTThirdUser=ContractMenuThirdUser
	s:ContractMenuAbnormal'="" object.PCTAbnormal=ContractMenuAbnormal
	s object.PCTUpdateDate=Date
	s object.PCTUpdateTime=Time
	s object.PCTDate=Date
	s object.PCTTime=Time
	s object.PCTStandby1="Y"
	s rc=object.%Save()
	if (rc)
	{
		Tc
		s arg1="PMP_Contract@@"_object.%Id()_"@@"_actionFlag_"@@"_ipAdress
		i actionFlag="Add" s arg2=""
		e  s arg2=oldValue
		s arg3=$REPLACE($p($p(input,actionFlag_"^",2),"^"_ipAdress,1),"^","@@")_"@@Y"
		s arg4="PCT_Code@@PCT_Desc@@PCT_Group@@PCT_Type@@PCT_Principal@@PCT_ContractDate@@PCT_ContractTime@@PCT_EffectiveDate"
		s arg4=arg4_"@@PCT_EffectiveTime@@PCT_Status@@PCT_FirstParty@@PCT_FirstUser@@PCT_SecondParty@@PCT_SecondUser@@"
		s arg4=arg4_"PCT_ThirdParty@@PCT_ThirdUser@@PCT_ModeExecution@@PCT_ConcludeMode@@PCT_Source@@PCT_Department@@"
		s arg4=arg4_"PCT_TotalMoney@@PCT_Currency@@PCT_FinishDate@@PCT_FinishTime@@PCT_Menu@@PCT_Abnormal@@PCT_Remark@@PCT_Standby1"
		s result=..PMPOperatingRecord(arg1,arg2,arg3,arg4)
		s ret=result
	}
	else
	{
	  Tro	
	}
	s ret=rc_"!"_ret
	q ret
 /*AddOperatingRecord
	
	s arg1="PMP_Contract@@"_object.%Id()_"@@"_actionFlag_"@@"_ipAdress
	s arg2="",arg3=$REPLACE($p($p(input,actionFlag_"^",2),"^"_ipAdress,1),"^","@@")
	s arg4="PCT_Code@@PCT_Desc@@PCT_Group@@PCT_Type@@PCT_Principal@@PCT_ContractDate@@PCT_ContractTime@@PCT_EffectiveDate"
	s arg4=arg4_"@@PCT_EffectiveTime@@PCT_Status@@PCT_FirstParty@@PCT_FirstUser@@PCT_SecondParty@@PCT_SecondUser@@"
	s arg4=arg4_"PCT_ThirdParty@@PCT_ThirdUser@@PCT_ModeExecution@@PCT_ConcludeMode@@PCT_Source@@PCT_Department@@"
	s arg4=arg4_"PCT_TotalMoney@@PCT_Currency@@PCT_FinishDate@@PCT_FinishTime@@PCT_Menu@@PCT_Abnormal@@PCT_Remark"
	
	b ;123
	s result=..PMPOperatingRecord(arg1,arg2,arg3,arg4)
	
	s ret=1_"!"_result
	q ret*/
}

/// Creat  lzt
/// date:2015-05-21
/// description: 删除合同数据
/// input:  Rowid(合同表rowid)^ip
/// output: 1 成功 
/// others:w ##class(web.PMP.Document).ContractDel("")
ClassMethod ContractDel(input As %Text) As %String
{
	q:input="" "input"
	s ret=-1
	s ContractRowid=$p(input,"^",1)
	s ipAdress=$p(input,"^",2)
	Ts
	s obj=##Class(User.PMPContract).%OpenId(ContractRowid)
	s obj.PCTStandby1="N"
	s ret=obj.%Save()
	i (ret) d
	.Tc
	e  d
	.Tro 
	i ret=1 d AddOperatingRecord
	e  q ret_"! "
	q ret
AddOperatingRecord
	s arg1="PMP_Contract@@"_ContractRowid_"@@Delete@@"_ipAdress
	s arg2="Y",arg3="N",arg4="PCT_Standby1"
	s result=..PMPOperatingRecord(arg1,arg2,arg3,arg4)
	s ret=ret_"!"_result
	q ret
}

/// Creat  lzt
/// date:2015-05-23
/// description: 插入合同关联模块
/// input:  ContractRowid^ContractMode^ipAdress
/// output: 1!1 成功 
/// others:w ##class(web.PMP.Document).AddContractMode("")
ClassMethod AddContractMode(input As %Text) As %String
{
	q:input="" "input!0"
	s ret=-1
	s Date=+$h,Time=$p($h,",",2)
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	;s userId=2488
	s ContractRowid=$p(input,"^",1)
	s ContractMode=$p(input,"^",2)
	s ipAdress=$p(input,"^",3)	
	s isExist=..CheckContractMode(ContractRowid,ContractMode) 
	q:isExist=1 "Exist!0"
	d AddCMode
	i ret=1 d AddRecord
	e  q ret_"! "
	q ret
AddCMode
	Ts
	s object=##Class(User.PMPContractMode).%New()
	s objContract=##Class(User.PMPContract).%OpenId(ContractRowid)
	s object.PCMContractDR=objContract
	i ContractMode'="" d
	.s objMode=##Class(User.PMPModule).%OpenId(ContractMode)
	.S object.PCMModeDR=objMode
	s object.PCMUser=userId
	s object.PCMUpdateUser=userId
	s object.PCMDate=Date
	s object.PCMTime=Time
	s object.PCMUpdateDate=Date
	s object.PCMUpdateTime=Time
	s rc=object.%Save()
	i (rc) d
	.Tc
	.s ret=1
	e  d
	.Tro
	q ret
AddRecord
	s arg1="PMP_ContractMode@@"_object.%Id()_"@@Add@@"_ipAdress
	s arg2="",arg3=$REPLACE($p(input,"^"_ipAdress,1),"^","@@")_"@@"_Date_"@@"_Time_"@@"_userId_"@@"_Date_"@@"_Time_"@@"_userId
	s arg4="PCM_Contract_DR@@PCM_Mode_DR@@PCM_Date@@PCM_Time@@PCM_User@@PCM_UpdateDate@@PCM_UpdateTime@@PCM_UpdateUser"
	s result=..PMPOperatingRecord(arg1,arg2,arg3,arg4)
	s ret=ret_"!"_result
	q ret
}

/// Creat  lzt
/// date:2015-05-23
/// description: 检查合同与模块是否关联
/// input:  ContractRowid^ContractMode
/// output: 1!1 成功  
/// others:w ##class(web.PMP.Document).CheckContractMode("")
ClassMethod CheckContractMode(contractDr As %String, modeDr As %String) As %String
{
	q:modeDr="" ""
	q:contractDr="" ""
	s ret="0"
	s rowid=""
	f  s rowid=$o(^PMPContractModei("MODE",modeDr,rowid))  q:rowid=""  d
	.s contract=$p(^PMPContractMode(rowid),"^",1)
	.i contractDr=contract d
	..s ret=1
	q ret
}

/// Creat  lzt
/// date:2015-05-23
/// description: 更新合同详细数据
/// input:  ContractDetialRowid^actionFlag^Title^subFlag^ContractMenu^ipAdress
/// output: 1!1 成功 
/// others:w ##class(web.PMP.Document).AddContractDetails("")
ClassMethod AddContractDetails(input As %Text) As %String
{
	q:input="" "input!0"
	s ^lzt("0523")=input
	s ret=-1
	s Date=+$h,Time=$p($h,",",2)
	s userId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(userId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s userId=userId_"||"_##Class(web.PMP.Document).ConvertUser(userId,"")
	;s userId=2488
	s ContractDetialRowid=$p(input,"^",1)
	s ContractRowid=$p(ContractDetialRowid,"||",1)
	s subRowid=$p(ContractDetialRowid,"||",2)
	s actionFlag=$p(input,"^",2)
	s Title=$p(input,"^",3)
	s subFlag=$p(input,"^",4)
	s ContractMenu=$p(input,"^",5)
	s ipAdress=$p(input,"^",6)	
	s level=..GetDetailsLevel(ContractDetialRowid)
	i subRowid="id" s ContractDetialRowid=""
	d AddDetial
	i ret=1 d AddDetailRecord
	q ret
AddDetial
	Ts
	i actionFlag="Add" d
	.&sql(insert INTO sqluser.PMP_ContractDetails (PCT_ParRef,PCTD_Title,PCTD_Level,PCTD_FatherLevel,PCTD_Menu,PCTD_Remark,PCTD_Date,PCTD_Time,PCTD_User,PCTD_UpdateDate,PCTD_UpdateTime,PCTD_UpdateUser) 
			values (:ContractRowid,:Title,:level,:ContractDetialRowid,:ContractMenu,"",:Date,:Time,:userId,:Date,:Time,:userId))
	.s:SQLCODE=0 rc=1
	i actionFlag="Update" d
	.s object=##Class(User.PMPContractDetails).%OpenId(ContractDetialRowid)
	.s oldTitle=object.PCTDTitle
	.s object.PCTDTitle=Title
	.s oldContractMenu=object.PCTDMenu
	.s object.PCTDMenu=ContractMenu
	.s object.PCTDUpdateUser=userId
	.s object.PCTDUpdateDate=Date
	.s object.PCTDUpdateTime=Time
	.s rc=object.%Save()
	i (rc) d
	.Tc
	.s ret=1
	e  d
	.Tro
	q ret
AddDetailRecord
	
	i actionFlag="Update" d
	.s arg1="PMP_ContractDetails@@"_object.%Id()_"@@"_actionFlag_"@@"_ipAdress
	.s arg2=oldTitle_"@@"_oldContractMenu
	.s arg3=Title_"@@"_ContractMenu
	.s arg4="PCTD_Title@@PCTD_Menu"
	i actionFlag="Add" d
	.s arg1="PMP_ContractDetails@@"_%ROWID_"@@"_actionFlag_"@@"_ipAdress
	.s arg2=""
	.s arg3=ContractRowid_"@@"_Title_"@@"_level_"@@"_ContractDetialRowid_"@@"_ContractMenu_"@@"_Date
	.s arg3=arg3_"@@"_Time_"@@"_userId_"@@"_Date_"@@"_Time_"@@"_userId
	.s arg4="PCTD_PCTRowid@@PCTD_Title@@PCTD_Level@@PCTD_FatherLevel@@PCTD_Menu@@PCTD_Date@@PCTD_Time"
	.s arg4=arg4_"@@PCTD_User@@PCTD_UpdateDate@@PCTD_UpdateTime@@PCTD_UpdateUser"
	s result=..PMPOperatingRecord(arg1,arg2,arg3,arg4)
	s ret=ret_"!"_result
	q ret
}

/// Creat  lzt
/// date:2015-05-23
/// description: 获取标题下一级别
/// input:  ContractDetailRowid
/// output: level 
/// others:w ##class(web.PMP.Document).GetDetailsLevel("")
ClassMethod GetDetailsLevel(Rowid As %String) As %Text
{
	s retret=""
	q:Rowid="" retret
	i ($p(Rowid,"||",2)="id") d
	.s retret=$o(^PMPDictionary("flagdesc","Level",1,""))
	e  d
	.s levelRowid=$p(^PMPContractDetails(+Rowid,$p(Rowid,"||",2)),"^",3)
	.s lel=$p(^PMPDictionary(levelRowid),"^",2)
	.i (lel<4) d
	..s lel=lel+1     //最小级别为4时
	..b ;1
	..s retret=$o(^PMPDictionary("flagdesc","Level",lel,retret))
	.e  d
	..s retret = "min"
	q retret
}

///  / lzt   end*********************
/// Creat  cyber
/// date:2015-05-21
/// description: 公司数据插入和更新
/// input:  Input As %Text(CompanyGridRowid^CompanyGridCode^CompanyGridDesc^CompanyGridAddress^CompanyGridPhone^CompanyGridWebsite^CompanyGridEmail^CompanyGridLawPerson^CompanyGridType^CompanyGridListing^CompanyGridPhone1^CompanyGridPhone2^CompanyGridPostCdoe^CompanyGridEmail1^CompanyGridEmail2^CompanyGridFlag^CompanyGridRemark^CompanyGridCreatUser^CompanyGridCreatDate^CompanyGridCreatTime)
/// input:  As %Text
/// output: String  
/// others:  
/// w ##class(web.PMP.Document).CompanyAddUpdate("1^^^^^^^^"股份制"^"其他"^^^^^^","Delete")
ClassMethod CompanyAddUpdate(Input As %Text, OptionFlag As %Text, ip As %String) As %String
{
	s ret=""
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	s UpdateDate=+$h,UpdateTime=$p($h,",",2)	
	q:Input="" "-1"
	s CompanyGridCreatUser=UserId
	s CompanyGridCreatDate=UpdateDate
	s CompanyGridCreatTime=UpdateTime 	
	s CompanyGridRowid=$p(Input,"@@",1)
	i OptionFlag="Delete" d
	.s CompanyGridFlag="N" 
	e  d	
	.s CompanyGridFlag="Y" 
	.s CompanyGridCode=$p(Input,"@@",2)
	.s CompanyGridDesc=$p(Input,"@@",3)
	.s CompanyGridAddress=$p(Input,"@@",4)
	.s CompanyGridPhone=$p(Input,"@@",5)
	.s CompanyGridWebsite=$p(Input,"@@",6)
	.s CompanyGridEmail=$p(Input,"@@",7)
	.s CompanyGridLawPerson=$p(Input,"@@",8)
	.s CompanyGridType=$p(Input,"@@",9)	
	.s CompanyGridListing=$p(Input,"@@",10)
	.s CompanyGridPhone1=$p(Input,"@@",11)
	.s CompanyGridPhone2=$p(Input,"@@",12)
	.s CompanyGridPostCdoe=$p(Input,"@@",13)
	.s CompanyGridEmail1=$p(Input,"@@",14)
	.s CompanyGridEmail2=$p(Input,"@@",15)
	.s CompanyGridRemark=$p(Input,"@@",16)
	i OptionFlag'="Add" s TabMessage="PMP_Company"_"@@"_CompanyGridRowid_"@@"_OptionFlag_"@@"_ip
	i OptionFlag="Delete" s (OldValue,NewValue,TabFieldName)=""
	i OptionFlag="Add"  d
	.s OldValue=""
	.s NewValue=UserId_"@@"_UpdateDate_"@@"_UpdateTime_"@@"_UserId_"@@"_UpdateDate_"@@"_UpdateTime_"@@"_CompanyGridFlag,TabFieldName="PC_CreatUser"_"@@"_"PC_CreatDate"_"@@"_"PC_CreatTime"_"@@"_"PC_UpdateUser"_"@@"_"PC_UpdateDate"_"@@"_"PC_UpdateTime"_"@@"_"PC_Flag"
	.i CompanyGridCode'="" s NewValue=NewValue_"@@"_CompanyGridCode,TabFieldName=TabFieldName_"@@"_"PC_Code"
	.i CompanyGridDesc'="" s NewValue=NewValue_"@@"_CompanyGridDesc,TabFieldName=TabFieldName_"@@"_"PC_Desc"
	.i CompanyGridAddress'="" s NewValue=NewValue_"@@"_CompanyGridAddress,TabFieldName=TabFieldName_"@@"_"PC_Address"
	.i CompanyGridPhone'="" s NewValue=NewValue_"@@"_CompanyGridPhone,TabFieldName=TabFieldName_"@@"_"PC_Phone"
	.i CompanyGridWebsite'="" s NewValue=NewValue_"@@"_CompanyGridWebsite,TabFieldName=TabFieldName_"@@"_"PC_Website"
	.i CompanyGridEmail'="" s NewValue=NewValue_"@@"_CompanyGridEmail,TabFieldName=TabFieldName_"@@"_"PC_Emeail"
	.i CompanyGridLawPerson'="" s NewValue=NewValue_"@@"_CompanyGridLawPerson,TabFieldName=TabFieldName_"@@"_"PC_LawPerson"
	.i CompanyGridType'="" s NewValue=NewValue_"@@"_CompanyGridType,TabFieldName=TabFieldName_"@@"_"PC_Type"
	.i CompanyGridListing'="" s NewValue=NewValue_"@@"_CompanyGridListing,TabFieldName=TabFieldName_"@@"_"PC_Listing"
	.i CompanyGridPhone1'="" s NewValue=NewValue_"@@"_CompanyGridPhone1,TabFieldName=TabFieldName_"@@"_"PC_Phone1"
	.i CompanyGridPhone2'="" s NewValue=NewValue_"@@"_CompanyGridPhone2,TabFieldName=TabFieldName_"@@"_"PC_Phone2"
	.i CompanyGridPostCdoe'="" s NewValue=NewValue_"@@"_CompanyGridPostCdoe,TabFieldName=TabFieldName_"@@"_"PC_PostCdoe"
	.i CompanyGridEmail1'="" s NewValue=NewValue_"@@"_CompanyGridEmail1,TabFieldName=TabFieldName_"@@"_"PC_Emeail1"
	.i CompanyGridEmail2'="" s NewValue=NewValue_"@@"_CompanyGridEmail2,TabFieldName=TabFieldName_"@@"_"PC_Emeail2"
	.i CompanyGridRemark'="" s NewValue=NewValue_"@@"_CompanyGridRemark,TabFieldName=TabFieldName_"@@"_"PC_Remark"
	i OptionFlag="Update"  d
	.s NewValue=UserId_"@@"_UpdateDate_"@@"_UpdateTime,TabFieldName="PC_UpdateUser"_"@@"_"PC_UpdateDate"_"@@"_"PC_UpdateTime"
	d AddUpdateComp
	q ret
AddUpdateComp
    Ts
    s object=""
    S objectuser=UserId
	i OptionFlag="Add" d
	.s object=##Class(User.PMPCompany).%New() 
	.s object.PCCreatUser=objectuser
	.s object.PCCreatDate=CompanyGridCreatDate
	.s object.PCCreatTime=CompanyGridCreatTime
	e  d
	.s object=##Class(User.PMPCompany).%OpenId(CompanyGridRowid)
	.i OptionFlag="Update"  d
	..s OldValue=object.PCCreatUser_"@@"_object.PCCreatDate_"@@"_object.PCCreatTime
	..i object.PCCode'=CompanyGridCode s OldValue=OldValue_"@@"_object.PCCode,NewValue=NewValue_"@@"_CompanyGridCode,TabFieldName=TabFieldName_"@@"_"PC_Code"
	..i object.PCDesc'=CompanyGridDesc s OldValue=OldValue_"@@"_object.PCDesc,NewValue=NewValue_"@@"_CompanyGridDesc,TabFieldName=TabFieldName_"@@"_"PC_Desc"
	..i object.PCAddress'=CompanyGridAddress s OldValue=OldValue_"@@"_object.PCAddress,NewValue=NewValue_"@@"_CompanyGridAddress,TabFieldName=TabFieldName_"@@"_"PC_Address"
	..i object.PCPhone'=CompanyGridPhone s OldValue=OldValue_"@@"_object.PCPhone,NewValue=NewValue_"@@"_CompanyGridPhone,TabFieldName=TabFieldName_"@@"_"PC_Phone"
	..i object.PCWebsite'=CompanyGridWebsite s OldValue=OldValue_"@@"_object.PCWebsite,NewValue=NewValue_"@@"_CompanyGridWebsite,TabFieldName=TabFieldName_"@@"_"PC_Website"
	..i object.PCEmeail'=CompanyGridEmail s OldValue=OldValue_"@@"_object.PCEmeail,NewValue=NewValue_"@@"_CompanyGridEmail,TabFieldName=TabFieldName_"@@"_"PC_Emeail"
	..i object.PCLawPerson'=CompanyGridLawPerson s OldValue=OldValue_"@@"_object.PCLawPerson,NewValue=NewValue_"@@"_CompanyGridLawPerson,TabFieldName=TabFieldName_"@@"_"PC_LawPerson"
	..i object.PCType'=CompanyGridType s OldValue=OldValue_"@@"_object.PCType,NewValue=NewValue_"@@"_CompanyGridType,TabFieldName=TabFieldName_"@@"_"PC_Type"
	..i object.PCListing'=CompanyGridListing s OldValue=OldValue_"@@"_object.PCListing,NewValue=NewValue_"@@"_CompanyGridListing,TabFieldName=TabFieldName_"@@"_"PC_Listing"
	..i object.PCPhone1'=CompanyGridPhone1 s OldValue=OldValue_"@@"_object.PCPhone1,NewValue=NewValue_"@@"_CompanyGridPhone1,TabFieldName=TabFieldName_"@@"_"PC_Phone1"
	..i object.PCPhone2'=CompanyGridPhone2 s OldValue=OldValue_"@@"_object.PCPhone2,NewValue=NewValue_"@@"_CompanyGridPhone2,TabFieldName=TabFieldName_"@@"_"PC_Phone2"
	..i object.PCPostCdoe'=CompanyGridPostCdoe s OldValue=OldValue_"@@"_object.PCPostCdoe,NewValue=NewValue_"@@"_CompanyGridPostCdoe,TabFieldName=TabFieldName_"@@"_"PC_PostCdoe"
	..i object.PCEmeail1'=CompanyGridEmail1 s OldValue=OldValue_"@@"_object.PCEmeail1,NewValue=NewValue_"@@"_CompanyGridEmail1,TabFieldName=TabFieldName_"@@"_"PC_Emeail1"
	..i object.PCEmeail2'=CompanyGridEmail2 s OldValue=OldValue_"@@"_object.PCEmeail2,NewValue=NewValue_"@@"_CompanyGridEmail2,TabFieldName=TabFieldName_"@@"_"PC_Emeail2"
	..i object.PCRemark'=CompanyGridRemark s OldValue=OldValue_"@@"_object.PCRemark,NewValue=NewValue_"@@"_CompanyGridRemark,TabFieldName=TabFieldName_"@@"_"PC_Remark"
	s object.PCFlag=CompanyGridFlag
	s object.PCUpdateUser=objectuser
	s object.PCUpdateDate=CompanyGridCreatDate
	s object.PCUpdateTime=CompanyGridCreatTime
	
	i OptionFlag'="Delete" d
	.s object.PCCode=CompanyGridCode
	.s object.PCDesc=CompanyGridDesc
	.s object.PCAddress=CompanyGridAddress
	.s object.PCPhone=CompanyGridPhone
	.s object.PCWebsite=CompanyGridWebsite
	.s object.PCEmeail=CompanyGridEmail
	.s object.PCLawPerson=CompanyGridLawPerson
	.i CompanyGridType'="" d
	..s object.PCType=##Class(User.PMPDictionary3).%OpenId(CompanyGridType)
	.i CompanyGridListing'="" d
	..s object.PCListing=CompanyGridListing	
	.s object.PCPhone1=CompanyGridPhone1
	.s object.PCPhone2=CompanyGridPhone2
	.s object.PCPostCdoe=CompanyGridPostCdoe
	.s object.PCEmeail1=CompanyGridEmail1
	.s object.PCEmeail2=CompanyGridEmail2
	.s object.PCRemark=CompanyGridRemark

	s rc=object.%Save()
	if (rc)
	{
		Tc
		i OptionFlag="Add" s TabMessage="PMP_Company"_"@@"_object.%Id()_"@@"_OptionFlag_"@@"_ip
		s ss=..PMPOperatingRecord(TabMessage,OldValue,NewValue,TabFieldName)
	}
	else
	{
	  	Tro	
	}
	s ret=rc
	q ret
}

/// Creat  cyber
/// date:2015-05-23
/// description: 产品数据插入和更新
/// input:  Input As %Text(ProductGridRowid^ProductGridCode^ProductGridDesc^ProductGridAddress^ProductGridPhone^ProductGridWebsite^ProductGridEmail^ProductGridLawPerson^ProductGridType^ProductGridListing^ProductGridPhone1^ProductGridPhone2^ProductGridPostCdoe^ProductGridEmail1^ProductGridEmail2^ProductGridFlag^ProductGridRemark^ProductGridCreatUser^ProductGridCreatDate^ProductGridCreatTime)
/// input:  As %Text
/// output: String  
/// others:  
/// w ##class(web.PMP.Document).ProductAddUpdate("5@@@@@@@@@@@@@@@@股份制@@其他@@@@@@@@@@@@","Delete")
ClassMethod ProductAddUpdate(Input As %Text, OptionFlag As %Text) As %String
{
	s ret=""
	s UserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(UserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s UserId=UserId_"||"_##Class(web.PMP.Document).ConvertUser(UserId,"")
	s UpdateDate=+$h,UpdateTime=$p($h,",",2)
	s ^CacheTemp("ProAddUpdate",0,$zt($p($h,",",2)))=Input_"^"_OptionFlag	
	q:Input="" "-1"
	s ProductGridCreatUser=UserId
	s ProductGridCreatDate=UpdateDate
	s ProductGridCreatTime=UpdateTime
	s ProductGridRowid=$p(Input,"@@",1)
	
	i OptionFlag="Delete" d
	.s ProductGridFlag="N" 
	e  d
	.s ProductGridFlag="Y"
	.s ProductGridCode=$p(Input,"@@",2)
	.s ProductGridDesc=$p(Input,"@@",3)
	.s ProductGridType=$p(Input,"@@",4)
	.;s ProductGridType=$o(^PMPDictionary("flagdesc","ProductType",ProductGridType,""))
	.s ProductGridVersions=$p(Input,"@@",5)
	.s ProductGridStandard=$p(Input,"@@",6)
	.s ProductGridSupplier=$p(Input,"@@",7)
	.s ProductGridProducer=$p(Input,"@@",8)
	.s ProductGridCount=$p(Input,"@@",9)
	.s ProductGridUnit=$p(Input,"@@",10)
	.;s ProductGridUnit=$o(^PMPDictionary("flagdesc","Unit",ProductGridUnit,""))
	.s ProductGridPrice=$p(Input,"@@",11)
	.s ProductGridTotalPrice=$p(Input,"@@",12)
	.s ProductGridPData=$p(Input,"@@",13)
	.i ProductGridPData'="" d  s ProductGridPData=$zdh(ProductGridPData,3)
	.s ProductGridPTime=$p(Input,"@@",14)
	.i ProductGridPTime'="" d  s ProductGridPTime=$zth(ProductGridPTime,3)
	.s ProductGridPUser=$p(Input,"@@",15)
	.s ProductGridGData=$p(Input,"@@",16)
	.i ProductGridGData'="" d  s ProductGridGData=$zdh(ProductGridGData,3)
	.s ProductGridGTime=$p(Input,"@@",17)
	.i ProductGridGTime'="" d  s ProductGridGTime=$zth(ProductGridGTime,3)
	.s ProductGridUser=$p(Input,"@@",18)
	.s ProductGridRemark=$p(Input,"@@",19)

	;s ^CacheTemp("ProAddUpdate",1,$zt($p($h,",",2)))=ProductGridPUser_"^"_ProductGridType_"^"_ProductGridUnit_"^"_ProductGridSupplier_"^"_ProductGridProducer
	d AddUpdateProd
	q ret
	
AddUpdateProd
    Ts
    ;s OptionFlag="Add"
    s object=""
	i OptionFlag="Add" d
	.s object=##Class(User.PMPProduct).%New() 
	.s object.PPDDate=UpdateDate
	.s object.PPDTime=UpdateTime
	.s object.PPDUser=UserId
	e  d
	.s object=##Class(User.PMPProduct).%OpenId(ProductGridRowid)
	
	s object.PPDStandby1=ProductGridFlag
	s object.PPDUpdateDate=ProductGridCreatDate
	s object.PPDUpdateTime=ProductGridCreatTime
	s object.PPDUpdateUser=UserId
	
	i OptionFlag'="Delete"  d
	.s object.PPDCode=ProductGridCode
	.s object.PPDDesc=ProductGridDesc
	.i ProductGridType'="" d
	..s object.PPDType=##Class(User.PMPDictionary3).%OpenId(ProductGridType)
	.s object.PPDVersions=ProductGridVersions
	.s object.PPDStandard=ProductGridStandard
	.i ProductGridSupplier'="" d
	..s object.PPDSupplierDR=##Class(User.PMPCompany).%OpenId(ProductGridSupplier)
	.i ProductGridProducer'="" d
	..s object.PPDProducerDR=##Class(User.PMPCompany).%OpenId(ProductGridProducer)
	.s object.PPDCount=ProductGridCount
	.i ProductGridUnit'="" d
	..s object.PPDUnit=##Class(User.PMPDictionary3).%OpenId(ProductGridUnit)
	.s object.PPDPrice=ProductGridPrice
	.s object.PPDTotalPrice=ProductGridTotalPrice
	.s object.PPDPurchaseData=ProductGridPData
	.s object.PPDPurchaseTime=ProductGridPTime
	.i ProductGridPUser'=""  d
	..s object.PPDPurchaseUser=ProductGridPUser
	.s object.PPDGoodsData=ProductGridGData
	.s object.PPDGoodsTime=ProductGridGTime
	.i ProductGridUser'=""  d
	..s object.PPDGoodsUser=ProductGridUser
	.s object.PPDRemark=ProductGridRemark

	s rc=object.%Save()
	if (rc)
	{
		Tc
	}
	else
	{
	  	Tro	
	}
	s ret=rc_"^"_object.%Id()
	q ret
}

/// -----------------------------------------
/// Creat  zzp
/// date:2015-05-15
/// description: 获取公司详细数据
/// input:  type() 
/// output: String "CompanyGridRowid^CompanyGridCode^CompanyGridDesc^CompanyGridAddress^CompanyGridPhone^CompanyGridWebsite^CompanyGridEmail^CompanyGridLawPerson^CompanyGridType^CompanyGridListing^CompanyGridPhone1^CompanyGridPhone2^CompanyGridPostCdoe^CompanyGridEmail1^CompanyGridEmail2^CompanyGridFlag^CompanyGridRemark^CompanyGridCreatUser^CompanyGridCreatDate^CompanyGridCreatTime"
/// others:  cyber 在原有方法基础上，增加InPut的细化过滤。
/// 2015-05-24 新增input过滤
/// InPut1=CompanyTCode+"^"+CompanyTDesc+"^"+CompanyTAddress+"^"+CompanyTTel;
ClassMethod CompanyGridStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("CompanyGridStore",0)=InPut
 ;i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")  
 s TCode=$p(InPut,"^",1)
 s TDesc=$p(InPut,"^",2)
 s TAddress=$p(InPut,"^",3)
 s TTel=$p(InPut,"^",4)
 s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s id=0
 f  s id=$o(^PMPCompany(id)) q:id=""  d
 .s (CompanyGridRowid,CompanyGridCode,CompanyGridDesc,CompanyGridAddress,CompanyGridPhone,CompanyGridWebsite,CompanyGridEmail,CompanyGridLawPerson,CompanyGridType,CompanyGridListing,CompanyGridPhone1,CompanyGridPhone2,CompanyGridPostCdoe,CompanyGridEmail1,CompanyGridEmail2,CompanyGridFlag,CompanyGridRemark,CompanyGridCreatUser,CompanyGridCreatDate,CompanyGridCreatTime,CompanyGridTypeid,CompanyGridListingid)=""
 .s CompanyGridCode=$p($G(^PMPCompany(id)),"^",1)
 .q:CompanyGridCode=""
 .s CompanyGridRowid=id
 .s CompanyGridDesc=$p($G(^PMPCompany(id)),"^",2)
 .s CompanyGridAddress=$p($G(^PMPCompany(id)),"^",3)
 .s CompanyGridPhone=$p($G(^PMPCompany(id)),"^",4)
 .s CompanyGridWebsite=$p($G(^PMPCompany(id)),"^",7)
 .s CompanyGridEmail=$p($G(^PMPCompany(id)),"^",12)
 .s CompanyGridLawPerson=$p($G(^PMPCompany(id)),"^",9)
 .s CompanyGridTypeid=$p($G(^PMPCompany(id)),"^",10)
 .i CompanyGridTypeid'="" s CompanyGridType=$p(^PMPDictionary(CompanyGridTypeid),"^",2)
 .s CompanyGridListingid=$p($G(^PMPCompany(id)),"^",11)
 .i CompanyGridListingid'="" d
 ..s CompanyGridListing=$select(CompanyGridListingid="Y":"已上市",CompanyGridListingid="N":"未上市",CompanyGridListingid="Other":"其他")
 .s CompanyGridPhone1=$p($G(^PMPCompany(id)),"^",5)
 .s CompanyGridPhone2=$p($G(^PMPCompany(id)),"^",6)
 .s CompanyGridPostCdoe=$p($G(^PMPCompany(id)),"^",8)
 .s CompanyGridEmail1=$p($G(^PMPCompany(id)),"^",13)
 .s CompanyGridEmail2=$p($G(^PMPCompany(id)),"^",14)
 .s CompanyGridFlagid=$p($G(^PMPCompany(id)),"^",30)
 .q:CompanyGridFlagid'="Y"
 .i CompanyGridFlagid'="" d
 ..s CompanyGridFlag=$select(CompanyGridFlagid="Y":"有效",CompanyGridFlagid="N":"无效",CompanyGridFlagid="":"无效")
 .s CompanyGridRemark=$p($G(^PMPCompany(id)),"^",31)
 .s CompanyGridCreatUserid=$p($G(^PMPCompany(id)),"^",15)
 .i CompanyGridCreatUserid'="" s CompanyGridCreatUser=##Class(web.PMP.Document).SSUSER(CompanyGridCreatUserid)
 .i IndependentUserRet'="Y" s CompanyGridCreatUserid=+CompanyGridCreatUserid
 .S CompanyGridCreatDate=$p($G(^PMPCompany(id)),"^",16)
 .i CompanyGridCreatDate'="" s CompanyGridCreatDate=$zd(CompanyGridCreatDate,3)
 .s CompanyGridCreatTime=$p($G(^PMPCompany(id)),"^",17)
 .i CompanyGridCreatTime'="" s CompanyGridCreatTime=$zt(CompanyGridCreatTime)
 .q:(TCode'="")&(CompanyGridCode'[TCode)
 .q:(TDesc'="")&(CompanyGridDesc'[TDesc)
 .q:(TAddress'="")&(CompanyGridAddress'[TAddress)
 .q:(TTel'="")&(CompanyGridPhone'[TTel)&(CompanyGridPhone1'[TTel)&(CompanyGridPhone2'[TTel)
 
 .;s namedesc=##Class(web.DHCINSUPort).GetCNCODE(desc,4,"")_desc
 .;q:(InPut'="")&(namedesc'[InPut)
 .s i=i+1
 .s tmp=CompanyGridRowid_"^"_CompanyGridCode_"^"_CompanyGridDesc_"^"_CompanyGridAddress_"^"_CompanyGridPhone_"^"_CompanyGridWebsite_"^"_CompanyGridEmail_"^"_CompanyGridLawPerson_"^"_CompanyGridType_"^"_CompanyGridListing_"^"_CompanyGridPhone1_"^"_CompanyGridPhone2_"^"_CompanyGridPostCdoe_"^"_CompanyGridEmail1_"^"_CompanyGridEmail2_"^"_CompanyGridFlag_"^"_CompanyGridRemark_"^"_CompanyGridCreatUser_"^"_CompanyGridCreatDate_"^"_CompanyGridCreatTime_"^"_CompanyGridTypeid_"^"_CompanyGridListingid
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("CompanyGridRowid^CompanyGridCode^CompanyGridDesc^CompanyGridAddress^CompanyGridPhone^CompanyGridWebsite^CompanyGridEmail^CompanyGridLawPerson^CompanyGridType^CompanyGridListing^CompanyGridPhone1^CompanyGridPhone2^CompanyGridPostCdoe^CompanyGridEmail1^CompanyGridEmail2^CompanyGridFlag^CompanyGridRemark^CompanyGridCreatUser^CompanyGridCreatDate^CompanyGridCreatTime^CompanyGridTypeid^CompanyGridListingid",i)
 k json
 q resultString
}

/// Creat  zzp  
/// date:2015-05-25
/// description: 获取HIS版本配置，默认为7.1
/// input:  
/// output: 1:高版本；0:低版本  默认1
/// others: w ##class(web.PMP.Document).HisVersions()
ClassMethod HisVersions() As %String
{
	s ret="1",Versions=""
	i $d(^PMPSysConfigure("Type","HisVersions"))  d
	.s rowid=$o(^PMPSysConfigure("Type","HisVersions",""))
	.s Versions=$p(^PMPSysConfigure(0,rowid),"^",2)
	i Versions="6.8" s ret="0"
	i Versions="6.9" s ret="0"
	i Versions="7.0" s ret="0"
	i Versions="7.1" s ret="0"
	i Versions="7.1.1" s ret="1"
	i Versions="8.0" s ret="1"
	i Versions="8.1" s ret="1"
	q ret
}

/// Creat  zzp  
/// date:2015-05-25
/// description: 判断用户是否有效
/// input:  用户id或者名称
/// output: 1:有效；0:无效
/// others: w ##class(web.PMP.Document).UserEfficacious(111111111111111)
ClassMethod UserEfficacious(User As %String) As %String
{
	s ret="0"
	i User="" s ret="1"
	i (User'="")&(User<1)  d  //判断是否非数字
	.i $d(^SSU("SSUSR",0,"SSUSR_Name",User)) s ret="1"
	i User>0  d
	.i $d(^SSU("SSUSR",User)) s ret="1"
	q ret
}

/// Creat  zzp  
/// date:2015-05-24
/// description: 获取需求添加处理记录时候的记录类型
/// input:  
/// output: String 
/// others: w ##class(web.PMP.Document).ProcessLoggning()
ClassMethod ProcessLoggning() As %String
{
	s ret="212"
	i $d(^PMPSysConfigure("Type","ProcessLoggning"))  d
	.s rowid=$o(^PMPSysConfigure("Type","ProcessLoggning",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-24
/// description: 获取需求的模块信息、开发信息，预计时间
/// input:  
/// output: String 
/// others: w ##class(web.PMP.Document).ImplMode("20")
ClassMethod ImplMode(Rowid As %String) As %String
{
	s ret=""
	q:Rowid="" ""
	s modeid=$p(^PMPImprovementList(Rowid),"^",23)
	B ;1
	i modeid'="" s modeid=$p(^PMPModule(modeid),"^",2)
	s IPMLDevelopUser=$p(^PMPImprovementList(Rowid),"^",17)
	s PredictTime=$p(^PMPImprovementList(Rowid),"^",24)
	s ret=modeid_"^"_IPMLDevelopUser_"^"_PredictTime
	q ret
}

/// Creat  zzp
/// date:2015-05-25
/// description: 获取目录树类型
/// input:  type()
/// output: String RowId,Description
/// others:w ##class(web.PMP.Document).DirTreeStore()
ClassMethod DirTreeStore(InPut As %Text)
{
 s i=0 
 ;s ^CacheTemp("DirTreeStore")=InPut
 i InPut'="" s InPut=$$ALPHAUP^SSUTIL4(InPut)
 i InPut'="" S InPut=$tr(InPut," ","")
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s RowId=""
 f  s RowId=$o(^PMPDictionary("FLAG","TreeType",RowId)) q:RowId=""  d
 .s Description=$p($G(^PMPDictionary(RowId)),"^",2)
 .q:Description=""
 .q:$p($G(^PMPDictionary(RowId)),"^",5)="N"
 .;s namedesc=##Class(web.DHCINSUPort).GetCNCODE(Description,4,"")_"|"_Description
 .s i=i+1
 .s tmp=RowId_"^"_Description
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// Creat  zhangsong
/// date:2015-05-23
/// description: 插入任务计划
/// input:4^Add^CS00001^测试插入数据^2015-05-24^00:00:00^2015-05-25^00:00:00^2015-05-26^00:00:00^2015-05-27^00:00:00^204^4^12^1^2^2^7^测试内容^备注信息
/// input desc:var inputStr=PPPMenuRowid+"^"+PPPMenuFlag+"^"+PPPMenuCode+"^"+PPPMenuDesc+"^"+PPPMenuPlanStartDate+"^"+PPPMenuPlanStartTime+"^"+PPPMenuStartDate
/// input desc:inputStr=inputStr+"^"+PPPMenuStartTime+"^"+PPPMenuPlanEndDate+"^"+PPPMenuPlanEndTime+"^"+PPPMenuEndDate+"^"+PPPMenuEndTime+"^"+PPPMenuStatus
/// input desc:inputStr=inputStr+"^"+PPPMenuImpro+"^"+PPPMenuJob+"^"+PPPMenuContractAging+"^"+PPPMenuMode+"^"+PPPMenuContract+"^"+PPPMenuUser
/// input desc:inputStr=inputStr+"^"+PPPMenuMenu+"^"+PPPMenuRemark
/// output: 1 成功 
/// others:w ##class(web.PMP.Document).PerformancePlanFun("4^Add^CS00001^测试插入数据^2015-05-24^00:00:00^2015-05-25^00:00:00^2015-05-26^00:00:00^2015-05-27^00:00:00^204^4^12^1^2^2^7^测试内容^备注信息")
/// others:w ##class(web.PMP.Document).PerformancePlanFun("11^Update^CS00001^测试更新程序^2015-05-24^00:00:00^2015-05-25^00:00:00^2015-05-26^00:00:00^2015-05-27^00:00:00^运行^测试2^项目管理^1^新农合^北京地坛医院信息化合同二^^测试修改^aaaaaaaa")
ClassMethod PerformancePlanFun(input As %Text) As %String
{
	q:input="" "input"
	s ret=-1
	s NowDate=+$h,NowTime=$p($h,",",2)
	;s ^Tmp("PerformancePlanAdd",$j)=input	   
	s CreateUserID=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(CreateUserID)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s CreateUserID=CreateUserID_"||"_##Class(web.PMP.Document).ConvertUser(CreateUserID,"")
	;s CreateUserID="1"
	
	s ProjectPlanCode=$P(input,"^",3)
	s ProjectPlanDesc=$P(input,"^",4)
	s ProjectPlanType=$P(input,"^",1)
	s ProjectPlanMenu=$P(input,"^",20)
	s ProjectPlanStartDate=..RDate($P(input,"^",5))
	
	s ProjectPlanStartTime=..RTime($P(input,"^",6))
	s ProjectPlanEndDate=..RDate($P(input,"^",7))
	s ProjectPlanEndTime=..RTime($P(input,"^",8))
	s ProjectPlanRealityStartDate=..RDate($P(input,"^",9))
	s ProjectPlanRealityStartTime=..RTime($P(input,"^",10))
	
	s ProjectPlanRealityEndDate=..RDate($P(input,"^",11))
	s ProjectPlanRealityEndTime=..RTime($P(input,"^",12))
	s ProjectPlanStatus=$P(input,"^",13)
	s ResponsibilityUserID=$P(input,"^",19)
	i ResponsibilityUserID'="" d  s ProjectPlanResponsibility="Y"
	e  d  s ProjectPlanResponsibility="N"	
	s ProjectPlanRemark=$P(input,"^",21)

	s ProjectPlanCreatDate=NowDate
	s ProjectPlanCreatTime=NowTime
	s ProjectPlanCreatUser=CreateUserID
	s ProjectPlanUpdateDate=NowDate
	s ProjectPlanUpdateTime=NowTime
	
	s ProjectUpdateUser=CreateUserID
	s PlanImprovmentDR=$P(input,"^",14)		;关联需求
	s PlanJobLoggDR=$P(input,"^",15)		;关联工作记录
	s PlanModuleDR=$P(input,"^",17)			;关联模块
	s PlanContractAgingDR=$P(input,"^",16)	;关联工期
	
	s PlanContractDR=$P(input,"^",18)		;关联合同
	s PlanAdjuc="N"							;附件标志
	s ProjectPlanRowID=$P(input,"^",1)							
	s OperationType=$P(input,"^",2)

	if (OperationType="Update")
	{
		d UpdatePlan()
	}
	else
	{
	 	d AddPlan()	
	}
	
	q ret

AddPlan()
	Ts
	s object=##Class(User.PMPProjectPlan).%New()
	
	s ProjectPlanCreatUser=ProjectPlanCreatUser
	s ProjectPlanStatus=##Class(User.PMPDictionary3).%OpenId(ProjectPlanStatus)
	s ProjectPlanType=##Class(User.PMPDirectoryTree).%OpenId(ProjectPlanType)
	s PlanImprovmentDR=##Class(User.PMPImprovementList).%OpenId(PlanImprovmentDR)
	s PlanJobLoggDR=##Class(User.PMPJobLogging).%OpenId(PlanJobLoggDR)
	s PlanModuleDR=##Class(User.PMPModule).%OpenId(PlanModuleDR)
	s PlanContractAgingDR=##Class(User.PMPContractAging).%OpenId(PlanContractAgingDR)
	s PlanContractDR=##Class(User.PMPContract).%OpenId(PlanContractDR)
			
	s object.PPPCode=ProjectPlanCode
	s object.PPPDesc=ProjectPlanDesc
	s object.PPPType=ProjectPlanType
	s object.PPPMenu=ProjectPlanMenu
	s object.PPPPlanStartDate=ProjectPlanStartDate
	
	s object.PPPPlanStartTime=ProjectPlanStartTime
	s object.PPPPlanEndDate=ProjectPlanEndDate
	s object.PPPPlanEndTime=ProjectPlanEndTime
	s object.PPPRealityStartDate=ProjectPlanRealityStartDate
	s object.PPPRealityStartTime=ProjectPlanRealityStartTime
	
	s object.PPPRealityEndDate=ProjectPlanRealityEndDate
	s object.PPPRealityEndTime=ProjectPlanRealityEndTime
	s object.PPPStatus=ProjectPlanStatus
	s object.PPPResponsibility=ProjectPlanResponsibility
	s object.PPPRemark=ProjectPlanRemark
	
	s object.PPPCreatDate=ProjectPlanCreatDate
	s object.PPPCreatTime=ProjectPlanCreatTime
	s object.PPPCreatUser=ProjectPlanCreatUser
	s object.PPPImprovmentDR=PlanImprovmentDR
	s object.PPPJobLoggDR=PlanJobLoggDR
	
	s object.PPPModuleDR=PlanModuleDR
	s object.PPPContractAgingDR=PlanContractAgingDR
	s object.PPPContractDR=PlanContractDR
	s object.PPPAdjuc=PlanAdjuc	
	
	s rc=object.%Save()
	s PerId= object.%Id()
	if (rc)
	{
		Tc
		&sql(insert into sqluser.PMP_ProjectPlanUser (PPP_ParRef,PPPU_User,PPPU_PlanStartDate,PPPU_PlanEndDate,PPPU_CreatUser) values (:PerId,:ResponsibilityUserID,:ProjectPlanStartDate,:PPPPlanEndDate,:CreateUserID))
	}
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
	
UpdatePlan()
	Ts
	s object=##Class(User.PMPProjectPlan).%OpenId(ProjectPlanRowID)
	

	s ProjectUpdateUser=ProjectUpdateUser
	s ProjectPlanStatus=##Class(User.PMPDictionary3).%OpenId(ProjectPlanStatus)
	s ProjectPlanType=##Class(User.PMPDirectoryTree).%OpenId(ProjectPlanType)
	s PlanImprovmentDR=##Class(User.PMPImprovementList).%OpenId(PlanImprovmentDR)
	s PlanJobLoggDR=##Class(User.PMPJobLogging).%OpenId(PlanJobLoggDR)
	s PlanModuleDR=##Class(User.PMPModule).%OpenId(PlanModuleDR)
	s PlanContractAgingDR=##Class(User.PMPContractAging).%OpenId(PlanContractAgingDR)
	s PlanContractDR=##Class(User.PMPContract).%OpenId(PlanContractDR)			

	s object.PPPCode=ProjectPlanCode
	s object.PPPDesc=ProjectPlanDesc
	s object.PPPMenu=ProjectPlanMenu
	s object.PPPPlanStartDate=ProjectPlanStartDate	
	s object.PPPPlanStartTime=ProjectPlanStartTime
	
	s object.PPPPlanEndDate=ProjectPlanEndDate
	s object.PPPPlanEndTime=ProjectPlanEndTime
	s object.PPPRealityStartDate=ProjectPlanRealityStartDate
	s object.PPPRealityStartTime=ProjectPlanRealityStartTime	
	s object.PPPRealityEndDate=ProjectPlanRealityEndDate
	
	s object.PPPRealityEndTime=ProjectPlanRealityEndTime
	s object.PPPStatus=ProjectPlanStatus
	s object.PPPResponsibility=ProjectPlanResponsibility
	s object.PPPRemark=ProjectPlanRemark
	s object.PPPUpdateDate=ProjectPlanUpdateDate
	
	s object.PPPUpdateTime=ProjectPlanUpdateTime
	s object.PPPUpdateUser=ProjectUpdateUser
	s object.PPPImprovmentDR=PlanImprovmentDR
	s object.PPPJobLoggDR=PlanJobLoggDR
	s object.PPPModuleDR=PlanModuleDR
	
	s object.PPPContractAgingDR=PlanContractAgingDR
	s object.PPPContractDR=PlanContractDR
	b
	s rc=object.%Save()
	if (rc)
	{
		Tc
	}
	else
	{
	  Tro	
	}
	s ret=rc
	q ret
}

/// Creat  zhangsong
/// date:2015-05-19
/// description: 获取计划人员信息
/// input:  type()
/// output: 'ResponsGridRowid','ResponsGridUser','ResponsGridMainPlan','ResponsGridInDate','ResponsGridOutDate','ResponsGridCreatUser','ResponsGridPlanRowID'
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","ResponsUserGridStore","10")
Query ResponsUserGridStore(PlanRowid As %String) As websys.Query(ROWSPEC = "ResponsGridRowid:%String,ResponsGridUser:%String,ResponsGridMainPlan:%String,ResponsGridInDate:%String,ResponsGridOutDate:%String,ResponsGridCreatUser:%String,ResponsGridPlanRowID:%String")
{
}

ClassMethod ResponsUserGridStoreExecute(ByRef qHandle As %Binary, PlanRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	q:PlanRowid="" $$$OK
	;s ^tmp("ResponsUserGridStore")=PlanRowid
    s ResponsGridRowid="" f  s ResponsGridRowid=$o(^PMPProjectPlanUser(PlanRowid,ResponsGridRowid)) q:((ResponsGridRowid="")||(ResponsGridRowid="Details"))  d
    .s (ResponsGridUser,ResponsGridMainPlan,ResponsGridInDate,ResponsGridOutDate,ResponsGridCreatUser,ResponsGridPlanRowID,ResponsGridCreatUserID,ResponsGridUserID)=""
    .s ResponsGridUserID=$P(^PMPProjectPlanUser(PlanRowid,ResponsGridRowid),"^",2)
    .s ResponsGridUser=##Class(web.PMP.Document).SSUSER(ResponsGridUserID)
    .i IndependentUserRet'="Y" s ResponsGridUserID=+ResponsGridUserID
    .s ResponsGridCreatUserID=$P(^PMPProjectPlanUser(PlanRowid,ResponsGridRowid),"^",15)
    .s ResponsGridCreatUser=##Class(web.PMP.Document).SSUSER(ResponsGridCreatUserID)
    .i IndependentUserRet'="Y" s ResponsGridCreatUserID=+ResponsGridCreatUserID
    .s ResponsGridMainPlan=$P(^PMPProjectPlan(PlanRowid),"^",2)
    .s ResponsGridPlanRowID=PlanRowid
    .s ResponsGridInDate=..Date($P(^PMPProjectPlanUser(PlanRowid,ResponsGridRowid),"^",4))
    .s ResponsGridOutDate=..Date($P(^PMPProjectPlanUser(PlanRowid,ResponsGridRowid),"^",6))


    .d OutputResponsUser
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputResponsUser
    s Data=$lb(ResponsGridRowid,ResponsGridUser,ResponsGridMainPlan,ResponsGridInDate,ResponsGridOutDate,ResponsGridCreatUser,ResponsGridPlanRowID)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zhangsong
/// date:2015-05-23
/// description: 插入责任人员数据
/// input:
/// input desc:inputStr=AddModeFlag"^"AddModeRowid"^"AddModeUserName"^"AddModeInDate"^"AddModeOutDate"^"AddModeCreatUser
/// output: 1 成功 
/// others:w ##class(web.PMP.Document).AddModeAddFun("")
ClassMethod AddModeAddFun(input As %Text) As %String
{
	q:input="" "input"
	s ret=-1
	s NowDate=+$h,NowTime=$p($h,",",2)
	;s ^Tmp("AddModeAddFun",$j)=input	   
	
	s AddModeFlag=$P(input,"^",1)
	s AddModeRowid=$P(input,"^",2)
	s AddModeUserName=$P(input,"^",3)
	s AddModeCreatUser=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(AddModeCreatUser)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s AddModeCreatUser=AddModeCreatUser_"||"_##Class(web.PMP.Document).ConvertUser(AddModeCreatUser,"")
	s AddModeInDate=..RDate($P(input,"^",4))
	s AddModeOutDate=..RDate($P(input,"^",5))
	
	s $ZT="ERROR^DHCSSERR" d ..tb()
	
	&sql(insert into sqluser.PMP_ProjectPlanUser(PPP_ParRef,PPPU_User,PPPU_PlanStartDate,PPPU_PlanEndDate,PPPU_CreatUser) values (:AddModeRowid,:AddModeUserName,:AddModeInDate,:AddModeOutDate,:AddModeCreatUser))
	d ..tc()
	
	q SQLCODE
}

/// Creat  zhangsong
/// date:2015-05-23
/// description: 插入责任人员数据
/// input:
/// input desc:inputStr=AddModeFlag"^"AddModeRowid"^"AddModeUserName"^"AddModeInDate"^"AddModeOutDate"^"AddModeCreatUser
/// output: 1 成功 
/// others:w ##class(web.PMP.Document).DeleteModeAddFun("")
ClassMethod DeleteModeAddFun(input As %Text) As %String
{
	q:input="" "input"
	s ret=-1
	;s ^Tmp("DeleteModeAddFun",$j)=input	   
	
	s AddModeFlag=$P(input,"^",1)
	i AddModeFlag'="Delete"  q -1
	s AddModeRowid=$P(input,"^",2)
	
	&sql(delete from PMP_ProjectPlanUser where PPPU_Rowid=:AddModeRowid)
	q SQLCODE
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

/// Creat  zzp
/// date:2015-05-27
/// description: 新增、更新树结构内容
/// input: nodeid+"^"+typeid+"^"+flag+"^"+sub+"^"+ipAdress;  titlename
/// input  节点id    类型id   操作标识  子节点（1,0）IP        标题
/// output: 1 成功 
/// others:w ##class(web.PMP.Document).AddDirTree("12^208^Add^1^192.168.1.7","1222")
ClassMethod AddDirTree(InPut As %String, Title As %Text) As %String
{
	;s ^Temp("AddDirTree")=InPut_"@@"_Title
	s ret=""
	q:$l(InPut,"^")'=5 "-1"
	q:Title="" "-2"
	s nodeid=$p(InPut,"^",1)  //节点id
	s typeid=$p(InPut,"^",2) //类型id  字典表
	s flag=$p(InPut,"^",3)  //操作标识 Add Update
	s sub=$p(InPut,"^",4)   //是否子节点 1 /0
	s ipAdress=$p(InPut,"^",5)  //ip地址
	q:(sub="1")&(nodeid="") "-3"
	i flag="Add"  d AddDirTreeSub
	i flag="Update"  d UpdateDirTreeSub
	q ret
AddDirTreeSub
     s leve="",code="",(TabMessage,OldValue,NewValue,TabFieldName)=""
     i nodeid=""  s leve=$o(^PMPDictionary("FLAG","Level",""))
     i nodeid'="" s leve=$p(^PMPDirectoryTree(nodeid),"^",4)
     i sub="1" s leve=leve+1
     i $d(^PMPDirectoryTreei("Code",typeid)) s code=$o(^PMPDirectoryTreei("Code",typeid,""),-1)+1
     i '$d(^PMPDirectoryTreei("Code",typeid)) s code="001"
     i $l(code)=1 s code="00"_code  
     i $l(code)=2 s code="0"_code  
     Ts
     s object=##Class(User.PMPDirectoryTree).%New()
     s object.PDTDesc=Title
     s object.PDTCode=code
     s objecttype=##Class(User.PMPDictionary3).%OpenId(typeid)
     s object.PDTType=objecttype
     s objectleve=##Class(User.PMPDictionary3).%OpenId(leve)
     s object.PDTLeve=objectleve
     i sub="1"  d
     .s objectfather=##Class(User.PMPDirectoryTree).%OpenId(nodeid)
     .s object.PDTFatherLeve=objectfather
     s sc=object.%Save()
     i sc{
	     Tc
	     s TabMessage="PMP_DirectoryTree"_"@@"_object.%Id()_"@@"_flag_"@@"_ipAdress
	     s OldValue="",NewValue=Title_"@@"_code_"@@"_typeid_"@@"_leve,TabFieldName="PDT_Desc@@PDT_Code@@PDT_Type@@PDT_Leve"
	     i sub="1" s NewValue=NewValue_"@@"_nodeid,TabFieldName=TabFieldName_"@@PDT_FatherLeve"
	     d ..PMPOperatingRecord(TabMessage,OldValue,NewValue,TabFieldName)
	     }
	 else{
		 Tro
		 }
	 s ret=sc
     q ret
UpdateDirTreeSub
     s (TabMessage,OldValue,NewValue,TabFieldName)=1
     Ts
     s object=##Class(User.PMPDirectoryTree).%OpenId(nodeid)
     i object.PDTDesc'=Title s OldValue=object.PDTDesc,NewValue=Title,TabFieldName="PDT_Desc"
     s object.PDTDesc=Title
     s sc=object.%Save()
     i sc{
	     Tc
	     s TabMessage="PMP_DirectoryTree"_"@@"_nodeid_"@@"_flag_"@@"_ipAdress
	     i OldValue'="" d ..PMPOperatingRecord(TabMessage,OldValue,NewValue,TabFieldName)
	     }
	 else{
		  Tro
		 }
     s sc=object.%Save()
     q ret
}

/// Creat  zzp
/// date:2015-05-27
/// description: 检查树节点是否存在子节点
/// input: 
/// output: 1 成功 
/// others:w ##class(web.PMP.Document).DirTreeSub("12")
ClassMethod DirTreeSub(Nodeid As %String) As %String
{
	n (Nodeid)
	s ret=""
	q:Nodeid="" ""
	s typeid=$p(^PMPDirectoryTree(Nodeid),"^",1)
	s sub=$o(^PMPDirectoryTreei("FatherLeve",typeid,Nodeid,""))
	while(sub'=""){
		i ret'="" s ret=ret_","_sub
	    i ret="" s ret=sub
	    s subret=..DirTreeSub(sub)
	    i subret'="" s ret=ret_","_subret
	    s sub=$o(^PMPDirectoryTreei("FatherLeve",typeid,Nodeid,sub))
		}
	q ret
}

/// Creat  zzp
/// date:2015-05-27
/// description: 删除节点树
/// input: Nodeid:节点id,SubNode:子节点,IP:IP地址
/// output: 1 成功 
/// others:w ##class(web.PMP.Document).DeleteDirTree("62","68","192.168.1.189")
ClassMethod DeleteDirTree(Nodeid As %String, SubNode As %String, IP As %String) As %String
{
	;s ^Temp("DeleteDirTree")=Nodeid_"@@"_SubNode_"@@"_IP
	s ret="-1"
	q:Nodeid="" "-2"
	i SubNode=""  d DeleteDirTree
	i SubNode'=""  d 
	.s SubNode=SubNode_","_Nodeid
	.s lenth=$l(SubNode,",")
	.s type=""
	.f id=1:1:lenth  d
	..q:type=id
	..s type=id
	..s nodeidd=$p(SubNode,",",id)
	..q:nodeidd=""
	..d DeleteDirTreeSub
	q ret
DeleteDirTree
    Ts
    s sc=##Class(User.PMPDirectoryTree).%DeleteId(Nodeid)
    i sc{
	    Tc
	    s TabMessage="PMP_DirectoryTree"_"@@"_Nodeid_"@@"_"Delete"_"@@"_IP
	    s (OldValue,NewValue,TabFieldName)=""
	    d ..PMPOperatingRecord(TabMessage,OldValue,NewValue,TabFieldName)
	    }
	 else{
		 Tro
		 }
    s ret=sc
    q ret
DeleteDirTreeSub
    Ts
    s sc=##Class(User.PMPDirectoryTree).%DeleteId(nodeidd)
    b ;3
    i sc{
	    Tc
	    s TabMessage="PMP_DirectoryTree"_"@@"_nodeidd_"@@"_"Delete"_"@@"_IP
	    s (OldValue,NewValue,TabFieldName)=""
	    d ..PMPOperatingRecord(TabMessage,OldValue,NewValue,TabFieldName)
	    }
	 else{
		 Tro
		 }
    s ret=sc
    q ret
}

/// Creat  zzp
/// date:2015-05-27
/// description: 重组文档管理的下载记录id
/// input:
/// output: 
/// others:w ##class(web.PMP.Document).NewRowid("3")
ClassMethod NewRowid(Rowid As %String) As %String
{
	s ret=""
	q:Rowid="" ""
	S ret=Rowid_"||"_$p(^PMPImprovementAdjunct(Rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-24
/// description: 获取项目审核通过配置
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).ProjectType()
ClassMethod ProjectType() As %String
{
	s ret="3@99"
	i $d(^PMPSysConfigure("Type","ProjectType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","ProjectType",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-24
/// description: 获取需求完成状态
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).FinishType()
ClassMethod FinishType() As %String
{
	s ret="108"
	i $d(^PMPSysConfigure("Type","FinishType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","FinishType",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-18
/// description: 获取需求提交状态
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).submittype()
ClassMethod submittype() As %String
{
	s ret="92"
	i $d(^PMPSysConfigure("Type","submittype"))  d
	.s rowid=$o(^PMPSysConfigure("Type","submittype",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-18
/// description: 获取用户操作需求的操作类型
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).UserSavetype()
ClassMethod UserSavetype() As %String
{
	s ret="135"
	i $d(^PMPSysConfigure("Type","UserSavetype"))  d
	.s rowid=$o(^PMPSysConfigure("Type","UserSavetype",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-28
/// description: 获取需求状态的部分code
/// input:  
/// output: 审核不通过^保存^测试^提交^完成^指定审核^审核通过^信息科制定审核人员^申请人指定审核人员^  全部为空的时候默认为"014^001^017^002^018^005^009^006^001"
/// others: w ##class(web.PMP.Document).StatusCode()
ClassMethod StatusCode() As %String
{
	s ret=""
	;审核不通过
	s (rowid,values)=""
	s statusid="014"
	i $d(^PMPSysConfigure("Type","BatchNotStatus"))  d
	.s rowid=$o(^PMPSysConfigure("Type","BatchNotStatus",""))
	.s values=$p(^PMPSysConfigure(0,rowid),"^",2)
	.i $d(^PMPDictionary(values))  d
	..s statusid=$p(^PMPDictionary(values),"^",1)
	..s ret=statusid
	.e  s ret=""
	
	;保存
	s (rowid,values)=""
	s statusid="001"
	i $d(^PMPSysConfigure("Type","Savetype"))  d
	.s rowid=$o(^PMPSysConfigure("Type","Savetype",""))
	.s values=$p(^PMPSysConfigure(0,rowid),"^",2)
	.i $d(^PMPDictionary(values))  d
	..s statusid=$p(^PMPDictionary(values),"^",1)
	..s ret=ret_"^"_statusid
	.e  s ret=ret_"^"_"" 
	e  s ret=ret_"^"_"" 
	
	;测试
	s (rowid,values)=""
	s statusid="017"
	i $d(^PMPSysConfigure("Type","TestType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","TestType",""))
	.s values=$p(^PMPSysConfigure(0,rowid),"^",2)
	.i $d(^PMPDictionary(values))  d
	..s statusid=$p(^PMPDictionary(values),"^",1)
	..s ret=ret_"^"_statusid
	.e  s ret=ret_"^"_"" 
	e  s ret=ret_"^"_"" 
	
	;提交
	s (rowid,values)=""
	s statusid="002"
	i $d(^PMPSysConfigure("Type","submittype"))  d
	.s rowid=$o(^PMPSysConfigure("Type","submittype",""))
	.s values=$p(^PMPSysConfigure(0,rowid),"^",2)
	.i $d(^PMPDictionary(values))  d
	..s statusid=$p(^PMPDictionary(values),"^",1)
	..s ret=ret_"^"_statusid
	.e  s ret=ret_"^"_"" 
	e  s ret=ret_"^"_""
	
	;完成
	s (rowid,values)=""
	s statusid="018"
	i $d(^PMPSysConfigure("Type","FinishType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","FinishType",""))
	.s values=$p(^PMPSysConfigure(0,rowid),"^",2)
	.i $d(^PMPDictionary(values))  d
	..s statusid=$p(^PMPDictionary(values),"^",1)
	..s ret=ret_"^"_statusid
	.e  s ret=ret_"^"_"" 
	e  s ret=ret_"^"_""
	
	;指定审核
	s (rowid,values)=""
	s statusid="005"
	i $d(^PMPSysConfigure("Type","Appoint"))  d
	.s rowid=$o(^PMPSysConfigure("Type","Appoint",""))
	.s values=$p(^PMPSysConfigure(0,rowid),"^",2)
	.i $d(^PMPDictionary(values))  d
	..s statusid=$p(^PMPDictionary(values),"^",1)
	..s ret=ret_"^"_statusid
	.e  s ret=ret_"^"_"" 
	e  s ret=ret_"^"_""
	
	;审核通过
	s (rowid,values)=""
	s statusid="009"
	i $d(^PMPSysConfigure("Type","ProjectType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","ProjectType",""))
	.s values=$p(^PMPSysConfigure(0,rowid),"^",2)
	.s values=$p(values,"@",2)
	.i $d(^PMPDictionary(values))  d
	..s statusid=$p(^PMPDictionary(values),"^",1)
	..s ret=ret_"^"_statusid
	.e  s ret=ret_"^"_"" 
	e  s ret=ret_"^"_""
	
	;信息科指定审核
	s (rowid,values)=""
	s statusid="006"
	i $d(^PMPSysConfigure("Type","InformationApp"))  d
	.s rowid=$o(^PMPSysConfigure("Type","InformationApp",""))
	.s values=$p(^PMPSysConfigure(0,rowid),"^",2)
	.i $d(^PMPDictionary(values))  d
	..s statusid=$p(^PMPDictionary(values),"^",1)
	..s ret=ret_"^"_statusid
	.e  s ret=ret_"^"_"" 
	e  s ret=ret_"^"_""
	
	;申请人指定审核
	s (rowid,values)=""
	s statusid="001"
	i $d(^PMPSysConfigure("Type","Savetype"))  d
	.s rowid=$o(^PMPSysConfigure("Type","Savetype",""))
	.s values=$p(^PMPSysConfigure(0,rowid),"^",2)
	.i $d(^PMPDictionary(values))  d
	..s statusid=$p(^PMPDictionary(values),"^",1)
	..s ret=ret_"^"_statusid
	.e  s ret=ret_"^"_"" 
	e  s ret=ret_"^"_""
	q ret
}

/// Creat  zzp  
/// date:2015-05-29
/// description: 获取权限列表的用户是否自动审核配置
/// input:  
/// output: Y:需要自动审核,N:不需要自动审核,默认为Y
/// others: w ##class(web.PMP.Document).PermissionType()
ClassMethod PermissionType() As %String
{
	s ret="Y"
	i $d(^PMPSysConfigure("Type","PermissionType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","PermissionType",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-29
/// description: 获取需求提交用户在审核列表中是否存在权限
/// input:  
/// output: Y^1(存在权限^权限级别id) N^0(不存在权限^0)  如果存在则返回该用户的最高审核权限
/// others: w ##class(web.PMP.Document).PermissionUser("1")
ClassMethod PermissionUser(User As %String) As %String
{
	s ret="N^0"
	s CurrUserId=%session.Data("LOGON.USERID") 
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s commonTypeRet=##Class(web.PMP.Document).IndependentType(CurrUserId)
	i IndependentUserRet="Y"  d
	.i commonTypeRet="Y" d
	..s CurrUserId=CurrUserId_"||"_##Class(web.PMP.Document).ConvertUser(CurrUserId,"")
	s ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s PERSpare2=$p(^PMPPermission(ROWIDD),"^",5)  //权限是否有效 Y/N
	.q:PERSpare2'="Y"
	.s ROWID="" F  S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,CurrUserId,ROWID)) Q:ROWID=""  D
	..s PERBusIsEffect=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",3)    //是否有效 Y/N ""
	..q:PERBusIsEffect'="Y"
	..s PERBusSpare1=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",5)   //审核科室组权限
	..i ret'="N^0" s ret=ret_"@"_PERBusSpare1
	..i ret="N^0" s ret="Y^"_ROWIDD_"^"_PERBusSpare1
	q ret
}

/// Creat  zzp  
/// date:2015-05-29
/// description: 判断当前登录科室用户提交需求事都需要科室审核
/// input:  
/// output: Y^1^93^156^1(需要科室审核^科室主任id^审核通过状态id^审核类型^科室id) N^0^0^0^0(不需要科室审核^0^0^0^0) 
/// others: w ##class(web.PMP.Document).PermissionLoc()
ClassMethod PermissionLoc() As %String
{
	s ret="N^0^0^0^0"
	s locid=%session.Data("LOGON.CTLOCID")
	i $d(^PMPSysConfigure("Type","locAuditing"))  d
	.s rowid=$o(^PMPSysConfigure("Type","locAuditing",""))
	.s loctype=$p(^PMPSysConfigure(0,rowid),"^",2)
	.i $p(loctype,"@",1)="Y"  d
	..i $d(^DepartAuditloc(0,"Departloc",locid)) d
	...s AuditRowid="" f  s AuditRowid=$o(^DepartAuditloc(0,"Departloc",locid,AuditRowid)) q:AuditRowid=""  d
	....q:$p(^DepartAudit(AuditRowid),"^",3)'="Y"
	....q:$p(^DepartAudit(AuditRowid),"^",4)'="L"
	....s AuditUserDr=$p(^DepartAudit(AuditRowid),"^",2)
	...S ret="Y^"_$g(AuditUserDr)_"^"_$P(loctype,"@",2)_"^"_$P(loctype,"@",3)_"^"_locid
	q ret
}

/// Creat  zzp  
/// date:2015-05-29
/// description: 自动审核操作
/// input:  需求的Rowid,当前用户的最高权限ID
/// output: 1:成功,0:失败(失败代码)
/// others: w ##class(web.PMP.Document).PermissionAuto("","")
ClassMethod PermissionAuto(IpmlRowid As %String, PermissRowid As %String) As %String
{
	s AutoRet="",permissLocRet="",Remark="系统自动审核"
	s Date=+$h,Time=$p($h,",",2)
	q:(IpmlRowid="")||(PermissRowid="") "-1"
	s creatloc=$p(^PMPImprovementList(IpmlRowid),"^",12)
	i creatloc'="" s loctypeid=$p(^CTLOC(creatloc),"^",19)
	s PermissionLocRet=..PermissionLoc()
	i PermissionLocRet["Y"  d  ;需要科室审核
	.s Locuserid=$p(PermissionLocRet,"^",2)
	.s PermissStatus=$p(PermissionLocRet,"^",3)
	.s PermissType=$p(PermissionLocRet,"^",4)
	.s LocID=$p(PermissionLocRet,"^",5)
	.d PermissLocAuto
	.i permissLocRet="1" d PermissAuto
	.i permissLocRet'="1" s AutoRet=permissLocRet
	e  d PermissAuto  ;不需要科室审核
	q AutoRet
PermissLocAuto
    Ts
    s object=##Class(User.PMPImprovementList).%OpenId(IpmlRowid)
    s objectStatus=##Class(User.PMPDictionary3).%OpenId(PermissStatus)
    s object.IPMLStatusDR=objectStatus 
    s objectType=##Class(User.PMPDictionary3).%OpenId(PermissType)
    s sc=object.%Save()
    i sc{
	    Tc
	    &sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid,IPMD_Standby3,IPMD_Remark) values (:IpmlRowid,:PermissType,:PermissStatus,:Date,:Time,:Locuserid,:locid,'Y',:Remark))
	    }
	else{
		Tro
		}
	s permissLocRet=sc
	q permissLocRet
PermissAuto
    f no=1:1:PermissRowid   d
    .q:'$d(^PMPPermission(no))
    .s PerStatusid=$P(^PMPPermission(no),"^",6)
    .q:$P(^PMPPermission(no),"^",5)'="Y"
    .s PerTypeid=$P(^PMPPermission(no),"^",9)
    .q:'$d(^PMPPermisBusiness(no))
    .s PERROWID="" f  s PERROWID=$o(^PMPPermisBusiness(no,"E",PERROWID)) q:PERROWID=""  d
    ..q:$P(^PMPPermisBusiness(no,"E",PERROWID),"^",3)'="Y"
    ..s PERBusSpare1=$P(^PMPPermisBusiness(no,"E",PERROWID),"^",5) 
    ..q:(PERBusSpare1'="")&(PERBusSpare1'=loctypeid)
    ..S PermissUser=$P(^PMPPermisBusiness(no,"E",PERROWID),"^",4) 
    .d AddPerAuto
    .s AutoRet=AddPerAutoRet
    q AutoRet
AddPerAuto
    Ts
    s object=##Class(User.PMPImprovementList).%OpenId(IpmlRowid)
    s objectStatus=##Class(User.PMPDictionary3).%OpenId(PerStatusid)
    s object.IPMLStatusDR=objectStatus 
    s objectType=##Class(User.PMPDictionary3).%OpenId(PerTypeid)
    s sc=object.%Save() 
    i sc{
	    Tc
	    &sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Standby3,IPMD_Remark) values(:IpmlRowid,:PerTypeid,:PerStatusid,:Date,:Time,:PermissUser,'Y',:Remark))
	    }
	else{
		Tro
		}
	s AddPerAutoRet=sc
	q AddPerAutoRet
}

/// Creat  zzp  
/// date:2015-05-29
/// description: 获取是否启用需审核人功能
/// input:  
/// output: Y:启用,N:不启用 默认为N
/// others: w ##class(web.PMP.Document).FormulatePermiss()
ClassMethod FormulatePermiss() As %String
{
	s ret="N"
	i $d(^PMPSysConfigure("Type","FormulatePermiss"))  d
	.s rowid=$o(^PMPSysConfigure("Type","FormulatePermiss",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-29
/// description: 获取工程师可用的状态id
/// input:  
/// output: 返回状态字符串，用,区分，默认为“100,101,102,103,105,107,109,110,112”
/// others: w ##class(web.PMP.Document).HandleNeed()
ClassMethod HandleNeed() As %String
{
	s ret="100,101,102,103,105,107,109,110,112"
	i $d(^PMPSysConfigure("Type","HandleNeed"))  d
	.s rowid=$o(^PMPSysConfigure("Type","HandleNeed",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-29
/// description: 获取配置中测试和完成状态的id
/// input:  
/// output: 测试id,完成id，默认为“107,108”
/// others: w ##class(web.PMP.Document).FinishTest()
ClassMethod FinishTest() As %String
{
	s ret="107,108"
	s TestType="107"
	i $d(^PMPSysConfigure("Type","TestType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","TestType",""))
	.s TestType=$p(^PMPSysConfigure(0,rowid),"^",2)
	s ret=TestType
	s FinishType="108"
	i $d(^PMPSysConfigure("Type","FinishType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","FinishType",""))
	.s TestType=$p(^PMPSysConfigure(0,rowid),"^",2)
	s ret=ret_","_FinishType
	q ret
}

/// Creat  zzp  
/// date:2015-05-30
/// description: 判断需求是否分配模块
/// input:  
/// output: Y:已填写,N:未填写
/// others: w ##class(web.PMP.Document).IpmlModule("76")
ClassMethod IpmlModule(IpmlRowid As %String) As %String
{
	s ret="N"
	q:IpmlRowid="" "N"
	i $d(^PMPImprovementList(IpmlRowid))   d
	.s modedr=$p(^PMPImprovementList(IpmlRowid),"^",23)
	.i $G(modedr)'="" s ret="Y"
	q ret
}

/// Creat  zzp  
/// date:2015-05-30
/// description: 获取配置中测试和完成状态的id
/// input:  
/// output: 默认为“Y,Y”
/// others: w ##class(web.PMP.Document).TestFinishUpdate()
ClassMethod TestFinishUpdate() As %String
{
	s ret="Y,Y"
	s TestType="Y"
	i $d(^PMPSysConfigure("Type","TestUpdate"))  d
	.s rowid=$o(^PMPSysConfigure("Type","TestUpdate",""))
	.s TestType=$p(^PMPSysConfigure(0,rowid),"^",2)
	s ret=TestType
	s FinishType="Y"
	i $d(^PMPSysConfigure("Type","FinishUpdate"))  d
	.s rowid=$o(^PMPSysConfigure("Type","FinishUpdate",""))
	.s FinishType=$p(^PMPSysConfigure(0,rowid),"^",2)
	s ret=ret_","_FinishType
	q ret
}

/// Creat  zzp  
/// date:2015-05-30
/// description: 获取配置中需求界面查询日期默认天数
/// input:  
/// output: 默认为"10"
/// others: w ##class(web.PMP.Document).SelectDefaultDate()
ClassMethod SelectDefaultDate() As %String
{
	s ret="10"
	i $d(^PMPSysConfigure("Type","SelectDefaultDate"))  d
	.s rowid=$o(^PMPSysConfigure("Type","SelectDefaultDate",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp
/// date:2015-05-30
/// description: 获取需求评价数据
/// input:  Rowid,type
/// output: 
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","IpmlAppingStore","","")
Query IpmlAppingStore(Rowid As %String, type As %String) As websys.Query(ROWSPEC = "IAppRowid:%String,IAppPJ1:%String,IAppPJ2:%String,IAppPJ3:%String,IAppType:%String,IAppUser:%String,IAppDate:%String,IAppMeau:%String,IAppImprove:%String")
{
}

ClassMethod IpmlAppingStoreExecute(ByRef qHandle As %Binary, Rowid As %String, type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    q:Rowid="" $$$OK
    q:type="" $$$OK
    s subRowid="" f  s subRowid=$o(^PMPImprovementAppraisal(Rowid,subRowid)) q:subRowid=""  d
    .s (IAppRowid,IAppPJ1,IAppPJ2,IAppPJ3,IAppType,IAppUser,IAppDate,IAppMeau,IAppImprove)=""
    .s IAppUser=..SSUSER($p(^PMPImprovementAppraisal(Rowid,subRowid),"^",3))
    .q:IAppUser=""
    .s IAppPJ1id=$p(^PMPImprovementAppraisal(Rowid,subRowid),"^",8)
    .s IAppPJ2id=$p(^PMPImprovementAppraisal(Rowid,subRowid),"^",9)
    .s IAppPJ3id=$p(^PMPImprovementAppraisal(Rowid,subRowid),"^",10)
    .s IAppPJ1=$select(IAppPJ1id="1":"很慢(1分)",IAppPJ1id="2":"较慢(2分)",IAppPJ1id="3":"正常(3分)",IAppPJ1id="4":"较快(4分)",IAppPJ1id="5":"很快(5分)")
    .s IAppPJ2=$select(IAppPJ2id="1":"很差(1分)",IAppPJ2id="2":"较差(2分)",IAppPJ2id="3":"一般(3分)",IAppPJ2id="4":"较好(4分)",IAppPJ2id="5":"很好(5分)")
    .s IAppPJ3=$select(IAppPJ3id="1":"很差(1分)",IAppPJ3id="2":"较差(2分)",IAppPJ3id="3":"一般(3分)",IAppPJ3id="4":"较好(4分)",IAppPJ3id="5":"很好(5分)")
    .s IAppTypeid=$p(^PMPImprovementAppraisal(Rowid,subRowid),"^",18)
    .s IAppType=$select(IAppTypeid="HA":"甲方评价",IAppTypeid="PA":"项目评价",IAppTypeid="SS":"实施评价")
    .s IAppDate=..Date($p(^PMPImprovementAppraisal(Rowid,subRowid),"^",4))_" "_..Time($p(^PMPImprovementAppraisal(Rowid,subRowid),"^",5))
	.s IAppMeau=$p(^PMPImprovementAppraisal(Rowid,subRowid),"^",7)
	.s IAppImprove=Rowid
	.s IAppRowid=Rowid_"||"_subRowid
	.d OutputIpmlApping
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputIpmlApping
    s Data=$lb(IAppRowid,IAppPJ1,IAppPJ2,IAppPJ3,IAppType,IAppUser,IAppDate,IAppMeau,IAppImprove)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp  
/// date:2015-05-30
/// description: 根据需求id获取详细信息
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).IpmlDetail("63")
ClassMethod IpmlDetail(Rowid As %String) As %Text
{
	s ret=""
	q:Rowid="" ""
	Do ##class(DHCPM.Query.PMQueryAll).BuildDemData(Rowid)
    s ret=DemandDesc_"^"_DemandType_"^"_EmergDegree_"^"_UserPhone_"^"_DemSituation_"^"_UserName_"^"_LocName_"^"_PMModule_"^"_EditUser_"^"_EditDemDesc
	q ret
}

/// Creat  zzp  
/// date:2015-06-02
/// description: 获取配置中之后启用工程师替用户申请需求的时候选择申请用户
/// input:  
/// output: 默认为“Y”
/// others: w ##class(web.PMP.Document).DHCCSaveType()
ClassMethod DHCCSaveType() As %String
{
	s ret="Y"
	i $d(^PMPSysConfigure("Type","DHCCSaveType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","DHCCSaveType",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat zzp
/// date: 2015-06-02
/// description: 获取当前登录人是否在工程师列表中并返回在需求申请时是否选择用户标识
/// input:  
/// output: "true";"false" 默认"true"
/// others: w ##class(web.PMP.Document).LocTionUser()
ClassMethod LocTionUser() As %String
{
	s retRet="true"
	s CurrUserId=%session.Data("LOGON.USERID") 
	s DHCCSaveTyperet=..DHCCSaveType()
	s usertype=$o(^PMPProjectUseri("SSUSER",CurrUserId,""))
	i (usertype'="")&&(DHCCSaveTyperet="Y") s retRet="false"
	q retRet
}

/// Creat  zzp  
/// date:2015-06-02
/// description: 获取配置中的保存状态id
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).Savetype()
ClassMethod Savetype() As %String
{
	s ret="91"
	i $d(^PMPSysConfigure("Type","Savetype"))  d
	.s rowid=$o(^PMPSysConfigure("Type","Savetype",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取配置中项目办分配需求的类型
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).IPMLfp()
ClassMethod IPMLfp() As %String
{
	s ret="159"
	i $d(^PMPSysConfigure("Type","IPMLfp"))  d
	.s rowid=$o(^PMPSysConfigure("Type","IPMLfp",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取配置需求完成的操作类型
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).FinishHZcz()
ClassMethod FinishHZcz() As %String
{
	s ret="213"
	i $d(^PMPSysConfigure("Type","FinishHZcz"))  d
	.s rowid=$o(^PMPSysConfigure("Type","FinishHZcz",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取配置中需求申请用户回执需求的状态id和类型，对应字典表id，默认为106#213
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).IPMLHZZTLX()
ClassMethod IPMLHZZTLX() As %String
{
	s ret="106#213"
	i $d(^PMPSysConfigure("Type","IPMLHZZTLX"))  d
	.s rowid=$o(^PMPSysConfigure("Type","IPMLHZZTLX",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取合同币种
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).ContractCurrency("1")
ClassMethod ContractCurrency(Rowid As %String) As %String
{
	s ret=""
	i $d(^PMPContract(Rowid))  d
	.s ret=$p(^PMPContract(Rowid),"^",10)
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取配置中需求申请用户选择沟通用户
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).CommunicationType()
ClassMethod CommunicationType() As %String
{
	s ret="1"
	i $d(^PMPSysConfigure("Type","CommunicationType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","CommunicationType",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp
/// date:2015-05-30
/// description: 获取已沟通人员列表---信息科+项目办
/// input:  Rowid,type
/// output: 
/// others: d ##class(%ResultSet).RunQuery("web.PMP.Document","cboDemUserStore","")
Query cboDemUserStore(Input As %String) As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod cboDemUserStoreExecute(ByRef qHandle As %Binary, Input As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1,locid=""
    i $d(^PMPSysConfigure("Type","InformationDept"))  d
    .s sysid=$o(^PMPSysConfigure("Type","InformationDept",""))
    .s locid=$p(^PMPSysConfigure(0,sysid),"^",2)
    s proid="" f  s proid=$o(^PMPProjectUser(proid)) q:proid=""  d
    .q:$p(^PMPProjectUser(proid),"^",5)'=""
    .s RowId=$p(^PMPProjectUser(proid),"^",1)_"||"_proid
    .q:RowId=""
    .s Description=$p(^PMPProjectUser(proid),"^",22)
	.d OutputUserStore
	i locid'=""  d
	.s deptid="" f  s deptid=$o(^DepartAuditloc(0,"Departloc",locid,deptid)) q:deptid=""  d
	..s RowId=$p(^DepartAudit(deptid),"^",2)
	..Q:$p(^DepartAudit(deptid),"^",3)'="Y"
	..Q:RowId=""
	..S Description=$p(^PMPProjectUser(proid),"^",22)
	..d OutputUserStore
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputUserStore
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creat  zzp  
/// date:2015-06-20	
/// description: 获取用户需求保存状态时候是否允许修改需求内容，默认为Y
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).SaveUpdateType()
ClassMethod SaveUpdateType() As %String
{
	s ret="Y"
	i $d(^PMPSysConfigure("Type","SaveUpdateType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","SaveUpdateType",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-23	
/// description: 获取配置中工程师是否走独立用户，默认为Y
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).IndependentUser()
ClassMethod IndependentUser() As %String
{
	s ret="Y"
	i $d(^PMPSysConfigure("Type","IndependentUser"))  d
	.s rowid=$o(^PMPSysConfigure("Type","IndependentUser",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-23	
/// description: 获取配置中工程师所关联的公共用户
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).CommonUser()
ClassMethod CommonUser() As %String
{
	s ret=""
	i $d(^PMPSysConfigure("Type","CommonUser"))  d
	.s rowid=$o(^PMPSysConfigure("Type","CommonUser",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-23	
/// description: 判断登录用户是否是公共帐号Y 为是,N为不是，默认不是
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).IndependentType(1)
ClassMethod IndependentType(UserId As %String) As %String
{
	s ret="N",retret=""
	;i $d(^PMPProjectUseri("SSUSER",UserId)) s ret="Y" 
	i $d(^PMPSysConfigure("Type","CommonUser"))  d
	.s rowid=$o(^PMPSysConfigure("Type","CommonUser",""))
	.s retret=$p(^PMPSysConfigure(0,rowid),"^",2)
	i retret'=""  d
	.f id=1:1:$l($G(retret),",")  d
	..i $p(retret,",",id)=UserId s ret="Y"
	q ret
}

/// Creat  zzp  
/// date:2015-06-23	
/// description: 保存每次登录选择的用户身份
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).InertNewUser("1","192.168.1.1")
ClassMethod InertNewUser(NewUserNameValue As %String, iP As %String) As %String
{
	 s ret="-1"
	 q:NewUserNameValue="" "-2"
	 s userid=%session.Data("LOGON.USERID")
	 s job=$j
	 i iP'="" d
	 k ^PMPSYSUSER("PMPNewUser",job,iP) 
	 k ^PMPSYSUSER("PMPNewUseri",job)
	 S ^PMPSYSUSER("PMPNewUser",job,iP,userid)=NewUserNameValue
	 S ^PMPSYSUSER("PMPNewUseri",job,userid)=NewUserNameValue
	 s ret="1"
	 q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取用户初始化密码
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).InitializationPassWord()
ClassMethod InitializationPassWord() As %String
{
	s ret="1"
	i $d(^PMPSysConfigure("Type","InitializationPassWord"))  d
	.s rowid=$o(^PMPSysConfigure("Type","InitializationPassWord",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取输入的密码是否正确 1 为正确
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).InitializationPassWord("1","1")
ClassMethod NewPassWordType(NewPassWordValue As %String, NewUserNameValue As %String) As %String
{
	s ret="0"
	q:NewPassWordValue="" "-1"
	q:NewUserNameValue="" "-2"
	q:'$d(^PMPProjectUser(NewUserNameValue)) "-3"
	i ##Class(web.SSUser).Encrypt($p(^PMPProjectUser(NewUserNameValue),"^",24))=NewPassWordValue S ret="1"
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取用户密码
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).PUUserAddPassWord("1")
ClassMethod PUUserAddPassWord(Rowid As %String) As %String
{
	s ret=""
	q:Rowid="" ""
	q:'$d(^PMPProjectUser(Rowid)) ""
	s ret=##class(web.findtable).Passwordn($p(^PMPProjectUser(Rowid),"^",24))
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 通过Userid进行转换 转换成工程师id
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).ConvertUser("1","")
ClassMethod ConvertUser(Userid As %String, IP As %String = "") As %String
{
	s ret=""
	i Userid="" S Userid=%session.Data("LOGON.USERID")
	i IP'="" d
	.S ret=$g(^PMPSYSUSER("PMPNewUser",$j,IP,Userid))
	i IP="" d
	.s IP=$O(^PMPSYSUSER("PMPNewUser",$j,""))
	.q:IP="" 
	.S ret=$g(^PMPSYSUSER("PMPNewUser",$j,IP,Userid))
	q ret
}

/// Creat  zzp  
/// date:2015-06-24
/// description: 通过需求id获取需求的问题描述和要求效果
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).IPMLSituation("123")
ClassMethod IPMLSituation(Rowid As %String) As %Text
{
	s ret=""
	q:Rowid="" ""
	i $d(^PMPImprovementList(Rowid))  d
	.s Situation=$P($g(^PMPImprovementList(Rowid)),"^",26)
	.s Standby3=$P($g(^PMPImprovementList(Rowid)),"^",34)
	.S Status=$P($g(^PMPImprovementList(Rowid)),"^",28)
	.s ret=Situation_"@@"_Standby3_"@@"_Status
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取需求变更的操作类型
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).IPMLEditType()
ClassMethod IPMLEditType() As %String
{
	s ret="213"
	i $d(^PMPSysConfigure("Type","IPMLEditType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","IPMLEditType",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取需求变更以后的状态
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).IPMLEditStatus()
ClassMethod IPMLEditStatus() As %String
{
	s ret="150"
	i $d(^PMPSysConfigure("Type","IPMLEditStatus"))  d
	.s rowid=$o(^PMPSysConfigure("Type","IPMLEditStatus",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp    
/// date:2015-06-24
/// description: 需求内容更新
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).EditUpdate("123@@234@@91")
ClassMethod EditUpdate(Input As %Text, Rowid As %String) As %String
{
	;s ^Temp("EditUpdate")=Input_"$$"_Rowid
	s ret="0"
	q:Input="" "-1"
	q:Rowid="" "-2"
	s Situation=$p(Input,"@@",1)
	S Standby3=$p(Input,"@@",2)
	s Status=$p(Input,"@@",3)
	s NewValue=Situation_"@@"_Standby3
	s SavetypeRet=..Savetype()
	s IPMLEditTypeRet=..IPMLEditType()
	s IPMLEditStatusRet=..IPMLEditStatus()
	s OldValue=$P($g(^PMPImprovementList(Rowid)),"^",26)_"@@"_$P($g(^PMPImprovementList(Rowid)),"^",34)
	s updateValue="新需求："_NewValue_"。原需求"_OldValue
	s Date=+$h,Time=$p($h,",",2)
	s UserId=%session.Data("LOGON.USERID")
	s IndependentUserRet=##class(web.PMP.Document).IndependentUser()
	s IndependentTypeRet2=##class(web.PMP.Document).IndependentType(UserId)
	i ((IndependentUserRet="Y")&(IndependentTypeRet2="Y")) S UserId=UserId_"||"_##class(web.PMP.Document).ConvertUser(UserId,"")
	i SavetypeRet=Status  d EditUpdateSave
	i SavetypeRet'=Status  d EditUpdateSub
	q ret
EditUpdateSave
    TS
    s object=##Class(User.PMPImprovementList).%OpenId(Rowid)
    s object.IPMLSituation=Situation
    s object.IPMLStandby3=Standby3
    ;s object.IPMLUpdateType="Y"
    s object.IPMLStandby6=OldValue
    ;s objectStatus=##Class(User.PMPDictionary3).%OpenId(IPMLEditStatusRet)
    ;s object.IPMLStatusDR=objectStatus
    S sc=object.%Save()
    if sc{
	    Tc
	    &sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Remark,IPMD_Flag) values (:Rowid,:Status,:Date,:Time,:UserId,:updateValue,:IPMLEditTypeRet))
	    }
	else{
		Tro
		}
	s ret=sc
	q ret
EditUpdateSub
    TS
    s object=##Class(User.PMPImprovementList).%OpenId(Rowid)
    s object.IPMLSituation=Situation
    s object.IPMLStandby3=Standby3
    s object.IPMLUpdateType="Y"
    s object.IPMLStandby6=OldValue
    s objectStatus=##Class(User.PMPDictionary3).%OpenId(IPMLEditStatusRet)
    s object.IPMLStatusDR=objectStatus
    S sc=object.%Save()
    if sc{
	    Tc
	    &sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Remark,IPMD_Flag) values (:Rowid,:IPMLEditStatusRet,:Date,:Time,:UserId,:updateValue,:IPMLEditTypeRet))
	    }
	else{
		Tro
		}
	s ret=sc
	q ret
}

/// Creat  zzp  
/// date:2015-06-03
/// description: 获取需求申请的操作类型
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).ApplicationType()
ClassMethod ApplicationType() As %String
{
	s ret="214"
	i $d(^PMPSysConfigure("Type","ApplicationType"))  d
	.s rowid=$o(^PMPSysConfigure("Type","ApplicationType",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-06-25
/// description: 获取需求审核用户是否允许修改需求内容
/// input:  
/// output: 
/// others: w ##class(web.PMP.Document).AllowApproval()
ClassMethod AllowApproval() As %String
{
	s ret="N"
	i $d(^PMPSysConfigure("Type","AllowApproval"))  d
	.s rowid=$o(^PMPSysConfigure("Type","AllowApproval",""))
	.s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

Storage Default
{
<Data name="DocumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.DocumentD</DataLocation>
<DefaultData>DocumentDefaultData</DefaultData>
<IdLocation>^web.PMP.DocumentD</IdLocation>
<IndexLocation>^web.PMP.DocumentI</IndexLocation>
<StreamLocation>^web.PMP.DocumentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
