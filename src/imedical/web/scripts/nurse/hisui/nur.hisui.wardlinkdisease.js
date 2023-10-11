$(function(){
	//初始化
	Init();
});
function Init(){
	var hospComp = GenHospComp("Nur_IP_WardLinkDisease");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#tabWard,#tabDisease").datagrid("reload");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitTabWardGrid();
		InitTabDiseaseGrid();
	}
}
function InitTabWardGrid() {
	var Columns=[[ 
		{field:'wardid',title:'病区ID',width:70},
		{field:'warddesc',title:'病区',width:250}
    ]]
	$("#tabWard").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'wardid',
		columns :Columns,
		url : $URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&rows=99999",
		onBeforeLoad:function(param){
			$('#tabWard').datagrid("unselectAll");
			$.extend(param,{desc:"",bizTable:"Nur_IP_WardLinkDisease",hospid:$HUI.combogrid('#_HospList').getValue()});
		},
		onClickRow:function(rowIndex, rowData){
			$("#tabDisease").datagrid("reload");
		}
	}); 
}
function InitTabDiseaseGrid() {
	var toobar=[{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {SaveWardLinkDiseases();}
    }];
	var Columns=[[ 
		{field:'KICId',title:'病种ID',checkbox:true},
		{field:'KICDesc',title:'病种',width:350}
    ]]
	$("#tabDisease").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : false,  
		idField:'KICId',
		columns :Columns,
		toolbar:toobar,
		url : $URL+"?ClassName=Nur.TCM.Service.Config&QueryName=GetWardLinkDisease&rows=99999",
		onBeforeLoad:function(param){
			$('#tabDisease').datagrid("unselectAll");
			var sel=$("#tabWard").datagrid("getSelected");
			$.extend(param,{WardId:sel?sel.wardid:""});
		},
		onLoadSuccess:function(data){
			for (i=0;i<data.rows.length;i++){
				if (data.rows[i].selected=="Y"){
					$("#tabDisease").datagrid("selectRow",i);
				}
			}
		}
	}); 
}
function SaveWardLinkDiseases(){
	var sel=$("#tabWard").datagrid("getSelections");
	if (sel.length ==0){
		$.messager.popover({msg: '请选择病区!',type:'error',timeout: 1000});
		return false;
	}
	var SaveDiseaseArr=[];
	var rows=$("#tabDisease").datagrid("getSelections");
	for (var i=0;i<rows.length;i++){
		SaveDiseaseArr.push(rows[i].KICId);
	}
	$.m({
		ClassName:"Nur.TCM.Service.Config",
		MethodName:"SaveWardLinkDisease",
		WardId:sel[0].wardid,
		WLDDiseases:SaveDiseaseArr.join("^")
	},function(rtn){
		if(+rtn=="0"){
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
		}else{
			$.messager.popover({msg: '保存失败!'+rtn,type:'error',timeout: 1000});
			return false
		}
	})
}