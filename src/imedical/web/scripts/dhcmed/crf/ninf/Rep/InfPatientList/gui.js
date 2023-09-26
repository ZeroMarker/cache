
function InitViewport(){
	var obj = new Object();
	
	obj.LogLocType = LogLocType;   //登录科室类型
	obj.TransType  = TransType;    //转科类型(科室/病区)
	obj.AdminPower  = 0;
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	} else {
		obj.AdminPower  = AdminPower;
	}
	
	//主窗体功能区
	obj.MainPanel = new Ext.Panel({
		id : "MainPanel"
		//,title: "Patient List"
		,region: "center"
		,enableTabScroll : true
		,autoDestroy : true
		,html:"<iframe id='MainPanelFrame' height='100%' width='100%' src='" + '' + "'/>"
	});
	
	//报告查询功能
	obj.ReportQueryRootNode = new Ext.tree.TreeNode({
		leaf: false
		, text : "root"
		, id: "root"
		, draggable: false
	});
	
	//科室病人列表
	obj.PatientListTreePanel = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		rootVisible: false,
		region: "center",
		frame: true,
		loader: new Ext.tree.TreeLoader({
	        dataUrl: "./dhcmed.ninf.rep.treeloader.csp",
	        baseParams: {
	            ClassName   : 'DHCMed.NINFService.Srv.CommonCls',
	            MethodName  : 'BuildAdmTransJson',
				Arg1        : 'Y',
	            Arg2        : (obj.LogLocType == 'E' ? session['LOGON.CTLOCID'] : ''),
				Arg3        : (obj.LogLocType == 'W' ? session['LOGON.CTLOCID'] : ''),
	            Arg4        : '',
				Arg5        : obj.TransType,
				Arg6        : (obj.AdminPower != '1' ? session['LOGON.CTLOCID'] : ''),
				Arg7		: '2,3',
	            ArgCnt      : 7
	        }
		}),
		root: new Ext.tree.AsyncTreeNode({
			id: "-root"
			,text: "root"
			,leaf: false
			,draggable: false
			,expanded: true
		})
	});
	obj.PatientListTreePanel.expandAll();
	
	obj.chkIPFlag = new Ext.form.Checkbox({
		id : 'chkIPFlag'
		,checked : true
		,fieldLabel : '在院'
		,anchor : '98%'
	});
	obj.txtRegNo = new Ext.form.TextField({
		id : 'txtRegNo'
		,fieldLabel : '登记号'     //update likai for bug:3849
		,anchor : '98%'
	});
	obj.txtMrNo = new Ext.form.TextField({
		id : 'txtMrNo'
		,fieldLabel : '病案号'
		,anchor : '98%'
	});
	obj.txtPatName = new Ext.form.TextField({
		id : 'txtPatName'
		,fieldLabel : '姓名'
		,anchor : '98%'
	});
	
	///增加医院选项
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"DTH");
	
	//obj.cboAdmLoc = Common_ComboToLoc("cboAdmLoc","科室","E","cboAdmWard","I","");
	obj.cboAdmLoc = Common_ComboToLoc("cboAdmLoc","科室","E","cboAdmWard","I","cboSSHosp");
	obj.cboAdmWard = Common_ComboToLoc("cboAdmWard","病区","W","cboAdmLoc","","");
	
	obj.btnAdmFind = new Ext.Button({
		id : 'btnAdmFind'
		,iconCls : 'icon-find'
		,width : 70
		,text : '查询'
	});
	
	//左侧功能区
	obj.LeftPanel = new Ext.Panel({
		id:'LeftPanel',
		region:"west",
		split:true,
		collapsible: true,
        lines:false,
        animCollapse:false,
        animate: false,
        collapseMode:'mini',
		collapseFirst:false,
		hideCollapseTool:true,
		border:true,
		width:270,
		boxMinWidth : 270,
		boxMaxWidth : 270,
		layout:"accordion",
		layoutConfig: {animate: true},
		items:[
			{
				layout : 'border',
				frame : true,
				title : '科室病人列表',
				items : [
					obj.PatientListTreePanel
					,{
						layout : 'form',
						height : 230,
						region : "south",
						frame : true,
						labelAlign : 'right',
						labelWidth : 50,
						buttonAlign : 'center',
						items : [
							obj.chkIPFlag
							,obj.cboSSHosp
							,obj.cboAdmLoc
							,obj.cboAdmWard
							,obj.txtRegNo
							,obj.txtMrNo
							,obj.txtPatName
						],
						buttons : [
							obj.btnAdmFind
						]
					}
				]
			}
		]
	});
	
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.MainPanel
			,obj.LeftPanel
		]
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

