Import sqluser

/// 不良事件导出元素字典维护
Class web.DHCADVEXPFIELD Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 报告类型combobox数据获取(DHC_MedAdrRepEvent表)
/// Creator:     CongYue
/// CreateDate:  2017-12-27
/// Input:  	 
/// Return: 	 受害者类型(下拉框) 信息
/// Others:		 w ##class(web.DHCADVEXPFIELD).JsonGetRepotType()
ClassMethod JsonGetRepotType(HospDr = "")
{
	s AdrEvtDr=0,Count=0
	w "["
	f  s AdrEvtDr = $o(^DHCMEDADREVT(AdrEvtDr)) q:AdrEvtDr=""  d
	.s RepTypeID = AdrEvtDr
	.s RepTypeCode = $P($g(^DHCMEDADREVT(AdrEvtDr)),"^",1)
	.Q:##class(web.DHCADVFormName).CheckFormName(RepTypeCode,HospDr)'=1
	.S RepTypeActiveFlag=$p(^DHCMEDADREVT(RepTypeID),"^",3)
	.Q:RepTypeActiveFlag="N"
	.S CH=""
	.F  S CH=$o(^DHCMEDADREVTI(RepTypeID,"MADREVI",CH)) Q:CH=""  D
	..S Code=$p(^DHCMEDADREVTI(RepTypeID,"MADREVI",CH),"^",1) //代码
	..Q:##class(web.DHCADVFormName).CheckFormName(Code,HospDr)'=1
	..S Desc=$p(^DHCMEDADREVTI(RepTypeID,"MADREVI",CH),"^",2) //描述
	..S Active=$p(^DHCMEDADREVTI(RepTypeID,"MADREVI",CH),"^",3) //是否可用
	..Q:Active="N"
	..Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(Code)))
	..s FormNameDr = $o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(Code),""))
	..q:+FormNameDr=0
	..s ForNameType = $lg(^User.DHCAdvFormNameD(FormNameDr),6)  //type
	..q:ForNameType'="Y"
	..s ForNameDesc = $lg(^User.DHCAdvFormNameD(FormNameDr),3)
	..s RsDate = FormNameDr_"^"_ForNameDesc
	..w $case(Count,0:"",:",")
	..s Count = Count+1
	..w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsDate)
	.Q:($d(^DHCMEDADREVTI(RepTypeID,"MADREVI")))  ;去除带有子元素的类型
	.Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(RepTypeCode)))  ;去除不是表单的类型
	.s FormNameDr = $o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(RepTypeCode),""))
	.q:+FormNameDr=0
	.s ForNameType = $lg(^User.DHCAdvFormNameD(FormNameDr),6)  //type
	.q:ForNameType'="Y"
	.s ForNameDesc = $lg(^User.DHCAdvFormNameD(FormNameDr),3)
	.
	.s RsDate = FormNameDr_"^"_ForNameDesc
	.w $case(Count,0:"",:",")
	.s Count = Count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsDate)
	w "]"
	q ""
}

/// Description: 报告表单信息
/// Creator:     CongYue
/// CreateDate:  2017-12-27
/// Input:  	 报告表单ID
/// Return: 	 报告表单信息
/// Others:		 w ##class(web.DHCADVEXPFIELD).GetAllItmByFormID(983)
ClassMethod GetAllItmByFormID(LinkID)
{
	n (LinkID)
	s pid = ##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVEXPFIELD","GetAllItmByFormID",pid)
	w ##class(web.DHCADVJSONCOMMON).getJsonStartNoTotal()
	w:LinkID="" ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:LinkID="" ""
	s ForNameID=""
	s FormNameCode=$lg(^User.DHCAdvExpFieldLinkD(LinkID),4)
	s:FormNameCode'="" ForNameID=$o(^User.DHCAdvFormNameI("IndexCode",##class(web.DHCADVAction).ALPHAUP(FormNameCode),""))
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
	.s HasChild = ##class(web.DHCADVEXPFIELD).IsHasChildDic(FormDicDr)  
	.s DicInfo = ##class(web.DHCADVEXPFIELD).GetDicItmInfo(FormDicDr)   
	.s DicStyle= $p(DicInfo,"^",3)	   //元素类型                                                
	.q:(DicStyle="label")&&(HasChild=0)    //过滤掉label,并且没有子元素
	.i ((DicStyle="label")||(DicStyle="table"))&&(HasChild'=0) d //有子元素,获取子元素信息
	..d ##class(web.DHCADVEXPFIELD).JsonChildDic(pid,FormDicDr)  //临时globle存储数据
	.s ^TMP("DHCADV","web.DHCADVEXPFIELD","GetAllItmByFormID",pid,FormDicDr)=""
	
	//循环获取数据
	s Count=0
	s RsTitle="FormDicID^DicField^DicStyle^DicDesc^DicUrl^DicParef^ValDr"
	s FormDicID=""
	f  s FormDicID = $o(^TMP("DHCADV","web.DHCADVEXPFIELD","GetAllItmByFormID",pid,FormDicID)) q:FormDicID=""  d
	.s DicInfo = ##class(web.DHCADVEXPFIELD).GetDicItmInfo(FormDicID)
	.s DicField = $p(DicInfo,"^",2)   //唯一标示
	.q:$d(^DHCADVEXPF(0,"LinkDicCode",LinkID,DicField))'=0
	.s DicStyle= $p(DicInfo,"^",3)	   //元素类型
	.s DicDesc= $p(DicInfo,"^",4)	   //元素描述
	.s:DicDesc["<span" DicDesc=$p(DicDesc,"<span",1)
	.s:DicDesc["&nbsp" DicDesc=$p(DicDesc,"&nbsp",1)
	.s DicUrl= $p(DicInfo,"^",5)	   //元素路径
	.s DicParef  = $p(DicInfo,"^",6)  //父元素ID
	.q:($$ALPHAUP^SSUTIL4(DicDesc)="")&&(DicStyle="label")
	.s testDesc=..GetTableDicParef(FormDicID)
	.s:+DicParef'=0 DicDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)_":"_DicDesc
	.S:testDesc'="" DicDesc = testDesc_DicDesc
	.s ValDr=""
	.s RsDate = FormDicID_"^"_DicField_"^"_DicStyle_"^"_DicDesc_"^"_DicUrl_"^"_DicParef_"^"_ValDr
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort(RsTitle,RsDate)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(Count)
	q ""
}

/// w ##class(web.DHCADVEXPFIELD).IsHasChildDic(93442)
ClassMethod IsHasChildDic(FormDicID)
{
	n (FormDicID)
	s ret=""
	s FormDicID = $o(^User.DHCAdvFormDicI("IndexParef"," "_FormDicID,""))
	q +FormDicID
}

/// w ##class(web.DHCADVEXPFIELD).JsonChildDic(1,93624)
ClassMethod JsonChildDic(pid, FormDicID)
{
	n (pid,FormDicID)
	q:FormDicID="" ""
	s ^TMP("DHCADV","web.DHCADVEXPFIELD","GetAllItmByFormID",pid,FormDicID)=""
	s DicID =0
	f  s DicID = $o(^User.DHCAdvFormDicI("IndexParef"," "_FormDicID,DicID)) q:DicID=""  d   //子元素
	.s ^TMP("DHCADV","web.DHCADVEXPFIELD","GetAllItmByFormID",pid,DicID)=""
	.s HasFlag = ##class(web.DHCADVEXPFIELD).GetDicItmInfo(DicID)
	.d:+HasFlag'=0 ##class(web.DHCADVEXPFIELD).JsonChildDic(pid,DicID)   //递归:注意容易出死循环
	q ""
}

/// 获取dic元素的信息
/// w ##class(web.DHCADVEXPFIELD).GetDicItmInfo(94247)
ClassMethod GetDicItmInfo(FormDicID)
{
	n (FormDicID)
	q:FormDicID="" ""
	q:'$d(^User.DHCAdvFormDicD(FormDicID)) ""
	s DicField = $lg(^User.DHCAdvFormDicD(FormDicID),2)    //唯一标示
	s DicStyle= $lg(^User.DHCAdvFormDicD(FormDicID),3)	   //元素类型
	s DicDesc= $lg(^User.DHCAdvFormDicD(FormDicID),4)	   //元素描述
	s DicUrl= $lg(^User.DHCAdvFormDicD(FormDicID),5)	   //元素路径
	s DicParef  = $lg(^User.DHCAdvFormDicD(FormDicID),6)   //父元素ID
	s ret  = FormDicID_"^"_DicField_"^"_DicStyle_"^"_DicDesc_"^"_DicUrl_"^"_DicParef
	q ret
}

/// Description: 保存[导出元素]
/// Creator:     CongYue
/// CreateDate:  2017-12-27
/// Table:		 DHC_AdvExpField
/// Input:  	 Params:以字符"&&"分割,格式为:FormDicCode&&FormDicCode LinkID:模板id
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEXPFIELD).SaveExpField("EventInforpanel",1)
ClassMethod SaveExpField(Params As %String, LinkID As %String) As %String
{
	N (Params,LinkID)
	S Err=0
	S len=$L(Params,"&&")
	F i=1:1:len D
	.S FormDicCode=$p(Params,"&&",i)
	.S Err=..InsExpField(FormDicCode,LinkID)
	Q Err
}

/// Description: 增加[导出元素]
/// Creator:     CongYue
/// CreateDate:  2017-12-27
/// Table:		 DHC_AdvExpField
/// Input:  	 
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEXPFIELD).InsExpField("^1^填报^填报")
ClassMethod InsExpField(FormDicCode As %String, LinkID As %String) As %String
{
	N (FormDicCode,LinkID)
	S num=$o(^DHCADVEXPF(0,"Linknum",LinkID,""),-1)+10   ;添加num索引，获取新的num数
 	&SQL(INSERT INTO DHC_AdvExpField(ADVEXPF_Link_Dr, ADVEXPF_FormDicCode,ADVEXPF_num)
 		 VALUES(:LinkID,:FormDicCode,:num))
 	Q SQLCODE
}

/// Description: 删除[导出元素]
/// Creator:     CongYue
/// CreateDate:  2017-12-28
/// Table:		 DHC_AdvExpField
/// Input:  	 
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEXPFIELD).DelExpField("^1^填报^填报")
ClassMethod DelExpField(Params)
{
	n (Params)
	q:Params="" "Params没有给值"
	s ParamLen = $l(Params,"&&")
	ts
	s ret = 0
	f i=1:1:ParamLen q:ret'=0  d
	.s ExpFieldID = $p(Params,"&&",i)
	.s ret = ##class(web.DHCADVEXPFIELD).DelExpFieldData(ExpFieldID)
	i ret'=0 tro
	i ret=0 tc
	q ret
}

/// 删除数据：字典表
/// 
ClassMethod DelExpFieldData(ExpFieldID)
{
	n (ExpFieldID)
	q:ExpFieldID="" 0
	&sql(DELETE FROM DHC_AdvExpField WHERE ADVEXPF_RowID = :ExpFieldID)
	Q SQLCODE
}

/// Description: 更新导出元素序号
/// Creator:     CongYue
/// CreateDate:  2017-12-27
/// Table:		 DHC_AdvExpField
/// Input:  	 input:id^顺序号^id^顺序号
/// Return: 	 更新成功 0,更新失败 非0
/// Others:		 w ##class(web.DHCADVEXPFIELD).UpdExpFieldNum("1||2^1^1||1^2")
ClassMethod UpdExpFieldNum(input) As %String
{
	N (input)
	S currowid=$p(input,"^",1)
	S curordernum=$p(input,"^",2)
	S lastrowid=$p(input,"^",3)
	S lastordernum=$p(input,"^",4)
	S curordernum=$p(^DHCADVEXPF(lastrowid),"^",3)
	S lastordernum=$p(^DHCADVEXPF(currowid),"^",3)
	tstart
	&sql(update DHC_AdvExpField  set ADVEXPF_num=:curordernum where ADVEXPF_RowID=:currowid)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 -1
	&sql(update DHC_AdvExpField  set ADVEXPF_num=:lastordernum where ADVEXPF_RowID=:lastrowid)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 -2
	tcommit
	
	Q 0
}

/// 字典维护表json获取
/// w ##class(web.DHCADVEXPFIELD).GetSetFiel(983)
ClassMethod GetSetFiel(LinkID)
{
	n (LinkID,%session)
	s Count=0
	s pid = ##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVEXPFIELD","GetSetFiel",pid)
	w ##class(web.DHCADVJSONCOMMON).getJsonStartNoTotal()
	w:LinkID="" ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:LinkID="" ""
	s FormNameDr=""
	s FormNameCode=$lg(^User.DHCAdvExpFieldLinkD(LinkID),4)
	s:FormNameCode'="" FormNameDr=$o(^User.DHCAdvFormNameI("IndexCode",##class(web.DHCADVAction).ALPHAUP(FormNameCode),""))
	s RsStr = "RowID^FormNameDr^FormDicDr^num^DicField^DicStyle^DicDesc^DicUrl^DicParef^LinkID"
	s RowID=""
	f  s RowID = $o(^DHCADVEXPF(0,"Link",LinkID,RowID)) q:RowID=""  d
	.s FormDicDr =""
	.s FormDicCode = $p(^DHCADVEXPF(RowID),"^",4)
	.s:FormDicCode'="" FormDicDr=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(FormDicCode),""))
	.q:FormDicDr="" 
	.s DicInfo = ##class(web.DHCADVEXPFIELD).GetDicItmInfo(FormDicDr)
	.s DicField = $p(DicInfo,"^",2)   //唯一标示
	.s DicStyle= $p(DicInfo,"^",3)	   //元素类型
	.s DicDesc= $p(DicInfo,"^",4)	   //元素描述
	.s:DicDesc["<span" DicDesc=$p(DicDesc,"<span",1)
	.s DicDesc=##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",DicDesc)  ;2020-06-28 cy
	.s DicUrl= $p(DicInfo,"^",5)	   //元素路径
	.s DicParef  = $p(DicInfo,"^",6)  //父元素ID
	.s num = $p(^DHCADVEXPF(RowID),"^",3)
	.s DicParefDesc=""
	.s:+DicParef'=0 DicParefDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)
	.s:DicParefDesc["<span" DicParefDesc=$p(DicParefDesc,"<span",1)
	.s:DicParefDesc["&nbsp" DicParefDesc=$p(DicParefDesc,"&nbsp",1)
	.s DicParefDesc=##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",DicParefDesc)  ;2020-06-28 cy
	.s:DicParefDesc'="" DicDesc = DicParefDesc_":"_DicDesc
	.s len=$L(DicField,"-")
	.s:DicField="UlcerPart-95158-95162-95192" DicDesc ="压疮发现日期"
	.s:DicField="UlcerPart-95158-95189-94247" DicDesc ="压疮面积长"
	.s:DicField="UlcerPart-95158-95189-94249" DicDesc ="压疮面积宽"
	.s:DicField="UlcerPart-95158-95189-94251" DicDesc ="压疮面积深"
	.s:(len=4)&&(DicField["UlcerPart-95158-95163-") DicDesc ="压疮来源"_DicDesc
	.s:(len=4)&&(DicField["UlcerPart-95158-95166-") DicDesc ="压疮部位"_DicDesc
	.s:(len=4)&&(DicField["UlcerPart-95158-95169-") DicDesc ="压疮分期"_DicDesc
	.s RsData = RowID_"^"_FormNameDr_"^"_FormDicDr_"^"_num_"^"_DicField_"^"_DicStyle
	.s RsData = RsData_"^"_DicDesc_"^"_DicUrl_"^"_DicParef_"^"_LinkID
	.s ^TMP("DHCADV","web.DHCADVEXPFIELD","GetSetFiel",pid,num)=RsData
	
	s index=""
	f  s index = $o(^TMP("DHCADV","web.DHCADVEXPFIELD","GetSetFiel",pid,index)) q:index=""  d
	.s List  =^TMP("DHCADV","web.DHCADVEXPFIELD","GetSetFiel",pid,index)
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort(RsStr,List)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(Count)
	q ""
}

ClassMethod GetTableDicParef(id As %String) As %String
{
	;s dic=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,"")) 
	s parref1=$lg(^User.DHCAdvFormDicD(id),6)
	q:+parref1=0 ""
	s parref2=$lg(^User.DHCAdvFormDicD(parref1),6)
	q:+parref2=0 ""
	s exitflag=0,tmpsubnum=0
	s tmpsub=""
	f  s tmpsub=$o(^User.DHCAdvFormDicI("IndexParef"," "_parref2,tmpsub)) q:(tmpsub="")||(exitflag=1)  d
	.s tmpsubnum=tmpsubnum+1
	.i tmpsub=parref1 d
	..s exitflag=1
	.q:exitflag=1
	
	s parref2=$lg(^User.DHCAdvFormDicD(parref1),6)
	s parref3=$lg(^User.DHCAdvFormDicD(parref2),6)
	q:+parref3=0 ""
	s dicdesc=""
	s tmpsubnum2=0
	s dic=$o(^User.DHCAdvFormDicI("IndexParef"," "_parref3,""))
	q:dic="" ""
	s tmpsub="" 
	f  s tmpsub=$o(^User.DHCAdvFormDicI("IndexParef"," "_dic,tmpsub)) q:(tmpsub="")||(dicdesc'="")  d  
	.s tmpsubnum2=tmpsubnum2+1
	.i tmpsubnum=tmpsubnum2 d 
	..s dicdesc=$lg(^User.DHCAdvFormDicD(tmpsub),4)
	.q:dicdesc'="" 
	
	q dicdesc
}

/// Descript:	 取表单和子表单，分类为不良事件，可用标志为Y
/// CreaDate：   2019-07-04
/// Return: 	 报告信息
/// Others:		 w ##class(web.DHCADVEXPFIELD).getRepType()
ClassMethod getRepType(HospDr = "")
{
	s FormNameId=""
	s count=0
	w "["
	for  s FormNameId=$o(^User.DHCAdvFormNameD(FormNameId))  Q:FormNameId=""  d
	.s ActiveFlag=$List(^User.DHCAdvFormNameD(FormNameId),8)
	.Q:ActiveFlag'="Y"
	.s CatId=+$List(^User.DHCAdvFormNameD(FormNameId),7)
	.s FormHospDr=$lg(^User.DHCAdvFormNameD(FormNameId),10)
	.s FormCode=$lg(^User.DHCAdvFormNameD(FormNameId),2)
	.;q:(FormHospDr'="")&&(HospDr'="")&&(FormHospDr'=HospDr)
	.q:##class(web.DHCADVFormName).CheckFormName(FormCode,HospDr)=0
	.s CatCode=""
	.i CatId'="0" s CatCode=$List(^User.DHCAdvFormCatD(CatId),2)
	.Q:(CatCode'="")&&(CatCode'="DHCADV")
	.s Name=$List(^User.DHCAdvFormNameD(FormNameId),3)
	.s ListData=FormNameId_"^"_Name
	.w $case(count,0:"",:",")
	.s count=count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",ListData)
	w "]"
	Q ""
}

/// Descript:	 取表单元素
/// CreaDate：   2019-06-27
/// Input:  	 报告表单ID
/// Return: 	 报告表单信息
/// Others:		 w ##class(web.DHCADVEXPFIELD).QueryAllItmByFormID("30","1","994","")
ClassMethod QueryAllItmByFormID(rows As %String, page As %String, ForNameID As %String, Input As %String = "")
{
	n (rows,page,ForNameID,Input)
	s ^temptest("ForNameID")=$lb(rows,page,ForNameID,Input)
	s Input=$$ALPHAUP^SSUTIL4(Input)
	s end=page*rows
	s start=(page-1)*rows+1
	s h=0,count=0
	s pid = ##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid)
	q:ForNameID="" ##class(web.DHCADVJSONCOMMON).GetNoJson()
	s Version = $o(^User.DHCAdvFormI("IndexNameVersion",ForNameID,""),-1)  //获取最后一个版本号
	s Del=""""
	s FormID=0
	f  s FormID = $o(^User.DHCAdvFormI("IndexNameVersion",ForNameID,Version,FormID)) q:FormID=""  d
	.s FormType = $lg(^User.DHCAdvFormD(FormID),7)
	.q:FormType'="element"
	.s FormDicDr = $lg(^User.DHCAdvFormD(FormID),4)
	.q:FormDicDr="" 
	.s HasChild = ##class(web.DHCADVEXPFIELD).IsHasChildDic(FormDicDr)  
	.s DicInfo = ##class(web.DHCADVEXPFIELD).GetDicItmInfo(FormDicDr)  
	.s DicStyle= $p(DicInfo,"^",3)	  		 							//元素类型                                                
	.q:(DicStyle="label")&&(HasChild=0)    						 		//过滤掉label,并且没有子元素
	.s DicField = $p(DicInfo,"^",2)   									//唯一标示
	.s DicStyle= $p(DicInfo,"^",3)	   									//元素类型
	.s DicDesc= $p(DicInfo,"^",4)	  							 		//元素描述
	.s:DicDesc["<span" DicDesc=$p(DicDesc,"<span",1)
	.s:DicDesc["&nbsp" DicDesc=$p(DicDesc,"&nbsp",1)
	.s DicUrl= $p(DicInfo,"^",5)	   									//元素路径
	.s DicParef  = $p(DicInfo,"^",6)  									//父元素ID
	.q:($$ALPHAUP^SSUTIL4(DicDesc)="")&&(DicStyle="label")
	.s testDesc=..GetTableDicParef(FormDicDr)
	.s:+DicParef'=0 DicDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)_":"_DicDesc
	.S:testDesc'="" DicDesc = testDesc_DicDesc
	.i ((DicStyle="label")||(DicStyle="table"))&&(HasChild'=0) d 		//有子元素,获取子元素信息
	..d ##class(web.DHCADVEXPFIELD).JsonChildDicNew(pid,FormDicDr)  	//临时globle存储数据
	.s h=h+1
	.s ListData=DicField_"^"_DicDesc
	.s ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,FormDicDr)=ListData
	
	s FormCode=$List(^User.DHCAdvFormNameD(ForNameID),2)    ///此处单独存储医疗评估界面的字段
	d ..StoreTempData(pid,FormCode)
	q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///取医疗不良事件评估的内容
	
	//循环获取数据
	s RsTitle="DicField^DicDesc",Count=0
	;w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	w ##class(web.DHCADVJSONCOMMON).getJsonStartNoTotal()
	s FormDicID=""
	f  s FormDicID = $o(^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,FormDicID)) q:FormDicID=""  d
	.s mdata=^(FormDicID)
	.s DicField=$p(mdata,"^",1)
	.s DicDesc=$p(mdata,"^",2)
	.s DicCode=##class(web.DHCINSUPort).GetCNCODE(DicDesc,4,"")
	.Q:(Input'="")&&((DicDesc'[Input)&&(DicCode'[Input))
	.s count=count+1
	.s RsDate = DicField_"^"_DicDesc
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(RsTitle,RsDate)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(RsTitle,RsDate)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(count)
	;w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	k ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid)

	q ""
}

/// w ##class(web.DHCADVEXPFIELD).JsonChildDic(1,93624)
ClassMethod JsonChildDicNew(pid, FormDicID)
{
	n (pid,FormDicID)
	q:FormDicID="" ""
	s DicID =0
	f  s DicID = $o(^User.DHCAdvFormDicI("IndexParef"," "_FormDicID,DicID)) q:DicID=""  d   //子元素
	.s HasFlag = ##class(web.DHCADVEXPFIELD).GetDicItmInfo(DicID)
	.s DicField = $p(HasFlag,"^",2)   									//唯一标示
	.s DicStyle= $p(HasFlag,"^",3)	   									//元素类型
	.s DicDesc= $p(HasFlag,"^",4)	  							 		//元素描述
	.s:DicDesc["<span" DicDesc=$p(DicDesc,"<span",1)
	.s:DicDesc["&nbsp" DicDesc=$p(DicDesc,"&nbsp",1)
	.s DicUrl= $p(HasFlag,"^",5)	   									//元素路径
	.s DicParef  = $p(HasFlag,"^",6)  									//父元素ID
	.q:($$ALPHAUP^SSUTIL4(DicDesc)="")&&(DicStyle="label")
	.s testDesc=..GetTableDicParef(DicID)
	.s:+DicParef'=0 DicDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)_":"_DicDesc
	.S:testDesc'="" DicDesc = testDesc_DicDesc
	.s ListData=DicField_"^"_DicDesc
	.s ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,DicID)=ListData
	.d:+HasFlag'=0 ##class(web.DHCADVEXPFIELD).JsonChildDicNew(pid,DicID)   //递归:注意容易出死循环
	q ""
}

/// Descript:存储非表单元素的字段数据  
/// Input：表单code
ClassMethod StoreTempData(pid, FormCode)
{
	n (pid,FormCode)
	s ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,"PrintId")="PrintDate^打印日期"
	s ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,"PrintUserId")="PrintUser^打印人"
	s ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,"HospId")="HospDesc^医院描述"
	if FormCode="advMedical"  d     //存储医疗评估的字段
	.s ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,"AsseLevId")="AsseLevel^不良事件等级"
	.s ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,"DealId")="AsseDealW^处理办法"
	.s ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,"ImpId")="AsseImpW^改进办法"
	.s ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,"StaOpinId")="AsseStaOpin^主管部门意见陈述"
	.s ^TMP("DHCADV","web.DHCADVEXPFIELD","QueryAllItmByFormID",pid,"impmeaId")="AsseConimpmea^持续改进措施"
}

/// Descript:	 取表单和子表单，分类为不良事件，可用标志为Y
/// CreaDate：   2019-09-03
/// Return: 	 报告信息
/// Others:		 w ##class(web.DHCADVEXPFIELD).getRepTypeNew()
ClassMethod getRepTypeNew()
{
	s FormNameId=""
	s Name=""
}

/// Description: 保存[导出模板名称Link]
/// Creator:     CongYue
/// CreateDate:  2021-07-07
/// Table:		 DHC_AdvExpFieldLink
/// Input:  	 Params:以字符"&&"分割,格式为:FormDicID&&FormDicID
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEXPFIELD).SaveExpFieldLink("1||1^1^填报^填报")
ClassMethod SaveExpFieldLink(Params As %String, HospDr As %String) As %String
{
	N (Params,HospDr)
  	S $Zt="Err"
  	TStart
  	S Ret=0
  	S Len=$l(Params,"$$")
  	F i=1:1:Len D
  	.Q:Ret<0
  	.S Str=$p(Params,"$$",i)
  	.S Ret=..SaveOrUpdateLink(Str,HospDr)
	I Ret'=0 TRollback
	Q:Ret'=0 Ret
	TCOMMIT
	Q Ret
Err
	TRollback
	w $ze
	Q -1
}

/// Description: 增加修改[导出模板名称Link]
/// Creator:     CongYue
/// CreateDate:  2021-07-07
/// Table:		 DHC_AdvExpFieldLink
/// Input:  	 
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEXPFIELD).SaveOrUpdateLink("^1^1^填报")
ClassMethod SaveOrUpdateLink(DataList As %String, HospDr As %String) As %String
{
	N (DataList,HospDr)
	S ID=+$p(DataList,"^",1)
	S Code=$p(DataList,"^",2)
	S Desc=$p(DataList,"^",3)
	S FormNameCode=$p(DataList,"^",4)
	S TmpID=$o(^User.DHCAdvExpFieldLinkI("IndexCode",##class(web.DHCADVAction).ALPHAUP(Code),""))
	//新增
	Q:(ID=0)&&(+TmpID'=0) 11
	//修改
	Q:(ID'=0)&&(+TmpID'=0)&&(+TmpID'=ID) 12
	I +ID=0 D
	.S obj=##class(User.DHCAdvExpFieldLink).%New()
	E  D
	.S obj=##class(User.DHCAdvExpFieldLink).%OpenId(ID)
	.D obj.%Reload()
	S obj.LinkCode=Code
	S obj.LinkDesc=Desc
	S obj.FormNameCode=FormNameCode
	S sc=obj.%Save()
	I $$$ISERR(sc) Q -2
	S DataID=obj.%Id()
	S hospflag=##Class(web.DHCADVCOMMON).SaveHOSP("DHC_AdvExpFieldLink",DataID,HospDr)
	Q:hospflag'=0 -3
	Q 0
}

/// Description: 删除[导出模板名称Link]
/// Creator:     CongYue
/// CreateDate:  2021-07-07
/// Table:		 DHC_AdvExpFieldLink
/// Input:  	 
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEXPFIELD).DelExpFieldLink("")
ClassMethod DelExpFieldLink(ID)
{
	N (ID)
  	S $Zt="DelErr"
	TS
	
	// 删除导出模板表数据
	&SQL(Delete From DHC_AdvExpFieldLink Where ID=:ID)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 SQLCODE
	
	// 删除导出模板明细表数据
	I $d(^DHCADVEXPF(0,"Link",ID)) D
	.&SQL(Delete From DHC_AdvExpField Where ADVEXPF_Link_Dr=:ID)
	I +$g(SQLCODE)'=0 tro
	Q:+$g(SQLCODE)'=0 SQLCODE
	
	// 删除多院区绑定数据
	S hospflag=##Class(web.DHCADVCOMMON).DeleteHospitals("DHC_AdvExpFieldLink",ID)
	I hospflag'=1 tro
	Q:hospflag'=1 -3

	TC
	Q 0
DelErr
	TRollback
	w $ze
	Q -1
}

/// Description: 查询[导出模板名称Link]
/// Creator:     CongYue
/// CreateDate:  2021-07-07
/// Table:		 DHC_AdvExpFieldLink
/// Input:  	 
/// Return: 	 导出模板信息
/// Others:		 w ##class(web.DHCADVEXPFIELD).GetLinkList("1","10","","2")
ClassMethod GetLinkList(page = 1, rows = 10, FormNameID = "", HospDr = "")
{
	N (page,rows,FormNameID,HospDr)
	;s ^TMP("ss")=$lb(rows,page,FormNameID,HospDr)
	S End = page*rows
	S Start=(page-1)*rows+1
	S count=0,ID=""
	W "{""rows"":["
	F  S ID=$o(^User.DHCAdvExpFieldLinkD(ID)) q:ID=""  d
	.Q:+ID=0
	.S Data=^User.DHCAdvExpFieldLinkD(ID)
	.S Code=$lg(Data,2)
	.S Desc=$lg(Data,3)
	.S FormNameCode=$lg(Data,4)
	.S FormNameDr=$o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(FormNameCode),""))   /// 表单ID
	.Q:(FormNameID'="")&&(FormNameDr'="")&&(FormNameDr'=FormNameID)
	.S FormNameData=^User.DHCAdvFormNameD(FormNameDr)
	.S FormNameDesc=$List(FormNameData,3)
	.Q:(FormNameCode'="")&&(##class(web.DHCADVFormName).CheckFormName(FormNameCode,HospDr)'=1)
	.Q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("DHC_AdvExpFieldLink",ID,HospDr,"")'="Y"
	.S count=count+1
	.Q:count<Start
	.Q:count>End
	.W $case(count,Start:"",:",")
	.W "{"
	.W """ID"":"_ID_","
	.W """Code"":"""_Code_""","
	.W """Desc"":"""_Desc_""","
	.W """FormNameCode"":"""_FormNameCode_""","
	.W """FormNameDesc"":"""_FormNameDesc_""""
	.W "}"
	W "],""total"":"_count_"}"
	Q ""
}

/// Description: 根据表单ID获取匹配的导出模板id
/// Creator:     CongYue
/// CreateDate:  2021-07-09  
/// Table:		 DHC_AdvFormName ,DHC_AdvExpFieldLink ,
/// Input:   	 表单ID
/// Output:  	 元素value值 
/// Others:		 w ##class(web.DHCADVEXPFIELD).GetExpLinkID("983",2)
ClassMethod GetExpLinkID(FormNameDr, HospDr) As %String
{
	N (FormNameDr,HospDr)
	S LinkID="",Flag=0
	Q:FormNameDr="" LinkID
	S FormNameData=^User.DHCAdvFormNameD(FormNameDr)
	S FormNameCode=$LG(FormNameData,2)
	Q:FormNameCode="" LinkID
	S ID=""
	F  S ID=$o(^User.DHCAdvExpFieldLinkI("IndexFormNameCode",##class(web.DHCADVAction).ALPHAUP(FormNameCode),ID)) Q:+ID=0  D
	.Q:LinkID'=""	
	.b ;cy01
	.Q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("DHC_AdvExpFieldLink",ID,HospDr,"")'="Y"
	.S LinkID=ID
	
	Q LinkID
}

}
