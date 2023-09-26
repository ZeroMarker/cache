/// 名称: web.DHCCPW.MRC.ClinPathWaysItmImpl
/// 描述: 实施记录关联项目
/// 编写者：zhufei
/// 编写日期: 2011-11-23
Class web.DHCCPW.MRC.ClinPathWaysItmImpl Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-11-23
/// Description:  根据Id取实施记录关联项目
/// Input：       User.DHCMRCClinPathWaysItmImpl.ID
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysItmImpl).GetById(9)
ClassMethod GetById(id, separete) As %String
{
	new (id,separete)
	set ret=""
	set obj=##class(User.DHCMRCClinPathWaysItmImpl).GetObjById(id)
	If $IsObject(obj){
		set:$g(separete)="" separete=..#SEPARATE
		set ret=id
		set ret=ret_separete_obj.CPWSIIType   //关联类型
		set ret=ret_separete_obj.CPWSIIValue  //关联项目
		set ret=ret_separete_obj.CPWSIINote   //说明
	}
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2011-11-23
/// Description:  保存实施记录关联项目
/// Input：       User.DHCMRCClinPathWaysItmImpl.ID
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysItmImpl).Update("")
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set ParRef=$p(argInput,"^",1)
	Quit:ParRef="" return
	Set ChildSub=$p(argInput,"^",2)
	If ChildSub="" {
		Set obj=##class(User.DHCMRCClinPathWaysItmImpl).%New()
	} Else {
		Set ID=ParRef_"||"_ChildSub
		Set obj=##class(User.DHCMRCClinPathWaysItmImpl).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set ItemType=$p(argInput,"^",3)
	Set ItemType=$s(ItemType="ARCIM":"A",ItemType="A":"A",ItemType="EPRIM":"E",ItemType="E":"E",1:"")
	Set ItemValue=$p(argInput,"^",4)
	Set ItemNote=$p(argInput,"^",5)
	
	Set obj.CPWSIIType=ItemType
	Set obj.CPWSIIValue=ItemValue
	Set obj.CPWSIINote=ItemNote
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		//Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-11-23
/// Description:  转换关联医嘱为实施记录项目
/// Input：       
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysItmImpl).ChangeToItmImpl()
ClassMethod ChangeToItmImpl()
{
	New
	
	Quit "Over!"
}

/// Creator：     zhufei
/// CreatDate：   2011-11-23
/// Description:  处理项目执行及路径外医嘱
/// Input：       
/// w ##Class(web.DHCCPW.MRC.ClinPathWaysItmImpl).ChangeLnkArcimsToItmImpl()
ClassMethod ProcessItmImpl(aPathWayID As %String) As %String
{
	New (aPathWayID)
	Set return=-1
	
	Set $ZT="ProcessItmImplErr"
	
	Set return=1
	Quit return
	
ProcessItmImplErr
	Quit return
}

}
