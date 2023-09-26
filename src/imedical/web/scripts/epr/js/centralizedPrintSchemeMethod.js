//变量声明********************************************
var selectNode;

var schemeName = "";
var schemeDesc = "";
var schemeItems = "";

var recordIds = new Array();
var selectSchemeID = "";

var currentBC = "#ffff00";
var pdfBC = "#0000ff";
var bothBC = "#00ff00";
var warnBC = "#FFFF00";

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

//方案表格，点击行事件，加载点击方案对应的方案树，设置当前方案id
function gridRowClick(g, index, e){
	var record = g.getStore().getAt(index);
	var schemeID = record.data['SchemeID'];
	var schemeName = record.data['SchemeName'];
	var schemeDesc = record.data['SchemeDesc'];
	
	//记录当前选中的方案id
	Ext.getCmp('currentSchemeID').setValue(schemeID);
	selectSchemeID = schemeID;
	
	//设置为当前选择方案的方案名和方案描述
	Ext.getCmp('schemeName').setValue(schemeName);
	Ext.getCmp('schemeDesc').setValue(schemeDesc);
	
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
		if((store.getAt(i).data['IsDefault'] == "yes") && (store.getAt(i).data['IsPDF'] != "yes")){
			var columnCount = grid.getColumnModel().getColumnCount();
			for (var j = 0; j < columnCount; j++) {
				grid.getView().getCell(i, j).style.backgroundColor = currentBC;
			}
		}
		else if((store.getAt(i).data['IsDefault'] != "yes") && (store.getAt(i).data['IsPDF'] == "yes")) 
		{
			var columnCount = grid.getColumnModel().getColumnCount();
			for (var j = 0; j < columnCount; j++) {
				grid.getView().getCell(i, j).style.backgroundColor = pdfBC;
			}			
		}
		else if((store.getAt(i).data['IsDefault'] == "yes") && (store.getAt(i).data['IsPDF'] == "yes")) 
		{
			var columnCount = grid.getColumnModel().getColumnCount();
			for (var j = 0; j < columnCount; j++) {
				grid.getView().getCell(i, j).style.backgroundColor = bothBC;
			}	
		}
	}
}

//方案表格，添加新方案
function addScheme(){
	//获取方案名称
	if(typeof(Ext.getCmp('schemeName'))== "undefined" || Ext.getCmp('schemeName').getValue() == ""){
		schemeName = "";
	}
	else{
		schemeName = Ext.getCmp('schemeName').getValue();
	}
	
	//获取方案描述
	if(typeof(Ext.getCmp('schemeDesc'))== "undefined" || Ext.getCmp('schemeDesc').getValue() == ""){
		schemeDesc = "";
	}
	else{
		schemeDesc = Ext.getCmp('schemeDesc').getValue();
	}
	
	//ajax保存方案
	Ext.Ajax.request({
		url: '../web.eprajax.CentralizedPrintScheme.cls',
		timeout: 5000,
		methode: 'POST',
		params: {
			Action: "addscheme",
			SchemeName: schemeName,
			SchemeDesc: schemeDesc,
			UserID: userID
		},
		success: function(response, opts){
			//debugger;
			if (response.responseText == "-1") {
				Ext.MessageBox.alert('操作提示', "保存方案失败");
			}
			else {
				var newSchemeID = response.responseText;
				//设置当前方案id
				Ext.getCmp('currentSchemeID').setValue(newSchemeID);
				selectSchemeID = newSchemeID;
				
				var s = Ext.getCmp('schemeEditGrid').getStore();
				s.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=loadschemeitems&SchemeID='+newSchemeID+'&EpisodeID='+ episodeID + '&UserID=' + userID;
				s.load();
				
				var ss = Ext.getCmp('schemeGrid').getStore();
				ss.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=getscheme&EpisodeID='+ episodeID + '&UserID=' + userID;
				ss.load();

			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("提示", response.responseText);
		}
	});	
}

//修改方案名称，描述
function modifyScheme(){
	var schemeName = Ext.getCmp('schemeName').getValue();
	var schemeDesc = Ext.getCmp('schemeDesc').getValue();
	var schemeID = Ext.getCmp('currentSchemeID').getValue();
	if (schemeID == "") {
		Ext.MessageBox.alert("提示", "请先选择一个方案");
	}
	else {
		//ajax 修改方案名称描述
		Ext.Ajax.request({
			url: '../web.eprajax.CentralizedPrintScheme.cls',
			timeout: 5000,
			params: {
				Action: "modifyscheme",
				SchemeID: schemeID,
				SchemeName: schemeName,
				SchemeDesc: schemeDesc,
				UserID: userID
			},
			success: function(response, opts) {
				//debugger;
				if (response.responseText == "nopower") {
					Ext.MessageBox.alert("提示", "无修改方案权限");
				}
				else if (response.responseText != "-1") {
					//方案名称和描述改成现在的
					var strs = new Array();
					strs = response.responseText.split("^");
					Ext.getCmp('currentSchemeID').setValue(strs[0]);
					Ext.getCmp('schemeName').setValue(strs[1]);
					Ext.getCmp('schemeDesc').setValue(strs[2]);
					selectSchemeID = strs[0];
					
					var ss = Ext.getCmp('schemeGrid').getStore();
					ss.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=getscheme&EpisodeID=' + episodeID + '&UserID=' + userID;
					ss.load();
				}
				else
				{
					Ext.MessageBox.alert("提示", "修改方案失败");
				}

			},
			failure: function(response, opts) {
				Ext.MessageBox.alert("提示",response.responseText);
			}
		});	
	}
}

//方案表格，删除方案
function deleteScheme(){
	//删除确认窗口
	Ext.MessageBox.confirm("删除方案","确定删除所选方案？",function(btn){
		if (btn == 'yes') {
			//获取所选行，形式：所选行方案ID串，用^分隔
			var grid = Ext.getCmp('schemeGrid');
			var selectedRows = grid.getSelectionModel().getSelections();
			var IDs = "";
			if (selectedRows.length > 0) {
				for (var i = 0; i < selectedRows.length; i++) {
					var row = selectedRows[i];
					//SchemeID
					var ID = row.get('SchemeID');
					if (i > 0) {
						IDs = IDs + "^";
					}
					IDs = IDs + ID;
				}
			}
			
			//ajax 删除方案操作
			Ext.Ajax.request({
				url: '../web.eprajax.CentralizedPrintScheme.cls',
				timeout: 5000,
				params: {
					Action: "deletescheme",
					SchemeIDs: IDs,
					UserID: userID
				},
				success: function(response, opts){
					//debugger;
					if (response.responseText == "nopower") {
						Ext.MessageBox.alert("提示", "无删除权限");
					}
					else 
						if (response.responseText != "-1") {
							//成功，删除成功更新表格
							//方案名称和描述改成现在的
							var strs = new Array();
							strs = response.responseText.split("^");
							Ext.getCmp('currentSchemeID').setValue(strs[0]);
							Ext.getCmp('schemeName').setValue(strs[1]);
							Ext.getCmp('schemeDesc').setValue(strs[2]);
							selectSchemeID = strs[0];
							//加载方案包含项目表格
							var s = Ext.getCmp('schemeEditGrid').getStore();
							s.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=loaddefault&EpisodeID=' + episodeID + '&UserID=' + userID;
							s.load();
							
							var ss = Ext.getCmp('schemeGrid').getStore();
							ss.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=getscheme&EpisodeID=' + episodeID + '&UserID=' + userID;
							ss.load();
						}
						else {
							Ext.MessageBox.alert("提示", "删除失败");
						}
					
				},
				failure: function(response, opts){
					Ext.MessageBox.alert("提示", response.responseText);
				}
			});
		}
	});
}

function setDefaultPDF()
{
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
				Action: "setdefaultpdf",
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

function addItem(){
	var schemeID = Ext.getCmp('currentSchemeID').getValue();
	if (schemeID == "") {
		Ext.MessageBox.alert("提示", "请先选择一个方案");
	}
	else {
		var win1 = new Ext.Window({
			id: 'addItemWin',
			layout: 'fit', // 自动适应Window大小
			width: 1000,
			height: 600,
			title: '增加打印项目',
			closeAction: 'hide',
			animateTarget: 'btnAddItem',
			// raggable: true, 		//不可拖动
			modal: true, //遮挡后面的页面
			resizable: true, // 重置窗口大小
			html: '<iframe id="frmScheme" style="width:100%; height:100%" src="dhc.epr.centralizedprinttree.csp?PatientID=' +
			patientID +
			'&EpisodeID=' +
			episodeID +
			'"></iframe>'
		});
		
		win1.show();
		
		//关闭时重载打印选项表格
		win1.on('hide', function(){
			//加载方案包含项目表格
			var schemeEditGrid = Ext.getCmp('schemeEditGrid');
			var schemeEditStore = schemeEditGrid.getStore();
			schemeEditStore.load();
		});
		
		win1.on('close', function(){
			//加载方案包含项目表格
			var schemeEditGrid = Ext.getCmp('schemeEditGrid');
			var schemeEditStore = schemeEditGrid.getStore();
			schemeEditStore.load();
		});
	}
}

function deleteItem(){
	//删除确认窗口
	Ext.MessageBox.confirm("删除打印项目","确定删除所选打印项目？",function(btn){
		if (btn == 'yes') {
			var schemeID = Ext.getCmp('currentSchemeID').getValue();
			//获取所选行，形式：所选行方案ID串，用^分隔
			var grid = Ext.getCmp('schemeEditGrid');
			var selectedRows = grid.getSelectionModel().getSelections();
			var IDs = "";
			if (selectedRows.length > 0) {
				for (var i = 0; i < selectedRows.length; i++) {
					var row = selectedRows[i];
					
					var ID = row.get('id');
					if (i > 0) {
						IDs = IDs + "^";
					}
					IDs = IDs + ID;
				}
			}
			
			//ajax 删除方案操作
			Ext.Ajax.request({
				url: '../web.eprajax.CentralizedPrintScheme.cls',
				timeout: 5000,
				params: {
					Action: "deleteitems",
					ItemIDs: IDs,
					UserID: userID,
					SchemeID: schemeID
				},
				success: function(response, opts){
					//debugger;
					if (response.responseText == "1") {
						//成功，删除成功更新表格
						//加载方案包含项目表格
						var s = Ext.getCmp('schemeEditGrid').getStore();
						s.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=loadschemeitems&SchemeID=' + schemeID + '&EpisodeID=' + episodeID + '&UserID=' + userID;
						s.load();
					}
					//没有删除权限
					else 
						if (response.responseText == "nopower") {
							Ext.MessageBox.alert("提示", "无删除权限");
						}
				},
				failure: function(response, opts){
					Ext.MessageBox.alert("提示", response.responseText);
				}
			});
		}	
	});	
}

function moveUpItem(){
	var schemeID = Ext.getCmp('currentSchemeID').getValue();
	//获取所选行，形式：所选行方案ID串，用^分隔
	var grid = Ext.getCmp('schemeEditGrid');
	var selectedRows = grid.getSelectionModel().getSelections();
	var IDs = "";
	var flag = false;
	if (selectedRows.length > 0) {
		for (var i = 0; i < selectedRows.length; i++) {
			var row = selectedRows[i];
			
			var ID = row.get('id');
			var order = row.get('order');
			if (order == "1") {
				flag = true;
				break;
			}
			
			if (i > 0) {
				IDs = IDs + "^";
			}
			IDs = IDs + ID;
		}
	}
	if (flag == true) {
		grid.getView().refresh();
		var columnCount = grid.getColumnModel().getColumnCount();
		for (var i = 0; i < columnCount; i++) {
			grid.getView().getCell(0, i).style.backgroundColor = warnBC;
		}
		changeRowBackgroundColor(grid);
		Ext.getCmp('status').setText('<font color="#FF0000">所选选项已经是第一项</font>');
	}
	else {
		//ajax 
		Ext.Ajax.request({
			url: '../web.eprajax.CentralizedPrintScheme.cls',
			timeout: 5000,
			params: {
				Action: "moveup",
				ItemIDs: IDs,
				UserID: userID,
				SchemeID: schemeID
			},
			success: function(response, opts){
				//debugger;
				if (response.responseText == "nopower") {
					Ext.MessageBox.alert("提示", "无操作权限");
				}
				else 
					if (response.responseText != "-1") {
						//加载方案包含项目表格
						var items = response.responseText;
						recordIds = items.split("^");
						//加载方案包含项目表格
						var schemeID = Ext.getCmp('currentSchemeID').getValue();
						var s = Ext.getCmp('schemeEditGrid').getStore();
						s.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=loadschemeitems&SchemeID=' + schemeID + '&EpisodeID=' + episodeID + '&UserID=' + userID;
						s.load();	
					}
					else {
						Ext.MessageBox.alert("提示", "移动出错");
					}
				
			},
			failure: function(response, opts){
				Ext.MessageBox.alert("提示", response.responseText);
			}
		});
	}
}

function moveDownItem(){
	var schemeID = Ext.getCmp('currentSchemeID').getValue();
	//获取所选行，形式：所选行方案ID串，用^分隔
	var grid = Ext.getCmp('schemeEditGrid');
	var selectedRows = grid.getSelectionModel().getSelections();
	var IDs = "";
	var flag = false;
	var total = grid.getStore().getTotalCount();
	if (selectedRows.length > 0) {
		for (var i = 0; i < selectedRows.length; i++) {
			var row = selectedRows[i];
				
			var ID = row.get('id');
			var order = row.get('order');
			if (order == total){
				flag = true;
			}
			
			if(i>0){
				IDs = IDs + "^";
			}
			IDs = IDs + ID;
		}
	}	
	if (flag == true) {
		grid.getView().refresh();
		var columnCount = grid.getColumnModel().getColumnCount();
		for (var i = 0; i < columnCount; i++) {
			grid.getView().getCell(total - 1, i).style.backgroundColor = warnBC;
		}
		changeRowBackgroundColor(grid);
		Ext.getCmp('status').setText('<font color="#FF0000">所选选项已经是最后一项</font>');
	}
	else {
		//ajax 
		Ext.Ajax.request({
			url: '../web.eprajax.CentralizedPrintScheme.cls',
			timeout: 5000,
			params: {
				Action: "movedown",
				ItemIDs: IDs,
				UserID: userID,
				SchemeID: schemeID
			},
			success: function(response, opts){
				//debugger;
				if (response.responseText == "nopower") {
					Ext.MessageBox.alert("提示", "无操作权限");
				}
				else if (response.responseText != "-1") {
					var items = response.responseText;
					recordIds = items.split("^");
					//加载方案包含项目表格
					var schemeID = Ext.getCmp('currentSchemeID').getValue();
					var s = Ext.getCmp('schemeEditGrid').getStore();
					s.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=loadschemeitems&SchemeID=' + schemeID + '&EpisodeID=' + episodeID + '&UserID=' + userID;
					s.load();					
				}
				else{
					Ext.MessageBox.alert("提示", "移动出错");
				}

			},
			failure: function(response, opts){
				Ext.MessageBox.alert("提示", response.responseText);
			}
		});
	}
}

function moveTop(){
	var schemeID = Ext.getCmp('currentSchemeID').getValue();
	//获取所选行，形式：所选行方案ID串，用^分隔
	var grid = Ext.getCmp('schemeEditGrid');
	var selectedRows = grid.getSelectionModel().getSelections();
	var IDs = "";
	var flag = false;
	if (selectedRows.length > 0) {
		for (var i = 0; i < selectedRows.length; i++) {
			var row = selectedRows[i];
			
			var ID = row.get('id');
			var order = row.get('order');
			if (order == "1") {
				flag = true;
				break;
			}
			
			if (i > 0) {
				IDs = IDs + "^";
			}
			IDs = IDs + ID;
		}
	}
	if (flag == true) {
		grid.getView().refresh();
		var columnCount = grid.getColumnModel().getColumnCount();
		for (var i = 0; i < columnCount; i++) {
			grid.getView().getCell(0, i).style.backgroundColor = warnBC;
		}
		changeRowBackgroundColor(grid);
		Ext.getCmp('status').setText('<font color="#FF0000">所选选项已经是第一项</font>');
	}
	else {
		//ajax 
		Ext.Ajax.request({
			url: '../web.eprajax.CentralizedPrintScheme.cls',
			timeout: 5000,
			params: {
				Action: "movetop",
				ItemIDs: IDs,
				UserID: userID,
				SchemeID: schemeID
			},
			success: function(response, opts){
				//debugger;
				if (response.responseText == "nopower") {
					Ext.MessageBox.alert("提示", "无操作权限");
				}
				else 
					if (response.responseText != "-1") {
						//加载方案包含项目表格
						var items = response.responseText;
						recordIds = items.split("^");
						//加载方案包含项目表格
						var schemeID = Ext.getCmp('currentSchemeID').getValue();
						var s = Ext.getCmp('schemeEditGrid').getStore();
						s.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=loadschemeitems&SchemeID=' + schemeID + '&EpisodeID=' + episodeID + '&UserID=' + userID;
						s.load();	
					}
					else {
						Ext.MessageBox.alert("提示", "移动出错");
					}
				
			},
			failure: function(response, opts){
				Ext.MessageBox.alert("提示", response.responseText);
			}
		});
	}	
}

function moveBottom(){
	var schemeID = Ext.getCmp('currentSchemeID').getValue();
	//获取所选行，形式：所选行方案ID串，用^分隔
	var grid = Ext.getCmp('schemeEditGrid');
	var selectedRows = grid.getSelectionModel().getSelections();
	var IDs = "";
	var flag = false;
	var total = grid.getStore().getTotalCount();
	if (selectedRows.length > 0) {
		for (var i = 0; i < selectedRows.length; i++) {
			var row = selectedRows[i];
				
			var ID = row.get('id');
			var order = row.get('order');
			if (order == total){
				flag = true;
			}
			
			if(i>0){
				IDs = IDs + "^";
			}
			IDs = IDs + ID;
		}
	}	
	if (flag == true) {
		grid.getView().refresh();
		var columnCount = grid.getColumnModel().getColumnCount();
		for (var i = 0; i < columnCount; i++) {
			grid.getView().getCell(total - 1, i).style.backgroundColor = warnBC;
		}
		changeRowBackgroundColor(grid);
		Ext.getCmp('status').setText('<font color="#FF0000">所选选项已经是最后一项</font>');
	}
	else {
		//ajax 
		Ext.Ajax.request({
			url: '../web.eprajax.CentralizedPrintScheme.cls',
			timeout: 5000,
			params: {
				Action: "movebottom",
				ItemIDs: IDs,
				UserID: userID,
				SchemeID: schemeID
			},
			success: function(response, opts){
				//debugger;
				if (response.responseText == "nopower") {
					Ext.MessageBox.alert("提示", "无操作权限");
				}
				else if (response.responseText != "-1") {
					var items = response.responseText;
					recordIds = items.split("^");
					//加载方案包含项目表格
					var schemeID = Ext.getCmp('currentSchemeID').getValue();
					var s = Ext.getCmp('schemeEditGrid').getStore();
					s.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=loadschemeitems&SchemeID=' + schemeID + '&EpisodeID=' + episodeID + '&UserID=' + userID;
					s.load();
				}
				else{
					Ext.MessageBox.alert("提示", "移动出错");
				}

			},
			failure: function(response, opts){
				Ext.MessageBox.alert("提示", response.responseText);
			}
		});
	}	
}

function moveUpScheme(){
	var schemeID = Ext.getCmp('currentSchemeID').getValue();
	var grid = Ext.getCmp('schemeGrid');
	//已保证是单选（表格中设置为单选）
	var selectedRows = grid.getSelectionModel().getSelections();
	var flag = false;
	if (selectedRows.length > 0) {
		var row = selectedRows[0];
		var order = row.get('Order');
		if (order == "1") {
			flag = true;
		}
	}	
	if (flag == true) {
		grid.getView().refresh();
		var columnCount = grid.getColumnModel().getColumnCount();
		for (var i = 0; i < columnCount; i++) {
			grid.getView().getCell(0, i).style.backgroundColor = warnBC;
		}
		changeRowBackgroundColor(grid);
		Ext.getCmp('status').setText('<font color="#FF0000">所选选项已经是第一项</font>');
	}
	else {
		//ajax 
		Ext.Ajax.request({
			url: '../web.eprajax.CentralizedPrintScheme.cls',
			timeout: 5000,
			params: {
				Action: "moveupscheme",
				SchemeID: schemeID
			},
			success: function(response, opts){
				//debugger;
				if (response.responseText != "-1") {
					//加载方案包含项目表格
					var s = Ext.getCmp('schemeGrid').getStore();
					s.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=getscheme&EpisodeID='+ episodeID + '&UserID=' + userID;
					s.load();					
				}
				else{
					Ext.MessageBox.alert("提示", "移动出错");
				}

			},
			failure: function(response, opts){
				Ext.MessageBox.alert("提示", response.responseText);
			}
		});
	}	
}

function moveDownScheme(){
	var schemeID = Ext.getCmp('currentSchemeID').getValue();
	var grid = Ext.getCmp('schemeGrid');
	//已保证是单选（表格中设置为单选）
	var selectedRows = grid.getSelectionModel().getSelections();
	var flag = false;
	var total = grid.getStore().getTotalCount();
	if (selectedRows.length > 0) {
		var row = selectedRows[0];
		var order = row.get('Order');
		if (order == total) {
			flag = true;
		}
	}	
	if (flag == true) {
		grid.getView().refresh();
		var columnCount = grid.getColumnModel().getColumnCount();
		for (var i = 0; i < columnCount; i++) {
			grid.getView().getCell(total - 1, i).style.backgroundColor = warnBC;
		}
		changeRowBackgroundColor(grid);
		Ext.getCmp('status').setText('<font color="#FF0000">所选选项已经是最后一项</font>');
	}
	else {
		//ajax 
		Ext.Ajax.request({
			url: '../web.eprajax.CentralizedPrintScheme.cls',
			timeout: 5000,
			params: {
				Action: "movedownscheme",
				SchemeID: schemeID
			},
			success: function(response, opts){
				//debugger;
				if (response.responseText != "-1") {
					//加载方案包含项目表格
					var s = Ext.getCmp('schemeGrid').getStore();
					s.proxy.conn.url = '../web.eprajax.CentralizedPrintScheme.cls?Action=getscheme&EpisodeID='+ episodeID + '&UserID=' + userID;
					s.load();					
				}
				else{
					Ext.MessageBox.alert("提示", "移动出错");
				}

			},
			failure: function(response, opts){
				Ext.MessageBox.alert("提示", response.responseText);
			}
		});
	}	
}
