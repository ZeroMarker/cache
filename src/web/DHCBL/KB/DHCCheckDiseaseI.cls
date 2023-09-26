Import SQLUser

/// 名称: 病症业务表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-12-3
Class web.DHCBL.KB.DHCCheckDiseaseI Extends %RegisteredObject
{

/// Description：打开适应症数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCCheckDiseaseI).OpenIndData("1")
ClassMethod OpenIndData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCCheckDiseaseI).%New()
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

	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存适应症
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCCheckDiseaseI 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCCheckDiseaseI).SaveIndData()
ClassMethod SaveIndData(eobj As web.Entity.KB.DHCCheckDiseaseI) As %String
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
				s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("RADIIndic","U"),0))
				s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("RADI","U"),0))
			}
			elseif(PHLICode="ULTR")  //超声
			{
				s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ULTRIndic","U"),0))
				s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("ULTR","U"),0))	
			}
			elseif(PHLICode="ENDO") //内镜
			{
				s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ENDOIndic","U"),0))
				s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("ENDO","U"),0))	
			}
			elseif(PHLICode="CHECK")   //检验
			{
				s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("CheckIndic","U"),0))
				s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("CHECK","U"),0))
			}
			else  //治疗项目
			{
				s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("TreatIndic","U"),0))
				s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("TREAT","U"),0))
			}
		}
		
					   				
		s objIns=##class(User.DHCPHInstructions).%New()
		s objIns.PHINSTMode=eobj.PHINSTMode							
		s objIns.PHINSTSex=eobj.PHINSTSex
		s objIns.PHINSTText=eobj.PHINSTText		

		//主索引表必填项
		//s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("CheckIndic","U"),0))
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
	
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scIns)_"'}"  //返回错误信息
		}
			
		//开始保存到病症业务表
		s args=eobj.PHDDDiseaDr
		if (args'=""){
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
				s eobj.PHDDMode="I"
				s obj.PHDDMode = eobj.PHDDMode          
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
			d:PHLICode="RADI" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","放射项目编辑器-适应症",Insid,eobj.PHINSTText,"A",eobj)
			d:PHLICode="ULTR" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","超声项目编辑器-适应症",Insid,eobj.PHINSTText,"A",eobj)
			d:PHLICode="ENDO" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","内镜项目编辑器-适应症",Insid,eobj.PHINSTText,"A",eobj)
			d:PHLICode="CHECK" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检验项目编辑器-适应症",Insid,eobj.PHINSTText,"A",eobj)
			d:PHLICode="TREAT" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","治疗项目编辑器-适应症",Insid,eobj.PHINSTText,"A",eobj)
		}
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改适应症
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCCheckDiseaseI 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCCheckDiseaseI).SaveIndData()
ClassMethod UpdateIndData(eobj As web.Entity.KB.DHCCheckDiseaseI) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		TS
		//日志
		s bobj = ##class(web.Entity.KB.DHCCheckDiseaseI).%New()
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
				s eobj.PHDDMode="I"
				s obj.PHDDMode = eobj.PHDDMode          
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

		//修改主索引表
				
		s objIns=##class(User.DHCPHInstructions).%OpenId(PHDDInstDr)
		s bobj.PHINSTMode=objIns.PHINSTMode //级别			
		s bobj.PHINSTSex=objIns.PHINSTSex //性别			
		s bobj.PHINSTText=objIns.PHINSTText //描述
		
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
		
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}
		else
		{
			Tc
			s result = "{success:'true',id:'"_PHDDInstDr_"'}" //返回RowId
			d:PHLICode="RADI" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","放射项目编辑器-适应症",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)
			d:PHLICode="ULTR" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","超声项目编辑器-适应症",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)
			d:PHLICode="ENDO" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","内镜项目编辑器-适应症",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)
			d:PHLICode="CHECK" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检验项目编辑器-适应症",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)
			d:PHLICode="TREAT" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","治疗项目编辑器-适应症",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)
		
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
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCCheckDiseaseI","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
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
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("RADIIndic","U"),0))
		}
		elseif(PHLICode="ULTR")  //超声
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ULTRIndic","U"),0))
		}
		elseif(PHLICode="ENDO") //内镜
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ENDOIndic","U"),0))
		}
		elseif(PHLICode="CHECK")  //检验
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("CheckIndic","U"),0))
		}
		else  //治疗项目
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("TreatIndic","U"),0))
		}
	}
			
	//s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("CheckIndic","U"),0))
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
/// Other:w ##class(web.DHCBL.KB.DHCCheckDiseaseI).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""
		TS
		//日志
		s bobj = ##class(web.Entity.KB.DHCCheckDiseaseI).%New()	
		//删除病症业务表
		s OPHDDDiseaDrs=""
		s PHDDRowId=0
		for
		{
			s PHDDRowId=$o(^DHCPHDDIS("0","Inst",id,PHDDRowId)) q:PHDDRowId=""
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
		s bobj.PHDDDiseaDrs=OPHDDDiseaDrs
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
		s objIns=##class(User.DHCPHInstructions).%OpenId(id)
		s bobj.PHINSTMode=objIns.PHINSTMode //级别			
		s bobj.PHINSTSex=objIns.PHINSTSex //性别			
		s bobj.PHINSTText=objIns.PHINSTText //描述
		
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
		s scInst=##class(User.DHCPHInstructions).%DeleteId(id)
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
			s result = "{success:'true',info:'删除成功！'}"	
			d:PHLICode="RADI" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","放射项目编辑器-适应症",id,bobj.PHINSTText,"D",bobj)
			d:PHLICode="ULTR" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","超声项目编辑器-适应症",id,bobj.PHINSTText,"D",bobj)
			d:PHLICode="ENDO" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","内镜项目编辑器-适应症",id,bobj.PHINSTText,"D",bobj)
			d:PHLICode="CHECK" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检验项目编辑器-适应症",id,bobj.PHINSTText,"D",bobj)
			d:PHLICode="TREAT" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","治疗项目编辑器-适应症",id,bobj.PHINSTText,"D",bobj)
			
		}
		q result
}

/// Description：根据主索引的id获取适应症数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCCheckDiseaseI).GetIndData("4")
ClassMethod GetIndData(InstId As %String) As %String
{

		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

/// Description：获取用法用量中已选病症的串
/// Other: w ##class(web.DHCBL.KB.DHCCheckDiseaseI).GetDiseaDr(67)
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

/// 查询适应症中病症已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCCheckDiseaseI","GetDiseaList","37")
Query GetDiseaList(InstId) As %Query(ROWSPEC = "PHDDRowId,PHDDDiseaDr,PHDISLDiseaCode,PHDISLDiseaDesc")
{
}

ClassMethod GetDiseaListExecute(ByRef qHandle As %Binary, InstId) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (InstId'=""){
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
/// Other:d ##class(web.DHCBL.KB.DHCCheckDiseaseI).DeleteDiseaData("121")
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

/// Description：查询未选病症字典的列表内容
/// Table：User.DHCPHDiseaseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCCheckDiseaseI","GetUnSelDiseaList","34")
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
				s PHDISLSysFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",4)
				s PHDISLRemark=$p($g(^DHCPHDISL(PHDISLRowId)),"^",5)
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHDISLDiseaDesc)
				if ('(selectStr[Code))&('(diseaStr[Code))&((PHDISLDiseaDescU[desc)||(PINYIN[desc))&(PHDISLActiveFlag'="N") //2016-08-09
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
