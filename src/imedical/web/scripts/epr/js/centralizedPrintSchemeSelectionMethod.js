//变量声明********************************************
var selectNode;

var schemeName = "";
var schemeDesc = "";
var schemeItems = "";

var recordIds = new Array();
var selectSchemeID = "";
var currentBC = "#00ff00";

//功能函数********************************************
//QuickTips
Ext.QuickTips.init();
//表格列按中文汉语拼音排序
Ext.data.Store.prototype.applySort = function(){ 
	if(this.sortInfo && !this.remoteSort){
		var s = this.sortInfo;
		var f = s.field;
		var st = this.fields.get(f).sortType;
		var fn = function(r1, r2){
			var v1 = st(r1.data[f]);
			v2 = st(r2.data[f]);
			if(typeof(v1) == "string"){
				return v1.localeCompare(v2);
			}
			return v1 > v2 ? 1 : (v1 < v2 ? -1 : 0);
		};
		this.data.sort(s.direction, fn);
		if(this.snapshot && this.snapshot != this.data){
			this.snapshot.sort(s.direction, fn);
		}
	}
};

function moveBack(){
	var win = parent.Ext.getCmp('schemeWin');
	win.hide();
}

//方案表格，点击行事件，加载点击方案对应的方案树，设置当前方案id
function gridRowClick(g, index, e){
	var record = g.getStore().getAt(index);
	var schemeID = record.data['SchemeID'];
	var schemeName = record.data['SchemeName'];
	var schemeDesc = record.data['SchemeDesc'];
	
	//记录当前选中的方案id
	Ext.getCmp('currentSchemeID').setValue(schemeID);
	selectSchemeID = schemeID;
	
	//加载方案包含项目表格
	var s = Ext.getCmp('schemeEditGrid').getStore();
	s.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=loadschemeitems&SchemeID='+schemeID+'&EpisodeID='+ episodeID + '&UserID=' + userID;
	s.load();
}

//方案表格，改变默认方案行背景色
function changeRowBackgroundColor(grid){
	var store = grid.getStore(grid);
	var total = store.getCount();
	for (var i = 0; i < total; i++) {
		if(store.getAt(i).data['IsDefault'] == "yes"){
			var columnCount = grid.getColumnModel().getColumnCount();
			for (var j = 0; j < columnCount; j++) {
				grid.getView().getCell(i, j).style.backgroundColor = currentBC;
			}
		}
	}
}

//方案表格，设置默认方案，默认方案指打印备选项目，若无默认方案，则默认为全部范围
function setDefaultScheme(){
	//获取所选行
	var grid = Ext.getCmp('schemeGrid');
	var selectedRows = grid.getSelectionModel().getSelections();
	var ID = "";
	//只能有一个默认方案，确保单选
	if (selectedRows.length != 1) {
		Ext.MessageBox.alert("提示", "请仅选择一项设为当前打印方案");
	}
	else {
		var row = selectedRows[0];
		var ID = row.get('SchemeID');
		
		//ajax 设置默认方案为所选
		Ext.Ajax.request({
			url: '../web.eprajax.CentralizedPrintScheme.cls',
			timeout: 5000,
			params: {
				Action: "setdefault",
				SchemeID: ID
			},
			success: function(response, opts){
				if (response.responseText != "-1") {
					//成功，刷新方案表格
					selectSchemeID = response.responseText
					Ext.getCmp('currentSchemeID').setValue(selectSchemeID);
					var ss = Ext.getCmp('schemeGrid').getStore();
					ss.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=getscheme&EpisodeID=' + episodeID + '&UserID=' + userID;
					ss.load();	
					//退出方案维护对话框
					Ext.MessageBox.confirm('操作提示', "设置当前打印方案成功,退出还是返回？",function(btn){
						if(btn == 'yes'){
							var win = parent.Ext.getCmp('schemeWin');
							win.hide();
						}
					});
				}
				else {
					Ext.MessageBox.alert('操作提示', "设置当前打印方案失败");
				}
			},
			failure: function(response, opts){
				Ext.MessageBox.alert("提示", response.responseText);
			}
		});
	}	
}
