Class web.DHCSTExport Extends %RegisteredObject
{

/// creator:yunhaibao
/// createdate:20160412
/// description:用于后台导出药房药库相关信息
/// descirption:导出抗菌药DDD值
/// windows路径命令:w ##class(web.DHCSTExport).ExportInciDDD("","d:\inciallddd.xls")
/// 小机路径命令:w ##class(web.DHCSTExport).ExportInciDDD("","/tmp/inciallddd.xls")
/// 导出excel到对应服务器目录查找
/// input:抗菌药标志(为空导出所有药品记录),Y/N;路径
ClassMethod ExportInciDDD(antiflag, filename)
{
	q:filename="" "无路径!"
	s num=1
 	o filename:"WNS"
 	u filename
	s inci=""
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci="0"
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s incicode=$p(^INCI(inci,1),"^",1)
	.s buom=$p(^INCI(inci,1),"^",10)
	.s puom=$p(^INCI(inci,3),"^",6)
	.i buom'="" s buom=$p($g(^CT("UOM",buom)),"^",2)
	.i puom'="" s puom=$p($g(^CT("UOM",puom)),"^",2)
	.Q:'$D(^INCI(inci)) 
	.S arcimdr=$P(^INCI(inci,1),"^",3)
	.S arcsub=$P(arcimdr,"||",1)
	.S arcver=$P(arcimdr,"||",2)
	.Q:arcsub="" 
	.Q:arcver="" 
	.Q:'$D(^ARCIM(arcsub,arcver)) 
    .S phcdf=$P(^ARCIM(arcsub,arcver,1),"^",12)
    .s phcd=+phcdf
    .s phcdsub=+$p(phcdf,"||",2)
    .q:phcd=0
    .q:phcdsub=0
    .q:'$d(^PHCD(phcd,"DF",phcdsub))
    .s phcdantiflag=$P($g(^PHCD(phcd,"DF",phcdsub,"DHC")),"^",8)
    .i phcdantiflag="" s phcdantiflag="N"
    .q:(antiflag'="")&&(antiflag'=phcdantiflag)
    .s ddd=$P($g(^PHCD(phcd,"DF",phcdsub,"DHC")),"^",5)
    .s whoddd=$P($g(^PHCD(phcd,"DF",phcdsub,"DHC")),"^",11)
    .s whoddduom=$P($g(^PHCD(phcd,"DF",phcdsub,"DHC")),"^",12)
    .i whoddduom'="" s whoddduom=$p($g(^CT("UOM",whoddduom)),"^",2)
    .s whonet=$P($g(^PHCD(phcd,"DF",phcdsub,"DHC")),"^",10)
    .s poison=$p($g(^PHCD(phcd,1)),"^",4)
 	.i poison'="" s poison=$p($g(^PHCPO(poison)),"^",2)
 	.i num=1 d
 	..w "代码"_$c(9)_"名称"_$c(9)_"管制分类"_$c(9)_"DDD值"_$c(9)_"WHODDD值"_$c(9)_"WHODDD单位"_$c(9)_"WHONET码"_$c(9)_"基本单位"_$c(9)_"入库单位"
    .s outputdata=incicode_$c(9)_incidesc_$c(9)_poison_$c(9)_ddd_$c(9)_whoddd_$c(9)_whoddduom_$c(9)_whonet_$c(9)_buom_$c(9)_puom
 	.s outputdata=$tr(outputdata,$c(13,10),"")
 	.w !,outputdata
 	.s num=num+1
 	c filename
    q "导出完成!"
}

}
