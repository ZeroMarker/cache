var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-2;
function BodyLoadHandler()
{
//	setsize("mygridpl","gform","mygrid",0);
	var grid = Ext.getCmp('mygrid');
	var gridpl=Ext.getCmp('mygridpl');
	gridpl.setWidth(Width);
	gridpl.setHeight(Height);
  var tobar=grid.getTopToolbar();
  tobar.hide();
  var tbar=new Ext.Toolbar({});
  tbar.addItem('-');
  tbar.addButton({
  	text:'增加',
  	id:'btnNew',
  	icon:'../images/uiimages/edit_add.png',
  	handler:function(){var par="";funNew(par);}	
  });
  tbar.addItem('-');
  tbar.addButton({
  	text:'保存',
  	id:'btnSave',
  	icon:'../images/uiimages/filesave.png',
  	handler:function(){funSave();}	
  })
  tbar.render(grid.tbar);
	tbar.doLayout();
	schData();
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'Par'){
			grid.getColumnModel().setHidden(i,true);
		}
  }
}
function funNew(par)
{
	var grid=Ext.getCmp('mygrid');
	var Plant=Ext.data.Record.create([]);
  var count=grid.store.getCount(); 
  var r=new Plant(); 
  grid.store.commitChanges(); 
  grid.store.insert(count,r); 
  return;
}
function funSave()
{
	var par="";
	var mygrid=Ext.getCmp('mygrid');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示','请选择需要保存的行！');
		return;
	}
	var secGrpCode=rowObj[0].get('SecGrpCode');
	if((secGrpCode==undefined)||(secGrpCode=="")){Ext.Msg.alert("提示","请输入有效代码值！");return;}
	else{
		var reg=/^[A-Za-z0-9]+$/;
		if(!reg.test(secGrpCode))
		{
			Ext.Msg.alert('提示',"代码值由数字和26个英文字母组成");
			return;
		}
	}
	var secGrpDesc=rowObj[0].get('SecGrpDesc');
	if((secGrpDesc==undefined)||(secGrpDesc=="")){Ext.Msg.alert("提示","描述不能为空！");return;}
	Par=rowObj[0].get('Par');
	if(Par==undefined){Par=""}
	var parr="secGrpCode|"+secGrpCode+"^secGrpDesc|"+secGrpDesc+"^Par|"+Par;
	//alert(parr)
	var IsExist=document.getElementById('IsExist');
	//var flag=cspRunServerMethod(IsExist.value,secGrpCode);
	var flag=cspRunServerMethod(IsExist.value,parr);
	//alert(flag)
	if(flag==1){Ext.Msg.alert('提示','此代码已经存在，请修改代码后重新保存！');return;}
	var save=document.getElementById('Save');
	//alert(save)
	var ret=cspRunServerMethod(save.value,parr);
	schData();
}
function schData()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({
		params:{
			start:0,
			limit:1000	
		}	
	})
	mygrid.store.sort('Par','asc');
}