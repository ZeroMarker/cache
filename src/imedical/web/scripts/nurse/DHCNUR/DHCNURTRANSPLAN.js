var Height = document.body.clientHeight-5;
var Width = document.body.clientWidth-3;
var REC = new Array();
var DHCNURTRANSPLANDETAILT101=new Ext.data.JsonStore({data:[],fields:['LZPersonID','LZPersonName','LastStayLoc','LZStdate','LZEndDate','rw']});
var WardCombox = new Ext.form.ComboBox({
  triggerAction: 'all',
  mode: 'local',
  width:150,
  store: new Ext.data.ArrayStore({
      fields: ['id','desc'],
      data:getWardArray()
  }),
  valueField: 'id',
  displayField: 'desc'
});
//var WardCombox2 = new Ext.form.ComboBox({
//  triggerAction: 'all',
//  mode: 'local',
//  width:150,
//  store: new Ext.data.ArrayStore({
//      fields: ['id','desc'],
//      data:getWardArray()
//  }),
//  valueField: 'id',
//  displayField: 'desc'
//});
function getWardArray()
{
	REC = new Array();
	var GetQueryData = document.getElementById("getQueryData").value;
	var a = cspRunServerMethod(GetQueryData,"web.DHCNurRosteringComm.FindAllWardData", "parr$", "AddRec1");
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

function BodyLoadHandler()
{
	CreateGrid();
	addTopTool();
	Ext.getCmp('mygrid').on('rowclick',findLTransDep);
}
function CreateGrid()
{
	var PlanTable=CreatePlanTable();
	var TranTable=CreateTranTable();
	var mainpanel = new Ext.Panel({
		id: 'mainpanle',
    title: '轮转计划列表',
    header:false,
    width:Width,
    height:Height,
    plain:true,
    layout: 'border',
    items: [PlanTable, TranTable]
	});
	var gform=Ext.getCmp('gform');
	gform.add(mainpanel);
	gform.doLayout();
}
function CreatePlanTable()
{
	var colModel = new Ext.grid.ColumnModel([ 
		new Ext.grid.RowNumberer(),
		new Ext.grid.CheckboxSelectionModel(),
    { header: "", width: 0, dataIndex: 'PlanNurseID'},//护士工号
    { header: "姓名", width: 50, dataIndex: 'NurseName'},
    { header: "参加工作时间", width: 100,  dataIndex: 'WorkStDate'},
    { header: "现所在科室", width: 100,  dataIndex: 'PlanNowWard'},
    { header: "拟调科室", width: 100,  dataIndex: 'PlanNextWard'},
    { header: "开始日期", width: 70,  dataIndex: 'PlanStDate'},
    { header: "结束日期", width: 70,  dataIndex: 'PlanEndDate'},
    { header: "备注", width: 150,  dataIndex: 'PlanRemarks'},
    { header: "有效位", width: 60,  dataIndex: 'PlanValid'},
    { header: "执行状态", width: 60,  dataIndex: 'PlanStatus'},
    { header: "创建日期", width: 70, dataIndex: 'PlanCrtDate'},
    { header: "创建时间", width: 70, dataIndex: 'PlanCrtTime'},
    { header: "创建人", width: 50, dataIndex: 'PlanCrtPerson'},
    { header: "rw", width: 30, dataIndex: 'id'}
 	]);
	var store = new Ext.data.JsonStore({
		fields:['PlanNurseID','NurseName','WorkStDate','PlanNowWard',
						'PlanNextWard','PlanStDate','PlanEndDate','PlanRemarks','PlanValid',
						'PlanStatus','PlanCrtDate','PlanCrtTime','PlanCrtPerson','id'],
    idIndex: 0
	});
	var table = new Ext.grid.GridPanel({
		id:'mygrid',
		title:'轮转计划列表',
		region: 'center',
		split: true,
		height:Height,
		width:Width*0.7,
		collapsible: false,
		margins:'0 0 0 0',
		store: store,
		tbar: [],
//		bbar: new Ext.PagingToolbar({ 
//      pageSize: 30, 
//      store: store, 
//      displayInfo: true, 
//      displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
//      emptyMsg: "没有记录" 
//    }),
		cm: colModel,
		sm: new Ext.grid.CheckboxSelectionModel()
	});
	return table;
}
function CreateTranTable()
{
	var colModel = new Ext.grid.ColumnModel([ 
		new Ext.grid.RowNumberer(),
    { header: "", width: 0, dataIndex: 'PlanNurseID'},//护士工号
    { header: "姓名", width: 50, dataIndex: 'NurseName'},
    { header: "轮转科室", width: 80,  dataIndex: 'TransWard'},
    { header: "开始日期", width: 60,  dataIndex: 'TransStDate'},
    { header: "结束日期", width: 60,  dataIndex: 'TransEndDate'},
    { header: "rw", width: 30, dataIndex: 'id'}
 	]);
	var store = new Ext.data.JsonStore({
		fields:['PlanNurseID','NurseName','TransWard','TransStDate','TransEndDate','id'],
    idIndex: 0
	});
	var table = new Ext.grid.GridPanel({
		id:'mygrid2',
		title:'轮转记录',
		region: 'east',
		split: true,
		height:Height,
		width:Width*0.3,
		collapsible: true,
	  margins:'0 0 1 0',
	  tbar: [],
//	 	bbar: new Ext.PagingToolbar({ 
//      pageSize: 30, 
//      store: store, 
//      displayInfo: true, 
//      displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
//      emptyMsg: "没有记录" 
//    }),
		store: store,
		cm: colModel
	});
	return table;
}
function addTopTool()
{
	var mygrid = Ext.getCmp("mygrid");
	var tobar=mygrid.getTopToolbar();
	var tobar2=new Ext.Toolbar();
	tobar.addItem('-');tobar.addItem('开始日期:',new Ext.form.DateField({id:'StDate',format:'Y-m-d',value:(new Date()).add(Date.DAY,1-((new Date()).format('N')))}));
	tobar.addItem('-');tobar.addItem('结束日期:',new Ext.form.DateField({id:'EndDate',format:'Y-m-d',value:(new Date()).add(Date.DAY,7-((new Date()).format('N')))}));
	tobar.addItem('-');tobar.addItem(new Ext.form.Checkbox({id:'ValidCheck'}),'显示作废记录')
	tobar.addItem('-');tobar.addItem(new Ext.form.Checkbox({id:'StatusCheck'}),'显示执行记录')
	tobar.addItem('-');tobar.addButton({id:'findbtn',icon:'../Image/light/search.png',text:'查找',handler:findRec});
	tobar2.addItem('-');tobar2.addButton({id:'addbtn',icon:'../Image/light/add.png',text:'新建',handler:addRec});
	tobar2.addItem('-');tobar2.addButton({id:'updatebtn',icon:'../Image/light/write.png',text:'修改',handler:updateRec});
	tobar2.addItem('-');tobar2.addButton({id:'validbtn',icon:'../Image/light/refuse.ico',text:'作废',handler:function(){setMarks("V");}});
	tobar2.addItem('-');tobar2.addButton({id:'unvalidbtn',icon:'../Image/light/refresh.png',text:'撤销作废',handler:function(){setMarks("CV");}});
	tobar2.addItem('-');tobar2.addButton({id:'dobtn',icon:'../Image/light/imgFlag1.gif',text:'执行',handler:function(){setMarks("S");}});
	tobar2.addItem('-');tobar2.addButton({id:'undobtn',icon:'../Image/light/imgFlag2.gif',text:'撤销执行',handler:function(){setMarks("CS");}});
	tobar2.render(mygrid.tbar);
	tobar.doLayout();
	var mygrid2 = Ext.getCmp("mygrid2");
	var tobar=mygrid2.getTopToolbar();
	tobar.addItem('-');tobar.addItem('病区:',WardCombox);
	tobar.addItem('-');tobar.addButton({id:'findtranbtn',icon:'../Image/light/search.png',text:'查找',handler:findTransDepByWard});
}

function CreatePlanWindow()
{
	var colModel = new Ext.grid.ColumnModel([ 
		new Ext.grid.RowNumberer(),
		new Ext.grid.CheckboxSelectionModel(),
    { header: "", width: 0, dataIndex: 'PlanNurseID'},//护士工号
    { header: "姓名", width: 70, dataIndex: 'PersonName'},
    { header: "参加工作时间", width: 100,  dataIndex: 'WorkStDate'},
    { header: "现所在科室", width: 150,  dataIndex: 'NowStayWard'},
    { header: "转入时间", width: 150,  dataIndex: 'NowStDate'},
    { header: "曾轮转科室", width: 250,  dataIndex: 'LastStayWard'}
 	]);
	var store = new Ext.data.JsonStore({
		fields:['PlanNurseID','PersonName','WorkStDate','NowStayWard','NowStDate','LastStayWard'],
    data:[]
	});
	var table = new Ext.grid.GridPanel({
		id:'mygrid3',
		title:'轮转计划列表',
		header: false,
		region: 'center',
		split: true,
		height:600,
		width:500,
		cm: colModel,
		store: store,
		tbar: ['-','姓名:',new Ext.form.TextField({id:'findName',width:100}),
			'-',new Ext.Button({id:'findperbtn',icon:'../Image/light/search.png',text:'查找'}),
			'-','拟调病区:',new Ext.form.ComboBox({
						id: 'WardCombox2',
					  triggerAction: 'all',
					  mode: 'local',
					  width:150,
					  store: new Ext.data.ArrayStore({
					      fields: ['id','desc'],
					      data:getWardArray()
					  }),
					  valueField: 'id',
					  displayField: 'desc'
					}),
					'-','开始日期:',new Ext.form.DateField({id:'CrtStDate',format:'Y-m-d',value:new Date()}),
					//'-','结束日期:',new Ext.form.DateField({id:'CrtEndDate',format:'Y-m-d',value:(new Date()).add(Date.DAY,1)}),
					'-',new Ext.Button({id:'addbtn2',icon:'../Image/light/add.png',text:'保存',handler:''})
					],
//		bbar: new Ext.PagingToolbar({ 
//      pageSize: 30, 
//      store: store, 
//      displayInfo: true, 
//      displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
//      emptyMsg: "没有记录" 
//    }),
		sm: new Ext.grid.CheckboxSelectionModel()
	});
	findLZRec();
	var win=new Ext.Window({
    title: '创建轮转计划',
    closable:true,
    width:800,
    height:600,
    plain:true,
    modal:true,
    layout: 'border',
    items: [table]
	});
	return win;
}
function addRec()
{
	var win=CreatePlanWindow();
	win.show();
	var saveBtn=Ext.getCmp('addbtn2');
	saveBtn.on('click',function(){saveRec();win.close();});
	Ext.getCmp('findperbtn').on('click',function(){findLZRec();})
}
function saveRec()
{
	var mygrid3=Ext.getCmp('mygrid3');
	var selections=mygrid3.getSelectionModel().getSelections();
	if(selections.length==0)
	{
		alert("请至少选择一条轮转护士信息!");
		return;
	}
	var saveVal=document.getElementById('saveVal').value;
	var PlanCrtPerson=session['LOGON.USERCODE'];
	
	var PlanNextWard=Ext.getCmp('WardCombox2').getValue();
	var PlanStDate=Ext.getCmp('CrtStDate').getValue().format('Y-m-d');
	for(var i=0;i<selections.length;i++)
	{
		var row=selections[i];
		var PlanNurseID=row.get('PlanNurseID');
		var parr="PlanNurseID|"+PlanNurseID+"^"+"PlanNextWard|"+PlanNextWard+"^"+"PlanCrtPerson|"+PlanCrtPerson+"^"+"PlanStDate|"+PlanStDate;
		cspRunServerMethod(saveVal,parr);
	}
	findRec();
}
function findLZRec()
{
	REC=new Array();
	var mygrid3 = Ext.getCmp('mygrid3');
	var PersonName=Ext.getCmp('findName').getValue();
	var GetQueryData = document.getElementById("GetQueryData").value;
	var ret=cspRunServerMethod(GetQueryData,"web.DHCNurTransPlan.FindNurNowLoc","parr$"+PersonName,"AddLZRec");
	mygrid3.store.loadData(REC);
	mygrid3.store.sort('WorkStDate','ASC');
}
function AddLZRec(a)
{
	var array=SplitStr(a);
	//"PersonID|"_PersonID_"^PersonName|"_PersonName_"^TempWardCode|"_TempWardCode_"
	//^WorkStDate|"_$zd(PersonWorkDateTime,3)_"^NowStDate|"_nowStDate_"^PerLastDep|"_PerLastDep
	//['PlanNurseID','PersonName','WorkStDate','NowStayWard','NowStDate','LastStayWard']
	REC.push({
		PlanNurseID:array["PersonID"],
		PersonName:array["PersonName"],
		NowStayWard:array["TempWardCode"],
		WorkStDate:array["WorkStDate"],
		NowStDate:array["NowStDate"],
		LastStayWard:array['PerLastDep']
	});
}
function SplitStr(Str)
{
	var array=new Array();
	var StrArr=Str.split("^");
	for(i=0;i<StrArr.length;i++)
	{
		var StrArr2=StrArr[i].split("|");
		array[StrArr2[0]]=StrArr2[1];
	}
	return array;
}
function findRec()
{
	//debugger;
	REC=new Array();
	var mygrid=Ext.getCmp('mygrid');
	var getQueryData=document.getElementById('GetQueryData').value;
	var StDate=Ext.getCmp('StDate').getValue(); //.format('Y-m-d');
	if(!StDate){
		Ext.Msg.alert('提示','开始日期不能为空！');
		return;	
	}else{
		if(StDate instanceof Date){
			StDate=StDate.format('Y-m-d');
		}
	}
	var EndDate=Ext.getCmp('EndDate').getValue(); //.format('Y-m-d');
	if(!EndDate){
		Ext.Msg.alert('提示','结束日期不能为空！');
		return;
	}else{
		if(EndDate instanceof Date){
			EndDate=EndDate.format('Y-m-d');
		}
	}
	var Valid=Ext.getCmp('ValidCheck').getValue();
	if(Valid==true) Valid="Y";
	else Valid="N";
	var Status=Ext.getCmp('StatusCheck').getValue();
	if(Status==true) Status="Y";
	else Status="N";
	var parr=StDate+"^"+EndDate+"^"+Valid+"^"+Status;
	cspRunServerMethod(getQueryData,"web.DHCNurTransPlan.FindTransPlan","parr$"+parr,"AddPlanRec");
	mygrid.store.loadData(REC);
}

function AddPlanRec(a)
{
	var array=SplitStr(a);
	//PlanNurseID|9706^PersonName|王海漫^WorkStDate|62282^NowStayLoc|^NowLocStDate|^PlanNextWard|913
	//^WardCode|急诊外科病区^PlanStDate|2014-06-17^PlanRemarks|^PlanValid|Y^PlanStatus|N^
	//PlanNTransID|^PlanLTransID|^PlanCrtDate|2014-06-17^PlanCrtTime|15:32:24^PlanCrtPerson|6253^ID|2
	REC.push({
		PlanNurseID:array['PlanNurseID'],
		NurseName:array['PersonName'],
		WorkStDate:array['WorkStDate'],
		PlanNowWard:array['NowStayLoc'],
		PlanNextWard:array['WardCode'],
		PlanStDate:array['PlanStDate'],
		PlanEndDate:array['PlanEndDate'],
		PlanRemarks:array['PlanRemarks'],
		PlanStatus:array['PlanStatus'],
		PlanValid:array['PlanValid'],
		PlanCrtDate:array['PlanCrtDate'],
		PlanCrtTime:array['PlanCrtTime'],
		PlanCrtPerson:array['CrtPersonName'],
		id:array['ID']
	});
}
function updateWindow()
{
	var a=cspRunServerMethod(pdata1,"","DHCNURTRANSPLANDETAIL","","");
	var arr = eval(a);
	var win= new Ext.Window({
		title : '轮转计划明细',
		id : "mygrid4",
		x:100,y:50,
		width : 600,
		height : 500,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		modal: true,
		items : [arr]
	});
	return win;
}
function updateRec()
{
	var mygrid=Ext.getCmp('mygrid');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length!=1)
	{
		alert('请选择一条轮转计划记录!');
		return;
	}
	var row=mygrid.getSelectionModel().getSelected();
	var rw=row.get('id');
	var getVal=document.getElementById('getVal').value;
	var ret=cspRunServerMethod(getVal,rw);
	var array=SplitStr(ret);
	var win=updateWindow();
	win.show();
	Ext.getCmp('UPersonID').setValue(array['PlanNurseID']);
	Ext.getCmp('UPersonName').setValue(array['PersonName']);
	Ext.getCmp('UWorkStDate').setValue(array['WorkStDate']);
	Ext.getCmp('UNowStayLoc').store.load({params:{start:0,limit:1000},callback:function(){Ext.getCmp('UNowStayLoc').setValue(array['NowStayLocCode']);}});
	Ext.getCmp('UNextStayLoc').store.load({params:{start:0,limit:1000},callback:function(){Ext.getCmp('UNextStayLoc').setValue(array['PlanNextWard']);}});
	Ext.getCmp('UPlanStDate').setValue(array['PlanStDate']);
	Ext.getCmp('UPersonID').disable();
	Ext.getCmp('UPersonName').disable();
	Ext.getCmp('UWorkStDate').disable();
	Ext.getCmp('UNowStayLoc').disable();
	REC=new Array();
	var getQueryData=document.getElementById('getQueryData').value;
	cspRunServerMethod(getQueryData,"web.DHCNurTransPlan.FindNurTransDep","parr$"+array['PlanNurseID'],"AddTransDep");
	var mygrid5 = Ext.getCmp('mygrid5');
	mygrid5.store.loadData(REC);
	var USaveBtn=Ext.getCmp('USaveBtn');
	USaveBtn.on('click',function()
	{
		var UNextStayLoc=Ext.getCmp('UNextStayLoc').getValue();
		if(UNextStayLoc=="")
		{
			alert("请选择拟调科室!");
			return;
		}
		var UPlanStDate=Ext.getCmp('UPlanStDate').getValue().format('Y-m-d');
		if(UPlanStDate=="")
		{
			alert("请选择开始日期!");
			return;
		}
		var UPlanRemarks=Ext.getCmp('UPlanRemarks').getValue();
		var parr="ID|"+rw+"^"+"PlanNextWard|"+UNextStayLoc+"^"+"PlanStDate|"+UPlanStDate+"^"+"PlanRemarks|"+UPlanRemarks;
		var updateVal=document.getElementById('updateVal').value;
		cspRunServerMethod(updateVal,parr);
		win.close();
	});
	findRec();
}
function AddTransDep(a)
{
	var array=SplitStr(a);
	REC.push({
		LZPersonID:array['PersonID'],
		LZPersonName:array['PersonName'],
		LastStayLoc:array['WardCode'],
		LZStdate:array['StDate'],
		LZEndDate:array['EndDate'],
		rw:array['ID']
	});
}
function setMarks(mark)
{
	var mygrid=Ext.getCmp('mygrid');
	var SetMarks=document.getElementById("SetMarks").value;
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length==0)
	{
		alert('请选择要操作的轮转计划记录!');
		return;
	}
	var parr=mark+"!";
	for(var i=0;i<selections.length;i++)
	{
		var row=selections[i];
		var rw=row.get('id');
		var Valid=row.get('PlanValid');
		var Status=row.get('PlanStatus');
		if(mark=="V")
		{
			if(Valid=="N")
			{
				alert("当前存在已作废的记录!")
				return;
			}
			if(Status=="Y")
			{
				alert("请先撤销执行，再进行作废操作!")
				return;
			}
		}
		if(mark=="CV")
		{
			if(Valid=="Y")
			{
				alert("当前存在未作废的记录!")
				return;
			}
		}
		if(mark=="S")
		{
			if(Valid=="N")
			{
				alert("当前存在已作废的记录!")
				return;
			}
			if(Status=="Y")
			{
				alert("当前存在已执行，请不要重复操作!")
				return;
			}
		}
		if(mark=="CS")
		{
			if(Status=="N")
			{
				alert("当前存在未执行，无法撤销执行操作!")
				return;
			}
			
		}
		parr=parr+rw+"^";
	}
	var a=cspRunServerMethod(SetMarks,parr);
	findRec();
}
function findLTransDep(grid,row,e)
{
	REC=new Array();
	var mygrid2=Ext.getCmp('mygrid2');
	var getQueryData=document.getElementById("getQueryData").value;
	var PlanNurseID=grid.store.getAt(row).get('PlanNurseID');
	cspRunServerMethod(getQueryData,"web.DHCNurTransPlan.FindNurTransDep","parr$"+PlanNurseID,"AddLTDRec");
	mygrid2.store.loadData(REC);
}
function AddLTDRec(a)
{
	var array=SplitStr(a);
	//'PlanNurseID','NurseName','TransWard','TransStDate','TransEndDate','id'
	REC.push({
		PlanNurseID:array['PersonID'],
		NurseName:array['PersonName'],
		TransWard:array['WardCode'],
		TransStDate:array['StDate'],
		TransEndDate:array['EndDate'],
		id:array['ID']
	});
}
function findTransDepByWard()
{
	REC=new Array();
	var mygrid2 = Ext.getCmp('mygrid2');
	var parr=WardCombox.getValue();
	if(parr=="")
	{
		alert("请选择病区");
		return;
	}
	var getQueryData = document.getElementById("getQueryData").value;
	var ret=cspRunServerMethod(getQueryData,"web.DHCNurTransPlan.FindNurseClgLoc","parr$"+parr,"AddLTDRec");
	mygrid2.store.loadData(REC);
}