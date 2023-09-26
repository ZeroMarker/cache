Import sqluser

Class web.DHCSTMHUI.Tools.CreateApp Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 插入应用代码\应用单号数据
/// d ##class(web.DHCSTMHUI.Tools.CreateApp).App(HospId)  
ClassMethod App(HospId = "")
{
	//插入APP
	//公共
	i ..getpar("DHCSTCOMMONM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTCOMMONM', '公共M', 'M', 'M', '1'))
	//窗口小贴士
	i ..getpar("DHCSTTIPSWIN")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTTIPSWIN', '工作台M', 'M', 'Q', '2'))
	//物资维护
	i ..getpar("DHCSTDRUGMAINTAINM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTDRUGMAINTAINM', '物资维护M', 'M', 'M', '3'))
	//库存转移请求
	i ..getpar("DHCSTINREQM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTINREQM', '库存转移请求M', 'M', 'B', '4'))
	//采购计划
	i ..getpar("DHCSTPURPLANAUDITM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTPURPLANAUDITM', '采购计划M', 'M', 'B', '5'))
	//订单
	i ..getpar("DHCSTPOM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTPOM', '订单M', 'M', 'B', '6'))
	//入库
	i ..getpar("DHCSTIMPORTM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTIMPORTM', '入库M', 'M', 'B', '7'))
	//库存转移
	i ..getpar("DHCSTTRANSFERM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTTRANSFERM', '库存转移M', 'M', 'B', '8'))
	//退货
	i ..getpar("DHCSTRETURNM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTRETURNM', '退货M', 'M', 'B', '9'))
	//库存调整
	i ..getpar("DHCSTSTOCKADJM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTSTOCKADJM', '库存调整M', 'M', 'B', '10'))
	//库存报损
	i ..getpar("DHCSTINSCRAPM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTINSCRAPM', '库存报损M', 'M', 'B', '11'))
	//盘点帐盘
	i ..getpar("DHCSTINSTKTKM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTINSTKTKM', '盘点帐盘M', 'M', 'B', '12'))
	;红冲
	i ..getpar("DHCSTMREDOFFSET")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTMREDOFFSET', '红冲', 'M', 'B', '13'))
	//高值跟踪
	i ..getpar("DHCITMTRACKM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCITMTRACKM', '高值跟踪M', 'M', 'B', '14'))
	//高值医嘱提取
	i ..getpar("HVMatOrdItm")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('HVMatOrdItm', '高值医嘱提取M', 'M', 'B', '15')) 
	;高值点评
	i ..getpar("DHCSTMCOMMENT")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTMCOMMENT', '高值点评', 'M', 'B', '16'))
	//发票组合
	i ..getpar("DHCSTVendorINVM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTVendorINVM', '发票组合M', 'M', 'B', '17'))	
	//付款
	i ..getpar("DHCSTPAYM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTPAYM', '付款M', 'M', 'B', '18'))
	;付款封面
	i ..getpar("DHCSTMRECCOVERM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTMRECCOVERM', '付款封面', 'M', 'B', '19'))
	;报销支付单
	i ..getpar("DHCSTMDHCREIMPAY")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTMDHCREIMPAY', '报销支付单', 'M', 'B', '20'))
	//月报
	i ..getpar("DHCSTKMONREPM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTKMONREPM', '月报M', 'M', 'B', '21'))
	//付款月报
	i ..getpar("DHCSTMPAYMON")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTMPAYMON', '付款月报M', 'M', 'B', '22'))
	//科室内部请领
	i ..getpar("DHCINDISPREQM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCINDISPREQM', '科室内部请领M', 'M', 'B', '23'))
	//科室内部发放
	i ..getpar("DHCSTINDISPM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTINDISPM', '科室内部发放M', 'M', 'B', '24'))
	//科室内部退回
	i ..getpar("DHCSTINDISPRETM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTINDISPRETM', '科室内部退回M', 'M', 'B', '25'))
	//科室内部公共支出分配
	i ..getpar("DHCSTSLGALLOTM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTSLGALLOTM', '科室内部公共支出分配M', 'M', 'B', '26'))
	//物资门诊发放
	i ..getpar("DHCSTMATDISPM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTMATDISPM', '物资门诊发放M', 'M', 'B', '27'))
	//物资门诊退回
	i ..getpar("DHCSTMATDISPRETM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTMATDISPRETM', '物资门诊退回M', 'M', 'B', '28'))
	;住院发放
	i ..getpar("DHCSTINMATDISPM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTINMATDISPM', '物资住院发放M', 'M', 'B', '29'))
	;住院退回
	i ..getpar("DHCSTINMATDISPRETM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTINMATDISPRETM', '物资住院退回M', 'M', 'B', '30'))
	//被服类管理
	i ..getpar("DHCSTBCM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTBCM', '被服类管理M', 'M', 'B', '31'))
	//调价
	i ..getpar("DHCSTADJSPM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTADJSPM', '调价M', 'M', 'B', '32'))
	//批次调价
	i ..getpar("DHCSTADJSPBATCHM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTADJSPBATCHM', '批次调价M', 'M', 'B', '33'))
	//供应商管理
	i ..getpar("DHCSTVENDORMTM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTVENDORMTM', '供应商管理M', 'M', 'B', '34'))
	//生产厂家管理
	i ..getpar("DHCSTPHMANFM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTPHMANFM', '生产厂家管理M', 'M', 'B', '35'))
	//应用程序语法
	i ..getpar("DHCSTPARAMERM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTPARAMERM', '应用程序语法M', 'M', 'Q', '36'))
	//新项申请
	i ..getpar("DHCSTNEWITMM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTNEWITMM', '新项申请M', 'M', 'B', '37'))
	//二级库快捷盘点
	i ..getpar("DHCSTSUBLOCSTKTKM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTSUBLOCSTKTKM', '二级库快捷盘点M', 'M', 'B', '38'))
	//虚拟入库
	i ..getpar("DHCSTVIRIMPORTM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTVIRIMPORTM', '虚拟入库M', 'M', 'B', '39'))
	//FTP文件操作
	i ..getpar("DHCSTFTPFILEM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTFTPFILEM', 'FTP文件操作M', 'M', 'B', '40'))
	//试剂Lis接口
	i ..getpar("DHCSTMSERFORLISM")="" d
	.&sql(INSERT INTO DHC_Stksysapp(ssa_code,ssa_desc,ssa_grptype,ssa_modutype,SSA_SortNum) VALUES ('DHCSTMSERFORLISM', '试剂Lis接口M', 'M', 'B', '41'))
	;勿删
	q ""
}

/// 根据应用代码查找其RowId
ClassMethod getpar(appname) As %String
{
	n (appname)
	s rowid=""
	&sql(select %id into :rowid from dhc_stksysapp where ssa_code=:appname)  
	q rowid
}

}
