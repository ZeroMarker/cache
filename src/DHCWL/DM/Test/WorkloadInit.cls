Class DHCWL.DM.Test.WorkloadInit Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.WorkloadInit).InitWorkloadMeta()

ClassMethod InitWorkloadMeta()
{
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("META:FACT")
	s ns=##class(DHCWL.DM.T.Namespace).MetaNamespace("/")
	s ds=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s obj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/WorkLoad.mf")
	if obj=""{
		s obj=##class(DHCWL.DM.T.MetaTableBase).%New()
		s obj.Type=type
		s obj.Namespace=ns
		s obj.Code="WorkLoad"
		s obj.Name="收入"
		s obj.Description="综合查询收入数据仓库"
		s obj.DSConfig=ds
		s obj.Creator="lhh"
		s obj.CreatedDate=+$h
		;s obj.RowKeyFields="WorkLoad_Rowid"
		d obj.%Save()
		w obj.%Id(),","
		s id=obj.%Id()
		q:id=""
		s master="MetaTableBase-MDS-"_obj.%Id()
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','DHC_WorkLoad'))
		w %ROWID,","
		;&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'catalog',''))
		;w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'EnumeratorClass','com.dhcwl.dm.adapter.jdbc.JDBCEnumeratorTable'))
		w %ROWID,","
		s status=##class(DHCWL.DM.I.Manage).MetaInfoBuild("/WorkLoad.mf")
	}
}

// d ##class(DHCWL.DM.Test.WorkloadInit).InitTheme()

ClassMethod InitTheme()
{
		s theme= ##class(DHCWL.DM.T.ThemeBase).BuildThemeFromMeta("/WorkLoad.mf","WorkLoad_OrdDate",$lb("WorkLoad_OrdDate","WorkLoad_RecDep_DR","WorkLoad_ItemOrd_DR","WorkLoad_ResDep_DR","WorkLoad_Type","WorkLoad_OrdTime","WorkLoad_StatDate","WorkLoad_StatTime","WorkLoad_ItemCat_DR","WorkLoad_BillGrp_DR","WorkLoad_BillSub_DR","WorkLoad_PAPMI_DR","WorkLoad_OrdStatus","WorkLoad_RecDoc_DR","WorkLoad_ResDoc_DR","WorkLoad_TarItem_DR","WorkLoad_PatDep_DR","WorkLoad_PatWard_DR","WorkLoad_PatDoc_DR","WorkLoad_Flag","WorkLoad_FlagDate","WorkLoad_ReceiptI_DR","WorkLoad_CasherO_DR","WorkLoad_UserDep_DR","WorkLoad_User_DR","WorkLoad_HoldFlag","WorkLoad_HoldFlagDate","WorkLoad_HoldDep_DR","WorkLoad_HoldDoc_DR","WorkLoad_ReceiptO_DR","WorkLoad_CasherI_DR","WorkLoad_DisDate","WorkLoad_DisFlag","WorkLoad_TarAC_dr","WorkLoad_TarSC_Dr","WorkLoad_TarOut_Dr","WorkLoad_TarEC_Dr","WorkLoad_TarMC_Dr","WorkLoad_TarIC_Dr","WorkLoad_FlagTime","WorkLoad_DataType","WorkLoad_ResMedUnitCareProv_dr","WorkLoad_RecMedUnitCareProv_dr","WorkLoad_PatMedUnitCareProv_dr","WorkLoad_AdmReason_DR","WorkLoad_TarMCNew_Dr","WorkLoad_SocialStatus_DR","WorkLoad_PHCC_DR","WorkLoad_PHCD_DR","WorkLoad_PHCDF_DR","WorkLoad_PHCIN_DR","WorkLoad_PatRoom_DR","WorkLoad_PatBed_DR","WorkLoad_Rowid","WorkLoad_PAADM_DR","WorkLoad_ARPBL_DR","WorkLoad_OEORI_DR","WorkLoad_PBDDR","WorkLoad_OEORE_Dr"),$lb("WorkLoad_UnitPrice","WorkLoad_Quantity","WorkLoad_TotalPrice","WorkLoad_PayorPrice","WorkLoad_DiscPrice","WorkLoad_PaSharePrice"))
    w theme,!
    d theme.ChangeDimType($lb("WorkLoad_Rowid","WorkLoad_PAADM_DR","WorkLoad_ARPBL_DR","WorkLoad_OEORI_DR","WorkLoad_PBDDR","WorkLoad_OEORE_Dr"),"R")
}

// d ##class(DHCWL.DM.Test.WorkloadInit).InitCube()

ClassMethod InitCube()
{
		s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/WorkLoad.t",$lb("WorkLoad_OrdDate","WorkLoad_RecDep_DR","WorkLoad_ItemOrd_DR","WorkLoad_ResDep_DR","WorkLoad_Type","WorkLoad_StatDate","WorkLoad_ItemCat_DR","WorkLoad_BillGrp_DR","WorkLoad_BillSub_DR","WorkLoad_PAPMI_DR","WorkLoad_OrdStatus","WorkLoad_RecDoc_DR","WorkLoad_ResDoc_DR","WorkLoad_TarItem_DR","WorkLoad_PatDep_DR","WorkLoad_PatWard_DR","WorkLoad_PatDoc_DR","WorkLoad_Flag","WorkLoad_FlagDate","WorkLoad_HoldFlag","WorkLoad_HoldFlagDate","WorkLoad_DisDate","WorkLoad_DisFlag","WorkLoad_TarAC_dr","WorkLoad_TarSC_Dr","WorkLoad_TarOut_Dr","WorkLoad_TarEC_Dr","WorkLoad_TarMC_Dr","WorkLoad_TarIC_Dr","WorkLoad_DataType","WorkLoad_AdmReason_DR","WorkLoad_TarMCNew_Dr","WorkLoad_SocialStatus_DR","WorkLoad_PatRoom_DR","WorkLoad_PatBed_DR"),$lb("WorkLoad_UnitPrice","WorkLoad_Quantity","WorkLoad_TotalPrice","WorkLoad_PayorPrice","WorkLoad_DiscPrice","WorkLoad_PaSharePrice"))
    if status'=$$$OK {
	    w status
	    q status
    }
    s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/WorkLoad.t",$lb("WorkLoad_OrdDate","WorkLoad_RecDep_DR","WorkLoad_ItemOrd_DR","WorkLoad_ResDep_DR","WorkLoad_Type","WorkLoad_OrdTime","WorkLoad_StatDate","WorkLoad_StatTime","WorkLoad_ItemCat_DR","WorkLoad_BillGrp_DR","WorkLoad_BillSub_DR","WorkLoad_PAPMI_DR","WorkLoad_OrdStatus","WorkLoad_RecDoc_DR","WorkLoad_ResDoc_DR","WorkLoad_TarItem_DR","WorkLoad_PatDep_DR","WorkLoad_PatWard_DR","WorkLoad_PatDoc_DR","WorkLoad_Flag","WorkLoad_FlagDate","WorkLoad_ReceiptI_DR","WorkLoad_CasherO_DR","WorkLoad_UserDep_DR","WorkLoad_User_DR","WorkLoad_HoldFlag","WorkLoad_HoldFlagDate","WorkLoad_HoldDep_DR","WorkLoad_HoldDoc_DR","WorkLoad_ReceiptO_DR","WorkLoad_CasherI_DR","WorkLoad_DisDate","WorkLoad_DisFlag","WorkLoad_TarAC_dr","WorkLoad_TarSC_Dr","WorkLoad_TarOut_Dr","WorkLoad_TarEC_Dr","WorkLoad_TarMC_Dr","WorkLoad_TarIC_Dr","WorkLoad_FlagTime","WorkLoad_DataType","WorkLoad_ResMedUnitCareProv_dr","WorkLoad_RecMedUnitCareProv_dr","WorkLoad_PatMedUnitCareProv_dr","WorkLoad_AdmReason_DR","WorkLoad_TarMCNew_Dr","WorkLoad_SocialStatus_DR","WorkLoad_PHCC_DR","WorkLoad_PHCD_DR","WorkLoad_PHCDF_DR","WorkLoad_PHCIN_DR","WorkLoad_PatRoom_DR","WorkLoad_PatBed_DR","WorkLoad_Rowid","WorkLoad_PAADM_DR","WorkLoad_ARPBL_DR","WorkLoad_OEORI_DR","WorkLoad_PBDDR","WorkLoad_OEORE_Dr"),$lb("WorkLoad_UnitPrice","WorkLoad_Quantity","WorkLoad_TotalPrice","WorkLoad_PayorPrice","WorkLoad_DiscPrice","WorkLoad_PaSharePrice"))
    if status'=$$$OK {
	    w status
	    q status
    }
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/WorkLoad.t")
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/WorkLoad.t")
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/WorkLoad.t")
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/WorkLoad.t")
}

// d ##class(DHCWL.DM.Test.WorkloadInit).InitThemeDimLinkPath()

ClassMethod InitThemeDimLinkPath()
{
	s theme= ##class(DHCWL.DM.T.ThemeBase).GetByPath("/WorkLoad.t")
    w theme.SetLinkPath("WorkLoad_RecDep_DR","/CTLOC.d")
    w theme.SetLinkPath("WorkLoad_ResDep_DR","/CTLOC.d")
    w theme.SetLinkPath("WorkLoad_PatDep_DR","/CTLOC.d")
    w theme.SetLinkPath("WorkLoad_PatWard_DR","/CTLOC.d")
    w theme.SetLinkPath("WorkLoad_RecDoc_DR","/CTPCP.d")
    w theme.SetLinkPath("WorkLoad_ResDoc_DR","/CTPCP.d")
    w theme.SetLinkPath("WorkLoad_PatDoc_DR","/CTPCP.d")
}

// d ##class(DHCWL.DM.Test.WorkloadInit).CreteThemeData("2018-02-01","2018-03-01")

// d ##class(DHCWL.DM.Test.WorkloadInit).CreteThemeData("2018-03-02","2018-04-01")

// d ##class(DHCWL.DM.Test.WorkloadInit).CreteThemeData("2018-04-02","2018-05-01")

ClassMethod CreteThemeData(sd, ed, rebuild As %Boolean = 0)
{
	s status=##class(DHCWL.DM.I.Manage).ThemeDataManualBuild("/WorkLoad.t",sd,ed,rebuild)
	w status
}

// d ##class(DHCWL.DM.Test.WorkloadInit).InitBaseDim()

ClassMethod InitBaseDim()
{
	s ds=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s ns=##class(DHCWL.DM.T.Namespace).MetaNamespace("/")
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("META:LOOKUP")
	s obj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/PA_PatMas.ml")
	if obj=""{
		s obj=##class(DHCWL.DM.T.MetaTableBase).%New()
		s obj.Type=type
		s obj.Namespace=ns
		s obj.Code="PA_PatMas"
		s obj.Name="病人基本信息"
		s obj.Description="病人基本信息"
		s obj.DSConfig=ds
		s obj.Creator="lhh"
		s obj.CreatedDate=+$h
		d obj.%Save()
		w obj.%Id(),","
		s id=obj.%Id()
		q:id=""
		s master="MetaTableBase-MDS-"_obj.%Id()
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','PA_PatMas'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
		w %ROWID,","
		s status=##class(DHCWL.DM.I.Manage).MetaInfoBuild("/PA_PatMas.ml")
		s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/PA_PatMas.ml","PAPMI_RowId")
	}
	
	s obj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/arc_itmmast.ml")
	if obj=""{
		s obj=##class(DHCWL.DM.T.MetaTableBase).%New()
		s obj.Type=type
		s obj.Namespace=ns
		s obj.Code="arc_itmmast"
		s obj.Name="病人基本信息"
		s obj.Description="病人基本信息"
		s obj.DSConfig=ds
		s obj.Creator="lhh"
		s obj.CreatedDate=+$h
		d obj.%Save()
		w obj.%Id(),","
		s id=obj.%Id()
		q:id=""
		s master="MetaTableBase-MDS-"_obj.%Id()
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','arc_itmmast'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
		w %ROWID,","
		s status=##class(DHCWL.DM.I.Manage).MetaInfoBuild("/arc_itmmast.ml")
		s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/arc_itmmast.ml","ARCIM_RowId")
	}
}

// d ##class(DHCWL.DM.Test.WorkloadInit).TestWorkload("2018-04-01","2018-04-30")

ClassMethod TestWorkload(sd, ed)
{
	;k ^TEMPCMPDCUBEDI,^TEMPCMPDCUBEDD   WorkLoad_TarMCNew_Dr
	s cql="rs1:{"_
            "from: /dw/dhcworkload.t,"_
            //"dims :  AdmType,"_
            //"dims :  null,"_
            //"dims: WorkLoad_Type,WorkLoad_RecDep_DR->LocCode,WorkLoad_RecDep_DR->LocDesc,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR as Name,"_
            //"dims: WorkLoad_OrdDate,WorkLoad_Type,WorkLoad_RecDep_DR->LocCode,WorkLoad_RecDep_DR->LocDesc,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR as Name,"_
            //"dims :WorkLoad_Type,WorkLoad_RecDep_DR->LocCode,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_
            //"dims : WorkLoad_OrdDate,WorkLoad_Type,WorkLoad_RecDep_DR,WorkLoad_RecDep_DR->Code,WorkLoad_RecDep_DR->Hospital->Name hospital,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_ 
            //"dims : WorkLoad_Rowid,WorkLoad_OEORI_DR,WorkLoad_OrdDate,WorkLoad_Type,WorkLoad_RecDep_DR,WorkLoad_RecDep_DR->Code,WorkLoad_RecDep_DR->Hospital->Name hospital,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,"_
            
            "metrics: sum(TotleFee) price,"_ //
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,"_ //
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count(WorkLoad_TotalPrice) ON (null),count() ON (WorkLoad_PAPMI_DR),count() ,"_ 
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count(WorkLoad_TotalPrice) ON (null),count() ON (WorkLoad_PAPMI_DR),count(),avg(WorkLoad_TotalPrice),median(WorkLoad_TotalPrice),min(WorkLoad_TotalPrice),max(WorkLoad_TotalPrice),"_ 
            //"metrics: sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,count(WorkLoad_TotalPrice) ON (null),count() ON (WorkLoad_PAPMI_DR),count(),avg(WorkLoad_TotalPrice),median(WorkLoad_TotalPrice),min(WorkLoad_TotalPrice),max(WorkLoad_TotalPrice),WorkLoad_TotalPrice,"_
            "filter:  (OrdDate between("_sd_","_ed_")) ,"_
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_"))&& WorkLoad_Type contain([I]) && WorkLoad_RecDep_DR->LocDesc [(内),"_
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_")) && WorkLoad_Type isnull(),"_ 
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_")) &&  WorkLoad_Type contain([O])  && WorkLoad_RecDep_DR->Code = (门诊西药房)  ,"_ 
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_"))  && WorkLoad_PatWard_DR->Code like(内%护%) ,"_ 
            //"filter:  (WorkLoad_OrdDate between("_sd_","_ed_"))  &&  WorkLoad_Type contain([O]) && WorkLoad_PAPMI_DR >= (4) && WorkLoad_PAPMI_DR <= (88) ,"_
            //"filter:  WorkLoad_Rowid = (297358) ,"_
            //"sort:WorkLoad_PAPMI_DR,"_  //WorkLoad_PAPMI_DR,WorkLoad_TotalPrice desc,
            "print:true,"_
          "};"
  ;s cql="rs1:{from:/workload.t,dims:WorkLoad_Type,WorkLoad_RecDep_DR->LocCode,WorkLoad_RecDep_DR->LocDesc,WorkLoad_PAPMI_DR,WorkLoad_PAPMI_DR->PAPMI_Name as Name,metrics:sum(WorkLoad_TotalPrice) price,sum(WorkLoad_TotalPrice) ON (WorkLoad_Type) As AdmSumPrice,sum(WorkLoad_TotalPrice) ON (null) allPrice,filter:(WorkLoad_OrdDate between(2018-03-23,2018-03-23)),}"
	s cql="rs1:{from: /DW/DHCWorkLoad.t , metrics: sum(TotleFee) AS Test , filter: (OrdDate between(2016-06-22,2016-06-22) && PatDep->CTD_Desc like(中%)) && AdmType =(I)}"
	s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: AdmType AS AdmType,PatDep->CTD_Code AS DepCode,PatDep->CTD_Desc AS DepDesc,PatDoc AS PatDoc,PatDoc->CTCP_Desc AS DocName,RecDep->CTD_Desc AS locDesc , metrics: sum(TotleFee) AS 中西医科住院收入 , filter: ((OrdDate between(2015-06-22,2019-06-22) && AdmType =()) && PatDep->CTD_Desc like(中%)) && AdmType =(I)}"
	s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: AdmType AS AdmType,PatDep->CTD_Code AS DepCode,PatDep->CTD_Desc AS DepDesc,PatDoc AS PatDoc,PatDoc->CTCP_Desc AS DocName,RecDep->CTD_Desc AS locDesc , metrics: sum(TotleFee) AS 同期住院收入 , filter: OrdDate->M_DAY_CODE between(2015-07-22,2015-07-28)}"
	s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: OrdDate->M_DAY_LONG_DESC AS dim1,AdmType AS AdmType,PatDep->CTD_Code AS DepCode,PatDep->CTD_Desc AS DepDesc,PatDoc AS PatDoc,PatDoc->CTCP_Desc AS DocName,RecDep->CTD_Desc AS locDesc , metrics: sum(TotleFee) AS 上期住院收入3 , filter: OrdDate->M_DAY_CODE between(2016-07-20,2016-07-27)}"
	s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: PatDep->Group(testloc,desc) AS 归组测试 , metrics: sum(TotleFee) AS 上期收入3 , filter: OrdDate->M_DAY_CODE between(2016-06-19,2016-08-27)}"
	s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: PatDep->CTD_Code AS dim1 , metrics: sum(TotleFee) AS N020001,sum(TotleFee) AS S0010001,sum(Quantity) AS S0010005 , filter: OrdDate->M_DAY_CODE between(2016-06-01,2016-07-01) && AdmType =(I,O,E,H) && PatDepHos->CTH_Code =('BFCode||2','BFCode||3') && PatDep->CTD_Code =('BFCode||1','BFCode||2','BFCode||3','BFCode||4','BFCode||5','BFCode||6','BFCode||7','BFCode||8','BFCode||9','BFCode||10','BFCode||11','BFCode||12','BFCode||13','BFCode||14','BFCode||15','BFCode||16','BFCode||17','BFCode||18','BFCode||19','BFCode||20','BFCode||21','BFCode||22','BFCode||23','BFCode||24','BFCode||25','BFCode||26','BFCode||27','BFCode||28','BFCode||29','BFCode||30','BFCode||31','BFCode||32','BFCode||33','BFCode||34','BFCode||35','BFCode||36','BFCode||37','BFCode||38','BFCode||39','BFCode||40','BFCode||41','BFCode||42','BFCode||43','BFCode||44','BFCode||45','BFCode||46','BFCode||47','BFCode||48','BFCode||49','BFCode||50','BFCode||51','BFCode||52','BFCode||53','BFCode||54','BFCode||55','BFCode||56','BFCode||57','BFCode||58','BFCode||59','BFCode||60','BFCode||61','BFCode||62','BFCode||63','BFCode||64','BFCode||65','BFCode||66','BFCode||67','BFCode||68','BFCode||69','BFCode||70','BFCode||71','BFCode||72','BFCode||73','BFCode||74','BFCode||75','BFCode||76','BFCode||77','BFCode||78','BFCode||79','BFCode||80','BFCode||81','BFCode||82','BFCode||83','BFCode||84','BFCode||85','BFCode||86','BFCode||87','BFCode||88','BFCode||89','BFCode||90','BFCode||91','BFCode||92','BFCode||93','BFCode||94','BFCode||95','BFCode||96','BFCode||97','BFCode||98','BFCode||99','BFCode||100','BFCode||101','BFCode||102','BFCode||103','BFCode||104','BFCode||105','BFCode||106','BFCode||107','BFCode||108','BFCode||109','BFCode||110','BFCode||111','BFCode||112','BFCode||113','BFCode||114','BFCode||115','BFCode||116','BFCode||117','BFCode||118','BFCode||119','BFCode||120','BFCode||121','BFCode||122','BFCode||123','BFCode||124','BFCode||125','BFCode||126','BFCode||127','BFCode||128','BFCode||129','BFCode||130','BFCode||131','BFCode||132','BFCode||133','BFCode||134','BFCode||136','BFCode||137','BFCode||138','BFCode||139','BFCode||140','BFCode||141','BFCode||142','BFCode||143','BFCode||144','BFCode||145','BFCode||146','BFCode||147','BFCode||148','BFCode||149','BFCode||150','BFCode||151','BFCode||152','BFCode||153','BFCode||154','BFCode||159','BFCode||161','BFCode||162','BFCode||163','BFCode||164','BFCode||165','BFCode||166','BFCode||167','BFCode||168','BFCode||169','BFCode||170','BFCode||171','BFCode||172','BFCode||173','BFCode||174','BFCode||175','BFCode||176','BFCode||177','BFCode||178','BFCode||179','BFCode||181','BFCode||182','BFCode||183','BFCode||184','BFCode||185','BFCode||186','BFCode||187','BFCode||188','BFCode||189','BFCode||190','BFCode||191','BFCode||192','BFCode||193','BFCode||194','BFCode||195','BFCode||196','BFCode||197','BFCode||198','BFCode||199','BFCode||200','BFCode||201','BFCode||202','BFCode||203','BFCode||204','BFCode||205','BFCode||206','BFCode||207','BFCode||208','BFCode||209','BFCode||210','BFCode||211','BFCode||212','BFCode||213','BFCode||214','BFCode||215','BFCode||216','BFCode||217','BFCode||218','BFCode||219','BFCode||220','BFCode||221','BFCode||222','BFCode||223','BFCode||224','BFCode||225','BFCode||226','BFCode||227','BFCode||228','BFCode||229','BFCode||230','BFCode||231','BFCode||232','BFCode||233','BFCode||234','BFCode||235','BFCode||236','BFCode||237','BFCode||238','BFCode||239','BFCode||240','BFCode||241','BFCode||242','BFCode||243','BFCode||244','BFCode||245','BFCode||246','BFCode||247','BFCode||248','BFCode||249','BFCode||250','BFCode||251','BFCode||252','BFCode||254','BFCode||255','BFCode||256','BFCode||258','BFCode||259','BFCode||260','BFCode||261','BFCode||262','BFCode||263','BFCode||264','BFCode||265','BFCode||266','BFCode||267','BFCode||268','BFCode||269','BFCode||270','BFCode||271','BFCode||272','BFCode||273','BFCode||274','BFCode||275','BFCode||276','BFCode||277','BFCode||278','BFCode||279','BFCode||280','BFCode||281','BFCode||282','BFCode||283','BFCode||284','BFCode||285','BFCode||289','BFCode||290','BFCode||291','BFCode||293','BFCode||303','BFCode||305','BFCode||307','BFCode||312','BFCode||313','BFCode||315','BFCode||328','BFCode||329','BFCode||330','BFCode||331','BFCode||332','BFCode||336','BFCode||337','BFCode||338','BFCode||339','BFCode||340','BFCode||342','BFCode||344','BFCode||345','BFCode||347','BFCode||348','BFCode||349','BFCode||350','BFCode||351','BFCode||352','BFCode||354','BFCode||355','BFCode||356','BFCode||357','BFCode||358','BFCode||359','BFCode||360','BFCode||361','BFCode||363','BFCode||364','BFCode||366','BFCode||367','BFCode||369','BFCode||370','BFCode||371','BFCode||372','BFCode||373','BFCode||374','BFCode||375','BFCode||376','BFCode||377','BFCode||378','BFCode||379','BFCode||380','BFCode||381','BFCode||382','BFCode||383','BFCode||384','BFCode||385','BFCode||387','BFCode||390','BFCode||391','BFCode||392','BFCode||393','BFCode||394','BFCode||396','BFCode||397','BFCode||398','BFCode||399','BFCode||400','BFCode||401','BFCode||402','BFCode||405','BFCode||408','BFCode||411','BFCode||412','BFCode||424','BFCode||425','BFCode||426','BFCode||427','BFCode||428','BFCode||429','BFCode||430','BFCode||434','BFCode||436')}"
	s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: AdmType AS 就诊类型,PatDep->CTD_Code,PatDep->CTD_Desc AS 科室,TecCat->CTEMCC_Desc AS 核算大类,TecSubCat->CTEMCCC_Code AS 核算子类,TecSubCat->Group(tarecGrp,desc) AS 核算子类分组 , metrics: sum(TotleFee) AS 总费用 , filter: OrdDate->M_DAY_CODE between(2016-01-01,2018-10-23) &&  PatDepHos->CTH_Code =('BFCode||2','BFCode||67','BFCode||16')}"
	;s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: AdmType AS 就诊类型,PatDep->CTD_Code,PatDep->CTD_Desc AS 科室,TecCat->CTEMCC_Desc AS 核算大类,TecSubCat->CTEMCCC_Code AS 核算子类,TecSubCat->Group(tarecGrp,desc) AS 核算子类分组 , metrics: sum(TotleFee) AS 总费用 , filter: OrdDate->M_DAY_CODE between(2016-01-01,2018-10-23)}"
  s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: PatDep->CTD_Code AS dim1 , metrics: sum(TotleFee) AS N020001,sum(TotleFee) AS S0010001,sum(Quantity) AS S0010005 , filter: OrdDate->M_DAY_CODE between(2016-06-01,2016-07-01) && AdmType =(I,O,E,H) && PatDepHos->CTH_Code =('BFCode||2','BFCode||3') && PatDep->CTD_Code =('BFCode||1','BFCode||2','BFCode||3','BFCode||4','BFCode||5','BFCode||6','BFCode||7','BFCode||8','BFCode||9','BFCode||10','BFCode||11','BFCode||12','BFCode||13','BFCode||14','BFCode||15','BFCode||16','BFCode||17','BFCode||18','BFCode||19','BFCode||20','BFCode||21','BFCode||22','BFCode||23','BFCode||24','BFCode||25','BFCode||26','BFCode||27','BFCode||28','BFCode||29','BFCode||30','BFCode||31','BFCode||32','BFCode||33','BFCode||34','BFCode||35','BFCode||36','BFCode||37','BFCode||38','BFCode||39','BFCode||40','BFCode||41','BFCode||42','BFCode||43','BFCode||44','BFCode||45','BFCode||46','BFCode||47','BFCode||48','BFCode||49','BFCode||50','BFCode||51','BFCode||52','BFCode||53','BFCode||54','BFCode||55','BFCode||56','BFCode||57','BFCode||58','BFCode||59','BFCode||60','BFCode||61','BFCode||62','BFCode||63','BFCode||64','BFCode||65','BFCode||66','BFCode||67','BFCode||68','BFCode||69','BFCode||70','BFCode||71','BFCode||72','BFCode||73','BFCode||74','BFCode||75','BFCode||76','BFCode||77','BFCode||78','BFCode||79','BFCode||80','BFCode||81','BFCode||82','BFCode||83','BFCode||84','BFCode||85','BFCode||86','BFCode||87','BFCode||88','BFCode||89','BFCode||90','BFCode||91','BFCode||92','BFCode||93','BFCode||94','BFCode||95','BFCode||96','BFCode||97','BFCode||98','BFCode||99','BFCode||100','BFCode||101','BFCode||102','BFCode||103','BFCode||104','BFCode||105','BFCode||106','BFCode||107','BFCode||108','BFCode||109','BFCode||110','BFCode||111','BFCode||112','BFCode||113','BFCode||114','BFCode||115','BFCode||116','BFCode||117','BFCode||118','BFCode||119','BFCode||120','BFCode||121','BFCode||122','BFCode||123','BFCode||124','BFCode||125','BFCode||126','BFCode||127','BFCode||128','BFCode||129','BFCode||130','BFCode||131','BFCode||132','BFCode||133','BFCode||134','BFCode||136','BFCode||137','BFCode||138','BFCode||139','BFCode||140','BFCode||141','BFCode||142','BFCode||143','BFCode||144','BFCode||145','BFCode||146','BFCode||147','BFCode||148','BFCode||149','BFCode||150','BFCode||151','BFCode||152','BFCode||153','BFCode||154','BFCode||159','BFCode||161','BFCode||162','BFCode||163','BFCode||164','BFCode||165','BFCode||166','BFCode||167','BFCode||168','BFCode||169','BFCode||170','BFCode||171','BFCode||172','BFCode||173','BFCode||174','BFCode||175','BFCode||176','BFCode||177','BFCode||178','BFCode||179','BFCode||181','BFCode||182','BFCode||183','BFCode||184','BFCode||185','BFCode||186','BFCode||187','BFCode||188','BFCode||189','BFCode||190','BFCode||191','BFCode||192','BFCode||193','BFCode||194','BFCode||195','BFCode||196','BFCode||197','BFCode||198','BFCode||199','BFCode||200','BFCode||201','BFCode||202','BFCode||203','BFCode||204','BFCode||205','BFCode||206','BFCode||207','BFCode||208','BFCode||209','BFCode||210','BFCode||211','BFCode||212','BFCode||213','BFCode||214','BFCode||215','BFCode||216','BFCode||217','BFCode||218','BFCode||219','BFCode||220','BFCode||221','BFCode||222','BFCode||223','BFCode||224','BFCode||225','BFCode||226','BFCode||227','BFCode||228','BFCode||229','BFCode||230','BFCode||231','BFCode||232','BFCode||233','BFCode||234','BFCode||235','BFCode||236','BFCode||237','BFCode||238','BFCode||239','BFCode||240','BFCode||241','BFCode||242','BFCode||243','BFCode||244','BFCode||245','BFCode||246','BFCode||247','BFCode||248','BFCode||249','BFCode||250','BFCode||251','BFCode||252','BFCode||254','BFCode||255','BFCode||256','BFCode||258','BFCode||259','BFCode||260','BFCode||261','BFCode||262','BFCode||263','BFCode||264','BFCode||265','BFCode||266','BFCode||267','BFCode||268','BFCode||269','BFCode||270','BFCode||271','BFCode||272','BFCode||273','BFCode||274','BFCode||275','BFCode||276','BFCode||277','BFCode||278','BFCode||279','BFCode||280','BFCode||281','BFCode||282','BFCode||283','BFCode||284','BFCode||285','BFCode||289','BFCode||290','BFCode||291','BFCode||293','BFCode||303','BFCode||305','BFCode||307','BFCode||312','BFCode||313','BFCode||315','BFCode||328','BFCode||329','BFCode||330','BFCode||331','BFCode||332','BFCode||336','BFCode||337','BFCode||338','BFCode||339','BFCode||340','BFCode||342','BFCode||344','BFCode||345','BFCode||347','BFCode||348','BFCode||349','BFCode||350','BFCode||351','BFCode||352','BFCode||354','BFCode||355','BFCode||356','BFCode||357','BFCode||358','BFCode||359','BFCode||360','BFCode||361','BFCode||363','BFCode||364','BFCode||366','BFCode||367','BFCode||369','BFCode||370','BFCode||371','BFCode||372','BFCode||373','BFCode||374','BFCode||375','BFCode||376','BFCode||377','BFCode||378','BFCode||379','BFCode||380','BFCode||381','BFCode||382','BFCode||383','BFCode||384','BFCode||385','BFCode||387','BFCode||390','BFCode||391','BFCode||392','BFCode||393','BFCode||394','BFCode||396','BFCode||397','BFCode||398','BFCode||399','BFCode||400','BFCode||401','BFCode||402','BFCode||405','BFCode||408','BFCode||411','BFCode||412','BFCode||424','BFCode||425','BFCode||426','BFCode||427','BFCode||428','BFCode||429','BFCode||430','BFCode||434','BFCode||436')}"
	s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: AdmType->CTDValue AS dim1,PatDep AS dim2,TecCat->CTEMCC_Desc AS dim3 , metrics: sum(TotleFee) AS S0010017 , filter: OrdDate->M_DAY_CODE between(2015-10-24,2018-10-24)}"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	s status= parser.Parse(cql)
	if status'=$$$OK{
		w status,!
		q
	}
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	w executor.Execute(),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta(),"    ",1),"    "
	w $lts(it.GetMetricMeta(),"    ",1),!
	s count=0
	while (it.HasNext()){
	  w $lts(it.CurDims(),":",1)_"   ;  "_$lts(it.CurMetrics(),":",1),!
	  s count=count+1
	}
	w "count:"_count,!
	d executor.Close()
	s executor="",parser=""
}

}
