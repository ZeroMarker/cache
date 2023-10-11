/**
 * @author Administrator
 */
var grid;
var arrgrid = new Array();
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
		grid = Ext.getCmp('mygrid');
		var len = grid.getColumnModel().getColumnCount();
		for (var i = 0; i < len; i++) {
			if (grid.getColumnModel().getDataIndex(i) == 'rw') {
				grid.getColumnModel().setHidden(i, true);
			}
		}
		var mydate = new Date();
		var tobar = grid.getTopToolbar();
		tobar.addButton({
			className : 'new-topic-button',
			icon:'../images/websys/delete.gif',
			text : "删除",
			handler : typdelete,
			id : 'mygridDelete'
		});
		tobar.addButton({
			className : 'new-topic-button',
			icon:'../images/uiimages/search.png',
			text : "查询",
			handler : find,
			id : 'find'
		});
		tobar.addButton({
			className : 'new-topic-button',
			icon:'../images/uiimages/searchallloc.png',
			text : "排序查询",
			handler : find2,
			id : 'find2'
		});
		// tobar.render(grid.tbar);
		tobar.doLayout();
	var but1=Ext.getCmp("mygridbut1");
	but1.on('click',additm);
	but1.setIcon("../images/uiimages/edit_add.png");
	var but = Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.on('click',save);
	but.setIcon("../images/uiimages/filesave.png");
	grid.getBottomToolbar().hide();
    find2();  
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
		for (var i = 0; i < store.getCount(); i++) {
			list.push(store.getAt(i).data);
		}
 var SaveQt=document.getElementById('SaveQt');
	    var rw="";
 	    for (var i = 0; i < list.length; i++) {
			  var obj=list[i];
			  var str="";
			  var CareDate="";
			  var CareTime="";
              for (var p in obj) {
			  	var aa = formatDate(obj[p]);
				if (p=="") continue;
			  	if (aa == "") 
				{   
					  if ((p=="Sortno")&&(obj[p]==""))
					  {				  		
			       obj[p]=i+1;
					  	}
			    	str = str + p + "|" + obj[p] + '^';
			    }else
				{
				  	str = str + p + "|" + aa + '^';	
				}
				rw=obj["rw"];
			}
			if (str!="")
			{
			  if (rw==undefined) rw=""; 
				//var a=cspRunServerMethod(SaveQt.value,str,rw);
				var a= tkMakeServerCall("Nur.DHCNUREPRMenu","SaveQt",str,rw);
				if (a!=0)
			  {
			  	return;
			  }
			}
		}
		find2();
}
function find()
{	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	//var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNUREPRMenu:CRItem", "parr$", "AddRec");
	var a = tkMakeServerCall("web.DHCMGNurComm","GetQueryData", "Nur.DHCNUREPRMenu:CRItem", "parr$", "AddRec");
	
    grid.store.loadData(arrgrid);   
}
function AddRec(str)
{
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
}
function find2()
{	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	//var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNUREPRMenu:CRItem2", "parr$", "AddRec2");
	var a = tkMakeServerCall("web.DHCMGNurComm","GetQueryData","Nur.DHCNUREPRMenu:CRItem2", "parr$", "AddRec2");
    grid.store.loadData(arrgrid);   
}
function AddRec2(str)
{
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
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
	var ee = tkMakeServerCall("Nur.DHCNUREPRMenu","QtDelete",rw);
		if (ee != "0") {
			alert(ee);
			return;
		}
	find();
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