var fheight = document.body.clientHeight-2;
var fwidth = document.body.clientWidth-2;
//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
//alert(secGrpFlag);

var combo = new Ext.form.ComboBox({
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
	listWidth:200,
	//height:18,
	width:150,xtype : 'combo',
	displayField : 'WardDesc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
	minChars : 1,pageSize : 10,typeAhead : false,typeAheadDelay : 1000,loadingText : 'Searching...'
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
	var mygridpl=Ext.getCmp("mygridpl");
	mygridpl.setHeight(fheight);
	mygridpl.setWidth(fwidth);
	mygridpl.setPosition(0,0);
	createGrid();
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.on('beforeload',function(){
		var WardId = combo.getValue();
		var stdate = Ext.getCmp('stdate').getValue().format('Y-m-d');
		var enddate = Ext.getCmp('enddate').getValue().format('Y-m-d');
		var PersonType=Ext.getCmp('personType').getValue();
		var parr = WardId+"^"+stdate+"^"+enddate+"^"+PersonType;
		mygrid.store.baseParams.parr=parr;
	});
}
function createGrid()
{
	var mygrid = Ext.getCmp("mygrid");
	var tobar = mygrid.getTopToolbar();
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but=Ext.getCmp("mygridbut2");
	but.hide();
	tobar.addItem("-");
	tobar.addItem("病区",combo);
	if(secGrpFlag=="nurhead")
	{
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
	tobar.addButton({id:'findbtn',icon:'../images/uiimages/search.png',text:'查询',handler:LoadData2});
	var bbar = mygrid.getBottomToolbar ();
	bbar.hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:20,
		store:mygrid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(mygrid.bbar);
	tobar.doLayout();
	var len = mygrid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){

		if(mygrid.getColumnModel().getDataIndex(i) == 'rw'){
			mygrid.getColumnModel().setHidden(i,true);
		}
  }
}
function getWardArray()
{
	REC = new Array();
	var GetQueryData = document.getElementById("getQueryData");
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurRosteringComm.FindAllWardData", "parr$"+"", "AddRec1");
	var arr = new Array();
	for(j=0,i=0;i<REC.length;i=i+3,j++)
	{
		arr[j] = new Array(parseInt(REC[i].toString()),REC[i+2].toString());
	}
	return arr;
}
function AddRec1(a1,a2,a3){
	REC.push(a1,a2,a3);
}

function LoadData()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({params:{start:0,limit:20}});
}
function LoadData2()
{
	var wardid=combo.getValue();
	if(wardid=="")
 
	{
		Ext.Msg.alert('提示','请选择病区！');
		return;
	}
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({params:{start:0,limit:20}});
}