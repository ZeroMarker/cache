Import SQLUser

/// Creator: 		qqa
/// CreateDate: 	2019-04-25
/// Descript: 		mdt疑难病种分组与号别关联维护
Class web.DHCMDTOrdConfig Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		mdt疑难病种分组与号别关联表
/// w ##class(web.DHCMDTOrdConfig).save("^1^7462||1")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTOrdConfig).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s GroupId=$p(mParam,"^",2)   ///分组ID
	s ArcItemDr=$p(mParam,"^",3) ///医嘱项ID
	s ArcItemNum=$p(mParam,"^",4) ///医嘱项数量
	b ;err
 	&SQL(INSERT INTO DHC_MDTOrdConfig(MD_Group_Dr, MD_ArcItem_Dr,MD_OrdNum) 
 		VALUES(:GroupId,:ArcItemDr,:ArcItemNum))
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTOrdConfig).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	 ///ID
	s GroupId=$p(mParam,"^",2)   ///分组ID
	s ArcItemDr=$p(mParam,"^",3) ///医嘱项ID
	s ArcItemNum=$p(mParam,"^",4) ///医嘱项数量
	&SQL(Update DHC_MDTOrdConfig Set MD_Group_Dr=:GroupId, MD_ArcItem_Dr=:ArcItemDr,MD_OrdNum=:ArcItemNum WHERE MD_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTOrdConfig).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTOrdConfig Where MD_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		查询
/// w ##class(web.DHCMDTOrdConfig).QryList("12","1","1")
ClassMethod QryList(rows As %String, page As %String, mID As %String) As %String
{
	N (rows,page,mID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCMDTOC(0,"Group",mID,ID)) Q:ID=""  D
	.s GrpID=$p(^DHCMDTOC(ID),"^",1)    /// 分组ID
	.s ArciID=$p(^DHCMDTOC(ID),"^",2)    /// 医嘱ID
	.s Arci = $p(^ARCIM(+ArciID,$p(ArciID,"||",2),1),"^",2)
	.s ArciNum = $p(^DHCMDTOC(ID),"^",3)
	.s ListData=ID_"^"_GrpID_"^"_ArciID_"^"_Arci_"^"_ArciNum
	.s h=h+1
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^mID^ArciID^Arci^ArciNum"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(TmpItemDet(index)) Q:index=""  D
	.s ListData=$g(TmpItemDet(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符

	Q ""
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		检查代码、描述是否重复
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	Q 0
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    MDT医嘱项获取
/// Input   : 	 
/// Return  :    JsonList
/// W ##Class(web.DHCMDTOrdConfig).ListArci()
ClassMethod ListArci(q) As %String
{
	n (q)
	s Count = 0
	w "["
	s ArciID=0
	f  s ArciID =$o(^ARCIM(ArciID)) q:ArciID=""  d
	.s ArciSub=0
	.f  s ArciSub =$o(^ARCIM(ArciID,ArciSub)) q:ArciSub=""  d
	..s ArciDesc = $p(^ARCIM(ArciID,ArciSub,1),"^",2)
	..s DateActiveFrom = $p($p(^ARCIM(ArciID,ArciSub,1),"^",13),"Z")
	..Q:(DateActiveFrom'="")&(DateActiveFrom>+$H) //过期退出
	..s DateActiveTo = $p($g(^ARCIM(ArciID,ArciSub,7)),"^",1)
	..Q:(DateActiveTo'="")&(DateActiveTo<+$H) //过期退出
	..s ArcAliasId=""
	..s ArcAliasId = $o(^ARC("ALIAS",0,"ARCIM",ArciID_"||"_ArciSub,""))
	..s:ArcAliasId'="" ArcAlias = $p(^ARC("ALIAS",ArcAliasId),"^",6)
	..s AllArciDesc = ArcAlias_ArciDesc
	..Q:ArciDesc'["会诊"
	..q:(q'="")&&(AllArciDesc'[$$ALPHAUP^SSUTIL4(q))
	..s Count = Count+1
	..s Tmp=ArciID_"||"_ArciSub_"^"_ArciDesc
	..i Count=1 d
	...W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	..e  d
	...W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

}
