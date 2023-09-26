Import sqluser

Class web.DHCSTMHUI.Util.StkGrp Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_StkCatGroup";

/// Description:取新版多级类组数据
/// Createor:	wangjiabin
/// CreateDate:	2016-03-07
/// Input:		NodeId(SCG-rowid,INCSC-rowid等格式), StrParam(科室^人员^第二科室^类组集合^...), 类组类型(M/O等,缺省为M)
/// Output:		tree-json数据
/// Return：
/// w ##class(web.DHCSTMHUI.Util.StkGrp).GetScgChildNode("AllSCG","392^4642^2^^2","M")
ClassMethod GetScgChildNode(NodeId As %String, StrParam As %String, Type As %String = "M") As %String
{
	n (NodeId,StrParam,Type,%session)
	s NodeType=$p(NodeId,"-",1)
	s NodeRowId=$p(NodeId,"-",2)
	s LocId=$p(StrParam,"^",1)
	s UserId=$p(StrParam,"^",2)
	s xLocId=$p(StrParam,"^",3)
	s ScgSet=$p(StrParam,"^",4)
	s gHopid=$p(StrParam,"^",5) ;登陆医院ID
	s HopId=$p(StrParam,"^",6) ;选取医院ID
	i HopId="" s HopId=gHopid
	s:Type="" Type=..sssCode()
	
	s ScgStr=""
	s Param=LocId_"^"_UserId
	s TmpScgStr=..GetAuthorOnlyScg(Param,Type,HopId)	;仅显示有权限的类组
	;若未授权,取所有类组
	s:TmpScgStr="" TmpScgStr=$$GetAllScgStr(Type)
	i xLocId'="" d
	.s xLocScgStr=..GetAuthorOnlyScg(xLocId_"^",Type)
	.s:xLocScgStr="" xLocScgStr=$$GetAllScgStr(Type)
	.f i=1:1:$l(TmpScgStr,",") d
	..s TmpScg=$p(TmpScgStr,",",i)
	..i (","_xLocScgStr_",")[(","_TmpScg_",") d
	...i ScgStr="" s ScgStr=TmpScg
	...e  s ScgStr=ScgStr_","_TmpScg
	e  d
	.s ScgStr=TmpScgStr
	q:ScgStr="" "[]"
	;获取权限顶层
	s TopAuthorScgStr=""
	f i=1:1:$l(ScgStr,",") d
	.s Scg=$p(ScgStr,",",i)
	.s ParScg=$p($g(^DHCSCG(Scg)),"^",4)
	.i (ParScg="")||((","_ScgStr_",")'[(","_ParScg_",")) d
	..;上级类组非空,或不再该串内,为授权顶级类组
	..i TopAuthorScgStr="" s TopAuthorScgStr=Scg
	..e  s TopAuthorScgStr=TopAuthorScgStr_","_Scg
	q:TopAuthorScgStr="" "[]"
	
	s result = ##class(%Library.ResultSet).%New()
	i NodeType="AllSCG" d
	.s sqlStr="select 'SCG-'||scg_rowid as Id,scg_code as Code, scg_desc as Description From dhc_stkcatgroup where scg_type='"_Type_"' and %id in ("_TopAuthorScgStr_") order by scg_desc"
	e  i NodeType="SCG" d
	.s sqlStr="select 'SCG-'||scg_rowid as Id, scg_code as Code, scg_desc as Description From dhc_stkcatgroup where scg_catgrp_dr="_NodeRowId
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s ResultStr=""
	While(result.Next())
	{
		s Id=result.Data("Id")
		s Token=$p(Id,"-",1)
		s RowId=+$p(Id,"-",2)
		continue:RowId=0
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(..#AppTable,RowId,HopId)
		continue:ShowDataFlag'="Y"
		continue:(LocId'="")&&(Token="SCG")&&((","_ScgStr_",")'[(","_RowId_","))
		;类组集合过滤
		s SCGSet=$p($G(^DHCSCG(RowId)),"^",5)
		continue:(Token="SCG")&&(ScgSet'="")&&((SCGSet="") || (ScgSet'[SCGSet))
		
		s Desc=result.Data("Description")
		s checked="''"
		s Description=Desc
		//拼接Json
		s:(ResultStr'="") ResultStr=ResultStr_","
		s ResultStr=ResultStr_"{"
		s ResultStr=ResultStr_"""id"":"""_""_RowId_""",""text"":"""_Desc_""""
		s ChildStr=..GetScgChildNode(Id,StrParam,Type)
		i ChildStr'="[]"  d
		.s ResultStr=ResultStr_",""children"":"
		.s ResultStr=ResultStr_ChildStr
		s ResultStr=ResultStr_"}"
	}
	s ResultStr="["_ResultStr_"]"
	q ResultStr

GetAllScgStr(Type)
	n (Type)
	s AllScgStr=""
	s ScgId=0
	f  s ScgId=$o(^DHCSCG(ScgId)) q:ScgId=""  d
	.q:(+ScgId'>0)||'$d(^DHCSCG(ScgId))
	.s ScgType=$p($G(^DHCSCG(ScgId)),"^",3)
	.q:ScgType'=Type
	.q:('$d(^DHCSCG(ScgId,"RE"))&&('$d(^DHCSCG(0,"Parent",ScgId))))		;未关联库存分类的,过滤
	.i AllScgStr="" d
	..s AllScgStr=ScgId
	.e  d
	..s AllScgStr=AllScgStr_","_ScgId
	q AllScgStr
}

/// description:获取类组是否在权限内
/// date:		2017-08-28
/// creator:	wangjiabin
/// input:		StrParam(科室^人员^第二科室^类组集合^...), 类组类型(M/O等,缺省为M), 要判断的类组id
/// output:		Y:在权限内, N:不在权限内
/// w ##class(web.DHCSTMHUI.Util.DrugUtil).IsScgAuthor("153","M",6)
ClassMethod IsScgAuthor(StrParam As %String, Type As %String, SCG As %String) As %String
{
	n (StrParam,Type,SCG,%session)
	s LocId=$p(StrParam,"^",1)
	s UserId=$p(StrParam,"^",2)
	s xLocId=$p(StrParam,"^",3)
	s ScgSet=$p(StrParam,"^",4)
	s gHopid=$p(StrParam,"^",5) ;登陆医院ID
	s HopId=$p(StrParam,"^",6) ;选取医院ID
	s:Type="" Type=..sssCode()
	
	s ScgStr=""
	s Param=LocId_"^"_UserId
	s TmpScgStr=..GetAuthorOnlyScg(Param,Type)	;仅显示有权限的类组
	;若未授权,取所有类组
	s:TmpScgStr="" TmpScgStr=$$GetAllScgString(Type)
	
	i xLocId'="" d
	.s xLocScgStr=..GetAuthorOnlyScg(xLocId_"^",Type)
	.s:xLocScgStr="" xLocScgStr=$$GetAllScgString(Type)
	.f i=1:1:$l(TmpScgStr,",") d
	..s TmpScg=$p(TmpScgStr,",",i)
	..i (","_xLocScgStr_",")[(","_TmpScg_",") d
	...i ScgStr="" s ScgStr=TmpScg
	...e  s ScgStr=ScgStr_","_TmpScg
	e  d
	.s ScgStr=TmpScgStr
	
	s ScgStr=..filterScgByHosp(ScgStr,HopId) ;根据院区过滤
	q:(ScgStr="")||((","_ScgStr_",")'[(","_SCG_",")) "N"
	q "Y"
	
GetAllScgString(Type)
	n (Type)
	s AllScgStr=""
	s ScgId=0
	f  s ScgId=$o(^DHCSCG(ScgId)) q:ScgId=""  d
	.q:(+ScgId'>0)||'$d(^DHCSCG(ScgId))
	.s ScgType=$p($G(^DHCSCG(ScgId)),"^",3)
	.q:ScgType'=Type
	.q:('$d(^DHCSCG(ScgId,"RE"))&&('$d(^DHCSCG(0,"Parent",ScgId))))		;未关联库存分类的,过滤
	.i AllScgStr="" d
	..s AllScgStr=ScgId
	.e  d
	..s AllScgStr=AllScgStr_","_ScgId
	q AllScgStr
}

/// 取某用户的授权类组串
/// Author:zhwh
/// Date:2013-07-12
/// Arguments:
///  userRowId - 用户rowid
///  stktype - 类型
/// Return:
///  类组串
///  update: 2014-10-29添加loc  如果人员下未配置 取科室下的权限
///  2016-03-14 修改多级类组后,方法名:GetUserCatGrpStr-->GetUserCatGrpStrOld
ClassMethod GetUserCatGrpStrOld(userRowId As %String, stktype As %String, loc As %String, HopId = "") As %String
{
	n (userRowId,stktype,loc,HopId,%session)
	s result=""
	&Sql(declare userScg cursor for 
		select u_slcg_parref->slcg_stkcatgrp_dr From sqluser.dhc_stklocusercatgrp
		where u_ssusr_dr=:userRowId and u_slcg_parref->slcg_type=:stktype and u_slcg_parref->SLCG_CTLoc_Dr=:loc and U_Active='Y')    
		&sql(open  userScg)
	f  &sql(fetch userScg into :scg) q:SQLCODE  d
	.i result="" s result=+scg
	.e  s result=result_"^"_+scg
	.
	&sql(close userScg)
	i result="" d
	.&Sql(declare userScg2 cursor for 
		select SLCG_StkCatGrp_Dr From DHC_StkLocCatGroup
		where SLCG_Type=:stktype and SLCG_CTLoc_Dr=:loc)    
	.&sql(open userScg2)
	.f  &sql(fetch userScg2 into :scg) q:SQLCODE  d
	..i result="" s result=+scg
	..e  s result=result_"^"_+scg
	.
	.&sql(close userScg2)
	s tmpresult=$tr(result,"^",",")
	s result=..filterScgByHosp(tmpresult,HopId) ;根据院区过滤
	s result=$tr(result,",","^")
	q result
}

/// Description:仅取有权限的类组(叶子类组或其子类组均有权限的),逗号隔开
/// Creator:	wangjiabin
/// CreateDate:	2016-03-10
/// Table:		DHC_StkCatGrpRelations等
/// Input:		StrParam(科室id^人员id^...), 类组类型(M/O等,缺省为M)
/// Output:	
/// w ##class(web.DHCSTMHUI.Util.DrugUtil).GetAuthorOnlyScg("153^541")
ClassMethod GetAuthorOnlyScg(StrParam As %String, Type As %String = "M", HopId = "") As %String
{
	n (StrParam,Type,HopId,%session)
	s:Type="" Type=..sssCode()
	s LocId=$p(StrParam,"^",1)
	s UserId=$p(StrParam,"^",2)
	s ScgStr=..GetUserCatGrpStrOld(UserId,Type,LocId,HopId)	;有权限的底层类组(^隔开)
	s ScgStr=$tr(ScgStr,"^",",")
	q:ScgStr="" ""
	
	;循环遍历所有的类组(新加入的也过滤),若上级类组的孩子都在ScgStr,则将上级类组加入 
	s i=0
	f {
		s i=i+1
		q:i>$l(ScgStr,",")
		s Scg=$p(ScgStr,",",i)
		continue:Scg=""
		s ParScg=$p($G(^DHCSCG(Scg)),"^",4)
		continue:(ParScg="")||((","_ScgStr_",")[(","_ParScg_","))		;已存在的过滤
		s AuthorFlag=$$IsAllChildrenAuthor(ParScg,ScgStr)
		continue:AuthorFlag=0
		s ScgStr=ScgStr_","_ParScg
	}
	s ScgStr=..filterScgByHosp(ScgStr,HopId) ;根据院区过滤
	q ScgStr
IsAllChildrenAuthor(ParScg,ScgStr)
	;判断是否所有的类组均已授权
	n (ParScg,ScgStr)
	s AuthorFlag=1
	s Scg=""
	f  s tmpScg=Scg,Scg=$o(^DHCSCG(0,"Parent",ParScg,Scg)) q:(Scg="")||(tmpScg=Scg)||(AuthorFlag'=1)  d
	.q:('$d(^DHCSCG(Scg,"RE"))&&('$d(^DHCSCG(0,"Parent",Scg))))		;2016-03-15 未关联库存分类且没有子类组的,不考虑
	.i (","_ScgStr_",")'[(","_Scg_",") s AuthorFlag=0
	q AuthorFlag
}

/// Description: 将类组串进行院区隔离筛选
/// Creator:	lihui
/// CreateDate:	20200402
/// Input:		类组ID串
ClassMethod filterScgByHosp(ScgStr, HopId) As %String
{
	n (ScgStr,HopId,%session)
	q:ScgStr="" ""
	s tmpScgStr=""
	f i=1:1:$l(ScgStr,",") d
	.s TmpScg=$p(ScgStr,",",i)
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(..#AppTable,TmpScg,HopId)
	.q:ShowDataFlag'="Y"
	.i tmpScgStr="" s tmpScgStr=TmpScg
	.e  s tmpScgStr=tmpScgStr_","_TmpScg
	q tmpScgStr
}

}
