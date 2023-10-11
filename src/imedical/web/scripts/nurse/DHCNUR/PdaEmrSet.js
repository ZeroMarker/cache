var grid="";
function BodyLoadHandler(){
	setsize("mygridpl","gform","mygrid");
	var but1=Ext.getCmp("mygridbut1");
	but1.on('click',additm);
	but1.hide();
	var but=Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.hide();
	but.on('click',save);
  grid=Ext.getCmp('mygrid');
  var len = grid.getColumnModel().getColumnCount();
		for(var i = 0 ;i < len;i++){
			if(grid.getColumnModel().getDataIndex(i) == 'id'){
				grid.getColumnModel().setHidden(i,true);
			}
		}
  //grid=Ext.getCmp('mygrid');
  var tobar=grid.getTopToolbar();
   var bbar = grid.getBottomToolbar ();
	bbar.hide();
	tobar.addItem('-');
	tobar.addButton(
	{
		//className: 'new-topic-button',
		text: "增加",
		handler:additm,
		icon:'../images/uiimages/edit_add.png',
		id:'additmbut'
	});
	tobar.addItem('-');
	tobar.addButton(
	{
		//className: 'new-topic-button',
		text: "保存",
		icon:'../images/uiimages/filesave.png',
		handler:save,
		id:'savbut'
	});
	tobar.addItem('-');
	tobar.addButton(
	{
		//className: 'new-topic-button',
		text: "查询",
		icon:'../images/uiimages/search.png',
		handler:find,
		id:'mygridSch'
	});
	tobar.addItem('-');
}

function additm()
{ 
  var Plant = Ext.data.Record.create([
	{name:'EmrCode'}, 
	{name:'PdaEmrCode'},
	{name:'PatName'},
	{name:'PatSex'},
	{name:'PatAge'},
	{name:'PatMedNo'},
	{name:'PatBedCode'},
	{name:'PatLoc'},
	{name:'PatAdmDate'},
	{name:'PatDiag'},
	{name:'id'},	
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
		var len = rowObj.length;
		for (var r = 0;r < len; r++) {
		   list.push(rowObj[r].data);
	  }
	  var Save=document.getElementById('Save');		
	  for (var i = 0; i < list.length; i++) {
		var obj=list[i];
		var str="";
	  for (var p in obj) {
				 //var aa = formatDate(obj[p]);
				 if (p=="") continue;
				 str = str + p + "|" + obj[p] + '^';
			}
			if (str!="")
			{
					var a=cspRunServerMethod(Save.value,str);
					find();
					if (a!=0)
					{
					  	alert("保存成功");
					  	return;
					}
			}
		}	
}

function find(){
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();	
	var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurPdaMainSet:GetPdaEmrSet", "parr$", "AddRec");
  grid.store.loadData(arrgrid);  
}


function AddRec(str)
{
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
}