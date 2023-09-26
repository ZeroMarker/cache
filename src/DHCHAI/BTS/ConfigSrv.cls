/// 名称: DHCHAI.BTS.ConfigSrv
/// 描述: 系统参数配置相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-07
Class DHCHAI.BTS.ConfigSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-03-07
/// Description:  通过编码查询
/// Table：       DHCHAI.BT.Config
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.ConfigSrv","QueryByCode","","")
Query QueryByCode(aCode As %String, aDesc As %String, aMod As %String) As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,Value:%String,HospDr:%String,HospCode:%String,HospDesc:%String,IsActive:%String,IsActDesc:%String,Mod:%String,Resume:%String,IndNo:%String") [ SqlProc ]
{
}

ClassMethod QueryByCodeExecute(ByRef qHandle As %Binary, aCode As %String, aDesc As %String, aMod As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//定义临时Global
	Set NIndex="QueryByCode"
	Kill ^TMP($zn,$j,NIndex)
	
 	Set aCode=$ZCVT($g(aCode),"U")
 	Set aDesc=$ZCVT($g(aDesc),"U")
 	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.BT.ConfigD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.BT.Config).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=obj.%Id()
	 	Set Code=obj.BTCode
	 	Set Desc=obj.BTDesc
	 	Set Value=obj.BTValue
	 	Continue:(aCode'="")&&($zcvt(Code,"U")'[aCode)
	 	Continue:(aDesc'="")&&($zcvt(Desc,"U")'[aDesc)
		Set HospID="",HospCode="",HospDesc=""
		If $IsObject(obj.BTHospDr) {
			Set HospID  =obj.BTHospDr.%Id()
	 		Set HospCode=obj.BTHospDr.BTCode
	 		Set HospDesc=obj.BTHospDr.BTDesc
		}
		Set IsActive=obj.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set Mod=obj.BTMod
		Continue:(aMod'="")&&(aMod'=Mod)
		Set Resume=obj.BTResume
		Set IndNo=obj.BTIndNo
		Set:IndNo="" IndNo=99999
		
		//保存数据
		Set ^TMP($zn,$j,NIndex,"IndoNo",IndNo,ID)=$lb(ID,Code,Desc,Value,HospID,HospCode,HospDesc,IsActive,IsActDesc,Mod,Resume,IndNo)	
	}
	//输出数据(排序码)
	Set xIndNo=""
	For{
		Set xIndNo=$o(^TMP($zn,$j,NIndex,"IndoNo",xIndNo))	
		Quit:xIndNo=""
		
		Set xID=""
		For{
			Set xID=$o(^TMP($zn,$j,NIndex,"IndoNo",xIndNo,xID))	
			Quit:xID=""
			
			Set Data=$g(^TMP($zn,$j,NIndex,"IndoNo",xIndNo,xID))
			Set ^CacheTemp(repid,ind)=Data
        	Set ind=ind+1	
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QueryByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByCodeExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2021-09-13
/// Description:  加载模块类型
/// Table：       DHCHAI.BT.Config
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.ConfigSrv","QueryMod")
Query QueryMod(aCode As %String, aDesc As %String, aMod As %String) As %Query(ROWSPEC = "ID:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QueryModExecute(ByRef qHandle As %Binary, aCode As %String, aDesc As %String, aMod As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set ModList="主页^综合监测^目标性监测^细菌耐药性^统计分析^环境卫生学^职业暴露^手卫生依从性^系统设置^其他"
 	For xInd=1:1:$l(ModList,"^"){
		Set Data=$lb(xInd,$p(ModList,"^",xInd))
		Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QueryModClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryModExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryModFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryModExecute ]
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

/// 取当前menu的操作权限信息
/// w ##class(DHCHAI.BTS.ConfigSrv).WriteMenuOperSecurity()
ClassMethod WriteMenuOperSecurity(aOperAuth As %String) As %String
{
	New (%session,aOperAuth)
	Set return=0
	Quit:aOperAuth="" return
	Write "<SCRIPT language='javascript' type='text/javascript'>"
	//Set MethodEncrypt=##class(%CSP.Page).Encrypt($LB("DHCHAI.ClassMethodService.RunClassMethod"))
	//Write !,"    var RunClassMethodEncrypt="""_MethodEncrypt_""";"
	Write !,"    var tDHCMedMenuOper=new Array();"
	Write !,"    tDHCMedMenuOper['"_aOperAuth_"']=1;  //Admin"
	Write !,"<"_"/SCRIPT>"
	Set return=1
	Quit return
}

}
