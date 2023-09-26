var opl=opdoc.lib.ns("opdoc.recadm.config");
opl.view=(function(){
	var printconfigtableDataGrid;
	var editRow;
	var pIdData="";
	function Init(){
		InitHospList();
	}
	function InitHospList()
	{
		var hospComp = GenHospComp("DocCFTreatPrintMainInfo");
		hospComp.jdata.options.onSelect = function(e,t){
			LoadData();
		}
		hospComp.jdata.options.onLoadSuccess= function(data){
			LoadData();
		}
	}
	function LoadData(){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		$.m({
			ClassName:"DHCDoc.OPDoc.AjaxTreatPrintConfigMain",
			MethodName:"GetTreatPIdConfigData",
			HospId:HospID,
			ResultSetType:"array"
		},function(txtData){ //id des
			pIdData=eval("("+txtData+")");
			InitTable();
			LoadDataGrid();
		});
	}
	function InitTable(){
		var Columns=[[ 
 			{field:'id',title:'',hidden:true},
 			{field:'pId',title:'父目录',width:150,
 				editor : {
	 				type:'combobox',
			        options:{
				      valueField:'id',
				      textField:'des',
				      editable:false,
				      data:pIdData,
			        }
	 			},
	 			formatter:function(value, record){
		 			return record.pName
		 		}
 			},
 			{field:'pName',title:'pName',width:100,hidden:true}, 			
 			{field:'name',title:'目录名称',width:100,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'eleId',title:'元素ID',width:80,
 				editor : {type : 'text',options : {}}
 			}, 			
 			{field:'value',title:'值',width:50,
 				editor : {type : 'text',options : {}}
 			},
 			/*{field:'displaynum',title:'显示顺序',width:80,
 				editor : {type : 'text',options : {}}
 			},*/
 			{field:'nocheck',title:'有无复选框',width:100,
 				editor : {
	 				type:'combobox',
			        options:{
				      valueField:'id',
				      textField:'des',
				      editable:false,
				      data:[{"id":"1","des":"有"},{"id":"0","des":"无"}],
			        }
	 			},
	 			formatter:function(value,record){
		 			if (value=="1") return "有";
		 			else  return "无";
		 		},styler: function(value,row,index){
	 				if (value=="1"){
		 				return 'color:#21ba45;';
		 			}else {
			 			return 'color:#f16e57;';
			 		}
 				}
 			},
 			{field:'checked',title:'是否默认选中',width:100,
 				editor : {
	 				type:'combobox',
			        options:{
				      valueField:'id',
				      textField:'des',
				      editable:false,
				      data:[{"id":"1","des":"是"},{"id":"0","des":"否"}],
			        }
	 			},
	 			formatter:function(value,record){
		 			if (value=="1") return "是";
		 			else  return "否";
		 		},styler: function(value,row,index){
	 				if (value=="1"){
		 				return 'color:#21ba45;';
		 			}else {
			 			return 'color:#f16e57;';
			 		}
 				}
 			},
 			{field:'open',title:'是否展开',width:80,
 				editor : {
	 				type:'combobox',
			        options:{
				      valueField:'id',
				      textField:'des',
				      editable:false,
				      data:[{"id":"1","des":"是"},{"id":"0","des":"否"}],
			        }
	 			},
	 			formatter:function(value,record){
		 			if (value=="1") return "是";
		 			else  return "否";
		 		},
 				styler: function(value,row,index){
	 				if (value=="1"){
		 				return 'color:#21ba45;';
		 			}else {
			 			return 'color:#f16e57;';
			 		}
 				}
 			},
 			{field:'expandMethodForLoadingTable',title:'展开事件',width:100,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'issendmessage',title:'未打印是否在接诊后提示',width:100,
 				editor : {
	 				type:'combobox',
			        options:{
				      valueField:'id',
				      textField:'des',
				      editable:false,
				      data:[{"id":"1","des":"提示"},{"id":"0","des":"不提示"}],
			        }
	 			},
	 			formatter:function(value,record){
		 			if (value=="1") return "提示";
		 			else  return "不提示";
		 		}
 			},
 			{field:'icon',title:'图标样式',width:150,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'fontstyle',title:'字体样式',width:150,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'clickevent',title:'点击事件',width:150,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'urlObject',title:'链接',width:150,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'urlStyle',title:'链接类型',width:150,
 				editor : {
	 				type:'combobox',
			        options:{
				      valueField:'id',
				      textField:'des',
				      editable:false,
				      data:[{"id":"iframe","des":"iframe"},{"id":"代码段","des":"代码段"}],
			        }
	 			},
	 			formatter:function(value,record){
		 			if (value=="iframe") return "iframe";
		 			else if(value=="代码段")  return "代码段";
		 			else return "";
		 		}
 			},
 			{field:'iconExpression',title:'条件表达式',width:150,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'previewxmlname',title:'预览文件名称',width:200,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'printmethod',title:'打印方法',width:600,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'isactive',title:'是否有效',width:80,
 				formatter:function(value,record){
		 			if (value==true) return "是";
		 			else  if (value==false) return "否";
		 		},
 				styler: function(value,row,index){
	 				if (value==true){
		 				return 'color:#21ba45;';
		 			}else if(value==false){
			 			return 'color:#f16e57;';
			 		}
 				}
 			},
		 ]]
		 var toolBar=[{
	            text: '新增',
	            iconCls: 'icon-add',
	            handler: function() {
		            printconfigtableDataGrid.datagrid("rejectChanges");
                	printconfigtableDataGrid.datagrid("unselectAll");
                	printconfigtableDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {
	                        pId:"0",
	                        nocheck:0,
	                        checked:0,
	                        open:0,
	                        issendmessage:0
	                        
	                    }
                    });
                    printconfigtableDataGrid.datagrid("beginEdit", 0);
                    SetRowFocus(0,"name");
                    editRow=0;
		        }
	        },{
	            text: '保存',
	            iconCls: 'icon-save',
	            handler: function() {PrintConfigSave();}
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
		printconfigtableDataGrid=$("#printconfigtable").datagrid({
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
			idField:'id',
			columns :Columns,
			toolbar :toolBar,
			onDblClickRow:function(rowIndex, rowData){
				if (editRow!= undefined){
					printconfigtableDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                }
                printconfigtableDataGrid.datagrid("beginEdit", rowIndex);
                SetRowFocus(rowIndex,"name");
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
			ClassName:"DHCDoc.OPDoc.TreatPrintConfigQuery",
			QueryName:"TreatPrintConfig",
			ActiveOrNo:"",
			HospId:HospID,
			Pagerows:printconfigtableDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			editRow=undefined;
			printconfigtableDataGrid.datagrid("unselectAll");
			printconfigtableDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
		});
	}
	function PrintConfigSave(){
		var editors = printconfigtableDataGrid.datagrid('getEditors', editRow);
		if (editors.length==0){
			$.messager.alert("提示","没有正在编辑的行!");
			return false;
		}
		var rows=printconfigtableDataGrid.datagrid("selectRow",editRow).datagrid("getSelected"); 
		
		var pId= editors[0].target.combobox('getValue');
		var name =  editors[1].target.val();
		if (name==""){
			$.messager.alert("提示","目录名称不能为空!","info",function(){
				SetRowFocus(editRow,"name");
			});
			return false;
		}
		var eleId=editors[2].target.val();
		var value=editors[3].target.val();
		var nocheck=editors[4].target.combobox('getValue');
		var checked=editors[5].target.combobox('getValue');
		var open=editors[6].target.combobox('getValue');
		var expandMethodForLoadingTable=editors[7].target.val();
		var issendmessage=editors[8].target.combobox('getValue');
		var icon=editors[9].target.val();
		var fontstyle=editors[10].target.val();
		var clickevent=editors[11].target.val();
		var urlObject=editors[12].target.val();
		var urlStyle=editors[13].target.combobox('getValue');
		// 传入的参数中不支持iframe,会被认为是不安全的
		if (urlStyle=="iframe") urlStyle="iframe_1"
		var iconExpression=editors[14].target.val();
		var previewxmlname=editors[15].target.val();
		var printmethod=editors[16].target.val();
		if ($.isEmptyObject(rows)){
			var ID="";
		}else{
			var ID=rows.id;
			if (ID==undefined) ID="";
		}
		var Str=ID+String.fromCharCode(1)+pId+String.fromCharCode(1)+name+String.fromCharCode(1)+eleId+String.fromCharCode(1)+value;
		Str=Str+String.fromCharCode(1)+nocheck+String.fromCharCode(1)+checked;
		Str=Str+String.fromCharCode(1)+open+String.fromCharCode(1)+expandMethodForLoadingTable;
		Str=Str+String.fromCharCode(1)+issendmessage+String.fromCharCode(1)+icon;
		Str=Str+String.fromCharCode(1)+fontstyle+String.fromCharCode(1)+clickevent;
		Str=Str+String.fromCharCode(1)+urlObject+String.fromCharCode(1)+urlStyle;
		Str=Str+String.fromCharCode(1)+iconExpression+String.fromCharCode(1)+previewxmlname+String.fromCharCode(1)+printmethod;
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		$.m({
			ClassName:"DHCDoc.OPDoc.AjaxTreatPrintConfigMain",
			MethodName:"SaveTreatPrintConfigData",
			Str:Str,
			HospId:HospID
		},function(val){
			if (val=="0"){
				LoadDataGrid();
			}else{
				$.messager.alert("提示","保存失败! "+val);
			}
		});
	}
	function IsActive(type){
		var rows=printconfigtableDataGrid.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			$.messager.alert("提示","请选择已经保存的数据修改有效标志!");
			return false;
		}else{
			var ID=rows.id;
			var selIsActive=rows.isactive;
			if ((type=="1")&&(selIsActive=="1")){
				$.messager.alert("提示","已经是有效状态!");
				return false;
			}
			if ((type=="0")&&(selIsActive=="0")){
				$.messager.alert("提示","已经是有效状态!");
				return false;
			}
			$.m({
				ClassName:"DHCDoc.OPDoc.AjaxTreatPrintConfigMain",
				MethodName:"IsActive",
				ID:ID,
				IsActive:type
			},function(val){
				if (val=="0"){
					if (type=="1") type="是";
					else type="否";
					var index=printconfigtableDataGrid.datagrid('getRowIndex',rows);
					printconfigtableDataGrid.datagrid('updateRow',{
						index: index,
						row: {
							isactive: type
						}
					});
				}else{
					$.messager.alert("提示","修改失败! "+val);
				}
			});
		}
	}
   function MoveSelRow(type){
	   var obj = new Object();
       obj=printconfigtableDataGrid;
	   var sel=obj.datagrid("getSelected");
		if (sel){
			MoveRow(obj,type);
			var pageNumber=obj.datagrid('options').pageNumber;
			var pageSize=obj.datagrid('options').pageSize;
			var StartIndex=(pageNumber-1)*pageSize+1;
		    var Str="";
		    var data = obj.datagrid('getData');
		    for (var i=0;i<data.rows.length;i++){
			    var ID=data.rows[i].id;
			    var index=obj.datagrid('getRowIndex',ID);
			    if (Str=="") Str=ID+String.fromCharCode(1)+(StartIndex+index);
			    else Str=Str+"^"+ID+String.fromCharCode(1)+(StartIndex+index);
			}
			if (Str==""){
				return false;
			}
		    $.m({
			    ClassName : "DHCDoc.OPDoc.AjaxTreatPrintConfigMain",
			    MethodName : "RemoveTreatPrintConfigData",
			    Str:Str
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
		var ed = printconfigtableDataGrid.datagrid('getEditor', {index:index,field:field});
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