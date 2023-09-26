/// 名称：DHCMed.EPDService.SuspScreeningSrv
/// 描述：传染病疑似筛查条件服务
Class DHCMed.EPDService.SuspScreeningSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-01-23
/// Description:  查询传染病疑似筛查条件
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspScreeningSrv","QryScreening","")
Query QryScreening(aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,InfectID:%String,InfectCode:%String,InfectDesc:%String,Condition:%String,Note:%String,Type:%String,TypeDesc:%String,IncludeKey:%String,ExcludeKeys:%String,LisItemDrs:%String,LisItems:%String,LisLogic:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryScreeningExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspScreeningD(xID))
		Quit:xID=""
		
		Set objScr = ##class(DHCMed.EPD.SuspScreening).GetObjById(xID)
		Continue:'$Isobject(objScr)
		Set IsActive = objScr.BTIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
        Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set (InfectID,InfectCode,InfectDesc)=""
	    If $Isobject(objScr.BTInfectDr){
		    Set InfectID   = objScr.BTInfectDr.%Id()
		    Set InfectCode = objScr.BTInfectDr.BTCode
		    Set InfectDesc = objScr.BTInfectDr.BTDesc
	    }    
		Set Condition    = objScr.BTCondition  
		Set Note         = objScr.BTNote       
		Set Type         = objScr.BTType 
		Set TypeDesc=$s(Type="K":"关键词",Type="I":"ICD编码",Type="L":"检验",Type="R":"检查")   
 
		Set IncludeKey   = objScr.BTIncludeKey 
		Set ExcludeKeys  = objScr.BTExcludeKeys
		Set LisItemDrs     = objScr.BTLisItems 
		Set LisItems = ""
		For indx=1:1:$length(LisItemDrs,",") {
			Set LisItemDr=$p(LisItemDrs,",",indx)
			Continue:LisItemDr=""
			Set objTest = ##class(DHCMed.EPD.SuspTestCode).GetObjById(LisItemDr)
			Continue:'$Isobject(objTest)
			Set LisItemCode = objTest.BTCode
			Set LisItemDesc = objTest.BTDesc
			Set LisItems=LisItems_","_LisItemDesc_"("_LisItemCode_")"
		}  
		Set:(LisItems'="") LisItems=$e(LisItems,2,$l(LisItems))
		Set LisLogic     = objScr.BTLisLogic 
		Set ActDate  = objScr.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set ActTime  = objScr.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime)
		Set ActUser  = objScr.BTActUser
				
		Set Data = $lb(xID,InfectID,InfectCode,InfectDesc,Condition,Note,Type,TypeDesc,IncludeKey,ExcludeKeys,LisItemDrs,LisItems,LisLogic,IsActive,IsActDesc,ActDate,ActTime,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryScreeningClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreeningExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryScreeningFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreeningExecute ]
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
/// CreatDate：   2019-01-26
/// Description:  根据疑似诊断查询传染病疑似筛查条件
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspScreeningSrv","QryScrByInfDic","")
Query QryScrByInfDic(aInfDic As %String) As %Query(ROWSPEC = "ID:%String,Condition:%String,Note:%String,Type:%String,TypeDesc:%String,IncludeKey:%String,ExcludeKeys:%String,LisItemDrs:%String,LisItems:%String,LisLogic:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryScrByInfDicExecute(ByRef qHandle As %Binary, aInfDic As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aInfDic="" $$$OK
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspScreeningI("IdxofInfect",aInfDic,xID))
		Quit:xID=""
		
		Set objScr = ##class(DHCMed.EPD.SuspScreening).GetObjById(xID)
		Continue:'$Isobject(objScr)
		Set IsActive = objScr.BTIsActive
        Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set Condition    = objScr.BTCondition  
		Set Note         = objScr.BTNote       
		Set Type         = objScr.BTType 
		Set TypeDesc=$s(Type="K":"关键词",Type="I":"ICD编码",Type="L":"检验",Type="R":"检查")   
 
		Set IncludeKey   = objScr.BTIncludeKey 
		Set ExcludeKeys  = objScr.BTExcludeKeys
		Set LisItemDrs     = objScr.BTLisItems 
		Set LisItems = ""
		For indx=1:1:$length(LisItemDrs,",") {
			Set LisItemDr=$p(LisItemDrs,",",indx)
			Continue:LisItemDr=""
			Set objTest = ##class(DHCMed.EPD.SuspTestCode).GetObjById(LisItemDr)
			Continue:'$Isobject(objTest)
			Set LisItemCode = objTest.BTCode
			Set LisItemDesc = objTest.BTDesc
			Set LisItems=LisItems_","_LisItemDesc_"("_LisItemCode_")"
		}  
		Set:(LisItems'="") LisItems=$e(LisItems,2,$l(LisItems))
		Set LisLogic     = objScr.BTLisLogic 
		Set ActDate  = objScr.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set ActTime  = objScr.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime)
		Set ActUser  = objScr.BTActUser
				
		Set Data = $lb(xID,Condition,Note,Type,TypeDesc,IncludeKey,ExcludeKeys,LisItemDrs,LisItems,LisLogic,IsActive,IsActDesc,ActDate,ActTime,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryScrByInfDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScrByInfDicExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryScrByInfDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScrByInfDicExecute ]
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
/// CreatDate：   2019-01-26
/// Description:  查询传染病疑似筛查条件（树形网格）
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspScreeningSrv","QryScreenInfo")
Query QryScreenInfo(aAlias As %String = "") As %Query(ROWSPEC = "RowId:%String,RowDesc:%String,ID:%String,InfectID:%String,InfectCode:%String,InfectDesc:%String,Condition:%String,Note:%String,Type:%String,TypeDesc:%String,IncludeKey:%String,ExcludeKeys:%String,LisItemDrs:%String,LisItems:%String,LisLogic:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,_parentId:%String") [ SqlProc ]
{
}

ClassMethod QryScreenInfoExecute(ByRef qHandle As %Binary, aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Set rowIdField=0
    Set xInfDr = ""
	For {
		Set xInfDr = $o(^DHCMed.EPD.SuspScreeningI("IdxofInfect",xInfDr))
		Quit:xInfDr=""
		
		Set objInf = ##class(DHCMed.EPD.SuspInfectDic).GetObjById(xInfDr)
		Continue:'$Isobject(objInf)
		Set InfectCode = objInf.BTCode
		Set InfectDesc = objInf.BTDesc
		Continue:(aAlias'="")&&(InfectDesc'[aAlias)    
		
		Set rowIdField=rowIdField+1,rowTreeField=InfectDesc
		Set Data = $lb(rowIdField,rowTreeField,"",xInfDr,InfectCode,InfectDesc,"","","","","","","","","","","","","","","","")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
		Set ParentId=rowIdField	
		Set xScrDr = ""
		For {
			Set xScrDr = $o(^DHCMed.EPD.SuspScreeningI("IdxofInfect",xInfDr,xScrDr))
			Quit:xScrDr=""
			
			Set objScr = ##class(DHCMed.EPD.SuspScreening).GetObjById(xScrDr)
			Continue:'$Isobject(objScr)
		
			Set IsActive = objScr.BTIsActive
	        Set IsActDesc=$s(IsActive=1:"是",1:"否")
			Set Condition    = objScr.BTCondition  
			Set Note         = objScr.BTNote       
			Set Type         = objScr.BTType 
			Set TypeDesc=$s(Type="K":"关键词(西医)",Type="I":"ICD编码",Type="L":"检验",Type="R":"检查",Type="KZ":"关键词(中医)")   
	 
			Set IncludeKey   = objScr.BTIncludeKey 
			Set ExcludeKeys  = objScr.BTExcludeKeys
			Set LisItemDrs     = objScr.BTLisItems 
			Set LisItems = ""
			For indx=1:1:$length(LisItemDrs,",") {
				Set LisItemDr=$p(LisItemDrs,",",indx)
				Continue:LisItemDr=""
				Set objTest = ##class(DHCMed.EPD.SuspTestCode).GetObjById(LisItemDr)
				Continue:'$Isobject(objTest)
				Set LisItemCode = objTest.BTCode
				Set LisItemDesc = objTest.BTDesc
				
				Set HaveActItem=0
				Set xExtSub=""
				For {
					Set xExtSub=$o(^DHCMed.EPD.SuspTestCodeD(LisItemDr,"EXT",xExtSub))
					Quit:xExtSub=""
					
					Set objExt=##class(DHCMed.EPD.SuspTestCodeExt).GetObjById(LisItemDr_"||"_xExtSub)
					Continue:'$IsObject(objExt)
					Continue:objExt.IsActive'=1
					Set HaveActItem=1
					Quit
				}
				
				If HaveActItem=1 {
					Set LisItems=LisItems_","_LisItemDesc_"("_LisItemCode_")"
				} Else {
					Set LisItems=LisItems_",【"_LisItemDesc_"("_LisItemCode_")】"
				}
			}  
			Set:(LisItems'="") LisItems=$e(LisItems,2,$l(LisItems))
			Set LisLogic     = objScr.BTLisLogic 
			Set ActDate  = objScr.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
			Set ActTime  = objScr.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime)
			Set ActUser  = objScr.BTActUser
			
			Set rowIdField=rowIdField+1,rowTreeField=Condition		
			Set Data = $lb(rowIdField,rowTreeField,xScrDr,xInfDr,InfectCode,InfectDesc,Condition,Note,Type,TypeDesc,IncludeKey,ExcludeKeys,LisItemDrs,LisItems,LisLogic,IsActive,IsActDesc,ActDate,ActTime,ActUser,ParentId)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}
	Quit $$$OK
}

ClassMethod QryScreenInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreenInfoExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryScreenInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreenInfoExecute ]
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
/// CreatDate：   2019-02-28
/// Description:  导入传染病疑似筛查条件
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       筛查条件字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.EPDService.SuspScreeningSrv).ImportScreen("鼠疫^鼠疫检验^L^^^001,002^&&^^1","^")
ClassMethod ImportScreen(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set Infect      = $p(aInput,aSeparate,1)  //疑似诊断
	Set Condition   = $p(aInput,aSeparate,2)  //筛查条件
	Set Type        = $p(aInput,aSeparate,3)  //筛查类型
	Set IncludeKey  = $p(aInput,aSeparate,4)  //诊断关键词
	Set ExcludeKeys = $p(aInput,aSeparate,5)  //排除关键词
	Set LisItems    = $p(aInput,aSeparate,6)  //检验项目
	Set LisLogic    = $p(aInput,aSeparate,7)  //逻辑运算
	Set Note        = $p(aInput,aSeparate,8)  //条件说明
	Set IsActive    = $p(aInput,aSeparate,9)  //是否有效
	Quit:(Infect="")||(Type="") return
	
	Set InfDr=$o(^DHCMed.EPD.SuspInfectDicI("IdxofDesc",Infect,0))
	Quit:InfDr="" return
	
	Set LisItemDrs=""
	For indx=1:1:$l(LisItems,",") {
		Set LisItem = $p(LisItems,",",indx)
		Continue:LisItem=""
		Set LisItemDr=$o(^DHCMed.EPD.SuspTestCodeI("IdxofCode",LisItem,0))
		Set LisItemDrs=LisItemDrs_","_LisItemDr
	}
	Set:LisItemDrs'="" LisItemDrs=$e(LisItemDrs,2,$l(LisItemDrs))
	
	// add 20200207 解决导入数据重复增加问题
	Set xID =""
	For { 
		Set xID=$o(^DHCMed.EPD.SuspScreeningI("IdxofInfect",InfDr,xID))
		Quit:xID=""
		Set obj = ##class(DHCMed.EPD.SuspScreening).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		Set BTCondition = obj.BTCondition
		Set BTType = obj.BTType
		Set BTIncludeKey = obj.BTIncludeKey
		Set BTExcludeKeys = obj.BTExcludeKeys
		Set BTLisItems = obj.BTLisItems
		Quit:(BTCondition=Condition)&&(BTType=Type)&&(BTIncludeKey=IncludeKey)&&(BTExcludeKeys=ExcludeKeys)&&(BTLisItems=LisItemDrs)
	}		
		
	Set InputStr=xID                            
	Set InputStr=InputStr_aSeparate_InfDr        
	Set InputStr=InputStr_aSeparate_Condition       
	Set InputStr=InputStr_aSeparate_Note       
	Set InputStr=InputStr_aSeparate_Type      
	Set InputStr=InputStr_aSeparate_IncludeKey       
	Set InputStr=InputStr_aSeparate_ExcludeKeys       
	Set InputStr=InputStr_aSeparate_LisItemDrs      
	Set InputStr=InputStr_aSeparate_LisLogic       
	Set InputStr=InputStr_aSeparate_IsActive   
	
	Set return=##Class(DHCMed.EPD.SuspScreening).Update(InputStr,aSeparate)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-11-23
/// Description:  同步传染病字典别名维护数据
/// Return：      处理别名数量
/// w ##class(DHCMed.EPDService.SuspScreeningSrv).SyncInfectionAlias()
ClassMethod SyncInfectionAlias() As %String
{
	Set return="",Count=0
	
	kill arrResult
	kill arrScreen
	kill arrKey
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspInfectDicD(xID))
		Quit:xID=""
		
		Set objDic = ##class(DHCMed.EPD.SuspInfectDic).GetObjById(xID)
		Continue:'$Isobject(objDic)
		// 传染病诊断
		Set (InfectID,Infection)=""
	    If $Isobject(objDic.BTInfectDr){
		    Set InfectID = objDic.BTInfectDr.%Id()
		    Set Infection = objDic.BTInfectDr.MIFDisease
	    }  
	    // 传染病分类
	    Set (KindCode,Kind)=""
	    If $Isobject(objDic.BTKindDr){
		    Set KindCode = objDic.BTKindDr.Code
		    Set Kind = objDic.BTKindDr.Description
	    }
	    Set num=0
	    If (InfectID'="") {  //具体诊断对应的别名
	    	Set xSubID=""
			For {
				Set xSubID=$o(^DHCMed.EPDC("IF",InfectID,"InfAlias",xSubID))
				Quit:xSubID=""
				Set Alias=$p($g(^DHCMed.EPDC("IF",InfectID,"InfAlias",xSubID)),"^",1)
				Set IsKeyword=+$p($g(^DHCMed.EPDC("IF",InfectID,"InfAlias",xSubID)),"^",2)
				Continue:(+IsKeyword)=0 //1-关键字,2-ICD10,3-排除关键词
			    Set num=num+1
				Set arrResult(xID,IsKeyword,num)=$lb(xID,IsKeyword,Alias,Infection)
			}
		    
	    }Else{ //诊断大类对应的别名
	        Set xIFRowID=""
			For {
				Set xIFRowID=$o(^DHCMed.EPDC("IF",xIFRowID))
				Quit:xIFRowID=""
				Set IsActive=$p($g(^DHCMed.EPDC("IF",xIFRowID)),"^",12)
				Continue:IsActive'="Y"
				Set IFKind=$p($g(^DHCMed.EPDC("IF",xIFRowID)),"^",3)
				Continue:IFKind'=KindCode
				Set xSubID=""
				For {
					Set xSubID=$o(^DHCMed.EPDC("IF",xIFRowID,"InfAlias",xSubID))
					Quit:xSubID=""
					Set Alias=$p($g(^DHCMed.EPDC("IF",xIFRowID,"InfAlias",xSubID)),"^",1)
					Set IsKeyword=+$p($g(^DHCMed.EPDC("IF",xIFRowID,"InfAlias",xSubID)),"^",2)
					Continue:(+IsKeyword)=0 //1-关键字,2-ICD10,3-排除关键词
					Set num=num+1
					Set arrResult(xID,IsKeyword,num)=$lb(xID,IsKeyword,Alias,Infection)
				}
			}
	   }
        
       If ($d(^DHCMed.EPD.SuspScreeningI("IdxofInfect",xID))) {  //已经存在数据
       	   Set KeyList="",ICDList="",ExcludeList="" 
	       Set xScreenID = ""
	       For {
				Set xScreenID=$o(^DHCMed.EPD.SuspScreeningI("IdxofInfect",xID,xScreenID))
				Quit:xScreenID=""
				
				Set objScr = ##class(DHCMed.EPD.SuspScreening).GetObjById(xScreenID)
				Continue:'$Isobject(objScr)
				Set IsActive = objScr.BTIsActive
				Continue:IsActive'=1

				Set Type         = objScr.BTType 
				Continue:(Type'="K")&&(Type'="I") //"K":"关键词","I":"ICD编码"	  
				Set IncludeKey   = objScr.BTIncludeKey
				If (IncludeKey'="")&&(Type="K") {
					If $listfind(KeyList,IncludeKey)<1 {
						Set KeyList=KeyList_$lb(IncludeKey)
					}
				}
				If (IncludeKey'="")&&(Type="I") {
					If $listfind(ICDList,IncludeKey)<1 {
						Set ICDList=ICDList_$lb(IncludeKey)
					}
				}
				Set ExcludeKeys  = objScr.BTExcludeKeys
				For indE=1:1:$l(ExcludeKeys,"#") {
					Set ExcludeKey=$p(ExcludeKeys,"#",indE)
					Continue:(ExcludeKey="")
					If $listfind(ExcludeList,ExcludeKey)<1 {
						Set ExcludeList=ExcludeList_$lb(ExcludeKey)
					}
				}
				Set arrScreen(xID,1)=KeyList
				Set arrScreen(xID,2)=ICDList
				Set arrScreen(xID,3)=ExcludeList
	       }  
		}
	
		Set xKeyType="",KeyList=""
		For {
			Set xKeyType=$o(arrResult(xID,xKeyType))
			Quit:xKeyType=""

			Set WordList =$g(arrScreen(xID,xKeyType))
			Set xNum=""
			For {
				Set xNum=$o(arrResult(xID,xKeyType,xNum))
				Quit:xNum=""
				Set KeyWordInfo = $g(arrResult(xID,xKeyType,xNum))
				Set KeyWord = $lg(KeyWordInfo,3)
				Continue:KeyWord=""	
				
				If ($listfind(WordList,KeyWord)<1)&&($listfind(KeyList,KeyWord)<1) {
					Set KeyList=KeyList_$lb(KeyWord)
				}	
			}
			If ($ll(KeyList)>0) {
				Set arrKey(xID,xKeyType)=KeyList
			}
		}
	}
   
	Set xInfDr=""
	For {
		Set xInfDr=$o(arrKey(xInfDr))
		Quit:xInfDr=""
		Set xKeyType=""
		For {
			Set xKeyType=$o(arrKey(xInfDr,xKeyType))
			Quit:xKeyType=""
			//1-关键字,2-ICD10,3-排除关键词 //"K":"关键词","I":"ICD编码"
			Set Type="K"	 
			Set:xKeyType=2 Type="I"
			
			Set KeyList=$g(arrKey(xInfDr,xKeyType))
			If (xKeyType=3) {
				Set IncludeKey="",ScreenID="",Condition="",ExcludeKeys=""
				Set xID =""   //从已有记录中选取
				For { 
					Set xID=$o(^DHCMed.EPD.SuspScreeningI("IdxofInfect",xInfDr,xID))
					Quit:xID=""
					Set obj = ##class(DHCMed.EPD.SuspScreening).GetObjById(xID)
					Continue:'$IsObject(obj)
					Set Type = obj.BTType
					Continue:Type'="K"				
					Set IncludeKey = obj.BTIncludeKey
					Set ExcludeKeys = obj.BTExcludeKeys
					Set Condition = obj.BTCondition
					Set ScreenID =xID
					Quit:IncludeKey'=""
				}
				  
				If (IncludeKey="") {  //从同步字典中选取
					Set IncludeKey=$lg(KeyList,1)
					Set ScreenID =""
				}
				For indL=1:1:$ll(KeyList) {
					Set Key=$listget(KeyList,indL)
					Set ExcludeKeys=ExcludeKeys_"#"_Key
				}
				Set:ExcludeKeys'="" ExcludeKeys=$e(ExcludeKeys,2,$l(ExcludeKeys))
				Set:Condition="" Condition="关键词排除"_ExcludeKeys
				
				Set InputStr=ScreenID                  
				Set InputStr=InputStr_"^"_xInfDr        
				Set InputStr=InputStr_"^"_Condition       
				Set InputStr=InputStr_"^"_IncludeKey       
				Set InputStr=InputStr_"^"_Type      
				Set InputStr=InputStr_"^"_""       
				Set InputStr=InputStr_"^"_ExcludeKeys       
				Set InputStr=InputStr_"^"_""      
				Set InputStr=InputStr_"^"_""       
				Set InputStr=InputStr_"^"_1  
				
				Set flg=##Class(DHCMed.EPD.SuspScreening).Update(InputStr,"^")
				If (flg>0) {
					Set Count=Count+1
				}
			}Else {
		        For indK=1:1:$ll(KeyList){			   
			        Set IncludeKey=$lg(KeyList,indK)
			        Continue:IncludeKey=""
			        Set Condition="关键词包含"_IncludeKey			 
					Set InputStr=""                            
					Set InputStr=InputStr_"^"_xInfDr        
					Set InputStr=InputStr_"^"_Condition       
					Set InputStr=InputStr_"^"_""       
					Set InputStr=InputStr_"^"_Type      
					Set InputStr=InputStr_"^"_IncludeKey       
					Set InputStr=InputStr_"^"_""       
					Set InputStr=InputStr_"^"_""      
					Set InputStr=InputStr_"^"_""       
					Set InputStr=InputStr_"^"_1  
					Set flg=##Class(DHCMed.EPD.SuspScreening).Update(InputStr,"^")
					If (flg>0) {
						Set Count=Count+1
					}
		        } 
			}
		}
	}

	
	kill arrResult
	kill arrScreen
	kill arrKey

	Set return=Count
	Quit return
}

}
