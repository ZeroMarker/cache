//================定义部分全局变量============================
var cycleIdCookieName="jxFeedBackCycleDr";
var periodTypeNameCookieName="jxFeedBackPeriodTypeName";
var periodTypeCookieName="jxFeedBackPeriodType";
var periodCookieName="jxFeedBackPeriod";
var schemIdCookieName="jxFeedBackSchemDr";
var deptIdCookieName="jxFeedBackUnitDr"
var trendIdCookieName="jxFeedBackTrendDr"
var trendNameCookieName="jxFeedBackTrendNameCookieName"
var nameStr=cycleIdCookieName+"^"+deptIdCookieName+"^"+trendIdCookieName+"^"+trendNameCookieName+"^"+schemIdCookieName;
var dataStr="";
var count1=0;
var count2=0;
var count3=0;
var count4=0; 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var SchemUrl = 'dhc.pa.schemexe.csp';
var UnitSchemDist = 'dhc.pa.schemunitdistexe.csp';
//var ParamProxy = new Ext.data.HttpProxy({url: ParamUrl+'?action=list'});
var DetailAddProxy = new Ext.data.HttpProxy({url:SchemUrl+'?action=schemdetailadd'});
var StratagemTabUrl = '../csp/dhcc.pa.stratagemexe.csp';
var userCode = session['LOGON.USERCODE'];
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
}
function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};
var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
	
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'年度',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
/* cycleDs.on('load', function(ds, o){
	cycleField.setValue(getCookie(cycleIdCookieName));
	count1=1;
});
 */
var schemedistDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

schemedistDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=schem&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('schemedistField').getRawValue())+'&active=Y',method:'POST'})
	
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
/* schemedistDs.on('load', function(ds, o){
	schemedistField.setValue(getCookie(schemIdCookieName));
	count2=1;
}) */;
var extremumStore = new Ext.data.SimpleStore({
	fields:['rowid','name'],
	data:[["H",'趋高'],["M",'趋中'],["L",'趋低']]
});
var extremum = new Ext.form.ComboBox({
			id:'extremum',
			width:180,
	        listWidth : 180,
			fieldLabel: '极值',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:extremumStore
		});
//加载页面时渲染控件
setComboValueFromClientOfNotChange(extremum,trendNameCookieName,trendIdCookieName);


var deptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitName','shortCut'])
});

deptDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=dept&schemDr='+Ext.getCmp('schemedistField').getValue(),method:'POST'})
	
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '科室',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: deptDs,
	anchor: '90%',
	displayField: 'shortCut',
	valueField: 'jxUnitDr',
	triggerAction: 'all',
	emptyText:'选择科室...',
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
/* deptDs.on('load', function(ds, o){
	deptField.setValue(getCookie(deptIdCookieName));
	count3=1;
}); */
var KPIDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

KPIDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.schemunitdistexe.csp?action=kpi&schem='+Ext.getCmp('schemedistField').getValue()+'&trend='+Ext.getCmp('extremum').getValue()+'&start=0&limit=25',method:'POST'})
});
var KPIField = new Ext.form.ComboBox({
	id: 'KPIField',
	fieldLabel: '',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: KPIDs,
	anchor: '90%',
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'请选择KPI...',
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

schemedistField.on("select",function(cmb,rec,id ){
    searchFun(cmb.getValue());
});

function searchFun(schemDr){
	deptField.setValue("");
	deptField.setRawValue("");
	//绩效单位
    deptDs.load({params:{start:0, limit:deptField.pageSize}});
	/* if(getCookie(schemIdCookieName)==schemDr){
		setComboValueFromServer(deptField,deptIdCookieName);
	}else{
		deptDs.on('load', function(ds, o){
			deptField.setValue("");
		});
	} */
};
function link(value,meta,record){
	return "<a href='dhc.pa.schemunitdetail.csp?schem="+Ext.getCmp('schemedistField').getValue()+"&rowid="+record.get('rowid')+"&extremum="+extremum.    getValue()+"'>"+record.get('KPIName')+"</a>";
};
//var extValue;
var range;
var groupRange;
extremum.on("select",function(cmb,rec,id ){
    sunfind(cmb.getValue());    
	//KPIDs.load({params:{start:0, limit:KPIField.pageSize}});
});

KPIField.on("select",function(cmb,rec,id ){
    sunfind(cmb.getValue());    
});

//DetailAddProxy+'&schem='+Ext.getCmp('schemedistField').getValue()
var ParamDs = new Ext.data.Store({
	proxy: DetailAddProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
           'rowid','unitSchem','KPIName','calUnitName','baseValue','trageValue','bestValue','baseup','trageup'
 
		]),
    remoteSort: true
});

ParamDs.setDefaultSort('rowid', 'DESC');

var addAdjustButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加',
		iconCls: 'add',
		handler: function(){addAdjustFun(ParamDs,SchemDetailDistGrid,ParamPagingToolbar);
		}
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
function kpiconfirm(schemedistField,rowid,extremum,title)
{
   Ext.MessageBox.confirm('提示','确实要设置该月指标区间?', function(btn){
    if (btn == 'yes'){
        window.open("dhc.pa.schemunitdetail.csp?schem="+schemedistField+"&rowid="+rowid+"&extremum="+extremum+"&title="+encodeURI(title), "", "toolbar=no,height=500,width=800");

    }
});
   
}


/*
ParamDs.on('beforeload', function(ds, o){
	ParamDs.proxy=new Ext.data.HttpProxy({url: UnitSchemDist+'?action=list&schem='+Ext.getCmp('schemedistField').getValue()+'&unit='+deptField.getValue()+'&trend='+Ext.getCmp('extremum').getValue()});
});
*/
function sunfind(str){
	dataStr=cycleIdCookieName+"^"+Ext.getCmp('cycleField').getValue()+"!"+schemIdCookieName+"^"+Ext.getCmp('schemedistField').getValue()+"!"+deptIdCookieName+"^"+Ext.getCmp('deptField').getValue()+"!"+trendIdCookieName+"^"+Ext.getCmp('extremum').getValue()+"!"+trendNameCookieName+"^"+Ext.getCmp('extremum').getRawValue();
	//批量设置cookie
	setBathCookieValue(dataStr);
	var schemdetaildistmain = Ext.getCmp('SchemDetailDistGrid');
	schemdetaildistmain.remove('first_center');

	ParamDs.proxy=new Ext.data.HttpProxy({url: UnitSchemDist+'?action=list&schem='+Ext.getCmp('schemedistField').getValue()+'&unit='+deptField.getValue()+'&trend='+Ext.getCmp('extremum').getValue()});
	ParamDs.load({params:{start:0, limit:schemedistField.pageSize}});

	if((extremum.getValue()=='H')||(extremum.getValue()=='L')){
     range1 = new Ext.grid.ColumnModel({
				columns: [
					{header: '科室名称', width: 80,align: 'left', dataIndex: 'unitSchem'},
					{header: '指标名称', 
					 width: 180,
					 align: 'left', 
					 dataIndex: 'KPIName',renderer:function(value,meta,record){
					   return "<a onClick=\"kpiconfirm('"+Ext.getCmp('schemedistField').getValue()+"','"+record.get('rowid')+"','"+extremum.getValue()+"','"+record.get('KPIName')+"');\" Style=\"cursor:pointer;\">"+record.get('KPIName')+"</a>";
						}
		             },
					{header: '计量单位', width: 80, dataIndex: 'calUnitName'},
					{header: '年基准值', width: 80, dataIndex: 'baseValue',align: 'right',renderer:format},
					{header: '年目标值', width: 80, dataIndex: 'trageValue',align: 'right',renderer:format},
					{header: '年最佳值', width: 80, dataIndex: 'bestValue',align: 'right',renderer:format}
				],
				defaultSortable: true
			});
	}
	else{
	range1 = new Ext.grid.ColumnModel({
					columns: [
						{header: '科室名称', width: 80,align: 'left', dataIndex: 'unitSchem'},
						{header: '指标名称', 
						width: 180,
						align: 'left', 
						dataIndex: 'KPIName',renderer:function(value,meta,record){
					   return "<a onClick=\"kpiconfirm('"+Ext.getCmp('schemedistField').getValue()+"','"+record.get('rowid')+"','"+extremum.getValue()+"','"+record.get('KPIName')+"');\" Style=\"cursor:pointer;\">"+record.get('KPIName')+"</a>";
						}
		             },
						{header: '计量单位', width: 80, dataIndex: 'calUnitName',renderer:format},
						{header: '年基准上限', width: 80, align: 'right',dataIndex: 'baseValue',align: 'right',renderer:format},
						{header: '年目标上限', width: 80, align: 'right',dataIndex: 'trageValue',align: 'right',renderer:format},
						{header: '年最佳值', width: 80, align: 'right',dataIndex: 'bestValue',align: 'right',renderer:format},
						{header: '年目标下限', width: 80,align: 'right', dataIndex: 'trageup',align: 'right',renderer:format},
						{header: '年基准下限', width: 80, align: 'right',dataIndex: 'baseup',align: 'right',renderer:format}
					],
					defaultSortable: true
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
			stripeRows: true
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
			stripeRows: true
		});
	}
	//alert(SchemDetailDistGrid1.id);
	schemdetaildistmain.add('SchemDetailDistGrid1');
	schemdetaildistmain.getLayout().setActiveItem('SchemDetailDistGrid1');
	schemdetaildistmain.doLayout();
}

function del(id){
  alert('测试');
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
					{columnWidth:.07,xtype:'label',text: '年度:'},
					cycleField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.07,xtype:'label',text: '方案:'},
					schemedistField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.07,xtype:'label',text: '科室:'},
					deptField,
					{columnWidth:.07,xtype:'label',text: '极值:'},
					extremum,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '设置参数值',name: 'editSchemDetailDist',tooltip: '修改',handler:function(){editSchemDetailDistFun(ParamDs,SchemDetailDistGrid1,ParamPagingToolbar)},iconCls: 'add'}
				]		
			}/*,{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				isFormField:true,
				items:[
					{columnWidth:.07,xtype:'label',text: '极值:'},
					extremum,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.07,xtype:'label',text: '考核指标:'},
					KPIField,
					{columnWidth:.02,xtype:'displayfield'}
					]
			}*/
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

extremumStore.on('load', function(ds, o){
	extremum.setValue(getCookie(trendIdCookieName));
	count3=1;
	ParamDs.proxy=new Ext.data.HttpProxy({url: UnitSchemDist+'?action=list&schem='+Ext.getCmp('schemedistField').getValue()+'&unit='+deptField.getValue()+'&trend='+Ext.getCmp('extremum').getValue()});
	ParamDs.load({params:{start:0, limit:schemedistField.pageSize}});
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
//SchemDetailDistGrid1.on("afteredit", afterEdit, SchemDetailDistGrid);    
ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
