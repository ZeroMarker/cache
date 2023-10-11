var checktyp = new Ext.form.ComboBox({
			name : 'CheckTyp1',
			id : 'CheckTyp1',
			tabIndex : '0',
			height : 20,
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
		}
);
function BodyLoadHandler()
{ 
  setsize("mygridpl","gform","mygrid",0);
  var grid = Ext.getCmp('mygrid');
  var tobar=grid.getTopToolbar();   
  var getVal=document.getElementById('getVal');  
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
  var but=Ext.getCmp("mygridbut2");
	but.hide();	
	var mygrid = Ext.getCmp("mygrid");
	var tbar2=new Ext.Toolbar({});
	tbar2.addButton({
			text:'新建',
			handler:function(){addNew();},
			id:'addNewbtn'
			});
	tbar2.addItem("-");
	tbar2.addButton({
			text:'修改',
			id:'editBtn',
			handler:function(){editAdd();}
	});
	tbar2.addItem("-");
	tbar2.addItem("-","查询类型",checktyp);
	tbar2.addItem("-");
	tbar2.addButton(
	{
		text:"查询",
		handler:function(){SchQual(PerID);},
		id:'btnSch'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:"审核",
		id:'auditeBtn',
		handler:function(){
			editAudite();
			}
	});
	if((session['LOGON.GROUPDESC']=="护理部")||(session['LOGON.GROUPDESC']=="护理部主任")||(session['LOGON.GROUPDESC']=="Demo Group")){
		var btnAudite=Ext.getCmp('auditeBtn');
		btnAudite.show();
	}else{
			var btnAudite=Ext.getCmp('auditeBtn');
			btnAudite.hide();
	}
	tbar2.render(grid.tbar);
	tobar.doLayout();
	var contextmenu=new Ext.menu.Menu({
		id:'theContextMenu',
 		items:[{
 			text:'撤销审核',
   		iconCls:'revoke',
   		handler:function(){
    		revokeAudite();
    		SchQual();
   		}
  	}]
	});
	if((session['LOGON.GROUPDESC']=="护理部")||(session['LOGON.GROUPDESC']=="护理部主任")||(session['LOGON.GROUPDESC']=="Demo Group")){
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
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on(
   "beforeLoad",function(){
   	var chktyp=Ext.getCmp("CheckTyp1").value;
		var mygrid = Ext.getCmp("mygrid");
   	mygrid.store.baseParams.parrm=PerID;
   	mygrid.store.baseParams.rowid=RowId;
   	mygrid.store.baseParams.typ=chktyp;
   });
   SchQual(PerID);
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
			grid.getView().getCell(gridcount,0).style.backgroundImage="url('../Image/light/imgFlag1.gif')";
			grid.getView().getCell(gridcount,0).style.backgroundRepeat='no-repeat';
			grid.getView().getCell(gridcount,0).style.backgroundPosition='center';
		}else if(r.get('PerFlag')==0){
			//grid.getView().getRow(gridcount).style.backgroundColor='#FF3300';	
			//grid.getView().getCell(gridcount,0).style.backgroundColor='#FF3300';
			grid.getView().getCell(gridcount,0).style.backgroundImage="url('../Image/light/imgFlag2.gif')";
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
		alert("请选择一条记录！");
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
	var aa=cspRunServerMethod(pdata1,"","DHCNURPerRelationshipAdd","","");
	var arr=eval(aa);
	var window=new Ext.Window({
		title:'审核确认',
		id:"gfrom21",
		x:200,y:150,
		width:460,
		height:300,
		autoScroll:true,
		layout:'absolute',
		items:[arr]
	});	
	if(ha1.items("PerFlag")==1){
		//var btnSave=Ext.getCmp("btnSave");
		//btnSave.hide();
		alert("已审核，不能重复审核!");
		return;
	}	
	var perName=Ext.getCmp("PerName");
	perName.disabled=true;
	Ext.getCmp("PerName").setValue(ha1.items("PerName"));		
	var perID=Ext.getCmp("PerID");
	perID.disabled=true;
	Ext.getCmp("PerID").setValue(PerID);
	Ext.getCmp("PerRelationSelf").setValue(ha1.items("PerRelationSelf"));
	Ext.getCmp("PerMemberName").setValue(ha1.items("PerMemberName"));
	Ext.getCmp("PerMemberWorkUnit").setValue(ha1.items("PerMemberWorkUnit"));
	Ext.getCmp("PerMemberContact").setValue(ha1.items("PerMemberContact"));
	Ext.getCmp("PerMemberPosition").setValue(ha1.items("PerMemberPosition"));
	window.show();
	var btnSave=Ext.getCmp("btnSave");
	btnSave.setText("确认审核");
	btnSave.on("click",function(){VerifySure(Par);window.close();alert("审核完毕！");SchQual();});
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
		alert("请选择一条记录！");
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
	var aa=cspRunServerMethod(pdata1,"","DHCNURPerRelationshipAdd","","");
	arr=eval(aa);
	var window=new Ext.Window({
		title:'修改编辑',
		id:"gfrom21",
		x:200,y:150,
		width:460,
		height:300,
		autoScroll:true,
		layout:'absolute',
		items:[arr]
	});	
	if(ha1.items("PerFlag")==1){
		var btnSave=Ext.getCmp("btnSave");
		btnSave.hide();
		alert("已审核，不能修改!");
		return;
	}	
	var perName=Ext.getCmp("PerName");
	perName.disabled=true;
	Ext.getCmp("PerName").setValue(ha1.items("PerName"));		
	var perID=Ext.getCmp("PerID");
	perID.disabled=true;
	Ext.getCmp("PerID").setValue(PerID);
	Ext.getCmp("PerRelationSelf").setValue(ha1.items("PerRelationSelf"));
	Ext.getCmp("PerMemberName").setValue(ha1.items("PerMemberName"));
	Ext.getCmp("PerMemberWorkUnit").setValue(ha1.items("PerMemberWorkUnit"));
	Ext.getCmp("PerMemberContact").setValue(ha1.items("PerMemberContact"));
	Ext.getCmp("PerMemberPosition").setValue(ha1.items("PerMemberPosition"));
	window.show();
	var edit1="1";
	var btnSave=Ext.getCmp("btnSave");
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
	var a = cspRunServerMethod(pdata1, "", "DHCNURPerRelationshipAdd", "", "");
	arr = eval(a);
	var window= new Ext.Window({
		title : '添加家庭成员及社会关系信息',
		id : "gform2",
		x:200,y:150,
		width : 460,
		height : 300,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [arr]
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
	btnSave.on("click",function(){SureCheck(RowId,edit1);SchQual();});	

}
function SureCheck(RowId,edit1)
{
	var PerName=Ext.getCmp("PerName").getValue(); //姓名
	var PerID=Ext.getCmp("PerID").getValue(); //工号
	var PerRelationSelf=Ext.getCmp("PerRelationSelf").getValue();//与本人关系
	if(PerRelationSelf==""){alert("请填写与本人关系！");return;}
	var PerMemberName=Ext.getCmp("PerMemberName").getValue();//成员姓名  
	if(PerMemberName==""){alert("请填写成员姓名！");return;}
	var PerMemberWorkUnit=Ext.getCmp("PerMemberWorkUnit").getValue();//成员工作单位
	//if (PerMemberWorkUnit==""){alert("请填写成员工作单位！");return;}
	var PerMemberContact=Ext.getCmp("PerMemberContact").getValue();//成员联系方式
	if (PerMemberContact==""){alert("请填写成员联系方式！");return;}
	var PerMemberPosition=Ext.getCmp("PerMemberPosition").getValue();//成员职务
	//if (PerMemberPosition==""){alert("请填写成员职务！");return;}

	var parr="raw|"+RowId+"^PerName|"+PerName+"^PerID|"+PerID+"^PerRelationSelf|"+PerRelationSelf+"^PerMemberName|"+PerMemberName+"^PerMemberWorkUnit|"+PerMemberWorkUnit+"^PerMemberContact|"+PerMemberContact+"^PerMemberPosition|"+PerMemberPosition;
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