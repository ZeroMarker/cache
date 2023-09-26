// 名称:库存项厂商管理
// 编写日期:2012-05-10

//=========================库存项厂商类别=============================
var conditionCodeField = new Ext.form.TextField({
	id:'conditionCodeField',
	fieldLabel:'代码',
	allowBlank:true,
	//width:180,
	listWidth:180,
	//emptyText:'代码...',
	anchor:'90%',
	selectOnFocus:true
});
	
var conditionNameField = new Ext.form.TextField({
	id:'conditionNameField',
	fieldLabel:'名称',
	allowBlank:true,
	//width:150,
	listWidth:150,
	//emptyText:'名称...',
	anchor:'90%',
	selectOnFocus:true
});

var PhManfStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["O",'出库'], ["I",'入库']]
});
	
var PhManfGrid="";
//配置数据源
var PhManfGridUrl = 'dhcst.phmanfaction.csp';
var PhManfGridProxy= new Ext.data.HttpProxy({url:PhManfGridUrl+'?actiontype=query',method:'POST'});
var PhManfGridDs = new Ext.data.Store({
	proxy:PhManfGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Name'},
		{name:'Address'},
		{name:'Tel'},
		{name:'AddManfId'},
		{name:'ParManfId'},
		{name:'ParManf'},
		{name:'DrugProductP'},
		{name:'DrugProductExp'},
		{name:'MatProductP'},
		{name:'MatProductExp'},
		{name:'ComLic'},
		{name:'ComLicDate'},
		{name:'Active'}
	]),
    remoteSort:false
});

//模型
var PhManfGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"代码",
        dataIndex:'Code',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'Name',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"地址",
        dataIndex:'Address',
        width:200,
        align:'left',
        sortable:false
    },{
        header:"电话",
        dataIndex:'Tel',
        width:100,
        align:'left',
        sortable:false
    },{
        header:"上级厂商",
        dataIndex:'ParManf',
        width:150,
        align:'left',
        sortable:false
    },{
        header:"药物生产许可",
        dataIndex:'DrugProductP',
        width:120,
        align:'left',
        sortable:false
    },{
        header:"药物生产许可有效期",
        dataIndex:'DrugProductExp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"材料生产许可",
        dataIndex:'MatProductP',
        width:120,
        align:'left',
        sortable:false
    },{
        header:"材料生产许可有效期",
        dataIndex:'MatProductExp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"工商执照许可",
        dataIndex:'ComLic',
        width:120,
        align:'left',
        sortable:false
    },{
        header:"工商执照许可有效期",
        dataIndex:'ComLicDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"激活标识",
        dataIndex:'Active',
        width:80,
        align:'left',
        sortable:true,
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    }
]);

//初始化默认排序功能
PhManfGridCm.defaultSortable = true;

var findPhManf = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var conditionCode = Ext.getCmp('conditionCodeField').getValue();
		var conditionName=Ext.getCmp('conditionNameField').getValue();
		PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:conditionCode,conditionName:conditionName},			callback : function(r,options, success) {					//Store异常处理方法二
			if(success==false){
				Msg.info("error", "查询错误，请查看日志!");
				//DrugInfoGrid.loadMask.hide();

				//return "{results:0,rows:[]}";
			}         				
		}});
	}
});

// 另存按钮
var SaveAsBT = new Ext.Toolbar.Button({
	text : '另存',
	tooltip : '另存为Excel',
	iconCls : 'page_excel',
	width : 70,
	height : 30,
	handler : function() {
		ExportAllToExcel(PhManfGrid);
	}
});
//厂商编辑窗口
//zdm,2013-03-06
function CreateEditWin(rowid){
	
	//厂商代码
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>厂商代码</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'厂商代码...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('codeField').getValue()==""){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'错误',msg:'厂商代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						nameField.focus();
					}
				}
			}
		}
	});
	
	//厂商名称
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>厂商名称</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'厂商名称...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('nameField').getValue()==""){
						Handler = function(){nameField.focus();}
						Ext.Msg.show({title:'错误',msg:'厂商名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						addressField.focus();
					}
				}
			}
		}
	});
	
	//厂商地址
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:'厂商地址',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'厂商地址...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						phoneField.focus();
				}
			}
		}
	});
	
	//厂商电话
	var phoneField = new Ext.form.TextField({
		id:'phoneField',
		fieldLabel:'厂商电话',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'厂商电话...',
		anchor:'90%',
		regex:/^[^\u4e00-\u9fa5]{0,}$/,
		regexText:'不正确的电话号码',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						lastPhManfField.focus();
				}
			}
		}
	});
	//上级厂商
	var lastPhManfField = new Ext.ux.ComboBox({
		id:'lastPhManfField',
		fieldLabel:'上级厂商',
		width:298,
		listWidth:298,
		allowBlank:true,
		store:PhManufacturerStore,
		valueField:'RowId',
		displayField:'Description',
		filterName: 'PHMNFName',
		//emptyText:'上级厂商...',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						drugProductPermitField.focus();
				}
			}
		}
	});
	
	//药物生产许可
	var drugProductPermitField = new Ext.form.TextField({
		id:'drugProductPermitField',
		fieldLabel:'药物生产许可',
		width:200,
		listWidth:200,
		//emptyText:'药物生产许可...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('drugProductPermitField').getValue()==""){
						Handler = function(){drugProductPermitField.focus();}
						Ext.Msg.show({title:'错误',msg:'药物生产许可不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						drugProductExpDate.focus();
					}
				}
			}
		}
	});
	
	//药物生产许可有效期
	var drugProductExpDate = new Ext.ux.DateField({ 
		id:'drugProductExpDate',
		fieldLabel:'药物生产许可有效期',  
		allowBlank:true,
		width:298,
		listWidth:298,    
		format:App_StkDateFormat,        
		//emptyText:'药物生产许可有效期 ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('drugProductExpDate').getValue()==""){
						Handler = function(){drugProductExpDate.focus();}
						Ext.Msg.show({title:'错误',msg:'药物生产许可有效期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						matProductPermitField.focus();
					}
				}
			}
		}      
	});  
	
	//材料生产许可
	var matProductPermitField = new Ext.form.TextField({
		id:'matProductPermitField',
		fieldLabel:'材料生产许可',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'材料生产许可...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('matProductPermitField').getValue()==""){
						Handler = function(){matProductPermitField.focus();}
						Ext.Msg.show({title:'错误',msg:'材料生产许可不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						matProductExpDate.focus();
					}
				}
			}
		}
	});
	
	//材料生产许可有效期
	var matProductExpDate = new Ext.ux.DateField({ 
		id:'matProductExpDate',
		fieldLabel:'材料生产许可有效期',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		//emptyText:'材料生产许可有效期 ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('matProductExpDate').getValue()==""){
						Handler = function(){matProductExpDate.focus();}
						Ext.Msg.show({title:'错误',msg:'材料生产许可有效期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						comLicField.focus();
					}
				}
			}
		}        
	});
	
	//工商执照许可
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:'工商执照许可',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'工商执照许可...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('comLicField').getValue()==""){
						Handler = function(){comLicField.focus();}
						Ext.Msg.show({title:'错误',msg:'工商执照许可不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						comLicExpDate.focus();
					}
				}
			}
		}
	});
	
	//工商执照许可有效期
	var comLicExpDate = new Ext.ux.DateField({ 
		id:'comLicExpDate',
		fieldLabel:'工商执照许可有效期',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		//emptyText:'工商执照许可有效期 ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('comLicExpDate').getValue()==""){
						Handler = function(){comLicExpDate.focus();}
						Ext.Msg.show({title:'错误',msg:'工商执照许可有效期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						activeField.focus();
						activeField.setValue(true);
					}
				}
			}
		}        
	});
	
	//激活
	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
		fieldLabel:'激活',
		hideLabel:false,
		allowBlank:false,
		checked:true,  //默认是"激活"状态
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					editButton.focus();
				}
			}
		}
	});
	
	//初始化面板
	editForm = new Ext.form.FormPanel({
		baseCls:'x-plain',
		labelWidth:130,
		labelAlign : 'right',
		autoScroll:true,
		items:[
			codeField,
			nameField,
			addressField,
			phoneField,
			lastPhManfField,
			drugProductPermitField,
			drugProductExpDate,
			matProductPermitField,
			matProductExpDate,
			comLicField,
			comLicExpDate,
			activeField
		]
	});
	
	//初始化添加按钮
	editButton = new Ext.Toolbar.Button({
		text:'确定',
		iconCls:'page_save',
		handler:function(){
			if(rowid==""){
				addHandler();
			}
			else{
				var ret2=confirm("是否生成厂商历史信息?");
				if (ret2==true){
					editHistoryHandler();
				}else{
				    editHandler();
				}
					
			}
		}
	});
	//初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
		text:'取消',
		iconCls:'page_close'
	});
	
	//定义取消按钮的响应函数
	cancelHandler = function(){
		win.close();
	};
	
	//添加取消按钮的监听事件
	cancelButton.addListener('click',cancelHandler,false);
	//初始化窗口
	var win = new Ext.Window({
		title:'厂商维护',
		width:500,
		height:440,
		minWidth:500,
		minHeight:405,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:editForm,
		buttons:[
			editButton,
			cancelButton
		],
		listeners:{
			'show':function(thisWin){
				Select(rowid);
			}
		}
	});

	win.show();
	//新增
	var addHandler = function(){
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue()
		if (drugProductExpDate!='') drugProductExpDate=drugProductExpDate.format(App_StkDateFormat);
		
		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue()
		if (matProductExpDate!='') matProductExpDate=matProductExpDate.format(App_StkDateFormat);

		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue()
		if (comLicExpDate!='') comLicExpDate=comLicExpDate.format(App_StkDateFormat);		
		
		var active = (activeField.getValue()==true)?'Y':'N';
		
		if(code.trim()==""){
			Msg.info('warning',"厂商代码不能为空");
			return;
		};
		
		if(name.trim()==""){
			Msg.info('warning',"厂商名称不能为空");
			return;
		};
		
		/*
		if(drugProductPermit.trim()==""){
			Ext.Msg.show({title:'提示',msg:'药物生产许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(drugProductExpDate==""){
			Ext.Msg.show({title:'提示',msg:'药物生产许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductPermit.trim()==""){
			Ext.Msg.show({title:'提示',msg:'材料生产许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductExpDate==""){
			Ext.Msg.show({title:'提示',msg:'材料生产许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLic.trim()==""){
			Ext.Msg.show({title:'提示',msg:'工商执照许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLicExpDate==""){
			Ext.Msg.show({title:'提示',msg:'工商执照许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		*/
		
		
		//拼data字符串
		var data=code+"^"+name+"^"+address+"^"+phone+"^"+lastPhManfId+"^"+drugProductPermit+"^"+drugProductExpDate+"^"+matProductPermit+"^"+matProductExpDate+"^"+comLic+"^"+comLicExpDate+"^"+active;
		var retstr=tkMakeServerCall("web.DHCST.ItmManf","CheckManfBeforeInsert",data,HospId)
		var retflag=retstr.split("^")[0];
		var retmsg=retstr.split("^")[1];
		if(retflag==-1)
		{
			Msg.info("error",retmsg);
			return;
		}
		else if((retflag>0)||(retflag==-2))
		{
			if(confirm("已存在相同的代码或者名称,是否放弃本次新增记录,启用原有记录?")==false)  return ;
			var updflag=0;
			if(retflag>0) updflag=1;
			var ret=tkMakeServerCall("web.DHCST.ItmManf","UpdateUniversal",retmsg,updflag)
			if(ret!=0)
			{
				Msg.info("error","更新通用类型失败,错误代码:"+ret);
			}
			else
			{
				Msg.info("success", "保存成功!");
				win.close();
				PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
			}
			return;
		}
		
		Ext.Ajax.request({
			url: PhManfGridUrl+'?actiontype=insert&data='+encodeURIComponent(data),
			method:'post',
			waitMsg:'新建中...',
			failure: function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					var newRowid = jsonData.info;
					Msg.info("success", "保存成功!");
					win.close();
					PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
				}else{
					if(jsonData.info==-1){
						Msg.info("error","名称重复!");
					}else if(jsonData.info==-11){
						Msg.info("error","代码重复!");
					}else{
						Msg.info("error", "保存失败!");
					}
				}
			},
			scope: this
		});
	};
	
	//修改
    var editHandler= function(){
		
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue()
		if (drugProductExpDate!='') {drugProductExpDate=drugProductExpDate.format(App_StkDateFormat);}
		
		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue()
		if (matProductExpDate!='') {matProductExpDate=matProductExpDate.format(App_StkDateFormat);}
		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue();
		if (comLicExpDate!='') {comLicExpDate=comLicExpDate.format(App_StkDateFormat);}
		var active = (activeField.getValue()==true)?'Y':'N';
		//alert('0')
		if(code.trim()==""){
			Ext.Msg.show({title:'提示',msg:'厂商代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(name.trim()==""){
			Ext.Msg.show({title:'提示',msg:'厂商名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		/*
		if(drugProductPermit.trim()==""){
			Ext.Msg.show({title:'提示',msg:'药物生产许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(drugProductExpDate==""){
			Ext.Msg.show({title:'提示',msg:'药物生产许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductPermit.trim()==""){
			Ext.Msg.show({title:'提示',msg:'材料生产许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductExpDate==""){
			Ext.Msg.show({title:'提示',msg:'材料生产许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLic.trim()==""){
			Ext.Msg.show({title:'提示',msg:'工商执照许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLicExpDate==""){
			Ext.Msg.show({title:'提示',msg:'工商执照许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		*/
		//拼data字符串
		var data=rowid+"^"+code+"^"+name+"^"+address+"^"+phone+"^"+lastPhManfId+"^"+drugProductPermit+"^"+drugProductExpDate+"^"+matProductPermit+"^"+matProductExpDate+"^"+comLic+"^"+comLicExpDate+"^"+active+"^";
		var retstr=tkMakeServerCall("web.DHCST.ItmManf","CheckManfBeforeUpdate",data,HospId)
		var retflag=retstr.split("^")[0];
		var retmsg=retstr.split("^")[1];
		if(retflag==-1)
		{
			Msg.info("error",retmsg);
			return;
		}
		else if((retflag>0)||(retflag==-2))
		{
			if(confirm("已存在相同的代码或者名称,是否放弃本次修改记录,启用原有记录?")==false)  return ;
			var updflag=0;
			if(retflag>0) updflag=1;
			var ret=tkMakeServerCall("web.DHCST.ItmManf","UpdateManf",data,retmsg,updflag)
			var flag=ret.split("^")[0];
			var msg=ret.split("^")[1];
			if(flag!=0)
			{
				Msg.info("error","更新通用类型失败,错误信息:"+msg);
			}
			else
			{
				Msg.info("success", "更新成功!");
				win.close();
				PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
			}
			return;
		}
		Ext.Ajax.request({
			url:PhManfGridUrl+'?actiontype=update&data='+encodeURIComponent(data)+'&histype=',
			waitMsg:'更新中...',
			failure:function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success:function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if(jsonData.success=='true'){
					Msg.info("success","更新成功!");
					PhManfGridDs.load({params:{start:PhManfPagingToolbar.cursor,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
					win.close();
				}else{
					if(jsonData.info==-1){
						Msg.info("error","名称重复!");
					}
					if(jsonData.info==-11){
						Msg.info("error","代码重复!");
					}
				}
			},
			scope: this
		});
	};
	var editHistoryHandler= function(){
		
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue()
		if (drugProductExpDate!='') {drugProductExpDate=drugProductExpDate.format(App_StkDateFormat);}
		
		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue()
		if (matProductExpDate!='') {matProductExpDate=matProductExpDate.format(App_StkDateFormat);}
		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue();
		if (comLicExpDate!='') {comLicExpDate=comLicExpDate.format(App_StkDateFormat);}
		var active = (activeField.getValue()==true)?'Y':'N';
		//alert('0')
		if(code.trim()==""){
			Ext.Msg.show({title:'提示',msg:'厂商代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(name.trim()==""){
			Ext.Msg.show({title:'提示',msg:'厂商名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		/*
		if(drugProductPermit.trim()==""){
			Ext.Msg.show({title:'提示',msg:'药物生产许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(drugProductExpDate==""){
			Ext.Msg.show({title:'提示',msg:'药物生产许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductPermit.trim()==""){
			Ext.Msg.show({title:'提示',msg:'材料生产许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductExpDate==""){
			Ext.Msg.show({title:'提示',msg:'材料生产许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLic.trim()==""){
			Ext.Msg.show({title:'提示',msg:'工商执照许可为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLicExpDate==""){
			Ext.Msg.show({title:'提示',msg:'工商执照许可有效期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		*/
		//拼data字符串
		var data=rowid+"^"+code+"^"+name+"^"+address+"^"+phone+"^"+lastPhManfId+"^"+drugProductPermit+"^"+drugProductExpDate+"^"+matProductPermit+"^"+matProductExpDate+"^"+comLic+"^"+comLicExpDate+"^"+active+"^";
		var retstr=tkMakeServerCall("web.DHCST.ItmManf","CheckManfBeforeUpdate",data,HospId)
		var retflag=retstr.split("^")[0];
		var retmsg=retstr.split("^")[1];
		if(retflag==-1)
		{
			Msg.info("error",retmsg);
			return;
		}
		else if((retflag>0)||(retflag==-2))
		{
			if(confirm("已存在相同的代码或者名称,是否放弃本次修改记录,启用原有记录?")==false)  return ;
			var updflag=0;
			if(retflag>0) updflag=1;
			var ret=tkMakeServerCall("web.DHCST.ItmManf","UpdateManf",data,retmsg,updflag,"1")
			var flag=ret.split("^")[0];
			var msg=ret.split("^")[1];
			if(flag!=0)
			{
				Msg.info("error","更新通用类型失败,错误信息:"+msg);
			}
			else
			{
				Msg.info("success", "保存成功!");
				win.close();
				PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
			}
			return;
		}
		Ext.Ajax.request({
			url:PhManfGridUrl+'?actiontype=update&data='+encodeURIComponent(data)+'&histype=1',
			waitMsg:'更新中...',
			failure:function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success:function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if(jsonData.success=='true'){
					Msg.info("success","更新成功!");
					PhManfGridDs.load({params:{start:PhManfPagingToolbar.cursor,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
					win.close();
				}else{
					if(jsonData.info==-1){
						Msg.info("error","名称重复!");
					}
					if(jsonData.info==-11){
						Msg.info("error","代码重复!");
					}
				}
			},
			scope: this
		});
	};
	
	function Select(rowid){
		Ext.Ajax.request({
			url: PhManfGridUrl+'?actiontype=queryByRowId&rowid='+rowid,
			failure: function(result, request) {
				Msg.info("error", "请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					//查询成功,赋值给控件
					var value = jsonData.info;
					var arr = value.split("^");
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('addressField').setValue(arr[2]);
					Ext.getCmp('phoneField').setValue(arr[3]);
					Ext.getCmp('lastPhManfField').setValue(arr[5]);
					Ext.getCmp('lastPhManfField').setRawValue(arr[6]);
					Ext.getCmp('drugProductPermitField').setValue(arr[7]);
					Ext.getCmp('drugProductExpDate').setValue(arr[8]);
					Ext.getCmp('matProductPermitField').setValue(arr[9]);
					Ext.getCmp('matProductExpDate').setValue(arr[10]);
					Ext.getCmp('comLicField').setValue(arr[11]);
					Ext.getCmp('comLicExpDate').setValue(arr[12]);
					Ext.getCmp('activeField').setValue((arr[13]=="Y")?true:false);
					//s Data1=Code_"^"_Name_"^"_Address_"^"_Tel_"^"_ManfAddId_"^"_$g(ParManfId)_"^"_$g(ParManf)_"^"_$g(DrugProductP)_"^"_$g(DrugProductE)_"^"_$g(MatProductP)_"^"_$g(MatProductE)_"^"_$g(ComLic)_"^"_$g(ComLicDate)_"^"_Active
				}else{
					Msg.info("error", "查询失败!" +newRowid);
				}
			},
			scope: this
		});
	}
}

var addPhManf = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){

		//窗口显示
		CreateEditWin("");
	}
});
		
var editPhManf = new Ext.Toolbar.Button({
	text:'编辑',
    tooltip:'编辑',
    id:'EditManfBt',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var rowObj = PhManfGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","请选择数据!");
			return false;
		}else{
					
			CreateEditWin(rowObj[0].get("RowId"));
		}
    }
});
var viewHisManf = new Ext.Toolbar.Button({
	text:'查看历史信息',
    tooltip:'查看历史信息',
    id:'viewHisManf',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var rowObj = PhManfGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","请选择数据!");
			return false;
		}else{
					
			ManfHisSearch(rowObj[0].get("RowId"));
		}
    }
});

var HospWinButton = GenHospWinButton("PH_Manufacturer");

//绑定点击事件
HospWinButton.on("click" , function(){
	var rowObj = PhManfGrid.getSelectionModel().getSelections(); 
	if (rowObj.length===0){
		Msg.info("warning","请选择数据!");
		return;	
	}
	var rowID=rowObj[0].get("RowId")||'';
	if (rowID===''){
		Msg.info("warning","请先保存数据!");
		return;	
	}
    GenHospWin("PH_Manufacturer",rowID,function(){PhManfGridDs.reload();}).show()   
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	//autoScroll : true,
	autoHeight:true,
    tbar:[findPhManf,'-',addPhManf,'-',editPhManf,'-',SaveAsBT,'-',viewHisManf,'-',HospWinButton],
	items : [{
		xtype : 'fieldset',
		title : '查询条件',
		defaults: {border:false},
		style:DHCSTFormStyle.FrmPaddingV,
		layout : 'column',
		items : [{
			columnWidth : .33,
			xtype : 'fieldset',
			items : [conditionCodeField]
		}, {
			columnWidth : .33,
			xtype : 'fieldset',
			items : [conditionNameField]
		}]
	}]
});

//分页工具栏
var PhManfPagingToolbar = new Ext.PagingToolbar({
    store:PhManfGridDs,
	pageSize:35,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='RowId';
		B[A.dir]='desc';
		B['conditionCode']=Ext.getCmp('conditionCodeField').getValue();
		B['conditionName']=Ext.getCmp('conditionNameField').getValue();
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
PhManfGrid = new Ext.grid.EditorGridPanel({
	store:PhManfGridDs,
	title:'厂商明细',
	cm:PhManfGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask:true,
	bbar:PhManfPagingToolbar,
	listeners:{
		'rowdblclick':function(){
			Ext.getCmp('EditManfBt').handler();
			
		}
	
	}
});

PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});

var HospPanel = InitHospCombo('PH_Manufacturer',function(combo, record, index){
	HospId = this.value; 
	PhManfGridDs.reload();
});

//=========================库存项厂商类别=============================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'厂商维护',
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(1),
		layout:'fit',
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[
			{
				region:'north',
				height:'500px',
				items:[HospPanel,panel]
			},PhManfGrid
		],
		renderTo:'mainPanel'
	});
});
//===========模块主页面===============================================