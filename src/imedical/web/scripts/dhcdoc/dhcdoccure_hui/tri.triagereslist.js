var CureRBCResListDataGrid;
$(document).ready(function(){
	Init();
	InitEvent();	
	CureRBCResListDataGridLoad();
	
});

function Init(){
	InitLoc(); 	
	InitCureRBCResListDataGrid();
}

function InitEvent(){
	$('#btnSearch').bind('click', function(){
		   CureRBCResListDataGridLoad();
    });
    
    $('#btnTriage').bind('click', function(){
		   TriageOnClick();
    });	
}

function InitCureRBCResListDataGrid()
{
	CureRBCResListDataGrid=$('#tabCureRBCResList').datagrid({  
		fit : true,
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		checkOnSelect:true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DDCTRROWID",
		pageNumber:0,
		pageSize : 5,
		pageList : [5,10,50,100],
		columns :[[ 
				//{field:'RowCheck',checkbox:true},     
				{field:'DDCTRROWID',title:'',width:35,align:'center',hidden:true},   
				{field:'DDCTRCTLoc',title:'科室',width:100,align:'center'},   
				{field:'DDCTRResDesc',title:'资源名称',width:100,align:'center'},   
				{field:'CureTriageNum',title:'已分配人数',width:50,align:'center'
				/*,formatter:function(value,row,index){	
							return '<a href="###" onclick=CureTriageNumClick('+index+');>已分配:'+row.CureTriageNum+"</a>"
						}*/
				},
				{field:'DDCTRLeftCount',title:'剩余可分配人数',width:50,align:'center'},
				{field:'DDCTRCount',title:'最大可分配人数',width:50,align:'center'},
				{field:'DDCTRHistoryRes',title:'是否历史分配',width:50,align:'center'
				,styler: function(value,row,index){
							if (value.indexOf("是")>=0){
								return 'background-color:#FF6347;';
							}
						}
				}
			 ]] 
	});
	CureRBCResListDataGridLoad();
}
function CureRBCResListDataGridLoad()
{
	var DCARowIdStr=$('#DCARowIdStr').val();
	var queryLoc=$("#ComboLoc").combogrid("getValue");
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Triage",
		QueryName:"QueryTriageResource",
		'DCARowIDStr':DCARowIdStr,
		'LocRowID':queryLoc,
		Pagerows:CureRBCResListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureRBCResListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function CureTriageNumClick(index){
	var selected=CureRBCResListDataGrid.datagrid('getRows'); 
	var DDCTRROWID=selected[index].DDCTRROWID;
	var DCARowIdStr=$('#DCARowIdStr').val();
	//var OperateType=$('#OperateType').val();
	var href="dhcdoc.cure.curetriagelist.csp?DCARowId="+DCARowIdStr+"&DDCTRIRowID="+DDCTRROWID;
	if(typeof websys_writeMWToken=='function') href=websys_writeMWToken(href);
	var ReturnValue=window.open(href,"","dialogwidth:60em;dialogheight:30em;status:no;center:1;resizable:yes");
	
}

function InitLoc()
{
	//科室列表
    var DDCTRCTLocListObj=$HUI.combobox("#ComboLoc",{
		valueField:'LocId',   
    	textField:'LocDesc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryCureLoc&ResultSetType=array",		
	});
};

function TriageOnClick(){
	var DCARowIdStr=$('#DCARowIdStr').val();
	if(DCARowIdStr==""){
		$.messager.alert("错误", "请选择待分配的申请单", 'error')
		return false;	
	}
	var selected=CureRBCResListDataGrid.datagrid('getRows'); 
	var rows = CureRBCResListDataGrid.datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.alert("错误", "请选择分配的资源", 'error')
		return false;
	}
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].DDCTRROWID);
		}
		var ID=ids.join(',');
		var DCARowIdArr=DCARowIdStr.split("!");
		var err="";
		var success=1;
		for(var j=0;j<DCARowIdArr.length;j++){	
			var oneDCARowId=DCARowIdArr[j];		
			var CureAppInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",oneDCARowId);
			var PatName="";
			var ArcimDesc="";
			if(CurePatInfo!=""){
				var CurePatInfo=CureAppInfo.split(String.fromCharCode(1))[0];
				var CureInfo=CureAppInfo.split(String.fromCharCode(1))[1];
				var PatName=CurePatInfo.split("^")[2];
				var ArcimDesc=CureInfo.split("^")[0];
			}
			
			//多人分配，需要进行同步处理
			var Para=oneDCARowId+"^"+session['LOGON.USERID'];
			var ObjScope=$.cm({
				ClassName:"DHCDoc.DHCDocCure.Triage",
				MethodName:"CureTriagedJson",
				'DDCTRResID':ID,
				'Para':Para,
			},false);
			var value=ObjScope.result;
			if(value=="0"){
				var obj=window.frames.parent
			}else{
				success=0;
				var err=value
				if (value==100) err="有参数为空";
				else if(value==101) err="分配资源ID为空";
				else if(value==102) err="该申请单已分配";
				else if(value==103) err="该分配资源人员已满.";
				else if(value=="-301") err="保存分配记录失败";
				else if(value=="-300") err="更新申请单状态失败";
				$.messager.alert('提示',"分配失败:"+err);	
			}
		}
		$.messager.show({title:"提示",msg:"操作完成"});
		CureRBCResListDataGridLoad();
		CureRBCResListDataGrid.datagrid('unselectAll');
		if(window.frames.parent.CureApplyDataGrid){
			window.frames.parent.RefreshDataGrid();
		}
		
    }
}