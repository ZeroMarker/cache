var grid;
var LocId;
var REC = new Array();
function AddRec(str)
{
	var obj = eval('(' + str + ')');
	REC.push(obj);
}

function BodyLoadHandler(){
	var but1=Ext.getCmp("mygridbut1");
	but1.on('click',additm);
	var but=Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.on('click',save);
	LocId=session['LOGON.CTLOCID'];
	grid=Ext.getCmp('mygrid');
	var tobar=grid.getTopToolbar();
	tobar.addButton(
	{
		className: 'new-topic-button',
		text: "查询",
		handler:find,
		id:'mygridSch'
	}
	);
	
	
	find();
}

function find(){
	  REC = new Array();
	  var GetQueryData = document.getElementById('GetQueryData');
	  var mygrid = Ext.getCmp("mygrid");
	  var parr = LocId+"^"+headcode;
	  var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurHeadKnowledge.GetHeadKnowledge", "parr$" + parr, "AddRec");
	  mygrid.store.loadData(REC);
}

function additm()
{ 
  	var Plant = Ext.data.Record.create([
  	{name:'ID'},
  	{name:'Head'},
  	{name:'Selections'}
    ]);
  var count = grid.store.getCount(); 
  var r = new Plant(); 
  grid.store.commitChanges(); 
  grid.store.insert(0,r); 
	return;
}

function save(){
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	//var len = rowObj.length;
	//	for (var r = 0;r < len; r++) {
	//	list.push(rowObj[r].data);
	//}
	for (var i = 0; i < store.getCount(); i++) {
		list.push(store.getAt(i).data);
	}
	var Save=document.getElementById('Save');
	for (var i=0;i<list.length;i++)
	{
		var obj=list[i];
		var str="";
		for(var p in obj)
		{
			if(p=="")continue;
			//alert(p);
			str=str+p+"|"+obj[p]+"^";
		}
		str=str+"Code|"+headcode+"^"
		//alert(str);
		if(str!=""){
			var a=cspRunServerMethod(Save.value,str+"LocId|"+LocId+"^");
			
			find();
			if(a!=0)
			{
				alert("保存成功！");
				return;
			}
			
		}
	}		
	
}
  	