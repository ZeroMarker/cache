/// 名称: DHCMed.CCService.Sys.CtrlItemTree
/// 描述: 取监控条件json串,组织为监控项目树
/// 编写者：zhufei
/// 编写日期: 2014-03-03
Class DHCMed.CCService.Sys.CtrlItemTree Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-03-03
/// Description:  根据主题主题配置构造监控项目json串
/// 
/// Table：       DHCMed_CC.Subject
///               DHCMed_CC.SubjectItm
///               DHCMed_CC.ItemDic
///               DHCMed_CC.ItemSubCat
///               DHCMed_CC.ItemCat
/// Input：       SubjectCode：  主题配置代码
/// Return：      返回树形结构json串
/// w ##class(DHCMed.CCService.Sys.CtrlItemTree).BuildSubjectAppJson("INTCCS")
ClassMethod BuildSubjectAppJson(aConfigCode As %String, aLocID As %String = "", aWardID As %String = "") As %List
{
	New (aConfigCode,aLocID,aWardID)

	Set return=0,Json=""
	Quit:aConfigCode="" return
	
	Set $ZT="BuildSubjectAppJsonErr"
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"BuildSubjectAppJson")
	
	Set LocList=""
	Set:aLocID'="" LocList=$lb(aLocID)
	Set:aWardID'="" LocList=$lb(aWardID)
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aConfigCode)
	Quit:'$IsObject(objConfig) return
	Set ConfigID=objConfig.%Id()
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	Set SubActive=objSubject.IsActive
	Quit:SubActive'=1 return
	
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
			//检查是否主题配置中项目
			Continue:'$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,ItemSubCatDR))
			
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
	//Write "Error:"_$ZERROR,!
	Quit 0
}

}
