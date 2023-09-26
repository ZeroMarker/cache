Class web.BDPExt.RoomBedTypeBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// update2020-02-11
/// Function:保存房间类型和床位类型，两个表的数据保存互不影响，分两个事务
ClassMethod SaveEntity(Ceobj As web.BDPExt.RoomBedTypeEntity) As %String
{
	n (Ceobj,%session)
	s ImportResult=""
	
	///默认值 
	if Ceobj.ROOMTDateFrom="" s Ceobj.ROOMTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	if Ceobj.BEDTPDateFrom="" s Ceobj.BEDTPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	s RoomTypeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.PACRoomType")
	s BedTypeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.PACBedType")
	
	
	if (Ceobj.ROOMTCode'=""){
		
		s ROOMTRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("PAC_RoomType",Ceobj.ROOMTCode,Ceobj.LinkHospId)
		if (ROOMTRowId=""){
			Ts
			s RoomTypeobj.ROOMTRowId=""
			s RoomTypeSaveResult=##class(web.DHCBL.CT.PACRoomType).SaveEntity(RoomTypeobj)
			s ROOMTRowId=##class(web.BDPExt.FunLib).GetResultRowId(RoomTypeSaveResult)
			if (ROOMTRowId=""){
				Tro
				s ImportResult="房间类型:"_RoomTypeSaveResult		
			}
			else
			{
				Tc
			}
		}else{
			
			s ImportResult="房间类型:该代码已存在"
		}
	}
	s BEDTPRowId=""
	if (Ceobj.BEDTPCode'=""){
		
		s BEDTPRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("PAC_BedType",Ceobj.BEDTPCode,Ceobj.LinkHospId)
		if (BEDTPRowId="")
		{
			Ts
			s BedTypeobj.BEDTPRowId=""
			s BedTypeSaveResult=##class(web.DHCBL.CT.PACBedType).SaveEntity(BedTypeobj)
			s BEDTPRowId=##class(web.BDPExt.FunLib).GetResultRowId(BedTypeSaveResult)
			if (BEDTPRowId=""){
				Tro
				s ImportResult="床位类型:"_BedTypeSaveResult		
			}
			else
			{
				Tc
			}
		}else{
			s ImportResult="床位类型:该代码已存在"
		}
	}
	if (ImportResult="")
	{
		s ImportResult="{success:'true',id:'"_BEDTPRowId_"'}" 
	}
	
	q ImportResult
}

}
