var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-2;
function BodyLoadHandler() {
	//setsize("mygridpl", "gform", "mygrid",0);
	var gridPl = Ext.getCmp('mygridpl');
	gridPl.setWidth(Width);
	gridPl.setHeight(Height);
	var mygrid=Ext.getCmp('mygrid');
	//mygrid.getColumnModel().setHidden(2,true)
	mygrid.getTopToolbar().hide();
	var tbar=new Ext.Toolbar({});
	tbar.addItem('-');
	tbar.addButton({
		id:'newBtn',
		text:'增加',
		icon:'../images/uiimages/edit_add.png',
		handler:function(){funNewRecord();}
	});
	tbar.addItem('-');
	tbar.addButton({
		id:'SaveBtn',
		text:'保存',
		icon:'../images/uiimages/filesave.png',
		handler:function(){funSave();}
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
		//hidden:true,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(mygrid.bbar);
	tbar.render(mygrid.tbar);
	tbar.doLayout();
	schGrid();
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
	if(rw==undefined){
		Ext.Msg.alert('提示','请先保存后再删除！');
		return;
	}
	Ext.MessageBox.confirm("系统提示","确认删除吗？",function(btn,txt){
    if(btn=="yes"){
      var delItem=document.getElementById('delItem');
			var flag=cspRunServerMethod(delItem.value,rw);
			//alert(flag)
			if(flag&&flag!="exist"){Ext.MessageBox.alert("系统提示","删除成功！");}
			if(flag=="exist"){
				Ext.Msg.alert('提示','已经添加所有，禁止删除！');

			}
			schGrid();
    }else if(btn=="no"){
      Ext.MessageBox.alert("系统提示","你放弃了删除操作！");
      schGrid();
    }
  });
}
function funSave()
{
	var rw="";
	var mygrid=Ext.getCmp('mygrid');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示','请选择需要保存的行！');
		return;
	}	
	var locCode=rowObj[0].get('LocCode');
	//alert(locCode)
	if(locCode==undefined){Ext.Msg.alert("提示","请输入有效代码值！");return false;}
	else{
		var reg=/^[A-Za-z0-9]+$/;
		if(!reg.test(locCode))
		{
			Ext.Msg.alert('提示',"代码值由数字和26个英文字母组成");
			return;
		}
	}
	var locDes=rowObj[0].get('LocDes');
	if((locDes==undefined)||(!locDes)){Ext.Msg.alert("提示","请输入有效描述值！");return;}
	rw=rowObj[0].get('rw');
	if(rw==undefined){rw=""}
	var parr="locCode|"+locCode+"^locDes|"+locDes+"^rw|"+rw;
	//alert(parr)
	var IsExist=document.getElementById('IsExist');
	//var flag=cspRunServerMethod(IsExist.value,locCode);
	var flag=cspRunServerMethod(IsExist.value,parr);
	//alert(flag)
	//return;
	if(flag==0){Ext.Msg.alert('提示','此代码已经存在，请修改代码后重新保存！');return;}
	var retMod=tkMakeServerCall('DHCMGNUR.MgNurLargeLoc','Modify',parr);
	//alert(retMod)
	if(retMod==1){
		Ext.Msg.alert('提示','此代码已经关联病区或者关联大科护士长，请确认！');
		return;	
	}
	//return;
	var Save=document.getElementById('Save');
	var ret=cspRunServerMethod(Save.value,parr);
	//alert(ret)
	schGrid();
}
function schGrid()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({
		params:{
			start:0,
			limit:30	
		}
	})
	mygrid.store.sort('rw','asc');
}
//新建
function funNewRecord()
{
	var grid=Ext.getCmp('mygrid');
	var Plant=Ext.data.Record.create([]);
  var count=grid.store.getCount(); 
  var r=new Plant(); 
  grid.store.commitChanges(); 
  grid.store.insert(count,r); 
  return;
}