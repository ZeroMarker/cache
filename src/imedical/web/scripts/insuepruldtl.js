/**
 * FileName: insuepruldtl.js
 * Description: 患者结算清单查询
 */
 var PageLogicObj={
	m_OPSpecilDiagDataGrid:""
}
 
 $(function(){
	//初始化
	Init();
	initQueryMenu();
})

function Init(){
	PageLogicObj.m_OPSpecilDiagDataGrid=initopspdiseinfo();
	PageLogicObj.m_OPSpecilDiagDataGrid=initIPDiagnosis();
	PageLogicObj.m_OPSpecilDiagDataGrid=initOprninfo();
	PageLogicObj.m_OPSpecilDiagDataGrid=initIteminfo();
	PageLogicObj.m_OPSpecilDiagDataGrid=initPayinfo();
	PageLogicObj.m_OPSpecilDiagDataGrid=initIcuinfo();
}

function initQueryMenu() {
	var url = window.location.href
	var Rowid=url.split("Rowid=")[1].split("&")[0]
	var Flag=url.split("Flag=")[1]
	if(Flag=="A"){   ///后清单
		var jsonStr=tkMakeServerCall("web.DHCINSUEprUl","Getinargs",Rowid)
		if ((jsonStr=="-1")||(jsonStr=="")){
			$.messager.alert('Tips','清单未上传');
			return;
		}		
	}else{			///前清单
		var jsonStr=tkMakeServerCall("web.DHCINSUEprUl","GetErpStr",Rowid)
		if ((jsonStr=="-1")||(jsonStr=="")){
			$.messager.alert('Tips','取数据出错');
			return;
		}
	}
		var inJson=JSON.parse(jsonStr);
		// datagrid数据格式		
		if(inJson.input.diseinfo){
			var datagridData = {total:inJson.input.diseinfo.length,rows:inJson.input.diseinfo};
			if(datagridData.rows){$("#diseinfo").datagrid('loadData',datagridData)};
		}	
		if(inJson.input.iteminfo){
			var datagridData = {total:inJson.input.iteminfo.length,rows:inJson.input.iteminfo};
			if(datagridData.rows){$("#iteminfo").datagrid('loadData',datagridData)};
		}
		if(inJson.input.payinfo){
			var datagridData = {total:inJson.input.payinfo.length,rows:inJson.input.payinfo};
			if(datagridData.rows){$("#payinfo").datagrid('loadData',datagridData)};
		}
		if(inJson.input.opspdiseinfo){
			var datagridData = {total:inJson.input.payinfo.length,rows:inJson.input.opspdiseinfo};
			if(datagridData.rows){$("#opspdiseinfo").datagrid('loadData',datagridData)};
		}
		if(inJson.input.oprninfo){
			var datagridData = {total:inJson.input.payinfo.length,rows:inJson.input.oprninfo};
			if(datagridData.rows){$("#oprninfo").datagrid('loadData',datagridData)};
		}
		if(inJson.input.icuinfo){
			var datagridData = {total:inJson.input.payinfo.length,rows:inJson.input.icuinfo};
			if(datagridData.rows){$("#icuinfo").datagrid('loadData',datagridData)};
		}
		// 获取所有name属性为QUERY的dom节点
		var dp =document.getElementsByName("QUERY");
		// 遍历所有节点
		for (var i = 0;i<dp.length;i++){
			// 获取节点id
			// console.log(dp[i].id);
			var DomId = dp[i].id
			// console.log(inJson[DomId]);
			// 注意： 返回数据的key值和dom节点的id名要一致
			// inJson[DomId]要使用必须先判断该key是否存在
			if(DomId){
				var DomSelect = "#" + DomId;
				if(inJson.input.setlinfo[DomId]){
					$(DomSelect).val(inJson.input.setlinfo[DomId]);
				}				
			}
		}
}
function initopspdiseinfo() {
	$HUI.datagrid('#opspdiseinfo', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		columns: [[{
					title: '诊断名称',
					field: 'settlementId',
					align: 'center',
					width: 300
				}, {
					title: '诊断代码',
					field: 'diag_code',
					align: 'center',
					width: 200
				}, {
					title: '手术操作名称',
					field: 'oprn_oprt_name',
					align: 'center',
					width: 300
				}, {
					title: '手术操作代码',
					field: 'oprn_oprt_code',
					align: 'center',
					width: 200
				}
			]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
			}
		
	});
}

function initIPDiagnosis() {
	$HUI.datagrid('#diseinfo', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		columns: [[{
					title: '诊断类别',
					field: 'diag_type',
					align: 'center',
					width: 100
				}, {
					title: '诊断代码',
					field: 'diag_code',
					align: 'center',
					width: 300
				}, {
					title: '诊断名称',
					field: 'diag_name',
					align: 'center',
					width: 300
				},{
					title: '入院病情',
					field: 'adm_cond_type',
					align: 'center',
					width: 100
				}
			]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
			}
		
	});
}

function initOprninfo() {
	$HUI.datagrid('#oprninfo', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		columns: [[{
					title: '手术操作类别',
					field: 'oprn_oprt_type',
					align: 'center',
					width: 100
				}, {
					title: '手术操作名称',
					field: 'oprn_oprt_name',
					align: 'center',
					width: 300
				}, {
					title: '手术操作代码',
					field: 'oprn_oprt_code',
					align: 'center',
					width: 200
				}, {
					title: '手术操作日期',
					field: 'oprn_oprt_date',
					align: 'center',
					width: 100
				}, {
					title: '麻醉方式',
					field: 'anst_way',
					align: 'center',
					width: 100
				}, {
					title: '术者医师姓名',
					field: 'oper_dr_name',
					align: 'center',
					width: 100
				}, {
					title: '术者医师代码',
					field: 'oper_dr_code',
					align: 'center',
					width: 100
				}
			]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
			}
		
	});
}

function initIteminfo() {
	$HUI.datagrid('#iteminfo', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		columns: [[{
					title: '医疗收费项目',
					field: 'med_chrgitm',
					align: 'center',
					width: 200
				}, {
					title: '金额',
					field: 'amt',
					align: 'center',
					width: 200
				}, {
					title: '甲类费用合计',
					field: 'claa_sumfee',
					align: 'center',
					width: 200
				}, {
					title: '乙类金额',
					field: 'clab_amt',
					align: 'center',
					width: 200
				}, {
					title: '全自费金额',
					field: 'fulamt_ownpay_amt',
					align: 'center',
					width: 200
				}, {
					title: '其他金额',
					field: 'oth_amt',
					align: 'center',
					width: 200
				}
			]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
			}
		
	});
}


function initPayinfo() {
	$HUI.datagrid('#payinfo', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		columns: [[{
					title: '基金支付类型',
					field: 'fund_pay_type',
					align: 'center',
					width: 300
				}, {
					title: '基金支付金额',
					field: 'fund_payamt',
					align: 'center',
					width: 200
				}
			]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
			}
		
	});
}

function initIcuinfo() {
	$HUI.datagrid('#icuinfo', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		columns: [[{
					title: '重症监护病房类型',
					field: 'scs_cutd_ward_type',
					align: 'center',
					width: 300
				}, {
					title: '重症监护进入时间',
					field: 'scs_cutd_inpool_time',
					align: 'center',
					width: 300
				}, {
					title: '重症监护退出时间',
					field: 'scs_cutd_exit_time',
					align: 'center',
					width: 300
				}, {
					title: '重症监护合计时长',
					field: 'scs_cutd_sum_dura',
					align: 'center',
					width: 300
				}
			]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
			}
		
	});
}
