Import sqluser

Class web.DHCADVAUTLOC Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存[科室维护]
/// Creator:     CongYue
/// CreateDate:  2018-01-12
/// Table: 		 DHC_AdvAutLoc
/// Input:  	 DataList: 科室维护数据信息, 以字符"^"分割,格式为：代码^描述&&代码^描述,
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVAUTLOC).SaveAutLocList("^内科^内科^^Y")
ClassMethod SaveAutLocList(DataList As %String) As %String
{
	N (DataList)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDeal(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdAutLoc(TmpStr)
	.E  D
	..S Err=..InsAutLoc(TmpStr)
	Q Err
}

/// Description: 保存[检查代码是否重复]
/// Creator:     CongYue
/// CreateDate:  2018-01-12
/// Table: 		 DHC_AdvAutLoc
/// Others:		 w ##class(web.DHCADVAUTLOC).CheckRepeatDeal("17^其他^其他^1^Y")
ClassMethod CheckRepeatDeal(TmpStr As %String) As %String
{
	N (TmpStr)
	s AutLID=$p(TmpStr,"^",1)   		///ID
	s AutLCode=$p(TmpStr,"^",2)   	///代码
	S AutLParentDr=$p(TmpStr,"^",4) //父级id
	S id=$o(^DHCADVAUTLOC(0,"Code",AutLCode,"")) //相同code的数据id
	S parentid=""
	s:id'="" parentid=$p($g(^DHCADVAUTLOC(id)),"^",3)    //相同code的数据父级id
	/// 新记录
	q:(AutLID="")&(parentid'="")&(parentid=AutLParentDr) "-1"
	q:AutLID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCADVAUTLOC(AutLID)),"^",1)    //代码
	s parent=$p($g(^DHCADVAUTLOC(AutLID)),"^",3)    //父级id
	q:(AutLCode'=Code)&(parentid'="")&(parentid=parent) "-2"
	q 0
}

/// Description: 更新[科室维护]
/// Creator:     CongYue
/// CreateDate:  2018-01-12
/// Table: 		 DHC_AdvAutLoc
/// Input:  	 DataList: 科室维护数据信息, 以字符"^"分割,格式为：id^代码^描述,
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVAUTLOC).UpdAutLoc("")
ClassMethod UpdAutLoc(DataList As %String) As %String
{
	N (DataList)
	S AutLID=$p(DataList,"^",1)
	S AutLCode=$p(DataList,"^",2)
	S AutLDesc=$p(DataList,"^",3)
	S AutLParentDr=$p(DataList,"^",4)
	S AutLActive=$p(DataList,"^",5)
	&SQL(Update DHC_AdvAutLoc Set AUTL_Code=:AutLCode, AUTL_Desc=:AutLDesc, AUTL_ParentDr=:AutLParentDr, AUTL_ActiveFlag=:AutLActive WHERE AUTL_RowID=:AutLID)
 	Q SQLCODE
}

/// Description: 增加[科室维护]
/// Creator:     CongYue
/// CreateDate:  2018-01-12
/// Table: 		 DHC_AdvAutLoc
/// Input:  	 DataList: 科室维护数据信息, 以字符"^"分割,格式为：id^代码^描述,
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVAUTLOC).InsAutLoc("")
ClassMethod InsAutLoc(DataList As %String) As %String
{
	N (DataList)
	S AutLCode=$p(DataList,"^",2)
	S AutLDesc=$p(DataList,"^",3)
	S AutLParentDr=$p(DataList,"^",4)
	S AutLActive=$p(DataList,"^",5)
 	&SQL(INSERT INTO DHC_AdvAutLoc(AUTL_Code,AUTL_Desc,AUTL_ParentDr,AUTL_ActiveFlag) VALUES(:AutLCode,:AutLDesc,:AutLParentDr,:AutLActive))
 	Q SQLCODE
}

/// Description: 删除 [科室维护]
/// Creator:     CongYue
/// CreateDate:  2018-01-12
/// Table: 		 DHC_AdvAutLoc
/// Input:   	 表的id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVAUTLOC).DelAutLoc("1")
ClassMethod DelAutLoc(AutLID As %String) As %String
{
	N (AutLID)
	q:$d(^DHCADVAUTLOC(0,"ParentDr",AutLID)) -1
	&SQL(Delete From DHC_AdvAutLoc Where AUTL_RowID=:AutLID)
	Q SQLCODE
}

/// Description: 查询[科室维护]
/// Creator:     CongYue
/// CreateDate:  2018-01-12
/// Table: 		 DHC_AdvAutLoc
/// Input:  	 params：订单信息，以字符"^"分割,格式为：代码^描述,
/// Output:  	 DHC_AdvMedUseLink表中的数据信息   
/// Others:		 w ##class(web.DHCADVAUTLOC).QueryMedUseLink("12","1","")
ClassMethod QueryAutLoc(rows = 10, page = 1, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S code=$p(params,"^",1)
    S desc=$p(params,"^",2)
	S h=0,count=0
	S ID="0"
	F  S ID=$o(^DHCADVAUTLOC(ID)) Q:ID=""  D
	.S Code=$p(^DHCADVAUTLOC(ID),"^",1) //代码
	.S Desc=$p(^DHCADVAUTLOC(ID),"^",2) //描述
	.S Parent=$p(^DHCADVAUTLOC(ID),"^",3) //描述
	.S Active=$p(^DHCADVAUTLOC(ID),"^",4) //描述
	.Q:(code'="")&(Code'[code)
	.Q:(desc'="")&(Desc'[desc)
	.Q:(Parent'="")
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc_"^"_Parent_"^"_Active
	.S ^TMP("DHCADV","web.DHCADVAUTLOC","QueryAutLoc",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Parent^Active"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVAUTLOC","QueryAutLoc",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVAUTLOC","QueryAutLoc",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 查询[科室维护项目]
/// Creator:     CongYue
/// CreateDate:  2018-01-12
/// Table: 		 DHC_AdvAutLoc
/// Input:  	 主表的id
/// Output:  	 DHC_AdvMedUseLinkItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVAUTLOC).QueryAutLocItm("12","1","1")
ClassMethod QueryAutLocItm(rows = 10, page = 1, AutLParentID As %String) As %String
{
	N (rows,page,AutLParentID)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S h=0,count=0
	S ID="0"
	F  S ID=$o(^DHCADVAUTLOC(0,"ParentDr",AutLParentID,ID)) Q:ID=""  D
	.S Code=$p(^DHCADVAUTLOC(ID),"^",1) //代码
	.S Desc=$p(^DHCADVAUTLOC(ID),"^",2) //描述
	.S Parent=$p(^DHCADVAUTLOC(ID),"^",3) //描述
	.S Active=$p(^DHCADVAUTLOC(ID),"^",4) //描述
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc_"^"_Parent_"^"_Active
	.S ^TMP("DHCADV","web.DHCADVAUTLOC","QueryAutLocItm",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Parent^Active"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVAUTLOC","QueryAutLocItm",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVAUTLOC","QueryAutLocItm",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCADV","web.DHCADVAUTLOC","QueryAutLoc",pid)
	k ^TMP("DHCADV","web.DHCADVAUTLOC","QueryAutLocItm",pid)
}

}
