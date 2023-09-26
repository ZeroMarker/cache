/// 名称: 公私有数据关联医院
/// 编写者：基础数据平台组 chenying 
/// 编写日期: 2018-4-16
Class web.DHCBL.BDP.BDPMappingHOSP Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// web.DHCBL.BDP.BDPConfig / web.DHCBL.BDP.FunLib / User.BDPMappingHosp / web.DHCBL.Authorize.BDPHospitalAut
/// Function:保存关联关系
/// Creator:chenying 
/// CreateDate:2018-4-16
/// input:BDPMPHTableName(表名称,如ARC_ItemCat)/BDPMPHDataReference(对应表数据RowID如 医嘱子分类rowid 12)/BDPMPHHospital(关联的医院,医院rowid 2) 
/// Debug： w ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("ARC_ItemCat",12,2)
ClassMethod SaveHOSP(BDPMPHTableName As %String, BDPMPHDataReference As %String, BDPMPHHospital As %String) As %String
{
    n (BDPMPHTableName,BDPMPHDataReference,BDPMPHHospital)
    s result=1
    //s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
    //if BDPHospAutflag = "Y"
    //{
        if (BDPMPHTableName="") 
        {
           s result="-1^表名不能为空"
        }
        elseif(BDPMPHDataReference="") 
        {
           s result="-1^对应表数据RowID不能为空"
        }
        elseif(BDPMPHHospital="") 
        {
           s result="-1^关联的医院不能为空"
        }
        else
        { 
            //20200509 likefan 根据表名和医院获取医院对应的默认医院组
	    	//s DefHospId=..GetDefHospIdByTableName(BDPMPHTableName,BDPMPHHospital)
	    	//s:($p(DefHospId,"^",1)'="-1") BDPMPHHospital=DefHospId
	    	
            if ($d(^User.BDPMappingHospI("HospRef",BDPMPHTableName,BDPMPHDataReference,BDPMPHHospital))) q result
            s obj=##class(User.BDPMappingHosp).%New()
            s obj.BDPMPHTableName=BDPMPHTableName
            s obj.BDPMPHDataReference=BDPMPHDataReference
            d obj.BDPMPHHospitalSetObjectId(BDPMPHHospital)
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc) 
            {   
                Tc
                s id=obj.%Id()
                s result=id_"^添加成功"
            }
            else
            {
                Trollback
                s result="-1^添加失败"
            }
        }
    //}
    //else
    //{
    //    s result="-1^没有开启医院级授权"
    //}
    q result
}

/// Function: 删除表里某条数据时，删除跟他所有关联医院关系
/// Creator:  chenying
/// CreatDate:2019-08-09
/// input:表名称(BDPMPHTableName，如ARC_ItemCat)/对应表数据RowID(BDPMPHDataReference,如 医嘱子分类rowid 12)
/// debug:    w ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospitals("CT_SocialStatus",31)
ClassMethod DeleteHospitals(BDPMPHTableName As %String, BDPMPHDataReference As %String) As %String
{
    ;遍历查找出关联医院表的id 
    n (BDPMPHTableName,BDPMPHDataReference,%session)
    s result=1 
    q:BDPMPHTableName="" result
    q:BDPMPHDataReference="" result
    if ($d(^User.BDPMappingHospI("HospRef",BDPMPHTableName,BDPMPHDataReference)))
    {
        s BDPMPHHospital=0
        for
        {
            
            s BDPMPHHospital=$O(^User.BDPMappingHospI("HospRef",BDPMPHTableName,BDPMPHDataReference,BDPMPHHospital))  q:BDPMPHHospital=""
            s ID=0
            for
            {
                s ID=$O(^User.BDPMappingHospI("HospRef",BDPMPHTableName,BDPMPHDataReference,BDPMPHHospital,ID))  q:ID=""
                s sc=##class(User.BDPMappingHosp).%DeleteId(ID)
                if (sc'=1)
                {
                   
                   s result=-1
                }
            }
        }
    }
   
    q result
}

/// Function: 删除关联医院
/// Creator:  sunfengchao
/// debug:    w ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospital("PAC_Room","111","2")
ClassMethod DeleteHospital(BDPMPHTableName As %String, BDPMPHDataReference As %String, BDPMPHHospital As %String) As %String
{
    ;遍历查找出关联医院表的id 
    n (BDPMPHTableName,BDPMPHDataReference,BDPMPHHospital,%session)
    s result=1 
    q:BDPMPHTableName="" 1
    q:BDPMPHHospital="" 1
    q:BDPMPHDataReference="" 1
    if ($d(^User.BDPMappingHospI("DataRef",BDPMPHTableName,BDPMPHHospital,BDPMPHDataReference)))
    {
	    
	    s ID=$O(^User.BDPMappingHospI("DataRef",BDPMPHTableName,BDPMPHHospital,BDPMPHDataReference,0))
        q:ID="" "-1^关联医院表数据删除失败"
        tstart
        s sc=##class(User.BDPMappingHosp).%DeleteId(ID)
        if (sc=1)
        {
            tcommit
        }
        else
        {
            tro    
            s result=-1
        }
        
    }
    q result
}

/// Function: 删除表名或则代码对应的所有关联医院关系,用于初始清数据
/// Creator:  chenying
/// CreatDate: 2020-05-21
/// input: 表名称(BDPMPHTableName，如ARC_ItemCat)
/// debug:    w ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("CT_SocialStatus")
ClassMethod DeleteTableHospitals(BDPMPHTableName As %String) As %String
{
    ;遍历查找出关联医院表的id 
    n (BDPMPHTableName)
    s result=1 
    q:BDPMPHTableName="" result
    s ID=0
    for
    {
        s ID=$O(^User.BDPMappingHospI("TableRef",BDPMPHTableName,ID))  q:ID=""
        s sc=##class(User.BDPMappingHosp).%DeleteId(ID)
        if (sc'=1)
        {
           s result=-1
        }
    }
    q result
}

///  Function:获取数据关联的医院信息(医院组)
///  Type:"ID"或者空，取出医院rowid串，用,连接
///  Type:"Desc"   取出医院rowid名称串，用,连接 
///  Creator: chenying
///  CreateDate:2020-06-29
/// debug:   w ##class(web.DHCBL.BDP.BDPDataExport).GetHospital("SS_User",2,"Desc")
ClassMethod GetHospital(tableName As %String, BDPMPHDataReference As %String, Type As %String = "") As %String
{
    n (tableName,BDPMPHDataReference,Type)
    q:tableName="" ""
    q:BDPMPHDataReference="" ""
    s str=""
    s date=+$h
    s split=","  //输出返回值连接符
    s dataid=BDPMPHDataReference
   	if (tableName="CT_Loc")   //科室，绝对私有
	{
		s CTLOCRowID=dataid
		s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
		s value=CTLOCHospitalDR
		if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
		s str=value
	}
	elseif (tableName="PAC_Ward")  //病区 ，绝对私有
	{
		s WARDRowID=dataid
		s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
		if (CTLOCRowID'="")
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			s value=CTLOCHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			s str=value
		}
	}
	elseif (tableName="PAC_Bed")   //床位 ，绝对私有
	{
		s WARDRowID=$p(dataid,"||",1)
		s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
		if (CTLOCRowID'="")
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			s value=CTLOCHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			s str=value
		}
	}
	elseif (tableName="SS_User")  //用户 判断用户默认登录科室对应医院及用户其他登录科室对应医院
	{
		s SSUSRRowId=dataid
		s CTLOCIDs= ..GetSSUserCTLocIDsByRowId(SSUSRRowId)  //获取用户所属科室
		for CTLOCIDi=1:1:$l(CTLOCIDs,"/")
		{
			s CTLOCID=$p(CTLOCIDs,"/",CTLOCIDi)
			S CTLOCHospitalDR=""
			if CTLOCID'="" s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCID)),"^",22)     //医院
			s value=CTLOCHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			if (CTLOCIDi=1) s str=value
			else  s str=str_split_value
		}
	}
	elseif tableName="CT_CareProv"  //医护人员
	{
		s CTPCPRowId1=dataid
		s HOSPChildsub=0
		for
		{
			s HOSPChildsub=$o(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")
			s CTHospitalDR=$P($g(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)),"^",1)
			s value=CTHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			if str="" s str=value
			else  s str=str_split_value
		}
	}
	elseif (tableName="ARC_ItmMast") //医嘱项
	{
		S ARCIMSubscript=$P(dataid,"||",1)
		S ARCIMVersion=$P(dataid,"||",2)
		; 遍历 医院子表，查询医院dr 进行筛选
		s HospChildsub=0
		for
		{
			s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")  
			s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
			s value=HOSPHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			if str="" s str=value
			else  s str=str_split_value
		}
	}
	elseif (tableName="SS_Group") //安全组
	{
		S SSGRPRowId=dataid
		s HOSPChildsub=0
		for
		{
			s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")
			s CTHospitalDR=$p($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
			s value=CTHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			if str="" s str=value
			else  s str=str_split_value
		}
	}
	elseif (tableName="INC_Itm") //库存项
	{
		//库存项表DHC_ItmAddHosp
		s HOSPHospitalDR=0
		for
		{
			s HOSPHospitalDR=$o(^ITMADDHOP(0,"HospInc",HOSPHospitalDR)) q:HOSPHospitalDR=""
			if $d(^ITMADDHOP(0,"HospInc",HOSPHospitalDR,dataid))>0
			{
				s value=CTHospitalDR
				if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
				if str="" s str=value
				else  s str=str_split_value
			}
		}
		
	}
	elseif (tableName="PAC_Bed")   //床位 ，绝对私有
	{
		s WARDRowID=$p(dataid,"||",1)
		s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
		if (CTLOCRowID'="")
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			s value=CTLOCHospitalDR
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			s str=value
		}
	}
	elseif (tableName="DHCExaBorough") //分诊区
	{
		s ExabHospitalDr=$LISTGET($g(^User.DHCExaBoroughD(dataid)),13)
		s value=ExabHospitalDr
		if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
		s str=value
	}
	elseif (tableName="ARC_OrdSets") //医嘱套
	{
		s FavRowId=$o(^DHCFavItems(0,"ItemRowid",dataid,0))
		if FavRowId'=""
		{
			s FavUseHospDr=$p($g(^DHCFavItems(FavRowId)),"^",11)
			s value=FavUseHospDr
			if (Type="Desc")&&(value'="") s value=$p($g(^CT("HOSP",value)),"^",2)
			s str=value
		}
	}
	else
	{
		///获取医院级授权标志
		i '$d(^||TMPBDP("BDPHospAutflag",$j))
		{
			s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
			s ^||TMPBDP("BDPHospAutflag",$j)=BDPHospAutflag
		}
		else
		{	
			s BDPHospAutflag=^||TMPBDP("BDPHospAutflag",$j)
		}
		if BDPHospAutflag = "Y"
		{
			//获取数据公有私有类型
			i '$d(^||TMPBDP("DataType",tableName,$j))
			{
				s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tableName)	 //获取数据公有私有类型
				s ^||TMPBDP("DataType",tableName,$j)=DataTypeFlag
			}
			else
			{	
				s DataTypeFlag=^||TMPBDP("DataType",tableName,$j)
			}
			if (DataTypeFlag'="G")
			{
				if ($d(^User.BDPMappingHospI("HospRef",tableName,BDPMPHDataReference)))
			    {
			        s Hospital=0
			        for
			        {
			            s Hospital= $O(^User.BDPMappingHospI("HospRef",tableName,BDPMPHDataReference,Hospital)) q:Hospital=""
			            s value=Hospital
			            if Type="Desc" s value=$p($g(^CT("HOSP",Hospital)),"^",2)
			            if str="" s str=value
						else  s str=str_split_value
			        }
			    }
			}
		}
	}
	q str
}

///  Function:给主数据平台提供的接口，获取数据关联的医院信息（具体院区）
///  Creator: chenying
///  CreateDate:2022-12-06
/// debug:   w ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospitalDetail("PAC_BedType",2)
ClassMethod GetHospitalDetail(tableName As %String, BDPMPHDataReference As %String) As %String
{
	n (tableName,BDPMPHDataReference,%session)
	//获取数据公有私有类型
	i '$d(^||TMPBDP("DataType",tableName,$j))
	{
		s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tableName)	 //获取数据公有私有类型
		s ^||TMPBDP("DataType",tableName,$j)=DataTypeFlag
	}
	else
	{	
		s DataTypeFlag=^||TMPBDP("DataType",tableName,$j)
	}
	s HospStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospital(tableName,BDPMPHDataReference)
	s HospDetailStr=""
	k HospArray
	if HospStr'=""
	{
		s lengthHosp=$l(HospStr,",")
		for lengthHospi=1:1:lengthHosp
		{
			s hosp=$p(HospStr,",",lengthHospi)
			continue:(hosp="")
			if ((DataTypeFlag="C")||(DataTypeFlag="S"))
			{
				s hosp=##class(web.DHCBL.BDP.BDPMappingHOSP).GetGroupHospIdsByTableName(tableName,hosp)
			}
			if hosp'=""
			{
				S lengthHospId=$l(hosp,",")
				for lengthHospIdi=1:1:lengthHospId
				{
					s hospId=$p(hosp,",",lengthHospIdi)
					continue:(hospId="")
					if (","_HospDetailStr_",")'[(","_hospId_",")
					{
						if HospDetailStr="" s HospDetailStr=hospId
						else  s HospDetailStr=HospDetailStr_","_hospId
					} 
				}
			}
		}
	}
	q HospDetailStr
}

/// Creator:陈莹
/// CreateDate:20190723
/// Description:判断A医院是否有权显示表里某一条数据
/// Input:tableName(表名称，格式如ARC_ItemCat),dataid(对应表数据RowID,如 医嘱子分类rowid 12)，HospID（A医院rowid)
/// Output:Y/N
/// s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",12,2,"2020-05-07")
ClassMethod GetHospShowDataFlag(tableName As %String, dataid As %String, HospID As %String, date As %String = "") As %String
{
    n (tableName,dataid,HospID,date)
    if dataid="" q "N"
    S:date="" date=+$h
	s flag="N"
	if (tableName="CT_Loc")   //科室，绝对私有
	{
		s CTLOCRowID=dataid
		s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
		i (HospID=CTLOCHospitalDR)
		{
			s flag="Y"
		}
	}
	elseif (tableName="PAC_Ward")  //病区 ，绝对私有
	{
		s WARDRowID=dataid
		s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
		if (CTLOCRowID'="")
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			i (HospID=CTLOCHospitalDR)
			{
				s flag="Y"
			}
		}
	}
	elseif (tableName="PAC_Bed")   //床位 ，绝对私有
	{
		s WARDRowID=$p(dataid,"||",1)
		s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
		if (CTLOCRowID'="")
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			i (HospID=CTLOCHospitalDR)
			{
				s flag="Y"
			}
		}
	}
	elseif (tableName="SS_User")  //用户 判断用户默认登录科室对应医院及用户其他登录科室对应医院
	{
		s SSUSRRowId=dataid
		s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
		s CTLOCHospitalDR=""
		if SSUSRDefaultDeptDR'="" s CTLOCHospitalDR=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",22)     //医院
		//s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
		s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
		//if (SSUSRActive="Y")
		i (HospID=CTLOCHospitalDR)
		{
			s flag="Y"
		}
		
		
		s ChildSub =0
		for 
		{
			s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""  
			s OTHLLHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",3)
	  		s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)
	  		s CTLOCHospitalDR=""
	  		if OTHLLCTLOCDR'="" s CTLOCHospitalDR=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",22)     //医院
	  		s OTHLLStartDate=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",4)
			s OTHLLEndDate=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",5)
			continue:(OTHLLEndDate'="")&&(OTHLLEndDate<date)
			continue:(OTHLLStartDate'="")&&(OTHLLStartDate>date)
			i (HospID=CTLOCHospitalDR)
			{
				s flag="Y"
			}
		}
		
	}
	elseif tableName="CT_CareProv"  //医护人员，
	{
		s CTPCPRowId1=dataid
		s HOSPChildsub=0
		for
		{
			s HOSPChildsub=$o(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")
			s CTHospitalDR=$P($g(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)),"^",1)
			i (HospID=CTHospitalDR) s flag="Y"
		}
	}
	elseif (tableName="RB_Resource")  //资源表
	{
		s RESCTLOCDR=$p($g(^RB("RES",dataid)),"^",1)       //科室ID
		if RESCTLOCDR'=""
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(RESCTLOCDR)),"^",22)     //医院
			i (HospID=CTLOCHospitalDR)
			{
				s flag="Y"
			}
		}
	}
	elseif (tableName="ARC_ItmMast") //医嘱项
	{
		///获取医院级授权标志
		i '$d(^||TMPBDP("BDPHospAutflag",$j))
		{
			s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
			s ^||TMPBDP("BDPHospAutflag",$j)=BDPHospAutflag
		}
		else
		{	
			s BDPHospAutflag=^||TMPBDP("BDPHospAutflag",$j)
		}
		if BDPHospAutflag = "Y"
		{
			
			//获取数据公有私有类型
			i '$d(^||TMPBDP("DataType",tableName,$j))
			{
				s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tableName)	 //获取数据公有私有类型
				s ^||TMPBDP("DataType",tableName,$j)=DataTypeFlag
			}
			else
			{	
				s DataTypeFlag=^||TMPBDP("DataType",tableName,$j)
			}
			if (DataTypeFlag'="G")
			{
				s HospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tableName,HospID,date)  //获取到医院对应的默认医院（判断例外和医院组）
				S ARCIMSubscript=$P(dataid,"||",1)
				S ARCIMVersion=$P(dataid,"||",2)
				; 遍历 医院子表，查询医院dr 进行筛选
				s HospChildsub=0
				for
				{
					s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")  
					s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
					if (HOSPHospitalDR=HospID) s flag="Y"
				}	
			}
			else
			{
				s flag="Y"	
			}
		}
		else
		{
			s flag="Y"	
		}
	}
	elseif (tableName="ARC_OrdSets")   //医嘱套 ，绝对私有
	{
		s flag="Y"
		s FavRowId=$o(^DHCFavItems(0,"ItemRowid",dataid,0))
		if FavRowId'=""
		{
			s FavUseHospDr=$p($g(^DHCFavItems(FavRowId)),"^",11)
			if FavUseHospDr'=""
			{
				i (HospID'=FavUseHospDr)
				{
					s flag="N"
				}		
			}
		}
		
	}
	elseif (tableName="SS_Group") //安全组
	{
		///获取医院级授权标志
		i '$d(^||TMPBDP("BDPHospAutflag",$j))
		{
			s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
			s ^||TMPBDP("BDPHospAutflag",$j)=BDPHospAutflag
		}
		else
		{	
			s BDPHospAutflag=^||TMPBDP("BDPHospAutflag",$j)
		}
		if BDPHospAutflag = "Y"
		{
			
			//获取数据公有私有类型
			i '$d(^||TMPBDP("DataType",tableName,$j))
			{
				s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tableName)	 //获取数据公有私有类型
				s ^||TMPBDP("DataType",tableName,$j)=DataTypeFlag
			}
			else
			{	
				s DataTypeFlag=^||TMPBDP("DataType",tableName,$j)
			}
			if (DataTypeFlag'="G")
			{
				s HospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tableName,HospID,date)  //获取到医院对应的默认医院（判断例外和医院组）
				S SSGRPRowId=dataid
				s HOSPChildsub=0
				for
				{
					s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")
					s CTHospitalDR=$p($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
					if (CTHospitalDR=HospID) s flag="Y"
				}
			}
			else
			{
				s flag="Y"	
			}		
		}
		else
		{
			s flag="Y"	
		}
	}
	elseif (tableName="INC_Itm") //库存项
	{
		///获取医院级授权标志
		i '$d(^||TMPBDP("BDPHospAutflag",$j))
		{
			s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
			s ^||TMPBDP("BDPHospAutflag",$j)=BDPHospAutflag
		}
		else
		{	
			s BDPHospAutflag=^||TMPBDP("BDPHospAutflag",$j)
		}
		if BDPHospAutflag = "Y"
		{
			
			//获取数据公有私有类型
			i '$d(^||TMPBDP("DataType",tableName,$j))
			{
				s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tableName)	 //获取数据公有私有类型
				s ^||TMPBDP("DataType",tableName,$j)=DataTypeFlag
			}
			else
			{	
				s DataTypeFlag=^||TMPBDP("DataType",tableName,$j)
			}
			if (DataTypeFlag'="G")
			{
				s HospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tableName,HospID,date)  //获取到医院对应的默认医院（判断例外和医院组）
				//库存项表DHC_ItmAddHosp
				if $d(^ITMADDHOP(0,"HospInc",HospID,dataid))>0
				{
					s flag="Y"	
				}	
			}	
			else
			{
				s flag="Y"	
			}
		}
		else
		{
			s flag="Y"	
		}
	}
	elseif (tableName="PAC_Bed")   //床位 ，绝对私有
	{
		s WARDRowID=$p(dataid,"||",1)
		s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
		if (CTLOCRowID'="")
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			i (HospID=CTLOCHospitalDR)
			{
				s flag="Y"
			}
		}
	}
	elseif (tableName="DHCExaBorough") //分诊区
	{
		s ExabHospitalDr=$LISTGET($g(^User.DHCExaBoroughD(dataid)),13)
		i (HospID=ExabHospitalDr)
		{
			s flag="Y"
		}
	}
	else
	{
		
		//获取医院级授权标志
		i '$d(^||TMPBDP("BDPHospAutflag",$j))
		{
			s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
			s ^||TMPBDP("BDPHospAutflag",$j)=BDPHospAutflag
		}
		else
		{	
			s BDPHospAutflag=^||TMPBDP("BDPHospAutflag",$j)
		}
		if BDPHospAutflag = "Y"
		{
			
			//获取数据公有私有类型
			i '$d(^||TMPBDP("DataType",tableName,$j))
			{
				s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tableName)	 //获取数据公有私有类型
				s ^||TMPBDP("DataType",tableName,$j)=DataTypeFlag
			}
			else
			{	
				s DataTypeFlag=^||TMPBDP("DataType",tableName,$j)
			}
			if (DataTypeFlag'="G")
			{
				s HospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tableName,HospID,date)  //获取到医院对应的默认医院（判断例外和医院组）	
				if $d(^User.BDPMappingHospI("HospRef",tableName,dataid,HospID)) s flag="Y"  //根据索引判断是否有存在HospID医院的关联数据
			}
			else
			{
				s flag="Y"
				
			}
			
		}
		else
		{
			s flag="Y"
		}
	}
	
	q flag
}

/// Creator:陈莹
/// CreateDate:2020-05-09
/// Description:配置里，需要根据医院所在的医院组获取组内科室和人员的方法(特殊情况才调用,调用前先和产品部核对）
/// a1、a2、a3返回a1+a2+a3的科室，如果再把a3例外，a1返回a1+a2的科室，a3返回a3的科室
/// Input: tableName(表名称，格式如CT_Loc),dataid(对应表数据RowID,如 科室rowid 12)，HospID（A1医院rowid)，date(日期，默认当天），ConfigTableName(配置的代码，在哪里用到了科室/人员）
/// Output:Y/N （A1,A2,A3下的科室都返回Y)
/// Other: s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial("CT_Loc",12,2,"","SS_Group")
ClassMethod GetHospShowDataFlagSpecial(tableName As %String, dataid As %String, HospID As %String, date As %String = "", ConfigTableName As %String = "") As %String
{
    n (tableName,dataid,HospID,date,ConfigTableName)
    S:date="" date=+$h
	s flag="N"
	//获取医院级授权标志
	i '$d(^||TMPBDP("BDPHospAutflag",$j))
	{
		s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
		s ^||TMPBDP("BDPHospAutflag",$j)=BDPHospAutflag
	}
	else
	{	
		s BDPHospAutflag=^||TMPBDP("BDPHospAutflag",$j)
	}
	if BDPHospAutflag = "Y"
	{
		s HospIds=","_##class(web.DHCBL.BDP.BDPMappingHOSP).GetGroupHospIdsByTableName(ConfigTableName,HospID,date)_","  //根据配置表的表名，医院id，日期，如果不是例外医院，返回该配置对应医院组下所有的非例外医院；
		if (tableName="CT_Loc")  //科室
		{
			s CTLOCRowID=dataid
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			if HospIds[(","_CTLOCHospitalDR_",") s flag="Y"
			
		}
		elseif (tableName="SS_User")  //用户 判断用户默认登录科室对应医院及用户其他登录科室对应医院
		{
			s SSUSRRowId=dataid
			s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
			s CTLOCHospitalDR=""
			if SSUSRDefaultDeptDR'="" s CTLOCHospitalDR=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",22)     //医院
			//s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
			s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
			//if (SSUSRActive="Y")&&
			if HospIds[(","_CTLOCHospitalDR_",") s flag="Y"
			s ChildSub =0
			for 
			{
				s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""  
				s OTHLLHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",3)
		  		s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)
		  		s CTLOCHospitalDR=""
		  		if OTHLLCTLOCDR'="" s CTLOCHospitalDR=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",22)     //医院
		  		s OTHLLStartDate=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",4)
				s OTHLLEndDate=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",5)
				continue:(OTHLLEndDate'="")&&(OTHLLEndDate<date)
				continue:(OTHLLStartDate'="")&&(OTHLLStartDate>date)
				if HospIds[(","_CTLOCHospitalDR_",") s flag="Y"
			}
			
		}
		elseif tableName="CT_CareProv"  //医护人员，
		{
			s CTPCPRowId1=dataid
			s HOSPChildsub=0
			for
			{
				s HOSPChildsub=$o(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")
				s CTHospitalDR=$g(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub))
				if HospIds[(","_CTHospitalDR_",") s flag="Y"
			}
		}
		
	}
	else
	{
		s flag="Y"
	}
	q flag
}

/// Creator:陈莹
/// CreateDate:2020-05-09
/// Description:配置里，需要根据医院所在的医院组获取组内科室和人员的方法
/// Input: SessionStr(用户ID^安全组ID^科室ID^当前登录医院ID)
/// Output: 返回医院级授权  off为未开启医院级授权，1为不受限， 其他受限情况：{limited:1,IDS:[{ID:2},{ID:3}]}  （ID为医院的rowid）
/// debug: w ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospAutBySessionStr("1^1^1^2")
ClassMethod GetHospAutBySessionStr(SessionStr) As %String
{
	n (SessionStr)
	s flag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
	if flag = "N" Q "off"						//如果没开启医院级别授权  则没有任何医院级限制
	s result = 0
	s myUserID=$p(SessionStr,"^",1)
	s myGroupID=$p(SessionStr,"^",2)
	s myLocID=$p(SessionStr,"^",3)
	s myHospitalID=$p(SessionStr,"^",4)
	s myPRowID=""
	
	//权限优先级：用户>科室>安全组
	;2. 用户
	if (myPRowID="")
	{
		s myPRowID=$O(^User.BDPPreferencesI("UqIndex"," U"," "_myUserID," BD"," HOSPPRE",0)) 
	}
	
	;3. 科室
	i myPRowID=""
	{
		s myPRowID=$O(^User.BDPPreferencesI("UqIndex"," L"," "_myLocID," BD"," HOSPPRE",0))
	}
	
	;4. 安全组
	i myPRowID=""
	{
		s myPRowID=$O(^User.BDPPreferencesI("UqIndex"," G"," "_myGroupID," BD"," HOSPPRE",0))
	}
	
	if myPRowID'=""
	{
		s myObj=##class(User.BDPPreferences).%OpenId(myPRowID)
		s AuStr=myObj.Data
		
		if AuStr=""			//当登录角色没有过授权时，则默认权限为登录科室指向医院
		{
			s result = "{ID:"_ myHospitalID_"}"
		}
		else				//当登录角色有进行医院授权时，则权限根据授权来控制
		{
			if (AuStr["limited:0")  s result = 1    //不受任何限制，可以查看所有医院数据
			if (AuStr["limited:2")  
			{
				s:myHospitalID'="" result = "{ID:"_ myHospitalID_"}"   //只可以查看该角色登录科室指向的医院数据
			}
			if (AuStr["limited:1") 				  //只可以查看所授权医院数据
			{
				s result = AuStr
			}
		}
	}
	else
	{
		s result = "{ID:"_ myHospitalID_"}"  //没有授权，默认为登录科室指向医院
		
	}
	q result
}

/// Table:User.BDPMappingHosp，User.CTHospital
/// Function:云HIS 医院下拉框统一接口
/// CreateDate:2020-05-06
/// Creator:基础数据平台组  陈莹
/// Input: rowid（医院rowid）, desc（医院desc），tablename（表名）， SessionStr(用户ID^安全组ID^科室ID^当前登录医院ID，不传的时候默认根据session来取)
/// Output: HOSPRowId(医院rowid),HOSPDesc(医院名称)
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPMappingHOSP","GetHospDataForCombo","","","DHC_TarItemPrice","1^1^1^2")
Query GetHospDataForCombo(rowid As %String, desc As %String, tablename As %String, SessionStr As %String) As %Query(ROWSPEC = "HOSPRowId,HOSPDesc")
{
}

ClassMethod GetHospDataForComboExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, tablename As %String, SessionStr As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //2021-12-01前台下拉框 增加调翻译接口
    Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s Languages=""
	s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
    if (rowid'="") //根据rowid返回该条记录
    {
        s HOSPRowId=rowid
        s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
        s:Languages'="" HOSPDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",Languages,HOSPDesc)
        d OutputRowHospCombo
    }
    else
    {
	    s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
		s:desc'="" desc=$zcvt(desc,"U")
        //获取医院级授权 
        if SessionStr'=""
        {
	        s AuHospStr=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospAutBySessionStr(SessionStr)  
        }
        else
        {
        	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()   ///不传默认取session的权限
        }
        
        
		k HospArray
		
        s RowId=0
        for  
        {   
            s RowId=$o(^CT("HOSP",RowId)) q:RowId=""
            s strRowId = "{ID:"_RowId_"}"
            i ((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1)) ;用来筛选授权数据
            {
               
                s HOSPDateTo=$p($g(^CT("HOSP",RowId)),"^",10)
                continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h) 	                
                if (BDPHospAutflag="Y")
                {
	                s HOSPRowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tablename,RowId)  //获取到医院对应的默认医院（判断例外和医院组）
	                if (HOSPRowId>0)
                    {
                    	s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
                    }
                    else
                    {
	                    s HOSPDesc=$p(HOSPRowId,"^",2)
	                    s HOSPRowId=-1
	                    
                    }
                    if $d(HospArray(HOSPRowId))>0 continue
                }
                else
                {
	                s HOSPRowId=RowId
	                s HOSPDesc=$p($g(^CT("HOSP",RowId)),"^",2)
	                
                }
                s:Languages'="" HOSPDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",Languages,HOSPDesc)
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(HOSPDesc)
                if ($zcvt(HOSPDesc,"U")[desc)||(PINYIN[desc)
                {
	                s HospArray(HOSPRowId)=""
	                d OutputRowHospCombo
                }
            }
        }
		
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowHospCombo
    set Data=$lb(HOSPRowId,HOSPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHospDataForComboClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospDataForComboExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetHospDataForComboFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospDataForComboExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Table:User.BDPMappingHosp，User.CTHospital
/// Function:云HIS 医院下拉框统一接口/ 公有授权查询医院关联数据接口（基础平台调用）
/// CreateDate:2019-07-15
/// Creator:基础数据平台组  陈莹
/// Input: rowid（医院rowid）, desc（医院desc），tablename（表名）， dataid(数据rowid),SessionStr(用户ID^安全组ID^科室ID^当前登录医院ID，不传的时候默认根据session来取)
/// Output: MappingID(关联医院数据的rowid),HOSPRowId(医院rowid),HOSPDesc(医院名称),LinkFlag(表里的这条数据是否关联此医院）
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPMappingHOSP","GetHospDataForCloud","","","PAC_AdmReason","","1^1^1^2")
Query GetHospDataForCloud(rowid As %String, desc As %String, tablename As %String, dataid As %String, SessionStr As %String) As %Query(ROWSPEC = "MappingID,HOSPRowId,HOSPDesc,LinkFlag")
{
}

ClassMethod GetHospDataForCloudExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, tablename As %String, dataid As %String, SessionStr As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //2021-12-01前台下拉框 增加调翻译接口
    Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s Languages=""
	s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
    if (rowid'="") //根据rowid返回该条记录
    {
        s HOSPRowId=rowid
        s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
        s MappingID="",LinkFlag="N"
        if (tablename'="")&&(dataid'="")
        {
            s MappingID=$O(^User.BDPMappingHospI("HospRef",tablename,dataid,HOSPRowId,0)) 
            if MappingID'="" s LinkFlag="Y"
        }
        s:Languages'="" HOSPDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",Languages,HOSPDesc)
        d OutputRowCloud
    }
    else
    {
	    s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
        s:desc'="" desc=$zcvt(desc,"U")
        //获取医院级授权 
        if SessionStr'=""
        {
	        s AuHospStr=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospAutBySessionStr(SessionStr)  
        }
        else
        {
        	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()    //不传默认取session的权限
        }
        s RowId=0
        k HospArray
        for  
        {   
            s RowId=$o(^CT("HOSP",RowId)) q:RowId=""
            s strRowId = "{ID:"_RowId_"}"
            i ((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1)) ;用来筛选授权数据
            {
               
                s HOSPDateTo=$p($g(^CT("HOSP",RowId)),"^",10)
                continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
                s MappingID="",LinkFlag="N"
                if (tablename'="")&&(dataid'="")
                {
                    //s MappingID=$O(^User.BDPMappingHospI("PubDataRef",tablename," "_dataid,HOSPRowId,0))
                    s MappingID=$O(^User.BDPMappingHospI("HospRef",tablename,dataid,RowId,0)) 
                    if MappingID'="" s LinkFlag="Y"
                }   
                if (BDPHospAutflag="Y")
                {
                    s HOSPRowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tablename,RowId) //获取到医院对应的默认医院（判断例外和医院组）
                    if (HOSPRowId>0)
                    {
                    	s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
                    }
                    else
                    {
	                    s HOSPDesc=$p(HOSPRowId,"^",2)
	                    s HOSPRowId=-1
	                    
                    }
                	if $d(HospArray(HOSPRowId))>0 continue
                }
                else
                {
                    s HOSPRowId=RowId
                     s HOSPDesc=$p($g(^CT("HOSP",RowId)),"^",2)
                    
                }
                s HospArray(HOSPRowId)=""
                s:Languages'="" HOSPDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",Languages,HOSPDesc)
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(HOSPDesc)
                if ($zcvt(HOSPDesc,"U")[desc)||(PINYIN[desc)
                {
	                d OutputRowCloud
                    
                }
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCloud
    set Data=$lb(MappingID,HOSPRowId,HOSPDesc,LinkFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHospDataForCloudClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospDataForCloudExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetHospDataForCloudFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospDataForCloudExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Function:批量更新和医院的关联关系(包括新增删除，基础平台调用）
/// Creator:chenying
/// CreateDate:2019-07-24
/// input:tableName(表名称,如ARC_ItemCat)/dataid(对应表数据RowID如 医嘱子分类rowid 12)/HospIDs(医院rowid串和勾选保存标识，2$Y^3$N)
/// output:str -1^原因  /  1
/// Debug： w ##class(web.DHCBL.BDP.BDPMappingHOSP).UpdateHOSP("MRC_ICDDx",26328,"2$N^3$Y^82$N")
ClassMethod UpdateHOSP(tableName As %String, dataid As %String, HospIDs As %String) As %String
{
    n (tableName,dataid,HospIDs)
    s result=1
    //s BDPHospAutflag =##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
	//if BDPHospAutflag = "Y"
	//{
	    if (tableName="") 
	    {
	       s result="-1^表名不能为空"
	    }
	    elseif(dataid="") 
	    {
	       s result="-1^对应表数据RowID不能为空"
	    }
	    else
	    { 

	    	for i=1:1:$l(HospIDs,"^")
	    	{
		    	s str=$p(HospIDs,"^",i)
		    	s HospID=$p(str,"$",1)
		    	continue:HospID=""
		    	s flag=$p(str,"$",2)
		    	if flag="Y"
		    	{
			    	s ret= ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(tableName,dataid,HospID)
			    	if ret<0 s result=ret
		    	}
	    	}
	    	if HospIDs'["Y"
	    	{
		    	s hosp=0
		    	s count=0
		    	k Array
		        for
		        {
		       		s hosp=$O(^User.BDPMappingHospI("HospRef",tableName,dataid,hosp)) q:hosp=""
		       		s count=count+1
		       		s Array(hosp)=""
		        }
		        for i=1:1:$l(HospIDs,"^")
		    	{
			    	s str=$p(HospIDs,"^",i)
			    	s HospID=$p(str,"$",1)
			    	continue:HospID=""
			    	s flag=$p(str,"$",2)
			    	if flag="N"
			    	{
				    	k Array(HospID)
			    	}
		    	}
				  
				if ($d(Array)=0)
				{
					s result="-1^不允许取消医院关联，需要保证一条数据至少关联一个医院"
					q result
					
				}
	    	}
			        
	    	for i=1:1:$l(HospIDs,"^")
	    	{
		    	s str=$p(HospIDs,"^",i)
		    	s HospID=$p(str,"$",1)
		    	continue:HospID=""
		    	s flag=$p(str,"$",2)
		    	if flag="N"
		    	{
			    	s ret= ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospital(tableName,dataid,HospID)
			    	if ret<0 s result=ret
		    	}
	    	}
	    	
	    }
	//}
	//else
	//{
	//	s result="-1^没有开启医院级授权"
	//}
    q result
}

/// Creator：杨帆
/// CreatDate: 2020-02-12
/// Description：查询私有数据关联医院表的内容
/// Table：BDP_MappingHosp
/// Input：rowid,code,desc,hospitaldr
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPMappingHOSP","GetList","","","6","")
Query GetList(rowid As %String, code As %String, tabledr As %String, hospitaldr As %String) As %Query(ROWSPEC = "ID:%String,BDPMPHTableName:%String,BDPMPHDataReference:%String,BDPMPHHospital:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, tabledr As %String, hospitaldr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID = rowid
		s BDPMPHTableName= $lg($g(^User.BDPMappingHospD(ID)),2)		//表名称
		s TableListID = $o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(BDPMPHTableName,"U"),0)) //表结构RowId
		s TableDesc=""
		s:TableListID'="" TableDesc = $lg($g(^User.BDPTableListD(TableListID)),3) //中文名称
		s:BDPMPHTableName'="" BDPMPHTableName=BDPMPHTableName_"("_TableDesc_")"
		s BDPMPHDataReference = $lg($g(^User.BDPMappingHospD(ID)),3)  //对应表数据RowID
		s BDPMPHHospital = $lg($g(^User.BDPMappingHospD(ID)),4)   //关联的医院
		s:BDPMPHHospital'="" BDPMPHHospital=$p($g(^CT("HOSP",BDPMPHHospital)),"^",2)	//医院描述
		d OutputRow
	}
	else
	{
		s table=""
		s:tabledr'="" table=$lg($g(^User.BDPTableListD(tabledr)),8)		//入参表名
		s ID=0
		for 
		{
			s ID=$o(^User.BDPMappingHospD(ID)) q:ID=""
			s BDPMPHTableName= $lg($g(^User.BDPMappingHospD(ID)),2)		//表名称
			s TableListID = $o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(BDPMPHTableName,"U"),0)) //表结构RowId
			s TableDesc=""
			s:TableListID'="" TableDesc = $lg($g(^User.BDPTableListD(TableListID)),3) //中文名称
			s:BDPMPHTableName'="" BDPMPHTableName=BDPMPHTableName_"("_TableDesc_")"
			s BDPMPHDataReference = $lg($g(^User.BDPMappingHospD(ID)),3)  //对应表数据RowID
			s BDPMPHHospital= $lg($g(^User.BDPMappingHospD(ID)),4)		//关联的医院
			if (hospitaldr'="")
			{
				continue:hospitaldr'=BDPMPHHospital
			}
			s:BDPMPHHospital'="" BDPMPHHospital=$p($g(^CT("HOSP",BDPMPHHospital)),"^",2)	//医院描述
			if (tabledr=TableListID)||(table="")&&($ZCONVERT(BDPMPHDataReference,"U")[code)
			{
				d OutputRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,BDPMPHTableName,BDPMPHDataReference,BDPMPHHospital)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：杨帆
/// CreatDate: 2020-02-12
/// Description:数据重复验证方法,js调用
/// Table:BDP_MappingHosp
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.BDP.BDPMappingHOSP).FormValidate("88","150","2","10")
ClassMethod FormValidate(id As %String, tablename As %String, hospitaldr As %String, datareference As %String) As %String
{
	n (id,tablename,hospitaldr,datareference)
	s flag=0
	s TableName=""
	if ((tablename'="")&&(hospitaldr'="")&&(datareference'=""))
	{
		s TableName=$lg($g(^User.BDPTableListD(tablename)),8)
		s ID=$o(^User.BDPMappingHospI("DataRef",TableName,hospitaldr,datareference,0))
		if (ID'="")&&(id'=ID) s flag=1
	}
	
	q flag
}

/// Creator：杨帆
/// CreatDate: 2020-02-12
/// Description：新增，修改时打开Form，根据ID查询
/// Table：BDP_MappingHosp
/// Input：ID
/// Other: w ##class(web.DHCBL.BDP.BDPMappingHOSP).OpenData(3)
ClassMethod OpenData(id As %String) As %String
{
	n (id)
    s str = ""
	s pobj = ##class(User.BDPMappingHosp).%OpenId(id) 
	s eobj = ##class(web.Entity.BDP.BDPMappingHosp).%New() 
	s eobj.ID = id
	s eobj.BDPMPHTableName = pobj.BDPMPHTableName     //表名称
	s:eobj.BDPMPHTableName'="" eobj.BDPMPHTableName=$o(^User.BDPTableListI("NameIndex"," "_$ZCVT(eobj.BDPMPHTableName,"U"),0))
	s eobj.BDPMPHDataReference = pobj.BDPMPHDataReference //对应表数据RowID
	s:pobj.BDPMPHHospital'="" eobj.BDPMPHHospital = pobj.BDPMPHHospital.%Id()     //关联的医院

	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：杨帆
/// CreatDate: 2020-02-12
/// Description：根据id删除 私有数据关联医院
/// Table：BDP_MappingHosp
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteData()
ClassMethod DeleteData(id) As %String
{
	n (id,%session)
	s result=""
	s pobj = ##class(User.BDPMappingHosp).%OpenId(id)
	s eobj = ##class(web.Entity.BDP.BDPMappingHosp).%New()
	s eobj.BDPMPHTableName = pobj.BDPMPHTableName		  //表名称
	s eobj.BDPMPHDataReference = pobj.BDPMPHDataReference		  //对应表数据RowID
	s eobj.BDPMPHHospital = pobj.BDPMPHHospital		  //关联的医院
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.BDPMappingHosp).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_MappingHosp","User.BDPMappingHosp","私有数据关联医院",id,eobj.BDPMPHTableName,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("私有数据关联医院","web.DHCBL.BDP.BDPMappingHOSP","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:杨帆 
/// CreatDate: 2020-02-12
/// Description：保存 私有数据关联医院
/// Input: eobj As web.Entity.BDP.BDPMappingHosp
/// Table：BDP_MappingHosp
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPMappingHosp) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.ID,eobj.BDPMPHTableName,eobj.BDPMPHHospital,eobj.BDPMPHDataReference)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s:eobj.BDPMPHTableName'="" eobj.BDPMPHTableName=$lg($g(^User.BDPTableListD(eobj.BDPMPHTableName)),8)		//取表名
		if (eobj.ID="")
		{
			s obj=##class(User.BDPMappingHosp).%New()
		}
		else
		{
			s obj=##class(User.BDPMappingHosp).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.BDP.BDPMappingHosp).%New()
			s bobj.ID = eobj.ID		//RowID
			s bobj.BDPMPHTableName = obj.BDPMPHTableName		//表名称
			s bobj.BDPMPHDataReference=obj.BDPMPHDataReference	//对应表数据RowID
			s:obj.BDPMPHHospital'="" bobj.BDPMPHHospital = obj.BDPMPHHospital.%Id()		 //关联的医院
		}
		s obj.BDPMPHTableName = eobj.BDPMPHTableName		//表名称
		S obj.BDPMPHDataReference=eobj.BDPMPHDataReference	//对应表数据RowID
		d obj.BDPMPHHospitalSetObjectId(eobj.BDPMPHHospital)		    //关联的医院
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_MappingHosp","User.BDPMappingHosp","私有数据关联医院",eobj.ID,eobj.BDPMPHTableName,"U",eobj,bobj)
    		d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_MappingHosp","User.BDPMappingHosp","私有数据关联医院",id,eobj.BDPMPHTableName,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年2月13日
/// Description：把一家医院A的私有数据关联，授权给另一个医院B
/// Table：User.BDPMappingHosp
/// Input：医院A的DR	医院B的DR	表名串(TableName1^TableName2^...)
/// Others：w ##class(web.DHCBL.BDP.BDPMappingHOSP).CopyAuthorizedDataByTable("2","3","")
ClassMethod CopyAuthorizedDataByTable(hospitalfrom As %String, hospitalto As %String, tables As %String) As %String
{
	n (hospitalfrom,hospitalto,tables,%session)
	q:((hospitalfrom="")||(hospitalto="")||(tables="")) ""
	for i=1:1:$l(tables,"^")
	{
		s TableName=$p(tables,"^",i)
		if (TableName="ARC_ItmMast")
		{
			//医嘱项
			s ARCIMSubscript=0
			for
			{
				s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript))
				q:ARCIMSubscript=""
				s ARCIMVersion=0
				for 
				{
					s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))
					q:ARCIMVersion=""
					
					if $d(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",0,"Hosp",hospitalfrom))
					{
						if ($d(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",0,"Hosp",hospitalto))=0)
						{
							s DataStr=ARCIMSubscript_"||"_ARCIMVersion_"^"_hospitalto
							s re=##class(web.DHCBL.CT.ARCItemHosp).AddARCItemHosp(DataStr)
							if (re["success:'false'")
							{
								w "保存失败^医嘱项^数据："_ARCIMSubscript_"||"_ARCIMVersion
							}
						}
					}
				}
			}
		}
		elseif (TableName="INC_Itm")
		{
			//库存项
			if $d(^ITMADDHOP(0,"HospInc",hospitalfrom))
			{
				s IAHIncItmDR=0
				for
				{
					s IAHIncItmDR=$o(^ITMADDHOP(0,"HospInc",hospitalfrom,IAHIncItmDR))
					q:IAHIncItmDR=""
					if ($d(^ITMADDHOP(0,"HospInc",hospitalto,IAHIncItmDR))=0)
					{
						s obj=##class(User.DHCItmAddHosp).%New()
						d obj.IAHHospitalDRSetObjectId(hospitalto)
						d obj.IAHIncItmDRSetObjectId(IAHIncItmDR)
						s obj.IAHNotUseFlag="N"
						s obj.IAHPreRecFlag="N"
						s obj.IAHStartDate=+$h
						s re=obj.%Save()
						if '(re)
						{
							w "保存失败^库存项^数据："_IAHIncItmDR
						}
					}
					
				}
			}
		}
		elseif (TableName="SS_Group")
		{
			//安全组
			s SSGRPRowId=0
			for
			{
				s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
				if $d(^SSU("SSGRP",SSGRPRowId,"HOSP",0,"Hosp",hospitalfrom))
				{
					if ($d(^SSU("SSGRP",SSGRPRowId,"HOSP",0,"Hosp",hospitalto))=0)
					{
						s hospeobj=##class(web.Entity.CT.SSGroupHospitals).%New()
						s hospeobj.HOSPRowId=""
						s hospeobj.HOSPHospitalDR=hospitalto
						s hospeobj.HOSPParRef=SSGRPRowId
						s re=##class(web.DHCBL.CT.SSGroupHospitals).SaveEntity(hospeobj)
						if (re["success:'false'")
						{
							w "保存失败^医嘱项^数据："_SSGRPRowId
						}
					}
				}
			}
		}
		else
		{
			s BDPMPHDataReference=0
			for
			{
				s BDPMPHDataReference=$o(^User.BDPMappingHospI("DataRef",TableName,hospitalfrom,BDPMPHDataReference))
				q:BDPMPHDataReference=""
				s re=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(TableName,BDPMPHDataReference,hospitalto)
				if ($p(re,"^",1)="-1")
				{
					w "保存失败^表名："_TableName_"^数据："_BDPMPHDataReference
				}
			}
		}
	}
	q "1"
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年5月7日
/// Description：根据表名，医院id，日期，返回该医院组下所有的非例外医院  update2020-06-05
/// Table：User.BDPTableList,User.BDPExceptionHosp
/// Input：tablename表名	hospitaldr医院DR	date日期
/// Output: 医院rowid串，逗号(,)分隔
/// Others：w ##class(web.DHCBL.BDP.BDPMappingHOSP).GetGroupHospIdsByTableName("CT_Loc","2","2020-05-07")
ClassMethod GetGroupHospIdsByTableName(tableName As %String, HospID As %String, date As %String = "") As %String
{
	new (tableName,HospID,date)
	s HospIdStr=""
	s:((date["/")||(date["-")) date=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(date)  //转换日期
	s:date="" date=+$h
	q:tableName="" "-1^表名不能为空"
	q:HospID="" "-1^医院不能为空"
	s TableListID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(tableName,"U"),0))
	//q:TableListID="" "-1^表结构登记中不存在 "_tableName_" 表名"
	if TableListID=""  //update2020-06-12兼容没有登记的项目
	{
		q HospID
		
	}
	s DataType=$LISTGET($G(^User.BDPTableListD(TableListID)),10)
	if (DataType="A")&&(tableName'="CT_Loc")	//如果类型是绝对私有，则直接返回入参医院
	{
		s HospIdStr=HospID
	}
	else
	{
		s defaultdr=$p($g(^CT("HOSP",HospID)),"^",41)	//取默认医院
		if defaultdr="" s defaultdr=HospID
		s ExceptionFlag=0
		//先判断是否是例外医院
		k ExceptionHosp
		s childsub=0
		for
		{
			s childsub=$o(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)) q:childsub=""
			s HospitalDR=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),2)     //例外医院
			s ActiveFlag=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),3)		//是否启用
			s ActiveFrom=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),4)		//开始日期
			s ActiveTo=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),5)		//结束日期
			if (ActiveFlag="Y")&&((ActiveFrom'="")&&(date>=ActiveFrom))&&((ActiveTo="")||(date<=ActiveTo))	//是例外医院，返回其本身
			{
				if HospitalDR=HospID s ExceptionFlag=1   //入参医院为例外医院
				s ExceptionHosp(HospitalDR)=""
			}
		}
		if (ExceptionFlag=1)   //入参医院为例外医院，返回自己
		{
			q HospID
		}
		else
		{
			s HospIdStr=HospID
			s HOSPRowId=0
			for
			{
				s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
				s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
				continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
				s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HOSPRowId)),"^",41)	//取默认医院
				if HOSPDefaultHospitalDR="" s HOSPDefaultHospitalDR=HOSPRowId
				if (HOSPDefaultHospitalDR=defaultdr)
				{
					if ($d(ExceptionHosp(HOSPRowId))=0)&&(HospID'=HOSPRowId) s HospIdStr=HospIdStr_","_HOSPRowId
					
				}
			}
		}
		
	}
	q HospIdStr
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年5月7日
/// Description：根据表名、业务数据中的医院、日期取要取哪个医院的配置，返回医院id
/// Table：User.BDPTableList,User.BDPExceptionHosp
/// Input：tableName表名	HospID医院DR	date日期
/// Output: 医院rowid
/// Others：w ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("PAC_AdmReason","3","2020-05-07")
ClassMethod GetDefHospIdByTableName(tableName As %String, HospID As %String, date As %String = "") As %String
{
	new (tableName,HospID,date)
	//获取医院级授权标志
	i '$d(^||TMPBDP("BDPHospAutflag",$j))
	{
		s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
		s ^||TMPBDP("BDPHospAutflag",$j)=BDPHospAutflag
	}
	else
	{	
		s BDPHospAutflag=^||TMPBDP("BDPHospAutflag",$j)
	}
	if BDPHospAutflag="Y"
	{
		s:((date["/")||(date["-")) date=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(date)  //转换日期  
		s:date="" date=+$h
		q:tableName="" "-1^表名不能为空"
		q:HospID="" "-1^医院不能为空"
		s TableListID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(tableName,"U"),0))
		//q:TableListID="" "-1^表结构登记中不存在 "_tableName_" 表名"
		if TableListID=""  //update2020-06-12兼容没有登记的项目
		{
			q HospID
			
		}
		s DataType=$LISTGET($G(^User.BDPTableListD(TableListID)),10)
		if ((DataType="A")||(DataType="G"))	//如果类型是绝对私有或公有，则直接返回入参医院
		{
			q HospID
		}
		else
		{
			if ($d(^User.BDPExceptionHospI("HospitalIndex",HospID,TableListID)))
			{
				s childsub=$o(^User.BDPExceptionHospI("HospitalIndex",HospID,TableListID,0))
				s ActiveFlag=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),3)		//是否启用
				s ActiveFrom=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),4)		//开始日期
				s ActiveTo=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),5)		//结束日期
				if (ActiveFlag="Y")&&((ActiveFrom'="")&&(date>=ActiveFrom))&&((ActiveTo="")||(date<=ActiveTo))	//是例外医院，返回其本身
				{
					q HospID
				}
				else	//不是例外医院，返回其默认医院
				{
					s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HospID)),"^",41)	//取默认医院
					q:HOSPDefaultHospitalDR="" HospID	//没有默认医院，返回其本身
					q HOSPDefaultHospitalDR
				}
			}
			else	//不是例外医院，返回其默认医院
			{
				s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HospID)),"^",41)	//取默认医院
				q:HOSPDefaultHospitalDR="" HospID	//没有默认医院，返回其本身
				q HOSPDefaultHospitalDR
			}
		}
	}
	else
	{
		q HospID
	}
}

/// ----方法弃用了！请别调用
/// Creator:陈莹
/// CreateDate:20190625
/// Description:判断对于当前登录角色(SESSION)，判断他的授权是否有权显示表里某一条数据（不包括 用户，人员，医嘱项，安全组，科室，这表里本来就有医院标识）
/// Input:tableName(表名称，格式如ARC_ItemCat),dataid(对应表数据RowID,如 医嘱子分类rowid 12)
/// Output:Y/N
/// s flag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag("ARC_ItemCat",12)
ClassMethod GetShowDataFlag(tableName As %String, dataid As %String) As %String
{
    n (tableName,dataid,%session)
    if tableName="" q "N"
    if dataid="" q "N"
	s flag="Y"
	s date=+$h
	//获取数据公有私有类型
	i '$d(^||TMPBDP("DataType",tableName,$j))
	{
		s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tableName)	 //获取数据公有私有类型
		s ^||TMPBDP("DataType",tableName,$j)=DataTypeFlag
	}
	else
	{	
		s DataTypeFlag=^||TMPBDP("DataType",tableName,$j)
	}
	//获取医院级授权标志
	i '$d(^||TMPBDP("BDPHospAutflag",$j))
	{
		s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
		s ^||TMPBDP("BDPHospAutflag",$j)=BDPHospAutflag
	}
	else
	{	
		s BDPHospAutflag=^||TMPBDP("BDPHospAutflag",$j)
	}
	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()   //"{limited:1,IDS:[{ID:2},{ID:3},{ID:82},{ID:83},{ID:84},{ID:85},{ID:86},{ID:87}]}"
	if (DataTypeFlag'="G")&&(BDPHospAutflag="Y")&&(AuHospStr'="off")&&(AuHospStr'= 1)  //非公有，且开启了医院级授权并且不是不受限，需要判断医院权限，否则全部显示
	{
		s flag="N"
	    if (tableName="CT_Loc")   //科室，绝对私有
		{
			s CTLOCRowID=dataid
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
			s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
			i (AuHospStr[strHospitalID)
			{
				s flag="Y"
			}
		}
		elseif (tableName="PAC_Ward")  //病区 ，绝对私有
		{
			s WARDRowID=dataid
			s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
			if (CTLOCRowID'="")
			{
				s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
				s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
				i (AuHospStr[strHospitalID)
				{
					s flag="Y"
				}
			}
		}
		elseif (tableName="PAC_Bed")   //床位 ，绝对私有
		{
			s WARDRowID=$p(dataid,"||",1)
			s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
			if (CTLOCRowID'="")
			{
				s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
				s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
				i (AuHospStr[strHospitalID)
				{
					s flag="Y"
				}
			}
		}
		elseif (tableName="SS_User")  //用户 判断用户默认登录科室对应医院及用户其他登录科室对应医院
		{
			s SSUSRRowId=dataid
			s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
			s CTLOCHospitalDR=""
			if SSUSRDefaultDeptDR'="" s CTLOCHospitalDR=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",22)     //医院
			//s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
			s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
			//if (SSUSRActive="Y")
			s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
			i (AuHospStr[strHospitalID)
			{
				s flag="Y"
			}
			s ChildSub =0
			for 
			{
				s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""  
				s OTHLLHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",3)
		  		s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)
		  		s CTLOCHospitalDR=""
		  		if OTHLLCTLOCDR'="" s CTLOCHospitalDR=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",22)     //医院
		  		s OTHLLStartDate=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",4)
				s OTHLLEndDate=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",5)
				continue:(OTHLLEndDate'="")&&(OTHLLEndDate<date)
				continue:(OTHLLStartDate'="")&&(OTHLLStartDate>date)
				s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
				i (AuHospStr[strHospitalID)
				{
					s flag="Y"
				}
			}
			
		}
		elseif tableName="CT_CareProv"  //医护人员，
		{
			s CTPCPRowId1=dataid
			s HOSPChildsub=0
			for
			{
				s HOSPChildsub=$o(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")
				s CTHospitalDR=$P($g(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)),"^",1)
				s strHospitalID = "{ID:"_CTHospitalDR_"}"
				i (AuHospStr[strHospitalID) s flag="Y"
			}
		}
		elseif (tableName="RB_Resource")  //资源表
		{
			s RESCTLOCDR=$p($g(^RB("RES",dataid)),"^",1)       //科室ID
			if RESCTLOCDR'=""
			{
				s CTLOCHospitalDR=$p($g(^CTLOC(RESCTLOCDR)),"^",22)     //医院
				s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
				i (AuHospStr[strHospitalID)
				{
					s flag="Y"
				}
			}
		}
		elseif (tableName="ARC_ItmMast") //医嘱项
		{
			S ARCIMSubscript=$P(dataid,"||",1)
			S ARCIMVersion=$P(dataid,"||",2)
			; 遍历 医院子表，查询医院dr 进行筛选
			s HospChildsub=0
			for
			{
				s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")  
				s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
				s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
				i (AuHospStr[strHospitalID) s flag="Y"
			}	
			
		}
		elseif (tableName="ARC_OrdSets")   //医嘱套 ，绝对私有
		{
			s flag="Y"
			s FavRowId=$o(^DHCFavItems(0,"ItemRowid",dataid,0))
			if FavRowId'=""
			{
				s FavUseHospDr=$p($g(^DHCFavItems(FavRowId)),"^",11)
				if FavUseHospDr'=""
				{
					s strHospitalID = "{ID:"_FavUseHospDr_"}"
					i (AuHospStr'[strHospitalID) s flag="N"
				}
			}
		}
		elseif (tableName="SS_Group") //安全组
		{
			S SSGRPRowId=dataid
			s HOSPChildsub=0
			for
			{
				s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")
				s CTHospitalDR=$p($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
				s strHospRowId="{ID:"_CTHospitalDR_"}"
				if (AuHospStr[strHospRowId) s flag="Y"
			}
		}
		elseif (tableName="INC_Itm") //库存项
		{
			//库存项表DHC_ItmAddHosp
			s HOSPHospitalDR=0
			for
			{
				s HOSPHospitalDR=$o(^ITMADDHOP(0,"HospInc",HOSPHospitalDR)) q:HOSPHospitalDR=""
				if $d(^ITMADDHOP(0,"HospInc",HOSPHospitalDR,dataid))>0
				{
					s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
					if (AuHospStr[strHospitalID) s flag="Y"
				}
			
			}
		}
		elseif (tableName="PAC_Bed")   //床位 ，绝对私有
		{
			s WARDRowID=$p(dataid,"||",1)
			s CTLOCRowID=$p($g(^PAWARD(WARDRowID)),"^",5)
			if (CTLOCRowID'="")
			{
				s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
				s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
				i (AuHospStr[strHospitalID) 
				{
					s flag="Y"
				}
			}
		}
		elseif (tableName="DHCExaBorough") //分诊区
		{
			s ExabHospitalDr=$LISTGET($g(^User.DHCExaBoroughD(dataid)),13)
			s strHospitalID = "{ID:"_ExabHospitalDr_"}"
			i (AuHospStr[strHospitalID)
			{
				s flag="Y"
			}
		}
		else
		{
			s Hospital= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospital(tableName,dataid)
			if (Hospital'="")  //关联了医院 ，判断是否有显示这个医院的权限；没有关联医院的非公有数据，不显示
			{
				s length=$l(Hospital,",")
				for hospi=1:1:length
				{
					s strHospitalRowId = "{ID:"_$P(Hospital,",",hospi)_"}"
					if AuHospStr[strHospitalRowId s flag="Y"
				}
			}
		}
	}
		
	q flag
}

/// Function:批量处理公有数据，跟医院关联 变成私有数据
/// Creator: 陈莹
/// CreateDate:2019-11-01
/// Input: hospid（医院的rowid)
/// debug:   w ##class(web.DHCBL.BDP.BDPMappingHOSP).BatchSaveHOSP(2)
///          w ##class(web.DHCBL.BDP.BDPMappingHOSP).BatchSaveHOSP(2,"ARC_ItemCat")
ClassMethod BatchSaveHOSP(hospid, tablename As %String = "") As %String
{
	s BDPHospAutflag =##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
	if BDPHospAutflag="N" Q "没有开启医院级授权"
	
	
	//d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("DHC_CTLoc_MedUnit")  //医疗单元不需要跟医院关联
	//d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("ARC_DerivedFeeRules")  //费用标准
	//d ##class(web.DHCBL. BDP.BDPMappingHOSP).DeleteTableHospitals("CT_UOM")  //单位
	//d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("CT_ConFac")  //单位转换
	//d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("CT_LocationList")  //科室列表
	//d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("ORC_Operation")  //手术
	
	///管控类型
	if ((tablename="")||(tablename="CT_SocialStatus"))
	{
		w "患者类别（社会地位）",! 
	    s SSRowId=0
		for
		{
			s SSRowId=$o(^CT("SS",SSRowId))
			q:SSRowId=""
			//if ($d(^User.BDPMappingHospI("HospRef","CT_SocialStatus",SSRowId))) =0
			//{
			//	d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CT_SocialStatus",SSRowId,hospid)
			//}
			//可以关联多家医院
			if ($d(^User.BDPMappingHospI("HospRef","CT_SocialStatus",SSRowId,hospid)) =0)
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CT_SocialStatus",SSRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="PAC_AdmReason"))
	{
		w "患者费别",!
		s REARowId=0
		for 
		{
			s REARowId=$o(^PAC("ADMREA",REARowId))
			q:REARowId=""
			//if ($d(^User.BDPMappingHospI("HospRef","PAC_AdmReason",REARowId))) =0
			//{
			//	d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("PAC_AdmReason",REARowId,hospid)
			//}
			//可以关联多家医院
			if ($d(^User.BDPMappingHospI("HospRef","PAC_AdmReason",REARowId,hospid)) =0)
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("PAC_AdmReason",REARowId,hospid)
			} 
			
	    }  
	}
    if ((tablename="")||(tablename="MRC_ICDDx"))
	{
		
		w "ICD诊断",!
		s MRCIDRowId=0
		for
		{
			s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:MRCIDRowId=""
			//只关联一家医院
			//if ($d(^User.BDPMappingHospI("HospRef","MRC_ICDDx",MRCIDRowId))) =0
			//{
			//	d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("MRC_ICDDx",MRCIDRowId,hospid)
			//}
			//可以关联多家医院
			if ($d(^User.BDPMappingHospI("HospRef","MRC_ICDDx",MRCIDRowId,hospid)) =0)
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("MRC_ICDDx",MRCIDRowId,hospid)
			} 
			
		}
	}
	if ((tablename="")||(tablename="ORC_Operation"))
	{
		
		/*
		w "手术/过程",!	
		s OPERRowId=0
		for
		{
			s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:OPERRowId=""
			//只关联一家医院
			if ($d(^User.BDPMappingHospI("HospRef","ORC_Operation",OPERRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("ORC_Operation",OPERRowId,hospid)
			} 
			//可以关联多家医院
			//if ($d(^User.BDPMappingHospI("HospRef","ORC_Operation",OPERRowId,hospid)) =0)
			//{
			//	d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("ORC_Operation",OPERRowId,hospid)
			//}
			
		}*/
	}
	
	
	
	///私有、绝对私有
	if ((tablename="")||(tablename="RBC_DepartmentGroup"))
	{
		w "科室部门组",!
		s DEPRowId=0
		for  
		{	
			s DEPRowId=$o(^RBC("DEP",DEPRowId)) q:DEPRowId=""
			if ($d(^User.BDPMappingHospI("HospRef","RBC_DepartmentGroup",DEPRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("RBC_DepartmentGroup",DEPRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="CT_Loc"))
	{
		w "科室",!
		s CTLOCRowID=0
	    for  
	    {
	        s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
	        s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
	        if CTLOCHospitalDR=""
	        {
		        s obj=##class(User.CTLoc).%OpenId(CTLOCRowID)
		        d obj.CTLOCHospitalDRSetObjectId(hospid) 
		        s sc=obj.%Save()
	        }
	    }	
	}
    
	if ((tablename="")||(tablename="SS_User"))
	{
		w "用户",!
		s SSUSRRowId=0
		for  
		{
			s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
			s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98) 	//医院
			s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
			if SSUSRDefaultDeptDR'=""
			{
				s SSUSRHospitalDR=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",22) 	
			}
			else
			{
				s SSUSRHospitalDR=hospid
			}	
			if SSUSRHospitalDR'=""
			{
				s obj=##class(User.SSUser).%OpenId(SSUSRRowId)
				d obj.SSUSRHospitalDRSetObjectId(SSUSRHospitalDR)
				s sc=obj.%Save()		
			}
		}
	}
	
	if ((tablename="")||(tablename="SS_Group"))
	{
		
		w "安全组",!
		s SSGRPRowId=0
		for
		{
			s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
			s hospeobj=##class(web.Entity.CT.SSGroupHospitals).%New()
			s hospeobj.HOSPRowId=""
			s hospeobj.HOSPHospitalDR=hospid
			s hospeobj.HOSPParRef=SSGRPRowId
			D ##class(web.DHCBL.CT.SSGroupHospitals).SaveEntity(hospeobj)
		}
	
	}
	if ((tablename="")||(tablename="CT_CareProv"))
	{
		
		w "医护人员",!
		s CTPCPRowId1=0
		for  
		{				
			s CTPCPRowId1=$o(^CTPCP(CTPCPRowId1)) q:CTPCPRowId1=""
			s HOSPChildsub=0,AuHospFlag=0
			s SSUSRRowID=$O(^SSU("SSUSR",0,"CTPCP",CTPCPRowId1,0))
			
			IF SSUSRRowID'=""
			{
				//按照默认登陆科室和其他登录科室的科室所属医院 ，添加到医护人员医院子表
				s SSUSRRowId=0
				for  
				{
					s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
					s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
					if SSUSRDefaultDeptDR'=""
					{
						s SSUSRHospitalDR=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",22)
						
						s hospeobj=##class(web.Entity.CT.CTCareProvHospitals).%New()
						s hospeobj.HOSPRowId=""
						s hospeobj.HOSPHospitalDR=hospid
						s hospeobj.HOSPParRef=CTPCPRowId1
						D ##class(web.DHCBL.CT.CTCareProvHospitals).SaveEntity(hospeobj)
					}
					
					s ChildSub =0
					for 
					{
						s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""  
						s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)
				  		if OTHLLCTLOCDR'=""
				  		{
					  		s SSUSRHospitalDR=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",22)
							s hospeobj=##class(web.Entity.CT.CTCareProvHospitals).%New()
							s hospeobj.HOSPRowId=""
							s hospeobj.HOSPHospitalDR=hospid
							s hospeobj.HOSPParRef=CTPCPRowId1
							D ##class(web.DHCBL.CT.CTCareProvHospitals).SaveEntity(hospeobj)
					  		
				  		}
					}
					
				}
			}
			else
			{
				//号别
				if SSUSRHospitalDR'=""
				{
					s hospeobj=##class(web.Entity.CT.CTCareProvHospitals).%New()
					s hospeobj.HOSPRowId=""
					s hospeobj.HOSPHospitalDR=hospid
					s hospeobj.HOSPParRef=CTPCPRowId1
					D ##class(web.DHCBL.CT.CTCareProvHospitals).SaveEntity(hospeobj)
				}
				
			}
		}
	}
	if ((tablename="")||(tablename="PAC_BedType"))
	{
		
		w "床位类型",!
		s BEDTPRowId=0
		for  
		{	
			s BEDTPRowId=$o(^PAC("BEDTP",BEDTPRowId)) q:BEDTPRowId=""
			if ($d(^User.BDPMappingHospI("HospRef","PAC_BedType",BEDTPRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("PAC_BedType",BEDTPRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="PAC_RoomType"))
	{
		
		w "房间类型",!
		s ROOMTRowId=0
		for  
		{	
			s ROOMTRowId=$o(^PAC("ROOMT",ROOMTRowId)) q:ROOMTRowId=""
			if ($d(^User.BDPMappingHospI("HospRef","PAC_RoomType",ROOMTRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("PAC_RoomType",ROOMTRowId,hospid)
			}
		}
	}
		
	if ((tablename="")||(tablename="PAC_Room"))
	{
		w "房间",!
		s ROOMRowID=0
		for  
		{	
			s ROOMRowID=$o(^PAROOM(ROOMRowID)) q:ROOMRowID=""
			if ($d(^User.BDPMappingHospI("HospRef","PAC_Room",ROOMRowID))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("PAC_Room",ROOMRowID,hospid)
			}
		}
		
	}     
	if ((tablename="")||(tablename="CT_LocationList"))
	{
		/*
		w "科室列表",!
		s LLRowId=0
		for
		{
			s LLRowId=$o(^CT("LL",LLRowId)) q:LLRowId="" 
			if ($d(^User.BDPMappingHospI("HospRef","CT_LocationList",LLRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CT_LocationList",LLRowId,hospid)
			}
		}
		*/
	}
	
	if ((tablename="")||(tablename="ARC_BillGrp"))
	{
		w "账单组，账单子组",!
		s ARCBGRowId=0
		for
		{
			s ARCBGRowId=$o(^ARCBG(ARCBGRowId))  
			q:((ARCBGRowId="")||(ARCBGRowId="SG_Abbr")||(ARCBGRowId="SG_Code")||(ARCBGRowId="SG_Desc")) 
			if ($d(^User.BDPMappingHospI("HospRef","ARC_BillGrp",ARCBGRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("ARC_BillGrp",ARCBGRowId,hospid)
			}
			
			s ChildSub =0
		   	for
		   	{
			   	s ChildSub=$o(^ARCBG(ARCBGRowId,"SG",ChildSub)) q:ChildSub=""
		    	s ARCSGRowId=ARCBGRowId_"||"_ChildSub
		    	if ($d(^User.BDPMappingHospI("HospRef","ARC_BillSub",ARCSGRowId))) =0
				{
					d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("ARC_BillSub",ARCSGRowId,hospid)
				}
		   	}
			
		}
	}
	if ((tablename="")||(tablename="BLC_ReasonForRefund"))
	{
		w "退款原因",!
		s RFRRowId=0
		for
		{
			s RFRRowId=$o(^BLC("RFR",RFRRowId)) q:RFRRowId=""   
			if ($d(^User.BDPMappingHospI("HospRef","BLC_ReasonForRefund",RFRRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("BLC_ReasonForRefund",RFRRowId,hospid)
			} 
		}
	}
	if ((tablename="")||(tablename="ARC_InsuranceType"))
	{
		w "付款人",!
		s INSTRowId=0
		for
		{
			s INSTRowId=$o(^ARC("INST",INSTRowId))  q:INSTRowId="" 
			if ($d(^User.BDPMappingHospI("HospRef","ARC_InsuranceType",INSTRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("ARC_InsuranceType",INSTRowId,hospid)
			} 
		}
	}
	if ((tablename="")||(tablename="ARC_ItmMast"))
	{
		
		w "医嘱项",!
		S ARCIMSubscript=0
		for
		{
			s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript))  q:ARCIMSubscript=""
			s ARCIMVersion=0
			for 
			{
				s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion=""
				S ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
				s hospeobj = ##class(web.Entity.CT.ARCItemHosp).%New()
				s hospeobj.HOSPRowId= ""
				s hospeobj.HOSPParRef=ARCIMRowId
				s hospeobj.HOSPHospitalDR=hospid
				d ##class(web.DHCBL.CT.ARCItemHosp).SaveEntity(hospeobj)
			}
		}
	}
	if ((tablename="")||(tablename="OEC_OrderCategory"))
	{
		
		w "医嘱大类",!
		s ORCATRowId=0
		f {
			s ORCATRowId=$o(^OEC("ORCAT",ORCATRowId))
			q:ORCATRowId=""
			if ($d(^User.BDPMappingHospI("HospRef","OEC_OrderCategory",ORCATRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("OEC_OrderCategory",ORCATRowId,hospid)
			}
				
		}
	}
	if ((tablename="")||(tablename="ARC_ItemCat"))
	{
		
		w "医嘱子类 ",!
		s ARCICRowId=0
		f {
			s ARCICRowId=$o(^ARC("IC",ARCICRowId))
			q:ARCICRowId=""
			if ($d(^User.BDPMappingHospI("HospRef","ARC_ItemCat",ARCICRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("ARC_ItemCat",ARCICRowId,hospid)
			}
			
		}
	}
	if ((tablename="")||(tablename="RBC_ServiceGroup"))
	{
			
		w "服务组",!
		s SGRowId=0
		for
		{
			s SGRowId=$o(^RBC("SG",SGRowId)) q:SGRowId=""  
			if ($d(^User.BDPMappingHospI("HospRef","RBC_ServiceGroup",SGRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("RBC_ServiceGroup",SGRowId,hospid)
			} 
		}
	}
	if ((tablename="")||(tablename="RBC_EquipmentGroup"))
	{
		
		w "资源组",!
		s GRPRowId=0
		for
		{
			s GRPRowId=$o(^RBC("GRP",GRPRowId)) q:GRPRowId="" 
			if ($d(^User.BDPMappingHospI("HospRef","RBC_EquipmentGroup",GRPRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("RBC_EquipmentGroup",GRPRowId,hospid)
			} 
		}
	}
	if ((tablename="")||(tablename="RBC_Equipment"))
	{
		
	    w "规定资源",!
	    s EQRowId=0
		for 
		{
			s EQRowId=$o(^RBC("EQ",EQRowId)) q:EQRowId=""
			if ($d(^User.BDPMappingHospI("HospRef","RBC_Equipment",EQRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("RBC_Equipment",EQRowId,hospid)
			} 
		}
	}
	if ((tablename="")||(tablename="RBC_SessionType"))
	{
		
		//挂号职称
		s SESSRowId=0
		for
		{
			s SESSRowId=$o(^RBC("SESS",SESSRowId))  q:SESSRowId="" 
			if ($d(^User.BDPMappingHospI("HospRef","RBC_SessionType",SESSRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("RBC_SessionType",SESSRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="DHC_TarCate"))
	{
		
		w "收费项目大类",!
		s TARCRowId=0
		for
		{ 
			s TARCRowId=$o(^DHCTarC("CC",TARCRowId)) q:TARCRowId="" 
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarCate",TARCRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarCate",TARCRowId,hospid)
			}

		}
	}
	if ((tablename="")||(tablename="DHC_TarSubCate"))
	{
		w "收费项目子类",!
		s TARSCRowId=0
		for
		{ 
			s TARSCRowId=$o(^DHCTarC("SC",TARSCRowId)) 
			q:TARSCRowId="" 
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarSubCate",TARSCRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarSubCate",TARSCRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="DHC_TarIC"))
	{
		
		w "住院费用大类",!
		s TARTICRowId=0
		for
		{ 
			s TARTICRowId=$o(^DHCTarC("TIC",TARTICRowId)) 
			q:TARTICRowId=""   
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarIC",TARTICRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarIC",TARTICRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="DHC_TarInpatCate"))
	{
		
		w "住院费用子类",!
		s TARICRowId=0
		for
		{ 
			s TARICRowId=$o(^DHCTarC("IC",TARICRowId)) 
			q:TARICRowId=""  
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarInpatCate",TARICRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarInpatCate",TARICRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="DHC_TarOC"))
	{
		
		w "门诊费用大类",!
		s TARTOCRowId=0
		for
		{ 
			s TARTOCRowId=$o(^DHCTarC("TOC",TARTOCRowId)) 
			q:TARTOCRowId=""    
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarOC",TARTOCRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarOC",TARTOCRowId,hospid)
			}
			
		}
	}
	if ((tablename="")||(tablename="DHC_TarOutpatCate"))
	{
		
		w "门诊费用子类",!
		s TAROCRowId=0
		for
		{ 
			s TAROCRowId=$o(^DHCTarC("OC",TAROCRowId)) 
			q:TAROCRowId=""    
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarOutpatCate",TAROCRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarOutpatCate",TAROCRowId,hospid)
			}
			
		}
	}
	if ((tablename="")||(tablename="DHC_TarEC"))
	{
		
		w "经济核算大类",!
		s TARTECRowId=0
		for
		{ 
			s TARTECRowId=$o(^DHCTarC("TEC",TARTECRowId)) q:TARTECRowId=""    
	    	if ($d(^User.BDPMappingHospI("HospRef","DHC_TarEC",TARTECRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarEC",TARTECRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="DHC_TarEMCCate"))
	{
		
	    w "经济核算子类",!
	    s TARECRowId=0
		for
		{ 
			s TARECRowId=$o(^DHCTarC("EC",TARECRowId)) 
			q:TARECRowId=""    
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarEMCCate",TARECRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarEMCCate",TARECRowId,hospid)
			}

		}
	}
	if ((tablename="")||(tablename="DHC_TarMC"))
	{
		
		w "旧病案首页大类",!
		s TARTMCRowId=0
		for
		{ 
			s TARTMCRowId=$o(^DHCTarC("TMC",TARTMCRowId)) 
			q:TARTMCRowId=""    
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarMC",TARTMCRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarMC",TARTMCRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="DHC_TarMRCate"))
	{
		
		w "旧病案首页子类",!
		s TARMCRowId=0
		for
		{ 
			s TARMCRowId=$o(^DHCTarC("MC",TARMCRowId)) 
			q:TARMCRowId=""    
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarMRCate",TARMCRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarMRCate",TARMCRowId,hospid)
			}
		}
	}
	
	if ((tablename="")||(tablename="DHC_TarAC"))
	{
		
		w "会计费用大类",!
		s TARTACRowId=0
		for
		{ 
			s TARTACRowId=$o(^DHCTarC("TAC",TARTACRowId)) 
			q:TARTACRowId=""    
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarAC",TARTACRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarAC",TARTACRowId,hospid)
			} 
		}
	}
	if ((tablename="")||(tablename="DHC_TarAcctCate"))
	{
		
		w "会计费用子类",!
		s TARACRowId=0
		for
		{ 
			s TARACRowId=$o(^DHCTarC("AC",TARACRowId)) q:TARACRowId=""    
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarAcctCate",TARACRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarAcctCate",TARACRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="DHC_TarMCNew"))
	{
		
		w "新病案首页大类",!
		s NTARTMCRowId=0
		for
		{ 
			s NTARTMCRowId=$o(^DHCTarC("TMCNew",NTARTMCRowId)) 
			q:NTARTMCRowId="" 
			
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarMCNew",NTARTMCRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarMCNew",NTARTMCRowId,hospid)
			}
		}  
	}
	if ((tablename="")||(tablename="DHC_TarMCCateNew"))
	{
		
		w "新病案首页子类",!
		s NTARMCRowId=0
		for
		{ 
			s NTARMCRowId=$o(^DHCTarC("MCNew",NTARMCRowId)) 
			q:NTARMCRowId="" 
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarMCCateNew",NTARMCRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarMCCateNew",NTARMCRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="BDP_ItemCategory"))
	{
		
		w "收费项目树形分类",!
		s RowId=0
		for
		{
			s RowId=$o(^User.BDPItemCategoryD(RowId)) q:RowId=""
			if ($d(^User.BDPMappingHospI("HospRef","BDP_ItemCategory",RowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("BDP_ItemCategory",RowId,hospid)
			}
		}
	}
	
	if ((tablename="")||(tablename="DHC_TarItem"))
	{
		
		w "收费项目",!
		s TARIRowId=0
		for
		{
			s TARIRowId=$o(^DHCTARI(TARIRowId)) q:TARIRowId=""
			if $g(^DHCTARI(TARIRowId))="" continue  //过滤空数据
			if ($d(^User.BDPMappingHospI("HospRef","DHC_TarItem",TARIRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarItem",TARIRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="INC_Itm"))
	{
		
		w "库存项",!
		s INCIRowId=0
		for
		{
			s INCIRowId=$o(^DHCTARI(INCIRowId)) q:((INCIRowId="")||(INCIRowId'>0))
			//库存项表DHC_ItmAddHosp
			if $d(^ITMADDHOP(0,"HospInc",hospid,INCIRowId))>0
			{
					
			}
			else
			{
				s obj=##class(User.DHCItmAddHosp).%New()
		        d obj.IAHIncItmDRSetObjectId(INCIRowId) 
		        d obj.IAHHospitalDRSetObjectId(hospid) 
		        s obj.IAHStartDate=+$h
		        s obj.IAHNotUseFlag="N"
		        s obj.IAHPreRecFlag="N"
		        s sc=obj.%Save()
			}
		}
	}
	if ((tablename="")||(tablename="INC_StkCat"))
	{
		
		w "库存分类",!
		s INCSCRowId=0
		for
		{
			s INCSCRowId=$o(^INC("SC",INCSCRowId)) q:INCSCRowId=""
			if ($d(^User.BDPMappingHospI("HospRef","INC_StkCat",INCSCRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("INC_StkCat",INCSCRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="DHC_StkCatGroup"))
	{
		w "库存类组",!
		s SCGRowid=0
		for
		{
			s SCGRowid=$o(^DHCSCG(INCSCRowId)) q:((SCGRowid="")||(SCGRowid'>0))
			if ($d(^User.BDPMappingHospI("HospRef","DHC_StkCatGroup",SCGRowid))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_StkCatGroup",SCGRowid,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="PHC_DrgMast"))
	{
		
		w "药学项",!
		s PHCDRowId=0
		for
		{
			s PHCDRowId=$o(^PHCD(PHCDRowId)) q:((PHCDRowId="")||(PHCDRowId'>0))
			if ($d(^User.BDPMappingHospI("HospRef","PHC_DrgMast",PHCDRowId))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("PHC_DrgMast",PHCDRowId,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="PH_Manufacturer"))
	{
		
		w "厂商",!
		s Rowid=0
		for
		{
			s Rowid=$o(^PHMNF(Rowid)) q:((Rowid="")||(Rowid'>0))
			if ($d(^User.BDPMappingHospI("HospRef","PH_Manufacturer",Rowid))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("PH_Manufacturer",Rowid,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="APC_Vendor"))
	{
		
		w "供应商",!
		s Rowid=0
		for
		{
			s Rowid=$o(^APC("APCVM",Rowid)) q:((Rowid="")||(Rowid'>0))
			if ($d(^User.BDPMappingHospI("HospRef","APC_Vendor",Rowid))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("APC_Vendor",Rowid,hospid)
			}
		}
	}
	
	if ((tablename="")||(tablename="APC_Vendor"))
	{
		
		w "产地",!
		s Rowid=0
		for
		{
			s Rowid=$o(^APC("APCVM",Rowid)) q:((Rowid="")||(Rowid'>0))
			if ($d(^User.BDPMappingHospI("HospRef","APC_Vendor",Rowid))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("APC_Vendor",Rowid,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="APC_Vendor"))
	{
		
		w "配送商",!
		s Rowid=0
		for
		{
			s Rowid=$o(^APC("APCVM",Rowid)) q:((Rowid="")||(Rowid'>0))
			if ($d(^User.BDPMappingHospI("HospRef","APC_Vendor",Rowid))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("APC_Vendor",Rowid,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="APC_Vendor"))
	{
		
		w "合同单位",!
		s Rowid=0
		for
		{
			s Rowid=$o(^APC("APCVM",Rowid)) q:((Rowid="")||(Rowid'>0))
			if ($d(^User.BDPMappingHospI("HospRef","APC_Vendor",Rowid))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("APC_Vendor",Rowid,hospid)
			}
		}
	}
	if ((tablename="")||(tablename="BDP_Holiady"))
	{
		w "节假日",!
		s Rowid=0
		for
		{
			s Rowid=$o(^APC("APCVM",Rowid)) q:((Rowid="")||(Rowid'>0))
			if ($d(^User.BDPMappingHospI("HospRef","BDP_Holiady",Rowid))) =0
			{
				d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("BDP_Holiady",Rowid,hospid)
			}
		}
	}
	q ""
}

/// Function:根据表名，校验医院是否符合配置（只能为默认组医院/例外医院，私有数据只能填一个医院，管控数据可以填多家）  医院名称1/医院名称2
/// Creator:chenying 
/// CreateDate:2018-4-16
/// input:关联的医院,医院rowid 2) 
/// Debug： w ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospId("ARC_ItemCat","东华标准版数字化医院[总院]/D")
ClassMethod GetHospId(tableName As %String, HospDesc As %String) As %String
{
	n (tableName,HospDesc,%session)
	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()  //{limited:1,IDS:[{ID:2},{ID:3}]}
	q:HospDesc="" ""
	s LinkHospId=""
	//获取数据公有私有类型
	i '$d(^||TMPBDP("DataType",tableName,$j))
	{
		s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tableName)	 //获取数据公有私有类型
		s ^||TMPBDP("DataType",tableName,$j)=DataTypeFlag
	}
	else
	{	
		s DataTypeFlag=^||TMPBDP("DataType",tableName,$j)
	}
	if (DataTypeFlag="S")  //私有不允许有多家医院，并且医院只能为这个表对应的默认医院或者例外医院
	{
		if HospDesc["/"
		{
			q "-1^私有数据不允许关联多家医院"
		}
		
		s LinkHospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospDesc),0))	
		if LinkHospId="" q "-1^医院名称错误"
		
		s DefLinkHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tableName,LinkHospId,+$H)	
		if (DefLinkHospId'=LinkHospId) q "-1^医院不是默认组医院或者例外医院"
		if (AuHospStr'=1)&&(AuHospStr'="off")
		{
			s strHosp="{ID:"_LinkHospId_"}"
			if AuHospStr'[strHosp q "-1^没有"_HospDesc_"医院的权限"
		}
	}
	elseif (DataTypeFlag="A") //绝对私有不允许有多家医院,并且允许是任何一家医院
	{
		if HospDesc["/"
		{
			q "-1^绝对私有数据不允许关联多家医院"
		}	
		s LinkHospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospDesc),0))	
		if LinkHospId="" q "-1^医院名称错误"
		if (AuHospStr'=1)&&(AuHospStr'="off")
		{
			
			s strHosp="{ID:"_LinkHospId_"}"
			if AuHospStr'[strHosp q "-1^没有"_HospDesc_"医院的权限"
		}
	}
	elseif (DataTypeFlag="C")  //管控
	{
		s errorflag=0,defflag=0
		s ErrorStr=""
		for hospi=1:1:$l(HospDesc,"/")
		{
			s Desc=$p(HospDesc,"/",hospi)
			s HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))	
			if HospId=""
			{
				s errorflag=1
			}
			else
			{
				if LinkHospId="" s LinkHospId=HospId
				else  s LinkHospId=LinkHospId_"/"_HospId	
			}
			s DefLinkHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tableName,HospId,+$H)	
			if (DefLinkHospId'=HospId) s defflag=1
			if (AuHospStr'=1)&&(AuHospStr'="off")
			{
				s strHosp="{ID:"_HospId_"}"
				if AuHospStr'[strHosp s ErrorStr= "-1^没有"_Desc_"医院的权限"
			}
		}
		if ErrorStr'="" q ErrorStr
		if (errorflag=1) q "-1^医院名称错误"
		if (defflag=1) q "-1^医院不是默认组医院或者例外医院"
		
	}
	elseif (DataTypeFlag="G")  //公有
	{
		q "-1^公有数据，表格里医院列需要为空"
	}
	
	q LinkHospId
}

/// Function:根据表名，校验医院是否符合配置（只能为默认组医院/例外医院，私有数据只能填一个医院，管控数据可以填多家）  医院名称1/医院名称2
/// Creator:chenying 
/// CreateDate:2018-4-16
/// input:关联的医院,医院rowid 2) 
/// Debug： w ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId("ARC_ItemCat","2/82")
ClassMethod ValidateHospId(tableName As %String, HospIds As %String) As %String
{
	n (tableName,HospIds)
	s ret=""
	///2020-06-02添加	
	//获取数据公有私有类型
	i '$d(^||TMPBDP("DataType",tableName,$j))
	{
		s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tableName)	 //获取数据公有私有类型
		s ^||TMPBDP("DataType",tableName,$j)=DataTypeFlag
	}
	else
	{	
		s DataTypeFlag=^||TMPBDP("DataType",tableName,$j)
	}
	if (HospIds<0) s ret=HospIds_"，"
	if (DataTypeFlag'="G")  //非公有数据都需要判断医院
	{
		if (HospIds="") s ret="【医院】不能为空，"
	}
	q ret
}

/// Table:User.BDPMappingHosp，User.CTHospital
/// Function:云HIS 新增接口，用于收费项目价格，需要根据收费项的医院来判断收费项目价格医院显示哪些
/// CreateDate:2020-05-06
/// Creator:基础数据平台组  陈莹
/// Input: rowid（医院rowid）, desc（医院desc），tablename（表名）， SessionStr(用户ID^安全组ID^科室ID^当前登录医院ID，不传的时候默认根据session来取)，HospGroup（父表的医院组  医院组)
/// Output: HOSPRowId(医院rowid),HOSPDesc(医院名称)
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPMappingHOSP","GetHospDataForGroup","","","DHC_TarItemPrice","1^1^1^2",2,"DHC_TarItem")
Query GetHospDataForGroup(rowid As %String, desc As %String, tablename As %String, SessionStr As %String, HospGroup As %String, Grouptablename) As %Query(ROWSPEC = "HOSPRowId,HOSPDesc")
{
}

ClassMethod GetHospDataForGroupExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, tablename As %String, SessionStr As %String, HospGroup As %String, Grouptablename) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s HOSPRowId=rowid
        s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
        d OutputRowHospComGroup
    }
    else
    {
	    s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
		//获取医院级授权 
        if SessionStr'=""
        {
	        s AuHospStr=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospAutBySessionStr(SessionStr)  
        }
        else
        {
        	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()   ///不传默认取session的权限
        }
        
        s GroupDataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(Grouptablename)
        s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tablename)	 //获取数据公有私有类型
		s GroupHospGroupIds=##class(web.DHCBL.BDP.BDPMappingHOSP).GetGroupHospIdsByTableName(Grouptablename,HospGroup)    ///父表 这个医院组 下的所有医院
		
		
		for hospi=1:1:$l(GroupHospGroupIds,",")
		{
			
			s RowId=$p(GroupHospGroupIds,",",hospi)
			s strRowId = "{ID:"_RowId_"}"
            i ((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1)) ;用来筛选授权数据
            {
                s HOSPDesc=$p($g(^CT("HOSP",RowId)),"^",2)
                s HOSPDateTo=$p($g(^CT("HOSP",RowId)),"^",10)
                continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
				s HOSPRowId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tablename,RowId)  //获取到医院对应的默认医院（判断例外和医院组）
				if (HOSPRowId>0)
	            {
	            	s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
	            }
	            else
	            {
	                s HOSPDesc=$p(HOSPRowId,"^",2)
	                s HOSPRowId=-1
	                
	            }
	            if $d(HospArray(HOSPRowId))>0 continue
				s HospArray(HOSPRowId)=""
				d OutputRowHospComGroup
            }
		}
		
		// 收费项A1  
		//收费项私有，价格私有    a1 返回a1   :    A1 GroupHospGroupIds A1,A2,A3   没有例外，  显示A1
		//收费项私有，价格私有，如果对价格 A3例外，返回A1+A3 :  GroupHospGroupIds A1+A2+A3, 没有例外，显示A1  ;  A3例外，显示A1+A3
		//如果对收费项A3例外， 价格就A3也要例外 ，那选A1 出来A1,A3出来A3:   GroupHospGroupIds A1+A2,  A3例外，显示A1  ,A3 显示A3
		//如果收费项私有，价格绝对私有，就你说的 选A1,出来A1下的所有医院:	 A1+a2+a3  
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowHospComGroup
    set Data=$lb(HOSPRowId,HOSPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHospDataForGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospDataForGroupExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetHospDataForGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospDataForGroupExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 2020-06-12
/// Creator:chenying
/// Function：获取表是公有G ，私有S，管控C，绝对私有A标识
/// Table：User.BDPTableList
/// Return：公有G ，私有S，管控C，绝对私有A
/// w ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType("PAC_BedType")
ClassMethod GetDataType(tableName As %String) As %String
{
	n (tableName)
	s DataType="G"
	Q:tableName="" DataType
	s DataType=$o(^User.BDPTableListI("ClassNameDataTypeRef",tableName,0))
	if (DataType="")||(DataType=-100000000000000) s DataType="G"
	Q DataType
}

/// Creator:陈莹
/// CreatDate:2021-05-27
/// Description:返回一条用户数据的科室ID串
/// Other:w ##class(web.DHCBL.BDP.BDPMappingHOSP).GetSSUserCTLocIDsByRowId(1)
ClassMethod GetSSUserCTLocIDsByRowId(RowId)
{
	n (RowId)
	s value=""
	Q:(RowId="") ""
	// 处理数据，去重，去掉无效数据
	k ArrayLOCSGroup
	s DefCTLOC=$p($g(^SSU("SSUSR",RowId)),"^",4)
	s DefSSGroup=$p($g(^SSU("SSUSR",RowId)),"^",5)
	s ChildSub =0
	for
	{
		s ChildSub=$o(^SSU("SSUSR",RowId,"OTHLL",ChildSub)) q:ChildSub=""
		s OTHLLStartDate=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",4)
		s OTHLLEndDate=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",5)
		continue:(OTHLLEndDate'="")&&(OTHLLEndDate<+$h)
		s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",1)
		s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",RowId,"OTHLL",ChildSub)),"^",2)
		continue:OTHLLCTLOCDR=""
		continue:OTHLLUserGroupDR=""
  		if '((DefCTLOC=OTHLLCTLOCDR)&&(DefSSGroup=OTHLLUserGroupDR))
  		{
  			s ArrayLOCSGroup(OTHLLCTLOCDR,OTHLLUserGroupDR)=""  //其他登录科室
  			
  		}
	}
	if (DefCTLOC'="")&&(DefSSGroup'="")
	{
		s value=DefCTLOC  //默认登录科室  
	}
	s CTLOC =0
	for
	{
		s CTLOC=$o(ArrayLOCSGroup(CTLOC)) q:CTLOC=""
		s SSGroup =0
		for
		{
			s SSGroup=$o(ArrayLOCSGroup(CTLOC,SSGroup)) q:SSGroup=""
			s Desc=CTLOC
			s value=value_"/"_Desc  //拼接其他登录科室
		}
	}
	q value
}

/// 根据医院代码 返回所属医院组代码
/// 基础数据-likefan
/// 2021-10-29
/// w ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospCodeByCode1("")
ClassMethod GetDefHospCodeByCode1(code As %String) As %String
{
	n (code)
	q:code="" ""
	s rowid=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	q:rowid="" ""
	s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",rowid)),"^",41)	//默认医院
	if (HOSPDefaultHospitalDR="")
	{
		q code
	}
	else
	{
		s DefHospCode=$p($g(^CT("HOSP",HOSPDefaultHospitalDR)),"^",1)	//默认医院代码
		q DefHospCode
	}
}

/// 描述：根据医院代码 返回所属医院组代码。表名不为空时判断例外医院
/// 编写人：基础数据-likefan
/// 日期：2021-10-29
/// input: 医院代码 hospcode，表名 tablename
/// output: 医院组默认医院代码
/// debug: w ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospCodeByCode("")
ClassMethod GetDefHospCodeByCode(hospcode As %String, tablename As %String = "") As %String
{
	n (hospcode,tablename)
	q:hospcode="" ""
	s rowid=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(hospcode),0))
	q:rowid="" ""
	s DefHospCode=""	//定义返回值
	if (tablename="")
	{
		s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",rowid)),"^",41)	//默认医院
		s:HOSPDefaultHospitalDR="" DefHospCode=hospcode
		s:HOSPDefaultHospitalDR'="" DefHospCode=$p($g(^CT("HOSP",HOSPDefaultHospitalDR)),"^",1)	//默认医院代码
	}
	else
	{
		s DefHosp=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tablename,rowid)
		s DefHospCode=""
		s:DefHosp'="" DefHospCode=$p($g(^CT("HOSP",DefHosp)),"^",1)	//默认医院代码
	}
	q DefHospCode
}

}
