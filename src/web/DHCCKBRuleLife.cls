/// 规则日志
Class web.DHCCKBRuleLife Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description:： 输出时间轴html
/// d ##class(web.DHCCKBRuleLife).HTML()
ClassMethod HTML()
{

	s ruleId=+$g(%request.Data("ruleId",1))
	//s ruleId=216001
	q:ruleId=0 ""
	w:'$d(^CT.CKB.PDSS.RuleD(ruleId)) "<h3>该规则已无</h3>" //hxy 2020-12-10 st
	q:'$d(^CT.CKB.PDSS.RuleD(ruleId)) "" //ed
	
	;w "<h3>"_$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3)_"</h3>"   //sufan 20211012
	s log="" f  s log=$o(^CKB.PDSS.RuleLogI("Rule",ruleId,log),-1) q:log=""  d
	.s logData = $g(^CKB.PDSS.RuleLogD(log))
	.s date= $lg(logData,4)
	.s time= $lg(logData,5)
	.s opType= $lg(logData,6) 
	.s user= $lg(logData,3) 
	.
	.s:+user'=0 user=$p($g(^SSU("SSUSR",user)),"^",2) //hxy 2020-12-14 +$g
	.//s opText=$case(opType,"Add":"增加","Edit":"修改","Remove":"删除","Release":"发布","CancelRelease":"取消")
	.s opText=$case(opType,"Add":"增加","Edit":"增加","Remove":"删除","Release":"发布","CancelRelease":"取消","Confirm":"核实","cancelconfirm":"撤销核实",:"") //先将修改 变为增加 2021/9/18
	.s color=$case(opType,"Add":"green","Edit":"yellow","Remove":"red","Release":"blue","CancelRelease":"purple",:"")
	.s colclss=$case(opType,"Add":"icon-hos_add_green","Edit":"icon-hos_edit_yellow","Remove":"icon-hos_edit_yellow","Release":"icon-hos_rele","CancelRelease":"icon-hos_edit_yellow","Confirm":"icon-hos_rele",:"")
	.s imgurl=$case(opType,"Add":"hos_add_green","Edit":"hos_edit_yellow","Remove":"hos_edit_yellow","Release":"hos_rele_blue","CancelRelease":"hos_edit_yellow","Confirm":"hos_rele_blue","cancelconfirm":"undo",:"")

	.w "<section>"
	.;w "	<span class='point-time "_"point-"_color_"'></span>"
	.//w "	<span class='point-time "_colclss_"'></span>"
	.w "	<span class='point-time'>"
	.w "		<img src='../scripts/dhcnewpro/dhcckb/images/"_imgurl_".png'>"
	.w "</span>"
	.;w "	<time>"
	.;w "		<span>&nbsp;</span>"
	.;w "		<span>"_$zd(date,3)_" "_$zt(time,1)_"</span>"
	.;w "	</time>"
	.w "	<aside>"
	.w "		<span class='things '>"_opText_"</span><span style='margin-left:50px;font-size:14px;color:#666666'><span class='icon-hos_zp_user'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>"_user_"<span style='margin-left:70px;' ><span class='icon-hos_clock'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>"_$zd(date,3)_" "_$zt(time,1)_"</span></span>"
	.
	.
	.
	.s logItm="" f  s logItm=$o(^CKB.PDSS.RuleDataLogI("Parent",log,logItm),-1) q:logItm=""  d
	..s logData = $g(^CKB.PDSS.RuleDataLogD(logItm))
	..s itmOpType= $lg(logData,17)
	..s lastLogItm= $lg(logData,18)
	..
	..q:itmOpType="Unchanged"
	..
	..s spanClass=$case(itmOpType,"Add":"text-green","Edit":"text-yellow","Remove":"text-red")
	..s opText=$case(itmOpType,"Add":"增加","Edit":"修改","Remove":"删除")
	..s logItmHtml=##class(web.DHCCKBRuleLog).GetLogRuleDataHtml(logItm)
	..s lastLogItmHtml=##class(web.DHCCKBRuleLog).GetLogRuleDataHtml(lastLogItm)
	..w "		<p class='brief'>"
	..w "			<span class='"_spanClass_"'>"
	..i itmOpType="Add" d
	...w "<span style=''>(增加子项)</span>"_logItmHtml
	..i itmOpType="Edit" d
	...w "<span style=''>(修改子项)</span>"_lastLogItmHtml_"<span style='margin:0px 5px 0px 5px;color:black'><b>改为</b></span>"_logItmHtml
	..i itmOpType="Remove" d
	...w "<span style=''>(删除子项)</span>"_logItmHtml
	..w "			</span>"
	..w "		</p>"
	.w "	</aside>"
	.w "</section>"
	.
	.
	.
	.
}

}
