// /名称: 根据转移请求制单
// /描述: 根据转移请求制单
// /编写者：zhangdongmei
// /编写日期: 2012.10.12
// /yunhaibao20151229,添加HideFlag,默认加载此界面时,如果无可用数据自动关闭
var SelReq=function(SupplyLocId,Fn,HideFlag) {
	if(HideFlag==undefined){HideFlag=""}
	var userId = session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// 请求部门
	var RequestPhaLocS = new Ext.ux.LocComboBox({
		fieldLabel : $g('请求部门'),
		id : 'RequestPhaLocS',
		name : 'RequestPhaLocS',
		emptyText:$g('请求部门'),
		anchor : '90%',
		width : 120,
		defaultLoc:{}
	}); 
	
	// 起始日期
	var StartDateS = new Ext.ux.DateField({
				fieldLabel : $g('起始日期'),
				id : 'StartDateS',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : DefaultStDate()
			});
	// 截止日期
	var EndDateS = new Ext.ux.DateField({
				fieldLabel : $g('截止日期'),
				id : 'EndDateS',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : DefaultEdDate()
			});
	
	// 包含部分转移
	var PartlyStatusS = new Ext.form.Checkbox({
				boxLabel : $g('包含部分转移'),
				id : 'PartlyStatusS',
				name : 'PartlyStatus',
				anchor : '90%',
				checked : false,
				disabled : false
			});
	
	// 显示已完成转移的请求明细
	var ShowTransfered = new Ext.form.Checkbox({
				boxLabel : $g('显示转移完成药品'),
				id : 'ShowTransfered',
				name : 'ShowTransfered',
				anchor : '90%',
				checked : false,
				disabled : false
			});
			
	var ReqStatus = new Ext.ux.form.LovCombo({
		id : 'ReqStatus',
		name : 'ReqStatus',
		fieldLabel : $g('请求状态'),
		//listWidth : 400,
		anchor: '90%',
		//labelStyle : "text-align:right;width:100;",
		labelSeparator : '',
		separator:',',	
		hideOnSelect : false,
		maxHeight : 300,
		editable:false,
		store : GetReqStatusStore ,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
				
		// 全选
		var AllBT = new Ext.form.Checkbox({
					boxLabel : $g('作废全选'),
					id : 'AllBT',
					name : 'AllBT',
					anchor : '90%',
					checked : false,
					handler : function() {
						AllBTSel();
					}
				});
		function AllBTSel(){
			var AllValue=Ext.getCmp("AllBT").getValue();
			var rowCount = DetailGridS.getStore().getCount();
			if (AllValue==true){
			    for (var i = 0; i < rowCount; i++) {
				  DetailStore.getAt(i).set("cancel",1);
				}  
			     }
			if (AllValue==false){
			    for (var i = 0; i < rowCount; i++) {
				   DetailStore.getAt(i).set("cancel",0);
			}
		}
	    
      /*function AllBTSel(){
	   var AllValue=Ext.getCmp("AllBT").getValue();
	   var rowCount = DetailGridS.getStore().getCount();
	   var reqItmString="";
	   if (AllValue==true){
		    for (var i = 0; i < rowCount; i++) {
			  DetailStore.getAt(i).set("cancel",1);
			  if (reqItmString==""){
				 reqItmString=DetailStore.getAt(i).get("rowid");
			  }else{
			  	 reqItmString=reqItmString+"^"+DetailStore.getAt(i).get("rowid");
			  }
			}
			CancelDetailsAction(reqItmString,"Y"); 
		}
	   if (AllValue==false){
		    for (var i = 0; i < rowCount; i++) {
			   DetailStore.getAt(i).set("cancel",0);
			   if (reqItmString==""){
				 reqItmString=DetailStore.getAt(i).get("rowid");
			   }else{
			  	 reqItmString=reqItmString+"^"+DetailStore.getAt(i).get("rowid");
			   }
			}
			CancelDetailsAction(reqItmString,"N"); 
		 }*/
	  }
	
	// 3关闭按钮
	var closeBTS = new Ext.Toolbar.Button({
				text : $g('关闭'),
				tooltip :$g( '关闭界面'),
				iconCls : 'page_delete',
				width : 70,
				height : 30,
				handler : function() {
					findWin.close();
				}
			});
			
	// 查询请求单按钮
	var SearchBTS = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : $g('查询'),
				tooltip : $g('点击查询请求单'),
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					HideFlag="";
					Query();
				}
			});


	// 清空按钮
	var ClearBTS = new Ext.Toolbar.Button({
				id : "ClearBTSR",
				text : $g('清屏'),
				tooltip :$g( '点击清屏'),
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * 清空方法
	 */
	function clearData() {
		Ext.getCmp("RequestPhaLocS").setValue("");
		Ext.getCmp("StartDateS").setValue(DefaultStDate());
		Ext.getCmp("EndDateS").setValue(DefaultEdDate());
		Ext.getCmp("PartlyStatusS").setValue(false);
		Ext.getCmp("ShowTransfered").setValue(false);
		Ext.getCmp("ReqStatus").setValue("");
		MasterGridS.store.removeAll();
		MasterGridS.getView().refresh();
		DetailGridS.store.removeAll();
		DetailGridS.getView().refresh();		
	}

	// 保存按钮
	var SaveBTS = new Ext.Toolbar.Button({
				id : "SaveBTS",
				text : $g('选取'),
				tooltip : $g('选取'),
				width : 70,
				height : 30,
				iconCls : 'page_goto',
				handler : function() {

					// 保存转移单
					if(CheckDataBeforeSave()==true){
						save();
					}
				}
			});
			
	/**
	 * 保存出库单前数据检查
	 */		
	function CheckDataBeforeSave() {
				
		var requestphaLoc = Ext.getCmp("RequestPhaLocS")
				.getValue();
		if (requestphaLoc == null || requestphaLoc.length <= 0) {
			Msg.info("warning", $g("请选择请求部门!"));
			return false;
		}
		
		if (SupplyLocId == null || SupplyLocId.length <= 0) {
			Msg.info("warning", $g("请关闭窗口，选择供应部门!"));
			return false;
		}
		if (requestphaLoc == SupplyLocId) {
			Msg.info("warning", $g("请求部门和供应部门不能相同!"));
			return false;
		}
		var selectRow=MasterGridS.getSelectionModel().getSelected();
		if(selectRow==null){
			Msg.info("warning", $g("请选择要出库的请求单!"));
			return false;
		}
		return true;
	}
	

	/**
	 * 保存转移单
	 */
	function save() {
		//供应科室RowId^请求科室RowId^制单人RowId
		var InitRowid="";
		var supplyPhaLoc =SupplyLocId;
		var requestPhaLoc = Ext.getCmp("RequestPhaLocS").getValue();
		var selectRow=MasterGridS.getSelectionModel().getSelected();
		var reqid=selectRow.get("req");
		if(reqid==null || reqid==""){
			Msg.info("warning",$g("请选择要出库的请求单!"));
			return;
		}
		if (DetailStore.getCount()<1)
		{
			Msg.info("warning",$g("没有需要转移的明细数据!"))
			return;
		}
		var mask=ShowLoadMask('findWin',$g("正在生成出库单..."));
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + userId ;		
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=CreateTransferByReq&MainInfo=" + MainInfo+"&ReqId="+reqid;
		var responsetext=ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responsetext);
		mask.hide();
		if (jsonData.success == 'true') {
			// 刷新界面
			InitRowid = jsonData.info;
			//Msg.info("success", "生成出库单成功!");
			findWin.close();
			Fn(InitRowid);
			
			// 跳转到出库制单界面
			//window.location.href='dhcst.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';

		} else {
			var ret=jsonData.info;
			if(ret==-99){
				Msg.info("error", $g("加锁失败,不能生成出库单!"));
			}else if(ret==-2){
				Msg.info("error", $g("生成出库单号失败!"));
			}else if(ret==-1){
				Msg.info("error", $g("生成出库单失败!"));
			}else if(ret==-5){
				Msg.info("error", $g("生成出库单明细失败!"));
			}else if(ret==-7){
				Msg.info("warning", $g("明细数据可用库存不足!"));
			}else if(ret==-8){
				Msg.info("warning",$g( "请求单有效数据已全部出库!"));
			}else {
				Msg.info("error", $g("生成出库单失败：")+ret);
			}
			
		}
		
	}

	// 显示请求单数据
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();  //SupplyLocId;
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning",$g( "请选择供应部门!"));
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLocS").getValue();
		var startDate = Ext.getCmp("StartDateS").getRawValue();
		var endDate = Ext.getCmp("EndDateS").getRawValue();
		var partlyStatus = (Ext.getCmp("PartlyStatusS").getValue()==true?1:0);
		var allStatus = (Ext.getCmp("ShowTransfered").getValue()==true?1:0);
		var ReqStatus = Ext.getCmp("ReqStatus").getValue();
		
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'+ReqStatus+'^'+allStatus;  //partlyStatus
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
					if(success==false){
	     				Msg.info("error", $g("查询错误，请查看日志!"));
	     			}else{
	     				if(r.length>0){
		     				MasterGridS.getSelectionModel().selectFirstRow();
		     				MasterGridS.getSelectionModel().fireEvent('rowselect',this,0);
		     				MasterGridS.getView().focusRow(0);
	     				}
	     				else if(r.length==0){
						    if (HideFlag=="1"){
								findWin.close();
							}
		     			}
	     			}
				}
		});
		DetailGridS.store.removeAll();
		DetailGridS.getView().refresh();

	}

	// 访问路径
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryReq';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["req", "reqNo", "toLoc","toLocDesc", "frLocDesc", "date","time", "comp", 
	"userName","status","transferStatus"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "req",
				fields : fields
			});
	// 数据集
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'req',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("请求单号"),
				dataIndex : 'reqNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("请求部门"),
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("供给部门"),
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("请求日期"),
				dataIndex : 'date',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : $g("单据类型"),
				dataIndex : 'status',
				width : 120,
				align : 'left',
				renderer: renderReqType,
				sortable : true
			}, {
				header : $g("制单人"),
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : $g("请求状态"),
				dataIndex : 'transferStatus',
				width : 160,
				align : 'left',
				//renderer: renderStatus,
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	
	function renderStatus(value){
		var InstrfStatus='';
		if(value==0){
			InstrfStatus=$g('未转移');			
		}else if(value==1){
			InstrfStatus=$g('部分转移');
		}else if(value==2){
			InstrfStatus=$g('全部转移');
		}
		return InstrfStatus;
	}
	function renderReqType(value){
		var ReqType='';
		if(value=='O'){
			ReqType=$g('请领单');
		}else if(value=='C'){
			ReqType=$g('申领计划');
		}
		return ReqType;
	}
	
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
	});
	var MasterGridS = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridPagingToolbar
			});

	// 添加表格单击行事件
	MasterGridS.getSelectionModel().on('rowselect', function(sm, rowIndex, r)  {
		var ReqId = MasterStore.getAt(rowIndex).get("req");
		var ReqLocDesc=MasterStore.getAt(rowIndex).get("toLocDesc");
		var ReqLocId=MasterStore.getAt(rowIndex).get("toLoc");
		addComboData(RequestPhaLocS.getStore(),ReqLocId,ReqLocDesc);
		Ext.getCmp("RequestPhaLocS").setValue(ReqLocId);
		var show=(Ext.getCmp("ShowTransfered").getValue()==true?1:0);
		DetailStore.removeAll();
		DetailStore.setBaseParam('req',ReqId);
		DetailStore.setBaseParam('TransferedFlag',show);
		
		DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'req',dir:'Desc'}});
	});
	
	// 请求明细
	// 访问路径
	var DetailUrl =DictUrl+
		'inrequestaction.csp?actiontype=queryDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// 指定列参数
	var fields = ["cancel","rowid", "inci", "code","desc","qty", "uom", "uomDesc", "spec",
			 "manf", "sp", "spAmt","generic","drugForm", "remark","transQty","NotTransQty","prvqty"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});


	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm,{
		              header :$g( "作废"),
		              width : 50,
		              sortable: false,             
		              dataIndex: 'cancel',//数据源中的状态列             
		              renderer: function (v) {
		                       return '<input type="checkbox"'+(v=="1"?"checked":"")+'/>';  //根据值返回checkbox是否勾选    
		                       },
		              listeners : {
			              'click':function(e,b,row){
				              if (DetailStore.getAt(row).get("cancel")==""||DetailStore.getAt(row).get("cancel")==0){
					              DetailStore.getAt(row).set("cancel",1);				              
					              CancelDetailsAction(DetailStore.getAt(row).get("rowid"),"Y");					               
				              }
				              else{
					              DetailStore.getAt(row).set("cancel",0);
					              CancelDetailsAction(DetailStore.getAt(row).get("rowid"),"N"); 
				              } 	
								DetailStore.getAt(row).dirty=false;
								DetailStore.getAt(row).commit(); 			               
				            }
			              },
			        hidden:(gParam[9]=='Y'?false:true)
			             
		                     
		        },{
				header : $g("请求明细RowId"),
				dataIndex : 'rowid',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("药品RowId"),
				dataIndex : 'inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g('药品代码'),
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g('药品名称'),
				dataIndex : 'desc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : $g("供应方库存"),
				dataIndex : 'prvqty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : $g("请求数量"),
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : $g("已转移数量"),
				dataIndex : 'transQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : $g("未转移数量"),
				dataIndex : 'NotTransQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header :$g( "单位"),
				dataIndex : 'uomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("售价"),
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("生产企业"),
				dataIndex : 'manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("规格"),
				dataIndex : 'spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("处方通用名"),
				dataIndex : 'generic',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("剂型"),
				dataIndex : 'drugForm',
				width : 100,
				align : 'left',
				sortable : true
			}]);
 var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
	});

	var DetailGridS = new Ext.grid.GridPanel({
				id : 'DetailGridS',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridDetailPagingToolbar,
				sm :new Ext.grid.RowSelectionModel({singleSelect:true}),
				//sm : new Ext.grid.CellSelectionModel({}),
				viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var stkQty=parseInt(record.get("stkQty"));
						var reqQty=parseInt(record.get("qty"));
						if(stkQty<reqQty){
							return 'classRed';
						}
					}
				}
			});

	 
	 function QueryListDetailID(){
	      //var sm=DetailGridS.getSelectionModel()
	      //var records=sm.getSelections()  //返回的是Ext.data.Record对象数组
	      //var count=records.length
	      var rowCount = DetailGridS.getStore().getCount();
	      var listdata=""
            for (var i=0;i<rowCount;i++) {
	         if (DetailStore.getAt(i).get("cancel")==true && listdata==""){
	            
	              listdata=DetailStore.getAt(i).get("rowid");
	         }
	         else if(DetailStore.getAt(i).get("cancel")==true && listdata!=""){
		       listdata=listdata+"^"+DetailStore.getAt(i).get("rowid");
		      }
	       } 
		return  listdata;   
	   }

	 //批量作废选中项函数 wyx 2014-06-23
	 function CancelDetailsAction(ListDetailID,CancelFlag){
		    	// 访问路径
	         var url =DictUrl+
		        'inrequestaction.csp?actiontype=CancelReqItm';
			var loadMask=ShowLoadMask(Ext.getBody(),$g("处理中..."));
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{ListDetailID:ListDetailID,CancelFlag:CancelFlag},
						waitMsg : $g('处理中...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								if (CancelFlag=="N"){
									Msg.info("success", $g("取消作废成功!"));
								}else{
									Msg.info("success",$g("作废成功!"));
								}
								// 重新加载数据
								DetailGridS.getView().refresh();

							} else {
								//var ret=jsonData.info;
								Msg.info("error", $g("作废失败!"));
							}
						},
						scope : this
					});
			loadMask.hide();		
		}
	
		function CancelSelectAll(){
			var toggleselect=(Ext.getCmp("AllBT").getValue()==false) ? true : false;
			Ext.getCmp("AllBT").setValue(toggleselect);

		}
		function CancelDetails() {
         // 用户对话框
                   Ext.Msg.show({
	                 title:$g('批量作废选中项'),
	                 msg:$g('确定批量作废选中项？'),
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    var ListDetailID=QueryListDetailID();
		                    if (ListDetailID=="") {Msg.info("warning",$g("没有勾选作废项!"));}
		                    if (ListDetailID!=""){
		                        CancelDetailsAction(ListDetailID,"Y"); 
		                       }
		                      
		                     }
                        
	                     }

	                 });
		}	
		
			/***
		**添加右键菜单,wyx,2014-06-23***
		**/
		//右键菜单代码关键部分 
		function rightClickFn(grid,rowindex,e){
			grid.getSelectionModel().selectRow(rowindex);
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); //获取坐标
           
		}
		if(gParam[9]=='Y'){
		   DetailGridS.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
		}
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mncancelSelectAll', 
					handler: CancelSelectAll, 
					text: $g('全选作废列'),
					click:true
					 
				},{ 
					id: 'mncancelDetails', 
					handler: CancelDetails, 
					text: $g('批量作废'),
					click:true,
					hidden:(gParam[9]=='Y'?false:true)
					 
				}
				]
		})
	// 双击事件
	MasterGridS.on('rowdblclick', function() {			
			// 保存转移单
		if(CheckDataBeforeSave()==true){
			save();
			
		}		
	});
	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		labelAlign : 'right',
		tbar : [SearchBTS, '-',  ClearBTS, '-', SaveBTS, '-', closeBTS],
		frame : true,
		autoScroll : false,		
		items:[{
			xtype:'fieldset',
			title:$g('查询条件'),
			defaults: {border:false}, 
			style:DHCSTFormStyle.FrmPaddingV,
			layout: 'column',    // Specifies that the items will now be arranged in columns
			items : [{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	defaults: {width: 220},    // Default config options for child items
	        	defaultType: 'textfield',
	        	items: [RequestPhaLocS]
				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',
	        	defaults: {width: 140},    // Default config options for child items
	        	defaultType: 'textfield',
	        	items: [StartDateS,EndDateS]
				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',
	        	defaults: {width: 140},    // Default config options for child items
	        	defaultType: 'textfield',
	        	items: [ReqStatus,ShowTransfered]
				
			}
			/*,{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	border: false,
	        	labelWidth:60,
	        	//defaults: {width: 140,labelWidth : 10},    // Default config options for child items
	        	items: [ShowTransfered,PartlyStatusS]
				
			}*//*,{ 				
				columnWidth: 0.24,
	        	xtype: 'fieldset',
	        	border: false,
	        	//defaults: {width: 140,labelWidth : 10},    // Default config options for child items
	        	items: [AllBT]
				
			}*/]
		}]		
	});
	var findWin = new Ext.Window({
		title:$g('选取请求单'),
		id:'findWin',
		width:document.body.clientWidth*0.9,
		height:document.body.clientHeight*0.9,
		minWidth:1000, 
		minHeight:620,
		plain:true,
		modal:true,
		layout : 'border',
		items : [            // create instance immediately
	        {
	            region: 'north',
	            height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
	            layout: 'fit', // specify layout manager for items
	            items:HisListTab
	        }, {
	            region: 'west',
	            title: $g('请求单'),
	            collapsible: true,
	            split: true,
	            width: document.body.clientWidth*0.88*0.32,
	            minSize: 175,
	            maxSize: 400,
	            margins: '0 5 0 0',
	            layout: 'fit', // specify layout manager for items
	            items: MasterGridS       
	           
	        }, {
	            region: 'center',
	            title: $g('请求单明细'),
	            layout: 'fit', // specify layout manager for items
	            items: DetailGridS       
	           
	        }
		]
		
	});
		
	//显示窗口
	findWin.show();
	Query();		
}