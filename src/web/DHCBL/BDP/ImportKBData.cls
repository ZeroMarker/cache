Import SQLUser

/// 名称:导入临床知识库模板
/// 编写者：基础数据平台组 
/// 编写日期: 2015-11-3
Class web.DHCBL.BDP.ImportKBData Extends %RegisteredObject [ Not ProcedureBlock ]
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
	
	 /// Function:保存频率字典  成功result:^1^1^1^1
	s:sheetid=4 result=..SaveExtFreq(dataStr)
	
	/// Function:保存剂型字典对照   成功result:^1^1^1^1
	s:sheetid=5 result=..SaveExtForm(dataStr)
	
	/// Function:保存用法字典对照  成功result:^1^1^1^1
	s:sheetid=6 result=..SaveExtInstruc(dataStr)
	
	 /// Function:保存单位字典对照  成功result:^1^1^1^1
	s:sheetid=7 result=..SaveExtUom(dataStr)
	
	/// Function:保存分类类型字典  成功result:^1^1^1^1
	s:sheetid=8 result=..SaveLibCat(dataStr)
	
	 /// Function:保存诊断字典对照 成功result:^1^1^1^1^1^1^1
	s:sheetid=9 result=..SaveIcd(dataStr)
	
	 /// Function:保存特殊人群字典  成功result:^1^1
	s:sheetid=10 result=..SaveSpecialPopu(dataStr)
	
	 /// Function:保存药品成分字典  成功result:^1^1
	s:sheetid=11 result=..SaveIngr(dataStr)
	
	 /// Function:保存生理字典  成功result:^1^1
	s:sheetid=12 result=..SavePhysiology(dataStr)
	
	 /// Function:保存病症字典  成功result:^1^1^1^1
	s:sheetid=13 result=..SaveDiseaseList(dataStr)
	
	 /// Function:保存年龄字典  成功result:^1^1^1
	s:sheetid=14 result=..SaveAge(dataStr)
	
	/// Function:保存过敏史  成功result:^1^1^1^1^1
	s:sheetid=15 result=..SaveAllergy(dataStr)
	
	/// Function:保存既往史  成功result:^1^1^1^1^1
	s:sheetid=16 result=..SaveHistory(dataStr)
	
	/// Function:保存到通用名（药品） 成功result:^1^1^1^1^1^1^1
	s:sheetid=17 result=..SaveGeneric(dataStr)
	
	/// Function:保存适应症 成功result:^1^1^1
	s:sheetid=18 result=..SaveDiseaseInd(dataStr,row)
	
	/// Function:保存禁忌症 成功result:^1^1^1
	s:sheetid=19 result=..SaveDiseaseCon(dataStr,row)
	
	/// Function:保存给药途径  成功result:^1^1^1
	s:sheetid=20 result=..SaveDiseaseUse(dataStr,row)
	
	/// Function:保存给药频次  成功result:^1^1^1
	s:sheetid=21 result=..SaveDiseaseFreq(dataStr,row)
	
	/// Function:保存用法用量  成功result:^1^1^1
	s:sheetid=22 result=..SaveUsageDosage(dataStr,row)
	
	/// Function:保存到相互作用 成功result:^1^1^1
	s:sheetid=23 result=..SaveDisInteract(dataStr,row)
	
	/// Function:保存到不良反应 成功result:^1^1^1
	s:sheetid=24 result=..SavePHDAR(dataStr,row)
	
	/// Function:保存到注意事项 成功result:^1^1^1
	s:sheetid=25 result=..SavePHDMHA(dataStr,row)
	
    /// Function:保存商品名字典  成功result:^1^1^1^1
	s:sheetid=26 result=..SaveProName(dataStr)
	//s:sheetid=26 result=..DeleteProName(dataStr)
	
	/// Function:保存溶媒分类字典  成功result:^1^1^1^1
	s:sheetid=27 result=..SaveMenstruumCat(dataStr)
	
	/// Function:保存溶媒分类字典  成功result:^1^1^1^1
	s:sheetid=28 result=..SaveMenstruumItm(dataStr)
	
	/// Function:保存药品规格字典表  成功result:^1^1^1^1
	s:sheetid=29 result=..SaveExtSqec(dataStr)
	
	/// Function:保存科室字典表  成功result:^1^1^1^1
	s:sheetid=30 result=..SaveHospLoc(dataStr)

	/// Function:保存症状字典表  成功result:^1^1^1^1
	s:sheetid=31 result=..SaveSymptom(dataStr)	
	
	/// Function:保存证型字典表  成功result:^1^1^1^1
	s:sheetid=32 result=..SaveSyndrome(dataStr)	

	/// Function:保存溶媒量  
	s:sheetid=33 result=..SaveMenstruumQty(dataStr,row)	
	
	/// Function:保存浓度 
	s:sheetid=34 result=..SaveDrgSolvent(dataStr,row)
	
	/// Function:保存可配伍药品
	s:sheetid=35 result=..SaveDrgAlone(dataStr,row)		
	
	/// Function:保存成分含量（g）
	s:sheetid=36 result=..SaveEleCon(dataStr,row)
	
	/// Function:保存联合用药 
	s:sheetid=37 result=..SaveMustDrug(dataStr,row)		

	/// Function:保存辅助用药个数
	s:sheetid=38 result=..SaveAssDrugNum(dataStr,row)	
	
	/// Function:保存重复用药规则
	s:sheetid=39 result=..SaveRepeatFeild(dataStr)
	
	/// Function:保存重复用药
	s:sheetid=40 result=..SaveRepeatItm(dataStr,row)	
	
	/// Function:保存配伍禁忌 成功result:^1^1^1
	s:sheetid=41 result=..SaveDrugContrain(dataStr,row)
	
	/// Function:保存炮制作用 成功result:^1^1^1
	s:sheetid=42 result=..SaveProcessingAct(dataStr,row)
	
	/// Function:保存厂家字典  成功result:^1^1
	s:sheetid=43 result=..SavePHManf(dataStr)
	
	/// Function:保存草药毒性字典  成功result:^1^1
	s:sheetid=44 result=..SavePHToxicity(dataStr)
		
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

/// Function:保存频率字典  成功result:^1^1^1^1
ClassMethod SaveExtFreq(dataStr As %String) As %String
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
		//保存到频率字典表	
	    s eobj2=##class(web.Entity.KB.DHCPHExtFreq).%New()
	    s eobj2.PHEFCode=code
	    s eobj2.PHEFDesc=desc
	    s eobj2.PHEFActiveFlag="Y"
	    s eobj2.PHEFSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtFreq).SaveData(eobj2)
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
    
	    //保存到频率对照表
	    if ((hiscode'="")&(hisdesc'="")) {  //如果HIS频率代码为空
		   s uphiscode=$$ALPHAUP^SSUTIL4(hiscode) //转换成大写
		   s hiscid=$o(^PHCFR(0,"Code",uphiscode,0))
		   s uphisdesc=$$ALPHAUP^SSUTIL4(hisdesc) //转换成大写
		   s hisdid=$o(^PHCFR(0,"Desc1",uphisdesc,0))
	   
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCPHEFRi(0,"Code",upcode,0))
		   s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCPHEFRi(0,"Desc",updesc,0))
	   	   //b ;hiscid,hisdid,cid,did
		    //判断填入的数据是否正确
		   if ((hiscid="")||(cid=""))
		   { 
				 s result=result_"^"_0
		    }
			else
			{
				s result=result_"^"_1
				   	
				s ids=cid_"^"_hiscid
				s str2 = ##class(web.DHCBL.KB.DHCPHFreqContrast).SaveData(ids)
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

/// Function:保存剂型字典对照   成功result:^1^1^1^1
ClassMethod SaveExtForm(dataStr As %String) As %String
{
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)
	s desc=$p(dataStr,"[next]",4)
    /*if ($d(^DHCPHEFi(0,"Desc",$ZCONVERT(desc,"U")))>0)
	{
		s desc=desc_code
	}*/
	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{
	    s result=result_"^"_1    
		//保存到剂型字典表	
	    s eobj3=##class(web.Entity.KB.DHCPHExtForm).%New()
	    s eobj3.PHEFCode=code
	    s eobj3.PHEFDesc=desc
	    s eobj3.PHEFActiveFlag="Y"
	    s eobj3.PHEFSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtForm).SaveData(eobj3)
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
    	
	    //保存到剂型对照表 特例^PHCF(0,"Code","乳液"_$c(13,10),94) 
	    if ((hiscode'="")&(hisdesc'="")) {  //如果HIS代码为空
		   s uphiscode=$$ALPHAUP^SSUTIL4(hiscode) //转换成大写
		   s hiscid=$o(^PHCF(0,"Code",uphiscode,0))
		   
		   s shiscid=$o(^PHCF(0,"Code",uphiscode_$c(13,10),0))
	   
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCPHEFi(0,"Code",upcode,0))
		   
	   		//b ;hiscid,hisdid,cid,did
		    //判断填入的数据是否正确
		    s sflag=""
		   if ((hiscid'="")){
			   s sflag="Y"
		   }
		   if ((shiscid'="")){
			   s sflag="Y"
		   }
		   if (sflag=""||(cid="")){ 
				 s result=result_"^"_0
		    }
			else{
				s result=result_"^"_1
				s ids=""
				if (hiscid'=""){	
					s ids=cid_"^"_hiscid
				}
				if (shiscid'=""){
					s ids=cid_"^"_shiscid
				}

				s str2 = ##class(web.DHCBL.KB.DHCPHFormContrast).SaveData(ids)

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

/// Function:保存用法字典对照  成功result:^1^1^1^1
ClassMethod SaveExtInstruc(dataStr As %String) As %String
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
		//保存到用法字典表	
	    s eobj4=##class(web.Entity.KB.DHCPHExtInstruc).%New()
	    s eobj4.PHEINCode=code
	    s eobj4.PHEINDesc=desc
	    s eobj4.PHEINActiveFlag="Y"
	    s eobj4.PHEINSysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtInstruc).SaveData(eobj4)
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
    
	    //保存到用法对照表
	    if ((hiscode'="")&(hisdesc'="")) {  //如果HIS用法代码为空
		   s uphiscode=$$ALPHAUP^SSUTIL4(hiscode) //转换成大写
		   s hiscid=$o(^PHCIN(0,"Code",uphiscode,0))
		   s uphisdesc=$$ALPHAUP^SSUTIL4(hisdesc) //转换成大写
		   s hisdid=$o(^PHCIN(0,"Desc1",uphisdesc,0))
	   
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCPHEINSTRi(0,"Code",upcode,0))
		   s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCPHEINSTRi(0,"Desc",updesc,0))
	   	  // b ;hiscid,hisdid,cid,did
		    //判断填入的数据是否正确
		   if ((hiscid="")||(hisdid="")||(hiscid'=hisdid)||(cid="")||(did="")||(cid'=did))
		   { 
				 s result=result_"^"_0
		    }
			else
			{
				s result=result_"^"_1
				   	
				s ids=cid_"^"_hiscid
				s str2 = ##class(web.DHCBL.KB.DHCPHInstContrast).SaveData(ids)
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

/// Function:保存药品成分字典  成功result:^1^1
ClassMethod SaveIngr(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)
	s uptype=$p(dataStr,"[next]",3)
	s Level=$p(dataStr,"[next]",4)
	s active=$p(dataStr,"[next]",5)
	s sys=$p(dataStr,"[next]",6)
	s relation=$p(dataStr,"[next]",7)
	s PivaTotalQty=$p(dataStr,"[next]",8)
	s active=$ZCONVERT(active,"U") 
	s:active="" active="Y"
	s sys=$ZCONVERT(sys,"U") 
	s:sys="" sys="Y"
	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1
   		if (uptype'=""){
		     s uptypeDr=" "_$ZCONVERT(uptype,"U")
		     s uptypeDr=$o(^User.DHCPHExtIngrI("DescIndex",uptypeDr,0))
		     if (uptypeDr=""){
			     //上级分类先保存到字典表	
			    s eobj=##class(web.Entity.KB.DHCPHExtIngr).%New()    
			    s eobj.PHEINGCode=uptype
			    s eobj.PHEINGDesc=uptype
			    s eobj.PHEINGActiveFlag="Y"
			    s eobj.PHEINGSysFlag="Y"
			    s str = ##class(web.DHCBL.KB.DHCPHExtIngr).SaveData(eobj)
			    if (str["true"){   
				    s result=result_"^"_1
			    }
			    else{        
					s result=result_"^"_0   
			    }
		     }
	    }  
	   //逻辑
	   if (relation'="")
		{ 
			s:relation="大于" relation=">"
			s:relation="小于" relation="<"
			s:relation="等于" relation="="
			s:relation="不大于" relation="!>"
			s:relation="不小于" relation="!<"
			s:relation="不等于" relation="<>"
			if ((relation'=">")&(relation'="<")&(relation'="=")&(relation'="!>")&(relation'="!<")&(relation'="<>")){
				s relation=""
			} 
	    }      
		//保存到字典表	
	    s eobj10=##class(web.Entity.KB.DHCPHExtIngr).%New()
	    s upcode=" "_$ZCONVERT(code,"U") //转换成大写
		s idc=$o(^User.DHCPHExtIngrI("CodeIndex",upcode,0))
		s uptypeDr=" "_$ZCONVERT(uptype,"U")
		s uptypeDr=$o(^User.DHCPHExtIngrI("DescIndex",uptypeDr,0))
		//判断是添加还是修改
		 if (idc'="")
		 { 
			s eobj10.PHEINGRowId=idc
		 }
	    s eobj10.PHEINGCode=code
	    s eobj10.PHEINGDesc=desc
	    s eobj10.PHEINGLastLevel=uptypeDr
	    s eobj10.PHEINGLevel=Level
	    s eobj10.PHEINGActiveFlag=active
	    s eobj10.PHEINGSysFlag=sys
	    s eobj10.PHEINGRelation=relation
	    s eobj10.PHEINGPivaTotalQty=PivaTotalQty
	    s str1 = ##class(web.DHCBL.KB.DHCPHExtIngr).SaveData(eobj10)
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
							//s ^ERRORKB(sheetname,DiseaCode,DiseaDesc,"Alias")=datastr_"&&"_estr
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
							//s ^ERRORKB(sheetname,DiseaCode,DiseaDesc,"Com")=datastr_"&&"_estr
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

/// Function:保存既往史  成功result:^1^1^1^1^1
ClassMethod SaveHistory(dataStr As %String) As %String
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
	    s eobj15=##class(web.Entity.KB.DHCDisHistoryFeild).%New()
	    s eobj15.DHICode=code
	    s eobj15.DHIDesc=desc
	    s eobj15.DHIActiveFlag="Y"
	    s eobj15.DHISysFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCDisHistoryFeild).SaveData(eobj15)
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
	    //保存既往史关键字表
	    if (keys'="") {
			s upcode=$ZCONVERT(code,"U") //转换成大写
			s cid=$o(^DHCDISHISFi(0,"Code",upcode,0))
			s updesc=$ZCONVERT(desc,"U") //转换成大写
			s did=$o(^DHCDISHISFi(0,"Desc",updesc,0))
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

				    s eobjdk=##class(web.Entity.KB.DHCDisHistoryKey).%New()
				    s eobjdk.DHKDHDr=cid
				    s eobjdk.DHKKey=key
				    s eobjdk.DHKSysFlag="Y"
				    s str1 = ##class(web.DHCBL.KB.DHCDisHistoryKey).SaveData(eobjdk)
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

/// Function:保存商品名字典  成功result:^1^1^1^1
ClassMethod SaveProName(dataStr As %String) As %String
{
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)
	s desc=$p(dataStr,"[next]",4)
	s form=$p(dataStr,"[next]",5)
	s factory=$p(dataStr,"[next]",6)
	s gen=$p(dataStr,"[next]",7)
	s toxicity=$p(dataStr,"[next]",8)

	Ts
	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   
   		if (form'=""){  //判断剂型是否存在
		     s form=$ZCONVERT(form,"U") //转换成大写
		     s form=$o(^DHCPHEFi(0,"Desc",form,0))
		     if (form=""){
			     s result=result_"^"_0
		     }
	    }  
	    if (gen'=""){  //判断通用名是否存在
		     s gen=$ZCONVERT(gen,"U") //转换成大写
		     s gen=$o(^DHCPHEGENi(0,"Desc",gen,0))
		     if (gen=""){
			     s result=result_"^"_0
		     }
	    } 
	    
		if (factory'=""){  //判断厂家是否存在
		     s factory=$ZCONVERT(factory,"U") //转换成大写
		     s factory=$o(^DHCPHMANF(0,"Desc",factory,0))
		     if (factory=""){
			     s result=result_"^"_0
		     }
	    }  
	    if (toxicity'=""){  //判断毒性是否存在
		     s toxicity=$ZCONVERT(toxicity,"U") //转换成大写
		     s toxicity=$o(^DHCPHTOXi(0,"Desc",toxicity,0))
		     if (gen=""){
			     s result=result_"^"_0
		     }
	    } 
		//保存到商品名字典表	
	    s eobjpro=##class(web.Entity.KB.DHCPHProName).%New()
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s cid=$o(^DHCPHPNA(0,"Code",upcode,0))
		//判断是添加还是修改
		if (cid'="")
		{ 
			s eobjpro.PHNRowId=cid
		}
		/*s flag=##class(web.DHCBL.KB.DHCPHProName).FormValidate(cid,code,desc)  //调用重复验证
		if (flag=1)
		{
			s desc=desc_code
		}*/
	    s eobjpro.PHNCode=code
	    s eobjpro.PHNDesc=desc
	    s eobjpro.PHNFormDr=form
	    s eobjpro.PHNFactory=factory
	    s eobjpro.PHNActiveFlag="Y"
	    s eobjpro.PHNSysFlag="Y"
	    s eobjpro.PHNGenericDr=gen
	    s eobjpro.PHNToxicity=toxicity
	    s eobjpro.PHNManfDR=factory
	    s str1 = ##class(web.DHCBL.KB.DHCPHProName).SaveData(eobjpro,"")
	    if (str1["false"){           
			s result=result_"^"_0
	    }
		 
	    //保存到商品名对照表
	    if ((hiscode'="")&(hisdesc'="")) {  //如果HIS频率代码为空
		   s uphiscode=$$ALPHAUP^SSUTIL4(hiscode) //转换成大写
		   s hiscid=$o(^PHCD(0,"Code",uphiscode,0))
		   //s uphisdesc=$$ALPHAUP^SSUTIL4(hisdesc) //转换成大写
		   //s hisdid=$o(^PHCD(0,"Name",uphisdesc,0))
	   
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCPHPNA(0,"Code",upcode,0))
		   //s updesc=$ZCONVERT(desc,"U") //转换成大写
		  // s did=$o(^DHCPHPNA(0,"Desc",updesc,0))
	   	   //b ;hiscid,hisdid,cid,did
		    //判断填入的数据是否正确
		   if ((hiscid="")||(cid=""))
		   { 
				 s result=result_"^"_0
		    }
			else
			{				   	
				s ids=cid_"^"_hiscid
				s str2 = ##class(web.DHCBL.KB.DHCPHProContrast).SaveData(ids)
				if (str2["false")&(str2'["不能重复对照")
				{
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
	}
			
	q result
}

// 删除商品名数据

ClassMethod DeleteProName(dataStr As %String) As %String
{
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)
	s desc=$p(dataStr,"[next]",4)
	s form=$p(dataStr,"[next]",5)
	s factory=$p(dataStr,"[next]",6)
	Ts
	
	//判断必填项
	if ((code'="")&(hiscode'="")){
		s conid=$o(^DHCPHPCO(0,"Code",code,hiscode,0)) 
		if (conid'="")  
		{
	    	//删除商品名对照表
			s consc=##class(User.DHCPHProContrast).%DeleteId(conid)
			if $$$ISOK(consc){
				s result=result_"^"_1		
			}
			else{
				s result=result_"^"_0	
			}
		}
		else
		{
			s result=result_"^"_0	
		}
		s upcode=$ZCONVERT(code,"U") //转换成大写
		s cid=$o(^DHCPHPNA(0,"Code",upcode,0))
		if (cid'="")
		{
			//删除商品名表
			s sc=##class(User.DHCPHProName).%DeleteId(cid)
			if $$$ISOK(sc){
				s result=result_"^"_1		
			}
			else{
				s result=result_"^"_0	
			}
				
		}
		else
		{
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

/// Function:保存溶媒分类字典表  成功result:^1^1
ClassMethod SaveMenstruumCat(dataStr As %String) As %String
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
	    s eobj=##class(web.Entity.KB.DHCPHMenstruumCat).%New()
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s updesc=$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^DHCPHMCTi(0,"Code",upcode,0))
		s idd=$o(^DHCPHMCTi(0,"Desc",updesc,0))
		//判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj.PHMCRowId=idc
		 }
		
	    s eobj.PHMCCode=code
	    s eobj.PHMCDesc=desc
	    s eobj.PHMCActive=active
	    s str = ##class(web.DHCBL.KB.DHCPHMenstruumCat).SaveData(eobj)
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

/// Function:保存溶媒分类明细表  成功result:^1^1
ClassMethod SaveMenstruumItm(dataStr As %String) As %String
{
	s result=""
	s name=$p(dataStr,"[next]",1)
	s cat=$p(dataStr,"[next]",2)

	Ts
	
	//判断必填项
	if ((name="")||(cat="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1      
		//保存到字典表	
	    s eobj=##class(web.Entity.KB.DHCPHMenstruumItm).%New()
	    s upname=$ZCONVERT(name,"U") //转换成大写
		s upcat=$ZCONVERT(cat,"U") //转换成大写
		s nameid=$o(^DHCPHPNA(0,"Desc",upname,0))
		s catid=$o(^DHCPHMCTi(0,"Desc",upcat,0))
		if ((nameid="")||(catid=""))
		{ 
			s result=result_"^"_0
		}
		else
		{
		    s eobj.PHMIDrugDr=nameid
		    s eobj.PHMIMentDr=catid
		    s str = ##class(web.DHCBL.KB.DHCPHMenstruumItm).SaveData(eobj)
		    if (str["true"){   
			    s result=result_"^"_1
		    }
		    else{
			    if (str["该记录已经存在"){
				    s result=result_"^"_1
			    }else{    
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
	}
			
	q result
}

/// Function:保存药品规格字典表  成功result:^1^1
ClassMethod SaveExtSqec(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)
	s active=$p(dataStr,"[next]",3)
	s sys=$p(dataStr,"[next]",4)
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
	    s eobj=##class(web.Entity.KB.DHCPHExtSqec).%New()
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s updesc=$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^DHCPHESQE(0,"Code",upcode,0))
		s idd=$o(^DHCPHESQE(0,"Desc",updesc,0))
		//判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj.PHSRowId=idc
		 }
	    s eobj.PHSCode=code
	    s eobj.PHSDesc=desc
	    s:active="" active="Y"
	    s eobj.PHSActiveFlag=active
	    s:sys="" sys="Y"
	    s eobj.PHSSysFlag=sys
	    s str = ##class(web.DHCBL.KB.DHCPHExtSqec).SaveData(eobj)
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

/// Function:保存科室字典  成功result:^1^1^1^1
ClassMethod SaveHospLoc(dataStr As %String) As %String
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
		//保存到频率字典表	
	    s eobj2=##class(web.Entity.KB.DHCPHHospLoc).%New()
	    s eobj2.HOSPLCode=code
	    s eobj2.HOSPLDesc=desc
	    s eobj2.HOSPLActiveFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHHospLoc).SaveData(eobj2)
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
    
	    //保存到频率对照表
	    if ((hiscode'="")&(hisdesc'="")) {  //如果HIS频率代码为空
		   s uphiscode=$$ALPHAUP^SSUTIL4(hiscode) //转换成大写
		   s hiscid=$o(^CTLOC(0,"Code",uphiscode,0))
		   s uphisdesc=$$ALPHAUP^SSUTIL4(hisdesc) //转换成大写
		   s hisdid=$o(^CTLOC(0,"Desc",uphisdesc,0))
	   
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCPHHLOC(0,"Code",upcode,0))
		   s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCPHHLOC(0,"Desc",updesc,0))
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
				s str2 = ##class(web.DHCBL.KB.DHCPHHospLocCon).SaveData(ids)
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

/// Function:保存症状字典  成功result:^1^1^1^1
ClassMethod SaveSymptom(dataStr As %String) As %String
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
		//保存到频率字典表	
	    s eobj2=##class(web.Entity.KB.DHCPHSymptom).%New()
	    s eobj2.SYMCode=code
	    s eobj2.SYMDesc=desc
	    s eobj2.SYMActiveFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHSymptom).SaveData(eobj2)
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
    
	    //保存到频率对照表
	    if ((hiscode'="")&(hisdesc'="")) {  //如果HIS频率代码为空
		   s uphiscode=$ZCONVERT(hiscode,"U") //转换成大写
		   s hiscid=$o(^DHCSYMFEI(0,"Code",uphiscode,0))
		   s uphisdesc=$ZCONVERT(hisdesc,"U") //转换成大写
		   s hisdid=$o(^DHCSYMFEI(0,"Desc",uphisdesc,0))
	   
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCPHSYMP(0,"Code",upcode,0))
		   s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCPHSYMP(0,"Desc",updesc,0))
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
				s str2 = ##class(web.DHCBL.KB.DHCPHSymptomCon).SaveData(ids)
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

/// Function:保存证型字典  成功result:^1^1^1^1
ClassMethod SaveSyndrome(dataStr As %String) As %String
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
		//保存到频率字典表	
	    s eobj2=##class(web.Entity.KB.DHCPHSyndrome).%New()
	    s eobj2.DROCode=code
	    s eobj2.DRODesc=desc
	    s eobj2.DROActiveFlag="Y"
	    s str1 = ##class(web.DHCBL.KB.DHCPHSyndrome).SaveData(eobj2)
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
    
	    //保存到频率对照表
	    if ((hiscode'="")&(hisdesc'="")) {  //如果HIS频率代码为空
		   s uphiscode=$ZCONVERT(hiscode,"U") //转换成大写
		   s hiscid=$o(^MRC("DSYM",0,"Code",uphiscode,0))
		   s uphisdesc=$ZCONVERT(hisdesc,"U") //转换成大写
		   s hisdid=$o(^MRC("DSYM",0,"Desc",uphisdesc,0))
	   
		   s upcode=$ZCONVERT(code,"U") //转换成大写
		   s cid=$o(^DHCPHSYDRO(0,"Code",upcode,0))
		   s updesc=$ZCONVERT(desc,"U") //转换成大写
		   s did=$o(^DHCPHSYDRO(0,"Desc",updesc,0))
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
				s str2 = ##class(web.DHCBL.KB.DHCPHSynContrast).SaveData(ids)
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

/// Function:保存到通用名（药品） 成功result:^1^1^1^1^1^1^1
ClassMethod SaveGeneric(dataStr As %String) As %String
{
	s result=""
	s hiscode=$p(dataStr,"[next]",1)	
	s hisdesc=$p(dataStr,"[next]",2)
	s code=$p(dataStr,"[next]",3)	
	s desc=$p(dataStr,"[next]",4)
	s keys=$p(dataStr,"[next]",5)
	s form=$p(dataStr,"[next]",6)
	s lib=$p(dataStr,"[next]",7)
	s atc=$p(dataStr,"[next]",8)
	s type=$p(dataStr,"[next]",9)
	s ingr=$p(dataStr,"[next]",10)
	s leval=$p(dataStr,"[next]",11)
    /*if ($d(^DHCPHEGENi(0,"Desc",$ZCONVERT(desc,"U")))>0)
	{
		s desc=desc_code
	}*/
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

	    if (form'=""){
		     s form=$ZCONVERT(form,"U") //转换成大写
		     s form=$o(^DHCPHEFi(0,"Desc",form,0))
		     if (form=""){
			     s result=result_"^"_0
		     }
		     else{
			    s result=result_"^"_1 
		     }
	    }  

		if (ingr'=""){
		     s ingr=$ZCONVERT(ingr,"U")
		     s ingr=$o(^DHCPHEINGi(0,"Desc",ingr,0))
		     if (ingr=""){
			     s result=result_"^"_0
		     }
		     else{
			    s result=result_"^"_1 
		     }
	    }

	    if (leval'=""){
	     //主要成分标识（,一级,二级,三级） 
			s:leval="一级" leval="1"
			s:leval="二级" leval="2"
			s:leval="三级" leval="3"
			if ((leval'="1")&(leval'="2")&(leval'="3")){
				s result=result_"^"_0
			}else{
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
	    //b ;1
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
	   // s updesc=$ZCONVERT(desc,"U")  //转换成大写
		s idc=$o(^DHCPHEGENi(0,"Code",upcode,0))
		//s idd=$o(^DHCPHEGENi(0,"Desc",updesc,0))
		 //判断填入的通用名是否正确，正确则继续插入与通用名字典关联的表
	    if (idc="")
		{ 
			s result=result_"^"_0
		}
		else
		{
			s result=result_"^"_1
        	//保存到药品通用名和HIS对照表
		   	 if ((hiscode'="")&(hisdesc'="")) {  //如果HIS用法代码为空
			   s uphiscode=$$ALPHAUP^SSUTIL4(hiscode) //转换成大写
			   s hiscid=$o(^PHCGE("GE",0,"Code",uphiscode,0))
			   s uphisdesc=$$ALPHAUP^SSUTIL4(hisdesc) //转换成大写
			   s hisdid=$o(^PHCGE("GE",0,"Name",uphisdesc,0))	
		   	   //b ;hiscid,hisdid,idc,idd
			    //判断填入的数据是否正确
			   if (hisdid="")
			   { 
					 s result=result_"^"_0
			    }
				else
				{
					s result=result_"^"_1
				   	
					s ids=idc_"^"_hisdid
					s str2 = ##class(web.DHCBL.KB.DHCGenItmContrast).SaveData(ids)
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
	    	
	    	//保存到通用名与剂型关联表
	   		if (form'="") {	   	
				 	s eobjglp=##class(web.Entity.KB.DHCGenLinkPointer).%New()
				 	s eobjglp.GlPGenDr=idc
				 	s eobjglp.GlPPointer=form
				    s eobjglp.GlPActiveFlag="Y"
				    s eobjglp.GlPSysFlag="Y"
				    s str1 = ##class(web.DHCBL.KB.DHCGenLinkPointer).SaveData(eobjglp)
				    //b ;3
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
	    	
	    	//保存到通用名药品属性表
	   		if (type'="") {	   	
				 	s eobjdgp=##class(web.Entity.KB.DHCPHDrugGenPro).%New()
				 	s eobjdgp.PHGPRGenDr=idc
				 	s eobjdgp.PHGPRCatDr=type
				 	s eobjdgp.PHGPRAtc=atc
				 	s eobjdgp.PHGPROTC="Y"
				 	s eobjdgp.PHGPRSysFlag="Y"
	
				    s str1 = ##class(web.DHCBL.KB.DHCPHDrugGenPro).SaveData(eobjdgp)
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
	    	
	    	//保存到通用名成分明细表
	   		if ((ingr'="")&(leval'="")) {	   	
				 	s eobjgi=##class(web.Entity.KB.DHCPHExtGenIngr).%New()
				 	s eobjgi.PHEGIPHEGDr=idc
				 	s eobjgi.PHEGIIngrDr=ingr
				 	s eobjgi.PHEGILevel=leval
				 	s eobjgi.PHEGISysFlag="Y"
	
				    s str1 = ##class(web.DHCBL.KB.DHCPHExtGenIngr).SaveData(eobjgi)
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
/// Input:RowId-his的rowid，Code-his的code，Desc-his的Desc ,lib-知识库标识
/// return: wrongFlag -正确的时候是"", 错误返回1
/// w ##class(web.DHCBL.BDP.ImportKBData).TransDRUGGeneric()
ClassMethod TransDRUGGeneric(RowId As %String, Code As %String, Desc As %String, lib As %String) As %String
{
	new (RowId,Code,Desc,lib)
	q:((RowId="")||(Code="")||(Desc="")||(lib="")) ""
	s wrongFlag=""
	
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
	   //保存到药品通用名与his对照表
		s ids=idc_"^"_RowId
		s str2 = ##class(web.DHCBL.KB.DHCGenItmContrast).SaveData(ids)
	    if (str2["false")&(str2'["该记录已对照"){   
	    	b ;2
		    s wrongFlag=1
	    }
	    
	    q:wrongFlag=1 1
	    
    	//保存到通用名别名表
	    s eobjga=##class(web.Entity.KB.DHCPHExtGenAlias).%New()
	    s eobjga.PHEGAlGenDr=idc
	    s eobjga.PHEGAlText=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
	    s eobjga.PHEGAlLibDr=lib
	    s eobjga.PHEGAlSysFlag="Y"
	    s str3 = ##class(web.DHCBL.KB.DHCPHExtGenAlias).SaveData(eobjga)
	    if (str3["false")&(str3'["该记录已经存在"){    
		    s wrongFlag=1
	    }			   	
    }
    q wrongFlag
}

/// 把his药品的数据转移到知识库
/// Input:""
/// return: flag -正确的时候是"", 错误返回1
/// w ##class(web.DHCBL.BDP.ImportKBData).TransHisDrugToKB()
ClassMethod TransHisDrugToKB() As %String
{
	s flag=""
	s lib=$o(^DHCPHLIBL(0,"Code","DRUG",0))
	q:lib="" 1
	s RowId=0
	for   //User.PHCGeneric his药品处方通用名表
	{
		s RowId=$o(^PHCGE("GE",RowId)) q:(RowId="")||(flag=1)
		s Code=$p($g(^PHCGE("GE",RowId)),"^",1)
		s Desc = $p($g(^PHCGE("GE",RowId)),"^",2)
		s flag=..TransDRUGGeneric(RowId,Code,Desc,lib)	
	}	
			
	q flag
}

/// 根据描述获得检验项目id,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getLabId("ml")
ClassMethod getLabId(Lab As %String) As %String
{
	s LabDr=""
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
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			TC
			s LabDr=obj.%Id()
		}
		else
		{
			Trollback
			s LabDr=""
		}
		
	}
	q LabDr
}

/// 指标值范围值拆分  逻辑#最小值#最大值
/// w ##class(web.DHCBL.BDP.ImportKBData).getLABLimit("<4")
ClassMethod getLABLimit(limit As %String) As %String
{
	s result="",ralation="",min="",max=""
	s limit= ##class(web.BDP.util.String).Replace(limit,"!>","≤")
	s limit= ##class(web.BDP.util.String).Replace(limit,"!<","≥")
	s limit= ##class(web.BDP.util.String).Replace(limit,"＞",">")
	s limit= ##class(web.BDP.util.String).Replace(limit,"＜","<")
	s limit= ##class(web.BDP.util.String).Replace(limit,"<>","≠")
	s limit= ##class(web.BDP.util.String).Replace(limit,"＝","=")
	
	if (limit["-")
	{
		s ralation=""
		s min=$p(limit,"-",1)
		s max=$p(limit,"-",2)
		
	}
	elseif(limit[">")
	{
		s ralation=">"
		s min=$p(limit,">",2)
		s max=""
	}
	elseif(limit["<")
	{ 
		s ralation="<"
		s max=$p(limit,"<",2)
		s min=""
	}
	elseif(limit["≤")
	{
		s ralation="!>"
		s max=$p(limit,"≤",2)
		s min=""
	}
	elseif(limit["≥")
	{
		s ralation="!<"
		s min=$p(limit,"≥",2)
		s max=""
	}
	elseif(limit["≠")
	{
		s ralation="<>"
		s max=$p(limit,"≠",2)
		s min=""
	}
	elseif(limit["=")
	{
		s ralation="="
		s max=$p(limit,"=",2)
		s min=""
	}
	else
	{
		s ralation=""
		s max=limit
		s min=""
	}
	s result=ralation_"#"_min_"#"_max
	q result
}

/// Function:保存适应症 成功result:
ClassMethod SaveDiseaseInd(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("DiseaseInd",seq))
		q:seq=""
		s str=^tempKB("DiseaseInd",seq)
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
		s text=$p(dataStr,"[next]",8)
		s doctips=$p(dataStr,"[next]",9)	
		s note=$p(dataStr,"[next]",10)
		s key0=$p(dataStr,"[next]",11)
		s key1=$p(dataStr,"[next]",12)
		s Lab=$p(dataStr,"[next]",13)
		s LABLimit=$p(dataStr,"[next]",14)
		
		s LABIMinVal="",LABIMaxVal="",LABIRelation=""
		if (LABLimit'="")
		{
			s LABLimit=..getLABLimit(LABLimit)
			s LABIMinVal=$p(LABLimit,"#",2)
			s LABIMaxVal=$p(LABLimit,"#",3)
			s LABIRelation=$p(LABLimit,"#",1)
		}

		s LABIUom=$p(dataStr,"[next]",15)
		s organism=$p(dataStr,"[next]",16)
		s genus=$p(dataStr,"[next]",17)
		s drug=$p(dataStr,"[next]",18) //商品名
		
		/*//1判断必填项
		if (gen="")||(point="")||(text="")
		{   
		    q "false"
	    }*/
	    if ((gen=""||point="")&(drug=""))||(text="")
		{   
		    q "false"
	    }

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
			
	    /* //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 	   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"
		*/
		//适应症
		s eobj=##class(web.Entity.KB.DHCPHDrugDiseaseI).%New()

		//插入主索引表			
		//s eobj.PHINSTGenDr=gen
		//s eobj.PHINSTPointerDr=point		
		s eobj.PHINSTOrderNum=1
		//s eobj.PHINSTPointerType="Form"
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
			if (agelimit["岁")&(agelimit'["/")
			{
				s agelimit= ##class(web.BDP.util.String).Replace(agelimit,"岁","/年")
			}
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
		//检验项目
		if (Lab'="")
		{
			s LabDr=..getLabId(Lab)
			q:(LabDr="") "false"	
			s eobj.LABILabDr=LabDr 		
			
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
		s eobj.LABIRelation=LABIRelation
		
		//细菌			
		if (organism'="")
		{
			s organismdr=..getOrganismIds(organism)
			q:(organismdr="false") "false"
			s eobj.PHORGOrgDr=organismdr 	
		}
		//菌属					
		if (genus'="")
		{
			s genusdr=..getGenusIds(genus)
			q:(genusdr="false") "false"
			s eobj.PHGENGenusDr=genusdr 	
		}
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{ 
		    //通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
			
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"

			
			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"

			s str = ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).SaveIndData(eobj)
			if (str["false"){   
				q "false"
			}
		}
		//按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false" 

			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"

			s str = ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).SaveIndData(eobj)
			if (str["false"){  
				q "false"
			}			
	    
	    }
		s result = "true"
		s ^tempKB("DiseaseInd",row)=dataStr
				
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
		s seq=$o(^tempKB("DiseaseCon",seq))
		q:seq=""
		s str=^tempKB("DiseaseCon",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s mode=$p(dataStr,"[next]",1)	
		s gen=$p(dataStr,"[next]",2)
		s point=$p(dataStr,"[next]",3)
		s dis=$p(dataStr,"[next]",4)	
		s age=$p(dataStr,"[next]",5)
		s agelimit=$p(dataStr,"[next]",6)
		s history=$p(dataStr,"[next]",7)
		s ingr=$p(dataStr,"[next]",8)
		s phy=$p(dataStr,"[next]",9)
		s phylimit=$p(dataStr,"[next]",10)
		s sex=$p(dataStr,"[next]",11)
		s special=$p(dataStr,"[next]",12)
		s allergy=$p(dataStr,"[next]",13)
		s text=$p(dataStr,"[next]",14)
		s doctips=$p(dataStr,"[next]",15)	
		s note=$p(dataStr,"[next]",16)
		s type=$p(dataStr,"[next]",17)
		s Lab=$p(dataStr,"[next]",18)
		s LABLimit=$p(dataStr,"[next]",19)
		s LABIMinVal="",LABIMaxVal="",LABIRelation=""
		if (LABLimit'="")
		{
			s LABLimit=..getLABLimit(LABLimit)
			s LABIMinVal=$p(LABLimit,"#",2)
			s LABIMaxVal=$p(LABLimit,"#",3)
			s LABIRelation=$p(LABLimit,"#",1)
		}

		s LABIUom=$p(dataStr,"[next]",20)
		s key0=$p(dataStr,"[next]",21)
		s key1=$p(dataStr,"[next]",22)
		s drug=$p(dataStr,"[next]",23) //商品名
		//1判断必填项
		/*if (gen="")||(point="")||(text="")
		{   
		    q "false"
	    }*/
	    if ((gen=""||point="")&(drug=""))||(text="")
		{   
		    q "false"
	    }
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
		
	     /*//通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 	   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"
		*/

		
		//禁忌症
		s eobj=##class(web.Entity.KB.DHCPHDrugDiseaseC).%New()

		//插入主索引表			
		//s eobj.PHINSTGenDr=gen
		//s eobj.PHINSTPointerDr=point		
		s eobj.PHINSTOrderNum=1
		//s eobj.PHINSTPointerType="Form"
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
			if (agelimit["岁")&(agelimit'["/")
			{
				s agelimit= ##class(web.BDP.util.String).Replace(agelimit,"岁","/年")
			}
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
		//既往史
		if (history'="")
		{
			s historydr=..GetHistoryIds(history)
			q:(historydr="false") "false"
			s eobj.LDHDhDr=historydr
		}	

		//成分
		if (ingr'="") 
		{
			s ingr=..GetIngrId(ingr)
			q:(ingr="") "false"	
			s eobj.PHINIIngrDr=ingr						
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
			
		//过敏史
		if (allergy'="") 
		{
			s allergy=..GetAllergyId(allergy)
			q:(allergy="") "false"		
			s eobj.LALCAllergyDr=allergy						
		}
		//检验项目
		if (Lab'="")
		{
			s LabDr=..getLabId(Lab)
			q:(LabDr="") "false"	
			s eobj.LABILabDr=LabDr 		
			
		}
		//指标值范围
		s eobj.LABIMinVal=LABIMinVal 
		s eobj.LABIMaxVal=LABIMaxVal 
		s eobj.LABIRelation=LABIRelation
		if (LABIUom'="")
		{
			s LABIUomDr=..getUomId(LABIUom)
			q:LABIUomDr="false" "false"
			s eobj.LABIUomDr=LABIUomDr

		} 
		//特殊人群special
		s popu=""
		if (special'="")
		{				
			s popu=..getSpecialPopuIds(special)
			q:(popu="false") "false"	
			s eobj.SpecialPopu=popu
		}
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{ 
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
			
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"
		
			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
		
			s str = ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).SaveConData(eobj)
			if (str["false"){   
				q "false"
			}
		}
		//按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false" 

			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"

			s str = ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).SaveConData(eobj)
			if (str["false"){  
				q "false"
			}			
	    
	    }
	    
		s result = "true"
		s ^tempKB("DiseaseCon",row)=dataStr			
	}
	else
	{
		s result = "true"
	}	
	q result
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

/// 根据描述获得成分id,没有的话添加数据
/// w ##class(web.DHCBL.BDP.ImportKBData).GetIngrId("")
ClassMethod GetIngrId(ingr As %String) As %String
{
	s ingrDr=""
	//成分
	if (ingr'="")
	{
		s upingr=" "_$ZCONVERT(ingr,"U") //转换成大写
		if ($d(^User.DHCPHExtIngrI("DescIndex",upingr))>0)
		{
			s ingrDr=$o(^User.DHCPHExtIngrI("DescIndex",upingr,0))
		}  
		else
		{
			s obj=##class(User.DHCPHExtIngr).%New()
			s obj.PHEINGCode =ingr
			s obj.PHEINGDesc = ingr
			s obj.PHEINGActiveFlag = "Y"
			s obj.PHEINGSysFlag = "Y"
			TS
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				TC
				s ingrDr = obj.%Id()
			}
			else
			{
				Trollback
				s ingrDr=""
				
			}
		}

	}
	q ingrDr
}

/// 根据描述串获得既往史id的拼串,没有的话添加数据
/// w ##class(web.DHCBL.BDP.ImportKBData).GetHistoryIds("ml")
ClassMethod GetHistoryIds(history As %String) As %String
{
	s historyflag=""
	s historydr=""
	TS
	if (history'="")
	{
		s history=..ChangeSeparator(history)
		s argsLen=$Length(history,"#&")
		for i=1:1:argsLen
		{
			s arg=$p(history,"#&",i)
			s uparg=$ZCONVERT(arg,"U")
			if ($d(^DHCDISHISFi(0,"Desc",uparg))>0)
			{
				s did=$o(^DHCDISHISFi(0,"Desc",uparg,0))  
			}
			else
			{
				s obj=##class(User.DHCDisHistoryFeild).%New()
				s obj.DHICode = arg
				s obj.DHIDesc = arg
				s obj.DHIActiveFlag ="Y" 
				s obj.DHISysFlag ="Y"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s did=obj.%Id()
				}
				
			}
			if (did'="") 
			{
				s:(historydr'="") historydr=historydr_","_did
				s:(historydr="") historydr=did				
			}
			else
			{
				s historyflag="false"
			}
	
		}		

	}
	if (historyflag'="") 
	{
		Trollback
		s historydr="false"
	}
	else
	{
		TC
	}
	q historydr
}

/// Others:w ##class(web.DHCBL.BDP.ImportKBData).SaveDiseaseUse("警示[next]阿糖胞苷[next]注射用无菌粉末[next]皮下注射/静脉注射/静脉点滴/鞘内注射[next]成人[next]18-120/年[next]Y",1)
/// Function:保存到给药途径 成功result:"^1^1^1^1^1^1"
ClassMethod SaveDiseaseUse(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("DiseaseUse",seq))
		q:seq=""
		s str=^tempKB("DiseaseUse",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
	if (flag="")
 	{
		s Mode=$p(dataStr,"[next]",1) //控制级别
		s Gen=$p(dataStr,"[next]",2) //通用名
		s Pointer=$p(dataStr,"[next]",3) //剂型
		s UseStr=$p(dataStr,"[next]",4) //给药途径
		s Age=$p(dataStr,"[next]",5) //年龄
		s AgeStr=$p(dataStr,"[next]",6) //年龄限制
		s ExcludeFlag=$p(dataStr,"[next]",7) //禁用
		s AlertMsg=$p(dataStr,"[next]",8) //提示消息
		s MinVal = $p(AgeStr,"-",1)
		s MaxVal = $p($p(AgeStr,"-",2),"/",1)
		s Uom = $p(AgeStr,"/",2)
		s drug=$p(dataStr,"[next]",9) //商品名
						
		s Type="PREMET" //知识库目录
		s OrderNum=0 //顺序
		s PointerType="Form" //指针类型
		s Lib="DRUG" //知识库标识
		s ActiveFlag="Y" //是否可用
		s SysFlag="Y" //是否系统标识
		
		//控制级别
		if (Mode="警示"){s Mode="W"}
		elseif (Mode="管控"){s Mode="C"}
		elseif (Mode="统计"){s Mode="S"}
		else {s Mode="W"}
		
		//禁用
		if (ExcludeFlag="Y"){s ExcludeFlag="true"}
		else{s ExcludeFlag="false"}
		
		/*if ((Gen="")||(Pointer="")||(UseStr=""))
		{   
	    	q "false"
    	}*/
    	if ((Gen=""||Pointer="")&(drug=""))||(UseStr="")
		{   
		    q "false"
	    }

	    /* //通用名
		s GenDr=..getGenId(Gen)
		q:GenDr="" "false" 	   
		//剂型
		s PointerDr=..getPointId(Pointer)
		q:PointerDr="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(GenDr,PointerDr)
		q:(isLink'="true") "false"
		*/
		
		//年龄
		s AgeDr=""
		if (Age'="")
		{
			s AgeDr=..getAgeId(Age)
			q:(AgeDr="false") "false"	
		}
		//单位
		s UomDr=""
		if (Uom'="")
		{
			s UomDr=..getUomId(Uom)
			q:UomDr="false" "false"
		} 
		//按通用名+剂型维护数据
		if ((Gen'="")&(Pointer'=""))
		{ 
		    //通用名
			s gen=..getGenId(Gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(Pointer)
			q:point="" "false"
			
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"

			s userFlag=""
	    	s diseaseUse = ""
	    	s UseLen=$Length(UseStr,"#&")
			for i=1:1:UseLen		
			{
				if (diseaseUse'="") s diseaseUse = diseaseUse_"*"
				s Use=$p(UseStr,"#&",i)
				//用法
				s UseDr=..getInstrucId(Use)
					
				if (UseDr'=""){
		    		s diseaseUse =diseaseUse_UseDr_"^"_Mode_"^"_Type_"^"_OrderNum_"^"_gen_"^"_point_"^"_PointerType_"^"_Lib_"^"_ActiveFlag_"^"_SysFlag_"^"_ExcludeFlag_"^"_AgeDr_"^"_MinVal_"^"_MaxVal_"^"_UomDr_"^"_AlertMsg
	    		}
	    		else{
		   			s userFlag="false"
	    		}
			} 
			q:(userFlag'="") "false"
			s str1 = ##class(web.DHCBL.KB.DHCPHDiseaseUse).SaveData(diseaseUse)
			if (str1["false"){   
				q "false"
			}
				
		}
		//按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false" 
			
			s userFlag=""
	    	s diseaseUse = ""
	    	s UseLen=$Length(UseStr,"#&")
			for i=1:1:UseLen		
			{
				if (diseaseUse'="") s diseaseUse = diseaseUse_"*"
				s Use=$p(UseStr,"#&",i)
				//用法
				s UseDr=..getInstrucId(Use)
					
				if (UseDr'=""){
		    		s diseaseUse =diseaseUse_UseDr_"^"_Mode_"^"_Type_"^"_OrderNum_"^"_drug_"^"_"0"_"^"_"ProName"_"^"_Lib_"^"_ActiveFlag_"^"_SysFlag_"^"_ExcludeFlag_"^"_AgeDr_"^"_MinVal_"^"_MaxVal_"^"_UomDr_"^"_AlertMsg
	    		}
	    		else{
		   			s userFlag="false"
	    		}
			} 
			q:(userFlag'="") "false"
			s str1 = ##class(web.DHCBL.KB.DHCPHDiseaseUse).SaveData(diseaseUse)
			if (str1["false"){   
				q "false"
			}
	    }
			
		
		s result = "true"
		s ^tempKB("DiseaseUse",row)=dataStr
		
 	}
 	else
	{
		s result = "true"
	}	
	
	q result
}

/// 根据描述获得频率id,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getFreqId("ml")
ClassMethod getFreqId(freq As %String) As %String
{
	s freqid=""
	//用法
	if (freq'="")
	{
		s upfreq=$ZCONVERT(freq,"U")
		if ($d(^DHCPHEFRi(0,"Desc",upfreq))>0)
		{
			s freqid=$o(^DHCPHEFRi(0,"Desc",upfreq,0))
		}
		else
		{
			s obj=##class(User.DHCPHExtFreq).%New()
			s obj.PHEFCode = freq
			s obj.PHEFDesc = freq
			s obj.PHEFActiveFlag = "Y"
			s obj.PHEFSysFlag = "Y"
			TS
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				TC
				s freqid = obj.%Id()
			}
			else
			{
				Trollback
				s freqid ="false"
			}
		}

	}
	q freqid
}

/// Others:d ##class(web.DHCBL.BDP.ImportKBData).SaveDiseaseFreq("管控[next]头孢拉定胶囊[next]胶囊[next]每6小时一次[next]成人[next]18-120/年[next]Y",1)
/// Function:保存到给药频次 成功result:^1^1^1^1^1^1^1
ClassMethod SaveDiseaseFreq(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("DiseaseFreq",seq))
		q:seq=""
		s str=^tempKB("DiseaseFreq",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
	if (flag="")
 	{
		s Mode=$p(dataStr,"[next]",1) //控制级别
		s Gen=$p(dataStr,"[next]",2) //通用名
		s Pointer=$p(dataStr,"[next]",3) //剂型
		s FreqStr=$p(dataStr,"[next]",4) //给药途径
		s Age=$p(dataStr,"[next]",5) //年龄
		s AgeStr=$p(dataStr,"[next]",6) //年龄限制
		s ExcludeFlag=$p(dataStr,"[next]",7) //禁用
		s AlertMsg=$p(dataStr,"[next]",8) //提示消息
		s MinVal = $p(AgeStr,"-",1)
		s MaxVal = $p($p(AgeStr,"-",2),"/",1)
		s Uom = $p(AgeStr,"/",2)
		s drug=$p(dataStr,"[next]",9) //商品名
						
		s Type="FREQ" //知识库目录
		s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT(Type,"U"),0))
		s OrderNum=0 //顺序
		s PointerType="Form" //指针类型
		s Lib="DRUG" //知识库标识
		s ActiveFlag="Y" //是否可用
		s SysFlag="Y" //是否系统标识
		
		//控制级别
		if (Mode="警示"){s Mode="W"}
		elseif (Mode="管控"){s Mode="C"}
		elseif (Mode="统计"){s Mode="S"}
		else {s Mode=""}
		
		//禁用
		if (ExcludeFlag="Y"){s ExcludeFlag="true"}
		else{s ExcludeFlag="false"}
		
		if ((Gen=""||Pointer="")&(drug=""))||(FreqStr="")
		{   
		    q "false"
	    }
		/*if ((Gen="")||(Pointer="")||(FreqStr=""))
		{   
	    	q "false"
    	}
    	
    	//通用名
		s GenDr=..getGenId(Gen)
		q:GenDr="" "false" 	   
		//剂型
		s PointerDr=..getPointId(Pointer)
		q:PointerDr="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(GenDr,PointerDr)
		q:(isLink'="true") "false"
		*/
		
		//年龄
		s AgeDr=""
		if (Age'="")
		{
			s AgeDr=..getAgeId(Age)
			q:(AgeDr="false") "false"	
		}
		//单位
		s UomDr=""
		if (Uom'="")
		{
			s UomDr=..getUomId(Uom)
			q:UomDr="false" "false"
		} 
		//按通用名+剂型维护数据
		if ((Gen'="")&(Pointer'=""))
		{ 
		    //通用名
			s gen=..getGenId(Gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(Pointer)
			q:point="" "false"
			
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"

			s freqFlag=""	
	    	s diseaseFreq = ""
	    	s FreqLen=$Length(FreqStr,"#&")
			for i=1:1:FreqLen		
			{
				if (diseaseFreq'="") s diseaseFreq = diseaseFreq_"*"
				s Freq=$p(FreqStr,"#&",i)
				//频率
				s FreqDr=..getFreqId(Freq)
				if (FreqDr'=""){
		    		s diseaseFreq=diseaseFreq_FreqDr_"^"_Mode_"^"_Type_"^"_OrderNum_"^"_gen_"^"_point_"^"_PointerType_"^"_Lib_"^"_ActiveFlag_"^"_SysFlag_"^"_ExcludeFlag_"^"_AgeDr_"^"_MinVal_"^"_MaxVal_"^"_UomDr_"^"_AlertMsg
	    		}
	    		else{
		   			s freqFlag="false"
	    		}
			} 
			q:(freqFlag'="") "false"
			s str1 = ##class(web.DHCBL.KB.DHCPHDiseaseFreq).SaveData(diseaseFreq)
			if (str1["false"){   
				q "false"
			}
				
		}
		//按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false" 
			
			s freqFlag=""	
	    	s diseaseFreq = ""
	    	s FreqLen=$Length(FreqStr,"#&")
			for i=1:1:FreqLen		
			{
				if (diseaseFreq'="") s diseaseFreq = diseaseFreq_"*"
				s Freq=$p(FreqStr,"#&",i)
				//频率
				s FreqDr=..getFreqId(Freq)
				if (FreqDr'=""){
		    		s diseaseFreq=diseaseFreq_FreqDr_"^"_Mode_"^"_Type_"^"_OrderNum_"^"_drug_"^"_"0"_"^"_"ProName"_"^"_Lib_"^"_ActiveFlag_"^"_SysFlag_"^"_ExcludeFlag_"^"_AgeDr_"^"_MinVal_"^"_MaxVal_"^"_UomDr_"^"_AlertMsg
	    		}
	    		else{
		   			s freqFlag="false"
	    		}
			} 
			q:(freqFlag'="") "false"
			s str1 = ##class(web.DHCBL.KB.DHCPHDiseaseFreq).SaveData(diseaseFreq)
			if (str1["false"){   
				q "false"
			}
	    }
	    
	    
		

		s result = "true"
		s ^tempKB("DiseaseFreq",row)=dataStr
	    		
 	}
 	else
	{
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
		s lib=$o(^DHCPHLIBL(0,"Code","DRUG",0))
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

/// 根据描述获得剂型id,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getGenId("ml")
ClassMethod getPointId(point As %String) As %String
{
	s pointid=""
	//剂型
	s uppoint=$ZCONVERT(point,"U") //转换成大写
	if ($d(^DHCPHEFi(0,"Desc",uppoint))>0)
	{
		s pointid=$o(^DHCPHEFi(0,"Desc",uppoint,0))
	}
	else
	{
		s obj=##class(User.DHCPHExtForm).%New()
		s obj.PHEFCode = point
		s obj.PHEFDesc = point
		s obj.PHEFActiveFlag = "Y"
		s obj.PHEFSysFlag = "Y"
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			TC
			s pointid=obj.%Id()
		}
		else
		{
			Trollback
			s pointid=""
		}
	}
	q pointid
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

/// 根据描述获得菌属id的拼串,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getGenusIds("ml")
ClassMethod getGenusIds(genus As %String) As %String
{
	s result=""
	s genusflag=""
	s genusdr=""
	TS
	if (genus'="")
	{
		s genus=..ChangeSeparator(genus)
		s argsLen=$Length(genus,"#&")
		for i=1:1:argsLen
		{
			s did=""
			s arg=$p(genus,"#&",i)
			continue:arg=""
			s uparg=$ZCONVERT(arg,"U")
			if ($d(^DHCPHBTGEi(0,"Desc",uparg))>0)
			{
				s did=$o(^DHCPHBTGEi(0,"Desc",uparg,0))  
			}
			else
			{
				s obj=##class(User.DHCPHBtGenus).%New()
				s obj.BTGECode = arg
				s obj.BTGEDesc = arg
				s obj.BTGEActiveFlag ="Y" 
				s obj.BTGESysFlag ="Y"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s did=obj.%Id()
				}
				
			}
			if (did'="") 
			{
				s:(genusdr'="") genusdr=genusdr_","_did
				s:(genusdr="") genusdr=did				
			}
			else
			{
				s genusflag=genusflag_"^"_0
			}
	
		}			

	}
	if (genusflag'="")
	{
		Trollback
		s result="false"
	}
	else
	{
		TC
		s result= genusdr
	}
	q result
}

/// 根据描述获得细菌id的拼串,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getGenusIds("ml")
ClassMethod getOrganismIds(organism As %String) As %String
{
	s result=""
	s organismflag=""
	s organismdr=""
	TS
	if (organism'="")
	{
		s organism=..ChangeSeparator(organism)
		s argsLen=$Length(organism,"#&")
		for i=1:1:argsLen
		{
			s did=""
			s arg=$p(organism,"#&",i)
			continue:arg=""
			s uparg=$ZCONVERT(arg,"U")
			if ($d(^DHCPHBTORGi(0,"Desc",uparg))>0)
			{
				s did=$o(^DHCPHBTORGi(0,"Desc",uparg,0))  
			}
			else
			{
				s obj=##class(User.DHCPHBTOrganism).%New()
				s obj.BTOCode = arg
				s obj.BTODesc = arg
				s obj.BTOActiveFlag ="Y" 
				s obj.BTOSysFlag ="Y"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s did=obj.%Id()
				}
				
			}
			if (did'="") 
			{
				s:(organismdr'="") organismdr=organismdr_","_did
				s:(organismdr="") organismdr=did				
			}
			else
			{
				s organismflag=organismflag_"^"_0
			}
	
		}			

	}
	if (organismflag'="")
	{
		Trollback
		s result="false"
	}
	else
	{
		TC
		s result= organismdr
	}
	q result
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
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
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

/// 根据描述获得用法id的拼串,没有的话添加一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).getInstrucId("ml")
ClassMethod getInstrucId(Instruc As %String) As %String
{
	s Instrucid=""
	//用法
	if (Instruc'="")
	{
		s upInstruc=$ZCONVERT(Instruc,"U")
		if ($d(^DHCPHEINSTRi(0,"Desc",upInstruc))>0)
		{
			s Instrucid=$o(^DHCPHEINSTRi(0,"Desc",upInstruc,0))
		}
		else
		{
			s obj=##class(User.DHCPHExtInstruc).%New()
			s obj.PHEINCode = Instruc
			s obj.PHEINDesc = Instruc
			s obj.PHEINActiveFlag = "Y"
			s obj.PHEINSysFlag = "Y"
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s Instrucid = obj.%Id()
			}
			else
			{
				Trollback
				s Instrucid ="false"
			}
		}

	}
	q Instrucid
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
				s popuflag="false"
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
		Tc
	}
	q popu
}

/// Others:w ##class(web.DHCBL.BDP.ImportKBData).SaveUsageDosage("管控[next]头孢拉定胶囊[next]胶囊[next]成人[next]18-120/年[next][next][next][next]口服[next]2[next]4[next]0.25[next]0.5[next]g[next]1[next]4[next]g[next]2[next]g[next]4[next]g[next][next][next]成人常用量：一次0.25～0.5g，每6小时一次，感染较严重者一次可增至1g，但一日总量不超过4g[next][next][next][next][next][next][next][next][next][next][next][next][next][next][next][next]",1)
/// Function:保存用法用量 成功result:
ClassMethod SaveUsageDosage(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("UsageDosage",seq))
		q:seq=""
		s str=^tempKB("UsageDosage",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s Mode=$p(dataStr,"[next]",1)	
		s Gen=$p(dataStr,"[next]",2)
		s Point=$p(dataStr,"[next]",3)
		s Age=$p(dataStr,"[next]",4)
		s agelimit=$p(dataStr,"[next]",5)
		s Dis=$p(dataStr,"[next]",6)
		s Sex=$p(dataStr,"[next]",7)
		s Special=$p(dataStr,"[next]",8)
		s Instruc=$p(dataStr,"[next]",9)
		s DayTime=$p(dataStr,"[next]",10) //每日服药次数
		s DayTimeMin="",DayTimeMax=""
		if (DayTime'="")
		{
			if (DayTime["-")
			{
				s DayTimeMin=$p(DayTime,"-",1)
				s DayTimeMax=$p(DayTime,"-",2)
			}
			else
			{
				s DayTimeMax=DayTime
			}
		}
		s OnceQty=$p(dataStr,"[next]",11)
		s OnceQtyMin="",OnceQtyMax=""
		if (OnceQty'="")
		{
			if (OnceQty["-")
			{
				s OnceQtyMin=$p(OnceQty,"-",1)
				s OnceQtyMax=$p(OnceQty,"-",2)
			}
			else
			{
				s OnceQtyMax=OnceQty
			}
		}
		s OnceQtyUom=$p(dataStr,"[next]",12)
		s DayQty=$p(dataStr,"[next]",13)
		s DayQtyMin="",DayQtyMax=""
		if (DayQty'="")
		{
			if (DayQty["-")
			{
				s DayQtyMin=$p(DayQty,"-",1)
				s DayQtyMax=$p(DayQty,"-",2)
			}
			else
			{
				s DayQtyMax=DayQty
			}
		}

		s DayQtyUom=$p(dataStr,"[next]",14)
		s OnceMaxQty=$p(dataStr,"[next]",15)
		s OnceMaxQtyUom=$p(dataStr,"[next]",16)
		s DayMaxQty=$p(dataStr,"[next]",17)
		s DayMaxQtyUom=$p(dataStr,"[next]",18)
		s DocUseTips=$p(dataStr,"[next]",19)
		s NurseUseTips=$p(dataStr,"[next]",20)
		s Text=$p(dataStr,"[next]",21)
		s FristTimeQty=$p(dataStr,"[next]",22)
		s FristTimeQtyMin="",FristTimeQtyMax=""
		if (FristTimeQty'="")
		{
			if (FristTimeQty["-")
			{
				s FristTimeQtyMin=$p(FristTimeQty,"-",1)
				s FristTimeQtyMax=$p(FristTimeQty,"-",2)
			}
			else
			{
				s FristTimeQtyMax=FristTimeQty
			}
		}
		s FristTimeQtyUom=$p(dataStr,"[next]",23)
		s DurationQty=$p(dataStr,"[next]",24)
		s DurationQtyMin="",DurationQtyMax=""
		if (DurationQty'="")
		{
			if (DurationQty["-")
			{
				s DurationQtyMin=$p(DurationQty,"-",1)
				s DurationQtyMax=$p(DurationQty,"-",2)
			}
			else
			{
				s DurationQtyMax=DurationQty
			}
		}

		s DurationQtyUom=$p(dataStr,"[next]",25)
		s SpaceQty=$p(dataStr,"[next]",26)
		s SpaceQtyMin="",SpaceQtyMax=""
		if (SpaceQty'="")
		{
			if (SpaceQty["-")
			{
				s SpaceQtyMin=$p(SpaceQty,"-",1)
				s SpaceQtyMax=$p(SpaceQty,"-",2)
			}
			else
			{
				s SpaceQtyMax=SpaceQty
			}
		}
		s SpaceQtyUom=$p(dataStr,"[next]",27)
		s Weight=$p(dataStr,"[next]",28)
		s BodyArea=$p(dataStr,"[next]",29)
		s Lab=$p(dataStr,"[next]",30)
		s LABLimit=$p(dataStr,"[next]",31)
		s LABIMinVal="",LABIMaxVal="",LABIRelation=""
		if (LABLimit'="")
		{
			s LABLimit=..getLABLimit(LABLimit)
			s LABIRelation=$p(LABLimit,"#",1)
			s LABIMinVal=$p(LABLimit,"#",2)
			s LABIMaxVal=$p(LABLimit,"#",3)
		}

		s LABIUom=$p(dataStr,"[next]",32)
		s drug=$p(dataStr,"[next]",18) //商品名
		
		
	
		//控制级别
		s:Mode="警示" Mode="W"
		s:Mode="管控" Mode="C"
		s:Mode="统计" Mode="S"
		if ((Mode'="W")&(Mode'="C")&(Mode'="S")){
			s Mode="W"
		}
		
		//性别
		s:Sex="男" Sex="M"
		s:Sex="女" Sex="F"
		s:Sex="全部" Sex="A"
		s:Sex="" Sex="A"
		
		
	    //1判断必填项
	    if ((Gen=""||Point="")&(drug=""))||(Text="")
		{   
		    q "false"
	    }
	    /*
	    //1判断必填项
		if (Gen="")||(Point="")||(Text="")
		{   
		    q "false" 
	    }
	     //通用名
		s GenDr=..getGenId(Gen)
		q:GenDr="" "false" 	   
		//剂型
		s PointDr=..getPointId(Point)
		q:PointDr="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(GenDr,PointDr)
		q:(isLink'="true") "false"
		*/
		
		s eobj=##class(web.Entity.KB.DHCPHUsageDosage).%New()

		//插入主索引表			
		s eobj.PHUSDOOneDayTimeMin=DayTimeMin 
		s eobj.PHUSDOOneDayTimeMax=DayTimeMax 
		s eobj.PHUSDOOnceQtyMin=OnceQtyMin 
		s eobj.PHUSDOOnceQtyMax=OnceQtyMax 
		if (OnceQtyUom'="")
		{
			s OnceQtyUomDr=..getUomId(OnceQtyUom)
			q:OnceQtyUomDr="false" "false"
			s eobj.PHUSDOOnceQtyUomDr=OnceQtyUomDr	
		}
		s eobj.PHUSDOOneDayQtyMin=DayQtyMin 
		s eobj.PHUSDOOneDayQtyMax=DayQtyMax
		if (DayQtyUom'="")
		{
			s DayQtyUomDr=..getUomId(DayQtyUom)
			q:DayQtyUomDr="false" "false"
			s eobj.PHUSDOOneDayQtyUomDr=DayQtyUomDr
		} 
		s eobj.PHUSDOOnceMaxQty=OnceMaxQty 
		if (OnceMaxQtyUom'="")
		{
			s OnceMaxQtyUomDr=..getUomId(OnceMaxQtyUom) 
			q:OnceMaxQtyUomDr="false" "false"
			s eobj.PHUSDOOnceMaxQtyUomDr=OnceMaxQtyUomDr 
		}  
		s eobj.PHUSDOOneDayMaxQty=DayMaxQty 
		if (DayMaxQtyUom'="")
		{
			s DayMaxQtyUomDr=..getUomId(DayMaxQtyUom)
			q:DayMaxQtyUomDr="false" "false"
			s eobj.PHUSDOOneDayMaxQtyUomDr= DayMaxQtyUomDr
		}  
		s eobj.PHUSDOFristTimeQtyMin=FristTimeQtyMin 
		s eobj.PHUSDOFristTimeQtyMax=FristTimeQtyMax 
		if (FristTimeQtyUom'="")
		{
			s FristTimeQtyUomDr=..getUomId(FristTimeQtyUom) 
			q:FristTimeQtyUomDr="false" "false"
			s eobj.PHUSDOFristTimeQtyUomDr=FristTimeQtyUomDr

		}   
		s eobj.PHUSDODurationQtyMin=DurationQtyMin 
		s eobj.PHUSDODurationQtyMax=DurationQtyMax 
		if (DurationQtyUom'="")
		{
			s DurationQtyUomDr=..getUomId(DurationQtyUom)
			q:DurationQtyUomDr="false" "false"
			s eobj.PHUSDODurationQtyUomDr=DurationQtyUomDr
		}   
		s eobj.PHUSDOSpaceQtyMin=SpaceQtyMin 
		s eobj.PHUSDOSpaceQtyMax=SpaceQtyMax 
		if (SpaceQtyUom'="")
		{
			s SpaceQtyUomDr=..getUomId(SpaceQtyUom)
			q:SpaceQtyUomDr="false" "false"
			s eobj.PHUSDOSpaceQtyUomDr= SpaceQtyUomDr
		}   
		if (Weight'=""){
			s WeightMin=$p(Weight,"-",1)
			s WeightMax=$p(Weight,"-",2)
			s eobj.PHUSDOWeightMin=WeightMin 
			s eobj.PHUSDOWeightMax=WeightMax 
		}
		if (BodyArea'=""){
			s BodyAreaMin=$p(BodyArea,"-",1)
			s BodyAreaMax=$p(BodyArea,"-",2)
			s eobj.PHUSDOBodyAreaMin=BodyAreaMin 
			s eobj.PHUSDOBodyAreaMax=BodyAreaMax 	
		} 
		s eobj.PHINSTMode=Mode  
		s eobj.PHINSTSex=Sex 
		s eobj.PHINSTDocUseTips=DocUseTips 
		s eobj.PHINSTNurseUseTips=NurseUseTips 
		s eobj.PHINSTTypeDr="USAGE" 
		s eobj.PHINSTOrderNum=0 
		//s eobj.PHINSTGenDr=GenDr 
		//s eobj.PHINSTPointerDr=PointDr 
		//s eobj.PHINSTPointerType="Form" 
		s eobj.PHINSTLibDr="DRUG" 
		s eobj.PHINSTActiveFlag="Y" 
		s eobj.PHINSTSysFlag="Y" 
		s eobj.PHINSTText=Text 			
				
		//用法
		if (Instruc'="")
		{
			s Instruc=..getInstrucId(Instruc)
			q:Instruc="false" "false"
			s eobj.PHEINInstruc=Instruc	
		}

		//病症					
		if (Dis'="")
		{
			s disdr=..getDisIds(Dis)
			q:(disdr="false") "false"
			s eobj.PHDISLDisea=disdr 
			
			
		}
		//年龄
		if (Age'="")
		{
			s Age=..getAgeId(Age)
			q:(Age="false") "false"	
			s eobj.PDAAge=Age

		}
		//年龄限制
		if (agelimit'="")
		{
			if ((agelimit["岁")&(agelimit'["/"))
			{
				s agelimit= ##class(web.BDP.util.String).Replace(agelimit,"岁","/")
			}
			s agelimit=$tr(agelimit,"岁","年")
			s ageUom=$p(agelimit,"/",2)
			s ageValue=$p(agelimit,"/",1)
			if (ageValue["-")
			{
				s ageMin=$p(ageValue,"-",1)
				s ageMax=$p(ageValue,"-",2)
			}
			else
			{
				s ageMin=""
				s ageMax=ageValue
			}
				
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
		if (Special'="")
		{				
			s popu=..getSpecialPopuIds(Special)
			q:(popu="false") "false"
			s eobj.SpecialPopu=popu
			
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
		s eobj.LABIRelation=LABIRelation
		if (LABIUom'="")
		{
			s LABIUomDr=..getUomId(LABIUom)
			q:LABIUomDr="false" "false"
			s eobj.LABIUomDr=LABIUomDr

		}   
		//按通用名+剂型维护数据
		if ((Gen'="")&(Point'=""))
		{ 
		     //通用名
			s GenDr=..getGenId(Gen)
			q:GenDr="" "false" 	   
			//剂型
			s PointDr=..getPointId(Point)
			q:PointDr="" "false"
			
			//通用名和剂型关联表
			s isLink=..getLinkORNo(GenDr,PointDr)
			q:(isLink'="true") "false"

			
			s eobj.PHINSTGenDr=GenDr
			s eobj.PHINSTPointerDr=PointDr
			s eobj.PHINSTPointerType="Form"

			s str = ##class(web.DHCBL.KB.DHCPHUsageDosage).SaveData(eobj)
			if (str["false"){   
				q "false"
			}			

		}
		//按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false" 

			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"

			s str = ##class(web.DHCBL.KB.DHCPHUsageDosage).SaveData(eobj)
			if (str["false"){   
				q "false"
			}			
	    
	    }
	    
		s result = "true"
		s ^tempKB("UsageDosage",row)=dataStr					
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
			Ts
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
		s seq=$o(^tempKB("DisInteract",seq))
		q:seq=""
		s str=^tempKB("DisInteract",seq)
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
		s iflag=$p(dataStr,"[next]",7)
		s drug=$p(dataStr,"[next]",8) //商品名
		
		 if ((gen=""||point="")&(drug="")) q "false"
		/*//1判断必填项
		if ((gen="")||(point=""))
		{   
		    q "false"
	    }
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 	   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"
		*/

		//判断填入的相互作用通用名是否正确
		if (igen'="")
		{
			s igen=..getGenId(igen)
			q:igen="" "false"
		}
		
		
		//判断填入的相互作用分类是否正确
		if (itype'="")
		{
			s itype=..GetCatId(itype)
			q:itype="" "false"
		}

     	//管理模式（ ",Warn,Control,Stat"） 
		s:mode="警示" mode="W"
		s:mode="管控" mode="C"
		s:mode="统计" mode="S"
		if ((mode'="W")&(mode'="C")&(mode'="S")){
			s mode="W"
		} 
	    
     	//医嘱标识:1 组内 2组间 3全部
		s:iflag="组内" iflag="1"
		s:iflag="组间" iflag="2"
		s:iflag="全部" iflag="3"
		if ((iflag'="1")&(iflag'="2")&(iflag'="3")){
			s iflag="3"
		} 
	    

		//插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCPHDiseaseInteract).%New()
		//s eobj.PHINSTGenDr=gen
		//s eobj.PHINSTPointerDr=point
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		//s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"

		s eobj.PDINTGenDr=igen
		s eobj.PDINTCatDr=itype
		s eobj.PHINSTMode=mode
		s eobj.PDINTFlag=iflag

		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{ 
		    //通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
			
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"

			
			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			
			s str = ##class(web.DHCBL.KB.DHCPHDiseaseInteract).SaveData(eobj)
			if (str["false"){   
				q "false"
			}
		}
		//按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false" 

			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"

			s str = ##class(web.DHCBL.KB.DHCPHDiseaseInteract).SaveData(eobj)
			if (str["false"){   
				q "false"
			}

	    }
	    
		
		s result = "true"
		s ^tempKB("DisInteract",row)=dataStr			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存配伍禁忌 成功result:
ClassMethod SaveDrugContrain(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("DrugContrain",seq))
		q:seq=""
		s str=^tempKB("DrugContrain",seq)
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
		s iflag=$p(dataStr,"[next]",7)
		s drug=$p(dataStr,"[next]",8) //商品名
		//1判断必填项
		/*if ((gen="")||(point=""))
		{   
		    q "false"
	    }*/
	    if ((gen=""||point="")&(drug="")) q "false"
	    //插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCPHDiseaseInteract).%New()
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		if (mode'="")
		{
			//管理模式（ ",Warn,Control,Stat"） 
			s:mode="警示" mode="W"
			s:mode="管控" mode="C"
			s:mode="统计" mode="S"
			if ((mode'="W")&(mode'="C")&(mode'="S")){
				s mode="W"
			} 
			s eobj.PHINSTMode=mode	
		}
	    if (iflag'="")
	    {
	     	//医嘱标识:1 组内 2组间 3全部
			s:iflag="组内" iflag="1"
			s:iflag="组间" iflag="2"
			s:iflag="全部" iflag="3"
			if ((iflag'="1")&(iflag'="2")&(iflag'="3")){
				s iflag="3"
			} 
			s eobj.PDINTFlag=iflag
	    }
		//判断填入的相互作用分类是否正确
		if (itype'="")
		{
			s itype=..GetCatId(itype)
			q:itype="" "false"
		}
		
		//判断填入的相互作用通用名是否正确
		if (igen'="")
		{
			s igen=..getGenId(igen)
			q:igen="" "false"
		}
		s eobj.PDINTGenDr=igen
		s eobj.PDINTCatDr=itype
		
		
			
	    //按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{ 
		    //通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
			
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"

			
			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			
			

			s str = ##class(web.DHCBL.KB.DHCPHDrugContrain).SaveData(eobj)
			if (str["false"){   
				q "false"
			}
		}
		//按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false" 

			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"

			s str = ##class(web.DHCBL.KB.DHCPHDrugContrain).SaveData(eobj)
			if (str["false"){  
				q "false"
			}			
	    
	    }

		s result = "true"
		s ^tempKB("DrugContrain",row)=dataStr			
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
		s seq=$o(^tempKB("PHDAR",seq))
		q:seq=""
		s str=^tempKB("PHDAR",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s gen=$p(dataStr,"[next]",1)	
		s point=$p(dataStr,"[next]",2)
		s text=$p(dataStr,"[next]",3)	
		s drug=$p(dataStr,"[next]",4) //商品名
		//1判断必填项
		/*if ((gen="")||(point="")||(text=""))
		{   
		   q "false"
	    }
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 	   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"*/
		if ((gen=""||point="")&(drug=""))||(text="") q "false"

		//插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCPHDAR).%New()
		//s eobj.PHINSTGenDr=gen
		//s eobj.PHINSTPointerDr=point
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		//s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PDAIOrdNum=row
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{ 
		    //通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
			
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"

			
			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			
			s str = ##class(web.DHCBL.KB.DHCPHDAR).SaveData(eobj)
			if (str["false"){   
				q "false"
			}
		}
		//按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false" 

			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"

			s str = ##class(web.DHCBL.KB.DHCPHDAR).SaveData(eobj)
			if (str["false"){   
				q "false"
			}

	    }
		
		   
		s result = "true"
		s ^tempKB("PHDAR",row)=dataStr
		
			
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
		s seq=$o(^tempKB("PHDMHA",seq))
		q:seq=""
		s str=^tempKB("PHDMHA",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s gen=$p(dataStr,"[next]",1)	
		s point=$p(dataStr,"[next]",2)
		s text=$p(dataStr,"[next]",3)
		s drug=$p(dataStr,"[next]",4) //商品名
		
		if ((gen=""||point="")&(drug=""))||(text="") q "false"
	
		/*//1判断必填项
		if ((gen="")||(point="")||(text=""))
		{   
		   q "false"
	    }
	    //通用名
		s gen=..getGenId(gen)
		q:gen="" "false" 	   
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"
		*/
		
		//插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCPHDMHA).%New()
		//s eobj.PHINSTGenDr=gen
		//s eobj.PHINSTPointerDr=point
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		//s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PDAIOrdNum=row
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{ 
		    //通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
			
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"

			
			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			
			s str = ##class(web.DHCBL.KB.DHCPHDMHA).SaveData(eobj)
			if (str["false"){   
				q "false"
			}
		}
		//按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false" 

			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"

			s str = ##class(web.DHCBL.KB.DHCPHDMHA).SaveData(eobj)
			if (str["false"){   
				q "false"
			}

	    }
		
										
		s result = "true"
		s ^tempKB("PHDMHA",row)=dataStr
		
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:根据描述获取溶媒分类的ID，若没有则生成一条溶媒分类
/// w ##class(web.DHCBL.BDP.ImportKBData).GetMenstruumCat()
ClassMethod GetMenstruumCat(cat As %String) As %String
{
	s catid=""
	if (cat'="")
	{
		s upcat=$ZCONVERT(cat,"U")
		if ($d(^DHCPHMCTi(0,"Desc",upcat))>0) 
		{	
			s catid=$o(^DHCPHMCTi(0,"Desc",upcat,0))
						
		}
		else
		{
			s obj=##class(User.DHCPHMenstruumCat).%New()
			s obj.PHMCCode = cat
			s obj.PHMCDesc = cat
			s obj.PHMCActive = "Y"
			TS
			s sc=obj.%Save()
			d obj.%Close() 
			If $$$ISOK(sc)
			{
				Tc
				s catid=obj.%Id()
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

/// Function:根据描述获取商品名的ID，若没有则生成一条数据
/// w ##class(web.DHCBL.BDP.ImportKBData).GetProNameId("商品名三")
ClassMethod GetProNameId(drug As %String) As %String
{
	s drugid=""
    //按商品名维护数据
	if (drug'="")
	{   
	    s updrug=$ZCONVERT(drug,"U")  //转换成大写 		
		 //判断填入的商品名是否正确
	    if ($d(^DHCPHPNA(0,"Desc",updrug))>0)
		{ 	
			s drugid=$o(^DHCPHPNA(0,"Desc",updrug,0))	
		}
		else
		{
			s obj=##class(User.DHCPHProName).%New()
			s obj.PHNCode = drug
			s obj.PHNDesc = drug
			s obj.PHNActiveFlag = "Y"
			s obj.PHNSysFlag = "Y"
			TS
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				TC
				s drugid = obj.%Id()
			}
			else
			{
				Trollback
				s drugid =""
			}

				
		}
    
    }
    q drugid
}

/// Function:保存溶媒量 成功result:
/// w ##class(web.DHCBL.BDP.ImportKBData).SaveMenstruumQty("注射用血栓通[next]注射剂[next]注射用血栓通(三七总甙)[250mg冻干粉]"_$c(10,10,10)_"[next]5%葡萄糖注射液[next]250[next]500[next]ml[next]本品用5%或10%葡萄糖注射液或氯化钠注射液250~500ml稀释。[next]",69)
ClassMethod SaveMenstruumQty(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("MenstruumQty",seq))
		q:seq=""
		s str=^tempKB("MenstruumQty",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{		
		s gen=$p(dataStr,"[next]",1)
		s point=$p(dataStr,"[next]",2)
		s drug=$p(dataStr,"[next]",3) //商品名
		s cat=$p(dataStr,"[next]",4)  //溶媒分类	
		s min=$p(dataStr,"[next]",5)
		s max=$p(dataStr,"[next]",6)
		s uom=$p(dataStr,"[next]",7)
		s text=$p(dataStr,"[next]",8)
		s mode=$p(dataStr,"[next]",9)
	
		if (gen=""||drug="") q "false"

		s eobj=##class(web.Entity.KB.DHCPHMenstruumQty).%New()

		//插入主索引表			
		
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
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
			s eobj.PHINSTMode=mode
	    }
		//溶媒分类
		if (cat'="")
		{
			s catid=..GetMenstruumCat(cat)
			q:catid="" "false"
			s eobj.PHMQCatDr=catid
	
		}
		//年龄限制
		if (uom'="")
		{
			s uomid=..getUomId(uom)
			q:uomid="false" "false"
			s eobj.PHMQCatQtyUomDr=uomid									
				
		}
		s eobj.PHMQCatQtyMin=min
		s eobj.PHMQCatQtyMax=max
		
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{   

			//通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
	
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"

			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			
			s str = ##class(web.DHCBL.KB.DHCPHMenstruumQty).SaveData(eobj)
			if (str["false"){   
				q "false"
			}		
	    
	    }
	    //按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false" 

			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"

			s str = ##class(web.DHCBL.KB.DHCPHMenstruumQty).SaveData(eobj)
			if (str["false"){  
				q "false"
			}			
	    
	    }

		s result = "true"
		s ^tempKB("MenstruumQty",row)=dataStr										
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存浓度 成功result:
ClassMethod SaveDrgSolvent(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("DrgSolvent",seq))
		q:seq=""
		s str=^tempKB("DrgSolvent",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{		
		s gen=$p(dataStr,"[next]",1)
		s point=$p(dataStr,"[next]",2)
		s drug=$p(dataStr,"[next]",3) //商品名
		s mode=$p(dataStr,"[next]",4) 
		s drg=$p(dataStr,"[next]",5)  //关联溶媒药品	
		s relation=$p(dataStr,"[next]",6)
		s dosage=$p(dataStr,"[next]",7)
		s uom=$p(dataStr,"[next]",8)
		s text=$p(dataStr,"[next]",9)
		s DosageMin=$p(dataStr,"[next]",10)
		s DosageMax=$p(dataStr,"[next]",11)
	
		s eobj=##class(web.Entity.KB.DHCPHDrgSolvent).%New()

		//插入主索引表					
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		
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
			s eobj.PHINSTMode=mode
	    }
	    //逻辑
	   if (relation'="")
		{ 
			s:relation="大于" relation=">"
			s:relation="小于" relation="<"
			s:relation="等于" relation="="
			s:relation="不大于" relation="!>"
			s:relation="不小于" relation="!<"
			s:relation="不等于" relation="<>"
			if ((relation'=">")&(relation'="<")&(relation'="=")&(relation'="!>")&(relation'="!<")&(relation'="<>")){
				s relation=""
			} 
			s eobj.PDINTRelation=relation
	    }
		//关联溶媒药品
		if (drg'="")
		{
			s drg=..GetProNameId(drg)
			q:drg="" "false" 	
			s eobj.PDINTDrgDr=drg						
		}
		//单位
		if (uom'="")
		{
			s uom=..getUomId(uom)
			q:uom="false" "false"
			s eobj.PDINTMustUomDr=uom									
		}
		
		s eobj.PDINTDosage=dosage  //单支溶媒量
		s eobj.PDINTDosageMax=DosageMax
		s eobj.PDINTDosageMin=DosageMin
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{ 
			//通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
	
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"
			  
			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			s str = ##class(web.DHCBL.KB.DHCPHDrgSolvent).SaveData(eobj)
			if (str["false"){   
				q "false"
			}			
	    
	    }
	    //按商品名维护数据
		if (drug'="")
		{ 
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false"   
			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"
			s str = ##class(web.DHCBL.KB.DHCPHDrgSolvent).SaveData(eobj)
			if (str["false"){   
				q "false"
			}		
	    
	    }

		s result = "true"
		s ^tempKB("DrgSolvent",row)=dataStr							
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:根据描述获取商品名的ID串，若没有则生成数据
/// w ##class(web.DHCBL.BDP.ImportKBData).GetProIds("商品名三/商品名四")
ClassMethod GetProIds(drgs As %String) As %String
{
	//可配伍药品（商品名多选用/分开）
	s result=""
	s drugflag =""
	s drgdr=""
	TS
	if (drgs'="")
	{			
		s argsLen=$Length(drgs,"#&")
		for i=1:1:argsLen
		{
			s arg=$p(drgs,"#&",i)
			s uparg=$ZCONVERT(arg,"U")
			
			if ($d(^DHCPHPNA(0,"Desc",uparg))>0) 
			{
				s did=$o(^DHCPHPNA(0,"Desc",uparg,0))  
			}
			else
			{
				s obj=##class(User.DHCPHProName).%New()
				s obj.PHNCode = arg
				s obj.PHNDesc = arg
				s obj.PHNActiveFlag = "Y"
				s obj.PHNSysFlag = "Y"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s did= obj.%Id()
				}
				else
				{
					s drugflag ="false"
				}
				
			}
			if (did'="") 
			{
				s:(drgdr'="") drgdr=drgdr_","_did
				s:(drgdr="") drgdr=did				
			}
	
		}

    }
    if (drugflag'="")
	{
		Trollback
		s result="false"
	}
	else
	{
		Tc
		s result= drgdr
	}
	q result
}

/// Function:保存可配伍药品 
ClassMethod SaveDrgAlone(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("DrgAlone",seq))
		q:seq=""
		s str=^tempKB("DrgAlone",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{		
		s gen=$p(dataStr,"[next]",1)
		s point=$p(dataStr,"[next]",2)
		s drug=$p(dataStr,"[next]",3) //商品名
		s grpNo=$p(dataStr,"[next]",4) 
		s drgs=$p(dataStr,"[next]",5)  //关联溶媒药品	
		s cat=$p(dataStr,"[next]",6)
		s text=$p(dataStr,"[next]",7)
		s mode=$p(dataStr,"[next]",8)
	
		s eobj=##class(web.Entity.KB.DHCPHDrgAlone).%New()

		//插入主索引表						
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text

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
			s eobj.PHINSTMode=mode
	    }
		//溶媒分类
		if (cat'="")
		{
			s catid=..GetMenstruumCat(cat)
			q:catid="" "false"
			s eobj.PHDALCatDr=catid
	
		}
		//可配伍药品（商品名多选用/分开）
		s drgdr=""
		if (drgs'="")
		{
			s drgdr=..GetProIds(drgs)
			q:(drgdr="false") "false"
			s eobj.PHDALDrgDr=drgdr 
	    }
	   
		s eobj.PHDALGrpNo=grpNo
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{  
			//通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
	
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"
			 

			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			s eobj.PHDALDrgDr=drgdr
			s str = ##class(web.DHCBL.KB.DHCPHDrgAlone).SaveData(eobj)

			if (str["false"){   
				q "false"
			}

					
		}
	    
	    
	    //按商品名维护数据
		if (drug'="")
		{   
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false"   
			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"
			s eobj.PHDALDrgDr=drgdr  //奇怪，这里要是不加这句，多选的就保存不了
	
			s str = ##class(web.DHCBL.KB.DHCPHDrgAlone).SaveData(eobj)
			if (str["false"){   
				q "false"
			}
	    }

		s result = "true"
		s ^tempKB("DrgAlone",row)=dataStr							

			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存成分含量（g）成功result:
ClassMethod SaveEleCon(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("EleCon",seq))
		q:seq=""
		s str=^tempKB("EleCon",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{		
		s gen=$p(dataStr,"[next]",1)
		s point=$p(dataStr,"[next]",2)
		s drug=$p(dataStr,"[next]",3) //商品名
		s ingr=$p(dataStr,"[next]",4)  //单支药品成分
		s ingrQty=$p(dataStr,"[next]",5) 	
		s uom=$p(dataStr,"[next]",6)  //单位
		s relation=$p(dataStr,"[next]",7)
		s totalQty=$p(dataStr,"[next]",8)
		s text=$p(dataStr,"[next]",9)
	
		s eobj=##class(web.Entity.KB.DHCPHEleCon).%New()

		//插入主索引表					
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		
	    //逻辑
	   if (relation'="")
		{ 
			s:relation="大于" relation=">"
			s:relation="小于" relation="<"
			s:relation="等于" relation="="
			s:relation="不大于" relation="!>"
			s:relation="不小于" relation="!<"
			s:relation="不等于" relation="<>"
			if ((relation'=">")&(relation'="<")&(relation'="=")&(relation'="!>")&(relation'="!<")&(relation'="<>")){
				s relation=""
			} 
			s eobj.PHECRelation=relation
	    }
		//关联溶媒药品
		if (ingr'="")
		{
			s ingr=..GetIngrId(ingr)
			q:(ingr="") "false"	
			s eobj.PHECPHExtIngr=ingr		
	
		}
		//单位
		if (uom'="")
		{
			s uom=..getUomId(uom)
			q:uom="false" "false"
			s eobj.PHECUomDr=uom					
		}
		
		s eobj.PHECIngrQty=ingrQty  //单支成分含量
		s eobj.PHECTotalQty=totalQty  //整组液体量（ml）
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{   
			//通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
	
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"
			
			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			s str = ##class(web.DHCBL.KB.DHCPHEleCon).SaveData(eobj)
			if (str["false"){   
				q "false"
			}
	    
	    }
	    //按商品名维护数据
		if (drug'="")
		{   
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false"  
			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"
			s str = ##class(web.DHCBL.KB.DHCPHEleCon).SaveData(eobj)
			if (str["false"){   
				q "false"
			}		
	    
	    }

		s result = "true"
		s ^tempKB("EleCon",row)=dataStr										
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存联合用药 成功result:
ClassMethod SaveMustDrug(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("MustDrug",seq))
		q:seq=""
		s str=^tempKB("MustDrug",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{		
		s gen=$p(dataStr,"[next]",1)
		s point=$p(dataStr,"[next]",2)
		s drug=$p(dataStr,"[next]",3) //商品名
		s assDrug=$p(dataStr,"[next]",4) //关联液体
		s mustDrug=$p(dataStr,"[next]",5)  //必用药品	
		s relation=$p(dataStr,"[next]",6)
		s dosage=$p(dataStr,"[next]",7)
		s uom=$p(dataStr,"[next]",8)
		s text=$p(dataStr,"[next]",9)
	
		s eobj=##class(web.Entity.KB.DHCPHMustDrug).%New()

		//插入主索引表					
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		
	    //逻辑
	   if (relation'="")
		{ 
			s:relation="大于" relation=">"
			s:relation="小于" relation="<"
			s:relation="等于" relation="="
			s:relation="不大于" relation="!>"
			s:relation="不小于" relation="!<"
			s:relation="不等于" relation="<>"
			if ((relation'=">")&(relation'="<")&(relation'="=")&(relation'="!>")&(relation'="!<")&(relation'="<>")){
				s relation=""
			} 
			s eobj.PHMDRelation=relation
	    }
		//关联液体
		if (assDrug'="")
		{
			//商品名
			s assDrug=..GetProNameId(assDrug)
			q:assDrug="" "false"  
			s eobj.PHMDAssDrugDr=assDrug						
	
		}
		//必用药品
		if (mustDrug'="")
		{
			//商品名
			s mustDrug=..GetProNameId(mustDrug)
			q:mustDrug="" "false"  	
			s eobj.PHMDMustDrugDr=mustDrug				
		}
		//单位
		if (uom'="")
		{
			s uom=..getUomId(uom)
			q:uom="false" "false"
			s eobj.PHMDMustUomDr=uom									
		}
		
		s eobj.PHMDMustQty=dosage  //必用药品剂量
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{   
			//通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
	
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"
			
			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			s str = ##class(web.DHCBL.KB.DHCPHMustDrug).SaveData(eobj)
			if (str["false")
			{   
				q "false"
			}		
	    
	    }
	    //按商品名维护数据
		if (drug'="")
		{   
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false"  
			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"
			s str = ##class(web.DHCBL.KB.DHCPHMustDrug).SaveData(eobj)
			if (str["false")
			{   
				q "false"
			}
	    
	    }

		s result = "true"
		s ^tempKB("MustDrug",row)=dataStr							
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存辅助用药个数 成功result:
ClassMethod SaveAssDrugNum(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("AssDrugNum",seq))
		q:seq=""
		s str=^tempKB("AssDrugNum",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{		
		s gen=$p(dataStr,"[next]",1)
		s point=$p(dataStr,"[next]",2)
		s drug=$p(dataStr,"[next]",3) //商品名
		s num=$p(dataStr,"[next]",4)
		s text=$p(dataStr,"[next]",5)
	
		s eobj=##class(web.Entity.KB.DHCPHAssDrugNum).%New()

		//插入主索引表					
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text
		

		s eobj.PHADNum=num  //辅助用药个数
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{   
			//通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
	
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"
			
			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			s str = ##class(web.DHCBL.KB.DHCPHAssDrugNum).SaveData(eobj)
			if (str["false")
			{   
				q "false"
			}				
	    
	    }
	    //按商品名维护数据
		if (drug'="")
		{   
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false"  
			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"
			s str = ##class(web.DHCBL.KB.DHCPHAssDrugNum).SaveData(eobj)
			if (str["false")
			{   
				q "false"
			}
	    }

		s result = "true"
		s ^tempKB("AssDrugNum",row)=dataStr							
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存重复用药规则  成功result:^1^1
ClassMethod SaveRepeatFeild(dataStr As %String) As %String
{
	s result=""
	s code=$p(dataStr,"[next]",1)
	s desc=$p(dataStr,"[next]",2)
	s active=$p(dataStr,"[next]",3)
	s active=$ZCONVERT(active,"U") 
	s:active="" active="Y"

	Ts	
	//判断必填项
	if ((code="")||(desc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1      
		//保存到字典表	
	    s eobj=##class(web.Entity.KB.DHCPHRepeatFeild).%New()
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s updesc=$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^DHCPHRFEi(0,"Code",upcode,0))
		s idd=$o(^DHCPHRFEi(0,"Desc",updesc,0))
		//判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj.PHRFRowId=idc
		 }
		
	    s eobj.PHRFCode=code
	    s eobj.PHRFDesc=desc
	    s eobj.PHRFActiveFlag=active
	    s str = ##class(web.DHCBL.KB.DHCPHRepeatFeild).SaveData(eobj)
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

/// Function:根据描述获取重复用药规则的ID，若没有则生成一条重复用药规则
/// w ##class(web.DHCBL.BDP.ImportKBData).GetRepeatId()
ClassMethod GetRepeatId(rule As %String) As %String
{
	s ruleid=""
	if (rule'="")
	{
		s uprule=$ZCONVERT(rule,"U")
		if ($d(^DHCPHRFEi(0,"Desc",uprule))>0) 
		{	
			s ruleid=$o(^DHCPHRFEi(0,"Desc",uprule,0))
						
		}
		else
		{
			s obj=##class(User.DHCPHRepeatFeild).%New()
			s obj.PHRFCode = rule
			s obj.PHRFDesc = rule
			s obj.PHRFActiveFlag = "Y"
			TS
			s sc=obj.%Save()
			d obj.%Close() 
			If $$$ISOK(sc)
			{
				Tc
				s ruleid=obj.%Id()
			}
			else
			{
				Trollback
				s ruleid=""
			}
		}

	}
	q ruleid
}

/// Function:根据描述获取通用名的ID串，若没有则生成数据
/// w ##class(web.DHCBL.BDP.ImportKBData).GetGenIds("商品名三/商品名四")
ClassMethod GetGenIds(drgs As %String) As %String
{
	//可配伍药品（商品名多选用/分开）
	s result=""
	s drugflag =""
	s drgdr=""
	TS
	if (drgs'="")
	{			
		s argsLen=$Length(drgs,"#&")
		for i=1:1:argsLen
		{
			s arg=$p(drgs,"#&",i)
			s uparg=$ZCONVERT(arg,"U")
			s did=""	
			if ($d(^DHCPHEGENi(0,"Desc",uparg))>0)
			{
				s did=$o(^DHCPHEGENi(0,"Desc",uparg,0))
			}
			else
			{
				s obj=##class(User.DHCPHExtGeneric).%New()
				s obj.PHEGCode = arg
				s obj.PHEGDesc = arg
				s lib=$o(^DHCPHLIBL(0,"Code","DRUG",0))
				d:lib'="" obj.PHEGLibDrSetObjectId(lib)
				s obj.PHEGActiveFlag = "Y"
				s obj.PHEGSysFlag = "Y"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					s did= obj.%Id()
				}
				else
				{
					s drugflag ="false"
				}
				
			}
			if (did'="") 
			{
				s:(drgdr'="") drgdr=drgdr_","_did
				s:(drgdr="") drgdr=did				
			}
	
		}

    }
    if (drugflag'="")
	{
		Trollback
		s result="false"
	}
	else
	{
		Tc
		s result= drgdr
	}
	q result
}

/// Function:保存重复用药
ClassMethod SaveRepeatItm(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("Repeat",seq))
		q:seq=""
		s str=^tempKB("Repeat",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{		
		s gen=$p(dataStr,"[next]",1)
		s point=$p(dataStr,"[next]",2)
		s drug=$p(dataStr,"[next]",3) //商品名
		s rule=$p(dataStr,"[next]",4) //规则
		s drgs=$p(dataStr,"[next]",5)  //关联商品名
		s mode=$p(dataStr,"[next]",6)
		s text=$p(dataStr,"[next]",7)
	
		s eobj=##class(web.Entity.KB.DHCPHRepeatItm).%New()

		//插入主索引表						
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PHINSTText=text

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
			s eobj.PHINSTMode=mode
	    }
		//重复用药规则
		if (rule'="")
		{
			s ruleid=..GetRepeatId(rule)
			q:ruleid="" "false"
			s eobj.PHRIRuleDr=ruleid
	
		}
		//商品名多选用/分开
		s drgdr=""
		if (drgs'="")
		{
			s drgdr=..GetProIds(drgs)
			q:(drgdr="false") "false"
			s eobj.PHRIProDr=drgdr 
	    }
	   
		//按通用名+剂型维护数据
		if ((gen'="")&(point'=""))
		{  
			//通用名
			s gen=..getGenId(gen)
			q:gen="" "false" 	   
			//剂型
			s point=..getPointId(point)
			q:point="" "false"
	
			//通用名和剂型关联表
			s isLink=..getLinkORNo(gen,point)
			q:(isLink'="true") "false"
			 

			s eobj.PHINSTGenDr=gen
			s eobj.PHINSTPointerDr=point
			s eobj.PHINSTPointerType="Form"
			s eobj.PHRIProDr=drgdr
			s str = ##class(web.DHCBL.KB.DHCPHRepeatItm).SaveData(eobj)

			if (str["false"){   
				q "false"
			}

					
		}
	    
	    
	    //按商品名维护数据
		if (drug'="")
		{   
			//商品名
			s drug=..GetProNameId(drug)
			q:drug="" "false"   
			s eobj.PHINSTGenDr=drug
			s eobj.PHINSTPointerDr="0"
			s eobj.PHINSTPointerType="ProName"
			s eobj.PHRIProDr=drgdr  //奇怪，这里要是不加这句，多选的就保存不了
	
			s str = ##class(web.DHCBL.KB.DHCPHRepeatItm).SaveData(eobj)
			if (str["false"){   
				q "false"
			}
	    }

		s result = "true"
		s ^tempKB("Repeat",row)=dataStr							

			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存炮制作用 成功result:1^1^1
ClassMethod SaveProcessingAct(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempKB("ProcessingAct",seq))
		q:seq=""
		s str=^tempKB("ProcessingAct",seq)
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
		//剂型
		s point=..getPointId(point)
		q:point="" "false"
		
		//通用名和剂型关联表
		s isLink=..getLinkORNo(gen,point)
		q:(isLink'="true") "false"

		//插入主索引表和不良反应表
		s eobj=##class(web.Entity.KB.DHCPHProcessingAct).%New()
		s eobj.PHINSTGenDr=gen
		s eobj.PHINSTPointerDr=point
		s eobj.PHINSTText=text
		s eobj.PHINSTOrderNum=1
		s eobj.PHINSTPointerType="Form"
		s eobj.PHINSTActiveFlag="Y"
		s eobj.PHINSTSysFlag="Y"
		s eobj.PACTOrdNum=row

		s str = ##class(web.DHCBL.KB.DHCPHProcessingAct).SaveData(eobj)
		if (str["false"){   
			q "false"
		}
										
		s result = "true"
		s ^tempKB("ProcessingAct",row)=dataStr
		
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Function:保存厂家字典  成功result:^1^1
ClassMethod SavePHManf(dataStr As %String) As %String
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
	    s eobj=##class(web.Entity.KB.DHCPHManf).%New()
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s updesc=$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^DHCPHMANF(0,"Code",upcode,0))
		s idd=$o(^DHCPHMANF(0,"Desc",updesc,0))
		//判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj.PHMARowId=idc
		 }
		
	    s eobj.PHMACode=code
	    s eobj.PHMADesc=desc
	    s eobj.PHMAActiveFlag=active
	    s str = ##class(web.DHCBL.KB.DHCPHManf).SaveData(eobj,"")
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

/// Function:保存草药毒性字典  成功result:^1^1
ClassMethod SavePHToxicity(dataStr As %String) As %String
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
	    s eobj=##class(web.Entity.KB.DHCPHToxicity).%New()
	    s upcode=$ZCONVERT(code,"U") //转换成大写
		s updesc=$ZCONVERT(desc,"U") //转换成大写
		s idc=$o(^DHCPHTOX(0,"Code",upcode,0))
		s idd=$o(^DHCPHTOX(0,"Desc",updesc,0))
		//判断是添加还是修改
		 if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj.ToxRowId=idc
		 }
		
	    s eobj.ToxCode=code
	    s eobj.ToxDesc=desc
	    s eobj.ToxActiveFlag=active
	    s str = ##class(web.DHCBL.KB.DHCPHToxicity).SaveData(eobj)
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

ClassMethod KillKBGlobal()
{
	;w ##class(web.DHCBL.BDP.ImportKBData).KillKBGlobal()
	;d $SYSTEM.OBJ.ImportDir("D:\","KBGlobal0407.gof")
	//字典表
	k ^DHCPHLIBL ;知识库标识字典
	k ^DHCPHPINL ;知识库目录字典
	k ^DHCPHLIBC ;知识库标识和HIS科室对照
	
	k ^DHCPHEGEN  ;通用名字典
	k ^DHCPHEGENi
	k ^DHCPHEGAL  ;通用名别名字典
	k ^DHCPHEGALi
	k ^User.DHCPHLibCatD  ;分类/类型字典表
	k ^User.DHCPHLibCatI
	k ^DHCPHDGP ;通用名药品属性表
	k ^DHCPHDGPi
	k ^DHCLISGP ;通用名检验属性表
	k ^DHCLISGPi
	k ^DHCGENLINP  ;通用名和剂型关联表
	k ^DHCGENLINPi
	k ^DHCPHGENCON  ;通用名对照表
	k ^User.DHCPHExtIngrI   ;药品成分字典表
	k ^User.DHCPHExtIngrD
	k ^DHCPHEGENIN  ;药品成分明细表
	k ^DHCPHEGENINi
	k ^DHCPHEF    ;剂型字典表
	k ^DHCPHEFi
	k ^DHCPHFOCON  ;剂型对照表
	k ^DHCPHEPA  ;检查部位字典
	k ^DHCPHPACON  ;检查部位对照
	k ^DHCEXTICD  ;诊断字典表
	k ^DHCEXTICDK ;诊断关键字表
	k ^DHCEXTICDKi  
	k ^DHCEXTICON ;诊断与HIS诊断对照
	k ^DHCPHDISL  ;病症字典
	k ^DHCPHDISCOML ;病症别名、常用名表
	k ^DHCPHDISCOMLi
	k ^DHCPHDISKEY  ;病症拼音码表
	k ^DHCPHDISKEYi
	
	k ^DHCPHPAGEL ;年龄字典
	k ^DHCPHEUO  ;单位字典表
	k ^DHCPHEUOi
	k ^DHCPHUOCON  ;单位对照表
	k ^DHCPHEINSTR ;用法字典表
	k ^DHCPHEINSTRi
	k ^DHCPHINSTCON  ;用法对照表
	k ^DHCPHEFR  ;频率字典表
	k ^DHCPHEFRi
	k ^DHCPHFRCON  ;频率对照表
	k ^DHCLABIF  ;检验条目字典
	k ^DHCPHYSIF ;生理字典表
	k ^DHCPHYSIFi
	k ^DHCEXAMINE  ;检查结果表
	k ^DHCEXAMINEi
	k ^DHCSPEP   ;特殊人群字典
	k ^DHCALLERGY ;过敏史字典表
	k ^DHCALLERGYi
	k ^DHCALLGYKEY  ;过敏史关键字表
	k ^DHCALLGYKEYi
	k ^DHCDISHISF ;既往史字典表
	k ^DHCDISHISFi
	k ^DHCDISHISK  ;既往史关键字表
	k ^DHCDISHISKi
	k ^DHCLSCCARE  ;标本采集注意事项
	//扩展

	k ^DHCPHHLOC  ;科室字典
	k ^DHCPHHLOCICD  ;科室常用诊断表
	k ^DHCPHHLOCCON  ;科室字典对照表
	k ^DHCPHSYMP  ;症状字典表
	k ^DHCPHSYMCON  ;症状字典对照表
	k ^DHCPHSYDRO   ;证型/证候字典
	k ^DHCPHSYNCON  ;证型字典对照表
	k ^DHCPHSYNICD  ;知识库诊断和症型关联表
	k ^DHCPHSYNGEN  ;知识库诊断和症型关联明细表
	k ^DHCPHDLSY   ;知识库诊断和症状关联表
	k ^DHCPHDLSYI  ;诊断与症状建议用药或检查
	
	//新加的表
	k ^DHCPHPNA  ;商品名字典
	k ^DHCPHPCO   ;商品名与HIS对照
	k ^DHCPHESQE ;规格字典
	k ^DHCPHMCT   ;溶媒分类字典
	k ^DHCPHMCTi
	k ^DHCPHMI ;溶媒分类明细
	k ^DHCPHMIi
	k ^DHCPHRFEi ;重复用药规则
	
	k ^DHCPHDAL ;单独用药
	k ^DHCPHKW ;知识库关键表字典表
	k ^DHCPHKWi
	k ^DHCPHRFEi ;重复用药规则
	k ^DHCPHRFE
	k ^DHCPHKW  ;知识库关键表字典表
	k ^DHCPHBTGE  ;菌属字典表
	k ^DHCPHBTGEi
	k ^DHCPHGENUSCON ;菌属对照表
	k ^DHCPHBTORG  ;细菌字典表
	k ^DHCPHBTORGi

	//业务表
	k ^DHCLABCLI
	k ^DHCLABDIAGI
	k ^DHCLIBALLI
	k ^DHCLIBCATI
	k ^DHCLIBDISHISI
	k ^DHCLIBLABI
	k ^DHCLIBSPEPI
	k ^DHCPHDISAGE
	k ^DHCPHDISFR
	k ^DHCPHDINTER
	k ^DHCPHDISUSE
	k ^DHCPHDDIS
	k ^DHCPHINI
	k ^DHCPHINSTRUC
	k ^DHCPHUSDO
	k ^DHCPHYVAL
	k ^DHCPHADDI
	k ^DHCLIBEXAI
	
	k ^DHCPHDST ;浓度
	k ^DHCPHDAL ;可配伍药品
	k ^DHCPHMD ;联合用药
	k ^DHCPHADN ;辅助用药个数
	k ^DHCPHEC ;成分含量（g）
	k ^DHCPHMQ ;溶媒量

	k ^DHCPHSYM ;症状业务表
	k ^DHCPHCU ;治疗手术业务表
	k ^DHCPHLRD  ;检验结果辅助诊断
	k ^DHCPHRITM  ;重复用药
	k ^DHCPHPACT  ;炮制作用
	k ^DHCPHORGBUS ;细菌业务表
	k ^DHCPHGENUSBUS ;菌属业务表
	k ^DHCPHOPCON ;手术对照表
	
	k ^tempKB
	k ^tempLAB
	k ^temp("KBData","Gen")
	
	q "ok"
}

/// 删除所有知识库对照表的数据
/// 谷雪萍  2017-09-14
/// w ##class(web.DHCBL.BDP.ImportKBData).KillKBConGlobal()
ClassMethod KillKBConGlobal()
{
	//字典表

	k ^DHCPHLIBC ;知识库标识和HIS科室对照	
	k ^DHCPHGENCON  ;通用名对照表
	k ^DHCPHFOCON  ;剂型对照表	
	k ^DHCPHPACON  ;检查部位对照
	k ^DHCEXTICON ;诊断与HIS诊断对照
	k ^DHCPHUOCON  ;单位对照表
	k ^DHCPHINSTCON  ;用法对照表
	k ^DHCPHFRCON  ;频率对照表

	k ^DHCPHHLOCCON  ;科室字典对照表
	k ^DHCPHSYMCON  ;症状字典对照表
	k ^DHCPHSYNCON  ;证型字典对照表
	k ^DHCPHPCO   ;商品名与HIS对照	
	k ^DHCPHGENUSCON ;菌属对照表
	k ^DHCPHOPCON ;手术对照表
	
	
	q "ok"
}

/// d ##class(web.DHCBL.BDP.ImportKBData).ExportGlobal()
ClassMethod ExportGlobal()
{
	k CList
	k myIdx
	
	//字典表
	s CList($i(CList))= "DHCPHLIBL.GBL" ;知识库标识字典
	s CList($i(CList))= "DHCPHPINL.GBL" ;知识库目录字典
	s CList($i(CList))= "DHCPHLIBC.GBL" ;知识库标识和HIS科室对照
	
	s CList($i(CList))= "DHCPHEGEN.GBL"  ;通用名字典
	s CList($i(CList))= "DHCPHEGENi.GBL"
	s CList($i(CList))= "DHCPHEGAL.GBL"  ;通用名别名字典
	s CList($i(CList))= "DHCPHEGALi.GBL"
	s CList($i(CList))= "User.DHCPHLibCatD.GBL"  ;分类/类型字典表
	s CList($i(CList))= "User.DHCPHLibCatI.GBL"
	s CList($i(CList))= "DHCPHDGP.GBL" ;通用名药品属性表
	s CList($i(CList))= "DHCPHDGPi.GBL"
	s CList($i(CList))= "DHCLISGP.GBL" ;通用名检验属性表
	s CList($i(CList))= "DHCLISGPi.GBL"
	s CList($i(CList))= "DHCGENLINP.GBL"  ;通用名和剂型关联表
	s CList($i(CList))= "DHCGENLINPi.GBL"
	s CList($i(CList))= "DHCPHGENCON.GBL"  ;通用名对照表
	s CList($i(CList))= "User.DHCPHExtIngrI.GBL"   ;药品成分字典表
	s CList($i(CList))= "User.DHCPHExtIngrD.GBL"
	s CList($i(CList))= "DHCPHEGENIN.GBL"  ;药品成分明细表
	s CList($i(CList))= "DHCPHEGENINi.GBL"
	s CList($i(CList))= "DHCPHEF.GBL"   ;剂型字典表
	s CList($i(CList))= "DHCPHEFi.GBL"
	s CList($i(CList))= "DHCPHFOCON.GBL"  ;剂型对照表
	s CList($i(CList))= "DHCPHEPA.GBL"  ;检查部位字典
	s CList($i(CList))= "DHCPHPACON.GBL"  ;检查部位对照
	s CList($i(CList))= "DHCEXTICD.GBL"  ;诊断字典表
	s CList($i(CList))= "DHCEXTICDK.GBL" ;诊断关键字表
	s CList($i(CList))= "DHCEXTICDKi.GBL"  
	s CList($i(CList))= "DHCEXTICON.GBL" ;诊断与HIS诊断对照
	s CList($i(CList))= "DHCPHDISL.GBL"  ;病症字典
	s CList($i(CList))= "DHCPHDISCOML.GBL" ;病症别名、常用名表
	s CList($i(CList))= "DHCPHDISCOMLi.GBL"
	s CList($i(CList))= "DHCPHDISKEY.GBL"  ;病症拼音码表
	s CList($i(CList))= "DHCPHDISKEYi.GBL"
	
	s CList($i(CList))= "DHCPHPAGEL.GBL" ;年龄字典
	s CList($i(CList))= "DHCPHEUO.GBL"  ;单位字典表
	s CList($i(CList))= "DHCPHEUOi.GBL"
	s CList($i(CList))= "DHCPHUOCON.GBL"  ;单位对照表
	s CList($i(CList))= "DHCPHEINSTR.GBL" ;用法字典表
	s CList($i(CList))= "DHCPHEINSTRi.GBL"
	s CList($i(CList))= "DHCPHINSTCON.GBL"  ;用法对照表
	s CList($i(CList))= "DHCPHEFR.GBL"  ;频率字典表
	s CList($i(CList))= "DHCPHEFRi.GBL"
	s CList($i(CList))= "DHCPHFRCON.GBL"  ;频率对照表
	s CList($i(CList))= "DHCLABIF.GBL"  ;检验条目字典
	s CList($i(CList))= "DHCPHYSIF.GBL" ;生理字典表
	s CList($i(CList))= "DHCPHYSIFi.GBL"
	s CList($i(CList))= "DHCEXAMINE.GBL"  ;检查结果表
	s CList($i(CList))= "DHCEXAMINEi.GBL"
	s CList($i(CList))= "DHCSPEP.GBL"   ;特殊人群字典
	s CList($i(CList))= "DHCALLERGY.GBL" ;过敏史字典表
	s CList($i(CList))= "DHCALLERGYi.GBL"
	s CList($i(CList))= "DHCALLGYKEY.GBL"  ;过敏史关键字表
	s CList($i(CList))= "DHCALLGYKEYi.GBL"
	s CList($i(CList))= "DHCDISHISF.GBL" ;既往史字典表
	s CList($i(CList))= "DHCDISHISFi.GBL"
	s CList($i(CList))= "DHCDISHISK.GBL"  ;既往史关键字表
	s CList($i(CList))= "DHCDISHISKi.GBL"
	s CList($i(CList))= "DHCLSCCARE.GBL"  ;标本采集注意事项
	//扩展

	s CList($i(CList))= "DHCPHHLOC.GBL"  ;科室字典
	s CList($i(CList))= "DHCPHHLOCICD.GBL"  ;科室常用诊断表
	s CList($i(CList))= "DHCPHHLOCCON.GBL"  ;科室字典对照表
	s CList($i(CList))= "DHCPHSYMP.GBL"  ;症状字典表
	s CList($i(CList))= "DHCPHSYMCON.GBL"  ;症状字典对照表
	s CList($i(CList))= "DHCPHSYDRO.GBL"   ;证型/证候字典
	s CList($i(CList))= "DHCPHSYNCON.GBL"  ;证型字典对照表
	s CList($i(CList))= "DHCPHSYNICD.GBL"  ;知识库诊断和症型关联表
	s CList($i(CList))= "DHCPHSYNGEN.GBL"  ;知识库诊断和症型关联明细表
	s CList($i(CList))= "DHCPHDLSY.GBL"   ;知识库诊断和症状关联表
	s CList($i(CList))= "DHCPHDLSYI.GBL"  ;诊断与症状建议用药或检查
	
	//新加的表
	s CList($i(CList))= "DHCPHPNA.GBL"  ;商品名字典
	s CList($i(CList))= "DHCPHPCO.GBL"   ;商品名与HIS对照
	s CList($i(CList))= "DHCPHESQE.GBL" ;规格字典
	s CList($i(CList))= "DHCPHMCT.GBL"   ;溶媒分类字典
	s CList($i(CList))= "DHCPHMCTi.GBL"
	s CList($i(CList))= "DHCPHMI.GBL" ;溶媒分类明细
	s CList($i(CList))= "DHCPHMIi.GBL"
	s CList($i(CList))= "DHCPHRFEi.GBL" ;重复用药规则
	
	s CList($i(CList))= "DHCPHDAL.GBL" ;单独用药
	s CList($i(CList))= "DHCPHKW.GBL" ;知识库关键表字典表
	s CList($i(CList))= "DHCPHKWi.GBL"
	s CList($i(CList))= "DHCPHRFEi.GBL" ;重复用药规则
	s CList($i(CList))= "DHCPHRFE.GBL"
	s CList($i(CList))= "DHCPHKW.GBL"  ;知识库关键表字典表
	s CList($i(CList))= "DHCPHBTGE.GBL" ;菌属字典表
	s CList($i(CList))= "DHCPHBTGEi.GBL"
	s CList($i(CList))= "DHCPHGENUSCON.GBL" ;菌属对照表
	s CList($i(CList))= "DHCPHBTORG.GBL" ;细菌字典表
	s CList($i(CList))= "DHCPHBTORGi.GBL"
	//业务表
	s CList($i(CList))= "DHCLABCLI.GBL"
	s CList($i(CList))= "DHCLABDIAGI.GBL"
	s CList($i(CList))= "DHCLIBALLI.GBL"
	s CList($i(CList))= "DHCLIBCATI.GBL"
	s CList($i(CList))= "DHCLIBDISHISI.GBL"
	s CList($i(CList))= "DHCLIBLABI.GBL"
	s CList($i(CList))= "DHCLIBSPEPI.GBL"
	s CList($i(CList))= "DHCPHDISAGE.GBL"
	s CList($i(CList))= "DHCPHDISFR.GBL"
	s CList($i(CList))= "DHCPHDINTER.GBL"
	s CList($i(CList))= "DHCPHDISUSE.GBL"
	s CList($i(CList))= "DHCPHDDIS.GBL"
	s CList($i(CList))= "DHCPHINI.GBL"
	s CList($i(CList))= "DHCPHINSTRUC.GBL"
	s CList($i(CList))= "DHCPHUSDO.GBL"
	s CList($i(CList))= "DHCPHYVAL.GBL"
	s CList($i(CList))= "DHCPHADDI.GBL"
	s CList($i(CList))= "DHCLIBEXAI.GBL"
	
	s CList($i(CList))= "DHCPHDST.GBL" ;浓度
	s CList($i(CList))= "DHCPHDAL.GBL" ;可配伍药品
	s CList($i(CList))= "DHCPHMD.GBL" ;联合用药
	s CList($i(CList))= "DHCPHADN.GBL" ;辅助用药个数
	s CList($i(CList))= "DHCPHEC.GBL" ;成分含量（g）
	s CList($i(CList))= "DHCPHMQ.GBL" ;溶媒量

	s CList($i(CList))= "DHCPHSYM.GBL" ;症状业务表
	s CList($i(CList))= "DHCPHCU.GBL" ;治疗手术业务表
	s CList($i(CList))= "DHCPHLRD.GBL"  ;检验结果辅助诊断
	s CList($i(CList))= "DHCPHRITM.GBL"  ;重复用药
	s CList($i(CList))= "DHCPHPACT.GBL"  ;炮制作用
	
	s CList($i(CList))= "DHCPHORGBUS.GBL"  ;细菌业务表
	s CList($i(CList))= "DHCPHGENUSBUS.GBL"  ;菌属业务表
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = "D:\KBGlobal"_time_".gof"
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
}

/// Creator：谷雪萍
/// CreatDate: 2021-01-12
/// Description：删除某一编辑器数据
/// Input:LibCode-知识库标识字典代码，PointerType-类别Form/ProName
/// return:删除成功或失败
/// w ##class(web.DHCBL.BDP.ImportKBData).KillBusData("LAB","Form")
ClassMethod KillBusData(LibCode As %String, PointerType As %String) As %String
{
	q:LibCode="" "{success:'false',info:'请输入知识库标识字典代码！'}"
	s LibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT(LibCode,"U"),0))  //要删除的编辑器知识库标识字典id
	q:LibDr="" "{success:'false',info:'没有获取到知识库标识字典id！'}"
	s result=""
	TS 
	if (PointerType="ProName")
	{
		//遍历商品名字典
	    s PHNRowId=0
		for  
		{	
			s PHNRowId=$o(^DHCPHPNA(PHNRowId)) q:(PHNRowId="")||(result["false") 
			s result=..KillBusOneData(PHNRowId,PointerType,0)
		}

	}
	else
	{
		s GlPRowId=0  //遍历通用名和剂型关联、检验通用名和标本关联表、检查项目通用名和部位关联表（一张表）
		for  
		{	
			s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:(GlPRowId="")||(result["false")

			s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
			s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //剂型/标本/部位指针

		
			s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7)  //知识库标识字典id
			continue:LibDr'=PHEGLibDr
			s result=..KillBusOneData(GlPGenDr,PointerType,GlPPointer)	
			
			//删除关联表
			if (result'["false")
			{
				s sc=##class(User.DHCGenLinkPointer).%DeleteId(GlPRowId)
				if '$$$ISOK(sc){
					s result="{success:'false',info:'删除失败！'}"
					q
				}		
			}	
		}
	}

	if (result["false")
	{
		Tro
		s result="{success:'false',info:'删除失败！'}"
	}
	else
	{
		TC
		s result = "{success:'true',info:'删除成功！'}"

	}
	q result
}

/// Creator：谷雪萍
/// CreatDate: 2021-01-12
/// Description：删除编辑器下的一条数据
/// Input：GenDr-通用名ID/商品名ID，PointerType-类别Form/ProName，PointerDr-剂型ID/标本ID/部位ID
/// w ##class(web.DHCBL.BDP.ImportKBData).KillBusOneData(16,"Form",2)
ClassMethod KillBusOneData(GenDr As %String, PointerType As %String, PointerDr As %String) As %String
{
	s result=""
	s errorFlag=""
	TS
	//遍历主索引表
	s InstId=0
	for
	{
		s InstId=$o(^DHCPHINSTRUC("0","GP",GenDr,PointerType,PointerDr,InstId))	q:(InstId="")||(errorFlag="1")
		
		//临床意义
		s RowId=0
		for
		{
			s RowId = $o(^DHCLABCLI("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCLabClinical).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//过敏史业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCLIBALLI("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCLibAllergyItm).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//分类业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCLIBCATI("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCLibCatItm).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//既往史业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCLIBDISHISI("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCLibDisHistoryItm).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//检验指标业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCLIBLABI("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCLibLabItm).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//特殊人群业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCLIBSPEPI("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCLibSpecPopuItm).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//年龄业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHDISAGE("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHDiseaseAge).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//用药频率业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHDISFR("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHDiseaseFreq).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//相互作用、互斥项目
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHDINTER("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHDiseaseInteract).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//用药方法业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHDISUSE("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHDiseaseUse).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//病症业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHDDIS("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHDrugDisease).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//成分业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHINI("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHIngrItm).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//用法用量业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHUSDO("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHUsageDosage).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//生理参数业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHYVAL("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPhysiologyVal).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//注意事项、不良反应
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHADDI("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHAddInfo).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//检验业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCLIBEXAI("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCLibExaItm).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//浓度
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHDST("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHDrgSolvent).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//可配伍药品
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHDAL("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHDrgAlone).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//联合用药
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHMD("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHMustDrug).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//辅助用药个数
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHADN("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHAssDrugNum).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//成分含量（g）
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHEC("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHEleCon).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//溶媒量
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHMQ("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHMenstruumQty).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//症状业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHSYM("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHSymptomBus).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//治疗手术业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHCU("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHCure).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//检验结果辅助诊断
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHLRD("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHLibResultDiag).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//重复用药
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHRITM("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHRepeatItm).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//炮制作用
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHPACT("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHProcessingAct).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//细菌业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHORGBUS("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHOrganismBus).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//菌属业务表
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHGENUSBUS("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHGenusBus).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		//滴速
		s RowId=0
		for
		{
			s RowId = $o(^DHCPHDRSP("0","Inst",InstId,RowId)) q:RowId=""
			s sc=##class(User.DHCPHDrippingSpeed).%DeleteId(RowId)
			if '$$$ISOK(sc){
				s errorFlag="1"
				q
			}
		}
		
		//删除主索引表
		s sc=##class(User.DHCPHInstructions).%DeleteId(InstId)
		if '$$$ISOK(sc){
			s errorFlag="1"
			q
		}
	}
	if (errorFlag="")
	{
		TC
		s result = "{success:'true',info:'删除成功！'}"
	}
	else
	{
		Tro
		s result="{success:'false',info:'删除失败！'}"
	}
	q result
}

}
