/// 名称:基础数据平台组知识库数据导出。 
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期:2017-3-20
Class web.DHCBL.BDP.ExportELECTData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.DHCBL.BDP.ExportELECTData).GetSSUserTitle()
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
		s str="代码&%结果&%知识库标识"
	}
	if (table="5")
	{
		s str="生理代码&%生理描述&%类型&%是否可用&%是否系统标识"
	}
	if (table="6")
	{
		s str="分类代码&%分类描述&%知识库标识&%上级分类&%级别&%是否可用&%是否系统标识"
	}
	if (table="7")
	{
		s str="HIS库单位代码&%HIS库单位描述&%知识库单位代码&%知识库单位描述"
	}
	if (table="8") 
	{
		s str="HIS库诊断代码&%HIS库诊断描述&%知识库诊断代码&%知识库诊断描述&%类型&%操作状态&%备注&%关键字"
	}
	if (table="9")
	{
		s str="知识库病症代码&%知识库病症描述&%拼音码&%常用名&%常用名拼音码&%别名&%备注&%知识库icd代码"
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
		s str="心电项目&%部位&%知识库病症&%检查结果&%描述说明&%控制级别"
	}
	if (table="13") 
	{
		s str="心电项目&%部位&%知识库病症&%检查结果&%生理参数&%生理参数下限-上限&%检验项目&%指标值下限-上限&%指标值单位&%描述说明&%控制级别"
	}
	if (table="14") 
	{
		s str="控制级别&%心电项目&%部位&%存在相互作用通用名&%存在相互作用分类&%本文描述"
	}
	if (table="15") 
	{
		s str="心电项目&%部位&%不良反应"
	}
	if (table="16")
	{
		s str="心电项目&%部位&%注意事项"
	}
	q str
}

/// w ##class(web.DHCBL.BDP.ExportELECTData).GetCount("SS_User")
ClassMethod GetCount(table) As %String
{
	s rs=""
	if (table="2")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetLibaryLabelCount()
	}
	if (table="3")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetInstLabelCount()
	}
	if (table="4")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetExamineCount()
	}
	if (table="5")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetPhysiologyCount()
	}
	if (table="6")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetLibCatCount()
	}
	if (table="7")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetExtUomCount()
	}
	if (table="8")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetIcdCount()
	}
	if (table="9")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseListCount()
	}
	if (table="10")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetPartCount()
	}
	if (table="11")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetGenericCount()
	}
	if (table="12")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseIndCount()
	}
	if (table="13")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseConCount()
	}
	if (table="14")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetECGInteractCount()
	}
	if (table="15")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetECGARCount()
	}
	if (table="16")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetECGMHACount()
	}

	q rs
}

/// w ##class(web.DHCBL.BDP.ExportELECTData).GetName("SS_User")
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
		s rs="检查结果表"
	}
	if (table="5")
	{
		s rs="生理字典"
	}
	if (table="6")
	{
		s rs="分类类型字典"
	}
	if (table="7")
	{
		s rs="单位字典对照"
	}
	if (table="8")
	{
		s rs="诊断字典对照"
	}
	if (table="9")
	{
		s rs="病症"
	}
	if (table="10")
	{
		s rs="检查部位字典"
	}
	if (table="11")
	{
		s rs="通用名（心电）"
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
		s rs="相互作用"
	}
	if (table="15")
	{
		s rs="不良反应"
	}
	if (table="16")
	{
		s rs="注意事项"
	}
	
	
	q rs
}

/// w ##class(web.DHCBL.BDP.ExportELECTData).GetInfo("SS_User",3)
ClassMethod GetInfo(table, i) As %String
{
	s rs=""
	if (table="2")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetLibaryLabelInfo(i)
	}
	if (table="3")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetInstLabelInfo(i)
	}
	if (table="4")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetExamineInfo(i)
	}
	if (table="5")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetPhysiologyInfo(i)
	}
	if (table="6")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetLibCatInfo(i)
	}
	if (table="7")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetExtUomInfo(i)
	}
	if (table="8")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetIcdInfo(i)
	}
	if (table="9")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseListInfo(i)
	}
	if (table="10")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetPartInfo(i)
	}
	if (table="11")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetGenericInfo(i)
	}
	if (table="12")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseIndInfo(i)
	}
	if (table="13")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseConInfo(i)
	}
	if (table="14")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetECGInteractInfo(i)
	}
	if (table="15")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetECGARInfo(i)
	}
	if (table="16")
	{
		s rs=##class(web.DHCBL.BDP.ExportELECTData).GetECGMHAInfo(i)
	}

	q rs
}

/// 知识库标识字典
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetLibaryLabelCount()
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
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetLibaryLabelInfo("2")
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
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetInstLabelCount()
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
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetLibaryLabelInfo("2")
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

/// 检查结果表
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetExamineCount()
ClassMethod GetExamineCount() As %String
{
	k ^TMPKBCOUNT("DHCExamineFeild")
    s count=0
	s id=0,ExaCode=""
	for {
		s id=$o(^DHCEXAMINE(id)) q:id=""
		s ExaCode=$p($g(^DHCEXAMINE(id)),"^",1)       //代码
		continue:ExaCode=""
		s count=count+1
		s ^TMPKBCOUNT("DHCExamineFeild",count)=id
	}	
	q count
}

/// 检查结果表
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetExamineInfo("2")
ClassMethod GetExamineInfo(i) As %String
{
	n (i)
	s str=""
	S ExaRowId=$g(^TMPKBCOUNT("DHCExamineFeild",i))
	q:(ExaRowId="") ""
	s ExaCode=$p($g(^DHCEXAMINE(ExaRowId)),"^",1)
	s ExaResult=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)
	s lib=""
	s ExaLibDr=$p($g(^DHCEXAMINE(ExaRowId)),"^",3)
	s:ExaLibDr'="" lib=$p($g(^DHCPHLIBL(ExaLibDr)),"^",2)
	
		
  	s str=ExaCode_"&%"_ExaResult_"&%"_lib
	q str
}

/// 生理字典
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetPhysiologyCount()
ClassMethod GetPhysiologyCount() As %String
{
	k ^TMPKBCOUNT("DHCPhysiologyFeild")
    s count=0
	s id=0,PHYFCode=""
	for {
		s id=$o(^DHCPHYSIF(id)) q:id=""
		s PHYFCode=$p($g(^DHCPHYSIF(id)),"^",1)       //代码
		continue:PHYFCode=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPhysiologyFeild",count)=id
	}	
	q count
}

/// 生理字典
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetPhysiologyInfo("2")
ClassMethod GetPhysiologyInfo(i) As %String
{
	n (i)
	s str=""
	S PHYFRowId=$g(^TMPKBCOUNT("DHCPhysiologyFeild",i))
	q:(PHYFRowId="") ""
	s PHYFCode=$p($g(^DHCPHYSIF(PHYFRowId)),"^",1)
	s PHYFDesc=$p($g(^DHCPHYSIF(PHYFRowId)),"^",2)
	s PHYFType=$p($g(^DHCPHYSIF(PHYFRowId)),"^",3)
	s PHYFActiveFlag=$p($g(^DHCPHYSIF(PHYFRowId)),"^",4)
	s PHYFSysFlag=$p($g(^DHCPHYSIF(PHYFRowId)),"^",5)
	
		
  	s str=PHYFCode_"&%"_PHYFDesc_"&%"_PHYFType_"&%"_PHYFActiveFlag_"&%"_PHYFSysFlag
	q str
}

/// 分类类型字典
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetLibCatCount()
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
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetLibCatInfo("2")
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

/// 单位字典
/// w ##class(web.DHCBL.BDP.ExportELECTData).GetExtUomCount()
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
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetExtUomInfo("2")
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

/// 诊断字典
/// w ##class(web.DHCBL.BDP.ExportELECTData).GetIcdCount()
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
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetIcdInfo("2")
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

/// 病症字典
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseListCount()
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
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseListInfo("2")
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

/// 检查部位字典
/// w ##class(web.DHCBL.BDP.ExportELECTData).GetPartCount()
ClassMethod GetPartCount() As %String
{
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
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetPartInfo("2")
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

/// 通用名（心电）
/// w ##class(web.DHCBL.BDP.ExportELECTData).GetGenericCount()
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
		continue:(lib'="心电")
		if ($d(^DHCPHGENCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHGENCON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHGENCON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHExtGeneric",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHExtGeneric",count)=id
		}

	}	
	q count
}

/// 通用名（心电）
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetGenericInfo("1")
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
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseIndCount()
ClassMethod GetDiseaseIndCount() As %String
{
	k ^TMPKBCOUNT("DHCELECTDiseaseInd")
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
			if (PINLCode="ELECTIndic") ;适应症
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCELECTDiseaseInd",count)=id_"^"_PHINSTRowId
			}
				
		}
	
		
	}	
	q count
}

/// 适应症
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseIndInfo("1")
ClassMethod GetDiseaseIndInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCELECTDiseaseInd",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //部位DR
		
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCELECTDiseaseInd",i)),"^",2)	
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
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_"#&"_dis
			}
			else
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
	}
	
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
	
	//检查结果
	s RowId=0
	s exa=""
	for
	{
		s RowId=$o(^DHCLIBEXAI(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s EXAIExamDr=$p(^DHCLIBEXAI(RowId),"^",2)
		if (EXAIExamDr'="") 
		{
			if (exa'="")
			{
				s exa = $p(^DHCEXAMINE(EXAIExamDr),"^",2)_"#&"_exa
			}
			else
			{
				s exa = $p(^DHCEXAMINE(EXAIExamDr),"^",2)
			}
		} 
	}
	
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_dis_"&%"_exa_"&%"_PHINSTText_"&%"_mode
	q str
}

/// 禁忌症
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseConCount()
ClassMethod GetDiseaseConCount() As %String
{
	k ^TMPKBCOUNT("DHCELECTDiseaseCon")
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
			if (PINLCode="ELECTContr") ;禁忌症
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCELECTDiseaseCon",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 禁忌症
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetDiseaseConInfo("1")
ClassMethod GetDiseaseConInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCELECTDiseaseCon",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //标本DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCELECTDiseaseCon",i)),"^",2)	
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
	
	//检查结果
	s RowId=0
	s exa=""
	for
	{
		s RowId=$o(^DHCLIBEXAI(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s EXAIExamDr=$p(^DHCLIBEXAI(RowId),"^",2)
		if (EXAIExamDr'="") 
		{
			if (exa'="")
			{
				s exa = $p(^DHCEXAMINE(EXAIExamDr),"^",2)_"#&"_exa
			}
			else
			{
				s exa = $p(^DHCEXAMINE(EXAIExamDr),"^",2)
			}
		} 
	}
	
	//生理参数
	s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",PHINSTRowId,0))
	s phy="", phylimit=""
	if (PHYVRowId'="")
	{
		s PHYVFeildDr=$p($g(^DHCPHYVAL(PHYVRowId)),"^",2)
		s:PHYVFeildDr'="" phy=$p($g(^DHCPHYSIF(PHYVFeildDr)),"^",2)
		 
		//生理参数范围
		s PHYVMinVal=$p($g(^DHCPHYVAL(PHYVRowId)),"^",5)
		s PHYVMaxVal=$p($g(^DHCPHYVAL(PHYVRowId)),"^",4)
		s:PHYVMinVal'="" phylimit=PHYVMinVal
		s:PHYVMaxVal'="" phylimit=phylimit_"-"_PHYVMaxVal
	   
	}
	
	//检验项目
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",PHINSTRowId,0))
	s Lab="",LABLimit="",LABIUom=""
	if (LABIRowId'="")
	{
		s LABILabDr=$p($g(^DHCLIBLABI(LABIRowId)),"^",2)
		s:LABILabDr'="" Lab=$p($g(^DHCPHEGEN(LABILabDr)),"^",2)
		
		//指标值范围
		s LABIMinVal=$p($g(^DHCLIBLABI(LABIRowId)),"^",4)
		s LABIMaxVal=$p($g(^DHCLIBLABI(LABIRowId)),"^",3)
		s LABIRelation=$p($g(^DHCLIBLABI(LABIRowId)),"^",6)
		
		s:LABIRelation'="" LABLimit=LABIRelation
		s:LABIMinVal'="" LABLimit=LABLimit_LABIMinVal
		s:LABIMaxVal'="" LABLimit=LABLimit_"-"_LABIMaxVal
		
		//指标值单位
		s LABIUomDr = $p($g(^DHCLIBLABI(LABIRowId)),"^",5)
		s:LABIUomDr'="" LABIUom=$p($g(^DHCPHEUO(LABIUomDr)),"^",2)
		
	}
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_dis_"&%"_exa_"&%"_phy_"&%"_phylimit_"&%"_Lab_"&%"_LABLimit_"&%"_LABIUom_"&%"_PHINSTText_"&%"_mode
	q str
}

/// 相互作用
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetECGInteractCount()
ClassMethod GetECGInteractCount() As %String
{
	k ^TMPKBCOUNT("DHCPHECGInteract")
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
			if (PINLCode="ELECTInterEach") ;相互作用
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHECGInteract",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 相互作用
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetECGInteractInfo("1")
ClassMethod GetECGInteractInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHECGInteract",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHECGInteract",i)),"^",2)	
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

/// 不良反应
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetECGARCount()
ClassMethod GetECGARCount() As %String
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
			if (PINLCode="ELECTAdvRea") ;不良反应
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDAR",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 不良反应
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetECGARInfo("1")
ClassMethod GetECGARInfo(i) As %String
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
	
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHINSTText
  	q str
}

/// 注意事项
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetECGMHACount()
ClassMethod GetECGMHACount() As %String
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
			if (PINLCode="ELECTMatNeAt") ;注意事项
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDMHA",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 注意事项
/// /w ##class(web.DHCBL.BDP.ExportELECTData).GetECGMHAInfo("1")
ClassMethod GetECGMHAInfo(i) As %String
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
	
	
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHINSTText
  	q str
}

}
