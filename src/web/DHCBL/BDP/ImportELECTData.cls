Import SQLUser

/// 名称:导入临床知识库模板
/// 编写者：基础平台组 
/// 编写日期: 2015-11-3
Class web.DHCBL.BDP.ImportELECTData Extends %RegisteredObject
{

/// Others:s str="Qd[next]Qd[next]每日一次[next]每日一次"
/// Others:w ##class(web.DHCBL.BDP.ImportELECTData).SaveData(str,2)
ClassMethod SaveData(dataStr As %String, sheetid As %String, row As %Float) As %String
{
	
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).Util(dataStr)		
	
 	/// Function:保存知识库标识字典  成功result:^1^1
	s:sheetid=2 result=..SaveLibaryLabel(dataStr)

	/// Function:保存知识库目录字典  成功result:^1^1
	s:sheetid=3 result=..SaveInstLabel(dataStr)
	
	 /// Function:保存检查结果字典  成功result:^1^1
	s:sheetid=4 result=..SaveExamine(dataStr)
	
	/// Function:保存生理字典  成功result:^1^1
	s:sheetid=5 result=..SavePhysiology(dataStr)
	
	/// Function:保存分类类型字典  成功result:^1^1^1^1
	s:sheetid=6 result=..SaveLibCat(dataStr)
	
	/// Function:保存单位字典对照  成功result:^1^1^1^1
	s:sheetid=7 result=..SaveExtUom(dataStr)
	
	/// Function:保存诊断字典对照 成功result:^1^1^1^1^1^1^1
	s:sheetid=8 result=..SaveIcd(dataStr)
	
	/// Function:保存病症字典  成功result:^1^1^1^1
	s:sheetid=9 result=..SaveDiseaseList(dataStr)
	
	/// Function:保存检查部位  成功result:^1^1^1
	s:sheetid=10 result=..SavePart(dataStr)
	
	/// Function:保存到通用名 成功result:^1^1^1^1^1^1^1
	s:sheetid=11 result=..SaveGeneric(dataStr)
	
	/// Function:保存适应症 成功result:^1^1^1
	s:sheetid=12 result=..SaveDiseaseInd(dataStr,row)
	
	/// Function:保存禁忌症 成功result:^1^1^1
	s:sheetid=13 result=..SaveDiseaseCon(dataStr,row)
	
		/// Function:保存到相互作用 成功result:^1^1^1
	s:sheetid=14 result=..SaveECGInteract(dataStr,row)
	
	/// Function:保存到不良反应 成功result:^1^1^1
	s:sheetid=15 result=..SaveECGAR(dataStr,row)
	
	/// Function:保存到注意事项 成功result:^1^1^1
	s:sheetid=16 result=..SaveECGMHA(dataStr,row)
	
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

/// s str="正常[next]正常[next]心电[next]"
/// Function:保存检查结果字典  成功result:^1^1^1^1
ClassMethod SaveExamine(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)
	s lib=$p(dataStr,"[next]",3)
		
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
  		     
		//保存到字典表	
	    s eobj=##class(web.Entity.KB.DHCExamineFeild).%New()
	    //判断是添加还是修改
		s upcode=$ZCONVERT(code,"U") //转换成大写
		s updesc=$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^DHCEXAMINEi(0,"Code",upcode,0))
		s idd=$o(^DHCEXAMINEi(0,"Desc",updesc,0))
		//判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj.ExaRowId=idc
		 }
		 //b ;idc	,idd	
	    s eobj.ExaCode=code
	    s eobj.ExaResult=desc
	    s eobj.ExaLibDr=lib
	    s eobj.ExaActiveFlag="Y"
	    s eobj.ExaSysFlag="Y"
	    s str = ##class(web.DHCBL.KB.DHCExamineFeild).SaveData(eobj)
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

/// Function:保存生理字典  成功result:^1^1
ClassMethod SavePhysiology(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)
	s type=$p(dataStr,"[next]",3)
	s active=$p(dataStr,"[next]",4)
	s sys=$p(dataStr,"[next]",5)
	s active=$ZCONVERT(active,"U") 
	s sys=$ZCONVERT(sys,"U") 
	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1      
		//保存到字典表	
	    s eobj11=##class(web.Entity.KB.DHCPhysiologyFeild).%New()
	    
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s updesc=$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^DHCPHYSIFi(0,"Code",upcode,0))
		s idd=$o(^DHCPHYSIFi(0,"Desc",updesc,0))
		//判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj11.PHYFRowId=idc
		 }
		
	    s eobj11.PHYFCode=code
	    s eobj11.PHYFDesc=desc
	    s eobj11.PHYFType=type
	    s eobj11.PHYFActiveFlag=active
	    s eobj11.PHYFSysFlag=sys
	    s str1 = ##class(web.DHCBL.KB.DHCPhysiologyFeild).SaveData(eobj11)
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

/// Function:保存单位字典对照  成功result:^1^1^1^1 
/// s str="次[next]次[next]次[next]次[next]"
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

/// s str="04[next]心脏[next]心脏[next]心脏[next]"
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
			s upcode=$ZCONVERT(code,"U") //转换成大写
		    s cid=$o(^DHCPHEPA(0,"Code",upcode,0))	   
	   		//b ;hiscid,hisdid,cid,did
		    //判断填入的数据是否正确
		    if ((hiscid="")||(cid=""))
		    { 
				 s result=result_"^"_0
		    }
			else{
				s result=result_"^"_1
				
				s ids=cid_"^"_hiscid
				s str2 = ##class(web.DHCBL.KB.DHCPHPartContrast).SaveData(ids)
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
			   if ((hiscid="")||(hisdid="")||(hiscid'=hisdid))
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
		s lib=$o(^DHCPHLIBL(0,"Desc","ELECT",0))
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

/// 根据描述获得病症id的拼串,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getDisIds("ml")
ClassMethod getExaIds(exa As %String) As %String
{
	s result=""
	s exaflag=""
	s exadr=""
	TS
	if (exa'="")
	{
		s exa=..ChangeSeparator(exa)
		s argsLen=$Length(exa,"#&")
		for i=1:1:argsLen
		{
			s did=""
			s arg=$p(exa,"#&",i)
			continue:arg=""
			s uparg=$ZCONVERT(arg,"U")
			if ($d(^DHCEXAMINEi(0,"Desc",uparg))>0)
			{
				s did=$o(^DHCEXAMINEi(0,"Desc",uparg,0))  
			}
			else
			{
				s obj=##class(User.DHCExamineFeild).%New()
				s obj.ExaCode = arg
				s obj.ExaResult = arg
				s lib=$o(^DHCPHLIBL(0,"Desc","ELECT",0))
				d:lib'="" obj.ExaLibDrSetObjectId(lib)
				s obj.ExaActiveFlag ="Y" 
				s obj.ExaSysFlag ="Y"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s did=obj.%Id()
				}
				
			}
			if (did'="") 
			{
				s:(exadr'="") exadr=exadr_","_did
				s:(exadr="") exadr=did				
			}
			else
			{
				s exaflag=exaflag_"^"_0
			}
	
		}			

	}
	if (exaflag'="")
	{
		Trollback
		s result="false"
	}
	else
	{
		TC
		s result= exadr
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
		s seq=$o(^tempELECT("DiseaseInd",seq))
		q:seq=""
		s str=^tempELECT("DiseaseInd",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s result=""
		s gen=$p(dataStr,"[next]",1)
		s part=$p(dataStr,"[next]",2)
		s dis=$p(dataStr,"[next]",3)	
        s exa=$p(dataStr,"[next]",4)
		s text=$p(dataStr,"[next]",5)
		s mode=$p(dataStr,"[next]",6)
		//控制级别
		s:mode="警示" mode="W"
		s:mode="管控" mode="C"
		s:mode="统计" mode="S"
		if ((mode'="W")&(mode'="C")&(mode'="S")){
			s mode="W"
		}
		//1判断必填项
		if ((gen="")||(part=""))
		{   
		    q "false"
	    }
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 	   
		//部位
		s part=..getPartId(part)
		q:part="" "false"
		
		//通用名和部位关联表
		s isLink=..getLinkORNo(gen,part)
		q:(isLink'="true") "false"
		
		s eobj=##class(web.Entity.KB.DHCECGDiseaseI).%New()
	
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
			s disdr=..getDisIds(dis)
			q:(disdr="false") "false"
			s eobj.PHDDDiseaDr=disdr

		}
		
		//判断填入的检查结果是否正确
		if (exa'="")
		{
			s exadr=..getExaIds(exa)
			q:(exadr="false") "false"
			s eobj.PHDDExamDr=exadr

		}

		s str = ##class(web.DHCBL.KB.DHCECGDiseaseI).SaveIndData(eobj)
		if (str["false"){   
			q "false"
		}
		
		s result = "true"
		s ^tempELECT("DiseaseInd",row)=dataStr
		
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// 根据描述获得生理id,没有的话添加数据
/// w ##class(web.DHCBL.BDP.ImportKBData).GetPhyId("")
ClassMethod GetPhyId(phy As %String) As %String
{
	s phyDr=""
	//生理
	if (phy'="")
	{
		s upphy=$ZCONVERT(phy,"U")
		if ($d(^DHCPHYSIFi(0,"Desc",upphy))>0)
		{
			s phyDr=$o(^DHCPHYSIFi(0,"Desc",upphy,0))
		} 
		else
		{
			s obj=##class(User.DHCPhysiologyFeild).%New()
			s obj.PHYFCode =phy
			s obj.PHYFDesc = phy
			s obj.PHYFActiveFlag = "Y"
			s obj.PHYFSysFlag = "Y"
			TS
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				TC
				s phyDr = obj.%Id()
			}
			else
			{
				Trollback
				s phyDr=""
			}
			
		} 

	}
	q phyDr
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

/// Function:保存禁忌症 成功result:
ClassMethod SaveDiseaseCon(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempELECT("DiseaseCon",seq))
		q:seq=""
		s str=^tempELECT("DiseaseCon",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{	
		s gen=$p(dataStr,"[next]",1)
		s part=$p(dataStr,"[next]",2)
		s dis=$p(dataStr,"[next]",3)
		s exa=$p(dataStr,"[next]",4)	
		s phy=$p(dataStr,"[next]",5)
		s phylimit=$p(dataStr,"[next]",6)
		s Lab=$p(dataStr,"[next]",7)
		s LABLimit=$p(dataStr,"[next]",8)
		s LABIMinVal="",LABIMaxVal=""
		if (LABLimit'="")
		{
			if (LABLimit["-")
			{
				s LABIMinVal=$p(LABLimit,"-",1)
				s LABIMaxVal=$p(LABLimit,"-",2)
			}
			else
			{
				s LABIMaxVal=LABLimit
			}
		}
		s LABIUom=$p(dataStr,"[next]",9)
		s text=$p(dataStr,"[next]",10)
		s mode=$p(dataStr,"[next]",11)
		
		//控制级别
		s:mode="警示" mode="W"
		s:mode="管控" mode="C"
		s:mode="统计" mode="S"
		if ((mode'="W")&(mode'="C")&(mode'="S")){
			s mode="W"
		}
	
		//1判断必填项
		if ((gen="")||(part=""))
		{   
		    q "false"
	    }
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 	   
		//部位
		s part=..getPartId(part)
		q:part="" "false"
		
		//通用名和部位关联表
		s isLink=..getLinkORNo(gen,part)
		q:(isLink'="true") "false"
		
		s eobj=##class(web.Entity.KB.DHCECGDiseaseC).%New()
	
		//插入主索引表			
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=part		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		s eobj.PHINSTMode=mode
	

		//病症
		if (dis'="")
		{
			s disdr=..getDisIds(dis)
			q:(disdr="false") "false"
			s eobj.PHDDDiseaDr=disdr
		}
		
		//判断填入的检查结果是否正确
		if (exa'="")
		{
			s exadr=..getExaIds(exa)
			q:(exadr="false") "false"
			s eobj.PHDDExamDr=exadr
		}
		

		//生理
		if (phy'="")
		{
			s phy=..GetPhyId(phy)
			q:(phy="") "false"	
			s eobj.PHYVFeildDr=phy
			//x-y 或者y 默认没有x
			if (phylimit'="")
			{
				if (phylimit["-")
				{
					s phymin=$p(phylimit,"-",1)
					s phymax=$p(phylimit,"-",2)
				}
				else
				{
					s phymin=""
					s phymax=phylimit
				}
			}
			s eobj.PHYVMinVal=phymin
			s eobj.PHYVMaxVal=phymax

		}
		
		//检验项目
		if (Lab'="")
		{
			s upLab=$ZCONVERT(Lab,"U")  //转换成大写
			if ($d(^DHCPHEGENi(0,"Desc",upLab))>0)
			{
				s LabDr=$o(^DHCPHEGENi(0,"Desc",upLab,0))
			}
			else
			{
				s obj=##class(User.DHCPHExtGeneric).%New()
				s obj.PHEGCode = Lab
				s obj.PHEGDesc = Lab
				s lib=$o(^DHCPHLIBL(0,"Code","LAB",0))
				d:lib'="" obj.PHEGLibDrSetObjectId(lib)
				s obj.PHEGActiveFlag = "Y"
				s obj.PHEGSysFlag = "Y"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s LabDr=obj.%Id()
				}
				else
				{
					s LabDr=""
					q "false"
				}
				
			}
			if (LabDr'="") 
			{	
				s eobj.LABILabDr=LabDr 		
			}
		}
		//指标值范围
		s eobj.LABIMinVal=LABIMinVal 
		s eobj.LABIMaxVal=LABIMaxVal 
		
		if (LABIUom'="")
		{
			s LABIUomDr=..getUomId(LABIUom)
			q:LABIUomDr="false" "false"
			s eobj.LABIUomDr=LABIUomDr

		}  

	
		s str = ##class(web.DHCBL.KB.DHCECGDiseaseC).SaveConData(eobj)
		if (str["false"){   
			q "false"
		}
				
		s result = "true"
		s ^tempELECT("DiseaseCon",row)=dataStr
				
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
ClassMethod SaveECGInteract(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempELECT("ECGInteract",seq))
		q:seq=""
		s str=^tempELECT("ECGInteract",seq)
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
		if ((gen="")||(point=""))
		{   
		   q "false" 
	    }
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 
		   
		//部位
		s point=..getPartId(point)
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
		s eobj=##class(web.Entity.KB.DHCECGInteract).%New()
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

		s str = ##class(web.DHCBL.KB.DHCECGInteract).SaveData(eobj)
		if (str["false"){   
			q "false"
		}
		
		s result = "true"
		s ^tempELECT("ECGInteract",row)=dataStr				
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存不良反应 成功result:1^1^1
ClassMethod SaveECGAR(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempELECT("ECGAR",seq))
		q:seq=""
		s str=^tempELECT("ECGAR",seq)
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
		if ((gen="")||(point="")||(text=""))
		{   
		    q "false"
	    }
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 
		   
		//部位
		s point=..getPartId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"
		
		//插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCECGAR).%New()
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=point
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PDAIOrdNum=row

		s str = ##class(web.DHCBL.KB.DHCECGAR).SaveData(eobj)
		if (str["false"){   
			s result=result_"^"_1
		}
			
		s result = "true"
		s ^tempELECT("ECGAR",row)=dataStr
		
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存注意事项 成功result:1^1^1
ClassMethod SaveECGMHA(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempELECT("ECGMHA",seq))
		q:seq=""
		s str=^tempELECT("ECGMHA",seq)
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
		if ((gen="")||(point="")||(text=""))
		{   
		    q "false"
	    }
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 
		   
		//部位
		s point=..getPartId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"
		
		//插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCECGMHA).%New()
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=point
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PDAIOrdNum=row

		s str = ##class(web.DHCBL.KB.DHCECGMHA).SaveData(eobj)
		if (str["true"){   
			s result=result_"^"_1
		}
		
		s result = "true"
		s ^tempELECT("ECGMHA",row)=dataStr
				
	}
	else
	{
		s result = "true"
	}	
	q result
}

}
