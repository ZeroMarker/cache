var PageLogicObj={
	m_ItemDefaultListTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
});
function InitEvent(){
	//$("#BFind").click(ItemDefaultListTabDataGridLoad);
	//$("#BStop").click(StopClick);
}
function PageHandle(){
	ItemDefaultListTabDataGridLoad();
}
function Init(){
	PageLogicObj.m_ItemDefaultListTabDataGrid=InitItemDefaultListTabDataGrid();
}
$(document).keydown(function(e) {
	e = window.event || e || e.which;
	if (e.which == 27) {
		websys_showModal("close");
	}
})
function InitItemDefaultListTabDataGrid(){
	var toolbar=[{
		text:"确定",
		iconCls: 'icon-ok',
		handler: function(){
			var row=PageLogicObj.m_ItemDefaultListTabDataGrid.datagrid('getSelected');
			if (websys_showModal("options").CallBackFunc) {
				websys_showModal("options").CallBackFunc(row['Rowid']);
			}else{
				window.returnValue=row['Rowid'];
	     		window.close();
			}
		}
	}]
	var Columns=[[ 
		//{field:'Rowid',checkbox:true,width:400},
		{field:'ArcimDesc',title:'科室',width:200},
		{field:'ContralType',title:'控制范围',width:70},
		{field:'ContralDesc',title:'医生科室',width:100},
		{field:'Priority',title:'医嘱类型',width:70},
		{field:'Dose',title:'单次剂量',width:60},
		{field:'DoseUom',title:'剂量单位',width:70},
		{field:'Instr',title:'用法',width:70},
		{field:'PHFreq',title:'频次',width:70},
		{field:'Durat',title:'疗程',width:70},
		{field:'SkinTest',title:'皮试',width:50,align:'center',
			editor:{
				type:'icheckbox',options:{on:'on',off:'',disabled:true}
			}
		},
		{field:'SkinAction',title:'皮试备注',width:70},
		//{field:'RelevanceNo',title:'关联ID',width:50},
		{field:'PackQty',title:'医嘱数量',width:50}
    ]]
	var ItemDefaultListTabDataGrid=$("#ItemDefaultListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		rownumbers:false,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'Rowid',
		columns :Columns,
		toolbar:toolbar,
		onSelect:function(index, row){
		},
		onDblClickRow:function(index, row){
			if (websys_showModal("options").CallBackFunc) {
				websys_showModal("options").CallBackFunc(row['Rowid']);
			}else{
				window.returnValue=row['Rowid'];
	     		window.close();
			}
		},onLoadSuccess:function(data){
			if(data["rows"].length>0){
				//默认选中第一行
				$(this).datagrid('checkRow', 0);  
				//设置焦点,否则在选中第一行后监听不到上下键事件
				$("#ItemDefaultListTab").datagrid('getPanel').panel('panel').focus();
				for (var i=0;i<data['rows'].length;i++){
					PageLogicObj.m_ItemDefaultListTabDataGrid.datagrid('beginEdit',i);
				}
			}
		}
	}).datagrid("keyCtr"); ;
	return ItemDefaultListTabDataGrid;
}

function ItemDefaultListTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCDocItemDefault",
	    QueryName : "FindByARCIIM",
	    OrderRowid:ServerObj.OrderRowid, UserID:ServerObj.UserID, LogonLocDr:ServerObj.LogonLocDr,
	    Pagerows:PageLogicObj.m_ItemDefaultListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ItemDefaultListTabDataGrid.datagrid('loadData',GridData);
	})
}
$.extend($.fn.datagrid.methods,{
	keyCtr : function (jq) {
	    return jq.each(function () {
	        var grid = $(this);
	        grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
		    	switch (e.keyCode) {
			    	case 13:
			    	  var row=PageLogicObj.m_ItemDefaultListTabDataGrid.datagrid('getSelected');
				      if (websys_showModal("options").CallBackFunc) {
						 websys_showModal("options").CallBackFunc(row['Rowid']);
					  }else{
						 window.returnValue=row['Rowid'];
				     	 window.close();
					  }
			    	  break;
		            case 38: // up
		                var Selections = grid.datagrid('getSelections');
		                var rows = grid.datagrid('getRows');
		                if (Selections.length>0) {
			                var MaxSelection=null,MinSelection=null;
			                var opts=grid.datagrid('options');
				            $.each(Selections,function(Index,RowData){
				            	if (RowData==null){return true;}
				            	if (RowData[opts.idField]==""){return true;}
				            	if (MaxSelection==null){
				            		MaxSelection=RowData;
				            	}
				            	if (MinSelection==null){
				            		MinSelection=RowData;
				            	}
								var RowIndex=grid.datagrid('getRowIndex',RowData.OrderId);
								var Maxindex=grid.datagrid('getRowIndex',MaxSelection.OrderId);
								var Minindex=grid.datagrid('getRowIndex',MinSelection.OrderId);
								if (Maxindex<RowIndex){
									MaxSelection=RowData;
								}
								if (Minindex>RowIndex){
									MinSelection=RowData;
								}
							});
							if (MinSelection==null){
								var Rows=grid.datagrid('getRows');
								for (var i=Rows.length-1;i>=0;i--) {
									if (Rows[i][opts.idField]!=""){
										MinSelection=Rows[i];
										break;
									}
								}
								var NextIndex=grid.datagrid('getRowIndex', MinSelection);
								var index=NextIndex+1;
							}else{
								var index = grid.datagrid('getRowIndex', MinSelection);
		                    	var NextIndex=index-1;
							}
		                    if (NextIndex<0){
			                	NextIndex=rows.length - 1;
			                }
		                    grid.datagrid('unselectRow',index).datagrid('selectRow', NextIndex);
		                } else {
		                    grid.datagrid('selectRow', rows.length - 1);
		                }
		                break;
		            case 40: // down
		                var Selections = grid.datagrid('getSelections');
		                var rows = grid.datagrid('getRows');
		                if (Selections.length>0) {
		                	var MaxSelection=null,MinSelection=null;
			                var opts=grid.datagrid('options')
				            $.each(Selections,function(Index,RowData){
				            	if (RowData==null){return true;}
				            	if (RowData[opts.idField]==""){return true;}
				            	if (MaxSelection==null){
				            		MaxSelection=RowData;
				            	}
				            	if (MinSelection==null){
				            		MinSelection=RowData;
				            	}
								var RowIndex=grid.datagrid('getRowIndex',RowData.OrderId);
								var Maxindex=grid.datagrid('getRowIndex',MaxSelection.OrderId);
								var Minindex=grid.datagrid('getRowIndex',MinSelection.OrderId);
								if (Maxindex<RowIndex){
									MaxSelection=RowData;
								}
								if (Minindex>RowIndex){
									MinSelection=RowData;
								}
							});
							if (MaxSelection==null){
								grid.datagrid('uncheckAll');
								grid.datagrid('selectRow', 0);
							}else{
			                    var index = grid.datagrid('getRowIndex', MaxSelection);
			                    var NextIndex=index+1;
			                    if (NextIndex>=rows.length){
				                	NextIndex=0;
				                }
				                grid.datagrid('unselectRow',index).datagrid('selectRow', NextIndex);
			                }
		                    
		                } else {
		                    grid.datagrid('selectRow', 0);
		                }
		                break;
		    	}
	    	});
		});
	}
});