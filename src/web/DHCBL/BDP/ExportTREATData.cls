/// 名称:基础数据平台组治疗知识库数据导出。 
/// 编写者:基础数据平台组 - 谷雪萍
/// 编写日期:2020-5-1
Class web.DHCBL.BDP.ExportTREATData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:谷雪萍
/// CreatDate: 2020-05-01
/// Description：获取每个表的标题行
/// Input: table-模板中第几个sheet
/// Return:str-标题串
/// w ##class(web.DHCBL.BDP.ExportTREATData).GetTitle(2)
ClassMethod GetTitle(table As %String) As %String
{
	n (table)
	s str=""
	if (table="2")
	{
		s str="知识库标识代码&%知识库标识描述&%是否可用"
	}
	if (table="3")
	{
		s str="知识库目录代码&%知识库目录描述&%知识库标识&%顺序&%管理模式&%图标路径&%是否全部通过&%提示消息&%在药品通用名目录显示&%在商品通用名目录显示"
	}
	if (table="4")
	{
		s str="过敏史代码&%过敏史描述&%别名"
	}
	if (table="5") 
	{
		s str="HIS库诊断代码&%HIS库诊断描述&%知识库诊断代码&%知识库诊断描述&%类型&%操作状态&%备注&%关键字"
	}
	if (table="6")
	{
		s str="HIS库单位代码&%HIS库单位描述&%知识库单位代码&%知识库单位描述"
	}
	if (table="7")
	{
		s str="特殊人群代码&%特殊人群描述"
	}
	if (table="8")
	{
		s str="知识库病症代码&%知识库病症描述&%拼音码&%常用名&%常用名拼音码&%别名&%备注&%知识库icd代码"
	}
	if (table="9") 
	{
		s str="年龄代码&%年龄描述&%最小值&%最大值&%单位&%是否可用&%系统标识"
	}
	if (table="10") 
	{
		s str="HIS库通用名代码&%HIS库通用名描述&%知识库通用名代码&%知识库通用名描述"
	}
	if (table="11") 
	{
		s str="HIS通用名代码&%HIS通用名描述&%知识库通用名代码&%知识库通用名描述&%知识库标识&%知识库通用名别名&%部位"
	}
	if (table="12") 
	{
		s str="治疗项目通用名&%部位&%控制级别&%知识库病症&%性别&%描述说明&%病症体征&%治疗手术"
	}
	if (table="13") 
	{
		s str="治疗项目通用名&%部位&%知识库病症类型&%知识库病症&%年龄&%年龄限制&%性别&%特殊人群&%过敏史&%描述说明&%控制级别&%病症体征&%治疗手术"
	}
	q str
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-01
/// Description：获取每个表的数据总量
/// Input: table-模板中第几个sheet
/// Return:rs-数据总量
/// w ##class(web.DHCBL.BDP.ExportTREATData).GetCount("2")
ClassMethod GetCount(table) As %String
{
	n (table)
	s rs=""
	if (table="2")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetLibaryLabelCount()
	}
	if (table="3")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetInstLabelCount()
	}
	if (table="4")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetAllergyCount()
	}
	if (table="5")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetIcdFeildCount()
	}
	if (table="6")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtUomCount()
	}
	if (table="7")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetSpecialPopuCount()
	}
	if (table="8")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseCount()
	}
	if (table="9")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetAgeCount()
	}
	if (table="10")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetPartCount()
	}
	if (table="11")
	{
		s rs=..GetGenericCount("TREAT")
	}
	if (table="12")
	{
		s rs=..GetBusCount("TREAT","TreatIndic")
	}
	if (table="13")
	{
		s rs=..GetBusCount("TREAT","TreatContr")
	}

	q rs
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-01
/// Description：获取导出的表名
/// Input: table-模板中第几个sheet
/// Return:rs-表名
/// w ##class(web.DHCBL.BDP.ExportTREATData).GetName("2")
ClassMethod GetName(table) As %String
{
	n (table)
	s rs=""
	if (table="2")
	{
		s rs="知识库标识字典"
	}
	if (table="3")
	{
		s rs="知识库目录字典"
	}
	if (table="4")
	{
		s rs="过敏史"
	}
	if (table="5")
	{
		s rs="诊断字典对照"
	}
	if (table="6")
	{
		s rs="单位字典"
	}
	if (table="7")
	{
		s rs="特殊人群字典"
	}
	if (table="8")
	{
		s rs="病症"
	}
	if (table="9")
	{
		s rs="年龄字典"
	}
	if (table="10")
	{
		s rs="检查部位字典"
	}
	if (table="11")
	{
		s rs="通用名（治疗项目）"
	}
	if (table="12")
	{
		s rs="适应症"
	}
	if (table="13")
	{
		s rs="禁忌症"
	}	
	
	q rs
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-01
/// Description：获取每行数据
/// Input: table-模板中第几个sheet
/// Return:i-第几行数据
/// w ##class(web.DHCBL.BDP.ExportTREATData).GetInfo("2","1")
ClassMethod GetInfo(table, i) As %String
{
	n (table,i)
	s rs=""
	if (table="2")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetLibaryLabelInfo(i)
	}
	if (table="3")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetInstLabelInfo(i)
	}
	if (table="4")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetAllergyInfo(i)
	}
	if (table="5")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetIcdFeildInfo(i)
	}
	if (table="6")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtUomInfo(i)
	}
	if (table="7")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetSpecialPopuInfo(i)
	}
	if (table="8")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseInfo(i)
	}
	if (table="9")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetAgeInfo(i)
	}
	if (table="10")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetPartInfo(i)
	}
	if (table="11")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetGenericInfo(i)
	}
	if (table="12")
	{
		s rs=..GetDiseaseIndInfo("TreatIndic",i)
	}
	if (table="13")
	{
		s rs=..GetDiseaseConInfo("TreatContr",i)
	}

	q rs
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-01
/// Description：获取通用名数据总数
/// Input: LibaryCode-知识库标识字典代码
/// Return:count-数据总数
/// Others:w ##class(web.DHCBL.BDP.ExportTREATData).GetBusCount("TREAT")
ClassMethod GetGenericCount(LibaryCode) As %String
{
	n (LibaryCode)
	k ^TMPKBCOUNT("DHCPHExtGeneric")
    s count=0
    q:LibaryCode="" count
	s id=0,Code=""
	for {
		s id=$o(^DHCPHEGEN(id)) q:id=""
		s Code=$p($g(^DHCPHEGEN(id)),"^",1)       //工号
		s lib=""
		s PHEGLibDr=$p($g(^DHCPHEGEN(id)),"^",7) 
		s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1)  //知识库标识代码

		continue:Code=""
		continue:(lib'=LibaryCode)

		if ($d(^DHCPHGENCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHGENCON("0","Code",Code,hiscode)) q:hiscode="" 
				s conid=""
				for
				{
					s conid=$o(^DHCPHGENCON("0","Code",Code,hiscode,conid)) q:conid=""
					continue:conid=""
					s count=count+1	
					s ^TMPKBCOUNT("DHCPHExtGeneric",count)=id_"#"_conid
				}
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHExtGeneric",count)=id
		}

	}	
	q count
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-01
/// Description：获取编辑器各项的数据总数
/// Input: LibaryCode-知识库标识字典代码，InstCode-知识库目录字典代码
/// Return:count-数据总数
/// Others:w ##class(web.DHCBL.BDP.ExportTREATData).GetBusCount("TREAT","TreatIndic")
ClassMethod GetBusCount(LibaryCode, InstCode) As %String
{
	n (LibaryCode,InstCode)
	k ^TMPKBCOUNT(InstCode)
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		continue:GlPGenDr=""
		s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7)       //通用名标识
		continue:PHEGLibDr=""
		s PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1)  //知识库标识代码 
		continue:PHLICode'=LibaryCode
		
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode=InstCode) 
			{
				s count=count+1
				s ^TMPKBCOUNT(InstCode,count)=id_"^"_PHINSTRowId
			}
				
		}
	
		
	}	
	q count
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-01
/// Description：获取适应症每行的数据
/// Input: InstCode-知识库目录字典代码
/// Return:PHEGDesc_"&%"_PHEFDesc_"&%"_mode_"&%"_dis_"&%"_sex_"&%"_PHINSTText_"&%"_key0_"&%"_key1
/// Others:w ##class(web.DHCBL.BDP.ExportTREATData).GetDiseaseIndInfo("TreatIndic",1)
ClassMethod GetDiseaseIndInfo(InstCode, i) As %String
{
	n (InstCode,i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT(InstCode,i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //部位DR
		
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT(InstCode,i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEPA(GlPPointer)),"^",2)          //部位
	
	//知识库标识
	s lib=""
	s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
	s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
	
	
	//适应症、病症
	s dis=""
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",PHINSTRowId,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (dis'="")
			{
				s dis = dis_"/"_$p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
			else
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
	}
	
	//性别
	s sex=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",9)
	s:sex="M" sex="男" 
	s:sex="F" sex="女" 
	s:sex="A" sex="全部" 
	
	
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
	
	//病症体征
	s RowId=0
	s key0=""
	for
	{
		s RowId=$o(^DHCPHSYM(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s PSYMKeyWordDr=$p(^DHCPHSYM(RowId),"^",2)
		if (PSYMKeyWordDr'="") 
		{
			if (key0'="")
			{
				s key0 = key0_"/"_$p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
			else
			{
				s key0 = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
		} 
	}
	
	//治疗手术
	s RowId=0
	s key1=""
	for
	{
		s RowId=$o(^DHCPHCU(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s PDCUKeyWordDr=$p(^DHCPHCU(RowId),"^",2)
		if (PDCUKeyWordDr'="") 
		{
			if (key1'="")
			{
				s key1 = key1_"/"_$p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
			else
			{
				s key1 = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
	
	
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_mode_"&%"_dis_"&%"_sex_"&%"_PHINSTText_"&%"_key0_"&%"_key1
	q str
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-01
/// Description：获取禁忌症每行的数据
/// Input: InstCode-知识库目录字典代码
/// Return:PHEGDesc_"&%"_PHEFDesc_"&%"_type_"&%"_dis_"&%"_age_"&%"_agelimit_"&%"_sex_"&%"_popu_"&%"_allergy_"&%"_PHINSTText_"&%"_mode_"&%"_key0_"&%"_key1
/// Others:w ##class(web.DHCBL.BDP.ExportTREATData).GetDiseaseConInfo("TreatContr",1)
ClassMethod GetDiseaseConInfo(InstCode, i) As %String
{
	n (InstCode,i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT(InstCode,i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //标本DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT(InstCode,i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEPA(GlPPointer)),"^",2)          //部位
	
	//知识库标识
	s lib=""
	s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
	s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
	
	//禁忌症、病症
	s dis=""
	s PHDDRowId=0
	s dis="",type=""
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",PHINSTRowId,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		s type=$p(^DHCPHDDIS(PHDDRowId),"^",6)
		if (type="C")
		{
			s type="慎用"
		}
		else
		{
			s type="禁用"
		}
		if (PHDDDiseaDr'="") 
		{
			if (dis'="")
			{
				s dis = dis_"/"_$p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
			else
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
		
	}
	//年龄
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",PHINSTRowId,0))
	s age="",agelimit="",uom=""
	if (PDARowId'="")
	{
		s PDAAgeDr=$p($g(^DHCPHDISAGE(PDARowId)),"^",2)
		s:PDAAgeDr'="" age=$p($g(^DHCPHPAGEL(PDAAgeDr)),"^",2)
		 
		//年龄限制^DHCPHDISAGE
		s PDAMaxVal=$p($g(^DHCPHDISAGE(PDARowId)),"^",4)
		s PDAMinVal=$p($g(^DHCPHDISAGE(PDARowId)),"^",3)
		s PDAUomDr=$p($g(^DHCPHDISAGE(PDARowId)),"^",5)
		s:PDAUomDr'="" uom=$p($g(^DHCPHEUO(PDAUomDr)),"^",2)
		s:PDAMinVal'="" agelimit=PDAMinVal
		s:PDAMaxVal'="" agelimit=agelimit_"-"_PDAMaxVal
		s:uom'="" agelimit=agelimit_"/"_uom
	   
	}
	
	
	//性别
	s sex=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",9)
	s:sex="M" sex="男" 
	s:sex="F" sex="女" 
	s:sex="A" sex="全部" 
	s:sex="" sex="全部" 
	
	//特殊人群
	s SPEPIRowId=0
	s popu=""
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",PHINSTRowId,SPEPIRowId)) q:SPEPIRowId=""	
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		if (SPEPISpecDr'="")
		{
			if (popu'="")
			{
				s popu = popu_"/"_$p($g(^DHCSPEP(SPEPISpecDr)),"^",2)
			}
			else
			{
				s popu = $p($g(^DHCSPEP(SPEPISpecDr)),"^",2)
			}
		}	
	}
	//过敏史
	s LALCRowId=$o(^DHCLIBALLI(0,"Inst",PHINSTRowId,0))
	s allergy=""
	if (LALCRowId'="")
	{
		s LALCAllergyDr=$P($g(^DHCLIBALLI(LALCRowId)),"^",2)  
		s:LALCAllergyDr'="" allergy=$p($g(^DHCALLERGY(LALCAllergyDr)),"^",2)
		
	}
	
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
	
	//病症体征
	s RowId=0
	s key0=""
	for
	{
		s RowId=$o(^DHCPHSYM(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s PSYMKeyWordDr=$p(^DHCPHSYM(RowId),"^",2)
		if (PSYMKeyWordDr'="") 
		{
			if (key0'="")
			{
				s key0 = key0_"/"_$p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
			else
			{
				s key0 = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
		} 
	}
	
	//治疗手术
	s RowId=0
	s key1=""
	for
	{
		s RowId=$o(^DHCPHCU(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s PDCUKeyWordDr=$p(^DHCPHCU(RowId),"^",2)
		if (PDCUKeyWordDr'="") 
		{
			if (key1'="")
			{
				s key1 = key1_"/"_$p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
			else
			{
				s key1 = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
	
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_type_"&%"_dis_"&%"_age_"&%"_agelimit_"&%"_sex_"&%"_popu_"&%"_allergy_"&%"_PHINSTText_"&%"_mode_"&%"_key0_"&%"_key1
	q str
}

}
