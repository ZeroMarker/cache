/**
 * @author Administrator
 */
var Width=document.body.clientWidth+2;
var Height=document.body.clientHeight;
//var grid;
var arrgrid = new Array();
function SizeChange(changewidth)
{
  var fheight=document.body.offsetHeight;
	var fwidth=document.body.offsetWidth;
	var fm=Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth+changewidth);
  setsize("mygridpl","gform","mygrid");
}

function BodyLoadHandler() 
{
	var mygridpl = Ext.getCmp('mygridpl');
	mygridpl.setWidth(Width);
	mygridpl.setHeight(Height);
	var grid = Ext.getCmp('mygrid');
	//grid.colModel.setHidden(6,true);
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.hide();
	var tbar1 = new Ext.Toolbar();
	tbar1.addItem('-');
	tbar1.addButton({
		id:'addbtn',
		handler:additm,
		text:'增加',
		icon:'../images/uiimages/edit_add.png'
	});
	tbar1.addItem('-');
	tbar1.addButton({
		id:'savebtn',
		text:'保存',
		handler:save,
		icon:'../images/uiimages/filesave.png'
	});
	tbar1.addItem('-')
	
	tbar1.addButton({
		//className : 'new-topic-button',
		text : "删除",
		handler : typdelete,
		id : 'mygridDelete',
		icon:'../images/uiimages/edit_remove.png'
	});
	
	grid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	tbar1.render(grid.tbar);
	bbar2.render(grid.bbar);
	tobar.doLayout();
//	var but1=Ext.getCmp("mygridbut1");
//	but1.on('click',additm);
//	var but = Ext.getCmp("mygridbut2");
//	but.setText("保存");
//	but.on('click',save);
	setgrid();
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
  }
	
}
function additm()
{
	   var grid=Ext.getCmp('mygrid');
	var Plant = Ext.data.Record.create([
           // the "name" below matches the tag name to read, except "availDate"
           // which is mapped to the tag "availability"

      ]);
   	            var count = grid.store.getCount(); 
                var r = new Plant(); 
                grid.store.commitChanges(); 
                grid.store.insert(count,r); 
                return;

}
function save()
{
	var grid = Ext.getCmp("mygrid");
    var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); 
 	  var list = [];
		//for (var i = 0; i < store.getCount(); i++) {
		//	list.push(store.getAt(i).data);
		//	//debugger;
		//}
		var rowObj = grid.getSelectionModel().getSelections();
			var len = rowObj.length;
			for (var r = 0;r < len; r++) {
			list.push(rowObj[r].data);
		}
        var SaveQt=document.getElementById('Save');
	    var rw="";
 	    for (var i = 0; i < list.length; i++) {
			  var obj=list[i];
			  var str="";
			  var CareDate="";
			  var CareTime="";
              for (var p in obj) {
			  	var aa = formatDate(obj[p]);
				if (p=="") continue;
				//str = str + p + "|" + obj[p] + '^';
			  	if (aa == "") 
				{
			    	str = str + p + "|" + obj[p] + '^';
			    }else
				{
				  	str = str + p + "|" + aa + '^';	
				}
				rw=obj["rw"];
			}
			if (str!="")
			{
			    //alert(str);
				var ret=tkMakeServerCall("DHCMGNUR.Mould","getMSort",str);
				if(ret!=""){
					alert(ret+"设定的显示顺序已存在,请重新填写!");
					return;
				}
				var a=cspRunServerMethod(SaveQt.value,str);
				if (a!=0)
			  {
			  	alert(a);
			  	return;
			  }
			}
		}
		setgrid();
}
function setgrid()
{	
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.load({params:{start:0, limit:30}});
}
function AddRec(str)
{
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
}
function typdelete() 
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	var QtDelete = document.getElementById('QtDelete');
	if (QtDelete){
   		var id=rowObj[0].get("rw");
   		if(id==undefined||id==""){Ext.Msg.alert('提示','请选择有效记录！');return;}
		if (confirm('确定删除选中的项？')) {
				var ee = cspRunServerMethod(QtDelete.value, id);
				if (ee != "0") {
					alert(ee);
					setgrid();
					return;
		        }		
		}
 	}
	setgrid();
};