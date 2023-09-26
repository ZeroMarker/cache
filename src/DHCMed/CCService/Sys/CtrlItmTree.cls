/// 名称: DHCMed.CCService.Sys.CtrlItmTree
/// 描述: 取监控条件json串,组织为监控项目树
/// 编写者：zhufei
/// 编写日期: 2011-03-11
Class DHCMed.CCService.Sys.CtrlItmTree Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

// Modified By LiYang 2011-09-23 增加科室、病区

/// Creator：     zhufei
/// CreatDate：   2011-03-11
/// Description:  根据监控主题构造监控项目json串
/// 
/// Table：       DHCMed_CC.Subject
///               DHCMed_CC.SubjectItm
///               DHCMed_CC.ItemDic
///               DHCMed_CC.ItemSubCat
///               DHCMed_CC.ItemCat
/// Input：       SubjectID：  监控主题ID
/// Return：      返回树形结构json串
/// 
/// 说明:         依托dhcmed.cc.ctrl.itemtree.csp输出
/// w ##class(DHCMed.CCService.Sys.CtrlItmTree).BuildNINFSubjectAppJson(1,31,"")
ClassMethod BuildNINFSubjectAppJson(argSubjectID As %String, ViewConfigCode As %String) As %List
{
	New (argSubjectID,ViewConfigCode)
	Set Json=""
	//Set $ZT="BuildNINFSubjectAppJsonErr"
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"BuildSubjectAppJson")
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjById(argSubjectID)
	Quit:'$IsObject(objSubject) ""
	
	Set ConfigID=$o(^DHCMed.CC.SubjectConfigI("CodeIndex"," "_$ZConvert(objSubject.Code,"U")," "_$ZConvert(ViewConfigCode,"U"),""))
	
	
	
	Set LocList=""
	Set SubjectID=0
	For {
		Set SubjectID=$o(^DHCMed.CC("Subject",SubjectID))
		Quit:SubjectID=""
		Continue:argSubjectID'=SubjectID
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		Set SubActive=objSubject.IsActive
		Continue:SubActive'=1     //1有效,0无效
		Set ^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID)=""
		Set IsActive=""
		For {
			Set IsActive=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,IsActive))
			Quit:IsActive=""
			Continue:IsActive'=1  //1有效,0无效
			Set ItemID=0
			For {
				Set ItemID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,IsActive,ItemID))
				Quit:ItemID=""
				Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				Continue:'$IsObject(objItem)
				Set tmpScore=+objItem.Score
				Continue:tmpScore<1
				Set ItemDicDR=objItem.ItemDic
				Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDR)
				Continue:'$IsObject(objItemDic)
				Set ItemSubCatDR=objItemDic.IDSubCatDr
				Continue:$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,ItemSubCatDR))=0
				Set objItemSubcat=##class(DHCMed.CC.ItemSubCat).GetObjById(ItemSubCatDR)
				Continue:'$IsObject(objItemSubcat)
				Set ItemCatDR=objItemSubcat.ISCCatDr
				Set objCat=##class(DHCMed.CC.ItemCat).GetObjById(ItemCatDR)
				Continue:'$IsObject(objCat)
				Set LocDr=objCat.LocDr
				Continue:((LocDr'="")&(LocList'="")&($listfind(LocList,+LocDr)<1))
				Set ^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,+LocDr,ItemCatDR,ItemSubCatDR,ItemDicDR,ItemID)=""
				//w "ItemCatDR="_ItemCatDR_",ItemSubCatDR="_ItemSubCatDR_",ItemDicDR="_ItemDicDR,!
			}
		}
	}
	
	Set SubjectID=0
	For {
		Set SubjectID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID))
		Quit:SubjectID=""
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		
		Write:Json'="" Json
		Set JsonItem="[{"_"""id"":"""_SubjectID_"-S-"",""text"":"""_$tr(objSubject.Title,"""","'")
		Set JsonItem=JsonItem_""",""iconCls"":""icon-pro"",""expanded"":true,"
		
		Set tmpLoc=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,""))
		If tmpLoc'="" {
			Set JsonItem=JsonItem_"""checked"":true,"
		}Else{
			Set JsonItem=JsonItem_"""checked"":false,"
		}
		Set JsonItem=JsonItem_"""children"":["
		Write JsonItem  //输出Json1
		
		Set LocID="",JsonLoc=""
		For {
			Set LocID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID))
			Quit:LocID=""
			Set JsonLocItem=""
			//add by zf 20111031 增加科室标识
			/*Set LocDesc=""
			Set:LocID'="" LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			Set LocDesc=$s(LocDesc="":"全局科室",1:LocDesc)
			
			Write:JsonLoc'="" JsonLoc
			Set JsonLocItem="{"_"""id"":"""_SubjectID_"||"_LocID_"-L-"",""text"":"""_$tr(LocDesc,"""","'")
			Set JsonLocItem=JsonLocItem_""",""iconCls"":""icon-pro"",""expanded"":true,"
			*/
			Set tmpCategID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,0))
			/*If tmpCategID'="" {
				Set JsonLocItem=JsonLocItem_"""checked"":true,"
			}Else{
				Set JsonLocItem=JsonLocItem_"""checked"":false,"
			}
			Set JsonLocItem=JsonLocItem_"""children"":["
			
			Write JsonLocItem  //输出JsonLoc1
			*/
			Set Cnt=0
			Set CategID=0,JsonA=""
			For {
				Set CategID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,CategID))
				Quit:CategID=""
				Set objCateg=##class(DHCMed.CC.ItemCat).GetObjById(CategID)
				Continue:'$IsObject(objCateg)
				
				Set JsonAItem=""
				Set SubCatID=0
				For {
					Set SubCatID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,CategID,SubCatID))
					Quit:SubCatID=""
					Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
					Continue:'$IsObject(objSubCat)
					
					Set:Cnt>0 JsonAItem=","_$c(13)_$c(10)
					Set JsonAItem=JsonAItem_"{"_"""id"":"""_SubjectID_"||"_LocID_"||"_CategID_"||"_SubCatID_"-D-"",""text"":"""_$tr(objSubCat.ISCDesc,"""","'")_""","
					//Set JsonAItem=JsonAItem_"""expanded"":true,"
					Set JsonAItem=JsonAItem_"""checked"":true,"
					Set JsonAItem=JsonAItem_"""iconCls"":""icon-pro"","
					Set JsonAItem=JsonAItem_"""leaf"":true"
					Set JsonAItem=JsonAItem_"}"
					
					Write JsonAItem
					Set Cnt=Cnt+1
					/*
					If $o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,CategID,SubCatID,0))'="" {
						Set JsonAItem=JsonAItem_"""checked"":true,"
					}Else{
						Set JsonAItem=JsonAItem_"""checked"":false,"
					}
					//Set JsonAItem=JsonAItem_"""iconCls"":""icon-pro"","
					Set JsonAItem=JsonAItem_"""iconCls"":""icon-pro"""
					
					Set JsonAItem=JsonAItem_"""children"":["
					Write JsonAItem  //输出JsonA1
					
					Set ItemDicID=0,JsonB=""
					For {
						Set ItemDicID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,CategID,SubCatID,ItemDicID))
						Quit:ItemDicID=""
						Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicID)
						Continue:'$IsObject(objItemDic)
						Set ItemID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,CategID,SubCatID,ItemDicID,0))
						Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
						Continue:'$IsObject(objItem)
						Set ItemActive=objItem.IsActive
						Set ItemAbsolute=objItem.IsAbsolute
						Continue:ItemActive'=1
						
						Write:JsonB'="" JsonB
						Set JsonBItem="{"_"""id"":"""_ItemID_"-I-"","
						If ItemAbsolute=1 {
							Set JsonBItem=JsonBItem_"""text"":""<font color=red>"_$tr(objItemDic.IDDesc,"""","'")_"</font>"","
						}Else{
							Set JsonBItem=JsonBItem_"""text"":"""_$tr(objItemDic.IDDesc,"""","'")_""","
						}
						Set JsonBItem=JsonBItem_"""expanded"":true,"
						Set JsonBItem=JsonBItem_"""checked"":true,"
						Set JsonBItem=JsonBItem_"""iconCls"":""icon-menu"","
						Set JsonBItem=JsonBItem_"""children"":[]}"
						Write JsonBItem  //输出JsonB1+JsonB2
						Set JsonB=","
					}
					Write "]}"  //输出JsonA2
					
					Set JsonA=","*/
				}
			}
			//Write "]}"  //输出JsonLoc2
			//Set JsonLoc=","
		}
		Write "]}]"  //输出Json2
		Set Json=","
	}
	
	Kill ^TMP(ZIndex,JIndex,"BuildSubjectAppJson")
	Write:Json="" "[]"  //输出Json
	Quit 1
	
BuildNINFSubjectAppJsonErr
	Write "Error:"_$ZERROR,!
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2011-03-11
/// Description:  根据监控主题构造监控项目json串
/// 
/// Table：       DHCMed_CC.Subject
///               DHCMed_CC.SubjectItm
///               DHCMed_CC.ItemDic
///               DHCMed_CC.ItemSubCat
///               DHCMed_CC.ItemCat
/// Input：       SubjectID：  监控主题ID
/// Return：      返回树形结构json串
/// 
/// 说明:         依托dhcmed.cc.ctrl.itemtree.csp输出
/// w ##class(DHCMed.CCService.Sys.CtrlItmTree).BuildSubjectAppJson(1,31,"")
ClassMethod BuildSubjectAppJson(argSubjectID As %String, argLoc As %String, argWard As %String) As %List
{
	New (argSubjectID,argLoc,argWard)
	Set Json=""
	Set $ZT="BuildSubjectAppJsonErr"
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"BuildSubjectAppJson")
	
	Set LocList=""
	Set:argLoc'="" LocList=$lb(argLoc)
	Set:argWard'="" LocList=$lb(argWard)
	
	Set SubjectID=0
	For {
		Set SubjectID=$o(^DHCMed.CC("Subject",SubjectID))
		Quit:SubjectID=""
		Continue:argSubjectID'=SubjectID
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		Set SubActive=objSubject.IsActive
		Continue:SubActive'=1     //1有效,0无效
		Set ^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID)=""
		Set IsActive=""
		For {
			Set IsActive=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,IsActive))
			Quit:IsActive=""
			Continue:IsActive'=1  //1有效,0无效
			Set ItemID=0
			For {
				Set ItemID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,IsActive,ItemID))
				Quit:ItemID=""
				Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				Continue:'$IsObject(objItem)
				Set tmpScore=+objItem.Score
				Continue:tmpScore<1
				Set ItemDicDR=objItem.ItemDic
				Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDR)
				Continue:'$IsObject(objItemDic)
				Set ItemSubCatDR=objItemDic.IDSubCatDr
				Set objItemSubcat=##class(DHCMed.CC.ItemSubCat).GetObjById(ItemSubCatDR)
				Continue:'$IsObject(objItemSubcat)
				Set ItemCatDR=objItemSubcat.ISCCatDr
				Set objCat=##class(DHCMed.CC.ItemCat).GetObjById(ItemCatDR)
				Continue:'$IsObject(objCat)
				Set LocDr=objCat.LocDr
				Continue:((LocDr'="")&(LocList'="")&($listfind(LocList,+LocDr)<1))
				Set ^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,+LocDr,ItemCatDR,ItemSubCatDR,ItemDicDR,ItemID)=""
				//w "ItemCatDR="_ItemCatDR_",ItemSubCatDR="_ItemSubCatDR_",ItemDicDR="_ItemDicDR,!
			}
		}
	}
	
	Set SubjectID=0
	For {
		Set SubjectID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID))
		Quit:SubjectID=""
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		
		Write:Json'="" Json
		Set JsonItem="[{"_"""id"":"""_SubjectID_"-S-"",""text"":"""_$tr(objSubject.Title,"""","'")
		Set JsonItem=JsonItem_""",""iconCls"":""icon-pro"",""expanded"":true,"
		
		Set tmpLoc=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,""))
		If tmpLoc'="" {
			Set JsonItem=JsonItem_"""checked"":true,"
		}Else{
			Set JsonItem=JsonItem_"""checked"":false,"
		}
		Set JsonItem=JsonItem_"""children"":["
		Write JsonItem  //输出Json1
		
		Set LocID="",JsonLoc=""
		For {
			Set LocID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID))
			Quit:LocID=""
			
			//add by zf 20111031 增加科室标识
			Set LocDesc=""
			Set:LocID'="" LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			Set LocDesc=$s(LocDesc="":"全局科室",1:LocDesc)
			
			Write:JsonLoc'="" JsonLoc
			Set JsonLocItem="{"_"""id"":"""_SubjectID_"||"_LocID_"-L-"",""text"":"""_$tr(LocDesc,"""","'")
			Set JsonLocItem=JsonLocItem_""",""iconCls"":""icon-pro"",""expanded"":true,"
			
			Set tmpCategID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,0))
			If tmpCategID'="" {
				Set JsonLocItem=JsonLocItem_"""checked"":true,"
			}Else{
				Set JsonLocItem=JsonLocItem_"""checked"":false,"
			}
			Set JsonLocItem=JsonLocItem_"""children"":["
			Write JsonLocItem  //输出JsonLoc1
			
			Set CategID=0,JsonA=""
			For {
				Set CategID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,CategID))
				Quit:CategID=""
				Set objCateg=##class(DHCMed.CC.ItemCat).GetObjById(CategID)
				Continue:'$IsObject(objCateg)
				
				Set SubCatID=0
				For {
					Set SubCatID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,CategID,SubCatID))
					Quit:SubCatID=""
					Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
					Continue:'$IsObject(objSubCat)
					
					Write:JsonA'="" JsonA
					Set JsonAItem="{"_"""id"":"""_SubjectID_"||"_LocID_"||"_CategID_"||"_SubCatID_"-D-"",""text"":"""_$tr(objCateg.ICDesc,"""","'")_"  "_$tr(objSubCat.ISCDesc,"""","'")_""","
					Set JsonAItem=JsonAItem_"""expanded"":true,"
					If $o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,CategID,SubCatID,0))'="" {
						Set JsonAItem=JsonAItem_"""checked"":true,"
					}Else{
						Set JsonAItem=JsonAItem_"""checked"":false,"
					}
					Set JsonAItem=JsonAItem_"""iconCls"":""icon-pro"","
					Set JsonAItem=JsonAItem_"""children"":["
					Write JsonAItem  //输出JsonA1
					
					Set ItemDicID=0,JsonB=""
					For {
						Set ItemDicID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,CategID,SubCatID,ItemDicID))
						Quit:ItemDicID=""
						Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicID)
						Continue:'$IsObject(objItemDic)
						Set ItemID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,LocID,CategID,SubCatID,ItemDicID,0))
						Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
						Continue:'$IsObject(objItem)
						Set ItemActive=objItem.IsActive
						Set ItemAbsolute=objItem.IsAbsolute
						Continue:ItemActive'=1
						
						Write:JsonB'="" JsonB
						Set JsonBItem="{"_"""id"":"""_ItemID_"-I-"","
						If ItemAbsolute=1 {
							Set JsonBItem=JsonBItem_"""text"":""<font color=red>"_$tr(objItemDic.IDDesc,"""","'")_"</font>"","
						}Else{
							Set JsonBItem=JsonBItem_"""text"":"""_$tr(objItemDic.IDDesc,"""","'")_""","
						}
						Set JsonBItem=JsonBItem_"""expanded"":true,"
						Set JsonBItem=JsonBItem_"""checked"":true,"
						Set JsonBItem=JsonBItem_"""iconCls"":""icon-menu"","
						Set JsonBItem=JsonBItem_"""children"":[]}"
						Write JsonBItem  //输出JsonB1+JsonB2
						Set JsonB=","
					}
					Write "]}"  //输出JsonA2
					Set JsonA=","
				}
			}
			Write "]}"  //输出JsonLoc2
			Set JsonLoc=","
		}
		Write "]}]"  //输出Json2
		Set Json=","
	}
	
	Kill ^TMP(ZIndex,JIndex,"BuildSubjectAppJson")
	Write:Json="" "[]"  //输出Json
	Quit 1
	
BuildSubjectAppJsonErr
	Write "Error:"_$ZERROR,!
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2011-03-17
/// Description:  根据监控主题构造json串
/// 
/// Table：       DHCMed_CC.Subject
///               DHCMed_CC.SubjectItm
///               DHCMed_CC.ItemDic
///               DHCMed_CC.ItemSubCat
///               DHCMed_CC.ItemCat
/// Input：       SubjectID：  监控主题ID
/// Return：      返回树形结构json串
/// 
/// 说明:         依托dhcmed.cc.sys.tree.csp输出
/// d ##Class(%ResultSet).RunQuery("DHCMed.CCService.Sys.CtrlItmTree","BuildSubjectJson","-root-","")
Query BuildSubjectJson(argNodeID As %String, argOutFormat As %String) As %Query(ROWSPEC = "id:%String,text:%String,iconCls:%String,leaf:%String")
{
}

ClassMethod BuildSubjectJsonExecute(ByRef qHandle As %Binary, argNodeID As %String, argOutFormat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"BuildSubjectJson")
	
	Set Type=$p(argNodeID,"-",2)
	If (Type="Dep")||(Type="root") {
		If Type="Dep" {
			
		}Else{
			Set SubjectID=0
			For {
				Set SubjectID=$o(^DHCMed.CC("Subject",SubjectID))
				Quit:SubjectID=""
				Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
				If $IsObject(objSubject){
					Set NodeID=SubjectID_"-Subject-"
					Set Desc=objSubject.Title
					Set Desc=$tr(Desc,"""","'")
					Set IconCls="icon-pro"
					Set Leaf="false"
					Set Data=""
					Set $li(Data,1)=$c(34)_NodeID_$c(34)
					Set $li(Data,2)=$c(34)_Desc_$c(34)
					Set $li(Data,3)=$c(34)_IconCls_$c(34)
					Set $li(Data,4)=Leaf
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
			If ($o(^DHCMed.CC("Subject",0))="")&&(argOutFormat=1) {
				Set NodeID="0-Subject-"
				Set Desc="请维护监控主题..."
				Set IconCls="icon-pro"
				Set Leaf="true"
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)=$c(34)_IconCls_$c(34)
				Set $li(Data,4)=Leaf
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}ElseIf Type="Subject" {
		Set SubjectID=$p(argNodeID,"-",1)
		Set tmp=$p(argNodeID,"-",3)
		Set CategID=0
		For {
			Set CategID=$o(^DHCMed.CCi("ItemCat",0,"SubjectIndex",SubjectID,CategID))
			Quit:CategID=""
			Set objCateg=##class(DHCMed.CC.ItemCat).GetObjById(CategID)
			If $IsObject(objCateg){
				Set NodeID=CategID_"-Categ-"_SubjectID_"||"_tmp
				Set Desc=objCateg.ICDesc
				Set LocID=objCateg.LocDr
				
				//add by zf 20111031 增加科室标识
				Set LocID=+LocID,LocDesc=""
				Set:LocID'="" LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
				Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
				Set LocDesc=$s(LocDesc="":"全局科室",1:LocDesc)
				Set:LocDesc'="" Desc=Desc_"("_LocDesc_")"
				
				Set Desc=$tr(Desc,"""","'")
				Set IconCls="icon-pro"
				Set Leaf="false"
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)=$c(34)_IconCls_$c(34)
				Set $li(Data,4)=Leaf
				
				//add by zf 20111031 按科室进行排序
				Set ^TMP(ZIndex,JIndex,"BuildSubjectJson",LocID,NodeID)=Data
			}
		}
		Set LocID=""
		For {
			Set LocID=$o(^TMP(ZIndex,JIndex,"BuildSubjectJson",LocID))
			Quit:LocID=""
			Set NodeID=0
			For {
				Set NodeID=$o(^TMP(ZIndex,JIndex,"BuildSubjectJson",LocID,NodeID))
				Quit:NodeID=""
				Set Data=$g(^TMP(ZIndex,JIndex,"BuildSubjectJson",LocID,NodeID))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		If ($o(^DHCMed.CCi("ItemCat",0,"SubjectIndex",SubjectID,0))="")&&(argOutFormat=1) {
			Set NodeID="0-Categ-"_SubjectID_"||"_tmp
			Set Desc="请维护监控项目大类..."
			Set IconCls="icon-pro"
			Set Leaf="true"
			Set Data=""
			Set $li(Data,1)=$c(34)_NodeID_$c(34)
			Set $li(Data,2)=$c(34)_Desc_$c(34)
			Set $li(Data,3)=$c(34)_IconCls_$c(34)
			Set $li(Data,4)=Leaf
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}ElseIf Type="Categ" {
		Set CategID=$p(argNodeID,"-",1)
		Set tmp=$p(argNodeID,"-",3)
		Set SubCatCode=""
		For {
			Set SubCatCode=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",CategID,SubCatCode))
			Quit:SubCatCode=""
			Set SubCatID=0
			For {
				Set SubCatID=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",CategID,SubCatCode,SubCatID))
				Quit:SubCatID=""
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
				If $IsObject(objSubCat){
					Set NodeID=SubCatID_"-SubCat-"_CategID_"||"_tmp
					Set Desc=objSubCat.ISCDesc
					Set Desc=$tr(Desc,"""","'")
					Set IconCls="icon-pro"
					Set Leaf="false"
					Set Data=""
					Set $li(Data,1)=$c(34)_NodeID_$c(34)
					Set $li(Data,2)=$c(34)_Desc_$c(34)
					Set $li(Data,3)=$c(34)_IconCls_$c(34)
					Set $li(Data,4)=Leaf
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
		
		If ($o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",CategID,""))="")&&(argOutFormat=1) {
			Set NodeID="0-SubCat-"_CategID_"||"_tmp
			Set Desc="请维护监控项目子类..."
			Set IconCls="icon-pro"
			Set Leaf="true"
			Set Data=""
			Set $li(Data,1)=$c(34)_NodeID_$c(34)
			Set $li(Data,2)=$c(34)_Desc_$c(34)
			Set $li(Data,3)=$c(34)_IconCls_$c(34)
			Set $li(Data,4)=Leaf
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}ElseIf Type="SubCat" {
		Set SubCatID=$p(argNodeID,"-",1)
		Set tmp=$p(argNodeID,"-",3)
		Set ItemDicID=0
		For {
			Set ItemDicID=$o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",SubCatID,ItemDicID))
			Quit:ItemDicID=""
			Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicID)
			If $IsObject(objItemDic){
				Set NodeID=ItemDicID_"-ItemDic-"_SubCatID_"||"_tmp
				Set Desc=objItemDic.IDDesc
				Set Desc=$tr(Desc,"""","'")
				Set IconCls="icon-menu"
				Set Leaf="true"
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)=$c(34)_IconCls_$c(34)
				Set $li(Data,4)=Leaf
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		If ($o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",SubCatID,0))="")&&(argOutFormat=1) {
			Set NodeID="0-ItemDic-"_SubCatID_"||"_tmp
			Set Desc="请维护监控项目..."
			Set IconCls="icon-menu"
			Set Leaf="true"
			Set Data=""
			Set $li(Data,1)=$c(34)_NodeID_$c(34)
			Set $li(Data,2)=$c(34)_Desc_$c(34)
			Set $li(Data,3)=$c(34)_IconCls_$c(34)
			Set $li(Data,4)=Leaf
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,"BuildSubjectJson")
	
	Quit $$$OK
}

ClassMethod BuildSubjectJsonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildSubjectJsonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod BuildSubjectJsonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildSubjectJsonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  构造函数库json串
/// 
/// Table：       DHCMed_CC.MethodPackage
///               DHCMed_CC.MethodInfo
/// Input：       
/// Return：      返回树形结构json串
/// 
/// 说明:         依托dhcmed.cc.sys.tree.csp输出
/// d ##Class(%ResultSet).RunQuery("DHCMed.CCService.Sys.CtrlItmTree","BuildMethodJson","","")
Query BuildMethodJson(argNodeID As %String, argOutFormat As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String,icon:%String,qtip:%String")
{
}

ClassMethod BuildMethodJsonExecute(ByRef qHandle As %Binary, argNodeID As %String, argOutFormat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set Type=$p(argNodeID,"-",2)
	If Type="root" {
		Set PackageID=0
		For {
			Set PackageID=$o(^DHCMed.CCF("Package",PackageID))
			Quit:PackageID=""
			Set objPackage=##class(DHCMed.CC.MethodPackage).GetObjById(PackageID)
			If $IsObject(objPackage){
				Set NodeID=PackageID_"-Package-"
				Set Desc=objPackage.Name
				Set Resume=objPackage.ResumeText
				Set:Resume'="" Desc=Desc_"("_Resume_")"
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)="false"
				Set $li(Data,4)="null"
				Set $li(Data,5)=$c(34)_"../images/websys/zreports.gif"_$c(34)
				Set $li(Data,6)=$c(34)_""_$c(34)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		If ($o(^DHCMed.CCF("Package",0))="")&&(argOutFormat=1) {
			Set NodeID="0-Package-"
			Set Desc="请维护包名..."
			Set Data=""
			Set $li(Data,1)=$c(34)_NodeID_$c(34)
			Set $li(Data,2)=$c(34)_Desc_$c(34)
			Set $li(Data,3)="true"
			Set $li(Data,4)="null"
			Set $li(Data,5)=$c(34)_"../images/websys/zreports.gif"_$c(34)
			Set $li(Data,6)=$c(34)_""_$c(34)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}ElseIf Type="Package" {
		Set PackageID=$p(argNodeID,"-",1)
		Set MethodID=0
		For {
			Set MethodID=$o(^DHCMed.CCFi("PMethod",0,"PackageIDIndex",PackageID,MethodID))
			Quit:MethodID=""
			Set objMethod=##class(DHCMed.CC.MethodInfo).GetObjById(MethodID)
			If $IsObject(objMethod){
				Set NodeID=MethodID_"-Method-"_PackageID
				Set Desc=objMethod.Name
				Set Resume=objMethod.ResumeText
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)="true"
				Set $li(Data,4)="null"
				Set $li(Data,5)=$c(34)_"../images/websys/report.gif"_$c(34)
				Set $li(Data,6)=$c(34)_Resume_$c(34)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		If ($o(^DHCMed.CCFi("PMethod",0,"PackageIDIndex",PackageID,0))="")&&(argOutFormat=1) {
			Set NodeID="0-Method-"_PackageID
			Set Desc="请维护函数..."
			Set Data=""
			Set $li(Data,1)=$c(34)_NodeID_$c(34)
			Set $li(Data,2)=$c(34)_Desc_$c(34)
			Set $li(Data,3)="true"
			Set $li(Data,4)="null"
			Set $li(Data,5)=$c(34)_"../images/websys/report.gif"_$c(34)
			Set $li(Data,6)=$c(34)_""_$c(34)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod BuildMethodJsonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildMethodJsonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod BuildMethodJsonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildMethodJsonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  构造函数库应用json串
/// 
/// Table：       DHCMed_CC.MethodPackage
///               DHCMed_CC.MethodInfo
/// Input：       
/// Return：      返回树形结构json串
/// 
/// 说明:         依托dhcmed.cc.sys.tree.csp输出
/// d ##Class(%ResultSet).RunQuery("DHCMed.CCService.Sys.CtrlItmTree","BuildMethodAppJson","root","")
Query BuildMethodAppJson(argNodeID As %String, argOutFormat As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String,icon:%String,qtip:%String")
{
}

ClassMethod BuildMethodAppJsonExecute(ByRef qHandle As %Binary, argNodeID As %String, argOutFormat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Type=$p(argNodeID,"-",2)
	If (Type="root")||(Type="") {
		Set PackageID=0
		For {
			Set PackageID=$o(^DHCMed.CCF("Package",PackageID))
			Quit:PackageID=""
			Set objPackage=##class(DHCMed.CC.MethodPackage).GetObjById(PackageID)
			If $IsObject(objPackage){
				Set NodeID=PackageID_"-Package-"
				Set Desc=objPackage.Name
				Set Resume=objPackage.ResumeText
				Set IsActive=objPackage.IsActive
				Continue:IsActive=0
				Set:Resume'="" Desc=Desc_"("_Resume_")"
				If $o(^DHCMed.CCFi("PMethod",0,"PackageIDIndex",PackageID,0))="" {
					Set Leaf="true"
				}Else{
					Set Leaf="false"  //有子节点
				}
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)=Leaf
				Set $li(Data,4)="null"
				Set $li(Data,5)=$c(34)_"../images/websys/zreports.gif"_$c(34)
				Set $li(Data,6)=$c(34)_""_$c(34)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}ElseIf Type="Package" {
		Set PackageID=$p(argNodeID,"-",1)
		Set MethodID=0
		For {
			Set MethodID=$o(^DHCMed.CCFi("PMethod",0,"PackageIDIndex",PackageID,MethodID))
			Quit:MethodID=""
			Set objMethod=##class(DHCMed.CC.MethodInfo).GetObjById(MethodID)
			If $IsObject(objMethod){
				Set NodeID=MethodID_"-Method-"_PackageID
				Set Desc=objMethod.Name
				Set IsActive=objMethod.IsActive
				Continue:IsActive=0
				Set Resume=objMethod.ResumeText
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)="true"
				Set $li(Data,4)="null"
				Set $li(Data,5)=$c(34)_"../images/websys/report.gif"_$c(34)
				Set $li(Data,6)=$c(34)_Resume_$c(34)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod BuildMethodAppJsonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildMethodAppJsonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod BuildMethodAppJsonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildMethodAppJsonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
