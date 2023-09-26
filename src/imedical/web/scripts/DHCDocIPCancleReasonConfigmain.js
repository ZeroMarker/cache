//DHCDocIPCancleReasonConfigmain.js
var CONST_HOSPID="";
var USERID=session['LOGON.USERID'];
var GROUPID=session['LOGON.GROUPID'];
var LOCID=session['LOGON.CTLOCID'];
var HOSPID=session['LOGON.HOSPID'];
var hospParams=USERID+"^"+GROUPID+"^"+LOCID+"^"+HOSPID;
var hospComp=GenHospComp("Nur_IP_DHCDocIPCancleReason",hospParams);
hospComp.on('select',function(){
	CONST_HOSPID=hospComp.getValue();
	Find_onclick();
	CancleCode.reset();
	CancleDesc.reset();
	//console.log(record.data.ID);
});
hospComp.x=46;
hospComp.y=5;
var HospLabel = new Ext.form.Label({
	text:'ҽԺ',
	x:10,
	y:5
});

var CodeLabel = new Ext.form.Label({
	text:'����',
	x:10,
	y:30
});
var CancleCode = new Ext.form.TextField({  //���ϴ���
	id : 'CancleCode' ,
	x:46,
	y:30	,
	width : 200,
	//,anchor : '50%'
	fieldLabel : '����'
});

var Code=new Ext.Panel({
	id : 'Code'
	,buttonAlign:'center'
	,labelAligh:'center'
	,columnWidth : .5
	,layout:'form'
	,items:[CancleCode]
});

var DescLabel = new Ext.form.Label({
	text:'����',
	x:260,
	y:30
});
var CancleDesc = new Ext.form.TextField({  //��������
	id : 'CancleDesc',
	x:296,
	y:30,
	width : 200,
	//anchor : '50%'
	fieldLabel : '����'
});

var Desc=new Ext.Panel({
	id : 'Desc'
	,buttonAlign:'center'
	,labelAligh:'center'
	,columnWidth : .5
	,layout:'form'
	,items:[CancleDesc]
});

var FieldSet1 = new Ext.form.FieldSet({
		id : 'FieldSet1'
		,buttonAlign : 'center'
		,labelAlign : 'center'
		,height:47
		,layout : 'column'
		,border:true
		,frame:true
		,anchor:'100%'
		//,labelWidth:100 //label�Ŀ��,�����Խ����Ŵ�����������
		,items : [Code,
				Desc]
	});

var FindButton = new Ext.Button({
	id : 'FindButton',
	x:1050,
	y:30,
	width:100,
	height:26,
	fieldLabel : '',
	icon:'../images/uiimages/search.png',
	text : '��ѯ'
});

var Find=new Ext.Panel({
	id : 'Find'
	,buttonAlign:'center'
	,labelAligh:'center'
	,columnWidth : .25
	,layout:'form'
	,items:[FindButton]
});

var AddButton = new Ext.Button({
	id : 'AddButton',
	x:600,
	y:30,
	width:100,
	height:26,
	fieldLabel : '',
	text : '����',
	icon:'../images/uiimages/edit_add.png'
});

var Add=new Ext.Panel({
	id : 'Add'
	,buttonAlign:'center'
	,labelAligh:'center'
	,columnWidth : .25
	,layout:'form'
	,items:[AddButton]
});

var UpdateButton = new Ext.Button({
	id : 'UpdateButton',
	x:900,
	y:30,
	width:100,
	height:26,
	fieldLabel : '',//width : 60
	icon:'../images/uiimages/update.png',
	text : '����'
});

var Update=new Ext.Panel({
	id : 'Update'
	,buttonAlign:'center'
	,labelAligh:'center'
	,columnWidth : .25
	,layout:'form'
	,items:[UpdateButton]
});

var DeleteButton = new Ext.Button({
	id : 'DeleteButton',
	x:750,
	y:30,
	width:100,
	height:26,
	fieldLabel : ''
	,text : 'ɾ��',
	icon:'../images/uiimages/cancel.png'
});

var Delete=new Ext.Panel({
	id : 'Delete'
	,buttonAlign:'center'
	,labelAligh:'center'
	,columnWidth : .25
	,layout:'form'
	,items:[DeleteButton]
});
/*
var FieldSet2 = new Ext.form.FieldSet({
		id : 'FieldSet2'
		,buttonAlign : 'center'
		,labelAlign : 'center'
		,height:47
		,layout : 'column'
		,border:true
		,frame:true
		,anchor:'100%'
		//,labelWidth:100 //label�Ŀ��,�����Խ����Ŵ�����������
		,items : [FindButton,AddButton,UpdateButton,DeleteButton]
	});
*/
var CancleInfo = new Ext.form.FormPanel({
	id : 'CancleInfo',
	buttonAlign : 'center', //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ�� 
	labelAlign : 'right', //�������п��õ��ı�����ֵ���Ϸ�ֵ�� "left", "top" �� "right" (Ĭ��Ϊ "left").
	//labelWidth : 60,
	bodyBorder : false,
	border : true,
	layout : 'absolute',
	region : 'center',
	frame : true,
	//width : 100,
	height : 90,
	//anchor:'80%',
	//title : winTitle,
	items : [HospLabel,hospComp,CodeLabel,CancleCode,DescLabel,CancleDesc,AddButton,DeleteButton,UpdateButton,FindButton]
});
	
var CancleReasonStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:''}), //AppPatientStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowID', mapping : 'RowID'}
			,{name: 'RowCode', mapping : 'RowCode'}
			,{name: 'RowDesc', mapping: 'RowDesc'}
		])
	});
	
var CancleReasonCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 100 });
	
var CancleReason = new Ext.grid.GridPanel({
		id : 'CancleReason'
		,store : CancleReasonStore
		,region : 'center'
		,layout: 'fit'
		,autoHeight:true
		,buttonAlign : 'center'
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}  
		,columns: [
			new Ext.grid.RowNumberer({header:"���"	,width:60})
			,{header: 'RowID', width: 200, dataIndex: 'RowID', sortable: true,hidden:true}
			,{header: '����', width: 200, dataIndex: 'RowCode', sortable: true}
			,{header: '����', width: 200, dataIndex: 'RowDesc', sortable: true}		
		]
});

function Find_onclick(){
	
	var Code = Ext.getCmp('CancleCode').getValue();
	var Desc = Ext.getCmp('CancleDesc').getValue();
	
	Ext.Ajax.request({
		url:'DHCDocIPAppointmentdata.csp',
		params:{action:'FindCancleReason',Code:Code, Desc:Desc,HospID:CONST_HOSPID} ,
		success: function(result, request) {
			CancleReasonStore.removeAll();
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.CancleReasonList!='') {
				//alert(jsonData.CancleReasonList)
				
				var CancleReasonListArr=jsonData.CancleReasonList.split("!");
				
				for (var i=0;i<CancleReasonListArr.length;i++) {
					//{name: 'checked', mapping : 'checked'}
					var RowId = CancleReasonListArr[i].split("^")[0];
					var RowCode = CancleReasonListArr[i].split("^")[1];
					var RowDesc = CancleReasonListArr[i].split("^")[2];
					
					var record = new Object();
		       		record.RowID = RowId ;
		       		record.RowCode = RowCode ;
		       		record.RowDesc = RowDesc ;
		       		var records = new Ext.data.Record(record);
		       		
					CancleReasonStore.add(records);
				}
			}
		},
		scope: this
	}) ;
	
}

function Add_onclick(){
	var Code = Ext.getCmp('CancleCode').getValue();
	var Desc = Ext.getCmp('CancleDesc').getValue();
	if(Code==""){
		alert("���벻��Ϊ�գ�");
		return;
	}
	if(Desc==""){
		alert("��������Ϊ�գ�");
		return;
	}
	Ext.Ajax.request({
		url:'DHCDocIPAppointmentdata.csp',
		params:{action:'AddCancleReason',Code:Code, Desc:Desc,HospID:CONST_HOSPID} ,
		success: function(result, request) {
			
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success!='') {
				//alert(jsonData.success)
				if (jsonData.success=="true"){
					alert("��ӳɹ�!");
					Ext.getCmp("CancleCode").setValue("");
					Ext.getCmp("CancleDesc").setValue("");
					Find_onclick();
				}else {
					alert("���ʧ��!�������:"+jsonData.info);
				}
			}
		},
		scope: this
	}) ;
}

function Update_onclick(){
	var selections=CancleReason.getSelectionModel().getSelections();
	//alert("selections=="+selections.length);
	if (selections.length == 0) {
		alert("����ѡ����¼�¼!");
		return ;
	}
	var Code = Ext.getCmp('CancleCode').getValue();
	var Desc = Ext.getCmp('CancleDesc').getValue();
	for (var i = 0; i < selections.length; i++) { 
		var record = selections[i]; 
		var RowId=record.get("RowID");
		
		Ext.Ajax.request({
			url:'DHCDocIPAppointmentdata.csp',
			params:{action:'UpdateCancleReason',RowId:RowId,Code:Code, Desc:Desc} ,
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success!='') {
					//alert(jsonData.success)
					if (jsonData.success=="true"){
						alert("���³ɹ�!");
						Ext.getCmp("CancleCode").setValue("");
						Ext.getCmp("CancleDesc").setValue("");
						Find_onclick();
					}else {
						alert("����ʧ��!�������:"+jsonData.info);
					}
				}
			},
			scope: this
		}) ;
		
	}
}

function Delete_onclick() {

	var selections = CancleReason.getSelectionModel().getSelections();
	//alert("selections=="+selections.length);
	if (selections.length == 0) {
		alert("����ѡ��ɾ����¼!");
		return;
	}
	Ext.MessageBox.confirm("ɾ��", "ȷ��ɾ��?", function (btn) {
		if (btn == 'yes') {
			for (var i = 0; i < selections.length; i++) {
				var record = selections[i];
				var RowId = record.get("RowID");
				Ext.Ajax.request({
					url: 'DHCDocIPAppointmentdata.csp',
					params: {
						action: 'DeleteCancleReason',
						RowId: RowId
					},
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success != '') {
							//alert(jsonData.success)
							if (jsonData.success == "true") {
								alert("ɾ���ɹ�!");
								Ext.getCmp("CancleCode").setValue("");
								Ext.getCmp("CancleDesc").setValue("");
								Find_onclick();
							} else {
								alert("ɾ��ʧ��!�������:" + jsonData.info);
							}
						}
					},
					scope: this
				});

			}
		}
	});

}
Ext.onReady(function(){
	
	new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		//,layout : 'fit'
		,enableTabScroll:true
		,collapsible:true
		,layout:"border"
		,items:[
			{region:"north",height:90,items:[CancleInfo]},
			{region:"center",width:300,split:true,border:true,collapsible:true,autoScroll:true,items:[CancleReason]}
		]
	});
	
	Ext.get('FindButton').on("click", Find_onclick);
	
	Ext.get('AddButton').on("click", Add_onclick);
	
	Ext.get('DeleteButton').on("click", Delete_onclick);
	
	Ext.get('UpdateButton').on("click", Update_onclick);
	
	CancleReason.on("rowclick",function(grid, rowIndex, e){
		
		var selections=CancleReason.getSelectionModel().getSelections();
		if (selections.length == 0) {
			//alert("����ѡ���˼�¼!");
			return ;
		}
		
		for (var i = 0; i < selections.length; i++) { 
			var record = selections[i]; 
			var CancleCode=record.get("RowCode");
			var CancleDesc=record.get("RowDesc");
			Ext.getCmp("CancleCode").setValue(CancleCode);
			Ext.getCmp("CancleDesc").setValue(CancleDesc);
		}
	});
	
	Find_onclick();
	
});
