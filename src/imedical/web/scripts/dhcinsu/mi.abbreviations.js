/**
 * FileName: dhcinsu/mi.abbreviations.js
 * Anchor: tangzf
 * Date: 2021-02-02
 * Description: ���Ұ�-����������
 */
 var Global = {
	SplitWord : {},
	SplitIndex : 0	 
}
 $(function(){
	 init_portargsdicDG();
	 
	 // ����״̬	
	 $("#PUBLISHSTATUS").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:[
	        {text:'�ݸ�',id:'0',selected:true},
	        {text:'���',id:'1'},
	        {text:'����',id:'2'}
	    ],
	    onClick:function(v){
			LoadportargsdicDG();    
		}
	});
	 // ��Ч��ʶ
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
		// ��ѯ��ʽ
	$('#QueryType').combobox({
		valueField: 'id',
		textField: 'desc',
		editable:false,
		data:[
			{
				"id":"0",
				"desc":"ģ����ѯ",
				selected:true
			},
			{
				"id":"1",
				"desc":"��ȷ��ѯ"	
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
				$.messager.confirm('ȷ��','�Ƿ����[�޸�]����Ϊ:' + dgSelect.CONTENTCODE +'������?',function(r){		
					if(r){
						SavePortList();	
					}			
				})
			}else{ // add
				$.messager.confirm('ȷ��','�Ƿ����[����]����?',function(r){		
					if(r){
						SavePortList();	
					}			
				})	
			}
		}
	});
	// ����
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
				$.messager.alert('��ʾ','�ִʲ���Ϊ��','error');
				return;	
			}
			if(getValueById('SplitShow') == ""){
				$.messager.alert('��ʾ','�ִ�չʾ����Ϊ��','error');
				return;	
			}
			$.messager.confirm('ȷ��','�Ƿ������������Ԫ:' + getValueById('SplitShow') + '?',function(r){		
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
		{field:'CHINESEPHRASES',title:'���Ķ���',width:110,align:'center'},
		{field:'ENGLISHNAME',title:'Ӣ����',width:120},
		{field:'ABBREVIATIONS',title:'������',width:70,align:'center',formatter:function(value, data,index){
				var rtn = GLOBAL.CONTENTTYPE[value] || value;
				return rtn ;	
			}
		},
		{field:'EFFTFLAG',title:'��Ч��־',width:100,align:'center',formatter:function(value, data,index){
				var rtn = GLOBAL.EFFTFLAG[value] || value;
				return rtn ;	
			}},
		{field:'PUBLISHSTATUS',title:'����״̬',width:100,align:'center',formatter:function(value, data,index){
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
			$('#Save').linkbutton({text:'�޸�'});
		},
		onUnselect:function(rowIndex, rowData){
			var checkedRows = $('#portargsdicDG').datagrid('getChecked');
			if (checkedRows.length == '0'){
				$('#Save').linkbutton({text:'����'});
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
	$('#Save').linkbutton({text:'����'});
	Global = {
		SplitWord : {},
		SplitIndex : 0	 
	}
}
 // ����
function SavePortList(){
	var PUBLISHSTATUS = '0'; // ֻ�������ݸ�״̬������
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
		INSUMIAlert('����ɹ�' , 'success');
	}else{
		INSUMIAlert('����ʧ�ܣ�'  + rtn , 'error');
	}
	LoadportargsdicDG();
}
// ɾ��
function DeletePortList(){
	var dgSelect = $('#portargsdicDG').datagrid('getSelected');
	var RowId = '';
	if(dgSelect){
		RowId = dgSelect.ROWID;	
	}
	if (RowId == ''){
		INSUMIAlert('��ѡ��Ҫɾ������' , 'error');
		return;	
	}	
	var rtn = $.m({ClassName: "INSU.MI.AbbreviationsCom", MethodName: "Delete", RowId:RowId,}, false);
	if (rtn == '0'){
		INSUMIAlert('ɾ���ɹ�' , 'success');
		LoadportargsdicDG();
	}else{
		INSUMIAlert('ɾ��ʧ��'  + rtn , 'error');
		LoadportargsdicDG();
	}
}

function Operation(type){
	var checkedRows = $('#portargsdicDG').datagrid('getChecked');
	var RowIdStr = '';
	if (checkedRows.length == '0'){
		INSUMIAlert('û����Ҫ����������' , 'info');
		return;
	}
	for (var i = 0; i <= checkedRows.length - 1; i++) {
		RowIdStr = RowIdStr + '^' + checkedRows[i].ROWID; 
	}
	var rtn = $.m({ClassName: "INSU.MI.AbbreviationsCom", MethodName: "UpdatePublishStatusById", Status:type,RowIdStr:RowIdStr,User:session['LOGON.USERID']}, false);
	if (rtn == '0'){
		$.messager.alert('��ʾ','�����ɹ�' , 'success',function(){
			LoadportargsdicDG();
		});
	}else{
		$.messager.alert('��ʾ','����ʧ��' + rtn , 'error',function(){
			//LoadportargsdicDG();
		});
	}	
}
// ��ѡ��
function checkRowHandle(rowIndex, rowData,bool){
	if(getValueById('SplitWords') == ""){
		return; // û����д�ִʲ�����	
	}
	// 1.��ѡ����GLOBAL��ֵ
	if(bool){ // check
		if(!Global.SplitWord[rowData.ABBREVIATIONS]){ // ���ڵĲ��ٽ��и�ֵ
			Global.SplitIndex++;
			Global.SplitWord[rowData.ABBREVIATIONS] = Global.SplitIndex + '|' + rowData.CHINESEPHRASES;		
		}
	}else{ // uncheck
		delete Global.SplitWord[rowData.ABBREVIATIONS];
	}
	// 2.����
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
    // 3.��ֵ
    ShowValue = $.trim(ShowValue);
    setValueById('SplitShow',ShowValue);
    
    ShowDesc = $.trim(ShowDesc);
    setValueById('SplitShowDesc',ShowDesc);		
}
 // ���ɷִ�
function SavePortArgsDic(){
	var PUBLISHSTATUS = '0'; // ֻ�������ݸ�״̬������
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
		$.messager.confirm('ȷ��','����Ԫ���ɳɹ�,�Ƿ���ת������Ԫ�����޸����Ӧ����' , function(r){
			if(r){
				var url = "dhcinsu.mi.portargsdic.csp?&CONTENTCODE=" + CONTENTCODE;
				websys_showModal({
					url: url,
					title: "����Ԫά��",
					iconCls: "icon-w-edit",
					width: "960",
					height: "660"
				});
			}
				
		});
	}else{
		INSUMIAlert('����ʧ�ܣ�'  + rtn , 'error');
	}
}