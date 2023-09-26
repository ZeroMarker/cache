document.write("<script language='javascript' src='../scripts/DHC.WMR.PinYinHead.js'></script>");

var CTHosStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	
var CTHosStore = new Ext.data.Store({
		proxy:CTHosStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Hoscode'
		},
		[
			{name: 'HosDesc', mapping : 'HosDesc'}
			,{name: 'HosCode', mapping: 'HosCode'}
		])
     });
var CTHosLabel = new Ext.form.Label({
		text:'院区'
	});
var CONST_HOSPID="";
var USERID=session['LOGON.USERID'];
var GROUPID=session['LOGON.GROUPID'];
var LOCID=session['LOGON.CTLOCID'];
var HOSPID=session['LOGON.HOSPID'];
var hospParams=USERID+"^"+GROUPID+"^"+LOCID+"^"+HOSPID;
var CTHos =GenHospComp("Nur_IP_DHCBedManager",hospParams);
CTHos.width=200;
CTHos.on('select',function (){
	btnQuery_onclick();	 	
	CONST_HOSPID = CTHos.getValue();
	cboWard.clearValue();
	cboWardStore.load({});
});

/*= new Ext.form.ComboBox({
		id : 'CTHos'
		,width :200
		,store : CTHosStore
		,minChars : 0
		,displayField : 'HosDesc'
		//,fieldLabel : '院区'
		,editable : true
		,triggerAction : 'all'
		,anchor : '80%'
		,valueField : 'HosCode'	
		
});	*/




var cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url : ExtToolSetting.RunQueryPageURL
}));

var cboWardStore = new Ext.data.Store({
	proxy: cboWardStoreProxy,
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
var cboWardLabel = new Ext.form.Label({
		text:'病区'
	});
var cboWard = new Ext.form.ComboBox({
		id: 'cboWard',
		width: 200,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		store: cboWardStore,
		displayField: 'CTLocDesc',
		editable: true,
		triggerAction: 'all',
		anchor: '100%',
		valueField: 'CTLocID',
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
var AppHospitalButton = new Ext.Button({
	id : 'AppHospitalButton'
	,fieldLabel : ''
	,width : 100,
	icon:'../images/uiimages/edit_add.png'
	,text : '添加院区'
	,margins : {top:0, right:0, bottom:0, left:100}
});
var btnQuery = new Ext.Button({
		id : 'btnQuery'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 100
		//,iconCls : 'icon-find'
		,icon:'../images/uiimages/search.png'
		,text : '查询'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
	
var AddWardButton = new Ext.Button({
	id : 'AddWardButton'
	,fieldLabel : ''
	,width : 100,
	//,iconCls : 'icon-find'
	icon:'../images/uiimages/edit_add.png'
	,text : '添加病区'
	,margins : {top:0, right:0, bottom:0, left:100}
});


var ConditionPanel = new Ext.form.FormPanel({
	id : 'ConditionPanel',
	buttonAlign : 'center',
	labelAlign : 'center', 
	labelWidth : 60,
	bodyBorder : 'padding:0 0 0 0',
	layout : 'column',
	region : 'north',
	frame : true,
	height : 40,
	items : [
		{buttonAlign : 'center',
		columnWidth : .2,
		layout : 'column',
		items : [CTHosLabel,CTHos]
		},
		{buttonAlign : 'center',
		columnWidth : .2,
		layout : 'form',
		items : [AppHospitalButton]
		},
		{
		buttonAlign : 'center',
		columnWidth : .2,
		layout : 'form',
		items : [btnQuery]		
		},
		{buttonAlign : 'center',
		columnWidth : .2,
		layout : 'column',
		items : [cboWardLabel,cboWard]
		},
		{buttonAlign : 'center',
		columnWidth : .2,
		layout : 'form',
		items : [AddWardButton]
		}
	]
});
CTHosStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'GetHospital';
			param.Arg1 = CTHos.getRawValue();;
			param.ArgCnt = 1;
	 });
cboWardStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'Nur.InService.DHCDocIPAppointment';
	param.QueryName = 'QryCTLoc';
	param.Arg1 = cboWard.getRawValue();
	param.Arg2 = 'W';
	param.Arg3 = "";
	param.Arg4 = CONST_HOSPID;
	param.Arg5 = '1';
	param.ArgCnt = 4;
});
//****************************************************************************************
var AppHospitalStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:''}), //AppHospitalStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IPAppID'
		}, 
		[
			{name: 'HosID', mapping : 'HosID'}
			,{name: 'HosDesc', mapping : 'HosDesc'}
			
		])
	});
	
var AppHospitalCheckCol = new Ext.grid.CheckColumn({header:'HosID', dataIndex: 'checked', width: 100 });


var AppHospital = new Ext.grid.GridPanel({
		id : 'AppHospital'
		,store : AppHospitalStore
		,region : 'center'
		,layout: 'fit'
		,autoHeight:true
		,buttonAlign : 'center'
		,loadMask : { msg : '正在读取数据,请稍后...'}  
		,columns: [{header: '院区id', width: 100, dataIndex: 'HosID', sortable: true}
			,{header: '院区', width: 200, dataIndex: 'HosDesc', sortable: true}
				
		]
	}
	);
AppHospital.addListener('cellclick',cellclick);  
//--------------------------------------------------------------------------------
var AppWardStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:''}),//AppWardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'//,
			//idProperty: 'paadmno'
		}, 
		[
			{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping : 'LocDesc'}
			
		])
	});
	
var AppWardCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	
var AppWard = new Ext.grid.GridPanel({
		id : 'AppWard'
		,store : AppWardStore
		,region : 'center'
		,buttonAlign : 'center'
		,autoHeight:true
		,loadMask : { msg : '正在读取数据,请稍后...'}  
		,columns: [
			{header: '病区id', width: 100, dataIndex: 'LocID', sortable: true}
			,{header: '病区', width: 300, dataIndex: 'LocDesc', sortable: true}		
		]
	});
//************************************************************************
//var thisHosid=session['LOGON.HOSPID'];
//var thisHosDesc=tkMakeServerCall("Nur.DHCBedManager","GetHospitaldesc",thisHosid)
Ext.onReady(function(){
//alert("");
	new Ext.Viewport({
		enableTabScroll:true,
		collapsible:true,
		layout:"border",
		items:[
		{region:"north",height:66,title:"控制条件",items:[ConditionPanel]},
		{region:"west",width:500,split:true,border:true,collapsible:true,autoScroll:true,title:"受控制的院区",items:[AppHospital]},
		{region:"center",width:500,split:true,border:true,collapsible:true,autoScroll:true,title:"不受控制病区",items:[AppWard]}]
	});
//Ext.getCmp('CTHos').setValue(thisHosid);
//Ext.getCmp('CTHos').setRawValue(thisHosDesc);
Ext.get('AppHospitalButton').on("click",AppHospital_onclick);
Ext.get('AddWardButton').on("click",AddWard_onclick);
Ext.get('btnQuery').on("click",btnQuery_onclick);
btnQuery_onclick();

})

function AppHospital_onclick(e){


        var Hospitalid=CTHos.getValue();
		var ret=tkMakeServerCall("Nur.DHCBedManager","AddHospital",Hospitalid)
		if (ret=="0")
		{
		  Ext.Ajax.request({
			url:'DHCNurBedManagerequest.csp',
			params:{action:'GetHospital',Hospitalid:Hospitalid} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				AppHospitalStore.removeAll();
		        var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.HospList!='') {
				var HospitalListArr=jsonData.HospList.split("!");
				for (var i=0;i<HospitalListArr.length;i++) {
						var HosID = HospitalListArr[i].split("^")[0];
						var HosDesc = HospitalListArr[i].split("^")[1];
						var record = new Object();
		  	     		record.HosID = HosID ;
			       		record.HosDesc = HosDesc ;
						var records = new Ext.data.Record(record);
						AppHospitalStore.add(records);
						}
				
				}
				}
				,
			scope: this
			})
		
		}
		else
		{
		alert(ret)
		return;
		}
		
		}
//添加病区	
function AddWard_onclick(e){
        var Wardid=cboWard.getValue();
		var Hospitalid=CTHos.getValue();
		var ret=tkMakeServerCall("Nur.DHCBedManager","AddWard",Wardid)
		if (ret=="0")
		{
		  Ext.Ajax.request({
			url:'DHCNurBedManagerequest.csp',
			params:{action:'GetWard',Hosid:Hospitalid} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				AppWardStore.removeAll();
		        var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.WardList!='') {
				var WardListArr=jsonData.WardList.split("!");
				for (var i=0;i<WardListArr.length;i++) {
						var LocID = WardListArr[i].split("^")[0];
						var LocDesc = WardListArr[i].split("^")[1];
						var record = new Object();
		  	     		record.LocID = LocID ;
			       		record.LocDesc = LocDesc ;
						var records = new Ext.data.Record(record);
						AppWardStore.add(records);
						}
				
				}
				}
				,
			scope: this
			})
		}
		else
		{
		alert(ret)
		return;
		}
		
		}
function cellclick(grid, rowIndex, columnIndex, e) { 
var linenum=grid.getSelectionModel().lastActive; //获取行号
var objresult=grid.store.data.items[linenum].data;
var Hosid=objresult.HosID;

 Ext.Ajax.request({
			url:'DHCNurBedManagerequest.csp',
			params:{action:'GetWard',Hosid:Hosid} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				AppWardStore.removeAll();
		        var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.WardList!='') {
				var WardListArr=jsonData.WardList.split("!");
				for (var i=0;i<WardListArr.length;i++) {
						var LocID = WardListArr[i].split("^")[0];
						var LocDesc = WardListArr[i].split("^")[1];
						var record = new Object();
		  	     		record.LocID = LocID ;
			       		record.LocDesc = LocDesc ;
						var records = new Ext.data.Record(record);
						AppWardStore.add(records);
						}
				
				}
				}
				,
			scope: this
			})
 
}  	
//********************************************************右键
var contextmenu =new Ext.menu.Menu({
        id: 'theContextMenu',
        items: [
		{
            text: '删除',
			id:'DeleteHospital',
            handler:DeleteHospital
        }
		]
    })
	//grid=Ext.getCmp("gridResult");
AppHospital.on("rowcontextmenu", function(grid1, rowIndex, e){
        e.preventDefault();
        grid1.getSelectionModel().selectRow(rowIndex);
        contextmenu.showAt(e.getXY());
    });
var contextmenu1 =new Ext.menu.Menu({
        id: 'theContextMenu',
        items: [
		{
            text: '删除病区',
			id:'DeleteWard',
            handler:DeleteWard
        }
		]
    })
	//grid=Ext.getCmp("gridResult");
AppWard.on("rowcontextmenu", function(grid1, rowIndex, e){
        e.preventDefault();
        grid1.getSelectionModel().selectRow(rowIndex);
        contextmenu1.showAt(e.getXY());
    });	

//删除院区	
function DeleteHospital() {
	Ext.MessageBox.confirm("删除", "确认删除?", function (btn) {
		if (btn == 'yes') {
			var linenum = AppHospital.getSelectionModel().lastActive; //获取行号
			var objresult = AppHospital.store.data.items[linenum].data;
			var Hosid = objresult.HosID;
			var ret = tkMakeServerCall("Nur.DHCBedManager", "DeleteHospital", Hosid);
			if (ret == "0") {
				alert("删除成功！")
				btnQuery_onclick()
			}
		}
	});
}
//删除病区
function DeleteWard() {
	Ext.MessageBox.confirm("删除", "确认删除?", function (btn) {
		if (btn == 'yes') {
			var linenum = AppWard.getSelectionModel().lastActive; //获取行号
			var objresult = AppWard.store.data.items[linenum].data;
			var Locid = objresult.LocID;
			var ret = tkMakeServerCall("Nur.DHCBedManager", "DeleteWard", Locid);
			if (ret == "0") {
				alert("删除成功！")
				btnQuery_onclick()
			} else {
				alert(ret)
				return;
			}
		}
	});
}
function btnQuery_onclick()
{
var Hospitalid=CTHos.getValue();
Ext.Ajax.request({
			url:'DHCNurBedManagerequest.csp',
			params:{action:'GetHospital',Hospitalid:Hospitalid} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				AppHospitalStore.removeAll();
		        var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.HospList!='') {
				var HospitalListArr=jsonData.HospList.split("!");
				for (var i=0;i<HospitalListArr.length;i++) {
						var HosID = HospitalListArr[i].split("^")[0];
						var HosDesc = HospitalListArr[i].split("^")[1];
						var record = new Object();
		  	     		record.HosID = HosID ;
			       		record.HosDesc = HosDesc ;
						var records = new Ext.data.Record(record);
						AppHospitalStore.add(records);
						}
				
				}
				}
				,
			scope: this
			})
Ext.Ajax.request({
			url:'DHCNurBedManagerequest.csp',
			params:{action:'GetWard',Hosid:Hospitalid} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				AppWardStore.removeAll();
		        var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.WardList!='') {
				var WardListArr=jsonData.WardList.split("!");
				for (var i=0;i<WardListArr.length;i++) {
						var LocID = WardListArr[i].split("^")[0];
						var LocDesc = WardListArr[i].split("^")[1];
						var record = new Object();
		  	     		record.LocID = LocID ;
			       		record.LocDesc = LocDesc ;
						var records = new Ext.data.Record(record);
						AppWardStore.add(records);
						}
				
				}
				}
				,
			scope: this
			})
}




















