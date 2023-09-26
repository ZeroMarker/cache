Import SQLUser

/// 名称: (禁忌症)病症业务表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-12-3
Class web.DHCBL.KB.DHCCheckDiseaseC Extends %RegisteredObject
{

/// Description：打开禁忌症数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCCheckDiseaseC).OpenIndData("1")
ClassMethod OpenConData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCCheckDiseaseC).%New()
	s eobj.PHDDInstDr=id
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTSex=pobjIns.PHINSTSex
	s eobj.PHINSTText=pobjIns.PHINSTText
	
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
	d pobjIns.%Close()
	k pobjIns

	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存禁忌症
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCCheckDiseaseC 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCCheckDiseaseC).SaveIndData()
ClassMethod SaveConData(eobj As web.Entity.KB.DHCCheckDiseaseC) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//开始保存到主索引表
		Ts	
		if ((eobj.PHINSTGenDr="")||(eobj.PHINSTPointerDr=""))   //通用名或部位为空
		{
			s result="false"
		}
		if (eobj.PHINSTGenDr'="")  //根据通用名的知识库标识来区分放射、超声、内镜
		{
			s PHEGLibDr=$p($g(^DHCPHEGEN(eobj.PHINSTGenDr)),"^",7)
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
			s:PHEGLibDr="" PHLICode=""
			if (PHLICode="RADI") //放射
			{
				s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("RADIContr","U"),0))
				s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("RADI","U"),0))
			}
			elseif(PHLICode="ULTR")  //超声
			{
				s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ULTRContr","U"),0))
				s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("ULTR","U"),0))	
			}
			elseif(PHLICode="ENDO") //内镜
			{
				s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ENDOContr","U"),0))
				s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("ENDO","U"),0))	
			}
			elseif(PHLICode="CHECK")  //检验
			{
				s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("CheckContr","U"),0))
				s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("CHECK","U"),0))
			}
			else  //治疗项目
			{
				s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("TreatContr","U"),0))
				s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("TREAT","U"),0))
			}
		}
					   				
		s objIns=##class(User.DHCPHInstructions).%New()							
		s objIns.PHINSTSex=eobj.PHINSTSex
		s objIns.PHINSTText=eobj.PHINSTText
		s objIns.PHINSTMode=eobj.PHINSTMode
		
		//主索引表必填项
		//s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("CheckContr","U"),0))
		//s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("CHECK","U"),0))	
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
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
			
		//开始保存到病症业务表
		s args=eobj.PHDDDiseaDr
		if (args'="")
		{
			s PHDDDiseaDrs=""
			s argsLen=$Length(args,",")
			for i=1:1:argsLen
			{                 
				s eobj.PHDDDiseaDr=$p(args,",",i)
				s PHDISLDiseaDesc=$p($g(^DHCPHDISL(eobj.PHDDDiseaDr)),"^",2) //病症描述
				s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
				s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc
				s obj=##class(User.DHCPHDrugDisease).%New()				
				s eobj.PHDDInstDr=Insid
				d obj.PHDDInstDrSetObjectId(eobj.PHDDInstDr)
				s eobj.PHDDMode="C"
				s obj.PHDDMode = eobj.PHDDMode 
				s obj.PHDDType=eobj.PHDDType         
				d obj.PHDDDiseaDrSetObjectId(eobj.PHDDDiseaDr)				
				s scDis=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scDis)
				{
					s id=obj.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scDis)_"'}"  //返回错误信息
				}
			}
			s eobj.PHDDDiseaDrs=PHDDDiseaDrs
		}
		//开始保存到特殊人群业务表
		s argPopu=eobj.SpecialPopu
		if (argPopu'="")
		{
			s SPEPISpecDrs=""
			s popuLen=$Length(argPopu,",")
			for i=1:1:popuLen
			{
				s eobj.SpecialPopu=$p(argPopu,",",i)
				s SPEDesc=$p($g(^DHCSPEP(eobj.SpecialPopu)),"^",2) //特殊人群描述
				s:SPEPISpecDrs'="" SPEPISpecDrs=SPEPISpecDrs_"、"_SPEDesc	
				s:SPEPISpecDrs="" SPEPISpecDrs=SPEDesc
				s popuobj = ##class(User.DHCLibSpecPopuItm).%New() 
				d popuobj.SPEPIInstDrSetObjectId(Insid)
				d popuobj.SPEPISpecDrSetObjectId(eobj.SpecialPopu)
							
				s scPopu=popuobj.%Save()
		
				d popuobj.%Close()
				if $$$ISOK(scPopu)
				{	
					s popuId=popuobj.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scPopu)_"'}"  //返回错误信息
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
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
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
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
		//开始保存到治疗手术业务表
		s args=eobj.PDCUKeyWordDr
		if (args'="")
		{
			s PDCUKeyWordDrs=""
			s argsLen=$Length(args,",")
			for i=1:1:argsLen
			{
	                  
				s eobj.PDCUKeyWordDr=$p(args,",",i)
				s PHKWDesc=$p($g(^DHCPHKW(eobj.PDCUKeyWordDr)),"^",2) //治疗手术
				s:PDCUKeyWordDrs'="" PDCUKeyWordDrs=PDCUKeyWordDrs_"、"_PHKWDesc	
				s:PDCUKeyWordDrs="" PDCUKeyWordDrs=PHKWDesc
				s obj=##class(User.DHCPHCure).%New()				
				d obj.PDCUInstDrSetObjectId(Insid)        
				d obj.PDCUKeyWordDrSetObjectId(eobj.PDCUKeyWordDr)				
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
			s PSYMKeyWordDrs=""
			s argsLen=$Length(args,",")
			for i=1:1:argsLen
			{
	                  
				s eobj.PSYMKeyWordDr=$p(args,",",i)
				s PHKWDesc=$p($g(^DHCPHKW(eobj.PSYMKeyWordDr)),"^",2) //症状业务
				s:PSYMKeyWordDrs'="" PSYMKeyWordDrs=PSYMKeyWordDrs_"、"_PHKWDesc	
				s:PSYMKeyWordDrs="" PSYMKeyWordDrs=PHKWDesc
				
				s obj=##class(User.DHCPHSymptomBus).%New()				
				d obj.PSYMInstDrSetObjectId(Insid)        
				d obj.PSYMKeyWordDrSetObjectId(eobj.PSYMKeyWordDr)				
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
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}
		else
		{
			Tc
			s result = "{success:'true',id:'"_Insid_"'}" //返回RowId
			d:PHLICode="RADI" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","放射项目编辑器-禁忌证",Insid,eobj.PHINSTText,"A",eobj)
			d:PHLICode="ULTR" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","超声项目编辑器-禁忌证",Insid,eobj.PHINSTText,"A",eobj)
			d:PHLICode="ENDO" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","内镜项目编辑器-禁忌证",Insid,eobj.PHINSTText,"A",eobj)
			d:PHLICode="CHECK" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检验项目编辑器-禁忌证",Insid,eobj.PHINSTText,"A",eobj)
			d:PHLICode="TREAT" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","治疗项目编辑器-禁忌证",Insid,eobj.PHINSTText,"A",eobj)
		
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
/// Input：web.Entity.KB.DHCCheckDiseaseC 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCCheckDiseaseC).SaveIndData()
ClassMethod UpdateConData(eobj As web.Entity.KB.DHCCheckDiseaseC) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		Ts
		//日志
		s bobj = ##class(web.Entity.KB.DHCCheckDiseaseC).%New()
		
		s PHDDInstDr=eobj.PHDDInstDr
		//s eobj.PHDDInstDr=$p($g(^DHCPHDDIS(eobj.PHDDRowId)),"^",1)
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
		s bobj.PHDDMode="C"
		s bobj.PHDDDiseaDrs=OPHDDDiseaDrs
		 //病症多选
		s args=eobj.PHDDDiseaDr 
		if (args'="")
		{
			s PHDDDiseaDrs=""
			s argsLen=$Length(args,",")
			for i=1:1:argsLen
			{               
				s eobj.PHDDDiseaDr=$p(args,",",i)
				s PHDISLDiseaDesc=$p($g(^DHCPHDISL(eobj.PHDDDiseaDr)),"^",2) //病症描述
				s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
				s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc
				
				s obj=##class(User.DHCPHDrugDisease).%New()				
				s eobj.PHDDInstDr=PHDDInstDr
				d obj.PHDDInstDrSetObjectId(eobj.PHDDInstDr)
				s eobj.PHDDMode="C"
				s obj.PHDDMode = eobj.PHDDMode  
				s obj.PHDDType=eobj.PHDDType        
				d obj.PHDDDiseaDrSetObjectId(eobj.PHDDDiseaDr)				
				s scDis=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scDis)
				{
					s id=obj.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scDis)_"'}"  //返回错误信息
				}
			}
			s eobj.PHDDDiseaDrs=PHDDDiseaDrs
		}
	//修改特殊人群业务表(先删除)
		s OSPEPISpecDrs=""
		s SPEPIRowId=0
		for
		{
			s SPEPIRowId=$o(^DHCLIBSPEPI("0","Inst",PHDDInstDr,SPEPIRowId)) q:SPEPIRowId=""
			s SPEPISpecDr=$p($g(^DHCLIBSPEPI(SPEPIRowId)),"^",2) //特殊人群DR	
			s SPEDesc=$p($g(^DHCSPEP(SPEPISpecDr)),"^",2) //特殊人群描述
			s:OSPEPISpecDrs'="" OSPEPISpecDrs=OSPEPISpecDrs_"、"_SPEDesc	
			s:OSPEPISpecDrs="" OSPEPISpecDrs=SPEDesc
			s scPopu=##class(User.DHCLibSpecPopuItm).%DeleteId(SPEPIRowId)
		}
		s bobj.SPEPISpecDrs=OSPEPISpecDrs
		//开始保存到特殊人群业务表
		s argPopu=eobj.SpecialPopu
		if (argPopu'="")
		{
			s SPEPISpecDrs=""
			s popuLen=$Length(argPopu,",")
			for i=1:1:popuLen
			{
				s eobj.SpecialPopu=$p(argPopu,",",i)
				s SPEDesc=$p($g(^DHCSPEP(eobj.SpecialPopu)),"^",2) //特殊人群描述
				s:SPEPISpecDrs'="" SPEPISpecDrs=SPEPISpecDrs_"、"_SPEDesc	
				s:SPEPISpecDrs="" SPEPISpecDrs=SPEDesc
				s popuobj = ##class(User.DHCLibSpecPopuItm).%New() 
				d popuobj.SPEPIInstDrSetObjectId(PHDDInstDr)
				d popuobj.SPEPISpecDrSetObjectId(eobj.SpecialPopu)
							
				s scPopu=popuobj.%Save()
		
				d popuobj.%Close()
				if $$$ISOK(scPopu)
				{
					s popuId=popuobj.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scPopu)_"'}"  //返回错误信息
				}
			}
			s eobj.SPEPISpecDrs=SPEPISpecDrs
		}
		//修改主索引表		
		s objIns=##class(User.DHCPHInstructions).%OpenId(PHDDInstDr)
		s bobj.PHINSTMode=objIns.PHINSTMode
		s bobj.PHINSTSex=objIns.PHINSTSex
		s bobj.PHINSTText=objIns.PHINSTText
		
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr=objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum 
		s bobj.PHINSTGenDr=objIns.PHINSTGenDr 
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr=objIns.PHINSTLibDr.%Id() 
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag 
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag 
		s PHLICode=""
		if (bobj.PHINSTGenDr'="")  //根据通用名的知识库标识来区分放射、超声、内镜
		{
			s PHEGLibDr=$p($g(^DHCPHEGEN(bobj.PHINSTGenDr)),"^",7)
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
			s:PHEGLibDr="" PHLICode=""
		}
		
		s objIns.PHINSTMode=eobj.PHINSTMode
		s objIns.PHINSTSex=eobj.PHINSTSex
		s objIns.PHINSTText=eobj.PHINSTText		
		s scIns=objIns.%Save()	
		d objIns.%Close()
		If $$$ISOK(scIns)
		{
			s Insid = objIns.%Id()
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scIns)_"'}"  //返回错误信息
		}
	
	    //修改年龄业务表
		//通过索引获取年龄业务表的RowId——PDARowId
		s PDARowId=$o(^DHCPHDISAGE(0,"Inst",PHDDInstDr,0))
		if (PDARowId'="")
		{
			s objAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			s:objAge.PDAAgeDr'="" bobj.PDAAgeDr=objAge.PDAAgeDr.%Id()
			s bobj.PDAMinVal=objAge.PDAMinVal
			s bobj.PDAMaxVal=objAge.PDAMaxVal
			s:objAge.PDAUomDr'="" bobj.PDAUomDr=objAge.PDAUomDr.%Id()
		}
		else
		{
			s objAge=##class(User.DHCPHDiseaseAge).%New()			
		}	
		d objAge.PDAInstDrSetObjectId(PHDDInstDr)			  
		d objAge.PDAAgeDrSetObjectId(eobj.PDAAgeDr)
		s objAge.PDAMaxVal=eobj.PDAMaxVal
		s objAge.PDAMinVal=eobj.PDAMinVal
		d objAge.PDAUomDrSetObjectId(eobj.PDAUomDr)	
		s scAge=objAge.%Save()
		d objAge.%Close()

		if $$$ISOK(scAge)
		{
			s ageId=objAge.%Id()
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scAge)_"'}"  //返回错误信息
		}
		
	    //修改过敏史业务表		

		//通过索引获取年龄业务表的RowId——PDARowId
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
		d objAgy.LALCInstDrSetObjectId(PHDDInstDr)
		d objAgy.LALCAllergyDrSetObjectId(eobj.LALCAllergyDr)
		s scAgy=objAgy.%Save()
		d objAgy.%Close()
		if $$$ISOK(scAgy)
		{
			s agyId=objAgy.%Id()
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scAgy)_"'}"  //返回错误信息
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
			s PDCUKeyWordDrs=""
			s argsLen=$Length(args,",")
			for i=1:1:argsLen
			{
	                  
				s eobj.PDCUKeyWordDr=$p(args,",",i)
				s PHKWDesc=$p($g(^DHCPHKW(eobj.PDCUKeyWordDr)),"^",2) //治疗手术
				s:PDCUKeyWordDrs'="" PDCUKeyWordDrs=PDCUKeyWordDrs_"、"_PHKWDesc	
				s:PDCUKeyWordDrs="" PDCUKeyWordDrs=PHKWDesc	
				s obj=##class(User.DHCPHCure).%New()				
				d obj.PDCUInstDrSetObjectId(PHDDInstDr)        
				d obj.PDCUKeyWordDrSetObjectId(eobj.PDCUKeyWordDr)				
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
			s PSYMKeyWordDrs=""
			s argsLen=$Length(args,",")
			for i=1:1:argsLen
			{
	                  
				s eobj.PSYMKeyWordDr=$p(args,",",i)
				s PHKWDesc=$p($g(^DHCPHKW(eobj.PSYMKeyWordDr)),"^",2) //症状业务
				s:PSYMKeyWordDrs'="" PSYMKeyWordDrs=PSYMKeyWordDrs_"、"_PHKWDesc	
				s:PSYMKeyWordDrs="" PSYMKeyWordDrs=PHKWDesc	
				
				s obj=##class(User.DHCPHSymptomBus).%New()				
				d obj.PSYMInstDrSetObjectId(PHDDInstDr)        
				d obj.PSYMKeyWordDrSetObjectId(eobj.PSYMKeyWordDr)				
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

		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}
		else
		{
			Tc
			s result = "{success:'true',id:'"_PHDDInstDr_"'}" //返回RowId
			d:PHLICode="RADI" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","放射项目编辑器-禁忌证",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)
			d:PHLICode="ULTR" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","超声项目编辑器-禁忌证",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)
			d:PHLICode="ENDO" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","内镜项目编辑器-禁忌证",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)
			d:PHLICode="CHECK" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检验项目编辑器-禁忌证",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)
			d:PHLICode="TREAT" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","治疗项目编辑器-禁忌证",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)
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
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCCheckDiseaseC","GetListCon","","","111","Form","1")
Query GetListCon(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText")
{
}

ClassMethod GetListConExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (GenDr'="")  //根据通用名的知识库标识来区分放射、超声、内镜
	{
		
		s PHEGLibDr=$p($g(^DHCPHEGEN(GenDr)),"^",7)
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
		s:PHEGLibDr="" PHLICode=""
		if (PHLICode="RADI") //放射
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("RADIContr","U"),0))
		}
		elseif(PHLICode="ULTR")  //超声
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ULTRContr","U"),0))
		}
		elseif(PHLICode="ENDO") //内镜
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ENDOContr","U"),0))
		}
		elseif(PHLICode="CHECK")  //检验
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("CheckContr","U"),0))
		}
		else  //治疗项目
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("TreatContr","U"),0))
		}
	}	
	
	//s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("CheckContr","U"),0))
	
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
/// Other:w ##class(web.DHCBL.KB.DHCCheckDiseaseC).DeleteData("1")
ClassMethod DeleteConData(id As %String) As %String
{
		s result=""	
		s InstDr=id
		TS
		//日志
		s bobj = ##class(web.Entity.KB.DHCCheckDiseaseC).%New()	
		//删除病症字典表
		s OPHDDDiseaDrs=""
		s PHDDRowId=0
		for
		{
			s PHDDRowId=$o(^DHCPHDDIS("0","Inst",InstDr,PHDDRowId)) q:PHDDRowId=""
			s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
			s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
			s:OPHDDDiseaDrs'="" OPHDDDiseaDrs=OPHDDDiseaDrs_"、"_PHDISLDiseaDesc	
			s:OPHDDDiseaDrs="" OPHDDDiseaDrs=PHDISLDiseaDesc		
			s sc=##class(User.DHCPHDrugDisease).%DeleteId(PHDDRowId)
			if '$$$ISOK(sc)
			{
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		}
		s bobj.PHDDMode="C"
		s bobj.PHDDDiseaDrs=OPHDDDiseaDrs
		
		//删除特殊人群业务表
		s OSPEPISpecDrs=""
		s SPEPIRowId=0
		for
		{
			s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",InstDr,SPEPIRowId)) q:SPEPIRowId=""
			s SPEPISpecDr=$p($g(^DHCLIBSPEPI(SPEPIRowId)),"^",2) //特殊人群DR	
			s SPEDesc=$p($g(^DHCSPEP(SPEPISpecDr)),"^",2) //特殊人群描述
			s:OSPEPISpecDrs'="" OSPEPISpecDrs=OSPEPISpecDrs_"、"_SPEDesc	
			s:OSPEPISpecDrs="" OSPEPISpecDrs=SPEDesc
			s scPopu=##class(User.DHCLibSpecPopuItm).%DeleteId(SPEPIRowId)
			if '$$$ISOK(scPopu)
			{
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scPopu)_"'}"  //返回错误信息
			}
		}
		s bobj.SPEPISpecDrs=OSPEPISpecDrs
		//删除年龄业务表
		s PDARowId=$o(^DHCPHDISAGE("0","Inst",InstDr,0))
		if (PDARowId'="")
		{	
			s objAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			s:objAge.PDAAgeDr'="" bobj.PDAAgeDr=objAge.PDAAgeDr.%Id()
			s bobj.PDAMinVal=objAge.PDAMinVal
			s bobj.PDAMaxVal=objAge.PDAMaxVal
			s:objAge.PDAUomDr'="" bobj.PDAUomDr=objAge.PDAUomDr.%Id()
				
			s scAge=##class(User.DHCPHDiseaseAge).%DeleteId(PDARowId)
			if '$$$ISOK(scAge)
			{
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scAge)_"'}"  //返回错误信息
			}
		}
		//删除过敏史业务表
		s LALCRowId=$o(^DHCLIBALLI(0,"Inst",InstDr,0))
		if (LALCRowId'="")
		{
			s objAgy =##class(User.DHCLibAllergyItm).%OpenId(LALCRowId)
			s:objAgy.LALCAllergyDr'="" bobj.LALCAllergyDr=objAgy.LALCAllergyDr.%Id()
			
			s scAgy=##class(User.DHCLibAllergyItm).%DeleteId(LALCRowId)
			if '$$$ISOK(scAgy)
			{
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scAgy)_"'}"  //返回错误信息
			}
		}
		//删除所有的治疗手术
		s OPDCUKeyWordDrs=""
		s RowId=0
		for
		{
			s RowId=$o(^DHCPHCU("0","Inst",id,RowId)) q:RowId=""
			s PDCUKeyWordDr=$p($g(^DHCPHCU(RowId)),"^",2) //手术DR
			s PHKWDesc=$p($g(^DHCPHKW(PDCUKeyWordDr)),"^",2) //治疗手术
			s:OPDCUKeyWordDrs'="" OPDCUKeyWordDrs=OPDCUKeyWordDrs_"、"_PHKWDesc	
			s:OPDCUKeyWordDrs="" OPDCUKeyWordDrs=PHKWDesc
			s scdcu=##class(User.DHCPHCure).%DeleteId(RowId)
			if '$$$ISOK(scdcu)
			{
				s result ="false"
			}
		}
		s bobj.PDCUKeyWordDrs=OPDCUKeyWordDrs
		//删除所有的症状
		s OPSYMKeyWordDrs=""
		s RowId=0
		for
		{
			s RowId=$o(^DHCPHSYM("0","Inst",id,RowId)) q:RowId=""
			s PSYMKeyWordDr=$p($g(^DHCPHSYM(RowId)),"^",2) //症状DR
			s PHKWDesc=$p($g(^DHCPHKW(PSYMKeyWordDr)),"^",2) //症状业务
			s:OPSYMKeyWordDrs'="" OPSYMKeyWordDrs=OPSYMKeyWordDrs_"、"_PHKWDesc	
			s:OPSYMKeyWordDrs="" OPSYMKeyWordDrs=PHKWDesc
			s scsym=##class(User.DHCPHSymptomBus).%DeleteId(RowId)
			if '$$$ISOK(scsym)
			{
				s result ="false"
			}
		}
		s bobj.PSYMKeyWordDrs=OPSYMKeyWordDrs
		//删除主索引表
		s objIns=##class(User.DHCPHInstructions).%OpenId(InstDr)
		s bobj.PHINSTMode=objIns.PHINSTMode
		s bobj.PHINSTSex=objIns.PHINSTSex
		s bobj.PHINSTText=objIns.PHINSTText
		
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr=objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum 
		s bobj.PHINSTGenDr=objIns.PHINSTGenDr 
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr=objIns.PHINSTLibDr.%Id() 
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag 
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag 
		s PHLICode=""
		if (bobj.PHINSTGenDr'="")  //根据通用名的知识库标识来区分放射、超声、内镜
		{
			s PHEGLibDr=$p($g(^DHCPHEGEN(bobj.PHINSTGenDr)),"^",7)
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
			s:PHEGLibDr="" PHLICode=""
		}
				
			
		s scInst=##class(User.DHCPHInstructions).%DeleteId(InstDr)
		if '$$$ISOK(scInst)
		{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scInst)_"'}"  //返回错误信息
		}
		if (result["false")
		{
			Trollback
			s result = "{success:'false',info:'删除失败！'}"
		}
		else
		{
			TC
			s result="{success:'true',info:'删除成功！'}"
			d:PHLICode="RADI" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","放射项目编辑器-禁忌证",id,bobj.PHINSTText,"D",bobj)
			d:PHLICode="ULTR" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","超声项目编辑器-禁忌证",id,bobj.PHINSTText,"D",bobj)
			d:PHLICode="ENDO" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","内镜项目编辑器-禁忌证",id,bobj.PHINSTText,"D",bobj)
			d:PHLICode="CHECK" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检验项目编辑器-禁忌证",id,bobj.PHINSTText,"D",bobj)
			d:PHLICode="TREAT" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","治疗项目编辑器-禁忌证",id,bobj.PHINSTText,"D",bobj)
		}
		q result
}

/// Description：根据主索引的id获取禁忌症数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCCheckDiseaseC).GetConData("7")
ClassMethod GetConData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

/// Description：获取禁忌证中已选成分的串
/// Other: w ##class(web.DHCBL.KB.DHCCheckDiseaseC).GetIngrDr(67)
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
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCCheckDiseaseC","GetUnSelIngrList","","")
Query GetUnSelIngrList(InstId As %String, desc As %String) As %Query(ROWSPEC = "PHEINGRowId,PHEINGCode,PHEINGDesc")
{
}

ClassMethod GetUnSelIngrListExecute(ByRef qHandle As %Binary, InstId As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s selectStr = ##class(web.DHCBL.KB.DHCCheckDiseaseC).GetIngrDr(InstId)
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHEINGRowId=0
		for  
		{	
			s PHEINGRowId=$o(^DHCPHEING(PHEINGRowId)) q:PHEINGRowId="" 
				s PHEINGCode=$p($g(^DHCPHEING(PHEINGRowId)),"^",1)  //代码
				s Code = "<"_PHEINGCode_">"
				s PHEINGDesc=$p($g(^DHCPHEING(PHEINGRowId)),"^",2)  //描述
				s PHEINGDescU=$ZCONVERT(PHEINGDesc,"U")
		
				if ('(selectStr[Code))&(PHEINGDescU[desc)   //条件
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
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCCheckDiseaseC","GetIngrList","")
Query GetIngrList(InstId As %String) As %Query(ROWSPEC = "PHINIRowId,PHINIIngrDr,PHEINGCode,PHEINGDesc")
{
}

ClassMethod GetIngrListExecute(ByRef qHandle As %Binary, InstId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (InstId'=""){
		s PHINIRowId=0
		for  
		{	
			s PHINIRowId=$o(^DHCPHINI("0","Inst",InstId,PHINIRowId)) q:PHINIRowId="" 
			s PHINIIngrDr=$p($g(^DHCPHINI(PHINIRowId)),"^",2)
			s PHEINGCode=$p($g(^DHCPHEING(PHINIIngrDr)),"^",1)  //代码
			s PHEINGDesc=$p($g(^DHCPHEING(PHINIIngrDr)),"^",2)  //描述
			d OutputRowIngr	
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
/// Other:d ##class(web.DHCBL.KB.DHCCheckDiseaseC).DeleteIngrData("")
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

}
