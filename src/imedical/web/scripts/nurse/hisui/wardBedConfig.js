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
			{id:1, text:$g("全部")},
			{id:2, text:$g("按人筛选")},
			{id:3, text:$g("按安全组筛选")}
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
		{ field: 'wardDesc', title: '病区列表', width: 40},
		{ field: 'personShow', title: '按人显示', width: 20,formatter:function (value,row,index) {
			return 1==value?$g('是'):'';
		}},
		{ field: 'groupShow', title: '按安全组显示', width: 20,formatter:function (value,row,index) {
			return 1==value?$g('是'):'';
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
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
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
				text:'保存按人显示',
				handler: saveTabDataByUser
			},'-',{				
				id: 'btnAddFilter',
				iconCls: 'icon-arrow-right-top',
				text:'按安全组保存显示',
				handler: saveTabDataByGruop
			},'-',{	
				id: 'btnDeleteFilter',
				iconCls: 'icon-undo',
				text:'撤销按人显示',
				handler: cancelTabDataByUser
			},'-',{	
				id: 'btnDirectory',			
				iconCls: 'icon-undo',
				text:'撤销按安全组保存显示',
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
		$.messager.alert($g("提示"),$g("没有需要保存的数据！"));
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
			return $.messager.popover({ msg: $g("保存成功！"), type:'success' });
		}else{
			$('#WardListTab').datagrid("reload");
			return $.messager.popover({ msg: $g("保存失败！")+rtn, type:'error' });	
		}
	});
}

function cancelSetComm(type){
	var rows=$('#WardListTab').datagrid('getSelections');
	if (rows.length==0) {
		$.messager.alert($g("提示"),$g("请至少选择一条数据！"));
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
			return $.messager.popover({ msg: $g("操作成功！"), type:'success' });
		}else{
			$('#WardListTab').datagrid("reload");
			return $.messager.popover({ msg: $g("操作失败！")+rtn, type:'error' });	
		}
	});
}