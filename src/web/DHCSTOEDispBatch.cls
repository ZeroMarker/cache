Import sqluser

Class web.DHCSTOEDispBatch Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Descript：	DHC_OEDispBatch表处理的相关操作
/// Creater：	zhouyg
/// CreateDate：2014-12-24
/// Table：		DHC_OEDispensing,DHCOEDispBatch
/// Input：		DspbStr:DspID^inclb^数量^售价^进价
/// Return：	SQLCODE
ClassMethod InsDspBatch(DspbStr As %String) As %String
{
 n (DspbStr)
 s DspID=$p(DspbStr,"^",1)
 s inclb=$p(DspbStr,"^",2)
 s qty=+$p(DspbStr,"^",3)
 s sp=+$p(DspbStr,"^",4)
 s rp=+$p(DspbStr,"^",5)
 s incID=$p(DspbStr,"^",6)
 s status=$p(DspbStr,"^",7)
 k OEDISP
 s OEDISP(0)=DspID
 s OEDISP(3)=inclb
 s OEDISP(4)=qty
 s OEDISP(5)=sp
 s OEDISP(6)=rp
 s OEDISP(7)=incID
 s OEDISP(8)=status
 &sql(Insert Into DHC_OEDispBatch Values :OEDISP())
 i SQLCODE'=0 d
 .s ret=$$SqlErrorRecord^DHCSTERROR("web.DHCSTOEDispBatch.InsDspBatch",inclb_"^"_qty_"^"_sp_"^"_rp,SQLCODE_":"_$g(%msg))
 q:SQLCODE'=0 SQLCODE
 s RetID=$p($g(%ROWID),$c(1))
 q 0_"^"_RetID
}

/// Description:根据打包子表ID删除打包子表记录
/// Creator:	hulihua
/// CreateDate:	2018-10-28
/// Table:      DHC_OEDispBatch
/// Input:		DspBatchID-打包表子表ID
/// Output:
/// Return： 	0-成功，-1-参数为空 ，其它-删除打包子表失败
/// Others:
/// Debug:		w ##class(web.DHCSTOEDispBatch).DelDspBatch()
ClassMethod DelDspBatch(DspBatchID As %String) As %String
{
	n (DspBatchID)
	q:DspBatchID="" -1
	&sql(Delete From DHC_OEDispBatch Where DSPB_RowId=:DspBatchID)
 	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("web.DHCSTOEDispBatch.DelDspBatch",DspBatchID,SQLCODE_":"_$g(%msg))
 	q:SQLCODE'=0 SQLCODE
 	q 0
}

}
