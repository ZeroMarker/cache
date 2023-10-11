var opl=opdoc.lib.ns("opdoc.recadm.config");
opl.view=(function(){
	var DataGrid1,DataGrid2;
	var editRow1,editRow2;
	function Init(){
		InitHospList();
		InitCache();
	}
	function InitHospList()
	{
		var hospComp = GenHospComp("DocCFTreatStatusMainInfo");
		hospComp.jdata.options.onSelect = function(e,t){
			LoadDataGrid1();
			if (DataGrid2) {
				DataGrid2.datagrid('loadData',{"total":0,"rows":[]});
				InitRecAdmDefShwoBtnCount();
			}
		}
		hospComp.jdata.options.onLoadSuccess= function(data){
			InitTable1();
			LoadDataGrid1();
		}
	}
	function InitTable1(){
		var Columns=[[ 
 			{field:'RowId',title:'',hidden:true},
 			{field:'CSPname',title:'CSP����',width:200,
 				editor : {type : 'text',options : {required:true}}
 			},
 			{field:'DefiDesc',title:'����',width:200,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'IsActive',title:'�Ƿ���Ч',width:150,
 				formatter:function(value,record){
		 			if (value=="1") return "��";
		 			else  if (value=="0") return "��";
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
	            text: '����',
	            iconCls: 'icon-add',
	            handler: function() {
		            DataGrid1.datagrid("rejectChanges");
                	DataGrid1.datagrid("unselectAll");
                	DataGrid1.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    DataGrid1.datagrid("beginEdit", 0);
                    SetRowFocus(DataGrid1,0,"CSPname");
                    editRow1=0;
		        }
	        },{
	            text: 'ɾ��',
	            iconCls: 'icon-cancel',
	            handler: function() {DataGrid1Del();}
	        },{
	            text: '����',
	            iconCls: 'icon-save',
	            handler: function() {DataGrid1Save();}
	        },'-', {
	            text: '��Ч',
	            iconCls: 'icon-ok',
	            handler: function() {IsActive1("1");}
	        },{
	            text: '��Ч',
	            iconCls: 'icon-abort-order',
	            handler: function() { IsActive1("0");}
	        }];
		DataGrid1=$("#pattable1").datagrid({
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
			idField:'RowId',
			columns :Columns,
			toolbar :toolBar,
			onDblClickRow:function(rowIndex, rowData){
				if (editRow1!= undefined){
					DataGrid1.datagrid("rejectChanges").datagrid("unselectAll");
                }
                DataGrid1.datagrid("beginEdit", rowIndex);
                SetRowFocus(DataGrid1,rowIndex,"CSPname");
                editRow1=rowIndex;
			},
			onClickRow:function(rowIndex, rowData){
				if (DataGrid2==undefined){
					InitTable2();
				}
				var len=$("#RecAdmDefShwoBtnCount-div").length;
				if (rowData.CSPname=="opdoc.outpatrecadm.csp") {
					if (len==0) {
						$($('.datagrid-toolbar table tbody tr')[1]).append('<td id="RecAdmDefShwoBtnCount-div"><div class="datagrid-btn-separator"></div></td><td><label style="padding:0 5px;">Ĭ����ʾ��ť��</label></td><td><input class="hisui-combobox textbox" id="RecAdmDefShwoBtnCount"/><td><label style="color:red;">(ѡ�񼴿ɱ���)</label></td></td>');
						InitRecAdmDefShwoBtnCount();
					}else{
						$("#RecAdmDefShwoBtnCount-div").show();
						$("#RecAdmDefShwoBtnCount-div").nextAll().show();
					}
				}else{
					if (len==1) {
						$("#RecAdmDefShwoBtnCount-div").hide();
						$("#RecAdmDefShwoBtnCount-div").nextAll().hide();
					}
				}
				LoadDataGrid2(rowData.CSPname);
			}
		})
	}
	function LoadDataGrid1(){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		$.q({
			ClassName:"DHCDoc.OPDoc.TreatStatusConfigQuery",
			QueryName:"TreatStatusConfigMain",
			HospId:HospID,
			Pagerows:DataGrid1.datagrid("options").pageSize,rows:99999
		},function(GridData){
			DataGrid1.datagrid("unselectAll");
			DataGrid1.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		});
	}
	function DataGrid1Del(){
		var rows=DataGrid1.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			var index=DataGrid1.datagrid('getRowIndex',rows);
			if (index<0){
				$.messager.alert("��ʾ","��ѡ����Ҫɾ��������!");
				return false;
			}
			DataGrid1.datagrid('deleteRow',index);
		}else{
			var ID=rows.RowId;
			$.m({
				ClassName:"DHCDoc.OPDoc.AjaxTreatStatusConfigMain",
				MethodName:"DelConfigData",
				ID:ID
			},function(val){
				if (val=="0"){
					LoadDataGrid1();
				}else{
					$.messager.alert("��ʾ","ɾ��ʧ��! "+val);
				}
			});
		}
	}
	function DataGrid2Del(){
		var rows=DataGrid2.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			var index=DataGrid2.datagrid('getRowIndex',rows);
			if (index<0){
				$.messager.alert("��ʾ","��ѡ����Ҫɾ��������!");
				return false;
			}
			DataGrid2.datagrid('deleteRow',index);
		}else{
			var ID=rows.RowId;
			$.m({
				ClassName:"DHCDoc.OPDoc.AjaxTreatStatusConfig",
				MethodName:"DelTreatStatusConfigData",
				ID:ID
			},function(val){
				if (val=="0"){
					LoadDataGrid2(rows.CSPname);
				}else{
					$.messager.alert("��ʾ","ɾ��ʧ��! "+val);
				}
			});
		}
	}
	function DataGrid1Save(){
		var editors = DataGrid1.datagrid('getEditors', editRow1);
		if (editors.length==0){
			$.messager.alert("��ʾ","û�����ڱ༭����!");
			return false;
		}
		var rows=DataGrid1.datagrid("selectRow",editRow1).datagrid("getSelected"); 
		var CSPname =  editors[0].target.val();
		if (CSPname==""){
			$.messager.alert("��ʾ","Ԫ��ID����Ϊ��!","info",function(){
				SetRowFocus(DataGrid1,editRow1,"CSPname");
			});
			return false;
		}
		var DefiDesc =  editors[1].target.val();
		if (DefiDesc==""){
			$.messager.alert("��ʾ","Ԫ��ID����Ϊ��!","info",function(){
				SetRowFocus(DataGrid1,editRow1,"DefiDesc");
			});
			return false;
		}
		var UserID=session['LOGON.USERID'];
		var ActiveFlag=1;
		if ($.isEmptyObject(rows)){
			var ID="";
		}else{
			var ID=rows.RowId;
		}
		var Str=ID+String.fromCharCode(1)+CSPname+String.fromCharCode(1)+DefiDesc;
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		$.m({
			ClassName:"DHCDoc.OPDoc.AjaxTreatStatusConfigMain",
			MethodName:"SaveConfigData",
			Str:Str,
			HospId:HospID
		},function(val){
			if (val=="0"){
				LoadDataGrid1();
			}else{
				$.messager.alert("��ʾ","����ʧ��! "+val);
			}
		});
	}
	function DataGrid2Save(){
		var editors = DataGrid2.datagrid('getEditors', editRow2);
		if (editors.length==0){
			$.messager.alert("��ʾ","û�����ڱ༭����!");
			return false;
		}
		var MainRow=DataGrid1.datagrid("getSelected"); 
		var cspId=MainRow.RowId;
		var cspName=MainRow.CSPname;
		var rows=DataGrid2.datagrid("selectRow",editRow2).datagrid("getSelected"); 
		
		var toolId =  editors[0].target.val();
		if (toolId==""){
			$.messager.alert("��ʾ","Ԫ��ID����Ϊ��!","info",function(){
				SetRowFocus(DataGrid2,editRow2,"toolId");
			});
			return false;
		}
		var name =  editors[1].target.val();
		/*if (name==""){
			$.messager.alert("��ʾ","��ť���Ʋ���Ϊ��!","info",function(){
				SetRowFocus(DataGrid2,editRow2,"name");
			});
			return false;
		}*/
		var clickHandler=editors[2].target.val();
		var iconStyle=editors[3].target.val();
		var tooltip=editors[4].target.val();
		var shortcut=editors[5].target.val();
		var express=editors[6].target.val();
		var URLconfig=editors[7].target.val();
		var iconRoute=editors[8].target.val();
		var customStyle=editors[9].target.val();
		var herSplitLine=editors[10].target.combobox('getValue');
		var verSplitLine=editors[11].target.combobox('getValue');
		var activeStatus=editors[12].target.val();
		var disableStatus=editors[13].target.val();
		var ID=rows.RowId;
		if (ID==undefined){
			ID="";
		}
		var Str=ID+String.fromCharCode(1)+toolId+String.fromCharCode(1)+name;
		Str=Str+String.fromCharCode(1)+iconStyle+String.fromCharCode(1)+iconRoute+String.fromCharCode(1)+customStyle;
		Str=Str+String.fromCharCode(1)+URLconfig+String.fromCharCode(1)+""+String.fromCharCode(1)+clickHandler;
		Str=Str+String.fromCharCode(1)+herSplitLine+String.fromCharCode(1)+verSplitLine+String.fromCharCode(1)+activeStatus;
		Str=Str+String.fromCharCode(1)+disableStatus+String.fromCharCode(1)+tooltip+String.fromCharCode(1)+shortcut+String.fromCharCode(1)+express;
		var val=tkMakeServerCall("DHCDoc.OPDoc.AjaxTreatStatusConfig","SaveTreatStatusConfigData",cspId,Str)
		if (val=="0"){
			LoadDataGrid2(cspName);
		}else{
			$.messager.alert("��ʾ","����ʧ��! "+val);
		}
	}
	function IsActive1(type){
		var rows=DataGrid1.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			$.messager.alert("��ʾ","��ѡ���Ѿ�����������޸���Ч��־!");
			return false;
		}else{
			var ID=rows.RowId;
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
				ClassName:"DHCDoc.OPDoc.AjaxTreatStatusConfigMain",
				MethodName:"IsActive",
				ID:ID,
				IsActive:type
			},function(val){
				if (val=="0"){
					var index=DataGrid1.datagrid('getRowIndex',rows);
					DataGrid1.datagrid('updateRow',{
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
	function IsActive2(type){
		var rows=DataGrid2.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			$.messager.alert("��ʾ","��ѡ���Ѿ�����������޸���Ч��־!");
			return false;
		}else{
			var ID=rows.RowId;
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
				ClassName:"DHCDoc.OPDoc.AjaxTreatStatusConfig",
				MethodName:"IsActive",
				ID:ID,
				IsActive:type
			},function(val){
				if (val=="0"){
					var index=DataGrid2.datagrid('getRowIndex',rows);
					DataGrid2.datagrid('updateRow',{
						index: index,
						row: {
							IsActive: type
						}
					});
				}else{
					$.messager.alert("��ʾ","�޸�ʧ��! "+val);
				}
			});
		}
	}
	function IsShow(type){
		var rows=DataGrid2.datagrid('getSelected');
		if ($.isEmptyObject(rows)){
			$.messager.alert("��ʾ","��ѡ���Ѿ�����������޸���Ч��־!");
			return false;
		}else{
			var ID=rows.RowId;
			var selIsVisible=rows.IsVisible;
			if ((type=="1")&&(selIsVisible=="1")){
				$.messager.alert("��ʾ","�Ѿ�����ʾ״̬!");
				return false;
			}
			if ((type=="0")&&(selIsVisible=="0")){
				$.messager.alert("��ʾ","�Ѿ�������״̬!");
				return false;
			}
			$.m({
				ClassName:"DHCDoc.OPDoc.AjaxTreatStatusConfig",
				MethodName:"IsVisible",
				ID:ID,
				IsVisible:type
			},function(val){
				if (val=="0"){
					var index=DataGrid2.datagrid('getRowIndex',rows);
					DataGrid2.datagrid('updateRow',{
						index: index,
						row: {
							IsVisible: type
						}
					});
				}else{
					$.messager.alert("��ʾ","�޸�ʧ��! "+val);
				}
			});
		}
	}
	function MoveSelRow(type){
	   var obj = new Object();
       obj=DataGrid2;
	   var sel=obj.datagrid("getSelected");
		if (sel){
			MoveRow(obj,type);
			var pageNumber=obj.datagrid('options').pageNumber;
			var pageSize=obj.datagrid('options').pageSize;
			var StartIndex=(pageNumber-1)*pageSize+1;
		    var Str="";
		    var data = obj.datagrid('getData');
		    for (var i=0;i<data.rows.length;i++){
			    var ID=data.rows[i].RowId;
			    var index=obj.datagrid('getRowIndex',ID);
			    if (Str=="") Str=ID+String.fromCharCode(1)+(StartIndex+index);
			    else Str=Str+"^"+ID+String.fromCharCode(1)+(StartIndex+index);
			}
			if (Str==""){
				return false;
			}
		    $.m({
			    ClassName : "DHCDoc.OPDoc.AjaxTreatStatusConfig",
			    MethodName : "RemoveTreatStatusConfigData",
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
	function SetRowFocus(DataGrid,index,field){
		var ed = DataGrid.datagrid('getEditor', {index:index,field:field});
		$(ed.target).focus(); 
	}
	function InitTable2(){
		var Columns=[[ 
 			{field:'RowId',title:'',hidden:true},
 			{field:'CSPname',title:'',hidden:true},
 			{field:'toolId',title:'Ԫ��ID',width:100,
 				editor : {type : 'text',options : {required:true}}
 			},
 			{field:'name',title:'��ť����',width:100,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'clickHandler',title:'�����¼�',width:150,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'iconStyle',title:'ͼ����ʽ',width:150,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'tooltip',title:'������ʾ�ı�',width:150,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'shortcut',title:'��ݼ�',width:100,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'express',title:'���ʽ',width:200,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'URLconfig',title:'����',width:150,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'iconRoute',title:'ͼ��·��',width:150,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'customStyle',title:'������ʽ',width:100,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'herSplitLine',title:'�Ƿ�ˮƽ�ָ�',width:100,
 				editor : {
	 				type:'combobox',
			        options:{
				      valueField:'code',
				      textField:'desc',
				      editable:false,
				      data:[{"code":"false","desc":"��","selected":true},{"code":"true","desc":"��"}],
			        }
	 			},formatter:function(value,record){
		 			if (value=="true") return "��";
		 			else  if (value=="false") return "��";
		 		},
 				styler: function(value,row,index){
	 				if (value=="true"){
		 				return 'color:#21ba45;';
		 			}else if(value=="false"){
			 			return 'color:#f16e57;';
			 		}
 				}
 			},
 			{field:'verSplitLine',title:'�Ƿ�ֱ�ָ�',width:100,
 				editor : {
	 				type:'combobox',
			        options:{
				      valueField:'code',
				      textField:'desc',
				      editable:false,
				      data:[{"code":"false","desc":"��","selected":true},{"code":"true","desc":"��"}]
			        }
	 			},
				formatter:function(value,record){
		 			if (value=="true") return "��";
		 			else  if (value=="false") return "��";
		 		},
 				styler: function(value,row,index){
	 				if (value=="true"){
		 				return 'color:#21ba45;';
		 			}else if(value=="false"){
			 			return 'color:#f16e57;';
			 		}
 				}
 			},
 			/*{field:'DisplayNum',title:'��ʾ˳��',width:150},*/
 			{field:'activeStatus',title:'����״̬',width:80,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'disableStatus',title:'����״̬',width:80,
 				editor : {type : 'text',options : {}}
 			},
 			{field:'IsVisible',title:'�Ƿ�ɼ�',width:70,
 				formatter:function(value,record){
		 			if (value=="1") return "��";
		 			else  if (value=="0") return "��";
		 		},
 				styler: function(value,row,index){
	 				if (value=="1"){
		 				return 'color:#21ba45;';
		 			}else if(value=="0"){
			 			return 'color:#f16e57;';
			 		}
 				}
 			},
 			{field:'IsActive',title:'�Ƿ���Ч',width:70,
 				formatter:function(value,record){
		 			if (value=="1") return "��";
		 			else  if (value=="0") return "��";
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
	            text: '����',
	            iconCls: 'icon-add',
	            handler: function() {
		            DataGrid2.datagrid("rejectChanges");
                	DataGrid2.datagrid("unselectAll");
                	DataGrid2.datagrid("insertRow", {
                        index: 0,
                        row: {
	                        herSplitLine:"��",
	                        verSplitLine:"��"
	                    }
                    });
                    DataGrid2.datagrid("beginEdit", 0);
                    SetRowFocus(DataGrid2,0,"toolId");
                    editRow2=0;
		        }
	        },{
	            text: 'ɾ��',
	            iconCls: 'icon-cancel',
	            handler: function() {DataGrid2Del();}
	        },{
	            text: '����',
	            iconCls: 'icon-save',
	            handler: function() {DataGrid2Save();}
	        },'-', {
	            text: '��ʾ',
	            iconCls: 'icon-ok',
	            handler: function() {IsShow("1");}
	        },{
	            text: '����',
	            iconCls: 'icon-abort-order',
	            handler: function() { IsShow("0");}
	        },'-', {
	            text: '��Ч',
	            iconCls: 'icon-ok',
	            handler: function() {IsActive2("1");}
	        },{
	            text: '��Ч',
	            iconCls: 'icon-abort-order',
	            handler: function() { IsActive2("0");}
	        },'-', {
	            iconCls: 'icon-arrow-top',
	            handler: function() {MoveSelRow("up");}
	        },{
	            iconCls: 'icon-arrow-bottom',
	            handler: function() {MoveSelRow("down");}
	        }];
		DataGrid2=$("#pattable2").datagrid({
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
			idField:'RowId',
			columns :Columns,
			toolbar :toolBar,
			onDblClickRow:function(rowIndex, rowData){
				if (editRow2!= undefined){
					DataGrid2.datagrid("rejectChanges").datagrid("unselectAll");
                }
                DataGrid2.datagrid("beginEdit", rowIndex);
                SetRowFocus(DataGrid2,rowIndex,"toolId");
                editRow2=rowIndex;
			},
			onClickRow:function(rowIndex, rowData){
			},
			onBeginEdit:function(index, row){
				var ed = DataGrid2.datagrid('getEditor', {index:index,field:'shortcut'});
				$(ed.target).attr('readOnly',true).keydown(function(e){
					e.preventDefault();
            		window.onhelp = function(){ return false };
					if((e.keyCode<37)||(e.keyCode>135)) return false;
					var keyName=e.key||window.event.code;
					if(keyName.indexOf('Digit')==0) keyName=keyName.split('Digit')[1];
            		if(keyName.indexOf('Key')==0) keyName=keyName.split('Key')[1];
					keyName=keyName.toUpperCase();
					if(e.shiftKey) keyName='Shift+'+keyName;
					if(e.ctrlKey) keyName='Ctrl+'+keyName;
					$(this).val(keyName);
					return false;
				});

			}
		}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter})
	}
	function LoadDataGrid2(CSPname){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
		$.q({
			ClassName:"DHCDoc.OPDoc.TreatStatusConfigQuery",
			QueryName:"TreatStatusConfig",
			CSPMain:CSPname,
			ActiveOrNo:"",
			HospId:HospID,
			Pagerows:DataGrid2.datagrid("options").pageSize,rows:99999
		},function(GridData){
			DataGrid2.datagrid("unselectAll").datagrid('loadData',GridData);
		});
	}
	function InitRecAdmDefShwoBtnCount(){
		$HUI.combobox("#RecAdmDefShwoBtnCount", {
				width:90,
				valueField: 'id',
				textField: 'desc', 
				editable:false,
				data: [{"id":"5","desc":"5"},
					   {"id":"6","desc":"6"},
					   {"id":"7","desc":"7"},
					   {"id":"8","desc":"8"},
					   {"id":"9","desc":"9"},
					   {"id":"10","desc":"10"},
					   {"id":"11","desc":"11"},
					   {"id":"12","desc":"12"},
					   {"id":"13","desc":"13"},
					   {"id":"14","desc":"14"},
					   {"id":"15","desc":"15"}],
				onSelect:function(rec){
					//���ؿ����б�
					if (rec) {
						$.m({
							 ClassName:"web.DHCDocConfig",
							 MethodName:"SaveConfig2",
							 Node:"RecAdmDefShwoBtnCount",
							 NodeValue:rec.id,
							 HospId:$HUI.combogrid('#_HospList').getValue()
						},false);
					}
				},
				onLoadSuccess:function(){
					var count=$.m({
						 ClassName:"web.DHCDocConfig",
						 MethodName:"GetConfigNode",
						 Node:"RecAdmDefShwoBtnCount",
						 HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
					if (count==0) count=6;
					$("#RecAdmDefShwoBtnCount").combobox('setValue',count);
				}
		 });
	}
	function InitCache(){
		var hasCache = $.DHCDoc.ConfigHasCache();
		if (hasCache!=1) {
			$.DHCDoc.CacheConfigPage();
			$.DHCDoc.storageConfigPageCache();
		}
	}
	return {
		"Init":Init
	}
})();