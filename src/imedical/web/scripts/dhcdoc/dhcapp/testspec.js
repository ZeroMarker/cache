/// Descript: 病理标本字典维护
/// Creator : yuliping
/// Date    : 2017-07-08
var editRow="";
/// 页面初始化函数
function initPageDefault(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("DHC_AppTestSpec",hospStr);
	hospComp.jdata.options.onSelect  = function(){
		initTestItem();
		} 
	initTestItem();       	/// 初始页面DataGrid病理检测项目
	
	//同时给代码和描述绑定回车事件
    $('#ATSCode,#ATSDesc').bind('keypress',function(event){
	    
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}) //调用查询
        }
    });
	
}
///病理检测项目
function initTestItem(){
	
	var Hospeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto" , //设置容器高度自动增长,
			required: true
		}
	}
	
	var atsflag={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"是"},{"value":"N","text":"否"}],
			
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'ActiveFlag'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'ActiveFlagCode'});
				$(ed.target).val(option.value); 
			} 
			
		}
	}
	var catinsflag={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"是"},{"value":"N","text":"否"}],
			
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'CatInsFlag'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'CatInsFlagCode'});
				$(ed.target).val(option.value); 
			} 
			
		}
	}
	var mulflag={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"是"},{"value":"N","text":"否"}],
			
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'MulFlag'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'MulFlagCode'});
				$(ed.target).val(option.value); 
			} 
			
		}
	}
	var catEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPTestItem&MethodName=QueryArcCatList",
			//required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}
	/// 文本编辑格
	var textEditor={
		type: 'validatebox',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 定义columns
	
	var columns=[[
		{field:"ATSCode",title:'项目代码',width:150,editor:textEditor},
		{field:"ATSDesc",title:'项目描述',width:150,editor:textEditor},
		{field:"CatDesc",title:'标本所属分类',width:140,editor:catEditor,hidden:'true'},
		{field:"HospDesc",title:'医院标识',width:200}, //editor:Hospeditor
		{field:"ActiveFlag",title:'是否可用',width:80,align:'center',editor:atsflag},
		{field:"ActiveFlagCode",title:'ActiveFlagCode',width:80,align:'center',editor:textEditor,hidden:'true'},
		{field:"CatDr",title:'CatDr',width:20,hidden:'true',align:'center'},
		{field:"HospDr",title:'HospDr',width:20,hidden:'true',align:'center'},
		{field:"ATSid",title:'ATSid',width:20,hidden:'true',align:'center'},
		{field:"MulFlag",title:'多选',width:80,align:'center',editor:mulflag},
		{field:"MulFlagCode",title:'MulFlagCode',width:80,align:'center',editor:textEditor,hidden:'true'},
		{field:"CatInsFlag",title:'是否为穿刺',width:80,align:'center',editor:catinsflag},
		{field:"CatInsFlagCode",title:'CatInsFlagCode',width:80,align:'center',editor:textEditor,hidden:'true'}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            onClickRow(rowIndex,rowData) 
            editRow=rowIndex;
        }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPTestSpec&MethodName=ListAPPTestSpec&HospID="+HospID;
	new ListComponent('datagrid', columns, uniturl, option).Init(); 
}
function addRow(){
	var HospDesc=$HUI.combogrid('#_HospList').getText();
	commonAddRow({'datagrid':'#datagrid',value:{'HospDesc':HospDesc,'ActiveFlag':'Y','ActiveFlagCode':'Y','MulFlag':'Y','MulFlagCode':'Y','CatInsFlag':'Y','CatInsFlagCode':'Y'}})
	editRow=0;
}
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	saveByDataGridNew("web.DHCAPPTestSpec","SaveUpdTestSpec","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==2){
				$.messager.alert("提示","描述已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}
function saveByDataGridNew(className,methodName,gridid,handle,datatype){
	if(!endEditing(gridid)){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	var rowsData = $(gridid).datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowData=[];
		var fileds=$(gridid).datagrid('getColumnFields')
		for(var j=0;j<fileds.length;j++){
			rowData.push(typeof(rowsData[i][fileds[j]]) == "undefined"?0:rowsData[i][fileds[j]])
		}
		dataList.push(rowData.join("^"));
	} 
	var params=dataList.join("$$");
	//alert(params)
	var HospID=$HUI.combogrid('#_HospList').getValue();
	runClassMethod(className,methodName,{'params':params,'HospID':HospID},handle,datatype)
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPTestSpec","RemoveTestSpec",{'Id':row.ATSid},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}
var m_ReBLMapDataGrid
function ConItemRow(){
	var rowsData = $("#datagrid").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示", "请选择一个项目!", 'info');
		return 
	}
	$("#ReBLMap-dialog").dialog("open");
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.cm({
			ClassName:"web.DHCAPPTestSpec",
			QueryName:"FindArcItem",
			HospID:HospID,
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#BLMap", {
				editable:false,
				valueField: 'arcimid',
				textField: 'arcitmdesc', 
				data: GridData["rows"],
				onLoadSuccess:function(){
					$("#BLMap").combobox('select','');
				}
			 });
	});
	m_ReBLMapDataGrid=InitReBLMapDataGrid();
	LoadReBLMapDataGrid();
	}
function InitReBLMapDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {ConItemaddClickHandle();}
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {ConItemdelectClickHandle();}
    }];
	var Columns=[[ 
		{field:'RowID',hidden:true,title:'RowID'},
		{field:'arcimid',hidden:true,title:'BLMapID'},
		{field:'arcitmdesc',title:'医嘱项描述',width:100},
		{field:'arcitmcode',title:'医嘱代码',width:100}
    ]]
	var ReHospitalDataGrid=$("#ReBLMapTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'RowID',
		columns :Columns,
		toolbar:toobar
	}); 
	return ReHospitalDataGrid;
}
function LoadReBLMapDataGrid(){
	var rowsData = $("#datagrid").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示", "请选择一个项目!", 'info');
		return 
	}
	var PisDicItem=rowsData["ATSid"]
	$.q({
	    ClassName : "web.DHCAPPTestSpec",
	    QueryName : "FindAppTestSpecRelArc",
	    PisDicItem:PisDicItem,
	    Pagerows:m_ReBLMapDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		m_ReBLMapDataGrid.datagrid("unselectAll");
		m_ReBLMapDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function ConItemaddClickHandle(){
	var rowsData = $("#datagrid").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示", "请选择一个项目!", 'info');
		return 
	}
	var TestSpec=rowsData["ATSid"]
	var TestSpecArc=$("#BLMap").combobox("getValue");
	if (TestSpecArc=="") {
		$.messager.alert("提示", "请选择医嘱项!", 'info');
		return 
	}
	$.cm({
		ClassName:"web.DHCAPPTestSpec",
		MethodName:"InsertAppTestSpecRelArc",
		TestSpec:TestSpec,
		TestSpecArc:TestSpecArc,
		dataType:"text",
	},function(data){
		if(data==-1) {
			$.messager.alert("提示","增加失败!记录重复!");
		}else{
			$.messager.popover({msg: '增加成功!',type:'success',timeout: 1000});
			LoadReBLMapDataGrid();
		}
	})
}
function ConItemdelectClickHandle(){
	var rowsData = m_ReBLMapDataGrid.datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示", "请选择一个项目!", 'info');
		return 
	}
	var RowID=rowsData.RowID
	$.cm({
		ClassName:"web.DHCAPPTestSpec",
		MethodName:"DelectAppTestSpecRelArc",
		RowID:RowID,
		dataType:"text",
	},function(data){
		$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
		LoadReBLMapDataGrid();
	})
}
function translateword(){
	var SelectedRow = $("#datagrid").datagrid('getSelected');
	if (!SelectedRow){
		$.messager.alert("提示","请选择需要翻译的行!","info");
		return false;
	}
	CreatTranLate("User.DHCAppTestSpec","ATSDesc",SelectedRow["ATSDesc"])	
	}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
