var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-1;
//HIS护理单元
var comboboxDep=new Ext.form.ComboBox({
	name:'comboboxDep',
	id:'comboboxDep',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
					'name':'LocDes',
					'mapping':'LocDes'
			}, {
					'name':'LocDr',
					'mapping':'LocDr'
			}]
		}),
		baseParams:{
			//
			//（2015-02-15确定修改）此处需要做适当修改(确定后修改):界面模板列表关联公式改成：web.DHCMgNurSysSetComm:SchMgLocCode:ward:LocDes:LocDr
			//修改前：web.DHCMgNurPerHRComm:FindWardItem:ward:LocDes:LocDr
			//className:'web.DHCMgNurPerHRComm',
			//methodName:'FindWardItem',
			//methodName:'FindWardCode',
			className:'web.DHCMgNurSysSetComm',
			//methodName:'SchMgLocCode',
			methodName:'FindWardCode',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:'220',
	//height:18,
	width:150,
	xtype:'combo',
	displayField:'LocDes',
	valueField:'LocDr',
	hideTrigger:false,
	//queryParam:'typ',
	queryParam:'wardid',
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
	editable:false,
	loadingText:'Searching...'
});

function BodyLoadHandler(){
	var grid1Pl = Ext.getCmp('mygrid1pl');
	grid1Pl.setPosition(0,0);
	grid1Pl.setWidth(480);
	grid1Pl.setHeight(Height);
	var grid2Pl = Ext.getCmp('mygrid2pl');
	grid2Pl.setPosition(480,0);
	grid2Pl.setWidth(480);
	grid2Pl.setHeight(Height);
	var mygrid1=Ext.getCmp('mygrid1');
	var tobarOld1=mygrid1.getTopToolbar(); 
	tobarOld1.hide();
	var mygrid2=Ext.getCmp('mygrid2');
	var bbarOld1 = mygrid1.getBottomToolbar ();
	bbarOld1.hide();
	var tobar1=new Ext.Toolbar({});
	var tobarOld2=mygrid2.getTopToolbar();
	tobarOld2.hide();
	var tobar2=new Ext.Toolbar({});
	var bbarOld2=mygrid2.getBottomToolbar();
	bbarOld2.hide();
//	var mygrid1pl=Ext.getCmp('mygrid1pl');
//	mygrid1pl.setHeight(document.body.offsetHeight);
//	var mygrid2pl=Ext.getCmp('mygrid2pl');
//	mygrid2pl.setHeight(document.body.offsetHeight);
	var bbar1 = new Ext.PagingToolbar({
		pageSize:20,
		store:mygrid1.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar1.render(mygrid1.bbar);
		var bbar2 = new Ext.PagingToolbar({
		pageSize:20,
		store:mygrid2.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(mygrid2.bbar);
	tobar1.addButton({
		id:'btnSure',
		text:'保存',
		icon:'../images/uiimages/filesave.png',
		handler:function(){makeSure();}	
	})
	tobar1.addItem("-","科室",comboboxDep);
	tobar1.addItem('-');
	tobar1.addButton({
		id:'btnSearch',
		text:'查询',
		icon:'../images/uiimages/search.png',
		handler:function(){var mygrid=Ext.getCmp('mygrid1');schGrid1(mygrid)}
	});
	tobar1.render(mygrid1.tbar);
	tobar1.doLayout();
	
	tobar2.add('-','类型',locTyp);
	tobar2.addItem('-');
	tobar2.addButton({
		id:'delItem',
		text:'删除',
		icon:'../images/uiimages/edit_remove.png',
		handler:function(){delItem();}	
	});
	tobar2.render(mygrid2.tbar);
	tobar2.doLayout();
	comboboxDep.store.on('beforeload',function(){
  	var pward=comboboxDep.lastQuery;
  	var wardrw=Ext.getCmp('comboboxDep').getValue();
    comboboxDep.store.baseParams.wardid=pward;
  });
  schGrid1(mygrid1);
  var cmb=Ext.getCmp('LocTyp');
  //cmb.setValue('InWard');
  cmb.on('select',setgrid); 
	mygrid1.store.on('beforeload',function(){
		var comboboxDep=Ext.getCmp('comboboxDep').getValue();
		mygrid1.store.baseParams.wardid=comboboxDep;
	});
  mygrid2.store.on('beforeload',function(){
		var locTyp=Ext.getCmp('LocTyp').getValue();
		mygrid2.store.baseParams.typ=locTyp;
	});
	schGrid1(mygrid2);
	var len = mygrid1.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(mygrid1.getColumnModel().getDataIndex(i) == 'LocDr'){
			mygrid1.getColumnModel().setHidden(i,true);
		}
  }
  var len = mygrid2.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(mygrid2.getColumnModel().getDataIndex(i) == 'LocId'){
			mygrid2.getColumnModel().setHidden(i,true);
		}
  }
  
}
function setSelItem()
{
   var loctyp=Ext.getCmp('LocTyp').getValue();
   var mygrid1=Ext.getCmp('mygrid1');
   var getselloc=document.getElementById('getselloc');
   var a=cspRunServerMethod(getselloc.value,loctyp);
   mygrid1.getSelectionModel().clearSelections();
	 if (a!="")
	 {
	 	//a=89^127^
     var ha = new Hashtable();
     var arr=a.split('^');
     for (var i=0;i<arr.length;i++){
     	ha.add(arr[i],arr[i]);
     }
     var n=mygrid1.getStore().getCount();
     var store = mygrid1.store;
     var arrsel = new Array();
     for( var j=0;j<n;j++){
      var LocDr=store.getAt(j).get('LocDr');
   	  if(ha.contains(LocDr)){
    	 arrsel[j]=j;
    	}
     }
	   mygrid1.getSelectionModel().selectRows(arrsel,true);  
	 }
}
//function SchQual()
//{
//	var mygrid = Ext.getCmp("mygrid1"); 
//	mygrid.store.on('beforeLoad',function(){
//		var comboboxDep=Ext.getCmp('comboboxDep').getValue();
//		mygrid.store.baseParams.ward=comboboxDep;
//	});
//	mygrid.store.load({
//		params : {
//			start : 0,
//			limit : 20
//		}
//	});	
//}
function delItem()
{
	var grid = Ext.getCmp('mygrid2');
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {Ext.Msg.alert('提示','请选择一条记录！');return;}
	var LocId=rowObj[0].get('LocId')
	//alert(LocId)
	var DelItem=document.getElementById('DelItem');
	var locTyp=Ext.getCmp('LocTyp').getValue();
	if (confirm('确定删除选中的项？')) {
			var delId=cspRunServerMethod(DelItem.value,locTyp,LocId);
			if(delId){
				Ext.Msg.alert('提示','删除成功');
				schGrid1(grid)
			}
	}		
}
function setgrid()
{
	var cmb=Ext.getCmp('LocTyp');
	//alert(cmb.getValue());
	var mygrid=Ext.getCmp('mygrid2')
	schGrid1(mygrid);
	setSelItem()
}
//查询HIS表数据
function schGrid1(mygrid)
{
	var mygrid1=Ext.getCmp('mygrid1');
	if(mygrid==mygrid1){
		mygrid.store.on('load',function(){
       setSelItem();
    });
  }
	mygrid.store.load({
		params:{
			start : 0,
			limit : 20	
		},callback : function() {
			//if(mygrid==mygrid1){
				setSelItem();
			//}
		}
	})
}
function makeSure()
{
	var grid1 = Ext.getCmp('mygrid1');
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) {Ext.Msg.alert('提示','请选择一条记录！');return;}
  var store = grid1.store;
  var rowCount = store.getCount();
  var cm = grid1.getColumnModel();
	var colCount = cm.getColumnCount();
	var loctyp=Ext.getCmp('LocTyp').getValue();
	if(!loctyp){Ext.Msg.alert('提示','请选择大科类型！');return;}
	var list=[];
	var len=rowObj.length;
	for(var r=0;r<len;r++) {
		list.push(rowObj[r].data);
	}
	//debugger;
	var rw="";
	var str="";
	for (var i = 0; i < list.length; i++) {
		var obj=list[i];
 		rw=obj["LocDr"];
 		if(str==""){str=rw;}
 		else{str=str+"^"+rw;}
	}
	var Save=document.getElementById('Save');
	var a=cspRunServerMethod(Save.value,loctyp,str);
	SchQual1()
}
//大科护理单元查询
function SchQual1()
{
	var mygrid=Ext.getCmp('mygrid2'); 
	mygrid.store.load({
		params:{
			start:0,
			limit:20
		}
	});	
}