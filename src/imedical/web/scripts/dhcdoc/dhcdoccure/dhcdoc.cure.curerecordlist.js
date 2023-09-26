var cureRecordDataGrid;
$(function(){
	InitCureRecordDataGrid();
	
});
function Int()
{
	loadCureRecordDataGrid();		
}

function InitCureRecordDataGrid()
{
	// Toolbar
	var cureRecordToolBar = [{
		id:'BtnDetailView',
		text:'浏览', 
		iconCls:'icon-search',  
		handler:function(){
			var rows = cureRecordDataGrid.datagrid("getSelections");
			if (rows.length==0) 
			{
				$.messager.alert("提示","请选择一条治疗记录单查看");
				return;
			}else if (rows.length>1){
	     		$.messager.alert("错误","您选择了多个治疗记录单！",'err')
	     		return;
    		}
    		var DCRRowId=""
			var rowIndex = cureRecordDataGrid.datagrid("getRowIndex", rows[0]);
			var selected=cureRecordDataGrid.datagrid('getRows'); 
			var DCRRowId=selected[rowIndex].Rowid;
			if(DCRRowId=="")
			{
				$.messager.alert('Warning','请选择一条治疗记录');
				return false;
			}
			OpenCureRecordDiag(DCRRowId);
		}
	}];
	// 治疗申请单预约记录Grid
	cureRecordDataGrid=$('#tabCureRecordList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : "",
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"CureRecordId",
		pageList : [15,50,100,200],
		columns :[[   
        			{field:'Rowid',title:'',width:1,hidden:true}, 
        			{field:'DCRTitle',title:'标题',width:300},  
        			{field:'CreateUser',title:'创建人',width:100},
        			{field:'CreateDate',title:'创建时间',width:100},
        			{field:'UpdateUser',title:'最后更新人',width:100},
        			{field:'DDCRSLoc',title:'预约-科室',width:100},
        			{field:'CTCareProv',title:'预约-资源',width:100},
        			{field:'DDCRSDate',title:'预约-日期',width:100},
        			{field:'TimeRangeDesc',title:'预约-时段',width:100},
        			{field:'ServiceGroupDesc',title:'预约-服务组',width:100},
        			{field:'DCAAStatus',title:'预约-状态',width:100},
        			{field:'DCAARowId',title:'预约-ID',width:100}   
        			//,CTCareProv,DDCRSDate,TimeRangeDesc,ServiceGroupDesc,DCAAStatus 
    			 ]] ,
    	toolbar : cureRecordToolBar
	});
}
function loadCureRecordDataGrid()
{
	var DCARowId=$('#DCARowId').val();
	var DCAARowId=$('#DCAARowId').val();
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Record';
	queryParams.QueryName ='FindCureRecordList';
	queryParams.Arg1 =DCARowId;
	queryParams.ArgCnt =1;
	var opts = cureRecordDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp";
	cureRecordDataGrid.datagrid('load', queryParams);
	cureRecordDataGrid.datagrid('unselectAll');
}
function OpenCureRecordDiag(DCRRowId)
{
	var OperateType=$('#OperateType').val();
	var DCAARowId=$('#DCAARowId').val(); //预约ID
	if (DCAARowId==""){
		//传入的预约ID不存在 获取治疗记录上的
		var rows = cureRecordDataGrid.datagrid("getSelections");
		if (rows.length==1){
	     	var rowIndex = cureRecordDataGrid.datagrid("getRowIndex", rows[0]);
			var selected=cureRecordDataGrid.datagrid('getRows'); 
			DCAARowId=selected[rowIndex].DCAARowId;
		}
	}
	var href="dhcdoc.cure.curerecord.csp?OperateType="+OperateType+"&DCRRowId="+DCRRowId+"&DCAARowId="+DCAARowId;
	//alert(DCRRowId);
	var ReturnValue=window.showModalDialog(href,"","dialogwidth:60em;dialogheight:30em;status:no;center:1;resizable:yes");
	/*
	var _content ="<iframe src='"+href+ "' scrolling='no' frameborder='0' style='width:100%;height:100%;'></iframe>"
	   $("#cureRecordDetailDiag").dialog({
        width: 800,
        height: 470,
        modal: true,
        content: _content,
        title: "治疗记录单",
        draggable: true,
        resizable: true,
        shadow: true,
        minimizable: false
    });
    */ 
}

