Class DHCDoc.DHCDocConfig.CodeTable Extends DHCDoc.Util.RegisteredObject
{

ClassMethod GetCTDefineJSON()
{
	s retObj=[]
	s rs=##class(%ResultSet).%New("web.DHCDocCTCommon:GetDHCDocCTModule")
	d rs.Execute()
	while rs.Next(){
		s ModuleRowId=rs.GetDataByName("ModuleRowId")
		s ModuleDesc=rs.GetDataByName("ModuleDesc")
		s obj={"id":(ModuleRowId),"text":(ModuleDesc),"children":[]}
		s DefineID=0 for{
			s DefineID=$O(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,DefineID)) Q:DefineID=""
			s DefineCode=$p($g(^DHCDocCT("Define",DefineID)),"^",1)
			s DefineDesc=$p($g(^DHCDocCT("Define",DefineID)),"^",2)
			d obj.children.%Push({"id":(ModuleRowId_"."_DefineID),"text":(DefineDesc),"attributes":{"code":(DefineCode)}})
		}
		d retObj.%Push(obj)
	}
	Q retObj.%ToJSON()
}

Query QueryDefineData(DefineRowID = "", DefineCode = "", DefineDesc = "", GroupID = "") As %Query(ROWSPEC = "SubRowID:%String,SubCode:%String,SubDesc:%String,SubStDate:%String,SubEndDate:%String,RowId:%String")
{
}

ClassMethod QueryDefineDataExecute(ByRef qHandle As %Binary, DefineRowID = "", DefineCode = "", DefineDesc = "", GroupID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s DefineCode=$$ALPHAUP^SSUTIL4(DefineCode)
	if (DefineRowID="")&&(DefineCode'=""){
		s DefineRowID=$O(^DHCDocCTi(0,"Define","Code",DefineCode,0))
	}
	s DefineDesc=$$ALPHAUP^SSUTIL4(DefineDesc)
	if (DefineRowID="")&&(DefineDesc'=""){
		s DefineRowID=$O(^DHCDocCTi(0,"Define","Desc",DefineDesc,0))
	}
	s Auth=1
	s:(GroupID'="")&&(DefineRowID'="") Auth=..IsAuth(GroupID,DefineRowID)
	i Auth'=1 Quit $$$OK
	if DefineRowID'=""{
		
		s SubRowID=0 for{
			s SubRowID=$o(^DHCDocCT("DefineData",DefineRowID,"D",SubRowID)) Q:SubRowID=""
			s SubCode=$p($g(^DHCDocCT("DefineData",DefineRowID,"D",SubRowID)),"^",1)
			s SubDesc=$p($g(^DHCDocCT("DefineData",DefineRowID,"D",SubRowID)),"^",2)
			s SubStDate=$p($g(^DHCDocCT("DefineData",DefineRowID,"D",SubRowID)),"^",3)
			s SubEndDate=$p($g(^DHCDocCT("DefineData",DefineRowID,"D",SubRowID)),"^",4)
			s:(SubStDate'="") SubStDate=..%ZD(SubStDate)
			s:(SubEndDate'="") SubEndDate=..%ZD(SubEndDate)
			s RowId=DefineRowID_"||"_SubRowID
			d rows.%Push($LB(SubRowID,SubCode,SubDesc,SubStDate,SubEndDate,RowId))
		}
	}
	Quit $$$OK
}

ClassMethod QueryDefineDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDefineDataExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod SaveTreeNode(ParentNodeId, NodeId, TreeNodeCode, TreeNodeDesc)
{
	Q:(ParentNodeId'="")&&(TreeNodeCode="") "代码不能为空!"
	Q:TreeNodeDesc="" "描述不能为空!"
	if NodeId=""{
		if ParentNodeId=""{
			Q ..InsertModule(TreeNodeDesc)
		}else{
			Q ..InsertDefine(TreeNodeCode,TreeNodeDesc,ParentNodeId)
		}
	}else{
		if NodeId["."{
			Q ..UpdateDefine($P(NodeId,".",2),TreeNodeCode,TreeNodeDesc,ParentNodeId)
		}else{
			Q ..UpdateModule(NodeId,TreeNodeDesc)
		}
	}
}

/// 插入代码分类表模块
ClassMethod InsertModule(ModuleDesc As %String) As %String
{
	Q:(ModuleDesc="") -1
	&SQL(SELECT COUNT(RowId) INTO :FindCount FROM SQLUser.DHCDoc_CT_Module WHERE DHCDoc_CT_Module_Desc=:ModuleDesc)
	Q:FindCount>0 "描述'"_ModuleDesc_"'已经存在!"
	&SQL(INSERT INTO SQLUser.DHCDoc_CT_Module SET DHCDoc_CT_Module_Desc=:ModuleDesc)
	Q SQLCODE
}

/// 更新代码分类表模块
ClassMethod UpdateModule(RowId As %String, ModuleDesc As %String) As %String
{
	Q:((RowId="")!(ModuleDesc="")) -1
	&SQL(SELECT COUNT(RowId) INTO :FindCount FROM SQLUser.DHCDoc_CT_Module WHERE DHCDoc_CT_Module_Desc=:ModuleDesc AND RowId<>:RowId)
	Q:FindCount>0 "描述'"_ModuleDesc_"'已经存在!"
	&SQL(UPDATE SQLUser.DHCDoc_CT_Module SET DHCDoc_CT_Module_Desc=:ModuleDesc WHERE RowId=:RowId)
	Q SQLCODE
}

/// 插入代码表数据
ClassMethod InsertDefine(DefineCode As %String, DefineDesc As %String, ModuleId As %String) As %String
{
	s DefineCode=$$ALPHAUP^SSUTIL4(DefineCode)
	Q:((DefineCode="")!(DefineDesc="")!(ModuleId="")) -1
	&SQL(SELECT COUNT(RowId) INTO :FindCount FROM SQLUser.DHCDoc_CT_Define WHERE DHCDoc_CT_Define_Code=:DefineCode AND DHCDoc_CT_Define_ModuleDR=:ModuleId)
	Q:FindCount>0 "代码'"_DefineCode_"'在此分类下已经存在!"
	&SQL(SELECT COUNT(RowId) INTO :FindCount FROM SQLUser.DHCDoc_CT_Define WHERE DHCDoc_CT_Define_Desc=:DefineDesc AND DHCDoc_CT_Define_ModuleDR=:ModuleId)
	Q:FindCount>0 "描述'"_DefineDesc_"'在此分类下已经存在!"
	k PLIST
	s PLIST(2)=$$ALPHAUP^SSUTIL4(DefineCode)
	s PLIST(3)=DefineDesc
	s PLIST(4)=ModuleId
	&SQL(INSERT INTO SQLUser.DHCDoc_CT_Define VALUES :PLIST())
	Q SQLCODE
}

/// 更新代码表数据
ClassMethod UpdateDefine(RowId As %String, DefineCode As %String, DefineDesc As %String, ModuleId As %String = "") As %String
{
	s DefineCode=$$ALPHAUP^SSUTIL4(DefineCode)
	Q:((RowId="")!(DefineCode="")!(DefineDesc="")) -1
	s:ModuleId="" ModuleId=$P(^DHCDocCT("Define",RowId),"^",3)
	&SQL(SELECT COUNT(RowId) INTO :FindCount FROM SQLUser.DHCDoc_CT_Define WHERE DHCDoc_CT_Define_Code=:DefineCode AND DHCDoc_CT_Define_ModuleDR=:ModuleId AND RowId<>:RowId)
	Q:FindCount>0 "代码'"_DefineCode_"'在此分类下已经存在!"
	&SQL(SELECT COUNT(RowId) INTO :FindCount FROM SQLUser.DHCDoc_CT_Define WHERE DHCDoc_CT_Define_Desc=:DefineDesc AND DHCDoc_CT_Define_ModuleDR=:ModuleId AND RowId<>:RowId)
	Q:FindCount>0 "描述'"_DefineDesc_"'在此分类下已经存在!"
	s PLIST(2)=$$ALPHAUP^SSUTIL4(DefineCode)
	s PLIST(3)=DefineDesc
	s PLIST(4)=ModuleId
	&SQL(UPDATE SQLUser.DHCDoc_CT_Define VALUES :PLIST() WHERE RowId=:RowId)
	Q SQLCODE
}

ClassMethod DeleteData(NodeId)
{
	if NodeId["."{
		Q ..DelDefine($P(NodeId,".",2))
	}else{
		Q ..DelModule(NodeId)
	}
}

/// 删除代码表数据
ClassMethod DelDefine(DefineRowID As %String) As %String
{
	Q:(DefineRowID="") -1
	&SQL(DELETE FROM SQLUser.DHCDoc_CT_Define WHERE RowId=:DefineRowID)
	Q SQLCODE
}

/// 删除代码表模块
ClassMethod DelModule(RowId As %String) As %String
{
	Q:(RowId="") -1
	TS
	&SQL(DELETE FROM SQLUser.DHCDoc_CT_Define WHERE DHCDoc_CT_Define_ModuleDR=:RowId)
	s:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		&SQL(DELETE FROM SQLUser.DHCDoc_CT_Module WHERE RowId=:RowId)
	}
	if SQLCODE{
		TRO
	}else{
		TC
	}
	Q SQLCODE
}

ClassMethod SaveDefineData(DefineRowID, InputStr)
{
	s ret=0
	TS
	s rows=[].%FromJSON(InputStr)
	for i=1:1:rows.%Size(){
		s row=rows.%Get(i-1)
		s DefineDataID=row.SubRowID
		if DefineDataID=""{
			s ret=..InsertDefineData(DefineRowID,row.SubCode,row.SubDesc,row.SubStDate,row.SubEndDate,.DefineDataID)
		}else{
			s ret=..UpdateDefineData(DefineRowID,DefineDataID,row.SubCode,row.SubDesc,row.SubStDate,row.SubEndDate)
			s DefineDataID=DefineRowID_"||"_DefineDataID
		}
		if 'ret{
			s ret=..SaveExtColData(DefineDataID,row)
		}
		Q:ret
	}
	if ret{
		TRO
	}else{
		TC
	}
	Q ret
}

/// 插入代码表子表数据
ClassMethod InsertDefineData(DefineRowID As %String, SubCode As %String, SubDesc As %String, SubStDate As %String = "", SubEndDate As %String = "", ByRef DefineDataID = "") As %String
{
	s DefineDataID=""
	s SubCode=$$ALPHAUP^SSUTIL4(SubCode)
	Q:((DefineRowID="")!(SubCode="")!(SubDesc="")) -1
	&SQL(SELECT Count(DHCDoc_CT_Define_RowId) INTO:FindCount from SQLUser.DHCDoc_CT_DefineData WHERE DHCDoc_CT_Define_ParRef=:DefineRowID AND DHCDoc_CT_DefineData_Code=:SubCode AND DHCDoc_CT_DefineData_Desc=:SubDesc)
	Q:FindCount>0 "-1^数据重复!"
	s SubStDate=..%ZDH(SubStDate)
	s SubEndDate=..%ZDH(SubEndDate)
	Q:(SubEndDate'="")&&(SubEndDate<SubStDate) "-1^结束日期不能小于开始日期!"
	K PLIST
	s PLIST(0)=DefineRowID
	s PLIST(3)=$$ALPHAUP^SSUTIL4(SubCode)
	s PLIST(4)=SubDesc
	s PLIST(5)=SubStDate
	s PLIST(6)=SubEndDate
	&SQL(INSERT INTO SQLUser.DHCDoc_CT_DefineData VALUES :PLIST())
	if 'SQLCODE s DefineDataID=+%ROWID
	Q SQLCODE
}

/// 更新代码表子表数据
ClassMethod UpdateDefineData(DefineRowID As %String, SubRowID As %String, SubCode As %String, SubDesc As %String, SubStDate As %String = "", SubEndDate As %String = "") As %String
{
	s SubCode=$$ALPHAUP^SSUTIL4(SubCode)
	Q:((DefineRowID="")!(SubCode="")!(SubDesc="")) -1
	&SQL(SELECT COUNT(DHCDoc_CT_Define_RowId) INTO:FindCount FROM SQLUser.DHCDoc_CT_DefineData WHERE DHCDoc_CT_Define_ParRef=:DefineRowID AND DHCDoc_CT_Define_ChildSub<>:SubRowID AND DHCDoc_CT_DefineData_Code=:SubCode AND DHCDoc_CT_DefineData_Desc=:SubDesc)
	Q:FindCount>0 "-1^数据重复!"
	s SubStDate=..%ZDH(SubStDate)
	s SubEndDate=..%ZDH(SubEndDate)
	Q:(SubEndDate'="")&&(SubEndDate<SubStDate) "-1^结束日期不能小于开始日期!"
	K PLIST
	s PLIST(3)=$$ALPHAUP^SSUTIL4(SubCode)
	s PLIST(4)=SubDesc
	s PLIST(5)=SubStDate
	s PLIST(6)=SubEndDate
	&SQL(UPDATE SQLUser.DHCDoc_CT_DefineData VALUES :PLIST() WHERE DHCDoc_CT_Define_ParRef=:DefineRowID AND DHCDoc_CT_Define_ChildSub=:SubRowID)
	Q SQLCODE
}

/// 删除代码表子表数据
ClassMethod DelDefineData(DefineRowID As %String, SubRowID As %String) As %String
{
	Q:((DefineRowID="")!(SubRowID="")) -1
	TS
	&SQL(DELETE FROM SQLUser.DHCDoc_CT_DefineData WHERE DHCDoc_CT_Define_ParRef=:DefineRowID AND DHCDoc_CT_Define_ChildSub=:SubRowID)
	if 'SQLCODE{
		s DefineDataID=DefineRowID_"||"_SubRowID
		&SQL(DELETE FROM SQLUser.DHCDoc_CT_DefineColData WHERE DefineDataDR=:DefineDataID)
		s:SQLCODE=100 SQLCODE=0
	}
	if SQLCODE{
		TRO
	}else{
		TC
	}
	Q SQLCODE
}

Query QueryGroup() As %Query(ROWSPEC = "id,text,code")
{
}

ClassMethod QueryGroupExecute(ByRef qHandle As %Binary) As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s id=0 for{
		s id=$O(^SSU("SSGRP",id)) Q:id=""
		s text=$P(^SSU("SSGRP",id),"^",1)
		s code=##class(ext.util.String).ToChineseSpell(text)
		d rows.%Push($LB(id,text,code))
	}
	Quit $$$OK
}

ClassMethod QueryGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGroupExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod SaveGroupAuth(GroupID, AuthData, HospID)
{
	s ^tempqujian("SaveGroupAuth")=$lb(GroupID, AuthData, HospID)
	s ret=0
	LOCK ^DHCDocCTDefineAuthLOCK
	s AuthData=[].%FromJSON(AuthData)
	for i=1:1:AuthData.%Size(){
		s NodeID=AuthData.%Get(i-1)
		continue:NodeID=""
		s AuthList(NodeID)=""
	}
	TS
	;本次授权没有的删除
	s NodeID=0 for{
		s NodeID=$O(^User.DHCDocCTDefineAuthI("IndexGroupNode",GroupID,NodeID)) Q:NodeID=""
		if '$D(AuthList(NodeID)){
			s ID=0
			for {
				s ID=$O(^User.DHCDocCTDefineAuthI("IndexGroupNode",GroupID,NodeID,ID)) Q:ID=""
				continue:$g(^User.DHCDocCTDefineAuthD(ID))=""
				s HospDr=$LG(^User.DHCDocCTDefineAuthD(ID),4)
				if ((HospDr'="")&&(HospDr'=HospID)) continue
				&SQL(DELETE FROM SQLUser.DHCDoc_CT_DefineAuth WHERE ID=:ID)
				if SQLCODE=100{
					k ^User.DHCDocCTDefineAuthI("IndexGroupNode",GroupID,NodeID,ID)
					s SQLCODE=0
				}
				if SQLCODE{
					s ret="-1^删除历史数据失败:"_SQLCODE
					Q
				}
			}
		}else{
			k AuthList($TR(NodeID," "))
		}
	}
	;本次新增的授权
	if ret=0{
		s NodeID=0 for{
			s NodeID=$O(AuthList(NodeID)) Q:NodeID=""
			s obj=##class(User.DHCDocCTDefineAuth).%New()
			d obj.GroupDRSetObjectId(GroupID)
			s obj.NodeID=NodeID
			d obj.HospDRSetObjectId(HospID)
			s sc=obj.%Save()
			if $$$ISERR(sc){
				s ret=-2
				Q
			}
		}
	}
	if ret{
		TRO
	}else{
		TC
	}
	LOCK -^DHCDocCTDefineAuthLOCK
	Q ret
}

ClassMethod SaveNodeAuth(NodeID, AuthData, HospID = "")
{
	s ret=0
	LOCK ^DHCDocCTDefineAuthLOCK
	s AuthData=[].%FromJSON(AuthData)
	for i=1:1:AuthData.%Size(){
		s GroupID=AuthData.%Get(i-1)
		continue:GroupID=""
		s AuthList(GroupID)=""
	}
	TS
	;本次授权没有的删除
	s ID=0 for{
		s ID=$O(^User.DHCDocCTDefineAuthI("IndexNode"," "_NodeID,ID)) Q:ID=""
		s GroupID=$LG(^User.DHCDocCTDefineAuthD(ID),2)
		if '$D(AuthList(GroupID)){
			&SQL(DELETE FROM SQLUser.DHCDoc_CT_DefineAuth WHERE ID=:ID)
			if SQLCODE=100{
				k ^User.DHCDocCTDefineAuthI("IndexNode"," "_NodeID,ID)
				s SQLCODE=0
			}
			if SQLCODE{
				s ret="-1^删除历史数据失败:"_SQLCODE
				Q
			}
		}else{
			k AuthList(GroupID)
		}
	}
	;本次新增的授权
	if ret=0{
		s GroupID=0 for{
			s GroupID=$O(AuthList(GroupID)) Q:GroupID=""
			s obj=##class(User.DHCDocCTDefineAuth).%New()
			d obj.GroupDRSetObjectId(GroupID)
			s obj.NodeID=NodeID
			d obj.HospDRSetObjectId(HospID)
			s sc=obj.%Save()
			if $$$ISERR(sc){
				s ret=-2
				Q
			}
		}
	}
	if ret{
		TRO
	}else{
		TC
	}
	LOCK -^DHCDocCTDefineAuthLOCK
	Q ret
}

/// 获取安全组授权数据
ClassMethod GetGroupAuth(GroupID, HospID = "")
{
	s AuthData=[]
	s NodeID=0 for{
		s NodeID=$O(^User.DHCDocCTDefineAuthI("IndexGroupNode",GroupID,NodeID)) Q:NodeID=""
		s ID=0
		s HospFlag=0
		for {
			s ID=$O(^User.DHCDocCTDefineAuthI("IndexGroupNode",GroupID,NodeID,ID)) Q:ID=""
			continue:$g(^User.DHCDocCTDefineAuthD(ID))=""
			s HospDr=$LG(^User.DHCDocCTDefineAuthD(ID),4)
			if ((HospDr'="")&&(HospDr=HospID)) s HospFlag=1
			}
		continue:HospFlag=0
		d AuthData.%Push($TR(NodeID," "))	
	}
	Q AuthData.%ToJSON()
}

/// 获取安全组授权数据
ClassMethod GetNodeAuth(NodeID)
{
	s AuthData=[]
	s ID=0 for{
		s ID=$O(^User.DHCDocCTDefineAuthI("IndexNode"," "_NodeID,ID)) Q:ID=""
		s GroupID=$LG(^User.DHCDocCTDefineAuthD(ID),2)
		d AuthData.%Push(GroupID)	
	}
	Q AuthData.%ToJSON()
}

/// 获取代码表某数据某安全组是否有权限，模块分类与代码要同时授权方可
/// Input:安全组ID，DHCDoc_CT_Define表ID
/// Output:1有权限，0无权限
/// w ##class(DHCDoc.DHCDocConfig.CodeTable).IsAuth(1,1)
ClassMethod IsAuth(GroupID, DefineRowID)
{
	s ModuleRowId=$p($g(^DHCDocCT("Define",DefineRowID)),"^",3)
	s id=ModuleRowId_"."_DefineRowID
	Q $D(^User.DHCDocCTDefineAuthI("IndexGroupNode",GroupID," "_ModuleRowId))&&$D(^User.DHCDocCTDefineAuthI("IndexGroupNode",GroupID," "_id))
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CodeTable","QueryColCfg",50)
Query QueryColCfg(DefineID) As %SQLQuery
{
	SELECT * FROM SQLUser.DHCDoc_CT_DefineColCfg WHERE DefineDR=:DefineID ORDER BY Sequence
}

/// w ##class(DHCDoc.DHCDocConfig.CodeTable).GetExtColCfg(50)
ClassMethod GetExtColCfg(DefineID = "")
{
	s Colums=[ 
		{"field":"SubRowID","hidden":1},
		{"field":"SubCode","title":"代码","width": 200,
			"editor": { "type":"validatebox", "options": {"required":1}}
		},
		{"field":"SubDesc","title":"描述","width":300,
			"editor": { "type":"validatebox", "options": {"required":1}}
		},
		{"field":"SubStDate","title":"开始日期","width": 200,
			"editor": { "type":"datebox","options": {}}
		},
		{"field":"SubEndDate","title":"结束日期","width":200,
			"editor": { "type":"datebox","options": {}}
		}
	]
	if DefineID'=""{
		s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.CodeTable:QueryColCfg")
		d rs.Execute(DefineID)
		while rs.Next(){
			continue:rs.GetDataByName("Active")'="Y"
			s Col={}
			s Col.field=rs.GetDataByName("Code")
			s Col.title=rs.GetDataByName("Name")
			s Style=rs.GetDataByName("Style")
			for i=1:1:$L(Style,";"){
				s oneStyle=$P(Style,";",i)
				continue:oneStyle=""
				s property=$P(oneStyle,":",1)
				if property="width"{
					s Col.width=+$P(oneStyle,":",2)
					Q
				}
			}
			s:+Col.width=0 Col.width=100
			s Type=rs.GetDataByName("Type")
			if Type'=""{
				s Col.editor={"type":(Type)}
				s Options=rs.GetDataByName("Options")
				if Options'=""{
					s Col.editor.options={}.%FromJSON("{"_Options_"}")
				}
			}
			d Colums.%Push(Col)
		}
	}
	Q [(Colums)].%ToJSON()
}

ClassMethod SaveExtColData(DefineDataID, row)
{
	s ret=0
	s DefineID=+DefineDataID
	if '$IsObject(row) s row={}.%FromJSON(row)
	s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.CodeTable:QueryColCfg")
	d rs.Execute(DefineID)
	TS
	while rs.Next(){
		continue:rs.GetDataByName("Active")'="Y"
		s Code=rs.GetDataByName("Code")
		s Value=row.%Get(Code)
		s ColCfgID=rs.GetDataByName("ID")
		s ID=$O(^User.DHCDocCTDefineColDataI("IndexDefData",DefineDataID,ColCfgID,0))
		if ID=""{
			s obj=##class(User.DHCDocCTDefineColData).%New()
			d obj.DefineDataDRSetObjectId(DefineDataID)
			d obj.ColCfgDRSetObjectId(ColCfgID)
		}else{
			s obj=##class(User.DHCDocCTDefineColData).%OpenId(ID)
		}
		s obj.Value=Value
		s sc=obj.%Save()
		if $$$ISERR(sc){
			s ret=-100
			Q
		}
	}
	if ret TRO
	else  TC
	Q ret
}

/// w ##class(DHCDoc.DHCDocConfig.CodeTable).GetDefineData("","","化疗组","")
ClassMethod GetDefineData(DefineRowID = "", DefineCode = "", DefineDesc = "", GroupID = "")
{
	s retObj={"rows":[],"total":0}
	s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.CodeTable:QueryDefineData")
	d rs.Execute(DefineRowID,DefineCode,DefineDesc,GroupID)
	s ColCounts=rs.GetColumnCount()
	while rs.Next(){
		s retObj.total=retObj.total+1
		s row={}
		for i=1:1:ColCounts{
			s field=rs.GetColumnName(i)
			s Data=rs.GetData(i)
			d row.%Set(field,Data)
		}
		s DefineDataID=row.RowId
		d ..GetExtColData(DefineDataID,.row)
		d retObj.rows.%Push(row)
	}
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d retObj.%ToJSON(.Stream)
	d Stream.OutputToDevice()
	Q ""
}

ClassMethod GetExtColData(DefineDataID, ByRef row)
{
	s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.CodeTable:QueryColCfg")
	d rs.Execute(+DefineDataID)
	while rs.Next(){
		continue:rs.GetDataByName("Active")'="Y"
		s Code=rs.GetDataByName("Code")
		s ColCfgID=rs.GetDataByName("ID")
		s ID=$O(^User.DHCDocCTDefineColDataI("IndexDefData",DefineDataID,ColCfgID,0))
		s Value=$CASE(ID,"":"",:$LG(^User.DHCDocCTDefineColDataD(ID),4))
		d row.%Set(Code,Value)
	}
	Q row
}

}
