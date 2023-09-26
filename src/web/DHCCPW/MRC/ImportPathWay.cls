/// 名称: web.DHCCPW.MRC.ImportPathWay
/// 描述: 临床路径表单导入程序
/// 编写者：zhufei
/// 编写日期: 2010-10-28
Class web.DHCCPW.MRC.ImportPathWay Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCCPW.MRC.ImportPathWay).ReplaceStr("测试表单","表单","")
ClassMethod ReplaceStr(aStr0 As %String, aStr1 As %String, aStr2 As %String) As %String
{
	New (aStr0,aStr1,aStr2)
	Set return=""
	Quit:(aStr0="")||(aStr1="") return
	
	For indS=1:1:$l(aStr0,aStr1) {
		Set tStr=$p(aStr0,aStr1,indS)
		Continue:tStr=""
		If return="" {
			Set return=tStr
		} Else {
			Set return=return_aStr2_tStr
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-10-28
/// Description:  保存临时表单（Excel-->临时表单）
/// Table：       
/// Input：       argCode:     临时表单编号
///               argRowInfo:    Excel行数据
/// Return：      return: 临时表单编码
/// w ##class(web.DHCCPW.MRC.ImportPathWay).SaveTempForm("","")
ClassMethod SaveTempForm(argCode As %String, argRowInfo As %String) As %String
{
	New (argCode,argRowInfo)
	Set return=0
	Set $ZT="SaveTempFormErr"
	
	If argCode="" {
		Set Head=$tr($zd(+$h,3),"-","")
		Set tmp=""
		Set Num=$i(^DHCMRCFD("Form",Head))
		Set $p(tmp,"0",5-$l(Num))=Num
		Set tmp=Head_tmp
		Set argCode=tmp
		Kill ^DHCMRCFD("Form",argCode)
	}
	
	Set argRowInfo=$tr(argRowInfo,$c(0),"")
	Set argRowInfo=$tr(argRowInfo,$c(1),"")
	Set argRowInfo=$tr(argRowInfo,$c(10),"")
	Set argRowInfo=$tr(argRowInfo,$c(13),"")
	Set argRowInfo=$tr(argRowInfo,"^","")
	Set argRowInfo=$tr(argRowInfo,"?","")
	Set argRowInfo=$tr(argRowInfo," ","")
	Set argRowInfo=$tr(argRowInfo,$c(0),"")
	Set argRowInfo=$tr(argRowInfo,$c(1),"")
	Set argRowInfo=$tr(argRowInfo,$c(10),"")
	Set argRowInfo=$tr(argRowInfo,$c(13),"")
	
	Set return=-1
	Set Row=$i(^DHCMRCFD("Form",argCode,"Item3","Row"))
	Set DataRow=+$g(^DHCMRCFD("Form",argCode,"Item3","DataRow"))
	Set ItemName=$p(argRowInfo,$c(9),1)
	Set ItemValue=$p(argRowInfo,$c(9),3)
	If ItemName="路径名称"
	{
		Set ItemValue=$tr(ItemValue,"（","(")
		Set ItemValue=$tr(ItemValue,"）",")")
		Set ItemValue=..ReplaceStr(ItemValue,"临床路径","")
		Set ItemValue=..ReplaceStr(ItemValue,"表单","")
		Set ^DHCMRCFD("Form",argCode,"Item1","Name")=ItemValue
		Set CPWDicID=..getSameNameCPWDicID(ItemValue)
		If CPWDicID>0
		{
			Set ^DHCMRCFD("Form",argCode,"Item1","CPWDicID")=CPWDicID
		} Else {
			Set ^DHCMRCFD("Form",argCode,"Item1","CPWDicID")=""
		}
	} ElseIf ItemName="路径类型" {          //数据格式：对应路径类型字典描述
		Set ^DHCMRCFD("Form",argCode,"Item1","Type")=ItemValue
		If ItemValue'=""
		{
			If $g(^DHCMRCFD("Form",argCode,"Item0","CPWType",ItemValue))=""
			{
				Set ^DHCMRCFD("Form",argCode,"Item0","CPWType",ItemValue)=..GetCPWTypeID(ItemValue)
			}
		}
	} ElseIf ItemName="准入诊断ICD10" {     //数据格式：C00-D48,D49.001,D49.002
		Set ^DHCMRCFD("Form",argCode,"Item1","ICD10")=ItemValue
	} ElseIf ItemName="准入诊断关键字" {    //数据格式：多值英文逗号分割
		Set ^DHCMRCFD("Form",argCode,"Item1","ICDKey")=ItemValue
	} ElseIf ItemName="准入手术CM3" {       //数据格式：36.5-36.7,38.0
		Set ^DHCMRCFD("Form",argCode,"Item1","OperCM3")=ItemValue
	} ElseIf ItemName="准入手术关键字" {    //数据格式：多值英文逗号分割
		Set ^DHCMRCFD("Form",argCode,"Item1","OperKey")=ItemValue
	} ElseIf ItemName="准入提示" {
		Set ^DHCMRCFD("Form",argCode,"Item1","Label")=ItemValue
	} ElseIf ItemName="参考费用" {          //数据格式：2000-3000
		If ItemValue'=""
		{
			Set ItemValue=$tr(ItemValue," ","")
			Set ItemValue=$tr(ItemValue,"/","-")
			Set ItemValue=$tr(ItemValue,"\","-")
			Set ItemValue=$tr(ItemValue,"|","-")
			Set ItemVal1=+$p(ItemValue,"-",1)
			Set ItemVal2=+$p(ItemValue,"-",2)
			If ItemVal1>ItemVal2
			{
				Set ItemVal1=+$p(ItemValue,"-",2)
				Set ItemVal2=+$p(ItemValue,"-",1)
			}
			Set:ItemVal1=0 ItemVal1=ItemVal2
			Set ItemValue=ItemVal1_"-"_ItemVal2
			Set:ItemValue="0-0" ItemValue=""
		}
		Set ^DHCMRCFD("Form",argCode,"Item1","Cost")=ItemValue
	} ElseIf ItemName="参考天数" {    //数据格式：5-7
		If ItemValue'=""
		{
			Set ItemValue=$tr(ItemValue," ","")
			Set ItemValue=$tr(ItemValue,"/","-")
			Set ItemValue=$tr(ItemValue,"\","-")
			Set ItemValue=$tr(ItemValue,"|","-")
			Set ItemVal1=+$p(ItemValue,"-",1)
			Set ItemVal2=+$p(ItemValue,"-",2)
			If ItemVal1>ItemVal2
			{
				Set ItemVal1=+$p(ItemValue,"-",2)
				Set ItemVal2=+$p(ItemValue,"-",1)
			}
			Set:ItemVal1=0 ItemVal1=ItemVal2
			Set ItemValue=ItemVal1_"-"_ItemVal2
			Set:ItemValue="0-0" ItemValue=""
		}
		Set ^DHCMRCFD("Form",argCode,"Item1","Days")=ItemValue
	} ElseIf ItemName="变异分析描述" {
		Set ^DHCMRCFD("Form",argCode,"Item1","VarDesc")=ItemValue
	} ElseIf (ItemName="阶段")||(ItemName="步骤") {
		Set TMP="阶段"_$c(9)_"天数"_$c(9)_"类型"_$c(9)_"主要诊疗工作"_$c(9)_"类型"_$c(9)_"重点医嘱"_$c(9)_"类型"_$c(9)_"主要护理工作"
		Set ItemNames=$p(argRowInfo,$c(9),1)
		Set ItemNames=ItemNames_$c(9)_$p(argRowInfo,$c(9),2)
		Set ItemNames=ItemNames_$c(9)_$p(argRowInfo,$c(9),3)
		Set ItemNames=ItemNames_$c(9)_$p(argRowInfo,$c(9),4)
		Set ItemNames=ItemNames_$c(9)_$p(argRowInfo,$c(9),5)
		Set ItemNames=ItemNames_$c(9)_$p(argRowInfo,$c(9),6)
		Set ItemNames=ItemNames_$c(9)_$p(argRowInfo,$c(9),7)
		Set ^DHCMRCFD("Form",argCode,"Item3","DataRow")=Row
	} ElseIf (DataRow>0)&&(Row>DataRow) {
		Set return=-2
		Set argRowInfo=$tr(argRowInfo," ","")
		
		Set return=-2.1
		Set EpDesc=$p(argRowInfo,$c(9),1)
		Set EpStepDays=$p(argRowInfo,$c(9),2)
		Set EpStepDays=$tr(EpStepDays," ","")
		Set EpStepDays=$tr(EpStepDays,"/","-")
		Set EpStepDays=$tr(EpStepDays,"\","-")
		Set EpStepDays=$tr(EpStepDays,"|","-")
		Set EpStepDay1=+$p(EpStepDays,"-",1)
		Set EpStepDay2=+$p(EpStepDays,"-",2)
		If EpStepDay1>EpStepDay2
		{
			Set EpStepDay1=+$p(EpStepDays,"-",2)
			Set EpStepDay2=+$p(EpStepDays,"-",1)
		}
		Set:EpStepDay1=0 EpStepDay1=EpStepDay2
		Set EpStepDays=EpStepDay1_"-"_EpStepDay2
		Set:EpStepDays="0-0" EpStepDays=""
		
		Set return=-2.2
		If (EpDesc'="")&&($p($g(^DHCMRCFD("Form",argCode,"Item3","CurrEp")),"^",2)'=EpDesc)
		{
			Set EpInd=$i(^DHCMRCFD("Form",argCode,"Item3","CurrEpInd"))
			Set ^DHCMRCFD("Form",argCode,"Item3","CurrEp")=EpInd_"^"_EpDesc
		}
		If $g(^DHCMRCFD("Form",argCode,"Item3","CurrEp"))=""
		{
			Set EpDesc="步骤X"
			If (EpDesc'="")&&($p($g(^DHCMRCFD("Form",argCode,"Item3","CurrEp")),"^",2)'=EpDesc)
			{
				Set EpInd=$i(^DHCMRCFD("Form",argCode,"Item3","CurrEpInd"))
				Set ^DHCMRCFD("Form",argCode,"Item3","CurrEp")=EpInd_"^"_EpDesc
			}
		}
		Set EpDesc=$g(^DHCMRCFD("Form",argCode,"Item3","CurrEp"))
		Set EpStepDesc=$p(EpDesc,"^",2)
		If $g(^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc))="" {
			Set ^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc)=EpStepDays
		}
		
		Set return=-2.3
		Set ItemVal1=$p(argRowInfo,$c(9),4)
		If ItemVal1'=""
		{
			Set ItemType="1^主要诊疗工作"
			Set ItemTypeSub=$p(argRowInfo,$c(9),3)
			Set:ItemTypeSub="" ItemTypeSub="主要诊疗工作(空)"
			Set ItemInd=$i(^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType))
			Set ^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType,ItemInd)=ItemTypeSub_"^"_ItemVal1
			If ItemTypeSub'=""
			{
				If $g(^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub,ItemType))=""
				{
					Set ^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub,ItemType)=..GetItemTypeSubID(ItemTypeSub,ItemType)
				}
			}
		}
		
		Set return=-2.4
		Set ItemVal2=$p(argRowInfo,$c(9),6)
		If ItemVal2'=""
		{
			Set ItemType="2^重点医嘱"
			Set ItemTypeSub=$p(argRowInfo,$c(9),5)
			Set:ItemTypeSub="" ItemTypeSub="重点医嘱(空)"
			Set ItemInd=$i(^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType))
			Set ^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType,ItemInd)=ItemTypeSub_"^"_ItemVal2
			If ItemTypeSub'=""
			{
				If $g(^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub,ItemType))=""
				{
					Set ^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub,ItemType)=..GetItemTypeSubID(ItemTypeSub,ItemType)
				}
			}
		}
		
		Set return=-2.5
		Set ItemVal3=$p(argRowInfo,$c(9),8)
		If ItemVal3'=""
		{
			Set ItemType="3^主要护理工作"
			Set ItemTypeSub=$p(argRowInfo,$c(9),7)
			Set:ItemTypeSub="" ItemTypeSub="主要护理工作(空)"
			Set ItemInd=$i(^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType))
			Set ^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType,ItemInd)=ItemTypeSub_"^"_ItemVal3
			If ItemTypeSub'=""
			{
				If $g(^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub,ItemType))=""
				{
					Set ^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub,ItemType)=..GetItemTypeSubID(ItemTypeSub,ItemType)
				}
			}
		}
	}
	
	Set return=argCode
	Quit return
	
SaveTempFormErr
	Set return=-999
	Quit return_$ZE
}

/// w ##class(web.DHCCPW.MRC.ImportPathWay).SaveTempFormNew("","步骤"_$c(9)_"住院第1天"_$c(9)_"住院第2-7天（放疗前准备）"_$c(9)_"住院第3-7天"_$c(10)_"（放疗第1天）"_$c(9)_"住院7-35天"_$c(10)_"放疗1-28日"_$c(9)_"住院36天"_$c(10)_"放疗后第28日"_$c(9)_"住院37-52天"_$c(10)_"放疗后第29-42（至出院）"_$c(9,9,9,9))
ClassMethod SaveTempFormNew(argCode As %String, argRowInfo As %String) As %String
{
	New (argCode,argRowInfo)
	Set return=0
	Set $ZT="SaveTempFormNewErr"
	If argCode="" {
		Set Head=$tr($zd(+$h,3),"-","")
		Set tmp=""
		Set Num=$i(^DHCMRCFD("Form",Head))
		Set $p(tmp,"0",5-$l(Num))=Num
		Set tmp=Head_tmp
		Set argCode=tmp
		Kill ^DHCMRCFD("Form",argCode)
	}
	
	Set argRowInfo=$tr(argRowInfo,$c(0),"")
	Set argRowInfo=$tr(argRowInfo,$c(1),"")
	Set argRowInfo=$tr(argRowInfo,$c(13),"")
	Set argRowInfo=$tr(argRowInfo,"^","")
	Set argRowInfo=$tr(argRowInfo,"?","")
	Set argRowInfo=$tr(argRowInfo," ","")
	Set argRowInfo=$tr(argRowInfo,$c(0),"")
	Set argRowInfo=$tr(argRowInfo,$c(1),"")
	Set argRowInfo=$tr(argRowInfo,$c(13),"")
	
	Set return=-1
	Set Row=$i(^DHCMRCFD("Form",argCode,"Item3","Row"))
	Set DataRow=+$g(^DHCMRCFD("Form",argCode,"Item3","DataRow"))
	Set ItemName=$p(argRowInfo,$c(9),1)
	Set ItemValue=$p(argRowInfo,$c(9),2)
  
	If ItemName="路径名称"
	{   
		Set ItemValue=$tr(ItemValue,$c(10),"")
		Set ItemValue=$tr(ItemValue,"（","(")
		Set ItemValue=$tr(ItemValue,"）",")")
		Set ItemValue=..ReplaceStr(ItemValue,"临床路径","")
		Set ItemValue=..ReplaceStr(ItemValue,"表单","")
		Set ^DHCMRCFD("Form",argCode,"Item1","Name")=ItemValue
		Set CPWDicID=..getSameNameCPWDicID(ItemValue)
		If CPWDicID>0
		{
			Set ^DHCMRCFD("Form",argCode,"Item1","CPWDicID")=CPWDicID
		} Else {
			Set ^DHCMRCFD("Form",argCode,"Item1","CPWDicID")=""
		}
	} ElseIf ItemName="路径类型" {          //数据格式：对应路径类型字典描述
		Set ^DHCMRCFD("Form",argCode,"Item1","Type")=ItemValue
		If ItemValue'=""
		{
			If $g(^DHCMRCFD("Form",argCode,"Item0","CPWType",ItemValue))=""
			{
				Set ^DHCMRCFD("Form",argCode,"Item0","CPWType",ItemValue)=..GetCPWTypeID(ItemValue)
			}
		}
	} ElseIf ItemName="准入诊断ICD10" {     //数据格式：C00-D48,D49.001,D49.002
		Set ^DHCMRCFD("Form",argCode,"Item1","ICD10")=ItemValue
	} ElseIf ItemName="准入诊断关键字" {    //数据格式：多值英文逗号分割
		Set ^DHCMRCFD("Form",argCode,"Item1","ICDKey")=ItemValue
	} ElseIf ItemName="准入手术CM3" {       //数据格式：36.5-36.7,38.0
		Set ^DHCMRCFD("Form",argCode,"Item1","OperCM3")=ItemValue
	} ElseIf ItemName="准入手术关键字" {    //数据格式：多值英文逗号分割
		Set ^DHCMRCFD("Form",argCode,"Item1","OperKey")=ItemValue
	} ElseIf ItemName="准入提示" {
		Set ^DHCMRCFD("Form",argCode,"Item1","Label")=ItemValue
	} ElseIf ItemName="参考费用" {          //数据格式：2000-3000
		If ItemValue'=""
		{
			Set ItemValue=$tr(ItemValue," ","")
			Set ItemValue=$tr(ItemValue,"/","-")
			Set ItemValue=$tr(ItemValue,"\","-")
			Set ItemValue=$tr(ItemValue,"|","-")
			Set ItemVal1=+$p(ItemValue,"-",1)
			Set ItemVal2=+$p(ItemValue,"-",2)
			If ItemVal1>ItemVal2
			{
				Set ItemVal1=+$p(ItemValue,"-",2)
				Set ItemVal2=+$p(ItemValue,"-",1)
			}
			Set:ItemVal1=0 ItemVal1=ItemVal2
			Set ItemValue=ItemVal1_"-"_ItemVal2
			Set:ItemValue="0-0" ItemValue=""
		}
		Set ^DHCMRCFD("Form",argCode,"Item1","Cost")=ItemValue
	} ElseIf ItemName="参考天数" {    //数据格式：5-7
		If ItemValue'=""
		{
			Set ItemValue=$tr(ItemValue,$c(10),"")
			Set ItemValue=$tr(ItemValue," ","")
			Set ItemValue=$tr(ItemValue,"/","-")
			Set ItemValue=$tr(ItemValue,"\","-")
			Set ItemValue=$tr(ItemValue,"|","-")
			Set ItemVal1=+$p(ItemValue,"-",1)
			Set ItemVal2=+$p(ItemValue,"-",2)
			If ItemVal1>ItemVal2
			{
				Set ItemVal1=+$p(ItemValue,"-",2)
				Set ItemVal2=+$p(ItemValue,"-",1)
			}
			Set:ItemVal1=0 ItemVal1=ItemVal2
			Set ItemValue=ItemVal1_"-"_ItemVal2
			Set:ItemValue="0-0" ItemValue=""
		}
		Set ^DHCMRCFD("Form",argCode,"Item1","Days")=ItemValue
	} ElseIf ItemName="变异分析描述" {
		Set ^DHCMRCFD("Form",argCode,"Item1","VarDesc")=ItemValue
	} ElseIf (ItemName="阶段")||(ItemName="步骤") {
		Set argRowInfo=$tr(argRowInfo," ","")
		Set EpDesc=""
	    For ind=2:1:$l(argRowInfo,$c(9)){
			Set EpDesc=$p(argRowInfo,$c(9),ind)
			Set EpDesc=$tr(EpDesc,$c(10),"")
			If (EpDesc'="")&&($p($g(^DHCMRCFD("Form",argCode,"Item3","CurrEp")),"^",2)'=EpDesc) {
				Set EpInd=$i(^DHCMRCFD("Form",argCode,"Item3","CurrEpInd"))
				Set ^DHCMRCFD("Form",argCode,"Item3","CurrEp")=EpInd_"^"_EpDesc
				Set ^DHCMRCFD("Form",argCode,"Item","EpDesc",ind)=EpInd_"^"_EpDesc
			}
			
		}
		Set ^DHCMRCFD("Form",argCode,"Item3","DataRow")=Row
	}
	 ElseIf (ItemName="天数") {
		Set argRowInfo=$tr(argRowInfo," ","")
		Set EpStepDay=""
	    For ind=2:1:$l(argRowInfo,$c(9)){
		    Set EpStepDay=$p(argRowInfo,$c(9),ind)
			Set EpStepDay=$tr(EpStepDay," ","")
			Set EpStepDay=$tr(EpStepDay,"/","-")
			Set EpStepDay=$tr(EpStepDay,"\","-")
			Set EpStepDay=$tr(EpStepDay,"|","-")
			Set EpStepDay1=+$p(EpStepDay,"-",1)
			Set EpStepDay2=+$p(EpStepDay,"-",2)
			If EpStepDay1>EpStepDay2
			{
				Set EpStepDay1=+$p(EpStepDay,"-",2)
				Set EpStepDay2=+$p(EpStepDay,"-",1)
			}
			Set:EpStepDay1=0 EpStepDay1=EpStepDay2
			Set EpStepDay=EpStepDay1_"-"_EpStepDay2
			Set:EpStepDay="0-0" EpStepDay=""
			If (EpStepDay'="") {
		    	Set ^DHCMRCFD("Form",argCode,"Item","EpStepDay",ind)=EpStepDay
			}
		}
		Set ^DHCMRCFD("Form",argCode,"Item3","DataRow")=Row
	}ElseIf (ItemName="主要诊疗工作") {
	    Set argRowInfo=$tr(argRowInfo," ","")  
	    Set ZYZLDescList=""
	    For ind=2:1:$l(argRowInfo,$c(9)){
			Set ZYZLDescList=$p(argRowInfo,$c(9),ind)
			If (ZYZLDescList'=""){
				Set ^DHCMRCFD("Form",argCode,"Item","ZYZLDescList",ind)=ZYZLDescList
			}
		}
	    Set ^DHCMRCFD("Form",argCode,"Item3","DataRow")=Row
	}ElseIf (ItemName="重点医嘱") {
		Set argRowInfo=$tr(argRowInfo," ","")
	    Set ZDYZDescList=""
	    For ind=2:1:$l(argRowInfo,$c(9)){
			Set ZDYZDescList=$p(argRowInfo,$c(9),ind)
			If (ZDYZDescList'=""){
				Set ^DHCMRCFD("Form",argCode,"Item","ZDYZDescList",ind)=ZDYZDescList
			}
		}
	   
	}ElseIf (ItemName="主要护理工作") {
		Set argRowInfo=$tr(argRowInfo," ","")
	    Set ZYHLDescList=""
	    For ind=2:1:$l(argRowInfo,$c(9)){
			Set ZYHLDescList=$p(argRowInfo,$c(9),ind)
			If (ZYHLDescList'=""){	
				Set ^DHCMRCFD("Form",argCode,"Item","ZYHLDescList",ind)=ZYHLDescList
			}
		}
		Set ^DHCMRCFD("Form",argCode,"Item3","DataRow")=Row
	}
	
	Set index=""
	For {
		Set index=$o(^DHCMRCFD("Form",argCode,"Item","EpDesc",index))
		Quit:index=""
		Set EpDescList=$g(^DHCMRCFD("Form",argCode,"Item","EpDesc",index))
		Set EpStepDayList=$g(^DHCMRCFD("Form",argCode,"Item","EpStepDay",index))
		Set EpStepDesc=$p(EpDescList,"^",2)
	
		If $g(^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc))="" {
			Set ^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc)=EpStepDayList
		}
		
		Set return=-2
		If (ItemName="主要诊疗工作"){
			Set ItemType1="1^主要诊疗工作"
			Set Flg=0
			Set ItemTypeSub1=""
			Set ZYZLDescList=$g(^DHCMRCFD("Form",argCode,"Item","ZYZLDescList",index))
			For indx=1:1:$l(ZYZLDescList,$c(10)) {
				Set ZYZLDesc=$p(ZYZLDescList,$c(10),indx)
				Continue:ZYZLDesc=""
				If ($f(ZYZLDesc,"【】")<1)&&($f(ZYZLDesc,"【*】")<1) {
					Set ZYZLDesc=$tr(ZYZLDesc,":","")
					Set ZYZLDesc=$tr(ZYZLDesc,"：","")
					Set ItemTypeSub1=ZYZLDesc
				}Else {
					Set ItemTypeSub1="主要诊疗工作"
					Set ZYZLDesc=$tr(ZYZLDesc,"【】","")
				}
				Set ItemIndx=$i(^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType1))
	            If $g(^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType1,ItemIndx))="" {
					Set ^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType1,ItemIndx)=ItemTypeSub1_"^"_ZYZLDesc
	            }
				If ItemTypeSub1'=""
				{
					If $g(^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub1,ItemType1))=""
					{
						Set ^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub1,ItemType1)=..GetItemTypeSubID(ItemTypeSub1,ItemType1)
					}
				}
			}
		}ElseIf (ItemName="重点医嘱") {
			Set ItemType2="2^重点医嘱"
			Set ZDYZDescList=$g(^DHCMRCFD("Form",argCode,"Item","ZDYZDescList",index))
			Set ItemTypeSub2=""
			For indy=1:1:$l(ZDYZDescList,$c(10)){
				Set ZDYZDesc=$p(ZDYZDescList,$c(10),indy)
				Continue:ZDYZDesc=""
				If ($f(ZDYZDesc,"【】")<1)&&($f(ZDYZDesc,"【*】")<1) {
					Set ZDYZDesc=$tr(ZDYZDesc,":","")
					Set ZDYZDesc=$tr(ZDYZDesc,"：","")
					Set ItemTypeSub2=ZDYZDesc		
				}Else {
					Set ZDYZDesc=$tr(ZDYZDesc,"【】","")
					Set ItemIndy=$i(^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType2))
					If $g(^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType2,ItemIndy))="" {
						Set ^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType2,ItemIndy)=ItemTypeSub2_"^"_ZDYZDesc
					}
				}
				Set:ItemTypeSub2="" ItemTypeSub2="重点医嘱(空)"
				If ItemTypeSub2'=""
					{
						If $g(^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub2,ItemType2))=""
						{
							Set ^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub2,ItemType2)=..GetItemTypeSubID(ItemTypeSub2,ItemType2)
						}
					}
				
			}
			
		}ElseIf (ItemName="主要护理工作") {
		    Set ItemType3="3^主要护理工作"
		    Set ItemTypeSub3=""
		    Set ZYHLDescList=$g(^DHCMRCFD("Form",argCode,"Item","ZYHLDescList",index))
			For indz=1:1:$l(ZYHLDescList,$c(10)) {
				Set ZYHLDesc=$p(ZYHLDescList,$c(10),indz)
				Continue:ZYHLDesc=""
				If ($f(ZYHLDesc,"【】")<1)&&($f(ZYHLDesc,"【*】")<1) {
					Set ZYHLDesc=$tr(ZYHLDesc,":","")
					Set ZYHLDesc=$tr(ZYHLDesc,"：","")
					Set ItemTypeSub3=ZYHLDesc
				}Else {
					Set ItemTypeSub3="主要护理工作"
					Set ZYHLDesc=$tr(ZYHLDesc,"【】","")
				}
				Set ItemIndz=$i(^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType3))
				If $g(^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType3,ItemIndz))=""{
					Set ^DHCMRCFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType3,ItemIndz)=ItemTypeSub3_"^"_ZYHLDesc
				}
				If ItemTypeSub3'=""
				{
					If $g(^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub3,ItemType3))=""
					{
						Set ^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub3,ItemType3)=..GetItemTypeSubID(ItemTypeSub3,ItemType3)
					}
				}
			}
		}
	}
	
	Set return=argCode
	Quit return
	
SaveTempFormNewErr
	Set return=-999
	Quit return_$ZE
}

/// 检查是否存在同名临床路径
/// w ##Class(web.DHCCPW.MRC.ImportPathWay).getSameNameCPWDicID("胃十二指肠溃疡")
ClassMethod getSameNameCPWDicID(argName)
{
	New (argName)
	Set return=-1
	Quit:argName="" return
	
	Set return=0
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		Quit:return>0
		Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		Continue:'$IsObject(objCPW)
		Set CPWDesc=objCPW.CPWCPWDicDR.CPWDDesc
		Set CPWCode=objCPW.CPWCPWDicDR.CPWDCode
		Set IsActive=objCPW.CPWCPWDicDR.CPWDActive
		Continue:IsActive'["Y"
		Set CPWDesc=$tr(CPWDesc,"（","(")
		Set CPWDesc=$tr(CPWDesc,"）",")")
		Set CPWDesc=$tr(CPWDesc,"临床路径","")
		Set CPWDesc=$tr(CPWDesc,"表单","")
		Set:(argName'="")&&(CPWDesc=argName) return=objCPW.CPWCPWDicDR.%Id()
	}
	Quit:return'="" return
	
	Set return=0
	Set CPWDID=0
	For {
		Set CPWDID=$o(^DHCMRC("CPWD",CPWDID))
		Quit:CPWDID=""
		Quit:return>0
		Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDID)
		Continue:'$IsObject(objCPWDic)
		Set CPWDDesc=objCPWDic.CPWDDesc
		Set CPWDCode=objCPWDic.CPWDCode
		Set IsActive=objCPWDic.CPWDActive
		Continue:IsActive'["Y"
		Set CPWDDesc=$tr(CPWDDesc,"（","(")
		Set CPWDDesc=$tr(CPWDDesc,"）",")")
		Set CPWDDesc=$tr(CPWDDesc,"临床路径","")
		Set CPWDDesc=$tr(CPWDDesc,"表单","")
		Set:(argName'="")&&(CPWDDesc=argName) return=objCPWDic.%Id()
	}
	
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.ImportPathWay).GetCPWTypeID("呼吸内科")
ClassMethod GetCPWTypeID(argCPWType As %String) As %String
{
	New (argCPWType)
	Set return=""
	Quit:argCPWType="" return
	
	Set CLPTID=0
	For {
		Set CLPTID=$o(^DHCMRC("CLPT",CLPTID))
		Quit:CLPTID=""
		Quit:return'=""
		
		Set CLPTDesc=$listget($g(^DHCMRC("CLPT",CLPTID)),3)
		Set:CLPTDesc=argCPWType return=CLPTID
	}
	
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.ImportPathWay).GetItemTypeSubID("主要护理工作","3^主要护理工作")
ClassMethod GetItemTypeSubID(argTypeSubDesc As %String, argItemType As %String) As %String
{
	New (argTypeSubDesc,argItemType)
	Set return=""
	Quit:(argTypeSubDesc="")||(argItemType="") return
	
	Set TypeID=0
	For {
		Set TypeID=$o(^DHCMRC("SIC",TypeID))
		Quit:TypeID=""
		Quit:return'=""
		
		Set ItemTypeDesc=$listget($g(^DHCMRC("SIC",TypeID)),3)
		Continue:ItemTypeDesc'=$p(argItemType,"^",2)
		
		Set TypeSubID=0
		For {
			Set TypeSubID=$o(^DHCMRC("SIC",TypeID,"SUB",TypeSubID))
			Quit:TypeSubID=""
			Quit:return'=""
			
			Set TypeSubDesc=$listget($g(^DHCMRC("SIC",TypeID,"SUB",TypeSubID)),3)
			Set:argTypeSubDesc=TypeSubDesc return=TypeID_"||"_TypeSubID
		}
	}
	
	Quit return
}

/// 检查临床表单数据的合法性
ClassMethod checkFromDataRightful(argCode As %String) As %String
{
	New (argCode)
	Set return=""
	
	Set Name=$g(^DHCMRCFD("Form",argCode,"Item1","Name"))
	Set:Name="" return=return_"路径名称为空;<br>"
	Set CPWDicID=$g(^DHCMRCFD("Form",argCode,"Item1","CPWDicID"))
	//Set:CPWDicID'="" return=return_"已存在同名路径;<br>"
	Set Type=$g(^DHCMRCFD("Form",argCode,"Item1","Type"))
	If Type=""
	{
		Set return=return_"路径类型为空;<br>"
	} Else {
		If $g(^DHCMRCFD("Form",argCode,"Item0","CPWType",Type))=""
		{
			Set return=return_"路径类型 "_Type_" 字典对照错误;<br>"
		}
	}
	Set ItemTypeSub=""
	For {
		Set ItemTypeSub=$o(^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub))
		Quit:ItemTypeSub=""
		Set xItemType=""
		For {
			Set xItemType=$o(^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub,xItemType))
			Quit:xItemType=""
			If $g(^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub,xItemType))=""
			{
				Set return=return_"项目子类 "_ItemTypeSub_" 字典对照错误;<br>"
			}
		}
		
	}
	Set ICD10=$g(^DHCMRCFD("Form",argCode,"Item1","ICD10"))
	Set:ICD10="" return=return_"准入诊断ICD10为空;<br>"
	If (ICD10[":")||($ZCVT(ICD10,"U")["ICD")
	{
		Set return=return_"准入诊断ICD10格式错误;<br>"
	}
	Set ICDKey=$g(^DHCMRCFD("Form",argCode,"Item1","ICDKey"))
	//Set:ICDKey="" return=return_"准入诊断关键字为空;<br>"
	Set OperCM3=$g(^DHCMRCFD("Form",argCode,"Item1","OperCM3"))
	//Set:OperCM3="" return=return_"准入手术CM3为空;<br>"
	If (OperCM3[":")||($ZCVT(OperCM3,"U")["ICD")||($ZCVT(OperCM3,"U")["CM")
	{
		Set return=return_"准入手术CM3格式错误;<br>"
	}
	Set Label=$g(^DHCMRCFD("Form",argCode,"Item1","Label"))
	Set:Label="" return=return_"准入提示为空;<br>"
	Set Cost=$g(^DHCMRCFD("Form",argCode,"Item1","Cost"))
	Set:Cost="" return=return_"参考费用为空;<br>"
	Set Days=$g(^DHCMRCFD("Form",argCode,"Item1","Days"))
	Set:Days="" return=return_"参考天数为空;<br>"
	
	Set DataRow=+$g(^DHCMRCFD("Form",argCode,"Item3","DataRow"))
	Set:DataRow=0 return=return_"表单格式错误;<br>"
	
	Set:return'="" return=return_"<b>请修改数据后,再重新导入!</b>"
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-11-01
/// Description:  取临时表单列表
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.ImportPathWay","QryTempFormData")
Query QryTempFormData() As %Query(ROWSPEC = "Code:%String,Desc:%String,RowCount:%String,Reminder:%String")
{
}

ClassMethod QryTempFormDataExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set Code=""
	For {
		Set Code=$o(^DHCMRCFD("Form",Code))
		Quit:Code=""
		Continue:$l(Code)<9
		
		Set Desc=$g(^DHCMRCFD("Form",Code,"Item1","Name"))
		Set RowCount=+$g(^DHCMRCFD("Form",Code,"Item3","Row"))
		Set Reminder=..checkFromDataRightful(Code)
		Set CPWDicID=$g(^DHCMRCFD("Form",Code,"Item1","CPWDicID"))
		Set:CPWDicID'="" Reminder="已存在同名路径;<br>"_Reminder
		
		Set Data=$lb(Code,Desc,RowCount,Reminder)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryTempFormDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTempFormDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTempFormDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTempFormDataExecute ]
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
/// CreatDate：   2010-11-01
/// Description:  删除临时表单
/// Table：       
/// Input：       argCode:     临时表单编号
/// Return：      return>0 删除正确
/// w ##class(web.DHCCPW.MRC.ImportPathWay).DeleteTempForm(argCode)
ClassMethod DeleteTempForm(argCode)
{
	New (argCode)
	Set return=-1
	
	Set $ZT="DeleteTempFormErr"
	
	If $d(^DHCMRCFD("Form",argCode)) {
		Kill ^DHCMRCFD("Form",argCode)
		Set return=1
	}
	
	Quit return
	
DeleteTempFormErr
	Set return=-999
	Quit return_$ZE
}

/// Creator：     zhufei
/// CreatDate：   2010-11-01
/// Description:  保存表单（临时表单-->正式表单）
/// Table：       
/// Input：       argCode: 临时表单编号
///               argID:   是否覆盖
/// Return：      return>0 导数据正确
/// w ##class(web.DHCCPW.MRC.ImportPathWay).SaveForm("",201202150012)
ClassMethod SaveForm(argID As %String, argCode As %String) As %String
{
	New (argID,argCode)
	Set return=0
	Quit:argCode="" return
	
	Set $ZT="SaveFormErr"
	
	//判断数据合法性
	Set return=-1
	Set flg=..checkFromDataRightful(argCode)
	Quit:flg'="" return
	
	//取路径字典数据
	Set return=-2
	Set Code=argCode                                               //路径代码
	Set CPWDicID=$g(^DHCMRCFD("Form",Code,"Item1","CPWDicID"))     //路径ID
	Set Name=$g(^DHCMRCFD("Form",Code,"Item1","Name"))             //路径名称
	Set Type=$g(^DHCMRCFD("Form",Code,"Item1","Type"))             //路径类型
	Set TypeID=""
	Set:Type'="" TypeID=$g(^DHCMRCFD("Form",Code,"Item0","CPWType",Type))
	Set ICD10=$g(^DHCMRCFD("Form",Code,"Item1","ICD10"))           //准入诊断ICD10
	Set ICDKey=$g(^DHCMRCFD("Form",Code,"Item1","ICDKey"))         //准入诊断关键字
	Set OperCM3=$g(^DHCMRCFD("Form",Code,"Item1","OperCM3"))       //准入手术CM3
	Set OperKey=$g(^DHCMRCFD("Form",Code,"Item1","OperKey"))       //准入手术关键字
	Set Label=$g(^DHCMRCFD("Form",Code,"Item1","Label"))           //准入提示
	Set Days=$g(^DHCMRCFD("Form",argCode,"Item1","Days"))          //参考天数
	Set Cost=$g(^DHCMRCFD("Form",argCode,"Item1","Cost"))          //参考费用
	Set VarDesc=$g(^DHCMRCFD("Form",argCode,"Item1","VarDesc"))    //变异分析描述
	Set OffShoot="false"                                           //是否分支路径
	If $e(Name,1,1)="*" {
		Set OffShoot="true"
		Set Name=$e(Name,2,$l(Name))
	}
	Quit:(Name="")||(TypeID="") return
	
	TStart
	
	//更新路径字典及路径主表信息
	Set return=-3
	If argID'="" {
		//覆盖原来表单
		Set return=-3.1,flg=0
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(argID)
		If objCPW'="" {
			Set CPWDicID=objCPW.CPWCPWDicDR.%Id()
			Set InputStr=""_"^"_CPWDicID_"^"_Cost_"^"_Days_"^"_ICD10_"^"_Label_"^"_VarDesc_"^"_OffShoot_"^"_ICDKey_"^"_OperCM3_"^"_OperKey
			Set flg=##Class(web.DHCCPW.MRC.CliPathWay).Update(InputStr)
			If flg<0 TRollBack
		} Else {
			Set flg=-1
		}
	} Else {
		//导入新表单
		Set return=-3.2,flg=0
		Set InputStr=CPWDicID_"^"_Code_"^"_Name_"^"_TypeID_"^"_"Y"_"^"_$zd(+$h,3)_"^"_""_"^"_""
		Set flg=##Class(web.DHCCPW.MRC.ClinPathWaysDicSrv).Update(InputStr,Code,Name)
		If flg<0 {
			TRollBack
		} Else {
			Set CPWDicID=flg
			Set InputStr=""_"^"_CPWDicID_"^"_Cost_"^"_Days_"^"_ICD10_"^"_Label_"^"_VarDesc_"^"_OffShoot_"^"_ICDKey_"^"_OperCM3_"^"_OperKey
			Set flg=##Class(web.DHCCPW.MRC.CliPathWay).Update(InputStr)
			If flg<0 TRollBack
		}
	}
	Quit:flg<0 return
	Set CPWID=flg  //路径ID
	
	Set HelpFild="<P><STRONG><FONT size=7>"_Name_"<BR><BR><BR><BR><BR><BR><BR><BR><BR></FONT></STRONG></P>"
	Set flg=##Class(web.DHCCPW.MRC.ClinPathWaysSrv).UpdateHelp(CPWID,HelpFild)
	
	//更新路径阶段,步骤,项目信息
	Set return=-4,flg=0
	//阶段、步骤、项目组织结构
	//^DHCMRCFD("Form",代码,"Item2",阶段,步骤,项目大类,编号)="项目子类^项目值"
	Set EpDesc=""
	For {
		Set EpDesc=$o(^DHCMRCFD("Form",argCode,"Item2",EpDesc))
		Quit:EpDesc=""
		Quit:flg<0
		
		//导入临床路径阶段信息
		Set return=-4.1,flg=0
		Set InputStr=CPWID_"^"_""_"^"_$p(EpDesc,"^",2)_"^"_$p(EpDesc,"^",1)_"^"_""
		Set flg=##Class(web.DHCCPW.MRC.PathWayEp).Update(InputStr)
		If flg<0 TRollBack
		Quit:flg<0
		Set CPWEpID=flg   //阶段ID
		Set EpStepDesc=$p(EpDesc,"^",2)
		
		//导入临床路径阶段信息
		Set return=-4.2,flg=0
		Set DayUnit="D"
		Set Day=$g(^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc))
		Set:Day="" Day="1-1"
		Set:Day["天" DayUnit="D"      //天
		Set:Day["时" DayUnit="H"      //小时
		Set:Day["分" DayUnit="M"      //分钟
		Set InputStr=CPWEpID_"^"_""_"^"_Day_"^"_$p(EpDesc,"^",1)_"^"_$p(EpDesc,"^",2)_"^"_DayUnit
		Set flg=##Class(web.DHCCPW.MRC.PathWEpStep).Update(InputStr)
		If flg<0 TRollBack
		Quit:flg<0
		Set CPWEpStepID=flg   //步骤ID
		
		Set return=-4.3,flg=0
		Set ItemType=""
		For {
			Set ItemType=$o(^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType))
			Quit:ItemType=""
			Quit:flg<0
			
			Set ItemInd=0,flg=0
			For {
				Set ItemInd=$o(^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType,ItemInd))
				Quit:ItemInd=""
				Quit:flg<0
				
				//导入临床路径项目信息
				Set return=-4.4,flg=0
				Set tmpItem=$g(^DHCMRCFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType,ItemInd))
				Set ItemTypeSub=$p(tmpItem,"^",1)
				Set ItemDesc=$p(tmpItem,"^",2)
				Continue:ItemDesc=""
				Set ItemTypeID=$g(^DHCMRCFD("Form",argCode,"Item0","ItemTypeSub",ItemTypeSub,ItemType))
				if (ItemType="2^重点医嘱"){
					//对医嘱按"、"拆分项目
					Set len=$l(ItemDesc,"、")
					for index=1:1:len {
						Set Item=$p(ItemDesc,"、",index)
						Continue:Item=""
						Set ItemIsMust="No"
						If $e(Item,1,1)="*" {
							Set ItemIsMust="Yes"
							Set Item=$e(Item,2,$l(Item))
						}
						Set InputStr=CPWEpStepID_"^"_""_"^"_ItemTypeID_"^"_ItemInd_"^"_Item_"^"_""_"^"_"KEY"_"^"_""_"^"_ItemIsMust
						Set flg=##Class(web.DHCCPW.MRC.PathWEpStepItem).Update(InputStr)
						If flg<0 TRollBack
						Quit:flg<0
						Set StepItemRowID=flg
						//Do ..CopyArcimByDesc(StepItemRowID)     //拷贝关联医嘱
					}
				}else{
					Set ItemIsMust="No"
					If $e(ItemDesc,1,1)="*" {
						Set ItemIsMust="Yes"
						Set ItemDesc=$e(ItemDesc,2,$l(ItemDesc))
					}
					Set InputStr=CPWEpStepID_"^"_""_"^"_ItemTypeID_"^"_ItemInd_"^"_ItemDesc_"^"_""_"^"_"KEY"_"^"_""_"^"_ItemIsMust	//update by liuyh 2017-03-02 
					Set flg=##Class(web.DHCCPW.MRC.PathWEpStepItem).Update(InputStr)
					If flg<0 TRollBack
					Quit:flg<0
				}
			}
		}
	}
	Quit:flg<0 return
	
	Kill ^DHCMRCFD("Form",argCode)
	Set return=$g(CPWID)
	
	TCommit
	
	Quit return
	
SaveFormErr
	Set return=-999
	//回滚事物,增加异常显示
	TRollBack
	Quit return_$ZE
}

/// w ##Class(web.DHCCPW.MRC.ImportPathWay).ChangeLnkOEPriority()
ClassMethod ChangeLnkOEPriority()
{
	New
	
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		Set EpID=0
		For {
			Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
			Quit:EpID=""
			Set StepID=0
			For {
				Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
				Quit:StepID=""
				Set ItemID=0
				For {
					Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
					Quit:ItemID=""
					
					Set ItemRowid=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
					Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowid)
					Continue:'$IsObject(objItem)
					Set SubTypeDesc=objItem.CPWSISubCategory.SISCDesc
					Set PriorityID = $o(^OECPR(0,"Desc",SubTypeDesc,0))
					Continue:PriorityID=""
					
					Set ARCIMLen=objItem.CPWSIARCIM.Count()
					For lnInd=1:1:ARCIMLen {
						Set objARCIM=objItem.CPWSIARCIM.GetAt(lnInd)
						Continue:'$IsObject(objARCIM)
						Set objARCIM.ITMIsMain="Y"
						Set tmpPriority=objARCIM.ITMPriority
						Set:($p($g(^OECPR(+tmpPriority)),"^",2)'="") PriorityID=+tmpPriority
						Set objARCIM.ITMPriority=PriorityID
						Do objItem.CPWSIARCIM.SetAt(objARCIM,lnInd)
					}
					Set sc=objItem.%Save()
					If $System.Status.IsError(sc) {                      //检查Save是否成功
				   		Do $system.OBJ.DisplayError(sc)
					}
					Do objItem.%Close()
				}
			}
		}
	}
	
	Quit "Over!"
}

/// Creator：     wuqk
/// CreatDate：   2011-10-24
/// Description:  拷贝关联医嘱
/// Table：       
/// Input：       StepItemId:     临床路径项目Id
/// d ##class(web.DHCCPW.MRC.ImportPathWay).CopyArcimByDesc(itemId)
ClassMethod CopyArcimByDesc(itemId)
{
	n (itemId)
	s objStepItem=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(itemId)
	q:'$IsObject(objStepItem)
	s itemDesc=objStepItem.CPWSIDesc
	s cId=$p(itemId,"||",1)
	s eId=$p(itemId,"||",2)
	s sId=$p(itemId,"||",3)
	s iId=$p(itemId,"||",4)
	s flag=0
	//^DHCMRC("CPW",1,"EP",5,"STEP",1,"ITEM",8)
	while cId'=""{
		s:eId="" eId="x"
		while eId'=""{
			s:sId="" sId="x"
			while sId'=""{
				s:iId="" iId="x"
				while iId'=""{
					s iId=$o(^DHCMRC("CPW",cId,"EP",eId,"STEP",sId,"ITEM",iId),-1)
					q:iId=""
					s tmpId=cId_"||"_eId_"||"_sId_"||"_iId
					s objTmpItem=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(tmpId)
					continue:+objTmpItem.CPWSISubCategory.%Id()'=2   //非重点医嘱
					continue:objTmpItem.CPWSIDesc'=itemDesc          //名称不匹配
					continue:objTmpItem.CPWSIARCIM.Count()=0         //无关联医嘱
					s objStepItem.CPWSIARCIM=objTmpItem.CPWSIARCIM
					d objStepItem.%Save()
					//w !,objTmpItem.CPWSISubCategory.SISCDesc,objTmpItem.CPWSIDesc
					//w:objTmpItem.CPWSIARCIM.Count()>0 !,objTmpItem.CPWSIARCIM.Count()_"-"_tmpId
					s objTmpItem=""
					s flag=1
					q
					//w !,tmpId
				}
				q:flag=1
				s sId=$o(^DHCMRC("CPW",cId,"EP",eId,"STEP",sId),-1)
			}
			q:flag=1
			s eId=$o(^DHCMRC("CPW",cId,"EP",eId),-1)
		}
		q:flag=1
		s cId=$o(^DHCMRC("CPW",cId),-1)
	}
	
	quit
}

/// Creator：     wuqk
/// CreatDate：   2011-11-01
/// Description:  导出路径
/// Table：       
/// Input：       CPWID:     临床路径版本Id User.DHCMRCClinPathWays 
/// d ##class(web.DHCCPW.MRC.ImportPathWay).ExportCW(15,"")
ClassMethod ExportCW(CPWID, ExportFn)
{
	n (CPWID,ExportFn)
	s objVer=##class(User.DHCMRCClinPathWays).%OpenId(CPWID)
	quit:'$IsObject(objVer) ""
	
	//Head
	s cpwDicId=objVer.CPWCPWDicDR.%Id()
	s objDic=##class(User.DHCMRCClinPathWaysDic).%OpenId(cpwDicId)
	s Head="路径名称"_$c(1)_objDic.CPWDDesc
	s Head=Head_$c(2)_"路径类型"_$c(1)_objDic.CPWDCPWTypeDR.CLPTDesc
	s Head=Head_$c(2)_"准入ICD"_$c(1)_objVer.CPWICD
	s Head=Head_$c(2)_"准入提示"_$c(1)_objVer.CPWLabel
	s Head=Head_$c(2)_"参考费用"_$c(1)_objVer.CPWCost
	s Head=Head_$c(2)_"参考天数"_$c(1)_objVer.CPWDays_"天"
	s Head=Head_$c(2)_"阶段"_$c(1)_"步骤"_$c(1)_"项目"_$c(1)_"项目类型"_$c(1)_"医嘱"_$c(1)_"医嘱类型"_$c(1)_"剂量"_$c(1)_"数量"_$c(1)_"用法"_$c(1)_"频次"_$c(1)_"备注"
	s Head=$tr(Head,$c(10),"")             //add by wuqk 2011-11-30
	s Head=$tr(Head,$c(13),"")
	s retval=ExportFn_"(xlSheet,'"_Head_"',1,1);"
	&javascript<#(retval)#>
	/*
	路径名称			反流食管炎20111025			
	路径类型			心内科			
	准入ICD			K21.0			
	准入提示			第一诊断为反流食管炎（ICD-10：K21.0）			
	参考费用			5000-8000			
	参考天数			5-7天	
	*/
	/*
	s iId=$o(^DHCMRC("CPW",CPWID,"EP",eId,"STEP",sId,"ITEM",iId),-1)
	s sId=$o(^DHCMRC("CPW",CPWID,"EP",eId,"STEP",sId),-1)
	s eId=$o(^DHCMRC("CPW",CPWID,"EP",eId),-1)*/
	Set iRow=8
	If $o(^DHCMRCi("CPW",0,"EP","IndexEpisode",CPWID,""))="" {
		Set eId=$o(^DHCMRC("CPW",CPWID,"EP",0))
		While eId'=""{
			Do ExportEpisodeInfo
			Set eId=$o(^DHCMRC("CPW",CPWID,"EP",eId))
		}
	} Else {
		Set xEpisode=""
		For {
			Set xEpisode=$o(^DHCMRCi("CPW",0,"EP","IndexEpisode",CPWID,xEpisode))
			Quit:xEpisode=""
			Set eId=0
			For {
				Set eId=$o(^DHCMRCi("CPW",0,"EP","IndexEpisode",CPWID,xEpisode,eId))
				Quit:eId=""
				Do ExportEpisodeInfo
			}
		}
	}
	
	quit ""
	
ExportEpisodeInfo
	s objEpisode=##class(User.DHCMRCClinPathWaysEp).%OpenId(CPWID_"||"_eId)
	if $IsObject(objEpisode){
		s Episode=objEpisode.EPDesc
		s retval=ExportFn_"(xlSheet,'"_Episode_"',"_iRow_",1);"
		&javascript<#(retval)#>
		s iRow=iRow+1
	}

	s sId=$o(^DHCMRC("CPW",CPWID,"EP",eId,"STEP",0))
	while sId'=""{
		s objStep=##class(User.DHCMRCClinPathWaysEpStep).%OpenId(CPWID_"||"_eId_"||"_sId)
		if $IsObject(objStep){
			s Step=objStep.CPWSDesc_$c(1)_objStep.CPWSDay_objStep.CPWSUnit //_$c(1)_objStep
			s retval=ExportFn_"(xlSheet,'"_Step_"',"_iRow_",2);"
			&javascript<#(retval)#>
			s iRow=iRow+1
		}
	
		s iId=$o(^DHCMRC("CPW",CPWID,"EP",eId,"STEP",sId,"ITEM",0))
		while iId'=""{ 
			s objItem=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(CPWID_"||"_eId_"||"_sId_"||"_iId)
			if $IsObject(objItem){
				s Item=objItem.CPWSIDesc_$c(1)_objItem.CPWSISubCategory.SISCDesc
				s retval=ExportFn_"(xlSheet,'"_Item_"',"_iRow_",3);"
				&javascript<#(retval)#>
				s iRow=iRow+1
			}
			
			s Arcim=""
			For indGene=1:1:objItem.ChildItmGene.Count() {
				Set objGene=objItem.ChildItmGene.GetAt(indGene)
				Continue:'$IsObject(objGene)
				
				For indArc=1:1:objGene.IGArcimList.Count() {
					Set objARCIM=objGene.IGArcimList.GetAt(indArc)
					Continue:'$IsObject(objARCIM)
					Set ItmNo=objGene.IGNo
					Set ItmLinkNo=objGene.IGLinkNo
					
					Set ItmARCIMDR=objARCIM.ITMARCIMDR
					If $l(ItmARCIMDR,"||")=2 {  //医嘱项
						Set ARCIMDesc=$p($g(^ARCIM(+$p(ItmARCIMDR,"||",1),+$p(ItmARCIMDR,"||",2),1)),"^",2)
						Set:ARCIMDesc="" ItmARCIMDR=""
					} Else {    //医嘱套
						Set ARCIMDesc=$p($g(^ARCOS(+ItmARCIMDR)),"^",2)
						Set:ARCIMDesc="" ItmARCIMDR=""
						Set:ARCIMDesc'="" ARCIMDesc="[套]"_ARCIMDesc
					}
					Set ItmDoseQty=objARCIM.ITMDoseQty
					Set ItmUOMDR=objARCIM.ITMUOMDR
					If ItmUOMDR'="" {
						Set UomDesc=$p($g(^CT("UOM",ItmUOMDR)),"^",2)
					}Else{
						Set ItmUOMDR="",UomDesc=""
					}
					
					Set ItmDuratDR=objARCIM.ITMDuratDR
					If ItmDuratDR'="" {
						Set DuratDesc=$p($g(^PHCDU(ItmDuratDR)),"^",3)
					}Else{
						Set ItmDuratDR="",DuratDesc=""
					}
				
					Set ItmFreqDR=objARCIM.ITMFreqDR
					If ItmFreqDR'="" {
						Set FreqDesc=$p($g(^PHCFR(ItmFreqDR)),"^",3)
					}Else{
						Set ItmFreqDR="",FreqDesc=""
					}
				
					Set ItmInstrucDR=objARCIM.ITMInstrucDR
					If ItmInstrucDR'="" {
						Set InstrucDesc=$p($g(^PHCIN(ItmInstrucDR)),"^",2)
					}Else{
						Set ItmInstrucDR="",InstrucDesc=""
					}
					
					Set ItmQty=objARCIM.ITMQty
					Set ItmDefault=objARCIM.ITMDefault
					Set ItmDefault=$s(ItmDefault["Y":"Yes",1:"No")
					
					Set ItmPriorityRoiwd=objARCIM.ITMPriority
					Set ItmPriority=$p($g(^OECPR(+ItmPriorityRoiwd)),"^",2)
					Set ItmIsMain=objARCIM.ITMIsMain
					Set ItmIsMain=$s(ItmIsMain["Y":"Yes",1:"No")
					Set ItmGroupNo=objARCIM.ITMGroupNo
					Set ItmResume=objARCIM.ITMResume
					
					//Set Data=$lb(RowID,ItmNo,ItmLinkNo,ItmARCIMDR,ARCIMDesc,ItmDoseQty,ItmUOMDR,UomDesc,ItmDuratDR,DuratDesc,ItmFreqDR,FreqDesc,ItmInstrucDR,InstrucDesc,ItmQty,ItmDefault,ItmPriorityRoiwd,ItmPriority,ItmIsMain,ItmGroupNo,ItmResume)
	 				//s arcim=ARCIMDesc_$c(1)_ItmPriority_$c(1)_ItmDoseQty_$c(1)_ItmUOMDR_UomDesc_$c(1)_ItmQty_$c(1)_ItmResume //_$c(1)_objStep
	 				s arcim=ARCIMDesc_$c(1)_ItmPriority_$c(1)_ItmDoseQty_UomDesc_$c(1)_ItmQty_$c(1)_InstrucDesc_$c(1)_FreqDesc_$c(1)_ItmResume
					s arcim=..EscapeCharacter(arcim,"'")
					s:arcim[$c(13,10) arcim=$tr(arcim,$c(13,10),"")
					s retval=ExportFn_"(xlSheet,'"_arcim_"',"_iRow_",5);"
					&javascript<#(retval)#>
					s iRow=iRow+1
				}
			}
			s iId=$o(^DHCMRC("CPW",CPWID,"EP",eId,"STEP",sId,"ITEM",iId))
		}
	
		s sId=$o(^DHCMRC("CPW",CPWID,"EP",eId,"STEP",sId))
	}
	quit
}

/// w ##class(web.DHCCPW.MRC.ImportPathWay).EscapeCharacter("aaaaa'bbbb","'")
ClassMethod EscapeCharacter(aInputStr As %String, aChar As %String) As %String
{
	New (aInputStr,aChar)
	Set return=""
	
	For ind=1:1:$l(aInputStr,aChar) {
		Set tmp=$p(aInputStr,aChar,ind)
		Set return=return_"\"_aChar_tmp
	}
	Set:return'="" return=$e(return,$l(aChar)+2,$l(return))
	
	Quit return
}

/// w ##class(web.DHCCPW.MRC.ImportPathWay).ChangeICD10()
ClassMethod ChangeICD10()
{
	New 
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		Set Info=$g(^DHCMRC("CPW",CPWID))
		Set CPWICD10=$listget(Info,10)
		Continue:CPWICD10=""
		Set CPWICD10=$tr(CPWICD10,"：",":")
		Set CPWICD10=$tr(CPWICD10,"(","")
		Set CPWICD10=$tr(CPWICD10,")","")
		Set CPWICD10=$zcvt(CPWICD10,"U")
		w CPWICD10_"-----"
		Set:CPWICD10["ICD10:" CPWICD10=$p(CPWICD10,"ICD10:",2)
		Set:CPWICD10["ICD-10:" CPWICD10=$p(CPWICD10,"ICD-10:",2)
		w CPWICD10,!
		Set $list(Info,10)=CPWICD10
		Set ^DHCMRC("CPW",CPWID)=Info
	}
	Quit "Over!"
}

/// w ##class(web.DHCCPW.MRC.ImportPathWay).ChangeEvaluateList()
ClassMethod ChangeEvaluateList()
{
	New 
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		Set Info=$g(^DHCMRC("CPW",CPWID))
		Set $list(Info,20)=$LB("","5||1:1","5||2:1","5||3:1","5||4:1","5||6:1","5||7:0")
		Set ^DHCMRC("CPW",CPWID)=Info
	}
	Quit "Over!"
}

}
