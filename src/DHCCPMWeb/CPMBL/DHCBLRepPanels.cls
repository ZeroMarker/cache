Class DHCCPMWeb.CPMBL.DHCBLRepPanels Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 加入Panel
ClassMethod AddNewPanel(RepRowID As %String, Panel As DHCCPMWeb.CPMSevice.entity.DHCERepPanels) As %String
{
	n (RepRowID, Panel)
	;s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).AddNewPanel(5,mypl)
	s $ZT="ERROR^DHCSSERR"
	;验证报表是否存在
	
	s myrtn=""
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).CheckCurSelRep(RepRowID)
	q:(+myrtn) myrtn
	
	TSTart
	
	s myrep=##class(DHCCPM.DHCReports).%OpenId(RepRowID)
	
	s mypanelobj=..DTOTransObj(Panel)
	d myrep.RepPanels.Insert(mypanelobj)
	;增加Fields
	
	s myFCount=Panel.RepFields.Count()
	f myIdx=1:1:myFCount  d
	.s myefobj=Panel.RepFields.GetAt(myIdx)
	.q:(myefobj.RFType'="C")
	.s myfobj=##class(DHCCPMWeb.CPMBL.DHCBLRepFields).DTOTransObj(myefobj)
	.d mypanelobj.RepFields.Insert(myfobj)
	.d myefobj.%Close()
	.d myfobj.%Close()
	
	;增加Parameter
	s myPMCount=Panel.RepParameters.Count()
	f myIdx=1:1:myPMCount  d
	.s myepmobj=Panel.RepParameters.GetAt(myIdx)
	.s mypmobj=##class(DHCCPMWeb.CPMBL.DHCBLRepParameters).DTOTransObj(myepmobj)
	.d mypanelobj.RepParameters.Insert(mypmobj)
	.d myepmobj.%Close()
	.d mypmobj.%Close()
	;关闭Panel对象
	d Panel.%Close()
	
	s mysc=myrep.%Save()
	
	;s myMaxID=myrep.RepPanels.Count()
	;s myCurPanelRowID=myrep.RepPanels.GetAt(myMaxID).%Id()
	s myCurPanelRowID=mypanelobj.%Id()
	
	d myrep.%Close()
	
	If $$$ISERR(mysc) {
    	s myrtn=-104
    }
	
	if (+myrtn=0){
		tc
	}else{
		tro
	}
	
	q myrtn_"^"_myCurPanelRowID
}

/// 验证当前的报表格式是否存在
ClassMethod CheckCurSelRepPanel(RPRowID As %String) As %String
{
	n (RPRowID)
	s myrtn=0
	s mysrc=##class(DHCCPM.DHCRepPanels).%ExistsId(RPRowID)
	i mysrc'=1 d
	.s myrtn=-1102	;
	
	q myrtn
}

/// 删除一个Panel
ClassMethod DELETE(RPRowID As %String) As %String
{
	n (RPRowID)
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).DELETE(RPRowID)
	
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=""
	;1验证报表是否存在：
	;2验证Panel是否存在
	;3删除Panel
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).CheckCurSelRep(+RPRowID)
	q:(myrtn) myrtn
	
	s myrtn=..CheckCurSelRepPanel(RPRowID)
	
	TStart
	
	Set mysc=##class(DHCCPM.DHCRepPanels).%DeleteId(RPRowID)
	
	If $$$ISERR(mysc) {
    	s myrtn=-106
    }
	
	if (+myrtn=0){
		TCommit
	}else{
		tro
	}
	
	q myrtn
}

/// 把DTO转换为对象
ClassMethod DTOTransObj(ERepPanel As DHCCPMWeb.CPMSevice.entity.DHCERepPanels) As DHCCPM.DHCRepPanels
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).DTOTransObj(RepPanel)
	;##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara()
	n (ERepPanel)
	
	s ERepPanel.RowID=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(ERepPanel.RowID)
	
	s myRowID=ERepPanel.RowID
	if (myRowID'=""){
		s mypanel=##class(DHCCPM.DHCRepPanels).%OpenId(myRowID)
	}else{
		s mypanel=##class(DHCCPM.DHCRepPanels).%New()
	}
	
	s mypanel.RPName=ERepPanel.RPName
	s mypanel.RPCaption=ERepPanel.RPCaption
	s mypanel.RPClassName=ERepPanel.RPClassName
	s mypanel.RPQueryName=ERepPanel.RPQueryName
	s mypanel.RPType=ERepPanel.RPType
	;
	
	q mypanel
}

/// 获取系统的Panel
ClassMethod GetDefaultSysPanel() As DHCCPMWeb.CPMSevice.entity.DHCERepPanels
{
	;s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetDefaultSysPanel()
	n (ad)
	
	s mySysPanel=""
	s mySysPanel=##class(DHCCPMWeb.CPMSevice.entity.DHCERepPanels).%New()
	
	s mySysPanel.ParRef=""
	s mySysPanel.RPName="SYSPanel"
	s mySysPanel.RPCaption="系统参数"
	s mySysPanel.RPClassName=""
	s mySysPanel.RPQueryName=""
	s mySysPanel.RPType="S"			;System
	s mySysPanel.ShowPackageInfo="系统包"
	s mylist=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetSysFields()
	
	;s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetCTLocID()
	;d mySysPanel.RepFields.Insert(obj)
	
	s mySysPanel.RepFields=mylist
	
	q mySysPanel
}

/// 利用一个 类名称和Query名称生成一个Panel
/// 可以作为新增也可以作为 报表加载
/// 返回  DHCCPMWeb.CPMSevice.entity.DHCERepPanels 对象
ClassMethod GetPanelByClsQuery(PanelRowID As %String, ClsName As %String, QueryName As %String, ExpStr As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepPanels
{
	;s mypl=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByClsQuery("","web.DHCOPAdmFind","AdmQuery","")
	n (PanelRowID, ClsName, QueryName, ExpStr)
	;1加载自定义Field
	;2加载Query的Field
	
	s myPanel=##class(DHCCPMWeb.CPMSevice.entity.DHCERepPanels).%New()
	
	;初始化
	s myPanel.RPName=ClsName_":"_QueryName
	s myPanel.RPCaption="查询"_ClsName_":"_QueryName
	s myPanel.RPClassName=ClsName
	s myPanel.RPQueryName=QueryName
	s myPanel.RPType="Q"
	s myPanel.ShowPackageInfo=ClsName_"||"_QueryName
	
	;增加一个报表的序号
	s myFObj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s myFObj.RFCaption="报表序号"
	s myNetDataType=##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).GetNetTypeByDBType("C","String","")
	s myFObj.RFDataType=myNetDataType
	s myFObj.RFDefaultValue=""
	s myFObj.RFDescription=""
	s myFObj.RFName=ClsName_"."_QueryName_".CPMReportSystemNo"
	s myFObj.RFType="Q"
	d myPanel.RepFields.Insert(myFObj)
	d myFObj.%Close()
	
	if (PanelRowID'="") d
	.s myobj=##class(DHCCPM.DHCRepPanels).%OpenId(PanelRowID)
	.q:('$IsObject(myobj))
	.s myPanel.ParRef=+PanelRowID
	.s myPanel.RowID=myobj.%Id()
	.s myPanel.RPName=myobj.RPName
	.s myPanel.RPCaption=myobj.RPCaption
	.s myPanel.RPClassName=myobj.RPClassName
	.s myPanel.RPQueryName=myobj.RPQueryName
	.s myPanel.RPType=myobj.RPType
	.s myCount=myobj.RepFields.Count()
	.f i=1:1:myCount  d
	..s myRepFobj=myobj.RepFields.GetAt(i)
	..s myFObj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	..s myFObj.RFCaption=myRepFobj.RFCaption
	..s myFObj.RFDataType=myRepFobj.RFDataType
	..s myFObj.RFDefaultValue=myRepFobj.RFDefaultValue
	..s myFObj.RFDescription=myRepFobj.RFDescription
	..s myFObj.RFName=myRepFobj.RFName
	..s myFObj.RowID=myRepFobj.%Id()
	..d myPanel.RepFields.Insert(myFObj)
	..d myFObj.%Close()
	..
	
	s myFStr=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQOutParaList(ClsName,QueryName,"")
	
	s mylist=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetParaList(myFStr,",")
	
	s myCount=mylist.Count()
	f i=1:1:myCount  d
	.s myStr=mylist.GetAt(i)
	.s myFName=$p(myStr,":",1)
	.s myDataType=$p(myStr,":",2)
	.s myFObj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	.s myFObj.RFCaption=myFName
	.s myNetDataType=##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).GetNetTypeByDBType("C",myDataType,"")
	.s myFObj.RFDataType=myNetDataType
	.s myFObj.RFDefaultValue=""
	.s myFObj.RFDescription=""
	.s myFObj.RFName=myFName
	.s myFObj.RFType="Q"
	.d myPanel.RepFields.Insert(myFObj)
	.d myFObj.%Close()
	
	QUIT myPanel
}

ClassMethod GetPanelByCompName(PanelRowID As %String, CompName As %String, ExpStr As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepPanels
{
	n (PanelRowID, CompName, ExpStr)
	
	;转换为大写字母；
	s CompName = $ZConvert(CompName, "U")
	;用空字符串替换“.”
	s CompName = $TR(CompName,".","")
	
	s myCompDR = $o(^websys.ComponentI("UniqueNameIndex", CompName,0))
	
	s myPanel= ..GetPanelByCompDR(PanelRowID, myCompDR, ExpStr)
	
	QUIT myPanel
}

/// 根据组件加载成为一个Panel
/// 可以作为新增也可以作为 报表加载
/// 返回  DHCCPMWeb.CPMSevice.entity.DHCERepPanels 对象
ClassMethod GetPanelByCompDR(PanelRowID As %String, CompDR As %String, ExpStr As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepPanels
{
	;s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByCompDR("",1909,"")
	;1加载自定义Field
	;2加载Query的Field
	n (PanelRowID, CompDR, ExpStr)
	
	s myPanel=##class(DHCCPMWeb.CPMSevice.entity.DHCERepPanels).%New()
	s myCompName=""
	
	if (PanelRowID'="") d
	.s myobj=##class(DHCCPM.DHCRepPanels).%OpenId(PanelRowID)	
	.q:('$IsObject(myobj))
	.s myPanel.RowID=myobj.%Id()
	.s myPanel.RPClassName=myobj.RPClassName
	.s myPanel.RPQueryName=myobj.RPQueryName
	.s myPanel.RPType=myobj.RPType
	.s myCount=myobj.RepFields.Count()
	.f i=1:1:myCount  d
	..s myRepFobj=myobj.RepFields.GetAt(i)
	..s myFObj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	..s myFObj.RFCaption=myRepFobj.RFCaption
	..s myFObj.RFDataType=myRepFobj.RFDataType
	..s myFObj.RFDefaultValue=myRepFobj.RFDefaultValue
	..s myFObj.RFDescription=myRepFobj.RFDescription
	..s myFObj.RFName=myRepFobj.RFName
	..s myFObj.RowID=myRepFobj.%Id()
	..d myPanel.RepFields.Insert(myFObj)
	..d myFObj.%Close()
	..
	
	q:(CompDR="") myPanel
	
	;打开组件类	
	s myComs=##class(websys.Component).%OpenId(CompDR)
	
	q:('$IsObject(myComs)) myPanel
	
	s myCompName=myComs.Name
	s myPanel.RPName="Componet"_CompDR
	s myPanel.RPCaption="组件"_myCompName
	s myPanel.ShowPackageInfo="组件"_myCompName
	
	s myCount=myComs.Items.Count()
	
	f i=1:1:myCount  d
	.s myItem=myComs.Items.GetAt(i)
	.s myDPType=myItem.DisplayType
	.;显示,TEXTBOX,LISTBOX,CHECKBOX,TEXTAREA,LINK,BUTTON,COMPONENT,ICONPROFILE,CUSTOM,RTF,CUSTOMTEXTBOX", 
	.;VALUELIST = ",T,L,C,TA,A,B,CX,IP,S,R,CT"
	.q:((myDPType'="T")&(myDPType'="L")&(myDPType'="C")&(myDPType'="TA"))
	.s myFObj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	.s myFObj.RFCaption=myItem.Caption
	.s myDBDataType=myItem.DataType
	.s myDataType=myDBDataType
	.i $l(myDBDataType,".")>1 d
	..s myDataType=$p(myDBDataType,".",2)
	.s myNetDataType=##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).GetNetTypeByDBType("C",myDataType,"")
	.s myFObj.RFDataType=myNetDataType
	.s myFObj.RFDefaultValue=""
	.s myFObj.RFDescription=myItem.Description
	.s myFObj.RFName=myItem.Name
	.s myFObj.RFDisplayType=myItem.DisplayType
	.s myFObj.RFType="T"
	.d myPanel.RepFields.Insert(myFObj)
	.d myFObj.%Close()
	
	QUIT myPanel
}

/// 把数据库中的对象转换为DTO
ClassMethod OBJTransDTO(RPRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepPanels
{
	n (RPRowID)
	;##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).OBJTransDTO()
	
	s myEPanel=##class(DHCCPMWeb.CPMSevice.entity.DHCERepPanels).%New()
	
	s mypanel=##class(DHCCPM.DHCRepPanels).%OpenId(RPRowID)
	q:('$IsObject(mypanel)) myEPanel
	
	s myEPanel.ParRef=+RPRowID
	s myEPanel.RowID=RPRowID
	s myEPanel.RPName=mypanel.RPName
	s myEPanel.RPCaption=mypanel.RPCaption
	s myEPanel.RPClassName=mypanel.RPClassName
	s myEPanel.RPQueryName=mypanel.RPQueryName
	s myEPanel.RPType=mypanel.RPType
	
	q myEPanel
}

}
