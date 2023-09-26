/// 名称:实施综合管理平台-字典对照
/// 描述:用于字典表修改删除时，同步修改删除对照数据
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2021-1-22
Class web.CDSS.IMP.InterDictMapping Extends %RegisteredObject
{

/// Creator：钟荣枫 
/// CreatDate: 2021-1-22
/// Description：将某个知识库的数据的对照数据删除,同时处理1.0以及2.0的数据
/// Table:type 类型 ,str 原来的代码[A]描述
/// Input： 
/// Return：re1_"[A]"_re2
/// Other: w ##class(web.CDSS.IMP.DictMappingInfo).DelMappings()
ClassMethod DelMappings(type, str)
{
	s ^TMP("KKK1")=type_","_str
	s result=""
	//s re1=##class(web.CDSS.IMP.InterDictMapping).DelMappings(type,str)
	s re1="true"
	s re2=##class(web.CDSS.IMP.ContrastDict).DelMappings(type,str)
	s result=re1_"[A]"_re2		//2.0
	//s result=re2				//2.1
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2021-1-22
/// Description：将某个知识库的数据的对照数据删除,原先的知识库数据的代码保持不变,同时处理1.0以及2.0的数据
/// Table:
/// Input：type 类型 ,oldstr 原来的代码[A]描述,newstr 修改后的代码[A]描述 
/// Return：false，true
/// Other: w ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings(type, oldstr,newstr)
ClassMethod UpdateMappings(type, oldstr, newstr)
{

	s result=""
	//s re1=##class(web.CDSS.IMP.InterDictMapping).UpdateMappings(type, oldstr, newstr)
	//s ^temp("555")=re1
	s re1="true"
	s flag1=##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.CDSSEntity.IMP.DictMappingInfo")
	if (flag1="1")
	{
	s re2=##class(web.CDSS.IMP.ContrastDict).UpdateMappings(type, oldstr, newstr)
	s flag = ##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("V1.2MKBConfig") //2.0
	//s flag = ##class(web.CDSS.Config.MKBConfig).GetConfigValue("V1.2MKBConfig") //2.1
	if (flag="Y")
	{
		s type1=type_"名称"
		s newdesc=$p(newstr,"[A]",2)
		s olddesc=$p(oldstr,"[A]",2)
		s re3= ##class(web.CDSS.CMKB.RuleTrigger).SynchroDictWord(type1,newdesc,olddesc)
	}
	}
	//s ^temp("666")=re2
	s result=re1_"^"_re2	//2.0
	//s result=re2 			//2.1
	q result
}

/// Creator：钟荣枫
/// CreatDate: 2021-1-29
/// Description:删除限制  知识库数据在字典对照1.0，2.0的引用
/// Input: type-类型  desc-描述
/// Return:位置
/// Other: w ##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("检验","测试ZWWBQ")
ClassMethod GetRefFlag(type As %String, desc As %String) As %String
{
	q:((type="")||(desc="")) ""
	s myInfo=""
	
	/*/对照1.0
	s type1=$case(type,"诊断":"1","检查":"2","检验":"3","药品":"4","手术":"5","护理":"6","频率":"7","体征":"8","检验标本":"9","用法":"10","单位":"11","科室":"12","输血品":"13","检验医嘱":"14","中药":"15",:"")
	if (type1'="")
	{
		s DictiClassMapping=$lg($g(^User.DHCDSSInterfaceClassDictD(type1)),5)	//对照CDSS字典名
		
		s DictID=##class(web.CDSS.IMP.InterDictMapping).GetDictID(DictiClassMapping,"",desc)
		if (DictID'="")
		{
			s Hospital=""
			for
			{
				//Index UniqueIndex On (DictMapType As Exact, DictHosp As Exact, DictDR As Exact, IntDictDR As Exact);

				s Hospital=$o(^User.DHCDSSInterDictMappingI("UniqueIndex",type1,Hospital))
				q:Hospital=""
				
				s IntDictDR=$o(^User.DHCDSSInterDictMappingI("UniqueIndex",type1,Hospital,DictID,""))
				if (IntDictDR'="")		//存在对照
				{	
				s DictHospDesc=$LISTGET($G(^User.DHCDSSCustomerHospD(Hospital)),3)
					s myInfo=myInfo_"<字典对照1.0-"_DictHospDesc_">"
					q:$l(myInfo,"字典对照1.0")=6
				}
			}
		}
	}*/
	//对照2.0
	s type2=$case(type,"药品":"药品","诊断":"诊断","检查":"检查检验","检验":"检查检验","检验医嘱":"检查检验","手术":"手术","护理":"护理","频率":"频率","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","中药":"中药","输血品":"输血品","中医疾病":"中医疾病",:"")
	s desc=","_desc_","
	s Hospital=""
	for
	{
		s Hospital=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital))
		q:Hospital=""
		s Descs=""
		s info=0
		for
		{
			q:info=1
			s Descs=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,type2,Descs))
			q:Descs=""
			s TDescs=","_Descs_","
			CONTINUE:TDescs'[desc
			s State=""
			for
			{
				q:info=1
				s State=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,type2,Descs,State))
				q:State=""
				if ((State'="")&&(State'="已删除")&&(State'="未关联"))	//存在对照
				{
					s DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(Hospital)),3)
					s myInfo=myInfo_"<字典对照2.0-"_DictHospDesc_">"
					s info=1
				}
			}
		}	
		q:$l(myInfo,"字典对照2.0")>5
	}
	q myInfo
}

/*
/// Creator：钟荣枫
/// CreatDate:2021-3-20
/// Description:导出字典对照1.0的global
/// Input:path
/// Others：d ##class(web.CDSS.IMP.DictMappingInfo).ExportCDSSMappingGlobal("D:\MappingGlobal\")
ClassMethod ExportCDSSMappingGlobal(filePath)
{
	k MList
	k MIdx
	//对接方字典表
	s MList($i(MList))= "User.DHCDSSInterfaceDictD.GBL"  
	
	//对接方字典分类表 
	s MList($i(MList))= "User.DHCDSSInterfaceClassDictD.GBL"  
	
	//字典对照 
	s MList($i(MList))= "User.DHCDSSInterDictMappingD.GBL" 
	
	//医院 
	s MList($i(MList))= "User.DHCDSSCustomerHospD.GBL"
	s MList($i(MList))= "User.DHCDSSCustomerHospI.GBL"
	//医院院区
	s MList($i(MList))= "User.DHCDSSCustomerHospC.GBL"
	 
	 //对接方字典关联院区表
	s MList($i(MList))= "CT.WDT.CDSS.InterDictConAreaD.GBL"
	 
	
	//his检验医嘱和his检验项目（检验小项）关联表
	s MList($i(MList))= "User.DHCDSSLabOrderConItemD.GBL" 
	
	//把所有GBL拼起来
	s items = ""
	for {
		s MIdx = $i(MIdx)
		q:(MIdx>$g(MList))
		s:items'="" items=items_","_MList(MIdx)
		s:items="" items=MList(MIdx)
	}
	s time = $zdt($h,3)
	s time=$p(time,":",1)
	s filename = filePath_"MappingData"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	//删除十天前的备份
	/*
	s time = $zd(+$H-10,3)
	w time,!
	s filename = filePath_"MappingData"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
	//
}
*/

/*
/// Creator：钟荣枫
/// CreatDate:2021-4-8
/// Description:导入字典对照1.0的global后重新生成索引
/// Input:path
/// Others：d ##class(web.CDSS.IMP.DictMappingInfo).BuildIndices()
ClassMethod BuildIndices()
{
	d ##class(User.DHCDSSInterfaceDict).%BuildIndices()
	d ##class(User.DHCDSSInterfaceClassDict).%BuildIndices()
	d ##class(User.DHCDSSInterDictMapping).%BuildIndices()
	d ##class(User.DHCDSSLabOrderConItem).%BuildIndices()
	d ##class(User.DHCDSSCustomerHosp).%BuildIndices()
	d ##class(CT.WDT.CDSS.CustomerHospArea).%BuildIndices()
	d ##class(CT.WDT.CDSS.InterDictConArea).%BuildIndices()
}
*/

/*// Creator：钟荣枫
/// CreatDate:2021-11-26
/// Description:删除字典对照1.0数据
/// Input:path
/// Others：d ##class(web.CDSS.IMP.DictMappingInfo).KillMappingGlobal()
ClassMethod KillMappingGlobal()
{
	b ;确定库是否正确？？？确定的话输 g 不确定输 q	
	b ;确定要删除字典对照V1.0的所有数据吗？确定的话输 g 不确定输 q
	k ^User.DHCDSSInterfaceDictD
	k ^User.DHCDSSInterfaceDictI
	k ^User.DHCDSSInterfaceClassDictD
	k ^User.DHCDSSInterfaceClassDictI
	k ^User.DHCDSSInterDictMappingD
	k ^User.DHCDSSInterDictMappingI
	k ^User.DHCDSSLabOrderConItemD
	k ^User.DHCDSSLabOrderConItemI
	k ^User.DHCDSSCustomerHospD
	k ^User.DHCDSSCustomerHospI
	k ^CT.WDT.CDSS.CustomerHospAreaI
	k ^CT.WDT.CDSS.InterDictConAreaD
	k ^CT.WDT.CDSS.InterDictConAreaI
	
	q "ok"
}
*/
}
