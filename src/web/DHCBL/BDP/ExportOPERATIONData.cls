/// 名称:基础数据平台组手术知识库数据导出。 
/// 编写者:基础数据平台组 - 谷雪萍
/// 编写日期:2020-5-7
Class web.DHCBL.BDP.ExportOPERATIONData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:谷雪萍
/// CreatDate: 2020-05-07
/// Description：获取每个表的标题行
/// Input: table-模板中第几个sheet
/// Return:str-标题串
/// w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetTitle(2)
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
	if (table="4")  //检查部位字典
	{
		s str="HIS库通用名代码&%HIS库通用名描述&%知识库通用名代码&%知识库通用名描述"
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
	if (table="10")  //通用名（手术）
	{
		s str="HIS通用名代码&%HIS通用名描述&%知识库通用名代码&%知识库通用名描述&%知识库标识&%知识库通用名别名&%部位"
	}
	if (table="11") //通用名（检验项目）
	{
		s str="HIS通用名代码&%HIS通用名描述&%知识库通用名代码&%知识库通用名描述&%知识库标识&%转换系数&%知识库通用名别名&%标本&%检验标准码&%检验分类&%医嘱类型标识&%HIS库通用名"
	}
	if (table="12") //通用名（检查项目）
	{
		s str="HIS通用名代码&%HIS通用名描述&%知识库通用名代码&%知识库通用名描述&%知识库标识&%知识库通用名别名&%部位"
	}
	if (table="13") //通用名（检查测值）
	{
		s str="HIS通用名代码&%HIS通用名描述&%知识库通用名代码&%知识库通用名描述&%知识库标识&%知识库通用名别名"
	}
	if (table="14") //高危提醒
	{
		s str="控制级别&%手术知识库通用名&%部位&%知识库病症&%年龄&%年龄限制&%BMI&%收缩压&%舒张压&%特殊人群&%描述说明"
	}
	if (table="15") //术前检验
	{
		s str="控制级别&%手术知识库通用名&%部位&%年龄&%年龄限制&%检验项目&%是否为报告状态&%描述说明"
	}
	if (table="16") //术前检验质控
	{
		s str="控制级别&%手术知识库通用名&%部位&%年龄&%年龄限制&%检验质控项目名称&%检验质控项目逻辑&%检验质控项目数值&%检验质控项目数值单位&%描述说明"
	}
    if (table="17") //术前检查
	{
		s str="控制级别&%手术知识库通用名&%部位&%年龄&%年龄限制&%检查项目&%是否为报告状态&%描述说明"
	}
	if (table="18") //术前检查质控
	{
		s str="控制级别&%手术知识库通用名&%部位&%年龄&%年龄限制&%检查质控项目名称&%检查质控项目逻辑&%检查质控项目数值&%检查质控项目数值单位&%描述说明"
	}
	q str
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-07
/// Description：获取每个表的数据总量
/// Input: table-模板中第几个sheet
/// Return:rs-数据总量
/// w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetCount("2")
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
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetPartCount()
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
	if (table="10")  //通用名（手术）
	{
		s rs=..GetOperationCount()
	}
	if (table="11") //通用名（检验项目）
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLABGenericCount()
	}
	if (table="12") //通用名（检查项目）
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetGenericCount()
	}
	if (table="13") //通用名（检查测值）
	{
		s rs=..GetGenericCount("CheckValues")
	}
	if (table="14") //高危提醒
	{
		s rs=..GetBusCount("OPERATION","OPERRemind")	
	}
	if (table="15") //术前检验
	{
		s rs=..GetBusCount("OPERATION","PreoperLab")	
	}
	if (table="16") //术前检验质控
	{
		s rs=..GetBusCount("OPERATION","PreoperLabContr")	
	}
    if (table="17") //术前检查
	{
		s rs=..GetBusCount("OPERATION","PreoperCheck")	
	}
	if (table="18") //术前检查质控
	{
		s rs=..GetBusCount("OPERATION","PreoperCheckContr")	
	}

	q rs
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-07
/// Description：获取导出的表名
/// Input: table-模板中第几个sheet
/// Return:rs-表名
/// w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetName("2")
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
		s rs="检查部位字典"
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
		s rs="通用名（手术）"
	}
	if (table="11") 
	{
		s rs="通用名（检验项目）"
	}
	if (table="12")
	{
		s rs="通用名（检查项目）"
	}
	if (table="13")
	{
		s rs="通用名（检查测值）"
	}
	if (table="14")
	{
		s rs="高危提醒"
	}
	if (table="15")
	{
		s rs="术前检验"
	}
	if (table="16")
	{
		s rs="术前检验质控"
	}
    if (table="17") 
	{
		s rs="术前检查"	
	}
	if (table="18") 
	{
		s rs="术前检查质控"
	}	
	
	q rs
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-07
/// Description：获取每行数据
/// Input: table-模板中第几个sheet
/// Return:i-第几行数据
/// w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetInfo("2","1")
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
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetPartInfo(i)
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
	if (table="10")  //通用名（手术）
	{
		s rs=..GetOperationInfo(i)
	}
	if (table="11") //通用名（检验项目）
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLABGenericInfo(i)
	}
	if (table="12") //通用名（检查项目）
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetGenericInfo(i)
	}
	if (table="13") //通用名（检查测值）
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetGenericInfo(i)
	}
	if (table="14") //高危提醒
	{
		s rs=..GetOPERRemindInfo("OPERRemind",i)	
	}
	if (table="15") //术前检验
	{
		s rs=..GetPreoperLabInfo("PreoperLab",i)	
	}
	if (table="16") //术前检验质控
	{
		s rs=..GetPreoperLabContrInfo("PreoperLabContr",i)	
	}
    if (table="17") //术前检查
	{
		s rs=..GetPreoperLabInfo("PreoperCheck",i)
	}
	if (table="18") //术前检查质控
	{
		s rs=..GetPreoperLabContrInfo("PreoperCheckContr",i)
	}
	q rs
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-07
/// Description：获取通用名数据总数
/// Input: LibaryCode-知识库标识字典代码
/// Return:count-数据总数
/// Others:w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetGenericCount("TREAT")
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
/// CreatDate: 2020-05-07
/// Description：获取手术通用名数据总数
/// Input: LibaryCode-知识库标识字典代码
/// Return:count-数据总数
/// Others:w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetOperationCount()
ClassMethod GetOperationCount() As %String
{
	n (LibaryCode)
	k ^TMPKBCOUNT("DHCPHExtGeneric")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHEGEN(id)) q:id=""
		s Code=$p($g(^DHCPHEGEN(id)),"^",1)       //工号
		s lib=""
		s PHEGLibDr=$p($g(^DHCPHEGEN(id)),"^",7) 
		s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1)  //知识库标识代码

		continue:Code=""
		continue:(lib'="OPERATION")

		if ($d(^DHCPHOPCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHOPCON("0","Code",Code,hiscode)) q:hiscode="" 
				s conid=""
				for
				{
					s conid=$o(^DHCPHOPCON("0","Code",Code,hiscode,conid)) q:conid=""
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
/// CreatDate: 2020-05-07
/// Description：获取手术通用名每行数据
/// Input: i-第几条数据
/// Return:hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc_"&%"_lib_"&%"_keys_"&%"_part
/// Others:w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetOperationInfo(i)
ClassMethod GetOperationInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHExtGeneric",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHEGEN(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHEGEN(rowId)),"^",2)  //描述
	
	//知识库标识
	s lib=""
	s PHEGLibDr=$p($g(^DHCPHEGEN(rowId)),"^",7) 
	s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
	
	s keys=""  //通用名别名
	s PHEGAlRowId=0
	for  
	{	
		s PHEGAlRowId=$o(^DHCPHEGALi(0,"Gen",rowId,PHEGAlRowId)) q:PHEGAlRowId="" 
		if (keys'="") 
		{
			s keys=keys_"/"_$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)
		}
		else
		{
			s keys=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)
		}		
	}
	
	
	//部位
	s GlPRowId=$o(^DHCGENLINPi(0,"Gen",rowId,0))
	s GlPPointer=""
	s:GlPRowId'="" GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)
	s part=""
	s:GlPPointer'="" part=$p($g(^DHCPHEPA(GlPPointer)),"^",2)
	
	
		
  	s str="&%&%"_code_"&%"_desc_"&%"_lib_"&%"_keys_"&%"_part
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHOPCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHOPCON(conid)),"^",4)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc_"&%"_lib_"&%"_keys_"&%"_part
	
  	}
	q str
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-07
/// Description：获取编辑器各项的数据总数
/// Input: LibaryCode-知识库标识字典代码，InstCode-知识库目录字典代码
/// Return:count-数据总数
/// Others:w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetBusCount("OPERATION","OPERRemind")
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
/// CreatDate: 2020-05-07
/// Description：获取高危提醒每行的数据
/// Input: InstCode-知识库目录字典代码
/// Return:"控制级别&%手术知识库通用名&%部位&%知识库病症&%年龄&%年龄限制&%BMI&%收缩压&%舒张压&%特殊人群&%描述说明"
/// Others:w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetOPERRemindInfo("OPERRemind",i)	
ClassMethod GetOPERRemindInfo(InstCode, i) As %String
{
	n (InstCode,i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT(InstCode,i)),"^",1)
	q:GlPRowId="" ""
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	q:GlPGenDr="" ""
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //部位DR
	q:GlPPointer="" ""
		
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
	//BMI	
	s BMIlimit=""
	s PHINSTBMIMin=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",16)
	s PHINSTBMIMax=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",17)
	if (PHINSTBMIMin'="")||(PHINSTBMIMax'="")
	{
		s BMIlimit=PHINSTBMIMin_"-"_PHINSTBMIMax
	}
	
	//通过索引获取生理业务表的RowId——PHYVRowId
	s SBPlimit="" //收缩压
	s DBPlimit="" //舒张压
	s PHYVRowId=0
	for {
		s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",PHINSTRowId,PHYVRowId)) q:PHYVRowId="" 
		s objPhy=##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
		if (objPhy.PHYVType="S")
		{
			s SysPressMinVal=objPhy.PHYVMinVal
			s SysPressMaxVal=objPhy.PHYVMaxVal	
			if (SysPressMinVal'="")||(SysPressMaxVal'="")
			{
				s SBPlimit=SysPressMinVal_"-"_SysPressMaxVal
			}
		}
		else
		{
			s DiaPressMinVal=objPhy.PHYVMinVal
			s DiaPressMaxVal=objPhy.PHYVMaxVal	
			if (DiaPressMinVal'="")||(DiaPressMaxVal'="")	
			{
				s DBPlimit=DiaPressMinVal_"-"_DiaPressMaxVal
			}
		}
		d objPhy.%Close()
		k objPhy	
	}
	
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
	
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_dis_"&%"_age_"&%"_agelimit_"&%"_BMIlimit_"&%"_SBPlimit_"&%"_DBPlimit_"&%"_popu_"&%"_PHINSTText
	q str
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-07
/// Description：获取术前检验/检查每行的数据
/// Input: InstCode-知识库目录字典代码
/// Return:"控制级别&%手术知识库通用名&%部位&%年龄&%年龄限制&%检验项目&%是否为报告状态&%描述说明"
/// Others:w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetPreoperLabInfo("PreoperLab",i)
ClassMethod GetPreoperLabInfo(InstCode, i) As %String
{
	n (InstCode,i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT(InstCode,i)),"^",1)
	q:GlPRowId="" ""
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	q:GlPGenDr="" ""
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //部位DR
	q:GlPPointer="" ""
		
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
	
	;检验指标
	s Lab="",RepFlag=""
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",PHINSTRowId,0))
	if (LABIRowId'="")
	{
		s objlab = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
		if $IsObject(objlab.LABILabDr)
		{
			s LABILabDr = objlab.LABILabDr.%Id()
			s:LABILabDr'="" Lab=$p($g(^DHCPHEGEN(LABILabDr)),"^",2)
		}		
		s RepFlag=objlab.LABIRepActiveFlag
		s:RepFlag="Y" RepFlag="是"
		d objlab.%Close()
		k objlab	
	}	
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_age_"&%"_agelimit_"&%"_Lab_"&%"_RepFlag_"&%"_PHINSTText
	q str
}

/// Creator:谷雪萍
/// CreatDate: 2020-04-29
/// Description：把后台运算符转化为中文
/// Input: LABIRelation-逻辑运算符
/// Return:LABIRelation-逻辑运算符中文
/// Others:w ##class(web.DHCBL.BDP.ImportOPERATIONData).GetLABRelation(dLABIRelation)
ClassMethod GetLABRelation(LABIRelation As %String) As %String
{
	if (LABIRelation=">")
	{
		s LABIRelation="大于"
	}
	elseif(LABIRelation="<")
	{
		s LABIRelation="小于"
	}
	elseif(LABIRelation="=")
	{
		s LABIRelation="等于"
	}
	elseif(LABIRelation="!>")
	{
		s LABIRelation="不大于"
	}
	elseif(LABIRelation="!<")
	{
		s LABIRelation="不小于"
	}
	elseif(LABIRelation="<>")
	{
		s LABIRelation="不等于"
	}
	else
	{
		s LABIRelation=""
	}
	q LABIRelation
}

/// Creator:谷雪萍
/// CreatDate: 2020-05-07
/// Description：获取术前检验/检查质控每行的数据
/// Input: InstCode-知识库目录字典代码
/// Return:"控制级别&%手术知识库通用名&%部位&%年龄&%年龄限制&%检验质控项目名称&%检验质控项目逻辑&%检验质控项目数值&%检验质控项目数值单位&%描述说明"
/// Others:w ##class(web.DHCBL.BDP.ExportOPERATIONData).GetPreoperLabContrInfo("PreoperCheckContr",i)
ClassMethod GetPreoperLabContrInfo(InstCode, i) As %String
{
	n (InstCode,i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT(InstCode,i)),"^",1)
	q:GlPRowId="" ""
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	q:GlPGenDr="" ""
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //部位DR
	q:GlPPointer="" ""
		
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
	
	;检验指标
	s Lab="",LABIRelation="",LABIMinVal="",LABIUomDr=""	
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",PHINSTRowId,0))
	if (LABIRowId'="")
	{
		s objlab = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
		if $IsObject(objlab.LABILabDr)
		{
			s LABILabDr = objlab.LABILabDr.%Id()
			s:LABILabDr'="" Lab=$p($g(^DHCPHEGEN(LABILabDr)),"^",2)
		}
		s LABIMinVal=objlab.LABIMinVal
		s LABIRelation=objlab.LABIRelation
		s:LABIRelation'="" LABIRelation=..GetLABRelation(LABIRelation)
		if $IsObject(objlab.LABIUomDr)
		{
			s LABIUomDr = objlab.LABIUomDr.%Id()
			s:LABIUomDr'="" LABIUomDr=$p($g(^DHCPHEUO(LABIUomDr)),"^",2)
		}
		d objlab.%Close()
		k objlab
		
	}
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_age_"&%"_agelimit_"&%"_Lab_"&%"_LABIRelation_"&%"_LABIMinVal_"&%"_LABIUomDr_"&%"_PHINSTText
	q str
}

}
