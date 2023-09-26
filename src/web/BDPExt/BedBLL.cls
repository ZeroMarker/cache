Class web.BDPExt.BedBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// chenying
ClassMethod SaveEntity(Ceobj As web.BDPExt.BedEntity) As %String
{
	n (Ceobj,%session)
	s $zt="ERROR"
	s ImportResult=""
	///默认值
	s:Ceobj.BEDRcFlag="" Ceobj.BEDRcFlag="Y"
	s:Ceobj.ROOMNoOfRows="" Ceobj.ROOMNoOfRows="40"
	S Ceobj.ROOMDifferentSexPatients=$$ALPHAUP^SSUTIL4(Ceobj.ROOMDifferentSexPatients)
	if (Ceobj.ROOMDifferentSexPatients="DOESNOTMATTER") s Ceobj.ROOMDifferentSexPatients="D"
	else  if (Ceobj.ROOMDifferentSexPatients="WARNING") s Ceobj.ROOMDifferentSexPatients="W"
	else  if (Ceobj.ROOMDifferentSexPatients="NOTALLOWED") s Ceobj.ROOMDifferentSexPatients="N"
	s Ceobj.ROOMQuery=$CASE(Ceobj.ROOMQuery,"急诊等候区":"WE","病区等候区":"BA","多人病房":"MPR","空房":"SR",:"")  //Query
	// 楼层转为医院楼楼层id	likefan	20201202
	s Ceobj.ROOMFloorDR=##class(web.DHCBL.CT.CTLocBuildingFloor).GetFloorIDByDesc(Ceobj.ROOMFloorDR,Ceobj.LinkHospId)
	s Roomobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.PACRoom")
	s Bedobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.PACBed")

	Ts	
	s BEDRowID=""
	s BEDWARDParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("PAC_Ward",Ceobj.WARDCode,Ceobj.LinkHospId)
	if (BEDWARDParRef'="")
	{
		
		///房间
		s ROOMRowID=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("PAC_Room",Ceobj.ROOMCode,Ceobj.LinkHospId)  ///已存在的房间跳过导入
		if (ROOMRowID="")
		{
			s ROOMSaveResult=""
			s Roomobj.ROOMRowID=""
			s Roomobj.ROOMDesc=Ceobj.ROOMCode
			s ROOMSaveResult=##class(web.DHCBL.CT.PACRoom).SaveEntity(Roomobj)
			s ROOMRowID=##class(web.BDPExt.FunLib).GetResultRowId(ROOMSaveResult)
		}
		if (ROOMRowID'="")
		{
			if (Bedobj.BEDCode'="")  //床位
			{
				///床高^床宽^每行床位个数^行间距^列间距
				if ($d(^TMP("BDPExt","PACBed",BEDWARDParRef))=0){
					s ^TMP("BDPExt","PACBed",BEDWARDParRef)=Ceobj.BEDHeight_"^"_Ceobj.BEDWidth_"^"_Ceobj.BEDNumber_"^"_Ceobj.BEDSequence
				}
				///床位
				s Bedobj.BEDRowID=""
				s Bedobj.BEDWARDParRef=BEDWARDParRef
				s Bedobj.BEDRoomDR=ROOMRowID
				s Bedobj.BEDSequence=Ceobj.BEDSequence
				s BedSaveResult=##class(web.DHCBL.CT.PACBed).SaveEntity(Bedobj)
				s BEDRowID=##class(web.BDPExt.FunLib).GetResultRowId(BedSaveResult)
				if (BEDRowID="")
				{
					s ImportResult="床位:"_BedSaveResult				
				}	
			}
			else  //房间分配
			{
				
				//if CTLOCType="W"  等候区 ROOMQuery="BA"
				//if CTLOCType="EM"  等候区ROOMQuery="WE"
				s Wardroomobj=##class(web.Entity.CT.PACWardRoom).%New()
				s Wardroomobj.ROOMRowId=""
				s Wardroomobj.ROOMParRef=BEDWARDParRef
				s Wardroomobj.ROOMRoomDR=ROOMRowID
				s WardroomSaveResult=##class(web.DHCBL.CT.PACWardRoom).SaveEntity(Wardroomobj)
				s ROOMRowId=##class(web.BDPExt.FunLib).GetResultRowId(WardroomSaveResult)
				if (ROOMRowId="")
				{
					s ImportResult="房间分配:"_WardroomSaveResult				
				}
			}
			
		}
		else
		{
			s ImportResult="房间:"_ROOMSaveResult	
		}
	}
	else
	{
		s ImportResult="该病区不存在"	
	}
	
	if (ImportResult="")
	{
		Tc
		s ImportResult="{success:'true',id:'"_BEDRowID_"'}" 
	}
	else
	{
		Tro
	}
	q ImportResult
ERROR
	Q "导入失败"_$ze
}

/// chenying
/// update 2020-01-19
/// 重新生成本次导入涉及到的病区得床位得坐标
/// w ##class(web.BDPExt.BedBLL).SavePosition()
ClassMethod SavePosition() As %String
{
	n (%session)
	s BDPExtWARDRowID=0
	for  
	{	
		s BDPExtWARDRowID=$o(^TMP("BDPExt","PACBed",BDPExtWARDRowID)) q:BDPExtWARDRowID="" 
		///房间分配
		s WARDLocationDR=$p($g(^PAWARD(BDPExtWARDRowID)),"^",5) 
		s:WARDLocationDR'="" CTLOCType=$p($g(^CTLOC(WARDLocationDR)),"^",13) 
		s:WARDLocationDR="" CTLOCType=""
		s LinkHospId=$p($g(^CTLOC(WARDLocationDR)),"^",22)  //取病区对应科室的医院
		///快速设置床位图
		///2020-01-19而是根据序号生成床位图
		s BEDHeight=$p($g(^TMP("BDPExt","PACBed",BDPExtWARDRowID)),"^",1)
		s BEDWidth=$p($g(^TMP("BDPExt","PACBed",BDPExtWARDRowID)),"^",2)
		d ##class(web.DHCBL.CT.PACBed).QuickSetPACBedFloorInfo(BDPExtWARDRowID,BEDHeight,BEDWidth,"","","","","")
		
	}
	q "1"
}

/// Creator:陈莹
/// CreatDate:20170330
/// Description:清除床位、房间、房间分配（新装床位数据时调用）
/// d ##class(web.BDPExt.BedBLL).ClearData()
ClassMethod ClearData() As %String
{
	n
	k ^PAROOM
	k ^PAWARDA  //床位的子表
	s paward=0
	for 
	{
		s paward=$o(^PAWARD(paward)) q:paward=""
		s bedsub=0
		for 
		{
			s bedsub=$o(^PAWARD(paward,"BED",bedsub)) q:bedsub=""
			s RowId=paward_"||"_bedsub
			d ##class(User.PACBed).%DeleteId(RowId)
		}
		
		s roomsub=0
		for 
		{
			s roomsub=$o(^PAWARD(paward,"ROOM",roomsub)) q:roomsub=""
			s RowId=paward_"||"_roomsub
			d ##class(User.PACWardRoom).%DeleteId(RowId)
		}
		
		k ^PAWARD(paward,"ROOM",0)
		k ^PAWARD(paward,"BED",0)
	}
}

/// CreatDate: 2017-09-01
/// Description: 获取床位价格
/// Table：PAC_BedAdm , GetBedPriceById
/// Input：parref,childsub
/// Return：床位价格
/// w ##class(web.BDPExt.BedBLL).GetBedPrice("2","1")
ClassMethod GetBedPrice(ParRef, Childsub) As %String
{
	n (ParRef,Childsub,%session)
	q:(ParRef="")||(Childsub="") ""
	s Price=0
	s BEDBedTypeDR=$p($g(^PAWARD(ParRef,"BED",Childsub)),"^",2)
	if (BEDBedTypeDR'="")
	{
		//if ##class(web.DHCDocConfig).GetConfigNodeNew2("RollNotUseNewConfig")=1
		if $g(^DHCDocConfig("RollNotUseNewConfig"))=1  ///勾选，取床位类型维护页面医嘱项价格数据
		{
			s ARCIMRowId=$p($g(^PAC("BEDTP",BEDBedTypeDR)),"^",4)
			if ARCIMRowId'="" s Price=##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(ARCIMRowId)
		}
		else   //为0时，取医生站床位费用设置页面数据  DHC_PAC_BedTypeFeeItem
		{
			s BEDTPIChildsub=0
			for
			{
				s BEDTPIChildsub=$o(^PAC("BEDTP",BEDBedTypeDR,"FEE",BEDTPIChildsub)) q:BEDTPIChildsub=""
				s BEDTPIFeeType=$p($g(^PAC("BEDTP",BEDBedTypeDR,"FEE",BEDTPIChildsub)),"^",1)  //费用类型
				
				///只取附加费的医嘱价格 2018-04-02
				s Code=""
				if BEDTPIFeeType'="" s Code=$p($g(^PAC("FEETP",BEDTPIFeeType)),"^",1)
				if Code'="A" continue
				s BEDTPIARCIMDR=$p($g(^PAC("BEDTP",BEDBedTypeDR,"FEE",BEDTPIChildsub)),"^",2)
				s BEDTPIStartDate=$p($g(^PAC("BEDTP",BEDBedTypeDR,"FEE",BEDTPIChildsub)),"^",3)
				s BEDTPIEndDate=$p($g(^PAC("BEDTP",BEDBedTypeDR,"FEE",BEDTPIChildsub)),"^",4)
				if ((BEDTPIStartDate'="")&&(BEDTPIStartDate<=+$h))&&((BEDTPIEndDate="")||((BEDTPIEndDate'="")&&(BEDTPIEndDate>=+$h)))
				{
					s Price1=##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(BEDTPIARCIMDR)
					s Price=Price1+Price
				}
			}
	
		}
	}
	q Price
}

/// 2017-10-13
/// w ##class(web.BDPExt.BedBLL).GetDspValue(xparref,xrowid)
ClassMethod GetDspValue(xparref, xrowid) As %String
{
	n (xparref,xrowid)
	q:(xparref="")||(xrowid="") ""
	s ROOMDifferentSexPatients=""
	s RoomId=$p($g(^PAWARD(xparref,"BED",xrowid)),"^",3)
	
	if RoomId'=""
	{
		s ROOMDifferentSexPatients=$p($g(^PAROOM(RoomId)),"^",4)
		if ROOMDifferentSexPatients="D" s ROOMDifferentSexPatients="Does Not Matter"
		if ROOMDifferentSexPatients="W" s ROOMDifferentSexPatients="Warning"
		if ROOMDifferentSexPatients="N" s ROOMDifferentSexPatients="Not Allowed"
	}
	
	q ROOMDifferentSexPatients
}

}
