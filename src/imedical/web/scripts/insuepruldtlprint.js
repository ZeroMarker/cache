/**
 * FileName: insuepruldtlprint.js
 * Description: 医保结算清单信息
 */
 var PageLogicObj={
	m_OPSpecilDiagDataGrid:""
}
 
 $(function(){
	//初始化
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
			$.messager.alert('Tips','取数据出错');
			return;
		}
        //alert("jsonStr="+jsonStr)
		var inJson=JSON.parse(jsonStr);
		//console.log(inJson);
		// datagrid数据格式	
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
		// 获取所有name属性为QUERY的dom节点
		var dp =document.getElementsByName("QUERY");
		var datas=[];	
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
					title: '字段代码',
					field: 'Code',
					align: 'center',
					width: 300
				}, {
					title: '字段名称',
					field: 'Name',
					align: 'center',
					width: 300
				}, {
					title: '字段内容',
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
					title: '诊断名称',
					field: 'diag_name',
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
		//pagination: true,
		//rownumbers: true,
		//pageSize: 20,
		//pageList: [20, 30, 40, 50],
		data: [],
		columns: [[ {
					title: '出院西医诊断',
					field: 'diag_name',
					align: 'center',
					width: 300
				},{
					title: '诊断代码',
					field: 'diag_code',
					align: 'center',
					width: 150
				},{
					title: '入院病情',
					field: 'adm_cond_type',
					align: 'center',
					width: 100
				},{
					title: '出院中医诊断',
					field: 'diag_name1',
					align: 'center',
					width: 270
				},{
					title: '诊断代码',
					field: 'diag_code1',
					align: 'center',
					width: 100
				},{
					title: '入院病情',
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
					title: '手术操作名称',
					field: 'oprn_oprt_name',
					align: 'center',
					width: 270
				}, {
					title: '手术操作代码',
					field: 'oprn_oprt_code',
					align: 'center',
					width: 150
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
				}, {
					title: '麻醉医师姓名',
					field: 'anst_dr_name',
					align: 'center',
					width: 100
				}, {
					title: '麻醉医师代码',
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
					width: 150
				}, {
					title: '乙类金额',
					field: 'clab_amt',
					align: 'center',
					width: 150
				}, {
					title: '全自费金额',
					field: 'fulamt_ownpay_amt',
					align: 'center',
					width: 150
				}, {
					title: '其他金额',
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
					title: '基金支付类型',
					field: 'fund_pay_type',
					align: 'center',
					width: 280
				}, {
					title: '基金支付金额',
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
					title: '重症监护病房类型(CCU、NICU、EICU、SICU、PICU、RICU、其他)',
					field: 'scs_cutd_ward_type',
					align: 'center',
					width: 300
				}, {
					title: '重症监护进入时间(_年_月_日_时_分)',
					field: 'scs_cutd_inpool_time',
					align: 'center',
					width: 250
				}, {
					title: '重症监护退出时间(_年_月_日_时_分)',
					field: 'scs_cutd_exit_time',
					align: 'center',
					width: 250
				}, {
					title: '合计(小时)',
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
		onLoad:function(){// 加载成功 （将请求url成功后返回的打印内容载入到这个panel中）
			$("#printdiv").jqprint(); // 打印内容
		},
		onLoadError:function(){// 加载失败
			$.messager.alert('错误消息', '打印失败请稍后重试', 'error');
		}
	});
	$('#printdiv').panel('close');// 关闭打印
	
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
			//生成base64图片数据
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
	//绑定 type=text, 同时如果checkbox,radio,select>option的值有变化, 也绑定一下, 这里忽略button
	$("input,select option").each(function(){
		$(this).attr('value',$(this).val());
	});
	
	//绑定 type=checkbox,type=radio 选中状态
	$("input[type='checkbox'],input[type='radio']").each(function(){
		if($(this).attr('checked'))
			$(this).attr('checked',true);
		else
			$(this).removeAttr('checked');
	});
	
	//绑定 select选中状态
	$("select option").each(function(){
		if($(this).attr('selected'))
			$(this).attr('selected',true);
		else
			$(this).removeAttr('selected');
	});
	
	//绑定 textarea
	$("textarea").each(function(){
		$(this).html($(this).val());
	});
	
}
