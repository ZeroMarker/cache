/**
 * @author Administrator
 */

var ret="";
var checkret="";
var comboret="";
var pg=0;
Ext.onReady(
   function() {
      if (pg>0) return ;
      new Ext.form.FormPanel({
      height:600,
      width: 800,
      id:'gform',
      autoScroll:true,
      layout: 'fit',
      renderTo: Ext.getBody()
   });
   pg++;
  
   var fheight=document.body.offsetHeight;
   var fwidth=document.body.offsetWidth;
   var fm=Ext.getCmp('gform');
   fm.setHeight(fheight);
   fm.setWidth(fwidth);
   BodyLoadHandler();
});

var modelgrid = new Ext.grid.EditorGridPanel({
		x:0,
		y:0,
		id : 'PDAupSet',
		name : 'PDAupSet',
    title: 'Pda升级设置',
    clicksToEdit : 1,
    stripeRows : true,
    frame: false,
	width: document.body.clientWidth-3,
    height: document.body.clientHeight-3,
		tbar : [{
					id : 'mygridbut1',
					text : '保存',
					handler : savegrid
		},{
			id : 'mygridbut2',
					text : '全部保存',
					handler : allSave
		}],
		store: new Ext.data.JsonStore({
					data : [],
					fields : ['WardId', 'WardDesc',{name:'IfShow',type:'bool'},'NewVersion','id']
	  }),
      colModel : new Ext.grid.ColumnModel({
		columns : [{
						header : '病区ID',
						dataIndex : 'WardId',
						width : 150
					
		}, {
						header : '病区名称',
						dataIndex : 'WardDesc',
						width : 250
		}, {
						type: 'bool',
						header : '是否升级',
						dataIndex : 'IfShow',
						width : 66,
						editor : new Ext.grid.GridEditor(new Ext.form.Checkbox(
								{
									allowBlank : true
								})),
						renderer: function(value){
							if (value==1) return "是";
							else return "否";
						}
		}, {
						header : '新版本号',
						dataIndex : 'NewVersion',
						width : 180,
						editor : new Ext.grid.GridEditor(new Ext.form.TextField(
								{
									readOnly : false
								}))
			 },{
			 	    header:'id',
			 	    dataIndex:'id',
			 	    hidden:true,
			 	    width: 50

			}],
			rows : [],
			defaultSortable : true
		}),
		enableColumnMove : false,
		viewConfig : {
			forceFit : false
		},
		plugins : [new Ext.ux.plugins.GroupHeaderGrid()],
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : false
				})
    });
    
 
function BodyLoadHandler(){
	 var fm = Ext.getCmp('gform');
	 fm.add(modelgrid);
	 //setsize("PDAupSetpl","gform","PDAupSet");
	 //var butadd=Ext.getCmp('PDAupSetbut1');
   //butadd.on("click",additm);
	 //var butsave=Ext.getCmp('PDAupSetbut2');
	 //butsave.setText("保存");
	 var grid=Ext.getCmp('PDAupSet');
   var tobar=grid.getTopToolbar();	
   tobar.addSpacer();
	 tobar.addItem({
		xtype: 'checkbox',
		id: 'AllWardFlag'
	 },'全院升级');
	 tobar.addSpacer();
	 //tobar.addText("现用版本号:")
	 //tobar.addItem(({xtype:'textfield',id:'Usingversion',value:uV}));
	 tobar.addText("新版本号:")
	 tobar.addItem(new Ext.form.TextField({id:'Newversion'}));
	 tobar.addSpacer();
	 tobar.addItem('-');
		tobar.addButton(
		  {
			   //className: 'allUpbut',
			   icon:'../images/uiimages/pencil.png',
			   text: "版本修改",
			   id:'allUpbut'			   
		  }	
		); 
		tobar.addItem('-');
		tobar.addButton(
		  {
			  // className: 'find',
			  icon:'../images/uiimages/search.png',
			   text: "查询",
			   id:'find'			   
		  }	
		); 
		tobar.addItem('-');
		tobar.addButton(
		  {
					id : 'mygridbut12',
					 icon:'../images/uiimages/filesave.png',
					text : '保存',
					handler : savegrid
		});
		tobar.addItem('-');
		tobar.addButton({
			id : 'mygridbut3',
			 icon:'../images/uiimages/saveapplycard.png',
			text : '全部保存',
			handler : allSave
		});
		tobar.addItem('-');
		var but1 = Ext.getCmp('mygridbut1');
		but1.hide();
		var but2 = Ext.getCmp('mygridbut2');
		but2.hide();
		var find=Ext.getCmp('find');
		find.on('click',setgrid);
		var allf=Ext.getCmp('AllWardFlag');
		allf.on('check',selectAll);
		var allupbut=Ext.getCmp('allUpbut');
		allupbut.on('click',allUp);
    setgrid(); 
}

function selectAll(){
	//alert("111");
	var allWardFlag=Ext.getCmp("AllWardFlag").getValue();
	var grid=Ext.getCmp("PDAupSet");
	var store=grid.getStore();
	var rowcount = grid.getStore().getCount();
	//alert(rowcount);
	if(allWardFlag==true){
		allWardFlag="Y";
	}else{
		allWardFlag="N";
	}
	if(allWardFlag=="N"){
	  for(var i=0; i<rowcount; i++)
	  {  
	  	 if(store.getAt(i).data.IfShow==true){
          store.getAt(i).set('IfShow',0);
       }
       //if(store.getAt(i).data.NewVersion!=nVersion){
          //store.getAt(i).set('NewVersion',nVersion);
       //}
    }
  }
  else{
  	for(var i=0;i<rowcount;i++)
  	{  
  		 if(store.getAt(i).data.IfShow!=true){
           store.getAt(i).set('IfShow',1);
       }
       //if(store.getAt(i).data.NewVersion!=nVersion){
          //store.getAt(i).set('NewVersion',nVersion);
       //}
    }
  }	
	
}

function allSave(){
	  var grid=Ext.getCmp("PDAupSet");
		var store = grid.getStore();
		var rowCount = store.getCount(); //记录数
		var cm = grid.getColumnModel();
		var colCount = cm.getColumnCount(); 
		var list = [];
		for (var i = 0; i < store.getCount(); i++) {
			list.push(store.getAt(i).data);
		}
    var allSave=document.getElementById('Save');
		for (var i = 0; i < list.length; i++) {
		  var obj=list[i];
		  var str="";
	    for (var p in obj) {
				      //var aa = formatDate(obj[p]);
				      if (p=="") continue;
				      if(p=="IfShow") {
				 	        if(obj[p]==true){
				 	  	        obj[p]="Y";
				 	  	    }else{ 
				    	    obj[p]="N";
				          }
				      }
			        str = str + p + "|" + obj[p] + '^';	
			}		
			if (str!="")
			{
			    var a=cspRunServerMethod(allSave.value,str);
			}
		  
		}
		alert("保存成功");
		setgrid();	
}
	

function allUp()
{
	var nVersion=Ext.getCmp('Newversion').getValue();	
  var grid=Ext.getCmp("PDAupSet");
	var store=grid.getStore();
	var rowcount = grid.getStore().getCount();
	for(var i=0; i<rowcount; i++)
	{  

       if(store.getAt(i).data.NewVersion!=nVersion){
          store.getAt(i).set('NewVersion',nVersion);
       }
  }
}

var arrgrid=new Array();
function setgrid()
{
	var grid = Ext.getCmp("PDAupSet");
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();	
	var a = cspRunServerMethod(GetQueryData.value, "Nur.PdaUpgradeSet:GetPdaUpSet", "parr$1", "AddRec");
  grid.store.loadData(arrgrid);  
}

function savegrid()
	{
	 	var grid = Ext.getCmp("PDAupSet");
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
	  var Save=document.getElementById('Save');		
	  for (var i = 0; i < list.length; i++) {
			var obj=list[i];
			var str="";
			var CareDate="";
			var CareTime="";
	    for (var p in obj) {
				 //var aa = formatDate(obj[p]);
				 if (p=="") continue;
				 if(p=="IfShow") {
				 	  //alert(obj[p]);
				 	  if(obj[p]==true){
				 	  	 obj[p]="Y";
				 	  	 //alert(obj[p]+"1");
				 	  }else{ 
				    	 obj[p]="N";
				    }
				 }
				 str = str + p + "|" + obj[p] + '^';
			}
			//alert(str);
			if (str!="")
			{
					var a=cspRunServerMethod(Save.value,str);
					setgrid();
					if (a!=0)
					{
					  	//alert(a);
					  	alert("保存成功");
					  	return;
					}
			}
		}	
	} 
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	arrgrid.push(obj);
	//debugger;
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}


function formatDate(value){
	  // alert(value);
	  try {
	  	 return value ? value.dateFormat('Y-m-d') : '';

	  }catch(err){  //err.description 
	  	return value;
	  }
     }      
function enterOrTabDate(param){
	alert(param);
}
function additm(){//alert(123)        
   	   //  debugger;
    var grid=Ext.getCmp('PDAupSet');
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