/*
 * FileName:	dhcinsu.locallistinfo.js
 * User:		tangzf
 * Date:		2019-09-11
 * Function:	
 * Description: 本地人员名单维护
 */
 var GV = {
	UPDATEDATAID : '',	
}
 $(function () { 
	 
	init_dg(); 
	
	// 费别
	init_AdmReason(); 
	
	// 费用性质 付费性质
	init_FYQB();
	
	// 回车事件
	$('#search .textbox').keydown(function (e) {
		if (e.keyCode == 13) {
			initLoadGrid();
		}
	});
});
/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'TXXLX',title:'信息类型',width:150 },
			{field:'TXM',title:'患者姓名',width:150 },
			{field:'TYLZBH',title:'保健号',width:150},
			{field:'TYLZZT',title:'医疗证状态',width:220},
			{field:'TSBCARD',title:'社保卡号',width:150},
			{field:'TTXM',title:'条形码',width:150},
			{field:'TSFZH',title:'身份证号',width:120,},
			{field:'TXB',title:'性别',width:150 },
			{field:'TCSNY',title:'出生日期',width:150},
			{field:'TBZNY',title:'办证日期',width:150},
			{field:'TYYDH',title:'选定医院代码',width:150},
			{field:'TDWDM',title:'单位代码',width:150},
			{field:'TDWMC',title:'单位名称',width:150},
			{field:'TDWDZ',title:'单位地址',width:150 },
			{field:'TDWDH',title:'单位电话',width:150},
			{field:'TDWYB',title:'单位邮编',width:150 },
			{field:'TJTZZ',title:'家庭地址',width:150 },
			{field:'TZZDH',title:'家庭电话',width:150 },
			{field:'TZZYB',title:'家庭邮编',width:150 },
			{field:'TiDate',title:'操作日期',width:150 },
			{field:'TStaDate',title:'生效日期',width:150 },
			{field:'SubCate',title:'结束日期',width:150 },
			{field:'TYearStrDate',title:'年度开始时间',width:150 },
			{field:'TMZQFD',title:'门诊起付段',width:150 },
			{field:'TMZLJ',title:'门诊自负段累计',width:150 },
			{field:'TZYQFX',title:'住院起付线',width:150 },
			{field:'TNDLJ',title:'年度累计',width:150 },
			{field:'TZYCS',title:'住院次数',width:150 },	
			{field:'TTZLX',title:'转诊通知类型',width:150 },
			{field:'TZCYYDM',title:'转出医院代码',width:150 },
			{field:'TZCKSMC',title:'转出门诊科室名称',width:150 },
			{field:'TZCBQMC',title:'转出病区名称',width:150 },	
			{field:'TZCCWBH',title:'转出床位编码',width:150 },
			{field:'TZRYYDH',title:'转入医院代码',width:150 },
			{field:'TZRKSMC',title:'门诊转入指定科室',width:150 },
			{field:'TZRBQMC',title:'转入指定病区名称',width:150 },	
			{field:'TXXLXDesc',title:'信息类型',width:150 },
			{field:'TAdmReaDesc',title:'费别',width:150 },	
			{field:'TFYIDDesc',title:'费用性质',width:150 },
			{field:'TFFXZIDDesc',title:'付费性质',width:150 },
			{field:'TRZIDDesc',title:'职退情况',width:150 },	
			{field:'TJBIDDesc',title:'职级代码',width:150 },
			{field:'TDWXZDMDesc',title:'单位性质',width:150},
			{field:'TRowid',title:'TRowid',width:150,hidden:true},
			{field:'TAdmReasonDr',title:'TRowid',width:150,hidden:true}
		]];

	// 初始化DataGrid
	$('#dg').datagrid({
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
	});
}
/*
 * 费别
 */
function init_AdmReason(){
	$('#AdmReason').combobox({
		valueField: 'RowID',
		textField: 'READesc',
		url: $URL,
		onBeforeLoad:function(param){
			param.ClassName = 'DHCBILLConfig.DHCBILLSysType';
			param.QueryName = 'FindAdmReason';
			param.ResultSetType = 'array';
			param.Code = '';
			param.Desc = '';
			param.HospId = PUBLIC_CONSTANT.SESSION.HOSPID; //+ DingSH 20200601
		},
		onSelect:function(data){
		}
	})
}
/*
 * 费用性质 ,付费性质
 */
function init_FYQB(){
	var Options = new Object();
	Options.editable = true ;
	Options.defaultFlag = 'N';
	Options.hospDr = PUBLIC_CONSTANT.SESSION.HOSPID; //+ DingSH 20200601 
	INSULoadDicData('FYQB','FYQB',Options); //费用性质 
	INSULoadDicData('FYLB','FYLB',Options); //付费性质
}
/*
 * 加载数据
 */
function initLoadGrid(){
    var queryParams = {
	    ClassName : 'web.DHCINSULOCInfo',
	    QueryName : 'QueryLocInfo',
	    AdmReason : getValueById('AdmReason') || '',
	    YLZBH : getValueById('INSUNo'),
	    Name : getValueById('Name'),
	    SFZH : getValueById('IDCard'),
	    FYID : getValueById('FYQB') || '',
	    FFXZID : getValueById('FYLB') || '',
	    DWDM : getValueById('PADepCode'),
	    HospDr:PUBLIC_CONSTANT.SESSION.HOSPID //+ DingSH 20200601
	}	
    loadDataGridStore('dg',queryParams);
	
}
/*
 * 清屏
 */
$('#BtnClear').bind('click', function () {
	setValueById('Name','');
	setValueById('AdmReason','');
	setValueById('INSUNo','');
	setValueById('IDCard','');
	setValueById('FYQB','');
	setValueById('FYLB','');
	setValueById('PADepCode','');
	initLoadGrid();
})
/*
 * 新增
 */
$('#BtnAdd').bind('click', function () {
	openEditWindow('insert');
});
/*
 * 修改
 */
$('#BtnUpdate').bind('click', function () {
	var selectRow = $('#dg').datagrid('getSelected');
	if(!selectRow){
		$.messager.alert('提示','请选择要修改的记录','info');
		return;	
	}
	openEditWindow('update');
});
/*
 * 导入
 */
$('#BtnImport').bind('click', function () {
	var filePath = FileOpenWindow(importFun)
    
});
function importFun(filePath){
	if(filePath=="")
    {
	    $.messager.alert('提示', '请选择文件！！', 'error');
	    return ;
    }
    
    var ErrMsg="";     //错误数据
    var errRowNums=0;  //错误行数
    var sucRowNums=0;  //导入成功的行数
    
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.open(filePath); 
	xlBook.worksheets(1).select(); 
    var xlsheet = xlBook.ActiveSheet;
    
    var rows=xlsheet.usedrange.rows.count;
    var columns=xlsheet.usedRange.columns.count;
    var i,j,k;
	try{

		for(i=2;i<=rows;i++){
			var pym="";
			
			var TmpList=new Array();
	        TmpList[0]="";
	        var InString="";
			for (j=1;j<=columns;j++){
				TmpList[j]=xlsheet.Cells(i,j).text;
			}
			var Type=TmpList[33]
			var VerStr=tkMakeServerCall("web.DHCINSULOCInfo","GetLocInfoBySSID",TmpList[2],Type);
			var VerArr=VerStr.split("^")
			if (parseInt(VerArr[0])<=0){
				TmpList[0]=""
				for(;j<32;j++){TmpList[j]=""}
				TmpList[j]=Type;
			}
			else{  
				if(TmpList[1]="1"){TmpList[0]=""}
				TmpList[0]=VerArr[0];
				}
			for(k=1;k<TmpList.length;k++){
				InString=InString+"^"+TmpList[k];
				}
				
			for(;k<VerArr.length;k++){
				InString=InString+"^"+VerArr[k];
				}
			
				InString=TmpList[0]+InString;
		
 	        var savecode=tkMakeServerCall("web.DHCINSULOCInfo","Save",InString);
			if(savecode==null || savecode==undefined) savecode=-1;
			if(eval(savecode)>=0){
				sucRowNums=sucRowNums+1;
		
			}else{
				errRowNums=errRowNums+1; 
				if(ErrMsg==""){
					ErrMsg=i;
				}else{
					ErrMsg=ErrMsg+"\t"+i;
				}
			}
		}
		
		if(ErrMsg==""){
			$.messager.alert('提示', '数据正确导入完成', 'info');
		}else{
			var tmpErrMsg="成功导入【"+sucRowNums+"/"+(rows-1)+"】条数据";
			tmpErrMsg=tmpErrMsg+"失败数据行号如下：\n\n"+ErrMsg;
			$.messager.alert('提示', tmpErrMsg, 'error');   
		}
	}
	catch(e){
		$.messager.alert('提示', "导入时发生异常：ErrInfo：" + e.message, 'error');
	}
	finally{
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}	
}
/*
 * 保存
 */
$('#BtnSavePro').bind('click', function () {
	try{
		var tmpObj = new Object();
		var saveTable=$('#addInfo').find('input');
		checkData(); //是否有效数据
		$.each(saveTable, function (index, rowData) {
			INSUcheckText(rowData.value, $('#Label' + rowData.id).text(), "^ < > '"); //特殊字符
			rowData.id != '' ? tmpObj[rowData.id] = getValueById(rowData.id) : '';
		});		
		var xmlStr=json2xml(tmpObj,"")
		var rtn=tkMakeServerCall("web.DHCINSULOCInfo", "SaveLocalInfo", xmlStr, GV.UPDATEDATAID);
		if(rtn != "0"){
			$.messager.alert('提示', "保存失败" + rtn, 'error');
		}else{
			$.messager.alert('提示', "保存成功", 'info',function(){
				$HUI.dialog("#LocalListInfoProWin",'close');
				initLoadGrid();
			});	
		}
	}catch(e){
	}
});
/*
 * 删除
 */
$('#BtnDelete').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
				if (r) {
					$.m({
						ClassName: "web.DHCINSULOCInfo",
						MethodName: "Delete",
						LocRowid: selected.TRowid ,
					}, function (rtn) {
						if (rtn == "0") {
							$.messager.alert('提示', "删除成功", 'success',function(){
								initLoadGrid();
							});
						} else {
							$.messager.alert('错误', "删除失败，错误代码：" + rtn, 'error');
						}
					});
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
$('#BtnFind').bind('click', function () {
	FindClick();
});
/*
 * 查询
 */
function FindClick() {
	initLoadGrid();
}
/* 新增/修改弹窗
 * input : type = 'insert' 新增 ; type = 'update' 修改
 */
function openEditWindow(type){
	$('#LocalListInfoProWin').show(); 
	var title = type=='insert' ? '新增':'修改'
	$HUI.dialog("#LocalListInfoProWin",{
			title:title,
			height:647,
			width:871,
			collapsible:false,
			modal:true,
		    iconCls: 'icon-w-edit'
	})
	$("#addInfo").form("clear");
	init_LocalListProWin();	
	if(type == 'update'){
		var selectRow = $('#dg').datagrid('getSelected');
		GV.UPDATEDATAID = selectRow.TRowid;
		setTimeout(function () {
			setDefaultVal();
		}, 200);
		
		
	}else{
		GV.UPDATEDATAID	= '';
	}
	
}
/* 
 * 修改  弹窗 setVal
 */
function setDefaultVal(){
	var selectRow = $('#dg').datagrid('getSelected');
	$.each(selectRow, function (field, Data) {
		field = field.substr(1,field.length);
		field = 'INLOC' + field;
		if($('#' + field).attr('class') && $('#' + field).attr('class').indexOf('datebox-f')>0 && Data =='ERROR!'){
			Data = '';	
		}
		setValueById(field,Data);

	});	
}
$('#BtnClose').bind('click', function () {
	$HUI.dialog("#LocalListInfoProWin",'close');
});
/* 
 * 初始化 弹窗中的下拉框 
 */
function init_LocalListProWin(){
	// 该方法内容可根据 具体医保字典配置  拼接 医保类型 
	// 如:费用性质：INSULoadDicData('INLOCFYID', 'FYQBZZB', '', '');
	
	// 性别
	$('#INLOCXB').combobox({
		valueField: 'id',
		textField: 'desc',
		editable:false,
		data:[
			{
				"id":"男",
				"desc":"男",
				selected:true
			},
			{
				"id":"女",
				"desc":"女"	
			},
			{
				"id":"未知",
				"desc":"未知"	
			}
		
		]
	})
	var paraOptions= new Object();
	paraOptions.valueField='cCode'
	paraOptions.hospDr = PUBLIC_CONSTANT.SESSION.HOSPID; //+ DingSH 20200601 
	// 费用性质
	INSULoadDicData('INLOCFYID', 'FYQB', paraOptions);
	// 付费性质
	INSULoadDicData('INLOCFFXZID', 'FYLB',paraOptions);
	// 职退情况	
	INSULoadDicData('INLOCRZID', 'RZID',paraOptions);
	// 职级代码
	INSULoadDicData('INLOCJBID', 'JBID',paraOptions);
	// 单位性质
	INSULoadDicData('INLOCDWXZDM', 'DWXZDM',paraOptions);	
	// 转诊通知类型
	$('#INLOCTZLX').combobox({
		valueField: 'id',
		textField: 'desc',
		editable:false,
		data:[
			{
				'id':'TZLX1',
				'desc':'延期通知',
			},
			{
				'id':'TZLX0',
				'desc':'正常通知',
				selected:true
			}		
		]
	})
	// 维护类别  费别
	$('#INLOCAdmReasonDr').combobox({
		valueField: 'RowID',
		textField: 'READesc',
		url: $URL,
		editable:false,
		onBeforeLoad:function(param){
			param.ClassName = 'DHCBILLConfig.DHCBILLSysType';
			param.QueryName = 'FindAdmReason';
			param.ResultSetType = 'array';
			param.Code = '';
			param.Desc = '';
			param.HospId = PUBLIC_CONSTANT.SESSION.HOSPID; //+ DingSH 20200601
		},
		onLoadSuccess:function(data){
			if(data.length > 0){
				$('#INLOCAdmReasonDr').combobox('select',data[0].RowID)	;
			}	
		}
	})
}
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
$.extend($.fn.validatebox.defaults.rules, {
    idcard : {// 验证身份证
        validator : function(value) {
            return /^\d{15}(\d{2}[A-Za-z0-9])?$/i.test(value);
        },
        message : '请输入正确的身份证'
    },
    integer : {// 验证整数
        validator : function(value) {
            return /^[+]?[1-9]+\d*$/i.test(value);
        },
        message : '请输入整数'
    },
    zip : {// 验证邮政编码
        validator : function(value) {
            return /^[0-9]\d{5}$/i.test(value);
        },
        message : '邮政编码格式不正确'
    },
    Date :{
	    validator: function (value) {
		    var r = value.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/);
		    if (r == null) return false;
		    var d = new Date(r[1], r[3] - 1, r[4], r[5], r[6], r[7]);
		    return (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4] && d.getHours() == r[5] && d.getMinutes() == r[6] && d.getSeconds() == r[7]);

		    },
		    message: '时间格式不正确，请重新输入。'
    }
});
function selectHospCombHandle(){
	setValueById('Name','');
	setValueById('AdmReason','');
	setValueById('INSUNo','');
	setValueById('IDCard','');
	setValueById('FYQB','');
	setValueById('FYLB','');
	setValueById('PADepCode','');
	$('#AdmReason').combobox('clear');
	$('#AdmReason').combobox('reload');
	//$('#AdmReason').combobox('clear');
	//$('#AdmReason').combobox('reload');
	initLoadGrid();
}
    
