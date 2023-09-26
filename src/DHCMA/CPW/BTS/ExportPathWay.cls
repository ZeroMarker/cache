/// 名称: DHCMA.CPW.BTS.ExportPathWay
/// 描述: 临床路径表单导出程序
/// 编写者：jiangpengpeng
/// 编写日期: 2018-09-26
Class DHCMA.CPW.BTS.ExportPathWay Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2020-04-22
/// Description:  取路径数据
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BTS.ExportPathWay).GetCPWInfo(9)
ClassMethod GetCPWInfo(aFormID As %String) As %String
{
	New (aFormID)
	Set return=""
	Quit:aFormID="" return
	
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(objForm) return
	Quit:'$IsObject(objForm.FormPathDr) return
	
	Set MastID=objForm.FormPathDr.%Id()
	Set (ICD10s,ICDKeys,OperICDs,OperKeys)=""
	Set xTypeID=""
 	For {
	 	Set xTypeID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",MastID,xTypeID))
	 	Quit:xTypeID=""
		
	 	Set xID = ""
	 	For {
		 	Set xID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",MastID,xTypeID,xID))
		 	Quit:xID=""
		 	Set obj = ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xID)
		 	Continue:'$IsObject(obj)
		 	Continue:'obj.BTIsActive
		 	
		 	Set BTICD10 =obj.BTICD10
		 	Set BTICDKeys = obj.BTICDKeys
		 	Set BTOperICD = obj.BTOperICD
		 	Set BTOperKeys = obj.BTOperKeys
		 	
		 	Set:BTICD10'="" ICD10s=ICD10s_"、"_BTICD10
		 	Set:BTICDKeys'="" ICDKeys=ICDKeys_"、"_BTICDKeys
		 	Set:BTOperICD'="" OperICDs=OperICDs_"、"_BTOperICD
		 	Set:BTOperKeys'="" OperKeys=OperKeys_"、"_BTOperKeys
	 	}
 	}
	Set:ICD10s'="" ICD10s=$e(ICD10s,2,$l(ICD10s))
	Set:ICDKeys'="" ICDKeys=$e(ICDKeys,2,$l(ICDKeys))
	
	Set:OperICDs'="" OperICDs=$e(OperICDs,2,$l(OperICDs))
	Set:OperKeys'="" OperKeys=$e(OperKeys,2,$l(OperKeys))
	
	Set CPWInfo="['路径名称','"_objForm.FormPathDr.BTDesc_"'],"
	Set CPWInfo=CPWInfo_"['路径类型','"_objForm.FormPathDr.BTTypeDr.BTDesc_"'],"
	Set CPWInfo=CPWInfo_"['准入提示','"_objForm.FormApply_"'],"
	Set CPWInfo=CPWInfo_"['准入诊断ICD10','"_ICD10s_"'],"
	Set CPWInfo=CPWInfo_"['准入诊断关键字','"_ICDKeys_"'],"
	Set CPWInfo=CPWInfo_"['准入手术CM3','"_OperICDs_"'],"
	Set CPWInfo=CPWInfo_"['准入手术关键字','"_OperKeys_"'],"
	Set CPWInfo=CPWInfo_"['参考费用','"_objForm.FormCost_"'],"
	Set CPWInfo=CPWInfo_"['参考天数','"_objForm.FormDays_"'],"
	Set CPWInfo=CPWInfo_"['适用描述','"_objForm.FormHelpDoc_"']"
	Set CPWInfo=$tr(CPWInfo,$c(10))
	
	Set return=CPWInfo
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2020-04-22
/// Description:  取表单数据
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BTS.ExportPathWay).GetFormInfo(17)
ClassMethod GetFormInfo(aFormID As %String) As %String
{
	New (aFormID)
	Set return=""
	Quit:aFormID="" return
	
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(objForm) return
	Quit:'$IsObject(objForm.FormPathDr) return
	
	Set NIndex="GetFormInfo"
    Kill ^TMP($zn,$j,NIndex)
    
	Set xEpID=""
 	For {
	 	Set xEpID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xEpID))
	 	Quit:xEpID=""
	 	
		Set objEp = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aFormID_"||"_xEpID)
		Continue:'$IsObject(objEp)
		Continue:'objEp.EpIsActive
	 	Set EpDesc = objEp.EpDesc
	 	Set EpDays = objEp.EpDays
	 	Set EpIndNo = +objEp.EpIndNo
	 	Set ^TMP($zn,$j,NIndex,"步骤",EpIndNo,xEpID)=EpDesc
	 	Set ^TMP($zn,$j,NIndex,"天数",EpIndNo,xEpID)=EpDays
	 	
		Set (ItemListA,ItemListB,ItemListB1,ItemListB2,ItemListC)=""
		Set xItemID=""
		For {
		 	Set xItemID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xEpID,"ITM",xItemID))
		 	Quit:xItemID=""
		 	
			Set objItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aFormID_"||"_xEpID_"||"_xItemID)
			Continue:'$IsObject(objItem)
			Continue:'objItem.ItemIsActive
			
			Set ItemIndNo=objItem.ItemIndNo	//顺序号
			Set ItemID = objItem.%Id()	
			If '$d(^TMP($zn,$j,NIndex,"顺序号",ItemIndNo,ItemID)){
				Set ^TMP($zn,$j,NIndex,"顺序号",ItemIndNo,ItemID)=ItemIndNo
			}
		}
			Set IndNo=""
			For {
				Set IndNo = $o(^TMP($zn,$j,NIndex,"顺序号",IndNo))
				Quit:IndNo=""
				Set tID=""
				For {
					Set tID = $o(^TMP($zn,$j,NIndex,"顺序号",IndNo,tID))
					Quit:tID=""
					Set objItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(tID)
					Continue:'$IsObject(objItem)
					Set ItemCat=objItem.ItemCatDr.BTTypeDr.BTCode
				 	Set ItemDesc = objItem.ItemDesc
				 	Set IsOption = objItem.ItemIsOption
				 	Set ItemH=$s(IsOption:"【】",1:"【*】")
				 	
				 	If (ItemCat="A") {
				 		Set ItemListA=ItemListA_ItemH_ItemDesc_"&#10;"
				 	} ElseIf (ItemCat="C") {
				 		Set ItemListC=ItemListC_ItemH_ItemDesc_"&#10;"
				 	} Else {
					 	Set SubCatCode=objItem.ItemCatDr.BTCode
					 	If ($e(SubCatCode,1,3)="B01"){
				 			Set ItemListB1=ItemListB1_ItemH_ItemDesc_"&#10;"
					 	} Else {
					 		Set ItemListB2=ItemListB2_ItemH_ItemDesc_"&#10;"
					 	}
				 	}
				}
				Kill ^TMP($zn,$j,NIndex,"顺序号",IndNo)
			}
		Set ItemListB1="长期医嘱&#10;"_ItemListB1
		Set ItemListB2="临时医嘱&#10;"_ItemListB2
		Set ItemListB=ItemListB1_ItemListB2
		
		Set:ItemListA'="" ItemListA=$e(ItemListA,1,$l(ItemListA)-5)
		Set:ItemListB'="" ItemListB=$e(ItemListB,1,$l(ItemListB)-5)
		Set:ItemListC'="" ItemListC=$e(ItemListC,1,$l(ItemListC)-5)
		Set ^TMP($zn,$j,NIndex,"主要诊疗工作",EpIndNo,xEpID)=ItemListA
		Set ^TMP($zn,$j,NIndex,"重点医嘱",EpIndNo,xEpID)=ItemListB
		Set ^TMP($zn,$j,NIndex,"主要护理工作",EpIndNo,xEpID)=ItemListC
 	}
	
	Set FormInfo=""
	Set ListHead="步骤^天数^主要诊疗工作^重点医嘱^主要护理工作"
	Set xHead=""
	For ind=1:1:$length(ListHead,"^"){
		Set xHead=$p(ListHead,"^",ind)
		Set rowInfo="['"_xHead_"',"
		Set xIndNo=""
		For {
			Set xIndNo=$o(^TMP($zn,$j,NIndex,xHead,xIndNo))
			Quit:xIndNo=""
			Set xEID=""
			For {
				Set xEID=$o(^TMP($zn,$j,NIndex,xHead,xIndNo,xEID))
				Quit:xEID=""
				Set value=$g(^TMP($zn,$j,NIndex,xHead,xIndNo,xEID))
				Set rowInfo=rowInfo_"'"_value_"',"
			}
		}
		Set:rowInfo'="" rowInfo=$e(rowInfo,1,$l(rowInfo)-1)
		Set rowInfo=rowInfo_"],"
		Set FormInfo=FormInfo_rowInfo
	}
	Set:FormInfo'="" FormInfo=$e(FormInfo,1,$l(FormInfo)-1)
	
	Set return=FormInfo
	Quit return
}

/// w ##Class(DHCMA.CPW.BTS.ExportPathWay).ExportOrd("GetRowXML","9")
ClassMethod ExportOrd(aItmjs As %String, aFormID As %String) As %String
{
	New (aItmjs,aFormID)
	Set return=""
	Quit:aFormID="" return
	
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(objForm) return
	Quit:'$IsObject(objForm.FormPathDr) return
	
	Set MastID=objForm.FormPathDr.%Id()
	Set (ICD10s,ICDKeys,OperICDs,OperKeys)=""
	Set xTypeID=""
 	For {
	 	Set xTypeID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",MastID,xTypeID))
	 	Quit:xTypeID=""
		
	 	Set xID = ""
	 	For {
		 	Set xID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",MastID,xTypeID,xID))
		 	Quit:xID=""
		 	Set obj = ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xID)
		 	Continue:'$IsObject(obj)
		 	Continue:'obj.BTIsActive
		 	
		 	Set BTICD10 =obj.BTICD10
		 	Set BTICDKeys = obj.BTICDKeys
		 	Set BTOperICD = obj.BTOperICD
		 	Set BTOperKeys = obj.BTOperKeys
		 	
		 	Set:BTICD10'="" ICD10s=ICD10s_"、"_BTICD10
		 	Set:BTICDKeys'="" ICDKeys=ICDKeys_"、"_BTICDKeys
		 	Set:BTOperICD'="" OperICDs=OperICDs_"、"_BTOperICD
		 	Set:BTOperKeys'="" OperKeys=OperKeys_"、"_BTOperKeys
	 	}
 	}
	Set:ICD10s'="" ICD10s=$e(ICD10s,2,$l(ICD10s))
	Set:ICDKeys'="" ICDKeys=$e(ICDKeys,2,$l(ICDKeys))
	Set:OperICDs'="" OperICDs=$e(OperICDs,2,$l(OperICDs))
	Set:OperKeys'="" OperKeys=$e(OperKeys,2,$l(OperKeys))
	
	Set retval=aItmjs_"('路径名称','"_$ZCVT(objForm.FormPathDr.BTDesc,"O","JS")_"');"
	&javascript<#(retval)#>
	Set retval=aItmjs_"('路径类型','"_$ZCVT(objForm.FormPathDr.BTTypeDr.BTDesc,"O","JS")_"');"
	&javascript<#(retval)#>
	Set retval=aItmjs_"('准入诊断ICD10','"_$ZCVT(ICD10s,"O","JS")_"');"
	&javascript<#(retval)#>
	Set retval=aItmjs_"('准入诊断关键字','"_$ZCVT(ICDKeys,"O","JS")_"');"
	&javascript<#(retval)#>
	Set retval=aItmjs_"('准入手术CM3','"_$ZCVT(OperICDs,"O","JS")_"');"
	&javascript<#(retval)#>
	Set retval=aItmjs_"('准入手术关键字','"_$ZCVT(OperKeys,"O","JS")_"');"
	&javascript<#(retval)#>
	Set retval=aItmjs_"('适用描述','"_$ZCVT(objForm.FormHelpDoc,"O","JS")_"');"
	&javascript<#(retval)#>
	Set retval=aItmjs_"('参考费用','"_$ZCVT(objForm.FormCost,"O","JS")_"');"
	&javascript<#(retval)#>
	Set retval=aItmjs_"('参考天数','"_$ZCVT(objForm.FormDays,"O","JS")_"');"
	&javascript<#(retval)#>
	Set retval=aItmjs_"('阶段','项目','类型','医嘱','医嘱套明细');"
	&javascript<#(retval)#>
	
	Set ret=..GetEpByForm(aItmjs,aFormID)
	Quit ""
}

/// w ##Class(DHCMA.CPW.BTS.ExportPathWay).GetEpByForm(17)
ClassMethod GetEpByForm(aItmjs As %String, aFormID As %String) As %String
{
	New (aItmjs,aFormID)
	Set return=""
	Quit:aFormID="" return
	
	Set xEpID=""
 	For {
	 	Set xEpID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xEpID))
	 	Quit:xEpID=""
	 	
		Set objEp = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aFormID_"||"_xEpID)
		Continue:'$IsObject(objEp)
		Continue:'objEp.EpIsActive
	 	Set EpDesc = objEp.EpDesc
	 	
	 	Set retval=aItmjs_"('"_$ZCVT(EpDesc,"O","JS")_"');"
		&javascript<#(retval)#>
		
		Set return=..GetItemByEp(aItmjs,aFormID_"||"_xEpID)
		
 	}
 	
 	Quit return
}

/// w ##Class(DHCMA.CPW.BTS.ExportPathWay).GetItemByEp("17||1")
ClassMethod GetItemByEp(aItmjs As %String, aEpID As %String) As %String
{
	New (aItmjs,aEpID)
	Set return=""
	Quit:aEpID="" return
	
	Set aFormID=$p(aEpID,"||",1)
	Set aFormEpID=$p(aEpID,"||",2)
	
	Set (ItemListA,ItemListC,ItemListB)=""
	Set xItemID=""
	For {
	 	Set xItemID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",aFormEpID,"ITM",xItemID))
	 	Quit:xItemID=""
	 	
		Set objItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aFormID_"||"_aFormEpID_"||"_xItemID)
		Continue:'$IsObject(objItem)
		Continue:'objItem.ItemIsActive
		
		Set ItemCat=objItem.ItemCatDr.BTTypeDr.BTCode
	 	Set ItemDesc = objItem.ItemDesc
	 	Set TypeDesc=objItem.ItemCatDr.BTDesc
	 	Set Item=ItemDesc_"@"_TypeDesc_"@"_xItemID
	 	
	 	If (ItemCat="A") {
	 		Set ItemListA=ItemListA_"^"_Item
	 	} ElseIf (ItemCat="C") {
	 		Set ItemListC=ItemListC_"^"_Item
	 	} Else {
		 	Set ItemListB=ItemListB_"^"_Item
	 	}
	}
	For ind=1:1:$length(ItemListA,"^") {
		Set Item=$p(ItemListA,"^",ind)
		Continue:Item=""
		Set retval=aItmjs_"('','"_$ZCVT($p(Item,"@",1),"O","JS")_"','"_$ZCVT($p(Item,"@",2),"O","JS")_"');"
		&javascript<#(retval)#>
	}
	For ind=1:1:$length(ItemListC,"^") {
		Set Item=$p(ItemListC,"^",ind)
		Continue:Item=""
		Set retval=aItmjs_"('','"_$ZCVT($p(Item,"@",1),"O","JS")_"','"_$ZCVT($p(Item,"@",2),"O","JS")_"');"
		&javascript<#(retval)#>
	}
	For ind=1:1:$length(ItemListB,"^") {
		Set Item=$p(ItemListB,"^",ind)
		Continue:Item=""
		Set retval=aItmjs_"('','"_$ZCVT($p(Item,"@",1),"O","JS")_"','"_$ZCVT($p(Item,"@",2),"O","JS")_"');"
		&javascript<#(retval)#>
		
		Set return=..GetOrdByItem(aItmjs,aFormID_"||"_aFormEpID_"||"_$p(Item,"@",3))
	}
	
	Quit return
}

/// w ##Class(DHCMA.CPW.CPS.PrintSrv).GetOrdByItem("33||1||8")
ClassMethod GetOrdByItem(aItmjs As %String, aItemID As %String) As %String
{
	New (aItmjs,aItemID)
	Set return=""
	Quit:aItemID="" return
	
	Set iPathFormDr =$p(aItemID,"||",1)
	Set iPathFormEpDr =$p(aItemID,"||",2)
	Set iPathFormEpItemDr =$p(aItemID,"||",3)
 	
 	Set objItm = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aItemID)
	Quit:'$IsObject(objItm) -2
 	Set ItemDesc = objItm.ItemDesc
 	
	Set xChildID=""
 	For {
	 	Set xChildID = $o(^DHCMA.CPW.BT.PathFormD(iPathFormDr,"EP",iPathFormEpDr,"ITM",iPathFormEpItemDr,"ORD",xChildID))
	 	Quit:xChildID=""
	 	
		Set obj = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(aItemID_"||"_xChildID)
		Continue:'$IsObject(obj)
		Continue:'obj.OrdIsActive
		
	 	Set OrdMastID =obj.OrdMastID
	 	Continue:OrdMastID=""
	 	
	 	If $l(OrdMastID,"||")=2 {
	 		Set ArcimDesc=$p($g(^ARCIM(+OrdMastID,+$p(OrdMastID,"||",2),1)),"^",2)    //医嘱名称
	 		Set retval=aItmjs_"('','','','"_$ZCVT(ArcimDesc,"O","JS")_"');"
			&javascript<#(retval)#>
	 	} Else {
		 	Set ARCOSRowid=+OrdMastID
	 		Set ARCOSDesc=$p($g(^ARCOS(ARCOSRowid)),"^",2)
	 		Set retval=aItmjs_"('','','','"_$ZCVT("[医嘱套]"_ARCOSDesc,"O","JS")_"');"
			&javascript<#(retval)#>
			
	 		Set ARCOSDateRowid=##class(web.DHCDocOrderEntry).GetOrderSetDate(ARCOSRowid)
			Quit:ARCOSDateRowid=""
			
			Set OSItems=""
			Set xID=""
			For {
				Set xID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",xID))
				Quit:xID=""
				
				Set Itmstr=$g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",xID))
				Continue:Itmstr=""
				
				Set ARCIMRowid=$p(Itmstr,"^",1)
				Set ArcimDesc=$p($g(^ARCIM(+ARCIMRowid,+$p(ARCIMRowid,"||",2),1)),"^",2)    //医嘱名称
				Continue:ArcimDesc=""
				Set retval=aItmjs_"('','','','','"_$ZCVT(ArcimDesc,"O","JS")_"');"
				&javascript<#(retval)#>
			}
	 	}
 	}
 	
 	Quit return
}

}
