var userId = session['LOGON.USERID'];
var projUrl='dhc.pa.selffillandreportexe.csp'   
var fm = Ext.form;
//---------------------------------------------------------------------------------
var dataStr="";
var data="";
var data1=[['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],
['10','10月'],['11','11月'],['12','12月']];
var data2=[['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']];
var data3=[['01','1~6上半年'],['02','7~12下半年']];
var data4=[['0','00']];

//年度
var yearField= new Ext.form.TextField({
                id:'yearField',
                value: "2015",//(new Date()).getFullYear(),
                width: 50,
                triggerAction: 'all',
                allowBlank: false,
                fieldLabel: '年度',
				emptyText:'选输入年份...',
                name: 'yearField',
                allowBlank: false ,
                regex:/^\d{4}$/,
                regexText:"只能输入数字年份",
                editable:true                			
});

//期间类型
var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value: 'M', 
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true,
	listeners:{"select":function(combo,record,index){ 
		DeptSchemDs.removeAll();   
        DeptSchemField.setValue('');
        DeptSchemDs.proxy = new Ext.data.HttpProxy({url:projUrl+'?action=listdeptschem&userId='+userId+'&frequency='+encodeURIComponent(Ext.getCmp('periodTypeField').getValue()),method:'POST'});
		DeptSchemDs.load({params:{start:0,limit:10}});
	}}   
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	periodStore.loadData(data);
	searchFun(cmb.getValue());
});

//期间
var periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
periodStore.loadData([['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']]);
var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
	value:'01', 
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});


//期间类别与方案查询的二级联动控制
function searchFun(periodType){
	periodField.setValue("");
	periodField.setRawValue("");
	
};

//选择自查
var DeptSchemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

DeptSchemDs.on('beforeload', function(ds, o){
	var periodType=periodTypeField.getValue();	
	var frequency = periodTypeField.getValue();
	ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.selffillandreportexe.csp?action=listdeptschem&userId='+userId+'&frequency='+frequency,method:'POST'})
	
});

var DeptSchemField = new Ext.form.ComboBox({
	id: 'DeptSchemField',
	fieldLabel:'选择自查',
	width:200,
	listWidth : 200,
	allowBlank: false,
	store: DeptSchemDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择自查...',
	name: 'DeptSchemField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

DeptSchemField.on('select', function(combo,record,index){ 	
        //alert("aa");	
		deptDs.removeAll();   
        deptField.setValue('');
        deptDs.proxy = new Ext.data.HttpProxy({url: projUrl+'?action=listdept&userId='+userId+'&DschemDr='+Ext.getCmp('DeptSchemField').getValue(),method:'POST'});
		deptDs.load({params:{start:0,limit:10}});	
	});
//权限科室
var deptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

deptDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url: projUrl+'?action=listdept&userId='+userId+'&DschemDr='+DeptSchemField.getValue(),method:'POST'});
	
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel:'权限科室',
	width:200,
	listWidth : 200,
	allowBlank: false,
	store: deptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'deptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{"select":function(combo,record,index){ 		
		search();	
			
	}}   
});

//查询面板
var autohisoutmedvouchForm = new Ext.form.FormPanel({
		//title:'自查填报',
		region:'north',
		frame:true,
		labelWidth:100,
		height:90,
		items:[{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				isFormField:true,
				items:[{columnWidth:.9,xtype: 'displayfield',value: '<font size="5px"><center>自 查 填 报</center></font>'}]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			labelWidth:100,
			items:[
					{xtype:'label',text: '年度:',style:'margin:2px 5px 0px 10px;'},
					yearField,
					{xtype:'label',text: '期间类型:',style:'margin:2px 5px 0px 5px;'},
					periodTypeField,
					{xtype:'label',text: '期间:',style:'margin:2px 5px 0px 5px;'},
					periodField,
					{xtype:'label',text: '选择自查:',style:'margin:2px 5px 0px 5px;'},
					DeptSchemField,
					{xtype:'label',text: '权限科室:',style:'margin:2px 5px 0px 5px;'},
					deptField,
					{xtype:'button',id:'sumBtn',text: '提交',style:'margin:2px 10px 0px 5px;',name: 'gb',tooltip: '提交',iconCls: 'remove', handler:function(){submitHandler()}},
					{xtype:'button',id:'uploadBtn',text: '上传',name: 'gb',tooltip: '上传',iconCls: 'remove', handler:function(){cancelsubmit()}}   
					
					
				]
			}
		]
});
var year ="";
var frequency ="";
var acuttypeitem ="";
var DschemDr ="";
var deptDr = "";

////=====================================固定头=========================================//

var editStore={};
var columnArry=[];

var sm = new Ext.grid.CheckboxSelectionModel(); 
var editCm = new Ext.grid.ColumnModel({
	defaults: {
		sortable: true          
	},
	columns: columnArry
});
//===========================编辑面板====================================
var editGrid = new Ext.grid.EditorGridPanel({
	store: editStore,
	cm: editCm,
	sm:sm,
	border:1,
	//frame: true,
	region:'center',
	autoScroll:true,
	clicksToEdit: 1
	
});

cancelsubmit = function(){
		
		var deptDr = deptField.getValue()
	//alert(deptDr);
	if (deptDr!=0){
			uploadMainFun(editGrid,'deptDr',deptDr);//附件上传wenjian
			}
			else{
				Ext.Msg.show({title:'注意',msg:'权限科室为空不可以上传!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;	}
			
			
	
}

