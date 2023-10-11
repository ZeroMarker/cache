var DHCNurCheckRecT102 = new Ext.data.JsonStore({
	data: [],
	fields: ['OrdDate', 'OrdTime', 'ARCIMDesc', 'DateEx', 'TimeEx', 'CPTEx', 'ArcimDR', 'ORW']
});
var DHCNurLabRecT103 = new Ext.data.JsonStore({
	data: [],
	fields: ['StDateTime', 'ARCIMDes', 'LabEpisodeNo', 'testcode', 'LabDate', 'LabTime', 'LabCpt', 'RowId']
});
var DHCPatOrdListT103 = new Ext.data.JsonStore({
	data: [],
	fields: ['OrdDate', 'OrdTime', 'ARCIMDesc', 'PriorDes', 'Meth', 'PHFreq', 'Dose', 'DoseUnit', 'OrdStat', 'Doctor', 'Oew', 'OrdSub', 'Sel', 'SeqNo']
});
var DHCNurRelDiagnosT101 = new Ext.data.JsonStore({
	data: [],
	fields: ['DiagNos', 'RecUser', 'RecDate', 'RecTime', 'rw']
});
var DHCPatOrdListT105 = new Ext.data.JsonStore({
	data: [],
	fields: ['OrdDate', 'OrdTime', 'ARCIMDesc', 'PriorDes', 'Meth', 'PHFreq', 'Dose', 'DoseUnit', 'OrdStat', 'Doctor', 'Oew', 'OrdSub', 'SeqNo']
});
var CurrHeadDr = "";
var SumInName = "";
var SumInAmount = "";
var SumOutName = "";
var SumOutAmount = "";
var PartInName = "";
var PartInAmount = "";
var PartOutName = "";
var PartOutAmount = "";
var DisplaySumInName = "";
var DisplaySumInAmount = "";
var DisplaySumOutName = "";
var DisplaySumOutAmount = "";
var CaseMeasureID = ""; //邦定的处置ID
var MeasureRel = new Hashtable();
var oriTitle = "";
var GetNurseRecSet = document.getElementById('GetNurseRecSet');
if (GetNurseRecSet) {
	var ret = cspRunServerMethod(GetNurseRecSet.value, EmrCode);
	var hh = ret.split("^");
	SumInName = hh[0].split("&")[0];
	SumInAmount = hh[0].split("&")[1];
	SumOutName = hh[1].split("&")[0];
	SumOutAmount = hh[1].split("&")[1];
	PartInName = hh[2].split("&")[0];
	PartInAmount = hh[2].split("&")[1];
	PartOutName = hh[3].split("&")[0];
	PartOutAmount = hh[3].split("&")[1];
	DisplaySumInName = hh[7].split("&")[0];
	DisplaySumInAmount = hh[7].split("&")[1];
	DisplaySumOutName = hh[8].split("&")[0];
	DisplaySumOutAmount = hh[8].split("&")[1];
	//debugger;
	//alert(DisplaySumInAmount);
	if ((SumInName == "") || (SumInName == null)) {
		SumInName = DisplaySumInName.split('!')[0];
	}
	if ((SumInAmount == "") || (SumInAmount == null)) {
		SumInAmount = DisplaySumInAmount;
	}
	//alert(SumInAmount);
}
var UserType = "";
var GetUserType = document.getElementById('GetUserType');
if (GetUserType) {
	UserType = cspRunServerMethod(GetUserType.value, session['LOGON.USERID']);
}
var grid;
var DiagnosDr = "";
var CurrHeadDr = "";
var BFHeadDr = "";
var mlStr = tkMakeServerCall("Nur.DHCNurRecHeadChangeRec", "getcurrrownew", EpisodeID, session['LOGON.USERID'], EmrCode);
function gethead() {
	var GetCurrHeadDR = document.getElementById('GetCurrHeadDR');
	//alert(EmrCode);
	var ret = cspRunServerMethod(GetCurrHeadDR.value, EpisodeID, session['LOGON.USERID'], EmrCode);
	if (ret != "") {
		var dd = ret.split("||");
		CurrHeadDr = dd[0] + "_" + dd[1];
		//alert(CurrHeadDr)
	}
	//取表头列表
	var list = tkMakeServerCall("Nur.DHCNurRecHeadChangeRec", "getbtlist", EpisodeID, session['LOGON.USERID'], EmrCode);
	var listarr = list.split("^")
	//alert(listarr)
	for (i = 0; i < listarr.length; i++) {
		if ((listarr[i] == CurrHeadDr) && (i > 0)) {
			BFHeadDr = listarr[i - 1]
		}
		if (i == 0) {
			BFHeadDr = 0
		}
	}
	//alert(BFHeadDr);
	var GetHead = document.getElementById('GetHead');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	return hh[0] + "  " + hh[1] + " ----注意:根据护理部要求，只能修改本人签名的记录！";
	//debugger;
}

var DHCPatOrdListT103 = new Ext.data.JsonStore({
	data: [],
	fields: ['OrdDate', 'OrdTime', 'ARCIMDesc', 'PriorDes', 'Meth', 'PHFreq', 'Dose', 'DoseUnit', 'OrdStat', 'Doctor', 'Oew', 'OrdSub', 'SeqNo']
});
var DHCNurLabRecT103 = new Ext.data.JsonStore({
	data: [],
	fields: ['StDateTime', 'ARCIMDes', 'LabEpisodeNo', 'testcode', 'LabDate', 'LabTime', 'LabCpt', 'RowId']
});
var DHCNurCheckRecT102 = new Ext.data.JsonStore({
	data: [],
	fields: ['OrdDate', 'OrdTime', 'ARCIMDesc', 'DateEx', 'TimeEx', 'CPTEx', 'ArcimDR', 'ORW']
});
var locdata = new Array();
var loc = session['LOGON.CTLOCID'];
cspRunServerMethod(getadmhead, EpisodeID, session['LOGON.USERID'], EmrCode, 'addloc');

function addloc(a, b) {
	locdata.push({
		loc: a,
		locdes: b
	});
}
var storeloc = new Ext.data.JsonStore({
	data: locdata,
	fields: ['loc', 'locdes']
});
var locField = new Ext.form.ComboBox({
	id: 'locsys',
	hiddenName: 'loc1',
	store: storeloc,
	width: 600,
	fieldLabel: '表头',
	valueField: 'loc',
	displayField: 'locdes',
	allowBlank: false,
	mode: 'local',
	editable: false,
	triggerAction: 'all',
	anchor: '100%'
});
var CurrHeadDr = ""
locField.on('select', function () {
	CurrHeadDr = Ext.get("loc1").dom.value;
	//alert(CurrHeadDr)
	var a = cspRunServerMethod(Savecurhead, EpisodeID, CurrHeadDr, session['LOGON.USERID'], EmrCode);
	self.location.reload();
	//find2();
});

function setbt() {
	CurrHeadDr = Ext.get("loc1").dom.value;
	var a = cspRunServerMethod(Savecurhead, EpisodeID, CurrHeadDr, session['LOGON.USERID'], EmrCode);
	self.location.reload();
	find2()
}
var wind3; //全局变量
var kkk = 0
var ddd = 0

//表头变更记录
function btlist() {

	var lnk = "dhcnuremrcomm.csp?" + "&EmrCode=DHCNURHEADCHANGE&EpisodeID=" + EpisodeID + "&headcode=" + EmrCode //""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	// window.open(lnk, "title3444", ',top=10,left=360,toolbar=no,location=no,directories=no,resizable=yes,width=800,height=500');
	var objret = window.showModalDialog(lnk, 'title3444', "dialogWidth:800px;dialogHeight:500px;center:yes;resizable:no;status:no;scroll:YES;help:no;edge:raised;");
	// alert(objret)
	if (objret == undefined) {
		CurrHeadDr = Ext.get("loc1").dom.value;
		var a = cspRunServerMethod(Savecurhead, EpisodeID, CurrHeadDr, session['LOGON.USERID'], EmrCode);
		self.location.reload();
		find();
	}

}

var StartLock = "0" //续打全院开关：1:启用续打，0:不启用续打
var IfMakePic = "" //是否生成图片
var WillUpload = "" //是否上传ftp
var prnmode = tkMakeServerCall("User.DHCNURMoudelLink", "getPrintCode", EmrCode) //根据界面模板获取打印模板
var prnmcodes = ""
if (prnmode != "") {
	var prnarr = prnmode.split('|')
	prnmcodes = prnarr[0]
	IfMakePic = prnarr[3] //是否生成图片
	WillUpload = prnarr[4] //是否上传ftp
	//alert(WillUpload)
	if (prnarr[2] == "Y") //启用续打
	{
		StartLock = "1"
	} else {
		StartLock = "0"
	}
}
if ((StartLock == "1") && (prnmode == "")) {
	alert("请关联界面模板和打印模板!")
	StartLock = "0" //关闭续打
}
var printcolor = '#C9C9C9'; //已打印颜色
var havechangecolor = '#FF8247' //有修改颜色
var noprintcolor = '#FFFFF0'; //未打印颜色
var Startcolor = '#1E90FF'; //从该条开始打印的颜色
var prncode = prnmcodes //打印模板名称
var Startloc = "" //启用续打的科室科室（前提必须是StartLock=1）

function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
	//fm.doLayout(); 
	var but1 = Ext.getCmp("mygridbut1");
	but1.on('click', additm);
	var but = Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.on('click', save);
	Ext.override(Ext.Editor, {
		onSpecialKey: function (field, e) {
			var key = e.getKey();
			this.fireEvent('specialkey', field, e);
		}
	});
	grid = Ext.getCmp('mygrid');
	// by lmm 控制G单元文本域显示大小 20171222
	Ext.getCmp("mygrid").on('beforeedit', function (e) {
		var el = Ext.get(e.grid.getView().getCell(e.row, e.column)); //获取列元素 
		if (e.column == 12) {
			var ed = e.grid.colModel.getCellEditor(e.column, e.row); //获取编辑器 
			ed.setSize(el.getWidth(), 100); //设置编辑器大小 
		}
		/*
		if (e.record.get('N_Pro_Action') == 1) return true;
		else return false*/
	})
	var selectMoodel = grid.getSelectionModel();
	Ext.override(Ext.grid.RowSelectionModel, {
		onEditorKey: function (F, E) {
			var C = E.getKey(),
				G, D = this.grid,
				B = D.activeEditor;
			var A = E.shiftKey;
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
					// alert(B);
					B.completeEdit();
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
				} else if (C == E.LEFT) {
					G = D.walkCells(B.row, B.col - 1, -1, this.acceptsNav, this);
					//南方医院竖向录入
					selectMoodel.selectRow(B.row);
				} else if (C == E.UP) {
					G = D.walkCells(B.row - 1, B.col, -1, this.acceptsNav, this);
					//南方医院竖向录入
					selectMoodel.selectRow(B.row - 1);
				} else if (C == E.RIGHT) {
					G = D.walkCells(B.row, B.col + 1, 1, this.acceptsNav, this);
					//南方医院竖向录入
					selectMoodel.selectRow(B.row);
				} else if (C == 40) {
					G = D.walkCells(B.row + 1, B.col, 1, this.acceptsNav, this);
					//南方医院竖向录入
					selectMoodel.selectRow(B.row + 1);
				} else {
					if (C == E.ESC) {
						B.cancelEdit();
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
	//竖方向录入start
	document.querySelector("#ext-gen4").style.height = (document.body.clientHeight - 300) + "px";
	document.querySelector("#ext-gen5").style.height = (document.body.clientHeight - 317) + "px";
	document.querySelector("#ext-gen8").style.height = (document.body.clientHeight - 317) + "px";
	document.querySelector("#ext-gen13").style.height = (document.body.clientHeight - 317) + "px"; 
	document.querySelector("#ext-gen14").style.font = "15px";
	var iframe = document.createElement("iframe");
	iframe.setAttribute("frameborder", 0);
	iframe.setAttribute("name", "JLDInVerticalModle")
	iframe.setAttribute("height", "520px");
	iframe.setAttribute("width", "100%");
	iframe.setAttribute("src", "../csp/dhc.nurse.emr.verticalmodel.csp?EpisodeID=" + EpisodeID + "&EmrCode=" + EmrCode);
	document.body.appendChild(iframe);
	grid.getSelectionModel().addListener('rowselect', rowSelectFn);
	//竖方向录入end

	grid.setTitle(gethead());
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.addItem({
		xtype: 'datefield',
		format: 'Y-m-d',
		id: 'mygridstdate',
		value: (diffDate(new Date(), -6))
	}, {
			xtype: 'timefield',
			width: 100,
			format: 'H:i',
			value: '0:00',
			id: 'mygridsttime'
		}, {
			xtype: 'datefield',
			format: 'Y-m-d',
			id: 'mygridenddate',
			value: diffDate(new Date(), 1)
		}, {
			xtype: 'timefield',
			width: 100,
			id: 'mygridendtime',
			format: 'H:i',
			value: '0:00'
		}, {
			xtype: 'textfield',
			width: 100,
			id: 'nurseSign'
		});
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询",
		handler: find,
		id: 'mygridSch'
	}

	);
	/*
    tobar.addButton(
		  {
			//className: 'new-topic-button',
			text: "统计",
			handler:findStat,
			id:'mygridStat'
		  }
	  );
	  
   	tobar.addButton(
		  {
			//className: 'new-topic-button',
			text: "打印",
			handler:printNurRec,
			id:'PrintBut'
		  }
	  );
	  */
	tobar.addButton({
		//className: 'new-topic-button',
		text: "特殊字符",
		handler: SepcialChar,
		id: 'SepcialChar1'
	});
	//	tobar.addItem ("-");
	//	tobar.addButton(
	//  {
	//className: 'new-topic-button',
	//	text: "打印新",
	//	handler:printNurRecnew,
	//	id:'PrintBut2'
	//  }
	//);
	tobar.addItem("-");
	if (StartLock == "1") {
		if ((Startloc.indexOf(session['LOGON.CTLOCID']) > -1) || (Startloc == "")) {

			tobar.addButton({
				text: "打印(续打)",
				handler: printNurRecXu,
				id: 'PrintButxu'
			});
			tobar.addButton({
				text: "全部打印",
				handler: printNurRecZK, //这个个调用原来的方法,在原来基础上加一句：PrintCommPic.Xuflag=0
				id: 'PrintButZK'
			});
		} else {
			tobar.addButton({
				text: "全部打印",
				handler: printNurRecZK,
				id: 'PrintButZK'
			});
		}
	} else {
		tobar.addButton({
			text: "全部打印",
			handler: printNurRecZK,
			id: 'PrintButZK'
		});
	}
	/*tobar.addItem("-");
	tobar.addButton({
		//className: 'new-topic-button',
		text: "24h统计",
		handler: InOutSumAll,
		id: 'mygridStat'
	});
	tobar.addItem("-");
	tobar.addButton({
		//className: 'new-topic-button',
		text: "日间小结",
		handler: InOutSumNod,
		id: 'mygridStat2'
	});
	tobar.addItem("-");
	tobar.addButton({
		//className: 'new-topic-button',
		text: "按时间段统计",
		handler: InOutSumSeg,
		id: 'mygridStat3'
	});
	tobar.addButton({
		text: "续打说明新",
		handler: XuInt,
		id: 'XuInt'
	});*/
	tobar.addButton({
		text: "关联",
		handler: LinkTemp,
		id: 'linkTemp'
	});
	/*
	tobar.addItem("-", {
		xtype: 'checkbox',
		id: 'IfCancelRec',
		checked: false,
		hidden:true,
		boxLabel: '显示作废记录'
	});
	*/
	//tobar.render(grid.tbar);
	if (session['LOGON.USERID'] == "3880") //测试账号测试用dh444444
	{
		tobar.addButton({
			text: "打印测试",
			handler: printNurRecXuTest,
			id: 'PrintButxutest'
		});
		tobar.addButton({
			text: "全部打印测试",
			handler: printNurRecZKTest,
			id: 'PrintButxualltest'
		});
		tobar.addItem("-")
		if (IfMakePic == "Y") {
			tobar.addButton({
				//className: 'new-topic-button',
				text: "生成所有图片",
				handler: MakePicture,
				id: 'MakePicture12'
			});
		}
	}
	// if (IfMakePic == "Y") {
	// 	tbar2 = new Ext.Toolbar({});
	// 	tbar2.addButton({
	// 		//className: 'new-topic-button',
	// 		text: "生成所有图片",
	// 		handler: MakePicture,
	// 		id: 'MakePicture12'
	// 	});
	// 	tbar2.render(grid.tbar);
	// }
	/*tbar2 = new Ext.Toolbar({});
	tbar2.addButton({
		//className: 'new-topic-button',
		text: "表头变更记录",
		handler: btlist,
		id: 'btlist'
	});
	tbar2.addItem("-");
	tbar2.addItem('当前表头', locField)
	tbar2.addItem("-");
	tbar2.addButton({
		text: "删除记录",
		handler: CancelRecord,
		id: 'rMenu7'
	});*/
	tbar2.render(grid.tbar);
	tobar.doLayout();
	locField.setValue(CurrHeadDr);
	if (UserType == "DOCTOR") {
		if (but1) but1.hide();
		if (but) but.hide();
		//var obj=Ext.getCmp("PrintBut");
		//if (obj) obj.hide();
		var obj = Ext.getCmp("XPrintSet");
		if (obj) obj.hide();
	} else {
		//grid.addListener('rowcontextmenu', rightClickFn);
		grid.addListener('rowclick', rowClickFn);
		grid.on('beforeedit', beforeEditFn);
		grid.on('afteredit', afterEditFn);
	}
	grid.on('mouseover', function (e) { //添加mouseover事件
		var index = grid.getView().findRowIndex(e.getTarget()); //根据mouse所在的target可以取到列的位置
		if (index !== false) { //当取到了正确的列时，（因为如果传入的target列没有取到的时候会返回false）
			var store = grid.getStore();
			var totalRow = "";
			if (store.getCount() > 0) totalRow = store.getAt(index).get(DisplaySumInName.split("!")[0]);
			if ((store.getCount() > 0)) //续打
			{
				if ((StartLock != "1") || (prnmode == "")) {
					return
				} else {
					if ((Startloc.indexOf(session['LOGON.CTLOCID']) == -1) && (Startloc != "")) return
				}
				var rowid = store.getAt(index).get("par") + "||" + store.getAt(index).get("rw")
				var rowidparr = store.getAt(index).get("par") + "&" + store.getAt(index).get("rw")
				var STInfo = tkMakeServerCall("Nur.DHCNurRecPrintStPos", "getval", EpisodeID + "&" + prncode)
				var STArr = STInfo.split('^')
				var printInfo = tkMakeServerCall("Nur.DHCNurRecPrint", "getval", rowidparr)
				var printedarr = printInfo.split('^')
				if (rowid == STArr[0]) //续打开始行或结束行
				{
					var str = "<TABLE borderColor=#000000 width='100%' bgColor=#ffffff border=1 cellSpacing=0 cellPadding=0><TBODY>";
					var text = ""
					var stp = (parseInt(STArr[1]) + parseInt(1))
					var stro = (parseInt(STArr[2]) + parseInt(1))
					var stoo = parseInt(STArr[2]) - parseInt(STArr[4])

					if ((printedarr[4] == "2") && (STArr[3] == "1")) {
						text = "该条记录打印过后有修改,该记录从第：" + stoo + "页,第:" + STArr[2] + "行开始打印,一页可打印:" + STArr[5] + "行"
					} else if (STArr[3] == "1") //已打印
					{
						text = "该条记录从第:" + stp + "页,第:" + stoo + "行开始打印到第:" + STArr[2] + "行,占用:" + STArr[4] + "行,一页可打印:" + STArr[5] + "行"
					} else {
						text = "补打开始位置--该条记录从第:" + stp + "页,第:" + stro + "行开始打印,一页可打印:" + STArr[5] + "行"
					}
					str = str + "<TR bgColor=#D2E9FF><TD>打印信息</TD></TR>";
					str = str + "<TR><TD>" + text + "</TD></TR>";

				} else if (printInfo != "") {
					var str = "<TABLE borderColor=#000000 width='100%' bgColor=#ffffff border=1 cellSpacing=0 cellPadding=0><TBODY>";
					var text = ""
					var stpage = parseInt(printedarr[1]) + parseInt(1)
					var strow = parseInt(printedarr[2]) + parseInt(1)
					var edrow = parseInt(printedarr[2]) + parseInt(printedarr[3])
					var rowh = parseInt(printedarr[3])
					if (printedarr[4] == "1") //已打印
					{
						text = "该条记录从第:" + stpage + "页,第:" + strow + "行开始打印到第:" + edrow + "行,占用:" + rowh + "行,一页可打印:" + printedarr[5] + "行"
					}
					if (printedarr[4] == "0") //未打印
					{
						text = "该条记录未打印"
					}
					if (printedarr[4] == "2") //有修改
					{
						text = "该条记录打印过后有修改,该记录从第：" + stpage + "页,第:" + strow + "行开始打印,一页可打印:" + printedarr[5] + "行"
					}
					str = str + "<TR bgColor=#D2E9FF><TD>打印信息</TD></TR>";
					str = str + "<TR><TD>" + text + "</TD></TR>";
				}

				if ((totalRow) && (totalRow.indexOf("入液量") > -1)) {
					//var record = store.getAt(index);//把这列的record取出来
					//var str = Ext.encode(record.data);//组装一个字符串，这个需要你自己来完成，这儿我把他序列化
					var par = store.getAt(index).get("par");
					var rw = store.getAt(index).get("rw");
					var totalRow1, totalRow2, totalRow3, totalRow4;
					if ((par) && (rw)) {
						var GetSubInOut = document.getElementById('GetSubInOut');
						if (GetSubInOut) {
							var ret = cspRunServerMethod(GetSubInOut.value, par + "^" + rw);
							var retArr = ret.split("@");
							totalRow1 = retArr[0];
							totalRow2 = retArr[1];
							totalRow3 = retArr[2];
							totalRow4 = retArr[3];
						}
					} else {
						totalRow1 = store.getAt(index).get(PartInName);
						totalRow2 = store.getAt(index).get(PartInAmount);
						totalRow3 = store.getAt(index).get(PartOutName);
						totalRow4 = store.getAt(index).get(PartOutAmount);
					}
					if (typeof (str) == "undefined") {
						var str = "<TABLE borderColor=#000000 width='100%' bgColor=#ffffff border=1 cellSpacing=0 cellPadding=0><TBODY>";
					}
					str = str + "<TR bgColor=#D2E9FF><TD></TD><TD>名称</TD><TD>量</TD></TR>";
					var totalRow2Arr = totalRow2.split(";");
					str = str + "<TR><TD bgColor=#D2E9FF rowSpan=" + (totalRow2Arr.length - 1) + ">入液量分项</TD><TD>" + totalRow2Arr[0].replace(":", "</TD><TD>") + "</TD></TR>";
					for (var i = 1; i < (totalRow2Arr.length - 1); i++) {
						str = str + "<TR><TD>" + totalRow2Arr[i].replace(":", "</TD><TD>") + "</TD></TR>";
					}
					var totalRow4Arr = totalRow4.split(";");
					str = str + "<TR><TD bgColor=#D2E9FF rowSpan=" + (totalRow4Arr.length - 1) + ">出液量分项</TD><TD>" + totalRow4Arr[0].replace(":", "</TD><TD>") + "</TD></TR>";
					for (var i = 1; i < (totalRow4Arr.length - 1); i++) {
						str = str + "<TR><TD>" + totalRow4Arr[i].replace(":", "</TD><TD>") + "</TD></TR>";
					}
				}


				str = str + "</TBODY></TABLE>";
				var rowEl = Ext.get(e.getTarget()); //把target转换成Ext.Element对象
				rowEl.set({
					'ext:qtip': str //设置它的tip属性
				}, false);
			}
			/*if ((totalRow) && (totalRow.indexOf("入液量") > -1)) {
				//var record = store.getAt(index);//把这列的record取出来
				//var str = Ext.encode(record.data);//组装一个字符串，这个需要你自己来完成，这儿我把他序列化
				var par = store.getAt(index).get("par");
				var rw = store.getAt(index).get("rw");
				var totalRow1, totalRow2, totalRow3, totalRow4;
				if ((par) && (rw)) {
					var GetSubInOut = document.getElementById('GetSubInOut');
					if (GetSubInOut) {
						var ret = cspRunServerMethod(GetSubInOut.value, par + "^" + rw);
						var retArr = ret.split("@");
						totalRow1 = retArr[0];
						totalRow2 = retArr[1];
						totalRow3 = retArr[2];
						totalRow4 = retArr[3];
					}
				} else {
					totalRow1 = store.getAt(index).get(PartInName);
					totalRow2 = store.getAt(index).get(PartInAmount);
					totalRow3 = store.getAt(index).get(PartOutName);
					totalRow4 = store.getAt(index).get(PartOutAmount);
				}
				//var str="<p>"+totalRow1+"</p><p>"+totalRow2+"</p><p>"+totalRow3+"</p><p>"+totalRow4+"</p>";
				var str = "<TABLE borderColor=#000000 width='100%' bgColor=#ffffff border=1 cellSpacing=0 cellPadding=0><TBODY>";
				str = str + "<TR bgColor=#D2E9FF><TD></TD><TD>名称</TD><TD>量</TD></TR>";
				var totalRow2Arr = totalRow2.split(";");
				str = str + "<TR><TD bgColor=#D2E9FF rowSpan=" + (totalRow2Arr.length - 1) + ">入液量分项</TD><TD>" + totalRow2Arr[0].replace(":", "</TD><TD>") + "</TD></TR>";
				for (var i = 1; i < (totalRow2Arr.length - 1); i++) {
					str = str + "<TR><TD>" + totalRow2Arr[i].replace(":", "</TD><TD>") + "</TD></TR>";
				}
				var totalRow4Arr = totalRow4.split(";");
				str = str + "<TR><TD bgColor=#D2E9FF rowSpan=" + (totalRow4Arr.length - 1) + ">出液量分项</TD><TD>" + totalRow4Arr[0].replace(":", "</TD><TD>") + "</TD></TR>";
				for (var i = 1; i < (totalRow4Arr.length - 1); i++) {
					str = str + "<TR><TD>" + totalRow4Arr[i].replace(":", "</TD><TD>") + "</TD></TR>";
				}
				str = str + "</TBODY></TABLE>";
				var rowEl = Ext.get(e.getTarget()); //把target转换成Ext.Element对象
				rowEl.set({
					'ext:qtip': str //设置它的tip属性
				}, false);
			}*/
		}
	});
	Ext.QuickTips.init(); //注意，提示初始化必须要有
	grid.getStore().on('load', function (s, records) {
		var girdcount = 0;
		s.each(function (r) {
			if (r.get(DisplaySumInName.split("!")[0]) == '总入液量=') {
				grid.getView().getRow(girdcount).style.backgroundColor = '#F7FE2E';
			}
			if (r.get(DisplaySumInName.split("!")[0]) == '入液量=') {
				grid.getView().getRow(girdcount).style.backgroundColor = '#A7FE2E';
			}
			girdcount = girdcount + 1;
		});
		//scope:this
	});

	setTimeout("find()", 0)
	setcolor(grid) //续打设置颜色
	//debugger;
	oriTitle = grid.title;

	if (BFHeadDr != 0) {
		//var lastpage = tkMakeServerCall("web.DHCNurHCRecComm","getlastrec", EpisodeID,EmrCode,BFHeadDr,"Item40");
		//alert(lastpage)
		//var curpage= Ext.getCmp("curpage");
		//curpage.setValue(lastpage)
	} else {
		//var curpage= Ext.getCmp("curpage");
		// curpage.setValue("1")

	}
	var GetCurrHeadDR = document.getElementById('GetCurrHeadDR');
	var ret = cspRunServerMethod(GetCurrHeadDR.value, EpisodeID, session['LOGON.USERID'], EmrCode);
	//if (ret==""){alert("请先填写表头变更")}

	//护士签名查询条件默认的当前的用户
	//setDefaultNurse();
}

//该模板维护的空白项
var blankstr = tkMakeServerCall("NurEmr.webheadchange", "GetMoldelBlankStr", EmrCode)
//alert(blankstr)
var selecteditem = "" //选中的需要变表头的列
var selecteditemid = ""
var selectedrow = "" //选中行
var curpositionofX = 0;
var curpositionofY = 0;
//表头项
var itemdata = new Array();

function addbtiem(a, b) {
	//alert(a)
	itemdata.push({
		ids: a,
		des: b
	});
}
var storeitem = new Ext.data.JsonStore({
	data: itemdata,
	fields: ['ids', 'des']
});
var BTItem = new Ext.form.ComboBox({
	id: 'BTItem',
	x: 5,
	y: 5,
	hiddenName: 'btitem',
	store: storeitem,
	width: 125,
	fieldLabel: '表头名称',
	valueField: 'ids',
	displayField: 'des',
	allowBlank: true,
	mode: 'local',
	anchor: '100%'
});

var DHCNURSELECTBTT101 = new Ext.data.JsonStore({
	data: [],
	fields: ['Item31', 'Item32', 'Item33', 'Item34']
});

function headclick(ct, column, direction, Object) {
	if (selecteditem == "") return
	//alert(CurrHeadDr)
	var flag = tkMakeServerCall("NurEmr.webheadchange", "Ifcurheaditemsaved", EmrCode, EpisodeID, CurrHeadDr, selecteditemid)
	if (flag != "") //改表头下改列已经保存过数据不允许修改表头
	{
		alert("当前表头下选中列已经保存过数据，不允许修改表头！")
		return
	}
	myId = "";
	var arr = new Array();
	//var a = cspRunServerMethod(pdata1, "", "DHCNURSELECTBT", EpisodeID, "");   
	//arr = eval(a);
	var window1 = new Ext.Window({
		title: '',
		width: 160,
		height: 100,
		x: curpositionofX,
		y: curpositionofY,
		autoScroll: true,
		layout: 'absolute',
		// plain: true,
		// modal: true,
		// bodyStyle: 'padding:5px;',
		// /buttonAlign: 'center',
		items: [new Ext.form.ComboBox({
			id: 'BTItem2',
			x: 5,
			y: 5,
			hiddenName: 'btitem',
			store: storeitem,
			width: 125,
			fieldLabel: '表头名称',
			valueField: 'ids',
			displayField: 'des',
			triggerAction: "all",
			allowBlank: true,
			mode: 'local',
			anchor: '100%'
		})],
		buttons: [{
			text: '确定',
			handler: function () {
				var val = Ext.getCmp("BTItem2").getValue()
				//alert(CurrHeadDr)
				var ret = tkMakeServerCall("NurEmr.webheadchange", "SaveCurHeadItem", EpisodeID, EmrCode, session['LOGON.USERID'], CurrHeadDr, selecteditemid, val)
				selecteditemid = ""
				self.location.reload();
			}
		}, {
			text: '取消',
			handler: function () {
				window1.close();
			}
		}]
	});
	window1.show();
	var objitm = Ext.getCmp("BTItem2");
	itemdata = new Array()
	tkMakeServerCall("NurEmr.webheadchange", "GetHeadItems", EmrCode, session['LOGON.CTLOCID'], 'addbtiem')
	objitm.store.loadData(itemdata);
	selecteditem = ""
	//alert(CurrHeadDr)

}

function beforeEditFn(e) {
	grid.rowIndex = e.row; //得到当前的行
	grid.columnIndex = e.column; //得到当前的列
}

///判断收缩压大于舒张压 yjn 20171021
function afterEditFn(e) {
	if (e.column == 5) {
		grid.getSelectionModel().selectRow(e.row);
		var itmPre = grid.colModel.getCellEditor(e.column, e.row).field;
		var valPre = itmPre.getValue();
		if (valPre.indexOf('/') < 0) {
			alert("血压格式为“收缩压/舒张压”");
			grid.getSelectionModel().getSelected().set("Item4", "");
			//grid.startEditing(e.row,e.column);
			return;
		}
		var valSS = valPre.split('/')[0];
		var valSZ = valPre.split('/')[1];
		if (parseInt(valSS) < parseInt(valSZ)) {
			alert("收缩压应大于舒张压！");
			grid.getSelectionModel().getSelected().set("Item4", "");
			//grid.startEditing(e.row,e.column);
			return;
		}
	}
	var curfield = e.field;
	var curvalue = e.value;
	if (blankstr != "") //是空白列
	{
		var straa = blankstr.split('^')
		for (aai = 0; aai < straa.length; aai++) {
			var aaitme = straa[aai]
			if (aaitme == "") continue
			if (aaitme == curfield) {
				if (curvalue != "") {
					if (CurrHeadDr == "") {
						alert("请先设置该列表头再录入数据")
						selectedrow.set(curfield, "")
						find()
						return
						//find()
					} else {

						var flag = tkMakeServerCall("NurEmr.webheadchange", "getcurheaditmname", EmrCode, curfield, CurrHeadDr)
						if (flag == "") {
							alert("请先设置该列表头再录入数据")
							selectedrow.set(curfield, "")
							find()
							return
							//	find()
						}
					}
				}

			}

		}
	}
}

var storespechar = new Array();
function SepcialChar() {
	var grid2 = new Ext.grid.GridPanel({
		id: 'mygridspecchar',
		name: 'mygridspecchar',
		title: '',
		stripeRows: true,
		height: 350,
		width: 120,
		tbar: [{
			id: 'insertBtn',
			handler: insertSpecChar,
			text: '插入'
		}, '-', {
			id: 'replaceBtn',
			handler: replaceSpecChar,
			text: '替换'
		}],
		store: new Ext.data.JsonStore({
			data: [],
			fields: ['desc', 'rw']
		}),
		colModel: new Ext.grid.ColumnModel({
			columns: [{
				header: '特珠字符',
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
		readOnly: false,
		viewConfig: {
			forceFit: false
		}
	});
	grid2.addListener('rowdblclick', insertSpecChar);
	storespechar = new Array();
	var GetQueryData = document.getElementById('GetQueryData1');
	//alert(GetQueryData)
	var parr = "";
	var a = cspRunServerMethod(GetQueryData.value, "User.DHCTEMPSPECIALCHAR:CRItem", "", "AddSpecChar");
	grid2.store.loadData(storespechar);
	var window = new Ext.Window({
		title: '特殊字符',
		
		width: 138,
		height: 350,
		x: 400,
		y: 200,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: grid2,
		listeners: {
			'close': function () {
				if (Ext.getCmp('mygrid').rowIndex > 0) Ext.getCmp('mygrid').startEditing(Ext.getCmp('mygrid').rowIndex, Ext.getCmp('mygrid').columnIndex);
			}
		}
	});
	window.show();
}

function AddSpecChar(str) {
	var obj = eval('(' + str + ')');
	storespechar.push(obj);
}

function SpecCharFn(flag) {
	var grid = Ext.getCmp('mygridspecchar');
	//弹出界面中Grid
	var selModel = grid.getSelectionModel();
	if (selModel.hasSelection()) {
		var selections = selModel.getSelections();

		var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
		if (rowIndex < 0) return;
		var specchardesc = grid.store.getAt(rowIndex).data.desc;
		var mygrid = Ext.getCmp('mygrid');
					if (insrtCurrentId != "") {
				var insertObj = Ext.getCmp(insrtCurrentId);
				//弹窗位置显示在外层 add by yjn
				if(window.frames[0]){
					insertObj = window.frames[0].Ext.getCmp(insrtCurrentId);
					//window.frames[0].InserTextComm(specchardesc);
					//return;
				}
				//add 替换功能
				e1= window.frames[0].document.getElementById(insrtCurrentId);
				FOUCSPOSTION = e1.selectionStart;
				FOUCSPOSTIONEnd = e1.selectionEnd;
				//add end
				var itemValue = insertObj.getValue();
				var itemValueStrat = "";
				var itemValueEnd = "";
				if (itemValue != "") {
					itemValueStrat = itemValue.substring(0, FOUCSPOSTION);
					//itemValueEnd = itemValue.substring(FOUCSPOSTION);
				}
				if (flag == "I") {
					itemValueEnd = itemValue.substring(FOUCSPOSTION);
					insertObj.setValue(itemValueStrat + specchardesc + itemValueEnd);
				}else{
					//insertObj.setValue(specchardesc );
					
					//add 替换功能
					itemValueEnd = itemValue.substring(FOUCSPOSTIONEnd);
					insertObj.setValue(itemValueStrat + specchardesc + itemValueEnd);
					//add end
				}
				
			}else{
				alert("请先选择要插入的位置!");
				return;
			}
		return;	
		if (mygrid.getSelectionModel().hasSelection()) { } else {
			
			if (insrtCurrentId != "") {
				var insertObj = Ext.getCmp(insrtCurrentId);
				//弹窗位置显示在外层 add by yjn
				if(window.frames[0]){
					insertObj = window.frames[0].Ext.getCmp(insrtCurrentId);
				}
				var itemValue = insertObj.getValue();
				var itemValueStrat = "";
				var itemValueEnd = "";
				if (itemValue != "") {
					itemValueStrat = itemValue.substring(0, FOUCSPOSTION);
					itemValueEnd = itemValue.substring(FOUCSPOSTION);
				}
				if (flag == "I") {
					insertObj.setValue(itemValueStrat + specchardesc + itemValueEnd);
				}else{
					insertObj.setValue(specchardesc );
				}
				
			}else{
				alert("请先选择要插入的位置!");
				return;
			}
				
		}
		var oldStr = mygrid.store.getAt(mygrid.rowIndex).get(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex));
		if (oldStr) {
			if (flag == "I") {
				specchardesc = oldStr + specchardesc;
			}
		}
		//mygrid.store.getAt(mygrid.rowIndex).set(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex), specchardesc);
		mygrid.startEditing(mygrid.rowIndex, mygrid.columnIndex);
	}
}

function insertSpecChar() {
	SpecCharFn("I");
}

function replaceSpecChar() {
	SpecCharFn("R");
}
var REC = new Array();

function PrintSet() {
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURXPRNSET", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		width: 750,
		height: 250,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	var but2 = Ext.getCmp('xpprnsetbut2');
	but2.hide();
	var butin = Ext.getCmp('xpprnsetbut1');
	butin.text = "确定";
	//debugger;
	butin.on('click', xpprnsetSave);
	window.show();

	var GetNurPrnSet = document.getElementById('GetNurPrnSet');
	var mygrid = Ext.getCmp("xpprnset");
	//alert(parr);
	// debugger;
	REC = new Array();
	var a = cspRunServerMethod(GetNurPrnSet.value, EmrCode, EpisodeID, 'addprnset');
	mygrid.store.loadData(REC);


}

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

function xpprnsetSave() {
	var mygrid = Ext.getCmp("xpprnset");
	var store = mygrid.store;
	//alert(parr);
	var SavePrnSet = document.getElementById('SPrnSet');

	var list = [];
	for (var i = 0; i < store.getCount(); i++) {

		list.push(store.getAt(i).data);
		//	debugger;
	}
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		var str = "";
		for (var p in obj) {
			var aa = formatDate(obj[p]);
			if (p == "")
				continue;
			if (aa == "") {

				str = str + p + "|" + obj[p] + '^';
			} else {
				str = str + p + "|" + aa + '^';
			}

		}
		var a = cspRunServerMethod(SavePrnSet.value, str); //page, caredattim, prnpos, adm,Typ,user
	}
}

function addtitCon(tobar, lab) {
	var but1 = Ext.getCmp(lab + "but1");
	but1.hide();
	var but2 = Ext.getCmp(lab + "but2");
	but2.hide();

	tobar.addItem({
		xtype: 'datefield',
		format: 'Y-m-d',
		id: lab + 'stdate',
		value: (diffDate(new Date(), -1))
	}, {
			xtype: 'datefield',
			format: 'Y-m-d',
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
	MeasureRel = new Hashtable();
	REC = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var IfCancelRec = ""  // Ext.getCmp("IfCancelRec").getValue();
	var nurseSign = Ext.getCmp("nurseSign").getValue();
	var parr = adm + "^" + StDate.value + "^" + StTime.value + "^" + Enddate.value + "^" + EndTime.value + "^" + EmrCode + "^" + IfCancelRec;
	var parr = parr + "^" + nurseSign + "^" + CurrHeadDr;   // 后面拼表头永远QUERY筛选表头 by lmm 20171222
	// debugger;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurRecComm:GetCareRecComm", "parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
	setcolor(grid) //续打设置颜色
}

function findStat() { //查询出入液量合计
	var adm = EpisodeID;
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var GeInOutAmount = document.getElementById('GeInOutAmount');
	var mygrid = Ext.getCmp("mygrid");

	//var parr=adm+"^"+StDate.value+"^"+StTime.value+"^"+Enddate.value+"^"+EndTime.value+"^";
	//alert(parr);
	//debugger;
	var a = cspRunServerMethod(GeInOutAmount.value, adm, StDate.value, StTime.value, Enddate.value, EndTime.value, EmrCode);
	if (a == "") {
		Ext.Msg.alert('提示', "无护理记录数据!");
		return;
	}
	//additm();
	additmstat(Enddate.value, EndTime.value);
	var tt = a.split('^');
	//alert(tt);
	mygrid.getSelectionModel().selectRow(mygrid.store.getCount() - 1);
	mygrid.getSelectionModel().getSelections()[0].set(DisplaySumInName, "入液量合计=");
	mygrid.getSelectionModel().getSelections()[0].set(DisplaySumInAmount, tt[0]);
	mygrid.getSelectionModel().getSelections()[0].set(DisplaySumOutName, "出液量合计=");
	mygrid.getSelectionModel().getSelections()[0].set(DisplaySumOutAmount, tt[1]);
	mygrid.getSelectionModel().getSelections()[0].set(PartInName, "入液量分项=");
	mygrid.getSelectionModel().getSelections()[0].set(PartInAmount, tt[2]);
	mygrid.getSelectionModel().getSelections()[0].set(PartOutName, "出液量分项=");
	mygrid.getSelectionModel().getSelections()[0].set(PartOutAmount, tt[3]);
	//mygrid.getSelectionModel().getSelections()[0].set("Item1",tt[4]);
	//mygrid.getSelectionModel().getSelections()[0].set("Item2",tt[5]);
	mygrid.getSelectionModel().getSelections()[0].set("CaseMeasure", tt[4] + " " + tt[5]);
	//OutQtAmount:a2,
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
	obj.CareDate = getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}

function test(record, rowIndex, rowParams, store) {
	//禁用数据显示红色   
	if (record.data.pstate != 0) {
		return 'x-grid-record-red';
	} else {
		return '';
	}

} //end for getRowClass  
///关联记录到体温单 by lmm
function LinkTemp() {
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	var grid1 = Ext.getCmp('mygrid');
	var rwIndex = grid1.getSelectionModel().last;
	var CaseMeasureID = "CaseMeasureID|";
	//debugger;
	if (MeasureRel.contains(rwIndex)) {
		var rid = MeasureRel.items(rwIndex);
		CaseMeasureID = CaseMeasureID + rid;
	}
	var RecSave = document.getElementById('RecSave');

	var recpar = "" //图片
	var recrw = "" //图片
	var TypeStr="";
	var QuantityStr="";
	
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		var str = "";
		var CareDate = "";
		var CareTime = "";
		var flag = "0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);
			if (p == "CareDate") CareDate = aa;
			if (p == 'CareTime') CareTime = obj[p];
			if (p == "par") recpar = obj[p] //图片
			if (p == "rw") recrw = obj[p] //图片
			if (p == "") continue;
			if ((p == DisplaySumInName) && (obj[p].indexOf("入液量") != -1)) {
				flag = "1";
			}
			if ((p == DisplaySumOutName) && (obj[p].indexOf("出液量") != -1)) {
				flag = "1";
			}
			if (aa == "") {
				if(p=='Item7')  {
					TypeStr=DBC2SBC(obj[p]);
					//return;
				}
				else if(p=='Item8')  {
					QuantityStr=DBC2SBC(obj[p]);
					//return;
				}
				else {
					str = str + p + "|" + DBC2SBC(obj[p]) + '^';
					if (p == "CareDate") CareDate =DBC2SBC(obj[p]);
					if (p == 'CareTime') CareTime = DBC2SBC(obj[p]);
					
					if (p == "par") recpar = DBC2SBC(obj[p]);
					if (p == "rw") recrw = DBC2SBC(obj[p]);
				}
				
			} else {
				str = str + p + "|" + aa + '^';
			}
		}
		if ((str != "") && (flag == "0")) {		
			if (str.indexOf("CareDate") == -1) {
				str = str + "CareDate|" + CareDate + "^CareTime|" + CareTime;
			}
			var diaggrid = Ext.getCmp('diaggrid');
			if (diaggrid) {
				var selModel = diaggrid.getSelectionModel();
				if (selModel.hasSelection()) {
					var objDiagRow = selModel.getSelections();
					DiagnosDr = objDiagRow[0].get("rw");
				} else {
					DiagnosDr = "";
				}
			} else {
				DiagnosDr = "";
			}
			str = str + "DiagnosDr|" + DiagnosDr;
			str = str + "^RecLoc|" + patloc + "^RecNurseLoc|" + session['LOGON.CTLOCID'] + "^RecBed|" + bedCode; //patloc是病人当前科室，如果打印时“科室”希望打印的是科室则用该句；
			str = str + "^" + CaseMeasureID;

			var recid = ""
			if ((recpar != "") && (recrw != "")) //图片
			{
				recid = recpar + "||" + recrw
			}

				if(TypeStr.split("^").length>1){
					//alert(1);
					var TypeArr=TypeStr.split("^")
					var QuantityArr=QuantityStr.split("^")
					var str1=str;
					for (var i=0;i<TypeArr.length;i++){
						if(i==0){
							str = str1 +"^Item7|"+TypeArr[i]+"^Item8|"+QuantityArr[i];
							var a = cspRunServerMethod(RecSave.value, EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
						}
						else{
							str="CareDate|" + CareDate + "^CareTime|" + CareTime;
							str = str + "^DiagnosDr|" + DiagnosDr;
							str = str + "^RecLoc|" + patloc + "^RecNurseLoc|" + session['LOGON.CTLOCID'] + "^RecBed|" + bedCode; //patloc是病人当前科室，如果打印时“科室”希望打印的是科室则用该句；
							str = str + "^" + CaseMeasureID;
							str = str +"^Item7|"+TypeArr[i]+"^Item8|"+QuantityArr[i];
							var a = tkMakeServerCall("Nur.CommonInterface.Temperature","LinkTemp", EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
						}
					}
					
				}
				else{
					str=str +"^Item7|"+TypeStr+"^Item8|"+QuantityStr;
					var a = tkMakeServerCall("Nur.CommonInterface.Temperature","LinkTemp", EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
				}
				if (a != "0") {
					alert(a);
					return;
				}else{
					alert("关联成功")
				}
		}
	}
}
function save() {
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	var grid1 = Ext.getCmp('mygrid');
	var rwIndex = grid1.getSelectionModel().last;
	var CaseMeasureID = "CaseMeasureID|";
	//debugger;
	if (MeasureRel.contains(rwIndex)) {
		var rid = MeasureRel.items(rwIndex);
		CaseMeasureID = CaseMeasureID + rid;
	}
	//for (var i = 0; i < store.getCount(); i++) {
	//	list.push(store.getAt(i).data);
	//	//	debugger;
	//}
	var RecSave = document.getElementById('RecSave');

	var recpar = "" //图片
	var recrw = "" //图片
	var TypeStr="";
	var QuantityStr="";
	
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		var str = "";
		var CareDate = "";
		var CareTime = "";
		var flag = "0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);
			if (p == "CareDate") CareDate = aa;
			if (p == 'CareTime') CareTime = obj[p];
			if (p == "par") recpar = obj[p] //图片
			if (p == "rw") recrw = obj[p] //图片
			if (p == "") continue;
			if ((p == DisplaySumInName) && (obj[p].indexOf("入液量") != -1)) {
				flag = "1";
			}
			if ((p == DisplaySumOutName) && (obj[p].indexOf("出液量") != -1)) {
				flag = "1";
			}
			if (aa == "") {
				if(p=='Item7')  {
					TypeStr=DBC2SBC(obj[p]);
					//return;
				}
				else if(p=='Item8')  {
					QuantityStr=DBC2SBC(obj[p]);
					//return;
				}
				else {
					str = str + p + "|" + DBC2SBC(obj[p]) + '^';
					if (p == "CareDate") CareDate =DBC2SBC(obj[p]);
					if (p == 'CareTime') CareTime = DBC2SBC(obj[p]);
					
					if (p == "par") recpar = DBC2SBC(obj[p]);
					if (p == "rw") recrw = DBC2SBC(obj[p]);
				}
				
			} else {
				str = str + p + "|" + aa + '^';
			}
		}
		if ((str != "") && (flag == "0")) {
			
			if (str.indexOf("CareDate") == -1) {
				//alert(str);
				str = str + "CareDate|" + CareDate + "^CareTime|" + CareTime;
				alert(str);
				//debugger;
			}
			var diaggrid = Ext.getCmp('diaggrid');
			if (diaggrid) {
				var selModel = diaggrid.getSelectionModel();
				if (selModel.hasSelection()) {
					var objDiagRow = selModel.getSelections();
					DiagnosDr = objDiagRow[0].get("rw");
				} else {
					DiagnosDr = "";
				}
			} else {
				DiagnosDr = "";
			}
			//alert(str);
			str = str + "DiagnosDr|" + DiagnosDr;
			str = str + "^RecLoc|" + patloc + "^RecNurseLoc|" + session['LOGON.CTLOCID'] + "^RecBed|" + bedCode; //patloc是病人当前科室，如果打印时“科室”希望打印的是科室则用该句；
			str = str + "^" + CaseMeasureID;
			//alert(str);
			var rtn=tkMakeServerCall("Nur.DHCNurseRecSub","JurgeTime",EpisodeID,CareDate,CareTime);
			var recid = ""
			if ((recpar != "") && (recrw != "")) //图片
			{
				recid = recpar + "||" + recrw
			}
			if((rtn==1)||(recid!="")){
				if(TypeStr.split("^").length>1){
					//alert(1);
					var TypeArr=TypeStr.split("^")
					var QuantityArr=QuantityStr.split("^")
					var str1=str;
					for (var i=0;i<TypeArr.length;i++){
						if(i==0){
							str = str1 +"^Item7|"+TypeArr[i]+"^Item8|"+QuantityArr[i];
							var a = cspRunServerMethod(RecSave.value, EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
						}
						else{
							str="CareDate|" + CareDate + "^CareTime|" + CareTime;
							str = str + "^DiagnosDr|" + DiagnosDr;
							str = str + "^RecLoc|" + patloc + "^RecNurseLoc|" + session['LOGON.CTLOCID'] + "^RecBed|" + bedCode; //patloc是病人当前科室，如果打印时“科室”希望打印的是科室则用该句；
							str = str + "^" + CaseMeasureID;
							str = str +"^Item7|"+TypeArr[i]+"^Item8|"+QuantityArr[i];
							var a = cspRunServerMethod(RecSave.value, EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
						}
					}
					
				}
				//alert(str);
				else{
					str=str +"^Item7|"+TypeStr+"^Item8|"+QuantityStr;
					//alert(str);
					var a = cspRunServerMethod(RecSave.value, EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
					}
				//var a = cspRunServerMethod(RecSave.value, EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
				if (i == (list.length - 1)) {
					if (IfMakePic == "Y") {
						var page = tkMakeServerCall("NurEmr.webheadchange", "getheadpagerow", EpisodeID, EmrCode, recid, "", CareDate, CareTime) //图片		   
						//alert(page)			   
						MakePicture(page) //生成图片
					}
				}
				//alert(recid)

				if (a != "0") {
					alert(a);
					return;
				}
			}
			else {
				alert("同一时间无法建立两条护理记录！")
			}
		}
	}
	find();
	parent.window.initMainTree();
	//setTimeout("find()", 0);
	//setcolor(grid); //续打设置颜色
}
//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
function gettime() {
	var a = Ext.util.Format.dateRenderer('h:m');
	return a;
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

function additm() {
	var Plant = Ext.data.Record.create([{
		name: 'CareDate'
	}, {
		name: 'CareTime'
	}, {
		name: 'Item1'
	}, {
		name: 'Item2'
	}, {
		name: 'Item3'
	}, {
		name: 'Item4'
	}, {
		name: 'Item5'
	}, {
		name: 'Item6'
	}, {
		name: 'Item7'
	}, {
		name: 'Item8'
	}, {
		name: 'Item9'
	}, {
		name: 'Item10'
	}, {
		name: 'Item11'
	}, {
		name: 'Item12'
	}, {
		name: 'Item13'
	}, {
		name: 'Item14'
	}, {
		name: 'Item15'
	}, {
		name: 'Item16'
	}, {
		name: 'Item17'
	}, {
		name: 'Item18'
	}, {
		name: 'Item19'
	}, {
		name: 'Item20'
	}, {
		name: 'Item21'
	}, {
		name: 'Item22'
	}, {
		name: 'Item23'
	}, {
		name: 'Item24'
	}, {
		name: 'Item25'
	}, {
		name: 'Item26'
	}, {
		name: 'Item27'
	}, {
		name: 'Item28'
	}, {
		name: 'Item29'
	}, {
		name: 'Item30'
	}, {
		name: 'Item31'
	}, {
		name: 'Item32'
	}, {
		name: 'Item33'
	}, {
		name: 'Item34'
	}, {
		name: 'Item35'
	}, {
		name: 'Item36'
	}, {
		name: 'Item37'
	}, {
		name: 'Item38'
	}, {
		name: 'Item39'
	}, {
		name: 'Item40'
	}, {
		name: 'Item41'
	}, {
		name: 'Item42'
	}, {
		name: 'Item43'
	}, {
		name: 'Item44'
	}, {
		name: 'Item45'
	}, {
		name: 'Item46'
	}, {
		name: 'Item47'
	}, {
		name: 'Item48'
	}, {
		name: 'Item49'
	}, {
		name: 'Item50'
	}, {
		name: 'CaseMeasure'
	}, {
		name: 'User'
	}, {
		name: 'rw'
	}, {
		name: 'par'
	}]);
	var count = grid.store.getCount();
	var r = new Plant({
		CareDate: new Date(),
		CareTime: new Date().dateFormat('H:i')
	});
	grid.store.commitChanges();
	grid.store.insert(0, r);

	//新建后自动选中行并聚焦 add by yjn
	grid.getSelectionModel().selectRow(0);
	window.frames[0].Ext.getCmp("Item1").focus();

	return;
}
/*
var rightClick = new Ext.menu.Menu({
	id: 'rightClickCont',
	items: [{
			text: '知识库',
			handler: LinkKnow
		}, {
			text: '检验结果',
			handler: LinkResult
		}, {
			id: 'rMenu1',
			text: '医嘱',
			handler: OrdSch
				//handler:opentam2
		},
		//,  {
		//    id:'rMenu2',
		//    text : '病情措施及处理',
		//    handler:Measure
		// }
		{
			id: 'rMenu3',
			text: '病情措施及处理', //新调用
			handler: MeasureNew
		}, {
			id: 'rMenu2',
			text: '补打设置',
			handler: SetXu
		}, {
			id: 'rMenu6',
			text: '修改关联科室床号',
			handler: ChangLocBed
		},
		/*
		 {
			id:'rMenu4',
			text : '插入出入液量小结',
			handler:InOutNod
		},  {
			id:'rMenu5',
			text : '插入24小时出入液量',
			handler:InOutSum
		},  {
			id:'rMenu6',
			text : '修改关联诊断',
			handler:UpdateRelDiagnos
		},  
		
		{
			id: 'rMenu7',
			text: '删除',
			handler: CancelRecord
		}
	]
});
*/
function rightClickFn(client, rowIndex, e) {
	e.preventDefault();
	grid = client;
	CurrRowIndex = rowIndex;
	rightClick.showAt(e.getXY());
}

function rowClickFn(grid, rowIndex, e) {
	//alert('你单击了' + rowIndex);
	var selRow = grid.getSelectionModel().getSelected();
	var nurseName = "护士签名:" + selRow.get("User");
	if (nurseName != "") {
		grid.setTitle(nurseName + " " + oriTitle);
	}
}
//南方医院 竖向录入
function rowSelectFn(selectModel, rowIndex) {
	var selRow = selectModel.getSelected();
	var iframe = document.querySelector("iframe[name='JLDInVerticalModle']");
	if (iframe && window.frames[0] && window.frames[0].setValue) {
		window.frames[0].setValue(selectModel);
	}
}
//南方医院 竖向录入

function ChangLocBed() {

	grid = Ext.getCmp('mygrid');
	var selModel = grid.getSelectionModel();
	var ret = "";
	if (selModel.hasSelection()) {
		var selections = selModel.getSelections();
		Ext.each(selections, function (item) {
			var par = item.data.par;
			var rw = item.data.rw;
			if (par != undefined) {
				if (ret == "") ret = par + "||" + rw
				else {
					ret = ret + "^" + par + "||" + rw
				}
			}

		})
	}
	//alert(ret)
	var objRow = grid.getSelectionModel().getSelections();

	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条护理记录!");
		return;
	}
	if (ret == "") return
	Rowid = ret;
	Prnloctype = "W"; //选择病区：W  ; 选择的是科室：L
	var lnk = "DHCNurEmrComm.csp?EmrCode=DHCNURSZZY_LocBedLink" + "&Rowid=" + Rowid + "&EpisodeID=" + EpisodeID + "&Prnloctype=" + Prnloctype //+rowid;
	//注意dhcnuremrcomm.csp大小写，一般是DHCNurEmrComm.csp
	window.open(lnk, "OrdExec1222", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=200,width=530,top=100,left=300");
}

//续打说明
function XuInt() {
	var lnk = WebIp + "/dhcmg/续打使用说明.doc"
	wind22 = window.open(lnk, "htmi", 'left=10,toolbar=no,location=no,directories=no,resizable=yes,width=1200,height=700');
}

//续打  测试
function printNurRecXuTest() {
	var GetPrnSet = document.getElementById('GetPrnSet');
	var GetHead = document.getElementById('GetPatInfo');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	var a = cspRunServerMethod(GetPrnSet.value, EmrCode, EpisodeID); //page, caredattim, prnpos, adm,Typ,user
	if (a == "") return;
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, EmrCode + "^" + session['LOGON.CTLOCID']);
	var tm = a.split("^");
	var stdate = "" //tm[2];
	var stim = "" //tm[3];
	var edate = "" //tm[4];
	var etim = "" //tm[5];
	PrintCommPic.RHeadCaption = hh[1];
	PrintCommPic.LHeadCaption = hh[0];
	PrintCommPic.TitleStr = ret;
	PrintCommPic.LFootCaption = hh[2];
	PrintCommPic.SetPreView("1"); //打印时是否预览：1预览，0不预览
	PrintCommPic.PrnLoc = session['LOGON.CTLOCID']; //如果没更新转科这句放开
	//PrintCommPic.PrnLoc=patloc ;  //转科打印时设置床号 如果没更新转科这句屏蔽
	PrintCommPic.PrnBed = bedCode; //转科打印时设置床号  如果没更新转科这句屏蔽
	PrintCommPic.tranflag = "1" //转科打印设置:0不启用 1启用转科打印
	PrintCommPic.SplitPage = "1" //转科是否换页
	PrintCommPic.dxflag = 0 //分割线设置：1一条记录打印一条线 0 一行打印一条线		
	PrintCommPic.xuflag = 1; //续打配置：1启用续打 0 普通全部打印	
	PrintCommPic.previewPrint = "0"; //是否弹出设置界面:0不弹出，1弹出
	PrintCommPic.ItmName = prncode; //打印模板名称取的是配置
	PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	PrintCommPic.stprintpos = 0;
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode + "!"; //注意不要少了最后一个！
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	//PrintCommPic.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;	//混合模板打印	
	if (LabHead != "") PrintCommPic.LabHead = LabHead;
	PrintCommPic.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
	PrintCommPic.PrintOut();
	setTimeout("find()", 0)
	setcolor(grid) //续打设置颜色	
}
//续打
function printNurRecXu() {
	var GetPrnSet = document.getElementById('GetPrnSet');
	var GetHead = document.getElementById('GetPatInfo');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	var a = cspRunServerMethod(GetPrnSet.value, EmrCode, EpisodeID); //page, caredattim, prnpos, adm,Typ,user
	if (a == "") return;
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, EmrCode + "^" + session['LOGON.CTLOCID']);
	var tm = a.split("^");
	var stdate = "" //tm[2];
	var stim = "" //tm[3];
	var edate = "" //tm[4];
	var etim = "" //tm[5];
	PrintCommPic.RHeadCaption = hh[1];
	PrintCommPic.LHeadCaption = hh[0];
	PrintCommPic.TitleStr = ret;
	PrintCommPic.LFootCaption = hh[2];
	PrintCommPic.SetPreView("1"); //打印时是否预览：1预览，0不预览
	PrintCommPic.PrnLoc = session['LOGON.CTLOCID']; //如果没更新转科这句放开
	PrintCommPic.PrnLoc = patloc; //转科打印时设置床号 如果没更新转科这句屏蔽
	PrintCommPic.PrnBed = bedCode; //转科打印时设置床号  如果没更新转科这句屏蔽
	PrintCommPic.tranflag = "1" //转科打印设置:0不启用 1启用转科打印
	PrintCommPic.SplitPage = "1" //转科是否换页
	PrintCommPic.dxflag = 0 //分割线设置：1一条记录打印一条线 0 一行打印一条线		
	PrintCommPic.xuflag = 1; //续打配置：1启用续打 0 普通全部打印	
	PrintCommPic.previewPrint = "0"; //是否弹出设置界面:0不弹出，1弹出
	PrintCommPic.ItmName = prncode; //打印模板名称取的是配置
	PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	PrintCommPic.stprintpos = 0;
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode + "!"; //注意不要少了最后一个！
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	//PrintCommPic.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;	//混合模板打印	
	if (LabHead != "") PrintCommPic.LabHead = LabHead;
	PrintCommPic.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
	PrintCommPic.PrintOut();
	setTimeout("find()", 0)
	setcolor(grid) //续打设置颜色	
}
//设置续打起始位置
function SetXu() {
	if ((StartLock != "1") || (prnmode == "")) //没有开启续打
	{
		return;
	}
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length > 0) { } else {
		Ext.Msg.alert('提示', "请先选择一条记录!");
		return;
	}
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNUR_SetXu", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '补打设置',
		width: 320,
		height: 200,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	var idrw = objRow[0].get("rw");
	var idpar = objRow[0].get("par");
	if (idpar == undefined) {
		alert("请选择已保存过得记录!");
		find()
		return;
	}
	var User = objRow[0].get("User");
	var CareDate = objRow[0].get("CareDate");
	var CareTime = objRow[0].get("CareTime");
	var select = Ext.getCmp('sel');
	var select2 = Ext.getCmp('page')
	var select3 = Ext.getCmp('row')
	var hnum = Ext.getCmp('hnum')
	var pflag = Ext.getCmp('pflag')
	pflag.disable()
	hnum.disable()
	select.disable()
	select.setValue(formatDate(CareDate) + "/" + (CareTime) + "/" + User)
	var but = Ext.getCmp('butSave');
	but.on('click', SaveSetXu);
	var but2 = Ext.getCmp('Cancel');
	but2.on('click', Cancel);
	var id = idpar + "&" + idrw
	var info = tkMakeServerCall("Nur.DHCNurRecPrint", "getval", id)
	var infoST = tkMakeServerCall("Nur.DHCNurRecPrintStPos", "getval", EpisodeID + "&" + prncode)
	var arr
	if (infoST != "") {
		arr = infoST.split('^')
		var nowid = idpar + "||" + idrw
		if (arr[0] != nowid) //选中行不是续打记录最后一条
		{
			if (info != "") {
				var arr2 = info.split('^')
				if (arr2[1] != "") //已打印
				{
					var pp2 = parseInt(arr2[1]) + parseInt(1)
					var rr2 = parseInt(arr2[2]) + parseInt(1)
					select2.setValue(pp2)
					select3.setValue(rr2)
					var hstr = rr2 + parseInt(arr2[3]) - parseInt(1) + "行(该条记录占" + arr2[3] + "行)"
					hnum.setValue(hstr)
					pflag.setValue("已打印")
				} else {
					pflag.setValue("未打印")
				}
			} else {
				pflag.setValue("未打印")
			}
		} else {
			if (arr[3] == "0") //从该条开始打印
			{
				var pp = parseInt(arr[1]) + parseInt(1)
				var rr = parseInt(arr[2]) + parseInt(1)
				select2.setValue(pp)
				select3.setValue(rr)
				if (arr[4] != "") {
					var hstr2 = parseInt(arr[2]) + parseInt(arr[4]) + "行(该条记录占" + arr[4] + "行)"
					hnum.setValue(hstr2)
				}
				pflag.setValue("未打印")
			}
			if (arr[3] == "1") //该条已经打印
			{
				var pp2 = parseInt(arr[1]) + parseInt(1)
				var rr2 = parseInt(arr[2]) - parseInt(arr[4]) + parseInt(1)
				select2.setValue(pp2)
				select3.setValue(rr2)
				var hstr3 = arr[2] + "行(该条记录占" + arr[4] + "行)"
				hnum.setValue(hstr3)
				pflag.setValue("已打印")
			}
		}

		if (arr[5] != undefined) {
			var pstrs = pflag.getValue() + "(每页可打印" + arr[5] + "行)"
			pflag.setValue(pstrs)
		}
	} else {
		pflag.setValue("未打印")
	}
	window.show();

	function Cancel() {
		window.close()
	}

	function SaveSetXu() {

		var pages = select2.getValue()
		var rows = select3.getValue()
		//alert(arr[5])
		if ((pages == "") || (rows == "")) {
			alert("开始页码和行数都不能为空!");
			return;
		}
		if (isNaN(pages)) {
			alert("页码请录入数字!");
			return;
		}
		if (isNaN(rows)) {
			alert("行数请录入数字!");
			return;
		}
		if ((parseInt(pages) < 1) || (parseInt(rows) < 1) || (parseInt(rows) > parseInt(arr[5]))) {
			alert("页码或行数必须大于0!" + "小于等于" + arr[5] + "行");
			return;
		}
		var stpage = parseInt(pages) - parseInt(1)
		var strow = parseInt(rows) - parseInt(1)
		var str = id + "^" + stpage + "^" + strow + "^^^^^"
		var ret = tkMakeServerCall("Nur.DHCNurRecPrintStPos", "Save", str, EpisodeID, prncode, "0")
		if (ret == "0") {
			Ext.Msg.show({
				title: '确认一下',
				msg: '设置成功! 您要开始续打吗？',
				buttons: {
					"ok": "是     ",
					"cancel": "  否"
				},
				fn: function (btn, text) {
					if (btn == 'ok') {
						printNurRecXu()
					} else { }
				},
				animEl: 'newbutton'
			});
			window.close()
			setTimeout("find()", 0)
			setcolor(grid)
		}
		//alert(ret)	  
	}

}


//续打设置颜色
function setcolor(grid) {
	if ((StartLock != "1") || (prnmode == "")) //没有开启续打
	{
		return;
	}
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var mygrid = Ext.getCmp("mygrid");
	var params = EpisodeID + "&" + prncode + "&" + StDate.value + "&" + StTime.value.replace(":", "*") + "&" + Enddate.value + "&" + EndTime.value.replace(":", "*")
	printinfo = tkMakeServerCall("Nur.DHCNurRecPrint", "getprintinfo", params)
	printarr = printinfo.split('&')
	//alert(printarr)
	printinfoST = tkMakeServerCall("Nur.DHCNurRecPrintStPos", "getval", EpisodeID + "&" + prncode + "&")
	printarrST = printinfoST.split('^')
	grid.getStore().on('load', function (s, records) {
		var girdcount = 0;
		s.each(function (r) {
			var rowid = r.get("par") + "||" + r.get("rw")
			if (printinfoST != "") {
				//alert(printinfoST[0]) 
				//alert(rowid) 
				if (rowid != printarrST[0]) {
					if (printarr[2].indexOf(rowid) > -1) //该条记录有修改
					{
						grid.getView().getRow(girdcount).style.backgroundColor = havechangecolor;
					} else if (r.get(DisplaySumInName.split("!")[0]) == '总入液量=') {
						grid.getView().getRow(girdcount).style.backgroundColor = '#F7FE2E';
					} else if (r.get(DisplaySumInName.split("!")[0]) == '入液量=') {
						grid.getView().getRow(girdcount).style.backgroundColor = '#A7FE2E';
					} else if (printarr[0].indexOf(rowid) > -1) //该条记录已打印
					{
						grid.getView().getRow(girdcount).style.backgroundColor = printcolor;
					} else if (printarr[1].indexOf(rowid) > -1) //该条记录未打印
					{
						grid.getView().getRow(girdcount).style.backgroundColor = noprintcolor;
					}

				} else //打印记录索引行
				{
					var pinfo = tkMakeServerCall("Nur.DHCNurRecPrint", "getval", r.get("par") + "&" + r.get("rw"))
					var pprr = pinfo.split('^');
					if (pprr[4] == "2") { //该条有修改
						grid.getView().getRow(girdcount).style.backgroundColor = havechangecolor;
					} else if (r.get(DisplaySumInName.split("!")[0]) == '总入液量=') {
						grid.getView().getRow(girdcount).style.backgroundColor = '#F7FE2E';
					} else if (r.get(DisplaySumInName.split("!")[0]) == '入液量=') {
						grid.getView().getRow(girdcount).style.backgroundColor = '#A7FE2E';
					} else if (printarrST[3] == "0") {
						grid.getView().getRow(girdcount).style.backgroundColor = Startcolor;
					} else {
						grid.getView().getRow(girdcount).style.backgroundColor = printcolor;
					}
				}
			}
			girdcount = girdcount + 1;
		});
		//scope:this
	});
}

function MultiFun() {
	var GetMulti = document.getElementById('GetMulti');
	var getcheckform = document.getElementById('getcheckform');
	var ret = cspRunServerMethod(GetMulti.value, EmrCode);
	var grid = Ext.getCmp('mygrid');
	var tt = ret.split('^');
	var ab = "";
	for (i = 0; i < tt.length; i++) {
		if (tt[i] == "") continue;
		//debugger;
		var dd = grid.getSelectionModel().getSelections()[0].get(tt[i]);
		if (dd == undefined) dd = ""
		if (dd != "") ab = ab + dd + "^" + tt[i] + "!";
		else ab = ab + "^" + tt[i] + "!";
	}
	var tabstr = cspRunServerMethod(getcheckform.value, EmrCode, ab);
	var tabarr = tabstr.split('!');
	var tbitm = new Array();
	for (i = 0; i < tabarr.length; i++) {
		if (tabarr[i] == "")
			continue;
		var itmm = tabarr[i].split('^');
		tbitm.push({
			xtype: 'panel',
			id: itmm[0],
			title: itmm[1],
			//height: 1000,
			layout: 'absolute',
			//frame:false,
			//palin:false,
			closable: false,
			items: eval(itmm[2])

		})
		//alert(itmm[2]);
	}
	var subttab = new Ext.TabPanel({
		activeTab: 0, //
		autoTabs: true,
		resizeTabs: true,
		//height:200,
		//  width:300,
		enableTabScroll: true,
		items: tbitm
	});

	var window = new Ext.Window({
		title: '多选',
		width: 450,
		height: 480,
		id: 'mulForm',
		autoScroll: true,
		layout: 'fit',
		plain: true,
		frame: true,
		items: subttab,
		buttons: [{
			id: 'mulselbut',
			text: '保存',
			handler: SaveMulCheck
		}]
	});

	window.show();


}
var checkret = "";

function SaveMulCheck() {
	checkret = "";
	var gform = Ext.getCmp("mulForm");
	gform.items.each(eachItem, this);
	var aa = checkret.split('^');
	var ht = new Hashtable();
	//debugger;
	for (i = 0; i < aa.length; i++) {
		if (aa[i] == "")
			continue;
		var itm = aa[i].split('|');
		var aitm = itm[0].split('_');
		if (ht.contains(aitm[0])) {
			var val = ht.items(aitm[0])
			ht.remove(aitm[0]);
			var dd = val + ";" + itm[1];
			ht.add(aitm[0], dd);
		} else {
			ht.add(aitm[0], itm[1])
		}
	}
	var mygrid = Ext.getCmp('mygrid');
	for (var i in ht.keys()) {
		var key = ht.keys()[i];
		var restr = ht.items(key);
		mygrid.getSelectionModel().getSelections()[0].set(key, restr);

	}
	alert(checkret);

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

function multiSel(ret) {
	var grid1 = Ext.getCmp('multigrid');
	var code = grid1.getSelectionModel().getSelections()[0].get("itm3");
	var itname = grid1.getSelectionModel().getSelections()[0].get("itm4");
	var getcheckform = document.getElementById('getcheckform');
	alert(itname + "!!" + code)
	var ret = cspRunServerMethod(getcheckform.value, EmrCode, itname, code, "");
	var CareDate = grid.getSelectionModel().getSelections()[0].get("CareDate");
	var aa = new Array();
	aa = eval(aa);
	/*
		debugger;
		for(var i=0;i<items.length;i++){ 

            panl.remove(items[i]); 

          } 
    
       panl.doLayout();
		panl.add(new Ext.form.Checkbox({    
                    id:"addboxModule",                
                    name:"userModule",
                    boxLabel : 'moduleName' 
                   }));*/

	panl.doLayout();
	debugger;


}

function addMulitm(ret) {
	var grid1 = Ext.getCmp('multigrid');
	var Plant = Ext.data.Record.create([{
		name: 'itm1'
	}, {
		name: 'itm2'
	}, {
		name: 'itm3'
	}, {
		name: 'itm4'
	}]);
	var itm = ret.split('^');
	for (i = 0; i < itm.length; i++) {
		if (itm[i] == "") continue;
		var aa = itm[i].split('!');
		var count = grid1.store.getCount();
		var r = new Plant({
			itm1: aa[0],
			itm2: "",
			itm3: aa[1],
			itm4: aa[2]
		});
		grid1.store.commitChanges();
		grid1.store.insert(count, r);
	}
	return;
}

//病情变化及处理措施新界面 201406
function MeasureNew() {

	MeasureRel = new Hashtable();
	var grid1 = Ext.getCmp('mygrid');
	var objRow = grid1.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条护理记录!");
		return;
	}
	var par = grid1.getSelectionModel().getSelections()[0].get("par");
	var rw = grid1.getSelectionModel().getSelections()[0].get("rw");
	var rowid = par + "||" + rw;
	if (par == undefined) {
		rowid = "";
	}
	var parr = EmrCode + "^" + EpisodeID + "^CaseMeasureXml^" + rowid;
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	arr = eval(a);
	var emrknowurl = "dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr=" + parr + "&EpisodeID=" + EpisodeID;
	var south_item = new Ext.Panel({
		region: 'south',
		split: false,
		border: false,
		// collapsible: true,   
		autoScroll: false,
		layout: 'absolute',
		minSize: 100,
		height: 570, //内层高度（600-30）预留30的高度给确定按钮
		frame: true,
		//items: arr 
		buttons: [{
			text: '确定',
			handler: function () {
				sureMeasure();
			}
		}, {
			text: '取消',
			handler: function () {
				window.close();
			}
		}],
		html: '<iframe id ="southTab" name="ddd" style="width:100%; height:100%" src=' + emrknowurl + ' ></iframe>'
	});
	var window = new Ext.Window({
		title: '病情措施及处理',
		width: 900, //宽度
		modal: true,
		height: 600, //高度
		x: 100,
		y: 100,
		id: 'CaseForm',
		autoScroll: false,
		layout: 'absolute',
		plain: true,
		frame: true,
		items: south_item
	});
	var mygrid = Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
			title: '注意',
			msg: '请选择一条数据!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}
	window.show();
}

function Measure1() {
	selections = grid.getSelectionModel().getSelections();
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		width: 550,
		height: 450,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	var mydate = new Date();
	var butord = Ext.getCmp('_Button5');
	butord.on = ('click', OrdSch1);
	window.show();
}

function tets33() { //小结

	var SaveOutIn = document.getElementById('SaveOutIn');
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先点'统计'按钮!");
		return;
	} else {
		var CareDate = objRow[0].get("CareDate");
		var CareTime = objRow[0].get("CareTime");
		var inamount = objRow[0].get(DisplaySumInAmount);
		var OutQtAmount = objRow[0].get(DisplaySumOutAmount);
		var InPart = objRow[0].get(PartInAmount);
		var OutPart = objRow[0].get(PartOutAmount);
		//var StatTime=objRow[0].get("Item1");
		//var StatHours=objRow[0].get("Item2");
		var CaseMeasure = objRow[0].get("CaseMeasure");
		var CaseMeasureArr = CaseMeasure.split(" ");
		if (CaseMeasureArr.length > 1) {
			var StatTime = CaseMeasureArr[0];
			var StatHours = CaseMeasureArr[1];
		} else {
			var StatTime = "";
			var StatHours = "";
		}
		var str = "SumInAmount|" + inamount + "^SumOutAmount|" + OutQtAmount + "^CareDate|" + formatDate(CareDate) + "^CareTime|" + CareTime + "^Typ|Nod^" + "InPart|" + InPart + "^OutPart|" + OutPart + "^StatTime|" + StatTime + "^StatHours|" + StatHours;
		var diaggrid = Ext.getCmp('diaggrid');
		if (diaggrid) {
			var selModel = diaggrid.getSelectionModel();
			if (selModel.hasSelection()) {
				var objDiagRow = selModel.getSelections();
				DiagnosDr = objDiagRow[0].get("rw");
			} else {
				DiagnosDr = "";
			}
		} else {
			DiagnosDr = "";
		}
		str = str + "^DiagnosDr|" + DiagnosDr;
		//alert(str);
		var a = cspRunServerMethod(SaveOutIn.value, EpisodeID, str, session['LOGON.USERID'], EmrCode);
		find();
	}
}

function InOutNod() { }

function InOutSum() {
	var SaveOutIn = document.getElementById('SaveOutIn');
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先点'统计'按钮!");
		return;
	} else {
		var CareDate = objRow[0].get("CareDate");
		var CareTime = objRow[0].get("CareTime");
		var inamount = objRow[0].get(DisplaySumInAmount);
		var OutQtAmount = objRow[0].get(DisplaySumOutAmount);
		var InPart = objRow[0].get(PartInAmount);
		var OutPart = objRow[0].get(PartOutAmount);
		//var StatTime=objRow[0].get("Item1");
		//var StatHours=objRow[0].get("Item2");
		var CaseMeasure = objRow[0].get("CaseMeasure");
		alert("1");
		alert(CaseMeasure);
		var CaseMeasureArr = CaseMeasure.split(" ");
		alert("2");
		if (CaseMeasureArr.length > 1) {
			var StatTime = CaseMeasureArr[0];
			var StatHours = CaseMeasureArr[1];
		} else {
			var StatTime = "";
			var StatHours = "";
		}
		var str = "SumInAmount|" + inamount + "^SumOutAmount|" + OutQtAmount + "^CareDate|" + formatDate(CareDate) + "^CareTime|" + CareTime + "^Typ|Sum^" + "InPart|" + InPart + "^OutPart|" + OutPart + "^StatTime|" + StatTime + "^StatHours|" + StatHours;
		var diaggrid = Ext.getCmp('diaggrid');
		if (diaggrid) {
			var selModel = diaggrid.getSelectionModel();
			if (selModel.hasSelection()) {
				var objDiagRow = selModel.getSelections();
				DiagnosDr = objDiagRow[0].get("rw");
			} else {
				DiagnosDr = "";
			}
		} else {
			DiagnosDr = "";
		}
		str = str + "^DiagnosDr|" + DiagnosDr;
		//alert(str);
		var a = cspRunServerMethod(SaveOutIn.value, EpisodeID, str, session['LOGON.USERID'], EmrCode);
		find();
	}
}

function OrdSch1() {
	// var CurrAdm=selections[rowIndex].get("Adm");
	selections = grid.getSelectionModel().getSelections();
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		width: 550,
		height: 550,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	var butin = Ext.getCmp('ordgridbut1');
	butin.text = "确定";
	//debugger;
	butin.on('click', SureIn);
	window.show();

}

function OrdSch() {
	// var CurrAdm=selections[rowIndex].get("Adm");
	selections = grid.getSelectionModel().getSelections();
	var arr = new Array();
	//alert(EpisodeID);
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList",EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		id: 'orditmssss',
		x: 100,
		y: 80,
		width: 800,
		height: 600,
		autoScroll: true,
		layout: 'absolute',
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	var mydate = new Date();

	var grid1 = Ext.getCmp("ordgrid");
	tobar = grid1.getTopToolbar();
	tobar.addItem({
		xtype: 'datefield',
		format: 'Y-m-d',
		id: 'ordgridstdate',
		//value: (diffDate(new Date(), -1))
		value: new Date()
	}, {
			xtype: 'datefield',
			format: 'Y-m-d',
			id: 'ordgridenddate',
			value: new Date()
		}, "-", "优先级", {
			xtype: 'combo',
			store: new Ext.data.SimpleStore({
				fields: ['valueInOut', 'descpInOut'],
				data: [
					['T', '临时医嘱'],
					['L', '长期医嘱']
				]
			}),
			id: 'Prior',
			fieldLabel: '优先级',
			loadingText: '正在加载...',
			displayField: 'descpInOut', //隐藏的数据
			valueField: 'valueInOut', //显示的数据
			mode: 'local', //读取本地数据(remote表示远程数据)
			triggerAction: 'all',
			editable: true, //是否可以编辑,同时此属性也支持输入搜索功能
			width: 100
		});
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询",
		//handler:find,
		id: 'ordgridSch'
	}

	);

	var butin = Ext.getCmp('ordgridbut2');
	butin.hide();
	var butin = Ext.getCmp('ordgridbut1');
	butin.text = "确定";
	//debugger;
	butin.on('click', SureIn);
	var butschord = Ext.getCmp('ordgridSch');
	butschord.on('click', SchOrd);
	var prior = Ext.getCmp("Prior");
	prior.on('select', SchOrd);
	window.show();
	SchOrd();
	Ext.getCmp("ordgrid").on('dblclick', function () {
		//alert('1');
		SureIn();
	})
	return;
}
var condata = new Array();

//'OrdDate', 'OrdTime', 'ARCIMDesc', 'PriorDes', 'Meth', 'PHFreq', 'Dose', 'DoseUnit', 'OrdStat', 'Doctor', 'Oew', 'OrdSub', 'SeqNo'
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

function SureIn() {
	var grid = Ext.getCmp('ordgrid');
	var mygrid = Ext.getCmp('mygrid');
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	/*var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); //列数
	var view = grid.getView();*/
	var num = 0;
	var selModel = grid.getSelectionModel();
	if (selModel.hasSelection()) {
		// Ext.Msg.confirm("警告", "确定要删除吗？", function(button) {   
		var selections = selModel.getSelections();
		//var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
		//grid.getSelectionModel().selectRow(rowIndex);
		//debugger;
		var caredate, caretime;
		Ext.each(selections, function (item) {
			var des = item.data.ARCIMDesc;
			des = des.replace("_____", "");
			//var ml = item.data.Dose;
			//var unit = item.data.DoseUnit;
			//换算成ml
			var oeoriId = item.data.Oew;
			var oeoriSub = item.data.OrdSub;
			var mlStr = tkMakeServerCall("web.DHCSTPCHCOLLPRN", "getDoseQtyML", item.data.Oew, item.data.OrdSub);
			var ml = mlStr.split('^')[0];
			//if ((unit != "ml") && (unit != "ML")) ml = "";
			var seqno = item.data.SeqNo;
			var rowIndex = grid.store.indexOf(item);
			for (var i = rowIndex - 1; i >= 0; i--) {
				var subdes = store.getAt(i).data.ARCIMDesc;
				//换算成ml
				var oeoriId = store.getAt(i).data.Oew;
				var oeoriSub = store.getAt(i).data.OrdSub;
				var submlStr = tkMakeServerCall("web.DHCSTPCHCOLLPRN", "getDoseQtyML", oeoriId, oeoriSub);
				var ml = submlStr.split('^')[0];
				subdes = subdes.replace("_____", "");
				//var subml = store.getAt(i).data.Dose;
				var subunit = store.getAt(i).data.DoseUnit;
				//if (subunit != "ml") subml = "";
				var subseqno = store.getAt(i).data.SeqNo;
				if (subseqno == seqno) {
					des = subdes + "," + des;
					ml = eval(ml) + eval(subml);
				} else {
					break;
				}
			}
			for (var i = rowIndex + 1; i < store.getCount(); i++) {
				var subdes = store.getAt(i).data.ARCIMDesc;
				subdes = subdes.replace("_____", "");
				//var subml = store.getAt(i).data.Dose;
				var oeoriId = store.getAt(i).data.Oew;
				var oeoriSub = store.getAt(i).data.OrdSub;
				var submlStr = tkMakeServerCall("web.DHCSTPCHCOLLPRN", "getDoseQtyML", oeoriId, oeoriSub);
				var ml = submlStr.split('^')[0];
				//var subunit = store.getAt(i).data.DoseUnit;
				//if ((subunit != "ml") && (subunit != "ML")) subml = "";
				var subseqno = store.getAt(i).data.SeqNo;
				if (subseqno == seqno) {
					des = des + "," + subdes;
					ml = eval(ml) + eval(subml);
				} else {
					break;
				}
			}
			if (num == 0) {
				caredate = mygrid.getStore().getAt(0).get("CareDate");
				caretime = mygrid.getStore().getAt(0).get("CareTime");
				var objRow = mygrid.getSelectionModel().getSelections();
				if (objRow.length == 0) {
					alert("请先选择某行!");
					return;
				} else {
					objRow[0].set(SumInName, des);
					objRow[0].set(SumInAmount, ml);
				}
			} else {
				additm();
				mygrid.getSelectionModel().selectRow(mygrid.store.getCount() - 1);
				mygrid.getSelectionModel().getSelections()[0].set("CareDate", caredate);
				mygrid.getSelectionModel().getSelections()[0].set("CareTime", caretime);
				//alert(SumInName+","+SumInAmount);
				mygrid.getSelectionModel().getSelections()[0].set(SumInName, des);
				mygrid.getSelectionModel().getSelections()[0].set(SumInAmount, ml);
			}
			num++;
		});
	}
}
//document.body.onload=BodyLoadHandler;
//date.on('change', function(){alert(1);});

function Measure() {
	/* selections = grid.getSelectionModel().getSelections();
 	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	arr = eval(a);*/
	//EmrCode,EpisodeId,fieldCode
	MeasureRel = new Hashtable();
	var grid1 = Ext.getCmp('mygrid');
	var objRow = grid1.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条护理记录!");
		return;
	}
	var par = grid1.getSelectionModel().getSelections()[0].get("par");
	var rw = grid1.getSelectionModel().getSelections()[0].get("rw");
	// debugger;
	var rowid = par + "||" + rw;
	if (par == undefined) {
		rowid = "";
	}
	var parr = EmrCode + "^" + EpisodeID + "^CaseMeasureXml^" + rowid;
	//alert(parr);
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	arr = eval(a);
	var arrlab = new Array();
	a = cspRunServerMethod(pdata1, "", "DHCNurLabRec", EpisodeID, "");
	arrlab = eval(a);
	var arrcheck = new Array();
	a = cspRunServerMethod(pdata1, "", "DHCNurCheckRec", EpisodeID, "");
	arrcheck = eval(a);
	var arrResult = new Array();
	a = cspRunServerMethod(pdata1, "", "DHCNurLCResult", EpisodeID, "");
	arrResult = eval(a);
	//DHCNurLCResult
	var north_item = new Ext.Panel({
		title: '',
		region: 'north',
		//contentEl: 'north-div',   
		split: true,
		frame: true,
		border: true,
		//collapsible: true,   
		height: 200,
		items: [{
			xtype: "tabpanel",
			activeTab: 0,
			frame: true,
			items: [{
				title: "医嘱",
				width: 550,
				height: 200,
				autoScroll: true,
				layout: 'absolute',
				items: arr
			}, {
				title: "检查",
				width: 550,
				height: 200,
				autoScroll: true,
				layout: 'absolute',
				items: arrcheck
			}, {
				title: "检验",
				width: 550,
				height: 200,
				autoScroll: true,
				layout: 'absolute',
				items: arrlab
			}]
		}]
	});

	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	arr = eval(a);
	var emrknowurl = "dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr=" + parr + "&EpisodeID=" + EpisodeID;
	//alert(emrknowurl);
	//中间   
	var center_item = new Ext.Panel({
		region: 'center',
		autoScroll: true,
		split: true,
		layout: 'fit',
		collapsible: false,
		height: 50,
		minSize: 50,
		frame: true,
		items: arrResult
	});
	//南边，状态栏   
	var south_item = new Ext.Panel({
		region: 'south',
		// contentEl: 'south-div',   
		split: true,
		// border: true,   
		// collapsible: true,   
		autoScroll: true,
		layout: 'absolute',
		minSize: 200,
		height: 200,
		frame: true,
		//items: arr 
		buttons: [{
			text: '确定',
			handler: function () {
				//	Save();
				//	window.close();
				sureMeasure();
			}
		}, {
			text: '取消',
			handler: function () {
				window.close();
			}
		}],
		html: '<iframe id ="southTab" name="ddd" style="width:100%; height:100%" src=' + emrknowurl + ' ></iframe>'

	});

	//中间的中间，功能菜单   
	//alert(parr);
	var window = new Ext.Window({
		title: '病情措施及处理',
		width: 550,
		modal: true,
		height: 580,
		id: 'CaseForm',
		autoScroll: true,
		layout: 'border',
		plain: true,
		frame: true,
		items: [north_item, center_item, south_item]
	});
	var grid = Ext.getCmp("LabGrid");
	var tobar = grid.getTopToolbar();
	addtitCon(tobar, grid.id);
	grid = Ext.getCmp("CheckGrid");
	tobar = grid.getTopToolbar();
	addtitCon(tobar, grid.id);
	grid = Ext.getCmp("ordgrid");
	tobar = grid.getTopToolbar();
	addtitCon(tobar, grid.id);

	var butschlab = Ext.getCmp('LabGridSch');
	butschlab.on('click', Schlab);

	var butschord = Ext.getCmp('ordgridSch');
	butschord.on('click', SchOrd);

	var butschcheck = Ext.getCmp('CheckGridSch');
	butschcheck.on('click', SchCheck);

	var gridc = Ext.getCmp('CheckGrid');
	gridc.on('click', gridcheckclick);

	var gridl = Ext.getCmp('LabGrid');
	gridl.on('click', gridLabclick);
	var mygrid = Ext.getCmp("mygrid");

	////var butsure=Ext.getCmp('_Button6');
	//butsure.on('click',sureMeasure);
	var rowObj = mygrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		//var content = rowObj[0].get("CaseMeasure");
		//var TxtCaseMeasure=Ext.getCmp('TxtCaseMeasure');
		//TxtCaseMeasure.setValue(content);
	}
	//var mydate=new Date();
	//var butord=Ext.getCmp('_Button5');
	//butord.on=('click',OrdSch1);

	window.show();
	//alert();
}

function sureMeasure() {
	var gform = Ext.getCmp("gform");
	//gform.items.each(eachItem, this);  

	var TxtCaseMeasure = Ext.getCmp('TxtCaseMeasure');
	var frm = Ext.getCmp('CaseForm');
	var aa = document.getElementById("southTab");
	var CareCon = Ext.get("southTab").dom.contentWindow.document.getElementById("DesignForm");
	//alert(CareCon.QichTextCon.GetCellText());
	var win = Ext.get("southTab").dom.contentWindow;
	// var parr="EmrCode^"+EpisodeID+"^CaseMeasureXml";
	var ret = southTab.Save();
	var grid1 = Ext.getCmp('mygrid');
	CaseMeasureID = ret;
	var rwIndex = grid1.getSelectionModel().last;
	MeasureRel.add(rwIndex, CaseMeasureID);
	//debugger;
	grid.getSelectionModel().getSelections()[0].set("CaseMeasure", CareCon.QichTextCon.GetCellText());
	frm.close();

}

function gridcheckclick() {
	var grid = Ext.getCmp("CheckGrid");

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var GetRadiaNote = document.getElementById('GetRadiaNote');
	if (len < 1) {
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		var rowid = rowObj[0].get("ORW");
		var a = cspRunServerMethod(GetRadiaNote.value, rowid);
		var LCResult = Ext.getCmp('LCResult');
		a = a.replace("_$c(13,10)_", String.fromCharCode(13) + String.fromCharCode(10));
		var aa = a.split("_$c_");
		var txt = "";
		for (i = 0; i < aa.length; i++) {
			if (aa[i] == "") continue;
			txt = txt + aa[i]; //+String.fromCharCode(13)+String.fromCharCode(10);
		}
		LCResult.setValue(txt);
		//EpisodeID=rowObj[0].get("EpisodeId");
		/*for (i = 0; i < top.frames.length; i++) {
			alert(top.frames[i].name);
		}
		var frm = top.frames[0].document.forms["fEPRMENU"];
	    frm.EpisodeID.value=EpisodeID;
        ModConsult();*/
	}
}

function gridLabclick() {
	var grid = Ext.getCmp("LabGrid");

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var GetLabItemdata = document.getElementById('GetLabItemdata');
	if (len < 1) {
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		var labno = rowObj[0].get("LabEpisodeNo");
		var tesc = rowObj[0].get("testcode");
		var ARCIMDes = rowObj[0].get("ARCIMDes");
		var a = cspRunServerMethod(GetLabItemdata.value, labno, tesc);
		if (a == "-1") return;
		var LCResult = Ext.getCmp('LCResult');
		//a=a.replace("&",String.fromCharCode(13)+String.fromCharCode(10));
		var aa = a.split("$");
		var aresult = aa[1].split('&');
		var txt = "";
		for (i = 0; i < aresult.length; i++) {
			if (aresult[i] == "") continue;
			var labar = aresult[i].split("^");
			txt = txt + labar + String.fromCharCode(13) + String.fromCharCode(10);
		}
		LCResult.setValue("        " + ARCIMDes + String.fromCharCode(13) + String.fromCharCode(10) + txt);
		//EpisodeID=rowObj[0].get("EpisodeId");
		/*for (i = 0; i < top.frames.length; i++) {
			alert(top.frames[i].name);
		}
		var frm = top.frames[0].document.forms["fEPRMENU"];
	    frm.EpisodeID.value=EpisodeID;
        ModConsult();*/
	}
}

function SchOrd() {
	condata = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("ordgridstdate");
	var Enddate = Ext.getCmp("ordgridenddate");
	var prior = Ext.getCmp("Prior");
	var GetQueryData = document.getElementById('GetQueryData1');
	var ordgrid = Ext.getCmp("ordgrid");
	var parr = adm + "^" + StDate.value + "^" + Enddate.value + "^" + prior.getValue();
	//alert(parr);
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNUREMR:GetPatOrd", "parr$" + parr, "add");
	//grid.width=document.body.offsetWidth;
	ordgrid.store.loadData(condata);

}

function Schlab() {
	condata = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("LabGridstdate");
	var Enddate = Ext.getCmp("LabGridenddate");
	var GetQueryData = document.getElementById('GetQueryData');
	var ordgrid = Ext.getCmp("LabGrid");
	//var parr=adm+"^"+StDate.value+"^"+Enddate.value;
	//alert(adm);
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurJYRESULT:GetLabNo", "Adm$" + adm, "AddLab");
	// grid.width=document.body.offsetWidth;
	ordgrid.store.loadData(condata);
}

function AddLab(a, b, c, d, e, f, g, h) {
	//OrdDate,OrdTime,ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR
	condata.push({
		ARCIMDes: a,
		LabEpisodeNo: b,
		StDateTime: c,
		RowId: d,
		testcode: e,
		LabCpt: f,
		LabDate: g,
		LabTime: h
	});
}

function AddCheck(a, b, c, d, e, f, g, h) {
	//OrdDate,OrdTime,ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR
	condata.push({
		OrdDate: a,
		OrdTime: b,
		ARCIMDesc: c,
		ORW: d,
		DateEx: e,
		TimeEx: f,
		CPTEx: g,
		ArcimDR: h
	});
}

function SchCheck() {
	condata = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("CheckGridstdate");
	var Enddate = Ext.getCmp("CheckGridenddate");
	var GetQueryData = document.getElementById('GetQueryData');
	var ordgrid = Ext.getCmp("CheckGrid");
	var parr = adm + "^" + StDate.value + "^" + Enddate.value;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurJYRESULT:GetOrdRadia", "parr$" + parr, "AddCheck");
	// grid.width=document.body.offsetWidth;

	ordgrid.store.loadData(condata);
}

function printNurRec() {
	var GetPrnSet = document.getElementById('GetPrnSet');
	var GetHead = document.getElementById('GetPatInfo');

	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	//debugger;
	var a = cspRunServerMethod(GetPrnSet.value, EmrCode, EpisodeID); //page, caredattim, prnpos, adm,Typ,user
	if (a == "") return;
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, EmrCode + "^" + session['LOGON.CTLOCID']);
	//alert(GetLableRec);
	var tm = a.split("^");
	var stdate = "" //tm[2];
	var stim = "" //tm[3];
	var edate = "" //tm[4];
	var etim = "" //tm[5];
	PrintCommPic.RHeadCaption = hh[1];
	PrintCommPic.LHeadCaption = hh[0];
	//PrintCommPic.RFootCaption="第";
	//PrintCommPic.LFootCaption="页";
	//alert(ret)
	PrintCommPic.TitleStr = ret;
	PrintCommPic.LFootCaption = hh[2];
	PrintCommPic.SetPreView("1");
	PrintCommPic.PrnLoc = session['LOGON.CTLOCID'];
	PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
	//alert(PrintCommPic.WebUrl);
	var aa = tm[1].split("&");
	//PrintCommPic.stPage=aa[0];
	//if (aa.length>1) PrintCommPic.stRow=aa[1];
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	PrintCommPic.previewPrint = "1"; //是否弹出设置界面
	//PrintCommPic.stprintpos=tm[0];
	PrintCommPic.stprintpos = 0;
	//alert(PrintCommPic.Pages);
	//PrintCommPic.SetConnectStr(CacheDB);
	PrintCommPic.ItmName = "DHCNurPrnMouldXH2"; //338155!2010-07-13!0:00!!
	//debugger;
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode;
	//alert(parr);
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	//PrintCommPic.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
	if (LabHead != "") PrintCommPic.LabHead = LabHead;
	//alert(parr);
	PrintCommPic.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
	PrintCommPic.PrintOut();
	//alert(122);
	var SavePrnSet = document.getElementById('SavePrnSet');
	//debugger;
	var CareDateTim = PrintCommPic.CareDateTim;
	if (CareDateTim == "") return;
	var pages = PrintCommPic.pages;
	var stRow = PrintCommPic.stRow;
	//debugger;
	var stprintpos = PrintCommPic.stPrintPos;
	//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"EmrCode"+","+session['LOGON.USERID']+","+PrintCommPic.PrnFlag);
	//PrnFlag==1说明是打印预览
	if (PrintCommPic.PrnFlag == 1) return;
	//如果原记录保存打印到第8页则当打印第8页之前页时不保存打印记录
	if (pages < aa[0]) return;
	var a = cspRunServerMethod(SavePrnSet.value, pages, CareDateTim, stprintpos, EpisodeID, EmrCode, session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
	//find();
}

function printNurRecnew() {
	var GetPrnSet = document.getElementById('GetPrnSet');
	var GetHead = document.getElementById('GetPatInfo');

	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	//debugger;
	var a = cspRunServerMethod(GetPrnSet.value, EmrCode, EpisodeID); //page, caredattim, prnpos, adm,Typ,user
	if (a == "") return;
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, EmrCode + "^" + session['LOGON.CTLOCID']);
	//alert(GetLableRec);
	var tm = a.split("^");
	var stdate = "" //tm[2];
	var stim = "" //tm[3];
	var edate = "" //tm[4];
	var etim = "" //tm[5];
	PrintCommPic.RHeadCaption = hh[1];
	PrintCommPic.LHeadCaption = hh[0];
	//PrintCommPic.RFootCaption="第";
	//PrintCommPic.LFootCaption="页";
	//alert(ret)
	PrintCommPic.TitleStr = ret;
	PrintCommPic.LFootCaption = hh[2];
	PrintCommPic.SetPreView("1");
	PrintCommPic.PrnLoc = session['LOGON.CTLOCID'];
	PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
	//alert(PrintCommPic.WebUrl);
	var aa = tm[1].split("&");
	//PrintCommPic.stPage=aa[0];
	//if (aa.length>1) PrintCommPic.stRow=aa[1];
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	PrintCommPic.previewPrint = "1"; //是否弹出设置界面
	//PrintCommPic.stprintpos=tm[0];
	PrintCommPic.stprintpos = 0;
	//alert(PrintCommPic.Pages);
	//PrintCommPic.SetConnectStr(CacheDB);
	PrintCommPic.ItmName = "DHCNurPrnMouldXH2new"; //338155!2010-07-13!0:00!!
	//debugger;
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode;
	//alert(parr);
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	//PrintCommPic.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
	if (LabHead != "") PrintCommPic.LabHead = LabHead;
	//alert(parr);
	PrintCommPic.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
	PrintCommPic.PrintOut();
	//alert(122);
	var SavePrnSet = document.getElementById('SavePrnSet');
	//debugger;
	var CareDateTim = PrintCommPic.CareDateTim;
	if (CareDateTim == "") return;
	var pages = PrintCommPic.pages;
	var stRow = PrintCommPic.stRow;
	//debugger;
	var stprintpos = PrintCommPic.stPrintPos;
	//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"EmrCode"+","+session['LOGON.USERID']+","+PrintCommPic.PrnFlag);
	//PrnFlag==1说明是打印预览
	if (PrintCommPic.PrnFlag == 1) return;
	//如果原记录保存打印到第8页则当打印第8页之前页时不保存打印记录
	if (pages < aa[0]) return;
	var a = cspRunServerMethod(SavePrnSet.value, pages, CareDateTim, stprintpos, EpisodeID, EmrCode, session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
	//find();
}
//全部打印
function printNurRecZK() {
	var GetPrnSet = document.getElementById('GetPrnSet');
	var GetHead = document.getElementById('GetPatInfo');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	//debugger;
	var a = cspRunServerMethod(GetPrnSet.value, EmrCode, EpisodeID); //page, caredattim, prnpos, adm,Typ,user
	if (a == "") return;
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, EmrCode + "^" + session['LOGON.CTLOCID']);
	//alert(GetLableRec);
	var tm = a.split("^");
	var stdate = "" //tm[2];
	var stim = "" //tm[3];
	var edate = "" //tm[4];
	//alert(PrintCommPic)
	var etim = "" //tm[5];
	PrintCommPic.RHeadCaption = hh[1];
	PrintCommPic.LHeadCaption = hh[0];
	//PrintCommPic.RFootCaption="第";
	//PrintCommPic.LFootCaption="页";
	//alert(ret)
	PrintCommPic.TitleStr = ret;
	PrintCommPic.LFootCaption = hh[2];
	PrintCommPic.SetPreView("1");
	//PrintCommPic.PrnLoc=session['LOGON.CTLOCID'];
	PrintCommPic.PrnLoc = patloc;
	PrintCommPic.PrnBed = bedCode; //转科打印时设置床号
	PrintCommPic.xuflag = 0; //0 不启用续打，1 启用续打
	PrintCommPic.dxflag = 0;
	PrintCommPic.SplitPage = "1" //转科是否换页1 换页，0不换页
	PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
	//alert(PrintCommPic.WebUrl);
	var aa = tm[1].split("&");
	//PrintCommPic.stPage=aa[0];
	//if (aa.length>1) PrintCommPic.stRow=aa[1];
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	PrintCommPic.previewPrint = "1"; //是否弹出设置界面
	//PrintCommPic.stprintpos=tm[0];
	PrintCommPic.stprintpos = 0;
	PrintCommPic.tranflag = 1; //是否启用转科
	PrintCommPic.EmrCode = EmrCode;
	//alert(PrintCommPic.Pages);
	//PrintCommPic.SetConnectStr(CacheDB);
	PrintCommPic.ItmName = prncode; //338155!2010-07-13!0:00!!
	//debugger;
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode + "!";
	//alert(parr);
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	//PrintCommPic.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
	if (LabHead != "") PrintCommPic.LabHead = LabHead;
	//alert(parr);
	PrintCommPic.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
	PrintCommPic.PrintOut();

}

//生成图片
function MakePicture(page) {
	//alert(prncode)
	var typein = typeof page
	if (typein == "object") page = 0
	var GetHead = document.getElementById('GetPatInfo');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	PrintCommPic.StartMakePic = "Y"; //图片

	PrintCommPic.SetPreView("1");
	PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	PrintCommPic.TitleStr = ret;
	PrintCommPic.previewPrint = "0"; //是否弹出设置界面
	PrintCommPic.stPrintPos = 0;
	PrintCommPic.PrnLoc = session['LOGON.CTLOCID'];
	PrintCommPic.Patcurloc = patloc; //病人当前科室id
	PrintCommPic.NurseLocHuanYe = "Y"; //Y:转病区换页(按绑定的护士科室id) N:按病人科室换页
	PrintCommPic.PrnBed = bedCode; //病人当前床号
	PrintCommPic.tranflag = "1"; //转科换页
	PrintCommPic.dxflag = 0; //1：一条记录打印一条横线；0：一条记录的每一行文字下面都打印一条横线
	PrintCommPic.xuflag = "0"; //0:不启用续打印 ；1 启用续打
	PrintCommPic.SplitPage = "1"; //1:有转科或转病区时新起一页打印
	PrintCommPic.ItmName = prncode; //打印模板名 请参考printNurRec
	PrintCommPic.EpisodeID = EpisodeID; //图片
	PrintCommPic.EmrCode = EmrCode; //图片
	PrintCommPic.MakeTemp = "Y"; //图片  Y:生成图片  ；N:不生成
	if (WillUpload == "Y") {
		PrintCommPic.IfUpload = "Y"; //图片是否上传ftp服务器：Y -上传，N-不上传
	} else {
		PrintCommPic.IfUpload = "N";
	}
	PrintCommPic.MakeAllPages = "N"; //图片  Y:生成该病人该模板的所有图片; N:生成最近一页图片
	PrintCommPic.curPages = page; //图片  开始页码
	PrintCommPic.filepath = WebIp + "/DHCMG/HLBLMakePictureSet.xml"; //图片 ftp服务器配置
	var parr = EpisodeID + "!" + "!" + "!" + "!" + "!" + EmrCode + "!";
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	PrintCommPic.SetParrm(parr);
	PrintCommPic.PrintOut();
	PrintCommPic.MakePicture(); //图片	
}
//全部打印 测试
function printNurRecZKTest() {
	var GetPrnSet = document.getElementById('GetPrnSet');
	var GetHead = document.getElementById('GetPatInfo');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	//debugger;
	var a = cspRunServerMethod(GetPrnSet.value, EmrCode, EpisodeID); //page, caredattim, prnpos, adm,Typ,user
	if (a == "") return;
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, EmrCode + "^" + session['LOGON.CTLOCID']);
	//alert(GetLableRec);
	var tm = a.split("^");
	var stdate = "" //tm[2];
	var stim = "" //tm[3];
	var edate = "" //tm[4];
	var etim = "" //tm[5];
	PrintCommPic.RHeadCaption = hh[1];
	PrintCommPic.LHeadCaption = hh[0];
	//PrintCommPic.RFootCaption="第";
	//PrintCommPic.LFootCaption="页";
	//alert(ret)
	PrintCommPic.TitleStr = ret;
	PrintCommPic.LFootCaption = hh[2];
	PrintCommPic.SetPreView("1");
	//PrintCommPic.PrnLoc=session['LOGON.CTLOCID'];
	PrintCommPic.PrnLoc = session['LOGON.CTLOCID'];;
	PrintCommPic.PrnBed = bedCode; //转科打印时设置床号
	PrintCommPic.xuflag = 0; //0 不启用续打，1 启用续打
	PrintCommPic.SplitPage = "1" //转科是否换页1 换页，0不换页
	PrintCommPic.WebUrl = WebIp + "/imedical/web/DWR.DoctorRound.cls";
	//alert(PrintCommPic.WebUrl);
	var aa = tm[1].split("&");
	//PrintCommPic.stPage=aa[0];
	//if (aa.length>1) PrintCommPic.stRow=aa[1];
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	PrintCommPic.previewPrint = "1"; //是否弹出设置界面
	//PrintCommPic.stprintpos=tm[0];
	PrintCommPic.stprintpos = 0;
	PrintCommPic.tranflag = 1; //是否启用转科
	PrintCommPic.EmrCode = EmrCode;
	//alert(PrintCommPic.Pages);
	//PrintCommPic.SetConnectStr(CacheDB);
	PrintCommPic.ItmName = "DHCNurPrnMouldXH2newzk"; //338155!2010-07-13!0:00!!
	//debugger;
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode + "!";
	//alert(parr);
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	//PrintCommPic.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
	if (LabHead != "") PrintCommPic.LabHead = LabHead;
	//alert(parr);
	PrintCommPic.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
	PrintCommPic.PrintOut();

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

function UpdateRelDiagnos() {
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNurRelDiagnos", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '关联诊断记录',
		width: 615,
		height: 235,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	var butin = Ext.getCmp('diaggridbut1');
	butin.text = "确定";
	butin.on('click', UpdateDiagnos);
	var but2 = Ext.getCmp('diaggridbut2');
	but2.text = "插入小结";
	but2.on('click', UpdateDiagnos1);
	var diaggrid = Ext.getCmp('diaggrid');
	var diagtobar = diaggrid.getTopToolbar();
	diagtobar.addButton({
		className: 'new-topic-button',
		text: "插入24小时",
		handler: UpdateDiagnos2,
		id: 'diaggridbut3'
	});
	//debugger;
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length > 0) {
		var inname = objRow[0].get(DisplaySumInName);
		var outname = objRow[0].get(DisplaySumOutName);
		if ((inname) && (outname) && ((inname.indexOf("入液量") != -1) || (outname.indexOf("出液量") != -1))) {
			butin.hide();
		} else {
			but2.hide();
			var but3 = Ext.getCmp('diaggridbut3');
			but3.hide();
		}
	}
	SchDiag();
	window.show();
}

function UpdateDiagnos() {
	var diaggrid = Ext.getCmp("diaggrid");
	var objDiagnosRow = diaggrid.getSelectionModel().getSelections();
	if (objDiagnosRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条诊断记录!");
		return;
	}
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条护理记录!");
		return;
	} else {
		save();
	}
}

function UpdateDiagnos1() {
	var diaggrid = Ext.getCmp("diaggrid");
	var objDiagnosRow = diaggrid.getSelectionModel().getSelections();
	if (objDiagnosRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条诊断记录!");
		return;
	}
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条统计记录!");
		return;
	} else {
		InOutNod();
	}
}

function UpdateDiagnos2() {
	var diaggrid = Ext.getCmp("diaggrid");
	var objDiagnosRow = diaggrid.getSelectionModel().getSelections();
	if (objDiagnosRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条诊断记录!");
		return;
	}
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条统计记录!");
		return;
	} else {
		InOutSum();
	}
}

function SchDiag() {
	condata = new Array();
	var adm = EpisodeID;
	var GetQueryData = document.getElementById('GetQueryData');
	var diaggrid = Ext.getCmp("diaggrid");
	//alert(adm);
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurseRecordComm:GetCopyDiagnos", "parr$" + adm, "AddDiag");
	diaggrid.store.loadData(condata);
}

function AddDiag(a1, a2, a3, a4, a5) {
	condata.push({
		DiagNos: a1,
		RecUser: a2,
		RecDate: a3,
		RecTime: a4,
		rw: a5
	});
}

function DBC2SBC(str) {
	var result = '';
	if ((str) && (str.length)) {
		for (var i = 0; i < str.length; i++) {
			var code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			} else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				} else {
					result += str.charAt(i);
				}
			}
		}
	} else {
		result = str;
	}
	return result;
}

function CancelRecord() {
	var objCancelRecord = document.getElementById('CancelRecord');
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条护理记录!");
		return;
	} else {
		// Ext.Msg.show({
		// 	title: '再确认一下',
		// 	msg: '你确定要作废此条护理记录吗?',
		// 	buttons: {
		// 		"ok": "确定",
		// 		"cancel": "取消"
		// 	},
		// 	fn: function(btn, text) {
		// 		if (btn == 'ok') {
		// 			var par = objRow[0].get("par");
		// 			var rw = objRow[0].get("rw");
		// 			//alert(par+","+rw+","+session['LOGON.USERID']+","+session['LOGON.GROUPDESC']);
		// 			if (objCancelRecord) {
		// 				var a = cspRunServerMethod(objCancelRecord.value, par, rw, session['LOGON.USERID'], session['LOGON.GROUPDESC']);
		// 				if (a != 0) {
		// 					alert(a);
		// 					return;
		// 				} else {
		// 					find();
		// 				}
		// 			}
		// 		}
		// 	},
		// 	animEl: 'newbutton'
		// });
		var flag = confirm("你确定要删除此条护理记录吗?");
		if (flag == true) {
			var par = objRow[0].get("par");
			var rw = objRow[0].get("rw");
			//alert(par+","+rw+","+session['LOGON.USERID']+","+session['LOGON.GROUPDESC']);
			if (objCancelRecord) {
				var a = cspRunServerMethod(objCancelRecord.value, par, rw, session['LOGON.USERID'], session['LOGON.GROUPDESC']);
				if (a != 0) {
					alert(a);
					return;
				} else {
					find();
				}
			}
		} else {
			return;
		}

	}
}

function additmstat(statenddate, statendtime) {
	var Plant = Ext.data.Record.create([{
		name: 'CareDate'
	}, {
		name: 'CareTime'
	}, {
		name: 'Item1'
	}, {
		name: 'Item2'
	}, {
		name: 'Item3'
	}, {
		name: 'Item4'
	}, {
		name: 'Item5'
	}, {
		name: 'Item6'
	}, {
		name: 'Item7'
	}, {
		name: 'Item8'
	}, {
		name: 'Item9'
	}, {
		name: 'Item10'
	}, {
		name: 'Item11'
	}, {
		name: 'Item12'
	}, {
		name: 'Item13'
	}, {
		name: 'Item14'
	}, {
		name: 'Item15'
	}, {
		name: 'Item16'
	}, {
		name: 'Item17'
	}, {
		name: 'Item18'
	}, {
		name: 'Item19'
	}, {
		name: 'Item20'
	}, {
		name: 'Item21'
	}, {
		name: 'Item22'
	}, {
		name: 'Item23'
	}, {
		name: 'Item24'
	}, {
		name: 'Item25'
	}, {
		name: 'Item26'
	}, {
		name: 'Item27'
	}, {
		name: 'Item28'
	}, {
		name: 'Item29'
	}, {
		name: 'Item30'
	}, {
		name: 'Item31'
	}, {
		name: 'Item32'
	}, {
		name: 'Item33'
	}, {
		name: 'Item34'
	}, {
		name: 'Item35'
	}, {
		name: 'Item36'
	}, {
		name: 'Item37'
	}, {
		name: 'Item38'
	}, {
		name: 'Item39'
	}, {
		name: 'Item40'
	}, {
		name: 'Item41'
	}, {
		name: 'Item42'
	}, {
		name: 'Item43'
	}, {
		name: 'Item44'
	}, {
		name: 'Item45'
	}, {
		name: 'Item46'
	}, {
		name: 'Item47'
	}, {
		name: 'Item48'
	}, {
		name: 'Item49'
	}, {
		name: 'Item50'
	}, {
		name: 'CaseMeasure'
	}, {
		name: 'User'
	}, {
		name: 'rw'
	}, {
		name: 'par'
	}]);
	var count = grid.store.getCount();
	var r = new Plant({
		CareDate: getDate(statenddate),
		CareTime: statendtime
	});
	grid.store.commitChanges();
	grid.store.insert(count, r);
	return;
}
//日间小结
var Timepoint24 = "07:00"; //24h统计时间点
var Timepoint12 = "19:00"; //日间小结时间点
function InOutSumNod() {
	//var adm=EpisodeID;
	var StDate = diffDate(new Date(), 0)
	var StTime2 = Timepoint24
	var Enddate = diffDate(new Date(), 0)
	var EndTime2 = Timepoint12
	//alert(Timepoint24)
	var aa = tkMakeServerCall("NurEmr.webheadchange", "GetInOutAmountCommAndInsert", "Nod", EpisodeID, StDate, StTime2, Enddate, EndTime2, EmrCode, session['LOGON.USERID'], session['LOGON.CTLOCID'], CurrHeadDr, "true")
	
	//出入量统计权限控制
	if (aa=="-1") {
		alert("只有护士才可以统计出入量！");
	}
	
	find();
}
//按时间段统计
function InOutSumSeg() {
	//var adm=EpisodeID;
	var StDate = Ext.getCmp("mygridstdate").value;
	var StTime = Ext.getCmp("mygridsttime").value;
	var Enddate = Ext.getCmp("mygridenddate").value;
	var EndTime = Ext.getCmp("mygridendtime").value;
	//alert(Timepoint24)
	var aa = tkMakeServerCall("NurEmr.webheadchange", "GetInOutAmountCommAndInsert", "Nod", EpisodeID, StDate, StTime, Enddate, EndTime, EmrCode, session['LOGON.USERID'], session['LOGON.CTLOCID'], CurrHeadDr, "true")
	
	if (aa=="-1") {
		alert("只有护士才可以统计出入量！");
	}
	
	find()
}

//24h统计
function InOutSumAll() {
	var adm = EpisodeID;
	var StDate = diffDate(new Date(), -1)
	var StTime = Timepoint24;
	var Enddate = diffDate(new Date(), 0)
	var EndTime = Timepoint24;
	var aa = tkMakeServerCall("NurEmr.webheadchange", "GetInOutAmountCommAndInsert", "Sum", EpisodeID, StDate, StTime, Enddate, EndTime, EmrCode, session['LOGON.USERID'], session['LOGON.CTLOCID'], CurrHeadDr, "true")
	
	if (aa=="-1") {
		alert("只有护士才可以统计出入量！");
	}

	//alert(aa)
	//find()
	// alert(aa)
	//return
	var flag = tkMakeServerCall("NurEmr.webheadchange", "ifexistinoutnew", EpisodeID, Enddate, EndTime, aa);
	// alert(flag)   
	if (flag != "") {
		var alertstr = "体温单中" + EndTime + "点以下项目值有修改：" + flag + "你确定要更新这些值吗"
		Ext.Msg.show({
			title: '再确认一下',
			msg: alertstr,
			buttons: {
				"ok": "确定",
				"cancel": "取消"
			},
			fn: function (btn, text) {
				if (btn == 'ok') {
					//alert(parr)              
					var id = tkMakeServerCall("NurEmr.webheadchange", "InOutResultSave", EpisodeID, aa, session['LOGON.USERID'], "DHCNUR6", session['LOGON.GROUPDESC'], Enddate, EndTime);
					// alert("完成")
				} else {
					// alert("完成")  	
				}
			},
			animEl: 'newbutton'
		});
	} else {

		var id = tkMakeServerCall("NurEmr.webheadchange", "InOutResultSave", EpisodeID, aa, session['LOGON.USERID'], "DHCNUR6", session['LOGON.GROUPDESC'], Enddate, EndTime);
		//alert("完成")
	}
	find();
}

function find2() {
	//var link="dhcnurtempature.csp?EpisodeID="+EpisodeID;
	/// window.open (link,'体温单','height=1,width=1,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
	// window.close();
	// alert(parent.frames.length);
	MeasureRel = new Hashtable();
	REC = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var IfCancelRec = ""  //Ext.getCmp("IfCancelRec").getValue();
	var parr = adm + "^" + StDate.value + "^" + StTime.value + "^" + Enddate.value + "^" + EndTime.value + "^" + EmrCode + "^" + IfCancelRec + "^" + CurrHeadDr;
	// debugger;
	//alert(parr)
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurHCRecComm:GetCareRecComm", "parr$" + parr, "AddRec");
	//var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurHCRecComm:GetCareRecComm", "parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}

//设置默认的护士签名
function setDefaultNurse() {
	var defaultNurseId = session['LOGON.USERID'];
	var defaultNurseName = tkMakeServerCall("Nur.DHCNurMyInterface", "GetNurseNameById", defaultNurseId);
	Ext.getCmp('nurseSign').setValue(defaultNurseName);
}