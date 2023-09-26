
var init=function() {
	
	///////////////////////////////////////////////////////////////////////////////
	///组
	var grpGrid = $HUI.datagrid("#grpGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"GetMapedGrp",
			rptTool:"bdq", 
			searchV:"",
			rptID:"",
			wantreturnval:0
		},		
		idField:'ID',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Name',title:'名称',width:100,align:'left'},
			{field:'Code',title:'编码',width:100,align:'left'},
			{field:'Descript',title:'描述',width:100,align:'left'},
			{field:'action',title:'操作',width:70,align:'left',
				formatter:function(value,row,index){
					var rowdataid="\""+row.ID+"\"";		//datagrid的idField；
					var selector='"#grpGrid"';
					var s = "<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRptItem("+selector+","+rowdataid+",init.deleteRGMap)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
					return s;
				} 
			}
	    ]],
	    
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
	    
		fitColumns:true
	});	
	
	
	///////////////////////////////////////////////////////////////////////////////
	///报表
	var rptGrid = $HUI.datagrid("#rptGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"GetRptByDevTool",
			devTool:"bdq", 
			searchV:"",
			wantreturnval:0
		},		
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'GrpID',title:'GrpID',width:100,align:'left',hidden:true},
			{field:'Name',title:'名称',width:100,align:'left'},
			{field:'Code',title:'编码',width:100,align:'left'},
			{field:'Descript',title:'描述',width:100,align:'left'},
			{field:'Creator',title:'创建人',width:100,align:'left'}
			
	    ]],
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
		fitColumns:true,
		onClickRow:function(rowIndex, rowData){
			//1、新增按钮置enable
			//$("#RGMapGrpAddBtn").attr("disabled",false);
			$("#RGMapGrpAddBtn").linkbutton("enable");
			//$('#btnmainmodify').linkbutton("enable");
			//2、查询报表分给了哪些组
			var values=getFieldValues("rptFrom");
			var rptTool=values.rptTool;
			$("#RGMapGrpSearchBtn").searchbox("setValue","");

			$('#RGMapGrpSearchBtn').val("");
			$("#grpGrid").datagrid("load",{
				ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
				MethodName:"GetMapedGrp",
				rptTool:rptTool, 
				searchV:"",
				rptID:rowData.ID,
				wantreturnval:0
			})
			
			
		}
	});
	
	$("#rptTool").combobox({
		onSelect:function(rec){
			$('#RGMapRptSearchBtn').searchbox("setValue","");
			var values=getFieldValues("rptFrom");
			var devTool=values.rptTool;

			$('#rptGrid').datagrid('load',{
								ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
								MethodName:"GetRptByDevTool",
								devTool:devTool, 
								searchV:"",
								wantreturnval:0
						});
			$('#grpGrid').datagrid('loadData',{rows:[]})			
						
		}

		
	});
	
	//查询报表
		///主界面查询响应方法
	$('#RGMapRptSearchBtn').searchbox({
		searcher:function(value){
			
			var values=getFieldValues("rptFrom");
			var devTool=values.rptTool;

			$('#rptGrid').datagrid('load',{
								ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
								MethodName:"GetRptByDevTool",
								devTool:devTool, 
								searchV:value,
								wantreturnval:0
						});

		}
	})
		///主界面查询响应方法
	$('#RGMapGrpSearchBtn').searchbox({
		searcher:function(value){
			var values=getFieldValues("rptFrom");
			var rptTool=values.rptTool;
			var rowData=$("#rptGrid").datagrid("getSelected");
			if(rowData==null) {
				
				return;
			};
			$("#grpGrid").datagrid("load",{
				ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
				MethodName:"GetMapedGrp",
				rptTool:rptTool, 
				searchV:value,
				rptID:rowData.ID,
				wantreturnval:0
			})
		}
	})
	

	
}

var addRptGrpMapCfg=function(){
	//////////////////////////////////////////////////////////////////////////
	/////////增加报表映射
	////增加报表映射对话框
	var lookupGrpDlg = $HUI.dialog("#lookupGrpDlg",{
		iconCls:'icon-w-add',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false,
		buttons:[{
			id:"btnExpData",
			text:'确定',
			handler:function(){
				var aryIDs=[];
				var rows=$('#lookupGrpGrid').datagrid("getSelections");
				if (rows.length==0) {
					//$('#lookupGrpDlg').dialog('close');
					//return;
					$.messager.alert("提示","未选择组！请选择组。");
					return;	
				}
				for(x in rows){
					aryIDs.push(rows[x].ID);	
				};
				
				//报表工具
				var values=getFieldValues("rptFrom");
				var rptTool=values.rptTool;
				//报表ID
				var rowData=$("#rptGrid").datagrid("getSelected");
	
				$cm({
					ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
					MethodName:"insertRGMap",
					wantreturnval:0,
					rptID:rowData.ID,
					grpIDs:aryIDs.join(","),
					rptTool:rptTool
				},function(jsonData){
						if (jsonData.success==1) {
							$.messager.alert("提示","添加成功！");
							$('#lookupGrpDlg').dialog('close');
							
							var values=getFieldValues("rptFrom");
							var rptTool=values.rptTool;
							var rowData=$("#rptGrid").datagrid("getSelected");
							if(rowData==null) {
								return;
							};
							$("#grpGrid").datagrid("load",{
								ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
								MethodName:"GetMapedGrp",
								rptTool:rptTool, 
								searchV:"",
								rptID:rowData.ID,
								wantreturnval:0
							})
						}else{
							$.messager.alert("提示",jsonData.msg);
						}
				});					
				
				
				
			}
		},{
			text:'取消',
			handler:function(){
				$('#lookupGrpDlg').dialog('close');	
			}
		}]
		
	});		
	
	var values=getFieldValues("rptFrom");
	var rptTool=values.rptTool;
	var row=$("#rptGrid").datagrid("getSelected");
	
	
	///增加报表映射datagrid
	var lookupGrpGrid = $HUI.datagrid("#lookupGrpGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"getUnMapGrp",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0,
			rptTool:rptTool,
			rptID:row.ID,
			searchV:""
		},
		fit:true,
		fitColumns:true,
		rownumbers:true,    
		columns:[[
			{field:'ck',checkbox:'true'},
			{field:'ID',title:'ID',width:100,hidden:true},
			{field:'Name',title:'名称',width:100,align:'left'},
			{field:'Code',title:'编码',width:100,align:'left'},
			{field:'Descript',title:'描述',width:100,align:'left'}			
	    ]]
		//pagination:true,
		//pageSize:500,
	    //pageList:[5,10,15,20,50,100]	
	});	
	
	$('#searchUnMapGrp').searchbox("setValue","");
	lookupGrpDlg.open();
	
	
	////////////////////////////////////////////////////////
	//
	$(function(){
		$('#searchUnMapGrp').searchbox({
			searcher:function(value){
				var values=getFieldValues("rptFrom");
				var rptTool=values.rptTool;
				var row=$("#rptGrid").datagrid("getSelected");
				$("#lookupGrpGrid").datagrid("reload",({
					ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
					MethodName:"getUnMapGrp",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
					wantreturnval:0,
					rptTool:rptTool,
					rptID:row.ID,
					searchV:value
				}))
			}
		});
	});
		
}
$(init);

//删除
init.removeRptItem=function(gridSelector,ID,funCallback) {
	$.messager.confirm("删除", "确定要删除数据吗?", function (r) { 
	if (r) { 	
		var colIndex=$(gridSelector).datagrid("getRowIndex",ID);
		$(gridSelector).datagrid("deleteRow",colIndex);
		if (funCallback!=null) {
			funCallback(ID);
		}
	}})
}
//删除
init.deleteRGMap=function(ID) {
	$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"delRGMap",
			wantreturnval:0,
			ID:ID
	},function(jsonData){
			if (jsonData.success==1) {
				var values=getFieldValues("rptFrom");
				var rowData=$("#rptGrid").datagrid("getSelected");
				
				var rptTool=values.rptTool;
				$("#RGMapGrpSearchBtn").searchbox("setValue","");
				$("#grpGrid").datagrid("load",{
					ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
					MethodName:"GetMapedGrp",
					rptTool:rptTool, 
					searchV:"",
					rptID:rowData.ID,
					wantreturnval:0
				})					
			}else{
				$.messager.alert("提示",jsonData.msg);
			}
	});

}