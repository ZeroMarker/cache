/// 名称: 管制药品分类权限按钮
/// 描述: 新建医护人员关联管制药品分类表
/// 编写者： 基础数据平台-李可凡
/// 编写日期: 2020年3月23日

	function GetPoisonWin(objectName,objectId,callback){
	    var _Poisongridds = new Ext.data.Store({
	                proxy : new Ext.data.HttpProxy({
	                	url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProvPHCPoison&pClassQuery=GetPHCPoison" }),
	                reader : new Ext.data.JsonReader({
	                            totalProperty : 'total',
	                            root : 'data',
	                            successProperty : 'success'
	                        }, [{name : 'PHCPORowId', mapping : 'PHCPORowId', type : 'string' }, 
	                            {name : 'PHCPODesc',mapping : 'PHCPODesc',type : 'string'},
	                            {name : 'LinkFlag',mapping : 'LinkFlag',type : 'string' }
	                        ]) 
	     });
	     
	   var gridsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : false, checkOnly : false, width : 20,
				listeners:{
					rowdeselect : function( e ,  rowIndex , record  ) 
					{ _PoisongridObj.getStore().getAt(rowIndex).set("LinkFlag","N") },    //当反选一个行时触发
					rowselect : function(  e ,  rowIndex , record ) 
					{ _PoisongridObj.getStore().getAt(rowIndex).set("LinkFlag","Y") }   //当选中一行数据时触发 
				}
		});
		
	    var _PoisongridObj = new Ext.grid.GridPanel({
	                region : 'center',
	                width : 550,
	                height : 350,
	                closable : true,
	                store : _Poisongridds,
	                trackMouseOver : true,
	                columnLines : true, //在列分隔处显示分隔符
	                sm:gridsm,
	                columns : [gridsm,
	                       	{header : '是否关联', width : 80,sortable : true, dataIndex : 'LinkFlag',hidden:true}, 
	                        {header : 'PHCPORowId',width : 80, sortable : true, dataIndex : 'PHCPORowId',hidden:true},
	                        {header : '管制药品分类', width : 160, sortable : true, dataIndex : 'PHCPODesc'}],
	                stripeRows : true ,
	                stateful : true,
	                viewConfig : {
	                    forceFit : true
	                }
	            });
	        
		var obj = new Ext.Window({
		        title : '管制药品分类权限',
		        width : 550,
		        height : 350,
		        layout : 'fit',
		        plain : true, 
		        modal : true,
		        frame : true,
		        //autoScroll : true,
		        collapsible : true,
		        hideCollapseTool : true,
		        titleCollapse : true,
		        bodyStyle : 'padding:3px',
		        constrain : true,
		        closeAction : 'hide',
		        buttonAlign : 'center',
		        items : [_PoisongridObj],
		        buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						handler : function() {	
							var linkstr="";
						    _PoisongridObj.getStore().each(function(record){
								if(linkstr!="") linkstr = linkstr+"^";
								linkstr = linkstr+record.get('PHCPORowId')+'$'+record.get('LinkFlag');
						    }, this);
						    Ext.Ajax.request({
								url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProvPHCPoison&pClassMethod=UpdatePoison",
								method:'POST',
								params:{
									'parref':objectId,
									'poisonids':linkstr
								},
								callback : function(options, success, response) {
									if (success) {
										//obj.hide();
										Ext.Msg.show({
											title:'提示',
											msg:'保存成功!',
											icon:Ext.Msg.INFO,
											buttons:Ext.Msg.OK
										});
										if ("function" == typeof callback) callback() //调用回调函数
									} 
									else {
										Ext.Msg.show({
													title : '提示',
													msg : '异步通讯失败,请检查网络连接！',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								}
							});  
						}
					}, {
						text : '关闭',
						iconCls : 'icon-close',
						handler : function() {
							obj.hide();
						}
				}],
		        listeners : {
                        "show" : function(){
                                _PoisongridObj.getStore().baseParams={parref : objectId };
								_PoisongridObj.getStore().load({
										scope: this,
										callback : function(records, options, success) {
											var records=[];//存放选中记录  
											for(var i=0;i<_PoisongridObj.getStore().getCount();i++){  
												var record = _PoisongridObj.getStore().getAt(i);  
												if(record.data.LinkFlag=='Y'){ records.push(record);   }  
											}  
											gridsm.selectRecords(records);//执行选中已对照的记录  
										}
								});              
                        }
                    }
		    });
		    return obj;
	}
	
	///管制药品分类权限按钮
	function GetPoisonWinButton(callback){
		var btnobj = new Ext.Toolbar.Button({
			text : '管制药品分类权限',
			iconCls : 'button-example',
			hidden:HospListHiddenFlag,  
			handler : function() {
				if ("function" == typeof callback) callback() //调用回调函数
			}
		});
		return btnobj;
	}