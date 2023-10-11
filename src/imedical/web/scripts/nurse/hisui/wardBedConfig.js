$(function(){
	InitHospList();
})
function InitHospList(){
	/*var hospComp = GenHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		$('#WardListTab').datagrid('unselectAll').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitCombobox();
		InitWardListTab();
	}*/
	$cm({
		 ClassName: "Nur.HISUI.WardBed",
		 MethodName: "GetHospitalList"
	 }, function (jsonData) {
		 $("#_HospList").combobox({
			 editable:false,
			 width:'250',
			 valueField:'id',
			 textField:'desc',
			 mode: "local",
			 data:jsonData,
			 value:session['LOGON.HOSPID'],
			 onSelect:function(e){
				$('#WardListTab').datagrid('unselectAll').datagrid('reload');
			 },
			 onLoadSuccess:function(){
				 InitCombobox();
				 InitWardListTab();
			 }
		 });
	 });
}

function InitCombobox(){
	$HUI.combobox('#comboFilter', {
		valueField: 'id',
		textField: 'text',
		value: 1,
		data:[
			{id:1, text:$g("ȫ��")},
			{id:2, text:$g("����ɸѡ")},
			{id:3, text:$g("����ȫ��ɸѡ")}
		],
		onChange:function(newval, oldval){
			filterTabData();
		},
			//defaultFilter:4
	});
}

function InitWardListTab(){
	$("#tab-div").css("height",$(window).height()-100);
	var Columns=[[    
		{ field: 'wardRowId', checkbox:true},
		{ field: 'wardDesc', title: '�����б�', width: 40},
		{ field: 'personShow', title: '������ʾ', width: 20,formatter:function (value,row,index) {
			return 1==value?$g('��'):'';
		}},
		{ field: 'groupShow', title: '����ȫ����ʾ', width: 20,formatter:function (value,row,index) {
			return 1==value?$g('��'):'';
		}}
    ]];
	$('#WardListTab').datagrid({  
		fit : true,
		//width : 'auto',
		//height:$(window).height()-150,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=CF.NUR.NIS.WardBedConfig&QueryName=GetWardsList&rows=9999",
		loadMsg : '������..',  
		pagination : false,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"wardRowId",
		columns :Columns,
		onBeforeLoad:function(param){
			$('#WardListTab').datagrid("unselectAll");
			param = $.extend(param,{
				HospId:$HUI.combobox('#_HospList').getValue(),
				desc:$("#SearchDesc").searchbox("getValue").toUpperCase(),
			 	userId:session['LOGON.USERID'],
			 	groupId:session['LOGON.GROUPID'],
			 	filterFlag: $('#comboFilter').combobox('getValue')
			});
		},
			toolbar: [{
				id: 'btnAddHosp',
				iconCls: 'icon-arrow-right-top',
				text:'���水����ʾ',
				handler: saveTabDataByUser
			},'-',{				
				id: 'btnAddFilter',
				iconCls: 'icon-arrow-right-top',
				text:'����ȫ�鱣����ʾ',
				handler: saveTabDataByGruop
			},'-',{	
				id: 'btnDeleteFilter',
				iconCls: 'icon-undo',
				text:'����������ʾ',
				handler: cancelTabDataByUser
			},'-',{	
				id: 'btnDirectory',			
				iconCls: 'icon-undo',
				text:'��������ȫ�鱣����ʾ',
				handler: cancelTabDataByGruop
			}]
	});
	
}

function saveTabDataByUser(){
	saveSetComm("person");
}

function saveTabDataByGruop(){
	saveSetComm("gruop");
}

function cancelTabDataByUser(){
	cancelSetComm("person");
}

function cancelTabDataByGruop(){
	cancelSetComm("gruop");
}

function filterTabData(){
	$('#WardListTab').datagrid("reload");
}

function saveSetComm(type){
	var rows=$('#WardListTab').datagrid('getSelections');
	if (rows.length==0) {
		$.messager.alert($g("��ʾ"),$g("û����Ҫ��������ݣ�"));
		return false;
	}
	var wardIdsPara=""
	for (var i=0;i<rows.length;i++){
		var wardId=rows[i].wardRowId;
		if (wardIdsPara == "") wardIdsPara = wardId;
		else  wardIdsPara = wardIdsPara + "^" + wardId;
	}
	$.cm({
		 ClassName:"CF.NUR.NIS.WardBedConfig",
		 MethodName:"SaveConfig",
		 hospId:$HUI.combobox('#_HospList').getValue(),
		 wardIdStr:wardIdsPara,
		 userId:session['LOGON.USERID'],
		 groupId:session['LOGON.GROUPID'],
		 saveType:type,
		 dataType:"text"
	},function(rtn){
		if (rtn ==0){
			$('#WardListTab').datagrid("reload");
			return $.messager.popover({ msg: $g("����ɹ���"), type:'success' });
		}else{
			$('#WardListTab').datagrid("reload");
			return $.messager.popover({ msg: $g("����ʧ�ܣ�")+rtn, type:'error' });	
		}
	});
}

function cancelSetComm(type){
	var rows=$('#WardListTab').datagrid('getSelections');
	if (rows.length==0) {
		$.messager.alert($g("��ʾ"),$g("������ѡ��һ�����ݣ�"));
		return false;
	}
	var wardIdsPara=""
	for (var i=0;i<rows.length;i++){
		var wardId=rows[i].wardRowId;
		if (wardIdsPara == "") wardIdsPara = wardId;
		else  wardIdsPara = wardIdsPara + "^" + wardId;
	}
	$.cm({
		 ClassName:"CF.NUR.NIS.WardBedConfig",
		 MethodName:"CancelConfig",
		 hospId:$HUI.combobox('#_HospList').getValue(),
		 wardIdStr:wardIdsPara,
		 userId:session['LOGON.USERID'],
		 groupId:session['LOGON.GROUPID'],
		 saveType:type,
		 dataType:"text"
	},function(rtn){
		if (rtn ==0){
			$('#WardListTab').datagrid("reload");
			return $.messager.popover({ msg: $g("�����ɹ���"), type:'success' });
		}else{
			$('#WardListTab').datagrid("reload");
			return $.messager.popover({ msg: $g("����ʧ�ܣ�")+rtn, type:'error' });	
		}
	});
}