/**
 * FileName: dhcinsu/mi.main.js
 * Anchor: tangzf
 * Date: 2021-02-02
 * Description: ���Ұ�-ҽ�������ϴ�
 */
 
 
 var Global = {
	Com : {
		ClassName :'INSU.COM.BaseData' // Global.Com.ClassName
	},
	PortConfig:{
		ClassName :'INSU.MI.PortConfig' // Global.PortConfig.ClassName
	},
	PortList:{
		ClassName :''
	},
	PortInArgs:{
		ClassName :''
	},
	PortNode:{
		ClassName :'INSU.MI.PortNodeCom'
	},
	QueryStr:'',
	Operator:''	,
	wdgSeq:[],
	edgSeq:[],
	HOSPID: session['LOGON.HOSPID']
}
// PUBLIC_CONSTANT.SESSION.HOSPID
var PUBLIC_CONSTANT = {
	SESSION: {
		HOSPID: session['LOGON.HOSPID'],
	}
}

$(function(){
	// hospital
	init_hosp(); //--�ӱ�ṹ�ǼǱ��ȡԺ��
	
	// insutype
	init_insuType();
	
	// AuditFlag
	init_auditFlag();
	
	// center
	init_dg();
	
	// west 
	init_wdg();
	
	// east
	init_edg();

	// PortCommon  - window
	init_PortCommonDg();

	// PortRoot - window 
	init_PortRootDg();
	
	init_INSUMIType(); // �������� 0�����£�1������
	// dg 
	init_dgEvent();
	init_wdgEvent();
	init_edgEvent();
	init_Keyup();
});
function init_dgEvent(){
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			Load_dg_DataGrid();
		}
	});
	$HUI.linkbutton("#btnAdd", {
		onClick: function () {
			dg_addRow();
		}
	});
	$HUI.linkbutton("#btnEndEdit", {
		onClick: function () {
			DG_EndEdit();
		}
	});
	$HUI.linkbutton("#btnSaveSingle", {
		onClick: function () {
			SaveSingle();
		}
	});
	$HUI.linkbutton("#btnSaveAll", {
		onClick: function () {
			SaveMult();
		}
	});
	
	$HUI.linkbutton("#btnPubConfig", {
		onClick: function () {
			var HospID =PUBLIC_CONSTANT.SESSION.HOSPID  //$('#Hospital').combobox('getValue');
			var InsuType = $('#InsuType').combobox('getValue');
			if(HospID == ""){
				$.messager.alert('��ʾ','��ѡ��Ժ��','info');
				return;	
			}
			if(InsuType == ""){
				$.messager.alert('��ʾ','��ѡ��ҽ������','info');
				return;	
			}
			$('#PubConfigWin').show(); 
			$HUI.dialog("#PubConfigWin",{
					title:'������������',
					height:669,
					width:871,
					collapsible:false,
					modal:true,
				    iconCls: 'icon-w-edit'
			})
			$("#addInfo").form("clear");
            var HospID = $('#Hospital').combogrid('getText');
            var InsuType = $('#InsuType').combobox('getText'); 
            $('#PortCom-HOSPID').val(HospID);
            $('#PortCom-HITYPE').val(InsuType);
            LoadPubDG();
		}
	});
	$HUI.linkbutton("#btnPointConfig", {
		onClick: function () {
			var dgSelected = $('#dg').datagrid('getSelected');
			if(!dgSelected){
				$.messager.alert('��ʾ','��ѡ��ӿ�','info');
				return;		
			}
			if(dgSelected.ROWID == ''){
				$.messager.alert('��ʾ','��ѡ����Ч�Ľӿ�','info');
				return;	
			}
			var HospID = dgSelected.HOSPID;
			var InsuType = dgSelected.HITYPE;
			if(HospID == ""){
				$.messager.alert('��ʾ','�ӿ�δά��Ժ��','info');
				return;	
			}
			if(InsuType == ""){
				$.messager.alert('��ʾ','�ӿ�δά��ҽ������','info');
				return;	
			}
			$('#PointConfigWin').show(); 
			$HUI.dialog("#PointConfigWin",{
					title:'���ڵ�����',
					height:642,
					width:895,
					collapsible:false,
					modal:true,
				    iconCls: 'icon-w-edit'
			});
			$("#addInfoRoot").form("clear");
			var dgIndex = $('#dg').datagrid('getRowIndex',dgSelected);
			var HOSPID = INSUMIDataGrid.getCellVal('dg',dgIndex,'HOSPID');
			var HITYPE = INSUMIDataGrid.getCellVal('dg',dgIndex,'HITYPE');
			$('#PortRoot-HOSPID').val(HOSPID);
			$('#PortRoot-HITYPE').val(HITYPE);
			
			var INFNO = INSUMIDataGrid.getCellVal('dg',dgIndex,'INFNO');
			var INFNAME = INSUMIDataGrid.getCellVal('dg',dgIndex,'INFNAME');
			$('#PortRoot-INFNO').val(INFNO);
			$('#PortRoot-INFNAME').val(INFNAME);
			
			LoadPortRoot();
		}
	});
	$HUI.linkbutton("#btnStedit", {
		onClick: function () {
			stEdit();
		}
	});
	$HUI.linkbutton("#btnDelDG", {
		onClick: function () {
			var edgSelect = $('#dg').datagrid('getSelected');
			if(!edgSelect){
				INSUMIAlert('��ѡ��Ҫɾ��������' , 'error');
		        return ;	
			}
			if (!edgSelect.ROWID){
				var Index = $('#dg').datagrid('getRowIndex',edgSelect);
				$('#dg').datagrid('deleteRow',Index);	
				return;
			}
			$.messager.confirm('��ʾ','�Ƿ����ɾ��������?�ò�����ɾ����Ӧ�Ĳ���',function(r){
				if(r){
					$.messager.confirm('ȷ��','�Ƿ����ɾ��������?�ò�����ɾ���ӿ��Լ�(���½ǡ����½�����)',function(r){
						if(r){
							var rtn = $.m({ClassName: "INSU.MI.PortListCom", MethodName: "DeleteListNodeArgs", id: edgSelect.ROWID}, false);
							if(rtn == '0'){
								INSUMIPOP('ɾ���ɹ�' , 'success');
							}else{
								INSUMIPOP('ɾ��ʧ��' , 'error');
							}
							Load_dg_DataGrid();
						}		
					});
				}		
			});
		}
	});
	$HUI.linkbutton("#btnBuildData", {
		onClick: function () {
			var edgSelect = $('#dg').datagrid('getSelected');
			if(!edgSelect){
				INSUMIAlert('��ѡ��Ҫ���ɵ�����' , 'error');
		        return ;	
			}
			$.messager.confirm('��ʾ','�Ƿ������������',function(r){
				if(r){
	        		var rtn = $.m({ClassName: Global.PortConfig.ClassName, MethodName: "BuildDefaultPortNodeData", PARNODETYPE:'' ,PortListID: edgSelect.ROWID}, false);
					if(rtn == '0'){
						INSUMIPOP('���ɳɹ�' , 'success');
					}else{
						INSUMIPOP('����ʧ��' , 'error');
					}
					Load_wdg_DataGrid();
				}		
			});
		}
	});
	$HUI.linkbutton("#btnAudit", {
		onClick: function () {
			var edgSelect = $('#dg').datagrid('getSelected');
			if(!edgSelect){
				INSUMIAlert('��ѡ��Ҫ��˵�����' , 'error');
		        return ;	
			}
			if(getValueById('AuditFlag') == ""){
				INSUMIAlert('��˱�־����Ϊ��' , 'error');
		        return ;	
			}
			var Msg = '�Ƿ��������������˳ɡ�' + $('#AuditFlag').combobox('getText') + '��';
			if(getValueById('AuditFlag') == '2'){
				Msg = Msg + '�����Ϊ�����Ժ󽫲������޸��κ����ݡ�'	
			}
			$.messager.confirm('��ʾ',Msg,function(r){
				if(r){
	        		var rtn = $.m({ClassName: 'INSU.MI.PortListCom', MethodName: "Audit",PUBLISHSTATUS:getValueById('AuditFlag'), SessionStr:session['LOGON.USERID'],RowId: edgSelect.ROWID}, false);
					if(rtn == '0'){
						INSUMIPOP('��˳ɹ�' , 'success');
					}else{
						INSUMIPOP('���ʧ��' , 'error');
					}
					Load_dg_DataGrid();
				}		
			});
		}
	});
	$HUI.linkbutton("#btnExport", {
		onClick: function () {
			ExportALLData();		
		}
	});
	$HUI.linkbutton("#btnImport", {
		onClick: function () {
			ImportAllData();		
		}
	});
	// ����չʾ
	$HUI.linkbutton("#btnParamShow", {
		onClick: function () {
			var dgSelected = $('#dg').datagrid('getSelected');
			if(!dgSelected){
				$.messager.alert('��ʾ','��ѡ��ӿ�','info');	
				return;
			}
			var ClassName = dgSelected.CLASSNAME;
			var MethodName = dgSelected.METHODNAME;
			if(ClassName == ""){
				$.messager.alert('��ʾ','�ӿ��б����಻��Ϊ��','info');
				return;
			}
			if(MethodName == ""){
				$.messager.alert('��ʾ','�ӿ��б��з�������Ϊ��','info');
				return;
			}
			showParamWindow();		
		}
	});	
	$HUI.linkbutton("#BuildParam", {
		onClick: function () {
			BuildOutputParam();		
		}
	});
}
// ���ɲ���
function BuildOutputParam(){
	var dgSelected = $('#dg').datagrid('getSelected');
	if(!dgSelected){
		$.messager.alert('��ʾ','��ѡ��ӿ�','info');
		return;	
	}
	var ClassName = dgSelected.CLASSNAME;
	var MethodName = dgSelected.METHODNAME;
	var INFNO = dgSelected.INFNO;
	var HospId = dgSelected.HOSPID;
	var CONTENTTYPE = dgSelected.CONTENTTYPE;
	if(ClassName == ""){
		$.messager.alert('��ʾ','�ӿ��б����಻��Ϊ��','info');
		return;
	}
	if(MethodName == ""){
		$.messager.alert('��ʾ','�ӿ��б��з�������Ϊ��','info');
		return;
	}
	if(CONTENTTYPE == ""){
		$.messager.alert('��ʾ','�����������Ͳ���Ϊ��','info');
		return;
	}
	var inputArr = $('#addInfoParamShow').find('input');
	var inputArrLen = inputArr.length;
	var InputParam = {
		ClassName: ClassName,
		MethodName: MethodName
	};
	var parentInput = $('.tb300');
	for (var index = 0;index < parentInput.length;index++){
		var parentVal = parentInput[index].value;
		var parentid = parentInput[index].id;
		var ChildNodeArr = $('.ChildNode');
		
		for (var ChildNodeindex = 0;ChildNodeindex < ChildNodeArr.length;ChildNodeindex++){
			var childData = $(ChildNodeArr[ChildNodeindex]).attr('data');
			var childVal = $(ChildNodeArr[ChildNodeindex]).val();
			if(childData == parentid){
				if (parentVal=="") parentVal=childVal;
				else parentVal = parentVal + '^' +childVal;
			}	
		}
		parentVal = parentVal==""?parentInput[index].value:parentVal;
		InputParam[parentid] = parentVal;
		
	}
	var InputInfo = $.m(InputParam, false);
	$('#OutPutParam').val(InputInfo);	
}
// ������Ϣչʾ
function showParamWindow(){
	try{
		var dgSelected = $('#dg').datagrid('getSelected');
		if(!dgSelected){
			$.messager.alert('��ʾ','��ѡ��ӿ�','info');
			return;	
		}
		var INFNO = dgSelected.INFNO;
		var HospId = dgSelected.HOSPID; // InfoNo, HospId, InsuType, PortRootNode
		var InsuType = dgSelected.HITYPE;
		if(HospId == "" || InsuType == ""){
			$.messager.alert('��ʾ','�ӿڵ�ҽ�����ͻ���Ժ������Ϊ��','info')	;
			return;
		}
		var InputInfo = $.m({ClassName: "INSU.MI.PortRoot", MethodName: "GetConinfoByInfoNoHospInsuType", InfoNo:INFNO,HospId:HospId,InsuType:InsuType,PortRootNode:'InputParam'}, false);
		var htmlStr = "";
		if(InputInfo.split('^')[0] < 0){
			$.messager.alert('��ʾ','δ���ýӿ��෽������δ�ڸ��ڵ�����InputParam����','info')	;
			return;
		}
		InputInfo = InputInfo.split('^')[7];
		var InputConfigObj = JSON.parse(InputInfo);
		
		var ColLen = 5; // three col �˴���������
		var tmpCol = 1;
		var totalRow = 0;
		
		
		var tmpIndex = 0;
		
		//��������
		for (key in InputConfigObj){
			var LabelId = key;
			var defVal = "";
			var LabelText = InputConfigObj[key];
			var keyVal = InputConfigObj[key];
			var parentClass = '';
			if (typeof keyVal == "object"){
					//����һ��
					htmlStr = htmlStr + "<tr class='auto'>";
					totalRow++;
					tmpCol = ColLen;
					LabelText = LabelId;
					buildData('tb300');
					//����һ��
					for (j in keyVal){
						parentClass = key;
						LabelId = j;
						LabelText = j;
						defVal = keyVal[j];	
						if(keyVal[j].split('=').length > 1){ // ά����Ĭ��ֵ
							defVal = keyVal[j].split('=')[1];
							LabelText = keyVal[j].split('=')[0];
						}
						buildData('');
					}
			}else{
				
				if(LabelText.split('=').length > 1){ // ά����Ĭ��ֵ
					defVal = LabelText.split('=')[1];
					LabelText = LabelText.split('=')[0];
					LabelId = key;
				}
				//����һ��
				htmlStr = htmlStr + "<tr class='auto'>";
				totalRow++;
				tmpCol = ColLen;
				LabelText = LabelId;
				buildData('tb300');
				//����һ��	
			}
		}
		var InputInfoLen = InputInfo.split('$').length;

		var defaultHeight = 463 + (totalRow-1) * 38; // Ĭ��һ�и߶�556px ÿ��һ�в���+38
		$('.auto').remove();
		$("#addInfoParamShow").prepend(htmlStr);	 
		//    
		$('#ParamShowWin').show(); 
		$HUI.dialog("#ParamShowWin",{
				title:'����չʾ',
				height:(defaultHeight+8),
				width:922,
				collapsible:false,
				modal:true,
			    iconCls: 'icon-w-edit'
		});
	}catch(e){
		$.messager.alert('��ʾ','���ɽ��淢���쳣:' + e.responseText,'info')
	}
	// ��������
	function buildData(SingleParam){
		var FirstCol = '';
		if(tmpCol==1){
			htmlStr = htmlStr + "<tr class='auto'>";	
			FirstCol = "r-label-1";
			totalRow++;
		}
		var colspan = "";
		var PaChLabel = '(��)';
		if(SingleParam != ""){
			colspan = "colspan=99";
			PaChLabel = '(��)';
		}
		LabelText = PaChLabel + LabelText;
		var ChildNode = parentClass == "" ?ChildNode="":"ChildNode";
		
		htmlStr = htmlStr + "<td class='auto r-label " + FirstCol +  "'><label>" + LabelText + "</label><td>";
		htmlStr	= htmlStr + "<td class='auto' " +colspan+  " ><input data='" + parentClass + "' placeholder='" + LabelId +"' class='auto textbox " + SingleParam + ' ' + ChildNode + "' id='" + LabelId +  "' value='" + defVal + "' /></td>";	
		if((tmpCol == ColLen ) || ((tmpIndex+1)==InputInfoLen)){
			htmlStr = htmlStr + "</tr>";	
		}
		if(tmpCol == ColLen){
			tmpCol = 1;	
		}else{
			tmpCol++;
		}
		
	}
}
function init_wdgEvent(){
	// west EVent
	$HUI.linkbutton("#west-btnFind", {
		onClick: function () {
			Load_wdg_DataGrid();
		}
	});
	// west EVent
	$HUI.linkbutton("#west-add", {
		onClick: function () {
			wdg_addRow();
		}
	});
	$HUI.linkbutton("#west-endEdit", {
		onClick: function () {
			WestEndEdit();
		}
	});
	$HUI.linkbutton("#west-save", {
		onClick: function () {
			wdg_SaveMultRow();
		}
	});
	$HUI.linkbutton("#west-comp", {
		onClick: function () {
			var url = "dhcinsu.mi.portargsdic.csp";
			websys_showModal({
				url: url,
				title: "����Ԫ�ֵ�ά��",
				iconCls: "icon-w-edit",
				width: "1120",
				height: "660",
				onClose: function()
				{
				}
			});
		}
	});
	$HUI.linkbutton("#west-imp", {
		onClick: function () {
			var dgSelect = $('#dg').datagrid('getSelected');
			if(!dgSelect){
				INSUMIAlert('����ѡ��ӿ�' , 'error');
		        return ;	
			}
			INSUMIFileOpenWindow(import_PortNode);
		}
	});
	$HUI.linkbutton("#west-del", {
		onClick: function () {
			var edgSelect = $('#wdg').datagrid('getSelected');
			if(!edgSelect){
				INSUMIAlert('��ѡ��Ҫɾ��������' , 'error');
		        return ;	
			}
			if (!edgSelect.ROWID){
				var Index = $('#wdg').datagrid('getRowIndex',edgSelect);
				var tmpSeq = INSUMIDataGrid.getCellVal('wdg',Index,'SEQ');
				$('#wdg').datagrid('deleteRow',Index);	
				Global.wdgSeq.splice(Global.wdgSeq.indexOf(tmpSeq), 1);
				return;
			}
			$.messager.confirm('��ʾ','�Ƿ����ɾ��������?�ò�����ɾ����Ӧ�Ĳ���',function(r){
				if(r){
					$.messager.confirm('��ʾ','�Ƿ����ɾ��������?�ò�����ɾ��ѡ�нڵ��Լ������½ǵ�����',function(r){
						if(r){
							var rtn = $.m({ClassName: "INSU.MI.PortNodeCom", MethodName: "DeleteNodeAndInargs", id: edgSelect.ROWID}, false);
							if(rtn == '0'){
								INSUMIPOP('ɾ���ɹ�' , 'success');
							}else{
								INSUMIPOP('ɾ��ʧ��' , 'error');
							}
							Load_wdg_DataGrid();
						}		
					});
				}		
			});
			
		}
	});
}
function init_edgEvent(){
	$HUI.linkbutton("#east-deleteALLCon", {
		onClick: function () {
			var edgSelect = $('#wdg').datagrid('getSelected'); //���ڵ�ID
			if(!edgSelect){
				INSUMIAlert('�������ѡ��һ��' , 'error');
		        return ;	
			}
			$.messager.confirm('��ʾ','�Ƿ����ɾ���ö��չ�ϵ?',function(r){
				if(r){
					var rtn = $.m({ClassName: "INSU.MI.PortInArgsCom", MethodName: "DeleteALLConByRowId", RowId: edgSelect.ROWID}, false);
					if(rtn == '0'){
						INSUMIPOP('ɾ���ɹ�' , 'success');
					}else{
						INSUMIPOP('ɾ��ʧ��' , 'error');
					}
					Load_edg_DataGrid();			
				}
					
			});
		}
	});
	$HUI.linkbutton("#east-deleteCon", {
		onClick: function () {
			var edgSelect = $('#edg').datagrid('getSelected');
			if(!edgSelect){
				INSUMIAlert('��ѡ��Ҫɾ��������' , 'error');
		        return ;	
			}
			$.messager.confirm('��ʾ','�Ƿ����ɾ���ö��չ�ϵ?',function(r){
				var rtn = $.m({ClassName: "INSU.MI.PortInArgsCom", MethodName: "DeleteConByRowId", RowId: edgSelect.ROWID}, false);
				if(rtn == '0'){
					INSUMIPOP('ɾ���ɹ�' , 'success');
				}else{
					INSUMIPOP('ɾ��ʧ��' , 'error');
				}
				Load_edg_DataGrid();	
			});
		}
	});
	$HUI.linkbutton("#east-delete", {
		onClick: function () {
			var edgSelect = $('#edg').datagrid('getSelected');
			if(!edgSelect){
				INSUMIAlert('��ѡ��Ҫɾ��������' , 'error');
		        return ;	
			}
			if (!edgSelect.ROWID){
				var Index = $('#edg').datagrid('getRowIndex',edgSelect);
				var tmpSeq = INSUMIDataGrid.getCellVal('edg',Index,'SEQ');
				$('#edg').datagrid('deleteRow',Index);	
				Global.edgSeq.splice(Global.edgSeq.indexOf(tmpSeq), 1);
				return;
			}
			$.messager.confirm('��ʾ','�Ƿ����ɾ��������?',function(r){
				if(r){
					var rtn = $.m({ClassName: "INSU.MI.PortInArgsCom", MethodName: "DeleteByRowId", RowId: edgSelect.ROWID}, false);
					if(rtn == '0'){
						INSUMIPOP('ɾ���ɹ�' , 'success');
					}else{
						INSUMIPOP('ɾ��ʧ��' , 'error');
					}
					Load_edg_DataGrid();
				}		
			});
		}
	});
	$HUI.linkbutton("#east-stedit", {
		onClick: function () {
			EastBeginEdit("","");
		}
	});
	$HUI.linkbutton("#east-btnFind", {
		onClick: function () {
			Load_edg_DataGrid();
		}
	});
	$HUI.linkbutton("#east-add", {
		onClick: function () {
			edg_addRow();
		}
	});
	$HUI.linkbutton("#east-endEdit", {
		onClick: function () {
			EastEndEdit();
		}
	});	
	$HUI.linkbutton("#east-save", {
		onClick: function () {
			edg_SaveSingle();
		}
	});	
	$HUI.linkbutton("#east-imp", {
		onClick: function () {
			var dgSelect = $('#wdg').datagrid('getSelected');
			if(!dgSelect){
				INSUMIAlert('����ѡ�����ݽڵ�' , 'error');
		        return ;	
			}
			INSUMIFileOpenWindow(import_PortInArgs);
		}
	});	
}


// ��������
 function init_INSUMIType(){
	$('#TYPE').combobox({
		defaultFilter: 4,
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'INSU.COM.BaseData';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'INSUMIType';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {
		},onLoadSuccess:function(){

		}
	});		 
	 
}
/**
 * Creator: tangzf
 * CreatDate: 
 * Description: 
 */
function init_Keyup() {
	$("#edgKeyInput").keydown(function (e) {
		Load_edg_DataGrid();
	});
	$("#ParamPortInfo").keydown(function (e) {
		if(e.keyCode==13){
			Load_dg_DataGrid();
		}
	});
}
// 
function init_dg() { 
	$('#dg').datagrid({
		autoSizeColumn:false,
		fit:true,	
		striped:true,
		singleSelect: true,
		pageSize: 10,
		data: [],
		toolbar:'#dgTB',
		pagination:true,
		rownumbers:false,
		columns:[[
			{field:'INFNO',title:'���ױ��',width:80,editor:{
				type: 'combogrid',
				options: {
					idField: 'INFNO',
					textField: 'INFNAME',
					url:$URL,
					required:true,
					panelWidth:350, 
					mode:'remote',  
					columns:[[   
						{field:'INFNO',title:'���ױ��',width:150},
						{field:'INFNAME',title:'��������',width:150}
				    ]],
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.MI.PortFunListCom';
				      	param.QueryName = 'QueryPortFunList';
				      	param.ExpStr = '||' + param.q;
				      	param.page = 1;
				      	param.rows = 9999;
				      	return true;
					},
					onSelect: function (index,data) {		
						var SelectIndex = INSUMIGetEditRowIndexByID('dg');		
						INSUMIDataGrid.setGridVal('dg',SelectIndex,'INFNAME',data.INFNAME);
					}
				}
			}},
			{field:'INFNAME',title:'��������',width:130,editor:{
				type: 'validatebox',
				options: {
					required:true
				}
			}},
			{field:'Timeout',title:'��ʱ',width:65,editor:{
				type: 'text'
			},hidden:true},
			{field:'HISVER',title:'�ӿڰ汾',width:70,editor:{
				type: 'text'
			}},
			{field:'URL',title:'����·��',width:120,editor:{
				type: 'text'
			}},
			{field:'CONTENTTYPE',title:'������������',width:120,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					editable:false,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'CONTENTTYPE';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.CONTENTTYPE[value];
				return rtn ;	
			}},
			
			{field:'TYPE',title:'��������',width:70,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					mode:'remote',
					editable:false,
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'INSUMIType';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.INSUMIType[value];
				return rtn ;	
			}	
			},
			{field:'CLASSNAME',title:'����',width:110,editor:{
				type: 'text'
			}},
			{field:'METHODNAME',title:'������',width:110,editor:{
				type: 'text'
			}},
			{field:'SIGNTYPE',title:'��������',width:70,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					editable:false,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'SIGNTYPE';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			}
			,formatter:function(value, data,index){
				var rtn = GLOBAL.SIGNTYPE[value];
				return rtn ;	
			}
			},
			{field:'EFFTFLAG',title:'�Ƿ�����',width:70,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					editable:false,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'EFFTFLAG';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.EFFTFLAG[value];
				return rtn ;	
			}
			},
			{field:'AutoUp',title:'�Զ��ϴ�',width:70,editor:{
				type: 'text'
			},hidden:true},
			{field:'SucUp',title:'�ɹ����ش�',width:70,editor:{
				type: 'text'
			},hidden:true},
			{field:'RecSYSCode',title:'���շ�ϵͳ����',width:120,editor:{
				type: 'text'
			},hidden:true},
			{field:'OUTNODECODE',title:'�ڵ����',width:80,editor:{
				type: 'text'
			},hidden:true},
			{field:'BUILDINPUT',title:'�Ƿ�����input',width:95,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					editable:false,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'CODEFLAG';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.CODEFLAG[value];
				return rtn ;	
			}
			
			},
			{field:'MDTRTTYPE',title:'���ò���',width:80,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					editable:false,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'MDTRTTYPE';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.MDTRTTYPE[value];
				return rtn ;	
			}
			,hidden:true
			},
			{field:'HOSPID',title:'����ҽԺ',width:140,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'Rowid',
					textField: 'Desc',
					editable:false,
					required:true,
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
						param.ClassName = Global.Com.ClassName;
						param.QueryName= 'QueryHospInfo';
						param.ResultSetType = 'array';
						return true;
					},
					onSelect: function (data) {
						
						
					},
					onLoadSuccess:function(data){

					}
				}
			},formatter:function(value, data,index){
				var rtn = $.m({ClassName: Global.PortConfig.ClassName, MethodName: "GetHospDescById", HospId:PUBLIC_CONSTANT.SESSION.HOSPID }, false);
				return rtn ;	
			}
			
			},
			{field:'HITYPE',title:'����ҽ��',width:120,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					mode:'remote',
					editable:false,
					required:true,
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'DLLType';
				      	param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID  //$('#Hospital').combobox('getValue');
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			},formatter:function(value, data,index){
				var rtn = $.m({ClassName: "INSU.COM.BaseData", MethodName: "GetDicByCodeAndInd", SysType: 'DLLType',Code: value,Ind:4,HospDr:PUBLIC_CONSTANT.SESSION.HOSPID  }, false);
				return rtn ;	
			}
			
			},
			{field:'CHKFLAG',title:'��˱�־',width:80
			,formatter:function(value, data,index){
				var rtn = GLOBAL.PUBLISHSTATUS[value] || value;
				return rtn ;
			}
			},
			{field:'ROWID',title:'ROWID',width:10,hidden:true}

		]],
        onSelect : function(rowIndex, rowData) {
	        ChangeButtonByPublishStatus();
			Load_wdg_DataGrid();
        },
        onUnselect: function(rowIndex, rowData) {
        },
        onBeforeLoad:function(param){

	    },
		onDblClickRow:function(index,row){
			stEdit(index,row);
			
		},
	    onLoadSuccess:function(data){

		},
		onBeginEdit:function(rowIndex, rowData){
			if(rowData.HOSPID ==""){
				INSUMIDataGrid.setGridVal('dg',rowIndex,'HOSPID',PUBLIC_CONSTANT.SESSION.HOSPID)  //$('#Hospital').combobox('getValue'));
			}
			if(rowData.HITYPE ==""){
				INSUMIDataGrid.setGridVal('dg',rowIndex,'HITYPE',$('#InsuType').combobox('getValue'));
			}
			focusEditRow('dg'); 		
		},
		onBeforeEdit:function(rowIndex,rowData){
		},
		onAfterEdit:function(){
		},
		onClickCell:function(){
		}
	});	
}
function Load_dg_DataGrid(){
	INSUMIClearGrid('wdg');
	INSUMIClearGrid('edg');
	var queryParams = {
	    ClassName : Global.PortConfig.ClassName,
	    QueryName : 'QueryPortList',
	    HospDr : PUBLIC_CONSTANT.SESSION.HOSPID,  //$('#Hospital').combobox('getValue'),
	    InsuType : $('#InsuType').combobox('getValue'),
	    AuditFlag : getValueById('AuditFlag'),
	    ParamPortInfo :getValueById('ParamPortInfo')
	}	
    loadDataGridStore('dg',queryParams);	
}
// ����
function dg_addRow(){
	var SelectIndex = INSUMIGetEditRowIndexByID('dg');
	if(SelectIndex > -1){
		if (!$('#dg').datagrid('validateRow', SelectIndex)) {
			$.messager.popover({msg: '������֤��ͨ��', type: 'error'});
			return;
		}
		$('#dg').datagrid('endEdit',SelectIndex);
	}
	var lastRows = $('#dg').datagrid('getRows').length;
	$('#dg').datagrid('appendRow', {
			INFNO: '',
			INFNAME: '',
			Timeout: '',
			HISVER: '',
			URL: '',
			TYPE: '',
			SIGNTYPE: '',
			EFFTFLAG: '',
			AutoUp : '',
			SucUp : '',
			RecSYSCode : '',
			MDTRTTYPE : '',
			HOSPID : '' ,
			HITYPE : '',
			METHODNAME:'',
			OUTNODECODE:'',
			CLASSNAME:'',
			CONTENTTYPE:'',
			CHKFLAG: '',
			BUILDINPUT: ''
				
	});
	$('#dg').datagrid('beginEdit', lastRows);
	$('#dg').datagrid('scrollTo', lastRows);
	$('#dg').datagrid('selectRow', lastRows);
}

// �����༭
function dg_endEditRow(){
		
}
// ���浥��
function SaveSingle(){
	var dgSelect = $('#dg').datagrid('getSelected');
	if(!dgSelect){
		INSUMIAlert('����ѡ��Ҫ���������' , 'error');
        return ;	
	}	
	var dgSelectIndex = $('#dg').datagrid('getRowIndex',dgSelect);
	
	var editor = $('#dg').datagrid('getEditor', {
      	index: dgSelectIndex,
      	field: 'INFNO'
	});
	if(!editor){
		INSUMIPOP('û����Ҫ���������' , 'error');
        return ;				
	}
	
	var dgSelectRowId = dgSelect.ROWID || '';
	var editorRow = {
			INFNO: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'INFNO'),
			INFNAME: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'INFNAME'),
			Timeout: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'Timeout'),
			HISVER: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'HISVER'),
			URL: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'URL'),
			TYPE: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'TYPE'),
			SIGNTYPE: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'SIGNTYPE'),
			EFFTFLAG: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'EFFTFLAG'),
			AutoUp : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'AutoUp'),
			SucUp : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'SucUp'),
			RecSYSCode : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'RecSYSCode'),
			MDTRTTYPE : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'MDTRTTYPE') ,
			HOSPID : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'HOSPID') ,
			HITYPE : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'HITYPE'),
			CLASSNAME: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'CLASSNAME'),
			METHODNAME: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'METHODNAME'),
			OUTNODECODE: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'OUTNODECODE'),
			CONTENTTYPE: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'CONTENTTYPE'),
			ROWID : dgSelectRowId,
			CHKFLAG: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'CHKFLAG'),
			BUILDINPUT: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'BUILDINPUT')
				
		}
	var InJson = JSON.stringify(editorRow);
	var rtn = $.m({ClassName: "INSU.MI.PortListCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);
	if (rtn.split('^')[0] == '0'){
		$('#dg').datagrid('updateRow',{
			index : dgSelectIndex,
			row: editorRow
		});
		INSUMIAlert('����ɹ�' , 'success');
		Load_dg_DataGrid();
	}else{
		INSUMIAlert('����ʧ�ܣ�'  + rtn , 'error');
	}
}
// �������
function SaveMult(){
	var SelectIndex = INSUMIGetEditRowIndexByID('dg');
	if(SelectIndex > -1){
		$('#dg').datagrid('endEdit',SelectIndex);
	}
	if (!$('#dg').datagrid('validateRow', SelectIndex)) {
		$.messager.popover({msg: '������֤��ͨ��', type: 'error'});
		return;
	}
	var TotalNum = 0;
	var SuccessNum = 0;
	var ErrorNum = 0;
	var dgRows = $('#dg').datagrid('getChanges');
	for (var rowIndex = 0; rowIndex < dgRows.length; rowIndex++) {
		var dgRow = dgRows[rowIndex];
		if(dgRow){
			TotalNum++;
			var dgSelectRowId = dgRow.ROWID || '';
			var dgSelectIndex = $('#dg').datagrid('getRowIndex',dgRow);
			$('#dg').datagrid('beginEdit',dgSelectIndex);
			var editorRow = {
				INFNO: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'INFNO'),
				INFNAME: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'INFNAME'),
				Timeout: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'Timeout'),
				HISVER: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'HISVER'),
				URL: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'URL'),
				TYPE: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'TYPE'),
				SIGNTYPE: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'SIGNTYPE'),
				EFFTFLAG: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'EFFTFLAG'),
				AutoUp : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'AutoUp'),
				SucUp : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'SucUp'),
				RecSYSCode : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'RecSYSCode'),
				MDTRTTYPE : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'MDTRTTYPE') ,
				HOSPID : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'HOSPID') ,
				HITYPE : INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'HITYPE'),
				CLASSNAME:INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'CLASSNAME'),
				METHODNAME:INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'METHODNAME'),
				OUTNODECODE:INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'OUTNODECODE'),
				CONTENTTYPE: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'CONTENTTYPE'),
				CHKFLAG: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'CHKFLAG'),
				BUILDINPUT: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'BUILDINPUT'),
				ROWID : dgSelectRowId
			}
			$('#dg').datagrid('endEdit',dgSelectIndex);
			var InJson = JSON.stringify(editorRow);
			var rtn = $.m({ClassName: "INSU.MI.PortListCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);	
			if(rtn.split('^')[0] == '0'){
				SuccessNum++;
				editorRow.ROWID = rtn.split('^')[1];
				$('#dg').datagrid('updateRow',{
					index : dgSelectIndex,
					row: editorRow
				});
			}else{
				ErrorNum++;
			}			
		}
	}
	INSUMIAlert('���ι�����:' + TotalNum + '����' + '�ɹ�:' + SuccessNum + '��ʧ�ܣ�' + ErrorNum +'��');
	
}
// ---dg end
// 
function init_wdg() { 
	var Columns= [[   
		{field:'SEQ',title:'˳���',width:50,align:'center',editor:{
				type: 'numberbox',
				options: {
					precision:0,
					min:0,
					required:true	
				}
			}},
		{field:'NODECODE',title:'�ڵ����',width:70,editor:{
				type: 'validatebox',
				options: {
					required:true	
				}
			}},
		{field:'NODENAME',title:'�ڵ�����',width:100,editor:{
				type: 'text'
			}},
		{field:'NODETYPE',title:'�ڵ�����',width:65,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					mode:'remote',
					editable:false,
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'NODETYPE';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			}
			,formatter:function(value, data,index){
				var rtn = GLOBAL.NODETYPE[value];
				return rtn ;	
			}	
			},
		{field:'CLASSNAME',title:'����',width:120,editor:{
				type: 'text'
			}},
		{field:'METHODNAME',title:'������',width:120,editor:{
				type: 'combogrid',
				options: {
					defaultFilter: 4,
					idField: 'METHODNAME',
					textField: 'METHODNAME',
					url:$URL,
					panelWidth:350,   
					mode:'remote',
					columns:[[   
						{field:'CLASSNAME',title:'����',width:150},
						{field:'METHODNAME',title:'������',width:150},
						{field:'METHODTYP',title:'��������',width:80},
						{field:'METHODDESC',title:'��������',width:100},
						{field:'DEMO',title:'��ע',width:150},
						{field:'EFFTFLAG',title:'��Ч��־',width:120},
						{field:'MULTSPLIT',title:'���ζ��зָ���',width:100},
						{field:'DATASPLIT',title:'���ݷָ��',width:100},
						{field:'OUTPUTTYPE',title:'����ֵ����',width:120},
						{field:'ROWID',title:'ROWID',width:120,hidden:true}
				    ]],
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.MI.ClassMethodCom';
				      	param.QueryName = 'QueryClassMethod';
				      	//param.ParamInput = '|' + param.q;
				      	return true;
					},
					onSelect: function (index,data) {
						selectClassMethod(data);
					}
				}
			}},
		{field:'METHODTYPE',title:'��������',width:65,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'METHODTYPE';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			}
			,formatter:function(value, data,index){
				var rtn = GLOBAL.METHODTYPE[value];
				return rtn ;	
			}	
			},
		{field:'CONFLAG',title:'���ձ�־',width:70,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'CONFLAG';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			}
			,formatter:function(value, data,index){
				var rtn = GLOBAL.CONFLAG[value];
				return rtn ;	
			
			}},	
		{field:'EFFTFLAG',title:'��Ч��־',width:70,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'EFFTFLAG';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
		},formatter:function(value, data,index){
				var rtn = GLOBAL.EFFTFLAG[value] || value;
				return rtn ;	
			}},
		{field:'MultRow',title:'���зָ���',width:80,editor:{
				type: 'text'
			}},
		{field:'SUBFLAG',title:'�ӽڵ��־',width:80,editor:{
				type: 'combobox',
				options: {
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					editable:false,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'CODEFLAG';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;
					},
					onSelect: function (data) {
						
					}
			}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.CODEFLAG[value] || value;
				return rtn ;	
			}},
		{field:'ClassMethodArgs',title:'ClassMethodArgs',width:10,hidden:true}, // ����Ԫ��   ������Դ����ʹ��
		{field:'ROWID',title:'ROWID',width:60,hidden:true}
		
	]]
	$('#wdg').datagrid({  
		border: false,
		striped:true,
		singleSelect: true,
		fit:true,
		columns:Columns,
		toolbar:'#wdgTB',
		onSelect : function(rowIndex, rowData) {
			Load_edg_DataGrid();		
		},
		onLoadSuccess:function(data){
			Global.wdgSeq = [];
			var dataRowsLen = data.rows.length;
			if(dataRowsLen > 0){
				for (var tmpIndex=0;tmpIndex < dataRowsLen;tmpIndex++){
					var seq = data.rows[tmpIndex].SEQ;
					Global.wdgSeq.push(seq);
				}	
			}
		},
		onDblClickRow:function(index,row){
			WestBeginEdit(index,row);			
		},onBeginEdit:function(){
			focusEditRow('wdg');		
		}	

	}); 
}
function Load_wdg_DataGrid(){
	INSUMIClearGrid('edg');
	var dgSelect = $('#dg').datagrid('getSelected');
	if(!dgSelect){
		$.messager.alert('��ʾ', '����ѡ��ӿ�','error');
        return ;	
	}
	if(dgSelect.ROWID==""){
		return;
	}
	//alert(dgSelect.ROWID)
	/*
	var queryParams = {
	    ClassName : Global.PortNode.ClassName,
	    QueryName : 'QueryPortNode',
	    PortId : dgSelect.ROWID,
	    ParamPARNODETYPE : $('#btnPARNODETYPE').attr('data')
	}
	*/	
    //loadDataGridStore('wdg',queryParams);
    //��Ϊֱ���첽���� 20210318
	$cm({
		ClassName:Global.PortNode.ClassName,
		QueryName:'QueryPortNode',
		PortId : dgSelect.ROWID,
		ParamPARNODETYPE : $('#btnPARNODETYPE').attr('data')
	},function(jsonData){
		$('#wdg').datagrid('loadData',jsonData);
	});
}
// ����
function wdg_addRow(){
	var dgSelect = $('#dg').datagrid('getSelected');
	if(!dgSelect){
		INSUMIAlert('����ѡ��ӿ�' , 'error');
        return ;	
	}
	var SelectIndex = INSUMIGetEditRowIndexByID('wdg');
	if(SelectIndex > -1 ){
		if (!$('#wdg').datagrid('validateRow', SelectIndex)) {
			$.messager.popover({msg: '������֤��ͨ��', type: 'error'});
			return;
		}
		$('#wdg').datagrid('endEdit', SelectIndex);
	}
	var Lastrows = $('#wdg').datagrid('getRows').length;
	var nextSeq = GetWDGNextSeq();
	
	$('#wdg').datagrid('appendRow',{
			NODECODE: '',
			NODENAME: '',
			NODETYPE: '',
			CLASSNAME : '',
			METHODNAME : '',
			METHODTYPE : '',
			CONFLAG : '' ,
			SUBFLAG : '' ,
			EFFTFLAG : '' ,
			SEQ : nextSeq 
	});
	$('#wdg').datagrid('beginEdit', Lastrows);	
	$('#wdg').datagrid('selectRow', Lastrows);		
}
function GetWDGNextSeq(){
	Global.wdgSeq = Global.wdgSeq.sort(sortNumber)
	var rtn = 1;
	if(Global.wdgSeq.length == 0){
		Global.wdgSeq.push(rtn.toString());	
	}else{
		for (key in Global.wdgSeq){
			var nextSeq = +Global.wdgSeq[key] + 1;
			if(Global.wdgSeq.indexOf(nextSeq.toString(),0) == -1) {
				Global.wdgSeq.push(nextSeq.toString());
				rtn = nextSeq;
				break;	
			}
		}
	}
	function sortNumber(a, b) {
					return a - b
				}
				
	return rtn;		
}
function GetEDGNextSeq(){
	Global.edgSeq = Global.edgSeq.sort(sortNumber)
	var rtn = 1;
	if(Global.edgSeq.length == 0){
		Global.edgSeq.push(rtn.toString());	
	}else{
		for (key in Global.edgSeq){
			var nextSeq = +Global.edgSeq[key] + 1;
			if(Global.edgSeq.indexOf(nextSeq.toString(),0) == -1) {
				Global.edgSeq.push(nextSeq.toString());
				rtn = nextSeq;
				break;	
			}
		}
	}
	function sortNumber(a, b) {
					return a - b
				}
				
	return rtn;		
}
// �����༭
function wdg_endEditRow(){
		
}
// ���浥��
function wdg_SaveSingle(){
	var dgSelect = $('#dg').datagrid('getSelected');
	if(!dgSelect){
		INSUMIAlert('����ѡ��ӿ�' , 'error');
        return ;	
	}
	var wdgSelect = $('#wdg').datagrid('getSelected');	
	var wdgSelectIndex = $('#wdg').datagrid('getRowIndex',wdgSelect);
	
	var wdgSelectRowId = wdgSelect.ROWID || '';
	var editorRow = {
			NODECODE: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'NODECODE'),
			NODENAME: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'NODENAME'),
			NODETYPE: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'NODETYPE'),
			CLASSNAME: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'CLASSNAME'),
			METHODNAME: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'METHODNAME'),
			METHODTYPE: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'METHODTYPE'),
			CONFLAG: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'CONFLAG'),
			SUBFLAG: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'SUBFLAG'),
			SEQ: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'SEQ'), 
			EFFTFLAG: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'EFFTFLAG'), 
			PARID:dgSelect.ROWID,
			ROWID : wdgSelect.ROWID,
			PARNODETYPE:$('#btnPARNODETYPE').attr('data')
		}

	var InJson = JSON.stringify(editorRow);
	var rtn = $.m({ClassName: "INSU.MI.PortNodeCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);
	if (rtn.split('^')[0] == '0'){
		$('#wdg').datagrid('updateRow',{
			index : wdgSelectIndex,
			row: editorRow
		});
		INSUMIPOP('����ɹ�' , 'success');
		Load_wdg_DataGrid();
	}else{
		INSUMIPOP('����ʧ�ܣ�'  + rtn , 'error');
	}
}
function wdg_SaveMultRow(){
	var dgSelect = $('#dg').datagrid('getSelected');
	if(!dgSelect){
		INSUMIAlert('����ѡ��ӿ�' , 'error');
        return ;	
	}
	var SelectIndex = INSUMIGetEditRowIndexByID('wdg');
	if(SelectIndex > -1){
		$('#wdg').datagrid('endEdit',SelectIndex);
	}
	if (!$('#wdg').datagrid('validateRow', SelectIndex)) {
			$.messager.popover({msg: '������֤��ͨ��', type: 'error'});
			return;
		}
	var TotalNum = 0;
	var SuccessNum = 0;
	var ErrorNum = 0;
	var dgRows = $('#wdg').datagrid('getChanges');
	for (var rowIndex = 0; rowIndex < dgRows.length; rowIndex++) {
		var dgRow = dgRows[rowIndex];
		if(dgRow){
			TotalNum++;
			var dgSelectRowId = dgRow.ROWID || '';
			var wdgSelectIndex = $('#wdg').datagrid('getRowIndex',dgRow);
			$('#wdg').datagrid('beginEdit',wdgSelectIndex); // For Get Editor value
			var editorRow = {
				NODECODE: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'NODECODE'),
				NODENAME: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'NODENAME'),
				NODETYPE: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'NODETYPE'),
				CLASSNAME: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'CLASSNAME'),
				METHODNAME: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'METHODNAME'),
				METHODTYPE: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'METHODTYPE'),
				CONFLAG: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'CONFLAG'),
				SUBFLAG: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'SUBFLAG'),
				SEQ: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'SEQ'), 
				EFFTFLAG: INSUMIDataGrid.getCellVal('wdg',wdgSelectIndex,'EFFTFLAG'), 
				PARID:dgSelect.ROWID,
				ROWID : dgSelectRowId,
				PARNODETYPE:$('#btnPARNODETYPE').attr('data')
			}
			// 2022-12-12 + tangzf �������ݲ�֧��NONEģʽ
            if((editorRow.NODETYPE=="M")&&(editorRow.NODECODE.indexOf("%NONE%")>-1)){
                INSUMIAlert("�ڵ���룺"+editorRow.NODECODE + "��NONEģʽ��֧�ֶ�������");  
                return;
            }
			$('#wdg').datagrid('endEdit',wdgSelectIndex); // For Get Editor value
			
			var InJson = JSON.stringify(editorRow);
			var rtn = $.m({ClassName: "INSU.MI.PortNodeCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);
			if(rtn.split('^')[0] == '0'){
				SuccessNum++;
				editorRow.ROWID = rtn.split('^')[1];
				$('#wdg').datagrid('updateRow',{
					index : wdgSelectIndex,
					row: editorRow
				});
			}else{
				ErrorNum++;
			}			
		}
	}
	INSUMIAlert('���ι�����:' + TotalNum + '����' + '�ɹ�:' + SuccessNum + '��ʧ�ܣ�' + ErrorNum +'��');	
	
}
function init_edg() { 
	var colums = [[
		{align:'left',field:'SEQ',title:'˳���',width:50,editor:{
				type: 'numberbox',
				options: {
					precision:0,
					min:0,
					required:true	
				}
			}},
		{align:'left',field:'ARGCODE',title:'��������',width:100,editor:{
				type: 'validatebox',
				options: {
					required:true	
				}
			}},
		{align:'left',field:'ARGNAME',title:'��������',width:100,editor:{
				type: 'validatebox',
				options: {
					required:true	
				}
			}},
		{align:'left',field:'ARGTYPE',title:'��������',width:100,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					editable:false,
					url:$URL,
					mode:'remote',
					required:true,
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'ARGTYPE';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.ARGTYPE[value] || value;
				return rtn;	
			}},
		{align:'left',field:'CONTYPE',title:'��������',width:100,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					editable:false,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'CONTYPE';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.CONTYPE[value] || value;
				return rtn ;	
			}				
		},
		{align:'left',field:'CONINFO',title:'����Դ����',width:94,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'ARGCODE',
					textField: 'ARGNAME',
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
						var selectWdg = $('#wdg').datagrid('getSelected');
						if(!selectWdg){
							return true;
						}
				      	param.ClassName = 'INSU.MI.ClassMethodArgsCom';
				      	param.QueryName = 'QueryClassMethodArgsByClassMethod';
				      	param.InputStr = selectWdg.CLASSNAME + "|" + selectWdg.METHODNAME ;
				      	param.ResultSetType = 'array';
				      	return true;
					},
					onLoadError:function(err){
						alert(err.responseText)
					},onLoadSuccess:function(data){
							
					}
				}
			}},
		{align:'left',field:'CONINFODESC',title:'����Դ����',width:94,editor:{
				type: 'text'
			}},	
		{align:'left',field:'CONINFOSOURCE',title:'����Դ��Դ',width:94,editor:{
				type: 'text'
			}},	
		{align:'left',field:'CONINFODEMO',title:'����Դ����',width:94,editor:{
				type: 'text'
			}},
		{align:'left',field:'DEFVALUE',title:'Ĭ��ֵ',width:94,editor:{
				type: 'text'
			}},
		{align:'left',field:'LOCALPARCODE',title:'���ز�������',width:124,editor:{
				type: 'text'
			}},
		{align:'left',field:'EFFTFLAG',title:'��Ч��־',width:94,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					mode:'remote',
					editable:false,
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'EFFTFLAG';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.EFFTFLAG[value] || value;
				return rtn ;	
			}},
		{align:'left',field:'MUSTLFLAG',title:'�����־',width:60,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					editable:false,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'MUSTFLAG';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
			}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.MUSTFLAG[value] || value;
				return rtn ;	
			}},
		{align:'left',field:'CODEFLAG',title:'�����ʶ',width:80,editor:{
				type: 'combobox',
				options: {
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					editable:false,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'INSU.COM.BaseData';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'CODEFLAG';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;
					},
					onSelect: function (data) {
						
					}
			}
			},formatter:function(value, data,index){
				var rtn = GLOBAL.CODEFLAG[value] || value;
				return rtn ;	
			}},
		{align:'left',field:'DICCODE',title:'�����ֵ�',width:80,editor:{
			type: 'text'
		}
		},
		{align:'left',field:'MAXLENG',title:'��󳤶�',width:50,editor:{
				type: 'text'
			}},
		{align:'left',field:'SUBNODE',title:'�ӽڵ����',width:48,editor:{
				type: 'text'
			}},
		{align:'left',field:'SUBNAME',title:'�ӽڵ�����',width:100,editor:{
				type: 'text'
			}},
		{align:'left',field:'ROWID',title:'ROWID',width:48,hidden:true}
	]];
	//		pagination:true,
	$HUI.datagrid('#edg',{
		border: false,
		fit:true,
		singleSelect: true,
		data: [],
		toolbar:'#edgTB',
		columns:colums,
		onLoadSuccess:function(data){
			Global.edgSeq = [];
			var dataRowsLen = data.rows.length;
			if(dataRowsLen > 0){
				for (var tmpIndex=0;tmpIndex < dataRowsLen;tmpIndex++){
					var seq = data.rows[tmpIndex].SEQ;
					Global.edgSeq.push(seq);
				}	
			}
		},
		onDblClickRow:function(index,row){
			EastBeginEdit(index,row);
		},
		onSelect:function(rowIndex, rowData){
			
		},
		onUnselect:function(rowIndex, rowData){
			
		},onBeginEdit:function(){
			focusEditRow('edg');		
		}
	});
}
function Load_edg_DataGrid(){
	var wdgSelect = $('#wdg').datagrid('getSelected');
	if(!wdgSelect){
		$.messager.alert('��ʾ', '����ѡ�����ݽڵ�','error');
        return ;	
	}
	var ROWID = wdgSelect.ROWID
	/*var queryParams = {
	    ClassName : Global.PortConfig.ClassName,
	    QueryName : 'QueryPortInArgs',
	    PortNodeId : ROWID
	}	
    loadDataGridStore('edg',queryParams);*/	
    //��Ϊֱ���첽���� 20210318
    //return;
	$cm({
		ClassName:Global.PortConfig.ClassName,
		QueryName: 'QueryPortInArgs',
		PortNodeId : ROWID,
		edgKeyInput: getValueById('edgKeyInput'),
		page:1,    //��ѡ�ҳ�룬Ĭ��1
		rows:1000    //��ѡ���ȡ���������ݣ�Ĭ��50
	},function(jsonData){
		$('#edg').datagrid('loadData',jsonData);
	});


}
// ����
function edg_addRow(){
	var dgSelect = $('#wdg').datagrid('getSelected');
	if(!dgSelect){
		INSUMIAlert('����ѡ�����ݽڵ�' , 'error');
        return ;	
	}
	if(dgSelect.ROWID == ""){
		INSUMIAlert('����ѡ�����ݽڵ�' , 'error');
        return;		
	}
	//var editor = $('#dg').datagrid('getEditor');
	var SelectIndex = INSUMIGetEditRowIndexByID('edg');
	if(SelectIndex > -1 ){
		if (!$('#edg').datagrid('validateRow', SelectIndex)) {
			$.messager.popover({msg: '������֤��ͨ��', type: 'error'});
			return;
		}
       $('#edg').datagrid('endEdit', SelectIndex);		
	}
	var rows = $('#edg').datagrid('getRows');
	var lastRows = rows.length;
	var nextSeq = GetEDGNextSeq();
	$('#edg').datagrid('appendRow',{
			ARGCODE: '',
			ARGNAME: '',
			CONTYPE: '',
			CONINFO : '',
			ARGTYPE : '',
			MUSTLFLAG : '',
			MAXLENG : '' ,
			SUBNODE : '' ,
			SUBNAME : '' ,
			CONINFODESC :'',
			SEQ : nextSeq ,
			CONINFOSOURCE : '' ,
			CONINFODEMO : '' ,
			EFFTFLAG :'',
			DEFVALUE :'',
			DICCODE:'',
			LOCALPARCODE: ''
	});
	$('#edg').datagrid('beginEdit', lastRows);	
	$('#edg').datagrid('scrollTo',lastRows);
	$('#edg').datagrid('selectRow', lastRows);
}
// �����༭
function edg_endEditRow(){
		
}
// ���浥��
function edg_SaveSingleOld(){
	var dgSelect = $('#wdg').datagrid('getSelected');
	if(!dgSelect){
		INSUMIAlert('����ѡ�����ݽڵ�' , 'error');
        return ;	
	}
	var wdgSelect = $('#edg').datagrid('getSelected');	
	if(!wdgSelect){
		INSUMIPOP('��ѡ��Ҫ�������' , 'error');
		return;	
	}
	var wdgSelectIndex = $('#edg').datagrid('getRowIndex',wdgSelect);
	
	var wdgSelectRowId = wdgSelect.ROWID || '';
	var editorRow = {
			ARGCODE: INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'ARGCODE'),
			ARGNAME: INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'ARGNAME'),
			CONTYPE: INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CONTYPE'),
			CONINFO : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CONINFO'),
			ARGTYPE : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'ARGTYPE'),
			MUSTLFLAG : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'MUSTLFLAG'),
			MAXLENG : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'MAXLENG') ,
			SUBNODE : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'SUBNODE') ,
			SUBNAME : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'SUBNAME') ,
			SEQ : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'SEQ'),
			CONINFODESC : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CONINFODESC'),
			PARID:dgSelect.ROWID,
			CONINFOSOURCE : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CONINFOSOURCE') ,
			CONINFODEMO : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CONINFODEMO') ,
			EFFTFLAG :INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'EFFTFLAG'),
			DEFVALUE :INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'DEFVALUE'),
			DICCODE :INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'DICCODE'),
			LOCALPARCODE :INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'LOCALPARCODE'),
			ROWID : wdgSelectRowId
		}
	var InJson = JSON.stringify(editorRow);
	 // ##class(INSU.MI.PortListCom).Save(InJson)
	var rtn = $.m({ClassName: "INSU.MI.PortInArgsCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);
	if (rtn.split('^')[0] == 0){
		$('#edg').datagrid('updateRow',{
			index : wdgSelectIndex,
			row: editorRow
		});
		INSUMIPOP('����ɹ�' , 'success');
	}else{
		INSUMIPOP('����ʧ�ܣ�'  + rtn , 'error');
	}
}

// �������
function edg_SaveSingle(){
	var dgSelect = $('#wdg').datagrid('getSelected');
	if(!dgSelect){
		INSUMIAlert('����ѡ�����ݽڵ�' , 'error');
        return ;	
	}
	var lastEdit = INSUMIGetEditRowIndexByID('edg');
	if (lastEdit > -1){
		if (!$('#edg').datagrid('validateRow', lastEdit)) {
			$.messager.popover({msg: '������֤��ͨ��', type: 'error'});
			return;
		}
		$('#edg').datagrid('endEdit',lastEdit);
	}
	
	var TotalNum = 0;
	var SuccessNum = 0;
	var ErrorNum = 0;
	var dgRows = $('#edg').datagrid('getChanges');
	for (var rowIndex = 0; rowIndex < dgRows.length; rowIndex++) {
		var dgRow = dgRows[rowIndex];
		if(dgRow){
			TotalNum++;
			var dgSelectRowId = dgRow.ROWID || '';
			var wdgSelectIndex = $('#edg').datagrid('getRowIndex',dgRow);
			$('#edg').datagrid('beginEdit',wdgSelectIndex); // For Get Editor value
			var editorRow = {
				ARGCODE: INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'ARGCODE'),
				ARGNAME: INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'ARGNAME'),
				CONTYPE: INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CONTYPE'),
				CONINFO : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CONINFO'),
				ARGTYPE : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'ARGTYPE'),
				MUSTLFLAG : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'MUSTLFLAG'),
				MAXLENG : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'MAXLENG') ,
				SUBNODE : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'SUBNODE') ,
				SUBNAME : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'SUBNAME') ,
				SEQ : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'SEQ'),
				CONINFODESC : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CONINFODESC'),
				CODEFLAG : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CODEFLAG'),
				PARID:dgSelect.ROWID,
				CONINFOSOURCE : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CONINFOSOURCE') ,
				CONINFODEMO : INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'CONINFODEMO') ,
				EFFTFLAG :INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'EFFTFLAG'),
				DEFVALUE :INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'DEFVALUE'),
				DICCODE :INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'DICCODE'),
				LOCALPARCODE :INSUMIDataGrid.getCellVal('edg',wdgSelectIndex,'LOCALPARCODE'),
				ROWID : dgSelectRowId
			}
			if(editorRow['CONTYPE']=="P" &&editorRow['CONINFO']==""){
				ErrorNum++;
				$.messager.alert('��ʾ','��������Ϊ[��������ֵ]ʱ����Դ���벻��Ϊ��','error')
				break;	
			}
			editorRow['CONTYPE'] = editorRow['CONTYPE'].replace('PARAM',"APARAMA");
			$('#edg').datagrid('endEdit',wdgSelectIndex); // For Get Editor value
			if(editorRow['DICCODE'] == "" && editorRow['CODEFLAG'] == "Y"){
				editorRow['DICCODE'] = editorRow['ARGCODE'] + "Con00A";	
			}
			var InJson = JSON.stringify(editorRow);
			var rtn = $.m({ClassName: "INSU.MI.PortInArgsCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);	
			if(rtn.split('^')[0] == 0) {
				SuccessNum++;
				editorRow.ROWID = rtn.split('^')[1];
				if(editorRow['CONTYPE']=="APARAMA") editorRow['CONTYPE']="PARAM";
				$('#edg').datagrid('updateRow', {
					index : wdgSelectIndex,
					row: editorRow
				});
			}else{
				ErrorNum++;
			}
		}
	}
	$('#edg').datagrid('acceptChanges');
	INSUMIAlert('���ι�����:' + TotalNum + '����' + '�ɹ�:' + SuccessNum + '��ʧ�ܣ�' + ErrorNum +'��');
	//Load_edg_DataGrid();
	
}
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}

//
//
function init_insuType(){
	// ҽ������
	$('#InsuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = 'INSU.COM.BaseData';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'DLLType';
	      	param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;  //$('#Hospital').combobox('getValue');
	     },
	    columns:[[   
	        {field:'cCode',title:'ҽ������',width:60},  
	        {field:'cDesc',title:'ҽ������',width:100}
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				$('#InsuType').combogrid('grid').datagrid('selectRow',0);
		    }
		},
		onSelect:function(index,data){
			// HospId , INSUType, TYPE, ParamVER
			var rtn = $.m({ClassName: Global.PortConfig.ClassName, MethodName: "BuildDefaultPortListData", HospId: PUBLIC_CONSTANT.SESSION.HOSPID  ,INSUType: $('#InsuType').combobox('getValue'), TYPE:getValueById('TYPE'), ParamVER:'',UpdateFlag:'N'}, false);
			if(rtn!=0){
				$.messager.confirm('ȷ��','��⵽��ҽ�����ʹ����µĽӿڣ��Ƿ�������',function(r){
					if(r){
						var rtn = $.m({ClassName: Global.PortConfig.ClassName, MethodName: "BuildDefaultPortListData", HospId: PUBLIC_CONSTANT.SESSION.HOSPID  ,INSUType: $('#InsuType').combobox('getValue'), TYPE:getValueById('TYPE'), ParamVER:'',UpdateFlag:'Y'}, false);
					}
					Load_dg_DataGrid();	
				});
			}
		}
	}); 
	/*
	$('#PortCom-HITYPE').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = 'web.INSUDicDataCom';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'DLLType';
	      	param.HospDr = $('#PortCom-HOSPID').combobox('getValue');
	     },
	    columns:[[   
	        {field:'cCode',title:'ҽ������',width:60},  
	        {field:'cDesc',title:'ҽ������',width:100}
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				$('#PortCom-HITYPE').combogrid('grid').datagrid('selectRow',0);
		    }
		}
	});	
	
	$('#PortRoot-HITYPE').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = 'web.INSUDicDataCom';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'DLLType';
	      	param.HospDr = $('#PortRoot-HOSPID').combobox('getValue');
	     },
	    columns:[[   
	        {field:'cCode',title:'ҽ������',width:60},  
	        {field:'cDesc',title:'ҽ������',width:100}
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				$('#PortRoot-HITYPE').combogrid('grid').datagrid('selectRow',0);
		    }
		}
	});	*/
}
//
function init_hosp(){
	$('#Hospital').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=CF.NSU.MI.PortList',
		method: 'GET',
		idField: 'HOSPRowId',
		textField: 'HOSPDesc',
	    columns:[[   
	        {field:'HOSPRowId',title:'����ID',width:60},  
	        {field:'HOSPDesc',title:'����',width:100}
	    ]],
	    fitColumns: true,
	    onSelect:function(index,data){
		    PUBLIC_CONSTANT.SESSION.HOSPID = data.HOSPRowId; 
		    selectHospCombHandle();
		},
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				$('#Hospital').combogrid('grid').datagrid('selectRow',0);
		    }
		}
	}); 
	
	/*$('#PortCom-HOSPID').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'Rowid',   
	    textField:'Desc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = Global.Com.ClassName;
	      	param.QueryName = 'QueryHospInfo';
	      	return true;
	     },
	    columns:[[   
	        {field:'Rowid',title:'����ID',width:60},  
	        {field:'Desc',title:'����',width:100}
	    ]],
	    fitColumns: true,
	    onSelect:function(){
		    $('#PortCom-HITYPE').combobox('clear');
		    $('#PortCom-HITYPE').combogrid('grid').datagrid('reload');
		},
	    onLoadSuccess:function(data){
		    
		}
	}); 
	
	$('#PortRoot-HOSPID').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'Rowid',   
	    textField:'Desc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = Global.Com.ClassName;
	      	param.QueryName = 'QueryHospInfo';
	      	return true;
	     },
	    columns:[[   
	        {field:'Rowid',title:'����ID',width:60},  
	        {field:'Desc',title:'����',width:100}
	    ]],
	    fitColumns: true,
	    onSelect:function(){
		    $('#PortRoot-HITYPE').combobox('clear');
		    $('#PortRoot-HITYPE').combogrid('grid').datagrid('reload');
		},
	    onLoadSuccess:function(data){
		    
		}
	}); */
}

function init_auditFlag(){
	$('#AuditFlag').combobox({
		defaultFilter: 4,
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'INSU.COM.BaseData';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'PUBLISHSTATUS';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {
		},onLoadSuccess:function(){

		}
	});		
}

// dg_btn_event
function DG_EndEdit(){
	var SelectIndex = INSUMIGetEditRowIndexByID('dg');
	if(SelectIndex < 0 ){
		$.messager.alert('��ʾ', '��ѡ��Ҫȡ���༭����','error');
        return;	
	}
	$('#dg').datagrid('endEdit',SelectIndex);		
}



function stEdit(index,row){
	if(!CheckCanEdit()){
		INSUMIPOP('�Ѿ����������ݲ������޸�' , 'error');
		return;	
	};
	var SelectIndex = INSUMIGetEditRowIndexByID('dg');
	if(SelectIndex > -1 ){
		if (!$('#dg').datagrid('validateRow', SelectIndex)) {
			$.messager.popover({msg: '������֤��ͨ��', type: 'error'});
			return;
		}
		$('#dg').datagrid('endEdit',SelectIndex);
	}		
	$('#dg').datagrid('beginEdit',index);	
}

function WestBeginEdit(index,row){
	if(!CheckCanEdit()){
		INSUMIPOP('�Ѿ����������ݲ������޸�' , 'error');
		return;	
	};
	var SelectIndex = INSUMIGetEditRowIndexByID('wdg');
	if(SelectIndex > -1 ) {
		if (!$('#wdg').datagrid('validateRow', SelectIndex)) {
			$.messager.popover({msg: '������֤��ͨ��', type: 'error'});
			return;
		}
		$('#wdg').datagrid('endEdit',SelectIndex);
	}
	$('#wdg').datagrid('beginEdit',index);
	
}

function SwitchPARNODETYPE(PARNODETYPE){
	$('#btnPARNODETYPE').attr('data',PARNODETYPE.split('|')[0]);
	$('#btnPARNODETYPELabel').find('.l-btn-text').text(PARNODETYPE.split('|')[1]);
	
	Load_wdg_DataGrid();
}

function WestEndEdit(){

	var SelectIndex = INSUMIGetEditRowIndexByID('wdg');
	if(SelectIndex < 0 ){
		$.messager.alert('��ʾ', '��ѡ��Ҫȡ���༭����','error');
        return;	
	}
	$('#wdg').datagrid('endEdit',SelectIndex);	

}
function EastBeginEdit(index,row){
	if(!CheckCanEdit()){
		INSUMIPOP('�Ѿ����������ݲ������޸�' , 'error');
		return;	
	};
	var SelectIndex = INSUMIGetEditRowIndexByID('edg');
	if(SelectIndex > -1 ){
		if (!$('#edg').datagrid('validateRow', SelectIndex)) {
			$.messager.popover({msg: '������֤��ͨ��', type: 'error'});
			return;
		}
		$('#edg').datagrid('endEdit',SelectIndex);	
	}	
	$('#edg').datagrid('beginEdit',index);
}

function EastEndEdit(){
	var SelectIndex = INSUMIGetEditRowIndexByID('edg');
	if(SelectIndex < 0 ){
		$.messager.alert('��ʾ', '��ѡ��Ҫȡ���༭����','error');
        return;	
	}
	$('#edg').datagrid('endEdit',SelectIndex);
}
function selectClassMethod(data){
	var SelectIndex = INSUMIGetEditRowIndexByID('wdg');
	if(SelectIndex < 0 ){
		return;
	}
	// SetWdgValue
	INSUMIDataGrid.setGridVal('wdg',SelectIndex,'CLASSNAME',data.CLASSNAME);
	INSUMIDataGrid.setGridVal('wdg',SelectIndex,'METHODTYPE',data.METHODTYP);	
	INSUMIDataGrid.setGridVal('wdg',SelectIndex,'ClassMethodArgs',data.ROWID);	
}

// �����ӿڼ��ӿڶ��ڵĽڵ㡢����(���½ǡ����½ǡ��ϱ�)
function ExportALLData()
{
	try{
/* 		var ExploreName = getExploreName();
		if(ExploreName !="IE>=11"){
			INSUMIPOP('��ʹ��IE11������������������վ��(ActiveX)' , 'error');	
			return;
		} */
		var selectDG = $('#dg').datagrid('getSelected');
		if(!selectDG){
			INSUMIPOP('û��ѡ��Ҫ����������' , 'error');	
			return;
		}		
		$.messager.confirm('��ʾ','�Ƿ����������' + selectDG.INFNAME + '���µ���������',function(r){
			if(r){
				$.messager.progress({
					title: "��ʾ",
					msg: '���ڵ�������',
					text: '������....'
				});
				var PortListId = selectDG.ROWID;	
				$cm({
					ResultSetType:"ExcelPlugin",  
					ExcelName:"�����ϴ�",		  
					PageName:"ExportALLData",      
					ClassName:"INSU.MI.PortConfig",
					QueryName:"ExportData",
					PortListId:PortListId
				},
				function(){
				  setTimeout('$.messager.progress("close");', 3 * 1000);	
				});
			}
		})
	} catch(e) {
		$.messager.alert("����",e.message,'error');
	};
}

// �����ӿڼ��ӿڶ��ڵĽڵ㡢����(���½ǡ����½ǡ��ϱ�)
function ImportAllData()
{
	try{
 		INSUMIFileOpenWindow(import_AllData); 
	} catch(e) {
		$.messager.alert("����",e.message);
	};
}
// �ж����Ƿ���Ա༭
function CheckCanEdit(){
	var dgSelected = $('#dg').datagrid('getSelected');
	if(!dgSelected){
		return false;	
	}	
	if(dgSelected.CHKFLAG=="2"){ // �ѷ���
		return false; // �ѷ����Ĳ������޸�	
	}
	return true;
}
//���ݷ���״̬ ���İ�ť������ʽ
function ChangeButtonByPublishStatus(){
	var dgSelected = $('#dg').datagrid('getSelected');
	if(!dgSelected){
		$('.changebtn').linkbutton('enable');
		return;	
	}	
	var Status = dgSelected.CHKFLAG;
	if(Status == 2){
		INSUMIPOP('�������������״̬������' , 'info');
		$('.changebtn').linkbutton('disable');	
	}else{
		$('.changebtn').linkbutton('enable');		
	}	
}
// ��ѡ���и�Ϊ���������
function focusEditRow(gridId){
	$('#' + gridId + 'TB').next().find(".datagrid-editable-input,.combo").off('click');
	$('#' + gridId + 'TB').next().find(".datagrid-editable-input,.combo").on('click',function(){				
		var index = INSUMIGetEditRowIndexByID(gridId);
		$('#' + gridId).datagrid('selectRow',index);
	});	
}
/*
 * ����ҽԺԺ��combogrid
 * tangzf 2019-7-18
 */
function selectHospCombHandle(){
	/*$('#InsuType').combobox('clear');
	$('#InsuType').combobox('reload');
	$('#TYPE').combobox('clear');
	$('#TYPE').combobox('reload');
	$('#AuditFlag').combobox('clear');
	$('#AuditFlag').combobox('reload');*/
	//InsuType
	init_insuType();
	init_auditFlag();
	init_INSUMIType();
	Load_dg_DataGrid();
	
}


