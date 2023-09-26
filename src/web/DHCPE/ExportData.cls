Class web.DHCPE.ExportData [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCPE.ExportData).ExportData("/tmp/DHCPE/DHCPEData/")
ClassMethod ExportData(DirName)
{
	s flag=..ExportStation(DirName)
	q:flag'=0 flag
	s flag=..ExportOrderDetail(DirName)
	q:flag'=0 flag
	s flag=..ExportODStand(DirName)
	q:flag'=0 flag
	s flag=..ExportODRelate(DirName)
	q:flag'=0 flag
	s flag=..ExportExpertDiagnosis(DirName)
	q:flag'=0 flag
	s flag=..ExportTemplate(DirName)
	q flag
}

/// w ##class(web.DHCPE.ExportData).ImportData("/tmp/")
ClassMethod ImportData(DirName)
{
   /*
	s fileName=DirName_"DHCPEStation.txt"
	d all^DHCPEIMPOrdSets()
	q 0
	//s flag=##class(web.DHCPE.IMPMenuAndCompont).CreateDirectory(DirName)
	//站点
	
	s fileName=DirName_"DHCPEStation.txt"
	s ret=$$all^DHCPEIMPStation(fileName)
	q:ret'=0 ret
	q ret
	
	
	//细项
	s fileName=DirName_"DHCPEOrderDetail.txt"
	s ret=$$all^DHCPEIMPOrderDetail(fileName)
	q:ret'=0 ret
	q ret

	
	//细项选择
	s fileName=DirName_"DHCPEODStandard.txt"
	                    
	s ret=$$all^DHCPEIMPODStandard(fileName)
	q:ret'=0 ret
	q ret
	
	
	//细项选择模版
	s fileName=DirName_"DHCPEODSTemplate.txt"
	s ret=$$all^DHCPEIMPODSTemplate(fileName)
	q:ret'=0 ret
	q 0
	*/
	//专家诊断
	s fileName=DirName_"DHCPEExpertDiagnosis.txt"
	s ret=$$all^DHCPEIMPExpertDiagnosis(fileName)
	q ret
}

/// w ##class(web.DHCPE.ExportData).ImportODRelate("/tmp/")
ClassMethod ImportODRelate(DirName)
{
	//细项与大项对照
	s fileName=DirName_"DHCPEOrderDetailRelate.txt"
	s ret=$$all^DHCPEIMPOrderDetailRelate(fileName)
	q:ret'=0 ret
}

/// w ##class(web.DHCPE.ExportData).DHCPEExportEDForResult("/tem/")
/// 导出协和自动添加建议的数据。。。  by sun 20130927
ClassMethod DHCPEExportEDForResult(DirName)
{
	s flag=##class(web.DHCPE.IMPMenuAndCompont).CreateDirectory(DirName)
 	;w "      flag:"_flag_""
	s f=##class(%File).%New(DirName_"DHCPEEDForResult.txt")
	;w !,"gg"
	d f.Open("WSN")
	;w !,"vv"
	
	s EDID=0
	f  s EDID=$o(^DHCPEED(EDID)) q:EDID=""  d
	.s EPID=0
	.s EDDesc=$p($g(^DHCPEED(EDID,"1")),"^",1)
	.q:'$d(^User.DHCPEExpressI("SourceIDIndex","ED",EDID))
	.s EPID=$o(^User.DHCPEExpressI("SourceIDIndex","ED",EDID,0))
	.;w !,"asd"
	.;w !,EDDesc
	.;d f.WriteLine("a")
	.d f.WriteLine(EDDesc)
	.
	.s sql="SELECT E_AfterBracket,E_ItemDR,E_ODStandardDR,E_Operator,E_PreBracket,E_Reference,E_Relation,E_Sex,E_SourceID,E_Type FROM sqluser.DHC_PE_Express where ID="_EPID
	.;w !,"sql"_sql
	.s rset = ##class(%ResultSet).%New()
	.
	.;q
	.d rset.Prepare(sql)
	.
 	.d rset.Execute()
 	.;w !,"a"
 	.;w !,(rset.Next(.sc))_"e",!
	.;s DirName=##class(web.DHCPE.IMPMenuAndCompont).Replace(DirName,"\","/")
	.q:'(rset.Next(.sc))
 	.q:'($SYSTEM.Status.IsOK(sc))
 	.s OneSt=""
	.s dataLength=rset.GetColumnCount()
	.;w !,"data"_rset.GetData(1)
	.;w !,"dataLength"_dataLength
	.s OneSt=""
 	.f i=1:1:dataLength  d
 	..s CurData=rset.GetData(i)
 	..;w !,CurData
 	..s:OneSt="" OneSt=CurData
 	..s:OneSt'="" OneSt=OneSt_$c(9)_CurData
 	.d f.WriteLine(OneSt)
 	.;w !,CurData
    d f.Close()
    q "aa"
}

/// w ##class(web.DHCPE.ExportData).ExportStation("d:/DHCPE/DHCPEData/")
ClassMethod ExportStation(DirName)
{
	n (DirName)
	s sql="SELECT st_code,st_desc,st_place,st_sequence,st_active FROM sqluser.DHC_PE_Station"
	s err=..ExportApp(sql,DirName,"DHCPEStation.txt")
	q err
}

/// w ##class(web.DHCPE.ExportData).ExportOrderDetail("d:/DHCPE/DHCPEData/")
ClassMethod ExportOrderDetail(DirName)
{
	n (DirName)
	s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	s sql="select od_parref->st_code,OD_Code,od_desc,OD_Type,od_unit,od_expression from dhc_pe_orderdetail where od_parref<"_LabStation_" and od_rowid in (select odr_od_dr from dhc_pe_orderdetailrelate where odr_sequence is not null)"
	s err=..ExportApp(sql,DirName,"DHCPEOrderDetail.txt")
	q err
}

ClassMethod ExportODStand(DirName)
{
	n (DirName)
	s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	s sql="select ods_parref->od_code,ods_sex,ods_textval,ods_unit,ods_min,ods_max,ods_naturevalue,ods_template from DHC_PE_ODStandard where +ods_rowid<"_LabStation_" and ods_parref in (select odr_od_dr from dhc_pe_orderdetailrelate where odr_sequence is not null )"
	s err=..ExportApp(sql,DirName,"DHCPEODStandard.txt")
	q err
}

ClassMethod ExportODRelate(DirName)
{
	n (DirName)
	s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	s sql="select odr_arcim_dr,odr_od_dr->od_code,odr_parent_dr,odr_cascade,ODR_Required from DHC_PE_OrderDetailRelate where odr_sequence is not null and +odr_od_dr <"_LabStation
	s err=..ExportApp(sql,DirName,"DHCPEOrderDetailRelate.txt")
	q err
}

/// w ##class(web.DHCPE.ExportData).ExportRelate()
ClassMethod ExportRelate()
{
	s Job=$J
	k ^TempDHCPE(Job)
	s StationID=0
	f  s StationID=$O(^DHCPEST(StationID)) q:(StationID="")  d
	.s StationDesc=$P(^DHCPEST(StationID),"^",2)
	.s StationSort=$P(^DHCPEST(StationID),"^",4)
	.s Sub=0
	.f  s Sub=$O(^DHCPEST(StationID,"O",Sub)) q:(Sub="")  d
	..s ItemID=$P(^DHCPEST(StationID,"O",Sub),"^",1)
	..s LocInfo=$G(^DHCPEStationOrder("Loc",ItemID))
	..i LocInfo="" d
	...s LocSort="999999"
	...s LocDesc=""
	..e  d
	...s LocID=$P(LocInfo,"^",1)
	...s LocSort=$P(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2)),"^",2)
	...s LocDesc=$P(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2)),"^",1)
	..s i=i+1
	..s ItemCode=$P(^ARCIM(+ItemID,1,1),"^",1)
	..s ItemDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemID)
	..s Item=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemID)
	..s PatItem=$G(^DHCPECTDataEx("PatItemSort",ItemID))
	..s:PatItem'="" PatItem=$P(^DHCPECTDataEx("PatItem",+PatItem),"^",1)
	..s PrintFlag=$G(^DHCPECTDataEx("DHCPEStationOrder","BaseInfoBar",ItemID))
	..;w ItemDesc,!
	..s ^TempDHCPE(Job,StationSort,StationID,LocSort,ItemID)=StationID_"^"_StationDesc_"^"_LocDesc_"^"_ItemCode_"^"_ItemDesc
	..;s OneStr=StationID_$c(9)_StationDesc_$c(9)_ItemCode_$c(9)_ItemDesc_$C(9)_Item
	..;d f.WriteLine(OneStr)
	s StationSort=""
	f  s StationSort=$O(^TempDHCPE(Job,StationSort)) q:StationSort=""  d
	.s StationID=""
	.f  s StationID=$O(^TempDHCPE(Job,StationSort,StationID)) q:StationID=""  d
	..q:StationID>2
	..s LocSort=""
	..f  s LocSort=$O(^TempDHCPE(Job,StationSort,StationID,LocSort)) q:LocSort=""  d
	...s ItemID=""
	...f  s ItemID=$O(^TempDHCPE(Job,StationSort,StationID,LocSort,ItemID)) q:ItemID=""  d
	....s Data=$G(^TempDHCPE(Job,StationSort,StationID,LocSort,ItemID))
	....s ODRID=0
	....f  s ODRID=$O(^DHCPEODR(0,"ARCIM",ItemID,ODRID)) q:ODRID=""  d
	.....s ODDetailID=$P(^DHCPEODR(ODRID),"^",2)
	.....s Sequence=$P(^DHCPEODR(ODRID),"^",3)
	.....s ODDetailCode=$P(^DHCPEST(+ODDetailID,"OD",$P(ODDetailID,"||",2)),"^",11)
	.....s ODDetailDesc=$P(^DHCPEST(+ODDetailID,"OD",$P(ODDetailID,"||",2)),"^",1)
	.....w Data_"^"_ODDetailCode_"^"_ODDetailDesc_"^"_Sequence,!
	k ^TempDHCPE(Job)
}

/// w ##class(web.DHCPE.ExportData).ExportED()
ClassMethod ExportED()
{
	s Job=$J
	k ^TempDHCPE(Job)
	s ID=0
	f  s ID=$O(^DHCPEED(ID)) q:ID=""  d
	.s Flag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",ID))
	.q:Flag="N"
	.s StationID=$P(^DHCPEED(ID,1),"^",7)
	.q:StationID=""
	.s STDesc=$P(^DHCPEST(StationID),"^",2)
	.s STLocID=$P(^DHCPEED(ID,1),"^",10)
	.i STLocID="" d
	..s STLocID="a"
	..s STLocDesc=""
	.e  d
	..s STLocDesc=$P(^DHCPEST(+STLocID,"STLOC",$P(STLocID,"||",2)),"^",1)
	.s Sort=$P(^DHCPEED(ID,1),"^",9)
	.s:Sort="" Sort="999999999999"
	.s EDCode=$P(^DHCPEED(ID,1),"^",6)
	.s EDDesc=$P(^DHCPEED(ID,1),"^",1)
	.s EDDesc=##class(web.DHCPE.Public.Setting).Replace(EDDesc,$C(13,10),"")
	.s HighFlag=$P(^DHCPEED(ID,1),"^",8)
	.s JY=$P(^DHCPEED(ID,"Detail"),"^",1)
	.s JY=##class(web.DHCPE.Public.Setting).Replace(JY,$C(13,10),"")
	.s ^TempDHCPE(Job,StationID,STLocID,Sort,ID)=STDesc_"^"_STLocDesc_"^"_EDCode_"^"_EDDesc_"^"_JY_"^"_Sort_"^"_HighFlag
	s f=##class(%File).%New("/tmp/dhcpe/ED.txt")
	d f.Open("WSN")
	s StationID=""
	f  s StationID=$O(^TempDHCPE(Job,StationID)) q:StationID=""  d
	.;q:StationID>7
	.s STLocID=""
	.f  s STLocID=$O(^TempDHCPE(Job,StationID,STLocID)) q:STLocID=""  d
	..s Sort=""
	..f  s Sort=$O(^TempDHCPE(Job,StationID,STLocID,Sort)) q:Sort=""  d
	...s ID=""
	...f  s ID=$O(^TempDHCPE(Job,StationID,STLocID,Sort,ID)) q:ID=""  d
	....s EDA=..GetEDA(ID)
	....s Info= $G(^TempDHCPE(Job,StationID,STLocID,Sort,ID))_"^"_EDA
	....d f.WriteLine(Info)
	k ^TempDHCPE(Job)
	d f.Close()
}

/// w ##class(web.DHCPE.ExportData).ExportExpertDiagnosis("/tem/ed.txt")
ClassMethod ExportExpertDiagnosis(DirName)
{
	n (DirName)
	s sql="select ED_RowID,ED_DiagnoseConclusion,ED_Detail,ED_Station_dr->st_desc, EDA_text,ED_RowId from DHC_PE_ExpertDiagnosis,DHC_PE_EDAlias where ED_rowid=EDA_ED_DR group by ed_code order by ED_Station_dr"
	s err=..ExportApp(sql,DirName,"DHCPEExpertDiagnosis.txt")
	q err
}

/// w ##class(web.DHCPE.ExportData).ExportArcItem("/tmp/dhcpe/")
ClassMethod ExportArcItem(DirName)
{
	s DirName=##class(web.DHCPE.IMPMenuAndCompont).Replace(DirName,"\","/")
 	;s flag=##class(web.DHCPE.IMPMenuAndCompont).CreateDirectory(DirName)
	;s f=##class(%File).%New(DirName_"DHCPEStationOrder.txt")
	;d f.Open("WSN")
	s Job=$J
	s i=0
	s StationID=0
	f  s StationID=$O(^DHCPEST(StationID)) q:(StationID="")  d
	.s StationDesc=$P(^DHCPEST(StationID),"^",2)
	.s StationSort=$P(^DHCPEST(StationID),"^",4)
	.s Sub=0
	.f  s Sub=$O(^DHCPEST(StationID,"O",Sub)) q:(Sub="")  d
	..s ItemID=$P(^DHCPEST(StationID,"O",Sub),"^",1)
	..s LocInfo=$G(^DHCPEStationOrder("Loc",ItemID))
	..i LocInfo="" d
	...s LocSort="999999"
	...s LocDesc=""
	..e  d
	...s LocID=$P(LocInfo,"^",1)
	...s LocSort=$P(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2)),"^",2)
	...s LocDesc=$P(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2)),"^",1)
	..s i=i+1
	..s ItemCode=$P(^ARCIM(+ItemID,1,1),"^",1)
	..s ItemDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemID)
	..s Item=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemID)
	..s PatItem=$G(^DHCPECTDataEx("PatItemSort",ItemID))
	..s:PatItem'="" PatItem=$P(^DHCPECTDataEx("PatItem",+PatItem),"^",1)
	..s PrintFlag=$G(^DHCPECTDataEx("DHCPEStationOrder","BaseInfoBar",ItemID))
	..;w ItemDesc,!
	..s ^TempDHCPE(Job,StationSort,StationID,LocSort,ItemID)=StationID_"^"_StationDesc_"^"_LocDesc_"^"_ItemCode_"^"_ItemDesc_"^"_PatItem_"^"_PrintFlag
	..;s OneStr=StationID_$c(9)_StationDesc_$c(9)_ItemCode_$c(9)_ItemDesc_$C(9)_Item
	..;d f.WriteLine(OneStr)
	s StationSort=""
	f  s StationSort=$O(^TempDHCPE(Job,StationSort)) q:StationSort=""  d
	.s StationID=""
	.f  s StationID=$O(^TempDHCPE(Job,StationSort,StationID)) q:StationID=""  d
	..s LocSort=""
	..f  s LocSort=$O(^TempDHCPE(Job,StationSort,StationID,LocSort)) q:LocSort=""  d
	...s ItemID=""
	...f  s ItemID=$O(^TempDHCPE(Job,StationSort,StationID,LocSort,ItemID)) q:ItemID=""  d
	....s Info=$G(^TempDHCPE(Job,StationSort,StationID,LocSort,ItemID))
	....w Info,!
	....;d f.WriteLine(Info)
	
	k ^TempDHCPE(Job)
	;d f.Close()
	w i,!
	q 0
}

ClassMethod GetEDA(EDID)
{
	s EDA=""
	Set rset = ##class(%ResultSet).%New()
	Set rset.ClassName = "web.DHCPE.DHCPEExpertDiagnosis"
	Set rset.QueryName = "EDAliasList"
	
	Do rset.Execute(EDID)
	While (rset.Next()) 
    {
	    s OneEDA=rset.Data("EDA_Text")
	    i EDA="" d
	    .s EDA=OneEDA
	    e  d
	    .s EDA=EDA_","_OneEDA
    }
    q EDA
}

/// w ##class(web.DHCPE.ExportData).ExportTemplate("/tmp/DHCPEData/")
ClassMethod ExportTemplate(DirName)
{
	s DirName=##class(web.DHCPE.IMPMenuAndCompont).Replace(DirName,"\","/")
 	s flag=##class(web.DHCPE.IMPMenuAndCompont).CreateDirectory(DirName)
	s f=##class(%File).%New(DirName_"DHCPEODSTemplate.txt")
	d f.Open("WSN")
	s ODSID=""
	f  s ODSID=$o(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSID)) q:ODSID=""  d
	.s ODCode=$P($G(^DHCPEST(+ODSID,"OD",$p(ODSID,"||",2))),"^",11)
	.s ODSDesc=$P($G(^DHCPEST(+ODSID,"OD",$p(ODSID,"||",2),"ODS",$p(ODSID,"||",3))),"^",2)
	.s Sort=0
	.s i=0
	.f  s Sort=$o(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSID,Sort)) q:Sort=""  d
	..s Detail=$G(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSID,Sort))
	..s i=i+1
	..s OneStr=ODCode_$c(9)_ODSDesc_$c(9)_i_$c(9)_Detail
	..d f.WriteLine(OneStr)
	d f.Close()
	q 0
}

ClassMethod ExportApp(sql, DirName, fileName)
{
	n (sql,fileName,DirName)
	s err=0
	s rset = ##class(%ResultSet).%New()
	d rset.Prepare(sql)
 	d rset.Execute()
 	s DirName=##class(web.DHCPE.IMPMenuAndCompont).Replace(DirName,"\","/")
 	s flag=##class(web.DHCPE.IMPMenuAndCompont).CreateDirectory(DirName)
	s f=##class(%File).%New(DirName_fileName)
	d f.Open("WSN")
 	While (rset.Next(.sc)) 
 	{
 		If ($SYSTEM.Status.IsOK(sc)) 
 		{
	 		s OneSt=""
	 		s dataLength=rset.GetColumnCount()
	 		s Flag="1"
	 		f i=1:1:dataLength
	 		{
		 		s CurData=rset.GetData(i)
		 		i (fileName="DHCPEOrderDetailRelate.txt")&&(i=1) d
		 		.w CurData,!
		 		.s CurData=$P($G(^ARCIM(+CurData,$p(CurData,"||",2),1)),"^",1)
		 		.w CurData,!
		 		i (fileName="DHCPEExpertDiagnosis.txt")&&(i=6) d
		 		.s CurData=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",CurData))
		 		.i CurData'="Y" s Flag=0
		 		i fileName="DHCPEExpertDiagnosis.txt" continue:i=6
		 		i OneSt=""
		 		{
			 		s OneSt=CurData
		 		}
		 		else
		 		{
			 		s OneSt=OneSt_$c(9)_CurData
		 		}
	 		}
	 		i Flag="1" d f.WriteLine(OneSt)
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        s err="err"
	        
 			q
 		}
 	}
 	d f.Close()
 	q err
}

// w ##class(web.DHCPE.ExportData).ExportPatItem()

ClassMethod ExportPatItem()
{
	s ID=""
	f  s ID=$O(^DHCPECTDataEx("PatItem",ID)) q:ID=""  d
	.w $G(^DHCPECTDataEx("PatItem",ID)),!
}

}
