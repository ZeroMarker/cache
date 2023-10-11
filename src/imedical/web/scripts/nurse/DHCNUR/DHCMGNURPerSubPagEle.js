var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-2;
var menuCode=new Ext.form.TextField({
	id:'menuCode'	,
	xtype:'textfield',
	width:180,
	//height:22,
	allowBlank:false,
	//regex: /^\w+$/,
	regexText: '只能输入数字、26个英文字母组成的字符串',
	//cls:'Diy-text',
	vtype: 'alphanum',
	enableKeyEvents:true,
	listeners:{
		blur:function(menuCode,e){
			//var val=menuCode.getValue().toString().replace(/^\w+$/);
			//menuCode.setValue(val)
			var reg=/^\w+$/;
			if(!reg.test(menuCode.getValue())){
				Ext.Msg.alert('提示',menuCode.regexText);
				menuCode.setValue();
				return;
			}
		}	
	}
})
var menuDesc=new Ext.form.TextField({
	id:'menuDesc',
	xtype:'textfield',
	width:150,
	//height:22,
	allowBlank:false,
	listeners:{
		blur:function(menuDesc,e){
			if(!menuDesc.getValue()){
				Ext.Msg.alert('提示','描述不能为空!');
				return;
			}
		}	
	}
});
function BodyLoadHandler(){
	//setsize("mygridpl","gform","mygrid");
	var gridPl = Ext.getCmp('mygridpl');
	gridPl.setWidth(Width);
	gridPl.setHeight(Height);
	Ext.getCmp('mygrid').getTopToolbar().hide();
	var mygrid=Ext.getCmp('mygrid');
	mygrid.colModel.setHidden(2,true);
	var tbar=new Ext.Toolbar({});
	tbar.addItem('-','JS文件名:',menuCode);
	tbar.addItem('-','描述:',menuDesc);
	tbar.addItem('-');
	tbar.addButton({
		id:'newBtn',
		text:'增加',
		icon:'../images/uiimages/edit_add.png',
		handler:function(){addFunRec();}
	});
	tbar.addItem('-');
	tbar.addButton({
		id:'editBtn',
		text:'编辑',
		icon:'../images/uiimages/pencil.png',
		disabled :true,
		handler:function(){editFunRec();}	
	})
	tbar.addItem('-');
	tbar.addButton({
		id:'delBtn',
		text:'清屏',
		icon:'../images/uiimages/clearscreen.png',
		handler:function(){clearFunRec();}	
	});
	var bbar = mygrid.getBottomToolbar ();
	bbar.hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:20,
		store:mygrid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(mygrid.bbar);
	tbar.render(mygrid.tbar);
	tbar.doLayout();
	mygrid.on('rowclick',rowClick);
	mygrid.on('rowdblclick',rowDblClick);
//	menuCode.on('keyup',function(menuCode,e){
//		alert('eee')
//	})
	
	findRec();
}
function addFunRec()
{
	var MenuCode=Ext.getCmp('menuCode').getValue();
	if(!MenuCode){
		Ext.Msg.alert('提示','js文件名不能为空！');
		return;
	}
	var existFlag=tkMakeServerCall("DHCMGNUR.MgChildPagEle","IsExist",MenuCode);
	if(existFlag!=0){
		Ext.Msg.alert('提示','此条记录已经存在，不用重复添加！');
		return;	
	}
	var MenuDesc=Ext.getCmp('menuDesc').getValue();
	if(!MenuDesc){
		Ext.Msg.alert('提示','描述不能为空！');
		return;
	}
	var rw="";
	var parr="rw|"+rw+"^MenuCode|"+MenuCode+"^MenuDesc|"+MenuDesc;
	var ret=tkMakeServerCall("DHCMGNUR.MgChildPagEle","Save",parr)
	//alert(ret)
	if(ret){
		Ext.Msg.alert('提示','保存成功！');
		findRec();
	}
}
function clearFunRec()
{
	Ext.getCmp('menuCode').setValue('');
	Ext.getCmp('menuDesc').setValue('');
	Ext.getCmp('newBtn').enable();
	Ext.getCmp('editBtn').disable();
	findRec();
}
function editFunRec()
{
	var mygrid=Ext.getCmp('mygrid');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	var rw=rowObj[0].get('rw');
	var MenuCode=Ext.getCmp('menuCode').getValue();
	if(!MenuCode){
		Ext.Msg.alert('提示','JS文件名不能为空！');
		return;
	}
//	var existFlag=tkMakeServerCall("DHCMGNUR.MgChildPagEle","IsExist",MenuCode);
//	if(existFlag!=0){
//		Ext.Msg.alert('提示','此条记录已经存在，不用重复添加！');
//		return;	
//	}
	var MenuDesc=Ext.getCmp('menuDesc').getValue();
	if(!MenuDesc){
		Ext.Msg.alert('提示','描述不能为空！');
		return;
	}
	var parr="rw|"+rw+"^MenuCode|"+MenuCode+"^MenuDesc|"+MenuDesc;
	//var existFlag=tkMakeServerCall("DHCMGNUR.MgChildPagEle","IsExist",MenuCode);
	var existFlag=tkMakeServerCall("DHCMGNUR.MgChildPagEle","IsExist",parr);
	if(existFlag==1){
		Ext.Msg.alert('提示','此条记录已经存在，不用重复添加！');
		return;	
	}
	if (confirm('人力子集信息为重要配置信息,要慎重修改,是否确认修改？')) {
		var ret=tkMakeServerCall("DHCMGNUR.MgChildPagEle","Save",parr);
		Ext.getCmp('newBtn').enable();
		Ext.getCmp('editBtn').disable();
		findRec();
    }
}
function rowClick()
{
	Ext.getCmp('newBtn').disable();
	Ext.getCmp('editBtn').enable();
	var mygrid=Ext.getCmp('mygrid');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	var rw=rowObj[0].get('rw');
	var ret=tkMakeServerCall("DHCMGNUR.MgChildPagEle","getVal",rw);
	var ha=new Hashtable();
	var tm=ret.split('^')
	sethashvalue(ha,tm);
	Ext.getCmp('menuCode').setValue(ha.items('menuCode'));
	Ext.getCmp('menuDesc').setValue(ha.items('menuDesc'));
	
}
function rowDblClick()
{
	var DHCMGNURPerChildPagSubT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'ItemCode','mapping':'ItemCode'},{'name':'ItemTyp','mapping':'ItemTyp'},{'name':'ItemDesc','mapping':'ItemDesc'},{'name':'raw','mapping':'raw'}]}),baseParams:{className:'web.DHCMgNurChildPage',methodName:'FindChildSubCtl',type:'RecQuery'}});
	var mygrid=Ext.getCmp('mygrid');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var rw = rowObj[0].get('rw');
	var a=cspRunServerMethod(pdata1, "", "DHCMGNURPerChildPagSub", "", "");
	var arr=eval(a);
	var formPanel=new Ext.form.FormPanel({
		x:0,y:0,width:500,height:500,
 		bodyStyle:'padding:5px 5px 0',
    id:'formPanel',renderTo:Ext.getBody(),
    frame:true,
    labelAlign:'left',
    autoScroll:true,
    layout:'absolute',
    defaults:{defaults:{anchor:'100%'}},
		items:[arr]
	});
	var grid=Ext.getCmp('grid');
	var win=new Ext.Window({
		title:'添加控制元素',
		id:'surWin1',x:10,y:2,width:465,height:600,
		modal:'true',
		autoScroll:true,
		layout:'absolute',
		items:[arr],
		buttons:[{ 
			xtype: 'button',
			id:'btnSave',
      text:'关闭',
	  icon:'../images/uiimages/cancel.png',
      handler:function(){win.close();}
    }]
	});
	grid.store.on('beforeLoad',function(){
		grid.store.baseParams.par=rw;
	})
	Ext.getCmp('gridpl').setWidth(win.width);
	Ext.getCmp('gridpl').setHeight(win.height);
	win.show();
	Ext.getCmp('gridbut1').hide();
	Ext.getCmp('gridbut2').hide();
	var tobar=grid.getTopToolbar();
	tobar.addItem('-');
	tobar.addButton({
		id:'addItemBtn',
		text:'增加',
		icon:'../images/uiimages/edit_add.png',
		handler:function(){var raw="";addItemRec(raw);}
	});
	tobar.addItem('-');
	tobar.addButton({
		id:'saveItemBtn',
		text:'保存',
		icon:'../images/uiimages/filesave.png',
		handler:function(){saveItemRec(rw);}
	});
	grid.getBottomToolbar().hide();
	var mbbar= new Ext.PagingToolbar({
		pageSize:20,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg:"没有记录"
	});
	mbbar.render(grid.bbar);
	searchGrid();
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'raw'){
			grid.getColumnModel().setHidden(i,true);
		}
  }

}
function addItemRec(raw)
{
	var grid=Ext.getCmp('grid');
	var Plant=Ext.data.Record.create([]);
  var count=grid.store.getCount(); 
  var r=new Plant(); 
  grid.store.commitChanges(); 
  grid.store.insert(count,r); 
  return;
}
function saveItemRec(rw)
{
	var raw="";
	var grid=Ext.getCmp('grid');
	var rowObj = grid.getSelectionModel().getSelections();
	if(rowObj.length == 0){
		Ext.Msg.alert('提示','请选择需要保存的行！');
		return;
	}
	var ItemCode=rowObj[0].get('ItemCode');
	if((ItemCode==undefined)||(ItemCode=="")){Ext.Msg.alert("提示","请输入有效代码值！");return;}
	else{
		var reg=/^[A-Za-z0-9]+$/;
		if(!reg.test(ItemCode))
		{
			Ext.Msg.alert('提示',"代码值由数字和26个英文字母组成");
			return;
		}
	}

	var ItemDesc=rowObj[0].get('ItemDesc');
	if((ItemDesc==undefined)||(ItemDesc=="")){Ext.Msg.alert("提示","描述不能为空！");return;}
	var ItemTyp=rowObj[0].get('ItemTyp');
	if((ItemTyp==undefined)||(ItemTyp=="")){Ext.Msg.alert('提示','元素类型不能为空！');return;}
	raw=rowObj[0].get('raw');
	if((raw==undefined)||(raw=="")){raw=rw+"__"+"";}
	var parr="ItemCode|"+ItemCode+"^ItemDesc|"+ItemDesc+"^ItemTyp|"+ItemTyp+"^raw|"+raw;
	//alert(parr)
	var isExistRec=tkMakeServerCall("DHCMGNUR.MgChildPagEleSub","IsExistRec",ItemCode+"^"+rw+"^"+raw);
	if(isExistRec==0){
		Ext.Msg.alert('提示','此记录已经存在，请更换代码后重新保存！');
		return;
	}
	var ret=tkMakeServerCall("DHCMGNUR.MgChildPagEleSub","Save",parr);
	if(ret!=0){
		//alert(ret)
		Ext.Msg.alert('提示','保存成功！');
		searchGrid();
	}else{
		//alert(ret)
		Ext.Msg.alert('提示','保存失败！');
	}

}
function searchGrid()
{
	var grid=Ext.getCmp('grid');
	grid.store.load({
		params:{
			start:0,
			limit:20	
	}});
}
function findRec()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({
		params:{
			start:0,
			limit:20	
		}
	});
	mygrid.store.sort('rw','asc');
}