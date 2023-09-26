/// 名称: DHCMA.CPW.KBS.ImportPathWay
/// 描述: 临床路径表单导入知识库程序
/// 编写者：zqy
/// 编写日期: 2022-05-19
Class DHCMA.CPW.KBS.ImportPathWay Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCMA.CPW.KBS.ImportPathWay).SaveTempFormNew()
ClassMethod SaveTempFormNew(argCode As %String, argRowInfo As %String, aHospID As %String = "") As %String
{
	New (argCode,argRowInfo,aHospID)
	Set return=0
	
	/*
	If $g(^DHCMAKBFD("Form",argCode,"FLG","Row"))=15{
		Set ^TEMPzqr=$lb(argCode,argRowInfo,aHospID)	
	}*/
	
	Set $ZT="SaveTempFormNewErr"
	If argCode["^"{
		Set Year=+$p(argCode,"^",1)
		Set Num=$p(argCode,"^",2)
		Set Num=$s(Num'[".":Num_"00",1:$tr(Num,".","0"))
		Set argCode=Year_$e("000000",1,6-$l(Num))_Num
		Kill ^DHCMAKBFD("Form",argCode)	
	}
	
	Set argRowInfo=$tr(argRowInfo,$c(0),"")
	Set argRowInfo=$tr(argRowInfo,$c(1),"")
	Set argRowInfo=$tr(argRowInfo,$c(13),"")
	Set argRowInfo=$tr(argRowInfo,"^","")
	Set argRowInfo=$tr(argRowInfo,"?","")
	Set argRowInfo=$tr(argRowInfo," ","")
	
	Set return=-1
	Set Row=$i(^DHCMAKBFD("Form",argCode,"FLG","Row"))			//行计数器
	Set:'$d(^DHCMAKBFD("Form",argCode,"Error","Info")) ^DHCMAKBFD("Form",argCode,"Error","Info")=""		//记录表单错误信息
	
	Set ItemName=$p(argRowInfo,$c(9),1)
	Set ItemValue=$p(argRowInfo,$c(9),2)
	If ItemName="路径名称"
	{   
		Set ItemValue=$tr(ItemValue,$c(10),"")
		Set ItemValue=$tr(ItemValue,"（","(")
		Set ItemValue=$tr(ItemValue,"）",")")
		Set ItemValue=$tr(ItemValue,"临床路径","")
		Set ItemValue=$tr(ItemValue,"表单","")
		
		Set CPWDicID=##class(DHCMA.CPW.KB.PathBase).CheckPTCode(argCode)					//根据代码检查是否已存在，存在返回路径主表ID
		Set ^DHCMAKBFD("Form",argCode,"Item1","Name")=ItemValue
		Set ^DHCMAKBFD("Form",argCode,"Item1","CPWDicID")=$s(CPWDicID>0:CPWDicID,1:"")		
	}ElseIf ItemName="就诊类型"{
		Set ItemValue=$s(ItemValue["门诊":"O",ItemValue["住院":"I",1:"I")
		If ItemValue'=""{
			Set ^DHCMAKBFD("Form",argCode,"Item1","ADM")=ItemValue
		}
		
	} ElseIf ItemName="路径类型" {          												//数据格式：对应路径类型字典描述
	
		Set ^DHCMAKBFD("Form",argCode,"Item1","Type")=ItemValue
		Set ^DHCMAKBFD("Form",argCode,"Item1","TypeID",ItemValue)=..GetCPWTypeID(ItemValue,aHospID)
		
	}ElseIf ItemName="发布年份" {    														//数据格式：描述	add 2022
		Set ^DHCMAKBFD("Form",argCode,"Item1","Year")=ItemValue
	}ElseIf ItemName="发布类型" {    														//数据格式：描述	add 2022
		Set ItemValue=$s(ItemValue="常规版":"G",ItemValue="县医院版":"C",1:"")
		If ItemValue'=""{
			Set ^DHCMAKBFD("Form",argCode,"Item1","GC")=ItemValue
		}
	}
	ElseIf (ItemName="适用对象")||(ItemName="准入提示") {    								//数据格式：描述	add 2022
		Set ^DHCMAKBFD("Form",argCode,"Item1","ApplyObj")=ItemValue
	}ElseIf ItemName="准入诊断ICD10" {     													//数据格式：C00-D48,D49.001,D49.002
		If ItemValue'=""{
			Set ItemValue=$tr(ItemValue," ","")	
			Set ItemValue=$tr(ItemValue,"，",",")
			Set ItemValue=$tr(ItemValue,"、",",")
		}
		Set ^DHCMAKBFD("Form",argCode,"Item1","ICD10")=ItemValue
	} ElseIf ItemName="准入诊断关键字" {    												//数据格式：多值英文逗号分割
		Set ^DHCMAKBFD("Form",argCode,"Item1","ICDKey")=ItemValue
	} ElseIf ItemName="准入手术CM3" {      													//数据格式：36.5-36.7,38.0
		If ItemValue'=""{
			Set ItemValue=$tr(ItemValue," ","")	
			Set ItemValue=$tr(ItemValue,"，",",")
			Set ItemValue=$tr(ItemValue,"、",",")
			Set ItemValue=$tr(ItemValue,"/",",")
		}
		Set ^DHCMAKBFD("Form",argCode,"Item1","OperCM3")=ItemValue
	} ElseIf ItemName="准入手术关键字" {    												//数据格式：多值英文逗号分割
		Set ^DHCMAKBFD("Form",argCode,"Item1","OperKey")=ItemValue
	} ElseIf ItemName="参考费用" {          												//数据格式：2000-3000
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
		Set ^DHCMAKBFD("Form",argCode,"Item1","Cost")=ItemValue
	} ElseIf ItemName="参考天数" {
		Set TimeUnit=""    														//数据格式：5-7
		If ItemValue'=""
		{
			Set ItemValue=$tr(ItemValue,$c(10),"")
			Set ItemValue=$tr(ItemValue," ","")
			Set ItemValue=$tr(ItemValue,"~","-")
			Set ItemValue=$tr(ItemValue,"/","-")
			Set ItemValue=$tr(ItemValue,"\","-")
			Set ItemValue=$tr(ItemValue,"|","-")
			Set TimeUnit=$s(ItemValue["次":"T",ItemValue["周":"W",ItemValue["月":"MTH",1:"D")
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
		Set ^DHCMAKBFD("Form",argCode,"Item1","Days")=ItemValue_"^"_TimeUnit
	}ElseIf ItemName="进入路径标准" {    														//数据格式：描述 add 2022
		Set ^DHCMAKBFD("Form",argCode,"Item1","PathStandard")=ItemValue
	}ElseIf ItemName="变异分析描述" {															//add 适用描述
		Set ^DHCMAKBFD("Form",argCode,"Item1","VarDesc")=ItemValue
	} ElseIf (ItemName="阶段")||(ItemName="步骤") {
		Set argRowInfo=$tr(argRowInfo,$c(10),"")
		Set argRowInfo=$tr(argRowInfo,$c(13),"")
		Set argRowInfo=$tr(argRowInfo," ","")
		
		Set EpDesc=""
	    For ind=2:1:$l(argRowInfo,$c(9)){
			Set EpDesc=$p(argRowInfo,$c(9),ind)
			If EpDesc'="" {
				Set EpDesc=$tr(EpDesc,"～","-")
				Set EpDesc=$tr(EpDesc,"－","-")
				Set EpDesc=$tr(EpDesc,"~","-")
				Set EpDesc=$tr(EpDesc,"/","-")
				
				Set EpInd=$i(^DHCMAKBFD("Form",argCode,"FLG","CurrEpInd"))						//阶段序号或个数
				Set ^DHCMAKBFD("Form",argCode,"Item1","EpDesc",ind)=EpInd_"^"_EpDesc
			}
		}
	}ElseIf (ItemName="天数") {
		/*
		If (argRowInfo["时")||(argRowInfo["分"){
			Set ^DHCMAKBFD("Form",argCode,"Error","Info")=$g(^DHCMAKBFD("Form",argCode,"Error","Info"))_$lb("阶段天数小于1天，请检查！") 	
		}
		If (argRowInfo["-"){
			Set ^DHCMAKBFD("Form",argCode,"Error","Info")=$g(^DHCMAKBFD("Form",argCode,"Error","Info"))_$lb("阶段天数不是固定数值，请检查！") 	
		}
		*/
		Set argRowInfo=$tr(argRowInfo," ","")
		Set EpStepDay=""
	    For ind=2:1:$l(argRowInfo,$c(9)){
		    Set EpStepDay=$p(argRowInfo,$c(9),ind)
		    Set EpCount=$g(^DHCMAKBFD("Form",argCode,"FLG","CurrEpInd"))
		    /*
		    If (+EpStepDay=0)&&(ind<(EpCount+1)){
				Set ^DHCMAKBFD("Form",argCode,"Error","Info")=$g(^DHCMAKBFD("Form",argCode,"Error","Info"))_$lb("第"_ind-1_"阶段天数无效，请检查！") 	
			}
			*/
			/*
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
			Set EpStepDay=$s(EpStepDay1=EpStepDay2:EpStepDay1,1:EpStepDay1_"-"_EpStepDay2)
			*/
			//此天数Global未使用（较多表单天数有问题），导入后通过程序对阶段天数单独处理
			If (EpStepDay'="") {
		    	Set ^DHCMAKBFD("Form",argCode,"Item1","EpStepDay",ind)=EpStepDay
			}
		}
	}ElseIf (ItemName="主要诊疗工作") {
	    Set argRowInfo=$tr(argRowInfo," ","")  
	    Set ZYZLDescList=""
	    For ind=2:1:$l(argRowInfo,$c(9)){
			Set ZYZLDescList=$p(argRowInfo,$c(9),ind)
			If (ZYZLDescList'=""){
				Set ^DHCMAKBFD("Form",argCode,"Item1","ZYZLDescList",ind)=ZYZLDescList
			}
		}
	}ElseIf (ItemName="重点医嘱") {
		Set argRowInfo=$tr(argRowInfo," ","")
	    Set ZDYZDescList=""
	    For ind=2:1:$l(argRowInfo,$c(9)){
			Set ZDYZDescList=$p(argRowInfo,$c(9),ind)
			If (ZDYZDescList'=""){
				Set ^DHCMAKBFD("Form",argCode,"Item1","ZDYZDescList",ind)=ZDYZDescList
			}
		}
	}ElseIf (ItemName="主要护理工作") {
		Set argRowInfo=$tr(argRowInfo," ","")
	    Set ZYHLDescList=""
	    For ind=2:1:$l(argRowInfo,$c(9)){
			Set ZYHLDescList=$p(argRowInfo,$c(9),ind)
			If (ZYHLDescList'=""){	
				Set ^DHCMAKBFD("Form",argCode,"Item1","ZYHLDescList",ind)=ZYHLDescList
			}
		}
	}ElseIf (+ItemName>0) {
		Set argRowInfo=$tr(argRowInfo," ","")
		Set EpIndx=$p(argRowInfo,$c(9),1)															//阶段序号
	    Set ItemDesc=$p(argRowInfo,$c(9),2)															//诊疗项目
	    Set tmpClinItem=$g(^DHCMAKBFD("Form",argCode,"Item1","ZYZLDescList",EpIndx+1))
	    
	    If tmpClinItem'[ItemDesc{
			Set ^DHCMAKBFD("Form",argCode,"Error","Info")=$g(^DHCMAKBFD("Form",argCode,"Error","Info"))_$lb("表三中第"_EpIndx_"阶段项目在表二中对应阶段无法找到，请检查！")    
		}
		Set ItemDesc=$tr(ItemDesc,"【】","")
		Set ItemDesc=$tr(ItemDesc,"【*】","")

	    Set Code=$p(argRowInfo,$c(9),3)
	    if ($d(^DHCMAKBFD("Form",argCode,"Item1","ZYZL",ItemDesc))){
		    Set EmrCode=$g(^DHCMAKBFD("Form",argCode,"Item1","ZYZL",ItemDesc))
		    Set ^DHCMAKBFD("Form",argCode,"Item1","ZYZL",ItemDesc)=..RemovalEmr(EmrCode,Code)
		}else{
	    	Set ^DHCMAKBFD("Form",argCode,"Item1","ZYZL",ItemDesc)=Code
		}
	}
	
	Set index=""
	For {
		Set index=$o(^DHCMAKBFD("Form",argCode,"Item1","EpDesc",index))
		Quit:index=""
		
		Set EpDescList=$g(^DHCMAKBFD("Form",argCode,"Item1","EpDesc",index))
		Set EpStepIndNo=$p(EpDescList,"^",1)														//阶段序号
		Set EpStepDesc=$p(EpDescList,"^",2)															//阶段描述
		Set EpStepDayList=$g(^DHCMAKBFD("Form",argCode,"Item1","EpStepDay",index))					//阶段天数
	
		If $g(^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc))="" {
			Set ^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc)=EpStepDayList
		}
		
		Set return=-2
		If (ItemName="主要诊疗工作"){
			Set ItemType1="1^主要诊疗工作"
			Set ItemTypeSub1=""
			Set ZYZLDescList=$g(^DHCMAKBFD("Form",argCode,"Item1","ZYZLDescList",index))
			Set Separete=$S($l(ZYZLDescList,$c(10))>1:$c(10),1:"&#10;")
			For indx=1:1:$l(ZYZLDescList,Separete) {
				Set ZYZLDesc=$p(ZYZLDescList,Separete,indx)
				Continue:ZYZLDesc=""
				
				If ($f(ZYZLDesc,"【】")<1)&&($f(ZYZLDesc,"【*】")<1) {
					Set ^DHCMAKBFD("Form",argCode,"Error","Info")=$g(^DHCMAKBFD("Form",argCode,"Error","Info"))_$lb("表2存在诊疗工作无效分类，请检查！")
				}Else {
					Set ItemTypeSub1="主要诊疗工作"
					Set ZYZLDesc=$tr(ZYZLDesc,"【】","")
					
					Set ItemIndx=$i(^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType1))
		            If $g(^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType1,ItemIndx))="" {
						Set ^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType1,ItemIndx)=ItemTypeSub1_"^"_ZYZLDesc
		            }
				}
			}
		}ElseIf (ItemName="重点医嘱") {
			Set ItemType2="2^重点医嘱"
			Set ZDYZDescList=$g(^DHCMAKBFD("Form",argCode,"Item1","ZDYZDescList",index))
			Set Separete=$S($l(ZDYZDescList,$c(10))>1:$c(10),1:"&#10;")
			Set ItemTypeSub2=""
			For indy=1:1:$l(ZDYZDescList,$c(10)){
				Set ZDYZDesc=$p(ZDYZDescList,$c(10),indy)
				Continue:ZDYZDesc=""
				If ($f(ZDYZDesc,"【】")<1)&&($f(ZDYZDesc,"【*】")<1) {
					Set ZDYZDesc=$tr(ZDYZDesc,":","")
					Set ZDYZDesc=$tr(ZDYZDesc,"：","")
					Set ItemTypeSub2=ZDYZDesc		
				}Else {
					Set:ItemTypeSub2="" ItemTypeSub2="其他医嘱"
					Set ZDYZDesc=$tr(ZDYZDesc,"【】","")
					
					Set ItemIndy=$i(^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType2))
					If $g(^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType2,ItemIndy))="" {
						Set ^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType2,ItemIndy)=ItemTypeSub2_"^"_ZDYZDesc
					}
				}
			}
		}ElseIf (ItemName="主要护理工作") {
		    Set ItemType3="3^主要护理工作"
		    Set ItemTypeSub3=""
		    Set ZYHLDescList=$g(^DHCMAKBFD("Form",argCode,"Item1","ZYHLDescList",index))
		    Set Separete=$S($l(ZYHLDescList,$c(10))>1:$c(10),1:"&#10;")
			For indz=1:1:$l(ZYHLDescList,Separete) {
				Set ZYHLDesc=$p(ZYHLDescList,Separete,indz)
				Continue:ZYHLDesc=""
				If ($f(ZYHLDesc,"【】")<1)&&($f(ZYHLDesc,"【*】")<1) {
					Set ^DHCMAKBFD("Form",argCode,"Error","Info")=$g(^DHCMAKBFD("Form",argCode,"Error","Info"))_$lb("表2存在护理工作无效分类，请检查！")
				}Else {
					Set ItemTypeSub3="主要护理工作"
					Set ZYHLDesc=$tr(ZYHLDesc,"【】","")
					
					Set ItemIndz=$i(^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType3))
					If $g(^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType3,ItemIndz))=""{
						Set ^DHCMAKBFD("Form",argCode,"Item2",EpDescList,EpStepDesc,ItemType3,ItemIndz)=ItemTypeSub3_"^"_ZYHLDesc
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

/// w ##Class(DHCMA.CPW.KBS.ImportPathWay).GetCPWTypeID("呼吸内科")
ClassMethod GetCPWTypeID(argCPWType As %String, aHospID As %String = "") As %String
{
	New (argCPWType,aHospID)
	Set return=""
	Quit:argCPWType="" return
	
	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
	Set CLPTID=0
	For {
		Set CLPTID=$o(^DHCMA.CPW.BT.PathTypeD(CLPTID))
		Quit:CLPTID=""
		Quit:return'=""
		Set obj = ##class(DHCMA.CPW.BT.PathType).GetObjById(CLPTID)
		Quit:'$Isobject(obj)
		If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.PathType",CLPTID,aHospID)
		 	Continue:retFlg'="Y"
		}
		Set CLPTDesc=obj.BTDesc
		Set:CLPTDesc=argCPWType return=CLPTID
	}
	
	Quit return
}

/// 检查临床表单数据的合法性
/// w ##class(DHCMA.CPW.KBS.ImportPathwayNew).checkFromDataRightful()
ClassMethod checkFromDataRightful(argCode As %String, argHospID As %String = "") As %String
{
	New (argCode,argHospID)
	Set return=""
	Set Name=$g(^DHCMAKBFD("Form",argCode,"Item1","Name"))
	Set:Name="" return=return_"路径名称为空;<br>"
	Set Year=$g(^DHCMAKBFD("Form",argCode,"Item1","Year"))
	Set:Year="" return=return_"发布年份为空;<br>"
	Set GC=$g(^DHCMAKBFD("Form",argCode,"Item1","GC"))
	Set:GC="" return=return_"发布类型赋值有误;<br>"
	Set CPWDicID=$g(^DHCMAKBFD("Form",argCode,"Item1","CPWDicID"))
	//Set:CPWDicID'="" return=return_"已存在同名代码;<br>"
	Set Type=$g(^DHCMAKBFD("Form",argCode,"Item1","Type"))
	If Type=""
	{
		Set return=return_"路径类型为空;<br>"
	} Else {
		If $g(^DHCMAKBFD("Form",argCode,"Item1","TypeID",Type))=""
		{
			Set return=return_"路径类型 "_Type_" 字典对照错误;<br>"
		}
	}
	
	Set ICD10=$g(^DHCMAKBFD("Form",argCode,"Item1","ICD10"))
	//Set:ICD10="" return=return_"准入诊断ICD10为空;<br>"
	If (ICD10[":")||($ZCVT(ICD10,"U")["ICD")
	{
		Set return=return_"准入诊断ICD10格式错误;<br>"
	}
	Set ICDKey=$g(^DHCMAKBFD("Form",argCode,"Item1","ICDKey"))
	//Set:ICDKey="" return=return_"准入诊断关键字为空;<br>"
	
	Set ApplyObj=$g(^DHCMAKBFD("Form",argCode,"Item1","ApplyObj"))
	Set:ApplyObj="" return=return_"适用对象为空;<br>"
	Set OperCM3=$g(^DHCMAKBFD("Form",argCode,"Item1","OperCM3"))
	//Set:OperCM3="" return=return_"准入手术CM3为空;<br>"
	If (OperCM3[":")||($ZCVT(OperCM3,"U")["ICD")||($ZCVT(OperCM3,"U")["CM")
	{
		Set return=return_"准入手术CM3格式错误;<br>"
	}
	Set Cost=$g(^DHCMAKBFD("Form",argCode,"Item1","Cost"))
	//Set:Cost="" return=return_"参考费用为空;<br>"
	Set Days=+$g(^DHCMAKBFD("Form",argCode,"Item1","Days"))
	//Set:Days=0 return=return_"参考天数为0;<br>"
	Set PathStandard=$g(^DHCMAKBFD("Form",argCode,"Item1","PathStandard"))
	//Set:PathStandard="" return=return_"进入路径标准为空;<br>"
	Set VarDesc=$g(^DHCMAKBFD("Form",argCode,"Item1","VarDesc"))
	//Set:VarDesc="" return=return_"变异分析描述为空;<br>"	
	Set DataRow=+$g(^DHCMAKBFD("Form",argCode,"FLG","Row"))
	Set:DataRow=0 return=return_"表单格式错误;<br>"
	
	Set ErrList=$g(^DHCMAKBFD("Form",argCode,"Error","Info"))
	If ErrList'=""{
		For index=1:1:$ll(ErrList){
			Set return=return_$li(ErrList,index)_"<br>"
		}
	}
	
	Set:return'="" return=return_"<b>请修改数据后,再重新导入!</b>"
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-11-01
/// Description:  取临时表单列表
/// Input：       
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.KBS.ImportPathWay","QryTempFormData")
Query QryTempFormData(argHospID As %String = "") As %Query(ROWSPEC = "Code:%String,Desc:%String,RowCount:%String,Reminder:%String")
{
}

ClassMethod QryTempFormDataExecute(ByRef qHandle As %Binary, argHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set Code=""
	For {
		Set Code=$o(^DHCMAKBFD("Form",Code))
		Quit:Code=""
		Continue:$l(Code)<8
		
		Set Desc=$g(^DHCMAKBFD("Form",Code,"Item1","Name"))
		Set RowCount=+$g(^DHCMAKBFD("Form",Code,"FLG","Row"))
		Set Reminder=..checkFromDataRightful(Code,argHospID)
		
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
/// w ##class(DHCMA.CPW.KBS.ImportPathWay).DeleteTempForm(argCode)
ClassMethod DeleteTempForm(argCode)
{
	New (argCode)
	Set return=-1
	
	Set $ZT="DeleteTempFormErr"
	
	If $d(^DHCMAKBFD("Form",argCode)) {
		Kill ^DHCMAKBFD("Form",argCode)
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
/// Return：      return>0 导数据正确
/// w ##class(DHCMA.CPW.KBS.ImportPathWay).SaveForm("2009099600",2)
ClassMethod SaveForm(argCode As %String, argHospID As %String = "") As %String
{
	New (argCode,argHospID)
	Set return=0
	Quit:argCode="" return
	
	//Set ^TEMPYK("SaveForm")=$LB($J,argCode,argHospID)
	
	//判断数据合法性
	Set flg=..checkFromDataRightful(argCode,argHospID)
	Quit:flg'="" -1
	
	//取路径字典数据                                             		//路径代码
	Set CPWDicID=$g(^DHCMAKBFD("Form",argCode,"Item1","CPWDicID"))    	//路径ID
	Set Year=$g(^DHCMAKBFD("Form",argCode,"Item1","Year"))     			//发布年份
	Set GC=$g(^DHCMAKBFD("Form",argCode,"Item1","GC"))     				//发布类型
	Set Name=$g(^DHCMAKBFD("Form",argCode,"Item1","Name"))             	//路径名称
	Set Type=$g(^DHCMAKBFD("Form",argCode,"Item1","Type"))             	//路径类型描述
	Set ApplyObj=$g(^DHCMAKBFD("Form",argCode,"Item1","ApplyObj"))		//适用对象	add 2022
	Set ICD10=$g(^DHCMAKBFD("Form",argCode,"Item1","ICD10"))           	//准入诊断ICD10
	Set ICDKey=$g(^DHCMAKBFD("Form",argCode,"Item1","ICDKey"))         	//准入诊断关键字
	Set OperCM3=$g(^DHCMAKBFD("Form",argCode,"Item1","OperCM3"))       	//准入手术CM3
	Set OperKey=$g(^DHCMAKBFD("Form",argCode,"Item1","OperKey"))       	//准入手术关键字
	Set Days=$g(^DHCMAKBFD("Form",argCode,"Item1","Days"))          		//参考天数
	Set Time=$p(Days,"^",1)
	Set TimeUnit=$p(Days,"^",2)
	Set Cost=$g(^DHCMAKBFD("Form",argCode,"Item1","Cost"))          		//参考费用
	Set PathStandard=$g(^DHCMAKBFD("Form",argCode,"Item1","PathStandard")) //进入路径标准	add 2022
	Set VarDesc=$g(^DHCMAKBFD("Form",argCode,"Item1","VarDesc"))    		//变异分析描述->适用描述
	If $d(^DHCMAKBFD("Form",argCode,"Item1","ADM")){					//门诊/住院
		Set AdmType=$g(^DHCMAKBFD("Form",argCode,"Item1","ADM"))
	}Else{
		Set AdmType="I"	
	} 
	
	Set $ZT="SaveFormErr"
	TStart
	
	//将诊疗及EMRCode存表
	Set xDesc=""
	For{
		Set xDesc=$o(^DHCMAKBFD("Form",argCode,"Item1","ZYZL",xDesc))
		Quit:xDesc=""
		//w xDesc_"|"_$l(xDesc),!
		Set xCode=$g(^DHCMAKBFD("Form",argCode,"Item1","ZYZL",xDesc))
		Set ItemDesc=..CleanSpecialChar(xDesc)									//字符处理,处理后的变量赋值新变量，否则死循环
		Set Alias=##class(ext.util.String).ToChineseSpell($$ALPHAUP^SSUTIL4(ItemDesc))
		Set ret=..CheckByDesc(ItemDesc,1)
		if (ret>0){
			Set CIObj=##Class(DHCMA.CPW.KB.ClinItemBase).GetObjById(ret)
			Continue:'$IsObject(CIObj)
			Set EMRCode=CIObj.CIEMRCode
			Set xCode=..RemovalEmr(EMRCode,xCode)
			Set InputStr=ret_"^"_ItemDesc_"^"_Alias_"^"_xCode_"^"_""_"^"_""_"^"_"1"_"^"_""_"^"_""_"^"_""
		}else{
			Set InputStr=""_"^"_ItemDesc_"^"_Alias_"^"_xCode_"^"_""_"^"_""_"^"_"1"_"^"_""_"^"_""_"^"_""
		}
		Set xflg=##Class(DHCMA.CPW.KB.ClinItemBase).Update(InputStr)
		If +xflg<0 {
			TRollBack
			Set return=-3
			Quit
		}
	}
	Quit:+return<0 return
	
	//更新路径字典及路径主表信息
	Set IsOper=0
	Set:((OperCM3'="")||(OperKey'="")) IsOper=1
	If CPWDicID'="" {											//覆盖原来表单
		;b ;00
		Set objKBCPW=##Class(DHCMA.CPW.KB.PathBase).GetObjById(CPWDicID)
		If $IsObject(objKBCPW) {
			Set InputStr=CPWDicID_"^"_argCode_"^"_Name_"^"_Type_"^"_""_"^"_IsOper_"^1^"_GC_"^"_Year_"^"_ICD10_"^^"_OperCM3_"^^"_ApplyObj_"^"_PathStandard_"^"_Time_"^"_TimeUnit_"^"_AdmType_"^^^^"
			Set flg=##Class(DHCMA.CPW.KB.PathBase).Update(InputStr)
			If +flg<0{
				TRollBack
				Set return=-4	
			}
		} Else {
			TRollBack
			Set return=-5
		}
	} Else {
		//导入新表单
		Set InputStr=""_"^"_argCode_"^"_Name_"^"_Type_"^"_""_"^"_IsOper_"^1^"_GC_"^"_Year_"^"_ICD10_"^^"_OperCM3_"^^"_ApplyObj_"^"_PathStandard_"^"_Time_"^"_TimeUnit_"^"_AdmType_"^^^^"
		Set flg=##Class(DHCMA.CPW.KB.PathBase).Update(InputStr)
		If +flg<0{
			TRollBack
			Set return=-6	
		}
	}
	Quit:+return<0 return
	
	//路径保存成功获取主表ID
	Set CPWID=flg				
	
	//保存变异信息
	Set len=$l(VarDesc,"。")
	For index=1:1:len {
		Set Item=$p(VarDesc,"。",index)
		Continue:Item=""
		Set InputStr=CPWID_"^"_""_"^"_index_"^"_Item
		Set Varflg=##Class(DHCMA.CPW.KB.PathVarRsn).Update(InputStr)
		If +Varflg<0{
			TRollBack
			Set return=-7
			Quit
		}
	}
	Quit:+return<0 return
	
	//更新路径阶段,步骤,项目信息
	//阶段、步骤、项目组织结构
	//^DHCMAKBFD("Form",代码,"Item2",阶段,步骤,项目大类,编号)="项目子类^项目值"
	Set EpDesc=""
	For {
		Set EpDesc=$o(^DHCMAKBFD("Form",argCode,"Item2",EpDesc))
		Quit:EpDesc=""

		Set EpStepDesc=$p(EpDesc,"^",2)
		Set EpStepDesc1=$p(EpStepDesc,"（",1)
		Set EpStepDesc2=$p($p(EpStepDesc,"（",2),"）",1)
		Set:EpStepDesc2="" EpStepDesc2=EpStepDesc1
		Set:EpStepDesc1="" EpStepDesc1=EpStepDesc2
		
		//导入临床路径阶段信息
		Set Day=""   //$g(^DHCMAKBFD("Form",argCode,"Item2",EpDesc,EpStepDesc))
		
		Set IsOperDay = 0
		Set:(EpStepDesc["术日")||(EpStepDesc["术当日")||(EpStepDesc["术当天") IsOperDay=1
		Set FirstSetp = 0
		Set:$p(EpDesc,"^",1)="1" FirstSetp =1
		Set InputStr=CPWID_"^"_""_"^"_EpStepDesc1_"^"_EpStepDesc2_"^"_$p(EpDesc,"^",1)_"^^^^"_IsOperDay_"^"_FirstSetp_"^1"
		//w InputStr,!
		Set retStage=##Class(DHCMA.CPW.KB.PathStage).Update(InputStr)
		If +retStage<0 {
			TRollBack
			Set return=-8
			Quit	
		}
		
		Set CPWEpID=retStage   //步骤(阶段)ID
		
		Set ItemType=""
		For {
			Set ItemType=$o(^DHCMAKBFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType))
			Quit:ItemType=""
			
			Set ItemInd=0
			For {
				Set ItemInd=$o(^DHCMAKBFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType,ItemInd))
				Quit:ItemInd=""
				
				//导入临床路径项目信息
				Set tmpItem=$g(^DHCMAKBFD("Form",argCode,"Item2",EpDesc,EpStepDesc,ItemType,ItemInd))
				Set ItemTypeSub=$p(tmpItem,"^",1)							//项目子分类
				Set ItemDesc=$p(tmpItem,"^",2)								//项目描述
				Continue:ItemDesc=""
				
				Set IsOptinion=$s(ItemDesc["【*】":1,1:0)					//是否可选
				Set:(ItemDesc["必要时")||(ItemDesc["酌情")||(ItemDesc["视情况") IsOptinion=1
				Set ItemDesc=$tr(ItemDesc,"【*】","")
				Set ItemDesc=..CleanSpecialChar(ItemDesc)	
				
				If ItemType["诊疗"{
					Set retID=..CheckByDesc(ItemDesc,1)						//诊疗库已存在，只保存路径库下的诊疗项目即可
					//w ItemDesc,!
					If +retID<0{
						TRollBack
						Set return=-9
						Quit		
					}Else{
						Set inputStr=CPWEpID_"^^"_ItemDesc_"^"_ItemTypeSub_"^"_ItemInd_"^"_IsOptinion_"^"_1_"^"_retID
						Set retPCItem=##class(DHCMA.CPW.KB.PathClinItem).Update(inputStr,"^")
						If +retPCItem<0{
							TRollBack
							Set return=-10
							Quit
						} 
					}
				}
				If ItemType["护理"{											//保存护理项目库的同时保存到路径库下护理项目表中
					//检查或保存到护理项目库中
					Set retNBID=..CheckByDesc(ItemDesc,3)
					If (+retNBID<0){
						Set Alias=##class(ext.util.String).ToChineseSpell($$ALPHAUP^SSUTIL4(ItemDesc))
						Set InputStr1="^"_ItemDesc_"^"_Alias_"^^^^"_"1"_"^^^"
						Set retNBID=##Class(DHCMA.CPW.KB.NurItemBase).Update(InputStr1)
						If +retNBID<0{
							TRollBack
							Set return=-11
							Quit
						} 
					}
				
					//保存到路径库下的护理项目中
					Set inputStr2=CPWEpID_"^^"_ItemDesc_"^"_ItemTypeSub_"^"_ItemInd_"^"_IsOptinion_"^"_1_"^"_retNBID
					Set retPNItem=##class(DHCMA.CPW.KB.PathNurItem).Update(inputStr2,"^")
					If +retPNItem<0{
						TRollBack
						Set return=-12
						Quit
					}
					
				}
				If ItemType["医嘱"{											//保存医嘱项目库的同时保存到路径库下医嘱项目表中
					//检查或保存到医嘱项目库中
					Set retOBID=..CheckByDesc(ItemDesc,2)
					If (+retOBID<0){
						Set Alias=##class(ext.util.String).ToChineseSpell($$ALPHAUP^SSUTIL4(ItemDesc))
						Set InputStr1="^"_ItemDesc_"^"_Alias_"^^"_"1"_"^^^"
						Set retOBID=##Class(DHCMA.CPW.KB.OrdItemBase).Update(InputStr1)
						If +retOBID<0{
							TRollBack
							Set return=-13
							Quit
						} 
					}
				
					//保存到路径库下的医嘱项目中
					Set inputStr2=CPWEpID_"^^"_ItemDesc_"^"_ItemTypeSub_"^"_ItemInd_"^"_IsOptinion_"^"_1_"^"_retOBID
					Set retPOItem=##class(DHCMA.CPW.KB.PathOrdItem).Update(inputStr2,"^")
					If +retPOItem<0{
						TRollBack
						Set return=-14
						Quit
					}	
				}
			}
			Quit:+return<0
		}
		Quit:+return<0
	}
	Quit:+return<0 return
	
	If $TLevel>0 TCommit
	Kill ^DHCMAKBFD("Form",argCode)
	Set return=$g(CPWID)
	Quit return
	
SaveFormErr
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// 处理诊疗/护理/医嘱项目字符串中的特殊字符
/// w ##class(DHCMA.CPW.KBS.ImportPathWay).CleanSpecialChar("质（）控科。？，；：”“‘’")
ClassMethod CleanSpecialChar(inputStr) As %String
{
	New (inputStr)

	Set inputStr=$tr(inputStr,$char(10),"")			//换行
	Set inputStr=$tr(inputStr,$char(13),"")			//回车
	Set inputStr=$tr(inputStr,"（","(")
	Set inputStr=$tr(inputStr,"）",")")
	Set inputStr=$tr(inputStr,"，",",")
	Set inputStr=$tr(inputStr,"。",".")
	Set inputStr=$tr(inputStr,"？","?")
	Set inputStr=$tr(inputStr,"！",".")
	Set inputStr=$tr(inputStr,"：",":")
	Set inputStr=$tr(inputStr,"；",";")
	Set inputStr=$tr(inputStr,"、",",")
	Set inputStr=$tr(inputStr,"”","""")
	Set inputStr=$tr(inputStr,"“","""")
	Set inputStr=$tr(inputStr,"‘","'")
	Set inputStr=$tr(inputStr,"’","'")
	
	Quit inputStr
}

/// 检查项目是否有重复的
/// w ##class(DHCMA.CPW.KBS.ImportPathWay).CheckByDesc("诊疗方案调整（必要时）",1)
ClassMethod CheckByDesc(aDesc As %String, flag As %String) As %String
{
	New (aDesc,flag)
	Set return=-1
	
	Set aDesc=$$ALPHAUP^SSUTIL4(aDesc)
	If (flag=1){
		If ($d(^CT.MA.CPW.KB.ClinItemBaseI("IdxofDesc",1,aDesc))){
			Set return=$O(^CT.MA.CPW.KB.ClinItemBaseI("IdxofDesc",1,aDesc,""),-1)
		}
	}ElseIf(flag=2){
		If ($d(^CT.MA.CPW.KB.OrdItemBaseI("IdxofDesc",1,aDesc))){
			Set return=$O(^CT.MA.CPW.KB.OrdItemBaseI("IdxofDesc",1,aDesc,""),-1)
		}
	}Elseif(flag=3){
		If ($d(^CT.MA.CPW.KB.NurItemBaseI("IdxofDesc",1,aDesc))){
			Set return=$O(^CT.MA.CPW.KB.NurItemBaseI("IdxofDesc",1,aDesc,""),-1)
		}
	}
	Quit return
}

/// 病历代码去重
/// w ##class(DHCMA.CPW.KBS.ImportPathWay).RemovalEmr("EMR100004,EMR100009，EMR100010","EMR100003,EMR100009")
ClassMethod RemovalEmr(EmrCode As %String, Code As %String) As %String
{
	new (EmrCode,Code)
	Set return=EmrCode
	Quit:EmrCode="" Code
	Quit:Code="" EmrCode
	
	Set EmrCode=$tr(EmrCode,"，",",")
	Set Code=$tr(Code,"，",",")
	Set len=$l(Code,",")
	For index=1:1:len{
		Set xCode=$p(Code,",",index)
		Continue:xCode=""
		if ((","_EmrCode_",")'[(","_xCode_",")){
			Set EmrCode=EmrCode_","_xCode
		}
	}
	Quit EmrCode
}

/// 全部导入后执行（一）:程序处理导入路径阶段天数(只处理含天的)
/// w ##class(DHCMA.CPW.KBS.ImportPathWay).AutoComputeStageTime()
ClassMethod AutoComputeStageTime() As %String
{
	Set xPathID=""
	For{
		Set xPathID=$o(^CT.MA.CPW.KB.PathBaseD(xPathID))
		Quit:xPathID=""
		
		Set xStageID=""
		For{
			Set xStageID=$o(^CT.MA.CPW.KB.PathBaseD(xPathID,"STG",xStageID))
			Quit:xStageID=""
			
			Set objStg=##class(DHCMA.CPW.KB.PathStage).GetObjById(xPathID_"||"_xStageID)
			Continue:'$IsObject(objStg)
			Set PSDesc=objStg.PSDesc
			If (PSDesc["天")||(PSDesc["日"){
				Set PSDesc=$tr(PSDesc,"～","-")
				Set PSDesc=$tr(PSDesc,"－","-")
				Set PSDesc=$tr(PSDesc,"~","-")
				Set PSDesc=$tr(PSDesc,"/","-")
				If PSDesc["-"{
					Set start1="",end1="",val1="",start2="",end2="",val2=""
					Set SttDay=$locate($p(PSDesc,"-",1),"[0-9]+",start1,end1,val1)
					Set EndDay=$locate($p(PSDesc,"-",2),"[0-9]+",start2,end2,val2)
					Set StgDays=(val2-val1)+1					
				}Else{
					Set start1="",end1="",val1=""
					Set SttDay=$locate(PSDesc,"[0-9]+",start1,end1,val1)
					Set:SttDay'="" StgDays=1	
				}
				
				Set objStg.PSTime=StgDays
				Set objStg.PSTimeUnit="D"
				Do objStg.%Save()
				Do objStg.%Close()		
			}			
		} 
			
	}
	Quit 1
}

/// 全部导入后执行（二）：对已导入诊疗项目数据所关联病历代码进行规范处理
/// w ##class(DHCMA.CPW.KBS.ImportPathWay).AutoCheckEMRCode()
ClassMethod AutoCheckEMRCode() As %String
{
	Set return=""
	Set ERMCodeList=$lb("EMR050101","EMR050102","EMR050103","EMR050104","EMR070001","EMR070002","EMR070004","EMR070005","EMR070006","EMR090001","EMR090002","EMR090003","EMR100001","EMR100002","EMR100003","EMR100007","EMR100008","EMR100009","EMR100010","EMR100011","EMR100012","EMR100013","EMR100014","EMR100015","EMR120001","EMR130001","EMR10000501","EMR10000502","EMR10000601","EMR10000602","EMR100022")
	
	Set xCItemID=""
	For{
		Set xCItemID=$o(^CT.MA.CPW.KB.ClinItemBaseD(xCItemID))
		Quit:xCItemID=""
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(xCItemID)
		Continue:'$IsObject(objItem)
		Continue:objItem.CIEMRCode=""
		Set strEMRCode=objItem.CIEMRCode               //strEMRCode="EMR050102,EMR0501012,EMR050166263,EMR070002" //
		For indx=1:1:$l(strEMRCode,","){
			Set tmpEmrCode=$p(strEMRCode,",",indx)
			Continue:tmpEmrCode=""
			Set ret=$locate(tmpEmrCode,"[0-9]+")
			Set $e(tmpEmrCode,1,ret-1)="EMR"
			If $lf(ERMCodeList,tmpEmrCode)>0{
				Set $p(strEMRCode,",",indx)=tmpEmrCode
			}Else{
				//将含错误目录代码的记录返回
				//Set return=return_$lb(xCItemID)
				
				//或直接删除错误目录代码
				Set tmpStrEmrCode=","_strEMRCode_","			
				Set strEMRCode=$p(tmpStrEmrCode,","_tmpEmrCode_",",1)_","_$p(tmpStrEmrCode,","_tmpEmrCode_",",2)
				Set strEMRCode=$e(strEMRCode,2,$l(strEMRCode)-1)
				Set indx=indx-1
				
			}
		}
		Set objItem.CIEMRCode=strEMRCode
		Do objItem.%Save()
		Do objItem.%Close()
	}
	
	//Quit return
	Quit 1
}

/// 全部导入后执行（三）：对转科/交接班/出院记录、出院小结/术后病程记录相关代码处理
/// w ##class(DHCMA.CPW.KBS.ImportPathWay).AutoModifyEMRCode()
ClassMethod AutoModifyEMRCode() As %String
{
	Set return=""
	//Set ERMCodeList=$lb("EMR10000501","EMR10000502","EMR10000601","EMR10000602","EMR100022","EMR100013","EMR120001")
	
	Set xCItemID="",flg1="",flg2=""
	For{
		Set xCItemID=$o(^CT.MA.CPW.KB.ClinItemBaseD(xCItemID))
		Quit:xCItemID=""
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(xCItemID)
		Continue:'$IsObject(objItem)
		Continue:objItem.CIEMRCode=""
		Set flg1=0,flg2=0
		
		Set strEMRCode=","_objItem.CIEMRCode_","
		If (strEMRCode[",EMR10000501,")||(strEMRCode[",EMR10000502,"){			//EMR10000501、EMR10000502替换为EMR100005
			Set strEMRCode=$replace(strEMRCode,",EMR10000501,",",EMR100005,")
			If strEMRCode'[",EMR100005,"{
				Set strEMRCode=$replace(strEMRCode,",EMR10000502,",",EMR100005,")
			}Else{
				Set:strEMRCode[",EMR10000502," strEMRCode=$p(strEMRCode,",EMR10000502,",1)_","_$p(strEMRCode,",EMR10000502,",2)
			}
				
		}
		If (strEMRCode[",EMR10000601,")||(strEMRCode[",EMR10000602,"){			//EMR10000601、EMR10000602替换为EMR100006
			Set strEMRCode=$replace(strEMRCode,",EMR10000601,",",EMR100006,")
			If strEMRCode'[",EMR100006,"{
				Set strEMRCode=$replace(strEMRCode,",EMR10000602,",",EMR100006,")
			}Else{
				Set:strEMRCode[",EMR10000602," strEMRCode=$p(strEMRCode,",EMR10000602,",1)_","_$p(strEMRCode,",EMR10000602,",2)
			} 
				
		}
		If (strEMRCode[",EMR100013,")&&(strEMRCode'[",EMR120001,"){				//EMR100013替换为EMR120001
			Set strEMRCode=$replace(strEMRCode,",EMR100013,",",EMR120001,")
			Set flg1=1
		}
		If (flg1=0)&&(strEMRCode[",EMR120001,")&&(strEMRCode'[",EMR100013,"){	//EMR120001替换为EMR100013
			Set strEMRCode=$replace(strEMRCode,",EMR120001,",",EMR100013,")
		}
		If strEMRCode[",EMR100022,"{											//删除EMR100022
			Set strEMRCode=$p(strEMRCode,",EMR100022,",1)_","_$p(strEMRCode,",EMR100022,",2)
		}
		
		Set strEMRCode=$e(strEMRCode,2,$l(strEMRCode)-1)
		Set objItem.CIEMRCode=strEMRCode
		Do objItem.%Save()
		Do objItem.%Close()
	}
	
	Quit 1
}

}
