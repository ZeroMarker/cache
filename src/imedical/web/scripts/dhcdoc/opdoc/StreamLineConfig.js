var opl=opdoc.lib.ns("opdoc.recadm.config");
opl.view=(function(){
	var StreamLineConfigDataGrid;
	var editRow;
	function Init(){
		InitHospList();
	}
	function InitHospList()
	{
		var hospComp = GenHospComp("DocCFStreamlineInfo");
		hospComp.jdata.options.onSelect = function(e,t){
			LoadDataGrid();
		}
		hospComp.jdata.options.onLoadSuccess= function(data){
			InitTable();
			LoadDataGrid();
		}
	}
	/*
	ID:%String,ItemID:%String,ItemName:%String,
	ItemClick:%String,ConditionalExpre:%String,StrLink:%String,DisplayNum:%String,Operator:%String,OprDate:%String,IsActive
	*/
	function InitTable(){
		var Columns=[[ 
 			{field:'ID',title:'',hidden:true},
 			{field:'ItemID',title:'元素ID',width:100,
 				editor : {type : 'text',options : {required:true}}
 			},
 			{field:'ItemName',title:'元素Name',width:100,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'ItemClick',title:'点击事件',width:180,
 				editor : {type : 'text',options : {}}
 			}, 			
 			{field:'ConditionalExpre',title:'条件表达式',width:200,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'PreLineClass',title:'前置样式',width:100,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'StrLink',title:'链接',width:400,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'isRefresh',title:'是否局部刷新',width:100,
 				editor : {
	 				type:'combobox',
			        options:{
				      valueField:'id',
				      textField:'des',
				      editable:false,
				      data:[{"id":"true","des":"是"},{"id":"false","des":"否"}],
			        }
	 			},
	 			formatter:function(value,record){
		 			if (value=="true") return "是";
		 			else  return "否";
		 		},styler: function(value,row,index){
	 				if (value=="true"){
		 				return 'color:#21ba45;';
		 			}else{
			 			return 'color:#f16e57;';
			 		}
 				}
 			},
 			{field:'IsActive',title:'是否有效',width:100,
 				formatter:function(value,record){
		 			if (value=="1") return "是";
		 			else  if (value=="0") return "否";
		 		},
 				styler: function(value,row,index){
	 				if (value=="1"){
		 				return 'color:#21ba45;';
		 			}else if(value=="0"){
			 			return 'color:#f16e57;';
			 		}
 				}
 			}
		 ]]
		 var toolBar=[{
	            text: '新增',
	            iconCls: 'icon-add',
	            handler: function() {
		            StreamLineConfigDataGrid.datagrid("rejectChanges");
                	StreamLineConfigDataGrid.datagrid("unselectAll");
                	StreamLineConfigDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {
	                        isRefresh:"true"
	                    }
                    });
                    StreamLineConfigDataGrid.datagrid("beginEdit", 0);
                    SetRowFocus(0,"ItemID");
                    editRow=0;
		        }
	        },{
	            text: '删除',
	            iconCls: 'icon-cancel',
	            handler: function() {StreamLineConfigDel();}
	        },{
	            text: '保存',
	            iconCls: 'icon-save',
	            handler: function() {StreamLineConfigSave();}
	        },'-', {
	            text: '有效',
	            iconCls: 'icon-ok',
	            handler: function() {IsActive("1");}
	        },{
	            text: '无效',
	            iconCls: 'icon-abort-order',
	            handler: function() { IsActive("0");}
	        },'-', {
	            iconCls: 'icon-arrow-top',
	            handler: function() {MoveSelRow("up");}
	        },{
	            iconCls: 'icon-arrow-bottom',
	            handler: function() {MoveSelRow("down");}
	        }];
		StreamLineConfigDataGrid=$("#StreamLineConfig").datagrid({
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
			pageSize: 10,
			pageList : [10,100,200],
			idField:'ID',
			columns :Columns,
			toolbar :toolBar,
			onDblClickRow:function(rowIndex, rowData){
				if (editRow!= undefined){
					StreamLineConfigDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                }
                StreamLineConfigDataGrid.datagrid("beginEdit", rowIndex);
                SetRowFocus(rowIndex,"ItemID");
                editRow=rowIndex;
			}
		})
	}
	function LoadDataGrid(){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		$.q({
			ClassName:"DHCDoc.OPDoc.PatConfigQuery",
			QueryName:"Streamline",
			HospId:HospID,
			Pagerows:StreamLineConfigDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			StreamLineConfigDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
		});
	}
	function StreamLineConfigSave(){
		var editors = StreamLineConfigDataGrid.datagrid('getEditors', editRow);
		if (editors.length==0){
			$.messager.alert("提示","没有正在编辑的行!");
			return false;
		}
		var rows=StreamLineConfigDataGrid.datagrid("selectRow",editRow).datagrid("getSelected"); 
		var ItemID =  editors[0].target.val();
		if (ItemID==""){
			$.messager.alert("提示","元素ID不能为空!","info",function(){
				SetRowFocus(editRow,"ItemID");
			});
			return false;
		}
		var ItemName = editors[1].target.val();
		if (ItemName==""){
			$.messager.alert("提示","元素Name不能为空!","info",function(){
				SetRowFocus(editRow,"ItemName");
			});
			return false;
		}
		var ItemClick =  editors[2].target.val();
		if (ItemClick==""){
			$.messager.alert("提示","点击事件不能为空!","info",function(){
				SetRowFocus(editRow,"ItemClick");
			});
			return false;
		}
		var ConditionalExpre =  editors[3].target.val();
		var PreLineClass=editors[4].target.val();
		var StrLink =  editors[5].target.val();
		if (StrLink==""){
			$.messager.alert("提示","链接不能为空!","info",function(){
				SetRowFocus(editRow,"StrLink");
			});
			return false;
		}
		var isRefresh=editors[6].target.combobox('getValue');
		var UserID=session['LOGON.USERID'];
		var ActiveFlag=1;
		if ($.isEmptyObject(rows)){
			var ID="";
			if (ID==undefined) ID="";
		}else{
			var ID=rows.ID;
			if (ID==undefined) ID="";
		}
		var Str=ID+String.fromCharCode(1)+ItemID+String.fromCharCode(1)+ItemName
			Str=Str+String.fromCharCode(1)+ItemClick+String.fromCharCode(1)+ConditionalExpre
			Str=Str+String.fromCharCode(1)+StrLink+String.fromCharCode(1)+isRefresh+String.fromCharCode(1)+UserID;
			Str=Str+String.fromCharCode(1)+PreLineClass;
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		$.m({
			ClassName:"DHCDoc.OPDoc.AjaxStreamlineConfig",
			MethodName:"SaveStreamlineConfig",
			Str:Str,
			_headers:{"X_ACCEPT_TAG":1},
			HospId:HospID
		},function(val){
			if (val=="0"){
				LoadDataGrid();
			}else{
				$.messager.alert("提示","保存失败! "+val);
			}
		});
	}
	function StreamLineConfigDel(){
		var rows=StreamLineConfigDataGrid.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			var index=StreamLineConfigDataGrid.datagrid('getRowIndex',rows);
			if (index<0){
				$.messager.alert("提示","请选择需要删除的数据!");
				return false;
			}
			PatInfoShowConfigDataGrid.datagrid('deleteRow',index);
		}else{
			var ID=rows.ID;
			$.m({
				ClassName:"DHCDoc.OPDoc.AjaxStreamlineConfig",
				MethodName:"DelStreamlineConfig",
				ID:ID
			},function(val){
				if (val=="0"){
					LoadDataGrid();
				}else{
					$.messager.alert("提示","删除失败! "+val);
				}
			});
		}
	}
	function IsActive(type){
		var rows=StreamLineConfigDataGrid.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			$.messager.alert("提示","请选择已经保存的数据修改有效标志!");
			return false;
		}else{
			var ID=rows.ID;
			var selIsActive=rows.IsActive;
			if ((type=="1")&&(selIsActive=="1")){
				$.messager.alert("提示","已经是有效状态!");
				return false;
			}
			if ((type=="0")&&(selIsActive=="0")){
				$.messager.alert("提示","已经是无效状态!");
				return false;
			}
			$.m({
				ClassName:"DHCDoc.OPDoc.AjaxStreamlineConfig",
				MethodName:"IsActive",
				ID:ID,
				IsActive:type,
				UserID:session['LOGON.USERID']
			},function(val){
				if (val=="0"){
					var index=StreamLineConfigDataGrid.datagrid('getRowIndex',rows);
					StreamLineConfigDataGrid.datagrid('updateRow',{
						index: index,
						row: {
							IsActive: type
						}
					});
				}else{
					$.messager.alert("提示","置有效失败! "+val);
				}
			});
		}
	}
   function MoveSelRow(type){
	   var obj = new Object();
       obj=StreamLineConfigDataGrid;
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
			    ClassName : "DHCDoc.OPDoc.AjaxStreamlineConfig",
			    MethodName : "RemoveStreamlineDisplay",
			    Str:Str,
			    UserID:session['LOGON.USERID']
			},function(val){
			    
			}); 
		}else{
			$.messager.alert("提示","请选择需要进行移动的记录!");
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
		var ed = StreamLineConfigDataGrid.datagrid('getEditor', {index:index,field:field});
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
				dg.datagrid('scrollTo',0); //滚动到指定的行        
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