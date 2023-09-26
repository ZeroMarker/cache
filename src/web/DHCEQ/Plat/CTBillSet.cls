Import SQLUser

/// Mozy	2021-6-20	设备打印单据配置信息
Class web.DHCEQ.Plat.CTBillSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTBillSet","GetBillSet")
Query GetBillSet() As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TBussType:%String,TSubTypes:%String,TFileType:%String,TFile:%String,THospitalDR:%String,THospital:%String,TEquipTypeIDs:%String,TEquipTypes:%String,TRemark:%String")
{
}

ClassMethod GetBillSetExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	Set index=1
	Set TRow=0
	Set BussTypeVal=""
	For  Set BussTypeVal=$o(^DHCEQCCode("DHCEQCBillSet",0,"Type","N",BussTypeVal)) Quit:(BussTypeVal="")  d
	.Set TBussType = $CASE(BussTypeVal,"1":"验收单","2":"入库单","3":"转移单","4":"退货减少单",:"没有定义")
	.Set TRemark=""
	.Set TableName = $CASE(BussTypeVal,"1":"DHCEQOpenCheckRequest","2":"DHCEQInStock","3":"DHCEQStoreMove","4":"DHCEQReturn",:"")
	.If TableName'="" Do
	..Set Name=$o(^DHCEQCCode("DHCEQCConditionFields",0,"Name",$ZConvert(TableName,"U"),""))
	..If Name'="" Do
	...Set FieldID=$o(^DHCEQCCode("DHCEQCConditionFields",0,"Name",$ZConvert(TableName,"U"),Name,0))
	...If FieldID'="" Set TRemark="子类型取值为[ "_TableName_" ]表的字段: "_$p(^DHCEQCCode("DHCEQCConditionFields",FieldID),"^",1)
	.
	.Set FileTypeVal=""
	.For  Set FileTypeVal=$o(^DHCEQCCode("DHCEQCBillSet",0,"Type","N",BussTypeVal,FileTypeVal)) Quit:(FileTypeVal="")  d
	..Set TFileType = $CASE(FileTypeVal,"0":"Excel","1":"润乾Raq",:"没有定义")
	..Set TRowID=0
	..For  Set TRowID=$o(^DHCEQCCode("DHCEQCBillSet",0,"Type","N",BussTypeVal,FileTypeVal,TRowID)) Quit:(TRowID="")  d
	...s TSubTypes = $p($g(^DHCEQCCode("DHCEQCBillSet",TRowID)),"^",2)
	...s TFile = $p($g(^DHCEQCCode("DHCEQCBillSet",TRowID)),"^",4)
	...s THospitalDR = $p($g(^DHCEQCCode("DHCEQCBillSet",TRowID)),"^",5)
	...s THospital = ##Class(web.DHCEQCommon).GetTrakNameByID("hos", THospitalDR)
	...s TEquipTypeIDs = $p($g(^DHCEQCCode("DHCEQCBillSet",TRowID)),"^",6)
	...s TEquipTypes=""
	...s num=$l(TEquipTypeIDs,",")
	...for i=1:1:num d
	....s info=$p(TEquipTypeIDs,",",i)
	....i TEquipTypes'="" s TEquipTypes=TEquipTypes_","
	....s TEquipTypes=TEquipTypes_##class(web.DHCEQCommon).GetTrakNameByID("equiptype", info)
	...d OutputRowGetBillSet
	
	Quit $$$OK
OutputRowGetBillSet
    Set TRow=TRow+1
	Set Data=$lb(TRow,TRowID,TBussType,TSubTypes,TFileType,TFile,THospitalDR,THospital,TEquipTypeIDs,TEquipTypes,TRemark)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBillSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBillSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBillSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBillSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 描述:删除
/// w ##Class(web.DHCEQ.Plat.CTBillSet).UpdateBillSet("^1^^0^888^^")
ClassMethod UpdateBillSet(val As %Library.String = "", apptype As %Library.String = "")
{
	Set $ZT="ERRORUpdateBillSet"
	s SQLCODE=0
	;s ^DHCEQMozy("web.DHCEQ.Plat.CTBillSet")=val
	i val="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	k PLIST
	s RowID=$p(val,"^",1)
	i apptype=1
	{
		&SQL(Update SQLUSER.DHC_EQCBillSet Set BS_InvalidFlag='Y' where BS_RowID=:RowID)
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	}
	s BussType=$p(val,"^",2)
	s PLIST(2)=BussType
	s SubTypes=##Class(web.DHCEQCommon).Trim($p(val,"^",3))
	s PLIST(3)=SubTypes
	s FileType=$p(val,"^",4)
	s PLIST(4)=FileType
	s File=##Class(web.DHCEQCommon).Trim($p(val,"^",5))
	s PLIST(5)=File
	s HospitalDR=$p(val,"^",6)
	s PLIST(6)=HospitalDR
	s ETypeIDs=$p(val,"^",7)
	s PLIST(7)=ETypeIDs
	s PLIST(8)="N"
	i RowID=""
	{
		s FindFlag=0
		; ^DHCEQCCode("DHCEQCBillSet",0,"Type","N",1,0,1)=""
		Set rowid=0
		For  Set rowid=$o(^DHCEQCCode("DHCEQCBillSet",0,"Type","N",BussType,FileType,rowid)) Quit:(rowid="")||(FindFlag>0)  d
		.Quit:SubTypes'=$p($g(^DHCEQCCode("DHCEQCBillSet",rowid)),"^",2)
		.;Quit:File'=$p($g(^DHCEQCCode("DHCEQCBillSet",rowid)),"^",4)
		.Quit:HospitalDR'=$p($g(^DHCEQCCode("DHCEQCBillSet",rowid)),"^",5)
		.Quit:ETypeIDs'=$p($g(^DHCEQCCode("DHCEQCBillSet",rowid)),"^",6)
		.Set FindFlag=1
		if (FindFlag > 0) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210")
		&SQL(Insert Into SQLUSER.DHC_EQCBillSet Values :PLIST())
		Set RowID=$g(%ROWID)
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQCBillSet Values :PLIST() where BS_RowID = :RowID) 
	}
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, RowID)
ERRORUpdateBillSet 
	Set ErrorMsg=$ZE	    				//得到系统返回的错误消息
 	Quit "ERRORUpdateBillSet"_ErrorMsg		//返回错误消息
}

/// w ##Class(web.DHCEQ.Plat.CTBillSet).GetOneBillSet(1)
ClassMethod GetOneBillSet(rowid As %Library.String = "")
{
	i rowid="" q ""
	s result=$g(^DHCEQCCode("DHCEQCBillSet",rowid))
	
	s resultex="^"		;BS_BussType
	i $p(result,"^",1)'="" d
	.s resultex=resultex_$CASE($p(result,"^",1),"1":"验收单","2":"入库单","3":"转移单","4":"退货减少单",:"没有定义")
	s resultex="^"		;BS_BussType
	i $p(result,"^",3)'="" d
	.s resultex=resultex_$CASE($p(result,"^",3),"0":"Excel","1":"润乾Raq",:"没有定义")
	s resultex=resultex_"^"		;BS_HospitalDR
	i $p(result,"^",5)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("hos", $p(result,"^",5))
	
	q result_resultex
}

/// w ##Class(web.DHCEQ.Plat.CTBillSet).GeteBSetFile(1)
ClassMethod GeteBSetFile(pBussType As %Library.String = "", pFileType As %Library.String = "", pEquipTypeDR As %Library.String = "", pSubTypes As %Library.String = "")
{
	Set (File,preFile)=""
	s preminnum=""
	s minnum=0	///模糊匹配数
	
	; ^DHCEQCCode("DHCEQCBillSet",0,"Type","N",1,0,1)=""
	Set BussType=0
	For  Set BussType=$o(^DHCEQCCode("DHCEQCBillSet",0,"Type","N",BussType)) Quit:(BussType="")||(File'="")  d
	.Quit:pBussType'=BussType
	.Set FileType=0
	.For  Set FileType=$o(^DHCEQCCode("DHCEQCBillSet",0,"Type","N",BussType,FileType)) Quit:(FileType="")||(File'="")  d
	..Quit:pFileType'=FileType
	..Set rowid=0
	..For  Set rowid=$o(^DHCEQCCode("DHCEQCBillSet",0,"Type","N",BussType,FileType,rowid)) Quit:(rowid="")||(File'="")  d
	...Set SubTypes=$p($g(^DHCEQCCode("DHCEQCBillSet",rowid)),"^",2)
	...Quit:(SubTypes'="")&&((","_SubTypes_",")'[(","_pSubTypes_","))
	...If (pSubTypes'="")&&(SubTypes="") s minnum=minnum+1
	...
	...Set LocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	...Set curHospital=$p($g(^DHCEQCCode("DHCEQCDepartment",+LocDR)),"^",8)
	...Set Hospital=$p($g(^DHCEQCCode("DHCEQCBillSet",rowid)),"^",5)
	...Quit:(Hospital'="")&&(curHospital'=Hospital)
	...If (Hospital="") Set minnum=minnum+1
	...
	...Set EquipTypeIDs=$p($g(^DHCEQCCode("DHCEQCBillSet",rowid)),"^",6)
	...Quit:(EquipTypeIDs'="")&&((","_EquipTypeIDs_",")'[(","_pEquipTypeDR_","))
	...If (pEquipTypeDR'="")&&(EquipTypeIDs="") s minnum=minnum+1
	...
	...i minnum=0 Set File=$p($g(^DHCEQCCode("DHCEQCBillSet",rowid)),"^",4)
	...i (minnum>0)&&((preminnum="")||(minnum<preminnum)) d
	....s preminnum=minnum
	....s preFile=$p($g(^DHCEQCCode("DHCEQCBillSet",rowid)),"^",4)
	
	i (File="")&&(preminnum>0) s File=preFile
	
	
	Quit File
}

}
