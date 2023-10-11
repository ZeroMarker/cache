var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-2;
var secgrp=new Ext.form.ComboBox({
	name:'secgrp',
	id:'secgrp',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'SecGrpCode',
				'mapping':'SecGrpCode'
			}, {
				'name':'SecGrpDesc',
				'mapping':'SecGrpDesc'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurSecGrpComm',
			methodName:'SearchNurSecGrp',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:220,
	//height:20,
	width:127,
	xtype:'combo',
	displayField:'SecGrpDesc',
	valueField:'SecGrpCode',
	hideTrigger:false,
	queryParam:'query',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:10,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var HISSecGrp=new Ext.form.ComboBox({
	name:'HISSecGrp',
	id:'HISSecGrp',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'HISSGrpCode',
				'mapping':'HISSGrpCode'
			}, {
				'name':'HISSGrpDesc',
				'mapping':'HISSGrpDesc'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurSecGrpComm',
			methodName:'SchSecGrpForHIS',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:220,
	//height:20,
	width:127,
	xtype:'combo',
	displayField:'HISSGrpDesc',
	valueField:'HISSGrpCode',
	hideTrigger:false,
	queryParam:'query',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:10,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
function BodyLoadHandler()
{
	//setsize("mygridpl","gform","mygrid",0);
	var gridPl=Ext.getCmp('mygridpl');
	gridPl.setWidth(Width);
	gridPl.setHeight(Height);
	var mygrid=Ext.getCmp('mygrid');
	mygrid.getTopToolbar().hide();
	var tobar=new Ext.Toolbar({});
	tobar.addItem('-','HIS安全组',HISSecGrp);
	tobar.addItem('-','安全组',secgrp);
	tobar.addItem('-')
	tobar.addButton({
		id:'addBtn',
		text:'关联',
		icon:'../images/uiimages/reload2.png',
		handler:function(){var rowId=""; Save(rowId);}
	});
	tobar.addItem('-');
	tobar.addButton({
		text:'删除',
		id:'delItem',
		icon:'../images/uiimages/edit_remove.png',
		handler:function(){delRec();}	
	});
	tobar.render(mygrid.tbar);
	tobar.doLayout();
	HISSecGrp.store.on("beforeLoad",function(){
    var pward=HISSecGrp.lastQuery;
    //alert(pward)
    //var wardrw=Ext.getCmp('HISSecGrp').getValue();
    HISSecGrp.store.baseParams.typ=pward;
  });
  schList();
  var len = mygrid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(mygrid.getColumnModel().getDataIndex(i) == 'rw'){
			mygrid.getColumnModel().setHidden(i,true);
		}
  }
}
function Save(str)
{
	//var IsExist=document.getElementById('IsExist');
	//alert(IsExist)
	
	if(!HISSecGrp.getValue()){
		Ext.Msg.alert('提示','HIS安全组不能为空！');
		return;
	}
	if(!secgrp.getValue()){
		Ext.Msg.alert('提示','安全组不能为空！');
		return;
	}
	//var existFlag=cspRunServerMethod(IsExist.value,);
	var IsExist=tkMakeServerCall("DHCMGNUR.MgNurSecGrpForHIS","IsExist",HISSecGrp.getValue(),secgrp.getValue());
	//alert(IsExist)
	if(IsExist=="1"){
		Ext.Msg.alert('提示','不能重复添加！');
		return;
	}
	var parr="HisSecGrpCode|"+HISSecGrp.getValue()+"^HisSecGrpDesc|"+HISSecGrp.getRawValue()+"^MgSecGrpCode|"+secgrp.getValue()+"^MgSecGrpDesc|"+secgrp.getRawValue()+"^rw|"+str;
	var Save=document.getElementById('Save');
	var ret=cspRunServerMethod(Save.value,parr);
	//alert(ret)
	if(ret){
		Ext.Msg.alert('提示','关联成功！');
	}
	schList();
}
function schList()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({
		params:{
			start:0,
			limit:20	
		}	
	});
}
function delRec()
{
	var mygrid=Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0) {
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	//alert(rw)
	if (confirm('确定删除选中的项？')) {
			var ret=tkMakeServerCall("DHCMGNUR.MgNurSecGrpForHIS","DelItem",rw)
		//	var delItem=document.getElementById('DelItem');
		//	var ret=cspRunServerMethod(delItem.value,rw);
		//	alert(ret)
			Ext.Msg.alert('提示',ret);
			schList();
	}		
}