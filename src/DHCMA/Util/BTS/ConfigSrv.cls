/// 名称: DHCMA.Util.BTS.ConfigSrv
/// 描述: 系统参数配置
/// 编写者：许文杰   
/// 编写日期: 2018-10-12
Class DHCMA.Util.BTS.ConfigSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-09
/// Description:  查询系统参数配置
/// Table：       DHCMA.Util.BT.Config
/// Input： 
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.ConfigSrv","QryByProduct","CPW","2!!2")
Query QryByProduct(aProductCode As %String, aHospID As %String, aKeyWords As %String = "") As %Query(ROWSPEC = "ind:%String,ID:%String,Code:%String,Desc:%String,value:%String,HospDesc:%String,ProID:%String,ProCode:%String,ProDesc:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,UserDesc:%String,Comments:%String")
{
}

ClassMethod QryByProductExecute(ByRef qHandle As %Binary, aProductCode As %String, aHospID As %String, aKeyWords As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xProductID=""
 	For {
 		Set xProductID=$o(^DHCMA.Util.BT.ConfigI("IdxofProduct",xProductID))
 		Quit:xProductID=""
 		
 		Set objPro=##class(DHCMA.Util.BT.Product).GetObjById(xProductID)
 		Continue:'$IsObject(objPro)
 		Set ProCode=objPro.ProCode
 		Continue:(aProductCode'="")&&(aProductCode'=ProCode)
 		Set ProDesc=objPro.ProDesc
 		
 		Set xHospID=""
 		For {
 			Set xHospID=$o(^DHCMA.Util.BT.ConfigI("IdxofProduct",xProductID,xHospID))
 			Quit:xHospID=""
 			
 			Continue:(aHospID'="")&&(" "_aHospID'=xHospID)
 			Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID($tr(xHospID," "))
 			Continue:'$IsObject(objHosp)
 			Set HospDesc=objHosp.BTDesc
 			
 			Set xID=""
 			For {
 				Set xID=$o(^DHCMA.Util.BT.ConfigI("IdxofProduct",xProductID,xHospID,xID))
 				Quit:xID=""
 				
 				Set objCof=##class(DHCMA.Util.BT.Config).GetObjById(xID)
 				Continue:'$IsObject(objCof)
 				Continue:(ProCode="SYS")&&(objCof.BTCode="SYSIsOpenMultiHospMode")    //多院区参数不显示到前台，修改时通过类DHCMA.Util.INIT.BatRelateDataAndHosp下方法修改
 				
 				Set Code=objCof.BTCode
 				Set Desc=objCof.BTDesc
 				Continue:(aKeyWords'="")&&(Code'[aKeyWords)&&(Desc'[aKeyWords)
 				Set value=objCof.BTValue
 				Set IsActive=$s(+objCof.BTIsActive=1:"是",1:"否")
 				Set ActDate=$zd(objCof.BTActDate,3)
 				Set ActTime=$zt(objCof.BTActTime,1)
 				Set ActUserID=objCof.BTActUserID
 				Set UserDesc=""
 				Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
 				Set:$IsObject(objUser) UserDesc=objUser.BTDesc
 				Set Comments=objCof.BTComments
 				
				Set Data=$lb(ind,xID,Code,Desc,value,HospDesc,xProductID,ProCode,ProDesc,IsActive,ActDate,ActTime,ActUserID,UserDesc,Comments)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
 			}
 		}
 	}
 	
	Quit $$$OK
}

ClassMethod QryByProductClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByProductExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryByProductFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByProductExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 导入参数设置列表
/// w ##Class(DHCMA.Util.BTS.ConfigSrv).ImportConfigs("^SYSUseHisMenuConfig^使用HIS的菜单配置^1^0^SYS^0：DHCMedBase的菜单配置"_$c(10)_"1：所有的菜单都切换到HIS菜单配置中","^")
ClassMethod ImportConfigs(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	//序号	医院ID	代码	描述	值	产品代码	备注
	Set Code=$p(aInputStr,aSeparate,2)
	Set Desc=$p(aInputStr,aSeparate,3)
	Set Value=$p(aInputStr,aSeparate,4)
	Set HospID=$p(aInputStr,aSeparate,5)
	Set ProCode=$p(aInputStr,aSeparate,6)
	Set Resume=$p(aInputStr,aSeparate,7)
	Quit:(Code="")||(Desc="")||(ProCode="") return
	
	Set ProductDr=$o(^DHCMA.Util.BT.ProductI("IdxOfProCode"," "_$zcvt(ProCode,"U"),0))
	Quit:ProductDr="" return
	
	Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(HospID)
	Set:$IsObject(objHosp) HospID=objHosp.OID
	
	Set IsActive=1,ActUserID=""
	Set ID=$o(^DHCMA.Util.BT.ConfigI("IdxofCode"," "_$zcvt(Code,"U")," "_$zcvt(HospID,"U"),0))
	If ID'="" {
		Set objCfg=##class(DHCMA.Util.BT.Config).GetObjById(ID)
		If $IsObject(objCfg){
			Set IsActive=objCfg.BTIsActive
			Set ActUserID=objCfg.BTActUserID
		}
	}
	
	Set InputStr=ID
	Set InputStr=InputStr_aSeparate_Code
	Set InputStr=InputStr_aSeparate_Desc
	Set InputStr=InputStr_aSeparate_Value
	Set InputStr=InputStr_aSeparate_HospID
	Set InputStr=InputStr_aSeparate_ProductDr
	Set InputStr=InputStr_aSeparate_IsActive
	Set InputStr=InputStr_aSeparate_ActUserID
	Set InputStr=InputStr_aSeparate_Resume
	Set return=##Class(DHCMA.Util.BT.Config).Update(InputStr,aSeparate)
	Quit return
}

/// 清除指定产品配置数据
/// w ##class(DHCMA.Util.BTS.ConfigSrv).ClearConfigDByPCode("SD")
ClassMethod ClearConfigDByPCode(aProductCode As %String, aHospID As %String = "") As %String
{
	n (aProductCode,aHospID)
	Set return="",ErrMsg=""
	Quit:(aProductCode="") return
	Set xProductID=""
 	For {
 		Set xProductID=$o(^DHCMA.Util.BT.ConfigI("IdxofProduct",xProductID))
 		Quit:xProductID=""
 		
 		Set objPro=##class(DHCMA.Util.BT.Product).GetObjById(xProductID)
 		Continue:'$IsObject(objPro)
 		Set ProCode=objPro.ProCode
 		Set ProDesc=objPro.ProDesc
 		Continue:(aProductCode'="")&&(aProductCode'=ProCode)	
 		Set xHospID=""
 		For {
 			Set xHospID=$o(^DHCMA.Util.BT.ConfigI("IdxofProduct",xProductID,xHospID))
 			Quit:xHospID=""
 			Continue:(aHospID'="")&&(" "_aHospID'=xHospID)			
 			Set xID=""
 			For {
 				Set xID=$o(^DHCMA.Util.BT.ConfigI("IdxofProduct",xProductID,xHospID,xID))
 				Quit:xID=""
 				Set objCof=##class(DHCMA.Util.BT.Config).%OpenId(xID)
 				Continue:'$IsObject(objCof)
 				Set objCof.BTValue=""
 				Set BTDesc=objCof.BTDesc
 				Set sc=objCof.%Save()
				If $system.Status.IsError(sc) {        //检查Save是否成功
			   		Do $system.OBJ.DisplayError(sc) 
			   		Set ErrMsg=ErrMsg_",配置项:"_BTDesc_"-配置值初始化失败；"
				}
				Do objCof.%Close()
 			}
 		}
 		Set:ErrMsg'="" return=$e(ErrMsg,2,$l(ErrMsg))
 		Set:ErrMsg="" return=ProDesc_"配置项目初始化完成！"
 	}
 	Quit return
}

}
