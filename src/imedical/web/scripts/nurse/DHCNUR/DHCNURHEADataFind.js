var REC = new Array();
var CareItemDR = "";
function BodyLoadHandler()
{
	var Height = document.body.clientHeight-5;
	var Width = document.body.clientWidth-3;
	var mygridpl=Ext.getCmp("mygridpl");
	mygridpl.setHeight(Height);
	mygridpl.setWidth(Width);
	mygridpl.setPosition(0,0);
	myGridFun("mygrid");
}
var combo1 = new Ext.form.ComboBox({
	id:'comboward',
  typeAhead: true,
  triggerAction: 'all',
  lazyRender:true,
  mode: 'local',
  lazyInit:true,
  editable:false,
  store: new Ext.data.ArrayStore({
      id: 'WardStore',
      fields: [
          'WardId2',
          'WardDesc2'
      ],
      data: getArray1()
  }),
  valueField: 'WardId2',
  displayField: 'WardDesc2',
  listeners:{
  	select:function(combox,record,index){
  		//alert(combox.getValue());
  		REC=new Array();
  		var parr=combo1.getValue();
  		if(parr!=""){
  			//var GetQueryData = document.getElementById("getQureyData");
				//var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPCare", "parr$" + parr, "AddRec2");
  			combo2.store.loadData(getArray2(parr));
  		}
  	}
  }
});
var combo2 = new Ext.form.ComboBox({
	id:'combocare',
  typeAhead: true,
  triggerAction: 'all',
  lazyRender:true,
  mode: 'local',
  lazyInit:true,
  editable:false,
  store: new Ext.data.ArrayStore({
    id: 'CareStore',
    fields: ['CareId','CareDesc']
	}),
  valueField: 'CareId',
  displayField: 'CareDesc',
  listeners:{
  	select:function(combox,record,index){
  		//alert(combo2.getValue());
  		CareItemDR = combo2.getValue();
  	}
  }
});
var StDate = new Ext.form.DateField({
	id:'StDate',
	editable:false,
	x:0,y:0,
	format:'Y-m-d',
	width:100
});
var EndDate = new Ext.form.DateField({
	id:'EndDate',
	editable:false,
	x:0,y:0,
	format:'Y-m-d',
	width:100,
	listeners:{
		select:function(dateField,date){
			var StDate = document.getElementById("StDate").value;
			var EndDate = document.getElementById("EndDate").value;
			//alert(EndDate);
			if(StDate>EndDate)
			{
				alert("结束日期不能早于开始日期！");
			}
		}
	}
});
var HEAIndvdNd = new Ext.form.CheckboxGroup({
	id:'HEAIndvdNd',
	height:20,
	//width:825,
	columns:[50,50,50,50,50,50,50,50,50,50,75,50],
	items:[
	{boxLabel:'疾病',inputValue:1},
	{boxLabel:'康复',inputValue:2},
	{boxLabel:'药物',inputValue:3},
	{boxLabel:'出院',inputValue:4},
	{boxLabel:'入院',inputValue:5},
	{boxLabel:'饮食',inputValue:6},
	{boxLabel:'宗教',inputValue:7},
	{boxLabel:'心理',inputValue:8},
	{boxLabel:'介入',inputValue:9},
	{boxLabel:'设备',inputValue:10},
	{boxLabel:'疼痛护理',inputValue:11},
	{boxLabel:'其他',inputValue:12}]
}); 
function myGridFun()
{
	var grid = Ext.getCmp("mygrid");
	var tobar=grid.getTopToolbar();
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but2=Ext.getCmp("mygridbut2");
	but2.hide();
	var tobar2=new Ext.Toolbar({});
	tobar.addItem("开始日期",StDate);
	tobar.addItem("-");
	tobar.addItem("结束日期",EndDate);
	tobar.addItem("-");
	var UserType = session['LOGON.GROUPDESC'];
	if(UserType=='Inpatient Nurse'||UserType == '住院护士长')
	{
		var parr = session['LOGON.CTLOCID'];
		combo1.setValue(parr);
		combo1.disable();
		combo2.store.loadData(getArray2(parr));
	}
	tobar.addItem("病区",combo1);
	tobar.addItem("-");
	tobar.addItem("教育项",combo2);
	tobar2.addItem("教育个性化需求:",HEAIndvdNd);
	tobar.addItem("-");
	tobar.addButton({
		id:'finBtn',
		handler:function(){findData();},
		text:'查询'
	});
	tobar2.render(grid.tbar);
	//tobar2.doLayout();
	tobar.doLayout();
}
function getArray1()
{
	REC = new Array();
	var GetQueryData = document.getElementById("getQureyData");
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindAllWardData", "parr$", "AddRec1");
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
function getArray2(parr)
{
	REC = new Array();
	var GetQueryData = document.getElementById("getQureyData");
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPItemOne", "parr$" + parr, "AddRec1");
	var arr = new Array();
	for(j=0,i=0;i<REC.length;i=i+3,j++)
	{
		arr[j] = new Array(parseInt(REC[i].toString()),REC[i+1].toString());
	}
	return arr;
}
function multchoice(multtext)
{
	var multvalue = Ext.getCmp(multtext).items;
	var multchkvalue = "";
	for(i=0;i<multvalue.length;i++)
	{
		if(multvalue.get(i).checked)
		{
			if(multchkvalue!="")
			{
				var multchkvalue = multchkvalue+","+multvalue.get(i).boxLabel;
			}
			else
			{
				var multchkvalue = multvalue.get(i).boxLabel;
			}
		}
	}
	return multchkvalue;
}
function findData()
{
	REC = new Array();
	var grid = Ext.getCmp("mygrid");
	var GetQueryData = document.getElementById("getQureyData");
	var StDate = document.getElementById("StDate").value;
	var EndDate = document.getElementById("EndDate").value;
	var IndvdNd = multchoice("HEAIndvdNd");
	var parr=StDate+"^"+EndDate+"^"+IndvdNd+"^"+CareItemDR;
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCHlthEduAss:FindHEAData", "parr$" + parr, "AddRec2");
	grid.store.loadData(REC);
}
function AddRec2(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18){
	REC.push({
		PAPMIName:a1,
		PAPMIPatNo:a2,
		CTSexDesc:a3,
		PAPersonAge:a4,
		CTLocDesc:a5,
		PAADMAdmDate:a6,
		PAADMAdmTime:a7,
		AdmDate:a8,
		HEATime:a9,
		HEAIdvdNd:a10,
		HEAProject:a11,
		HEAObject:a12,
		HEAOpportunity:a13,
		HEAMethod:a14,
		HEAEffectAss:a15,
		HEATeacher:a16,
		HEARemarks:a17,
		HEARowId:a18
	});
}