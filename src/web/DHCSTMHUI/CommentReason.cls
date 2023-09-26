Import sqluser

Class web.DHCSTMHUI.CommentReason Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:获取点评不合格原因tree信息
/// Creator:	wxj
/// CreateDate:	2019-10-17
/// Table:		DHC_MatCNT_Reason
/// Input:		tree节点id(为空时显示所有)
/// Output:		
/// d ##class(web.DHCSTMHUI.CommentReason).GetComReasonInfo("")
ClassMethod GetComReasonInfo(ParentId = "") [ ProcedureBlock = 1 ]
{
	s id=$p(ParentId,"-")
	s rowid=$p(ParentId,"-",2)
	
	i ParentId="" d
	.w "[{""id"":""AllMCR"",""text"":""点评不合格原因"",""iconCls"":""icon-sum"",""children"":"
	.d ..GetComReasonInfo("AllMCR")
	.w "}]"
	q:ParentId=""
	
	s result=##class(%Library.ResultSet).%New()
	i id="AllMCR" d
	.s sqlStr="select 'MCR-'||ID as RowId, MATCR_Code as Code, MATCR_Desc as Description From DHC_MatCNT_Reason where MATCRID_DR is null order by MATCR_Desc"
	e  i id="MCR" d
	.s sqlStr="select 'MCR-'||ID as RowId, MATCR_Code as Code, MATCR_Desc as Description From DHC_MatCNT_Reason where MATCRID_DR="_rowid_" order by MATCR_Desc"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	w "["
	While(result.Next())
	{
		s Id=result.Data("RowId")
		s Token=$p(Id,"-",1)
		s TmpRowId=+$p(Id,"-",2)
		continue:TmpRowId=0
		continue:(Token="MCR")&&('$d(^User.DHCMatCNTReasonD(TmpRowId)))
		s Desc=result.Data("Description")
		&sql(select %id from DHC_MatCNT_Reason where MATCRID_DR=:TmpRowId)
		s IsParent=$s(SQLCODE=0:"Y",1:"N")
		s IconCls="icon-star-yellow"
		s count=count+1
		i count=1 w "{"
		e  w ",{"
		w """id"":"""_Id_""",""text"":"""_Desc_""""_",""iconCls"":"""_IconCls_""""
		i (IsParent="Y") d
		.w ",""children"":"
		.d ..GetComReasonInfo(Id)
		w "}"
	}
	d result.Close()
	w "]"
}

/// Description: 新建点评不合格原因
/// Creator: wxj
/// CreateDate: 2019-10-17
/// Table: DHC_MatCNT_Reason
/// Input: Strparam(代码^名称^上层分类rowid)
/// Return: "":成功, '="":失败信息
ClassMethod AddMatComReason(StrParam) As %String
{
	n (StrParam)
	s NewCode=$p(StrParam,"^",1)
	s NewDesc=$p(StrParam,"^",2)
	s ParentId=$p(StrParam,"^",3)	
	s ret=""
	s $ZT=..sssError()
	ts
	&sql(select ID into:TmpId from DHC_MatCNT_Reason where MATCR_Code=:NewCode)
	s:(TmpId'="") ret="代码重复!"
	&sql(select ID into:TmpId from DHC_MatCNT_Reason where MATCR_Desc=:NewDesc)
	s:(TmpId'="") ret="描述重复!"
	q:ret'="" ret
	&sql(Insert into DHC_MatCNT_Reason(MATCR_Code, MATCR_Desc, MATCRID_DR)
		values (:NewCode,:NewDesc,:ParentId))
	i SQLCODE s ret="保存失败!"
	i ret'="" tro  q ret
	tc
	q ret
}

/// Description: 修改点评不合格原因
/// Creator: wxj
/// CreateDate:	2019-10-17
/// Input: StrParam(rowid^代码^名称)
/// Return: "":成功, '="":失败信息
ClassMethod UpdateMatComReason(StrParam As %String) As %Library.String
{
	n (StrParam,%session)
	s rowid=$p(StrParam,"^",1)
	s code=$p(StrParam,"^",2)
	s desc=$p(StrParam,"^",3)
	q:rowid="" "信息有误!"
	q:code="" "代码为空!"
	q:desc="" "名称为空!"
	
	s ret=""
	s $ZT=..sssError()
	&sql(select * from DHC_MatCNT_Reason where (MATCR_Code=:code or MATCR_Desc=:desc) and %id<>:rowid)
	q:SQLCODE=0 "信息重复!"
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatCNT_Reason",rowid)
	&sql(Update DHC_MatCNT_Reason set MATCR_Code=:code,MATCR_Desc=:desc where ID=:rowid)
	i SQLCODE'=0  d
	.s ret="更新失败!"
	e  d
	.d ##class(Log).SaveLog("DHC_MatCNT_Reason","User.DHCMatCNTReason","点评不合格原因信息",rowid,desc,"U","",OldJsonStr)
	q ret
}

/// Description: 获取点评不合格原因信息
/// Creator: wxj
/// CreateDate:	2019-10-17
/// Input: RowId
/// Return: 代码^名称
/// w ##class(web.DHCSTMHUI.CommentReason).GetMatComReason(4)
ClassMethod GetMatComReason(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	q:'$d(^User.DHCMatCNTReasonD(RowId)) ""
	s Code=$List(^User.DHCMatCNTReasonD(RowId),2)
	s Desc=$List(^User.DHCMatCNTReasonD(RowId),3)
	s result=Code_"^"_Desc
	q result
}

/// Description: 将点评不合格原因上下级进行关联
/// Creator: wxj
/// CreateDate:	2019-10-17
/// Table: DHC_MatCNT_Reason
/// Input: 上级分类id, 本级分类id
/// Return: "":成功, '="":失败信息
ClassMethod UpdateParMCR(ParID, RowId) As %String
{
	n (ParID,RowId)
	q:RowId="" -1
	&sql(update DHC_MatCNT_Reason set MATCRID_DR=:ParID where %ID=:RowId)
	q:SQLCODE "修改失败!"
	q ""
}

}
