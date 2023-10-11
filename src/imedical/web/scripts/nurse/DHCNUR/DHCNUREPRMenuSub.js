/**
 * @author Administrator
 */
var grid;
var arrgrid = new Array();
var fatherCombo=new Ext.form.ComboBox({
		name:'fatherCombo',
		id:'fatherCombo',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader:new Ext.data.JsonReader({
				root:'rows',
				totalProperty:'results',
				fields:[{
					'name':'desc',
					'mapping':'decc'
				},{
					'name':'id',
					'mapping':'id'
				}]
			}),
			baseParams:{
				className:'Nur.DHCNUREPRMenuSub',
				methodName:'getFatherId',
				type:'RecQuery'
			}
		}),
		tabIndex:'0',
		listWidth:220,
		height:18,
		width:150,
		xtype:'combo',
		displayField:'desc',
		valueField:'desc',
		hideTrigger:false,
		queryParam:'ward1',
		forceSelection:true,
		triggerAction:'all',
		minChars:1,
		pageSize:100,
		typeAhead:true,
		typeAheadDelay:1000,
		loadingText:'Searching...'
	});
var newColumnMode=new Ext.grid.ColumnModel({columns:[{header:'父节点',dataIndex:'fatherName',width:91,editor:new Ext.grid.GridEditor(fatherCombo)},{header:'描述',dataIndex:'name',width:151,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'代码',dataIndex:'code',width:79,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id', valueField:'desc',store:new Ext.data.JsonStore({data : [{desc:'node1',id:'node1'},{desc:'node2',id:'node2'},{desc:'node3',id:'node3'},{desc:'node4',id:'node4'},{desc:'node5',id:'node5'},{desc:'node6',id:'node6'},{desc:'node7',id:'node7'},{desc:'node8',id:'node8'},{desc:'node9',id:'node9'},{desc:'node10',id:'node10'},{desc:'node11',id:'node11'},{desc:'node12',id:'node12'},{desc:'node13',id:'node13'},{desc:'node14',id:'node14'},{desc:'node15',id:'node15'},{desc:'node16',id:'node16'},{desc:'node17',id:'node17'},{desc:'node18',id:'node18'},{desc:'node19',id:'node19'},{desc:'node20',id:'node20'}],fields: ['desc', 'id']}),mode:'local'}))},{header:'是否可用',dataIndex:'ifon',width:68,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id', valueField:'desc',store:new Ext.data.JsonStore({data : [{desc:'Y',id:'Y'},{desc:'N',id:'N'}],fields: ['desc', 'id']}),mode:'local'}))},{header:'顺序',dataIndex:'sort',width:68,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'fatherId',dataIndex:'fatherId',width:67,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'childsub',dataIndex:'childsub',width:70,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))}],rows:[],defaultSortable:false});
function comboLoadData(comBoBoxDepObj,className,methodName,inPut)
{
	comBoBoxDepObj.on('beforequery',function(){
	    comBoBoxDepObj.store.proxy=new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		});
		comBoBoxDepObj.store.reader =new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'desc',
				'mapping' : 'desc'
			}, {
				'name' : 'id',
				'mapping' : 'id'
			}]
		});
		comBoBoxDepObj.store.baseParams.className =className;
		comBoBoxDepObj.store.baseParams.methodName = methodName;
		comBoBoxDepObj.store.baseParams.type = 'RecQuery';
		var comboboxDepStore=comBoBoxDepObj.getStore();
	    comboboxDepStore.load({
 		params:{start:0,limit:1000}
	    });	
   });	
}
comboLoadData(fatherCombo,"Nur.DHCNUREPRMenuSub","getFatherId","");
function BodyLoadHandler() {
	    setsize("mygridpl", "gform", "mygrid");
		grid = Ext.getCmp('mygrid');
		grid.colModel=newColumnMode;
		var mydate = new Date();
		var tobar = grid.getTopToolbar();
		tobar.addButton({
			className : 'new-topic-button',
			icon:'../images/websys/delete.gif',
			text : "删除",
			handler : typdelete,
			id : 'mygridDelete'
		});
		tobar.addButton({
			className : 'new-topic-button',
			icon:'../images/uiimages/search.png',
			text : "查询",
			handler : find,
			id : 'find'
		});
		// tobar.render(grid.tbar);
		tobar.doLayout();
	var but1=Ext.getCmp("mygridbut1");
	but1.on('click',additm);
	but1.setIcon("../images/uiimages/edit_add.png");
	var but = Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.on('click',save);
	but.setIcon("../images/uiimages/filesave.png");
	grid.getBottomToolbar().hide();
	find();
    fatherCombo.on('change',setfatherId);
	grid.on('beforeedit',beforeEditFnchidSub);
}
function beforeEditFnchidSub(e)
{
	if(((e.field=="fatherId"))||(e.field=="childsub"))
	{
       var grid1=Ext.getCmp('mygrid');
       var textarea1= grid1.getColumnModel().getCellEditor(e.column, e.row);
       var textarea=Ext.getCmp(textarea1.field.id);
	   textarea.disable();
	}
}
function setfatherId(e)
{
	 var grid=Ext.getCmp('mygrid');
	 var valueArr=e.value.split(":");
	 grid.getSelectionModel().getSelections()[0].set("fatherId",valueArr[1]);
	 //grid.getSelectionModel().getSelections()[0].set("fatherName",e.lastSelectionText);	
}
function additm()
{
	   var grid=Ext.getCmp('mygrid');
	var Plant = Ext.data.Record.create([
         
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
		for (var i = 0; i < store.getCount(); i++) {
			list.push(store.getAt(i).data);
		}
 var SaveQt=document.getElementById('SaveQt');
	    var childsub="";
 	    for (var i = 0; i < list.length; i++) {
			  var obj=list[i];
			  var str="";
			  var CareDate="";
			  var CareTime="";
              for (var p in obj) {
			  	var aa = formatDate(obj[p]);
				if (p=="") continue;
			  	if (aa == "") 
				{   
					  if ((p=="sort")&&(obj[p]==""))
					  {				  		
			              obj[p]=i+1;
					  }
					  
			    	str = str + p + "|" + obj[p] + '^';
			    }else
				{
				  	str = str + p + "|" + aa + '^';	
				}
				childsub=obj["childsub"];
			}
			if (str!="")
			{
			  if (childsub==undefined) childsub=""; 
				//var a=cspRunServerMethod(SaveQt.value,str,childsub);
				var a = tkMakeServerCall("Nur.DHCNUREPRMenuSub","SaveQt",str,childsub);
				if (a!=0)
			  {
			  	return;
			  }
			}
		}
		find();
}
function find()
{	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	//var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNUREPRMenuSub:CRItem", "parr$", "AddRec");
	var a = tkMakeServerCall("web.DHCMGNurComm","GetQueryData", "Nur.DHCNUREPRMenuSub:CRItem", "parr$", "AddRec");
    grid.store.loadData(arrgrid);   
}
function AddRec(str)
{
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
}
function typdelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var list = [];
	var rw=""
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	for (var r = 0;r < len; r++) 
    {
			list.push(rowObj[r].data);
    }
   for (var i = 0; i < list.length; i++) 
   {
			  var obj=list[i];
			  rw=obj["childsub"];
   }

if (rw==undefined) 
	{
		Ext.Msg.alert('提示', "请先选择有效行!");
		return;
	};
	var QtDelete = document.getElementById('QtDelete');
	var ee = tkMakeServerCall("Nur.DHCNUREPRMenuSub","QtDelete",rw);
		if (ee != "0") {
			alert(ee);
			return;
		}
	
	find();
}
function clearscreen() {
	var typ = Ext.getCmp("typsys");
	if (typ) typ.setValue("");
}
function diffDate(val,addday){
	var year=val.getYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };