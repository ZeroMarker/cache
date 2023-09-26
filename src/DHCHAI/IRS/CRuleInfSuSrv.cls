/// 名称: DHCHAI.IRS.CRuleInfSuSrv
/// 描述: 疑似诊断规则相关服务
/// 编写者：zhufei
/// 编写日期: 2017-05-12
Class DHCHAI.IRS.CRuleInfSuSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-05
/// Description:  根据疑似诊断关键词筛查诊断
/// Table：       DHCHAI.BT.InfSuPos、DHCHAI.IR.CRuleInfSuPos
/// Input：       objResult : 疑似筛查结果
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CRuleInfSuSrv).CheckInfSuRule("肺炎")
ClassMethod CheckInfSuRule(aInfSuKeys As %String) As %String
{
	New (aInfSuKeys)
	Set return=""
	Quit:(aInfSuKeys="") return
	
	Kill arrInfSuPos
	
	//未确认疑似诊断
	Set KeyList=""
	For indKey=1:1:$l(aInfSuKeys,"^") {
		Set tKey=$p(aInfSuKeys,"^",indKey)
		Continue:tKey=""
		Set tKey=$zcvt(tKey,"U")
		Continue:$listfind(KeyList,tKey)>0
		Set KeyList=KeyList_$lb(tKey)
		
		Set xKey=""
		For {
			Set xKey=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofKeyPRI",xKey))
			Quit:xKey=""
			Continue:tKey'[$e(xKey,2,$l(xKey))
			
			Set xPRIDr=0
			For {
				Set xPRIDr=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofKeyPRI",xKey,xPRIDr))
				Quit:xPRIDr=""
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofKeyPRI",xKey,xPRIDr,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xID)
					Continue:'$IsObject(obj)
					Continue:'$IsObject(obj.BTSuPosDr)
					Set InfSuPosDr=obj.BTSuPosDr.%Id()
					Set InfSuPosDesc=obj.BTSuPosDr.BTDiagnos
					Set Property=obj.BTProperty
					If $IsObject(obj.BTPRIDr){ //优先级
						Set PRICode=obj.BTPRIDr.BTCode
					} Else {
						Set PRICode="99"
					}
					If Property=1 {
						Set arrInfSuPos("PRI",PRICode,indKey,InfSuPosDr)=$lb(tKey,InfSuPosDr,InfSuPosDesc)
					} Else {
						Set arrInfSuPos("Err",indKey,InfSuPosDr)=""
					}
				}
			}
		}
	}
	
	Set xPRI=""
	For {
		Set xPRI=$o(arrInfSuPos("PRI",xPRI))
		Quit:xPRI=""
		Quit:return'="" //优先级别匹配,取最高匹配级别
		
		Set xKey=""
		For {
			Set xKey=$o(arrInfSuPos("PRI",xPRI,xKey))
			Quit:xKey=""
			
			Set xSuPosDr=""
			For {
				Set xSuPosDr=$o(arrInfSuPos("PRI",xPRI,xKey,xSuPosDr))
				Quit:xSuPosDr=""
				Continue:$d(arrInfSuPos("Err",xKey,xSuPosDr))
				Set tData=$g(arrInfSuPos("PRI",xPRI,xKey,xSuPosDr))
				//tData=$lb(tKey,InfSuPosDr,InfSuPosDesc)
				Set return=return_$lb(tData)
			}
		}
	}
	Kill arrInfSuPos
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-01
/// Description:  疑似诊断-关键字
/// Table：       DHCHAI.IR.CRuleInfSuPos
/// Input：       DHCHAI.BT.InfSuPos->ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleInfSuSrv","QrySuPosKeysByID","1")
Query QrySuPosKeysByID(aSuPosID As %String) As %Query(ROWSPEC = "ID:%String,KeyWord:%String,TypeID:%String,TypeDesc:%String,Property:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUser:%String,CateID:%String,CateCode:%String,CateDesc:%String,IsCurrent:%String,CurrentDesc:%String,Note:%String") [ SqlProc ]
{
}

ClassMethod QrySuPosKeysByIDExecute(ByRef qHandle As %Binary, aSuPosID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aSuPosID="" $$$OK
	
	Set xID =""
    For {
		Set xID = $o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosDr",aSuPosID,xID))
		Quit:xID="" 
		
		Set obj = ##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xID)
		Continue:'$Isobject(obj)
		
		Set KeyWord	    = obj.BTKeyWord
		Set PRIID="",PRIDesc=""
		If $IsObject(obj.BTPRIDr) {
			Set PRIID=obj.BTPRIDr.%Id()
			Set PRIDesc=obj.BTPRIDr.BTDesc
		}
		Set Property    = obj.BTProperty
		Set Property=$s(Property=1:"包含",1:"排除")
		
		Set ActDate		= obj.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
		Set ActTime		= obj.BTActTime 
		Set:ActTime'="" ActTime=$zt(ActTime,1)  
		
		Set ActUserDr   = obj.BTActUserDr    	
		Set ActUserID="",ActUser="",ActUserDesc=""
		If $IsObject(obj.BTActUserDr) {
			Set ActUserID   = obj.BTActUserDr.%Id()
			Set ActUser     = obj.BTActUserDr.BTDesc
		}
		Set CateID="",CateCode="",CateDesc=""
		If $IsObject(obj.BTCatDr) {
			Set CateID   = obj.BTCatDr.%Id()
			Set CateCode = obj.BTCatDr.BTCode
			Set CateDesc = obj.BTCatDr.BTDesc
		}
		Set IsCurrent	= obj.BTIsCurrent
		Set CurrentDesc = $s(IsCurrent=1:"是",1:"否")
		Set Note	    = obj.BTNote
				
		Set Data = $lb(xID,KeyWord,PRIID,PRIDesc,Property,ActDate,ActTime,ActUserID,ActUser,CateID,CateCode,CateDesc,IsCurrent,CurrentDesc,Note)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
	    
	Quit $$$OK
}

ClassMethod QrySuPosKeysByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuPosKeysByIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySuPosKeysByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuPosKeysByIDExecute ]
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
/// CreatDate：   2019-04-26
/// Description:  查询疑似诊断医院感染关键词字
/// Table：       DHCHAI.IR.CRuleInfSuPos
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleInfSuSrv","QryInfSuPos","肺囊虫")
Query QryInfSuPos(aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,SuPosID:%String,InfPosID:%String,InfPos:%String,Diagnos:%String,KeyWord:%String,PRIID:%String,PRIDesc:%String,Property:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUser:%String,CateID:%String,CateCode:%String,CateDesc:%String,IsCurrent:%String,CurrentDesc:%String,Note:%String") [ SqlProc ]
{
}

ClassMethod QryInfSuPosExecute(ByRef qHandle As %Binary, aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Set rowIdField=0
    
    Set xSuPosDr = ""
	For {
		Set xSuPosDr = $o(^DHCHAI.BT.InfSuPosD(xSuPosDr))
		Quit:xSuPosDr=""
	
		Set objInf = ##class(DHCHAI.BT.InfSuPos).GetObjById(xSuPosDr)
		Continue:'$Isobject(objInf)
		Set Diagnos = objInf.BTDiagnos
		Set (InfPosID,InfPos)=""
		If $IsObject(objInf.BTInfPosDr) {
			Set InfPosID=objInf.BTInfPosDr.%Id()
			Set InfPos=objInf.BTInfPosDr.BTDesc
		}
		//增加处理没有维护关键词也显示出来
		Set (KeyWord,PRIID,PRIDesc,Property,ActDate,ActTime,ActUserID,ActUser,CateID,CateCode,CateDesc,IsCurrent,CurrentDesc,Note)=""		
		Set IsExsit = 0 //不存在
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosDr",xSuPosDr,xID))
			Quit:xID=""
	
			Set obj = ##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xID)
			Continue:'$Isobject(obj)
			Continue:'$IsObject(obj.BTCatDr)
	        Set CateID   = obj.BTCatDr.%Id()
			Set CateCode = obj.BTCatDr.BTCode
			Set CateDesc = obj.BTCatDr.BTDesc
			
			Set KeyWord	    = obj.BTKeyWord
			
			Continue:(aAlias'="")&&((Diagnos'[aAlias)&&(CateDesc'[aAlias)&&(KeyWord'[aAlias))
			
			Set PRIID="",PRIDesc=""
			If $IsObject(obj.BTPRIDr) {
				Set PRIID=obj.BTPRIDr.%Id()
				Set PRIDesc=obj.BTPRIDr.BTDesc
			}
			Set Property    = obj.BTProperty
			Set Property=$s(Property=1:"包含",1:"排除")
			
			Set ActDate		= obj.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
			Set ActTime		= obj.BTActTime 
			Set:ActTime'="" ActTime=$zt(ActTime,1)  
			
			Set ActUserDr   = obj.BTActUserDr    	
			Set ActUserID="",ActUser="",ActUserDesc=""
			If $IsObject(obj.BTActUserDr) {
				Set ActUserID   = obj.BTActUserDr.%Id()
				Set ActUser     = obj.BTActUserDr.BTDesc
			}
			
			Set IsCurrent	= obj.BTIsCurrent
			Set CurrentDesc = $s(IsCurrent=1:"是",1:"否")
			Set Note	    = obj.BTNote
			Set IsExsit =1 //存在
			Set Data = $lb(xID,xSuPosDr,InfPosID,InfPos,Diagnos,KeyWord,PRIID,PRIDesc,Property,ActDate,ActTime,ActUserID,ActUser,CateID,CateCode,CateDesc,IsCurrent,CurrentDesc,Note)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	
		}
		if (IsExsit=0)
		{
			Continue:(aAlias'="")&(Diagnos'[aAlias)
			Set Data = $lb(xID,xSuPosDr,InfPosID,InfPos,Diagnos,KeyWord,PRIID,PRIDesc,Property,ActDate,ActTime,ActUserID,ActUser,CateID,CateCode,CateDesc,IsCurrent,CurrentDesc,Note)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}
	Quit $$$OK
}

ClassMethod QryInfSuPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfSuPosExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfSuPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfSuPosExecute ]
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
/// CreatDate：   2018-02-24
/// Description:  导入疑似诊断关键词
/// Table：       DHCHAI.IR.CRuleInfSuPos
/// Input：       关键词字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IRS.CRuleInfSuSrv).ImportKeyWord("上呼吸道感染^痰1^一级^包含","^")
ClassMethod ImportKeyWord(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"

	Set SuPos    = $p(aInput,aSeparate,1)  //疑似诊断（部位）
	Set KeyWord  = $p(aInput,aSeparate,2)  //关键词
	Set PRType   = $p(aInput,aSeparate,3)  //优先级
	
	Set Property=1
	Set:$p(aInput,aSeparate,4)="排除" Property=0  //属性
	Set Cate     = $p(aInput,aSeparate,5)  //分类
	Quit:(SuPos="")||(KeyWord="")||(PRType="")||(Cate="") return
	Set IsCurrent = 1
	Set:$p(aInput,aSeparate,6)="否" IsCurrent=0   //是否通用
	Set Note      = $p(aInput,aSeparate,7)  //说明
	
	Set SuPosID=$o(^DHCHAI.BT.InfSuPosI("IdxofBTDiagnos",SuPos,0))
	Quit:SuPosID="" return
	
	Set CatDr=""
	Set objCate = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("InfSuPosKeyCate",Cate)
	Set:$Isobject(objCate) CatDr = objCate.%Id()
	
	Set PRTypeDr=""
	Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("InfSuPosKeyTpye",PRType)
	Set:$Isobject(objDic) PRTypeDr = objDic.%Id()
	
	Set InputStr=""                            //ID
	Set InputStr=InputStr_aSeparate_KeyWord    //关键词
	Set InputStr=InputStr_aSeparate_PRTypeDr   //优先级ID
	Set InputStr=InputStr_aSeparate_Property   //属性
    Set InputStr=InputStr_aSeparate_SuPosID    //疑似诊断ID
    Set InputStr=InputStr_aSeparate_"" 
    Set InputStr=InputStr_aSeparate_"" 
    Set InputStr=InputStr_aSeparate_"" 
    Set InputStr=InputStr_aSeparate_CatDr       //分类
    Set InputStr=InputStr_aSeparate_IsCurrent   //是否通用
    Set InputStr=InputStr_aSeparate_Note        //说明
    
	Set return=##Class(DHCHAI.IR.CRuleInfSuPos).Update(InputStr,aSeparate)
	Quit return
}

}
