var data="";
var monthStore="";
//Ext.Ajax.timeout=90000000000000; 加上这句请求会取消
var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'herp.srm.calculatorexe.csp?action=cycle&str='+Ext.getCmp('cycleField').getRawValue(),method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'年度',
	width:180,
	listWidth : 260,
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

var calcuPanel = new Ext.form.FormPanel({
		title:'科研绩点计算',
		region:'north',
		frame:true,
		height:120,
		items:[{
			xtype: 'panel',
			layout:"column",
			height:25,
			hideLabel:true,
			isFormField:true,
			items:[
					{columnWidth:.0,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '☆ 科研绩点---绩点计算 ☆'}
				]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			height:50,
			isFormField:true,
			items:[
					{columnWidth:.07,xtype:'label',text: '年度:'},
					cycleField,
                    {
							       xtype : 'displayfield',
							       columnWidth : 0.1
					},
					{columnWidth:.05,xtype:'button',text: '绩点计算',name: 'bc',tooltip: '绩点计算'
					,handler:function(){pointcalcu()},iconCls: 'remove'}
				]
			}]
});
pointcalcu = function(){
              var year = cycleField.getValue(); 
			  if (year=="")
			  {
			  Ext.Msg.show({title:'错误',msg:'年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
			  }
	    Ext.Ajax.request({
		url: 'herp.srm.calculatorexe.csp?action=calu&year='+year,
		waitMsg:'保存中...',
		failure: function(result, request){
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'计算完成!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
								else
								{
								Ext.Msg.show({title:'注意',msg:'请重新计算!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
			}
		},
		scope: this
	});
}


var projUrl='herp.srm.calculatorexe.csp';
/////////////////年度//////////////////

var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=getyear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),
	method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '年度',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
/////////////////科室//////////////////

var DeptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=getdept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),
	method:'POST'});
});

var DeptField = new Ext.form.ComboBox({
	id: 'DeptField',
	fieldLabel: '科室',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:DeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{"select":function(combo,record,index){ 
			UserDs.removeAll();  
           	UserField.setValue('');
            UserDs.proxy = new Ext.data.HttpProxy({url:projUrl+'?action=getdeptuser&deptdr='+DeptField.getValue()+'&str='+encodeURIComponent(Ext.getCmp('UserField').getRawValue()),method:'POST'});
		    UserDs.load({params:{start:0,limit:10}});  
			        }}   
});
/////////////////科室人员//////////////////

var UserDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['userid','username'])
});


UserDs.on('beforeload', function(ds, o){
	var deptdr=DeptField.getValue();	
	if(!deptdr){
		Ext.Msg.show({title:'注意',msg:'请先选择科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
});

var UserField = new Ext.form.ComboBox({
	id: 'UserField',
	fieldLabel: '科室人员',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:UserDs,
	valueField: 'userid',
	displayField: 'username',
	triggerAction: 'all',
	emptyText:'请选择科室人员...',
	name: 'UserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////// 查询按钮 
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'add',
	handler: function(){
	    
		var year = YearField.getValue();
		var deptdr = DeptField.getValue();
	    var userdr = UserField.getValue();
		if(year==""){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
		}
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    year: year,
		    deptdr: deptdr,
			userdr:userdr
		   }
	  })
  }
});
var itemGrid = new dhc.herp.Grid({
        title: '科研绩点汇总查询',
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.calculatorexe.csp',	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            id:'usercode',
            header: '工作编码',
			      allowBlank: false,
			      width:120,
            dataIndex: 'usercode'
        },{
            id:'username',
            header: '姓名',
			      allowBlank: false,
			      width:120,
            dataIndex: 'username'
        },{
            id:'deptname',
            header: '所属科室',
			      allowBlank: false,
			      width:150,
            dataIndex: 'deptname'
        },{
            id:'achpoint',
            header: '科研获奖绩点',
			      allowBlank: false,
			      width:120,
            dataIndex: 'achpoint'
        },{
            id:'prjpoint',
            header: '课题立项绩点',
			      allowBlank: false,
			      width:120,
            dataIndex: 'prjpoint'
        },{
            id:'paperpoint',
            header: '论文绩点',
			      allowBlank: false,
			      width:120,
            dataIndex: 'paperpoint'
        },{
            id:'mpoint',
            header: '著作绩点',
			      allowBlank: false,
			      width:120,
            dataIndex: 'mpoint'
        },{
            id:'patentpoint',
            header: '专利绩点',
			      allowBlank: false,
			      width:120,
            dataIndex: 'patentpoint'
        },{
            id:'sumpoint',
            header: '总绩点',
			      allowBlank: false,
			      width:120,
            dataIndex: 'sumpoint'
        }],
		tbar :['年度:', YearField,'科室:', DeptField,'科室人员:',UserField,'-',findButton]
});
  
    itemGrid.btnAddHide();     //隐藏增加按钮
    itemGrid.btnSaveHide();    //隐藏保存按钮
    itemGrid.btnResetHide();   //隐藏重置按钮
    itemGrid.btnDeleteHide();  //隐藏删除按钮
    itemGrid.btnPrintHide();   //隐藏打印按钮

