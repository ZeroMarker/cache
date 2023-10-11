GetLocInfoWindow = function(Input,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	// 替换特殊字符
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}

	var LocInfoUrl = 'dhcst.drugutil.csp?actiontype=GetLocInfoForDialog&Input='
			+ encodeURI(Input) + '&start=' + 0
			+ '&limit=' + 15;
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : LocInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["RowId", "Code", "Desc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "InciItem",
				fields : fields
			});
	// 数据集
	var LocInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : LocInfoStore,
				pageSize : 15,
				displayInfo : true,
				displayMsg :$g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
				emptyMsg : "No results to display",
				prevText : $g("上一页"),
				nextText : $g("下一页"),
				refreshText : $g("刷新"),
				lastText : $g("最后页"),
				firstText : $g("第一页"),
				beforePageText : $g("当前页"),
				afterPageText : $g("共{0}页"),
				emptyMsg : $g("没有数据")
			});

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({singleSelect:true,hidden:true});
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: '不可用',
   		dataIndex: 'NotUseFlag',
   		width: 45,
   		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});
	var LocInfoCm = new Ext.grid.ColumnModel([nm, sm, {
				header : $g("代码"),
				dataIndex : 'Code',
				width : 80,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : $g('名称'),
				dataIndex : 'Desc',
				width : 400,
				align : 'left',
				sortable : true
			}]);
	LocInfoCm.defaultSortable = true;

	// 返回按钮
	var returnBT = new Ext.Toolbar.Button({
				text : $g('返回'),
				tooltip : $g('点击返回'),
				iconCls : 'page_goto',
				handler : function() {
					returnData();
				}
			});
	/**
	 * 返回数据
	 */
	function returnData() {
		var selectRows = LocInfoGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", $g("请选择要返回的科室信息！"));
		} else if (selectRows.length > 1) {
			Msg.info("warning", $g("返回只允许选择一条记录！"));
		} else {
			flg = true;
			window.close();
			
		}
		//Ext.getCmp('SearchBT').focus(); //能将光标定义到查询按钮处，但是需要在每一个查询按钮上都添加id：SearchBT 
		                                 // 但是最好不要在公共的方法里改，因为不是所有的界面查完药品回车都是查询的 add by myq 20140418
	}

	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : $g('关闭'),
				tooltip : $g('点击关闭'),
				iconCls : 'page_delete',
				handler : function() {
					flg = false;
					window.close();
				}
			});
			
	var OverHosp=new Ext.form.Checkbox({
		boxLabel:$g('跨院'),
		fieldLabel:$g('跨院'),
		id:'OverHosp',
		name:'OverHosp',
		width:80,
		disabled:false,
		listeners : {
            "check" : function(obj,ischecked){
	            		var OverHospFlag="N"
	            		if (ischecked== true)  OverHospFlag="Y" 
	            		LocInfoStore.setBaseParam("OverHospFlag",OverHospFlag);
                        LocInfoStore.removeAll();
						LocInfoStore.load({params:{start:0,limit:15,Input:Input,OverHospFlag:OverHospFlag}});
                        
            }

    	}
	});

	var LocInfoGrid = new Ext.grid.GridPanel({
				cm : LocInfoCm,
				store : LocInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				sm : sm, //new Ext.grid.CheckboxSelectionModel(),
				loadMask : true,
				tbar : [returnBT, '-', closeBT,'->',OverHosp],
				bbar : StatuTabPagingToolbar,
				deferRowRender : false
			});

	// 双击事件
	LocInfoGrid.on('rowdblclick', function() {
				returnData();
			});
	// 回车事件
	LocInfoGrid.on('keydown', function(e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					returnData();
				}
			});
if(!window){
	var window = new Ext.Window({
				title : $g('科室信息'),
				width : 600,
				height : 400,
				layout : 'fit',
				plain : true,
				modal : true,
				buttonAlign : 'center',
//				autoScroll : true,
				items : LocInfoGrid,
				listeners: {
                                             
                        "show" : function () {

							LoadLocInfoStore(); //避免弹出窗体焦点丢失LiangQiang 2013-11-22
							
							}
                    }
			});
}
	window.show();

	window.on('close', function(panel) {
				var selectRows = LocInfoGrid.getSelectionModel()
						.getSelections();
				if (selectRows.length == 0) {
					Fn("");
				} else if (selectRows.length > 1) {
					Fn("");
				} else {
					if (flg) {
						Fn(selectRows[0]);
					} else {
						Fn("");
					}
				}
			});
    /*
	PhaOrderStore.load({
				callback : function(r, options, success) {
					if (success == false) {
						Msg.info('warning','没有任何符合的记录！');
			 	        if(window){window.close();}

					} else {
						PhaOrderGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
						row = PhaOrderGrid.getView().getRow(0);
						var element = Ext.get(row);
						if (typeof(element) != "undefined" && element != null) {
							element.focus();
						}
					}
				}
			});

	*/


	function LoadLocInfoStore()
	{
			LocInfoStore.load({
				callback : function(r, options, success) {
					if (success == false) {
						Msg.info('warning',$g('没有任何符合的记录！'));
			 	        if(window){window.close();}

					} else {
						LocInfoGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
						row = LocInfoGrid.getView().getRow(0);
						var element = Ext.get(row);
						if (typeof(element) != "undefined" && element != null) {
							element.focus();
						}
						var rownum=LocInfoGrid.getStore().getCount()
						if(rownum==1){
							returnData();
							}
					}
				}
			});

	}



}
