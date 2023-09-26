Import SQLUser

Class web.UDHCJFBILLMENU Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.UDHCJFBILLMENU).GetAuthList(1)
ClassMethod GetAuthList(Group As %String)
{
	new (Group)
	set MenuList=""
	quit:(+Group=0) MenuList
	set MggId=0
	for  set MggId=$o(^DHCJFMGG(0,"GrpOnly",Group,MggId)) quit:(MggId="")  do
	.set AuthMenu=$p(^DHCJFMGG(MggId),"^",2)
	.quit:(+AuthMenu=0)
	.quit:'$d(^DHCJFBM(AuthMenu))
	.set UseFlag=$p(^DHCJFMGG(MggId),"^",3)
	.quit:(UseFlag'="Y")
	.set MenuList=$s((MenuList=""):AuthMenu,1:(MenuList_"^"_AuthMenu))
	
	quit MenuList
}

ClassMethod Insert(val) As %String
{
	k PLIST(1)
	s $zt="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_JFBILLMENU Values PLIST())
	d ..tc()
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod Delete(RowId) As %String
{
	s $zt="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_JFBILLMENU WHERE %ID = :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod Update(RowId) As %String
{
	s $zt="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_JFBILLMENU VALUES PLIST() WHERE %ID = :RowId)
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

/// w ##Class(web.UDHCJFBILLMENU).DelMenu(5)
ClassMethod DelMenu(rowId)
{
	New (rowId)
	If (rowId="") Quit "-2"
	If '$d(^DHCJFBM(rowId)) Quit "-2"
	Set rtn=0
	Set $zt="ERROR^DHCSSERR" d ..tb()

	Set sub=""
	For {
		Set sub=$o(^DHCJFBM(0,"Parref",rowId,sub)) Quit:(sub="")
		set isLeaf=$p(^DHCJFBM(sub),"^",5)
		do ..DelMenu(sub)
	}
	If '$d(^DHCJFBM(0,"Parref",rowId)) {
		Set err=..Delete(rowId)
		Set rtn=rtn+err
	}
	If (+rtn) tro  quit rtn
	tc
	Quit rtn
}

ClassMethod tb()
{
 	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
 	n SQLCODE
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_JFBILLMENU WHERE %ID = :RowId)
	s PLIST=$o(PLIST(""),-1)
 
	q SQLCODE
}

ClassMethod hasChild(rowId)
{
	New (rowId)
	If (rowId="") Quit "N"
	If '$d(^DHCJFBM(rowId)) Quit "N"
	If $d(^DHCJFBM(0,"Parref",rowId)) Quit "Y"
	Quit "N"
}

/// 获取页面菜单
/// w ##class(web.UDHCJFBILLMENU).GetPageMenus(1)
ClassMethod GetPageMenus(level) As %String
{
	New (level)
	Set strs="",json="["
	Set rowId="0"
	For {
		Set rowId=$o(^DHCJFBM(rowId)) Quit:rowId=""
		Set mylevel=$p(^DHCJFBM(rowId),"^",7)
		Set active=$p(^DHCJFBM(rowId),"^",6)
		Set code=$p(^DHCJFBM(rowId),"^",1)
		Set desc=$p(^DHCJFBM(rowId),"^",2)
		Continue:mylevel'=level
		Continue:active'="Y"
		/*
		Set str=rowId_"@"_desc
		if strs="" {
			Set strs=str	
		}else {
			Set strs=strs_"^"_str	
		}
		*/
		Set obj=##class(User.DHCJFBILLMENU).%OpenId(rowId, 0)
		Set str=..ToJson(obj,"User.DHCJFBILLMENU")
		If json="[" {
			Set json=json_str
		}else {
			Set json=json_","_str
		}
	}
	Set json=json_"]"
	
	Quit json
}

/// 获取页面一级子菜单
/// w ##class(web.UDHCJFBILLMENU).GetTargetsByPage("TEST",2)
ClassMethod GetTargetsByPage(code, level) As %String
{
	New (code, level)
	If (code="") Quit "[]"
	If '$d(^DHCJFBM(0,"Code",code)) Quit "[]"
	Set parref=$o(^DHCJFBM(0,"Code",code,""))
	If '$d(^DHCJFBM(parref)) Quit "[]"
	Set json="["
	Set rowId=0
	For {
		Set rowId=$o(^DHCJFBM(0,"Parref",parref,rowId)) Quit:(rowId="")
		Set mylevel=$p(^DHCJFBM(rowId),"^",7)
		Set active=$p(^DHCJFBM(rowId),"^",6)
		Set code=$p(^DHCJFBM(rowId),"^",1)
		Set desc=$p(^DHCJFBM(rowId),"^",2)
		Continue:(mylevel'=level)
		Continue:(active'="Y")
		Set obj=##class(User.DHCJFBILLMENU).%OpenId(rowId, 0)
		Set str=..ToJson(obj,"User.DHCJFBILLMENU")
		If (json="[") {
			Set json=json_str
		}else {
			Set json=json_","_str
		}
	}
	Set json=json_"]"
	Quit json
}

/// w ##class(web.UDHCJFBILLMENU).GetMenus("IPBILLTool",241)
ClassMethod GetMenus(code, groupId) As %String
{
	New (code, groupId)
	If (code="") Quit "[]"
	If '$d(^DHCJFBM(0,"Code",code)) Quit "[]"
	Set parref=$o(^DHCJFBM(0,"Code",code,""))
	If '$d(^DHCJFBM(parref)) Quit "[]"
	Set json="["
	Set obj=##class(User.DHCJFBILLMENU).%OpenId(parref, 0)
	Set str=..ToJson(obj,"User.DHCJFBILLMENU")
	;判断是否是授权的菜单
	if (groupId'="") {
		Set mggId=$o(^DHCJFMGG(0,"Grp",groupId,"Menu",parref,""))
		if ((mggId'="") && $d(^DHCJFMGG(mggId))) {
			Set str=$e(str,1,$l(str)-1)
			Set str=str_","_"""checked"""_":"_"""true"""
			Set str=str_"}"	
		}	
	}
	
	If $d(^DHCJFBM(0,"Parref",parref)) {
		Set str=$e(str,1,$l(str)-1)
		Set str=str_","_"""children"""_":["
		Set rtn=..GetJsonStr(parref,groupId)
		Set str=str_rtn_"]}"
	}
	Set json=json_str_"]"
	Quit json
}

/// w ##Class(web.UDHCJFBILLMENU).GetJsonStr(29,8)
ClassMethod GetJsonStr(parref, groupId) As %String
{
	New (parref, groupId)
	Set strs=""
	Set rowId=0
	For {
		Set rowId=$o(^DHCJFBM(0,"Parref",parref,rowId)) Quit:(rowId="")
		Set mylevel=$p(^DHCJFBM(rowId),"^",7)
		Set active=$p(^DHCJFBM(rowId),"^",6)
		Continue:(active'="Y")
		Set code=$p(^DHCJFBM(rowId),"^",1)
		Set desc=$p(^DHCJFBM(rowId),"^",2)
		Set obj=##class(User.DHCJFBILLMENU).%OpenId(rowId, 0)
		Set str=..ToJson(obj,"User.DHCJFBILLMENU")
		if (groupId'="") {
			Set mggId=$o(^DHCJFMGG(0,"Grp",groupId,"Menu",rowId,""))
			if ((mggId'="") && $d(^DHCJFMGG(mggId))) {
				Set str=$e(str,1,$l(str)-1)
				Set str=str_","_"""checked"""_":"_"""true"""
				Set str=str_"}"
			}
		}
		If $d(^DHCJFBM(0,"Parref",rowId)) {
			Set str=$e(str,1,$l(str)-1)
			Set str=str_","_"""children"""_":["
			Set rtn=..GetJsonStr(rowId,groupId)
			Set str=str_rtn_"]}"
		}
		
		if (strs="") {
			Set strs=str	
		}else {
			Set strs=strs_","_str	
		}
	}
	
	Quit strs
}

/// Creator: ZhYW
/// CreatDate: 2019-04-25
/// Description: 获取授权菜单按钮数组
/// Input: code:父菜单code, groupId:SS_Group.RowId, hospId:CT_Hospital.RowId
/// Return: 
/// Table: DHC_JFBillMenu, DHC_JFMenuGroupGrant
/// Debug: w ##class(web.UDHCJFBILLMENU).GetSubListToJson("IPBILLTool", 241, 2)
ClassMethod GetSubListToJson(code As %String, groupId As %String, hospId As %String) As %String
{
	new (code, groupId, hospId)
	if ((code="")||(groupId="")) quit "[]"
	set parref=$o(^DHCJFBM(0,"Code",code,""))
	if (+parref=0) quit "[]"
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_GroupAuth", hospId)

	set maxSeqIdx=$o(^DHCJFBM(0,"Sequence",parref,""),-1)
	kill menuSeqAry
	
	//DHC_JFBillMenu
	set rowId=0
	while($o(^DHCJFBM(0,"Parref",parref,rowId))) {
		set rowId=$o(^DHCJFBM(0,"Parref",parref,rowId))
		set menuData=$g(^DHCJFBM(rowId))
		continue:(menuData="")
		set active=$p(menuData,"^",6)
		continue:(active'="Y")
	 	set grantId=""
	 	//DHC_JFMenuGroupGrant
	 	set myGGId=0
	 	while($o(^DHCJFMGG(0,"Grp",groupId,"Menu",rowId,myGGId))&&(grantId="")) {
		 	set myGGId=$o(^DHCJFMGG(0,"Grp",groupId,"Menu",rowId,myGGId))
		 	set myHospDR=$p($g(^DHCJFMGG(myGGId)),"^",4)
		 	continue:(myHospDR'=defHospId)
		 	set grantId=myGGId
		}
		continue:(grantId="")
		set grantData=$g(^DHCJFMGG(grantId))
		continue:(grantData="")
		set useRight=$p(grantData,"^",3)
		continue:(useRight'="Y")
		//DHC_JFBillMenu
		set code=$p(menuData,"^",1)
		set desc=$p(menuData,"^",2)
		set seqIdx=$p(menuData,"^",9)
		if (seqIdx="") set seqIdx=$i(maxSeqIdx)
		set iconCls=$p(menuData,"^",10)
		set handler=$p(menuData,"^",11)
		set menuSeqAry(seqIdx)=$lb(code, desc, iconCls, handler)
	}
	
	set ary=[]
	set seqIdx=""
	while($o(menuSeqAry(seqIdx))) {
		set seqIdx=$o(menuSeqAry(seqIdx))
		set data=$g(menuSeqAry(seqIdx))
		set d={}
		set d.id="tool-btn-"_$lg(data,1)
		set d.text=$lg(data,2)
		set d.iconCls=$lg(data,3)
		set d.handler=$lg(data,4)
		do ary.%Push(d)
	}
	quit ary.%ToJSON()
}

/// w ##class(web.UDHCJFBILLMENU).ToJson(obj,"User.DHCJFBILLMENU")
ClassMethod ToJson(obj, objClass) As %String
{
	New (obj, objClass)
	Set rtn=""
	If $isObject(obj) {
		set @"obj"=obj
		Set cdef=##class(%Dictionary.ClassDefinition).%OpenId(objClass, 0)
		If $SYSTEM.Status.IsError(cdef)  {
			Quit ""
		}
		Set count=cdef.Properties.Count()
		For i=1:1:count {
			Set tPropName=cdef.Properties.GetAt(i).Name
			set tmpVal="value=obj."_tPropName,@tmpVal
			;w @"value",!
			Set val=@"value"
			;w val
			;w $zobjproperty(obj,tPropName)
			Set tPrivate=+$$$comMemberKeyGet(objClass,$$$cCLASSproperty,tPropName,$$$cPROPprivate)
			;If ('tPrivate && (tPropName'["%")) {
				Set tType=$$$comMemberKeyGet(objClass,$$$cCLASSproperty,tPropName,$$$cPROPtype)
				Set tClsType=$$$getClassType(tType)
				Set tClientType=$$$comClassKeyGet(tType,$$$cCLASSclientdatatype)
				Set tCollection=$$$comMemberKeyGet(objClass,$$$cCLASSproperty,tPropName,$$$cPROPcollection)
				If (tClsType'="datatype") {
					If ($zobjclassmethod(tType,"%IsA","%Collection.AbstractList")) {
						Set tCollection = "list"
					}
				}
				Set tMultiDim=0
				If (tCollection="array") {
					Set tCardinality=$$$comMemberKeyGet(objClass,$$$cCLASSproperty,tPropName,$$$cPROPcardinality)
					Set tInverse=$$$comMemberKeyGet(objClass,$$$cCLASSproperty,tPropName,$$$cPROPinverse)
					If ((tCardinality'="")&&(tInverse'="")) {
						// treat relationship as list
						Set tCollection="list"
					}
				}
				ElseIf (tCollection="") {
					Set tMultiDim=+$$$comMemberKeyGet(objClass,$$$cCLASSproperty,tPropName,$$$cPROPmultidimensional)
				}

				If ('tMultiDim) {
					Set tValue=$zobjproperty(obj,tPropName)
				}
				
				If (tMultiDim) {
				}
				ElseIf (tCollection="list") {
					// list collection
					If $IsObject(tValue) {
						Set tList=tValue
						Set tCount=tList.Count()
						Set strs=tPropName_":["
						For n=1:1:tCount {
							Set tValue=tList.GetAt(n)
							Set:(n>1) strs=strs_","
							If (tClientType="HANDLE") {
								// object
								If $IsObject(tValue) {
									Set className=tValue.%ClassName(1)
									Set str=..ToJson(tValue,className)
									Set strs=strs_str
								}
							}else {
								Set str=$Case(tClientType,"BOOLEAN":$S(tValue:"true",1:"false"),:$S($IsValidNum(tValue):tValue,1:tValue))
								Set strs=strs_str	
							}
						}
						Set rtn=rtn_strs
					}
					Set rtn=rtn_"]"
				}
				ElseIf (tCollection="array") {
					// array collection (object on client)
					Set rtn=rtn_"{"
					If $IsObject(tValue) {
						Set tArray = tValue
						Set n=0
						Set tKey=tArray.Next("")
						While (tKey'="") {
							Set n=n+1
							Set tValue=tArray.GetAt(tKey)
							Set str=$zname(tKey)_":"_tKey_","_$IsValidNum(tKey)_":"_tKey
							Set rtn=rtn_","_str
							If (tClientType="HANDLE") {
								// object
								If $IsObject(tValue) {
									Set className=tValue.%ClassName(1)
									Set tSC=..ToJson(tValue, className)
									If $$$ISERR(tSC) Quit
								}
							}
							Set tKey=tArray.Next(tKey)
						}
					}
					Set rtn=rtn_"}"
				}
				ElseIf (tClientType="HANDLE") {
					/*
					If $IsObject(tValue) {
						Set className=tValue.%ClassName(1)
						Set tSC=..ToJson(tValue,className)
						If $$$ISERR(tSC) Quit
					}
					*/
					If $IsObject(tValue) {
						Set tValue=tValue.%Id()
						Set str=""""_tPropName_""""_":"_""""_tValue_""""
						if (rtn="") {
							Set rtn=str	
						}else {
							Set rtn=rtn_","_str	
						}
					}
				}ElseIf (tClientType="CHARACTERSTREAM") {
					If $IsObject(tValue) {
						Set tValue="CHARACTERSTREAM"
						Set rtn=rtn_","_tPropName_":"_tValue
					}
				}ElseIf (tClientType="BINARYSTREAM") {
					Set tValue="BINARYSTREAM"
					Set rtn=rtn_","_tPropName_":"_tValue
				}Else {
					Set str=""""_tPropName_""""_":"_""""_tValue_""""
					if (rtn="") {
						Set rtn=str	
					}else {
						Set rtn=rtn_","_str	
					}
				}
		}
	} Else {
		Quit ""	
	}
	If $l(rtn)>0 Set rtn=rtn_","_"""rowId"""_":"_""""_obj.%Id()_""""
	if $e(rtn,1,1)="," Set rtn=$e(rtn,2,$l(rtn))
	Quit "{"_rtn_"}"
}

}
