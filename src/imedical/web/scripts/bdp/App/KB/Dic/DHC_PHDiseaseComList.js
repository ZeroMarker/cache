/// 名称: 病症类型字典表
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2016-5-19
Ext.namespace("Ext.BDP.grid");

/**
 * @class Ext.BDP.grid.AliasEditorGridPanel
 * @extends Ext.grid.EditorGridPanel
 * @author 2015-01-12 by chenying
 * 说明：
 * 		1.别名维护面板
 * 		2.公共方法:
 * 			saveAlias()   ----保存别名数据(包括：修改、新增)
 * 			loadGrid()    ----加载grid数据
 * 			delAlias()    ----删除一条别名(local and remote)
 * 			clearGrid()   ----清空grid数据(local)
 * 			
 */
Ext.BDP.grid.AliasEditorGridPanel = Ext.extend(Ext.grid.EditorGridPanel,{
	
	ALIAS_QUERY_ACTION_URL : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseComList&pClassQuery=GetList",
	ALIAS_DELETE_ACTION_URL : "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseComList&pClassMethod=DeleteData",
	ALIAS_SAVE_ACTION_URL : "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseComList&pClassMethod=SaveAll",
   
	PHDCLDisDr : "", //表中数据ID
	pycode:"",
	height : 200,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask : true,
	clicksToEdit : 2,
	viewConfig : {
		forceFit : true
	},
	initComponent : function(){
        Ext.BDP.grid.AliasEditorGridPanel.superclass.initComponent.call(this);
        
        //列模型
		this.colModel = new Ext.grid.ColumnModel({
			defaultSortable : true,
			columns : [{
					header : 'PHDCLDisDr',
					hidden : true,
					dataIndex : 'PHDCLDisDr'
					
				},{
					header : 'PHDCLRowId',
					hidden : true,
					dataIndex : 'PHDCLRowId'
					
				},{
					header : this.title,
					dataIndex : 'PHDCLDesc',
					sortable : true,
					//width : 260,
					editor : new Ext.form.TextField({
						allowBlank : false,
						enableKeyEvents : true,
							validationEvent : 'blur',
                            validator : function(thisText){
	                           tpycode= tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            //Ext.getCmp("PHDCLKeyF").setValue(pycode);
	                           //alert(pycode)

                            }
					})
				},{
					header : '拼音码',
					dataIndex : 'PHDCLKey',
					sortable : true,
					//width : 180,
					editor : new Ext.form.TextField({
						//allowBlank : false
					})
				}]
		});
		
        //store存储
        this.store = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
				url : this.ALIAS_QUERY_ACTION_URL
			}),
		    reader : new Ext.data.JsonReader({
		        totalProperty : 'total',
		        root : 'data', 
		        successProperty : 'success'
		    }, [{
		            name : 'PHDCLDisDr',
		            type : 'string'
		         },{
		            name : 'PHDCLRowId',
		            type : 'string' 
		         },{
		         	name : 'PHDCLDesc',
		            type : 'string'
		         },{
		         	name : 'PHDCLKey',
		            type : 'string'
		         }
		    ]),
		    pruneModifiedRecords : true,
		    remoteSort : false
		});
		
		//工具条
		this.tbar = new Ext.Toolbar({
			items : [{
				id : 'btn_AliasAdd'+this.type,
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AliasAdd'),
				text : '添加',
				iconCls : 'icon-add',
				handler : function(e){
					//alert(e.id)
					this.addNewRow();
				},
				scope : this
			},'-',{
				id : 'btn_AliasDel'+this.type,
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AliasDel'),
      			text : '删除',
				iconCls : 'icon-delete',
				handler : function(){
					this.delAlias();
				},
				scope : this
			}]
		});
		this.elements += ',tbar';
        this.topToolbar = this.createToolbar(this.tbar);
        this.tbar = null;
		
        if(!this.selModel){
            this.selModel = new Ext.grid.CellSelectionModel();
        }
        this.activeEditor = null;
        this.addEvents(
            "beforeedit",
            "afteredit",
            "validateedit"
        );
    },
    
    onEditComplete : function(ed, value, startValue){
    	this.validate(ed, value, startValue);
    	
        this.editing = false;
        this.lastActiveEditor = this.activeEditor;
        this.activeEditor = null;

        var r = ed.record,
            field = this.colModel.getDataIndex(ed.col);
        value = this.postEditValue(value, startValue, r, field);
        if(this.forceValidation === true || String(value) !== String(startValue)){
            var e = {
                grid: this,
                record: r,
                field: field,
                originalValue: startValue,
                value: value,
                row: ed.row,
                column: ed.col,
                cancel:false
            };
            if(this.fireEvent("validateedit", e) !== false && !e.cancel && String(value) !== String(startValue)){
                r.set(field, e.value);
                delete e.cancel;
                this.fireEvent("afteredit", e);
            }
        }
        this.view.focusCell(ed.row, ed.col);
    },
    
    validate : function(ed, value, startValue){
    	var idx = ed.row;
    	for(var i=0; i<this.store.getCount(); i++){
    		if(idx==i) continue;
    		var tmpRec = this.store.getAt(i);
    		if(tmpRec.data["PHDCLDesc"]==value){
    			Ext.Msg.show({
    				title : '提示',
    				msg : '该别名已经存在, 请重新输入!',
    				minWidth : 200,
    				icon : Ext.Msg.ERROR,
    				buttons : Ext.Msg.OK,
    				fn : function(btn){
    					this.startEditing(idx, 2);
    				},
    				scope : this
    			});
    			break;
    		}
    	}
    	return;
    },
    
	clearGrid : function(){	
		this.store.removeAll();
	},
	
	addNewRow : function() {
	
		var record = Ext.data.Record.create([{
				name:'PHDCLDisDr',
				type:'string'
			},{
				name: 'PHDCLRowId',
				type: 'string' 
			},{
				name: 'PHDCLDesc',
				type:'string'
			},{
				name: 'PHDCLKey',
				type:'string'
			}
	    ]);
	    var NewRecord = new record({
	    	//PHDCLDisDr : '',
			PHDCLRowId : '',			
			PHDCLDesc : '',
			PHDCLKey : ''
		});
		this.store.insert(0, NewRecord);
		this.startEditing(0, 2);
		//alert(3)
	},
	
    delAlias : function(){
    	var seleCell = this.getSelectionModel().getSelectedCell();
		if(seleCell==null){
			Ext.Msg.show({
				title:'提示',
				minWidth:240,
				msg:'请选择需要删除的别名!',
				icon:Ext.Msg.WARNING,
				buttons:Ext.Msg.OK
			}); 
			return false;
		}else{
			var record = this.store.getAt(seleCell[0]);
            var RowId = record.get("PHDCLRowId");
            if(RowId!=""){
                Ext.MessageBox.confirm('提示', '确定要删除该别名?', function(btn){
                    if(btn == 'yes'){
                        Ext.MessageBox.wait('别名删除中,请稍候...', '提示');
                        Ext.Ajax.request({
                            url : this.ALIAS_DELETE_ACTION_URL,
                            params : {'id' : RowId},
                            failure: function(result, request) {
								Ext.MessageBox.hide();
								Ext.Msg.show({
									title:'提示',
									minWidth:240,
									msg:'请检查网络连接!',
									icon:Ext.Msg.WARNING,
									buttons:Ext.Msg.OK
								});
                            },
                            success: function(result, request) {
                                var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
                                   Ext.MessageBox.hide();
                                   Ext.Msg.show({
		                               title:'提示',
		                               minWidth:240,
		                               msg:'别名删除成功!',
		                               icon:Ext.Msg.WARNING,
		                               buttons:Ext.Msg.OK
                                    });
                                    this.store.removeAt(seleCell[0]);
								}else{
									Ext.Msg.show({
										title:'提示',
										minWidth:240,
										msg:'别名删除失败!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});
								}
							},
							scope : this
						});
					}
				},this);
			}else{
			    var rowInd = seleCell[0];
			    if (rowInd>=0) this.store.removeAt(rowInd);                        
			}
		}
	},
    
	loadGrid : function(){
		
			if(this.PHDCLDisDr){
				this.store.load({
					params : {
						dis : this.PHDCLDisDr,
						type:this.type
					}
				});
			}else{
				Ext.Msg.show({
					title:'提示',
					minWidth:240,
					msg:'AliasEditorGridPanel控件的PHDCLDisDr属性为空,请查看原因!',
					icon:Ext.Msg.ERROR,
					buttons:Ext.Msg.OK
				});
				return;
			}
		
	},
	
	saveAlias : function(){
		var modiRec = this.store.getModifiedRecords();
		var data = "";
		var type=this.type
		var PHDCLDisDr = this.PHDCLDisDr;
		for(var i=0; i<modiRec.length; i++){
			var RowId = modiRec[i].data['PHDCLRowId'].trim();			
			var Alias = modiRec[i].data["PHDCLDesc"].trim();
			var key = modiRec[i].data["PHDCLKey"].trim();
			
			if(Alias!=""){
				var dataRow = RowId+"^"+Alias+"^"+PHDCLDisDr+"^"+type+"^"+key;
				if(data==""){
					data = dataRow;
				}else{
					data += "#"+dataRow;
				}
			}
		}
		if(data==""){
          
            return false;
        }else{
            Ext.Ajax.request({
                url : this.ALIAS_SAVE_ACTION_URL,
                params : {listData : data},
                failure : function(result, request) {
                	Ext.Msg.show({
						title:'提示',
						minWidth:240,
						msg:'请检查网络连接!',
						icon:Ext.Msg.ERROR,
						buttons:Ext.Msg.OK
					});
                },
                success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if(jsonData.success=='true') {
                      
                    }else{
						Ext.Msg.show({
							title:'提示',
							minWidth:240,
							msg:"保存别名失败!错误信息："+jsonData.info,
							icon:Ext.Msg.ERROR,
							buttons:Ext.Msg.OK
						});
                    }
                },
                scope: this
            });
        }
	}
});
Ext.BDP.grid.ComEditorGridPanel = Ext.extend(Ext.grid.EditorGridPanel,{
	
	ALIAS_QUERY_ACTION_URL : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseComList&pClassQuery=GetList",
	ALIAS_DELETE_ACTION_URL : "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseComList&pClassMethod=DeleteData",
	ALIAS_SAVE_ACTION_URL : "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseComList&pClassMethod=SaveAll",
   
	PHDCLDisDr : "", //表中数据ID
	height : 200,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask : true,
	clicksToEdit : 2,
	viewConfig : {
		forceFit : true
	},
	initComponent : function(){
        Ext.BDP.grid.ComEditorGridPanel.superclass.initComponent.call(this);
        
        //列模型
		this.colModel = new Ext.grid.ColumnModel({
			defaultSortable : true,
			columns : [{
					header : 'PHDCLDisDr',
					hidden : true,
					dataIndex : 'PHDCLDisDr'
					
				},{
					header : 'PHDCLRowId',
					hidden : true,
					dataIndex : 'PHDCLRowId'
					
				},{
					header : this.title,
					dataIndex : 'PHDCLDesc',
					sortable : true,
					//width : 260,
					editor : new Ext.form.TextField({
						allowBlank : false
					})
				},{
					header : '拼音码',
					dataIndex : 'PHDCLKey',
					sortable : true,
					//width : 180,
					editor : new Ext.form.TextField({
						//allowBlank : false
					})
				}]
		});
		
        //store存储
        this.store = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
				url : this.ALIAS_QUERY_ACTION_URL
			}),
		    reader : new Ext.data.JsonReader({
		        totalProperty : 'total',
		        root : 'data', 
		        successProperty : 'success'
		    }, [{
		            name : 'PHDCLDisDr',
		            type : 'string'
		         },{
		            name : 'PHDCLRowId',
		            type : 'string' 
		         },{
		         	name : 'PHDCLDesc',
		            type : 'string'
		         },{
		         	name : 'PHDCLKey',
		            type : 'string'
		         }
		    ]),
		    pruneModifiedRecords : true,
		    remoteSort : false
		});
		
		//工具条
		this.tbar = new Ext.Toolbar({
			items : [{
				id : 'btn_AliasAdd'+this.type,
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AliasAdd'),
				text : '添加',
				iconCls : 'icon-add',
				handler : function(e){
					//alert(e.id)
					this.addNewRow();
				},
				scope : this
			},'-',{
				id : 'btn_AliasDel'+this.type,
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AliasDel'),
      			text : '删除',
				iconCls : 'icon-delete',
				handler : function(){
					this.delAlias();
				},
				scope : this
			}]
		});
		this.elements += ',tbar';
        this.topToolbar = this.createToolbar(this.tbar);
        this.tbar = null;
		
        if(!this.selModel){
            this.selModel = new Ext.grid.CellSelectionModel();
        }
        this.activeEditor = null;
        this.addEvents(
            "beforeedit",
            "afteredit",
            "validateedit"
        );
    },
    
    onEditComplete : function(ed, value, startValue){
    	this.validate(ed, value, startValue);
    	
        this.editing = false;
        this.lastActiveEditor = this.activeEditor;
        this.activeEditor = null;

        var r = ed.record,
            field = this.colModel.getDataIndex(ed.col);
        value = this.postEditValue(value, startValue, r, field);
        if(this.forceValidation === true || String(value) !== String(startValue)){
            var e = {
                grid: this,
                record: r,
                field: field,
                originalValue: startValue,
                value: value,
                row: ed.row,
                column: ed.col,
                cancel:false
            };
            if(this.fireEvent("validateedit", e) !== false && !e.cancel && String(value) !== String(startValue)){
                r.set(field, e.value);
                delete e.cancel;
                this.fireEvent("afteredit", e);
            }
        }
        this.view.focusCell(ed.row, ed.col);
    },
    
    validate : function(ed, value, startValue){
    	var idx = ed.row;
    	for(var i=0; i<this.store.getCount(); i++){
    		if(idx==i) continue;
    		var tmpRec = this.store.getAt(i);
    		if(tmpRec.data["PHDCLDesc"]==value){
    			Ext.Msg.show({
    				title : '提示',
    				msg : '该常用名已经存在, 请重新输入!',
    				minWidth : 200,
    				icon : Ext.Msg.ERROR,
    				buttons : Ext.Msg.OK,
    				fn : function(btn){
    					this.startEditing(idx, 2);
    				},
    				scope : this
    			});
    			break;
    		}
    	}
    	return;
    },
    
	clearGrid : function(){	
		this.store.removeAll();
	},
	
	addNewRow : function() {
	
		var record = Ext.data.Record.create([{
				name:'PHDCLDisDr',
				type:'string'
			},{
				name: 'PHDCLRowId',
				type: 'string' 
			},{
				name: 'PHDCLDesc',
				type:'string'
			},{
				name: 'PHDCLKey',
				type:'string'
			}
	    ]);
	    var NewRecord = new record({
	    	//PHDCLDisDr : '',
			PHDCLRowId : '',			
			PHDCLDesc : '',
			PHDCLKey : ''
		});
		this.store.insert(0, NewRecord);
		this.startEditing(0, 2);
		//alert(3)
	},
	
    delAlias : function(){
    	var seleCell = this.getSelectionModel().getSelectedCell();
		if(seleCell==null){
			Ext.Msg.show({
				title:'提示',
				minWidth:240,
				msg:'请选择需要删除的常用名!',
				icon:Ext.Msg.WARNING,
				buttons:Ext.Msg.OK
			}); 
			return false;
		}else{
			var record = this.store.getAt(seleCell[0]);
            var RowId = record.get("PHDCLRowId");
            if(RowId!=""){
                Ext.MessageBox.confirm('提示', '确定要删除该常用名?', function(btn){
                    if(btn == 'yes'){
                        Ext.MessageBox.wait('常用名删除中,请稍候...', '提示');
                        Ext.Ajax.request({
                            url : this.ALIAS_DELETE_ACTION_URL,
                            params : {'id' : RowId},
                            failure: function(result, request) {
								Ext.MessageBox.hide();
								Ext.Msg.show({
									title:'提示',
									minWidth:240,
									msg:'请检查网络连接!',
									icon:Ext.Msg.WARNING,
									buttons:Ext.Msg.OK
								});
                            },
                            success: function(result, request) {
                                var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
                                   Ext.MessageBox.hide();
                                   Ext.Msg.show({
		                               title:'提示',
		                               minWidth:240,
		                               msg:'常用名删除成功!',
		                               icon:Ext.Msg.WARNING,
		                               buttons:Ext.Msg.OK
                                    });
                                    this.store.removeAt(seleCell[0]);
								}else{
									Ext.Msg.show({
										title:'提示',
										minWidth:240,
										msg:'常用名删除失败!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});
								}
							},
							scope : this
						});
					}
				},this);
			}else{
			    var rowInd = seleCell[0];
			    if (rowInd>=0) this.store.removeAt(rowInd);                        
			}
		}
	},
    
	loadGrid : function(){
		
			if(this.PHDCLDisDr){
				this.store.load({
					params : {
						dis : this.PHDCLDisDr,
						type:this.type
					}
				});
			}else{
				Ext.Msg.show({
					title:'提示',
					minWidth:240,
					msg:'AliasEditorGridPanel控件的PHDCLDisDr属性为空,请查看原因!',
					icon:Ext.Msg.ERROR,
					buttons:Ext.Msg.OK
				});
				return;
			}
		
	},
	
	saveAlias : function(){
		var modiRec = this.store.getModifiedRecords();
		var data = "";
		var type=this.type
		var PHDCLDisDr = this.PHDCLDisDr;
		for(var i=0; i<modiRec.length; i++){
			var RowId = modiRec[i].data['PHDCLRowId'].trim();			
			var Alias = modiRec[i].data["PHDCLDesc"].trim();
			var key = modiRec[i].data["PHDCLKey"].trim();
			if(Alias!=""){
				var dataRow = RowId+"^"+Alias+"^"+PHDCLDisDr+"^"+type+"^"+key;
				if(data==""){
					data = dataRow;
				}else{
					data += "#"+dataRow;
				}
			}
		}
		if(data==""){
          
            return false;
        }else{
            Ext.Ajax.request({
                url : this.ALIAS_SAVE_ACTION_URL,
                params : {listData : data},
                failure : function(result, request) {
                	Ext.Msg.show({
						title:'提示',
						minWidth:240,
						msg:'请检查网络连接!',
						icon:Ext.Msg.ERROR,
						buttons:Ext.Msg.OK
					});
                },
                success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if(jsonData.success=='true') {
                      
                    }else{
						Ext.Msg.show({
							title:'提示',
							minWidth:240,
							msg:"保存常用名失败!错误信息："+jsonData.info,
							icon:Ext.Msg.ERROR,
							buttons:Ext.Msg.OK
						});
                    }
                },
                scope: this
            });
        }
	}
})

