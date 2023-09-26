var PageLogicObj={
	m_PatAllDiagTabDataGrid:""
};
//diagCatkw
$(function(){
	//初始化
	Init();
	//页面元素初始化
	//PageHandle();
	//表格数据初始化
	LoadPatAllDiagTabDataGrid();
});
function Init(){
	InitSearchType()
	InitdiagCatkw();
	PageLogicObj.m_PatAllDiagTabDataGrid=InitPatAllDiagTabDataGrid();
	InitPageItemEvent();
}
function InitPageItemEvent(){
	$("#BFind").click(LoadPatAllDiagTabDataGrid);
	$("#BCopy").click(CopyDiag);
	$HUI.radio(".hisui-radio",{
        onChecked:function(e,value){
            LoadPatAllDiagTabDataGrid();
        }
    });
}
function InitSearchType(){
	$HUI.combobox("#searchType", {
		width:120,
		valueField: 'id',
		textField: 'text',
		editable:false,
		data: [
			{"id":"ALL","text":$g("全部"),"selected":true},
			{"id":"DiagDesc","text":$g("诊断描述")},
			{"id":"DiagType","text":$g("诊断类型")},
			{"id":"DiagLoc","text":$g("下诊断科室")}
		],
		onSelect:function(record){
			$("#searchDesc").val("").focus();
		}
	})
}
function InitdiagCatkw(){
	$("#diagCatkw").keywords({
	    singleSelect:false,
	    labelCls:'red',
	    items:[
	        {text:$g('西医'),id:0,selected:true},
	        {text:$g('中医'),id:1,selected:true}
	    ],
	    onUnselect:function(v){LoadPatAllDiagTabDataGrid();},
	    onSelect:function(v){LoadPatAllDiagTabDataGrid();}
	})
}
function InitPatAllDiagTabDataGrid(){
	var Columns=[[ 
		{field:'LastMRDIARowId',checkbox:'true',width:70},
		{field:'GroupICDRowIDStr',title:'重复',width:90,
			formatter:function(value,rec){  
			   var btn = '<a class="editcls" onclick="diagRepeatDetailShow(\'' + rec.GroupICDRowIDStr +"'\,\'" +rec.Desc + '\')">记录'+rec.RepeatNum+'条</a>';
			   return btn;
            }
		},
		{field:'Desc',title:'诊断描述',width:150},
		{field:'LastDiagStatus',title:'最新诊断状态',width:100},
		{field:'FirstMRDate',title:'最早诊断日期',width:100},
		{field:'LastMRDate',title:'最新诊断日期',width:100},
		{field:'DiagPALongDate',title:'长效诊断起止日期',width:180},
		{field:'LastDoctDesc',title:'最新诊断医生',width:100},
		{field:'LastUpdateLoc',title:'最新诊断科室',width:150},
		{field:'ICDCodeStr',title:'ICD代码',width:150},
    ]]
	var PatAllDiagTabDataGrid=$("#PatAllDiagTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'GroupICDRowIDStr',
		columns :Columns,
		onCheck:function(index, row){
		},
		onLoadSuccess:function(data){
			PageLogicObj.m_PatAllDiagTabDataGrid.datagrid("uncheckAll");
		}
	});
	return PatAllDiagTabDataGrid;
}
function LoadPatAllDiagTabDataGrid(){
	var AdmTypeStr=$("input[name='AdmType']:checked")[0].value;
	var kwSel=$("#diagCatkw").keywords("getSelected");
	var diagCat="";
	for (var i=0;i<kwSel.length;i++) {
		if (diagCat==="") diagCat=kwSel[i].id;
		else diagCat=diagCat+"^"+kwSel[i].id;
	}
	var searchType=$("#searchType").combobox("getValue");
	var searchDesc=$.trim($("#searchDesc").val());
	$.q({
	    ClassName : "web.DHCDocPatAllDiagnos",
	    QueryName : "GetPatAllDiagnose",
	    PatientID:ServerObj.PatientID,
	    diagCat:diagCat,
	    AdmTypeStr:AdmTypeStr,
	    searchType:searchType,
	    searchDesc:searchDesc,
	    Pagerows:PageLogicObj.m_PatAllDiagTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_PatAllDiagTabDataGrid.datagrid("uncheckAll").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function diagRepeatDetailShow(GroupICDRowIDStr,DiagDesc){
	 websys_showModal({
			url:"dhcdocpatrepeatdiag.csp?PatientID=" + ServerObj.PatientID+"&GroupICDRowIDStr="+GroupICDRowIDStr,
			title:ServerObj.PatName+"患者的【"+DiagDesc+"】诊断重复列表",
			width:'93%',height:'93%'
	 });
}
function CopyDiag(){
	var rows = PageLogicObj.m_PatAllDiagTabDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
        var ids = [];
        for (var i = 0; i < rows.length; i++) {
            ids.push(rows[i].GroupICDRowIDStr+String.fromCharCode(1)+rows[i].Desc+String.fromCharCode(1)+"");
        }
        var ID=ids.join(String.fromCharCode(2));
        websys_showModal("hide");
		websys_showModal('options').AddCopyItemToList(ID,"CopyFromAllDiag");
		websys_showModal("close");
    }else {
        $.messager.alert("提示", "请选择要复制的记录!");
    }
}
