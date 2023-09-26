Import SQLUser

/// 名称:导入手术知识库模板
/// 编写者：基础平台组 -谷雪萍
/// 编写日期: 2020-04-28
Class web.DHCBL.BDP.ImportOPERATIONData Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：前台导入手术编辑器模板数据调用的方法
/// Input: dataStr-数据拼串，sheetid-模板中第几个Excel，row-行号
/// Return:成功返回true，失败返回false
/// Others:s str="NK0001[next]鼻咽镜检查[next]鼻咽镜检查[next]鼻咽镜检查[next]内镜[next]byj/byjjc[next]头部[next]"
/// Others:w ##class(web.DHCBL.BDP.ImportOPERATIONData).SaveData(str,11,1)
ClassMethod SaveData(dataStr As %String, sheetid As %String, row As %Float) As %String
{
	
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.ImportKBData).EvalJSON(dataStr)	
	
 	/// Function:保存知识库标识字典
	s:sheetid=2 result=##class(web.DHCBL.BDP.ImportKBData).SaveLibaryLabel(dataStr)

	/// Function:保存知识库目录字典
	s:sheetid=3 result=##class(web.DHCBL.BDP.ImportKBData).SaveInstLabel(dataStr)
	
	/// Function:保存检查部位
	s:sheetid=4 result=##class(web.DHCBL.BDP.ImportCheckData).SavePart(dataStr)
	
	/// Function:保存诊断字典对照
	s:sheetid=5 result=##class(web.DHCBL.BDP.ImportKBData).SaveIcd(dataStr)
	
	/// Function:保存单位字典对照
	s:sheetid=6 result=##class(web.DHCBL.BDP.ImportKBData).SaveExtUom(dataStr)
	
	/// Function:保存特殊人群字典
	s:sheetid=7 result=##class(web.DHCBL.BDP.ImportKBData).SaveSpecialPopu(dataStr)
	
    /// Function:保存病症字典
	s:sheetid=8 result=##class(web.DHCBL.BDP.ImportKBData).SaveDiseaseList(dataStr)
	
	 /// Function:保存年龄字典
	s:sheetid=9 result=##class(web.DHCBL.BDP.ImportKBData).SaveAge(dataStr)

	/// Function:保存手术通用名
	s:sheetid=10 result=..SaveOperGeneric(dataStr)	
	
	/// Function:保存检验项目通用名
	s:sheetid=11 result=##class(web.DHCBL.BDP.ImportLABData).SaveLABGeneric(dataStr)
	
	/// Function:保存检查项目通用名
	s:sheetid=12 result=##class(web.DHCBL.BDP.ImportCheckData).SaveGeneric(dataStr)
	
	/// Function:保存检查测值通用名 
	s:sheetid=13 result=..SaveCheckValuesGeneric(dataStr)
	
	/// Function:保存高危提醒
	s:sheetid=14 result=..SaveOPERRemind(dataStr,row)
	
	/// Function:保存术前检验 
	s:sheetid=15 result=..SavePreoperLab(dataStr,row)
	
	/// Function:保存术前检验质控
	s:sheetid=16 result=..SavePreoperLabContr(dataStr,row)
	
	/// Function:保存术前检查
	s:sheetid=17 result=..SavePreoperCheck(dataStr,row)
	
	/// Function:保存术前检查质控
	s:sheetid=18 result=..SavePreoperCheckContr(dataStr,row)
	

	q result
}

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：手术通用名Excel保存方法
/// Input: dataStr-数据拼串
/// Return:成功返回true，失败返回false  
/// Others:s str="0.11001[next]输注重组蛋白[next]0.11001[next]输注重组蛋白[next]手术[next]szczdb/cs[next]头部[next]"
/// Others:w ##class(web.DHCBL.BDP.ImportOPERATIONData).SaveOperGeneric(str)
ClassMethod SaveOperGeneric(dataStr As %String) As %String
{
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)	
	s desc=$p(dataStr,"[next]",4)
	s lib=$p(dataStr,"[next]",5)
	s keys=$p(dataStr,"[next]",6)
	s part=$p(dataStr,"[next]",7)

	Ts

	//1判断必填项
	if ((code="")||(desc="")||(lib=""))
	{   
	    s result=result_"^"_0
    }
    else
    { 
   		s result=result_"^"_1 
   		//2知识库标识是否正确  
   	    if (lib'="")
   	    {
		     s lib=$ZCONVERT(lib,"U")
		     s lib=$o(^DHCPHLIBL(0,"Desc",lib,0))
		     if (lib="")
		     {
			     s result=result_"^"_0
		     }
		     else
		     {
			    s result=result_"^"_1 
		     }
	    }
		//3部位是否正确 
	    if (part'=""){
		     s part=$ZCONVERT(part,"U") //转换成大写
		     s part=$o(^DHCPHEPA(0,"Desc",part,0))
		     if (part="")
		     {
			     s result=result_"^"_0
		     }
		     else
		     {
			    s result=result_"^"_1 
		     }
	    }  
	
		//4保存到通用名字典表	
	    s eobj=##class(web.Entity.KB.DHCPHExtGeneric).%New() 
	    s eobj.PHEGCode=code
	    s eobj.PHEGDesc=desc
	    s eobj.PHEGLibDr=lib
	    s eobj.PHEGActiveFlag="Y"
	    s eobj.PHEGSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtGeneric).SaveData(eobj)
	    if (str1["true")
	    {   
		    s result=result_"^"_1
	    }
	    else
	    {        
			if (str1["该记录已经存在")
			{
			 	s result=result_"^"_1   
		    }
		    else
		    {
			    s result=result_"^"_0
		    }
		    
	    }
	   
	    s upcode=$ZCONVERT(code,"U") //转换成大写
	    s updesc=$ZCONVERT(desc,"U")  //转换成大写
		s idc=$o(^DHCPHEGENi(0,"Code",upcode,0))
		s idd=$o(^DHCPHEGENi(0,"Desc",updesc,0))
		 //5 判断填入的通用名是否正确，正确则继续插入与通用名字典关联的表
	    if ((idc="")||(idd="")||(idc'=idd))
		{ 
			s result=result_"^"_0
		}
		else
		{
			s result=result_"^"_1
        	
			if ((hiscode'="")&(hisdesc'="")) 
			{  
				s uphiscode=$$ALPHAUP^SSUTIL4(hiscode) //转换成大写
				s hiscid=$o(^ORC("OPER",0,"Code",uphiscode,""),-1) 
				s uphisdesc=$$ALPHAUP^SSUTIL4(hisdesc) //转换成大写
				s hisdid=$o(^ORC("OPER",0,"Desc",uphisdesc,""),-1) 

				//b ;hiscid,hisdid,idc,idd
				//6判断填入的his数据是否正确
				if (hiscid="")
				{ 
					 s result=result_"^"_0
				}
				else
				{
					s ids=idc_"^"_hiscid
					// 7保存到通用名和HIS对照表
					s str2 = ##class(web.DHCBL.KB.DHCPHOrcOpContrast).SaveData(ids)
					if (str2["true")
					{
					    s result=result_"^"_1
				    }
				    else
				    {
					    if (str2["不能重复对照")
					    {
						    s result=result_"^"_1
					    }
					    else
					    {
						    s result=result_"^"_0
					    }
				    }
				}
			}
		
	    	//8保存到通用名别名表
	   		if (keys'="") 
	   		{	   	
				s argsLen=$Length(keys,"/")
				for i=1:1:argsLen		
				{
					s key=$p(keys,"/",i)	

				    s eobjga=##class(web.Entity.KB.DHCPHExtGenAlias).%New()
				    s eobjga.PHEGAlGenDr=idc
				    s eobjga.PHEGAlText=key
				    s eobjga.PHEGAlLibDr=lib
				    s eobjga.PHEGAlSysFlag="Y"
				    s str1 = ##class(web.DHCBL.KB.DHCPHExtGenAlias).SaveData(eobjga)
				    if (str1["true")
				    {   
					    s result=result_"^"_1
				    }
				    else
				    {        
					    if (str1["该记录已经存在")
					    {
						 	s result=result_"^"_1   
					    }
					    else
					    {
						    s result=result_"^"_0
					    }
				    }				
				}	 
					
	    	}
	    	
	    	//9 保存到通用名与部位关联表
	   		if (part'="") 
	   		{	   	
			 	s eobjglp=##class(web.Entity.KB.DHCGenLinkPointer).%New()
			 	s eobjglp.GlPGenDr=idc
			 	s eobjglp.GlPPointer=part
			    s eobjglp.GlPActiveFlag="Y"
			    s eobjglp.GlPSysFlag="Y"
			    s str1 = ##class(web.DHCBL.KB.DHCGenLinkPointer).SaveData(eobjglp)
			    if (str1["true")
			    {   
				    s result=result_"^"_1
			    }
			    else
			    {        
				    if (str1["该记录已经存在")
				    {
					 	s result=result_"^"_1   
				    }
				    else
				    {
					    s result=result_"^"_0
				    }
			    }							 
					
	    	}
	    	
	    	
		}
	    
	    
    }
	//b ;
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

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：检查测值通用名Excel保存方法
/// Input: dataStr-数据拼串
/// Return:成功返回true，失败返回false
/// Others:s str="NK0001[next]主动脉内镜AO[next]NK0001[next]主动脉内镜AO[next]检查测值[next]zdmnj/zdmnjao"
/// Others:w ##class(web.DHCBL.BDP.ImportOPERATIONData).SaveCheckValuesGeneric(str)
ClassMethod SaveCheckValuesGeneric(dataStr As %String) As %String
{
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)	
	s desc=$p(dataStr,"[next]",4)
	s lib=$p(dataStr,"[next]",5)
	s keys=$p(dataStr,"[next]",6)
	s part=$p(dataStr,"[next]",7)

	Ts

	//1判断必填项
	if ((code="")||(desc="")||(lib=""))
	{   
	    s result=result_"^"_0
    }
    else
    { 
   		s result=result_"^"_1 
   		//2知识库标识是否正确  
   	    if (lib'="")
   	    {
		     s lib=$ZCONVERT(lib,"U")
		     s lib=$o(^DHCPHLIBL(0,"Desc",lib,0))
		     if (lib="")
		     {
			     s result=result_"^"_0
		     }
		     else
		     {
			    s result=result_"^"_1 
		     }
	    }
		//3部位是否正确 
	    if (part'=""){
		     s part=$ZCONVERT(part,"U") //转换成大写
		     s part=$o(^DHCPHEPA(0,"Desc",part,0))
		     if (part="")
		     {
			     s result=result_"^"_0
		     }
		     else
		     {
			    s result=result_"^"_1 
		     }
	    }  
	
		//4保存到通用名字典表	
	    s eobj=##class(web.Entity.KB.DHCPHExtGeneric).%New() 
	    s eobj.PHEGCode=code
	    s eobj.PHEGDesc=desc
	    s eobj.PHEGLibDr=lib
	    s eobj.PHEGActiveFlag="Y"
	    s eobj.PHEGSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtGeneric).SaveData(eobj)
	    if (str1["true")
	    {   
		    s result=result_"^"_1
	    }
	    else
	    {        
			if (str1["该记录已经存在")
			{
			 	s result=result_"^"_1   
		    }
		    else
		    {
			    s result=result_"^"_0
		    }
		    
	    }
	   
	    s upcode=$ZCONVERT(code,"U") //转换成大写
	    s updesc=$ZCONVERT(desc,"U")  //转换成大写
		s idc=$o(^DHCPHEGENi(0,"Code",upcode,0))
		s idd=$o(^DHCPHEGENi(0,"Desc",updesc,0))
		 //5判断填入的通用名是否正确，正确则继续插入与通用名字典关联的表
	    if ((idc="")||(idd="")||(idc'=idd))
		{ 
			s result=result_"^"_0
		}
		else
		{
			s result=result_"^"_1
			//6保存到通用名和HIS对照表
		   	if ((hiscode'="")&(hisdesc'="")) 
		   	{ 
				s hisRowId=""
				s ids=idc_"^"_hisRowId_"^"_hiscode_"^"_hisdesc
				s str2 = ##class(web.DHCBL.KB.DHCGenItmContrast).SaveCheckValues(ids)		
				if (str2["true") //保存成功
				{
				    s result=result_"^"_1
			    }
			    else
			    {
				    if (str2["不能重复对照")
				    {
					    s result=result_"^"_1
				    }
				    else
				    {
					    s result=result_"^"_0
				    }
			    }
		   	}
		   	//7保存到通用名别名表
	   		if (keys'="") 
	   		{	   	
				s argsLen=$Length(keys,"/")
				for i=1:1:argsLen		
				{
					s key=$p(keys,"/",i)	
				    s eobjga=##class(web.Entity.KB.DHCPHExtGenAlias).%New()
				    s eobjga.PHEGAlGenDr=idc
				    s eobjga.PHEGAlText=key
				    s eobjga.PHEGAlLibDr=lib
				    s eobjga.PHEGAlSysFlag="Y"
				    s str1 = ##class(web.DHCBL.KB.DHCPHExtGenAlias).SaveData(eobjga)
				    if (str1["true")
				    {   
					    s result=result_"^"_1
				    }
				    else
				    {        
					    if (str1["该记录已经存在")
					    {
						 	s result=result_"^"_1   
					    }
					    else
					    {
						    s result=result_"^"_0
					    }
				    }				
				}	 
					
	    	}
		    	
	    	//8保存到检查通用名与部位关联表
	   		if (part'="") 
	   		{	   	
			 	s eobjglp=##class(web.Entity.KB.DHCGenLinkPointer).%New()
			 	s eobjglp.GlPGenDr=idc
			 	s eobjglp.GlPPointer=part
			    s eobjglp.GlPActiveFlag="Y"
			    s eobjglp.GlPSysFlag="Y"
			    s str1 = ##class(web.DHCBL.KB.DHCGenLinkPointer).SaveData(eobjglp)
			    if (str1["true")
			    {   
				    s result=result_"^"_1
			    }
			    else
			    {        
				    if (str1["该记录已经存在")
				    {
					 	s result=result_"^"_1   
				    }
				    else
				    {
					    s result=result_"^"_0
				    }
			    }							 
				
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

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：保存高危提醒
/// Input: dataStr-excel中用[next]连接的一行单元格数据，row-行号
/// Return:成功返回true，失败返回false
/// Others:w ##class(web.DHCBL.BDP.ImportOPERATIONData).SaveCheckValuesGeneric(dataStr,row)
ClassMethod SaveOPERRemind(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for
	{
		s seq=$o(^TEMPOPER("OPERRemind",seq))
		q:seq=""
		s str=^TEMPOPER("OPERRemind",seq)
		if (str=dataStr) 
		{
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s lib="手术"
		s mode=$p(dataStr,"[next]",1)
		s gen=$p(dataStr,"[next]",2)
		s part=$p(dataStr,"[next]",3)
		s dis=$p(dataStr,"[next]",4)
		s age=$p(dataStr,"[next]",5)
		s agelimit=$p(dataStr,"[next]",6)	
		s BMIlimit=$p(dataStr,"[next]",7)
		s SBPlimit=$p(dataStr,"[next]",8)
		s DBPlimit=$p(dataStr,"[next]",9)
		s special=$p(dataStr,"[next]",10)
		s text=$p(dataStr,"[next]",11)

		//1判断必填项
		if ((gen="")||(part="")||(lib="")||(text=""))
		{   
		   q "false"
	    }

	    //通用名
		s gen=##class(web.DHCBL.BDP.ImportCheckData).getGenId(gen,lib)
		q:gen="" "false" 	   
		//部位
		s part=##class(web.DHCBL.BDP.ImportCheckData).getPartId(part)
		q:part="" "false"
		
		//通用名和部位关联表
		s isLink=##class(web.DHCBL.BDP.ImportKBData).getLinkORNo(gen,part)
		q:(isLink'="true") "false"
	
		//控制级别
		s:mode="警示" mode="W"
		s:mode="管控" mode="C"
		s:mode="统计" mode="S"
		if ((mode'="W")&(mode'="C")&(mode'="S"))
		{
			s mode="W"
		}	
			
		s eobj=##class(web.Entity.KB.DHCOPERRemind).%New()

		//插入主索引表			
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=part		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		s eobj.PHINSTMode=mode
	
		//判断填入的病症是否正确
		if (dis'="")
		{
			s disdr=##class(web.DHCBL.BDP.ImportKBData).getDisIds(dis)
			q:(disdr="false") "false"
			s eobj.PHDDDiseaDr=disdr
		}
		
		//年龄
		if (age'="")
		{
			s age=##class(web.DHCBL.BDP.ImportKBData).getAgeId(age)
			q:(age="false") "false"		
			s eobj.PDAAgeDr=age						
		
		}
		//年龄限制
		if (agelimit'="")
		{
			s agelimit=$tr(agelimit,"岁","年")
			s ageMin=$p(agelimit,"-",1)
			s ageMax=$p($p(agelimit,"-",2),"/",1)
			s ageUom=$p($p(agelimit,"-",2),"/",2)
			//单位
			if (ageUom'="")
			{
				s PDAUomDr=##class(web.DHCBL.BDP.ImportKBData).getUomId(ageUom)
				q:PDAUomDr="false" "false"
				s eobj.PDAUomDr=PDAUomDr
			} 
			s eobj.PDAMaxVal=ageMax
			s eobj.PDAMinVal=ageMin
		
		}
		//BMI值
		if (BMIlimit'="")
		{
			s eobj.PHINSTBMIMin=$p(BMIlimit,"-",1)
			s eobj.PHINSTBMIMax=$p(BMIlimit,"-",2)
		}
		//收缩压
		if (SBPlimit'="")
		{
			s eobj.SysPressMinVal=$p(SBPlimit,"-",1)
			s eobj.SysPressMaxVal=$p(SBPlimit,"-",2)
		}
		//舒张压
		if (DBPlimit'="")
		{
			s eobj.DiaPressMinVal=$p(DBPlimit,"-",1)
			s eobj.DiaPressMaxVal=$p(DBPlimit,"-",2)
		}
		//特殊人群special
		s popu=""
		if (special'="")
		{				
			s popu=##class(web.DHCBL.BDP.ImportKBData).getSpecialPopuIds(special)
			q:(popu="false") "false"	
			s eobj.SpecialPopu=popu
		}
		s str = ##class(web.DHCBL.KB.DHCOPERRemind).SaveRemindData(eobj)
		if (str["false"){   
			q "false"
		}

		s result = "true"
		s ^TEMPOPER("OPERRemind",row)=dataStr	
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：保存术前检查
/// Input: dataStr-excel中用[next]连接的一行单元格数据，row-行号
/// Return:成功返回true，失败返回false
/// Others:s dataStr="管控[next]输注重组蛋白[next]头部[next]成人[next]18-60/年[next]钾离子[next]是[next]术前检查测试数据[next]"
/// Others:w ##class(web.DHCBL.BDP.ImportOPERATIONData).SavePreoperLab(dataStr,row)
ClassMethod SavePreoperLab(dataStr As %String, row As %Float) As %String
{
	s ^TMPGXP=dataStr
	s result=""
	s flag=""
	s seq=0
	for
	{
		s seq=$o(^TEMPOPER("PreoperLab",seq))
		q:seq=""
		s str=^TEMPOPER("PreoperLab",seq)
		if (str=dataStr) 
		{
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
	 	s lib="手术"
	 	s mode=$p(dataStr,"[next]",1)
		s gen=$p(dataStr,"[next]",2)
		s part=$p(dataStr,"[next]",3)
		s age=$p(dataStr,"[next]",4)
		s agelimit=$p(dataStr,"[next]",5)
		s Lab=$p(dataStr,"[next]",6)	
		s RepFlag=$p(dataStr,"[next]",7)
		s text=$p(dataStr,"[next]",8)
		
		//1判断必填项
		if ((gen="")||(part="")||(lib="")||(text=""))
		{   
		    q "false"
	    }

	    //通用名
		s gen=##class(web.DHCBL.BDP.ImportCheckData).getGenId(gen,lib)
		q:gen="" "false" 	   
		//部位
		s part=##class(web.DHCBL.BDP.ImportCheckData).getPartId(part)
		q:part="" "false"
		
		//通用名和部位关联表
		s isLink=##class(web.DHCBL.BDP.ImportKBData).getLinkORNo(gen,part)
		q:(isLink'="true") "false"
	
		//控制级别
		s:mode="警示" mode="W"
		s:mode="管控" mode="C"
		s:mode="统计" mode="S"
		if ((mode'="W")&(mode'="C")&(mode'="S"))
		{
			s mode="W"
		}	
		
		s eobj=##class(web.Entity.KB.DHCPreoperLab).%New()
	
		//插入主索引表			
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=part		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		s eobj.PHINSTMode=mode
		s eobj.OPERInstLabelCode="PreoperLab"
		
		//年龄
		if (age'="")
		{
			s age=##class(web.DHCBL.BDP.ImportKBData).getAgeId(age)
			q:(age="false") "false"		
			s eobj.PDAAgeDr=age						
		
		}
		//年龄限制
		if (agelimit'="")
		{
			s agelimit=$tr(agelimit,"岁","年")
			s ageMin=$p(agelimit,"-",1)
			s ageMax=$p($p(agelimit,"-",2),"/",1)
			s ageUom=$p($p(agelimit,"-",2),"/",2)
			//单位
			if (ageUom'="")
			{
				s PDAUomDr=##class(web.DHCBL.BDP.ImportKBData).getUomId(ageUom)
				q:PDAUomDr="false" "false"
				s eobj.PDAUomDr=PDAUomDr
			} 
			s eobj.PDAMaxVal=ageMax
			s eobj.PDAMinVal=ageMin
		
		}
	
		//检验项目
		if (Lab'="")
		{
			s LabDr=##class(web.DHCBL.BDP.ImportKBData).getLabId(Lab)
			q:(LabDr="") "false"	
			s eobj.LABILabDr=LabDr 
			if (RepFlag="是")||(RepFlag="Y")
			{
				s eobj.LABIRepActiveFlag="Y"
			}		
			
		}
		s str = ##class(web.DHCBL.KB.DHCPreoperLab).SavePreoperLabData(eobj)
		//b ;
		if (str["false")
		{   
			q "false"
		}
		s result = "true"
		s ^TEMPOPER("PreoperLab",row)=dataStr
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：把前台逻辑单元格传入的中文名转化为运算符
/// Input: LABIRelation-逻辑运算符中文
/// Return:LABIRelation-逻辑运算符
/// Others:w ##class(web.DHCBL.BDP.ImportOPERATIONData).GetLABRelation(dLABIRelation)
ClassMethod GetLABRelation(LABIRelation As %String) As %String
{
	if (LABIRelation="大于")
	{
		s LABIRelation=">"
	}
	elseif(LABIRelation="小于")
	{
		s LABIRelation="<"
	}
	elseif(LABIRelation="等于")
	{
		s LABIRelation="<"
	}
	elseif(LABIRelation="不大于")
	{
		s LABIRelation="!>"
	}
	elseif(LABIRelation="不小于")
	{
		s LABIRelation="!<"
	}
	elseif(LABIRelation="不等于")
	{
		s LABIRelation="<>"
	}
	else
	{
		s LABIRelation=""
	}
	q LABIRelation
}

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：保存术前检验质控
/// Input: dataStr-excel中用[next]连接的一行单元格数据，row-行号
/// Return:成功返回true，失败返回false
/// Others:w ##class(web.DHCBL.BDP.ImportOPERATIONData).SavePreoperLabContr(dataStr,row)
ClassMethod SavePreoperLabContr(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for
	{
		s seq=$o(^TEMPOPER("PreoperLabContr",seq))
		q:seq=""
		s str=^TEMPOPER("PreoperLabContr",seq)
		if (str=dataStr) 
		{
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
	 	s lib="手术"
	 	s mode=$p(dataStr,"[next]",1)
		s gen=$p(dataStr,"[next]",2)
		s part=$p(dataStr,"[next]",3)
		s age=$p(dataStr,"[next]",4)
		s agelimit=$p(dataStr,"[next]",5)
		s Lab=$p(dataStr,"[next]",6)
		s LABIRelation=$p(dataStr,"[next]",7)
		s LABIMinVal=$p(dataStr,"[next]",8)	
		s LABIUomDr=$p(dataStr,"[next]",9)	
		s text=$p(dataStr,"[next]",10)
		
		//1判断必填项
		if ((gen="")||(part="")||(lib="")||(text=""))
		{   
		    q "false"
	    }

	    //通用名
		s gen=##class(web.DHCBL.BDP.ImportCheckData).getGenId(gen,lib)
		q:gen="" "false" 	   
		//部位
		s part=##class(web.DHCBL.BDP.ImportCheckData).getPartId(part)
		q:part="" "false"
		
		//通用名和部位关联表
		s isLink=##class(web.DHCBL.BDP.ImportKBData).getLinkORNo(gen,part)
		q:(isLink'="true") "false"
	
		//控制级别
		s:mode="警示" mode="W"
		s:mode="管控" mode="C"
		s:mode="统计" mode="S"
		if ((mode'="W")&(mode'="C")&(mode'="S"))
		{
			s mode="W"
		}	
		
		s eobj=##class(web.Entity.KB.DHCPreoperLabContr).%New()
	
		//插入主索引表			
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=part		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		s eobj.PHINSTMode=mode
		s eobj.OPERInstLabelCode="PreoperLabContr"
		
		//年龄
		if (age'="")
		{
			s age=##class(web.DHCBL.BDP.ImportKBData).getAgeId(age)
			q:(age="false") "false"		
			s eobj.PDAAgeDr=age						
		
		}
		//年龄限制
		if (agelimit'="")
		{
			s agelimit=$tr(agelimit,"岁","年")
			s ageMin=$p(agelimit,"-",1)
			s ageMax=$p($p(agelimit,"-",2),"/",1)
			s ageUom=$p($p(agelimit,"-",2),"/",2)
			//单位
			if (ageUom'="")
			{
				s PDAUomDr=##class(web.DHCBL.BDP.ImportKBData).getUomId(ageUom)
				q:PDAUomDr="false" "false"
				s eobj.PDAUomDr=PDAUomDr
			} 
			s eobj.PDAMaxVal=ageMax
			s eobj.PDAMinVal=ageMin
		
		}
	
		//检验项目
		if (Lab'="")
		{
			s LabDr=##class(web.DHCBL.BDP.ImportKBData).getLabId(Lab)
			q:(LabDr="") "false"	
			s eobj.LABILabDr=LabDr 
			s eobj.LABIMinVal=LABIMinVal
			s eobj.LABIRelation=..GetLABRelation(LABIRelation)		
			//单位
			if (LABIUomDr'="")
			{
				s LABIUomDr=##class(web.DHCBL.BDP.ImportKBData).getUomId(LABIUomDr)
				q:LABIUomDr="false" "false"
				s eobj.LABIUomDr=LABIUomDr
			} 
			
		}
		s str = ##class(web.DHCBL.KB.DHCPreoperLabContr).SavePreoperLabContrData(eobj)
		if (str["false")
		{   
			q "false"
		}
		s result = "true"
		s ^TEMPOPER("PreoperLabContr",row)=dataStr
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：保存术前检查
/// Input: dataStr-excel中用[next]连接的一行单元格数据，row-行号
/// Return:成功返回true，失败返回false
/// Others:w ##class(web.DHCBL.BDP.ImportOPERATIONData).SavePreoperCheck(dataStr,row)
ClassMethod SavePreoperCheck(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for
	{
		s seq=$o(^TEMPOPER("PreoperCheck",seq))
		q:seq=""
		s str=^TEMPOPER("PreoperCheck",seq)
		if (str=dataStr) 
		{
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
	 	s lib="手术"
	 	s mode=$p(dataStr,"[next]",1)
		s gen=$p(dataStr,"[next]",2)
		s part=$p(dataStr,"[next]",3)
		s age=$p(dataStr,"[next]",4)
		s agelimit=$p(dataStr,"[next]",5)
		s Check=$p(dataStr,"[next]",6)	
		s RepFlag=$p(dataStr,"[next]",7)
		s text=$p(dataStr,"[next]",8)
		
		//1判断必填项
		if ((gen="")||(part="")||(lib="")||(text=""))
		{   
		    q "false"
	    }

	    //通用名
		s gen=##class(web.DHCBL.BDP.ImportCheckData).getGenId(gen,lib)
		q:gen="" "false" 	   
		//部位
		s part=##class(web.DHCBL.BDP.ImportCheckData).getPartId(part)
		q:part="" "false"
		
		//通用名和部位关联表
		s isLink=##class(web.DHCBL.BDP.ImportKBData).getLinkORNo(gen,part)
		q:(isLink'="true") "false"
	
		//控制级别
		s:mode="警示" mode="W"
		s:mode="管控" mode="C"
		s:mode="统计" mode="S"
		if ((mode'="W")&(mode'="C")&(mode'="S"))
		{
			s mode="W"
		}	
		
		s eobj=##class(web.Entity.KB.DHCPreoperLab).%New()
	
		//插入主索引表			
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=part		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		s eobj.PHINSTMode=mode
		s eobj.OPERInstLabelCode="PreoperCheck"
		
		//年龄
		if (age'="")
		{
			s age=##class(web.DHCBL.BDP.ImportKBData).getAgeId(age)
			q:(age="false") "false"		
			s eobj.PDAAgeDr=age						
		
		}
		//年龄限制
		if (agelimit'="")
		{
			s agelimit=$tr(agelimit,"岁","年")
			s ageMin=$p(agelimit,"-",1)
			s ageMax=$p($p(agelimit,"-",2),"/",1)
			s ageUom=$p($p(agelimit,"-",2),"/",2)
			//单位
			if (ageUom'="")
			{
				s PDAUomDr=##class(web.DHCBL.BDP.ImportKBData).getUomId(ageUom)
				q:PDAUomDr="false" "false"
				s eobj.PDAUomDr=PDAUomDr
			} 
			s eobj.PDAMaxVal=ageMax
			s eobj.PDAMinVal=ageMin
		
		}
	
		//检查项目
		if (Check'="")
		{
			s upCheck=$ZCONVERT(Check,"U")  //转换成大写 
			s CheckDr=""			
			if ($d(^DHCPHEGENi(0,"Desc",upCheck))>0)
			{
				s CheckDr=$o(^DHCPHEGENi(0,"Desc",upCheck,0))
			}
			q:(CheckDr="") "false"	
			s eobj.LABILabDr=CheckDr 
			if (RepFlag="是")||(RepFlag="Y")
			{
				s eobj.LABIRepActiveFlag="Y"
			}		
			
		}
		s str = ##class(web.DHCBL.KB.DHCPreoperLab).SavePreoperLabData(eobj)
		if (str["false")
		{   
			q "false"
		}
		s result = "true"
		s ^TEMPOPER("PreoperCheck",row)=dataStr
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：保存术前检查质控
/// Input: dataStr-excel中用[next]连接的一行单元格数据，row-行号
/// Return:成功返回true，失败返回false
/// Others:w ##class(web.DHCBL.BDP.ImportOPERATIONData).SavePreoperCheckContr(dataStr,row)
ClassMethod SavePreoperCheckContr(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for
	{
		s seq=$o(^TEMPOPER("PreoperCheckContr",seq))
		q:seq=""
		s str=^TEMPOPER("PreoperCheckContr",seq)
		if (str=dataStr) 
		{
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
	 	s lib="手术"
	 	s mode=$p(dataStr,"[next]",1)
		s gen=$p(dataStr,"[next]",2)
		s part=$p(dataStr,"[next]",3)
		s age=$p(dataStr,"[next]",4)
		s agelimit=$p(dataStr,"[next]",5)
		s Lab=$p(dataStr,"[next]",6)
		s LABIRelation=$p(dataStr,"[next]",7)
		s LABIMinVal=$p(dataStr,"[next]",8)	
		s LABIUomDr=$p(dataStr,"[next]",9)	
		s text=$p(dataStr,"[next]",10)
		
		//1判断必填项
		if ((gen="")||(part="")||(lib="")||(text=""))
		{   
		    q "false"
	    }

	    //通用名
		s gen=##class(web.DHCBL.BDP.ImportCheckData).getGenId(gen,lib)
		q:gen="" "false" 	   
		//部位
		s part=##class(web.DHCBL.BDP.ImportCheckData).getPartId(part)
		q:part="" "false"
		
		//通用名和部位关联表
		s isLink=##class(web.DHCBL.BDP.ImportKBData).getLinkORNo(gen,part)
		q:(isLink'="true") "false"
	
		//控制级别
		s:mode="警示" mode="W"
		s:mode="管控" mode="C"
		s:mode="统计" mode="S"
		if ((mode'="W")&(mode'="C")&(mode'="S"))
		{
			s mode="W"
		}	
		
		s eobj=##class(web.Entity.KB.DHCPreoperLabContr).%New()
	
		//插入主索引表			
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=part		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		s eobj.PHINSTMode=mode
		s eobj.OPERInstLabelCode="PreoperCheckContr"
		
		//年龄
		if (age'="")
		{
			s age=##class(web.DHCBL.BDP.ImportKBData).getAgeId(age)
			q:(age="false") "false"		
			s eobj.PDAAgeDr=age						
		
		}
		//年龄限制
		if (agelimit'="")
		{
			s agelimit=$tr(agelimit,"岁","年")
			s ageMin=$p(agelimit,"-",1)
			s ageMax=$p($p(agelimit,"-",2),"/",1)
			s ageUom=$p($p(agelimit,"-",2),"/",2)
			//单位
			if (ageUom'="")
			{
				s PDAUomDr=##class(web.DHCBL.BDP.ImportKBData).getUomId(ageUom)
				q:PDAUomDr="false" "false"
				s eobj.PDAUomDr=PDAUomDr
			} 
			s eobj.PDAMaxVal=ageMax
			s eobj.PDAMinVal=ageMin
		
		}
	
		//检验项目
		if (Lab'="")
		{
			s LabDr=##class(web.DHCBL.BDP.ImportCheckData).getGenId(Lab,"检查测值")
			q:(LabDr="") "false"	
			s eobj.LABILabDr=LabDr 
			s eobj.LABIMinVal=LABIMinVal
			s eobj.LABIRelation=..GetLABRelation(LABIRelation)		
			//单位
			if (LABIUomDr'="")
			{
				s LABIUomDr=##class(web.DHCBL.BDP.ImportKBData).getUomId(LABIUomDr)
				q:LABIUomDr="false" "false"
				s eobj.LABIUomDr=LABIUomDr
			} 
			
		}
		s str = ##class(web.DHCBL.KB.DHCPreoperLabContr).SavePreoperLabContrData(eobj)
		if (str["false")
		{   
			q "false"
		}
		s result = "true"
		s ^TEMPOPER("PreoperCheckContr",row)=dataStr
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

}
