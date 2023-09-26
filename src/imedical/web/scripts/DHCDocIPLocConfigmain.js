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
		text:'医院'
	});
	
var HosptialId=session['LOGON.HOSPID'];
var SaveButton = new Ext.Button({
	id : 'SaveButton'
	,fieldLabel : ''
	,width : 100,
	height:26
	//,iconCls : 'icon-find'
	,text : '保存',
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
	,text : '删除',
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
		text:'科室'
	});
	var CTLocCombo = new Ext.form.ComboBox({
		id : 'CTLocCombo'
		,width : 300
		,store : CTLocComboStore
		,hiddenName:'CTLocID'
		,minChars : 1
		,displayField : 'CTLocDesc'
		//,
		//fieldLabel : '科室'
		,editable : true
		,triggerAction : 'all'
		//,mode : 'remote' //为分页做准备
		//,pageSize : 5 //每页显示的记录条数
		//,minListWidth : 220 //分页栏的最小宽度，否则可能不能显示完整的分页栏
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
		//,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		//,columnWidth : .60 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		//,layout : 'form' //布局方式
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
		,loadMask : { msg : '正在读取数据,请稍后...'}  
		,columns: [
			new Ext.grid.RowNumberer({header:"序号"	,width:60})
			,{header: 'CTLocID', width: 100, dataIndex: 'CTLocID', sortable: true,hidden:true}
			,{header: '科室代码', width: 200, dataIndex: 'CTLocCode', sortable: true}
			,{header: '科室名称', width: 200, dataIndex: 'CTLocDesc', sortable: true}		
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
		alert("请选择科室");
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
					alert("保存成功!");
					CTLocStore.load({});
				}else {
					alert("保存失败:"+jsonData.info);
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
		alert("请先选择记录!");
		return ;
	}
	Ext.MessageBox.confirm("删除", "确认删除?", function (btn) {
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
								alert("删除成功!");
								CTLocStore.load({});
							} else {
								alert("删除失败!");
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
			{region:"center",split:true,border:true,collapsible:true,autoScroll:true,title:"科室列表",items:[CTLoc]}
		]
	});
	
	Ext.get('SaveButton').on("click", Save_onclick);
	Ext.get('DeleteButton').on("click", Delete_onclick);
})