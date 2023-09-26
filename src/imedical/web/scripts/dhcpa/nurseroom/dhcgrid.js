
Ext.ns('Ext.ux.grid');

Ext.ux.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if(!this.id){
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.ux.grid.CheckColumn.prototype ={
    init : function(grid){
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },

    onMouseDown : function(e, t){
        if(Ext.fly(t).hasClass(this.createId())){
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);
            record.set(this.dataIndex, !record.data[this.dataIndex]);
        }
    },

    renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'||v==true?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    },
    
    createId : function(){
        return 'x-grid3-cc-' + this.id;
    }
};

// register ptype
Ext.preg('checkcolumn', Ext.ux.grid.CheckColumn);

// backwards compat
Ext.grid.CheckColumn = Ext.ux.grid.CheckColumn;










Ext.ns("Dhc.ca");

 var checkColumn = new Ext.grid.CheckColumn({
       header: '有效标记',
       dataIndex: 'active',
       width: 55
    });

	
	
Ext.grid.Column.types = {
    gridcolumn : Ext.grid.Column,
    booleancolumn: Ext.grid.BooleanColumn,
    numbercolumn: Ext.grid.NumberColumn,
    datecolumn: Ext.grid.DateColumn,
    templatecolumn: Ext.grid.TemplateColumn,
	checkcolumn:Ext.ux.grid.CheckColumn
};


Dhc.ca.Grid = Ext.extend(Ext.grid.EditorGridPanel, {
    edit: true,
    trackMouseOver: true,
	tb:false,              //是否创建tBar
    stripeRows: true,
    readerModel: 'remote', //store reader类型 默认为远程
    //sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
	urlParam:{},
	forms:[],
    pageSize: 25,
	dateFields:[],
    atLoad: true, //是否自动刷新
    initComponent: function(){
		
        this.createColumns();
        this.createStore();
        this.createBbar();
		if(this.tb)this.createTbar();
        this.createSm();
		//this.createPlugins();
        if (this.atLoad) {
            this.bbar.doRefresh();
        }
		Dhc.ca.Grid.superclass.initComponent.call(this);
    },
	createPlugins: function(){
		var plugins=[];
		if(!Ext.isEmpty(this.plugins)){
			var plugins=this.plugins;
		}
		plugins.push(checkColumn);
		plugins.push(Dhc.ca.GridTip);
		this.plugins=plugins;   
	},
    defaultfiles: {
        hidden: false,
		dataIndex:'rowid',
		allowBlank: true,
		params:'',
		editable:true,
		tip:false,
		width:80,
		align: 'left',
        sortable: true
    },
    createColumns: function(){
		
        var tmpfiels = [];
        var cols = [new Ext.grid.RowNumberer()];
        for (var i = 0; i < this.fields.length; i++) {
            var tmpObj = this.fields[i];
			
			
            //columns模型-[0:名称,1:index,2:类型,3:是否可编辑,4:是否可为空]  下午继续这里
            tmpObj = Ext.applyIf(tmpObj, this.defaultfiles);
		
			
            cols.push(tmpObj);
			
            //组合fiels
            tmpfiels.push({name:tmpObj.dataIndex,tip:tmpObj.tip,header:tmpObj.header});
            
            //如果为可编辑Grid
            if (this.edit) {
                if (tmpObj.type instanceof Object) {
					if("combo"===tmpObj.type.getXType()){
						cols[i + 1].renderer = Dhc.ca.ComboRender;
					}
                    cols[i + 1].editor = tmpObj.type;
					cols[i + 1].width= tmpObj.width;
                }
                else 
                    if (tmpObj.type == "dateField") {
						//tmpDate.push(tmpObj.dataIndex);
						this.dateFields.push(tmpObj.dataIndex);
                        cols[i + 1].renderer = function(v, p, r,i){ 
							
				
						if(v instanceof Date){   
					
							return new Date(v).format("Y-m-d");   
						}
						else{   
							return v;   
							 
						} 
			
						};
                        
                        cols[i + 1].editor = new Ext.form.DateField({
							fieldLabel:tmpObj.header,
							id:tmpObj.dataIndex,
							anchor: '90%',
							allowBlank:tmpObj.allowBlank,
							hidden:tmpObj.hidden,
                            format: 'Y-m-d',
                            disabledDays: [0, 6],
                            disabledDaysText: 'Plants are not available on the weekends'
                        });
                    }
                    else 
                        if (tmpObj.type == "combo") {
							var tmpParams=Ext.urlEncode(tmpObj.params);
							cols[i + 1].editor = new Ext.form.ComboBox({
								anchor: '90%',
								listWidth : 260,
								store: new Ext.data.Store({
									proxy: new Ext.data.HttpProxy({url:this.url+'?action=listCombo&'+tmpParams,method:'GET'}),     
									reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
								}),
								valueField: 'rowid',
								displayField: 'name',
								fieldLabel:tmpObj.header,
								id:tmpObj.dataIndex,
								triggerAction: 'all',
								pageSize: 10,
								hidden:tmpObj.hidden,
								allowBlank:tmpObj.allowBlank,
								minChars: 1,
								selectOnFocus: true,
								forceSelection: true,
								load: function(param){
									if(!Ext.isEmpty(param))this.getStore().baseParams=param.params;
									this.getStore().load({params:{start:0, limit:this.pageSize}});
								}
							});
							cols[i + 1].renderer = Dhc.ca.ComboRender;
                        }
					else
						if(tmpObj.type == "numberField"){
							cols[i + 1].xtype='numbercolumn';
							cols[i + 1].align='right';
							cols[i + 1].editor = new Ext.form.NumberField({
								fieldLabel:tmpObj.header,
								hidden:tmpObj.hidden,
								anchor: '90%',
								id:tmpObj.dataIndex,
								allowBlank:tmpObj.allowBlank
							})
						}
					else
						if(tmpObj.type == "checkBox"){
							cols[i + 1]=checkColumn;
						}
                        else {
                            cols[i + 1].editor = new Ext.form.TextField({
								fieldLabel:tmpObj.header,
								anchor: '90%',
								hidden:tmpObj.hidden,
								id:tmpObj.dataIndex,
								allowBlank:tmpObj.allowBlank
							})
                        }
            }
            //非可编辑Grid
            else {
                if (tmpObj.type == "dateField") {
                    cols[i + 1].renderer = Ext.util.Format.dateRenderer('Y-m-d');
                }
            }
        }
        
        //cols.push(checkColumn);
        this.cm = new Ext.grid.ColumnModel(cols);

        this.fields = tmpfiels;
    },
    createStore: function(){
        //  本地 
        if (this.readerModel == 'local') {
            this.store = new Ext.data.Store({
                proxy: new Ext.data.MemoryProxy(this.data),
                reader: new Ext.data.ArrayReader({
                    fields: this.fields
                })
            });
        }
        // 远程 
        else 
            if (this.readerModel == 'remote') {
                this.store = new Ext.data.Store({
                    proxy: new Ext.data.HttpProxy({
                        url: this.url + '?action=list' 
                    }),
                    reader: new Ext.data.JsonReader({
                        root: 'rows',
                        totalProperty: 'results'
                    }, this.fields),
                    remoteSort: true
                });
            }
            else {
                alert("请填写Store类型!");
            }
        
    },
    createBbar: function(){
        this.bbar = new Ext.PagingToolbar({//分页工具栏
            pageSize: this.pageSize,
            store: this.store,
            displayInfo: true,
			plugins:new Dhc.ca.PageSizePlugin(),
            displayMsg: '当前显示{0} - {1}，共计{2}',
            emptyMsg: "没有数据"
        });
    },
	hiddenButton:function(index){
		//index=index-1;
		var tbar=this.getTopToolbar();
		var tbutton=tbar.get(index);
		//alert(tbutton.hidden);
		tbutton.setVisible(tbutton.hidden);
	},
	addButton:function(btn){
		var tbar=this.getTopToolbar();
		tbar.add(btn);
	},
    add: function(){
        var store = this.store;
        if (store.recordType) {
            var rec = new store.recordType({
                newRecord: true
            });
            rec.fields.each(function(f){
                if (f.defaultValue != null) {
                    rec.data[f.name] = f.defaultValue;
				
                }
            });
            rec.commit();
            store.add(rec);
            return rec;
        }
        return false;
    },
	del:function(){
		var tmpUrl=this.url;
		var tmpG=this;
        var records = this.getSelectionModel().getSelections();
		Ext.MessageBox.confirm('提示', 
    	    '确定要删除选定的行?', 
    	    function(btn) {
	    	    if(btn == 'yes')
		        {	
					Ext.each(records, function(record){   		
						     Ext.Ajax.request({
					              url: tmpUrl +'?action=del&rowid='+record.get("rowid"),
												waitMsg:'删除中...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
													Ext.MessageBox.alert('提示', '删除完成');
											    			tmpG.load({params:{start:0, limit:tmpG.pageSize}});
									    			}
									    			else {
									    					var message = "SQLErr: " + jsonData.info;
									    					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									    			}
												},
					               scope: this
					          });
			        });	
			    }
		    } 
		);
	},
    createTbar: function(){
		var buttons=[];
		if(!Ext.isEmpty(this.tbar))buttons.push(this.tbar);
		
        buttons.push(["-",{
            text: '增加',
            //iconCls: 'icon-form-add',
            listeners: {
                click: {
                    scope: this,
                    fn: this.add,
                    buffer: 200
                }
            }
        }, '-',{
            text: '删除',
            listeners: {
                click: {
                    scope: this,
                    fn:this.del,
                    buffer: 200
                }
            }
        
        }, '-',{
            text: '保存',
            id: 'ChronicSaveId',
            tooltip: '保存所有更改',
            scope: this,
            handler: this.save

        }, '-',{
            text: '重置',
            tooltip: '撤销所有更改',
            //iconCls:'icon-undo',
            scope: this,
            handler: function(){
                this.store.rejectChanges();
            }
        }])
		this.tbar = buttons;
    },
    createSm: function(){
    
        this.sm = new Ext.grid.CheckboxSelectionModel({
            moveEditorOnEnter: true,
            //------------------------------
            onEditorKey: function(field, e){
                var k = e.getKey(), newCell, g = this.grid, last = g.lastEdit, ed = g.activeEditor, ae, last, r, c;
                var shift = e.shiftKey;
       
                if (k == e.TAB) {
                    e.stopEvent();
                    ed.completeEdit();
				
                    if (shift) {
                        newCell = g.walkCells(ed.row, ed.col - 1, -1, this.acceptsNav, this);
                    }
                    else {
                        newCell = g.walkCells(ed.row, ed.col + 1, 1, this.acceptsNav, this);
						
                    }
                    if (ed.col == this.grid.fields.length && ed.row == g.getStore().getCount() - 1) {
                        g.add();
                        newCell = g.walkCells(ed.row + 1, 1, 1, this.acceptsNav, this);
                    }
                }
                else 
                    if (k == e.RIGHT) {
                        e.stopEvent();
                        ed.completeEdit();
                        if (shift) {
                            newCell = g.walkCells(ed.row, ed.col - 1, -1, this.acceptsNav, this);
                        
                        }
                        else {
                            newCell = g.walkCells(ed.row, ed.col + 1, 1, this.acceptsNav, this);
                        }
                        if (ed.col == this.grid.fields.length && ed.row == g.getStore().getCount() - 1) {
                            g.add();
                            newCell = g.walkCells(ed.row + 1, 1, 1, this.acceptsNav, this);
                        }
                    }
                    else 
                        if (k == e.LEFT) {
                            e.stopEvent();
                            ed.completeEdit();
                            if (shift) {
                                newCell = g.walkCells(ed.row, ed.col - 1, -1, this.acceptsNav, this);
                            }
                            else {
                                newCell = g.walkCells(ed.row, ed.col - 1, 1, this.acceptsNav, this);
                            }
                        }
                if (newCell) {
                    r = newCell[0];
                    c = newCell[1];
                    
                    if (last.row != r) {
                        this.selectRow(r); // *** highlight newly-selected cell and update selection
                    }
                    
                    if (g.isEditor && g.editing) { // *** handle tabbing while editorgrid is in edit mode
                        ae = g.activeEditor;
                        if (ae && ae.field.triggerBlur) {
                            // *** if activeEditor is a TriggerField, explicitly call its triggerBlur() method
                            ae.field.triggerBlur();
                        }
                    }
                    g.startEditing(r, c);
                }
                
                
            }
            //------------------------------
        });
    },
    save: function(){
		var forms=this.forms;
		var flag=Ext.each(forms, function(i){
			if(i.getXType()==='form'){
				return i.getForm().isValid();
			}
		});
		if(!flag&&forms.length>0){
			Ext.Msg.show({title:'错误',msg:'请将数据添加完整后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return;
		}
        this.focus();
		var tmpDate=this.dateFields;
        var records = this.store.getModifiedRecords();
		var tmpStore=this.store;
		var topbar=this.getTopToolbar().items;
		var stro = "";
		Ext.each(topbar.items, function(i){
			if(i.getXType()==='combo'){
				stro+="&"+i.getId()+"="+i.getValue();
			}
		})
        if (!records.length) {
            return;
        }
        var data = [];
        var p;
        Ext.each(records, function(r){
            var o = {};
			var tmpstro="&rowid="+r.data['rowid'];
            if (r.isValid()) {
				for (var f in r.getChanges()){
					o[f] = r.data[f];
					if (r.data[f] != null) {
                        if (tmpDate.indexOf(f)>=0) { //field.type=='date' 
                            if (r.data[f].toString() == "") {
                                tmpstro += "&" + f + "=" + r.data[f].toString();
                            }
                            else {
                                 tmpstro += "&" + f + "=" + new Date(r.data[f]).format('Y-m-d').toString();
                            }
                        }else 
						if (f != null) {
							var chk=r.data[f];
							if(chk===true)chk='Y';
							else if(chk===false)chk='N';
						
                            //tmpstro += "&" + f + "=" + encodeURIComponent(chk);
							tmpstro += "&" + f + "=" + chk;
                        }
                    }
				}
            }else{
				Ext.Msg.show({title:'错误',msg:'请将数据添加完整后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
            var recordType;
            if (r.data.newRecord) {
                recordType = "add";
            }
            else {
                recordType = "edit";
            }
            o[this.idName] = r.get(this.idName);
            data.push(o);
            var saveUrl = this.url + '?action=' + recordType +stro.toString() +"&"+tmpstro.toString()+"&"+Ext.urlEncode(this.urlParam);

            p = {
                url: saveUrl,
                method: 'GET',
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							var message="";
							message=recordType=='add'?'添加成功!':'修改成功!'
							Ext.Msg.show({title:'注意',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							tmpStore.commitChanges();
							if (jsonData.refresh=='true') {
								tmpStore.load({params:{start:Ext.isEmpty(this.getTopToolbar().cursor)?0:this.getTopToolbar().cursor, limit:this.pageSize}});
							}
						}
						else{
							if (jsonData.refresh=='true') {
								tmpStore.load({params:{start:Ext.isEmpty(this.getTopToolbar().cursor)?0:this.getTopToolbar().cursor, limit:this.pageSize}});
							}
							var message = "";
							message = "SQLErr: " + jsonData.info;
							if(jsonData.info=='EmptyName') message='输入的名称为空!';
							if(jsonData.info=='EmptyOrder') message='输入的序号为空!';
							if(jsonData.info=='RepName') message='输入的名称已经存在!';
							if(jsonData.info=='RepOrder') message='输入的序号已经存在!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							this.store.rejectChanges();
						}
				},
                scope: this
            };
            Ext.Ajax.request(p);
        }, this);
    }, 
	getForm: function() {
        return this.getFormPanel().getForm();
    },

	submitRecord: function() {
        var form = this.getForm();
        var values = form.getFieldValues();
		var topbar=this.getTopToolbar().items;
		var stro = "";
		Ext.each(topbar.items, function(i){
			if(i.getXType()==='combo'){
				stro+="&"+i.getId()+"="+i.getValue();
			}
		})
		this.getStore().proxy= new Ext.data.HttpProxy({
            url: this.url + '?action=list' + stro
        });
        var data = [];
        for (var name in values) {
            data.push(values[name]);
        }
		this.getStore().load({params:{data:data.toString()}});
        this.hideWindow();
    },
	getFormPanel: function() {
        if (!this.gridForm) {
            this.gridForm = this.createForm();
        }
        return this.gridForm;
    },

    createForm: function() {
		
        var items = [];
		var cmObj=this.getColumnModel();
        for (var i = 1; i <= this.fields.length; i++) {
			if(Ext.isDefined(cmObj.getColumnById(i))){
				var editorObj=cmObj.getColumnById(i).editor;	

				if(!editorObj.hidden){
					items.push(
						editorObj
					);
				}
			}
        }

        var form = new Ext.form.FormPanel({
            frame: true,
            defaultType: 'textfield',
            buttonAlign: 'center',
            labelAlign: 'right',
            labelWidth: 60,
            trackResetOnLoad: true,
            reader: new Ext.data.ArrayReader({
                fields: this.fields
            }),
            items: items,
            buttons: [{
                text: '提交',
                handler: this.submitRecord.createDelegate(this)
            }, {
                text: '重置',
                handler: function() {
                    form.getForm().reset();
                }
            }]
        });
        return form;
    },
	showWindow: function() {
        this.getWindow().show();
    },

    hideWindow: function() {
        this.getWindow().hide();
    },

    getWindow: function() {
        if (!this.gridWindow) {
            this.gridWindow = this.createWindow();
        }
        return this.gridWindow;
    },

    createWindow: function() {
        var formPanel = this.getFormPanel();

        var win = new Ext.Window({
			width: 400,
            title: '查询',
            closeAction: 'hide',
            modal: true,
            items: [
                formPanel
            ]
        });

        return win;
    },
	load: function(param){
		if(!Ext.isEmpty(param))this.getStore().baseParams=Ext.apply(this.urlParam,param.params) 
		else this.getStore().baseParams=this.urlParam;
		this.getStore().load({params:{start:Ext.isEmpty(this.getBottomToolbar().cursor)?0:this.getBottomToolbar().cursor, limit:this.pageSize}});
	},
	isSave: function(){
		return Ext.isEmpty(this.getStore().getModifiedRecords());
		
	},
	isNew: function(){
		var tmpRs=false;
		var tmpR=this.getSelectionModel().getSelected();
		if (tmpR.data.newRecord) {
                tmpRs = true;
            }
            else {
                tmpRs = false;
            }
		return tmpRs;
		
	},
	setUrlParam: function(param){
		if(!Ext.isEmpty(param))this.urlParam=Ext.apply(this.urlParam,param);
		
	}

});

Dhc.ca.GridTip={
	init:function(g){
		var message = "";
		g.on('beforeedit', beforeedit, this );
		function beforeedit(e) {
			var record=e.record;
			var tmpResult="";
			var fields=record.fields;
			var jsonData="";
			if(fields.get(e.field).tip){
				for(var v=0;v<fields.length;v++){
					
					tmpResult=tmpResult+'&'+fields.get(v).name+'='+record.get(fields.get(v).name);
				}
				Ext.Ajax.request({
					url: g.url+'?action=tip',
					//montod:"GET",
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',bufieldsons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							message=jsonData.info;
							Ext.example.msg('查询成功<p/>', '{0}',message);
						}
						else
						{
							message = "SQLErecord: " + jsonData.info;
							Ext.example.msg('查询失败<p/>', '{0}',message);
						}
					},
					params:tmpResult,
					scope: this
				});
			}			
		};
	}
};

Dhc.ca.ComboRender  = function(value){
	
              var editor = this.editor;
            if(editor){
				
                  var myStore = editor.store;
				  
               
                          var rec = myStore.find(editor.valueField, value);
                          if(rec>=0){
                              return myStore.getAt(rec).get(editor.displayField);
                          }else{
							return value;
						  }
                      

                  //}
             }
              return value;
          };

Dhc.ca.PageSizePlugin = function() {
    Dhc.ca.PageSizePlugin.superclass.constructor.call(this, {
        store: new Ext.data.SimpleStore({
            fields: ['text', 'value'],
            data: [['10', 10], ['20', 20], ['30', 30], ['50', 50], ['100', 100]]
        }),
        mode: 'local',
        displayField: 'text',
        valueField: 'value',
        editable: false,
        allowBlank: false,
        triggerAction: 'all',
        width: 40
    });
};



Ext.extend(Dhc.ca.PageSizePlugin, Ext.form.ComboBox, {
    init: function(paging) {
        paging.on('render', this.onInitView, this);
    },

    onInitView: function(paging) {
        paging.add('-',
            this,
            '-'
        );
        this.setValue(paging.pageSize);
        this.on('select', this.onPageSizeChanged, paging);
    },

    onPageSizeChanged: function(combo) {
        this.pageSize = parseInt(combo.getValue());
        this.doLoad(0);
    }
});



