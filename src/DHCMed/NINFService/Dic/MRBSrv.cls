/// 名称: DHCMed.NINFService.Dic.MRBSrv
/// 描述: 与多重耐药菌相关的函数库
/// 编写者：liuyh
/// 编写日期: 2013-03-7
Class DHCMed.NINFService.Dic.MRBSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.Dic.MRBSrv).GetMRBRules(999,999)
ClassMethod GetMRBRules(JIndex, NIndex)
{
	New (JIndex,NIndex)
	Quit:(JIndex="")||(NIndex="") "Error"
	
	Set $ZT="GetMRBRulesErr"
	
	Kill ^TMP(JIndex,NIndex)
	
	Set MRBId=""
	For {
		Set MRBId=$o(^DHCMed.NINFD("MRB",MRBId))
		Quit:MRBId=""
		
		Set objMRB=##class(DHCMed.NINF.Dic.MRB).GetObjById(MRBId)
		Quit:'$IsObject(objMRB)
		
		Set IsActive=objMRB.Active
		Continue:IsActive'=1
		
		Set PYCategory=objMRB.PYCategory  //病原体分类
		Set Pathogeny=objMRB.Pathogeny    //病原体
		Set:(+Pathogeny)=0 Pathogeny=""
		Set CheckPyCate=""
		If Pathogeny'="" {
			Do GetMRBItem($lb(Pathogeny),"MRBPY","Item","")
		} ElseIf PYCategory'="" {
			Do GetMRBCate($lb(PYCategory),"MRBPY","Cate","")
		} Else {
			Continue  //无病原体项目
		}
		
		Set AntiCategory=objMRB.AntiCategory  //抗生素分类
		Set Antibiotics=objMRB.Antibiotics    //抗生素
		If Antibiotics'="" {
			Set AntibioticsActive=$list(Antibiotics,1)
			If AntibioticsActive="1" {
				Set AntibioticsCount=$list(Antibiotics,2)
				Set AntibioticsList=$list(Antibiotics,3)
				Do GetMRBItem(AntibioticsList,"MRBANT","Item",AntibioticsCount)
			}
		} ElseIf AntiCategory'="" {
			Set AntiCategoryActive=$list(AntiCategory,1)
			If AntiCategoryActive="1" {
				Set AntiCategoryCount=$list(AntiCategory,2)
				Set AntiCategoryList=$list(AntiCategory,3)
				Do GetMRBCate(AntiCategoryList,"MRBANT","Cate",AntiCategoryCount)
			}
		} Else {
			Continue  //无抗生素项目
		}
	}
	
	Quit "OK"
	
GetMRBCate(CateList,Note1,Note2,CheckCount)
	For indCate=1:1:$ll(CateList) {
		Set CateID=$list(CateList,indCate)
		Continue:CateID=""
		
		Set objCate=##class(DHCMed.NINF.Dic.Cate).GetObjById(CateID)
		Continue:'$IsObject(objCate)
		Set CateCode=objCate.Code
		
		Set xCategory=""
		For {
			Set xCategory=$o(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode",xCategory))
			Quit:xCategory=""
			Continue:$e(xCategory,2,$l(xCategory))'[$zcvt(CateCode,"U")
			
			Set xCode=""
			For {
				Set xCode=$o(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode",xCategory,xCode))
				Quit:xCode=""
				
				Set xId=""
				For {
					Set xId=$o(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode",xCategory,xCode,xId))
					Quit:xId=""
					
					Set objCateItem=##class(DHCMed.NINF.Dic.CateItem).GetObjById(xId)
					Continue:'$IsObject(objCateItem)
					
					Set IsActive=objCateItem.Active
					Continue:IsActive'=1
					Set Code=objCateItem.Code
					Continue:Code=""
					Set Desc=objCateItem.Description
					Continue:Desc=""
					Set Category=objCateItem.Category
					Continue:Category=""
					
					Set ^TMP(JIndex,NIndex,MRBId,Note1,Desc,Note2,Category)=$lb(Code,Desc,Category)
				}
			}
		}
	}
	//抗生素分类数量设置
	If (Note1="MRBANT")&&$d(^TMP(JIndex,NIndex,MRBId,Note1)) {
		Set CheckCount=+CheckCount
		Set:CheckCount<1 CheckCount=1
		Set ^TMP(JIndex,NIndex,MRBId,Note1)=CheckCount
	}
	
	Quit
	
GetMRBItem(CateItemList,Note1,Note2,CheckCount)
	For indItem=1:1:$ll(CateItemList) {
		Set ItemID=$list(CateItemList,indItem)
		Continue:ItemID=""
		
		Set objCateItem=##class(DHCMed.NINF.Dic.CateItem).GetObjById(ItemID)
		Continue:'$IsObject(objCateItem)
		
		Set IsActive=objCateItem.Active
		Continue:IsActive'=1
		Set Code=objCateItem.Code
		Continue:Code=""
		Set Desc=objCateItem.Description
		Continue:Desc=""
		Set Category=objCateItem.Category
		Continue:Category=""
		
		Set ^TMP(JIndex,NIndex,MRBId,Note1,Desc,Note2)=$lb(Code,Desc,Category)
	}
	//抗生素数量设置
	If (Note1="MRBANT")&&$d(^TMP(JIndex,NIndex,MRBId,Note1)) {
		Set CheckCount=+CheckCount
		Set:CheckCount<1 CheckCount=1
		Set ^TMP(JIndex,NIndex,MRBId,Note1)=CheckCount
	}
	
	Quit
	
GetMRBRulesErr
	Quit $ZError
}

/// Creator：     zhufei
/// CreatDate：   2013-07-05
/// Description:  通过细菌、抗菌药物判断是否为多重耐药菌
/// Table：       
/// Input：       argPathogeny : 细菌代码
///               argAntiList  : 抗生素代码列表
/// Return：      返回检验项目数量  ret=-1:Error
/// w ##class(DHCMed.NINFService.Dic.MRBSrv).CheckIsMRB("ECO",$lb("ER","IPM"))
ClassMethod CheckIsMRB(argPathogeny As %String, argAntiList As %String) As %String
{
	New (argPathogeny,argAntiList)
	Set return=""
	Quit:(argPathogeny="")||(argAntiList="") return
	
	Set JIndex=$j,NIndex="CheckIsMRB"
	
	//判断是否加载多耐规则
	Set CurrTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	If $g(^TMP(JIndex,NIndex))'=CurrTime {
		Kill ^TMP(JIndex,NIndex)
		Set ^TMP(JIndex,NIndex)=CurrTime
		Set flg=..GetMRBRules(JIndex,NIndex)
	}
	
	Set MRBId=""
	For {
		Set MRBId=$o(^TMP(JIndex,NIndex,MRBId))
		Quit:MRBId=""
		
		Continue:'$d(^TMP(JIndex,NIndex,MRBId,"MRBPY",argPathogeny))
		
		Set objMRB=##class(DHCMed.NINF.Dic.MRB).GetObjById(MRBId)
		Continue:'$IsObject(objMRB)
		Set MRBDesc=objMRB.Description
		Set MRBCode=objMRB.Code
		Continue:MRBCode["ESBL"  //去掉ESBL的项目
		
		//计算多耐相关分类数量
		Set numMDR=0,listMDR=""
		For indAnti=1:1:$ll(argAntiList) {
			Set Antibiotics=$list(argAntiList,indAnti)
			Continue:Antibiotics=""
			
			Continue:'$d(^TMP(JIndex,NIndex,MRBId,"MRBANT",Antibiotics))
			
			If $d(^TMP(JIndex,NIndex,MRBId,"MRBANT",Antibiotics,"Item")) {
				Continue:$listfind(listMDR,Antibiotics)>0
				Set listMDR=listMDR_$lb(Antibiotics)
				Set numMDR=numMDR+1
			} Else {
				Set Category=$o(^TMP(JIndex,NIndex,MRBId,"MRBANT",Antibiotics,"Cate",""))
				If Category'="" {
					Continue:$listfind(listMDR,Category)>0
					Set listMDR=listMDR_$lb(Category)
					Set numMDR=numMDR+1
				}
			}
		}
		
		//判断是否达到多耐要求
		If (numMDR>0) {
			Set tmpMDR=+$g(^TMP(JIndex,NIndex,MRBId,"MRBANT"))
			If (numMDR>=tmpMDR) {
				Set return=return_","_MRBDesc
			}
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Kill ^TMP(JIndex,NIndex)
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-07-05
/// Description:  通过细菌、分类判断是否属于ESBLs细菌
/// Table：       
/// Input：       argPathogeny : 细菌代码
/// Return：      返回检验项目数量  ret=-1:Error
/// w ##class(DHCMed.NINFService.Dic.MRBSrv).CheckIsESBLs("ECO",$lb("ER","IPM"))
ClassMethod CheckIsESBLs(argPathogeny As %String, argAntiList As %String) As %String
{
	New (argPathogeny,argAntiList)
	Set return=""
	Quit:(argPathogeny="") return
	
	Set JIndex=$j,NIndex="CheckIsESBLs"
	
	//判断是否加载多耐规则
	Set CurrTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	If $g(^TMP(JIndex,NIndex))'=CurrTime {
		Kill ^TMP(JIndex,NIndex)
		Set ^TMP(JIndex,NIndex)=CurrTime
		Set flg=..GetMRBRules(JIndex,NIndex)
	}
	Set MRBId=""
	For {
		Set MRBId=$o(^TMP(JIndex,NIndex,MRBId))
		Quit:MRBId=""
		
		Continue:'$d(^TMP(JIndex,NIndex,MRBId,"MRBPY",argPathogeny))
		
		Set objMRB=##class(DHCMed.NINF.Dic.MRB).GetObjById(MRBId)
		Continue:'$IsObject(objMRB)
		Set MRBDesc=objMRB.Description
		Set MRBCode=objMRB.Code
		Continue:MRBCode'["ESBL"  //只保留ESBL的项目
		
		If (argAntiList'="")&&$d(^TMP(JIndex,NIndex,MRBId,"MRBANT")) {
			//计算多耐相关分类数量
			Set numMDR=0,listMDR=""
			For indAnti=1:1:$ll(argAntiList) {
				Set Antibiotics=$list(argAntiList,indAnti)
				Continue:Antibiotics=""
				
				Continue:'$d(^TMP(JIndex,NIndex,MRBId,"MRBANT",Antibiotics))
				
				If $d(^TMP(JIndex,NIndex,MRBId,"MRBANT",Antibiotics,"Item")) {
					Continue:$listfind(listMDR,Antibiotics)>0
					Set listMDR=listMDR_$lb(Antibiotics)
					Set numMDR=numMDR+1
				} Else {
					Set Category=$o(^TMP(JIndex,NIndex,MRBId,"MRBANT",Antibiotics,"Cate",""))
					If Category'="" {
						Continue:$listfind(listMDR,Category)>0
						Set listMDR=listMDR_$lb(Category)
						Set numMDR=numMDR+1
					}
				}
			}
			
			//判断是否达到多耐要求
			If (numMDR>0) {
				Set tmpMDR=+$g(^TMP(JIndex,NIndex,MRBId,"MRBANT"))
				If (numMDR>=tmpMDR) {
					Set return=return_","_MRBDesc
				}
			}
		} Else {
			Set return=return_","_MRBDesc
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Kill ^TMP(JIndex,NIndex)
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-07-22
/// Description:  查询多重耐药菌定义字典
/// Table：       DHCMed.NINF.Dic.MRBDic
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.MRBSrv","QryMRBToCombo","1")
Query QryMRBToCombo(aIsActive As %String, aAddItem As %String = "") As %Query(ROWSPEC = "MRBID:%String,MRBCode:%String,MRBDesc:%String,MRBActive:%String,MRBActiveDesc:%String,MRBResume:%String")
{
}

ClassMethod QryMRBToComboExecute(ByRef qHandle As %Binary, aIsActive As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//add by zf 20140321 增加附加选项
 	Set aAddItem=$g(aAddItem)
	If aAddItem'="" {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemCode,addItemDesc,"","","")
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
 	Set xID=0
 	For {
		Set xID=$o(^DHCMed.NINFD("MRB",xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.NINF.Dic.MRB).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		Set Code=obj.Code
		Set Desc=obj.Description
		Set Active=obj.Active
		Continue:(aIsActive'="")&&(Active'=aIsActive)
		Set ActiveDesc=$s(Active=1:"是",1:"否")
	 	Set Resume=obj.Resume
	 	
	 	Set Data=$lb(xID,Code,Desc,Active,ActiveDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMRBToComboClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBToComboExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBToComboFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBToComboExecute ]
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

}
