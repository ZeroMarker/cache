/// 名称:基础数据平台组知识库数据导出。 
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期:2018-3-13
Class web.DHCBL.BDP.ExportLABData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.DHCBL.BDP.ExportLABData).GetSSUserTitle()
ClassMethod GetTitle(table As %String) As %String
{
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
		s str="分类代码&%分类描述&%知识库标识&%上级分类&%级别&%是否可用&%是否系统标识"
	}
	if (table="5") 
	{
		s str="HIS库诊断代码&%HIS库诊断描述&%知识库诊断代码&%知识库诊断描述&%类型&%操作状态&%备注&%关键字"
	}
	if (table="6")
	{
		s str="特殊人群代码&%特殊人群描述"
	}
	if (table="7")
	{
		s str="知识库病症代码&%知识库病症描述&%拼音码&%常用名&%常用名拼音码&%别名&%备注&%知识库icd代码"
	}
	if (table="8")
	{
		s str="年龄代码&%年龄描述&%最小值&%最大值&%单位&%是否可用&%系统标识"
	}
	if (table="9") 
	{
		s str="HIS通用名代码&%HIS通用名描述&%知识库通用名代码&%知识库通用名描述&%知识库标识&%知识库通用名别名&%分类&%标本采集注意事项&%HIS库通用名rowid"
	}
	if (table="10") 
	{
		s str="HIS通用名代码&%HIS通用名描述&%知识库通用名代码&%知识库通用名描述&%知识库标识&%转换系数&%知识库通用名别名&%标本&%检验标准码&%检验分类&%医嘱类型标识&%HIS库通用名"
	}
	if (table="11") 
	{
		s str="控制级别&%通用名&%标本&%知识库病症&%年龄&%年龄限制&%性别&%特殊人群&%描述说明&%提示（医生）&%备注"
	}
	if (table="12") 
	{
		s str="控制级别&%通用名&%标本&%类型&%知识库病症&%年龄&%年龄限制&%性别&%特殊人群&%描述说明&%提示（医生）&%备注"
	}
	if (table="13") 
	{
		s str="控制级别&%通用名&%标本&%存在相互作用通用名&%存在相互作用分类&%本文描述"
	}
	if (table="14")
	{
		s str="通用名&%标本&%临床意义"
	}
	if (table="15")
	{
		s str="通用名&%标本&%注意事项"
	}
	
	if (table="16") 
	{
		s str="检验项目通用名&%标本&%正常范围值&%结果值升高&%结果值降低&%结果值阴性&%结果值阳性&%结果值其他&%文本描述"
	}
	q str
}

/// w ##class(web.DHCBL.BDP.ExportLABData).GetCount("SS_User")
ClassMethod GetCount(table) As %String
{
	s rs=""
	if (table="2")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLibaryLabelCount()
	}
	if (table="3")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetInstLabelCount()
	}
	if (table="4")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLibCatCount()
	}
	if (table="5")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetIcdCount()
	}
	if (table="6")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetSpecialPopuCount()
	}
	if (table="7")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetDiseaseListCount()
	}
	if (table="8")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetAgeCount()
	}
	if (table="9")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetSPECGenericCount()
	}
	if (table="10")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLABGenericCount()
	}
	if (table="11")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetDiseaseIndCount()
	}
	if (table="12")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetDiseaseConCount()
	}
	if (table="13")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetDisInteractCount()
	}
	if (table="14")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetClinicalCount()
	}
	if (table="15")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLABMHACount()
	}
	if (table="16")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLabResultDiagCount()
	}
	
	q rs
}

/// w ##class(web.DHCBL.BDP.ExportLABData).GetName("SS_User")
ClassMethod GetName(table) As %String
{
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
		s rs="分类类型字典"
	}
	if (table="5")
	{
		s rs="诊断字典对照"
	}
	if (table="6")
	{
		s rs="特殊人群字典"
	}
	if (table="7")
	{
		s rs="病症"
	}
	if (table="8")
	{
		s rs="年龄字典"
	}
	if (table="9")
	{
		s rs="通用名（检验标本）"
	}
	if (table="10")
	{
		s rs="通用名（检验项目）"
	}
	if (table="11")
	{
		s rs="适应症"
	}
	if (table="12")
	{
		s rs="禁忌症"
	}
	if (table="13")
	{
		s rs="相互作用"
	}
	if (table="14")
	{
		s rs="临床意义"
	}
	if (table="15")
	{
		s rs="注意事项"
	}
	if (table="16")
	{
		s rs="检验结果辅助诊断"
	}
	
	q rs
}

/// w ##class(web.DHCBL.BDP.ExportLABData).GetInfo("SS_User",3)
ClassMethod GetInfo(table, i) As %String
{
	s rs=""
	if (table="2")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLibaryLabelInfo(i)
	}
	if (table="3")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetInstLabelInfo(i)
	}
	if (table="4")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLibCatInfo(i)
	}
	if (table="5")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetIcdInfo(i)
	}
	if (table="6")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetSpecialPopuInfo(i)
	}
	if (table="7")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetDiseaseListInfo(i)
	}
	if (table="8")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetAgeInfo(i)
	}
	if (table="9")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetSPECGenericInfo(i)
	}
	if (table="10")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLABGenericInfo(i)
	}
	if (table="11")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetDiseaseIndInfo(i)
	}
	if (table="12")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetDiseaseConInfo(i)
	}
	if (table="13")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetDisInteractInfo(i)
	}
	if (table="14")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetClinicalInfo(i)
	}
	if (table="15")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLABMHAInfo(i)
	}
	if (table="16")
	{
		s rs=##class(web.DHCBL.BDP.ExportLABData).GetLabResultDiagInfo(i)
	}
	q rs
}

/// 知识库标识字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetLibaryLabelCount()
ClassMethod GetLibaryLabelCount() As %String
{
	k ^TMPKBCOUNT("DHCPHLibaryLabel")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCPHLIBL(id)) q:id=""
		s PHLICode=$p($g(^DHCPHLIBL(id)),"^",1)       //工号
		continue:PHLICode=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHLibaryLabel",count)=id
	}	
	q count
}

/// 知识库标识字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetLibaryLabelInfo("2")
ClassMethod GetLibaryLabelInfo(i) As %String
{
	n (i)
	s str=""
	S PHLIRowId=$g(^TMPKBCOUNT("DHCPHLibaryLabel",i))
	q:(PHLIRowId="") ""
	s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
	s PHLIDesc=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
	s PHLIActiveFlag=$p($g(^DHCPHLIBL(PHLIRowId)),"^",3)
		
  	s str=PHLICode_"&%"_PHLIDesc_"&%"_PHLIActiveFlag
	q str
}

/// 知识库目录字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetInstLabelCount()
ClassMethod GetInstLabelCount() As %String
{
	k ^TMPKBCOUNT("DHCPHInstLabel")
    s count=0
	s id=0,PINLCode=""
	for {
		s id=$o(^DHCPHPINL(id)) q:id=""
		s PINLCode=$p($g(^DHCPHPINL(id)),"^",1)       //工号
		continue:PINLCode=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHInstLabel",count)=id
	}	
	q count
}

/// 知识库目录字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetLibaryLabelInfo("2")
ClassMethod GetInstLabelInfo(i) As %String
{
	n (i)
	s str=""
	S PINLRowID=$g(^TMPKBCOUNT("DHCPHInstLabel",i))
	q:(PINLRowID="") ""
	s PINLCode=$p($g(^DHCPHPINL(PINLRowID)),"^",1)
	s PINLDesc=$p($g(^DHCPHPINL(PINLRowID)),"^",2)
	s PINLOrderNum=$p($g(^DHCPHPINL(PINLRowID)),"^",3)
	s PINLManageMode=$p($g(^DHCPHPINL(PINLRowID)),"^",4)
	s PINLIcon=$p($g(^DHCPHPINL(PINLRowID)),"^",6)
	s PINLAllFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",7)
	s PHLIRowId=$p($g(^DHCPHPINL(PINLRowID)),"^",5)
	i PHLIRowId'="" {
		s PINLLabelDr=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
	}
	else {
		s PINLLabelDr=""
	}
	s PINLAlertMsg=$p($g(^DHCPHPINL(PINLRowID)),"^",8)
	s PINLGenFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",9)
	s PINLProFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",10)
		
  	s str=PINLCode_"&%"_PINLDesc_"&%"_PINLLabelDr_"&%"_PINLOrderNum_"&%"_PINLManageMode_"&%"_PINLIcon_"&%"_PINLAllFlag_"&%"_PINLAlertMsg_"&%"_PINLGenFlag_"&%"_PINLProFlag
	q str
}

/// 分类类型字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetLibCatCount()
ClassMethod GetLibCatCount() As %String
{
	k ^TMPKBCOUNT("DHCPHLibCat")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^User.DHCPHLibCatD(id)) q:id=""
		s Code=$listGet($g(^User.DHCPHLibCatD(id)),2)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHLibCat",count)=id
	}	
	q count
}

/// 分类类型字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetLibCatInfo("2")
ClassMethod GetLibCatInfo(i) As %String
{
	n (i)
	s str=""
	S myRowID=$g(^TMPKBCOUNT("DHCPHLibCat",i))
	q:(myRowID="") ""
	s PHICCode=$listGet($g(^User.DHCPHLibCatD(myRowID)),2)
	s PHICDesc=$listGet($g(^User.DHCPHLibCatD(myRowID)),3)
	s PHICLastLevel=$listGet($g(^User.DHCPHLibCatD(myRowID)),4)
	s:PHICLastLevel'="" PHICLastLevel=$listGet($g(^User.DHCPHLibCatD(PHICLastLevel)),3)
	s PHICLevel=$listGet($g(^User.DHCPHLibCatD(myRowID)),5)
	s PHICLibDr=$listGet($g(^User.DHCPHLibCatD(myRowID)),6)
	s:PHICLibDr'="" PHICLibDr=$p($g(^DHCPHLIBL(PHICLibDr)),"^",2)
	s PHICActiveFlag=$listGet($g(^User.DHCPHLibCatD(myRowID)),7)
	s PHICSysFlag=$listGet($g(^User.DHCPHLibCatD(myRowID)),8)
			
  	s str=PHICCode_"&%"_PHICDesc_"&%"_PHICLibDr_"&%"_PHICLastLevel_"&%"_PHICLevel_"&%"_PHICActiveFlag_"&%"_PHICSysFlag
	q str
}

/// 诊断字典
/// w ##class(web.DHCBL.BDP.ExportLABData).GetIcdCount()
ClassMethod GetIcdCount() As %String
{
	k ^TMPKBCOUNT("DHCExtIcdFeild")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCEXTICD(id)) q:id=""
		s Code=$p($g(^DHCEXTICD(id)),"^",1)       //工号
		continue:Code=""
		if ($d(^DHCEXTICON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCEXTICON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCEXTICON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCExtIcdFeild",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCExtIcdFeild",count)=id
		}

	}	
	q count
}

/// 诊断字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetIcdInfo("2")
ClassMethod GetIcdInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCExtIcdFeild",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCEXTICD(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCEXTICD(rowId)),"^",2)  //描述
	
	//2类型（ICD9/ICD10/非ICD）
	s type=$p($g(^DHCEXTICD(rowId)),"^",3)
	s:type=9 type="ICD9"
	s:type=10 type="ICD10"
	s:type=99 type="非ICD"
	if ((type'="ICD9")&(type'="ICD10")&(type'="非ICD")&(type'="")){
		s type="ICD10"
	}
	//操作状态（放弃/确认）
	s OpStatus=$p($g(^DHCEXTICD(rowId)),"^",6)
	s:OpStatus=0 OpStatus="放弃"
	s:OpStatus=1 OpStatus="确认"
	if ((OpStatus'="放弃")&(OpStatus'="确认")&(OpStatus'="")){
		s OpStatus=""
	} 
	
	s ICDRemark=$p($g(^DHCEXTICD(rowId)),"^",7)
	s text ="",ICDText=""
	for {
		s text=$o(^DHCEXTICDKi(0,"ICDText",rowId,text)) q:text=""  
		s:ICDText'="" ICDText=ICDText_"#&"_text
		s:ICDText="" ICDText=text
	}	
  	s str="&%&%"_code_"&%"_desc_"&%"_type_"&%"_OpStatus_"&%"_ICDRemark_"&%"_ICDText
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCEXTICON(conid)),"^",2)
	  	s hisdesc=$p($g(^DHCEXTICON(conid)),"^",3)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc_"&%"_type_"&%"_OpStatus_"&%"_ICDRemark_"&%"_ICDText
	
  	}
	q str
}

/// 特殊人群字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetSpecialPopuCount()
ClassMethod GetSpecialPopuCount() As %String
{
	k ^TMPKBCOUNT("DHCSpecialPopu")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCSPEP(id)) q:id=""
		s Code=$p($g(^DHCSPEP(id)),"^",1)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCSpecialPopu",count)=id
	}	
	q count
}

/// 特殊人群字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetSpecialPopuInfo("2")
ClassMethod GetSpecialPopuInfo(i) As %String
{
	n (i)
	s str=""
	S SPERowId=$g(^TMPKBCOUNT("DHCSpecialPopu",i))
	q:(SPERowId="") ""
	s SPECode=$p($g(^DHCSPEP(SPERowId)),"^",1)
	s SPEDesc=$p($g(^DHCSPEP(SPERowId)),"^",2)
		
  	s str=SPECode_"&%"_SPEDesc
	q str
}

/// 病症字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetDiseaseListCount()
ClassMethod GetDiseaseListCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDiseaseList")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHDISL(id)) q:id=""
		s Code=$p($g(^DHCPHDISL(id)),"^",1)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHDiseaseList",count)=id
	}	
	q count
}

/// 病症字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetDiseaseListInfo("2")
ClassMethod GetDiseaseListInfo(i) As %String
{
	n (i)
	s str=""
	S PHDISLRowId=$g(^TMPKBCOUNT("DHCPHDiseaseList",i))
	q:(PHDISLRowId="") ""
	s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
	s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
	s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
	s PHDISLSysFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",4)
	s PHDISLRemark=$p($g(^DHCPHDISL(PHDISLRowId)),"^",5)
	s keyid=$o(^DHCPHDISKEYi(0,"Dis","M",PHDISLRowId,0))
	s PHDISLKey=""
	s:keyid'="" PHDISLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)
	s strAlias=##class(web.DHCBL.KB.DHCPHDiseaseList).GetComOrAlias(PHDISLRowId,"A")
	s PHDISLAlias=$p(strAlias,"||",1)
	s PHDISLAlias=$tr(PHDISLAlias,",","#&")
	s aliasKey=$p(strAlias,"||",2)
	s strCom=##class(web.DHCBL.KB.DHCPHDiseaseList).GetComOrAlias(PHDISLRowId,"C")
	s PHDISLCom=$p(strCom,"||",1)
	s PHDISLCom=$tr(PHDISLCom,",","#&")
	s comKey=$p(strCom,"||",2)	
	s comKey=$tr(comKey,",","#&")
	
	//关联的诊断
	s ICDCodeStr=""
	s DisRowId=PHDISLRowId,PHDISLIChildsub=0
	for {
		S PHDISLIChildsub=$o(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)) q:PHDISLIChildsub=""
		s PHDISLIRowId=DisRowId_"||"_PHDISLIChildsub
		s ICDRowId=$p($g(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)),"^",1)
		i ICDRowId'="" 
		{
			s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
		}
		else 
		{
			s ICDCode=""
		}
		if (PHDISLIChildsub>0)&(ICDCode'="")
		{
			s:ICDCodeStr'="" ICDCodeStr=ICDCodeStr_"#&"_ICDCode
			s:ICDCodeStr="" ICDCodeStr=ICDCode
		}
		
	}
  	s str=PHDISLDiseaCode_"&%"_PHDISLDiseaDesc_"&%"_PHDISLKey_"&%"_PHDISLCom_"&%"_comKey_"&%"_PHDISLAlias_"&%"_PHDISLRemark_"&%"_ICDCodeStr
	q str
}

/// 年龄字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetAgeCount()
ClassMethod GetAgeCount() As %String
{
	k ^TMPKBCOUNT("DHCPHPatAgeList")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHPAGEL(id)) q:id=""
		s Code=$p($g(^DHCPHPAGEL(id)),"^",1)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHPatAgeList",count)=id
	}	
	q count
}

/// 年龄字典
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetAgeInfo("2")
ClassMethod GetAgeInfo(i) As %String
{
	n (i)
	s str=""
	S PDARowID=$g(^TMPKBCOUNT("DHCPHPatAgeList",i))
	q:(PDARowID="") ""
	s PDAAgeCode=$p($g(^DHCPHPAGEL(PDARowID)),"^",1)
	s PDAAgeDesc=$p($g(^DHCPHPAGEL(PDARowID)),"^",2)
	s PDAAgeMin=$p($g(^DHCPHPAGEL(PDARowID)),"^",3)
	s PDAAgeMax=$p($g(^DHCPHPAGEL(PDARowID)),"^",4)
	s PDAActiveFlag=$p($g(^DHCPHPAGEL(PDARowID)),"^",5)
	s PDASysFlag=$p($g(^DHCPHPAGEL(PDARowID)),"^",6)
	s UomRowId=$p($g(^DHCPHPAGEL(PDARowID)),"^",7)
	i UomRowId'="" {
		s PDAUomDr=$p($g(^DHCPHEUO(UomRowId)),"^",2)
	}
	else {
		s PDAUomDr=""
	}
  	s str=PDAAgeCode_"&%"_PDAAgeDesc_"&%"_PDAAgeMin_"&%"_PDAAgeMax_"&%"_PDAUomDr_"&%"_PDAActiveFlag_"&%"_PDASysFlag
	q str
}

/// 通用名（检验标本）
/// w ##class(web.DHCBL.BDP.ExportLABData).GetSPECGenericCount()
ClassMethod GetSPECGenericCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtSPECGeneric")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHEGEN(id)) q:id=""
		s Code=$p($g(^DHCPHEGEN(id)),"^",1)       //工号
		s lib=""
		s PHEGLibDr=$p($g(^DHCPHEGEN(id)),"^",7) 
		s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
		continue:Code=""
		continue:lib'="检验标本"
		if ($d(^DHCPHGENCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHGENCON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHGENCON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHExtSPECGeneric",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHExtSPECGeneric",count)=id
		}

	}	
	q count
}

/// 通用名（检验标本）
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetSPECGenericInfo("1")
ClassMethod GetSPECGenericInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHExtSPECGeneric",i))
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
			s keys=keys_"#&"_$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)
		}
		else
		{
			s keys=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)
		}		
	}
	
	
	//分类^User.DHCPHLibCatD
	s LSCRowId=$o(^DHCLSCCARE(0,"Gen",rowId,0))
	s LSCCatDr=""
	s:LSCRowId'="" LSCCatDr=$p($g(^DHCLSCCARE(LSCRowId)),"^",2)
	s type=""
	s:LSCCatDr'="" type=$listGet($g(^User.DHCPHLibCatD(LSCCatDr)),3)
	//标本采集注意事项
	s care=""
	s:LSCRowId'="" care=$p($g(^DHCLSCCARE(LSCRowId)),"^",3)
	
		
  	s str="&%&%"_code_"&%"_desc_"&%"_lib_"&%"_keys_"&%"_type_"&%"_care_"&%"_conid
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHGENCON(conid)),"^",2)
	  	s hisdesc=$p($g(^DHCPHGENCON(conid)),"^",3)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc_"&%"_lib_"&%"_keys_"&%"_type_"&%"_care_"&%"_conid
	
  	}
	q str
}

/// 通用名（检验项目）
/// w ##class(web.DHCBL.BDP.ExportLABData).GetLABGenericCount()
ClassMethod GetLABGenericCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtLABGeneric")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHEGEN(id)) q:id=""
		s Code=$p($g(^DHCPHEGEN(id)),"^",1)       //工号
		s lib=""
		s PHEGLibDr=$p($g(^DHCPHEGEN(id)),"^",7) 
		s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
		continue:Code=""
		continue:lib'="检验项目"
		if ($d(^DHCPHGENCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHGENCON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHGENCON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHExtLABGeneric",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHExtLABGeneric",count)=id
		}

	}	
	q count
}

/// 通用名（检验项目）
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetLABGenericInfo("1")
ClassMethod GetLABGenericInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHExtLABGeneric",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHEGEN(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHEGEN(rowId)),"^",2)  //描述
	
	//知识库标识
	s lib=""
	s PHEGLibDr=$p($g(^DHCPHEGEN(rowId)),"^",7) 
	s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
	s turn=""
	s keys=""  //通用名别名
	s PHEGAlRowId=0
	for  
	{	
		s PHEGAlRowId=$o(^DHCPHEGALi(0,"Gen",rowId,PHEGAlRowId)) q:PHEGAlRowId="" 
		if (keys'="") 
		{
			s keys=keys_"#&"_$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)
		}
		else
		{
			s keys=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)
		}		
	}
	//标本
	s GlPRowId=$o(^DHCGENLINPi(0,"Gen",rowId,0))
	s GlPPointer=""
	s:GlPRowId'="" GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)
	s spec=""
	s:GlPPointer'="" spec=$p($g(^DHCPHEGEN(GlPPointer)),"^",2)
	
	//分类^User.DHCPHLibCatD
	s LGPRowId=$o(^DHCLISGPi(0,"Gen",rowId,0))
	s LGPCatDr=""
	s:LGPRowId'="" LGPCatDr=$p($g(^DHCLISGP(LGPRowId)),"^",3)
	s type=""
	s:LGPCatDr'="" type=$listGet($g(^User.DHCPHLibCatD(LGPCatDr)),3)
	
	//ATC编码
	s atc=""
	s:LGPRowId'="" atc=$p($g(^DHCLISGP(LGPRowId)),"^",2)
	
	//医嘱类型识别LGPOTFlag
	s LGPOTFlag="",otflag=""
	s:LGPRowId'="" LGPOTFlag=$p($g(^DHCLISGP(LGPRowId)),"^",5)
	if (LGPOTFlag'="")
	{
		//医嘱类型标识（,医嘱项,医嘱套） 
		s:LGPOTFlag="TS" otflag="医嘱套" 
		s:LGPOTFlag="TC" otflag="医嘱项" 
	}	
  	s str="&%&%"_code_"&%"_desc_"&%"_lib_"&%"_turn_"&%"_keys_"&%"_spec_"&%"_atc_"&%"_type_"&%"_otflag_"&%"_conid
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHGENCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHGENCON(conid)),"^",4)
	  	s turn=$p($g(^DHCPHGENCON(conid)),"^",9)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc_"&%"_lib_"&%"_turn_"&%"_keys_"&%"_spec_"&%"_atc_"&%"_type_"&%"_otflag_"&%"_conid
	
  	}
	q str
}

/// 适应症
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetDiseaseIndCount()
ClassMethod GetDiseaseIndCount() As %String
{
	k ^TMPKBCOUNT("DHCLABDiseaseInd")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="LabIndic") ;适应症
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCLABDiseaseInd",count)=id_"^"_PHINSTRowId
			}
				
		}
	
		
	}	
	q count
}

/// 适应症
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetDiseaseIndInfo("1")
ClassMethod GetDiseaseIndInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCLABDiseaseInd",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //标本DR
		
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCLABDiseaseInd",i)),"^",2)	
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
	s PHEFDesc=$p($g(^DHCPHEGEN(GlPPointer)),"^",2)          //标本
	
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
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_"#&"_dis
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
		 
		//年龄限制
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
				s popu = $p($g(^DHCSPEP(SPEPISpecDr)),"^",2)_"#&"_popu
			}
			else
			{
				s popu = $p($g(^DHCSPEP(SPEPISpecDr)),"^",2)
			}
		}	
	}
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
	
	//提示（医生）
	s PHINSTDocUseTips=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",11)
	
	//备注
	s PHINSTNote=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",12)
	
	
		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_dis_"&%"_age_"&%"_agelimit_"&%"_sex_"&%"_popu_"&%"_PHINSTText_"&%"_PHINSTDocUseTips_"&%"_PHINSTNote
	q str
}

/// 禁忌症
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetDiseaseConCount()
ClassMethod GetDiseaseConCount() As %String
{
	k ^TMPKBCOUNT("DHCLABDiseaseCon")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="LabContr") ;禁忌症
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCLABDiseaseCon",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 禁忌症
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetDiseaseConInfo("1")
ClassMethod GetDiseaseConInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCLABDiseaseCon",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //标本DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCLABDiseaseCon",i)),"^",2)	
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
	s PHEFDesc=$p($g(^DHCPHEGEN(GlPPointer)),"^",2)          //标本
	
	//禁忌症、病症
	s dis=""
	s PHDDRowId=0
	s dis="",type=""
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",PHINSTRowId,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (dis'="")
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_"#&"_dis
			}
			else
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
		//类型
		s PHDDType=$p($g(^DHCPHDDIS(PHDDRowId)),"^",6)
		s:PHDDType="F" type="禁用" 
		s:PHDDType="C" type="慎用" 
		if ((type'="禁用")&(type'="慎用"))
		{
			s type="禁用"
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
				s popu = $p($g(^DHCSPEP(SPEPISpecDr)),"^",2)_"#&"_popu
			}
			else
			{
				s popu = $p($g(^DHCSPEP(SPEPISpecDr)),"^",2)
			}
		}	
	}
	
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
	
	//提示（医生）
	s PHINSTDocUseTips=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",11)
	
	//备注
	s PHINSTNote=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",12)
	
		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_type_"&%"_dis_"&%"_age_"&%"_agelimit_"&%"_sex_"&%"_popu_"&%"_PHINSTText_"&%"_PHINSTDocUseTips_"&%"_PHINSTNote
	q str
}

/// 相互作用
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetDisInteractCount()
ClassMethod GetDisInteractCount() As %String
{
	k ^TMPKBCOUNT("DHCLABDiseaseInteract")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="LabInterEach") ;相互作用
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCLABDiseaseInteract",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 相互作用
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetDisInteractInfo("1")
ClassMethod GetDisInteractInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCLABDiseaseInteract",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //标本DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCLABDiseaseInteract",i)),"^",2)	
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
	s PHEFDesc=$p($g(^DHCPHEGEN(GlPPointer)),"^",2)          //标本
	
	
	//
	s PDINTRowId=$o(^DHCPHDINTER(0,"Inst",PHINSTRowId,0))
	s igen="",iflag=""
	if (PDINTRowId'="")
	{
		//存在相互作用通用名
		s PDINTGenDr = $p($g(^DHCPHDINTER(PDINTRowId)),"^",2)
		s:PDINTGenDr'="" igen=$p($g(^DHCPHEGEN(PDINTGenDr)),"^",2)
		
		
		
	}
	
	//存在相互作用分类
	s CATICatDr="",itype=""
	s CATIRowId=$o(^DHCLIBCATI("0","Inst",PHINSTRowId,0))
	s:CATIRowId'="" CATICatDr=$p($g(^DHCLIBCATI(CATIRowId)),"^",2)
	s:CATICatDr'="" itype=$listGet($g(^User.DHCPHLibCatD(CATICatDr)),3)
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_igen_"&%"_itype_"&%"_PHINSTText
  	q str
}

/// 注意事项
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetLABMHACount()
ClassMethod GetLABMHACount() As %String
{
	k ^TMPKBCOUNT("DHCPHDMHA")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="LabMatNeAt") ;注意事项
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDMHA",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 注意事项
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetLABMHAInfo("1")
ClassMethod GetLABMHAInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDMHA",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHDMHA",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEGEN(GlPPointer)),"^",2)          //剂型
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHINSTText
  	q str
}

/// 临床意义
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetClinicalCount()
ClassMethod GetClinicalCount() As %String
{
	k ^TMPKBCOUNT("DHCLABClinical")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="LabClinical") ;不良反应
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCLABClinical",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 临床意义
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetClinicalInfo("1")
ClassMethod GetClinicalInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCLABClinical",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCLABClinical",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHINSTText
  	q str
}

/// 检验结果辅助诊断
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetLabResultDiagCount()
ClassMethod GetLabResultDiagCount() As %String
{
	k ^TMPKBCOUNT("DHCLabResultDiag")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="LabResultDiag") ;检验结果辅助诊断
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCLabResultDiag",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 检验结果辅助诊断
/// /w ##class(web.DHCBL.BDP.ExportLABData).GetLabResultDiagInfo("1")
ClassMethod GetLabResultDiagInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCLabResultDiag",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //标本DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCLabResultDiag",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEGEN(GlPPointer)),"^",2)          //标本
	
	s PLRDRowId=$o(^DHCPHLRD(0,"Inst",PHINSTRowId,0))
	s PLRDNormal="",PLRDHigh="",PLRDLow="",PLRDNegative="",PLRDPositive="",PLRDOther=""
	if (PLRDRowId'="")
	{
		s PLRDNormal=$p($g(^DHCPHLRD(PLRDRowId)),"^",2)
		s PLRDHigh=$p($g(^DHCPHLRD(PLRDRowId)),"^",3)
		s PLRDLow=$p($g(^DHCPHLRD(PLRDRowId)),"^",4)
		s PLRDNegative=$p($g(^DHCPHLRD(PLRDRowId)),"^",5)
		s PLRDPositive=$p($g(^DHCPHLRD(PLRDRowId)),"^",6)
		s PLRDOther=$p($g(^DHCPHLRD(PLRDRowId)),"^",7)	
	}
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PLRDNormal_"&%"_PLRDHigh_"&%"_PLRDLow_"&%"_PLRDNegative_"&%"_PLRDPositive_"&%"_PLRDOther_"&%"_PHINSTText
  	q str
}

}
