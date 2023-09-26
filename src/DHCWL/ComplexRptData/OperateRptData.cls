Import SQLUser

Class DHCWL.ComplexRptData.OperateRptData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// hetong
/// 2015-10-23
/// 删除报表配置相关信息，报表的删除包含两方面内容：
/// 		1、删除报表定义及配置相关信息
/// 		2、删除报表与指标的关联
/// 删除报表不涉及对指标的删除操作
/// w ##class(DHCWL.ComplexRptData.OperateRptData).DeleteRptCfg("6")
ClassMethod DeleteRptCfg(rptId As %String) As %String
{
	n (rptId)
	
	i +rptId=0 q "报表不存在！"
	;设置事务，报表配置及与指标的关联作为整体操作 TSTART TROLLBACK TCOMMIT
	;事物回滚后，任何对数据库数据的操作都将还原
	// 1、删除报表定义及配置相关信息
	TSTART
		&sql(DELETE FROM DHCWL_ComplexRpt.RptCfg WHERE ID=:rptId)
		i SQLCODE=0{
			i '$d(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptId)){
				TCOMMIT  q "ok"
			}
			&sql(DELETE FROM DHCWL_ComplexRpt.RowsColCfg WHERE RC_RptDr=:rptId)
			i SQLCODE=0{
				// 2、删除报表与指标的关联关联关系
				i '$d(^DHCWL.ComplexRpt.RptLinkMkpiI("LinkRpt",rptId)){
					TCOMMIT  q "ok"
				}
				&sql(delete from DHCWL_ComplexRpt.RptLinkMkpi where RptLink_Rpt=:rptId)
				i SQLCODE=0{
					TCOMMIT  q "ok"
				}else{
					TROLLBACK  q "删除关联指标错误！"
				}
			}else{
				TROLLBACK  q "删除报表配置错误！"
			}
		}else{
			TROLLBACK  q "删除报表定义错误！"
		}
}

/// hetong
/// 2015-10-29
/// 检查当前报表是否已匹配关联指标
/// 如果没有返回空，否则返回已匹配的指标ID串
/// w ##class(DHCWL.ComplexRptData.OperateRptData).CheckRptKpiLink("2")
ClassMethod CheckRptKpiLink(rptId As %String) As %String
{
	n (rptId)
	q:'$d(^DHCWL.ComplexRpt.RptCfgD(rptId)) ""
	s linkID=0,linkStr=""
	f {
		s linkID=$o(^DHCWL.ComplexRpt.RptLinkMkpiI("LinkRpt",rptId,linkID))
		q:linkID=""
		i linkStr="" s linkStr=linkID
		else  s linkStr=linkStr_","_linkID
	}
	
	q linkStr
}

}
