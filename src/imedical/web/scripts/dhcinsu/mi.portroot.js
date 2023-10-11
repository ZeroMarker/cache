/**
 * FileName: dhcinsu/mi.portroot.js
 * Anchor: tangzf
 * Date: 2021-02-02
 * Description: 国家版-医保数据上传-根节点配置弹窗
 */

function Clean(){
	setValueById('PortRoot-PORTCODE','');
	//$('#PortRoot-HITYPE').combobox('clear');
	setValueById('PortRoot-MEDMDTRTTYPE','');
	setValueById('PortRoot-NODECODE','');
	setValueById('PortRoot-NODENAME','');
	setValueById('PortRoot-CONINFO','');
	//setValueById('PortRoot-HOSPID',rowData.HOSPID);
	//$('#PortRoot-HOSPID').combobox('clear');
	setValueById('PortRoot-ROWID','');	
	if ($('#PortRoot-NODECODE').attr("class").indexOf("combobox") >= 0){
		$('#PortRoot-NODECODE').combobox('destroy');
		if($('#PortRoot-NODECODE').length == 0){
			$('#TDPortRoot-NODECODE').prepend('<input id="PortRoot-NODECODE" class="textbox PortCom"/>');l
		}
				
	}
	//setValueById('PortRoot-INFNO','');
	//setValueById('PortRoot-INFNAME','');
			
}
 // 保存
function SavePortRootmon(){
	var dgSelected = $('#dg').datagrid('getSelected');
	if(!dgSelected){
		return;	
	}
	var HITYPE = dgSelected.HITYPE;//$('#PortRoot-HITYPE').combobox('getValue');
	var HOSPID = dgSelected.HOSPID; //$('#PortRoot-HOSPID').combobox('getValue');
	
	
	var PORTCODE = getValueById('PortRoot-PORTCODE');
	var HITYPE = dgSelected.HITYPE;//$('#PortRoot-HITYPE').combobox('getValue');
	var HOSPID = dgSelected.HOSPID; //$('#PortRoot-HOSPID').combobox('getValue');
	var INFNAME = getValueById('PortRoot-INFNAME');
	var INFNO = getValueById('PortRoot-INFNO');
	var NODECODE = getValueById('PortRoot-NODECODE');
	var NODENAME = getValueById('PortRoot-NODENAME');
	var CONINFO = getValueById('PortRoot-CONINFO');
	var ROWID = '';
	
	if (PORTCODE == ""){
		INSUMIAlert('节点类型不能为空' , 'error');
		return;	
	}
	if (NODECODE == ""){
		INSUMIAlert('节点代码不能为空' , 'error');
		return;	
	}
	
	var Msg = '<span style="color:red" >新增</span>';
	var selectedRow = $('#PortRootDG').datagrid('getSelected');
	if(selectedRow){
		ROWID = selectedRow.ROWID;
		Msg =  '<span style="color:red" >更新</span>';
	}	
	$.messager.confirm('提示','是否继续[' + Msg + '],节点代码为：' + NODECODE + ',节点值:' + CONINFO,function(r){
		if(r){
			var InStr = ROWID + '^' + HOSPID  + '^' + HITYPE + '^' + PORTCODE  + '^' + INFNO + '^' + INFNAME  + '^' + NODECODE + '^' + NODENAME + '^' + CONINFO;
			var rtn = $.m({ClassName: "INSU.MI.PortRoot", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
			if (rtn == '0'){
				INSUMIAlert('保存成功' , 'success');
			}else{
				INSUMIAlert('保存失败：'  + rtn , 'error');
			}
			LoadPortRoot();	
		}		
	});

}
// 删除
function DeletePortRootmon(){
	var selectedRow = $('#PortRootDG').datagrid('getSelected');
	if (!selectedRow){
		INSUMIAlert('请选择要删除的行' , 'error');
		return;	
	}
	ROWID = selectedRow.ROWID;
	$.messager.confirm('提示','是否继续删除?',function(r){
		if(r){
			var rtn = $.m({ClassName: "INSU.MI.PortRoot", MethodName: "Delete", RowId:ROWID}, false);
			if (rtn == '0'){
				INSUMIAlert('删除成功' , 'success');
				Clean();
				LoadPortRoot();
			}else{
				INSUMIAlert('保存失败：'  + rtn , 'error');
				LoadPortRoot();
			}		
		}	
	})		
}
// 
//
function init_PortRootDg(){
	var colums = [[
		{field:'HOSPID',title:'医院',width:100,align:'center'},
		{field:'HITYPE',title:'医保类型',width:100,align:'center'},
		{field:'PORTCODE',title:'节点类型',width:94,align:'center'},
		{field:'INFNO',title:'交易编号',width:100,align:'center'},
		{field:'INFNAME',title:'交易名称',width:60,align:'center'},
		{field:'NODECODE',title:'节点代码',width:50,align:'center'},
		{field:'NODENAME',title:'节点名称',width:100},
		{field:'CONINFO',title:'节点值',width:70,align:'center'},
		{field:'ROWID',title:'ROWID',width:48,align:'center',hidden:true}
	]];
	var width = 871;
	$HUI.datagrid('#PortRootDG',{
		//height: 150,
		border:true,
		fitColumns: true,
		singleSelect: true,
		data: [],
		width:width,
		height:(660-287),
		//toolbar:'#PubDGTB',
		columns:colums,
		pageSize:10,
		pageList:[10,20],
		pagination:true,
		onLoadSuccess:function(data){

		},
		onDblClickRow:function(){
		},
		onSelect:function(rowIndex, rowData){
			FillPortRootDGInfo(rowData);
		},
		onUnselect:function(rowIndex, rowData){
			
		}
	});	
	init_NodeType();
}

function init_NodeType(){
	try{
		$('#PortRoot-PORTCODE').combobox({
			valueField: 'cCode',
			textField: 'cDesc',
			data:[
				{
					'cCode':'Config',
					'cDesc':'生成数据时不解析的配置'
				},
				{
					'cCode':'Root',
					'cDesc':'生成数据时解析的根节点'
				}			
				],
			onSelect: function (data) {
				if(data.cCode == "Config"){ // config类型 生成下拉框
					init_PortRootNodeCode();	
				}else{ //root 生成input文本框
					if ($('#PortRoot-NODECODE').attr("class").indexOf("combobox") >= 0){
						$('#PortRoot-NODECODE').combobox('destroy');
					}
					if($('#PortRoot-NODECODE').length == 0){
						$('#TDPortRoot-NODECODE').prepend('<input id="PortRoot-NODECODE" class="textbox PortCom"/>');
					}
				}
				setValueById('PortRoot-CONINFO','');
				setValueById('PortRoot-NODENAME','');
			}
		});	
	}catch(e){
		INSUMIAlert(e.responseText , 'error');	
	}	
}
// 节点代码
function init_PortRootNodeCode(){
	if ($('#PortRoot-NODECODE').attr("class").indexOf("combobox") >= 0){
		$('#PortRoot-NODECODE').combobox('destroy');
	}
	if($('#PortRoot-NODECODE').length == 0){
		$('#TDPortRoot-NODECODE').prepend('<input id="PortRoot-NODECODE" class="hisui-combobox textbox PortCom"/>');
	}
	$('#PortRoot-NODECODE').combobox({
		defaultFilter: 4,
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		editable:false,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'INSU.COM.BaseData';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'RootConfig';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;
		},
		onSelect: function (data) {
			setValueById('PortRoot-NODENAME',data.cDesc);
		}	
	});
}

function FillPortRootDGInfo(rowData){
	//$('#PortRoot-HOSPID').combogrid('setValue',rowData.HOSPID)
	//$('#PortRoot-HITYPE').combobox('clear');
	//$('#PortRoot-HITYPE').combogrid('setValue',rowData.HITYPE); 
	//setValueById('PortRoot-HITYPE',rowData.HITYPE);
	setValueById('PortRoot-MEDMDTRTTYPE',rowData.MEDMDTRTTYPE);
	
	setValueById('PortRoot-INFNO',rowData.INFNO);
	setValueById('PortRoot-INFNAME',rowData.INFNAME);
	setValueById('PortRoot-PORTCODE',rowData.PORTCODE);
	
	setValueById('PortRoot-NODECODE',rowData.NODECODE);
	setValueById('PortRoot-NODENAME',rowData.NODENAME);
	setValueById('PortRoot-CONINFO',rowData.CONINFO);
	setValueById('PortRoot-ROWID',rowData.ROWID);	
}
function LoadPortRoot(){
	INSUMIClearGrid('PortRootDG');
	var dgSelected = $('#dg').datagrid('getSelected');
	if(!dgSelected){
		return;	
	}
	var HITYPE = dgSelected.HITYPE;//$('#PortRoot-HITYPE').combobox('getValue');
	var HOSPID = dgSelected.HOSPID; //$('#PortRoot-HOSPID').combobox('getValue');
	
	var queryParams = {
	    ClassName : 'INSU.MI.PortRoot',
	    QueryName : 'QueryPortRoot',
	    Hospital: HOSPID,
	    InsuType : HITYPE,
	    QINFNO:getValueById('PortRoot-INFNO')
	}	
    loadDataGridStore('PortRootDG',queryParams);				
}
function paramCFGClick(){
	var NodeCode = getValueById('PortRoot-NODECODE');
	if(NodeCode != "InputParam"){
		INSUMIPOP('该按钮只允许配置节点代码为InputParam的数据' , 'error');
		return;		
	}		
}