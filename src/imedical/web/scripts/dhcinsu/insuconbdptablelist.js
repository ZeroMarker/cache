/*
 * FileName:	dhcinsu.insuconbdptablelist.js
 * User:		tangzf
 * Date:		2020-06-22
 * Function:	
 * Description: 医保代码与平台配置对照
 */
var PassWardFlag = 'N';
 $(function () { 
 	//
 	var Insert = tkMakeServerCall("web.INSUDicDataCom","CheckAddINSUConBDPTableList");
	//
	init_dg(); 
	
	// 
	init_wdg(); 
	
	//
	init_QFactor();
	
	//
	init_rQFactor();
	
	//
	$('#r-Find').bind('click',function(){
		loadBDPDataGrid();	
	})
	$('#Find').bind('click',function(){
		loadINSUDataGrid();	
	})
	
});
/*
 * datagrid
 */
function init_wdg(){
	var dgColumns = [[
			{field:'ID',title:'Id',hidden:true},
			{field:'TableName',title:'类名'},
			{field:'ClassName',title:'代码/表名'},
			{field:'TableDesc',title:'描述'}
			
		]];
	// 初始化DataGrid
	$('#wdg').datagrid({
		data:{'rows':[],'total':'0'},
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		fitColumns: true,
		onDblClickRow:function(index,rowData){
			checkPassward(index,rowData)	
		},
		frozenColumns:[[
			{
				field: 'Option', title: '对照', width: 50
				,formatter:function(value,rowData,index){
					return "<a href='#' onclick='checkPassward("+index+','+JSON.stringify(rowData)+")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png ' border=0/>\
					</a>";
				}
			}
		]]
	});
		
}
function checkPassward(index,rowData){
	var selectedRow = $('#dg').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请先选择左边的数据','info');
		return;	
	}
	if(selectedRow.cBill1!=""){
		$.messager.confirm('提示',selectedRow.cDesc + '已经存在对照，是否继续进行更换？',function(r1){
			if(r1){
				if(PassWardFlag == "N"){
			    	$.messager.prompt("提示", "请输入密码", function (r) { // prompt 此处需要考虑为非阻塞的
						if (r) {
							PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
							if(PassWardFlag=='Y'){ 
								SaveCon(index,rowData,selectedRow)
							}else{
								$.messager.alert('提示','密码错误!','info')
								return false;
							};
						} else {
							return false;
						}
					})
				}else{
					SaveCon(index,rowData,selectedRow);  
				}		
			}	
		})	
	}else{
		if(PassWardFlag == "N"){
			$.messager.prompt("提示", "请输入密码", function (r) { // prompt 此处需要考虑为非阻塞的
				if (r) {
					PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
					if(PassWardFlag=='Y'){ 
						SaveCon(index,rowData,selectedRow)
					}else{
						$.messager.alert('提示','密码错误!','info')
						return false;
					}; 
				} else {
					return false;
				}
			})
		}else{
			SaveCon(index,rowData,selectedRow);  
		}	
	}
	
	
}
function SaveCon(index,rowData,selectedRow){
	if(!rowData.ClassName){
		$.messager.alert('提示','表名不能为空','info')
		return;	
	}
	var rtn = tkMakeServerCall("web.INSUDicDataCom","UpdaDicInfoByJson",'{"INDIDDicBill1":"' + rowData.ClassName + '"}',selectedRow.id);
	if(rtn==0){
		$.messager.alert('提示','保存成功','info',function(){
			loadINSUDataGrid();	
		});		
	}
}

/*
 * datagrid
 */
function init_dg(){
	var dgColumns = [[
			{field:'id',hidden:true},
			{field:'cCode',title:'字典代码'},
			{field:'cDesc',title:'字典描述'},
			{field:'cBill1',title:'对照代码'},
			/*{field:'cBill2',title:'医保描述'},*/
		]];
	// 初始化DataGrid
	$('#dg').datagrid({
		data:{'rows':[],'total':'0'},
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		fitColumns: true
	});
		
}

/*
 * 加载数据 医保字典
 */
function loadINSUDataGrid(){
	var QueryParam={
		ClassName:'web.INSUDicDataCom' ,
		QueryName: 'QueryDicINSUBDPTableList',
		type :'INSUConBDPTableList', 
		CodeAndDesc : getValueById('Keywords'),
		ConFlag : getValueById('QFactor')
	}
	loadDataGridStore('dg',QueryParam);
}
/*
 * 加载数据 表结构登记
 */
 // RowId As %String, code As %String, desc As %String, table As %String, attribute As %String, datatype As %String, uniteflag As %String, type
function loadBDPDataGrid(){
	var QFactor = getValueById('r-QFactor');
	var tmpTable='';
	var tmpClass='';
	if(QFactor==1){
		tmpClass = getValueById('r-Keywords');	
	}else{
		tmpTable = getValueById('r-Keywords');
	}
    var queryParams = {
	    ClassName : 'web.DHCBL.BDP.BDPTableList',
	    QueryName : 'GetList',
	    RowId : '',
	    code : tmpTable,
	    desc : '',
	    table : tmpClass,
	    attribute : '',
	    datatype : '',
	    uniteflag: '',
	    type : '医保'
	}	
    loadDataGridStore('wdg',queryParams);
}  
function init_rQFactor(){
	// 查询条件
	$('#r-QFactor').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    editable:false,
	    data: [
	    	{
				Code: '1',
				Desc: '按表名',
				selected:true
			},{
				Code: '2',
				Desc: '按类名'
			}]
	}); 	
}
function init_QFactor(){
	// 查询条件
	$('#QFactor').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    editable:false,
	    data: [{
				Code: 'Y',
				Desc: '已对照',
				selected:true
			},{
				Code: 'N',
				Desc: '未对照'
			}]
	}); 	
}
