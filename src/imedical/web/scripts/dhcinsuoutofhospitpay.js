/**
 * 院外报销垫付录入
 * FileName: dhcinsuoutofhospitpay.js
 * tangzf 2019-12-06
 * 版本：V1.0
 * hisui版本:0.1.0
 */
 var HospDr=session['LOGON.HOSPID'];
$(function(){
	init_SearchPanel();
	init_OutHospitalPayDG();
	
});
/*
 * 初始化查询面板
 */
function init_SearchPanel(){
	//默认日期
	setValueById('StartDate',getDefStDate(-31));
	//setValueById('EndDate',getDefStDate(31));
	setValueById('EndDate',getDefStDate(0));  //结束日期使用当天日期 modify by kj 20200304
	
	// 医保类型
	init_INSUType();
	
	// 就诊类型
	init_AdmType();
	
	//医疗类别
	init_MedType();
	
	// 性别
	init_Sex();
	
	// 门诊住院流水号
	buildADMSeri();
	
	// 结算状态
	init_INPAYFlag();
	
	// 初始化金额
	$('.hisui-numberbox').numberbox({
		value:0,
		min:0,
		precision:2	
	})
	$("#INPAYjjzfe0").keyup(function(e){ 
		if(e.keyCode===13){
			calAmt(this.value);		
		}
	})
	$('#INPAYjjzfe0').bind('change',function(){
  		calAmt(this.value);
	})
	
	$("#INPAYbcbxf0").keyup(function(e){ 
		if(e.keyCode===13){
			calAmt(getValueById("INPAYjjzfe0"));		
		}
	})
	$('#INPAYbcbxf0').bind('change',function(){
  		calAmt(getValueById("INPAYjjzfe0"));
	})
	
	// 身份证
	$('#INPAYid0000').bind('change',function(){
		if(this.value.length !='15' && this.value.length !='18'){
  			$.messager.alert('提示', "身份证号不合法", 'error');
			setValueById('INPAYid0000', '');
		}
	})
	
	// 加载Dg
	//loadDatagridData();
}
/*
 * 门诊住院流水号
 */
function buildADMSeri(){
	var NowDate=new Date();
	var NowDate=nowTimeObjToFormatTime(NowDate);
	var objAdmType=getValueById('INPAYZstr12');
	if (objAdmType !=""){
		zylsh0=objAdmType+NowDate+PUBLIC_CONSTANT.SESSION.USERID;
		setValueById('INPAYzylsh0',zylsh0);
	}else{
		setValueById('INPAYzylsh0','');
	}
}
/*
 * 计算个人自负
 */
function calAmt(insuAmt){
	//var totalAmt = getValueById('INPAYbcbxf0');
	var totalAmt = $("#INPAYbcbxf0").val();
	if (totalAmt <=0){
		$.messager.alert('提示', "输入总金额不正确", 'error');
		setValueById('INPAYgrzfe0', '0.00');
		return;	
	}
		
	var selfAmt = totalAmt - insuAmt;
	if(selfAmt < 0){
		$.messager.alert('提示', "输入金额不正确", 'error');
		setValueById('INPAYgrzfe0', '0.00');
		return;	
	}
	setValueById('INPAYgrzfe0', formatAmt(selfAmt));
}
/*
 * 数据校验
 */
function checkAmtData(){
	//var totalAmt = getValueById('INPAYbcbxf0');
	var totalAmt = $("#INPAYbcbxf0").val();
	if (totalAmt <=0){
		$.messager.alert('提示', "输入总金额不正确", 'error');
		setValueById('#INPAYbcbxf0', '0.00');
		return;	
	}
	var insuAmt = $("#INPAYjjzfe0").val();
	var selfAmt = totalAmt - insuAmt;
	if(selfAmt < 0){
		$.messager.alert('提示', "输入金额不正确", 'error');
		setValueById('INPAYgrzfe0', '0.00');
		return false;	
	}
	setValueById('INPAYgrzfe0', formatAmt(selfAmt));
	return true;
}
/*
 * 院外垫付grid
 */
function init_OutHospitalPayDG(){
	var dgColumns = [[
			{field:'TFlag',title:'结算状态',width:150},
			{field:'Txming0',title:'姓名',width:150},
			{field:'Tbcbxf0',title:'总费用',width:100,align:'right' },
			{field:'Tjjzfe0',title:'垫付费用',width:100,align:'right'},
			{field:'Tgrzfe0',title:'个人自付',width:100,align:'right'},
			{field:'Tdjlsh0',title:'单据号',width:150},
			{field:'TiDate',title:'录入时间',width:150},
			{field:'Tid0000',title:'身份证号',width:120},
			{field:'TsUserDr',title:'录入人',width:150},
			{field:'Tsftsbz',title:'医疗类别',width:150 },
			{field:'Tbie00',title:'性别',width:150 },
			{field:'Tzylsh0',title:'流水号',width:150 },
			{field:'TZstr04',title:'医保类型',width:150},
			{field:'TZstr10',title:'待遇类别',width:220},
			{field:'TZstr12',title:'就诊类型',width:150},
			{field:'TZstr13',title:'地区',width:120},
			{field:'TZstr16',title:'转诊医院',width:150},
			{field:'TZstr24',title:'备注',width:100},
			{field:'TRowID',title:'TRowID',hidden:true},
			{field:'Flag',title:'Flag',hidden:true}, // 状态
			{field:'Sex',title:'Sex',hidden:true}, // 性别
			{field:'AdmType',title:'AdmType',hidden:true}, // 就诊类别
			{field:'States',title:'States',hidden:true}, // 统筹区
			{field:'PatType',title:'PatType',hidden:true},// 人员类别
			{field:'MedType',title:'MedType',hidden:true}, // 医疗类别
			{field:'InsuType',title:'InsuType',hidden:true},// 医保类型
		]];
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		data:[],
		pageSize:'20',
		columns: dgColumns,
		toolbar:'#toolBar',
		onLoadSuccess: function (data) {
		},
		onSelect:function(index,row){
			selectRowHandle(index,row);
		}
	});
}
/*
 * 查询
 */
function Query(){
	loadDatagridData();
}
/*
 * 新增
 */
function Add(){
	try{
		var flag=checkAmtData();
		if(!flag){return;}
		var tmpObj = new Object();
		var saveTable=$('#addInfo').find('input');
		$.each(saveTable, function (index, rowData) {
			if(rowData.id !='StartDate' && rowData.id !='EndDate'){
				checkData(index, rowData);
				rowData.id != '' ? tmpObj[rowData.id] = getValueById(rowData.id) : '';
			}
		});	
		tmpObj['INPAYFlag'] = 'I'; 
		tmpObj['INPAYsUserDr'] = PUBLIC_CONSTANT.SESSION.USERID;
		tmpObj['INPAYHospDr'] = PUBLIC_CONSTANT.SESSION.HOSPID;	
		var xmlStr=json2xml(tmpObj,"")
		var rtn=tkMakeServerCall("web.INSUOutOfHospitalCtl", "SaveDivInfo", xmlStr);
		if(rtn != "0"){
			$.messager.alert('提示', "保存失败" + rtn, 'error');
		}else{
			$.messager.alert('提示', "保存成功", 'info',function(){
				Query();
			});	
		}
	}catch(e){}
}
/*
 * 作废
 */
function Abort(){
	var selected = $('#dg').datagrid('getSelected');
	if(!selected){
		$.messager.alert('提示','请选择要作废的记录','info');	
		return;
	}
	if(selected.TFlag != '正常结算'){
		$.messager.alert('提示','不允许作废已冲销的费用！请重新选择！','info');	
		return;
	}
	var User = PUBLIC_CONSTANT.SESSION.USERID ;
	var djlsh = selected.Tdjlsh0;
	var rowid = selected.TRowID;
	var divideFlag = selected.Flag;
	var Instring = User + '^' + djlsh + '^' + rowid + '^' + 'S'; //用户ID^单据号^Divide表的Rowid(作废必传)^结算状态(正常:I,被作废:B,作废:S)
	
	$.messager.confirm("确认", "是否作废该数据?", function (r) {
		if (r) {
			$.m({
				ClassName: "web.INSUOutOfHospitalCtl",
				MethodName: "StrikeDivideInfo",
				InStr: Instring,
			}, function(rtn){
				if(rtn > 0){
					$.messager.alert('提示', "作废成功！", 'info');	
				}else if(rtn = -5){
					$.messager.alert('作废失败', "系统中保存的医保系统结算号与页面显示的结算号不同！", 'error');	
				}else{
					$.messager.alert('作废失败:', rtn, 'error');
				}
				//Clear();
				Query();
			});
		}
	});
}
/*
 * 清屏
 */
function Clear(){
	$(".search-table").form("clear");
	setValueById('StartDate',getDefStDate(-31));
	setValueById('EndDate',getDefStDate(0));  //结束日期使用当天日期 modify by kj 20200304
	// 就诊类型
	setValueById('INPAYZstr12','OP');
	// 医保类型
	var data = $('#INPAYZstr04').combobox('getData');
	/*if(data.length > 0){
		$('#INPAYZstr04').combobox('select',data[0].cCode);	
	}*/
	// 结算状态
	setValueById('INPAYFlag','I');;
	// amt
	$('.hisui-numberbox').val('0.00');
	// sex
	setValueById('INPAYxbie00','1');
	buildADMSeri();
	loadDatagridData();
}
/*
 * 加载dg数据
 */
function loadDatagridData(){
	var queryParams={
		ClassName:'web.INSUOutOfHospitalCtl',
		QueryName:'QryOutOfHospital',
		StartDate:getValueById('StartDate'),
		EndDate:getValueById('EndDate'),
		Zstr12:getValueById('INPAYZstr12'),  // 门诊 住院
		djlsh0:getValueById('INPAYdjlsh0'), //登记流水号
		id0000:getValueById('INPAYid0000'), // 身份证
		Zstr04:getValueById('INPAYZstr04'), // 医保类型
		HospDr : HospDr
	}
	loadDataGridStore('dg',queryParams);	
}
/*
 * 选中行
 */
function selectRowHandle(index,rowData){
	setValueById('INPAYZstr04',rowData.InsuType); //医保类型
	setTimeout(function(){
		setValueById('INPAYzylsh0',rowData.Tzylsh0);
		setValueById('INPAYxming0',rowData.Txming0);
		setValueById('INPAYbcbxf0',rowData.Tbcbxf0);
		setValueById('INPAYZstr24',rowData.TZstr24);
		//setValueById('INPAYsftsbz',rowData.Tsftsbz); // 医疗类别
		setValueById('INPAYsftsbz',rowData.MedType);   // 医疗类别
		setValueById('INPAYZstr12',rowData.AdmType);   //就诊类型
		setValueById('INPAYZstr16',rowData.TZstr16);
		setValueById('INPAYjjzfe0',rowData.Tjjzfe0);
		setValueById('INPAYZstr13',rowData.States);   //地区
		setValueById('INPAYxbie00',rowData.Sex);      //性别
		setValueById('INPAYdjlsh0',rowData.Tdjlsh0);
		setValueById('INPAYid0000',rowData.Tid0000);
		setValueById('INPAYgrzfe0',rowData.Tgrzfe0);
		setValueById('INPAYZstr10',rowData.PatType); //待遇类别
		setValueById('INPAYFlag',rowData.Flag); //状态	
	},300)	
}
/*
 * 医疗类别
 */
function init_MedType(){
	$('#INPAYsftsbz').combobox({
		valueField: 'cCode',
		textField: 'cDesc',
		editable: false,
		onBeforeLoad:function(param){
				param.ResultSetType = 'array';
			},	
		onLoadSuccess:function(data){
			if(data.length > 0){
				$('#INPAYsftsbz').combobox('select',data[0].cCode);	
			}	
		}
	})
}
/*
 * 加载医疗类别 (还需要根据就诊类别加载)
 */
function loadMedType(){
	var INSUType = getValueById('INPAYZstr04');
	setValueById('INPAYsftsbz','');
	var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&Type=" + 'med_type' + INSUType + '&Code=' + '' + '&OPIPFlag=' + getValueById('INPAYZstr12')+'&HospDr='+HospDr;
	$('#INPAYsftsbz').combobox('reload', url); 
}
/*
 * 医保类型
 */
function init_INSUType(){
	var options={
		  defaultFlag:'N',
		  hospDr:HospDr
		}
	INSULoadDicData('INPAYZstr04','DLLType',options);
	$('#INPAYZstr04').combobox({
		onChange:function(){
			init_TreatmentType();
			init_States();
			loadMedType();
		}	
	})	
}
/*
 * 地区
 */
function init_States(){
	var options={
		  defaultFlag:'N',
		  hospDr:HospDr
		}
	var INSUType = getValueById('INPAYZstr04');
	INSULoadDicData('INPAYZstr13','admdvs' + INSUType,options);
}
/*
 * 就诊类型
 */
function init_AdmType(){
	$HUI.combobox("#INPAYZstr12", {
		valueField:'id',
		textField:'text',
		editable:false,
		data:[{
			"id" : 'OP',
			"text":"门诊",
			selected:true
		},{
			"id" : 'IP',
			"text":"住院"	
		}],
		onSelect:function(data){
			buildADMSeri();
			loadMedType();
		}
	})
}
/*
 * 待遇类别
 */
function init_TreatmentType(){
	var options={
		  defaultFlag:'N',
		  hospDr:HospDr
		}
	var INSUType = getValueById('INPAYZstr04');
	INSULoadDicData('INPAYZstr10','psn_type' + INSUType,options);
}
/*
 * 性别
 */
function init_Sex(){
	$HUI.combobox("#INPAYxbie00", {
		valueField:'id',
		textField:'text',
		data:[{
			"id" : '1',
			"text":"男",
			selected:true
		},{
			"id" : '2',
			"text":"女"	
		}],
	})
}
/*
 * 结算状态
 */
function init_INPAYFlag(){
	$HUI.combobox("#INPAYFlag", {
		valueField:'id',
		textField:'text',
		data:[{
			"id" : 'I',
			"text":"正常结算",
			selected:true
		},{
			"id" : 'D',
			"text":"预结算"	
		},{
			"id" : 'S',
			"text":"作废",
		},{
			"id" : 'B',
			"text":"被作废"	
		}],
	})
}
/**
* 数据校验
*/
function checkData(index, rowData) {
	if(rowData.id==''){
		return;
	}
	// 标签描述
	var labelDesc =  $('#Label' + rowData.id).text();
	var val = getValueById(rowData.id);
	//必填
	var required = $('#' + rowData.id).attr('required');
	if(required && val == ''){
		$.messager.alert('提示', '[' + labelDesc +']' + '不能为空' , 'error');
		throw msg;		
	}
	var Flag = val!=''?INSUcheckText(rowData.value, labelDesc):'';
}
