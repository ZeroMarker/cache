

var unitsUrl = 'dhcst.piva.setwardbat.save.csp';

//显示窗口
Ext.onReady(function() {

        Ext.QuickTips.init();// 浮动信息提示
        Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var okButton = new Ext.Toolbar.Button({
			text : '增加',
			tooltip : '点击增加',
			icon: "../scripts/dhcpha/img/add.png",
			height:30,
			width:70,
			handler : function() {

				SaveClick();

			}
		});

		var FindButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '点击查询',
			height:30,
			width:70,
			icon: "../scripts/dhcpha/img/find.gif",
			handler : function() {

				FindClick();

			}
		});
		var DeleteButton = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '点击删除',
			height:30,
			width:70,
			icon: "../scripts/dhcpha/img/cancel.png",
			handler : function() {

				DeleteClick();

			}
		});
		var ModifyButton = new Ext.Toolbar.Button({
			text : '修改',
			tooltip : '点击修改',
			height:30,
			width:70,
			icon: "../scripts/dhcpha/img/update.png",
			handler : function() {

				ModifyClick();

			}
		});		
		 ///病区控件
		var WardDs = new Ext.data.Store({
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({
				url : unitsUrl
						+ '?action=GetWardDs',
				method : 'POST'
			}),
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['warddesc','rowId'])
					
		});
		
		
		//病区tbar 
		var WardDescSelecter = new Ext.form.ComboBox({
					  id:'WardDescCombox',
					  fieldLabel:'病区',
					  store: WardDs,
					  valueField:'rowId',
					  displayField:'warddesc',
					  selectOnFocus : true,
					  width : 220,
					  listWidth:350,
					  emptyText:'选择病区...',
					  queryMode: 'remote',
					  queryParam:'combotext',
					  valueNotFoundText:''	,
					  minChars:0		  
		}); 

		var WardGridNm = new Ext.grid.RowNumberer();
		var WardGridCm = new Ext.grid.ColumnModel([WardGridNm, {
					header : "rowId",
					dataIndex : 'rowId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},{
					header : "药房",
					dataIndex : 'locdesc',
					width : 200,
					align : 'left'

				},{
					header : "病区",
					dataIndex : 'warddesc',
					width : 250,
					align : 'left'

				}, {
					header : "warddr",
					dataIndex : 'warddr',
					width : 20,
					align : 'left',
					hidden:true

				}, {
					header : "locdr",
					dataIndex : 'locdr',
					width : 40,
					align : 'left',
					hidden:true

				}]);

		WardGridCm.defaultSortable = true;
		
		// 访问路径
		var WardGridUrl = unitsUrl+'?action=GetWardDs&start=&limit=';
		// 通过AJAX方式调用后台数据
		var WardGridproxy = new Ext.data.HttpProxy({
					url : WardGridUrl,
					method : "POST"
				});
		// 指定列参数
		var WardGridFields = ["rowId", "warddesc","warddr","locdesc","locdr"];
		// 支持分页显示的读取方式
		var WardGridReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "rowId",
					fields : WardGridFields
				});
		// 数据集
		var WardGridStore = new Ext.data.Store({
					proxy : '',
					autoLoad: false,
					reader : WardGridReader
				});



		 //药房科室控件
		
		var phlocInfo = new Ext.data.Store({
			autoLoad: true,
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
					
		});
		
		phlocInfo.on(
			'beforeload',
			function(ds, o){
				var grpdr=session['LOGON.GROUPID'] ;
				ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+grpdr, method:'GET'});
			
			}
		);

		var PhaLocSelecter = new Ext.form.ComboBox({
				  id:'PhaLocSelecter',
				  fieldLabel:'药房科室',
				  store: phlocInfo,
				  valueField:'rowId',
				  displayField:'phlocdesc',
				  selectOnFocus : true,
				  width : 220,
				  listWidth:350,
				  emptyText:'选择药房科室...',
		          allowBlank: false,
				  name:'PhaLocSelecter',
				  mode: 'local',
				  valueNotFoundText:'',
				  listeners : {
                    'select' : function(e) {
                             var SelLocId=Ext.getCmp('PhaLocSelecter').getValue();//add yunhaibao 根据选择的科室动态加载批次
                             ComBoLocBat.getStore().removeAll();
                             ComBoLocBat.getStore().setBaseParam("Phalocdr",SelLocId)
                             ComBoLocBat.getStore().load();
					}
				  }		  

		});
			

		


         //第二行工具栏
		 var twoTbar=new Ext.Toolbar({   
		 region: 'center',
		 items:[ '病区:',WardDescSelecter,'-',ModifyButton,'-',DeleteButton]  
		 
		 }); 


		var WardGrid = new Ext.grid.GridPanel({
				id:'WardTbl',
				width: 450,
				region : 'west',
				cm : WardGridCm,
				store : WardGridStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				tbar:["药房: ",PhaLocSelecter,'-',okButton,'-',FindButton],
				listeners:{ 
     
							  'render' : function(){   
									twoTbar.render(this.tbar); //add one tbar   
					          }
                                
                     }


			});

		
		var upButton = new Ext.Toolbar.Button({
			text : '上移',
			tooltip : '点击上移',
			height:30,
			width:70,
			icon: "../scripts/dhcpha/images/arrow_up.png",
			handler : function() {

				UpClick();

			}
		});


		var downButton = new Ext.Toolbar.Button({
			text : '下移',
			tooltip : '点击下移',
			height:30,
			width:70,
			icon: "../scripts/dhcpha/images/arrow_down.png",
			handler : function() {

				DownClick();

			}
		});

		//药品列表

		var ItmGridNm = new Ext.grid.RowNumberer();
		var ItmGridCm = new Ext.grid.ColumnModel([ItmGridNm, {
					header : "rowId",
					dataIndex : 'rowId',
					width : 40,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "药品名称",
					dataIndex : 'itmdesc',
					width : 250,
					align : 'left'

				}, {
					header : "itmrowid",
					dataIndex : 'itmrowid',
					width : 40,
					align : 'left',
					hidden : true

				}, {
					header : "药品子类",
					dataIndex : 'subcatdesc',
					width : 200,
					align : 'left',
					hidden : true

				}, {
					header : "subcatrowid",
					dataIndex : 'subcatrowid',
					width : 40,
					align : 'left',
					hidden : true

				}, {
					header : "批次",
					dataIndex : 'batno',
					width : 100,
					align : 'left'

				}, {
					header : "顺序号",
					dataIndex : 'ordernum',
					width : 100,
					align : 'left',
					hidden:true

				}]);

		ItmGridCm.defaultSortable = true;
		
		// 访问路径
		var ItmGridUrl = unitsUrl+'?action=GetWardDs&start=&limit=';
		// 通过AJAX方式调用后台数据
		var ItmGridproxy = new Ext.data.HttpProxy({
					url : WardGridUrl,
					method : "POST"
				});
		// 指定列参数
		var ItmGridFields = ["rowId", "itmdesc","itmrowid","subcatdesc","subcatrowid","batno","ordernum"];
		// 支持分页显示的读取方式
		var ItmGridReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "rowId",
					fields : ItmGridFields
				});
		// 数据集
		var ItmGridStore = new Ext.data.Store({
					proxy : '',
					autoLoad: false,
					reader : ItmGridReader
				});




		var ItmGrid = new Ext.grid.GridPanel({
				id:'ItmTbl',
				width: 450,
				region : 'west',
				cm : ItmGridCm,
				store : ItmGridStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				tbar:[upButton,downButton]


			});



		var addButton = new Ext.Toolbar.Button({
			text : '增加',
			tooltip : '点击增加',
			height:30,
			width:70,
			icon:"../scripts/dhcpha/img/add.png",
			handler : function() {

				SaveLocBatItmClick();

			}
		});

		var updButton = new Ext.Toolbar.Button({
			text : '更新',
			tooltip : '点击更新',
			height:30,
			width:70,
			handler : function() {

			}
		});

		var delButton = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '点击删除',
			height:30,
			width:70,
			icon:"../scripts/dhcpha/img/cancel.png",
			handler : function() {

				DelClick();

			}
		});


         //药品分类
		 var ComBoCatDs = new Ext.data.Store({
				autoLoad: true,
				proxy : new Ext.data.HttpProxy({
					url : unitsUrl
							+ '?action=GetPhcCatDs',
					method : 'POST'
				}),
				reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'drugcatrowid'},['drugcatdesc','drugcatrowid'])
						
			});
			

			var ComBoCat = new Ext.form.ComboBox({
				store: ComBoCatDs,
				displayField:'drugcatdesc',
				mode: 'local', 
				width : 220,
				id:'catcomb',
				emptyText:'',
				listWidth : 200,
				valueField : 'drugcatrowid',
				emptyText:'选择药学大类...',
				fieldLabel: '药学大类'
			}); 
			
			
			//药学子类
			
			
			var ComBoSubCatDs = new Ext.data.Store({
				proxy :'',
				reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'drugsubcatrowid'},['drugsubcatdesc','drugsubcatrowid'])
						
			});
		
		

		var ComBoSubCat = new Ext.form.ComboBox({
			store: ComBoSubCatDs,
			displayField:'drugsubcatdesc',
			mode: 'local', 
			width : 220,
			id:'subcatcomb',
			emptyText:'',
			listWidth : 200,
			valueField : 'drugsubcatrowid',
			emptyText:'选择药学子类...',
			fieldLabel: '药学子类'
		}); 
		
		
		ComBoCat.on(
		'select',
		function(){
			ComBoSubCatDs.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetPhcSubCatDs&CatDr='+Ext.getCmp("catcomb").getValue(), method:'GET'});
			ComBoSubCatDs.load();
			}
		);



		///定义药品名称
	
			var ComBoIncitmDs = new Ext.data.Store({
				//autoLoad: true,
				proxy : new Ext.data.HttpProxy({
					url : unitsUrl,
		//					+ '?action=GetIncitmDs&start=0&limit=50&searchItmValue=',

					method : 'POST'
				}),
				//proxy : '',
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows',
							id : 'rowId'
						}, ['rowId', 'itmcode', 'itmdesc'])

			});
			
			
			
			 var tpl =  new Ext.XTemplate(
			'<table cellpadding=2 cellspacing = 1><tbody>',
			'<tr><th style="font-weight: bold; font-size:15px;">药品名称</th><th style="font-weight: bold; font-size:15px;">编码</th><th style="font-weight: bold; font-size:15px;">ID</th></tr>',
			'<tpl for=".">',
			'<tr class="combo-item">',
			'<td style="width:500; font-size:15px;">{itmdesc}</td>',
			'<td style="width:20%; font-size:15px;">{itmcode}</td>',
			'<td style="width:50; font-size:15px;">{rowId}</td>',
			'</tr>',
			'</tpl>', '</tbody></table>');
			

			var IncitmSelecter = new Ext.form.ComboBox({
						id : 'InciSelecter',
						fieldLabel : '药品名称',
						store : ComBoIncitmDs,
						valueField : 'rowId',
						displayField : 'itmdesc',
						//typeAhead : true,
						pageSize : 50,
						minChars : 1,
						width:220,
						// heigth : 150,
						autoHeight:true,
						listWidth : 550,
						triggerAction : 'all',
						emptyText : '选择药品名称...',
						//allowBlank : false,
						name : 'IncitmSelecter',
						selectOnFocus : true,
						forceSelection : true,
						valueNotFoundText:'',
						tpl: tpl,
						itemSelector: 'tr.combo-item',
						listeners : {
							 'beforequery':function(e){
								
																					ComBoIncitmDs.proxy = new Ext.data.HttpProxy({
												url : unitsUrl
														+ '?action=GetIncitmDs&searchItmValue='
														+ Ext.getCmp('InciSelecter').getRawValue(),
												method : 'POST'
											})
									ComBoIncitmDs.reload({
												params : {
													start : 0,
													limit : IncitmSelecter.pageSize
												}
											});
							},
								specialKey :function(field,e){								
												if (e.getKey() == Ext.EventObject.ENTER) {
													   
														ComBoIncitmDs.proxy = new Ext.data.HttpProxy({
												url : unitsUrl
														+ '?action=GetIncitmDs&searchItmValue='
														+ Ext.getCmp('InciSelecter').getRawValue(),
												method : 'POST'
											})
									ComBoIncitmDs.reload({
												params : {
													start : 0,
													limit : IncitmSelecter.pageSize
												}
											});
												
															 }					
										}
									   
							 }

			});

		  //批次
		 var LocBatListDs = new Ext.data.Store({
				autoLoad: false,
				proxy : new Ext.data.HttpProxy({
					url : unitsUrl
							+ '?action=GetLocBatListDs',
					method : 'POST'
				}),
				reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'batnorowid'},['batno','batnorowid'])
						
			});
		 var ComBoLocInciBat= new Ext.form.ComboBox({
				store: LocBatListDs,
				displayField:'batno',
				mode: 'local', 
				width : 220,
				id:'locincibatcomb',
				emptyText:'',
				listWidth : 200,
				valueField : 'batnorowid',
				emptyText:'选择批次...',
				fieldLabel: '批次',
				valueNotFoundText:''
			});

		var ItmPanel = new Ext.form.FormPanel({
            	labelWidth : 80,
				labelAlign : 'right',
				height:150,
				frame : true,
				items : [IncitmSelecter,ComBoLocInciBat]
        });

		var MinField=new Ext.form.NumberField({
			allowNegative:false ,
			width : 220, 
			id:"MinText", 
			fieldLabel:"下限" ,
			emptyText:'一组容量不能小于...'
        })

		var MaxField=new Ext.form.NumberField({
			allowNegative:false ,
			width : 220, 
			id:"MaxText", 
			fieldLabel:"上限" ,
			emptyText:'一组容量不能大于...'
        })			

		 var ComBoLocBat= new Ext.form.ComboBox({
				store: LocBatListDs,
				displayField:'batno',
				mode: 'local', 
				width : 220,
				id:'locbatcomb',
				emptyText:'',
				listWidth : 200,
				valueField : 'batnorowid',
				emptyText:'选择批次...',
				fieldLabel: '批次',
				valueNotFoundText:''
			});  

		var CubagePanel = new Ext.form.FormPanel({
            	labelWidth : 80,
				labelAlign : 'right',
				height:150,
				frame : true,				
				items : [ComBoLocBat,MinField,MaxField]
        });

		
		
		//容积列表

		var CubageGridNm = new Ext.grid.RowNumberer();
		var CubageGridCm = new Ext.grid.ColumnModel([CubageGridNm, {
					header : "rowId",
					dataIndex : 'rowId',
					width : 40,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "批次",
					dataIndex : 'batno',
					width : 200,
					align : 'left'

				}, {
					header : "下限",
					dataIndex : 'min',
					width : 80,
					align : 'left'
					

				}, {
					header : "上限",
					dataIndex : 'max',
					width : 80,
					align : 'left'
					

				}]);

		CubageGridCm.defaultSortable = true;
		
		// 访问路径
		var CubageGridUrl = unitsUrl+'?action=GetWardDs&start=&limit=';
		// 通过AJAX方式调用后台数据
		var CubageGridproxy = new Ext.data.HttpProxy({
					url : CubageGridUrl,
					method : "POST"
				});
		// 指定列参数
		var CubageGridFields = ["rowId", "batno","min","max"];
		// 支持分页显示的读取方式
		var CubageGridReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "rowId",
					fields : CubageGridFields
				});
		// 数据集
		var CubageGridStore = new Ext.data.Store({
					proxy : '',
					autoLoad: false,
					reader : CubageGridReader
				});




		var CubageGrid = new Ext.grid.GridPanel({
				id:'CubageTbl',
				width: 450,
				region : 'west',
				cm : CubageGridCm,
				store : CubageGridStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true


			});

		
		var BatNoPanel = new Ext.TabPanel({
			activeTab : 0,
			id:'BatNoTab',
			region : 'center',
			margins:'3 3 3 3',
			border:false,
			tbar : [addButton,delButton],
			items : [{
				id:'itm',
				layout:{  
						type:'vbox', 
						align: 'stretch',  
						pack: 'start'  
					 },
				title : '药品规则',
				items: [{         
				  flex: 1,
				  layout:'fit',
				  items:[ItmPanel]  
				 },{   
				  flex: 5 ,
				  layout:'fit',
				  items:[ItmGrid]    
				   }] 
			}, {
				id:'cubage',
				layout:{  
						type:'vbox', 
						align: 'stretch',  
						pack: 'start'  
					 },
				title : '容量规则',
				items: [{         
				  flex: 2,
				  layout:'fit',
				  items:[CubagePanel]  
				 },{   
				  flex: 6 ,
				  layout:'fit',
				  items:[CubageGrid]    
				   }] 
			}]
		});	



        var port = new Ext.Viewport({

				layout : 'border',

				items : [WardGrid,BatNoPanel]

			});



    

	///////////////////////Event//////////////////
			
			
		
			
	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });		
			
	 //设置默认科室
	function setDefaultLoc()
	{
		
		if (phlocInfo.getTotalCount() > 0){
                PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
				QueryLocBat();
				GetLocBatListDs();
        }

	}

    //
    function FindClick()
	{
		QueryLocBat();
	}

	function SaveClick()
	{
		Ext.MessageBox.confirm('注意', '确认增加吗?',SaveLocBat);
	}
	function DeleteClick()
	{
		Ext.MessageBox.confirm('注意', '确认删除吗?',DeleteLocBat);
	}
	function ModifyClick()
	{
		Ext.MessageBox.confirm('注意', '确认修改吗?',ModifyLocBat);
	}
	function DeleteLocBat(btn)
	{
		if (btn=="no"){ return ;}
		var row = Ext.getCmp("WardTbl").getSelectionModel().getSelections();
		if (!(row)){
			   Ext.MessageBox.alert("提示", "未选中记录!");
			   return;
		 }
		if (row==0){
			   Ext.MessageBox.alert("提示", "未选中记录!");
			   return;
		 }
		var plbatrowid = row[0].data.rowId;
		waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
		waitMask.show();				
		Ext.Ajax.request({
	
		url:unitsUrl+'?action=DelLocBat&PLBATRowid='+plbatrowid,
		method : 'POST',
		failure: function(result, request) {
			waitMask.hide();
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			msgtxt="OK" ;
			waitMask.hide();
			var jsonData = Ext.util.JSON.decode( result.responseText );

			if (jsonData.retvalue==0){
			  QueryLocBat();
			}else{
			  msgtxt="删除失败,ErrCode:"+jsonData.retinfo;
			}			  	 
			
			Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});

		},
		
			scope: this
		});

	}
	function ModifyLocBat(btn)
	{
		if (btn=="no"){ return ;}
		var row = Ext.getCmp("WardTbl").getSelectionModel().getSelections();
		if (!(row)){
			   Ext.MessageBox.alert("提示", "未选中记录!");
			   return;
		 }
		if (row==0){
			   Ext.MessageBox.alert("提示", "未选中记录!");
			   return;
		 }
		var plbatrowid = row[0].data.rowId;
		var Phalocdr=Ext.getCmp("PhaLocSelecter").getValue();  //科室 ;
		var PhclocDesc=Ext.getCmp("PhaLocSelecter").getRawValue().trim();
		if (PhclocDesc==""){
			Phalocdr="";
		}
		var WardDr=Ext.getCmp("WardDescCombox").getValue();  //病区
		var WardDesc=Ext.getCmp("WardDescCombox").getRawValue().trim();
		if (WardDesc==""){
			WardDr="";
		}
		if(Phalocdr==""){
			Ext.MessageBox.alert("提示", "科室为空!");
		  	return;	
		}
		waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
		waitMask.show();				
		Ext.Ajax.request({
	
		url:unitsUrl+'?action=UpdateLocBat&PLBATRowid='+plbatrowid+'&Phalocdr='+Phalocdr+'&WardDr='+WardDr,
		method : 'POST',
		failure: function(result, request) {
			waitMask.hide();
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			msgtxt="OK" ;
			waitMask.hide();
			var jsonData = Ext.util.JSON.decode( result.responseText );

			if (jsonData.retvalue==0){
			  QueryLocBat();
			}
			else if (jsonData.retvalue==-1){
				msgtxt="已存在修改后的记录,不允许修改,请核实!";
			}
			else{
			  msgtxt="修改失败,ErrCode:"+jsonData.retinfo;
			}			  	 
			
			Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});

		},
		
			scope: this
		});

	}

	function SaveLocBat(btn)
	{

					if (btn=="no"){ return ;}

					var Phaloc=Ext.getCmp("PhaLocSelecter").getRawValue();
					if (Phaloc=="")
					{
						Ext.Msg.show({title:'注意',msg:'药房不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
						return;

					}
					var Phalocdr=Ext.getCmp("PhaLocSelecter").getValue();  //科室 ;
					var PhclocDesc=Ext.getCmp("PhaLocSelecter").getRawValue().trim();
					if (PhclocDesc==""){
						Phalocdr="";
					}
					var WardDr=Ext.getCmp("WardDescCombox").getValue();  //病区
					var WardDesc=Ext.getCmp("WardDescCombox").getRawValue().trim();
					if (WardDesc==""){
						WardDr="";
					}
					waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
					waitMask.show();					
					Ext.Ajax.request({			
					url:unitsUrl+'?action=InsLocBat&Phalocdr='+Phalocdr+'&WardDr='+WardDr,
					method : 'POST',
					failure: function(result, request) {
						waitMask.hide();
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
			
						waitMask.hide();
						var jsonData = Ext.util.JSON.decode( result.responseText );
           				msgtxt="OK" ;
						if (jsonData.retvalue==0){
						  QueryLocBat();
						}else{
							if (jsonData.retvalue==-1){
								msgtxt="维护数据已存在!";
							}
							else{
						  		msgtxt="保存失败,ErrCode:"+jsonData.retinfo;
							}
						}			  	 
						
						Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			
					},
					
						scope: this
					});
			
			
		
	}

    //获取批次
	function GetLocBatListDs()
	{
			var Phalocdr=Ext.getCmp("PhaLocSelecter").getValue();  //科室 ;

			LocBatListDs.removeAll(); 	
			LocBatListDs.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetLocBatListDs&Phalocdr='+Phalocdr });
			LocBatListDs.load({
			callback: function(r, options, success){
	 
					 
					 if (success==false){
								 Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
								 }
					  }
			
			});
	}

    ///查询
	function QueryLocBat()
	{



			var Phalocdr=Ext.getCmp("PhaLocSelecter").getValue();  //科室 ;

			WardGridStore.removeAll(); 	
			WardGridStore.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetLocBatDs&Phalocdr='+Phalocdr });
			WardGridStore.load({
			callback: function(r, options, success){
	 
					 
					 if (success==false){
								 Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
								 }
					  }
			
			});
			
			
	}




	


	function SaveLocBatItmClick()
	{
		Ext.MessageBox.confirm('注意', '确认保存吗?',InsLocBat);
	}

    
	function InsLocBat(btn)
	{
		    if (btn=="no"){ return ;}
			var p = Ext.getCmp("BatNoTab").getActiveTab();
			if (p.id=='itm')
			{
				InsLocBatItm();
			}

			if (p.id=='cubage')
			{
				InsLocBatCubage();
			}
	}



	///
	function InsLocBatItm()
	{

					var row = Ext.getCmp("WardTbl").getSelectionModel().getSelections();

					if (!(row)){
						   Ext.MessageBox.alert("提示", "未选中左侧记录!");
						   return;
					 }
					if (row==0){
						   Ext.MessageBox.alert("提示", "未选中左侧记录!");
						   return;
					 }

					 var warddr = row[0].data.warddr;
					 var phalocdr = row[0].data.locdr;
					 var main = row[0].data.rowId;

					var Phaloc=Ext.getCmp("PhaLocSelecter").getRawValue();
					if (Phaloc=="")
					{
						Ext.Msg.show({title:'注意',msg:'药房不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
						return;

					}
					var DrugName=Ext.getCmp("InciSelecter").getRawValue();
					if (DrugName=="")
					{
						Ext.Msg.show({title:'注意',msg:'药品名称不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
						return;

					}
                    
					var inci=Ext.getCmp("InciSelecter").getValue();
					var itmbatnoid=Ext.getCmp("locincibatcomb").getValue().trim('');
					var itmbatno=Ext.getCmp("locincibatcomb").getRawValue().trim('');
					if ((itmbatnoid=="")||(itmbatno==""))
					{
						Ext.Msg.show({title:'注意',msg:'批次不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
						return;
					}
					waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
					waitMask.show();
					
					Ext.Ajax.request({
				
					url:unitsUrl+'?action=InsLocBatItm&main='+main+'&inci='+inci+'&itmbatno='+itmbatno,
					method : 'POST',
					failure: function(result, request) {
						waitMask.hide();
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
			
						waitMask.hide();
						msgtxt="OK" ;
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.retvalue==0){
								QueryLocBatItm(main);
						}else if (jsonData.retvalue==-10){
							msgtxt="药品批次记录已存在!"
						}
						else{
						  msgtxt="保存失败,ErrCode:"+jsonData.retinfo;
						}			  	 
						
						Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			
					},
					
						scope: this
					});
			
			
		
	}


	WardGrid.on('rowclick',function(grid,rowIndex,e){
        var selectedRow = WardGridStore.data.items[rowIndex];
		var main = selectedRow.data["rowId"];
		var locdr=selectedRow.data["locdr"];
		var warddr=selectedRow.data["warddr"];
		Ext.getCmp('PhaLocSelecter').setValue(locdr);
		Ext.getCmp('WardDescCombox').setValue(warddr);
        QueryLocBatItm(main);
        QueryLocBatCubage(main) ;
		
    });


	function QueryLocBatItm(main)
	{

            ItmGridStore.removeAll();
			ItmGridStore.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetLocBatItmDs&main='+main });
			ItmGridStore.load({
			callback: function(r, options, success){
	 
					 
					 if (success==false){
								 Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
								 }
					  }
			
			});
	}



		    ///查询容量规则
	function QueryLocBatCubage(main)
	{

			CubageGridStore.removeAll(); 	
			CubageGridStore.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryLocBatCubage&main='+main});
			CubageGridStore.load({
			callback: function(r, options, success){
	 
					 
					 if (success==false){
								 Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
								 }
					  }
			
			});
			
			
	}



   ///删除
   function DelClick()
	{
		Ext.MessageBox.confirm('注意', '确认删除吗?',Del);
	}

	function Del(btn)
	{
						
		if (btn=="no"){ return ;}

		var p = Ext.getCmp("BatNoTab").getActiveTab();
		if (p.id=='itm')
		{
			DelLocBatItm();
		}

		if (p.id=='cubage')
		{
			DelLocBatCubage();
		}
		

	}

	///
	function DelLocBatItm()
	{



				var row = Ext.getCmp("ItmTbl").getSelectionModel().getSelections();

				if (!(row)){
					   Ext.MessageBox.alert("提示", "未选中记录!");
					   return;
				 }
				if (row==0){
					   Ext.MessageBox.alert("提示", "未选中记录!");
					   return;
				 }

				var PlbSub = row[0].data.rowId;


				waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
				waitMask.show();
				
				Ext.Ajax.request({
			
				url:unitsUrl+'?action=DelLocBatItm&PlbSub='+PlbSub,
				method : 'POST',
				failure: function(result, request) {
					waitMask.hide();
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
		
					waitMask.hide();
					var jsonData = Ext.util.JSON.decode( result.responseText );
					msgtxt="";
					if (jsonData.retvalue==0){
					  QueryLocBatItm(PlbSub);
					}else{
					  msgtxt="删除失败,ErrCode:"+jsonData.retinfo;
					}			  	 
					if (msgtxt!=""){
						Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
				},
				
					scope: this
				});



	}


	///
	function DelLocBatCubage()
	{



				var row = Ext.getCmp("CubageTbl").getSelectionModel().getSelections();

				if (!(row)){
					   Ext.MessageBox.alert("提示", "未选中记录!");
					   return;
				 }
				if (row==0){
					   Ext.MessageBox.alert("提示", "未选中记录!");
					   return;
				 }

				var PlbSub = row[0].data.rowId;


				waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
				waitMask.show();
				
				Ext.Ajax.request({
			
				url:unitsUrl+'?action=DelLocBatCubage&PlbSub='+PlbSub,
				method : 'POST',
				failure: function(result, request) {
					waitMask.hide();
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
		
					waitMask.hide();
					var jsonData = Ext.util.JSON.decode( result.responseText );
					msgtxt="";
					if (jsonData.retvalue==0){
					  QueryLocBatCubage(PlbSub);
					}else{
					  msgtxt="删除失败,ErrCode:"+jsonData.retinfo;
					}
					if (msgtxt!=""){			  	 
						Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
				},
				
					scope: this
				});



	}





    ///保存容量规则
	function InsLocBatCubage()
	{
					var row = Ext.getCmp("WardTbl").getSelectionModel().getSelections();

					if (!(row)){
						   Ext.MessageBox.alert("提示", "未选中左侧记录!");
						   return;
					 }
					if (row==0){
						   Ext.MessageBox.alert("提示", "未选中左侧记录!");
						   return;
					 }

					 var warddr = row[0].data.warddr;
					 var phalocdr = row[0].data.locdr;
					 var main = row[0].data.rowId;

					var Phaloc=Ext.getCmp("PhaLocSelecter").getRawValue();
					if (Phaloc=="")
					{
						Ext.Msg.show({title:'注意',msg:'药房不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
						return;

					}
					var min=Ext.getCmp("MinText").getRawValue().trim('');
					if (min=="")
					{
						Ext.Msg.show({title:'注意',msg:'下限不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
						return;
					}
					var max=Ext.getCmp("MaxText").getRawValue().trim('');
					if (max=="")
					{
						Ext.Msg.show({title:'注意',msg:'上限不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
						return;

					}
                    if(Number(min)>Number(max))
                    {
	                	Ext.Msg.show({title:'注意',msg:'下限不能大于上限 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
						return;
	                }
					var locbatnoid=Ext.getCmp("locbatcomb").getValue().trim('');
					var locbatno=Ext.getCmp("locbatcomb").getRawValue().trim('');
					if ((locbatnoid=="")||(locbatno==""))
					{
						Ext.Msg.show({title:'注意',msg:'批次不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
						return;

					}

					waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
					waitMask.show();
					
					Ext.Ajax.request({
				
					url:unitsUrl+'?action=InsLocBatCubage&main='+main+'&min='+min+'&max='+max+'&locbatno='+locbatno,
					method : 'POST',
					failure: function(result, request) {
						waitMask.hide();
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
			
						waitMask.hide();
						msgtxt="OK";
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.retvalue==0){
							QueryLocBatCubage(main);
						}else if (jsonData.retvalue=="-10"){
							msgtxt="该批次容量记录已存在!";
						}
						else{
						  	msgtxt="保存失败,ErrCode:"+jsonData.retinfo;
						}			  	 
						
						Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			
					},
					
						scope: this
					});
			
			
		
	}


   //上移
   function UpClick()
   {               
	             
	 			var rows = Ext.getCmp("ItmTbl").getSelectionModel().getSelections();

				if (!(rows)){
					   Ext.MessageBox.alert("提示", "未选中记录!");
					   return;
				 }
				if (rows==0){
					   Ext.MessageBox.alert("提示", "未选中记录!");
					   return;
				 }

				record=rows[0];
				var index=ItmGridStore.indexOf(record);//

				//当前面仍有记录时, 才进行上移操作
				var lastindex=index-1 ;
			    if (lastindex<0)
			    {
					return;
				}
				var lastRecord=ItmGridStore.getAt(lastindex);
				var ordernum=record.get("ordernum");
				var plbsub = record.get("rowId");
				var lastordernum=lastRecord.get("ordernum");
				var lastplbsub = lastRecord.get("rowId");

				var input=plbsub+"^"+lastordernum+"^"+lastplbsub+"^"+ordernum 

	
				waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
				waitMask.show();
				
				Ext.Ajax.request({
			
				url:unitsUrl+'?action=UpLocBatItm&Input='+input,
				method : 'POST',
				failure: function(result, request) {
					waitMask.hide();
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
		
					waitMask.hide();
					var jsonData = Ext.util.JSON.decode( result.responseText );

					if (jsonData.retvalue==0){
					 	msgtxt="ok";
						record.set("ordernum",lastordernum);
						lastRecord.set("ordernum",ordernum);
						ItmGridStore.sort("ordernum","ASC");

					}else{
					  msgtxt="ErrCode:"+jsonData.retinfo;
					}			  	 
					
					Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		
				},
				
					scope: this
				});

				


	}



	 //下移
   function DownClick()
   {               
	             
	 			var rows = Ext.getCmp("ItmTbl").getSelectionModel().getSelections();

				if (!(rows)){
					   Ext.MessageBox.alert("提示", "未选中记录!");
					   return;
				 }
				if (rows==0){
					   Ext.MessageBox.alert("提示", "未选中记录!");
					   return;
				 }

				record=rows[0];
				var index=ItmGridStore.indexOf(record);//

				//当前面仍有记录时, 才进行上移操作
				var nextindex=index+1 ;		
			    if (nextindex<ItmGridStore.getCount())
			    {
				}else{
					return;
				}

				var nextRecord=ItmGridStore.getAt(nextindex);
				var ordernum=record.get("ordernum");
				var plbsub = record.get("rowId");
				var nextordernum=nextRecord.get("ordernum");
				var nextplbsub = nextRecord.get("rowId");

				var input=plbsub+"^"+nextordernum+"^"+nextplbsub+"^"+ordernum 

	
				waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
				waitMask.show();
				
				Ext.Ajax.request({
			
				url:unitsUrl+'?action=UpLocBatItm&Input='+input,
				method : 'POST',
				failure: function(result, request) {
					waitMask.hide();
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
		
					waitMask.hide();
					var jsonData = Ext.util.JSON.decode( result.responseText );

					if (jsonData.retvalue==0){
					    msgtxt="ok";
						record.set("ordernum",nextordernum);
						nextRecord.set("ordernum",ordernum);
						ItmGridStore.sort("ordernum","ASC");

					}else{
					  msgtxt="ErrCode:"+jsonData.retinfo;
					}			  	 
					
					Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		
				},
				
					scope: this
				});

				


	}





    
});