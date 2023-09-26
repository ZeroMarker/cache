var contactsComboGrid;
$(function(){ 
  InitHospList();
  $("#BSave").click(SaveArcimConfig);
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_ArcItemConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		datadefault();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitArcimList();
		datadefault();
	}
}
function SaveArcimConfig()
{
	var ArcimRowid=$('#Combo_ContinuousOxygenItem').combogrid('getValue');
    if(ArcimRowid!="") ArcimRowid=$('#Combo_ContinuousOxygenItem').combogrid("options").value
    var Data="ContinuousOxygenItem"+String.fromCharCode(1)+ArcimRowid;
    var value=$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig",
	   	Coninfo:Data,
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(value=="0"){
	   $.messager.popover({msg: '保存成功!',type:'success'});
	}else{
	   $.messager.alert('提示',"保存失败:"+value);
	}
};
function InitArcimList()
{
	$('#Combo_ContinuousOxygenItem').combogrid({
		panelWidth:500,
		panelHeight:400,
		delay: 500,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'ArcimRowID',    
		textField: 'ArcimDesc',    
		columns: [[    
			{field:'ArcimDesc',title:'名称',width:400,sortable:true},
			{field:'ArcimRowID',title:'ID',width:120,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		]],
		onSelect: function (){
			var selected = $('#Combo_ContinuousOxygenItem').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#Combo_ContinuousOxygenItem').combogrid("options").value=selected.ArcimRowID;
			}
		},
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}else{
				var desc="";
			}
			var HospId=$HUI.combogrid('#_HospList').getValue();
			param = $.extend(param,{Alias:desc,HospId:HospId});
		},
		onChange:function(newValue,oldValue){
			if ((newValue=="")||(!newValue)) {
				$(this).combogrid('setValue','');
				$('#Combo_ContinuousOxygenItem').combogrid("options").value="";
			}
		}
	});
};
function datadefault(){
	var objScope=$.m({
		ClassName:"DHCDoc.DHCDocConfig.ArcItemConfig",
		MethodName:"getDefaultData",
	   	value:"ContinuousOxygenItem",
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	objScope=eval("(" + objScope + ")");
	$('#Combo_ContinuousOxygenItem').combogrid('setValue',objScope.result.split("^")[1])
	$('#Combo_ContinuousOxygenItem').combogrid("options").value=objScope.result.split("^")[0];
}