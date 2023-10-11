//var recname = session['LOGON.USERID'];
//alert(recname);
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var auditreplaceURL='herp.budg.budgauditreplaceexe.csp';
var unituserDs = new Ext.data.Store({
	atLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxURL+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),method:'POST'});
});
var unituserField = new Ext.form.ComboBox({
	id: 'unituserField',
	fieldLabel: '人员名称',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: unituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择人员姓名...',
	name: 'unituserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/*
var endDateField= new Ext.form.DateField({
	//format:'Y-m-d',
	//emptyText:'结束时间...',
	columnWidth:1
});

*/
//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除',
   // tooltip:'删除',       
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
		}else{
			var rowid = rowObj[0].get("rowid");
			//alert(rowid);
		}
		if(rowObj[0].get("chkstate")=="1")
		{
		  
		   // alert(rowid);
			Ext.Msg.show({title:'注意',msg:'已审核,不能删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		function handler(id){
			if(id=="yes"){
				Ext.each(rowObj, function(record) {
							if (Ext.isEmpty(record.get("rowid"))) {
								itemGrid.getStore().remove(record);
								return;}
								
					Ext.Ajax.request({
						url:auditreplaceURL+'?action=del&rowid='+rowid,
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
								
							}else{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
						});	
			}else{
				return;
			}

		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});
	
var auditButton = new Ext.Toolbar.Button({
	id:'auditButton',
	text: '审核',
	iconCls: 'option',
	handler: function(){
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要审核的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var chkname = session['LOGON.USERID'];
			//alert(rowid);
		}
		if(rowObj[0].get("chkstate")=="1")
		{
		  
		   // alert(rowid);
			Ext.Msg.show({title:'注意',msg:'数据已审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:auditreplaceURL+'?action=audit&rowid='+rowid+'&chkname='+chkname,
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
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核该条记录吗?审核后不能删除和修改',handler);
	}
});
//没用到
var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls: 'option',
	handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
        if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		if(rowObj[0].get("chkstate")=="已审核")
		{
			Ext.Msg.show({title:'注意',msg:'已审核,不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		auditreplaceEdit(rowid);
	}
});


var itemGrid = new dhc.herp.Gridlyf({
        title: '代审定义维护',
        width: 400,
        //edit:false,                   //是否可编辑
        //readerModel:'local',
        region: 'center',
        url: auditreplaceURL,      

		atLoad : true, // 是否自动刷新
		listeners:{
        'cellclick' : function(grid, rowIndex, columnIndex, e) {
               var record = grid.getStore().getAt(rowIndex);
               // 根据条件设置单元格点击编辑是否可用
               if ((record.get('chkstate') == '1') &&((columnIndex == 2)||(columnIndex == 3)||(columnIndex == 4)||(columnIndex == 5)||(columnIndex == 6)||(columnIndex == 7))) {    
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
        
            if ((record.get('chkstate') == '1') &&((columnIndex == 2)||(columnIndex == 3)||(columnIndex == 4)||(columnIndex == 5)||(columnIndex == 6)||(columnIndex == 7))) {          
                   return false;
            } else 
                   {
                   return true;
                   }
     	}},
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        }, {
            id:'CompName',
            header: '医疗单位',
			allowBlank:true,
			editable:false,
			width:100,
            dataIndex: 'CompName'
        },{
            id:'username',
            header: '当事人',
			allowBlank: false,
			width:100,
			editable:true,
            dataIndex: 'username',
            /*
            renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
        	var rd = record.data['chkstate']                   
        	cellmeta.css="cellColor3";
                if (rd='1') {
                      cellmeta.css="cellColor1";// 设置可编辑的单元格背景色
                      return 
                      //'<span style="cursor:hand;backgroundColor:red">'+value+'</span>';
                } else {
                      return 
                       //'<span style="cursor:hand"><u></u></span>';
              }
        	},
            */
            type: unituserField
        },{
            id:'fstname',
            header: '第一替代人',
			allowBlank: false,
			width:100,
            dataIndex: 'fstname',
            type:unituserField
        },{
            id:'sndname',
            header: '第二替代人',
			allowBlank: false,
			width:100,
            dataIndex: 'sndname',
			type:unituserField
        },{
            id:'begindate',
            header: '开始时间',
			width:100,
			//format:'Y-m-d',
            dataIndex: 'begindate',
			allowBlank: false,
			type: "dateField"		//使用	herpGrid
        },{
            id:'enddate',
            header: '结束时间',
			allowBlank: false,
			width:100,
            dataIndex: 'enddate',
		//	type:endDateField,
			type: "dateField"	
			/*
			renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
			}
			*/
        },{
            id:'putdate',
            header: '信息提交时间',
			allowBlank: true,
			width:100,
            dataIndex: 'putdate',
            type: "dateField"	
        },{
            id:'recnamed',
            header: '记录人',
			editable:false,
			width:100,
            dataIndex: 'recnamed'
        },{
            id:'chkname',
            header: '审批人',
			//allowBlank: false,
			editable:false,
			width:100,
            dataIndex: 'chkname'
        //
        },{
            id:'chkdate',
            header: '审批时间',
			//allowBlank: false,
			editable:false,
			width:100,
            dataIndex: 'chkdate'
        },{
            id:'chkstate',
            header: '审批状态',
			hidden: true,
			editable:false,
			width:100,
            dataIndex: 'chkstate'
        },{
            id:'chkstateed',
            header: '审批状态',
			editable:false,
			hidden:false,
			width:100,
            dataIndex: 'chkstateed'
        }]
    
    });

       
        //tbar:[auditButton,'-',delButton],
        itemGrid.addButton('-');
        itemGrid.addButton(delButton);
        itemGrid.addButton('-');
        itemGrid.addButton(auditButton);
        
        itemGrid.btnResetHide(); 	//隐藏重置按钮
		itemGrid.btnDeleteHide(); //隐藏删除按钮
		itemGrid.btnPrintHide(); 	//隐藏打印按钮
		//itemGrid.hiddenButton(8);
	//	itemGrid.hiddenButton(9);
	
