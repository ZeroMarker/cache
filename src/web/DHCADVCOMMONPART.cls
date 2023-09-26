Import sqluser

/// 不良事件升级 公共类
Class web.DHCADVCOMMONPART Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 受害者类型(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 受害者类型(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryVictimtypeCombo()
ClassMethod QueryVictimtypeCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","患者").Put("text","患者"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","员工").Put("text","员工"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","患者家属").Put("text","患者家属"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","实习生").Put("text","实习生"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","进修生").Put("text","进修生"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","访客").Put("text","访客"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","护工").Put("text","护工"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","保洁员").Put("text","保洁员"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","其他").Put("text","其他"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","无").Put("text","无"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 患者性别(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-11-28
/// Input:  	 
/// Return: 	 患者性别(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryPatSexCombo()
ClassMethod QueryPatSexCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  s SexDr=""
  F  S SexDr=$o(^CT("SEX",SexDr)) Q:SexDr=""  D
  .S SexDesc=$p(^CT("SEX",SexDr),"^",2) //描述
  .S StDate=$p(^CT("SEX",SexDr),"^",4) 		//有效期 开始日期 //qunianpeng 2017/12/29 增加对性别有效期的判断
  .S EndDate=$p(^CT("SEX",SexDr),"^",5) 	//有效期 接收日期
  .Q:(StDate'="")&&(StDate>$h)
  .Q:(StDate'="")&&(EndDate'="")&&((StDate>$h)||(EndDate<$h))  
  .D listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",SexDesc).Put("text",SexDesc))
  W jsonObj.ListToJson(listObj)
  Q ""
}

/// Description: 是否(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 是否(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryWhetherCombo()
ClassMethod QueryWhetherCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 就诊形式(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 就诊形式(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryAdmTypeCombo()
ClassMethod QueryAdmTypeCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","I").Put("text","住院"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","O").Put("text","门诊"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","E").Put("text","急诊"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 发生日期类型(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 发生日期类型(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryDateTypeCombo()
ClassMethod QueryDateTypeCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","工作日").Put("text","工作日"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","周末").Put("text","周末"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","节日之一").Put("text","节日之一"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 科室(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 科室(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryLocDescCombo("12")
ClassMethod QueryLocDescCombo(hospId, q)
{
  N (hospId,q,%session)
  S q=$$ALPHAUP^SSUTIL4(q)
  S jsonObj=##class(web.DHCAPPJsonObject).%New()
  S listObj=##class(%ListOfObjects).%New()
  S LocDr="",LocDesc=""
  F  S LocDr=$o(^CTLOC(LocDr)) Q:LocDr=""  D
  .S LocDesc=$p(^CTLOC(LocDr),"^",2) //描述
  .Q:LocDesc=""
  .Q:(hospId'="")&(hospId'=$p(^CTLOC(LocDr),"^",22))
  .;^PAC("ADMLOC",0,"AdmType",{ADMLOC_AdmType},{ADMLOC_CTLOC_DR},{ADMLOC_RowId})
  .;Q:$d(^PAC("ADMLOC",0,"AdmType","I",LocDr)) ;2018-10-24 后期需要再放开条件
  .;Q:$d(^PAC("ADMLOC",0,"AdmType","O",LocDr)) ;2018-10-24 后期需要再放开条件
  .;Q:$d(^PAC("ADMLOC",0,"AdmType","E",LocDr)) ;2018-10-24 后期需要再放开条件
  .;Q:$d(^PAC("ADMLOC",0,"AdmType","H",LocDr)) ;2018-10-24 后期需要再放开条件
  .S DateActiveFrom=$p(^CTLOC(LocDr),"^",24) // 科室 开始日期 
  .S DateActiveTo=$p(^CTLOC(LocDr),"^",25) // 科室  结束日期
  .Q:((DateActiveFrom'="")&&(DateActiveFrom>+$h))||((DateActiveTo'="")&&(DateActiveTo<+$h))
  .S ContactName=$p(^CTLOC(LocDr),"^",43) // 科室编码  
  .s ContactName=$$ALPHAUP^SSUTIL4(ContactName)
  .S LocDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
  .Q:(q'="")&&(ContactName'[q)&&(LocDesc'[q)
  .d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",LocDesc).Put("text",LocDesc))
  w jsonObj.ListToJson(listObj)
  q ""
}

/// Description: 科室
/// Creator:     congyue
/// CreateDate:  2017-07-24
/// Table: 		 CT_LOC
/// Output:  	 所有科室描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVCOMMONPART).SelLocDesc(2)
ClassMethod SelLocDesc(hospId = "", q = "") As %String
{
	N (hospId,q,%session)
	S q=$zcvt(q,"U")
	S count=0
	W "["
	S LocDr="",LocDesc=""
	F  S LocDr=$o(^CTLOC(LocDr)) Q:LocDr=""  D
	.S LocDesc=$p(^CTLOC(LocDr),"^",2) //描述
	.Q:LocDesc=""
	.Q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("CT_Loc",LocDr,hospId,"")'="Y"
	.S DateActiveFrom=$p(^CTLOC(LocDr),"^",24) // 科室 开始日期 
	.S DateActiveTo=$p(^CTLOC(LocDr),"^",25) // 科室  结束日期
	.Q:((DateActiveFrom'="")&&(DateActiveFrom>+$h))||((DateActiveTo'="")&&(DateActiveTo<+$h))
	.S ContactName=$p(^CTLOC(LocDr),"^",43) // 科室编码  
	.S ContactName=$$ALPHAUP^SSUTIL4(ContactName)
	.S LocDesc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)  
	.Q:(q'="")&&(ContactName'[q)&&(LocDesc'[q)
	.S tmp=LocDr_"^"_LocDesc
	.S count = count+1
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	W "]"
	Q ""
}

/// Description: 不良事件级别(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 不良事件级别(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryAdvLevelCombo()
ClassMethod QueryAdvLevelCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Ⅰ级").Put("text","Ⅰ级-警讯事件"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Ⅱ级").Put("text","Ⅱ级-不良后果事件"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Ⅲ级").Put("text","Ⅲ级-未造成后果事件"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Ⅳ级").Put("text","Ⅳ级-隐患事件"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 一级伤害严重度(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 一级伤害严重度(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryInjSevOneCombo()
ClassMethod QueryInjSevOneCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","死亡").Put("text","死亡"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","永久性功能丧失").Put("text","永久性功能丧失"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 二级伤害严重度(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 二级伤害严重度(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryInjSevTwoCombo()
ClassMethod QueryInjSevTwoCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","重度伤害").Put("text","重度伤害"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","中度伤害").Put("text","中度伤害"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","轻度伤害").Put("text","轻度伤害"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 三级伤害严重度(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 三级伤害严重度(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryInjSevThreeCombo()
ClassMethod QueryInjSevThreeCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","未造成伤害").Put("text","未造成伤害"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","没有伤害").Put("text","没有伤害"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 四级伤害严重度(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 四级伤害严重度(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryInjSevFourCombo()
ClassMethod QueryInjSevFourCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","没有伤害").Put("text","没有伤害"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 有无不需要(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 有无不需要(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryHaveOrNoCombo()
ClassMethod QueryHaveOrNoCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","有").Put("text","有"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","无").Put("text","无"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","不需要").Put("text","不需要"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 是否 不知道(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 是否 不知道(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryWheOrNoCombo()
ClassMethod QueryWheOrNoCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Oth").Put("text","不知道"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 是否 无法判断(下拉框) 
/// Creator:     dws
/// CreateDate:  2017-08-08
/// Input:  	 
/// Return: 	 是否 无法判断(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryWhetherNoCombo()
ClassMethod QueryWhetherNoCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","No").Put("text","无法判断"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 是否 其他(下拉框) 
/// Creator:     dws
/// CreateDate:  2017-08-08
/// Input:  	 
/// Return: 	 是否 其他(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryWhetherOthCombo()
ClassMethod QueryWhetherOthCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","O").Put("text","其他"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 理解 不理解(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 理解 不理解(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryIfUnderstandCombo()
ClassMethod QueryIfUnderstandCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","理解").Put("text","理解"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","不理解").Put("text","不理解"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 当事人职业种类(下拉框) 
/// Creator:     dws
/// CreateDate:  2017-07-24
/// Input:  	 
/// Return: 	 当事人职业种类(下拉框)
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryTypeOfPartiesCombo()
ClassMethod QueryTypeOfPartiesCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","医生").Put("text","医生"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","护士").Put("text","护士"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","技师").Put("text","技师"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","药剂师").Put("text","药剂师"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","行政人员").Put("text","行政人员"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","技工").Put("text","技工"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","后勤人员").Put("text","后勤人员"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","院感检测护士").Put("text","院感检测护士"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","医务处长").Put("text","医务处长"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","轮转护士").Put("text","轮转护士"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","进修护士").Put("text","进修护士"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","实习护士").Put("text","实习护士"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","其他").Put("text","其他"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 工作年限/在科室工作年限(下拉框) 
/// Creator:     dws
/// CreateDate:  2017-07-25
/// Input:  	 
/// Return: 	 工作年限/在科室工作年限(下拉框)
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryWorkYearsCombo()
ClassMethod QueryWorkYearsCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","未满一年").Put("text","未满一年"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","1~3年").Put("text","1~3年"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","4~5年").Put("text","4~5年"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","6~10年").Put("text","6~10年"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","10年以上").Put("text","10年以上"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","不知道").Put("text","不知道"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 医护人员职称(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2019-12-06
/// Input:  	 
/// Return: 	 医护人员职称(下拉框) 信息 CT_CarPrvTp
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryCarPrvTpCombo("ys")
ClassMethod QueryCarPrvTpCombo(q)
{
  N (q,%session)
  S q=$$ALPHAUP^SSUTIL4(q)
  S jsonObj=##class(web.DHCAPPJsonObject).%New()
  S listObj=##class(%ListOfObjects).%New()
  S CTCptID=""
  F  S CTCptID=$o(^CT("CPT",CTCptID)) Q:CTCptID=""  D
  .Q:+CTCptID=0
  .S Desc=$p(^CT("CPT",CTCptID),"^",2) //描述
  .S ActiveFlag=$p(^CT("CPT",CTCptID),"^",3) // 标志
  .S StDate=$p(^CT("CPT",CTCptID),"^",5) 		//有效期 开始日期 
  .S EndDate=$p(^CT("CPT",CTCptID),"^",6) 	//有效期 结束日期
  .S Codes=##class(web.DHCADVCOMMON).GetPYCODE(Desc)
  .S Desc=##class(web.DHCADVCOMMON).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",Desc)
  .Q:(q'="")&&(Codes'[q)&&(Desc'[q)
  .Q:(StDate'="")&&(StDate>$h)
  .Q:(StDate'="")&&(EndDate'="")&&((StDate>$h)||(EndDate<$h))  
  .D listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",Desc).Put("text",Desc))
  W jsonObj.ListToJson(listObj)
  Q ""
}

/// Description: 查询 报告信息 
/// Creator:     CongYue
/// CreateDate:  2017-07-28
/// Input:  	 record : 表单记录ID
/// Table:       FormRecord,FormRecordItm ##class(web.DHCADVAction).ALPHAUP()
/// Return: 	 报告信息 PatID^PatName^RepSubType  病人ID^病人姓名^报告小类型
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryRepInfo(4)
ClassMethod QueryRepInfo(record As %String)
{
	n (record)
	s ItmID="",PatID="",PatName="",RepSubType="",i=1,value="",Discoverer="" //hxy 2018-01-05
	f  s ItmID=$o(^User.DHCAdvFormRecordItmI("IndexFormRecord",record,ItmID)) q:ItmID=""  d
	.s data=^User.DHCAdvFormRecordItmD(ItmID)
	.s:i=1 value=$LIST(data,4)  //hxy 2018-01-05
	.s PatIDdicdr=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP("PatID"),"")) ;处理为大写
	.S:PatIDdicdr=$LIST(data,3) PatID=$LIST(data,4)
	.s PatNamedr=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP("PatName"),""))
	.S:PatNamedr=$LIST(data,3) PatName=$LIST(data,4)
	.s DiscovererDr=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP("Discoverer"),"")) //hxy 2018-01-18 审核查询界面报告人匿名时也显示报告人
	.S:DiscovererDr=$LIST(data,3) Discoverer=$LIST(data,4)
	.s i=i+1 //hxy 2018-01-05
	S RepSubType=..QueryDataInfo(record,"事件类别")
	//i PatName="" s PatName=value //hxy 2018-01-05  除类型为“患者\患者家属”外，其他类型上报记录的姓名显示为空

	q PatID_"^"_PatName_"^"_RepSubType_"^"_Discoverer
}

/// Description: 获取 数据保存值（select-change 类型（事件类别，不良事件级别，伤害严重度）） 
/// Creator:     CongYue
/// CreateDate:  2017-09-07
/// Input:  	 record : 表单填写记录表ID, title:所需元素保存值的元素描述（事件类别，不良事件级别，伤害严重度）
/// Table:       FormRecordItm,FormDic
/// Return: 	 Data  数据保存值
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryDataInfo(33,"事件类别")
ClassMethod QueryDataInfo(record As %String, title As %String)
{
	n (record,title,%session)
	S RecordItmvalue="",RecordItmID=""
	Q:title="" ""
	S FormDicID=$o(^User.DHCAdvFormDicI("IndexTitle"," "_title,""))  
	
	Q:FormDicID="" ""
	F  S RecordItmID=$o(^User.DHCAdvFormRecordItmI("IndexFormRecord",record,RecordItmID)) Q:RecordItmID=""  D
	.Q:(FormDicID'="")&&(FormDicID'=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),3))&&(FormDicID'=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),8))
	.S RecordItmvalue=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),4)
	.Q:RecordItmvalue'=""
	q RecordItmvalue
}

/// Description: 保存 报告信息 
/// Creator:     CongYue
/// CreateDate:  2017-08-10
/// Input:  	 user = 用户ID, formId = 表单ID, formVersion = , par = 表单数据, recordId = 表单填写记录表ID
/// 				 AuditList:LgUserID用户ID, LgCtLocID科室ID, LgGroupID安全组ID, adrNextLoc指向科室ID, adrLocAdvice科室意见, adrReceive报告接收状态
/// Table:       FormRecord,FormRecordItm,FormRecordItmSub
/// Return: 	 req^FormRecordID 
/// Others:		 w ##class(web.DHCADVCOMMONPART).SaveRepInfo("3","982","14","173112.93374:堵漏事件^173114.93376:小测试堵漏事件事件              经过^173116.93378:测试堵漏事件原因分析^173118.93380:测试堵漏事件改进方法^173122.                      94160:innurse^173126.93383:测试职称^173130.93385:测试职务^173133.94168:2^173139.        93403:innurse^173143.93405:2^173149.93407:测试堵漏行为^173151.93417:众生皆苦东方            航空市政府开始的饭卡上^173104.93567:一病房^173108.93372:2017-12-18^173147.94162:              一病房^173136.93400:是^173154.93410:一般^173158.93415:否^173135.93393:医疗","","","101","")
/// Others:		 w ##class(web.DHCADVCOMMONPART).SaveRepInfo("12175","994","6","215080.94281:ADV202102230001^215086.94284:未 提交^215094.89001:zfmcs0707^215098.94387:0000000001^215102.93420:100001^215106.93988:女^215110.89009:32岁^215118.98323:13322557788^215122.94413:15^215126.94407:  医生01^215130.94389:1^215153.93424:1.巴赞病^215165.94171:10:11^215169.94652:工作日^215228.88916:11^215230.94718:12^215232.90889:1212^215234.94720:1213^215241.93 561:医生01^215249.93555:东华标准版数字化医院[总院]^215082.93559:2021-02-23^215114.89007:1988-07-07^215134.94409:内分泌科^215138.94415:2020-07-07^215142.94411:2020-07-08^215150.94419:全自费^215161.98326:2021-02-23^215173.89037:内分泌科^215175.94788:门诊^215223.98019:Ⅱ级事件（不良后果事件）：在疾病医疗过程中因诊疗活动(或其他原因)而非疾病本身造成的病人（或工作人员）机体与功能损害。^215224.98415:H级不良事件发生并导致患者需要治疗挽救生命^215178.98333:输血^215178.98349:口腔^215219.94669:治疗缺陷^215219.94670:手术缺陷^215219.94671:手术前准备不足(或不充分)^215225.98587:技师^215226.98594:耗材药品不良","","12175^113^29^^^","113","1","0","")
ClassMethod SaveRepInfo(user = "", formId = "", formVersion = "", par = "", recordId = "", AuditList As %String, locdr = "", EpisodeID = "", flag = "", order = "", LgParam = "")
{
	N (user,formId,formVersion,par,recordId,AuditList,locdr,EpisodeID,flag,order,LgParam,%session)
	S myrlflag=(('$d(%session.Data("LOGON.USERID")))||($g(%session.Data("LOGON.USERID"))=""))
	Q:myrlflag=1 "Error"        ;2021-05-17 cy 保存时加校验登录是否超时 ;2021-05-17 cy 保存时加校验登录是否超时
	S RepID=""
	I recordId'=""  D
	.S RepID=$o(^DHCADVMASTER(0,"FormRec",recordId,""))
	.S data=^User.DHCAdvFormRecordD(recordId)
	.S formId=$LIST(data,2)
	.S formVersion=$LIST(data,3)
	S ret=0
	I RepID="" D
	.S ret=..Insert(user,formId,formVersion,par,recordId,AuditList,locdr,EpisodeID,flag,order,LgParam)
	E  D
	.S ret=..Update(RepID,user,formId,formVersion,par,recordId,AuditList,locdr,flag,order,LgParam)
	Q ret
}

/// Description: 插入 报告信息 
/// Creator:     CongYue
/// CreateDate:  2017-08-23
/// Input:  	 user = 用户ID, formId = 表单ID, formVersion = , par = 表单数据, recordId = 表单填写记录表ID
/// 				 AuditList:LgUserID用户ID, LgCtLocID科室ID, LgGroupID安全组ID, adrNextLoc指向科室ID, adrLocAdvice科室意见, adrReceive报告接收状态
/// Table:       FormRecord,FormRecordItm,FormRecordItmSub,DHC_AdvMaster
/// Return: 	 req^RepID 
/// Others:		 w ##class(web.DHCADVCOMMONPART).Insert(359,8,69,"115493.60734:0000000009^115497.60618:test^115510.60624:17岁^115514.60626:40kg^115519.60628:123546533^115536.60636:蒋荣猛^155662.60638:孙      凤霞^115467.60578:Ⅲ级-未造成后果事件  是指在诊疗服务和医院工作过程中，虽然发生                                了错误的事实，担未对机体与功能造成任何损害，或仅有轻微后果，不需要任何处理，可完全康复。^115472.1927:没有伤害  --事件未形成事实，未造成伤害。^155691.60646:叙述                         事件经过及详细信息测试^103821.961:20分 中度危险^123149.1117:1cm^155711.62124:检                  查检查j8ics检查^155721.1149:蒋荣猛^155721.1152:测试人员^155742.60770:孙凤霞^1557               63.60776:研究生^155650.117:1902^115501.60620:男^115506.60622:2000-05-15^115523.6    0630:否^115527.60632:住院^115532.60634:2017-08-23^155666.60640:2017-08-23^155670   .60642:工作日^155675.60644:ZXYJHYK-中西医结合一科^155685.392:1932^115472.1912:19          25^155699.60652:60912^122013.762:1975^157547.1972:1973^157556.1068:1070^123149.1095:自家庭入住时已有压疮^157565.60658:是^157569.60660:否^157573.60662:否^157578.             60664:是^157587.60666:2017-08-23^157591.60668:低温麻醉^157595.60670:平卧位^12202        2.60672:2017-08-23^122026.60674:2017-08-23^122036.60676:否^155711.60656:62121^15 5721.60740:62467^155730.60742:62474^153872.60744:2017-08-23 17:19:36^153876.60746:理解^155746.60772:医生^155750.60780:4~5年^155755.60782:4~5年^155759.60774:ZXYJ      HYK-中西医结合一科^155768.60778:61025^103821.931:不受限(4分)^103821.933:局限于椅               (2分)^103821.938:严重受限(2分)^103821.943:偶尔潮湿(3分)^103821.947:有潜在问题(3                 分)^103821.952:营养良好(4分)^103821.954:受损(2分)^123149.1090:Ⅱ期-部分真皮厚度                  的缺失呈现为一个浅的的开放的溃疡,并且有一个粉红色的创伤部位， 无组织脱落,也呈现                                       为一个完整的或开放/破裂的充血性水疱。^155768.61034:实习医师^155680.599:病房^1231                        49.1096:骶尾椎骨处^123149.1102:枕骨处^122031.1183:保持床铺和衣裤清洁、干燥、平整、舒适^122031.1197:局都或周围予以皮肤保护剂(膏) 涂抹^155716.1071:无处理措施","","359                       ^6^134^^^")
ClassMethod Insert(user = "", formId = "", formVersion = "", par = "", recordId = "", AuditList = "", locdr = "", EpisodeID = "", flag = "", order = "", LgParam = "")
{
	N (user,formId,formVersion,par,recordId,AuditList,locdr,EpisodeID,flag,order,LgParam,%session)
	S Err=0
	S UserList=$p(AuditList,"^",1,3)

	TS

	//保存报告表单数据信息
	S recordlist=##class(web.DHCADVFormRecord).SaveRecord(user,formId,formVersion,par,recordId)
	S rep=$p(recordlist,"^",1)
	S recordId=$p(recordlist,"^",2)
	I rep'=0 tro
	Q:rep'=0 rep

	//获取报告状态ID与报告类型
	S RepSubType=..QueryDataInfo(recordId,"事件类别")
	S Formdata=^User.DHCAdvFormNameD(formId)
	S RepTypeCode=$LG(Formdata,2)
	S RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //类别指向
	S RepTypeParref="",RepTypeSub="" ;2018-08-31
	I RepTypeDr=""  D
	.S RepTypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:RepTypeParref'="" RepTypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),RepTypeParref,""))
	.S:(RepTypeParref'="")&&(RepTypeSub'="") RepTypeDr=RepTypeParref_"||"_RepTypeSub
	
	//保存不良事件主表
	S RepID=..InsAdvmaster(recordId,RepTypeDr,RepSubType,user,locdr,EpisodeID,formId,LgParam)
	I RepID<0 tro
	Q:RepID<0 RepID
	
	//保存压疮部位信息
	S AdvUPID=""
	S:RepTypeCode="advSkinUlcer" AdvUPID=##class(web.DHCADVULCPARTINFO).SavePartList(RepID,recordId)
	I AdvUPID<0 tro
	Q:AdvUPID<0 AdvUPID
	
	//保存不良事件类别信息     cy  2020-06-17 
	S AdvManID=..SaveManageList(RepID,formId,"RepManaCat")
	I AdvManID<0 tro
	Q:AdvManID<0 AdvManID
	
	// 获取带有工作流的 不良事件类别id与code
	S RepManaCat=..GetWFTypeCode(RepID,formId,"RepManaCat")
	S:($p(RepManaCat,"^",1))'="" RepTypeDr=$p(RepManaCat,"^",1)
	S:($p(RepManaCat,"^",2))'="" RepTypeCode=$p(RepManaCat,"^",2)

	//更新状态
    S nextStatuDr=""
	I flag="1" D
	.S adtList=RepID_"^"_RepTypeDr_"^"_UserList
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList,"",LgParam)
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_AdvMaster set ADV_RepStaus_Dr=:nextStatuDr where ADV_RowID=:RepID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 S Err="-16"
	Q:Err'=0 "-16"
	
	S advRepAuditList=""
	S:AuditList'="" advRepAuditList=nextStatuDr_"^"_AuditList_"^"_RepTypeDr
	
	//不良反应报告审批流程[默认插入初始状态]
	I advRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(RepID,advRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-18"
	
	I flag="1" D
	.s Err=##class(web.DHCADVCOMMONPART).InsWebsysMessage(RepID, user, "",LgParam)
	.I Err'=0 tro
	Q:Err'=0 "-99"

	// 不良事件主表关联表信息保存 2021-02-09 cy
	I order'="" D
	.S Err=##class(web.DHCADVCOMMONPART).InsRepLink(RepID,"Order",order)
	I Err'=0 tro
	Q:Err'=0 "-19"

	TC
	Q "0^"_RepID_"^"_recordId_"^"_RepTypeDr
}

/// Description: 插入 报告信息 
/// Creator:     CongYue
/// CreateDate:  2017-08-23
/// Input:  	 user = 用户ID, formId = 表单ID, formVersion = , par = 表单数据, recordId = 表单填写记录表ID
/// 				 AuditList:LgUserID用户ID, LgCtLocID科室ID, LgGroupID安全组ID, adrNextLoc指向科室ID, adrLocAdvice科室意见, adrReceive报告接收状态
/// Table:       FormRecord,FormRecordItm,FormRecordItmSub,DHC_AdvMaster
/// Return: 	 req^RepID 
/// Others:		 w ##class(web.DHCADVCOMMONPART).Insert(223)
ClassMethod Update(RepID, user, formId, formVersion, par, recordId, AuditList As %String, locdr, flag = "", order = "", LgParam = "") As %String
{
	N (RepID,user,formId,formVersion,par,recordId,AuditList,locdr,flag,order,LgParam,%session)
	S Err=0
	S UserList=$p(AuditList,"^",1,3)
	S RepStatus=$p(^DHCADVMASTER(RepID),"^",3)
	TS
	//保存报告表单数据信息
	S recordlist=##class(web.DHCADVFormRecord).SaveRecord(user,formId,formVersion,par,recordId)
	S Err=$p(recordlist,"^",1)
	S recordId=$p(recordlist,"^",2)
	I Err'=0 tro
	Q:Err'=0 Err

	//获取报告状态ID与报告类型
	S RepSubType=..QueryDataInfo(recordId,"事件类别")
	S Formdata=^User.DHCAdvFormNameD(formId)
	S RepTypeCode=$LG(Formdata,2)
	S RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //类别指向
	S RepTypeParref="",RepTypeSub="" ;2018-08-31
	I RepTypeDr=""  D
	.S RepTypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:RepTypeParref'="" RepTypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),RepTypeParref,""))
	.S:(RepTypeParref'="")&&(RepTypeSub'="") RepTypeDr=RepTypeParref_"||"_RepTypeSub
	
	//保存不良事件主表
	S RepID=..UpdAdvmaster(RepID,recordId,RepTypeDr,RepSubType,user,locdr,formId,LgParam)
	I RepID<0 tro
	Q:RepID<0 RepID
	
	//保存压疮部位信息
	S AdvUPID=""
	S:RepTypeCode="advSkinUlcer" AdvUPID=##class(web.DHCADVULCPARTINFO).SavePartList(RepID,recordId)
	I AdvUPID<0 tro
	Q:AdvUPID<0 AdvUPID
	
	//保存不良事件类别信息     congyue  2020-06-17 
	S AdvManID=..SaveManageList(RepID,formId,"RepManaCat")
	I AdvManID<0 tro
	Q:AdvManID<0 AdvManID
	
	// 获取带有工作流的 不良事件类别id与code
	S RepManaCat=..GetWFTypeCode(RepID,formId,"RepManaCat")
	S:($p(RepManaCat,"^",1))'="" RepTypeDr=$p(RepManaCat,"^",1)
	S:($p(RepManaCat,"^",2))'="" RepTypeCode=$p(RepManaCat,"^",2)
	
	//更新状态
    S nextStatuDr=""
	I flag="1" D
	.S adtList=RepID_"^"_RepTypeDr_"^"_UserList
	.S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(adtList,"",LgParam)
	I (flag="1")&(+nextStatuDr'>0) tro
	Q:(flag="1")&(+nextStatuDr'>0) nextStatuDr
	
	I flag="1" D
	.&sql(update DHC_AdvMaster set ADV_RepStaus_Dr=:nextStatuDr where ADV_RowID=:RepID)
	.I SQLCODE'=0 tro
	.I SQLCODE'=0 S Err="-16"
	Q:Err'=0 "-16"
	
	S advRepAuditList=""
	S:(AuditList'="")&&(flag=1) advRepAuditList=nextStatuDr_"^"_AuditList_"^"_RepTypeDr
	S:(AuditList'="")&&(flag=0) advRepAuditList=RepStatus_"^"_AuditList_"^"_RepTypeDr
	
	//不良反应报告审批流程[默认插入初始状态]
	I advRepAuditList'="" D
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(RepID,advRepAuditList)
	I Err'=0 tro
	Q:Err'=0 "-18"
	
	I flag="1" D
	.s Err=##class(web.DHCADVCOMMONPART).InsWebsysMessage(RepID, user, "",LgParam)
	.I Err'=0 tro
	Q:Err'=0 "-99"
	// 不良事件主表关联表信息保存 2021-02-09 cy
	I order'="" D
	.S Err=##class(web.DHCADVCOMMONPART).InsRepLink(RepID,"Order",order)
	I Err'=0 tro
	Q:Err'=0 "-19"
	TC
	Q "0^"_RepID_"^"_recordId_"^"_RepTypeDr
}

/// Description: 插入 不良事件主表信息 
/// Creator:     CongYue
/// CreateDate:  2017-08-23
/// Input:  	 表单填写记录表ID, 报告类型ID,报告子类型描述,user人员ID,locdr科室ID
/// Table:       DHC_AdvMaster
/// Return: 	 RepID 
/// Others:		 w ##class(web.DHCADVCOMMONPART).InsAdvmaster()
ClassMethod InsAdvmaster(recordId, RepTypeDr, RepSubType, user, locdr, EpisodeID, formId, LgParam) As %String
{
	n (recordId, RepTypeDr, RepSubType, user, locdr,EpisodeID,formId,LgParam,%session)
	S advRepImpFlag="N"
	S RepLevel=..QueryDataInfo(recordId,"不良事件的等级")
	S RepInjSev=..QueryDataInfo(recordId,"伤害严重度")
	S PatID=..GetSaveInfo("PatID", formId, recordId) ;..QueryInputDataInfo(recordId,"患者ID")
	S AdmType=..QueryInputDataInfo(recordId,"就诊形式")
	
	S PatName=..GetSaveInfo("PatName", formId, recordId)
	S PatSex=..GetSaveInfo("PatSex", formId, recordId)
	S PatAge=..GetSaveInfo("PatAge", formId, recordId)
	S AdmNo=..GetSaveInfo("AdmNo", formId, recordId) ;病案号
	S PatDiag=..GetSaveInfo("PatDiag", formId, recordId) ;诊断
	
	S HospAdmDate=..GetSaveInfo("HospAdmDate", formId, recordId) ;入院日期
	S:HospAdmDate'="" HospAdmDate=$zdh(HospAdmDate,3) ;##class(web.DHCADVCOMMON).DateHtmlToLogical(HospAdmDate)
	S OccurDate=..GetSaveInfo("OccurDate", formId, recordId) ;发生日期
	S:OccurDate'="" OccurDate=$zdh(OccurDate,3) ;##class(web.DHCADVCOMMON).DateHtmlToLogical(OccurDate)
	S OccurTime=..GetSaveInfo("OccurTime", formId, recordId) ;发生时间
	S:OccurTime'="" OccurTime=$zth(OccurTime,1)
	S OccurLoc=..GetSaveInfo("OccurLoc", formId, recordId)  ;发生科室
	S:OccurLoc'="" OccurLoc=##Class(web.DHCADVCOMMON).GetBeforeTransDesc("User.CTLoc","CTLOCDesc","",OccurLoc)
	S:OccurLoc'="" OccurLoc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(OccurLoc),""))

	S RepUserTitle=..GetSaveInfo("RepUserTitle", formId, recordId) ;填报人职称
	S RepUseWorYears=..GetSaveInfo("RepUseWorYears", formId, recordId) ;工作年限
	S RepDate=..GetSaveInfo("RepDate", formId, recordId) ;报告日期
	S:RepDate'="" RepDate=$zdh(RepDate,3) ;##class(web.DHCADVCOMMON).DateHtmlToLogical(RepDate)
	S:RepDate="" RepDate=+$h
	S RepTime=..GetSaveInfo("RepTime", formId, recordId) ;报告时间
	S:RepTime'="" RepTime=$zth(RepTime,1)
	S:RepTime="" RepTime=$p($h,",",2) 
	
	; 2021-02-22 cy 报告人id方式与保存 
	S RepUser=..GetSaveInfo("RepUser", formId, recordId) ;报告人
	S:RepUser'="" RepUser=##Class(web.DHCADVCOMMON).GetBeforeTransDesc("User.SSUser","SSUSRName","",RepUser)
	S REPUSERFLAG=##class(web.DHCADVCOMMON).GetEmSysConfig("REPUSERFLAG",LgParam)
	S:REPUSERFLAG="" RepUser=user ;当前登陆人id为报告人id
	S:(REPUSERFLAG="1")&&(RepUser'="") RepUser=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(RepUser),"")) ; 输入报告人姓名获取报告人id
	S:(REPUSERFLAG="2")&&(RepUser'="") RepUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUser),"")) ; 输入报告人工号获取报告人id
	S:(REPUSERFLAG'="")&&(+RepUser=0) RepUser=user ;当前登陆人id为报告人id

	S RepLoc=..GetSaveInfo("RepLoc", formId, recordId) ;报告科室
	S:RepLoc'="" RepLoc=##Class(web.DHCADVCOMMON).GetBeforeTransDesc("User.CTLoc","CTLOCDesc","",RepLoc)
	S:RepLoc'="" RepLoc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RepLoc),""))
	S:RepLoc="" RepLoc=locdr
	S RepNo=..GetSaveInfo("RepNo", formId, recordId) ;报告编号
	
	&SQL(Insert Into DHC_AdvMaster(ADV_FormRec_Dr,ADV_RepType_Dr,ADV_RepDate,ADV_RepTime,
		ADV_RepUser_Dr,ADV_RepLoc_Dr,ADV_RepSubType,ADV_RepImpFlag,ADV_RepLevel,ADV_RepInjSev,ADV_PatID,ADV_AdmType,ADV_Adm,
		ADV_PatName,ADV_PatSex,ADV_PatAge,ADV_AdmNo,ADV_PatDiag,ADV_HospAdmDate,ADV_OccurDate,ADV_OccurTime,
		ADV_OccurLoc,ADV_RepUserTitle,ADV_RepUseWorYears,ADV_RepNo
	) Values(:recordId,:RepTypeDr,:RepDate,:RepTime,
		:RepUser,:RepLoc,:RepSubType,:advRepImpFlag,:RepLevel,:RepInjSev,:PatID,:AdmType,:EpisodeID,
		:PatName,:PatSex,:PatAge,:AdmNo,:PatDiag,:HospAdmDate,:OccurDate,:OccurTime,
		:OccurLoc,:RepUserTitle,:RepUseWorYears,:RepNo
	))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 修改 不良事件主表信息 
/// Creator:     CongYue
/// CreateDate:  2017-08-23
/// Input:  	 不良事件主表ID, 表单填写记录表ID, 报告类型ID,报告子类型描述,user人员ID,locdr科室ID
/// Table:       DHC_AdvMaster
/// Return: 	 RepID 
/// Others:		 w ##class(web.DHCADVCOMMONPART).UpdAdvmaster()
ClassMethod UpdAdvmaster(RepID, recordId, RepTypeDr, RepSubType, user, locdr, formId, LgParam) As %String
{
	n (RepID,recordId, RepTypeDr, RepSubType, user, locdr,formId,LgParam,%session)
	S RepLevel=..QueryDataInfo(recordId,"不良事件的等级")
	S RepInjSev=..QueryDataInfo(recordId,"伤害严重度")
	S PatID=..GetSaveInfo("PatID", formId, recordId) ;..QueryInputDataInfo(recordId,"患者ID")
	S AdmType=..QueryInputDataInfo(recordId,"就诊形式")
	
	S PatName=..GetSaveInfo("PatName", formId, recordId)
	S PatSex=..GetSaveInfo("PatSex", formId, recordId)
	S PatAge=..GetSaveInfo("PatAge", formId, recordId)
	S AdmNo=..GetSaveInfo("AdmNo", formId, recordId) ;病案号
	S PatDiag=..GetSaveInfo("PatDiag", formId, recordId) ;诊断
	
	S HospAdmDate=..GetSaveInfo("HospAdmDate", formId, recordId) ;入院日期
	S:HospAdmDate'="" HospAdmDate=$zdh(HospAdmDate,3) ;##class(web.DHCADVCOMMON).DateHtmlToLogical(HospAdmDate)
	S OccurDate=..GetSaveInfo("OccurDate", formId, recordId) ;发生日期
	S:OccurDate'="" OccurDate=$zdh(OccurDate,3) ;##class(web.DHCADVCOMMON).DateHtmlToLogical(OccurDate)
	S OccurTime=..GetSaveInfo("OccurTime", formId, recordId) ;发生时间
	S:OccurTime'="" OccurTime=$zth(OccurTime,1)
	S OccurLoc=..GetSaveInfo("OccurLoc", formId, recordId)  ;发生科室
	S:OccurLoc'="" OccurLoc=##Class(web.DHCADVCOMMON).GetBeforeTransDesc("User.CTLoc","CTLOCDesc","",OccurLoc)
	S:OccurLoc'="" OccurLoc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(OccurLoc),""))

	S RepUserTitle=..GetSaveInfo("RepUserTitle", formId, recordId) ;填报人职称
	S RepUseWorYears=..GetSaveInfo("RepUseWorYears", formId, recordId) ;工作年限
	S RepDate=..GetSaveInfo("RepDate", formId, recordId) ;报告日期
	S:RepDate'="" RepDate=$zdh(RepDate,3) ;##class(web.DHCADVCOMMON).DateHtmlToLogical(RepDate)
	S RepTime=..GetSaveInfo("RepTime", formId, recordId) ;报告时间
	S:RepTime'="" RepTime=$zth(RepTime,1)
	S RepNo=..GetSaveInfo("RepNo", formId, recordId) ;报告编号
	
	&SQL(update DHC_AdvMaster set ADV_FormRec_Dr=:recordId,ADV_RepType_Dr=:RepTypeDr,ADV_RepDate=:RepDate,ADV_RepTime=:RepTime,ADV_RepSubType=:RepSubType,
	ADV_RepLevel=:RepLevel,ADV_RepInjSev=:RepInjSev,ADV_PatID=:PatID,ADV_AdmType=:AdmType,
	ADV_PatName=:PatName,ADV_PatSex=:PatSex,ADV_PatAge=:PatAge,ADV_AdmNo=:AdmNo,ADV_PatDiag=:PatDiag,ADV_HospAdmDate=:HospAdmDate,ADV_OccurDate=:OccurDate,ADV_OccurTime=:OccurTime,
	ADV_OccurLoc=:OccurLoc,ADV_RepUserTitle=:RepUserTitle,ADV_RepUseWorYears=:RepUseWorYears,ADV_RepNo=:RepNo
	 where ADV_RowID=:RepID)
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 获取工作流是否授权
/// Creator:    ggm
/// CreateDate:  2018-01-30
/// Input:  	 报告填报人员数据
/// Return:  	 报告下一个状态id
/// Others:	w ##class(web.DHCADVCOMMONPART).GetRepStatus("361^906^1223^4^235")
ClassMethod GetRepStatus(RepAuditList, LgParam As %String = "") As %String
{
	n (RepAuditList,LgParam)
	s typecode=$p(RepAuditList,"^",2)
	S Formdata=^User.DHCAdvFormNameD(typecode)
	S RepTypeCode=$LIST(Formdata,2)
	S RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //类别指向
	s eventparref="",eventsub="" ;2018-08-29
	i RepTypeDr=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") RepTypeDr=eventparref_"||"_eventsub
	s RepList=$p(RepAuditList,"^",1)_"^"_RepTypeDr_"^"_$p(RepAuditList,"^",3)_"^"_$p(RepAuditList,"^",4)_"^"_$p(RepAuditList,"^",5)
	S nextStatuDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(RepList,"",LgParam)
	Q:(RepList'="")&(+nextStatuDr'>0) nextStatuDr
}

/// Description: 不良事件查询 
/// Creator:     CongYue
/// CreateDate:  2017-08-28
/// Input:  	 StrParam : 以字符"^"分割,格式为:开始时间^结束时间
/// Table:       FormRecord,FormRecordItm,FormRecordItmSub
/// Return: 	 不良事件 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryRepList("10","1","2018-01-01^2021-03-12^113^^29^113^12175^^^^^^^^^^^^^^^N^^1","12175^113^29^2","","^")
ClassMethod QueryRepList(rows = 10, page = 1, StrParam As %String, LgParam As %String, ParStr As %String, ColParam As %String)
{
  
	N (rows,page,StrParam,LgParam,ParStr,ColParam,%session)
	q:StrParam="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S End = page*rows
	S Start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	
	S UserId=$p(LgParam,"^",1)    //用户ID
    S LocId=$p(LgParam,"^",2)     //科室ID
	S GroupId=$p(LgParam,"^",3)   //安全组ID
	S HospId=$p(LgParam,"^",4)   //医院ID

	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S DeptID=$p(StrParam,"^",3)    //科室
	S patNo=$p(StrParam,"^",4)     //登记号
    S StatType=$p(StrParam,"^",8)  //状态
    I StatType="全部" S StatType=""
    S typeevent=$p(StrParam,"^",9)    //填报类型
    S statShare=$p(StrParam,"^",10)    //分享状态
    S receive=$p(StrParam,"^",11)    //接收
    S repflag=$p(StrParam,"^",20)    //已报标识(Y) 草稿标识(N)12
    S inpfileflag=$p(StrParam,"^",17)    //归档标识 14
	S OverTime=$p(StrParam,"^",18)    //是否超时 15
	S homeRepOverTime=$p(StrParam,"^",21)    //首页是否填报超时 16
	S Cancelflag=$p(StrParam,"^",22)    //作废界面查询 17
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",LgParam)
	S:QUERYDATE="1" DateNode="OccurDate"
	S IFREPEDIT=##class(web.DHCADVCOMMON).GetEmSysConfig("IFREPEDIT",LgParam) ;2021-04-26 cy 报告是否可以修改 （1：允许修改(报告未做审核操作且报告未归档)，其他：不允许修改）
	S OrdFlag=-1
	S ColSort=$p(ColParam,"^",1)  // 列头 
	S ColOrder=$p(ColParam,"^",2)  // desc 降序   asc 升序
	S:(ColSort="RepDate")&&(ColOrder="desc") OrdFlag=-1
	S:(ColSort="RepDate")&&(ColOrder="asc") OrdFlag=1
	// 降序 开始日期 结束日期转换
	I OrdFlag=-1  D
	.S OrdFlagDate=StDate 
	.S StDate=EndDate
	.S EndDate=OrdFlagDate
	
    S h=0  //yangyongtao  2017-11-22 
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	Q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	S count=0
	W "{""rows"":["
	F date=StDate:OrdFlag:EndDate D
	.S RepID=""
	.F  S RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) Q:RepID=""  D
	..S RepTypeCode="",RepTypeDr="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",MedadrReceive="",MedadrReceivedr="",FileFlag="",RepOverTimeflag="",AutOverTimeflag="",RepOverTime="",AutOverTime="",RepCancelflag="",StaFistAuditUser="",BackAuditUser="",MedadrNextLocDR=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id） 2020-06-22
	..S RepTypeString=..GetRepTypeString(RepID)
	..S TypeDr=$p(RepTypeString,"^",1) ; 报告表单类型id
	..S TypeCode=$p(RepTypeString,"^",2)
	..S Type=$p(RepTypeString,"^",3)
	..S RepTypeDr=$p(RepTypeString,"^",4)
	..S RepTypeCode=$p(RepTypeString,"^",5)
	..Q:(TypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(TypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,TypeDr,""))
	..S File="",FileFlag=""
	..S:FILERowID'="" File=$p(^DHCADVFILE(FILERowID),"^",3)
	..s:(File'="Y")||(File'="N") File=..JudgeIsOutCome(RepID,TypeDr,LgParam)
	..S FileFlag=$S(File="0":"未归档",(File="1")||(File="3"):"已归档",File="4":"归档(待复核)",(File="2")||(File="5"):"撤销归档",File="N":"撤销归档",File="Y":"已归档",1:"")
	..S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	..S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	..S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	..S:OccurDate="" OccurDate=0
	..S OccurTime=$p(^DHCADVMASTER(RepID),"^",26)  ///发生时间
	..S:OccurTime="" OccurTime=0
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..I RepStausDr=""  D
	...S RepStaus="未提交"
	...S status="N"
	..E  D 
	...S status="Y"
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	..S RepOverTime=""
	..; 2021-03-26 cy 填写超时程序修改
	..;S HolidayDate=##class(web.DHCADVCOMMONPART).CheckTimeEscapeHoliday(OccurDate,OccurTime,RepDate,RepTime)
	..;S FillTime=##class(web.DHCADVCOMMON).GetEmSysConfig("FILLTIME",LgParam)  ///填报时限时长
	..;I (+FillTime'=0)&&(HolidayDate>FillTime) S RepOverTimeflag="Y"   //填报超时
	..S RepOverTimeflag=##class(web.DHCADVCOMMONPART).ChkOverTime(RepID,"FILLTIME",RepDate,RepTime,RepStausDr,LgParam)
	..S RepOverTime=$S(RepOverTimeflag="":"未超时",RepOverTimeflag="N":"未超时",RepOverTimeflag="Y":"已超时",1:"")
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..I MedadrID'=""  D
	...S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	...S MedadrReceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9)
	...i $g(MedadrReceivedr)="" s MedadrReceivedr="未接收"
	...S MedadrReceive=$S(MedadrReceivedr="未接收":"未接收",MedadrReceivedr="1":"接收",MedadrReceivedr="2":"驳回",MedadrReceivedr="3":"撤销",MedadrReceivedr="4":"审核",MedadrReceivedr="5":"归档",MedadrReceivedr="6":"撤销归档",1:"")
	...;S:(MedadrReceive'="")&&(status="Y") RepStaus=RepStaus_"："_MedadrReceive
	...S MedadrRevStatus=$p(^DHCMEDREPADT(MedadrID),"^",14) ;驳回指向
	...S StaFistAuditDr="",StaFistAuditUserDr="",BackAuditUserDr=""
	...S:(RepTypeDr'="")&&(MedadrRevStatus'="") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(RepID, RepTypeDr, MedadrRevStatus ) ;$o(^DHCMEDREPADT(0,"TypeSta",RepTypeDr,MedadrRevStatus,""))
	...S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	...S:MedadrReceivedr="2" BackAuditUserDr=MedadrUserID
	...S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	...S MedadrNextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	..S AuditId="",RepCancelflag="",AutOverTimeflag=""
	..F  S AuditId=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,AuditId),-1)  Q:(AuditId="")  d
	...S OverTimeflag=$p(^DHCMEDREPADT(AuditId),"^",15) ;护士长审核超时标志
	...S AuditCancelflag=$p(^DHCMEDREPADT(AuditId),"^",11) ;作废标识
	...S:OverTimeflag'="" AutOverTimeflag=OverTimeflag
	...S:AuditCancelflag'="" RepCancelflag=AuditCancelflag
	..S AutOverTime=""
	..S AutOverTime=$S(AutOverTimeflag="":"未超时",AutOverTimeflag="N":"未超时",AutOverTimeflag="Y":"已超时",1:"")
	..
	..S:RepDate'="" RepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S RecRepUser=##class(web.DHCADVCOMMONPART).QueryInputDataInfo(recordID,"填报人姓名")  //取匿名信息 sufan 2019-11-07
	..S:(RecRepUser["匿名")||(RecRepUser["anonymous") RepUser=RecRepUser
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..s RepHospID="" //hxy 2020-02-18 st
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(HospId'="")&(HospId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..S RepSubType=$p(^DHCADVMASTER(RepID),"^",8)
	..S RepImpFlag=$p(^DHCADVMASTER(RepID),"^",9)
	..S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	..S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	..S RepInjSev=$p(^DHCADVMASTER(RepID),"^",13) ///伤害严重度
	..S AdmID=$p(^DHCADVMASTER(RepID),"^",16)  
	..S PatName=$p(^DHCADVMASTER(RepID),"^",17)  
	..S AdmNo=$p(^DHCADVMASTER(RepID),"^",20)  ///病案号
	..S OccurLoc=$p(^DHCADVMASTER(RepID),"^",27)  ///发生科室
	..S:OccurLoc'="" OccurLoc=$p(^CTLOC(OccurLoc),"^",2)
	..S:OccurLoc["-" OccurLoc=$p(OccurLoc,"-",2)
	..S:OccurDate="0" OccurDate=""
	..S:(OccurDate'="")&&(OccurDate'="0") OccurDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(OccurDate)
	..s PatID=$p(^DHCADVMASTER(RepID),"^",14)  ///登记号 
	..S PapRowid=""
	..S:AdmID'="" PapRowid=$p(^PAADM(AdmID),"^",1)
	..S:(AdmID'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(AdmID,"")  //病案号 
	..S:(PapRowid'="")&&(PatID="") PatID=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	..S:(PapRowid'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",PapRowid)  //病案号
	..S:(PapRowid'="")&&(PatName="") PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	..S RepShareStatus="未分享"
	..S rshShare=$o(^DHCADVRSH(0,"TypePointer",RepTypeDr,RepID,""))
	..I rshShare'="" D
	...S RepShareStatus="分享"
	..S RepImp=$p(^DHCADVMASTER(RepID),"^",9)
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S Listt=RepID_"^"_RepTypeDr_"^"_list_"^"_RepStausDr_"^"_MedadrNextLocDR_"^"_RepLevelDr
	..S matalast=##class(web.DHCADVCOMMON).InsStatusLast(Listt) 
	..S StatusLastID=$p(matalast,"^",2)  //上一状态
	..S StatusLast=""
	..I StatusLastID'=""  D
	...S AdrewRowIDnLast=$p(StatusLastID,"||",1)
	...S AdrewChildSubnLast=$p(StatusLastID,"||",2)
	...S StatusLast=$p(^DHCADREVTWFI(AdrewRowIDnLast,"ADREWI",AdrewChildSubnLast),"^",2)
	..S GroupDesc=$p(^SSU("SSGRP",GroupId),"^",1)
	..S LocDep=""
	..S:RepLocDr'="" LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)  ;报告科室所属大科系统
	..S CaseShareflag="",CaseShareLoclist="",CaseShareUserlist="",CaseShareAdvicelist=""
	..S CaseShareflag=..GetCaseFlag(RepID,TypeDr,LocId,UserId)
	..S ShareDataList=..GetCaseLocList(RepID,TypeDr)
	..I ShareDataList["&&" S CaseShareLoclist=$p(ShareDataList,"&&",1) //共享科室列表
	..I ShareDataList["&&" S CaseShareUserlist=$p(ShareDataList,"&&",2) //共享用户列表
	..I ShareDataList["&&" S CaseShareAdvicelist=$p(ShareDataList,"&&",3) //共享意见列表
	..S CondFlag=..CheckCondition(ParStr,RepID,LgParam,1) //高级查询条件判断
	..; 压力性损伤不良事件报告类型区分院内院外
	..;S RepTypeExp=""
	..;S Ulcerorign=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordID,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("UlcerPart-95158-95163-95170"))
	..;S:Ulcerorign'="" RepTypeExp="(院内发生)"
	..;S Ulcerorignout=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordID,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("UlcerPart-95158-95163-95171")) 
	..;S:Ulcerorignout'="" RepTypeExp="(院外带入)"
	..;S:(Type["压力性损伤")&&(RepTypeExp'="") Type=Type_RepTypeExp
	..; 跌倒坠床不良事件报告类型区分跌倒坠床
	..;S FallDownTypeSub=""
	..;S Falltyp=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordID,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("FallDownType-94261"))
	..;S:Falltyp'="" FallDownTypeSub="(跌倒类型)"	 //跌倒
	..;S Downtype=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordID,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("FallDownType-94262"))
	..;S:Downtype'="" FallDownTypeSub="(坠床类型)" //坠床
	..;S:(Type["跌倒")&&(FallDownTypeSub'="") Type=Type_FallDownTypeSub
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..Q:((flag'="")&&(flag'=1))&&(CaseShareflag'="Y")
	..Q:(StatType'="")&(StatType'=status)
	..Q:(DeptID'="")&(DeptID'=RepLocDr)
	..Q:(patNo'="")&(patNo'=PatID)
	..Q:(typeevent'="")&(typeevent'=TypeDr)
	..Q:(statShare'="")&(statShare'=RepShareStatus)
	..Q:(repflag'="")&(RepUserDr'=UserId)  //2018-01-13 cy  首页过滤
	..Q:(inpfileflag="N")&(FileFlag="已归档")
	..Q:(inpfileflag="Y")&(FileFlag'="已归档")
	..Q:(OverTime="N")&(RepOverTime'="未超时")&(AutOverTime'="未超时")
	..Q:(OverTime="Y")&(RepOverTime'="已超时")&(AutOverTime'="已超时")
	..Q:(homeRepOverTime="Y")&(RepOverTime'="已超时")
	..Q:(Cancelflag'="Y")&&(RepCancelflag="Y")
	..Q:(Cancelflag="Y")&&(RepCancelflag'="Y")
	..Q:(CondFlag'=1)
	..S count=count+1
	..Q:count<Start
	..Q:count>End
	..W $case(count,Start:"",:",")
	..S OccurLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",OccurLoc) //hxy 2020-06-24 st
	..S RepLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",RepLoc) //ed
	..S RepUser=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",RepUser)
	..S FileFlag=##class(websys.Translation).Get("dhcadv.reportquery.csp",FileFlag)
	..S RepOverTime=##class(websys.Translation).Get("dhcadv.reportquery.csp",RepOverTime)
	..S AutOverTime=##class(websys.Translation).Get("dhcadv.reportquery.csp",AutOverTime)
	..S MedadrReceive=##class(websys.Translation).Get("dhcadv.reportquery.csp",MedadrReceive)
	..S RepShareStatus=##class(websys.Translation).Get("dhcadv.reportquery.csp",RepShareStatus)
	..S:status="N" RepStaus=##class(websys.Translation).Get("dhcadv.reportquery.csp",RepStaus)
	..S:status="Y" RepStaus=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdrEvtWorkFlowItm","ADREWIDesc","",RepStaus)
	..S:(MedadrReceive'="")&&(status="Y") RepStaus=RepStaus_"："_MedadrReceive
	
	..S tmpObj={}
	..S tmpObj.RepID=RepID
	..S tmpObj.recordID=recordID
	..S tmpObj.RepTypeCode=TypeCode
	..S tmpObj.RepType=Type
	..S tmpObj.RepStaus=RepStaus
	..S tmpObj.RepDate=RepDate
	..S tmpObj.RepUser=RepUser
	..S tmpObj.RepLoc=RepLoc 
	..S tmpObj.RepImpFlag=RepImpFlag 
	..S tmpObj.RepShareStatus=RepShareStatus 
	..S tmpObj.Medadrreceive=MedadrReceive			//接收
	..S tmpObj.Medadrreceivedr=MedadrReceivedr		//接收
	..S tmpObj.PatID=PatID
	..S tmpObj.PatName=PatName
	..S tmpObj.RepSubType=RepSubType
	..S tmpObj.RepLevel=RepLevel
	..S tmpObj.RepInjSev=RepInjSev
	..S tmpObj.RepTypeDr=TypeDr
	..S tmpObj.StatusLast=StatusLast
	..S tmpObj.StatusLastID=StatusLastID
	..S tmpObj.AdmNo=AdmNo
	..S tmpObj.OccurLoc=OccurLoc
	..S tmpObj.OccurDate=OccurDate
	..S tmpObj.LocDep=LocDep
	..S tmpObj.FileFlag=FileFlag
	..S tmpObj.RepOverTimeflag=RepOverTime
	..S tmpObj.AutOverTimeflag=AutOverTime
	..S tmpObj.CaseShareLoclist=CaseShareLoclist
	..S tmpObj.StaFistAuditUser=StaFistAuditUser
	..S tmpObj.BackAuditUser=BackAuditUser
	..S tmpObj.RepStausDr=RepStausDr
	..S tmpObj.AdmID=AdmID
	..S tmpObj.IfRepEdit=IFREPEDIT
	..S tmpObj.RepUserDr=RepUserDr
	..W tmpObj.%ToJSON()
	W "],""total"":"_count_"}"
	Q ""
}

/// Description: 根据病人No取病人基本信息
/// Creator:     huaxiaoying
/// CreateDate:  2017-12-26
/// w ##class(web.DHCADVCOMMONPART).GetPatInfoByPatNo("0000000001")
/// return :登记号^病人姓名^性别^年龄^生日^省份证^民族^国家^电话^住址^费别^卡号^卡类型
ClassMethod GetPatInfoByPatNo(PatientNo As %String)
{
	n (PatientNo)
	s PatientID=""
	s PatientID=$o(^PAPERi("PAPMI_PatNo",PatientNo,PatientID))
	i PatientID="" q ""
	s rs=""
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	                    /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)                     /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     					/// 性别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID)   /// 年龄
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        			/// 出生日期
	i birthday'="" s birthday=##class(web.DHCADVCOMMON).DateLogicalToHtml(birthday) 
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)         			/// 身份证号
	s PatNation=""
	s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  			/// 民族
	i nationdr'="" s PatNation=$p(^CT("NAT",nationdr),"^",2)
	s PatCountry=""
	s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	 			/// 国家
	i countrydr'="" s PatCountry=$p(^CT("COU",countrydr),"^",2)
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	  				/// 电话 
	s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	  				/// 家庭住址
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     			/// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s PatDiag=""
	s PatCardNo=""
	s CardTypeID=""
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	i CardNoID'="" d
	.s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 		 		/// 卡号
	.s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 		 	/// 卡类型
	s rs= PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_birthday_"^"_IdentNo
	s rs=rs_"^"_PatNation_"^"_PatCountry_"^"_PatTelH_"^"_Address_"^"_BillType
	s rs=rs_"^"_PatCardNo_"^"_CardTypeID
	q rs
}

/// Description: 不良事件统计界面使用
/// Creator:     QQA
/// CreateDate:  2017-08-28
/// Input:  	 StrParam : 以字符"^"分割,格式为:开始时间^结束时间
/// Table:       FormRecord,FormRecordItm,FormRecordItmSub
/// Return: 	 不良事件 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryRepStatList("10","1","2018-12-10^2019-12-10^^^29^95^10209^^994^^")
/// 
ClassMethod QueryRepStatList(rows = 10, page = 1, StrParam As %String, LgParam As %String)
{
	N (rows,page,StrParam,LgParam)
	Q:StrParam="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S DeptID=$p(StrParam,"^",3)    //科室
	S patNo=$p(StrParam,"^",4)     //登记号
	
    S StatType=$p(StrParam,"^",8)  //状态
    S statShare=$p(StrParam,"^",10)   //分享状态
    S receive=$p(StrParam,"^",11)    //接收
    S repflag=$p(StrParam,"^",12)    //已报标识(Y) 草稿标识(N)
	S GroupId=$p(LgParam,"^",3)   //安全组ID
    S LocId=$p(LgParam,"^",2)     //科室ID
    S UserId=$p(LgParam,"^",1)    //用户ID
	S HospId=$p(LgParam,"^",4)    //医院ID
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",LgParam)
	S:QUERYDATE="1" DateNode="OccurDate"

    I StatType="全部" S StatType=""
    S FormNameInfo=$p(StrParam,"^",9)
    S FormNameID = $p(FormNameInfo,"*",1)
    S FormNameItmType = $p(FormNameInfo,"*",2)
    S ShowDetail="N"
    S:FormNameID'="" ShowDetail="Y"
    S typeevent="",FormNameCode=""
    I FormNameID'="" D
    .S FormNameCode = $lg(^User.DHCAdvFormNameD(FormNameID),2)
    .S:FormNameCode'="" typeevent = $o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(FormNameCode),""),-1)
	S eventparref="",eventsub="" ;2018-08-29
	I typeevent=""  D
	.S:FormNameCode'="" eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(FormNameCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(FormNameCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") typeevent=eventparref_"||"_eventsub
    S h=0  //yangyongtao  2017-11-22 
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	Q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	S count=0
	W "{""rows"":["
	F date=EndDate:-1:StDate D
	.S RepID=""
	.F  S RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) Q:RepID=""  D
	..S RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",Medadrreceive="",Medadrreceivedr="",RepCancelflag="",MedadrNextLocDR=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	..Q:(RepTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(RepTypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..I RepStausDr=""  D
	...S RepStaus="未提交"
	...S status="N"
	..E  D 
	...S status="Y"
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	...I MedadrID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9)
	....S Medadrreceive=$S(Medadrreceivedr="":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....S:Medadrreceive'="" RepStaus=RepStaus_"："_Medadrreceive
	....S RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	....S MedadrNextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	..S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	..S:RepDate'="" RepDate=$zd(RepDate,3) ;##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	..S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S RecRepUser=##class(web.DHCADVCOMMONPART).QueryInputDataInfo(recordID,"填报人姓名")  //取匿名信息 sufan 2019-11-07
	..S:(RecRepUser["匿名")||(RecRepUser["anonymous") RepUser=RecRepUser
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..S RepHospID="" //hxy 2020-02-18 st
	..S:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..Q:(IFDISTHOSP="1")&(RepHospID'="")&(HospId'="")&(HospId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..S RepImpFlag=$p(^DHCADVMASTER(RepID),"^",9) 
	..S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	..S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	..S RepInjSev=$p(^DHCADVMASTER(RepID),"^",13) ///伤害严重度
	..S RepInjSev=$p(^DHCADVMASTER(RepID),"^",13) ///伤害严重度
	..S AdmID=$p(^DHCADVMASTER(RepID),"^",16)   ///就诊ID
	..S PatName=$p(^DHCADVMASTER(RepID),"^",17)   ///病人姓名
	..S PatSex = $p(^DHCADVMASTER(RepID),"^",18)  ///病人性别
	..S PatAge = $p(^DHCADVMASTER(RepID),"^",19)  ///病人年龄
	..S AdmNo=$p(^DHCADVMASTER(RepID),"^",20)  	  ///病案号
	..S OccurLoc=$p(^DHCADVMASTER(RepID),"^",27)  ///发生科室
	..S:OccurLoc'="" OccurLoc=$p(^CTLOC(OccurLoc),"^",2)
	..S:OccurLoc["-" OccurLoc=$p(OccurLoc,"-",2)
	..S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	..S:OccurDate'="" OccurDate=$zd(OccurDate,3) ;##class(web.DHCADVCOMMON).DateLogicalToHtml(OccurDate)
	..S PatID=$p(^DHCADVMASTER(RepID),"^",14)  ///登记号
	..S PapRowid=""
	..S:AdmID'="" PapRowid=$p(^PAADM(AdmID),"^",1)
	..S:(AdmID'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(AdmID,"")  //病案号 
	..S:(PapRowid'="")&&(PatID="") PatID=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	..S:(PapRowid'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",PapRowid)  //病案号
	..S:(PapRowid'="")&&(PatName="") PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..Q:+flag'=1                    //qqa 2018-05-28
	..S RepShareStatus="未分享"
	..S rshShare=$o(^DHCADVRSH(0,"TypePointer",RepTypeDr,RepID,""))
	..I rshShare'="" D
	...S RepShareStatus="分享"
	..S LocDep=""
	..S:RepLocDr'="" LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)
	..Q:(StatType'="")&(StatType'=status)
	..Q:(DeptID'="")&(DeptID'=RepLocDr)
	..Q:(patNo'="")&(patNo'=PatID)
	..Q:(typeevent'="")&(typeevent'=RepTypeDr)
	..Q:(statShare'="")&(statShare'=RepShareStatus)
	..Q:(repflag'="")&(RepUserDr'=UserId)
	..Q:RepCancelflag="Y"
	..S RepType = ##class(web.DHCADVCOMMONPART).GetReportEasyName(RepType)
	..S ADVFormRecDr = $p(^DHCADVMASTER(RepID),"^",1)
	..;过滤掉压疮院内院外，跌倒坠床：跌倒或者坠床
	..S Ulcerorign=""
	..S:(RepType["压疮") Ulcerorign=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(ADVFormRecDr,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("UlcerPart-95158-95163-95170"))
	..Q:(RepType["压疮")&&(FormNameItmType=1)&&(Ulcerorign="")
	..S:Ulcerorign'="" RepType=RepType_"(院内发生)"
	..S Ulcerorign=""
	..S:(RepType["压疮") Ulcerorign=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(ADVFormRecDr,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("UlcerPart-95158-95163-95171"))
	..Q:(RepType["压疮")&&(FormNameItmType=2)&&(Ulcerorign="")
	..S:Ulcerorign'="" RepType=RepType_"(院外带入)"
	..S Ulcerorign=""
	..S:(RepType["跌倒") Ulcerorign=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(ADVFormRecDr,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("FallDownType-94261"))
	..Q:(RepType["跌倒")&&(FormNameItmType=1)&&(Ulcerorign="")
	..S:Ulcerorign'="" RepType=RepType_"(跌倒类型)"
	..S Ulcerorign=""
	..S:(RepType["跌倒")&&(FormNameItmType=2) Ulcerorign=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(ADVFormRecDr,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("FallDownType-94262"))
	..Q:(RepType["跌倒")&&(FormNameItmType=2)&&(Ulcerorign="")
	..S:Ulcerorign'="" RepType=RepType_"(坠床类型)"
	..S count=count+1
	..W $case(count,1:"",:",")
	..S tmpObj={}
	..S tmpObj.RepID=RepID
	..S tmpObj.recordID=recordID
	..S tmpObj.RepTypeCode=RepTypeCode
	..S tmpObj.RepType=RepType
	..S tmpObj.RepStaus=RepStaus
	..S tmpObj.RepDate=RepDate
	..S tmpObj.RepUser=RepUser
	..S tmpObj.RepLoc=RepLoc 
	..S tmpObj.RepImpFlag=RepImpFlag 
	..S tmpObj.RepShareStatus=RepShareStatus 
	..S tmpObj.PatID=PatID
	..S tmpObj.PatName=PatName
	..S tmpObj.PatSex=PatSex
	..S tmpObj.PatAge=PatAge
	..S tmpObj.RepLevel=RepLevel
	..S tmpObj.RepInjSev=RepInjSev
	..S tmpObj.RepTypeDr=RepTypeDr
	..S tmpObj.AdmNo=AdmNo
	..S tmpObj.OccurLoc=OccurLoc
	..S tmpObj.OccurDate=OccurDate
	..S tmpObj.LocDep=LocDep
	..I ShowDetail= "Y" D
	...S AdvMasterDr = RepID              //DHC_AdvMaster的ID
	...S RsDate="",RsString="",tableName=""
	...S RepLocDr=$p(^DHCADVMASTER(AdvMasterDr),"^",7)
	...S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	...S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	...S LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)   //获取大科描述
	...S ADVFormRecDr = $p(^DHCADVMASTER(AdvMasterDr),"^",1)
	...S ADVFormRecItmDr=""
	...F  S ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",ADVFormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	....S ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  //元素ID
	....S ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  //值
	....Q:'$d(^User.DHCAdvFormDicD(ADVFormDicID))
	....S ItmID = $lg(^User.DHCAdvFormDicD(ADVFormDicID),2)        //元素唯一标示，对应界面的ID
	....Q:ItmID["UlcerPart"   //取消掉关于table的数据获取
	....S DataRowKey = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),7)  //Key 只有table才有的标识
	....Q:DataRowKey'=""     //table 数据单独写 先过滤掉
	....Q:ItmValue="title" 
	....S:ItmID="ReportCardSta" ItmValue=RepStaus  //sufan 2019-10-25 报告卡取报告状态
	....D:'$d(TMPData(ItmID)) tmpObj.%Set(ItmID,ItmValue)  //$d(TMPData(ItmID)) no rep has child itm(radio and checkbox)
	....;qqa 2018-11-02 鉴于医院的要求，特留下备注标识统计必须统计radio的父元素
	....;qqa 2018-12-19 不仅有radio，还有radio-input
	....S FormDicType = $lg(^User.DHCAdvFormDicD(ADVFormDicID),3)
	....I (FormDicType="radio")||(FormDicType="radio-input") D  
	.....S:FormDicType="radio-input" ItmValue=$lg(^User.DHCAdvFormDicD(ADVFormDicID),4)  //qqa input性质的父元素统计，描述强行改为title
	.....S ItmParentID = $lg(^User.DHCAdvFormDicD(ADVFormDicID),6)
	.....Q:+ItmParentID=0
	.....S ItmParentField=$lg(^User.DHCAdvFormDicD(ItmParentID),2) 
	.....D tmpObj.%Set(ItmParentField,ItmValue)
	....I (FormDicType="checkbox")||(FormDicType="checkbox-input") D
	.....S:FormDicType="checkbox-input" ItmValue=$lg(^User.DHCAdvFormDicD(ADVFormDicID),4)  //qqa input性质的父元素统计，描述强行改为title
	.....S ItmParentID = $lg(^User.DHCAdvFormDicD(ADVFormDicID),6)
	.....Q:+ItmParentID=0
	.....S ItmParentField=$lg(^User.DHCAdvFormDicD(ItmParentID),2)
	.....S ParItmTitle = $lg(^User.DHCAdvFormDicD(ItmParentID),4)
	.....S ItmParentValue=tmpObj.%Get(ItmParentField)
	.....;这里父元素本身并不需要统计进去，因此判断当存储元素与当自己描述相同时，去掉第一个描述	
	.....S:(ParItmTitle=ItmParentValue)&&($l(ItmParentValue,$c(10))=1) ItmParentValue=""
	.....S:ItmParentValue'="" ItmParentValue=ItmParentValue_$c(10)_ItmValue
	.....S:ItmParentValue="" ItmParentValue=ItmValue
	.....S TMPData(ItmParentField)=""         
	.....D tmpObj.%Set(ItmParentField,ItmParentValue)
	
	.....
	..S Data = $p(##class(web.DHCADVCOMMONPRINT).GetTableData(RepID,"UlcerPart","UlcerPart-95158-95162"),",",1)
	..D tmpObj.%Set("UlcerPart-95158-95162",Data)
	..
	..S Data = ##class(web.DHCADVCOMMONPRINT).GetTableData(RepID,"UlcerPart","UlcerPart-95158-95166")
	..D tmpObj.%Set("UlcerPart-95158-95166",Data)
	..
	..S Data = ##class(web.DHCADVCOMMONPRINT).GetTableData(RepID,"UlcerPart","UlcerPart-95158-95163")
	..D tmpObj.%Set("UlcerPart-95158-95163",Data)
	..
	..S Data = ##class(web.DHCADVCOMMONPRINT).GetTableData(RepID,"UlcerPart","UlcerPart-95158-95169")
	..D tmpObj.%Set("UlcerPart-95158-95169",Data)
	..
	..S Data = ##class(web.DHCADVCOMMONPRINT).GetTableData(RepID,"UlcerPart","UlcerPart-95158-95189")
	..D tmpObj.%Set("UlcerPart-95158-95189",Data)
	..
	..W tmpObj.%ToJSON()

	W "],""total"":"_count_"}"
	Q ""
}

/// Description: 不良事件审核查询（查询已审核的报告记录 —）
/// Creator:     CongYue
/// CreateDate:  2017-08-31
/// Input:  	 StrParam : 以字符"^"分割,格式为:开始时间^结束时间
/// Table:       FormRecord,FormRecordItm,FormRecordItmSub
/// Return: 	 不良事件 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryAuditRepList(30,1,"2018-01-01^2019-11-18^^^69^336^10278^^^^^^^^^^^","10278^336^69^2")
ClassMethod QueryAuditRepList(rows = 10, page = 1, StrParam As %String, LgParam As %String, ParStr As %String, ColParam As %String)
{
  
	N (rows,page,StrParam,LgParam,ParStr,ColParam,%session)
	q:StrParam="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S End = page*rows
	S Start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行

    S UserId=$p(LgParam,"^",1)    //用户ID
    S LocId=$p(LgParam,"^",2)     //科室ID
	S GroupId=$p(LgParam,"^",3)   //安全组ID
	S HospId=$p(LgParam,"^",4)   //医院ID

	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S DeptID=$p(StrParam,"^",3)    //科室
	S patNo=$p(StrParam,"^",4)     //登记号
    S StatTypedr=$p(StrParam,"^",8)  //状态
    S typeevent=$p(StrParam,"^",9)    		//填报类型
    S statShare=$p(StrParam,"^",10)    		//分享状态
    S receive=$p(StrParam,"^",11)    		//接收状态
    S receiveflag=$p(StrParam,"^",12)    	//接收标识
    S impflag=$p(StrParam,"^",13)    		//重点关注
    S appauditflag=$p(StrParam,"^",14) 		//待审批标识
    S backflag=$p(StrParam,"^",15) 			//退回标识
    S auditflag=$p(StrParam,"^",16)  		//已处理标识
   	S inpfileflag=$p(StrParam,"^",17)  		//归档标识
	S OverTime=$p(StrParam,"^",18)    		//是否超时
	S homeAutOverTime=$p(StrParam,"^",19)   //首页是否护士长审核超时
	S RepCode=$p(StrParam,"^",23)			//报告类型过滤
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",LgParam)
	S:QUERYDATE="1" DateNode="OccurDate"
	S IFREPEDIT=##class(web.DHCADVCOMMON).GetEmSysConfig("IFREPEDIT",LgParam) ;2021-04-26 cy 报告是否可以修改 （1：允许修改(报告未做审核操作且报告未归档)，其他：不允许修改）
	
	S OrdFlag=-1
	S ColSort=$p(ColParam,"^",1)  // 列头 
	S ColOrder=$p(ColParam,"^",2)  // desc 降序   asc 升序
	S:(ColSort="RepDate")&&(ColOrder="desc") OrdFlag=-1
	S:(ColSort="RepDate")&&(ColOrder="asc") OrdFlag=1
	// 降序 开始日期 结束日期转换
	I OrdFlag=-1  D
	.S OrdFlagDate=StDate 
	.S StDate=EndDate
	.S EndDate=OrdFlagDate
	
    S h=0  
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	Q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符  //yangyongtao   2017-11-22
	S count=0
	W "{""rows"":["
	F date=StDate:OrdFlag:EndDate D
	.S RepID=""
	.F  S RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) Q:RepID=""  D
	..S RepTypeDr="",RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",Medadrreceive="",Medadrreceivedr="",StatusNext="",MedadrUserID="",MedadrRevStatus="",StaFistAuditUser="",BackAuditUser="",RepOverTimeflag="",AutOverTimeflag="",RepOverTime="",AutOverTime="",RepCancelflag="",StaFistAuditUserDr="",BackAuditUserDr="",MedadrNextLocDR="",RepLevelDr="",RepStaFistAudUserDr=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id） 2020-06-22
	..S RepTypeString=..GetRepTypeString(RepID)
	..S TypeDr=$p(RepTypeString,"^",1) ; 报告表单类型id
	..S TypeCode=$p(RepTypeString,"^",2)
	..S Type=$p(RepTypeString,"^",3)
	..S RepTypeDr=$p(RepTypeString,"^",4)
	..S RepTypeCode=$p(RepTypeString,"^",5)
	..Q:(RepCode'="")&&(RepCode'=RepTypeCode)
	..Q:(TypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(TypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,TypeDr,""))
	..S File="",FileFlag=""
	..S:FILERowID'="" File=$p(^DHCADVFILE(FILERowID),"^",3)
	..S:(File'="Y")||(File'="N") File=..JudgeIsOutCome(RepID,TypeDr,LgParam)
	..S FileFlag=$S(File="0":"未归档",(File="1")||(File="3"):"已归档",File="4":"归档(待复核)",(File="2")||(File="5"):"撤销归档",File="N":"撤销归档",File="Y":"已归档",1:"")
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..Q:RepStausDr=""
	..S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	..S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	..S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	..S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	..S:OccurDate="" OccurDate=0
	..S OccurTime=$p(^DHCADVMASTER(RepID),"^",26)  ///发生时间
	..S:OccurTime="" OccurTime=0
	..S RepOverTime=""
	..S RepOverTimeflag=##class(web.DHCADVCOMMONPART).ChkOverTime(RepID,"FILLTIME",RepDate,RepTime,RepStausDr,LgParam)
	..S RepOverTime=$S(RepOverTimeflag="":"未超时",RepOverTimeflag="N":"未超时",RepOverTimeflag="Y":"已超时",1:"")
	..S:RepStausDr'="" RepStaFistAudUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(RepID,RepTypeDr,RepStausDr)  ;报告第一操作人 2019-02-20
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S Subflag=0
	..S SubUserflag=0 
	..I MedadrID'=""  D
	...S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	...I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	...S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",Medadrreceivedr="3":"撤销",Medadrreceivedr="4":"审核",Medadrreceivedr="5":"归档",Medadrreceivedr="6":"撤销归档",Medadrreceivedr="7":"归档(待复核)",1:"")
	...S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	...S MedadrLocID=$p(^DHCMEDREPADT(MedadrID),"^",12)
	...S MedadrRevStatus=$p(^DHCMEDREPADT(MedadrID),"^",14) ;驳回指向
	...S StaFistAuditDr=""
	...S:(RepTypeDr'="")&&(MedadrRevStatus'="") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(RepID, RepTypeDr, MedadrRevStatus ) ;$o(^DHCMEDREPADT(0,"TypeSta",RepTypeDr,MedadrRevStatus,""))
	...S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	...S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	...S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	...S MedadrNextLocDR=##class(web.DHCADVCOMMONPART).GetNowRepNextLoc(RepID,RepTypeDr,RepStausDr) ;指向科室（分派科室）
	..Q:(appauditflag'="")&&(MedadrNextLocDR'="")&&(MedadrNextLocDR'=LocId)
	..S AuditId="",RepCancelflag="",AutOverTimeflag=""
	..F  S AuditId=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,AuditId),-1)  Q:(AuditId="")  D
	...S OverTimeflag=$p(^DHCMEDREPADT(AuditId),"^",15) ;护士长审核超时标志
	...S Cancelflag=$p(^DHCMEDREPADT(AuditId),"^",11) ;作废标识
	...S:OverTimeflag'="" AutOverTimeflag=OverTimeflag
	...S:Cancelflag'="" RepCancelflag=Cancelflag
	..S AutOverTime=""
	..S AutOverTime=$S(AutOverTimeflag="":"未超时",AutOverTimeflag="N":"未超时",AutOverTimeflag="Y":"已超时",1:"")
	..S Medadrflag=##class(web.DHCADVSEARCHREPORT).SearchAuditIMess(MedadrID)
	..S:Medadrflag=1 Subflag=1 //转抄 
	..S:Medadrflag=2 Subflag=2 //全部回复 
	..S:Medadrflag=3 Subflag=3 //部分回复 
	..S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	..S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	..S RepInjSev=$p(^DHCADVMASTER(RepID),"^",13) ///伤害严重度
	..S params=RepID_"^"_RepTypeCode_"^"_UserId_"^"_LocId 
	..S SubUserflag=##class(web.DHCADVSEARCHREPORT).SearchAuditIUser(MedadrID,params) 
	..S Listt=RepID_"^"_RepTypeDr_"^"_list_"^"_RepStausDr_"^"_MedadrNextLocDR_"^"_RepLevelDr
	..S matalast=##class(web.DHCADVCOMMON).InsStatusLast(Listt) 
	..S StatusLastID=$p(matalast,"^",2)  //上一状态
	..S StatusLast=""
	..I StatusLastID'=""  D
	...S AdrewRowIDnLast=$p(StatusLastID,"||",1)
	...S AdrewChildSubnLast=$p(StatusLastID,"||",2)
	...S StatusLast=$p(^DHCADREVTWFI(AdrewRowIDnLast,"ADREWI",AdrewChildSubnLast),"^",2)
	..S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt,LgParam) 
	..S StatusNextID=$p(matalist,"^",2)  //下一状态
	..I StatusNextID'=""  D
	...S AdrewRowIDn=$p(StatusNextID,"||",1)
	...S AdrewChildSubn=$p(StatusNextID,"||",2)
	...S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	..S:RepDate'="" RepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S RecRepUser=##class(web.DHCADVCOMMONPART).QueryInputDataInfo(recordID,"填报人姓名")  //取匿名信息 sufan 2019-11-07
	..S:(RecRepUser["匿名")||(RecRepUser["anonymous") RepUser=RecRepUser
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..S RepHospID="" //hxy 2020-02-18 st
	..S:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..Q:(IFDISTHOSP="1")&(RepHospID'="")&(HospId'="")&(HospId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..S RepSubType=$p(^DHCADVMASTER(RepID),"^",8)
	..S RepImp=$p(^DHCADVMASTER(RepID),"^",9)
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S AdmID=$p(^DHCADVMASTER(RepID),"^",16)  
	..S PatName=$p(^DHCADVMASTER(RepID),"^",17)  
	..S AdmNo=$p(^DHCADVMASTER(RepID),"^",20)  ///病案号	
	..S OccurLoc=$p(^DHCADVMASTER(RepID),"^",27)  ///发生科室
	..S:OccurLoc'="" OccurLoc=$p(^CTLOC(OccurLoc),"^",2)
	..S:OccurLoc["-" OccurLoc=$p(OccurLoc,"-",2)
	..S:OccurDate="0" OccurDate=""
	..S:(OccurDate'="")&&(OccurDate'="0") OccurDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(OccurDate)
	..S PatID=$p(^DHCADVMASTER(RepID),"^",14)  ///登记号
	..S PapRowid=""
	..S:AdmID'="" PapRowid=$p(^PAADM(AdmID),"^",1)
	..S:(AdmID'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(AdmID,"")  //病案号 
	..S:(PapRowid'="")&&(PatID="") PatID=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	..S:(PapRowid'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",PapRowid)  //病案号
	..S:(PapRowid'="")&&(PatName="") PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	..S RepShareStatus="未分享"
	..S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeDr,RepID,""))
	..I rshShare'="" D
	...S RepShareStatus="分享"
	..I Subflag=0 S Medadrreceive=Medadrreceive
	..I Subflag=1 S Medadrreceive=Medadrreceive_"："_"已转抄"
	..I Subflag=2 S Medadrreceive=Medadrreceive_"："_"全部回复"
	..I Subflag=3 S Medadrreceive=Medadrreceive_"："_"部分回复"
	..S GroupDesc=$p(^SSU("SSGRP",GroupId),"^",1)
	..S StsusGrant=##class(web.DHCADVCOMMON).CheckWorkItmGrant(RepStausDr,LgParam,2)  ;判断当前登录人对此报告状态是否有授权
	..S:(StaFistAuditUserDr'=UserId)&&(RepStaFistAudUserDr'=UserId) StsusGrant=0
	..S UserLeadflag=..GetSecuUserLeader(UserId,GroupId)
	..S StatusNextIDaudit=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,"",LgParam)
	..S LocDep=""
	..S:RepLocDr'="" LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)  ;报告科室所属大科系统
	..S CaseShareflag="",CaseShareLoclist="",CaseShareUserlist="",CaseShareAdvicelist=""
	..S CaseShareflag=..GetCaseFlag(RepID,TypeDr,LocId,UserId)
	..S ShareDataList=..GetCaseLocList(RepID,TypeDr)
	..I ShareDataList["&&" S CaseShareLoclist=$p(ShareDataList,"&&",1) //共享科室列表
	..I ShareDataList["&&" S CaseShareUserlist=$p(ShareDataList,"&&",2) //共享用户列表
	..I ShareDataList["&&" S CaseShareAdvicelist=$p(ShareDataList,"&&",3) //共享意见列表
	..S RepAppAuditFlag=0
	..S:StatusNextIDaudit=StatusNextID RepAppAuditFlag=1
	..S CondFlag=..CheckCondition(ParStr,RepID,LgParam,2)  //高级查询条件判断
	..S PatOutFlag="N"  //转归标识
	..S:##class(web.DHCADVCOMMONPART).GetRecordId(recordID,"PatOutcomform")'="" PatOutFlag="Y"
	..S MedadrUserLocList=##class(web.DHCADVCOMMON).GetRepAuditUserLoc(RepID,RepTypeDr)	
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..Q:((flag'="")&&(flag'=1))&&(CaseShareflag'="Y") 
	..Q:(StatTypedr'="")&&(StatTypedr'=RepStausDr)
	..Q:(DeptID'="")&&(DeptID'=RepLocDr)
	..Q:(patNo'="")&&(patNo'=PatID)
	..Q:(typeevent'="")&&(typeevent'=TypeDr) 
	..Q:(receive'="")&&(receive'[Medadrreceivedr) 
	..Q:(statShare'="")&&(statShare'=RepShareStatus)
	..Q:(receiveflag="Y")&(MedadrUserID'=UserId) ;校验报告是否为本人接收的报告
	..Q:(impflag'="")&&(impflag'=RepImp) 
	..Q:(appauditflag'="")&&((StatusNextIDaudit'=StatusNextID)&&(SubUserflag'=1))  ;校验报告是否为本人待审批的报告,待转抄回复的报告
	..Q:(backflag="Y")&&(Medadrreceivedr="2")&&(StaFistAuditUserDr'=UserId)&&(BackAuditUserDr'=UserId)  ;校验报告是否为本人审核并且被驳回来的报告
	..Q:(auditflag="Y")&&((("；"_MedadrUserLocList)'[("；"_LocId_":"_UserId_"；"))||(Medadrreceivedr="未接收")||(Medadrreceivedr="1")||(Medadrreceivedr="3"))  ;校验报告是否为本人处理的报告(最新操作 驳回或者审核)	
	..Q:(inpfileflag="N")&&(FileFlag="已归档")  ;||((StsusGrant'=1)&&(BackAuditUserDr'=UserId))
	..Q:(inpfileflag="Y")&&(FileFlag'="已归档")
	..Q:(OverTime="N")&&(RepOverTime'="未超时")&&(AutOverTime'="未超时")
	..Q:(OverTime="Y")&&(RepOverTime'="已超时")&&(AutOverTime'="已超时")
	..Q:(homeAutOverTime="Y")&(AutOverTime="未超时")
	..Q:(RepCancelflag="Y")
	..Q:(CondFlag'="1")
	..S count=count+1
	..Q:count<Start
	..Q:count>End
	..W $case(count,Start:"",:",")
	..S OccurLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",OccurLoc) //hxy 2020-06-24 st
	..S RepLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",RepLoc) //ed
	..S RepUser=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",RepUser)
	..S FileFlag=##class(websys.Translation).Get("dhcadv.reportaudit.csp",FileFlag)
	..S RepOverTime=##class(websys.Translation).Get("dhcadv.reportaudit.csp",RepOverTime)
	..S AutOverTime=##class(websys.Translation).Get("dhcadv.reportaudit.csp",AutOverTime)
	..S Medadrreceive=##class(websys.Translation).Get("dhcadv.reportaudit.csp",Medadrreceive)
	..S RepImpFlag=##class(websys.Translation).Get("dhcadv.reportaudit.csp",RepImpFlag)
	..S RepShareStatus=##class(websys.Translation).Get("dhcadv.reportaudit.csp",RepShareStatus)
	..S RepStaus=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdrEvtWorkFlowItm","ADREWIDesc","",RepStaus)
	..S tmpObj={}
	..S tmpObj.RepID=RepID
	..S tmpObj.recordID=recordID
	..S tmpObj.RepTypeCode=TypeCode
	..S tmpObj.RepType=Type
	..S tmpObj.RepStaus=RepStaus
	..S tmpObj.RepStausDr=RepStausDr
	..S tmpObj.StatusNext=StatusNext
	..S tmpObj.StatusNextID=StatusNextID
	..S tmpObj.RepDate=RepDate
	..S tmpObj.Medadrreceive=Medadrreceive
	..S tmpObj.Medadrreceivedr=Medadrreceivedr
	..S tmpObj.RepUser=RepUser
	..S tmpObj.RepLoc=RepLoc 
	..S tmpObj.RepImpFlag=RepImpFlag 
	..S tmpObj.RepShareStatus=RepShareStatus 
	..S tmpObj.PatID=PatID
	..S tmpObj.PatName=PatName
	..S tmpObj.RepSubType=RepSubType
	..S tmpObj.Subflag=Subflag
	..S tmpObj.SubUserflag=SubUserflag
	..S tmpObj.RepLevel=RepLevel
	..S tmpObj.RepInjSev=RepInjSev
	..S tmpObj.StatusLast=StatusLast
	..S tmpObj.StatusLastID=StatusLastID
	..S tmpObj.RepTypeDr=TypeDr
	..S tmpObj.AdmNo=AdmNo
	..S tmpObj.OccurLoc=OccurLoc
	..S tmpObj.OccurDate=OccurDate
	..S tmpObj.LocDep=LocDep
	..S tmpObj.StsusGrant=StsusGrant
	..S tmpObj.MedadrRevStatus=MedadrRevStatus
	..S tmpObj.StaFistAuditUser=StaFistAuditUser
	..S tmpObj.BackAuditUser=BackAuditUser
	..S tmpObj.FileFlag=FileFlag
	..S tmpObj.RepOverTimeflag=RepOverTime
	..S tmpObj.AutOverTimeflag=AutOverTime
	..S tmpObj.CaseShareLoclist=CaseShareLoclist
	..S tmpObj.CaseShareUserlist=CaseShareUserlist
	..S tmpObj.CaseShareAdvicelist=CaseShareAdvicelist
	..S tmpObj.UserLeadflag=UserLeadflag
	..S tmpObj.AdmID=AdmID
	..S tmpObj.RepAppAuditFlag=RepAppAuditFlag
	..S tmpObj.RepLocDr=RepLocDr
	..S tmpObj.StatusNextIDaudit=StatusNextIDaudit
	..S tmpObj.PatOutFlag=PatOutFlag
	..S tmpObj.CaseShareflag=CaseShareflag
	..S tmpObj.IfRepEdit=IFREPEDIT
	..S tmpObj.RepUserDr=RepUserDr
	..W tmpObj.%ToJSON()
	W "],""total"":"_count_"}"
	Q ""
}

/// Description: 不良事件升级中的重点关注
/// Creator:     CongYue
/// CreateDate:  2017-9-5
/// Table: 		 DHC_AdvMaster
/// Input:  	 报告主表ID 重点关注标记
/// Return： 	 0 修改成功，非0 修改失败
/// Others:		 w ##class(web.DHCADVCOMMONPART).InsRepImp("59","N")
ClassMethod InsRepImp(RepID As %String, RepImpFlag As %String) As %String
{
	N (RepID,RepImpFlag)
    I RepImpFlag="N" D
    .S RepImpFlag="Y"
    E  S RepImpFlag="N"  
    &SQL(Update DHC_AdvMaster Set ADV_RepImpFlag=:RepImpFlag where ADV_RowID=:RepID)	
	Q SQLCODE
}

/// Description: 首页 获取事件填报类型
/// Creator:     CongYue
/// CreateDate:  2017-9-6
/// Table: 		 DHC_MedAdrRepEvent  DHC_AdvQuerySec
/// Input:  	 报告主表ID 重点关注标记
/// Return： 	 0 修改成功，非0 修改失败
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetRepTypeList("1223^6^235")
ClassMethod GetRepTypeList(UserList As %String) As %String
{
	N (UserList)
	S UserDR=$p(UserList,"^",1)
	S LocDR=$p(UserList,"^",2)
	S GroupDR=$p(UserList,"^",3)
	s ListTitle="id^value"
	S count = 0
	W "["
	S RepTypeID=""
	F  S RepTypeID=$o(^DHCMEDADREVT(RepTypeID))  Q:RepTypeID=""  D
	.Q:RepTypeID=0
	.S RepTypeCode=$p(^DHCMEDADREVT(RepTypeID),"^",1)
	.S RepTypeDesc=$p(^DHCMEDADREVT(RepTypeID),"^",2)
	.S RepTypeActiveFlag=$p(^DHCMEDADREVT(RepTypeID),"^",3)
	.Q:RepTypeActiveFlag="N"
	.Q:('$d(^DHCADVQUS(0,"RepType",RepTypeID,3,UserDR)))&&('$d(^DHCADVQUS(0,"RepType",RepTypeID,2,LocDR)))&&('$d(^DHCADVQUS(0,"RepType",RepTypeID,1,GroupDR)))  ;查看权限的判断
	.S CH=""
	.F  S CH=$o(^DHCMEDADREVTI(RepTypeID,"MADREVI",CH)) Q:CH=""  D
	..S Code=$p(^DHCMEDADREVTI(RepTypeID,"MADREVI",CH),"^",1) //代码
	..S Desc=$p(^DHCMEDADREVTI(RepTypeID,"MADREVI",CH),"^",2) //描述
	..S Active=$p(^DHCMEDADREVTI(RepTypeID,"MADREVI",CH),"^",3) //是否可用
	..Q:Active="N"
	..Q:'$D(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(Code)))
	..S ListData=Code_"^"_Desc
	..S count = count+1
	..I count=1 D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	.Q:($D(^DHCMEDADREVTI(RepTypeID,"MADREVI")))  ;去除带有子元素的类型
	.Q:'$D(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(RepTypeCode)))  ;去除不是表单的类型
	.S ListData=RepTypeCode_"^"_RepTypeDesc
	.S count = count+1
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	W "]"
	Q ""
}

/// Description: 不良反应报告审批
/// Creator:     CongYue
/// CreateDate:  2016-03-09
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^审核状态^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0 审批成功
/// Others:		 w ##class(web.DHCADVCOMMONPART).AuditMataReport("66^34||2^1223^4^235^^人太少隔热率^^advMedical")
ClassMethod AuditMataReport(params As %String, LgParam As %String) As %String
{
	N (params,LgParam)
	S ListData = ..AuditReport(params,LgParam)
	S ListTitle="ErrCode^ErrMsg"
	W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Description: 不良反应报告审批
/// Creator:     CongYue
/// CreateDate:  2015-11-10
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^审核状态^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0 审批成功
/// Others:		 w ##class(web.DHCADVCOMMONPART).AuditReport("32^10||2^10876^149^25^^^1^advPipeOff")
ClassMethod AuditReport(params As %String, LgParam As %String) As %String
{
	
	N (params,LgParam)
	S ID=+$p(params,"^",1)       //不良反应报告ID
	S medadrStatusDR=$p(params,"^",2)  //审核状态
	S medadrAuditUserDR=+$p(params,"^",3)     //用户ID
	S LgCtLocID=+$p(params,"^",4)     //科室ID
	S LgGroupID=+$p(params,"^",5)     //安全组ID
	S medadrNextLocDR=$p(params,"^",6)
	S medadrLocAdvice=$p(params,"^",7)
	S medadrReceive=$p(params,"^",8)
	S typecode=$p(params,"^",9) // 报告类型代码
	S medadrRecProgress=$p(params,"^",10) //调查核实
	
	// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id）
	S RepTypeString=..GetRepTypeString(ID)
	S eventDr=$p(RepTypeString,"^",4)
	S typecode=$p(RepTypeString,"^",5)
	
	// 驳回报告不能审核
	Q:medadrReceive="2" "-6^报告已驳回，不能审核"
	
	// 判断是否存在指向科室 且 符合审核权限
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",eventDr,ID,""),-1)
	S NextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（被指向的审批科室）
	Q:(NextLocDR'="")&&(NextLocDR'="0")&&(LgCtLocID'=NextLocDR) "-8^登录科室无审批权限，不能审核"
	
	// 判断报告状态是否存在第一审核人
	S StaFistAuditUserDr="",StaFistAuditUser=""
	S:medadrStatusDR'="" StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID,eventDr,medadrStatusDR)  ;报告第一操作人 2019-02-20
	S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2)
	Q:(StaFistAuditUserDr'="")&&(StaFistAuditUserDr'=medadrAuditUserDR) "-11^登录人不是"_StaFistAuditUser_"，不能审核"	  ;2019-02-20
	
	// 判断转抄是否完成 flag为2 代表 完成转抄  0 代表没有转抄信息
	S flag=##class(web.DHCADVSEARCHREPORT).SearchAuditIMess(MedadrID)
	Q:(flag'="2")&&(flag'="0") "-7^转抄审批信息未完成，不能审核"
	
	// 获取符合权限的下一状态
	S RepLevel=$p(^DHCADVMASTER(ID),"^",12) // 不良事件级别
	S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	S list=medadrAuditUserDR_"^"_LgCtLocID_"^"_LgGroupID
	S Listt=ID_"^"_eventDr_"^"_list_"^^"_NextLocDR_"^"_RepLevelDr

	S StatusNextID=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,"",LgParam)
	Q:StatusNextID="-1" "-1^无权限"
	Q:StatusNextID="-2" "-2^已是最后一个权限"
	Q:StatusNextID="-3" "-3^无授权工作流"
	Q:StatusNextID="-4" "-4^无配置子项"
	I StatusNextID'="" D
	.S AdrewRowIDn=$p(StatusNextID,"||",1)
	.S AdrewChildSubn=$p(StatusNextID,"||",2)
	.S MataStatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	I medadrReceive="未接收"  D
	.S medadrReceive="1"
	S medadrReceive=4 ;审核
	S medadrAuditDate=+$h
	S medadrAuditTime=$p($h,",",2)
	
	// 计算受理是否超时
	S TimeOutFlag=""
	S OccurDate=$p(^DHCADVMASTER(ID),"^",25)  ///发生日期
	S:OccurDate="" OccurDate=0
	S OccurTime=$p(^DHCADVMASTER(ID),"^",26)  ///发生时间
	S:OccurTime="" OccurTime=0
	; 2021-03-26 cy 受理超时程序修改
	;S HolidayDate=##class(web.DHCADVCOMMONPART).CheckTimeEscapeHoliday(OccurDate,OccurTime,medadrAuditDate,medadrAuditTime)
	;S AcceptTime=##class(web.DHCADVCOMMON).GetEmSysConfig("ACCEPTTIME",LgParam)  ///受理时限时长
	;I (+AcceptTime'=0)&&(HolidayDate>AcceptTime) S TimeOutFlag="Y"   //受理超时
	S TimeOutFlag=##class(web.DHCADVCOMMONPART).ChkOverTime(ID,"ACCEPTTIME",medadrAuditDate,medadrAuditTime,medadrStatusDR,LgParam)
	
	
	S medadrRetReason="",RevStatus="",RepCancelFlag=""
	
	S Err=0
	TS
	S Err=..InsAdvMasterStart(ID,medadrStatusDR)
	I Err'=0 tro
	Q:Err'=0 "-05"

	S matadrRepAuditList=medadrStatusDR_"^"_list_"^"_medadrNextLocDR_"^"_medadrLocAdvice_"^"_medadrReceive_"^"_eventDr_"^"_medadrRetReason_"^"_RevStatus_"^"_TimeOutFlag_"^"_RepCancelFlag_"^"_medadrRecProgress
	S retVal=##class(web.DHCADVCOMMON).InsRepAudit(ID,matadrRepAuditList)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	
	S Err=##class(web.DHCADVCOMMONPART).InsWebsysMessage(ID, medadrAuditUserDR, "",LgParam)
	I Err'=0 tro
	Q:Err'=0 "-99"
	
	TC
	Q 0
}

/// Description: 插入不良事件关联表主表报告状态
/// Creator:     CongYue
/// CreateDate:  2017-09-11
/// Input:  	 主表id , 报告状态
/// Return:		 插入成功 0,插入失败 非0
ClassMethod InsAdvMasterStart(RepID As %String, StatuDr As %String) As %String
{
	N (RepID,StatuDr)
	&sql(update DHC_AdvMaster set ADV_RepStaus_Dr=:StatuDr where ADV_RowID=:RepID)
	Q SQLCODE
}

/// Description: 不良事件查询 
/// Creator:     CongYue
/// CreateDate:  2017-08-28
/// Input:  	 LgParam : 以字符"^"分割,格式为:人员、科室、安全组、医院
/// Table:       FormRecord,FormRecordItm,FormRecordItmSub
/// Return: 	 收件一览 已报事件 重点关注 草稿箱 归档事件 待审批报告 被退回报告 填写时限 受理时限 全部已处理报告 待定
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryRepListAll("10","1","12177^114^23^2")
ClassMethod QueryRepListAll(rows = 10, page = 1, LgParam As %String)
{
  
	N (rows,page,LgParam)
	Q:LgParam="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S RecListnum="", Complenum="", RepImpnum="", Draftsnum="",Filenum="",PendAuditnum="",Backnum="",FillTimenum="",AcceptTimenum="",Auditnum="",Pendnum=""  
	S End = page*rows
	S Start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	S DateList=##class(web.DHCADVCOMMON).GetStaEndDate(LgParam,3)
	S StDate=$p(DateList,"^",1)    //开始日期
	S:StDate'="" StDate=$zdh(StDate,3)
	S EndDate=$p(DateList,"^",2)   //结束日期
    S:EndDate'="" EndDate=$zdh(EndDate,3)
    S UserId=$p(LgParam,"^",1)    //用户ID
    S LocId=$p(LgParam,"^",2)     //科室ID
	S GroupId=$p(LgParam,"^",3)   //安全组ID
    S HospId=$p(LgParam,"^",4)    //医院ID
    S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",LgParam)
	S:QUERYDATE="1" DateNode="OccurDate"
	Q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S count=0
	;w "["
	F date=StDate:1:EndDate D
	.S RepID=""
	.F  S RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) Q:RepID=""  D
	..S RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",MedadrReceive="",MedadrReceivedr="",RepOverTimeflag="",AutOverTimeflag="",RepCancelflag="",StaFistAuditUserDr="",StaFistAuditUser="",BackAuditUserDr="",BackAuditUser="",MedadrNextLocDR="",RepLevelDr=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id） 2020-06-22
	..S RepTypeString=..GetRepTypeString(RepID)
	..S TypeDr=$p(RepTypeString,"^",1) ; 报告表单类型id
	..S TypeCode=$p(RepTypeString,"^",2)
	..S Type=$p(RepTypeString,"^",3)
	..S RepTypeDr=$p(RepTypeString,"^",4)
	..S RepTypeCode=$p(RepTypeString,"^",5)
	..Q:RepTypeDr=""
	..Q:(TypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(TypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..;S:MedadrID'="" RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	..S AuditId="",RepCancelflag="",AutOverTimeflag=""
	..F  S AuditId=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,AuditId),-1)  Q:(AuditId="")  D
	...S OverTimeflag=$p(^DHCMEDREPADT(AuditId),"^",15) ;护士长审核超时标志
	...S Cancelflag=$p(^DHCMEDREPADT(AuditId),"^",11) ;作废标识
	...S:OverTimeflag'="" AutOverTimeflag=OverTimeflag
	...S:Cancelflag'="" RepCancelflag=Cancelflag
	..S AutOverTime=""
	..S AutOverTime=$S(AutOverTimeflag="":"未超时",AutOverTimeflag="N":"未超时",AutOverTimeflag="Y":"已超时",1:"")
	..Q:RepCancelflag="Y"
	..S:MedadrID'="" MedadrNextLocDR=##class(web.DHCADVCOMMONPART).GetNowRepNextLoc(RepID,RepTypeDr,RepStausDr) ;指向科室（分派科室）
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..S RepHospID="" //hxy 2020-02-18 st
	..S:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..Q:(IFDISTHOSP="1")&(RepHospID'="")&(HospId'="")&(HospId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..S GroupDesc=$p(^SSU("SSGRP",GroupId),"^",1)
	..S Secuflag=..GetSecuGroupWard(UserId, RepLocDr) ;判断登录人是否属于大科安全组 病区 是否有查看权限
	..S SecuLocflag=..GetSecuGroupLoc(UserId, RepLocDr) ;判断登录人是否属于大科安全组 科室 是否有查看权限
	..Q:((flag'="")&&(flag'=1))
	..S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,RepTypeDr,""))
	..S File="",FileFlag=""
	..S:FILERowID'="" FileFlag=$p(^DHCADVFILE(FILERowID),"^",3)
	..s:(FileFlag'="Y")||(FileFlag'="N") File=..JudgeIsOutCome(RepID,RepTypeDr,LgParam)
	..S:(FileFlag="Y")||(File=1)||(File=3) Filenum=Filenum+1  //归档事件
	..S:(RepLocDr=LocId)&&(RepStausDr="")&&(RepUserDr=UserId) Draftsnum=Draftsnum+1  ;草稿箱
	..I RepStausDr'=""  D
	...S:(RepLocDr=LocId)&&(RepUserDr=UserId)&&(FileFlag'="Y") Complenum=Complenum+1 ;已报事件
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	...Q:MedadrID=""
	...S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	...S MedadrLocID=$p(^DHCMEDREPADT(MedadrID),"^",12)
	...S:MedadrID'="" MedadrReceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9)
	...S:MedadrReceivedr="" MedadrReceivedr="未接收"
	...S MedadrRevStatus=$p(^DHCMEDREPADT(MedadrID),"^",14) ;驳回指向
	...S StaFistAuditDr=""
	...S:(RepTypeDr'="")&&(MedadrRevStatus'="") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(RepID, RepTypeDr, MedadrRevStatus ) ;$o(^DHCMEDREPADT(0,"TypeSta",RepTypeDr,MedadrRevStatus,""))
	...S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	...S:MedadrReceivedr="2" BackAuditUserDr=MedadrUserID
	...S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	...;S:(MedadrID'="") AutOverTimeflag=$p(^DHCMEDREPADT(MedadrID),"^",15) ;护士长审核超时标志
	...S:(MedadrReceivedr="1")&&(MedadrUserID=UserId) RecListnum=RecListnum+1  ;收件一览
	...S StsusGrant=##class(web.DHCADVCOMMON).CheckWorkItmGrant(RepStausDr,LgParam,2)
	...S:(MedadrReceivedr="2")&&((StaFistAuditUserDr=UserId)||(BackAuditUserDr=UserId)) Backnum=Backnum+1  ;被退回报告	
	...S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	...S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	...S Listt=RepID_"^"_RepTypeDr_"^"_list_"^"_RepStausDr_"^"_MedadrNextLocDR_"^"_RepLevelDr
	...S StatusNextIDaudit=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,"",LgParam) ;报告下一状态（根据报告审批记录获取）
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt,LgParam) 
	...S UserLeadflag=..GetSecuUserLeader(UserId,GroupId)
	...S StatusNextID=$p(matalist,"^",2) ;报告下一状态 （根据报告状态获取）
	...S StatusNext=""
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	...;S:(StatusNextIDaudit=StatusNextID)&&((MedadrNextLocDR="")||((MedadrNextLocDR'="")&&(MedadrNextLocDR=LocId)))&&((StatusNext'["科")||((StatusNext["科")&&(UserLeadflag=1))) PendAuditnum=PendAuditnum+1   //待审批报告
	...S params=RepID_"^"_RepTypeCode_"^"_UserId_"^"_LocId 
	...S SubUserflag=##class(web.DHCADVSEARCHREPORT).SearchAuditIUser(MedadrID,params) 
	...S:(SubUserflag=1)||((StatusNextIDaudit=StatusNextID)&&((MedadrNextLocDR="")||((MedadrNextLocDR'="")&&(MedadrNextLocDR=LocId)))) PendAuditnum=PendAuditnum+1   //待审批报告
	...S matalast=##class(web.DHCADVCOMMON).InsStatusLast(Listt) 
	...S StatusLastID=$p(matalast,"^",2)  //上一状态
	...S MedadrUserLocList=##class(web.DHCADVCOMMON).GetRepAuditUserLoc(RepID,RepTypeDr)	
	...S:(MedadrReceivedr'="未接收")&&(MedadrReceivedr'=1)&&(MedadrReceivedr'=3)&&(("；"_MedadrUserLocList)[("；"_LocId_":"_UserId_"；")) Auditnum=Auditnum+1   //全部已处理报告  上一状态不为空，且是我对该报告进行的最后一次处理（除了接收操作）
	...;w:(MedadrReceivedr'=1)&&(MedadrReceivedr'="")&&(MedadrReceivedr'=3)&&(MedadrUserID=UserId) "**"_MedadrReceivedr_"^"_MedadrUserID_"^"_UserId_"^"_RepID
	..S RepImpFlag=$p(^DHCADVMASTER(RepID),"^",9)
	..S:(RepStausDr'="")&&(RepImpFlag="Y") RepImpnum=RepImpnum+1  //重点关注
	..S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	..S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	..S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  //发生日期
	..S:OccurDate="" OccurDate=0
	..S OccurTime=$p(^DHCADVMASTER(RepID),"^",26)  //发生时间
	..S:OccurTime="" OccurTime=0
	..S RepOverTime=""
	..; 2021-03-26 cy 填写超时程序修改
	..;S HolidayDate=##class(web.DHCADVCOMMONPART).CheckTimeEscapeHoliday(OccurDate,OccurTime,RepDate,RepTime)
	..;S FillTime=##class(web.DHCADVCOMMON).GetEmSysConfig("FILLTIME",LgParam)  ///填报时限时长
	..;I (+FillTime'=0)&&(HolidayDate>FillTime) S RepOverTimeflag="Y"   //填报超时
	..S RepOverTimeflag=##class(web.DHCADVCOMMONPART).ChkOverTime(RepID,"FILLTIME",RepDate,RepTime,RepStausDr,LgParam)
	..S:RepOverTimeflag="Y" FillTimenum=FillTimenum+1  //填写时限
	..S:AutOverTimeflag="Y" AcceptTimenum=AcceptTimenum+1	 //受理时限
	
	;S NumList=RecListnum_"^"_Complenum_"^"_RepImpnum_"^"_Draftsnum_"^"_Filenum_"^"_PendAuditnum_"^"_Backnum_"^"_FillTimenum_"^"_AcceptTimenum_"^"_Auditnum_"^"_Pendnum  
	s tmpObj={}
	s tmpObj.RecListnum=RecListnum
	s tmpObj.Complenum=Complenum
	s tmpObj.RepImpnum=RepImpnum
	s tmpObj.Draftsnum=Draftsnum
	s tmpObj.Filenum=Filenum
	s tmpObj.PendAuditnum=PendAuditnum
	s tmpObj.Backnum=Backnum
	s tmpObj.FillTimenum=FillTimenum
	s tmpObj.AcceptTimenum=AcceptTimenum
	s tmpObj.Auditnum=Auditnum
	s tmpObj.Pendnum=Pendnum
	q tmpObj
}

/// Description: 获取 数据保存值（input、combobox、textarea 类型（患者ID,就诊形式,事件发生部门）） 
/// Creator:     CongYue
/// CreateDate:  2017-10-13
/// Input:  	 record : 表单填写记录表ID, title:所需元素保存值的元素描述（患者ID,就诊形式,事件发生部门,叙述事件经过及详细信息）
/// Table:       FormRecordItm,FormDic
/// Return: 	 Data  数据保存值
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryInputDataInfo(96,"填报人姓名")
ClassMethod QueryInputDataInfo(record As %String, title As %String)
{
	n (record,title)
	s ItmID="",Data=""
	f  s ItmID=$o(^User.DHCAdvFormRecordItmI("IndexFormRecord",record,ItmID)) q:ItmID=""  d
	.s data=^User.DHCAdvFormRecordItmD(ItmID)
	.s FormdicID="",RepSubTypedr=""
	.f  s FormdicID=$o(^User.DHCAdvFormDicI("IndexTitle"," "_title,FormdicID)) q:FormdicID=""  d
	..s Formdicdata=^User.DHCAdvFormDicD(FormdicID)
	..s style=$LIST(Formdicdata,3)
	..q:(style'="")&&((style'="input")&&(style'="textarea")&&(style'="easyui-combobox"))
	..S:FormdicID=$LIST(data,3) Data=$LIST(data,4)
	..Q:Data'=""
	
	q Data
}

/// Description: 获取 数据保存值（单选框 复选框类型（事件发生地点,应给药物剂量）） 
/// Creator:     CongYue
/// CreateDate:  2017-10-13
/// Input:  	 record : 表单填写记录表ID, title:所需元素保存值的元素描述（事件发生地点,应给药物剂量）
/// Table:       FormRecordItm,FormDic
/// Return: 	 Data  数据保存值 用","分割(英文逗号)
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryCheckDataInfo(33,"事件发生地点")
ClassMethod QueryCheckDataInfo(record As %String, title As %String)
{
	n (record,title)
	s ItmID="",Data=""
	f  s ItmID=$o(^User.DHCAdvFormRecordItmI("IndexFormRecord",record,ItmID)) q:ItmID=""  d
	.s data=^User.DHCAdvFormRecordItmD(ItmID)
	.s FormdicID="",RepSubTypedr=""
	.f  s FormdicID=$o(^User.DHCAdvFormDicI("IndexTitle"," "_title,FormdicID)) q:FormdicID=""  d
	..s Formdicdata=^User.DHCAdvFormDicD(FormdicID)
	..s style=$LIST(Formdicdata,3)
	..q:(style'="")&&(style'="radio")&&(style'="label")&&(style'="checkbox")&&(style'="radio-input") 
	..s parrefdicID="",parrefdictitle=""
	..f  s parrefdicID=$o(^User.DHCAdvFormDicI("IndexParef"," "_FormdicID,parrefdicID)) q:parrefdicID=""  d
	...s parrefdicdata=^User.DHCAdvFormDicD(parrefdicID)
	...s parrefdictitle=$LIST(parrefdicdata,4)
	...S:parrefdicID=$LIST(data,3) Data=parrefdictitle_","_Data
	...;Q:Data'=""
	q Data
}

/// Description: 不良反应报告按病区统计
/// Creator:     CongYue
/// CreateDate:  2017-10-17  
/// Input:  	 开始日期^结束日期"12","1","2016-02-02^2016-02-02"
/// Output:   	 不良事件个数^不良反应报告总数
/// Others:		 w ##class(web.DHCADVCOMMONPART).StaticPreAlert("12","1","2018-01-01^2021-2-22^29^113^12175")
ClassMethod StaticPreAlert(rows As %String, page As %String, params As %String, LgParam As %String = "") As %String
{
	N (rows,page,params,%session,LgParam)
	S End = page*rows
	S Start = (page-1)*rows+1
	S pid=##class(web.DHCADVCOMMON).NewPid()
	S StDate=$p(params,"^",1)       //开始日期
	S EndDate=$p(params,"^",2)      //结束日期
	S GroupId=$p(LgParam,"^",1)   //安全组ID
    S LocId=$p(LgParam,"^",2)     //科室ID
    S UserId=$p(LgParam,"^",3)    //用户ID
	s HospId=$p(LgParam,"^",4) //hxy 2020-02-24 st
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",LgParam)
	S:QUERYDATE="1" DateNode="OccurDate"
	S StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate) //$zdh(StDate,3)
	S EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate) //$zdh(EndDate,3)
	S Repnum=0
	S Num=1
	S ID=""
	F date=StDate:1:EndDate D
	.s RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) q:RepID=""  d
	..S RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepLocType=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	..Q:(RepTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(RepTypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..;Q:RepStausDr=""  ;2018-01-11  统计所有填写的报告 
	..S RepCancelflag=""
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S:MedadrID'="" RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	..Q:RepCancelflag="Y"
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..s RepHospID="" //hxy 2020-02-18 st
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(HospId'="")&(HospId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S:RepLocDr'="" RepLocType=$p(^CTLOC(RepLocDr),"^",13)  ;为W 属于病区
	..;Q:RepLocType'="W"
	..S RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S GroupDesc="",flag="",Secuflag="",SecuLocflag=""
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S:UserId'="" flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..Q:((flag'="")&&(flag'=1))
	..I (RepTypeDr'="")&&(RepTypeDr'["||") D
	...S RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	...S RepType=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEvent","MADREVDesc","",RepType)
	..I (RepTypeDr'="")&&(RepTypeDr["||")  D
	...S RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	...S RepType=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEventItm","MADREVIDesc","",RepType)
	..S RepLoc=##class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",RepLoc) 
	..I $d(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,RepLoc,RepTypeCode)) D
	...S $p(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,RepLoc,RepTypeCode),"^",3)=$p(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,RepLoc,RepTypeCode),"^",3)+Num
	..E  S ^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,RepLoc,RepTypeCode)=RepLoc_"^"_"报告数量"_"^"_Num_"^"_RepType_"^"_RepTypeDr
	
	S typecode=""
	S ward=""
	S Numalls=0
	S h=0
	
	F  S ward=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,ward)) Q:ward=""  D
	.F  S typecode=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,ward,typecode)) Q:typecode=""  D
	..S Numall=$p(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,ward,typecode),"^",3)
	..S ListData=$g(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,ward,typecode))
	..S h=h+1
	..S ^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,+Numall,ward,typecode,h)=ListData
	.
	
	I h=0 W ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	S ListTitle="name^group^value^reptype"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S Num=0
	S count=""
	S ward=""
	S typecode=""
	S index=""
	F  S count=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,count),-1) Q:count=""  D
	.F  S ward=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,count,ward)) Q:ward=""  D
	..F  S typecode=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,count,ward,typecode)) Q:typecode=""  D
	...F  S index=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,count,ward,typecode,index)) Q:index=""  D
	....S ListData=$g(^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid,count,ward,typecode,index))
	....Q:ListData=""
	....S Num=Num+1
	....Q:(Num<Start)||(Num>End)
	....I Num=Start D
	.....W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	....E  D
	.....W ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	....
	...
	..
	.
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	K ^TMP("DHCADV","web.DHCADVCOMMONPART","StaticPreAlert",pid)
	Q ""
}

/// Description: 不良反应报告待办统计
/// Creator:     CongYue
/// CreateDate:  2017-10-17  
/// Input:  	 开始日期^结束日期"12","1","2016-02-02^2016-02-02"
/// Output:   	 不良事件个数^不良反应报告总数
/// Others:		 d ##class(web.DHCADVPREALERT).UntreatedList("12","1","2017-01-01^2017-10-17^235^4^1223")
ClassMethod UntreatedList(rows As %String, page As %String, param As %String) As %String
{
	
	n (rows,page,param)
	s End = page*rows
    s Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
	K ^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedList") //k掉临时global
    s StDate=$p(param,"^",1)    //开始日期
	s EndDate=$p(param,"^",2)   //结束日期 
	S GroupId=$p(param,"^",3)   //安全组ID
    S LocId=$p(param,"^",4)     //科室ID
    S UserId=$p(param,"^",5)    //用户ID
    S list=UserId_"^"_LocId_"^"_GroupId
	s StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate) //$zdh(StDate,3)
	s EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate) //$zdh(EndDate,3)
	s h=0,count=0
	S Numalls=0   //合计初始化
    s Num=1       //审核状态类型数量统计初始化
	S ID=""
	F date=StDate:1:EndDate D
	.s RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) q:RepID=""  d
	..K ^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedListNum")
	..S RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",Medadrreceive="",Medadrreceivedr="",StatusNext="",RepLevelDr=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..Q:RepStausDr=""
	..S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S:MedadrID'="" Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	..S params=RepID_"^"_RepTypeCode_"^"_UserId_"^"_LocId 
	..S SubUserflag=##class(web.DHCADVSEARCHREPORT).SearchAuditIUser(MedadrID,params) 
	..S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	..S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	..S Listt=RepID_"^"_RepTypeDr_"^"_list_"^"_RepStausDr_"^"_""_"^"_RepLevelDr
	..S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	..S StatusNextID=$p(matalist,"^",2)  //下一状态
	..Q:StatusNextID=""
	..q:Medadrreceivedr="2" //判断是否驳回
	..S adrwfgID=""
	..F  S adrwfgID=$o(^DHCADREVTWFGR(0,"ItmDr",StatusNextID,adrwfgID)) Q:adrwfgID=""  d
	...S adrwfgType=$p(^DHCADREVTWFGR(adrwfgID),"^",3)
	...S adrwfgLocID=$p(^DHCADREVTWFGR(adrwfgID),"^",4)
	...;Q:(LocId'="")&(LocId'=adrwfgLocID) //hxy 2018-01-19 st
	...;Q:adrwfgType'=2  //判断权限是否为科室
	...;S Numalls=Numalls+1
	...s CurFlag=""
	...i (adrwfgType=1)&&(GroupId'="")&&(+GroupId=+adrwfgLocID) s CurFlag=1
	...i (adrwfgType=2)&&(LocId'="")&&(+LocId=+adrwfgLocID) s CurFlag=1
	...i (adrwfgType=3)&&(UserId'="")&&(+UserId=+adrwfgLocID) s CurFlag=1
	...Q:CurFlag=""
	...I '$d(^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedListNum",RepID))  D
	....S Numalls=Numalls+1

	....I $d(^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedList",pid,RepType))  d
	.....S $p(^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedList",pid,RepType),"^",2)=$p(^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedList",pid,RepType),"^",2)+Num
	....E  d
	.....S h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedList",pid,RepType)=RepType_"^"_Num
	....S ^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedListNum",RepID)=RepID
	...
	..

	I h=0 W ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	S ^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedList",pid,h)="合计:"_"^"_Numalls
	
	///转换数据为Json格式
	S Title="name^value"
	
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h+1) //输出json前缀串  qunianpeng  2016-07-13
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedList",pid,index),-1) q:index=""  d
	.s mdate=$g(^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	K ^TMP("DHCADV","web.DHCADVCOMMONPART","UntreatedList") //k掉临时global
	q ""
}

/// Description: 获取科室描述，用于查询条件的下拉框中(标准版新版 科室取消了拼音码-科室的形式)
/// Creator:     yangyongtao
/// CreateDate:  2017-11-17	 
/// Input:       查询内容(汉字或者拼音码)
/// Output:  	 id^科室描述 （串）
/// Table:		 CT_LOC
/// Others:	w ##class(web.DHCADVCOMMONPART).GetAllLocNewVersion("",2)	
ClassMethod GetAllLocNewVersion(input As %String, hospID As %String) As %String
{
	n (input,hospID,%session)
	
	s input=$ZCVT(input,"U")
	d ..QueryCtLoc(input,hospID)
	Q ""    //sufan 2020-03-18  以下代码和前台交互时取不到数据
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CTLOC_ROWID as locDr,CTLOC_DESC as locDesc ,CTLOC_ContactName as ContactName FROM CT_LOC"
	;i input'=""  d   //sufan 2019-12-04 由于科室码有大小写区分，会导致查询数据不全
	;.s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_"%"_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_"%"_""_input_""_"%"_""_""" "
	;.//旧版(拼音码和描述为分开) s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_""_input_""_"%"_""" OR CTLOC_Code LIKE """_""_input_""_"%"_""_""" "
	
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s locDr = result.Data("locDr")
		s locDesc = result.Data("locDesc")
		s ContactName = result.Data("ContactName")
		s ContactName = $ZCVT(ContactName,"U")
		continue:(hospID'="")&(hospID'=$p(^CTLOC(locDr),"^",22))
		continue:(locDesc["停")||(locDesc["工作量")
		;continue:$d(^PAC("ADMLOC",0,"AdmType","I",locDr))
  		;continue:$d(^PAC("ADMLOC",0,"AdmType","O",locDr))
  		;continue:$d(^PAC("ADMLOC",0,"AdmType","E",locDr))
  		;continue:$d(^PAC("ADMLOC",0,"AdmType","H",locDr))
  		continue:($p(^CTLOC(locDr),"^",25)'="")&&($p(^CTLOC(locDr),"^",25)<+$h)
  		continue:(input'="")&&(locDesc_ContactName'[input)
		;s:locDesc["-" locDesc=$p(locDesc,"-",2)
		s tmp=locDr_"^"_locDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
		e  d
		.w ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	}
	w "]"
	q ""
}

ClassMethod QueryCtLoc(input, hospID)
{
	n (input,hospID,%session)
	
	s input=$ZCVT(input,"U")
	s count=0
	w "["
	s LocId=""
	for  s LocId=$o(^CTLOC(LocId)) Q:LocId=""  d
	.s Text=$p(^CTLOC(LocId),"^",2)
	.s Text=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",Text) //hxy 2020-06-24
	.s ContactName = $p(^CTLOC(LocId),"^",43)
	.s ContactName = $ZCVT(ContactName,"U")
	.Q:(hospID'="")&(hospID'=$p(^CTLOC(LocId),"^",22))
	.Q:(input'="")&&(Text_ContactName'[input)
	.Q:(Text["停")||(Text["工作量")
	.Q:($p(^CTLOC(LocId),"^",25)'="")&&($p(^CTLOC(LocId),"^",25)<+$h)
	.s tmp=LocId_"^"_Text
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	w "]"
	Q ""
}

/// Description: 事件类型
/// Creator:     CongYue
/// CreateDate:  2017-11-28  
/// Table:		 DHC_MedAdrRepEvent
/// Output:  	 事件类型描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVCOMMONPART).SelEventbyNew()
ClassMethod SelEventbyNew(param) As %String
{
	n (param,%session)
	S count=0
    S UserId=$p(param,"^",1)    //用户ID
    S LocId=$p(param,"^",2)     //科室ID
	S GroupId=$p(param,"^",3)   //安全组ID
	S HospId=$p(param,"^",4)    //医院ID
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdvQuerySec",HospId) ///2021-06-18 cy 多院区业务改造	S RepTypeID=""
	S AllDesc=##class(websys.Translation).Get("dhcadv.reportaudit.csp","全部")
	W "["
	S EventDr=""
	F  S EventDr=$o(^DHCMEDADREVT(EventDr)) Q:EventDr=""  D
	.Q:+EventDr=0
	.S EventCode=$p(^DHCMEDADREVT(EventDr),"^",1)
	.S EventDesc=$p(^DHCMEDADREVT(EventDr),"^",2)
	.S EventDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEvent","MADREVDesc","",EventDesc) //hxy 2020-06-24
	.S Active=$p(^DHCMEDADREVT(EventDr),"^",3) //是否可用
	.Q:'$d(^DHCADVQUS(0,"HospRepType",HospIdGroup,+EventDr,1,GroupId))&&'$d(^DHCADVQUS(0,"HospRepType",HospIdGroup,+EventDr,2,LocId))&&'$d(^DHCADVQUS(0,"HospRepType",HospIdGroup,+EventDr,3,UserId))
	.Q:Active="N"
	.S CH=""
	.F  S CH=$o(^DHCMEDADREVTI(EventDr,"MADREVI",CH)) Q:CH=""  D
	..S Code=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",1) //代码
	..S Desc=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",2) //描述
	..S Desc=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEventItm","MADREVIDesc","",Desc) //hxy 2020-06-24
	..S Active=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",3) //是否可用
	..Q:(Code'="")&&(##class(web.DHCADVFormName).CheckFormName(Code,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..Q:Active="N"
	..S ListData=EventDr_"||"_CH_"^"_Desc
	..S count = count+1
	..I count=1 D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text","^"_AllDesc)
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",ListData)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",ListData)
	.Q:($d(^DHCMEDADREVTI(EventDr,"MADREVI")))  ;去除带有子元素的类型
	.Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(EventCode)))  ;去除不是表单的类型
	.Q:(EventCode'="")&&(##class(web.DHCADVFormName).CheckFormName(EventCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	.S tmp=EventDr_"^"_EventDesc
	.S count = count+1
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text","^"_AllDesc)
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	W "]"
	Q ""
}

/// Description: 报告状态
/// Creator:     CongYue
/// CreateDate:  2017-11-28  
/// Table:		 DHC_AdrEvtWorkFlow ,DHC_AdrEvtWorkFlowItm
/// Input:   	 类型id
/// Output:  	 事件状态描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVCOMMONPART).SelEvtStatusbyNew("1")
ClassMethod SelEvtStatusbyNew(EventDr) As %String
{
	N (EventDr,%session)
	S count=0
	if EventDr=""  d
	.w "[]"
	Q:EventDr=""
	S:(EventDr["||")&&('$d(^DHCADREVTWF(0,"Event",EventDr))) EventDr=+EventDr
	S AllDesc=##class(websys.Translation).Get("dhcadv.reportaudit.csp","全部")
	W "["	
	S EvtWorkflowID=""
	F  S EvtWorkflowID=$o(^DHCADREVTWF(0,"Event",EventDr,EvtWorkflowID))  Q:EvtWorkflowID=""  D
	.Q:+EvtWorkflowID=0
	.S Active=$p(^DHCADREVTWF(EvtWorkflowID),"^",4) //是否可用
	.Q:Active="N"
	.S CH=""
	.F  S CH=$o(^DHCADREVTWFI(EvtWorkflowID,"ADREWI",CH)) Q:CH=""  D
	..q:+CH=0
	..S Desc=$p(^DHCADREVTWFI(EvtWorkflowID,"ADREWI",CH),"^",2) //描述
	..S Desc=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdrEvtWorkFlowItm","ADREWIDesc","",Desc)
	..S ID=EvtWorkflowID_"||"_CH
	..S tmp=ID_"^"_Desc
	..s count = count+1
	..I count=1 d
	...W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text","^"_AllDesc)
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	..e  d
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp) //value^text
	w "]"
	q ""
}

/// Description: 删除报告 
/// Creator:     yangyongtao
/// CreateDate:  2017-11-30
/// Table: 		 DHC_AdvMaster
/// Input:  	 报告表id 
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVCOMMONPART).DelReport("")
ClassMethod DelReport(params As %String) As %String
{
	N (params)
	S RepID=$p(params,"^",1)
	S UserID=$p(params,"^",2)
	S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)   //报告类型
	S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3) //当前状态
	S repUserID=$p(^DHCADVMASTER(RepID),"^",6)    //填报人ID
	Q:UserID'=repUserID -1
	Q:RepStausDr'="" -2
	&SQL(DELETE DHC_AdvMaster WHERE ADV_RowID=:RepID)
	Q SQLCODE
}

/// Description: 供血者血型(下拉框) 
/// Creator:     yangyongtao
/// CreateDate:  2017-11-30
/// Input:  	 
/// Return: 	 供血者血型(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryPatSexCombo()
ClassMethod QueryPatBloodTypeCombo()
{
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Rh阳性A血型").Put("text","Rh阳性A血型"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Rh阳性B血型").Put("text","Rh阳性B血型"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Rh阳性AB血型").Put("text","Rh阳性AB血型"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Rh阳性O血型").Put("text","Rh阳性O血型"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Rh阴性A血型").Put("text","Rh阴性A血型"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Rh阴性B血型").Put("text","Rh阴性B血型"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Rh阴性AB血型").Put("text","Rh阴性AB血型"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Rh阴性O血型").Put("text","Rh阴性O血型"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 通过对照表Code获取 对应元素的value值
/// Creator:     CongYue
/// CreateDate:  2017-12-19  
/// Table:		 DHC_AdvFormField ,DHC_AdvFormDicContrast ,
/// Input:   	 需保存的数据对应的code，元素所在formid
/// Output:  	 元素value值 
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetSaveInfo("HospAdmDate","986","15")
ClassMethod GetSaveInfodd(code, formid, recordid) As %String
{
	n (code,formid,recordid)
	Q:(code="")||(formid="")||(recordid="")
	S FieldID="",ContrastID="",FormDicID="",RecordItmID="",RecordItmvalue=""
	q:'$d(^DHCADVFF(0,"Code",$$ALPHAUP^SSUTIL4(code))) ""
	S FieldID=$o(^DHCADVFF(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	S:FieldID'="" ContrastID=$o(^DHCADVFDC(0,"FieldCode",FieldID,formid,""))
	S:ContrastID'="" FormDicID=$p(^DHCADVFDC(ContrastID),"^",2)
	Q:formid'=$lg(^User.DHCAdvFormRecordD(recordid),2) ""
	Q:FormDicID="" ""
	F  S RecordItmID=$o(^User.DHCAdvFormRecordItmI("IndexFormRecord",recordid,RecordItmID)) Q:RecordItmID=""  D
	.S RecItmFormDic=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),3) ;元素指向
	.S RecItmparrefFormDic=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),8) ;父元素指向
	.Q:(FormDicID'="")&&(FormDicID'=RecItmFormDic)&&((RecItmparrefFormDic'="")&&(FormDicID'=RecItmparrefFormDic))
	.S RecordItmvalue=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),4)
	.Q:RecordItmvalue'=""
	q RecordItmvalue
}

/// Description: 根据报告类型ID获取对应表单nameID
/// Creator:     CongYue
/// CreateDate:  2017-12-23  
/// Table:		 DHC_AdvFormName ,DHC_AdvFormDicContrast ,
/// Input:   	 需保存的数据对应的code，元素所在formid
/// Output:  	 元素value值 
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetFormNameID("")
ClassMethod GetFormNameID(AdrEvtDr) As %String
{
	n (AdrEvtDr)
	S:(AdrEvtDr'="")&&(AdrEvtDr'["||") ReportTypeCode=$p(^DHCMEDADREVT(AdrEvtDr),"^",1)
	S:(AdrEvtDr'="")&&(AdrEvtDr["||") ReportTypeCode=$p(^DHCMEDADREVTI(+AdrEvtDr,"MADREVI",$p(AdrEvtDr,"||",2)),"^",1)
	s FormNameDr = $o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(ReportTypeCode),""))
	q FormNameDr
}

/// Description: 不良事件查询 
/// Creator:     CongYue
/// CreateDate:  2018-01-09
/// Input:  	 StrParam : 以字符"^"分割,格式为:开始时间^结束时间
/// Table:       FormRecord,FormRecordItm,FormRecordItmSub
/// Return: 	 事件上报 护士长审核 科护士长 护理部审核 案例归档 警示事件  23 
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryRepManageList("10","1","23^193^4805")
ClassMethod QueryRepManageList(rows = 10, page = 1, StrParam As %String)
{
  
	N (rows,page,StrParam)
	;w $h
	q:StrParam="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S Repnum="", HeadNurAuditnum="", LocNurAuditnum="", NurDepartAuditnum="",Filenum="",Warningnum=""  ,RepOverTimenum="",AutOverTimenum=""
	S End = page*rows
	S Start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	
	S StDate="2018-01-01"    //开始日期
	S:StDate'="" StDate=$zdh(StDate,3)
	S EndDate=+$h   //结束日期
    S UserId=$p(StrParam,"^",1)    //用户ID
    S LocId=$p(StrParam,"^",2)     //科室ID
	S GroupId=$p(StrParam,"^",3)   //安全组ID
    S HospId=$p(StrParam,"^",4)    //医院ID
	S list=UserId_"^"_LocId_"^"_GroupId
	
	;S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate) //hxy 2018-03-21 不走日期配置时报错
	;S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate) //hxy 2018-03-21
	q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	s count=0
	f date=StDate:1:EndDate d
	.s RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) q:RepID=""  d
	..S RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",MedadrReceive="",RepOverTimeflag="",AutOverTimeflag="",RepCancelflag="",RepLevelDr=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..Q:RepTypeDr=""
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,list)
	..S GroupDesc=$p(^SSU("SSGRP",GroupId),"^",1)
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S:MedadrID'="" RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	..Q:RepCancelflag="Y"
	..Q:((flag'="")&&(flag'=1))
	..S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,RepTypeDr,""))
	..S File="",FileFlag=""
	..S:FILERowID'="" FileFlag=$p(^DHCADVFILE(FILERowID),"^",3)
	..S:FileFlag="Y" Filenum=Filenum+1
	..S:((RepLocDr=LocId)||((GroupDesc["护理部"))||(SecuUserdlag=1))&&(FileFlag'="Y") Repnum=Repnum+1
	..I RepStausDr'=""  D
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	...S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	...S:MedadrID'="" MedadrReceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9)
	...S:(MedadrID'="")&(RepStaus="护士长审核") AutOverTimeflag=$p(^DHCMEDREPADT(MedadrID),"^",15) ;护士长审核超时标志
	...S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	...S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	...S Listt=RepID_"^"_RepTypeDr_"^"_list_"^"_RepStausDr_"^"_""_"^"_RepLevelDr
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...S StatusNext=""
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	....S:(StatusNext="护士长审核")&&(FileFlag'="Y") HeadNurAuditnum=HeadNurAuditnum+1
	....S:(StatusNext="科护士长审核")&&(FileFlag'="Y") LocNurAuditnum=LocNurAuditnum+1
	....S:(StatusNext="护理部审核")&&(FileFlag'="Y") NurDepartAuditnum=NurDepartAuditnum+1
	..S RepImpFlag=$p(^DHCADVMASTER(RepID),"^",9)
	..S:RepImpFlag="Y" Warningnum=Warningnum+1
	..S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	..S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	..S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	..S:OccurDate="" OccurDate=0
	..S OccurTime=$p(^DHCADVMASTER(RepID),"^",26)  ///发生时间
	..S:OccurTime="" OccurTime=0
	..S RepOverTime=""
	..; 2021-03-26 cy 填写超时程序修改
	..;S HolidayDate=##class(web.DHCADVCOMMONPART).CheckTimeEscapeHoliday(OccurDate,OccurTime,RepDate,RepTime)
	..;S FillTime=##class(web.DHCADVCOMMON).GetEmSysConfig("FILLTIME",StrParam)  ///填报时限时长
	..;I (+FillTime'=0)&&(HolidayDate>FillTime) S RepOverTimeflag="Y"   //填报超时
	..S RepOverTimeflag=##class(web.DHCADVCOMMONPART).ChkOverTime(RepID,"FILLTIME",RepDate,RepTime,RepStausDr,StrParam)
	..S:RepOverTimeflag="Y" RepOverTimenum=RepOverTimenum+1
	..S:AutOverTimeflag="Y" AutOverTimenum=AutOverTimenum+1	
	s tmpObj={}
	s tmpObj.Repnum=Repnum
	s tmpObj.HeadNurAuditnum=HeadNurAuditnum
	s tmpObj.LocNurAuditnum=LocNurAuditnum
	s tmpObj.NurDepartAuditnum=NurDepartAuditnum
	s tmpObj.Filenum=Filenum
	s tmpObj.Warningnum=Warningnum
	s tmpObj.RepOverTimenum=RepOverTimenum
	s tmpObj.AutOverTimenum=AutOverTimenum
	;w !,$h
	q tmpObj
}

/// Description: 判断登录人是否有查看大科安全组下病区的相关报告权限
/// Creator:     CongYue
/// CreateDate:  2018-01-10  
/// Table:		 DHC_AdvSecuGroupUserWard
/// Input:   	 登录人id，报告填报科室
/// Output:  	 flag 0 无权限  1 有权限 
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetSecuGroupWard("12751","101")
ClassMethod GetSecuGroupWard(UserId, RepLoc) As %String
{
	n (UserId,RepLoc)
	s flag=0
	s WardId=$o(^PAWARD(0,"WARD_LocationDR",RepLoc,""))
	q:WardId="" flag
	s SecuId=""
	f  s SecuId=$o(^DHCADVSECUGUW(SecuId)) q:SecuId=""  d
	.q:+SecuId=0
	.;s SecuGrpDr=$p(^DHCADVSECUGUW(SecuId),"^",1)
	.s SecuUser=$p(^DHCADVSECUGUW(SecuId),"^",2)
	.s SecuWard=$p(^DHCADVSECUGUW(SecuId),"^",3)
	.q:SecuUser'=UserId
	.s:SecuWard=WardId flag=1
	q flag
}

/// Description: 根据科室获取所属大科安全组
/// Creator:     CongYue
/// CreateDate:  2018-01-11  
/// Table:		 DHC_AdvSecuGroupUserWard
/// Input:   	 报告填报科室id
/// Output:  	 大科描述 
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetSecuGroupDesc("101")
ClassMethod GetSecuGroupDesc(RepLoc) As %String
{
	n (RepLoc)
	s SecuDesc=""
	q:RepLoc="" SecuDesc
	s SecuLId=""
	f  s SecuLId=$o(^DHCADVSECUGUL(SecuLId)) q:SecuLId=""  d
	.q:+SecuLId=0
	.s SecuLGrpDr=$p(^DHCADVSECUGUL(SecuLId),"^",1)
	.s SecuLoc=$p(^DHCADVSECUGUL(SecuLId),"^",3)
	.q:SecuLoc'=RepLoc
	.s:(SecuLGrpDr'="")&&(SecuLoc=RepLoc) SecuDesc=$p(^DHCADVSECUG(SecuLGrpDr),"^",2)
	q:SecuDesc'="" SecuDesc
	
	s WardId=$o(^PAWARD(0,"WARD_LocationDR",RepLoc,""))
	q:WardId="" SecuDesc
	s SecuId=""
	f  s SecuId=$o(^DHCADVSECUGUW(SecuId)) q:SecuId=""  d
	.q:+SecuId=0
	.s SecuGrpDr=$p(^DHCADVSECUGUW(SecuId),"^",1)
	.s SecuWard=$p(^DHCADVSECUGUW(SecuId),"^",3)
	.q:SecuWard'=WardId
	.s:(SecuGrpDr'="")&&(SecuWard=WardId) SecuDesc=$p(^DHCADVSECUG(SecuGrpDr),"^",2)
	q SecuDesc
}

/// Description: 判断登录人是否有查看大科安全组下科室的相关报告权限
/// Creator:     CongYue
/// CreateDate:  2018-01-10  
/// Table:		 DHC_AdvSecuGroupUserLoc
/// Input:   	 登录人id，报告填报科室
/// Output:  	 flag 0 无权限  1 有权限 
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetSecuGroupLoc("12713","2")
ClassMethod GetSecuGroupLoc(UserId, RepLoc) As %String
{
	n (UserId,RepLoc)
	s flag=0
	q:RepLoc="" flag
	s SecuId=""
	f  s SecuId=$o(^DHCADVSECUGUL(SecuId)) q:SecuId=""  d
	.q:+SecuId=0
	.s SecuUser=$p(^DHCADVSECUGUL(SecuId),"^",2)
	.s SecuLoc=$p(^DHCADVSECUGUL(SecuId),"^",3)
	.q:SecuUser'=UserId
	.s:SecuLoc=RepLoc flag=1
	q flag
}

/// Description: 查询[科室维护] 下拉框
/// Creator:     CongYue
/// CreateDate:  2018-01-15
/// Table: 		 DHC_AdvAutLoc
/// Input:  	 params：订单信息，以字符"^"分割,格式为：代码^描述,
/// Output:  	 DHC_AdvMedUseLink表中的数据信息   
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetAutLocCombox("")
ClassMethod GetAutLocCombox(q As %String) As %String
{
	N (q)
	S q=$$ALPHAUP^SSUTIL4(q)
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s listObj=##class(%ListOfObjects).%New()
	s ID="",Desc=""
	F  S ID=$o(^DHCADVAUTLOC(ID)) Q:ID=""  D
	.Q:+ID=0
	.S Code=$p(^DHCADVAUTLOC(ID),"^",1) //代码
	.S Desc=$p(^DHCADVAUTLOC(ID),"^",2) //描述
	.S Parent=$p(^DHCADVAUTLOC(ID),"^",3) //描述
	.S Active=$p(^DHCADVAUTLOC(ID),"^",4) //描述
	.Q:Active="N"
	.Q:((q'="")&(Code'[q))||((q'="")&(Desc'[q))
	.Q:(Parent'="")
	.d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",Desc).Put("text",Desc))
	w jsonObj.ListToJson(listObj)
	q ""
}

/// Description: 查询[科室维护项目]
/// Creator:     CongYue
/// CreateDate:  2018-01-12
/// Table: 		 DHC_AdvAutLoc
/// Input:  	 主表的id
/// Output:  	 DHC_AdvMedUseLinkItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetAutLocItmCombox("内科","")
ClassMethod GetAutLocItmCombox(AutLParentDesc, q As %String) As %String
{
	N (AutLParentDesc,q)
	S q=$$ALPHAUP^SSUTIL4(q)
	S AutLParentID=$o(^DHCADVAUTLOC(0,"Code",AutLParentDesc,""))
	Q:AutLParentID="" "[]"
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s listObj=##class(%ListOfObjects).%New()
	s ID="",Desc=""
	F  S ID=$o(^DHCADVAUTLOC(0,"ParentDr",AutLParentID,ID)) Q:ID=""  D
	.Q:+ID=0
	.S Code=$p(^DHCADVAUTLOC(ID),"^",1) //代码
	.S Desc=$p(^DHCADVAUTLOC(ID),"^",2) //描述
	.S Parent=$p(^DHCADVAUTLOC(ID),"^",3) //描述
	.S Active=$p(^DHCADVAUTLOC(ID),"^",4) //描述
	.Q:Active="N"
	.Q:((q'="")&(Code'[q))||((q'="")&(Desc'[q))
	.Q:(Parent="")
	.d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",Desc).Put("text",Desc))
	w jsonObj.ListToJson(listObj)
	q ""
}

/// Description: 不良反应报告审批（撤销审批）  2018-01-17
/// Creator:     yangyongtao
/// CreateDate:  2016-09-19
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^审核状态^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	
/// Others:		 w ##class(web.DHCADVCOMMONPART).CancelAuditReport("1^3||1^600^63^126^2^aaaaa^Y^blood")
ClassMethod CancelAuditReport(params As %String) As %String
{
	N (params)
	S ListData = ..CancelAudit(params)
	S ListTitle="ErrCode^ErrMsg"
	W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Description: 不良反应报告审批（撤销审批）
/// Creator:     yangyongtao
/// CreateDate:  2016-09-19
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^审核状态^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 
/// Others:		 w ##class(web.DHCADVCOMMONPART).CancelAudit("3^17||1^3^101^25^^^2^advPipeOff")
ClassMethod CancelAudit(params As %String) As %String
{
	N (params)
	S ID=+$p(params,"^",1)       //不良反应报告ID
	S medadrStatusDR=$p(params,"^",2)  //审核状态
	S UserID=+$p(params,"^",3)     //用户ID
	S LgCtLocID=+$p(params,"^",4)     //科室ID
	S LgGroupID=+$p(params,"^",5)     //安全组ID
	S medadrLastLocDR=$p(params,"^",6)
	S medadrLocAdvice=$p(params,"^",7)
	S medadrReceive=3
	S medadrAuditDate=+$h
	S medadrAuditTime=$p($h,",",2)
	S typecode=$p(params,"^",9) // 报告类型代码
	S medadrRecProgress=$p(params,"^",10) // 调查核实
	S eventDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(typecode),"")) //报告类型id
	s eventparref="",eventsub="" ;2018-08-29
	i eventDr=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") eventDr=eventparref_"||"_eventsub
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",eventDr,ID,""),-1)
	S MedadrStatus="",NextLocDR="",StaFistAuditUserDr="",MedadrRetStatus=""
	S:MedadrID'="" MedadrStatus=$p(^DHCMEDREPADT(MedadrID),"^",3) ;审批记录报告状态
	S:MedadrID'="" NextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（被指向的审批科室）
	;Q:(NextLocDR'="")&&(LgCtLocID'=NextLocDR) "-8^当前登录科室无审批权限，不能审核"
	S:MedadrID'="" MedadrRetStatus=$p(^DHCMEDREPADT(MedadrID),"^",14) ;审批记录驳回指向状态 2019-02-20
	S:MedadrStatus'="" StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID,eventDr,MedadrStatus)  ;报告第一操作人 2019-02-20
	S:MedadrRetStatus'="" StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID,eventDr,MedadrRetStatus)  ;报告第一操作人 2019-02-20
		
	S flag=##class(web.DHCADVSEARCHREPORT).SearchAuditIMess(MedadrID)
	Q:(flag'="2")&&(flag'="0") "-7^报告已转抄，不能撤销审核"
		
	S list=UserID_"^"_LgCtLocID_"^"_LgGroupID
	;S StsusGrantflag=##class(web.DHCADVCOMMON).CheckWorkItmGrant(medadrStatusDR,list)
	
	Q:StaFistAuditUserDr'=UserID "-11^无撤销审核权限"
	
	S medadrRetReason="",RevStatus="",TimeOutFlag="",RepCancelFlag=""
	S Listt=ID_"^"_eventDr_"^"_list
	S StatusLastID=medadrStatusDR  ;##class(web.DHCADVCOMMON).GetRepLastStatusDr(Listt)

	TS
	S Err=0

	S Err=..InsAdvMasterStart(ID,StatusLastID)
	I Err'=0 tro
	Q:Err'=0 "-05"

	S matadrRepAuditList=StatusLastID_"^"_list_"^"_medadrLastLocDR_"^"_medadrLocAdvice_"^"_medadrReceive_"^"_eventDr_"^"_medadrRetReason_"^"_RevStatus_"^"_TimeOutFlag_"^"_RepCancelFlag
	S retVal=##class(web.DHCADVCOMMON).InsRepAudit(ID,matadrRepAuditList)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	
	
	TC
	Q 0
}

/// Description: 报告状态
/// Creator:     CongYue
/// CreateDate:  2017-11-28  
/// Table:		 DHC_AdrEvtWorkFlow ,DHC_AdrEvtWorkFlowItm
/// Input:   	 类型id
/// Output:  	 事件状态描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetRevStatusCombox("advWallLeakage","10||2")
ClassMethod GetRevStatusCombox(EvenCode, Status = "") As %String
{
	N (EvenCode,Status)
	Q:EvenCode="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	S EventDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(EvenCode),""))
	s eventparref="",eventsub="" ;2018-08-29
	i EventDr=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(EvenCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(EvenCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") EventDr=eventparref_"||"_eventsub
	S CurOrderNo=""
	S:Status'="" CurOrderNo=$p(^DHCADREVTWFI(+Status,"ADREWI",$p(Status,"||",2)),"^",3)
	S count=0
	W "["	
	S EvtWorkflowID=$o(^DHCADREVTWF(0,"Event",+EventDr,""))
	Q:EvtWorkflowID=""
	S Active=$p(^DHCADREVTWF(EvtWorkflowID),"^",4) //是否可用
	Q:Active="N"
	S CH=""
	F  S CH=$o(^DHCADREVTWFI(EvtWorkflowID,"ADREWI",CH)) Q:CH=""  D
	.q:+CH=0
	.S Desc=$p(^DHCADREVTWFI(EvtWorkflowID,"ADREWI",CH),"^",2) //描述
	.S OrderNo=$p(^DHCADREVTWFI(EvtWorkflowID,"ADREWI",CH),"^",3) //顺序号
	.Q:(CurOrderNo'="")&&(OrderNo>CurOrderNo)
	.;s tmps=AdrEwiID_"^"_"全部"
	.S ID=EvtWorkflowID_"||"_CH
	.S tmp=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..;W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text","^全部")
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp) //value^text
	w "]"
	q ""
}

/// Description: 判断登录人是否 是大科安全组组长  是否可以查看大科报告权限
/// Creator:     CongYue
/// CreateDate:  2018-01-18  
/// Table:		 DHC_AdvSecuGroupUserLoc
/// Input:   	 登录人id，报告填报科室
/// Output:  	 flag 0 无权限  1 有权限 
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetSecuUser("12713","2")
ClassMethod GetSecuUser(UserId, RepLoc) As %String
{
	n (UserId,RepLoc)
	s flag=0
	q:RepLoc="" flag
	;^DHCADVSECUGU({SECUGU_RowId})
	;^DHCADVSECUGU(0,"GroupUser",{SECU_Grp_Dr},{SECU_User_Dr},{SECUGU_RowId})
	s SecuId=""
	f  s SecuId=$o(^DHCADVSECUGU(SecuId)) q:SecuId=""  d
	.q:+SecuId=0
	.s SecuUser=$p(^DHCADVSECUGU(SecuId),"^",2)
	.s SecuLeadFlag=$p(^DHCADVSECUGU(SecuId),"^",3)
	.q:SecuUser'=UserId
	.Q:SecuLeadFlag'="Y"
	.S Secuflag=..GetSecuGroupWard(UserId, RepLoc) ;判断登录人是否属于大科安全组 是否有查看权限
	.S SecuLocflag=..GetSecuGroupLoc(UserId, RepLoc) ;判断登录人是否属于大科安全组 是否有查看权限
	.S:(Secuflag=1)||(SecuLocflag=1) flag=1
	q flag
}

/// Description: 判断登录人是否 是大科安全组组长 
/// Creator:     CongYue
/// CreateDate:  2018-01-18  
/// Table:		 DHC_AdvSecuGroupUserLoc
/// Input:   	 登录人id , 登录人安全组
/// Output:  	 flag 0 否  1 是大科安全组组长 （科护士长）
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetSecuUserLeader("12713")
ClassMethod GetSecuUserLeader(UserId, GroupId = "") As %String
{
	N (UserId,GroupId)
	S Flag=0
	Q:UserId="" Flag
	;Q:(UserId="")||(GroupId="") Flag
	s GroupDesc=""
	i GroupId'="" S GroupDesc=$p(^SSU("SSGRP",GroupId),"^",1)
	Q:(GroupDesc'="")&&(GroupDesc'["护士长") Flag
	S SecuId=""
	F  S SecuId=$o(^DHCADVSECUGU(SecuId)) Q:SecuId=""  D
	.Q:+SecuId=0
	.S SecuUser=$p(^DHCADVSECUGU(SecuId),"^",2)
	.S SecuLeadFlag=$p(^DHCADVSECUGU(SecuId),"^",3)
	.Q:SecuUser'=UserId
	.Q:SecuLeadFlag'="Y"
	.S:(SecuLeadFlag="Y") Flag=1
	Q Flag
}

/// Description: 不良反应报告驳回
/// Creator:     CongYue
/// CreateDate:  2018-01-19
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0  驳回成功
/// Others:		 w ##class(web.DHCADVCOMMONPART).ReportBack("12^600^63^126^^^N^blood")
ClassMethod ReportBack(params As %String, LgParam As %String) As %String
{
	N (params,LgParam)
	S ListData = ..BackRep(params,LgParam)
	S ListTitle="ErrCode^ErrMsg"
	W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Description: 不良反应报告驳回
/// Creator:     CongYue
/// CreateDate:  2018-01-19
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码^报告状态
/// Return: 	 0  驳回成功
/// Others:		 w ##class(web.DHCADVCOMMONPART).BackRep("98^12183^163^99^^^未接收^advDevice^14||1^333^14||1")
ClassMethod BackRep(params As %String, LgParam As %String) As %String
{
	
	N (params,LgParam)
	S ID=+$p(params,"^",1)       //不良反应报告ID
	S medadrAuditUserDR=+$p(params,"^",2)     //用户ID
	S LgCtLocID=+$p(params,"^",3)     //科室ID
	S LgGroupID=+$p(params,"^",4)     //安全组ID
	S list=medadrAuditUserDR_"^"_LgCtLocID_"^"_LgGroupID
	S medadrNextLocDR=$p(params,"^",5)
	S medadrLocAdvice=$p(params,"^",6)
	S medadrReceivedr=$p(params,"^",7)
	S typecode=$p(params,"^",8) // 报告类型代码
	S StatusID=$p(params,"^",9) // 报告当前状态
	S medadRetReason=$p(params,"^",10) //驳回原因
	S RevStatus=$p(params,"^",11) //驳回指向
	
	// 已驳回报告不能再次驳回
	Q:medadrReceivedr="2" "-1^已驳回"
	
	// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id）
	S RepTypeString=..GetRepTypeString(ID)
	S medadrType=$p(RepTypeString,"^",4)
	S typecode=$p(RepTypeString,"^",5)
	
	// 判断是否存在指向科室(有审核权限才有驳回权限)
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",medadrType,ID,""),-1) //hxy 2020-03-23 st
	S NextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（被指向的审批科室）
	Q:(NextLocDR'="")&&(NextLocDR'="0")&&(LgCtLocID'=NextLocDR) "-8^当前登录科室无驳回权限，不能驳回" //ed
	
	//判断该登录人对报告是否有驳回权限(有审核权限才有驳回权限)
	S Listt=ID_"^"_medadrType_"^"_list
	S StatusNextID=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,"",LgParam)
	Q:StatusNextID="-1" "-2^无权限"
	Q:StatusNextID="-2" "-3^已是最后一个权限"
	
	// 设置驳回标识
	S medadrReceivedr="2"
	S medadrAuditDate=+$h
	S medadrAuditTime=$p($h,",",2)
	S TimeOutFlag="",RepCancelFlag=""
	TS
	S Err=..InsAdvMasterStart(ID,RevStatus)
	I Err'=0 tro
	Q:Err'=0 "-05"
	
	S matadrRepAuditList=StatusID_"^"_list_"^"_medadrNextLocDR_"^"_medadrLocAdvice_"^"_medadrReceivedr_"^"_medadrType_"^"_medadRetReason_"^"_RevStatus_"^"_TimeOutFlag_"^"_RepCancelFlag
	S retVal=##class(web.DHCADVCOMMON).InsRepAudit(ID,matadrRepAuditList)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	
	I StatusID'=RevStatus D
	.S medadrAuditUser=""
	.S:medadrAuditUserDR'="" medadrAuditUser=$p(^SSU("SSUSR",medadrAuditUserDR),"^",2)
	.S matadrRepAuditList=RevStatus_"^"_list_"^"_medadrNextLocDR_"^"_medadrLocAdvice_"^"_medadrReceivedr_"^"_medadrType_"^"_medadrAuditUser_"跨级驳回"_"^"_RevStatus_"^"_TimeOutFlag_"^"_RepCancelFlag
	.S Err=##class(web.DHCADVCOMMON).InsRepAudit(ID,matadrRepAuditList)
	I Err'=0 tro
	Q:Err'=0 Err	
	
	// 插入消息提醒
	
	S StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID, medadrType, RevStatus ) // 获取报告审核第一操作人
	S EpisodeId=$p(^DHCADVMASTER(ID),"^",16)
	s StsDate = +$h-7
	s EndDate = +$h
	s StrParam = StsDate_"^"_EndDate_"^^^"_LgGroupID_"^"_LgCtLocID_"^"_StaFistAuditUserDr_"^^^^2^^^^Y^^^^^^^^^2"
	s linkUrl="dhcadv.reportaudit.csp"
	s Url=""""_linkUrl_"?StrParam="_StrParam_""""
	//s Link="{""link"":"_""""_linkUrl_""""_",""BizObjId"":"_""""_ID_""""_",""dialogWidth"":"_1400_",""dialogHeight"":"_600_"}"
	s Link="{""link"":"_Url_",""BizObjId"":"_""""_ID_""""_",""dialogWidth"":"_1400_",""dialogHeight"":"_600_"}"
	S Err=##class(websys.DHCMessageInterface).Send("审核未通过,报告被驳回！","1130",medadrAuditUserDR,EpisodeId,"",StaFistAuditUserDr,Link)
	I Err<0 tro
	Q:Err<0 Err

	TC
	
	Q 0
}

/// 检查日期和当前日期差多少小时,节假日不算，国庆，春节等   64645^37758
/// w ##class(web.DHCADVCOMMONPART).CheckTimeEscapeHoliday(0,0,64671,0)
ClassMethod CheckTimeEscapeHoliday(date, time, today, todayTime)
{
	n (date,time,today,todayTime)
	;w !,date_"**"_time_"**"_today_"**"_todayTime
	q:(date=0)||(date="") 0
	;s HolidaysStr=##class(web.DHCADVCOMMONPART).GetHolidaysStr()
	;s today=+$h
	;s todayTime=$p($h,",",2)
	s hours=0
	f d=date:1:today d
	.//节假日
	.q:(d'=date)&&(d'=today)&&(##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate(d,"","")'=0)   //节假日判断接口调用  节日2/假日1/非节假日0 /错误 -1
	.//工作日
	.i d=today d
	..//当天
	..s:date=today hours=(todayTime-time)/3600+hours
	..s:date'=today hours=(todayTime)/3600+hours
	.e  d
	..//不是同一天的情况
	..i d=date d
	...s hours=(86400-time)/3600+hours
	..e  i d=today d
	...s hours=hours+todayTime/3600
	..e  d
	...s hours=hours+24
	;w !,$h
	q hours
}

/// Description: 得到节假日串
/// Creator:     CongYue
/// CreateDate:  2018-01-19
/// Table:        DHC_OPRegFestivalSet
/// Input:  	 
/// Return: 	 节假日信息串
/// Others:
ClassMethod GetHolidaysStr() As %String
{
	;w ##class(web.DHCADVCOMMONPART).GetHolidaysStr()
	s HolidaysStr=""
	s FestivalRowid=0
	for {
		s FestivalRowid=$o(^DHCADVHOLIDAY(FestivalRowid))
		q:FestivalRowid=""
		s Festival=$p(^DHCADVHOLIDAY(FestivalRowid),"^",1)
		s FestivalFlag=$p(^DHCADVHOLIDAY(FestivalRowid),"^",2)
		Q:FestivalFlag="工作日"
		i HolidaysStr="" s HolidaysStr="!"_Festival_"!"
		e  s HolidaysStr=HolidaysStr_"^"_"!"_Festival_"!"
	} 
	Q HolidaysStr
}

/// 判断节假日
ClassMethod CheckHoliday(date, HolidaysStr)
{
	n (date,HolidaysStr)
	
	
	Q:(HolidaysStr'="")&&(HolidaysStr[date) 1
	// 	周日
	q:$SYSTEM.SQL.DAYOFWEEK(date)=1 1
	//  周六
	q:$SYSTEM.SQL.DAYOFWEEK(date)=7 1
	
	q 0
}

/// Description: 不良反应报告归档
/// Creator:     CongYue
/// CreateDate:  2018-01-22
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^审核状态^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0 归档成功
/// Others:		 w ##class(web.DHCADVCOMMONPART).FileMataReport("66^34||2^1223^4^235^^人太少隔热率^^advMedical")
ClassMethod FileMataReport(auditparams As %String, fileparams As %String) As %String
{
	N (auditparams,fileparams)
	S RepID=$p(auditparams,"^",1)
	S RepTypeCode=$p(auditparams,"^",9)
	S RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),""))
	s eventparref="",eventsub="" ;2018-08-29
	i RepTypeDr=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") RepTypeDr=eventparref_"||"_eventsub
	TS
	S Err=0

	S matadrRepAuditList=$p(auditparams,"^",2,8)_"^"_RepTypeDr
	S retVal=##class(web.DHCADVCOMMON).InsRepAudit(RepID,matadrRepAuditList)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	
	S retVal=##class(web.DHCADVREPFILE).SaveRepFile(RepID,RepTypeDr,fileparams)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	
	TC
	Q 0
}

/// Description: 不良反应报告作废
/// Creator:     CongYue
/// CreateDate:  2018-01-23
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^审核状态^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0 作废成功
/// Others:		 w ##class(web.DHCADVCOMMONPART).MataRepCancel("82^5738^402^69^^^未接收^advskinUlcer^10||1^Y")
ClassMethod MataRepCancel(params As %String) As %String
{
	N (params)
	S ListData = ..RepCancel(params)
	S ListTitle="ErrCode^ErrMsg"
	W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Description: 不良反应报告作废
/// Creator:     CongYue
/// CreateDate:  2018-01-23
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^审核状态^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0 作废成功
/// Others:		 w ##class(web.DHCADVCOMMONPART).RepCancel("138^5||2^600^63^126^2^wqdewq^未接收^med")
ClassMethod RepCancel(params As %String) As %String
{
	
	N (params)
	S ID=+$p(params,"^",1)       //不良反应报告ID
	S medadrAuditUserDR=+$p(params,"^",2)     //用户ID
	S LgCtLocID=+$p(params,"^",3)     //科室ID
	S LgGroupID=+$p(params,"^",4)     //安全组ID
	S list=medadrAuditUserDR_"^"_LgCtLocID_"^"_LgGroupID
	S medadrNextLocDR=$p(params,"^",5)
	S medadrLocAdvice=$p(params,"^",6)
	
	S medadrAuditDate=+$h
	S medadrAuditTime=$p($h,",",2)
	
	S typecode=$p(params,"^",8) // 报告类型代码
	S medadrType=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(typecode),"")) //报告类型id
	s eventparref="",eventsub="" ;2018-08-29
	i medadrType=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") medadrType=eventparref_"||"_eventsub
	S StatusID=$p(params,"^",9) // 当前状态
	
	S medadrReceivedr=$p(params,"^",7)
	S RepCancelFlag=$p(params,"^",10) ;作废
	
	S medadrRetReason="",RevStatus="",TimeOutFlag=""
	TS
	S matadrRepAuditList=StatusID_"^"_list_"^"_medadrNextLocDR_"^"_medadrLocAdvice_"^"_medadrReceivedr_"^"_medadrType_"^"_medadrRetReason_"^"_RevStatus_"^"_TimeOutFlag_"^"_RepCancelFlag
	S retVal=##class(web.DHCADVCOMMON).InsRepAudit(ID,matadrRepAuditList)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	
	TC
	Q 0
}

/// Description: 不良事件查询 
/// Creator:     CongYue
/// CreateDate:  2018-01-25
/// Input:  	 StrParam : 以字符"^"分割,格式为:开始时间^结束时间
/// Table:       FormRecord,FormRecordItm,FormRecordItmSub
/// Return: 	 不良事件 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryRepHomeList("64649^64687^193^^23^193^4805^^^^^^^^^")
ClassMethod QueryRepHomeList(StrParam As %String, LgParam As %String = "")
{
  
	N (StrParam,LgParam,%session)
	q:StrParam="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S DeptID=$p(StrParam,"^",3)    //科室
	S patNo=$p(StrParam,"^",4)     //登记号
	S UserId=$p(LgParam,"^",1)     //用户ID
	S LocId=$p(LgParam,"^",2)      //科室ID
	S GroupId=$p(LgParam,"^",3)    //安全组ID
	s HospId=$p(LgParam,"^",4) 	   //医院ID
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",LgParam)
	S:QUERYDATE="1" DateNode="OccurDate"
    S h=0  //yangyongtao  2017-11-22 
	q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	s count=0
	S RetArr=[]
	f date=EndDate:-1:StDate d
	.s RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) q:RepID=""  d
	..S RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",Medadrreceive="",Medadrreceivedr="",FileFlag="",RepOverTimeflag="",AutOverTimeflag="",RepOverTime="",AutOverTime="",RepCancelflag="",MedadrNextLocDR="",RepFistStatus="",RepLevelDr=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id） 2020-06-22
	..S RepTypeString=..GetRepTypeString(RepID)
	..S TypeDr=$p(RepTypeString,"^",1) ; 报告表单类型id
	..S TypeCode=$p(RepTypeString,"^",2)
	..S Type=$p(RepTypeString,"^",3)
	..S RepTypeDr=$p(RepTypeString,"^",4)
	..S RepTypeCode=$p(RepTypeString,"^",5)	
	..Q:(TypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(TypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,TypeDr,""))
	..S File="",FileFlag=""
	..S:FILERowID'="" File=$p(^DHCADVFILE(FILERowID),"^",3)
	..S FileFlag=$S(File="":"未归档",File="N":"撤销归档",File="Y":"已归档",1:"")
	..S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	..S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	..S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	..S OccurTime=$p(^DHCADVMASTER(RepID),"^",26)  ///发生时间
	..S:OccurTime="" OccurTime=0
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..I RepStausDr=""  D
	...S RepStaus="未提交"
	...S status="N"
	..E  D 
	...S status="Y"
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..I MedadrID'=""  D
	...S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9)
	...S MedadrNextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	..s AuditId="",RepCancelflag="",AutOverTimeflag=""
	..for  s AuditId=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,AuditId),-1)  Q:(AuditId="")  d
	...S OverTimeflag=$p(^DHCMEDREPADT(AuditId),"^",15) ;护士长审核超时标志
	...S Cancelflag=$p(^DHCMEDREPADT(AuditId),"^",11) ;作废标识
	...s:OverTimeflag'="" AutOverTimeflag=OverTimeflag
	...s:Cancelflag'="" RepCancelflag=Cancelflag
	..Q:RepCancelflag="Y"
	..S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	..S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	..S Listt=RepID_"^"_RepTypeDr_"^"_list_"^"_RepStausDr_"^"_MedadrNextLocDR_"^"_RepLevelDr
	..S matalist=""
	..S:RepStausDr'="" matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt,LgParam) 
	..S:matalist'="" StatusNextID=$p(matalist,"^",2)  //下一状态	
	..S:RepStausDr="" RepFistStatus=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,1,LgParam) ;报告初始
	..S:+RepFistStatus<=0 RepFistStatus=""
	..;S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	..S:RepDate'="" RepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	..;S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..s RepHospID="" //hxy 2020-02-18 st
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(HospId'="")&(HospId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..S AdmID=$p(^DHCADVMASTER(RepID),"^",16) 
	..S PatName=$p(^DHCADVMASTER(RepID),"^",17)  
	..S AdmNo=$p(^DHCADVMASTER(RepID),"^",20)  ///病案号
	..S OccurLoc=$p(^DHCADVMASTER(RepID),"^",27)  ///发生科室
	..S:OccurLoc'="" OccurLoc=$p(^CTLOC(OccurLoc),"^",2)
	..S:OccurLoc["-" OccurLoc=$p(OccurLoc,"-",2)
	..;S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	..S:OccurDate="0" OccurDate=""
	..S:(OccurDate'="")&&(OccurDate'="0") OccurDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(OccurDate)
	..S PatID=$p(^DHCADVMASTER(RepID),"^",14)  ///登记号
	..S PapRowid=""
	..S:AdmID'="" PapRowid=$p(^PAADM(AdmID),"^",1)
	..S:(AdmID'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(AdmID,"")  //病案号 
	..S:(PapRowid'="")&&(PatID="") PatID=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	..S:(PapRowid'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",PapRowid)  //病案号
	..S:(PapRowid'="")&&(PatName="") PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..S LocDep=""
	..S CaseShareflag="",CaseShareLoclist="",CaseShareUserlist="",CaseShareAdvicelist=""
	..S CaseShareflag=..GetCaseFlag(RepID,TypeDr,LocId,UserId)
	..S orderno=""	
	..S:RepStausDr'="" orderno=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",3)
	..Q:(DeptID'="")&(DeptID'=RepLocDr)
	..Q:FileFlag="已归档"
	..Q:((flag'="")&&(flag'=1))&&(CaseShareflag'="Y")
	..Q:(RepStausDr'="")&&(StatusNextID="")
	..s count=count+1
	..S tmpObj={}
	..S tmpObj.RepID=RepID
	..S tmpObj.RepType=Type ;
	..S tmpObj.RepStaus=RepStaus ;
	..S tmpObj.RepDate=RepDate  ;
	..S tmpObj.RepUser=RepUser
	..S tmpObj.RepLoc=RepLoc 
	..S tmpObj.PatID=PatID
	..S tmpObj.PatName=PatName ;
	..S tmpObj.AdmNo=AdmNo ;
	..S tmpObj.OccurLoc=OccurLoc
	..S tmpObj.OccurDate=OccurDate ;
	..S tmpObj.FileFlag=FileFlag ;
	..S tmpObj.RepTypeDr=TypeDr
	..S tmpObj.RepStausDr=RepStausDr
	..S tmpObj.RepFistStatus=RepFistStatus
	..D RetArr.%Push(tmpObj)
	;w !,$h
	Q RetArr
}

/// Description: 大科科室下拉数据 
/// Creator:     CongYue
/// CreateDate:  2018-01-25  
/// Table:		 DHC_AdvSecuGroupUserLoc,DHC_AdvSecuGroupUserWard
/// Input:   	 登录人id
/// Output:  	 科室下拉数据  12245 14865 14865
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetSecuGroupCombox("5738","69","402","")
ClassMethod GetSecuGroupCombox(UserId, GroupId, LocId, q) As %String
{
	N (UserId,GroupId,LocId,q)

	S pid=##class(web.DHCADVCOMMON).NewPid()
    K ^TMP("DHCADV","web.DHCADVCOMMONPART","GetSecuGroupCombox",pid)
	S count=0
	S:q'="" q=$zcvt(q,"U") 
	S GroupDesc=$p(^SSU("SSGRP",GroupId),"^",1)
	S LocDesc=$p(^CTLOC(LocId),"^",2)
	W "["	
	W:(GroupDesc'="护理部")&&(GroupDesc'="Nursing Manager")&&(GroupDesc'="住院护士长") ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",LocId_"^"_LocDesc)
	S SecuId=""
	F  S SecuId=$o(^DHCADVSECUGUW(SecuId)) q:SecuId=""  d
	.Q:+SecuId=0
	.S SecuGrpDr=$p(^DHCADVSECUGUW(SecuId),"^",1)
	.S SecuUser=$p(^DHCADVSECUGUW(SecuId),"^",2)
	.S SecuWard=$p(^DHCADVSECUGUW(SecuId),"^",3)
	.;s ^DHCADVSECUGU
	.S useruId=$o(^DHCADVSECUGU(0,"GroupUser",SecuGrpDr,SecuUser,""))
	.S useruflag=""
	.S:useruId'="" useruflag=$p(^DHCADVSECUGU(useruId),"^",3)
	.Q:(SecuUser'=UserId)&(UserId'="")&(GroupDesc'="护理部")&&(GroupDesc'="Nursing Manager")
	.Q:(useruflag'="Y")&(UserId="")
	.S LocationDR=$p(^PAWARD(SecuWard),"^",5)
	.Q:LocationDR=""
	.S LocationDesc=$p(^CTLOC(LocationDR),"^",2)
	.S ContactName=$p(^CTLOC(LocationDR),"^",43) // 科室编码   
	.Q:(q'="")&(LocationDesc'[q)&&(ContactName'[q)
	.S tmp=LocationDR_"^"_LocationDesc
	.S count = count+1
	.Q:$D(^TMP("DHCADV","web.DHCADVCOMMONPART","GetSecuGroupCombox",pid,LocationDR))
	.S ^TMP("DHCADV","web.DHCADVCOMMONPART","GetSecuGroupCombox",pid,LocationDR,count)=tmp
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp) //value^text
	S SecuId=""
	F  S SecuId=$o(^DHCADVSECUGUL(SecuId)) Q:SecuId=""  D
	.Q:+SecuId=0
	.S SecuGrpDr=$p(^DHCADVSECUGUL(SecuId),"^",1)
	.S SecuUser=$p(^DHCADVSECUGUL(SecuId),"^",2)
	.S SecuLoc=$p(^DHCADVSECUGUL(SecuId),"^",3)
	.S SecuLocDesc=$p(^CTLOC(SecuLoc),"^",2)
	.S ContactName=$p(^CTLOC(SecuLoc),"^",43) // 科室编码 
	.S useruId=$o(^DHCADVSECUGU(0,"GroupUser",SecuGrpDr,SecuUser,""))
	.S useruflag=""
	.S:useruId'="" useruflag=$p(^DHCADVSECUGU(useruId),"^",3)
	.Q:(SecuUser'=UserId)&(UserId'="")&(GroupDesc'="护理部")&&(GroupDesc'="Nursing Manager")
	.Q:(useruflag'="Y")&(UserId="")
	.Q:(q'="")&(LocationDesc'[q)&&(ContactName'[q)
	.S tmp=SecuLoc_"^"_SecuLocDesc
	.S count = count+1
	.Q:$D(^TMP("DHCADV","web.DHCADVCOMMONPART","GetSecuGroupCombox",pid,SecuLoc))
	.S ^TMP("DHCADV","web.DHCADVCOMMONPART","GetSecuGroupCombox",pid,SecuLoc,count)=tmp
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp) //value^text
	W "]"
	Q ""
}

/// Description: 删除 [护理不良事件报告]
/// Creator:     CongYue
/// CreateDate:  2018-01-26
/// Table:		 DHC_MedAdrRepEvent
/// Input:  	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVCOMMONPART).DelAdrEvent("")
ClassMethod DelRepData(RepID As %String) As %String
{
	N (RepID)
	&SQL(Delete From DHC_AdvMaster Where ADV_RowID=:RepID)
	Q SQLCODE
}

/// Description: 获取共享科室列
/// Creator:     CongYue
/// CreateDate:  2018-01-26
/// Table:		 DHC_AdvCaseShare
/// Input:  	 报告id ，报告类型id，
/// Return: 	 共享科室串
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetCaseLocList("")
ClassMethod GetCaseLocList(RepDr As %String, RepTypeDr As %String) As %String
{
	N (RepDr,RepTypeDr,%session)
	S LocList="",CaseShareLocDr="",n=0
	S UserList="",AdviceList=""
	F  S CaseShareLocDr=$o(^DHCADVCASHARE(0,"RepDrType",RepDr,RepTypeDr,CaseShareLocDr)) Q:CaseShareLocDr=""  D
	.S ID=""
	.S n=n+1
	.F  S ID=$o(^DHCADVCASHARE(0,"RepDrType",RepDr,RepTypeDr,CaseShareLocDr,ID)) Q:ID=""  D
	..Q:+ID=0
	..S CaseShareLocDr=$p(^DHCADVCASHARE(ID),"^",3) ///共享科室指向
	..S ShareLoc=""
	..S:CaseShareLocDr'="" ShareLoc=$p(^CTLOC(CaseShareLocDr),"^",2)
	..S ShareLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",ShareLoc) //hxy 2020-06-24
	..S CaseShareUserDr=$p(^DHCADVCASHARE(ID),"^",11) ///共享人员指向
	..S ShareUser=""  
	..S:CaseShareUserDr'="" ShareUser=$p(^SSU("SSUSR",CaseShareUserDr),"^",2)
	..S ShareUser=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",ShareUser)
	..S ShareAdvice=$p(^DHCADVCASHARE(ID),"^",12) ///共享意见
	..S CASHAREIfShare=$p(^DHCADVCASHARE(ID),"^",4) ///共享标识
	..Q:CASHAREIfShare'="Y"
	..I ShareLoc'=""  D
	...I LocList="" S LocList=n_"."_ShareLoc
	...E  S LocList=LocList_","_n_"."_ShareLoc
	..I ShareUser'=""  D
	...I UserList="" S UserList=n_"."_ShareUser
	...E  S UserList=UserList_","_n_"."_ShareUser
	..I ShareAdvice'=""  D
	...I AdviceList="" S AdviceList=n_"."_ShareAdvice
	...E  S AdviceList=AdviceList_";"_n_"."_ShareAdvice
	
	Q LocList_"&&"_UserList_"&&"_AdviceList
}

/// Description: 获取共享科室、人员权限
/// Creator:     CongYue
/// CreateDate:  2019-07-16
/// Table:		 DHC_AdvCaseShare
/// Input:  	 报告id ，报告类型id，登录科室id，登录人员id
/// Return: 	 共享标识：N 当前登录科室人员未共享   Y 当前登录科室人员已共享
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetCaseFlag("87","87||2",93,1)
ClassMethod GetCaseFlag(RepDr As %String, RepTypeDr As %String, LocID As %String, UserID As %String) As %String
{
	N (RepDr,RepTypeDr,LocID,UserID)
	S flag="N",ID="",UserList="",ShareID=""
	F  S ID=$o(^DHCADVCASHARE(0,"RepDrType",RepDr,RepTypeDr,LocID,ID)) Q:ID=""  D
	.Q:+ID=0
	.S CASHAREIfShare=$p(^DHCADVCASHARE(ID),"^",4) ///共享标识
	.Q:CASHAREIfShare'="Y"
	.S:CASHAREIfShare="Y" ShareID=ID
	.S CaseShareUserDr=$p(^DHCADVCASHARE(ID),"^",11) ///共享人员指向
	.S:(CaseShareUserDr'="")&&(CaseShareUserDr=UserID) flag="Y"
	.I CaseShareUserDr'=""  D
	..I UserList=""  D
	...S UserList=CaseShareUserDr
	..E  D
	...S UserList=UserList_","_CaseShareUserDr
	.
	S:(ShareID'="")&&(UserList="") flag="Y"
	
	Q flag
}

ClassMethod GetSaveInfoCommon(code, recordid) As %String
{
	N (code,recordid)
	Q:(code="")||(recordid="") ""
	S FieldID="",ContrastID="",FormDicID="",RecordItmID="",RecordItmvalue=""
	S thisFormNameCode="",FormDicCode=""
	Q:'$D(^DHCADVFF(0,"Code",$$ALPHAUP^SSUTIL4(code))) ""
	S FieldID=$o(^DHCADVFF(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	Q:FieldID="" ""
	F  S RecordItmID=$o(^User.DHCAdvFormRecordItmI("IndexFormRecord",recordid,RecordItmID)) Q:RecordItmID=""  D
	.S thisFormid=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),5)
	.S thisFormName=$lg(^User.DHCAdvFormD(thisFormid),2)
	.S thisFormNameCode=$lg(^User.DHCAdvFormNameD(thisFormName),2)
	.Q:thisFormNameCode=""
	.Q:'$D(^DHCADVFDC(0,"FieldFormName",FieldID,thisFormNameCode))
	.S ContrastID=$o(^DHCADVFDC(0,"FieldFormName",FieldID,thisFormNameCode,""))
	.S:ContrastID'="" FormDicCode=$p(^DHCADVFDC(ContrastID),"^",4)
	.S:FormDicCode'="" FormDicID=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(FormDicCode),""))  
	.Q:(FormDicID'="")&&(FormDicID'=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),3))
	.S RecordItmvalue=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),4)
	.Q:RecordItmvalue'=""
	Q RecordItmvalue
}

/// Description: 判断字符串是否是日期
/// Creator:     CongYue
/// CreateDate:  2018-03-20
/// Table:		 
/// Input:  	  (4:"DMY" DD/MM/YYYY 3:"YMD" YYYY-MM-DD  1:"MDY" MM/DD/YYYY)，字符串   
/// Return: 	 字符串为日期则返回（2018-01-01格式的日期），若不是日期则返回原串
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetDate("02/30/2018")
ClassMethod GetDate(List As %String) As %String
{
	N (List)
	S DateFormat = ##class(websys.Conversions).DateFormat()
	S DataList=""
	S len=$L(List)
	I DateFormat="1"  D
	.S Month=$p(List,"/",1)
	.Q:($L(Month)'="2")&&(Month<0)&&(Month>12)
	.S Day=$p(List,"/",2)
	.Q:($L(Day)'="2")&&(Day<0)&&(Day>31)
	.S Year=$p(List,"/",3)
	.Q:($L(Year)'="4")
	.Q:Year<1840
	.Q:(Month<"07")&&((Month/"02")=(Month\"02"))&&(Month'="02")&&(Day>30)
	.Q:(Month>"07")&&((Month/"02")'=(Month\"02"))&&(Month'="02")&&(Day>30)
	.Q:(Month="02")&&((Year/"4")=(Year\"4"))&&(Day>29)
	.Q:(Month="02")&&((Year/"4")'=(Year\"4"))&&(Day>28)
	.S DataList=$zdh(List,1)
	.S:DataList'="" DataList=$zd(DataList,3)
	I DateFormat="4"  D
	.S Day=$p(List,"/",1)
	.Q:($L(Day)'="2")&&(Day<0)&&(Day>31)
	.S Month=$p(List,"/",2)
	.Q:($L(Month)'="2")&&(Month<0)&&(Month>12)
	.S Year=$p(List,"/",3)
	.Q:($L(Year)'="4")
	.Q:Year<1840
	.Q:(Month<"07")&&((Month/"02")=(Month\"02"))&&(Month'="02")&&(Day>30)
	.Q:(Month>"07")&&((Month/"02")'=(Month\"02"))&&(Month'="02")&&(Day>30)
	.Q:(Month="02")&&((Year/"4")=(Year\"4"))&&(Day>29)
	.Q:(Month="02")&&((Year/"4")'=(Year\"4"))&&(Day>28)
	.S DataList=$zdh(List,4)
	.S:DataList'="" DataList=$zd(DataList,3)
	S:DataList="" DataList=List
	Q DataList
}

/// Description: 将日期转为当前系统格式日期
/// Creator:     CongYue
/// CreateDate:  2018-03-20
/// Table:		 
/// Input:  	 2018-01-01 格式日期
/// Return: 	 字符串为日期则返回（系统格式的日期），若不是日期则返回原串
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetDateToHtml("2018-02-29")
ClassMethod GetDateToHtml(List As %String) As %String
{
	N (List)
	S DataList=""
	S len=$L(List)
	S Year=$p(List,"-",1)
	Q:($L(Year)'="4") List 
	S Month=$p(List,"-",2)
	Q:($L(Month)'="2")&&(Month<0)&&(Month>12) List
	S Day=$p(List,"-",3) 
	Q:($L(Day)'="2")&&(Day<0)&&(Day>31) List
	Q:(Month<"07")&&((Month/"02")=(Month\"02"))&&(Month'="02")&&(Day>30) List
	Q:(Month>"07")&&((Month/"02")'=(Month\"02"))&&(Month'="02")&&(Day>30) List
	Q:(Month="02")&&((Year/"4")=(Year\"4"))&&(Day>29) List
	Q:(Month="02")&&((Year/"4")'=(Year\"4"))&&(Day>28) List
	Q:Year<1840 List
	S DataList=$zdh(List,3)
	S:DataList'="" DataList=##class(web.DHCADVCOMMON).DateLogicalToHtml(DataList)
	S:DataList="" DataList=List
	Q DataList
}

/// Description: 根据 关联表单记录id 和 表单唯一标识 获取表单记录id
/// Creator:     CongYue
/// CreateDate:  2018-04-14
/// Table:		 DHC_AdvFormRecord
/// Input:  	 关联表单记录id ,表单唯一标识
/// Return: 	 表单id
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetRecordId("12","cs")
ClassMethod GetRecordId(LinkRecordId As %String, FormCode As %String) As %String
{
	N (LinkRecordId,FormCode)
	S RecordId="",FormID="",RecID=""
	Q:FormCode="" ""
	S FormID=$o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(FormCode),""))
	F  S RecID=$o(^User.DHCAdvFormRecordI("IndexFormName",$$ALPHAUP^SSUTIL4(FormID),RecID)) Q:(RecID="")||(RecordId'="")  D
	.Q:+RecID=0
	.S Recorddata=^User.DHCAdvFormRecordD(RecID)
	.S RecLinkRecordId=$LIST(Recorddata,9)
	.S:RecLinkRecordId=LinkRecordId RecordId=RecID
	.Q:RecordId'=""
	Q RecordId
}

/// S matadrNo=..GetAdrReportCurMaxNo("MATADR"_$zd(+$H,8),"3") //报告编码 $p(dataList,"^",1)
/// Description: 取当前不良反应报告最大码
/// Creator:	 CongYue
/// CreateDate:  2015-12-21
/// Input:  	 报告编码规则,编码数字长度  "MATADR"_$zd(+$H,8)  4
/// Return:  	 当前不良反应报告最大码
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetAdrRepMaxNo("DHCADV","4",983)
ClassMethod GetAdrRepMaxNo(CurCode As %String, NoLen As %String, formId As %String) As %String
{
	N (CurCode,NoLen,formId,%session)
	S myrlflag=(('$d(%session.Data("LOGON.USERID")))||($g(%session.Data("LOGON.USERID"))=""))
	Q:myrlflag=1 "Error"        ;2021-05-17 cy 保存时加校验登录是否超时 ;2021-05-17 cy 保存时加校验登录是否超时
	S Formdata="",RepTypeCode="",RepTypeDr=""
	S:formId'="" Formdata=^User.DHCAdvFormNameD(formId)
	S:Formdata'="" RepTypeCode=$LIST(Formdata,2)
	S:RepTypeCode'="" RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //类别指向
	S eventparref="",eventsub="" ;2018-08-29
	I RepTypeDr=""  D
	.S:RepTypeCode'="" eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") RepTypeDr=eventparref_"||"_eventsub
	S NextNo=""
	S Prefix=CurCode_$zd(+$H,8)
	L +^DHCADVRMN("DHCADV",Prefix):10 E  Q -100
	S PreLen=$L(Prefix)
	S MinSuffix=1
	F i=1:1:NoLen-1 S MinSuffix="0"_MinSuffix
	S MinNo=Prefix_MinSuffix	//最小码
	S CurLen=PreLen+NoLen	    //单号长度
	///表里记录的最大码
	S CurrMaxNo=..GetMaxCode(Prefix,RepTypeDr)
	S CurPrefix=$E(CurrMaxNo,1,PreLen)
	S CurrNo=$E(CurrMaxNo,PreLen+1,CurLen)
	
	I Prefix'=CurPrefix D
	.S NextNo=MinNo
	.L -^DHCADVRMN("DHCADV",Prefix)
	S:NextNo'="" ret=..SaveMaxCode(CurrMaxNo,NextNo,RepTypeDr)
	Q:NextNo'="" NextNo

	S Suffix=CurrNo+1
	S slen=$L(Suffix)
	S flen=NoLen-slen
	F i=1:1:flen S Suffix="0"_Suffix
	S NextNo=Prefix_Suffix
	L -^DHCADVRMN("DHCADV",Prefix)
	S:NextNo'="" ret=..SaveMaxCode(CurrMaxNo,NextNo,RepTypeDr)
	Q NextNo
}

/// Description: 获取当前最大码
/// Creator:	 CongYue
/// CreateDate:  2015-12-21
/// Input:  	 报告编码规则,编码数字长度
/// Return:  	 当前不良反应报告最大码  
ClassMethod GetMaxCode(Prefix As %String, RepTypeDr As %String) As %String
{
	N (Prefix, RepTypeDr)
	Q:Prefix="" ""
	S AdvRmnCode=""
	I RepTypeDr="" D
	.&sql(select max(ADVRMN_Code) into AdvRmnCode from DHC_AdvRepMaxNo Where ADVRMN_Code %STARTSWITH %ALPHAUP :Prefix )
	E  D
	.&sql(select max(ADVRMN_Code) into AdvRmnCode from DHC_AdvRepMaxNo Where ADVRMN_Code %STARTSWITH %ALPHAUP :Prefix and ADVRMN_RepType_Dr=:RepTypeDr)
	Q AdvRmnCode
}

/// Description: 更新保存当前最大码
/// Creator:	 CongYue
/// CreateDate:  2018-06-05
/// Input:  	 报告编码
/// Return:  	 0 保存成功，非0 保存失败  
ClassMethod SaveMaxCode(CurrMaxNo As %String, Code As %String, RepTypeDr As %String) As %String
{
	N (CurrMaxNo,Code,RepTypeDr)
	Q:Code="" "-1"
	S AdvRMNID=""
	S:CurrMaxNo'="" AdvRMNID=$o(^DHCADVRMN(0,"Code",CurrMaxNo,""))
	S:RepTypeDr'="" AdvRMNID=$o(^DHCADVRMN(0,"RepType",RepTypeDr,""))
	I AdvRMNID="" D
	.&SQL(INSERT INTO DHC_AdvRepMaxNo(ADVRMN_Code,ADVRMN_RepType_Dr) VALUES(:Code,:RepTypeDr))
	Q:+$g(SQLCODE)'=0 SQLCODE
	
	I AdvRMNID'="" D
	.&SQL(Update DHC_AdvRepMaxNo Set ADVRMN_Code=:Code,ADVRMN_RepType_Dr=:RepTypeDr Where ADVRMN_RowID=:AdvRMNID)
	Q:+$g(SQLCODE)'=0 SQLCODE

	Q 0
}

/// Description: 查询[审批表信息 json对象]
/// Creator:     CongYue
/// CreateDate:  2018-06-07
/// Table: 		 DHC_MedAdrRepAudit
/// Input:  	 报告ID,报告类型ID
/// Output:  	 DHC_MedAdrRepAudit表中的数据信息   
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryAuditMesJson("133^med")
ClassMethod QueryAuditMesJson(ReportID As %String, TypeDr As %String) As %String
{
	N (ReportID,TypeDr,%session)
	S RepTypeString=##class(web.DHCADVCOMMONPART).GetRepTypeString(ReportID)
	S TypeDr=$p(RepTypeString,"^",4)
	S TypeCode=$p(RepTypeString,"^",5)
    S pid=##class(web.DHCADVCOMMON).NewPid()
    K ^TMP("DHCADV","web.DHCADVCOMMONPART","QueryAuditMesJson")
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,""),-1)
	Q:MedadrID=""
	S h=0,count=0
	S ID=""
	F  S ID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,ID)) Q:ID=""  D
	.Q:ID=0
	.S StatusDR=$p(^DHCMEDREPADT(ID),"^",3) //状态
	.Q:StatusDR=""
	.S Subflag=0
	.S TranMess=..QueryAuditItmMesJson(ID)
	.S Status=""
	.S:StatusDR'="" Status=$p(^DHCADREVTWFI(+StatusDR,"ADREWI",$p(StatusDR,"||",2)),"^",2)	
	.S AuditUserDR=$p(^DHCMEDREPADT(ID),"^",4) //审批人
	.S AuditUser=""
	.S:AuditUserDR'="" AuditUser=$p(^SSU("SSUSR",AuditUserDR),"^",2)
	.S AuditUser=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",AuditUser)  ;2020-06-28 cy
	.S AuditDate=$p(^DHCMEDREPADT(ID),"^",5) //审批日期
	.I AuditDate'="" S AuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AuditDate)
	.S AuditTime=$p(^DHCMEDREPADT(ID),"^",6) //审批时间
	.I AuditTime'="" S AuditTime=$zt(AuditTime,1)
	.S NextLocDR=$p(^DHCMEDREPADT(ID),"^",7) //科室指向
	.S NextLoc=""
	.S:NextLocDR'="" NextLoc=$p(^CTLOC(NextLocDR),"^",2)
	.S NextLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",NextLoc)  ;2020-06-28 cy
	.S LocAdvice=$p(^DHCMEDREPADT(ID),"^",8) //科室意见
	.S ReceiveDR=$p(^DHCMEDREPADT(ID),"^",9) //接收状态
	.S RetReason=$p(^DHCMEDREPADT(ID),"^",10) //驳回意见
	.S RecProgress=$p(^DHCMEDREPADT(ID),"^",13) //调查核实
	.S RetStatusDr=$p(^DHCMEDREPADT(ID),"^",14) //驳回指向
	.S RetStatus=""
	.S:RetStatusDr'="" RetStatus=$p(^DHCADREVTWFI(+RetStatusDr,"ADREWI",$p(RetStatusDr,"||",2)),"^",2)	
	.S AuditReason=""
	.S:(RetReason'="")&&(LocAdvice="") AuditReason=RetReason
	.S:(RetReason="")&&(LocAdvice'="") AuditReason=LocAdvice
	.S:(RetReason'="")&&(LocAdvice='"") AuditReason=LocAdvice_"/"_RetReason
	.I ReceiveDR=""  S ReceiveDR="未接收"
	.S Receive=$S(ReceiveDR="未接收":"未接收",ReceiveDR="1":"接收",ReceiveDR="2":"驳回",ReceiveDR="3":"撤销",ReceiveDR="4":"审核",ReceiveDR="5":"归档",ReceiveDR="6":"撤销归档",ReceiveDR="7":"归档待复核",1:"")
	.Q:(ReceiveDR'=3)&&(TranMess="")&&(AuditReason="")
	.S Receive=##class(websys.Translation).Get("dhcadv.layoutform.csp",Receive)
	.S Status=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdrEvtWorkFlowItm","ADREWIDesc","",Status)
	.S RetStatus=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdrEvtWorkFlowItm","ADREWIDesc","",RetStatus)
	.S h=h+1
	.S TempStr=ID_"^"_StatusDR_"^"_AuditUserDR_"^"_AuditUser_"^"_AuditDate_" "_AuditTime_"^"_NextLocDR_"^"_NextLoc_"^"_AuditReason_"^"_Receive_"^"_Status_"^"_TranMess_"^"_RetStatus_"^"_RecProgress
	.S ^TMP("DHCADV","web.DHCADVCOMMONPART","QueryAuditMesJson",pid,h)=TempStr
	
	///转换数据为Json格式
	S Title="ID^StatusDR^AuditUserDR^AuditUser^AuditDateTime^NextLocDR^NextLoc^LocAdvice^Receive^Status^TranMess^RetStatus^RecProgress"
	;W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S Num=0,ret=""
	S ret = "["
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","QueryAuditMesJson",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVCOMMONPART","QueryAuditMesJson",pid,index))
	.S ret=ret_$case(Num,0:"",:",")
	.S Num=Num+1
	.S ret=ret_##class(web.DHCADVJSONCOMMON).getJsonDataPort(Title,mdate)
	S ret=ret_"]"
	K ^TMP("DHCADV","web.DHCADVCOMMONPART","QueryAuditMesJson")
	Q ret
}

/// Description: 查询[审批子表信息 json对象]
/// Creator:     CongYue
/// CreateDate:  2018-06-11
/// Table: 		 DHC_MedAdrRepAuditItm
/// Input:  	 报告ID^报告类型代码
/// Output:  	 DHC_MedAdrRepAuditItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryAuditItmMesJson("133")
ClassMethod QueryAuditItmMesJson(AuditID As %String) As %String
{
	N (AuditID)
    S pid=##class(web.DHCADVCOMMON).NewPid()
    K ^TMP("DHCADV","web.DHCADVCOMMONPART","QueryAuditItmMesJson")
	S h=0,count=0
	S Sub=""
	F  S Sub=$o(^DHCMEDREPADT(AuditID,"MEDADRI",Sub)) Q:Sub=""  D
	.Q:Sub=0
	.S MedIAuditDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",1) //审批日期
	.I MedIAuditDate'="" S MedIAuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedIAuditDate)
	.S MedIAuditTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",2) //审批时间
	.I MedIAuditTime'="" S MedIAuditTime=$zt(MedIAuditTime,1)
	.S MedIAuditUserCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",3) //审批人
	.S MedIAuditUser="",MedIAuditUserDR=""
	.S:MedIAuditUserCode'="" MedIAuditUserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedIAuditUserCode),""))
	.S:MedIAuditUserDR'="" MedIAuditUser=$p(^SSU("SSUSR",MedIAuditUserDR),"^",2)
	.S MedINextLocCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",4) //指向科室
	.S MedINextLoc="",MedINextLocDR=""
	.S:MedINextLocCode'="" MedINextLocDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(MedINextLocCode),""))
	.S:MedINextLocDR'="" MedINextLoc=$p(^CTLOC(MedINextLocDR),"^",2)
	.S MedINextUserCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",5) //指向人员
	.S MedINextUser="",MedINextUserDR=""
	.S:MedINextUserCode'="" MedINextUserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedINextUserCode),""))
	.S:MedINextUserDR'="" MedINextUser=$p(^SSU("SSUSR",MedINextUserDR),"^",2)
	.S MedIUserAdvice=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",6) //人员意见
	.S MedIReceiveDR=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",7) //接收状态
	.I MedIReceiveDR=""  S MedIReceiveDR="N"
	.S MedIReceive=$S(MedIReceiveDR="N":"未接收",MedIReceiveDR="Y":"接收",1:"")
	.S MedIReceiveDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",8) //接收日期
	.I MedIReceiveDate'="" S MedIReceiveDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedIReceiveDate)
	.S MedIReceiveTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",9) //接收时间
	.I MedIReceiveTime'="" S MedIReceiveTime=$zt(MedIReceiveTime,1)
	.S MedICompleteDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",10) //完成日期
	.I MedICompleteDate'="" S MedICompleteDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedICompleteDate)
	.S MedICompleteTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",11) //完成时间
	.I MedICompleteTime'="" S MedICompleteTime=$zt(MedICompleteTime,3)
	.S MedILocAdvice=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",12) //部门意见
	.S AuditDutyFlag=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",13) //备注
    .I AuditDutyFlag="N"  S AuditDutyFlag=""
    .I AuditDutyFlag="Y"  S AuditDutyFlag="该事件已报告本部门第一责任人"
	.S h=h+1
	.S TempStr=MedIAuditDate_" "_MedIAuditTime_"^"_MedIAuditUserDR_"^"_MedIAuditUser_"^"_MedINextLocDR_"^"_MedINextLoc_"^"_MedINextUserDR_"^"_MedINextUser_"^"_MedIUserAdvice_"^"_MedIReceive_"^"_MedIReceiveDate_" "_MedIReceiveTime_"^"_MedICompleteDate_" "_MedICompleteTime_"^"_MedILocAdvice_"^"_AuditDutyFlag
	.S ^TMP("DHCADV","web.DHCADVCOMMONPART","QueryAuditItmMesJson",pid,h)=TempStr
	Q:h=0 ""
	///转换数据为Json格式
	S Title="MedIAuditDateTime^MedIAuditUserDR^MedIAuditUser^MedINextLocDR^MedINextLoc^MedINextUserDR^MedINextUser^MedIUserAdvice^MedIReceive^MedIReceiveDateTime^MedICompleteDateTime^MedILocAdvice^DutyFlag"
	;W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S Num=0,ret=""
	S ret = "["
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","QueryAuditItmMesJson",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVCOMMONPART","QueryAuditItmMesJson",pid,index))
	.S ret=ret_$case(Num,0:"",:",")
	.S Num=Num+1
	.S ret=ret_##class(web.DHCADVJSONCOMMON).getJsonDataPort(Title,mdate)
	S ret=ret_"]"
	K ^TMP("DHCADV","web.DHCADVCOMMONPART","QueryAuditItmMesJson")
	Q ret
}

/// Description: 压疮部位(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2018-06-08
/// Input:  	 
/// Return: 	 压疮部位(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryUlcerPartCombo()
ClassMethod QueryUlcerPartCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","骶尾椎骨").Put("text","骶尾椎骨"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","坐骨").Put("text","坐骨"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","股骨粗隆").Put("text","股骨粗隆"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","根骨").Put("text","根骨"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","足踝 ").Put("text","足踝 "))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","肩胛骨").Put("text","肩胛骨"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","枕骨").Put("text","枕骨"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","其他部位").Put("text","其他部位"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 压疮分期(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2018-06-08
/// Input:  	 
/// Return: 	 压疮分期(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryUlcerLevelCombo()
ClassMethod QueryUlcerLevelCombo()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","可疑深部组织损伤").Put("text","可疑深部组织损伤"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Ⅰ期淤血红润期 ").Put("text","Ⅰ期淤血红润期 "))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Ⅱ期炎性浸润期").Put("text","Ⅱ期炎性浸润期"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Ⅲ期浅度溃疡期").Put("text","Ⅲ期浅度溃疡期"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Ⅳ期坏死溃疡期 ").Put("text","Ⅳ期坏死溃疡期 "))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","不可分期压疮").Put("text","不可分期压疮"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Description: 获取日期类型（周六，周日，元旦，端午等） 
/// Creator:     CongYue
/// CreateDate:  2018-06-13
/// Input:  	 日期 (2018-01-01)
/// Return: 	 日期类型 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryDateType("2018-07-29")
ClassMethod QueryDateType(Date)
{
	N (Date)
	Q:Date="" ""
	S Result = ##Class(%ResultSet).%New("web.DHCBL.CT.BDPHoliday:GetDataForCmb1") //调用 节假日,为combobox查询取数据 query程序
	S SC = Result.Execute("",Date,"") //query传参
	S DateType="工作日"
	While (Result.Next())
	{
		S DateDesc=$g(Result.Data("BDPHDDesc")) 			//节假日信息
		S:DateDesc'="" DateType=DateDesc
	}
	Q DateType
}

/// Description: 通过对照表Code获取 对应元素的value值
/// Creator:     CongYue
/// CreateDate:  2017-12-19  
/// Table:		 DHC_AdvFormField ,DHC_AdvFormDicContrast ,
/// Input:   	 需保存的数据对应的code，元素所在formid
/// Output:  	 元素value值 
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetSaveInfo("PatName","983","2")
ClassMethod GetSaveInfo(code, formid, recordid) As %String
{
	N (code,formid,recordid,%session)
	Q:(code="")||(formid="")||(recordid="")
	S FormNameCode="",FormDicCode=""
	S FieldID="",ContrastID="",FormDicID="",RecordItmID="",RecordItmvalue=""
	Q:'$d(^DHCADVFF(0,"Code",$$ALPHAUP^SSUTIL4(code))) ""
	S FormNameCode=$lg(^User.DHCAdvFormNameD(formid),2)
	Q:FormNameCode="" ""
	S FieldID=$o(^DHCADVFF(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	S:FieldID'="" ContrastID=$o(^DHCADVFDC(0,"FieldFormName",FieldID,FormNameCode,""))
	S:ContrastID'="" FormDicCode=$p(^DHCADVFDC(ContrastID),"^",4)
	S:FormDicCode'="" FormDicID=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(FormDicCode),""))  
	Q:formid'=$lg(^User.DHCAdvFormRecordD(recordid),2) ""
	
	Q:FormDicID="" ""
	F  S RecordItmID=$o(^User.DHCAdvFormRecordItmI("IndexFormRecord",recordid,RecordItmID)) Q:RecordItmID=""  D
	.Q:(FormDicID'="")&&(FormDicID'=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),3))&&(FormDicID'=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),8))
	.S RecordItmvalue=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),4)
	.Q:RecordItmvalue'=""
	Q RecordItmvalue
}

/// Description: 病人类型-医疗类别-病人费别(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2018-06-28
/// Input:  	 
/// Return: 	 病人类型-医疗类别-病人费别(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QuerySocialStatusCombo()
ClassMethod QuerySocialStatusCombo(hospId = "")
{
	n (hospId,%session)
	S jsonObj=##class(web.DHCAPPJsonObject).%New()
	S listObj=##class(%ListOfObjects).%New()
	S SocialStatusDr="",SocialStatusDesc=""
	F  S SocialStatusDr=$o(^PAC("ADMREA",+SocialStatusDr)) Q:SocialStatusDr=""  D
	.S SocialStatusDesc=$p($g(^PAC("ADMREA",+SocialStatusDr)),"^",2)
	.S SocialStatusDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.PACAdmReason","READesc","",SocialStatusDesc)
	.Q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("PAC_AdmReason",SocialStatusDr,hospId,"")'="Y" 

	.S DateFrom=$p(^PAC("ADMREA",SocialStatusDr),"^",3)
	.Q:(DateFrom'="")&&(DateFrom>+$H)
	.S DateTo=$p(^PAC("ADMREA",SocialStatusDr),"^",4)
	.Q:(DateTo'="")&&(DateTo<+$H)
	.D listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",SocialStatusDesc).Put("text",SocialStatusDesc))
	W jsonObj.ListToJson(listObj)
	Q ""
}

/// Description: 病人职业-患者职别(下拉框) 
/// Creator:     CongYue
/// CreateDate:  2018-06-28
/// Input:  	 
/// Return: 	 病人职业-患者职别(下拉框) 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryOccupationCombo()
ClassMethod QueryOccupationCombo()
{
	n (%session)
	S jsonObj=##class(web.DHCAPPJsonObject).%New()
	S listObj=##class(%ListOfObjects).%New()
	S OccupationDr="",OccupationDesc=""
	F  S OccupationDr=$o(^CT("OCC",OccupationDr)) Q:OccupationDr=""  D
	.Q:+OccupationDr=0
	.S OccupationDesc=$p($g(^CT("OCC",OccupationDr)),"^",2)
	.S OccupationDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.CTOccupation","CTOCCDesc","",OccupationDesc)
	.S StDate=$p($g(^CT("OCC",OccupationDr)),"^",3) 		//有效期 开始日期 //qunianpeng 2017/12/29 增加对性别有效期的判断
	.S EndDate=$p($g(^CT("OCC",OccupationDr)),"^",4) 	//有效期 接收日期
	.Q:(StDate'="")&&(StDate>$h)
	.Q:(StDate'="")&&(EndDate'="")&&((StDate>$h)||(EndDate<$h))  
	.D listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",OccupationDesc).Put("text",OccupationDesc))
	W jsonObj.ListToJson(listObj)
	Q ""
}

ClassMethod WarnMataReport(auditparams)
{
	N (auditparams)
	S RepID=$p(auditparams,"^",1)
	S RepTypeCode=$p(auditparams,"^",2)
	S flag=$p(auditparams,"^",3)
	S RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),""))
	S eventparref="",eventsub="" ;2018-08-29
	I RepTypeDr=""  D
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") RepTypeDr=eventparref_"||"_eventsub
	TS
	S Err=0
	
	S retVal=..SaveWarnFile(RepID,RepTypeDr,flag)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	
	TC
	Q 0
}

/// Description: 报告预警
/// Creator:     CongYue
/// CreateDate:  2018-01-22  
/// Table:	     DHC_AdvRepFile 
/// Input:  	
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVCOMMONPART).SaveRepFile("2^2018-01-16^归档")
ClassMethod SaveWarnFile(RepID, RepTypeDr, flag) As %String
{
	N (RepID,RepTypeDr,flag)
	S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,RepTypeDr,""))

	I FILERowID'="" D
	.S Err=..UpdRepFile(FILERowID,RepID,RepTypeDr,flag)
	E  D
	.S Err=..InsRepFile(RepID,RepTypeDr,flag)
	Q Err
}

/// Description: 增加[归档数据维护] 
/// Creator:     CongYue
/// CreateDate:  2018-01-22  
/// Table:	     DHC_AdvRepFile 
/// Input:  	 DataList:以字符"^"分割,格式为: id^日期^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVCOMMONPART).InsRepFile("")
ClassMethod InsRepFile(RepID, RepTypeDr, flag) As %String
{
	N (RepID,RepTypeDr,flag)
 	&SQL(INSERT INTO DHC_AdvRepFile(FILE_RepDr,FILE_RepType,FILE_IfFile) 
 		VALUES(:RepID,:RepTypeDr,:flag))
 	Q SQLCODE
}

/// Description: 修改[归档数据维护] 
/// Creator:     CongYue
/// CreateDate:  2018-01-22  
/// Table:	     DHC_AdvRepFile 
/// Input:  	 DataList: 以字符"^"分割,格式为: id^日期^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVCOMMONPART).UpdRepFile("2^2018-01-16^归档")
ClassMethod UpdRepFile(FILERowID, RepID, RepTypeDr, flag) As %String
{
	N (FILERowID,RepID,RepTypeDr,flag)
	&SQL(Update DHC_AdvRepFile Set FILE_IfFile=:flag WHERE FILE_RowID=:FILERowID)
 	Q SQLCODE
}

ClassMethod GetParams(params)
{
	n (params)
	s HospID = $P(params,"^",1)
	s LocID = $P(params,"^",2)
	s GroupID = $P(params,"^",3)
	s UserID = $P(params,"^",4)
	s RepTypeDr = $o(^DHCMEDADREVT(0,"Code","NURSINGREP",""))
	q:+RepTypeDr=0 ""
	s ShowStat = ""
	i ShowStat = "" d
	.i $d(^DHCADVQUS(0,"RepType",RepTypeDr,1,GroupID)) d
	..s AdvqsID = $o(^DHCADVQUS(0,"RepType",RepTypeDr,1,GroupID,""))
	..S SecFlagID=$p(^DHCADVQUS(AdvqsID),"^",4) //权限
	..S SecFlag=$S(SecFlagID="1":"仅自己",SecFlagID="2":"仅本科室",SecFlagID="3":"全院",1:"")
	..q:SecFlag'="全院"
	..s ShowStat=1
	i ShowStat = "" d
	.i $d(^DHCADVQUS(0,"RepType",RepTypeDr,2,LocID)) d
	..s AdvqsID = $o(^DHCADVQUS(0,"RepType",RepTypeDr,2,LocID,""))
	..S SecFlagID=$p(^DHCADVQUS(AdvqsID),"^",4) //权限
	..S SecFlag=$S(SecFlagID="1":"仅自己",SecFlagID="2":"仅本科室",SecFlagID="3":"全院",1:"")
	..q:SecFlag'="全院"
	..s ShowStat=1
	i ShowStat = "" d
	.i $d(^DHCADVQUS(0,"RepType",RepTypeDr,3,UserID)) d
	..s AdvqsID = $o(^DHCADVQUS(0,"RepType",RepTypeDr,3,UserID,""))
	..S SecFlagID=$p(^DHCADVQUS(AdvqsID),"^",4) //权限
	..S SecFlag=$S(SecFlagID="1":"仅自己",SecFlagID="2":"仅本科室",SecFlagID="3":"全院",1:"")
	..q:SecFlag'="全院"
	..s ShowStat=1
	q ShowStat
}

/// Description: 不良反应报告接收
/// Creator:     CongYue
/// CreateDate:  2016-03-09
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0  接收成功
/// Others:		 w ##class(web.DHCADVCOMMONPART).REMataReport("12^600^63^126^^^N^blood")
ClassMethod REMataReport(params As %String, LgParam As %String = "") As %String
{
	N (params, LgParam)
	S ListData = ..REceiveReport(params, LgParam)
	S ListTitle="ErrCode^ErrMsg"
	W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Description: 不良反应报告接收
/// Creator:     CongYue
/// CreateDate:  2015-11-16
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码^报告状态id
/// Return: 	 0  接收成功
/// Others:		 w ##class(web.DHCADVCOMMONPART).REceiveReport("86^10||5^4636^197^25^^^未接收^advWallLeakage")
ClassMethod REceiveReport(params As %String, LgParam As %String = "") As %String
{
	
	N (params,LgParam)
	S ID=+$p(params,"^",1)       //不良反应报告ID
	S medadrStatusDR=$p(params,"^",2)  //审核状态
	S medadrAuditUserDR=+$p(params,"^",3)     //用户ID
	S LgCtLocID=+$p(params,"^",4)     //科室ID
	S LgGroupID=+$p(params,"^",5)     //安全组ID
	S medadrNextLocDR=$p(params,"^",6)
	S medadrLocAdvice=$p(params,"^",7)
	S medadrReceive=$p(params,"^",8)
	Q:medadrReceive="1" "-1^已接收"
	S medadrReceive="1"
	
	S medadrAuditDate=+$h
	S medadrAuditTime=$p($h,",",2)
	S typecode=$p(params,"^",9) // 报告类型代码
	S medadrRecProgress=$p(params,"^",10) //调查核实
	S eventDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(typecode),"")) //报告类型id
	S eventparref="",eventsub="" ;2018-08-29
	I eventDr=""  D
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") eventDr=eventparref_"||"_eventsub
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",eventDr,ID,""),-1)
	S NextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（被指向的审批科室）
	Q:(NextLocDR'="")&&(NextLocDR'="0")&&(LgCtLocID'=NextLocDR) "-8^当前登录科室无接收权限，不能接收"
	
	S list=medadrAuditUserDR_"^"_LgCtLocID_"^"_LgGroupID
	S Listt=ID_"^"_eventDr_"^"_list
	
	S StatusNextID=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,"",LgParam)
	Q:StatusNextID="-1" "-1^无权限"
	Q:StatusNextID="-2" "-2^已是最后一个权限"
	Q:StatusNextID="-3" "-3^无授权工作流"
	Q:StatusNextID="-4" "-4^无配置子项"
	S medadrRetReason="",RevStatus="",RepCancelFlag="",TimeOutFlag="",RepCancelFlag=""
	TS
	S matadrRepAuditList=medadrStatusDR_"^"_list_"^"_medadrNextLocDR_"^"_medadrLocAdvice_"^"_medadrReceive_"^"_eventDr_"^"_medadrRetReason_"^"_RevStatus_"^"_TimeOutFlag_"^"_RepCancelFlag_"^"_medadrRecProgress
	S retVal=##class(web.DHCADVCOMMON).InsRepAudit(ID,matadrRepAuditList)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	
	TC
	
	Q 0
}

/// Descript:安贞统计用于描述名称改变
/// Creator:qqa
ClassMethod GetReportEasyName(Text)
{
	n (Text)
	;s Text = $Replace(Text,"压疮报告单","压疮")
	;s Text = $Replace(Text,"跌倒(坠床)事件报告单","跌倒坠床")
	;s Text = $Replace(Text,"管路滑脱报告单","管路滑脱")
	;s Text = $Replace(Text,"用药错误报告单","用药错误")
	;s Text = $Replace(Text,"意外事件报告单","意外事件")
	;s Text = $Replace(Text,"一次性医疗用品不良事件报告单","一次性医疗用品")
	;s Text = $Replace(Text,"医疗护理风险防范(堵漏/隐患)事件报告单","隐患事件")
	q Text
}

/// Description: 判断大科是否有查看权限
/// Creator:     CongYue
/// CreateDate:  2019-05-27  
/// Table:		 DHC_AdvSecuGroupUserWard
/// Input:   	 登录人id , 登录科室id
/// Output:  	 flag 0 无权限  1 有权限 (组长有管理组员负责科室病区的权限)
/// Others:		 w ##class(web.DHCADVCOMMONPART).QuerySecuGroup("12177","114","12177","144")
ClassMethod QuerySecuGroup(UserId, LocId, RepUser, RepLoc, HospId = "") As %String
{
	N (UserId,LocId,RepUser,RepLoc,HospId)
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdvSecuGroup",HospId)  ///2021-06-18 cy 多院区业务改造
	S AdvSecuGrpDrList="",WardId=""	
	S:+LocId'=0 WardId=$o(^PAWARD(0,"WARD_LocationDR",LocId,""))
	S RepWardId=""
	S:+RepLoc'=0 RepWardId=$o(^PAWARD(0,"WARD_LocationDR",RepLoc,""))

	S SecGrpDr=""
	F  S SecGrpDr=$o(^DHCADVSECUG(SecGrpDr)) Q:SecGrpDr=""  D
	.Q:+SecGrpDr=0
	.S SecGrpActFlag=$p(^DHCADVSECUG(SecGrpDr),"^",4)
	.Q:SecGrpActFlag="N"
	.S SecGrpHosp=$p(^DHCADVSECUG(SecGrpDr),"^",3)
	.Q:(HospIdGroup'="")&&(SecGrpHosp'="")&&(SecGrpHosp'=HospIdGroup)
	.S SecuUserGrpDr=$o(^DHCADVSECUGU(0,"GroupUser",SecGrpDr,+UserId,""))
	.S SecuLeadFlag=""
	.S:SecuUserGrpDr'="" SecuLeadFlag=$p(^DHCADVSECUGU(SecuUserGrpDr),"^",3)
	.S SecuUser="",SecFlag=""
	.F  S SecuUser=$o(^DHCADVSECUGU(0,"GroupUser",SecGrpDr,SecuUser)) Q:SecuUser=""  D
	..Q:+SecuUser=0
	..Q:(SecuLeadFlag'="Y")&&(SecuUser'=UserId)
	..I (((RepWardId'="")&&($d(^DHCADVSECUGUW(0,"GroupUserWard",SecGrpDr,SecuUser,RepWardId))))||(RepWardId=""))&&(((SecuLeadFlag'="Y")&&(((WardId'="")&&($d(^DHCADVSECUGUW(0,"GroupUserWard",SecGrpDr,SecuUser,WardId))))||(WardId="")))||(SecuLeadFlag="Y"))  D
	...Q:SecFlag=SecGrpDr
	...S SecFlag=SecGrpDr
	...I AdvSecuGrpDrList=""  D
	....S AdvSecuGrpDrList=SecGrpDr
	...E  D
	....S AdvSecuGrpDrList=AdvSecuGrpDrList_","_SecGrpDr
	..I (((RepLoc'="")&&($d(^DHCADVSECUGUL(0,"GroupUserLoc",SecGrpDr,SecuUser,RepLoc))))||(RepLoc=""))&&(((SecuLeadFlag'="Y")&&($d(^DHCADVSECUGUL(0,"GroupUserLoc",SecGrpDr,SecuUser,LocId))))||(SecuLeadFlag="Y"))  D
	...Q:SecFlag=SecGrpDr
	...S SecFlag=SecGrpDr
	...I AdvSecuGrpDrList=""  D
	....S AdvSecuGrpDrList=SecGrpDr
	...E  D
	....S AdvSecuGrpDrList=AdvSecuGrpDrList_","_SecGrpDr
	
	Q AdvSecuGrpDrList
}

/// Description: 判断大科是否有查看权限
/// Creator:     CongYue
/// CreateDate:  2019-05-27  
/// Table:		 DHC_AdvSecuGroupUserWard
/// Input:   	 报告类型id , 登录人id , 登录科室id , 报告人id , 报告科室id 
/// Output:  	 flag 0 无权限  1 有权限  RepType,UserID,LocID,RepUser,RepLoc
/// Others:		 w ##class(web.DHCADVCOMMONPART).ChkSecuGroup(87,"4636","193","4636","197")
ClassMethod ChkSecuGroup(RepType, UserID, LocID, RepUser, RepLoc, HospID = "") As %String
{
	N (RepType,UserID,LocID,RepUser,RepLoc,HospID)
	//科室权限
	S AdvSecuGrpDrList=..QuerySecuGroup(UserID,LocID,RepUser,RepLoc,HospID)
	S HospIDGroup=""
	S:HospID'="" HospIDGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdvQuerySec",HospID)  ///2021-06-18 cy 多院区业务改造

	S SecFlagID=""
	S flag=0
	S len=$L(AdvSecuGrpDrList,",")
	F i=1:1:len Q:flag'="0"  D
	.S AdvSecuGrpDr=$p(AdvSecuGrpDrList,",",i)
	.Q:AdvSecuGrpDr=""
	.//科室权限
	.S AdvqsID=$o(^DHCADVQUS(0,"HospRepType",HospIDGroup,RepType,5,AdvSecuGrpDr,""))
	.Q:AdvqsID=""
	.S SecFlagID=$p(^DHCADVQUS(AdvqsID),"^",4) //权限
	.S:(SecFlagID="1")&&(UserID=RepUser) flag=1
	.S:(SecFlagID="2") flag=1
	.S:(SecFlagID="3") flag=1
	.Q:flag'="0"
	
	Q flag
}

/*ClassMethod ChkSecuGrpForWorFlow(UserID, LocID, GroupID, AdrewRowID, WorkFlag, HospId = "") As %String
{
	n (UserID, LocID,GroupID, AdrewRowID,WorkFlag,HospId)
	//科室权限
	S AdvSecuGrpDrList=..QuerySecuGroup(UserID,LocID,"","",HospId)
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdrWorkFlowGrant",HospId)  ///2021-06-18 cy 多院区业务改造
	S WorkGrID=""
	S len=$L(AdvSecuGrpDrList,",")
	F i=1:1:len Q:WorkGrID'=""  D
	.S AdvSecuGrpDr=$p(AdvSecuGrpDrList,",",i)
	.Q:AdvSecuGrpDr=""
	.//科室权限
	.S Sub=$o(^DHCADREVTWFGR(0,"TypePointer",5,AdvSecuGrpDr,WorkFlag,AdrewRowID,""))
	.S WFGHospID=""
	.S:+Sub'="0" WFGHospID=$p(^DHCADREVTWFGR(Sub),"^",5)
	.Q:(WFGHospID'="")&&(HospIdGroup'="")&&(WFGHospID'=HospIdGroup)
	.S:Sub'="" WorkGrID=Sub
	.Q:WorkGrID'=""
	Q WorkGrID
}*/
/// Description: 判断大科是否有审核权限
/// Creator:     CongYue
/// CreateDate:  2019-05-27  
/// Table:		 DHC_AdvSecuGroupUserWard
/// Input:   	 登录人id , 登录科室id , 安全组id , 工作流id/工作流项目id , WorkFlag :1 工作流 / 2 工作流项目
/// Output:  	 WorkGrID 空 无权限  非空 有权限 
/// Others:		 w ##class(web.DHCADVCOMMONPART).ChkSecuGrpForWorFlow("4636","194","","23||1","2",2)
/// Description: 判断大科是否有审核权限
/// Creator:     CongYue
/// CreateDate:  2019-05-27  
/// Table:		 DHC_AdvSecuGroupUserWard
/// Input:   	 登录人id , 登录科室id , 安全组id , 工作流id/工作流项目id , WorkFlag :1 工作流 / 2 工作流项目
/// Output:  	 WorkGrID 空 无权限  非空 有权限 
/// Others:		 w ##class(web.DHCADVCOMMONPART).ChkSecuGrpForWorFlow("4636","194","","23||1","2","2")
ClassMethod ChkSecuGrpForWorFlow(UserID, LocID, GroupID, AdrewRowID, WorkFlag, HospId = "") As %String
{
	N (UserID, LocID,GroupID, AdrewRowID,WorkFlag,HospId)
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdrWorkFlowGrant",HospId)  ///2021-06-18 cy 多院区业务改造
	
	S WardId=""	
	S:+LocID'=0 WardId=$o(^PAWARD(0,"WARD_LocationDR",LocID,""))
	
	S WorkGrID="",WFGrID=""
	S SecGrpDr=""
	F  S SecGrpDr=$o(^DHCADVSECUGU(0,"GroupUser",SecGrpDr)) Q:(SecGrpDr="")||(WorkGrID'="")  D
	.Q:+SecGrpDr=0
	.S SecGrpActFlag=$p(^DHCADVSECUG(SecGrpDr),"^",4)
	.Q:SecGrpActFlag="N"
	.S WFGrID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,5,SecGrpDr,WorkFlag,AdrewRowID,"")) 
	.Q:WFGrID=""
	.S SecuUserGrpDr=$o(^DHCADVSECUGU(0,"GroupUser",SecGrpDr,+UserID,""))
	.S SecuLeadFlag=""
	.S:SecuUserGrpDr'="" SecuLeadFlag=$p(^DHCADVSECUGU(SecuUserGrpDr),"^",3)
	.S SecuUser="",SecFlag=""
	.F  S SecuUser=$o(^DHCADVSECUGU(0,"GroupUser",SecGrpDr,SecuUser)) Q:(SecuUser="")||(WorkGrID'="")  D
	..Q:+SecuUser=0
	..Q:(SecuLeadFlag'="Y")&&(SecuUser'=UserID)
	..S:((WardId'="")&&($D(^DHCADVSECUGUW(0,"GroupUserWard",SecGrpDr,SecuUser,WardId))))||(WardId="") WorkGrID=WFGrID 
	..S:((LocID'="")&&($D(^DHCADVSECUGUL(0,"GroupUserLoc",SecGrpDr,SecuUser,LocID))))||(LocID="") WorkGrID=WFGrID 
	..Q:WorkGrID'=""

	Q WorkGrID
}

/// Description: 事件类型
/// Creator:     CongYue
/// CreateDate:  2019-06-10  
/// Table:		 DHC_MedAdrRepEvent ，DHC_MedAdrRepEventItm
/// Output:  	 事件类型描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryEventCommbox("院")
ClassMethod QueryEventCommbox(q, HospDr = "") As %String
{
	N (q,HospDr)
	S count=0
	W "["
	S EventDr=""
	F  S EventDr=$o(^DHCMEDADREVT(EventDr)) Q:EventDr=""  D
	.Q:+EventDr=0
	.S EventCode=$p(^DHCMEDADREVT(EventDr),"^",1)
	.Q:(##class(web.DHCADVFormName).CheckFormName(EventCode,HospDr)'=1)
	.S EventDesc=$p(^DHCMEDADREVT(EventDr),"^",2)
	.S Active=$p(^DHCMEDADREVT(EventDr),"^",3) //是否可用
	.Q:Active="N"
	.S tmp=EventDr_"^"_EventDesc
	.S CH=""
	.F  S CH=$o(^DHCMEDADREVTI(EventDr,"MADREVI",CH)) Q:CH=""  D
	..S Code=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",1) //代码
	..Q:(##class(web.DHCADVFormName).CheckFormName(Code,HospDr)'=1)
	..S Desc=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",2) //描述
	..S Active=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",3) //是否可用
	..S Levelrowid=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",5) //上一级别的rowid
	..Q:Active="N"
	..Q:EventDr'=Levelrowid  ; 入参与父元素指向id不相等则退出
	..S ListData=EventDr_"||"_CH_"^"_EventDesc_"-"_Desc
	..s count=..GetEventItm(EventDr_"||"_CH,count,EventDesc_"-"_Desc,q,HospDr)
	..Q:(q'="")&&(EventDesc_"-"_Desc'[q)
	..S count = count+1
	..I count=1 D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",ListData)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",ListData)
	.Q:(q'="")&&(EventDesc'[q)
	.S count = count+1
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)	
	
	
	W "]"
	Q ""
}

/// Description: 事件子类型数据
/// Creator:     CongYue
/// CreateDate:  2019-06-11  
/// Table:		 DHC_MedAdrRepEventItm
/// Output:  	 事件子类型数据 
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryEventItm()
ClassMethod GetEventItm(ParentID, count, ParentDesc, q, HospDr = "") As %String
{
	n (ParentID,count,ParentDesc,q,HospDr)
	S Parref=""
	F  S Parref=$o(^DHCMEDADREVTI(0,"ItmLevelDr",ParentID,Parref)) Q:Parref=""  D
	.Q:+Parref=0
	.S SubID=""
	.F  S SubID=$o(^DHCMEDADREVTI(0,"ItmLevelDr",ParentID,Parref,SubID)) Q:SubID=""  D
	..Q:+SubID=0
	..S SubCode=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",1)  //代码
	..Q:(##class(web.DHCADVFormName).CheckFormName(SubCode,HospDr)'=1)
	..S SubDesc=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",2)  //描述
	..S SubLevelrowid=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",5) //上一级别的rowid
	..S SubActive=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",3) //是否可用
	..Q:ParentID'=SubLevelrowid  ; 入参与父元素指向id不相等则退出
	..Q:SubActive="N"
	..S SubListData=Parref_"||"_SubID_"^"_ParentDesc_"-"_SubDesc
	..Q:(q'="")&&(ParentDesc_"-"_SubDesc'[q)
	..S count = count+1
	..I count=1 D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",SubListData)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",SubListData)
	..d ..GetEventItm(Parref_"||"_SubID,count,ParentDesc_"-"_SubDesc,q,HospDr)
	Q count
}

/// Description: 获取子事件类型描述
/// Creator:     CongYue
/// CreateDate:  2019-06-11  
/// Table:		 DHC_MedAdrRepEvent ， DHC_MedAdrRepEventItm
/// Input:  	 DataList: 以字符"^"分割,格式为:代码^描述
/// Output:  	 事件类型描述--》  父元素-子元素-子元素 
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetEventDesc("87||10","")
ClassMethod GetEventDesc(SubTypeDr, SubTypeDesc, HospDr = "") As %String
{
	n (SubTypeDr,SubTypeDesc,HospDr)
	S ParrentType=""
	Q:SubTypeDr'["||" ParrentType
	S Parref=+SubTypeDr
	S Sub=$p(SubTypeDr,"||",2)
	S SubCode=$p(^DHCMEDADREVTI(Parref,"MADREVI",Sub),"^",1)  // 代码
	Q:##class(web.DHCADVFormName).CheckFormName(SubCode,HospDr)'=1 ParrentType
	S SubDesc=$p(^DHCMEDADREVTI(Parref,"MADREVI",Sub),"^",2)  //描述
	S Levelrowid=$p(^DHCMEDADREVTI(Parref,"MADREVI",Sub),"^",5) //上一级别的rowid
	S:(Levelrowid'="")&&(Levelrowid'["||") ParrentType=$p(^DHCMEDADREVT(Levelrowid),"^",2)
	S:(Levelrowid'="")&&(Levelrowid["||") ParrentType=##class(web.DHCADVCOMMONPART).GetEventDesc(Levelrowid,SubDesc,HospDr)
	I ParrentType=""  D
	.S ParrentType=SubDesc
	E  D
	.S ParrentType=ParrentType_"-"_SubDesc
	
	Q ParrentType
}

/// Description: 不良事件全部月统计
/// Creator:     yguoguomin
/// CreateDate:  2018-08-18
/// Input:  	 开始日期^结束日期^报告类型"
/// Output:   	 月份^数量^总数量
/// Others:		 w ##class(web.DHCADVCOMMONPART).StatAllRepByLocMon("2018-01-01^2019-11-30^")
ClassMethod StatAllRepByLocMon(StrParam As %String, LgParam As %String) As %String
{
	N (StrParam,%session,LgParam)
	S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
	d ..killTmpGlobal(pid) //k掉临时global
	q:StrParam=""
	S Year=$p(StrParam,"^",1)    //开始日期
	s RepLocStr=$p(StrParam,"^",2)    //上报科室
    S matadrDataList=""
	S StDate=$zdh(Year_"-01-01",3)
	S EndDate=$zdh(Year_"-12-31",3)
	Q:StDate="" 
	
	s UserId=$p(LgParam,"^",1)
	s LocId=$p(LgParam,"^",2)
	s GroupId=$p(LgParam,"^",3)
	s HospId=$p(LgParam,"^",4) //hxy 2020-02-26 st
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",LgParam)
	S:QUERYDATE="1" DateNode="OccurDate"
	s count=0
	s countmon=0
	s Num=1
	s matadrDataList=""
	s matadrDataListStr=""
	s YearDate=""
	f date=StDate:1:EndDate d
	.s RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) q:RepID=""  d
	..S RepTypeCode="",RepTypeDr="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",MedadrReceive="未接收",MedadrReceivedr=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1) //表单id
	..Q:recordID=""
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2) //报告类型id
	..S:RepTypeDr'="" RepTypeCode=$p($g(^DHCMEDADREVT(RepTypeDr)),"^",1)
	..S:RepTypeDr'="" RepType=$p($g(^DHCMEDADREVT(RepTypeDr)),"^",2) //报告类型描述
	..Q:(RepTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(RepTypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3) //报告状态ID	
	..Q:RepStausDr=""  //过滤未提交的报告
	..s ChildSub=$p(RepStausDr,"||",2)
	..s Parref=$p(RepStausDr,"||",1)
	..s RepStausDesc=$p($g(^DHCADREVTWFI(Parref,"ADREWI",ChildSub)),"^",2)
	..;q:RepStausDesc'="结案"
	..S RepCancelflag=""
    ..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S:MedadrID'="" RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	..Q:RepCancelflag="Y"
	..;S status="Y"
	..;S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1) ;b
	..I MedadrID'=""  D
	...S MedadrReceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) //接收状态
	...i $g(MedadrReceivedr)="" s MedadrReceivedr="未接收"
	...S MedadrReceive=$S(MedadrReceivedr="未接收":"未接收",MedadrReceivedr="1":"接收",MedadrReceivedr="2":"驳回",1:"")
	...;S:MedadrReceive'="" RepStaus=RepStaus_"："_MedadrReceive
	..S RepDate=$p(^DHCADVMASTER(RepID),"^",4)  //报告日期
	..S:RepDate'="" RepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	..S RepTime=$p(^DHCADVMASTER(RepID),"^",5) /// 	报告时间
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)  /// 	上报人
	..S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7) /// 	上报科室
	..s RepHospID="" //hxy 2020-02-26 st
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(HospId'="")&(HospId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..q:((RepLocStr'="")&&(RepLocStr'=RepLocDr))
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..S RepSubType=$p(^DHCADVMASTER(RepID),"^",8)  /// 	报告类型子类描述
	..S RepImpFlag=$p(^DHCADVMASTER(RepID),"^",9) /// 	重点标记
	..S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..S CaseShareflag=..GetCaseFlag(RepID,RepTypeDr,LocId,UserId)
	..Q:((flag'="")&&(flag'=1))&&(CaseShareflag'="Y")	
	..S DateFormat = ##class(websys.Conversions).DateFormat()
	..S YearDate="" ,MonthDate=""
	..I DateFormat="1"  D //MDY
	...I RepDate["/" S YearDate=$p(RepDate,"/",3) //以"-"截取字符，获取年份
	...I RepDate["/" S MonthDate=$p(RepDate,"/",1) //以"-"截取字符，获取月份
	..I DateFormat="3"  D  //YMD
	...I RepDate["-" S YearDate=$p(RepDate,"-",1) //以"-"截取字符，获取年份
	...I RepDate["-" S MonthDate=$p(RepDate,"-",2) //以"-"截取字符，获取月份
    ..I DateFormat="4"  D  //DMY
	...I RepDate["/" S YearDate=$p(RepDate,"/",3) //以"-"截取字符，获取年份
	...I RepDate["/" S MonthDate=$p(RepDate,"/",2) //以"-"截取字符，获取月份
	..i $d(^TMP("DHCADV","web.DHCADVEXPBYMON","getExportByMonInfo",pid,"A",RepLoc))  d
	..E  d
	...S ^TMP("DHCADV","web.DHCADVEXPBYMON","getExportByMonInfo",pid,"A",RepLoc)=""
	..i $d(^TMP("DHCADV","web.DHCADVEXPBYMON","getExportByMonInfo",pid,+YearDate,+MonthDate,RepLoc))  d
	...S $p(^TMP("DHCADV","web.DHCADVEXPBYMON","getExportByMonInfo",pid,+YearDate,+MonthDate,RepLoc),"^",5)=$p(^TMP("DHCADV","web.DHCADVEXPBYMON","getExportByMonInfo",pid,+YearDate,+MonthDate,RepLoc),"^",5)+1
	..E  d
	...S ^TMP("DHCADV","web.DHCADVEXPBYMON","getExportByMonInfo",pid,+YearDate,+MonthDate,RepLoc)=+YearDate_"^"_+MonthDate_"^"_RepLoc_"^"_"报告数量"_"^"_Num	
	s year=""
	s month=""
	s RepLoc=""
	s reploc=""
	s replocstr=""
	s reploccount=0
	s countlocnum=0
	s replocmoninfo=""
	s replocmoninfostr=""
	s oneTotNum=0,twoTotNum=0,threetotNum=0,fourTotNum=0,fiveTotNum=0,sixTotNum=0
	s sevenTotNum=0,eightTotNum=0,nineTotNum=0,tenTotNum=0,elevTotNum=0,twelTotNum=0
	s SpTotNum=0,SuTotNum=0,AutotNum=0,WinTotNum=0,TotInfoStrArr=""
	s year=YearDate

	f  s reploc=$o(^TMP("DHCADV","web.DHCADVEXPBYMON","getExportByMonInfo",pid,"A",reploc)) q:reploc=""  d
	.s reploccount=reploccount+1
	.i reploccount=1 d
	..s replocstr=reploc
	.e  d
	..s replocstr=replocstr_"^"_reploc
	s a=$l(replocstr,"^")
	s b=a+1
	f i=1:1:a  q:(i>a)  d
	.s countlocnum=countlocnum+1
	.s repLoc=""
	.i i<=(b-1) d
	..s repLoc=$p(replocstr,"^",i)
	..S repLoc=##class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",repLoc)
    .i i=b d
    ..s repLoc="合计"
	.q:repLoc=""
	.f month=1:1:12  q:(month>12)  d
	..s countmon=countmon+1
	..i (year'="")&&($d(^TMP("DHCADV","web.DHCADVEXPBYMON","getExportByMonInfo",pid,year,month,repLoc)))  d 
	...s mdate=$p($g(^TMP("DHCADV","web.DHCADVEXPBYMON","getExportByMonInfo",pid,year,month,repLoc)),"^",5)
	...i month=1  d
	....s replocmoninfo=repLoc_"^"_mdate
	...e  d
	....s replocmoninfo=replocmoninfo_"^"_mdate
	..e  d
	...i month=1  d
	....s replocmoninfo=repLoc_"^"_0
	...e  d
	....s replocmoninfo=replocmoninfo_"^"_0
	.i countlocnum=1  d
	..s replocmoninfostr=replocmoninfo
	.e  d
	..s replocmoninfostr=replocmoninfostr_"@@"_replocmoninfo

	s length=$l(replocmoninfostr,"@@")
	f i=1:1:length  q:(i>length)  d
	.s dataInfoStr=$p(replocmoninfostr,"@@",i)
	.s sublength=$p(dataInfoStr,"^")
	.s oneTotNum=oneTotNum+$p(dataInfoStr,"^",2)
	.s twoTotNum=twoTotNum+$p(dataInfoStr,"^",3)
	.s threetotNum=threetotNum+$p(dataInfoStr,"^",4)
	.s fourTotNum=fourTotNum+$p(dataInfoStr,"^",5)
	.s fiveTotNum=fiveTotNum+$p(dataInfoStr,"^",6)
	.s sixTotNum=sixTotNum+$p(dataInfoStr,"^",7)
	.s sevenTotNum=sevenTotNum+$p(dataInfoStr,"^",8)
	.s eightTotNum=eightTotNum+$p(dataInfoStr,"^",9)
	.s nineTotNum=nineTotNum+$p(dataInfoStr,"^",10)
	.s tenTotNum=tenTotNum+$p(dataInfoStr,"^",11)
	.s elevTotNum=elevTotNum+$p(dataInfoStr,"^",12)
	.s twelTotNum=twelTotNum+$p(dataInfoStr,"^",13)
	.s SpTotNum=SpTotNum+$p(dataInfoStr,"^",2)+$p(dataInfoStr,"^",3)+$p(dataInfoStr,"^",4)
	.s SuTotNum=SuTotNum+$p(dataInfoStr,"^",5)+$p(dataInfoStr,"^",6)+$p(dataInfoStr,"^",7)
    .s AutotNum=AutotNum+$p(dataInfoStr,"^",8)+$p(dataInfoStr,"^",9)+$p(dataInfoStr,"^",10)
    .s WinTotNum=WinTotNum+$p(dataInfoStr,"^",11)+$p(dataInfoStr,"^",12)+$p(dataInfoStr,"^",13)
	s TotInfoStrArr="合计"_"^"_oneTotNum_"^"_twoTotNum_"^"_threetotNum_"^"_fourTotNum_"^"_fiveTotNum_"^"_sixTotNum_"^"_sevenTotNum_"^"_eightTotNum_"^"_nineTotNum_"^"_tenTotNum_"^"_elevTotNum_"^"_twelTotNum
	i replocmoninfostr'=""  d
	.s replocmoninfostr=replocmoninfostr_"@@"_TotInfoStrArr
	e  d
	.s replocmoninfostr=TotInfoStrArr
	
	d ..killTmpGlobal(pid) //k掉临时global
	d ..StringToJson(replocmoninfostr)
	;q replocmoninfostr
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCADV","web.DHCADVEXPBYMON","getExportByMonInfo",pid)
}

/// 字符串转json
/// guoguomin
ClassMethod StringToJson(Param As %String) As %String
{
	N (Param)
	s replocmoninfostr=Param
	w "{""rows"":["
	s length=$l(replocmoninfostr,"@@")
	f i=1:1:length  q:(i>length)  d
	.s dataInfoStr=$p(replocmoninfostr,"@@",i)
	.s sublength=$p(dataInfoStr,"^")
	
	
	.w $case(i,1:"",:",")
	.s tmpObj={}
	
	.s tmpObj.locName=$p(dataInfoStr,"^",1)
	.s tmpObj.oneMonNum=$p(dataInfoStr,"^",2)
	.s tmpObj.TwoMonNum=$p(dataInfoStr,"^",3)
	.s tmpObj.ThreeMonNum=$p(dataInfoStr,"^",4)
	.s tmpObj.FourMonNum=$p(dataInfoStr,"^",5)
	.s tmpObj.FiveMonNum=$p(dataInfoStr,"^",6)
	.s tmpObj.SixMonNum=$p(dataInfoStr,"^",7)
	.s tmpObj.SevenMonNum=$p(dataInfoStr,"^",8)
	.s tmpObj.EightMonNum=$p(dataInfoStr,"^",9)
	.s tmpObj.NineMonNum=$p(dataInfoStr,"^",10)
	.s tmpObj.TenMonNum=$p(dataInfoStr,"^",11)
	.s tmpObj.ElevenMonNum=$p(dataInfoStr,"^",12)
	.s tmpObj.TwelveMonNum=$p(dataInfoStr,"^",13)
	.s tmpObj.SpringMonNum=$p(dataInfoStr,"^",2)+$p(dataInfoStr,"^",3)+$p(dataInfoStr,"^",4)
	.s tmpObj.SummerMonNum=$p(dataInfoStr,"^",5)+$p(dataInfoStr,"^",6)+$p(dataInfoStr,"^",7)
	.s tmpObj.AutumnMonNum=$p(dataInfoStr,"^",8)+$p(dataInfoStr,"^",9)+$p(dataInfoStr,"^",10)
	.s tmpObj.WinterMonNum=$p(dataInfoStr,"^",11)+$p(dataInfoStr,"^",12)+$p(dataInfoStr,"^",13)
	.s tmpObj.TotleNum=tmpObj.SpringMonNum+tmpObj.SummerMonNum+tmpObj.AutumnMonNum+tmpObj.WinterMonNum
	.w tmpObj.%ToJSON()
	w "],""total"":"_length_"}"
}

/// Description: 不良事件报告数据基本信息查询 
/// Creator:     CongYue
/// CreateDate:  2019-11-05
/// Input:  	 RepID : 报告id
/// Table:       
/// Return: 	 报告时间 报告状态
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetRepBasicInfo("8")
ClassMethod GetRepBasicInfo(RepID)
{
	N (RepID)

	Q:RepID="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	S:RepTime'="" RepTime=$zt(RepTime,2)
	S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	S RepStaus=""
	S:RepStausDr'="" RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	S OrderList=##class(web.DHCADVCOMMONPART).GetOrdList(RepID,"Order") ;2021-02-09 cy 新增医嘱串信息
	

	s tmpObj={}
	s tmpObj.RepTime=RepTime
	s tmpObj.RepStaus=RepStaus
	s tmpObj.OrderList=OrderList
	W tmpObj.%ToJSON()
	Q ""
}

/// Description: 不良事件报告登录人信息查询 
/// Creator:     CongYue
/// CreateDate:  2019-11-05
/// Input:  	 UserID : 登录人id
/// Table:       
/// Return: 	 报告人职称
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetRepUserInfo("8")
ClassMethod GetRepUserInfo(UserID, LocID, HospID, GroupID = "")
{
	N (UserID,LocID,HospID,GroupID,%session)

	Q:UserID="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S UserCPDR="",CTCptDR="",CTCptDesc="",User=""
	S:+UserID'=0 User=$p(^SSU("SSUSR",UserID),"^",2) 
	S User=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",User)
	S:+UserID'=0 UserCPDR=$p(^SSU("SSUSR",UserID),"^",14) 
	S:+UserCPDR'=0 CTCptDR=$p(^CTPCP(UserCPDR,1),"^",4 )
	S:+CTCptDR'=0 CTCptDesc=$p(^CT("CPT",CTCptDR),"^",2)   ;职称
	S CTCptDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",CTCptDesc)
	S LocDesc="",HospDesc="",GroupDesc=""
	S:+LocID'=0 LocDesc=$p(^CTLOC(LocID),"^",2) 
	S LocDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)

	S:+HospID'=0 HospDesc=$p(^CT("HOSP",HospID),"^",2)  
	S HospDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.CTHospital","HOSPDesc","",HospDesc)
	S:+GroupID'=0 GroupDesc=$p(^SSU("SSGRP",GroupID),"^",1)  
	S GroupDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.SSGroup","SSGRPDesc","",GroupDesc)

	s tmpObj={}
	s tmpObj.CTCptDesc=CTCptDesc
	s tmpObj.User=User
	s tmpObj.LocDesc=LocDesc
	s tmpObj.HospDesc=HospDesc
	s tmpObj.GroupDesc=GroupDesc
	W tmpObj.%ToJSON()
	Q ""
}

/// Description: 首页 获取事件填报类型（根据填报权限）
/// Creator:     CongYue
/// CreateDate:  2019-06-26
/// Table: 		 DHC_AdrEvtWorkFlow DHC_AdrEvtWorkFlowItm DHC_AdrWorkFlowGrant 
/// Input:  	 用户信息
/// Return： 	 报告类型 list
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetRepTypeByWFList("10211^178^111^3")
ClassMethod GetRepTypeByWFList(UserList As %String) As %String
{
	N (UserList,%session)
	S UserId=$p(UserList,"^",1)
	S LocId=$p(UserList,"^",2)
	S GroupId=$p(UserList,"^",3)
	S HospId=$p(UserList,"^",4)
	s ListTitle="id^value"
	S count = 0
	W "["
	S EventDr=""
	F  S EventDr=$o(^DHCMEDADREVT(EventDr))  Q:EventDr=""  D
	.Q:+EventDr=0
	.S EventCode=$p(^DHCMEDADREVT(EventDr),"^",1)
	.S EventDesc=$p(^DHCMEDADREVT(EventDr),"^",2)
	.S EventActiveFlag=$p(^DHCMEDADREVT(EventDr),"^",3)
	.Q:EventActiveFlag="N"	
	.Q:(EventCode'="")&&(##class(web.DHCADVFormName).CheckFormName(EventCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	.S Flag=##class(web.DHCADVCOMMONPART).ChkEvtWFGrant(EventDr,UserList)
	.S CH=""
	.F  S CH=$o(^DHCMEDADREVTI(EventDr,"MADREVI",CH)) Q:CH=""  D
	..S Code=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",1) //代码
	..S Desc=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",2) //描述
	..S Active=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",3) //是否可用
	..Q:Active="N"
	..Q:(Code'="")&&(##class(web.DHCADVFormName).CheckFormName(Code,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S EventItmDr=EventDr_"||"_CH
	..Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(Code)))
	..S WorkFlowFlag=##class(web.DHCADVCOMMONPART).ChkEvtWFGrant(EventItmDr,UserList) 
	..Q:($d(^DHCADREVTWF(0,"Event",EventItmDr))&&(WorkFlowFlag'=1))||((Flag'=1)&&('$d(^DHCADREVTWF(0,"Event",EventItmDr))))
	..S Desc=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEventItm","MADREVIDesc","",Desc)
	..S ListData=Code_"^"_Desc
	..S count = count+1
	..I count=1 D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	.Q:Flag'=1
	.Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(EventCode)))  ;去除不是表单的类型
	.S EventDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEvent","MADREVDesc","",EventDesc)
	.S ListData=EventCode_"^"_EventDesc
	.S count = count+1
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)

	W "]"
	Q ""
}

/// Description: 通过科室ID获取人员列表
/// Creator:     yangyongtao
/// CreateDate:  2019-01-26
/// Table: 		 RB_Resource,CT_CareProv
/// Input:  	 科室ID
/// Output:  
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetLocUserList("6","") 	  
ClassMethod GetLocUserList(LocDr As %String, input As %String)
{
	 N (LocDr,input,%session)
	 S count=0
	 W "["
	 S RESID=""
	 F  S RESID=$o(^RB("RES",0,"CTLOC",LocDr,RESID))  Q:RESID=""  D 
	 .S CareProvDr=$p(^RB("RES",RESID),"^",2)  //职能科室ID
	 .Q:CareProvDr=""
	 .S DateForm=$p(^CTPCP(CareProvDr,2),"^",14)
	 .S DateTo=$p(^CTPCP(CareProvDr,2),"^",15)
	 .Q:((DateTo'="")&&(DateTo<+$H))
	 .S UserCode=$p(^CTPCP(CareProvDr,1),"^",1) //UserCode
	 .S UserDr="",UserName=""
	 .I UserCode'="" s UserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	 .I UserDr'="" s UserName=$p(^SSU("SSUSR",UserDr),"^",2)
	 .S UserName=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",UserName)
	 .Q:UserName=""
	 .Q:(input'="")&&(UserName'[input)
	 .S tmp=UserDr_"^"_UserName
	 .S count = count+1
	 .I count=1 D
	 ..W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	 .E  D
	 ..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	 W "]"
	 Q ""
}

/// Creator:sufan
/// Descript:判断报告是归档状态
/// Input:RepID,RepTypeID
/// Output:一个人归档：1：归档，2：撤销归档;两个人归档：3：归档，4：归档待复核,5:撤销归档
/// w ##Class(web.DHCADVCOMMONPART).JudgeIsOutCome(85,"87||7")
ClassMethod JudgeIsOutCome(RepID, RepTypeDr, LgParam)
{
	n (RepID,RepTypeDr,LgParam)
	s FilePerNum=##class(web.DHCADVCOMMON).GetEmSysConfig("FILETIMES",LgParam)
	s Ret=0,Num=0,FileNum=0
	s FileId="",FlagList="",FileFlag=""
	for  s FileId=$o(^DHCADVFILE(0,"RepDrType",RepID,RepTypeDr,FileId))  Q:FileId=""  d
	.s AuitUserId=$p(^DHCADVFILE(FileId),"^",4)			//归档人
	.s FileFlag=$p(^DHCADVFILE(FileId),"^",3)			//归档标识
	.s FileNum=FileNum+1
	.i FlagList="" s FlagList=FileFlag
	.e  s FlagList=FlagList_FileFlag
	
	i ((FilePerNum=1)||(+FilePerNum="0")) d
	.i FlagList ["01" s Ret=1
	.e  i (FlagList ["11") s Ret=2
	.e  s Ret=0
	i (FilePerNum>1)  d
	.i (FlagList="0102")&&(FileNum=2) s Ret=3
	.i (FlagList="0112")&&(FileNum=2) s Ret=4
	.i (FlagList="1112")&&(FileNum=2) s Ret=5
	.i (FileNum=1)&&(FlagList="01") s Ret=4
	.i (FileNum=1)&&(FlagList="11") s Ret=5
	Q Ret
}

/// Descript:查询归档记录
/// w ##class(web.DHCADVCOMMONPART).QueryFileList("40","1","20","87||6")
ClassMethod QueryFileList(rows = 10, page = 1, RepID, RepTypeID, flag = "")
{
	n (rows,page,RepID,RepTypeID,flag,%session)
	q:(RepID="")||(RepTypeID="") ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S End = page*rows
	S Start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	s count=0
	w "{""rows"":["
	s FileId=""
	for  s FileId=$o(^DHCADVFILE(0,"RepDrType",RepID,RepTypeID,FileId))  Q:FileId=""  d
	.s AuitUserId=$p(^DHCADVFILE(FileId),"^",4)			//归档人
	.s AuitUser=""
	.s:AuitUserId'="" AuitUser=$p(^SSU("SSUSR",AuitUserId),"^",2)
	.s FileFlagCode=$p(^DHCADVFILE(FileId),"^",3)			//归档标识
	.Q:(flag=1)&&(FileFlagCode'="01")
	.Q:(flag=2)&&(FileFlagCode'="02")
	.s FileFlag=$s(FileFlagCode="01":"归档",FileFlagCode="02":"复核",FileFlagCode="11":"撤销归档",FileFlagCode="12":"撤销复核",1:"")
	.s FileDate=$p(^DHCADVFILE(FileId),"^",6)
	.s:FileDate'="" FileDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(FileDate)
	.s FileTime=$p(^DHCADVFILE(FileId),"^",7)
	.s:FileTime'="" FileTime=$zt(FileTime,1)
	.s count=count+1
	.q:count<Start
	.q:count>End
	.s FileFlag=##class(websys.Translation).Get("dhcadv.reportaudit.csp",FileFlag)
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.FileId=FileId
	.s tmpObj.AuitUserId=AuitUserId
	.s tmpObj.AuitUser=AuitUser
	.s tmpObj.FileFlagCode=FileFlagCode
	.s tmpObj.FileFlag=FileFlag
	.s tmpObj.FileDate=FileDate
	.s tmpObj.FileTime=FileTime
	.w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	q ""
}

/// Creator:sufan
/// CreteDate:2019-11-01
/// Descript:获取当前登录人已归档记录Id
/// Input:表单记录ID
/// Return:Y:已填写，N:未填写
/// w ##class(web.DHCADVCOMMONPART).GetFileRecordId(2,"87||3",1)
ClassMethod GetFileRecordId(RepID, RepTypeDr, flag)
{
	n (RepID, RepTypeDr, flag)
	s RetValue=""
	s FileId=""
	for  s FileId=$o(^DHCADVFILE(0,"RepDrType",RepID,RepTypeDr,FileId))  Q:FileId=""  d
	.s AuitUserId=$p(^DHCADVFILE(FileId),"^",4)			//归档人
	.s FileFlag=$p(^DHCADVFILE(FileId),"^",3)			//归档标识
	.Q:(flag=1)&&(FileFlag'=11)
	.Q:(flag=2)&&(FileFlag'=12)
	.s RetValue=FileId
	Q RetValue
}

/// Description: 过滤动态查询条件 
/// Creator:     CongYue
/// CreateDate:  2019-11-21
/// Input:  	 ParStr:列_$c(1)_值_$c(1)_判断条件_$c(1)_逻辑关系 ,RepID:报告ID  , LgParam:登录信息  ,  Type: 1 查询界面  2 审核界面
/// Table:       
/// Return: 	 0 不通过  1 通过
/// Others:		 w ##class(web.DHCADVCOMMONPART).CheckCondition("RepStaus"_$c(1)_"提交"_$c(1)_"="_$c(1)_"and^PatName"_$c(1)_"体温"_$c(1)_"="_$c(1)_"and","94","10209^95^29^2",2)
ClassMethod CheckCondition(ParStr, RepID, LgParam, Type)
{
	n (ParStr,RepID,LgParam,Type)
	q:ParStr="" 1
	S RepTypeDr="",RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",Medadrreceive="",Medadrreceivedr="",StatusNext="",MedadrUserID="",MedadrRevStatus="",StaFistAuditUser="",BackAuditUser="",RepOverTimeflag="",AutOverTimeflag="",RepOverTime="",AutOverTime="",RepCancelflag="",StaFistAuditUserDr="",BackAuditUserDr="",MedadrNextLocDR=""
	S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,RepTypeDr,""))
	S File="",FileFlag=""
	S:FILERowID'="" File=$p(^DHCADVFILE(FILERowID),"^",3)
	s:(File'="Y")||(File'="N") File=..JudgeIsOutCome(RepID,RepTypeDr,LgParam)
	S FileFlag=$S(File="0":"未归档",(File="1")||(File="3"):"已归档",File="4":"归档(待复核)",(File="2")||(File="5"):"撤销归档",File="N":"撤销归档",File="Y":"已归档",1:"")
	S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	I RepStausDr=""  D
	.S RepStaus="未提交"
	E  D
	.S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	S:OccurDate="" OccurDate=0
	S OccurTime=$p(^DHCADVMASTER(RepID),"^",26)  ///发生时间
	S:OccurTime="" OccurTime=0
	S RepOverTime=""
	; 2021-03-26 cy 填写超时程序修改
	;S HolidayDate=##class(web.DHCADVCOMMONPART).CheckTimeEscapeHoliday(OccurDate,OccurTime,RepDate,RepTime)
	;S FillTime=##class(web.DHCADVCOMMON).GetEmSysConfig("FILLTIME",LgParam)  ///填报时限时长
	;I (+FillTime'=0)&&(HolidayDate>FillTime) S RepOverTimeflag="Y"   //填报超时
	S RepOverTimeflag=##class(web.DHCADVCOMMONPART).ChkOverTime(RepID,"FILLTIME",RepDate,RepTime,RepStausDr,LgParam)
	S RepOverTime=$S(RepOverTimeflag="":"未超时",RepOverTimeflag="N":"未超时",RepOverTimeflag="Y":"已超时",1:"")
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	S Subflag=0
	S SubUserflag=0 
	I MedadrID'=""  D
	.S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	.I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	.S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",Medadrreceivedr="3":"撤销",Medadrreceivedr="4":"审核",Medadrreceivedr="5":"归档",Medadrreceivedr="6":"撤销归档",Medadrreceivedr="7":"归档(待复核)",1:"")
	.S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	.S MedadrLocID=$p(^DHCMEDREPADT(MedadrID),"^",12)
	.S MedadrRevStatus=$p(^DHCMEDREPADT(MedadrID),"^",14) ;驳回指向
	.S StaFistAuditDr=""
	.S:(RepTypeDr'="")&&(MedadrRevStatus'="") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(RepID, RepTypeDr, MedadrRevStatus ) ;$o(^DHCMEDREPADT(0,"TypeSta",RepTypeDr,MedadrRevStatus,""))
	.S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	.S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	.S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	.S AutOverTimeflag=$p(^DHCMEDREPADT(MedadrID),"^",15) ;护士长审核超时标志
	.S RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	.S MedadrNextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	S:(Medadrreceive'="")&&(Type="1")&&(RepStausDr'="") RepStaus=RepStaus_"："_Medadrreceive

	S AutOverTime=""
	S AutOverTime=$S(AutOverTimeflag="":"未超时",AutOverTimeflag="N":"未超时",AutOverTimeflag="Y":"已超时",1:"")
	S Medadrflag=##class(web.DHCADVSEARCHREPORT).SearchAuditIMess(MedadrID)
	S:Medadrflag=1 Subflag=1 //转抄 
	S:Medadrflag=2 Subflag=2 //全部回复 
	S:Medadrflag=3 Subflag=3 //部分回复 
	S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	S RepInjSev=$p(^DHCADVMASTER(RepID),"^",13) ///伤害严重度
	;S:RepDate'="" RepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	S RecRepUser=##class(web.DHCADVCOMMONPART).QueryInputDataInfo(recordID,"填报人姓名")  //取匿名信息 sufan 2019-11-07
	S:(RecRepUser["匿名")||(RecRepUser["anonymous") RepUser=RecRepUser
	S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	S RepSubType=$p(^DHCADVMASTER(RepID),"^",8)
	S RepImp=$p(^DHCADVMASTER(RepID),"^",9)
	S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	S AdmID=$p(^DHCADVMASTER(RepID),"^",16)  
	S PatName=$p(^DHCADVMASTER(RepID),"^",17)  
	S AdmNo=$p(^DHCADVMASTER(RepID),"^",20)  ///病案号	
	S OccurLoc=$p(^DHCADVMASTER(RepID),"^",27)  ///发生科室
	S:OccurLoc'="" OccurLoc=$p(^CTLOC(OccurLoc),"^",2)
	S:OccurLoc["-" OccurLoc=$p(OccurLoc,"-",2)
	S:OccurDate="0" OccurDate=""
	;S:(OccurDate'="")&&(OccurDate'="0") OccurDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(OccurDate)
	s PatID=$p(^DHCADVMASTER(RepID),"^",14)  ///登记号
	S PapRowid=""
	S:AdmID'="" PapRowid=$p(^PAADM(AdmID),"^",1)
	S:(AdmID'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(AdmID,"")  //病案号 
	S:(PapRowid'="")&&(PatID="") PatID=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	S:(PapRowid'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",PapRowid)  //病案号
	S:(PapRowid'="")&&(PatName="") PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	S RepShareStatus="未分享"
	S rshShare=$o(^DHCADVRSH(0,"TypePointer",RepTypeDr,RepID,""))
	I rshShare'="" D
	.S RepShareStatus="分享"
	I Subflag=0 S Medadrreceive=Medadrreceive
	I Subflag=1 S Medadrreceive=Medadrreceive_"："_"已转抄"
	I Subflag=2 S Medadrreceive=Medadrreceive_"："_"全部回复"
	I Subflag=3 S Medadrreceive=Medadrreceive_"："_"部分回复"
	S CaseShareflag="",CaseShareLoclist="",CaseShareUserlist="",CaseShareAdvicelist=""
	S ShareDataList=..GetCaseLocList(RepID,RepTypeDr)
	I ShareDataList["&&" S CaseShareLoclist=$p(ShareDataList,"&&",1) //共享科室列表
	I ShareDataList["&&" S CaseShareUserlist=$p(ShareDataList,"&&",2) //共享用户列表
	I ShareDataList["&&" S CaseShareAdvicelist=$p(ShareDataList,"&&",3) //共享意见列表
	
	s ret=1
	f i=1:1:$l(ParStr,"^") d
	.s dicStr=$p(ParStr,"^",i)
	.//列_$c(1)_值_$c(1)_判断条件_$c(1)_逻辑关系
	.s column=$p(dicStr,$c(1),1)
	.s columnValue=$p(dicStr,$c(1),2)
	.s columnOp=$p(dicStr,$c(1),3)
	.s columnCondition=$p(dicStr,$c(1),4)
	.s:columnOp="" columnOp="="
	.s:columnCondition="" columnCondition="and"
	.q:column=""
	.q:(columnCondition="and")&&(ret=0)
	.s:i=1 ret=0
	.q:(columnCondition="or")&&(ret=1)
	.s Flag=0
	.s:column="RepStaus" value=""""_RepStaus_""""
	.s:column="PatID" value=""""_PatID_""""
	.s:column="AdmNo" value=""""_AdmNo_""""
	.s:column="PatName" value=""""_PatName_""""
	.s:column="RepType" value=""""_RepType_""""
	.s:column="OccurLoc" value=""""_OccurLoc_""""
	.s:column="RepLoc" value=""""_RepLoc_""""
	.s:column="RepUser" value=""""_RepUser_""""
	.s:column="RepOverTimeflag" value=""""_RepOverTimeflag_""""
	.s:column="AutOverTimeflag" value=""""_AutOverTimeflag_""""
	.s:column="CaseShareLoclist" value=""""_CaseShareLoclist_""""
	.s:column="FileFlag" value=""""_FileFlag_""""
	.s:column="Medadrreceive" value=""""_Medadrreceive_""""
	.s:column="RepImpFlag" value=""""_RepImpFlag_""""
	.s:column="RepLevel" value=""""_RepLevel_""""
	.s:column="RepInjSev" value=""""_RepInjSev_""""
	.s:column="CaseShareLoclist" value=""""_CaseShareLoclist_""""
	.s:column="CaseShareUserlist" value=""""_CaseShareUserlist_""""
	.s:column="CaseShareAdvicelist" value=""""_CaseShareAdvicelist_""""
	.s:column="RepSubType" value=""""_RepSubType_""""
	.i column["Date" d
	..s:column="RepDate" value=""""_RepDate_""""
	..s:column="OccurDate" value=""""_OccurDate_""""
	..s columnValue=##class(web.DHCADVCOMMON).DateHtmlToLogical(columnValue)
	.e  d
	..s columnOp=$S(columnOp="=":"=",columnOp=">":"[",columnOp=">=":"[",columnOp="<=":"]",columnOp="<":"]",1:"")
	.s xcode=" s Flag="_value_columnOp_""""_columnValue_""""
	.x xcode
	.s:Flag=0 ret=0
	.s:Flag=1 ret=1
	q ret
}

/// Description: 获取报告已走过的流程下拉数据
/// Creator:     CongYue
/// CreateDate:  2019-12-26  
/// Table:		 DHC_AdrEvtWorkFlow ,DHC_AdrEvtWorkFlowItm
/// Input:   	 事件code，报告状态id ， 报告id
/// Output:  	 驳回下拉数据  
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetRevStatusComboxNew("advLogistics","32||1",58)
ClassMethod GetRevStatusComboxNew(EvenCode, Status = "", RepID = "") As %String
{
	N (EvenCode,Status,RepID,%session)
	Q:(EvenCode="")||(RepID="") ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	S EventDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(EvenCode),""))
	s eventparref="",eventsub="" ;2018-08-29
	i EventDr=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(EvenCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(EvenCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") EventDr=eventparref_"||"_eventsub
	S StatusDesc=$p(^DHCADREVTWFI(+Status,"ADREWI",$p(Status,"||",2)),"^",2)
	S StatusDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdrEvtWorkFlowItm","ADREWIDesc","",StatusDesc)

	S tmp=Status_"^"_StatusDesc
	S RevStatusList=..GetRevStatusList(EvenCode,Status,RepID)
	
	S count=0
	W "["	
	S len=$L(RevStatusList,"&&")
	F i=1:1:len D
	.S TmpStr=$p(RevStatusList,"&&",i)
	.Q:TmpStr=""
	.S TmpID=$p(TmpStr,"^",1)
	.S TmpDesc=$p(TmpStr,"^",2)
	.S TmpDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdrEvtWorkFlowItm","ADREWIDesc","",TmpDesc)
	.S TmpStr=TmpID_"^"_TmpDesc
	.I i=1  D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",TmpStr)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",TmpStr) //value^text
	I RevStatusList=""  D
	.W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	E  D
	.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp) //value^text
	w "]"
	q ""
}

/// Description: 获取报告已走状态数据串
/// Creator:     CongYue
/// CreateDate:  2019-12-26  
/// Table:		 DHC_AdrEvtWorkFlow ,DHC_AdrEvtWorkFlowItm
/// Input:   	 事件code，报告状态id ， 报告id
/// Output:  	 已走状态数据串  已&&分隔
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetRevStatusList("advLogistics","32||1",58)
ClassMethod GetRevStatusList(EvenCode, Status = "", RepID = "") As %String
{
	N (EvenCode,Status,RepID,%session)
	S RevStatusList=""
	Q:(EvenCode="")||(RepID="") ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	S EventDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(EvenCode),""))
	s eventparref="",eventsub="" ;2018-08-29
	i EventDr=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(EvenCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(EvenCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") EventDr=eventparref_"||"_eventsub
	S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	
	S Listt=RepID_"^"_EventDr_"^^^^"_Status_"^^"_RepLevelDr
	S matalast=##class(web.DHCADVCOMMON).InsStatusLast(Listt) 
	S ID=$p(matalast,"^",2)
	if (ID["||") d
	.S Desc=$p(^DHCADREVTWFI(+ID,"ADREWI",$p(ID,"||",2)),"^",2)
	.S tmp=ID_"^"_Desc
	.S RevStatusList=..GetRevStatusList(EvenCode,ID,RepID)
	.I RevStatusList="" D
	..S RevStatusList=tmp
	.E  D  
	..S RevStatusList=RevStatusList_"&&"_tmp
	
	Q RevStatusList
}

/// Descript:查询统计模板
/// Creator:sufan
/// CreateDate：2020-02-21
/// w ##class(web.DHCADVCOMMONPART).QueryStaTemp()
ClassMethod QueryStaTemp(HospDr = "")
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT M_RowId as ID , Code,Name FROM DHC_ADVModel" 
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowID = result.Data("ID")
		continue:+RowID=0
		s Code = result.Data("Code")
		s Desc = result.Data("Name")
		continue:(HospDr'="")&&(##class(web.DHCADVCOMMON).GetHospShowDataFlag("DHC_ADVModel",RowID,HospDr,"")'="Y")
		s tmp=RowID_"^"_Code_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^code^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^code^text",tmp)
	}
	w "]"
	Q ""
}

/// CreateDate:  2018-08-30
/// 发送消息到平台组
/// w ##class(web.DHCADVCOMMONPART).InsWebsysMessage(74,10211,"")
ClassMethod InsWebsysMessage(RepID = "", AuditUserDR = "", AuditMes = "", LgParam = "")
{
	n (RepID,AuditUserDR,AuditMes,LgParam)

	S RepRecordID=$p(^DHCADVMASTER(RepID),"^",1)
	S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	S RepLoc=$p(^DHCADVMASTER(RepID),"^",7)
	S CurStatusId=$p(^DHCADVMASTER(RepID),"^",3)  //当前状态ID
	s EpisodeId=$p(^DHCADVMASTER(RepID),"^",16)
	S RepType=""
	S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)		//事件类型
	S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	S FromUserRowId=AuditUserDR
	S FromLocRowId=$p(LgParam,"^",2)
	S WorkStatusDesc=""
	S NextStatusId=""
    S ToUserRowId=""
    S MedadrNextLocDR="",List="^^",WorkStatusDesc=""
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	S:MedadrID'="" MedadrNextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	S Listt=RepID_"^"_RepTypeDr_"^"_List_"^"_CurStatusId_"^"_MedadrNextLocDR_"^"_RepLevelDr
	S Matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt,LgParam) 
	S NextStatusId=$p(Matalist,"^",2)  //下一状态
	I NextStatusId'=""  D
	.S AdrewRowIDn=$p(NextStatusId,"||",1)
	.S AdrewChildSubn=$p(NextStatusId,"||",2)
	.S WorkStatusDesc=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	Q:NextStatusId="" "0"
	S HospID=$p(LgParam,"^",4)
	S Rtn=##class(web.DHCADVCOMMONPART).AdvSendMessage(FromUserRowId,EpisodeId,NextStatusId,RepTypeDr,RepLoc,RepUserDr,RepID,AuditMes,RepType,HospID,FromLocRowId)
	Q:Rtn'=0 Rtn
    Q "0"
}

/// w ##class(web.DHCADVCOMMONPART).AdvSendMessage(4926,"193")
ClassMethod AdvSendMessage(FromUserRowId, EpisodeId, NextStatusId, RepTypeDr, RepLoc, RepUserDr, RepID, AuditMes, RepType, HospID, FromLocRowId)
{
	N (FromUserRowId,EpisodeId,NextStatusId,RepTypeDr,RepLoc,RepUserDr,RepID,AuditMes,RepType,HospID,FromLocRowId)
	S RepList=RepTypeDr_"^"_RepLoc_"^"_RepUserDr_"^"_RepID 
	S pid=##class(web.DHCADVCOMMON).NewPid()
	K ^TMP("DHCADV","web.DHCADVCOMMONPART","AdvSendMessage",pid)
	S h=0
	S Err=0
	S AdrwfgID=""
	F  S AdrwfgID=$o(^DHCADREVTWFGR(0,"ItmDr",NextStatusId,AdrwfgID)) Q:AdrwfgID=""  D
	.S Type=$p(^DHCADREVTWFGR(AdrwfgID),"^",3) //类型 (人员/科室/安全组)
	.S Pointer=$p(^DHCADREVTWFGR(AdrwfgID),"^",4) //指针
	.S GrpHospDr=$p(^DHCADREVTWFGR(AdrwfgID),"^",5) // 关联医院
	.Q:(HospID'="")&&(HospID'=GrpHospDr)
	.S SSRowId="" d
	.F  S SSRowId=$o(^SSU("SSUSR",SSRowId)) q:SSRowId=""  d
	..S SedFlag=0
	..S SSLocID=$p(^SSU("SSUSR",SSRowId),"^",4)
	..S SSGroupID=$p(^SSU("SSUSR",SSRowId),"^",5)
	..S OtherChildSub=""
	..F  S OtherChildSub=$o(^SSU("SSUSR",SSRowId,"OTHLL",OtherChildSub)) Q:OtherChildSub=""  D
	...Q:SedFlag=1
	...S OTUserCTLOCDR=$p(^SSU("SSUSR",SSRowId,"OTHLL",OtherChildSub),"^",1) //其他登陆科室ID
	...S OTUserGroupDR=$p(^SSU("SSUSR",SSRowId,"OTHLL",OtherChildSub),"^",2) //其他登陆安全组ID
	...Q:((Type="1")&&(OTUserGroupDR'=Pointer))||((Type="2")&&(OTUserCTLOCDR'=Pointer))||((Type="3")&&(SSRowId'=Pointer))||(Type="5")
	...S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,SSRowId_"^"_OTUserCTLOCDR_"^"_OTUserGroupDR_"^"_HospID)
	...Q:flag=0
	...Q:$d(^TMP("DHCADV","web.DHCADVCOMMONPART","AdvSendMessage",pid,SSRowId))
	...S h=h+1
	...S ^TMP("DHCADV","web.DHCADVCOMMONPART","AdvSendMessage",pid,SSRowId,h)=SSRowId_"^"_OTUserCTLOCDR
	...D ##class(web.DHCADVCOMMONPART).SendMessage(FromUserRowId,EpisodeId,SSRowId,OTUserCTLOCDR,AuditMes,RepType,"",FromLocRowId)
	...s SedFlag=1
	..Q:SedFlag=1
	..Q:((Type="1")&&(SSGroupID'=Pointer))||((Type="2")&&(SSLocID'=Pointer))||((Type="3")&&(SSRowId'=Pointer))||(Type="5")
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,SSRowId_"^"_SSLocID_"^"_SSGroupID_"^"_HospID)
	..Q:flag=0
	..Q:$d(^TMP("DHCADV","web.DHCADVCOMMONPART","AdvSendMessage",pid,SSRowId))
	..S h=h+1
	..S ^TMP("DHCADV","web.DHCADVCOMMONPART","AdvSendMessage",pid,SSRowId,h)=SSRowId_"^"_SSLocID
	..D ##class(web.DHCADVCOMMONPART).SendMessage(FromUserRowId,EpisodeId,SSRowId,SSLocID,AuditMes,RepType,"",FromLocRowId)
	.Q:('Type="5")
    .S GrpUId=""
	.F  S GrpUId=$o(^DHCADVSECUGU(GrpUId)) Q:GrpUId=""  D
	..Q:GrpUId=0
	..S SECUGrpDr=$p($g(^DHCADVSECUGU(GrpUId)),"^",1)
	..Q:SECUGrpDr'=Pointer
	..S SECUUserDr=$p($g(^DHCADVSECUGU(GrpUId)),"^",2)
	..S SECULeadFlag=$p($g(^DHCADVSECUGU(GrpUId)),"^",3)
	..Q:SECULeadFlag'="Y"
	..S Flag= ##class(web.DHCADVCOMMONPART).GetRecieveUser(SECUUserDr,RepLoc)
	..I (Flag=1) D 
	...S ToUserRowId=SECUUserDr   //大科护士长
	...Q:$d(^TMP("DHCADV","web.DHCADVCOMMONPART","AdvSendMessage",pid,ToUserRowId))
	...S h=h+1
	...S ^TMP("DHCADV","web.DHCADVCOMMONPART","AdvSendMessage",pid,ToUserRowId,h)=ToUserRowId_"^"_RepLoc
	...D ##class(web.DHCADVCOMMONPART).SendMessage(FromUserRowId,EpisodeId,ToUserRowId,RepLoc,AuditMes,RepType,"",FromLocRowId)
	K ^TMP("DHCADV","web.DHCADVCOMMONPART","AdvSendMessage",pid)
    Q "0"
}

/// w ##class(web.DHCADVMessage).GetRecieveUser(4926,"193")
ClassMethod GetRecieveUser(UserId, RepLoc)
{
	N (UserId,RepLoc)
	S Flag=0
	S Secuflag=##class(web.DHCADVCOMMONPART).GetSecuGroupWard(UserId, RepLoc) ;判断登录人是否属于大科安全组 病区 是否有查看权限
	S SecuLocflag=##class(web.DHCADVCOMMONPART).GetSecuGroupLoc(UserId, RepLoc) ;判断登录人是否属于大科安全组 科室 是否有查看权限
    S SecuLeaderfalg=##class(web.DHCADVCOMMONPART).GetSecuUserLeader(UserId)
    S:((Secuflag=1)||(SecuLocflag=1))&&(SecuLeaderfalg=1) Flag=1
    Q Flag
}

/// 发送消息到平台组 //不良事件   
/// Creator:     yangyongtao
/// CreateDate:  2018-08-30
/// 发送消息到平台组 //  给上报人发送消息
ClassMethod SendMessage(FromUserRowId = "", EpisodeId = "", ToUserRowId = "", RepLoc = "", AuditMes = "", RepType = "", ActionTypeCode = "", FromLocRowId = "")
{
	N (FromUserRowId, EpisodeId, ToUserRowId, RepLoc, AuditMes, RepType,ActionTypeCode,FromLocRowId)
	Q:ToUserRowId="" 0
	S UserActive=$p(^SSU("SSUSR",ToUserRowId),"^",19)
	Q:(UserActive'="")&&(UserActive="N") 0
	S UserDateFrom=$p(^SSU("SSUSR",ToUserRowId),"^",96) ;生效日期
	S UserDateTo=$p(^SSU("SSUSR",ToUserRowId),"^",97) ;截止日期
	Q:(UserDateFrom'="")&&(UserDateFrom>+$h) 0
	Q:(UserDateTo'="")&&(UserDateTo<+$h) 0
	
	S OrdItemId=""
	S EffectiveDays=30
	S CreateLoc=FromLocRowId // RepLoc-发送到科室 CreateLoc-从哪个科室发送
	S LgUserID=ToUserRowId
	S RepType=$Replace(RepType,"/","")
	S AuditMes=$Replace(AuditMes,"/","")
	s LinkUrl="dhcadv.homepage.csp"
	S Title=RepType   ;_"不良事件"	
	S Context="你有新的报告单（"_Title_"）需处理。"  
	S:ActionTypeCode="" ActionTypeCode="1165"
	S Rtn =##class(websys.DHCMessageInterface).Send(Context, ActionTypeCode, FromUserRowId, EpisodeId , OrdItemId , ToUserRowId , LinkUrl , "" , EffectiveDays , FromLocRowId)
	Q Rtn
}

/// Description: 父类子类都是checkbox的情况  根据 报告id 父元素代码 获取 勾选的所有叶子节点元素
/// Creator:     cy
/// CreateDate:  2020-06-01
/// Table:		 
/// Input:   	 RepID 报告id ， DicField  元素代码 ，  List 元素描述串  ，  CodeList 元素代码串
/// Output:  	 字符串
/// Others:		 w ##class(web.DHCADVCOMMONPART).getSubTypeNew("108","MedRepType","","")
ClassMethod getSubTypeNew(RepID, DicField, List, CodeList)
{
	N (RepID, DicField,List,CodeList)
	S SubList=List
	S FiledList=CodeList
	Q:RepID="" SubList_"^"_FiledList
	Q:DicField="" SubList_"^"_FiledList
	S FormRecDr=$p(^DHCADVMASTER(RepID),"^",1)
	S FormDicDr=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(DicField),""))
	
	S DicID="",FList=""
	F  S DicID=$o(^User.DHCAdvFormRecordItmI("IndexRefFormDic",FormRecDr,FormDicDr,DicID)) Q:DicID=""  D
	.S Filed=$LG(^User.DHCAdvFormDicD(DicID),2)
	.S FormRecItmID=$o(^User.DHCAdvFormRecordItmI("IndexRefFormDic",FormRecDr,FormDicDr,DicID,"")) 
	.Q:FormRecItmID=""
	.S:('$d(^User.DHCAdvFormRecordItmI("IndexRefFormDic",FormRecDr,DicID))) List=$LG(^User.DHCAdvFormRecordItmD(FormRecItmID),4)  //值
	.S:('$d(^User.DHCAdvFormRecordItmI("IndexRefFormDic",FormRecDr,DicID))) FList=Filed  //值
	.S DicList=..getSubTypeNew(RepID, Filed,List,FList)
	.S:SubList'="" SubList=SubList_"$$"_$p(DicList,"^",1)
	.S:FiledList'="" FiledList=FiledList_"&&"_$p(DicList,"^",2)
	.S:SubList="" SubList=$p(DicList,"^",1)
	.S:FiledList="" FiledList=$p(DicList,"^",2)
	
	Q SubList_"^"_FiledList
}

/// Description: 获取表单对照 不良事件类别 元素id与code
/// Creator:     congyue
/// CreateDate:  2020-06-17
/// Table: 		 DHC_DHCAdvDicContrast DHC_AdvFormField DHC_AdvFormDic 
/// Input:  	 表单名称id  业务字段代码
/// Return: 	 保存成功 0,保存失败 非0  QueryCheckDataInfo
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetConFormDic("994","RepManaCat")
ClassMethod GetConFormDic(FormNameID As %String, FileCode As %String)
{
	N (FormNameID,FileCode)
	S FormDicID="",ContrastID="",FormDicCode=""
	S FormNameCode=$lg(^User.DHCAdvFormNameD(FormNameID),2)
	Q:FormNameCode="" FormDicID_"^"_FormDicCode
	S FieldID=$o(^DHCADVFF(0,"Code",$$ALPHAUP^SSUTIL4(FileCode),""))
	Q:FieldID="" FormDicID_"^"_FormDicCode
	S:FieldID'="" ContrastID=$o(^DHCADVFDC(0,"FieldFormName",FieldID,FormNameCode,""))
	S:ContrastID'="" FormDicCode=$p(^DHCADVFDC(ContrastID),"^",4)
	S:FormDicCode'="" FormDicID=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(FormDicCode),""))  
	Q:FormDicID="" FormDicID_"^"_FormDicCode
	Q FormDicID_"^"_FormDicCode
}

/// Description: 保存[管理类别]的数据
/// Creator:     congyue
/// CreateDate:  2020-06-17
/// Table: 		 DHC_AdvFormDic DHC_AdvFormRecordItm DHC_AdvMasterCat
/// Input:  	 报告id（master表Id）, 表单记录id 
/// Return: 	 保存成功 0,保存失败 非0  QueryCheckDataInfo
/// Others:		 w ##class(web.DHCADVCOMMONPART).SaveManageList("107","994","RepManaCat")
ClassMethod SaveManageList(RepID As %String, FormNameID As %String, FileCode As %String) As %String
{
	N (RepID,FormNameID,FileCode)
	S ManageTypeCode="",ServiceItemCode="",ChildItemCode="",Err=0
	S FormDicCode=""
	S ConFormDicList=..GetConFormDic(FormNameID,FileCode) // 获取表单中元素对照的code
	S FormDicCode=$p(ConFormDicList,"^",2)
	Q:FormDicCode="" Err
	S RepTypeDescList="",RepTypeCodeList=""
	S RepTypeList= ##class(web.DHCADVCOMMONPART).getSubTypeNew(RepID,FormDicCode,"","") // 获取勾选所有子元素叶子节点数据
	S:RepTypeList["^" RepTypeDescList=$p(RepTypeList,"^",1)
	S:RepTypeList["^" RepTypeCodeList=$p(RepTypeList,"^",2)
	
	TS
	// 删除相关表
	S Err=..DelManageType(RepID)
	I Err'=0 tro
	Q:Err'=0 "-10"
	
	// 保存管理类别信息
	S len=$L(RepTypeCodeList,"&&")
	F i=1:1:len Q:Err<0  D
	.S TmpStr=$p(RepTypeCodeList,"&&",i)
	.Q:TmpStr=""
	.S TmpDicID=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(TmpStr),""))  
	.Q:'$D(^DHCADVFDLINK(0,"FormDic",TmpDicID))
	.S Err=..SaveManageTypeList(RepID,$p(TmpStr,"-",2),$p(TmpStr,"-",3),$p(TmpStr,"-",4))
	.Q:Err<0
	I Err<0 tro
	Q:Err<0 Err
	
	TC
	
	q Err
}

/// Description: 删除 不良事件主表关联表（管理类别数据） 信息
/// Creator:     congyue
/// CreateDate:  2020-06-17
/// Table: 		 DHC_AdvMasterCat  
/// Input:  	 RepDr 
/// Return: 	 删除成功 0,删除失败 非0 
/// Others:		 w ##class(web.DHCADVULCPARTINFO).SaveManageTypeList("")
ClassMethod DelManageType(RepID As %String)
{
	N (RepID)
	// 管理类别
	I $D(^DHCADVMASTERCAT(0,"Master",RepID)) D
	.&SQL(DELETE DHC_AdvMasterCat WHERE  MC_Master_Dr=:RepID)
	Q:+$G(SQLCODE)'=0 SQLCODE
	
	Q 0
}

/// Description: 保存[管理类别数据]
/// Creator:     WangXuejian
/// CreateDate:  2018-10-31
/// Table: 		 DHC_AdvMasterCat  
/// Input:  	 RepDr,ManageTypeCode:管理类别Code(一级),ServiceItemCode:服务项目Code(二级) ,ChildItemCode:子项Code(三级) 
/// Input:  	 RepDr:108,advBlood,bld01       RepDr:108,treDefect,Tre01,Tre01_03
/// Return: 	 保存成功 0,保存失败 非0 ManageTypeCode,ServiceItemCode,ChildItemCode
/// Others:		 w ##class(web.DHCADVULCPARTINFO).SaveManageTypeList("")
ClassMethod SaveManageTypeList(RepDr As %String, ManageTypeCode As %String, ServiceItemCode As %String, ChildItemCode As %String) As %String
{
	N (RepDr,ManageTypeCode,ServiceItemCode,ChildItemCode)
	S Err=0
	&SQL(INSERT INTO DHC_AdvMasterCat(MC_Master_Dr,MC_ManageCat,MC_ManCatProject,MC_CatProChild) 
 	VALUES(:RepDr,:ManageTypeCode,:ServiceItemCode,:ChildItemCode))
 	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 获取带有工作流的类别id与代码
/// Creator:     CongYue
/// CreateDate:  2020-06-03
/// Table:		 DHC_AdrEvtWorkFlow
/// Input:  	 DataList:以字符"&&"分割,格式为:MedRepType-advBlood-bld01&&MedRepType-advBlood-bld02
/// Return: 	 类别id^类别代码 
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetWFTypeCode("107","994","RepManaCat")
ClassMethod GetWFTypeCode(RepID As %String, FormNameID As %String, FileCode As %String) As %String
{
	N (RepID, FormNameID,FileCode)
	S ConFormDicList=..GetConFormDic(FormNameID,FileCode) // 获取表单中元素对照的code
	S FormDicCode=$p(ConFormDicList,"^",2)
	Q:FormDicCode="" "^"
	S RepTypeDescList="",RepTypeCodeList=""
	S RepTypeList= ##class(web.DHCADVCOMMONPART).getSubTypeNew(RepID,FormDicCode,"","") // 获取勾选所有子元素叶子节点数据
	S:RepTypeList["^" RepTypeDescList=$p(RepTypeList,"^",1)
	S:RepTypeList["^" RepTypeCodeList=$p(RepTypeList,"^",2)
	
	S TypeDr="",TypeCode="" 
	S len=$L(RepTypeCodeList,"&&")
	F i=1:1:len Q:TypeDr'=""  D
	.Q:TypeDr'="" 
	.S TmpStr=$p(RepTypeCodeList,"&&",i)
	.Q:TmpStr=""
	.S TmpDicID=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(TmpStr),""))  
	.Q:'$D(^DHCADVFDLINK(0,"FormDic",TmpDicID))
	.S Tmplen=$L(TmpStr,"-")
	.S Code=$p(TmpStr,"-",Tmplen)
	.S TypeDr=..GetWFType(Code)  // 获取带有工作流的id
	.Q:TypeDr'="" 	
	S:(TypeDr["||") TypeCode=$p(^DHCMEDADREVTI(+TypeDr,"MADREVI",$p(TypeDr,"||",2)),"^",1)
	S:(TypeDr'="")&&(TypeDr'["||") TypeCode=$p(^DHCMEDADREVT(TypeDr),"^",1)
	
	Q TypeDr_"^"_TypeCode
}

/// Description: 根据类型code获取工作流（本身，父元素，……优先级依次低  存在工作流即返回类型id）
/// Creator:     CongYue
/// CreateDate:  2020-06-03
/// Table:		 DHC_AdrEvtWorkFlow
/// Input:  	 Code： 类型code
/// Return: 	 存在工作流的类型id
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetWFType("advSkinUlcer")
ClassMethod GetWFType(Code As %String) As %String
{
	N (Code)
	S TypeDr=""
	Q:Code="" TypeDr
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(Code),"")) //类别指向
	Q:(TypeDr'="")&&($d(^DHCADREVTWF(0,"Event",TypeDr))) TypeDr
	S TypeParref="",TypeSub="" ;2018-08-31
	I TypeDr=""  D
	.S TypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(Code),"")) //子表类别指向
	.S:TypeParref'="" TypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(Code),TypeParref,""))
	.S:(TypeParref'="")&&(TypeSub'="") TypeDr=TypeParref_"||"_TypeSub
	Q:(TypeDr'="")&&($d(^DHCADREVTWF(0,"Event",TypeDr))) TypeDr
	Q:TypeDr'["||" ""
	S LevelRowID=$p(^DHCMEDADREVTI(TypeParref,"MADREVI",TypeSub),"^",5)
	S LevelCode=""
	S:LevelRowID["||" LevelCode=$p(^DHCMEDADREVTI(+LevelRowID,"MADREVI",$p(LevelRowID,"||",2)),"^",1)
	S:LevelRowID'["||" LevelCode=$p(^DHCMEDADREVT(LevelRowID),"^",1)
	S TypeDr=..GetWFType(LevelCode)
	Q:(TypeDr'="")&&($d(^DHCADREVTWF(0,"Event",TypeDr))) TypeDr
	
	Q TypeDr
}

/// Description: 根据报告类型信息（报告表单类型id^报告表单类型code^报告表单类型描述^报告类别id^报告类别code）
/// Creator:     CongYue
/// CreateDate:  2020-06-21
/// Table:		 DHC_AdrEvtWorkFlow
/// Input:  	 报告ID , 
/// Return: 	 RepTypeString:报告表单类型id^报告表单类型code^报告表单类型描述^报告类别id(报告表单类型id或者报告勾选不良事件类别id)^报告类别code
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetWFType("advSkinUlcer")
ClassMethod GetRepTypeString(RepID As %String) As %String
{
	N (RepID,%session)
	S RepTypeString=""
	S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	Q:recordID="" RepTypeString
	// 报告表单类型
	S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEvent","MADREVDesc","",RepType) //hxy 2020-06-24 st
	S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEventItm","MADREVIDesc","",RepType) //ed

	S TypeDr=RepTypeDr
	S Type=RepType
	S TypeCode=RepTypeCode
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	
	// 获取带有工作流的 不良事件类别id与code(报告勾选不良事件类别)
	S RepManaCatDr="",RepManaCatCode="",RepManaCat=""
	S FormNameID=$lg(^User.DHCAdvFormRecordD(recordID),2)
	S:MedadrID="" RepManaCat=..GetWFTypeCode(RepID,FormNameID,"RepManaCat")
	S:($p(RepManaCat,"^",1))'="" RepTypeDr=$p(RepManaCat,"^",1)
	S:($p(RepManaCat,"^",2))'="" RepTypeCode=$p(RepManaCat,"^",2)
	S RepTypeString=TypeDr_"^"_TypeCode_"^"_Type_"^"_RepTypeDr_"^"_RepTypeCode
	Q RepTypeString
}

/// Description: 保存不良事件关联表业务数据
/// Creator:     congyue
/// CreateDate:  2021-02-09
/// Table: 		 DHC_AdvMasterLink
/// Input:  	 报告id（master表Id）, 关联类型（Order 医嘱） , 关联数据串（&&拼接） 
/// Return: 	 保存成功 0,保存失败 非0  
/// Others:		 w ##class(web.DHCADVCOMMONPART).InsRepLink("107","Order","208502.96805.99&&14||20$$208502.96805.100&&14||66$$208503.96814.91&&14||19")
ClassMethod InsRepLink(RepID As %String, Type As %String, DataList As %String) As %String
{
	N (RepID,Type,DataList)
	S Err=0
	Q:DataList="" Err
	TS
	// 删除报告相关数据	
	I $D(^User.DHCAdvMasterLinkI("IndexMatTyeLink",RepID," "_##class(web.DHCADVAction).ALPHAUP(Type)))  D
	.&SQL(DELETE DHC_AdvMasterLink WHERE  MLMasterDr=:RepID AND MLType=:Type)
	S:+$g(SQLCODE)'=0 Err=SQLCODE
	Q:Err'=0

	I Err'=0 tro
	Q:Err'=0 Err
	
	// 插入数据
	S len=$L(DataList,"$$")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"$$",i)
	.Q:(TmpStr="")
	.S LinkDr=$p(TmpStr,"&&",1)
	.Q:(LinkDr="")
	.&SQL(Insert Into DHC_AdvMasterLink(MLMasterDr,MLType,MLLinkDr) Values(:RepID,:Type,:LinkDr))
	.S:+$g(SQLCODE)'=0 Err=SQLCODE
	.Q:Err'=0
	I Err'=0 tro
	Q:Err'=0 Err
	
	TC
	
	q Err
}

/// Description: 不良事件查询（查询医嘱相关的不良事件）
/// Creator:     CongYue
/// CreateDate:  2021-02-07
/// Input:  	 LgParam:登陆人信息（备用） RepCode:报告类型code ,OrderID: 医嘱ID
/// Return: 	 医嘱相关不良事件 信息
/// Others:		 w ##class(web.DHCADVCOMMONPART).QueryRepListByOrder(30,1,"","","14||19")
ClassMethod QueryRepListByOrder(rows = 10, page = 1, LgParam As %String = "", RepCode As %String, OrderID As %String)
{
  
	N (rows,page,LgParam,RepCode,OrderID)
	q:OrderID="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S End = page*rows
	S Start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行

    S UserId=$p(LgParam,"^",1)    //用户ID
    S LocId=$p(LgParam,"^",2)     //科室ID
	S GroupId=$p(LgParam,"^",3)   //安全组ID
	S HospId=$p(LgParam,"^",4)   //医院ID

	S list=UserId_"^"_LocId_"^"_GroupId
	
    S h=0  
	s count=0
	w "{""rows"":["
	s MasLinkID=""
	f  s MasLinkID=$o(^User.DHCAdvMasterLinkI("IndexTyeLink"," ORDER"," "_OrderID,MasLinkID)) q:MasLinkID=""  d
	.s data=^User.DHCAdvMasterLinkD(MasLinkID)
	.s RepID=$LIST(data,2)  
	.S RepTypeDr="",RepTypeCode="",RepType="",RepUser="",RepLoc="",RepSubType="",RepLevelDr=""
	.S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	.Q:recordID=""
	.// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id） 2020-06-22
	.S RepTypeString=..GetRepTypeString(RepID)
	.S TypeDr=$p(RepTypeString,"^",1) ; 报告表单类型id
	.S TypeCode=$p(RepTypeString,"^",2)
	.S Type=$p(RepTypeString,"^",3)
	.S RepTypeDr=$p(RepTypeString,"^",4)
	.S RepTypeCode=$p(RepTypeString,"^",5)
	.Q:(RepCode'="")&&(RepCode'=RepTypeCode)
	.S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	.S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	.S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	.S:OccurDate="" OccurDate=0
	.S OccurTime=$p(^DHCADVMASTER(RepID),"^",26)  ///发生时间
	.S:OccurTime="" OccurTime=0
	.S RepOverTime=""
	.S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	.S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	.S RepInjSev=$p(^DHCADVMASTER(RepID),"^",13) ///伤害严重度
	.S:RepDate'="" RepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	.S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	.S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	.S RecRepUser=##class(web.DHCADVCOMMONPART).QueryInputDataInfo(recordID,"填报人姓名")  //取匿名信息 sufan 2019-11-07
	.S:(RecRepUser["匿名")||(RecRepUser["anonymous") RepUser=RecRepUser
	.S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	.S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	.S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	.S RepSubType=$p(^DHCADVMASTER(RepID),"^",8)
	.S RepImp=$p(^DHCADVMASTER(RepID),"^",9)
	.S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	.S AdmID=$p(^DHCADVMASTER(RepID),"^",16)  
	.S PatName=$p(^DHCADVMASTER(RepID),"^",17)  
	.S AdmNo=$p(^DHCADVMASTER(RepID),"^",20)  ///病案号	
	.S OccurLoc=$p(^DHCADVMASTER(RepID),"^",27)  ///发生科室
	.S:OccurLoc'="" OccurLoc=$p(^CTLOC(OccurLoc),"^",2)
	.S:OccurLoc["-" OccurLoc=$p(OccurLoc,"-",2)
	.S:OccurDate="0" OccurDate=""
	.S:(OccurDate'="")&&(OccurDate'="0") OccurDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(OccurDate)
	.s PatID=$p(^DHCADVMASTER(RepID),"^",14)  ///登记号
	.S PapRowid=""
	.S:AdmID'="" PapRowid=$p(^PAADM(AdmID),"^",1)
	.S:(AdmID'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(AdmID,"")  //病案号 
	.S:(PapRowid'="")&&(PatID="") PatID=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	.S:(PapRowid'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",PapRowid)  //病案号
	.S:(PapRowid'="")&&(PatName="") PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	.S LocDep=""
	.S:RepLocDr'="" LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)  ;报告科室所属大科系统
	.s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.RepID=RepID
	.s tmpObj.recordID=recordID
	.s tmpObj.RepTypeCode=TypeCode
	.s tmpObj.RepType=Type
	.s tmpObj.RepDate=RepDate
	.s tmpObj.RepUser=RepUser
	.s tmpObj.RepLoc=RepLoc 
	.s tmpObj.PatID=PatID
	.s tmpObj.PatName=PatName
	.s tmpObj.RepSubType=RepSubType
	.s tmpObj.RepLevel=RepLevel
	.s tmpObj.RepInjSev=RepInjSev
	.s tmpObj.RepTypeDr=TypeDr
	.s tmpObj.AdmNo=AdmNo
	.s tmpObj.OccurLoc=OccurLoc
	.s tmpObj.OccurDate=OccurDate
	.s tmpObj.LocDep=LocDep
	.s tmpObj.AdmID=AdmID
	.s tmpObj.RepLocDr=RepLocDr
	.w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	q ""
}

/// Description: 获取 不良事件关联表 关联数据指向id
/// Creator:     congyue
/// CreateDate:  2021-02-09
/// Table: 		 
/// Input:  	 报告id, 关联类型（Order 医嘱） 
/// Return: 	 关联数据指向id串："$$"拼接
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetOrdList("25","Order")
ClassMethod GetOrdList(RepID As %String, Type As %String) As %String
{
	N (RepID,Type)
	S MasLinkID="",OrderList=""

	F  S MasLinkID=$o(^User.DHCAdvMasterLinkI("IndexMatTyeLink",RepID," "_##class(web.DHCADVAction).ALPHAUP(Type),MasLinkID)) Q:MasLinkID=""  D
	.S Data=^User.DHCAdvMasterLinkD(MasLinkID)
	.S OrderDr=$LIST(Data,4) 
	.S:OrderList'="" OrderList=OrderList_"$$"_OrderDr
	.S:OrderList="" OrderList=OrderDr
	
	Q OrderList
}

/// Description: 检查医护人员类型（登陆人和报告人是否为同一类型）
/// Creator:     CongYue
/// CreateDate:  2021-02-24
/// Table:		 SS_User CT_CareProv CT_CarPrvTp
/// Input:  	 UserID：登陆人ID , RepUserDr：报告人ID , LgParam：登陆人信息
/// Return: 	 Flag:0 类型不一致  1 类型一致
/// Others:		 w ##class(web.DHCADVCOMMONPART).ChkUserType("12175","12176","1")
ClassMethod ChkUserType(UserID As %String, RepUserDr As %String, IfShunt As %String) As %String
{
	N (UserID,RepUserDr,IfShunt)
	S Flag=0
	S LgUserCPDR="",LgCTCptDR="",LgCTType=""
	S:+UserID'=0 LgUserCPDR=$p(^SSU("SSUSR",UserID),"^",14) 
	S:+LgUserCPDR'=0 LgCTCptDR=$p(^CTPCP(LgUserCPDR,1),"^",4 )
	S:+LgCTCptDR'=0 LgCTType=$p(^CT("CPT",LgCTCptDR),"^",4)   ;类型
	
	S UserCPDR="",CTCptDR="",CTType=""
	S:+RepUserDr'=0 UserCPDR=$p(^SSU("SSUSR",RepUserDr),"^",14)  
	S:+UserCPDR'=0 CTCptDR=$p(^CTPCP(UserCPDR,1),"^",4 )
	S:+CTCptDR'=0 CTType=$p(^CT("CPT",CTCptDR),"^",4)   ;类型
	
	S:(IfShunt="1")||(LgCTType=CTType) Flag=1
	
	Q Flag
}

/// 转抄操作
/// Description: 查询有权限的科室指向下的人员
/// Creator:     CongYue
/// CreateDate:  2016-05-16  
/// Input:  	 报告类型Code^科室ID
/// Output:   	 具有查看报告权限的人员
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetUserList("120","1","advNursing^6")
ClassMethod GetUserList(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params,%session)
	
	S LocDr=$p(params,"^",2) ;下拉框科室指向
	S End = page*rows
	S Start=(page-1)*rows+1
	S pid=##class(web.DHCADVCOMMON).NewPid()
	K ^TMP("DHCADV","web.DHCADVCOMMONPART","GetUserList",pid)
	S UserID=""
	S h=0
	S count=0
	F  S UserID=$o(^SSU("SSUSR",UserID)) Q:UserID=""  D
	.S Sub=""
	.S UserActive=$p(^SSU("SSUSR",UserID),"^",19)
	.Q:(UserActive'="")&&(UserActive="N")
	.S UserDateFrom=$p(^SSU("SSUSR",UserID),"^",96) ;生效日期
	.S UserDateTo=$p(^SSU("SSUSR",UserID),"^",97) ;截止日期
	.Q:(UserDateFrom'="")&&(UserDateFrom>+$h)
	.Q:(UserDateTo'="")&&(UserDateTo<+$h)

	.S LocID=$p(^SSU("SSUSR",UserID),"^",4)
	.F  S Sub=$o(^SSU("SSUSR",UserID,"OTHLL",Sub)) Q:Sub=""  D
	..Q:Sub=0
	..S OthLogLocID=$p(^SSU("SSUSR",UserID,"OTHLL",Sub),"^",1)
	..S flags=0
	..Q:(OthLogLocID="")&&(LocID="")
	..S:(LocID'=LocDr)&&(OthLogLocID'=LocDr) flags=-1
	..S userName=$p(^SSU("SSUSR",UserID),"^",2)
	..S userName=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",userName)  ;2020-06-28 cy
	..Q:flags=-1
	..S ListData=UserID_"^"_userName
	..Q:$d(^TMP("DHCADV","web.DHCADVCOMMONPART","GetUserList",pid,userName))
	..S h=h+1
	..S ^TMP("DHCADV","web.DHCADVCOMMONPART","GetUserList",pid,userName,h)=ListData
	.S flags=0
	.Q:LocID=""
	.S:LocID'=LocDr flags=-1
	.S userName=$p(^SSU("SSUSR",UserID),"^",2)
	.S userName=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",userName)  ;2020-06-28 cy
	.Q:flags=-1
	.Q:$d(^TMP("DHCADV","web.DHCADVCOMMONPART","GetUserList",pid,userName))
	.S h=h+1
	.S ListDatas=UserID_"^"_userName
	.S ^TMP("DHCADV","web.DHCADVCOMMONPART","GetUserList",pid,userName,h)=ListDatas
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	S Title="UserID^Username"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index="",user=""
	F  S user=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","GetUserList",pid,user)) Q:user=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVCOMMONPART","GetUserList",pid,user,index)) Q:index=""  D
	..S mdate=$g(^TMP("DHCADV","web.DHCADVCOMMONPART","GetUserList",pid,user,index))
	..S count = count+1
	..Q:(count<Start)||(count>End)
	..I count=Start D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	K ^TMP("DHCADV","web.DHCADVCOMMONPART","GetUserList",pid)
	Q ""
}

/// Description: 检查是否超时
/// Creator:     CongYue
/// CreateDate:  2021-03-26
/// Table:		
/// Input:  	 RepID：报告ID , TimeType:"ACCEPTTIME" 受理时限时长(默认) , "FILLTIME" 填报时限时长(默认) , LgParam：登陆人信息 , EndDate : 结束日期 ,EndTime : 结束时间
/// Return: 	 Flag:N 未超时  Y 超时
/// Others:		 w ##class(web.DHCADVCOMMONPART).ChkOverTime("12","FILLTIME","65796","37260","17||2","10211^151^23^2")
ClassMethod ChkOverTime(RepID As %String, TimeType As %String, EndDate As %String = 0, EndTime As %String = 0, RepStausDr As %String, LgParam As %String) As %String
{
	N (RepID,TimeType,EndDate,EndTime,RepStausDr,LgParam)
	S Flag="N",TimeLen=0
	S TimeType=$$ALPHAUP^SSUTIL4(TimeType)
	Q:(RepID="")||(TimeType="") Flag
	
	S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	S OccurDate=$p(^DHCADVMASTER(RepID),"^",25)  ///发生日期
	S:OccurDate="" OccurDate=0
	S OccurTime=$p(^DHCADVMASTER(RepID),"^",26)  ///发生时间
	S:OccurTime="" OccurTime=0
	S StDate=OccurDate,StTime=OccurTime
	/// 受理时限模式 1 与填报时间相比较
	S AcceptMode=##class(web.DHCADVCOMMON).GetEmSysConfig("ACCEPTMODE",LgParam)  
	I (TimeType="ACCEPTTIME")&&(AcceptMode="1")  D
	.S StDate=RepDate
	.S StTime=RepTime
	// 获取工作流维护时限时长
	S GenericList=##class(web.DHCADVCOMMONPART).GetGenericInfo("TIME",RepStausDr)
  	S Len=$L(GenericList,"$$")
  	F i=1:1:Len D
  	.S Str=$p(GenericList,"$$",i)
  	.S Data=$p(Str,"^",1)
  	.S Attribute=$p(Str,"^",2)
  	.S:(Attribute'="")&&(RepLevelDr=Attribute) TimeLen=Data
  	.S:(Attribute="")&&(Data'="") TimeLen=Data
	// 计算是否超时  TimeType:"ACCEPTTIME" 受理时限时长(默认) TimeType:"FILLTIME" 填报时限时长(默认)
	S HolidayDate=##class(web.DHCADVCOMMONPART).CheckTimeEscapeHoliday(StDate,StTime,EndDate,EndTime)
	S:TimeLen=0 TimeLen=##class(web.DHCADVCOMMON).GetEmSysConfig(TimeType,LgParam) 
	S:(+TimeLen'=0)&&(HolidayDate>TimeLen) Flag="Y"   
	Q Flag
}

/// Description: 获取配置通用关系表数据与属性
/// Creator:     CongYue
/// CreateDate:  2021-03-26
/// Table:		
/// Input:  	 Type："FORMDIC"-元素属性维护  "TIME"-时限 , RepStausDr：报告状态 , HospId：医院id
/// Return: 	 属性信息串：数据^属性$$数据^属性$$数据^属性
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetGenericInfo("formdic","14||1")
ClassMethod GetGenericInfo(Type As %String, RepStausDr As %String, HospId = "") As %String
{
	N (Type,RepStausDr,HospId)
	S Type=$$ALPHAUP^SSUTIL4(Type)
	S List=""
	Q:(Type="")||(RepStausDr="") List
	S ID=""

	F  S ID=$o(^User.DHCAdvGenericRelationI("IndexTypeLink",Type," "_RepStausDr,ID))  Q:+ID=0  D
	.S datalist=^User.DHCAdvGenericRelationD(ID)
	.S Data=$LG(datalist,4)
	.S Attribute=$LG(datalist,5)
	.S GRHospID=$LG(datalist,7)
	.Q:(GRHospID'="")&&(HospId'="")&&(GRHospID'=HospId)
	.S:List'="" List=List_"$$"_Data_"^"_Attribute
	.S:List="" List=Data_"^"_Attribute
	
	Q List
}

/// Description: 获取报告填写状态
/// Creator:     CongYue
/// CreateDate:  2021-03-26
/// Table:		
/// Input:  	 RepID：报告ID , TimeType：超时类型（填写时限-Fill，受理时限-Accept） , LgParam：登陆人信息 , EndDate : 结束日期 ,EndTime : 结束时间
/// Return: 	 Flag^RepStausDr: 登录人是否对报告下一状态有操作权限
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetRepStaus("","BloodDealAdvice","advBlood","12175^113^29")
ClassMethod GetRepStaus(RepID As %String, TypeCode As %String, LgParam As %String) As %String
{
	N (RepID,TypeCode,LgParam)
	S Flag="N"
	S list=$p(LgParam,"^",1,3)
	Q:(TypeCode="") Flag
	S RepStausDr="",RepLevelDr=""
	/// 获取报告类型id
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),"")) 
	s TypeParref="",TypeSub="" 
	i TypeDr=""  d
	.S TypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),"")) 
	.S:TypeParref'="" TypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),TypeParref,""))
	.S:(TypeParref'="")&&(TypeSub'="") TypeDr=TypeParref_"||"_TypeSub
	I RepID="" D
	.S RepStausDr=##class(web.DHCADVCOMMON).GetRepFistStatusID(TypeDr,LgParam,"")
	E  D
	.S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	.S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	.S Listt=RepID_"^"_TypeDr_"^"_list_"^^"_""_"^"_RepLevelDr
	.S RepStausDr=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,"",LgParam)
	S:RepStausDr["||" Flag="Y"
	Q Flag_"^"_RepStausDr
}

/// Description: 获取配置通用关系表数据与属性
/// Creator:     CongYue
/// CreateDate:  2021-03-26
/// Table:		
/// Input:  	 RepID：报告ID , RepStausDr：报告状态ID ,HospId:医院ID
/// Return: 	 Flag:0 可以编辑  1 不可编辑
/// Others:		 w ##class(web.DHCADVCOMMONPART).ChkFormDic("","BloodDealAdvice","advBlood","12175^113^29")
ClassMethod ChkFormDic(FormDic As %String, RepStausDr As %String, HospId = "") As %String
{
	N (FormDic,RepStausDr,HospId)
	S Flag=0
	Q:(RepStausDr="")||(FormDic="") Flag
	// 获取工作流维护元素编辑属性
	S GenericList=##class(web.DHCADVCOMMONPART).GetGenericInfo("FORMDIC",RepStausDr,HospId)
  	S Len=$L(GenericList,"$$")
  	F i=1:1:Len D
  	.S Str=$p(GenericList,"$$",i)
  	.S Data=$p(Str,"^",1)
  	.S Attribute=$p(Str,"^",2)
  	.S:(FormDic=Data) Flag=Attribute
	.Q:Flag=1
	Q Flag
}

/* 
/// Descritp:  插入敏感词提示记录表
/// Input:     mListData-EpisodeID^敏感词^操作人^操作日期^操作时间
/// Ouput:     
/// w ##Class(web.DHCADVCOMMONPART).InsAdvSenWordRecord("14","")
ClassMethod InsAdvSenWordRecord(mListData As %String) As %String
{
	n (mListData)
	s EpisodeID=$p(ListData,"^",1)      ///EpisodeID
	s SWRText=$p(ListData,"^",2)       ///敏感词
	s SWROperator=$p(ListData,"^",3)       ///操作人
	s SWRRecordDate=$p(ListData,"^",4)       ///操作日期
	i SWRRecordDate'="" s SWRRecordDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(SWRRecordDate)
	s SWRRecordTime=$p(ListData,"^",5)      ///操作时间
	s:SWRRecordTime'="" SWRRecordTime=$zth(SWRRecordTime,1)
	&SQL(Insert Into DHC_AdvSenWordRecord(SWR_Adm,SWR_Text,SWR_Operator,SWR_RecordDate,SWR_RecordTime)
		values(:EpisodeID,:SWRText,:SWROperator,:SWRRecordDate,:SWRRecordTime))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
} */
/// Description: 检查事件类型填报权限
/// Creator:     CongYue
/// CreateDate:  2021-04-28
/// Table: 		 DHC_AdrEvtWorkFlow DHC_AdrEvtWorkFlowItm DHC_AdrWorkFlowGrant 
/// Input:  	 EventDr-事件类型ID，LgParam-人员ID^科室ID^安全组ID^医院ID
/// Return： 	 EventDrFlag：1有权限， 0 无权限
/// Others:		 w ##class(web.DHCADVCOMMONPART).ChkEvtWFGrant("10211^178^111^3")
ClassMethod ChkEvtWFGrant(EventDr As %String, LgParam As %String) As %String
{
	n (EventDr,LgParam)
	S Flag=0
	Q:EventDr="" Flag
	S WorkFlowID=""
	F  S WorkFlowID=$o(^DHCADREVTWF(0,"Event",EventDr,WorkFlowID)) Q:+WorkFlowID=0  D
	.Q:+WorkFlowID=0
	.S EvtWorkflowItmID=""
	.S WorkFlowActive=$p(^DHCADREVTWF(WorkFlowID),"^",4) //是否可用
	.Q:WorkFlowActive="N"
	.Q:##class(web.DHCADVCOMMON).CheckWorkItmGrant(WorkFlowID,LgParam,1)=0 ;工作流权限
	.S OrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",WorkFlowID,WorkFlowID,""))
	.Q:OrderNo=""
	.S Sub=$o(^DHCADREVTWFI(0,"LevOrderNo",WorkFlowID,WorkFlowID,OrderNo,""))
	.Q:Sub=""
	.S EvtWorkflowItmID=WorkFlowID_"||"_Sub
	.S:##class(web.DHCADVCOMMON).CheckWorkItmGrant(EvtWorkflowItmID,LgParam,2)=0 EvtWorkflowItmID="" ;工作流项目权限
	.S:EvtWorkflowItmID'="" Flag=1
	Q Flag
}

/// Description: 获取报告 处理人id,处理科室id
/// Creator:     CongYue
/// CreateDate:  2018-02-07
/// Table:		 DHC_MedAdrRepAudit
/// Input:  	 报告id ，报告类型id，报告状态id
/// Return: 	 报告 处理人id,处理科室id
/// Others:		 w ##class(web.DHCADVCOMMONPART).GetNowRepNextLoc("16","93","19||2")
ClassMethod GetNowRepNextLoc(RepDr As %String, RepTypeDr As %String, Status As %String = "") As %String
{
	N (RepDr,RepTypeDr,Status)
	S MedadrID="",LocAdvice="",LocStatus="",NextLocDr=""
	F  S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepDr,MedadrID),-1) Q:((MedadrID="")||(LocAdvice'=""))  D
	.Q:+MedadrID=0
	.S MedadrReceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9)
	.Q:MedadrReceivedr'="4"
	.S LocAdvice=$p(^DHCMEDREPADT(MedadrID),"^",8)
	.S MedadrStatus=$p(^DHCMEDREPADT(MedadrID),"^",3)
	.Q:(Status'="")&&(MedadrStatus'=Status)
	.S RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	.Q:RepCancelflag="Y"
	.S NextLocDr=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	
	Q NextLocDr
}

}
