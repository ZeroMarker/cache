/// 名称: DHCHAI.MAPS.MappingSrv
/// 描述: 值域字典数据对照服务类
/// 编写者：pylian
/// 编写日期: 2022-04-12
Class DHCHAI.MAPS.MappingSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2022-04-12
/// Description:  查询数据对照
/// Table：       DHCHAI.MAP.MapData
/// Input：       aType:分类编码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.MAPS.MappingSrv","QryMapData","","","血")
Query QryMapData(aType As %String = "", aNoMapFlg As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,Type:%String,KeyVal:%String,KeyText:%String,ItemDr:%String,ItemCode:%String,ItemDesc:%String,ItemCate:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String") [ SqlProc ]
{
}

ClassMethod QryMapDataExecute(ByRef qHandle As %Binary, aType As %String = "", aNoMapFlg As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	If (aType'=""){
		Set xID=""
		For {
			Set xID=$o(^CF.MA.HAI.MAP.MapDataI("IndexType",aType,xID))
			Quit:xID=""
			do BuildData
		}
	}Else{
		Set xID=0
	 	For {
		 	Set xID=$o(^CF.MA.HAI.MAP.MapDataD(xID))
		 	Quit:xID=""
		 	do BuildData
		}
	}
	Quit $$$OK
	
BuildData
 	Set MapData=$g(^CF.MA.HAI.MAP.MapDataD(xID))
 	Quit:MapData=""
 	Set ID        = xID
 	Set Type      = $lg(MapData,2)
 	
 	Set KeyVal    = $lg(MapData,3)
 	Set KeyText   = $lg(MapData,4)
 	Set ItemDr    = $lg(MapData,5)
 	Set IsActive  = $lg(MapData,6)
 	Set ActDate   = $lg(MapData,7)
 	Set ActTime   = $lg(MapData,8)
	Set IsActDesc = $s(IsActive=1:"是",1:"否")
	Quit:((aNoMapFlg=1)&&(ItemDr'=""))
	Set ItemData="",ItemCate="",ItemDesc="",ItemCode=""
	Set:ItemDr'="" ItemData=$g(^CF.MA.HAI.MAP.MapItemD(ItemDr))
	If (ItemData'=""){
		Set ItemCate = $lg(ItemData,3)
		Set ItemCode = $lg(ItemData,4)
		Set ItemDesc = $lg(ItemData,5)
	}Else {
		Set ItemID = $o(^CF.MA.HAI.MAP.MapItemI("IndexType",Type,0))
		Set:ItemID'="" ItemData=$g(^CF.MA.HAI.MAP.MapItemD(ItemID))
		Set ItemCate = $lg(ItemData,3)
	}
	
	Quit:(aAlias'="")&&(KeyVal'[aAlias)&&(KeyText'[aAlias)&&(ItemDesc'[aAlias)&&(ItemCate'[aAlias)
	
	Set:ActDate'="" ActDate=##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set:ActTime'="" ActTime=$zt(ActTime,1)
		
	Set Data=$lb(ID,Type,KeyVal,KeyText,ItemDr,ItemCode,ItemDesc,ItemCate,IsActive,IsActDesc,ActDate,ActTime)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    
    Quit
}

ClassMethod QryMapDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMapDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapDataExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2022-04-12
/// Description:  查询值域字典
/// Table：       DHCHAI.MAP.MapItem
/// Input：       aType:分类编码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.MAPS.MappingSrv","QryMapItem","")
Query QryMapItem(aType As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,Type:%String,Cate:%String,Code:%String,Desc:%String,Desc2:%String,Source:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryMapItemExecute(ByRef qHandle As %Binary, aType As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	If (aType'=""){
		Set xID=""
		For {
			Set xID=$o(^CF.MA.HAI.MAP.MapItemI("IndexType",aType,xID))
			Quit:xID=""
			do BuildItemData
		}
	}Else{
		Set xID=""
	 	For {
		 	Set xID=$o(^CF.MA.HAI.MAP.MapItemD(xID))
		 	Quit:xID=""
		 	do BuildItemData
		}
	}
	Quit $$$OK
	
BuildItemData
 	Set ItemData=$g(^CF.MA.HAI.MAP.MapItemD(xID))
 	Quit:ItemData=""
 	Set ID       = xID
 	Set Type     = $lg(ItemData,2)
 	Set Cate     = $lg(ItemData,3)
 	Set Code     = $lg(ItemData,4)
 	Set Desc     = $lg(ItemData,5)
 	Set Desc2    = $lg(ItemData,6)
 	Set Source   = $lg(ItemData,7)
 	Set IsActive = +$lg(ItemData,8)
	Set IsActDesc = $s(IsActive=1:"是",1:"否")
	Quit:(aAlias'="")&&(Desc'[aAlias)&&(Desc2'[aAlias)
	
	Set Data=$lb(ID,Type,Cate,Code,Desc,Desc2,Source,IsActive,IsActDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    
    Quit
}

ClassMethod QryMapItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMapItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapItemExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2022-04-12
/// Description:  查询分类/项目编码
/// Table：       DHCHAI.MAP.MapItem
/// Input：       aType:分类编码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.MAPS.MappingSrv","QryMapCate")
Query QryMapCate() As %Query(ROWSPEC = "Type:%String,Cate:%String") [ SqlProc ]
{
}

ClassMethod QryMapCateExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set TypeList=""
	Set xType=""
 	For {
	 	Set xType=$o(^CF.MA.HAI.MAP.MapItemI("IndexType",xType))
		Quit:xType=""
	
		If ($listfind(TypeList,xType)<1) {
			Set TypeList=TypeList_$lb(xType)
		}
		
		Set Cate=""
		Set xID=""
		For {
			Set xID=$o(^CF.MA.HAI.MAP.MapItemI("IndexType",xType,xID))
			Quit:xID=""
			Set ItemData=$g(^CF.MA.HAI.MAP.MapItemD(xID))
 			Continue:ItemData=""
 			Set Cate = $lg(ItemData,3)	
 			Quit	
		}
		Set Data=$lb(xType,Cate)
   	 	Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryMapCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapCateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMapCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapCateExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2022-04-14
/// Description:  判断是否有项目未对照
/// Table：       DHCHAI.MAP.MapData
/// Input：		 
/// Return：      0:无,1：有
/// w ##Class(DHCHAI.MAPS.MappingSrv).GetIsUnMap()
ClassMethod GetIsUnMap() As %String
{
 
	Set return=""
	
	Set Flg=0
	Set xID=""
 	For {
	 	Set xID=$o(^CF.MA.HAI.MAP.MapItemD(xID))
	 	Quit:xID=""
	 	Quit:Flg=1 
		Set MapData=$g(^CF.MA.HAI.MAP.MapDataD(xID))
	 	Continue:MapData=""
	 	Set Type      = $lg(MapData,2)
 		Set ItemDr    = $lg(MapData,5)
 		Set IsActive  = $lg(MapData,6)
        Set:(IsActive=1)&&(ItemDr="") Flg=1
 	}
 	
 	Set return=Flg
 	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-04-14
/// Description:  自动匹配对照规则
/// Table：       DHCHAI.MAP.MapItem,DHCHAI.MAP.MapData
/// Input：		 
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.MAPS.MappingSrv).SynMapData()
ClassMethod SynMapData() As %String
{
	Set return=0,Count=0
	
	//检验医嘱
	Set ret=..MapDicList("LabTestSet")
	Set:ret>0 Count=Count+ret
	
	//感染诊断
	Set ret=..MapDicList("InfPos")
	Set:ret>0 Count=Count+ret
	//科室字典
	Set ret=..MapDicList("LocWard")
	Set:ret>0 Count=Count+ret
	//给药途径
	Set ret=..MapDicList("AntiAdminRoute")
	Set:ret>0 Count=Count+ret
	//抗菌药物
	Set ret=..MapDicList("OEAntiMast")
	Set:ret>0 Count=Count+ret
	//标本
	Set ret=..MapDicList("LabSpecimen")
	Set:ret>0 Count=Count+ret

	Set return=Count
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-04-14
/// Description:  对照数据
/// Table：                 
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCHAI.MAPS.MappingSrv).MapDicList("InfPos")
ClassMethod MapDicList(aTypeCode As %String) As %String
{
	New (aTypeCode)
	Set return=0,Count=0
	
	Set xMapID=""
	For {  
		Set xMapID=$o(^CF.MA.HAI.MAP.MapDataI("IndexType",aTypeCode,xMapID))
	    Quit:xMapID=""
	   
	   	Set MapData =$g(^CF.MA.HAI.MAP.MapDataD(xMapID))
	   	Continue:MapData=""
		Set ItemDr  = $lg(MapData,5)
		Continue:ItemDr'=""  //已经对照不再同步匹配	
		Set Type    = $lg(MapData,2)			    	
		Set KeyVal  = $lg(MapData,3)
		Set KeyText = $lg(MapData,4)
		
		Set ItemID=""
		Set xItem=""    //名称一样可直接匹配
	    For {
		    Set xItem=$o(^CF.MA.HAI.MAP.MapItemI("IndexType",aTypeCode,xItem))
		    Quit:xItem=""
		    Quit:ItemID'=""
		    Set ItemData =$g(^CF.MA.HAI.MAP.MapItemD(xItem))
		    Set MapDesc=$lg(ItemData,5)
		    Set:KeyText=MapDesc ItemID=xItem 
	    }	
		    
		If aTypeCode="LabTestSet" { //检验医嘱			
			Set TestSetID =$o(^DHCHAI.DP.LabTestSetI("IndexTSCode",KeyVal,0))
			Continue:TestSetID=""
			Set TestSetData=$g(^DHCHAI.DP.LabTestSetD(TestSetID))
			Set CateDr=$lg(TestSetData,4)
			Continue:CateDr=""
			Set TestSetCat=$g(^DHCHAI.DP.LabTestSetCatD(CateDr))
			Set CateCode=$lg(TestSetCat,2)
			Set CateDesc=$lg(TestSetCat,3)
            Set MapCode=""
			Set:CateCode=1 MapCode="100"
			Set:CateCode=2 MapCode="500"
			Set:CateCode=3 MapCode="300"
			Set:CateCode=4 MapCode="400"
			Set:(KeyText="显微镜检查")&(CateCode=1) MapCode="200"
			Continue:MapCode=""
			Set ItemID=$o(^CF.MA.HAI.MAP.MapItemI("IndexTypeCode",aTypeCode,MapCode,0)) //直接匹配
			
		} ElseIf aTypeCode="InfPos" { //感染诊断
		  	If (ItemID="")	 {   //手术诊断对照
		  		Set MapCode=""
		  		Set:KeyVal="07" MapCode="070"
		  		Set:KeyVal="0701" MapCode="071"
		  		Set:KeyVal="0702" MapCode="072"
		  		Set:KeyVal="0703" MapCode="073"
		  		Continue:MapCode=""
		  		Set ItemID=$o(^CF.MA.HAI.MAP.MapItemI("IndexTypeCode",aTypeCode,MapCode,0)) //直接匹配
		  	}	    
		
		} ElseIf aTypeCode="AntiAdminRoute" { //给药途径
			If (ItemID="")	 {   //查找标准名称 
				Set TypeDr=$o(^DHCHAI.DP.PhraseTypeI("IndexCode"," "_$zcvt(aTypeCode,"U"),0))
				Continue:TypeDr=""
			
				Set xSCode =""
			    For {
				    Set xSCode=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode))
				    Quit:xSCode=""
				    Quit:ItemID'=""
				    Set xPhMapID =""
				    For {
				    	Set xPhMapID=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode,TypeDr,KeyVal,xPhMapID))
				    	Quit:xPhMapID=""
				    	Quit:ItemID'=""
				    	Set PhMapData=$g(^DHCHAI.DP.PhraseMapD(xPhMapID))
				    	Set MapDicDr=$lg(PhMapData,5)
						Continue:MapDicDr="" 
						Set DicData=$g(^DHCHAI.BT.DictionaryD(MapDicDr))
						Set DicDesc=$lg(DicData,3) //标准字典名称
					
						Set xItem=""
					    For {
						    Set xItem=$o(^CF.MA.HAI.MAP.MapItemI("IndexType",aTypeCode,xItem))
						    Quit:xItem=""
						    Quit:ItemID'=""
						    Set ItemData =$g(^CF.MA.HAI.MAP.MapItemD(xItem))
						    Set MapDesc=$lg(ItemData,5)
						    Set:DicDesc=MapDesc ItemID=xItem  //名称一样可直接匹配
					    }			    	
				    }
			    }
			}

		} ElseIf aTypeCode="OEAntiMast" { //抗菌药物	
 			Set xSCode =""
		    For {
			    Set xSCode=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xSCode))
			    Quit:xSCode=""
			    Quit:ItemID'=""
			     
			    Set xAntMapID=""
			    For {  
					Set xAntMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xSCode,KeyText,xAntMapID))
				    Quit:xAntMapID=""
				    Quit:ItemID'=""
				    
				    Set AntMapData=$g(^DHCHAI.DP.OEAntiMastMapD(xAntMapID))
				    Set MapItemDr =$lg(AntMapData,3)
				    Continue:MapItemDr=""
				    Set AntiMastData=$g(^DHCHAI.DP.OEAntiMastD(MapItemDr))
				    Set AntCode =$lg(AntiMastData,2)
				    Set AntName =$lg(AntiMastData,3)
				    
				    Set ItemID=$o(^CF.MA.HAI.MAP.MapItemI("IndexTypeCode",aTypeCode,AntCode,0)) //代码一样可直接匹配
				    If (ItemID="") {
					    Set xItem=""
					    For {
						    Set xItem=$o(^CF.MA.HAI.MAP.MapItemI("IndexType",aTypeCode,xItem))
						    Quit:xItem=""
						    Quit:ItemID'=""
						    Set ItemData =$g(^CF.MA.HAI.MAP.MapItemD(xItem))
						    Set MapDesc=$lg(ItemData,5)						  
						    Set:AntName=MapDesc ItemID=xItem  //名称一样可直接匹配
					    }
				    }
			    }
		    }
			
	    } ElseIf aTypeCode="LabSpecimen" { //标本
	    	
	    	If (ItemID="")	 {   //查找标准名称 
				Set xSCode =""
			    For {
				    Set xSCode=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",xSCode))
				    Quit:xSCode=""
				    Quit:ItemID'=""
				     
				    Set xSpecMapID=""
				    For {  
						Set xSpecMapID=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",xSCode,KeyText,xSpecMapID))
					    Quit:xSpecMapID=""
					    Quit:ItemID'=""
					    
					    Set SpecMapData=$g(^DHCHAI.DP.LabSpecMapD(xSpecMapID))
					    Set MapItemDr =$lg(SpecMapData,3)
					    Continue:MapItemDr=""
					    Set LabSpecData=$g(^DHCHAI.DP.LabSpecimenD(MapItemDr))
					    Set SpecDesc =$lg(LabSpecData,3)
					    
					    If (ItemID="") {
						    Set xItem=""
						    For {
							    Set xItem=$o(^CF.MA.HAI.MAP.MapItemI("IndexType",aTypeCode,xItem))
							    Quit:xItem=""
							    Quit:ItemID'=""
							    Set ItemData =$g(^CF.MA.HAI.MAP.MapItemD(xItem))
							    Set MapDesc=$lg(ItemData,5)						  
							    Set:SpecDesc=MapDesc ItemID=xItem  //名称一样可直接匹配		                       
						    }
					    }
				    }
			    }
	    	}
	    }ElseIf aTypeCode="LocWard" { //科室字典
		
		} 
	    //设置对照
		Set flg=##class(DHCHAI.MAP.MapData).UpdateMap(xMapID,ItemID)
		If (+flg)>0{
			Set Count=Count+1
		}
	} 
	Quit Count
}

/// Creator：     pylian
/// CreatDate：   2022-04-13
/// Description:  抽取需对照的数据
/// Table：       DHCHAI.MAP.MapItem,DHCHAI.MAP.MapData
/// Input：		 
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.MAPS.MappingSrv).SynSourceData()
ClassMethod SynSourceData() As %String
{
	Set return=0,Count=0

	//检验医嘱
	Set ret=..GetDicList("LabTestSet")
	Set:ret>0 Count=Count+ret
	
	//感染诊断
	Set ret=..GetDicList("InfPos")
	Set:ret>0 Count=Count+ret
	//科室字典
	Set ret=..GetDicList("LocWard")
	Set:ret>0 Count=Count+ret
	//给药途径
	Set ret=..GetDicList("AntiAdminRoute")
	Set:ret>0 Count=Count+ret
	//抗菌药物
	Set ret=..GetDicList("OEAntiMast")
	Set:ret>0 Count=Count+ret
	//标本
	Set ret=..GetDicList("LabSpecimen")
	Set:ret>0 Count=Count+ret

	Set return=Count
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-04-13
/// Description:  抽取数据
/// Table：                 
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCHAI.MAPS.MappingSrv).GetDicList("AntiAdminRoute")
ClassMethod GetDicList(aTypeCode As %String) As %String
{
	New (aTypeCode)
	Set return=0,Count=0
	
	If aTypeCode="LabTestSet" {
		//检验医嘱
		Set rs=##Class(%ResultSet).%New("DHCHAI.MAPS.MappingSrv:GetLabTestSet")
		Set sc=rs.Execute("")
	} ElseIf aTypeCode="InfPos" {
		//感染诊断
		Set rs=##Class(%ResultSet).%New("DHCHAI.MAPS.MappingSrv:GetInfPos")
		Set sc=rs.Execute("")
	} ElseIf aTypeCode="LocWard" {
		//科室字典
		Set rs=##Class(%ResultSet).%New("DHCHAI.MAPS.MappingSrv:GetLocation")
		Set sc=rs.Execute("")
	} ElseIf aTypeCode="AntiAdminRoute" {
		//给药途径
		Set rs=##Class(%ResultSet).%New("DHCHAI.MAPS.MappingSrv:GetPhraseMap")
		Set sc=rs.Execute("AntiAdminRoute")
	} ElseIf aTypeCode="OEAntiMast" {
		//抗菌药物
		Set rs=##Class(%ResultSet).%New("DHCHAI.MAPS.MappingSrv:GetOEAntiMastMap")
		Set sc=rs.Execute("")
	} ElseIf aTypeCode="LabSpecimen" {
		//标本
		Set rs=##Class(%ResultSet).%New("DHCHAI.MAPS.MappingSrv:GetLabSpecimen")
		Set sc=rs.Execute("")
	} 

  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	 
	    Set sID=rs.Data("ID")                // 源数据ID
		Set Code=rs.Data("Code")             // 代码
		Set Desc=rs.Data("Desc")             // 描述
		Set IsActive=rs.Data("IsActive")     // 是否有效
	    Set ItemDr=""
	    Set ID =$o(^CF.MA.HAI.MAP.MapDataI("IndexTypeVal",aTypeCode,Code,0)) 
	    If (ID'="" ) {
		    Set MapData=$g(^CF.MA.HAI.MAP.MapDataD(ID))
		    Continue:MapData=""
		    Set ItemDr=$lg(MapData,5)
	    }
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=aTypeCode
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=ItemDr
		Set $p(InputStr,"^",6)=IsActive
		Set flg=##class(DHCHAI.MAP.MapData).Update(InputStr,"^")
	
		If (+flg)>0{
			Set Count=Count+1
		}
	}
	Quit Count
}

/// Creator：      pylian
/// CreatDate：    2022-04-13
/// Description:   查询科室字典数据
/// Table：        DHCHAI.BT.Location
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.MAPS.MappingSrv","GetLocation","")
Query GetLocation(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLocationExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    If aID'="" {
	 	Do BuildLocData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.BT.LocationD(xID))
			Quit:xID=""
			
			Do BuildLocData(xID)
		}
	}
	Quit $$$OK
 	
BuildLocData(xID)
	Set tmpData=$g(^DHCHAI.BT.LocationD(xID))
	Quit:tmpData=""
	Set Code=$lg(tmpData,2)
	Set Desc=$lg(tmpData,3)
	Set TypeDr =$lg(tmpData,5)
	Quit:TypeDr=""
	Set TypeData=$g(^DHCHAI.BT.DictionaryD(TypeDr))
	Quit:TypeData=""
	Quit:$lg(TypeData,2)'="E"
	Set CateDr =$lg(tmpData,6)
	Quit:CateDr=""
	Set CateData=$g(^DHCHAI.BT.DictionaryD(CateDr))
	Quit:CateData=""
	Quit:$lg(CateData,2)'="I"
	Set IsActive=$lg(tmpData,14)
    //ID做唯一编码，方便取对照数据
	Set Data=$lb(xID,xID,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocationExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocationExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      pylian
/// CreatDate：    2022-04-13
/// Description:   查询检验医嘱数据
/// Table：        DHCHAI.DP.LabTestSet
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.MAPS.MappingSrv","GetLabTestSet","")
Query GetLabTestSet(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLabTestSetExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    If aID'="" {
	 	Do BuildTestSetData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.LabTestSetD(xID))
			Quit:xID=""
			
			Do BuildTestSetData(xID)
		}
	}
	Quit $$$OK
 	
BuildTestSetData(xID)
	Set tmpData=$g(^DHCHAI.DP.LabTestSetD(xID))
	Quit:tmpData=""
	Set Code=$lg(tmpData,2)
	Set Desc=$lg(tmpData,3)
	Set IsActive=$lg(tmpData,5)
	Set IsSubItem=$lg(tmpData,7)
	Quit:IsSubItem'=1
	
	Set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetLabTestSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLabTestSetExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLabTestSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLabTestSetExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      pylian
/// CreatDate：    2022-04-13
/// Description:   查询感染诊断数据
/// Table：        DHCHAI.BT.InfPos
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.MAPS.MappingSrv","GetInfPos","")
Query GetInfPos(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetInfPosExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    If aID'="" {
	 	Do BuildInfPosData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.BT.InfPosD(xID))
			Quit:xID=""
			
			Do BuildInfPosData(xID)
		}
	}
	Quit $$$OK
 	
BuildInfPosData(xID)
	Set tmpData=$g(^DHCHAI.BT.InfPosD(xID))
	Quit:tmpData=""
	Set Code=$lg(tmpData,2)
	Set Desc=$lg(tmpData,3)
	Set IsActive=$lg(tmpData,6)
	
	Set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInfPosExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInfPosExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      pylian
/// CreatDate：    2022-04-13
/// Description:   查询给药途径数据
/// Table：        DHCHAI.DP.PhraseMap
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.MAPS.MappingSrv","GetPhraseMap","AntiAdminRoute")
Query GetPhraseMap(aTypeCode As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetPhraseMapExecute(ByRef qHandle As %Binary, aTypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
    Quit:aTypeCode="" $$$OK
    
 	Set xSCode=""
    For {
	 	Set xSCode=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode))
	 	Quit:xSCode=""
	
	 	Set xTypeID=""
	 	For {
		 	Set xTypeID=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode,xTypeID))
		 	Quit:xTypeID=""
		 	
		 	Set PhTypeData=$g(^DHCHAI.DP.PhraseTypeD(xTypeID))
		 	Continue:PhTypeData=""
		 	Set TypeCode=$lg(PhTypeData,2)
		 	Continue:TypeCode'=aTypeCode
		 	
		 	Set xCode=""
		 	For {
			 	Set xCode=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode,xTypeID,xCode))
			 	Quit:xCode=""
		 	
			 	Set xID=0
			 	For {
				 	Set xID=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode,xTypeID,xCode,xID))
				 	Quit:xID=""
		 		
		 			Set PhMapData=$g(^DHCHAI.DP.PhraseMapD(xID))
		 			Continue:PhMapData=""
		 			Set Code=$lg(PhMapData,2)
		 			Set Desc=$lg(PhMapData,3)
		 			Set IsActive=$lg(PhMapData,7)
			 
					set Data=$lb(xID,Code,Desc,IsActive)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
			 	}
		 	}
	 	}
    }
	Quit $$$OK
}

ClassMethod GetPhraseMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhraseMapExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPhraseMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhraseMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      pylian
/// CreatDate：    2022-04-13
/// Description:   查询标本业务数据
/// Table：        DHCHAI.DP.LabSpecMap
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.MAPS.MappingSrv","GetLabSpecimen","")
Query GetLabSpecimen(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLabSpecimenExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildLabSpecData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.LabSpecMapD(xID))
			Quit:xID=""
			
			Do BuildLabSpecData(xID)
		}
	}
	Quit $$$OK
 	
BuildLabSpecData(xID)
	Set tmpData=$g(^DHCHAI.DP.LabSpecMapD(xID))
	Quit:tmpData=""
	Set Code=$lg(tmpData,2)
	Set Desc=$lg(tmpData,2)
	Set IsActive=$lg(tmpData,6)
	
	Set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetLabSpecimenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLabSpecimenExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLabSpecimenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLabSpecimenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      pylian
/// CreatDate：    2022-04-13
/// Description:   查询抗菌药物业务数据
/// Table：        DHCHAI.DP.LabSpecMap
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.MAPS.MappingSrv","GetOEAntiMastMap","")
Query GetOEAntiMastMap(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetOEAntiMastMapExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildAntiMastData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.OEAntiMastMapD(xID))
			Quit:xID=""
			
			Do BuildAntiMastData(xID)
		}
	}
	Quit $$$OK
 	
BuildAntiMastData(xID)
	Set tmpData=$g(^DHCHAI.DP.OEAntiMastMapD(xID))
	Quit:tmpData=""
	Set Code=$lg(tmpData,2)
	Set Desc=$lg(tmpData,2)
	Set IsActive=$lg(tmpData,7)
	
	Set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOEAntiMastMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOEAntiMastMapExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOEAntiMastMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOEAntiMastMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
