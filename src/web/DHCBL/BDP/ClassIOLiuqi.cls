Import SQLUser

Class web.DHCBL.BDP.ClassIOLiuqi Extends web.DHCBL.BDP.ClassCheckIO [ Not ProcedureBlock ]
{

/// 导入药品维护和物资维护的图标 ^BDPMenuCaption(菜单名，id)
/// w ##class(web.DHCBL.BDP.ClassIOLiuqi).DrugAndMaterial()
ClassMethod DrugAndMaterial() As %String
{
  s result=""	
  s ID=0
  for  
  {
	  s Icon=""
	  s ID=$o(^User.BDPMenuD(ID)) 
	  q:ID=""  
      s Caption=$LISTGET($G(^User.BDPMenuD(ID)),3)
      s ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ID)),11)  //获取上级菜单
      if (ParentMenuDr'="")
      {
	      s ParentMenu1=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),3) //获取菜单描述
	      s:ParentMenu1="HERP HIS对照" ParentMenu1="HERP-HIS对照"

	      if (ParentMenu1="物资维护")
	      {
		    s Icon="../scripts/bdp/Framework/BdpIconsLib/基础数据维护/物资维护/"_Caption_"/"_Caption_".png" 
	      }
	      s ParentMenuDr1=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),11) //获取上上级菜单
     	  if (ParentMenuDr1'="")
     	  {
	     	  
	     	  s ParentMenu2=$LISTGET($G(^User.BDPMenuD(ParentMenuDr1)),3) //获取上上级菜单的描述
	     	  if (ParentMenu2="药品维护")
	     	  {
		     	s Icon="../scripts/bdp/Framework/BdpIconsLib/基础数据维护/药品维护/"_Caption_".png"
	     	  }
		     	  
	     	  if (ParentMenu2="物资维护")
	     	  {
		     	  s Icon="../scripts/bdp/Framework/BdpIconsLib/基础数据维护/物资维护/"_ParentMenu1_"/"_Caption_".png"  	  
	     	  }
		     	  
	      }
     	}
     	
     	 if (Icon'="")
     	 {
     	  	    s obj=##class(User.BDPMenu).%OpenId(ID)
				s obj.Image=Icon
			
				s sc=obj.%Save()
		  		d obj.%Close()
		  		If $$$ISOK(sc)
		   		{
				    s result =result_"^"_1
		  		}
			    else
				{
				    s result =result_"^"_0
				}
     	  }
   }
   q result
}

/// 生成菜单名和id的索引 ^BDPMenuCaption(菜单名，id)
/// w ##class(web.DHCBL.BDP.ClassIOLiuqi).BDPMenuGlobal()
ClassMethod BDPMenuGlobal() As %String
{
  s ID=0
  f  s ID=$o(^User.BDPMenuD(ID)) q:ID=""  d
  .s Caption=$LISTGET($G(^User.BDPMenuD(ID)),3)
  .s ^BDPMenuCaption("Caption",Caption)=ID
  q "OK"
}

/// 导入菜单图标
/// w ##class(web.DHCBL.BDP.ClassIOLiuqi).ImportBdpIcons()
ClassMethod ImportBdpIcons() As %String
{

	s file=##class(%File).%New("D:\DtHealth\app\dthis\web\scripts\bdp\Framework\BdpIconsLib\菜单图标.txt")
	//w file.Size,!
	d file.Open("R")
	s SQLCODE=100
	k myXMLFileAry
	for i=1:1:file.Size {
	s data=file.Read()
	q:data=""
	s myXMLFileAry(i)=data	
	}
	close file
	
	s result =""
	Ts
	s i=0
	for {
		s i = $o(myXMLFileAry(i))
		q:(i="")
		s Name=$p(myXMLFileAry(i),"	",1)
		s Icon=$p(myXMLFileAry(i),"	",2)
		s ID=^BDPMenuCaption("Caption",Name)
		if (ID'=""){			
			s obj=##class(User.BDPMenu).%OpenId(ID)
			s obj.Image=Icon
			
			s sc=obj.%Save()
	  		d obj.%Close()
	  		If $$$ISOK(sc)
	   		{
			    s result =result_"^"_1
	  		}
		    else
			{
			    s result =result_"^"_0
			}
		}

	}
	if (result[0)
	{		
		Trollback
		s result = "false"		
	}
	else
	{
		Tc
		s result = "true"
	}
		
	q result
}

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
/// CreatDate: 2017-10-16 
/// Description：批量处理国家标准编码数据与基础数据对照
/// Other: d ##class(web.DHCBL.BDP.ClassIOLiuqi).BatchBDPDomain()
ClassMethod BatchBDPDomain() As %Integer
{
	n 
	k ^TMP("BDPStandardCode")
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
		
		w TableName ,!
		if (TableName="PAC_DeliveryMethod")  //分娩方法  分娩方式代码表
		{
			s Xrowid="s RowId=$o(^PAC(""DLMTH"",RowId))"
			s Xcode="s Code=$p($g(^PAC(""DLMTH"",RowId)),""^"",1)"
		}
		
		if (TableName="PAC_Allergy")  //过敏源   过敏源代码表
		{
			s Xrowid="s RowId=$o(^PAC(""ALG"",RowId))"
			s Xcode="s Code=$p($g(^PAC(""ALG"",RowId)),""^"",1)"
		}
		if (TableName="PAC_DischCondit")  //出院条件  病情转归代码表
		{
			
			s Xrowid="s RowId=$o(^PAC(""DISCON"",RowId))"
			s Xcode="s Code=$p($g(^PAC(""DISCON"",RowId)),""^"",1)"
		}
		if (TableName="ORC_ASA_ClassPhActiv")  //ASA分级 美国麻醉医师协会（ASA）分级标准代码表
		{
			
			s Xrowid="s RowId=$o(^ORC(""ASA"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""ASA"",RowId)),""^"",1)"
		}
		if (TableName="ORC_BladeType")  //切口类型 手术切口类型代码表
		{
			
			s Xrowid="s RowId=$o(^ORC(""BLDTP"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""BLDTP"",RowId)),""^"",1)"
		}
		if (TableName="ORC_OperationCategory")  //手术分类  手术级别代码表
		{
			
			s Xrowid="s RowId=$o(^ORC(""CATEG"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""CATEG"",RowId)),""^"",1)"
		}
		
		if (TableName="ORC_AnaestMethod")  //麻醉方法 麻醉方法代码表
		{
			
			s Xrowid="s RowId=$o(^ORC(""ANMET"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""ANMET"",RowId)),""^"",1)"
		}
		if (TableName="ORC_OperPosition")  //手术位置  手术体位代码表
		{
			
			s Xrowid="s RowId=$o(^ORC(""OPPOS"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""OPPOS"",RowId)),""^"",1)"
		}
		if (TableName="OEC_BodySite")  //操作部位  操作部位代码表
		{
			
			s Xrowid="s RowId=$o(^OEC(""BODS"",RowId))"
			s Xcode="s Code=$p($g(^OEC(""BODS"",RowId)),""^"",1)"
		}
		
		if (TableName="CT_CarPrvTp")  //医护人员类型  专业技术职务代码
		{
			
			s Xrowid="s RowId=$o(^CT(""CPT"",RowId))"
			s Xcode="s Code=$p($g(^CT(""CPT"",RowId)),""^"",1)"
		}
		if (TableName="PAC_AdmSource")  //许可来源  入院途径代码表
		{
			
			s Xrowid="s RowId=$o(^PAC(""ADSOU"",RowId))"
			s Xcode="s Code=$p($g(^PAC(""ADSOU"",RowId)),""^"",1)"
		}
		if (TableName="CT_Country")  //国家   世界各国和地区名称代码
		{
			
			s Xrowid="s RowId=$o(^CT(""COU"",RowId))"
			s Xcode="s Code=$p($g(^CT(""COU"",RowId)),""^"",1)"
		}
		if (TableName="CT_Nation")  //民族 民族类别代码表
		{
			
			s Xrowid="s RowId=$o(^CT(""NAT"",RowId))"
			s Xcode="s Code=$p($g(^CT(""NAT"",RowId)),""^"",1)"
		}
		if (TableName="CT_Occupation")  //职业 从业状况（个人身体）代码表
		{
			
			s Xrowid="s RowId=$o(^CT(""OCC"",RowId))"
			s Xcode="s Code=$p($g(^CT(""OCC"",RowId)),""^"",1)"
		}
		if (TableName="CT_Marital")  //婚姻状况 婚姻状况代码表
		{
			
			s Xrowid="s RowId=$o(^CT(""MAR"",RowId))"
			s Xcode="s Code=$p($g(^CT(""MAR"",RowId)),""^"",1)"
		}
		if (TableName="CT_Relation")  //家庭关系 家庭关系代码表
		{
			
			s Xrowid="s RowId=$o(^CT(""RLT"",RowId))"
			s Xcode="s Code=$p($g(^CT(""RLT"",RowId)),""^"",1)"
		}
		/*if (TableName="ORC_Operation")  //手术/过程  ICD-9手术编码
		{
			
			s Xrowid="s RowId=$o(^ORC(""OPER"",RowId))"
			s Xcode="s Code=$tr($p($g(^ORC(""OPER"",RowId)),""^"",14),"" "","""")"    //根据手术的ICD10代码来对照，手术有数据代码中存在空格，但标准元值域里不带空格的
		}*/
		if (TableName="CT_Sex")  //性别 生理性别代码表
		{
			
			s Xrowid="s RowId=$o(^CT(""SEX"",RowId))"
			s Xcode="s Code=$p($g(^CT(""SEX"",RowId)),""^"",1)"
		}
		if (TableName="CT_Province")  //省 中华人民共和国行政区划代码
		{
			
			s Xrowid="s RowId=$o(^CT(""PROV"",RowId))"
			s Xcode="s Code=$p($g(^CT(""PROV"",RowId)),""^"",1)"
		}
		if (TableName="CT_City")  //城市 中华人民共和国行政区划代码
		{
			
			s Xrowid="s RowId=$o(^CT(""CIT"",RowId))"
			s Xcode="s Code=$p($g(^CT(""CIT"",RowId)),""^"",1)"
		}
		if (TableName="CT_CityArea")  //城市区域 中华人民共和国行政区划代码
		{
			
			s Xrowid="s RowId=$o(^CT(""CITAREA"",RowId))"
			s Xcode="s Code=$p($g(^CT(""CITAREA"",RowId)),""^"",1)"
		}
		
		if (TableName="CT_Education")  //教育水平 学历代码表
		{
			
			s Xrowid="s RowId=$o(^CT(""EDU"",RowId))"
			s Xcode="s Code=$p($g(^CT(""EDU"",RowId)),""^"",1)"
		}
		/*if (TableName="MRC_ICDDx")  //诊断 中医病症分类与代码表、ICD-10诊断编码
		{
			
			s Xrowid="s RowId=$o(^MRC(""ID"",RowId))"
			s Xcode="s Code=$p($g(^MRC(""ID"",RowId)),""^"",4)"   ///诊断根据ICD10(MRCIDICD9CMCode)来对照，而不是代码
		}*/
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
			IF Code'=""
			{
				
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
			else
			{
				s ^TMP("BDPStandardCode",TableName,RowId)=""
			}
		}
		
		
	}
}

/// 调试：d ##class(web.DHCBL.BDP.ClassIOLiuqi).SetGlobal()
ClassMethod SetGlobal() As %String
{
	///2020-02-13 修正计数器
	s ^ARCIMDUPDI(0)=$o(^ARCIMDUPDI(""),-1)
	s ^DHCOLT(0)=$o(^DHCOLT(""),-1)
	s ^DHCTarC("TAC",0)=$o(^DHCTarC("TAC",""),-1) 
	s ^DHCTarC("AC",0)=$o(^DHCTarC("AC",""),-1) 
	s ^DHCTarC("CC",0)=$o(^DHCTarC("CC",""),-1) 
	s ^DHCTarC("SC",0)=$o(^DHCTarC("SC",""),-1) 
	s ^DHCTarC("TEC",0)=$o(^DHCTarC("TEC",""),-1) 
	s ^DHCTarC("EC",0)=$o(^DHCTarC("EC",""),-1) 
	s ^DHCTarC("TIC",0)=$o(^DHCTarC("TIC",""),-1) 
	s ^DHCTarC("IC",0)=$o(^DHCTarC("IC",""),-1) 
	s ^DHCTarC("TMC",0)=$o(^DHCTarC("TMC",""),-1) 
	s ^DHCTarC("MC",0)=$o(^DHCTarC("MC",""),-1) 
	s ^DHCTarC("TOC",0)=$o(^DHCTarC("TOC",""),-1) 
	s ^DHCTarC("OC",0)=$o(^DHCTarC("OC",""),-1) 
	s ^DHCTARI(0)=$o(^DHCTARI(""),-1)
	s ^DHCTARAL(0)=$o(^DHCTARAL("A"),-1)
}

/// 处理菜单数据，首拼 和 医用知识库标识
/// d ##class(web.DHCBL.BDP.ClassIOLiuqi).batchUpdate()
ClassMethod batchUpdate() As %String
{
	s ID=0
	for
	{
		s ID=$o(^User.BDPMenuD(ID)) q:ID=""
		k obj
		s obj=##class(User.BDPMenu).%OpenId(ID) 
		s Caption=$ZCONVERT(obj.Caption,"U")
		s obj.FirstPYCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Caption) //首拼
	    s obj.WholePYCODE=##class(web.DHCBL.BDP.FunLib).GetCNCODE(Caption,3,"")  //全拼
	    s sc=obj.%Save()
		d obj.%Close()
	}
	q "over"
}

/// Function: 批量处理表结构登记 Code, Desc, Xglobal 
/// Creator:  chenying
/// CreateDate:2020-06-01
///   d ##class(web.DHCBL.BDP.ClassIOLiuqi).MultiUpdateList()
ClassMethod MultiUpdateList() As %String
{
	s ID=0
	for
	{
		s ID=$o(^User.BDPTableListD(ID)) q:ID=""
		s TableName=$LISTGET($G(^User.BDPTableListD(ID)),2)  //(User.ARCItemCat)
		s TableDesc=$LISTGET($G(^User.BDPTableListD(ID)),3)
		s XCode=$LISTGET($G(^User.BDPTableListD(ID)),4)
		s Type=$LISTGET($G(^User.BDPTableListD(ID)),5)
		s XCode2=$LISTGET($G(^User.BDPTableListD(ID)),6)
		s Sources=$LISTGET($G(^User.BDPTableListD(ID)),7)
		s ClassName=$LISTGET($G(^User.BDPTableListD(ID)),8)
		s TableGlobal=$LISTGET($G(^User.BDPTableListD(ID)),9)
		s EXTID=$O(^User.BDPExecutablesI("CodeIndex"," "_$ZCVT(ClassName,"u"),0))
		s EXTClassName="",PropertyName=""
		if EXTID'=""
		{
			s EXTClassName=$LISTGET($G(^User.BDPExecutablesD(EXTID)),9)
  			s PropertyName=$LISTGET($G(^User.BDPExecutablesD(EXTID)),10)
  			if EXTClassName'=""
	  		{
		  		//continue:(TableName="User.RBResource")||(TableName="User.PACAdmTypeLocation")||(TableName="User.CTConFac")||(TableName="User.CTConFac")
		  		w TableDesc_" "_EXTClassName_" "_TableName_" "_PropertyName,! 
		  		s obj=##class(User.BDPTableList).%OpenId(ID)
		    	s obj.DescPropertyName=PropertyName  //处理描述字段，从功能大表里把数据同步过来
		   		d obj.%Save()
	  		}
	  		else
	  		{
		  		
		  		//w "ClassName为空"_TableDesc,!
	  		}
		}
		else
		{
			///w "功能大表里没有维护"_" "_TableDesc_" "_TableName,!
		}
		
		if (TableGlobal="")&&(XCode'="")
		{
			
			if XCode[",RowId" s TableGlobal="^"_$P($p(XCode,"^",2),",RowId",1)_")"
			else  if XCode["(RowId" s TableGlobal="^"_$P($p(XCode,"^",2),"(RowId",1)
			
			//w TableDesc_" "_TableName_" "_TableGlobal,!   //  _" "_XCode
			
			s obj=##class(User.BDPTableList).%OpenId(ID)
	    	s obj.TableGlobal=TableGlobal   //处理global字段，从XCode中把数据同步过来
	    	d obj.%Save()
		}
		
	}
}

/// Function: 处理导入和导入配置，将导出配置增加到导入配置表里。
/// Creator:  chenying
/// CreateDate:2021-01-08
/// debug:   w ##class(web.DHCBL.BDP.BDPIMConfig).MultiUpdateData()
ClassMethod MultiUpdateData() As %String
{
	k ^tmpcy
	s ID=0
	for
	{
		s ID=$o(^User.BDPIMConfigD(ID)) q:ID="" 
		s IMCTableDesc=$LISTGET($G(^User.BDPIMConfigD(ID)),2)  //描述
		s IMCTableName=$LISTGET($G(^User.BDPIMConfigD(ID)),3)   //代码
		s IMCIDName=$LISTGET($G(^User.BDPIMConfigD(ID)),4)
		S EXCONFIGID=$o(^User.BDPEXConfigI("UniqueTableName"," "_$zcvt(IMCTableName,"u"),0))
		IF EXCONFIGID=""
		{
			w "没找到对应的导出配置,"_IMCTableDesc_","_IMCTableName_","_EXCONFIGID,!
			s ^tmpcy("error",ID)="没找到对应的导出配置,"_IMCTableDesc_","_IMCTableName_","_EXCONFIGID
			continue
		}
		
		s EXCTableDesc=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),2) //描述
		s EXCTableName=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),3) //代码
		
		if (IMCTableDesc'=EXCTableDesc)||(IMCTableName'=EXCTableName)
		{
			w "代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_EXCTableDesc_","_EXCTableName_","_EXCONFIGID,!
			s ^tmpcy("error",ID)="代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_EXCTableDesc_","_EXCTableName_","_EXCONFIGID
			continue
		}
		
		s EXCIDName=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),4) //rowid
		if (EXCIDName'=IMCIDName)
		{
			w "ROWID名称不匹配,"_IMCTableDesc_","_IMCTableName_","_EXCONFIGID,!
			s ^tmpcy("error",ID)="ROWID名称不匹配,"_IMCTableDesc_","_IMCTableName_","_EXCONFIGID
			continue
		}
		
		s EXCXGlobal=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),5)
		s EXCIsChildTable=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),8)
		s EXCParRefGlobal=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),9)
		s obj=##class(User.BDPIMConfig).%OpenId(ID)
		
		s obj.EXCXGlobal=EXCXGlobal
		s obj.EXCIsChildTable=EXCIsChildTable
		s obj.EXCParRefGlobal=EXCParRefGlobal
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
		}
		else
		{
			w "保存失败!"_IMCTableDesc_" "_IMCTableName_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
			s ^tmpcy("error",ID)="保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			continue
		}
		
		
	
		s IMFieldChildSub=0
		for
		{
			s IMFieldChildSub=$o(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)) q:IMFieldChildSub=""
			
			s IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),3)
			s IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),2)
			s IMFCFieldType=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),4)
			
			S EXFIELDCONFIGSub=$o(^User.BDPEXFieldConfigI("FieldNameUniqueI"," "_$zcvt(IMFCFieldName,"u"),EXCONFIGID,0))
			IF EXFIELDCONFIGSub=""
			{
				//b ;1
				w "没找到对应的字段导出配置,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc,!
				s ^tmpcy("error",ID,IMFieldChildSub)="没找到对应的字段导出配置,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc
				continue
			}
			
  			s EXFCFieldName=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),3)   //字段描述
			s EXFCFieldDesc=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),2)  //字段代码
  
			if (IMFCFieldDesc'=EXFCFieldDesc)||(IMFCFieldName'=EXFCFieldName)
			{
				//b ;2
				w "代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_","_EXFCFieldDesc_","_EXFCFieldName,!
				s ^tmpcy("error",ID,IMFieldChildSub)="代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_","_EXFCFieldDesc_","_EXFCFieldName
				//continue
			}
			
			s EXFCFieldType=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),4)
			if (IMFCFieldType'=EXFCFieldType)&&(IMFCFieldType'="Y/N")
			{
				//w "类型不匹配,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_","_IMFCFieldType_","_EXFCFieldType,!
				s ^tmpcy("error4",ID,IMFieldChildSub)="类型不匹配,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_","_EXFCFieldDesc_","_EXFCFieldName
				//continue
			}
			
			s IMFCImport=$LISTGET($G(^User.BDPIMConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),10)  //是否导入
			s:IMFCImport="" IMFCImport="Y"
			s EXFCIDToCode=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),5)
			s EXFCGetField=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),6)
			
			s FIELDID=ID_"||"_IMFieldChildSub
			s FIELDobj=##class(User.BDPIMFieldConfig).%OpenId(FIELDID)
			
			s FIELDobj.EXFCIDToCode=EXFCIDToCode
			s FIELDobj.EXFCGetField=EXFCGetField
			s FIELDobj.EXFCFieldType=EXFCFieldType
			s:FIELDobj.EXFCFieldType="" FIELDobj.EXFCFieldType="String"
			s FIELDobj.IMFCExport=IMFCImport  //是否导出
			
			s sc=FIELDobj.%Save()
			d FIELDobj.%Close()
			If $$$ISOK(sc)
			{
				s id = FIELDobj.%Id()
			}
			else
			{
				w "保存失败!"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
				s ^tmpcy("error",ID,IMFieldChildSub)="保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				continue
			}
			
		}
	}
	q "1"
}

/// Function: 处理导入和导入配置，将导出配置增加到导入配置表里。
/// Creator:  chenying
/// CreateDate:2021-01-08
/// debug:   w ##class(web.DHCBL.BDP.ClassIOLiuqi).MultiUpdateIMConfigData()
ClassMethod MultiUpdateIMConfigData() As %String
{
	k ^tmpcy
	s ID=0
	for
	{
		s ID=$o(^User.BDPIMConfigD(ID)) q:ID="" 
		s IMCTableDesc=$LISTGET($G(^User.BDPIMConfigD(ID)),2)  //描述
		s IMCTableName=$LISTGET($G(^User.BDPIMConfigD(ID)),3)   //代码
		s IMCIDName=$LISTGET($G(^User.BDPIMConfigD(ID)),4)
		S EXCONFIGID=$o(^User.BDPEXConfigI("UniqueTableName"," "_$zcvt(IMCTableName,"u"),0))
		IF EXCONFIGID=""
		{
			w "没找到对应的导出配置,"_IMCTableDesc_","_IMCTableName_","_EXCONFIGID,!
			s ^tmpcy("error",ID)="没找到对应的导出配置,"_IMCTableDesc_","_IMCTableName_","_EXCONFIGID
			continue
		}
		
		s EXCTableDesc=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),2) //描述
		s EXCTableName=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),3) //代码
		
		if (IMCTableDesc'=EXCTableDesc)||(IMCTableName'=EXCTableName)
		{
			w "代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_EXCTableDesc_","_EXCTableName_","_EXCONFIGID,!
			s ^tmpcy("error",ID)="代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_EXCTableDesc_","_EXCTableName_","_EXCONFIGID
			continue
		}
		
		s EXCIDName=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),4) //rowid
		if (EXCIDName'=IMCIDName)
		{
			w "ROWID名称不匹配,"_IMCTableDesc_","_IMCTableName_","_EXCONFIGID,!
			s ^tmpcy("error",ID)="ROWID名称不匹配,"_IMCTableDesc_","_IMCTableName_","_EXCONFIGID
			continue
		}
		
		s EXCXGlobal=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),5)
		s EXCIsChildTable=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),8)
		s EXCParRefGlobal=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),9)
		s obj=##class(User.BDPIMConfig).%OpenId(ID)
		
		s obj.EXCXGlobal=EXCXGlobal
		s obj.EXCIsChildTable=EXCIsChildTable
		s obj.EXCParRefGlobal=EXCParRefGlobal
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
		}
		else
		{
			w "保存失败!"_IMCTableDesc_" "_IMCTableName_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
			s ^tmpcy("error",ID)="保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			continue
		}
		
		
	
		s IMFieldChildSub=0
		for
		{
			s IMFieldChildSub=$o(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)) q:IMFieldChildSub=""
			
			s IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),3)
			s IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),2)
			s IMFCFieldType=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),4)
			
			S EXFIELDCONFIGSub=$o(^User.BDPEXFieldConfigI("FieldNameUniqueI"," "_$zcvt(IMFCFieldName,"u"),EXCONFIGID,0))
			IF EXFIELDCONFIGSub=""
			{
				//b ;1
				w "没找到对应的字段导出配置,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc,!
				s ^tmpcy("error",ID,IMFieldChildSub)="没找到对应的字段导出配置,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc
				continue
			}
			
  			s EXFCFieldName=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),3)   //字段描述
			s EXFCFieldDesc=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),2)  //字段代码
  
			if (IMFCFieldDesc'=EXFCFieldDesc)||(IMFCFieldName'=EXFCFieldName)
			{
				//b ;2
				w "代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_","_EXFCFieldDesc_","_EXFCFieldName,!
				s ^tmpcy("error",ID,IMFieldChildSub)="代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_","_EXFCFieldDesc_","_EXFCFieldName
				//continue
			}
			
			s EXFCFieldType=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),4)
			if (IMFCFieldType'=EXFCFieldType)&&(IMFCFieldType'="Y/N")
			{
				//w "类型不匹配,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_","_IMFCFieldType_","_EXFCFieldType,!
				s ^tmpcy("error4",ID,IMFieldChildSub)="类型不匹配,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_","_EXFCFieldDesc_","_EXFCFieldName
				//continue
			}
			
			s IMFCImport=$LISTGET($G(^User.BDPIMConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),10)  //是否导入
			s:IMFCImport="" IMFCImport="Y"
			s EXFCIDToCode=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),5)
			s EXFCGetField=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),6)
			
			s FIELDID=ID_"||"_IMFieldChildSub
			s FIELDobj=##class(User.BDPIMFieldConfig).%OpenId(FIELDID)
			
			s FIELDobj.EXFCIDToCode=EXFCIDToCode
			s FIELDobj.EXFCGetField=EXFCGetField
			s FIELDobj.EXFCFieldType=EXFCFieldType
			s:FIELDobj.EXFCFieldType="" FIELDobj.EXFCFieldType="String"
			s FIELDobj.IMFCExport=IMFCImport  //是否导出
			
			s sc=FIELDobj.%Save()
			d FIELDobj.%Close()
			If $$$ISOK(sc)
			{
				s id = FIELDobj.%Id()
			}
			else
			{
				w "保存失败!"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
				s ^tmpcy("error",ID,IMFieldChildSub)="保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				continue
			}
			
		}
	}
	q "1"
}

}
