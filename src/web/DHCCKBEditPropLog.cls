/// 编辑日志
Class web.DHCCKBEditPropLog Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      lidong
/// CreatDate：    2022-8-1
/// Description:： 药品编辑日志
/// Table：        
/// Input:		   药品分类ID^药品ID
/// Others：       w ##class(web.DHCCKBEditPropLog).HTML() //(151070,0)
ClassMethod HTML()
{
	s EntyId=+$g(%request.Data("ID",1))	
	//s EntyId=151070
	q:EntyId=0 ""
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s dicParref=+$g(%request.Data("dicParref",1))
	//s dicParref=0
	s par= dicParref_"^"_EntyId_"^"_""	
	s ^Tmp("DHCCKB","web.DHCCKBEditPropLog","HTML",pid)=""	
	s arr = ##class(web.DHCCKBTinyOpen).GetAttrListData("1000","1",par,"")
	s json = ##class(%Library.DynamicObject).%FromJSON(arr)
	s len = json.%Size()
	f k=0:1:(len-1) d
	.s params = json.%Get(k).%ToJSON()
	.s obj = ##class(%Library.DynamicObject).%FromJSON(params)
	.s AttrCodeId = obj.attrID	
	.s DicAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,""))
	.q:DicAttrId=""
	.s log="" 
	.f  s log=$o(^CKB.PDSS.DicLogI("DLGDataDr",DicAttrId,log),-1) q:log=""  d
	..s listData = $g(^CKB.PDSS.DicLogD(log))
	..s table= $lg(listData,2)
	..i table="DHC_CKBDicLinkAttr"  d
	...s date= $lg(listData,6)
	...s time= $lg(listData,7)
	...s fulltime=$case($length(time),"1":"0000"_""_time,"2":"000"_""_time,"3":"00"_""_time,"4":"0"_""_time,"5":time)
	...s splDate=date_""_fulltime
	...s ^Tmp("DHCCKB","web.DHCCKBEditPropLog","HTML",pid,splDate)=##class(web.DHCCKBEditPropLog).GetLogDete(AttrCodeId,log)
	
	s existFlag = 0 
	s Date="" f  s Date=$o(^Tmp("DHCCKB","web.DHCCKBEditPropLog","HTML",pid,Date),-1) q:Date=""  d
	.s outstr=^Tmp("DHCCKB","web.DHCCKBEditPropLog","HTML",pid,Date)
	.w ^Tmp("DHCCKB","web.DHCCKBEditPropLog","HTML",pid,Date)
	.s existFlag=1
	i existFlag=0 d
	.s text="<div style="_""""_"margin-top:240px;"_""""_">暂无数据</div>"
	.w "<div class="_""""_"no-data"_""""_" style="_""""_"margin-top:50px;"_""""_">"_text_"</div>"
	k ^Tmp("DHCCKB","web.DHCCKBEditPropLog","HTML",pid)
	
	q ""
}

/// Creator：      lidong
/// CreatDate：    2022-8-10
/// Description:： 生成药品编辑日志临时global
/// Table：        
/// Input:		   字典类型^药品ID
/// Others：       d ##class(web.DHCCKBEditPropLog).GetLogOut()
ClassMethod GetLogOut(par, EntyId)
{
	n (par,EntyId)
	s arr = ##class(web.DHCCKBTinyOpen).GetAttrListData("1000","1",par,"")
	s json = ##class(%Library.DynamicObject).%FromJSON(arr)
	s len = json.%Size()
	f k=0:1:(len-1) d
	.s params = json.%Get(k).%ToJSON()
	.s obj = ##class(%Library.DynamicObject).%FromJSON(params)
	.s AttrCodeId = obj.attrID
	
	.s DicAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,""))
	.q:DicAttrId=""
	.s log="" 
	.f  s log=$o(^CKB.PDSS.DicLogI("DLGDataDr",DicAttrId,log),-1) q:log=""  d
	..s listData = $g(^CKB.PDSS.DicLogD(log))
	..s table= $lg(listData,2) 
	..i table="DHC_CKBDicLinkAttr"  d
	...s date=$lg(listData,6)
	...s time=$lg(listData,7)
	...s fulltime=$case($length(time),"1":"0000"_""_time,"2":"000"_""_time,"3":"00"_""_time,"4":"0"_""_time,"5":time)
	...s splDate=date_""_fulltime
	...s det=##class(web.DHCCKBEditPropLog).GetLogDete(AttrCodeId,log)
	...s ^Tmp("Out",splDate)=det
}

/// Creator：      lidong
/// CreatDate：    2022-8-8
/// Description:： 药品编辑药品属性日志
/// Table：        
/// Input:		   药品ID^药品属性ID
/// Others：       w ##class(web.DHCCKBEditPropLog).HTMLDET()
ClassMethod HTMLDET()
{
	s parref=+$g(%request.Data("parref",1))
	s attrID=+$g(%request.Data("ID",1))
	
	s log=""
	i $o(^CKB.PDSS.DicDataLogI("IndexEntyIDAttrID",parref,attrID,log),-1)=""  d
	.//w "<h3 style='float: left;width: auto;background:#fff'>暂无相关日志</h3>"
	.s text="<div style="_""""_"margin-top:195px;"_""""_">暂无数据</div>"
	.w "<div class="_""""_"no-data"_""""_">"_text_"</div>"
	e  d 
	.f  s log=$o(^CKB.PDSS.DicDataLogI("IndexEntyIDAttrID",parref,attrID,log),-1) q:log=""  d
	..s DicLogID=$lg(^CKB.PDSS.DicDataLogD(log),2)
	..s AttrID=$lg(^CKB.PDSS.DicDataLogD(log),4)
	..s listData = $g(^CKB.PDSS.DicLogD(DicLogID))
	..s date= $lg(listData,6) 
	..s time= $lg(listData,7)
	..s opType= $lg(listData,4) 
	..s user= $lg(listData,5)
	..s:+user'=0 user=$p($g(^SSU("SSUSR",user)),"^",2)
	..s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(AttrID)),3)
	..i desc = ""  d  
	...s linkDr= $lg($g(^CT.CKB.PDSS.CommonDictionD(AttrID)),5)
	...i linkDr'=""  d
	....s desc =$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s opText=$case(opType,"add":"增加","edit":"修改",:"") //先将修改 变为增加 2021/9/18
	..s color=$case(opType,"add":"green","edit":"yellow",:"")
	..s colclss=$case(opType,"add":"icon-hos_add_green","edit":"icon-hos_edit_yellow",:"")
	..s imgurl=$case(opType,"add":"hos_add_green","edit":"hos_edit_yellow","grantAuth":"hos_rele_blue",:"")
	..s img = "<img src='../scripts/dhcnewpro/dhcckb/images/"_imgurl_".png'>"
	
	..w "<section>"
	..w "	<span class='point-time'>"_img_"</span>"
	..w "	<aside>"
	..w "		<span class='things '>"_opText_"  "_desc_"</span><span style='margin-left:50px;font-size:14px;color:#666666'><span class='icon-hos_zp_user'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>"_user_"<span style='margin-left:70px;' ><span class='icon-hos_clock'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>"_$zd(date,3)_" "_$zt(time,1)_"</span></span>"
	..s EntyID=$lg(^CKB.PDSS.DicDataLogD(log),3)
	..s LogItm=$lg(^CKB.PDSS.DicDataLogD(log),5)
	..s LastLogID=$lg(^CKB.PDSS.DicDataLogD(log),6)
	..i LastLogID'="" d
	...s LastLogItm=$lg(^CKB.PDSS.DicDataLogD(LastLogID),5)
	..s spanClass=$case(opType,"add":"text-green","edit":"text-yellow",:"")
	..s opText=$case(opType,"add":"增加","edit":"修改",:"")
	..w "		<p class='brief'>"
	..w "			<span class='"_spanClass_"'>"
	..i LastLogID="" d
	...w "<span style='margin:0px 15px 0px 15px'>增加</span>"_LogItm
	..e  d
	...w "<span style='margin:0px 15px 0px 15px'>修改</span>"_LastLogItm_"<span style='margin:0px 15px 0px 15px;color:black'><b>改为</b></span>"_LogItm
	..w "			</span>"
	..w "		</p>"
	..w "	</aside>"
	..w "</section>"
	
	q ""
}

/// Creator：      lidong
/// CreatDate：    2022-8-8
/// Description:： 药品编辑日志输出
/// Table：        
/// Input:		   药品ID^药品属性ID
/// Others：       w ##class(web.DHCCKBEditPropLog).GetLogDet()
ClassMethod GetLogDete(AttrCodeId, log)
{
	n (AttrCodeId,log)
	s listData = $g(^CKB.PDSS.DicLogD(log))
	s date= $lg(listData,6) 
	s time= $lg(listData,7)
	s opType= $lg(listData,4)
	s user= $lg(listData,5)
	s:+user'=0 user=$p($g(^SSU("SSUSR",user)),"^",2) //hxy 2020-12-14 +$g
	s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(AttrCodeId)),3)
	i desc = ""  d  
	.s linkDr= $lg($g(^CT.CKB.PDSS.CommonDictionD(AttrCodeId)),5)
	.i linkDr'=""  d
	..s desc =$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	s opText=$case(opType,"add":"增加","edit":"修改","grantAuth":"授权",:"") //先将修改 变为增加 2021/9/18
	s color=$case(opType,"add":"green","edit":"yellow","grantAuth":"blue",1:"")
	s colclss=$case(opType,"add":"icon-hos_add_green","edit":"icon-hos_edit_yellow","grantAuth":"icon-hos_rele",:"")
	//s a= "<section>"_""_"<span class='point-time "_colclss_"'></span>"_""_"<aside>"_""_"<span class='things '>"_opText_"  "_desc_"</span>"_""_"<span style='margin-left:50px;font-size:14px;color:#666666'>"_""_"<span class='icon-hos_zp_user'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>"_user_""_""_"<span style='margin-left:70px;' >"_""_"<span class='icon-hos_clock'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>"_$zd(date,3)_" "_$zt(time,1)_""_""_"</span>"_""_"</span>"
	s imgurl=$case(opType,
		"add":"hos_add_green",
		"edit":"hos_edit_yellow",
		"remove":"hos_edit_yellow",
		"release":"hos_rele_blue",
		"cancelRelease":"hos_edit_yellow",
		"grantAuth":"hos_rele_blue",
		:"")
	s img = "<img src='../scripts/dhcnewpro/dhcckb/images/"_imgurl_".png'>"
	s a= "<section>"_""_"<span class='point-time'>"_img_"</span>"_""_"<aside>"_""_"<span class='things '>"_opText_"  "_desc_"</span>"_""_"<span style='margin-left:50px;font-size:14px;color:#666666'>"_""_"<span class='icon-hos_zp_user'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>"_user_""_""_"<span style='margin-left:70px;' >"_""_"<span class='icon-hos_clock'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>"_$zd(date,3)_" "_$zt(time,1)_""_""_"</span>"_""_"</span>"
	s DataLogID=$o(^CKB.PDSS.DicDataLogI("IndexLogID",log,""))
	i DataLogID=""  d
	.s b="<h3></h3>"_""_"</aside>"_""_"</section>"
	e  d
	.s LogItm=$lg(^CKB.PDSS.DicDataLogD(DataLogID),5)
	.s LastLogID=$lg(^CKB.PDSS.DicDataLogD(DataLogID),6)
	.i LastLogID'="" d
	..s LastLogItm=$lg(^CKB.PDSS.DicDataLogD(DataLogID),5)
	.s spanClass=$case(opType,"add":"text-green","edit":"text-yellow")
	.s b="<p class='brief'>"_""_"<span class='"_spanClass_"'>"
	.i LastLogID="" d
	..s b=b_""_ "<span style='margin:0px 15px 0px 15px'>增加</span>"_LogItm
	.e  d
	..s b=b_""_ "<span style='margin:0px 15px 0px 15px'>修改</span>"_LastLogItm_"<span style='margin:0px 15px 0px 15px;color:black'><b>改为</b></span>"_LogItm
	.s b=b_""_ "</span>"_""_"</p>"_""_"</aside>"_""_"</section>"
	s c=a_""_b
	q c
}

/// Creator：      lidong
/// CreatDate：    2022-8-8
/// Description:： 药品编辑药品属性日志
/// Table：        
/// Input:		   药品ID^药品属性ID
/// Others：       w ##class(web.DHCCKBEditPropLog).GetLogDet()
ClassMethod GetDataLogDet()
{
	s DicAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,""))
	s log=$o(^CKB.PDSS.DicLogI("DLGDataDr",DicAttrId,""),-1) 
	s logItm="" f  s logItm=$o(^CKB.PDSS.RuleDataLogI("Parent",log,logItm),-1) q:logItm=""  d
	.s logData = $g(^CKB.PDSS.RuleDataLogD(logItm))
	.s itmOpType= $lg(logData,17)
	.s lastLogItm= $lg(logData,18)
	.s spanClass=$case(itmOpType,"Add":"text-green","Edit":"text-yellow","Remove":"text-red")
	.s opText=$case(itmOpType,"Add":"增加","Edit":"修改","Remove":"删除")
	.s logItmHtml=##class(web.DHCCKBRuleLog).GetLogRuleDataHtml(logItm)
	.s lastLogItmHtml=##class(web.DHCCKBRuleLog).GetLogRuleDataHtml(lastLogItm)
	.w "		<p class='brief'>"
	.w "			<span class='"_spanClass_"'>"
	
	
	.i itmOpType="Add" d
	..w "<span style='margin:0px 15px 0px 15px'>(增加子项)</span>"_logItmHtml
	.i itmOpType="Edit" d
	..w "<span style='margin:0px 15px 0px 15px'>(修改子项)</span>"_lastLogItmHtml_"<span style='margin:0px 15px 0px 15px;color:black'><b>改为</b></span>"_logItmHtml
	.i itmOpType="Remove" d
	..w "<span style='margin:0px 15px 0px 15px'>(删除子项)</span>"_logItmHtml
	.w "			</span>"
	.w "		</p>"
}

}
