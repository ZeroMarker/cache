function InitViewscreen(){
	var obj = new Object();
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		//,iconCls : 'icon-new'
		,text : '查询'
	});
	
	obj.btnExport = new Ext.Button({ //Add By LiYang 2013-11-25  增加导出功能
		id : 'btnExport',
		text : '导出'
	});
	obj.dtFromDate = new Ext.form.DateField({
		id : 'DateFrom',
		format : 'Y-m-d',
		fieldLabel : '报告日期',
		anchor : '95%',
		altFormats : 'Y-m-d|d/m/Y',
		value : new Date()
	});
	obj.dtToDate = new Ext.form.DateField({
		id : 'DateTo'
		,fieldLabel : '结束日期'
		,format : 'Y-m-d'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
		,anchor : '95%'
	});
/*
	var objService = ExtTool.StaticServerObject("DHCMed.SS.MyPortlets");
	var objPortlet = objService.GeMyportletsByGroup(groupId);
		
	var arryTmp = objPortlet.split("<$C1>");
  for(var intRow = 0; intRow < arryTmp.length; intRow ++)
		{
			 var myPortlet = arryTmp[intRow];
			 if(myPortlet == "") continue;
			 var arryField = myPortlet.split("^");
			 //var myPorId=arryField[0];
			 var pId = arryField[0];
			 var pName = arryField[1];
			 var ProIsShow = arryField[2];
			 var check=false;
			 if(ProIsShow=="1")
			 {
			 	check=true;
				}
     	var menuItem=new Ext.menu.CheckItem({
			 //	itemId:myPorId+"^"+groupId+"^"+pId,
			 	itemId:pId,
				text:pName,
				checked : check,
				listeners: {
        'checkchange': function(e,checked){  
        	}
      	}
			});
			menu.addItem(menuItem);
			menu.doLayout();
		}
*/
	var arrItem = new Array();
	var objService = ExtTool.StaticServerObject("DHCMed.CR.BO.FormQry");
	var objPortlet = objService.GetStatusList(FormId);		
	var arryTmp = objPortlet.split("<$C1>");
  for(var intRow = 0; intRow < arryTmp.length; intRow ++)
	{
		var myPortlet = arryTmp[intRow];
		if(myPortlet == "") continue;
		var arryField = myPortlet.split("^");
		var chkItem = {boxLabel : arryField[1],name : arryField[0],checked : false};
		arrItem.push(chkItem);
   }
   arrItem[0].checked=true;
/*   var arrItem = new Array();
	var chkItem = {boxLabel : '已审',name : 'Y',checked : false};
	arrItem.push(chkItem);
	var chkItem = {boxLabel : '退回',name : 'R',checked : false};
	arrItem.push(chkItem);
		var chkItem = {boxLabel : '草稿',name : 'C',checked : false};
	arrItem.push(chkItem);
		var chkItem = {boxLabel : '二审',name : 'DR',checked : false};
	arrItem.push(chkItem);*/
	obj.bgRepStatus = new Ext.form.CheckboxGroup({
		id : 'bgRepStatus'
		,fieldLabel : '报告状态'
		,anchor : '95%'
		,columns : 4
		,xtype : 'checkboxgroup'
		,items : arrItem
	});

	obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboLocStore = new Ext.data.Store({
		proxy : obj.cboLocStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'CTLocID'
		}, 
		[{
			name : 'checked',mapping : 'checked'
		}, {
			name : 'CTLocID',mapping : 'CTLocID'
		}, {
			name : 'CTLocDesc',mapping : 'CTLocDesc'
		}
		//,{name: 'selecttext', convert: seltext}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc',
		width : 100,
		store : obj.cboLocStore,
		minChars : 1,
		displayField : 'CTLocDesc',
		fieldLabel : '报告科室',
		editable : true,
		triggerAction : 'all',
		anchor : '95%',
		valueField : 'CTLocID'
	});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.Base.Ctloc';
		param.QueryName = 'QryCTLoc';
		param.Arg1 = obj.cboLoc.getRawValue();
		param.Arg2 = 'E';
		param.Arg3 = "";
		;param.Arg4 = "";
		param.ArgCnt = 4;
	});
	   obj.pnCol11 = new Ext.Panel({
		id : 'pnCol11'
		,columnWidth : 0.3
		,layout : 'form'
		,items:[
			obj.dtFromDate
      ,obj.bgRepStatus
		]
	});
		obj.pnCol12 = new Ext.Panel({
		id : 'pnCol12'
		,columnWidth : 0.3
		,layout : 'form'		
		,items:[
			obj.dtToDate			
      ,obj.cboLoc  
 //     ,obj.comboProvinces   
		]
	});
			obj.pnCol13 = new Ext.Panel({
		id : 'pnCol13'
		,columnWidth : 0.4
		,layout : 'form'
		,buttonAlign : 'left'
		,items:[
		]
		,buttons:[
			obj.btnFind,
			obj.btnExport
		]
	});
	 obj.ConditionPanel = new Ext.FormPanel({
		id : 'ConditionPanel'
	//	,width: 460
		,height : 150	
		,labelWidth : 60
		,region : 'north'// 'center'
		,title :winTitle //"["+FormDesc+"]查询"
		,frame:true
		,layout : 'column'
		,items:[
			obj.pnCol11
			,obj.pnCol12
			,obj.pnCol13
		]
		
		});
		
		// ******************************Start****************************
	// 查询列表显示
	try {
		var objClass = ExtTool.StaticServerObject("DHCMed.CR.BO.FormQry");
		if (objClass) {
			var JsonExp = objClass.BuildCRReportHeader(FormId);
			window.eval(JsonExp); // 返回数组:gridHeader、gridColumn、storeFields
		}
	} catch (e) {
		var gridColumn = "", storeFields = "";
		ExtTool.alert("错误", "获取动态Json数据错误!");
	}
	if ((gridColumn == "") || (storeFields == "")) {
		return;
	}
	
	obj.gridColumn = gridColumn;
	obj.storeFields = storeFields;
	
	obj.GridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : './dhcmed.store.csp',
		timeout : 300000,
		method : 'POST'
	}));
	obj.GridStore = new Ext.data.Store({
		proxy : obj.GridStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total'
				//,idProperty: 'ReportID'
			},
			obj.storeFields
		)
	});
	obj.RstGridPanel = new Ext.grid.GridPanel({
		id : 'RstGridPanel',
		loadMask : true,
		store : new Ext.data.ArrayStore({}),
		animCollapse : false,
		region : 'center',
		columns : obj.gridColumn 
	/*	,viewConfig : {
			// forceFit : true    //是否强制调整表格列宽以适用表格的整体宽度，防止出现水平滚动条，默认为false
			enableRpwBody : true, //是否包含行体
			showPreview : true,   //
			layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					}
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					}
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					}
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}*/
	});
	// ****************************** End ****************************
	obj.Viewscreen = new Ext.Viewport({
		id : 'Viewscreen'
		,layout : 'border'
		,items:[
			obj.ConditionPanel
			,obj.RstGridPanel
		]
	});
	obj.GridStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.CR.BO.FormQry';
		param.MethodName = 'BuildCRReportStoreTest';
		param.Arg1 = FormId;
		param.Arg2 = obj.dtFromDate.getRawValue();
		param.Arg3 = obj.dtToDate.getRawValue();
		param.Arg4 = obj.cboLoc.getValue();
		param.Arg5 = obj.GetStatusList();
		param.Arg6 = '';
		param.ArgCnt = 6;
	});

	InitViewscreenEvent(obj);
	//事件处理代码
	obj.btnFind.on("click", obj.btnFind_click, obj);
	obj.btnExport.on("click", obj.btnExport_click, obj);
	obj.cboLoc.on("expand", obj.cboLoc_OnExpand, obj);
	obj.RstGridPanel.on("rowdblclick", obj.GridPanel_rowdblclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}
