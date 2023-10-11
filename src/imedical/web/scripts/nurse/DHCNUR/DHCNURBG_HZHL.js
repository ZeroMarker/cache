/**
 * @author Administrator
 */
/*
 grid.store.on('load', function() {
    grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
        x.addClass('x-grid3-cell-text-visible');
    });
});
var DHCPatOrdListT103=new Ext.data.JsonStore({data:[],fields:['OrdDate','OrdTime','ARCIMDesc','PriorDes','Meth','PHFreq','Dose','DoseUnit','OrdStat','Doctor','Oew','OrdSub','SeqNo']});
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
var DHCPatOrdListT103 = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({
		url: "../csp/dhc.nurse.ext.common.getdata.csp"
	}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results',
		fields: [{
			'name': 'OrdDate',
			'mapping': 'OrdDate'
		}, {
			'name': 'OrdTime',
			'mapping': 'OrdTime'
		}, {
			'name': 'ARCIMDesc',
			'mapping': 'ARCIMDesc'
		}, {
			'name': 'PriorDes',
			'mapping': 'PriorDes'
		}, {
			'name': 'Meth',
			'mapping': 'Meth'
		}, {
			'name': 'PHFreq',
			'mapping': 'PHFreq'
		}, {
			'name': 'Dose',
			'mapping': 'Dose'
		}, {
			'name': 'DoseUnit',
			'mapping': 'DoseUnit'
		}, {
			'name': 'OrdStat',
			'mapping': 'OrdStat'
		}, {
			'name': 'Doctor',
			'mapping': 'Doctor'
		}, {
			'name': 'Oew',
			'mapping': 'Oew'
		}, {
			'name': 'OrdSub',
			'mapping': 'OrdSub'
		}, {
			'name': 'SeqNo',
			'mapping': 'SeqNo'
		}]
	}),
	baseParams: {
		className: 'web.DHCNUREMR',
		methodName: 'GetPatOrd',
		type: 'Query'
	}
});
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
var OrdInName = "";
var OrdInAmount = "";
var ICountCls = "";
var OCountCls = "";
var GetNurseRecSet = document.getElementById('GetNurseRecSet');
if (GetNurseRecSet) {
	var ret = cspRunServerMethod(GetNurseRecSet.value, EmrCode);
	var hh = ret.split("^");
	SumInName = hh[0].split("&")[0];
	SumInAmount = hh[0].split("&")[1];
	SumOutName = hh[1].split("&")[0];
	SumOutAmount = hh[1].split("&")[1];
	PartInName = hh[2].split("&")[0].split("!")[0];
	PartInAmount = hh[2].split("&")[1];
	PartOutName = hh[3].split("&")[0].split("!")[0];
	PartOutAmount = hh[3].split("&")[1];
	DisplaySumInName = hh[7].split("&")[0].split("!")[0];
	DisplaySumInAmount = hh[7].split("&")[1];
	DisplaySumOutName = hh[8].split("&")[0].split("!")[0];
	DisplaySumOutAmount = hh[8].split("&")[1];
	ICountCls = hh[9];
	OCountCls = hh[10];
	OrdInName = hh[11].split("&")[0];;
	OrdInAmount = hh[11].split("&")[1];;
	//debugger;
	//alert(OrdInName);
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
	//alert(BFHeadDr)

	var GetHead = document.getElementById('GetHead');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	return hh[0] + "  " + hh[1];
	//debugger;
}
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
locField.on('select', function() {
	CurrHeadDr = Ext.get("loc1").dom.value;
	//alert(CurrHeadDr)
	var a = cspRunServerMethod(Savecurhead, EpisodeID, CurrHeadDr, session['LOGON.USERID'], EmrCode);
	self.location.reload();
	find2();
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

	var lnk = "DHCNurEmrComm.csp?" + "&EmrCode=DHCNURHEADCHANGE&EpisodeID=" + EpisodeID + "&headcode=" + EmrCode //""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	var objret = window.showModalDialog(lnk, 'title3444', "dialogWidth:800px;dialogHeight:500px;center:yes;resizable:no;status:no;scroll:YES;help:no;edge:raised;");
	//var objret =window.open(lnk,'title3444','height=600,width=1000,top=50,left=50,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');	   
	//alert(objret)
	if (objret == undefined) {
		//CurrHeadDr= Ext.get("loc1").dom.value;
		//var a=cspRunServerMethod(Savecurhead,EpisodeID, CurrHeadDr, session['LOGON.USERID'], EmrCode);
		self.location.reload();
		//find()
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
	grid1 = Ext.getCmp("mygrid");
	//grid1.on('click',gridclick);
	var but1 = Ext.getCmp("mygridbut1");
	but1.on('click', additm);
	var but = Ext.getCmp("mygridbut2");
	but.setText("保存");
	//alert(CurrHeadDr)
	//but.icon='../scripts/nurse/image/save.png'
	but.on('click', save);
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
			//alert(C+"/"+E.ENTER+"/"+E.TAB)
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
			// }     saveAll
		}

	});
	grid = Ext.getCmp('mygrid');
	grid.setTitle(gethead());
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.addItem("-")
	tobar.addItem({
		xtype: 'checkbox',
		id: 'hjflag',
		checked: false,
		boxLabel: ''
	});
	tobar.addButton({
		className: 'new-topic-button',
		text: "生成痕迹",
		handler: function() {
			makeRechj(prncode)
		},
		id: 'makehj'
	});
	if (IfMakePic == "Y") {
		tobar.addButton({
			className: 'new-topic-button',
			text: "生成图片",
			handler: function(){
				MakeRecPicture(prncode)
			},
			id: 'MakePicture'
		});
	}
	tobar.addButton({
			//className: 'new-topic-button',
			text: "全部保存",
			handler: saveAll,
			//icon:'../scripts/nurse/image/save.png',
			id: 'mygridSchall'
		}

	);
	tobar.addItem("-");
	tobar.addItem({
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'mygridstdate',

		value: (diffDate(new Date(), 0))
	}, {
		xtype: 'timefield',
		width: 50,
		format: 'H:i',
		value: '0:00',
		id: 'mygridsttime'
	}, {
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'mygridenddate',
		value: diffDate(new Date(), 1)
	}, {
		xtype: 'timefield',
		width: 50,
		id: 'mygridendtime',
		format: 'H:i',
		value: '0:00'
	});
	tobar.addItem("-");
	tobar.addButton({
			className: 'new-topic-button',
			text: "查询",
			handler: find,
			icon: '../scripts/nurse/image/find.png',
			id: 'mygridSch'
		}

	);
	tobar.addItem("-");
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

	tobar.addItem("-", {
		xtype: 'checkbox',
		id: 'IfCancelRec',
		checked: false,
		boxLabel: '显示作废记录'
	});
	tbar2 = new Ext.Toolbar({

	});
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
		//className: 'new-topic-button',
		text: "打印",
		handler: function(){
			printNurCareRec(prncode)
		},
		id: 'PrintBut2'
	});
	/*tbar2.addButton({
		//className: 'new-topic-button',
		text: "奇偶打印",
		handler: function(){
			printNurCareRecJO(prncode)
		},
		id: 'PrintBut2JO'
	});*/
	tbar2.render(grid.tbar);

	tobar.doLayout();
	locField.setValue(CurrHeadDr);
	grid.addListener('rowcontextmenu', rightClickFn);
	grid.addListener('rowclick', rowClickFn);
	grid.on('beforeedit', function beforeEditFn(e) {
		//alert(11)
		grid.rowIndex = e.row; //得到当前的行
		grid.columnIndex = e.column; //得到当前的列
		var objRow = grid.getSelectionModel().getSelections();
		if (objRow.length < 1) return
		var par = objRow[0].get("par");
		var curfield = e.field;
		var curvalue = e.value;
		selectedrow = grid.getSelectionModel().getSelections()[0];
		selecteditem = ""
			//alert(blankstr)
		if (blankstr != "") {
			var straa = blankstr.split('^')
				//alert(straa.lenght)
			for (aai = 0; aai < straa.length; aai++) {
				var aaitme = straa[aai]
				if (aaitme == "") continue
					//alert(aaitme)
				if (aaitme == curfield) {
					selecteditem = curfield
					selecteditemid = curfield
						//alert(curfield)
				}

			}
		}
	});
	grid.on('afteredit', AfterEditFn);
	grid.addListener('headerclick', headclick);
	grid.addListener('rowdblclick', rowdbClickFn);



	grid.on('mouseover', function(e) { //添加mouseover事件
		curpositionofX = e.xy[0];
		curpositionofY = e.xy[1]
		var index = grid.getView().findRowIndex(e.getTarget()); //根据mouse所在的target可以取到列的位置
		//if (index==false) selecteditem=""
		if (index !== false) { //当取到了正确的列时，（因为如果传入的target列没有取到的时候会返回false）
			var store = grid.getStore();
			var totalRow = "";
			if (store.getCount() > 0) totalRow = store.getAt(index).get(DisplaySumInName);
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
			}
		}
	});


	//alert();
	//debugger;


	Ext.QuickTips.init(); //注意，提示初始化必须要有
	grid.getStore().on('load', function(s, records) {
		var girdcount = 0;
		s.each(function(r) {
			if (r.get(DisplaySumInName) == '总入液量=') {
				grid.getView().getRow(girdcount).style.backgroundColor = '#F7FE2E';
			}
			if (r.get(DisplaySumInName) == '入液量=') {
				grid.getView().getRow(girdcount).style.backgroundColor = '#A7FE2E';
			}
			//打印信息，如果换页记录有颜色标记
			if (r.get("RowPrintInfo") != undefined) {
				var printinfo = r.get("RowPrintInfo")
				if (printinfo != "") {
					var spp = printinfo.split('-')
						//alert(spp)
					for (k = 0; k < spp.length; k++) {
						var parrs = spp[k].split('>')
							//alert(parrs)
						var pparr = parrs[1].split('/')
						if (pparr[0] == pparr[1]) {
							grid.getView().getCell(girdcount, 0).style.backgroundColor = '#8DEEEE';
						}
					}

				}
			}
			girdcount = girdcount + 1;
		});
		//scope:this
	});
	setTimeout("find()", 0)
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
	//test()
}

function test() {
	var str = ""
	for (var i = 0; i < str.length; i++) {
		var code = str.charCodeAt(i);
		alert(code)
	}

}
//生成每条记录的痕迹
function makehj() {
	var page = tkMakeServerCall("NurEmr.webheadchange", "getheadpagerow", EpisodeID, EmrCode, "", CurrHeadDr, "", "") //计算当期表头起始页码		
	if (page == "") page = 0
	var zkflag = 0;
	if (zkflag == "1") //转科
	{
		var PrnLoc = patloc; //转科打印时设置床号 如果没更新转科这句屏蔽
	} else {
		var PrnLoc = session['LOGON.CTLOCID'];
	}
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, "DHCNURBG_HZHL^" + session['LOGON.CTLOCID'] + "^" + EpisodeID + "^" + session['LOGON.USERID']);
	LabHead = LabHead.replace(/&/g, "$");
	var stdate = "" //tm[2];
	var stim = "" //tm[3];
	var edate = "" //tm[4];
	var etim = "" //tm[5];

	//是否启用转科开关，默认不启用：1 启用；0 不启用		
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "tranflag", EmrCode, zkflag);
	//续打开关，默认不许打-- 0：不续打；1:启用续打功能
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "xuflag", EmrCode, "0");
	//打印起始页的页码
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "curPages", EmrCode, "0");
	//转科打印时是否换页立即换页，默认换页 ---1 换页  0 不换页
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "SplitPage", EmrCode, "1");
	//打印内容线条类型，默认是一条记录打印一直线：1 一条记录一条线；0 一行文字打印一条线 
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "dxflag", EmrCode, "1");
	//预览打印 设置起始页和打印机 0 不弹出 1 弹出
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "previewPrint", EmrCode, "0");
	//外框打印，Y--打印所有，其他--按内容行高打印
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "AllLine", EmrCode, "Y");
	//是否生成打印记录
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "Makeprintinfo", EmrCode, "Y");
	//是否生成奇偶打印记录
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeInfo", EmrCode, "N");
	//是否预览
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "PreView", EmrCode, "1");

	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeTemp", EmrCode, "N");
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakePic", EmrCode, "N");
	//是否开始生成图片
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "StartMakePic", EmrCode, "N");
	//生成的图片是否上传ftp
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "IfUpload", EmrCode, "N");
	//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeAllPages", EmrCode, "N");

	var EmrType = 2; //1:混合单 2：记录单 3：评估单
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode + "!" + CurrHeadDr;
	//alert(parr)	
	var link = WebIp + "/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID=" + EpisodeID + "&EmrCode=" + EmrCode + "&EmrType=" + EmrType + "&ItmName=" + prncode + "&Parrm=" + parr + "&PrnLoc=" + PrnLoc + "&PrnBed=" + bedCode + "&LabHead=" + LabHead + "&curhead=" + CurrHeadDr;
	//alert(link)
	window.location.href = link;

	//清除参数
	//tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","KillEmrTmpGlobal",EmrCode);

	setTimeout("find()", 3000);

}

//生成图片
function MakePicturePGd() {
	var mygrid = Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		alert("请选择需要生成图片的数据!")
		return;
	} else {
		id = rowObj[0].get("par")
	}
	if (id) {
		PrintCommPic.StartMakePic = "Y" //图片
			//以下4句请参考butPrintFn方法
		PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
		PrintCommPic.ItmName = "DHCNURPRNFFYC";
		var subid = id
		PrintCommPic.MthArr = "Nur.DHCMoudData:getVal&parr:" + subid + "!";
		PrintCommPic.PrintOut();
		PrintCommPic.NurRecId = id //图 片
		PrintCommPic.EmrCode = EmrCode //图片
		PrintCommPic.EpisodeID = EpisodeID //图片
		PrintCommPic.curPages = 0; //图片
		PrintCommPic.MakeTemp = "Y"; //图片
		PrintCommPic.filepath = WebIp + "/DHCMG/HLBLMakePictureSet.xml" //图片
			//PrintComm.MakeAllPages="Y";    //图片
		PrintCommPic.MakePicture(); //图片		
	}
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

//表头变更列录入值后判断是否设定了表头
function AfterEditFn(e) {
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
							//alert(33)
							//find()
							//return
							//find()
					} else {

						var flag = tkMakeServerCall("NurEmr.webheadchange", "getcurheaditmname", session['LOGON.CTLOCID'], EmrCode, curfield, CurrHeadDr)
							//alert(flag+curfield+CurrHeadDr+EmrCode)
						if (flag == "") {
							alert("请先设置该列表头再录入数据")
							selectedrow.set(curfield, "")
								//find()
								//return
								//	find()
						}
					}
				}

			}

		}
	}

}
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
			handler: function() {
				var val = Ext.getCmp("BTItem2").getValue()
					//alert(CurrHeadDr)
				var ret = tkMakeServerCall("NurEmr.webheadchange", "SaveCurHeadItem", EpisodeID, EmrCode, session['LOGON.USERID'], CurrHeadDr, selecteditemid, val)
				selecteditemid = ""
				self.location.reload();
			}
		}, {
			text: '取消',
			handler: function() {
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

function gridclick() {
	var grid = Ext.getCmp("mygrid");

	var rowObj = grid.getSelectionModel().getSelections();
	//var rowObjddd = grid.getSelectionModel().hasSelection();
	var len = rowObj.length;
	//alert(len+"@"+rowObjddd)  //getSelectionModel

	if (len < 1) {
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});1
		return;
	} else {
		//EpisodeIDF=rowObj[0].get("Adm");
		/*for (i = 0; i < top.frames.length; i++) {
			alert(top.frames[i].name);
		}*/
		var frm = top.document.forms["fEPRMENU"];
		//frm.EpisodeID.value=EpisodeID;
		// ModConsult();
	}
}

var storespechar = new Array();

function SepcialChar() {
	var grid = new Ext.grid.GridPanel({
		id: 'mygridspecchar',
		name: 'mygridspecchar',
		title: '',
		stripeRows: true,
		height: 250,
		width: 120,
		tbar: [{
			id: 'insertBtn',
			handler: insertSpecChar,
			text: '插入'
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
		viewConfig: {
			forceFit: false
		}
	});
	storespechar = new Array();
	var GetQueryData = document.getElementById('GetQueryData11');
	var parr = "";
	//alert(11)
	var a = cspRunServerMethod(GetQueryData.value, "User.DHCTEMPSPECIALCHAR:CRItem", "", "AddSpecChar");
	//alert(22)
	grid.store.loadData(storespechar);
	var window = new Ext.Window({
		title: '特殊字符',
		width: 138,
		height: 285,
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
	//alert(str)
	var obj = eval('(' + str + ')');
	storespechar.push(obj);
}

function insertSpecChar() {
	var grid = Ext.getCmp('mygridspecchar');
	//弹出界面中Grid  DHCNURSPECCHAR
	//var rowObj = grid.getSelectionModel().getSelections();
	var selModel = grid.getSelectionModel();
	if (selModel.hasSelection()) {
		var selections = selModel.getSelections();
		var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
		var specchardesc = grid.store.getAt(rowIndex).data.desc;
		//alert(specchardesc)
		var mygrid = Ext.getCmp('mygrid');
		var myrowIndex = mygrid.store.indexOf(mygrid.getSelectionModel().getSelected());
		var myspecchardesc = mygrid.store.getAt(myrowIndex).data.desc;
		//alert(myspecchardesc)
		var oldStr = mygrid.store.getAt(mygrid.rowIndex).get(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex));
		if (oldStr) specchardesc = oldStr + specchardesc
		mygrid.store.getAt(mygrid.rowIndex).set(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex), specchardesc);
		mygrid.startEditing(mygrid.rowIndex, mygrid.columnIndex);
	}
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
	var IfCancelRec = Ext.getCmp("IfCancelRec").getValue();

	//var CurrHeadDr="";
	var parr = adm + "^" + StDate.value + "^" + StTime.value + "^" + Enddate.value + "^" + EndTime.value + "^" + EmrCode + "^" + IfCancelRec + "^" + CurrHeadDr;
	//var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurHCRecComm:GetCareRecComm", "parr$" + parr, "AddRec");
	//mygrid.store.loadData(REC);
	//alert(parr)
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on("beforeLoad", function() {
		mygrid.store.baseParams.parr = parr; //传参数，根据原来的方式修改
	});
	mygrid.getStore().addListener('load', handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
	mygrid.store.load({
		params: {
			start: 0,
			limit: 30
		}
	})
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
	var IfCancelRec = Ext.getCmp("IfCancelRec").getValue();
	var parr = adm + "^" + StDate.value + "^" + StTime.value + "^" + Enddate.value + "^" + EndTime.value + "^" + EmrCode + "^" + IfCancelRec + "^" + CurrHeadDr;
	// debugger;
	//alert(parr)
	//var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurHCRecComm:GetCareRecComm", "parr$" + parr, "AddRec");
	//var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurHCRecComm:GetCareRecComm", "parr$" + parr, "AddRec");
	//mygrid.store.loadData(REC);
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on("beforeLoad", function() {
		mygrid.store.baseParams.parr = parr; //传参数，根据原来的方式修改
	});
	mygrid.getStore().addListener('load', handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
	mygrid.store.load({
		params: {
			start: 0,
			limit: 30
		}
	})
}

function handleGridLoadEvent(store, records) {
	var grid = Ext.getCmp('mygrid');
	var gridcount = 0;

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
		// alert(printarrST)
	store.each(function(r) {
		var rowid = r.get("par") + "||" + r.get("rw")
		if (r.get('CareDate') != "") //日期格式转换
		{
			var date = getDate(r.get('CareDate'));
			grid.store.getAt(gridcount).set("CareDate", date);
		}
		store.commitChanges()
		if (printinfoST != "") {
			//alert(printinfoST[0]) 
			//alert(rowid) 
			if (rowid != printarrST[0]) {
				if (printarr[0].indexOf(rowid) > -1) //该条记录已打印
				{
					grid.getView().getRow(gridcount).style.backgroundColor = printcolor;
				}
				if (printarr[1].indexOf(rowid) > -1) //该条记录未打印
				{
					grid.getView().getRow(gridcount).style.backgroundColor = noprintcolor;
				}
				if (printarr[2].indexOf(rowid) > -1) //该条记录有修改
				{
					grid.getView().getRow(gridcount).style.backgroundColor = havechangecolor;
				}
			} else //打印记录索引行
			{
				//alert(printarrST[3])                          
				var pinfo = tkMakeServerCall("Nur.DHCNurRecPrint", "getval", r.get("par") + "&" + r.get("rw"))
				var pprr = pinfo.split('^')
					// alert(pprr)                 
				if (printarrST[3] == "0") {
					grid.getView().getRow(gridcount).style.backgroundColor = Startcolor;
				} else if (pprr[4] == "2") //该条有修改
				{

					grid.getView().getRow(gridcount).style.backgroundColor = havechangecolor;
				} else {
					grid.getView().getRow(gridcount).style.backgroundColor = printcolor;
				}
			}
		}
		gridcount = gridcount + 1;
	});


}

function findStat() { //查询出入液量合计
	var adm = EpisodeID;
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var GeInOutAmount = document.getElementById('GeInOutAmount');
	var mygrid = Ext.getCmp("mygrid");
	alert(adm + "|" + StDate.value + "|" + StTime.value + "|" + Enddate.value + "|" + EndTime.value + "|" + EmrCode)
	var a = cspRunServerMethod(GeInOutAmount.value, adm, StDate.value, StTime.value, Enddate.value, EndTime.value, EmrCode);
	if (a == "") {
		Ext.Msg.alert('提示', "无护理记录数据!");
		return;
	}
	//additm();
	var count = additmstat(Enddate.value, EndTime.value);
	var tt = a.split('^');
	//alert(a);
	mygrid.getSelectionModel().selectRow(mygrid.store.getCount() - 1);
	//mygrid.getSelectionModel().selectRow(0); 
	//var count = grid.store.getCount();   
	//alert(count+"@"+mygrid.getSelectionModel().getSelections()[0])
	for (i = 0; i < tt.length; i++) {
		itm = tt[i].split('|');
		mygrid.getSelectionModel().getSelections()[0].set(itm[0], itm[1]);
	}
	//alert(tt);

}

function findStat2() { //查询出入液量合计
	var adm = EpisodeID;
	var StDate = diffDate(new Date(), 0);
	var StTime = "06:00"
	var Enddate = diffDate(new Date(), 0)
	var EndTime = "17:00"
		//Ext.getCmp("mygridenddate");
	var GeInOutAmount = document.getElementById('GeInOutAmount');
	var mygrid = Ext.getCmp("mygrid");
	//alert(adm+"|"+StDate+"|"+StTime+"|"+Enddate+"|"+EndTime+"|"+EmrCode)
	var a = cspRunServerMethod(GeInOutAmount.value, adm, StDate, StTime, Enddate, EndTime, EmrCode);
	//alert(a)
	if (a == "") {
		Ext.Msg.alert('提示', "无护理记录数据!");
		return;
	}
	//additm();
	var count = additmstat(Enddate, EndTime);
	var tt = a.split('^');
	//alert(a);
	mygrid.getSelectionModel().selectRow(mygrid.store.getCount() - 1);
	//mygrid.getSelectionModel().selectRow(0); 
	//var count = grid.store.getCount();   
	//alert(count+"@"+mygrid.getSelectionModel().getSelections()[0])
	for (i = 0; i < tt.length; i++) {
		itm = tt[i].split('|');
		mygrid.getSelectionModel().getSelections()[0].set(itm[0], itm[1]);
	}
	//alert(tt);

}

function findStatCL() { //查询出入液量合计
	var adm = EpisodeID;
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var GeInOutAmount = document.getElementById('GeInOutAmount');
	var mygrid = Ext.getCmp("mygrid");
	//alert(adm+"|"+StDate.value+"|"+StTime.value+"|"+Enddate.value+"|"+EndTime.value+"|"+EmrCode)
	var a = cspRunServerMethod(GeInOutAmount.value, adm, StDate.value, StTime.value, Enddate.value, EndTime.value, "DHCNURBG_HZHL@CL");
	if (a == "") {
		Ext.Msg.alert('提示', "无护理记录数据!");
		return;
	}
	//additm();
	var count = additmstat(Enddate.value, EndTime.value);
	var tt = a.split('^');
	//alert(a);
	//mygrid.getSelectionModel().selectRow(mygrid.store.getCount()-1);   
	mygrid.getSelectionModel().selectRow(0);
	//var count = grid.store.getCount();   
	//alert(count+"@"+mygrid.getSelectionModel().getSelections()[0])
	for (i = 0; i < tt.length; i++) {
		itm = tt[i].split('|');
		if ((itm[0] == "Item6") || (itm[0] == "Item7")) {
			//continue;
			itm[1] = "";
		}
		//alert(itm)
		mygrid.getSelectionModel().getSelections()[0].set(itm[0], itm[1]);
	}
	//alert(tt);

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
	//alert(str)
	var obj = eval('(' + str + ')');
	obj.CareDate = getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}
//end for getRowClass  

function save() {
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(len)
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	//for (var i = 0; i < store.getCount(); i++) {
	//	list.push(store.getAt(i).data);
	//	debugger;
	//}
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
			var objval = obj[p] + ""
			if ((p == DisplaySumInName) && (objval.indexOf("入液量") != -1)) {
				flag = "1";
			}
			if ((p == DisplaySumOutName) && (objval.indexOf("出液量") != -1)) {
				flag = "1";
			}
			if (aa == "") {
				str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			} else {
				str = str + p + "|" + aa + '^';
			}
		}
		if ((str != "") && (flag == "0")) {
			if (str.indexOf("CareDate") == -1) {
				str = str + "CareDate|" + CareDate + "^CareTime|" + CareTime;
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
			str = str + "DiagnosDr|" + DiagnosDr + "^HeadDR|" + CurrHeadDr;
			str = str + "^" + CaseMeasureID;
			//alert(str);
			var a = cspRunServerMethod(RecSave.value, EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
			var recid = ""; //生成图片及打印记录
			if ((recpar != "") && (recrw != "")) //生成图片及打印记录
			{
				recid = recpar + "||" + recrw
			}
			//alert(recid)
			if (i == (list.length - 1)) {
				if (IfMakePic == "Y") {
					//alert(recid+"&"+CurrHeadDr+"&"+CareDate+"&"+CareTime)
					//获取要打印的起始页码
					var page = tkMakeServerCall("NurEmr.webheadchange", "getheadpagerow", EpisodeID, EmrCode, recid, CurrHeadDr, CareDate, CareTime) //图片		   
						//alert(page)			   
						//MakePicture(page) //生成图片
				}
			}
			if (a != "0") {
				//alert(a);
				//find()
				//return;
			}
		}
	}
	find();
	window.parent.reloadtree2(EmrCode, "表格");
	var pinfoval = Ext.getCmp("hjflag").getValue();
	if (pinfoval) {
		makeRechj(prncode)
	}
}

function saveAll() {
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//	for (var r = 0;r < len; r++) {
	//list.push(rowObj[r].data);
	//}		
	for (var i = 0; i < store.getCount(); i++) {
		list.push(store.getAt(i).data);
		//debugger;
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
				str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			} else {
				str = str + p + "|" + aa + '^';
			}
		}
		if ((str != "") && (flag == "0")) {
			if (str.indexOf("CareDate") == -1) {
				str = str + "CareDate|" + CareDate + "^CareTime|" + CareTime;
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
			str = str + "DiagnosDr|" + DiagnosDr + "^HeadDR|" + CurrHeadDr;
			str = str + "^" + CaseMeasureID;
			//alert(str);
			var a = cspRunServerMethod(RecSave.value, EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
			var recid = ""
			if ((recpar != "") && (recrw != "")) //图片
			{
				recid = recpar + "||" + recrw
			}
			//alert(recid)
			if (i == (list.length - 1)) {
				if (IfMakePic == "Y") {
					var page = tkMakeServerCall("NurEmr.webheadchange", "getheadpagerow", EpisodeID, EmrCode, recid, CurrHeadDr, CareDate, CareTime) //图片		   
						//alert(page)			   
					//MakePicture(page) //生成图片
				}
			}
			if (a != "0") {
				//alert(a);
				//find()
				//return;
			}
		}
	}
	find();
	window.parent.reloadtree2(EmrCode, "表格");
}

function savebt() {
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
	//for (var i = 0; i < store.getCount(); i++) {
	//	list.push(store.getAt(i).data);
	//	debugger;
	//}
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
			if (p == "") continue;
			if ((p == DisplaySumInName) && (obj[p].indexOf("入液量") != -1)) {
				flag = "1";
			}
			if ((p == DisplaySumOutName) && (obj[p].indexOf("出液量") != -1)) {
				flag = "1";
			}
			if (aa == "") {
				str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			} else {
				str = str + p + "|" + aa + '^';
			}
		}
		if ((str != "") && (flag == "0")) {
			if (str.indexOf("CareDate") == -1) {
				str = str + "CareDate|" + CareDate + "^CareTime|" + CareTime;
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
			str = str + "DiagnosDr|" + DiagnosDr + "^HeadDR|" + curhead;
			str = str + "^" + CaseMeasureID;
			//alert(str);
			var a = cspRunServerMethod(RecSave.value, EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
			if (a != "0") {
				alert(a);
				return;
			}
		}
	}
	find();
}
//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
function gettime() {
	var a = Ext.util.Format.dateRenderer('h:m');
	return a;
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
	//alert(count)
	var r = new Plant({
		CareDate: new Date(),
		CareTime: new Date().dateFormat('H:i')
	});
	grid.store.commitChanges();
	//grid.store.insert(count,r);
	grid.store.insert(0, r); //新建记录在最前面，
	return;
}

var rightClick = new Ext.menu.Menu({
	id: 'rightClickCont',
	items: [{
		id: 'rMenu2',
		text: '病情措施及处理',
		handler: RecMeasureNew
	}, {
		id: 'rMenu8',
		text: '修改关联表头',
		handler: UpdateRelBT
	}, {
		id: 'rMenu7',
		text: '作废',
		handler: CancelRecord
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

function rowdbClickFn(grid, rowIndex, e) {
	alert('你单击了' + rowIndex);
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

function InOutNod() { //小结
	//alert(11)
	var SaveOutIn = document.getElementById('SaveOutIn');
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先点'统计'按钮!");
		return;
	} else {
		var countstr = ""; //合计项
		var countcls = ICountCls + "&" + OCountCls;
		var tt = countcls.split('&');
		for (i = 0; i < tt.length; i++) {
			if (tt[i] == "") continue;
			countstr = countstr + tt[i] + "|" + objRow[0].get(tt[i]) + "^";
		}
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
		var str = countstr + "^SumInAmount|" + inamount + "^SumOutAmount|" + OutQtAmount + "^CareDate|" + formatDate(CareDate) + "^CareTime|" + CareTime + "^Typ|Nod^" + "InPart|" + InPart + "^OutPart|" + OutPart + "^StatTime|" + StatTime + "^StatHours|" + StatHours;
		var diaggrid = Ext.getCmp('diaggrid');
		if (diaggrid) {
			var selModel = diaggrid.getSelectionModel();
			if (selModel.hasSelection()) {
				var objDiagRow = selModel.getSelections();
				DiagnosDr = objDiagRow[0].get("rw");
				//DiagnosDr="";	
			} else {
				DiagnosDr = "";
			}
		} else {
			DiagnosDr = "";
		}
		str = str + "^DiagnosDr|" + DiagnosDr + "^HeadDR|" + CurrHeadDr;
		//alert(str);
		var a = cspRunServerMethod(SaveOutIn.value, EpisodeID, str, session['LOGON.USERID'], EmrCode);
		find();
	}
}

//日间小结
var Timepoint24 = "06:00"; //24h统计时间点
var Timepoint12 = "18:00"; //日间小结时间点
function InOutSumNod() {
	//var adm=EpisodeID;
	var StDate = diffDate(new Date(), 0)
	var StTime2 = Timepoint24
	var Enddate = diffDate(new Date(), 0)
	var EndTime2 = Timepoint12
		//alert(Timepoint24)
	var aa = tkMakeServerCall("NurEmr.webheadchange", "GetInOutAmountCommAndInsert", "Nod", EpisodeID, StDate, StTime2, Enddate, EndTime2, EmrCode, session['LOGON.USERID'], session['LOGON.CTLOCID'], CurrHeadDr, "true")
	find()
}
//按时间段统计
function InOutSumSeg() {
	//var adm=EpisodeID;
	var StDate = Ext.getCmp("mygridstdate").value;
	var StTime = Ext.getCmp("mygridsttime").value;
	var Enddate = Ext.getCmp("mygridenddate").value;
	var EndTime = Ext.getCmp("mygridendtime").value;
	//alert(CurrHeadDr)
	var aa = tkMakeServerCall("NurEmr.webheadchange", "GetInOutAmountCommAndInsert", "Nod", EpisodeID, StDate, StTime, Enddate, EndTime, EmrCode, session['LOGON.USERID'], session['LOGON.CTLOCID'], CurrHeadDr, "true")
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
		//alert(aa)
		//find()
		// alert(aa)
		//return
	var flag = tkMakeServerCall("NurEmr.webheadchange", "ifexistinoutnew", EpisodeID, Enddate, EndTime, aa);
	// alert(flag)   
	if (flag != "") {
		var alertstr = "体温单中" + EndTime + "点以下项目值有修改：" + flag + "你确定要更新这些值吗"

		var flag = confirm(alertstr);
		if (flag) {
			var id = tkMakeServerCall("NurEmr.webheadchange", "InOutResultSave", EpisodeID, aa, session['LOGON.USERID'], "DHCNUR6", session['LOGON.GROUPDESC'], Enddate, EndTime);
		}
		/* Ext.Msg.show({    
	              title:'再确认一下',    
	              msg: alertstr,    
	              buttons:{"ok":"确定","cancel":"取消"},
	              fn:  function(btn, text){    
	                 if (btn == 'ok'){   	                 	 	                    
	                    //alert(parr)              
	                    var id=tkMakeServerCall("NurEmr.webheadchange","InOutResultSave",EpisodeID,aa,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],Enddate,EndTime);
                     // alert("完成")
	                 }
					        else
	                {   
	                 // alert("完成")  	
	                }            
	             },    
	             animEl: 'newbutton'   
	            }); */
	} else {

		var id = tkMakeServerCall("NurEmr.webheadchange", "InOutResultSave", EpisodeID, aa, session['LOGON.USERID'], "DHCNUR6", session['LOGON.GROUPDESC'], Enddate, EndTime);
		//alert("完成")
	}

	find()

}

function InOutSum() {
	var SaveOutIn = document.getElementById('SaveOutIn');
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先点'统计'按钮!");
		return;
	} else {
		var countstr = ""; //合计项
		//var countcls=ICountCls+"&"+OCountCls;
		var countcls = "Item2&Item3&Item5"
		var tt = countcls.split('&');
		for (i = 0; i < tt.length; i++) {
			if (tt[i] == "") continue;
			countstr = countstr + tt[i] + "|" + objRow[0].get(tt[i]) + "^";
		}
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
		var str = countstr + "^SumInAmount|" + inamount + "^SumOutAmount|" + OutQtAmount + "^CareDate|" + formatDate(CareDate) + "^CareTime|" + CareTime + "^Typ|Sum^" + "InPart|" + InPart + "^OutPart|" + OutPart + "^StatTime|" + StatTime + "^StatHours|" + StatHours;
		//alert(str);
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
		str = str + "^DiagnosDr|" + DiagnosDr + "^HeadDR|" + CurrHeadDr;
		alert(str);
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
		x: 100,
		y: 80,
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
	var arrord = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	arrord = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		id: 'orditmssss',
		x: 100,
		y: 80,
		width: 670,
		height: 560,
		autoScroll: true,
		layout: 'absolute',
		//plain: true,
		//frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arrord
	});

	var mydate = new Date();

	var grid1 = Ext.getCmp("ordgrid");
	var bbar = grid1.getBottomToolbar();
	//bbar.hide();

	//bbarord.render(grid1.bbar);
	tobar = grid1.getTopToolbar();
	tobar.addItem({
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'ordgridstdate',
		value: (diffDate(new Date(), -1))
	}, {
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'ordgridenddate',
		value: new Date()
	});
	tobar.addButton({
			className: 'new-topic-button',
			text: "查询",
			icon: '../Image/icons/magnifier.png',
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
	window.show();
	return;

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
		Ext.each(selections, function(item) {
			var des = item.data.ARCIMDesc;
			des = des.replace("_____", "");
			var ml = item.data.Dose;
			var unit = item.data.DoseUnit;
			if ((unit != "ml") && (unit != "ML")) ml = 0;
			var seqno = item.data.SeqNo;
			var rowIndex = grid.store.indexOf(item);
			for (var i = rowIndex - 1; i >= 0; i--) {
				var subdes = store.getAt(i).data.ARCIMDesc;
				subdes = subdes.replace("_____", "");
				var subml = store.getAt(i).data.Dose;
				var subunit = store.getAt(i).data.DoseUnit;
				if (subunit != "ml") subml = 0;
				var subseqno = store.getAt(i).data.SeqNo;
				if (subseqno == seqno) {
					des = subdes + "," + des;
					ml = eval(ml) + eval(subml);
				} else {
					break;
				}
			}
			//alert(store.getCount());
			for (var i = rowIndex + 1; i < store.getCount(); i++) {
				var subdes = store.getAt(i).data.ARCIMDesc;
				subdes = subdes.replace("_____", "");
				var subml = store.getAt(i).data.Dose;
				//alert(subml);
				var subunit = store.getAt(i).data.DoseUnit;
				//alert(subunit);
				if ((subunit != "ml") && (subunit != "ML")) subml = 0;
				var subseqno = store.getAt(i).data.SeqNo;
				if (subseqno == seqno) {
					des = des + "\n" + subdes;
					ml = eval(ml) + eval(subml);
				} else {
					break;
				}
			}
			//alert(num);
			if (num == 0) {
				caredate = mygrid.getStore().getAt(0).get("CareDate");
				caretime = mygrid.getStore().getAt(0).get("CareTime");
				var objRow = mygrid.getSelectionModel().getSelections();
				if (objRow.length == 0) {

					//alert("请先选择某行!"); 
					return;
				} else {
					objRow[0].set(OrdInName, des);
					//alert(objRow[0].value);
					objRow[0].set(OrdInAmount, ml);
				}
			} else {
				additm();
				//alert(OrdInName+":"+des)
				mygrid.getSelectionModel().selectRow(0);
				mygrid.getSelectionModel().getSelections()[0].set("CareDate", caredate);
				mygrid.getSelectionModel().getSelections()[0].set("CareTime", caretime);
				mygrid.getSelectionModel().getSelections()[0].set(OrdInName, des);
				mygrid.getSelectionModel().getSelections()[0].set(OrdInAmount, ml);
			}
			num++;
		});
	}
}

var CaseMeasureID = ""; //邦定的处置ID
var MeasureRel = new Hashtable();

function sureMeasure() {
	var gform = Ext.getCmp("gform");
	//gform.items.each(eachItem, this);  

	var TxtCaseMeasure = Ext.getCmp('TxtCaseMeasure');
	var frm = Ext.getCmp('CaseForm');
	var aa = document.getElementById("southTab");
	var CareCon = Ext.get("southTab").dom.contentWindow.document.getElementById("DesignForm");
	//alert(CareCon.QichTextCon.GetCellText());
	var win = Ext.get("southTab").dom.contentWindow;
	// var parr="DHCNURBG_HZHL^"+EpisodeID+"^CaseMeasureXml";
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
	var GetQueryData = document.getElementById('GetQueryData1');
	var ordgrid = Ext.getCmp("ordgrid");
	var parr = adm + "^" + StDate.value + "^" + Enddate.value;
	//var a=cspRunServerMethod(GetQueryData.value,"web.DHCNUREMR:GetPatOrd","parr$"+parr,"add");
	// grid.width=document.body.offsetWidth;
	//ordgrid.store.loadData(condata);
	ordgrid.store.on("beforeLoad", function() {
		if (ordgrid.store) {
			ordgrid.store.baseParams.parr = parr; //传参数，根据原来的方式修改
		}
	});
	//ordgrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
	ordgrid.store.load({
		params: {
			start: 0,
			limit: 30
		}
	})
}

function Schlab() {
	condata = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("LabGridstdate");
	var Enddate = Ext.getCmp("LabGridenddate");
	var GetQueryData = document.getElementById('GetQueryData1');
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
	var GetQueryData = document.getElementById('GetQueryData1');
	//alert(GetQueryData);
	var ordgrid = Ext.getCmp("CheckGrid");
	var parr = adm + "^" + StDate.value + "^" + Enddate.value;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurJYRESULT:GetOrdRadia", "parr$" + parr, "AddCheck");
	// grid.width=document.body.offsetWidth;

	ordgrid.store.loadData(condata);
}
//生成图片
function MakePicture(page) {
	var typein = typeof page
	if (typein == "object") page = 0
	if (page == "") page = 0
	var page = tkMakeServerCall("NurEmr.webheadchange", "getheadpagerow", EpisodeID, EmrCode, "", CurrHeadDr, "", "") //计算当期表头起始页码		
	if (page == "") page = 0
	var zkflag = 0;
	if (zkflag == "1") //转科
	{
		var PrnLoc = patloc; //转科打印时设置床号 如果没更新转科这句屏蔽
	} else {
		var PrnLoc = session['LOGON.CTLOCID'];
	}
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, EmrCode + "^" + session['LOGON.CTLOCID'] + "^" + EpisodeID + "^" + session['LOGON.USERID']);
	LabHead = LabHead.replace(/&/g, "$");
	//alert(LabHead)
	var stdate = ""
	var stim = ""
	var edate = ""
	var etim = ""
		//是否启用转科开关，默认不启用：1 启用；0 不启用		
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "tranflag", EmrCode, zkflag);
	//续打开关，默认不许打-- 0：不续打；1:启用续打功能
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "xuflag", EmrCode, "0");
	//打印起始页的页码
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "curPages", EmrCode, page);
	//转科打印时是否换页立即换页，默认换页 ---1 换页  0 不换页
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "SplitPage", EmrCode, "0");
	//打印内容线条类型，默认是一条记录打印一直线：1 一条记录一条线；0 一行文字打印一条线 
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "dxflag", EmrCode, "1");
	//预览打印 设置起始页和打印机 0 不弹出 1 弹出
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "previewPrint", EmrCode, "1");
	//外框打印，Y--打印所有，其他--按内容行高打印
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "AllLine", EmrCode, "Y");
	//是否生成打印记录
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "Makeprintinfo", EmrCode, "N");
	//是否生成奇偶打印记录
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeInfo", EmrCode, "N");
	//是否预览
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "PreView", EmrCode, "1");
	var IfMakePicFlag = "Y";
	var WillUploadFlag = "Y";
	var prnmodes = tkMakeServerCall("User.DHCNURMoudelLink", "getPrintCode", EmrCode) //根据界面模板获取打印模板
	if (prnmodes != "") {
		var prnarr = prnmode.split('|')
		IfMakePicFlag = prnarr[3] //是否生成图片
		WillUploadFlag = prnarr[4] //是否上传ftp
	}
	if (IfMakePicFlag !== "Y") return;
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeTemp", EmrCode, IfMakePicFlag);
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakePic", EmrCode, IfMakePicFlag);
	//是否开始生成图片
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "StartMakePic", EmrCode, IfMakePicFlag);
	//生成的图片是否上传ftp
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "IfUpload", EmrCode, WillUploadFlag);
	//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeAllPages", EmrCode, "Y");
	var EmrType = 2; //1:混合单 2：记录单 3：评估单
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode + "!" + CurrHeadDr;
	//alert(parr)	
	var link = WebIp + "/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID=" + EpisodeID + "&EmrCode=" + EmrCode + "&EmrType=" + EmrType + "&ItmName=" + prncode + "&Parrm=" + parr + "&PrnLoc=" + PrnLoc + "&PrnBed=" + bedCode + "&LabHead=" + LabHead + "&curhead=" + CurrHeadDr;
	window.location.href = link;

	var link = WebIp + "/dhcmg/PrintComm/PrintCommPic.application?method=MakePicture&EpisodeID=" + EpisodeID + "&EmrCode=" + EmrCode + "&EmrType=" + EmrType + "&ItmName=" + prncode + "&Parrm=" + parr + "&PrnLoc=" + PrnLoc + "&PrnBed=" + bedCode + "&LabHead=" + LabHead + "&curhead=" + CurrHeadDr;
	window.location.href = link;
	//清除参数
	//tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","KillEmrTmpGlobal",EmrCode);
}

function printNurRecOld() {
	var page = tkMakeServerCall("NurEmr.webheadchange", "getheadpagerow", EpisodeID, EmrCode, "", CurrHeadDr, "", "") //计算当期表头起始页码		
	if (page == "") page = 0
		//alert(page)		
	var GetHead = document.getElementById('GetPatInfo');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var stdate = ""
	var stim = ""
	var edate = ""
	var etim = ""
	PrintCommPic.RHeadCaption = "";
	PrintCommPic.LHeadCaption = "";
	PrintCommPic.LFootCaption = "";
	PrintCommPic.RFootCaption = "";
	PrintCommPic.TitleStr = ret;
	PrintCommPic.SetPreView("1");
	PrintCommPic.PrnLoc = session['LOGON.CTLOCID'];
	PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	PrintCommPic.previewPrint = "1"; //是否弹出设置界面
	PrintCommPic.stprintpos = 0;
	PrintCommPic.SetConnectStr(CacheDB);
	PrintCommPic.ItmName = prncode; //打印模板
	PrintCommPic.curPages = page; //图片  开始页码
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode + "!" + CurrHeadDr;
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	PrintCommPic.SetParrm(parr);
	PrintCommPic.PrintOut();

}

function printNurRec() {
	var page = tkMakeServerCall("NurEmr.webheadchange", "getheadpagerow", EpisodeID, EmrCode, "", CurrHeadDr, "", "") //计算当期表头起始页码		
	if (page == "") page = 0
	var zkflag = 0;
	if (zkflag == "1") //转科
	{
		var PrnLoc = patloc; //转科打印时设置床号 如果没更新转科这句屏蔽
	} else {
		var PrnLoc = session['LOGON.CTLOCID'];
	}
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, EmrCode + "^" + session['LOGON.CTLOCID'] + "^" + EpisodeID + "^" + session['LOGON.USERID']);
	LabHead = LabHead.replace(/&/g, "$");
	//alert(LabHead)
	var stdate = ""
	var stim = ""
	var edate = ""
	var etim = ""
		//是否启用转科开关，默认不启用：1 启用；0 不启用		
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "tranflag", EmrCode, zkflag);
	//续打开关，默认不许打-- 0：不续打；1:启用续打功能
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "xuflag", EmrCode, "0");
	//打印起始页的页码
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "curPages", EmrCode, page);
	//转科打印时是否换页立即换页，默认换页 ---1 换页  0 不换页
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "SplitPage", EmrCode, "0");
	//打印内容线条类型，默认是一条记录打印一直线：1 一条记录一条线；0 一行文字打印一条线 
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "dxflag", EmrCode, "1");
	//预览打印 设置起始页和打印机 0 不弹出 1 弹出
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "previewPrint", EmrCode, "1");
	//外框打印，Y--打印所有，其他--按内容行高打印
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "AllLine", EmrCode, "Y");
	//是否生成打印记录
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "Makeprintinfo", EmrCode, "N");
	//是否生成奇偶打印记录
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeInfo", EmrCode, "N");
	//是否预览
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "PreView", EmrCode, "1");

	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeTemp", EmrCode, "N");
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakePic", EmrCode, "N");
	//是否开始生成图片
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "StartMakePic", EmrCode, "N");
	//生成的图片是否上传ftp
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "IfUpload", EmrCode, "N");
	//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeAllPages", EmrCode, "N");

	//默认不启用CA打印 1：启用；0：不启用		
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "CAStart", EmrCode, "0");
	//科室是否启用CA--0 不启用；1 启用
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "IsVerifyCALoc", EmrCode, "0");
	var EmrType = 2; //1:混合单 2：记录单 3：评估单
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode + "!" + CurrHeadDr;
	//alert(parr)	
	var link = WebIp + "/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID=" + EpisodeID + "&EmrCode=" + EmrCode + "&EmrType=" + EmrType + "&ItmName=" + prncode + "&Parrm=" + parr + "&PrnLoc=" + PrnLoc + "&PrnBed=" + bedCode + "&LabHead=" + LabHead + "&curhead=" + CurrHeadDr;
	//alert(link)
	window.location.href = link;

	//清除参数
	//tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","KillEmrTmpGlobal",EmrCode);
}

function printNurRecJO() {
	var page = tkMakeServerCall("NurEmr.webheadchange", "getheadpagerow", EpisodeID, EmrCode, "", CurrHeadDr, "", "") //计算当期表头起始页码		
	if (page == "") page = 0
	var zkflag = 0;
	if (zkflag == "1") //转科
	{
		var PrnLoc = patloc; //转科打印时设置床号 如果没更新转科这句屏蔽
	} else {
		var PrnLoc = session['LOGON.CTLOCID'];
	}
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, EmrCode + "^" + session['LOGON.CTLOCID'] + "^" + EpisodeID + "^" + session['LOGON.USERID']);
	LabHead = LabHead.replace(/&/g, "$");
	//alert(LabHead)
	var stdate = ""
	var stim = ""
	var edate = ""
	var etim = ""
		//是否启用转科开关，默认不启用：1 启用；0 不启用		
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "tranflag", EmrCode, zkflag);
	//续打开关，默认不许打-- 0：不续打；1:启用续打功能
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "xuflag", EmrCode, "0");
	//打印起始页的页码
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "curPages", EmrCode, page);
	//转科打印时是否换页立即换页，默认换页 ---1 换页  0 不换页
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "SplitPage", EmrCode, "0");
	//打印内容线条类型，默认是一条记录打印一直线：1 一条记录一条线；0 一行文字打印一条线 
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "dxflag", EmrCode, "1");
	//预览打印 设置起始页和打印机 0 不弹出 1 弹出
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "previewPrint", EmrCode, "1");
	//外框打印，Y--打印所有，其他--按内容行高打印
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "AllLine", EmrCode, "Y");
	//是否生成打印痕迹
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "Makeprintinfo", EmrCode, "N");
	//是否生成奇偶打印痕迹
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeInfo", EmrCode, "Y");
	//是否预览
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "PreView", EmrCode, "1");

	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeTemp", EmrCode, "N");
	//是否生成图片 Y 生成，N 不生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakePic", EmrCode, "N");
	//是否开始生成图片
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "StartMakePic", EmrCode, "N");
	//生成的图片是否上传ftp
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "IfUpload", EmrCode, "N");
	//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm", "SetEmrTempGlobal", "MakeAllPages", EmrCode, "N");
	var EmrType = 2; //1:混合单 2：记录单 3：评估单
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!" + EmrCode + "!" + CurrHeadDr;
	//alert(parr)	
	var link = WebIp + "/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID=" + EpisodeID + "&EmrCode=" + EmrCode + "&EmrType=" + EmrType + "&ItmName=" + prncode + "&Parrm=" + parr + "&PrnLoc=" + PrnLoc + "&PrnBed=" + bedCode + "&LabHead=" + LabHead + "&curhead=" + CurrHeadDr;
	//alert(link)
	window.location.href = link;

	var link = WebIp + "/dhcmg/PrintComm/PrintCommPic.application?method=PrintOutAll&EpisodeID=" + EpisodeID + "&EmrCode=" + EmrCode + "&EmrType=" + EmrType + "&ItmName=" + prncode + "&Parrm=" + parr + "&PrnLoc=" + PrnLoc + "&PrnBed=" + bedCode + "&LabHead=" + LabHead + "&curhead=" + CurrHeadDr;
	//alert(link)
	window.location.href = link;

	//清除参数
	//tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","KillEmrTmpGlobal",EmrCode);

}

function printNurRec2() {
	var GetPrnSet = document.getElementById('GetPrnSet');
	var GetHead = document.getElementById('GetPatInfo');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	//alert(ret)
	var hh = ret.split("^");
	//alert("ddd");
	//debugger;
	var a = cspRunServerMethod(GetPrnSet.value, EmrCode, EpisodeID); //page, caredattim, prnpos, adm,Typ,user
	if (a == "") return;
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, "DHCNURBG_HZHL^" + session['LOGON.CTLOCID'] + "^" + EpisodeID + "^" + session['LOGON.USERID']);
	//alert("DHCNURBG_HZHL^"+session['LOGON.CTLOCID']+"^"+EpisodeID+"^"+session['LOGON.USERID'])
	var tm = a.split("^");
	var stdate = "" //tm[2];
	var stim = "" //tm[3];
	var edate = "" //tm[4];
	var etim = "" //tm[5];
	PrintCommPic.RHeadCaption = "111111"; //"日期:"+appdate.value;
	PrintCommPic.LHeadCaption = "211111"; //"科室:"+dep.getValue();
	PrintCommPic.LFootCaption = "311111";
	PrintCommPic.RFootCaption = "411111";
	//PrintCommPic.RHeadCaption=hh[1];
	//PrintCommPic.LHeadCaption=hh[0];
	//PrintCommPic.RFootCaption="第";
	//PrintCommPic.LFootCaption="页";
	//PrintCommPic.LFootCaption=hh[2];
	//alert(ret);
	PrintCommPic.TitleStr = ret;
	PrintCommPic.SetPreView("1");
	PrintCommPic.PrnLoc = session['LOGON.CTLOCID'];
	PrintCommPic.WebUrl = webIP + "/dthealth/web/DWR.DoctorRound.cls";
	var aa = tm[1].split("&");
	//PrintCommPic.stPage=aa[0];
	//if (aa.length>1) PrintCommPic.stRow=aa[1];
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	PrintCommPic.previewPrint = "1"; //是否弹出设置界面
	//PrintCommPic.stprintpos=tm[0];
	PrintCommPic.stprintpos = 0;
	//alert(PrintCommPic.Pages);
	PrintCommPic.SetConnectStr(CacheDB);
	PrintCommPic.ItmName = "DHCNurPrnMouldXH12"; //338155!2010-07-13!0:00!!
	//debugger;
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!DHCNURBG_HZHL!" + CurrHeadDr;
	//alert(parr)
	//alert(LabHead)
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	//PrintCommPic.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
	if (LabHead != "") PrintCommPic.LabHead = LabHead;
	PrintCommPic.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
	PrintCommPic.PrintOut();
	var lastrowcount = PrintCommPic.lastrowcount
	var pagerows = PrintCommPic.PageRows
	var allpage = PrintCommPic.Allpages
		//additm()
	find()
	var mygrid = Ext.getCmp("mygrid");
	var count = grid.store.getCount();
	//alert(count)
	mygrid.getSelectionModel().selectRow(count - 1);
	//mygrid.getSelectionModel().selectRow(0);   

	mygrid.getSelectionModel().getSelections()[0].set("Item40", lastrowcount + "/" + pagerows + "/" + allpage);
	saveprint()
		//alert(33)

}

function printNurRec3() {
	var GetPrnSet = document.getElementById('GetPrnSet');
	var GetHead = document.getElementById('GetPatInfo');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	var a = cspRunServerMethod(GetPrnSet.value, EmrCode, EpisodeID); //page, caredattim, prnpos, adm,Typ,user
	if (a == "") return;
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, "DHCNURBG_HZHL^" + session['LOGON.CTLOCID'] + "^" + EpisodeID + "^" + session['LOGON.USERID']);


	//alert(LabHead)
	var tm = a.split("^");
	var stdate = "" //tm[2];
	var stim = "" //tm[3];
	var edate = "" //tm[4];
	var etim = "" //tm[5];
	PrintCommPic.RHeadCaption = "111111"; //"日期:"+appdate.value;
	PrintCommPic.LHeadCaption = "211111"; //"科室:"+dep.getValue();
	PrintCommPic.LFootCaption = "311111";
	PrintCommPic.RFootCaption = "411111";
	//alert(ret)
	var stdate = Ext.getCmp("prndate").value;
	ret = ret + "^CareDate@" + stdate
		//alert(ret)
	PrintCommPic.TitleStr = ret;
	PrintCommPic.SetPreView("1");
	PrintCommPic.PrnLoc = session['LOGON.CTLOCID'];
	PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
	var aa = tm[1].split("&");
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	var curpage = Ext.getCmp("curpage").getValue();
	PrintCommPic.curPages = curpage - 1;
	PrintCommPic.previewPrint = "1"; //是否弹出设置界面
	PrintCommPic.stprintpos = 0;
	PrintCommPic.SetConnectStr(CacheDB);
	PrintCommPic.ItmName = "DHCNURMouldPrn_HLJL";
	//alert(CurrHeadDr)


	//alert(prndate) 
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!DHCNURBG_HZHL!" + CurrHeadDr;
	//alert(parr)
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	if (LabHead != "") PrintCommPic.LabHead = LabHead;
	PrintCommPic.SetParrm(parr);
	PrintCommPic.PrintOut();
	return
	var lastrowcount2 = PrintCommPic.lastrowcount
	var pagerows2 = PrintCommPic.PageRows
	var allpage2 = PrintCommPic.Allpages
	if (curpage == 1) {
		allpage2 = allpage2 - 1
	}

	//if (lastrowcount2==pagerows2) return
	find()
	var mygrid = Ext.getCmp("mygrid");
	var count = grid.store.getCount();

	if (count == 0) {
		var StDate = Ext.getCmp("mygridstdate");
		StDate.setValue("2013-01-01")
		find()
		var mygrid = Ext.getCmp("mygrid");
		var count = grid.store.getCount();
		if (count > 0) {
			mygrid.getSelectionModel().selectRow(count - 1);
			mygrid.getSelectionModel().getSelections()[0].set("Item40", lastrowcount2 + "/" + pagerows2 + "/" + allpage2);
			saveprint()
		}

	}
	if (count > 0) {
		mygrid.getSelectionModel().selectRow(count - 1);
		mygrid.getSelectionModel().getSelections()[0].set("Item40", lastrowcount2 + "/" + pagerows2 + "/" + allpage2);
		saveprint()
	}
}

function printNurRecbq() {
	var GetPrnSet = document.getElementById('GetPrnSet');
	var GetHead = document.getElementById('GetPatInfo');
	var ret = cspRunServerMethod(GetHead.value, EpisodeID);
	var hh = ret.split("^");
	var a = cspRunServerMethod(GetPrnSet.value, EmrCode, EpisodeID); //page, caredattim, prnpos, adm,Typ,user
	if (a == "") return;
	var GetLableRec = document.getElementById('GetLableRec');
	var LabHead = cspRunServerMethod(GetLableRec.value, "DHCNURBG_HZHL^" + session['LOGON.CTLOCID'] + "^" + EpisodeID + "^" + session['LOGON.USERID']);
	//alert(LabHead)
	var tm = a.split("^");
	var stdate = "" //tm[2];
	var stim = "" //tm[3];
	var edate = "" //tm[4];
	var etim = "" //tm[5];
	PrintCommPic.RHeadCaption = "111111"; //"日期:"+appdate.value;
	PrintCommPic.LHeadCaption = "211111"; //"科室:"+dep.getValue();
	PrintCommPic.LFootCaption = "311111";
	PrintCommPic.RFootCaption = "411111";
	var stdate = Ext.getCmp("prndate").value;
	ret = ret + "^CareDate@" + stdate
		//alert(ret)
	PrintCommPic.TitleStr = ret;
	PrintCommPic.SetPreView("1");
	PrintCommPic.PrnLoc = session['LOGON.CTLOCID'];
	PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";
	var aa = tm[1].split("&");
	PrintCommPic.stPage = 0;
	PrintCommPic.stRow = 0;
	var curpage = Ext.getCmp("curpage").getValue();
	PrintCommPic.curPages = curpage - 1;
	PrintCommPic.previewPrint = "1"; //是否弹出设置界面
	PrintCommPic.stprintpos = 0;
	PrintCommPic.SetConnectStr(CacheDB);
	PrintCommPic.ItmName = "DHCNurMouldPrnwkbq";
	//alert(CurrHeadDr)
	var parr = EpisodeID + "!" + stdate + "!" + stim + "!" + edate + "!" + etim + "!DHCNURBG_HZHL!" + CurrHeadDr + "!Y";
	//alert(parr)
	PrintCommPic.ID = "";
	PrintCommPic.MultID = "";
	if (LabHead != "") PrintCommPic.LabHead = LabHead;
	PrintCommPic.SetParrm(parr);
	PrintCommPic.PrintOut();
	return
	var lastrowcount2 = PrintCommPic.lastrowcount
	var pagerows2 = PrintCommPic.PageRows
	var allpage2 = PrintCommPic.Allpages
	if (curpage == 1) {
		allpage2 = allpage2 - 1
	}

	//if (lastrowcount2==pagerows2) return
	find()
	var mygrid = Ext.getCmp("mygrid");
	var count = grid.store.getCount();

	if (count == 0) {
		var StDate = Ext.getCmp("mygridstdate");
		StDate.setValue("2013-01-01")
		find()
		var mygrid = Ext.getCmp("mygrid");
		var count = grid.store.getCount();
		if (count > 0) {
			mygrid.getSelectionModel().selectRow(count - 1);
			mygrid.getSelectionModel().getSelections()[0].set("Item40", lastrowcount2 + "/" + pagerows2 + "/" + allpage2);
			saveprint()
		}

	}
	if (count > 0) {
		mygrid.getSelectionModel().selectRow(count - 1);
		mygrid.getSelectionModel().getSelections()[0].set("Item40", lastrowcount2 + "/" + pagerows2 + "/" + allpage2);
		saveprint()
	}
}

function saveprint() {
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	//var rowObj = grid.getSelectionModel().getSelections();
	//var len = rowObj.length;
	//for (var r = 0;r < len; r++) {
	//list.push(rowObj[r].data);
	//}		
	for (var i = 0; i < store.getCount(); i++) {
		if (i == (store.getCount() - 1)) {
			//alert(i)
			list.push(store.getAt(i).data);
		}
		//	debugger;
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
			if (p == "") continue;
			if ((p == DisplaySumInName) && (obj[p].indexOf("入液量") != -1)) {
				flag = "1";
			}
			if ((p == DisplaySumOutName) && (obj[p].indexOf("出液量") != -1)) {
				flag = "1";
			}
			if (aa == "") {
				str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			} else {
				str = str + p + "|" + aa + '^';
			}
		}
		if ((str != "") && (flag == "0")) {
			if (str.indexOf("CareDate") == -1) {
				str = str + "CareDate|" + CareDate + "^CareTime|" + CareTime;
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
			str = str + "DiagnosDr|" + DiagnosDr + "^HeadDR|" + CurrHeadDr;
			str = str + "^" + CaseMeasureID;
			//alert(str);
			var a = cspRunServerMethod(Saveprn, EpisodeID, str, session['LOGON.USERID'], EmrCode, session['LOGON.GROUPDESC']);
			if (a != "0") {
				alert(a);
				return;
			}
		}
	}
	find();
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
ERC = new Array();

function UpdateRelBT() {
	ChangeBT(selectedrow, "UP")
}
var insertheadtime = "06:00"; //插入表头的时间点
//修改记录绑定表头
function ChangeBT(SELOBJ, flag) {
	//alert(select)
	if (SELOBJ) {
		myId = "";
		var arr = new Array();
		var LINKBTITM = new Ext.form.ComboBox({
			name: '修改关联表头',
			id: 'btlink',
			store: new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url: "../csp/dhc.nurse.ext.common.getdata.csp"
				}),
				reader: new Ext.data.JsonReader({
					root: 'rows',
					totalProperty: 'results',
					fields: [{
						'name': 'LocCode',
						'mapping': 'LocCode'
					}, {
						'name': 'LocDes',
						'mapping': 'LocDes'
					}, {
						'name': 'rw',
						'name': 'rw'
					}]
				}),
				baseParams: {
					className: 'NurEmr.webheadchange',
					methodName: 'getheadlist',
					type: 'Query'
				}
			}),
			tabIndex: '0',
			listWidth: '500',
			x: 5,
			y: 5,
			width: 500,
			xtype: 'combo',
			displayField: 'LocDes',
			valueField: 'LocCode',
			hideTrigger: false,
			forceSelection: true,
			triggerAction: 'all',
			minChars: 1,
			pageSize: 20,
			typeAhead: true,
			typeAheadDelay: 1000,
			//editable:false,
			loadingText: 'Searching...'
		});
		var windowbts = new Ext.Window({
			title: '',
			width: 520,
			height: 100,
			x: curpositionofX,
			y: curpositionofY,
			autoScroll: true,
			layout: 'absolute',
			buttonAlign: 'center',
			items: [LINKBTITM],
			buttons: [{
				text: '保存',
				id: 'sure',
				x: 5,
				width: 20,
				handler: function() {
					var val = LINKBTITM.value;
					//alert(val)
					if (val == undefined) val = ""
					if (val != "") {
						var rw = SELOBJ.get("rw")
						var par = SELOBJ.get("par")
						var id = par + "||" + rw
							//alert(id)
						tkMakeServerCall("Nur.DHCNurseRecSub", "SetHeadDR", id, val)
						windowbts.close()
						if (flag == "UP") find()
						else {
							find2()
						}
					}
				}
			}, {
				text: '关闭',
				id: 'close',
				width: 20,
				handler: function() {
					windowbts.close();
				}
			}]
		});
		windowbts.show();
		var btgrid = Ext.getCmp("btlink");
		btgrid.store.on("beforeLoad", function() {
			var parr = EpisodeID + "^" + session['LOGON.USERID'] + "^" + EmrCode + "^" + insertheadtime
			btgrid.store.baseParams.parr = parr;
		});
		btgrid.store.load({
			params: {
				start: 0,
				limit: 20
			},
			callback: function() {
				btgrid.setValue(CurrHeadDr);
			}
		})
	}
}
var curhead = ""

function UpdateBT() {
	var diaggrid = Ext.getCmp("mybt");
	var objDiagnosRow = diaggrid.getSelectionModel().getSelections();
	//alert(objDiagnosRow)
	if (objDiagnosRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条诊断记录!");
		return;
	}
	var grid = Ext.getCmp("mygrid");
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		Ext.Msg.alert('提示', "请先选择一条护理记录!");
		return;
	} else { //alert(objRow)
		var par = objDiagnosRow[0].get("par");
		var rw = objDiagnosRow[0].get("rw");
		curhead = par + "_" + rw
			//alert(curhead)
		if (curhead != "") {
			savebt();
		}
	}
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
	//var GetQueryData=document.getElementById('GetQueryDatal');
	var GetQueryData = document.getElementById('GetQueryData1');
	//alert(GetQueryData);
	var diaggrid = Ext.getCmp("diaggrid");
	//alert(adm);
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurseRecordComm:GetCopyDiagnos", "parr$" + adm, "AddDiag");
	diaggrid.store.loadData(condata);
}

function SchBT() {
	MeasureRel = new Hashtable();
	REC = new Array();
	var adm = EpisodeID;
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mybt");
	var parr = adm + "^" + "DHCNURHEADCHANGE";
	// debugger;
	//alert(parr)
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurRecComm:GetHeadChange", "parr$" + parr, "AddRecbt");
	mygrid.store.loadData(REC);
}

function AddRecbt(str) {
	//var a=new Object(eval(str));
	//alert(str)
	var obj = eval('(' + str + ')');
	obj.CareDate = getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
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
		for (i = 0; i < str.length; i++) {
			code = str.charCodeAt(i);
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
//作废
function CancelRecord() {
	var objCancelRecord = document.getElementById('CancelRecord');
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		alert("请先选择一条护理记录!");
		return;
	} else {
		var flag = confirm("你确定要作废此条记录吗!")
		if (flag) {
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
	//alert(count)
	var r = new Plant({
		CareDate: getDate(statenddate),
		CareTime: statendtime
	});
	grid.store.commitChanges();
	grid.store.insert(count, r);
	return count;
}
//病情变化及处理措施新界面 201406
function MeasureNew() {

	MeasureRel = new Hashtable();
	var grid1 = Ext.getCmp('mygrid');
	var objRow = grid1.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		alert("请先选择一条护理记录!");
		return;
	}
	var par = grid1.getSelectionModel().getSelections()[0].get("par");
	var rw = grid1.getSelectionModel().getSelections()[0].get("rw");
	var rowid = par + "||" + rw;
	if (par == undefined) {
		rowid = "";
	}
	var parr = "DHCNURXH2^" + EpisodeID + "^CaseMeasureXml^" + rowid;
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
			handler: function() {
				sureMeasure();
			}
		}, {
			text: '取消',
			handler: function() {
				window.close();
			}
		}],
		html: '<iframe id ="southTab" name="ddd" style="width:100%; height:100%" src=' + emrknowurl + ' ></iframe>'
	});
	var window = new Ext.Window({
		title: '病情措施及处理',
		x: 100,
		y: 50,
		width: 900, //宽度
		modal: true,
		height: 600, //高度
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
		alert("请选择一条数据");
		return;
	}
	window.show();
}