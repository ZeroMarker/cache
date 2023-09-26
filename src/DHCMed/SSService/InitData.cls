/// 名称: DHCMed.SSService.InitData
/// 描述: 初始化数据
/// 编写者：wuqk
/// 编写日期: 2010-03-30
Class DHCMed.SSService.InitData Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：     wuqk
/// CreatDate：   2010-04-01
/// Description:  初始化产品 菜单 操作 授权
/// Table：       DHCMed.SS.Products，DHCMed.SS.Menus，DHCMed.SS.MenuOperation
/// Input：       groupId：安全组Id
/// Return：      返回产品信息，按照<$C1>分隔行，^分隔字段
/// d ##class(DHCMed.SSService.InitData).LoadPMO()
ClassMethod LoadPMO()
{
	/*
	k ^DHCMed.SS.MenusD
	k ^DHCMed.SS.MenusI
	k ^DHCMed.SS.ProductsD
	k ^DHCMed.SS.ProductsI
	k ^DHCMed.SS.SecurityD
	k ^DHCMed.SS.SecurityI
	k ^DHCMed.SS.MenuOperationD
	k ^DHCMed.SS.MenuOperationI
	k ^DHCMed.SS.SecurityOperaD
	k ^DHCMed.SS.SecurityOperaI*/
	
	/*
	//1:Rowid 2:ProCode 3:ProName 4:ProVersion 5:IconClass 6:ShowIndex 7:ProActive 8:ProResume
	set id=##class(DHCMed.SS.Products).Update("^Epdemic^传染病管理^v2.3.0^^3^1^")
	//1:Rowid 2:MenuCode 3:MenuCaption 4:LinkUrl 5:Expression 6:ProductDr 7:ShowIndex 8:IconClass 9:ParentMenuDr
	set mid=##class(DHCMed.SS.Menus).Update("^EpdemicRep^传染病报告^dhc.med.gettree1.csp^^"_id_"^1^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^New^新建")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Edit^编辑")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Delete^删除")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	
	
	set mid=##class(DHCMed.SS.Menus).Update("^InfControl^监控^^^"_id_"^3^^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	
	set mid1=##class(DHCMed.SS.Menus).Update("^InfControl1^日常监控^dhcmed.imppat.imppatcontrol.csp^^"_id_"^1^icon-menu^"_mid)
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid1,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid1_"^New^新建")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid1_"^Edit^编辑")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid1_"^Delete^删除")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	
	
	set mid2=##class(DHCMed.SS.Menus).Update("^InfControl2^监控结论^dhc.med.security.csp?groupId=1^^"_id_"^2^icon-menu^"_mid)
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
	
	set id=##class(DHCMed.SS.Products).Update("^DeathReport^医学死亡证明管理^v1.5.0^^2^1^")
	set mid=##class(DHCMed.SS.Menus).Update("^DeathRep^死亡报告^dhc.med.gettree.csp^^"_id_"^1^^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^New^新建")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Edit^编辑")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Delete^删除")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	
	
	set id=##class(DHCMed.SS.Products).Update("^Infection^院内感染管理^v2.6.0^^1^1^")
	set mid=##class(DHCMed.SS.Menus).Update("^InfRep^院感报告^dhcmedinfrepqry.csp^^"_id_"^1^^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^New^新建")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Edit^编辑")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Delete^删除")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	
	set mid=##class(DHCMed.SS.Menus).Update("^InfRepCheck^报告审核^dhcmedinsutest.csp^^"_id_"^2^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)	
	*/
	//Modify by wuqk 2011-07-18
	Set IsActive="",ProID=""
	Set IsActive=$o(^DHCMed.SS.ProductsI("ProductActive","SYS",IsActive))
	Set:IsActive'="" ProID=$o(^DHCMed.SS.ProductsI("ProductActive","SYS",IsActive,0))
	
	Set InputStr="^SYS^系统管理^v2.12.0^icon-sysconfig^99^1^" 
	Set:ProID='"" InputStr=ProID_InputStr
	set id=##class(DHCMed.SS.Products).Update(InputStr)
	
	m ^DHCMed.SS.MenusDTMP=^DHCMed.SS.MenusD
	m ^DHCMed.SS.MenusITMP=^DHCMed.SS.MenusI
	&SQL(DELETE FROM DHCMed_SS.Menus WHERE ProductDr=:id)
	
	set mid=##class(DHCMed.SS.Menus).Update("^Productsl^产品维护^dhcmed.main.products.csp^^"_id_"^1^icon-menupro^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	
	set mid=##class(DHCMed.SS.Menus).Update("^Menus^菜单维护^dhcmed.main.menus.csp^^"_id_"^1^icon-menumenu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	
	set mid=##class(DHCMed.SS.Menus).Update("^Authority^菜单授权^dhcmed.main.security.csp^^"_id_"^2^icon-menuauthority^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	
	set mid=##class(DHCMed.SS.Menus).Update("^Dictionary^基础字典^dhcmed.main.dictionary.csp^^"_id_"^3^icon-menudic^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	
	set mid=##class(DHCMed.SS.Menus).Update("^Config^配置项目^dhcmed.main.configs.csp^^"_id_"^3^icon-menuconfig^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
}

/// 初始化系统菜单权限
/// w ##Class(DHCMed.SSService.InitData).LoadMenuSec(13)
ClassMethod LoadMenuSec(SSGrpID As %String, ProCode As %String = "SYS") As %String
{
	New (SSGrpID,ProCode)
	Set return=-1
	Quit:(SSGrpID="")||(ProCode="") return
	
	Set $ZT="LoadMenuSecErr"
	
	Set ProductID=$o(^DHCMed.SS.ProductsI("ProCodeIndex"," "_$zcvt(ProCode,"U"),0))
	Set ParentMenuDr="",Count=0
	For {
		Set ParentMenuDr=$o(^DHCMed.SS.MenusI("IndexProParentIndex",ProductID,ParentMenuDr))
		Quit:ParentMenuDr=""
		Set ShowIndex=0
		For {
			Set ShowIndex=$o(^DHCMed.SS.MenusI("IndexProParentIndex",ProductID,ParentMenuDr,ShowIndex))
			Quit:ShowIndex=""
			Set MenuID=0
			For {
				Set MenuID=$o(^DHCMed.SS.MenusI("IndexProParentIndex",ProductID,ParentMenuDr,ShowIndex,MenuID))
				Quit:MenuID=""
				Set flg=##class(DHCMed.SS.Security).Update(SSGrpID,ProductID,MenuID,1)
				Set Count=Count+1
			}
		}
	}
	
	Set return=Count
	Quit return
	
LoadMenuSecErr
	Write $ZError,!
	Quit -999
}

Storage Default
{
}

}
