/**
 * FileName: insuepruldtlprint.js
 * Description: ҽ�������嵥��Ϣ
 */
 var PageLogicObj={
	m_OPSpecilDiagDataGrid:""
}
 
 $(function(){
	//��ʼ��
	Init();
	initQueryMenu();

	$HUI.linkbutton('#btn-print', {
		onClick: function () {
			btnprint();
		}
	});
})

function Init(){
	PageLogicObj.m_OPSpecilDiagDataGrid=initsetlinfo();
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
	var EId=url.split("EId=")[1].split("&")[0]
		var jsonStr=tkMakeServerCall("web.DHCINSUEprUl","GetErpiInargInfo",Rowid,EId)
		var rtncode=jsonStr.split("^")[0];
		if ((rtncode=="-1")||(jsonStr=="")){
			$.messager.alert('Tips','ȡ���ݳ���');
			return;
		}
        //alert("jsonStr="+jsonStr)
		var inJson=JSON.parse(jsonStr);
		//console.log(inJson);
		// datagrid���ݸ�ʽ	
		if(inJson.input.diseinfo){
			var datagridData = {total:inJson.input.diseinfo.length,rows:inJson.input.diseinfo};
			if(datagridData.rows){$("#diseinfo").datagrid({loadFilter:pagerFilter}).datagrid('loadData',datagridData)};		
				var InsertRows = 10 ;
				for (var i =inJson.input.diseinfo.length;i<InsertRows;i++){
					$('#diseinfo').datagrid('appendRow',{
						"diag_name" : "",
						"diag_code" : "",
						"adm_cond_type": "",
						"diag_name1" : "",
						"diag_code1" : "",
						"adm_cond_type1": ""
					});		
				}
		}else{
			var InsertRows = 10 ;
				for (var i = 1;i<=InsertRows;i++){
					$('#diseinfo').datagrid('appendRow',{
						"diag_name" : "",
						"diag_code" : "",
						"adm_cond_type": "",
						"diag_name1" : "",
						"diag_code1" : "",
						"adm_cond_type1": ""
					});		
				}			
		}	
		if(inJson.input.iteminfo){
			var datagridData = {total:inJson.input.iteminfo.length,rows:inJson.input.iteminfo};
			if(datagridData.rows){$("#iteminfo").datagrid({loadFilter:pagerFilter}).datagrid('loadData',datagridData)};
			var InsertRows = 15 ;
				for (var i =inJson.input.iteminfo.length;i<InsertRows;i++){
					$('#iteminfo').datagrid('appendRow',{
						"med_chrgitm" : "",
						"amt" : "",
						"claa_sumfee": "",
						"clab_amt" : "",
						"fulamt_ownpay_amt" : "",
						"oth_amt": ""
					});		
				}
		}else{
			var InsertRows = 15 ;
				for (var i = 1;i<=InsertRows;i++){
					$('#iteminfo').datagrid('appendRow',{
						"med_chrgitm" : "",
						"amt" : "",
						"claa_sumfee": "",
						"clab_amt" : "",
						"fulamt_ownpay_amt" : "",
						"oth_amt": ""
					});	
				}			
		}
		if(inJson.input.payinfo){
			var datagridData = {total:inJson.input.payinfo.length,rows:inJson.input.payinfo};
			if(datagridData.rows){$("#payinfo").datagrid({loadFilter:pagerFilter}).datagrid('loadData',datagridData)};
			var InsertRows = 9 ;
				for (var i = inJson.input.payinfo.length;i<InsertRows;i++){
					$('#payinfo').datagrid('appendRow',{
						"fund_pay_type" : "",
						"fund_payamt" : ""
						
					});		
				}
		}else{
			var InsertRows = 9 ;
				for (var i = 1;i<=InsertRows;i++){
					$('#payinfo').datagrid('appendRow',{
						"fund_pay_type" : "",
						"fund_payamt" : ""
						
					});		
				}			
		}
		if(inJson.input.opspdiseinfo){
			var datagridData = {total:inJson.input.opspdiseinfo.length,rows:inJson.input.opspdiseinfo};
			if(datagridData.rows){$("#opspdiseinfo").datagrid({loadFilter:pagerFilter}).datagrid('loadData',datagridData)};
			if(inJson.input.opspdiseinfo.length < 5){
				var InsertRows = 5 - inJson.input.opspdiseinfo.length;
				for (var i = 1;i<=InsertRows;i++){
					$('#opspdiseinfo').datagrid('appendRow',{
						"diag_name" : "",
						"diag_code" : "",
						"oprn_oprt_name": "",
						"oprn_oprt_code":""	
					});		
				}	
			}
		}else{
			var InsertRows = 5 ;
				for (var i = 1;i<=InsertRows;i++){
					$('#opspdiseinfo').datagrid('appendRow',{
						"diag_name" : "",
						"diag_code" : "",
						"oprn_oprt_name": "",
						"oprn_oprt_code":""	
					});		
				}			
		}
		
		if(inJson.input.oprninfo){
			var datagridData = {total:inJson.input.oprninfo.length,rows:inJson.input.oprninfo};
			if(datagridData.rows){$("#oprninfo").datagrid({loadFilter:pagerFilter}).datagrid('loadData',datagridData)};
			var InsertRows=10
			if(inJson.input.oprninfo.length<InsertRows){
				for (var i = inJson.input.oprninfo.length;i<InsertRows;i++){
					$('#oprninfo').datagrid('appendRow',{
						"oprn_oprt_name" : "",
						"oprn_oprt_code" : "",
						"oprn_oprt_date": "",
						"anst_way":"",
						"oper_dr_name" : "",
						"oper_dr_code" : "",
						"anst_dr_name": "",
						"anst_dr_code":""	
					});			
				}
			}
		}else{
			var InsertRows = 10 ;
				for (var i = 1;i<=InsertRows;i++){
					$('#oprninfo').datagrid('appendRow',{
						"oprn_oprt_name" : "",
						"oprn_oprt_code" : "",
						"oprn_oprt_date": "",
						"anst_way":"",
						"oper_dr_name" : "",
						"oper_dr_code" : "",
						"anst_dr_name": "",
						"anst_dr_code":""	
					});		
				}			
		}
		if(inJson.input.icuinfo){
			var datagridData = {total:inJson.input.icuinfo.length,rows:inJson.input.icuinfo};
			if(datagridData.rows){$("#icuinfo").datagrid({loadFilter:pagerFilter}).datagrid('loadData',datagridData)};
				var InsertRows = 3 ;
				for (var i = inJson.input.icuinfo.length;i<InsertRows;i++){
					$('#icuinfo').datagrid('appendRow',{
						"scs_cutd_ward_type" : "",
						"scs_cutd_inpool_time" : "",
						"scs_cutd_exit_time": "",
						"scs_cutd_sum_dura":""				
					});		
				}
		}else{
			var InsertRows = 3 ;
				for (var i = 1;i<=InsertRows;i++){
					$('#icuinfo').datagrid('appendRow',{
						"scs_cutd_ward_type" : "",
						"scs_cutd_inpool_time" : "",
						"scs_cutd_exit_time": "",
						"scs_cutd_sum_dura":""				
					});		
				}			
		}
		// ��ȡ����name����ΪQUERY��dom�ڵ�
		var dp =document.getElementsByName("QUERY");
		var datas=[];	
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

		$('#hosp_name').val($('#fixmedins_name').val())
		//alert("inJson['fixmedins_code']="+inJson['fixmedins_code'])
		$('#fixmedins_code').val(inJson['fixmedins_code'])
}
function initsetlinfo() {
	$HUI.datagrid('#setlinfo', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		pagination: true,
		rownumbers: true,
		width:800,
		pageSize: 20,
		pageList: [10, 20, 30, 40],
		data: [],
		columns: [[{
					title: '�ֶδ���',
					field: 'Code',
					align: 'center',
					width: 300
				}, {
					title: '�ֶ�����',
					field: 'Name',
					align: 'center',
					width: 300
				}, {
					title: '�ֶ�����',
					field: 'value',
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

function initopspdiseinfo() {
	$HUI.datagrid('#opspdiseinfo', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		//pagination: true,
		//rownumbers: true,
		//pageSize: 20,
		//pageList: [20, 30, 40, 50],
		data: [],
		columns: [[{
					title: '�������',
					field: 'diag_name',
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
		//pagination: true,
		//rownumbers: true,
		//pageSize: 20,
		//pageList: [20, 30, 40, 50],
		data: [],
		columns: [[ {
					title: '��Ժ��ҽ���',
					field: 'diag_name',
					align: 'center',
					width: 300
				},{
					title: '��ϴ���',
					field: 'diag_code',
					align: 'center',
					width: 150
				},{
					title: '��Ժ����',
					field: 'adm_cond_type',
					align: 'center',
					width: 100
				},{
					title: '��Ժ��ҽ���',
					field: 'diag_name1',
					align: 'center',
					width: 270
				},{
					title: '��ϴ���',
					field: 'diag_code1',
					align: 'center',
					width: 100
				},{
					title: '��Ժ����',
					field: 'adm_cond_type1',
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
		//pagination: true,
		//rownumbers: true,
		//pageSize: 20,
		//pageList: [20, 30, 40, 50],
		data: [],
		columns: [[{
					title: '������������',
					field: 'oprn_oprt_name',
					align: 'center',
					width: 270
				}, {
					title: '������������',
					field: 'oprn_oprt_code',
					align: 'center',
					width: 150
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
				}, {
					title: '����ҽʦ����',
					field: 'anst_dr_name',
					align: 'center',
					width: 100
				}, {
					title: '����ҽʦ����',
					field: 'anst_dr_code',
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
		//pagination: true,
		//rownumbers: true,
		//pageSize: 20,
		//pageList: [20, 30, 40, 50],
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
					width: 150
				}, {
					title: '������',
					field: 'clab_amt',
					align: 'center',
					width: 150
				}, {
					title: 'ȫ�Էѽ��',
					field: 'fulamt_ownpay_amt',
					align: 'center',
					width: 150
				}, {
					title: '�������',
					field: 'oth_amt',
					align: 'center',
					width: 150
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
		//pagination: true,
		//rownumbers: true,
		//pageSize: 20,
	//pageList: [20, 30, 40, 50],
		data: [],
		columns: [[{
					title: '����֧������',
					field: 'fund_pay_type',
					align: 'center',
					width: 280
				}, {
					title: '����֧�����',
					field: 'fund_payamt',
					align: 'center',
					width: 214
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
		//pagination: true,
		//rownumbers: true,
		//pageSize: 20,
		//pageList: [20, 30, 40, 50],
		data: [],
		columns: [[{
					title: '��֢�໤��������(CCU��NICU��EICU��SICU��PICU��RICU������)',
					field: 'scs_cutd_ward_type',
					align: 'center',
					width: 300
				}, {
					title: '��֢�໤����ʱ��(_��_��_��_ʱ_��)',
					field: 'scs_cutd_inpool_time',
					align: 'center',
					width: 250
				}, {
					title: '��֢�໤�˳�ʱ��(_��_��_��_ʱ_��)',
					field: 'scs_cutd_exit_time',
					align: 'center',
					width: 250
				}, {
					title: '�ϼ�(Сʱ)',
					field: 'scs_cutd_sum_dura',
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

function pagerFilter(data){
	if (typeof data.length == 'number' && typeof data.splice == 'function'){ // is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		onSelectPage:function(pageNum, pageSize){
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
			pageNumber:pageNum,
			pageSize:pageSize
			});
			dg.datagrid('loadData',data);
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}

function btnprint(){
	var url = window.location.href
	var RowId=url.split("Rowid=")[1].split("&")[0]
	var Flag=url.split("Flag=")[1]
	$("#btn-print").hide();
	preview(1)
	$("#btn-print").show();

	return;
	$('#printdiv2').panel({
		closed: false,
		href:'../csp/insueprulprintdtl.csp?Rowid='+window.location.href.split("Rowid=")[1].split("&")[0]+"&Flag=B",
		onLoad:function(){// ���سɹ� ��������url�ɹ��󷵻صĴ�ӡ�������뵽���panel�У�
			$("#printdiv").jqprint(); // ��ӡ����
		},
		onLoadError:function(){// ����ʧ��
			$.messager.alert('������Ϣ', '��ӡʧ�����Ժ�����', 'error');
		}
	});
	$('#printdiv').panel('close');// �رմ�ӡ
	
}
function preview(mode)
{
	if (mode < 10){
		buildData()
		var body = window.document.body.innerHTML;
		var form = $("#printdiv").html();
		window.document.body.innerHTML = form;
		window.print();
		window.document.body.innerHTML = body;
		
	} else {
		window.print();
	}
}

function printById(id) {
	//html2canvas(document.getElementById(id)); //document.body
	//return;
	html2canvas(document.getElementById(id), {
		allowTaint : true,
		taintTest : false,
		onrendered : function(canvas) {
			canvas.id = "mycanvas";
			//document.body.appendChild(canvas);
			//����base64ͼƬ����
			var dataUrl = canvas.toDataURL();
			var newImg = document.createElement("img");
			newImg.src = dataUrl;
			/* document.body.appendChild(newImg);  */
			/* window.open(newImg.src); */
		  	var printWindow = window.open(newImg.src);
      	 		// printWindow.document.write(); 
      			 printWindow.document.write('<img src="'+newImg.src+'" />')
         		 printWindow.print();
		}
	});
}

function buildData(){
	//�� type=text, ͬʱ���checkbox,radio,select>option��ֵ�б仯, Ҳ��һ��, �������button
	$("input,select option").each(function(){
		$(this).attr('value',$(this).val());
	});
	
	//�� type=checkbox,type=radio ѡ��״̬
	$("input[type='checkbox'],input[type='radio']").each(function(){
		if($(this).attr('checked'))
			$(this).attr('checked',true);
		else
			$(this).removeAttr('checked');
	});
	
	//�� selectѡ��״̬
	$("select option").each(function(){
		if($(this).attr('selected'))
			$(this).attr('selected',true);
		else
			$(this).removeAttr('selected');
	});
	
	//�� textarea
	$("textarea").each(function(){
		$(this).html($(this).val());
	});
	
}
