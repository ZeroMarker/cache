﻿var formQueryBBar = new Ext.Toolbar({
    border: true,
    autoWidth: true,
    items: [{
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        id: 'chkCurLoc',
        name: 'chkCurLoc',
        xtype: 'checkbox',
        boxLabel: '本科病人病历授权',
        hideLabel: true,
        checked: chkCurLoc,
        disabled: true
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        xtype: 'tbspacer'
    }, {
        id: 'btnAppointQuery',
        name: 'btnAppointQuery',
        xtype: 'button',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/btnSearch.gif',
        text: '查询',
        pressed: false,
        handler: getAppointList
    }, '-', {
        id: 'btnQueryReset',
        name: 'btnQueryReset',
        xtype: 'button',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/sltPrint.gif',
        text: '重置',
        pressed: false,
        handler: queryReset
    }]
});

var rootNode = new Ext.tree.AsyncTreeNode({
    text: '请选择病历范围',
    nodeType: 'async',
    draggable: false,
    id: "RT0"
})

var formQueryCondition = new Ext.form.FormPanel({
    id: 'pnlSimple',
    layout: 'form',
    frame: true,
    bbar: formQueryBBar,
    keys: [{
        key: Ext.EventObject.ENTER,
        scope: this,
        fn: getAppointList
    }, {
        key: Ext.EventObject.ESC,
        scope: this,
        fn: queryReset
    }],
    items: [{
        layout: 'column',
        items: [{
            columnWidth: .17,
            labelAlign: 'right',
            layout: 'form',
            items: [            
            {
                id: 'cbxAppointAction',
                name: 'cbxAppointAction',
                xtype: 'combo',
                fieldLabel: '授权情况',
                anchor: '75%',
                readOnly: true,
                store: new Ext.data.SimpleStore({
                    fields: ['id', 'name'],
                    data: [['getunappointed', '未授权'], ['getappointed', '已授权'], ['getrefuse', '已拒绝']]
                }),
                mode: 'local',
                displayField: 'name',
                valueField: 'id',
                triggerAction: 'all',
                selectOnFocus: true,
                readOnly: true,
                editable: false,
                emptyText: '请选择授权情况',
                listeners: {
                    scope: this,
                    change: function(){
                        if (Ext.getCmp('cbxAppointAction').getValue() == "getunappointed") {
                            Ext.getCmp('cbxIsActive').clearValue();
                            Ext.getCmp('cbxIsActive').setDisabled(true);
                            Ext.getCmp('cbxCanAppoint').setDisabled(false);
                            Ext.getCmp('dtAppointDateStart').setDisabled(true);
                            Ext.getCmp('dtAppointDateEnd').setDisabled(true);
							Ext.getCmp('tmAppointTimeStart').setDisabled(true);
                            Ext.getCmp('tmAppointTimeEnd').setDisabled(true);
                            Ext.getCmp('dtRequestDateStart').setDisabled(false);
                            Ext.getCmp('dtRequestDateEnd').setDisabled(false);
							Ext.getCmp('tmRequestTimeStart').setDisabled(false);
                            Ext.getCmp('tmRequestTimeEnd').setDisabled(false);
                            Ext.getCmp('dtAppointDateStart').setValue("");
                            Ext.getCmp('dtAppointDateEnd').setValue("");
                            Ext.getCmp('tmAppointTimeStart').setValue("");
                            Ext.getCmp('tmAppointTimeEnd').setValue("");
                        }
                        else 
                            if (Ext.getCmp('cbxAppointAction').getValue() == "getappointed") {
                                Ext.getCmp('cbxCanAppoint').clearValue();
                                Ext.getCmp('cbxCanAppoint').setDisabled(true);
                                Ext.getCmp('cbxIsActive').setDisabled(false);
                                Ext.getCmp('cbxIsActive').setValue(1);
                                Ext.getCmp('dtAppointDateStart').setDisabled(false);
                                Ext.getCmp('dtAppointDateEnd').setDisabled(false);
								Ext.getCmp('tmAppointTimeStart').setDisabled(false);
                                Ext.getCmp('tmAppointTimeEnd').setDisabled(false);
                                Ext.getCmp('dtRequestDateStart').setDisabled(true);
                                Ext.getCmp('dtRequestDateEnd').setDisabled(true);
								Ext.getCmp('tmRequestTimeStart').setDisabled(true);
                                Ext.getCmp('tmRequestTimeEnd').setDisabled(true);
                                Ext.getCmp('dtRequestDateStart').setValue("");
                                Ext.getCmp('dtRequestDateEnd').setValue("");
                                Ext.getCmp('tmRequestTimeStart').setValue("");
                                Ext.getCmp('tmRequestTimeEnd').setValue("");
                            }
                            else {
                                Ext.getCmp('cbxCanAppoint').clearValue();
                                Ext.getCmp('cbxCanAppoint').setDisabled(true);
                                Ext.getCmp('cbxIsActive').clearValue();
                                Ext.getCmp('cbxIsActive').setDisabled(true);
                                Ext.getCmp('dtAppointDateStart').setDisabled(false);
                                Ext.getCmp('dtAppointDateEnd').setDisabled(false);
								Ext.getCmp('tmAppointTimeStart').setDisabled(false);
                                Ext.getCmp('tmAppointTimeEnd').setDisabled(false);
                                Ext.getCmp('dtRequestDateStart').setDisabled(true);
                                Ext.getCmp('dtRequestDateEnd').setDisabled(true);
								Ext.getCmp('tmRequestTimeStart').setDisabled(true);
                                Ext.getCmp('tmRequestTimeEnd').setDisabled(true);
                                Ext.getCmp('dtRequestDateStart').setValue("");
                                Ext.getCmp('dtRequestDateEnd').setValue("");
                                Ext.getCmp('tmRequestTimeStart').setValue("");
                                Ext.getCmp('tmRequestTimeEnd').setValue("");
                            }
                    }
                }
            }, {
                id: 'cbxCanAppoint',
                name: 'cbxCanAppoint',
                xtype: 'combo',
                fieldLabel: '授权权限',
                anchor: '75%',
                readOnly: true,
                editable: false,
                store: new Ext.data.SimpleStore({
                    fields: ['id', 'name'],
                    data: [['0', '无权限'], ['1', '可授权'], ['2', '全部']]
                }),
                mode: 'local',
                displayField: 'name',
                valueField: 'id',
                triggerAction: 'all',
                selectOnFocus: true,
                emptyText: '请选择授权权限'
            }, {
                id: 'cbxAuthLevel',
                name: 'cbxAuthLevel',
                xtype: 'combo',
                fieldLabel: '授权级别',
                anchor: '75%',
                readOnly: true,
                editable: false,
                store: new Ext.data.SimpleStore({
                    fields: ['id', 'name'],
                    data: [['100', '主管医师'], ['200', '科主任'], ['300', '医务处'], ['ALL','全部']]
                }),
                mode: 'local',
                displayField: 'name',
                valueField: 'id',
                triggerAction: 'all',
                selectOnFocus: true,
                emptyText: '请选择授权级别'
            }, {
                id: 'cbxIsActive',
                name: 'cbxIsActive',
                xtype: 'combo',
                fieldLabel: '生效授权',
                anchor: '75%',
                readOnly: true,
                disabled: true,
                editable: false,
                store: new Ext.data.SimpleStore({
                    fields: ['id', 'name'],
                    data: [['0', '过期'], ['1', '生效授权'], ['2', '全部']]
                }),
                mode: 'local',
                displayField: 'name',
                valueField: 'id',
                triggerAction: 'all',
                selectOnFocus: true,
                emptyText: '请选择生效授权'
            }]
        
        }, 
		{
			columnWidth: .17,
            layout: 'form',
            labelAlign: 'right',
            items: [
			//add by niucaicai 2013-03-13  start
            {
                id: 'txtPapmiNo',
                name: 'txtPapmiNo',
                xtype: 'textfield',
                fieldLabel: '登记号',
                anchor: '85%',
                emptyText: '请填写登记号',
                value: '',
                enableKeyEvents: true
            },            //add by niucaicai 2013-03-13   end 
			//add by niucaicai 2015-10-08   start 增加按病案号查询
			{
                id: 'MedicareNo',
                name: 'MedicareNo',
                xtype: 'textfield',
                fieldLabel: '病案号',
                anchor: '85%',
                emptyText: '请填写病案号',
                value: '',
                enableKeyEvents: true
            },
			//add by niucaicai 2015-10-08   end
			{
                id: 'textName',
                name: 'textName',
                xtype: 'textfield',
                fieldLabel: '患者姓名',
                anchor: '85%',
                emptyText: '请填写姓名',
                value: '',
                enableKeyEvents: true
            }
			]
		},
		{
			columnWidth: .17,
            layout: 'form',
            labelAlign: 'right',
            items: [
			{
                id: 'cbxTreatmentLoc',
                name: 'cbxTreatmentLoc',
                xtype: 'combo',
                fieldLabel: '就诊科室',
                anchor: '85%',
                minChars: 1,
                store: getLocStore,
                hiddenName: 'locID',
                displayField: 'DicDesc',
                valueField: 'ID',
                triggerAction: 'all',
                selectOnFocus: true,
                emptyText: '请选择就诊科室'
            },{
                id: 'cbxPAAdmType',
                name: 'cbxPAAdmType',
                xtype: 'combo',
                fieldLabel: '就诊类型',
                anchor: '85%',
                editable: false,
                store: new Ext.data.SimpleStore({
                    fields: ['id', 'name'],
                    data: [['I', '住院'], ['O', '门诊'], ['E', '急诊']]
                }),
                mode: 'local',
                displayField: 'name',
                valueField: 'id',
                triggerAction: 'all',
                selectOnFocus: true,
                emptyText: '请选择就诊类型'
            }, {
                id: 'cbxPAStatus',
                name: 'cbxPAStatus',
                xtype: 'combo',
                fieldLabel: '在院状态',
                anchor: '85%',
                editable: false,
                store: new Ext.data.SimpleStore({
                    fields: ['id', 'name'],
                    data: [['in', '在院'], ['out', '出院']]
                }),
                mode: 'local',
                displayField: 'name',
                valueField: 'id',
                triggerAction: 'all',
                selectOnFocus: true,
                emptyText: '请选择在院状态'
            }
			]
		},
		{
            columnWidth: .17,
            layout: 'form',
            labelAlign: 'right',
            items: [{
                id: 'txtRequestUserName',
                name: 'txtRequestUserName',
                xtype: 'textfield',
                fieldLabel: '申请医生',
                anchor: '85%',
                emptyText: '请填写申请医生',
                value: '',
                enableKeyEvents: true
            }, {
                id: 'cbxRequestLoc',
                name: 'cbxRequestLoc',
                anchor: '85%',
                xtype: 'combo',
                fieldLabel: '申请科室',
                minChars: 1,
                store: getRequestLocStore,
                hiddenName: 'locID',
                displayField: 'DicDesc',
                valueField: 'ID',
                triggerAction: 'all',
                selectOnFocus: true,
                emptyText: '请选择申请科室'
            }, {
                id: 'cbxRangeTree',
                name: 'cbxRangeTree',
                xtype: 'combotree',
                anchor: '85%',
                listWidth: 300,
                fieldLabel: '申请范围',
				readOnly: true,
                disabled: true,
                editable: false,
                tree: new Ext.tree.TreePanel({
                    id: 'comboTree',
                    name: 'comboTree',
                    width: 298,
                    anchor: '100%',
                    loader: new Ext.tree.TreeLoader({
                        dataUrl: "../web.eprajax.ActionRange.cls"
                    }),
                    root: rootNode,
                    listeners: {
                        load: function(){
                            rootNode.expand(true);
                        },
                        checkchange: function(node, checked){
                            if (node.leaf) {
                                if (!checked) {
                                    //任一子节点未选中，则不选中父节点
                                    node.parentNode.attributes.checked = false;
                                    node.parentNode.getUI().checkbox.checked = false;
                                }
                                else {
                                    //选中所有子节点，则选中父节点
                                    var totChecked = true;
                                    for (var i = 0; i < node.parentNode.childNodes.length; i++) {
                                        if (!node.parentNode.childNodes[i].attributes.checked) {
                                            totChecked = false;
                                            break;
                                        }
                                    }
                                    node.parentNode.attributes.checked = totChecked;
                                    node.parentNode.getUI().checkbox.checked = totChecked;
                                }
                            }
                            else {
                                //选中父节点，则选中所有子节点
                                for (var i = 0; i < node.childNodes.length; i++) {
                                    node.childNodes[i].attributes.checked = checked;
                                    node.childNodes[i].getUI().checkbox.checked = checked;
                                }
                            }
                            
                            var selectNodes = Ext.getCmp('comboTree').getChecked();
                            var selectValues = "";
							globalRequestRange = "";  //选择节点前，先将globalRequestRange清空 add by 牛才才 2016-11-01
                            for (var i = 0; i < selectNodes.length; ++i) {
                                var selectNode = selectNodes[i];
                                var selectValue = selectNode.attributes['text'];
                                var selectID = selectNode.attributes['id'];
                                if (typeof selectValue != 'undefined') {
                                    if (selectNode.leaf) 
                                        if (selectValues == "") {
                                            selectValues = selectValue;
                                            globalRequestRange = selectID;
                                        }
                                        else {
                                            selectValues = selectValue + " | " + selectValue;
                                            globalRequestRange = globalRequestRange + "#" + selectID;
                                        }
                                }
                            }
                            Ext.getCmp('cbxRangeTree').setValue(selectValues);
                        }
                    }
                }),
                emptyText: '请选择申请范围'
            }
			]
        }, 
		{
            columnWidth: .19,
            layout: 'form',
            labelAlign: 'right',
            items: [
			{
                id: 'dtRequestDateStart',
                name: 'dtRequestDateStart',
                xtype: 'datefield',
                fieldLabel: '申请起始日',
                anchor: '100%',
                format: 'Y-m-d'
				/*,
                listeners: {
                    scope: this,
                    change: function(){
                        if (Ext.getCmp('dtRequestDateStart').getValue() != "") {
                            Ext.getCmp('tmRequestTimeStart').setVisible(true);
                        }
                        else {
                            Ext.getCmp('tmRequestTimeStart').clearValue();
                            Ext.getCmp('tmRequestTimeStart').setVisible(false);
                        }
                    }
                }
				*/
            }, {
                id: 'dtRequestDateEnd',
                name: 'dtRequestDateEnd',
                xtype: 'datefield',
                fieldLabel: '申请终止日',
                anchor: '100%',
                format: 'Y-m-d'
				/*,
                listeners: {
                    scope: this,
                    change: function(){
                        if (Ext.getCmp('dtRequestDateEnd').getValue() != "") {
                            Ext.getCmp('tmRequestTimeEnd').setVisible(true);
                        }
                        else {
                            Ext.getCmp('tmRequestTimeEnd').clearValue();
                            Ext.getCmp('tmRequestTimeEnd').setVisible(false);
                        }
                    }
                }
				*/
            }, {
                id: 'dtAppointDateStart',
                name: 'dtAppointDateStart',
                xtype: 'datefield',
                fieldLabel: '授权起始日',
                anchor: '100%',
                format: 'Y-m-d'
				/*,
                listeners: {
                    scope: this,
                    change: function(){
                        if (Ext.getCmp('dtAppointDateStart').getValue() != "") {
                            Ext.getCmp('tmAppointTimeStart').setVisible(true);
                        }
                        else {
                            Ext.getCmp('tmAppointTimeStart').clearValue();
                            Ext.getCmp('tmAppointTimeStart').setVisible(false);
                        }
                    }
                }
				*/
            }, {
                id: 'dtAppointDateEnd',
                name: 'dtAppointDateEnd',
                xtype: 'datefield',
                fieldLabel: '授权终止日',
                anchor: '100%',
                format: 'Y-m-d'
				/*,
                listeners: {
                    scope: this,
                    change: function(){
                        if (Ext.getCmp('dtAppointDateEnd').getValue() != "") {
                            Ext.getCmp('tmAppointTimeEnd').setVisible(true);
                        }
                        else {
                            Ext.getCmp('tmAppointTimeEnd').clearValue();
                            Ext.getCmp('tmAppointTimeEnd').setVisible(false);
                        }
                    }
                }
				*/
            }
			]
        }, 
		{
            columnWidth: .09,
            layout: 'form',
			labelWidth: 34,
            labelAlign: 'left',
            items: [{
                id: 'tmRequestTimeStart',
                name: 'tmRequestTimeStart',
                xtype: 'timefield',
				fieldLabel: '时间',
                //hideLabel: true,
				width:70,
                //anchor: '50%',
                increment: 60,
                format: 'H:i'
				//,hidden: true
            }, {
                id: 'tmRequestTimeEnd',
                name: 'tmRequestTimeEnd',
                xtype: 'timefield',
				fieldLabel: '时间',
                //hideLabel: true,
				width:70,
                //anchor: '50%',
                increment: 60,
                format: 'H:i'
				//,hidden: true
            }, {
                id: 'tmAppointTimeStart',
                name: 'tmAppointTimeStart',
                xtype: 'timefield',
				fieldLabel: '时间',
                //hideLabel: true,
				disabled: true,
				width:70,
                //anchor: '50%',
                increment: 60,
                format: 'H:i'
				//,hidden: true
            }, {
                id: 'tmAppointTimeEnd',
                name: 'tmAppointTimeEnd',
                xtype: 'timefield',
				fieldLabel: '时间',
                //hideLabel: true,
				disabled: true,
				width:70,
                //anchor: '50%',
                increment: 60,
                format: 'H:i'
				//,hidden: true
            }]
        }
		/*
		, 
		{
            columnWidth: .04,
            layout: 'form',
            items: [{}]
        }
		*/
		]
    }]
});

//授权类型
var appointTypeData = [['0', '个人'], ['1', '科室']];

//操作类型
var actionTypeData = [['view', '界面模板浏览'], ['save', '保存'], ['print', '打印'], ['commit', '提交'], ['switch', '选择模板'], ['switchtemplate', '更新模板'], ['chiefcheck', '主任医师签名'], ['attendingcheck', '主治医生签名'], ['browse', '病历浏览']];

//默认申请时间跨度
var appointRequestSpanData = [['0', '无'], ['24', '24小时内'], ['48', '48小时内'], ['72', '72小时内'], ['168', '1周内']];

//可编辑列定义**********************************************
//授权类型
var columnAppointType = new Ext.grid.GridEditor(new Ext.form.ComboBox({
    id: 'cbxAppointType',
    name: 'cbxAppointType',
    store: new Ext.data.SimpleStore({
        fields: ['value', 'text'],
        data: appointTypeData
    }),
    valueField: 'value',
    displayField: 'text',
    typeAhead: true,
    triggerAction: 'all',
    mode: 'local',
    editable: false,
    selectOnFocus: true
}));

//授权时间（小时）
var colunmAppointSpan = new Ext.grid.GridEditor(new Ext.form.TextField({
    id: 'txtAppointSpan',
    name: 'txtAppointSpan',
    regex: /^([1-9][0-9]{0,2}(\.[0-9][1-9]?)?)$|^(0\.[0-9][1-9]?)$/
}));

//操作类型（批准）
var colunmActionType = new Ext.grid.GridEditor(new Ext.form.ComboBox({
    id: 'cbxActionType',
    name: 'cbxActionType',
    store: new Ext.data.SimpleStore({
        fields: ['value', 'text'],
        data: actionTypeData
    }),
    valueField: 'value',
    displayField: 'text',
    typeAhead: true,
    triggerAction: 'all',
    mode: 'local',
    editable: false,
    selectOnFocus: true,
    emptyText: '请选择',
    blankText: '请选择'
}));

var store = new Ext.data.JsonStore({
    url: url,
    root: 'Data',
    totalProperty: 'TotalCount',
    fields: 	
	[{
        name: 'EpisodeID'
	}, {
        name: 'PaadmNO'
    }, {
        name: 'PapmiNo'
    }, {
        name: 'Name'
    }, {
        name: 'MedicareNo'
    }, {
        name: 'AdmDate'
    }, {
        name: 'AdmTime'
    }, {
        name: 'MainDoc'
    }, {
        name: 'CurDept'
    }, {
        name: 'PAAdmType'
    }, {
        name: 'PAStatus'
    }, {
        name: 'PADischgeDateTime'
    }, {
        name: 'AppointID'
	}, {
        name: 'RequestUser'
	}, {
        name: 'RequestDept'
	}, {
        name: 'RequestDate'
	}, {
        name: 'RequestTime'
	}, {
        name: 'RequestDateTime'
	}, {
        name: 'AppointDate'
	}, {
        name: 'AppointTime'
	}, {
        name: 'AppointDateTime'
	}, {
        name: 'AppointUser'
	}, {
        name: 'AppointType'
	}, {
        name: 'IsActive'
	}, {
        name: 'AppointSpan'
	}, {
        name: 'AppointEndDateTime'
	}, {
        name: 'IsAppointed'
	}, {
        name: 'CanAppoint'
	}, {
        name: 'AuthLevel'
	}, {
        name: 'AuthLevelDesc'
	}, {
        name: 'RefuseReason'
	}, {
        name: 'RequestReason'
	}, {
        name: 'BeforeRequestContent'
	}, {
        name: 'AfterRequestContent'
	}, {
        name: 'AppointDetailData'
    }]
	//此处不做自动排序，如果自动排序，用户会觉得全部数据的排序被打乱，全部数据整体而言没有进行排序；
	/*	,
    sortInfo: {
        field: 'RequestDate',
        direction: 'asc'
		//direction: 'desc'
    }*/
});

var sm = new Ext.grid.CheckboxSelectionModel({
	singleSelect: false,
	renderer: function(v, c, r){
		//重写CheckboxSelectionModel的Renderer，若已授权和无权限授权，不显示行头的复选框
		if (r.get('CanAppoint') == '0' || CheckAppointed(r.get('IsAppointed')) || CheckAuthLevel(r.get('AuthLevel')) == false) {
			return " ";
		}
		//原本行头的复选框
		else {
			return '<div class="x-grid3-row-checker">&#160;</div>';
		}
	},
	listeners: {
		//若已授权和无权限授权，不可选中
		'beforerowselect': function(s, n, k, r){
			if (r.get('CanAppoint') == '0' || CheckAppointed(r.get('IsAppointed')) || CheckAuthLevel(r.get('AuthLevel')) == false) {
				return false;
			}
		}
	}
});

//数据正常加载
store.on('load', function(){
	if('IE11.0'==isIE()){
		Ext.getCmp('dgResultGrid').addClass('ext-ie');
	}
    changeRowBackgroundColor(Ext.getCmp('dgResultGrid'));
});

//数据加载异常
store.on('loadexception', function(proxy, options, response, e){
    //debugger;
    alert(response.responseText);
});

var expander = new Ext.grid.RowExpander({
	 tpl : new Ext.XTemplate(
	 '<div class="detailData" id="expanderdiv"></div>'
	 )
 });

expander.on("expand",function(expander,r,body,rowIndex){
	var dgResultGrid = Ext.getCmp('dgResultGrid');
	
	Ext.util.Observable.capture(dgResultGrid,function(){
		if(arguments[0] == 'rowclick'){
			if(DisableParent == 1){
				DisableParent = 0;
			}
			else{
				return true;
			}
		} 
		return false;
	});
	
	var expanderdivID = "expanderdiv" + rowIndex;
	body.innerHTML = '<div class="detailData" id="' + expanderdivID + '" data-options="fit:true,border:false" sysle="width:500px;overflow-x:auto;"></div>'
	
	var expanderdata = r.data['AppointDetailData'];
	var expanderstore=new Ext.data.JsonStore({
		fields:  
		[
			{
				name: 'CateCharpter'
			}, {
				name: 'CCDesc'
			}, {
				name: 'CCDateTime'
			}, {
				name: 'CCCreator'
			}, {
				name: 'IsAppointed'
			}, {
				name: 'CanAppoint'
			}, {
				name: 'DetailStr'
			}
		]
		,data:expanderdata
	});
	
	var expandersm = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true,
		renderer: function(v, c, r){
			return " ";   //占位使用
		},
		listeners: {
			//单击行事件
			'rowselect': function(record, index, e){
				var grid = Ext.getCmp(expanderGridID);
				expanderGridRowClick(grid,index,e);
				//选中对象触发的事件
				//var grid = Ext.getCmp(expanderGridID);
				//ID = grid.getStore().getAt(index).data['ID'];
			},
			'rowclick': function (g, index, e){
				expanderGridRowClick(grid,index,e);
			}
		}
	});

	var expandercm = new Ext.grid.ColumnModel([
		//expandersm,
		{
			header: '实例(模板)ID',
			dataIndex: 'CateCharpter',
			width: 70,
			hidden: true
		},{
			header: '病历名称',
			dataIndex: 'CCDesc',
			width: 415
		},{
			header: '病历书写日期',
			dataIndex: 'CCDateTime',
			width: 160
		},{
			header: '病历创建者',
			dataIndex: 'CCCreator',
			width: 90
		},{
			header: '申请的操作',
			dataIndex: 'DetailStr',
			width: 170,
			renderer: rendererRequestAction
		},{
			header: '授权的操作',
			dataIndex: 'DetailStr',
			width: 170,
			renderer: rendererAppointAction
		},{
			header: 'DetailStr',
			dataIndex: 'DetailStr',
			width: 70,
			hidden: true
		} 
		
	]);
	
	var expanderGridID = "expanderGrid" + rowIndex;
	var expanderGrid = new Ext.grid.GridPanel({
		id: expanderGridID,
		store:expanderstore,
		cm:expandercm,
		//sm:expandersm,
		renderTo:expanderdivID,
		autoScroll: true,
		frame: true,
		//height: 280,
		//width: 1003,
		autoHeight: true,
		autoWidth: true,
		viewConfig: {
			columnsText: '显示的列',
			sortAscText: '升序',
			sortDescText: '降序'
		},
		listeners: {
			//单击行事件
			'rowclick': function (g, index, e){
				expanderGridRowClick(g,index,e);
			},
			'headerclick': function(g, columnId, e){
				//expanderGridHeaderClick(g, columnId, e);
			}
		}
	});
	/*
	Ext.util.Observable.capture(Ext.getCmp('expanderGridID'),function(e){  
		if (e == "rowcontextmenu")
		{
			return false;  
		}
	});
	*/
	//changeRowBackgroundColor(expanderGrid);
	//expanderGrid.addListener('rowclick', expanderGridRowClick, false);
	//expanderGrid.addListener('headerclick', gridHeaderClick, false);
	//expanderGrid.addListener("rowcontextmenu", rightClickFn, false);
});

var WithdrawcheckColumn = new Ext.grid.CheckColumn({
	header: "收回权限",
	dataIndex: 'AppointWithdraw',
	width: 70,
	renderer: function(v, p, record){
		if (record.get('IsActive') != "1" || CheckAuthLevel(record.get('AuthLevel')) == false) {
			return " ";
		}
		else {
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col' + (v ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		}
	}
});

var cm = new Ext.grid.ColumnModel([
	expander,
	sm,
	{
		header: '授权表ID',
		dataIndex: 'AppointID',
		width: 70,
		hidden: true
	}, {
		header: '能否审核',
		dataIndex: 'CanAppoint',
		width: 70,
		sortable: true,
		renderer: rendererCanAppoint
	}, {
		header: '授权级别',
		dataIndex: 'AuthLevelDesc',
		width: 70,
		sortable: true
	}, {
		header: '是否过期',
		dataIndex: 'IsActive',
		width: 70,
		sortable: true,
		renderer: rendererIsActive
	},
	WithdrawcheckColumn,
	{
		header: '患者姓名',
		dataIndex: 'Name',
		width: 80,
		sortable: true
	}, {
		header: '就诊科室',
		dataIndex: 'CurDept',
		width: 140,
		sortable: true
	}, {
		header: '主治医师',
		dataIndex: 'MainDoc',
		width: 70,
		sortable: true
	}, {
		header: '申请医师',
		dataIndex: 'RequestUser',
		width: 70,
		sortable: true
	}, {
		header: '申请时间',
		dataIndex: 'RequestDateTime',
		width: 150,
		sortable: true
	}, {
		header: '申请原因',
		dataIndex: 'RequestReason',
		width: 180,
		//renderer: TrimEnterAndWrite
		renderer:function(data,metadata){
			var data = TrimEnterAndWrite(data);
			metadata.attr = 'ext:qtip=' + data;

			return data;
		}
	}, {
		header: '在院状态',
		dataIndex: 'PAStatus',
		width: 75,
		sortable: true,
		renderer: rendererPAStatus
	}, {
		header: '出院日期',
		dataIndex: 'PADischgeDateTime',
		width: 150,
		sortable: true,
		renderer: rendererPADischgeDateTime
	}, {
		header: '登记号',
		dataIndex: 'PapmiNo',
		width: 100,
		sortable: true
	}, {
		header: '病案号',
		dataIndex: 'MedicareNo',
		width: 80,
		sortable: true
	}, {
		header: '就诊日期',
		dataIndex: 'AdmDate',
		width: 90,
		sortable: true
	}, {
		header: '就诊时间',
		dataIndex: 'AdmTime',
		width: 80,
		sortable: true
	}, {
		header: '就诊类型',
		dataIndex: 'PAAdmType',
		width: 70,
		sortable: true,
		renderer: rendererPAAdmType
	}, {
		header: '就诊号',
		dataIndex: 'PaadmNO',
		width: 110,
		sortable: true
	}, {
		header: '申请科室',
		dataIndex: 'RequestDept',
		width: 140,
		sortable: true
	}, {
		header: '授权状态',
		dataIndex: 'IsAppointed',
		width: 70,
		sortable: true,
		renderer: rendererIsAppointed
	}, {
		header: '授权医师',
		dataIndex: 'AppointUser',
		width: 70,
		sortable: true
	}, {
		header: '授权类型',
		dataIndex: 'AppointType',
		width: 80,
		sortable: true,
		editor: columnAppointType,
		renderer: getAppointType
	}, {
		header: '授权剩余时间（小时）',
		dataIndex: 'AppointSpan',
		width: 150,
		sortable: true,
		editor: colunmAppointSpan,
		renderer: rendererAppointSpan
	}, {
		header: '授权/拒绝时间',
		dataIndex: 'AppointDateTime',
		width: 150,
		sortable: true,
		renderer: rendererAppointDateTime
	}, {
		header: '授权结束时间',
		dataIndex: 'AppointEndDateTime',
		width: 150,
		sortable: true,
		renderer: rendererAppointDateTime
	}, {
		header: '修改前内容',
		dataIndex: 'BeforeRequestContent',
		width: 180,
		sortable: true,
		//renderer: TrimEnterAndWrite
		renderer:function(data,metadata){
			var data = TrimEnterAndWrite(data);
			metadata.attr = 'ext:qtip=' + data;

			return data;
		}
	}, {
		header: '修改后内容',
		dataIndex: 'AfterRequestContent',
		width: 180,
		sortable: true,
		//renderer: TrimEnterAndWrite
		renderer:function(data,metadata){
			var data = TrimEnterAndWrite(data);
			metadata.attr = 'ext:qtip=' + data;

			return data;
		}
	}, {
		header: '拒绝原因',
		dataIndex: 'RefuseReason',
		width: 180,
		sortable: true,
		//renderer: TrimEnterAndWrite
		renderer:function(data,metadata){
			var data = TrimEnterAndWrite(data);
			metadata.attr = 'ext:qtip=' + data;

			return data;
		}
	}
]);

var gridTB1 = new Ext.Toolbar({
    border: false,
    items: [{
        id: 'btnCommit',
        name: 'btnCommit',
        text: '<font color="red">授权选中条目</font>',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/btnConfirm.gif',
        pressed: false,
        handler: commitAppoint
    }, '-', {
        id: 'btnRefuse',
        name: 'btnRefuse',
        text: '<font color="red">拒绝选中授权</font>',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/btnClose.gif',
        pressed: false,
        handler: refuseAppoint
    }, '-', {
        id: 'btnWithdraw',
        name: 'btnWithdraw',
        text: '<font color="red">提前收回选中授权</font>',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/btnClose.gif',
        pressed: false,
        handler: withdrawAppoint
    }, '->',    //add by niucaicai 添加导出数据功能按钮  ------------------------ start
    {
        id: 'btnExport',
        name: 'btnExport',
        text: '导出该页数据到Excel',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/xls.gif',
        pressed: false,
        handler: function(){
            var grid = Ext.getCmp('dgResultGrid');
            doExport(grid, 1)
        }
    }, '-', {
        id: 'btnExportAll',
        name: 'btnExportAll',
        text: '导出所有数据到Excel',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/xlsBatch.gif',
        pressed: false,
        handler: function(){
            var grid = Ext.getCmp('dgResultGrid');
            doExport(grid, 2)
        }
    }, '-'    //add by niucaicai 添加导出数据功能按钮  ------------------------ end
    ]
});

var gridTB2 = new Ext.Toolbar({
    border: false,
    items: [{
        xtype: 'label',
        text: '默认申请时间范围'
    }, {
        id: 'cbxAppointRequestSpan',
        name: 'cbxAppointRequestSpan',
        xtype: 'combo',
        width: 70,
        store: new Ext.data.SimpleStore({
            fields: ['value', 'text'],
            data: appointRequestSpanData
        }),
        valueField: 'value',
        displayField: 'text',
        typeAhead: true,
        triggerAction: 'all',
        mode: 'local',
        editable: false,
        selectOnFocus: true,
        value: appointRequestSpan,
        listeners: {
            'select': function(){
                appointRequestSpan = Ext.getCmp('cbxAppointRequestSpan').getValue();
                var grid = Ext.getCmp('dgResultGrid');
                var s = grid.getStore();
                var link = getUrl();
                s.proxy.conn.url = link;
                s.load({
                    params: {
                        start: 0,
                        limit: pageSize
                    }
                });
            }
        }
    }, '-', {
        xtype: 'label',
        text: '默认授权类型'
    }, {
        id: 'cbxDefaultAppointType',
        name: 'cbxDefaultAppointType',
        xtype: 'combo',
        width: 70,
        store: new Ext.data.SimpleStore({
            fields: ['value', 'text'],
            data: appointTypeData
        }),
        valueField: 'value',
        displayField: 'text',
        typeAhead: true,
        triggerAction: 'all',
        mode: 'local',
        editable: false,
        selectOnFocus: true,
        value: appointType,
        listeners: {
            'select': function(){
                appointType = Ext.getCmp('cbxDefaultAppointType').getValue();
                var grid = Ext.getCmp('dgResultGrid');
                var s = grid.getStore();
                var link = getUrl();
                s.proxy.conn.url = link;
                s.load({
                    params: {
                        start: 0,
                        limit: pageSize
                    }
                });
            }
        }
    }, '-', {
        xtype: 'label',
        text: '默认授权时间'
    }, {
        id: 'cbxDefaultAppointSpan',
        name: 'cbxDefaultAppointSpan',
        xtype: 'combo',
        width: 70,
        store: new Ext.data.SimpleStore({
            fields: ['value', 'text'],
            data: [['1', '1小时'], ['2', '2小时'], ['5', '5小时'], ['10', '10小时'], ['24', '24小时'], ['48', '48小时'], ['72', '72小时'], ['168', '1周']]
        }),
        valueField: 'value',
        displayField: 'text',
        typeAhead: true,
        triggerAction: 'all',
        mode: 'local',
        editable: false,
        selectOnFocus: true,
        value: appointSpan,
        listeners: {
            'select': function(){
                appointSpan = Ext.getCmp('cbxDefaultAppointSpan').getValue();
                var grid = Ext.getCmp('dgResultGrid');
                var s = grid.getStore();
                var link = getUrl();
                s.proxy.conn.url = link;
                s.load({
                    params: {
                        start: 0,
                        limit: pageSize
                    }
                });
            }
        }
    }]
});

var grid = new Ext.grid.EditorGridPanel({
    id: 'dgResultGrid',
    layout: 'fit',
    store: store,
    cm: cm,
    sm: sm,
    name: '病历授权查询结果', // add by niucaicai 导出结果时作为sheet名字
	plugins: [
		expander,
		WithdrawcheckColumn
	],
	stopPropagation:true,
    forceFit: true,
    autoScroll: true,
    frame: true,
    editable: true,
    enableColumnMove: true,
    enableColumnResize: true,
    loadMask: {
        msg: '数据正在加载中……'
    },
    clickToEdit: 1,
    viewConfig: {
        columnsText: '显示的列',
        sortAscText: '升序',
        sortDescText: '降序'
    },
    tbar: gridTB1,
    listeners: {
	    'rowclick': function(g,index,e){
			gridRowClick(g,index,e);
		},
		'rowcontextmenu': function(g,index,e){
			rightClickFn(g,index,e);
		},
		'headerclick': function(g, columnId, e){
			gridHeaderClick(g, columnId, e);
		},
        'render': function(){
            gridTB2.render(this.tbar);
        }
    },
    bbar: new Ext.PagingToolbar({
        id: "eprPagingToolbar",
        store: store,
        pageSize: pageSize,
        displayInfo: true,
        displayMsg: '第 {0} 条到  {1} 条, 一共 {2} 条',
        beforePageText: '当前页',
        afterPageText: '总页数{0}',
        firstText: '首页',
        prevText: '上一页',
        nextText: '下一页',
        lastText: '末页',
        refreshText: '刷新',
        emptyMsg: "没有记录",
        items: ['-', {
            xtype: 'label',
            text: '每页显示'
        }, {
            id: 'cbxPageSize',
            name: 'cbxPageSize',
            xtype: 'combo',
            width: 50,
            readOnly: true,
            editable: false,
            store: new Ext.data.SimpleStore({
                fields: ['id', 'name'],
                data: [['5', '5'], ['10', '10'], ['20', '20'], ['50', '50']]
            }),
            mode: 'local',
            displayField: 'name',
            valueField: 'id',
            triggerAction: 'all',
            selectOnFocus: true,
            emptyText: '请选择每页条目数',
            value: pageSize,
            listeners: {
                'select': function(){
                    pageSize = Ext.getCmp('cbxPageSize').getValue();
                    var grid = Ext.getCmp('dgResultGrid');
                    Ext.getCmp('eprPagingToolbar').pageSize = pageSize;
                    var s = grid.getStore();
                    var link = getUrl();
                    s.proxy.conn.url = link;
                    s.load({
                        params: {
                            start: 0,
                            limit: pageSize
                        }
                    });
                }
            }
        }, {
            xtype: 'label',
            text: '条记录'
        }]
    })
});

var link = getUrl();
store.proxy.conn.url = link;
store.load({
    params: {
        start: 0,
        limit: pageSize
    }
});

var detailProperty = new Ext.form.FormPanel({
    id: 'detailProperty',
    lableWidth: 60,
    labelAlign: 'right',
    frame: true,
    autoScroll: true,
    width: 250,
    bodyStyle: 'padding:5px 5px 0',
    items: [{
        xtype: 'fieldset',
        id: 'fsRange',
        labelWidth: 0,
        title: '申请操作',
        collapsible: true,
        autoHeight: true,
        width: 250,
		height: 300,
        defaultType: 'checkbox'
	},{
        id: 'fsReason',
        xtype: 'fieldset',
        labelWidth: 0,
        title: '申请原因',
        collapsible: true,
        autoHeight: true,
        width: 250,
        labelAlign: 'top',
        labelWidth: 200,
        items: [{
            xtype: 'textarea',
            id: 'taRequestReason',
            fieldLabel: '申请的原因',
            enable: false,
            readOnly: true,
            style: 'border:0px;background:#dfe8f6',
            grow: true,
            preventScrollbars: true,
            allowBank: false,
            width: 200,
            height: 35,
            maxLength: 1000
        }, {
            xtype: 'textarea',
            id: 'taBeforeRequestContent',
            fieldLabel: '修改前内容',
            enable: false,
            readOnly: true,
            style: 'border:0px;background:#dfe8f6',
            grow: true,
            preventScrollbars: true,
            allowBank: false,
            width: 200,
            height: 35,
            maxLength: 1000
        }, {
            xtype: 'textarea',
            id: 'taAfterRequestContent',
            fieldLabel: '修改后内容',
            enable: false,
            readOnly: true,
            style: 'border:0px;background:#dfe8f6',
            grow: true,
            preventScrollbars: true,
            allowBank: false,
            width: 200,
            height: 35,
            maxLength: 1000
        }]
    }]
});

var frmMainContent = new Ext.Viewport({
    id: 'vpEPRIntegratedAuthorization',
    layout: 'border',
    shim: false,
    animCollapse: false,
    constrainHeader: true,
    collapsible: true,
    margins: '0 0 0 0',
    border: true,
    resizable: false,
    bodyStyle: 'position:relative',
    items: [{
        id: 'north',
        region: 'north',
        title: '病历授权',
        height: 197,     //ie11为177显示正好，但是ie8需要197
        width:'100%',
        autoScroll: true,
        border: true,
        split: false,
        collapsible: true,
        layout: 'fit',
        items: formQueryCondition
    }, {
        id: 'center',
        region: 'center',
        layout: 'fit',
        border: true,
        split: false,
        collapsible: true,
        autoScroll: true,
        items: grid
    }, {
        id: 'east',
        region: 'east',
        layout: 'fit',
        title: '属性',
        width: 300,
        border: true,
        split: false,
        collapsible: true,
        autoScroll: true,
        items: detailProperty
    }]
});
