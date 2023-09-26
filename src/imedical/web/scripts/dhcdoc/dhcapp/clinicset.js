//检查申请报告结果和图象阅读相关配置js
//wangxuejian  2017/02/23
var RhasRegArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
var RhasStudyNoArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
var RhasOtherArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
var IhasRegArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
var IhasStudyNoArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
var IhasOtherArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
function initPageDefault()
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Clinicset",hospStr);
	hospComp.jdata.options.onSelect = function(){
		initParams();
		initLocItemList(); 
		initMethod();
		initBlButton(); 
		reloadTable()
		HospID=$HUI.combogrid('#_HospList').getValue();
	}
	initParams();
	
	initLocItemList();       ///  加载科室表的信息
	
	initMethod();
	
	initBlButton();          ///  页面Button绑定事件
	$HUI.tabs("#tabs",{
		onSelect:function(title){
			reloadTable()					
		}
	});
	reloadTable()
	HospID=$HUI.combogrid('#_HospList').getValue();
}

function initParams(){
	curSelLoc="";	
}

function initMethod(){
	$("#searchBtn").on("click",reloadTable)	
}

///初始化科室表
function initLocItemList(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$HUI.combobox("#locList",{
		url:'dhcapp.broker.csp?ClassName=web.DHCAPPLocLinkClinicSet&MethodName=JsonLocList&HospID='+HospID,
		valueField:'value',
		textField:'text',
		mode:'remote'
	})
}


/// 页面 Button 绑定事件
function initBlButton(){
	
	$('#find').bind('click',function(event){
         commonQuery(); //调用查询出科室信息
    })
    var HospID=$HUI.combogrid('#_HospList').getValue();
    $('#Loc').combobox({ 
    url:'dhcapp.broker.csp?ClassName=web.DHCAPPLocLinkClinicSet&MethodName=SelAllLoc&HospID='+HospID,

  	valueField:'val', 
  	textField:'text',
	editable:true
}); 

}
///插入执行报告参数
function addReportRow(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var e = $("#datagrid").datagrid('getColumnOption', 'Loc');
	e.editor = {type:'combobox',options:{
										url:'dhcapp.broker.csp?ClassName=web.DHCAPPLocLinkClinicSet&MethodName=JsonLocList&HospID='+HospID,
										valueField:'value',
										textField:'text',
										required:true,
										mode:'remote',
										onSelect:function(option){
											var ed=$('#datagrid').datagrid('getEditor',{index:editIndex,field:'LocDr'});
											$(ed.target).val(option.value);
										}	
										}
									};
	commonAddRow({'datagrid':'#datagrid',value:{'LocDr':'','HasRegNo':'Y','HasStudyNo':'Y','HasOrdItm':'Y','HasOther':'Y','HasRepId':'Y'}})
}

///插入影像调用参数
function addImageRow(){
	var rowsMData = $("#locItemList").datagrid('getSelected'); //选中左边的科室项目
	commonAddRow({'datagrid':'#ImageParam',value:{'LocDr':rowsMData.LocRowId,'IhasReg':'Y','IhasStudyNo':'Y','IhasOther':'Y','HasRepId':'Y'}})
}



///更新执行报告参数信息
function onClickRowReport(index,row){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var e = $("#datagrid").datagrid('getColumnOption', 'Loc');
	e.editor = {type:'combobox',options:{
										url:'dhcapp.broker.csp?ClassName=web.DHCAPPLocLinkClinicSet&MethodName=JsonLocList&HospID='+HospID,
										valueField:'value',
										textField:'text',
										required:true,
										mode:'remote',
										onSelect:function(option){
											var ed=$('#datagrid').datagrid('getEditor',{index:editIndex,field:'LocDr'});
											$(ed.target).val(option.value);
										}	
										}
									};	 
	CommonRowClick(index,row,"#datagrid");
} 
///更新影像调用参数信息
function onClickRowImage(index,row){
	RowClick(index,row,"#ImageParam");
} 
///保存执行报告列表
function saveReportRow(){
	var tab = $('#tabs').tabs('getSelected');
	var index = $('#tabs').tabs('getTabIndex',tab);
	var methodName = (index==0?"SaveReport":"SaveImage");

	saveByDataGrid("web.DHCAPPLocLinkClinicSet",methodName,"#datagrid",function(data){
		if(data==0){
			$.messager.alert('提示','保存成功');
		}
	    else{
			$.messager.alert('提示','保存失败:'+data);
		}
		reloadTable();
	})
}

/// 删除执行报告中的行
function deleteReportRow(){
	
	var rowsData = $("#datagrid").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？(删除后执行报告参数和影像参数都将被删除）", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPLocLinkClinicSet","DelReportImage",{"params":rowsData.RBCDr},function(jsonString){
					reloadTable(); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}


/// 删除影像调用中的行
function deleteImageRow(){
	
	var rowsData = $("#ImageParam").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？(删除后执行报告参数和影像参数都将被删除）", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPLocLinkClinicSet","DelReportImage",{"params":rowsData.Rowid},function(jsonString){
					
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}



/// 按科室描述查询函数
function commonQuery() 
{
	var desc=$('#Loc').combobox('getText');
	/// 科室
	var param=desc;
	$('#locItemList').datagrid('load',{params:param}); 
}

function reloadTable(){
	var tab = $('#tabs').tabs('getSelected');
	var index = $('#tabs').tabs('getTabIndex',tab);
	var inLocID = $HUI.combobox("#locList").getValue();
	var reportType= (index==0?"R":"I");
	var params = reportType+"^"+inLocID;
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$HUI.datagrid('#datagrid').load({
		Params:params,
		HospID:HospID
	})
}




/// JQuery 初始化页面
$(function(){ initPageDefault(); })
