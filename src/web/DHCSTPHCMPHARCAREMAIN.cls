Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2015-04-23
/// Descript: 药学监护基础数据维护类
Class web.DHCSTPHCMPHARCAREMAIN Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取监护级别列表
/// DHC_PHMonLevel
ClassMethod QueryMonLevel(rows As %String, page As %String) As %String
{
	n (rows, page)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global

	s h=0,count=0
	s ID=""
    f  s ID=$o(^DHCPHML(ID)) q:ID=""  d
    .s Code=$p(^DHCPHML(ID),"^",1)
    .s Desc=$p(^DHCPHML(ID),"^",2)
    .s Color=$p(^DHCPHML(ID),"^",3)
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc_"^"_Color
	.s ^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonLevel",pid,h)=TempStr
	
	//q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Color"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonLevel",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonLevel",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// 更新监护级别 DHC_PHMonLevel
ClassMethod SaveMonLevel(DataList) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdMonLevel(TmpStr)
	.e  d
	..s ret=..InsMonLevel(TmpStr)
	q ret
}

/// Descript:update 更新监护级别 DHC_PHMonLevel记录
ClassMethod UpdMonLevel(DataList) As %String
{
	N (DataList)
	s flag=0
	S ID=$p(DataList,"^",1)
	S Code=$p(DataList,"^",2) 
	S Desc=$p(DataList,"^",3)
	S Color=$p(DataList,"^",4)
	;s PHLMID=0 f  s PHLMID=$o(^DHCPHML(PHLMID))  q:PHLMID=""  d //modify:lbb  2018.7.12 监护级别是否存在，不存在后更新对应表数据
	.;s PHMLDesc=$p(^DHCPHML(PHLMID),"^",2)
    .;i PHMLDesc=Desc   s flag=1
    i flag=0 d
	.&SQL(UPDATE DHC_PHMonLevel Set PHML_Code=:Code,PHML_Desc=:Desc,PHML_Color=:Color WHERE PHML_RowID=:ID)
 	Q flag
}

/// w ##class(web.DHCSTPHCMPHARCAREMAIN).InsMonLevel("^004^四级")
/// Descript:Insert 插入监护级别 DHC_PHMonLevel记录
ClassMethod InsMonLevel(DataList) As %String
{
	N (DataList)
	s flag=0
	S Code=$p(DataList,"^",2) 
	S Desc=$p(DataList,"^",3)
	S Color=$p(DataList,"^",4)
	s PHLMID=0 f  s PHLMID=$o(^DHCPHML(PHLMID))  q:PHLMID=""  d //modify:lbb  2018.7.12 监护级别是否存在，不存在后插入对应表数据
	.s PHMLDesc=$p(^DHCPHML(PHLMID),"^",2)
    .i PHMLDesc=Desc   s flag=1
    i flag=0 d
 	.&SQL(INSERT INTO DHC_PHMonLevel(PHML_Code,PHML_Desc,PHML_Color)VALUES(:Code,:Desc,:Color))
 	Q flag
}

/// Descript:delete 更新监护级别 DHC_PHMonLevel记录
ClassMethod DelMonLevel(monLevID) As %String
{
	N (monLevID)
	&SQL(DELETE FROM DHC_PHMonLevel WHERE PHML_RowID=:monLevID)
	Q SQLCODE
}

/// Descript:监护级别combox
ClassMethod SelMonLevel() As %String
{
	n (grpId)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PHML_RowID,PHML_Desc,PHML_Color FROM DHC_PHMonLevel"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s monLevID = result.Data("PHML_RowID")
		s monLevDesc = result.Data("PHML_Desc")
		s monLevColor= result.Data("PHML_Color")
		s tmp=monLevID_"^"_monLevDesc_"^"_monLevColor
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text^color",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text^color",tmp)
	}
	w "]"
}

/// Descript:保存监护标准
ClassMethod SaveMonScope(DataList) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdMonScope(TmpStr)
	.e  d
	..s ret=..InsMonScope(TmpStr)
	q 0
}

/// Descript:更新监护范围
/// Table:DHC_PHMonScope记录
ClassMethod UpdMonScope(DataList) As %String
{
	N (DataList)
	S monScopeID=$p(DataList,"^",1)
	S monScopeCode=$p(DataList,"^",2) 
	S monScopeDesc=$p(DataList,"^",3)
	s monLevID=$p(DataList,"^",4)
	s monSubClassID=$p(DataList,"^",5)
	&SQL(UPDATE DHC_PHMonScope Set PHMS_Code=:monScopeCode,PHMS_Desc=:monScopeDesc,PHMS_ML_DR=:monLevID,PHMS_SubClass_DR=:monSubClassID
 		WHERE PHMS_RowID=:monScopeID)
 	Q SQLCODE
}

/// Descript:更新监护范围
/// Table:DHC_PHMonScope记录
ClassMethod InsMonScope(DataList) As %String
{
	N (DataList)
	S monScopeCode=$p(DataList,"^",2) 
	S monScopeDesc=$p(DataList,"^",3)
	s monLevID=$p(DataList,"^",4)
	s monSubClassID=$p(DataList,"^",5)
 	&SQL(INSERT INTO DHC_PHMonScope(PHMS_Code,PHMS_Desc,PHMS_ML_DR,PHMS_SubClass_DR)
 		VALUES(:monScopeCode,:monScopeDesc,:monLevID,:monSubClassID))
 	Q SQLCODE
}

/// Descript:delete 更新监护范围 DHC_PHMonScope记录
ClassMethod DelMonScope(monScopeID) As %String
{
	N (monScopeID)
	&SQL(DELETE FROM DHC_PHMonScope WHERE PHMS_RowID=:monScopeID)
	Q SQLCODE
}

/// Descript:监护范围列表
ClassMethod QueryMonScope(rows As %String, page As %String, ImonSubClassId As %String, ImonLevId As %String) As %String
{
	n (rows,page,ImonSubClassId,ImonLevId)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global

	s h=0,count=0
	s monScopeID="0"
    f  s monScopeID=$o(^DHCPHMS(monScopeID)) q:monScopeID=""  d
    .s monScopeCode=$p(^DHCPHMS(monScopeID),"^",1) //代码
    .s monScopeDesc=$p(^DHCPHMS(monScopeID),"^",2) //描述
    .s monLevID=$p(^DHCPHMS(monScopeID),"^",3)     //级别
    .q:(ImonLevId'="")&(ImonLevId'=monLevID)
    .s monLevel=$p(^DHCPHML(monLevID),"^",2)
    .s monSubClassID=$p(^DHCPHMS(monScopeID),"^",5)     //分类
    .q:monSubClassID=""
    .q:(ImonSubClassId'="")&(ImonSubClassId'=monSubClassID)
    .i '$d(^DHCPHMSC(monSubClassID)) q
    .s monSubClass=$p(^DHCPHMSC(monSubClassID),"^",2)
	.s h=h+1
	.s TempStr=monScopeID_"^"_monScopeCode_"^"_monScopeDesc_"^"_monLevID_"^"_monLevel_"^"_monSubClassID_"^"_monSubClass
	.s ^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonScope",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="monScopeID^monScopeCode^monScopeDesc^monLevID^monLevel^monSubClassID^monSubClass"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonScope",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonScope",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

// w ##class(web.DHCSTPHCMPHARCAREMAIN).QueryMonItem(1,15,"","")

/// Descript:监护项目列表
ClassMethod QueryMonItem(rows As %String, page As %String, ImonSubClassId As %String, ImonLevId As %String) As %String
{
	n (rows,page,ImonSubClassId,ImonLevId)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global

	s h=0,count=0
	s monItmID="0"
    f  s monItmID=$o(^DHCPHMI(monItmID)) q:monItmID=""  d
    .s monItmCode=$p(^DHCPHMI(monItmID),"^",1) //代码
    .s monItmDesc=$p(^DHCPHMI(monItmID),"^",2) //描述
    .s monLevID=$p(^DHCPHMI(monItmID),"^",3)   //级别
    .q:(ImonLevId'="")&(ImonLevId'=monLevID)
    .s monLevel=$p(^DHCPHML(monLevID),"^",2)
    .s monSubClassID=$p(^DHCPHMI(monItmID),"^",5)   //分类
    .q:monSubClassID=""
    .q:(ImonSubClassId'="")&(ImonSubClassId'=monSubClassID)
    .i '$d(^DHCPHMSC(monSubClassID))  q
    .s monSubClass=$p(^DHCPHMSC(monSubClassID),"^",2)
	.s h=h+1
	.s TempStr=monItmID_"^"_monItmCode_"^"_monItmDesc_"^"_monLevID_"^"_monLevel_"^"_monSubClassID_"^"_monSubClass
	.s ^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonItem",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="monItmID^monItmCode^monItmDesc^monLevID^monLevel^monSubClassID^monSubClass"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonItem",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonItem",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:保存监护项目
/// Table:DHC_PHMonItem
ClassMethod SaveMonItm(DataList) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdMonItem(TmpStr)
	.e  d
	..s ret=..InsMonItem(TmpStr)
	q 0
}

/// Descript:更新监护项目
/// Table:DHC_PHMonItem
ClassMethod UpdMonItem(DataList) As %String
{
	N (DataList)
	S monItmID=$p(DataList,"^",1)
	S monItmCode=$p(DataList,"^",2) 
	S monItmDesc=$p(DataList,"^",3)
	s monLevID=$p(DataList,"^",4)
	s monSubClassID=$p(DataList,"^",5)
	&SQL(UPDATE DHC_PHMonItem Set PHMI_Code=:monItmCode,PHMI_Desc=:monItmDesc,PHMI_ML_DR=:monLevID,PHMI_SubClass_DR=:monSubClassID
 		WHERE PHMI_RowID=:monItmID )
 	Q SQLCODE
}

/// Descript:更新监护项目
/// Table:DHC_PHMonItem
ClassMethod InsMonItem(DataList) As %String
{
	N (DataList)
	S monItmCode=$p(DataList,"^",2) 
	S monItmDesc=$p(DataList,"^",3)
	s monLevID=$p(DataList,"^",4)
	s monSubClassID=$p(DataList,"^",5)
 	&SQL(INSERT INTO DHC_PHMonItem(PHMI_Code,PHMI_Desc,PHMI_ML_DR,PHMI_SubClass_DR)
 		VALUES(:monItmCode,:monItmDesc,:monLevID,:monSubClassID))
 	Q SQLCODE
}

/// Descript:删除监护项目
/// Table:DHC_PHMonItem
ClassMethod DelMonItem(monItmID) As %String
{
	N (monItmID)
	&SQL(DELETE FROM DHC_PHMonItem WHERE PHMI_RowID=:monItmID)
	Q SQLCODE
}

/// Descript:学科分类列表
ClassMethod QueryMonSubClass(rows As %String, page As %String) As %String
{
	n (rows,page)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global

	s h=0,count=0
	s monSubClassID="0"
    f  s monSubClassID=$o(^DHCPHMSC(monSubClassID)) q:monSubClassID=""  d
    .s monSubClassCode=$p(^DHCPHMSC(monSubClassID),"^",1) //代码
    .s monSubClassDesc=$p(^DHCPHMSC(monSubClassID),"^",2) //描述
	.s h=h+1
	.s TempStr=monSubClassID_"^"_monSubClassCode_"^"_monSubClassDesc
	.s ^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonSubClass",pid,h)=TempStr

	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="monSubClassID^monSubClassCode^monSubClassDesc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonSubClass",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonSubClass",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:学科分类combox
ClassMethod SelMonSubClass() As %String
{
	n (grpId)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PHMSC_RowID,PHMSC_Desc FROM DHC_PHMonSubClass"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s monSubClassId = result.Data("PHMSC_RowID")
		s monSubClassDesc = result.Data("PHMSC_Desc")
		s tmp=monSubClassId_"^"_monSubClassDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descript:保存学科分类
ClassMethod SaveMonSubClass(DataList) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdMonSubClass(TmpStr)
	.e  d
	..s ret=..InsMonSubClass(TmpStr)
	q ret
}

/// Descript:更新学科分类
ClassMethod UpdMonSubClass(DataList) As %String
{
	N (DataList)
	s flag=0
	S monSubClassID=$p(DataList,"^",1)
	S monSubClassCode=$p(DataList,"^",2) 
	S monSubClassDesc=$p(DataList,"^",3)
	s ID=0 f  s ID=$o(^DHCPHMSC(ID))  q:ID=""  d   //modify:lbb  2018.7.12 学科分类是否存在，不存在后插入对应表数据
	.s desc=$p(^DHCPHMSC(ID),"^",2)
	.i desc=monSubClassDesc   s flag=1
	i flag=0 d
	.&SQL(UPDATE DHC_PHMonSubClass Set PHMSC_Code=:monSubClassCode,PHMSC_Desc=:monSubClassDesc WHERE PHMSC_RowID=:monSubClassID )
 	Q flag
}

/// w ##class(web.DHCSTPHCMPHARCAREMAIN).SaveMonSubClass("^XNK^心内科")
/// Descript:插入学科分类
ClassMethod InsMonSubClass(DataList) As %String
{
	N (DataList)
	s flag=0
	S monSubClassCode=$p(DataList,"^",2) 
	S monSubClassDesc=$p(DataList,"^",3)
	s ID=0 f  s ID=$o(^DHCPHMSC(ID))  q:ID=""  d  //modify:lbb  2018.7.12 学科分类是否存在，不存在后插入对应表数据
	.s desc=$p(^DHCPHMSC(ID),"^",2)
	.i desc=monSubClassDesc   s flag=1
	i flag=0 d
 	.&SQL(INSERT INTO DHC_PHMonSubClass(PHMSC_Code,PHMSC_Desc) VALUES(:monSubClassCode,:monSubClassDesc))
 	Q flag
}

/// Descript:删除学科分类
ClassMethod DelMonSubClass(monSubClassID) As %String
{
	N (monSubClassID)
	&SQL(DELETE FROM DHC_PHMonSubClass WHERE PHMSC_RowID=:monSubClassID)
	Q SQLCODE
}

/// Descript:学科分类子项目列表
ClassMethod QueryMonSubClassItm(rows As %String, page As %String, monSubClassID As %String, hospID As %String) As %String
{
	n (rows,page,monSubClassID,hospID)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global

	s h=0,count=0
	s Itm="0"
    f  s Itm=$o(^DHCPHMSC(monSubClassID,"I",Itm)) q:Itm=""  d
    .s monSubClassItmID=monSubClassID_"||"_Itm
    .s monLocDr=$p(^DHCPHMSC(monSubClassID,"I",Itm),"^",1) //LocDr
    .s hospital=$p($g(^CTLOC(monLocDr)),"^",22)
	.q:(hospID'="")&(hospID'=hospital)   //过滤病区
    .s monLocDesc=$p(^CTLOC(monLocDr),"^",2)
	.s h=h+1
	.s TempStr=monSubClassItmID_"^"_monLocDr_"^"_monLocDesc
	.s ^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonSubClassItm",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="monSubClassItmID^monLocID^monLocDesc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonSubClassItm",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonSubClassItm",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:保存学科分类子项
ClassMethod SaveMonSubClassItm(DataList) As %String
{
	n (DataList)
	s len=$L(DataList,"%")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"%",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdMonSubClassItm(TmpStr)
	.e  d
	..s ret=..InsMonSubClassItm(TmpStr)
	q ret
}

/// Descript:更新学科分类子项
ClassMethod UpdMonSubClassItm(DataList) As %String
{
	N (DataList)                            //wangxuejian 2016-09-06
	s tmp=0
	S monSubClassItmID=$p(DataList,"^",1)
	S monSubClassID=$p(DataList,"^",2) 
	S monSubLocDr=$p(DataList,"^",3)
	i $d(^DHCPHMSC(0,"LocDr",monSubLocDr,monSubClassID))  d
	.s tmp=1
	i tmp=0 d
	.&SQL(UPDATE DHC_PHMonSubClassItm Set PHMSCI_Loc_Dr=:monSubLocDr WHERE PHMSCI_RowID=:monSubClassItmID )
 	q tmp
}

/// w ##class(web.DHCSTPHCMPHARCAREMAIN).InsMonSubClassItm("^5^110")
/// Descript:插入学科分类子项
ClassMethod InsMonSubClassItm(DataList) As %String
{
	N (DataList)                            //wangxuejian 2016-09-06 
	s tmp=0
	S monSubClassID=$p(DataList,"^",2)   //主表id
	S monSubLocDr=$p(DataList,"^",3)    //科室id
	s PHMSCRowID=""                   //父表的rowid
    i $d(^DHCPHMSC(0,"LocDr",monSubLocDr,monSubClassID))  d
	.s tmp=1
	i tmp=0 d
	.S childSub=$o(^DHCPHMSC(monSubClassID,"I",""),-1)+1    
 	.&SQL(INSERT INTO DHC_PHMonSubClassItm(PHMSCI_PHMSC_Parref,PHMSCI_ChildSub,PHMSCI_Loc_Dr) VALUES(:monSubClassID,:childSub,:monSubLocDr))
 	q tmp
}

/// Descript:获取监护范围列表
/// w ##class(web.DHCSTPHCMPHARCAREMAIN).getMonScopeList("1/2/3","1")
ClassMethod getMonScopeList(monSubClassID As %String, monLevelID As %String) As %String
{
	n (monSubClassID,monLevelID)
	s Len=$l(monSubClassID,"/")					//qunianpeng 2016-09-20  
	s count=0 
	
	i (monSubClassID="")||(monLevelID="") w "[]"
	q:(monSubClassID="")||(monLevelID="") ""
	w "["
	
	f i=1:1:Len d 								//qunianpeng 2016-09-20
	.s PHMSSubClassDR=$p(monSubClassID,"/",i)   //qunianpeng 2016-09-20
	.s monScopeID=""
	.f  s monScopeID=$o(^DHCPHMS(0,"SubClassLevel",PHMSSubClassDR,monLevelID,monScopeID)) q:monScopeID=""  d
	..s monScopeDesc=$p(^DHCPHMS(monScopeID),"^",2)
	..s PHMSCRowID=$p(^DHCPHMS(monScopeID),"^",5)    //取学科分类的ID    qunianpeng 2016-09-20
	..s PHMSCDesc=$p(^DHCPHMSC(PHMSCRowID),"^",2)    //取纳入标准对应的学科分类   qunianpeng 2016-09-20
	..s ListData=PHMSCRowID_"^"_PHMSCDesc_"^"_monScopeID_"^"_monScopeDesc	
	..s count = count+1
	..I count=1 d
	...w ##class(web.DHCSTPHCMCOMMON).getJsonData("PHMSCRowID^PHMSCDesc^monScopeID^monScopeDesc",ListData)
	..e  d
	...w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("PHMSCRowID^PHMSCDesc^monScopeID^monScopeDesc",ListData)
	w "]"
	q ""
}

/// Description:	通过id获取学科分类描述
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-17
/// Input:			学科分类id
/// return:		    学科分类描述
/// other:	
/// Descript:
/// w ##class(web.DHCSTPHCMPHARCAREMAIN).GetScopeDescList("5")
ClassMethod GetScopeDescList(classId As %String) As %String
{
	n (classId)
	i (classId="") w "[]"
	q:(classId="") ""
	
	s Len=$l(classId,"/")					
	s count=0 
	w "["
	f i=1:1:Len d 							
	.s classDesc = $p(^DHCPHMSC($p(classId,"/",i)),"^",2)
	.s listData = $p(classId,"/",i)_"^"_classDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("classId^classDesc",listData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("classId^classDesc",listData)
	w "]"
	
	q ""
}

/// Descript:获取监护项目列表
/// w ##class(web.DHCSTPHCMPHARCAREMAIN).getMonItemList("5","1")
ClassMethod getMonItemList(monSubClassID As %String, monLevelID As %String) As %String
{
	n (monSubClassID,monLevelID)
	s Len=$l(monSubClassID,"/")						//qunianpeng 2016-09-20
	s count=0
	
	i (monSubClassID="")||(monLevelID="") w "[]"
	q:(monSubClassID="")||(monLevelID="") ""
	w "["
	
	f i=1:1:Len d 								//qunianpeng 2016-09-20
	.s PHMISubClassDR=$p(monSubClassID,"/",i)   //qunianpeng 2016-09-20
	.s monItemID=""
	.f  s monItemID=$o(^DHCPHMI(0,"SubClassLevel",PHMISubClassDR,monLevelID,monItemID)) q:monItemID=""  d
	..s monItemDesc=$p(^DHCPHMI(monItemID),"^",2)
	..s monItemUom=$p(monItemDesc,"[]","2")
	..s monItemDesc=$p(monItemDesc,":")_"："
	..s PHMSCRowID=$p(^DHCPHMI(monItemID),"^",5)  	//取学科分类的ID 
	..s PHMSCDesc=$p(^DHCPHMSC(PHMSCRowID),"^",2)   //取监护项目对应的学科分类
	..s ListData=PHMSCRowID_"^"_PHMSCDesc_"^"_monItemID_"^"_monItemDesc_"^"_monItemUom
	..s count = count+1
	..I count=1 d
	...w ##class(web.DHCSTPHCMCOMMON).getJsonData("PHMSCRowID^PHMSCDesc^monItemID^monItemDesc^monItemUom",ListData)
	..e  d
	...w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("PHMSCRowID^PHMSCDesc^monItemID^monItemDesc^monItemUom",ListData)
	w "]"
	q ""
}

/// Description:	获取监护项目列表
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-17
/// Input:			学科分类id
/// return:		    学科分类描述
/// other:		    w ##class(web.DHCSTPHCMPHARCAREMAIN).getMonItemListNew("1","1")
ClassMethod getMonItemListNew(classId As %String, monLevelId As %String) As %String
{
	n (classId,monLevelId)	
		i (classId="")||(monLevelId="") w "[]"
	q:(classId="")||(monLevelId="") ""
	s count=0
	w "["	
	s monItemID=""
	f  s monItemID=$o(^DHCPHMI(0,"SubClassLevel",classId,monLevelId,monItemID)) q:monItemID=""  d
	.s monItemDesc=$p(^DHCPHMI(monItemID),"^",2)
	.s monItemUom=$p(monItemDesc,"[]","2")
	.s monItemDesc=$p(monItemDesc,":")_"："
	.s classDesc=$p(^DHCPHMSC(classId),"^",2)   //取监护项目对应的学科分类
	.s listData=classId_"^"_classDesc_"^"_monItemID_"^"_monItemDesc_"^"_monItemUom
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("classId^classDesc^monItemID^monItemDesc^monItemUom",listData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("classId^classDesc^monItemID^monItemDesc^monItemUom",listData)
	w "]"
	q ""
}

/// Descript:删除学科分类
ClassMethod DelMonSubClassItm(monSubClassItmID) As %String
{
	N (monSubClassItmID)
	&SQL(DELETE FROM DHC_PHMonSubClassItm WHERE PHMSCI_RowID=:monSubClassItmID)
	Q SQLCODE
}

/// Descript:监护学科分类
ClassMethod getJSonMonSubClass(LocID As %String) As %String
{
	N (LocID)
	w "["
	s monSubClassId="",ListData="",count=0
	f  s monSubClassId=$o(^DHCPHMSC(0,"LocDr",LocID,monSubClassId)) q:monSubClassId=""  d
	.s monSubClass=$p(^DHCPHMSC(monSubClassId),"^",2)
	.s ListData=monSubClassId_"^"_monSubClass
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("monSubClassId^monSubClass",ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("monSubClassId^monSubClass",ListData)
	w "]"
	q ""
}

/// Descript:监护学科分类
/// W ##Class(web.DHCSTPHCMPHARCAREMAIN).getMonSubClass("15")
ClassMethod getMonSubClass(LocID As %String) As %String
{
	N (LocID)
	s monSubClassId="",ListData=""
	f  s monSubClassId=$o(^DHCPHMSC(0,"LocDr",LocID,monSubClassId)) q:monSubClassId=""  d
	.s monSubClass=$p(^DHCPHMSC(monSubClassId),"^",2)
	.i ListData="" s ListData=monSubClassId
	.;e  s ListData=ListData_"^"_monSubClassId
	.e  s ListData=ListData_"/"_monSubClassId    //qunianpeng 2016-09-06
	q ListData
}

/// Description:	根据级别id和登录的科室id,取到所有的学科分类
/// Creator:		QuNianpeng（此方法尚未开始使用,用于扩展）
/// CreateDate:		2018-03-17
/// Input:			级别id,科室id
/// return:		   	学科分类
/// w ##class(web.DHCSTPHCMPHARCAREMAIN).GetClassList(1,110)
ClassMethod GetClassList(monLevelId, admLocId) As %String
{
	n (monLevelId,admLocId)
	s count = 0
	w "["
	/// 根据科室id获取所有的学科分类
	s classId = ""
	f  s classId = $o(^DHCPHMSC(0,"LocDr",admLocId,classId))  q:classId=""   d
	./// 使用学科分类id和级别id过滤监护项目和纳入标准中不存在的学科分类
	.q:'$d(^DHCPHMI(0,"SubClassLevel",classId,monLevelId))&('$d(^DHCPHMS(0,"SubClassLevel",classId,monLevelId)))
	.s classCode = $p(^DHCPHMSC(classId),"^",1)
	.s classDesc = $p(^DHCPHMSC(classId),"^",2)
	.s tmpData = classId_"^"_classDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("classId^classDesc",tmpData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("classId^classDesc",tmpData)
	w "]"
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonLevel",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonItem",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonScope",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonSubClass",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPHARCAREMAIN","QueryMonSubClassItm",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^TMP("PHCMADRDICMAIN"))
}

}
