/// 
Class web.DHCBL.BDP.ClassIOBDP Extends web.DHCBL.BDP.ClassCheckIO [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 20170801
/// Description：批量生成地理信息下数据的别名
/// Table：
/// Input：
/// Return：
/// 	W ##class(web.DHCBL.BDP.ClassIOLiuqi).BatchCreateAlias()
ClassMethod BatchCreateAlias() As %String
{
	
	///国家
	s CTCOURowId=0
	for
	{	
		s CTCOURowId=$o(^CT("COU",CTCOURowId)) q:CTCOURowId=""
		s CTCOUDesc=$p($g(^CT("COU",CTCOURowId)),"^",2)
		S Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTCOUDesc)
		d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("^CT_Country^"_Alias_"^"_CTCOURowId)
	}
	//区域
	s CTRGRowId=0
	for
	{
		s CTRGRowId=$o(^CT("RG",CTRGRowId)) q:CTRGRowId=""
		s CTRGDesc=$p($g(^CT("RG",CTRGRowId)),"^",2)
		S Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTRGDesc)
		d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("^CT_Region^"_Alias_"^"_CTRGRowId)	
	}
	//省份
	s PROVRowId=0
	for
	{
		s PROVRowId=$o(^CT("PROV",PROVRowId)) q:PROVRowId=""
		s PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)
		S Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROVDesc)
		d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("^CT_Province^"_Alias_"^"_PROVRowId)
		
		///加开始日期
		s obj=##class(User.CTProvince).%OpenId(PROVRowId)
		s obj.PROVDateFrom = +$h
		s sc=obj.%Save()
		k obj
		
	}	
	//城市		
	s CTCITRowId=0
	for
	{
		s CTCITRowId=$o(^CT("CIT",CTCITRowId)) q:CTCITRowId=""		
		s CTCITDesc=$p($g(^CT("CIT",CTCITRowId)),"^",2)
		S Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTCITDesc)
		d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("^CT_City^"_Alias_"^"_CTCITRowId)
		///加开始日期
		s obj=##class(User.CTCity).%OpenId(CTCITRowId)
		s obj.CTCITDateFrom = +$h
		s sc=obj.%Save()
		k obj
	}
	//城市区域
	s CITAREARowId=0
	for
	{
		s CITAREARowId=$o(^CT("CITAREA",CITAREARowId)) q:CITAREARowId=""
		s CITAREADesc=$p($g(^CT("CITAREA",CITAREARowId)),"^",2)
		S Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CITAREADesc)
		d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("^CT_CityArea^"_Alias_"^"_CITAREARowId)	
		///加开始日期
		s obj=##class(User.CTCityArea).%OpenId(CITAREARowId)
		s obj.CITAREADateFrom = +$h
		s sc=obj.%Save()
		k obj
	}
	//街道
	s LOCTYPERowId=0
	for
	{  
		s LOCTYPERowId=$o(^CT("LOCTYPE",LOCTYPERowId)) q:LOCTYPERowId="" 
		s LOCTYPEDesc=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",2)
		S Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(LOCTYPEDesc)
		d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("^CT_LocalityType^"_Alias_"^"_LOCTYPERowId)	
		///激活
		s obj=##class(User.CTLocalityType).%OpenId(LOCTYPERowId)
		s obj.LOCTYPEActiveFlag ="Y"
		s sc=obj.%Save()
		k obj
	}
	
	//地址
	s CTADDRowId=0
	for
	{ 
		s CTADDRowId=$o(^CT("ADD",CTADDRowId)) q:CTADDRowId=""   
		s CTADDDesc=$p($g(^CT("ADD",CTADDRowId)),"^",2)
		S Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTADDDesc)
		d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("^CT_Address^"_Alias_"^"_CTADDRowId)  
		///加开始日期
		s obj=##class(User.CTAddress).%OpenId(CTADDRowId)
		s obj.CTADDDateFrom = +$h
		s sc=obj.%Save()
		k obj
	}   
	q ""
}

/// Creator：陈莹
/// CreatDate: 2017-10-16 补处理新导入的诊断及代码里带空格的手术数据
/// Description：批量处理国家标准编码数据与基础数据对照
/// Other: d ##class(web.DHCBL.BDP.ClassIOLiuqi).BatchBDPDomain()
ClassMethod BatchBDPDomain() As %Integer
{
	n 
	s ID=0
	for
	{
		s ID=$O(^User.BDPMenuNATDataTypeD(ID)) Q:ID=""
		s MenuCode=$lg($g(^User.BDPMenuNATDataTypeD(ID)),2)  ///dhc.bdp.NewBorn.PACDeliveryMethod
		s NATDataType=$lg($g(^User.BDPMenuNATDataTypeD(ID)),3)  //CV02.10.003
		S MenuID=$O(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCVT(MenuCode,"U"),0))
		S ExecutableId=$LISTGET($G(^User.BDPMenuD(MenuID)),4)
		if ExecutableId=""
		{
			 continue
		}
		S TableName=$LISTGET($G(^User.BDPExecutablesD(ExecutableId)),4)  //"PAC_DeliveryMethod"
		s BDPDomainCodeA=$$ALPHAUP^SSUTIL4(NATDataType)

		K ^TMPBDPDomain
		s BDPDomainRowId=0
		for
		{
			s BDPDomainRowId=$o(^BDPDATADOMAIN(0,"Code",BDPDomainCodeA,BDPDomainRowId)) q:BDPDomainRowId=""
			s BDPDomainValue=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",3)
			s BDPDomainExpression=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",4)
			s ^TMPBDPDomain(NATDataType,BDPDomainValue)=BDPDomainExpression
		}
		s Xrowid="",Xcode=""
		if (TableName'="ORC_Operation")&&(TableName'="MRC_ICDDx")
		{
			continue
		}
		b ;w TableName 
		if (TableName="ORC_Operation")  //手术/过程
		{
			
			s Xrowid="s RowId=$o(^ORC(""OPER"",RowId))"
			s Xcode="s Code=$tr($p($g(^ORC(""OPER"",RowId)),""^"",1),"" "","""")"
		}
		if (TableName="MRC_ICDDx")  //诊断
		{
			
			s Xrowid="s RowId=$o(^MRC(""ID"",RowId))"
			s Xcode="s Code=$p($g(^MRC(""ID"",RowId)),""^"",4)"   //MRCIDICD9CMCode
		}
		IF Xrowid="" 
		{
			b ;XROWID=""
			continue	
		}
		s RowId=0
		for
		{
			x Xrowid
			q:RowId=""
			x Xcode
			if $d(^TMPBDPDomain(NATDataType,Code)) 
			{
				IF $d(^User.BDPStandardCodeI("InternalCodeRef",TableName,NATDataType,RowId))=0
				{
					s obj = ##class(User.BDPStandardCode).%New()
					s obj.BDPInternalCode =NATDataType   
					s obj.BDPInternalDesc = $G(^TMPBDPDomain(NATDataType,Code)) 
					s obj.BDPInternalValue=Code
					s obj.DataReference=RowId
					s obj.TableName=TableName
					s sc = obj.%Save()
				}
			}
		}
		
		
	}
}

/// Fucntion:动态判断字典是否存在该条数据
/// CreateDate:2022-11-02
/// Creator:sunfengchao
/// d ##class(web.DHCBL.BDP.ClassIOBDP).IfDataExist("ARC_BillGrp",1)
ClassMethod IfDataExist(Table As %String, rowid As %String) As %String
{
 	n (Table , rowid)
    s flag=0
    q:(Table="")||(rowid="") flag
    s sql="select %id   from "_Table_" where %id='"_rowid_"'"
    s xs=##class(%ResultSet).%New() 
    d xs.Prepare(sql)
    s ret=xs.Execute(sql)
    while (xs.Next())
    {
        s flag=1 
        q 
    }
    q flag
}

/// Fucntion:查询私有数据关联医院表的数据，是否真实存在
/// CreateDate:2022-11-02
/// Creator:sunfengchao
/// Table：  BDP_MappingHosp
/// w ##class(web.DHCBL.BDP.ClassIOBDP).GetUnExistList(0)  //查询私有数据关联医院表的数据
/// w ##class(web.DHCBL.BDP.ClassIOBDP).GetUnExistList(1)  //查询私有数据关联医院表的数据并删除错误数据
ClassMethod GetUnExistList(deleteflag As %String) As %String
{
	n (deleteflag)
 	if (deleteflag=0) k ^TMPGetUnExistList
 	s i=0
    s ID=0
    for 
    {
        s ID=$o(^User.BDPMappingHospD(ID)) q:ID=""
        s BDPMPHTableName= $lg($g(^User.BDPMappingHospD(ID)),2)     //表名称 
        s TableListID = $o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(BDPMPHTableName,"U"),0)) //表结构RowId  
        continue:TableListID="" 
        s TableDesc=""
        
        s:TableListID'="" TableDesc = $lg($g(^User.BDPTableListD(TableListID)),3) //中文名称
      	s BDPMPHDataReference = $lg($g(^User.BDPMappingHospD(ID)),3)  //对应表数据RowID 
        s TableGlobal=$LISTGET($G(^User.BDPTableListD(TableListID)),9)
        s existflag= ..IfDataExist(BDPMPHTableName,BDPMPHDataReference)  // 1存在 0 不存在 
        if existflag=0 ///不存在
        {     
            s BDPMPHHospital= $lg($g(^User.BDPMappingHospD(ID)),4)      //关联的医院 
            s:BDPMPHHospital'="" BDPMPHHospital=$p($g(^CT("HOSP",BDPMPHHospital)),"^",2)    //医院描述
            //s:BDPMPHTableName'="" BDPMPHTableName=BDPMPHTableName_"("_TableDesc_")"
            s i=i+1
            s str=ID_"^"_BDPMPHHospital_"^"_BDPMPHTableName_"^"_TableDesc_"^"_BDPMPHDataReference
            if (deleteflag=0) s ^TMPGetUnExistList(i)=str
            w str,!
           
            if (deleteflag=1)
            {
	            w ##class(User.BDPMappingHosp).%DeleteId(ID),!
		        
	            //b ;1
            }
        } 
		
	}
    q i
}

/// Fucntion:获取私有数据和管控数据关联了非默认医院的数据
/// CreateDate:2022-11-03
/// Creator:chenying
/// w ##class(web.DHCBL.BDP.ClassIOBDP).GetUnExistExpHosp(0) //获取私有数据和管控数据关联了非默认医院的数据。 
/// w ##class(web.DHCBL.BDP.ClassIOBDP).GetUnExistExpHosp(1) //查询数据，并删除错误数据
ClassMethod GetUnExistExpHosp(deleteflag As %String) As %String
{
	n (deleteflag)
	if (deleteflag=0) k ^TMPGetUnExistExpHosp
	s i=0
 	s ID=0
    for 
    {
        s ID=$o(^User.BDPMappingHospD(ID)) q:ID=""
        s BDPMPHTableName= $lg($g(^User.BDPMappingHospD(ID)),2)     //表名称 
        s BDPMPHDataReference = $lg($g(^User.BDPMappingHospD(ID)),3)  //对应表数据RowID 
        s BDPMPHHospital = $lg($g(^User.BDPMappingHospD(ID)),4)   //关联的医院
        s TableListID = $o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(BDPMPHTableName,"U"),0)) //表结构RowId  
        continue:TableListID="" 
        s DataType=$LISTGET($G(^User.BDPTableListD(TableListID)),10)  //私有数据类型
        s TableDesc=""
        s:TableListID'="" TableDesc = $lg($g(^User.BDPTableListD(TableListID)),3) //中文名称
        if ((DataType="C")||(DataType="S"))  //私有数据 管控数据
        {
	        //判断医院是不是关联的默认医院组。
	        s Hospital =##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(BDPMPHTableName,BDPMPHHospital,"")
	        if (Hospital'=BDPMPHHospital)
	        {
				s i=i+1
				s str=ID_"^"_BDPMPHHospital_"^"_BDPMPHTableName_"^"_TableDesc_"^"_BDPMPHDataReference
		        if (deleteflag=0) s ^TMPGetUnExistExpHosp(i)=str
		        w str,!
		        if (deleteflag=1)
		        {
			        d ##class(User.BDPMappingHosp).%DeleteId(ID)
		        }
	        }
        }
        else
        {
	        if (TableListID="A")  //绝对私有
	        {
		       
	        }
	        if (TableListID="G")  //公用数据
	        {
		        
	        }
        }
         
        
    }
    q i
}

}
