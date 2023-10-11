/**
 * FileName: dhcinsu/mi.abbreviations.js
 * Anchor: tangzf
 * Date: 2021-02-02
 * Description: 国家版-缩略语配置
 */
 var Global = {
	SplitWord : {},
	SplitIndex : 0	 
}
 $(function(){
	 init_portargsdicDG();
	 
	 // 发布状态	
	 $("#PUBLISHSTATUS").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:[
	        {text:'草稿',id:'0',selected:true},
	        {text:'审核',id:'1'},
	        {text:'发布',id:'2'}
	    ],
	    onClick:function(v){
			LoadportargsdicDG();    
		}
	});
	 // 有效标识
	 $('#EFFTFLAG').combobox({
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'web.INSUDicDataCom';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'EFFTFLAG';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;
		},
		onSelect: function (data) {
		
		}
	});	
		// 查询方式
	$('#QueryType').combobox({
		valueField: 'id',
		textField: 'desc',
		editable:false,
		data:[
			{
				"id":"0",
				"desc":"模糊查询",
				selected:true
			},
			{
				"id":"1",
				"desc":"精确查询"	
			}	
		],
		onSelect:function(){
			setValueById('CHINESEPHRASES',"");
			setValueById('ENGLISHNAME',"");
			setValueById('ABBREVIATIONS',"");
			setValueById('EFFTFLAG',"");	
		}
	});
	$('.textbox').keyup(function(){
		if(event.keyCode==13){
			LoadportargsdicDG();
		}
	});
	$HUI.linkbutton("#Find", {
		onClick: function () {
			LoadportargsdicDG();
		}
	});
	$HUI.linkbutton("#Save", {
		onClick: function () {
			var dgSelect = $('#portargsdicDG').datagrid('getSelected');
			var selectROWID = '';
			if(dgSelect){
				selectROWID = dgSelect.ROWID;	
			}
			if(selectROWID != ''){ // uodate
				$.messager.confirm('确认','是否继续[修改]代码为:' + dgSelect.CONTENTCODE +'的数据?',function(r){		
					if(r){
						SavePortList();	
					}			
				})
			}else{ // add
				$.messager.confirm('确认','是否继续[新增]数据?',function(r){		
					if(r){
						SavePortList();	
					}			
				})	
			}
		}
	});
	// 导入
	$HUI.linkbutton("#Imp", {
		onClick: function () {
			INSUMIFileOpenWindow(import_abbreviationsD);
		}
	});
	$HUI.linkbutton("#Del", {
		onClick: function () {
			DeletePortList();		
		}
	});
	$HUI.linkbutton("#Clean", {
		onClick: function () {
			clean();		
		}
	});
	$HUI.linkbutton("#Build", {
		onClick: function () {
			if(getValueById('SplitWords') == ""){
				$.messager.alert('提示','分词不能为空','error');
				return;	
			}
			if(getValueById('SplitShow') == ""){
				$.messager.alert('提示','分词展示不能为空','error');
				return;	
			}
			$.messager.confirm('确认','是否继续生成数据元:' + getValueById('SplitShow') + '?',function(r){		
				if(r){
					SavePortArgsDic();	
				}			
			})
		}
	});
	LoadportargsdicDG();
})
function init_portargsdicDG(){
	var colums = [[
		{field:'ck',title:'ck',width:220, checkbox:true},
		{field:'CHINESEPHRASES',title:'中文短语',width:110,align:'center'},
		{field:'ENGLISHNAME',title:'英文名',width:120},
		{field:'ABBREVIATIONS',title:'缩略语',width:70,align:'center',formatter:function(value, data,index){
				var rtn = GLOBAL.CONTENTTYPE[value] || value;
				return rtn ;	
			}
		},
		{field:'EFFTFLAG',title:'生效标志',width:100,align:'center',formatter:function(value, data,index){
				var rtn = GLOBAL.EFFTFLAG[value] || value;
				return rtn ;	
			}},
		{field:'PUBLISHSTATUS',title:'发布状态',width:100,align:'center',formatter:function(value, data,index){
				var rtn = GLOBAL.PUBLISHSTATUS[value] || value;
				return rtn ;	
			}},
		{field:'ROWID',title:'ROWID',width:48,align:'center',hidden:true}
	]];
	$HUI.datagrid('#portargsdicDG',{
		border:false,
		//fitColumns: true,
		singleSelect: false,
		data: [],
		fit:true,
		columns:colums,
		pageSize:30,
		pageList:[30,60,90],
		pagination:true,
		toolbar:'#TB',
		onLoadSuccess:function(data){

		},
		onDblClickRow:function(){
			
		},
		onSelect:function(rowIndex, rowData){
			FillportargsdicDG(rowData);
			$('#Save').linkbutton({text:'修改'});
		},
		onUnselect:function(rowIndex, rowData){
			var checkedRows = $('#portargsdicDG').datagrid('getChecked');
			if (checkedRows.length == '0'){
				$('#Save').linkbutton({text:'新增'});
			} 
		},
		onCheck:function(rowIndex, rowData){
			checkRowHandle(rowIndex, rowData,true);
		},
		onUncheck:function(rowIndex, rowData){
			checkRowHandle(rowIndex, rowData,false);
		}		
	});		
}
function FillportargsdicDG(rowData){
	setValueById('CHINESEPHRASES',rowData.CHINESEPHRASES);
	setValueById('ENGLISHNAME',rowData.ENGLISHNAME);
	setValueById('ABBREVIATIONS',rowData.ABBREVIATIONS);
	setValueById('EFFTFLAG',rowData.EFFTFLAG);
}
function LoadportargsdicDG(){
	var PUBLISHSTATUS = $('#PUBLISHSTATUS').keywords('getSelected')[0].id;
	var CHINESEPHRASES = getValueById('CHINESEPHRASES');
	var ENGLISHNAME = getValueById('ENGLISHNAME');
	var ABBREVIATIONS = getValueById('ABBREVIATIONS');
	var EFFTFLAG = getValueById('EFFTFLAG');
	var ParamInput = PUBLISHSTATUS + "|" + CHINESEPHRASES + "|" + ENGLISHNAME + "|"  + ABBREVIATIONS + "|"  + EFFTFLAG;
	var queryParams = {
	    ClassName : 'INSU.MI.AbbreviationsCom',
	    QueryName : 'QueryAbbreviations',
	    ParamInput : ParamInput ,
	    SplitWords:getValueById('SplitWords') ,
	    SearchType:getValueById('QueryType')  
	}	
    loadDataGridStore('portargsdicDG',queryParams);	
    //clean();			
}
function clean(){
	setValueById('CHINESEPHRASES',"");
	setValueById('ENGLISHNAME',"");
	setValueById('ABBREVIATIONS',"");
	setValueById('EFFTFLAG',"");
	setValueById('QueryType',"0");
	setValueById('SplitWords',"");	
	setValueById('SplitShow',"");			
	$('#portargsdicDG').datagrid('unselectAll');
	$('#portargsdicDG').datagrid('uncheckAll');
	$('#Save').linkbutton({text:'新增'});
	Global = {
		SplitWord : {},
		SplitIndex : 0	 
	}
}
 // 保存
function SavePortList(){
	var PUBLISHSTATUS = '0'; // 只能新增草稿状态的数据
	var EFFTFLAG = getValueById('EFFTFLAG');
	var CHINESEPHRASES = getValueById('CHINESEPHRASES');
	var ENGLISHNAME = getValueById('ENGLISHNAME');
	var ABBREVIATIONS = getValueById('ABBREVIATIONS');
	var dgSelect = $('#portargsdicDG').datagrid('getSelected');
	var selectROWID = '';
	if(dgSelect){
		selectROWID = dgSelect.ROWID;
		PUBLISHSTATUS = $('#PUBLISHSTATUS').keywords('getSelected')[0].id; //	
	}
	
	var InStr = selectROWID + '^' + PUBLISHSTATUS    + '^' + CHINESEPHRASES + '^' + ENGLISHNAME + '^' + ABBREVIATIONS;
	InStr = InStr + '^' + EFFTFLAG ;
	
	var rtn = $.m({ClassName: "INSU.MI.AbbreviationsCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
	if (rtn == '0'){
		INSUMIAlert('保存成功' , 'success');
	}else{
		INSUMIAlert('保存失败：'  + rtn , 'error');
	}
	LoadportargsdicDG();
}
// 删除
function DeletePortList(){
	var dgSelect = $('#portargsdicDG').datagrid('getSelected');
	var RowId = '';
	if(dgSelect){
		RowId = dgSelect.ROWID;	
	}
	if (RowId == ''){
		INSUMIAlert('请选择要删除的行' , 'error');
		return;	
	}	
	var rtn = $.m({ClassName: "INSU.MI.AbbreviationsCom", MethodName: "Delete", RowId:RowId,}, false);
	if (rtn == '0'){
		INSUMIAlert('删除成功' , 'success');
		LoadportargsdicDG();
	}else{
		INSUMIAlert('删除失败'  + rtn , 'error');
		LoadportargsdicDG();
	}
}

function Operation(type){
	var checkedRows = $('#portargsdicDG').datagrid('getChecked');
	var RowIdStr = '';
	if (checkedRows.length == '0'){
		INSUMIAlert('没有需要操作的数据' , 'info');
		return;
	}
	for (var i = 0; i <= checkedRows.length - 1; i++) {
		RowIdStr = RowIdStr + '^' + checkedRows[i].ROWID; 
	}
	var rtn = $.m({ClassName: "INSU.MI.AbbreviationsCom", MethodName: "UpdatePublishStatusById", Status:type,RowIdStr:RowIdStr,User:session['LOGON.USERID']}, false);
	if (rtn == '0'){
		$.messager.alert('提示','操作成功' , 'success',function(){
			LoadportargsdicDG();
		});
	}else{
		$.messager.alert('提示','操作失败' + rtn , 'error',function(){
			//LoadportargsdicDG();
		});
	}	
}
// 行选中
function checkRowHandle(rowIndex, rowData,bool){
	if(getValueById('SplitWords') == ""){
		return; // 没有填写分词不生成	
	}
	// 1.勾选先往GLOBAL赋值
	if(bool){ // check
		if(!Global.SplitWord[rowData.ABBREVIATIONS]){ // 存在的不再进行赋值
			Global.SplitIndex++;
			Global.SplitWord[rowData.ABBREVIATIONS] = Global.SplitIndex + '|' + rowData.CHINESEPHRASES;		
		}
	}else{ // uncheck
		delete Global.SplitWord[rowData.ABBREVIATIONS];
	}
	// 2.排序
	var tmpObj = {};
	for (var Key in Global.SplitWord){
		var Index = Global.SplitWord[Key].split('|')[0];
		tmpObj[Index] = Key + '|' + Global.SplitWord[Key].split('|')[1];
    }
    var ShowValue = "";
    var ShowDesc = "";
    for (var Key in tmpObj){
		ShowValue = ShowValue + ' ' + tmpObj[Key].split('|')[0];
		ShowDesc = ShowDesc + tmpObj[Key].split('|')[1];	
    }
    // 3.赋值
    ShowValue = $.trim(ShowValue);
    setValueById('SplitShow',ShowValue);
    
    ShowDesc = $.trim(ShowDesc);
    setValueById('SplitShowDesc',ShowDesc);		
}
 // 生成分词
function SavePortArgsDic(){
	var PUBLISHSTATUS = '0'; // 只能新增草稿状态的数据
	var CONTENTCODE = getValueById('SplitShow');
	var CONTENTNAME = getValueById('SplitShowDesc');
	var CONTENTTYPE = '';
	var CONTENTLENG = '';
	var CONTENTDICFLAG = '';
	var CONTENTMUSTLFLAG = '';
	var EFFTFLAG = '';
	var VER = '0';
	var InStr = '' + '^' + PUBLISHSTATUS    + '^' + CONTENTCODE + '^' + CONTENTNAME + '^' + CONTENTTYPE;
	var InStr = InStr + '^' + CONTENTLENG  + '^' + CONTENTDICFLAG + '^' + CONTENTMUSTLFLAG  + '^' + EFFTFLAG+ '^'  + VER;
	
	var rtn = $.m({ClassName: "INSU.MI.PortArgsDicCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
	if (rtn == '0'){
		$.messager.confirm('确认','数据元生成成功,是否跳转到数据元界面修改其对应属性' , function(r){
			if(r){
				var url = "dhcinsu.mi.portargsdic.csp?&CONTENTCODE=" + CONTENTCODE;
				websys_showModal({
					url: url,
					title: "数据元维护",
					iconCls: "icon-w-edit",
					width: "960",
					height: "660"
				});
			}
				
		});
	}else{
		INSUMIAlert('保存失败：'  + rtn , 'error');
	}
}