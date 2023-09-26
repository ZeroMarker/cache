function ManfHisSearch(ManfId){
	// 检索按钮
	var searchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询批次信息',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					ManHisInfoStore.load({params:{start:0,limit:15,ManfId:ManfId}});
				}
			});
	//厂商编辑窗口
    function CreateEditWin(rowid){
	
	//厂商代码
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>厂商代码</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'厂商代码...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('codeField').getValue()==""){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'错误',msg:'厂商代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						nameField.focus();
					}
				}
			}
		}
	});
	
	//厂商名称
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>厂商名称</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'厂商名称...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('nameField').getValue()==""){
						Handler = function(){nameField.focus();}
						Ext.Msg.show({title:'错误',msg:'厂商名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						addressField.focus();
					}
				}
			}
		}
	});
	
	//厂商地址
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:'厂商地址',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'厂商地址...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						phoneField.focus();
				}
			}
		}
	});
	
	//厂商电话
	var phoneField = new Ext.form.TextField({
		id:'phoneField',
		fieldLabel:'厂商电话',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'厂商电话...',
		anchor:'90%',
		regex:/^[^\u4e00-\u9fa5]{0,}$/,
		regexText:'不正确的电话号码',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						lastPhManfField.focus();
				}
			}
		}
	});
	
	//上级厂商
	var lastPhManfField = new Ext.form.ComboBox({
		id:'lastPhManfField',
		fieldLabel:'上级厂商',
		width:298,
		listWidth:298,
		allowBlank:true,
		store:PhManufacturerStore,
		valueField:'RowId',
		displayField:'Description',
		//emptyText:'上级厂商...',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						drugProductPermitField.focus();
				}
			}
		}
	});
	
	//药物生产许可
	var drugProductPermitField = new Ext.form.TextField({
		id:'drugProductPermitField',
		fieldLabel:'药物生产许可',
		width:200,
		listWidth:200,
		//emptyText:'药物生产许可...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('drugProductPermitField').getValue()==""){
						Handler = function(){drugProductPermitField.focus();}
						Ext.Msg.show({title:'错误',msg:'药物生产许可不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						drugProductExpDate.focus();
					}
				}
			}
		}
	});
	
	//药物生产许可有效期
	var drugProductExpDate = new Ext.ux.DateField({ 
		id:'drugProductExpDate',
		fieldLabel:'药物生产许可有效期',  
		allowBlank:true,
		width:298,
		listWidth:298,    
		format:App_StkDateFormat,        
		//emptyText:'药物生产许可有效期 ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('drugProductExpDate').getValue()==""){
						Handler = function(){drugProductExpDate.focus();}
						Ext.Msg.show({title:'错误',msg:'药物生产许可有效期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						matProductPermitField.focus();
					}
				}
			}
		}      
	});  
	
	//材料生产许可
	var matProductPermitField = new Ext.form.TextField({
		id:'matProductPermitField',
		fieldLabel:'材料生产许可',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'材料生产许可...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('matProductPermitField').getValue()==""){
						Handler = function(){matProductPermitField.focus();}
						Ext.Msg.show({title:'错误',msg:'材料生产许可不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						matProductExpDate.focus();
					}
				}
			}
		}
	});
	
	//材料生产许可有效期
	var matProductExpDate = new Ext.ux.DateField({ 
		id:'matProductExpDate',
		fieldLabel:'材料生产许可有效期',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		//emptyText:'材料生产许可有效期 ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('matProductExpDate').getValue()==""){
						Handler = function(){matProductExpDate.focus();}
						Ext.Msg.show({title:'错误',msg:'材料生产许可有效期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						comLicField.focus();
					}
				}
			}
		}        
	});
	
	//工商执照许可
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:'工商执照许可',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'工商执照许可...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('comLicField').getValue()==""){
						Handler = function(){comLicField.focus();}
						Ext.Msg.show({title:'错误',msg:'工商执照许可不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						comLicExpDate.focus();
					}
				}
			}
		}
	});
	
	//工商执照许可有效期
	var comLicExpDate = new Ext.ux.DateField({ 
		id:'comLicExpDate',
		fieldLabel:'工商执照许可有效期',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		//emptyText:'工商执照许可有效期 ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('comLicExpDate').getValue()==""){
						Handler = function(){comLicExpDate.focus();}
						Ext.Msg.show({title:'错误',msg:'工商执照许可有效期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						activeField.focus();
						activeField.setValue(true);
					}
				}
			}
		}        
	});
	var StartDate = new Ext.ux.DateField({ 
		id:'StartDate',
		fieldLabel:'起始日期',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('StartDate').getValue()==""){
						Handler = function(){comLicExpDate.focus();}
						Ext.Msg.show({title:'错误',msg:'起始日期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						activeField.focus();
						activeField.setValue(true);
					}
				}
			}
		}        
	});
	var EndDate = new Ext.ux.DateField({ 
		id:'EndDate',
		fieldLabel:'截止日期',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('StartDate').getValue()==""){
						Handler = function(){comLicExpDate.focus();}
						Ext.Msg.show({title:'错误',msg:'截止日期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						activeField.focus();
						activeField.setValue(true);
					}
				}
			}
		}        
	});
	
	
	//初始化面板
	editForm = new Ext.form.FormPanel({
		baseCls:'x-plain',
		labelWidth:150,
		labelAlign : 'right',
		items:[
			codeField,
			nameField,
			addressField,
			phoneField,
			lastPhManfField,
			drugProductPermitField,
			drugProductExpDate,
			matProductPermitField,
			matProductExpDate,
			comLicField,
			comLicExpDate,
			StartDate,
			EndDate
		]
	});
	
	//初始化添加按钮
	editButton = new Ext.Toolbar.Button({
		text:'确定',
		iconCls : 'page_save',
		handler:function(){
			editHandler();	
		}
	});
	//初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
		iconCls : 'page_close',
		text:'关闭'
	});
	
	//定义取消按钮的响应函数
	cancelHandler = function(){
		win.close();
	};
	
	//添加取消按钮的监听事件
	cancelButton.addListener('click',cancelHandler,false);
	//初始化窗口
	var win = new Ext.Window({
		title:'厂商维护',
		width:500,
		height:455,
		minWidth:500,
		minHeight:455,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:editForm,
		buttons:[
			editButton,
			cancelButton
		],
		listeners:{
			'show':function(thisWin){
				Select(rowid);
			}
		}
	});

	win.show();
	//新增
	
	
	//修改
    var editHandler= function(){
		
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue()
		if (drugProductExpDate!='') {drugProductExpDate=drugProductExpDate.format(App_StkDateFormat);}
		
		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue()
		if (matProductExpDate!='') {matProductExpDate=matProductExpDate.format(App_StkDateFormat);}
		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue();
		if (comLicExpDate!='') {comLicExpDate=comLicExpDate.format(App_StkDateFormat);}
		var StartDate = Ext.getCmp('StartDate').getValue();
		var StartDateB,EndDateB;
		if (StartDate!='') {
			StartDateB=StartDate.format('Y-m-d');
			StartDate=StartDate.format(App_StkDateFormat);
		}
		var EndDate = Ext.getCmp('EndDate').getValue();
		if (EndDate!='') {
			EndDateB=EndDate.format('Y-m-d');
			EndDate=EndDate.format(App_StkDateFormat);
		}
		if ((EndDateB!="")&&(StartDateB!="")&&(EndDateB<StartDateB)){
			Msg.info("warning", "起始日期大于截止日期!");
			return;
		}
		if(code.trim()==""){
			Ext.Msg.show({title:'提示',msg:'厂商代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(name.trim()==""){
			Ext.Msg.show({title:'提示',msg:'厂商名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		/*
		if(drugProductPermit.trim()==""){
			Ext.Msg.show({title:'提示',msg:'药物生产许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(drugProductExpDate==""){
			Ext.Msg.show({title:'提示',msg:'药物生产许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductPermit.trim()==""){
			Ext.Msg.show({title:'提示',msg:'材料生产许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductExpDate==""){
			Ext.Msg.show({title:'提示',msg:'材料生产许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLic.trim()==""){
			Ext.Msg.show({title:'提示',msg:'工商执照许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLicExpDate==""){
			Ext.Msg.show({title:'提示',msg:'工商执照许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		*/
		//拼data字符串
		var data=rowid+"^"+code+"^"+name+"^"+address+"^"+phone+"^"+lastPhManfId+"^"+drugProductPermit+"^"+drugProductExpDate+"^"+matProductPermit+"^"+matProductExpDate+"^"+comLic+"^"+comLicExpDate+"^"+StartDate+"^"+EndDate;
		Ext.Ajax.request({
			url:PhManfGridUrl+'?actiontype=updateManfHis&data='+encodeURI(data),
			waitMsg:'更新中...',
			failure:function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success:function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if(jsonData.success=='true'){
					Msg.info("success","更新成功!");
					ManfHisInfoStore.load({params:{start:PhManfPagingToolbar.cursor,limit:PhManfPagingToolbar.pageSize,ManfId:ManfId}});
					win.close();
				}else{
					if(jsonData.info==-1){
						Msg.info("error","名称重复!");
					}
					if(jsonData.info==-11){
						Msg.info("error","代码重复!");
					}
				}
			},
			scope: this
		});
	};
	
	
	function Select(rowid){
		Ext.Ajax.request({
			url: PhManfGridUrl+'?actiontype=GetManfHis&rowid='+rowid,
			failure: function(result, request) {
				Msg.info("error", "请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					//查询成功,赋值给控件
					var value = jsonData.info;
					var arr = value.split("^");
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('addressField').setValue(arr[2]);
					Ext.getCmp('phoneField').setValue(arr[3]);
					Ext.getCmp('lastPhManfField').setValue(arr[4]);
					Ext.getCmp('lastPhManfField').setRawValue(arr[5]);
					Ext.getCmp('drugProductPermitField').setValue(arr[6]);
					Ext.getCmp('drugProductExpDate').setValue(arr[7]);
					Ext.getCmp('matProductPermitField').setValue(arr[8]);
					Ext.getCmp('matProductExpDate').setValue(arr[9]);
					Ext.getCmp('comLicField').setValue(arr[10]);
					Ext.getCmp('comLicExpDate').setValue(arr[11]);
					Ext.getCmp('StartDate').setValue(arr[12]);
					Ext.getCmp('EndDate').setValue(arr[13]);
					//s Data1=Code_"^"_Name_"^"_Address_"^"_Tel_"^"_ManfAddId_"^"_$g(ParManfId)_"^"_$g(ParManf)_"^"_$g(DrugProductP)_"^"_$g(DrugProductE)_"^"_$g(MatProductP)_"^"_$g(MatProductE)_"^"_$g(ComLic)_"^"_$g(ComLicDate)_"^"_Active
				}else{
					Msg.info("error", "查询失败!" +rowid);
				}
			},
			scope: this
		});
	}
}

	// 编辑按钮
	var editPhManfHis = new Ext.Toolbar.Button({
	text:'编辑',
    tooltip:'编辑',
    id:'EditManfHisBt',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	hidden:true,
	handler:function(){
		var rowObj = ManfHisInfoGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","请选择数据!");
			return false;
		}else{
					
			CreateEditWin(rowObj[0].get("ManfHisId"));
		}
      }
    });
	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '点击关闭',
				iconCls : 'page_close',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});
	
	// 访问路径
	var ManfHisInfoUrl = DictUrl	+ 'phmanfaction.csp?actiontype=GetManfHisInfo';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : ManfHisInfoUrl,
				method : "POST"
			});

	// 指定列参数
	var fields = ["ManfHisId","ManfHisCode", "ManfHisDesc", "ManfHisAddress","ManfHisTel","ManfHisPar","ManfHisDProductP", "ManfHisDProductE", "ManfHisMProductP",
			"ManfHisMProductE","ManfHisComLic","ManfHisComLicDate","ManfHisStDate","ManfHisEdDate"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "manfhisinfo",
				fields : fields
			});
	// 数据集
	var ManfHisInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	ManfHisInfoStore.load({params:{start:0,limit:15,ManfId:ManfId}});
	var nm = new Ext.grid.RowNumberer();
	var ManfHisInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "ManfHisId",
				dataIndex : 'ManfHisId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			},{
				header : "代码",
				dataIndex : 'ManfHisCode',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "名称",
				dataIndex : 'ManfHisDesc',
				width : 250,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "地址",
				dataIndex : 'ManfHisAddress',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "电话",
				dataIndex : 'ManfHisTel',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "上级厂商",
				dataIndex : 'ManfHisPar',
				width : 120,
				align : 'left',
				sortable : true
			
	        }, {
				header : "药物生产许可",
				dataIndex : 'ManfHisDProductP',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "药物生产许可有效期",
				dataIndex : 'ManfHisDProductE',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "材料生产许可",
				dataIndex : 'ManfHisMProductP',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "材料生产许可有效期",
				dataIndex : 'ManfHisMProductE',
				width : 120,
				align : 'left',
				sortable : true
			
	        }, {
				header : "工商执照许可",
				dataIndex : 'ManfHisComLic',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "工商执照许可有效期",
				dataIndex : 'ManfHisComLicDate',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "开始日期",
				dataIndex : 'ManfHisStDate',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "截止日期",
				dataIndex : 'ManfHisEdDate',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        ]);
	var ManfHisInfoGrid = new Ext.grid.GridPanel({
				id : 'ManfHisInfoGrid',
				title : '',
				height : 170,
				cm : ManfHisInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : ManfHisInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				listeners:{
		            'rowdblclick':function(){
			             Ext.getCmp('EditManfHisBt').handler();
			
		             }
	
	             }
				//bbar:[GridPagingToolbar]
			});
	ManfHisInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : ManfHisInfoStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
					emptyMsg : "No results to display",
					prevText : "上一页",
					nextText : "下一页",
					refreshText : "刷新",
					lastText : "最后页",
					firstText : "第一页",
					beforePageText : "当前页",
					afterPageText : "共{0}页",
					emptyMsg : "没有数据",
					doLoad:function(C){
						var B={},
						A=this.getParams();
						B[A.start]=C;
						B[A.limit]=this.pageSize;
						B[A.sort]='Rowid';
						B[A.dir]='desc';
						B['ManfId']=ManfId;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});
	var window = new Ext.Window({
				title : '厂商历史信息',
				width : 700,
				height : 400,
				layout : 'border',
				items :[
				    {
		                region: 'center',
		                layout: 'fit', // specify layout manager for items
		                items: ManfHisInfoGrid        
		               
		            }
	            ],
	            tbar : [editPhManfHis,'-',closeBT]
	});
	window.show();
	}