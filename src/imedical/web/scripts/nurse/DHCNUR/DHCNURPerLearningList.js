var Width = document.body.clientWidth;
var Height = document.body.clientHeight;
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
	tbar2=new Ext.Toolbar({});
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
	tbar2.addItem("-","查询类型",checktyp);
	tbar2.addItem("-");
	tbar2.addButton(
	{
		text:"查询",
		handler:function(){SchQual(PerID);},
		id:'btnSch',
		hidden:true,
		icon:'../images/uiimages/search.png'
	});	
	tbar2.addItem("-");
	tbar2.addButton({
		text:'删除',
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
//		var btnAudite=Ext.getCmp('auditeBtn');
//		btnAudite.hide();
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
	   mygrid.store.baseParams.parr=PerID;
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
	//alert(rowObj)
	var Par= rowObj[0].get("raw").replace("__","||");
	var delInfo=document.getElementById('delItem')
	var ret=cspRunServerMethod(delInfo.value,Par);
	Ext.Msg.alert('提示',ret);
	SchQual();
}
///审核窗口
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
	var aa=cspRunServerMethod(pdata1,"","DHCNURLearningAdd","","");
	var arr=eval(aa);
	var window=new Ext.Window({
		title:'审核确认',
		id:"gfrom21",
		x:200,y:100,
		width:480,
		height:325,
		autoScroll:true,
		layout:'absolute',
		items:[arr],
		modal:true,
		resizable:false
		});	
		if(ha1.items("PerFlag")==1){
			//var btnSave=Ext.getCmp("btSave");
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
		Ext.getCmp("StaDate").setValue(ha1.items("StaDate"));
		Ext.getCmp("EndDate").setValue(ha1.items("EndDate"));	
		var professionStore=Ext.getCmp("PerProfession").getStore();
		professionStore.load({params:{start:0,limit:1000}});
		professionStore.on('load',function(professionStore, records, options){
			  Ext.getCmp("PerProfession").selectText();
				Ext.getCmp("PerProfession").setValue(ha1.items("PerProfession").replace("__","||"));
			});
		var schoolAgeDrStore=Ext.getCmp("PerSchoolAgeDr").getStore();		
		schoolAgeDrStore.load({params:{start:0,limit:1000}});
		schoolAgeDrStore.on('load',function(Store,records,options){
			Ext.getCmp("PerSchoolAgeDr").selectText();
			Ext.getCmp("PerSchoolAgeDr").setValue(ha1.items("PerSchoolAgeDr").replace("__","||"));
			});						
		var degreeStore=Ext.getCmp("PerDegreeDR").getStore();
		degreeStore.load({params:{start:0,limit:1000}});
		degreeStore.on('load',function(degreeStore,records,options){
			Ext.getCmp("PerDegreeDR").selectText();
			Ext.getCmp("PerDegreeDR").setValue(ha1.items("PerDegreeDR").replace("__","||"));
		});	
		var perGradSchStore=Ext.getCmp('PerGraduateSchool').getStore();
		perGradSchStore.load({params:{start:0,limit:1000}});
		perGradSchStore.on('load',function(perGradSchStore,records,options){
			Ext.getCmp("PerGraduateSchool").selectText();
			Ext.getCmp("PerGraduateSchool").setValue(ha1.items("PerGraduateSchool").replace("__","||"));	
		})
	
		//Ext.getCmp("PerGraduateSchool").setValue(ha1.items("PerGraduateSchool").replace("__","||"));	
		Ext.getCmp("PerSchoolAgeNo").setValue(ha1.items("PerSchoolAgeNo"));
		Ext.getCmp("PerDegreeNo").setValue(ha1.items("PerDegreeNo"));
		
		Ext.getCmp("PerHeadShip").setValue(ha1.items("PerHeadShip"));
		Ext.getCmp("PerReferences").setValue(ha1.items("PerReferences"));
		window.show();
		var btnSave=Ext.getCmp("btSave");
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
//修改编辑
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
	var aa=cspRunServerMethod(pdata1,"","DHCNURLearningAdd","","");
	arr=eval(aa);
	var window=new Ext.Window({
		title:'编辑',
		id:"gfrom21",
		x:200,y:100,
		width:480,
		height:325,
		autoScroll:true,
		layout:'absolute',
		items:[arr],
		modal:true,
		resizable:false
	});	
	if(ha1.items("PerFlag")==1){
		var btnSave=Ext.getCmp("btSave");
		btnSave.hide();
		Ext.Msg.alert('提示',"已审核，不能修改!");
		return;
	}
	var perProfession=Ext.getCmp('PerProfession');
	perProfession.setEditable(false);
	perProfession.listWidth=220;
	var perDegreeDR=Ext.getCmp('PerDegreeDR');
	perDegreeDR.setEditable(false);
	perDegreeDR.listWidth=220;
	var perSchoolAgeDr=Ext.getCmp('PerSchoolAgeDr');
	perSchoolAgeDr.setEditable(false);
	perSchoolAgeDr.listWidth=220;
	var perName=Ext.getCmp("PerName");
	perName.disabled=true;
	Ext.getCmp("PerName").setValue(ha1.items("PerName"));		
	var perID=Ext.getCmp("PerID");
	perID.disabled=true;
	//Ext.getCmp("PerID").setValue(ha1.items("PerID"))
	Ext.getCmp("PerID").setValue(PerID);		
	Ext.getCmp("StaDate").setValue(ha1.items("StaDate"));
	Ext.getCmp("EndDate").setValue(ha1.items("EndDate"));	
//	var professionStore=Ext.getCmp("PerProfession").getStore();
//	professionStore.load({params:{start:0,limit:1000}});
//	professionStore.on('load',function(professionStore, records, options){
//	  Ext.getCmp("PerProfession").selectText();
//		Ext.getCmp("PerProfession").setValue(ha1.items("PerProfession").replace("__","||"));
//	});
	Ext.getCmp('PerProfession').store.load({params:{start:0,limit:1000},callback:function(){
			Ext.getCmp("PerProfession").setValue(ha1.items("PerProfession").replace("__","||"));
	}});
//	var schoolAgeDrStore=Ext.getCmp("PerSchoolAgeDr").getStore();		
//	schoolAgeDrStore.load({params:{start:0,limit:100}});
//	schoolAgeDrStore.on('load',function(Store,records,options){
//		Ext.getCmp("PerSchoolAgeDr").selectText();
//		Ext.getCmp("PerSchoolAgeDr").setValue(ha1.items("PerSchoolAgeDr").replace("__","||"));
//	});	
	Ext.getCmp('PerSchoolAgeDr').store.load({params:{start:0,limit:100},callback:function(){
			Ext.getCmp("PerSchoolAgeDr").setValue(ha1.items("PerSchoolAgeDr").replace("__","||"));
	}});
//	var degreeStore=Ext.getCmp("PerDegreeDR").getStore();
//	//Ext.getCmp("PerDegreeDR").hiddenName='combo';
//	degreeStore.load({params:{start:0,limit:100}});
//	degreeStore.on('load',function(degreeStore,records,options){
//		Ext.getCmp("PerDegreeDR").selectText();
//		Ext.getCmp("PerDegreeDR").setValue(ha1.items("PerDegreeDR").replace("__","||"));
//	});
	Ext.getCmp('PerDegreeDR').store.load({params:{start:0,limit:100},callback:function(){
		Ext.getCmp("PerDegreeDR").setValue(ha1.items("PerDegreeDR").replace("__","||"));	
	}})
	var personGraduateSch=Ext.getCmp('PerGraduateSchool');
	personGraduateSch.triggerAction='all';
	personGraduateSch.setEditable(false);
	personGraduateSch.selectByValue();
	personGraduateSch.pageSize=1000;
//	var perGradSchStore=Ext.getCmp('PerGraduateSchool').getStore();
//	perGradSchStore.load({
//		params:{start:0,limit:5000}
//	});
//	perGradSchStore.on('load',function(perGradSchStore,records,options){
//		Ext.getCmp("PerGraduateSchool").selectText();
//		Ext.getCmp("PerGraduateSchool").setValue(ha1.items("PerGraduateSchool").replace("__","||"));	
//	})
	personGraduateSch.store.load({params:{start:0,limit:5000},callback:function(){
			Ext.getCmp("PerGraduateSchool").setValue(ha1.items("PerGraduateSchool").replace("__","||"));	
	}})
	Ext.getCmp("PerSchoolAgeNo").setValue(ha1.items("PerSchoolAgeNo"));
	Ext.getCmp("PerDegreeNo").setValue(ha1.items("PerDegreeNo"));
	
	Ext.getCmp("PerHeadShip").setValue(ha1.items("PerHeadShip"));
	Ext.getCmp("PerReferences").setValue(ha1.items("PerReferences"));
	window.show();
	var edit1="1";
	var btnSave=Ext.getCmp("btSave");
	btnSave.setIcon('../images/uiimages/reload.png');
	btnSave.setText("更新");
	btnSave.on("click",function(){SureCheck(Par,edit1);SchQual();});	
}
function SchQual(parr)
	{
		var mygrid = Ext.getCmp("mygrid"); 
		//mygrid.viewConfig=true;
		mygrid.getStore().addListener('load',handleGridLoadEvent);
		mygrid.store.load({
			params : {
				start : 0,
				limit : 30
			}
		});				
	}
	//显示审核标识
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

function addNew()
{
	var getVal=document.getElementById('getVal');
	var ret=cspRunServerMethod(getVal.value,RowId);
	var ha = new Hashtable();
  var tm=ret.split('^')
	sethashvalue(ha,tm);
	var a = cspRunServerMethod(pdata1, "", "DHCNURLearningAdd", "", "");
	arr = eval(a);
	var window= new Ext.Window({
		title : '添加学习经历',
		id : "gform2",
		x:200,y:100,
		width : 480,
		height : 325,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [arr],
		modal:true,
		resizable:false
	});	
	
	var perProfession=Ext.getCmp('PerProfession');
	perProfession.setEditable(false);
	perProfession.listWidth=220;
	var perDegreeDR=Ext.getCmp('PerDegreeDR');
	perDegreeDR.setEditable(false);
	perDegreeDR.listWidth=220;
	var perSchoolAgeDr=Ext.getCmp('PerSchoolAgeDr');
	perSchoolAgeDr.setEditable(false);
	perSchoolAgeDr.listWidth=220;
	var perName=Ext.getCmp("PerName");
	perName.disabled=true;
	Ext.getCmp("PerName").setValue(ha.items("PerName"))
			
	var perID=Ext.getCmp("PerID");
	perID.disabled=true;
	//Ext.getCmp("PerID").setValue(ha.items("PerID"))
	Ext.getCmp("PerID").setValue(PerID);
	var personGraduateSch=Ext.getCmp('PerGraduateSchool');
	personGraduateSch.triggerAction='all';
	personGraduateSch.setEditable(false);
	personGraduateSch.selectByValue();
	personGraduateSch.pageSize=1000;
	var perGradSchStore=Ext.getCmp('PerGraduateSchool').getStore();
	perGradSchStore.load({
		params:{start:0,limit:5000}
	});
	window.show();
	var edit1="0";
	var btnSave=Ext.getCmp("btSave");
	btnSave.setIcon('../images/uiimages/filesave.png');
	var par=RowId+"__"+"";
	btnSave.on("click",function(){SureCheck(par,edit1);SchQual();});	

}
function SureCheck(par,edit1)
{
	var PerName=Ext.getCmp("PerName").getValue(); //姓名
	var PerID=Ext.getCmp("PerID").getValue(); //工号
	var StaDate=Ext.getCmp("StaDate").getValue(); //开始时间
	if(StaDate==""){
		Ext.Msg.alert('提示',"请选择开始日期！");
		return;
	}else{
		if(StaDate instanceof Date){
			StaDate=StaDate.format('Y-m-d');
		}
	}
	var EndDate=Ext.getCmp("EndDate").getValue(); //结束时间
	if(EndDate==""){
		Ext.Msg.alert('提示',"请选择结束日期！");
		return;
	}else{
		if(EndDate instanceof Date){
			EndDate=EndDate.format('Y-m-d');
		}
	}
	if(StaDate>EndDate){
		alert("开始日期不能大于结束日期！");
		return;
	}
	//var PerProfession=Ext.getCmp("PerProfession").getValue(); //专业
	var PerProfession=Ext.getCmp("PerProfession").getValue();
	if(PerProfession==""){Ext.Msg.alert('提示',"请选择所学专业！");return;}
	if(PerProfession){
		PerProfession=PerProfession.replace("||","__");
	}
	var PerSchoolAgeDr=Ext.getCmp("PerSchoolAgeDr").getValue(); //学历
	if(PerSchoolAgeDr==""){Ext.Msg.alert('提示',"请选择学历！");return;}
	if(PerSchoolAgeDr){
		PerSchoolAgeDr=PerSchoolAgeDr.replace("||","__");
	}
	var PerSchoolAgeNo=Ext.getCmp("PerSchoolAgeNo").getValue(); //学历证书号
	var PerDegreeDR=Ext.getCmp("PerDegreeDR").getValue(); //学位
	if(PerDegreeDR==""){Ext.Msg.alert('提示',"请选择学位！");return;}
	if(PerDegreeDR){
		PerDegreeDR=PerDegreeDR.replace("||","__");
	}
	var PerDegreeNo=Ext.getCmp("PerDegreeNo").getValue(); //学位证书号
	
	var PerGraduateSchool=Ext.getCmp("PerGraduateSchool").getValue(); //毕业学校
	if(PerGraduateSchool==""){Ext.Msg.alert('提示',"请填写毕业学校！");return;}
	else{PerGraduateSchool=PerGraduateSchool.replace("||","__");}
	var PerHeadShip=Ext.getCmp("PerHeadShip").getValue(); //担任职务
	var PerReferences=Ext.getCmp("PerReferences").getValue(); //证明人	
	var parr="raw|"+par+"^PerName|"+PerName+"^PerID|"+PerID+"^StaDate|"+StaDate+"^EndDate|"+EndDate+"^PerProfession|"+PerProfession+"^PerSchoolAgeDr|"+PerSchoolAgeDr+"^PerSchoolAgeNo|"+PerSchoolAgeNo+"^PerDegreeDR|"+PerDegreeDR+"^PerDegreeNo|"+PerDegreeNo+"^PerGraduateSchool|"+PerGraduateSchool+"^PerHeadShip|"+PerHeadShip+"^PerReferences|"+PerReferences;
	var Save = document.getElementById('Save');
	var a=cspRunServerMethod(Save.value,parr);
	if(edit1=="0"){
		var gform2=Ext.getCmp("gform2");
		gform2.close();
	}
	else if(edit1=="1"){
		var gfrom21=Ext.getCmp("gfrom21");
		gfrom21.close();
	}
	
}