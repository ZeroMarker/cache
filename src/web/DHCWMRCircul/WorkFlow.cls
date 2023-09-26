Import SQLUser

/// 公共字典信息
Class web.DHCWMRCircul.WorkFlow Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 33;

ClassMethod GetWorkItemsByUserGroup(WFlowId, UserGroupId)
{
	n (WFlowId,UserGroupId)
	s ret=""
	
	s ModuleName="DHCWMR"
	q:(WFlowId="")||(UserGroupId="") ret
	q:'$d(^DHCWMRWFLOW(WFlowId,"S")) ret
	s SubId=0
	f  s SubId=$o(^DHCWMRWFLOW(WFlowId,"S",SubId)) q:SubId=""  d
	.s WItemId=$p($g(^DHCWMRWFLOW(WFlowId,"S",SubId)),"^",2)
	.q:WItemId=""
	.s WItemDesc=$p($g(^DHCWMRWITM(WItemId)),"^",2)
	.s MenuName=WItemDesc
	.s flg=##Class(web.DHCWMRCommon.UserFunction).UserFunction(UserGroupId,ModuleName,MenuName)
	.s:flg=0 ret=ret_"$"_WItemId_"^"_WItemDesc
	
	s:ret'="" ret=$e(ret,2,$l(ret))
	q ret
}

ClassMethod GetWorkItemsByUserGroup01(WFlowId, UserGroupId)
{
	n (WFlowId,UserGroupId)
	s ret=""
	
	s ModuleName="DHCWMR"
	q:(WFlowId="")||(UserGroupId="") ret
	q:'$d(^DHCWMRWFLOW(WFlowId,"S")) ret
	s SubId=0
	f  s SubId=$o(^DHCWMRWFLOW(WFlowId,"S",SubId)) q:SubId=""  d
	.q:SubId=$o(^DHCWMRWFLOW(WFlowId,"S",0))
	.s WItemId=$p($g(^DHCWMRWFLOW(WFlowId,"S",SubId)),"^",2)
	.q:WItemId=""
	.s WItemDesc=$p($g(^DHCWMRWITM(WItemId)),"^",2)
	.s MenuName=WItemDesc
	.s flg=##Class(web.DHCWMRCommon.UserFunction).UserFunction(UserGroupId,ModuleName,MenuName)
	.s:flg=0 ret=ret_"$"_WItemId_"^"_WItemDesc
	
	s:ret'="" ret=$e(ret,2,$l(ret))
	q ret
}

ClassMethod GetWorkItemById(Rowid)
{
	n (Rowid)
	s ret=""
	
	s TMP=$g(^DHCWMRWITM(+Rowid))
	q:TMP="" ret
	s SubId=0,IsItemDtl="N"
	f  s SubId=$o(^DHCWMRWITM(+Rowid,"L",SubId)) q:(SubId="")||(IsItemDtl="Y")  d
	.s tmp=$g(^DHCWMRWITM(+Rowid,"L",SubId))
	.q:$p(tmp,"^",3)'="Y"
	.s IsItemDtl="Y"
	
	s ret=Rowid_"^"_TMP_"^"_IsItemDtl
	q ret
}

ClassMethod GetWorkFlowsByUserGroup(MrType, UserGroupId)
{
	n (MrType,UserGroupId)
	s ret=""
	
	s ModuleName="DHCWMR"
	q:(MrType="")||(UserGroupId="") ret
	
	k ^CacheTemp($zn,$j,"DHCWorkFlow")
	s Active=""
	f  s Active=$o(^DHCWMRWFLOW(0,"TypeActive",MrType,Active)) q:Active=""  d
	.s WFlowId=0
	.f  s WFlowId=$o(^DHCWMRWFLOW(0,"TypeActive",MrType,Active,WFlowId)) q:WFlowId=""  d
	..s SubId=0
	..f  s SubId=$o(^DHCWMRWFLOW(WFlowId,"S",SubId)) q:SubId=""  d
	...s WItemId=$p($g(^DHCWMRWFLOW(+WFlowId,"S",SubId)),"^",2)
	...s MenuName=$p($g(^DHCWMRWITM(+WItemId)),"^",2)
	...q:MenuName=""
	...s flg=##Class(web.DHCWMRCommon.UserFunction).UserFunction(UserGroupId,ModuleName,MenuName)
	...s:flg=0 ^CacheTemp($zn,$j,"DHCWorkFlow",WFlowId)=""
	
	s WFlowId=0
	f  s WFlowId=$o(^CacheTemp($zn,$j,"DHCWorkFlow",WFlowId)) q:WFlowId=""  d
	.s WFlowDesc=$p($g(^DHCWMRWFLOW(WFlowId)),"^",2)
	.s ret=ret_"$"_WFlowId_"^"_WFlowDesc
	
	k ^CacheTemp($zn,$j,"DHCWorkFlow")
	s:ret'="" ret=$e(ret,2,$l(ret))
	q ret
}

ClassMethod GetWorkItemsByFlow(WorkFlow)
{
	n (WorkFlow)
	s ret=""
	
	q:WorkFlow="" ret
	s SubId=0
	f  s SubId=$o(^DHCWMRWFLOW(WorkFlow,"S",SubId)) q:SubId=""  d
	.s tmpItem=$g(^DHCWMRWFLOW(WorkFlow,"S",SubId))
	.q:tmpItem=""
	.s TMP=WorkFlow_"||"_SubId_"^"_$p(tmpItem,"^",1)_"^"_$p(tmpItem,"^",2)
	.s ret=ret_$c(1)_TMP
	
	s:ret'="" ret=$e(ret,2,$l(ret))
	q ret
}

}
