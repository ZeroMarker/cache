/// 名称: web.DHCPE.KBA.IOPEUsherItemCatSrv
/// 描述: 导出导入科室导诊单项目分类
/// 编写者：zhufei
/// 编写日期: 2022-01-21
Class web.DHCPE.KBA.IOPEUsherItemCatSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-21
/// Description: 导出科室导诊单项目分类（绝对私有）
/// Table：      User.DHCPEUsherItemCat
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEUsherItemCatSrv","QryUsherItemCat",152)
Query QryUsherItemCat(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,CatCode:%String,Category:%String,Sort:%String,Diet:%String,AutoChange:%String,Place:%String,DocSignName:%String,PatSignName:%String,Active:%String")
{
}

ClassMethod QryUsherItemCatExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCategory=""
	For {
		Set xCategory=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_aLocId,xCategory))
		Quit:xCategory=""
		
		Set xID=0
		For {
			Set xID=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_aLocId,xCategory,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEUsherItemCat).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEUsherItemCat).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.PINoActive="N"  //无效数据过滤
			Set CatCode     = obj.PICatCode
			Set Category    = obj.PICategory
			Set Sort        = obj.PISort
			Set Diet        = obj.PIDiet
			Set AutoChange  = obj.PIAutoChange
			Set Place       = obj.PIPlace
			Set DocSignName = obj.PIDocSignName
			Set PatSignName = obj.PIPatSignName
			Set Active      = obj.PINoActive
			Set:Active="" Active="Y"
			
			Set Data=$lb(xID,CatCode,Category,Sort,Diet,AutoChange,Place,DocSignName,PatSignName,Active)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-21
/// Description:  导入科室导诊单项目分类（绝对私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEUsherItemCatSrv).SaveUsherItemCat()
ClassMethod SaveUsherItemCat(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set CatCode       = $p(aInputStr,aDelimiter,2)    //代码
	Set Category      = $p(aInputStr,aDelimiter,3)    //分类
	Set Sort          = $p(aInputStr,aDelimiter,4)    //顺序号
	Set Diet          = $p(aInputStr,aDelimiter,5)    //就餐标志
	Set AutoChange    = $p(aInputStr,aDelimiter,6)    //自动调整顺序
	Set Place         = $p(aInputStr,aDelimiter,7)    //注意事项
	Set DocSignName   = $p(aInputStr,aDelimiter,8)    //医生签名
	Set PatSignName   = $p(aInputStr,aDelimiter,9)    //患者签名
	Set Active        = $p(aInputStr,aDelimiter,10)   //激活
	Quit:(CatCode="")||(Category="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_xInLocID," "_$zcvt(Category,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEUsherItemCat).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEUsherItemCat).%New()
		}Else{
			Set obj=##class(User.DHCPEUsherItemCat).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.PILocDR         = xInLocID
		Set obj.PICatCode       = CatCode
		Set obj.PICategory      = Category
		Set obj.PISort          = Sort
		Set obj.PIDiet          = Diet
		Set obj.PIAutoChange    = AutoChange
		Set obj.PIPlace         = Place
		Set obj.PIDocSignName   = DocSignName
		Set obj.PIPatSignName   = PatSignName
		Set obj.PINoActive      = Active
		Set obj.PIUpdateDate    = +$h
		Set obj.PIUpdateTime    = $p($h,",",2)
		
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
	   		Quit
		}Else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
		
		//保存表记录授权
		Set flg=##class(User.DHCPEUsherItemCat).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
