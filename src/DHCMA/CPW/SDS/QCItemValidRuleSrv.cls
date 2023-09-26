/// add by zgz 2020-04
/// 质控病种项目检验规则服务类
Class DHCMA.CPW.SDS.QCItemValidRuleSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2020-04-1
/// Description:  查询项目检验规则
/// Table：       DHCMA.CPW.SD.QCItemValidRule      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCItemValidRuleSrv","QryQCItemVRule","1||11")
Query QryQCItemVRule(aItemDr As %String = "") As %Query(ROWSPEC = "RowID:%String,RuleType:%String,RuleTypeDesc:%String,QCExpressID:%String,QCExpress:%String,RuleExpress:%String,RuleContent:%String")
{
}

ClassMethod QryQCItemVRuleExecute(ByRef qHandle As %Binary, aItemDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aItemDr="" $$$OK
 	Set ^tmpzgz416=aItemDr
 	Set QCEntityID=$p(aItemDr,"||",1)
 	Set ItemChildID=$p(aItemDr,"||",2)
 	Quit:(QCEntityID="")||(ItemChildID="") $$$OK
 	Set xSubID=0,QCExpressID="",QCExpress="",RuleTypeDesc=""
 	For
 	{
	 	Set xSubID        = $o(^DHCMA.CPW.SD.QCEntityD(QCEntityID,"Item",ItemChildID,"Rule",xSubID))
	 	Quit:xSubID=""
	 	Set xRowID=aItemDr_"||"_xSubID
	 	Set objVRule        = ##class(DHCMA.CPW.SD.QCItemValidRule).GetObjById(xRowID)
	 	Continue:'$IsObject(objVRule)
	 	Set RuleType         = objVRule.RuleType
	 	Set RuleFunction     = objVRule.RuleFunction
	 	Set RuleExpress      = objVRule.RuleExpress
	 	Set RuleContent      = objVRule.RuleContent
	 	Set RuleTypeDesc=$Case(RuleType,"info":"温馨提示","warning":"指标预警","error":"填报错误","stop":"终止填报",:"")
	 	Set:$IsObject(RuleFunction) QCExpressID=RuleFunction.%Id(),QCExpress=RuleFunction.BTDesc
		Set Data=$lb(xRowID,RuleType,RuleTypeDesc,QCExpressID,QCExpress,RuleExpress,RuleContent)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryQCItemVRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCItemVRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCItemVRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCItemVRuleExecute ]
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

/// 获取项目ID相关的校验规则涉及到的项目code，以便前台取值返回进行计算
/// w ##class(DHCMA.CPW.SDS.QCItemValidRuleSrv).GetRuleItemCode("STEMI-4-3")
ClassMethod GetRuleItemCode(aItemCode As %String, aQCID As %String, aVerID As %String) As %String
{
	New (aItemCode,aQCID,aVerID)
	Set return=""
	Quit:(aItemCode="")||(aQCID="")||(aVerID="") return
	Set ObjItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCID,aItemCode)
 	Quit:'$IsObject(ObjItem) return
 	Set aItemID=ObjItem.%Id()
	Set QCEntityID=$p(aItemID,"||",1)
 	Set ItemChildID=$p(aItemID,"||",2)
 	Quit:(QCEntityID="")||(ItemChildID="") return
 	Set RuleStr=ObjItem.BTCode
 	Set xSubID=0
 	For
 	{
	 	Set xSubID        = $o(^DHCMA.CPW.SD.QCEntityD(QCEntityID,"Item",ItemChildID,"Rule",xSubID))
	 	Quit:xSubID=""
	 	Set xRowID=aItemID_"||"_xSubID
	 	Set objVRule        = ##class(DHCMA.CPW.SD.QCItemValidRule).GetObjById(xRowID)
	 	Continue:'$IsObject(objVRule)
	 	Set RuleType         = objVRule.RuleType
	 	Set RuleFunction     = objVRule.RuleFunction
	 	Continue:RuleFunction=""
	 	Set RuleExpress      = objVRule.RuleExpress
	 	for j=1:1:$l(RuleExpress,"(") {
		 	Set tRuleStr=$p(RuleExpress,"(",j)
		 	Continue:tRuleStr'[")"
		 	Set RuleCode=$p(tRuleStr,")",1)	
		 	Continue:RuleCode=""
		 	Continue:("^"_RuleStr_"^")[("^"_RuleCode_"^")
		 	Set RuleStr=RuleStr_"^"_RuleCode
		 }
 	}
 	Set return=RuleStr
 	Quit return
}

/// 获取与该项目相关连的其他项目
/// w ##class(DHCMA.CPW.SDS.QCItemValidRuleSrv).GetValiItemCode("STEMI-0-2-2-1")
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
		//如果维护了校验规则条目，则走新方式来判断
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
	Quit ItemCodeStr
}

/// 获取校验提示信息
/// w ##class(DHCMA.CPW.SDS.QCItemValidRuleSrv).GetValiMsg("STEMI-1-1-1","n","STEMI-1-1-1","n")
ClassMethod GetValiMsg(aQCID As %String, aVerID As %String, aItemCode As %String, aItemValue As %String, aItemCodeStr As %String, aItemValStr As %String, aLangID As %String = "")
{
	n (aQCID,aVerID,aItemCode,aItemValue,aItemCodeStr,aItemValStr,aLangID)
	Set $ZT="ValiErr"
	Set:aItemCode="STEMI-1-1-1" ^tmpzgz=$lb(aItemCode,aItemValue,aItemCodeStr,aItemValStr)
	Set return=""
	Set ObjItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCID,aItemCode)
 	Quit:'$IsObject(ObjItem) return
 	Set aItemID=ObjItem.%Id()
	Set QCEntityID	=$p(aItemID,"||",1)
 	Set ItemChildID	=$p(aItemID,"||",2)
 	Quit:(QCEntityID="")||(ItemChildID="") return
 	Quit:(aItemValue="") return
 	Set ItemType=ObjItem.BTTypeDr.BTCode
 	Set tmpItemCode=""
 	//将传入的校验参数整理
 	For k=1:1:$l(aItemCodeStr,"^") {
	 	Set ItemCode=$p(aItemCodeStr,"^",k)
	 	continue:ItemCode=""
	 	Set xValue=$p(aItemValStr,"^",k)
		//根据关联的项目类型转换项目值
		Set ObjLinkItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCID,ItemCode)
		if (ObjLinkItem.BTTypeDr.BTCode["Date")&&(xValue'="") {
			Set xDate=$p(xValue," ",1)
			Set xTime=$p(xValue," ",2)
			Set LogicxDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xDate)
			Set LogicxTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(xTime)
			Set xValue=LogicxDate*86400+LogicxTime	
		}
		Set tmpItemCode(ItemCode)=xValue //由于项目代码和值的位置对应 这里直接取
	}
	Set ValiMsg=""
	//通用校验
	//--------校验1  UTD不能与其他字典同时选择
	If (aItemValue["UTD")&&($l(aItemValue,",")>1) {
		Set UTDError="【无法确定或无记录】不应与其他选项同时选择"
		Set ValiMsg=##class(DHCMA.CPW.SD.QCItemValidRule).GetTranByDesc("RuleContent",UTDError)_"！^error"
		Quit ValiMsg
	}
	//通过项目校验规则校验
 	Set xSubID=0
 	For
 	{
	 	Set xSubID= $o(^DHCMA.CPW.SD.QCEntityD(QCEntityID,"Item",ItemChildID,"Rule",xSubID))
	 	Quit:xSubID=""
	 	Set xRowID=aItemID_"||"_xSubID
	 	Set objVRule        = ##class(DHCMA.CPW.SD.QCItemValidRule).GetObjById(xRowID)
	 	Continue:'$IsObject(objVRule)
	 	Set ValiFlg=1      //当条校验规则涉及项目是否合格
	 	Set RuleType         = objVRule.RuleType
	 	Set RuleFunction     = objVRule.RuleFunction
	 	Continue:RuleFunction=""
	 	Set RuleExpress      = objVRule.RuleExpress
	 	Set RuleCodeArr=""
	 	For j=1:1:$l(RuleExpress,"(") {
		 	Set tRuleStr=$p(RuleExpress,"(",j)
		 	Continue:tRuleStr'[")"
		 	Set RuleCode=$p(tRuleStr,")",1)	
		 	Continue:RuleCode=""
		 	Set RuleCodeArr(RuleCode)=""
		 	//根据计算公式
		 }	
		Set ValiResult=0
		Set ValiContent=objVRule.RuleContent
		If (RuleFunction.BTCode="DATEFORMAT") { //日期格式校验
			//通过日期时间转换接口对日期时间格式进行校验,21550代表1900年
			If (ItemType="Date"){
				Set LogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aItemValue)
				Set:LogicDate<21550 ValiResult=1
				//根据系统配置格式返回提示内容
				Set ValiContent=ValiContent_##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(+$h)
			}elseif(ItemType="DateT"){
				Set Date=$p(aItemValue," ",1)
				Set Time=$p(aItemValue," ",2)
				Set LogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(Date)
				Set LogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(Time)
				Set:(LogicDate<21550)||(LogicTime="") ValiResult=1
				//根据系统配置格式返回提示内容
				Set ValiContent=ValiContent_##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(+$h)_" "_$zt($p($h,",",2),1)
			}
		}elseif(RuleFunction.BTCode="ITEMLEN"){ //长度判断
			//文本类型的，校验字符串长度
			If (ItemType="Text"){
				Set xRCode=""
				For{
					Set xRCode=$o(RuleCodeArr(xRCode))
					Quit:xRCode=""
					Set xValue=$g(tmpItemCode(xRCode))
					Set xLen=$l(xValue)
					Set RuleExpress=$Replace(RuleExpress,xRCode,xLen)
				}
				//兼容处理this
				Set thisLen=$l(aItemValue)
				Set RuleExpress=$Replace(RuleExpress,"this",thisLen)
			}else{
				//默认为字典类型的，校验数组长度"a,b,c"
				Set xRCode=""
				for{
					Set xRCode=$o(RuleCodeArr(xRCode))
					Quit:xRCode=""
					Set xValue=$g(tmpItemCode(xRCode))
					Set xLen=$l(xValue,",")
					Set RuleExpress=$Replace(RuleExpress,"("_xRCode_")",xLen)
				}
				//兼容处理this
				Set thisLen=$l(aItemValue,",")
				Set RuleExpress=$Replace(RuleExpress,"this",thisLen)
			}
			Set RuleExpress=$tr($tr(RuleExpress,"[","("),"]",")")
			Set RuleExpress=$tr($tr(RuleExpress,"{","("),"}",")")
			x "Set result="_RuleExpress
			Set:result=0 ValiResult=1
			
		}elseif(RuleFunction.BTCode="CMPVAL"){  //比较值
			Set thisValue=aItemValue
			if (ItemType["Date"){
			 	//根据项目类型转换项目值
		 		Set Date=$p(thisValue," ",1)
				Set Time=$p(thisValue," ",2)
				Set LogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(Date)
				Set LogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(Time)
				Set thisValue=LogicDate*86400+LogicTime
		 	}
			//比较值大小，如有新类型可以根据情况添加
			Set xRCode=""
			for{
				Set xRCode=$o(RuleCodeArr(xRCode))
				Quit:xRCode=""
				Set xValue=$g(tmpItemCode(xRCode))
				Set:xValue="" ValiFlg=0 		//如果当前规则有项目值为空，则放弃该条校验
				Set RuleExpress=$Replace(RuleExpress,"("_xRCode_")",""""_xValue_"""")
			}
			//运算的时候需要加引号，否则会作为未定义变量处理
			Set thisValue=""""_thisValue_""""
			if (ValiFlg=1) {
				Set Now=(+$h)*86400+$p($h,",",2)
				Set RuleExpress=$Replace(RuleExpress,"this",thisValue)
				Set RuleExpress=$Replace(RuleExpress,"Now",Now)
				Set RuleExpress=$tr($tr(RuleExpress,"[","("),"]",")")
				Set RuleExpress=$tr($tr(RuleExpress,"{","("),"}",")")
				Set RuleExpress=$Replace(RuleExpress,"不包含","'[")
				Set RuleExpress=$Replace(RuleExpress,"包含","[")
				Set RuleExpress=$tr(RuleExpress,"!","'")
				x "Set result="_RuleExpress
				Set:result=0 ValiResult=1
			}
		}elseif(RuleFunction.BTCode="IDFORMAT"){  //身份证格式校验
			//正则表达式校验
			d ..ValidDVANoS(aItemValue,.OK)
			Set:OK=0 ValiResult=1
		}
		Continue:ValiFlg=0           //校验规则是否合法
		Continue:ValiResult=0		 //校验规则结果
		Set ValiContent=$tr(ValiContent,";.!","")
		Set:aLangID'="" ValiContent=##class(DHCMA.CPW.SD.QCItemValidRule).GetTranByDesc("RuleContent",ValiContent,aLangID)
		Set RuleType=objVRule.RuleType
		Set ValiMsg=ValiMsg_"&"_ValiContent_"^"_RuleType
		//如果有错误 或者 终止上报的错误，则不再校验后面的规则
		Quit:(RuleType="error")||(RuleType="stop")
 	} 	
 	Set:ValiMsg'="" return=$e(ValiMsg,2,$l(ValiMsg))
 	Quit return
ValiErr
	Quit $ZCVT($ZERROR,"O","HTML")
}

/// w ##class(DHCMA.CPW.SDS.QCItemValidRuleSrv).ImportValidRule("WS033","V202010","CM-0-1-1-1","不能超过50个文字说明;"_$c(1)_"ITEMLEN"_$c(1)_"this<=50"_$c(1)_"error",$c(1))
ClassMethod ImportValidRule(aQCCode As %String, aVersion As %String, aItemCode As %String, aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aQCCode,aVersion,aInputStr,aItemCode,aSeparete)	
	Set:aItemCode="STK-2-3-1" ^tmpzgz41=$lb(aItemCode,aInputStr)
	Set ret=""
	Set ^tmp1022=$lb(aQCCode,aVersion,aItemCode,aInputStr,aSeparete)
	Quit:(aQCCode="")||(aVersion="") ret
	Set ObjQC=##class(DHCMA.CPW.SD.QCEntity).GetObjByCode(aQCCode)
	Quit:'$IsObject(ObjQC) ret
	Set aQCID=ObjQC.%Id()
	Set ObjVersion=##class(DHCMA.CPW.SD.QCEntityVersion).GetObjByCode(aVersion)
	Quit:'$IsObject(ObjVersion) ret
	Set aVerID=ObjVersion.%Id()
	Quit:(aInputStr="")||(aItemCode="")||(aQCID="")||(aVerID="") ret
	Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCID,aItemCode)
	Quit:'$IsObject(ItemObj) ret
	Set ItemID		= ItemObj.%Id()
	Set RuleContent	= $p(aInputStr,aSeparete,1)
	Set QCExpress	= $p(aInputStr,aSeparete,2)
	Set RuleExpress	= $p(aInputStr,aSeparete,3)
	Set:RuleExpress["!" RuleExpress=$tr(RuleExpress,"!","'")
	Set RuleType	= $p(aInputStr,aSeparete,4)
	Set:QCExpress'="" QCExpress=##class(DHCMA.CPW.SD.QCExpress).GetObjByCode(QCExpress).%Id()
	Set UpStr=ItemID_$c(2)_""_$c(2)_RuleType_$c(2)_QCExpress_$c(2)_RuleExpress_$c(2)_RuleContent
	//add by zgz 20210713 导入相同版本的校验规则时，先将该版本校验规则删除
	//默认一天只给删除一次
	d ..DeleteVerRule(aQCID,aVerID)
	Set ret=##class(DHCMA.CPW.SD.QCItemValidRule).Update(UpStr,$c(2))
	Quit ret
}

/// w ##class(DHCMA.CPW.SDS.QCItemValidRuleSrv).ValidDVANoS("12344212412",1)
ClassMethod ValidDVANoS(IDNo As %String, Output OK As %String) As %String
{
	s OK=0
	s $zt="Err"
	s:$l(IDNo)'=18 IDNo=..ID218(IDNo)
	s n1=$e(IDNo,1,1)*7
	s n2=$e(IDNo,2,2)*9
	s n3=$e(IDNo,3,3)*10
	s n4=$e(IDNo,4,4)*5
	s n5=$e(IDNo,5,5)*8
	s n6=$e(IDNo,6,6)*4
	s n7=$e(IDNo,7,7)*2
	s n8=$e(IDNo,8,8)*1
	s n9=$e(IDNo,9,9)*6
	s n10=$e(IDNo,10,10)*3
	s n11=$e(IDNo,11,11)*7
	s n12=$e(IDNo,12,12)*9
	s n13=$e(IDNo,13,13)*10
	s n14=$e(IDNo,14,14)*5
	s n15=$e(IDNo,15,15)*8
	s n16=$e(IDNo,16,16)*4
	s n17=$e(IDNo,17,17)*2
	s sum=n1+n2+n3+n4+n5+n6+n7+n8+n9+n10+n11+n12+n13+n14+n15+n16+n17
	s ys=sum#11
	s n18=$s(ys=0:1,ys=1:0,ys=2:"X",ys=3:9,ys=4:8,ys=5:7,ys=6:6,ys=7:5,ys=8:4,ys=9:3,ys=10:2)
	i n18=$zcvt($e(IDNo,18,18),"u") d
	.s OK=1
	q IDNo
Err
	q $ze
}

/// 转换15位身份证位18位
ClassMethod ID218(ID As %String) As %String
{
	q:$l(ID)'=15 ""
	s ID=$e(ID,1,6)_"19"_$e(ID,7,15)
	s N=0
	s co="7-9-10-5-8-4-2-1-6-3-7-9-10-5-8-4-2"
	f i=1:1:17 d
	.s N=N+($e(ID,i,i)*$p(co,"-",i))
	s N=N#11
	s VerCode="1-0-X-9-8-7-6-5-4-3-2"
	q ID_$p(VerCode,"-",N+1)
}

/// w ##class(DHCMA.CPW.SDS.QCItemValidRuleSrv).ImportDefault("V202010","CM-0-3-3","OrderInfo","")
ClassMethod ImportDefault(aVersion As %String, aItemCode As %String, aExpree As %String, aparam As %String) As %String
{
	New (aVersion,aItemCode,aExpree,aparam)
	Set return=""
	Quit:(aVersion="")||(aItemCode="")||(aExpree="") return
	Set ^tmpzzqy=$lb(aVersion,aItemCode,aExpree,aparam)
	Set xQCID=""
	Set aVersion=##class(DHCMA.CPW.SD.QCEntityVersion).GetObjByCode(aVersion).%Id()
	for{
		Set xQCID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVersion," "_aItemCode,xQCID))
		Quit:xQCID=""
		Set ItemID="",Express=""
		For{
			Set ItemID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVersion," "_aItemCode,xQCID,ItemID))
			Set Express=$o(^DHCMA.CPW.SD.QCExpressI("IdxOfCode"," "_$zcvt(aExpree,"U"),0))
			Quit:ItemID=""
			Quit:Express=""
			Set xItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xQCID_"||"_ItemID)
			Continue:'$IsObject(xItemObj)
			continue:xItemObj.GetDataParam'=""
			Set xItemObj.GetDataParam=aparam
			Set xItemObj.BTExpressDr=##class(DHCMA.CPW.SD.QCExpress).GetObjById(Express)
			
			Set sc=xItemObj.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc) 
		   		Set return=-1
			}Else{
				Set return=xItemObj.%Id()
			}
			Do xItemObj.%Close()
		}
	}
	Quit return
}

/// 按照病种id 版本id   批量删除版本病种校验规则
/// w ##class(DHCMA.CPW.SDS.QCItemValidRuleSrv).DeleteVerRule(33,2)
ClassMethod DeleteVerRule(aQCID As %String, aVerID As %String) As %String
{
	New (aQCID,aVerID)
	//如果导入当天已经导入了当前版本，退出
	Quit:$d(^DHCMADeleteVerRule(aQCID,aVerID,+$h)) ""
	Set xItemCode="",Count=0
	For {
		Set xItemCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",aQCID,aVerID,xItemCode))
		Quit:xItemCode=""
		Set xItemID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfQCVerCode",aQCID,aVerID,xItemCode,0))
		Set xItemobj=##class(DHCMA.CPW.SD.QCEntityItem).%OpenId(aQCID_"||"_xItemID)
		Continue:'$IsObject(xItemobj)
		Set xSubID=""
		For
	 	{
		 	Set xSubID = $o(^DHCMA.CPW.SD.QCEntityD(aQCID,"Item",xItemID,"Rule",xSubID))
		 	Quit:xSubID=""
		 	Set xRowID=aQCID_"||"_xItemID_"||"_xSubID
		 	d ##class(DHCMA.CPW.SD.QCItemValidRule).DeleteById(xRowID)
		 	Set Count=Count+1
	 	}
	}
	Set ^DHCMADeleteVerRule(aQCID,aVerID,+$h)="导入更新日期："_$zd(+$h)_" "_$zt($p($h,",",2))
	Quit "清除历史校验规则："_Count_"个"
}

}
