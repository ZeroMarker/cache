var ParamUrl = 'dhc.pa.adjustexe.csp';
var ParamProxy = new Ext.data.HttpProxy({url: ParamUrl+'?action=list'});
var DetailAddProxy = new Ext.data.HttpProxy({url: SchemUrl+'?action=schemdetailadd'});
var StratagemTabUrl = '../csp/dhcc.pa.stratagemexe.csp';
var userCode = session['LOGON.USERCODE'];
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
}

var schemedistDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

schemedistDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemexe.csp?action=list&searchField=name&searchValue='+encodeURIComponent(schemedistField.getRawValue())});
});

var schemedistField = new Ext.form.ComboBox({
	id: 'schemedistField',
	fieldLabel: '��Ч����',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: schemedistDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��Ч����...',
	name: 'schemedistField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var extremum = new Ext.form.ComboBox({
			id:'extremum',
			fieldLabel: '��ֵ',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[["H",'����'],["M",'����'],["L",'����']]
			})			
		});

var stratagemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

stratagemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:ParamUrl+'?action=stratagem&cycle='+Ext.getCmp('schemedistField').getValue()});
});

var stratagemField = new Ext.form.ComboBox({
	id: 'stratagemField',
	fieldLabel: 'ս��',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: stratagemDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��ս��...',
	name: 'stratagemField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//var extValue;
var range;
var groupRange;
extremum.on("select",function(cmb,rec,id ){
    //extValue=extremum.getValue();
	//alert(extValue);
	//extreFunction(cmb.getValue());
    sunfind(cmb.getValue());    
});

//DetailAddProxy+'&schem='+Ext.getCmp('schemedistField').getValue()
var ParamDs = new Ext.data.Store({
	proxy: DetailAddProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','code','name','calUnite','range1','range2','range3','range4','range5','range6','scorelower1','scoreup1','scorelower2','scoreup2','scorelower3','scoreup3','scorelower4','scoreup4','scorelower5','scoreup5','scorelower6','scoreup6'
 
		]),
    remoteSort: true
});

ParamDs.setDefaultSort('rowid', 'DESC');

var addAdjustButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µķ�������',
		iconCls: 'add',
		handler: function(){init()}
});

var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'add'
		//handler: function(){}		
});

var ParamSearchField = 'name';

var ParamFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'info',checked: false,group: 'ParamFilter',checkHandler: onParamItemCheck })
		]}
});
init = function(){
	Ext.MessageBox.confirm('��ʾ','ȷʵҪ��ʼ��������?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:'dhc.pa.schemexe.csp?action=init',
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'��ʾ',msg:'���ݳ�ʼ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						}else{
							if(jsonData.info=='Copyed'){
								Ext.Msg.show({title:'��ʾ',msg:'��ǰս���Ѿ���ʼ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
							if(jsonData.info=='NoCurrRecord'){
								Ext.Msg.show({title:'��ʾ',msg:'û�е�ǰս��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
							if(jsonData.info=='RepCurrRecord'){
								Ext.Msg.show({title:'��ʾ',msg:'�����ǰս��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
							if(jsonData.info=='false'){
								Ext.Msg.show({title:'��ʾ',msg:'��ǰ��ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
						}
					},
					scope: this
				});
			}
		}
	)
}
function sunfind(str){
	//alert(Ext.getCmp('SchemDetailDistPanel'));
	//SchemDetailDistGrid.getColumnModel().reload();
    //SchemDetailDistGrid.getColumnModel().reset();	
	
	var schemdetaildistmain = Ext.getCmp('SchemDetailDistGrid');
	schemdetaildistmain.remove('first_center');
	//alert(extremum.getValue());
	ParamDs.proxy=new Ext.data.HttpProxy({url: SchemUrl+'?action=schemdetailadd&schem='+Ext.getCmp('schemedistField').getValue()+'&trend='+extremum.getValue()});
	ParamDs.load({params:{start:0, limit:stratagemField.pageSize}});
	if((extremum.getValue()=='H')||(extremum.getValue()=='L')){
     range1 = new Ext.grid.ColumnModel({
				columns: [
					{header: 'ָ������', width: 80,align: 'left', dataIndex: 'name'},
					{header: 'ָ�����', width: 25,align: 'left', dataIndex: 'code'},
					{header: '������λ', width: 50, dataIndex: 'calUnite'},
					{header: '��ʼ��', width: 25, align: 'right',dataIndex: 'scorelower1'},
					{header: '��ֹ��', width: 25, align: 'right',dataIndex: 'scoreup1'},
					{header: '��ʼ��', width: 25, align: 'right',dataIndex: 'scorelower2'},
					{header: '��ֹ��', width: 25, align: 'right',dataIndex: 'scoreup2'},
					{header: '��ʼ��', width: 25, align: 'right',dataIndex: 'scorelower3'},
					{header: '��ֹ��', width: 25, align: 'right',dataIndex: 'scoreup3'},
					{header: '��ʼ��', width: 25, align: 'right',dataIndex: 'scorelower4'},
					{header: '��ֹ��', width: 25, align: 'right',dataIndex: 'scoreup4'}
				],
				defaultSortable: true
			});
	}
	else{
	range1 = new Ext.grid.ColumnModel({
					columns: [
						{header: 'ָ������', width: 80,align: 'left', dataIndex: 'name'},
						{header: 'ָ�����', width: 25,align: 'left', dataIndex: 'code'},
						{header: '������λ', width: 50, dataIndex: 'calUnite'},
						{header: '��ʼ��', width: 25, align: 'right',dataIndex: 'scorelower1'},
						{header: '��ֹ��', width: 25, align: 'right',dataIndex: 'scoreup1'},
						{header: '��ʼ��', width: 25, align: 'right',dataIndex: 'scorelower2'},
						{header: '��ֹ��', width: 25, align: 'right',dataIndex: 'scoreup2'},
						{header: '��ʼ��', width: 25, align: 'right',dataIndex: 'scorelower3'},
						{header: '��ֹ��', width: 25, align: 'right',dataIndex: 'scoreup3'},
						{header: '��ʼ��', width: 25, align: 'right',dataIndex: 'scorelower4'},
						{header: '��ֹ��', width: 25, align: 'right',dataIndex: 'scoreup4'},
						{header: '��ʼ��', width: 25, align: 'right',dataIndex: 'scorelower5'},
						{header: '��ֹ��', width: 25, align: 'right',dataIndex: 'scoreup5'},
						{header: '��ʼ��', width: 25, align: 'right',dataIndex: 'scorelower6'},
						{header: '��ֹ��', width: 25, align: 'right',dataIndex: 'scoreup6'}
					],
					defaultSortable: true
				});
		}
	if((extremum.getValue()=='H')||(extremum.getValue()=='L')){
	groupRange1 = new Ext.ux.plugins.GroupHeaderGrid({
					rows: [
						[
							{},
							{},
							{},
							{header: '����1', colspan: 2, align: 'center'},
							{header: '����2', colspan: 2, align: 'center'},
							{header: '����3', colspan: 2, align: 'center'},
							{header: '����4', colspan: 2, align: 'center'}
						]
					],
					hierarchicalColMenu: false
					});				
	}
	else{
	groupRange1 = new Ext.ux.plugins.GroupHeaderGrid({
					rows: [
						[
							{},
							{},
							{},
							{header: '����1', colspan: 2, align: 'center'},
							{header: '����2', colspan: 2, align: 'center'},
							{header: '����3', colspan: 2, align: 'center'},
							{header: '����4', colspan: 2, align: 'center'},
							{header: '����5', colspan: 2, align: 'center'},
							{header: '����6', colspan: 2, align: 'center'}
						]
					],
					hierarchicalColMenu: true
					});		
	}

	if((extremum.getValue()=='H')||(extremum.getValue()=='L')){
	  new Ext.grid.EditorGridPanel({//���
			id: 'SchemDetailDistGrid1',
			store: ParamDs,
			xtype: 'grid',
			cm: range1,
			trackMouseOver: true,
			region:'center',
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			frame: true,
			viewConfig: {
					forceFit: true
				},
			stripeRows: true, 
			plugins:groupRange1
	});
	}
	else{ 
	  new Ext.grid.EditorGridPanel({//���
			//title: 'ս�Ե�������',
			store: ParamDs,
			id:'SchemDetailDistGrid1',
			xtype: 'grid',
			cm: range1,
			trackMouseOver: true,
			region:'center',
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			frame: true,
			viewConfig: {
					forceFit: true
				},
			stripeRows: true, 
			plugins:groupRange1
	});
	}
	//alert(SchemDetailDistGrid1.id);
	schemdetaildistmain.add('SchemDetailDistGrid1');
	schemdetaildistmain.getLayout().setActiveItem('SchemDetailDistGrid1');
	schemdetaildistmain.doLayout();
}
function onParamItemCheck(item, checked)
{
		if(checked) {
				ParamSearchField = item.value;
				ParamFilterItem.setText(item.text + ':');
		}
}

var extremumForm = new Ext.form.FormPanel({
		//title:'��������',
		region:'north',
		frame:true,
		height:90,
		items:[{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
					{columnWidth:.07,xtype:'label',text: '����:'},
					schemedistField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.07,xtype:'label',text: '��ֵ:'},
					extremum,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '���ݳ�ʼ��',name: 'addAdjustButton',tooltip: '���',handler:function(){init()},iconCls: 'add'},
					{columnWidth:.1,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '�޸�',name: 'editSchemDetailDist',tooltip: '�޸�',handler:function(){editSchemDetailDistFun(ParamDs,SchemDetailDistGrid1,ParamPagingToolbar)},iconCls: 'add'}
				]
			}
		]
		 
});  	

var ParamSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				ParamDs.proxy = new Ext.data.HttpProxy({url: ParamUrl + '?action=list'});
				ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				ParamDs.proxy = new Ext.data.HttpProxy({
				url: ParamUrl + '?action=list&searchField=' + ParamSearchField + '&searchValue=' + this.getValue()});
				ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
	    	}
		}
});
ParamDs.each(function(record){
    alert(record.get('tieOff'));

});
var ParamPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: ParamDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',ParamFilterItem,'-',ParamSearchBox]
});


////
function isEdit(value,record){   
    //���̨�ύ����   
   return value;   
  }  
function afterEdit(obj){    //ÿ�θ��ĺ󣬴���һ�θ��¼�   
          var mr=ParamDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
                var data = Ext.getCmp('stratagemField').getValue().trim()+"^"+userCode+"^"+mr[i].data["info"].trim();
				var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: ParamUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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

ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
