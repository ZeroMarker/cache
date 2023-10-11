var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-2;
var Nurse = new Ext.form.ComboBox({
	name:'Nurse',
	id:'Nurse',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'nursename',
				'mapping':'nursename'
			}, {
				'name':'nurdr',
				'mapping':'nurdr'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurCareTeamBuild',
			methodName:'SchLarLocNurHead',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:160,
	//height:20,
	width:127,
	xtype:'combo',
	displayField:'nursename',
	valueField:'nurdr',
	hideTrigger:false,
	queryParam:'nuser',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:10,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var locTyp=new Ext.form.ComboBox({
	name:'LocTyp',
	id:'LocTyp',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'LocCode',
				'mapping':'LocCode'
			},{
				'name':'LocDes',
				'mapping':'LocDes'
			},{
				'name':'rw',
				'name':'rw'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurCareTeamBuild',
			methodName:'SchLargeLocList',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:'150',
	//height:18,
	width:150,
	xtype:'combo',
	displayField:'LocDes',
	valueField:'LocCode',
	hideTrigger:false,
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:10,
	typeAhead:true,
	typeAheadDelay:1000,
	//editable:false,
	loadingText:'Searching...'
});
function BodyLoadHandler(){
	//setsize("mygridpl","gform","mygrid",0);
	var gridPl = Ext.getCmp('mygridpl');
	gridPl.setWidth(Width);
	gridPl.setHeight(Height);
	var mygrid=Ext.getCmp('mygrid');
	var tobar=mygrid.getTopToolbar();
	tobar.hide();
	var tbar=new Ext.Toolbar({});
	//tbar.addItem('-');
	tbar.addItem('-','大科护士长',Nurse);
	tbar.addItem('-','大科',locTyp);
	tbar.addItem('-');
	tbar.addButton({
		id:'addBtn',
		text:'关联',
		icon:'../images/uiimages/reload2.png',
		handler:function(){LarNurForLoc();}	
	});
	tbar.addItem('-');
	tbar.addButton({
		id:'delBtn',
		text:'删除',
		icon:'../images/uiimages/edit_remove.png',
		handler:function(){delItem();}
	});
	
	mygrid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	tbar.render(mygrid.tbar);
	bbar2.render(mygrid.bbar);
	tbar.doLayout();
	schRec();
	var len = mygrid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(mygrid.getColumnModel().getDataIndex(i) == 'rw'){
			mygrid.getColumnModel().setHidden(i,true);
		}
  }
}
function delItem()
{
	var mygrid=Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	//alert(rw);
	Ext.MessageBox.confirm("系统提示","确认删除吗？",function(btn,txt){
    if(btn=="yes"){
      var delItem=document.getElementById('delItem');
			var flag=cspRunServerMethod(delItem.value,rw);
			if(flag){Ext.MessageBox.alert("系统提示","删除成功！");}
			schRec();
    }else if(btn=="no"){
        Ext.MessageBox.alert("系统提示","你放弃了删除操作！");
        schRec();
    }
  });

}
function LarNurForLoc()
{
	var nurseHead=Ext.getCmp('Nurse').getValue();
	if(!nurseHead){Ext.Msg.alert('提示','请选择大科护士长后关联!');return;}
	var nurseLoc=Ext.getCmp('LocTyp').getValue();
	if(!nurseLoc){Ext.Msg.alert('提示','请选择大科后关联！');return;}
	//alert(nurseLoc)
	var rw=""
	var parr="nurseHead|"+nurseHead+"^nurseLoc|"+nurseLoc+"^rw|"+rw
	var isRet = tkMakeServerCall('DHCMGNUR.DHCMgNurLarNurForLoc','IsExistRec',parr);
	if(isRet==1){
		Ext.Msg.alert('提示','请勿重复添加！');
		return;
	}
	var Save=document.getElementById('Save');
	var ret=cspRunServerMethod(Save.value,parr)
	schRec();
}
function schRec()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({
		params:{
			start:0,
			limit:30	
		}
	})
}