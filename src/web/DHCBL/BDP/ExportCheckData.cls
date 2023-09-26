/// 名称:基础数据平台组知识库数据导出。 
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期:2018-2-13
Class web.DHCBL.BDP.ExportCheckData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.DHCBL.BDP.ExportCheckData).GetSSUserTitle()
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
		s str="检查项目通用名&%部位&%知识库标识&%知识库病症&%性别&%描述说明&%控制级别&%病症体征&%治疗手术"
	}
	if (table="13") 
	{
		s str="检查项目通用名&%部位&%知识库标识&%知识库病症&%年龄&%年龄限制&%性别&%特殊人群&%过敏史&%描述说明&%控制级别&%病症体征&%治疗手术"
	}
	if (table="14") 
	{
		s str="检查项目通用名&%部位&%知识库标识&%不良反应"
	}
	if (table="15")
	{
		s str="检查项目通用名&%部位&%知识库标识&%注意事项"
	}
	q str
}

/// w ##class(web.DHCBL.BDP.ExportCheckData).GetCount("SS_User")
ClassMethod GetCount(table) As %String
{
	s rs=""
	if (table="2")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetLibaryLabelCount()
	}
	if (table="3")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetInstLabelCount()
	}
	if (table="4")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetAllergyCount()
	}
	if (table="5")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetIcdCount()
	}
	if (table="6")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetExtUomCount()
	}
	if (table="7")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetSpecialPopuCount()
	}
	if (table="8")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseListCount()
	}
	if (table="9")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetAgeCount()
	}
	if (table="10")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetPartCount()
	}
	if (table="11")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetGenericCount()
	}
	if (table="12")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseIndCount()
	}
	if (table="13")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseConCount()
	}
	if (table="14")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetPHDARCount()
	}
	if (table="15")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetPHDMHACount()
	}

	q rs
}

/// w ##class(web.DHCBL.BDP.ExportCheckData).GetName("SS_User")
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
		s rs="通用名（检验）"
	}
	if (table="12")
	{
		s rs="适应症"
	}
	if (table="13")
	{
		s rs="禁忌症"
	}
	if (table="14")
	{
		s rs="不良反应"
	}
	if (table="15")
	{
		s rs="注意事项"
	}
	
	
	q rs
}

/// w ##class(web.DHCBL.BDP.ExportCheckData).GetInfo("SS_User",3)
ClassMethod GetInfo(table, i) As %String
{
	s rs=""
	if (table="2")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetLibaryLabelInfo(i)
	}
	if (table="3")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetInstLabelInfo(i)
	}
	if (table="4")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetAllergyInfo(i)
	}
	if (table="5")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetIcdInfo(i)
	}
	if (table="6")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetExtUomInfo(i)
	}
	if (table="7")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetSpecialPopuInfo(i)
	}
	if (table="8")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseListInfo(i)
	}
	if (table="9")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetAgeInfo(i)
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
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseIndInfo(i)
	}
	if (table="13")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseConInfo(i)
	}
	if (table="14")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetPHDARInfo(i)
	}
	if (table="15")
	{
		s rs=##class(web.DHCBL.BDP.ExportCheckData).GetPHDMHAInfo(i)
	}

	q rs
}

/// 知识库标识字典
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetLibaryLabelCount()
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
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetLibaryLabelInfo("2")
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
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetInstLabelCount()
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
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetLibaryLabelInfo("2")
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

/// 过敏史字典
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetAllergyCount()
ClassMethod GetAllergyCount() As %String
{
	k ^TMPKBCOUNT("DHCAllergyFeild")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCALLERGY(id)) q:id=""
		s Code=$p($g(^DHCALLERGY(id)),"^",1)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCAllergyFeild",count)=id
	}	
	q count
}

/// 过敏史字典
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetAllergyInfo("2")
ClassMethod GetAllergyInfo(i) As %String
{
	n (i)
	s str=""
	S ALFRowId=$g(^TMPKBCOUNT("DHCAllergyFeild",i))
	q:(ALFRowId="") ""
	s ALFCode=$p($g(^DHCALLERGY(ALFRowId)),"^",1)  //代码
	s ALFDesc=$p($g(^DHCALLERGY(ALFRowId)),"^",2)  //描述
	s keys=""
	s upkey=""
	for  
	{	
		s upkey=$o(^DHCALLGYKEYi(0,"Key",ALFRowId,upkey)) q:upkey="" 
		s idd=$o(^DHCALLGYKEYi(0,"Key",ALFRowId,upkey,0))
		s ALKKey=""
		s:idd'="" ALKKey=$p($g(^DHCALLGYKEY(idd)),"^",2)  //关键字
		i (ALKKey'="")  //条件
		{
			s:keys'="" keys=keys_"#&"_ALKKey
			s:keys="" keys=ALKKey
		}		
	}
  	s str=ALFCode_"&%"_ALFDesc_"&%"_keys
	q str
}

/// 诊断字典
/// w ##class(web.DHCBL.BDP.ExportCheckData).GetIcdCount()
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
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetIcdInfo("2")
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

/// 单位字典
/// w ##class(web.DHCBL.BDP.ExportCheckData).GetExtUomCount()
ClassMethod GetExtUomCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtUom")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHEUO(id)) q:id=""
		s Code=$p($g(^DHCPHEUO(id)),"^",1)       //工号
		continue:Code=""
		if ($d(^DHCPHUOCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHUOCON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHUOCON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHExtUom",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHExtUom",count)=id
		}

	}	
	q count
}

/// 单位字典
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetExtUomInfo("2")
ClassMethod GetExtUomInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHExtUom",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHEUO(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHEUO(rowId)),"^",2)  //描述
  	s str="&%&%"_code_"&%"_desc
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHUOCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHUOCON(conid)),"^",4)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc
	
  	}
	q str
}

/// 特殊人群字典
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetSpecialPopuCount()
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
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetSpecialPopuInfo("2")
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
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseListCount()
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
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseListInfo("2")
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
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetAgeCount()
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
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetAgeInfo("2")
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

/// 检查部位字典
/// w ##class(web.DHCBL.BDP.ExportCheckData).GetPartCount()
ClassMethod GetPartCount() As %String
{
	//谷雪萍 2020-05-07 修改 User表中原来的^DHCPHPACON(0,"PartCode",Code)不知道被谁删掉了，重新加回去
	d ##class(User.DHCPHPartContrast).%BuildIndices()
	k ^TMPKBCOUNT("DHCPHPart")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHEPA(id)) q:id=""
		s Code=$p($g(^DHCPHEPA(id)),"^",1)       //检查部位code
		continue:Code=""
		if ($d(^DHCPHPACON(0,"PartCode",Code))>0){
			s conid =0
			for {
				s conid=$o(^DHCPHPACON(0,"PartCode",Code,conid)) q:conid=""  
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHPart",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHPart",count)=id
		}

	}	
	q count
}

/// 检查部位字典
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetPartInfo("2")
ClassMethod GetPartInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHPart",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHEPA(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHEPA(rowId)),"^",2)  //描述
  	s str="&%&%"_code_"&%"_desc
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHPACON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHPACON(conid)),"^",4)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc
	
  	}
	q str
}

/// 通用名（检验）
/// w ##class(web.DHCBL.BDP.ExportCheckData).GetGenericCount()
ClassMethod GetGenericCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtGeneric")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHEGEN(id)) q:id=""
		s Code=$p($g(^DHCPHEGEN(id)),"^",1)       //工号
		s lib=""
		s PHEGLibDr=$p($g(^DHCPHEGEN(id)),"^",7) 
		s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
		continue:Code=""
		continue:(lib'="检查项目")&(lib'="内镜")&(lib'="放射")&(lib'="超声")
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

/// 通用名（检验）
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetSPECGenericInfo("1")
ClassMethod GetGenericInfo(i) As %String
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
			s keys=keys_"#&"_$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)
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
	  	s hiscode=$p($g(^DHCPHGENCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHGENCON(conid)),"^",4)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc_"&%"_lib_"&%"_keys_"&%"_part
	
  	}
	q str
}

/// 适应症
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseIndCount()
ClassMethod GetDiseaseIndCount() As %String
{
	k ^TMPKBCOUNT("DHCCheakDiseaseInd")
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
			if (PINLCode="RADIIndic")||(PINLCode="ULTRIndic")||(PINLCode="ENDOIndic")||(PINLCode="CheckIndic") ;适应症
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCCheakDiseaseInd",count)=id_"^"_PHINSTRowId
			}
				
		}
	
		
	}	
	q count
}

/// 适应症
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseIndInfo("1")
ClassMethod GetDiseaseIndInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCCheakDiseaseInd",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //部位DR
		
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCCheakDiseaseInd",i)),"^",2)	
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
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_"#&"_dis
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
				s key0 = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)_"#&"_key0
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
				s key1 = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)_"#&"_key1
			}
			else
			{
				s key1 = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
	
	
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_lib_"&%"_dis_"&%"_sex_"&%"_PHINSTText_"&%"_mode_"&%"_key0_"&%"_key1
	q str
}

/// 禁忌症
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseConCount()
ClassMethod GetDiseaseConCount() As %String
{
	k ^TMPKBCOUNT("DHCCheckDiseaseCon")
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
			if (PINLCode="RADIContr")||(PINLCode="ULTRContr")||(PINLCode="ENDOContr")||(PINLCode="CheckContr") ;禁忌症
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCCheckDiseaseCon",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 禁忌症
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetDiseaseConInfo("1")
ClassMethod GetDiseaseConInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCCheckDiseaseCon",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //标本DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCCheckDiseaseCon",i)),"^",2)	
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
				s key0 = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)_"#&"_key0
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
				s key1 = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)_"#&"_key1
			}
			else
			{
				s key1 = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
	
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_lib_"&%"_dis_"&%"_age_"&%"_agelimit_"&%"_sex_"&%"_popu_"&%"_allergy_"&%"_PHINSTText_"&%"_mode_"&%"_key0_"&%"_key1
	q str
}

/// 不良反应
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetPHDARCount()
ClassMethod GetPHDARCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDAR")
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
			if (PINLCode="RADIAdvRea")||(PINLCode="ULTRAdvRea")||(PINLCode="ENDOAdvRea")||(PINLCode="CheckAdvRea") ;不良反应
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDAR",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 不良反应
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetPHDARInfo("1")
ClassMethod GetPHDARInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDAR",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //部位DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHDAR",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEPA(GlPPointer)),"^",2)          //部位
	
	//知识库标识
	s lib=""
	s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
	s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_lib_"&%"_PHINSTText
  	q str
}

/// 注意事项
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetPHDMHACount()
ClassMethod GetPHDMHACount() As %String
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
			if (PINLCode="RADIMatNeAt")||(PINLCode="ULTRMatNeAt")||(PINLCode="ENDOMatNeAt")||(PINLCode="CheckMatNeAt") ;注意事项
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDMHA",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 注意事项
/// /w ##class(web.DHCBL.BDP.ExportCheckData).GetPHDMHAInfo("1")
ClassMethod GetPHDMHAInfo(i) As %String
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
	s PHEFDesc=$p($g(^DHCPHEPA(GlPPointer)),"^",2)          //部位
	
	//知识库标识
	s lib=""
	s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
	s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
	
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_lib_"&%"_PHINSTText
  	q str
}

}
