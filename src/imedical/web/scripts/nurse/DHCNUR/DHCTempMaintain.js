/**
 * @author Administrator
 */

var ret = "";
var checkret = "";
var comboret = "";

function BodyLoadHandler() {
	setsize("TempMaintainpl", "gform", "TempMaintain");
	var butadd = Ext.getCmp('TempMaintainbut1');
	butadd.on("click", additm);
	butadd.hide();
	var butsave = Ext.getCmp('TempMaintainbut2');
	butsave.setText("保存");
	butsave.hide();
	var grid = Ext.getCmp('TempMaintain');
	var len = grid.getColumnModel().getColumnCount();
		for(var i = 0 ;i < len;i++){
			if(grid.getColumnModel().getDataIndex(i) == 'id'){
				grid.getColumnModel().setHidden(i,true);
			}
		}
	grid.getBottomToolbar().hide();

	var tobar = grid.getTopToolbar();


	tobar.addItem( {
		xtype: 'checkbox',
		id: 'mygridNWFlag',
		value: (true)
	},'内科');

	tobar.addItem('-');
	tobar.addButton({
			//className: 'new-topic-button',
			text: "增加",
			icon:'../images/uiimages/edit_add.png',
			handler: additm,
			id: 'additmBut'
		}
	);
	tobar.addItem('-');
	tobar.addButton({
			//className: 'new-topic-button',
			text: "保存",
			icon:'../images/uiimages/filesave.png',
			handler: savegrid,
			id: 'savegridBut'
		});
	tobar.addItem('-');
	tobar.addButton({
			//className: 'new-topic-button',
			text: "查询",
			icon:'../images/uiimages/search.png',
			handler: find,
			id: 'mygridSch'
		});
	tobar.addItem('-');
	tobar.addButton({
		//className: 'new-topic-button',
		text: "删除",
		icon:'../images/uiimages/edit_remove.png',
		handler: Delete,
		id: 'mygridDelete'
	});
	tobar.addItem('-');
	var butsch = Ext.getCmp('mygridSch');
	butsch.on("click", setgrid)

	butsave.on("click", savegrid);
	setgrid();

}

var timField = new Ext.form.ComboBox({
	id: 'mygridttime',
	hiddenName: 'mygridttime1',
	//store : storetim,
	width: 150,
	fieldLabel: '固定时间',
	valueField: 'idv',
	displayField: 'des',
	triggerAction: 'all',
	allowBlank: true,
	mode: 'local',
	anchor: '100%'
});
timField.on('select', function() {
	find();
});

function diffDate(val, addday) {
	var year = val.getFullYear();
	var mon = val.getMonth();
	var dat = val.getDate() + addday;
	var datt = new Date(year, mon, dat);
	return formatDate(datt);
}

function find() {
	setgrid();
}

function cmbkey(field, e) {
	if (e.getKey() == Ext.EventObject.ENTER) {
		var pp = field.lastQuery;
		getlistdata(pp, field);
		//	alert(ret);

	}
}
var person = new Array();

function getlistdata(p, cmb) {
	var GetPerson = document.getElementById('GetPerson');
	//debugger;
	var ret = cspRunServerMethod(GetPerson.value, p);
	if (ret != "") {
		var aa = ret.split('^');
		for (i = 0; i < aa.length; i++) {
			if (aa[i] == "") continue;
			var it = aa[i].split('|');
			addperson(it[1], it[0]);
		}
		//debugger;
		cmb.store.loadData(person);
	}
}

function addperson(a, b) {
	person.push({
		desc: a,
		id: b
	});
}

function savegrid() {
	var grid = Ext.getCmp("TempMaintain");
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();

	var list = [];
	//for (var i = 0; i < store.getCount(); i++) {
	//	list.push(store.getAt(i).data);
	//	//debugger;
	//}
	var nwcheck = Ext.getCmp("mygridNWFlag");
	var flag = nwcheck.getValue();
	if (nwcheck.getValue() == true) flag = "M";
	else flag = "O";

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	var SaveOpCheck = document.getElementById('SaveOpCheck');

	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		var str = "";
		var CareDate = "";
		var CareTime = "";
		for (var p in obj) {
			var aa = formatDate(obj[p]);
			if (p == "") continue;
			//str = str + p + "|" + obj[p] + '^';
			if (aa == "") {
				str = str + p + "|" + obj[p] + '^';
			} else {
				str = str + p + "|" + aa + '^';
			}
		}
		if (str != "") {
			if (str.indexOf("ConName") < 0) {
				alert("请填写规则名称")
				return;
			}
			str = "ConMO|" + flag + "^" + str;
			var a = cspRunServerMethod(SaveOpCheck.value, str);
			if (a != 0) {
				alert(a);
				return;
			}else{
				alert("保存成功")
			}
			setgrid();



		}
	}

}
var arrgrid = new Array();

function setgrid() {
	var grid = Ext.getCmp("TempMaintain");
	var GetQueryData = document.getElementById('GetQueryData');
	arrgrid = new Array();
	var nwcheck = Ext.getCmp("mygridNWFlag");
	var flag = nwcheck.getValue();
	if (nwcheck.getValue() == true) flag = "M";
	else flag = "O";

	var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurTempContidion:MantainTempGuize", "parr$" + flag, "AddRec");
	grid.store.loadData(arrgrid);

}

function AddRec(str) {
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	arrgrid.push(obj);
	//debugger;
}

function getDate(val) {
	var a = val.split('-');
	var dt = new Date(a[0], a[1] - 1, a[2]);
	return dt;
}


function formatDate(value) {
	// alert(value);
	try {
		return value ? value.dateFormat('Y-m-d') : '';

	} catch (err) { //err.description 
		return value;
	}
}

function enterOrTabDate(param) {
	alert(param);
}

function additm() { //alert(123)        
	//  debugger;
	var grid = Ext.getCmp('TempMaintain');
	var Plant = Ext.data.Record.create([
		// the "name" below matches the tag name to read, except "availDate"
		// which is mapped to the tag "availability"

	]);
	var count = grid.store.getCount();
	var r = new Plant();
	grid.store.commitChanges();
	grid.store.insert(count, r);
	return;
}

function Delete() {
	var TempMaintainArr = [];
	var grid = Ext.getCmp("TempMaintain");
	var store = grid.store;
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len==0){
		alert("请选中一条记录!")
		return;
	}
	for (var r = 0; r < len; r++) {
		TempMaintainArr[TempMaintainArr.length] = rowObj[r].data.id

	}
	//var ifconfirm=
	if (confirm("确定要删除记录吗?")) {
		var ret = tkMakeServerCall("Nur.DHCNurTempContidion", "DeleteRecord", TempMaintainArr.join("^"))
		if (ret == "0") {
			find();
		} else {
			alert(ret)
			return;
		}
	}
}