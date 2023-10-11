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
	setsize("mygridpl","gform","mygrid",0);
  var grid = Ext.getCmp('mygrid');
  var tobar=grid.getTopToolbar(); 
  tobar.hide();
  var getVal=document.getElementById('getVal');  
	var but1=Ext.getCmp("mygridbut1");	
	but1.hide();
  var but=Ext.getCmp("mygridbut2");
	but.hide();	
	var mygrid = Ext.getCmp("mygrid");
	tbar2=new Ext.Toolbar({});
	tbar2.addItem("-");
	tbar2.addButton({
		text:'增加',
		handler:function(){addNew();},
		id:'addNewbtn',
		hidden:true,
		icon:'../images/uiimages/edit_add.png'
	});
	//Ext.getCmp('addNewbtn').hide()
	tbar2.addItem("-");
	tbar2.addButton({
		text:'编辑',
		id:'editBtn',
		hidden:true,
		icon:'../images/uiimages/pencil.png',
		handler:function(){editAdd();}
	});
	tbar2.addItem("-","查询类型",checktyp);
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
	//Ext.getCmp('delBtn').hide();
	tbar2.addItem("-");
	tbar2.addButton({
		text:"审核",
		id:'auditeBtn',
		hidden:true,
		icon:'../images/uiimages/ok.png',
		handler:function(){
			editAudite();
		}
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
//删除
function delItem()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par= rowObj[0].get("raw").replace("__","||");
	var delInfo=document.getElementById('delItem')
	var ret=cspRunServerMethod(delInfo.value,Par);
	Ext.Msg.alert('提示',ret)
	SchQual();
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
	var aa=cspRunServerMethod(pdata1,"","DHCNURPerProTechPositionAdd","","");
	var arr=eval(aa);
	var window=new Ext.Window({
		title:'审核确认',
		id:"gfrom21",
		x:200,y:150,
		width:580,
		height:260,
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
	Ext.getCmp("PerAppStartDate").setValue(ha1.items("PerAppStartDate"));
	Ext.getCmp("PerAppEndDate").setValue(ha1.items("PerAppEndDate"));
	var perProfQualNameStore=Ext.getCmp("PerProfQualName").getStore();
	perProfQualNameStore.load({params:{start:0,limit:100}});
	perProfQualNameStore.on('load',function(perProfQualNameStore,records,options){
		Ext.getCmp("PerProfQualName").selectText();
		Ext.getCmp("PerProfQualName").setValue(ha1.items("PerProfQualName").replace("__","||"));	
	});
	var profQualPosNameStore=Ext.getCmp("PerAppProfQualPosName").getStore();
	profQualPosNameStore.load({params:{start:0,limit:100}});
	profQualPosNameStore.on('load',function(profQualPosNameStore,records,options){
		Ext.getCmp("PerAppProfQualPosName").selectText();
		Ext.getCmp("PerAppProfQualPosName").setValue(ha1.items("PerAppProfQualPosName").replace("__","||"))	
	});
	Ext.getCmp("PerOccuQual").setValue(ha1.items("PerOccuQual"));
	Ext.getCmp("PerAppExamRersult").setValue(ha1.items("PerAppExamRersult"));
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
	var aa=cspRunServerMethod(pdata1,"","DHCNURPerProTechPositionAdd","","");
	arr=eval(aa);
	var window=new Ext.Window({
		title:'编辑',
		id:"gfrom21",
		x:200,y:150,
		width:580,
		height:260,
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
	var perProfQualName=Ext.getCmp('PerProfQualName');
	perProfQualName.setEditable(false);
	perProfQualName.listWidth=220;
	var perAppProfQualPosName=Ext.getCmp('PerAppProfQualPosName');
	perAppProfQualPosName.setEditable(false);
	perAppProfQualPosName.listWidth=220;
	var perOccuQual=Ext.getCmp('PerOccuQual');
	perOccuQual.setEditable(false);
	perOccuQual.triggerAction='all';
	var perAppExamRersult=Ext.getCmp('PerAppExamRersult');
	perAppExamRersult.setEditable(false);
	perAppExamRersult.triggerAction='all';
	var perName=Ext.getCmp("PerName");
	perName.disabled=true;
	Ext.getCmp("PerName").setValue(ha1.items("PerName"));		
	var perID=Ext.getCmp("PerID");
	perID.disabled=true;
	Ext.getCmp("PerID").setValue(PerID);		
	Ext.getCmp("PerAppStartDate").setValue(ha1.items("PerAppStartDate"));
	Ext.getCmp("PerAppEndDate").setValue(ha1.items("PerAppEndDate"));
	var perProfQualNameStore=Ext.getCmp("PerProfQualName").getStore();
	perProfQualNameStore.load({params:{start:0,limit:100}});
	perProfQualNameStore.on('load',function(perProfQualNameStore,records,options){
		Ext.getCmp("PerProfQualName").selectText();
		Ext.getCmp("PerProfQualName").setValue(ha1.items("PerProfQualName").replace("__","||"));	
	});
	var profQualPosNameStore=Ext.getCmp("PerAppProfQualPosName").getStore();
	profQualPosNameStore.load({params:{start:0,limit:100}});
	profQualPosNameStore.on('load',function(profQualPosNameStore,records,options){
		Ext.getCmp("PerAppProfQualPosName").selectText();
		Ext.getCmp("PerAppProfQualPosName").setValue(ha1.items("PerAppProfQualPosName").replace("__","||"))	
	});
	Ext.getCmp("PerOccuQual").setValue(ha1.items("PerOccuQual"));
	Ext.getCmp("PerAppExamRersult").setValue(ha1.items("PerAppExamRersult"));
	window.show();
	var PerAppStartDate=Ext.getCmp('PerAppStartDate');
	PerAppStartDate.on('select',function(dateField,date){
		var endDate=Ext.getCmp('PerAppEndDate').getValue();
		//alert(1)
		if(endDate!=""){
			var flag=date.between(date,endDate);
			if(!flag){
					Ext.Msg.alert('提示',"开始时间不能大于结束时间！");
				  PerAppStartDate.setValue("");
			}				
		}
	});
	var EndDate=Ext.getCmp('PerAppEndDate');
	EndDate.on('select',function(dateField,date){
		var stDate=Ext.getCmp('PerAppStartDate').getValue();
		if(stDate!=""){
			var flag=date.between(stDate,date);
			if(!flag){
				Ext.Msg.alert('提示','结束时间不能小于开始时间！');
				EndDate.setValue('');
			}
		}
	})
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
  var tm=ret.split('^')
	sethashvalue(ha,tm);
	var a = cspRunServerMethod(pdata1, "", "DHCNURPerProTechPositionAdd", "", "");
	arr = eval(a);
	var window= new Ext.Window({
		title : '添加专业技术职务信息',
		id : "gform2",
		x:200,y:200,
		width : 580,
		height : 260,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [arr],
		modal:true,
		resizable:false
	});
	var perProfQualName=Ext.getCmp('PerProfQualName');
	perProfQualName.setEditable(false);
	perProfQualName.listWidth=220;
	var perAppProfQualPosName=Ext.getCmp('PerAppProfQualPosName');
	perAppProfQualPosName.setEditable(false);
	perAppProfQualPosName.listWidth=220;
	var perOccuQual=Ext.getCmp('PerOccuQual');
	perOccuQual.setEditable(false);
	perOccuQual.triggerAction='all';
	var perAppExamRersult=Ext.getCmp('PerAppExamRersult');
	perAppExamRersult.setEditable(false);
	perAppExamRersult.triggerAction='all';
	var perName=Ext.getCmp("PerName");
	perName.disabled=true;
	var perID=Ext.getCmp("PerID");
	perID.disabled=true;
	Ext.getCmp("PerName").setValue(ha.items("PerName"))
	Ext.getCmp("PerID").setValue(PerID);
	window.show();
	
	var PerAppStartDate=Ext.getCmp('PerAppStartDate');
	PerAppStartDate.on('select',function(dateField,date){
		var endDate=Ext.getCmp('PerAppEndDate').getValue();
		//alert(1)
		if(endDate!=""){
			var flag=date.between(date,endDate);
			if(!flag){
					Ext.Msg.alert('提示',"开始时间不能大于结束时间！");
				  PerAppStartDate.setValue("");
			}				
		}
	});
	var EndDate=Ext.getCmp('PerAppEndDate');
	EndDate.on('select',function(dateField,date){
		var stDate=Ext.getCmp('PerAppStartDate').getValue();
		if(stDate!=""){
			var flag=date.between(stDate,date);
			if(!flag){
				Ext.Msg.alert('提示','结束时间不能小于开始时间！');
				EndDate.setValue('');
			}
		}
	})
	var edit1="0";
	var btnSave=Ext.getCmp("btnSave");
	btnSave.setIcon('../images/uiimages/filesave.png');
	btnSave.on("click",function(){SureCheck(RowId,edit1);SchQual();});
}
function SureCheck(RowId,edit1)
{
	var PerName=Ext.getCmp("PerName").getValue(); //姓名
	var PerID=Ext.getCmp("PerID").getValue(); //工号
  var PerProfQualName=Ext.getCmp("PerProfQualName").getValue(); //专业技术资格名称
  if(PerProfQualName==""){Ext.Msg.alert('提示',"请选择专业技术资格！");return;}
  if(PerProfQualName){
		PerProfQualName=PerProfQualName.replace("||","__");
	}
  var PerAppProfQualPosName=Ext.getCmp("PerAppProfQualPosName").getValue();  //聘任专业技术职务名称
  if(PerAppProfQualPosName==""){Ext.Msg.alert('提示',"请选择聘任专业技术职务！");return;}
  if(PerAppProfQualPosName){
		PerAppProfQualPosName=PerAppProfQualPosName.replace("||","__");
	}
  var PerOccuQual=Ext.getCmp("PerOccuQual").getValue(); //是否具有职业资格
  if(PerOccuQual==""){Ext.Msg.alert('提示',"请选择是否具有职业资格！");return;}
  var PerAppStartDate=Ext.getCmp("PerAppStartDate").getValue(); //聘任起始日期
  if(PerAppStartDate==""){
  	Ext.Msg.alert('提示',"请选择聘任起始日期！");
  	return;
  }else{
  	if(PerAppStartDate instanceof Date){
			PerAppStartDate=PerAppStartDate.format('Y-m-d');
		}
  }
  var PerAppEndDate=Ext.getCmp("PerAppEndDate").getValue(); //聘任终止日期
  if(PerAppEndDate instanceof Date){
  	PerAppEndDate=PerAppEndDate.format('Y-m-d');
  }
  
 // if(PerAppEndDate==""){alert("请选择聘任终止日期！");return;}
  var PerAppExamRersult=Ext.getCmp("PerAppExamRersult").getValue(); //聘任考核结果	
  if(PerAppExamRersult==""){Ext.Msg.alert('提示',"请选择聘任考核结果！");return;}

	var parr="raw|"+RowId+"^PerName|"+PerName+"^PerID|"+PerID+"^PerProfQualName|"+PerProfQualName+"^PerAppProfQualPosName|"+PerAppProfQualPosName+"^PerOccuQual|"+PerOccuQual+"^PerAppStartDate|"+PerAppStartDate+"^PerAppEndDate|"+PerAppEndDate+"^PerAppExamRersult|"+PerAppExamRersult;
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
}