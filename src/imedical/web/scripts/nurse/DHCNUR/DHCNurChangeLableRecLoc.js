/**
 * @author Administrator
 */
/*
 * grid.store.on('load', function() {
 * grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
 * x.addClass('x-grid3-cell-text-visible'); }); });
 * 
 * grid.getStore().on('load',function(s,records){ var girdcount=0;
 * s.each(function(r){ if(r.get('10')=='数据错误'){
 * grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E'; }
 * girdcount=girdcount+1; }); //scope:this });
 */
 //alert(1);
var grid;
var recId="";
var locdata = new Array();
var modledata = new Array();
var labledata = new Array();
var labledata1 = new Array();
var loc = session['LOGON.CTLOCID'];
//alert(getloc);
cspRunServerMethod(getloc, 'addloc');
function addloc(a, b) {
	locdata.push({
				loc : a,
				locdes : b
			});
}
var storeloc = new Ext.data.JsonStore({
			data : locdata,
			fields : ['loc', 'locdes']
		});
var GetModel = document.getElementById('GetModel');
//alert(GetModel);
if (GetModel) {
	//alert(3);
	//cspRunServerMethod(GetModel.value, 'addmodel');
}
function addmodel(a, b) {
	modledata.push({
				modle : a,
				modledesc : b
			});
}
var modlestore = new Ext.data.JsonStore({
			data : modledata,
			fields : ['modle', 'modledesc']
		});

function addmodelblank(a, b) {
	labledata1 = [];
	labledata1[0] = a;
	labledata1[1] = b;
	labledata[labledata.length] = labledata1;
}

var locField = new Ext.form.ComboBox({
			id : 'locsys',
			hiddenName : 'loc1',
			store : storeloc,
			width : 200,
			fieldLabel : '科室',
			valueField : 'loc',
			displayField : 'locdes',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
		});
locField.on('select', function() {
			find();
			var loc= Ext.get("loc1").dom.value;
	   if (loc == "")
		  loc = session['LOGON.CTLOCID'];
			cspRunServerMethod(GetModel.value,loc,'addmodel');
			combo.store.loadData(modledata);	
		});
var combo = new Ext.form.ComboBox({
			id : 'mygridmodle',
			store : modlestore,
			valueField : 'modle',
			displayField : 'modledesc',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			// emptyText:'按模版查询...',
			selectOnFocus : true,
			width : 250,
			listeners : {
				select : function(combo, record, index) {
					lablecombo.clearValue();
					labledata = [];
					//var GetMoldelBlank = document.getElementById('GetMoldelBlank');
					//cspRunServerMethod(GetMoldelBlank.value, combo.value,'addmodelblank');
					tkMakeServerCall("NurEmr.webheadchange","GetMoldelBlank", combo.value,'addmodelblank')
					//alert(Ext.encode(labledata))
					lablecombo.store.loadData(labledata);
				}
			}
		});
var lablecombo = new Ext.form.ComboBox({
			id : 'mygridlable',
			store : new Ext.data.SimpleStore({
						fields : ['lable', 'labledesc'],
						data : []
					}),
			valueField : 'lable',
			displayField : 'labledesc',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			selectOnFocus : true,
			width : 70
		});

function BodyLoadHandler() {
	//alert(1);
	setsize("mygridpl", "gform", "mygrid");
	// fm.doLayout();
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.hide();

	grid = Ext.getCmp('mygrid');
	// grid.setTitle(gethead());

	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.addItem('科室', locField, '模版', combo, '对应空白栏', lablecombo, '标题', {
				xtype : 'textfield',
				id : 'mygridlabledesc',
				fieldLabel : '标题名称'
			});
	tobar.addItem("-"); 
	tobar.addButton({
				className : 'new-topic-button',
				text : "增加",
				handler : add,
				icon:'../images/uiimages/edit_add.png',
				id : 'mygridAdd'
			});
	tobar.addItem("-"); 
	tobar.addButton({
				className : 'new-topic-button',
				text : "修改",
				handler : update,
				icon:'../images/uiimages/pencil.png',
				id : 'mygridSave'
			});
	tobar.addItem("-"); 
	tobar.addButton({
				className : 'new-topic-button',
				text : "删除",
				handler : labledelete,
				icon:'../images/uiimages/edit_remove.png',
				id : 'mygridDelete'
			});
	tobar.addItem("-"); 
	tobar.addButton({
				className : 'new-topic-button',
				text : "查询",
				handler : find,
				icon:'../images/uiimages/search.png',
				id : 'mygridSch'
			});
			tobar.addItem("-"); 
	// tobar.render(grid.tbar);
	var bbar = grid.getBottomToolbar ();
	bbar.hide();
	var bbar2 = new Ext.PagingToolbar({
	    pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	tobar.doLayout();
	grid.addListener('rowclick', rowClickFn);
	find();
}
var REC = new Array();
function rowClickFn(grid, rowIndex, e) {
	// alert('你单击了' + rowIndex);
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var loc = Ext.getCmp("locsys");
	loc.setValue(rowObj[0].get("LocId"))
	var modle = Ext.getCmp("mygridmodle");
	modle.setValue(rowObj[0].get("MoudleCode"))
	var lable = Ext.getCmp("mygridlable");
	lable.setValue(rowObj[0].get("LableId"))
	var labledesc = Ext.getCmp("mygridlabledesc");
	labledesc.setValue(rowObj[0].get("LableDesc"))
	recId = rowObj[0].get("rw");
}
function find() {
	REC = new Array();
	var GetQueryData = document.getElementById('GetQueryData');
	//var GetQueryData = Ext.getCmp("GetQueryData");
	var mygrid = Ext.getCmp("mygrid");
	var loc= Ext.get("loc1").dom.value;
	var model=Ext.getCmp("mygridmodle").getValue();
	//alert(loc);
	//if (loc == "")
	//	loc = session['LOGON.CTLOCID'];
	var parr = loc+"^"+model;
	//alert(parr)
	//var a = cspRunServerMethod(GetQueryData.value,"NurEmr.webheadchange:GetLocLable", "parr$"+loc, "AddRec");
	//alert(a);
	//mygrid.store.loadData(REC);
	mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
    });    
    //mygrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
    mygrid.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })
}
function AddRec(str)
{
	//var a=new Object(eval(str));
	//alert(str)
	var obj = eval('(' + str + ')');
	REC.push(obj);
	//debugger;
}
function AddRec11(a1, a2, a3, a4, a5, a6, a7) {
	// debugger;
	REC.push({
				LableLoc : a1,
				MoudleName : a2,
				LableId : a3,
				LableDesc : a4,
				rw : a5,
				MoudleCode : a6,
				LocId : a7
			});
}
function add() {
	recId = "";
	save();
}
function update() {
	save();
}
function labledelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择行!");
		return;
	};
	var flag = confirm("你确定要删除这条记录吗？")
	if(flag)
	{
		var LableRecDelete = document.getElementById('LableRecDelete');
		var parr = recId + "^" + session['LOGON.USERID'] + "^"+ session['LOGON.GROUPDESC'];
		// alert(parr)
		var ee = cspRunServerMethod(LableRecDelete.value, parr);
		if (ee != "0") {
			alert(ee);
			return;
		}
	}
	clearscreen();
	find();
}

function save() {
	var grid = Ext.getCmp("mygrid");
	var loc = Ext.get("loc1").dom.value;
	if (loc == "")
		loc = session['LOGON.CTLOCID'];
	var modle = Ext.getCmp("mygridmodle");
	if (modle.getValue() == "") {
		alert("请选择'模版'!");
		return;
	};
	var lable = Ext.getCmp("mygridlable");
	if (lable.getValue() == "") {
		alert("请选择'对应空白栏'!");
		return;
	};
	var labledesc = Ext.getCmp("mygridlabledesc");
	if (labledesc.getValue() == "") {
		alert( "请填写'标题名称'!");
		return;
	};
	// alert(ItmCode+","+loc+","+parr+","+session['LOGON.USERID']);
	var parr = recId + "^" + modle.getValue() + "^" + loc + "^"+ lable.getValue() + "^" + labledesc.getValue() + "^"+ session['LOGON.USERID'];
	//alert(parr);
	var ee = cspRunServerMethod(SaveLoc.value, parr);
	if (ee != "0") {
		alert(ee);
		return;
	}
	clearscreen();
	find();
}
function clearscreen() {
	//var loc = Ext.getCmp("locsys");
	//if (loc) loc.setValue("");
	var modle = Ext.getCmp("mygridmodle");
	if (modle) modle.setValue("");
	var lable = Ext.getCmp("mygridlable");
	if (lable) lable.setValue("");
	var labledesc = Ext.getCmp("mygridlabledesc");
	if (labledesc) labledesc.setValue("");
}