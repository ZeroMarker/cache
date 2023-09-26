var KPIIndexUrl = 'dhc.pa.kpiindexnotreeexe.csp';
var KPIIndexProxy = new Ext.data.HttpProxy({url: KPIIndexUrl+'?action=list',method:'POST'});


var KPIIndexDs = new Ext.data.Store({
	proxy: KPIIndexProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'id','code','name','py','shortcut','dimTypeDr','dimTypeName','target','desc','calUnitDr','calUnitName','extreMum','extreMumName','expression','expName',
			'expName2','expDesc','colTypeDr','colTypeName','scoreMethodCode','scoreMethodName','colDeptDr','colDeptName','dataSource','isHospKPI','isDeptKPI','isMedKPI',
			'isNurKPI','isPostKPI','parent','parentName','level','isStop','isEnd','order','isKPI'
 
		]),
    remoteSort: true
});

//KPIIndexDs.setDefaultSort('id', 'DESC');


var addKPIIndexButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µļ�����λ',
		iconCls: 'add',
		handler: function(){addKPIIndexFun(KPIIndexDs,KPIIndexMain,KPIIndexPagingToolbar);}
});

var editKPIIndexButton  = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸�ѡ�������',
		iconCls: 'remove',
		handler: function(){editKPIIndexFun(KPIIndexDs,KPIIndexMain,KPIIndexPagingToolbar);}
});
var KPIIndexCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
    	header:'ָ������',
    	align: 'left',
    	width:200,
    	dataIndex:'name'
	},{
    	header:'ָ�����',
    	width:60,
    	dataIndex:'code'
	},{
    	header:'����ά��',
    	align: 'left',
    	width:60,
    	dataIndex:'dimTypeName'
	},{
    	header:'����Ŀ��',
    	align: 'left',
    	width:60,
    	dataIndex:'target'
	},{
    	header:'������λ',
    	align: 'right',
    	width:60,
    	dataIndex:'calUnitName'
	},{
    	header:'��ֵ',
    	align: 'right',
    	width:40,
    	dataIndex:'extreMumName'
	},{
    	header:'�ռ���ʽ',
    	align: 'right',
    	width:60,
    	dataIndex:'colTypeName'
	},{
    	header:'���ַ���',
    	align: 'right',
    	width:60,
    	dataIndex:'scoreMethodName'
	},{
    	header:'�ռ�����',
    	align: 'right',
    	width:60,
    	dataIndex:'colDeptName'
	},{
    	header:'�ϼ�ָ��',
    	align: 'right',
    	width:60,
    	dataIndex:'parentName'
	},{
    	header:'ĩ����־',
    	align: 'right',
    	width:60,
    	dataIndex:'isEnd',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	},{
    	header:'˳��',
    	align: 'right',
    	width:40,
    	dataIndex:'order'
	},{
    	header:'ָ�꼶��',
    	align:'right',
    	width:55,
    	dataIndex:'level'
	},{
    	header:'�Ƿ�ͣ��',
    	align: 'right',
    	width:55,
    	dataIndex:'isStop',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	},{
    	header:'KPI ��־',
    	align: 'right',
    	width:50,
    	dataIndex:'isKPI',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	},{
    	header:'ָ������',
    	align: 'center',
    	width:145,
    	dataIndex:'desc'
	}
	]);
	
var KPIIndexSearchField = 'name';

var KPIIndexFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'KPIIndexFilter',checkHandler: onKPIIndexItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'KPIIndexFilter',checkHandler: onKPIIndexItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'desc',checked: false,group: 'KPIIndexFilter',checkHandler: onKPIIndexItemCheck })
		]}
});

function onKPIIndexItemCheck(item, checked)
{
		if(checked) {
				KPIIndexSearchField = item.value;
				KPIIndexFilterItem.setText(item.text + ':');
		}
};

var KPIIndexSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				KPIIndexDs.proxy = new Ext.data.HttpProxy({url: KPIIndexUrl + '?action=list',method:'POST'});
				KPIIndexDs.load({params:{start:0, limit:KPIIndexPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				KPIIndexDs.proxy = new Ext.data.HttpProxy({
				url: KPIIndexUrl + '?action=list&searchField='+ KPIIndexSearchField + '&searchValue=' + this.getValue(),method:'POST'});
				KPIIndexDs.load({params:{start:0, limit:KPIIndexPagingToolbar.pageSize}});
	    	}
		}
});
KPIIndexDs.each(function(record){
    alert(record.get('tieOff'));

});
var KPIIndexPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: KPIIndexDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',KPIIndexFilterItem,'-',KPIIndexSearchBox]
});

var KPIIndexMain = new Ext.grid.EditorGridPanel({//���
		title: 'ָ�����÷���״�ṹ',
		store: KPIIndexDs,
		cm: KPIIndexCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addKPIIndexButton,'-'],
		bbar: KPIIndexPagingToolbar
});


KPIIndexMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
function afterEdit(obj){    //ÿ�θ��ĺ󣬴���һ�θ��¼�   
          var mr=KPIIndexDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim();
                var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: KPIIndexUrl+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
KPIIndexMain.on("afteredit", afterEdit, KPIIndexMain);    
KPIIndexDs.load({params:{start:0, limit:KPIIndexPagingToolbar.pageSize}});
