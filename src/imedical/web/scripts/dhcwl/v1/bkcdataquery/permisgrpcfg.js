
var init=function() {
	
	///////////////////////////////////////////////////////////////////////////////
	///组
	var grpDataGrid = $HUI.datagrid("#grpDataGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"GetGrp",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			searchV:"",
			wantreturnval:0
		},		
		idField:'ID',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Name',title:'名称',width:100,align:'left',editor:'text'},
			{field:'Code',title:'编码',width:100,align:'left'},
			{field:'Descript',title:'描述',width:100,align:'left',editor:'text'},
			{field:'action',title:'操作',width:70,align:'left',
				formatter:function(value,row,index){
					var rowdataid="\""+row.ID+"\"";		//datagrid的idField；
					var selector='"#grpDataGrid"';
					var s = "<a href='#' title='修改/结束修改' class='hisui-tooltip' ><span class='icon icon-write-order'  onclick='init.editRec("+selector+','+rowdataid+",init.editCallback)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRec("+selector+","+rowdataid+",init.deleteGrp)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
					return s;
				} 
			}
	    ]],

		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
	    
		fit:true,
		fitColumns:true,
		onAfterEdit:function(rowIndex, rowData, changes) {
			val=$.trim(rowData.Name);
			if(val == ""){
				$.messager.alert("提示","名称不能为空，没有完成修改操作！");
				$("#grpDataGrid").datagrid("reload");
				return ;
			}
			$cm({
					ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
					MethodName:"updateGrp",
					wantreturnval:0,
					ID:rowData.ID,
					Name:rowData.Name,
					Descript:rowData.Descript
				},function(jsonData){
						//$("#grpDataGrid").datagrid("reload");
						if (jsonData.success==1) {
							$("td.datagrid-value-changed").removeClass("datagrid-value-changed");

						}else{
							$.messager.alert("提示",jsonData.msg);
						}
						//$('#grpDataGrid').datagrid('refreshRow',index);
				});			
		}
	});	
	
	//查询报表
		///主界面查询响应方法
	$('#searchBtn').searchbox({
		searcher:function(value){
			$('#grpDataGrid').datagrid('load',{
				ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
				MethodName:"GetGrp",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
				searchV:value,
				wantreturnval:0
				});

		}
	})
	
}

var addGrpCfg=function(){
	$HUI.dialog("#addGrpDlg",{
		//title:'增加',
		iconCls:'icon-w-add',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false,			
		buttons:[{
			//id:'btnPrevID',
			text:'确定',
			handler:OnAddConfirm
		},{
			//id:'btnNextID',
			text:'取消',
			handler:OnAddCancel
		}]
		});	
		
		
	function OnAddConfirm() {
		//1、数据格式校验
		flag = $("#addGrpForm").form("validate");   //表单内容合法性检查
		if (!flag){
			myMsg("请按照提示填写信息");
			return;
		}
		//2、判断编码是否重复
		var values=getFieldValues("addGrpForm");
		var Code=values.Code;
		var Name=values.Name;
		var Descript=values.Descript;
		
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"InsertGrp",
			wantreturnval:0,
			/// 编码
			Code:Code,
			/// 名称
			Name:Name,
			/// 描述
			Descript:Descript

		},function(jsonData){
				if (jsonData.success==1) {
					$('#addGrpDlg').dialog('close');
					$.messager.alert("提示","操作成功！");
					$("#grpDataGrid").datagrid("reload");
				}else{
					$.messager.alert("提示",jsonData.msg);
				}
		});
	}
	
	function OnAddCancel() {
		$('#addGrpDlg').dialog('close');
	}
	
	
	setFieldValues("addGrpForm",{Code:"",Name:"",Descript:""});
	
	$('#addGrpDlg').dialog('open');	
	
	
	
}
$(init);

//移除grid中的一行记录
init.removeRec=function(gridSelector,ID,funCallback) {
		$.messager.confirm("删除", "确定要删除数据吗?", function (r) { 
		if (r) { 
				var colIndex=$(gridSelector).datagrid("getRowIndex",ID);
				$(gridSelector).datagrid("deleteRow",colIndex);
				if (funCallback!=null) {
					funCallback(ID);
				}
		}
		})
}


//删除
init.deleteGrp=function(ID) {
                                                
	$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"delGrp",
			wantreturnval:0,
			ID:ID
		},function(jsonData){
				$("#grpDataGrid").datagrid("reload");
				if (jsonData.success==1) {
				}else{
					$.messager.alert("提示",jsonData.msg);
				}
				

		});

}

init.editCallback=function(rowData) {
	/*
	var ID=rowData.ID; 
	//var index=$("#grpDataGrid").datagrid("getRowIndex",ID);                                    
	$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"updateGrp",
			wantreturnval:0,
			ID:ID,
			Name:rowData.Name,
			Descript:rowData.Descript
		},function(jsonData){
				//$("#grpDataGrid").datagrid("reload");
				if (jsonData.success==1) {
				}else{
					$.messager.alert("提示",jsonData.msg);
				}
				//$('#grpDataGrid').datagrid('refreshRow',index);
				
				

		});

	*/
}

init.editRec=function(gridSelector,ID,funCallback) {
	//alert("editItem "+inx);	
	var index=$(gridSelector).datagrid("getRowIndex",ID);
	if (init[gridSelector].editID != ID){
		if (init.endEditing(gridSelector,ID,funCallback)){
			$(gridSelector).datagrid('selectRow', index).datagrid('beginEdit', index);
			init[gridSelector].editID = ID;
		} else {
			$(gridSelector).datagrid('selectRow', index);
		}
	}
	else if (init[gridSelector].editID == ID){
		if (init.endEditing(gridSelector,ID,funCallback)){
		} else {
			$(gridSelector).datagrid('selectRow', index);
		}
	}		
};	

///结束编辑
init.endEditing=function(gridSelector,ID,funCallback){
	if (init[gridSelector].editID == undefined){return true}
	//var editIndex=$(gridSelector).datagrid("getRowIndex",ID);
	var editIndex=$(gridSelector).datagrid("getRowIndex",init[gridSelector].editID);
	if ($(gridSelector).datagrid('validateRow', editIndex)){
		$(gridSelector).datagrid('endEdit',editIndex);
		///
		var rowData=$(gridSelector).datagrid('getRows')[editIndex];
		funCallback(rowData);
		///
		init[gridSelector].editID = undefined;
		return true;                                                                                
	} else {
		return false;                                                                               
	}                                                                                             
} 

init["#grpDataGrid"]={editID:undefined};