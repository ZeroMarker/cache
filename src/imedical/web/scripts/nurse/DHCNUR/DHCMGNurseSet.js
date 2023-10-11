/**
 * @author Administrator
 */
var ret="";
var checkret="";
var comboret="";
var ht = new Hashtable();
function BodyLoadHandler(){	
	var gridpl = Ext.getCmp('mygridpl');
	//gridpl.setHeight(document.body.clientHeight);
	gridpl.setWidth(document.body.clientWidth);
	var but = Ext.getCmp("_Button5");
	but.setText("保存");
	but.on('click', save);
	but.setIcon('../images/uiimages/filesave.png');
	
	var StartMaintain = Ext.getCmp("StartMaintain");
	StartMaintain.on('click', startMain);
	StartMaintain.setIcon('../images/uiimages/insureg.png');

	var but1=Ext.getCmp("mygridbut1");
	but1.setText("查询");
	but1.on('click',loadnurserecset);
	but1.hide();
	var but2=Ext.getCmp("mygridbut2");
	but2.setText("保存");
	but2.on('click',saverec);
	but2.hide();
	loadset();
	loadnurserecset();
	var grid = Ext.getCmp('mygrid');
	grid.getBottomToolbar().hide();
	var tobar = grid.getTopToolbar();
	//grid.setTitle(gethead());
	var mydate = new Date();
	tobar.addItem("-"); 
    tobar.addButton({
		//className: 'new-topic-button',
		icon:'../images/uiimages/filesave.png',
		text: "保存",
		handler: saverec,
		id: 'savtbut'
	});
	tobar.addItem("-"); 
	tobar.addButton({
		//className: 'new-topic-button',
		icon:'../images/uiimages/search.png',
		text: "查询",
		handler: loadnurserecset,
		id: 'searchbut'
	});
	tobar.addItem("-"); 
	tobar.addButton({
		//className: 'new-topic-button',
		icon:'../images/uiimages/pencil.png',
		text: "编辑",
		handler: modrec,
		id: 'mygridmod'
	});
	tobar.addItem("-"); 
}
function startMain(){
	window.location.href = "/dhcmg/NurEmrMaintain/NurEmrMaintain.application";
}
var windowsub;
function modrec()
{
    var mygrid = Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();
	var RecTyp = rowObj[0].get("RecTyp");
	var RecName = rowObj[0].get("RecName");
	
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMGNurseSetEdit", "", "");
	//alert(a);
	arr = eval(a);
	windowsub = new Ext.Window({
				title : RecName,
				id:'gform1',
				width : 650,
				height : 500,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr
			});
			
    var butAdd=Ext.getCmp("butSave");
	butAdd.on("click",saveSet);
	butAdd.setIcon("../images/uiimages/filesave.png");
	var butClose=Ext.getCmp("butClose");
	butClose.on("click",btclose);
	butClose.setIcon("../images/uiimages/cancel.png");
    setvalue(RecTyp);
	windowsub.show();



}
function setvalue(typ)
{
	//alert(ExamId);
   var ha = new Hashtable();
  if (typ!="")
   {
   	 var getVal=document.getElementById('getVal');
	 var ret=cspRunServerMethod(getVal.value,typ);
     var tm=ret.split('^')
	// alert(tm);
	 sethashvalue(ha,tm)

   }
 	 var gform=Ext.getCmp("gform1");
     gform.items.each(eachItem, this);  
	 //  alert(a);
   for (var i=0 ; i<ht.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = ht.keys()[i];
		//restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_") == -1) 
		{
			var itm = Ext.getCmp(key);
			if (ha.contains(key)) 
			itm.setValue(ha.items(key));
	    }else{
			var aa=key.split('_');
			if(ha.contains(aa[0]))
			{
			  setcheckvalue(key,ha.items(aa[0]));
			}
		}
    }
 
 
}
function btclose(){
				windowsub.close();
			}
function saveSet()
{
  ret="";
  checkret="";
  var RowId="";
  comboret="";
  var saveSet=document.getElementById('RecSave');
   var gform=Ext.getCmp("gform1");
   gform.items.each(eachItem, this);  
 	//alert(ret+"&"+checkret+"&"+comboret);
  var a=cspRunServerMethod(saveSet.value,ret+"^"+checkret+"^"+comboret);
  if (a!=0)
  {
  	alert("保存成功");
  	return;
  }
 
 }
function loadset()
{
	var dbip=Ext.getCmp("dbip");
	var webip=Ext.getCmp("webip");
	var genpath=Ext.getCmp("GeneratorPath");
	var getSet=document.getElementById('getSet');
 	var a=cspRunServerMethod(getSet.value);
	if (a != "") {
		var ar = a.split("^");
		dbip.setValue(ar[0]);
		webip.setValue(ar[1]);
		genpath.setValue(ar[2]);
		//alert(webip.value);
		//debugger;
	}

}
function save()
{
	var dbip=Ext.getCmp("dbip");
	var webip=Ext.getCmp("webip");
    var genpath=Ext.getCmp("GeneratorPath");

	var saveset=document.getElementById('SetSave');
	var parr="ServerDB|"+dbip.getValue()+"^WebServer|"+webip.getValue()+"^GeneratorPath|"+genpath.getValue();
 	var a=cspRunServerMethod(saveset.value,parr);

}
//document.body.onload = BodyLoadHandler;
var REC=new Array();
function loadnurserecset()
{
	REC = new Array();
	var GetNurseRecSet = document.getElementById('GetNurseRecSet');
	if (GetNurseRecSet)
	{
		cspRunServerMethod(GetNurseRecSet.value,'addrec');
	}
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.loadData(REC);
}

function addrec(str)
{
	//var a=new Object(eval(str));
	//alert(str);
	var obj = eval('(' + str + ')');
	//obj.CareDate=getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}

function saverec()
{
		var grid=Ext.getCmp("mygrid");
		var list = [];
		var rowObj = grid.getSelectionModel().getSelections();
			var len = rowObj.length;
			for (var r = 0;r < len; r++) {
			list.push(rowObj[r].data);
		}
    var RecSave=document.getElementById('RecSave');
		for (var i = 0; i < list.length; i++) {
		  var obj=list[i];
		  var str="";
			for (var p in obj) {
				str = str + p + "|" + obj[p] + '^';
			}
			//alert(str);
			var a=cspRunServerMethod(RecSave.value,str);
		}
		loadnurserecset();
} 