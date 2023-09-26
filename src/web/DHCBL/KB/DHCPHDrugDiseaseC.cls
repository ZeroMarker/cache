Import SQLUser

/// 名称: (禁忌症)病症业务表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-12-3
Class web.DHCBL.KB.DHCPHDrugDiseaseC Extends %RegisteredObject
{

/// Description：打开禁忌症数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).OpenIndData("1")
ClassMethod OpenConData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCPHDrugDiseaseC).%New()
	s eobj.PHDDInstDr=id
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTSex=pobjIns.PHINSTSex
	s eobj.PHINSTDocUseTips=pobjIns.PHINSTDocUseTips
	s eobj.PHINSTNote=pobjIns.PHINSTNote
	s eobj.PHINSTText=pobjIns.PHINSTText	
	d pobjIns.%Close()
	k pobjIns
	
	;病症,病症业务表^DHCPHDDIS，病症字典表^DHCPHDISL
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (eobj.PHDDDiseaDr'="")
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
			}
			else
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		}
		s eobj.PHDDType=$p($g(^DHCPHDDIS(PHDDRowId)),"^",6) 
	}
	//成分业务表^DHCPHINI，成分字典表^DHCPHEING
	s IngrRowId=$o(^DHCPHINI(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.PHINIIngrDr=""
	if (IngrRowId'="")
	{
		s pobjIngr = ##class(User.DHCPHIngrItm).%OpenId(IngrRowId)
		if $IsObject(pobjIngr.PHINIIngrDr){
			s eobj.PHINIIngrDr =pobjIngr.PHINIIngrDr.%Id() 
		}
	}
	
	/*s PHINIRowId=0
	for 
	{
		s PHINIRowId=$o(^DHCPHINI(0,"Inst",id,PHINIRowId)) q:PHINIRowId=""
		s IngrDr=$p($g(^DHCPHINI(PHINIRowId)),"^",2)
		if (IngrDr'="")
		{
			if (eobj.PHINIIngrDr'="")
			{
				s eobj.PHINIIngrDr=$p($g(^DHCPHEING(IngrDr)),"^",2)_","_eobj.PHINIIngrDr  
			}
			else
			{
				s eobj.PHINIIngrDr=$p($g(^DHCPHEING(IngrDr)),"^",2)
			}
		}
	}*/
	//获取既往史(多选)既往史业务表^DHCLIBDISHISI，既往史字典表^DHCDISHISF
	s LDHRowId=0
	for
	{
		s LDHRowId=$o(^DHCLIBDISHISI("0","Inst",id,LDHRowId)) q:LDHRowId=""	
		s DhDr=$p($g(^DHCLIBDISHISI(LDHRowId)),"^",2)  //病症指针		
		if (DhDr'="")
		{
			if (eobj.LDHDhDr'="")
			{
				s eobj.LDHDhDr=$p($g(^DHCDISHISF(DhDr)),"^",2)_","_eobj.LDHDhDr
			}
			else
			{
				s eobj.LDHDhDr=$p($g(^DHCDISHISF(DhDr)),"^",2)
			}
		}			
	}
		
	;特殊人群
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",eobj.PHDDInstDr,SPEPIRowId)) q:SPEPIRowId=""
		//s eobj.SpecialPopu=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)_"^"_eobj.SpecialPopu	
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		s:SPEPISpecDr'="" eobj.SpecialPopu=$p(^DHCSPEP(SPEPISpecDr),"^",2)_","_eobj.SpecialPopu	
	}

	//通过索引获取年龄业务表的RowId——PDARowId
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.PDAAgeDr=""
	if (PDARowId'="")
	{
		s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(pobjAge.PDAAgeDr)
		{
			s eobj.PDAAgeDr =pobjAge.PDAAgeDr.%Id() 
		}
		s eobj.PDAMaxVal=pobjAge.PDAMaxVal
		s eobj.PDAMinVal=pobjAge.PDAMinVal
		if $IsObject(pobjAge.PDAUomDr)
		{
			s eobj.PDAUomDr = pobjAge.PDAUomDr.%Id() 
		}
		d pobjAge.%Close()
		k pobjAge
	}	
	//通过索引获取过敏史业务表的RowId——LALCRowId
	s LALCRowId=$o(^DHCLIBALLI(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.LALCAllergyDr=""
	if (LALCRowId'="")
	{
		s pobjAgy = ##class(User.DHCLibAllergyItm).%OpenId(LALCRowId)
		if $IsObject(pobjAgy.LALCAllergyDr)
		{
			s eobj.LALCAllergyDr =pobjAgy.LALCAllergyDr.%Id() 
		}
		d pobjAgy.%Close()
		k pobjAgy
		
	}

	//通过索引获取生理参数业务表DHC_PhysiologyVal的RowId——PHYVRowId
	s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.PHYVFeildDr=""
	if (PHYVRowId'="")
	{
		s pobjPhy = ##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
		if $IsObject(pobjPhy.PHYVFeildDr)
		{
			s eobj.PHYVFeildDr =pobjPhy.PHYVFeildDr.%Id() 
		}
		s eobj.PHYVMinVal=pobjPhy.PHYVMinVal
		s eobj.PHYVMaxVal=pobjPhy.PHYVMaxVal
		d pobjPhy.%Close()
		k pobjPhy
	}
	;检验指标
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",eobj.PHDDInstDr,0))
	if (LABIRowId'="")
	{
		s objlab = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
		if $IsObject(objlab.LABILabDr)
		{
			s eobj.LABILabDr = objlab.LABILabDr.%Id()
		}
		s eobj.LABIMinVal=objlab.LABIMinVal
		s eobj.LABIMaxVal=objlab.LABIMaxVal
		s eobj.LABIRelation=objlab.LABIRelation
		if $IsObject(objlab.LABIUomDr)
		{
			s eobj.LABIUomDr = objlab.LABIUomDr.%Id()
		}
		
	}
	;治疗手术
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHCU(0,"Inst",id,RowId)) q:RowId=""
		s PDCUKeyWordDr=$p(^DHCPHCU(RowId),"^",2)
		if (PDCUKeyWordDr'="") 
		{
			if (eobj.PDCUKeyWordDr'="")
			{
				s eobj.PDCUKeyWordDr = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)_","_eobj.PDCUKeyWordDr
			}
			else
			{
				s eobj.PDCUKeyWordDr = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
	;症状
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHSYM(0,"Inst",id,RowId)) q:RowId=""
		s PSYMKeyWordDr=$p(^DHCPHSYM(RowId),"^",2)
		if (PSYMKeyWordDr'="") 
		{
			if (eobj.PSYMKeyWordDr'="")
			{
				s eobj.PSYMKeyWordDr = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)_","_eobj.PSYMKeyWordDr
			}
			else
			{
				s eobj.PSYMKeyWordDr = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
		} 
	}
	
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存禁忌症
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCPHDrugDiseaseC 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).SaveIndData()
ClassMethod SaveConData(eobj As web.Entity.KB.DHCPHDrugDiseaseC) As %String
{
	s result=""
	s Insid =""
	if $IsObject(eobj)
	{
		//开始保存到主索引表
		Ts					   				
			s objIns=##class(User.DHCPHInstructions).%New()							
			s objIns.PHINSTMode=eobj.PHINSTMode
			s objIns.PHINSTSex=eobj.PHINSTSex
			s objIns.PHINSTDocUseTips=eobj.PHINSTDocUseTips
			s objIns.PHINSTNote=eobj.PHINSTNote
			s objIns.PHINSTText=eobj.PHINSTText
			
			//主索引表必填项
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Contr","U"),0))
			s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("DRUG","U"),0))	
			d objIns.PHINSTTypeDrSetObjectId(eobj.PHINSTTypeDr)		
			s objIns.PHINSTOrderNum=eobj.PHINSTOrderNum
			//d objIns.PHINSTGenDrSetObjectId(eobj.PHINSTGenDr)
			s objIns.PHINSTGenDr=eobj.PHINSTGenDr
			s objIns.PHINSTPointerDr=eobj.PHINSTPointerDr
			s objIns.PHINSTPointerType=eobj.PHINSTPointerType	
			d objIns.PHINSTLibDrSetObjectId(eobj.PHINSTLibDr)		
			s objIns.PHINSTActiveFlag=eobj.PHINSTActiveFlag
			s objIns.PHINSTSysFlag=eobj.PHINSTSysFlag
			
			s scIns=objIns.%Save()	
			d objIns.%Close()
			If $$$ISOK(scIns)
			{
				s Insid = objIns.%Id()
			}
			else
			{
				s result ="false"
			}
			if (Insid'="")
			{
				//开始保存到病症业务表
				s args=eobj.PHDDDiseaDr
				if (args'="")
				{
					s argsLen=$Length(args,",")
					s PHDDDiseaDrs=""
					for i=1:1:argsLen
					{                 
						s eobj.PHDDDiseaDr=$p(args,",",i)
						s obj=##class(User.DHCPHDrugDisease).%New()				
						s eobj.PHDDInstDr=Insid
						d obj.PHDDInstDrSetObjectId(eobj.PHDDInstDr)
						s eobj.PHDDMode="C"
						s obj.PHDDMode = eobj.PHDDMode 
						s obj.PHDDType=eobj.PHDDType         
						d obj.PHDDDiseaDrSetObjectId(eobj.PHDDDiseaDr)	
						s PHDISLDiseaDesc=$p($g(^DHCPHDISL(eobj.PHDDDiseaDr)),"^",2) //病症描述
						s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
						s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc			
						s scDis=obj.%Save()
						d obj.%Close()
						if $$$ISOK(scDis)
						{
							s id=obj.%Id()			
						}
						else
						{
							s result ="false"
						}
					}
					s eobj.PHDDDiseaDrs=PHDDDiseaDrs
				}
				elseif(eobj.PHDDType'=""){
					s obj=##class(User.DHCPHDrugDisease).%New()	
					s eobj.PHDDInstDr=Insid
					d obj.PHDDInstDrSetObjectId(eobj.PHDDInstDr)			
					s eobj.PHDDMode="C"
					s obj.PHDDMode = eobj.PHDDMode 
					s obj.PHDDType=eobj.PHDDType         		
					s scDis=obj.%Save()
					d obj.%Close()
					if $$$ISOK(scDis)
					{
						s id=obj.%Id()			
					}
					else
					{
						s result ="false"
					}
				}
				
				//开始保存到治疗手术业务表
				s args=eobj.PDCUKeyWordDr
				if (args'="")
				{
					s argsLen=$Length(args,",")
					s PDCUKeyWordDrs=""
					for i=1:1:argsLen
					{
	                  
						s eobj.PDCUKeyWordDr=$p(args,",",i)
						s obj=##class(User.DHCPHCure).%New()				
						d obj.PDCUInstDrSetObjectId(Insid)        
						d obj.PDCUKeyWordDrSetObjectId(eobj.PDCUKeyWordDr)
						s PHKWDesc=$p($g(^DHCPHKW(eobj.PDCUKeyWordDr)),"^",2) //治疗手术
				        s:PDCUKeyWordDrs'="" PDCUKeyWordDrs=PDCUKeyWordDrs_"、"_PHKWDesc	
				        s:PDCUKeyWordDrs="" PDCUKeyWordDrs=PHKWDesc				
						s scPDCU=obj.%Save()
						d obj.%Close()
						if $$$ISOK(scPDCU)
						{
							s PDCUid=obj.%Id()
						}
						else
						{		
							s result ="false"
						}
					}
					s eobj.PDCUKeyWordDrs=PDCUKeyWordDrs
				}
		
				//开始保存到症状业务表
				s args=eobj.PSYMKeyWordDr
				if (args'="")
				{
					s argsLen=$Length(args,",")
					s PSYMKeyWordDrs=""
					for i=1:1:argsLen
					{
	                  
						s eobj.PSYMKeyWordDr=$p(args,",",i)
						s obj=##class(User.DHCPHSymptomBus).%New()				
						d obj.PSYMInstDrSetObjectId(Insid)        
						d obj.PSYMKeyWordDrSetObjectId(eobj.PSYMKeyWordDr)
						
						s PHKWDesc=$p($g(^DHCPHKW(eobj.PSYMKeyWordDr)),"^",2) //症状业务
						s:PSYMKeyWordDrs'="" PSYMKeyWordDrs=PSYMKeyWordDrs_"、"_PHKWDesc	
						s:PSYMKeyWordDrs="" PSYMKeyWordDrs=PHKWDesc				
						s scPSYM=obj.%Save()
						d obj.%Close()
						if $$$ISOK(scPSYM)
						{
							s PSYMid=obj.%Id()
						}
						else
						{
							s result ="false"
						}
					}
					s eobj.PSYMKeyWordDrs=PSYMKeyWordDrs
				}
				//开始保存到特殊人群业务表
				s argPopu=eobj.SpecialPopu
				if (argPopu'="")
				{
					s popuLen=$Length(argPopu,",")
					s SPEPISpecDrs=""
					for i=1:1:popuLen
					{
						s eobj.SpecialPopu=$p(argPopu,",",i)
						s popuobj = ##class(User.DHCLibSpecPopuItm).%New() 
						d popuobj.SPEPIInstDrSetObjectId(Insid)
						d popuobj.SPEPISpecDrSetObjectId(eobj.SpecialPopu)
						
						s SPEDesc=$p($g(^DHCPHBTGE(eobj.SpecialPopu)),"^",2) //特殊人群描述	
						s:SPEPISpecDrs'="" SPEPISpecDrs=SPEPISpecDrs_"、"_SPEDesc
						s:SPEPISpecDrs="" SPEPISpecDrs=SPEDesc

						s scPopu=popuobj.%Save()
		
						d popuobj.%Close()
						if $$$ISOK(scPopu)
						{
	
							s popuId=popuobj.%Id()			
						}
						else
						{
							s result ="false"
						}
					}
					s eobj.SPEPISpecDrs=SPEPISpecDrs
				}
				//开始保存到年龄业务表
				s objAge=##class(User.DHCPHDiseaseAge).%New()
				d objAge.PDAInstDrSetObjectId(Insid)
				d objAge.PDAAgeDrSetObjectId(eobj.PDAAgeDr)
				s objAge.PDAMinVal=eobj.PDAMinVal
				s objAge.PDAMaxVal=eobj.PDAMaxVal
				d objAge.PDAUomDrSetObjectId(eobj.PDAUomDr)				
				s scAge=objAge.%Save()
				d objAge.%Close()
				if $$$ISOK(scAge)
				{
					s ageId=objAge.%Id()
				}
				else
				{
					s result ="false"
				}
			//开始保存到过敏史业务表
				s objAgy=##class(User.DHCLibAllergyItm).%New()
				d objAgy.LALCInstDrSetObjectId(Insid)
				d objAgy.LALCAllergyDrSetObjectId(eobj.LALCAllergyDr)
				
				s scAgy=objAgy.%Save()
	
				d objAgy.%Close()
				if $$$ISOK(scAgy)
				{
					s agyId=objAgy.%Id()
				}
				else
				{
					s result ="false"
				}

		
		
			//开始保存到成分业务表
				s objItm=##class(User.DHCPHIngrItm).%New()
				d objItm.PHINIInstDrSetObjectId(Insid)
				d objItm.PHINIIngrDrSetObjectId(eobj.PHINIIngrDr)
					
				s scItm=objItm.%Save()

				d objItm.%Close()
				if $$$ISOK(scItm)
				{
					s itmId=objItm.%Id()
				}
				else
				{
					s result ="false"
				}
			//开始保存到生理参数业务表
				s objPhy=##class(User.DHCPhysiologyVal).%New()
				d objPhy.PHYVInstDrSetObjectId(Insid)
				d objPhy.PHYVFeildDrSetObjectId(eobj.PHYVFeildDr)
				s objPhy.PHYVMinVal=eobj.PHYVMinVal
				s objPhy.PHYVMaxVal=eobj.PHYVMaxVal
						
				s scPhy=objPhy.%Save()
	
				d objPhy.%Close()
				if $$$ISOK(scPhy)
				{

					s phyId=objPhy.%Id()
				}
				else
				{
					s result ="false"
				}
			
			
				//开始保存到检验指标业务表
				s labobj = ##class(User.DHCLibLabItm).%New() 
				;检验指标
				d:eobj.LABILabDr'="" labobj.LABILabDrSetObjectId(eobj.LABILabDr)
				s labobj.LABIMinVal=eobj.LABIMinVal
				s labobj.LABIMaxVal=eobj.LABIMaxVal
				s labobj.LABIRelation=eobj.LABIRelation
				d:eobj.LABIUomDr'="" labobj.LABIUomDrSetObjectId(eobj.LABIUomDr)
				d labobj.LABIInstDrSetObjectId(Insid)
				
			
				s labsc=labobj.%Save()
				d labobj.%Close()
				If $$$ISOK(labsc){ 	
					s labid = labobj.%Id()
					s:eobj.LABILabDr'="" $p(^DHCPHEGEN(eobj.LABILabDr),"^",9)="Y" //设置检验项目通用名数据池标识
				}else{	
					s result ="false"
				}
		
				//开始保存到既往史业务表
				s argsDH=eobj.LDHDhDr
				s DHlogJson="LDHDhDrs:"""""
				if (argsDH'="")
				{
					s argsLenDH=$Length(argsDH,",")
					s LDHDhDrs=""
					for i=1:1:argsLenDH
					{                 
						s eobj.LDHDhDr=$p(argsDH,",",i)
						s obj=##class(User.DHCLibDisHistoryItm).%New()				
						d obj.LDHInstDrSetObjectId(Insid)     
						d obj.LDHDhDrSetObjectId(eobj.LDHDhDr)	
						s DHIDesc=$p($g(^DHCDISHISF(eobj.LDHDhDr)),"^",2) //既往史描述
						s:LDHDhDrs'="" LDHDhDrs=LDHDhDrs_"、"_DHIDesc	
						s:LDHDhDrs="" LDHDhDrs=DHIDesc
			
						s scDH=obj.%Save()
						d obj.%Close()
						if $$$ISOK(scDH)
						{
							s id=obj.%Id()
						}
						else
						{
							s result ="false"
						}
					}
					s eobj.LDHDhDrs=LDHDhDrs
				}
				
			}
			else
			{
				s result ="false"
			}
			
			
			if (result["false")
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败'}"	
			}
			else
			{
				
				Tc
				s result = "{success:'true',id:'"_Insid_"'}" //返回RowId
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-禁忌证",Insid,eobj.PHINSTText,"A",eobj)
			}
			
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改禁忌症
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCPHDrugDiseaseC 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).SaveIndData()
ClassMethod UpdateConData(eobj As web.Entity.KB.DHCPHDrugDiseaseC) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		Ts
		//日志
		s bobj = ##class(web.Entity.KB.DHCPHDrugDiseaseC).%New()
		
		s PHDDInstDr=eobj.PHDDInstDr
		//修改病症业务表(先删除所有的病症)
		s OPHDDDiseaDrs="",OPHDDType=""
		s PHDDRowId=0
		for
		{
			s PHDDRowId=$o(^DHCPHDDIS("0","Inst",PHDDInstDr,PHDDRowId)) q:PHDDRowId=""
			s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
			s OPHDDType=$p($g(^DHCPHDDIS(PHDDRowId)),"^",6) //禁忌类型
			s PHDISLDiseaDesc=""
			s:PHDDDiseaDr'="" PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
			s:OPHDDDiseaDrs'="" OPHDDDiseaDrs=OPHDDDiseaDrs_"、"_PHDISLDiseaDesc	
			s:OPHDDDiseaDrs="" OPHDDDiseaDrs=PHDISLDiseaDesc
			s scdrug=##class(User.DHCPHDrugDisease).%DeleteId(PHDDRowId)
		}
		s bobj.PHDDMode="C"
		s bobj.PHDDDiseaDrs=OPHDDDiseaDrs
		s bobj.PHDDType=OPHDDType
		
		 //病症多选
		s args=eobj.PHDDDiseaDr
		if (args'="")
		{
			s argsLen=$Length(args,",")
			s PHDDDiseaDrs=""
			for i=1:1:argsLen
			{               
				s eobj.PHDDDiseaDr=$p(args,",",i)
				s obj=##class(User.DHCPHDrugDisease).%New()				
				s eobj.PHDDInstDr=PHDDInstDr
				d obj.PHDDInstDrSetObjectId(eobj.PHDDInstDr)
				s eobj.PHDDMode="C"
				s obj.PHDDMode = eobj.PHDDMode  
				s obj.PHDDType=eobj.PHDDType        
				d obj.PHDDDiseaDrSetObjectId(eobj.PHDDDiseaDr)
				s PHDISLDiseaDesc=$p($g(^DHCPHDISL(eobj.PHDDDiseaDr)),"^",2) //病症描述	
				s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc
				s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc				
				s scDis=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scDis)
				{
					s id=obj.%Id()
				}
				else
				{
					s result ="false"
				}
			}
			s eobj.PHDDDiseaDrs=PHDDDiseaDrs	
		}
		elseif(eobj.PHDDType'=""){
			s obj=##class(User.DHCPHDrugDisease).%New()	
			s eobj.PHDDInstDr=PHDDInstDr
			d obj.PHDDInstDrSetObjectId(eobj.PHDDInstDr)			
			s eobj.PHDDMode="C"
			s obj.PHDDMode = eobj.PHDDMode 
			s obj.PHDDType=eobj.PHDDType         		
			s scDis=obj.%Save()
			d obj.%Close()
			if $$$ISOK(scDis)
			{
				s id=obj.%Id()			
			}
			else
			{
				s result ="false"
			}
			s DislogJson="PHDDMode:"_$C(34)_eobj.PHDDMode_$C(34)_",PHDDDiseaDrs:"""",PHDDType:"_$C(34)_eobj.PHDDType_$C(34)	
		}
		//修改治疗手术业务表(先删除所有的治疗手术)
		s RowId=0
		s OPDCUKeyWordDrs=""
		for
		{
			s RowId=$o(^DHCPHCU("0","Inst",PHDDInstDr,RowId)) q:RowId=""
			s PDCUKeyWordDr=$p($g(^DHCPHCU(RowId)),"^",2) //手术DR
			s PHKWDesc=$p($g(^DHCPHKW(PDCUKeyWordDr)),"^",2) //治疗手术
			s:OPDCUKeyWordDrs'="" OPDCUKeyWordDrs=OPDCUKeyWordDrs_"、"_PHKWDesc	
			s:OPDCUKeyWordDrs="" OPDCUKeyWordDrs=PHKWDesc
			s scdcu=##class(User.DHCPHCure).%DeleteId(RowId)
		}
		s bobj.PDCUKeyWordDrs=OPDCUKeyWordDrs
		//开始保存到治疗手术业务表
		s args=eobj.PDCUKeyWordDr
		if (args'="")
		{
			s argsLen=$Length(args,",")
			s PDCUKeyWordDrs=""
			for i=1:1:argsLen
			{
	                  
				s eobj.PDCUKeyWordDr=$p(args,",",i)
				s obj=##class(User.DHCPHCure).%New()				
				d obj.PDCUInstDrSetObjectId(PHDDInstDr)        
				d obj.PDCUKeyWordDrSetObjectId(eobj.PDCUKeyWordDr)
				s PHKWDesc=$p($g(^DHCPHKW(eobj.PDCUKeyWordDr)),"^",2) //治疗手术
				s:PDCUKeyWordDrs'="" PDCUKeyWordDrs=PDCUKeyWordDrs_"、"_PHKWDesc	
				s:PDCUKeyWordDrs="" PDCUKeyWordDrs=PHKWDesc				
				s scPDCU=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scPDCU)
				{
					s PDCUid=obj.%Id()
				}
				else
				{		
					s result ="false"
				}
			}
			s eobj.PDCUKeyWordDrs=PDCUKeyWordDrs
		}
		
		//修改症状业务表(先删除所有的症状)
		s OPSYMKeyWordDrs=""
		s RowId=0
		for
		{
			s RowId=$o(^DHCPHSYM("0","Inst",PHDDInstDr,RowId)) q:RowId=""
			s PSYMKeyWordDr=$p($g(^DHCPHSYM(RowId)),"^",2) //症状DR
			s PHKWDesc=$p($g(^DHCPHKW(PSYMKeyWordDr)),"^",2) //症状业务
			s:OPSYMKeyWordDrs'="" OPSYMKeyWordDrs=OPSYMKeyWordDrs_"、"_PHKWDesc	
			s:OPSYMKeyWordDrs="" OPSYMKeyWordDrs=PHKWDesc
			s scsym=##class(User.DHCPHSymptomBus).%DeleteId(RowId)
		}
		s bobj.PSYMKeyWordDrs=OPSYMKeyWordDrs
		
		//开始保存到症状业务表
		s args=eobj.PSYMKeyWordDr
		s PSYMlogJson="PSYMKeyWordDrs:"""""
		if (args'="")
		{
			s argsLen=$Length(args,",")
			s PSYMKeyWordDrs=""
			for i=1:1:argsLen
			{
	                  
				s eobj.PSYMKeyWordDr=$p(args,",",i)
				s obj=##class(User.DHCPHSymptomBus).%New()				
				d obj.PSYMInstDrSetObjectId(PHDDInstDr)        
				d obj.PSYMKeyWordDrSetObjectId(eobj.PSYMKeyWordDr)
				s PHKWDesc=$p($g(^DHCPHKW(eobj.PSYMKeyWordDr)),"^",2) //症状业务
				s:PSYMKeyWordDrs'="" PSYMKeyWordDrs=PSYMKeyWordDrs_"、"_PHKWDesc	
				s:PSYMKeyWordDrs="" PSYMKeyWordDrs=PHKWDesc				
				s scPSYM=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scPSYM)
				{
					s PSYMid=obj.%Id()
				}
				else
				{
					s result ="false"
				}
			}
			s eobj.PSYMKeyWordDrs=PSYMKeyWordDrs
		}
	   //修改特殊人群业务表(先删除)
		s SPEPIRowId=0
		s OSPEPISpecDrs=""
		for
		{
			s SPEPIRowId=$o(^DHCLIBSPEPI("0","Inst",PHDDInstDr,SPEPIRowId)) q:SPEPIRowId=""
			s SPEPISpecDr=$p($g(^DHCLIBSPEPI(SPEPIRowId)),"^",2) //特殊人群DR
			s SPEDesc=$p($g(^DHCPHBTGE(SPEPISpecDr)),"^",2) //特殊人群描述
			s:OSPEPISpecDrs'="" OSPEPISpecDrs=OSPEPISpecDrs_"、"_SPEDesc	
			s:OSPEPISpecDrs="" OSPEPISpecDrs=SPEDesc
			s scPopu=##class(User.DHCLibSpecPopuItm).%DeleteId(SPEPIRowId)
		}
		s bobj.SPEPISpecDrs=OSPEPISpecDrs
		
		//开始保存到特殊人群业务表
		s argPopu=eobj.SpecialPopu
		if (argPopu'="")
		{
			s popuLen=$Length(argPopu,",")
			s SPEPISpecDrs=""
			for i=1:1:popuLen
			{
				s eobj.SpecialPopu=$p(argPopu,",",i)
				s popuobj = ##class(User.DHCLibSpecPopuItm).%New() 
				d popuobj.SPEPIInstDrSetObjectId(PHDDInstDr)
				d popuobj.SPEPISpecDrSetObjectId(eobj.SpecialPopu)
				s SPEDesc=$p($g(^DHCPHBTGE(eobj.SpecialPopu)),"^",2) //特殊人群描述	
				s:SPEPISpecDrs'="" SPEPISpecDrs=SPEPISpecDrs_"、"_SPEDesc
				s:SPEPISpecDrs="" SPEPISpecDrs=SPEDesc			
				s scPopu=popuobj.%Save()
		
				d popuobj.%Close()
				if $$$ISOK(scPopu)
				{
					s popuId=popuobj.%Id()
				}
				else
				{
					s result ="false"
				}
			}
			s eobj.SPEPISpecDrs=SPEPISpecDrs
		}
		//修改主索引表		
		s objIns=##class(User.DHCPHInstructions).%OpenId(PHDDInstDr)
		
		s bobj.PHINSTMode=objIns.PHINSTMode
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr = objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum	
		s bobj.PHINSTGenDr = objIns.PHINSTGenDr
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr = objIns.PHINSTLibDr.%Id()
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag
		s bobj.PHINSTText=objIns.PHINSTText
		s bobj.PHINSTSex=objIns.PHINSTSex
		s bobj.PHINSTDocUseTips=objIns.PHINSTDocUseTips
		s bobj.PHINSTNote=objIns.PHINSTNote
		
		s objIns.PHINSTMode=eobj.PHINSTMode
		s objIns.PHINSTSex=eobj.PHINSTSex
		s objIns.PHINSTDocUseTips=eobj.PHINSTDocUseTips
		s objIns.PHINSTNote=eobj.PHINSTNote
		s objIns.PHINSTText=eobj.PHINSTText	
		
		s scIns=objIns.%Save()	
		d objIns.%Close()
		If $$$ISOK(scIns)
		{
			s Insid = objIns.%Id()

		}
		else
		{
			s result ="false"
		}
		
		//修改年龄业务表
		//通过索引获取年龄业务表的RowId——PDARowId
		s PDARowId=$o(^DHCPHDISAGE(0,"Inst",PHDDInstDr,0))
		if (PDARowId'="")
		{
			s objAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		  	s bobj.PDARowId=PDARowId
		  	s:objAge.PDAInstDr'="" bobj.PDAInstDr = objAge.PDAInstDr.%Id()
		  	s:objAge.PDAAgeDr'="" bobj.PDAAgeDr = objAge.PDAAgeDr.%Id()
		  	s bobj.PDAMinVal=objAge.PDAMinVal
		  	s bobj.PDAMaxVal=objAge.PDAMaxVal
		  	s:objAge.PDAUomDr'="" bobj.PDAUomDr = objAge.PDAUomDr.%Id()
		}
		else
		{
			s objAge = ##class(User.DHCPHDiseaseAge).%New()	
		}
		d objAge.PDAAgeDrSetObjectId(eobj.PDAAgeDr)
		s objAge.PDAMaxVal=eobj.PDAMaxVal
		s objAge.PDAMinVal=eobj.PDAMinVal
		d objAge.PDAUomDrSetObjectId(eobj.PDAUomDr)
		d objAge.PDAInstDrSetObjectId(PHDDInstDr)
		
		s scAge=objAge.%Save()
		d objAge.%Close()
	
		if $$$ISOK(scAge)
		{
			s ageId=objAge.%Id()
		}
		else
		{
			s result ="false"
		}
			
		//修改过敏史业务表、
		//通过索引获取过敏史业务表的RowId——LALCRowId
		s OAgylogJson="",AgylogJson=""
		s LALCRowId=$o(^DHCLIBALLI(0,"Inst",PHDDInstDr,0))
		if (LALCRowId'="")
		{
			s objAgy =##class(User.DHCLibAllergyItm).%OpenId(LALCRowId) 
			s:objAgy.LALCAllergyDr'="" bobj.LALCAllergyDr=objAgy.LALCAllergyDr.%Id()
		}
		else
		{
			s objAgy =##class(User.DHCLibAllergyItm).%New()	
		}
		
		d objAgy.LALCAllergyDrSetObjectId(eobj.LALCAllergyDr)
		d objAgy.LALCInstDrSetObjectId(eobj.PHDDInstDr)
			
		s scAgy=objAgy.%Save()
		d objAgy.%Close()
		if $$$ISOK(scAgy)
		{
			s agyId=objAgy.%Id()
		}
		else
		{
			s result ="false"
		}
	
		
		//修改成分业务表
		//通过索引获取成分业务表的RowId——LALCRowId
		s PHINIRowId=$o(^DHCPHINI(0,"Inst",PHDDInstDr,0))
		if (PHINIRowId'="")
		{
			s objItm =##class(User.DHCPHIngrItm).%OpenId(PHINIRowId)
			s:objItm.PHINIIngrDr'="" bobj.PHINIIngrDr=objItm.PHINIIngrDr.%Id()
		}
		else
		{
			s objItm =##class(User.DHCPHIngrItm).%New()	
		}
		
		d objItm.PHINIIngrDrSetObjectId(eobj.PHINIIngrDr)	
		d objItm.PHINIInstDrSetObjectId(eobj.PHDDInstDr)		
		s scItm=objItm.%Save()
		d objItm.%Close()
		if $$$ISOK(scItm)
		{
			s ItmId=objItm.%Id()
		}
		else
		{
			s result ="false"
		}
		

		
		//修改生理参数业务表		
		//通过索引获取生理参数业务表DHC_PhysiologyVal的RowId——PHYVRowId
		s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",PHDDInstDr,0))
		if (PHYVRowId'="")
		{
			s objPhy=##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
			s:objPhy.PHYVFeildDr'="" bobj.PHYVFeildDr=objPhy.PHYVFeildDr.%Id()
			s bobj.PHYVMinVal=objPhy.PHYVMinVal
			s bobj.PHYVMaxVal=objPhy.PHYVMaxVal
		}
		else
		{
			s objPhy=##class(User.DHCPhysiologyVal).%New()
		}
			
		d objPhy.PHYVFeildDrSetObjectId(eobj.PHYVFeildDr)
		s objPhy.PHYVMinVal=eobj.PHYVMinVal
		s objPhy.PHYVMaxVal=eobj.PHYVMaxVal	
		d objPhy.PHYVInstDrSetObjectId(PHDDInstDr)
								
		s scPhy=objPhy.%Save()		
		d objPhy.%Close()
		if $$$ISOK(scPhy)
		{
			s phyId=objPhy.%Id()
		}
		else
		{

			s result ="false"
		}				
	
		//检验指标
		s LABIRowId=$o(^DHCLIBLABI(0,"Inst",PHDDInstDr,0))
		if (LABIRowId'="")
		{
			s labobj = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)	
			s:labobj.LABILabDr'="" bobj.LABILabDr = labobj.LABILabDr.%Id()
			s bobj.LABIMinVal=labobj.LABIMinVal
			s bobj.LABIMaxVal=labobj.LABIMaxVal
			s bobj.LABIRelation=labobj.LABIRelation
			s:labobj.LABIUomDr'="" bobj.LABIUomDr = labobj.LABIUomDr.%Id()
		}
		else
		{
			s labobj = ##class(User.DHCLibLabItm).%New()	
		}
		
		d:eobj.LABILabDr'="" labobj.LABILabDrSetObjectId(eobj.LABILabDr)
		s labobj.LABIMinVal=eobj.LABIMinVal
		s labobj.LABIMaxVal=eobj.LABIMaxVal
		s labobj.LABIRelation=eobj.LABIRelation
		d:eobj.LABIUomDr'="" labobj.LABIUomDrSetObjectId(eobj.LABIUomDr)
		d labobj.LABIInstDrSetObjectId(PHDDInstDr)
			
		
		s labsc=labobj.%Save()
		d labobj.%Close()
		If $$$ISOK(labsc){ 	
			s labid = labobj.%Id()
			s:eobj.LABILabDr'="" $p(^DHCPHEGEN(eobj.LABILabDr),"^",9)="Y" //设置检验项目通用名数据池标识
		}else{	
			s result ="false"
		}
			
		//修改既往史业务表(先删除所有的既往史)
		s OLDHDhDrs=""
		s LDHRowId=0
		for
		{
			s LDHRowId=$o(^DHCLIBDISHISI("0","Inst",PHDDInstDr,LDHRowId)) q:LDHRowId=""
			s LDHDhDr=$p($g(^DHCLIBDISHISI(LDHRowId)),"^",2) //既往史DR
			s DHIDesc=$p($g(^DHCDISHISF(LDHDhDr)),"^",2) //既往史描述
			s:OLDHDhDrs'="" OLDHDhDrs=OLDHDhDrs_"、"_DHIDesc	
			s:OLDHDhDrs="" OLDHDhDrs=DHIDesc
			s scDH=##class(User.DHCLibDisHistoryItm).%DeleteId(LDHRowId)
		}
		s bobj.LDHDhDrs=OLDHDhDrs
		
		//开始保存到既往史业务表
		s argsDH=eobj.LDHDhDr
		if (argsDH'="")
		{
			s argsLenDH=$Length(argsDH,",")
			s LDHDhDrs=""
			for i=1:1:argsLenDH
			{                  
				s eobj.LDHDhDr=$p(argsDH,",",i)
				s obj=##class(User.DHCLibDisHistoryItm).%New()				
				d obj.LDHInstDrSetObjectId(PHDDInstDr)     
				d obj.LDHDhDrSetObjectId(eobj.LDHDhDr)
				s DHIDesc=$p($g(^DHCDISHISF(eobj.LDHDhDr)),"^",2) //既往史描述
				s:LDHDhDrs'="" LDHDhDrs=LDHDhDrs_"、"_DHIDesc	
				s:LDHDhDrs="" LDHDhDrs=DHIDesc				
				s scDH=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scDH)
				{
					s id=obj.%Id()
				}
				else
				{
					s result ="false"
				}
			}
			s eobj.LDHDhDrs=LDHDhDrs
		}
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
			
		}
		else
		{
			Tc
			s result = "{success:'true',id:'"_PHDDInstDr_"'}" //返回RowId
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-禁忌证",Insid,eobj.PHINSTText,"U",eobj,bobj)
			
		}
			
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：谷雪萍
/// CreatDate: 2014-12-4
/// Description：查询病症业务表内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugDiseaseC","GetList","")
Query GetListCon(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText")
{
}

ClassMethod GetListConExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Contr","U"),0))	
	s PHINSTRowId=0
	for
	{	
		s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""	
	    s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
		d OutputRow		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,PHINSTText)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListConClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListConExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListConFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListConExecute ]
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

/// Description:根据id删除 病症业务表
/// Table:User.DHCPHDrugDisease
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).DeleteConData("1")
ClassMethod DeleteConData(id As %String) As %String
{
		s result=""	
		s InstDr=id
		TS
		//日志
		s bobj=##class(web.Entity.KB.DHCPHDrugDiseaseC).%New()
		//删除病症字典表
		s PHDDRowId=0
		s PHDDDiseaDrs=""
		for
		{
			s PHDDRowId=$o(^DHCPHDDIS("0","Inst",InstDr,PHDDRowId)) q:PHDDRowId=""	
			s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
			s PHDISLDiseaDesc=""
			s:PHDDDiseaDr'="" PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
			s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
			s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc	
			s sc=##class(User.DHCPHDrugDisease).%DeleteId(PHDDRowId)
			if '$$$ISOK(sc)
			{
				s result ="false"
			}
		}
		s bobj.PHDDDiseaDrs=PHDDDiseaDrs
		s bobj.PHDDMode="C"
		
		//删除所有的治疗手术
		s RowId=0
		s PDCUKeyWordDrs=""
		for
		{
			s RowId=$o(^DHCPHCU("0","Inst",id,RowId)) q:RowId=""
			s PDCUKeyWordDr=$p($g(^DHCPHCU(RowId)),"^",2) //手术DR
			s PHKWDesc=$p($g(^DHCPHKW(PDCUKeyWordDr)),"^",2) //治疗手术
			s:PDCUKeyWordDrs'="" PDCUKeyWordDrs=PDCUKeyWordDrs_"、"_PHKWDesc	
			s:PDCUKeyWordDrs="" PDCUKeyWordDrs=PHKWDesc
			s scdcu=##class(User.DHCPHCure).%DeleteId(RowId)
			if '$$$ISOK(scdcu)
			{
				s result ="false"
			}
		}
		s bobj.PDCUKeyWordDrs=PDCUKeyWordDrs
		
		//删除所有的症状
		s RowId=0
		s PSYMKeyWordDrs=""
		for
		{
			s RowId=$o(^DHCPHSYM("0","Inst",id,RowId)) q:RowId=""
			s PSYMKeyWordDr=$p($g(^DHCPHSYM(RowId)),"^",2) //症状DR
			s PHKWDesc=$p($g(^DHCPHKW(PSYMKeyWordDr)),"^",2) //症状业务	
			s:PSYMKeyWordDrs'="" PSYMKeyWordDrs=PSYMKeyWordDrs_"、"_PHKWDesc
			s:PSYMKeyWordDrs="" PSYMKeyWordDrs=PHKWDesc
			s scsym=##class(User.DHCPHSymptomBus).%DeleteId(RowId)
			if '$$$ISOK(scsym)
			{
				s result ="false"
			}
		}
		s bobj.PSYMKeyWordDrs=PSYMKeyWordDrs
		
		//删除特殊人群业务表
		s SPEPIRowId=0
		s SPEPISpecDrs=""
		for
		{
			s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",InstDr,SPEPIRowId)) q:SPEPIRowId=""
			s SPEPISpecDr=$p($g(^DHCLIBSPEPI(SPEPIRowId)),"^",2) //特殊人群DR	
			s SPEDesc=$p($g(^DHCSPEP(SPEPISpecDr)),"^",2) //特殊人群描述
			s:SPEPISpecDrs'="" SPEPISpecDrs=SPEPISpecDrs_"、"_SPEDesc	
			s:SPEPISpecDrs="" SPEPISpecDrs=SPEDesc

			s scPopu=##class(User.DHCLibSpecPopuItm).%DeleteId(SPEPIRowId)
			if '$$$ISOK(scPopu)
			{
				s result ="false"
			}

		}
		s bobj.SPEPISpecDrs=SPEPISpecDrs
		
		//删除年龄业务表
		s PDARowId=$o(^DHCPHDISAGE("0","Inst",InstDr,0))
		if (PDARowId'="")
		{		
			s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			s:pobjAge.PDAAgeDr'="" bobj.PDAAgeDr=pobjAge.PDAAgeDr.%Id()

			if $IsObject(pobjAge.PDAInstDr)
			{
				s bobj.PHDDInstDr=pobjAge.PDAInstDr
			}
			s bobj.PDAMaxVal=pobjAge.PDAMaxVal
			s bobj.PDAMinVal=pobjAge.PDAMinVal
			s:pobjAge.PDAUomDr'="" bobj.PDAUomDr=pobjAge.PDAUomDr.%Id()
			
			s scAge=##class(User.DHCPHDiseaseAge).%DeleteId(PDARowId)
			if '$$$ISOK(scAge)
			{
				s result ="false"
			}
		}
		
		//删除过敏史业务表
		s LALCRowId=$o(^DHCLIBALLI(0,"Inst",InstDr,0))
		if (LALCRowId'="")
		{
			s pobjAgy = ##class(User.DHCLibAllergyItm).%OpenId(LALCRowId)
			
			s:pobjAgy.LALCAllergyDr'="" bobj.LALCAllergyDr=pobjAgy.LALCAllergyDr.%Id()

			if $IsObject(pobjAgy.LALCInstDr)
			{
				s bobj.PHDDInstDr=pobjAgy.LALCInstDr
			}
			
			
			s scAgy=##class(User.DHCLibAllergyItm).%DeleteId(LALCRowId)
			if '$$$ISOK(scAgy)
			{
				s result ="false"
			}

		}

		//删除成分业务表
		s PHINIRowId=$o(^DHCPHINI("0","Inst",InstDr,0))
		if (PHINIRowId'="")
		{
			s pobjItm = ##class(User.DHCPHIngrItm).%OpenId(PHINIRowId)
			
			s:pobjItm.PHINIIngrDr'="" bobj.PHINIIngrDr=pobjItm.PHINIIngrDr.%Id()

			if $IsObject(pobjItm.PHINIInstDr)
			{
				s bobj.PHDDInstDr=pobjItm.PHINIInstDr.%Id()
			}	
			s scItm=##class(User.DHCPHIngrItm).%DeleteId(PHINIRowId)
			if '$$$ISOK(scItm)
			{
				s result ="false"
			}
		}
		//删除生理参数业务表
		s PHYVRowId=$o(^DHCPHYVAL("0","Inst",InstDr,0))	
		if (PHYVRowId'="")
		{
			s pobjPhy = ##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
			
			s:pobjPhy.PHYVFeildDr'="" bobj.PHYVFeildDr=pobjPhy.PHYVFeildDr.%Id()
			s bobj.PHYVMinVal=pobjPhy.PHYVMinVal
			s bobj.PHYVMaxVal=pobjPhy.PHYVMaxVal
			if $IsObject(pobjPhy.PHYVInstDr)
			{
				s bobj.PHDDInstDr=pobjPhy.PHYVInstDr.%Id()
			}
			
			s scPhy=##class(User.DHCPhysiologyVal).%DeleteId(PHYVRowId)
			if '$$$ISOK(scPhy)
			{
				s result ="false"
			}

		}
		
		//检验指标2017-03-17
		s LABIRowId=$o(^DHCLIBLABI(0,"Inst",InstDr,0))
		if (LABIRowId'="") 
		{
			s labobj = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)	
			s:labobj.LABILabDr'="" bobj.LABILabDr = labobj.LABILabDr.%Id()
			s bobj.LABIMinVal=labobj.LABIMinVal
			s bobj.LABIMaxVal=labobj.LABIMaxVal
			s bobj.LABIRelation=labobj.LABIRelation
			s:labobj.LABIUomDr'="" bobj.LABIUomDr = labobj.LABIUomDr.%Id()
			
			s sclab=##class(User.DHCLibLabItm).%DeleteId(LABIRowId)
			if '$$$ISOK(sclab)
			{
				s result ="false"
			}

		}
		//删除既往史字典表
		s LDHDhDrs=""
		s LDHRowId=0
		for
		{
			s LDHRowId=$o(^DHCLIBDISHISI("0","Inst",InstDr,LDHRowId)) q:LDHRowId=""
			s LDHDhDr=$p($g(^DHCLIBDISHISI(LDHRowId)),"^",2) //既往史DR	
			s DHIDesc=$p($g(^DHCDISHISF(LDHDhDr)),"^",2) //既往史描述
			s:LDHDhDrs'="" LDHDhDrs=LDHDhDrs_"、"_DHIDesc	
			s:LDHDhDrs="" LDHDhDrs=DHIDesc
			s scDH=##class(User.DHCLibDisHistoryItm).%DeleteId(LDHRowId)
			if '$$$ISOK(scDH)
			{
				s result ="false"
			}

		}
		s bobj.LDHDhDrs=LDHDhDrs
		//删除主索引表		
		s objIns=##class(User.DHCPHInstructions).%OpenId(id)
		
		s bobj.PHINSTMode=objIns.PHINSTMode
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr = objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum	
		s bobj.PHINSTGenDr = objIns.PHINSTGenDr
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr = objIns.PHINSTLibDr.%Id()
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag
		s bobj.PHINSTText=objIns.PHINSTText
		s bobj.PHINSTSex=objIns.PHINSTSex
		s bobj.PHINSTDocUseTips=objIns.PHINSTDocUseTips
		s bobj.PHINSTNote=objIns.PHINSTNote
		
		s scInst=##class(User.DHCPHInstructions).%DeleteId(InstDr)
		if '$$$ISOK(scInst)
		{
			s result ="false"
		}

		if (result["false")
		{
			Trollback
			s result = "{success:'false',info:'删除失败！'}"
		}
		else
		{
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-禁忌证",id,bobj.PHINSTText,"D",bobj)
		
		}
		q result
}

/// Description：根据主索引的id获取禁忌症数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).GetConData("7")
ClassMethod GetConData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

/// Description：获取禁忌证中已选成分的串
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).GetIngrDr(67)
ClassMethod GetIngrDr(InstId As %String) As %String
{
	//成分业务表^DHCPHINI，成分字典表^DHCPHEING
 s str=""
 if (InstId'="")
 {
	s PHINIRowId=0
	for
	{
		s PHINIRowId=$o(^DHCPHINI(0,"Inst",InstId,PHINIRowId)) q:PHINIRowId=""
		s IngrDr=$p($g(^DHCPHINI(PHINIRowId)),"^",2) //成分DR
		s PHEINGCode=$p($g(^DHCPHEING(IngrDr)),"^",1) //成分代码 
		s str="<"_PHEINGCode_">^"_str
	}
 }
 q str
}

/// Description：查询未选成分字典的列表内容
/// Table：User.DHCPHExtIngr
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugDiseaseC","GetUnSelIngrList","","")
Query GetUnSelIngrList(InstId As %String, ingrStr As %String, desc As %String) As %Query(ROWSPEC = "PHEINGRowId,PHEINGCode,PHEINGDesc")
{
}

ClassMethod GetUnSelIngrListExecute(ByRef qHandle As %Binary, InstId As %String, ingrStr As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s selectStr = ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).GetIngrDr(InstId)
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s PHEINGRowId=0
	for  
	{	
			s PHEINGRowId=$o(^DHCPHEING(PHEINGRowId)) q:PHEINGRowId="" 
				s PHEINGCode=$p($g(^DHCPHEING(PHEINGRowId)),"^",1)  //代码
				s Code = "<"_PHEINGCode_">"
				s PHEINGDesc=$p($g(^DHCPHEING(PHEINGRowId)),"^",2)  //描述
				s PHEINGDescU=$ZCONVERT(PHEINGDesc,"U")
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHEINGDesc)
				if ('(selectStr[Code))&('(ingrStr[Code))&((PHEINGDescU[desc)||(PINYIN[desc)) //2016-08-09  
				{
					d OutputRowUnIngr
				}		

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUnIngr
    set Data=$lb(PHEINGRowId,PHEINGCode,PHEINGDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelIngrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelIngrListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnSelIngrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelIngrListExecute ]
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

/// Description：查询已选成分字典的列表内容
/// Table：User.DHCPHExtIngr
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugDiseaseC","GetIngrList","")
Query GetIngrList(InstId As %String) As %Query(ROWSPEC = "PHINIRowId,PHINIIngrDr,PHEINGCode,PHEINGDesc")
{
}

ClassMethod GetIngrListExecute(ByRef qHandle As %Binary, InstId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (InstId'="")
	{
		s PHINIRowId=0
		for  
		{	
			s PHINIRowId=$o(^DHCPHINI("0","Inst",InstId,PHINIRowId)) q:PHINIRowId="" 
			s PHINIIngrDr=$p($g(^DHCPHINI(PHINIRowId)),"^",2)
			s PHEINGCode="",PHEINGDesc=""
			if (PHINIIngrDr'="")
			{
				s PHEINGCode=$p($g(^DHCPHEING(PHINIIngrDr)),"^",1)  //代码
				s PHEINGDesc=$p($g(^DHCPHEING(PHINIIngrDr)),"^",2)  //描述
				d OutputRowIngr	
			}
		}

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowIngr
    set Data=$lb(PHINIRowId,PHINIIngrDr,PHEINGCode,PHEINGDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetIngrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIngrListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetIngrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIngrListExecute ]
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

/// Description:根据病症id删除成分
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).DeleteIngrData("")
ClassMethod DeleteIngrData(id As %String) As %String
{
	s return="",myInfo=""
	s sc=##class(User.DHCPHIngrItm).%DeleteId(id)
	if $$$ISOK(sc)
	{
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Description：获取禁忌证中已选既往史的串
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).GetDhDr()
ClassMethod GetDhDr(InstId As %String) As %String
{
	//既往史业务表^DHCLIBDISHISI，既往史字典表^DHCDISHISF
 s str=""
 if (InstId'="")
 {
	s LDHRowId=0
	for
	{
		s LDHRowId=$o(^DHCLIBDISHISI("0","Inst",InstId,LDHRowId)) q:LDHRowId=""
		s DhDr=$p($g(^DHCLIBDISHISI(LDHRowId)),"^",2)  
		s DHICode=$p($g(^DHCDISHISF(DhDr)),"^",1)
		s str="<"_DHICode_">^"_str
	}
 }
 q str
}

/// Description：查询未选既往史字典的列表内容
/// Table：User.DHCDisHistoryFeild
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugDiseaseC","GetUnSelDhList","","")
Query GetUnSelDhList(InstId As %String, dhStr As %String, desc As %String) As %Query(ROWSPEC = "DHIRowId,DHICode,DHIDesc")
{
}

ClassMethod GetUnSelDhListExecute(ByRef qHandle As %Binary, InstId As %String, dhStr As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s selectStr = ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).GetDhDr(InstId)
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s DHIRowId=0
		for  
		{	
			s DHIRowId=$o(^DHCDISHISF(DHIRowId)) q:DHIRowId="" 
			s DHICode=$p($g(^DHCDISHISF(DHIRowId)),"^",1)  //代码
			s Code = "<"_DHICode_">"
			s DHIDesc=$p($g(^DHCDISHISF(DHIRowId)),"^",2)  //描述
			s DHIActiveFlag=$p($g(^DHCDISHISF(DHIRowId)),"^",3)  //是否可用2018-02-07
			s DHIDescU=$ZCONVERT(DHIDesc,"U")
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DHIDesc)
			if ('(selectStr[Code))&('(dhStr[Code))&((DHIDescU[desc)||(PINYIN[desc)) &(DHIActiveFlag'="N") //2016-08-09   
			{
				d OutputRowUnDh
			}		

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUnDh
    set Data=$lb(DHIRowId,DHICode,DHIDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelDhListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelDhListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnSelDhListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelDhListExecute ]
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

/// Description：查询已选既往史字典的列表内容
/// Table：DHC_LibDisHistoryItm
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugDiseaseC","GetDhList","")
Query GetDhList(InstId As %String) As %Query(ROWSPEC = "LDHRowId,LDHDhDr,DHICode,DHIDesc")
{
}

ClassMethod GetDhListExecute(ByRef qHandle As %Binary, InstId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (InstId'="")
	{
		s LDHRowId=0
		for  
		{	
			s LDHRowId=$o(^DHCLIBDISHISI("0","Inst",InstId,LDHRowId)) q:LDHRowId=""
			s LDHDhDr=$p($g(^DHCLIBDISHISI(LDHRowId)),"^",2)
			s DHICode="",DHIDesc=""
			if (LDHDhDr'="")
			{
				s DHICode=$p($g(^DHCDISHISF(LDHDhDr)),"^",1)  //代码
				s DHIDesc=$p($g(^DHCDISHISF(LDHDhDr)),"^",2)  //描述
				d OutputRowDh	
			}
		}

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDh
    set Data=$lb(LDHRowId,LDHDhDr,DHICode,DHIDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDhListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDhListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDhListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDhListExecute ]
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

/// Description:根据病症id删除既往史
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).DeleteIngrData("")
ClassMethod DeleteDhData(id As %String) As %String
{
	s return="",myInfo=""
	s sc=##class(User.DHCLibDisHistoryItm).%DeleteId(id)
	if $$$ISOK(sc)
	{
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Description：成分描述
/// Input：ingrid
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).GetIngrText("9")
ClassMethod GetIngrText(ingrid As %String) As %String
{
	s PHINIIngrDesc=""
	s:ingrid'="" PHINIIngrDesc=$LISTGET($G(^User.DHCPHExtIngrD(ingrid)),3)
	q PHINIIngrDesc
}

}
