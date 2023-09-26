/**
 * *dhcopifworkload.js
 * *Creator:liulei
 * *CreatDate:2010-06-20 
 * *Description:门诊输液室工作量统计
 */
    var SummUserdata=new Array();
	var Detaildata=new Array();
	var SummCTLocdata=new Array();
	var path=cspRunServerMethod(GetPath);
	
   function SummSearch()
   {
        SummUserdata=new Array();
		SummCTLocdata=new Array();
   		var sd=Ext.get("SDate").dom.value;
		var ed=Ext.get("EDate").dom.value;
		if((sd=="")||(ed=="")){
			alert("查询日期不能为空!")
			return;
		}
		var ctlocId=session['LOGON.CTLOCID'];
		cspRunServerMethod(GetNurWork,ctlocId,sd,ed,'SummUserAdd');
		cspRunServerMethod(GetCTLocWork,ctlocId,sd,ed,'SummCTLocAdd');
		SummUserstore.loadData(SummUserdata);
		SummCTLocstore.loadData(SummCTLocdata);
		DetailSearch("",""); //查询刷新
	}
	
    function SummUserAdd(a,b,c,d,e,f)
    {
	    SummUserdata.push({
			UserName:a,
			InfuWork:b,
			ConWork:c,
			DosWork:d,
			FailWork:e,
			UserId:f
		});
    }
	
	function SummCTLocAdd(a,b,c,d,e)
	{
		SummCTLocdata.push({
			CTLoc:a,
			TotalInfuWork:b,
			TotalConWork:c,
			TotalDosWork:d,
			CTLocId:e
		});
	}
	
	var searchButton=new Ext.Toolbar.Button({
		text:'查询',
		tooltip:'查询',
		icon: '../images/uiimages/search.png',
		handler:function(){
			SummSearch();
		}
	});
	
	var PrintButton=new Ext.Toolbar.Button({
		text:'打印',
		tooltip:'打印',
		icon: '../images/uiimages/print.png',
		handler:function(){
			PrintWorkLoad(SummUsergrid);
		}
	});
	
	function PrintWorkLoad(grid)
	{
		//var fileName="c:\\"+"workload.xls";
		var fileName=path+"workload.xls";
		var xlsExcel=new ActiveXObject("Excel.Application");
		//xlsExcel.visible=true;
		xlsBook=xlsExcel.Workbooks.Add(fileName);
		xlsSheet=xlsBook.ActiveSheet;
		var cm=grid.getColumnModel(); 
        var colCount = cm.getColumnCount(); 
		var temp=[];
		for(i=0;i<colCount;i++)
		{
			if(cm.isHidden(i)==true){
			}else{
				temp.push(i);
			}
		}
		var sd=Ext.get("SDate").dom.value;
		var ed=Ext.get("EDate").dom.value;
		var ctlocId=session['LOGON.CTLOCID'];
		var hosp = cspRunServerMethod(GetHosp,ctlocId);
		xlsExcel.Range("A1:E2").value=hosp+"门诊输液工作量统计";
		xlsSheet.cells(3,2)=sd;
		xlsSheet.cells(3,4)=ed;
		var store=grid.getStore();
		var recordCount=store.getCount();
		var view=grid.getView();
		var row=5; //开始行
		var col=5; //总列数
		var ClearStr="A6:E41";
		var i,j=0;
		for (var i=0;i<=recordCount-1;i++)
		{
			j++;
			xlsSheet.cells(row+j,1)=view.getCell(i,0).innerText;
			xlsSheet.cells(row+j,2)=view.getCell(i,1).innerText;
			xlsSheet.cells(row+j,3)=view.getCell(i,2).innerText;
			xlsSheet.cells(row+j,4)=view.getCell(i,3).innerText;
			xlsSheet.cells(row+j,5)=view.getCell(i,4).innerText;
			var num=j%40;
			if (num==0)
			{
				xlsSheet.PrintOut;
				ClearContents (xlsSheet,ClearStr);
				j=0;
			}
			else{
				if (i==(recordCount-1))
				{
					xlsSheet.PrintOut;
				}
			}
		}
		xlsSheet = null;
		xlsBook.Close(savechanges=false);
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
	}
	
	function ClearContents (objSheet,str)
	{        
		objSheet.Range(str).ClearContents();
    	//objSheet.Range(objSheet.Cells(srow, c1), objSheet.Cells(erow,c2)).ClearContents();
	}

	function DetailSearch(UserId,CTLocId)
	{
		Detaildata=new Array();
		var sd=Ext.get("SDate").dom.value;
		var ed=Ext.get("EDate").dom.value;
		//alert(UserId);
		cspRunServerMethod(GetDetailsWork,UserId,CTLocId,sd,ed,'DetailAdd');
		Detailstore.loadData(Detaildata);
	}
	
	function DetailAdd(a,b,c,d,e,f)
    {
	    Detaildata.push({
			RegNo:a,
			PatName:b,
			ArcDesc:c,
			WorkItem:d,
			ExecDateTime:e,
			ExecUser:f
		});
    }
	
	var StDate=new Ext.form.DateField({
		id:'SDate',
		//format:'Y-m-d'
	});
	
	var EndDate=new Ext.form.DateField({
		id:'EDate',
		//format:'Y-m-d'
	});
		
	var dt = new Date();
    StDate.setValue(dt);
	EndDate.setValue(dt);
	
	var SummUserstore=new Ext.data.JsonStore({
		data:SummUserdata,
		fields:["UserName","InfuWork","ConWork","DosWork","FailWork","UserId"]
	});
	
	var SummCTLocstore=new Ext.data.JsonStore({
		data:SummCTLocdata,
		fields:["CTLoc","TotalInfuWork","TotalConWork","TotalDosWork","CTLocId"]
	});
	
	var Detailstore=new Ext.data.JsonStore({
		data:Detaildata,
		fields:["RegNo","PatName","ArcDesc","WorkItem","ExecDateTime","ExecUser"]
	});    
	
Ext.onReady(function(){
	
	var bd = Ext.getBody();
	 
	var gridForm = new Ext.FormPanel({
        id: 'company-form',
        frame: true,
        labelAlign: 'left',
        //title: '工作量查询',
        width: 880,
		height: 630,
        layout: 'border',        
	    border: false,  
		items:[
		{
        	region: 'center',
			layout: 'accordion',
            title: '汇总',
            split: true, 
		    autoScroll: true,
            collapsible: true, 
            titleCollapse: true,
			items:[SummUsergrid,SummCTLocgrid]
		},
		{
			region: 'south',
			layout: 'fit',
			title: '明细',
            split: true, 
			height: 250,
		    autoScroll: true,
            collapsible: true, 
            titleCollapse: true,
			items:[Detailsgrid]
		}
		],
		tbar:['开始时间','-',StDate,'结束时间','-',EndDate,'-',searchButton,'-',PrintButton],
		renderTo: bd
});

});

function FailChange(val)
{
	if (val>0)
	{
		return '<span style="color:red">' + val + '</span>';
	}
	return val
}

var SummUsergrid = new Ext.grid.GridPanel({
        store: SummUserstore,
        columns: [
        {header:'人员',width:100,sortable:true,dataIndex:'UserName'},
        {header:'输液',width:100,sortable:true,dataIndex:'InfuWork'},
        {header:'续液',width:100,sortable:true,dataIndex:'ConWork'},
		{header:'配液',width:100,sortable:true,dataIndex:'DosWork'},
		{header:'穿刺失误',width:100,sortable:true,renderer:FailChange,dataIndex:'FailWork'},
		{header:'UserId',width:200,hidden:true,sortable:false,dataIndex:'UserId'}
		],
        //autoExpandColumn: 2,
		title:'按医护人员汇总',
		//height: 400, 
		trackMouseOver: true,
        stripeRows: true,
	    sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners: 
				{
					"rowselect": function(sm, row, e){
					//Ext.MessageBox.alert(e.get('UserId'));
					DetailSearch(e.get('UserId'),"");
				}
			}
		}),
	    loadMask: true,
		//tbar:['开始时间','-',StDate,'结束时间','-',EndDate,'-',searchButton,'-'],
        stateful: true,
        stateId: 'grid'       
    });

var SummCTLocgrid=new Ext.grid.GridPanel({
		store: SummCTLocstore,
        columns: [
        {header:'科室',width:100,sortable:true,dataIndex:'CTLoc'},
        {header:'输液',width:100,sortable:true,dataIndex:'TotalInfuWork'},
        {header:'续液',width:100,sortable:true,dataIndex:'TotalConWork'},
		{header:'配液',width:100,sortable:true,dataIndex:'TotalDosWork'},
		{header:'CTLocId',width:100,hidden:true,sortable:true,dataIndex:'CTLocId'}
		],
        //autoExpandColumn: 2,
		title:'按科室汇总',
		//height: 400, 
		trackMouseOver: true,
        stripeRows: true,
	    sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners:{
				"rowselect":function(sm1,row1,e1){
					DetailSearch("",e1.get('CTLocId'));
				}
			}
		}),
	    loadMask: true,
        stateful: true,
        stateId: 'grid'       
});

function ItemChange(val)
{
	if(val=="配液")
	{
		return '<span style="color:green;">' + val + '</span>';
    }
	else if(val=="输液")
	{
		return '<span style="color:blue;">' + val + '</span>';
    }
	return val;
}
	
var Detailsgrid = new Ext.grid.GridPanel({
	    store: Detailstore,
        columns: [ 
		{header:'登记号',width:70,sortable:true,dataIndex:'RegNo'},
        {header:'病人姓名',width:70,sortable:true,dataIndex:'PatName'},
		{header:'医嘱',width:300,sortable:true,dataIndex:'ArcDesc'},
		{header:'工作量类型',width:100,sortable:true,renderer:ItemChange,dataIndex:'WorkItem'},
		{header:'执行时间',width:150,sortable:true,dataIndex:'ExecDateTime'},
		{header:'执行人',width:100,sortable:true,dataIndex:'ExecUser'}
		],
        //title: '明细',
        //height: 200, 
		trackMouseOver: true,
        stripeRows: true,
	    sm: new Ext.grid.RowSelectionModel({
			singleSelect: true}),
	    loadMask: true,
        stateful: true,
		stateId: 'grid'     
    });
	
SummUsergrid.addListener('rowcontextmenu', rightClickFn);


function rightClickFn(grid,dataIndex,e){
    e.preventDefault();
    //rightClick.showAt(e.getXY());
	var rightClick = new Ext.menu.Menu({
    id:'rightClickCont',
    items: [
        {
            //id: 'rMenu1',
            //handler: rMenu1Fn,
            text: '工作量分析',
			handler:function(){
				var record = grid.getStore().getAt(dataIndex);
				//alert(record.get('UserId'));
				
			}
        }
    ]
	});
   rightClick.showAt(e.getXY());
   
} 
