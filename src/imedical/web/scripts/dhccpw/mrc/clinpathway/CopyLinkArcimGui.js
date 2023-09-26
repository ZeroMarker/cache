
function CopyLinkArcim(CPWID,CPWItemID,obj2,FormItemID){
	var obj = new Object();
	obj.CPWID = CPWID;
	obj.obj2 = obj2;
	obj.CPWItemID = CPWItemID;
	obj.FormItemID = FormItemID;
	//*************add by wuqk 2011-12-12***** 展现路径列表*********begin
	
	var CPWLogLocID=CPWLogLocID=session['LOGON.CTLOCID'];
	var SetPower=1;
	var LocPower=ExtTool.GetParam(window,"LocPower");
	if (LocPower==1) {
		SetPower=0;
	}else{
			SetPower=1;
	}
	obj.objVerisonTreeLoader = new Ext.tree.TreeLoader({
	        nodeParameter: 'Arg1',
	        dataUrl: "./dhccpw.tree.csp",
	        baseParams: {
	            ClassName: 'web.DHCCPW.MRC.PathWayQry',
	            QueryName: 'QryLocPathVer',
	            Arg2: (SetPower == 1 ? "" : CPWLogLocID),  //Modified By LiYang 2011-03-31 根据权限显示路径树
	            ArgCnt: 2
	        }
	});
	
	obj.objVerisonTree = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		region : 'west',
		border: false,
		rootVisible: false,
		width:200,
		//title: "科室路径维护",
		title: "路径列表",    //by wuqk 2011-07-21
		loader: obj.objVerisonTreeLoader,
		collapsible : true,
		//height : 200, //Modify By LiYang 2011-03-23 固定版本树高度  //Modified By LiYang 2011-05-21  初始不限定高度
		root: new Ext.tree.AsyncTreeNode({
			leaf: false
			, text: "root"
			, id: "-root"
			, draggable: false
		})
	});
	obj.objVerisonTree.getRootNode().expand();
	
	obj.objVerisonTree.on("click",function(objNode){
		var arryParts = objNode.id.split("-");
		
		
		
		//只有到版本层次才显示临床路径树
		if(arryParts[1] == "Ver"){
			//objRoot.setId(objNode.id);
			obj.CPWID=arryParts[0];
			
			obj.cboEP.clearValue(); //setValue("");
			obj.cboEPStep.clearValue(); //setValue("");
			obj.cboEPStepItem.clearValue(); //setValue("");
			obj.PathARCIMStore.load();
			//obj.PathARCIMStore.removedAll(true);
			//obj.PathARCIM.doLayout();
		}
	},obj);
	//*************add by wuqk 2011-12-12***** 展现路径列表*********end
	
	
	
	
	
	
	//********************************************** 取阶段******************************************
	obj.cboEPStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboEPStore = new Ext.data.Store({
		proxy: obj.cboEPStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'episode', mapping: 'episode'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.cboEP = new Ext.form.ComboBox({
		//id : 'cboEP'//Modified by liyang 2014-02-12
		//,columnwidth : .3
		store : obj.cboEPStore
		,displayField : 'desc'
		,fieldLabel : '阶段'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.cboEPStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWayEp';
			param.QueryName = 'GetPathWayEp';
			param.Arg1 = obj.CPWID;
			param.ArgCnt = 1;
	});
	obj.cboEPStore.load({});
	//********************************************** 取阶段******************************************

	//********************************************** 取步骤******************************************
	obj.cboEPStepStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboEPStepStore = new Ext.data.Store({
		proxy: obj.cboEPStepStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'StepRowid', mapping: 'StepRowid'}
			,{name: 'StepDayNum', mapping: 'StepDayNum'}
			,{name: 'StepDesc', mapping: 'StepDesc'}
		])
	});
	obj.cboEPStep = new Ext.form.ComboBox({
		//id : 'cboEPStep'//Modified by liyang 2014-02-12
		//,columnwidth : .3
		store : obj.cboEPStepStore
		,displayField : 'StepDesc'
		,fieldLabel : '步骤'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'StepRowid'
	});
	obj.cboEPStepStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWEpStep';
			param.QueryName = 'GetPathEpStep';
			param.Arg1 = '';
			param.Arg2 = obj.cboEP.getValue();
			param.ArgCnt = 2;
	});
	//obj.cboEPStepStore.load({});
	//********************************************** 取步骤******************************************

	//********************************************** 取项目******************************************
	obj.cboEPStepItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboEPStepItemStore = new Ext.data.Store({
		proxy: obj.cboEPStepItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'StepItemRowid', mapping: 'StepItemRowid'}
			,{name: 'SubCatDesc', mapping: 'SubCatDesc'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboEPStepItem = new Ext.form.ComboBox({
		//id : 'cboEPStepItem'//Modified by liyang 2014-02-12
		//,columnwidth : .3
		store : obj.cboEPStepItemStore
		,displayField : 'Desc'
		,fieldLabel : '项目'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'StepItemRowid'
	});
	obj.cboEPStepItemStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWEpStepItem';
			param.QueryName = 'GetPathEpStepItem';
			param.Arg1 = obj.cboEPStep.getValue();
			param.Arg2 = '';
			param.ArgCnt = 2;
	});
	//obj.cboEPStepItemStore.load({});
	//********************************************** 取项目******************************************
	/*
	obj.panel1 = new Ext.Panel({
		id : 'panel1'
		,columnWidth : .3
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 35
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'form'
		//,frame : true
		,items:[
			obj.cboEP
		]
	});
	obj.panel2 = new Ext.Panel({
		id : 'panel2'
		,columnWidth : .3
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 35
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'form'
		//,frame : true
		,items:[
			obj.cboEPStep
		]
	});
	obj.panel3 = new Ext.Panel({
		id : 'panel3'
		,columnWidth : .4
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 35
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'form'
		//,frame : true
		,items:[
			obj.cboEPStepItem
		]
	});*/
	obj.NorthPanel = new Ext.Panel({
		//id : 'NorthPanel'//Modified by liyang 2014-02-12
		region : 'north'
		,height : 100
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'form'
		,frame : true
		,items:[
			obj.cboEP
			,obj.cboEPStep
			,obj.cboEPStepItem
		/*
			obj.panel1
			,obj.panel2
			,obj.panel3*/
		]
	});
	//*************************************************************************************************************************
	
	obj.PathARCIMStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PathARCIMStore = new Ext.data.Store({
		proxy: obj.PathARCIMStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IGAIndex'
		},
		[
			{name: 'IGAIndex', mapping: 'IGAIndex'}
			,{name: 'IGNo', mapping: 'IGNo'}
			,{name: 'IGLinkNo', mapping: 'IGLinkNo'}
			,{name: 'IGPriority', mapping: 'IGPriority'}
			,{name: 'IGPriorityDesc', mapping: 'IGPriorityDesc'}
			,{name: 'IGIsMain', mapping: 'IGIsMain'}
			,{name: 'IGAArcimDR', mapping: 'IGAArcimDR'}
			,{name: 'IGAArcimDesc', mapping: 'IGAArcimDesc'}
			,{name: 'PHCGeneDesc', mapping: 'PHCGeneDesc'}
			,{name: 'PHCSpecDesc', mapping: 'PHCSpecDesc'}
			,{name: 'PHCFormDesc', mapping: 'PHCFormDesc'}
			,{name: 'IGAPackQty', mapping: 'IGAPackQty'}
			,{name: 'IGAFreqDR', mapping: 'IGAFreqDR'}
			,{name: 'IGAFreqDesc', mapping: 'IGAFreqDesc'}
			,{name: 'IGADuratDR', mapping: 'IGADuratDR'}
			,{name: 'IGADuratDesc', mapping: 'IGADuratDesc'}
			,{name: 'IGAInstrucDR', mapping: 'IGAInstrucDR'}
			,{name: 'IGAInstrucDesc', mapping: 'IGAInstrucDesc'}
			,{name: 'IGADoseQty', mapping: 'IGADoseQty'}
			,{name: 'IGADoseUomDR', mapping: 'IGADoseUomDR'}
			,{name: 'IGADoseUomDesc', mapping: 'IGADoseUomDesc'}
			,{name: 'IGADefault', mapping: 'IGADefault'}
			,{name: 'IGAIsActive', mapping: 'IGAIsActive'}
			,{name: 'IGAResume', mapping: 'IGAResume'}
			,{name: 'IGASign', mapping: 'IGASign'}
		])
	});
	obj.PathWaysARCIMGridCheckCol = new Ext.grid.CheckColumn({header:'选择', dataIndex: 'checked', width: 50 });
	obj.PathWaysARCIMGrid = new Ext.grid.GridPanel({
//		id : 'PathWaysARCIMGrid'   //Modified by liyang 2014-02-12
		//,title:"可选医嘱项"
		store : obj.PathARCIMStore
		,buttonAlign : 'center'
		//,width : 725
		//,height : 180
		,region: 'center'
		,plugins:obj.PathWaysARCIMGridCheckCol
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.PathWaysARCIMGridCheckCol
			,{header: '通用名', width: 120, dataIndex: 'PHCGeneDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var IGASign = rd.get("IGASign");
					if (IGASign == '1'){
						v = '┏' + v;
					} else if (IGASign == '2'){
						v = '┗' + v;
					} else if (IGASign == '3'){
						v = '' + v;
					} else {
						v = '┃' + v;
					}
					return v;
				}
			}
			,{header: '医嘱类型', width:80, dataIndex: 'IGPriorityDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '顺序号', width: 50, dataIndex: 'IGNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '关联', width: 50, dataIndex: 'IGLinkNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '副医嘱', width: 50, dataIndex: 'IGIsMain', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IGIsMain = rd.get("IGIsMain");
					if (IGIsMain == '0') {
						return "<IMG src='../scripts/dhccpw/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhccpw/img/unchecked.gif'>";
					}
				}
			}
			,{header: '名称', width: 200, dataIndex: 'IGAArcimDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '单次<br>剂量', width: 50, dataIndex: 'IGADoseQty', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '单位', width: 50, dataIndex: 'IGADoseUomDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '频次', width: 70, dataIndex: 'IGAFreqDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '用法', width: 70, dataIndex: 'IGAInstrucDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '疗程', width: 70, dataIndex: 'IGADuratDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '数量', width:50, dataIndex: 'IGAPackQty', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '首选<br>医嘱', width: 50, dataIndex: 'IGADefault', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IGADefault = rd.get("IGADefault");
					if (IGADefault == '1') {
						return "<IMG src='../scripts/dhccpw/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhccpw/img/unchecked.gif'>";
					}
				}
			}
			,{header: '是否<br>有效', width: 50, dataIndex: 'IGAIsActive', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IGAIsActive = rd.get("IGAIsActive");
					if (IGAIsActive == '1') {
						return "<IMG src='../scripts/dhccpw/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhccpw/img/unchecked.gif'>";
					}
				}
			}
			,{header: '备注', width: 100, dataIndex: 'IGAResume', sortable: false, menuDisabled:true, align: 'center'}
		]
	});
	obj.PathARCIMStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCCPW.MRC.FORM.LnkArcimSrv';
			param.QueryName = 'QryLnkArcimByItm';
			param.Arg1 = obj.cboEPStepItem.getValue();
			param.ArgCnt = 1;
	});
	//obj.PathARCIMStore.load({});
	//*************************************************************************************************************************
	obj.btnAdd = new Ext.Button({
		//id : 'btnAdd' //Modified by liyang 2014-02-12
		iconCls : 'icon-add'
		,text : '确定'
	});

	obj.chkSelectAll = new Ext.form.Checkbox({
		fieldLabel : '全选/全不选'
		,value:false
	});
	
	obj.SouthPanel = new Ext.Panel({
		//id : 'SouthPanel'//Modified by liyang 2014-02-12
		region : 'center'
		,buttonAlign : 'center'
		//,labelAlign : 'right'
		//,labelWidth : 70
		//,bodyBorder : 'padding:0 0 0 0'
		,layout : 'border'
		,frame : true
		,items:[
			obj.PathWaysARCIMGrid
			,{
				layout : 'form'
				,region : 'south'
				,height:40 
				,frame : true 
				,items:[obj.chkSelectAll]
			}
		],
		buttons:[
			obj.btnAdd
		]
	});
	
	obj.cboEP_OnExpand = function(){
		obj.cboEP.clearValue();
		obj.cboEPStore.load({});
	}
	obj.cboEP_OnCollapse = function(){
		obj.cboEPStep.clearValue();
	}
	obj.cboEPStep_OnExpand = function(){
		obj.cboEPStep.clearValue();
		obj.cboEPStepStore.load({});
	}
	obj.cboEPStep_OnCollapse = function(){
		obj.cboEPStepItem.clearValue();
	}
	obj.cboEPStepItem_OnExpand = function(){
		obj.cboEPStepItem.clearValue();
		obj.cboEPStepItemStore.load({});
	}
	obj.cboEPStepItem_OnCollapse = function(){
		obj.PathARCIMStore.load({});
	}
	
	
	obj.CenterPanel = new Ext.Panel({
		//id : 'CenterPanel' //Modified by liyang 2014-02-12
		region : 'center'
		,buttonAlign : 'center'
		,layout : 'border'
		,frame : true
		,items:[
			obj.NorthPanel
			,obj.SouthPanel
		]
	});
	
	obj.CopyLinkArcimWindow = new Ext.Window({
			//id : 'win',//Modified by liyang 2014-02-12
			width : 750,
			height : 500,
			x : 20,
			y : 20,
			resizable : false,
			closable : true,
			autoScroll:true,
			animCollapse : true,
			//html:template,
			renderTo : document.body,
			layout : 'border',
			modal : true,
			title : '复制关联医嘱',
			items : [
						//obj.NorthPanel
						//,obj.SouthPanel
				obj.objVerisonTree,
				obj.CenterPanel
			],
			listeners :{
				"beforeclose" : function(){
					
				},
				"beforeshow" : function(){
					obj.cboEP.on("expand", obj.cboEP_OnExpand, obj);
					obj.cboEP.on("collapse", obj.cboEP_OnCollapse, obj);
					obj.cboEPStep.on("expand", obj.cboEPStep_OnExpand, obj);
					obj.cboEPStep.on("collapse", obj.cboEPStep_OnCollapse, obj);
					obj.cboEPStepItem.on("expand", obj.cboEPStepItem_OnExpand, obj);
					obj.cboEPStepItem.on("collapse", obj.cboEPStepItem_OnCollapse, obj);
				}
			}
	});
//*********************************End*************************************
	CopyLinkArcimEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

