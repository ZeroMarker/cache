Import SQLUser

Class web.DHCBPCEquip Extends %RegisteredObject
{

/// 根据条件查找设备相关信息
/// 查询条件：BPCEBPCEquipModelDr-设备型号；PurchaseDate-购买日期；
/// 			  BPCECode-设备院内编号；BPCENo-设备序列号
/// d ##class(%ResultSet).RunQuery("web.DHCBPCEquip","FindEquip","","","","")
Query FindEquip(BPCEBPCEquipModelDr, PurchaseDate As %String = "", BPCECode As %String = "", BPCENo As %String = "", Status As %String = "", hospId As %String = "") As %Query(ROWSPEC = "tBPCERowId:%String,tBPCECode:%String,tBPCEDesc:%String,tBPCENo:%String,tBPCEFromDate:%Date,tBPCEToDate:%Date,tBPCEStatus:%String,tBPCEStatusD:%String,tBPCENote:%String,tBPCEBPCEquipModelDr:%String,tBPCEBPCEquipModel:%String,tBPCEBPCEAbbre:%String,tBPCEBPCEquipMFDr:%String,tBPCEBPCEquipMFDesc:%String,tBPCESoftwareVersion:%String,tBPCEPart:%String,tBPCEInstallDate:%String,tBPCETotalWorkingHour:%Float,tBPCEPurchaseDate:%String,tBPCEPurchaseAmount:%String,tBPCEWarrantyYear:%String,installPerIdLtIn:%String,installPerNameLtIn:%String,installPersonOut:%String,keepPerIdList:%String,keepPerNameList:%String,tBPBEBedDr:%String,tBPBEBed:%String")
{
}

ClassMethod FindEquipExecute(ByRef qHandle As %Binary, BPCEBPCEquipModelDr, PurchaseDate As %String = "", BPCECode As %String = "", BPCENo As %String = "", Status As %String = "", hospId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i PurchaseDate'="" s PurchaseDate=##class(web.DHCANOPCom).ConvertToDateH(PurchaseDate)
 	i BPCEBPCEquipModelDr="" d
 	.s tBPCERowId=0
	.f  s tBPCERowId=$o(^DHCBPC("Equip",tBPCERowId)) q:tBPCERowId=""  d
		..s hospitalId=""
		..s DataAttributionDr=$lg(^DHCBPC("Equip",tBPCERowId),16)
		..i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
		..q:((hospitalId'="")&(hospId'=hospitalId))
	    ..s tBPCECode=$lg(^DHCBPC("Equip",tBPCERowId),2) // 院内编号
	    ..q:tBPCECode=""
	    ..q:(BPCECode'="")&&(BPCECode'=tBPCECode)
	    ..s tBPCEDesc=$lg(^DHCBPC("Equip",tBPCERowId),3)
	    ..q:tBPCEDesc=""
	    ..s tBPCENo=$lg(^DHCBPC("Equip",tBPCERowId),4) //设备序列号
	    ..q:(BPCENo'="")&&(BPCENo'=tBPCENo)
	    ..s tBPCEFromDate=$lg(^DHCBPC("Equip",tBPCERowId),5)
	    ..i tBPCEFromDate'="" s tBPCEFromDate=$zd(tBPCEFromDate,3)
	    ..s tBPCEToDate=$lg(^DHCBPC("Equip",tBPCERowId),6)
	    ..i tBPCEToDate'="" s tBPCEToDate=$zd(tBPCEToDate,3)
	    ..s tBPCEStatus=$lg(^DHCBPC("Equip",tBPCERowId),7)
	    ..q:(Status'="")&&(Status'=tBPCEStatus)
	    ..s:tBPCEStatus="US" tBPCEStatusD="在用"
	    ..s:tBPCEStatus="SC" tBPCEStatusD="报废"
	    ..s:tBPCEStatus="SP" tBPCEStatusD="备用"
	    ..s tBPCENote=$lg(^DHCBPC("Equip",tBPCERowId),8)
	    ..s tBPCEBPCEquipModelDr=$lg(^DHCBPC("Equip",tBPCERowId),1)
	    ..i tBPCEBPCEquipModelDr'="" d
	    ...s tBPCEBPCEquipModel=$lg(^DHCBPC("EquipModel",tBPCEBPCEquipModelDr),2)
	    ...s tBPCEBPCEAbbre=$lg($g(^DHCBPC("EquipModel",tBPCEBPCEquipModelDr)),3) //缩写
	    ...s tBPCEBPCEquipMFDr=$lg(^DHCBPC("EquipModel",tBPCEBPCEquipModelDr),4) //厂家id
	    ...i tBPCEBPCEquipMFDr'="" s tBPCEBPCEquipMFDesc=$lg(^DHCBPC("Manufacturer",tBPCEBPCEquipMFDr),2) //厂家名
	    ..s tBPCESoftwareVersion=$lg(^DHCBPC("Equip",tBPCERowId),9)
	    ..s tBPCEPart=$lg(^DHCBPC("Equip",tBPCERowId),10)
	    ..s tBPCEInstallDate=$lg(^DHCBPC("Equip",tBPCERowId),11)
	    ..i tBPCEInstallDate'="" s tBPCEInstallDate=$zd(tBPCEInstallDate,3)
	    ..s tBPCETotalWorkingHour=$lg(^DHCBPC("Equip",tBPCERowId),12)
	    ..s tBPCEPurchaseDate=$lg(^DHCBPC("Equip",tBPCERowId),13) //购买时间
	    ..q:(PurchaseDate'="")&&(PurchaseDate'=tBPCEPurchaseDate)
	    ..i tBPCEPurchaseDate'="" s tBPCEPurchaseDate=##class(web.DHCClinicCom).ConvertToDate(tBPCEPurchaseDate)
	    ..s tBPCEPurchaseAmount=$lg(^DHCBPC("Equip",tBPCERowId),14) //购买金额
	    ..;i tBPCEPurchaseAmount'="" s tBPCEPurchaseAmount=tBPCEPurchaseAmount_"万"
	    ..s tBPCEWarrantyYear=$lg(^DHCBPC("Equip",tBPCERowId),15) //保修年限
	    ..;i tBPCEWarrantyYear'="" s tBPCEWarrantyYear=tBPCEWarrantyYear_"年"
	    ..;安装人员院内
	    ..s installPerInfo=##class(web.DHCBPCEquipUser).GetEquipInUserInfo(tBPCERowId,"I")
	    ..s installPerIDLtIn=$p(installPerInfo,"^",1)
	    ..s installPerNameLtIn=$p(installPerInfo,"^",2)
	    ..;安装人员院外
	    ..s installPersonOut=##class(web.DHCBPCEquipUser).GetEquipOutUserInfo(tBPCERowId)
	    ..;保管人员
	    ..s keepPersonInfo=##class(web.DHCBPCEquipUser).GetEquipInUserInfo(tBPCERowId,"K")
	    ..s keepPerIdList=$p(keepPersonInfo,"^",1)
	    ..s keepPerNameList=$p(keepPersonInfo,"^",2)
	    ..;关联设备的床位
	   	..s tBPBERowId=0
	   	..s tBPBEBed="",tBPBEBedDr=""
		..f  s tBPBERowId=$o(^DHCBPBedEquip(tBPBERowId)) q:tBPBERowId=""  d
	    ...s tBPBEBPCEquipDr=$lg(^DHCBPBedEquip(tBPBERowId),2)
	    ...q:(tBPCERowId'="")&&(tBPCERowId'=tBPBEBPCEquipDr)
	    ...s tBPBEBedDr=$lg(^DHCBPBedEquip(tBPBERowId),1) ;床位id
	    ...i tBPBEBedDr'="" s tBPBEBed=$lg(^DHCBPC("Bed",tBPBEBedDr),2) ;床位名称
	    ..d OutputRow1
	e  d
	.s tBPCEBPCEquipModelDr=BPCEBPCEquipModelDr
	.s tBPCERowId=0
	.f  s tBPCERowId=$o(^DHCBPC("Equip",0,"BPCEquipModel",BPCEBPCEquipModelDr,tBPCERowId)) q:tBPCERowId=""  d
		..s hospitalId=""
		..s DataAttributionDr=$lg(^DHCBPC("Equip",tBPCERowId),16)
		..i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
		..q:((hospitalId'="")&(hospId'=hospitalId))
	    ..s tBPCECode=$lg(^DHCBPC("Equip",tBPCERowId),2) // 院内编号
	    ..q:tBPCECode=""
	    ..q:(BPCECode'="")&&(BPCECode'=tBPCECode)
	    ..s tBPCEDesc=$lg(^DHCBPC("Equip",tBPCERowId),3)
	    ..q:tBPCEDesc=""
	    ..s tBPCENo=$lg(^DHCBPC("Equip",tBPCERowId),4) //设备序列号
	    ..q:(BPCENo'="")&&(BPCENo'=tBPCENo)
	    ..s tBPCEFromDate=$lg(^DHCBPC("Equip",tBPCERowId),5)
	    ..i tBPCEFromDate'="" s tBPCEFromDate=$zd(tBPCEFromDate,3)
	    ..s tBPCEToDate=$lg(^DHCBPC("Equip",tBPCERowId),6)
	    ..i tBPCEToDate'="" s tBPCEToDate=$zd(tBPCEToDate,3)
	    ..s tBPCEStatus=$lg(^DHCBPC("Equip",tBPCERowId),7)
	    ..q:(Status'="")&&(Status'=tBPCEStatus)
	    ..s:tBPCEStatus="US" tBPCEStatusD="在用"
	    ..s:tBPCEStatus="SC" tBPCEStatusD="报废"
	    ..s:tBPCEStatus="SP" tBPCEStatusD="备用"
	    ..s tBPCENote=$lg(^DHCBPC("Equip",tBPCERowId),8)
	    ..;s tBPCEBPCEquipModelDr=$lg(^DHCBPC("Equip",tBPCERowId),1)
	    ..i tBPCEBPCEquipModelDr'="" d
	    ...s tBPCEBPCEquipModel=$lg(^DHCBPC("EquipModel",tBPCEBPCEquipModelDr),2) //设备型号
	    ...s tBPCEBPCEAbbre=$lg($g(^DHCBPC("EquipModel",tBPCEBPCEquipModelDr)),3) //缩写
	    ...s tBPCEBPCEquipMFDr=$lg(^DHCBPC("EquipModel",tBPCEBPCEquipModelDr),4) //厂家id
	    ...i tBPCEBPCEquipMFDr'="" s tBPCEBPCEquipMFDesc=$lg(^DHCBPC("Manufacturer",tBPCEBPCEquipMFDr),2) //厂家名
	    ..s tBPCESoftwareVersion=$lg(^DHCBPC("Equip",tBPCERowId),9)
	    ..s tBPCEPart=$lg(^DHCBPC("Equip",tBPCERowId),10)
	    ..s tBPCEInstallDate=$lg(^DHCBPC("Equip",tBPCERowId),11)
	    ..i tBPCEInstallDate'="" s tBPCEInstallDate=$zd(tBPCEInstallDate,3)
	    ..s tBPCETotalWorkingHour=$lg(^DHCBPC("Equip",tBPCERowId),12)
	    ..s tBPCEPurchaseDate=$lg(^DHCBPC("Equip",tBPCERowId),13) //购买时间
	    ..q:(PurchaseDate'="")&&(PurchaseDate'=tBPCEPurchaseDate)
	    ..i tBPCEPurchaseDate'="" s tBPCEPurchaseDate=##class(web.DHCClinicCom).ConvertToDate(tBPCEPurchaseDate)
	    ..s tBPCEPurchaseAmount=$lg(^DHCBPC("Equip",tBPCERowId),14) //购买金额
	    ..;i tBPCEPurchaseAmount'="" s tBPCEPurchaseAmount=tBPCEPurchaseAmount_"万"
	    ..s tBPCEWarrantyYear=$lg(^DHCBPC("Equip",tBPCERowId),15) //保修年限
	    ..;i tBPCEWarrantyYear'="" s tBPCEWarrantyYear=tBPCEWarrantyYear_"年"
	    ..;安装人员院内
	    ..s installPerInfo=##class(web.DHCBPCEquipUser).GetEquipInUserInfo(tBPCERowId,"I")
	    ..s installPerIDLtIn=$p(installPerInfo,"^",1)
	    ..s installPerNameLtIn=$p(installPerInfo,"^",2)
	    ..;安装人员院外
	    ..s installPersonOut=##class(web.DHCBPCEquipUser).GetEquipOutUserInfo(tBPCERowId)
	    ..;保管人员
	    ..s keepPersonInfo=##class(web.DHCBPCEquipUser).GetEquipInUserInfo(tBPCERowId,"K")
	    ..s keepPerIdList=$p(keepPersonInfo,"^",1)
	    ..s keepPerNameList=$p(keepPersonInfo,"^",2)
	    ..;关联设备的床位
	   	..s tBPBERowId=0
		..f  s tBPBERowId=$o(^DHCBPBedEquip(tBPBERowId)) q:tBPBERowId=""  d
	    ...s tBPBEBPCEquipDr=$lg(^DHCBPBedEquip(tBPBERowId),2)
	    ...q:(tBPCERowId'="")&&(tBPCERowId'=tBPBEBPCEquipDr)
	    ...s tBPBEBedDr=$lg(^DHCBPBedEquip(tBPBERowId),1) ;床位id
	    ...i tBPBEBedDr'="" s tBPBEBed=$lg(^DHCBPC("Bed",tBPBEBedDr),2) ;床位名称
	    ..d OutputRow1
	     
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCERowId,tBPCECode,tBPCEDesc,tBPCENo,tBPCEFromDate,tBPCEToDate,tBPCEStatus,tBPCEStatusD,tBPCENote,tBPCEBPCEquipModelDr,tBPCEBPCEquipModel,tBPCEBPCEAbbre,tBPCEBPCEquipMFDr,tBPCEBPCEquipMFDesc,tBPCESoftwareVersion,tBPCEPart,tBPCEInstallDate,tBPCETotalWorkingHour,tBPCEPurchaseDate,tBPCEPurchaseAmount,tBPCEWarrantyYear,installPerIDLtIn,installPerNameLtIn,installPersonOut,keepPerIdList,keepPerNameList,tBPBEBedDr,tBPBEBed)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEquipExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEquipExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 添加设备信息
/// W ##class(web.DHCBPCEquip).InsertEquip("0101","设备1","JB200K0101","2014-01-01","2014-11-30","SP","note6#@+_)(","3","01","HD","2014-10-10","1000","2013-01-01","","","","","","")
ClassMethod InsertEquip(bpcECode, bpcEDesc, bpcENo, bpcEFromDate, bpcEToDate, bpcEStatus, bpcENote, bpcEBPCEquipModelDr, bpcESoftwareVersion, bpcEPart, bpcEInstallDate, bpcETotalWorkingHour, bpcEPurchaseDate, bpcEPurchaseAmount, bpcEWarrantyYear, installPersonIn, installPersonOut, takeCarePerson, bedNo, hospId As %String = "") As %String
{
	q:bpcECode="" "设备院内编号不能为空!"
	q:bpcEBPCEquipModelDr="" "设备型号不能为空!"
	q:bpcENo="" "设备序列号不能为空！"
	s temRowid=$o(^DHCBPC("Equip",0,"Code",bpcECode,""))
	i temRowid'="" q "该设备已经存在！"

	Tstart //事务开始		
	s objEquip = ##class(User.DHCBPCEquip).%New()
	s objEquip.BPCECode=bpcECode
	s equipDesc=$lg(^DHCBPC("EquipModel",bpcEBPCEquipModelDr),3)
	s bpceDesc=equipDesc_"("_bpcENo_")"
	s objEquip.BPCEDesc=bpceDesc
	s objEquip.BPCENo=bpcENo
	;i bpcEFromDate'="" s objEquip.BPCEFromDate=$zdh(bpcEFromDate,3)
	s objEquip.BPCEFromDate=##class(web.DHCANOPCom).ConvertToDateH(bpcEFromDate)
	;i bpcEToDate'="" s objEquip.BPCEToDate=$zdh(bpcEToDate,3)
	s objEquip.BPCEToDate=##class(web.DHCANOPCom).ConvertToDateH(bpcEToDate)
	s objEquip.BPCEStatus=bpcEStatus
	s objEquip.BPCENote=bpcENote		
	i bpcEBPCEquipModelDr'=""
	{
	   s objEModel= ##class(User.DHCBPCEquipModel).%OpenId(bpcEBPCEquipModelDr)
	   s objEquip.BPCEBPCEquipModelDr=objEModel
	}
	s objEquip.BPCESoftwareVersion=bpcESoftwareVersion
	s objEquip.BPCEPart=bpcEPart
	i bpcEInstallDate'="" s objEquip.BPCEInstallDate=$zdh(bpcEInstallDate,3)
	s objEquip.BPCETotalWorkingHour=bpcETotalWorkingHour
	i bpcEPurchaseDate'="" s objEquip.BPCEPurchaseDate=##class(web.DHCANOPCom).ConvertToDateH(bpcEPurchaseDate)
	s objEquip.BPCEPurchaseAmount=bpcEPurchaseAmount
	s objEquip.BPCEWarrantyYear=bpcEWarrantyYear
	b ;000
	s saveStatus=objEquip.%Save()
	if $$$ISERR(saveStatus){
		Trollback
		do $System.Status.DisplayError(saveStatus)
	}else{
		s bpcEId=objEquip.%Id()
	}
	q:(+saveStatus=0) "数据保存失败!"
	
	;b ;00
	;插入安装人（院内）
	i installPersonIn'="" {
		f i=1:1:$l(installPersonIn,",")
		{
			s objEquipUser=##class(User.DHCBPCEquipUser).%New()
			D objEquipUser.BPCEUBPCEDrSetObjectId(bpcEId) //设备id
			;b ;000
			s userId=$p(installPersonIn,",",i)
			s objEquipUser.BPCEUUserDr=userId
			s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
			s objEquipUser.BPCEUUserName=userName
			s objEquipUser.BPCEUType="I" ;安装人类型为“I”
			s objEquipUser.BPCEUDate=##class(web.DHCANOPCom).ConvertToDateH("")
			s objEquipUser.BPCEUTime=##class(web.DHCANOPCom).ConvertToTimeH("")
			;b ;01
			s saveStatus=objEquipUser.%Save()
			;b ;02
			if $$$ISERR(saveStatus){
				Trollback
				do $System.Status.DisplayError(saveStatus)
			}
		}
		d objEquipUser.%Close()
	}
	;插入安装人（院外）
	i installPersonOut'=""{
		s objEquipUserOut=##class(User.DHCBPCEquipUser).%New()
		d objEquipUserOut.BPCEUBPCEDrSetObjectId(bpcEId) //设备id
		s objEquipUserOut.BPCEUUserDr=""
		s objEquipUserOut.BPCEUUserName=installPersonOut
		s objEquipUserOut.BPCEUType="I" ;安装人类型为“I”
		s objEquipUserOut.BPCEUDate=##class(web.DHCANOPCom).ConvertToDateH("")
		s objEquipUserOut.BPCEUTime=##class(web.DHCANOPCom).ConvertToTimeH("")
		s saveStatus=objEquipUserOut.%Save()
		if $$$ISERR(saveStatus){
			Trollback
			do $System.Status.DisplayError(saveStatus)
		}
		d objEquipUserOut.%Close()
	}
	;插入保管人员
	i takeCarePerson'=""{
		f i=1:1:$l(takeCarePerson,","){
			s objEquipTKUser=##class(User.DHCBPCEquipUser).%New()
			d objEquipTKUser.BPCEUBPCEDrSetObjectId(bpcEId) //指向型设备id
			s userId=$p(takeCarePerson,",",i)
			s objEquipTKUser.BPCEUUserDr=userId
			s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
			s objEquipTKUser.BPCEUUserName=userName
			s objEquipTKUser.BPCEUType="K"  ;保管人员类型为“I”
			s objEquipTKUser.BPCEUDate=##class(web.DHCANOPCom).ConvertToDateH("")
			s objEquipTKUser.BPCEUTime=##class(web.DHCANOPCom).ConvertToTimeH("")
			s saveStatus=objEquipTKUser.%Save()
			if $$$ISERR(saveStatus){
				Trollback
				do $System.Status.DisplayError(saveStatus)
			}
		}
		d objEquipTKUser.%Close()
	}
	tcommit
	d objEquip.%Close()
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCEquip")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCEquip",bpcEId,hospId)
    }
	q 0
}

/// d ##class(web.DHCBPCEquip).UpdateEquip(3,"A0102","Dialogonline","010010101A","2014-11-01","2014-11-12","SP","","6","1.0","HD","2014-11-02","20","2014-11-10","11.3","10","6536","刘猛,小伟,非凡","6536")
ClassMethod UpdateEquip(bpcEId, bpcECode, bpcEDesc, bpcENo, bpcEFromDate, bpcEToDate, bpcEStatus, bpcENote, bpcEBPCEquipModelDr, bpcESoftwareVersion, bpcEPart, bpcEInstallDate, bpcETotalWorkingHour, bpcEPurchaseDate, bpcEPurchaseAmount, bpcEWarrantyYear, installPersonIn, installPersonOut, takeCarePerson, bedNo, hospId As %String = "") As %String
{
	q:bpcEId="" "ID不能为空!"
	q:bpcECode="" "代码不能为空!"
	q:bpcEDesc="" "描述不能为空!"
	q:'##class(User.DHCBPCEquip).%ExistsId(bpcEId) "日志码表指针无对应记录!"
	s temRowid=""
	s temRowid=$o(^DHCBPC("Equip",0,"Code",bpcECode,temRowid))
	q:(temRowid'="")&&(bpcEId'=temRowid) "要修改的院内编号已经存在！"
	
	s objEquip = ##class(User.DHCBPCEquip).%OpenId(bpcEId)
	s objEquip.BPCECode=bpcECode	
	s objEquip.BPCENo=bpcENo
	s objEquip.BPCEFromDate=##class(web.DHCANOPCom).ConvertToDateH(bpcEFromDate)
	s objEquip.BPCEToDate=##class(web.DHCANOPCom).ConvertToDateH(bpcEToDate)
	//i bpcEFromDate'="" s objEquip.BPCEFromDate=$zdh(bpcEFromDate,3)
	//i bpcEToDate'="" s objEquip.BPCEToDate=$zdh(bpcEToDate,3)
	s objEquip.BPCEStatus=bpcEStatus
	s objEquip.BPCENote=bpcENote
	i bpcEBPCEquipModelDr'=""
	{
	   s objEModel= ##class(User.DHCBPCEquipModel).%OpenId(bpcEBPCEquipModelDr)
	   s objEquip.BPCEBPCEquipModelDr=objEModel
	   s equipDesc=$lg(^DHCBPC("EquipModel",bpcEBPCEquipModelDr),3)
	   s bpceDesc=equipDesc_"("_bpcENo_")"
	   s objEquip.BPCEDesc=bpceDesc
	}
	s objEquip.BPCESoftwareVersion=bpcESoftwareVersion
	s objEquip.BPCEPart=bpcEPart
	i bpcEInstallDate'="" s objEquip.BPCEInstallDate=$zdh(bpcEInstallDate,3)
	s objEquip.BPCETotalWorkingHour=bpcETotalWorkingHour
	i bpcEPurchaseDate'="" s objEquip.BPCEPurchaseDate=##class(web.DHCANOPCom).ConvertToDateH(bpcEPurchaseDate)
	s objEquip.BPCEPurchaseAmount=bpcEPurchaseAmount
	s objEquip.BPCEWarrantyYear=bpcEWarrantyYear
	Tstart //事务开始
	s updateStatus=objEquip.%Save()
	if $$$ISERR(updateStatus){
		Trollback
		do $System.Status.DisplayError(updateStatus)
	}
	q:(+updateStatus=0) "数据修改失败!"
	
	//===更新院内安装人员信息===
	;插入安装人（院内）
	s isExistFlag=0
	s install="I"
	s Error=0
	s updateDate=##class(web.DHCANOPCom).ConvertToDateH("")
	s updateTime=##class(web.DHCANOPCom).ConvertToTimeH("")
	s installPerInfo=##class(web.DHCBPCEquipUser).GetEquipInUserInfo(bpcEId,"I")
	s installPerInListOld=$p($g(installPerInfo),"^",1)
	
	i installPersonIn'="" d
	.f i=1:1:$l(installPersonIn,",") q:Error'=0  d
	..s userIdN=$p(installPersonIn,",",i)
	..s userNameN=$p($g(^SSU("SSUSR",userIdN)),"^",2)
	..s tRowId=""
	..s isExistFlag=0
	..f  s tRowId=$o(^DHCBPCEquipUser(0,"Equip",bpcEId,tRowId)) q:tRowId=""  d 
	...s tUserType=$lg($g(^DHCBPCEquipUser(tRowId)),2) //人员类型
	...q:(tUserType'="I")&&(tUserType'="")
	...s userDr=$lg($g(^DHCBPCEquipUser(tRowId)),3)
	...i userIdN=userDr s isExistFlag=1
	..i isExistFlag=0 d
	...&SQL(insert into DHC_BPC_EquipUser Values(:bpcEId,:install,:userIdN,:userNameN,:updateDate,:updateTime))
	...s Error=SQLCODE
	...i (Error'=0)&& (Error'=100) Trollback
	q:(Error'=0)&&(Error'=100) Error
	
	s isExistFlag=0
	s Error=0
	;旧的安装人员不在最新更新的人员中时，则将删除该旧的安装人员
	f i=1:1:$l(installPerInListOld,",") q:Error'=0  d
	.s userIdO=$P(installPerInListOld,",",i)
	.s isExistFlag=0
	.f j=1:1:$l(installPersonIn,",") q:Error'=0  d
	..s userIdNew=$P(installPersonIn,",",j)
	..i userIdO=userIdNew s isExistFlag=1
	.i isExistFlag=0 d
	..&SQL(delete from DHC_BPC_EquipUser where (BPCEU_BPCE_Dr=:bpcEId and BPCEU_User_Dr=:userIdO))
	..s Error=SQLCODE
	i (Error'=0)&& (Error'=100) Trollback
	q:(Error'=0)&&(Error'=100) Error
	
	//===更新院外安装人员信息===
	s Error=0
	i installPersonOut'="" d
	.s userIdOut=""
	.s equipUserRowid=""
	.s isExistFlag=0
	.f  s equipUserRowid=$o(^DHCBPCEquipUser(0,"Equip",bpcEId,equipUserRowid)) q:equipUserRowid=""  d
	..s tUserType=$lg($g(^DHCBPCEquipUser(equipUserRowid)),2) //人员类型
	..q:(tUserType'="I")&&(tUserType'="")
	..s userDr=$lg($g(^DHCBPCEquipUser(equipUserRowid)),3)
	..q:'((userDr=$c(0))!(userDr=""))
	..s isExistFlag=1
	..s outUserName=$lg($g(^DHCBPCEquipUser(equipUserRowid)),4) //院外人员
	..i outUserName'="" d
	...&SQL(update DHC_BPC_EquipUser set BPCEU_UserName=:installPersonOut where ID=:equipUserRowid)
	...s Error=SQLCODE
	...i (Error'=0)&&(Error'=100) Trollback
	.q:(Error'=0)&&(Error'=100)
	.;原院外安装人员不存在时
	.i isExistFlag=0 d 
	..s InstallNull=""
	..&SQL(insert into DHC_BPC_EquipUser Values(:bpcEId,:install,:InstallNull,:installPersonOut,:updateDate,:updateTime))
	..s Error=SQLCODE
	..i (Error'=0)&&(Error'=100) Trollback
	q:(Error'=0)&&(Error'=100) Error
	
	
	//===更新保管人员信息===
	;b ;30
	s Error=0
	s take="K"
	i takeCarePerson'="" d
	.f i=1:1:$l(takeCarePerson,",") q:Error'=0  d
	..s takeUserIdNew=$p(takeCarePerson,",",i)
	..s takeUserNameNew=$p($g(^SSU("SSUSR",takeUserIdNew)),"^",2)
	..s tRowId=""
	..s userDr=""
	..s isExistFlag=0
	..f  s tRowId=$o(^DHCBPCEquipUser(0,"Equip",bpcEId,tRowId)) q:tRowId=""  d 
	...s tUserType=$lg($g(^DHCBPCEquipUser(tRowId)),2) //人员类型
	...q:(tUserType'="K")&&(tUserType'="")
	...s userDr=$lg($g(^DHCBPCEquipUser(tRowId)),3)
	...i takeUserIdNew=userDr s isExistFlag=1
	..i isExistFlag=0 d
	...&SQL(insert into DHC_BPC_EquipUser Values(:bpcEId,:take,:takeUserIdNew,:takeUserNameNew,:updateDate,:updateTime))
	...s Error=SQLCODE
	...i (Error'=0)&& (Error'=100) Trollback
	q:(Error'=0)&&(Error'=100) Error
	
	s isExistFlag=0
	s Error=0
	;获得旧的保管人员
	s takeCarePersonListOld=##class(web.DHCBPCEquipUser).GetEquipInUserInfo(bpcEId,"K")
	s takeCarePersonListOld=$p($g(takeCarePersonListOld),"^",1)
	;旧的保管人员不在最新更新的人员中时，则将删除该旧的保管人员
	f i=1:1:$l(takeCarePersonListOld,",") q:Error'=0  d
	.s takeUserIdO=$P(takeCarePersonListOld,",",i)
	.s isExistFlag=0
	.f j=1:1:$l(takeCarePerson,",") q:Error'=0  d
	..s takeUserIdN=$P(takeCarePerson,",",j)
	..i takeUserIdO=takeUserIdN s isExistFlag=1
	.i isExistFlag=0 d
	..&SQL(delete from DHC_BPC_EquipUser where (BPCEU_BPCE_Dr=:bpcEId and BPCEU_User_Dr=:takeUserIdO))
	..s Error=SQLCODE
	..i (Error'=0)&& (Error'=100) Trollback
	.q:(Error'=0)&&(Error'=100) 
	tcommit
	d objEquip.%Close()
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCEquip")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCEquip",bpcEId,hospId)
    }
	q Error
}

/// d ##class(web.DHCBPCEquip).DeleteEquip(1)
ClassMethod DeleteEquip(bpcEId) As %String
{
	q:bpcEId="" "ID不能为空!"
	Tstart //事务开始
	;删除关联表数据
	s tRowId=""
	s Error1=0
	s tRowId=$o(^DHCBPCEquipUser(0,"Equip",bpcEId,tRowId))
	i tRowId'="" d
	.&SQL(delete from DHC_BPC_EquipUser where BPCEU_BPCE_Dr=:bpcEId)
	.i SQLCODE'=0 Trollback
	.i SQLCODE'=0 s Error1=SQLCODE
	q:Error1'=0 "数据删除失败!" 
	;删除主表数据
	s Error=0
	q:'##class(User.DHCBPCEquip).%ExistsId(bpcEId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCBPCEquip).%DeleteId(bpcEId)
	i (+deleteStatus=0) Trollback
	q:(+deleteStatus=0) "数据删除失败!" 
	tcommit
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCEquip")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBPCEquip",bpcEId)
    }
	q 0
}

Query FindBPCEStatus() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindBPCEStatusExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="N",Desc="正常"
	d OutputRow1
	s Id="I",Desc="无效"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCEStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCEStatusExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPCEStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCEStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindBPCEPart() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindBPCEPartExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="HD",Desc="HD"
	d OutputRow1
	s Id="HDF",Desc="HDF"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCEPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCEPartExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPCEPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCEPartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetEquipList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCE_BPCEquipModel_Dr As EquipModelId,
	   BPCE_Code As Code,
	   BPCE_Desc As Description,
	   BPCE_No As Number,
	   BPCE_FromDate As FromDate,
	   BPCE_ToDate As ToDate,
	   BPCE_Status As Status,
	   BPCE_Note As Note
	   FROM DHC_BPC_Equip
}

}
