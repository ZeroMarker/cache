var Width = document.body.clientWidth-2;
var Height = document.body.clientHeight-2;
var checktyp = new Ext.form.ComboBox({
	name : 'CheckTyp1',
	id : 'CheckTyp1',
	tabIndex : '0',
	//height : 20,
	width : 70,
	xtype : 'combo',
	store : new Ext.data.JsonStore({
		data : [{
			desc:'全部',
			id:'Complete'
		},{
			desc : '未审核',
			id : 'unVerify'
		}, {
			desc : '已审核',
			id : 'Verify'
		}],
		fields : ['desc', 'id']
	}),
	displayField : 'desc',
	valueField : 'id',
	allowBlank : true,
	mode : 'local',
	value : 'Complete'
});
function BodyLoadHandler()
{
	//获取护理安全组
	var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
	/*-----------------------------------------*/
  //setsize("mygridpl","gform","mygrid",0);
  var gridPl = Ext.getCmp('mygridpl');
  gridPl.setWidth(Width);
  gridPl.setHeight(Height);
  var grid = Ext.getCmp('mygrid');
  var tobar=grid.getTopToolbar();
  tobar.hide();   
  var getVal=document.getElementById('getVal');  
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
  var but=Ext.getCmp("mygridbut2");
	but.hide();	
	var mygrid = Ext.getCmp("mygrid");
	var tbar2=new Ext.Toolbar({});
	tbar2.addItem("-");
	tbar2.addButton({
		text:'增加',
		handler:function(){addNew();},
		id:'addNewbtn',
		hidden:true,
		icon:'../images/uiimages/edit_add.png'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:'编辑',
		id:'editBtn',
		hidden:true,
		icon:'../images/uiimages/pencil.png',
		handler:function(){editAdd();}
	});
	tbar2.addItem("-","查询类型:",checktyp);
	tbar2.addItem("-");
	tbar2.addButton({
		text:"查询",
		handler:function(){SchQual(PerID);},
		id:'btnSch',
		hidden:true,
		icon:'../images/uiimages/search.png'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:"删除",
		id:'delBtn',
		hidden:true,
		icon:'../images/uiimages/edit_remove.png',
		handler:function(){delItem();}	
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:"审核",
		id:'auditeBtn',
		hidden:true,
		icon:'../images/uiimages/ok.png',
		handler:function(){editAudite();}
	});
//	if((session['LOGON.GROUPDESC']=="护理部")||(session['LOGON.GROUPDESC']=="护理部主任")||(session['LOGON.GROUPDESC']=="Demo Group")||(session['LOGON.GROUPDESC']=="住院护士长")||(session['LOGON.GROUPDESC']=="注射室护士长")||(session['LOGON.GROUPDESC']=="门诊护士长")){
//		var btnAudite=Ext.getCmp('auditeBtn');
//		btnAudite.show();
//	}else{
//			var btnAudite=Ext.getCmp('auditeBtn');
//			btnAudite.hide();
//	}
	mygrid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	tbar2.render(grid.tbar);
	bbar2.render(mygrid.bbar);
	tobar.doLayout();
	var contextmenu=new Ext.menu.Menu({
		id:'theContextMenu',
 		items:[{
 			text:'撤销审核',
   		iconCls:'revoke',
   		icon:'../images/uiimages/undo.png',
   		handler:function(){
    		revokeAudite();
    		SchQual();
   		}
  	}]
	});
	//if((session['LOGON.GROUPDESC']=="护理部")||(session['LOGON.GROUPDESC']=="护理部主任")||(session['LOGON.GROUPDESC']=="Demo Group")||(session['LOGON.GROUPDESC']=="住院护士长")||(session['LOGON.GROUPDESC']=="注射室护士长")||(session['LOGON.GROUPDESC']=="门诊护士长")){
	if((secGrpFlag=="hlb")||(secGrpFlag=="demo")||(secGrpFlag=="hlbzr")||(secGrpFlag=="znurhead")){
		grid.on('rowcontextmenu',function(grid,rowIndex,e){
			var selections = grid.getSelectionModel().getSelections();
			if(selections[0].get("PerFlag")==1){
				e.preventDefault();
 				grid.getSelectionModel().selectRow(rowIndex);
 				contextmenu.showAt(e.getXY());
			}
			if(selections[0].get("PerFlag")==0){
				e.preventDefault();
 				grid.getSelectionModel().selectRow(rowIndex);
 				contextmenu.hide();
 				//contextmenu.showAt(e.getXY());
			};
		});
	}
	//通过护理安全组判断显示页面控件元素
	var PageElement=toMgSecGrpSub(secGrpFlag,EmrCode);
	//--PageElement="addNewbtn^longTranBtn"
	var ElementArray=PageElement.split('^');
	for(var i=0;i<ElementArray.length;i++){
		if(Ext.getCmp(ElementArray[i])){
			Ext.getCmp(ElementArray[i]).show();
		}
	}
	/*=======================================*/
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on("beforeload",function(){
   	var chktyp=Ext.getCmp("CheckTyp1").getValue();
	 	var mygrid = Ext.getCmp("mygrid");
   	mygrid.store.baseParams.parrm=PerID;
   	mygrid.store.baseParams.rowid=RowId;
   	mygrid.store.baseParams.typ=chktyp;
  });
  var len=mygrid.getColumnModel().getColumnCount()
	for(var i=0;i<len;i++){
		if(mygrid.getColumnModel().getDataIndex(i)=="PerFlag"){
			mygrid.getColumnModel().setHidden(i,true);
		}
		if(mygrid.getColumnModel().getDataIndex(i)=="raw"){
			mygrid.getColumnModel().setHidden(i,true);
		}
	}
  SchQual(PerID);	
}
function delItem()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par= rowObj[0].get("raw").replace("__","||");
	var retVal=tkMakeServerCall('DHCMGNUR.MgNurExamine','delItem',Par);
	Ext.Msg.alert('提示',retVal);
	SchQual();
}
function SchQual(parr)
	{
		var mygrid = Ext.getCmp("mygrid"); 
		mygrid.getStore().addListener('load',handleGridLoadEvent);
		mygrid.store.load({
			params : {
				start : 0,
				limit : 30
			}
		});				
	}
function handleGridLoadEvent(store,records)
{
	var grid=Ext.getCmp('mygrid');
	//var rowObj = grid.getSelectionModel().getSelections();
	//var rowCount=grid.getStore().getCount()
	var gridcount=0;
	store.each(function(r){
		if(r.get('PerFlag')==1){
			//grid.getView().getRow(gridcount).style.backgroundColor='#33FF00';	
			//grid.getView().getCell(gridcount,0).style.backgroundColor='#33FF00';
			grid.getView().getCell(gridcount,0).style.backgroundImage="url('../images/uiimages/ok.png')";
			grid.getView().getCell(gridcount,0).style.backgroundRepeat='no-repeat';
			grid.getView().getCell(gridcount,0).style.backgroundPosition='center';
		}else if(r.get('PerFlag')==0){
			//grid.getView().getRow(gridcount).style.backgroundColor='#FF3300';	
			//grid.getView().getCell(gridcount,0).style.backgroundColor='#FF3300';
			grid.getView().getCell(gridcount,0).style.backgroundImage="url('../images/uiimages/cancel.png')";
			grid.getView().getCell(gridcount,0).style.backgroundRepeat='no-repeat';
			grid.getView().getCell(gridcount,0).style.backgroundPosition='center';
		}
		gridcount=gridcount+1;
	})
}
function editAudite()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}	
	var Par = rowObj[0].get("raw");		
	var getVal=document.getElementById('getVal');
	var ret=cspRunServerMethod(getVal.value,RowId);
	var ha = new Hashtable();
  var tm=ret.split('^')
	sethashvalue(ha,tm);
	var getValue=document.getElementById('getValue');
	var ret1=cspRunServerMethod(getValue.value,Par);
	var ha1=new Hashtable();
	var tm1=ret1.split('^');
	sethashvalue(ha1,tm1);
	var aa=cspRunServerMethod(pdata1,"","DHCNURPerExamineAdd","","");
	var arr=eval(aa);
	var window=new Ext.Window({
		title:'审核确认',
		id:"gfrom21",
		x:210,y:100,
		width :480,
		height : 330,
		autoScroll:true,
		layout:'absolute',
		items:[arr],
		modal:true,
		resizable:false
	});	
	if(ha1.items("PerFlag")==1){
		//var btnSave=Ext.getCmp("btnSave");
		//btnSave.hide();
		Ext.Msg.alert('提示',"已审核，不能重复审核!");
		return;
	}	
	var perName=Ext.getCmp("PerName");
	perName.disabled=true;
	Ext.getCmp("PerName").setValue(ha1.items("PerName"));		
	var perID=Ext.getCmp("PerID");
	perID.disabled=true;
	Ext.getCmp("PerID").setValue(PerID);
	Ext.getCmp("PerExamineDate").setValue(ha1.items("PerExamineDate"));
	Ext.getCmp("PerExamineType").setValue(ha1.items("PerExamineType"));
	Ext.getCmp("PerExamineContent").setValue(ha1.items("PerExamineContent"));
	Ext.getCmp("PerExamineResult").setValue(ha1.items("PerExamineResult"));
	Ext.getCmp("PerExamineOpinion").setValue(ha1.items("PerExamineOpinion"));
	Ext.getCmp("PerExamineUnit").setValue(ha1.items("PerExamineUnit"));
	Ext.getCmp("PerExaminePerson").setValue(ha1.items("PerExaminePerson"));
	Ext.getCmp("PerExamineScore").setValue(ha1.items("PerExamineScore"));
	window.show();
	var btnSave=Ext.getCmp("btnSave");
	btnSave.setIcon('../images/uiimages/ok.png');
	btnSave.setText("确认审核");
	btnSave.on("click",function(){VerifySure(Par);window.close();Ext.Msg.alert('提示',"审核完毕！");SchQual();});
}

//撤销审核
function revokeAudite(Par)
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var Par = rowObj[0].get("raw");	
	var revokeFlag="0";
	var parr=Par+"^"+PerID+"^"+revokeFlag;
	var revokeSave=document.getElementById('revokeSave');
	var a=cspRunServerMethod(revokeSave.value,parr);
}
///审核
function VerifySure(Par)
{
	//alert(Par);
	var verFlag="1";
	var parr=Par+"^"+PerID+"^"+verFlag;
	var VerSave = document.getElementById('VerSave');
	var a=cspRunServerMethod(VerSave.value,parr);	
}
///修改编辑
function editAdd()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}	
	var Par = rowObj[0].get("raw");	
	var getVal=document.getElementById('getVal');
	var ret=cspRunServerMethod(getVal.value,RowId);
	var ha = new Hashtable();
  var tm=ret.split('^')
	sethashvalue(ha,tm);
	var getValue=document.getElementById('getValue');
	var ret1=cspRunServerMethod(getValue.value,Par);
	var ha1=new Hashtable();
	var tm1=ret1.split('^');
	sethashvalue(ha1,tm1);
	var aa=cspRunServerMethod(pdata1,"","DHCNURPerExamineAdd","","");
	arr=eval(aa);
	var window=new Ext.Window({
		title:'编辑',
		id:"gfrom21",
		x:210,y:100,
		width :480,
		height : 330,
		autoScroll:true,
		layout:'absolute',
		items:[arr],
		modal:true,
		resizable:false
	});	
	if(ha1.items("PerFlag")==1){
		var btnSave=Ext.getCmp("btnSave");
		btnSave.hide();
		Ext.Msg.alert('提示',"已审核，不能修改!");
		return;
	}	
	var perName=Ext.getCmp("PerName");
	perName.disabled=true;
	Ext.getCmp("PerName").setValue(ha1.items("PerName"));		
	var perID=Ext.getCmp("PerID");
	perID.disabled=true;
	Ext.getCmp("PerID").setValue(PerID);
	Ext.getCmp("PerExamineDate").setValue(ha1.items("PerExamineDate"));
	Ext.getCmp("PerExamineType").setValue(ha1.items("PerExamineType"));
	Ext.getCmp("PerExamineContent").setValue(ha1.items("PerExamineContent"));
	Ext.getCmp("PerExamineResult").setValue(ha1.items("PerExamineResult"));
	Ext.getCmp("PerExamineOpinion").setValue(ha1.items("PerExamineOpinion"));
	Ext.getCmp("PerExamineUnit").setValue(ha1.items("PerExamineUnit"));
	Ext.getCmp("PerExaminePerson").setValue(ha1.items("PerExaminePerson"));
	Ext.getCmp("PerExamineScore").setValue(ha1.items("PerExamineScore"));
	window.show();
	var edit1="1";
	var btnSave=Ext.getCmp("btnSave");
	btnSave.setIcon('../images/uiimages/reload.png');
	btnSave.setText("更新");
	btnSave.on("click",function(){SureCheck(Par,edit1);SchQual();});
}
function addNew()
{
	var getVal=document.getElementById('getVal');
	var ret=cspRunServerMethod(getVal.value,RowId);
	var ha = new Hashtable();
  var tm=ret.split('^');
	sethashvalue(ha,tm);
	var a = cspRunServerMethod(pdata1, "", "DHCNURPerExamineAdd", "", "");
	arr = eval(a);
	var window= new Ext.Window({
		title : '添加考核信息',
		id : "gform2",
		x:210,y:100,
		width :480,
		height : 330,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [arr],
		modal:true,
		resizable:false
	});			
	var perName=Ext.getCmp("PerName");
	perName.disabled=true;
	var perID=Ext.getCmp("PerID");
	perID.disabled=true;
	Ext.getCmp("PerName").setValue(ha.items("PerName"));
	Ext.getCmp("PerID").setValue(PerID);
	window.show();
	var edit1="0";
	var btnSave=Ext.getCmp("btnSave");
	btnSave.setIcon('../images/uiimages/filesave.png');
	btnSave.on("click",function(){SureCheck(RowId,edit1);SchQual();});	

}
function SureCheck(RowId,edit1)
{
	var PerName=Ext.getCmp("PerName").getValue(); //姓名
	var PerID=Ext.getCmp("PerID").getValue(); //工号
	var PerExamineDate=Ext.getCmp("PerExamineDate").getValue();
	if(PerExamineDate==""){
		Ext.Msg.alert('提示',"请选择考核时间！");
		return;
	}else{
		if(PerExamineDate instanceof Date){
			PerExamineDate=PerExamineDate.format('Y-m-d');
		}
	}
	
	var PerExamineType=Ext.getCmp("PerExamineType").getValue();
	if(PerExamineType==""){Ext.Msg.alert('提示',"请填写考核类别！");return;}
	var PerExamineContent=Ext.getCmp("PerExamineContent").getValue();
	if(PerExamineContent==""){Ext.Msg.alert('提示',"请填写考核内容！");return;}
	var PerExamineResult=Ext.getCmp("PerExamineResult").getValue();
	if(PerExamineResult==""){Ext.Msg.alert('提示',"请填写考核结果！");return;}
	
	var PerExamineScore=Ext.getCmp("PerExamineScore").getValue(); //PerExamineScore
	if(PerExamineScore==""){Ext.Msg.alert('提示',"请输入考核分数！");return;}
	
	var PerExamineOpinion=Ext.getCmp("PerExamineOpinion").getValue();
	if(PerExamineOpinion==""){Ext.Msg.alert('提示',"请填写考核意见！");return;}
	var PerExamineUnit=Ext.getCmp("PerExamineUnit").getValue();
	if(PerExamineUnit==""){Ext.Msg.alert('提示',"请填写考核单位！");return;}
	var PerExaminePerson=Ext.getCmp("PerExaminePerson").getValue();
	//if(PerExaminePerson==""){alert("请填写考察人！");return;}

	var parr="raw|"+RowId+"^PerName|"+PerName+"^PerID|"+PerID+"^PerExamineDate|"+PerExamineDate+"^PerExamineType|"+PerExamineType+"^PerExamineContent|"+PerExamineContent+"^PerExamineResult|"+PerExamineResult+"^PerExamineOpinion|"+PerExamineOpinion+"^PerExamineUnit|"+PerExamineUnit+"^PerExaminePerson|"+PerExaminePerson+"^PerExamineScore|"+PerExamineScore;
	//alert(parr);
	var Save = document.getElementById('Save');
	var a=cspRunServerMethod(Save.value,parr);
	if (edit1==0){
		var gform2=Ext.getCmp("gform2");
		gform2.close();
	}
	else if (edit1==1){
		var gform21=Ext.getCmp("gfrom21");
		gform21.close();
	}
	//var gform2=Ext.getCmp("gform2");
	//gform2.close();
}