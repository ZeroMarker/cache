Class DHCWL.CodeCfgData.DimtypeReplaceType Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      yuanxu
/// CreatDate：    2015-12-05
/// Description:： 取消原代码维护中的类型概念，使用指标中的维度替换类型,指标版本4.2（含4.2）以上
///                低版本升级到V1.6版本（包含V1.6）以后的需要用此方法把原类型替换成维度,同事把原类型中的执行代码插入到维度中
/// Table：       
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.CodeCfgData.DimtypeReplaceType).DimtypeReplaceType()
ClassMethod DimtypeReplaceType() As %String
{
 s retsqlcode=0	
 s id=0 f  s id=$o(^DHCWL.CodeCfg.TypeD(id)) q:id=""  d
 .s typeExtCode=$li(^DHCWL.CodeCfg.TypeD(id),7)
 .s dimId=$$GetDimByType(id)
 .q:dimId=""
 .&sql(UPDATE DHCWL_MKPI.DHCWLMKPIDimType SET KDT_ExeCode=:typeExtCode WHERE ID=:dimId )   //and KDT_ExeCode is null
 .s retsqlcode=$g(retsqlcode)+SQLCODE
 i retsqlcode=0 w !,"维度执行代码更新成功！"
 k
 s retsqlcode=0	
 s id=0 f  s id=$o(^DHCWL.CodeCfg.GroupD(id)) q:id=""  d
 .s typeId=$li(^DHCWL.CodeCfg.GroupD(id),7)
 .q:typeId=""
 .s dimId=$$GetDimByType(typeId)
 .q:dimId=""
 .&sql(UPDATE DHCWL_CodeCfg.DHCWLCodeCfgGroup SET Grp_Dim_Dr=:dimId WHERE ID=:id )   //and Grp_Dim_Dr is null
 .s retsqlcode=$g(retsqlcode)+SQLCODE
 i retsqlcode=0 w !,"科室子组维度替换成功！"
 k
 s retsqlcode=0	
 s id=0 f  s id=$o(^DHCWL.CodeCfg.ItemGroupD(id)) q:id=""  d
 .s typeId=$li(^DHCWL.CodeCfg.ItemGroupD(id),4)
 .q:typeId=""
 .s dimId=$$GetDimByType(typeId)
 .q:dimId=""
 .&sql(UPDATE DHCWL_CodeCfg.DHCWLCodeCfgItemGroup SET ItemGrp_Dim_Dr =:dimId WHERE ID =:id )   //and ItemGrp_Dim_Dr is null
 .s retsqlcode=$g(retsqlcode)+SQLCODE
 i retsqlcode=0 w !,"科室大组维度替换成功！"
 q retsqlcode
 
 
 //类型与维度的对应
GetDimByType(typeId)
 s dimCode=""
 s typeCode=$li(^DHCWL.CodeCfg.TypeD(typeId),2)
 i typeCode="CTLoc" d
 . s dimCode="CTLOC"
 i typeCode="CTDoc" d
 . s dimCode="CTPCP"
 i typeCode="TAREC" d
 . s dimCode="TAREC"
 i typeCode="TARAC" d
 . s dimCode="TARAC"
 i typeCode="TARIC" d
 . s dimCode="TARIC"
 i typeCode="TAROC" d
 . s dimCode="TAROC"
 i typeCode="TARSC" d
 . s dimCode="TARSC"
 i typeCode="TARMC" d
 . s dimCode="TARMC"
 i typeCode="TARMCNew" d
 . s dimCode="TARMCNew"
 i typeCode="ARCBG" d
 . s dimCode="ARCBG"
 i typeCode="ARCSG" d
 . s dimCode="ARCSG"
 i typeCode="ARCIC" d
 . s dimCode="ARCIC"
 i typeCode="ARCIM" d
 . s dimCode="ARCIM"
 i typeCode="TARI" d
 . s dimCode="TARI"
 i typeCode="SESS" d
 . s dimCode="SESS"
 i typeCode="REA" d
 . s dimCode="REA"
 i typeCode="CarPrv" d
 . s dimCode="CarPrv"
 q:dimCode="" ""
 s dimId=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$zcvt(dimCode,"U"),""))
 q dimId
}

}
