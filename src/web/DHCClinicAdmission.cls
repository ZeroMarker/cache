/// Creator：      	陈长青
/// CreatDate：    	2015-03-10
/// Description： 	编写与医嘱相关的代码
Class web.DHCClinicAdmission Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      	陈长青
/// CreatDate：    	2015-03-10
/// Description： 	根据拼音码或名称字符串查找医嘱项
/// Table：        	
/// Input:			filterDesc：医嘱项名称或别名过滤字符串，groupId：用户安全组ID，ctLocId：用户登录位置ID，opaId：手术病人申请排班ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindArcim","PTT","1")
Query FindArcim(filterDesc As %String, groupId As %String) As %Query(ROWSPEC = "Id,Code,Desc,Price,BaseUomId,BaseUomDesc,ItemCatId,ItemCatDesc,OrderCatId,OrderCatDesc,DefaultInstrId,DefaultInstrDesc,Manufacturer") [ SqlProc ]
{
}

ClassMethod FindArcimExecute(ByRef qHandle As %Binary, filterDesc As %String, groupId As %String, ctLocId As %String, opaId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	if (filterDesc="") Quit $$$OK
	set filterDesc=$$ALPHAUP^SSUTIL4(filterDesc)
	set orderId=0,itemCatStr=""
	for
	{
		set orderId=$order(^SSU("SSGRP",groupId,"SSORD",orderId))
		quit:(orderId="")
		set orderCatId=$piece(^SSU("SSGRP",groupId,"SSORD",orderId),"^",1)	//医嘱项大类ID
		set orderCatDesc=$piece($get(^OEC("ORCAT",orderCatId)),"^",2)
		set itemCatId=$piece(^SSU("SSGRP",groupId,"SSORD",orderId),"^",5)	//医嘱项子类ID
		
		set itemCatStr=itemCatId
		//医嘱项子类为空，那么通过医嘱项大类的索引查找所有的子类ID
		if (itemCatStr="")
		{
			for
			{
				set itemCatId=$order(^ARC("IC",0,"OrdCat",orderCatId,itemCatId))
				quit:(itemCatId="")
				
				if (itemCatStr="")
				{
					set itemCatStr=itemCatId	
				}
				else
				{
					set itemCatStr=itemCatStr_"^"_itemCatId		
				}
			}	
		}
		set itemCatCount=$length(itemCatStr,"^")
		for i=1:1:itemCatCount
		{
			set itemCatId=$piece(itemCatStr,"^",i)
			continue:(itemCatId="")
			set itemCatDesc=$piece($get(^ARC("IC",itemCatId)),"^",2)
			set itemSubscript=0
			for
			{
				set itemSubscript=$order(^ARCIM(0,"ARCIC_DR",itemCatId,itemSubscript))
				quit:(itemSubscript="")
				set itemVersion=0
				for
				{
					set itemVersion=$order(^ARCIM(0,"ARCIC_DR",itemCatId,itemSubscript,itemVersion))
					quit:(itemVersion="")
					set arcimId=itemSubscript_"||"_itemVersion
					set ifEffect=##class(web.DHCANOPCom).IfEffectOrd("",arcimId)
					continue:(ifEffect'="Y")
					//获取医嘱项的别名
					set aliasDesc="",aliasId=""
					for
					{
						set aliasId=$order(^ARC("ALIAS",0,"ARCIM",arcimId,aliasId))
						quit:(aliasId="")
						if (aliasDesc'="")
						{
							set aliasDesc=aliasDesc_"^"_$$ALPHAUP^SSUTIL4($piece(^ARC("ALIAS",aliasId),"^",6))
						}	
						else
						{
							set aliasDesc=aliasDesc_$$ALPHAUP^SSUTIL4($piece(^ARC("ALIAS",aliasId),"^",6))
						}
					}
					set itemDesc=$piece(^ARCIM(itemSubscript,itemVersion,1),"^",2)
					continue:(aliasDesc'[filterDesc)&(itemDesc'[filterDesc)
					set itemCode=$piece(^ARCIM(itemSubscript,itemVersion,1),"^",1)
					set itemPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,+$h,"","","","")
					set baseUomId=$piece($g(^ARCIM(itemSubscript,itemVersion,8)),"^",14)
					set baseUomDesc=""
					i baseUomId'="" set baseUomDesc=$piece($g(^CT("UOM",baseUomId)),"^",2)
					set drugFormId=$piece(^ARCIM(itemSubscript,itemVersion,1),"^",12)
					set drugMasterId=+drugFormId
					set drugFormSubId=$piece(drugFormId,"||",2)
					set defaultInstrId="",defaultInstrDesc=""
					if (drugFormSubId'="")
					{
						set defaultInstrId=$piece($get(^PHCD(drugMasterId,"DF",drugFormSubId,1)),"^",5)
						set defaultInstrDesc=$piece(^PHCIN(defaultInstrId),"^",2)
					}
					
					set drugManufacturerId=	$piece($get(^PHCD(drugMasterId,2)),"^",4)
					set manufacturer=$piece($get(^PHMNF(+drugManufacturerId)),"^",2) //厂商
					
					do OutputRow	
				}	
			}
			
		}
	}
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(arcimId,itemCode,itemDesc,itemPrice,baseUomId,baseUomDesc,itemCatId,itemCatDesc,orderCatId,orderCatDesc,defaultInstrId,defaultInstrDesc,manufacturer)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimExecute ]
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

ClassMethod FindArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2015-03-10
/// Description： 	查找医嘱项的等效单位、等效剂量
/// Table：        	PHC_DrgMast,PHC_DrgForm,PHC_FormDoseEquiv
/// Input:			arcimIdPara:医嘱项ID，多个ID以"^"连接
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindDoseEquiv","574||1^385||1")
Query FindDoseEquiv(arcimIdPara As %String) As %Query(ROWSPEC = "Id,EqualUomId,EqualUomDesc,EqualDoseQty,EqualDefaultDoseQty,ArcimId")
{
}

ClassMethod FindDoseEquivExecute(ByRef qHandle As %Binary, arcimIdPara As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set itemCount=$length(arcimIdPara,"^")
	for i=1:1:itemCount
	{
		set itemId=$piece(arcimIdPara,"^",i)
		continue:(itemId="")
		set itemSub=+itemId
		set itemVer=$piece(itemId,"||",2)
		set drugFormId=$piece(^ARCIM(itemSub,itemVer,1),"^",12)	
		set drugMasterId=+drugFormId
		set drugFormSubId=$piece(drugFormId,"||",2)
		continue:(drugFormSubId="")
		set equivSubId=0
		for
		{
			set equivSubId=$order(^PHCD(drugMasterId,"DF",drugFormSubId,"EQ",equivSubId))	
			quit:equivSubId=""
			set equalUomId=$piece(^PHCD(drugMasterId,"DF",drugFormSubId,"EQ",equivSubId),"^",1)
			set equalUomDesc=$piece($get(^CT("UOM",equalUomId)),"^",2)
			set equalDoseQty=$piece(^PHCD(drugMasterId,"DF",drugFormSubId,"EQ",equivSubId),"^",2)
			set equalDefaultDoseQty=$piece(^PHCD(drugMasterId,"DF",drugFormSubId,"EQ",equivSubId),"^",3)
			set equivId=drugMasterId_"||"_drugFormSubId_"||"_equivSubId
			do OutputRow
		}
	}
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(equivId,equalUomId,equalUomDesc,equalDoseQty,equalDefaultDoseQty,itemId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDoseEquivFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDoseEquivExecute ]
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

ClassMethod FindDoseEquivClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDoseEquivExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2015-03-11
/// Description： 	根据医嘱项的ID查找医嘱项信息
/// Table：        	ARC_ItmMast
/// Input:			arcimIdPara:医嘱项ID，多个ID以"^"连接
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindArcimById","12196||1^12195||1")
Query FindArcimById(arcimIdPara As %String) As %Query(ROWSPEC = "Id,Code,Desc,Price,BaseUomId,BaseUomDesc,ItemCatId,ItemCatDesc,OrderCatId,OrderCatDesc,DefaultInstrId,DefaultInstrDesc,Manufacturer")
{
}

ClassMethod FindArcimByIdExecute(ByRef qHandle As %Binary, arcimIdPara As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set itemCount=$length(arcimIdPara,"^")
	for i=1:1:itemCount
	{
		set itemId=$piece(arcimIdPara,"^",i)
		continue:(itemId="")
		set itemSub=+itemId
		set itemVer=$piece(itemId,"||",2)
		continue:'$data(^ARCIM(itemSub,itemVer))
		set itemCode=$piece(^ARCIM(itemSub,itemVer,1),"^",1)
		set itemDesc=$piece(^ARCIM(itemSub,itemVer,1),"^",2)
		set itemCatId=$piece(^ARCIM(itemSub,itemVer,1),"^",10)
		set itemCatDesc=$piece($get(^ARC("IC",itemCatId)),"^",2)
		set orderCatId=$piece($get(^ARC("IC",itemCatId)),"^",8)
		set orderCatDesc=$piece($get(^OEC("ORCAT",orderCatId)),"^",2)
		set itemPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",itemId,+$h,"","","","")
		set baseUomId=$piece(^ARCIM(itemSub,itemVer,8),"^",14)
		set baseUomDesc=""
		if (baseUomId'="")
		{
			set baseUomDesc=$piece($get(^CT("UOM",baseUomId)),"^",2)	
		}
		
		set drugFormId=$piece(^ARCIM(itemSub,itemVer,1),"^",12)
		set drugMasterId=+drugFormId
		set drugFormSubId=$piece(drugFormId,"||",2)
		set defaultInstrId="",defaultInstrDesc=""
		if (drugFormSubId'="")
		{
			set defaultInstrId=$piece($get(^PHCD(drugMasterId,"DF",drugFormSubId,1)),"^",5)
			set defaultInstrDesc=$piece(^PHCIN(defaultInstrId),"^",2)	
		}
		set drugManufacturerId=	$piece($get(^PHCD(drugMasterId,2)),"^",4)
		set manufacturer=$piece($get(^PHMNF(+drugManufacturerId)),"^",2) //厂商
		do OutputRow	
	}
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(itemId,itemCode,itemDesc,itemPrice,baseUomId,baseUomDesc,itemCatId,itemCatDesc,orderCatId,orderCatDesc,defaultInstrId,defaultInstrDesc,manufacturer)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcimByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimByIdExecute ]
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

ClassMethod FindArcimByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimByIdExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2014-11-12
/// Description： 	根据医嘱套的ID获取医嘱套的项目
/// Table：        	ARC_OrdSetDate,ARC_OrdSetDateItem
/// Input:			arcosId:医嘱套ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindArcosItems","")
Query FindArcosItems(arcosId As %String) As %Query(ROWSPEC = "Id,ArcimId,ArcimDesc,Qty,InstrId,InstrDesc,UomId,UomDesc,DoseQty")
{
}

ClassMethod FindArcosItemsExecute(ByRef qHandle As %Binary, arcosId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	set currentDate=+$h
	set activeDateFrom=$order(^ARCOS(arcosId,"DATE",0,"DateFrom",currentDate+1),-1)
	if (activeDateFrom'="")
	{
		set dateSubId=$order(^ARCOS(arcosId,"DATE",0,"DateFrom",activeDateFrom,""))
		if (dateSubId'="")
		{
			set itemSubId=0
			for
			{
				set itemSubId=$order(^ARCOS(arcosId,"DATE",dateSubId,"ITM",itemSubId))
				quit:(itemSubId="")
				set itemId=arcosId_"||"_dateSubId_"||"_itemSubId
				set itemValueString=^(itemSubId)
				set arcimId=$piece(itemValueString,"^",1)
				set arcimSub=+arcimId
				//set arcimVer=$piece(arcimId,"||",2)
				set arcimVer=$piece(itemId,"||",2)
				set arcimDesc=$piece(^ARCIM(arcimSub,arcimVer,1),"^",2)
				set itemQty=$piece(itemValueString,"^",2)
				set itemInstrId=$piece(itemValueString,"^",9)
				set itemInstrDesc=""
				if (itemInstrId'="")
				{
					//set itemInstrDesc=$piece($get(^PHCIN(defaultInstrId)),"^",2)
					set itemInstrDesc=$piece($get(^PHCIN(itemInstrId)),"^",2)	
				}
				set itemUomId=$piece(itemValueString,"^",10)
				set itemUomDesc=""
				if (itemUomId'="")
				{
					set itemUomDesc=$piece($get(^CT("UOM",itemUomId)),"^",2)	
				}
				set itemDoseQty=$piece(itemValueString,"^",13)
				do OutputRow
			}	
		}	
	}
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(itemId,arcimId,arcimDesc,itemQty,itemInstrId,itemInstrDesc,itemUomId,itemUomDesc,itemDoseQty)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcosItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcosItemsExecute ]
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

ClassMethod FindArcosItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcosItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2015-03-11
/// Description： 	获取医嘱项的接收科室
/// Table：        	
/// Input:			EpisodeID:就诊ID，locId:当前科室,arcimIdPara:医嘱项ID，多个ID以"^"连接
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindRecvLoc","","","")
Query FindRecvLoc(EpisodeID As %String, locId As %String, arcimIdPara As %String) As %Query(ROWSPEC = "Id,Desc,ArcimId")
{
}

ClassMethod FindRecvLocExecute(ByRef qHandle As %Binary, EpisodeID As %String, locId As %String, arcimIdPara As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set arcimCount=$length(arcimIdPara,"^")
	for i=1:1:arcimCount
	{
		set arcimId=$piece(arcimIdPara,"^",i)
		continue:(arcimId="")
		set recvLocResult=##class(web.DHCANCall).GetOrderItemRecloc("",arcimId,EpisodeID,locId)
		set recvLocId=$piece(recvLocResult,$char(3),1)
		set recvLocDesc=$piece(recvLocResult,$char(3),2)
		do OutputRow	
	}
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(recvLocId,recvLocDesc,arcimId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindRecvLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecvLocExecute ]
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

ClassMethod FindRecvLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecvLocExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2015-03-16
/// Description： 	获取麻醉方法
/// Table：        	ORC_AnaestMethod
/// Input:			queryDate:查询日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindAnaestMethod","")
Query FindAnaestMethod(queryDate) As %Query(ROWSPEC = "Id,Code,Desc,Type,ArcosId,DateFrom,DateTo") [ SqlProc ]
{
}

ClassMethod FindAnaestMethodExecute(ByRef qHandle As %Binary, queryDate) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	if (+queryDate<=0)
	{
		set queryDate=+$horolog	
	}
	
	set anaMethodId=0
	for
	{
		set anaMethodId=$order(^ORC("ANMET",anaMethodId))
		quit:(anaMethodId="")
		set anaMethodCode=$piece($get(^ORC("ANMET",anaMethodId)),"^",1)
		set anaMethodDesc=$piece($get(^ORC("ANMET",anaMethodId)),"^",2)
		set anaMethodType=$piece($get(^ORC("ANMET",anaMethodId)),"^",3)
		set arcosId=$piece($get(^ORC("ANMET",anaMethodId)),"^",4)
		set dateFrom=$piece($get(^ORC("ANMET",anaMethodId)),"^",5)
		set dateTo=$piece($get(^ORC("ANMET",anaMethodId)),"^",6)
		continue:(+dateTo>0)&((+dateTo<queryDate)!(+dateFrom>queryDate))
		continue:(+dateTo<=0)&(+dateFrom>queryDate)	
		do OutputRow
	}
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(anaMethodId,anaMethodCode,anaMethodDesc,anaMethodType,arcosId,dateFrom,dateTo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindAnaestMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnaestMethodExecute ]
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

ClassMethod FindAnaestMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnaestMethodExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2015-03-25
/// Description： 	获取病人信息
/// Table：        	PA_Adm,PA_PatMas
/// Input:			opaId:手术申请排班ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindPatientInfo","159")
Query FindPatientInfo(opaId) As %Query(ROWSPEC = "MasterID,EpisodeID,RegisterNo,MedicareNo,Name,Gender,Age,BirthDate,BloodType,PersonID,AdmReason,AdmissionDate,LocationId,Location,WardId,Ward,Complaints,hospitalDesc") [ SqlProc ]
{
}

ClassMethod FindPatientInfoExecute(ByRef qHandle As %Binary, opaId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set arrangeInfo=^DHCANOPArrange(opaId)
	set anaestId=$piece(arrangeInfo,"^",2)
	set EpisodeID=+anaestId
	set patMasterID=$piece(^PAADM(EpisodeID),"^",1)
	set patientInfo=^PAPER(patMasterID,"ALL")
	
	//病人登记号 统一调用病案的接口
	set registerNo=##class(web.DHCClinicCom).GetRegNobyEpisodeID(EpisodeID)
	
	//病人姓名
	set patientName=$piece(patientInfo,"^",1)
	
	//病人病案号(住院号) 统一调用病案的接口+20160922+dyl
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	;set medicareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID , .ErrMsg)
	;set medicareNo=##class(web.DHCClinicCom).GetMedicareNo(EpisodeID,"")
	
	
	//病人性别 存在没有性别的情况
	set genderId=$piece(patientInfo,"^",7)
	set gender=""
	if (genderId'="")
	{
		set gender=$piece($get(^CT("SEX",genderId)),"^",2)	
	}
	
	//病人年龄
	set birthDate=$piece(patientInfo,"^",6)
	set today=+$horolog
	;统一从计费接口走+20160922+dyl
	;set age=##class(web.DHCClinicCom).CalAge(birthDate,today)
	set age=##class(web.DHCBillInterface).GetPapmiAge(patMasterID,EpisodeID)
	
	//病人出生日期
	
	set birthDate=##class(web.DHCClinicCom).ConvertToDate(birthDate)
	
	//病人血型
	set bloodType=##class(web.DHCClinicCom).GetBloodType(registerNo)
	
	//病人身份证号
	set personID=$piece(patientInfo,"^",9)
	
	//病人身份(费用类型)
	set admReasonId=$piece(^PAADM(EpisodeID,1),"^",7)
	set admReason=""
	if (admReasonId'="")
	{
		set admReason=$piece($get(^PAC("ADMREA",admReasonId)),"^",2)	
	}
	
	//入院日期
	set admissionDate=$piece(^PAADM(EpisodeID),"^",6)
	set admissionDate=##class(web.DHCClinicCom).ConvertToDate(admissionDate)
	
	//科室
	set locationId=$piece(^DHCANOPArrange(opaId),"^",21)
	set location=""
	if (locationId'="")
	{
		set location=$piece($get(^CTLOC(locationId)),"^",2)	
		if ($piece(location,"-",2)'="") set location=$piece(location,"-",2)
	}
	//病区
	set wardId=$piece(^DHCANOPArrange(opaId),"^",32)
	set ward=""
	if (wardId'="")
	{
		set ward=$piece($get(^PAWARD(wardId)),"^",2)
		if ($piece(ward,"-",2)'="") set ward=$piece(ward,"-",2)	
	}
	
	//取医院名称 YuanLin 20170828
	s hospitalDesc=""
	s hospitalDesc=##class(web.DHCClinicCom).GetHospital()
	
	//主诉 统一从电子病历的接口获取
	s complaints=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID,"#TYPE:TextDesc#TID:1#TVER:0#ECODE:E0013")
	
	do OutputRow
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(patMasterID,EpisodeID,registerNo,medicareNo,patientName,gender,age,birthDate,bloodType,personID,admReason,admissionDate,locationId,location,wardId,ward,complaints,hospitalDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatientInfoExecute ]
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

ClassMethod FindPatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatientInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2015-03-25
/// Description： 	获取病人麻醉信息
/// Table：        	OR_Anaesthesia,OR_An_Oper_Anaest_Assistant
/// Input:			opaId:手术申请排班ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindAnaestInfo","159")
Query FindAnaestInfo(opaId) As %Query(ROWSPEC = "Id,AnaMethodId,AnaMethod,SupervisorId,Supervisor,AnaesthetistId,Anaesthetist,AnaestAssistantId,AnaestAssistant,AnaestNurseId,AnaestNurse,SourceType,AreaInDT,AreaOutDT,TheatreInDT,TheatreOutDT,AnaStartDT,AnaFinishDT,SurgStartDT,SurgFinishDT,PACUStartDT,PACUFinishDT,ASAClassId,ASAClass") [ SqlProc ]
{
}

ClassMethod FindAnaestInfoExecute(ByRef qHandle As %Binary, opaId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set arrangeInfo=^DHCANOPArrange(opaId)
	set anaestId=$piece(arrangeInfo,"^",2)
	set EpisodeID=+anaestId
	set anaestSub=$piece(anaestId,"||",2)
	set anaestInfo=^OR(EpisodeID,"ANA",anaestSub)
	
	//麻醉方法
	set anaMethodId=$piece(anaestInfo,"^",5)
	set anaMethodId=$translate(anaMethodId,"|","+")
	set anaMethodCount=$length(anaMethodId,"+")
	set anaMethod=""
	for i=1:1:anaMethodCount
	{
		set singleAnaMethodId=$piece(anaMethodId,"+",i)
		continue:(i=anaMethodCount)&(singleAnaMethodId="")
		set singleAnaMethod=""
		if (+singleAnaMethodId>0)
		{
			set singleAnaMethod=$piece($get(^ORC("ANMET",singleAnaMethodId)),"^",2)	
		}	
		if (i>1)
		{
			set anaMethod=anaMethod_"+"	
		}
		set anaMethod=anaMethod_singleAnaMethod
	}
	
	//麻醉指导医生
	set supervisorId=$piece(anaestInfo,"^",7)
	set supervisor=##class(web.DHCClinicCom).GetNameById(supervisorId)
	
	//麻醉医生
	set anaesthetistId=$piece(anaestInfo,"^",6)
	set anaesthetist=##class(web.DHCClinicCom).GetNameById(anaesthetistId)
	
	//麻醉助手 OR_An_Oper_Anaest_Assistant
	set operSub=$order(^OR(EpisodeID,"ANA",anaestSub,"OP",0))
	set anaestAssistant="",anaestAssistantId=""
	if (+operSub>0)
	{
		set assistantSub=0
		for
		{
			set assistantSub=$order(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"ANAASS",assistantSub))
			quit:(assistantSub="")
			set singleAssistantId=$piece(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"ANAASS",assistantSub),"^",1)
			set singleAssistant=##class(web.DHCClinicCom).GetNameById(singleAssistantId)
			if (anaestAssistantId="") set anaestAssistantId=anaestAssistantId_","
			if (anaestAssistant="") set anaestAssistant=anaestAssistant_","
			set anaestAssistantId=anaestAssistantId_singleAssistantId
			set anaestAssistant=anaestAssistant_singleAssistant
		}
	}
	
	//麻醉护士
	set anaestNurseId=$piece(anaestInfo,"^",8)
	set anaestNurse=##class(web.DHCClinicCom).GetNameById(anaestNurseId)
	
	//麻醉来源类型(择期或急诊)
	set sourceTypeCode=$piece(anaestInfo,"^",32)
	set sourceType="择期"
	if (sourceTypeCode="E") set sourceType="急诊"
	
	//入手术科室日期和时间、出手术科室日期和时间
	set areaInDate=$piece(anaestInfo,"^",35)
	set areaInTime=$piece(anaestInfo,"^",36)
	set areaInDT=##class(web.DHCClinicCom).ConvertToDateTime(areaInDate,areaInTime)
	set areaOutDate=$piece(anaestInfo,"^",37)
	set areaOutTime=$piece(anaestInfo,"^",38)
	set areaOutDT=##class(web.DHCClinicCom).ConvertToDateTime(areaOutDate,areaOutTime)
	
	//入手术间日期和时间、出手术间日期和时间
	set theatreInDate=$piece(anaestInfo,"^",39)
	set theatreInTime=$piece(anaestInfo,"^",40)
	set theatreInDT=##class(web.DHCClinicCom).ConvertToDateTime(theatreInDate,theatreInTime)
	set theatreOutDate=$piece(anaestInfo,"^",41)
	set theatreOutTime=$piece(anaestInfo,"^",42)
	set theatreOutDT=##class(web.DHCClinicCom).ConvertToDateTime(theatreOutDate,theatreOutTime)
	
	//麻醉开始日期和时间、结束日期和时间
	set anaStartDate=$piece(anaestInfo,"^",2)
	set anaStartTime=$piece(anaestInfo,"^",3)
	set anaStartDT=##class(web.DHCClinicCom).ConvertToDateTime(anaStartDate,anaStartTime)
	set anaFinishDate=$piece(anaestInfo,"^",29)
	set anaFinishTime=$piece(anaestInfo,"^",4)
	set anaFinishDT=##class(web.DHCClinicCom).ConvertToDateTime(anaFinishDate,anaFinishTime)
	
	//手术开始日期和时间、结束日期和时间
	set surgStartDate=anaStartDate
	set surgStartTime=$piece(anaestInfo,"^",19)
	if (surgStartTime<anaStartTime) s surgStartDate=surgStartDate+1
	set surgStartDT=##class(web.DHCClinicCom).ConvertToDateTime(surgStartDate,surgStartTime)
	set surgFinishDate=surgStartDate
	set surgFinishTime=$piece(anaestInfo,"^",20)
	if (surgFinishTime<surgStartTime) s surgFinishDate=surgFinishDate+1
	set surgFinishDT=##class(web.DHCClinicCom).ConvertToDateTime(surgFinishDate,surgFinishTime)
	
	//入恢复室日期和时间、出恢复室日期和时间
	set PACUStartDate=$piece(anaestInfo,"^",30)
	set PACUStartTime=$piece(anaestInfo,"^",23)
	set PACUStartDT=##class(web.DHCClinicCom).ConvertToDateTime(PACUStartDate,PACUStartTime)
	set PACUFinishDate=$piece(anaestInfo,"^",31)
	set PACUFinishTime=$piece(anaestInfo,"^",24)
	set PACUFinishDT=##class(web.DHCClinicCom).ConvertToDateTime(PACUFinishDate,PACUFinishTime)
	
	//ASA分级
	set ASAClassId=$piece(anaestInfo,"^",26)
	set ASAClass=""
	if (+ASAClassId>0)
	{
		set ASAClass=$piece($get(^ORC("ASA",ASAClassId)),"^",2)	
	}
	
	//麻醉分级
	
	//拟施麻醉
	
	do OutputRow
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(anaestId,anaMethodId,anaMethod,supervisorId,supervisor,anaesthetistId,anaesthetist,anaestAssistantId,anaestAssistant,anaestNurseId,anaestNurse,sourceType,areaInDT,areaOutDT,theatreInDT,theatreOutDT,anaStartDT,anaFinishDT,surgStartDT,surgFinishDT,PACUStartDT,PACUFinishDT,ASAClassId,ASAClass)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindAnaestInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnaestInfoExecute ]
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

ClassMethod FindAnaestInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnaestInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2015-03-26
/// Description： 	获取病人手术信息
/// Table：        	OR_Anaest_Operation
/// Input:			opaId:手术申请排班ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindOperationInfo","115")
Query FindOperationInfo(opaId) As %Query(ROWSPEC = "Id,OperationId,Operation,OperationDate,BladeTypeId,BladeType,SurgeonId,Surgeon,OperType,AssistantId,Assistant,OperPositionId,OperPosition,BodySiteId,BodySite,PreopDiagId,PreopDiag,PostopDiagId,PostopDiag,CirculNurseId,CirculNurse,ScrubNurseId,ScrubNurse") [ SqlProc ]
{
}

ClassMethod FindOperationInfoExecute(ByRef qHandle As %Binary, opaId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set arrangeInfo=^DHCANOPArrange(opaId)
	set anaestId=$piece(arrangeInfo,"^",2)
	set EpisodeID=+anaestId
	set anaestSub=$piece(anaestId,"||",2)
	set operationDate=##class(web.DHCClinicCom).ConvertToDate($piece(arrangeInfo,"^",14))
	set operSub=0
	for
	{
		set operSub=$order(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub))
		quit:(operSub="")
		set operationInfo=^OR(EpisodeID,"ANA",anaestSub,"OP",operSub)
		
		//手术麻醉ID
		set ANOPId=anaestId_"||"_operSub
		
		//手术名称
		set operationId=$piece(operationInfo,"^",6)
		set operation=""
		if (+operationId>0)
		{
			//ORC_Operation+20160922+dyl
			i operation="" set operation=$piece($get(^ORC("OPER",+operationId)),"^",2)
			e  set operation=operation_";"_$piece($get(^ORC("OPER",+operationId)),"^",2)
		}
		else
		{
			//非手术字典手术(医生手工输入的手术名称)
			i operation="" set operation=$piece($get(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"REM")),"^",2)	
			e  set operation=operation_";"_$piece($get(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"REM")),"^",2)	
		}
		//切口
		set bladeTypeId=$piece(operationInfo,"^",9)
		set bladeType=""
		if (+bladeTypeId>0)
		{
			//ORC_BladeType
			set bladeType=$piece($get(^ORC("BLDTP",bladeTypeId)),"^",2)		
		}
		
		//主刀医生
		set surgeonId=$piece(operationInfo,"^",8)	
		set surgeon=##class(web.DHCClinicCom).GetNameById(surgeonId)
		if (+surgeonId<=0)
		{
			//非院内医护人员(如：从其他医院请来的专家作为主刀医生)	
		}
		
		//手术类型(M:主手术、S:子手术)
		set operType=$piece(operationInfo,"^",12)
		
		//手术助手
		set assistantSub=0,assistantId="",assistant=""
		for
		{
			//OR_An_Oper_Assistant
			set assistantSub=$order(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"ASS",assistantSub))
			quit:(assistantSub="")
			set singleASSId=$piece(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"ASS",assistantSub),"^",1)
			set singleASS=##class(web.DHCClinicCom).GetNameById(singleASSId)
			if (assistantId'="") set assistantId=assistantId_","
			if (assistant'="") set assistant=assistant_","
			set assistantId=assistantId_singleASSId
			set assistant=assistant_singleASS	
		}
		
		//手术体位
		set positionSub=0,operPositionId="",operPosition=""
		for
		{
			//OR_An_Oper_Position
			set positionSub=$order(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"POS",positionSub))
			quit:(positionSub="")
			set singleOperPosId=$piece(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"POS",positionSub),"^",1)
			set singleOperPos=""
			if (+singleOperPosId>0)
			{
				//ORC_OperPosition
				set singleOperPos=$piece($get(^ORC("OPPOS",singleOperPosId)),"^",2)	
			}	
			if (operPositionId'="") set operPositionId=operPositionId_","
			if (operPosition'="") set operPosition=operPosition_","
			set operPositionId=operPositionId_singleOperPosId
			set operPosition=operPosition_singleOperPos
		}
		
		//手术部位
		set bodySiteId=+$piece(operationInfo,"^",24)
		set bodySite=""
		if (+bodySiteId>0)
		{
			//OEC_BodySite
			s bodySite=$piece($get(^OEC("BODS",bodySiteId)),"^",2)	
		}
		
		//术前诊断
		set preopDiagId=$piece(operationInfo,"^",4)
		set preopDiag=""
		if (+preopDiagId>0)
		{
			//MRC_ICDDx
			set preopDiag=$piece($get(^MRC("ID",preopDiagId)),"^",2)	
		}
		
		//术后诊断
		set postopDiagId=$piece(operationInfo,"^",4)
		set postopDiag=""
		if (+postopDiagId>0)
		{
			//MRC_ICDDx
			set postopDiag=$piece($get(^MRC("ID",postopDiagId)),"^",2)	
		}
		
		//巡回护士
		set circulNurseSub=0,circulNurseId="",circulNurse=""
		for
		{
			//OR_An_Oper_Circul_Nurse
			set circulNurseSub=$order(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"CIRN",circulNurseSub))
			quit:(circulNurseSub="")
			set singleCirculNurseId=$piece(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"CIRN",circulNurseSub),"^",1)
			set singleCirculNurse=##class(web.DHCClinicCom).GetNameById(singleCirculNurseId)
			if (circulNurseId'="") set circulNurseId=circulNurseId_","
			if (circulNurse'="") set circulNurse=circulNurse_","
			set circulNurseId=circulNurseId_singleCirculNurseId
			set circulNurse=circulNurse_singleCirculNurse	
		}
		
		//器械护士
		set scrubNurseSub=0,scrubNurseId="",scrubNurse=""
		for
		{
			//OR_An_Oper_Scrub_Nurse
			set scrubNurseSub=$order(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"SCN",scrubNurseSub))
			quit:(scrubNurseSub="")
			set singleScrubNurseId=$piece(^OR(EpisodeID,"ANA",anaestSub,"OP",operSub,"SCN",scrubNurseSub),"^",1)
			set singleScrubNurse=##class(web.DHCClinicCom).GetNameById(singleScrubNurseId)
			if (scrubNurseId'="") set scrubNurseId=scrubNurseId_","
			if (scrubNurse'="") set scrubNurse=scrubNurse_","
			set scrubNurseId=scrubNurseId_singleScrubNurseId
			set scrubNurse=scrubNurse_singleScrubNurse		
		}
		
		do OutputRow
	}

 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(ANOPId,operationId,operation,operationDate,bladeTypeId,bladeType,surgeonId,surgeon,operType,assistantId,assistant,operPositionId,operPosition,bodySiteId,bodySite,preopDiagId,preopDiag,postopDiagId,postopDiag,circulNurseId,circulNurse,scrubNurseId,scrubNurse)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOperationInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationInfoExecute ]
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

ClassMethod FindOperationInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
