///session['LOGON.HOSPID'];  dddddd
document.write("<script language='javascript' src='../scripts/DHC.WMR.PinYinHead.js'></script>");
var CONST_HOSPID="";
var USERID=session['LOGON.USERID'];
var GROUPID=session['LOGON.GROUPID'];
var LOCID=session['LOGON.CTLOCID'];
var HOSPID=session['LOGON.HOSPID'];
var hospParams=USERID+"^"+GROUPID+"^"+LOCID+"^"+HOSPID;
var hospComp=GenHospComp("Nur_IP_DHCDocConfig",hospParams);
hospComp.on('select',function(){
	CONST_HOSPID=hospComp.getValue();
	CTLocComboStore.reload();
	CTLocCombo.clearValue();
	CTLocStore.load({});
	//Find_onclick();
	//console.log(record.data.ID);
});
var HospLabel = new Ext.form.Label({
		text:'ҽԺ'
	});
	
var HosptialId=session['LOGON.HOSPID'];
var SaveButton = new Ext.Button({
	id : 'SaveButton'
	,fieldLabel : ''
	,width : 100,
	height:26
	//,iconCls : 'icon-find'
	,text : '����',
	icon:'../images/uiimages/filesave.png'
	//,margins : {top:0, right:0, bottom:0, left:100}
});

var SaveCondition=new Ext.Panel({
		id : 'SaveCondition'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth : 70
		,layout:'form'
		,items:[SaveButton]  
	});

var DeleteButton = new Ext.Button({
	id : 'DeleteButton'
	,fieldLabel : ''
	,width : 100,
	height:26
	//,iconCls : 'icon-find'
	,text : 'ɾ��',
	icon:'../images/uiimages/edit_remove.png'
	//,margins : {top:0, right:0, bottom:0, left:100}
});

var DeleteCondition=new Ext.Panel({
		id : 'DeleteCondition'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth : 70
		,layout:'form'
		,items:[DeleteButton]  
	});

var CTLocComboStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	var CTLocComboStore = new Ext.data.Store({
		proxy: CTLocComboStoreProxy,
		autoLoad : true, 
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	
	var CodeLabel = new Ext.form.Label({
		text:'����'
	});
	var CTLocCombo = new Ext.form.ComboBox({
		id : 'CTLocCombo'
		,width : 300
		,store : CTLocComboStore
		,hiddenName:'CTLocID'
		,minChars : 1
		,displayField : 'CTLocDesc'
		//,
		//fieldLabel : '����'
		,editable : true
		,triggerAction : 'all'
		//,mode : 'remote' //Ϊ��ҳ��׼��
		//,pageSize : 5 //ÿҳ��ʾ�ļ�¼����
		//,minListWidth : 220 //��ҳ������С��ȣ�������ܲ�����ʾ�����ķ�ҳ��
		,anchor : '90%'
		,valueField : 'CTLocID',
		listeners: {
			focus: {
				fn: function (e) {
					e.expand();
					this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
					combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.get('CTLocDesc'));
						return regExp.test(text) | regExp.test(record.data[me.displayField]); 
					});
					combo.expand();
					combo.select(0, true);
					return false;
				}
			}
		}
});

CTLocComboStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'Nur.InService.DHCDocIPAppointment';
	param.QueryName = 'QryCTLoc';
	param.Arg1 = CTLocCombo.getRawValue();;
	param.Arg2 = 'E';
	param.Arg3 = "";
	param.Arg4 = CONST_HOSPID;
	param.ArgCnt = 4;
	
});

var CTLocComboCondition=new Ext.Panel({
		id : 'CTLocComboCondition'
		,buttonAlign : 'center'
		,columnWidth : .50
		,labelWidth : 70
		,layout:'column'
		,items:[HospLabel,hospComp,CodeLabel,CTLocCombo]  
	});

var Save = new Ext.form.FormPanel({
		id : 'Save',
		buttonAlign : 'center',
		labelAlign : 'center', 
		labelWidth : 100,
		bodyBorder : 'padding:0 0 0 0',
		layout : 'column',
		region : 'north',
		frame : true,
		height : 80,
		//,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		//,columnWidth : .60 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		//,layout : 'form' //���ַ�ʽ
		items : [CTLocComboCondition, SaveCondition,DeleteCondition]
	});

var CTLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url : ExtToolSetting.RunQueryPageURL
}));

var CTLocStore = new Ext.data.Store({
		proxy: CTLocStoreProxy,
		autoLoad:true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	
var CTLocCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 100 });

var CTLoc = new Ext.grid.GridPanel({
		id : 'CTLoc'
		,store : CTLocStore
		,region : 'center'
		,layout: 'fit'
		,autoHeight:true
		,buttonAlign : 'center'
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}  
		,columns: [
			new Ext.grid.RowNumberer({header:"���"	,width:60})
			,{header: 'CTLocID', width: 100, dataIndex: 'CTLocID', sortable: true,hidden:true}
			,{header: '���Ҵ���', width: 200, dataIndex: 'CTLocCode', sortable: true}
			,{header: '��������', width: 200, dataIndex: 'CTLocDesc', sortable: true}		
		]
		//,selModel:Ext.create('Ext.selection.CheckboxModel',{mode:"SIMPLE"})
	});

CTLocStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'Nur.InService.DHCDocIPAppointment';
	param.QueryName = 'QryCTLoc';
	param.Arg1 = "";
	param.Arg2 = 'E';
	param.Arg3 = "";
	param.Arg4 = CONST_HOSPID;
	param.Arg5 = '1';
	param.ArgCnt = 5;
	
});
/*
CTLocStore.on('load', function(){
	
	var ConfigStr="";
	Ext.Ajax.request({
		url:'DHCDocIPAppointmentdata.csp',
		params:{action:'GetConfig'} ,
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			//alert(jsonData.Config);
			if (jsonData.Config!='') {
				//alert(jsonData.success)
				ConfigStr="^"+jsonData.Config+"^";
				
				var count = CTLocStore.data.length;
				var LocModel = CTLoc.getSelectionModel(); 
				//alert("ConfigStr=="+ConfigStr);
				var rows=""
				for (var i = 0; i < count; i++){
					var data = CTLocStore.getAt(i).data;
					var LocId = "^"+data.CTLocID+"^";
					if (ConfigStr.indexOf(LocId)>=0) {
						if (rows=="") {rows=rows+i;}
						else {rows=rows+","+i;}
						//LocModel.selectRows(i);
					}
				}
				var rowsArr=rows.split(",");
				LocModel.selectRows(rowsArr);
			}
		},
		scope: this
	}) ;
	
});
*/
/*
var pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'border'
		,items:[
			Save,
			CTLoc
		]
	});
*/

function Save_onclick(){
	
	//alert(CTLocCombo.getValue());
	var ConfigStr=CTLocCombo.getValue();
	if(ConfigStr==""){
		alert("��ѡ�����");
		return;
	}
	Ext.Ajax.request({
		url:'DHCDocIPAppointmentdata.csp',
		params:{action:'SetConfig',ConfigStr:ConfigStr} ,
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success!='') {
				//alert(jsonData.success)
				if (jsonData.success=="true"){
					alert("����ɹ�!");
					CTLocStore.load({});
				}else {
					alert("����ʧ��:"+jsonData.info);
				}
			}
		},
		scope: this
	}) ;
}

function Delete_onclick() {
	
	var selections=CTLoc.getSelectionModel().getSelections();
	//alert("selections=="+selections.length);
	
	if (selections.length == 0) {
		alert("����ѡ���¼!");
		return ;
	}
	Ext.MessageBox.confirm("ɾ��", "ȷ��ɾ��?", function (btn) {
		if (btn == 'yes') {
			var IdStr = ""
				for (var i = 0; i < selections.length; i++) {
					var record = selections[i];
					if (IdStr == "") {
						IdStr = record.get("CTLocID");
					} else {
						IdStr = IdStr + "^" + record.get("CTLocID");
					}
				}
				//alert("IdStr=="+IdStr);
				Ext.Ajax.request({
					url: 'DHCDocIPAppointmentdata.csp',
					params: {
						action: 'DeleteConfig',
						DeleteStr: IdStr
					},
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success != '') {
							//alert(jsonData.success)
							if (jsonData.success == "true") {
								alert("ɾ���ɹ�!");
								CTLocStore.load({});
							} else {
								alert("ɾ��ʧ��!");
							}
						}
					},
					scope: this
				});
		}
	});
}

Ext.onReady(function(){
	
	new Ext.Viewport({
		id : 'viewScreen'
		,enableTabScroll:true
		,collapsible:true
		,layout:"border"
		,items:[
			{region:"north",height:60,items:[Save]},
			{region:"center",split:true,border:true,collapsible:true,autoScroll:true,title:"�����б�",items:[CTLoc]}
		]
	});
	
	Ext.get('SaveButton').on("click", Save_onclick);
	Ext.get('DeleteButton').on("click", Delete_onclick);
})