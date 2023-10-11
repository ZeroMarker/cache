/**
 * FileName: bill.einv.invlogicpath.js
 * Author: ZhaoZW
 * Date: 2019-09-16
 * Description:
 */
//入口函数
$(function(){
	setPageLayout(); //页面布局初始化
	setElementEvent(); //页面事件初始化
});
//页面布局初始化
function setPageLayout(){
	initBillIUPGrid(); //初始化表格
	initIUPTypeCombo(); //初始化类型下拉框
	initWinIUPActiveCombo(); //初始化是否启用下拉框
	initwinIUDPrintTypeCombo(); //初始化票据类型下拉框
	initwinIUPTypeCombo(); //初始化类型下拉框
	initwinFactoryCodeCombo(); //初始化开发商下拉框
}
//页面事件初始化
function setElementEvent(){
	searchDataInfo(); //查询配置数据
}

////查询配置数据
function searchDataInfo(){
	$('#IUPSearch').on('click',function(){
		queryBillIUP();
	});
}
//初始化开发商下拉框
function initwinFactoryCodeCombo(){
	$('#winFactoryCodeCombo').combobox({
		width:157,
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	   		param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
	    	param.QueryName="QueryDicDataInfo"
	   		param.ResultSetType="array";
	 		param.Type="EInv_Factory_List"          
	    },
	    onLoadSuccess:function(){
			$('#winFactoryCodeCombo').combobox('setValue',"BS");   
		}
	});
}
//初始化类型下拉框
function initIUPTypeCombo(){
	$('#IUPTypeCombo').combobox({
		width:157,
		panelHeight: 'auto',
		multiple: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'', text:'全部', selected:'true'},
			{value:'I', text:'接口'},
			{value:'T', text:'任务'}
		],
		editable: false,
		disabled: false,
		readonly: false
	});
}
//初始化表格
function initBillIUPGrid() {
	$('#tBillIUP').datagrid({
		fit: true,
		striped: true, //是否显示斑马线效果
		singleSelect: true,
		selectOnCheck: false,
		fitColumns: false,
		autoRowHeight: false,
		pageSize:20,
		showFooter: true,
		loadMsg: 'Loading...',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		pageList: [20,40,60],  
		url:$URL,
		queryParams: {
			ClassName:"BILL.EINV.BL.COM.InvLogicPathCtl",
			QueryName:"QueryBillIUPInfo"
		},
		columns:[[    
        	{field:'ID',title:'ID',hidden:true},    
        	{field:'IUPType',title:'接口/任务',align:'left',halign:'center',width:110,
        		formatter: function(value){
					if(value == "I"){
						return '接口'
					}else{
						return '任务'	
					}
				}
			},    
        	{field:'IUPCode',title:'接口代码',align:'left',halign:'center',width:130}, 
        	{field:'IUPDesc',title:'接口描述',align:'left',halign:'center',width:150},    
        	{field:'IUPClassName',title:'类名',align:'left',halign:'center',width:200},    
        	{field:'IUPMethodName',title:'方法名',align:'left',halign:'center',width:200},
        	{field:'IUPActive',title:'是否启用',align:'left',halign:'center',width:130,
        		formatter: function(value){
					if(value == "Y"){
						return '是'
					}else{
						return '否'	
					}
				}
        	},    
        	{field:'IUPReMark',title:'接口说明',align:'left',halign:'center',width:200,
        		formatter:function(value){
	        		var abValue = value;
        			if (value.length>=22) {
            			abValue = value.substring(0,13) + "...";
            			var content = '<span href="#" title="' + value + '" class="note">' + abValue + '</span>';
        				return content;
        			}else{
        				return value;
        			}
	        	}
        	},
        	{field:'IUDPrintType',title:'票据类型',align:'left',halign:'center',width:130,
        		formatter: function(value){
					if(value == "E"){
						return '电子票据业务'
					}
					if(value == "P"){
						return '纸质票据业务'	
					}
					if(value == "C"){
						return '通用'	
					}
				}
        	},
        	{field:'FactoryCode',title:'开发商编码',align:'left',halign:'center',width:130},
        	{field:'FactoryDesc',title:'开发商名称',align:'left',halign:'center',width:130},
        	{field:'XStr1',title:'备用1',align:'left',halign:'center',width:130},
        	{field:'XStr2',title:'备用2',align:'left',halign:'center',width:130},
        	{field:'XStr3',title:'备用3',align:'left',halign:'center',width:130},
        	{field:'XStr4',title:'备用4',align:'left',halign:'center',width:130},
        	{field:'XStr5',title:'备用5',align:'left',halign:'center',width:130}
    	]],
    	onLoadSuccess:function(){
   			$(".showtip").tooltip({
                onShow: function(){
                    $(this).tooltip('tip').css({
                        width:'300',
                        boxShadow: '1px 1px 3px #292929'
                    });
                }
            });
		},
    	toolbar:[
    		{
	    		text:"添加",
	    		iconCls:"icon-add",
	    		handler:addBillIUP
	    	},
	    	{
	    		text:"修改",
	    		iconCls:"icon-edit",
	    		handler:editBillIUP
	    	},
	    	{
	    		text:"删除",
	    		iconCls:"icon-remove",
	    		handler:deleteBillIUP
	    	},
	    	{
	    		text:"导入",
	    		iconCls:"icon-import",
	    		handler:importBillIUP
	    	}
    	]
	});
}
//添加数据
function addBillIUP(){
	$('#tBillIUP').datagrid('clearSelections'); //清除所有选择的行
	//模态窗口
	$('#winBillIUP').dialog({  
		title:'添加',
		width:600,
		height:400,
		modal:true,
		iconCls:'icon-add',
		minimizable:false, //定义是否显示最小化按钮
		maximizable:false, //定义是否显示最大化按钮
		closable:false, //定义是否显示关闭按钮
		collapsible:false, //定义是否显示可折叠按钮
		resizable:true, //定义是否能够改变窗口大小
		buttons:[
			{
				text:'保存',
				handler:saveBillIUP
			},{
				text:'取消',
				handler:closeWin
			}
		]
	}).dialog('center'); 
}
//修改数据
function editBillIUP(){
	var selectedRow=$('#tBillIUP').datagrid('getSelected'); //获取选择行
	if (!selectedRow) {
		$.messager.alert('消息', '请选择需要编辑的行');
		return;
	}else{
		GetBillIUPDetails(selectedRow);
	}
	//模态窗口
	$('#winBillIUP').dialog({  
		title:'修改',
		width:600,
		height:400,
		modal:true,
		iconCls:'icon-edit',
		minimizable:false, //定义是否显示最小化按钮
		maximizable:false, //定义是否显示最大化按钮
		closable:false, //定义是否显示关闭按钮
		collapsible:false, //定义是否显示可折叠按钮
		resizable:true, //定义是否能够改变窗口大小
		buttons:[
			{
				text:'保存',
				handler:saveBillIUP
			},{
				text:'取消',
				handler:closeWin
			}
		]
	}).dialog('center'); 
}
//删除数据
function deleteBillIUP(){
	var selectedRow = $('#tBillIUP').datagrid('getSelected'); //获取选择行
	if (!selectedRow) {
		$.messager.alert('消息', '请选择需要删除的行');
		return;
	}
	$.messager.confirm('消息', '您确定要删除该条记录吗？', function (r) {
		if (!r) {
			return;
		} else {
			var ID = selectedRow.ID;
			$m({
				ClassName:"BILL.EINV.BL.COM.InvLogicPathCtl",
				MethodName:"DeleteBillIUPInfo",
				ID:ID
			},function(value){
				if(value.length > 0){
					$.messager.alert('消息',value);
					loadBillIUPGrid();
				}else{
					$.messager.alert('消息','服务器内部错误，请联系管理员！');
				}
			});
		}
	});
}
//导入数据
function importBillIUP(){
	var UserDr=UserID;
	var GlobalDataFlg="0";                          	 //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
	var ClassName="BILL.EINV.BL.COM.InvLogicPathCtl";    //导入处理类名
	var MethodName="ImportInvLogicPathByExcel";          //导入处理方法名
	var ExtStrPam="";                   			     //备用参数()
	ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
}
//查询数据
function queryBillIUP(){
	loadBillIUPGrid();	
}
//加载DataGrid数据
function loadBillIUPGrid(){
	var IUPType = $('#IUPTypeCombo').combobox('getValue');
	var IUPCode = $('#IUPCode').val();
	var IUPDesc = $('#IUPDesc').val();
	$('#tBillIUP').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.InvLogicPathCtl",
		QueryName:"QueryBillIUPInfo",
		PIUPType:IUPType,
		PIUPDesc:IUPDesc
	});
}
//获datagrid选择数据
function GetBillIUPDetails(selectedRow){
	if ((!selectedRow) || (selectedRow.ID == undefined)){
		return;
	}
	var ID = selectedRow.ID;
	$m({
		ClassName:"BILL.EINV.BL.COM.InvLogicPathCtl",
		MethodName:"GetBillIUPInfo",
		ID:ID
	},function(value){
		if(value == ""){
			return;
		}
		var rtnAry = value.split('^');
		$('#winIUPTypeCombo').combobox('setValue',rtnAry[0]);
		$('#winIUPCode').val(rtnAry[1]);
		$('#winIUPDesc').val(rtnAry[2]);
		$('#winIUPClassName').val(rtnAry[3]);
		$('#winIUPMethodName').val(rtnAry[4]);
		$('#winIUPActiveCombo').combobox('setValue',rtnAry[5]);
		$('#winIUPReMark').val(rtnAry[6]);
		$('#winIUDPrintTypeCombo').combobox('setValue',rtnAry[7]);
		$('#winXStr1').val(rtnAry[8]);
		$('#winXStr2').val(rtnAry[9]);
		$('#winXStr3').val(rtnAry[10]);
		$('#winXStr4').val(rtnAry[11]);
		$('#winXStr5').val(rtnAry[12]);
		$('#winFactoryCodeCombo').combobox('setValue',rtnAry[13]);
	});
}
//取消按钮
function closeWin(){
	$('#winBillIUP').window('close');
	$('#tBillIUP').datagrid('clearSelections'); //清除所选行
	clearDialog(); //清空Dialog的内容
}
//清空Dialog的内容
function clearDialog(){
	$('#winIUPTypeCombo').combobox('setValue',"I");
	$('#winIUPCode').val("");
	$('#winIUPDesc').val("");
	$('#winIUPClassName').val("");
	$('#winIUPMethodName').val("");
	$('#winIUPActiveCombo').combobox('setValue',"Y");
	$('#winIUPReMark').val("");
	$('#winIUDPrintTypeCombo').combobox('setValue',"C");
	$('#winFactoryCodeCombo').combobox('setValue',"BS");
	$('#winXStr1').val("");
	$('#winXStr2').val("");
	$('#winXStr3').val("");
	$('#winXStr4').val("");
	$('#winXStr5').val("");
}
//保存按钮
function saveBillIUP(){
	var selectedRow = $('#tBillIUP').datagrid('getSelected'); //获取选择行
	var ID = '';
	if (selectedRow){
		ID = selectedRow.ID;
	}
	var IUPType = $('#winIUPTypeCombo').combobox('getValue');
	if ($.trim(IUPType) == ""){
		$('#winIUPTypeCombo').combobox({required: true});
		return;
	}
	var IUPCode = $('#winIUPCode').val();
	if ($.trim(IUPCode) == ""){
		$('#winIUPCode').attr('placeholder', '请输入接口代码');
		return;
	}
	var IUPDesc = $('#winIUPDesc').val();
	if ($.trim(IUPDesc) == ""){
		$('#winIUPDesc').attr('placeholder', '请输入接口描述');
		return;
	}
	var IUPClassName = $('#winIUPClassName').val();
	if ($.trim(IUPClassName) == ""){
		$('#winIUPClassName').attr('placeholder', '请输入类名');
		return;
	}
	var IUPMethodName = $('#winIUPMethodName').val();
	if ($.trim(IUPMethodName) == ""){
		$('#winIUPMethodName').attr('placeholder', '请输入方法名');
		return;
	}
	var IUPActive = $('#winIUPActiveCombo').combobox('getValue');
	if (IUPActive == ""){
		$('#winIUPActiveCombo').combobox({required: true});
		return;
	}
	var IUPReMark = $('#winIUPReMark').val();
	/*
	if ($.trim(IUPReMark) == ""){
		$('#winIUPReMark').attr('placeholder', '请输入接口说明');
		return;
	}
	*/
	var IUDPrintType = $('#winIUDPrintTypeCombo').combobox('getValue'); //票据类型
	var FactoryCode = $('#winFactoryCodeCombo').combobox('getValue'); //开发商编码 
	var FactoryDesc = $('#winFactoryCodeCombo').combobox('getText'); //开发商名称
	var XStr1 = $('#winXStr1').val(); //备用1
	var XStr2 = $('#winXStr2').val(); //备用2
	var XStr3 = $('#winXStr3').val(); //备用3
	var XStr4 = $('#winXStr4').val(); //备用4
	var XStr5 = $('#winXStr5').val(); //备用5
	var IUPStr=IUPType+"^"+IUPCode+"^"+IUPDesc+"^"+IUPClassName+"^"+IUPMethodName+"^"+IUPActive+"^"+IUPReMark+"^"+IUDPrintType+"^"+XStr1+"^"+XStr2+"^"+XStr3+"^"+XStr4+"^"+XStr5+"^"+FactoryCode+"^"+FactoryDesc;
	var IUPAry=IUPStr.split('^');
	if(IUPAry.length > 15){
		$.messager.alert('消息','内容不能包含^号！');
		return;
	}
	if(ID == ""){
		saveMethod('SaveBillIUPInfo',IUPStr);
	}else{
		IUPStr=ID+"^"+IUPStr;
		saveMethod('UpdateBillIUPInfo',IUPStr);
	}
}
//抽取方法
function saveMethod(MethodName,IUPStr){
	$m({
		ClassName:"BILL.EINV.BL.COM.InvLogicPathCtl",
		MethodName:MethodName,
		IUPStr:IUPStr
	},function(value){
		if(value.length > 0){
			$.messager.alert('消息',value);
			loadBillIUPGrid();
			closeWin();
			return;
		}else{
			$.messager.alert('消息','服务器内部错误，请联系管理员！');
		}
	});
}
//初始化类型下拉框
function initwinIUPTypeCombo(){
	$('#winIUPTypeCombo').combobox({
		width:157,
		panelHeight: 'auto',
		multiple: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'I', text:'接口', selected:'true'},
			{value:'T', text:'任务'}
		],
		editable: false,
		disabled: false,
		readonly: false
	});
}
//初始化是否启用下拉框
function initWinIUPActiveCombo(){
	$('#winIUPActiveCombo').combobox({
		width:157,
		panelHeight: 'auto',
		multiple: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'Y', text:'启用', selected:'true'},
			{value:'N', text:'停止'}
		],
		editable: false,
		disabled: false,
		readonly: false
	});
}
//初始化票据类型下拉框
function initwinIUDPrintTypeCombo(){
	$('#winIUDPrintTypeCombo').combobox({
		width:157,
		panelHeight: 'auto',
		multiple: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'E', text:'电子票据业务'},
			{value:'P', text:'纸质票据业务'},
			{value:'C', text:'通用', selected:'true'}
		],
		editable: false,
		disabled: false,
		readonly: false
	});
}
