/**
*��ʿִ�е�������-- ��ť���塢�ж���� �������Ͷ���
*DHCNurItemDefine.js
*lvxin
*2014-09-02
*/

/**
*Note:��ť����
*�ù����������� cloumnModel ��˳����뱣�ֺ� ��̨save������Ӧ
*buttonDefine �ࣺNur.NurseExcuteButtons.cls
*����:save()
*ɾ��:delete()
*/
function buttonDefine()
{
	var cloumnModel = new Ext.grid.ColumnModel([
	    {header: "ID",width:20,dataIndex:"buttonID"},
	    {header: "��ť����",width:90,dataIndex:"buttonDesc",editor:new Ext.form.Field()},
    	{header: "��ť����",width:60,dataIndex:"buttonName",editor:new Ext.form.Field()},
		{header: "����",width:60,dataIndex:"buttonCode",editor:new Ext.form.Field()},
    	{header: "JS����",width:100,dataIndex:"jsFunction",editor:new Ext.form.Field()},
		{header: "ͼƬ����",width:100,dataIndex:"iconName",editor:new Ext.form.Field()},
		{header: "����",width:50,dataIndex:"ifShowWindow",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
		})},
    	{header: "��ǩ",width:50,dataIndex:"ifSign",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"],
			listeners:{
				'change':function(feild,newValue,oldValue ){
					var grid = Ext.getCmp('buttonDefine');
					var selections = grid.getSelectionModel().getSelections();
					var store = grid.getStore();
					var selectData = selections[0];
					var dataIndex = store.indexOf(selectData);
					var record = grid.getStore().getAt(dataIndex);   //Get the Record
					var ifDoubleSign = record.get("ifDoubleSign");
					if(newValue=='Y'&&ifDoubleSign=='Y'){
						record.set("ifDoubleSign","N");
						return;
					}
				}
			}
		})},  
    	{header: "˫ǩ",width:50,dataIndex:"ifDoubleSign",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"],
			listeners:{
				'change':function(feild,newValue,oldValue ){
					var grid = Ext.getCmp('buttonDefine');
					var selections = grid.getSelectionModel().getSelections();
					var store = grid.getStore();
					var selectData = selections[0];
					var dataIndex = store.indexOf(selectData);
					var record = grid.getStore().getAt(dataIndex);   //Get the Record
					var ifSign = record.get("ifSign");
					if(newValue=='Y'&&ifSign=='Y'){
						record.set("ifSign","N");
						return;
					}
				}
			}
		})},
    	{header: "��������",hidden:true,width:70,dataIndex:"operationType",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			valueField:"operationID",
			displayField :"operationTypeDesc",
			store:new Ext.data.JsonStore({
				url:"../csp/dhc.nurse.extjs.getdata.csp?className=Nur.NurseSheetSetCom&methodName=getOperationType",
				fields:["operationID","operationTypeDesc"],
				root:"rowData"
			})
		})},
		{header: "��ӡ���",width:60,dataIndex:"printFlag",editor:new Ext.form.Field()},
	]);
	
	var window =createEidtPanelWin({
		winID:"buttonDefineWin",
		gridID:"buttonDefine",
		cm:cloumnModel,
		fields:["buttonID","buttonDesc","buttonName","buttonCode","jsFunction","iconName","ifShowWindow","ifSign","ifDoubleSign","operationType","printFlag"],
		className:"Nur.NurseSheetSetCom",
		methodName:"getButtons",
		forceFit:true,
		MainClass:"Nur.NurseExcuteButtons",
		idField:"buttonID"
	});
	window.show();
}
/**
*Note:�������Ͷ���
*�ù����������� cloumnModel ��˳����뱣�ֺ� ��̨save������Ӧ
*operationDefine �ࣺNur.NurseOperationType.cls
*����:save()
*ɾ��:delete()
*/
function operationDefine()
{
	var cloumnModel = new Ext.grid.ColumnModel([
	    {header: "ID",width:20,dataIndex:"operationID"},
	    {header: "��������",width:60,dataIndex:"operationTypeCode",editor:new Ext.form.Field()},
    	{header: "������������",width:100,dataIndex:"operationTypeDesc",editor:new Ext.form.Field()}
	]);
	var window =createEidtPanelWin({
		winID:"operationDefineWin",
		gridID:"operationDefine",
		cm:cloumnModel,
		fields:["operationID","operationTypeCode","operationTypeDesc"],
		className:"Nur.NurseSheetSetCom",
		methodName:"getOperationType",
		forceFit:true,
		MainClass:"Nur.NurseOperationType",
		idField:"operationID"
	});
	window.show();
}
/**
*Note:�ж���
*�ù����������� cloumnModel ��˳����뱣�ֺ� ��̨save������Ӧ
*columnDefine �ࣺNur.NurseExcuteColumns.cls
*����:save()
*ɾ��:delete()
*/
function columnDefine()
{
	var cloumnModel = new Ext.grid.ColumnModel([
	    {header: "ID",width:20,dataIndex:"columnID"},
	    {header: "����",width:60,dataIndex:"varDesc",editor:new Ext.form.Field()},
    	{header: "����",width:60,dataIndex:"varCode",editor:new Ext.form.Field()},
		{header: "�п�",width:20,dataIndex:"columnWidth",editor:new Ext.form.Field()},
		{header: "�Ƿ���ʾ��ҽ��",width:50,dataIndex:"ifShowSubOrder",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
		})},  
		{header: "�󶨺���",width:200,dataIndex:"funCode",editor:new Ext.form.Field()}
	]);
	var window =createEidtPanelWin({
		winID:"columnDefineWin",
		gridID:"columnDefine",
		cm:cloumnModel,
		fields:["columnID","varDesc","varCode","columnWidth","ifShowSubOrder","funCode"],
		className:"Nur.NurseSheetSetCom",
		methodName:"getColumns",
		forceFit:true,
		MainClass:"Nur.NurseExcuteColumns",
		idField:"columnID"
	});
	window.show();
}


/**
*��������
*Note:�����༭����
*obj������
*/
function createEidtPanelWin(obj)
{
	if(Ext.getCmp(obj.winID))
	{
		Ext.getCmp(obj.winID).close();
	}
	var grid = new Ext.grid.EditorGridPanel({
		id:obj.gridID,
		layout:"fit",
		sm:new Ext.grid.RowSelectionModel({}),
		cm:obj.cm,
		viewConfig:{forceFit:obj.forceFit},
		store:new Ext.data.JsonStore({
			url:"../csp/dhc.nurse.extjs.getdata.csp?className="+obj.className+"&methodName="+obj.methodName,
			fields:obj.fields,
			root:"rowData",
			autoLoad:true
		})
	});
	var window = new Ext.Window({
		id:obj.winID,
		layout:"fit",
		items:[grid],
		width:800,
		height:400,
		buttons:[
			new Ext.Button({
				text:"����",
				icon:'../images/uiimages/edit_add.png',
				handler:function(){
					insertNewRecord(obj.fields,obj.gridID);
				}
			}),
			new Ext.Button({
				text:"����",
				icon:'../images/uiimages/filesave.png',
				handler:function(){
				saveDefines(obj.gridID,obj.MainClass)
				}
			}),
			new Ext.Button({
				text:"ɾ��",
				icon:'../images/uiimages/edit_remove.png',
				handler:function(){
				deleteSelected(obj.gridID,obj.MainClass,obj.idField)
				}
			}),
			new Ext.Button({
				text:"ȡ��",
				icon:'../images/uiimages/cancel.png',
				handler:function (){
					window.close();
				}
			})
		],
		listeners:{close:function(){
			Ext.getCmp("sheetButtons").getStore().removeAll();
			Ext.getCmp("sheetColumn").getStore().removeAll();
			Ext.getCmp("sheetButtons").getStore().load();
			Ext.getCmp("sheetColumn").getStore().load();
		}}
	})
	return window;
}


/**
*��������
*Note:���Ӽ�¼
*/
function insertNewRecord(fields,gridID)
{
	var store = Ext.getCmp(gridID).getStore();
	var recObj = "{"
	for(var i=0;i<fields.length;i++)
	{
		if(recObj!="{") recObj=recObj+","
		recObj=recObj+fields[i]+":''";
	}
	recObj=recObj+"}"
	recObj=eval("("+recObj+")");
	var newRecord = new Ext.data.Record(recObj);
	var count =store.getCount()
	store.insert(count,newRecord);
	Ext.getCmp(gridID).startEditing( count, 1 ) ;
}
/**
*��������
*Note:��������
*/
function saveDefines(gridID,saveClass)
{
	Ext.getCmp(gridID).stopEditing(false);
	var saveStr=""
	var store = Ext.getCmp(gridID).getStore(); 
	var count = store.getCount();
	for(var index = 0;index<count;index++)
	{
		var rowRecord = store.getAt(index);
		var modefiedFlag=false;
		var dataStr="";
		for(var key in rowRecord.data)
		{
			if(rowRecord.isModified(key)==true)
			{
				modefiedFlag=true;
			}
			var cellVal= rowRecord.get(key);
			dataStr=dataStr+String.fromCharCode(135)+cellVal;
		}		
		dataStr=dataStr.substring(1,dataStr.length)	
		if(modefiedFlag)
		{
			if(saveStr=="")
			{
				saveStr=dataStr;
			}
			else
			{
				saveStr=saveStr+String.fromCharCode(138)+dataStr
			}
		}
	}
	if(saveStr!="")
	{
		saveStr=saveStr.replace(/"/ig,String.fromCharCode(129));
		var ret = tkMakeServerCall("Nur.NurseSheetSetCom","saveDefines",saveClass,saveStr);
		Ext.MessageBox.alert("<��ʾ>",ret==""?"�������óɹ���":ret);
	}
	Ext.getCmp(gridID).getStore().load();
}
/**
*��������
*Note:ɾ��ѡ����
*/
function deleteSelected(gridID,deleteClass,idField)
{
	Ext.MessageBox.confirm("ɾ��ȷ��", "ȷ��ɾ��ѡ�����𣿣�" ,function (btId){
		if(btId=="yes")
		{
			var grid = Ext.getCmp(gridID);
			var SelectionModel  = grid.getSelectionModel();
			var rowArray = SelectionModel.getSelections();
			var IDStr="";
			for(var i =0;i<rowArray.length;i++)
			{
				var rowRecord = rowArray[i];
				var ID = rowRecord.get(idField);
				IDStr=IDStr==""?ID:IDStr+String.fromCharCode(135)+ID
			}
			if(IDStr!="")
			{
				var ret = tkMakeServerCall("Nur.NurseSheetSetCom","deleteDefines",deleteClass,IDStr)
				Ext.MessageBox.alert("<��ʾ>",ret==""?"�����ɹ���":ret);
			}
 			Ext.getCmp(gridID).getStore().load();
		}
	});	
}