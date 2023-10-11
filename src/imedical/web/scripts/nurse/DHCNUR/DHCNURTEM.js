/**
 * @author Administrator
 */
/*
 grid.store.on('load', function() {
    grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
        x.addClass('x-grid3-cell-text-visible');
    });
});

grid.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
              if(r.get('10')=='数据错误'){
                    grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
              }
              girdcount=girdcount+1;
          });
       //scope:this
       });
*/

var UserType = "";
var GetUserType = document.getElementById('GetUserType');
if (GetUserType) {
	UserType = cspRunServerMethod(GetUserType.value, session['LOGON.USERID']);
}

var findTransPatsFlag=false;
var grid;
var arrtim = new Array();
var GetQueryData = document.getElementById('GetQueryData1');
var a = cspRunServerMethod(GetQueryData.value, "web.DHCTHREEEX.GetTimePoint", "", "AddTim");
var storetim = new Ext.data.JsonStore({
	data: arrtim,
	fields: ['idv', 'des']
});

function AddTim(str) {
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	arrtim.push(obj);
	//debugger;
}

function gethead() {
	var GetHead = document.getElementById('GetHead');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	return hh[0];
	//debugger;
}
var timField = new Ext.form.ComboBox({
	id: 'mygridttime',
	hiddenName: 'mygridttime1',
	store: storetim,
	width: 150,
	fieldLabel: '固定时间',
	valueField: 'idv',
	triggerAction: 'all',
	displayField: 'des',
	allowBlank: true,
	mode: 'local',
	anchor: '100%'
});
timField.on('select', function() {
	find();
});

function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
	//fm.doLayout(); 
	grid1 = Ext.getCmp("mygrid");
	grid1.on('click', gridclick);
	grid1.getBottomToolbar().hide();
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	//but1.on('click',additm);
	var but = Ext.getCmp("mygridbut2");
	but.setIcon('../images/uiimages/filesave.png');
	but.setText("保存");
	but.on('click', save);
	var gettime = document.getElementById('getTime');
	var timindex = cspRunServerMethod(gettime.value);

	var cmbtim = Ext.getCmp("mygridttime");
	cmbtim.setValue(timindex);
	cmbtim.on("blur",function(){
		if(!findTransPatsFlag){
			find();
		}else{
			findTransPats();
		}
	})

	Ext.override(Ext.Editor, {
		onSpecialKey: function(field, e) {
			var key = e.getKey();
			this.fireEvent('specialkey', field, e);
		}
	});
	Ext.override(Ext.grid.RowSelectionModel, {
		onEditorKey: function(F, E) {
			var C = E.getKey(),
				G, D = this.grid,
				B = D.activeEditor;
			var A = E.shiftKey;
			var keyCode = E.keyCode;
			if (C == E.TAB) {
				E.stopEvent();
				B.completeEdit();
				if (A) {
					G = D.walkCells(B.row, B.col - 1, -1, this.acceptsNav,
						this);
				} else {
					G = D.walkCells(B.row, B.col + 1, 1, this.acceptsNav,
						this);
				}
			} else {
				if (C == E.ENTER) {

					E.stopEvent();

					B.completeEdit();

					save("1");
					if (this.moveEditorOnEnter !== false) {
						if (A) {
							// G = D.walkCells(B.row - 1, B.col, -1,
							// this.acceptsNav,this)
							G = D.walkCells(B.row, B.col - 1, -1,
								this.acceptsNav, this);
						} else {
							// G = D.walkCells(B.row + 1, B.col, 1,
							// this.acceptsNav,this)
							G = D.walkCells(B.row, B.col + 1, 1,
								this.acceptsNav, this);
						}
					}
				} else {
					if (C == E.ESC) {
						B.cancelEdit();

					} else {

						switch (keyCode) {
							case 39:
								G = D.walkCells(B.row, B.col + 1, 1, this.acceptsNav, this);
								break;
							case 37:
								G = D.walkCells(B.row, B.col - 1, -1, this.acceptsNav, this);
								break;
							case 40:
								G = D.walkCells(B.row + 1, B.col, 1, this.acceptsNav, this);
								break;
							case 38:
								G = D.walkCells(B.row - 1, B.col, 1, this.acceptsNav, this);
								break;
							default:
								break;
						}
					}
				}
			}
			if (G) {
				D.startEditing(G[0], G[1]);
			}
		}
	});
	var sm2 = new Ext.grid.RowSelectionModel({
		moveEditorOnEnter: true,
		singleSelect: false,
		listeners: {
			//rowselect : function(sm, row, rec) {   
			//centerForm.getForm().loadRecord(rec);   
			// }   
		}

	});


	grid = Ext.getCmp('mygrid');
	gridPreHandle(grid);
	grid.on("cellclick",setStartDay);
	//grid.setTitle(gethead());
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.addItem({
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'mygridstdate',
		value: (diffDate(new Date(), 0)),
		listeners:{
			'select':selcetDateHandler
		}
	}, timField);
	Ext.getCmp("mygridstdate").on("change",function(){
		if(!findTransPatsFlag){
			find();
		}else{
			findTransPats();
		}
	})
	tobar.addItem("-");
	tobar.addItem(
	    {
			xtype    : 'textfield',  
            id     : 'regNo',  
            emptyText: '输入登记号',
			listeners:{
				 specialkey: function(field, e){
				   if (e.getKey() == e.ENTER) {
                       find();
                    }
                }
				
			}
        }
	);
	tobar.addButton({
			className: 'new-topic-button',
			text: "查询",
			icon:'../images/uiimages/search.png',
			handler: find,
			id: 'mygridSch'
		}

	);
	tobar.addItem("-");
	tobar.addButton({
		//className: 'new-topic-button',
		text: "特殊字符",
		handler: SepcialChar,
		icon:'../images/uiimages/oplog.png',
		id: 'PrintBut'
	});
	tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "需测体温查询",
		icon:'../images/uiimages/search.png',
		handler: SchXC,
		id: 'mygridSchXC'
	});
	tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "需测身高体重",
		icon:'../images/uiimages/search.png',
		handler: SchXCSGTZ,
		id: 'mygridSchXCSGTZ'
	});
	tobar.addItem("-");
	tobar.addButton({
		//className: 'new-topic-button',
		text: "生成图片 ",
		handler: makepic,
		icon:'../images/uiimages/update.png',
		id: 'makepicBut'
	});
	tobar.addItem("-");
	tobar.addButton({
		//className: 'new-topic-button',
		text: "质控提醒",
		icon:'../images/uiimages/validatebox_warning.png',
		handler: makesure,
		id: 'makesure'
	});
	tobar.addItem("-");
	tobar.addButton({
		text: "预览",
		icon:'../images/uiimages/see.png',
		handler: temppreview,
		id: 'temppreview'
	});
	tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "在院转科病人",
		icon:'../images/uiimages/search.png',
		handler: findTransPats,
		id: 'mygridSchTransPat'
	});
	var tormorrowConfig = tkMakeServerCall("web.DHCThreeNew","getTormorrowConfig");
	if (tormorrowConfig!=""){
		tobar.addItem("-");
		tobar.addButton({
			className: 'new-topic-button',
			text: "录入明日体温",
			icon:'../images/uiimages/search.png',
			handler: findTomorrow,
			id: 'mygridSchTomorrow,'
		});
	}
	tobar.render(grid.tbar);
	tobar.doLayout();
	
	var tobarCheckbox = new Ext.Toolbar();
	selShowColumn(tobarCheckbox,grid);
	tobarCheckbox.render(grid.tbar);
	tobarCheckbox.doLayout();
	
	if (UserType == "DOCTOR") {
		if (but1) but1.hide();
		if (but) but.hide();
		var obj = Ext.getCmp("PrintBut");
		if (obj) obj.hide();
		var obj = Ext.getCmp("XPrintSet");
		if (obj) obj.hide();
	} else {
		grid.addListener('rowcontextmenu', rightClickFn);
		grid.addListener('rowclick', rowClickFn);
		grid.on('beforeedit', beforeEditFn);
	}

	Ext.QuickTips.init(); //注意，提示初始化必须要有
	grid.getStore().on('load', function(s, records) {
		var girdcount = 0;
		s.each(function(r) {
			girdcount = girdcount + 1;
		});
		//scope:this
	});
	if (timindex != "")
		find();

	//alert();
	//debugger;
}
///show column CheckBox on toolbar  songchao 20170812
function selShowColumn(tobarCheckbox,grid){	
	tobarCheckbox.addItem("显示列 ");
	tobarCheckbox.add("全选", {
				xtype: "checkbox",
				id: "ifAllSel",
				checked:true,
				handler:function(){
					var checked = this.checked;
					var len = grid.getColumnModel().getColumnCount();
					for(var i = 0 ;i < len;i++){	
						var fieldName = grid.getColumnModel().getDataIndex(i);
						var checkBoxObj = Ext.getCmp((fieldName+"ifShow").trim());
						if(checkBoxObj) checkBoxObj.setValue(checked);
					}
				}
			});		
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		var fieldName = grid.getColumnModel().getDataIndex(i); // Get field name
		var notInclude = ["Adm","BedCode","PatName","EncryptLevel","PatLevel","AdmDate","RegNo"];
		if(notInclude.indexOf(fieldName)<0){
			tobarCheckbox.addItem('-');
			var columnHeader = grid.getColumnModel().getColumnHeader(i); // Get field name
			var isHidden = grid.getColumnModel().isHidden(i);
			tobarCheckbox.add(columnHeader, {
				xtype: "checkbox",
				id: fieldName+"ifShow",
				checked:!isHidden,
				handler:function(){
					var checked = this.checked;
					var field = this.id.replace("ifShow","").trim();
					var colIndex = grid.getColumnModel().findColumnIndex(field);
					grid.getColumnModel().setHidden(colIndex,!checked);
				}
			});		
		}
		
	}
	tobarCheckbox.addItem('-');
}
var datePeriod="";
////设置录入日期不得早于入院日期  songchao  2017-8-11
function setStartDay(grid, rowIndex, columnIndex, e){
    var record = grid.getStore().getAt(rowIndex);  // Get the Record
	var startDay = changeDateFormat(record.get("AdmDate"));
	var stDatePicker = Ext.getCmp('mygridstdate');
	var date = changeDateFormat(stDatePicker.value);
	var sdate = new Date(startDay.replace(/\-/g, "\/"));  
	var curSelDate = new Date(date.replace(/\-/g, "\/"));  
	if(curSelDate<sdate){
		alert("录入体温的日期小于入院日期,请检查!");
	}
	else{
		if(record.get("AdmDate")!=""){
			stDatePicker.setMinValue(sdate);
		}
		else if(record.get("BedCode")==""){
			var wardId = session['LOGON.WARDID'];
			var Adm = record.get("Adm");
			var ret = tkMakeServerCall("web.DHCThreeNew","getCurrLocPeriod",Adm,wardId);
			datePeriod = eval(ret);
			//console.log(datePeriod);
			var strDate=datePeriod[0].StartDate;
			stDatePicker.setValue(strDate);
		}
	}
	if(record.get("Adm")=="") return;
	var endDay = tkMakeServerCall("Nur.Utility","getDisDate",record.get("Adm"));
	if(endDay!=""){
		stDatePicker.setValue(endDay);
		stDatePicker.setMaxValue(endDay);
	}	
	
}

///

function selcetDateHandler(){	
	var periodStr=""
	if(datePeriod!=""){
		var flag = true;
		for(i=0;i<datePeriod.length;i++){
			var period = datePeriod[i];
		    if (period=="") break;
			var pStart = new Date(period.StartDate.replace(/\-/g, "\/"));
			var pEnd = new Date(period.EndDate.replace(/\-/g, "\/"));
			if((this.getValue()>=pStart)&&(this.getValue()<=pEnd)){
				flag=false;
				break;
			}else{
				periodStr+=period.StartDate+"~"+period.EndDate;
			}
		}	
		if(flag){
			alert("您选择的日期病人不在本科室,无法修改数据!"+periodStr);
			this.setValue("");
			return;
		}
	}
}
///change date format from dd/MM/yyyy to yyyy-MM-dd
function changeDateFormat(date){
	var ret="";
	if(date.indexOf('/')>0){
		var dateStrs = date.split("/");
		var year = dateStrs[2];
		var month = dateStrs[1];
		var day = dateStrs[0];
		ret =year+"-"+month+"-"+day
	}else{
		ret=date;
	}	
	return ret;
	
}
////grid可编辑列处理  songchao  2017-8-11
function gridPreHandle(grid){
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		var dataIndex = grid.getColumnModel().getDataIndex(i);
		switch(dataIndex)
		{
			case 'Adm':
				grid.getColumnModel().setHidden(i,true);
			  break;
			case 'BedCode':
				grid.getColumnModel().setEditable(i,false);
			  break;
			case 'PatName':
				grid.getColumnModel().setEditable(i,false);
			  break;
			case 'EncryptLevel':
				grid.getColumnModel().setHidden(i,true);
			  break;
			case 'PatLevel':
				grid.getColumnModel().setHidden(i,true);
			  break;
			case 'RegNo':
				grid.getColumnModel().setEditable(i,false);
			  break;
			case 'AdmDate':
				grid.getColumnModel().setHidden(i,true);
			  break;
			default:
				break;
		}
	}
}
function makesure() {
	var lnk = "DHCNurEmrComm.csp?" + "&EmrCode=DHCNUR_TEMZK&EpisodeID=" + EpisodeID; //"&DtId="+DtId+"&ExamId="+ExamId
	window.open(lnk, "ht1222m", 'left=460,top=20,toolbar=no,location=no,directories=no,resizable=yes,width=800,height=600');
}
var REC = new Array();

function addprnset(par) {
	var a = par.split("^");
	//alert(a);
	a[4] = getDate(a[4]);
	if (a[6] != "") a[6] = getDate(a[6]);
	REC.push({
		patname: a[0],
		bedcode: a[1],
		pagno: a[2],
		prnpos: a[3],
		stdate: a[4],
		sttime: a[5],
		edate: a[6],
		etime: a[7],
		rectyp: a[8],
		rw: a[9],
		EpisodeID: a[10]
	})
}

function addtitCon(tobar, lab) {
	var but1 = Ext.getCmp(lab + "but1");
	but1.hide();
	var but2 = Ext.getCmp(lab + "but2");
	but2.hide();

	tobar.addItem({
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: lab + 'stdate',
		value: (diffDate(new Date(), -1))
	}, {
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: lab + 'enddate',
		value: new Date()
	});
	tobar.addButton({
			className: 'new-topic-button',
			text: "查询",
			//handler:find,
			id: lab + 'Sch'
		}

	);
}

function find() {	
	var startObj = Ext.getCmp("mygridstdate");
	startObj.setMaxValue(new Date());
	if(startObj.disabled){
		startObj.setDisabled(false);
		startObj.setValue(new Date());
	}
	findTransPatsFlag=false;
	REC = new Array();
	var adm = EpisodeID;
	var regNo = Ext.getCmp('regNo').getValue();
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr = session['LOGON.CTLOCID'] + "^"+adm+"^" + StDate + "^" + StTime+"^^"+regNo;
	if ((StTime == "") || (StTime == undefined)) return;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCThreeNew:GetAllPatient", "Parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}
///查询可录入明日体温的患者 sc 20170906
function findTomorrow() {
	findTransPatsFlag=false;
	REC = new Array();
	var startObj = Ext.getCmp("mygridstdate");
	var curDate = new Date();
	var tomorrowDate = new Date((curDate/1000+86400)*1000);  
	startObj.setDisabled(true);
	startObj.setValue(tomorrowDate);
	var StDate = formatDate(startObj.getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr = session['LOGON.WARDID'] +"^" + StDate + "^" + StTime+"^^";
	if ((StTime == "") || (StTime == undefined)) return;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCThreeNew:FindTomorowDish", "Parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}
///查询在院转科病人 songchao 20170818
function findTransPats() {
	findTransPatsFlag=true;
	REC = new Array();
	var adm = EpisodeID;
	var regNo = Ext.getCmp('regNo').getValue();
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr = session['LOGON.CTLOCID'] + "^"+adm+"^" + StDate + "^" + StTime+"^^"+regNo+"^"+"Y";
	if ((StTime == "") || (StTime == undefined)) return;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCThreeNew:GetAllPatient", "Parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}


function makepic() {
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择 一条记录 !");
		return;
	}
	var Adm = rowObj[0].get("Adm");
	MakeTempPicNew(Adm);
	//MakeTempPic(Adm);
	//find();
}

function FailChange(val) {
	if (val > 0) {
		return '<span style="color:red">' + val + '</span>';
	}
	return val
}

function IntensiveSch() {

}

function AddRec(str) {
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}

function aa(record, rowIndex, rowParams, store) {
	//禁用数据显示红色   
	if (record.data.pstate != 0) {
		return 'x-grid-record-red';
	} else {
		return '';
	}

} //end for getRowClass  

function save(flag) {

	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	if ((StTime == "") || (StTime == undefined)) return;
	var list = [];
	// var rowObj = grid.getSelectionModel().getSelections();
	// var len = rowObj.length;
	// for (var r = 0; r < len; r++) {
	// 	list.push(rowObj[r].data);
	// }
	for (var i = 0; i < store.getCount(); i++) {
		list.push(store.getAt(i).data);
		//debugger;
	}

	var RecSave = document.getElementById('RecSave');

	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		var str = "";
		var CareDate = "";
		var CareTime = "";
		//var flag="0";
		for (var p in obj) {
			obj[p] = obj[p].replace(/ /g, "")
			var aa = formatDate(obj[p]);
			//alert(aa);			
			if (p == "Adm") EpisodeID = obj[p];
			if (store.getAt(i).isModified(p) != true) {
				continue;
			}
			//alert(p);
			if (p == 'CareTime') CareTime = obj[p];
			if (p == "") continue;
			if (obj[p].indexOf("\\") > -1) {
				alert("不能输入'\\'");
				return;
			}
			if (obj[p].indexOf("'") > -1 || obj[p].indexOf('"') > -1) {
				alert("不能输入引号");
				return;
			}
			if (obj[p].indexOf("[") > -1 || obj[p].indexOf(']') > -1) {
				alert("不能输入 [ 或 ]");
				return;
			}
			if (obj[p].indexOf("{") > -1 || obj[p].indexOf('}') > -1) {
				alert("不能输入 { 或 }");
				return;
			}
			if ((p == 'Item1') || (p == 'Item22')) {
				if (isNaN(obj[p])) {
					if ((obj[p] != "") && (obj[p].split(".").length > 2)) {
						alert("体温或物理降温输入格式不对,包括多个点!");
						return;
					} else {
						alert("体温或物理降温值请录入数字!");
						return;
					}
				} else {
					if ((obj[p] != "") && ((obj[p] < 34) || (obj[p] > 43))) {
						alert("体温或物理降温值请录入34到43之间的数值!");
						return;
					}
				}
			}
			if ((p == 'Item60') || (p == 'Item61')) {
				if (isNaN(obj[p])) {
					if ((obj[p] != "") && (obj[p].split(".").length > 2)) {
						alert("疼痛或止痛输入格式不对,包括多个点!");
						return;
					} else {
						alert("疼痛或止痛值请录入数字!");
						return;
					}
				} else {
					if ((obj[p] != "") && ((obj[p] < 0) || (obj[p] > 10))) {
						alert("疼痛或止痛值请录入0到10之间的数值!");
						return;
					}
				}
			}
			if (p == 'Item17')  {			
				var reasons = ['拒测','请假','外出'];
				if ((obj[p] != "") && (reasons.indexOf(obj[p])< 0)) {
						alert("请选择下拉框中的未测原因!");
						return;
				}
			}
			if (p == 'Item62')  {			
				var reasons = ['入睡','拒测','请假','外出'];
				if ((obj[p] != "") && (reasons.indexOf(obj[p])< 0)) {
						alert("请选择下拉框中的疼痛未测原因!");
						return;
				}
			}
			
			if (p == 'Item7') {
				if (isNaN(obj[p])) {
					alert("脉搏值请录入数字!");
					return;
				} else {
					if ((obj[p] != "") && ((obj[p] < 20) || (obj[p] > 200))) {
						alert("脉搏值请录入20到200之间的数值!");
						return;
					}
				}
			}
			if (p == 'Item13') {
				if (isNaN(obj[p])) {
					alert("心率值请录入数字!");
					return;
				} else {
					if ((obj[p] != "") && ((obj[p] < 20) || (obj[p] > 200))) {
						alert("心率值请录入20到200之间的数值!");
						return;
					}
				}
			}
			if (aa == "") {
				str = str + p + "|" + obj[p] + '^';
			} else {
				str = str + p + "|" + aa + '^';
			}
		}

		if ((str != "") && (flag != "1")) {
			if (str.indexOf("CareDate") == -1) {
				str = str + "CareDate|" + CareDate + "^CareTime|" + CareTime;
				//debugger;
			}
			// alert(EpisodeID);
			//alert(str);
			var a = cspRunServerMethod(RecSave.value, EpisodeID, str, session['LOGON.USERID'], "DHCNUR6", session['LOGON.GROUPDESC'], StDate, StTime);
			if (a != "0") {
				alert(a);
				return;
			}
			//MakeTempPic(EpisodeID);
		}
	}

	if (flag !== "1") {
		alert("保存成功");
		find();
	}
}
//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
function gettime() {
	var a = Ext.util.Format.dateRenderer('h:m');
	return a;
}

function gridclick() {
	var grid = Ext.getCmp("mygrid");

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		EpisodeID = rowObj[0].get("Adm");
		/*for (i = 0; i < top.frames.length; i++) {
			alert(top.frames[i].name);
		}*/
		var frm = top.document.forms["fEPRMENU"];
		//frm.EpisodeID.value=EpisodeID;
		// ModConsult();
	}
}

function diffDate(val, addday) {
	var year = val.getFullYear();
	var mon = val.getMonth();
	var dat = val.getDate() + addday;
	var datt = new Date(year, mon, dat);

	return formatDate(datt);
}

function getDate(val) {
	var a = val.split('-');
	var dt = new Date(a[0], a[1] - 1, a[2]);
	return dt;
}

function formatDate(value) {
	try {
		return value ? value.dateFormat('Y-m-d') : '';
	} catch (err) {
		return '';
	}
};
/*
 
 */
var rightClick = new Ext.menu.Menu({
	id: 'rightClickCont',
	items: [ {
		id: 'rMenu2',
		text: '事件登记',
		handler: QtEvent
	}, {
		id: 'rMenu4',
		text: '预览',
		handler: temppreview
	}, {
		id: 'rMenu5',
		text: '数据明细',
		handler: PatDataDetail
	},
					{
                    id:'rMenu6',
                    text : '修改记录',
                    handler:PatDataModied
                }]
});

function rightClickFn(client, rowIndex, e) {
	e.preventDefault();
	grid = client;
	CurrRowIndex = rowIndex;
	rightClick.showAt(e.getXY());
}

function rowClickFn(grid, rowIndex, e) {
	//alert('你单击了' + rowIndex);
}

function add(a1, a2) {
	attenitm.push({
		xtype: 'panel',
		id: a1,
		title: a2,
		region: 'center',
		height: 1000,
		layout: 'fit',
		closable: true,
		items: []
	})
}

function OrdSch() {
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请先选择一条记录!");
		return;
	}
	var Adm = rowObj[0].get("Adm");
	// var CurrAdm=selections[rowIndex].get("Adm");
	var lnk = "DHCNurEmrComm.csp?" + "&EmrCode=DHCNUROUTREG" + "&EpisodeID=" + Adm;
	window.open(lnk, "htm", 'toolbar=no,location=no,directories=no,resizable=yes,width=760,height=500');


}

function temppreview() {
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请先选择一条记录!");
		return;
	}
	var Adm = rowObj[0].get("Adm");
	//TempShow(Adm);///体温单object-dll动态库方式调用
	TempShowNew(Adm);///体温ClickOnce方式
	// var CurrAdm=selections[rowIndex].get("Adm");
	///var lnk= "DHCNurTempature.csp?"+"&EpisodeID="+Adm;
	//window.open(lnk,"htm",'toolbar=no,location=no,directories=no,status=yes,resizable=no,width=860,height=800');


}

function QtEvent() {
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请先选择一条记录!");
		return;
	}
	var Adm = rowObj[0].get("Adm");
	// var CurrAdm=selections[rowIndex].get("Adm");
	var lnk = "DHCNurEmrComm.csp?" + "&EmrCode=DHCNURQTDATA" + "&EpisodeID=" + Adm;
	window.open(lnk, "htm", 'toolbar=no,location=no,directories=no,resizable=yes,width=520,height=400');
}
var condata = new Array();

function add(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) { //OrdDate,OrdTime,ARCIMDesc,PriorDes,Meth,PHFreq,Dose,PhQtyOrd,OrdStat,Doctor,Oew,OrdSub,Sel,SeqNo
	condata.push({
		OrdDate: a,
		OrdTime: b,
		ARCIMDesc: c,
		PriorDes: d,
		Meth: e,
		PHFreq: f,
		Dose: g,
		DoseUnit: h,
		PhQtyOrd: i,
		OrdStat: j,
		Doctor: k,
		Oew: l,
		OrdSub: m,
		SeqNo: o
	});
}

//document.body.onload=BodyLoadHandler;
//date.on('change', function(){alert(1);});



function printNurRec() {
	var GetPrnSet = document.getElementById('GetPrnSet');
	var GetHead = document.getElementById('GetHead');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	//debugger;
	var a = cspRunServerMethod(GetPrnSet.value, "DHCNUR6", EpisodeID); //page, caredattim, prnpos, adm,Typ,user
	if (a == "") return;
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, "DHCNUR6^" + session['LOGON.CTLOCID']);
	var tm = a.split("^");
	var stdate = tm[2];
	var stim = tm[3];
	var edate = tm[4];
	var etim = tm[5];
	PrintComm.RHeadCaption = hh[1];
	PrintComm.LHeadCaption = hh[0];
	//PrintComm.RFootCaption="第";
	//PrintComm.LFootCaption="页";
	PrintComm.LFootCaption = hh[2];
	PrintComm.SetPreView("1");
	var aa = tm[1].split("&");
	PrintComm.stPage = aa[0];
	if (aa.length > 1) PrintComm.stRow = aa[1];
	PrintComm.stprintpos = tm[0];
	//alert(PrintComm.Pages);
	PrintComm.SetConnectStr(CacheDB);
	PrintComm.ItmName = "DHCNurPrnMould6"; //338155!2010-07-13!0:00!!
	//debugger;
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!DHCNUR6";
	PrintComm.ID = "";
	PrintComm.MultID = "";
	//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
	PrintComm.LabHead = LabHead;
	PrintComm.SetParrm(parr); // ="EpisodeId" ;  //"p1:0^p2:"
	PrintComm.PrintOut();
	var SavePrnSet = document.getElementById('SavePrnSet');
	//debugger;
	var CareDateTim = PrintComm.CareDateTim;
	if (CareDateTim == "") return;
	var pages = PrintComm.Pages;
	var stRow = PrintComm.stRow;
	//debugger;
	var stprintpos = PrintComm.stPrintPos;
	//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"DHCNUR6"+","+session['LOGON.USERID']);
	//暂时判断坐标为0里,说明是打印预览
	if (PrintComm.PrnFlag == 1) return;
	var a = cspRunServerMethod(SavePrnSet.value, pages + "|" + stRow, CareDateTim, stprintpos, EpisodeID, "DHCNUR6", session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
	//alert(a);			
}

function eachItem(item, index, length) {
	if (item.xtype == "checkbox") {
		//修改下拉框的请求地址    
		//debugger;
		if (item.checked == true) checkret = checkret + item.id + "|" + item.boxLabel + "^";
	}

	if (item.items && item.items.getCount() > 0) {
		item.items.each(eachItem, this);
	}
}

function beforeEditFn(e) {
	grid.rowIndex = e.row; //得到当前的行
	grid.columnIndex = e.column; //得到当前的列
}
var storespechar = new Array();

function SepcialChar() {
	var grid = new Ext.grid.GridPanel({
		id: 'mygridspecchar',
		name: 'mygridspecchar',
		title: '',
		stripeRows: true,
		height: 480,
		width: 145,
		tbar: [{
			id: 'insertBtn',
			handler: insertSpecChar,
			icon:'../images/uiimages/editstatu.png',
			text: '插入'
		}],
		store: new Ext.data.JsonStore({
			data: [],
			fields: ['desc', 'rw']
		}),
		colModel: new Ext.grid.ColumnModel({
			columns: [{
				header: '特殊字符',
				dataIndex: 'desc',
				width: 110
			}, {
				header: 'rw',
				dataIndex: 'rw',
				width: 0
			}],
			rows: [],
			defaultSortable: true
		}),
		enableColumnMove: false,
		viewConfig: {
			forceFit: false
		}
	});
	storespechar = new Array();
	var GetQueryData = document.getElementById('GetQueryData1');
	var parr = "";
	var a = cspRunServerMethod(GetQueryData.value, "User.DHCTEMPSPECIALCHAR:CRItem", "", "AddSpecChar");
	grid.store.loadData(storespechar);
	var len = grid.getColumnModel().getColumnCount();
	for(var i=0;i<len;i++){
		if(grid.getColumnModel().getDataIndex(i)=="rw"){
			grid.getColumnModel().setHidden(i,true);
		}
	}
	var window = new Ext.Window({
		title: '特殊字符',
		width: 180,
		height: 480,
		x:200,
		y:200,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: grid,
		listeners: {
			'close': function() {
				Ext.getCmp('mygrid').startEditing(Ext.getCmp('mygrid').rowIndex, Ext.getCmp('mygrid').columnIndex);
			}
		}
	});
	window.show();
}

function AddSpecChar(str) {
	var obj = eval('(' + str + ')');
	storespechar.push(obj);
}

function insertSpecChar() {
	var grid = Ext.getCmp('mygridspecchar');
	//弹出界面中Grid
	var selModel = grid.getSelectionModel();
	if (selModel.hasSelection()) {
		var selections = selModel.getSelections();
		var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
		var specchardesc = grid.store.getAt(rowIndex).data.desc;
		var mygrid = Ext.getCmp('mygrid');
		var oldStr = mygrid.store.getAt(mygrid.rowIndex).get(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex));
		if (oldStr) specchardesc = oldStr + specchardesc
		mygrid.store.getAt(mygrid.rowIndex).set(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex), specchardesc);
		mygrid.startEditing(mygrid.rowIndex, mygrid.columnIndex);
	}
}

function PatDataDetail() {
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请先选择一条记录!");
		return;
	}
	var Adm = rowObj[0].get("Adm");
	var lnk = "DHCNurEmrComm.csp?" + "&EmrCode=DHCNURTEMDETAIL" + "&EpisodeID=" + Adm;
	window.open(lnk, "htm", 'toolbar=no,location=no,directories=no,resizable=yes,width=1366,height=768,left=0,top=0');
}

function PatDataModied()
{         
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURTEMMODIED"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=900,height=600,left=50,top=90');
} 
function SchXCSGTZ() {
	//alert('heheh');
	REC = new Array();
	var adm = EpisodeID;
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr = session['LOGON.WARDID'] + "^" + StDate + "^" + StTime+"^N";
	if ((StTime == "") || (StTime == undefined)) return;
	debugger;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurNeedMeasureTempPat:MeaserWeightHeightPats", "Parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
	buttonFlag = "0";
}
function SchXC() {
	REC = new Array();
	var adm = EpisodeID;
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr = session['LOGON.CTLOCID'] + "^" + StDate + "^" + StTime;
	if ((StTime == "") || (StTime == undefined)) return;
	debugger;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurNeedMeasureTempPat:GetNeedMeaserPat", "Parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
	buttonFlag = "0";
}