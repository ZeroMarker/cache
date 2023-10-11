var hospid = session['LOGON.HOSPID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var deptsetUrl ='herp.budg.budgdeptsetexe.csp';
//////////////////医疗单位
var AddCompDRDs = new Ext.data.Store({
						proxy : "",
						url : commonboxUrl+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						//autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

			AddCompDRDs.on('load', function() {

						var Num=AddCompDRDs.getCount();
    					if (Num!=0){
						var id=AddCompDRDs.getAt(0).get('rowid');
						AddCompDRCombo.setValue(id);  
    					} 
					});

			var AddCompDRCombo = new Ext.form.ComboBox({
						id : 'AddCompDRCombo',
						name : 'AddCompDRCombo',
						fieldLabel : '医疗单位',
						store : AddCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						//allowBlank: false,
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 70,
						listWidth : 300,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});			

/////////////////科室类别//////////////
var unitDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=deptType&str='+encodeURIComponent(Ext.getCmp('unitField').getRawValue()),method:'POST'});
});
var unitField = new Ext.form.ComboBox({
	id: 'unitField',
	fieldLabel: '科室类别名称', 
	width:200,
	listWidth : 300,
	allowBlank: false,
	store: unitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室类别...',
	name: 'unitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
var unitDs2 = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unitDs2.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=deptType&str='+encodeURIComponent(Ext.getCmp('unitField2').getRawValue()),method:'POST'});
});
var unitField2 = new Ext.form.ComboBox({
	id: 'unitField2',
	fieldLabel: '科室类别名称',
	width:200,
	listWidth : 300,
	allowBlank: false,
	store: unitDs2,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室类别...',
	name: 'unitField2',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
/////////////////科主任//////////////
var unituserDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),method:'POST'});
});
var unituserField = new Ext.form.ComboBox({
	id: 'unituserField',
	fieldLabel: '科主任名称',
	width:200,
	listWidth :300,
	allowBlank: false,
	store: unituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科主任名称...',
	name: 'unituserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
/////////////////科室名称//////////////
var deptDs = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['rowid', 'name'])
			});

	deptDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxUrl+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()),
							method : 'POST'
						});
			});

	var deptCombo = new Ext.form.ComboBox({
				id: 'deptCombo',
				fieldLabel : '科室',
				store : deptDs,
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '请选择或者名称或编码...',
				width : 150,
				listWidth : 260,			
				pageSize : 10,
				minChars : 1,
				columnWidth : .1,
				selectOnFocus : true
			});
//var NameField = new Ext.form.TextField({
//	fieldLabel: '科室名称',
//	width:120,
//	emptyText:'请输入名称后者编码...',
//	name: 'unituserField',
//	selectOnFocus:true,
//	editable:true
//});


//////////////////////是否用于项目预算/////////////////////////
var IsProjStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});
var IsProjField = new Ext.form.ComboBox({
			id : 'IsProjField',
			fieldLabel : '用于项目预算否',
			width : 200,
			listWidth : 245,
			selectOnFocus : true,
			allowBlank : true,
			store : IsProjStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

//////////////////////是否大科科室/////////////////////////
var IsBudgStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});
		
var IsBudgField = new Ext.form.ComboBox({
			id : 'IsBudgField',
			fieldLabel : '是否大科科室',
			width : 200,
			listWidth : 245,
			selectOnFocus : true,
			allowBlank : true,
			store : IsBudgStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
		
//////////////////////是否有效/////////////////////////
var IsStateStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});	
var IsStateField = new Ext.form.ComboBox({
			id : 'IsStateField',
			fieldLabel : '是否有效',
			width : 200,
			listWidth : 245,
			selectOnFocus : true,
			allowBlank : true,
			store : IsStateStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
		
//////////////////////是否末级/////////////////////////
var IsLastStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});	
var IsLastField = new Ext.form.ComboBox({
			id : 'IsLastField',
			fieldLabel : '是否末级',
			width : 200,
			listWidth : 245,
			selectOnFocus : true,
			allowBlank : true,
			store : IsLastStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
			
		
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	      	var deptdr = deptCombo.getValue();
	      	var type = unitField2.getValue();
		itemGrid.load({params : {start : 0,
								limit : itemGrid.getBottomToolbar().pageSize,deptdr : deptdr,type : type}});
								
	}
});

var delButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    //iconCls:'remove',
    handler:function() {
    // get the selected items
    //定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:deptsetUrl+'?action=del&rowid='+rowid,
					waitMsg:'审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params : {start : Ext
											.isEmpty(itemGrid.getBottomToolbar().cursor)
											? 0
											: itemGrid.getBottomToolbar().cursor,
								limit : itemGrid.getBottomToolbar().pageSize,deptdr : deptdr,type : type}});
						}else{
							Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除目标记录吗?',handler);
	}
	});

var itemGrid = new dhc.herp.Grid({
        title: '预算科室维护',
        width: 400,
        //edit:false,                   //是否可编辑
        //readerModel:'local',
        region: 'center',
        url: deptsetUrl,
		tbar:['科室:',deptCombo,'科室类别:',unitField2, '-',findButton],
		atLoad : true, // 是否自动刷新
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        }, {
            id:'CompName',
            header: '医疗单位',
			calunit:true,
			allowBlank: false,
			width:120,
            dataIndex: 'CompName',
			type:AddCompDRCombo
        },{
            id:'code',
            header: '科室编码',
			allowBlank: false,
			width:120,
			edit:true,
            dataIndex: 'code'
        },{
           id:'name',
            header: '科室名称',
			allowBlank: false,
			width:180,
            dataIndex: 'name'
        },{
            id:'class1',
            header: '科室类别',
			calunit:true,
			allowBlank: false,
			width:120,
            dataIndex: 'class1',
			type:unitField
        },{
            id:'directdr',
            header: '科主任',
			calunit:true,
			allowBlank: false,
			width:160,
            dataIndex: 'directdr',
			type:unituserField
        },{
            id:'Level',
            header: '科室层次',
			allowBlank: false,
			width:60,
			edit:true,
            dataIndex: 'Level'
        },{
            id:'SupDeptID',
            header: '上级科室',
			width:200,
			edit:true,
            dataIndex: 'SupDeptID'
        },{
            id:'IOFlag',
            header: '门诊住院',
			allowBlank: true,
			width:60,
			edit:true,
            dataIndex: 'IOFlag'
        },{
            id:'IsBudg',
            header: '是否大科科室',
			width:80,
            dataIndex: 'IsBudg',
			type:IsBudgField
			
        },{
            id:'State',
            header: '是否有效',
			width:60,
            dataIndex: 'State',
			type:IsStateField
			
        },{
            id:'IsItem',
            header: '是否用于项目预算',
			width:110,
            dataIndex: 'IsItem',
			type:IsProjField
        },{
            id:'Pym',
            header: '拼音码',
			allowBlank: true,
			width:80,
            dataIndex: 'Pym'
        },{
            id:'IsLast',
            header: '是否末级',
			width:60,
            dataIndex: 'IsLast',
			type:IsLastField
			
        }]
    
    });

	//itemGrid.hiddenButton(3);
	//itemGrid.hiddenButton(4);
	itemGrid.btnResetHide();  //隐藏重置按钮
	itemGrid.btnPrintHide();  //隐藏打印按钮