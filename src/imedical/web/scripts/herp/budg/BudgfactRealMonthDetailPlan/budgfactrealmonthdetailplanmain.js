var checker = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var tmpData="";
var budgfactrealmonthdetailplanDs=function(){
		
	var yearmonth=Ext.getCmp('yearmonField').getValue();
	var datafrom=Ext.getCmp('dataField').getValue();
	
    tmpData=yearmonth+'^'+datafrom;
	itemGrid.load(({params:{start:0, limit:25,yearmonth:yearmonth,datafrom:datafrom}}));
};

//获取年月
var yearmonthDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});


yearmonthDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgcommoncomboxexe.csp'+'?action=year&flag=1',method:'POST'});
});

var yearmonthField = new Ext.form.ComboBox({
	id: 'yearmonthField',
	fieldLabel: '年月',
	width:200,
	listWidth : 300,
	//allowBlank: false,
	store: yearmonthDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年月...',
	name: 'yearmonthField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//查询年月
var yearmonDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});


yearmonDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgcommoncomboxexe.csp'+'?action=year&flag=1',method:'POST'});
});

var yearmonField = new Ext.form.ComboBox({
	id: 'yearmonField',
	fieldLabel: '年月',
	width:200,
	listWidth : 300,
	//allowBlank: false,
	store: yearmonDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年月...',
	name: 'yearmonField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var unitDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgcommoncomboxexe.csp'+'?action=calunit',method:'POST'});
});

var unitField = new Ext.form.ComboBox({
	id: 'unitField',
	fieldLabel: '计量单位',
	width:200,
	listWidth : 300,
	//allowBlank: false,
	store: unitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年月...',
	name: 'unitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var deptnameDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


deptnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgcommoncomboxexe.csp'+'?action=dept',method:'POST'});
});

var deptnameField = new Ext.form.ComboBox({
	id: 'deptnameField',
	fieldLabel: '科室名称',
	width:150,
	listWidth :300,
	//allowBlank: false,
	store: deptnameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室名称...',
	name: 'deptnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//获取数据来源

var dataDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


dataDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailplanexe.csp'+'?action=data&str='+encodeURIComponent(Ext.getCmp('dataField').getRawValue()),method:'POST'});
});

var dataField = new Ext.form.ComboBox({
	id: 'dataField',
	fieldLabel: '数据来源',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: dataDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择数据来源...',
	name: 'dataField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//获取数据来源

var datafromDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


datafromDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailplanexe.csp'+'?action=data&str='+encodeURIComponent(Ext.getCmp('datafromField').getRawValue()),method:'POST'});
});

var datafromField = new Ext.form.ComboBox({
	id: 'datafromField',
	fieldLabel: '数据来源',
	width:150,
	listWidth :300,
	//allowBlank: false,
	store: datafromDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择数据来源...',
	name: 'datafromField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//获取科目名称

var itemdescDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


itemdescDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgfactrealmonthdetailplanexe.csp'+'?action=desc&str='+encodeURIComponent(Ext.getCmp('itemdescField').getRawValue()),method:'POST'});
});

var itemdescField = new Ext.form.ComboBox({
	id: 'itemdescField',
	fieldLabel: '科室名称',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: itemdescDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室名称...',
	name: 'itemdescField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
var tmpTitle='医疗计划执行数据维护';
var combos = new Ext.FormPanel({
	height:130,
	region:'north',
	frame:true,
	defaults: {bodyStyle:'padding:5px'},
		items:[{
		xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'<center><p style="font-weight:bold;font-size:150%">'+tmpTitle+'</p></center>',
				columnWidth:1,
				height:'50'
			}
		]
	   },{
	    columnWidth:1,
	    xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'年月:',
				columnWidth:.08
			},
			yearmonField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.18
			},
			{
				xtype:'displayfield',
				value:'数据来源:',
				columnWidth:.1
			},
			dataField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.18
			},
			{
				columnWidth:0.05,
				xtype:'button',
				text: '查询',
				handler:function(b){
					budgfactrealmonthdetailplanDs();
				},
				iconCls: 'add'
			}		
		]
	}
	]
});

//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除',  
    id:'delButton', 
    iconCls:'remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var j = 0; j < len; j++){
		   if(rowObj[j].get("chkstate")=="1")
		   {     
			      Ext.Msg.show({title:'注意',msg:'已审核,不能删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		}
		function handler(id){
			if(id=="yes"){
			
						Ext.each(rowObj, function(record) {
						  if (Ext.isEmpty(record.get("rowid"))) {
						       itemGrid.getStore().remove(record);
						       return;
						}
      		            for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.budg.budgfactrealmonthdetailplanexe.csp?action=del&&rowid='+rowObj[i].get("rowid"),
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
						
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								//TargetTypeTabDs.load({params:{start:0, limit:20}});
								itemGrid.load({params:{start:0, limit:20}});
								
							}
							//else{
								//Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							//}
						},
						scope: this
					});
					}
					});
		    }else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});

var auditButton  = new Ext.Toolbar.Button({
		text: '审核',  
        id:'auditButton', 
        iconCls:'option',
        handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;

		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("chkstate")=="1")
		 {
			      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.budg.budgfactrealmonthdetailplanexe.csp?action=audit&&rowid='+rowObj[i].get("rowid")+'&checker='+checker,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
						
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								//TargetTypeTabDs.load({params:{start:0, limit:20}});
								itemGrid.load({params:{start:0, limit:20}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核该条记录吗?审核后不能删除和修改',handler);
    }
});


var noauditButton  = new Ext.Toolbar.Button({
		text:'取消审核',  
        id:'noauditButton', 
        iconCls:'remove',
        handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		var oprator = session['LOGON.USERID'];
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要取消审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		 for(var j= 0; j < len; j++){
		 if(rowObj[j].get("chkstate")=="0")
		 {
			      Ext.Msg.show({title:'注意',msg:'已取消审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.budg.budgfactrealmonthdetailplanexe.csp?action=noaudit&&rowid='+rowObj[i].get("rowid")+'&oprator='+oprator,
						waitMsg:'取消中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
						
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'取消审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								//TargetTypeTabDs.load({params:{start:0, limit:20}});
								itemGrid.load({params:{start:0, limit:20}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'取消审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要取消审核该条记录吗?',handler);
    }
});

var calculateButton  = new Ext.Toolbar.Button({
		text:'统计计算',  
        id:'calculateButton', 
        iconCls:'option',
        handler:function(){
        
        	var yearmonth=yearmonField.getValue();
			if(yearmonth=="")
		    {
			      Ext.Msg.show({title:'注意',msg:'请选择年月！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		   }
		 function handler(id){
			if(id=="yes"){

					    Ext.Ajax.request({
						url:'herp.budg.budgfactrealmonthdetailplanexe.csp?&action=calculate&&yearmonth='+yearmonth,
						waitMsg:'取消中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
						
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'统计成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								//TargetTypeTabDs.load({params:{start:0, limit:20}});
								itemGrid.load({params:{start:0, limit:20}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'统计失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要统计记录吗?',handler);
    }
});



var itemGrid = new dhc.herp.Grid({
      //  title: '科目预算执行数据维护',
        width: 400,
        //edit:false,                   //是否可编辑
        //readerModel:'local',
        region: 'center',
        url: 'herp.budg.budgfactrealmonthdetailplanexe.csp',
        //tbar:[delButton,'-',auditButton,'-',noauditButton,'-',calculateButton],
		//atLoad : true, // 是否自动刷新
		listeners:{
        'cellclick' : function(grid, rowIndex, columnIndex, e) {
               var record = grid.getStore().getAt(rowIndex);
               // 根据条件设置单元格点击编辑是否可用
               if ((record.get('chkstate') == '1') &&((columnIndex == 9)||(columnIndex == 4)||(columnIndex == 5)||(columnIndex == 6)||(columnIndex == 7)||(columnIndex == 8))) {    
                      Ext.Msg.show({title:'注意',msg:'已审核,不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                      return false;
               } else 
                      {
                      return true;
                      }
        },        
        'celldblclick' : function(grid, rowIndex, columnIndex, e) {
            var record = grid.getStore().getAt(rowIndex);
            // 根据条件设置单元格点击编辑是否可用
        
            if ((record.get('chkstate') == '1') &&((columnIndex == 9)||(columnIndex == 4)||(columnIndex == 5)||(columnIndex == 6)||(columnIndex == 7)||(columnIndex == 8))) {          
                   return false;
            } else 
                   {
                   return true;
                   }
     	}},
        fields: [
        new Ext.grid.CheckboxSelectionModel({editable:false}),
        {
	            id : 'CompName',
	        header : '医疗单位',
                         width : 90,
	      editable : false,
	       hidden: true,
                     dataIndex : 'CompName'

	    },
        {
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'yearmonth',
            header: '年月',
			width:100,
			editable:true,
            dataIndex: 'yearmonth',
            type: yearmonthField
        },{
            id:'deptname',
            header: '科室名称',
			//allowBlank: false,
			editable:true,
			width:150,
            dataIndex: 'deptname',
            type: deptnameField
        },{
            id:'itemdesc',
            header: '科目名称',
			//allowBlank: false,
			width:150,
			editable:true,
            dataIndex: 'itemdesc',
			type: itemdescField
        },{
            id:'unitname',
            header: '计量单位',
			//allowBlank: false,
			width:100,
			editable:true,
            dataIndex: 'unitname',
			type: unitField
        },{
            id:'value',
            header: '执行金额',
            editable:true,
            align:'right',
			width:200,
            dataIndex: 'value'
        },{
            id:'datafrom',
            header: '数据来源',
			width:100,
			editable:true,
            dataIndex: 'datafrom',
			type: datafromField
        },{
            id:'chkstate',
            header: '审核状态',
			hidden: true,
			editable:false,
			width:100,
            dataIndex: 'chkstate'
        },{
            id:'chkstateed',
            header: '审核状态',
			editable:false,
			hidden:false,
			width:100,
            dataIndex: 'chkstateed'
        },{
            id:'oprator',
            header: '操作员',
			editable:false,
			width:100,
            dataIndex: 'oprator'
        },{
            id:'optime',
            header: '操作时间',
			editable:false,
			width:150,
            dataIndex: 'optime'
        }]
    
    });

        itemGrid.addButton('-');
        itemGrid.addButton(delButton);
        itemGrid.addButton('-');
        itemGrid.addButton(auditButton);
        itemGrid.addButton('-');
        itemGrid.addButton(noauditButton);
        itemGrid.addButton('-');
        itemGrid.addButton(calculateButton);
        
        itemGrid.btnResetHide(); 	//隐藏重置按钮
		itemGrid.btnDeleteHide(); //隐藏删除按钮
		itemGrid.btnPrintHide(); 	//隐藏打印按钮
	
