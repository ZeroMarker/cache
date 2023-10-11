var Height = document.body.clientHeight-3;
var Width = document.body.clientWidth-3;
var REC=new Array();

//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
//alert(secGrpFlag);
var WardCombo = new Ext.form.ComboBox({
	id:'comboward',
 store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:[{'name':'WardDesc','mapping':'WardDesc'},{'name':'rw','mapping':'rw'}]
		}),
		baseParams:{className:'web.DHCNurRosterComm',methodName:'GetWardData',type:'RecQuery'}
	}),
	listeners:{ 
			beforeload:function(tstore,e){ 
				tstore.baseParams.parr=secGrpFlag+'^'+session['LOGON.USERCODE'];
				tstore.baseParams.input=Ext.getCmp('comboward').lastQuery;
			},
			focus: {
				fn: function (e) {
				e.expand();
				this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
						combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.data[me.displayField]);
						return regExp.test(text)|regExp.test(record.data[me.displayField]);
					});
					combo.expand();
					combo.select(0, true);
					return false;
				}
		    }
		},
	//tabIndex:'0',
	listWidth:200,
	//height:18,
	width:150,xtype : 'combo',
	displayField : 'WardDesc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
	minChars : 1,pageSize : 10,typeAhead : false,typeAheadDelay : 1000,loadingText : 'Searching...'
});
function BodyLoadHandler()
{
	var gform=Ext.getCmp("gform");
	gform.add(CreateTable());
	gform.doLayout();
	createGrid();
}
function createGrid()
{
	var mygrid =Ext.getCmp("mygrid");
	var tobar = mygrid.getTopToolbar();
	var tobar2 = new Ext.Toolbar();
	var bbar=mygrid.getBottomToolbar();
	bbar.hide();
	tobar.addItem("-","病区",WardCombo);
	var UserType = session['LOGON.GROUPDESC'];
	//if(UserType=='Inpatient Nurse'||UserType == '住院护士长'||UserType.indexOf('护士长')>0)
	if(secGrpFlag=="nurhead"){
		WardCombo.store.load({params:{start:0,limit:1000},callback:function(){
			WardCombo.setValue(session['LOGON.CTLOCID']);
			setTimeout(function(){
				if(findRec()!=false) saveRec();
			},10);}});
		WardCombo.disable();
	}
	var nowDate=new Date();
	var nextDate="";
	if(nowDate.format('w')==0) nextDate=1;
	else nextDate=8-nowDate.format('w');
	tobar.addItem("-","开始日期",new Ext.form.DateField({id:'StDate',value:nowDate.add(Date.DAY,nextDate)}));
	tobar.addItem("-","结束日期",new Ext.form.DateField({id:'EndDate',value:nowDate.add(Date.DAY,6+nextDate)}));
	tobar.addItem("-");
	//tobar.addButton({id:'addBtn',text:'查询',icon:'../images/uiimages/search.png',handler:function(){if(findRec()!=false) saveRec();}});
	tobar2.addItem("-","序号",new Ext.form.TextField({id:'TOrder',width:50,maskRe:/^\d+$/}));
	tobar2.addItem("-",new Ext.Button({id:'saveBtn',icon:'../images/uiimages/filesave.png',text:'保存',handler:changeOrder}));
	tobar2.addItem("-",new Ext.Button({id:'upBtn',icon:'../images/uiimages/moveup.png',text:'上移',handler:changeOrder}));
	tobar2.addItem("-",new Ext.Button({id:'downBtn',icon:'../images/uiimages/movedown.png',text:'下移',handler:changeOrder}));
	tobar2.addItem("-");
	tobar2.addButton({id:'addBtn',text:'查询',icon:'../images/uiimages/search.png',handler:function(){if(findRec()!=false) saveRec();}});
	var bbar=new Ext.PagingToolbar({ 
      pageSize: 1000, 
      store: mygrid.store, 
      hidden:true,
      displayInfo: true, 
      displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
      emptyMsg: "没有记录" 
  })
  bbar.render(mygrid.bbar);
  tobar2.render(mygrid.tbar);
	tobar.doLayout();
}
function getWardArray()
{
	REC=new Array();
	var getQueryData=document.getElementById("GetQueryData").value;
	var ret=cspRunServerMethod(getQueryData,"web.DHCNurRosterComm.FindAllWard", "parr$", "AddWardRec");
	return REC;
}
function AddWardRec(a1,a2,a3)
{
	//if(a1=="1018") alert(a1+"-"+a3);
	REC.push(new Array(a1,a3));
}
function CreateTable()
{
	REC=new Array();
	var colModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{header: '', width: 0,hidden:true, sortable: false,dataIndex: 'NurseID'},
		{header: '护士姓名', width: 150, sortable: false,dataIndex: 'NurseName'},
		{header: '护士层级', width: 100, sortable: false,dataIndex: 'NurseBty'},
		{header: '', width: 0,hidden:true, sortable: false,dataIndex: 'NurseType'},
		{header: '显示顺序', width: 100, sortable: false,dataIndex: 'NurseOrder'}
	]);
	var store = new Ext.data.JsonStore({
		//data:[],
		//autoSave:true,
    fields:['NurseID','NurseName','NurseType','NurseBty','NurseOrder'],
    listeners:{
    	load:function(mystore,recodes,o){
    		var RCount=mystore.getTotalCount();
      	var view=table.getView();
      	//var CheckNurseType = document.getElementById('CheckNurseType').value;
      	for(var svi=0;svi<RCount;svi++){
      		//var NurseId=mystore.getAt(svi).get('NurseId');
      		var NurType=mystore.getAt(svi).get('NurseType');
    			if(NurType=="P"){
    				cell=view.getCell(svi,2);
      			cell.style.color='#FF00FF';
      		}
      		if(NurType=="S"){
      			cell=view.getCell(svi,2);
      			cell.style.color='blue';
      		}
      		if(NurType=="W"){
      			cell=view.getCell(svi,2);
      			cell.style.color='orange';
      		}
      	}
    	}
    }
	});
	var table = new Ext.grid.GridPanel({
		renderTo:document.body,
		id:'mygrid',
		x:0,y:0,width:Width,height:Height,
		store: store,
		cm :colModel,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar:[],
		bbar: new Ext.PagingToolbar({ 
        pageSize: 1000, 
        store: store, 
        displayInfo: true, 
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
        emptyMsg: "没有记录" 
    }),
    listeners:{
    }
	});
	return table;
}
function saveRec()
{
	var mygrid=Ext.getCmp('mygrid');
	var store=mygrid.getStore();
	var count=store.getTotalCount();
	var WardId=WardCombo.getValue();
	if(WardId==""){
		Ext.Msg.alert('提示',"请选择病区!");
		return;
	}
	var JsonStr = Ext.util.JSON.encode(store.reader.jsonData);
	var StoreStr = JsonToString(JsonStr);
	var parr=WardId+"!"+StoreStr;
	var save=document.getElementById('Save').value;
	var a=cspRunServerMethod(save,parr);
}
function changeOrder()
{
	var mygrid=Ext.getCmp('mygrid');
	var WardId=WardCombo.getValue();
	var selectedRow=mygrid.getSelectionModel().getSelected();
	if(selectedRow==null){
		Ext.Msg.alert('提示',"请选择一条记录")
		return;
	}
	var NurseId=selectedRow.get('NurseID');
	var parr=WardId+"^"+NurseId+"^";
	if(this.id=="saveBtn"){
		var TOrder=Ext.getCmp('TOrder').getValue();
		if(TOrder==""){
			alert('请填写将要设置的序号!');
			return;
		}
		parr=parr+TOrder;
	}
	if(this.id=="upBtn"){
		parr=parr+(parseInt(selectedRow.get('NurseOrder'))-1);
		Ext.getCmp('TOrder').setValue(parseInt(selectedRow.get('NurseOrder'))-1);
	}
	if(this.id=="downBtn"){
		parr=parr+(parseInt(selectedRow.get('NurseOrder'))+1);
		Ext.getCmp('TOrder').setValue(parseInt(selectedRow.get('NurseOrder'))+1);
	}
	parr=parr+"^"+selectedRow.get('NurseType');
	var ChangeOrder=document.getElementById('ChangeOrder').value;
	var a=cspRunServerMethod(ChangeOrder,parr);
	findRec();
	mygrid.getSelectionModel().selectRow(Ext.getCmp('TOrder').getValue()-1);
}
function JsonToString(JsonStr)
{
	JsonStr=JsonStr.replace(/\"\}\,\{\"/g,"@");
	JsonStr=JsonStr.replace(/\"\:\"/g,"|");
	JsonStr=JsonStr.replace(/\"\,\"/g,"^");
	JsonStr=JsonStr.replace(/\[\{\"/g,"");
	JsonStr=JsonStr.replace(/\"\}\]/g,"");
	return JsonStr;
}
function findRec()
{
	REC=new Array();
	var mygrid =Ext.getCmp('mygrid');
	var getQueryData=document.getElementById("GetQueryData").value;
	var WardId=WardCombo.getValue();
	if(WardId==""){
		Ext.Msg.alert('提示',"请选择病区!");
		return false;
	}
	var StDate=Ext.getCmp("StDate").getValue().format('Y-m-d');
	var EndDate=Ext.getCmp('EndDate').getValue().format('Y-m-d');
	var parr=WardId+"^"+StDate+"^"+EndDate;
	var ret=cspRunServerMethod(getQueryData,"web.DHCNurArgJobNurInfo.FindNurInfoData", "parr$"+parr, "AddNurInfRec");
	mygrid.store.loadData(REC);
}
function AddNurInfRec(a)
{
	var array=SplitStr(a);
	REC.push({
		NurseID:array['PersonID'],
		NurseName:array['PersonName'],
		NurseType:array['PersonType'],
		NurseBty:array['PersonBty'],
		NurseOrder:(REC.length+1).toString()
	});
}
function SplitStr(Str)
{
	var array=new Array();
	var StrArr=Str.split("^");
	for(i=0;i<StrArr.length;i++){
		var StrArr2=StrArr[i].split("|");
		array[StrArr2[0]]=StrArr2[1];
	}
	return array;
}