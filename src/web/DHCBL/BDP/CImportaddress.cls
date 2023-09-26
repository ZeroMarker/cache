/// 名称:基础数据平台组 
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2016-1-9
Class web.DHCBL.BDP.CImportaddress Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 去掉字符串末尾的空格
/// w ##class(web.DHCBL.BDP.CImportaddress).trim("    btnSearch    ")-->    btnSearch
ClassMethod trim(str) As %String
{
	While($e(str,*)=" ")
	{
		s str=$e(str,1,*-1)
	}
	q str
}

/// w ##class(web.DHCBL.BDP.CImportaddress).k()
ClassMethod k() As %String
{
	//BI Glolba数据
	
	k ^CT("ADD")   //地址
	k ^CT("CTCMUNT")  //社区
	k ^CT("LOCTYPE")  //街道
	k ^CT("CITAREA") //城市区域
	k ^CT("CIT")  //城市
	k ^CT("PROV")  //省
	k ^CT("ZIP")  //邮编
	q "SUCCESS"
}

/// w ##class(web.DHCBL.BDP.CImportaddress).ImportExcel("省","cs#省测试一#01##中国")
/// w ##class(web.DHCBL.BDP.CImportaddress).ImportExcel("街道","440103001#SMJD-沙面街道#440103##")
/// w ##class(web.DHCBL.BDP.CImportaddress).ImportExcel("社区","440103001111#SMJD-沙面社区#440103001##")
/// w ##class(web.DHCBL.BDP.CImportaddress).ImportExcel("地址","440103001#广东省广州市荔湾区沙面街道#gdsgzslwqsmjd#440000##440100##440103##440103001#SMJD-沙面街道#440103001111###")
/// w ##class(web.DHCBL.BDP.CImportaddress).ImportExcel("地址区域","qycs1#区域测试二#110108#HDQ-海淀区#")
/// 0 失败，1修改/新增，2 数据相同 不操作
ClassMethod ImportExcel(sheetname, datastr) As %String
{
	s result =0
	q:datastr="" 0
	if (sheetname["省") //User.CTProvince
	{
		s Code=$p(datastr,"#",1)
		q:Code="" result
		s Code1=..trim(Code)
		S flag=$d(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(Code1)))
		if (flag>0)
		{
			s id=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(Code1),0))
			s oobj=##class(User.CTProvince).%OpenId(id)
			s PROVCode=$p(datastr,"#",1)
			s PROVDesc=$p(datastr,"#",2)
			s PROVRegionDR=$p(datastr,"#",3)
			s:PROVRegionDR'="" PROVRegionDR=$o(^CT("RG",0,"Code",$$ALPHAUP^SSUTIL4(PROVRegionDR),0))  	
			///判断是否和原数据一样，一样则不修改
			
			s oPROVRegionDR=$p($g(^CT("PROV",id)),"^",3)
		
			s cstrnew="{list:[{PROVCode:"""_PROVCode_""",PROVDesc:"""_PROVDesc_""",PROVRegionDR:"""_PROVRegionDR_"""}]}"
   			s cstrold="{list:[{PROVCode:"""_oobj.PROVCode_""",PROVDesc:"""_oobj.PROVDesc_""",PROVRegionDR:"""_oPROVRegionDR_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改	   		
   			}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.CT.CTProvince).%New()
   				s eobj.PROVRowId=id
  				s eobj.PROVCode=$p(datastr,"#",1)
  				s eobj.PROVDesc=$p(datastr,"#",2)
  				s eobj.PROVRegionDR=$p(datastr,"#",3)
  				s:eobj.PROVRegionDR'="" eobj.PROVRegionDR=$o(^CT("RG",0,"Code",$$ALPHAUP^SSUTIL4(eobj.PROVRegionDR),0))  	
  				s eobj.PROVDateFrom=$tr($zd((+$H-1),3),"-","/")
   				s estr=##class(web.DHCBL.CT.CTProvince).SaveEntity(eobj)
   				if (estr["success:'true'")
				{
   					 s result=1  					
				}
				if (estr["success:'false'")
				{
					s result=0				
					s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
				}
   			}
   				
		}
		else
		{
			s eobj=##class(web.Entity.CT.CTProvince).%New()
   			s eobj.PROVRowId=""
  			s eobj.PROVCode=$p(datastr,"#",1)
  			s eobj.PROVDesc=$p(datastr,"#",2)
  			s eobj.PROVRegionDR=$p(datastr,"#",3)
  			s:eobj.PROVRegionDR'="" eobj.PROVRegionDR=$o(^CT("RG",0,"Code",$$ALPHAUP^SSUTIL4(eobj.PROVRegionDR),0))  	
			s eobj.PROVDateFrom=$tr($zd((+$H-1),3),"-","/")
 				
			s estr=##class(web.DHCBL.CT.CTProvince).SaveEntity(eobj)
			if (estr["success:'true'")
			{
				s result=1	 
			}
			if (estr["success:'false'")
			{
				s result=0
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}	
		}
		
	}
	
	if (sheetname="城市") //User.CTCity
	{
		s Code=$p(datastr,"#",1)
		q:Code="" result
		s Code1=..trim(Code)
		S flag=$d(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(Code1)))
		if (flag>0)
		{
			s id=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(Code1),0))
			s oobj=##class(User.CTCity).%OpenId(id)
			s CTCITCode=$p(datastr,"#",1)
			s CTCITDesc=$p(datastr,"#",2)
			s CTCITProvinceDR=$p(datastr,"#",3)
			s:CTCITProvinceDR'="" CTCITProvinceDR=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(CTCITProvinceDR),0))  	
			///判断是否和原数据一样，一样则不修改
			
			s oCTCITProvinceDR=$p($g(^CT("CIT",id)),"^",3)
		
			s cstrnew="{list:[{CTCITCode:"""_CTCITCode_""",CTCITDesc:"""_CTCITDesc_""",CTCITProvinceDR:"""_CTCITProvinceDR_"""}]}"
   			s cstrold="{list:[{CTCITCode:"""_oobj.CTCITCode_""",CTCITDesc:"""_oobj.CTCITDesc_""",CTCITProvinceDR:"""_oCTCITProvinceDR_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改	   		
   			}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.CT.CTCity).%New()
   				s eobj.CTCITRowId=id
  				s eobj.CTCITCode=$p(datastr,"#",1)
  				s eobj.CTCITDesc=$p(datastr,"#",2)
  				s eobj.CTCITProvinceDR=$p(datastr,"#",3)
  				s:eobj.CTCITProvinceDR'="" eobj.CTCITProvinceDR=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTCITProvinceDR),0))  	
  				s eobj.CTCITDateFrom=$tr($zd((+$H-1),3),"-","/")
   				s estr=##class(web.DHCBL.CT.CTCity).SaveEntity(eobj)
   				if (estr["success:'true'")
				{
   					 s result=1  					
				}
				if (estr["success:'false'")
				{
					s result=0				
					s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
				}
   			}
   				
		}
		else
		{
			s eobj=##class(web.Entity.CT.CTCity).%New()
   			s eobj.CTCITRowId=""
  			s eobj.CTCITCode=$p(datastr,"#",1)
  			s eobj.CTCITDesc=$p(datastr,"#",2)
  			s eobj.CTCITProvinceDR=$p(datastr,"#",3)
  			s:eobj.CTCITProvinceDR'="" eobj.CTCITProvinceDR=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTCITProvinceDR),0))  	
			s eobj.CTCITDateFrom=$tr($zd((+$H-1),3),"-","/")
 				
			s estr=##class(web.DHCBL.CT.CTCity).SaveEntity(eobj)
			if (estr["success:'true'")
			{
				s result=1	 
			}
			if (estr["success:'false'")
			{
				s result=0
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}	
		}
		
	}
	
	if (sheetname["城市区域") //User.CTAddress
	{
		s Code=$p(datastr,"#",1)
		q:Code="" result
		s Code1=..trim(Code)
		S flag=$d(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(Code1)))
		if (flag>0)
		{
			s id=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(Code1),0))
			s oobj=##class(User.CTCityArea).%OpenId(id)
			s CITAREACode=$p(datastr,"#",1)
			s CITAREADesc=$p(datastr,"#",2)
			s CITAREACityDR=$p(datastr,"#",3)
			s:CITAREACityDR'="" CITAREACityDR=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(CITAREACityDR),0))  	
			///判断是否和原数据一样，一样则不修改
			
			s oCITAREACityDR=$p($g(^CT("CITAREA",id)),"^",3)
		
			s cstrnew="{list:[{CITAREACode:"""_CITAREACode_""",CITAREADesc:"""_CITAREADesc_""",CITAREACityDR:"""_CITAREACityDR_"""}]}"
   			s cstrold="{list:[{CITAREACode:"""_oobj.CITAREACode_""",CITAREADesc:"""_oobj.CITAREADesc_""",CITAREACityDR:"""_oCITAREACityDR_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改	   		
   			}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.CT.CTCityArea).%New()
   				s eobj.CITAREARowId=id
  				s eobj.CITAREACode=$p(datastr,"#",1)
  				s eobj.CITAREADesc=$p(datastr,"#",2)
  				s eobj.CITAREACityDR=$p(datastr,"#",3)
  				s:eobj.CITAREACityDR'="" eobj.CITAREACityDR=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CITAREACityDR),0))  	
  				s eobj.CITAREADateFrom=$tr($zd((+$H-1),3),"-","/")
  				
   				s estr=##class(web.DHCBL.CT.CTCityArea).SaveEntity(eobj)
   				if (estr["success:'true'")
				{
   					 s result=1  					
				}
				if (estr["success:'false'")
				{
					s result=0				
					s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
				}
   			}
   				
		}
		else
		{
			s eobj=##class(web.Entity.CT.CTCityArea).%New()
   			s eobj.CITAREARowId=""
  			s eobj.CITAREACode=$p(datastr,"#",1)
  			s eobj.CITAREADesc=$p(datastr,"#",2)
  			s eobj.CITAREACityDR=$p(datastr,"#",3)
  			s:eobj.CITAREACityDR'="" eobj.CITAREACityDR=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CITAREACityDR),0))  	
			s eobj.CITAREADateFrom=$tr($zd((+$H-1),3),"-","/")
 				
			s estr=##class(web.DHCBL.CT.CTCityArea).SaveEntity(eobj)
			if (estr["success:'true'")
			{
				s result=1	 
			}
			if (estr["success:'false'")
			{
				s result=0
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}	
		}
		
	}
	
	/*if ((sheetname["街道")||(sheetname["社区")) //User.CTLocalityType
	{
		s Code=$p(datastr,"#",1)
		q:Code="" result
		s Code1=..trim(Code)
		S flag=$d(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(Code1)))
		if (flag>0)
		{
			s id=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(Code1),0))
			s oobj=##class(User.CTLocalityType).%OpenId(id)
			///判断是否和原数据一样，一样则不修改
			if oobj.LOCTYPEActiveFlag="" s oobj.LOCTYPEActiveFlag="N"
			S Flag=oobj.LOCTYPEActiveFlag
			IF Flag="" s Flag="Y"
   			s cstrnew="{list:[{LOCTYPECode:"""_$p(datastr,"#",1)_""",LOCTYPEDesc:"""_$p(datastr,"#",2)_""",LOCTYPENationalCode:"""_$p(datastr,"#",3)_""",LOCTYPEActiveFlag:"""_Flag_"""}]}"
   			s cstrold="{list:[{LOCTYPECode:"""_oobj.LOCTYPECode_""",LOCTYPEDesc:"""_oobj.LOCTYPEDesc_""",LOCTYPENationalCode:"""_oobj.LOCTYPENationalCode_""",LOCTYPEActiveFlag:"""_oobj.LOCTYPEActiveFlag_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改	   		
   			}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.CT.CTLocalityType).%New()
   				
				s eobj.LOCTYPECode = $p(datastr,"#",1)
   				s eobj.LOCTYPEDesc = $p(datastr,"#",2)
   				s eobj.LOCTYPENationalCode =$p(datastr,"#",3)
				s eobj.LOCTYPEActiveFlag=$p(datastr,"#",5)
  				s:eobj.LOCTYPEActiveFlag="" eobj.LOCTYPEActiveFlag="Y"  //默认激活
   				s estr=""
   				if (sheetname["街道")
   				{
	   				s eobj.LOCTYPERowId=id
	   				s:eobj.LOCTYPENationalCode'="" eobj.LOCTYPENationalCode=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(eobj.LOCTYPENationalCode),0))   				
	   				s eobj.LOCTYPEType="S"
	   				s estr=##class(web.DHCBL.CT.CTLocalityTypeOfStreet).SaveEntity(eobj)
   				}
   				if (sheetname["社区")
   				{
	   				s eobj.LOCTYPERowId=id
	   				s:eobj.LOCTYPENationalCode'="" eobj.LOCTYPENationalCode=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(eobj.LOCTYPENationalCode),0))
	   				s eobj.LOCTYPEType="C"
	   				s estr=##class(web.DHCBL.CT.CTLocalityType).SaveEntity(eobj)
   				}
  				
   				if (estr["success:'true'")
				{
   					 s result=1
				}
				if (estr["success:'false'")
				{
					s result=0
					s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
				}
			
   			}	
		}
		else
		{	
			s eobj=##class(web.Entity.CT.CTLocalityType).%New()
			s eobj.LOCTYPERowId=""
			s eobj.LOCTYPECode = $p(datastr,"#",1)
			s eobj.LOCTYPEDesc = $p(datastr,"#",2)
			s eobj.LOCTYPENationalCode =$p(datastr,"#",3)
			s eobj.LOCTYPEActiveFlag=$p(datastr,"#",5)
			s:eobj.LOCTYPEActiveFlag="" eobj.LOCTYPEActiveFlag="Y"  //默认激活
			s estr=""
			if (sheetname["街道")
			{
   				s:eobj.LOCTYPENationalCode'="" eobj.LOCTYPENationalCode=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(eobj.LOCTYPENationalCode),0))   				
   				s eobj.LOCTYPEType="S"
   				s estr=##class(web.DHCBL.CT.CTLocalityTypeOfStreet).SaveEntity(eobj)
			}
			if (sheetname["社区") 
			{
   				s:eobj.LOCTYPENationalCode'="" eobj.LOCTYPENationalCode=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(eobj.LOCTYPENationalCode),0))
   				s eobj.LOCTYPEType="C"
   				s estr=##class(web.DHCBL.CT.CTLocalityType).SaveEntity(eobj)
			}
			if (estr["success:'true'")
			{
				s result=1			
			}
			if (estr["success:'false'")
			{
				s result=0			
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}
			
		}
		
	}*/
	if (sheetname["街道")  //User.CTLocalityType
	{
		s Code=$p(datastr,"#",1)
		q:Code="" result
		s Code1=..trim(Code)
		S flag=$d(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(Code1)))
		if (flag>0)
		{
			s id=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(Code1),0))
			s oobj=##class(User.CTLocalityType).%OpenId(id)
			///判断是否和原数据一样，一样则不修改
			if oobj.LOCTYPEActiveFlag="" s oobj.LOCTYPEActiveFlag="N"
			S Flag=oobj.LOCTYPEActiveFlag
			IF Flag="" s Flag="Y"
   			s cstrnew="{list:[{LOCTYPECode:"""_$p(datastr,"#",1)_""",LOCTYPEDesc:"""_$p(datastr,"#",2)_""",LOCTYPENationalCode:"""_$p(datastr,"#",3)_""",LOCTYPEActiveFlag:"""_Flag_"""}]}"
   			s cstrold="{list:[{LOCTYPECode:"""_oobj.LOCTYPECode_""",LOCTYPEDesc:"""_oobj.LOCTYPEDesc_""",LOCTYPENationalCode:"""_oobj.LOCTYPENationalCode_""",LOCTYPEActiveFlag:"""_oobj.LOCTYPEActiveFlag_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改	   		
   			}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.CT.CTLocalityType).%New()
   				
				s eobj.LOCTYPECode = $p(datastr,"#",1)
   				s eobj.LOCTYPEDesc = $p(datastr,"#",2)
   				s eobj.LOCTYPENationalCode =$p(datastr,"#",3)
				s eobj.LOCTYPEActiveFlag=$p(datastr,"#",5)
  				s:eobj.LOCTYPEActiveFlag="" eobj.LOCTYPEActiveFlag="Y"  //默认激活
   				s estr=""

	   			s eobj.LOCTYPERowId=id
	   			s:eobj.LOCTYPENationalCode'="" eobj.LOCTYPENationalCode=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(eobj.LOCTYPENationalCode),0))   				
	   			s eobj.LOCTYPEType="S"
	   			s estr=##class(web.DHCBL.CT.CTLocalityTypeOfStreet).SaveEntity(eobj)
				
   				if (estr["success:'true'")
				{
   					 s result=1
				}
				if (estr["success:'false'")
				{
					s result=0
					s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
				}
			
   			}	
		}
		else
		{	
			s eobj=##class(web.Entity.CT.CTLocalityType).%New()
			s eobj.LOCTYPERowId=""
			s eobj.LOCTYPECode = $p(datastr,"#",1)
			s eobj.LOCTYPEDesc = $p(datastr,"#",2)
			s eobj.LOCTYPENationalCode =$p(datastr,"#",3)
			s eobj.LOCTYPEActiveFlag=$p(datastr,"#",5)
			s:eobj.LOCTYPEActiveFlag="" eobj.LOCTYPEActiveFlag="Y"  //默认激活
			s estr=""

   			s:eobj.LOCTYPENationalCode'="" eobj.LOCTYPENationalCode=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(eobj.LOCTYPENationalCode),0))   				
   			s eobj.LOCTYPEType="S"
   			s estr=##class(web.DHCBL.CT.CTLocalityType).SaveEntity(eobj)

			if (estr["success:'true'")
			{
				s result=1			
			}
			if (estr["success:'false'")
			{
				s result=0			
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}
			
		}
		
	}
	
	if (sheetname["社区") //User.CTCommunity
	{
		s Code=$p(datastr,"#",1)
		q:Code="" result
		s Code1=..trim(Code)
		S flag=$d(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(Code1)))
		if (flag>0)
		{
			s id=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(Code1),0))
			s oobj=##class(User.CTCommunity).%OpenId(id)
			///判断是否和原数据一样，一样则不修改
			if oobj.CTCMUNTActiveFlag="" s oobj.CTCMUNTActiveFlag="N"
			S Flag=oobj.CTCMUNTActiveFlag
			IF Flag="" s Flag="Y"
   			s cstrnew="{list:[{CTCMUNTCode:"""_$p(datastr,"#",1)_""",CTCMUNTDesc:"""_$p(datastr,"#",2)_""",CTCMUNTNationalCode:"""_$p(datastr,"#",3)_""",CTCMUNTActiveFlag:"""_Flag_"""}]}"
   			s cstrold="{list:[{CTCMUNTCode:"""_oobj.CTCMUNTCode_""",CTCMUNTDesc:"""_oobj.CTCMUNTDesc_""",CTCMUNTNationalCode:"""_oobj.CTCMUNTNationalCode_""",CTCMUNTActiveFlag:"""_oobj.CTCMUNTActiveFlag_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改	   		
   			}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.CT.CTCommunity).%New()
   				
				s eobj.CTCMUNTCode = $p(datastr,"#",1)
   				s eobj.CTCMUNTDesc = $p(datastr,"#",2)
   				s eobj.CTCMUNTNationalCode =$p(datastr,"#",3)
				s eobj.CTCMUNTActiveFlag=$p(datastr,"#",5)
  				s:eobj.CTCMUNTActiveFlag="" eobj.CTCMUNTActiveFlag="Y"  //默认激活
   				s eobj.CTCMUNTRowId=id
   				s:eobj.CTCMUNTNationalCode'="" eobj.CTCMUNTNationalCode=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTCMUNTNationalCode),0))
   				s estr=""
   				s estr=##class(web.DHCBL.CT.CTCommunity).SaveEntity(eobj)
   				
  				
   				if (estr["success:'true'")
				{
   					 s result=1
				}
				if (estr["success:'false'")
				{
					s result=0
					s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
				}
			
   			}	
		}
		else
		{	
			s eobj=##class(web.Entity.CT.CTCommunity).%New()
			s eobj.CTCMUNTRowId=""
			s eobj.CTCMUNTCode = $p(datastr,"#",1)
			s eobj.CTCMUNTDesc = $p(datastr,"#",2)
			s eobj.CTCMUNTNationalCode =$p(datastr,"#",3)
			s eobj.CTCMUNTActiveFlag=$p(datastr,"#",5)
			s:eobj.CTCMUNTActiveFlag="" eobj.CTCMUNTActiveFlag="Y"  //默认激活

			s:eobj.CTCMUNTNationalCode'="" eobj.CTCMUNTNationalCode=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTCMUNTNationalCode),0))
			s estr=""
			s estr=##class(web.DHCBL.CT.CTCommunity).SaveEntity(eobj)
		
			if (estr["success:'true'")
			{
				s result=1			
			}
			if (estr["success:'false'")
			{
				s result=0			
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}
			
		}
		
	}
	
	if (sheetname["地址") //User.CTAddress
	{
		s Code=$p(datastr,"#",1)
		q:Code="" result
		s Code1=..trim(Code)
		S flag=$d(^CT("ADD",0,"Code",$$ALPHAUP^SSUTIL4(Code1)))
		if (flag>0)
		{
			s id=$o(^CT("ADD",0,"Code",$$ALPHAUP^SSUTIL4(Code1),0))
			s oobj=##class(User.CTAddress).%OpenId(id)
			s CTADDCode=$p(datastr,"#",1)
			s CTADDDesc=$p(datastr,"#",2)
			s CTADDSearchCode=$p(datastr,"#",3)
			s CTADDProvinceDR=$p(datastr,"#",4)
			s:CTADDProvinceDR'="" CTADDProvinceDR=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(CTADDProvinceDR),0))  
			s CTADDCityDR=$p(datastr,"#",6)
			s:CTADDCityDR'="" CTADDCityDR=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(CTADDCityDR),0))  	
			s CTADDCityAreaDR=$p(datastr,"#",8)
			s:CTADDCityAreaDR'="" CTADDCityAreaDR=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(CTADDCityAreaDR),0)) 
			s CTADDStreetDR=$p(datastr,"#",10)
			s:CTADDStreetDR'="" CTADDStreetDR=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(CTADDStreetDR),0)) 
			s CTADDCommunityDR=$p(datastr,"#",12)
			//s:CTADDCommunityDR'="" CTADDCommunityDR=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(CTADDCommunityDR),0))
			s:CTADDCommunityDR'="" CTADDCommunityDR=$o(^CT("CTCMUNT",0,"Code",$$ALPHAUP^SSUTIL4(CTADDCommunityDR),0))
			///判断是否和原数据一样，一样则不修改
			
			s oCTADDProvinceDR=$p($g(^CT("ADD",id)),"^",3)
			s oCTADDCityDR=$p($g(^CT("ADD",id)),"^",4)
			s oCTADDCityAreaDR=$p($g(^CT("ADD",id)),"^",5)
			s oCTADDStreetDR=$p($g(^CT("ADD",id)),"^",7)
			s oCTADDCommunityDR=$p($g(^CT("ADD",id)),"^",6)
			
			s cstrnew="{list:[{CTADDCode:"""_CTADDCode_""",CTADDDesc:"""_CTADDDesc_""",CTADDSearchCode:"""_CTADDSearchCode_""",CTADDProvinceDR:"""_CTADDProvinceDR_""",CTADDCityDR:"""_CTADDCityDR_""",CTADDCityAreaDR:"""_CTADDCityAreaDR_""",CTADDStreetDR:"""_CTADDStreetDR_""",CTADDCommunityDR:"""_CTADDCommunityDR_"""}]}"
   			s cstrold="{list:[{CTADDCode:"""_oobj.CTADDCode_""",CTADDDesc:"""_oobj.CTADDDesc_""",CTADDSearchCode:"""_oobj.CTADDSearchCode_""",CTADDProvinceDR:"""_oCTADDProvinceDR_""",CTADDCityDR:"""_oCTADDCityDR_""",CTADDCityAreaDR:"""_oCTADDCityAreaDR_""",CTADDStreetDR:"""_oCTADDStreetDR_""",CTADDCommunityDR:"""_oCTADDCommunityDR_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改	   		
   			}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.CT.CTAddress).%New()
   				s eobj.CTADDRowId=id
  				s eobj.CTADDCode=$p(datastr,"#",1)
  				s eobj.CTADDDesc=$p(datastr,"#",2)
  				///　拼音码
 				s eobj.CTADDSearchCode=$p(datastr,"#",3)
  				s eobj.CTADDProvinceDR=$p(datastr,"#",4)
  				s:eobj.CTADDProvinceDR'="" eobj.CTADDProvinceDR=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDProvinceDR),0))  
  				s eobj.CTADDCityDR=$p(datastr,"#",6)
  				s:eobj.CTADDCityDR'="" eobj.CTADDCityDR=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDCityDR),0))  	
  				s eobj.CTADDCityAreaDR=$p(datastr,"#",8)
  				s:eobj.CTADDCityAreaDR'="" eobj.CTADDCityAreaDR=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDCityAreaDR),0)) 
  				s eobj.CTADDStreetDR=$p(datastr,"#",10)
 				s:eobj.CTADDStreetDR'="" eobj.CTADDStreetDR=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDStreetDR),0)) 
  				s eobj.CTADDCommunityDR=$p(datastr,"#",12)
  				//s:eobj.CTADDCommunityDR'="" eobj.CTADDCommunityDR=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDCommunityDR),0))
  				s:eobj.CTADDCommunityDR'="" eobj.CTADDCommunityDR=$o(^CT("CTCMUNT",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDCommunityDR),0))
 				s eobj.CTADDDateFrom=$tr($zd((+$H-1),3),"-","/")

   				s estr=##class(web.DHCBL.CT.CTAddress).SaveEntity(eobj)
   				if (estr["success:'true'")
				{
   					 s result=1  					
				}
				if (estr["success:'false'")
				{
					s result=0					
					s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
				}
   			}	
		}
		else
		{	
			s eobj=##class(web.Entity.CT.CTAddress).%New()
			s eobj.CTADDRowId=""
			s eobj.CTADDCode=$p(datastr,"#",1)
			s eobj.CTADDDesc=$p(datastr,"#",2)		
			s eobj.CTADDSearchCode=$p(datastr,"#",3)
			s eobj.CTADDProvinceDR=$p(datastr,"#",4)
			s:eobj.CTADDProvinceDR'="" eobj.CTADDProvinceDR=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDProvinceDR),0))  
			s eobj.CTADDCityDR=$p(datastr,"#",6)
			s:eobj.CTADDCityDR'="" eobj.CTADDCityDR=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDCityDR),0))  
			s eobj.CTADDCityAreaDR=$p(datastr,"#",8)
			s:eobj.CTADDCityAreaDR'="" eobj.CTADDCityAreaDR=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDCityAreaDR),0)) 
			s eobj.CTADDStreetDR=$p(datastr,"#",10)
			s:eobj.CTADDStreetDR'="" eobj.CTADDStreetDR=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDStreetDR),0)) 
			s eobj.CTADDCommunityDR=$p(datastr,"#",12)
			//s:eobj.CTADDCommunityDR'="" eobj.CTADDCommunityDR=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDCommunityDR),0))
			s:eobj.CTADDCommunityDR'="" eobj.CTADDCommunityDR=$o(^CT("CTCMUNT",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTADDCommunityDR),0))
			s eobj.CTADDDateFrom=$tr($zd((+$H-1),3),"-","/")
 				
			s estr=##class(web.DHCBL.CT.CTAddress).SaveEntity(eobj)
			if (estr["success:'true'")
			{
				s result=1	 
			}
			if (estr["success:'false'")
			{
				s result=0
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}	
		}
		
	}
	if (sheetname["邮编") //User.CTAddress
	{
		s Code=$p(datastr,"#",1)
		s Desc=$p(datastr,"#",2)
		q:Code="" result
		q:Desc="" result
		s Code1=..trim(Code)
		s nDesc=..trim(Desc)
		s CodeLen=$Length(Code1)     //数字的长度
		s nCode=$e("000000",1,6-CodeLen)_Code1  //组合
		S flagc=$d(^CT("ZIP",0,"Code",$$ALPHAUP^SSUTIL4(nCode)))
		S flagd=$d(^CT("ZIP",0,"Desc",$$ALPHAUP^SSUTIL4(nDesc)))
		
		s flag=0
		s id=""
		if ((flagc>0)&(flagd>0))
		{
			s idc=0
			for
			{
				s idc=$o(^CT("ZIP",0,"Code",$$ALPHAUP^SSUTIL4(nCode),idc)) q:idc=""
				s CTZIPDesc=$p($g(^CT("ZIP",idc)),"^",2) 
				if (CTZIPDesc=nDesc)
				{
					s flag=1  //返回重复标志
					s id=idc
				}
			}
		}
		if (flag>0)
		{
			//s id=$o(^CT("ZIP",0,"Code",$$ALPHAUP^SSUTIL4(nCode),0))
			s oobj=##class(User.CTZip).%OpenId(id)
			s CTZIPCode=nCode
			s CTZIPDesc=nDesc
			s CTZIPRegionDR=$p(datastr,"#",3)
			s:CTZIPRegionDR'="" CTZIPRegionDR=$o(^CT("RG",0,"Code",$$ALPHAUP^SSUTIL4(CTZIPRegionDR),0))  
			s CTZIPProvinceDR=$p(datastr,"#",5)
			s:CTZIPProvinceDR'="" CTZIPProvinceDR=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(CTZIPProvinceDR),0))  	
			s CTZIPCITYDR=$p(datastr,"#",7)
			s:CTZIPCITYDR'="" CTZIPCITYDR=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(CTZIPCITYDR),0)) 
			s CTZIPCITYAREADR=$p(datastr,"#",9)
			s:CTZIPCITYAREADR'="" CTZIPCITYAREADR=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(CTZIPCITYAREADR),0)) 
		
			///判断是否和原数据一样，一样则不修改
			
			s oCTZIPRegionDR=$p($g(^CT("ZIP",id)),"^",3)
			s oCTZIPProvinceDR=$p($g(^CT("ZIP",id)),"^",4)
			s oCTZIPCITYDR=$p($g(^CT("ZIP",id)),"^",6)
			s oCTZIPCITYAREADR=$p($g(^CT("ZIP",id)),"^",7)
			
			s cstrnew="{list:[{CTZIPCode:"""_nCode_""",CTZIPDesc:"""_CTZIPDesc_""",CTZIPRegionDR:"""_CTZIPRegionDR_""",CTZIPProvinceDR:"""_CTZIPProvinceDR_""",CTZIPCITYDR:"""_CTZIPCITYDR_""",CTZIPCITYAREADR:"""_CTZIPCITYAREADR_"""}]}"
   			s cstrold="{list:[{CTZIPCode:"""_oobj.CTZIPCode_""",CTZIPDesc:"""_oobj.CTZIPDesc_""",CTZIPRegionDR:"""_oCTZIPRegionDR_""",CTZIPProvinceDR:"""_oCTZIPProvinceDR_""",CTZIPCITYDR:"""_oCTZIPCITYDR_""",CTZIPCITYAREADR:"""_oCTZIPCITYAREADR_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改	   		
   			}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.CT.CTZip).%New()
   				s eobj.CTZIPRowId=id
  				s eobj.CTZIPCode=nCode
  				s eobj.CTZIPDesc=nDesc
  				
  				s eobj.CTZIPRegionDR=$p(datastr,"#",3)
 				s:eobj.CTZIPRegionDR'="" eobj.CTZIPRegionDR=$o(^CT("RG",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTZIPRegionDR),0)) 
  				s eobj.CTZIPProvinceDR=$p(datastr,"#",5)
  				s:eobj.CTZIPProvinceDR'="" eobj.CTZIPProvinceDR=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTZIPProvinceDR),0))  
  				s eobj.CTZIPCITYDR=$p(datastr,"#",7)
  				s:eobj.CTZIPCITYDR'="" eobj.CTZIPCITYDR=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTZIPCITYDR),0))  	
  				s eobj.CTZIPCITYAREADR=$p(datastr,"#",9)
  				s:eobj.CTZIPCITYAREADR'="" eobj.CTZIPCITYAREADR=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTZIPCITYAREADR),0)) 
  				s eobj.CTZIPDateFrom=$tr($zd((+$H-1),3),"-","/")

   				s estr=##class(web.DHCBL.CT.CTZip).SaveEntity(eobj)
   				if (estr["success:'true'")
				{
   					 s result=1  					
				}
				if (estr["success:'false'")
				{
					s result=0					
					s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
				}
   			}	
		}
		else
		{	
			s eobj=##class(web.Entity.CT.CTZip).%New()
			s eobj.CTZIPRowId=""
			s eobj.CTZIPCode=nCode
			s eobj.CTZIPDesc=nDesc
			s eobj.CTZIPRegionDR=$p(datastr,"#",3)
			s:eobj.CTZIPRegionDR'="" eobj.CTZIPRegionDR=$o(^CT("RG",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTZIPRegionDR),0)) 

			s eobj.CTZIPProvinceDR=$p(datastr,"#",5)
			s:eobj.CTZIPProvinceDR'="" eobj.CTZIPProvinceDR=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTZIPProvinceDR),0))  
			s eobj.CTZIPCITYDR=$p(datastr,"#",7)
			s:eobj.CTZIPCITYDR'="" eobj.CTZIPCITYDR=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTZIPCITYDR),0))  
			s eobj.CTZIPCITYAREADR=$p(datastr,"#",9)
			s:eobj.CTZIPCITYAREADR'="" eobj.CTZIPCITYAREADR=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTZIPCITYAREADR),0)) 
			s eobj.CTZIPDateFrom=$tr($zd((+$H-1),3),"-","/")
 				
			s estr=##class(web.DHCBL.CT.CTZip).SaveEntity(eobj)
			if (estr["success:'true'")
			{
				s result=1	 
			}
			if (estr["success:'false'")
			{
				s result=0
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}	
		}
		
	}
	q result
}

}
