var opl=opdoc.lib.ns("opdoc.recadm.config");
opl.view=(function(){
	var EMRInfoShowConfigDataGrid;
	var editRow;
	function Init(){
		InitTable();
		LoadDataGrid();
	}
	function InitTable(){
		/*
		�ӿ���������ʾ��������ʾ���ݣ�ִ�д��룩������ģ�飬ģ������ʾ˳���Ƿ���Ч
		*/
		var Columns=[[ 
 			{field:'ID',title:'',hidden:true},
 			{field:'DisplayItem',title:'��ʾ����',width:150,
 				editor : {type : 'text',options : {required:true}}
 			},
 			{field:'ExecuteCode',title:'��ʾ����(ִ�д���)',width:500,
 				editor : {type : 'text',options : {required:true}}
 			},
 			/*{field:'DisplayNum',title:'��ʾ˳��',width:500
 			}, 	*/		
 			{field:'IsActive',title:'�Ƿ���Ч',width:100}
		 ]]
		 var toolBar=[{
	            text: '����',
	            iconCls: 'icon-add',
	            handler: function() {
		            EMRInfoShowConfigDataGrid.datagrid("rejectChanges");
                	EMRInfoShowConfigDataGrid.datagrid("unselectAll");
                	EMRInfoShowConfigDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    EMRInfoShowConfigDataGrid.datagrid("beginEdit", 0);
                    SetRowFocus(0,"DisplayItem");
                    editRow=0;
		        }
	        },'-', {
	            text: 'ɾ��',
	            iconCls: 'icon-remove',
	            handler: function() {EMRInfoShowConfigDel();}
	        },'-',{
	            text: '����',
	            iconCls: 'icon-save',
	            handler: function() {EMRInfoShowConfigSave();}
	        },'-', {
	            text: '��Ч',
	            iconCls: 'icon-ok',
	            handler: function() {IsActive("1");}
	        },'-', {
	            text: '��Ч',
	            iconCls: 'icon-abort-order',
	            handler: function() { IsActive("0");}
	        },'-', {
	            iconCls: 'icon-arrow-top',
	            handler: function() {MoveSelRow("up");}
	        },'-', {
	            iconCls: 'icon-arrow-bottom',
	            handler: function() {MoveSelRow("down");}
	        }];
		EMRInfoShowConfigDataGrid=$("#EMRInfoShowConfig").datagrid({
			fit : true,
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : false,
			autoRowHeight : false,
			autoSizeColumn : false,
			rownumbers:true,
			pagination : true,  //
			rownumbers : true,  //
			pageSize: 15,
			pageList : [15,100,200],
			idField:'ID',
			columns :Columns,
			toolbar :toolBar,
			onDblClickRow:function(rowIndex, rowData){
				EMRInfoShowConfigDataGrid.datagrid("rejectChanges");
                EMRInfoShowConfigDataGrid.datagrid("unselectAll");
                EMRInfoShowConfigDataGrid.datagrid("beginEdit", rowIndex);
                SetRowFocus(rowIndex,"DisplayItem");
                editRow=rowIndex;
			}
		})
	}
	function LoadDataGrid(){
		$.q({
			ClassName:"DHCDoc.OPDoc.PatConfigQuery",
			QueryName:"EMRInfo",
			Pagerows:EMRInfoShowConfigDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			EMRInfoShowConfigDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
		});
	}
	function EMRInfoShowConfigSave(){
		var rows=EMRInfoShowConfigDataGrid.datagrid("selectRow",editRow).datagrid("getSelected"); 
		var editors = EMRInfoShowConfigDataGrid.datagrid('getEditors', editRow);
		var DisplayItem =  editors[0].target.val();
		if (DisplayItem==""){
			$.messager.alert("��ʾ","��ʾ��������Ϊ��!","info",function(){
				SetRowFocus(editRow,"DisplayItem");
			});
			return false;
		}
		var ExecuteCode =  editors[1].target.val();
		if (ExecuteCode==""){
			$.messager.alert("��ʾ","ִ�д��벻��Ϊ��!","info",function(){
				SetRowFocus(editRow,"ExecuteCode");
			});
			return false;
		}
		if ($.isEmptyObject(rows)){
			var ID="";
		}else{
			var ID=rows.ID;
		}
		var Str=ID+String.fromCharCode(1)+DisplayItem+String.fromCharCode(1)+ExecuteCode;
		$.m({
			ClassName:"DHCDoc.OPDoc.PatConfigQuery",
			MethodName:"SaveEMRInfoDisplay",
			Str:Str
		},function(val){
			if (val=="0"){
				LoadDataGrid();
			}else{
				$.messager.alert("��ʾ","����ʧ��! "+val);
			}
		});
	}
	function EMRInfoShowConfigDel(){
		var rows=EMRInfoShowConfigDataGrid.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			var index=EMRInfoShowConfigDataGrid.datagrid('getRowIndex',rows);
			if (index<0){
				$.messager.alert("��ʾ","��ѡ����Ҫɾ��������!");
				return false;
			}
			EMRInfoShowConfigDataGrid.datagrid('deleteRow',index);
		}else{
			var ID=rows.ID;
			$.m({
				ClassName:"DHCDoc.OPDoc.PatConfigQuery",
				MethodName:"DelEMRInfoDisplay",
				ID:ID
			},function(val){
				if (val=="0"){
					LoadDataGrid();
				}else{
					$.messager.alert("��ʾ","ɾ��ʧ��! "+val);
				}
			});
		}
	}
	function IsActive(type){
		var rows=EMRInfoShowConfigDataGrid.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			$.messager.alert("��ʾ","��ѡ���Ѿ�����������޸���Ч��־!");
			return false;
		}else{
			var ID=rows.ID;
			var selIsActive=rows.IsActive;
			if ((type=="1")&&(selIsActive=="1")){
				$.messager.alert("��ʾ","�Ѿ�����Ч״̬!");
				return false;
			}
			if ((type=="0")&&(selIsActive=="0")){
				$.messager.alert("��ʾ","�Ѿ�����Ч״̬!");
				return false;
			}
			$.m({
				ClassName:"DHCDoc.OPDoc.PatConfigQuery",
				MethodName:"IsActive",
				ID:ID,
				IsActive:type
			},function(val){
				if (val=="0"){
					var index=EMRInfoShowConfigDataGrid.datagrid('getRowIndex',rows);
					EMRInfoShowConfigDataGrid.datagrid('updateRow',{
						index: index,
						row: {
							IsActive: type
						}
					});
				}else{
					$.messager.alert("��ʾ","����Чʧ��! "+val);
				}
			});
		}
	}
   function MoveSelRow(type){
	   var obj = new Object();
       obj=EMRInfoShowConfigDataGrid;
	   var sel=obj.datagrid("getSelected");
		if (sel){
			MoveRow(obj,type);
			var pageNumber=obj.datagrid('options').pageNumber;
			var pageSize=obj.datagrid('options').pageSize;
			var StartIndex=(pageNumber-1)*pageSize+1;
		    var Str="";
		    var data = obj.datagrid('getData');
		    for (var i=0;i<data.rows.length;i++){
			    var ID=data.rows[i].ID;
			    var index=obj.datagrid('getRowIndex',ID);
			    if (Str=="") Str=ID+String.fromCharCode(1)+(StartIndex+index);
			    else Str=Str+"^"+ID+String.fromCharCode(1)+(StartIndex+index);
			}
			if (Str==""){
				return false;
			}
		    $.m({
			    ClassName : "DHCDoc.OPDoc.PatConfigQuery",
			    MethodName : "RemoveEMRInfoDisplay",
			    Str:Str
			},function(val){
			    
			}); 
		}else{
			$.messager.alert("��ʾ","��ѡ����Ҫ�����ƶ��ļ�¼!");
			return false;
		}
	}
    function MoveRow(obj,type){
		var sel=obj.datagrid("getSelected");
		var index = obj.datagrid('getRowIndex', sel);
		if ("up" == type) {
	        if (index != 0) {
	            var toup = obj.datagrid('getData').rows[index];
	            var todown = obj.datagrid('getData').rows[index - 1];
	            obj.datagrid('getData').rows[index] = todown;
	            obj.datagrid('getData').rows[index - 1] = toup;
	            obj.datagrid('refreshRow', index);
	            obj.datagrid('refreshRow', index - 1);
	            obj.datagrid('selectRow', index - 1);
	        }
	    } else if ("down" == type) {
	        var rows = obj.datagrid('getRows').length;
	        if (index != rows - 1) {
	            var todown = obj.datagrid('getData').rows[index];
	            var toup = obj.datagrid('getData').rows[index + 1];
	            obj.datagrid('getData').rows[index + 1] = todown;
	            obj.datagrid('getData').rows[index] = toup;
	            obj.datagrid('refreshRow', index);
	            obj.datagrid('refreshRow', index + 1);
	            obj.datagrid('selectRow', index + 1);
	        }
	    }
	}

	function SetRowFocus(index,field){
		var ed = EMRInfoShowConfigDataGrid.datagrid('getEditor', {index:index,field:field});
		$(ed.target).focus(); 
	}
	function pagerFilter(data){
		if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
			data = {
				total: data.length,
				rows: data
			}
		}
		var dg = $(this);
		var opts = dg.datagrid('options');
		var pager = dg.datagrid('getPager');
		pager.pagination({
			showRefresh:false,
			onSelectPage:function(pageNum, pageSize){
				opts.pageNumber = pageNum;
				opts.pageSize = pageSize;
				pager.pagination('refresh',{
					pageNumber:pageNum,
					pageSize:pageSize
				});
				dg.datagrid('loadData',data);
				dg.datagrid('scrollTo',0); //������ָ������        
			}
		});
		if (!data.originalRows){
			data.originalRows = (data.rows);
		}
		var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
		var end = start + parseInt(opts.pageSize);
		data.rows = (data.originalRows.slice(start, end));
		return data;
	}
	return {
		"Init":Init
	}
})();