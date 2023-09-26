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
		text: '���',
		tooltip: '����µ����',
		iconCls: 'add',
		handler: function(){
		addAAccCycleFun(AAccCycleDs,AAccCycleMain,AAccCyclePagingToolbar);
		}
});


var editAAccCycleButton  = new Ext.Toolbar.Button({
		text: '�ϴ��ļ�',
		tooltip: '�ϴ�',
		iconCls: 'remove',
		handler: function(){editAAccCycleFun();}
});

var typeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['1','�ɱ�����-cost_detail'],['2','�ɱ�����-֧��'],['3','��������-��Ӧ��'],['4','��������-�繤��'],['5','��������-�绰��'],['7','��������-����'],['8','��������-����'],['9','��������-˾��'],['A','��������-ͳ��'],['B','��������-ϴ��'],['C','��������-Ժ��'],['D','��������-�����˴�'],['F','��������-סԺ������']]
});
var typeField = new Ext.form.ComboBox({
	id: 'typeField',
	fieldLabel: '������������',
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: typeStore,
	anchor: '90%',
	value:'Y', //Ĭ��ֵ
	valueNotFoundText:'������������',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���־...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
var excelButton = new Ext.Toolbar.Button({
	id:'excelButton',
	text:'���ݵ���',        
	tooltip:'����',
	iconCls:'add',        
	handler: function(){ 
				//location.href = 'http://localhost:8080/etl/CostTrance';	
				var r=confirm("ȷ��Ҫ����������");
				if(r==true)
				{
				if(typeField.getValue()==""){
				  Ext.Msg.show({title:'����',msg:'��ѡ������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
								waitMsg:'���ڵ���...',
								failure: function(result, request) {
								Ext.Msg.show({title:'��ʾ',msg:'����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							    },
								success: function(result,request){
								
                                var jsonData = Ext.util.JSON.decode( result.responseText );
								//alert(jsonData.success);
								var suc=jsonData.success;
						  	   if (suc) {
							   alert
						  		Ext.Msg.show({title:'��ʾ',msg:jsonData.message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
								else
								{
								  Ext.Msg.show({title:'����',msg:jsonData.message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
         header: "��Ч��־",
         dataIndex: 'active',
         width: 55
         });
var AAccCycleCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '����',
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
			header: '����',
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
			header: '����',
			dataIndex: 'desc',
			width: 100,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
           })

		},
		
		/* {
			header: "��Ч��־",
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
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'AAccCycleFilter',checkHandler: onAAccCycleItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'AAccCycleFilter',checkHandler: onAAccCycleItemCheck }),
				//new Ext.menu.CheckItem({ text: '��ʼ����',value: 'start',checked: false,group: 'AAccCycleFilter',checkHandler: onAAccCycleItemCheck }),
				//new Ext.menu.CheckItem({ text: '��������',value: 'end',checked: false,group: 'AAccCycleFilter',checkHandler: onAAccCycleItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'active',checked: false,group: 'AAccCycleFilter',checkHandler: onAAccCycleItemCheck })
		]}
});

function onAAccCycleItemCheck(item, checked){
		if(checked) {
				AAccCycleSearchField = item.value;
				AAccCycleFilterItem.setText(item.text + ':');
		}
};

var AAccCycleSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'����...',
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
var AAccCyclePagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: AAccCycleDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',AAccCycleFilterItem,'-',AAccCycleSearchBox]
});

var AAccCycleMain = new Ext.grid.EditorGridPanel({//���
		title: '��ȱ�ά��',
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
		var mr=AAccCycleDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
				//alert("orginValue:"+mr[i].data["desc"]);//�˴�cell�Ƿ���   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim()+"^"+mr[i].data["active"];
                if(mr[i].data["code"].trim()=="")
				{
					Ext.Msg.show({title:'����',msg:'���벻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
				if(mr[i].data["name"].trim()=="")
				{
					Ext.Msg.show({title:'����',msg:'���Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
				var myRowid = mr[i].data["rowid"].trim();				
     }  
        Ext.Ajax.request({
							url: AAccCycleUrl+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									//AAccCycleDs.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									this.store.commitChanges(); //��ԭ�����޸���ʾ
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
    //���̨�ύ����   
   return value;   
  }  
  /*
function afterEdit(obj){    //ÿ�θ��ĺ󣬴���һ�θ��¼�   
          var mr=AAccCycleDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
				//alert("orginValue:"+mr[i].data["desc"]);//�˴�cell�Ƿ���   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim()+"^"+mr[i].data["active"];
                var myRowid = mr[i].data["rowid"].trim();				
     }  
	 Ext.Ajax.request({
							url: AAccCycleUrl+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									//AAccCycleDs.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									this.store.commitChanges(); //��ԭ�����޸���ʾ
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
AAccCycleMain.on("afteredit", afterEdit, AAccCycleMain);   */ 
AAccCycleDs.load({params:{start:0, limit:AAccCyclePagingToolbar.pageSize}});
