Class DHCMA.CPW.SDS.QCEntityItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2018-11-19
/// Description:  查询质控病种信息
/// Table：       DHCMA.CPW.SD.QCEntityItem      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntityItemSrv","QryQCEntityItem",7,"",1)
Query QryQCEntityItem(aParRef As %String, aKey As %String = "", aVersion As %String = "", aMatched As %String = "") As %Query(ROWSPEC = "BTID:%String,aParRef:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String,BTExpressDr:%String,BTExpressCode:%String,BTIsActive:%String,BTIndNo:%String,BTLinkedItem:%String,BTLinkedItemDesc:%String,BTTriggerCondition:%String,BTResume:%String,BTExpressParam:%String,BTIsNeeded:%String,BTItemCat:%String,BTItemSubCat:%String,GetDataParam:%String,BTUpTypeID:%String,BTUpTypeDesc:%String,ValiRule:%String,MatchItemCode:%String,MatchItemDesc:%String,StandConfig:%String")
{
}

ClassMethod QryQCEntityItemExecute(ByRef qHandle As %Binary, aParRef As %String, aKey As %String = "", aVersion As %String = "", aMatched As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Set xSubRowID=""	
 	For
 	{	
 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfParref",aParRef,xSubRowID))
 		Quit:xSubRowID=""
 		Set xRowID = aParRef_"||"_xSubRowID
 		
 		Set (BTCode,BTDesc,BTTypeDr,BTTypeDesc,BTUpTypeDr,BTUpTypeDesc,BTExpressDr,BTExpressCode,BTIsActive,BTIndNo,BTLinkedItemID,BTLinkedItemDesc,BTTriggerCondition,BTResume,BTExpressParam,BTIsNeeded,BTItemCat,BTItemCatDesc,GetDataParam)=""
 		Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
 		Set BTCode          = ObjEntityItem.BTCode
 		Set BTDesc         	= ObjEntityItem.BTDesc
 		Continue:(aKey'="")&&(BTCode'[aKey)&&(BTDesc'[aKey)
 		if ($IsObject(ObjEntityItem.BTTypeDr)) {
	 		Set BTTypeDr        = ObjEntityItem.BTTypeDr.%Id()
	 		Set BTTypeDesc      = ObjEntityItem.BTTypeDr.BTDesc
 		}
 		if ($IsObject(ObjEntityItem.BTUpTypeDr)) {
	 		Set BTUpTypeDr        = ObjEntityItem.BTUpTypeDr.%Id()
	 		Set BTUpTypeDesc      = ObjEntityItem.BTUpTypeDr.BTDesc
 		}
 		if ($IsObject(ObjEntityItem.BTExpressDr))
 		{
	 		Set BTExpressDr		= ObjEntityItem.BTExpressDr.%Id()
	 		Set BTExpressCode	= ObjEntityItem.BTExpressDr.BTCode
 		}
 		Set BTIsActive      = ObjEntityItem.BTIsActive
 		Set BTIndNo      	= ObjEntityItem.BTIndNo
 		if ($IsObject(ObjEntityItem.BTLinkedItem))
 		{
 			Set BTLinkedItemID  	= ObjEntityItem.BTLinkedItem.%Id()
 			Set BTLinkedItemDesc  	= ObjEntityItem.BTLinkedItem.BTDesc
 		}
 		//获取版本信息，默认条件展现当前有效版本
 		Set Version=ObjEntityItem.BTVersion.%Id()
 		Set QCEntityObj=##class(DHCMA.CPW.SD.QCEntity).GetObjById(aParRef)
 		Set QCVersion=""
 		Set:$IsObject(QCEntityObj.BTVersion) QCVersion=QCEntityObj.BTVersion.%Id()
 		Set:QCVersion="" QCVersion=1
 		Continue:(aVersion="")&&(Version'=QCVersion)
 		Continue:(aVersion'="")&&(aVersion'=Version)
 		//end
 		//判断项目是否有对照信息
 		Set (MatchItemCode,MatchItemDesc)=""
 		Set MatchItem=ObjEntityItem.BTMatchItem
 		If ($IsObject(MatchItem)) {
	 		Set MatchItemCode=MatchItem.BTCode
	 		Set MatchItemDesc=MatchItem.BTDesc
	 	}
 		Continue:(aMatched=1)&&(MatchItemCode="")
 		Continue:(aMatched=0)&&(MatchItemCode'="")
 		Set BTIsNeeded=ObjEntityItem.BTIsNeeded
 		Set BTIsActive=$s(BTIsActive=1:"是",1:"否")
 		Set BTIsNeeded=$s(BTIsNeeded=1:"是",1:"否")
 		Set BTTriggerCondition = ObjEntityItem.BTTriggerCondition
 		Set BTResume = ObjEntityItem.BTResume
 		Set BTExpressParam = ObjEntityItem.BTExpressParam
 		Set BTItemCat  	= ObjEntityItem.BTItemCat
 		Set BTItemSubCat = ObjEntityItem.BTItemSubCat
 		Set GetDataParam=ObjEntityItem.GetDataParam
 		//判断项目是否维护标准校验规则
 		Set ValiRule=""
 		Set:$d(^DHCMA.CPW.SD.QCEntityD(aParRef,"Item",xSubRowID,"Rule"))>1 ValiRule=1
 		
 		//判断是否做标准化取值配置
 		Set StandConfig=""
 		//数据源关联标准化配置
 		Set:$d(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",xRowID)) StandConfig=1
 		//项目描述自动匹配标准化字典
 		Set (StandDic,TableInfo)=""
 		Set StandDic=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetStandDicID(BTDesc)
 		Set:StandDic'="" TableInfo=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(StandDic)
 		Set:(StandDic'="")&&(TableInfo'="") StandConfig=2
		Set Data=$lb(xRowID,aParRef,BTCode,BTDesc,BTTypeDr,BTTypeDesc,BTExpressDr,BTExpressCode,BTIsActive,BTIndNo,BTLinkedItemID,BTLinkedItemDesc,BTTriggerCondition,BTResume,BTExpressParam,BTIsNeeded,BTItemCat,BTItemSubCat,GetDataParam,BTUpTypeDr,BTUpTypeDesc,ValiRule,MatchItemCode,MatchItemDesc,StandConfig)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryQCEntityItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCEntityItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCEntityItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCEntityItemExecute ]
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

/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).getItemTypeDescByCode("HF-0-1-1-4")
ClassMethod getItemTypeDescByCode(ItemCode As %String, aQCID As %String, aVerID As %String) As %String
{
	new (ItemCode,aQCID,aVerID)
	Set return=""
	Quit:(ItemCode="")||(aQCID="")||(aVerID="") return
	Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCID,ItemCode)
	Quit:'$IsObject(ItemObj) return
	if (ItemCode)
	Set ItemTypeDesc=ItemObj.BTTypeDr.BTDesc
	//该项设置默认值 且不可修改
	Set:(ItemObj.BTResume["Lock")||(ItemObj.BTResume["锁定") ItemTypeDesc=""
	Quit ItemTypeDesc
}

/// 获取被关联项目的其他关联项
/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).GetRelativeItemCode("VTE-0-1-1",33,2)
ClassMethod GetRelativeItemCode(aCode As %String, aQCID As %String, aVerID As %String) As %String
{
	n (aCode,aQCID,aVerID)
	Set return="",RelativeItemCodeStr=""
	Quit:(aCode="")||(aQCID="")||(aVerID="") return
	Set QCEntityID=aQCID
	Set xCode=""
	for {
		Set xCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVerID,xCode))
		Quit:xCode=""
		Set ItemID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVerID,xCode,aQCID,0))
		Set xItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(QCEntityID_"||"_ItemID)
		Continue:'$IsObject(xItemObj)
		Set LinkCode="",ItemCodeStr=""
		Set BTLinkedItem=xItemObj.BTLinkedItem
		if ($IsObject(BTLinkedItem)) {
			Set LinkCode=BTLinkedItem.BTCode
			Continue:(LinkCode'=aCode)
		}
		
		Set ItemCodeStr=""
		Set BTLinkedParam=xItemObj.BTTriggerCondition
		Continue:(LinkCode="")&&(BTLinkedParam="")
		if ((LinkCode="")&&(BTLinkedParam'="")) {
			Set ItemCodeLi=$lb("")
			for i=1:1:$l(BTLinkedParam,"}"){
				Set LinkedParamSub=$p(BTLinkedParam,"}",i)
				Set:LinkedParamSub["{" LinkedParamSub=$p(LinkedParamSub,"{",2)
				Continue:LinkedParamSub=""
				Continue:BTLinkedParam'[("("_aCode_")")
				Set CalcStr=$p(LinkedParamSub,":",2)
				for j=1:1:$l(CalcStr,")") {
						Set CodeSub=$p(CalcStr,")",j)
						Set Code=$p(CodeSub,"(",2)
						Set:$lf(ItemCodeLi,Code)<1 ItemCodeStr=ItemCodeStr_"^"_Code
						Set ItemCodeLi=ItemCodeLi_$lb(Code)
					}
			}
		}else{
				set ItemCodeStr="^"_LinkCode
			}
		Continue:ItemCodeStr'[aCode   //单个项目相关的code必须和入参code相关
		Set ItemCodeStr=$e(ItemCodeStr,2,$l(ItemCodeStr))
		Continue:RelativeItemCodeStr[ItemCodeStr
		Set RelativeItemCodeStr=RelativeItemCodeStr_"^"_ItemCodeStr
	}
	Set RelativeItemCodeStr=$e(RelativeItemCodeStr,2,$l(RelativeItemCodeStr))
	Quit RelativeItemCodeStr
}

/// ExpFlg 关联项是否展现
/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).GetSubItemMsg("^n^","^HF-2-1-A^HF-2-2-1")
ClassMethod GetSubItemMsg(aValueStr As %String, aCodeStr As %String, ShowFlg As %String = "0", aQCID As %String, aVerID As %String) As %String
{
	n (aValueStr,aCodeStr,ShowFlg,aQCID,aVerID)
	Set return="",SubItemCodeStr=""
	//处理前置参数 键-值
	for i=1:1:$l(aCodeStr,"^") {
		Set aCodeSub=$p(aCodeStr,"^",i)
		Continue:aCodeSub=""
		Set Code=aCodeSub
		Set CodeArr(aCodeSub)=$p(aValueStr,"^",i)
	}
	Quit:('$d(CodeArr)) return
	Set xCode=""
	For {
		Set xCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",aQCID,aVerID,xCode))
		Quit:xCode=""
		Set ItemID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVerID,xCode,aQCID,0))
		Set xItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aQCID_"||"_ItemID)
		Continue:'$IsObject(xItemObj)
		Set BTLinkedItem=xItemObj.BTLinkedItem
		Set BTLinkedParam=xItemObj.BTTriggerCondition
		Continue:('$IsObject(BTLinkedItem))&&(BTLinkedParam="")
		Continue:(xItemObj.BTItemCat="")
		If ($IsObject(BTLinkedItem)) {
			//关联了项目的
			Continue:'$d(CodeArr(BTLinkedItem.BTCode))
			if (ShowFlg=0) { //只要触发当前事件，第三级项目都不显示。
				Set SubItemCodeStr=SubItemCodeStr_"`"_0_"^"_xItemObj.BTCode
			}else{
				Set aValue=CodeArr(BTLinkedItem.BTCode)
				Set EditPower=0		
				Set BTTriggerCondition=","_xItemObj.BTTriggerCondition_","
				Set aValue=","_aValue_","
				Set:(aValue[BTTriggerCondition)||((BTTriggerCondition[aValue)) EditPower=1
				Set SubItemCodeStr=SubItemCodeStr_"`"_EditPower_"^"_xItemObj.BTCode
			}
		}elseif(BTLinkedParam'=""){
			//对于没有关联项目对象，写表达式的特殊处理
			Set ExcuteExp=BTLinkedParam
			Continue:BTLinkedParam'[")"
			for j=1:1:$l(BTLinkedParam,")") { //如果参数与表达式Code不匹配则终止判断
				Set CodeSub=$p(BTLinkedParam,")",j)
				Set Code=$p(CodeSub,"(",2)
				Continue:Code=""
				Set:'$d(CodeArr(Code)) ExcuteExp=0
			}	
			Continue:ExcuteExp=0
			if (ShowFlg=0) {
					Set SubItemCodeStr=SubItemCodeStr_"`"_0_"^"_xItemObj.BTCode
			}else{
				for ParamExpInd=1:1:$l(BTLinkedParam,"}") {
					Set ParamExpSub=$p(BTLinkedParam,"}",ParamExpInd)
					continue:ParamExpSub=""
					Set:ParamExpSub["{" ParamExpSub=$p(ParamExpSub,"{",2)
					Set ParamExp=$p(ParamExpSub,":",2)
					Set:ParamExp'[")" ExcuteExp=0 //如果有表达式未正常写入code格式，则退出
					Quit:ExcuteExp=0
					Set CodeTmp=""
					for {
						Set CodeTmp=$o(CodeArr(CodeTmp))
						Quit:CodeTmp=""
						continue:ParamExpSub'[("("_CodeTmp_")")   //滤除与子表达式无关的code值
						if ($p(ParamExpSub,":",1)="CALC-h") { //计算小时数
							Set EditPower=0,tmpHour=0
							Set tmpDate=$p(CodeArr(CodeTmp)," ",1)
							Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
							if (tmpDateLogic=""){
								Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,0)
								Quit  //如果有时间为空 则不执行表达式
							}
							Set tmpTime=$p(CodeArr(CodeTmp)," ",2),tmpTimeLogic=0
							Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
							//将各个时间参数换算为与固定时间小时差
							Set tmpHour=(tmpDateLogic-60000)*24+(tmpTimeLogic\3600)
							Set ParamExp=$Replace(ParamExp,"("_CodeTmp_")",tmpHour)
						}elseif ($p(ParamExpSub,":",1)="CALC-m") { //计算分钟数
							Set tmpMin=0
							Set tmpDate=$p(CodeArr(CodeTmp)," ",1)	
							Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
							if (tmpDateLogic=""){
								Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,0)
								Quit  //如果有时间为空 则不执行表达式
							}
							Set tmpTime=$p(CodeArr(CodeTmp)," ",2),tmpTimeLogic=0
							Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
							//将各个时间参数换算为与固定时间分钟差
							Set tmpMin=(tmpDateLogic-60000)*24*60+(tmpTimeLogic\60)
							Set ParamExp=$Replace(ParamExp,"("_CodeTmp_")",tmpMin)
						}elseif ($p(ParamExpSub,":",1)="CALC-month") { //计算月数
							Set EditPower=0
							Set tmpDate=$p(CodeArr(CodeTmp)," ",1)
							Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
							if (tmpDateLogic=""){
								Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,0)
								Quit  //如果有时间为空 则不执行表达式
							}
							Set tmpDate=$zd(tmpDateLogic,3)
							Set tmpMon=$p(tmpDate,"-",1)*12+$p(tmpDate,"-",2)+$fn(($p(tmpDate,"-",3)/30),"",2)
							Set ParamExp=$Replace(ParamExp,"("_CodeTmp_")",tmpMon)
						}elseif ($p(ParamExpSub,":",1)="CALC-year") { //计算年龄
							Set EditPower=0
							Set tmpDate=$p(CodeArr(CodeTmp)," ",1)
							Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
							if (tmpDateLogic=""){
								Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,0)
								Quit  //如果有时间为空 则不执行表达式
							}
							Set tmpDate=$zd(tmpDateLogic,3)
							Set tmpYear=$p(tmpDate,"-",1)+$fn($p(tmpDate,"-",2),"",2)+$fn(($p(tmpDate,"-",3)/(30*12)),"",2)
							Set ParamExp=$Replace(ParamExp,"("_CodeTmp_")",tmpYear)
						}else{
							//默认情况下替换Code值，进行运算
							Set CodeValue=""""_$g(CodeArr(CodeTmp))_""""
							Set ParamExp=$Replace(ParamExp,"("_CodeTmp_")",CodeValue)
						}
					}
					Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,ParamExp)
				}
				//小括号被作为标记项目code符号，所以表达式优先级用[] {}来写
				Set ExcuteExp=$tr($tr(ExcuteExp,"[","("),"]",")")  //[]相当于小括号
				Set ExcuteExp=$tr($tr(ExcuteExp,"{","("),"}",")")
				Set ExcuteExp=$Replace(ExcuteExp,"不包含","'[")
				Set ExcuteExp=$Replace(ExcuteExp,"包含","[")
				Set ExcuteExp=$Replace(ExcuteExp,"!","'")
				//处理包含关系 oth[o类似情况
				if (ExcuteExp["[") {
					Set ExcuteExp=..ChangeExp(ExcuteExp)
						
				}
				Set Exp="Set result="_ExcuteExp
				x Exp
				if (result) {
					Set EditPower=1
					Set SubItemCodeStr=SubItemCodeStr_"`"_EditPower_"^"_xItemObj.BTCode
				}elseif('result){
					Set SubItemCodeStr=SubItemCodeStr_"`"_0_"^"_xItemObj.BTCode
				}
			}
	 	}
	}
	Set:SubItemCodeStr'="" SubItemCodeStr=$e(SubItemCodeStr,2,$l(SubItemCodeStr))
	Set return=SubItemCodeStr
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).GetSubItemMsgNew("^y^^","^CABG-1-4-1-1^CABG-1-4-1-3^CABG-1-4-1-2")
ClassMethod GetSubItemMsgNew(aValueStr As %String, aCodeStr As %String, aQCID As %String, aVerID As %String) As %String
{
	n (aValueStr,aCodeStr,aQCID,aVerID)
	Set return=""
	Set MCodeStr=""
	Set MCodeStr=..GetSubItemMsg(aValueStr,aCodeStr,1,aQCID,aVerID)
	Set LastCodeStr=""
	Set tString=MCodeStr
	while(tString'="") {
		Set tString=$$GetSubItemMsg(tString)
	}
	Set LastCodeStr=$e(LastCodeStr,2,$l(LastCodeStr))
	Quit MCodeStr_"`"_LastCodeStr
GetSubItemMsg(CodeStr)
	Set tCodeStr=""
	For j=1:1:$l(CodeStr,"`"){
		Set CodeValue=$p(CodeStr,"`",j)
		Set tCode	= $p(CodeValue,"^",2)
		Set tValue	= $p(CodeValue,"^",1)
		Continue:tValue=1   ;如果该项目为显示状态，则不再处理子项目，反之则将相关的子项目隐藏
		Set tmpCode=..GetSubItemMsg("",tCode,0,aQCID,aVerID)
		Continue:tmpCode=""
		Set tCodeStr=tCodeStr_"`"_tmpCode	
	}
	For k=1:1:$l(aCodeStr,"^"){
		Set xInputCode=$p(aCodeStr,"^",k)
		Continue:xInputCode=""
		Set:(tCodeStr_"`")[(xInputCode_"`") tCodeStr="" ;如果循环检索到初始参数，代表已经遍历完成，应退出循环
	}
	Set:tCodeStr'="" tCodeStr=$e(tCodeStr,2,$l(tCodeStr)),LastCodeStr=LastCodeStr_"`"_tCodeStr
	Quit tCodeStr
}

/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).ImportFormItems(^tmpzgz120,$c(1))
ClassMethod ImportFormItems(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set ^tmpzgz120=aInputStr
	Set return=-1
	Quit:aInputStr="" return		
	Set ParrefCode		 = $p(aInputStr,aSeparete,1)
	Set IndNo            = $p(aInputStr,aSeparete,2)
	Set Code             = $p(aInputStr,aSeparete,3)
	Set Desc             = $p(aInputStr,aSeparete,4)
	Set UpTypeDesc   	 = $p(aInputStr,aSeparete,5)
	Set Parref= ##class(DHCMA.CPW.SD.QCEntity).GetObjByCode(ParrefCode)
	Set ParrefID=Parref.%Id()
	Set:UpTypeDesc["整型" UpTypeDesc="数值"
	Set UpTypeDr=""
	Set UpTypeDicObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDUpType",UpTypeDesc)	
	Set:$IsObject(UpTypeDicObj) UpTypeDr=UpTypeDicObj.%Id()
	Set ExpressDr        = ""
	Set IsActive         = "1"
	Set BTIsNeeded=0
	Set BTIsNeededDesc	 = $p(aInputStr,aSeparete,6)
	Set:BTIsNeededDesc="是" BTIsNeeded=1
	Set:BTIsNeededDesc["作废" IsActive= "0"
	Set BTResume	 	 = $p(aInputStr,aSeparete,7)
	Set LinkedItemCode   = $p(aInputStr,aSeparete,8)
	
	Set TriggerCondition = $p(aInputStr,aSeparete,9)
	Set ItemCat          = $p(aInputStr,aSeparete,10)
	Set ItemSubCat       = $p(aInputStr,aSeparete,11)
	Set BTExpressParam	 = $p(aInputStr,aSeparete,12)
	Set ItemType	 	 = $p(aInputStr,aSeparete,13)
	Set ItemVersion	 	 = $p(aInputStr,aSeparete,14)
	Quit:ItemVersion="" return
	Set ItemVersionObj=##Class(DHCMA.CPW.SD.QCEntityVersion).GetObjByCode(ItemVersion)
	Quit:'$IsObject(ItemVersionObj) return
	Set VersionID=ItemVersionObj.%Id()
	Set LinkedItemID=""
	Set LinkItemObj		 = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VersionID,ParrefID,LinkedItemCode)
	Set:$IsObject(LinkItemObj) LinkedItemID=LinkItemObj.%Id()	
	Set ItemType=$case(ItemType,"下拉单选字典":"下拉字典","下拉多选字典":"多选字典列表",:ItemType)
	Set:(ItemType="下拉字典")&&(Desc["是否") ItemType="单选字典列表"
	Set:(ItemType="下拉字典")&&(Desc["?") ItemType="单选字典列表"
	Set:(ItemType="下拉字典")&&(Desc["性别") ItemType="单选字典列表"
	Set:(ItemType="整型")&&(ItemCat["费") ItemType="数值"
	Set ItemTypeDr=""
	Set ItemTypeDicObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDType",ItemType)	
	Set:$IsObject(ItemTypeDicObj) ItemTypeDr=ItemTypeDicObj.%Id()
	Set GetDataParam     = ""
	//add by zgz 20210409 导入相同版本的表单时，先将该版本项目置为无效
	//默认一天只给批量无效一次
	d ..DisabledVerItem(ParrefID,VersionID)
	Set ID="",SubID=""
	Set:ParrefID'="" SubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VersionID," "_$zcvt(Code,"U"),ParrefID,0))
	Set:SubID'="" ID=ParrefID_"||"_SubID
	if (ID'="") {
		Set obj=##class(DHCMA.CPW.SD.QCEntityItem).%OpenId(ID)
	}else{
		Set obj=##class(DHCMA.CPW.SD.QCEntityItem).%New()	
	}
	Quit:'$IsObject(obj) return	
	If (ID="") {  //新导入项目才更新下面属性，老项目保留
		Set obj.Parref        		=##class(DHCMA.CPW.SD.QCEntity).GetObjById(ParrefID)
		Set obj.BTCode        		= Code
		Set obj.BTDesc        		= Desc	
		Set obj.BTExpressDr   		= ##class(DHCMA.CPW.SD.QCExpress).GetObjById(ExpressDr)
		Set obj.BTExpressParam		= BTExpressParam
		Set obj.GetDataParam        = GetDataParam
	}
	Set obj.BTUpTypeDr			= ##class(DHCMA.Util.BT.Dictionary).GetObjById(UpTypeDr)
	Set obj.BTIsActive    		= IsActive
	Set obj.BTVersion			= ItemVersionObj
	Set obj.BTIndNo				= IndNo
	Set obj.BTLinkedItem  		= ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(LinkedItemID)
	Set obj.BTTriggerCondition	= TriggerCondition
	Set obj.BTItemCat           = ItemCat
	Set obj.BTItemSubCat        = ItemSubCat
	Set obj.BTIsNeeded			= BTIsNeeded
	Set:ItemTypeDr'="" obj.BTTypeDr = ##class(DHCMA.Util.BT.Dictionary).GetObjById(ItemTypeDr)
	Set obj.BTResume			= BTResume
	Set obj.BTFixDate			= +$h
	Set obj.BTFixTime			= $p($h,",",2)
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=1
	}
	Do obj.%Close()
	
	Quit return
}

/// 根据自定义规则，自动识别项目类型
/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).InitItemType()
ClassMethod InitItemType(aQCEntityID As %String = "") As %String
{
	new (aQCEntityID)
	Set return=""
	Set QCEntityID="" 
	for {
		Set QCEntityID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfParref",QCEntityID))
		Quit:QCEntityID=""
		Set xSubRowID=""	
		Continue:(aQCEntityID'="")&&(aQCEntityID'=QCEntityID)
	 	For
	 	{	
	 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfParref",QCEntityID,xSubRowID))
	 		Quit:xSubRowID=""
	 		Set xRowID = QCEntityID_"||"_xSubRowID
	 		Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).%OpenId(xRowID)
	 		Continue:'$IsObject(ObjEntityItem)
	 		Set ItemCode=ObjEntityItem.BTCode,BTTypeDr=""
	 		Continue:ObjEntityItem.BTTypeDr'="" //如果项目已经有类型，不自动覆盖
	 		Set VersionID=ObjEntityItem.BTVersion.%Id()
	 		Set MatchDicTypeObj=##class(DHCMA.CPW.SD.DicType).GetObjByCode(QCEntityID,VersionID,ItemCode)
	 		if ($IsObject(MatchDicTypeObj)) {
		 		Set nodes=0,SubCode=""
	 			for {
		 			Set SubCode=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",MatchDicTypeObj.%Id(),SubCode))
		 			Quit:SubCode=""
		 			Set nodes=nodes+1
		 			}
		 		if ((ObjEntityItem.BTDesc["至少")||(ObjEntityItem.BTDesc["最多")||(ObjEntityItem.BTUpTypeDr.BTDesc["数组"))
		 		{	
		 			Set TypeObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDType","多选字典列表")
		 			Set:$IsObject(TypeObj) BTTypeDr=TypeObj.%Id()
	 			}elseif(nodes<3){
		 			Set TypeObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDType","单选字典列表")
		 			Set:$IsObject(TypeObj) BTTypeDr=TypeObj.%Id()
		 		}else{
			 		set TypeObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDType","下拉字典")
			 		Set:$IsObject(TypeObj) BTTypeDr=TypeObj.%Id()
			 		}
	 		}elseif ($e(ObjEntityItem.BTDesc,($l(ObjEntityItem.BTDesc)-1),$l(ObjEntityItem.BTDesc))="日期"){
		 		Set TypeObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDType","日期")
		 		Set:$IsObject(TypeObj) BTTypeDr=TypeObj.%Id()
		 	}elseif ($e(ObjEntityItem.BTDesc,($l(ObjEntityItem.BTDesc)-3),$l(ObjEntityItem.BTDesc))="日期时间"){
		 		Set TypeObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDType","日期时间")
		 		Set:$IsObject(TypeObj) BTTypeDr=TypeObj.%Id()
		 	}elseif (ObjEntityItem.BTDesc["数值"){
		 		Set TypeObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDType","数值")
		 		Set:$IsObject(TypeObj) BTTypeDr=TypeObj.%Id()
		 	}else{
			 	Set TypeObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDType","文本")
			 	Set:$IsObject(TypeObj) BTTypeDr=TypeObj.%Id()
			 	}
			Set ObjEntityItem.BTTypeDr=##class(DHCMA.Util.BT.Dictionary).GetObjById(BTTypeDr)
			d ObjEntityItem.%Save()
		}
	}
	Quit $$$OK
}

/// 根据目标病种以及项目描述，自动同步其他病种项目取值参数
/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).InitItemExpByQCVer(1,2)
ClassMethod InitItemExpByQCVer(aQCEntityID As %String, aVerID As %String) As %String
{
	new (aQCEntityID,aVerID)
	Set return=""
	Quit:(aQCEntityID="")||(aVerID="") return
	//记录目标病种关联项目
	k tmpItemExpArr
	Set xCode=""	
 	For
 	{	
 		Set xCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",aQCEntityID,aVerID,xCode))
 		Quit:xCode=""
 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",aQCEntityID,aVerID,xCode,0))
 		Set xRowID = aQCEntityID_"||"_xSubRowID
 		Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).%OpenId(xRowID)
 		Continue:'$IsObject(ObjEntityItem)
 		Set ItemCode=ObjEntityItem.BTCode
 		Continue:ObjEntityItem.GetDataParam=""
 		Set BTExpress=ObjEntityItem.BTExpressDr.%Id()
 		Set Param=ObjEntityItem.GetDataParam
 		Set tmpItemExpArr(ItemCode)=$lb(BTExpress,Param)
 		
 	}
	//同步到其他病种
	Set xEntityID=""
	For
 	{	
 		Set xEntityID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",xEntityID))
 		Quit:xEntityID=""
 		Continue:(aQCEntityID=xEntityID)
 		Set yCode=""	
	 	For
	 	{	
	 		Set yCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",xEntityID,aVerID,yCode))
	 		Quit:yCode=""
	 		Set ySubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",xEntityID,aVerID,yCode,0))
	 		Set BTExpress="",GetParam=""
	 		Set yRowID = xEntityID_"||"_ySubRowID
	 		Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).%OpenId(yRowID)
	 		Continue:'$IsObject(ObjEntityItem)
	 		Continue:ObjEntityItem.BTExpressDr'="" //如果项目已经有取值表达式，不自动覆盖
	 		Set ItemCode=ObjEntityItem.BTCode
	 		Set ItemDesc=ObjEntityItem.BTDesc
			Set:$d(tmpItemExpArr(ItemCode)) BTExpress=$lg(tmpItemExpArr(ItemCode),1),GetParam=$lg(tmpItemExpArr(ItemCode),2)
			Continue:BTExpress=""
			Set ObjEntityItem.BTExpressDr=##class(DHCMA.CPW.SD.QCExpress).GetObjById(BTExpress)
			Set ObjEntityItem.GetDataParam=GetParam
			d ObjEntityItem.%Save()
		}
	}
	Quit $$$OK
}

/// 根据传参获取项目值域树内容
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntityItemSrv","QryQCItemTree","1",1)
Query QryQCItemTree(EntityID As %String, aActive As %String = "") As %Query(ROWSPEC = "id:%String,code:%String,text:%String,iconCls:%String,checked:%String,state:%String,attributes:%String")
{
}

ClassMethod QryQCItemTreeExecute(ByRef qHandle As %Binary, EntityID As %String, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	if (EntityID="") {
	 	Set xRowID=0
	 	For
	 	{
		 	Set xRowID        = $o(^DHCMA.CPW.SD.QCEntityD(xRowID))
		 	Quit:xRowID=""
		 	Set objEntity        = ##class(DHCMA.CPW.SD.QCEntity).GetObjById(xRowID)
		 	Set Code             = objEntity.BTCode
		 	Set Desc             = objEntity.BTDesc  
		 	Set Abbrev           = objEntity.BTAbbrev
		 	Set IsActive         = objEntity.BTIsActive
		 	Continue:(aActive'="")&&(IsActive'=aActive)
		 	Set IsActive = $s(IsActive=1:"是",1:"否")
		 	Set IndNo            = objEntity.BTIndNo
		 	Set Pubdate          = objEntity.BTPubdate 
			Set Data=$lb(xRowID,Code,Desc,"","false","closed","")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
 	}else {
	 	Set aParRef=EntityID
	 	Set xRowID=""	
	 	For
	 	{	
	 		Set xRowID=$o(^DHCMA.CPW.SD.DicTypeI("IdxofQCDr",aParRef,xRowID))
	 		Quit:xRowID=""
	 		Set (BTCode,BTDesc)=""
	 		Set ObjDicType = ##class(DHCMA.CPW.SD.DicType).GetObjById(xRowID)
	 		Continue:'$IsObject(ObjDicType)
	 		Set BTIsActive          = ObjDicType.IsActive
	 		Continue:(aActive'="")&&(BTIsActive'=aActive)
	 		Continue:ObjDicType.BTQCDr.BTVersion.%Id()'=ObjDicType.QCVersion.%Id()
	 		Set BTCode=ObjDicType.BTCode
	 		Set BTDesc=ObjDicType.BTDesc
			Set Data=$lb(xRowID,BTCode,BTDesc,"","","","")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	 	if (ind=1) {
		 	Set Data=$lb("","","无表单项目...","","","","")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	 }	
	Quit $$$OK
}

ClassMethod QryQCItemTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCItemTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCItemTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCItemTreeExecute ]
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

/// 获取基本信息表对应的属性字段
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntityItemSrv","QryClassProperty","DHCMA.CPW.SD.Data.Operation")
Query QryClassProperty(aClassName As %String) As %Query(ROWSPEC = "PropertyName:%String")
{
}

ClassMethod QryClassPropertyExecute(ByRef qHandle As %Binary, aClassName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aClassName="" $$$OK
	Set obj=##Class(%Dictionary.CompiledClass).%OpenId(aClassName)
	Set cnt=obj.Properties.Count()
	for i=1:1:cnt {
		Set PropertyObj=obj.Properties.GetAt(i)
		Set PropertyName=PropertyObj.Name	
		Continue:PropertyName["%"
		Set ^CacheTemp(repid,ind)=$lb(PropertyName)
		Set ind=ind+1
	 }
	Quit $$$OK
}

ClassMethod QryClassPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryClassPropertyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryClassPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryClassPropertyExecute ]
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

ClassMethod GetClassProperty(aClassName As %String) As %String
{
	new (aClassName)
	Set obj=##Class(%Dictionary.CompiledClass).%OpenId(aClassName)
	Set cnt=obj.Properties.Count()
	Set PropertyStr=""
	for i=1:1:cnt {
		Set PropertyName=obj.Properties.GetAt(i).Name	
		Continue:PropertyName["%"
		Set PropertyStr=PropertyStr_"^"_PropertyName
	}
	Set:PropertyStr'="" PropertyStr=$e(PropertyStr,2,$l(PropertyStr))
	Quit PropertyStr
}

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntityItemSrv","QryQCTree")
Query QryQCTree(EntityID As %String) As %Query(ROWSPEC = "id:%String,code:%String,text:%String,iconCls:%String,checked:%String,state:%String,attributes:%String")
{
}

ClassMethod QryQCTreeExecute(ByRef qHandle As %Binary, EntityID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^DHCMA.CPW.SD.QCEntityD(xRowID))
	 	Quit:xRowID=""
	 	Set objEntity        = ##class(DHCMA.CPW.SD.QCEntity).GetObjById(xRowID)
	 	Set Code             = objEntity.BTCode
	 	Set Desc             = objEntity.BTDesc  
	 	Set Abbrev           = objEntity.BTAbbrev
	 	Set IsActive         = objEntity.BTIsActive
	 	Set IsActive = $s(IsActive=1:"是",1:"否")
	 	Set IndNo            = objEntity.BTIndNo
	 	Set Pubdate          = objEntity.BTPubdate 
		Set Data=$lb(xRowID,Code,Desc,"","","","")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryQCTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCTreeExecute ]
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

/// 查询表单项目大类
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntityItemSrv","QryQCFormCat",3,2)
Query QryQCFormCat(EntityID As %String, VerID As %String) As %Query(ROWSPEC = "CatCode:%String,CatDesc:%String,SubCatStr:%String")
{
}

ClassMethod QryQCFormCatExecute(ByRef qHandle As %Binary, EntityID As %String, VerID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Set ItemCat="0"	
 	For
 	{	
 		Set ItemCat=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCat",EntityID,VerID,ItemCat))
 		Quit:ItemCat=""
 		Set tmpItemCat=ItemCat
 		Continue:$tr(ItemCat," ","")=""
 		Set ItemCatCode=$p(tmpItemCat," ",1)
 		Set indNo=$p(tmpItemCat,"-",2)
 		Set indNo=+indNo
 		Set:ItemCat["基本信息" indNo=0
 		Set ItemSubCat="0",ItemSubCatList="",ItemSubNo=""
 		kill ItemSubArr
 		for {
	 		Set ItemSubCat=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerSubCat",EntityID,VerID,tmpItemCat,ItemSubCat))
 			Quit:ItemSubCat=""	
 			if ($tr(ItemSubCat," ","")="") Continue
 			Continue:$lf(ItemSubCatList,ItemSubCat)>0
 			//根据子类第一个项目出现的顺序（或者项目序号），组织子类展现顺序
 			Set ItemSubNo=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfSubCat",EntityID,tmpItemCat,ItemSubCat,0))
 			Set ItemSubArr(ItemSubNo)=ItemSubCat
	 	}
	 	Set ItemSubInd="",ItemSubCatStr=""
	 	for {
	 		Set ItemSubInd=$o(ItemSubArr(ItemSubInd))
			Quit:ItemSubInd=""
			Set ItemSubCatStr=ItemSubCatStr_","_$g(ItemSubArr(ItemSubInd))
	 	}
	 	Set:ItemSubCatStr'="" ItemSubCatStr=$e(ItemSubCatStr,2,$l(ItemSubCatStr))
		Set ItemCatArr(indNo)=$lb(ItemCatCode,tmpItemCat,ItemSubCatStr)
 	}
 	Set xind=""
 	for {
	 	Set xind=$o(ItemCatArr(xind))
	 	Quit:xind=""
	 	Set ^CacheTemp(repid,ind)=ItemCatArr(xind)
		Set ind=ind+1
	 	}	
	Quit $$$OK
}

ClassMethod QryQCFormCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCFormCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCFormCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCFormCatExecute ]
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

/// 根据项目大类获取项目信息
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntityItemSrv","QryQCFormItemByCat",3,2,"STK-1")
Query QryQCFormItemByCat(EntityID As %String, VerID As %String, CatCode As %String) As %Query(ROWSPEC = "ItemCode:%String,ItemDesc:%String,ItemType:%String,ItemSubCat:%String")
{
}

ClassMethod QryQCFormItemByCatExecute(ByRef qHandle As %Binary, EntityID As %String, VerID As %String, CatCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Set ItemCat=""	
 	For
 	{	
 		Set ItemCat=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCat",EntityID,VerID,ItemCat))
 		Quit:ItemCat=""
 		Set ItemCatCode=$p(ItemCat," ",1)
 		Continue:ItemCatCode'=CatCode
 		Set ItemSubID=""
 		for {
	 		Set ItemSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCat",EntityID,VerID,ItemCat,ItemSubID))
	 		Quit:ItemSubID=""
	 		Set ItemID=EntityID_"||"_ItemSubID
	 		Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(ItemID)
	 		Continue:'$IsObject(ItemObj)
	 		Set ItemCode=ItemObj.BTCode
	 		Set ItemDesc=ItemObj.BTDesc
	 		Set ItemType=ItemObj.BTTypeDr.BTCode
	 		Set ItemSubCat=ItemObj.BTItemSubCat
	 		Set ^CacheTemp(repid,ind)=$lb(ItemCode,ItemDesc,ItemType,ItemSubCat)
			Set ind=ind+1
	 		}
		
 	}	
	Quit $$$OK
}

ClassMethod QryQCFormItemByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCFormItemByCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCFormItemByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCFormItemByCatExecute ]
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

/// 根据项目子类获取项目信息
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntityItemSrv","QryQCFormItemBySubCat","2","3","基本信息","一般信息","14")
Query QryQCFormItemBySubCat(VerID As %String, EntityID As %String, CatDesc As %String, SubCatDesc As %String, MrListID As %String = "") As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String,ItemType:%String,ItemSubCat:%String,ExecResult:%String,display:%String,IsNeeded:%String")
{
}

ClassMethod QryQCFormItemBySubCatExecute(ByRef qHandle As %Binary, VerID As %String, EntityID As %String, CatDesc As %String, SubCatDesc As %String, MrListID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ^TMPZGZ114=$LB(VerID,EntityID, CatDesc, SubCatDesc, MrListID)
 	if (MrListID'="") {
	 	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrListID)
	 	Set EntityID=MrListObj.QCEntityDr.%Id() 
	 	Set:VerID="" VerID=	MrListObj.QCEntityDr.BTVersion.%Id() 
	 }
	Set:VerID="" VerID=1
	k tmpItemArr
	Set ItemSubID=""	
	for {
 		Set ItemSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerSubCat",EntityID,VerID,CatDesc,SubCatDesc,ItemSubID))
 		Quit:ItemSubID=""
 		Set ItemID=EntityID_"||"_ItemSubID
 		Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(ItemID)
 		Continue:'$IsObject(ItemObj)
 		Continue:ItemObj.BTVersion.%Id()'=VerID
 		Set ItemInd		= ItemObj.BTIndNo
 		Set ItemCode	= ItemObj.BTCode
 		Set tmpItemArr(ItemInd,ItemCode)=ItemObj
 		d ItemObj.%Close()
	}
	Set ItemInd=""
	for {
		Set ItemInd=$o(tmpItemArr(ItemInd))
		Quit:ItemInd=""
		Set ItemCode=""
		for {
			Set ItemCode=$o(tmpItemArr(ItemInd,ItemCode))
			Quit:ItemCode=""
			Set ItemObj=$g(tmpItemArr(ItemInd,ItemCode))
			Set ItemID		= ItemObj.%Id()
	 		Set ItemDesc	= ItemObj.BTDesc
	 		Set ItemType	= ItemObj.BTTypeDr.BTCode
	 		Set IsNeeded	= ItemObj.BTIsNeeded
	 		Set ItemSubCat	= ItemObj.BTItemSubCat
	 		Set LinkedItem	= ItemObj.BTLinkedItem
	 		Set LinkedParam = ItemObj.BTTriggerCondition
	 		Set ExecResult="",display=""
	 		if (MrListID'="") {
		 		Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,ItemID,""),-1)
		 		if (ESubID'="") { //转换显示值
			 		Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_ESubID)
			 		If $IsObject(ItemExecObj){
				 		Set ExecResult=ItemExecObj.ExecResult
			 		}
		 		}
			 	if (LinkedItem'=""){
		 			Set PValue=""
		 			Set PItemDr=LinkedItem.%Id()
		 			Set PESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,PItemDr,""),-1)
			 		Set PItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_PESubID)
			 		Set:$IsObject(PItemExecObj) PValue=PItemExecObj.ExecResult
			 		//判断前提条件是否满足a,b,c
			 		Set BTTriggerCondition=","_LinkedParam_","
					Set PValue=","_PValue_","
			 		Set:(PValue'[LinkedParam)&&(LinkedParam'[PValue) display="none" //有前置质控项目的，如果不满足前提值，则不可编辑
				}elseif (LinkedParam'=""){
		 			k CodeArr
		 			for i=1:1:$l(LinkedParam,","){
						Set LinkedParamSub=$p(LinkedParam,",",i)
						Continue:LinkedParamSub=""
						Set CalcStr=$p(LinkedParamSub,":",2)
						for j=1:1:$l(CalcStr,")") {
							Set CodeSub=$p(CalcStr,")",j)
							Set Code=$p(CodeSub,"(",2)
							Continue:Code=""
							Set ItemDr=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,EntityID,Code)
							if ($IsObject(ItemDr)) {
								Set xSubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,ItemDr.%Id(),""),-1)
			 					Set xItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_xSubID)
			 					Set xValue=""
			 					Set:$IsObject(xItemExecObj) xValue=xItemExecObj.ExecResult
								Set CodeArr(Code)=xValue
							}
						}
					}
					Set ParamExp=$p(LinkedParam,":",2)
					if ('$d(CodeArr)) {Set ParamExp=0}
					else{ 
						Set CodeTmp="",RFlag=0
						for {
							Set CodeTmp=$o(CodeArr(CodeTmp))
							Quit:CodeTmp=""
							if ($p(LinkedParam,":",1)["CALC-h") {
								Set tmpHour=0
								Set tmpDate=$p(CodeArr(CodeTmp)," ",1)	
								Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
								if (tmpDateLogic=""){
									Set ParamExp=0
									Quit  //如果有时间为空 则不执行表达式
								}
								Set tmpTime=$p(CodeArr(CodeTmp)," ",2),tmpTimeLogic=0
								Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
								//将各个时间参数换算为与固定时间小时差
								Set tmpHour=(tmpDateLogic-60000)*24+(tmpTimeLogic\3600)
								Set ParamExp=$Replace(ParamExp,CodeTmp,tmpHour)
							}elseif ($p(LinkedParam,":",1)["CALC-m") {
								Set tmpHour=0
								Set tmpDate=$p(CodeArr(CodeTmp)," ",1)	
								Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
								if (tmpDateLogic=""){
									Set ParamExp=0
									Quit  //如果有时间为空 则不执行表达式
								}
								Set tmpTime=$p(CodeArr(CodeTmp)," ",2),tmpTimeLogic=0
								Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
								//将各个时间参数换算为与固定时间分钟差
								Set tmpHour=(tmpDateLogic-60000)*24*60+(tmpTimeLogic\60)
								Set ParamExp=$Replace(ParamExp,CodeTmp,tmpHour)
							}else{
								//默认情况下替换Code值，进行运算
								Set CodeValue=""""_$g(CodeArr(CodeTmp))_""""
								Set ParamExp=$Replace(ParamExp,CodeTmp,CodeValue)
							}
						}
					}
					Set ParamExp=$tr($tr(ParamExp,"[","("),"]",")")
					Set ParamExp=$tr($tr(ParamExp,"{","("),"}",")")
					Set ParamExp=$Replace(ParamExp,"不包含","'[")
					Set ParamExp=$Replace(ParamExp,"包含","[")
					Set ParamExp=$Replace(ParamExp,"!","'")
					Set Exp="Set result=("_ParamExp_")"
					x Exp
		 			Set:'result display="none"
				}
		 	}else{
			 	Set:(LinkedItem'="")||(LinkedParam'="") display="none"
			 }
			
		Set ^CacheTemp(repid,ind)=$lb(ItemID,ItemCode,ItemDesc,ItemType,ItemSubCat,ExecResult,display,IsNeeded)
		Set ind=ind+1
		}
 	}	
	Quit $$$OK
}

ClassMethod QryQCFormItemBySubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCFormItemBySubCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCFormItemBySubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCFormItemBySubCatExecute ]
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

/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).getItemDescByCode("STK-0-2-5")
ClassMethod getItemDescByCode(ItemCode As %String, aQCID As %String, aVerID As %String) As %String
{
	new (ItemCode,aQCID,aVerID)
	Set return=""
	Quit:(ItemCode="")||(aQCID="")||(aVerID="") return
	Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCID,ItemCode)
	Quit:'$IsObject(ItemObj) return
	Set ItemDesc=ItemObj.BTDesc
	Quit ItemDesc
}

/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).GetValItemByLinkID("8||138")
ClassMethod GetValItemByLinkID(aLinkID As %String) As %String
{
	New (aLinkID)
	Set return=""
	Quit:aLinkID="" return
	Set ^tmpzgz117=aLinkID
	//取出被关联医嘱的表单项目，获取邻近项目执行的相关医嘱记录
	Set ParrefID=+aLinkID
	Set ItemSubID="",LinkedStr=""
	for {
		Set ItemSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfLinked",aLinkID,ParrefID,ItemSubID))
		Quit:ItemSubID=""
		Set ItemTmpID=ParrefID_"||"_ItemSubID
		Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(ItemTmpID)
		Continue:(ItemObj.BTItemSubCat'="")
		Set LinkedStr=LinkedStr_"^"_ItemObj.BTCode_","_ItemObj.BTDesc
	}
	Set:LinkedStr'="" return=$e(LinkedStr,2,$l(LinkedStr))
	Quit return
}

/// 获取与该项目校验相关联项目的code
/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).GetValiItemCode(33,2,"VTE-0-1-1")
ClassMethod GetValiItemCode(aQCID, aVerID, aCode As %String) As %String
{
	
	n (aQCID,aVerID,aCode)
	Set return=""
	Quit:(aCode="")||(aQCID="")||(aVerID="") return
	Set QCEntityID=aQCID
	Set ItemCodeStr=aCode
	Set xCode=""
	for {
		Set xCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVerID,xCode))
		Quit:xCode=""
		Set ItemID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVerID,xCode,aQCID,0))
		Set xItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(QCEntityID_"||"_ItemID)
		Continue:'$IsObject(xItemObj)
		Set BTCode=xItemObj.BTCode
		Set BTExpressParam=xItemObj.BTExpressParam
		if (BTExpressParam'=""){
			//如果维护了简版表达式，依然走原来的方式
			Continue:(BTExpressParam'[aCode)
			Set ItemCodeStr=ItemCodeStr_","_BTCode
		}else{
			//如果维护了校验规则条目，则走以下方式来判断
			Set xSubID=0
		 	For
		 	{
			 	Set xSubID = $o(^DHCMA.CPW.SD.QCEntityD(QCEntityID,"Item",ItemID,"Rule",xSubID))
			 	Quit:xSubID=""
			 	Set xRowID=QCEntityID_"||"_ItemID_"||"_xSubID
			 	Set objVRule        = ##class(DHCMA.CPW.SD.QCItemValidRule).GetObjById(xRowID)
			 	Continue:'$IsObject(objVRule)
			 	Set RuleExpress      = objVRule.RuleExpress
			 	//校验表达式项目代码必须以()括起来
			 	Continue:RuleExpress'[("("_aCode_")")
				Set ItemCodeStr=ItemCodeStr_","_BTCode
			}
		}
	}
	Quit ItemCodeStr
}

/// 按照病种id 版本id   批量无效版本病种项目
/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).DisabledVerItem(1,2)
ClassMethod DisabledVerItem(aQCID As %String, aVerID As %String) As %String
{
	New (aQCID,aVerID)
	//如果导入当天已经导入了当前版本，退出
	Quit:$d(^DHCMADisabledVerItem(aQCID,aVerID,+$h)) ""
	Set xItemCode="",Count=0
	For {
		Set xItemCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",aQCID,aVerID,xItemCode))
		Quit:xItemCode=""
		Set xItemID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",aQCID,aVerID,xItemCode,0))
		Set xItemobj=##class(DHCMA.CPW.SD.QCEntityItem).%OpenId(aQCID_"||"_xItemID)
		Continue:'$IsObject(xItemobj)
		Set xItemobj.BTIsActive  = 0
		Set sc=xItemobj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
		}Else{
			Set Count=Count+1
		}
		Do xItemobj.%Close()
	}
	Set ^DHCMADisabledVerItem(aQCID,aVerID,+$h)="导入更新日期："_$zd(+$h)_" "_$zt($p($h,",",2))
	Quit "无效项目："_Count_"个"
}

/// 处理表达式包含关系时，双端值处理
/// w ##class(DHCMA.CPW.SDS.QCEntityItemSrv).ChangeExp()
ClassMethod ChangeExp(aExp) As %String
{
	new (aExp)
	for ExpInd=1:1:$l(aExp,")") {
		Set ExpSub=$p(aExp,")",ExpInd)
		Continue:ExpSub'["["
		Set:ExpSub["(" ExpSub=$p(ExpSub,"(",$l(ExpSub,"("))
		continue:ExpSub=""
		Set xExpSub=ExpSub
		if (xExpSub["'[") {
			Set xVal1=$p(xExpSub,"'[",1)
		}else{
			Set xVal1=$p(xExpSub,"[",1)	
		}
		Set xValTmp1=$tr(xVal1,"""","")
		If ($e(xValTmp1,$l(xValTmp1),$l(xValTmp1))'=",") {
			Set xValTmp1=""","_xValTmp1_","""
			Set xExpSub=$Replace(xExpSub,xVal1,xValTmp1)
		}
		Set xVal2=$p(xExpSub,"[",2)
		Set xValTmp2=$tr(xVal2,"""","")
		If ($e(xValTmp2,$l(xValTmp2),$l(xValTmp2))'=",") {
			Set xValTmp2=""","_xValTmp2_","""
			Set xExpSub=$Replace(xExpSub,xVal2,xValTmp2)
		}
		Set:xExpSub'="" aExp=$Replace(aExp,ExpSub,xExpSub)
	}
	quit aExp
}

}
