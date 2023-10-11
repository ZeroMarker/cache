/**
 * @author Administrator
 */
var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-1;
var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();
function SizeChange(changewidth) {
	var fheight = document.body.offsetHeight;
	var fwidth = document.body.offsetWidth;
	var fm = Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth + changewidth);
	setsize("mygridpl", "gform", "mygrid");
}
var QualScore=0;
var cmbitm = new Hashtable();
function comboload2(itm, val) {
    itm.getStore().baseParams[cmbitm.items(itm.id)]=val;
	if (val != "") {
		itm.getStore().load({
			params : {
				start : 0,
				limit : 10
			},
			callback : function() {
				itm.setValue(session['LOGON.CTLOCID']);
			}
		});
	}
}
function comboload1(itm, val) {
    itm.getStore().baseParams[cmbitm.items(itm.id)]=val;
	if (val != ""){
		itm.getStore().load({
			params : {
				start : 0,
				limit : 100
			},
			callback : function(){
				itm.setValue(val);
			}
		});
	}
}
function grid1click() {
	var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		//alert("请选择一条记录！");
		return;
	}
	var sort = rowObj[0].get("SortPos");
  var sortpos=Ext.getCmp("SortPos1");
  sortpos.setValue(sort);
}
//常用模板维护
function BodyLoadHandler()
{	
    var but1=Ext.getCmp("mygrid1but1");
    but1.setText("增加至常用模板");
    but1.setIcon('../images/uiimages/edit_add.png');
    but1.on('click',function(){addcheckMoud();});		
    var but2=Ext.getCmp("mygrid1but2");
    but2.hide();
    Ext.getCmp('B125').hidden=true;
    //Ext.getCmp('gform').add(label1);
    //Ext.getCmp('gform').doLayout();
    Ext.getCmp("mygrid2").store.removeAll();
    Ext.getCmp("mygrid1").store.removeAll();
	//大标题选择后小标题自动选择
	sm1.on('rowselect',function(sm1,rowIndex){
		var store = Ext.getCmp("mygrid1").store;
		var rowObj =sm1.getSelections();
		var MinLevel=rowObj[rowObj.length-1].get("MinLevel");
		if(MinLevel=="N"){
			var rows=store.getCount()
			var Level=rowObj[rowObj.length-1].get("ItemLevel");
			var code=rowObj[rowObj.length-1].get("ItemCode");
			if(code.indexOf(".")!=-1){
				Level=code
			}
			for(var i=0;i<rows;i++){
				var MLevel=store.getAt(i).get("MinLevel");
				var MILevel=store.getAt(i).get("ItemLevel");
				//alert(rows[1].get("MinLevel")+"!!!"+rows[i].get("ItemLevel"))
				if((MLevel!="N")&&(MILevel==Level)){
					sm1.selectRow(i,true);
				}
			}
		}
	})
	//取消选择
	sm1.on('rowdeselect',function(sm1,rowIndex){
		var store = Ext.getCmp("mygrid1").store;
		var rowObj =sm1.getSelections();
		var MinLevel=store.getAt(rowIndex).get("MinLevel");
		//if(sm1.isSelected(rowIndex)==true){return}
		if(MinLevel=="N") 
		{
			var rows=store.getCount()
			var Level=store.getAt(rowIndex).get("ItemLevel");
			var code=store.getAt(rowIndex).get("ItemCode");
			if(code.indexOf(".")!=-1){
				Level=code
			}
			for(var i=0;i<rows;i++){
				var MLevel=store.getAt(i).get("MinLevel");
				var MILevel=store.getAt(i).get("ItemLevel");
				if((MLevel=="Y")&&(MILevel==Level))
				{
					sm1.deselectRow(i);
				}
			}
		}
	})
  var grid = Ext.getCmp('mygrid2');
	grid.on('rowclick', gridclick);
	grid.colModel.setHidden(4,true);
	grid.colModel.setHidden(5,true);
	grid.colModel.setHidden(6,true);
	grid.colModel.setHidden(7,true);
	var gridStore=grid.getStore();
	gridStore.on('load',function(){
		var num=gridStore.getCount();
		if(num=="0"){
			Ext.Msg.confirm('提示','此模板没有子项，是否删除此模板名称',function(btn,text){
				if(btn=="yes"){
					var rw=Ext.getCmp('CheckItmMoud').getValue();
					var ret=cspRunServerMethod(DelItmMoudName.value,rw);
					Ext.getCmp('CheckItmMoud').setRawValue("");
					var CheckItmMoudstore=Ext.getCmp('CheckItmMoud').getStore();
					CheckItmMoudstore.reload();
				}
			});
		}
	});
  var but1=Ext.getCmp("mygrid2but1");
  but1.setText("删除");
  but1.setIcon('../images/uiimages/edit_remove.png')
  but1.on('click',function(){DelItmMoud();});
  var but=Ext.getCmp("mygrid2but2");
  but.hide();
  var btnsave=Ext.getCmp("btnSave1");
  btnsave.on('click',SaveCheckItmMoud);
  btnsave.setIcon('../images/uiimages/filesave.png');
  var btnsure=Ext.getCmp("btnSure1");
  btnsure.hide();
  btnsure.on("click",function(){window.close();});
  var CheckItem=Ext.getCmp("CheckItm");
  CheckItem.on("select",checkitmgrid);
	var mygrid2=Ext.getCmp('mygrid2');
	mygrid2.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid2.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(mygrid2.bbar);
	var mygrid1=Ext.getCmp('mygrid1');
	mygrid1.colModel.setHidden(6,true);
	mygrid1.colModel.setHidden(7,true);
	mygrid1.colModel.setHidden(8,true);
	mygrid1.colModel.setHidden(9,true);
	mygrid1.getBottomToolbar().hide();
	var bbar1 = new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid1.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar1.render(mygrid1.bbar);
  //常用模板选择事件
  var CheckItem=Ext.getCmp("CheckItmMoud");
  CheckItem.on("select",setgridU);
 	var stdata=Ext.getCmp("mygrid1").store; 
	stdata.on("beforeLoad",function(){
		 var CheckItem=Ext.getCmp("CheckItm");
		 var qupar=CheckItem.getValue();
		 //MoudType 为1 自定义， 为0 通用
		 stdata.baseParams.Moudtype="0";
		 stdata.baseParams.Par=qupar;
	});
	var stdata2=Ext.getCmp("mygrid2").store; 
	stdata2.on("beforeload",function(){
		 var CheckItem=Ext.getCmp("CheckItmMoud");
		 var qupar=CheckItem.getValue();
		 stdata2.baseParams.className="web.DHCMgNurSysComm";
	 	 stdata2.baseParams.methodName="GetQualItemUsual";		
		 //stdata2.baseParams.Moudtype="1";
		 stdata2.baseParams.Par=qupar;
	})
   //setgridU();
}
function SaveCheckItmMoud()
{
	var mygrid2=Ext.getCmp('mygrid2');
	var rowObj = mygrid2.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var level=Ext.getCmp("Level").getValue();
	var code=Ext.getCmp("ItemCode").getValue();
	if ((level=="")||(code=="")) return;
	var p = rowObj[0].get("Par");
	var rw=rowObj[0].get("rw");
	//var parr="ItemLevel|"+ItemLevel+"^Par|"+Par+"^rw|"+rw+"^MinLevel|"+MinLevel;
	var SaveEdit=document.getElementById('SaveEdit');
	var mret=cspRunServerMethod(SaveEdit.value,p+"||"+rw,level,code);
	if(mret==0){
		Ext.Msg.alert('提示','保存成功！');
		setgridU();
	}
}
function setgridU() {
	var grid1 = Ext.getCmp("mygrid2");
	grid1.store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
}
function addcheckMoud()
{
	var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var level=Ext.getCmp("Level").getValue();
	var code=Ext.getCmp("ItemCode").getValue();
	level=""
	code=""
	var Name = Ext.getCmp("CheckName").getValue();
	if(Name=="")
	{
		Ext.Msg.alert('提示',"请先录入:常用模板名称,然后再进行添加。")
		return
	}
	var save = document.getElementById('SaveMoud');
	var Moudid=cspRunServerMethod(save.value,"",Name,session['LOGON.CTLOCID']);
	if(Moudid=="模板已使用，不能修改，请维护新模板!")
	{
		Ext.Msg.alert('提示',Moudid)
		return;
	}
  	if(Moudid!=""){
	    for(var i=0;i<rowObj.length;i++)
	    {
			var p = rowObj[i].get("Par");
			var rw=rowObj[i].get("rw");
			var MinLevel=rowObj[i].get("MinLevel");
			if(MinLevel=="N") {continue;}
			var save = document.getElementById('SaveCheckMoud');
		    var ret=cspRunServerMethod(save.value,p+"||"+rw,Moudid,level,code);
	    }
	}
    setgrid();
    checkitmgrid();
}
function DelItmMoud()
{
  var grid = Ext.getCmp("mygrid2");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ex.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var p = rowObj[0].get("Par");
	var rw=rowObj[0].get("rw");
	var DelItm = document.getElementById('DelItmMoud');
	if (confirm('确定删除选中的项？')) {
			var ret=cspRunServerMethod(DelItm.value,p+"||"+rw);
			if(ret!=0)
			{
				Ext.Msg.alert('提示',ret);
			}
			setgrid();
	}		
}

function gridclick()
{
	//debugger;
   	var grid = Ext.getCmp("mygrid2");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	Ext.getCmp("Level").setValue(rowObj[0].get("ItemLevel"));
	Ext.getCmp("ItemCode").setValue(rowObj[0].get("ItemCode"));
}

function gridclick11()
{
   	var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
}

function checkitmgrid()
{
	Ext.getCmp("mygrid1").store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
}
var returnid=""

var CheckValue = new Hashtable();
var CheckReason = new Hashtable();
function setgrid() {
	var grid1 = Ext.getCmp("mygrid2");
	grid1.store.load({
		params:{
			start:0,
			limit:30
		}
	});
}
var CurrSelItm = "";
function SaveItm()
{
  	ret = "";
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save');
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	// var rw=cspRunServerMethod(getemrcodeid.value,code,NurRecId);
	// var parr=ret+"&"+checkret+"&"+comboret;
	var parr = "rw|" + CurrSelItm + "^Par|" + curmenuid + "^" + ret + "^"+ checkret + "^" + comboret;
	
	var row = cspRunServerMethod(Save.value, parr);
	Ext.getCmp("mygrid2").store.load({
		params : {
			start : 0,
			limit : 30,
			Par : curmenuid
		}
	});
	return;
}

function setvalue(menid) 
{
	var ha = new Hashtable();
	var getval = document.getElementById('getVal');
	var ret = cspRunServerMethod(getval.value, menid);
	var tm = ret.split('^')
	sethashvalue(ha, tm)
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	for (var i = 0; i < ht.keys().length; i++)// for...in statement get all of			// Array's index
	{
		var key = ht.keys()[i];
		// restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_") == -1) {
			var itm = Ext.getCmp(key);
			if (ha.contains(key))
				if (itm.xtype == "combo") {
					comboload(itm, ha.items(key));
				} else {
					itm.setValue(ha.items(key));
				}
		} else {
			var aa = key.split('_');
			if (ha.contains(aa[0])) {
				setcheckvalue(key, ha.items(aa[0]));
			}
		}
	}
}
function comboload(itm, str) {
	var aa = str.split('!');
	var par = itm.id;
	if (aa.length < 2) {
		itm.setValue(str);
		return;
	}
	if (str != "") {
		itm.getStore().load({
			params : {
				start : 0,
				limit : 10,
				locdes : aa[0]
			},
			callback : function() {
				itm.setValue(aa[1])
			}
		});
	}
}
function Save(win, menuid) {
	ret = "";
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save2');
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	var parr = "rw|" + menuid + "^" + ret + "^" + checkret + "^" + comboret;
	menuid = cspRunServerMethod(Save.value, parr);
	curmenuid = menuid;
	win.close();
	loadgrid();
	return;
}

function setgrid1() 
{
	var mygrid = Ext.getCmp("mygrid1");
	// var parr = getParameters()
	mygrid.store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
}

function additm() {
	var grid = Ext.getCmp('mygrid1');
	var Plant = Ext.data.Record.create([]);
	var count = grid.store.getCount();
	var r = new Plant();
	grid.store.commitChanges();
	grid.store.insert(count, r);
	return;
}

function typdelete() 
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	var QtDelete = document.getElementById('QtDelete');
	if (QtDelete) {
		var id = rowObj[0].get("rw");
		var ee = cspRunServerMethod(QtDelete.value, id);
		if (ee != "0") {
			Ext.Msg.alert('提示',ee);
			return;
		}
	}
	setgrid();
};