/**
 * *DHCNurOPPatInfuDetails.js
 * *Creator:liulei
 * *CreatDate:2010-07-15
 * *Description:病人输液查询
 */

	var myData=new Array();
	var CTLocId=session['LOGON.CTLOCID'];
	cspRunServerMethod(PatInfuDetails,CTLocId,"",'Search');
	
	function Search(a,b,c,d,e,f,g,h,i,j)
	{
		myData.push({
			RegNo:a,
			PatName:b,
			ArcDesc:c,
			Growth:d,
			DosAgeDT:e,
			DosAgeUser:f,
			ExecDT:g,
			ExecUser:h,
			FinishDT:i,
			FinishUser:j
		});
	}
	
	var growthColumn=new Ext.ux.grid.ProgressColumn({
		header:'输液进度',
		dataIndex:'Growth',
		width:100,
		textPst:'%',
		actionEvent:'click',
		colored:false,
		editor:new Ext.form.TextField()
	});

	//var store=new Ext.data.ArrayStore({
	//	fields:['RegNo','PatName','ArcDesc','Growth','DosAgeDT','DosAgeUser','ExecDT','ExecUser','FinishDT','FinishUser']
	//});
	
	var store=new Ext.data.JsonStore({
		data:myData,
		fields:["RegNo","PatName","ArcDesc","Growth","DosAgeDT","DosAgeUser","ExecDT","ExecUser","FinishDT","FinishUser"]
	});

	//store.loadData(myData);
	
	var cm=new Ext.grid.ColumnModel({
		defaults:{
			sortable:true
		},
		columns:[
		{
			header:'登记号',
			width:60,
			dataIndex:'RegNo'			
		},
		{
			header:'姓名',
			width:50,
			dataIndex:'PatName'
		},
		{
			header:'医嘱',
			width:180,
			dataIndex:'ArcDesc'
		},
		growthColumn,
		{
			header:'配液时间',
			width:110,
			dataIndex:'DosAgeDT'
		},
		{
			header:'配液人',
			width:50,
			dataIndex:'DosAgeUser'
		},
		{
			header:'输液开始时间',
			width:110,
			dataIndex:'ExecDT'
		},
		{
			header:'输液人',
			width:50,
			dataIndex:'ExecUser'
		},
		{
			header:'输液完成时间',
			width:110,
			dataIndex:'FinishDT'
		},
		{
			header:'完成人',
			width:50,
			dataIndex:'FinishUser'
		}
		]
	});
	
	var StDate=new Ext.form.DateField({
		id:'SDate',
		format:'Y-m-d'
	});
	
	var searchButton=new Ext.Toolbar.Button({
		text:'查询',
		tooltip:'查询',
		handler:function(){
			Search();
		}
	});
	
	
	setTimeout("beginrefresh()",60000);		//1000=1秒
	function beginrefresh()
	{
		window.location.reload();
                //store.reload();
	}
	
Ext.onReady(function(){

	//var myData=[
	//['001','张三','青霉素',73,'2010-07-10 09:10','龙胖子','2010-07-10 10:11','龙胖子','2010-07-10 13:00','龙胖子'],
	//['002','偶德俊','杜冷丁',67,'2010-07-12 09:10','龙胖子','2010-07-12 10:11','龙胖子','2010-07-12 13:00','龙胖子']
	//];
	
	var grid=new Ext.grid.GridPanel({
		store:store,
		cm:cm,
		renderTo:'grid-example',
		height:630,
		width:880,
		autoExpandColumn:true,
        stripeRows: true, 
		clicksToEdit:1
	});
})


