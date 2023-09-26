// ����:����רҵ��
// ��д����:2012-05-8
//=========================����ȫ�ֱ���===============================
var SubLocUserGroupId = "";
//=========================����ȫ�ֱ���===============================
//=========================רҵ��=====================================
var logonLoc=session['LOGON.CTLOCID'];  //��¼����
var gGroupId = session['LOGON.GROUPID'];
var SubLocUserGridUrl = 'dhcstm.sublocusergroupaction.csp';

var PhaLoc = new Ext.ux.ComboBox({
	id:'PhaLoc',
	fieldLabel:'����',
	emptyText:'����...',
	listWidth:200,
	store : LeadLocStore,
	valueParams : {groupId : gGroupId},
	filterName : 'locDesc',
	listeners : {
		select : function(index, scrollIntoView){
			SubLocUserGroupGridDs.load({params:{SubLoc:this.getValue()}});
		},
		change : function(combo, newValue, oldValue){
			if(newValue==""){
				SubLocUserGroupGridDs.removeAll();
				SubLocUserGridDs.removeAll();
				SubLocUserGroupId='';
			}
		}
	}
});

function addNewRow() {
	var col=GetColIndex(SubLocUserGroupGrid,"Code");
	var rowCount = SubLocUserGroupGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = SubLocUserGroupGridDs.data.items[rowCount - 1];
		var data = rowData.get("RowId");
		if (data == null || data.length <= 0) {
			SubLocUserGroupGrid.startEditing(rowCount-1, col);
			return;
		}
	}
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		},{
			name:'DateFrom',
			type:'date'
		},{
			name:'DateTo',
			type:'date'
		},{
			name:'subloc',
			type:'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		DateFrom:'',
		DateTo:'',
		subloc:''
	});
					
	SubLocUserGroupGridDs.add(NewRecord);
	SubLocUserGroupGrid.startEditing(SubLocUserGroupGridDs.getCount() - 1, col);
}

//��������Դ
var SubLocUserGroupGridUrl = 'dhcstm.sublocusergroupaction.csp';
var SubLocUserGroupGridProxy= new Ext.data.HttpProxy({url:SubLocUserGroupGridUrl+'?actiontype=getLocGroupList',method:'GET'});
var SubLocUserGroupGridDs = new Ext.data.Store({
	proxy:SubLocUserGroupGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'Code',mapping:'grpCode'},
		{name:'Desc',mapping:'grpDesc'},
		{name:'DateFrom',mapping:'df',type:'date',dateFormat:DateFormat},
		{name:'DateTo',mapping:'dt',type:'date',dateFormat:DateFormat},
		{name:'subloc'}
	]),
	remoteSort:false,
	pruneModifiedRecords:true,
	listeners :��{
		beforeload : function(store, options){
			SubLocUserGridDs.removeAll();
		}
	}
});

//ģ��
var SubLocUserGroupGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
	 	header:'RowId',
	 	dataIndex:'RowId',
	 	hidden:true
	 },{
        header:"רҵ�����",
        dataIndex:'Code',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row=SubLocUserGroupGrid.getSelectionModel().getSelectedCell()[0];
						var col=GetColIndex(SubLocUserGroupGrid,"Desc");
						SubLocUserGroupGrid.startEditing(row, col);
					}
				}
			}
        })
    },{
        header:"רҵ������",
        dataIndex:'Desc',
        width:200,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
        })
    },{
	    header:'��Ч��ʼ����',
	    dataIndex:'DateFrom',
	    //xtype:'datecolumn',
	    renderer : Ext.util.Format.dateRenderer(DateFormat),
	    editor: new Ext.ux.DateField({
	    	selectOnFocus : true
	    }),
	    width:100
    },{
	    header:'��Ч��ֹ����',
	    dataIndex:'DateTo',
	    //
	    renderer : Ext.util.Format.dateRenderer(DateFormat),
	    //xtype:'datecolumn',
	    editor: new Ext.ux.DateField({}),
	    width:100
	},{
	    header:'subloc',
	    dataIndex:'subloc',
	    hidden:true
    }
]);

var addSubLocUserGroup = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		var PhaLoc = Ext.getCmp('PhaLoc').getValue();
		if(PhaLoc==''){
			Msg.info('warning','��ѡ����Ҫά��רҵ��Ŀ���!');
			return;
		}
		addNewRow();
	}
});

var saveSubLocUserGroup = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(SubLocUserGroupGrid.activeEditor != null){
			SubLocUserGroupGrid.activeEditor.completeEdit();
		}
		//��ȡ���е��¼�¼ 
		var mr=SubLocUserGroupGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
			var df=mr[i].data["DateFrom"];
			var dt=mr[i].data["DateTo"];
			if((df!=null)&&(df!='')&&(dt!=null)&&(dt!='')){
				if(df>dt){
					var rowIndex=SubLocUserGroupGridDs.indexOf(mr[i]);
					Msg.info("warning","��"+(rowIndex+1)+"�п�ʼ���ڲ��ܴ��ڽ�ֹ����!");
					return;
				}
			}
			if ((df!=null)&&(df!='')){
				df=df.format(ARG_DATEFORMAT);
			}else{
				df="";
			}
			
			if ((dt!=null)&&(dt!='')){
				dt=dt.format(ARG_DATEFORMAT);
			}else{
				dt="";
			}
			
			var subloc=Ext.getCmp('PhaLoc').getValue();
			if(subloc==""){
				Msg.info("warning",'���Ҳ���Ϊ��!');
				return false;
			}
			if(code!="" && desc!=""){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+df+"^"+dt+"^"+subloc;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		
		if(data==""){
			Msg.info("warning","û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: SubLocUserGroupGridUrl+'?actiontype=saveGroup',
				params: {data:data},
				failure: function(result, request) {
					mask.hide();
					Msg.info("error","������������!");
					SubLocUserGroupGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						SubLocUserGroupGridDs.reload();
					}else{
						Msg.info("error","����ʧ��!"+jsonData.info);
						SubLocUserGroupGridDs.reload();
					}
					SubLocUserGroupGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});

var deleteSubLocUserGroup = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = SubLocUserGroupGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ������!");
			return false;
		}else{
			var rowIndex=cell[0];  //��ǰ�к�
			var record = SubLocUserGroupGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:SubLocUserGroupGridUrl+'?actiontype=deleteGroup',
								waitMsg:'ɾ����...',
								params:{RowId:RowId},
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","ɾ���ɹ�!");
										SubLocUserGrid.store.removeAll();
										SubLocUserGrid.getView().refresh();
										SubLocUserGroupGridDs.reload();
									}else{
										Msg.info("error","ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				SubLocUserGroupGridDs.remove(record);
				SubLocUserGroupGrid.getView().refresh();
			}
		}
    }
});

//���
var SubLocUserGroupGrid = new Ext.ux.EditorGridPanel({
	id : 'SubLocUserGroupGrid',
	store:SubLocUserGroupGridDs,
	cm:SubLocUserGroupGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:['����:',PhaLoc,'-',addSubLocUserGroup,'-',saveSubLocUserGroup],		//����ɾ����ť ,'-',deleteSubLocUserGroup
	listeners:{
		'rowclick':function(grid,rowIndex,e){
			//����רҵ��ˢ��רҵ����Ա��¼
			var selectedRow = SubLocUserGroupGridDs.data.items[rowIndex];
			SubLocUserGroupId = selectedRow.data["RowId"];
			SubLocUserGridDs.proxy = new Ext.data.HttpProxy({url:SubLocUserGridUrl+'?actiontype=getGroupUser',method:'GET'});
			SubLocUserGridDs.load({params:{SubLocUserGroupId:SubLocUserGroupId}});
		},
		'afteredit':function(e){
			if(e.field=="Code" || e.field=="Desc"){
				var findIndex=SubLocUserGroupGridDs.findExact(e.field,e.value,0);
				if(findIndex>=0 && findIndex!=e.row){
					Msg.info("warning","����,���Ʋ����ظ�!");
					e.record.set(e.field,e.originalValue);
				}
			}
		}
	}
});

//=========================רҵ��=====================================

function addNewSCRow() {
	var col=GetColIndex(SubLocUserGrid,"user");
	var rowCount = SubLocUserGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = SubLocUserGridDs.data.items[rowCount - 1];
		var data = rowData.get("user");
		if (data == null || data.length <= 0) {
			SubLocUserGrid.startEditing(rowCount-1, col);
			return;
		}
	}
	var scRecord = Ext.data.Record.create([
		{
			name : 'rowid',
			type : 'string'
		},{
			name : 'user',
			type : 'int'
		},{
			name : 'userName',
			type : 'string'
		},{
			name : 'DateFromX',
			type : 'date'
		},{
			name : 'DateToX',
			type : 'date'
		},{
			name : 'ReqFlag',
			type : 'string'
		}
	]);
					
	var NewSCRecord = new scRecord({
		rowid:'',
		user:'',
		userName:'',
		DateFromX:'',
		DateToX:'',
		ReqFlag:'Y'
	});
		
	SubLocUserGridDs.add(NewSCRecord);
	var col=GetColIndex(SubLocUserGrid,'user');
	SubLocUserGrid.startEditing(SubLocUserGridDs.getCount() - 1, col);
}

var UCG = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'UCG',
	anchor : '90%',
	store : UStore,
	params : {locId:'PhaLoc'},
	filterName : 'name',
	listeners:{
		select:function(combo,record,index){
			var findIndex=SubLocUserGridDs.findExact('user',record.get('RowId'),0);
			var cell=SubLocUserGrid.getSelectionModel().getSelectedCell();
			if(findIndex>=0 && findIndex!=cell[0]){
				combo.setValue("");
				Msg.info("warning","����Ա�Ѵ���!");
				return false;
			}
		}
	}
});

//��������Դ
var SubLocUserGridProxy= new Ext.data.HttpProxy({url:SubLocUserGridUrl,method:'GET'});
var SubLocUserGridDs = new Ext.data.Store({
	proxy:SubLocUserGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows',
		id:'rowid'
	}, [
		{name:'rowid'},
		{name:'user',mapping:'userRowId'},
		{name:'userName'},
		{name:'DateFromX',mapping:'dateFrom',type:'date',dateFormat:DateFormat},
		{name:'DateToX',mapping:'dateTo',type:'date',dateFormat:DateFormat},
		{name:"ReqFlag"}
	]),
	pruneModifiedRecords:true
});

var ReqFlag = new Ext.grid.CheckColumn({
	header:'רҵ������Ȩ��',
	dataIndex:'ReqFlag',
	width:100,
	sortable:true
});

//ģ��
var SubLocUserGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:'rowid',
		dataIndex:'rowid',
		hidden:true
	},{
		header:"������Ա",
		dataIndex:'user',
		width:300,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer2(UCG,"user","userName"),
		editor:new Ext.grid.GridEditor(UCG)
	},{
		header:'��Ч��ʼ����',
		dataIndex:'DateFromX',
		//xtype:'datecolumn',
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField({
			selectOnFocus : true
		}),
		width:100 
	},{
		header:'��Ч��ֹ����',
		dataIndex:'DateToX',
		//
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		//xtype:'datecolumn',
		editor: new Ext.ux.DateField({}),
		width:100
	}, ReqFlag
]);

//���
SubLocUserGrid = new Ext.ux.EditorGridPanel({
	id : 'SubLocUserGrid',
	store:SubLocUserGridDs,
	cm:SubLocUserGridCm,
	trackMouseOver:true,
	clicksToEdit:1,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	plugins:ReqFlag,
	listeners:{
		beforeedit:function(e){
			if(e.field=="user" && e.record.get('rowid')!=""){
				e.cancel=true;
			}
		}
	}
});
//=========================רҵ����Ա===================================

var addSubLocUser = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(SubLocUserGroupGridDs.getCount()>0 && SubLocUserGroupId!=""){
			addNewSCRow();
		}else{
			Msg.info("warning","��ѡ��רҵ��!");
			return false;
		}
	}
});

var saveSubLocUser = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(SubLocUserGrid.activeEditor != null){
			SubLocUserGrid.activeEditor.completeEdit();
		}
		//��ȡ���е��¼�¼ 
		var mr=SubLocUserGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			if(mr[i].data["user"].trim()!=""){
				var dateFrom=mr[i].data["DateFromX"];
				var dateTo=mr[i].data["DateToX"];
				if((dateFrom!=null)&&(dateFrom!="")&&(dateTo!=null)&&(dateTo!="")){
					if(dateFrom>dateTo){
						var rowIndex=SubLocUserGridDs.indexOf(mr[i])
						Msg.info("warning","��"+(rowIndex+1)+"�п�ʼ���ڲ��ܴ��ڽ�ֹ����!");
						return;
					}
				}
				if ((dateFrom!=null)&&(dateFrom!='')){
					dateFrom=dateFrom.format(ARG_DATEFORMAT);
				}else{
					dateFrom="";
				}
				if ((dateTo!=null)&&(dateTo!='')){
					dateTo=dateTo.format(ARG_DATEFORMAT);
				}else{
					dateTo="";
				}
				var ReqFlag = mr[i].data["ReqFlag"];
				var dataRow = SubLocUserGroupId+"^"+mr[i].data["rowid"]+"^"+mr[i].data["user"]
					+"^"+dateFrom+"^"+dateTo+"^"+ReqFlag;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}

		if(data==""){
			Msg.info("error","û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: SubLocUserGridUrl+'?actiontype=saveGroupUser',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","������������!");
					SubLocUserGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success","��ӳɹ�!");
						SubLocUserGridDs.reload();
					}else{
						Msg.info("error",jsonData.info+" ���ʧ��!");
						
					}
					SubLocUserGridDs.commitChanges();
					SubLocUserGridDs.reload();
				},
				scope: this
			});
		}
	}
});

var deleteSubLocUser = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = SubLocUserGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ������!");
			return false;
		}else{
			var rowIndex=cell[0];
			var record = SubLocUserGrid.getStore().getAt(cell[0]);
			var RowId = record.get("rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:SubLocUserGridUrl+'?actiontype=deleteGroupUser',
								params:{rowid:RowId},
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","ɾ���ɹ�!");
										SubLocUserGridDs.reload();
										
									}else{
										Msg.info("error","ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				SubLocUserGridDs.remove(record);
				SubLocUserGrid.getView().refresh();
			}
		}
	}
});

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var SubLocUserGroupPanel = new Ext.Panel({
		title:'����רҵ��ά��',
		activeTab: 0,
		region:'west',
		width:600,
		collapsible: true,
		split: true,
		minSize: 0,
		maxSize: 600,
		layout:'fit',
		items:[SubLocUserGroupGrid]                                 
	});
	
	var SubLocUserPanel = new Ext.Panel({
		title:'רҵ����Ա',
		region:'center',
		tbar:[addSubLocUser,'-',saveSubLocUser,'-',deleteSubLocUser],
		layout:'fit',
		items:[SubLocUserGrid]                                 
	});

	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[SubLocUserGroupPanel,SubLocUserPanel],
		renderTo: 'mainPanel'
	});
	
	SetLogInDept(PhaLoc.getStore(),'PhaLoc');
	//����ȱʡ���ҵ�רҵ��	ps:2018-04-08 ��SetLogInDept�����Ӵ����¼�,���ﲻ���ظ�
	//SubLocUserGroupGridDs.load({params:{SubLoc:Ext.getCmp('PhaLoc').getValue()}});
});
//===========ģ����ҳ��===============================================