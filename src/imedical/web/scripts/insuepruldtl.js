/**
 * FileName: insuepruldtl.js
 * Description: ���߽����嵥��ѯ
 */
 var PageLogicObj={
	m_OPSpecilDiagDataGrid:""
}
 
 $(function(){
	//��ʼ��
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
	if(Flag=="A"){   ///���嵥
		var jsonStr=tkMakeServerCall("web.DHCINSUEprUl","Getinargs",Rowid)
		if ((jsonStr=="-1")||(jsonStr=="")){
			$.messager.alert('Tips','�嵥δ�ϴ�');
			return;
		}		
	}else{			///ǰ�嵥
		var jsonStr=tkMakeServerCall("web.DHCINSUEprUl","GetErpStr",Rowid)
		if ((jsonStr=="-1")||(jsonStr=="")){
			$.messager.alert('Tips','ȡ���ݳ���');
			return;
		}
	}
		var inJson=JSON.parse(jsonStr);
		// datagrid���ݸ�ʽ		
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
		// ��ȡ����name����ΪQUERY��dom�ڵ�
		var dp =document.getElementsByName("QUERY");
		// �������нڵ�
		for (var i = 0;i<dp.length;i++){
			// ��ȡ�ڵ�id
			// console.log(dp[i].id);
			var DomId = dp[i].id
			// console.log(inJson[DomId]);
			// ע�⣺ �������ݵ�keyֵ��dom�ڵ��id��Ҫһ��
			// inJson[DomId]Ҫʹ�ñ������жϸ�key�Ƿ����
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
					title: '�������',
					field: 'settlementId',
					align: 'center',
					width: 300
				}, {
					title: '��ϴ���',
					field: 'diag_code',
					align: 'center',
					width: 200
				}, {
					title: '������������',
					field: 'oprn_oprt_name',
					align: 'center',
					width: 300
				}, {
					title: '������������',
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
					title: '������',
					field: 'diag_type',
					align: 'center',
					width: 100
				}, {
					title: '��ϴ���',
					field: 'diag_code',
					align: 'center',
					width: 300
				}, {
					title: '�������',
					field: 'diag_name',
					align: 'center',
					width: 300
				},{
					title: '��Ժ����',
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
					title: '�����������',
					field: 'oprn_oprt_type',
					align: 'center',
					width: 100
				}, {
					title: '������������',
					field: 'oprn_oprt_name',
					align: 'center',
					width: 300
				}, {
					title: '������������',
					field: 'oprn_oprt_code',
					align: 'center',
					width: 200
				}, {
					title: '������������',
					field: 'oprn_oprt_date',
					align: 'center',
					width: 100
				}, {
					title: '����ʽ',
					field: 'anst_way',
					align: 'center',
					width: 100
				}, {
					title: '����ҽʦ����',
					field: 'oper_dr_name',
					align: 'center',
					width: 100
				}, {
					title: '����ҽʦ����',
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
					title: 'ҽ���շ���Ŀ',
					field: 'med_chrgitm',
					align: 'center',
					width: 200
				}, {
					title: '���',
					field: 'amt',
					align: 'center',
					width: 200
				}, {
					title: '������úϼ�',
					field: 'claa_sumfee',
					align: 'center',
					width: 200
				}, {
					title: '������',
					field: 'clab_amt',
					align: 'center',
					width: 200
				}, {
					title: 'ȫ�Էѽ��',
					field: 'fulamt_ownpay_amt',
					align: 'center',
					width: 200
				}, {
					title: '�������',
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
					title: '����֧������',
					field: 'fund_pay_type',
					align: 'center',
					width: 300
				}, {
					title: '����֧�����',
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
					title: '��֢�໤��������',
					field: 'scs_cutd_ward_type',
					align: 'center',
					width: 300
				}, {
					title: '��֢�໤����ʱ��',
					field: 'scs_cutd_inpool_time',
					align: 'center',
					width: 300
				}, {
					title: '��֢�໤�˳�ʱ��',
					field: 'scs_cutd_exit_time',
					align: 'center',
					width: 300
				}, {
					title: '��֢�໤�ϼ�ʱ��',
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
