Class web.DHCEQImportDataTool Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 849;

/// /根据分类导入类组和设备类型
ClassMethod ImportStatCatByEquipCat(col, description, code)
{
	if col=1
	{
		s scRowid=""
		if description="" q 0
		&SQL(Select ET_RowID into :scRowid from sqluser.DHC_EQCEquipType where ET_Code=:code and ET_Desc=:description and ET_InvalidFlag='N')	
		if scRowid=""
		{
			&SQL(Insert into sqluser.DHC_EQCEquipType(ET_Code,ET_Desc,ET_InvalidFlag) values (:code,:description,'N'))
			//b
			q SQLCODE
		}
	}
	if col=2
	{
		s scRowid=""
		if description="" q 0
		&SQL(Select SC_RowID into :scRowid from sqluser.DHC_EQCStatCat where SC_Code=:code and SC_Desc=:description )	
		if scRowid=""
		{
			&SQL(Insert into sqluser.DHC_EQCStatCat(SC_Code,SC_Desc,SC_InvalidFlag) values (:code,:description,'N'))
			//b
			q SQLCODE
		}
	}
	q 0
}

/// 根据设备项获取相关信息
ClassMethod ImportInfoByMasterItem(itemname, code, unit, equiptype, statcat, equipcat, model, catid)
{
	new rowid,sql,errs,row
	s (code,unit,equiptype,statcat,equipcat,errs)=""
	&SQL(select mi_code,mi_unitdr,mi_equiptypedr,mi_statcatdr,mi_catdr into :code,:unit,:equiptype,:statcat,:equipcat from SQLUSER.dhc_eqcmasteritem where mi_desc=:itemname)
	if (SQLCODE)
	{
		s row=0
		//set sql="select Code,Unit,StatCat,Model,EquipType from SQLUSER.CurSheBei where name='"_itemname_"'"
		//set sql="select Code,Unit,StatCat,Model,EquipType from SQLUSER.SheBei where name='"_itemname_"'"
		set sql="select Code,Unit,StatCat,Model,EquipType from sqluser.SheBei where name='"_itemname_"'"
		Set rset = ##class(%ResultSet).%New()
		Do rset.Prepare(sql)
 		Do rset.Execute()
 		While (rset.Next(.sc))
    	{	break:row>0    
        	If ($SYSTEM.Status.IsOK(sc))
            {
	            s code=rset.Data("Code")
	            s unit=rset.Data("Unit")
	            s statcat=rset.Data("StatCat")
	            s model=rset.Data("Model")
	            s equiptype=rset.Data("EquipType")
	            if ((statcat="")||(statcat=$c(0)))
	            {
		            //s statcat=##Class(DHCEQImportDataTool).GetEquipTypeInfo(catid)
		            //s equiptype=$p(statcat,"^",1)
		            //s statcat=$p(statcat,"^",2)
		        }
	            s row=row+1
	        }
        	Else // if there was an error, break out of the While loop
            {
	            s errs="status err"
	            q
            }
     	}
     	//w "errs:"_errs_" code:"_code_" unit:"_unit_" statcat:"_statcat_" model:"_model
		//&SQL(select code,unit,statcat,model into :code,:unit,:statcat,:model from SQLUSER.curshebei where name=:itemname)
		s statcat=..GetStatCatID(statcat)
		s unit=..GetUnitID(unit)
		s equiptype=..GetEquipTypeID(equiptype)
		&SQL(insert into sqluser.dhc_eqcmasteritem (mi_desc,mi_code,mi_unitdr,mi_equiptypedr,mi_statcatdr,mi_invalidflag)
			values(:itemname,:code,:unit,:equiptype,:statcat,'N'))
		Set rowid=$g(%ROWID)
		if ((model'="")&(model'=$C(0)))
		{
			//w "model:"_model_"@",!
			&SQL(Insert Into sqluser.dhc_eqcmodel(m_desc,m_Itemdr,m_invalidflag) values (:model,:rowid,'N'))
			s model=$g(%ROWID)
		}
	}
	q
}

ClassMethod UpdateMasterItem()
{
	new rset,sql
	new item,errs,row,id,items,itemid,itemids,PLIST
	set errs=""
	set items=""
	set itemids=""
	set row=0
	set sql="SELECT MI_RowID,MI_Desc FROM sqluser.DHC_EQCMasterItem "
	Set rset = ##class(%ResultSet).%New()
	Do rset.Prepare(sql)
 	Do rset.Execute()
 	
 	While (rset.Next(.sc))
     {
        If ($SYSTEM.Status.IsOK(sc))
            {
	            s id=""
	            s row=row+1
	            s item=rset.Data("MI_Desc")
	            i item="" continue
	            s items=items_"^"_item
	            s itemid=rset.Data("MI_RowID")
	            s itemids=itemids_"^"_itemid
            }
        Else // if there was an error, break out of the While loop
            {
	            s errs="status err"
	            q
            }
     }
     i items="" q 0
     s items=$e(items,2,$l(items))
     s itemids=$e(itemids,2,$l(itemids))
    
     for i=1:1:$l(items,"^")  q:errs'=""  d
     .s item=$p(items,"^",i)
     .q:item=""
     .s itemid=$p(itemids,"^",i)
     .s (type,statcat,equipcat,unit,code)=""
     .&SQL(Select TI_Code,TI_EquipType,TI_StatCat,TI_Unit into :code,:type,:statcat,:unit from SQLUSER.DHC_EQTempimport where TI_Name=:item)
     .i type'=""  d 
     ..&SQl(Select et_rowid into :type from sqluser.DHC_EQCEquipType where et_desc=:type and ET_InvalidFlag='N')
     .i statcat'=""  d
     ..&SQl(Select sc_rowid into :statcat from sqluser.DHC_EQCStatCat where sc_desc=:statcat)
     .i unit'=""  d
     ..;Modified By jdl 20150906 v4.1.0 规范单位取值
     ..;&SQl(Select ctuom_rowid into :unit from sqluser.ct_uom where ctuom_desc=:unit)
     ..s unit=##Class(web.DHCEQImportDataTool).GetUnitID(unit)
     .&SQL(Select EQ_EquiCatDR into :equipcat from SQLUSER.DHC_EQTempEquip where EQ_ItemDR=:itemid)
     .k PLIST
     .k PLIST(1)
     .i (code'="") s PLIST(3) = code
     .i (type'="") s PLIST(4) = type
     .i (equipcat'="") s PLIST(5) = equipcat
     .i (statcat'="") s PLIST(6) = statcat
     .i (unit'="") s PLIST(8) = unit
     .&SQL(Update SQLUSER.DHC_EQCMasterItem Values :PLIST() where MI_RowID=:itemid)
     .i SQLCODE  d
     ..s errs=errs_"   "_item_" Update err "_SQLCODE
     
 	 i errs'=""
     {
	     w errs,!
	     q -1
     }
     Quit 0
}

ClassMethod UpdateMasterItemByEquip()
{
	new rset,sql
	new item,errs,row,id,items,itemid,itemids,PLIST
	set errs=""
	set items=""
	set itemids=""
	set row=0
	set sql="SELECT MI_RowID,MI_Desc FROM sqluser.DHC_EQCMasterItem "
	Set rset = ##class(%ResultSet).%New()
	Do rset.Prepare(sql)
 	Do rset.Execute()
 	
 	While (rset.Next(.sc))
     {
        If ($SYSTEM.Status.IsOK(sc))
            {
	            s id=""
	            s row=row+1
	            s item=rset.Data("MI_Desc")
	            i item="" continue
	            s items=items_"^"_item
	            s itemid=rset.Data("MI_RowID")
	            s itemids=itemids_"^"_itemid
            }
        Else // if there was an error, break out of the While loop
            {
	            s errs="status err"
	            q
            }
     }
     i items="" q 0
     s items=$e(items,2,$l(items))
     s itemids=$e(itemids,2,$l(itemids))
    
     for i=1:1:$l(items,"^")  q:errs'=""  d
     .s item=$p(items,"^",i)
     .q:item=""
     .s itemid=$p(itemids,"^",i)
     .s (type,statcat,equipcat,unit,code)=""
     .&SQL(Select EQ_Code,EQ_EquipTypeDR,EQ_StatCatDR,EQ_UnitDR,EQ_EquiCatDR into :code,:type,:statcat,:unit,:equipcat from SQLUSER.DHC_EQEquip where EQ_Name=:item)
     .k PLIST
     .k PLIST(1)
     .i (code'="") s PLIST(3) = code
     .i (type'="") s PLIST(4) = type
     .i (equipcat'="") s PLIST(5) = equipcat
     .i (statcat'="") s PLIST(6) = statcat
     .i (unit'="") s PLIST(8) = unit
     .&SQL(Update SQLUSER.DHC_EQCMasterItem Values :PLIST() where MI_RowID=:itemid)
     .i SQLCODE  d
     ..s errs=errs_"   "_item_" Update err "_SQLCODE
     
 	 i errs'=""
     {
	     w errs,!
	     q -1
     }
     Quit 0
}

/// w ##class(web.DHCEQImportDataTool).GetModelID("联想17'LCD","办公显示器","信息一般设备")
ClassMethod GetModelID(desc, remark, equiptype)
{
	new rowid,tmpid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s desc=$ZCONVERT(desc,"U")
	s tmpid=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCModel",rowid))  q:((rowid="")||(tmpid'=""))  d
	.s ItemDR=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",4)
	.q:remark'=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1)
	.s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
	.q:equiptype'=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s model=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",2)
	.s model=##Class(web.DHCEQCommon).Trim(model)
	.s model=$ZCONVERT(model,"U")
	.if model=desc  d
	..s tmpid=rowid
	//&SQL(select M_rowid into :tmpid from sqluser.dhc_eqcmodel where M_desc=:desc and m_remark=:remark)
	q tmpid
}

ClassMethod GetEquipCatID(code)
{
	s code=##Class(web.DHCEQCommon).Trim(code)
	i code="" q ""
	s tmpid=""
	&SQL(select ec_rowid into :tmpid from sqluser.dhc_eqcequipecat where ec_code=:code)
	q tmpid
}

/// add by lmm 2020-12-02
ClassMethod GetEquipID(desc)
{
	i desc="" q ""
	s equipid=""
	&SQL(Select EQ_RowID into :equipid  from sqluser.DHC_EQEquip where EQ_No=:desc)
	q equipid
}

/// w ##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(1,"")
/// paratype: 0:para为desc  1:para为code  2:para为code%excode  3:para为desc%code  4:para为desc,且使用年限不为空
ClassMethod GetEquipCatIDNew(paratype, para)
{
	i para="" q ""	
	s tmpid=""
	
	if (paratype=0)
	{
		&SQL(select ec_rowid into :tmpid from sqluser.dhc_eqcequipecat where ec_desc=:para and ec_invalidflag<>'Y')
	}
	elseif (paratype=1)
	{
		s tmpid=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",para,0))
		//&SQL(select ec_rowid into :tmpid from sqluser.dhc_eqcequipecat where ec_code=:para)
	}
	elseif (paratype=2)
	{
		/*s code=$p(para,"%",1)		// MZY0028	1340074		2020-05-29	分类扩展码不再使用
		s excode=$p(para,"%",2)
		if ((excode="")||(code="")) q ""
		s equipCatRowId=0
		f  s equipCatRowId=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"ExCode",excode,equipCatRowId))  quit:equipCatRowId=""  d
		.q:##Class(web.DHCEQCEquipeCat).GetCodeByCatID(equipCatRowId)'=code
		.s tmpid=equipCatRowId*/
	}
	elseif (paratype=3)
	{
		s code=$p(para,"%",1)
		s desc=$p(para,"%",2)
		if ((desc="")&&(code="")) q ""
		&SQL(select ec_rowid into :tmpid from sqluser.dhc_eqcequipecat where ec_desc=:desc)
		if tmpid=""
		{
			s tmpid=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",code,0))
		}
	}
	elseif (paratype=4)
	{
		&SQL(select ec_rowid into :tmpid from sqluser.dhc_eqcequipecat where ec_desc=:para and ec_yearsnum<>'')
	}
	q tmpid
}

ClassMethod IsChildCatByCode(code, catid)
{
	if catid="" q 0
	if $p($g(^DHCEQCCode("DHCEQCEquipeCat",catid)),"^",1)=code
	{
		q 1
	}
	else
	{
		q ..IsChildCatByCode(code,$p($g(^DHCEQCCode("DHCEQCEquipeCat",catid)),"^",4))
	}
}

ClassMethod GetUnitID(desc)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	//&SQL(select ctuom_rowid into :tmpid from sqluser.ct_uom where ctuom_desc=:desc)
	;Modified By jdl 20150906 v4.1.0 统一单位取值，不再取CT_UOM中，直接使用DHC_EQUOM
	;&SQL(select UOM_RowID into :tmpid from sqluser.DHC_EQCUOM where  UOM_Desc=:desc and UOM_InvalidFlag<>'Y')
	&SQL(select UOM_RowID into :tmpid from sqluser.DHC_EQCUOM where  UOM_Desc=:desc)
	q tmpid
}

ClassMethod GetCountryID(desc)
{
	new (desc)
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	s rowid=""
	f  s rowid=$o(^CT("COU",rowid)) q:((rowid="")||(tmpid'=""))  d
	.s couDesc=$p($g(^CT("COU",rowid)),"^",2)
	.s couDesc=##class(web.DHCEQCommon).GetSplitDataByFlag(couDesc,"-")
	.;s couDesc=$p(couDesc,"-",2)
	.i desc=couDesc  d
	..s tmpid=rowid
	q tmpid
}

ClassMethod GetCountryIDForXY2(desc)
{
	new rowid,tmpid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	s rowid=""
	f  s rowid=$o(^CT("COU",rowid)) q:((rowid="")||(tmpid'=""))  d
	.s couDesc=$p($g(^CT("COU",rowid)),"^",2)
	.s couDesc=##class(web.DHCEQCommon).GetSplitDataByFlag(couDesc,"-")
	.;s couDesc=$p(couDesc,"-",2)
	.i desc=couDesc  d
	..s tmpid=rowid
	q tmpid
}

/// MZY0035	1387807		2020-06-28
/// w ##Class(web.DHCEQImportDataTool).GetUseLocID("MDT会诊中心")
ClassMethod GetUseLocID(desc)
{
	new (desc)
	i desc="" q ""
	/*s locid=##Class(web.DHCEQCommon).GetContrastInfo("Old", "dept", desc, 1, 0)
	i locid=$c(0)  d
	.s rowid=""
	.f  s rowid=$o(^CTLOC(rowid)) q:((rowid="")||(+locid>0))  d
	..;s locDesc=$p($g(^CTLOC(rowid)),"^",1)
	..;s locDesc=$p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",1)
	..;s locDesc=$p($g(^CTLOC(rowid)),"^",2)
	..s locDesc=$p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",2)     //modify by jyp 2019-10-18 CTLOC调整
	..;s locDesc=##class(web.DHCEQCommon).GetSplitDataByFlag(locDesc,"-")  //modify by jyp 2019-10-18 CTLOC调整
	..i desc=locDesc  d
	...s locid=rowid
	.i locid=$c(0) s locid=""
	e  d
	.i locid="没有对照" s locid=""
	*/
	s locid=""
	s rowid=""
	f  s rowid=$o(^DHCEQCCode("DHCEQCDepartment",rowid)) q:(rowid="")||(locid'="")  d
	.s locDesc=$p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",2)
	.i desc=locDesc s locid=rowid
	
	i locid="" s ^DHCEQImportResult("Err","LocNotFind",desc)=""
	q locid
}

/// add by lmm 2020-12-03
/// w ##Class(web.DHCEQImportDataTool).GetMeasureDeptID("MDT会诊中心")
ClassMethod GetMeasureDeptID(desc)
{
	new (desc)
	i desc="" q ""
	s deptid=""
	&SQL(select MD_RowID into:deptid from sqluser.DHC_EQCMeasureDept where MD_Name = :desc)
	q deptid
}

ClassMethod GetUseLocIDForXY2(desc)
{
	new rowid,tmpid
	i desc="" q ""
	s tmpid=""
	s rowid=""
	f  s rowid=$o(^CTLOC(rowid)) q:((rowid="")||(tmpid'=""))  d
	.s couDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s couDesc=$p(couDesc,"-",2)
	.i desc=couDesc  d
	..s tmpid=rowid
	q tmpid
}

ClassMethod GetUserID(desc)
{
	i desc="" q ""
	s tmpid=""
	//&SQL(Select SSUSR_rowid into :tmpid  from sqluser.ss_user where SSUSR_Name=:desc)		//modified by czf 2020-07-24 1435945
	&SQL(Select U_RowID into :tmpid  from sqluser.DHC_EQCUser where U_Name=:desc)
	i tmpid="" s ^DHCEQImportResult("Err","UserNotFind",desc)=""
	q tmpid
}

ClassMethod GetNewUseLoc(desc)
{
	new tmpid,errs,sql
	i desc="" q ""
	s tmpid="",errs=""
	set sql="Select NewName from sqluser.keshi where OldName='"_desc_"'"
	//w sql,!
	Set rset = ##class(%ResultSet).%New()
	Do rset.Prepare(sql)
 	Do rset.Execute()
 	While (rset.Next(.sc2))
     {	    
        If ($SYSTEM.Status.IsOK(sc2))
            {
	            s tmpid=rset.Data("NewName")
	        }
        Else // if there was an error, break out of the While loop
            {
	            s errs="status err"
	            q
            }
     }
    q:errs'="" ""
	q tmpid
}

ClassMethod GetOriginID(desc)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	&SQL(Select o_rowid into :tmpid  from sqluser.dhc_eqcOrigin where o_desc=:desc)
	if tmpid=""
	{
		&SQL(Select o_rowid into :tmpid  from sqluser.dhc_eqcOrigin where o_code=:desc)
	}
	q tmpid
}

ClassMethod GetFromToDept(desc)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	&SQL(Select ftd_rowid into :tmpid  from sqluser.DHC_EQCFromToDept where ftd_desc=:desc)
	q tmpid
}

ClassMethod GetProviderIDOld(desc)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	&SQL(Select apcvm_rowid into :tmpid  from sqluser.APC_Vendor where apcvm_name=:desc and apcvm_type='EQ')
	q tmpid
}

/// flag:1:按名称查，2：按代码查
/// w ##Class(web.DHCEQImportDataTool).GetProviderID("GYKGHNYXGS-国药控股湖南有限公司")
ClassMethod GetProviderID(desc, flag)
{
	new rowid,tmpid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	i flag=1 d
	.&SQL(Select v_rowid into :tmpid  from sqluser.DHC_EQCVendor where v_name=:desc and v_invalidflag='N')	//modified by CZF0105
	e  d
	.&SQL(Select v_rowid into :tmpid  from sqluser.DHC_EQCVendor where v_Code=:desc and v_invalidflag='N')
	q tmpid
}

ClassMethod GetManuFactoryID(desc)
{
	new rowid,tmpid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	&SQL(Select v_rowid into :tmpid  from sqluser.DHC_EQCVendor where v_name=:desc and v_invalidflag='N')	//modified by CZF0105
	/*
	s desc=$ZCONVERT(desc,"U")
	s rowid=""
	f  s rowid=$o(^DHCEQCCode("DHCEQCManufacturer",rowid))  q:((rowid="")||(tmpid'=""))  d
	.s manufacturer=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",1)	;name
	.;s manufacturer=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",2)	;code
	.s manufacturer=$ZCONVERT(manufacturer,"U")
	.s manufacturer=##Class(web.DHCEQCommon).Trim(manufacturer)
	.if manufacturer=desc  s tmpid=rowid
	//&SQL(Select mf_rowid into :tmpid  from sqluser.DHC_EQCManufacturer where mf_name=:desc)
	*/
	q tmpid
}

ClassMethod GetEquipTypeID(desc)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	s desc=$ZCONVERT(desc,"U")
	&SQL(Select et_rowid into :tmpid  from sqluser.DHC_EQCEquipType where et_desc=:desc and ET_InvalidFlag='N')
	q tmpid
}

ClassMethod GetStatCatID(desc)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	s desc=$ZCONVERT(desc,"U")
	&SQL(Select sc_rowid into :tmpid  from sqluser.DHC_EQCStatCat where sc_desc=:desc)
	q tmpid
}

/// add by lmm 2020-12-02
ClassMethod GetCycleUnitID(desc)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	s desc=$ZCONVERT(desc,"U")
	&SQL(Select CU_RowID into :tmpid  from sqluser.DHC_EQCCycleUnit where CU_Desc=:desc)
	q tmpid
}

ClassMethod GetItemID(desc, equiptypeid)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	i equiptypeid=""
	{
		&SQL(Select MI_rowid into :tmpid  from sqluser.DHC_EQCMasterItem where MI_desc=:desc)
	}
	else
	{
		&SQL(Select MI_rowid into :tmpid  from sqluser.DHC_EQCMasterItem where MI_desc=:desc and MI_EquipTypeDR=:equiptypeid)
	}
	q tmpid
}

ClassMethod GetPurposeTypeID(desc)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	&SQL(Select PT_rowid into :tmpid  from sqluser.DHC_EQCPurposeType where PT_desc=:desc)
	if tmpid=""
	{&SQL(Select PT_rowid into :tmpid  from sqluser.DHC_EQCPurposeType where PT_code=:desc)}
	
	q tmpid
}

ClassMethod EquipBeginDepre(beginId, endId)
{
	/*new monthStr,CurDate
	s CurDate=$ZD($H,3)
	i $p(CurDate,"-",3)>25 d
	.s monthStr=$p(CurDate,"-",1,2)
	e  d
	.s CurDate=$ZD($H-26,3)
	.s monthStr=$p(CurDate,"-",1,2)
	
	//s monthStr="2007-02"
	s MonthStr=##class(web.DHCEQMonthDepre).GetMonth(monthStr)*/
	new End
	s beginId=+beginId
	s MonthStr=..GetCurMonthStr()
	s End=##class(web.DHCEQCommon).GetSysInfo("901002")
	if (End="") s End="1"
	s EndDate=$ZDH(MonthStr_"-"_End,3)
	s j=0
	s EquipID=beginId
	k ^DHCEQTemp("Depre")
	TSTART
	f  s EquipID=$O(^DHCEQEquip(EquipID)) q:((EquipID="")||(j>0)||((EquipID>+endId)&&(endId'="")))  d
	.s Name=$P(^DHCEQEquip(EquipID),"^",1)
	.s Flag=$P(^DHCEQEquip(EquipID),"^",59)
	.i Flag="Y" s ^DHCEQTemp("Depre","Delete",EquipID)=Name
	.q:Flag="Y"
	.s Status=$P(^DHCEQEquip(EquipID),"^",38)
	.i Status'="1" s ^DHCEQTemp("Depre","Status",EquipID)=Name 
	.q:Status'="1"
	.//s StartDate=$P(^DHCEQEquip(EquipID),"^",44)	///StartDate
	.s StartDate=$P(^DHCEQEquip(EquipID),"^",45)	///TransAssetDate
	.i StartDate>EndDate s ^DHCEQTemp("Depre","Time",EquipID)=Name
	.q:StartDate>EndDate
	.i StartDate="" d
	..w "EquipID"_EquipID_"的启用日期为空",!
	..s j=j+1
	.q:j>0
	.///q:EquipID>5
	.s Return=..InsertDepreTotal(EquipID,EndDate,StartDate,MonthStr)
	.i Return<0 d
	..w "EquipID"_EquipID_Name_"^"_Return,!
	..s ^DHCEQTemp("Depre","Err",EquipID)=Name_"^"_Return
	..s j=j+1
	.q:Return<0
	i j>0
	{
		TROLLBACK
		w "没有完成"
		q
	}
	TCOMMIT
	w "完成"
}

ClassMethod InsertDepreTotal(EquipID, EndDate, StartDate, MonthStr)
{
	new DepreMethod,OriginalFee,NetFee,FormatStartDate,Day,StartMonth,Start
	s DepreMethod="1" //$P(^DHCEQEquip(EquipID),"^",33)
	s OriginalFee=$P(^DHCEQEquip(EquipID),"^",27)
	s NetFee=$P(^DHCEQEquip(EquipID),"^",28)
	s FormatStartDate=$ZD(StartDate,1)
	s Day=$P(FormatStartDate,"/",2)
	s StartMonth=$p($ZD(StartDate,3),"-",1,2)
	s Start=##class(web.DHCEQCommon).GetSysInfo("901001")
	i Day<Start
	{
		s StartMonth=$p($ZD(StartDate,3),"-",1,2)
		s date=0
	}
	else
	{
		s date=$ZDH(##Class(web.DHCEQCommon).DateAddApp("m",1,FormatStartDate),1)
		s StartMonth=$p($ZD(date,3),"-",1,2)
	}
	s StartMonth=##class(web.DHCEQMonthDepre).GetMonth(StartMonth)
	s i=1
	while ($ZDH(##Class(web.DHCEQCommon).DateAddApp("m",i,FormatStartDate),1)<EndDate)
	{
		s i=i+1
	}
	s depremethod=$P(^DHCEQEquip(EquipID),"^",33)
	i depremethod="" q 0
	i $p($g(^DHCEQCCode("DHCEQCDepreMethod",depremethod)),"^",1)="02" q 0
	s years=$P(^DHCEQEquip(EquipID),"^",31)
	s months=years*12
	///w ";OriginalFee:"_OriginalFee_" months:"_months_"&&"_i
	i i'<months
	{
		s TotalDepreFee=OriginalFee
		s NetFee=0
	}
	else
	{
		s TotalDepreFee=(OriginalFee/months)*i
		///w " TotalDepreFee:"_TotalDepreFee
		s TotalDepreFee=$Number(TotalDepreFee,2)
		s NetFee=OriginalFee-TotalDepreFee
	}
	k EQPLIST,DPPLIST,val
	s EQPLIST(29)=NetFee
	s EQPLIST(36)=TotalDepreFee
	s EQPLIST(69)=StartMonth
	s EQPLIST(32)=years
	s EQPLIST(34)=DepreMethod
	i NetFee=0 s EQPLIST(75)="Y"
	//&SQL(update sqluser.DHC_EQEquip values EQPLIST() where EQ_RowID=:EquipID)
	//i SQLCODE q SQLCODE
	s DPPLIST(2)=EquipID
	s DPPLIST(5)=DepreMethod
	s DPPLIST(6)=OriginalFee
	s DPPLIST(7)=MonthStr
	s DPPLIST(8)=$P(^DHCEQEquip(EquipID),"^",37) //工作总量
	s DPPLIST(9)=$P(^DHCEQEquip(EquipID),"^",38) //工作单位
	s DPPLIST(10)=years //年限
	s DPPLIST(11)=i
	s DPPLIST(13)=0
	s DPPLIST(15)=TotalDepreFee
	s DPPLIST(18)=NetFee
	s DPPLIST(20)="N"
	s DPPLIST(21)="1"
	s DPPLIST(30)=+$H
	s DPPLIST(31)=$P($H,",",2)
	s DPPLIST(32)="9"
	//&SQL(insert into sqluser.DHC_EQMonthDepre values DPPLIST())
	s Date=+$H
	s Time=$P($H,",",2)
	s User=""
	//s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s val=""
	s Equip=EquipID
	s val=val_Equip_"^" //EquipDR 1
	s val=val_"^" //MaintDR 2
	s val=val_""_"^" //CostallotDR 3
	s val=val_TotalDepreFee_"^" //UseFee 4
	s val=val_(+$H)_"^" //FeeDate 5
	s val=val_$p($G(^DHCEQEquip(EquipID)),"^",19)_"^" //UseLocDR 6
	s val=val_$p($G(^DHCEQEquip(EquipID)),"^",17)_"^" //ManageLocDR 7
	s val=val_##class(web.DHCEQMaint).GetFeeType(6)_"^" //FeeTypeDR 8
	s val=val_User_"^" //user 9
	s val=val_Date_"^" //Date 10
	s val=val_Time_"^" //Time 11
	s val=val_"月度折旧产生费用" //Remark 12
	///w EQPLIST(36),!
	&SQL(update sqluser.DHC_EQEquip values EQPLIST() where EQ_RowID=:EquipID)
	i SQLCODE q -2001
	
	&SQL(insert into sqluser.DHC_EQMonthDepre values DPPLIST())
	i SQLCODE q -2002_","_SQLCODE
	
	s SourceID=$G(%ROWID)
	s $P(val,"^",2)=SourceID
	s Return=##class(web.DHCEQMaint).InsertLifeFee(3,val)
	i Return q -2003
	q 0
}

ClassMethod GetCurMonthStr()
{
	new monthStr,CurDate,StartDate
	s StartDate=##class(web.DHCEQCommon).GetSysInfo("901001")
	s CurDate=$ZD($H,3)
	i $p(CurDate,"-",3)>StartDate d
	.s monthStr=$p(CurDate,"-",1,2)
	e  d
	.s CurDate=$ZD($H-StartDate-1,3)
	.s monthStr=$p(CurDate,"-",1,2)
	
	//s monthStr="2007-02"
	s monthStr=##class(web.DHCEQMonthDepre).GetMonth(monthStr)
	q monthStr
}

/// 导入设备分类
/// ##Class(web.DHCEQImportDataTool).ImportEquipCatByList()
ClassMethod ImportEquipCatByList()
{
	new rset,sql
	new row,col,cols
	new PLIST,preInsertRow
	new firstflag,diffrentflag,errs
	new catdesc,parref
	k ^DHCEQCCode("DHCEQCEquipeCat")
	k ^DHCEQTempImport("EquipCat","Code")
	set firstFlag=1
	set row=0
	set errs=""
	//set sql="SELECT * FROM sqluser.FenLei order by code "
	set sql="SELECT * FROM sqluser.FenLei order by code "
	
	Set rset = ##class(%ResultSet).%New()
	Do rset.Prepare(sql)
 	Do rset.Execute()
 	k PLIST
 	
 	While (rset.Next(.sc))
     {	    
        If ($SYSTEM.Status.IsOK(sc))
            {
	            s PLIST(2) = rset.GetDataByName("code")
	            s PLIST(3) = rset.GetDataByName("desc1")
	            s PLIST(4) = rset.GetDataByName("remark")
	            s PLIST(5) ="0"	            
	            s PLIST(7) = rset.GetDataByName("yearsnum")
	            s PLIST(8)="N"
	            s PLIST(9) = rset.GetDataByName("equipnoflag")
	            i PLIST(9)="" s PLIST(8)="N"
	            s PLIST(10) = rset.GetDataByName("hold1")
	            s PLIST(11) = rset.GetDataByName("hold2")
	            //s PLIST(12) = rset.GetDataByName("excode")
	            
	            s code=PLIST(2)
	            
	            s ID=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",code,0))
	            if ID=""
	            {
		            s len=$l(code)
		            s parref=""
		            for i=len:-1:1
		            {
			            //b
			            s parref=$g(^DHCEQTempImport("EquipCat","Code",$e(code,1,i)))
			            if (parref'="")
			            { 
			            	s PLIST(5)=	parref
			            	q
			            }
			        }
			        ///if (PLIST(5)="") s PLIST(5)=0
			        &SQL(Insert Into SQLUSER.DHC_EQCequipecat Values :PLIST())
			        i SQLCODE w SQLCODE  ;s errs=errs_"   "_PLIST(3)_" insert err "_SQLCODE
			        Set ID=$g(%ROWID)
	            }
		        s ^DHCEQTempImport("EquipCat","Code",code)=ID
            }
        Else // if there was an error, break out of the While loop
            {
	            q
            }
     }
     
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
     {
	 	Quit -1
     }
     i errs'=""
     {
	     q -1
     }
     Quit 0
}

/// ##Class(DHCEQImportDataTool).GetEquipTypeInfo(
ClassMethod GetEquipTypeInfo(catid)
{
	if catid="" q "^"
	s parcatid=1
	s preCatid=""
	While (parcatid>0)
     {
	    &SQL(Select EC_ParCatDR into :parcatid from SQLuser.DHC_EQCEquipeCat where EC_RowID=:catid)
	    if parcatid>0 
	    {
		    s preCatid=catid   
	    	s catid=parcatid
		}
	 }
	 if ((preCatid'="")&&(catid'=""))
	 {
		 q ..GetEquipTypeID($p($g(^DHCEQCCode("DHCEQCEquipeCat",catid)),"^",2))_"^"_..GetStatCatID($p($g(^DHCEQCCode("DHCEQCEquipeCat",preCatid)),"^",2))
	 }
	 else
	 {	q "^"}
}

/// 检查导入的设备数据是否正常
/// w ##Class(web.DHCEQImportDataTool).CheckEquipData()
ClassMethod CheckEquipData()
{
	new count,err,oldcount
	s err=""
	&SQL(select count(*) into :count  from sqluser.dhc_eqequip where EQ_EquipTypeDR is null)
	if count>0 s err="一共有"_count_"条设备信息设备类组为空!"
	&SQL(select count(*) into :count  from sqluser.dhc_eqequip where EQ_StatCatDR is null)
	if count>0  d
	.i err'="" s err=err_$c(13)
	.s err="一共有"_count_"条设备信息设备类型为空!"
	&SQL(select count(*) into :count  from sqluser.dhc_eqequip where EQ_EquiCatDR is null)
	if count>0  d
	.i err'="" s err=err_$c(13)
	.s err="一共有"_count_"条设备信息设备分类为空!"
	
	//&SQL(select count(*) into :oldcount from sqluser.shebei where model='')
	&SQL(select count(*) into :count from sqluser.dhc_eqequip where eq_modeldr is null)
	if count>0  d
	.i err'="" s err=err_$c(13)
	.s err="现共有"_count_"条设备信息机型为空!"
	
	q err
}

/// w ##class(web.DHCEQImportDataTool).EquipBeginDepre("","")
/// w ##Class(web.DHCEQImportDataTool).BImportTempData(2000,15000)
ClassMethod BatchEquipBeginDepre(QtyOfOneTime, Total)
{
	new beginid,endid,finishFlag,killGlobalFlag
	s finishFlag=0
	s beginid=0
	While(finishFlag=0)
	{
		s endid=beginid+QtyOfOneTime
		s killGlobalFlag=0
		i beginid=0  s killGlobalFlag=1
		d ..EquipBeginDepre(killGlobalFlag,beginid,endid)
		s beginid=endid
		if beginid>Total d
		.s finishFlag=1
		// w "请输入:g   继续执行！"
	}
}

/// w ##Class(web.DHCEQImportDataTool).MapVendor(0,1000)
ClassMethod MapVendor(beginid, endid)
{
	new equipid
	s beginid=+beginid
	s endid=+endid
	
	new rset,sql
	new row,col,cols
	set sql="SELECT * FROM sqluser.shebei where id>"_beginid_" and id<="_endid
	
	Set rset = ##class(%ResultSet).%New()
	Do rset.Prepare(sql)
 	Do rset.Execute()
 	k PLIST
 	
 	While (rset.Next(.sc))
     {	    
        If ($SYSTEM.Status.IsOK(sc))
            {
	            s eqno=rset.Data("EQNo")
	            if eqno'=""  d
	            .s equipid=$o(^DHCEQEquip(0,"No",eqno,0))
	            .if equipid'=""  d
	            ..s provider=rset.Data("Provider")
	            ..s provider=..GetTempProvider(provider)
	            ..if provider'=""  d
	            ...&SQL(Update SQLUSER.DHC_EQEquip set EQ_Providerdr=:provider where EQ_RowID=:equipid)
	            
            }
     }
}

/// Mozy
/// 2009-5-6
/// 增加对“-”的处理
ClassMethod GetTempProvider(desc)
{
	New rowid,tmpid,len
	Set desc=##Class(web.DHCEQCommon).Trim(desc)
	If desc="" Quit ""
	Set tmpid=""
	Set desc=$ZCONVERT(desc,"U")
	Set rowid=""
	For  Set rowid=$Order(^APC("APCVM",rowid))  Quit:((rowid="")||(tmpid'=""))  Do
	.Set provider=$Piece($Get(^APC("APCVM",rowid)),"^",3)
	.Set provider=##class(web.DHCEQCommon).GetSplitDataByFlag(provider,"-")
	.Set provider=$ZCONVERT(provider,"U")
	.If provider=desc  Do
	..Set tmpid=rowid
	
	//&SQL(Select apcvm_rowid into :tmpid  from sqluser.APC_Vendor where apcvm_name=:desc and apcvm_type='EQ')
	Quit tmpid
}

ClassMethod GetDepreMethodID(desc)
{
	new rowid,tmpid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""	
	&SQL(Select dm_rowid into :tmpid  from sqluser.DHC_EQCDepreMethod where dm_desc=:desc)
	q tmpid
}

/// Add 2010-08-04 党军
/// Description:获取科室组ID
ClassMethod GetLocGroup(desc)
{
	new tmpid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	&SQL(Select lg_rowid into :tmpid  from sqluser.DHC_EQCLocGroup where lg_desc=:desc)
	q tmpid
}

/// Add 2010-07-02 党军
/// Description:获取科室职能ID
ClassMethod GetLocGroupType(gdesc, desc)
{
	new tmpid
	s gdesc=##Class(web.DHCEQCommon).Trim(gdesc)
	i gdesc="" q ""
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s LocGroupDR=..GetLocGroup(gdesc)
	i LocGroupDR="" q ""
	s tmpid=""
	&SQL(Select LGT_RowID into :tmpid from sqluser.DHC_EQCLocGroupType where LGT_LocGroupDR=:LocGroupDR and LGT_Desc=:desc)
	q tmpid
}

/// 创建：zy 2010-07-26   ZY0025
/// 描述：判断是否是库房
/// w ##class(web.DHCEQImportDataTool).GetStoreLocID("妇科")
ClassMethod GetStoreLocID(desc)
{
	new tmpid,lgtid,ltid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s (tmpid,lgtid,ltid)=""
	&SQL(Select ctloc_rowid into :tmpid  from sqluser.ct_loc where ctloc_code=:desc)
	i tmpid'="" d
	.&SQL(Select LGT_RowID into :lgtid from sqluser.DHC_EQCLocGroupType where LGT_Code='0101')
	.i lgtid'="" &SQL(Select LT_RowID into :ltid from sqluser.DHC_EQCLocType where LT_Type=:lgtid and LT_LocDR=:tmpid)
	.i ltid="" s tmpid=""
	q tmpid
}

/// w  ##Class(web.DHCEQImportDataTool).BakEqData("Bak101013")
ClassMethod BakEqData(Node)
{
	m ^DHCEQBakData(Node,"CodeTable")=^DHCEQCCodeTable
	m ^DHCEQBakData(Node,"Code")=^DHCEQCCode
	m ^DHCEQBakData(Node,"Equip")=^DHCEQEquip
	m ^DHCEQBakData(Node,"Affix")=^DHCEQAffix
	m ^DHCEQBakData(Node,"Doc")=^DHCEQDoc
	m ^DHCEQBakData(Node,"Picture")=^DHCEQPicture
	m ^DHCEQBakData(Node,"ChangeAccount")=^DHCEQChangeAccount	
	m ^DHCEQBakData(Node,"DepreSet")=^DHCEQDepreSet	
	m ^DHCEQBakData(Node,"AppendFee")=^DHCEQAppendFee
	m ^DHCEQBakData(Node,"AppendFile")=^DHCEQAppendFile
	m ^DHCEQBakData(Node,"LifeFee")=^DHCEQLifeFee
	m ^DHCEQBakData(Node,"ChangeInfo")=^DHCEQChangeInfo
	m ^DHCEQBakData(Node,"LifeInfo")=^DHCEQLifeInfo
	m ^DHCEQBakData(Node,"Funds")=^DHCEQFunds
	
	m ^DHCEQBakData(Node,"InStock")=^DHCEQInStock
	m ^DHCEQBakData(Node,"InStockList")=^DHCEQInStockList
	m ^DHCEQBakData(Node,"StoreMove")=^DHCEQStoreMove
	m ^DHCEQBakData(Node,"StoreMoveList")=^DHCEQStoreMoveList
	m ^DHCEQBakData(Node,"Return")=^DHCEQReturn
	m ^DHCEQBakData(Node,"ReturnList")=^DHCEQReturnList
	m ^DHCEQBakData(Node,"ChangeStock")=^DHCEQChangeStock	
	m ^DHCEQBakData(Node,"Invoice")=^DHCEQInvoice
	m ^DHCEQBakData(Node,"InvoiceUseMap")=^DHCEQInvoiceUseMap
	
	m ^DHCEQBakData(Node,"ApproveInfo")=^DHCEQApproveInfo
	m ^DHCEQBakData(Node,"ApproveList")=^DHCEQApproveList
	
	m ^DHCEQBakData(Node,"Maint")=^DHCEQMaint
	m ^DHCEQBakData(Node,"MaintPlan")=^DHCEQMaintPlan
	m ^DHCEQBakData(Node,"MaintRequest")=^DHCEQMaintRequest
	m ^DHCEQBakData(Node,"Inspect")=^DHCEQInspect
	m ^DHCEQBakData(Node,"InspectPlan")=^DHCEQInspectPlan
	
	m ^DHCEQBakData(Node,"OpenCheckRequest")=^DHCEQOpenCheckRequest
	m ^DHCEQBakData(Node,"OpenCheckList")=^DHCEQOpenCheckList
	m ^DHCEQBakData(Node,"DisuseRequest")=^DHCEQDisuseRequest	
	m ^DHCEQBakData(Node,"DisuseRequestList")=^DHCEQDisuseRequestList
	
	m ^DHCEQBakData(Node,"UseRecord")=^DHCEQUseRecord
	m ^DHCEQBakData(Node,"MonthDepre")=^DHCEQMonthDepre
	m ^DHCEQBakData(Node,"MonthReportList")=^DHCEQMonthReportList
	q "finish"
}

/// 清除字典数据
/// d ##Class(web.DHCEQImportDataTool).KillCodeTable()
ClassMethod KillCodeTable()
{
 ;清除配件信息
 ;k ^DHCEQCCode("DHCEQCAccessory")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ;k ^DHCEQCCode("DHCEQCAccessoryCat")
 ;k ^DHCEQCCode("DHCEQCAccessoryType")
 
 ;清除附件信息
 ;k ^DHCEQCCode("DHCEQCAffix")
 ;k ^DHCEQCCode("DHCEQCAffixCat")
 
 ;保留附加费类型
 ;k ^DHCEQCCode("DHCEQCAppendFeeType")
 
 ;保留审批设置及相关信息
 ;k ^DHCEQCCode("DHCEQCApprFlowStepAction")
 ;k ^DHCEQCCode("DHCEQCApproveAction")
 ;k ^DHCEQCCode("DHCEQCApproveCondition")
 ;k ^DHCEQCCode("DHCEQCApproveFlow")
 ;k ^DHCEQCCode("DHCEQCApproveRole")
 ;k ^DHCEQCCode("DHCEQCApproveSet")
 ;k ^DHCEQCCode("DHCEQCApproveType")
 ;k ^DHCEQCCode("DHCEQCRoleReqFields")
 ;k ^DHCEQCCode("DHCEQCConditionFields")
 
 ;采购方式 (保留)
 ;k ^DHCEQCCode("DHCEQCBuyType")
 
 ;保留列导出设置
 ;k ^DHCEQCCode("DHCEQCTableData")
 ;k ^DHCEQCCode("DHCEQCColSet")
 ;k ^DHCEQCCode("DHCEQCColumns")
 
 ;保留系统参数设置
 ;k ^DHCEQCCode("DHCEQCSysSet")
 
 ;保留以下字典
 ;k ^DHCEQCCode("DHCEQCChangeType")
 ;k ^DHCEQCCode("DHCEQCCheckItem")
 ;k ^DHCEQCCode("DHCEQCCheckResult")
 ;k ^DHCEQCCode("DHCEQCCheckType")
 ;k ^DHCEQCCode("DHCEQCCodeTable") 
 ;k ^DHCEQCCode("DHCEQCConfigItem")
 ;k ^DHCEQCCode("DHCEQCConfigItemCat")
 ;k ^DHCEQCCode("DHCEQCCurrency")
 ;k ^DHCEQCCode("DHCEQCCycleUnit")
 ;k ^DHCEQCCode("DHCEQCDealMethod")
 ;k ^DHCEQCCode("DHCEQCDepreMethod")
 ;k ^DHCEQCCode("DHCEQCDepreType")
 ;k ^DHCEQCCode("DHCEQCDisuseType")
 ;k ^DHCEQCCode("DHCEQCDocOriginal")
 ;k ^DHCEQCCode("DHCEQCDocType")
 ;k ^DHCEQCCode("DHCEQCEmergencyLevel")
 ;k ^DHCEQCCode("DHCEQCEmployeeType")
 ;k ^DHCEQCCode("DHCEQCFaultCase")
 ;k ^DHCEQCCode("DHCEQCFaultReason")
 ;k ^DHCEQCCode("DHCEQCFaultType")
 ;k ^DHCEQCCode("DHCEQCFeeMode")
 ;k ^DHCEQCCode("DHCEQCFittings")
 ;k ^DHCEQCCode("DHCEQCFromToDept")
 ;k ^DHCEQCCode("DHCEQCFundsType")
 ;k ^DHCEQCCode("DHCEQCIFBMode")
 ;k ^DHCEQCCode("DHCEQCInspectItem")
 ;k ^DHCEQCCode("DHCEQCInspectResult")
 ;k ^DHCEQCCode("DHCEQCInspectType")
 ;k ^DHCEQCCode("DHCEQCMaintItem")
 ;k ^DHCEQCCode("DHCEQCMaintMode")
 ;k ^DHCEQCCode("DHCEQCMaintType")
 ;k ^DHCEQCCode("DHCEQCManageLevel")
 ;k ^DHCEQCCode("DHCEQCOrigin")
 ;k ^DHCEQCCode("DHCEQCOutType")
 ;k ^DHCEQCCode("DHCEQCPackType")
 ;k ^DHCEQCCode("DHCEQCPart")
 ;k ^DHCEQCCode("DHCEQCPurchaseType")
 ;k ^DHCEQCCode("DHCEQCPurposeType")
 ;k ^DHCEQCCode("DHCEQCRejectReason")
 ;k ^DHCEQCCode("DHCEQCResourceType")
 ;k ^DHCEQCCode("DHCEQCReturnReason")
 ;k ^DHCEQCCode("DHCEQCSpecialType")
 ;k ^DHCEQCCode("DHCEQCTechLevel")
 ;k ^DHCEQCCode("DHCEQCValueChangeReason")
 ;
 ;k ^DHCEQCCode("DHCEQCSysType")
 ;k ^DHCEQCCode("DHCEQCUserRole") 
 
 ;清除对照数据
 k ^DHCEQCCode("DHCEQCContrastInfo")
 ;保留对照类型
 ;k ^DHCEQCCode("DHCEQCContrastType")
 
 ;保留计数器信息
 ;k ^DHCEQCCode("DHCEQCCounter")
 ;k ^DHCEQCCode("DHCEQCCounterType")
 ;初始化计数器
 d ..InitCounter()
 
 ;清除安全组访问类组，清除安全组访问代码表
 k ^DHCEQCCode("DHCEQCGroupCTable")
 k ^DHCEQCCode("DHCEQCGroupEquipType")
 k ^DHCEQCCode("DHCEQCGroupSysType")
  
 ;保留科室组信息
 ;k ^DHCEQCCode("DHCEQCLocGroup")
 ;k ^DHCEQCCode("DHCEQCLocGroupType")
 ;清除科室类型
 k ^DHCEQCCode("DHCEQCLocType")
 ;清除库房管理科室
 k ^DHCEQCCode("DHCEQCStoreManageLoc")
  
 ;清除效益分析中的基础数据
 k ^DHCEQCCode("DHCEQCServiceItem")
 k ^DHCEQCCode("DHCEQCConsumableItem")
 k ^DHCEQCCode("DHCEQCServiceConsumable")
 k ^DHCEQCCode("DHCEQCServDetItem")
 k ^DHCEQCCode("DHCEQCServiceDetails")
  
 ;清除级别树及辅助分类
 ;k ^DHCEQCCode("DHCEQCTree")		//后有用来存68码分类，可保留 Modified By  DJ 2015-05　DJ0144
 k ^DHCEQCCode("DHCEQCTreeMap")
 ;需要增加科室级别树根节点   Add By  DJ 2015-05　DJ0144
 &SQL(insert into sqluser.dhc_eqctreemap(tm_sourcetype,tm_type,tm_treeid,tm_partreeid,tm_invalidflag) values('CT_Loc',1,'科室级别树',0,'N'))
 
 ;清除类型员工定义及用户管理科室
 k ^DHCEQCCode("DHCEQCTypeEmployee") 
 k ^DHCEQCCode("DHCEQCUserManagerLoc") 
 
 ;清除类组，类型
 ;k ^DHCEQCCode("DHCEQCEquipType")
 ;k ^DHCEQCCode("DHCEQCStatCat")
 ;保留国标分类
 ;k ^DHCEQCCode("DHCEQCEquipeCat")
 
 ;清除供应商、生产厂商、服务商、计量部门
 k ^DHCEQCCode("DHCEQCManufacturer") 
 k ^DHCEQCCode("DHCEQCMeasureDept") 
 k ^DHCEQCCode("DHCEQCVendor")
 k ^DHCEQCCode("DHCEQCService")
 
 ;清除设备项、机型、单位
 k ^DHCEQCCode("DHCEQCMasterItem")
 k ^DHCEQCCode("DHCEQCModel")
 ;k ^DHCEQCCode("DHCEQCUOM")
 
  ;清除品牌,设备配置项目,用户角色设置 Add By  DJ 2015-05　DJ0144
 k ^DHCEQCCode("DHCEQCBrand")
 k ^DHCEQCCode("DHCEQCConfigItem")
 k ^DHCEQCCode("DHCEQCUserRole")
 ;清除用户管理范围限定,维修组定义		Add By DJ 2017-01-06
 k ^DHCEQCCode("DHCEQCManageLimit")
 k ^DHCEQCCode("DHCEQCManageLimitList")
 k ^DHCEQCCode("DHCEQMCMaintGroup")
 k ^DHCEQCCode("DHCEQMCMaintGrouplist")
 k ^DHCEQCCode("DHCEQCExpenditures")
 q "OK"
}

/// 初始化设备管理的计数器信息
/// d ##Class(web.DHCEQImportDataTool).InitCounter()
ClassMethod InitCounter()
{
	n TypeID,RowID
	s RowID=0
	
	s TypeID=0
	f  s TypeID=$o(^DHCEQCCode("DHCEQCCounterType",TypeID)) quit:TypeID=""  d
	.s RowID=0
	.f  s RowID=$o(^DHCEQCCode("DHCEQCCounter",0,"Type",TypeID,RowID)) q:RowID=""  d
	..k ^DHCEQCCode("DHCEQCCounter",RowID,"EX","Group")
	&SQL(Update SQLUSer.DHC_EQCCounter set CNT_counterNum=0)
}

/// Add by JDL 2011-12-19 JDL0106
ClassMethod GetLocationID(desc)
{
	new rowid,tmpid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s desc= $ZCONVERT(desc,"U")
	s tmpid=""	
	&SQL(Select l_rowid into :tmpid  from sqluser.DHC_EQCLocation where l_desc=:desc)
	q tmpid
}

/// Add By DJ 2011-12-21
ClassMethod GetFundsType(desc)
{
	n (desc)
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	&SQL(Select FT_RowID into :tmpid From SQLUSER.DHC_EQCFundsType Where FT_Desc=:desc)
	q tmpid
}

/// Add By DJ 2015-08-21 DJ0157
ClassMethod GetbrandID(desc)
{
	new rowid,tmpid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""	
	&SQL(Select b_rowid into :tmpid  from sqluser.DHC_EQCBrand where b_desc=:desc)
	q tmpid
}

/// Add By DJ 2015-08-21 DJ0157
ClassMethod GetExpendituresID(desc)
{
	new rowid,tmpid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""	
	&SQL(Select e_rowid into :tmpid  from sqluser.DHC_EQCExpenditures where e_desc=:desc)
	q tmpid
}

ClassMethod GetTypeID(desc)
{
	new rowid,tmpid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""	
	&SQL(Select AT_RowID into :tmpid  from sqluser.DHC_EQCAccessoryType where AT_Desc=:desc and AT_InvalidFlag='N')
	q tmpid
}

ClassMethod GetCatID(code)
{
	new rowid,tmpid
	s code=##Class(web.DHCEQCommon).Trim(code)
	i code="" q ""
	s tmpid=""	
	&SQL(Select ac_rowid into :tmpid  from sqluser.DHC_EQCAccessoryCat where AC_Code=:code and AC_InvalidFlag='N')
	q tmpid
}

/// modified ZY0256 20210315 增加一些业务数据的删除
/// Add By DJ 2018-03-13
/// 描述:清除所有业务数据
/// w ##Class(web.DHCEQImportDataTool).KillBussGlobal()
ClassMethod KillBussGlobal()
{
    k ^DHCEQAccountPeriod
    k ^DHCEQAccountPeriodList
    k ^DHCEQAppendFile
	k ^DHCEQApproveInfo
	K ^DHCEQAccountList
	k ^DHCEQArrive
	k ^DHCEQArriveList
	K ^DHCEQAccountNo
	K ^DHCEQAccountNoList
	K ^DHCEQAChangeStock
	K ^DHCEQAChangeStockDetail
	K ^DHCEQAdjustData
	K ^DHCEQAdjustDataList
	K ^DHCEQAffix
	K ^DHCEQAInStock
	K ^DHCEQAInStockList
	K ^DHCEQAMonthReportList
	K ^DHCEQAMoveStock
	K ^DHCEQAMoveStockList
	K ^DHCEQAppendFee
	K ^DHCEQAppendFile
	K ^DHCEQApproveInfo
	K ^DHCEQApproveList
	K ^DHCEQAReduce
	K ^DHCEQAReduceList
	K ^DHCEQArgumentation
	K ^DHCEQAssociated
	K ^DHCEQAStock
	K ^DHCEQAStockDetail
    k ^DHCEQBUBuilding
    k ^DHCEQBUFloor
    k ^DHCEQGather
	K ^DHCEQBenefitAnaly
	K ^DHCEQBenefitAnalyList
	k ^DHCEQBenefitEquipList
	K ^DHCEQBillInfo
	K ^DHCEQBudget
	K ^DHCEQBudgetUsed
	K ^DHCEQBuilding
	K ^DHCEQBuildingChange
	K ^DHCEQBuildingUnit
	K ^DHCEQBuyPlan
	K ^DHCEQBuyPlanList
	K ^DHCEQBuyReqListAlter
	K ^DHCEQBuyRequest
	K ^DHCEQBuyRequestDetail
	K ^DHCEQBuyRequestList
	/// add by ZY0258 20210331
	k ^DHCEQBuyReqAuditInfo
	K ^DHCEQCertificate
	K ^DHCEQCertificateInfo
	K ^DHCEQCEvaluation
	K ^DHCEQCEvaluationList
	K ^DHCEQCEvaluationRoles
	K ^DHCEQChangeAccount
	K ^DHCEQChangeConfig
	K ^DHCEQChangeInfo
	K ^DHCEQChangeName
	K ^DHCEQChangeStock
	K ^DHCEQChangeYears
	K ^DHCEQCheck
	K ^DHCEQCheckAffix
	K ^DHCEQCheckConfig
	K ^DHCEQCheckDoc
	K ^DHCEQCheckEquip
	K ^DHCEQCheckList
	K ^DHCEQCheckPicture
	K ^DHCEQCheckResult
	K ^DHCEQCheckResultList
	K ^DHCEQCheckUse
	K ^DHCEQConfig
	K ^DHCEQContract
	K ^DHCEQContractAffix
	K ^DHCEQContractConfig
	K ^DHCEQContractList
	K ^DHCEQContractPayment
	/// add by ZY0258 20210331
	K ^DHCEQDataChangeLog
	K ^DHCEQDataChangeRequest
	K ^DHCEQCostAllot
	K ^DHCEQCostAllotDetail
	K ^DHCEQCostAllotList
	K ^DHCEQCTPLAT   //add by mwz 20210415 MWZ0046 
    K ^DHCEQDeptOrdItem    ///add by ZY 20220906  2705409
	K ^DHCEQDepreInfo
	K ^DHCEQDepreMonReportList
	K ^DHCEQDepreMonthReport
	K ^DHCEQDepreSet
	K ^DHCEQDepreSetDetail
	K ^DHCEQDevice
	K ^DHCEQDeviceMap
	K ^DHCEQDispatchVehicle
	K ^DHCEQDispatchVehicleList
	K ^DHCEQDisuseList
	K ^DHCEQDisuseRequest
	K ^DHCEQDisuseRequestList
	K ^DHCEQDoc
	K ^DHCEQDocMove
	K ^DHCEQDocMoveList
	K ^DHCEQEquip
	K ^DHCEQEquipBenefitEvaluate
	K ^DHCEQEquipConsumable
	K ^DHCEQEquipDoc
	K ^DHCEQEquipOperator
	K ^DHCEQEquipRange
	K ^DHCEQEquipRangeList   //modify by lmm 2020-07-28
	K ^DHCEQEquipRent
	K ^DHCEQEquipRentAffix
	K ^DHCEQEquipService
	K ^DHCEQEquipTemp
	K ^DHCEQEvaluate
	K ^DHCEQEvaluateList
	K ^DHCEQExecuMaintPlan
	K ^DHCEQExecuMaintPlanList
	K ^DHCEQExhibits
	K ^DHCEQFinancialReview
	K ^DHCEQFinancialReviewList
	K ^DHCEQFittintList
	K ^DHCEQForWJWSnapMonthReport
	K ^DHCEQFunds
	K ^DHCEQFundsDepreInfo
	K ^DHCEQFundsRecord
	K ^DHCEQGroup
	K ^DHCEQGroupList
	K ^DHCEQIFB
	K ^DHCEQIFBBag
	K ^DHCEQIFBList
	K ^DHCEQInspect
	K ^DHCEQInspectItem
	K ^DHCEQInspectPlan
	K ^DHCEQInspectPlanItem
	K ^DHCEQInStock
	K ^DHCEQInStockList
	K ^DHCEQIntangibleAssets
	K ^DHCEQInventory
	K ^DHCEQInventoryAudit		; MZY0092	2126658		2021-08-27
	K ^DHCEQInventoryException
	K ^DHCEQInventoryFilterInfo
	K ^DHCEQInventoryList
    k ^DHCEQInventoryPlan
	K ^DHCEQInvoice
	K ^DHCEQInvoiceUseMap
	K ^DHCEQIssue
	K ^DHCEQIUseRecordQueue
	K ^DHCEQIUseRecordQueueHistory
	K ^DHCEQLand
	K ^DHCEQLandLendRentInfo
	K ^DHCEQLifeFee
	K ^DHCEQLifeInfo
	K ^DHCEQMaint
	K ^DHCEQMaintItem
	K ^DHCEQMaintPart
	K ^DHCEQMaintPlan
	K ^DHCEQMaintPlanItem
	K ^DHCEQMaintPlanPart
	K ^DHCEQMaintRequest
	K ^DHCEQMergeOrder    // add by mwz MWZ0043 2020-12-15
	K ^DHCEQMergeOrderList        // add by mwz MWZ0043 2020-12-15
	K ^DHCEQMessages
	K ^DHCEQMessageSendDefine
	K ^DHCEQMessageSendInfo
	K ^DHCEQMessagesLink
	K ^DHCEQMessagesRecInfo
	K ^DHCEQMessagesRecRange
	K ^DHCEQMExObj
	K ^DHCEQMMaint
	K ^DHCEQMMaintItem
	K ^DHCEQMMaintPart
	K ^DHCEQMMaintPlan
	K ^DHCEQMMaintPlanItem
	K ^DHCEQMMaintPlanPart
	K ^DHCEQMMaintRequest
	K ^DHCEQMonthDepre
	K ^DHCEQMonthReportList
	K ^DHCEQMove
	K ^DHCEQMoveOut
	K ^DHCEQMovePosition
	K ^DHCEQMoveUsers
	/// add by ZY0258 20210331
	k ^DHCEQMultipleApproveInfo
	K ^DHCEQNotice
	K ^DHCEQOpenCheck
	K ^DHCEQOpenCheckItem
	K ^DHCEQOpenCheckList
	K ^DHCEQOpenCheckRequest
	K ^DHCEQOperateLog
	K ^DHCEQOrderItemMap
	K ^DHCEQOuterMaintRequest
	K ^DHCEQOutStock
	K ^DHCEQOutStockList
	K ^DHCEQPartList
	K ^DHCEQPaymentNotice
	K ^DHCEQPaymentNoticeList
	K ^DHCEQPayPlan
	K ^DHCEQPayRecord
	K ^DHCEQPayRecordDetail
	K ^DHCEQPayRequest
	K ^DHCEQPicture
	K ^DHCEQPictureList
	//add by lmm 2020-07-28 1435558
	K ^DHCEQPlanExecute
	K ^DHCEQPlanExecuteList
	K ^DHCEQPMReport
	K ^DHCEQPMReportList
	k ^DHCEQPNotice  //add by lmm 2020-08-03 1405955
	K ^DHCEQPrescription
	K ^DHCEQPrescriptionInfo
	K ^DHCEQPrescriptionList
	K ^DHCEQPriorityRule
	K ^DHCEQProject
    k ^DHCEQProxyAuthorization
	K ^DHCEQRefuseRecord
	K ^DHCEQRent
	K ^DHCEQRentAffix
	K ^DHCEQReturn
	K ^DHCEQReturnList
	//add by lmm 2020-07-28 1435558
	k ^DHCEQResearch
	k ^DHCEQResourceAllot	//czf 2022-01-10
	K ^DHCEQRun
	K ^DHCEQRunPlan
	K ^DHCEQServiceContract
	K ^DHCEQSharingPlatform
	K ^DHCEQSharingPlatformList
	K ^DHCEQSpecialPlant
	K ^DHCEQStateInfo
	K ^DHCEQStock
	K ^DHCEQStoreMonthStat
	K ^DHCEQStoreMonthStatList
	K ^DHCEQStoreMove
	K ^DHCEQStoreMoveList
	K ^DHCEQStructures
	K ^DHCEQSwap
	K ^DHCEQSwapList
	K ^DHCEQSwapListDetail
	K ^DHCEQTempEquip
	K ^DHCEQTempImport
	K ^DHCEQTempLocMap
	K ^DHCEQUseConsumableItem
	K ^DHCEQUseConsumableStat
	K ^DHCEQUsedResource
	K ^DHCEQUsedResourceItem
	K ^DHCEQUserDefinedInfo
	K ^DHCEQUserDefinedInfoList
	K ^DHCEQUseRecord
	K ^DHCEQUseRecordEquip
	K ^DHCEQUseRecordStat
	K ^DHCEQVehicle
	K ^DHCEQWash
	K ^DHCEQWashList
	K ^DHCEQWChatBindLog
	K ^DHCEQWChatLog
	K ^DHCEQWChatUser
	K ^DHCEQCourse	//start by csj 2020-07-02 考核培训数据清除 需求号：1398506
	k ^DHCEQTrainingRecord
	k ^DHCEQTrainingRecordList
	k ^DHCEQTrainingUser
	k ^DHCEQTrainingScore
	k ^DHCEQTrainingScoreList
	k ^DHCEQOperateInfo //end by csj 2020-07-02
	k ^DHCEQSResourcePrice	//start by csj 2020-07-03 资源共享数据清除 需求号：	1398494
	k ^DHCEQSResourceHistoryPrice
	k ^DHCEQSRent
	k ^DHCEQSRentFee
	k ^DHCEQSShareResource
	k ^DHCEQSPutOnSet
	k ^DHCEQSRentMaintMap
	k ^DHCEQSRentCostAllot
	k ^DHCEQMoveAffix 
	//k ^DHCEQSCPriceType	//费用类型不用清
	k ^DHCEQSCItemAffix
	k ^DHCEQSCShareItemCat
	k ^DHCEQSCShareItem
	k ^DHCEQSCShareItemList //end by csj 2020-07-03
	k ^DHCEQEquipAttributeList		//czf 20200707 1405740
	k ^DHCEQSnapShot		///Modefied by ZC0081 2020-09-07 快照删除
	k ^DHCEQBindObj			//设备绑定码  czf 2021-01-04 begin
	k ^DHCEQBussWarnDays	//预警天数
	k ^DHCEQCertificateType
	k ^DHCEQAppraisalReport //zyq 20220922 鉴定报告删除
	k ^DHCEQContractListLoc	//合同明细多科室
	k ^DHCEQDelete			//验收删除
	//k ^DHCEQDeptOrdItem
	k ^DHCEQEconCalc
	k ^DHCEQEquipGetEquipList
	k ^DHCEQEquipGuaranteeInfo
	k ^DHCEQEquipShadow
	k ^DHCEQFinancialReviewEquip	//财务监审设备
	k ^DHCEQFinancialReviewFunds	//财务监审设备资金来源
	k ^DHCEQFund
	k ^DHCEQIUsedRecord
	k ^DHCEQImportResult
	k ^DHCEQInStockListLoc		//入库多科室
	k ^DHCEQInventoryListInfo
	k ^DHCEQLog
	k ^DHCEQMark		//台账设备修改记录
	k ^DHCEQOpenCheckListLoc	//验收多科室
	k ^DHCEQPLATProductMap		//产品库对照
	k ^DHCEQPReason			//报废原因
	k ^DHCEQPreCostAllotDetail	//预折旧成本分摊
	k ^DHCEQPreFunds		//预折旧资金来源
	k ^DHCEQPreMonthDepre	//预折旧
	k ^DHCEQReduceInfo		//设备处置
	k ^DHCEQRiskEvaluation	//风险评估
	k ^DHCEQRiskEvaluationList	//风险评估明细
	k ^DHCEQSBill			//租借账单
	k ^DHCEQSBillList		//租借账单明细
	k ^DHCEQSEquipRent
	k ^DHCEQSplit			//设备拆分
	k ^DHCEQSplitList		//设备拆分明细
	k ^DHCEQTempExpenditures
	k ^DHCEQTempFunds		//单据调整资金来源
	k ^DHCEQTempOrigin
	k ^DHCEQTempPurposeType
	k ^DHCEQTempSplitList	//拆分明细设备
	k ^DHCEQUseContext
#;	k ^DHCDT3DAlarm
#;	k ^DHCDT3DAlarmProcess
#;	k ^DHCDT3DBuildUnit
#;	k ^DHCDT3DBuildUnitPosition
#;	k ^DHCDT3DBuilding
#;	k ^DHCDT3DBuildingConf
#;	k ^DHCDT3DClinic
#;	k ^DHCDT3DDoor
#;	k ^DHCDT3DEmployee
#;	k ^DHCDT3DEmployeeCurPos
#;	k ^DHCDT3DEvent
#;	k ^DHCDT3DExit
#;	k ^DHCDT3DExitList
#;	k ^DHCDT3DFloor
#;	k ^DHCDT3DFloorExpand
#;	k ^DHCDT3DImgMap
#;	k ^DHCDT3DModeConf
#;	k ^DHCDT3DModel
#;	k ^DHCDT3DModelPartMap
#;	k ^DHCDT3DObjHisPos
#;	k ^DHCDT3DObjHisPosition
#;	k ^DHCDT3DObjMap
#;	k ^DHCDT3DObjectModel
#;	k ^DHCDT3DOnlineCheck
#;	k ^DHCDT3DOnlineCheckList
#;	k ^DHCDT3DOperDept
#;	k ^DHCDT3DPerson
#;	k ^DHCDT3DSensor
#;	k ^DHCDT3DWard
#;	k ^DHCDT3DWatchingFocus
#;	k ^DHCEQBUBuilding
#;	k ^DHCEQBUBuildingUnit
#;	k ^DHCEQBUBuildingUnitShare
#;	k ^DHCEQBUFloor
#;	k ^DHCEQBUMRoomOrder		//czf 2021-01-04 end
	
	s sqlcode=##Class(web.DHCEQImportDataTool).CreatPNotice()
	i sqlcode q sqlcode
	q "业务数据清除结束!"
}

/// add by lmm 2020-08-03 1405955
/// desc:清除global后新增公告基础数据（导入模板）
/// w ##Class(web.DHCEQImportDataTool).CreatPNotice()
ClassMethod CreatPNotice()
{
	new OCRRowID,tmpid,OCRowID
	&SQL(Insert Into SQLUser.DHC_EQPNotice (N_HospitalDR,N_NoticeCat,N_Title,N_PublishDate,N_PublishTime,N_ContentType,N_ManageLocDR,N_Status,N_InvalidFlag,N_SourceType,N_SourceID) 
	values ('2','5','固定资产系统基础数据模板','42259','65492','2','327','2','N','1','0') )
	 i SQLCODE q SQLCODE_"A"
	s OCRRowID=$G(%ROWID)
	s OperateInfo="^67^"_OCRRowID_"^1^^0"
 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
 	
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','hisui组件及菜单修改导入模板','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	 i SQLCODE q SQLCODE_"B"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','安全组菜单权限分配','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	 i SQLCODE q SQLCODE_"C"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','菜单基础信息导入','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	 i SQLCODE q SQLCODE_"D"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','组件列相关导入模板','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	 i SQLCODE q SQLCODE_"E"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','数据准备模板','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	 i SQLCODE q SQLCODE_"F"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','设备相关数据导入模板','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	 i SQLCODE q SQLCODE_"G"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','核算项目导入','/DHCEQ/DHCEQAppendFile/','xlsx','1','42259','65492','0','N','N') )
	 i SQLCODE q SQLCODE_"H"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','PM模板','/DHCEQ/DHCEQAppendFile/','xlsx','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"I"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','保养项目','/DHCEQ/DHCEQAppendFile/','xlsx','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"J"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','标准设备项','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"K"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','设备仪器服务项对照导入模板','/DHCEQ/DHCEQAppendFile/','xlsx','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"L"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','使用记录数据导入模板','/DHCEQ/DHCEQAppendFile/','xlsx','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"M"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','配件导入模板','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"N"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRRowID,'32','系统参数配置','/DHCEQ/DHCEQAppendFile/','xlsx','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"O"
 	
 	
	&SQL(Insert Into SQLUser.DHC_EQPNotice (N_HospitalDR,N_NoticeCat,N_Title,N_PublishDate,N_PublishTime,N_ContentType,N_ManageLocDR,N_Status,N_InvalidFlag,N_SourceType,N_SourceID) 
	values ('2','6','固定资产系统业务数据模板','42259','65492','2','327','2','N','1','0') )
	  i SQLCODE q SQLCODE_"P"
	s OCRowID=$G(%ROWID)
	s OperateInfo="^67^"_OCRowID_"^1^^0"
 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
	  i SQLCODE q SQLCODE_"Q"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRowID,'32','验收单','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"R"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRowID,'32','数据调账模版','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"S"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRowID,'32','科室分摊数据导入模板','/DHCEQ/DHCEQAppendFile/','xlsx','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"T"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRowID,'32','批量数据调整','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	  i SQLCODE q SQLCODE_"U"
	&SQL(Insert Into SQLUser.DHC_EQAppendFile (AF_SourceType,AF_SourceID,AF_AppendFileTypeDR,AF_DocName,AF_FilePath,AF_FileType,AF_AddUserDR,AF_AddDate,AF_AddTime,AF_Stauts,AF_InvalidFlag,AF_ToSwfFlag) 
	values ('67',:OCRowID,'32','批量采购合同信息模版','/DHCEQ/DHCEQAppendFile/','xls','1','42259','65492','0','N','N') )
	 i SQLCODE q SQLCODE_"V"
	q 0
}

// add by zc0052 20191030

// MZY0076	2021-05-25

ClassMethod GetMaintItemCatID(code, type As %Library.String = "1")
{
	new rowid,tmpid
	s code=##Class(web.DHCEQCommon).Trim(code)
	i code="" q ""
	s tmpid=""	
	&SQL(Select mic_rowid into :tmpid  from sqluser.DHC_EQCMaintItemCat where mic_desc=:code and MIC_Type=:type)
	q tmpid
}

/// add by zc0052 20191030
/// w ##Class(web.DHCEQImportDataTool).GetMaintItemID("主要操作模式（2D/M-mode/Doppler/Color/3D/4D）是否正常","开机检查",2)
ClassMethod GetMaintItemID(code, mcode, type As %Library.String = "1")
{
	new rowid,tmpid,maintcatid
	s code=##Class(web.DHCEQCommon).Trim(code)
	i code="" q ""
	s maintcatid=##Class(web.DHCEQImportDataTool).GetMaintItemCatID(mcode, type)
	i maintcatid="" q ""
	
	s tmpid=""
	;&SQL(Select mi_rowid into :tmpid  from sqluser.DHC_EQCMaintItem where mi_desc=:code and MI_ItemCatDR=:maintcatid and MI_Type=:type)
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCMaintItem",0,"ItemcatDR",maintcatid,rowid)) q:(rowid="")||(tmpid'="")  d
	.q:$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",4)'="N"
	.q:$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",5)'=type
	.i code=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",2) s tmpid=rowid
	
	q tmpid
}

/// Add By CZF 2020-03-19 CZF0105
/// 描述:清除基础数据
/// d ##Class(web.DHCEQImportDataTool).KillCodeNew("1")
ClassMethod KillCodeNew(Type As %String = "")
{
	k ^DHCEQCCode("DHCEQCAccessory")    //配件信息
	;k ^DHCEQCCode("DHCEQCAccessoryCat")    //
	;k ^DHCEQCCode("DHCEQCAccessoryOriginal")    //
	;k ^DHCEQCCode("DHCEQCAccessoryType")    //
	;k ^DHCEQCCode("DHCEQCAction")    //动作
	k ^DHCEQCCode("DHCEQCAffix")    //附件信息
	k ^DHCEQCCode("DHCEQCAffixCat")    //
	k ^DHCEQCCode("DHCEQCAlias")    //别名表,目前用于科室拼音码
	;k ^DHCEQCCode("DHCEQCAppendFeeType")    //附加费用类型
	;k ^DHCEQCCode("DHCEQCAppendFileType")    //文件类型
	;k ^DHCEQCCode("DHCEQCApprFlowStepAction")    //审批设置及相关信息
	;k ^DHCEQCCode("DHCEQCApproveAction")    //
	;k ^DHCEQCCode("DHCEQCApproveCondition")    //
	;k ^DHCEQCCode("DHCEQCApproveFlow")    //
	;k ^DHCEQCCode("DHCEQCApproveFlowAllow")    //
	;k ^DHCEQCCode("DHCEQCApproveRole")    //
	;k ^DHCEQCCode("DHCEQCApproveSet")    //
	;k ^DHCEQCCode("DHCEQCApproveType")    //
	;k ^DHCEQCCode("DHCEQCBarDetail")    //条码打印配置
	;k ^DHCEQCCode("DHCEQCBarDetailKey")    //
	;k ^DHCEQCCode("DHCEQCBarInfo")    //
	;k ^DHCEQCCode("DHCEQCBarSet")    //
	k ^DHCEQCCode("DHCEQCBenefitItem")    //？
	k ^DHCEQCCode("DHCEQCBrand")    //品牌
	;k ^DHCEQCCode("DHCEQCBuildingStruct")    //建筑结构
	;k ^DHCEQCCode("DHCEQCBussType")    //业务类型
	;k ^DHCEQCCode("DHCEQCBuyType")    //采购方式
	;k ^DHCEQCCode("DHCEQCCertificateType")    //证件类型
	;k ^DHCEQCCode("DHCEQCChangeType")    //变动类型
	;k ^DHCEQCCode("DHCEQCChartsColorScheme")    //？
	;k ^DHCEQCCode("DHCEQCChartsDefine")    //？
	;k ^DHCEQCCode("DHCEQCCheckItem")    //检查项
	;k ^DHCEQCCode("DHCEQCCheckResult")    //检查结果
	;k ^DHCEQCCode("DHCEQCCheckType")    //检查类型
	;k ^DHCEQCCode("DHCEQCColSet")    //导出列信息
	;k ^DHCEQCCode("DHCEQCColumns")    //
	;k ^DHCEQCCode("DHCEQCCompanyType")    //公司类型
	;k ^DHCEQCCode("DHCEQCComponent")    //组件信息
	;k ^DHCEQCCode("DHCEQCComponentItem")    //
	;k ^DHCEQCCode("DHCEQCComponentParas")    //
	;k ^DHCEQCCode("DHCEQCComponentSet")    //
	;k ^DHCEQCCode("DHCEQCComponentSetItem")    //
	;k ^DHCEQCCode("DHCEQCConditionFields")    //审批工作流条件
	k ^DHCEQCCode("DHCEQCConfigItem")    //设备配置项信息
	k ^DHCEQCCode("DHCEQCConfigItemCat")    //
	k ^DHCEQCCode("DHCEQCConsumableItem")    //消耗项
	k ^DHCEQCCode("DHCEQCContrastInfo")    //对照信息
	;k ^DHCEQCCode("DHCEQCContrastType")    //对照类型
	;k ^DHCEQCCode("DHCEQCCostAllotType")    //分摊方式
	//清除计数器
	;k ^DHCEQCCode("DHCEQCCounter")    //计数器信息
	;k ^DHCEQCCode("DHCEQCCounterType")    //
	//初始化计数器
	d ..InitCounter()
	;k ^DHCEQCCode("DHCEQCCurrency")    //币种
	;k ^DHCEQCCode("DHCEQCCycleUnit")    //周期单位
	;k ^DHCEQCCode("DHCEQCDealMethod")    //解决方法
	k ^DHCEQCCode("DHCEQCDepartment")    //部门信息
	;k ^DHCEQCCode("DHCEQCDepreMethod")    //折旧方法
	;k ^DHCEQCCode("DHCEQCDepreType")    //折旧方式
	;k ^DHCEQCCode("DHCEQCDisuseType")    //报废方式
	;k ^DHCEQCCode("DHCEQCDocOriginal")    //文件来源
	;k ^DHCEQCCode("DHCEQCDocType")    //文件类型
	;k ^DHCEQCCode("DHCEQCElement")    //？
	;k ^DHCEQCCode("DHCEQCElementCat")    //？
	;k ^DHCEQCCode("DHCEQCElementGroup")    //？
	;k ^DHCEQCCode("DHCEQCElementValues")    //？
	;k ^DHCEQCCode("DHCEQCEmergencyLevel")    //紧急级别
	;k ^DHCEQCCode("DHCEQCEmployeeCertificateType")    //员工证件类型
	;k ^DHCEQCCode("DHCEQCEmployeeType")    //员工类型
	;k ^DHCEQCCode("DHCEQCEquipAttribute")    //设备属性
	;k ^DHCEQCCode("DHCEQCEquipType")    //类组
	;k ^DHCEQCCode("DHCEQCEquipeCat")    //设备分类
	;k ^DHCEQCCode("DHCEQCEvaluateGroup")    //评价组
	;k ^DHCEQCCode("DHCEQCEvaluateType")    //评价指标
	;k ^DHCEQCCode("DHCEQCExpenditures")    //经费来源
	;k ^DHCEQCCode("DHCEQCFactor")    //？
	;k ^DHCEQCCode("DHCEQCFaultCase")    //故障现象
	;k ^DHCEQCCode("DHCEQCFaultReason")    //故障原因
	;k ^DHCEQCCode("DHCEQCFaultType")    //故障类型
	;k ^DHCEQCCode("DHCEQCFeeMode")    //
	;k ^DHCEQCCode("DHCEQCFeeRules")    //
	;k ^DHCEQCCode("DHCEQCFinaceItem")    //核算项目
	;k ^DHCEQCCode("DHCEQCFinanceType")    //财务大类
	;k ^DHCEQCCode("DHCEQCFittings")    //
	;k ^DHCEQCCode("DHCEQCFrequency")    //
	k ^DHCEQCCode("DHCEQCFromToDept")    //调拨单位
	k ^DHCEQCCode("DHCEQCFunctionCat")    //功能分类？
	;k ^DHCEQCCode("DHCEQCFundsType")    //资金来源类型
	;k ^DHCEQCCode("DHCEQCGroupAccessoryType")    //安全组访问配件类组？
	k ^DHCEQCCode("DHCEQCGroupCTable")    //安全组访问代码
	k ^DHCEQCCode("DHCEQCGroupEquipType")    //安全组访问设备类组
	k ^DHCEQCCode("DHCEQCGroupFundsType")    //安全组访问资金来源
	k ^DHCEQCCode("DHCEQCGroupHospital")    //
	;k ^DHCEQCCode("DHCEQCGroupPicType")    //
	;k ^DHCEQCCode("DHCEQCGroupRole")    //
	k ^DHCEQCCode("DHCEQCGroupSysType")    //？
	;k ^DHCEQCCode("DHCEQCHanZiEncoding")    //
	;k ^DHCEQCCode("DHCEQCIFBAgency")    //
	;k ^DHCEQCCode("DHCEQCIFBMode")    //招标方式
	;k ^DHCEQCCode("DHCEQCInspectItem")    //检查项
	;k ^DHCEQCCode("DHCEQCInspectResult")    //检查结果
	;k ^DHCEQCCode("DHCEQCInspectType")    //检查方式
	;k ^DHCEQCCode("DHCEQCInvoiceType")    //发票类型？
	;k ^DHCEQCCode("DHCEQCLandPurpose")    //？
	;k ^DHCEQCCode("DHCEQCLendType")    //？
	;k ^DHCEQCCode("DHCEQCLocGroup")    //科室职能
	;k ^DHCEQCCode("DHCEQCLocGroupType")    //科室属性
	k ^DHCEQCCode("DHCEQCLocType")    //科室类型
	;k ^DHCEQCCode("DHCEQCLocation")    //存放地点
	;k ^DHCEQCCode("DHCEQCMaintItem")    //？
	;k ^DHCEQCCode("DHCEQCMaintItemCat")    //？
	;k ^DHCEQCCode("DHCEQCMaintMode")    //维修方式
	;k ^DHCEQCCode("DHCEQCMaintType")    //维护类型
	;k ^DHCEQCCode("DHCEQCManageLevel")    //管理界别
	k ^DHCEQCCode("DHCEQCManageLimit")    //用户管理范围限定
	k ^DHCEQCCode("DHCEQCManageLimitList")    //
	k ^DHCEQCCode("DHCEQCManufacturer")    //生产厂商
	;k ^DHCEQCCode("DHCEQCMasterItem")    //设备项
	k ^DHCEQCCode("DHCEQCMeasureDept")    //计量部门
	k ^DHCEQCCode("DHCEQCMessagesResult")    //？
	;k ^DHCEQCCode("DHCEQCModel")    //机型
	;k ^DHCEQCCode("DHCEQCMultipleDefine")    //？
	k ^DHCEQCCode("DHCEQCNormalValues")    //？
	;k ^DHCEQCCode("DHCEQCOrigin")    //设备来源
	k ^DHCEQCCode("DHCEQCOutReason")    //退货原因
	;k ^DHCEQCCode("DHCEQCOutType")    //退货方式
	;k ^DHCEQCCode("DHCEQCPDABroadcast")    //pda广播
	;k ^DHCEQCCode("DHCEQCPMTemplate")    //PM模板
	;k ^DHCEQCCode("DHCEQCPMTemplateList")    //
	;k ^DHCEQCCode("DHCEQCPackType")    //
	;k ^DHCEQCCode("DHCEQCPart")    //
	;k ^DHCEQCCode("DHCEQCPayCostType")    //付款用途
	;k ^DHCEQCCode("DHCEQCPayMode")    //付款方式
	;k ^DHCEQCCode("DHCEQCPayType")    //付款类型
	;k ^DHCEQCCode("DHCEQCPicSourceType")    //图片类型访问权限
	;k ^DHCEQCCode("DHCEQCPicType")    //图片类型
	;k ^DHCEQCCode("DHCEQCPromptInfo")    //
	;k ^DHCEQCCode("DHCEQCPurchaseType")    //采购方式
	;k ^DHCEQCCode("DHCEQCPurposeType")    //设备用途
	k ^DHCEQCCode("DHCEQCRejectReason")    //拒绝原因
	;k ^DHCEQCCode("DHCEQCResourceType")    //消耗资源类型
	;k ^DHCEQCCode("DHCEQCReturnReason")    //退货原因
	;k ^DHCEQCCode("DHCEQCRiskGrade")    //风险级别
	;k ^DHCEQCCode("DHCEQCRiskItem")    //
	;k ^DHCEQCCode("DHCEQCRiskItemValue")    //
	;k ^DHCEQCCode("DHCEQCRoleBuss")    //角色定义
	k ^DHCEQCCode("DHCEQCRoleLimitAmount")    //？
	;k ^DHCEQCCode("DHCEQCRoleReqElement")    //？
	;k ^DHCEQCCode("DHCEQCRoleReqFields")    //可编辑字段
	k ^DHCEQCCode("DHCEQCServDetItem")    //服务细项定义表
	k ^DHCEQCCode("DHCEQCService")    //服务商
	k ^DHCEQCCode("DHCEQCServiceConsumable")    //服务消耗项
	k ^DHCEQCCode("DHCEQCServiceDetails")    //服务
	k ^DHCEQCCode("DHCEQCServiceItem")    //服务项
	k ^DHCEQCCode("DHCEQCSpecialType")    //特种类型
	;k ^DHCEQCCode("DHCEQCStatCat")    //设备类型
	k ^DHCEQCCode("DHCEQCStoreManageLoc")    //库房管理科室
	;k ^DHCEQCCode("DHCEQCSysGroupMenu")    //安全组访问菜单(移动端)
	;k ^DHCEQCCode("DHCEQCSysMenus")    //功能模块菜单维护
	;k ^DHCEQCCode("DHCEQCSysSet")    //系统配置
	;k ^DHCEQCCode("DHCEQCSysType")    //系统类型
	;k ^DHCEQCCode("DHCEQCTableData")    //导出列
	;k ^DHCEQCCode("DHCEQCTechLevel")    //？
	;k ^DHCEQCCode("DHCEQCTemplate")    //模板？
	;k ^DHCEQCCode("DHCEQCTemplateList")    //
	;k ^DHCEQCCode("DHCEQCTree")    //68分类
	k ^DHCEQCCode("DHCEQCTreeMap")    //
	&SQL(insert into sqluser.dhc_eqctreemap(tm_sourcetype,tm_type,tm_treeid,tm_partreeid,tm_invalidflag) values('CT_Loc',1,'科室级别树',0,'N'))
	;k ^DHCEQCCode("DHCEQCTypeDefine")    //？
	k ^DHCEQCCode("DHCEQCTypeEmployee")    //设备员工定义
	;k ^DHCEQCCode("DHCEQCUOM")    //单位
	k ^DHCEQCCode("DHCEQCUser")    //用户
	;k ^DHCEQCCode("DHCEQCUserDefined")    //
	;k ^DHCEQCCode("DHCEQCUserDefinedList")    //
	k ^DHCEQCCode("DHCEQCUserManagerLoc")    //用户管理科室
	;k ^DHCEQCCode("DHCEQCUserRole")    //用户角色
	;k ^DHCEQCCode("DHCEQCValueChangeReason")    //值变动原因
	;k ^DHCEQCCode("DHCEQCVendor")    //供应商，生产厂商，服务商
	k ^DHCEQCCode("DHCEQContrastInfo")    //对照信息
	;k ^DHCEQCCode("DHCEQContrastType")    //对照类型
	;k ^DHCEQCCode("DHCEQETNotAccessSC")    //类组禁止访问类型
	;k ^DHCEQCCode("DHCEQEquipStatus")    //设备状态
	;k ^DHCEQCCode("DHCEQForCWJW")    //卫计委接口
	;k ^DHCEQCCode("DHCEQCInHospitalType")    //院内分类 属性分类
	;k ^DHCEQCCode("DHCEQMCCaseReasonDealMap")    //
	;k ^DHCEQCCode("DHCEQMCDealMethod")    //维修知识库-解决方法
	;k ^DHCEQCCode("DHCEQMCEmergencyLevel")    //维修知识库-紧急级别
	;k ^DHCEQCCode("DHCEQMCEvaluateType")    //维修知识库-评价指标
	;k ^DHCEQCCode("DHCEQMCFaultCase")    //维修知识库-故障现象
	k ^DHCEQCCode("DHCEQMCFaultEquipMap")    //
	;k ^DHCEQCCode("DHCEQMCFaultReason")    //维修知识库-故障原因
	;k ^DHCEQCCode("DHCEQMCFaultType")    //维修知识库-故障类型
	k ^DHCEQCCode("DHCEQMCMaintGroup")    //维修组
	k ^DHCEQCCode("DHCEQMCMaintGroupList")    //维修组明细
	;k ^DHCEQCCode("DHCEQMCMaintItem")    //维修基础数据-维护项目
	;k ^DHCEQCCode("DHCEQMCMaintMode")    //维修基础数据-维修方式
	;k ^DHCEQCCode("DHCEQMCMaintProcess")    //维修基础数据-
	;k ^DHCEQCCode("DHCEQMCMaintResults")    //维修基础数据-维修结果
	;k ^DHCEQCCode("DHCEQMCMaintType")    //维修基础数据-维护类型
	k ^DHCEQCCode("DHCEQMCManageType")    //维修基础数据-管理类型
	k ^DHCEQCCode("DHCEQMCObjType")    //维修基础数据-维修对象类型
	k ^DHCEQCCode("DHCEQMCPart")    //维修基础数据-维修部位
	;k ^DHCEQCCode("DHCEQMCSeverityLevel")    //维修基础数据-严重级别
	k ^DHCEQCCode("DHCEQPCContactPerson")    //联系人
	;k ^DHCEQCCode("DHCEQPCNoticeCat")		//公告类型
	;k ^DHCEQCCode("DHCEQCBillSet")			//
	;k ^DHCEQCCode("DHCEQCComponentZone")	//
	;k ^DHCEQCCode("DHCEQCFirmContrast")	//公司对照
	;k ^DHCEQCCode("DHCEQCGroupEquipAttribute")	//安全组访问设备属性
	;k ^DHCEQCCode("DHCEQCGroupNoticeCat")		//安全组访问公告
	;k ^DHCEQCCode("DHCEQCLocUser")				//科室人员
	;k ^DHCEQCCode("DHCEQMCFactor")
	;k ^DHCEQCCode("DHCEQMCMaintItemFactor")
	;k ^DHCEQCCode("DHCEQMCMaintItemNormalValues")
	;k ^DHCEQCCode("DHCEQMCMaintItemValues")

	;k ^DHCEQCCodeTable    //标准代码表
	i Type=1 
	{
		k ^DHCEQCCode("DHCEQCLocation")
		k ^DHCEQCCode("DHCEQCMasterItem")
		k ^DHCEQCCode("DHCEQCModel")
		k ^DHCEQCCode("DHCEQCVendor")
		k ^DHCEQCCode("DHCEQCFirmContrast")	//公司类型对照
	}
	//删除医院表关联关系
	w "deleteBDPMapping:"_..deleteBDPMapping(Type),!
	
	//初始化科室 add by czf 20200404
	w "InitDepartment:"_##Class(web.DHCEQInit).InitDepartment(),!
	
	//初始化科室拼音码 add by ZY0243 20200917
	w "InitAlias:"_##Class(web.DHCEQInit).InitAlias("DHC_EQCDepartment"),!
	
	//初始化人员 add by czf 20200404
	w "InitDHCEQUser:"_##Class(web.DHCEQInit).InitDHCEQUser(),!
	w "OK"
}

/// czf 2022-11-04
/// 删除医院关联表中DHC_EQCFunctionCat，DHC_EQCFinaceItem，DHC_EQCMasterItem，DHC_EQCLocation关联数据
ClassMethod deleteBDPMapping(Type As %String = "")
{
	&SQL(delete FROM SQLUser.BDP_MappingHosp where BDPMPH_TableName="DHC_EQCFunctionCat")
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE q "删除DHC_EQCFunctionCat医院表对照错误,SQLCODE="_SQLCODE_",错误信息:"_$g(%msg)
	
	&SQL(delete FROM SQLUser.BDP_MappingHosp where BDPMPH_TableName="DHC_EQCFinaceItem")
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE q "删除DHC_EQCFinaceItem医院表对照错误,SQLCODE="_SQLCODE_",错误信息:"_$g(%msg)
	
	i Type=1
	{
		&SQL(delete FROM SQLUser.BDP_MappingHosp where BDPMPH_TableName="DHC_EQCMasterItem")
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE q "删除DHC_EQCMasterItem医院表对照错误,SQLCODE="_SQLCODE_",错误信息:"_$g(%msg)
		
		&SQL(delete FROM SQLUser.BDP_MappingHosp where BDPMPH_TableName="DHC_EQCLocation")
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE q "删除DHC_EQCLocation医院表对照错误,SQLCODE="_SQLCODE_",错误信息:"_$g(%msg)
	}
	q "success"
}

/// add by czf 2021-04-14
ClassMethod GetFinanceTypeID(desc)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	s desc=$ZCONVERT(desc,"U")
	&SQL(Select ft_rowid into :tmpid  from sqluser.DHC_EQCFinanceType where ft_desc=:desc)
	q tmpid
}

/// add by ZY0271 20210620
/// w ##Class(web.DHCEQImportDataTool).GetGroupID("Demo Group")
ClassMethod GetGroupID(desc)
{
	new rowid,tmpid,rowid
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	&SQL(Select SSGRP_rowid into :tmpid  from sqluser.SS_Group where SSGRP_desc=:desc)
	q tmpid
}

ClassMethod GetHospID(desc)
{
	s desc=##Class(web.DHCEQCommon).Trim(desc)
	i desc="" q ""
	s tmpid=""
	&SQL(select H_RowID into :tmpid from sqluser.DHC_EQKBHospital where  H_Desc=:desc)
	q tmpid
}

}
