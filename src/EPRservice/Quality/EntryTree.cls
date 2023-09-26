/// Class Name:		EPRservice.Quality.EntryTree
/// Description:	质控手工评分项目树(JSON)
/// Author:			Zuoxiang Xie
/// Create Date:	2010-07-26
/// Version:	
Class EPRservice.Quality.EntryTree Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	// 获取请求参数
	s RuleID = $g(%request.Data("RuleID",1),"-1")
	s NodeInfo = $g(%request.Data("node",1),"-1")
	q:(RuleID = -1)||(NodeInfo = -1) $$$OK 

	d ..GetJSON(RuleID,NodeInfo)
	
	q $$$OK
}

/// Desc:	根据主观评分质控标准RowID和父节点ID获取整棵子树JSON串;
/// Input:	ARuleID为主观评分标准RowID;
/// 		ANodeInfo为主观评分项目树父节点ID;
/// Debug: 	w ##Class(EPRservice.Quality.EntryTree).GetJSON(11,"root^0")
ClassMethod GetJSON(ARuleID As %String, ANodeInfo As %String)
{
	
	s StructID = ""
	s NodeType = $p(ANodeInfo,"^",1)
	s:(NodeType = "CG") StructID = $p(ANodeInfo,"^",2)
	
	// 判断请求条件
	s objRule = $g(^DHCEPRM.QualityRuleD(+ARuleID))
	q:(objRule = "") $$$OK
	
	s IsRuleActive = $list(objRule,4)
	q:(IsRuleActive '= "Y") 
	
	// 判断结点类型
	if (NodeType = "RT") || (NodeType = "root")
	{
		// 根结点
		w "[" 
		
		s RuleTitle = $list(objRule,2)
		
		s ParentStructID = $list(objRule,3)
		q:(ParentStructID = "") $$$OK
				
		w "{"
		w "id:'"_"RT"_"^"_ARuleID_"'"
		w ",text:'"_RuleTitle_"'" 
		w ",children:"
		d ..GetChildNodes(ARuleID,ParentStructID)
		w "}"
		
		w "]"
	}
	else
	{
		// 目录结点（不会包含质控项目结点，由前台JS控制）
		d ..GetChildNodes(ARuleID,StructID)
	}
}

/// Desc:	根据主观评分质控标准RowID和父节点ID递归获取子树JSON串;
/// Input:	ARuleID为主观评分标准RowID;
/// 		ANodeInfo为主观评分项目树父节点ID;
/// Debug:	w ##Class(EPRservice.Quality.EntryTree).GetChildNodes("11","8")
ClassMethod GetChildNodes(ARuleID As %String, AStructID As %String) As %String
{
	w "["
	
	s count = 0
	s isFirstNode = 1
	// 加载当前目录的子目录结构
	s StructID=""
	for {
		s StructID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AStructID,StructID))
		q:(StructID = "")

		s objStruct = $g(^DHCEPRM.QualityStructD(StructID))
		continue:(objStruct = "")
		
		s IsActive = $list(objStruct,8)
		continue:(IsActive '= "Y")
		
		s StructName = $list(objStruct,1)
		
		// 判断当前参与循环的质控结构（包括子结构）是否挂有质控项目
		s HasEntry = ..CheckStructHasEntry(ARuleID,StructID)
		if (+HasEntry > 0)
		{
			if (isFirstNode = 0) {w ","}
			
			w "{"
			w "id:'"_"CG"_"^"_StructID_"'"
			w ",text:'"_StructName_"'"
			w "}"
			
			s isFirstNode = 0
			
			s count = count + 1
		}
	}
	
	s isFirstNode = 1
	// 加载当前目录结构下当前标准的质控项目
	s EntryID = ""
	for {
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleStruct"," "_ARuleID," "_AStructID, EntryID))
		q:(EntryID = "")
		
		s objEntry = $g(^DHCEPRM.QualityEntryD(EntryID))
		continue:(objEntry = "")
		
		s EntryIsActive = $list(objEntry,8)
		continue:(EntryIsActive '= "Y")
		
		s PoolID = $list(objEntry,1)	
		s EntryTitle = ##Class(EPRmeta.Quality.QualityPool).GetTitleByPoolID(PoolID)
		
		if (isFirstNode = 0 || count > 0 ) {w ","}
		
		w "{"
		w "id:'"_"LF"_"^"_EntryID_"^"_EntryTitle_"'"
		w ",text:'"_EntryTitle_"'"
		w ",leaf:'ture'"
		w "}"
		
		s isFirstNode = 0
	}
	
	w "]"
}

/// Desc:	递归判断给定质控结构及其子结构是否包含质控项目;
/// Input:	ARuleID为主观评分标准RowID;
/// 		AStructID为质控结构RowID;
/// Output: ret=1包含质控项目; ret=0不包含质控项目
/// Debug: 	w ##Class(EPRservice.Quality.EntryTree).CheckStructHasEntry(2,11)
ClassMethod CheckStructHasEntry(ARuleID As %String, AStructID As %String) As %String
{
	s ret = 0
	s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleStruct"," "_ARuleID," "_AStructID,""))
	if (EntryID '= "")
	{
		s ret = 1
		q ret	
	}
	else
	{
		s flag = 0
		s StructID = ""
		for {
			s StructID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AStructID,StructID))
			q:(StructID = "")
	
			s objStruct = $g(^DHCEPRM.QualityStructD(StructID))
			continue:(objStruct = "")
			
			s IsActive = $list(objStruct,8)
			continue:(IsActive '= "Y")	
			
			s BindCategoryID = $list(objStruct,5)
			s BindCategoryParentId = $list(objStruct,6)
			if (BindCategoryID = "")||(BindCategoryID = $C(0))
			{
				s flag = ..CheckStructHasEntry(ARuleID, StructID)
				q:(flag = 1)	
			}
			else
			{
				s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleStruct"," "_ARuleID," "_StructID, ""))
				if (EntryID '= "")
				{ 
					s flag = 1
					q	
				}
			}	
		}
		s ret = flag
		q ret
	}
}

}
