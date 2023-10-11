var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-1;
var SortPos=new Ext.form.TextField(
{
	tabIndex : '0',
	xtype : 'textfield',
	//height : 21,
	width : 24,
	name : 'SortPos',
	id : 'SortPos',
	value : ''
});
//HIS护理单元
var comboboxDep = new Ext.form.ComboBox({
	name : 'comboboxDep',
	id : 'comboboxDep',
	store : new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
				url : "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader : new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'LocDes',
				'mapping' : 'LocDes'
			}, {
				'name' : 'LocDr',
				'mapping' : 'LocDr'
			}]
		}),
		baseParams : {
			className : 'web.DHCMgNurPerHRComm',
			methodName : 'FindWardCode',
			type : 'Query'
		}
	}),
	tabIndex : '0',
	listWidth : '300',
	//height : 18,
	width : 150,
	xtype : 'combo',
	displayField : 'LocDes',
	valueField : 'LocDr',
	hideTrigger : false,
	//queryParam : 'typ',
	queryParam : 'ward',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 10,
	typeAhead : true,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
});
function BodyLoadHandler() {
	//setsize("mygridpl","gform","mygrid1",0);
	var grid1 = Ext.getCmp('mygrid1');
	var bbar1 = grid1.getBottomToolbar ();
	bbar1.hide();
	var gridp1=Ext.getCmp('mygrid1pl')
	//gridp1.setHeight(document.body.offsetHeight);
	gridp1.setHeight(Height);
	gridp1.setPosition(0,0);
	gridp1.setWidth(480);
	var gridp2=Ext.getCmp('mygrid2pl')
	//gridp2.setHeight(document.body.offsetHeight);
	gridp2.setHeight(Height);
	gridp2.setPosition(480,0);
	gridp2.setWidth(480);
	var tobar = grid1.getTopToolbar();
	var grid2=Ext.getCmp('mygrid2');
	var bbar2 = grid2.getBottomToolbar ();
	bbar2.hide();
	var tobar2 = grid2.getTopToolbar();
	var but1 = Ext.getCmp("mygrid1but1");
	but1.setText("添加护理单元");
	but1.setIcon('../images/uiimages/filesave.png');
	but1.on('click',makeSure);
	var but2=Ext.getCmp('mygrid1but2')
	but2.hide();
	//var grid2=Ext.getCmp('mygrid2');
	grid2.on("click",grid2click);
	tobar.addItem("-","科室",comboboxDep);
	tobar.addItem('-');
	tobar.addButton({
		id:'btnSearch',
		test:"查询",
		icon:'../images/uiimages/search.png',
		handler:function(){SchQual();}
	});
	Ext.getCmp('btnSearch').setText("查询");
	//comboboxDep.on('select',SchQual);
	var tobar2=grid2.getTopToolbar();
	var but21=Ext.getCmp('mygrid2but1');
	but21.setText('保存');
	but21.setIcon('../images/uiimages/filesave.png');
	but21.hide();
	but21.on('click',makeSave);
	var but22=Ext.getCmp('mygrid2but2');
	but22.hide();
	//but22.setText('删除');
	tobar2.addItem('-');
	tobar2.addButton({
		id:'delitembtn',
		text:'删除',
		handler:makeDelete,
		icon:'../images/uiimages/edit_remove.png'
	});
	//but22.on('click',makeDelete);
	tobar2.addItem('-','序号',SortPos);
	var bmbar1 = new Ext.PagingToolbar({
		pageSize:20,
		store:grid1.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	
	var bmbar2=new Ext.PagingToolbar({
		pageSize:20,
		store:grid2.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"	
	});
	bmbar1.render(grid1.bbar);
	bmbar2.render(grid2.bbar);
	tobar.doLayout();
	SchQual();
	SchQual1();
	comboboxDep.store.on("beforeload",function(){
    	var pward=comboboxDep.lastQuery;
    	var wardrw=Ext.getCmp('comboboxDep').getValue();
      //comboboxDep.store.baseParams.ward=pward;
      comboboxDep.store.baseParams.wardid=pward;
  });
  
  var len = grid1.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid1.getColumnModel().getDataIndex(i) == 'LocDr'){
			grid1.getColumnModel().setHidden(i,true);
		}
  }
  var len = grid2.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid2.getColumnModel().getDataIndex(i) == 'rw'){
			grid2.getColumnModel().setHidden(i,true);
		}
  }
}
//his grid
function SchQual()
{
	var mygrid = Ext.getCmp("mygrid1"); 
	mygrid.store.on("beforeload",function(){
			var comboboxDep=Ext.getCmp('comboboxDep').getValue();
			mygrid.store.baseParams.ward=comboboxDep;
	});
	mygrid.store.load({
		params : {
			start : 0,
			limit : 20
		}
	});	
}
function setSelItem()
{
	var mygrid1=Ext.getCmp("mygrid1");
	var comboboxDep=Ext.getCmp('comboboxDep').getRawValue();
	var getselloc=document.getElementById('getselloc');
  var a=cspRunServerMethod(getselloc.value,comboboxDep);
  mygrid1.getSelectionModel().clearSelections();
  if (a!=""){
  	var ha = new Hashtable();
		var arr=a.split('^');
		for (var i=0;i<arr.length;i++)
		{
		  	ha.add(arr[i],arr[i]);
		}
		var n = mygrid1.getStore().getCount();
		var store = mygrid1.store;
		var arrsel = new Array();
		for( var j=0;j<n;j++){
		   var LocDr=store.getAt(j).get("LocDr");
		   if(ha.contains(LocDr)){
		   arrsel[j]=j;
		   }
		}
		mygrid1.getSelectionModel().selectRows(arrsel,true);
	} 
}
//人力资源护理单元grid
function SchQual1()
{
	var mygrid = Ext.getCmp("mygrid2"); 
	mygrid.store.load({
		params : {
			start : 0,
			limit : 20
		}
	});	
}
//his选择护理单元
function makeSure()
{
	var grid1 = Ext.getCmp("mygrid1");
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var grid1 = Ext.getCmp("mygrid1");
  var store = grid1.store;
  var rowCount = store.getCount(); //记录数
  var cm = grid1.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var len = rowObj.length;
	for (var r = 0;r < len; r++) {
		list.push(rowObj[r].data);
	}
	var rw="";
	var str="";
	for (var i = 0; i < list.length; i++) {
		var obj=list[i];
 		rw=obj["LocDr"];
 		if(str==""){str=rw;}
 		else{str=str+"^"+rw;}
	}
	var Save=document.getElementById('Save');
	var a=cspRunServerMethod(Save.value,str);
	SchQual1()
}
//护理单元保存
function makeSave()
{
	var grid2= Ext.getCmp("mygrid2");
	var rowObj = grid2.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var loc = rowObj[0].get("rw");
	var sortpos=Ext.getCmp("SortPos").getValue();
	if(sortpos!="")
	{
		var SaveQt=document.getElementById('SavePos');
		var a=cspRunServerMethod(SaveQt.value,loc,sortpos);
		SchQual1();
	}
	
}
function grid2click()
{
	var grid = Ext.getCmp("mygrid2");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		//alert("请选择一条记录！");
		return;
	}
	var sort = rowObj[0].get("WardOrd");
  var sortpos=Ext.getCmp("SortPos");
  sortpos.setValue(sort);
}
//
function makeDelete()
{
	var grid2= Ext.getCmp("mygrid2");
	var rowObj = grid2.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par=rowObj[0].get('rw');
	var Delete=document.getElementById('Delete');
	if (confirm('确定删除选中的项？')) {
			var a=cspRunServerMethod(Delete.value,Par);
			SchQual1();
	}
}
