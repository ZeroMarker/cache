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
	fieldLabel: '绩效方案',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: schemedistDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择绩效方案...',
	name: 'schemedistField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var extremum = new Ext.form.ComboBox({
			id:'extremum',
			fieldLabel: '极值',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[["H",'趋高'],["M",'趋中'],["L",'趋低']]
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
	fieldLabel: '战略',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: stratagemDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择战略...',
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
		text: '添加',
		tooltip: '添加新的方案调整',
		iconCls: 'add',
		handler: function(){init()}
});

var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'add'
		//handler: function(){}		
});

var ParamSearchField = 'name';

var ParamFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '描述',value: 'info',checked: false,group: 'ParamFilter',checkHandler: onParamItemCheck })
		]}
});
init = function(){
	Ext.MessageBox.confirm('提示','确实要初始化数据吗?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:'dhc.pa.schemexe.csp?action=init',
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'数据初始化完成!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						}else{
							if(jsonData.info=='Copyed'){
								Ext.Msg.show({title:'提示',msg:'当前战略已经初始化!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
							if(jsonData.info=='NoCurrRecord'){
								Ext.Msg.show({title:'提示',msg:'没有当前战略!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
							if(jsonData.info=='RepCurrRecord'){
								Ext.Msg.show({title:'提示',msg:'多个当前战略!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
							if(jsonData.info=='false'){
								Ext.Msg.show({title:'提示',msg:'当前初始化失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
					{header: '指标名称', width: 80,align: 'left', dataIndex: 'name'},
					{header: '指标代码', width: 25,align: 'left', dataIndex: 'code'},
					{header: '计量单位', width: 50, dataIndex: 'calUnite'},
					{header: '起始分', width: 25, align: 'right',dataIndex: 'scorelower1'},
					{header: '终止分', width: 25, align: 'right',dataIndex: 'scoreup1'},
					{header: '起始分', width: 25, align: 'right',dataIndex: 'scorelower2'},
					{header: '终止分', width: 25, align: 'right',dataIndex: 'scoreup2'},
					{header: '起始分', width: 25, align: 'right',dataIndex: 'scorelower3'},
					{header: '终止分', width: 25, align: 'right',dataIndex: 'scoreup3'},
					{header: '起始分', width: 25, align: 'right',dataIndex: 'scorelower4'},
					{header: '终止分', width: 25, align: 'right',dataIndex: 'scoreup4'}
				],
				defaultSortable: true
			});
	}
	else{
	range1 = new Ext.grid.ColumnModel({
					columns: [
						{header: '指标名称', width: 80,align: 'left', dataIndex: 'name'},
						{header: '指标代码', width: 25,align: 'left', dataIndex: 'code'},
						{header: '计量单位', width: 50, dataIndex: 'calUnite'},
						{header: '起始分', width: 25, align: 'right',dataIndex: 'scorelower1'},
						{header: '终止分', width: 25, align: 'right',dataIndex: 'scoreup1'},
						{header: '起始分', width: 25, align: 'right',dataIndex: 'scorelower2'},
						{header: '终止分', width: 25, align: 'right',dataIndex: 'scoreup2'},
						{header: '起始分', width: 25, align: 'right',dataIndex: 'scorelower3'},
						{header: '终止分', width: 25, align: 'right',dataIndex: 'scoreup3'},
						{header: '起始分', width: 25, align: 'right',dataIndex: 'scorelower4'},
						{header: '终止分', width: 25, align: 'right',dataIndex: 'scoreup4'},
						{header: '起始分', width: 25, align: 'right',dataIndex: 'scorelower5'},
						{header: '终止分', width: 25, align: 'right',dataIndex: 'scoreup5'},
						{header: '起始分', width: 25, align: 'right',dataIndex: 'scorelower6'},
						{header: '终止分', width: 25, align: 'right',dataIndex: 'scoreup6'}
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
							{header: '区间1', colspan: 2, align: 'center'},
							{header: '区间2', colspan: 2, align: 'center'},
							{header: '区间3', colspan: 2, align: 'center'},
							{header: '区间4', colspan: 2, align: 'center'}
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
							{header: '区间1', colspan: 2, align: 'center'},
							{header: '区间2', colspan: 2, align: 'center'},
							{header: '区间3', colspan: 2, align: 'center'},
							{header: '区间4', colspan: 2, align: 'center'},
							{header: '区间5', colspan: 2, align: 'center'},
							{header: '区间6', colspan: 2, align: 'center'}
						]
					],
					hierarchicalColMenu: true
					});		
	}

	if((extremum.getValue()=='H')||(extremum.getValue()=='L')){
	  new Ext.grid.EditorGridPanel({//表格
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
	  new Ext.grid.EditorGridPanel({//表格
			//title: '战略调整设置',
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
		//title:'区间设置',
		region:'north',
		frame:true,
		height:90,
		items:[{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
					{columnWidth:.07,xtype:'label',text: '方案:'},
					schemedistField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.07,xtype:'label',text: '极值:'},
					extremum,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '数据初始化',name: 'addAdjustButton',tooltip: '添加',handler:function(){init()},iconCls: 'add'},
					{columnWidth:.1,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '修改',name: 'editSchemDetailDist',tooltip: '修改',handler:function(){editSchemDetailDistFun(ParamDs,SchemDetailDistGrid1,ParamPagingToolbar)},iconCls: 'add'}
				]
			}
		]
		 
});  	

var ParamSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
var ParamPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: ParamDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',ParamFilterItem,'-',ParamSearchBox]
});


////
function isEdit(value,record){   
    //向后台提交请求   
   return value;   
  }  
function afterEdit(obj){    //每次更改后，触发一次该事件   
          var mr=ParamDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
                var data = Ext.getCmp('stratagemField').getValue().trim()+"^"+userCode+"^"+mr[i].data["info"].trim();
				var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: ParamUrl+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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

ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
