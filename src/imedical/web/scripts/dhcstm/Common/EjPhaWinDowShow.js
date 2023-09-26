/**
 * 名称: 物资信息窗口
 * 
 * 描述: 物资信息 编写者：hsc 编写日期: 20151101
 * 
 * @param {}
 *            Input 输入值
 * @param {}
 *            StkGrpCode 类组编码
 * @param {}
 *            StkGrpType 类组
 * @param {}
 *            Locdr 药房
 * @param {}
 *            NotUseFlag 不启用
 * @param {}
 *            QtyFlag 数量
 * @param {}
 *            HospID 院区
 * @param {}
 *            Fn 调用界面方法句柄，用于反射调用界面的方法(传递选中行的数据Record)
 */
ShowEjPhaOrderWindow = function(ReqLocId,User,toLoc,MainData,Fn) {
	var PhaOrderUrl = 'dhcstm.drugutil.csp?actiontype=GetLocalLocInciAll'

	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["InciDr","InciItem", "InciCode", "InciDesc", "Spec","Brand",
			"ManfName", "PuomDesc", "BuomDesc", 
			"PFac",  "localstkQty","Abbrev","LocManGrpdesc","kfstkQty","PuomDr","cat","sortnum","ReRowid"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "InciItem",
				fields : fields
			});
	// 数据集
	var PhaOrderStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				sortInfo: {
                     field: 'sortnum',
                     direction: "ASC"
                }

                 //remoteSort: true //服务器端排序(可分页)
			});
      PhaOrderStore.setBaseParam('ReqLocId',ReqLocId)
      PhaOrderStore.setBaseParam('ReqUser',User)
      PhaOrderStore.setBaseParam('toLoc',toLoc)
      
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : PhaOrderStore,
				pageSize : 999,
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
				emptyMsg : "没有数据"
			});
    //PhaOrderStore.load()
	 // 规格

	var nm = new Ext.grid.RowNumberer();
	//var sm = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
	var PhaOrderCm = new Ext.grid.ColumnModel([nm,  {
				header : "ReRowid",
				dataIndex : 'ReRowid',
				width : 70,
				hidden: true,
				align : 'left',
				sortable : true
			},  {
				header : "代码",
				dataIndex : 'InciCode',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '名称',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : 'rowid',
				dataIndex : 'InciDr',
				width : 200,
				hidden:true,
				align : 'left',
				sortable : true
			} ,{
				header : "规格",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
		   	}, {
				header : "品牌",
				dataIndex : 'Brand',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'ManfName',
				width : 100,
				align : 'left',
				hidden:true,
				sortable : true
			},{
                header:"请求数量",
                dataIndex:'qty',
                id:'qty',
                width:110,
                align:'right',
                allowBlank:false,
                sortable:true
             },{
				header : '转化系数',
				dataIndex : 'PFac',
				width : 110,
				align : 'left',
				sortable : true
			},{
	            header:"大包装请求数量",
	            dataIndex:'BigRqQty',
	            width:180,
	            align:'right',
	   	        editor:new Ext.form.NumberField({
			    id:'BigRqQtyField',
                allowBlank:false,
                enableKeyEvents:true,
			    listeners:{
				specialKey:function(field, e) {
					var newValue=field.getValue();
					//alert(newValue);
					if (e.getKey() == Ext.EventObject.ENTER) {
				   
					   var cell = PhaOrderGrid.getSelectionModel().getSelectedCell();
				       var rowData = PhaOrderGrid.getStore().getAt(cell[0]);
					   
					
					   var fac=rowData.get('PFac');
					   if(fac==""||fac==null){
						  fac=1;
					   }
                       if(newValue!=0){
                    	  rowData.set("qty",newValue*fac);
                       }else{
                        rowData.set("qty","");
                        }
				
					}
					
				},
				keyup:function(curfield,e){
					   var newValue=curfield.getValue();
					  
					   var cell = PhaOrderGrid.getSelectionModel().getSelectedCell();
				       var rowData = PhaOrderGrid.getStore().getAt(cell[0]);
					   
					
					   var fac=rowData.get('PFac');
					   if(fac==""||fac==null){
						  fac=1;
					   }
                       if(newValue!=0){
                    	  rowData.set("qty",newValue*fac);
                       }else{
                          rowData.set("qty","");
                       }
                       
				}
				
		       }
            })
	       }, {
				header : '入库单位',
				dataIndex : 'PuomDesc',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'PuomDr',
				width : 80,
				align : 'left',
				hidden:true,
				sortable : true
			}, {
				header : "基本单位",
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : '通用名',
				dataIndex : 'Abbrev',
				width : 100,
				align : 'left',
				sortable : true
			},{
			   header:"本科室数量",
			   dataIndex:'localstkQty',
			   width:100,
			   align:'left'
			},{
			   header:"库房数量",
			   dataIndex:'kfstkQty',
			   width:100,
			   align:'left'
			},{
			   header:"管理组",
			   dataIndex:'LocManGrpdesc',
			   width:100,
			   align:'left'
			},{
			   header:"类型",
			   dataIndex:'cat',
			   width:100,
			   align:'left'
			},{
			   header:"位置",
			   dataIndex:'sortnum',
			   width:100,
			  // sortable : true,
			   align:'left'
			}
	]);
	PhaOrderCm.defaultSortable = true;
    var MoveUpBT= new Ext.Toolbar.Button({
	     text:'上移',
	     tooltip:'点击上移',
	     iconCls:'page_delete',
	     handler:function(){
		     var ReRowid=""
		    var cell = PhaOrderGrid.getSelectionModel().getSelectedCell();
           if(cell==null){
                Msg.info("error","请选择要上移的行!");
               return false;}
           else{ 
               var record = PhaOrderGrid.getStore().getAt(cell[0]);
               ReRowid = record.get("ReRowid");
           }
           
		  Ext.Ajax.request({
		   url : 'dhcstm.drugutil.csp?actiontype=MoveUp',
	    	params:{ReRowid:ReRowid},
	    	method : 'POST',
	     	waitMsg : '上移中...',
		   success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "上移成功!");
				PhaOrderStore.reload();
			}else{
				
					Msg.info("error", "失败!");
				
			}
		},
		scope : this
	   });
	       
	     }
    });
    var MoveDownBT= new Ext.Toolbar.Button({
	     text:'下移',
	     tooltip:'点击下移',
	     iconCls:'page_delete',
	     handler:function(){
		     var ReRowid=""
		   var cell = PhaOrderGrid.getSelectionModel().getSelectedCell();
           if(cell==null){
                Msg.info("error","请选择要下移的行!");
               return false;}
           else{ 
               var record = PhaOrderGrid.getStore().getAt(cell[0]);
                ReRowid = record.get("ReRowid");
           }
		    Ext.Ajax.request({
		   url : 'dhcstm.drugutil.csp?actiontype=MoveDown',
	    	params:{ReRowid:ReRowid},
	    	method : 'POST',
	     	waitMsg : '下移中...',
		   success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "下移成功!");
				PhaOrderStore.reload();
			}else{
				
					Msg.info("error", "失败!");
				
			}
		},
		   scope : this
	   });
	     }
    });
	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '点击关闭',
				iconCls : 'page_delete',
				handler : function() {
					flg = false;
					window.close();
				}
			});
    var SaveBT= new Ext.Toolbar.Button({
	     text:'保存',
	     tooltip:'点击保存',
	     iconCls:'page_delete',
	     handler:function(){
		     
		     var data=""
		     var dzdata=""
		     var count= PhaOrderGrid.getStore().getCount();
	         for(var index=0;index<count;index++){
		        var rec = PhaOrderStore.getAt(index);	
				//新增或数据发生变化时执行下述操作
	            if(rec.data.newRecord || rec.dirty){
			       var inc = rec.data['InciDr'];
			       var qty = rec.data['qty'];
			       var locmangrpdesc= rec.data['LocManGrpdesc'];
			       if((qty=="")||(qty==0)){
				       continue;
			       }
			       var grpdesc="常备库存";
	               if((toLoc==569)&&(locmangrpdesc==grpdesc)&&(ReqLocId!=613)){
	               	Msg.info("error","该物质属于常备库存，不能进行申购!");
		            return;
	               }
			       var desc = rec.data['InciDesc'];
			       var colRemark="";
			       var stkQty=rec.data['stkQty'];
			       var LimitQty=rec.data['LimitQty'];
			       var LocBuomQty=rec.data['LocBuomQty'];
			       var bigrqqty=rec.data['BigRqQty'];
			       var PackUomfac=rec.data['PFac'];
			       if(PackUomfac==""||PackUomfac==null){
				        PackUomfac=1;
			       }
			       var sumqty=bigrqqty*PackUomfac;
			       if((inc!="")&&(inc!=null)){
                         if(qty==0){
					        Msg.info("warning","第"+(InRequestGridDs.indexOf(rec)+1)+"行请求数量不能为空或0!");
					        return;
				          }
				         if(sumqty!=qty){
					           Msg.info("warning","第"+(InRequestGridDs.indexOf(rec)+1)+"行单位转换失败!");
					           return;
			           	 }
		
				         
				          var tmp = ""+"^"+inc+"^"+rec.data['PuomDr']+"^"+qty+"^"+colRemark+"^"+scg;
				          //var tmp = rec.data['rowid']+"^"+inc+"^"+rec.data['uom']+"^"+qty+"^"+colRemark+"^"+scg+"^"+SpecDesc;
				          var tmpstr=inc+"^"+desc+"^"+qty
				          if(data==""){
					           data = tmp;
				          }else{
					           data = data+xRowDelim()+tmp;
				          }
				          if(dzdata==""){
					           dzdata = tmpstr;
				          }else{
					
					           dzdata = dzdata+","+tmpstr;
				          }
			      }
			
		       }
	        }
	        
	       if ( data=="") {Msg.info("error", "没有内容需要保存!");return false;};
	       Ext.Ajax.request({
		   url : 'dhcstm.inrequestaction.csp?actiontype=save',
	    	params:{req:"",reqInfo:MainData,data:data},
	    	method : 'POST',
	     	waitMsg : '查询中...',
		   success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "保存成功!");
				var req = jsonData.info;
				closeBT.handler();
				Fn(req);
			}else{
				if(jsonData.info==-1){
					Msg.info("error", "主表保存失败!");
				}else if(jsonData.info==-99){
					Msg.info("error", "主表加锁失败!");
				}else if(jsonData.info==-2){
					Msg.info("error", "主表解锁失败!");
				}else if(jsonData.info==-5){
					Msg.info("error", "明细保存失败!");
				}else if(jsonData.info==-4){
					Msg.info("error", "主表单号设置失败!");
				}else if(jsonData.info==-3){
					Msg.info("error", "主表保存失败!");
				}else{
					Msg.info("error", "保存失败!");
				}
			}
		},
		scope : this
	   }); 
	        
	 }
    });
	var PhaOrderGrid = new Ext.grid.EditorGridPanel({
				id:'PhaOrderGrid',
				cm : PhaOrderCm,
				store : PhaOrderStore,
				trackMouseOver : true,
				stripeRows : true,
				sm:new Ext.grid.CellSelectionModel({singleSelect:true}),
	            viewConfig:{
		            forceFit:true,
		            getRowClass:function(record,rowindex,rowParams,store){
			           if(record.data.cat=="1"){
				           return 'RowColor';
			           }
			           
		            }
	            },
             	clicksToEdit:1,
				loadMask : true,
				tbar : [SaveBT,'-',closeBT,'-',MoveUpBT,'-',MoveDownBT],
				bbar : StatuTabPagingToolbar,
				deferRowRender : false
			});

	

	var window = new Ext.Window({
				title : '物资信息',
				width : 900,
				height : 400,
				layout : 'fit',
				plain : true,
				modal : true,
				buttonAlign : 'center',
//				autoScroll : true,
				items : PhaOrderGrid
			});
    
	window.show();
	
	gPhaOrderWindowFlag=true;	//通过全局变量控制多个window显示的问题,close时置为false
	window.on('close', function(panel) {
				gPhaOrderWindowFlag=false;
			});

	PhaOrderStore.load({
		       params:{start:0, limit:StatuTabPagingToolbar.pageSize},
				callback : function(r, options, success) {
					if (success == false) {
						Msg.info('warning','没有任何符合的记录！');
			 	       // if(window){window.close();}

					} 
				}
			});
}
