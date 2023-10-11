
//var SSGCmb =CreateComboBoxQ("SSGCmb","Group","ID","安全组","","180","web.DHCMgNurChildPage","SSGROUP","desc",0,0);

var SSGCmb=new Ext.form.ComboBox({
	name:'SSGCmb',
	id:'SSGCmb',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'Group',
				'mapping':'Group'
			},{
				'name':'ID',
				'mapping':'ID'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurChildPage',
			methodName:'SSGROUP',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:'200',
	//height:18,
	width:120,
	xtype : 'combo',
	displayField : 'Group',
	valueField : 'ID',
	hideTrigger : false,
	queryParam : 'desc',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 20,
	typeAhead : true,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
});


function BodyLoadHandler(){
	var grid = Ext.getCmp('mygrid');
	Ext.getCmp('mygridbut1').hide();
	var but=Ext.getCmp('mygridbut2');
  but.setText("保存");
  but.setIcon('../images/uiimages/filesave.png');
  but.on("click",Save);
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.addItem("-","安全组",SSGCmb);
	tobar.doLayout();
  var cmb=Ext.getCmp("SSGCmb");
  cmb.on("select",loadgrid);
  grid.on('dblclick', griddblclick);
  grid.store.load({params:{start:0,limit:10}});
}
function griddblclick()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择安全组！");
		return;
	}
	var sgrp=rowObj[0].get("ID");
	var mould = cspRunServerMethod(getmould1);
	var mouldarr = mould.split('^')
	for(var i=0;i<mouldarr.length;i++){
		itm = mouldarr[i].split('|');
		var ssgrpcheck=cspRunServerMethod(getssgrpcheck1,sgrp,itm[0])
		//alert(ssgrpcheck)
		var tree1=Ext.getCmp(itm[0]+"1");
		clearcheckchildnode(tree1.getRootNode());
		if (ssgrpcheck!="")
		{
			var ha = new Hashtable();
			var arr=ssgrpcheck.split("|");
			//alert(arr);
			for (var j=0;j<arr.length;j++)
			{
			  if (arr[j]!="")
				inserthashItm(arr[j],arr[j],ha);
			}
			findchildnode(tree1.getRootNode(),ha);//);
		}
	}
}
function clearcheckchildnode(node){
  var childnodes = node.childNodes;
  var nd;
  for(var i=0;i<childnodes.length;i++){  //从节点中取出子节点依次遍历
  	nd = childnodes[i];
	 	nd .getUI().toggleCheck(false);
	 	//nodevalue += nd.id + ",";
	 	//alert(nodevalue);
	 	if(nd.hasChildNodes()){  //判断子节点下是否存在子节点
	  	 clearcheckchildnode(nd);    //如果存在子节点  递归
	 	}
  }
}
function inserthashItm(item,typ,ha)
{
  if (ha.contains(item)) {
	}
	else {
		ha.add(item, typ)
  }
}
function findchildnode(node,ha){
  var childnodes = node.childNodes;
  var nd;
  for(var i=0;i<childnodes.length;i++){  //从节点中取出子节点依次遍历
		nd=childnodes[i];
		if(ha.contains(nd.id)){
	  	//alert(nd.id);
	  	nd .getUI().toggleCheck(true);
		}
		//nodevalue += nd.id + ",";
		//alert(nodevalue);
		if(nd.hasChildNodes()){ //判断子节点下是否存在子节点
	  	findchildnode(nd,ha);    //如果存在子节点  递归
		}
  }
}
function loadgrid()
{
	var cmb=Ext.getCmp("SSGCmb");
	//debugger;
  Ext.getCmp("mygrid").store.load({params:{start:0,limit:10,desc:cmb.lastSelectionText}});
}
function Save()
{
	var mygrid=Ext.getCmp('mygrid');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择安全组！");
		return;
	}
	var secGrp=rowObj[0].get("ID");
	var mould = cspRunServerMethod(getmould1);
	var mouldarr = mould.split('^');
	//mould="DHCNURPerChiefPosition|3^DHCNURPerDepartLearning|2^DHCNURPerHosBusLearning|1^DHCNURPerProTechPosition|4^DHCNURPerResearch|5"
	for (i = 0; i < mouldarr.length; i++){
		itm = mouldarr[i].split('|');
		//itm="DHCNURPerChiefPosition,3"
		//alert(itm)
		var checkitms = Ext.getCmp(itm[0]+"1").getChecked('id');
		//alert(checkitms)
		if(checkitms!=''){
			var ret=tkMakeServerCall("DHCMGNUR.MgNurSecLayOut","Save",secGrp,itm[0]+"|"+checkitms);
			//alert(ret)
		}
	}
	return;
}