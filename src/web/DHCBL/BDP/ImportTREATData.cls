Import SQLUser

/// 名称:导入治疗项目知识库模板
/// 编写者：基础平台组 -谷雪萍
/// 编写日期: 2020-05-01
Class web.DHCBL.BDP.ImportTREATData Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate: 2020-05-01
/// Description：前台导入手术编辑器模板数据调用的方法
/// Input: dataStr-数据拼串，sheetid-模板中第几个Excel，row-行号
/// Return:成功返回true，失败返回false
/// Others:s str="NK0001[next]鼻咽镜检查[next]鼻咽镜检查[next]鼻咽镜检查[next]内镜[next]byj/byjjc[next]头部[next]"
/// Others:w ##class(web.DHCBL.BDP.ImportTREATData).SaveData(str,11,1)
ClassMethod SaveData(dataStr As %String, sheetid As %String, row As %Float) As %String
{
	
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.ImportKBData).EvalJSON(dataStr)	
	
 	/// Function:保存知识库标识字典
	s:sheetid=2 result=##class(web.DHCBL.BDP.ImportKBData).SaveLibaryLabel(dataStr)

	/// Function:保存知识库目录字典
	s:sheetid=3 result=##class(web.DHCBL.BDP.ImportKBData).SaveInstLabel(dataStr)
	
	/// Function:保存过敏史
	s:sheetid=4 result=##class(web.DHCBL.BDP.ImportKBData).SaveAllergy(dataStr)
	
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
	
	/// Function:保存检查部位
	s:sheetid=10 result=##class(web.DHCBL.BDP.ImportCheckData).SavePart(dataStr)
	
	/// Function:保存治疗项目通用名
	s:sheetid=11 result=##class(web.DHCBL.BDP.ImportCheckData).SaveGeneric(dataStr)

	/// Function:保存适应症 
	s:sheetid=12 result=..SaveDiseaseInd(dataStr,row)
	
	/// Function:保存禁忌症 
	s:sheetid=13 result=..SaveDiseaseCon(dataStr,row)
	

	q result
}

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：导入治疗项目适应证
/// Input: dataStr-数据拼串
/// Return:成功返回true，失败返回false  
/// Others:w ##class(web.DHCBL.BDP.ImportTREATData).SaveDiseaseInd(str)
ClassMethod SaveDiseaseInd(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempTreat("TreatIndic",seq))
		q:seq=""
		s str=^tempTreat("TreatIndic",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s result=""
		s gen=$p(dataStr,"[next]",1)
		s part=$p(dataStr,"[next]",2)
		s lib="治疗项目"
		s mode=$p(dataStr,"[next]",3)
		s dis=$p(dataStr,"[next]",4)	
		s sex=$p(dataStr,"[next]",5)
		s text=$p(dataStr,"[next]",6)		
		s key0=$p(dataStr,"[next]",7)
		s key1=$p(dataStr,"[next]",8)
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
		s gen=##class(web.DHCBL.BDP.ImportCheckData).getGenId(gen,lib)
		q:gen="" "false" 	   
		//部位
		s part=##class(web.DHCBL.BDP.ImportCheckData).getPartId(part)
		q:part="" "false"
		
		//通用名和部位关联表
		s isLink=##class(web.DHCBL.BDP.ImportKBData).getLinkORNo(gen,part)
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
			s disdr=##class(web.DHCBL.BDP.ImportKBData).getDisIds(dis)
			q:(disdr="false") "false"
			s eobj.PHDDDiseaDr=disdr
		}
		//病症体征					
		if (key0'="")
		{
			s key0dr=##class(web.DHCBL.BDP.ImportKBData).getKeyIds(key0,"0")
			q:(key0dr="false") "false"
			s eobj.PSYMKeyWordDr=key0dr 		
			
		}
		//治疗手术					
		if (key1'="")
		{
			s key1dr=##class(web.DHCBL.BDP.ImportKBData).getKeyIds(key1,"1")
			q:(key1dr="false") "false"
			s eobj.PDCUKeyWordDr=key1dr 				
		}
		
		s str = ##class(web.DHCBL.KB.DHCCheckDiseaseI).SaveIndData(eobj)
		if (str["false"){   
			q "false"
		}

		s result = "true"
		s ^tempTreat("TreatIndic",row)=dataStr	
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：导入治疗项目禁忌证
/// Input: dataStr-数据拼串
/// Return:成功返回true，失败返回false  
/// Others:w ##class(web.DHCBL.BDP.ImportTREATData).SaveDiseaseCon(str)
ClassMethod SaveDiseaseCon(dataStr As %String, row As %Float) As %String
{
	s result=""
	s flag=""
	s seq=0
	for{
		s seq=$o(^tempTreat("TreatContr",seq))
		q:seq=""
		s str=^tempTreat("TreatContr",seq)
		if (str=dataStr) {
			s flag="repeat"
		}
	}
		
 	if (flag="")
 	{
		s gen=$p(dataStr,"[next]",1)
		s part=$p(dataStr,"[next]",2)
		s lib="治疗项目"
		s disType=$p(dataStr,"[next]",3)
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
		s gen=##class(web.DHCBL.BDP.ImportCheckData).getGenId(gen,lib)
		q:gen="" "false" 
			   
		//部位
		s part=##class(web.DHCBL.BDP.ImportCheckData).getPartId(part)
		q:part="" "false"
	
		//通用名和部位关联表
		s isLink=##class(web.DHCBL.BDP.ImportKBData).getLinkORNo(gen,part)
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
			s disdr=##class(web.DHCBL.BDP.ImportKBData).getDisIds(dis)
			q:(disdr="false") "false"
			s eobj.PHDDDiseaDr=disdr
			//控制级别
			s:disType="禁用" disType="F"
			s:disType="慎用" disType="C"
			if ((disType'="F")&(disType'="C"))
			{
				s disType="F"
			}
			s eobj.PHDDType=disType

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
	
		//特殊人群
		s popu=""
		if (special'="")
		{				
			s popu=##class(web.DHCBL.BDP.ImportKBData).getSpecialPopuIds(special)
			q:(popu="false") "false"
			s eobj.SpecialPopu=popu

		}
	
		//过敏史
		if (allergy'="")
		{
			s allergy=##class(web.DHCBL.BDP.ImportKBData).GetAllergyId(allergy)
			q:(allergy="") "false"	
			s eobj.LALCAllergyDr=allergy						
		}
		
		//病症体征					
		if (key0'="")
		{
			s key0dr=##class(web.DHCBL.BDP.ImportKBData).getKeyIds(key0,"0")
			q:(key0dr="false") "false"
			s eobj.PSYMKeyWordDr=key0dr 		
			
		}
		//治疗手术					
		if (key1'="")
		{
			s key1dr=##class(web.DHCBL.BDP.ImportKBData).getKeyIds(key1,"1")
			q:(key1dr="false") "false"
			s eobj.PDCUKeyWordDr=key1dr 				
		}
		s str = ##class(web.DHCBL.KB.DHCCheckDiseaseC).SaveConData(eobj)
		if (str["false")
		{   
			q "false"
		}
		

		s result = "true"
		s ^tempTreat("TreatContr",row)=dataStr
		
			
	}
	else
	{
		s result = "true"
	}	
	q result
}

}
