/**
 * @author Administrator
 */
var grid;
var arrgrid = new Array();
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
		 //fm.doLayout();
		//but.hide();
		grid = Ext.getCmp('mygrid');
		var len = grid.getColumnModel().getColumnCount();
		for(var i = 0 ;i < len;i++){
			if(grid.getColumnModel().getDataIndex(i) == 'rw'){
				grid.getColumnModel().setHidden(i,true);
			}
		}
		var bbar = grid.getBottomToolbar ();
	    bbar.hide();
		var mydate = new Date();
		var tobar = grid.getTopToolbar();
    //alert(11);
    //alert(13);
		tobar.addItem("-");
		tobar.addButton({
			className : 'new-topic-button',
			text : "增加",
			handler : additm,
			id : 'myaddbut',
			icon:'../images/uiimages/edit_add.png'
		});
		tobar.addItem("-");
		tobar.addButton({
			className : 'new-topic-button',
			text : "保存",
			handler : save,
			id : 'mysaveBut',
			icon:'../images/uiimages/filesave.png'
		});
		tobar.addItem("-");
		tobar.addButton({
			className : 'new-topic-button',
			text : "删除",
			handler : typdelete,
			id : 'mygridDelete',
			icon:'../images/uiimages/edit_remove.png'
		});
		tobar.addItem("-");
		// tobar.render(grid.tbar);
		tobar.doLayout();
		//alert(14);
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	but1.on('click',additm);
	var but = Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.hide();
	but.on('click',save);
    setgrid();
}
function additm()
{
	   var grid=Ext.getCmp('mygrid');
	var Plant = Ext.data.Record.create([
         
      ]);
   	            var count = grid.store.getCount(); 
                var r = new Plant(); 
                grid.store.commitChanges(); 
                grid.store.insert(count,r); 
                return;

}
function save()
{
	var grid = Ext.getCmp("mygrid");
    var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); 
 	  var list = [];
		//for (var i = 0; i < store.getCount(); i++) {
		//	list.push(store.getAt(i).data);
		//	//debugger;
		//}
		var rowObj = grid.getSelectionModel().getSelections();
			var len = rowObj.length;
			for (var r = 0;r < len; r++) {
			list.push(rowObj[r].data);
		}
 var SaveQt=document.getElementById('SaveQt');
        //alert(SaveQt);
	    var rw="";
 	    for (var i = 0; i < list.length; i++) {
			  var obj=list[i];
			  var str="";
			  var CareDate="";
			  var CareTime="";
              for (var p in obj) {
			  	var aa = formatDate(obj[p]);
			  	//alert(aa);
				if (p=="") continue;
				//str = str + p + "|" + obj[p] + '^';
			  	if (aa == "") 
				{
			    	str = str + p + "|" + obj[p] + '^';
			    }else
				{
				  	str = str + p + "|" + aa + '^';	
				}
				rw=obj["rw"];
			}
			//alert(str);
			if (str!="")
			{
			 // alert(str);
 
			 // alert(rw);
			  if (rw==undefined) rw=""; 
			  //alert(str);
			  //alert(rw)
				var a=cspRunServerMethod(SaveQt.value,str,rw);
				//alert(a);
				//var a=cspRunServerMethod(SaveQt.value,str+"^WardId|"+session['LOGON.CTLOCID'],rw);
				if (a!=0)
			  {
			  	alert(a);
			  	return;
			  }
			}
		}
		setgrid();
}
function setgrid()
{	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	//alert(session['LOGON.CTLOCID']);
	var a = cspRunServerMethod(GetQueryData.value, "NurMp.DHCNURTemPrintLInk:CRItem", "parr$", "AddRec");
  //alert(a);
  grid.store.loadData(arrgrid);   
}
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function typdelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var list = [];
 
	 var rw=""
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	for (var r = 0;r < len; r++) 
{
			list.push(rowObj[r].data);
}
 
for (var i = 0; i < list.length; i++) 
{
			  var obj=list[i];
 
			  rw=obj["rw"];
}
 

if (rw==undefined) 
	{
		Ext.Msg.alert('提示', "请先选择有效行!");
		return;
	};
	var QtDelete = document.getElementById('QtDelete');

	//var rw=document.getElementById('rw');
	//alert(rw);
	if (QtDelete)
	{
		var ee = cspRunServerMethod(QtDelete.value, rw);
		if (ee != "0") {
			alert(ee);
			return;
		}
 	}
	clearscreen();
	setgrid();
}
function clearscreen() {
	var typ = Ext.getCmp("typsys");
	if (typ) typ.setValue("");
}
function diffDate(val,addday){
	var year=val.getYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };