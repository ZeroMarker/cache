Import sqluser

Class web.DHCADVMEDREPCAT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存[医疗不良事件报告分类]
/// Creator:     CongYue
/// CreateDate:  2016-03-24
/// Table: 		 DHC_AdvMedRepCat
/// Input:  	 DataList: 用药环节数据信息, 以字符"^"分割,格式为：代码^描述&&代码^描述,
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPCAT).SaveMedRepCat("^器械填报^器械填报")
ClassMethod SaveMedRepCat(DataList As %String) As %String
{
	N (DataList)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDeal(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdMedRepCat(TmpStr)
	.E  D
	..S Err=..InsMedRepCat(TmpStr)
	Q Err
}

/// Description: 保存[检查代码是否重复]
/// Creator:     CongYue
/// CreateDate:  2016-05-23
/// Table:		 DHC_AdvMedRepCat
/// Others:		 w ##class(web.DHCADVMEDREPCAT).CheckRepeatDeal("2^1^一级^1^16^Y")
ClassMethod CheckRepeatDeal(TmpStr As %String) As %String
{
	N (TmpStr)
	s MrcID=$p(TmpStr,"^",1)   		///ID
	s MrcCode=$p(TmpStr,"^",2)   	///代码
	/// 新记录
	q:(MrcID="")&($d(^DHCADVMEDRCA(0,"Code",$$ALPHAUP^SSUTIL4(MrcCode)))) "-1"
	q:MrcID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCADVMEDRCA(MrcID)),"^",1)    //代码
	q:(MrcCode'=Code)&($d(^DHCADVMEDRCA(0,"Code",$$ALPHAUP^SSUTIL4(MrcCode)))) "-2"
	q 0
}

/// Description: 更新[医疗不良事件报告分类]
/// Creator:     CongYue
/// CreateDate:  2016-03-24
/// Table: 		 DHC_AdvMedRepCat
/// Input:  	 DataList: 用药环节数据信息, 以字符"^"分割,格式为：id^代码^描述,
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPCAT).UpdMedRepCat("")
ClassMethod UpdMedRepCat(DataList As %String) As %String
{
	N (DataList)
	S MrcID=$p(DataList,"^",1)
	S MrcCode=$p(DataList,"^",2)
	S MrcDesc=$p(DataList,"^",3)
	S MrcLevel=$p(DataList,"^",4)
	S MrcLevelrowid=$p(DataList,"^",5)
	S MrcActive=$p(DataList,"^",6)
	&SQL(Update DHC_AdvMedRepCat Set MRC_Code=:MrcCode, MRC_Desc=:MrcDesc,MRC_Level=:MrcLevel, MRC_LevelRowID=:MrcLevelrowid,MRC_ActiveFlag=:MrcActive WHERE MRC_RowID=:MrcID)
 	Q SQLCODE
}

/// Description: 增加[医疗不良事件报告分类]
/// Creator:     CongYue
/// CreateDate:  2016-03-24
/// Table: 		 DHC_AdvMedRepCat
/// Input:  	 DataList: 用药环节数据信息, 以字符"^"分割,格式为：id^代码^描述,
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPCAT).InsMedRepCat("")
ClassMethod InsMedRepCat(DataList As %String) As %String
{

	N (DataList)
	S MrcCode=$p(DataList,"^",2)
	S MrcDesc=$p(DataList,"^",3)
	S MrcLevel=$p(DataList,"^",4)
	S MrcLevelrowid=$p(DataList,"^",5)
	S MrcActive=$p(DataList,"^",6)
	
 	&SQL(INSERT INTO DHC_AdvMedRepCat(MRC_Code,MRC_Desc,MRC_Level,MRC_LevelRowID,MRC_ActiveFlag) VALUES(:MrcCode,:MrcDesc,:MrcLevel,:MrcLevelrowid,:MrcActive))
 	Q SQLCODE
}

/// Description: 删除 [医疗不良事件报告分类]
/// Creator:     CongYue
/// CreateDate:  2016-03-24
/// Table: 	 	 DHC_AdvMedRepCat
/// Input:   	 表的id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDREPCAT).DelMedRepCat("1")
ClassMethod DelMedRepCat(MrcID As %String) As %String
{
	N (MrcID)
	Q:$d(^DHCADVMEDRCA(0,"LevelRowID",MrcID)) "-2"  //  判断此报告分类的信息ID被下一级别的ID占用，不能删除！
	Q:$d(^DHCADVREPMAN(0,"CatDr",MrcID)) "-1" //判断此报告分类是否存在报告使用记录
	&SQL(Delete From DHC_AdvMedRepCat Where MRC_RowID=:MrcID)
	Q SQLCODE
}

/// Description: 查询[医疗不良事件报告分类]
/// Creator:     CongYue
/// CreateDate:  2016-03-24
/// Table: 		 DHC_AdvMedRepCat
/// Input:  	 params：订单信息，以字符"^"分割,格式为：代码^描述,
/// Output:  	 DHC_AdvMedRepCat表中的数据信息   
/// Others:		 w ##class(web.DHCADVMEDREPCAT).QueryMedRepCat1("12","1","")
ClassMethod QueryMedRepCat(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=..NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S h=0,count=0
	S ID=""
	F  S ID=$o(	^DHCADVMEDRCA(0,"LevelRowID",params,ID)) Q:ID=""  D
	.Q:ID=0
	.S Code=$p(^DHCADVMEDRCA(ID),"^",1) //代码
	.S Desc=$p(^DHCADVMEDRCA(ID),"^",2) //描述
	.S Level=$p(^DHCADVMEDRCA(ID),"^",3) //级别
	.S Levelrowid=$p(^DHCADVMEDRCA(ID),"^",4) //上一级别的rowid
	.S Active=$p(^DHCADVMEDRCA(ID),"^",5) //是否可用
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc_"^"_Level_"^"_Levelrowid_"^"_Active
	.S ^TMP("DHCADV","web.DHCADVMEDREPCAT","QueryMedRepCat",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Level^Levelrowid^Active"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVMEDREPCAT","QueryMedRepCat",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVMEDREPCAT","QueryMedRepCat",pid,index))
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

/// Description: 查询[医疗不良事件报告分类]
/// Creator:     CongYue
/// CreateDate:  2016-03-26
/// Table: 		 DHC_AdvMedRepCat
/// Input:  	 params：订单信息，以字符"^"分割,格式为：代码^描述,
/// Output:  	 DHC_AdvMedRepCat表中的数据信息   
/// Others:		 w ##class(web.DHCADVMEDREPCAT).QueryMrcInfo("12","1","")
ClassMethod QueryMrcInfo(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=..NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S h=0,count=0
	S ID=""
	F  S ID=$o(^DHCADVMEDRCA(ID)) Q:ID=""  D
	.Q:ID=0
	.S Code=$p(^DHCADVMEDRCA(ID),"^",1) //代码
	.S Desc=$p(^DHCADVMEDRCA(ID),"^",2) //描述
	.S Level=$p(^DHCADVMEDRCA(ID),"^",3) //级别
	.S Levelrowid=$p(^DHCADVMEDRCA(ID),"^",4) //上一级别的rowid
	.S Active=$p(^DHCADVMEDRCA(ID),"^",5) //是否可用
	.S h=h+1
	.S TempStr=ID_"^"_Desc_"^"_Level_"^"_Levelrowid
	.S ^TMP("DHCADV","web.DHCADVMEDREPCAT","QueryMrcInfo",pid,h)=TempStr
	
	s a=""
	S mdate=""
	Q:h=0 ..getJsonEmptySign(h) //输出json结尾符
	S Title="ID^text^Level^Levelrowid"
	///转换数据为Json格式
	W ..getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVMEDREPCAT","QueryMrcInfo",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVMEDREPCAT","QueryMrcInfo",pid,index))
	.S count = count+1
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ..getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Descript:返回Json串起始符
ClassMethod getJsonStartSign(Count) As %String
{
	N (Count)
	S del=""""
	q "["
}

/// Descript:返回Json串结束符
ClassMethod getJsonEndSign() As %String
{
	q "]"
}

/// Descript:返回Json空串符
ClassMethod getJsonEmptySign(Count) As %String
{
	N (Count)
	S del=""""
	q "[]"
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCADV("DHCADVMEDREPCAT"))
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCADV","web.DHCADVMEDREPCAT","QueryMedRepCat",pid)
	k ^TMP("DHCADV","web.DHCADVMEDREPCAT","QueryMrcInfo",pid)
}

}
