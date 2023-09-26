/// 名称:     web.DHCDocCTCommon
/// 描述:     代码表公共类
/// 编写者:  谭吉善
/// 编写日期: 2013.02.22
Class web.DHCDocCTCommon Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询代码表模块query
Query GetDHCDocCTModule() As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "ModuleRowId:%String,ModuleDesc:%String")
{
	Select RowId,DHCDoc_CT_Module_Desc From SQLUser.DHCDoc_CT_Module where RowId!=0
}

/// 插入代码表模块
ClassMethod InsertDHCDocCTModule(ModuleDesc As %String) As %String
{
	q:(ModuleDesc="") -1
	Q:($d(^DHCDocCT(0,"ModuleDesc",ModuleDesc))) "repeat"
	;Lock +^DHCDocCT
	&sql(Insert into SQLUser.DHCDoc_CT_Module set DHCDoc_CT_Module_Desc=:ModuleDesc)
	;Lock -^DHCDocCT
	q SQLCODE
}

/// 删除代码表模块
/// 当有代码表指向代码表模块时，当删除此代码表模块，会发生什么情况?
ClassMethod DelDHCDocCTModule(RowId As %String) As %String
{
	q:(RowId="") -1
	&sql(Delete From SQLUser.DHCDoc_CT_Module where RowId=:RowId)
	q SQLCODE
}

/// 更新代码表模块
ClassMethod UpdateDHCDocCTModule(RowId As %String, ModuleDesc As %String) As %String
{
	q:((RowId="")!(ModuleDesc="")) -1
	s repeatId=$o(^DHCDocCT(0,"ModuleDesc",ModuleDesc,""))
	Q:(repeatId'="")&&(repeatId'=RowId) "repeat"
	&sql(Update SQLUser.DHCDoc_CT_Module set DHCDoc_CT_Module_Desc=:ModuleDesc where RowId=:RowId)
	q SQLCODE
}

/// 查询代码表
Query LookUpDHCDocCTDefine() As %Library.Query(CONTAINID = 3, ROWSPEC = "DefineRowID:%String,DefineCode:%String,DefineDesc:%String,ModuleDR:%String,ModuleDesc:%String")
{
}

ClassMethod LookUpDHCDocCTDefineClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDHCDocCTDefineFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LookUpDHCDocCTDefineExecute(ByRef qHandle As %Library.Binary) As %Library.Status
{
	n (qHandle,DefineRowID,DefineCode,DefineDesc,ModuleDR,ModuleDesc)
	Set repid=$I(^CacheTemp)
	s ind=1
	s DefineRowID=0
	f  s DefineRowID=$o(^DHCDocCT("Define",DefineRowID)) q:DefineRowID=""  d
	.s DefineCode=$p($g(^DHCDocCT("Define",DefineRowID)),"^",1)
	.s DefineDesc=$p($g(^DHCDocCT("Define",DefineRowID)),"^",2)
	.s ModuleDR=$p($g(^DHCDocCT("Define",DefineRowID)),"^",3)
	.s ModuleDesc=$g(^DHCDocCT("Module",ModuleDR))
	.d OuputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	///DefineRowID,DefineCode,DefineDesc,ModuleDR,ModuleDesc
	set Data=$lb(DefineRowID,DefineCode,DefineDesc,ModuleDR,ModuleDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpDHCDocCTDefineFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDHCDocCTDefineExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取代码表模块Str,用于初始化代码表模块下拉列表
ClassMethod GetMethodStr() As %String
{
	s ret=""
	Set rset=##class(%ResultSet).%New("web.DHCDocCTCommon:GetDHCDocCTModule")
	do rset.Execute()
	While (rset.Next()) {
		if ret="" s ret=rset.Data("ModuleRowId")_$C(1)_rset.Data("ModuleDesc")
		e  s ret=ret_"^"_rset.Data("ModuleRowId")_$C(1)_rset.Data("ModuleDesc")
	}
	d rset.Close()
	Q ret
}

/// 插入代码表数据
ClassMethod InsertDHCDocCTDefine(DefineCode As %String, DefineDesc As %String, ModuleCode As %String) As %String
{
	q:((DefineCode="")!(DefineDesc="")!(ModuleCode="")) -1
	s DefineCode=$$ALPHAUP^SSUTIL4(DefineCode)
	s FindRowId=""
	&sql(select RowId into:FindRowId From SQLUser.DHCDoc_CT_Define where DHCDoc_CT_Define_Code=:DefineCode and DHCDoc_CT_Define_Desc=:DefineDesc and DHCDoc_CT_Define_ModuleDR=:ModuleCode)
	q:FindRowId'="" "数据重复！"
	kill PLIST
	s PLIST(2)=$$ALPHAUP^SSUTIL4(DefineCode)
	s PLIST(3)=DefineDesc
	s PLIST(4)=ModuleCode
	&sql( INSERT INTO SQLUser.DHCDoc_CT_Define VALUES :PLIST())
	//&sql(Insert into SQLUser.DHCDoc_CT_Define set DHCDoc_CT_Define_Code=:ModuleDesc,DHCDoc_CT_Define_Desc=:DefineDesc,DHCDoc_CT_Define_ModuleDR=:ModuleCode)
	q SQLCODE
}

/// 删除代码表数据
ClassMethod DelDHCDocCTDefine(DefineRowId As %String) As %String
{
	q:(DefineRowId="") -1
	&sql(Delete From SQLUser.DHCDoc_CT_Define where RowId=:DefineRowId)
	q SQLCODE
}

/// 更新代码表数据
ClassMethod UpdateDHCDocCTDefine(RowId As %String, DefineCode As %String, DefineDesc As %String, ModuleCode As %String) As %String
{
	q:((RowId="")!(ModuleCode="")!(DefineCode="")!(DefineDesc="")) -1
	s DefineCode=$$ALPHAUP^SSUTIL4(DefineCode)
	s FindRowId=""
	&sql(select RowId into:FindRowId From SQLUser.DHCDoc_CT_Define where DHCDoc_CT_Define_Code=:DefineCode and DHCDoc_CT_Define_Desc=:DefineDesc and DHCDoc_CT_Define_ModuleDR=:ModuleCode and RowId<>:RowId)
	q:FindRowId'="" "数据重复！"
	
	s PLIST(2)=$$ALPHAUP^SSUTIL4(DefineCode)
	s PLIST(3)=DefineDesc
	s PLIST(4)=ModuleCode
	&sql( Update SQLUser.DHCDoc_CT_Define VALUES :PLIST() where RowId=:RowId)
	//&sql(Update SQLUser.DHCDoc_CT_Define set DHCDoc_CT_Module_Desc=:ModuleDesc where RowId=:RowId)
	q SQLCODE
}

/// 查询代码表数据
Query LookUpDHCDocCTDefineData(DefineRowID As %String) As %Library.Query(CONTAINID = 3, ROWSPEC = "SubRowID:%String,SubCode:%String,SubDesc:%String,SubStDate:%String,SubEndDate:%String")
{
}

ClassMethod LookUpDHCDocCTDefineDataClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDHCDocCTDefineDataFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// d ##Class(%ResultSet).RunQuery("web.DHCDocCTCommon","LookUpDHCDocCTDefineData","",2)

ClassMethod LookUpDHCDocCTDefineDataExecute(ByRef qHandle As %Library.Binary, DefineRowID As %String) As %Library.Status
{
	n (qHandle,DefineRowID)
	Set repid=$I(^CacheTemp)
	s ind=1
	if (DefineRowID'="") d
	.if $d(^DHCDocCT("DefineData",DefineRowID)) d
	..s SubRowID=0
	..f  s SubRowID=$o(^DHCDocCT("DefineData",DefineRowID,"D",SubRowID)) q:SubRowID=""  d
	...s SubCode=$p($g(^DHCDocCT("DefineData",DefineRowID,"D",SubRowID)),"^",1)
	...s SubDesc=$p($g(^DHCDocCT("DefineData",DefineRowID,"D",SubRowID)),"^",2)
	...s SubStDate=$p($g(^DHCDocCT("DefineData",DefineRowID,"D",SubRowID)),"^",3)
	...s SubEndDate=$p($g(^DHCDocCT("DefineData",DefineRowID,"D",SubRowID)),"^",4)
	...s:(SubStDate'="") SubStDate=..%ZD(SubStDate) //$zd(SubStDate,4)
	...s:(SubEndDate'="") SubEndDate=..%ZD(SubEndDate) //$zd(SubEndDate,4)
	...d OuputRow2
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow2
	///SubRowID,SubCode,SubDesc,SubStDate,SubEndDate
	set Data=$lb(SubRowID,SubCode,SubDesc,SubStDate,SubEndDate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpDHCDocCTDefineDataFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDHCDocCTDefineDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 插入代码表子表数据
ClassMethod InsertDHCDocCTDefineData(DefineRowID As %String, SubCode As %String, SubDesc As %String, SubStDate As %String = "", SubEndDate As %String = "") As %String
{
	q:((DefineRowID="")!(SubCode="")!(SubDesc="")) -1
	s SubCode=$$ALPHAUP^SSUTIL4(SubCode)
	s FindDefRowId=""
	&sql(select DHCDoc_CT_Define_RowId into:FindDefRowId from SQLUser.DHCDoc_CT_DefineData where DHCDoc_CT_Define_ParRef=:DefineRowID and DHCDoc_CT_DefineData_Code=:SubCode and DHCDoc_CT_DefineData_Desc=:SubDesc)
	q:FindDefRowId'="" "数据重复！"
	//$zdh("22/02/2013",4)
	s:(SubStDate'="") SubStDate=..%ZDH(SubStDate) //$zdh(SubStDate,4)
	s:(SubEndDate'="") SubEndDate=..%ZDH(SubEndDate) //$zdh(SubEndDate,4)
	kill PLIST
	s PLIST(0)=DefineRowID
	s PLIST(3)=$$ALPHAUP^SSUTIL4(SubCode)
	s PLIST(4)=SubDesc
	s PLIST(5)=SubStDate
	s PLIST(6)=SubEndDate
	&sql( INSERT INTO SQLUser.DHCDoc_CT_DefineData VALUES :PLIST())
	q SQLCODE
}

/// 删除代码表子表数据
ClassMethod DelDHCDocCTDefineData(DefineRowId As %String, SubCode As %String) As %String
{
	q:((DefineRowId="")!(SubCode="")) -1
	&sql(Delete From SQLUser.DHCDoc_CT_DefineData where DHCDoc_CT_Define_ParRef=:DefineRowId and DHCDoc_CT_Define_ChildSub=:SubCode)
	q SQLCODE
}

/// 更新代码表子表数据
ClassMethod UpdateDHCDocCTDefineData(DefineRowID As %String, SubRowid As %String, SubCode As %String, SubDesc As %String, SubStDate As %String = "", SubEndDate As %String = "") As %String
{
	q:((DefineRowID="")!(SubCode="")!(SubDesc="")) -1
	s SubCode=$$ALPHAUP^SSUTIL4(SubCode)
	s FindDefRowId=""
	&sql(select DHCDoc_CT_Define_RowId into:FindDefRowId from SQLUser.DHCDoc_CT_DefineData where DHCDoc_CT_Define_ParRef=:DefineRowID and DHCDoc_CT_Define_ChildSub<>:SubRowid and DHCDoc_CT_DefineData_Code=:SubCode and DHCDoc_CT_DefineData_Desc=:SubDesc)
	q:FindDefRowId'="" "数据重复！"
	//$zdh("21/02/2013",4)
	;s ^tan("UpdateDHCDocCTDefineData")=DefineRowID_"^"_SubRowid_"^"_SubCode_"^"_SubDesc_"^"_SubStDate_"^"_SubEndDate_"^"
	s:(SubStDate'="") SubStDate=..%ZDH(SubStDate) //$zdh(SubStDate,4)
	s:(SubEndDate'="") SubEndDate=..%ZDH(SubEndDate) //$zdh(SubEndDate,4)
	kill PLIST
	s PLIST(3)=$$ALPHAUP^SSUTIL4(SubCode)
	s PLIST(4)=SubDesc
	s PLIST(5)=SubStDate
	s PLIST(6)=SubEndDate
	&sql(Update SQLUser.DHCDoc_CT_DefineData VALUES :PLIST() where DHCDoc_CT_Define_ParRef=:DefineRowID and DHCDoc_CT_Define_ChildSub=:SubRowid)
	q SQLCODE
}

}
