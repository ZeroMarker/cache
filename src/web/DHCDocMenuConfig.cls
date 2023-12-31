/// @author:  wanghc
/// @date:    2012/4/14
/// @desc:    为右键菜单做权限配置
Class web.DHCDocMenuConfig Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// d ##class(web.DHCDocMenuConfig).InitWebsysExtMenu()
ClassMethod InitWebsysExtMenu()
{
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText) values('DOCPRNOrder','医生长期医嘱菜单'))
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText) values('DOCSOSOrder','医生临时医嘱菜单'))
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText) values('NURPRNOrder','护士长期医嘱菜单'))
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText) values('NURSOSOrder','护士临时医嘱菜单'))
	
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText) values('NURPRNExec','护士长期执行菜单'))
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText) values('NURSOSExec','护士临时执行菜单'))
	
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText) values('NURPRNFee','护士长期费用菜单'))
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText) values('NURSOSFee','护士临时费用菜单'))

		
	s displayHandler = "{HIDDEN2_Disable:['D','E'],HIDDEN5_Disable:['N^N^N']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMHandler,EMDisplayHandler,EMParentCode) 
	values('DOCPRNOrderStop','停医嘱','stopOrderHandler',:displayHandler,'DOCPRNOrder'))
	
	s displayHandler = "{HIDDEN2_Disable:['D','C','E'],HIDDEN5_Disable:['N^N^N']}"	
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMHandler,EMDisplayHandler,EMParentCode) 
	values('DOCPRNOrderCancel','撤消(DC)','cancelOrderHandler',:displayHandler,'DOCPRNOrder'))
	
	s displayHandler = "{HIDDEN2_Disable:['U','E'],HIDDEN5_Display:['Y^Y^Y']}"		
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMHandler,EMDisplayHandler,EMParentCode) 
	values('DOCPRNOrderUnuse','作废','abortOrderHandler',:displayHandler,'DOCPRNOrder'))
	
	s displayHandler="{HIDDEN4_Display: ['Prn','PRN','prn']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMHandler,EMDisplayHandler,EMParentCode) 
	values('DOCPRNAddExecOrder','增加执行医嘱','addExecOrderHandler',:displayHandler,'DOCPRNOrder'))
	
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode) 
	values('DOCPRNOrderCopyPrn','复制长期','DOCPRNOrder'))
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode) 
	values('DOCPRNOrderCopySos','复制临时','DOCPRNOrder'))	
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMHandler) 
	values('DOCPRNOrderAddNotes','增加备注','DOCPRNOrder','addOrderNotesHandler'))	
	
	//--------------
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMHandler,EMDisplayHandler) 
	values('DOCSOSOrderSurgeryApply','手术申请','DOCSOSOrder','surgeryApplyHandler','surgeryApplyShowHandler'))
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMHandler,EMDisplayHandler) 
	values('DOCSOSOrderConsultation','会诊申请','DOCSOSOrder','consultationHandler','consultationShowHandler'))
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMHandler,EMDisplayHandler) 
	values('DOCSOSOrderBloodApply','输血申请','DOCSOSOrder','bloodApplyHandler','bloodApplyShowHandler'))
	
	s displayHandler = "{HIDDEN2_Disable:['C','E'],HIDDEN5_Disable:['N^N^N']}"		
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMHandler,EMDisplayHandler) 
	values('DOCSOSOrderCancel','撤消(DC)','DOCSOSOrder','cancelOrderHandler',:displayHandler))
	s displayHandler = "{HIDDEN2_Disable:['U','E'],HIDDEN5_Display:['Y^Y^Y']}"		
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMHandler,EMDisplayHandler) 
	values('DOCSOSOrderUnuse','作废','DOCSOSOrder','abortOrderHandler',:displayHandler))	
	
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode) 
	values('DOCSOSOrderCopySos','复制临时','DOCSOSOrder'))
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMHandler) 
	values('DOCSOSOrderAddNotes','增加备注','DOCSOSOrder','addOrderNotesHandler'))
	
	//------------------护士长期医嘱菜单
	s displayHandler = "{HIDDEN2_Disable:['D','E'],HIDDEN5_Disable:['N^N^N']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNOrderStop','停医嘱','NURPRNOrder',:displayHandler,'stopOrderHandler'))
	
	s displayHandler = "{HIDDEN2_Disable:['D','C','E'],HIDDEN5_Disable:['N^N^N']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNOrderCancel','撤消(DC)','NURPRNOrder',:displayHandler,'cancelOrderHandler'))
	
	/*
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMHandler) 
	values('NURPRNOrderAddBillOrder','增加费用医嘱','NURPRNOrder','addBillOrderHandler'))
	*/
	s displayHandler = "{HIDDEN4_Display: ['Prn','PRN','prn']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNOrderAddExecOrder','增加执行医嘱','NURPRNOrder',:displayHandler,'addExecOrderHandler'))
	
	//---------------护士临时医嘱菜单

	s displayHandler = "{HIDDEN2_Disable:['U','E'],HIDDEN5_Display:['Y^Y^Y']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURSOSOrderUnuse','作废','NURSOSOrder',:displayHandler,'abortOrderHandler'))
	
	s displayHandler = "{HIDDEN2_Disable:['C','E'],HIDDEN5_Disable:['N^N^N']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURSOSOrderCancel','撤消(DC)','NURSOSOrder',:displayHandler,'cancelOrderHandler'))
	
	//-----护士长期执行菜单
	s displayHandler = "{TExecStateCode_Display:['未执行','C']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNExecRun','执行','NURPRNExec',:displayHandler,'runExecOrderHandler'))
	
	s displayHandler = "{TExecStateCode_Display:['未执行','C']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNExecStop','停止执行','NURPRNExec',:displayHandler,'stopExecOrderHandler'))
	
	s displayHandler = "{TExecFreeChargeFlag_Disabled: ['免费']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNExecFree','免费','NURPRNExec',:displayHandler,'freeExecOrderHandler'))
	
	s displayHandler = "{TExecFreeChargeFlag_Display: ['免费']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNExecCancelFree','取消免费','NURPRNExec',:displayHandler,'cancelFreeExecOrderHandler'))
	
	s displayHandler = "{TExecStateCode_Display: ['F']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNExecCancel','撤消执行','NURPRNExec',:displayHandler,'cancelExecOrderHandler'))
	
	s displayHandler = "{TExecStateCode_Display:['F']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNExecAddFee','增加费用','NURPRNExec',:displayHandler,'addFeeExecOrderHandler'))
	
	s displayHandler = "{HIDDEN2_Display: ['D']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNExecUpdateHour','修改小时医嘱结束时间','NURPRNExec',:displayHandler,'UpdateHourOrderEndTimeHandler'))
	//-----护士临时执行菜单
	
	s displayHandler = "{TExecStateCode_Display:['未执行','C']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURSOSExecRun','执行','NURSOSExec',:displayHandler,'runExecOrderHandler'))
	
	s displayHandler = "{ HIDDEN2_Display: ['D','C','U'], TExecStateCode_Display:['未执行','C'] }"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURSOSExecStop','停止执行','NURSOSExec',:displayHandler,'stopExecOrderHandler'))
	
	s displayHandler = "{TExecFreeChargeFlag_Disabled: ['免费']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURSOSExecFree','免费','NURSOSExec',:displayHandler,'freeExecOrderHandler'))
	
	s displayHandler = "{TExecFreeChargeFlag_Display: ['免费']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURSOSExecCancelFree','取消免费','NURSOSExec',:displayHandler,'cancelFreeExecOrderHandler'))
	
	s displayHandler = "{TExecStateCode_Display: ['F']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURSOSExecCancel','撤消执行','NURSOSExec',:displayHandler,'cancelExecOrderHandler'))
	
	s displayHandler = "{TExecStateCode_Display:['F']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURSOSExecAddFee','增加费用','NURSOSExec',:displayHandler,'addFeeExecOrderHandler'))
	
	s displayHandler = "{HIDDEN2_Display: ['D']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURSOSExecUpdateHour','修改小时医嘱结束时间','NURSOSExec',:displayHandler,'UpdateHourOrderEndTimeHandler'))
	
	
	//-----费用菜单
	
	s displayHandler = "{HIDDEN2_Disable: ['R']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNFeeCancel','取消费用','NURPRNFee',:displayHandler,'cancelFeeOrderHandler'))
	
	
	s displayHandler = "{HIDDEN2_Disable: ['R']}"
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURSOSFeeCancel','取消费用','NURSOSFee',:displayHandler,'cancelFeeOrderHandler'))
}

/// 更新显示函数,把停止 撤销 作废标志分成三列
ClassMethod updateDisplay()
{
	;StopPermission,CancelPermission,UnusePermission
	
	s displayHandler = "{HIDDEN2_Disable:['D','E'],StopPermission_Disable:['0']}"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCPRNOrderStop')
	
	s displayHandler = "{HIDDEN2_Disable:['D','E'],CancelPermission_Disable:['0']}"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCPRNOrderCancel')
	
	s displayHandler = "{HIDDEN2_Disable:['D','E'],UnusePermission_Disable:['0']}"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCPRNOrderUnuse')

	s displayHandler = "{HIDDEN2_Disable:['D','E'],UnusePermission_Disable:['0']}"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCSOSOrderUnuse')

	s displayHandler = "{HIDDEN2_Disable:['D','E'],CancelPermission_Disable:['0']}"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCSOSOrderCancel')

	s displayHandler = "{HIDDEN2_Disable:['D','E'],StopPermission_Disable:['0']}"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNOrderStop')

	s displayHandler = "{HIDDEN2_Disable:['D','E'],CancelPermission_Disable:['0']}"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNOrderCancel')

	s displayHandler = "{HIDDEN2_Disable:['D','E'],UnusePermission_Disable:['0']}"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSOrderUnuse')

	s displayHandler = "{HIDDEN2_Disable:['D','E'],CancelPermission_Disable:['0']}"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSOrderCancel')
	
	s displayHandler = "{HIDDEN2_Disable:['D','E'],UnusePermission_Disable:['0']}"		
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNOrderUnuse','作废','NURPRNOrder',:displayHandler,'abortOrderHandler'))
}

ClassMethod updateDisplayFun()
{
	s displayHandler = "stopOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCPRNOrderStop')
	s displayHandler = "cancelOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCPRNOrderCancel')
	s displayHandler = "abortOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCPRNOrderUnuse')
	s displayHandler = "addExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCPRNAddExecOrder')
	
	s displayHandler = "abortOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCSOSOrderUnuse')
	s displayHandler = "cancelOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='DOCSOSOrderCancel')

	s displayHandler = "stopOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNOrderStop')
	s displayHandler = "cancelOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNOrderCancel')
	s displayHandler = "abortOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNOrderUnuse')
	s displayHandler = "addExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNOrderAddExecOrder')
	
	s displayHandler = "abortOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSOrderUnuse')
	s displayHandler = "cancelOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSOrderCancel')
	
	s displayHandler = "runExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNExecRun')
	s displayHandler = "stopExecPrnOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNExecStop')
	s displayHandler = "freeExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNExecFree')
	s displayHandler = "cancelFreeExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNExecCancelFree')
	s displayHandler = "cancelExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNExecCancel')
	s displayHandler = "addFeeExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNExecAddFee')
	s displayHandler = "UpdateHourOrderEndTimeShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNExecUpdateHour')
	
	s displayHandler = "runExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSExecRun')
	s displayHandler = "stopExecSosOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSExecStop')
	s displayHandler = "freeExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSExecFree')
	s displayHandler = "cancelFreeExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSExecCancelFree')
	s displayHandler = "cancelExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSExecCancel')
	s displayHandler = "addFeeExecOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSExecAddFee')	
	s displayHandler = "UpdateHourOrderEndTimeShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSExecUpdateHour')
		
	s displayHandler = "cancelFeeOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURPRNFeeCancel')
	s displayHandler = "cancelFeeOrderShowHandler"
	&sql(update sqluser.websys.ExtMenu set EMDisplayHandler=:displayHandler where EMCode='NURSOSFeeCancel')
}

/// 获得树的json串
/// w ##class(web.DHCDocMenuConfig).GetExtTreeJson("menuTreeRoot",1)
ClassMethod GetExtTreeJson(parentNode, groupid)
{
	q:groupid="" ""
	;i parentNode="" s parentNode=-100000000000000
	i parentNode="menuTreeRoot" s parentNode=""
	s parentNode = " "_$$ALPHAUP^SSUTIL4(parentNode)
	s treejson=""	
	s index=0 f  s index = $o(^websys.ExtMenuI("EMChildrenMenu",parentNode,index)) q:index=""  d
	.s id = 0 f  s id = $o(^websys.ExtMenuI("EMChildrenMenu",parentNode,index,id)) q:id=""  d
	..s obj = ##class(websys.ExtMenu).%OpenId(id,0)
	..s checkflag=0
	..i $d(^SSU("SSGRP",groupid,"Menu")) d
	...s checkflag=$bit($p(^SSU("SSGRP",groupid,"Menu"),"^",1),id) 
	..s checkflag=$s(checkflag:"true",1:"false")
	..i treejson="" s treejson = obj.GetTreeNodeJson(checkflag)
	..e  s treejson=treejson_","_obj.GetTreeNodeJson(checkflag)
	..d obj.%Close()
	..s obj = ""
	q "["_treejson_"]"
}

/*
ClassMethod GetExtMenuJson(node)
{
	m menu = ^websys.ExtMenu
	s json=""
	if (node="menuTreeRoot") d
	. s root="" f  s root=$o(menu(root)) q:root=""  d
	. . s item = "{text:'"_menu(root)_"', id:'"_root_"'}"
	. . i json = "" s json = item
	. . e  s json=json_","_item
	else  d
	. s gbl="", ind="" 
	. s len=$l(node,"-")
	. f i=1:1:len d
	. . s item = """"_$p(node,"-",i)_""""
	. . i gbl="" s gbl = "menu("_item
	. . e  s gbl=gbl_","_item
	. s gbl=gbl_",ind)"
	. f  d GetItemJson q:ind=""  d
	. .d DataGbl
	. .s treenode="{text:'"_text_"',id:'"_node_"-"_ind_"',leaf:"_$s(dataflag=1:"true",1:"false")_",checked:false}"  
	. .i json="" s json=treenode
	. .e  s json=json_","_treenode
	q "["_json_"]"

GetItemJson
	s oexec = "ind=$o("_gbl_")"
	s @oexec
	q:ind=""
	s vexec = "text="_gbl
	s @vexec
	q
DataGbl
	s dexec = "dataflag=$d("_gbl_")"
	s @dexec	
	q
}*/
/// @params:  code1!0^code2!1   0表示没有权限 ,1表示有权限
/// d ##class(web.DHCDocMenuConfig).SaveMenuGroupSetting("DOCPRN^DOCPRNStop^DOCPRNCancel",21)
ClassMethod SaveMenuGroupSetting(codes, groupid)
{
	s ^Temp("wanghc","savegtl")=codes_","_groupid
	q:groupid="" 100
	q:codes="" 100
	s len=$l(codes,"^")
	s gobj = ##class(User.SSExtMeunGroup).%OpenId(groupid)
	q:'$IsObject(gobj)
	s menubit=gobj.DHCEMGExtMenu
	f j=1:1:len d
	.s code=$p($p(codes,"^",j),"!",1)
	.s grant = $p($p(codes,"^",j),"!",2)
	.q:code=""
	.s id = $O(^websys.ExtMenuI("EMCodeMenu"," "_$$ALPHAUP^SSUTIL4(code),""))
	.q:id=""
	.s $bit(menubit,id)=grant	
	s gobj.DHCEMGExtMenu = menubit
	d gobj.%Save()
	d gobj.%Close()
	s gobj=""	
	q 0
}

ClassMethod GetGroupTreeJson(groupDesc = "")
{
	
	s rtnJson=""
	s rowid=0 f  s rowid=$o(^SSU("SSGRP",rowid)) q:rowid=""  d
	.s Desc=$p(^SSU("SSGRP",rowid),"^",1)
	.q:(groupDesc'="")&&($$ALPHAUP^SSUTIL4(Desc)'[$$ALPHAUP^SSUTIL4(groupDesc))
	.if rtnJson="" d
	..s rtnJson=rtnJson_"{id:'"_rowid_"',text:'"_Desc_"',leaf:true}"
	.else  d
	..s rtnJson=rtnJson_",{id:'"_rowid_"',text:'"_Desc_"',leaf:true}"
	q "["_rtnJson_"]"
}

ClassMethod GetMenuItemInfo(code)
{
	s id = $O(^websys.ExtMenuI("EMCodeMenu"," "_$$ALPHAUP^SSUTIL4(code),""))
	q:id="" "{}"
	s obj = ##class(websys.ExtMenu).%OpenId(id,0)
	s jsonObj = ##class(ext.util.JsonObject).%New()
	s json = jsonObj.FromObject(obj).Json()
	d jsonObj.%Close()
	s jsonObj=""
	Q json
}

/// reqJson=EMParentCode=DOCSOSOrder&EMCode=DOCSOSOrderConsultation&EMText=%E4%BC%9A%E8%AF%8A%E7%94%B3%E8%AF%B7&EMHandler=consultationHandler&EMDisplayHandler=&EMCls=&EMItemIndex=&ID=14
ClassMethod SaveExtMenu(reqJson)
{
	s jsonObj = ##class(ext.util.JsonObject).%New()
	s jsonObj.ContainNullValue=1	//删除属性值时用到
	d jsonObj.FromObject(reqJson)
	s obj = jsonObj.Bean("websys.ExtMenu")
	s sc = obj.%Save()
	If $$$ISERR(sc) Quit "-306"
	q 0
}

ClassMethod DeleteExtMenu(code)
{
	s index="",parentCode = " "_$$ALPHAUP^SSUTIL4(code),sc=$$$OK
	q:$$$ISERR(sc) "sc"
	f  s index=$o(^websys.ExtMenuI("EMChildrenMenu",parentCode,index)) q:(index="")||($$$ISERR(sc))  d
	.s id="" f  s id = $o(^websys.ExtMenuI("EMChildrenMenu",parentCode,index,id)) q:(id="")||($$$ISERR(sc))  d
	..s sc = ##class(websys.ExtMenu).%DeleteId(id)
	Q:$$$ISERR(sc) "-306"
	s id = $O(^websys.ExtMenuI("EMCodeMenu",parentCode,""))
	s sc = ##class(websys.ExtMenu).%DeleteId(id)
	Q:$$$ISERR(sc) "-306"
	q 0
}

}
