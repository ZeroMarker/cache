/// Description:门诊药房公共控件类
/// Creator: 	hulihua
/// CreateDate: 2018-08-14
Class web.DHCOUTPHA.Common.CommonUtil Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Description:： 获取疗程集合用于combox（json）
/// Creator：      pushuangcai
/// CreatDate：    2018/07/16
/// Table：        User.PHCDuration
/// Input：        combotext , style 
/// Output：       w ##class(web.DHCSTPharmacyCommon).GetPhcDurationjs()
/// Return：       
/// Others：    
ClassMethod GetPhcDurationjs(combotext = "", style = "")
{
 s result=##class(%ResultSet).%New("web.DHCST.Util.DrugUtilQuery:GetPhcDuration")
 s sc=result.Execute(combotext)
 i $$$ISERR(sc) q "[{}]"
 s colNum=result.GetColumnCount()
 i style["select2" s Title="id^text"
 e  s Title="RowId^Desc"
 s count = 0
 While(result.Next())
 { 
  	s ret=""
  	f i=1:1:colNum d
  	.i ret="" s ret=result.%GetData(i)
  	.e  s ret=ret_"^"_result.%GetData(i)
 	s count = count+1
 	I count=1 d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartRow()
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
	e  d
	.w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
  }
  i count'=0 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonEndRow()
  q:count=0 "[{}]"
  q ""
}

/// Description: 获取频次集合用于combox（json）
/// Creator：    pushuangcai
/// CreatDate：  2018/07/16
/// Table：      User.PHCFreq
/// Input：      combotext , style 
/// Output：     w ##class(web.DHCOUTPHA.Common.CommonUtil).GetPHCFreqJs()
/// Return：       
/// Others：
ClassMethod GetPHCFreqJs(combotext = "", style = "")
{
	s Title="text^code^factor^days^id"
  	s result=##class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpFrequence") //调用医生站录医嘱界面频次信息
 	s sc=result.Execute(combotext)
 	i $$$ISERR(sc) q "[{}]"
 	s colNum=result.GetColumnCount()
 	s count = 0
 	While(result.Next())
 	{ 
  		s ret=""
  		f i=1:1:colNum d
  		.i ret="" s ret=result.%GetData(i)
  		.e  s ret=ret_"^"_result.%GetData(i)
 		s count = count+1
 		I count=1 d
		.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartRow()
		.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
		e  d
		.w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
  	}
  	i count'=0 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonEndRow()
  	q:count=0 "[{}]"
  	q ""
}

/// Description:获取用法集合用于combox（json）
/// Creator：   pushuangcai
/// CreatDate： 2018/07/16
/// Table：      
/// Input：     PrescType -处方类型, combotext, style  
/// Output：    w ##class(web.DHCOUTPHA.Common.CommonUtil).GetInstrJs()
/// Return：       
/// Others：
ClassMethod GetInstrJs(PrescConfigId, combotext = "", style = "")
{
	q:PrescConfigId="" "[{}]"
	i style["select2" s Title="id^text"
  	e  s Title="RowId^Desc"
  	s result=##class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpInstr") 	//调用医生站录医嘱界面用法信息
  	s sc=result.Execute("",PrescConfigId)											// 用法关联处方类型
 	i $$$ISERR(sc) q "[{}]"
 	s colNum=result.GetColumnCount()
 	s count = 0
 	While(result.Next())
 	{ 
  		s ret=""
  		f i=1:1:colNum d
  		.i ret="" s ret=result.%GetData(i)
  		.e  s ret=ret_"^"_result.%GetData(i)
 		s count = count+1
 		I count=1 d
		.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartRow()
		.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
		e  d
		.w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
  	}
  	i count'=0 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonEndRow()
  	q:count=0 "[{}]"
  	q ""
}

/// Description:获取处方类型集合用于combox（json）
/// Creator：   pushuangcai
/// CreatDate： 2018/07/16
/// Table：        
/// Input：     combotext, style   
/// Output：    w ##class(web.DHCSTPharmacyCommon).GetPrescTypeJs()
/// Return：       
/// Others：
ClassMethod GetPrescTypeJs(combotext = "", style = "")
{
	i style["select2" s Title="id^text"
  	e  s Title="RowId^Desc"
  	s PAAdmType="",RecLocID="" //暂写为空 psc
  	;判断接收科室是否是大十字分部
	s DSZFlag=##class(web.DHCDocOrderEntryCM).GetLocDSZFlag(RecLocID)
	s CTDefineALL=""
	s CTDefineRowID=0 f  s CTDefineRowID=$o(^DHCDocCT("Define",CTDefineRowID)) q:CTDefineRowID=""  d
	.s CTModuleDR=$p($g(^DHCDocCT("Define",CTDefineRowID)),"^",3)
	.q:CTModuleDR'="15"
	.;住院处方类型 根据大十字和黄河路区分
	.q:(PAAdmType="I")&&(DSZFlag'="Y")&&(CTDefineRowID'="29")&&(CTDefineRowID'="30")&&(CTDefineRowID'="32")
	.q:(PAAdmType="I")&&(DSZFlag="Y")&&(CTDefineRowID'="29")&&(CTDefineRowID'="31")
	.;q:(PAAdmType'="I")&&(CTDefineRowID="32")
	.s CTDefineDesc=$p($g(^DHCDocCT("Define",CTDefineRowID)),"^",2)
	.i CTDefineALL="" s CTDefineALL=CTDefineRowID_"^"_CTDefineDesc
	.e  s CTDefineALL=CTDefineALL_"%"_CTDefineRowID_"^"_CTDefineDesc
	q:CTDefineALL="" "[{}]"
	s Len=$l(CTDefineALL,"%")
	f I=1:1:Len  d
	.s Ret=$p(CTDefineALL,"%",I)
	.i I=1 d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartRow()
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,Ret)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,Ret)
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonEndRow()
  	q ""
}

/// Description:获取处方配制集合用于combox（json）
/// Creator：   pushuangcai
/// CreatDate： 2018/07/16
/// Table：        
/// Input：        
/// Output：    w ##class(web.DHCOUTPHA.Common.CommonUtil).GetPrescConfigJs()
/// Return：       
/// Others：
ClassMethod GetPrescConfigJs(PrescType, combotext = "", style = "")
{
	i $f(PrescType,"||")>0 s PrescType=$p(PrescType,"||",1)
	i style["select2" s Title="id^text^code"
  	e  s Title="RowId^Desc^Code"
  	s result=##class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpPrescConfig") 	//调用医生站录医嘱界面处方类型信息
  	s sc=result.Execute(PrescType,combotext)										//关联处方类型
 	i $$$ISERR(sc) q "[{}]"
 	s colNum=result.GetColumnCount()
 	s count = 0
 	While(result.Next())
 	{ 
  		s ret=""
  		f i=1:1:colNum d
  		.i ret="" s ret=result.%GetData(i)
  		.e  s ret=ret_"^"_result.%GetData(i)
 		s count = count+1
 		I count=1 d
		.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartRow()
		.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
		e  d
		.w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
  	}
  	i count'=0 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonEndRow()
  	q:count=0 "[{}]"
  	q ""
}

/// Description:获取用量（跟用法关联）集合用于combox（json）
/// Creator：   pushuangcai
/// CreatDate： 2018/07/16
/// Table：        
/// Input：     Instr-用法id, combotext , style    
/// Output：    w ##class(web.DHCOUTPHA.Common.CommonUtil).GetPrescOrderQtyJs()
/// Return：       
/// Others：
ClassMethod GetPrescOrderQtyJs(Instr, combotext = "", style = "")
{
	i style["select2" s Title="id^text^code"
  	e  s Title="RowId^Desc^Code"
  	q:Instr="" "[{}]"
  	s result=##class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpPrescOrderQty") //调用医生站录医嘱界面用量信息
  	s sc=result.Execute(Instr)											 			//关联用法
 	i $$$ISERR(sc) q "[{}]"
 	s colNum=result.GetColumnCount()
 	s count = 0
 	While(result.Next())
 	{ 
  		s ret=""
  		f i=1:1:colNum d
  		.i ret="" s ret=result.%GetData(i)
  		.e  s ret=ret_"^"_result.%GetData(i)
 		s count = count+1
 		I count=1 d
		.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartRow()
		.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
		e  d
		.w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
  	}
  	i count'=0 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonEndRow()
  	q:count=0 "[{}]"
  	q ""
}

/// Description:获取特殊煎药方式集合用于combox（json）
/// Creator：   pushuangcai
/// CreatDate： 2018/08/15
/// Table：        
/// Input：     combotext , style    
/// Output：    w ##class(web.DHCINPHA.MTCommon.CommonUtil).GetPhSpecInstJs()
/// Return：       
/// Others：
ClassMethod GetPhSpecInstJs(combotext = "", style = "")
{
	i style["select2" s Title="id^text"
  	e  s Title="RowId^Desc"
  	s Str=$g(^DHCDocConfig("CNMedItemPhSpecInstr"))
  	q:Str="" "[{}]"
  	s count = 0
 	f i=1:1:$l(Str,"^") d
  	.s SpecInstId=$p($p(Str,"^",i),$c(1),1)
  	.s SpecInst=$p($p(Str,"^",i),$c(1),2)
  	.s ret=SpecInst_"^"_SpecInst
 	.s count = count+1
 	.I count=1 d
	..w "["
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,ret)
    i count'=0 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonEndRow()
  	q:count=0 "[{}]"
  	q ""
}

/// Description:新建临时global的计数器
/// Creator:	hulihua
/// CreateDate:	2018-08-14
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCOUTPHA.Common.CommonUtil).NewPid()
ClassMethod NewPid(ClassName As %String) As %String
{
  	Q $I(^DHCOUTPHAPID("DHCOUTPHA",ClassName))
}

/// Description:Kill临时global的公共方法
/// Creator:	hulihua
/// CreateDate:	2018-08-14
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCOUTPHA.Common.CommonUtil).ClearTmp()
ClassMethod ClearTmp(ClassName As %String, MethodName As %String, pid As %String, PAR As %String = "") As %String
{
	I PAR'="" D
	.K ^TMP("DHCOUTPHA",ClassName,MethodName,pid,PAR)
	E  D
	.K ^TMP("DHCOUTPHA",ClassName,MethodName,pid)
	Q ""
}

}
