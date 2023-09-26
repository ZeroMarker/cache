Import SQLUSER

/// qqa
/// 不良事件统计字典
Class web.DHCADVSetAdvStatFied Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCADVSetAdvStatFied).JsonListGetAllItmByFormID(987)
ClassMethod JsonListGetAllItmByFormID(ForNameID)
{
	n (ForNameID)
	s pid = ##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid)
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:ForNameID="" ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:ForNameID="" ""
	s Version = $o(^User.DHCAdvFormI("IndexNameVersion",ForNameID,""),-1)  //获取最后一个版本号
	s Del="""",Count=0
	s FormID=0
	f  s FormID = $o(^User.DHCAdvFormI("IndexNameVersion",ForNameID,Version,FormID)) q:FormID=""  d
	.s FormType = $lg(^User.DHCAdvFormD(FormID),7)
	.q:FormType'="element"
	.s FormDicDr = $lg(^User.DHCAdvFormD(FormID),4)
	.q:FormDicDr="" 
	.s HasChild = ##class(web.DHCADVSetAdvStatFied).IsHasChildDic(FormDicDr)  
	.s DicInfo = ##class(web.DHCADVSetAdvStatFied).GetDicItmInfo(FormDicDr)   
	.s DicStyle= $p(DicInfo,"^",3)	   //元素类型  
	.i DicStyle="table" b ;1                                          
	.q:(DicStyle="label")&&(HasChild=0)    //过滤掉label,并且没有子元素
	.i (DicStyle="label")&&(HasChild'=0) d //有子元素,获取子元素信息
	..d ##class(web.DHCADVSetAdvStatFied).JsonChildDic(pid,FormDicDr)  //临时globle存储数据
	.i (DicStyle="table")&&(HasChild'=0) d //table元素中获取子元素
	..d ##class(web.DHCADVSetAdvStatFied).JsonChildDic(pid,FormDicDr)  //临时globle存储数据
	.s ^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid,FormDicDr)=""
	b ;data
	//循环获取数据
	s SpecialDic="93915^"
	s Count=0
	s RsTitle="FormDicID^DicField^DicStyle^DicDesc^DicUrl^DicParef^ValDr"
	s FormDicID=""
	f  s FormDicID = $o(^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid,FormDicID)) q:FormDicID=""  d
	.q:$d(^DHCADVSTF(0,"FormNameDic",ForNameID,FormDicID))'=0
	.s DicInfo = ##class(web.DHCADVSetAdvStatFied).GetDicItmInfo(FormDicID)
	.s DicField = $p(DicInfo,"^",2)   //唯一标示
	.s DicStyle= $p(DicInfo,"^",3)	   //元素类型
	.s DicDesc= $p(DicInfo,"^",4)	   //元素描述
	.s DicUrl= $p(DicInfo,"^",5)	   //元素路径
	.s DicParef  = $p(DicInfo,"^",6)  //父元素ID
	.
	.q:$$ALPHAUP^SSUTIL4(DicDesc)=""
	.q:$$ALPHAUP^SSUTIL4(DicDesc)="1"
	.q:$$ALPHAUP^SSUTIL4(DicDesc)="2"
	.;q:$lg($g(^User.DHCAdvFormDicD(+DicParef)),4)="1"
	.
	.q:DicStyle="easyui-datebox" 
	.s IsTableFlag =##class(web.DHCADVSetAdvStatFied).GetIsTableItm(FormDicID)
	.s:IsTableFlag'=0 DicDesc = ##class(web.DHCADVEXPFIELD).GetTableDicParef(FormDicID)_":"_DicDesc
	.s:(+DicParef'=0)&&(IsTableFlag=0) DicDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)_":"_DicDesc
	.s:$p(DicDesc,":",1)="1" DicDesc = "压疮部位:"_$p(DicDesc,":",2)
	.;s:SpecialDic[DicParef DicDesc = ##class(web.DHCADVEXPFIELD).GetTableDicParef(FormDicID)
	.s ValDr=""
	.s RsDate = FormDicID_"^"_DicField_"^"_DicStyle_"^"_DicDesc_"^"_DicUrl_"^"_DicParef_"^"_ValDr
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.w ##class(web.DHCAPPJsonCommon).getJsonData(RsTitle,RsDate)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(Count)
	q ""
}

/// 统计数据获取Columns(新)
/// w ##class(web.DHCADVSetAdvStatFied).JsonGetAllItmByFormID(987)
ClassMethod JsonGetAllItmByFormID(ForNameID)
{
	n (ForNameID)
	w "["
	s pid = ##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid)
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:ForNameID="" ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:ForNameID="" ""
	s Version = $o(^User.DHCAdvFormI("IndexNameVersion",ForNameID,""),-1)  //获取最后一个版本号
	s Del="""",Count=0
	s FormID=0
	f  s FormID = $o(^User.DHCAdvFormI("IndexNameVersion",ForNameID,Version,FormID)) q:FormID=""  d
	.s FormType = $lg(^User.DHCAdvFormD(FormID),7)
	.q:FormType'="element"
	.s FormDicDr = $lg(^User.DHCAdvFormD(FormID),4)
	.q:FormDicDr="" 
	.s HasChild = ##class(web.DHCADVSetAdvStatFied).IsHasChildDic(FormDicDr)  
	.s DicInfo = ##class(web.DHCADVSetAdvStatFied).GetDicItmInfo(FormDicDr)   
	.s DicStyle= $p(DicInfo,"^",3)	   //元素类型  
	.i DicStyle="table" b ;1                                          
	.q:(DicStyle="label")&&(HasChild=0)    //过滤掉label,并且没有子元素
	.i (DicStyle="label")&&(HasChild'=0) d //有子元素,获取子元素信息
	..d ##class(web.DHCADVSetAdvStatFied).JsonChildDic(pid,FormDicDr)  //临时globle存储数据
	.i (DicStyle="table")&&(HasChild'=0) d //table元素中获取子元素
	..d ##class(web.DHCADVSetAdvStatFied).JsonChildDic(pid,FormDicDr)  //临时globle存储数据
	.s ^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid,FormDicDr)=""
	//循环获取数据
	s Count=0
	;s RsTitle="FormDicID^DicField^DicStyle^DicDesc^DicUrl^DicParef^ValDr"
	s FormDicID=""
	f  s FormDicID = $o(^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid,FormDicID)) q:FormDicID=""  d
	.q:$d(^DHCADVSTF(0,"FormNameDic",ForNameID,FormDicID))'=0
	.s DicInfo = ##class(web.DHCADVSetAdvStatFied).GetDicItmInfo(FormDicID)
	.s DicField = $p(DicInfo,"^",2)   //唯一标示
	.s DicStyle= $p(DicInfo,"^",3)	   //元素类型
	.s DicDesc= $p(DicInfo,"^",4)	   //元素描述
	.s DicUrl= $p(DicInfo,"^",5)	   //元素路径
	.s DicParef  = $p(DicInfo,"^",6)  //父元素ID
	.
	.q:$$ALPHAUP^SSUTIL4(DicDesc)=""
	.q:$$ALPHAUP^SSUTIL4(DicDesc)="1"
	.q:$$ALPHAUP^SSUTIL4(DicDesc)="2"
	.
	.q:DicStyle="easyui-datebox" 
	.s IsTableFlag =##class(web.DHCADVSetAdvStatFied).GetIsTableItm(FormDicID)
	.s:IsTableFlag'=0 DicDesc = ##class(web.DHCADVEXPFIELD).GetTableDicParef(FormDicID)_":"_DicDesc
	.s:(+DicParef'=0)&&(IsTableFlag=0) DicDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)_":"_DicDesc
	.s:$p(DicDesc,":",1)="1" DicDesc = "压疮部位:"_$p(DicDesc,":",2)
	.s ValDr=""
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.;w ##class(web.DHCAPPJsonCommon).getJsonData(RsTitle,RsDate)
	.s dymObj={}
	.s dymObj.field = DicField
	.s dymObj.title = DicDesc
	.s dymObj.align = "center"
	.w dymObj.%ToJSON()
	w "]"
	q ""
}

/// 判断元素是否是table数据
ClassMethod GetIsTableItm(FormDicID)
{
	n (FormDicID)
	s Ret=0
	s DicParef  = $lg($g(^User.DHCAdvFormDicD(FormDicID)),6)   //父元素ID
	q:+DicParef=0 Ret
	s DicDesc= $lg(^User.DHCAdvFormDicD(DicParef),4)	   //元素描述
	s:$$ALPHAUP^SSUTIL4(DicDesc)="" Ret=1
	q Ret
}

/// w ##class(web.DHCADVSetAdvStatFied).JsonListGetSetFielVal(987)
ClassMethod JsonListGetSetFielVal(ForNameID)
{
	n (ForNameID)
	s Count=0
	w ##class(web.DHCADVJSONCOMMON).getJsonStartNoTotal()   //json前串
	w:ForNameID="" ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:ForNameID="" ""
	s RsStr = "STFVId^FormNameDr^FormDicDr^FeildDesc^FieldVal^FormDicDesc^FieldUom^FieldUomID"
	s STFVId=""
	f  s STFVId = $o(^DHCADVSTFV(0,"FormName",ForNameID,STFVId)) q:STFVId=""  d
	.;s ^DHCADVSTFV(11)="987^8818^测试数据^30"
	.s FormNameDr = $p(^DHCADVSTFV(STFVId),"^",1)
	.s FormDicDr = $p(^DHCADVSTFV(STFVId),"^",2)
	.s DicDesc= $lg(^User.DHCAdvFormDicD(FormDicDr),4)	   //元素描述
	.s FeildDesc = $p(^DHCADVSTFV(STFVId),"^",3)
	.s FieldVal = $p(^DHCADVSTFV(STFVId),"^",4)
	.s FieldUomID = $p(^DHCADVSTFV(STFVId),"^",5)
	.s FieldUom = $case(FieldUomID,1:"日",2:"月",3:"年")
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.s RsData = STFVId_"^"_FormNameDr_"^"_FormDicDr_"^"_FeildDesc_"^"_FieldVal_"^"_DicDesc_"^"_FieldUom_"^"_FieldUomID
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort(RsStr,RsData)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(Count)
	q ""
}

/// 字典维护表json获取
/// w ##class(web.DHCADVSetAdvStatFied).JsonListGetSetFiel(985)
ClassMethod JsonListGetSetFiel(ForNameID)
{
	n (ForNameID)
	s Count=0
	w ##class(web.DHCADVJSONCOMMON).getJsonStartNoTotal()   //json前串
	w:ForNameID="" ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:ForNameID="" ""
	s RsStr = "STFId^FormNameDr^FormDicDr^ValDr^DicField^DicStyle^DicDesc^DicUrl^DicParef"
	s STFId=""
	b ;err
	f  s STFId = $o(^DHCADVSTF(0,"FormName",ForNameID,STFId)) q:STFId=""  d
	.s FormNameDr = $p(^DHCADVSTF(STFId),"^",1)
	.s FormDicDr = $p(^DHCADVSTF(STFId),"^",2)
	.q:FormDicDr="" 
	.s DicInfo = ##class(web.DHCADVSetAdvStatFied).GetDicItmInfo(FormDicDr)
	.s DicField = $p(DicInfo,"^",2)   //唯一标示
	.s DicStyle= $p(DicInfo,"^",3)	   //元素类型
	.s DicDesc= $p(DicInfo,"^",4)	   //元素描述
	.s DicUrl= $p(DicInfo,"^",5)	   //元素路径
	.s DicParef  = $p(DicInfo,"^",6)  //父元素ID
	.s ValDr = $p(^DHCADVSTF(STFId),"^",3)
	.s:+DicParef'=0 DicDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)_":"_DicDesc
	.s:$p(DicDesc,":",1)="1" DicDesc = "压疮部位:"_$p(DicDesc,":",2)
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.s RsData = STFId_"^"_FormNameDr_"^"_FormDicDr_"^"_ValDr_"^"_DicField_"^"_DicStyle
	.s RsData = RsData_"^"_DicDesc_"^"_DicUrl_"^"_DicParef
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort(RsStr,RsData)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(Count)
	q ""
}

/// 判断Dic元素是否已经维护
ClassMethod HasItmInField(ForNameID, FormDicID)
{
	n (ForNameID,FormDicID)
	s ret = $d(^DHCADVSTF(0,"FormNameDic",ForNameID,FormDicID))
	q ret
}

/// 保存数据：自定义
/// w ##class(web.DHCADVSetAdvStatFied).Save("13^987^11111^测试数据^30")
ClassMethod Save(Params)
{
	n (Params)
	s ParamLen = $l(Params,"&&")
	ts
	s ret = 0
	f i=1:1:ParamLen q:ret'=0  d
	.s Param = $p(Params,"&&",i)
	.s STFVRowID=$p(Param,"^",1)
	.b ;1
	.s:STFVRowID="" ret = ##class(web.DHCADVSetAdvStatFied).InsItm(Param)
	.s:STFVRowID'="" ret = ##class(web.DHCADVSetAdvStatFied).UptItm(Param)
	
	i ret'=0 tro
	i ret=0 tc
	q ret
}

/// 保存数据：字典表
/// w ##class(web.DHCADVSetAdvStatFied).InsStatField(982,"发生科室^93567^&&事件类别^93373^&&事件经过^93376^&&原因分析^93378^")
ClassMethod InsStatField(FormNameID, Params)
{
	;DHC_AdvStatField
	n (FormNameID,Params)
	q:FormNameID="" "FormNameID没有给值"
	s ParamLen = $l(Params,"&&")
	ts
	s ret = 0
	f i=1:1:ParamLen q:ret'=0  d
	.s Param = $p(Params,"&&",i)
	.s ret = ##class(web.DHCADVSetAdvStatFied).InsStatFieldItm(FormNameID,Param)
	i ret'=0 tro
	i ret=0 tc
	q ret
}

/// 删除数据：字典表
/// w ##class(web.DHCADVSetAdvStatFied).InsStatField(982,"发生科室^93567^&&事件类别^93373^&&事件经过^93376^&&原因分析^93378^")
ClassMethod DelStatField(Params)
{
	n (Params)
	q:Params="" "Params没有给值"
	s ParamLen = $l(Params,"&&")
	ts
	s ret = 0
	f i=1:1:ParamLen q:ret'=0  d
	.s STFId = $p(Params,"&&",i)
	.s ret = ##class(web.DHCADVSetAdvStatFied).DelStatFieldItm(STFId)
	i ret'=0 tro
	i ret=0 tc
	q ret
}

/// 自定义类型：下拉框加载数据
/// w ##class(web.DHCADVSetAdvStatFied).GetStatFiedValComboBox(987)
ClassMethod GetStatFiedValComboBox(FormNameID)
{
	n (FormNameID)
	q:FormNameID="" "[]" 
	s Version = $o(^User.DHCAdvFormI("IndexNameVersion",FormNameID,""),-1)  //获取最后一个版本号
	w "["
	s Del="""",Count=0
	s FormID=0
	f  s FormID = $o(^User.DHCAdvFormI("IndexNameVersion",FormNameID,Version,FormID)) q:FormID=""  d
	.s FormType = $lg(^User.DHCAdvFormD(FormID),7)
	.q:FormType'="element"
	.s FormDicDr = $lg(^User.DHCAdvFormD(FormID),4)
	.q:FormDicDr="" 
	.s DicField = $lg(^User.DHCAdvFormDicD(FormDicDr),2)   //唯一标示
	.s DicStyle= $lg(^User.DHCAdvFormDicD(FormDicDr),3)	   //元素类型
	.s DicField= $lg(^User.DHCAdvFormDicD(FormDicDr),4)	   //元素描述
	.s DicUrl= $lg(^User.DHCAdvFormDicD(FormDicDr),6)	   //元素路径
	.s DicParef  = $lg(^User.DHCAdvFormDicD(FormDicDr),7)  //父元素ID
	.q:DicStyle'="easyui-datebox"    //过滤掉非时间控件
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.s RsDate = FormDicDr_"^"_DicField
	.w ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",RsDate)
	w "]"

	q ""
}

/// w ##class(web.DHCADVSetAdvStatFied).IsHasChildDic(93442)
ClassMethod IsHasChildDic(FormDicID)
{
	n (FormDicID)
	s ret=""
	s FormDicID = $o(^User.DHCAdvFormDicI("IndexParef"," "_FormDicID,""))
	q +FormDicID
}

/// w ##class(web.DHCADVSetAdvStatFied).JsonChildDic(1,93906)
ClassMethod JsonChildDic(pid, FormDicID)
{
	n (pid,FormDicID)
	q:FormDicID="" ""
	s ^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid,FormDicID)=""
	s DicID =0
	f  s DicID = $o(^User.DHCAdvFormDicI("IndexParef"," "_FormDicID,DicID)) q:DicID=""  d   //子元素
	.s ^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid,DicID)=""
	.s HasFlag = ##class(web.DHCADVSetAdvStatFied).IsHasChildDic(DicID)
	.d:+HasFlag'=0 ##class(web.DHCADVSetAdvStatFied).JsonChildDic(pid,DicID)   //递归:注意容易出死循环
	q ""
}

/// 获取dic元素的信息
/// w ##class(web.DHCADVSetAdvStatFied).GetDicItmInfo(94247)
ClassMethod GetDicItmInfo(FormDicID)
{
	n (FormDicID)
	q:FormDicID="" ""
	s DicField = $lg(^User.DHCAdvFormDicD(FormDicID),2)    //唯一标示
	s DicStyle= $lg(^User.DHCAdvFormDicD(FormDicID),3)	   //元素类型
	s DicDesc= $lg(^User.DHCAdvFormDicD(FormDicID),4)	   //元素描述
	s DicUrl= $lg(^User.DHCAdvFormDicD(FormDicID),5)	   //元素路径
	s DicParef  = $lg(^User.DHCAdvFormDicD(FormDicID),6)   //父元素ID
	s ret  = FormDicID_"^"_DicField_"^"_DicStyle_"^"_DicDesc_"^"_DicUrl_"^"_DicParef
	q ret
}

}
