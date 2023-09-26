Import sqluser

/// Creator: 	  bianshuai
/// CreateDate:   2019-04-16
/// Descript: 	  mdt会诊查询类
Class web.DHCMDTDocAppAut Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCMDTDocAppAut).JsonListAutType()
ClassMethod JsonListAutType()
{
	w "["
	w ##class(web.DHCAPPJsonCommon).getJsonData("value^text","1^医院")
	w ","	
	w ##class(web.DHCAPPJsonCommon).getJsonData("value^text","2^科室")
	w ","
	w ##class(web.DHCAPPJsonCommon).getJsonData("value^text","3^安全组")
	w ","
	w ##class(web.DHCAPPJsonCommon).getJsonData("value^text","4^人员")
	w "]"
	q ""
}

/// w ##class(web.DHCMDTDocAppAut).JsonListAutPointer(2,"BQ")
ClassMethod JsonListAutPointer(TypeID, q = "")
{
	n (TypeID,q)
	s q=$ZCONVERT(q,"U")
	s MethodName=$case(TypeID,1:"ListHosp",2:"ListLoc",3:"ListGroup",4:"ListUser",:"")
	s MethodName="d ##class(web.DHCMDTDocAppAut)."_MethodName_"("""_q_""")"
	x MethodName
	q ""
}

/// Return
/// d ##class(web.DHCMDTDocAppAut).ListHosp()
ClassMethod ListHosp(q = "")
{
	 n (q)
	 w "["
	 s Count=0
	 s ID=0
     f  s ID=$o(^CT("HOSP",ID)) q:ID=""  d
     .s Code=$p(^CT("HOSP",ID),"^",1)
     .s Desc=$P(^CT("HOSP",ID),"^",2)
     .s edDate=$p(^CT("HOSP",ID),"^",10) //hxy 2020-06-05 st
   	 .q:(edDate'="")&(edDate<+$h) //ed
     .s AllDesc=Code_Desc
	 .s Tmp=ID_"^"_Desc
	 .q:(q'="")&(AllDesc'[q)
	 .s Count = Count+1
 	 .w $case(Count,1:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	 w "]"
	 q ""
}

/// Return
/// d ##class(web.DHCMDTDocAppAut).ListLoc("nk")
ClassMethod ListLoc(q = "")
{
	 n (q)
	 s input=$ZCVT(q,"U")
	 w "["
	 s Count=0
	 s ID=0
     f  s ID=$o(^CTLOC(ID)) q:ID=""  d
     .s Code=$p(^CTLOC(ID),"^",43)
     .s Desc=$P(^CTLOC(ID),"^",2)
     .s AllDesc=Code_Desc
	 .s Tmp=ID_"^"_Desc
	 .q:(input'="")&($ZCVT(AllDesc,"U")'[input)
	 .s Count = Count+1
 	 .w $case(Count,1:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	 w "]"
	 q ""
}

/// Return
/// d ##class(web.DHCMDTDocAppAut).ListGroup()
ClassMethod ListGroup(q = "")
{
	 n (q)
	 w "["
	 s Count=0
	 s ID=0
     f  s ID=$o(^SSU("SSGRP",ID)) q:ID=""  d
     .s Code="" ;$p(^SSU("SSGRP",ID),"^",124)
     .s Desc=$P(^SSU("SSGRP",ID),"^",1)
     .s AllDesc=Code_Desc
	 .s Tmp=ID_"^"_Desc
	 .q:(q'="")&($ZCONVERT(AllDesc,"U")'[q)
	 .s Count = Count+1
 	 .w $case(Count,1:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	 w "]"
	 q ""
}

/// Return
/// d ##class(web.DHCMDTDocAppAut).ListUser()
ClassMethod ListUser(q = "")
{
	 n (q)
	 w "["
	 s Count=0
	 s ID=0
     f  s ID=$o(^SSU("SSUSR",ID)) q:ID=""  d
     .s UserNo = $p(^SSU("SSUSR",ID),"^",1)
     .s Code=$p(^SSU("SSUSR",ID),"^",105)
     .s Desc=$P(^SSU("SSUSR",ID),"^",2)
     .s AllDesc=$ZCONVERT(UserNo,"U")_Desc
	 .q:(q'="")&(AllDesc'[q)
	 .s Desc=Desc_"【"_UserNo_"】"
	 .s Tmp=ID_"^"_Desc
	 .s Count = Count+1
 	 .w $case(Count,1:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	 w "]"
	 q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		mdt成员科室
/// w ##class(web.DHCMDTDocAppAut).QryDocAutItm("12","1","6")
ClassMethod QryDocAutItm(rows As %String, page As %String, GropID As %String) As %String
{
	N (rows, page, GropID)
	s End = page*rows
	s Start=(page-1)*rows+1
	
    k TmpItemDet
  
	s H=0,Count=0
	s ID=""
	f  s ID=$o(^DHCMDTDAA(0,"Group",GropID,ID)) q:ID=""  d
	.s TypeID=$p(^DHCMDTDAA(ID),"^",2)    ///类型
	.s Type=$case(TypeID,1:"医院",2:"科室",3:"安全组",4:"人员")
	.s PointerID=$p(^DHCMDTDAA(ID),"^",3)    ///指针
	.s Pointer=""
	.s:TypeID=1 Pointer=$p($g(^CT("HOSP",PointerID)),"^",2)
	.s:TypeID=2 Pointer=$p($g(^CTLOC(PointerID)),"^",2)
	.s:TypeID=3 Pointer=$p($g(^SSU("SSGRP",PointerID)),"^",1)
	.s:TypeID=4 Pointer=$p($g(^SSU("SSUSR",PointerID)),"^",2)_"【"_$p($g(^SSU("SSUSR",PointerID)),"^",1)_"】"
	.s ListData=ID_"^"_TypeID_"^"_Type_"^"_PointerID_"^"_Pointer
	.s H=H+1
	.s TmpItemDet(H)=ListData
	.
	
	///转换数据为Json格式
	S ListTitle="ID^TypeID^Type^PointerID^Pointer"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(H) //输出json前缀串
	s Index=""
	f  s Index=$o(TmpItemDet(Index)) q:Index=""  d
	.s ListData=$g(TmpItemDet(Index))
	.s Count = Count+1
	.q:(Count<Start)||(Count>End)
	.I Count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	q ""
}

/// w ##class(web.DHCMDTDocAppAut).QryDocAutDicItm(11)
ClassMethod QryDocAutDicItm(DARowID)
{
	n (DARowID)
    k TmpItemDet
	s H=0,Count=0
	s Sub=""
	f  s Sub=$o(^DHCMDTDAA(DARowID,"I",Sub)) q:Sub=""  d
	.s DicItmID=$p(^DHCMDTDAA(DARowID,"I",Sub),"^",1)
	.s DicItm=$p($g(^DHCMDTDI(+DicItmID)),"^",2)
	.s ID=DARowID_"||"_Sub
	.s ListData=ID_"^"_DicItm_"^"_DicItmID
	.s H=H+1
	.s TmpItemDet(H)=ListData
	.
	
	///转换数据为Json格式
	S ListTitle="ID^DicItm^DicItmID"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(H) //输出json前缀串
	s Index=""
	f  s Index=$o(TmpItemDet(Index)) q:Index=""  d
	.s ListData=$g(TmpItemDet(Index))
	.s Count = Count+1
	.I Count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	q ""
}

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
	.s Err=..isAutExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Descript:检查是否重复
ClassMethod isAutExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	 /// ID
	s GropID=$p(mParam,"^",2)    /// 病种组
	s TypeID=$p(mParam,"^",3)    /// 类型
	s PointerID=$p(mParam,"^",4) /// 指针
	/// 新记录
	Q:(ID="")&($d(^DHCMDTDAA(0,"GroupType",GropID,TypeID,PointerID))) "-1"
	Q:ID="" 0
	
	/// 修改记录
	s TmpTypeID=$p($g(^DHCMDTDAA(ID)),"^",2)    //类型
	s TmpPointerID=$p($g(^DHCMDTDAA(ID)),"^",3) //指针
	Q:(TmpTypeID'=TypeID)&($d(^DHCMDTDAA(0,"GroupType",GropID,TypeID,PointerID))) "-1"
	Q:(TmpPointerID'=PointerID)&($d(^DHCMDTDAA(0,"GroupType",GropID,TypeID,PointerID))) "-1"
	Q 0
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTDocAppAut).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s GroupId=$p(mParam,"^",2)   ///分组ID
	s TypeID=$p(mParam,"^",3) 
	s PointerID=$p(mParam,"^",4) 
 	&SQL(INSERT INTO DHC_MDTDocAppAut(DA_Group_Dr, DA_Type, DA_Pointer) 
 		VALUES(:GroupId,:TypeID,:PointerID))
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTDocAppAut).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	 ///ID
	s GroupId=$p(mParam,"^",2)   ///分组ID
	s TypeID=$p(mParam,"^",3) 
	s PointerID=$p(mParam,"^",4) 
	&SQL(Update DHC_MDTDocAppAut Set DA_Group_Dr=:GroupId,DA_Type=:TypeID,DA_Pointer=:PointerID WHERE DA_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTDocAppAut).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTDocAppAut Where DA_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		mdt疑难病种分组与号别关联表
/// w ##class(web.DHCMDTDocAppAut).saveAut("^3^1")
ClassMethod saveAut(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.;s Err=..isExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insertAut(mdata)
	.e  d
	..s Err=..updateAut(mdata)
	Q Err
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTDocAppAut).insert("")
ClassMethod insertAut(mParam As %String) As %String
{
	n (mParam)
	s AppUserID=$p(mParam,"^",2)  
	s DicItmID=$p(mParam,"^",3)
	s ChildSub=$o(^DHCMDTDAA(AppUserID,"I",""),-1)+1
	b ;err
 	&SQL(INSERT INTO DHC_MDTDocAppAutItm (DI_ParRef_Dr , DI_ChlidSub,DI_AutType_Dr ) 
 		VALUES(:AppUserID,:ChildSub,:DicItmID))
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTDocAppAut).update("")
ClassMethod updateAut(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	 ///ID
	s AppUserID=$p(mParam,"^",2)  
	s DicItmID=$p(mParam,"^",3)
	&SQL(Update DHC_MDTDocAppAutItm Set DI_AutType_Dr=:DicItmID WHERE DI_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTDocAppAut).delete("1")
ClassMethod deleteAut(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTDocAppAutItm Where DI_RowID=:ID)
	Q SQLCODE
}

}
