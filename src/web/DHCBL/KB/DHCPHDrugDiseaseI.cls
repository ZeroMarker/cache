Import SQLUser

/// 名称: 病症业务表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-12-3
Class web.DHCBL.KB.DHCPHDrugDiseaseI Extends %RegisteredObject
{

/// Description：打开适应证数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).OpenIndData("1")
ClassMethod OpenIndData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHDrugDiseaseI).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTSex=pobjIns.PHINSTSex
	s eobj.PHINSTDocUseTips=pobjIns.PHINSTDocUseTips
	s eobj.PHINSTNote=pobjIns.PHINSTNote
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	//通过索引获取年龄业务表的RowId——PDARowId
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",id,0))
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
	;病症
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
	;细菌
	s RowId=0
	for
	{
		s RowId=$o( ^DHCPHORGBUS(0,"Inst",id,RowId)) q:RowId=""
		s PHORGOrgDr=$p(^DHCPHORGBUS(RowId),"^",2)
		if (PHORGOrgDr'="") 
		{
			if (eobj.PHORGOrgDr'="")
			{
				s eobj.PHORGOrgDr = $p(^DHCPHBTORG(PHORGOrgDr),"^",2)_","_eobj.PHORGOrgDr
			}
			else
			{
				s eobj.PHORGOrgDr = $p(^DHCPHBTORG(PHORGOrgDr),"^",2)
			}
		} 
	}
	;菌属
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHGENUSBUS(0,"Inst",id,RowId)) q:RowId=""
		s PHGENGenusDr=$p(^DHCPHGENUSBUS(RowId),"^",2)
		if (PHGENGenusDr'="") 
		{
			if (eobj.PHGENGenusDr'="")
			{
				s eobj.PHGENGenusDr = $p(^DHCPHBTGE(PHGENGenusDr),"^",2)_","_eobj.PHGENGenusDr
			}
			else
			{
				s eobj.PHGENGenusDr = $p(^DHCPHBTGE(PHGENGenusDr),"^",2)
			}
		} 
	}
	;检验指标
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",id,0))
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
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存适应证
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCPHDrugDiseaseI 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).SaveIndData()
ClassMethod SaveIndData(eobj As web.Entity.KB.DHCPHDrugDiseaseI) As %String
{
	s result=""
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
		s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Indic","U"),0))
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
				s eobj.PHDDMode="I"
				s obj.PHDDMode = eobj.PHDDMode          
				d obj.PHDDDiseaDrSetObjectId(eobj.PHDDDiseaDr)
				s PHDISLDiseaDesc=$p($g(^DHCPHDISL(eobj.PHDDDiseaDr)),"^",2) //病症描述
				s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
				s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc			
				s scDis=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scDis)
				{
					s Disid=obj.%Id()
				}
				else
				{		
					s result ="false"
				}
			}
			s eobj.PHDDDiseaDrs=PHDDDiseaDrs
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
		
		//开始保存到细菌业务表
		s args=eobj.PHORGOrgDr
		if (args'="")
		{
			s argsLen=$Length(args,",")
			s PHORGOrgDrs=""
			for i=1:1:argsLen
			{
	                  
				s eobj.PHORGOrgDr=$p(args,",",i)
				s obj=##class(User.DHCPHOrganismBus).%New()				
				d obj.PHORGInstDrSetObjectId(Insid)        
				d obj.PHORGOrgDrSetObjectId(eobj.PHORGOrgDr)
				
				s BTODesc=$p($g(^DHCPHBTORG(eobj.PHORGOrgDr)),"^",2) //细菌描述	
				s:PHORGOrgDrs'="" PHORGOrgDrs=PHORGOrgDrs_"、"_BTODesc
				s:PHORGOrgDrs="" PHORGOrgDrs=BTODesc
								
				s scOrg=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scOrg)
				{
					s Orgid=obj.%Id()
				}
				else
				{
					s result ="false"
				}
			}
			s eobj.PHORGOrgDrs=PHORGOrgDrs
		}
		//开始保存到菌属业务表
		s args=eobj.PHGENGenusDr
		if (args'="")
		{
			s argsLen=$Length(args,",")
			s PHGENGenusDrs=""
			for i=1:1:argsLen
			{
	                  
				s eobj.PHGENGenusDr=$p(args,",",i)
				s obj=##class(User.DHCPHGenusBus).%New()				
				d obj.PHGENInstDrSetObjectId(Insid)        
				d obj.PHGENGenusDrSetObjectId(eobj.PHGENGenusDr)
				
				s BTGEDesc=$p($g(^DHCPHBTGE(eobj.PHGENGenusDr)),"^",2) //菌属描述
				s:PHGENGenusDrs'="" PHGENGenusDrs=PHGENGenusDrs_"、"_BTGEDesc	
				s:PHGENGenusDrs="" PHGENGenusDrs=BTGEDesc
				
				s scGenus=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scGenus)
				{
					s Genusid=obj.%Id()
				}
				else
				{
					s result ="false"
				}
			}
			s eobj.PHGENGenusDrs=PHGENGenusDrs
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
		
		//开始保存到检验指标业务表
		s labobj = ##class(User.DHCLibLabItm).%New() 
		;检验指标
		d:eobj.LABILabDr'="" labobj.LABILabDrSetObjectId(eobj.LABILabDr)
		s labobj.LABIMinVal=eobj.LABIMinVal
		s labobj.LABIMaxVal=eobj.LABIMaxVal
		d:eobj.LABIUomDr'="" labobj.LABIUomDrSetObjectId(eobj.LABIUomDr)
		s labobj.LABIRelation=eobj.LABIRelation
		d labobj.LABIInstDrSetObjectId(Insid)

		
		s labsc=labobj.%Save()
		d labobj.%Close()
		If $$$ISOK(labsc){ 	
			s labid = labobj.%Id()
			s:eobj.LABILabDr'="" $p(^DHCPHEGEN(eobj.LABILabDr),"^",9)="Y" //设置检验项目通用名数据池标识
		}else{	
			s result ="false"
		}
		
		
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"			}
		else
		{
			Tc
			s result = "{success:'true',id:'"_Insid_"'}" //返回RowId
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器适应证",Insid,eobj.PHINSTText,"A",eobj)
		}
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改适应证
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCPHDrugDiseaseI 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).SaveIndData()
ClassMethod UpdateIndData(eobj As web.Entity.KB.DHCPHDrugDiseaseI) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		TS
		//日志
		s bobj = ##class(web.Entity.KB.DHCPHDrugDiseaseI).%New()
		s PHDDInstDr=eobj.PHDDInstDr
		//修改病症业务表(先删除所有的病症)
		s OPHDDDiseaDrs=""
		s PHDDRowId=0
		for
		{
			s PHDDRowId=$o(^DHCPHDDIS("0","Inst",PHDDInstDr,PHDDRowId)) q:PHDDRowId=""
			s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
			s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
			s:OPHDDDiseaDrs'="" OPHDDDiseaDrs=OPHDDDiseaDrs_"、"_PHDISLDiseaDesc	
			s:OPHDDDiseaDrs="" OPHDDDiseaDrs=PHDISLDiseaDesc
			s scdrug=##class(User.DHCPHDrugDisease).%DeleteId(PHDDRowId)
		}
		s bobj.PHDDMode="I"
		s bobj.PHDDDiseaDrs=OPHDDDiseaDrs
		
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
				s eobj.PHDDMode="I"
				s obj.PHDDMode = eobj.PHDDMode          
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
		//修改治疗手术业务表(先删除所有的治疗手术)
		s OPDCUKeyWordDrs=""
		s RowId=0
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
		
		//修改细菌业务表(先删除所有的细菌)
		s OPHORGOrgDrs=""
		s RowId=0
		for
		{
			s RowId=$o(^DHCPHORGBUS("0","Inst",PHDDInstDr,RowId)) q:RowId=""
			s PHORGOrgDr=$p($g(^DHCPHORGBUS(RowId)),"^",2) //细菌DR
			s BTODesc=$p($g(^DHCPHBTORG(PHORGOrgDr)),"^",2) //细菌描述
			s:OPHORGOrgDrs'="" OPHORGOrgDrs=OPHORGOrgDrs_"、"_BTODesc	
			s:OPHORGOrgDrs="" OPHORGOrgDrs=BTODesc
			s scorg=##class(User.DHCPHOrganismBus).%DeleteId(RowId)
		}
		s bobj.PHORGOrgDrs=OPHORGOrgDrs
		
		//开始保存到细菌业务表
		s args=eobj.PHORGOrgDr
		if (args'="")
		{
			s PHORGOrgDrs=""
			s argsLen=$Length(args,",")
			for i=1:1:argsLen
			{
	                  
				s eobj.PHORGOrgDr=$p(args,",",i)
				s obj=##class(User.DHCPHOrganismBus).%New()				
				d obj.PHORGInstDrSetObjectId(PHDDInstDr)        
				d obj.PHORGOrgDrSetObjectId(eobj.PHORGOrgDr)
				s BTODesc=$p($g(^DHCPHBTORG(eobj.PHORGOrgDr)),"^",2) //细菌描述
				s:PHORGOrgDrs'="" PHORGOrgDrs=PHORGOrgDrs_"、"_BTODesc	
				s:PHORGOrgDrs="" PHORGOrgDrs=BTODesc
							
				s scOrg=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scOrg)
				{
					s Orgid=obj.%Id()
				}
				else
				{
					s result ="false"
				}
			}
			s eobj.PHORGOrgDrs=PHORGOrgDrs
		}
		//修改菌属业务表(先删除所有的菌属)
		s OPHGENGenusDrs=""
		s RowId=0
		for
		{
			s RowId=$o(^DHCPHGENUSBUS("0","Inst",PHDDInstDr,RowId)) q:RowId=""
			s PHGENGenusDr=$p($g(^DHCPHGENUSBUS(RowId)),"^",2) //菌属DR
			s BTGEDesc=$p($g(^DHCPHBTGE(PHGENGenusDr)),"^",2) //菌属描述
			s:OPHGENGenusDrs'="" OPHGENGenusDrs=OPHGENGenusDrs_"、"_BTGEDesc	
			s:OPHGENGenusDrs="" OPHGENGenusDrs=BTGEDesc
			s scgenus=##class(User.DHCPHGenusBus).%DeleteId(RowId)
		}
		s bobj.PHGENGenusDrs=OPHGENGenusDrs
		
		//开始保存到菌属业务表
		s args=eobj.PHGENGenusDr
		if (args'="")
		{
			s argsLen=$Length(args,",")
			s PHGENGenusDrs=""
			for i=1:1:argsLen
			{
	                  
				s eobj.PHGENGenusDr=$p(args,",",i)
				s obj=##class(User.DHCPHGenusBus).%New()				
				d obj.PHGENInstDrSetObjectId(PHDDInstDr)        
				d obj.PHGENGenusDrSetObjectId(eobj.PHGENGenusDr)
				s BTGEDesc=$p($g(^DHCPHBTGE(eobj.PHGENGenusDr)),"^",2) //菌属描述
				s:PHGENGenusDrs'="" PHGENGenusDrs=PHGENGenusDrs_"、"_BTGEDesc	
				s:PHGENGenusDrs="" PHGENGenusDrs=BTGEDesc
								
				s scGenus=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scGenus)
				{
					s Genusid=obj.%Id()
				}
				else
				{
					s result ="false"
				}
			}
			s eobj.PHGENGenusDrs=PHGENGenusDrs
		}	
		;检验指标
		s LABIRowId=$o(^DHCLIBLABI(0,"Inst",PHDDInstDr,0))
		if (LABIRowId'="")
		{
			s labobj = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
		}
		else
		{
			s labobj = ##class(User.DHCLibLabItm).%New()
		}		
		;检验指标
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
				
		//修改主索引表
				
		s objIns=##class(User.DHCPHInstructions).%OpenId(PHDDInstDr)
		
		s bobj.PHINSTRowId=PHDDInstDr
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
		  	s:objAge.PDAAgeDr'="" bobj.PDAAgeDr = objAge.PDAAgeDr.%Id()
		  	s bobj.PDAMinVal=objAge.PDAMinVal
		  	s bobj.PDAMaxVal=objAge.PDAMaxVal
		  	s:objAge.PDAUomDr'="" bobj.PDAUomDr = objAge.PDAUomDr.%Id()
		}
		elseif(PDARowId="")&((eobj.PDAAgeDr'="")||(eobj.PDAMinVal'="")||(eobj.PDAMinVal'=""))
		{
			s objAge=##class(User.DHCPHDiseaseAge).%New()
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

		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"			}
		else
		{
			Tc
			s result = "{success:'true',id:'"_PHDDInstDr_"'}" //返回RowId
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器适应证",Insid,eobj.PHINSTText,"U",eobj,bobj)
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
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugDiseaseI","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Indic","U"),0))
	s PHINSTRowId=0
	for
	{
		s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""	
		s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
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

/// Description:根据id删除 病症业务表
/// Table:User.DHCPHDrugDisease
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""
		TS	
		//日志
		s bobj = ##class(web.Entity.KB.DHCPHDrugDiseaseI).%New()
		//删除病症业务表
		s PHDDRowId=0
		s PHDDDiseaDrs=""
		for
		{
			s PHDDRowId=$o(^DHCPHDDIS("0","Inst",id,PHDDRowId)) q:PHDDRowId=""
			s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
			s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
			s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc
			s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc			
			s sc=##class(User.DHCPHDrugDisease).%DeleteId(PHDDRowId)
			if '$$$ISOK(sc)
			{
				s result ="false"
			}
		}
		s bobj.PHDDDiseaDrs=PHDDDiseaDrs
		s bobj.PHDDMode="I"
		
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
		
		//修改细菌业务表(先删除所有的细菌)
		s RowId=0
		s PHORGOrgDrs=""
		for
		{
			s RowId=$o(^DHCPHORGBUS("0","Inst",id,RowId)) q:RowId=""
			s PHORGOrgDr=$p($g(^DHCPHORGBUS(RowId)),"^",2) //细菌DR
			s BTODesc=$p($g(^DHCPHBTORG(PHORGOrgDr)),"^",2) //细菌描述
			s:PHORGOrgDrs'="" PHORGOrgDrs=PHORGOrgDrs_"、"_BTODesc	
			s:PHORGOrgDrs="" PHORGOrgDrs=BTODesc
			s scorg=##class(User.DHCPHOrganismBus).%DeleteId(RowId)
			if '$$$ISOK(scorg)
			{
				s result ="false"
			}
		}
		s bobj.PHORGOrgDrs=PHORGOrgDrs
		
		//修改菌属业务表(先删除所有的细菌)
		s RowId=0
		s PHGENGenusDrs=""
		for
		{
			s RowId=$o(^DHCPHGENUSBUS("0","Inst",id,RowId)) q:RowId=""
			s PHGENGenusDr=$p($g(^DHCPHGENUSBUS(RowId)),"^",2) //菌属DR
			s BTGEDesc=$p($g(^DHCPHBTGE(PHGENGenusDr)),"^",2) //菌属描述
			s:PHGENGenusDrs'="" PHGENGenusDrs=PHGENGenusDrs_"、"_BTGEDesc	
			s:PHGENGenusDrs="" PHGENGenusDrs=BTGEDesc
			s scgenus=##class(User.DHCPHGenusBus).%DeleteId(RowId)
		}
		s bobj.PHGENGenusDrs=PHGENGenusDrs
		
		//删除年龄业务表
		s PDARowId=$o(^DHCPHDISAGE("0","Inst",id,0))
		if (PDARowId'="")
		{
			s aobj = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			s bobj.PDARowId=PDARowId
			s:aobj.PDAInstDr'="" bobj.PDAInstDr=aobj.PDAInstDr.%Id()
			s bobj.PDAMinVal=aobj.PDAMinVal
			s bobj.PDAMaxVal=aobj.PDAMaxVal
			s:aobj.PDAUomDr'="" bobj.PDAUomDr=aobj.PDAUomDr.%Id()
			
			s scAge=##class(User.DHCPHDiseaseAge).%DeleteId(PDARowId)
			if '$$$ISOK(scAge)
			{
				s result ="false"
			}

		}
		
		//删除检验项目业务表
		s LABIRowId=$o(^DHCLIBLABI("0","Inst",id,0))
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
		
		//删除主索引表	
		s objIns=##class(User.DHCPHInstructions).%OpenId(id)
		s bobj.PHINSTRowId=id
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
		
								
		s scInst=##class(User.DHCPHInstructions).%DeleteId(id)
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
			TC
			s result = "{success:'true',info:'删除成功！'}"	
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器适应证",id,bobj.PHINSTText,"D",bobj)
			
		}
		q result
}

/// Description：根据主索引的id获取适应证数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).GetIndData("4")
ClassMethod GetIndData(InstId As %String) As %String
{

		s PHINSTText=""
		s PHINSTMode= $p($g(^DHCPHINSTRUC(InstId)),"^",14)
		if (PHINSTMode'="")
		{
			s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		}
		q PHINSTText
}

/// Description：获取用法用量中已选病症的串
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).GetDiseaDr(67)
ClassMethod GetDiseaDr(InstId As %String) As %String
{
 s str=""
 if (InstId'="")
 {
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",InstId,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3) //病症Dr
		s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",1) //病症代码 
		s str="<"_PHDISLDiseaCode_">^"_str
	}
 }
 q str
}

/// 查询适应证中病症已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugDiseaseI","GetDiseaList","37")
Query GetDiseaList(InstId) As %Query(ROWSPEC = "PHDDRowId,PHDDDiseaDr,PHDISLDiseaCode,PHDISLDiseaDesc")
{
}

ClassMethod GetDiseaListExecute(ByRef qHandle As %Binary, InstId) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (InstId'="")
	{
		s PHDDRowId=0
		for
		{
			s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",InstId,PHDDRowId)) q:PHDDRowId=""
			s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3) //病症Dr
			s PHDISLDiseaCode="",PHDISLDiseaDesc=""
			if (PHDDDiseaDr'="") 
			{
				s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",1) //病症代码 
			 	s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述			
				d OutputRowDis
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDis
    set Data=$lb(PHDDRowId,PHDDDiseaDr,PHDISLDiseaCode,PHDISLDiseaDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiseaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiseaListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiseaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiseaListExecute ]
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

/// Description:根据病症id删除病症
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).DeleteDiseaData("121")
ClassMethod DeleteDiseaData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s sc=##class(User.DHCPHDrugDisease).%DeleteId(id)
		if $$$ISOK(sc)
		{
			s result="{success:'true',info:'删除成功！'}"
		}
		else
		{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else
	{
		s result= "{success:'false',info:'没有选中行'}"  //返回错误信息
	}
	q result
}

/// Creator:丁亚男
/// Description：查询未选病症字典的下拉列表内容
/// Table：User.DHCPHDiseaseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugDiseaseI","GetUnSelDiseaListForCmb","34")
Query GetUnSelDiseaListForCmb(InstId As %String, diseaStr As %String, desc As %String) As %Query(ROWSPEC = "PHDISLRowId:%String,PHDISLDiseaDesc:%String")
{
}

ClassMethod GetUnSelDiseaListForCmbExecute(ByRef qHandle As %Binary, InstId As %String, diseaStr As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		s selectStr = ##class(web.DHCBL.KB.DHCPHDrugDisease).GetDiseaDr(InstId)
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHDISLRowId=0
		for {
			s PHDISLRowId=$o(^DHCPHDISL(PHDISLRowId))
			q:PHDISLRowId=""
				s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
				s Code = "<"_PHDISLDiseaCode_">"
				s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
				s Desc = "<"_PHDISLDiseaDesc_">"
				s PHDISLDiseaDescU=$ZCONVERT(PHDISLDiseaDesc,"U")
				s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
				continue:PHDISLActiveFlag="N"
				s PHDISLSysFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",4)
				s PHDISLRemark=$p($g(^DHCPHDISL(PHDISLRowId)),"^",5)
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHDISLDiseaDesc)
				if ('(selectStr[Code))&('(diseaStr[Desc))&((PHDISLDiseaDescU[desc)||(PINYIN[desc)) //2016-08-09
				{
					d OutputRowUn
				}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUn
    set Data=$lb(PHDISLRowId,PHDISLDiseaDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelDiseaListForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelDiseaListForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnSelDiseaListForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelDiseaListForCmbExecute ]
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

/// Description：查询未选病症字典的列表内容
/// Table：User.DHCPHDiseaseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugDiseaseI","GetUnSelDiseaList","34")
Query GetUnSelDiseaList(InstId As %String, diseaStr As %String, desc As %String) As %Query(ROWSPEC = "PHDISLRowId:%String,PHDISLDiseaCode:%String,PHDISLDiseaDesc:%String,PHDISLActiveFlag:%String,PHDISLSysFlag:%String,PHDISLRemark:%String")
{
}

ClassMethod GetUnSelDiseaListExecute(ByRef qHandle As %Binary, InstId As %String, diseaStr As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		s selectStr = ##class(web.DHCBL.KB.DHCPHDrugDisease).GetDiseaDr(InstId)
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHDISLRowId=0
		for {
			s PHDISLRowId=$o(^DHCPHDISL(PHDISLRowId))
			q:PHDISLRowId=""
				s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
				s Code = "<"_PHDISLDiseaCode_">"
				s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
				s PHDISLDiseaDescU=$ZCONVERT(PHDISLDiseaDesc,"U")
				s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
				continue:PHDISLActiveFlag="N"
				s PHDISLSysFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",4)
				s PHDISLRemark=$p($g(^DHCPHDISL(PHDISLRowId)),"^",5)
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHDISLDiseaDesc)
				if ('(selectStr[Code))&('(diseaStr[Code))&((PHDISLDiseaDescU[desc)||(PINYIN[desc)) //2016-08-09
				{
					d OutputRowUn
				}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUn
    set Data=$lb(PHDISLRowId,PHDISLDiseaCode,PHDISLDiseaDesc,PHDISLActiveFlag,PHDISLSysFlag,PHDISLRemark)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelDiseaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelDiseaListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnSelDiseaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelDiseaListExecute ]
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

}
