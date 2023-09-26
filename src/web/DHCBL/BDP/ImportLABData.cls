Import SQLUser

/// 名称:导入检验知识库模板
/// 编写者：基础数据平台组 -谷雪萍
/// 编写日期: 2015-12-14
Class web.DHCBL.BDP.ImportLABData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Others:s str="Qd[next]Qd[next]每日一次[next]每日一次"
/// Others:w ##class(web.DHCBL.BDP.ImportKBData).SaveData(str,2)
ClassMethod SaveData(dataStr As %String, sheetid As %String, row As %Float) As %String
{
	
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).Util(dataStr)	
	
 	/// Function:保存知识库标识字典  成功result:^1^1
	s:sheetid=2 result=..SaveLibaryLabel(dataStr)

	/// Function:保存知识库目录字典  成功result:^1^1
	s:sheetid=3 result=..SaveInstLabel(dataStr)
	
	/// Function:保存分类类型字典  成功result:^1^1^1^1
	s:sheetid=4 result=..SaveLibCat(dataStr)
	
	/// Function:保存诊断字典对照 成功result:^1^1^1^1^1^1^1
	s:sheetid=5 result=..SaveIcd(dataStr)
	
	/// Function:保存特殊人群字典  成功result:^1^1
	s:sheetid=6 result=..SaveSpecialPopu(dataStr)
	
	 /// Function:保存病症字典  成功result:^1^1^1^1
	s:sheetid=7 result=..SaveDiseaseList(dataStr)
	
	 /// Function:保存年龄字典  成功result:^1^1^1
	s:sheetid=8 result=..SaveAge(dataStr)
	
	/// Function:保存到通用名（检验标本） 成功result:^1^1^1^1^1^1^1
	s:sheetid=9 result=..SaveSPECGeneric(dataStr,row)
	
	/// Function:保存到通用名（检验项目） 成功result:^1^1^1^1^1^1^1
	s:sheetid=10 result=..SaveLABGeneric(dataStr)
	
	/// Function:保存适应症 成功result:^1^1^1
	s:sheetid=11 result=..SaveDiseaseInd(dataStr,row)

	/// Function:保存禁忌症 成功result:^1^1^1
	s:sheetid=12 result=..SaveDiseaseCon(dataStr,row)
		
	/// Function:保存到相互作用 成功result:^1^1^1
	s:sheetid=13 result=..SaveDisInteract(dataStr,row)
	
	/// Function:保存到临床意义 成功result:^1^1^1
	s:sheetid=14 result=..SaveClinical(dataStr,row)
	
	/// Function:保存到注意事项 成功result:^1^1^1
	s:sheetid=15 result=..SaveLABMHA(dataStr,row)
	
	/// Function:保存到检验结果辅助诊断 成功result:^1^1^1
	s:sheetid=16 result=..SaveLabResultDiag(dataStr,row)
	
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

/// Function:保存分类类型字典  成功result:^1^1^1^1
ClassMethod SaveLibCat(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)
	s lib=$p(dataStr,"[next]",3)
	s uptype=$p(dataStr,"[next]",4)
	s level=$p(dataStr,"[next]",5)
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
	    if (uptype'=""){
		    
		     s uptypeDr=" "_$ZCONVERT(uptype,"U")
		     s uptypeDr=$o(^User.DHCPHLibCatI("DescIndex",uptypeDr,0))
		     if (uptypeDr=""){
			     //上级分类先保存到字典表	
			    s eobj=##class(web.Entity.KB.DHCPHLibCat).%New()    
			    s eobj.PHICCode=uptype
			    s eobj.PHICDesc=uptype
			    s eobj.PHICLibDr=lib
			    s eobj.PHICActiveFlag="Y"
			    s eobj.PHICSysFlag="Y"
			    s str = ##class(web.DHCBL.KB.DHCPHLibCat).SaveData(eobj)
			    if (str["true"){   
				    s result=result_"^"_1
			    }
			    else{        
					s result=result_"^"_0   
			    }
		     }
	    }  
		//保存到字典表	
	    s eobj7=##class(web.Entity.KB.DHCPHLibCat).%New()
	    s upcode=" "_$ZCONVERT(code,"U") //转换成大写
		s updesc=" "_$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^User.DHCPHLibCatI("CodeIndex",upcode,0))
  		s idd=$o(^User.DHCPHLibCatI("DescIndex",updesc,0))
  		
  		s uptypeDr=" "_$ZCONVERT(uptype,"U")
		s uptypeDr=$o(^User.DHCPHLibCatI("DescIndex",uptypeDr,0))
  		//判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj7.PHICRowId=idc
		 }
	    
	    s eobj7.PHICCode=code
	    s eobj7.PHICDesc=desc
	    s eobj7.PHICLibDr=lib
	    s eobj7.PHICLastLevel=uptypeDr
	    s eobj7.PHICLevel=level
	    s eobj7.PHICActiveFlag=active
	    s eobj7.PHICSysFlag=sys
	    s str1 = ##class(web.DHCBL.KB.DHCPHLibCat).SaveData(eobj7)
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

/// Others:s str="急性咽炎[next]急性咽炎[next]jxya[next]咽炎/急性[next]y/j[next]咽炎/咽喉肿痛[next]备注[next]A00.000/A00.100"
/// Others:w ##class(web.DHCBL.BDP.ImportKBData).SaveData(str,13)
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

/// Function:保存到通用名（检验标本） 成功result:^1^1^1^1^1^1^1
ClassMethod SaveSPECGeneric(dataStr As %String, row As %Float) As %String
{
  s flag=""
  s seq=0
  for{
	s seq=$o(^tempLAB("SPECGeneric",seq))
	q:seq=""
	s str=^tempLAB("SPECGeneric",seq)
	if (str=dataStr) {
		s flag="repeat"
	}
  }
		
 if (flag="")
 {
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)	
	s desc=$p(dataStr,"[next]",4)
	s lib=$p(dataStr,"[next]",5)
	s keys=$p(dataStr,"[next]",6)
	s type=$p(dataStr,"[next]",7)
	s care=$p(dataStr,"[next]",8)
	s hisrowid=$p(dataStr,"[next]",9)

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
	
    	if (type'=""){
		     s type=" "_$ZCONVERT(type,"U")
		     s type=$o(^User.DHCPHLibCatI("DescIndex",type,0))
		     if (type=""){
			     s result=result_"^"_0
		     }
		     else{
			    s result=result_"^"_1 
		     }
	    } 
	
		//3保存到通用名字典表	
	    s eobj6=##class(web.Entity.KB.DHCPHExtGeneric).%New() 
	    s eobj6.PHEGCode=code
	    s eobj6.PHEGDesc=desc
	    s eobj6.PHEGLibDr=lib
	    s eobj6.PHEGActiveFlag="Y"
	    s eobj6.PHEGSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtGeneric).SaveData(eobj6)
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
        	//保存到通用名和HIS对照表
		   	if (hisrowid'="") { 			   	
				s ids=idc_"^"_hisrowid_"^"_"SPEC"_"^"_""
				s str2 = ##class(web.DHCBL.KB.DHCGenItmContrast).SaveLisData(ids)
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
	    	
	    	//保存到标本采集注意事项表
	   		if (type'="") {	   	
				 	s eobjscc=##class(web.Entity.KB.DHCLisSpecCollCare).%New()
				 	s eobjscc.LSCGenDr=idc
				 	s eobjscc.LSCCatDr=type
				 	s eobjscc.LSCCollCare=care
				 	s eobjscc.LSCSysFlag="Y"
	
				    s str1 = ##class(web.DHCBL.KB.DHCLisSpecCollCare).SaveData(eobjscc)
				    if (str1["true"){   
					    s result=result_"^"_1
				    }
				    else{        
						s result=result_"^"_0

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
		s ^tempLAB("SPECGeneric",row)=dataStr
	}
  }
  else
  {
	 s result = "true"
  }	
  q result
}

/// Function:保存到通用名（检验项目） 成功result:^1^1^1^1^1^1^1
ClassMethod SaveLABGeneric(dataStr As %String) As %String
{
	
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)	
	s desc=$p(dataStr,"[next]",4)
	s lib=$p(dataStr,"[next]",5)
	s turn=$p(dataStr,"[next]",6)	
	s keys=$p(dataStr,"[next]",7)
	s spec=$p(dataStr,"[next]",8)
	s atc=$p(dataStr,"[next]",9)
	s type=$p(dataStr,"[next]",10)
	s otflag=$p(dataStr,"[next]",11)
	s hisrowid=$p(dataStr,"[next]",12)

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
	
    	if (type'=""){
		     s type=" "_$ZCONVERT(type,"U")
		     s type=$o(^User.DHCPHLibCatI("DescIndex",type,0))
		     if (type=""){
			     s result=result_"^"_0
		     }
		     else{
			    s result=result_"^"_1 
		     }
	    } 

	    if (otflag'=""){
	     //医嘱类型标识（,检验项,检验套） 
			s:otflag="检验套" otflag="TS"
			s:otflag="检验项" otflag="TC"
			if ((otflag'="TS")&(otflag'="TC")){
				s result=result_"^"_0
			}else{
				s result=result_"^"_1
			}  
	    }
	    if (spec'=""){
		     s spec=$ZCONVERT(spec,"U")
		     s spec=$o(^DHCPHEGENi(0,"Desc",spec,0))
		     if (spec=""){
			     s result=result_"^"_0
		     }
		     else{
			    s result=result_"^"_1 
		     }
	    } 
		//3保存到通用名字典表	
	    s eobj6=##class(web.Entity.KB.DHCPHExtGeneric).%New() 
	    s eobj6.PHEGCode=code
	    s eobj6.PHEGDesc=desc
	    s eobj6.PHEGLibDr=lib
	    s eobj6.PHEGActiveFlag="Y"
	    s eobj6.PHEGSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtGeneric).SaveData(eobj6)
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
        	//保存到通用名和HIS对照表
		   	if (hisrowid'="") { 			   	
				s ids=idc_"^"_hisrowid_"^"_"LAB"_"^"_otflag
				s str2 = ##class(web.DHCBL.KB.DHCGenItmContrast).SaveLisData(ids)
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
	    	
	    	//保存检验通用名和标本关联
	   		if (spec'="") {	   	
				 	s eobjglp=##class(web.Entity.KB.DHCGenLinkPointer).%New()
				 	s eobjglp.GlPGenDr=idc
				 	s eobjglp.GlPPointer=spec
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
	    	
	    	//保存到通用名检验属性表
	   		if ((type'="")||(otflag'="") ||(atc'=""))
	   		{	   	
				 	s eobjlgp=##class(web.Entity.KB.DHCLisGenPro).%New()
				 	s eobjlgp.LGPGenDr=idc
				 	s eobjlgp.LGPCatDr=type
				 	s eobjlgp.LGPStCode=atc
				 	s eobjlgp.LGPSysFlag="Y"
				 	s eobjlgp.LGPOTFlag=otflag
	
				    s str1 = ##class(web.DHCBL.KB.DHCLisGenPro).SaveData(eobjlgp)
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

/// 把his的数据转移到知识库
/// Input:RowId-his的rowid，Code-his的code，Desc-his的Desc ，otflag-检验项还是检验套,lib-知识库标识 LAB是检验项目 SPEC是检验标本
/// return: wrongFlag -正确的时候是"", 错误返回1
/// w ##class(web.DHCBL.BDP.ImportLABData).TransLABGeneric()
ClassMethod TransLABGeneric(RowId As %String, Code As %String, Desc As %String, otflag As %String, libCode As %String) As %String
{
	new (RowId,Code,Desc,otflag,libCode)
	q:((RowId="")||(Code="")||(Desc="")||(libCode="")) ""
	s wrongFlag=""
	
	s lib=$o(^DHCPHLIBL(0,"Code",libCode,0))
	q:lib="" 1
	
	//保存到通用名字典表	
    s eobj=##class(web.Entity.KB.DHCPHExtGeneric).%New() 
    s eobj.PHEGCode=Code
    s eobj.PHEGDesc=Desc
    s eobj.PHEGLibDr=lib
    s eobj.PHEGActiveFlag="Y"
    s eobj.PHEGSysFlag="Y"
    s str1 = ##class(web.DHCBL.KB.DHCPHExtGeneric).SaveData(eobj)

    if (str1["false")&(str1'["该记录已经存在"){ 
    	b ;1   
	    s wrongFlag=1
    }
    q:(wrongFlag=1) 1
    s upcode=$ZCONVERT(Code,"U") //转换成大写
	s idc=$o(^DHCPHEGENi(0,"Code",upcode,0))

    s updesc=$ZCONVERT(Desc,"U")  //转换成大写
	s idd=$o(^DHCPHEGENi(0,"Desc",updesc,0))
	
	if (idc=""){
		s:idd'="" idc=idd
	}
	
    if (idc'="") 
    {
	   //保存到检验通用名与his对照表
		s ids=idc_"^"_RowId_"^"_libCode_"^"_otflag
		s str2 = ##class(web.DHCBL.KB.DHCGenItmContrast).SaveLisData(ids)
	    if (str2["false")&(str2'["该记录已对照"){   
	    	b ;2
		    s wrongFlag=1
	    }
	    
	    q:wrongFlag=1 1
	    
	    if (otflag="TS")
	    {
		    //保存到通用名检验属性表		
		 	s eobjlgp=##class(web.Entity.KB.DHCLisGenPro).%New()
		 	s eobjlgp.LGPGenDr=idc
		 	s eobjlgp.LGPStCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
		 	s eobjlgp.LGPSysFlag="Y"
		 	s eobjlgp.LGPOTFlag=otflag

		    s str3 = ##class(web.DHCBL.KB.DHCLisGenPro).SaveData(eobjlgp)
		    if (str3["false")&(str3'["该记录已经存在"){
			    b ;3   
			    s wrongFlag=1
		    }
	    }
    }
    q wrongFlag
}

/// 把his检验项目的数据转移到知识库
/// Input:otflag-检验项 TC  / 检验套 TS
/// return:    wrongFlag -正确的时候是"", 错误返回1
/// w ##class(web.DHCBL.BDP.ImportLABData).TransHisLabToKB("TC")
ClassMethod TransHisLabToKB(otflag As %String) As %String
{
	new (otflag)
	q:(otflag="") "检验项或检验套标识不能为空"
	q:(otflag'="TC")&(otflag'="TS") "检验项标识为TC，检验套标识为TS"
	s lib="LAB"
	s flag=""
	if (otflag="TC")  //检验项
	{
		if ($d(^DHCLISBSVersion(1)))  //新版
		{
			s RowId=0
			for
			{	
				s RowId=$o(^dbo.BTTestCodeD(RowId)) q:(RowId="")||(flag=1)
				s Code=$listget($g(^dbo.BTTestCodeD(RowId)),2)
				s Desc=$listget($g(^dbo.BTTestCodeD(RowId)),3)
				
				s flag=..TransLABGeneric(RowId,Code,Desc,otflag,lib)				
			}
		}
		else   //老版
		{
			s RowId=0
			for
			{	
				s RowId=$o(^TTAB("TC",RowId)) q:(RowId="")||(flag=1)
				s Code=RowId
				s Desc=$p($g(^TTAB("TC",RowId)),"\",1)
				s flag=..TransLABGeneric(RowId,Code,Desc,otflag,lib)
			}
		}
	}
	else //检验套
	{
		
		if ($d(^DHCLISBSVersion(1)))  //新版
		{  
			s RowId=0
			for
			{	
				s RowId=$o(^dbo.BTTestSetD(RowId)) q:(RowId="")||(flag=1)
				s Code=$listget($g(^dbo.BTTestSetD(RowId)),2)
				s Desc=$listget($g(^dbo.BTTestSetD(RowId)),3)
				
				s flag=..TransLABGeneric(RowId,Code,Desc,otflag,lib)
			}
		}
		else  //老版
		{
			s RowId=0
			s Subscript=0         
			for{
				s Subscript=$o(^ARCIM(Subscript)) q:(Subscript="")||(flag=1)
				s Version=0
				for  
				{	
					s Version=$o(^ARCIM(Subscript,Version)) q:(Version="")||(flag=1)
					s RowId = Subscript_"||"_Version
					//b ;
					s Code=$p($g(^ARCIM(Subscript,Version,1)),"^",1) 
					s Desc=$p($g(^ARCIM(Subscript,Version,1)),"^",2)  
					s ARCIMItemCatDR=$p($g(^ARCIM(Subscript,Version,1)),"^",10) 
					s:ARCIMItemCatDR'="" ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
					s:ARCIMItemCatDR="" ARCICOrderType=""
				
					i (ARCICOrderType="L")
					{
						s flag=..TransLABGeneric(RowId,Code,Desc,otflag,lib)
					}	
				}
			}

		}	
	}
	q flag
}

/// 把his检验标本的数据转移到知识库
/// Input:"'
/// return: flag -正确的时候是"", 错误返回1
/// w ##class(web.DHCBL.BDP.ImportLABData).TransHisSpecToKB()
ClassMethod TransHisSpecToKB() As %String
{
	s lib="SPEC"
	s flag=""
	
	s RowId=0
	if ($d(^DHCLISBSVersion(1)))  //新版
	{
		for
		{	
			s RowId=$o(^dbo.BTSpecimenD(RowId)) q:RowId=""
			s Code=$listget($g(^dbo.BTSpecimenD(RowId)),2)
			s Desc=$listget($g(^dbo.BTSpecimenD(RowId)),3)
			
			s flag=..TransLABGeneric(RowId,Code,Desc,"",lib)
		}
	}
	else   //老版
	{
		for
		{	
			s RowId=$o(^TTAB("SPEC",RowId)) q:RowId=""
			s Code=RowId
			s Desc=$p($g(^TTAB("SPEC",RowId)),"\",1)
			
			s flag=..TransLABGeneric(RowId,Code,Desc,"",lib)
		}	
	}
		
	q flag
}

/// w ##class(web.DHCBL.BDP.ImportLABData).ExportGenericGlobal()    //导出没导数据之前的数据
/// d $SYSTEM.OBJ.ImportDir("D:\", "GenericGlobal0810.gof")
ClassMethod ExportGenericGlobal()
{
	k CList
	k myIdx
	s CList($i(CList))= "DHCPHEGEN.GBL"  ;通用名字典
	s CList($i(CList))= "DHCPHEGENi.GBL"
	s CList($i(CList))= "DHCLISGP.GBL" ;通用名检验属性表
	s CList($i(CList))= "DHCLISGPi.GBL"
	s CList($i(CList))= "DHCPHGENCON.GBL"  ;通用名对照表
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}

	d $SYSTEM.OBJ.Export(items, "D:\GenericGlobal0810.gof", "", .log)
}

/// 根据描述获得通用名id,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getGenId("ml")
ClassMethod getGenId(gen As %String) As %String
{
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
		s lib=$o(^DHCPHLIBL(0,"Code","LAB",0))
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

/// 根据描述获得标本id,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getPointId("ml")
ClassMethod getPointId(gen As %String) As %String
{
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
		s lib=$o(^DHCPHLIBL(0,"Code","SPEC",0))
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
	q genid
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

/// 转换符号
/// w ##class(web.DHCBL.BDP.ImportKBData).ChangeSeparator("ml")
ClassMethod ChangeSeparator(str As %String) As %String
{
	s str=$tr(str,"。","")
	s str=$tr(str,"，","#&")
	s str=$tr(str,"、","#&")
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

/// Function:保存适应症 成功result:
ClassMethod SaveDiseaseInd(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempLAB("DiseaseInd",seq))
		q:seq=""
		s str=^tempLAB("DiseaseInd",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s result=""
		s mode=$p(dataStr,"[next]",1)	
		s gen=$p(dataStr,"[next]",2)
		s point=$p(dataStr,"[next]",3)
		s dis=$p(dataStr,"[next]",4)	
		s age=$p(dataStr,"[next]",5)
		s agelimit=$p(dataStr,"[next]",6)
		s sex=$p(dataStr,"[next]",7)
		s special=$p(dataStr,"[next]",8)
		s text=$p(dataStr,"[next]",9)
		s doctips=$p(dataStr,"[next]",10)	
		s note=$p(dataStr,"[next]",11)
	
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
		if (gen="")||(text="")
		{   
		    q "false" 
	    }
	    s:point="" point="空标本"   
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 	   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"

		s eobj=##class(web.Entity.KB.DHCLABDiseaseI).%New()
	
		//插入主索引表			
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=point		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTMode=mode
		s eobj.PHINSTText=text
		s eobj.PHINSTSex=sex
		s eobj.PHINSTDocUseTips=doctips
		s eobj.PHINSTNote=note
			
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
		//特殊人群special
		s popu=""
		if (special'="")
		{				
			s popu=..getSpecialPopuIds(special)
			q:(popu="false") "false"	
			s eobj.SpecialPopu=popu
		}			


		s str = ##class(web.DHCBL.KB.DHCLABDiseaseI).SaveIndData(eobj)
		if (str["false"){   
			q "false"
		}	    

		s result = "true"
		s ^tempLAB("DiseaseInd",row)=dataStr		
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存禁忌症 成功result:
ClassMethod SaveDiseaseCon(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempLAB("DiseaseCon",seq))
		q:seq=""
		s str=^tempLAB("DiseaseCon",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s mode=$p(dataStr,"[next]",1)	
		s gen=$p(dataStr,"[next]",2)
		s point=$p(dataStr,"[next]",3)
		s type=$p(dataStr,"[next]",4)
		s dis=$p(dataStr,"[next]",5)	
		s age=$p(dataStr,"[next]",6)
		s agelimit=$p(dataStr,"[next]",7)
		s sex=$p(dataStr,"[next]",8)
		s special=$p(dataStr,"[next]",9)
		s text=$p(dataStr,"[next]",10)
		s doctips=$p(dataStr,"[next]",11)	
		s note=$p(dataStr,"[next]",12)	
	
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
	
		//类型
		s:type="禁用" type="F"
		s:type="慎用" type="C"
		if ((type'="F")&(type'="C"))
		{
			s type="F"
		}
		
		//1判断必填项
		if (gen="")||(text="")
		{   
		    q "false" 
	    }
		s:point="" point="空标本"
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 
		   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"

		s eobj=##class(web.Entity.KB.DHCLABDiseaseC).%New()
	
		//插入主索引表			
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=point		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTMode=mode
		s eobj.PHINSTText=text
		s eobj.PHINSTSex=sex
		s eobj.PHINSTDocUseTips=doctips
		s eobj.PHINSTNote=note
	

		//病症
		if (dis'="")
		{
			s disdr=..getDisIds(dis)
			q:(disdr="false") "false"
			s eobj.PHDDDiseaDr=disdr
			s eobj.PHDDType=type
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
				
		s str = ##class(web.DHCBL.KB.DHCLABDiseaseC).SaveConData(eobj)
		if (str["false"){   
			q "false"
		}

		s result = "true"
		s ^tempLAB("DiseaseCon",row)=dataStr		
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:根据描述获取分类类型字典的id.没有的话加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).GetCatId()
ClassMethod GetCatId(cat As %String) As %String
{
	
	s catid=""
	if (cat'="")
	{
		s upcat=" "_$ZCONVERT(cat,"U")
		if ($d(^User.DHCPHLibCatI("DescIndex",upcat))>0) 
		{
  			s catid=$o(^User.DHCPHLibCatI("DescIndex",upcat,0))
		}

		else
		{
			s obj=##class(User.DHCPHLibCat).%New()
			s obj.PHICCode = cat
			s obj.PHICDesc = cat
			s lib=$o(^DHCPHLIBL(0,"Code","DRUG",0))
			d:lib'="" obj.PHICLibDrSetObjectId(lib)
			s obj.PHICActiveFlag = "Y"
			s obj.PHICSysFlag = "Y"
			TS
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				TC
				s catid = obj.%Id()
			}
			else
			{
				Trollback
				s catid=""
			}			
				
		}		
	}
	q catid
}

/// Function:保存相互作用 成功result:
ClassMethod SaveDisInteract(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempLAB("DisInteract",seq))
		q:seq=""
		s str=^tempLAB("DisInteract",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s mode=$p(dataStr,"[next]",1)	
		s gen=$p(dataStr,"[next]",2)
		s point=$p(dataStr,"[next]",3)
		s igen=$p(dataStr,"[next]",4)	
		s itype=$p(dataStr,"[next]",5)
		s text=$p(dataStr,"[next]",6)
	
		//1判断必填项
		if (gen="")||(text="")
		{   
		    q "false" 
	    }
		s:point="" point="空标本"
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 
		   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"

		//判断填入控制级别是否正确
		if (mode'="")
		{
	     	//管理模式（ ",Warn,Control,Stat"） 
			s:mode="警示" mode="W"
			s:mode="管控" mode="C"
			s:mode="统计" mode="S"
			if ((mode'="W")&(mode'="C")&(mode'="S")){
				s mode="W"
			} 
	    }
		//判断填入的相互作用通用名是否正确
		if (igen'="")
		{   s upgen=$ZCONVERT(igen,"U")  //转换成大写 			
			if ($d(^DHCPHEGENi(0,"Desc",upgen))>0)
			{
				s igen=$o(^DHCPHEGENi(0,"Desc",upgen,0))
			}
			else
			{
				s obj=##class(User.DHCPHExtGeneric).%New()
				s obj.PHEGCode = igen
				s obj.PHEGDesc = igen
				s lib=$o(^DHCPHLIBL(0,"Code","DRUG",0))
				d:lib'="" obj.PHEGLibDrSetObjectId(lib)
				s obj.PHEGActiveFlag = "Y"
				s obj.PHEGSysFlag = "Y"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s igen=obj.%Id()
				}
				else
				{
					s igen=""
				}

			}
			q:igen="" "false"

		}

		//判断填入的相互作用分类是否正确
		if (itype'="")
		{
			s itype=..GetCatId(itype)
			q:itype="" "false"
		
		}
	
		//插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCLABDiseaseInteract).%New()
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=point
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
	
		s eobj.PDINTGenDr=igen
		s eobj.PDINTCatDr=itype
		s eobj.PHINSTMode=mode

		s str = ##class(web.DHCBL.KB.DHCLABDiseaseInteract).SaveData(eobj)
		if (str["false"){   
			q "false"
		}
					
		s result = "true"
		s ^tempLAB("DisInteract",row)=dataStr		
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存临床意义 成功result:1^1^1
ClassMethod SaveClinical(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempLAB("Clinical",seq))
		q:seq=""
		s str=^tempLAB("Clinical",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s gen=$p(dataStr,"[next]",1)	
		s point=$p(dataStr,"[next]",2)
		s text=$p(dataStr,"[next]",3)
	
		
		//1判断必填项
		if ((gen="")||(text=""))
		{   
		    q "false"
	    }
	    s:point="" point="空标本"
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 
		   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"
		
		//插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCLabClinical).%New()
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=point
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"

		s str = ##class(web.DHCBL.KB.DHCLabClinical).SaveData(eobj)
		if (str["false"){   
			q "false"
		}

		s result = "true"
		s ^tempLAB("Clinical",row)=dataStr
		
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存注意事项 成功result:1^1^1
ClassMethod SaveLABMHA(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempLAB("LABMHA",seq))
		q:seq=""
		s str=^tempLAB("LABMHA",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s gen=$p(dataStr,"[next]",1)	
		s point=$p(dataStr,"[next]",2)
		s text=$p(dataStr,"[next]",3)
	
		//1判断必填项
		if ((gen="")||(text=""))
		{   
		    q "false"
	    }
	    s:point="" point="空标本"
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 
		   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"
		//插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCLABMHA).%New()
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=point
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PDAIOrdNum=row

		s str = ##class(web.DHCBL.KB.DHCLABMHA).SaveData(eobj)
		if (str["false"){   
			q "false"
		}
			
		s result = "true"
		s ^tempLAB("LABMHA",row)=dataStr		
		
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存检验结果辅助诊断 
ClassMethod SaveLabResultDiag(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempLAB("LabResultDiag",seq))
		q:seq=""
		s str=^tempLAB("LabResultDiag",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s gen=$p(dataStr,"[next]",1)	
		s point=$p(dataStr,"[next]",2)	
		s PLRDNormal=$p(dataStr,"[next]",3)
		s PLRDHigh=$p(dataStr,"[next]",4)
		s PLRDLow=$p(dataStr,"[next]",5)
		s PLRDNegative=$p(dataStr,"[next]",6)
		s PLRDPositive=$p(dataStr,"[next]",7)
		s PLRDOther=$p(dataStr,"[next]",8)
		s text=$p(dataStr,"[next]",9)
		//1判断必填项
		if ((gen="")||(text=""))
		{   
		    q "false"
	    }
	    s:point="" point="空标本"
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 
		   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"
		
		//插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCPHLibResultDiag).%New()
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=point
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		
		s eobj.PLRDNormal=PLRDNormal
		s eobj.PLRDHigh=PLRDHigh
		s eobj.PLRDLow=PLRDLow
		s eobj.PLRDNegative=PLRDNegative
		s eobj.PLRDPositive=PLRDPositive
		s eobj.PLRDOther=PLRDOther

		s str = ##class(web.DHCBL.KB.DHCPHLibResultDiag).SaveData(eobj)
		if (str["false"){   
			q "false"
		}
			
		s result = "true"
		s ^tempLAB("LabResultDiag",row)=dataStr		
		
	}
	else
	{
		s result = "true"
	}	
	q result
}

}
