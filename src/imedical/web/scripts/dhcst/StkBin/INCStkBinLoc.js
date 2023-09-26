// /名称: 科室库存项货位码维护
// /描述: 科室库存项货位码维护
// /编写者：LiangQiang
// /编写日期: 2013.11.12
Ext.onReady(function() {

		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var gStrParam='';
		var gIncId='';
		var gGroupId=session['LOGON.GROUPID'];
		var gLocId=session['LOGON.CTLOCID'];
		var gUserId=session['LOGON.USERID'];
         //该人员被授权的类组串。
         if (gGrantStkGrp==""){
          GetGrantStkGrp();
         }
		//////////// UI  //////////////////

		 var HelpButton = new Ext.Button({
             width : 65,
             id:"HelpButton",
             text: '帮助',
			 renderTo: Ext.get("tipdiv"),  
			 iconCls : 'page_help'
			 
             
         }) 

　　　　///科室
		var PhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '科室',
					id : 'PhaLoc',
					name : 'PhaLoc',
					width : 200,
					anchor:'30%',
					groupId:gGroupId
				});

        
		PhaLoc.on(
			"select",
			function(cmb,rec,id ){
					searchData();
					QueryLocInciDs();
					
					BinInciGrid.store.removeAll(); 
					InciBinGrid.store.removeAll(); 
			}
		);

		// 药品类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			UserId:gUserId,
			LocId:gLocId,
			anchor : '90%'
		}); 

		///药品名称
		var InciDesc = new Ext.form.TextField({
                fieldLabel : '药品名称',
                id : 'InciDesc',
                name : 'InciDesc',
				width : 250,
                listeners : {
                    specialkey : function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var inputDesc=field.getValue();
                            var stkGrp=Ext.getCmp("StkGrpType").getValue();
                            GetPhaOrderInfo(inputDesc,stkGrp);
                        }
                    },
					render : function SetTip(textfield, e){
                             this.getEl().dom.setAttribute("ext:qtip", "录入拼音助记词后回车");
                    },
                    blur:function(){
	                   	if (InciDesc.getValue()==""){
		                	gIncId="";
		                }
	                }
                }
            });
	　　

        ///货位
		var StkBinTxt = new Ext.form.TextField({
                fieldLabel : '货位',
                id : 'StkBinTxt',
                name : 'StkBinTxt',
                width : 180,
                listeners : {
                    specialkey : function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            //var inputDesc=field.getValue().trim('');
                            searchData();
                        }
                    },
					render : function SetTip(textfield, e){
                             this.getEl().dom.setAttribute("ext:qtip", "录入货位码后回车,左匹配模糊查询");
                    }
                }
            });
	　　
		///药品代码
		var IncCodeTxt = new Ext.form.TextField({
                fieldLabel : '药品代码',
                id : 'IncCodeTxt',
                name : 'IncCodeTxt',
                width : 120,
                listeners : {
                    specialkey : function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            QueryLocInciDs();
                        }
                    },
                    
                    render : function SetTip(textfield, e){
                             this.getEl().dom.setAttribute("ext:qtip", "录入药品代码回车,左匹配模糊查询");
                    }
                }
            });

         //第二行工具栏
		 var twoTbar=new Ext.Toolbar({   
		 region: 'center',
		 items:[ '药品名称:',InciDesc]  
		 
		 }); 

        //根据授权的类组串加载库存分类 add wyx 2014-04-28
		var M_StkCat = new Ext.ux.ComboBoxD({
			fieldLabel : '库存分类',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStoreByGrant,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpIdStr:gGrantStkGrp}
		});
		M_StkCat.on(
			"select",
			function(cmb,rec,id ){
					QueryLocInciDs();
			}
		);

	   ///科室货位
		
		var nm = new Ext.grid.RowNumberer();
		var StkBinCm = new Ext.grid.ColumnModel([nm, {
					header : "rowid",
					dataIndex : 'sb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '代码',
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "货位名称",
					dataIndex : 'desc',
					width : 400,
					align : 'left',
					sortable : true,
					editor:new Ext.form.TextField({
						allowBlank : false,
						listeners:{
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									addNewRow();
								}
							}
						}
					})
				}]);
		StkBinCm.defaultSortable = true;
		
		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'incstkbinaction.csp?actiontype=Query&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["sb", "code", "desc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "sb",
					fields : fields
				});
		// 数据集
		var StkBinStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:StkBinStore,
			pageSize:50,
			displayInfo:true,
			displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg:"没有记录"
		});
		
		var StkBinSm = new Ext.grid.CheckboxSelectionModel({singleSelect : true});
		var StkBinGrid = new Ext.grid.GridPanel({
					id:'StkBinGrid',
					region : 'west',
					cm : StkBinCm,
					store : StkBinStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : StkBinSm, //new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					loadMask : true,
					tbar:['科室:',PhaLoc,'-','货位:',StkBinTxt],
                    ddGroup: 'secondGridDDGroup',
					enableDragDrop : true,
					bbar:GridPagingToolbar
				});
	


        //科室库存项
		var locincinm = new Ext.grid.RowNumberer();
		var LocInciCm = new Ext.grid.ColumnModel([locincinm, {
					header : "rowid",
					dataIndex : 'rowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '代码',
					dataIndex : 'code',
					width : 140

				}, {
					header : "名称",
					dataIndex : 'desc',
					width : 400,
					align : 'left'

				}]);

		LocInciCm.defaultSortable = true;
		
		// 访问路径
		var LocInciUrl = DictUrl
					+ 'incstkbinaction.csp?actiontype=QueryLocInci&start=&limit=';
		// 通过AJAX方式调用后台数据
		var LocInciproxy = new Ext.data.HttpProxy({
					url : LocInciUrl,
					method : "POST"
				});
		// 指定列参数
		var LocInciFields = ["rowid", "code", "desc"];
		// 支持分页显示的读取方式
		var LocInciReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "rowid",
					fields : LocInciFields
				});
		// 数据集
		var LocInciStore = new Ext.data.Store({
					proxy : LocInciproxy,
					reader : LocInciReader
				});
		
		var LocInciGridPagingToolbar = new Ext.PagingToolbar({
			store:LocInciStore,
			pageSize:50,
			displayInfo:true,
			displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg:"没有记录"
		});
		
		var LocInciGrid = new Ext.grid.GridPanel({
					id:'LocInciGrid',
					region : 'center',
					cm : LocInciCm,
					store : LocInciStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					enableDragDrop : true,
					ddGroup : 'firstGridDDGroup',
					tbar:['药品代码:',IncCodeTxt,'-','库存分类:',M_StkCat,HelpButton],
					bbar:LocInciGridPagingToolbar,
                    listeners:{ 
     
							  'render' : function(){   
									twoTbar.render(this.tbar); //add one tbar   
					          }
                                
                     }

				});



		//按货位显示库存项
		
		var BinIncinm = new Ext.grid.RowNumberer();
		var BinInciCm = new Ext.grid.ColumnModel([BinIncinm, {
					header : "rowid",
					dataIndex : 'rowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '代码',
					dataIndex : 'code',
					width : 80

				}, {
					header : "名称",
					dataIndex : 'desc',
					width : 400,
					align : 'left'

				}]);

		BinInciCm.defaultSortable = true;
		
		// 访问路径
		var BinInciUrl = DictUrl
					+ 'incstkbinaction.csp?actiontype=QueryLocBinInc&start=&limit=';
		// 通过AJAX方式调用后台数据
		var BinInciproxy = new Ext.data.HttpProxy({
					url : BinInciUrl,
					method : "POST"
				});
		// 指定列参数
		var BinInciFields = ["rowid", "code", "desc"];
		// 支持分页显示的读取方式
		var BinInciReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "rowid",
					fields : BinInciFields
				});
		// 数据集
		var BinInciStore = new Ext.data.Store({
					proxy : BinInciproxy,
					reader : BinInciReader
				});
		

		var BinInciGrid = new Ext.grid.GridPanel({
					id:'BinInciGrid',
					region : 'west',
					cm : BinInciCm,
					title:'货位摆放药品(双击删除)',
					store : BinInciStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true
				});


		//按库存项显示货位
		
		var InciBinnm = new Ext.grid.RowNumberer();
		var InciBinCm = new Ext.grid.ColumnModel([InciBinnm, {
					header : "rowid",
					dataIndex : 'rowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '代码',
					dataIndex : 'code',
					width : 80

				}, {
					header : "名称",
					dataIndex : 'desc',
					width : 400,
					align : 'left'

				}]);

		InciBinCm.defaultSortable = true;
		
		// 访问路径
		var InciBinUrl = DictUrl
					+ 'incstkbinaction.csp?actiontype=QueryLocItmBin&start=&limit=';
		// 通过AJAX方式调用后台数据
		var InciBinproxy = new Ext.data.HttpProxy({
					url : InciBinUrl,
					method : "POST"
				});
		// 指定列参数
		var InciBinFields = ["rowid", "code", "desc"];
		// 支持分页显示的读取方式
		var InciBinReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "rowid",
					fields : InciBinFields
				});
		// 数据集
		var InciBinStore = new Ext.data.Store({
					proxy : InciBinproxy,
					reader : InciBinReader
				});
		

		var InciBinGrid = new Ext.grid.GridPanel({
					id:'InciBinGrid',
					region : 'center',
					cm : InciBinCm,
					title:'药品货位(双击删除)',
					store : InciBinStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					margins:'０ ０ ０ 3'
				});


　　　　 //左边panel
		 var westPanel = new Ext.Panel({  
			 id:'westform',
			 title:'科室药品货位维护',
			 region:'west',
			 collapsible: false,
			 margins:'0 3 0 0',
			 width:500,
			 frame : true,
			 layout:{  
				type:'vbox', 
				align: 'stretch',  
				pack: 'start'  
			 },
		 items: [{         
			  flex: 6,
			  layout:'fit',
			  items:[StkBinGrid]  
			 },{   
			  flex: 2 ,
			  layout:'fit',
			  items:[BinInciGrid]    
			   }]  
		 });

　　　　　//中间panel
		　centerPanel = new Ext.Panel({
		　id:'centerform',
		  title:'科室药品',
		　region: 'center',
		　margins:'0 3 0 1', 
		　frame : true,
		　layout:{  
					type:'vbox', 
					align: 'stretch',  
					pack: 'start'  
			}, 
		  items: [{           
				  flex: 6,
				  layout:'border',
				  items:[LocInciGrid]  
				 },{   
				  flex: 2 ,
				  layout:'fit',
				  items:[InciBinGrid]    
			   }]

			
		});

		// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [ westPanel,centerPanel ],
					renderTo : 'mainPanel'
				});



//	  //--------Events-------------------------//
//	  	initHosp({
//			grids:[StkBinGrid,BinInciGrid,LocInciGrid,InciBinGrid],
//			selHandler : function(){
//				PhaLoc.setValue('');
//				StkBinTxt.setValue('');
//				IncCodeTxt.setValue('');
//				M_StkCat.setValue('');
//				InciDesc.setValue('');
//			},
//			movepanel:['westform','centerform']		  	
//		});


		// 登录设置默认值
		SetLogInDept(PhaLoc.getStore(), "PhaLoc");
		searchData();
		QueryLocInciDs();
		
	
	   var firstGridDropTargetEl =  StkBinGrid.getView().scroller.dom;;
	  
	    var firstGridDropTarget = new Ext.dd.DropTarget(firstGridDropTargetEl, {
			ddGroup    : 'firstGridDDGroup',
			notifyDrop : function(ddSource, e, data){
                    var records =  ddSource.dragData.selections;
					//alert(records[0].data.code)
					//var index = ddSource.getDragData(e).rowIndex;
					
					var target = Ext.lib.Event.getTarget(e);
					var rindex = StkBinGrid.getView().findRowIndex(target); 
					var stkbindr=StkBinStore.getAt(rindex).get("sb");
					Ext.getCmp("StkBinGrid").getSelectionModel().selectRow(rindex);
                    
					for (var i = 0; i < records.length; i++) {
						//alert(LocInciGrid.getSelectionModel().getSelections()[i].data.code)
						var incil=LocInciGrid.getSelectionModel().getSelections()[i].data.rowid ;
						var savestr=incil+"^"+stkbindr;
						//alert(rindex+":"+savestr)
						save(savestr);
					}

					
					return true;
					
					
			}
	    });


		 /**
		 * 查询方法
		 */
		function searchData() {
			// 必选条件
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "科室不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}

			gStrParam=phaLoc;
			var pagesize=GridPagingToolbar.pageSize;
			StkBinStore.removeAll();
			StkBinStore.setBaseParam('LocId',gStrParam);
			StkBinStore.setBaseParam('sbDesc',Ext.getCmp("StkBinTxt").getValue().trim(''));
			StkBinStore.load({params:{start:0,limit:50}});

			
		}

        //按科室查询库存项列表
		function QueryLocInciDs()
		{
				LocInciStore.removeAll();
				var phalocrowid=Ext.getCmp("PhaLoc").getValue();
                var inccode=Ext.getCmp("IncCodeTxt").getValue().trim('');
				var stkcatrowid=Ext.getCmp("M_StkCat").getValue();
				var StrPar=phalocrowid+"^"+gIncId+"^"+inccode+"^"+stkcatrowid ;
                
				LocInciStore.setBaseParam('StrPar',StrPar);
				Ext.getCmp("StkBinTxt").getValue().trim('')
				LocInciStore.load({
				params:{start:0, limit:LocInciGridPagingToolbar.pageSize},
				callback: function(r, options, success){

					   if (success==false){
							Msg.info("error", "查询科室药品错误");
						 } else{
							   
						 }         
						   
					   }
				
				});

		}
	
         ///关联药品与货位
		function save(savestr){
			PhaLocId=Ext.getCmp('PhaLoc').getValue();
			if(PhaLocId==null||PhaLocId.length<1){
				Msg.info("warning", "科室不能为空!");
				return;
			}
		    var savestr=savestr+"^"+PhaLocId;
			var url = DictUrl
					+ "incstkbinaction.csp?actiontype=SaveLocItmBin";
            var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params: {savestr:savestr},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							mask.hide();

							//刷新下面列表
							var TmpArr = savestr.split("^");
							QueryLocInciBinDs(TmpArr[0]);
							QueryLocBinIncDs(TmpArr[1]);

							if (jsonData.success == 'true') {


							} else {
								var ret=(jsonData.info).split(':')[1];
								Msg.info("error", "保存失败："+ret);

							}
						},
						scope : this
					});

		}

　
　　///弹出药品列表
    function GetPhaOrderInfo(item, stktype) {
       var phaLoc = Ext.getCmp("PhaLoc").getValue();
        if (item != null && item.length > 0) {
            GetPhaOrderWindow(item, "", App_StkTypeCode, phaLoc, "N", "0", "",getDrugList);
        }else{
			gIncId="";
			QueryLocInciDs();
		}
		
    }
    /**
     * 返回方法
     */
    function getDrugList(record) {
        if (record == null || record == "") {
            return;
        }
        gIncId = record.get("InciDr");
        var incDesc=record.get("InciDesc");
        Ext.getCmp("InciDesc").setValue(incDesc);
		QueryLocInciDs();
    }


	    //按科室库存项查询货位列表
		function QueryLocInciBinDs(incil)
		{
				InciBinStore.removeAll();
				var StrPar=incil ;
                
				InciBinStore.setBaseParam('StrPar',StrPar);
				InciBinStore.load({
				params:{start:0, limit:9999},
				callback: function(r, options, success){

					   if (success==false){
							Msg.info("error", "查询科室药品货位错误");
						 } else{

							 
							 var totalnum =InciBinGrid.getStore().getCount()-1;
							 Ext.getCmp("InciBinGrid").getSelectionModel().selectRow(totalnum);
							 InciBinGrid.getView().focusRow(totalnum);
							   
						 }         
						   
					   }
				
				});

		}



		 ///LocInciGrid 单击行事件

		 LocInciGrid.on('rowclick',function(grid,rowIndex,e){
		   
				var selectedRow = LocInciStore.data.items[rowIndex];
				var incil = selectedRow.data["rowid"];
				QueryLocInciBinDs(incil); 
				
				
			}); 


		 ///StkBinGrid 单击行事件

		 StkBinGrid.on('rowclick',function(grid,rowIndex,e){
		   
				var selectedRow = StkBinStore.data.items[rowIndex];
				var stkbindr = selectedRow.data["sb"];
				QueryLocBinIncDs(stkbindr); 
				
				
			});


		//按货位查询科室库存项列表
		function QueryLocBinIncDs(stkbindr)
		{
				BinInciStore.removeAll();
				var StrPar=stkbindr ;
                
				BinInciStore.setBaseParam('StrPar',StrPar);
				BinInciStore.load({
				params:{start:0, limit:9999},
				callback: function(r, options, success){

					   if (success==false){
							Msg.info("error", "查询货位科室药品错误");
						 } else{
							 var totalnum =BinInciGrid.getStore().getCount()-1;
							 Ext.getCmp("BinInciGrid").getSelectionModel().selectRow(totalnum);
							 BinInciGrid.getView().focusRow(totalnum); 
						 }         
						   
					   }
				
				});

		}

     //货位库存项双击事件
	 BinInciGrid.on('rowdblclick',function(grid,rowIndex,e){
		   
				//var selectedRow = BinInciStore.data.items[rowIndex];
				Ext.MessageBox.confirm('注意', '确认要删除吗 ? ',DeleteBinInciData);
				
				
			});

	function DeleteBinInciData(btn)
	{
		if (btn=="no"){ return ;}
		var selectedRow = BinInciGrid.getSelectionModel().getSelected();
		var incilb = selectedRow.data["rowid"];
        var ParStr=incilb;
		var rowIndex = BinInciStore.indexOfId(selectedRow.id);//行号

		var url = DictUrl
					+ "incstkbinaction.csp?actiontype=DelBinInci";
        var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
						url : url,
						method : 'POST',
						params: {ParStr:ParStr},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							mask.hide();

							if (jsonData.success == 'true') {

								//刷新下面列表
								BinInciStore.removeAt( rowIndex );
								BinInciStore.reload();
								InciBinStore.reload();

							} else {
								var ret=jsonData.info;
								Msg.info("error", "删除失败："+ret);

							}
						},
						scope : this
					});

	}



    //库存项货位双击事件
	InciBinGrid.on('rowdblclick',function(grid,rowIndex,e){
		   
				Ext.MessageBox.confirm('注意', '确认要删除吗 ? ',DeleteInciBinData);
				
				
			});

	function DeleteInciBinData(btn)
	{
		if (btn=="no"){ return ;}
		var selectedRow = InciBinGrid.getSelectionModel().getSelected();
		var incilb = selectedRow.data["rowid"];
        var ParStr=incilb;
		var rowIndex = InciBinStore.indexOfId(selectedRow.id);//行号

		var url = DictUrl
					+ "incstkbinaction.csp?actiontype=DelBinInci";
        var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
						url : url,
						method : 'POST',
						params: {ParStr:ParStr},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							mask.hide();

							if (jsonData.success == 'true') {

								//刷新下面列表
								InciBinStore.removeAt( rowIndex );
								InciBinStore.reload();
								BinInciStore.reload();

							} else {
								var ret=jsonData.info;
								Msg.info("error", "删除失败："+ret);

							}
						},
						scope : this
					});

	}


   /*给帮助按钮增加tip提示
   * LiangQiang
   */
   new Ext.ToolTip({
        target: 'HelpButton',
        anchor: 'right',
        width: 400,
        anchorOffset: 5,
		hideDelay : 8000,
        html: "<font size=3 color='#5E88B6'><b>选中药品行拖拽至左边货位行,完成关联<b></font>"
    });



})