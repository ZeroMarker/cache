var opl=opdoc.lib.ns("opdoc.recadm.config");
opl.view=(function(){
	var PatInfoShowConfigDataGrid;
	var editRow;
	function Init(){
		InitHospList();
		//LoadDataGrid();
		InitCache();
	}
	function InitHospList()
	{
		//初始化医院
		var hospComp = GenHospComp("DocCFPatientInfo");
		hospComp.jdata.options.onSelect = function(e,t){
			LoadDataGrid($("#AdmType").combobox('getValue'));
		}
		hospComp.jdata.options.onLoadSuccess= function(data){
			InitTable();
			InitAdmType();
		}
	}
	function InitCache(){
		var hasCache = $.DHCDoc.ConfigHasCache();
		if (hasCache!=1) {
			$.DHCDoc.CacheConfigPage();
			$.DHCDoc.storageConfigPageCache();
		}
	}
	function InitAdmType(){
		var cbox = $HUI.combobox("#AdmType", {
				valueField: 'id',
				textField: 'desc', 
				editable:false,
				data: [{"id":"O","desc":"门诊"},
					   {"id":"I","desc":"住院"},
					   {"id":"IE","desc":"急诊留观"},
					   {"id":"OE","desc":"急诊非留观"}],
				onSelect:function(rec){
					//加载科室列表
					if (rec) {
						LoadDataGrid(rec['id']);
					}
				},
				onLoadSuccess:function(){
					$(this).combobox('select',"O");
				}
		 });
	}
	function InitTable(){
		var Columns=[[ 
 			{field:'ID',title:'',hidden:true},
 			{field:'DisplayItem',title:'显示项目',width:80,
 				editor : {type : 'text',options : {required:true}}
 			},
 			{field:'Code',title:'显示项目编码',width:110,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'ExecuteCode',title:'执行代码',width:500,
 				editor : {type : 'text',options : {}}
 			}, 			
 			{field:'Link',title:'链接',width:200,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'Style',title:'样式',width:200,
 				editor : {type : 'text',options : {}}
 			},
 			/*{field:'DisplayNum',title:'顺序',width:50},
 			{field:'Operator',title:'操作人',width:100,},
 			{field:'OprDate',title:'操作日期',width:100,},*/
 			{field:'IsActive',title:'是否有效',width:100,
 				styler: function(value,row,index){
	 				if (value=="是"){
		 				return 'color:#21ba45;';
		 			}else{
			 			return 'color:#f16e57;';
			 		}
 				}
 			}
		 ]]
		 var toolBar=[{
	            text: '新增',
	            iconCls: 'icon-add',
	            handler: function() {
		            PatInfoShowConfigDataGrid.datagrid("rejectChanges");
                	PatInfoShowConfigDataGrid.datagrid("unselectAll");
                	PatInfoShowConfigDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    PatInfoShowConfigDataGrid.datagrid("beginEdit", 0);
                    SetRowFocus(0,"DisplayItem");
                    editRow=0;
		        }
	        },{
	            text: '删除',
	            iconCls: 'icon-cancel',
	            handler: function() {PatInfoShowConfigDel();}
	        },{
	            text: '保存',
	            iconCls: 'icon-save',
	            handler: function() {PatInfoShowConfigSave();}
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
		PatInfoShowConfigDataGrid=$("#PatInfoShowConfig").datagrid({
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
					PatInfoShowConfigDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
				}
                PatInfoShowConfigDataGrid.datagrid("beginEdit", rowIndex);
                SetRowFocus(rowIndex,"DisplayItem");
                editRow=rowIndex;
			}
		}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter})
	}
	function LoadDataGrid(AdmType){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		$.q({
			ClassName:"DHCDoc.OPDoc.PatConfigQuery",
			QueryName:"PatientInfo",
			paraAdmType:AdmType,
			HospId:HospID,
			Pagerows:PatInfoShowConfigDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			PatInfoShowConfigDataGrid.datagrid('loadData',GridData);
		});
	}
	function PatInfoShowConfigSave(){
		var editors = PatInfoShowConfigDataGrid.datagrid('getEditors', editRow);
		if (editors.length==0){
			$.messager.alert("提示","没有正在编辑的行!");
			return false;
		}
		var rows=PatInfoShowConfigDataGrid.datagrid("selectRow",editRow).datagrid("getSelected"); 
		var DisplayItem =  editors[0].target.val();
		/*if (DisplayItem==""){
			$.messager.alert("提示","显示项目不能为空!","info",function(){
				SetRowFocus(editRow,"DisplayItem");
			});
			return false;
		}*/
		var Code = editors[1].target.val();
		if (Code==""){
			$.messager.alert("提示","显示项目编码不能为空!","info",function(){
				SetRowFocus(editRow,"Code");
			});
			return false;
		}
		var ExecuteCode =  editors[2].target.val();
		if (ExecuteCode==""){
			$.messager.alert("提示","执行代码不能为空!","info",function(){
				SetRowFocus(editRow,"ExecuteCode");
			});
			return false;
		}else{
			//调用的方法中不能包含html标签
			ExecuteCode=ExecuteCode.replace(/HTML/g,"*").replace(/MAP/g,"@")
		}
		var Style =   editors[4].target.val();
		var Link=  editors[3].target.val();
		var UserID=session['LOGON.USERID'];
		var ActiveFlag=1;
		if ($.isEmptyObject(rows)){
			var ID="";
		}else{
			var ID=rows.ID;
		}
		var Str=ID+String.fromCharCode(1)+DisplayItem+String.fromCharCode(1)+Code+String.fromCharCode(1)+ExecuteCode+String.fromCharCode(1)+Style+String.fromCharCode(1)+Link+String.fromCharCode(1)+UserID;
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		$.m({
			ClassName:"DHCDoc.OPDoc.AjaxPatientInfoConfig",
			MethodName:"SavePatientInfoDisplay",
			Str:Str,
			AdmType:$("#AdmType").combobox('getValue'),
			HospId:HospID
		},function(val){
			if (val=="0"){
				LoadDataGrid($("#AdmType").combobox('getValue'));
			}else{
				$.messager.alert("提示","保存失败! "+val);
			}
		});
	}
	function PatInfoShowConfigDel(){
		var rows=PatInfoShowConfigDataGrid.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			var index=PatInfoShowConfigDataGrid.datagrid('getRowIndex',rows);
			if (index<0){
				$.messager.alert("提示","请选择需要删除的数据!");
				return false;
			}
			PatInfoShowConfigDataGrid.datagrid('deleteRow',index);
		}else{
			var ID=rows.ID;
			$.m({
				ClassName:"DHCDoc.OPDoc.AjaxPatientInfoConfig",
				MethodName:"DelPatientInfoDisplay",
				ID:ID
			},function(val){
				if (val=="0"){
					LoadDataGrid($("#AdmType").combobox('getValue'));
				}else{
					$.messager.alert("提示","删除失败! "+val);
				}
			});
		}
	}
	function IsActive(type){
		var rows=PatInfoShowConfigDataGrid.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			$.messager.alert("提示","请选择已经保存的数据修改有效标志!");
			return false;
		}else{
			var ID=rows.ID;
			var selIsActive=rows.IsActive;
			if ((type=="1")&&(selIsActive=="是")){
				$.messager.alert("提示","已经是有效状态!");
				return false;
			}
			if ((type=="0")&&(selIsActive=="否")){
				$.messager.alert("提示","已经是无效状态!");
				return false;
			}
			$.m({
				ClassName:"DHCDoc.OPDoc.AjaxPatientInfoConfig",
				MethodName:"IsActive",
				ID:ID,
				IsActive:type,
				UserID:session['LOGON.USERID']
			},function(val){
				if (val=="0"){
					if (type==0) type="否"
					if (type==1) type="是"
					var index=PatInfoShowConfigDataGrid.datagrid('getRowIndex',rows);
					PatInfoShowConfigDataGrid.datagrid('updateRow',{
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
       obj=PatInfoShowConfigDataGrid;
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
			    ClassName : "DHCDoc.OPDoc.AjaxPatientInfoConfig",
			    MethodName : "RemovePatientInfoDisplay",
			    Str:Str,
			    UserID:session['LOGON.USERID'],
			    AdmType:$("#AdmType").combobox('getValue')
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
		var ed = PatInfoShowConfigDataGrid.datagrid('getEditor', {index:index,field:field});
		$(ed.target).focus(); 
	}
	return {
		"Init":Init
	}
})();