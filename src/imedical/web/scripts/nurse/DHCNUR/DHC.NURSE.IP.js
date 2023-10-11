// 加载ext组件

function InitializeForm() {
		var patientTree = CreateTree("patientTree");
		var anchorPanel = new Ext.FormPanel({
			// layout : 'anchor',
			items: [{
				xtype: 'fieldset',
				id: 'FsSearch',
				labelWidth: 55,
				collapsible: true,
				title: '查询条件',
				frame: false,
				bodyStyle: 'padding:1px',
				items: [{
					layout: 'table',
					layoutConfig: {
						columns: 2
					},
					items: [{
						xtype: 'datefield',
						id: 'startDate',
						fieldLabel: '开始日期',
						//format: 'Y-m-d',
						width:130,
						colspan: 1
					}, {
						xtype: 'timefield',
						id: 'startTime',
						colspan: 2,
						width: 110,
						format: 'G:i'
							// format : 'Y-m-d'
					}, {
						// layout:'form',
						colspan: 1,
						xtype: 'datefield',
						width:130,
						id: 'endDate',
						fieldLabel: '结束日期'
						//format: 'Y-m-d'

						// value : session['TODAY']
					}, {
						// layout:'form',
						colspan: 2,
						xtype: 'timefield',
						width: 110,
						id: 'endTime',
						format: 'G:i'
							// format : 'Y-m-d'
							// value : session['TODAY']
					}]
				}, {
					layout: 'table',
					layoutConfig: {
						columns: 2
					},
					items: [{
							xtype: 'label',
							text: '科室',
							colspan: 1
						},
						CreateComboBox('ctlocDr', 'ctlocDesc', 'ctlocId', '科室', "", 200, 'web.DHCNurIpComm', 'Ctloc', 'desc', 2), {
							xtype: 'label',
							text: '病区',
							colspan: 1
						},
						CreateComboBox('wardDr', 'desc', 'rw', '病区', "", 200, 'web.DHCLCNUREXCUTE', 'GetWard', 'code', 2), {
							xtype: 'label',
							text: '医嘱项',
							colspan: 1
						},
						CreateComboBox('arcimDr', 'ArcimDesc', 'ArcimDR', '医嘱项', "", 200, 'web.DHCNurCom', 'FindMasterItem', "ARCIMDesc", 2)
					]
				}, {
					layout: 'table',
					layoutConfig: {
						columns: 4
					},
					items: [{
						xtype: 'label',
						width: 50,
						text: '医生医嘱'
					}, {
						xtype: 'checkbox',
						id: 'docTyp',
						width: 50,
						checked: true
					}, {
						xtype: 'label',
						text: '已执行/已处理',
						width: 80
					}, {
						xtype: 'checkbox',
						id: 'ckbExecute',
						width: 30,
						text: '已执行'
					}, {
						xtype: 'label',
						text: '新医嘱',
						width: 50
					}, {
						xtype: 'checkbox',
						id: 'ckbNew',
						width: 50
					}, {
						xtype: 'label',
						text: '未执行',
						width: 50
					}, {
						xtype: 'checkbox',
						id: 'ckbUnExec',
						width: 30
					}, {
						xtype: 'label',
						text: '长期医嘱',
						width: 50
					}, {
						xtype: 'checkbox',
						id: 'ckbLong',
						width: 50
					}, {
						xtype: 'label',
						text: '临时医嘱',
						width: 50
					}, {
						xtype: 'checkbox',
						id: 'ckbTemp',
						width: 30
					}, {
						xtype: 'label',
						text: '开医嘱时间'
					}, {
						xtype: 'checkbox',
						id: 'ckStartDate',
						width: 50
					}, {
						xtype: 'label',
						text: 'PRN医嘱',
						width: 50
					}, {
						xtype: 'checkbox',
						id: 'ckbPrnOrd',
						width: 30
					}, {
						xtype: 'label',
						text: '          ',
						rowspan: 1
					}, {
						xtype: 'label',
						text: '          '
					}, {
						xtype: 'button',
						id: 'btnSearch',
						text: '查询',
						icon:'../images/uiimages/search.png',
						width:100,
						rowspan: 1,
						handler: Search_Click
					}]
				}]

			}, {
				xtype: 'fieldset',
				collapsible: true,
				title: '病人排序',
				id: 'FsSort',
				labelWidth: 80,
				frame: false,
				items: [{
					xtype: 'checkbox',
					id: 'ckbGroup',
					fieldLabel: '专业组排序'
				}]
			}, {
				xtype: 'fieldset',
				title: '病人列表',
				id: 'FsPats',
				containerScroll: true,
				collapsible: true,
				autoScroll: true,
				frame: true,
				items: [patientTree]
			}]
		});

		var viewPort = new Ext.Viewport({
			layout: 'border',
			id: "viewPort",
			defaults: {
				border: true,
				frame: true,
				bodyBorder: true
			},
			items: [{
				region: 'west',
				width: 290,
				minWidth: 140,
				split: true,
				items: anchorPanel,
				collapsible: true
			}, {
				region: 'center',
				layout: 'fit',
				title: getDsposeStatColor(),
				items: CreateTabs("tabVarTyp")
			}]
		});
		// var disposeStatInfo=new Ext.form.
	}
	// 初始化组件初始值

function getDsposeStatColor() {
	var str = "<table>" + "<tr>" + "<TD noWrap><label id='cColorLongNew'  style='WIDTH: 85px; HEIGHT: 24px; BACKGROUND-IMAGE: url(../images/uiimages/dhcnurse/newlong.png);    FONT-SIZE: 12px; PADDING-TOP: 4px;PADDING-LEFT: 18px;           padding-bottom:4px;margin-left:20px;'>新开长期医嘱</label></TD>" +
		"<TD noWrap><label id='cColorTemp'                                style='WIDTH: 85px; HEIGHT: 24px; BACKGROUND-IMAGE: url(../images/uiimages/dhcnurse/optemp.png);     FONT-SIZE: 12px; PADDING-TOP: 4px;PADDING-LEFT: 18px;           padding-bottom:4px;margin-left:5px;'>新开临时医嘱</label></TD>" +
		"<TD noWrap><label id='cColorImmediate'                           style='WIDTH: 85px; HEIGHT: 24px; BACKGROUND-IMAGE: url(../images/uiimages/dhcnurse/immediate.png);  FONT-SIZE: 12px; PADDING-TOP: 4px;PADDING-LEFT: 18px;           padding-bottom:4px;margin-left:5px;'>新开即刻医嘱</label></TD>" +
		//"<TD noWrap><label id='cColorPreDiscon'                           style='WIDTH: 85px; HEIGHT: 24px; BACKGROUND-IMAGE: url(../images/uiimages/dhcnurse/prediscon.png);  FONT-SIZE: 12px; PADDING-TOP: 4px;PADDING-LEFT: 18px;color:#fff;padding-bottom:4px;padding-right:3px;margin-left:5px;'>预停医嘱</label></TD>" +
		"<TD noWrap><label id='cColorDiscontinue'                         style='WIDTH: 85px; HEIGHT: 24px; BACKGROUND-IMAGE: url(../images/uiimages/dhcnurse/discontinue.png);FONT-SIZE: 12px; PADDING-TOP: 4px;PADDING-LEFT: 18px;color:#fff;padding-bottom:4px;padding-right:3px;margin-left:5px;'>停止需处理</label></TD>" +
		"<TD noWrap><label id='cColorExecDiscon'                          style='WIDTH: 85px; HEIGHT: 24px; BACKGROUND-IMAGE: url(../images/uiimages/dhcnurse/ExecDiscon.png); FONT-SIZE: 12px; PADDING-TOP: 4px;PADDING-LEFT: 18px;color:#fff;padding-bottom:4px;padding-right:3px;margin-left:5px;'>停止已处理</label></TD>" +
		"<TD noWrap><label id='cColorLongUnnew'                           style='WIDTH: 85px; HEIGHT: 24px; BACKGROUND-IMAGE: url(../images/uiimages/dhcnurse/longunnew.png);  FONT-SIZE: 12px; PADDING-TOP: 4px;PADDING-LEFT: 18px;           padding-bottom:4px;padding-right:3px;margin-left:5px;'>非新长嘱</label></TD>" +
		"<TD noWrap><label id='cColorSkinTest'                            style='WIDTH: 85px; HEIGHT: 24px; BACKGROUND-IMAGE: url(../images/uiimages/dhcnurse/opskintest.png); FONT-SIZE: 12px; PADDING-TOP: 4px;PADDING-LEFT: 18px;color:#fff;padding-bottom:4px;padding-right:3px;margin-left:5px;'>皮试医嘱</label></TD>" +
		"<TD noWrap><label id='cColorExec'                                style='WIDTH: 85px; HEIGHT: 24px; BACKGROUND-IMAGE: url(../images/uiimages/dhcnurse/opexec.png);     FONT-SIZE: 12px; PADDING-TOP: 4px;PADDING-LEFT: 18px;           padding-bottom:4px;padding-right:3px;margin-left:5px;'>已执行医嘱</label></TD>" + "</tr>" + " </table>"
	return str;
}

function InitializeValue() {

	// alert(tkMakeServerCall("web.DHCLCNUREXCUTE",
	// "GetUserWardId",session['LOGON.USERID'], session['LOGON.CTLOCID'],""))
	// 初始化日期初始值
	Ext.getCmp("startDate").setValue(session['TODAY']);
	Ext.getCmp("endDate").setValue(session['TOMORROW']);
	Ext.getCmp("startTime").setValue("0");
	//20121223Ext.getCmp("endTime").setValue("12:00");
	Ext.getCmp("endTime").setValue("23:59");

	// 初始化病区科室初始值
	var wardLocInfo = tkMakeServerCall("web.DHCLCNUREXCUTE", "GetUserWardId", session['LOGON.USERID'], session['LOGON.CTLOCID'], EpisodeID).split("|");
	var wardInfo = wardLocInfo[0].split("^");
	var locInfo = wardLocInfo[1].split("^");
	Ext.getCmp("ctlocDr").setDisabled(true);
	Ext.getCmp("ctlocDr").getStore().load({
		params: {
			start: 0,
			limit: 10,
			desc: locInfo[0]
		},
		callback: function() {

			Ext.getCmp("ctlocDr").setValue(locInfo[1])

		}
	});

	Ext.getCmp("wardDr").setDisabled(true);
	Ext.getCmp("wardDr").getStore().load({
		params: {
			start: 0,
			limit: 10,
			code: wardInfo[0]
		},
		callback: function() {
			Ext.getCmp("wardDr").setValue(wardInfo[1]);

		}
	});

	// 初始化执行单据页签
	var str = tkMakeServerCall("web.DHCCLNURSET", "GetUserGroupAccess", session['LOGON.GROUPID'], session['LOGON.USERID']);
	var arrayList = str.split("!");
	var tabList = arrayList[0].split("^");
	var tabs = Ext.getCmp("tabVarTyp");
	var defaultTabId = "";
	for (var i = 0; i < tabList.length; i++) {
		(function(info) {
			var infoDetail = info.split("|");
			tabs.add({
				title: infoDetail[1],
				id: infoDetail[0]
			});
			if (i == 0) {
				defaultTabId = infoDetail[0];
			}
		})(tabList[i]);
	}

	// 执行单据页签点击事件
	tabs.on("tabchange", function() {
			Search();
		})
		// 调整病人列表高度
	var FsSort = Ext.getCmp("FsSort")
	var FsSearch = Ext.getCmp("FsSearch")
	var patientTree = Ext.getCmp("patientTree")
	var patientTreeAutoHeight = function() {
		Ext.getCmp("patientTree").setHeight(Ext.getCmp("viewPort").getHeight() - Ext.getCmp("FsSearch").getHeight() - Ext.getCmp("FsSort").getHeight() - 120)
	}
	FsSort.on("collapse", function() {
		patientTreeAutoHeight()
	}, this)
	FsSort.on("expand", function() {
		patientTreeAutoHeight()
	}, this)
	FsSearch.on("collapse", function() {
		patientTreeAutoHeight()
	}, this)
	FsSearch.on("expand", function() {
		patientTreeAutoHeight()
	}, this)

	//
	// 病人列表数的点击事件
	patientTree.on("click", function(node) {
		if ((!arguments[1]) != true) {
			node.getUI().toggleCheck();
		}
		var childNodeArray = node.childNodes;
		if (childNodeArray.length == 0) {
			return;
		}
		for (var i = 0; i < childNodeArray.length; i++) {
			childNodeArray[i].getUI().toggleCheck(node.getUI().isChecked());
			arguments.callee(childNodeArray[i], false)
		}
	})
	patientTree.on("checkchange", function(node) {
			var childNodeArray = node.childNodes;
			if (childNodeArray.length == 0) {
				return;
			}
			for (var i = 0; i < childNodeArray.length; i++) {
				childNodeArray[i].getUI().toggleCheck(node.getUI()
					.isChecked());
				arguments.callee(childNodeArray[i], false)
			}

		})
		// 病人列表双击事件
	patientTree.on("dblclick", function(node) {
		node.getUI().toggleCheck(true)
		Search_Click()
	});
	patientTree.on("load", function() {
		if (arrayList[1] != "") {
			tabs.activate(arrayList[1])
		} else {
			if (defaultTabId != "") {
				tabs.activate(defaultTabId);
			}

		};

	})
	patientTree.setHeight(patientTreeAutoHeight())
	patientTree.expandAll();
	// 专业组排序
	Ext.getCmp("ckbGroup").on("check", function() {
			var loader = patientTree.getLoader();
			loader.dataUrl = '../csp/dhc.nurse.ext.common.getdataold.csp?className=Nur.QueryBroker&methodName=GetTree&type=Method&ctlocDr=' + session['LOGON.CTLOCID'] + "&adm=" + EpisodeID + "&groupSort=" + Ext.getCmp("ckbGroup").getValue();
			loader.load(patientTree.getRootNode(), function() {
				patientTree.expandAll();
			})
		})
		// 长期临时事件
	var long = Ext.getCmp("ckbLong");
	var temp = Ext.getCmp("ckbTemp");
	long.on("check", function() {

		if (long.getValue()) {
			temp.setValue("false");
			/*Ext.getCmp("startDate").setValue(session['TODAY']);
			Ext.getCmp("startTime").setValue("12:01");
			Ext.getCmp("endDate").setValue(session['TOMORROW']);
			Ext.getCmp("endTime").setValue("12:00");
		} else {
			Ext.getCmp("startDate").setValue(session['TODAY']);
			Ext.getCmp("endDate").setValue(session['TOMORROW']);
			Ext.getCmp("startTime").setValue("0");
			Ext.getCmp("endTime").setValue("12:00");*/
		}
	});
	temp.on("check", function() {
			if (temp.getValue()) {
				long.setValue("false");
				/*Ext.getCmp("startDate").setValue(session['TODAY']);
			Ext.getCmp("startTime").setValue("00:00");
			Ext.getCmp("endDate").setValue(session['TODAY']);
			Ext.getCmp("endTime").setValue("23:59");
		} else {
			Ext.getCmp("startDate").setValue(session['TODAY']);
			Ext.getCmp("endDate").setValue(session['TOMORROW']);
			Ext.getCmp("startTime").setValue("0");
			Ext.getCmp("endTime").setValue("12:00");*/
			}
		})
		// 全局快捷键
		/*
		new Ext.KeyMap(this.document, [{
			key: [16],
			fn: function() {
				Ext.getCmp("FsSearch").toggleCollapse();
				Ext.getCmp("FsSort").toggleCollapse();
			}
		}])*/

}

function Search() {
	InitializeSearchData();

}

function Search_Click() {
	Search()
}

function InitializeSearchData() {

	var varStr = Ext.getCmp("tabVarTyp").getActiveTab().id.split("@");
	var pats = Ext.getCmp("patientTree").getChecked("id")
	if (pats.length == 0) {
		pats = "&patsAdm=" + EpisodeID
	} else {
		pats = "&patsAdm=" + pats.join("^")
	}
	var vartyp = "&vartyp=" + varStr[1];
	var ctlocDr = "&ctlocDr=" + Ext.getCmp("ctlocDr").getValue();
	var wardid = "&wardid=" + Ext.getCmp("wardDr").getValue();
	var RegNo = "&RegNo=";
	var userId = "&userId=" + session['LOGON.USERID'];
	var StartDate = "&StartDate=" + Ext.getCmp("startDate").getRawValue();
	var EndDate = "&EndDate=" + Ext.getCmp("endDate").getRawValue();
	var startTime = "&startTime=" + Ext.getCmp("startTime").getRawValue();
	var endTime = "&endTime=" + Ext.getCmp("endTime").getRawValue();
	var doctyp = "&doctyp=" + Ext.getCmp("docTyp").getValue();
	var ArcimDR = "&ArcimDR=" + Ext.getCmp("arcimDr").getValue();
	var HospitalRowId = "&HospitalRowId=" + varStr[0];
	var wardProGroupId = "&wardProGroupId="
	var excute = "&excute=" + Ext.getCmp("ckbExecute").getValue();
	var long = "&long=" + Ext.getCmp("ckbLong").getValue();
	var temp = "&temp=" + Ext.getCmp("ckbTemp").getValue();
	var newOrd = "&newOrd=" + Ext.getCmp("ckbNew").getValue();
	var unExec = "&unExec=" + Ext.getCmp("ckbUnExec").getValue();
	var prnOrd = "&prnOrd=" + Ext.getCmp("ckbPrnOrd").getValue();
	var StartCheck = "&StartCheck=" + Ext.getCmp("ckStartDate").getValue();
	frames['OrdList'].location.href = "dhcnuripexeclist.csp?" + vartyp + ctlocDr + wardid + RegNo + userId + StartDate + EndDate + doctyp + ArcimDR + HospitalRowId + wardProGroupId + pats + excute + long + temp + startTime + endTime + newOrd + unExec + prnOrd + StartCheck;
	// var wardid=
	// alert(frames['tabPanelBody'].location.href)
	// autoLoad: {url: '../csp/dhcnuripexeclist.csp'} refresh
	// "dhcnuripexeclist.csp?"+"&wardid="+wardid+"&RegNo="+regobj+"&userId="+userId+"&StartDate="+stdate+"&EndDate="+edate+"&vartyp="+vartyp+"&warddes="+wardobj+"&Loc="+locid+"&doctyp="+doctyp+"&longNewOrdAdd="+longNewOrdAdd+"&onlyNewOrd="+onlyNewOrd+"&ArcimDR="+ArcimDR+"&wardProGroupId="+wardProGroupId+"&HospitalRowId="+HospitalRowId;
}

function CreateTree(patientTree) {
	var loader = new Ext.tree.TreeLoader({
		dataUrl: '../csp/dhc.nurse.ext.common.getdataold.csp?className=Nur.QueryBroker&methodName=GetTree&type=Method&ctlocDr=' + session['LOGON.CTLOCID'] + "&adm=" + EpisodeID
	});
	var root = new Ext.tree.AsyncTreeNode({
		checked: false,
		text: "全病区",
		iconCls: 'all'
	});
	var tree = new Ext.tree.TreePanel({
		root: root,
		// animate : true,
		// frame:true,
		// tbar:[new Ext.form.ComboBox({id:"dsds"})],
		autoScroll: true,
		id: 'patientTree',
		rootVisible: true,
		height: 100,
		width: 255,
		containerScroll: true,
		autoScroll: true,
		loader: loader
	})
	return tree;
}

function CreateTabs(id) {
	var tabs = new Ext.TabPanel({
		id: id,
		enableTabScroll: true,
		autoWidth: true,
		enableTabScroll: true,
		scrollIncrement: 500,
		html: '<iframe name="OrdList" style="width:100%; height:100%;" frameborder=0 src="" ></iframe>'
	});
	return tabs;
}

function CreateStore(className, methodName) {
	var store = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: "../csp/dhc.nurse.ext.common.getdataold.csp"
		}),
		reader: new Ext.data.JsonReader(eval("(" + tkMakeServerCall("Nur.QueryBroker", "GenerateMetaData", className, methodName) + ")")),
		baseParams: {
			className: className,
			methodName: methodName,
			type: 'Query'
		}
	});

	// paramsArray=paramsArray+","
	return store;
}

function CreateComboBox(id, displayField, valueField, fieldLabel, value, width, className, methodName, queryParam, column) {
	var combox = new Ext.form.ComboBox({
		store: CreateStore(className, methodName),
		displayField: displayField,
		valueField: valueField,
		fieldLabel: fieldLabel,
		id: id,
		value: value,
		colspan: column,
		width: width,
		hideTrigger: false,
		queryParam: queryParam,
		forceSelection: true,
		triggerAction: 'all',
		minChars: 0,
		pageSize: 10,
		typeAhead: false,
		typeAheadDelay: 1000,
		loadingText: 'Searching...'
	})
	combox.on("expand", function(comboBox) {
		comboBox.list.setWidth('500');
		comboBox.innerList.setWidth('auto');
	}, this, {
		single: true
	})
	return combox;
}
Ext.onReady(function() {
	InitializeForm();
	InitializeValue()

});