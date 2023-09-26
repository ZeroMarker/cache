/// Description: 取有关检验的细项明细
Class web.DHCPE.TransOrderDetail Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// d ##class(web.DHCPE.TransOrderDetail).FormatODCode(1)
ClassMethod FormatODCode(SID)
{
	s id=0
	f  s id=$O(^DHCPEST(SID,"OD",id)) Q:(""=id)  d
	.s Code=SID_$Extract("0000",1,4-$Length(id))_id
	.&sql(
				update SQLUSER.DHC_PE_OrderDetail 
				set OD_Code=:Code
					, OD_Sequence=:Code
				where OD_ParRef=:SID and OD_ChildSub=:id
				
			)
	.s ODDR=SID_"||"_id
	.&sql(
				update SQLUSER.DHC_PE_OrderDetailRelate 
				set ODR_Sequence=:Code
				where ODR_OD_DR=:ODDR
				
			)
			
	.Q:("0"'=SQLCODE)
}

ClassMethod DeleteOldDetail(ARCITEMID)
{
	&SQL(delete from sqluser.DHC_PE_OrderDetail where od_rowid in (select ODR_OD_DR from sqluser.DHC_PE_OrderDetailRelate where ODR_ARCIM_DR=:ARCITEMID))
	s:SQLCODE=100 SQLCODE=0
	q:(SQLCODE'=0) SQLCODE
	&SQL(delete from sqluser.DHC_PE_OrderDetailRelate where ODR_ARCIM_DR=:ARCITEMID)
	s:SQLCODE=100 SQLCODE=0
	q SQLCODE
}

/// test: w ##class(web.DHCPE.TransOrderDetail).Main("9978||1")
/// return: "":Correct, else:Error.
ClassMethod Main(arcItemId As %String, StationID As %String = "")
{
	
	s labItemCode="", myCount="", retStr=""
	
	s CurLoc=%session.Get("LOGON.CTLOCID")
	//i StationID="" s labStationId=^DHCPESetting("DHCPE","StationId_Lab")
	i StationID="" s labStationId=^DHCPESetting("DHCPE","StationId_Lab",CurLoc)


	i StationID'="" s labStationId=StationID
	
	s TrakVerison=##class(web.DHCPE.Public.Setting).GetTrakVerison()
	
	////取检验医嘱的外部代码
	// 新版本
  	i "TrakCare"=TrakVerison d
 	.i ((TrakVerison="TrakCare")&&($g(arcItemId)'="")) Set labItemCode=##Class(web.DHCPE.TransResult).GetLabExtCode("TrakCare",arcItemId)
 	// 旧版本
	i "MedTrak"=TrakVerison d
	.// DHC_PE_StationOrder.{ STORD_ChildSub }
	.s STORDChildSub=""
	.s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, labStationId,STORDChildSub))
	.Q:(""=STORDChildSub)
	.// DHC_PE_StationOrder.{ STORD_ARCOS_DR }
	.s STORDARCOSDR=$P($G(^DHCPEST(labStationId, "O", STORDChildSub)),"^",3)
	.Q:(""=STORDARCOSDR)
	.// ARC_OrdSets.{ ARCOS_LabTrakTestSet }
	.s labItemCode=$P($G(^ARCOS(STORDARCOSDR)), "^", 11)
	;w labItemCode
	q:(""=labItemCode) "No Item"
	
	//i $G(^DHCPESetting("DHCPE","LisNewVersion"))="Y"{
	i $G(^DHCPESetting("DHCPE","LisNewVersion",CurLoc))="Y"{
		s DSequence=0
		s Hosp=0
		f  s Hosp=$O(^dbo.BTTestSetI("IndexCode",Hosp)) q:Hosp=""  d
		.s LisSetID=""
		.;f  s LisSetID=$O(^dbo.BTTestSetI("IndexCode",Hosp," "_labItemCode,LisSetID)) q:LisSetID=""  d
		.f  s LisSetID=$O(^dbo.BTTestSetI("IndexCode",Hosp,##class(web.DHCPE.DHCPECommon).LisIndexData(labItemCode),LisSetID)) q:LisSetID=""  d
		..s WorkGroupDR=0
		..f  s WorkGroupDR=$O(^dbo.BTTestSetLayoutI("IndexMaster",LisSetID,WorkGroupDR)) q:WorkGroupDR=""  d
		...s TestCodeDR=0
		...f  s TestCodeDR=$O(^dbo.BTTestSetLayoutI("IndexMaster",LisSetID,WorkGroupDR,TestCodeDR)) q:TestCodeDR=""  d
		....s detailCode=$LG(^dbo.BTTestCodeD(TestCodeDR),2)
		....s detailUnits=$LG(^dbo.BTTestCodeD(TestCodeDR),8)
		....s detailDesc=$LG(^dbo.BTTestCodeD(TestCodeDR),3)
		....s DSequence=DSequence+1
		....s myId=""
		....&sql(select OD_RowId into :myId from SQLUSER.DHC_PE_OrderDetail where OD_LabTrakCode=:detailCode)
		....i myId="" d
		.....&sql( insert into SQLUSER.DHC_PE_OrderDetail(
				OD_Parref, OD_Code, OD_Type,  OD_Unit,  OD_DESC, OD_LabTrakCode
			) values(:labStationId,:detailCode, 'N',:detailUnits,:detailDesc,:detailCode))
		.....q:SQLCODE'=0
		.....s myId=%ROWID
		
		....If myId'="" Do
		.....Set ODDR=""
		.....&sql(select ODR_OD_DR into :ODDR from SQLUSER.DHC_PE_OrderDetailRelate where ODR_ARCIM_DR=:arcItemId and ODR_OD_DR->OD_LabtrakCode=:detailCode)
		.....If (SQLCODE=100) Do
		
		......&sql(insert into SQLUSER.DHC_PE_OrderDetailRelate(
				ODR_ARCIM_DR, ODR_OD_DR, ODR_Required,odr_sequence
			) values(:arcItemId, :myId, 'Y',:DSequence))
		
		//q ""
		q 0
	}
	
	s detailIds="'zzz'"
  	s num=""
  	f  s num=$o(^TTAB("TS",labItemCode,0,num))  q:num=""  d
  	.s detailCode=$p($g(^TTAB("TS",labItemCode,0,num)),"\",8)
  	.//s str=$g(^TTAB("TC",CTTCCode))
  	.q:detailCode=""
  	.s detailDesc=$p($g(^TTAB("TC",detailCode)),"\",1)
  	.s detailUnits=$p($g(^TTAB("TC",detailCode)),"\",2)
  	.s detailActiveFlag=$p($g(^TTAB("TC",detailCode)),"\",19)
  	.i detailActiveFlag="Y"  d
	..s myId=""
	..&sql(select OD_RowId into :myId from SQLUSER.DHC_PE_OrderDetail where OD_LabTrakCode=:detailCode)
	..i myId="" d
	...&sql( insert into SQLUSER.DHC_PE_OrderDetail(
				OD_Parref, OD_Code, OD_Type,  OD_Unit,  OD_DESC, OD_LabTrakCode
			) values(:labStationId,:detailCode, 'N',:detailUnits,:detailDesc,:detailCode))
	...i SQLCODE'=0  s retStr=retStr_$c(10)_$c(13)_SQLCODE_"  insert into SQLUSER.DHC_PE_OrderDetail"
	...s myId=%ROWID
	..e  d
	...&sql(update SQLUSER.DHC_PE_OrderDetail 
				set  OD_Unit=:detailUnits, OD_DESC=:detailDesc, OD_LabTrakCode=:detailCode 
			where OD_RowID=:myId
			)
	..If myId'="" Do
	...Set ODDR=""
	...//b //1
	...&sql(select ODR_OD_DR into :ODDR from SQLUSER.DHC_PE_OrderDetailRelate where ODR_ARCIM_DR=:arcItemId and ODR_OD_DR->OD_LabtrakCode=:detailCode)
	...//b //2
	...If (SQLCODE=100) Do
	....s Order1=$p($G(^TTAB("TC",detailCode,1,labItemCode)),"\",1)
	....q:Order1=""
	....s LayOut=$p($G(^TTAB("TC",detailCode,1,labItemCode)),"\",2)
	....q:LayOut=""
	....s Sequence=$p($G(^TTAB("TS",labItemCode,LayOut,Order1)),"\",15)
	....&sql(insert into SQLUSER.DHC_PE_OrderDetailRelate(
				ODR_ARCIM_DR, ODR_OD_DR, ODR_Required,odr_sequence
			) values(:arcItemId, :myId, 'Y',:Sequence))
	....If SQLCODE'=0  s retStr=retStr_$c(10)_$c(13)_SQLCODE_"  insert into SQLUSER.DHC_PE_OrderDetailRelate"
	..
	..s SQLCODE=..TransStandard(myId)
	..i SQLCODE'=0  s retStr=retStr_$c(10)_$c(13)_SQLCODE_" ..TransStandard"
	..s detailIds=detailIds_", '"_myId_"'"
	//i detailIds="'zzz'" q "No ItemDetail"

	//-----删除多余的项目明细及对应表记录----
	s sqlWhere=" ODR_ARCIM_DR='"_arcItemId_"' and odr_OD_dr not in ("_detailIds_")" 
	//s sqlDeleteDetail="delete from SQLUSER.DHC_PE_OrderDetail where od_rowid in ( "
	//								_"select odr_od_dr from  SQLUSER.DHC_PE_OrderDetailRelate where "_sqlWhere_")"
	s sqlDeleteRelation="delete from SQLUSER.DHC_PE_OrderDetailRelate where "_sqlWhere
	
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Do result.Prepare(sqlDeleteRelation)
	s retStatus=result.Execute()
	//b:($$$ISOK(retStatus)'=1)	;sqlDeleteRelation
	//s retStr=##class(web.DHCPE.StationOrder).UpdateODRSequence(labStationId)
	q retStr
}

/// Creator：    xy 
/// CreatDate：  20211209
/// Description: 检验自动插入站点项目组合扩展表、细项表、细项扩展表，且进行大项细项关联
/// Input:  	 arcItemId:医嘱项ID, StationID:站点ID, LocID:科室ID, UserID:用户ID ,LocStr:科室组下没有对应的科室ID 
/// Return：     0(成功)
/// Debug: w ##class(web.DHCPE.TransOrderDetail).MainNew("9978||1")
ClassMethod MainNew(arcItemId As %String, StationID As %String = "", OrderDR, LocID, UserID, LocStr As %String = "")
{

	s ^temp("web.DHCPE.TransOrderDetail","MainNew")=$lb(arcItemId,StationID,OrderDR,LocID,UserID,LocStr)
	i StationID="" s labStationId=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
	i StationID'="" s labStationId=StationID
	
	i (LocStr="") {
		s LocStr=##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocIDByLocGrp(LocGrpID)
		i $p(LocStr,"^",1)="-1"  q "-1^科室组下没有对应的科室ID"
	}
    s SQLCODE=0
	s HOSPID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID) //根据科室找院区
 	s HOSPCode=$p($g(^CT("HOSP",HOSPID)),"^",1)
 	S HOSPCode=$$ALPHAUP^SSUTIL4(HOSPCode)
 	;s btHOSPID=$o(^dbo.BTHospitalI("IndexCode"," "_HOSPCode,0))
	s btHOSPID=$o(^dbo.BTHospitalI("IndexCode",##class(web.DHCPE.DHCPECommon).LisIndexData(HOSPCode),0))
	s TrakVerison=##class(web.DHCPE.Public.Setting).GetTrakVerison()
	
	/****************取检验医嘱的外部代码(仅考虑新版)************************/
	s labItemCode=""
  	i "TrakCare"=TrakVerison d
 	.i ((TrakVerison="TrakCare")&&($g(arcItemId)'="")) s labItemCode=##Class(web.DHCPE.TransResult).GetLabExtCode("TrakCare",arcItemId)
	q:(""=labItemCode) "-1^没有对应的外部代码"
	
	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",LocID))
	
	i (LisNewVersion="Y"){
		s DSequence=0
		s LisSetID=""
		//f  s LisSetID=$o(^dbo.BTTestSetI("IndexCode",btHOSPID," "_labItemCode,LisSetID)) q:LisSetID=""  d
		f  s LisSetID=$o(^dbo.BTTestSetI("IndexCode",btHOSPID,##class(web.DHCPE.DHCPECommon).LisIndexData(labItemCode),LisSetID)) q:LisSetID=""  d
		.s WorkGroupDR=0
		.f  s WorkGroupDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",LisSetID,WorkGroupDR)) q:WorkGroupDR=""  d
		..s TestCodeDR=0
		..f  s TestCodeDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",LisSetID,WorkGroupDR,TestCodeDR)) q:TestCodeDR=""  d
		...s detailCode=$lg(^dbo.BTTestCodeD(TestCodeDR),2)
		...s detailUnits=$lg(^dbo.BTTestCodeD(TestCodeDR),8)
		...s detailDesc=$lg(^dbo.BTTestCodeD(TestCodeDR),3)
		...s DSequence=DSequence+1
		...
		.../***********插入细项表 Start**********/
		...s myId=""
		...s UpdateDate=+$h,UpdateTime=$p($h,",",2),UpdateUserDR=UserID
		...s ExsistFlag=##class(web.DHCPE.CT.StatOrderDetail).IsExsistODDesc(StationID,"",LocID,detailCode)
		...i ExsistFlag="1" s myId=##class(web.DHCPE.CT.StatOrderDetail).GetOrdDetailIDByDesc(LocID,detailDesc) //根据细项描述获取该科室下得细项的ID
	    ...i ExsistFlag="0" d		
		....&sql( insert into SQLUSER.DHC_PE_OrderDetail
		(
			OD_ParRef,OD_Code,OD_Type,OD_Unit,
			OD_Desc,OD_LabTrakCode,OD_Sex,
			OD_UpdateDate,OD_UpdateTime,OD_UpdateUserDR
		) values(
			:labStationId,:detailCode,'N',:detailUnits,
			:detailDesc,:detailCode,'N',
			:UpdateDate,:UpdateTime,:UpdateUserDR
		))
		....i SQLCODE'=0 s SQLCODE="-1^插入细项表失败"
		....q:SQLCODE'=0
		....s myId=%ROWID
		....s ret=##class(User.DHCPEOrderDetail).SaveDataToPowerControl(myId,LocID,UserID,"N") //插入授权表
		....If ($p(ret,"^",1)="-1") s SQLCODE="-1^细项插入记录授权表失败"	 
		....q:SQLCODE'=0
		..../***********插入细项表 end**********/
		....
		..../***********插入细项扩展表 start**********/
		....f LISODSLocNum=1:1:$l(LocStr,"^") d
	    .....s CurLocID=$P(LocStr,"^",LISODSLocNum)
		.....s Summary="Y",NoPrint="N",ODSetID=""
		.....s UpdateDate=+$h,UpdateTime=$p($h,",",2),UpdateUserDR=UserID
		.....s OrdDetailSetID=""
		.....s OrdDetailSetID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_CurLocID,myId,0))
		.....i OrdDetailSetID=""  d
		......&sql(insert into sqluser.DHC_PE_OrderDetailSet
		(
			ODS_OrderDtlDR,ODS_LocDR,ODS_Summary,ODS_NoPrint,
			ODS_UpdateDate,ODS_UpdateTime,ODS_UpdateUserDR
		)values 
		(
			:myId,:CurLocID,:Summary,:NoPrint,
			:UpdateDate,:UpdateTime,:UpdateUserDR
		))
    	......b ;插入细项扩展表  SQLCODE
		......i SQLCODE'=0 s SQLCODE="-1^插入细项扩展表失败"
		......q:SQLCODE'=0
		......s ODSetID=%ROWID //细项扩展表ID
		......s ret=##class(User.DHCPEOrderDetailSet).SaveDataToPowerControl(ODSetID,CurLocID,UserID)
		......If ($p(ret,"^",1)="-1") s SQLCODE="-1^细项扩展表插入记录授权表失败"	 
		......q:SQLCODE'=0
		..../***********插入细项扩展表 end**********/
		....
		...e  d
		....&sql(update SQLUSER.DHC_PE_OrderDetail 
				set  OD_Unit=:detailUnits, OD_DESC=:detailDesc, OD_LabTrakCode=:detailCode 
				where OD_RowID=:myId
			)
	  	
	    .../***********插入大项细项组合表 start**********/
		...i myId'="" d
		....s UpdateDate=+$h,UpdateTime=$p($h,",",2),UpdateUserDR=UserID
		....s IsExsistODRelate=##class(web.DHCPE.CT.OrderDetailRelate).IsExsistODRelate(OrderDR,myId,LocID)
		....i (IsExsistODRelate="0") d
		.....&SQL(insert into sqluser.DHC_PE_OrderDetailRelate 
			(ODR_OrderDR,ODR_ARCIM_DR,ODR_OD_DR,ODR_Sequence,ODR_Required,ODR_NoActive,ODR_UpdateDate,ODR_UpdateTime,ODR_UpdateUserDR) 
			values(:OrderDR,:arcItemId,:myId,:DSequence,'Y','Y',:UpdateDate,:UpdateTime,:UpdateUserDR))
		.....i SQLCODE'=0 s SQLCODE="-1^插入大项细项组合表失败"
		.....q:SQLCODE'=0
 		.....b ;插入大项细项组合表  SQLCODE
 		.....s OrdDetRelateID=%ROWID //大项细项组合表ID
 		.....s ret=##class(User.DHCPEOrderDetailRelate).SaveDataToPowerControl(OrdDetRelateID,LocID,UserID,"N")
		.....If ($p(ret,"^",1)="-1") s SQLCODE="-1^大项细项组合插入记录授权表失败"	 
		.....q:SQLCODE'=0
 		.../***********插入大项细项组合表 end**********/
	
		q SQLCODE
	}
}

/// return: SQLCODE, 0-Correct;  else-error
ClassMethod TransStandard(OrderDetailId As %String)
{
	s labDetailId=""
	&sql(select OD_LabTrakCode into :labDetailId from SQLUSER.DHC_PE_OrderDetail where OD_RowId=:OrderDetailId)
	q:labDetailId="" 0
	s Flag="Y"
	&sql(delete from SQLUSER.DHC_PE_ODStandard where ODS_ParRef=:OrderDetailId )
	s Date=0
	f  s Date=$o(^TTAB("TC",labDetailId,4,Date)) q:Date=""  d
	.s Type=""
	.f  s Type=$o(^TTAB("TC",labDetailId,4,Date,Type)) q:Type=""  d
	..s Order=""
	..f  s Order=$o(^TTAB("TC",labDetailId,4,Date,Type,Order)) q:Order=""  d
	...s Sex=$p(^TTAB("TC",labDetailId,4,Date,Type,Order),"\",22)
	...s Min=$p(^TTAB("TC",labDetailId,4,Date,Type,Order),"\",1)
	...s Max=$p(^TTAB("TC",labDetailId,4,Date,Type,Order),"\",2)
	...s Age=$p(^TTAB("TC",labDetailId,4,Date,Type,Order),"\",23)
	...s MinAge=$p(Age,"-",1)
	...s MaxAge=$p(Age,"-",2)
	...&SQL(insert into SQLUSER.DHC_PE_ODStandard(
    			  ODS_ParRef, ODS_NatureValue, ODS_Sex
    			, ODS_min , ODS_Max, ODS_AgeMin, ODS_AgeMax) 
    			values (:OrderDetailId,:Flag,:Sex,:Min,:Max,:MinAge,:MaxAge))
	
	
	
	q 0
}

ClassMethod GetLisInterface(LocID As %String = "")
{
 
   i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    s flag="N"
	//s flag=$g(^DHCPESetting("DHCPE","LisInterface"))
	s flag=$g(^DHCPESetting("DHCPE","LisInterface",LocID))
	Q flag
}

}
