//别名维护面板
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
	
	ALIAS_QUERY_ACTION_URL : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationAlias&pClassQuery=GetList",
	ALIAS_DELETE_ACTION_URL : "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperationAlias&pClassMethod=DeleteData",
	ALIAS_SAVE_ACTION_URL : "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperationAlias&pClassMethod=SaveAll",
   
	title : "别名",
	ALIASParRef : "", //表中数据ID
	height : 200,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask : true,
	clicksToEdit : 2,
	
	initComponent : function(){
        Ext.BDP.grid.AliasEditorGridPanel.superclass.initComponent.call(this);
        
        //列模型
		this.colModel = new Ext.grid.ColumnModel({
			defaultSortable : true,
			columns : [{
					header : 'ALIASParRef',
					hidden : true,
					dataIndex : 'ALIASParRef'
					
				},{
					header : 'ALIASRowId',
					hidden : true,
					dataIndex : 'ALIASRowId'
					
				},{
					header : "别名",
					dataIndex : 'ALIASText',
					sortable : true,
					width : 450,
					editor : new Ext.form.TextField({
						id : 'ALIASText',
						allowBlank : false
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
		            name : 'ALIASParRef',
		            type : 'string'
		         },{
		            name : 'ALIASRowId',
		            type : 'string' 
		         },{
		         	name : 'ALIASText',
		            type : 'string'
		         }
		    ]),
		    pruneModifiedRecords : true,
		    remoteSort : false
		});
		
		//工具条
		this.tbar = new Ext.Toolbar({
			items : [{
				id : 'btn_AliasAdd',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AliasAdd'),
				text : '添加',
				iconCls : 'icon-add',
				handler : function(){
					this.addNewRow();
				},
				scope : this
			},'-',{
				id : 'btn_AliasDel',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AliasDel'),
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
		re= /select|update|delete|exec|count|'|"|=|;|>|<|%/i; // 防止SQL注入  
		if (re.test(value)){  
			Ext.Msg.show({
					title : '提示',
					msg : '请勿输入非法字符,请重新输入!',
					minWidth : 200,
					icon : Ext.Msg.ERROR,
					buttons : Ext.Msg.OK   
			});
			value="";
			this.startEditing(ed.row, 2);
		}
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
    		if(tmpRec.data["ALIASText"]==value){
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
		/// 清空国家标准编码数据
		Ext.BDP.ResetFormFun(this.TableN);
		this.store.removeAll();
	},
	
	addNewRow : function() {
		var record = Ext.data.Record.create([{
				name:'ALIASParRef',
				type:'string'
			},{
				name: 'ALIASRowId',
				type: 'string' 
			},{
				name: 'ALIASText',
				type:'string'
			}
	    ]);
		var NewRecord = new record({
			ALIASRowId : '',
			ALIASText : ''
		});
		var cnt=this.store.data.items.length;
		if (cnt>0){  	 
			var value=this.store.data.items[0].data.ALIASText;  
			if ((value=="")||(value==null)){
				Ext.Msg.show({
					title:'提示',
					minWidth:240,
					msg:'别名列表已存在新建的行!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				}); 
				return false;
			}
			else{
				this.store.insert(0, NewRecord);
				this.startEditing(0, 2);  
			}
		}
		else{
			this.store.insert(0, NewRecord);
			this.startEditing(0, 2);   
		} 
	},
	
    delAlias : function(){
    	/// 删除国家标准编码数据
		Ext.BDP.DeleteFormFun(this.TableN,this.ALIASParRef);
		
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
            var RowId = record.get("ALIASRowId");
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
		
			if(this.ALIASParRef){
				this.store.load({
					params : {
						aliasparref : this.ALIASParRef
					}
				});
				/// 加载国家标准编码数据
			    Ext.BDP.OpenNationalCodeFun(this.TableN,this.ALIASParRef);
			}else{
				Ext.Msg.show({
					title:'提示',
					minWidth:240,
					msg:'AliasEditorGridPanel控件的ALIASParRef属性为空,请查看原因!',
					icon:Ext.Msg.ERROR,
					buttons:Ext.Msg.OK
				});
				return;
			}
		
	},
	
	saveAlias : function(){
		//// 保存国家标准编码
		Ext.BDP.NationalCodeModFun(this.TableN,this.ALIASParRef)
		
		var modiRec = this.store.getModifiedRecords();
		var data = "";
		for(var i=0; i<modiRec.length; i++){
			var RowId = modiRec[i].data['ALIASRowId'].trim();
			
			var Alias = modiRec[i].data["ALIASText"].trim();
			var ALIASParRef = this.ALIASParRef;
			if(Alias!=""){
				var dataRow = RowId+"^"+Alias+"^"+ALIASParRef;
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
})
