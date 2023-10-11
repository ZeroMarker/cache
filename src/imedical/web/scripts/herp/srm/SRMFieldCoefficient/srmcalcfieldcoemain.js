
var FieldCoefficientUrl='herp.srm.fieldcoefficientexe.csp';


function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};

///////////////////年/////////////////////////////  
var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:FieldCoefficientUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '年',
	width:120,
	listWidth : 260,
	//allowBlank : false, 
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '95%',
	//emptyText:'请选择开始时间...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//系统模块号
var SysModListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
SysModListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('SysModListField').getRawValue()),
						method : 'POST'
					});
		});
var SysModListField = new Ext.form.ComboBox({
            id:'SysModListField',
			name:'SysModListField',
			fieldLabel : '系统模块',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : false,
			store : SysModListDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
var CodeField = new Ext.form.TextField({
	  id:'CodeField',
    fieldLabel: '编码',
	  width:120,
    //allowBlank: false,
    //emptyText:'编码...',
    anchor: '95%'
	});
var NameField = new Ext.form.TextField({
	  id:'NameField',
    fieldLabel: '名称',
	  width:120,
    //allowBlank: false,
    //emptyText:'名称...',
    anchor: '95%'
	});
//系统模块号
var SysModDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
SysModDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('SysModField').getRawValue()),
						method : 'POST'
					});
		});
var SysModField = new Ext.form.ComboBox({
            id:'SysModField',
			name:'SysModField',
			fieldLabel : '系统模块',
			width : 150,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : SysModDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
/**
//是否由其他字段构成
var IsComprehensiveDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});
var IsComprehensiveField = new Ext.form.ComboBox({
			fieldLabel : '是否由其他字段构成',
			width : 150,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsComprehensiveDs,
			//anchor : '90%',
			value:'1', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
**/
//计算方法
var CalcMethodDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '比例系数法'], ['2', '公式法'], ['3', '等比步长法'], ['4', '非等比步长法'], ['5', '列举法']]
		});
var CalcMethodField = new Ext.form.ComboBox({
			fieldLabel : '计算方法',
			width : 150,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : CalcMethodDs,
			//anchor : '90%',
			value:'1', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
/////////////////// 查询按钮 
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'search',
	handler: function(){
	    var year = YearField.getValue();
		var sysno = SysModListField.getValue();
		var code = CodeField.getValue();
		var name = NameField.getValue();
	
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
			year:year,
			SysNO:sysno,
		    Code: code,
		    Name: name
		   }
	  })
  }
});

// ///////////////////////////////////////////
var addButton = new Ext.Toolbar.Button({
			text : '新增',
			iconCls : 'edit_add',
			handler : function() {
				FieldCoefficientAddFun();
			}
		});

var editButton = new Ext.Toolbar.Button({
			text : '修改',
			//tooltip : '修改',
			iconCls : 'pencil',
			handler : function() {
				FieldCoefficientEditFun();
			}
		});

var delButton = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除',
	iconCls : 'edit_remove',
	handler : function() {
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";

		if (len < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择需要删除的记录!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			tmpRowid = rowObj[0].get("rowid");
			Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
				if (btn == 'yes') {
					Ext.Ajax.request({
						url : FieldCoefficientUrl + '?action=del&rowid=' + tmpRowid,
						waitMsg : '删除中...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '错误',
										msg : '请检查网络连接!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : '注意',
											msg : '操作成功!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								itemGrid.load({
											params : {
												start : 0,
												limit : 25
											}
										});
							} else {
								Ext.Msg.show({
											title : '错误',
											msg : '错误',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
				}
			})
		}
	}
});
//复制按钮
var CopyButton = new Ext.Toolbar.Button({
	text: '复制',
    tooltip:'复制上年数据到本年度',       
    id:'CopyButton', 
    iconCls:'copy',
	handler:function(){
		function handler(id){
			if(id=="yes"){
					Ext.Ajax.request({
						url:FieldCoefficientUrl+'?action=copy',
						waitMsg:'复制中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'复制成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25}});
							}else{
							    var err=jsonData.info;
								Ext.Msg.show({title:'错误',msg:err,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{return;}
		}
		Ext.MessageBox.confirm('提示','确实要复制上年数据到本年度吗?',handler);
	}
});
var itemGrid = new dhc.herp.Grid({
        title: '字段系数维护列表',
		iconCls: 'list',
        width: 400,
        edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: FieldCoefficientUrl,	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
            hidden: true
        },{
            id:'Year',
            header: '年度',
			width:80,
            dataIndex: 'Year'
			//type:YearField
        },{
            id:'SysNO',
            header: '系统模块',
			width:120,
            dataIndex: 'SysNO'
			//type:SysModField
        },{
            id:'Code',
            header: '字段编码',
			width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '字段名称',
			width:150,
            dataIndex: 'Name'
        },{
            id:'CalcMethod',
            header: '计算方法',
			allowBlank: true,
			width:100,
			hidden:false,
            dataIndex: 'CalcMethod'
        },{
            id:'CoefficientType',
            header: '系数类型',
			editable:true,
			width:100,
            dataIndex: 'CoefficientType'
        },{
            id:'DefaultValue',
            header: '默认值',
			editable:true,
			width:100,
			align:'left',
            dataIndex: 'DefaultValue'
         
        },{
            id:'FourmulaDesc',
            header: '公式描述',
			editable:true,
			width:100,
            dataIndex: 'FourmulaDesc'
        },{
            id:'FieldValue',
            header: '字段对应值',
			editable:true,
			width:180,
			align:'left',
            dataIndex: 'FieldValue'
        },{
            id:'FieldMinValue',
            header: '等比最小值',
			editable:true,
			width:80,
			align:'right',
            dataIndex: 'FieldMinValue',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'FieldMaxValue',
            header: '等比最大值',
			editable:true,
			width:80,
			align:'right',
            dataIndex: 'FieldMaxValue',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'StepSize',
            header: '等比步长',
			editable:true,
			width:80,
			align:'right',
            dataIndex: 'StepSize',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'IntervalCoefficient',
            header: '等比系数',
			editable:true,
			width:80,
			align:'right',
            dataIndex: 'IntervalCoefficient',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'MinValue',
            header: '非等比最小值',
			editable:true,
			width:100,
			align:'right',
            dataIndex: 'MinValue',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'MaxValue',
            header: '非等比最大值',
			editable:true,
			width:100,
			align:'right',
            dataIndex: 'MaxValue',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'Coefficient',
            header: '系数',
			editable:true,
			width:180,
			align:'left',
            dataIndex: 'Coefficient'
        },{
            id:'CoefficientDesc',
            header: '系数描述',
			hidden:true,
			editable:true,
			width:180,
            dataIndex: 'CoefficientDesc'
        }],
        tbar :['','年度','',YearField,'','系统模块','',SysModListField,'','字段编码','', CodeField,'','字段名称','',NameField,'-',findButton,'-',addButton,'-',editButton,'-',delButton,'-',CopyButton]
});

   itemGrid.btnResetHide();  //隐藏重置按钮
   itemGrid.btnPrintHide();  //隐藏打印按钮
   itemGrid.btnAddHide();  //隐藏增加按钮
   itemGrid.btnDeleteHide();  //隐藏删除按钮
   itemGrid.btnSaveHide();  //隐藏修改按钮
   
  //itemGrid.load({	params:{start:0, limit:25}});
