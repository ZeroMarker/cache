var AAccCycleUrl = 'dhc.pa.cycleexe.csp';
var AAccCycleProxy = new Ext.data.HttpProxy({url: AAccCycleUrl+'?action=list'});
var ServletURL = 'http://172.16.2.20:8080';
var month = 1;
var user = 1;
var AAccCycleDs = new Ext.data.Store({
	proxy: AAccCycleProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'code',
			'name',
			'shortcut',
			'desc',
			'active'
 
		]),
    // turn on remote sorting
    remoteSort: true
});

AAccCycleDs.setDefaultSort('rowid', 'DESC');


var addAAccCycleButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的年度',
		iconCls: 'add',
		handler: function(){
		addAAccCycleFun(AAccCycleDs,AAccCycleMain,AAccCyclePagingToolbar);
		}
});


var editAAccCycleButton  = new Ext.Toolbar.Button({
		text: '上传文件',
		tooltip: '上传',
		iconCls: 'remove',
		handler: function(){editAAccCycleFun();}
});

var typeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['1','成本数据-cost_detail'],['2','成本数据-支出'],['3','参数数据-供应室'],['4','参数数据-电工班'],['5','参数数据-电话班'],['7','参数数据-接诊'],['8','参数数据-技工'],['9','参数数据-司机'],['A','参数数据-统计'],['B','参数数据-洗衣'],['C','参数数据-院容'],['D','参数数据-门诊人次'],['F','参数数据-住院床日数']]
});
var typeField = new Ext.form.ComboBox({
	id: 'typeField',
	fieldLabel: '导入数据类型',
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: typeStore,
	anchor: '90%',
	value:'Y', //默认值
	valueNotFoundText:'导入数据类型',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择标志...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
var excelButton = new Ext.Toolbar.Button({
	id:'excelButton',
	text:'数据导入',        
	tooltip:'导入',
	iconCls:'add',        
	handler: function(){ 
				//location.href = 'http://localhost:8080/etl/CostTrance';	
				var r=confirm("确定要导入数据吗？");
				if(r==true)
				{
				if(typeField.getValue()==""){
				  Ext.Msg.show({title:'错误',msg:'请选择类型',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			  return;
				}
				var data = "";
				var type = typeField.getValue()
				if((type=="1")||(type=="2")){
				   data = month;
				}
				else{
				   data = month+'^'+user+'^load';
				}
				Ext.Ajax.request({
								url:ServletURL+'/etl/CostTrance?data='+data+'&type='+type,
								waitMsg:'正在导入...',
								failure: function(result, request) {
								Ext.Msg.show({title:'提示',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							    },
								success: function(result,request){
								
                                var jsonData = Ext.util.JSON.decode( result.responseText );
								//alert(jsonData.success);
								var suc=jsonData.success;
						  	   if (suc) {
							   alert
						  		Ext.Msg.show({title:'提示',msg:jsonData.message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
								else
								{
								  Ext.Msg.show({title:'错误',msg:jsonData.message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								}
							});
							}
		}
});
Ext.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if(!this.id){
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype ={
    init : function(grid){
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },

    onMouseDown : function(e, t){
        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
             e.stopEvent();   
            var index = this.grid.getView().findRowIndex(t);   
            var cindex = this.grid.getView().findCellIndex(t);   
            var record = this.grid.store.getAt(index);   
            var field = this.grid.colModel.getDataIndex(cindex);   
            var e = {   
                grid : this.grid,   
                record : record,   
                field : field,   
                originalValue : record.data[this.dataIndex],   
                value : !record.data[this.dataIndex],   
                row : index,   
                column : cindex,   
                cancel : false  
            };   
            if (this.grid.fireEvent("validateedit", e) !== false && !e.cancel) {   
                delete e.cancel;   
                record.set(this.dataIndex, !record.data[this.dataIndex]);   
                this.grid.fireEvent("afteredit", e);   
            }
        }
    },

    renderer : function(v, p, record){
        p.css += ' x-grid3-check-col-td'; 
        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
	};
	
var checkColumn=new Ext.grid.CheckColumn({
         header: "有效标志",
         dataIndex: 'active',
         width: 55
         });
var AAccCycleCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '代码',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
               allowBlank: false
           })
		},
		{
			header: '名称',
			dataIndex: 'name',
			width: 200,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
               allowBlank: false
           })

		},
		{
			header: '描述',
			dataIndex: 'desc',
			width: 100,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
           })

		},
		
		/* {
			header: "有效标志",
			dataIndex: 'active',
			width: 90,
			sortable: true,
            renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		}, */
	checkColumn
	

	]);



	
var AAccCycleSearchField = 'Name';

var AAccCycleFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'AAccCycleFilter',checkHandler: onAAccCycleItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'AAccCycleFilter',checkHandler: onAAccCycleItemCheck }),
				//new Ext.menu.CheckItem({ text: '开始日期',value: 'start',checked: false,group: 'AAccCycleFilter',checkHandler: onAAccCycleItemCheck }),
				//new Ext.menu.CheckItem({ text: '结束日期',value: 'end',checked: false,group: 'AAccCycleFilter',checkHandler: onAAccCycleItemCheck }),
				new Ext.menu.CheckItem({ text: '描述',value: 'active',checked: false,group: 'AAccCycleFilter',checkHandler: onAAccCycleItemCheck })
		]}
});

function onAAccCycleItemCheck(item, checked){
		if(checked) {
				AAccCycleSearchField = item.value;
				AAccCycleFilterItem.setText(item.text + ':');
		}
};

var AAccCycleSearchBox = new Ext.form.TwinTriggerField({//查找按钮
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'搜索...',
		listeners: {
			specialkey: {fn:function(field, e) {
			var key = e.getKey();
			if(e.ENTER === key) {this.onTrigger2Click();}}}
		},
		grid: this,
		onTrigger1Click: function() {
			if(this.getValue()) {
				this.setValue('');
				AAccCycleDs.proxy = new Ext.data.HttpProxy({url: AAccCycleUrl + '?action=list'});
				AAccCycleDs.load({params:{start:0, limit:AAccCyclePagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				AAccCycleDs.proxy = new Ext.data.HttpProxy({
				url: AAccCycleUrl + '?action=list&searchField=' + AAccCycleSearchField + '&searchValue=' + this.getValue()});
				AAccCycleDs.load({params:{start:0, limit:AAccCyclePagingToolbar.pageSize}});
	    	}
		}
});
AAccCycleDs.each(function(record){
    alert(record.get('tieOff'));

});
var AAccCyclePagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: AAccCycleDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',AAccCycleFilterItem,'-',AAccCycleSearchBox]
});

var AAccCycleMain = new Ext.grid.EditorGridPanel({//表格
		title: '年度表维护',
		store: AAccCycleDs,
		cm: AAccCycleCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		plugins:checkColumn,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addAAccCycleButton,'-',editAAccCycleButton,'-',typeField,'-',excelButton],
		bbar: AAccCyclePagingToolbar,
		listeners : {   
        'afteredit' : function(e) {   
		var mr=AAccCycleDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
				//alert("orginValue:"+mr[i].data["desc"]);//此处cell是否发生   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim()+"^"+mr[i].data["active"];
                if(mr[i].data["code"].trim()=="")
				{
					Ext.Msg.show({title:'错误',msg:'代码不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
				if(mr[i].data["name"].trim()=="")
				{
					Ext.Msg.show({title:'错误',msg:'名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
				var myRowid = mr[i].data["rowid"].trim();				
     }  
        Ext.Ajax.request({
							url: AAccCycleUrl+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									//AAccCycleDs.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									this.store.commitChanges(); //还原数据修改提示
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});  
        }   
    }  

});


AAccCycleMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});
////
function isEdit(value,record){   
    //向后台提交请求   
   return value;   
  }  
  /*
function afterEdit(obj){    //每次更改后，触发一次该事件   
          var mr=AAccCycleDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
				//alert("orginValue:"+mr[i].data["desc"]);//此处cell是否发生   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim()+"^"+mr[i].data["active"];
                var myRowid = mr[i].data["rowid"].trim();				
     }  
	 Ext.Ajax.request({
							url: AAccCycleUrl+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									//AAccCycleDs.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									this.store.commitChanges(); //还原数据修改提示
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
AAccCycleMain.on("afteredit", afterEdit, AAccCycleMain);   */ 
AAccCycleDs.load({params:{start:0, limit:AAccCyclePagingToolbar.pageSize}});
