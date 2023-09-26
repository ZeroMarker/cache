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
	 
var CTHos = new Ext.form.ComboBox({
		id : 'CTHos'
		,width : 100
		,store : CTHosStore
		,minChars : 1
		,displayField : 'HosDesc'
		,fieldLabel : '院区'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'HosCode'
		
		
});	
//***************************************医嘱项
var OrderitemStoreProxy= new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var OrderitemStore=new Ext.data.Store({
		proxy:OrderitemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ArcimDR'
		},
		[
			{name: 'ArcimDesc', mapping : 'ArcimDesc'}
			,{name: 'ArcimDR', mapping: 'ArcimDR'}
		])
     });
var Orderitem = new Ext.form.ComboBox({
		id : 'Orderitem'
		,width : 100
		,store : OrderitemStore
		,minChars : 1
		,displayField : 'ArcimDesc'
		,fieldLabel : '医嘱项'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'ArcimDR'
		
		
});	




//***************************************************
var NewConDep = new Ext.form.TextField({
		id : 'NewConDep' 
		,width : 80
		,anchor : '100%'
		,fieldLabel : '科室名' 
	});
var NewConDepCode = new Ext.form.TextField({
		id : 'NewConDepCode' 
		,width : 80
		,anchor : '100%'
		,fieldLabel : '科室编码' 
	});
var cboCTLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url : ExtToolSetting.RunQueryPageURL
}));

var cboCTLocStore = new Ext.data.Store({
	proxy: cboCTLocStoreProxy,
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

var cboCTLoc = new Ext.form.ComboBox({
	id : 'cboCTLoc'
	,width : 100
	,minChars : 1
	,selectOnFocus : true 
	,forceSelection : true  
	,store : cboCTLocStore
	,displayField : 'CTLocDesc'
	,fieldLabel : '子科室'
	,editable : true 
	,triggerAction : 'all' 
	,anchor : '100%'
	,valueField : 'CTLocID'
});

cboBigCTLocStoreStoreProxy= new Ext.data.HttpProxy(new Ext.data.Connection({
	url : ExtToolSetting.RunQueryPageURL
}));
var cboBigCTLocStore = new Ext.data.Store({
	proxy: cboBigCTLocStoreStoreProxy,
	reader: new Ext.data.JsonReader({
		root: 'record',
		totalProperty: 'total',
		idProperty: 'BigLocID'
	}, 
	[
		,{name: 'BigLocID', mapping: 'BigLocID'}
		,{name: 'BigLocDesc', mapping: 'BigLocDesc'}
	])
});
var cboBigCTLoc = new Ext.form.ComboBox({
	id : 'cboBigCTLoc'
	,width : 100
	,minChars : 1
	,selectOnFocus : true 
	,forceSelection : true  
	,store : cboBigCTLocStore
	,displayField : 'BigLocDesc'
	,fieldLabel : '大科室'
	,editable : true 
	,triggerAction : 'all' 
	,anchor : '100%'
	,valueField : 'BigLocID'
});

var AddConsultDep = new Ext.Button({
	id : 'AddConsultDep'
	,fieldLabel : ''
	,width : 120
	//,iconCls : 'icon-find'
	,text : '添加会诊大科室'
	,margins : {top:0, right:0, bottom:0, left:100}
});
var btnQuery = new Ext.Button({
		id : 'btnQuery'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 60
		,iconCls : 'icon-find'
		,text : '查询'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var AddConsultItm = new Ext.Button({
	id : 'AddConsultItm'
	,fieldLabel : ''
	,width : 150
	//,iconCls : 'icon-find'
	,text : '添加子科'
	,margins : {top:0, right:0, bottom:0, left:100}
});

var pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .20 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		CTHos,
		cboBigCTLoc
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
var pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .20 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		NewConDep,
		cboCTLoc
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	
var pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .25 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		Orderitem,
		NewConDepCode
		
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
	var pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .20 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		
		AddConsultDep,
		AddConsultItm
		
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
	});
var pConditionChild5 = new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign : 'center'  //添加到当前panel的所有 buttons 的对齐方式。
		,columnWidth : .20 //columnWidth 表示使用百分比的形式指定列宽度，而width 则是使用绝对象素的方式指定列宽度
		,layout : 'form' //布局方式
		,items : [
		btnQuery
		
		]  //一个单独项，或子组件组成的数组，加入到此容器中。
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
	height : 90,
	items : [
			pConditionChild1
			,pConditionChild2
			,pConditionChild3
			,pConditionChild4
			,pConditionChild5
		]
});

CTHosStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'GetHospital';
			param.Arg1 = Orderitem.getRawValue();
			param.ArgCnt = 1;
	 });
//医嘱项
OrderitemStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCConsultNew';
			param.QueryName = 'FindMasterItem';
			param.Arg1 = Orderitem.getRawValue();
			param.ArgCnt = 1;
	 });

cboCTLocStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'web.DHCConsultNew';
	param.QueryName = 'QryCTLoc';
	param.Arg1 = cboCTLoc.getRawValue();
	param.Arg2 = 'E';
	param.Arg3 = "";
	param.Arg4 = "";
	param.ArgCnt = 4;
});

cboBigCTLocStoreStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'web.DHCConsultNew';
	param.QueryName = 'GetBigLoc';
	param.Arg1 = cboBigCTLoc.getRawValue();
	param.ArgCnt = 1;
});
//****************************************************************************************
var AppConsultDepStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:''}), //AppConsultDepStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IPAppID'
		}, 
		[
			{name: 'ConID', mapping : 'ConID'}
			,{name: 'ConDesc', mapping : 'ConDesc'}
			,{name: 'ConCode', mapping : 'ConCode'}
			,{name: 'ARCItmmast', mapping : 'ARCItmmast'}
			,{name: 'ARCItmmastDr', mapping : 'ARCItmmastDr'}
			,{name: 'HosID', mapping : 'HosID'}
			,{name: 'HosDesc', mapping : 'HosDesc'}
			
		])
	});
	
var AppConsultDepCheckCol = new Ext.grid.CheckColumn({header:'ConID', dataIndex: 'checked', width: 100 });


var AppConsultDep = new Ext.grid.GridPanel({
		id : 'AppConsultDep'
		,store : AppConsultDepStore
		,region : 'center'
		,layout: 'fit'
		,autoHeight:true
		,buttonAlign : 'center'
		,loadMask : { msg : '正在读取数据,请稍后...'}  
		,columns: [
		new Ext.grid.CheckboxSelectionModel({singleSelect:true}),
		     {header: 'ID', width: 100, dataIndex: 'ConID', sortable: true}
			,{header: '会诊科室', width: 150, dataIndex: 'ConDesc', sortable: true}
			,{header: '科室编码', width: 100, dataIndex: 'ConCode', sortable: true}
			,{header: '医嘱项', width: 200, dataIndex: 'ARCItmmast', sortable: true}
			,{header: '医嘱项ID', width: 200, dataIndex: 'ARCItmmastDr', sortable: true,hidden:true}
			,{header: '院区ID', width: 200, dataIndex: 'HosID', sortable: true,hidden:true}
			,{header: '院区', width: 200, dataIndex: 'HosDesc', sortable: true}
				
		]
	}
	);
AppConsultDep.addListener('cellclick',cellclick);  
//--------------------------------------------------------------------------------
var ConsultDepItmStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:''}),//ConsultDepItmStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'//,
			//idProperty: 'paadmno'
		}, 
		[
			{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping : 'LocDesc'}
			,{name: 'LocParr', mapping : 'LocParr'}
			,{name: 'LocParrDesc', mapping : 'LocParrDesc'}
			,{name: 'rowid', mapping : 'rowid'}
			
		])
	});
	
var ConsultDepItmCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	
//科室子类
var ConsultDepItm = new Ext.grid.GridPanel({
		id : 'ConsultDepItm'
		,store : ConsultDepItmStore
		,region : 'center'
		,buttonAlign : 'center'
		,autoHeight:true
		,loadMask : { msg : '正在读取数据,请稍后...'}  
		,columns: [
			 {header: '科室id', width: 100, dataIndex: 'LocID', sortable: true}
			,{header: '科室', width: 200, dataIndex: 'LocDesc', sortable: true}		
			,{header: '科室大类id', width: 200, dataIndex: 'LocParr', sortable: true,hidden:true}	
            ,{header: '科室大类', width: 200, dataIndex: 'LocParrDesc', sortable: true}	
            ,{header: 'rowid', width: 200, dataIndex: 'rowid', sortable: true,hidden:true}				
		]
	});
//************************************************************************
Ext.onReady(function(){
//alert("");
	new Ext.Viewport({
		enableTabScroll:true,
		collapsible:true,
		layout:"border",
		items:[
		{region:"north",height:120,title:"操作面板",items:[ConditionPanel]},
		{region:"west",width:500,split:true,border:true,collapsible:true,autoScroll:true,title:"会诊科室",items:[AppConsultDep]},
		{region:"center",width:500,split:true,border:true,collapsible:true,autoScroll:true,title:"会诊子科室",items:[ConsultDepItm]}]
	});
Ext.get('AddConsultDep').on("click",AppConsultDep_onclick);
Ext.get('AddConsultItm').on("click",AddConsultItm_onclick);
Ext.get('btnQuery').on("click",btnQuery_onclick);
btnQuery_onclick();


})

function AppConsultDep_onclick(e){

        var Hospitalid=CTHos.getValue();
		var NewConDep=Ext.getCmp("NewConDep").getValue();  //会诊科室名
		
		
		//*******************
		var Orderitem=Ext.getCmp("Orderitem").getValue();  //会诊医嘱项
		///alert(Orderitem)
		///return;
		//*************************
		var NewConDepCode=Ext.getCmp("NewConDepCode").getValue();
		var ret=tkMakeServerCall("User.DHCConsultLoc","Save",Hospitalid,NewConDep,Orderitem,"",NewConDepCode)
		
		if (ret=="0")
		{
		  Ext.Ajax.request({
			url:'dhcconsultrequest.csp',
			params:{action:'GetConsultDep',Hospitalid:Hospitalid} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				
				AppConsultDepStore.removeAll();
		        var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.ConsultDepList!='') {
				var ConsultDepListArr=jsonData.ConsultDepList.split("!");
				for (var i=0;i<ConsultDepListArr.length;i++) {
						var ConID = ConsultDepListArr[i].split("^")[0];
						var ConDesc = ConsultDepListArr[i].split("^")[1];
						var ConCode = ConsultDepListArr[i].split("^")[2];
						
						var ARCItmmast = ConsultDepListArr[i].split("^")[3];
						var ARCItmmastDr = ConsultDepListArr[i].split("^")[4];
						
						var HosID=ConsultDepListArr[i].split("^")[5];
						var HosDesc=ConsultDepListArr[i].split("^")[6];
						var record = new Object();
		  	     		record.ConID = ConID ;
			       		record.ConDesc = ConDesc ;
						record.ConCode=ConCode;
						record.ARCItmmast=ARCItmmast;
						record.ARCItmmastDr=ARCItmmastDr;
						record.HosID = HosID ;
						record.HosDesc = HosDesc ;
						var records = new Ext.data.Record(record);
						AppConsultDepStore.add(records);
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
//添加会诊子科室
function AddConsultItm_onclick(e){
        var cboBigCTLoc=Ext.getCmp("cboBigCTLoc").getValue();  //大科室id
		if (cboBigCTLoc=="") 
		{
		alert("请选择大科室")
		return;
		}
		var cboCTLoc=Ext.getCmp("cboCTLoc").getValue();  //会诊子科室
		if (cboCTLoc=="")
		{
		alert("请添加子科室")
		return;
        }
		
		var ret=tkMakeServerCall("User.DHCConsultLocItm","Save",cboCTLoc,cboBigCTLoc,"")
		if (ret=="0")
		{
		  Ext.Ajax.request({
			url:'dhcconsultrequest.csp',
			params:{action:'GetItemLoc',cboBigCTLoc:cboBigCTLoc} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				ConsultDepItmStore.removeAll();
		        var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.GetItemLocList!='') {
				var ItemLocListArr=jsonData.GetItemLocList.split("!");
				
				for (var i=0;i<ItemLocListArr.length;i++) {
						var LocID = ItemLocListArr[i].split("^")[0];
						var LocDesc = ItemLocListArr[i].split("^")[1];
						var LocParr=ItemLocListArr[i].split("^")[2];
						var LocParrDesc=ItemLocListArr[i].split("^")[3];
						var rowid=ItemLocListArr[i].split("^")[4];
						var record = new Object();
		  	     		record.LocID = LocID ;
			       		record.LocDesc = LocDesc ;
						record.LocParr = LocParr ;
						record.LocParrDesc = LocParrDesc ;
						record.rowid=rowid;
						var records = new Ext.data.Record(record);
						ConsultDepItmStore.add(records);
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
////cboBigCTLocStore.load({})      //加载大科室
cboBigCTLoc.setValue(objresult.ConID);
cboBigCTLoc.setRawValue(objresult.ConDesc);//  给combobox 赋值
Ext.Ajax.request({
			url:'dhcconsultrequest.csp',
			params:{action:'GetItemLoc',cboBigCTLoc:cboBigCTLoc.value} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				ConsultDepItmStore.removeAll();
		        var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.GetItemLocList!='') {
				var ItemLocListArr=jsonData.GetItemLocList.split("!");
				for (var i=0;i<ItemLocListArr.length;i++) {
				////alert(ItemLocListArr[i])
						var LocID = ItemLocListArr[i].split("^")[0];
						var LocDesc = ItemLocListArr[i].split("^")[1];
						var LocParr=ItemLocListArr[i].split("^")[2];
						var LocParrDesc=ItemLocListArr[i].split("^")[3];
						var rowid=ItemLocListArr[i].split("^")[4];
						var record = new Object();
		  	     		record.LocID = LocID ;
			       		record.LocDesc = LocDesc ;
						record.LocParr = LocParr ;
						record.LocParrDesc = LocParrDesc ;
						record.rowid=rowid;
						var records = new Ext.data.Record(record);
						ConsultDepItmStore.add(records);
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
            text: '修改',
			id:'ChangeBigLoc',
            handler:ChangeBigLoc
        }
		]
    })
	//grid=Ext.getCmp("gridResult");
AppConsultDep.on("rowcontextmenu", function(grid1, rowIndex, e){
        e.preventDefault();
        grid1.getSelectionModel().selectRow(rowIndex);
        contextmenu.showAt(e.getXY());
    });
var contextmenu1 =new Ext.menu.Menu({
        id: 'theContextMenu',
        items: [
		{
            text: '移除子科室',
			id:'DeleteLoc',
            handler:DeleteLoc
        }
		]
    })
	//grid=Ext.getCmp("gridResult");
ConsultDepItm.on("rowcontextmenu", function(grid1, rowIndex, e){
        e.preventDefault();
        grid1.getSelectionModel().selectRow(rowIndex);
        contextmenu1.showAt(e.getXY());
    });	

//删除院区	
function DeleteHospital()
{
return;
var linenum=AppConsultDep.getSelectionModel().lastActive; //获取行号
var objresult=AppConsultDep.store.data.items[linenum].data;
var Hosid=objresult.HosID;
var ret=tkMakeServerCall("Nur.DHCBedManager","DeleteHospital",Hosid);
if(ret=="0")
{
alert("删除成功！")
btnQuery_onclick()
}
}
//删除会诊子科室
function DeleteLoc()
{
var linenum=ConsultDepItm.getSelectionModel().lastActive; //获取行号
var objresult=ConsultDepItm.store.data.items[linenum].data;
var rowid=objresult.rowid;
alert(rowid)
var ret=tkMakeServerCall("User.DHCConsultLocItm","Delete",rowid);
if (ret=="0")
{
alert("删除成功！")
btnQuery_onclick()
}
else
{
alert(ret)
return;
}
}
////查询
function btnQuery_onclick()
{
var Hospitalid=CTHos.getValue();
Ext.Ajax.request
		  Ext.Ajax.request({
			url:'dhcconsultrequest.csp',
			params:{action:'GetConsultDep',Hospitalid:Hospitalid} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				AppConsultDepStore.removeAll();
		        var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.ConsultDepList!='') {
				var ConsultDepListArr=jsonData.ConsultDepList.split("!");
				for (var i=0;i<ConsultDepListArr.length;i++) {
						var ConID = ConsultDepListArr[i].split("^")[0];
						var ConDesc = ConsultDepListArr[i].split("^")[1];
						var ConCode = ConsultDepListArr[i].split("^")[2];
						var ARCItmmast = ConsultDepListArr[i].split("^")[3];
						var ARCItmmastDr = ConsultDepListArr[i].split("^")[4];
						
						var HosID=ConsultDepListArr[i].split("^")[5];
						var HosDesc=ConsultDepListArr[i].split("^")[6];
						var record = new Object();
		  	     		record.ConID = ConID ;
			       		record.ConDesc = ConDesc ;
						record.ConCode = ConCode ;
						record.ARCItmmast=ARCItmmast;
						record.ARCItmmastDr=ARCItmmastDr;
						record.HosID = HosID ;
						record.HosDesc = HosDesc ;
						var records = new Ext.data.Record(record);
						AppConsultDepStore.add(records);
						}
				
				}
				}
				,
			scope: this
			})
Ext.Ajax.request({
			url:'dhcconsultrequest.csp',
			params:{action:'GetItemLoc',cboBigCTLoc:""} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				ConsultDepItmStore.removeAll();
		        var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.GetItemLocList!='') {
				var ItemLocListArr=jsonData.GetItemLocList.split("!");
				for (var i=0;i<ItemLocListArr.length;i++) {
						var LocID = ItemLocListArr[i].split("^")[0];
						//alert(ItemLocListArr[i])
						var LocDesc = ItemLocListArr[i].split("^")[1];
						var LocParr=ItemLocListArr[i].split("^")[2];
						var LocParrDesc=ItemLocListArr[i].split("^")[3];
						var rowid=ItemLocListArr[i].split("^")[4];
						var record = new Object();
		  	     		record.LocID = LocID ;
			       		record.LocDesc = LocDesc ;
						record.LocParr = LocParr ;
						record.LocParrDesc = LocParrDesc ;
						record.rowid=rowid;
						var records = new Ext.data.Record(record);
						ConsultDepItmStore.add(records);
						}
				
				}
				}
				,
			scope: this
			})
}
var cb_data = [["2","北京同仁医院(南区)"],["3","北京同仁医院(西区)"],["45","北京同仁医院(东区)"]]; 
var cb_store = new Ext.data.SimpleStore({ fields: ['value', 'text'], data: cb_data });
function ChangeBigLoc()
{
var linenum=AppConsultDep.getSelectionModel().lastActive; //获取行号
var objresult=AppConsultDep.store.data.items[linenum].data;
//弹框的医嘱项
var Orderitem1StoreProxy= new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var Orderitem1Store=new Ext.data.Store({
		proxy:Orderitem1StoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ArcimDR'
		},
		[
			{name: 'ArcimDesc', mapping : 'ArcimDesc'}
			,{name: 'ArcimDR', mapping: 'ArcimDR'}
		])
     });
var Orderitem1 = new Ext.form.ComboBox({
		id : 'Orderitem1'
		,width : 100
		,store : Orderitem1Store
		,minChars : 1
		,displayField : 'ArcimDesc'
		,fieldLabel : '医嘱项'
		,editable : true
		,triggerAction : 'all'
		,anchor : '60%'
		,valueField : 'ArcimDR'
		
		
});

//弹框
Orderitem1StoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCConsultNew';
			param.QueryName = 'FindMasterItem';
			param.Arg1 = Orderitem1.getRawValue();
			param.ArgCnt = 1;
	 });	
var win = new Ext.Window({					
			title: '信息修改', 
			layout: 'form',					
			width: 550, 
			height: 300, 
			modal: true,
			labelAlign:'right',	
			items: [
			 {		  
			  xtype: "combo",
                     fieldLabel: "院区",
					 id:'CTHosCh',
                     mode:"local", //直接定义写成local
                     triggerAction: 'all', //加载所有项
                     editable: false,
                     store: cb_store,
					 anchor : '60%',
                     displayField: 'text',
					 valueField : 'value'
                 }
				 ,
			 Orderitem1,
			 {
			   xtype:'field', 
			   id:'BigLocCh',
			   fieldLabel:'科室', 
			   width:160, 
			   anchor : '60%',
			   value: objresult.ConDesc
			   } ,
			   {
			   xtype:'field', 
			   id:'BigLocChCode',
			   fieldLabel:'科室编码', 
			   width:160, 
			   anchor : '60%',
			   value: objresult.ConCode
			   } ,
			 
		     {
							xtype : 'button',
							id : 'ChangeBigloc',
							buttonAlign: 'center',
							text : '确认',
							height:30,width:80,
							anchor : '60%',
							style: 'margin:50 121',  ////gg 这种方式调位置,没想到其他法子 
							handler :  function(t,e){
							
							var CTHosChdr=Ext.getCmp("CTHosCh").value;
							var BigLocChdr=Ext.getCmp("BigLocCh").value;
							var arcimdr=Ext.getCmp("Orderitem1").getValue();
							var BigLocChCode=Ext.getCmp("BigLocChCode").getValue();
							///alert(BigLocChCode)
							///return;
							//alert(CTHosChdr+"#"+BigLocChdr+"#"+arcimdr)
							if ((CTHosChdr=="")||(BigLocChdr=="")||(arcimdr=="")||(BigLocChCode==""))
							{
							alert("请添加信息")
							return;
							}
							var rowid=objresult.ConID;
							if(rowid=="")
							{
							alert("id为空")
							return;
							}
							var ret=tkMakeServerCall("User.DHCConsultLoc","Save",CTHosChdr,BigLocChdr,arcimdr,rowid,BigLocChCode)
							if (ret=="0")
							{
							//win.parent.btnQuery_onclick();
							btnQuery_onclick();
							win.close();
							return;
							}
							else
							{
							alert(ret)
							return;
							}
							}
							}
				 ]
				 })
	Ext.getCmp("CTHosCh").setValue(objresult.HosID);
	Ext.getCmp("CTHosCh").setRawValue(objresult.HosDesc);
	Ext.getCmp("Orderitem1").setRawValue(objresult.ARCItmmast);
	Ext.getCmp("Orderitem1").setValue(objresult.ARCItmmastDr);
	//alert(objresult.ARCItmmast)
	win.show();


}

function ChangeConLoc()
{
win.close();
var CTHosCh=Ext.getCmp("CTHosCh").value;
if (CTHosCh=="")
{
alert("请选择院区")
return;
}
}
















