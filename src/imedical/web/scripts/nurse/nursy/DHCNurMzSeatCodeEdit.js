/**
 * @author Qse
 */
var myId = "";

var generateFun = function(loc){
    Ext.QuickTips.init();
    // pre-define fields in the form
    var locField = new Ext.form.ComboBox({
        id: 'locsys1',
        hiddenName:'loc2', 
        store: loc,
        width: 100,
        fieldLabel: '科室',
        valueField: 'loc',
        displayField: 'locdes',
		labelSeparator :'', 
        allowBlank: true,
        mode: 'local',
        anchor: '80%',
		listeners: {
			focus: {
				fn: function (e) {
					e.expand();
					this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				// 在文本框内输入拼音时，根据store内code进行过滤，在下拉列表中只显示拼音匹配的选项
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
					combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.get('locdes'));
						return regExp.test(text) | regExp.test(record.data[me.displayField])
					});
					combo.expand();
					combo.select(0, true);// 将光标默认指向下拉列表的第一项，这样在取到合适的选项时，通过上下方向键和回车就可以选中需要的结果
					return false;
				}
			}
		}
		
    });
    
    var StartX = new Ext.form.TextField({
        id: 'StartX',
        fieldLabel: '起始X坐标',
		labelSeparator :'', 
        blankText: "",
        allowBlank: true,
        anchor: '80%'
    });

    var StartY = new Ext.form.TextField({
        id: 'StartY',
        fieldLabel: '起始Y坐标',
		labelSeparator :'', 
        blankText: "",
        allowBlank: true,
        anchor: '80%'
    });

    var SeatWidth = new Ext.form.TextField({
        id: 'SeatWidth',
        fieldLabel: '宽',
		labelSeparator :'', 
        blankText: "",
        allowBlank: true,
        anchor: '80%'
    });
    
    var SeatHeight = new Ext.form.TextField({
        id: 'SeatHeight',
        fieldLabel: '高',
		labelSeparator :'', 
        blankText: "",
        allowBlank: true,
        anchor: '80%'
    });

    var SeatHint = new Ext.form.TextField({
        id: 'SeatHint',
        fieldLabel: '间隔',
		labelSeparator :'', 
        blankText: "",
        allowBlank: true,
        anchor: '80%'
    });

    var columnCount = new Ext.form.TextField({
        id: 'columnCount',
        fieldLabel: '列数',
		labelSeparator :'', 
        blankText: "",
        allowBlank: true,
        anchor: '80%'
    });

    var seatCount = new Ext.form.TextField({
        id: 'seatCount',
        fieldLabel: '生成座位数',
		labelSeparator :'', 
        blankText: "",
        allowBlank: true,
        anchor: '80%'
    });

    var seatDesc = new Ext.form.TextField({
        id: 'seatDesc',
        fieldLabel: '座位描述',
		labelSeparator :'', 
        blankText: "",
        allowBlank: true,
        anchor: '80%'
    });

    var startCode = new Ext.form.TextField({
        id: 'startCode',
        fieldLabel: '开始代码',
		labelSeparator :'', 
        blankText: "",
        allowBlank: true,
        anchor: '80%'
    });

    var formPanel = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 90,
		labelAlign: "right",
        items: [locField, StartX, StartY, SeatWidth, SeatHeight,SeatHint,columnCount,seatCount,seatDesc,startCode]
    });

    var window = new Ext.Window({
        title: '批量生成座位',
        width: 350,
        height: 390,
        x:50,
        y:100,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: formPanel,
        buttons: [{
        		text: '生成',
				icon:'../images/uiimages/cancel_all_selected.png',
        		handler: function () {
        			generateSeat();
        			window.close();

        		}
        	}, {
        		text: '取消',
        		icon: '../images/uiimages/undo.png',
        		handler: function () {
        			window.close();
        		}
        	}
        ]
    });
    window.show();  
};

function generateSeat()
{
    var locId=Ext.get('loc2').dom.value;
    var StartX=Ext.get('StartX').dom.value;
    var StartY=Ext.get('StartY').dom.value;
    var SeatWidth=Ext.get('SeatWidth').dom.value;
    var SeatHeight=Ext.get('SeatHeight').dom.value;
    var SeatHint=Ext.get('SeatHint').dom.value;
    var columnCount=Ext.get('columnCount').dom.value;
    var seatCount=Ext.get('seatCount').dom.value;
    var seatDesc=Ext.get('seatDesc').dom.value;
    var startCode=Ext.get('startCode').dom.value;
    var a=tkMakeServerCall("User.DHCNurSySeat","generatorSeat",locId,StartX,StartY,SeatWidth,SeatHeight,SeatHint,columnCount,seatCount,seatDesc,startCode);
}

EditFun = function(grid) {
	Ext.QuickTips.init();
	// pre-define fields in the form
	//var rowObj = grid.getSelections();
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if (len < 1) {
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {

		myId = rowObj[0].get("id");
	}
	var ret = cspRunServerMethod(seatinfo, myId);
	var arr = ret.split('^');
	//	alert(arr);
	var SeatCode = new Ext.form.TextField({
		id: 'SeatCode',
		fieldLabel: '座位代码',
		blankText: "",
		allowBlank: true,
		anchor: '80%',
		value: arr[1]
	});

	var SeatName = new Ext.form.TextField({
		id: 'SeatName',
		fieldLabel: '座位名称',
		allowBlank: true,
		blankText: "",
		anchor: '80%',
		value: arr[0]
	});
	var SeatSize = new Ext.form.TextField({
		id: 'SeatSize',
		fieldLabel: '座位尺寸',
		allowBlank: true,
		blankText: "",
		anchor: '80%',
		value: arr[2]
	});
	var SeatPoint = new Ext.form.TextField({
		id: 'SeatPoint',
		fieldLabel: '位置',
		allowBlank: true,
		blankText: "",
		anchor: '80%',
		value: arr[3]
	});
	/*var SeatFlag = new Ext.form.Checkbox({
		id: 'SeatFlag',
		 boxLabel: '可用',
        checked:true,
		fieldLabel:'标志'
		});
		*/
	if (arr[4] == 'N') {
		//SeatFlag.checked=false;
	}
	// create form panel
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		//items: [ SeatCode, SeatName, SeatSize, SeatPoint,SeatFlag]
		items: [SeatCode, SeatName, SeatSize, SeatPoint]
	});
	// define window and show it in desktop
	var window = new Ext.Window({
		title: '座位',
		width: 350,
		height: 250,
		layout: 'fit',
		plain: true,
		modal: true,
		bodyStyle: 'padding:5px;',
		buttonAlign: 'center',
		items: formPanel,
		buttons: [{
			text: '保存',
			icon:'../images/websys/filesave.png',
			handler: function() {
				editSeat();
				window.close();
			}
		}, {
			text: '取消',
			icon:'../images/uiimages/undo.png',
			handler: function() {
				window.close();
			}
		}]
	});
	window.show();
}
AddFun = function(loc) {
	Ext.QuickTips.init();
	// pre-define fields in the form
	var locField = new Ext.form.ComboBox({
		id: 'locsys',
		hiddenName: 'loc1',
		store: loc,
		fieldLabel: '科室',
		labelSeparator :'', 
		valueField: 'loc',
		displayField: 'locdes',
		allowBlank: true,
		mode: 'local',
		anchor: '90%',
		listeners: {
			focus: {
				fn: function (e) {
					e.expand();
					this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				// 在文本框内输入拼音时，根据store内code进行过滤，在下拉列表中只显示拼音匹配的选项
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
					combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.get('locdes'));
						return regExp.test(text) | regExp.test(record.data[me.displayField])
					});
					combo.expand();
					combo.select(0, true);// 将光标默认指向下拉列表的第一项，这样在取到合适的选项时，通过上下方向键和回车就可以选中需要的结果
					return false;
				}
			}
		}
	});
	var SeatCode = new Ext.form.TextField({
		id: 'SeatCode',
		fieldLabel: '座位代码',
		labelSeparator :'', 
		blankText: "",
		allowBlank: true,
		anchor: '90%'
	});

	var SeatName = new Ext.form.TextField({
		id: 'SeatName',
		fieldLabel: '座位名称',
		labelSeparator :'', 
		allowBlank: true,
		blankText: "",
		anchor: '90%'
	});
	var SeatSize = new Ext.form.TextField({
		id: 'SeatSize',
		fieldLabel: '座位尺寸',
		labelSeparator :'', 
		allowBlank: true,
		blankText: "",
		anchor: '90%',
		value: 50
	});
	var SeatPoint = new Ext.form.TextField({
		id: 'SeatPoint',
		fieldLabel: '位置',
		labelSeparator :'', 
		allowBlank: true,
		blankText: "",
		anchor: '90%'
	});
	/*	var SeatFlag = new Ext.form.Checkbox({
		id: 'SeatFlag',
		boxLabel: '可用',
        checked:true,
		fieldLabel:'标志'
 	});*/

	// create form panel
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		labelAlign: "right",
		labelSeparator :'', 
		//items: [locField, SeatCode, SeatName, SeatSize, SeatPoint,SeatFlag]
		items: [locField, SeatCode, SeatName, SeatSize, SeatPoint]
	});
	// define window and show it in desktop
	var window = new Ext.Window({
		title: '座位',
		width: 350,
		height: 250,
		layout: 'fit',
		plain: true,
		modal: true,
		bodyStyle: 'padding:5px;',
		buttonAlign: 'center',
		items: formPanel,
		buttons: [{
			text: '保存',
			icon:'../images/websys/filesave.png',
			handler: function() {
				SaveSeat();
				window.close();

			}
		}, {
			text: '取消',
			icon:'../images/uiimages/undo.png',
			handler: function() {
				window.close();
			}
		}]
	});
	window.show();
};

function editSeat() {
	//alert( Ext.get("loc").dom.value);
	var loc = "";
	var loc = Ext.get("loc").dom.value;
	var code = Ext.get("SeatCode").dom.value;
	var name = Ext.get("SeatName").dom.value;
	var size = Ext.get("SeatSize").dom.value;
	var point = Ext.get("SeatPoint").dom.value;
	var flag = "Y";

	//if (Ext.get("SeatFlag").dom.checked) flag="Y";
	//else flag ="N";
	var parr = myId + "^" + loc + "^" + code + "^" + name + "^" + size + "^" + point + "^" + flag;
	var ret=cspRunServerMethod(savecode, parr);
	if(ret!="0") {
		alert(ret);
		return;
	}	
	find(loc);
	var lnk = "dhcnursyseatmap.csp?&loc=" + Ext.get("loc").dom.value;
	parent.frames['RPbottom'].location.href = lnk;
}

function SaveSeat() {
	// alert( Ext.get("loc1").dom.value);
	var loc = Ext.get("loc1").dom.value;
	var code = Ext.get("SeatCode").dom.value;
	var name = Ext.get("SeatName").dom.value;
	var size = Ext.get("SeatSize").dom.value;
	var point = Ext.get("SeatPoint").dom.value;
	var flag = "Y";

	//if (Ext.get("SeatFlag").dom.checked) flag="Y";
	//else flag ="N";
	var parr = "^" + loc + "^" + code + "^" + name + "^" + size + "^" + point + "^" + flag;
	var ret=cspRunServerMethod(savecode, parr);
	if(ret!="0") {
		alert(ret);
		return;
	}
	find(loc);
	var lnk = "dhcnursyseatmap.csp?&loc=" + Ext.get("loc").dom.value;
	parent.frames['RPbottom'].location.href = lnk;

}