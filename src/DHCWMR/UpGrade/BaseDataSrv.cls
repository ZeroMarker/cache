/// 名称: DHCWMR.UpGrade.BaseDataSrv
/// 描述: 系统升级 基础数据处理
/// 编写者：zhufei
/// 编写日期: 2014-08-27
Class DHCWMR.UpGrade.BaseDataSrv Extends DHCWMR.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// ****************************************************
/// 一、升级基础数据执行方法
/// 1 基础数据处理方法 ：w ##Class(DHCWMR.UpGrade.BaseDataSrv).ProcBaseData()
/// 
/// 二、升级完成手工配置
/// 1 配置病案类型、号码类型
/// 2 配置工作流
/// 3 配置编目操作项
/// ****************************************************
ClassMethod ProcBaseData()
{
	/*
	//处理基础字典
	Kill ^DHCWMR.SS.DictionaryD
	Kill ^DHCWMR.SS.DictionaryI
	Set flg=##Class(DHCWMR.UpGrade.BaseDataSrv).ChangeBaseDic()
	
	//处理病案分类
	Kill ^DHCWMR.SS.MrClassD
	Kill ^DHCWMR.SS.MrClassI
	Set flg=##Class(DHCWMR.UpGrade.BaseDataSrv).UpdateMrClass()
	
	//处理病案类型
	Kill ^DHCWMR.SS.MrTypeD
	Kill ^DHCWMR.SS.MrTypeI
	Set flg=##Class(DHCWMR.UpGrade.BaseDataSrv).ChangeMrType()
	
	//处理操作项目
	Kill ^DHCWMR.SS.WorkItemD
	Kill ^DHCWMR.SS.WorkItemI
	Set flg=##Class(DHCWMR.UpGrade.BaseDataSrv).ChangeWorkItem()
	
	//医院列表配置
	//Kill ^DHCWMR.SS.HospitalD
	//Kill ^DHCWMR.SS.HospitalI
	
	//工作流配置
	Kill ^DHCWMR.SS.WorkFlowD
	Kill ^DHCWMR.SS.WorkFlowI
	//首页数据项
	Kill ^DHCWMR.MQ.DataItemsD
	Kill ^DHCWMR.MQ.DataItemsI
	//编目操作项配置
	Kill ^DHCWMR.FP.WorkFItemD
	Kill ^DHCWMR.FP.WorkFItemI
	//编目数据项
	Kill ^DHCWMR.FP.DataItemD
	Kill ^DHCWMR.FP.DataItemI
	//编目附加项
	Kill ^DHCWMR.FP.ExtraItemD
	Kill ^DHCWMR.FP.ExtraItemI
	//编目附加项配置
	Kill ^DHCWMR.FP.WorkFExtraD
	Kill ^DHCWMR.FP.WorkFExtraI
	*/
	//处理诊断版本
	Kill ^DHCWMR.FP.ICDVersionD
	Kill ^DHCWMR.FP.ICDVersionI
	Set flg=##Class(DHCWMR.UpGrade.BaseDataSrv).ChangeICDVer()
	
	//处理诊断库
	Kill ^DHCWMR.FP.ICDDxD
	Kill ^DHCWMR.FP.ICDDxI
	Set flg=##Class(DHCWMR.UpGrade.BaseDataSrv).ChangeMRICDDx()
	//加载HIS诊断库
	Set ICDVer=+$g(^DHCWMRICDSetting("D"))
	If ICDVer=1 {
		Set flg=##Class(DHCWMR.UpGrade.BaseDataSrv).LoadHISICDDx()
	}
	//加载HIS手术库
	Set OPRVer=+$g(^DHCWMRICDSetting("O"))
	If OPRVer=1 {
		Set flg=##Class(DHCWMR.UpGrade.BaseDataSrv).LoadHISICDCM3()
	}
	
	Quit "OK"
}

/// w ##class(DHCWMR.UpGrade.BaseDataSrv).ChangeMRICDDx()
ClassMethod ChangeMRICDDx()
{
	New
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRICD(xID))
		Quit:xID=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "同步病案诊断库：已处理 "_Count_" 条!",!
		
		Set Code=xID
		Set Desc=$p($g(^DHCWMRICD(xID)),"^",3)
		Set ICD10=$p($g(^DHCWMRICD(xID)),"^",1)
		Set ICD9=$p($g(^DHCWMRICD(xID)),"^",2)
		Set VerID=$p($g(^DHCWMRICD(xID)),"^",4)
		Set IsActive=$p($g(^DHCWMRICD(xID)),"^",6)
		Set IsActive=$s(IsActive="Y":1,1:0)
		Set Resume=$p($g(^DHCWMRICD(xID)),"^",5)
		
		Set InputStr=""
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_VerID
		Set InputStr=InputStr_"^"_ICD10
		Set InputStr=InputStr_"^"_ICD9
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_IsActive
		Set InputStr=InputStr_"^"_Resume
		Set flg=##class(DHCWMR.FP.ICDDx).Update(InputStr,"^")
		Continue:flg<0
		Set ID=flg
		
		Set xAliasID=0
		For {
			Set xAliasID=$o(^DHCWMRICDA(0,"ICDDxDr",xID,xAliasID))
			Quit:xAliasID=""
			
			Set tmp=$g(^DHCWMRICDA(xAliasID))
			Set ICDAlias=$p(tmp,"^",2)
			Continue:ICDAlias=""
			
			Set InputStr=ID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_ICDAlias
			Set flg=##class(DHCWMR.FP.ICDAlias).Update(InputStr,"^")
		}
	}
	
	Quit Count
}

/// w ##class(DHCWMR.UpGrade.BaseDataSrv).ChangeICDVer()
ClassMethod ChangeICDVer()
{
	New
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRICDV(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^DHCWMRICDV(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		Set ICDVCode=xID
		Set ICDVDesc=$p(tmpInfo,"^",2)
		Set ICDVResume=$p(tmpInfo,"^",3)_","_$p(tmpInfo,"^",4)
		
		Set ^DHCWMR.FP.ICDVersionD=xID-1
		Set InputStr=""_"^"_ICDVCode
		Set InputStr=InputStr_"^"_ICDVDesc
		Set InputStr=InputStr_"^"_ICDVResume
		Set flg=##class(DHCWMR.FP.ICDVersion).Update(InputStr,"^")
		If flg'=xID {
			Write "操作项目："_xID_"'="_flg_","_InputStr,!
		}
	}
	
	Set flg=##class(DHCWMR.FP.ICDVersion).Update("^HIS-D^HIS诊断库^","^")
	Quit:(+flg)<1 return
	Set Count=Count+1
	
	Set flg=##class(DHCWMR.FP.ICDVersion).Update("^HIS-O^HIS手术库^","^")
	Quit:(+flg)<1 return
	Set Count=Count+1
	
	Quit Count
}

/// w ##class(DHCWMR.UpGrade.BaseDataSrv).LoadHISICDDx()
ClassMethod LoadHISICDDx()
{
	New
	Set return="Error"
	
	Set objVersion=##class(DHCWMR.FP.ICDVersion).GetObjByCode("HIS-D")
	Quit:'$IsObject(objVersion) return
	Set VerID=objVersion.%Id()
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^MRC("ID",xID))
		Quit:xID=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "同步HIS诊断库：已处理 "_Count_" 条!",!
		
		Set Code=$p($g(^MRC("ID",xID)),"^",1)
		Set Desc=$p($g(^MRC("ID",xID)),"^",2)
		Set ICD10=$p($g(^MRC("ID",xID)),"^",4)
		Set ICD9=$p($g(^MRC("ID",xID)),"^",35)
		Set IsActive=1
		Set:ICD10="" IsActive=0
		Set DateFrom=$p($g(^MRC("ID",xID)),"^",6)
		Set DateTo=$p($g(^MRC("ID",xID)),"^",7)
		If DateFrom'="" {
			Set:DateFrom>(+$h) IsActive=0
		}
		If DateTo'="" {
			Set:DateTo<(+$h) IsActive=0
		}
		
		Set InputStr=""
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_VerID
		Set InputStr=InputStr_"^"_ICD10
		Set InputStr=InputStr_"^"_ICD9
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_IsActive
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""  //别名
		Set InputStr=InputStr_"^"_xID //诊断库指针
		Set InputStr=InputStr_"^"_""  //手术库指针
		Set flg=##class(DHCWMR.FP.ICDDx).Update(InputStr,"^")
		Continue:flg<0
		Set ID=flg
		
		Set xSub=0
		For {
			Set xSub=$o(^DHCWMR.FP.ICDDxD(ID,"A",xSub))
			Quit:xSub=""
			Set flg=##class(DHCWMR.FP.ICDAlias).DeleteById(ID_"||"_xSub)
		}
		
		Set xSub=0
		For {
			Set xSub=$o(^MRC("ID",xID,"ALIAS",xSub))
			Quit:xSub=""
			
			Set InputStr=ID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_$g(^MRC("ID",xID,"ALIAS",xSub))
			Set flg=##class(DHCWMR.FP.ICDAlias).Update(InputStr,"^")
		}
	}
	
	Quit "OK"
}

/// w ##class(DHCWMR.UpGrade.BaseDataSrv).LoadHISICDCM3()
ClassMethod LoadHISICDCM3()
{
	New
	Set return="Error"
	
	Set objVersion=##class(DHCWMR.FP.ICDVersion).GetObjByCode("HIS-O")
	Quit:'$IsObject(objVersion) return
	Set VerID=objVersion.%Id()
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^ORC("OPER",xID))
		Quit:xID=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "同步HIS手术库：已处理 "_Count_" 条!",!
		
		Set Code=$p($g(^ORC("OPER",xID)),"^",1)
		Set Desc=$p($g(^ORC("OPER",xID)),"^",2)
		Set ICD10=$p($g(^ORC("OPER",xID)),"^",14)
		Set ICD9=$p($g(^ORC("OPER",xID)),"^",21)
		Set IsActive=1
		Set:ICD10="" IsActive=0
		Set DateFrom=$p($g(^ORC("OPER",xID)),"^",5)
		Set DateTo=$p($g(^ORC("OPER",xID)),"^",6)
		If DateFrom'="" {
			Set:DateFrom>(+$h) IsActive=0
		}
		If DateTo'="" {
			Set:DateTo<(+$h) IsActive=0
		}
		
		Set InputStr=""
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_VerID
		Set InputStr=InputStr_"^"_ICD10
		Set InputStr=InputStr_"^"_ICD9
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_IsActive
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""   //别名
		Set InputStr=InputStr_"^"_""   //诊断库指针
		Set InputStr=InputStr_"^"_xID  //手术库指针
		Set flg=##class(DHCWMR.FP.ICDDx).Update(InputStr,"^")
		Continue:flg<0
		Set ID=flg
		
		Set xSub=0
		For {
			Set xSub=$o(^DHCWMR.FP.ICDDxD(ID,"A",xSub))
			Quit:xSub=""
			Set flg=##class(DHCWMR.FP.ICDAlias).DeleteById(ID_"||"_xSub)
		}
		
		Set xSub=0
		For {
			Set xSub=$o(^ORC("OPER",xID,"ALIAS",xSub))
			Quit:xSub=""
			
			Set InputStr=ID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_$g(^ORC("OPER",xID,"ALIAS",xSub))
			Set flg=##class(DHCWMR.FP.ICDAlias).Update(InputStr,"^")
		}
	}
	
	Quit "OK"
}

ClassMethod ChangeWorkItem()
{
	New
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRWITM(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^DHCWMRWITM(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		Set WICode=xID
		Set WIDesc=$p(tmpInfo,"^",2)
		Set WIResume=$p(tmpInfo,"^",4)
		
		Set ^DHCWMR.SS.WorkItemD=xID-1
		Set InputStr=""_"^"_WICode
		Set InputStr=InputStr_"^"_WIDesc
		Set InputStr=InputStr_"^"_WIResume
		Set flg=##class(DHCWMR.SS.WorkItem).Update(InputStr,"^")
		If flg'=xID {
			Write "操作项目："_xID_"'="_flg_","_InputStr,!
		}
	}
	
	Quit Count
}

ClassMethod ChangeMrType()
{
	New
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRNOTYPE("NoFormat",xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^DHCWMRDIC(xID))
		Continue:tmpInfo=""
		Set tmpNoType=$g(^DHCWMRNOTYPE("NoFormat",xID))
		Continue:tmpNoType=""
		
		Set Count=Count+1
		
		Set MTDesc=$p(tmpInfo,"^",3)
		If MTDesc["住院" {
			Set MrClassCode="I"
		} ElseIf MTDesc["门诊" {
			Set MrClassCode="O"
		} ElseIf MTDesc["急诊" {
			Set MrClassCode="E"
		} Else {
			Set MrClassCode="I"
		}
		Set obj=##class(DHCWMR.SS.MrClass).GetObjByCode(MrClassCode)
		Set MTMrClass=obj.%Id()
		Set MTHospIDs=""
		Set MTReceiptType=""
		Set MTGetWay=""
		Set MTRecycleType=""
		Set MTNoFiled=$p(tmpNoType,"^",5)
		Set MTResume=$p(tmpInfo,"^",11)
		
		Set ^DHCWMR.SS.MrTypeD=xID-1
		Set InputStr=""_"^"_MTMrClass
		Set InputStr=InputStr_"^"_MTDesc
		Set InputStr=InputStr_"^"_MTHospIDs
		Set InputStr=InputStr_"^"_MTReceiptType
		Set InputStr=InputStr_"^"_MTGetWay
		Set InputStr=InputStr_"^"_MTRecycleType
		Set InputStr=InputStr_"^"_MTNoFiled
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_"0"
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_MTResume
		Set flg=##class(DHCWMR.SS.MrType).Update(InputStr,"^")
		If flg'=xID {
			Write "病案类型："_xID_"'="_flg_","_InputStr,!
		}
	}
	
	Quit Count
}

ClassMethod UpdateMrClass()
{
	Set flg=##class(DHCWMR.SS.MrClass).Update("^I^住院病历^","^")
	Set flg=##class(DHCWMR.SS.MrClass).Update("^O^门诊病历^","^")
	Set flg=##class(DHCWMR.SS.MrClass).Update("^E^急诊病历^","^")
	Set flg=##class(DHCWMR.SS.MrClass).Update("^L^急诊留观^","^")
	Quit 4
}

ClassMethod ChangeBaseDic()
{
	New
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRDIC(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^DHCWMRDIC(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		Set SDType=$p(tmpInfo,"^",1)
		Set SDCode=$p(tmpInfo,"^",2)
		Set SDDesc=$p(tmpInfo,"^",3)
		Set SDHospID=""
		Set SDTextA=$p(tmpInfo,"^",6)
		Set SDTextB=$p(tmpInfo,"^",7)
		Set SDTextC=$p(tmpInfo,"^",8)
		Set SDTextD=$p(tmpInfo,"^",9)
		Set SDIsActive=$p(tmpInfo,"^",10)
		Set SDIsActive=$s(SDIsActive["Y":1,1:0)
		Set SDResume=$p(tmpInfo,"^",11)
		
		Set ^DHCWMR.SS.DictionaryD=xID-1
		Set InputStr=""_"^"_SDType
		Set InputStr=InputStr_"^"_SDCode
		Set InputStr=InputStr_"^"_SDDesc
		Set InputStr=InputStr_"^"_SDHospID
		Set InputStr=InputStr_"^"_SDTextA
		Set InputStr=InputStr_"^"_SDTextB
		Set InputStr=InputStr_"^"_SDTextC
		Set InputStr=InputStr_"^"_SDTextD
		Set InputStr=InputStr_"^"_SDIsActive
		Set InputStr=InputStr_"^"_SDResume
		Set flg=##class(DHCWMR.SS.Dictionary).Update(InputStr,"^")
		If (flg'=xID)&&(flg="-100") {
			Set ^DHCWMR.SS.DictionaryD=xID-1
			Set InputStr=""_"^"_SDType
			Set InputStr=InputStr_"^"_"Err-"_SDCode
			Set InputStr=InputStr_"^"_SDDesc
			Set InputStr=InputStr_"^"_SDHospID
			Set InputStr=InputStr_"^"_SDTextA
			Set InputStr=InputStr_"^"_SDTextB
			Set InputStr=InputStr_"^"_SDTextC
			Set InputStr=InputStr_"^"_SDTextD
			Set InputStr=InputStr_"^"_SDIsActive
			Set InputStr=InputStr_"^"_SDResume
			Set flg=##class(DHCWMR.SS.Dictionary).Update(InputStr,"^")
		}
		If flg'=xID {
			Write "基础字典："_xID_"'="_flg_","_InputStr,!
		}
	}
	&SQL(update DHCWMR_SS.Dictionary set SDIsActive=0 where SDType='WorkType')      //项目类型（E突发项、O顺序项）
	&SQL(update DHCWMR_SS.Dictionary set SDIsActive=0 where SDType='SysOperation')  //系统操作
	&SQL(update DHCWMR_SS.Dictionary set SDIsActive=0 where SDType='ReceiptType')   //接诊类型
	&SQL(update DHCWMR_SS.Dictionary set SDIsActive=0 where SDType='AssignType')    //号码分配方式
	&SQL(update DHCWMR_SS.Dictionary set SDIsActive=0 where SDType='UnReceiptType') //取消接诊方式
	&SQL(update DHCWMR_SS.Dictionary set SDIsActive=0 where SDType='ICDType' or (SDCode='ICDType' and SDType='SYS')) //诊断、手术/操作类型
	
	Set InputStr="^SYS^FPCutType^切口类型^^^^^^1^"
	Set flg=##class(DHCWMR.SS.Dictionary).Update(InputStr,"^")
	Set InputStr="^SYS^FPHealing^愈合情况^^^^^^1^"
	Set flg=##class(DHCWMR.SS.Dictionary).Update(InputStr,"^")
	Set xID=0
	For {
		Set xID=$o(^DHCWMR.SS.DictionaryI("IndexDicType"," CLOSEUP",xID))
		Quit:xID=""
		Set objDic=##class(DHCWMR.SS.Dictionary).GetObjById(xID)
		Continue:'$IsObject(objDic)
		Continue:objDic.SDIsActive'=1
		Set DicDesc=objDic.SDDesc
		Set CutType=$p(DicDesc,"/",1)
		Set Healing=$p(DicDesc,"/",2)
		If CutType'="" {
			Set InputStr="^FPCutType^"_CutType_"^"_CutType_"^^^^^^1^"
			Set flg=##class(DHCWMR.SS.Dictionary).Update(InputStr,"^")
		}
		If Healing'="" {
			Set InputStr="^FPHealing^"_Healing_"^"_Healing_"^^^^^^1^"
			Set flg=##class(DHCWMR.SS.Dictionary).Update(InputStr,"^")
		}
	}
	&SQL(update DHCWMR_SS.Dictionary set SDCode='1' where SDCode='Ⅰ' and SDType='FPCutType')
	&SQL(update DHCWMR_SS.Dictionary set SDCode='2' where SDCode='Ⅱ' and SDType='FPCutType')
	&SQL(update DHCWMR_SS.Dictionary set SDCode='3' where SDCode='Ⅲ' and SDType='FPCutType')
	&SQL(update DHCWMR_SS.Dictionary set SDCode='1' where SDCode='I' and SDType='FPCutType')
	&SQL(update DHCWMR_SS.Dictionary set SDCode='2' where SDCode='II' and SDType='FPCutType')
	&SQL(update DHCWMR_SS.Dictionary set SDCode='3' where SDCode='III' and SDType='FPCutType')
	&SQL(update DHCWMR_SS.Dictionary set SDCode='0' where SDCode='无' and SDType='FPCutType')
	&SQL(update DHCWMR_SS.Dictionary set SDCode='1' where SDCode='甲' and SDType='FPHealing')
	&SQL(update DHCWMR_SS.Dictionary set SDCode='2' where SDCode='乙' and SDType='FPHealing')
	&SQL(update DHCWMR_SS.Dictionary set SDCode='3' where SDCode='丙' and SDType='FPHealing')
	&SQL(update DHCWMR_SS.Dictionary set SDCode='0' where SDCode='无' and SDType='FPHealing')
	
	Quit Count
}

ClassMethod ChangeSpecialDic()
{
	New
	
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRDIC(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^DHCWMRDIC(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		Set SDType=$p(tmpInfo,"^",1)
		Set SDCode=$p(tmpInfo,"^",2)
		Set SDDesc=$p(tmpInfo,"^",3)
		Set SDHospID=""
		Set SDTextA=$p(tmpInfo,"^",6)
		Set SDTextB=$p(tmpInfo,"^",7)
		Set SDTextC=$p(tmpInfo,"^",8)
		Set SDTextD=$p(tmpInfo,"^",9)
		Set SDIsActive=$p(tmpInfo,"^",10)
		Set SDIsActive=$s(SDIsActive["Y":1,1:0)
		Set SDResume=$p(tmpInfo,"^",11)
		
		Set ^DHCWMR.SS.DictionaryD=xID-1
		Set InputStr=""_"^"_SDType
		Set InputStr=InputStr_"^"_SDCode
		Set InputStr=InputStr_"^"_SDDesc
		Set InputStr=InputStr_"^"_SDHospID
		Set InputStr=InputStr_"^"_SDTextA
		Set InputStr=InputStr_"^"_SDTextB
		Set InputStr=InputStr_"^"_SDTextC
		Set InputStr=InputStr_"^"_SDTextD
		Set InputStr=InputStr_"^"_SDIsActive
		Set InputStr=InputStr_"^"_SDResume
		Set flg=##class(DHCWMR.SS.Dictionary).Update(InputStr,"^")
		If flg'=xID {
			Write "基础字典："_xID_"'="_flg_","_InputStr,!
		}
	}
	
	Quit Count
}

}
