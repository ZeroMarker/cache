/**
 * 发药单位
 */
 var DispUomUrl='dhcst.druginfomaintainaction.csp';
function DispUomEdit(dataStore, ArcRowid,BuomId) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// 增加按钮
	var AddBT = new Ext.Toolbar.Button({
		text : '增加',
		tooltip : '点击增加',
		width : 70,
		height : 30,
		iconCls : 'page_add',
		handler : function() {
			addNewRow();
			//存在相同记录			
		}
	});
	// 保存按钮
	var SaveBT = new Ext.Toolbar.Button({
		id : "SaveBT",
		text : '保存',
		tooltip : '点击保存',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			// 保存库存项别名
			Save();			
		}
	});
	
	
	function Save() {	
			var phaloc=Ext.getCmp("PhaLoc").getValue();
			var Arcitm=Ext.getCmp("Arcitm").getValue();
			var rowCount = DispuomGrid.getStore().getCount();
			if (rowCount<1)
			{
				Msg.info("warning", "无可用保存数据!");
				return
			}
			var ListData="";
			if ((phaloc=="")||(phaloc==null)){Msg.info("error", "请选择库存科室！"); return}
			for (var i = 0; i < rowCount; i++) {
					var ilduid = MasterInfoStore.getAt(i).get("ilduid");
					var uomdr=MasterInfoStore.getAt(i).get("UomId");
					if ((uomdr=="")||(uomdr==null))
					{
						Msg.info("warning", "单位不能为空!");
						return
						}
					var acttive=MasterInfoStore.getAt(i).get("ActiveFlag");
					var df=Ext.util.Format.date( MasterInfoStore.getAt(i).get("SDate"),'Y-m-d'); 
					var dt=Ext.util.Format.date(MasterInfoStore.getAt(i).get("EDate"),'Y-m-d');
					//alert(ilduid+"^"+uomdr+"^"+acttive+"^"+df+"^"+dt)
					if (ListData=="") 
						{
							ListData=ilduid+"^"+uomdr+"^"+acttive+"^"+df+"^"+dt;
						}
					else
					{ListData=ListData+","+ilduid+"^"+uomdr+"^"+acttive+"^"+df+"^"+dt;}
				}

			SaveDispUom(phaloc,Arcitm,ListData);
		}
		
	function SaveDispUom(phaloc,Arcitm,ListData){
			var url = DispUomUrl
					+ '?actiontype=DispUomSave';
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{phaloc:phaloc,Arcitm:Arcitm,ListData:ListData},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "保存成功!");
								GetDispUomInfo();
							} else {
								if (jsonData.info) {Msg.info("error", "保存失败:"+"不存在和基本单位的转换系数！");}
								else {Msg.info("error", "保存失败:"+jsonData.info);}
							}
						},
						scope : this
				});
				
		}
	//2. 删除按钮
	var DeleteBT = new Ext.Toolbar.Button({
		id : "DeleteBT",
		text : '删除',
		tooltip : '点击删除',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			deleteData();
		}
	});	
	function deleteData(){
					var cell = DispuomGrid.getSelectionModel().getSelectedCell();
					if (cell==null)
					{
						return;
					}
					var record = DispuomGrid.getStore().getAt(cell[0]);
					var ilduid = record.get("ilduid");
					if (ilduid=="") {
						DispuomGrid.getStore().remove(record);
						DispuomGrid.getView().refresh();
						return;
						}
					 //删除该行数据
					 var url = DispUomUrl+'?actiontype=DeleteDispUomInfo';
					 Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{ilduid:ilduid},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "删除成功!");
							} else {
								Msg.info("error", "删除失败:"+jsonData.info);
							}
						},
						scope : this
				});
			GetDispUomInfo();
		}
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'page_close',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});
	var Arcitm = new Ext.form.TextField({
		fieldLabel : '医嘱项id',
		id : 'Arcitm',
		name : 'Arcitm',
		anchor : '90%',
		value:ArcRowid,
		hidden:true
	});
	var incibuom = new Ext.form.TextField({
		fieldLabel : '库存基本单位id',
		id : 'incibuom',
		name : 'incibuom',
		anchor : '90%',
		hidden:true,
		value:BuomId
	});

	
	var PhaLoc = new Ext.ux.ComboBox({
		fieldLabel : '库存科室',
		id : 'PhaLoc',
		name : 'PhaLoc',
		store : dispuomStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'phadisploc',  //根据录入数据过滤下拉内容的参数名称
		selectOnFocus : true,
		forceSelection : true,
		params:{Arcitm:'Arcitm'},
		listeners : {
			'select' : function(e) {
				GetDispUomInfo()
				}
		}

	});

	var uom = new Ext.ux.ComboBox({
					fieldLabel : '单位',
					id : 'uom',
					name : 'uom',
					anchor : '90%',
					width : 100,
					store :CONUomStore,          //           CTUomStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'CTUomDesc',
					params:{UomId:'incibuom'},
					selectOnFocus : true,
					forceSelection : true,
				      listeners:{      
                      	'select':function(combo){
		                         var cell = DispuomGrid.getSelectionModel().getSelectedCell();
		                         var record = DispuomGrid.getStore().getAt(cell[0]);
                                 var colIndex=GetColIndex(DispuomGrid,'UomId');
                                 DispuomGrid.stopEditing(cell[0], colIndex); //弹出前先置完成编辑 LiangQiang 2013-11-22 
								 var inputUomDr = record.get("UomId");
								 var repeatflag=CheckInciUomRep(inputUomDr,cell[0]);  //最后一条
								 if (repeatflag=="1")
								 {
									Msg.info("warning", "已存在相同单位记录!");
									record.set("UomId","");
									DispuomGrid.startEditing(cell[0], colIndex);
									return;	 
								 }
								 
                         }
				      }

				});
	 var ActiveFlag=new Ext.grid.CheckColumn({
       header: '激活标志',
       dataIndex: 'ActiveFlag',
       width: 80
    });

	var nm = new Ext.grid.RowNumberer();	
	var sm=new Ext.grid.CheckboxSelectionModel()                //({singleSelect:false});
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "ilduid",
				dataIndex : 'ilduid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true

			},{
				header : "单位",
				dataIndex : 'UomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer :Ext.util.Format.comboRenderer2(uom,"UomId","Uom")	,
				editor : new Ext.grid.GridEditor(uom)
			},ActiveFlag,{
				header : "开始时间",
				dataIndex : 'SDate',
				width : 140,
				align : 'center',
				sortable : true,						
				renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
				editor :new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : false,
						format : App_StkDateFormat
				}) 
			},{
				header : "结束时间",
				dataIndex : 'EDate',
				width : 100,
				align : 'center',
				sortable : true,						
				renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
				editor :new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : true,
						format : App_StkDateFormat
				})
				}
			]);
	
	// 访问路径
	var MasterInfoUrl = DispUomUrl + '?actiontype=GetDispUomInfo';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["ilduid","UomId","Uom","ActiveFlag","SDate","EDate"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "ilduid",
				fields : fields
			});
	// 数据集
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
			
	function GetDispUomInfo(IngrRowid) {
			var Arcitm=Ext.getCmp("Arcitm").getValue();
			var phaloc=Ext.getCmp("PhaLoc").getValue();
			if (Arcitm == null) {
				return;
			}
			if (phaloc == null) {
				return;
			}
			MasterInfoStore.removeAll();
			MasterInfoStore.load({params:{phaloc:phaloc,Arcitm:Arcitm}});
		}
	///判断单位重复
	function CheckInciUomRep(InputUomDr,InputRow){
	    var repflag="0"
		var Count = DispuomGrid.getStore().getCount();
		for (var i = 0; i < Count; i++) {
			var rowData = MasterInfoStore.getAt(i);
			var rowUomDr = rowData.get("UomId");
			if ((InputRow==i)){continue}
			if ((rowUomDr!="")&&(InputUomDr==rowUomDr)){
				var repflag="1";
				return repflag;
				}
			}
		return repflag;
	}			
	var DispuomGrid = new Ext.grid.EditorGridPanel({
                id:'DispuomGrid',
                region : 'center',
                cm : MasterInfoCm,
                store : MasterInfoStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : new Ext.grid.CellSelectionModel({}),
                clicksToEdit : 1,
                plugins: [ActiveFlag],
                loadMask : true
            });
			
			
	var HisListTab = new Ext.form.FormPanel({
			height:50,
			labelWidth: 80,	
			labelAlign : 'right',
			frame : true,
			autoScroll : false,
			region : 'north',
			defaults:{border:false},
			items:[{
				xtype:'fieldset',
				columnWidth : 0.5,
				items : [PhaLoc]

			}]
	})

	var window = new Ext.Window({
				title : '发药单位',
				width :400,
				height : 400,
				layout : 'border',
				items :  [{
                	region: 'center',
                	split: true,
               		width: 500, 
                	minSize: 470,
                	maxSize: 600,
                	layout: 'border', 
                	items : [HisListTab,DispuomGrid]          
            	}],
				tbar : [AddBT, '-', SaveBT, '-', DeleteBT, '-', closeBT]
				
			});
	window.show();
	function addNewRow() {

			var record = Ext.data.Record.create([{
						name :'ilduid',
						type : 'string',
						hidden : false
					},{
						name : 'UomId',
						type : 'string'
					}, {
						name : 'DispUom',
						type : 'string'
					},{
						name : 'ActiveFlag'
						//type : 'ActiveFlag'

					}, {
						name : 'SDate',
						type : 'date'
					}, {
						name : 'EDate',
						type : 'date'
					}]);
			var NewRecord = new record({
						ilduid:'',
						UomRowid : '',
						DispUom : '',
						ActiveFlag:'',
						SDate:new Date().add(Date.DAY,1),
						EDate:new Date().add(Date.DAY,1)
					});
			MasterInfoStore.add(NewRecord);
	}
	
	addNewRow();
}
