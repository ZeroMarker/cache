/**
 * @author Qse
 */
var flag = "1";
var datatest = new Array();
var loc = reqLoc;
cspRunServerMethod(GetSeatCode, loc, "add");

function add(a1, a2, a3, a4, a5, a6, a7, a8) {
	datatest.push({
		id: a1,
		title: a2,
		width: parseInt(a3),
		height: parseInt(a4),
		bodyStyle: a8,
		frame: true,
		x: a5,
		y: a6,
		html: a7,
		padding: '15px',
		draggable: {
			insertProxy: false,
			onDrag: function(e) {
				var pel = this.proxy.getEl();
				this.x = pel.getLeft(true);
				this.y = pel.getTop(true);
				var s = this.panel.getEl().shadow;
				if (s) {
					s.realign(this.x, this.y, pel.getWidth(), pel.getHeight());
				}
			},
			endDrag: function(e) {
				this.panel.setPosition(this.x, this.y);
				cspRunServerMethod(savecode, this.panel.id + "^" + this.x + "," + this.y);
			}
		}
	});


}

Ext.onReady(function() {
	new Ext.Viewport({
		layout: 'absolute',
		items: {
			id: "form",
			height: 200,
			width: 800,
			layout: 'absolute',
			items: datatest,
			autoScroll: true
		}
	});
	flag = "0";
	//Ext.get("p1").addListener("click",aa(Ext.get("p1")),this);  
	var fheight = document.body.offsetHeight;
	var fwidth = document.body.offsetWidth;
	Ext.getCmp("form").setHeight(fheight);
	Ext.getCmp("form").setWidth(fwidth);
	window.onresize = function() {
		var fheight = document.body.offsetHeight;
		var fwidth = document.body.offsetWidth;
		Ext.getCmp("form").setHeight(fheight);
		Ext.getCmp("form").setWidth(fwidth);
	}
})


// new Ext.Panel({
// 	renderTo:Ext.getBody(),
// 	autoScroll:true,
// 	layout: 'absolute',
// 	height:"100%",
// 	items: datatest
// });


function aa(vv) {
	var win = new Ext.Window({
		title: "窗口" + vv.id,
		width: 400,
		height: 200,
		bodyStyle: "padding:5px 5px 0",
		items: [{
			xtype: 'fieldset',
			title: '个人信息',
			collapsible: true,
			autoHeight: true,
			width: 330,
			defaults: {
				width: 150
			},
			defaultType: 'textfield',
			items: [{
				fieldLabel: '卡号',
				name: 'RegNo',
				value: ''
			}, {
				fieldLabel: '姓名',
				name: 'patname',
				value: ''
			}]
		}],
		buttons: [{
			text: "读卡"
		}, {
			text: "确定"
		}, {
			text: "取消",
			handler: function() {
				alert("事件！");
			}
		}],
		maximizable: false
	});
	win.show();
}