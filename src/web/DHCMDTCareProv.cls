Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript: 		mdt疑难病种分组与号别关联维护
Class web.DHCMDTCareProv Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		mdt疑难病种分组与号别关联表
/// w ##class(web.DHCMDTCareProv).save("^4^1^480")
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

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTCareProv).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s GroupId=$p(mParam,"^",2)   ///分组ID
	s LocID=$p(mParam,"^",3)     ///科室ID
	s ProvID=$p(mParam,"^",4)    ///号别ID
 	&SQL(INSERT INTO DHC_MDTCareProv(MD_Group_Dr, MD_Loc_Dr, MD_Care_Dr) VALUES(:GroupId,:LocID,:ProvID))
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTCareProv).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	 ///ID
	s GroupId=$p(mParam,"^",2)   ///分组ID
	s LocID=$p(mParam,"^",3)     ///科室ID
	s ProvID=$p(mParam,"^",4)    ///号别ID
	&SQL(Update DHC_MDTCareProv Set MD_Group_Dr=:GroupId, MD_Loc_Dr=:LocID, MD_Care_Dr=:ProvID WHERE MD_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTCareProv).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTCareProv Where MD_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		查询
/// w ##class(web.DHCMDTCareProv).QryCareProv("12","1","")
ClassMethod QryCareProv(rows As %String, page As %String, mID As %String) As %String
{
	N (rows,page,mID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCMDTCP(0,"Group",mID,ID)) Q:ID=""  D
	.s GrpID=$p(^DHCMDTCP(ID),"^",1)    /// 分组ID
	.s LocID=$p(^DHCMDTCP(ID),"^",2)    /// 科室ID
	.s LocDesc = $p(^CTLOC(LocID),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s PrvID=$p(^DHCMDTCP(ID),"^",3)    /// 号别ID
	.s PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	.s HospID = $p(^CTLOC(LocID),"^",22)
	.s h=h+1
	.s ListData=ID_"^"_GrpID_"^"_LocID_"^"_LocDesc_"^"_PrvID_"^"_PrvDesc_"^"_HospID
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^mID^LocID^LocDesc^PrvID^PrvDesc^HospID"
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

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		检查代码、描述是否重复
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	Q 0
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		MDT会诊申请字典项目
/// w ##Class(web.DHCMDTCareProv).jsonCareProv("1")
ClassMethod jsonCareProv(GrpID As %String) As %String
{
	n (GrpID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MD_Care_Dr FROM DHC_MDTCareProv Where MD_Group_Dr="_GrpID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s PrvID = result.Data("MD_Care_Dr")       /// 号别ID
		Continue:PrvID=""
		s PrvDesc = $p($g(^CTPCP(PrvID,1)),"^",2) /// 号别
		s tmp=PrvID_"^"_PrvDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		根据疑难病种取关联号别
/// w ##Class(web.DHCMDTCareProv).GetCareProvByGrp("")
ClassMethod GetCareProvByGrp(mID As %String) As %String
{
	N (mID,%session)
	s ID=$o(^DHCMDTCP(0,"Group",mID,""))
	s PrvID="", PrvDesc="", Address="", RBResID=""
	i ID'="" D
	.s PrvID=$p(^DHCMDTCP(ID),"^",3)    /// 号别ID
	.s PrvLocID = $p(^DHCMDTCP(ID),"^",2)    /// 号别科室
	.s RBResID = $o(^RB("RES",0,"CTPCP",PrvID,PrvLocID,""))   //rbresource 的ID
	.s PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	.s Address = $p(^DHCMDTG(mID),"^",5)
	s PrvDesc=##class(web.DHCMDTCom).GetMulLanTrsDesc("CareProv","",PrvDesc) //hxy 2022-12-08 st
	s Address=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTGroup","MDConsAddress","",Address) //ed
	W ##Class(web.DHCAPPJsonCommon).getJsonData("PrvID^PrvDesc^Address^RBResID",PrvID_"^"_PrvDesc_"^"_Address_"^"_RBResID)
	Q ""
}

Storage Default
{
<Data name="DHCMDTCareProvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMDTCareProvD</DataLocation>
<DefaultData>DHCMDTCareProvDefaultData</DefaultData>
<IdLocation>^web.DHCMDTCareProvD</IdLocation>
<IndexLocation>^web.DHCMDTCareProvI</IndexLocation>
<StreamLocation>^web.DHCMDTCareProvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
