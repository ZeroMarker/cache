Class web.DHCJFInsertTreeAndLink Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(web.DHCJFInsertTreeAndLink).Insert()
ClassMethod Insert()
{
   s $zt="GetError"
   d ##class(web.DHCJFInsertTreeAndLink).tb()
   &SQL(delete from SQLUSER.DHC_TreeNode)
   &SQL(delete from SQLUSER.DHC_TreeGroupLink)
   s ^mdata("DHCTREENODE")=0
   S ^mdata("DHCTREEGROUPLINK")=0
	;树节点值的设置
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('点餐系统','bookMealMenuTree',"",'false',0,'mainFrame',''))  //1
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('点餐配置','bookMealMenuTree',"",'false',1,'mainFrame',''))	//1
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('点餐业务','bookMealMenuTree','udhcopbill.csp','false',1,'mainFrame',''))  //1
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('点餐查询','bookMealMenuTree','DHCJFBillCodeManage.csp','false',1,'mainFrame',''))	//1
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('权限分配','bookMealMenuTree',"",'false',1,'mainFrame',''))  //1
	
	
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('餐类型维护 ','bookMealMenuTree','dhcipmeal.setmealtype.csp','true',2,'mainFrame',''))	//39
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('餐形态维护','bookMealMenuTree','dhcipmeal.setmealmodality.csp','true',2,'mainFrame',''))	//40
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('菜定义维护','bookMealMenuTree','dhcipmeal.setfooditem.csp','true',2,'mainFrame',''))	//41
    &SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('菜单位维护 ','bookMealMenuTree','dhcipmeal.setmealuom.csp','true',2,'mainFrame',''))
	
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('周菜谱制作','bookMealMenuTree','dhcipmeal.setmealmenu.csp','true',3,'mainFrame',''))	//43
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('订餐','bookMealMenuTree','dhcipmeal.bookmeal.csp','true',3,'mainFrame',''))	//44
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('结账','bookMealMenuTree','dhcipmeal.bill.csp','true',3,'mainFrame',''))	//45
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('周菜谱操作','bookMealMenuTree','dhcipmeal.mealmenuoperation.csp','true',3,'mainFrame',''))
	
	
	//&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('送餐汇总表','bookMealMenuTree','dhcipmeal.createmenubook.csp','true',4,'mainFrame',''))	//47
	//&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('订餐明细查询','bookMealMenuTree','dhcipmeal.findmealbookinfobyward.csp','true',4,'mainFrame',''))	//48
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('订餐明细查询','bookMealMenuTree','dhcipmeal.statdetailsbymodward.csp','true',4,'mainFrame',''))	//48
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('订餐病区汇总','bookMealMenuTree','dhcipmeal.statbymealtypeward.csp','true',4,'mainFrame',''))	//48
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('病人膳食费用','bookMealMenuTree','dhcipmeal.statpatfeebydatemedicare.csp','true',4,'mainFrame',''))	//48
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('膳食医嘱明细','bookMealMenuTree','dhcipmeal.statwardorderdetail.csp','true',4,'mainFrame',''))	//48
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('退费明细查询','bookMealMenuTree','dhcipmeal.statstrikeinfobydate.csp','true',4,'mainFrame',''))	//48
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('病区餐率统计','bookMealMenuTree','dhcipmeal.statwardprecentbydate.csp','true',4,'mainFrame',''))	//48
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('工作量统计表','bookMealMenuTree','dhcipmeal.statcashierworkbydate.csp','true',4,'mainFrame',''))	//48
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('发餐统计','bookMealMenuTree','dhcipmeal.mealsendoutdiet.csp','true',4,'mainFrame',''))	//48
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('菜订单统计','bookMealMenuTree','dhcipmeal.bookitmdetailbydate.csp','true',4,'mainFrame',''))	//48
	&SQL(insert into SQLUSER.DHC_TreeNode(TN_Text,TN_Code,TN_Href,TN_Leaf,TN_ParrentNode_Dr,TN_HrefTarget,TN_UserClass) values ('权限分配','bookMealMenuTree','dhcipmeal.granttree.csp','true',5,'mainFrame',''))	//51
	;权限表
	&sql(select count(1) into :sumTreeNode from SQLUSER.DHC_TreeNode)
	for i=1:1:sumTreeNode d
	.&SQL(insert into SQLUSER.DHC_TreeGroupLink(TGL_Group_Dr,TGL_TreeNode_Dr,TGL_UseRight) values (1,:i,'Y'))
	.&SQL(insert into SQLUSER.DHC_TreeGroupLink(TGL_Group_Dr,TGL_TreeNode_Dr,TGL_UseRight) values (206,:i,'Y'))
	
	d ##class(web.DHCJFInsertTreeAndLink).tc()
	q SQLCODE
GetError()
    b ;'11
	w !,$g(%msg)_"SQLCODE="_SQLCODE_" err"
	TROLLBACK
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	N SQLCODE
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
