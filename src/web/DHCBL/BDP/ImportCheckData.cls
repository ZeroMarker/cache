Import SQLUser

/// 名称:导入检查知识库模板
/// 编写者：基础平台组 -谷雪萍
/// 编写日期: 2015-12-16
Class web.DHCBL.BDP.ImportCheckData Extends %RegisteredObject
{

/// Others:s str="NK0001[next]鼻咽镜检查[next]鼻咽镜检查[next]鼻咽镜检查[next]内镜[next]byj/byjjc[next]头部[next]"
/// Others:w ##class(web.DHCBL.BDP.ImportCheckData).SaveData(str,11,1)
ClassMethod SaveData(dataStr As %String, sheetid As %String, row As %Float) As %String
{
	
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).Util(dataStr)
	
 	/// Function:保存知识库标识字典  成功result:^1^1
	s:sheetid=2 result=..SaveLibaryLabel(dataStr)

	/// Function:保存知识库目录字典  成功result:^1^1
	s:sheetid=3 result=..SaveInstLabel(dataStr)
	
	/// Function:保存过敏史  成功result:^1^1^1^1^1
	s:sheetid=4 result=..SaveAllergy(dataStr)
	
	/// Function:保存诊断字典对照 成功result:^1^1^1^1^1^1^1
	s:sheetid=5 result=..SaveIcd(dataStr)
	
	/// Function:保存单位字典对照  成功result:^1^1^1^1
	s:sheetid=6 result=..SaveExtUom(dataStr)
	
	/// Function:保存特殊人群字典  成功result:^1^1
	s:sheetid=7 result=..SaveSpecialPopu(dataStr)
	
    /// Function:保存病症字典  成功result:^1^1^1^1
	s:sheetid=8 result=..SaveDiseaseList(dataStr)
	
	 /// Function:保存年龄字典  成功result:^1^1^1
	s:sheetid=9 result=..SaveAge(dataStr)
	
	/// Function:保存检查部位  成功result:^1^1^1
	s:sheetid=10 result=..SavePart(dataStr)
	
	/// Function:保存到通用名 成功result:^1^1^1^1^1^1^1
	s:sheetid=11 result=..SaveGeneric(dataStr)
	
	/// Function:保存适应症 成功result:^1^1^1
	s:sheetid=12 result=..SaveDiseaseInd(dataStr,row)
	
	/// Function:保存禁忌症 成功result:^1^1^1
	s:sheetid=13 result=..SaveDiseaseCon(dataStr,row)
	
	/// Function:保存到不良反应 成功result:^1^1^1
	s:sheetid=14 result=..SavePHDAR(dataStr,row)
	
	/// Function:保存到注意事项 成功result:^1^1^1
	s:sheetid=15 result=..SavePHDMHA(dataStr,row)
	

	q result
}

/// 去掉字符串末尾的空格
/// w ##class(web.DHCBL.BDP.CImportDisKB).trim("    btnSearch    ")-->    btnSearch
ClassMethod trim(str) As %String
{
	While($e(str,*)=" ")
	{
		s str=$e(str,1,*-1)
	}
	q str
}

/// Function:保存知识库标识字典  成功result:^1^1
ClassMethod SaveLibaryLabel(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)
	s active=$p(dataStr,"[next]",3)
	s active=$ZCONVERT(active,"U") 

	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1      
		//保存到字典表	
	    s eobj=##class(web.Entity.KB.DHCPHLibaryLabel).%New()
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s updesc=$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^DHCPHLIBL(0,"Code",upcode,0))
		s idd=$o(^DHCPHLIBL(0,"Desc",updesc,0))
		//判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj.PHLIRowId=idc
		 }
		
	    s eobj.PHLICode=code
	    s eobj.PHLIDesc=desc
	    s eobj.PHLIActiveFlag=active
	    s str = ##class(web.DHCBL.KB.DHCPHLibaryLabel).SaveData(eobj)
	    if (str["true"){   
		    s result=result_"^"_1
	    }
	    else{        
			s result=result_"^"_0
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

/// Function:保存知识库目录字典  成功result:^1^1^1
ClassMethod SaveInstLabel(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)
	s lib=$p(dataStr,"[next]",3)
	s order=$p(dataStr,"[next]",4)
	s mode=$p(dataStr,"[next]",5)
	s icon=$p(dataStr,"[next]",6)
	s flag=$p(dataStr,"[next]",7)
	s flag=$ZCONVERT(flag,"U") 
	s alertMsg=$p(dataStr,"[next]",8)
	s genFlag=$p(dataStr,"[next]",9)
	s proFlag=$p(dataStr,"[next]",10)
		
	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{
	    s result=result_"^"_1 
	     //判断填入的数据是否正确  
   	    if (lib'=""){
		     s lib=$ZCONVERT(lib,"U")
		     s lib=$o(^DHCPHLIBL(0,"Desc",lib,0))
		     if (lib=""){
			     s result=result_"^"_0
		     }
		     else{
			    s result=result_"^"_1 
		     }
	    } 
	    if (mode'=""){
	     //管理模式（ ",Warn,Control,Stat"） 
			s:mode="Warn" mode="W"
			s:mode="Control" mode="C"
			s:mode="Stat" mode="S"
			if ((mode'="W")&(mode'="C")&(mode'="S")){
				s result=result_"^"_0
			}else{
				s result=result_"^"_1
			}  
	    }
  		     
		//保存到字典表	
	    s eobj=##class(web.Entity.KB.DHCPHInstLabel).%New()
	    //判断是添加还是修改
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s idc=$o(^DHCPHPINL(0,"Code",upcode,0))	
		if (idc'=""){
			s eobj.PINLRowID=idc
		}		
	    s eobj.PINLCode=code
	    s eobj.PINLDesc=desc
	    s eobj.PINLLabelDr=lib
	    s eobj.PINLOrderNum=order
	    s eobj.PINLManageMode=mode
	    s eobj.PINLIcon=icon
	    s eobj.PINLAllFlag=flag
	    s eobj.PINLAlertMsg=alertMsg
	    s eobj.PINLGenFlag=genFlag
	    s eobj.PINLProFlag=proFlag
	    s str = ##class(web.DHCBL.KB.DHCPHInstLabel).SaveData(eobj)
	    if (str["true"){   
		    s result=result_"^"_1
	    }
	    else{        
			 if (str["该记录已经存在"){
			 	s result=result_"^"_1   
		    }
		    else{
			    s result=result_"^"_0
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

/// Function:保存过敏史  成功result:^1^1^1^1^1
ClassMethod SaveAllergy(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)
	s keys=$p(dataStr,"[next]",3)
	
	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1      
		//保存到字典表	
	    s eobj14=##class(web.Entity.KB.DHCAllergyFeild).%New()
	    s eobj14.ALFCode=code
	    s eobj14.ALFDesc=desc
	    s eobj14.ALFActiveFlag="Y"
	    s eobj14.ALFSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCAllergyFeild).SaveData(eobj14)
	    if (str1["true"){   
		    s result=result_"^"_1
	    }
	    else{        
			if (str1["该记录已经存在"){
				s result=result_"^"_1   
			}
			else{
				s result=result_"^"_0
			}
		    
	    }  
	    //保存到过敏史关键字表
	    if (keys'="") {
		      
	    	s upcode=$ZCONVERT(code,"U") //转换成大写
			s cid=$o(^DHCALLERGYi(0,"Code",upcode,0))
			s updesc=$ZCONVERT(desc,"U") //转换成大写
			s did=$o(^DHCALLERGYi(0,"Desc",updesc,0))

		 	if ((cid="")||(did="")||(cid'=did))
		 	{ 
				s result=result_"^"_0
		 	}
		 	else
		 	{
			 	s result=result_"^"_1   	
				s argsLen=$Length(keys,"#&")
				for i=1:1:argsLen		
				{
					s key=$p(keys,"#&",i)	

				    s eobjak=##class(web.Entity.KB.DHCAllergyKey).%New()
				    s eobjak.ALKALDr=cid
				    s eobjak.ALKKey=key
				    s eobjak.ALKSysFlag="Y"
				    s str1 = ##class(web.DHCBL.KB.DHCAllergyKey).SaveData(eobjak)
				    
				    if (str1["true"){   
					    s result=result_"^"_1
				    }
				    else{        
					    if (str1["该记录已经存在"){
						 	s result=result_"^"_1   
					    }
					    else{
						    s result=result_"^"_0
					    }
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

/// Function:保存诊断字典对照 成功result:^1^1^1^1^1^1^1
ClassMethod SaveIcd(dataStr As %String) As %String
{
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)
	s desc=$p(dataStr,"[next]",4)
	s type=$p(dataStr,"[next]",5)
	s OpStatus=$p(dataStr,"[next]",6)
	s Remark=$p(dataStr,"[next]",7)
	s keys=$p(dataStr,"[next]",8)

	Ts
	
	//1判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1 
   		
   		//2类型（ICD9/ICD10/非ICD）
   		s type=$ZCONVERT(type,"U") 
		s:type="ICD9" type=9
		s:type="ICD10" type=10
		s:type="非ICD" type=99
		if ((type'=9)&(type'=10)&(type'=99)&(type'="")){
			s type=10
		}
		
		 //操作状态（放弃/确认）
		s:OpStatus="放弃" OpStatus=0
		s:OpStatus="确认" OpStatus=1
		if ((OpStatus'=0)&(OpStatus'=1)&(OpStatus'="")){
			s OpStatus=""
		}      
		 
		//3保存到诊断字典表	
	    s eobj8=##class(web.Entity.KB.DHCExtIcdFeild).%New()
	     //判断是添加还是修改
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s idc=$o(^DHCEXTICD(0,"Code",upcode,0))	
		if (idc'=""){
			s eobj8.ICDRowId=idc
		}
	    s eobj8.ICDCode=code
	    s eobj8.ICDDesc=desc
	    s eobj8.ICDType=type
	    s eobj8.ICDOpStatus=OpStatus
	    s eobj8.ICDRemark=Remark
	    s eobj8.ICDAcitveFlag="Y"
	    s eobj8.ICDSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCExtIcdFeild).SaveData(eobj8)
	    if (str1["true"){   
		    s result=result_"^"_1
	    }
	    else{        
		    if (str1["该记录已经存在"){
			 	s result=result_"^"_1   
		    }
		    else{
			    s result=result_"^"_0
		    }
	    }
    
	    //5保存到诊断对照表
	    if ((hiscode'="")&(hisdesc'="")) {  //如果HIS代码为空
		   s uphiscode=$$ALPHAUP^SSUTIL4(hiscode) //转换成大写
		   s hiscid=$o(^MRC("ID",0,"Code",uphiscode,0))
		   s uphisdesc=$$ALPHAUP^SSUTIL4(hisdesc) //转换成大写
		   s hisdid=$o(^MRC("ID",0,"Desc",uphisdesc,0))
	   
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCEXTICD(0,"Code",upcode,0))
		   s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCEXTICD(0,"Desc",updesc,0))
	   	  // b ;hiscid,hisdid,cid,did
		    //4判断填入的数据是否正确
		   if ((hiscid="")||(cid=""))
		   { 
				 s result=result_"^"_0
		    }
			else
			{
				s result=result_"^"_1
				   	
				s ids=cid_"^"_hiscid
				s str2 = ##class(web.DHCBL.KB.DHCExtIcdContrast).SaveData(ids)
				//b ;str2
				if (str2["true"){
				    s result=result_"^"_1
			    }
			    else{
				    if (str2["不能重复对照"){
					    s result=result_"^"_1
				    }
				    else{
					    s result=result_"^"_0
				    }
			    }
			}
	    }
	    
	    //7,8,9..保存到诊断关键字表

	    if (keys'="") {  
	   
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCEXTICD(0,"Code",upcode,0))
		   s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCEXTICD(0,"Desc",updesc,0))
		   
	   	  // b ;hiscid,hisdid,cid,did
		    //6判断填入的数据是否正确
		   if ((cid="")||(did="")||(cid'=did))
		   { 
				 s result=result_"^"_0
		    }
			else
			{
				s result=result_"^"_1
				   	
				s argsLen=$Length(keys,"#&")
				for i=1:1:argsLen		
				{
					s key=$p(keys,"#&",i)	

				    s eobjk=##class(web.Entity.KB.DHCExtIcdKey).%New()
				    s eobjk.ICDKICDDr=cid
				    s eobjk.ICDKText=key
				    s eobjk.ICDKSysFlag="Y"
				    s str1 = ##class(web.DHCBL.KB.DHCExtIcdKey).SaveData(eobjk)
				    if (str1["true"){   
					    s result=result_"^"_1
				    }
				    else{        
					    if (str1["该记录已经存在"){
						 	s result=result_"^"_1   
					    }
					    else{
						    s result=result_"^"_0
					    }
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

/// Function:保存单位字典对照  成功result:^1^1^1^1 
ClassMethod SaveExtUom(dataStr As %String) As %String
{
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)
	s desc=$p(dataStr,"[next]",4)

	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1      
		//保存到单位字典表	
	    s eobj5=##class(web.Entity.KB.DHCPHExtUom).%New()
	    s eobj5.PHEUCode=code
	    s eobj5.PHEUDesc=desc
	    s eobj5.PHEUActiveFlag="Y"
	    s eobj5.PHEUSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtUom).SaveData(eobj5)
	    if (str1["true"){   
		    s result=result_"^"_1
	    }
	    else{        
		    if (str1["该记录已经存在"){
			 	s result=result_"^"_1   
		    }
		    else{
			    s result=result_"^"_0
		    }
	    }
    
	    //保存到单位对照表
	    if ((hiscode'="")&(hisdesc'="")) {  //如果HIS代码为空
		   s uphiscode=$ZCONVERT(hiscode,"U") //转换成大写
		   s hiscid=$o(^CT("UOM",0,"Code",uphiscode,0))
		   s uphisdesc=$ZCONVERT(hisdesc,"U") //转换成大写
		   s hisdid=$o(^CT("UOM",0,"Desc",uphisdesc,0))
	   
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCPHEUOi(0,"Code",upcode,0))
		   s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCPHEUOi(0,"Desc",updesc,0))
	   	   //b ;hiscid,hisdid,cid,did
		    //判断填入的数据是否正确
		   if ((hiscid="")||(hisdid="")||(hiscid'=hisdid)||(cid="")||(did="")||(cid'=did))
		   { 
				 s result=result_"^"_0
		    }
			else
			{
				s result=result_"^"_1
				   	
				s ids=cid_"^"_hiscid
				s str2 = ##class(web.DHCBL.KB.DHCPHUomContrast).SaveData(ids)
				//b ;str2
				if (str2["true"){
				    s result=result_"^"_1
			    }
			    else{
				    if (str2["不能重复对照"){
					    s result=result_"^"_1
				    }
				    else{
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

/// Function:保存特殊人群字典  成功result:^1^1
ClassMethod SaveSpecialPopu(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)

	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1      
		//保存到字典表	
	    s eobj9=##class(web.Entity.KB.DHCSpecialPopu).%New()
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s updesc=$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^DHCSPEP(0,"Code",upcode,0))
		s idd=$o(^DHCSPEP(0,"Desc",updesc,0))
		//判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj9.SPERowId=idc
		 }
		
	    s eobj9.SPECode=code
	    s eobj9.SPEDesc=desc
	    s eobj9.SPEActiveFlag="Y"
	    s eobj9.SPESysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCSpecialPopu).SaveData(eobj9)
	    if (str1["true"){   
		    s result=result_"^"_1
	    }
	    else{        
			s result=result_"^"_0
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

/// Others:s str="A01[next]伤寒和副伤寒[next]SHHFSH[next][next][next][next]备注[next]A00.000"
/// Others:w ##class(web.DHCBL.BDP.ImportCheckData).SaveData(str,8)
/// Function:保存病症字典  成功result:^1^1^1^1
ClassMethod SaveDiseaseList(dataStr As %String) As %String
{
	s result=""
	s code=..trim($p(dataStr,"[next]",1))
	s desc=..trim($p(dataStr,"[next]",2))
	s DiseaKey=..trim($p(dataStr,"[next]",3))
	s DiseaCom=..trim($p(dataStr,"[next]",4))
	s DiseaComKey=..trim($p(dataStr,"[next]",5))
	s DiseaAlias=..trim($p(dataStr,"[next]",6))
	s DiseaRemark=..trim($p(dataStr,"[next]",7))
	s icds=..trim($p(dataStr,"[next]",8))

	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1   
   		s upcode=$ZCONVERT(code,"U") //转换成大写
		s id=$o(^DHCPHDISL(0,"Code",upcode,0))   
		//保存到字典表	
	    s eobj12=##class(web.Entity.KB.DHCPHDiseaseList).%New()
	    s eobj12.PHDISLRowId=id
	    s eobj12.PHDISLDiseaCode=code
	    s eobj12.PHDISLDiseaDesc=desc
	    s eobj12.PHDISLActiveFlag="Y"
	    s eobj12.PHDISLSysFlag="Y"
	    s eobj12.PHDISLKey=DiseaKey
	    s eobj12.PHDISLRemark=DiseaRemark
	 
	    s str1 = ##class(web.DHCBL.KB.DHCPHDiseaseList).SaveData(eobj12)
	    if (str1["true"){   
		    s result=result_"^"_1
	    }
	    else{        
		    if (str1["该记录已经存在"){
			 	s result=result_"^"_1   
		    }
		    else{
			    s result=result_"^"_0
		    }
	    }
	    
	    if (DiseaCom'="")||(DiseaAlias'="")
	    {   //如果病症修改成功,则保存常用名和别名
	       s upcode=$ZCONVERT(code,"U") //转换成大写
		   s id=$o(^DHCPHDISL(0,"Code",upcode,0))
		   s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCPHDISL(0,"Desc",updesc,0)) 	
		    //判断填入的数据是否正确
		   if ((id="")||(did="")||(id'=did))
		   { 
				s result=result_"^"_0
		   }
			else
			{
				s result=result_"^"_1
	   			s strAlias=##class(web.DHCBL.KB.DHCPHDiseaseList).GetComOrAlias(id,"A")
				s PHDISLAlias=$p(strAlias,"||",1)
				s aliasKey=$p(strAlias,"||",2)
				s strCom=##class(web.DHCBL.KB.DHCPHDiseaseList).GetComOrAlias(id,"C")
				s PHDISLCom=$p(strCom,"||",1)
				s comKey=$p(strCom,"||",2)
				s tDiseaCom=$tr(DiseaCom,"#&","")
				s tDiseaComKey=$tr(DiseaComKey,"#&","")
				s tDiseaAlias=$tr(DiseaAlias,"#&","")
				s tPHDISLCom=$tr(PHDISLCom,",","")
				s tcomKey=$tr(comKey,",","")
				s tPHDISLAlias=$tr(PHDISLAlias,",","")
				
		   		///判断是否和原数据一样，一样则不修改
				s cstrnew="{list:[PHDISLCom:"""_tDiseaCom_""",comKey:"""_tDiseaComKey_""",PHDISLAlias:"""_tDiseaAlias_"""}]}"
	   			s cstrold="{list:[PHDISLCom:"""_tPHDISLCom_""",comKey:"""_tcomKey_""",PHDISLAlias:"""_tPHDISLAlias_"""}]}"
	   		
	   			if (cstrnew=cstrold)
	   			{
		   			s result=result_"^"_2  ///跳过修改
	   			}
	   			else
	   			{
		   			if (DiseaAlias'="")
		   			{ 
		   				 s listData=""
			   			 s AliasLen=$Length(DiseaAlias,"#&")
						 for i=1:1:AliasLen		
						 {
						 	s Alias=$p(DiseaAlias,"#&",i)	
			   				s type="A"
			   				s uDiseaAlias=$ZCONVERT(Alias,"U") //转换成大写
							s idd=$o(^DHCPHDISCOMLi(0,"Desc",id,type,uDiseaAlias,0))
							s:listData'="" listData=idd_"^"_Alias_"^"_id_"^"_type_"^"_"#"_listData
							s:listData="" listData=idd_"^"_Alias_"^"_id_"^"_type_"^"
						  }
						s estr=##class(web.DHCBL.KB.DHCPHDiseaseComList).SaveAll(listData)
						//b ;estr2
		   				if (estr["success:'true'")
						{
		   					 s result=result_"^"_1 				
						}
						if (estr["success:'false'")
						{
							s result=result_"^"_0				
							s ^ERRORKB(sheetname,DiseaCode,DiseaDesc,"Alias")=datastr_"&&"_estr
						}
					 
		   			}
		   			if (DiseaCom'="")
		   			{
			   			  s listData="" 
			   			  s ComLen=$Length(DiseaCom,"#&")
						  for i=1:1:ComLen		
						  {
							s Com=$p(DiseaCom,"#&",i)	
							s comKey=$p(DiseaComKey,"#&",i)
			   				s type="C"
			   				s uDiseaCom=$ZCONVERT(Com,"U") //转换成大写
							s idd=$o(^DHCPHDISCOMLi(0,"Desc",id,type,uDiseaCom,0))
							s:listData'="" listData=idd_"^"_Com_"^"_id_"^"_type_"^"_comKey_"#"_listData
							s:listData="" listData=idd_"^"_Com_"^"_id_"^"_type_"^"_comKey
						  }
						s estr=##class(web.DHCBL.KB.DHCPHDiseaseComList).SaveAll(listData)
						//b ;estr3
		   				if (estr["success:'true'")
						{
		   					 s result=result_"^"_1 				
						}
						if (estr["success:'false'")
						{
							s result=result_"^"_0				
							s ^ERRORKB(sheetname,DiseaCode,DiseaDesc,"Com")=datastr_"&&"_estr
						}
					  
		   			}
	   			}
   			}
		}
	    b ;11
	    //保存到病症与诊断关联表
	    if (icds'="") { 
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCPHDISL(0,"Code",upcode,0))
		   s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCPHDISL(0,"Desc",updesc,0))
		    
		   s icdDrs=""
		   s icdLen=$Length(icds,"#&")
		   for i=1:1:icdLen
		   {
			    s icd=$p(icds,"#&",i)
		 		s icd=$ZCONVERT(icd,"U") //转换成大写
		   		s icdid=$o(^DHCEXTICD(0,"Code",icd,0))
		 		if (icdid'="") 
		   		{
			   		s:icdDrs'="" icdDrs=icdDrs_","_icdid
			   		s:icdDrs="" icdDrs=icdid
		   		}
		   		else
		   		{
			   		s result=result_"^"_0
		   		}
		   }
		   b ;22
		    //判断填入的数据是否正确
		   if ((icdid="")||(cid="")||(did="")||(cid'=did))
		   { 
				 s result=result_"^"_0
		    }
			else
			{
				s result=result_"^"_1
				   	
				s eobjI= ##class(web.Entity.KB.DHCPHDiseaseItmList).%New()
				s eobjI.PHDISLIICDDr=icdDrs
				s eobjI.PHDISLIDisDr=cid
				s eobjI.PHDISLISysFlag="Y"
				s str2 = ##class(web.DHCBL.KB.DHCPHDiseaseItmList).SaveData(eobjI)

				if (str2["true"){
				    s result=result_"^"_1
			    }
			    else{
				    if (str2["该记录已经存在")||(str2["存在已经被关联的诊断")
				    {
					    s result=result_"^"_1
				    }
				    else{
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

/// Function:保存年龄字典  成功result:^1^1^1
ClassMethod SaveAge(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)
	s min=$p(dataStr,"[next]",3)
	s max=$p(dataStr,"[next]",4)
	s uom=$p(dataStr,"[next]",5)
	s active=$p(dataStr,"[next]",6)
	s sys=$p(dataStr,"[next]",7)
	s active=$ZCONVERT(active,"U") 
	s sys=$ZCONVERT(sys,"U") 
	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1
   		
   		 //判断填入的数据是否正确  
   	    if (uom'=""){
		     s uom=$ZCONVERT(uom,"U")
		     s uom=$o(^DHCPHEUOi(0,"Desc",uom,0))
		     if (uom=""){
			     s result=result_"^"_0
		     }
		     else{
			    s result=result_"^"_1 
		     }
	    }    
		//保存到字典表	
	    s eobj13=##class(web.Entity.KB.DHCPHPatAgeList).%New()
	    
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s updesc=$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^DHCPHPAGEL(0,"Code",upcode,0))
		s idd=$o(^DHCPHPAGEL(0,"Desc",updesc,0))
	      //判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj13.PDARowID=idc
		 }
		
	    s eobj13.PDAAgeCode=code
	    s eobj13.PDAAgeDesc=desc
	    s eobj13.PDAAgeMin=min
	    s eobj13.PDAAgeMax=max
	    s eobj13.PDAUomDr=uom
	    s eobj13.PDAActiveFlag=active
	    s eobj13.PDASysFlag=sys
	    s str1 = ##class(web.DHCBL.KB.DHCPHPatAgeList).SaveData(eobj13)
	    if (str1["true"){   
		    s result=result_"^"_1
	    }
	    else{        
			s result=result_"^"_0
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

/// Function:保存检查部位对照   成功result:^1^1^1^1
ClassMethod SavePart(dataStr As %String) As %String
{
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)
	s desc=$p(dataStr,"[next]",4)

	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{
	    s result=result_"^"_1    
		//保存到检查部位字典表	
	    s eobj=##class(web.Entity.KB.DHCPHExtPart).%New()
	    s eobj.PHEPCode=code
	    s eobj.PHEPDesc=desc
	    s eobj.PHEPAcitveFlag="Y"
	    s eobj.PHEPSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtPart).SaveData(eobj)
	    if (str1["true"){   
		    s result=result_"^"_1
	    }
	    else{        
		    if (str1["该记录已经存在"){
			 	s result=result_"^"_1   
		    }
		    else{
			    s result=result_"^"_0
		    }
	    }
    	
	    //保存到检查部位对照表 
	    if ((hiscode'="")&(hisdesc'="")) {  //如果HIS代码为空
	    	s hiscid=""
	    	if (##class(web.DHCBL.BDP.BDPDataChangeLog).IsValidClassName("User.DHCAppPart")=1){
			//新版检查部位：检查医嘱配置-检查医嘱及项目维护-部位维护
				s hiscid=$o(^DHCAPPART(0,"Code",hiscode,0))
	    	}else{
		    	s uphiscode=$$ALPHAUP^SSUTIL4(hiscode) //转换成大写
		   		s hiscid=$o(^MRC("BODP",0,"Code",uphiscode,0))
	    	}

		   /*s uphisdesc=$$ALPHAUP^SSUTIL4(hisdesc) //转换成大写
		   s hisdid=$o(^MRC("BODP",0,"Desc",uphisdesc,0))*/
		 
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCPHEPA(0,"Code",upcode,0))
		  /* s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCPHEPA(0,"Desc",updesc,0))*/
		   
	   		//b ;hiscid,hisdid,cid,did
		    //判断填入的数据是否正确
		  // if ((hiscid="")||(hisdid="")||(hiscid'=hisdid)||(cid="")||(did="")||(cid'=did))
		    if ((hiscid="")||(cid=""))
		    { 
				 s result=result_"^"_0
		    }
			else{
				s result=result_"^"_1
				
				s ids=cid_"^"_hiscid
				s str2 = ##class(web.DHCBL.KB.DHCPHPartContrast).SaveData(ids)

				if (str2["true"){
				    s result=result_"^"_1
			    }
			    else{
				    if (str2["不能重复对照"){
					    s result=result_"^"_1
				    }
				    else{
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

/// Function:保存到通用名 成功result:^1^1^1^1^1^1^1
/// s str="NK0001[next]鼻咽镜检查[next]鼻咽镜检查[next]鼻咽镜检查[next]内镜[next]byj/byjjc[next]头部[next]"
ClassMethod SaveGeneric(dataStr As %String) As %String
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
	if ((code="")||(desc="")||(lib="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1 
   		//2判断填入的数据是否正确  
   	    if (lib'=""){
		     s lib=$ZCONVERT(lib,"U")
		     s lib=$o(^DHCPHLIBL(0,"Desc",lib,0))
		     if (lib=""){
			     s result=result_"^"_0
		     }
		     else{
			    s result=result_"^"_1 
		     }
	    }

	    if (part'=""){
		     s part=$ZCONVERT(part,"U") //转换成大写
		     s part=$o(^DHCPHEPA(0,"Desc",part,0))
		     if (part=""){
			     s result=result_"^"_0
		     }
		     else{
			    s result=result_"^"_1 
		     }
	    }  
	
		//3保存到通用名字典表	
	    s eobj=##class(web.Entity.KB.DHCPHExtGeneric).%New() 
	    s eobj.PHEGCode=code
	    s eobj.PHEGDesc=desc
	    s eobj.PHEGLibDr=lib
	    s eobj.PHEGActiveFlag="Y"
	    s eobj.PHEGSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtGeneric).SaveData(eobj)
	    if (str1["true"){   
		    s result=result_"^"_1
	    }
	    else{        
			if (str1["该记录已经存在"){
			 	s result=result_"^"_1   
		    }
		    else{
			    s result=result_"^"_0
		    }
		    
	    }
	   
	    s upcode=$ZCONVERT(code,"U") //转换成大写
	    s updesc=$ZCONVERT(desc,"U")  //转换成大写
		s idc=$o(^DHCPHEGENi(0,"Code",upcode,0))
		s idd=$o(^DHCPHEGENi(0,"Desc",updesc,0))
		 //判断填入的通用名是否正确，正确则继续插入与通用名字典关联的表
	    if ((idc="")||(idd="")||(idc'=idd))
		{ 
			s result=result_"^"_0
		}
		else
		{
			s result=result_"^"_1
        	//保存到检查通用名和HIS对照表
		   	 if ((hiscode'="")&(hisdesc'="")) {  //如果HIS用法代码为空
			   s uphiscode=$$ALPHAUP^SSUTIL4(hiscode) //转换成大写
			   s hiscid=$o(^ARCIM(0,"Code",uphiscode,0))
			   s uphisdesc=$$ALPHAUP^SSUTIL4(hisdesc) //转换成大写
			   s hisdid=$o(^ARCIM(0,"Desc",uphisdesc,0))

		   	   //b ;hiscid,hisdid,idc,idd
			    //判断填入的数据是否正确
			   if (hiscid="")
			   { 
					 s result=result_"^"_0
			    }
				else
				{
					
					s result=result_"^"_1
					s ARCIMVersion = 0
				    for{
					 	s ARCIMVersion=$o(^ARCIM(hiscid,ARCIMVersion))	q:ARCIMVersion=""
						s hisRowId = hiscid_"||"_ARCIMVersion
				    }
				   	
					s ids=idc_"^"_hisRowId
					s str2 = ##class(web.DHCBL.KB.DHCGenItmContrast).SavePartData(ids)
					//b ;str2
					if (str2["true"){
					    s result=result_"^"_1
				    }
				    else{
					    if (str2["不能重复对照"){
						    s result=result_"^"_1
					    }
					    else{
						    s result=result_"^"_0
					    }
				    }
				}
		    }
		
	    	//保存到通用名别名表
	   		if (keys'="") {	   	
				s argsLen=$Length(keys,"#&")
				for i=1:1:argsLen		
				{
					s key=$p(keys,"#&",i)	

				    s eobjga=##class(web.Entity.KB.DHCPHExtGenAlias).%New()
				    s eobjga.PHEGAlGenDr=idc
				    s eobjga.PHEGAlText=key
				    s eobjga.PHEGAlLibDr=lib
				    s eobjga.PHEGAlSysFlag="Y"
				    s str1 = ##class(web.DHCBL.KB.DHCPHExtGenAlias).SaveData(eobjga)
				    if (str1["true"){   
					    s result=result_"^"_1
				    }
				    else{        
					    if (str1["该记录已经存在"){
						 	s result=result_"^"_1   
					    }
					    else{
						    s result=result_"^"_0
					    }
				    }				
				}	 
					
	    	}
	    	
	    	//保存到检查通用名与部位关联表
	   		if (part'="") {	   	
				 	s eobjglp=##class(web.Entity.KB.DHCGenLinkPointer).%New()
				 	s eobjglp.GlPGenDr=idc
				 	s eobjglp.GlPPointer=part
				    s eobjglp.GlPActiveFlag="Y"
				    s eobjglp.GlPSysFlag="Y"
				    s str1 = ##class(web.DHCBL.KB.DHCGenLinkPointer).SaveData(eobjglp)
				    if (str1["true"){   
					    s result=result_"^"_1
				    }
				    else{        
					    if (str1["该记录已经存在"){
						 	s result=result_"^"_1   
					    }
					    else{
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

/// 根据描述获得通用名id,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getGenId("ml")
ClassMethod getGenId(gen As %String, lib As %String) As %String
{
	
	if (gen="")||(lib="") q ""
	s genid=""
    s upgen=$ZCONVERT(gen,"U")  //转换成大写 			
	if ($d(^DHCPHEGENi(0,"Desc",upgen))>0)
	{
		s genid=$o(^DHCPHEGENi(0,"Desc",upgen,0))
	}
	else
	{
		s obj=##class(User.DHCPHExtGeneric).%New()
		s obj.PHEGCode = gen
		s obj.PHEGDesc = gen
		s lib=$o(^DHCPHLIBL(0,"Desc",lib,0))
		q:lib="" ""
		d:lib'="" obj.PHEGLibDrSetObjectId(lib)
		s obj.PHEGActiveFlag = "Y"
		s obj.PHEGSysFlag = "Y"
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			TC
			s genid=obj.%Id()
		}
		else
		{
			Trollback
			s genid=""
		}

	}
	s:genid'="" ^temp("KBData","Gen",genid)=gen
	q genid
}

/// 根据描述获得部位id,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getPointId("ml")
ClassMethod getPartId(part As %String) As %String
{
	s partid=""	
	s updesc=$ZCONVERT(part,"U") //转换成大写    	
	if ($d(^DHCPHEPA(0,"Desc",updesc))>0)
	{
		 s partid=$o(^DHCPHEPA(0,"Desc",updesc,0))
	}
	else
	{
		s obj=##class(User.DHCPHExtPart).%New()
		s obj.PHEPCode = part
		s obj.PHEPDesc = part 
		s obj.PHEPAcitveFlag = "Y"
		s obj.PHEPSysFlag = "Y"
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			TC
			s partid=obj.%Id()
		}
		else
		{
			Trollback
			s partid=""
		}

	}
	q partid
}

/// 判断通用名和剂型关联,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getLinkORNo()
ClassMethod getLinkORNo(gen As %String, point As %String) As %String
{
	s result=""
	s isLink=$d(^DHCGENLINPi("0",gen,point))
	if (isLink>0)
	{
		s result="true"
	}
	else
	{
		s obj=##class(User.DHCGenLinkPointer).%New()
		d:gen'="" obj.GlPGenDrSetObjectId(gen)
		s obj.GlPPointer = point
		s obj.GlPActiveFlag = "Y"
		s obj.GlPSysFlag = "Y"
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			TC
			s result="true"
		}
		else
		{
			Trollback
			s result="false"
		}
	}
	q result
}

/// 转换符号,处理字符串里的换行和双引号
/// w ##class(web.DHCBL.BDP.ImportKBData).ChangeSeparator("ml")
ClassMethod ChangeSeparator(str As %String) As %String
{
	q:str="" ""
	s str=$tr(str,"""","")
	s str=$p(str,$c(13,10),1)
	s str=$p(str,$c(0),1)
	s str=$p(str,$c(13),1)
	s str=$p(str,$c(10),1)
	s str=$tr(str,"。","")
	s str=$tr(str,"，","/")
	s str=$tr(str,"、","/")
	q str
}

/// 根据描述获得病症id的拼串,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getDisIds("ml")
ClassMethod getDisIds(dis As %String) As %String
{
	s result=""
	s disflag=""
	s disdr=""
	TS
	if (dis'="")
	{
		s dis=..ChangeSeparator(dis)
		s argsLen=$Length(dis,"#&")
		for i=1:1:argsLen
		{
			s did=""
			s arg=$p(dis,"#&",i)
			continue:arg=""
			s uparg=$ZCONVERT(arg,"U")
			if ($d(^DHCPHDISL(0,"Desc",uparg))>0)
			{
				s did=$o(^DHCPHDISL(0,"Desc",uparg,0))  
			}
			else
			{
				s obj=##class(User.DHCPHDiseaseList).%New()
				s obj.PHDISLDiseaCode = arg
				s obj.PHDISLDiseaDesc = arg
				s obj.PHDISLActiveFlag ="Y" 
				s obj.PHDISLSysFlag ="Y"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s did=obj.%Id()
				}
				
			}
			if (did'="") 
			{
				s:(disdr'="") disdr=disdr_","_did
				s:(disdr="") disdr=did				
			}
			else
			{
				s disflag=disflag_"^"_0
			}
	
		}			

	}
	if (disflag'="")
	{
		Trollback
		s result="false"
	}
	else
	{
		TC
		s result= disdr
	}
	q result
}

/// 根据描述获得单位id,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getUomId("ml")
ClassMethod getUomId(uom As %String) As %String
{
	s uomid=""
	//单位
	s upUom=$ZCONVERT(uom,"U") //转换成大写
	if ($d(^DHCPHEUOi(0,"Desc",upUom))>0)
	{
		s uomid=$o(^DHCPHEUOi(0,"Desc",upUom,0))
	}
	else
	{
		s obj=##class(User.DHCPHExtUom).%New()
		s obj.PHEUCode = uom
		s obj.PHEUDesc = uom
		s obj.PHEUActiveFlag = "Y"
		s obj.PHEUSysFlag = "Y"
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			TC
			s uomid = obj.%Id()
		}
		else
		{
			Trollback
			s uomid="false"
		}

	}
	q uomid
}

/// 根据描述获得年龄id的拼串,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getAgeId("ml")
ClassMethod getAgeId(age As %String) As %String
{
	s ageid=""
	//年龄
	if (age'="")
	{
		s upage=$ZCONVERT(age,"U")
		if ($d(^DHCPHPAGEL(0,"Desc",upage))>0)
		{
			s ageid=$o(^DHCPHPAGEL(0,"Desc",upage,0))
		}
		else
		{
			s obj=##class(User.DHCPHPatAgeList).%New()
			s obj.PDAAgeCode = age
			s obj.PDAAgeDesc = age
			s obj.PDAActiveFlag ="Y" 
			s obj.PDASysFlag ="Y"
			TS
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				TC
				s ageid = obj.%Id()
			}
			else
			{
				Trollback
				s ageid ="false"
			}

		}

	}
	q ageid
}

/// 根据描述获得治疗手术type=1或病症体征type=0 id的拼串,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getDisIds("ml")
ClassMethod getKeyIds(key As %String, type As %String) As %String
{
	s result=""
	s keyflag=""
	s keydr=""
	TS
	if ((key'="")&(type'=""))
	{
		s key=..ChangeSeparator(key)
		s argsLen=$Length(key,"#&")
		for i=1:1:argsLen
		{
			s did=""
			s arg=$p(key,"#&",i)
			continue:arg=""
			s uparg=$ZCONVERT(arg,"U")
			if ($d(^DHCPHKWi(0,"Desc",type,uparg))>0)
			{
				s did=$o(^DHCPHKWi(0,"Desc",type,uparg,0))  
			}
			else
			{
				s obj=##class(User.DHCPHKeyWord).%New()
				s obj.PHKWTypeFlag=type
				s obj.PHKWCode = arg
				s obj.PHKWDesc = arg
				s obj.PHKWActiveFlag ="Y" 
				s obj.PHKWSysFlag ="Y"				
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s did=obj.%Id()
				}
				
			}
			if (did'="") 
			{
				s:(keydr'="") keydr=keydr_","_did
				s:(keydr="") keydr=did				
			}
			else
			{
				s keyflag="false"
			}
	
		}			

	}
	if (keyflag'="")
	{
		Trollback
		s result="false"
	}
	else
	{
		TC
		s result= keydr
	}
	q result
}

/// Function:保存适应症 成功result:
ClassMethod SaveDiseaseInd(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempCheck("DiseaseInd",seq))
		q:seq=""
		s str=^tempCheck("DiseaseInd",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s result=""
		s gen=$p(dataStr,"[next]",1)
		s part=$p(dataStr,"[next]",2)
		s lib=$p(dataStr,"[next]",3)
		s dis=$p(dataStr,"[next]",4)	
		s sex=$p(dataStr,"[next]",5)
		s text=$p(dataStr,"[next]",6)
		s mode=$p(dataStr,"[next]",7)
		s key0=$p(dataStr,"[next]",8)
		s key1=$p(dataStr,"[next]",9)
		//性别
		s:sex="男" sex="M"
		s:sex="女" sex="F"
		s:sex="全部" sex="A"
		s:sex="" sex="A"
		
		//控制级别
		s:mode="警示" mode="W"
		s:mode="管控" mode="C"
		s:mode="统计" mode="S"
		if ((mode'="W")&(mode'="C")&(mode'="S")){
			s mode="W"
		}	

		//1判断必填项
		if ((gen="")||(part="")||(lib="")||(text=""))
		{   
		   q "false"
	    }

	    //通用名
		s gen=..getGenId(gen,lib)
		q:gen="" "false" 	   
		//部位
		s part=..getPartId(part)
		q:part="" "false"
		
		//通用名和部位关联表
		s isLink=..getLinkORNo(gen,part)
		q:(isLink'="true") "false"
		
		s eobj=##class(web.Entity.KB.DHCCheckDiseaseI).%New()
	
		//插入主索引表			
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=part		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		s eobj.PHINSTSex=sex
		s eobj.PHINSTMode=mode
	
		//判断填入的病症是否正确
		if (dis'="")
		{
			s disdr=..getDisIds(dis)
			q:(disdr="false") "false"
			s eobj.PHDDDiseaDr=disdr
		}
		//病症体征					
		if (key0'="")
		{
			s key0dr=..getKeyIds(key0,"0")
			q:(key0dr="false") "false"
			s eobj.PSYMKeyWordDr=key0dr 		
			
		}
		//治疗手术					
		if (key1'="")
		{
			s key1dr=..getKeyIds(key1,"1")
			q:(key1dr="false") "false"
			s eobj.PDCUKeyWordDr=key1dr 				
		}
		
		s str = ##class(web.DHCBL.KB.DHCCheckDiseaseI).SaveIndData(eobj)
		if (str["false"){   
			q "false"
		}

		s result = "true"
		s ^tempCheck("DiseaseInd",row)=dataStr	
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// 根据描述获得特殊人群id的拼串,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getSpecialPopuIds("ml")
ClassMethod getSpecialPopuIds(special As %String) As %String
{
	//特殊人群
	s popu=""
	s popuflag=""
	TS
	if (special'="")
	{
		s special=..ChangeSeparator(special)			
		s argsLen=$Length(special,"#&")
		for i=1:1:argsLen
		{
			s arg=$p(special,"#&",i)
			s uparg=$ZCONVERT(arg,"U")
			if ($d(^DHCSPEP(0,"Desc",uparg))>0)
			{
				s idd=$o(^DHCSPEP(0,"Desc",uparg,0))
			}
			else
			{
				s obj=##class(User.DHCSpecialPopu).%New()
				s obj.SPECode = arg
				s obj.SPEDesc = arg
				s obj.SPEActiveFlag ="Y"
				s obj.SPESysFlag = "Y"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s idd=obj.%Id()
				}
			}
			if (idd'="") 
			{
				s:popu'="" popu=idd_","_popu
				s:popu="" popu=idd					
			}
			else
			{
				s popuflag=popuflag_"^"_0
			}
	
		}

	}
	if (popuflag'="")
	{
		Trollback
		s popu="false"
	}
	else
	{
		TC
	}
	q popu
}

/// 根据描述获得过敏史id,没有的话添加数据
/// w ##class(web.DHCBL.BDP.ImportKBData).GetAllergyId("")
ClassMethod GetAllergyId(allergy As %String) As %String
{
	s allergyDr=""
	//过敏史
	if (allergy'="")
	{
		s upallergy=$ZCONVERT(allergy,"U")
		if ($d(^DHCALLERGYi(0,"Desc",upallergy))>0)
		{
			s allergyDr=$o(^DHCALLERGYi(0,"Desc",upallergy,0)) 
		} 
		else
		{
			s obj=##class(User.DHCAllergyFeild).%New()
			s obj.ALFCode = allergy
			s obj.ALFDesc = allergy
			s obj.ALFActiveFlag = "Y"
			s obj.ALFSysFlag = "Y"
			TS
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				TC
				s allergyDr = obj.%Id()
			}
			else
			{
				Trollback
				s allergyDr=""
				
			}
		}

	}
	q allergyDr
}

/// Function:保存禁忌症 成功result:
ClassMethod SaveDiseaseCon(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempCheck("DiseaseCon",seq))
		q:seq=""
		s str=^tempCheck("DiseaseCon",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s gen=$p(dataStr,"[next]",1)
		s part=$p(dataStr,"[next]",2)
		s lib=$p(dataStr,"[next]",3)
		s dis=$p(dataStr,"[next]",4)	
		s age=$p(dataStr,"[next]",5)
		s agelimit=$p(dataStr,"[next]",6)
		s sex=$p(dataStr,"[next]",7)
		s special=$p(dataStr,"[next]",8)
		s allergy=$p(dataStr,"[next]",9)
		s text=$p(dataStr,"[next]",10)
		s mode=$p(dataStr,"[next]",11)
		s key0=$p(dataStr,"[next]",12)
		s key1=$p(dataStr,"[next]",13)
	
		//性别
		s:sex="男" sex="M"
		s:sex="女" sex="F"
		s:sex="全部" sex="A"
		s:sex="" sex="A"
		
		//控制级别
		s:mode="警示" mode="W"
		s:mode="管控" mode="C"
		s:mode="统计" mode="S"
		if ((mode'="W")&(mode'="C")&(mode'="S")){
			s mode="W"
		}
		//1判断必填项
		if ((gen="")||(part="")||(lib="")||(text=""))
		{   
		    q "false"
	    }

	    //通用名
		s gen=..getGenId(gen,lib)
		q:gen="" "false" 
			   
		//部位
		s part=..getPartId(part)
		q:part="" "false"
	
		//通用名和部位关联表
		s isLink=..getLinkORNo(gen,part)
		q:(isLink'="true") "false"
		
		s eobj=##class(web.Entity.KB.DHCCheckDiseaseC).%New()
	
		//插入主索引表			
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=part		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		s eobj.PHINSTSex=sex
		s eobj.PHINSTMode=mode
		

		//病症
		if (dis'="")
		{
			s disdr=..getDisIds(dis)
			q:(disdr="false") "false"
			s eobj.PHDDDiseaDr=disdr

		}
		//年龄
		if (age'="")
		{
			s age=..getAgeId(age)
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
				s PDAUomDr=..getUomId(ageUom)
				q:PDAUomDr="false" "false"
				s eobj.PDAUomDr=PDAUomDr
			} 
			s eobj.PDAMaxVal=ageMax
			s eobj.PDAMinVal=ageMin
		
		}
	
		//特殊人群
		s popu=""
		if (special'="")
		{				
			s popu=..getSpecialPopuIds(special)
			q:(popu="false") "false"
			s eobj.SpecialPopu=popu

		}
	
		//过敏史
		if (allergy'="")
		{
			s allergy=..GetAllergyId(allergy)
			q:(allergy="") "false"	
			s eobj.LALCAllergyDr=allergy						
		}
		
		//病症体征					
		if (key0'="")
		{
			s key0dr=..getKeyIds(key0,"0")
			q:(key0dr="false") "false"
			s eobj.PSYMKeyWordDr=key0dr 		
			
		}
		//治疗手术					
		if (key1'="")
		{
			s key1dr=..getKeyIds(key1,"1")
			q:(key1dr="false") "false"
			s eobj.PDCUKeyWordDr=key1dr 				
		}
		s str = ##class(web.DHCBL.KB.DHCCheckDiseaseC).SaveConData(eobj)
		if (str["false"){   
			q "false"
		}
		

		s result = "true"
		s ^tempCheck("DiseaseCon",row)=dataStr
		
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存不良反应 成功result:1^1^1
ClassMethod SavePHDAR(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempCheck("PHDAR",seq))
		q:seq=""
		s str=^tempCheck("PHDAR",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s gen=$p(dataStr,"[next]",1)	
		s part=$p(dataStr,"[next]",2)
		s lib=$p(dataStr,"[next]",3)
		s text=$p(dataStr,"[next]",4)

		//1判断必填项
		if ((gen="")||(part="")||(text="")||(lib=""))
		{   
		   	q "false"
	    }
	    //通用名
		s gen=..getGenId(gen,lib)
		q:gen="" "false" 
			   
		//部位
		s part=..getPartId(part)
		q:part="" "false"
	
		//通用名和部位关联表
		s isLink=..getLinkORNo(gen,part)
		q:(isLink'="true") "false"
		
		s eobj=##class(web.Entity.KB.DHCCheckAR).%New()
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=part
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PDAIOrdNum=row

		s str = ##class(web.DHCBL.KB.DHCCheckAR).SaveData(eobj)
		if (str["false"){   
			q "false"
		}			

		s result = "true"
		s ^tempCheck("PHDAR",row)=dataStr
		
	
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存注意事项 成功result:1^1^1
ClassMethod SavePHDMHA(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempCheck("PHDMHA",seq))
		q:seq=""
		s str=^tempCheck("PHDMHA",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s gen=$p(dataStr,"[next]",1)	
		s part=$p(dataStr,"[next]",2)
		s lib=$p(dataStr,"[next]",3)
		s text=$p(dataStr,"[next]",4)
	
		//1判断必填项
		if ((gen="")||(part="")||(text="")||(lib=""))
		{   
		   	q "false"
	    }
	    //通用名
		s gen=..getGenId(gen,lib)
		q:gen="" "false" 
			   
		//部位
		s part=..getPartId(part)
		q:part="" "false"
	
		//通用名和部位关联表
		s isLink=..getLinkORNo(gen,part)
		q:(isLink'="true") "false"
		
		s eobj=##class(web.Entity.KB.DHCCheckMHA).%New()
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=part
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PDAIOrdNum=row

		s str = ##class(web.DHCBL.KB.DHCCheckMHA).SaveData(eobj)
		
		if (str["false"){   
			q "false"
		}
					
		s result = "true"
		s ^tempCheck("PHDMHA",row)=dataStr
	
		
	}
	else
	{
		s result = "true"
	}	
	q result
}

}
