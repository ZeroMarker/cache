/*
 * FileName:	dhcinsu.insudeclaration.js
 * User:		tangzf
 * Date:		2020-02-27
 * Description: 医保申报
 */
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] 
}
 $(function () { 
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(1));	
	// 审批类别
	init_ReportType();
	// 医保类型
	init_INSUType();	
	// 回车事件
	$('#search .textbox').keydown(function (e) {
		if (e.keyCode == 13) {
			initLoadGrid();
		}
	});
	init_dg(); 
});
/*
 * 医保类型
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'N'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('INSUType','DLLType',Options); 	
	$('#INSUType').combobox({
		onSelect:function(){
			init_ReportType();
		}	
	})
}
/*
 * 审批类别
 */
function init_ReportType(){
	var Options = {
		defaultFlag:'N',
		editable:'Y',
		hospDr:GV.HospDr	
	}
	INSULoadDicData('Rptlb','AKA130' + getValueById('INSUType'),Options); 	
}
/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'TabPatNo',title:'个人编号',width:150 },
			{field:'TabPatName',title:'患者姓名',width:150 },
			{field:'TabRptDate',title:'申报日期',width:150},
			{field:'TabSDate',title:'有效开始日期',width:150},
			{field:'TabEDate',title:'有效结束日期',width:150},
			{field:'TabFlag',title:'审批标志',width:150,styler:function(val, index, rowData){
				switch (val){
					case "审批未通过":
						return "background:red"
						break;
					case "审批通过":
						return "background:green"
						break
					case "未审批":
						return "background:yellow"
						break
						
				}
			
			}},	
			{field:'TabRptTypeDesc',title:'申报类型	',width:150},
			{field:'TabAdmSeriNo',title:'住院流水号',width:220},
			{field:'TabAdmType',title:'就诊类型',width:120,},
			{field:'TabDiagCode',title:'疾病编码',width:150 },
			{field:'TabDiagDesc',title:'疾病名称',width:150},
			{field:'TabRPTNo',title:'审批编号',width:150},
			{field:'Tabxmbm',title:'项目编码',width:150},
			{field:'Tabxmmc',title:'项目名称',width:150 },
			{field:'TabHisCode',title:'医院项目编码',width:150},
			{field:'TabHisDesc',title:'医院项目名称',width:150 },
			{field:'Tabxmlb',title:'项目类别',width:150 },
			{field:'TabOutHosName',title:'转外医院',width:150 },
			{field:'Tabmoney',title:'金额',width:150,align:'right' },
			{field:'Tabsl',title:'数量',width:150 },
			{field:'TabUserName',title:'审批人',width:150 },
			{field:'TabDoctor',title:'主治医生',width:150 },
			{field:'TabNumberID',title:'审批批次号',width:150 },
			{field:'TabStates',title:'参保地',width:150 },
			{field:'TabHosYJ',title:'医院意见',width:150 },
			{field:'TabJSYJ',title:'家属意见',width:150 },
			{field:'TabMD',title:'	目的',width:150 },
			{field:'TabZZ',title:'症状',width:150 },	
			{field:'TabBZ',title:'备注',width:150 },
			{field:'TabRptType',hidden:true },	
			{field:'rowid',hidden:true}
		]];

	// 初始化DataGrid
	$('#dg').datagrid({
		data:[],
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		toolbar: '#tToolBar',
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}
/*
 * 加载数据
 */
function initLoadGrid(){
	if(getValueById('INSUType')==''){
		$.messager.alert('提示','医保类型不能为空','info');
		return;	
	}
    var queryParams = {
	    ClassName : 'web.INSUReport',
	    QueryName : 'QueryAll',
	    Rptlb : getValueById('Rptlb'),
	    StartDate : getValueById('StartDate'),
	    EndDate : getValueById('EndDate'),
	    HospId: GV.HospDr,
	    ParamINSUType: getValueById('INSUType')
	    
	}	
    loadDataGridStore('dg',queryParams);
	
}
/*
 * 查询医保审核信息
 */
$('#btnFindReport').bind('click', function () {
	FindReportInfo();
})
/*
 * 新增
 */
$('#btnAdd').bind('click', function () {
	var INSUType = getValueById('INSUType');
	if(INSUType == ''){
		$.messager.alert('提示','请先选择医保类型','info');
		return;	
	}
	openEditWindow();
});

/*
 * readcard
 */
$('#btnReadCard').bind('click', function () {
	var CardType="1",InsuNo="";
	var ExpString = getValueById('INSUType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	var str = InsuReadCard('0',UserId,InsuNo,1,ExpString);
	var TmpData = str.split("|");
	if (TmpData[0]!="0"){
		$.messager.alert('提示', "读卡失败" + str, 'error');	
		return;
	}else{
	 	var TmpData1 = TmpData[1].split("^")
	 	var TmpData2 = TmpData[2].split("^")
	 	setValueById('PatNo',TmpData1[0]); //个人编号
	 	setValueById('INSUCardNo',TmpData1[1]);  //卡号
	 	setValueById('name',TmpData1[3]); //姓名
	 	setValueById('Sex',TmpData1[4]); //性别
	 	setValueById('States',TmpData2[8]); //参保人所属地
	 	setValueById('rylb',TmpData1[11]);  //人员类别	 	
	 }
    
});
/**
* 数据校验
*/
function checkData() {
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		$.each(inValiddatebox, function (index, rowData) {
			var labelDesc = $('#Label' + rowData.id).text() || '值: ' + rowData.value;
			$.messager.alert('提示', '[' + labelDesc +']' + '验证不通过' , 'error');
			throw rowData.id;
		});		
	}
}
/*
 * 保存
 */
$('#btnReport').bind('click', function () {
	try{
		
		checkData();
		var PatNo = getValueById('PatNo');
		var RptType = getValueById('RptType');
		var AdmSeriNo = '';
		var OutHosName = '';
		var HosLevel = '';
		var DiagCode = getValueById('DiagCode');
		var DiagDesc = $('#DiagCode').combobox('getText');
		var HosYJ = getValueById('HosYJ');
		var xmbm = getValueById('xmbm');
		var xmmc = $('#xmbm').combobox('getText');	
		var sl = getValueById('sl');
		var RptDate = getValueById('RptDate');	
		var SDate = getValueById('SDate');	
		var EDate = getValueById('EDate');	
		var Guser = session['LOGON.USERID'];
		var OutHosName = '';
		var GuserName = session['LOGON.USERNAME'];
		var OutType = '';
		var Demo = '';
		var money = getValueById('money');
		var xmlb = '';
		var RPTNo = '';
		var ZYZZ = getValueById('ZYZZ');
		var MD = getValueById('MD');
		var Doctor = getValueById('Doctor');
		var KZR = getValueById('KZR');
		var JSYJ = getValueById('JSYJ');
		var KZRYJ = getValueById('KZRYJ');
		var LRuser = '';
		var LRDate = '';
		var RPTUser = '';
		var HisCode = '';
		var HisDesc = '';
		var AdmType = '';
		var NumberID = '';
		var States =  $('#States').combobox('getText'); 
		var HospId = GV.HospDr;
                    //0                       											5															11									14
		var str = PatNo + "|"+RptType+"|"+AdmSeriNo+"|"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|";
		//				15												20																			28			
		str = str + OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|";
								// 30								      33
		str = str + HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID + "|" + States;
		ExpString = getValueById('INSUType') + '^^' +getValueById('name'); // insutype^ExpStrForNet^Name
		var rtn=InsuReport(0,str,Guser,ExpString);
		if (rtn == 0){
			$.messager.alert('提示', "审批上报成功!：" + rtn, 'info',function(){
				$HUI.dialog("#LocalListInfoProWin",'close');
				initLoadGrid();	
			});	
		} else{
			$.messager.alert('错误', "审批上报失败!：" + rtn, 'error');
		}
	}catch(e){
	}
});
/*
 * 删除
 */
$('#btnDel').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.rowid != "") {
			$.messager.confirm('确认', '确认撤销上报记录？', function (r) {
				if (r) {
					var str=selected.TabRptType + "|"  + selected.TabPatNo + "|" + selected.TabAdmSeriNo + "|" + selected.TabDiagCode + "|" + selected.TabDiagDesc + "|" + selected.TabSDate
					ExpString = selected.rowid + "|";
					var rtn=tkMakeServerCall("web.INSUReport", "DeleteReport", selected.rowid); //DHCINSUBLL.InsuReportDestroy(1,str,Guser,ExpString);	
				    if (rtn!="0"){
					    $.messager.alert('错误', "审批上报撤销失败!" + rtn, 'info');
					}else {
						$.messager.alert('错误', "审批上报撤销成功!" + rtn, 'info',function(){
							initLoadGrid();	
						});
				    }
				}
			});
		}
	} else {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
	}
});
/*
 * 查询
 */
$('#btnFind').bind('click', function () {
	initLoadGrid();
});
/* 新增/修改弹窗
 */
function openEditWindow(){
	$('#LocalListInfoProWin').show(); 
	$HUI.dialog("#LocalListInfoProWin",{
			title:"申报信息",
			height:527,
			width:570,
			collapsible:false,
			modal:true,
		    iconCls: 'icon-w-edit'
	})
	$("#addInfo").form("clear");
	
	init_AddInfoPanel();	
	
}
/* 
 * 查询医保审核信息
 */
function FindReportInfo(){
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if(selected.TabFlag =='已撤销'){
			$.messager.alert('提示', "审核已经撤销", 'info');
			return;
		}
		$.messager.alert('提示', "需要连接医保中心", 'info');	
	} else {
		$.messager.alert('提示', "请选择要查询的记录", 'info');
	}
}
/* 
 * 新增弹窗
 */
function init_AddInfoPanel(){
	setValueById('SDate',getDefStDate(0));
	setValueById('EDate',getDefStDate(1));
	setValueById('RptDate',getDefStDate(0));
	Options = {
		hospDr: GV.HospDr	
	}
	// 审批类别
	INSULoadDicData('RptType','AKA130' + getValueById('INSUType'),Options); 	
	// 人员类别
	INSULoadDicData('rylb','AKC021' + getValueById('INSUType'),Options); 
	// states
	INSULoadDicData('States','YAB003' + getValueById('INSUType'),Options); 
	// 数量，金额
	setValueById('money','0');
	setValueById('sl','1');
	
	// HIS项目编码
	$HUI.combobox(('#xmbm'),{
		defaultFilter:'4',
		valueField: 'HisCode',
		textField: 'HisDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			if(param.q==''){
				return true;	
			}
			param.ClassName = 'web.INSUTarContrastCom';
			param.QueryName= 'DhcTarQuery';
			param.sKeyWord = param.q;
			param.Class = '1';
			param.Type = getValueById('INSUType');
			param.ConType = 'A';
			param.ExpStr = 'N||' + GV.HospDr;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	})
	Options = {
		defaultFlag:'N',
		hospDr: GV.HospDr	
	}
	// 慢性病诊断
	INSULoadDicData('DiagCodeMXB','Skc516' + getValueById('INSUType'),Options); 
	
	// HIS诊断
	$HUI.combobox(('#DiagCode'),{
		defaultFilter:'3',
		valueField: 'code',
		textField: 'desc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			if(param.q==''){
				return true;	
			}
			param.ClassName = 'web.DHCMRDiagnos';
			param.QueryName= 'LookUpWithAlias';
			param.desc = param.q;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	})
	
	// 意见
	$('.advise').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{
    			"id" : '01',
    			"text":"同意",
    			selected:true
    		},{
    			"id" : '02',
    			"text":"不同意"	
    		}],		
	})
	// sex
	$('#Sex').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{
    			"id" : '男',
    			"text":"男",
    			selected:true
    		},{
    			"id" : '女',
    			"text":"女"	
    		},{
    			"id" : '未知',
    			"text":"未知"	
    		}],		
	})
}

