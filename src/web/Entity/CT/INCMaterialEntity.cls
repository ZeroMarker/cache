/// Function:材料审批 材料类 
/// CreateDate:2023-04-19
/// Creator:sunfengchao
Class web.Entity.CT.INCMaterialEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.INCMaterialEntity";

/// 数据ID
Property ID As %String;

/// 是否收费(Y/N)  
Property Charge As %String;

/// 代码  
Property InciCode As %String;

/// 名称
Property InciDesc As %String;

/// 别名  
Property Alias As %String;

/// 规格   
Property Spec As %String;

/// 型号
Property Model As %String;

/// 生产商名称   
Property Manf As %String;

/// 基本单位 
Property BUom As %String;

/// 入库单位
Property PUom As %String;

/// 入库转换系数  
Property Factor As %String;

/// 大包装单位   
Property PackUomMax As %String;

/// 大包装转换系数
Property PackUomFacMax As %String;

/// 零售价 
Property SP As %String;

/// 库存类组
Property StkGrp As %String;

/// 库存分类
Property StkCat As %String;

/// 是否高值(Y/N) 
Property HighValue As %String;

/// 产地 
Property Origin As %String;

/// 国家医保编码 
Property MatInsuCode As %String;

/// 国家医保名称 
Property MatInsuDesc As %String;

/// 条码   
Property INCBCode As %String;

/// 供应商名称   
Property PbVendor As %String;

/// 注册证号  
Property RegisterNo As %String;

/// 停用日期    
Property INCEndDate As %String;

/// 进口标志(进口/国产/合资)  
Property ImportFlag As %String;

///  流程平台对应的流程实例 id 
Property BDPINCAProcInsId As %String;

/// 任务ID
Property MtaskId As %String;

}
