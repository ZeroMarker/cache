/// 名称:     web.DHCDiagnosCat
/// 描述:     医生站设置,诊断设置,特殊诊断分类设置的业务类
/// 编写日期: 2010.02.24
/// 创建人  : 周志强
/// 适用医院:
Class web.DHCDiagnosCat Extends %RegisteredObject
{

/// Creator    ：周志强      
/// CreatDate  ：2010.02.24
/// Description: 根据费别得到对应大病类别
/// Table      ：   
/// Input      ：CatBillType:费别RowId
/// Return     ：以"!"分隔
/// Others     ：
ClassMethod GetDiagnosCatByBillType(CatBillType As %String) As %String
{
	;w ##class(web.DHCDiagnosCat).GetDiagnosCatByBillType(2)
	if CatBillType="" Q ""
	Set Flag=0
	//if '$D(^DHCDiagnosCatBill(CatBillType)) Q ""
	Set ret=""
	Set RowId=0 f  s RowId=$O(^DHCDiagnosCat(RowId)) Q:RowId=""  d
	.Set DCBillType=$P($G(^DHCDiagnosCat(RowId)),"^",3)
	.Q:DCBillType'=CatBillType
	.Set DCAdmType=$P($G(^DHCDiagnosCat(RowId)),"^",2)
	.Set DCType=$P($G(^DHCDiagnosCat(RowId)),"^",5)
	.Set DCQuick=$P($G(^DHCDiagnosCat(RowId)),"^",6)
	.Set Desc=$P($G(^DHCDiagnosCat(RowId)),"^",1)
	.Q:(DCType'="S")
	.If ret="" Set ret=RowId_"!"_Desc_"!"_DCQuick_$C(1)_Desc_"-"_$g(DCQuick)
	.Else  Set ret=ret_"^"_RowId_"!"_Desc_"!"_DCQuick_$C(1)_Desc_"-"_$g(DCQuick)
	
	Q ret
}

ClassMethod GetDiagnosCatStr() As %String
{
}

}
