/**
 * @author Administrator
 */

var ret="";
var checkret="";
var comboret="";
var locdata = new Array();
var DayType="";
function addloc(a, b) {
	locdata.push({
		id : a,
		desc : b
	});
}
function onFocus(field)
{
	//alert(2)
	//if(field.isDirty())ChangeDateFn()
}

function BodyLoadHandler(){
	
	DayType=""
	var dep = Ext.getCmp("LocDr");
	if (dep != null) {
		cspRunServerMethod(getloc, 'addloc');
		dep.store.loadData(locdata);
		dep.setValue(session['LOGON.CTLOCID'])
		//dep.on('change', ChangeDepFn);
		dep.disable();
	}
	var mydate = new Date();
	var appdate = Ext.getCmp("CareDate");
	appdate.setValue(diffDate(mydate, 0));
	appdate.on('change', ChangeDateFn);
	appdate.on('select', ChangeDateFn);
	//appdate.on('focus', onFocus);
	var hour=mydate.getHours();
	/*if(hour>=7&&hour<19)
	{
	  DayType="Day"; //白天默认查白班
  }else
  	{
  		DayType="Night";
  		}*/
  		SetDefaultValue();
		Ext.getCmp('mygrid').getBottomToolbar().pageSize=1000;
	setgrid();
	if(LockFlag==1)
	{
		alert(LockFlag)
		return;
	}
		var but1=Ext.getCmp("mygridbut2");
	but1.setText("全部保存");
	//	var but1=Ext.getCmp("mygridbut4");
//	but1.setText("全部保存");
	var btnSearch = Ext.getCmp("btnSearch");
	btnSearch.on("click",ChangeDateFn);
	
	/*var btnSearchDay = Ext.getCmp("btnSearchDay");
	btnSearchDay.on("click",SearchDay);
	var btnSearchNight = Ext.getCmp("btnSearchNight");
	btnSearchNight.on("click",SearchNight);*/
	var btnSaveDay = Ext.getCmp("btnSaveDay");
	btnSaveDay.on("click",SaveDay);
	btnSaveDay.hide();
	var btnSaveNight = Ext.getCmp("btnSaveNight");
	btnSaveNight.on("click",SaveNight);
	btnSaveNight.hide();
	var butadd=Ext.getCmp('mygridbut1');
	butadd.on("click",additm);
	butadd.hide();
	var butsave=Ext.getCmp('mygridbut2');
	butsave.setText("保存");
	butsave.hide();
	//butsave.on("click",savegrid);
	var but=Ext.getCmp("butSave");
	but.on('click',save);
	var but=Ext.getCmp("butPrint");
	but.on('click',Print);
		Ext.override(Ext.Editor, {
			onSpecialKey : function(field, e) {
				var key = e.getKey();
				this.fireEvent('specialkey', field, e);
			}
		});
	Ext.override(Ext.grid.RowSelectionModel, {
			onEditorKey : function(F, E) {
				var C = E.getKey(), G, D = this.grid, B = D.activeEditor;
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
    var grid=Ext.getCmp('mygrid');
	var tobar=grid.getTopToolbar();
		tobar.addButton({
			//className: 'new-topic-button',
			text: "新建",
			handler:additm,
			id:'mygridadd',
			icon:'../Image/light/useradd.png'
		});
  	    tobar.addItem('-');
		tobar.addButton({
			//className: 'new-topic-button',
			text: "删除",
			handler:deleteFn,
			id:'mygridStat',
			icon:'../Image/icons/cancel.png'
		});
		/*tobar.addButton({
			className: 'new-topic-button',
			text: "查询",
			handler:setgrid,
			id:'mygridSch'
		});*/
	tobar.addItem('-');
	tobar.addItem({xtype:'checkbox',boxLabel:'显示已删除',id:'deleteflagbtn'});
	tobar.addItem('-');
	tobar.addItem({xtype:'button',id:'finddetbtn',text:'查询明细',handler:setgrid,icon:'../Image/icons/magnifier.png'});
	tobar.addItem('-');
	tobar.addItem({xtype:'button',id:'undeletebtn',text:'取消删除',handler:undeleteRec,icon:'../Image/icons/arrow_redo.png'});
	tobar.addItem('-');
    tobar.addItem({xtype:'button',id:'insertbtn',text:'插入护理记录',handler:insertRec,icon:'../Image/icons/add.png'});
	Ext.getCmp('insertbtn').hide();
	var a = new Date ();
	var b = new Date ();
	a.setHours (7);
	a.setMinutes (0);
	b.setHours (19);
	b.setMinutes (0);
	var myDate = new Date();
	//alert(myDate.toLocaleTimeString());
	//alert(a.toLocaleTimeString());
	//alert(b.toLocaleTimeString());
	if (myDate.getTime () - a.getTime () > 0 && myDate.getTime () - b.getTime () < 0) {
		var Item22=Ext.getCmp("Item22");
		Item22.disable();
		var len = grid.getColumnModel().getColumnCount();
		for(var i = 0 ;i < len;i++){
			if(grid.getColumnModel().getDataIndex(i) == 'Item106'){
				
				grid.getColumnModel().setEditable(i,false);
			}
		}
	} else
	{
		var Item21=Ext.getCmp("Item21");
		Item21.disable();
		var len = grid.getColumnModel().getColumnCount();
		for(var i = 0 ;i < len;i++){
			if(grid.getColumnModel().getDataIndex(i) == 'Item105'){
				
				grid.getColumnModel().setEditable(i,false);
			}
		}
	}
  var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			//alert(grid.getColumnModel().getDataIndex(i));
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'par'){
			//alert(grid.getColumnModel().getDataIndex(i));
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'EpisodeID'){
			grid.getColumnModel().setHidden(i,true);
		}
  }
}
function ChangeDateFn()
{
	//DayType="";
	SetDefaultValue();
	setgrid();
}
function ChangeDepFn()
{
	SetDefaultValue();
	setgrid();
}
function savegrid()
{
	var grid = Ext.getCmp("mygrid");
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	for (var i = 0; i < store.getCount(); i++) {
		list.push(store.getAt(i).data);
		//debugger;
	}
	//var rowObj = grid.getSelectionModel().getSelections();
	//var len = rowObj.length;
	//for (var r = 0;r < len; r++) {
	//	list.push(rowObj[r].data);
	//}
	var objSaveSub=document.getElementById('SaveSub');
	var dep = Ext.getCmp("LocDr");
	var appdate = Ext.getCmp("CareDate");	
	//var appdatenew = Ext.getCmp("CareDate");	
	//alert(GetExchageSummary);
	//var date=appdatenew.value.split("/");
	//var appdate=date[2]+"-"+date[1]+"-"+date[0];
	//alert(list.length);
	for (var i = 0; i < list.length; i++) {
		var obj=list[i];
		var str="";
		var CareDate="";
		var CareTime="";
	
		if(obj["Item111"]==undefined||obj["Item111"]=="") 
		{
			alert("新加记录请选择班次")
			return;
		}
		for (var p in obj) {
			var aa = formatDate(obj[p]);
			if (p=="") continue;
			if (aa == "") 
			{
				str = str + p + "|" + obj[p] + '^';
			}else
			{
				str = str + p + "|" + aa + '^';	
			}
		}
		if (str!="")
		{
			//alert(dep.value+","+"^"+str+","+session['LOGON.USERID']+","+appdate+","+session['LOGON.GROUPDESC']);
			var a=cspRunServerMethod(objSaveSub.value,dep.value,"^"+str,session['LOGON.USERID'],appdate.value,session['LOGON.GROUPDESC'],DayType);
			if (a!=0) {
				alert(a);
				return;
			}
		}
	}
	arrgrid=new Array();

	setgrid();	
} 
var arrgrid=new Array();
function setgrid()
{	
		var grid = Ext.getCmp("mygrid");

		var GetQueryData=document.getElementById('GetQueryData');
		arrgrid=new Array();
		var dep = Ext.getCmp("LocDr");
		var appdate = Ext.getCmp("CareDate");	
		//var appdatenew = Ext.getCmp("CareDate");	
	//alert(GetExchageSummary);
	//var date=appdatenew.value.split("/");
	//var appdate=date[2]+"-"+date[1]+"-"+date[0];
		var deleteflag="";
		if(Ext.getCmp('deleteflagbtn')) deleteflag=Ext.getCmp('deleteflagbtn').getValue()?"1":"";
		var parr=dep.value+"^"+appdate.value+"^"+session['LOGON.USERID'];
		//alert(parr);
		arrgrid=new Array();
		parr=parr+"^"+DayType+"^"+deleteflag
		//alert(parr)
		//var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurShiftExchage:FindShiftExchageDetail", "parr$" + parr, "AddRec");
		
		//grid.store.loadData(arrgrid);   
		grid.store.on('beforeload',function(){
			grid.store.baseParams.parr=parr;
		});
		grid.store.load({params:{start:0,limit:grid.getBottomToolbar().pageSize}});
}

function AddRec(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
{
	//debugger;
	//if(arrgrid.length==0) alert(a1+","+a2+","+a3)
	arrgrid.push({
		Item101:a1,
		Item102:a2,
		Item103:a3,
		Item104:a4,
		Item105:a5,
		Item106:a6,
		par:a7,
		rw:a8,
		EpisodeID:a9,
		Item111:a10

	});
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function clearSum()
{

			var dayTotal = Ext.getCmp("Item1");
			dayTotal.setValue("");
			var dayAdmSum = Ext.getCmp("Item2");
			dayAdmSum.setValue("");
			var dayTransInSum = Ext.getCmp("Item3");
			dayTransInSum.setValue("");
			var dayDischSum = Ext.getCmp("Item4");
			dayDischSum.setValue("");
			var dayTransOutSum = Ext.getCmp("Item5");
			dayTransOutSum.setValue("");
			var dayDeathSum = Ext.getCmp("Item6");
			dayDeathSum.setValue("");
			var dayOperSum = Ext.getCmp("Item7");
			dayOperSum.setValue("");
			var dayBabySum = Ext.getCmp("Item8");
			dayBabySum.setValue("");
			var daySeveritySum = Ext.getCmp("Item10");
			daySeveritySum.setValue("");
			var dayCritiSum = Ext.getCmp("Item9");
			dayCritiSum.setValue("");
			var dayNurse = Ext.getCmp("Item21");
			dayNurse.setValue("");

			
			var nightTotal = Ext.getCmp("Item11");
			nightTotal.setValue("");
			var nightAdmSum = Ext.getCmp("Item12");
			nightAdmSum.setValue("");
			var nightTransInSum = Ext.getCmp("Item13");
			nightTransInSum.setValue("");
			var nightDischSum = Ext.getCmp("Item14");
			nightDischSum.setValue("");
			var nightTransOutSum = Ext.getCmp("Item15");
			nightTransOutSum.setValue("");
			var nightDeathSum = Ext.getCmp("Item16");
			nightDeathSum.setValue("");
			var nightOperSum = Ext.getCmp("Item17");
			nightOperSum.setValue("");
			var nightBabySum = Ext.getCmp("Item18");
			nightBabySum.setValue("");
			var nightSeveritySum = Ext.getCmp("Item20");
			nightSeveritySum.setValue("");
			//alert(nightarr[8]);
			var nightCritiSum = Ext.getCmp("Item19");
			nightCritiSum.setValue("");
			var nightNurse = Ext.getCmp("Item22");
			nightNurse.setValue("");
	
}
function SetDefaultValue()
{
	 clearSum();
	var dep = Ext.getCmp("LocDr");
	var appdate = Ext.getCmp("CareDate");	
	//alert(GetExchageSummary);
	//var appdatenew = Ext.getCmp("CareDate");	
	//alert(GetExchageSummary);
	//var date=appdatenew.value.split("/");
	//var appdate=date[2]+"-"+date[1]+"-"+date[0];
	var ret = cspRunServerMethod(GetExchageSummary, dep.value+"^"+appdate.value+"^"+session['LOGON.USERID'],DayType);
	//alert(dep.value+"^"+appdate.value+"^"+session['LOGON.USERID']);
	if (session['LOGON.CTLOCID']=="65")
    {
		//alert(ret)
	}
	var arr = ret.split("@");

	//alert(ret);
	/*if(DayType=="Day")
	{
		var dayarr = arr[0].split("^");
		var dayTotal = Ext.getCmp("Item1");
		dayTotal.setValue(dayarr[0]);
		var dayAdmSum = Ext.getCmp("Item2");
		dayAdmSum.setValue(dayarr[1]);
		var dayTransInSum = Ext.getCmp("Item3");
		dayTransInSum.setValue(dayarr[2]);
		var dayDischSum = Ext.getCmp("Item4");
		dayDischSum.setValue(dayarr[3]);
		var dayTransOutSum = Ext.getCmp("Item5");
		dayTransOutSum.setValue(dayarr[4]);
		var dayDeathSum = Ext.getCmp("Item6");
		dayDeathSum.setValue(dayarr[5]);
		var dayOperSum = Ext.getCmp("Item7");
		dayOperSum.setValue(dayarr[6]);
		var dayBabySum = Ext.getCmp("Item8");
		dayBabySum.setValue(dayarr[7]);
		var daySeveritySum = Ext.getCmp("Item10");
		daySeveritySum.setValue(dayarr[9]);
		var dayCritiSum = Ext.getCmp("Item9");
		dayCritiSum.setValue(dayarr[8]);
		var dayNurse = Ext.getCmp("Item21");
		dayNurse.setValue(dayarr[10]);
	}
	else if(DayType=="Night")
	{
		var nightarr = arr[1].split("^");
		var nightTotal = Ext.getCmp("Item11");
		nightTotal.setValue(nightarr[0]);
		var nightAdmSum = Ext.getCmp("Item12");
		nightAdmSum.setValue(nightarr[1]);
		var nightTransInSum = Ext.getCmp("Item13");
		nightTransInSum.setValue(nightarr[2]);
		var nightDischSum = Ext.getCmp("Item14");
		nightDischSum.setValue(nightarr[3]);
		var nightTransOutSum = Ext.getCmp("Item15");
		nightTransOutSum.setValue(nightarr[4]);
		var nightDeathSum = Ext.getCmp("Item16");
		nightDeathSum.setValue(nightarr[5]);
		var nightOperSum = Ext.getCmp("Item17");
		nightOperSum.setValue(nightarr[6]);
		var nightBabySum = Ext.getCmp("Item18");
		nightBabySum.setValue(nightarr[7]);
		var nightSeveritySum = Ext.getCmp("Item20");
		nightSeveritySum.setValue(nightarr[9]);
		//alert(nightarr[8]);
		var nightCritiSum = Ext.getCmp("Item19");
		nightCritiSum.setValue(nightarr[8]);
		var nightNurse = Ext.getCmp("Item22");
		nightNurse.setValue(nightarr[10]);
	}
	else*/
	{
			var dayarr = arr[0].split("^");
			var dayTotal = Ext.getCmp("Item1");
			dayTotal.setValue(dayarr[0]);
			var dayAdmSum = Ext.getCmp("Item2");
			dayAdmSum.setValue(dayarr[1]);
			var dayTransInSum = Ext.getCmp("Item3");
			dayTransInSum.setValue(dayarr[2]);
			var dayDischSum = Ext.getCmp("Item4");
			dayDischSum.setValue(dayarr[3]);
			var dayTransOutSum = Ext.getCmp("Item5");
			dayTransOutSum.setValue(dayarr[4]);
			var dayDeathSum = Ext.getCmp("Item6");
			dayDeathSum.setValue(dayarr[5]);
			var dayOperSum = Ext.getCmp("Item7");
			dayOperSum.setValue(dayarr[6]);
			var dayBabySum = Ext.getCmp("Item8");
			dayBabySum.setValue(dayarr[7]);
			var daySeveritySum = Ext.getCmp("Item10");
			daySeveritySum.setValue(dayarr[9]);
			var dayCritiSum = Ext.getCmp("Item9");
			dayCritiSum.setValue(dayarr[8]);
			var dayNurse = Ext.getCmp("Item21");
			dayNurse.setValue(dayarr[10]);

			var nightarr = arr[1].split("^");
			var nightTotal = Ext.getCmp("Item11");
			nightTotal.setValue(nightarr[0]);
			var nightAdmSum = Ext.getCmp("Item12");
			nightAdmSum.setValue(nightarr[1]);
			var nightTransInSum = Ext.getCmp("Item13");
			nightTransInSum.setValue(nightarr[2]);
			var nightDischSum = Ext.getCmp("Item14");
			nightDischSum.setValue(nightarr[3]);
			var nightTransOutSum = Ext.getCmp("Item15");
			nightTransOutSum.setValue(nightarr[4]);
			var nightDeathSum = Ext.getCmp("Item16");
			nightDeathSum.setValue(nightarr[5]);
			var nightOperSum = Ext.getCmp("Item17");
			nightOperSum.setValue(nightarr[6]);
			var nightBabySum = Ext.getCmp("Item18");
			nightBabySum.setValue(nightarr[7]);
			var nightSeveritySum = Ext.getCmp("Item20");
			nightSeveritySum.setValue(nightarr[9]);
			//alert(nightarr[8]);
			var nightCritiSum = Ext.getCmp("Item19");
			nightCritiSum.setValue(nightarr[8]);
			var nightNurse = Ext.getCmp("Item22");
			nightNurse.setValue(nightarr[10]);
	}
}

function save()
{
 var grid = Ext.getCmp("mygrid");
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	for (var i = 0; i < store.getCount(); i++) {
		list.push(store.getAt(i).data);
		
	}
	
	for (var i = 0; i < list.length; i++) {
		var obj=list[i];
		var str="";
		var CareDate="";
		var CareTime="";
	
		if(obj["Item111"]==undefined||obj["Item111"]=="") 
		{
			alert("存在未选班次记录!")
			return;
		}
		 }
	DayType="";
	ret="";
	checkret="";
	comboret="";
	var objSave=document.getElementById('Save');
	var gform=Ext.getCmp("gform");
	gform.items.each(eachItem, this);
	//alert(ret+"&"+checkret+"&"+comboret);
	//alert(checkret);
	var dep = Ext.getCmp("LocDr");
	var appdate = Ext.getCmp("CareDate");	
	//var appdatenew = Ext.getCmp("CareDate");	
	//alert(GetExchageSummary);
	//var date=appdatenew.value.split("/");
	//var appdate=date[2]+"-"+date[1]+"-"+date[0];
	var a=cspRunServerMethod(objSave.value,dep.value,"^"+ret+"^",session['LOGON.USERID'],appdate.value,session['LOGON.GROUPDESC'],DayType);
	if (a!=0)
	{
		alert(a);
		return;
	}
	else {
		savegrid();	
		SetDefaultValue();
		ret="";
		gform.items.each(eachItem, this);
		var a=cspRunServerMethod(objSave.value,dep.value,"^"+ret+"^",session['LOGON.USERID'],appdate.value,session['LOGON.GROUPDESC'],DayType);
		
	}
		ChangeDepFn();
 }

function formatDate(value){
	// alert(value);
	try {
		return value ? value.dateFormat('Y-m-d') : '';
	}catch(err){  //err.description 
		return value;
	}
}      
function additm()
{           //  debugger;
		var grid=Ext.getCmp('mygrid');
		var Plant = Ext.data.Record.create([
				// the "name" below matches the tag name to read, except "availDate"
				// which is mapped to the tag "availability"
		
		]);
		var count = grid.store.getCount(); 
		var r = new Plant(); 
		grid.store.commitChanges(); 
		grid.store.insert(count,r); 
		return;
}
function deleteFn() {
    var grid = Ext.getCmp("mygrid");
    if (grid.getSelectionModel().getSelections().length > 0) {
        Ext.Msg.show({
            title: '再确认一下',
            msg: '你确定要删除此条记录吗?',
            buttons: {
                "ok": "确定",
                "cancel": "取消"
            },
            fn: function(btn, text){
                if (btn == 'ok') {
                    var Rw = grid.getSelectionModel().getSelections()[0].get("par");
                    var subrw = grid.getSelectionModel().getSelections()[0].get("rw");
                    var Delete = document.getElementById('Delete');
                    if (Delete) {
                        var a = cspRunServerMethod(Delete.value, Rw + "||" + subrw+"^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']);
                        if (a != 0) {
                            alert(a);
                            //return;
                        }
                        setgrid();
                    }
                    SetDefaultValue();
                    save();
                }
            },
            animEl: 'newbutton'
        });
    }
    else {
        Ext.Msg.alert('提示', "请先选择一条记录!");
        return;
    }			
}
function Print1()
{
			PrintCommPic.RHeadCaption='dddd';
			PrintCommPic.LHeadCaption="3333333";
			//PrintCommPic.RFootCaption="第";
			//PrintCommPic.LFootCaption="页";
			//PrintCommPic.LFootCaption="88";
			//alert(PrintCommPic.Pages);
			PrintCommPic.SetConnectStr(CacheDB);
			PrintCommPic.ItmName = "DHCNurShiftExchageWardPrn";  //338155!2010-07-13!0:00!!
			//debugger;
			var dep = Ext.getCmp("LocDr");
			var appdate = Ext.getCmp("CareDate");
			//var appdatenew = Ext.getCmp("CareDate");	
	//alert(GetExchageSummary);
	//var date=appdatenew.value.split("/");
	//var appdate=date[2]+"-"+date[1]+"-"+date[0];
			var parr=dep.value+"#"+appdate.value;
			PrintCommPic.MthArr="web.DHCNurShiftExchage:GetExchagePrint&parr:"+parr+"|"+"web.DHCNurShiftExchage:GetExchagePrintTable&parr$"+parr;
			//PrintCommPic.LabHead=LabHead;			
			//PrintCommPic.SetParrm(parr);  // ="EpisodeId" ;  //"p1:0^p2:"
			PrintCommPic.PrintOut();
}
function Print(){

		var dep = Ext.getCmp("LocDr");
		var appdate = Ext.getCmp("CareDate");
		//var appdatenew = Ext.getCmp("CareDate");	
	//alert(GetExchageSummary);
	//var date=appdatenew.value.split("/");
	//var appdate=date[2]+"-"+date[1]+"-"+date[0];
		var parr=dep.value+"#"+appdate.value;
		//var a = GetExchangeSummary();
		//var tm = a.split('^');
		var GetexchagesummaryTb = document.getElementById('GetExchageSummaryTb');
    var a = cspRunServerMethod(GetExchageSummaryTb.value, parr);
    if (a=="") {
    	alert("请先点'保存'按钮,再打印!");
    }
    //alert(a);
    var tm = a.split('^');
    //alert(tm)
    PrintCommPic.RHeadCaption = tm[1]; //"日期:"+appdate.value;
    PrintCommPic.LHeadCaption = tm[0]; //"科室:"+dep.getValue();
    PrintCommPic.LFootCaption = tm[2];
    PrintCommPic.RFootCaption = tm[3];
	
    PrintCommPic.SetPreView("1");
	
    PrintCommPic.PrnLoc=session['LOGON.CTLOCID'];
    PrintCommPic.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
  
    PrintCommPic.stPage = 0;
    PrintCommPic.stRow = 0;
    PrintCommPic.previewPrint="1"; //是否弹出设置界面
    PrintCommPic.stprintpos = 0;
    PrintCommPic.SetConnectStr(CacheDB);
    PrintCommPic.ItmName = "DHCNurShiftExchageWardPrn2";
	PrintCommPic.BlueString=""
    PrintCommPic.ID = "";
    PrintCommPic.MultID = "";
    PrintCommPic.MthArr = "";
    PrintCommPic.SetParrm(parr);
    //alert(parr);
    PrintCommPic.PrintOut();
}
function GetExchangeSummary(){
		var retStr="";
		var dayTotal = Ext.getCmp("Item1");
		retStr=retStr+"总数: "+fillSpace(dayTotal.value);
		var dayAdmSum = Ext.getCmp("Item2");
		retStr=retStr+"入院: "+fillSpace(dayAdmSum.value);
		var dayTransInSum = Ext.getCmp("Item3");
		retStr=retStr+"转入: "+fillSpace(dayTransInSum.value);
		var dayDischSum = Ext.getCmp("Item4");
		retStr=retStr+"出院: "+fillSpace(dayDischSum.value);
		var dayTransOutSum = Ext.getCmp("Item5");
		retStr=retStr+"转出: "+fillSpace(dayTransOutSum.value);
		var dayDeathSum = Ext.getCmp("Item6");
		retStr=retStr+"死亡: "+fillSpace(dayDeathSum.value);
		var dayOperSum = Ext.getCmp("Item7");
		retStr=retStr+"手术: "+fillSpace(dayOperSum.value);
		var dayBabySum = Ext.getCmp("Item8");
		retStr=retStr+"生产: "+fillSpace(dayBabySum.value);
		var daySeveritySum = Ext.getCmp("Item9");
		retStr=retStr+"病重: "+fillSpace(daySeveritySum.value);
		var dayCritiSum = Ext.getCmp("Item10");
		retStr=retStr+"病危: "+fillSpace(dayCritiSum.value);
		//var dayNurse = Ext.getCmp("Item21");
		//retStr=retStr+"总数: "+dayTotal.value;
		retStr=retStr+"^";
		var nightTotal = Ext.getCmp("Item11");
		retStr=retStr+"总数: "+fillSpace(nightTotal.value);
		var nightAdmSum = Ext.getCmp("Item12");
		retStr=retStr+"入院: "+fillSpace(nightAdmSum.value);
		var nightTransInSum = Ext.getCmp("Item13");
		retStr=retStr+"转入: "+fillSpace(nightTransInSum.value);
		var nightDischSum = Ext.getCmp("Item14");
		retStr=retStr+"出院: "+fillSpace(nightDischSum.value);
		var nightTransOutSum = Ext.getCmp("Item15");
		retStr=retStr+"转出: "+fillSpace(nightTransOutSum.value);
		var nightDeathSum = Ext.getCmp("Item16");
		retStr=retStr+"死亡: "+fillSpace(nightDeathSum.value);
		var nightOperSum = Ext.getCmp("Item17");
		retStr=retStr+"手术: "+fillSpace(nightOperSum.value);
		var nightBabySum = Ext.getCmp("Item18");
		retStr=retStr+"生产: "+fillSpace(nightBabySum.value);
		var nightSeveritySum = Ext.getCmp("Item19");
		retStr=retStr+"病重: "+fillSpace(nightSeveritySum.value);
		var nightCritiSum = Ext.getCmp("Item20");
		retStr=retStr+"病危: "+fillSpace(nightCritiSum.value);
		//var nightNurse = Ext.getCmp("Item22");
		//retStr=retStr+"总数: "+dayTotal.value;
		return retStr;
}
function fillSpace(inStr){
	var retStr=inStr;
	for (var i=inStr.length;i<4;i++){
			retStr=retStr+" ";
	}
	return retStr;
}

function SearchDay()
{
	
	var mydate = new Date();
	var hour=mydate.getHours();
	if(hour<7)
	{
	  alert("今天白班未开始");
	  return;
  }
  if(hour>=19)
	{
	  alert('今天白班已结束,请使用"查询完结报告"');
	  return;
  }
  DayType="Day";
	var appdate = Ext.getCmp("CareDate");
	appdate.setValue(diffDate(mydate, 0));
	SetDefaultValue();
	
	setgrid();
	DayType="";

}

function SearchNight()
{


	var mydate = new Date();
	var hour=mydate.getHours();
	if(hour>=7&&hour<19)
	{
	  alert('今天夜班未开始,查看昨天报告请使用"查询完结报告"');
	  return;
  }
  DayType="Night";
	var appdate = Ext.getCmp("CareDate");
	appdate.setValue(diffDate(mydate, 0));
	SetDefaultValue();
	//
	setgrid();
	DayType="";
}

function SaveDay()
{
	DayType="Day";
	
}

function SaveNight()
{
	DayType="Night";
}

function undeleteRec()
{
	var grid = Ext.getCmp("mygrid");
	var selections=grid.getSelectionModel().getSelections();
	if(selections.length==0)
	{
		alert('请选择一条记录！');
		return;
	}
	for(var i=0;i<selections.length;i++)
	{
		var parid=selections[i].get('par');
		var rw=selections[i].get('rw');
		if(typeof rw === 'undefined') return;
		else
		{
			var a=tkMakeServerCall("User.DHCNurWardShiftSub","UnDelete",parid+"||"+rw+"^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']);
		}
	}
	
	Ext.getCmp("deleteflagbtn").setValue(false);
	setgrid();
	//SetDefaultValue();
	//save();
}
function insertRec()
{
  var appdate = Ext.getCmp("CareDate");
	var grid = Ext.getCmp("mygrid");
	var selections=grid.getSelectionModel().getSelections();
	if(selections.length==0)
	{
		alert('请选择一条记录！');
		return;
	}
	for(var i=0;i<selections.length;i++)
	{
		var parid=selections[i].get('par');
		var rw=selections[i].get('rw');
		if(typeof rw === 'undefined') 
		{
			alert("未保存记录!");
			return;
		}
		else
		{
			var EpisodeID=selections[i].get('EpisodeID');
			var ret=tkMakeServerCall("User.DHCNurWardShiftSub","inRecord",EpisodeID,appdate.value,"DHCNURXH2");
			var arr=ret.split("@");
			if((arr[0]=="")&&(arr[1]="")) alert("未填写7:00和16:00护理记录！");
			selections[i].set("Item105", arr[0]);
			selections[i].set("Item106", arr[1]);
		}
		
	}
	
	
}