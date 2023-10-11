var fheight = document.body.clientHeight-2;
var fwidth = document.body.clientWidth-2;
var REC=new Array();

//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
//alert(secGrpFlag);

var combo = new Ext.form.ComboBox({
	id:'comboward',
 store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'WardDesc',
				'mapping':'WardDesc'
				},{
					'name':'rw',
					'mapping':'rw'
				}]
		}),
		baseParams:{
			className:'web.DHCNurRosterComm',
			methodName:'GetWardData',
			type:'RecQuery'
			}
		/* listeners:{ 
			beforeload:function(tstore,e){ 
				tstore.baseParams.parr=secGrpFlag+'^'+session['LOGON.USERCODE'];
				tstore.baseParams.input=Ext.getCmp('comboward').lastQuery;
			}
		} */
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
	listWidth:200,
	width:150,
	xtype : 'combo',
	displayField : 'WardDesc',
	valueField : 'rw',
	hideTrigger : false,
	queryParam : '',
	forceSelection:true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 10,
	typeAhead : true,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
});
var PerTypeCmb=new Ext.form.ComboBox({
	id:'personType',width:100,triggerAction: 'all',mode: 'local',value:'N',
	store: new Ext.data.ArrayStore({
    fields: ['id','desc'],
    data:[['N','正式'],['W','护理员'],['P','实习'],['S','进修']]
	}),
	valueField: 'id',
	displayField: 'desc',
	value:''
});

function BodyLoadHandler()
{	
	createGrid();
}
function createGrid()
{
	var gform=Ext.getCmp('gform');
	var mainpanel=createPanel();
	gform.add(mainpanel);
	gform.doLayout();
	var mainpanel = Ext.getCmp("mainpanel");
	var tobar = mainpanel.getTopToolbar();
	tobar.addItem("-");
	tobar.addItem("病区",combo);
	if(secGrpFlag=="nurhead"){
		combo.store.load({params:{start:0,limit:1000},callback:function(){combo.setValue(session['LOGON.CTLOCID']);}});
		combo.disable();
	}
	tobar.addItem("-");
	var ndate=new Date(),nweek=ndate.format('N');
	tobar.addItem("开始日期",new Ext.form.DateField({id:'stdate',value:ndate.add(Date.DAY,1-nweek)}));
	tobar.addItem("-");
	tobar.addItem("结束日期",new Ext.form.DateField({id:'enddate',value:ndate.add(Date.DAY,7-nweek)}));
	tobar.addItem("-");
	tobar.addItem("人员类型",PerTypeCmb);
	tobar.addItem("-");
	tobar.addButton({id:'findbtn',icon:'../images/uiimages/search.png',text:'查询',handler:function(){reloadGrid();setTimeout('findRec2()',1);}});
	tobar.doLayout();
}
function reloadGrid()
{
	var mainpanel=Ext.getCmp('mainpanel');
	mainpanel.removeAll();
	var table=createTable();
	mainpanel.add(table);
	mainpanel.doLayout();
}

function getWardArray()
{
	REC = new Array();
	var GetQueryData = document.getElementById("getQueryData");
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurRosteringComm.FindAllWardData", "parr$", "AddRec1");
	var arr = new Array();
	for(j=0,i=0;i<REC.length;i=i+3,j++){
		arr[j] = new Array(parseInt(REC[i].toString()),REC[i+2].toString());
	}
	return arr;
}

function AddRec1(a1,a2,a3){
	REC.push(a1,a2,a3);
}

function createPanel()
{
	var table = createTable(); 
	var panel = new Ext.Panel({
		id:'mainpanel',
		region: 'center',
		margins:'3 3 3 0',
		activeTab: 0,
		x:0,y:0,
		border:false,
		height: fheight,
		width: fwidth,
		defaults:{autoScroll:true},
		tbar:[],
		items:[{
			items:[table]
		}]
	});
	return panel;
}
function createTable()
{
	var colModelStr = new Array();
	var colData = new Array();
	getHolidayData();
	colModelStr.push({header: '' ,align:'center' , hidden: true, width: 0, sortable: false,dataIndex: 'NurseId'});
	colModelStr.push({header: '护士姓名' ,align:'center', width: 100, sortable: false,dataIndex: 'NurseName'});
	colData.push({'name':'NurseId','mapping':'NurseId'});
	colData.push({'name':'NurseName','mapping':'NurseName'});
	for(var i=0;i<REC.length;i=i+1){
		//alert('Holiday'+REC[i]['rw']);
		colModelStr.push({header:REC[i]['HolidayDesc'], width: 50,align:'center', sortable: false,dataIndex: 'Holiday'+REC[i]['rw']});
		colData.push({'name':'Holiday'+REC[i]['rw'],'mapping':'Holiday'+REC[i]['rw']});
	}
	colModelStr.push({header: '合计', align:'center', width: 50, sortable: false,dataIndex: 'TotalNum'});
	colData.push({'name':'TotalNum','mapping':'TotalNum'});
	var colModel = new Ext.grid.ColumnModel(colModelStr);
	var store = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:colData
		}),
		baseParams:{className:'DHCMGNUR.MgNurArrangeJob',methodName:'CountHolidayData',type:'RecQuery'},
		listeners:{
			beforeload:function(tstore,e){
				var WardId=combo.getValue();
				var stdate=Ext.getCmp('stdate').getValue().format('Y-m-d');
				var enddate=Ext.getCmp('enddate').getValue().format('Y-m-d');
				var PersonType=Ext.getCmp('personType').getValue();
				var parr=WardId+"^"+stdate+"^"+enddate+"^"+PersonType;
				tstore.baseParams.parr=parr;
			},
    	load:function(mystore,recodes,o) {
   			var RCount=mystore.getTotalCount();
   			var CCount=table.getColumnModel().getColumnCount();
      	var view=table.getView();
      	var CheckNurseType = document.getElementById('CheckNurseType').value;
      	for(var svi=0;svi<RCount;svi++){
      		var NurseID=mystore.getAt(svi).get('NurseId');
      		var NurType=cspRunServerMethod(CheckNurseType,NurseID);
    			if(NurType=="轮转"){
    				cell=view.getCell(svi,1);
      			cell.style.color='#FF0000';
      		}
      		if(NurType=="进修"){
      			cell=view.getCell(svi,1);
      			cell.style.color='#CC00FF';
      		}
      	}
   		}
   	} 
	});
	var table = new Ext.grid.GridPanel({
		renderTo:document.body,
		id:'mygrid',
		x:0,y:0,
		height: document.body.clientHeight-3,
		width: document.body.clientWidth-5,
		store: store,
		cm :colModel,
		//tbar:[],
		bbar:new Ext.PagingToolbar({
			pageSize:1000,
			store:store,
			displayInfo:true,
			displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
			emptyMsg:"没有记录"
		})
	});
	return table;
}
function getHolidayData()
{
	REC =new Array();
	var GetQueryData = document.getElementById("getQueryData").value;
	cspRunServerMethod(GetQueryData,"DHCMGNUR.MgNurHolidayCode.FindHolidayData","parr$N","AddRec2");
}
function AddRec2(a){
	var array=SplitStr(a);
	REC.push(array);
}
function findRec()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({params:{start:0,limit:1000}});
}
function findRec2()
{
	var wardid=combo.getValue();
	if(wardid=="")
 
	{
		Ext.Msg.alert('提示','请选择病区！');
		return;
	}
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({params:{start:0,limit:1000}});
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