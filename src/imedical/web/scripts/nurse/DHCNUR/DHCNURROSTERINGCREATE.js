var REC=new Array();
var Height = document.body.clientHeight-2;
var Width = document.body.clientWidth-2;
//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);

Ext.MultiCellSelectionModel = Ext.extend(Ext.grid.CellSelectionModel, {
	last : false, // 上一次选中的单元格
	selections : [], // 选择区缓存
	constructor : function() {
		Ext.MultiCellSelectionModel.superclass.constructor.call(this);
	},
	initEvents : function() {
		Ext.MultiCellSelectionModel.superclass.initEvents.call(this);
		this.grid.on("mouseup",this.handlerMouseUp,this);
	},
	// 根据行列以及是否按住Ctrl键或者shift键，执行多选操作的逻辑
	handleMouseDown : function(grid, row, col, event) {
		var isSelected;
		var grid = Ext.getCmp("mygrid");
		var colCount=grid.getColumnModel().getColumnCount();
		if(event.button !== 0 || this.isLocked())
		return;
		if(event.shiftKey && this.last !== false) { //是否按下shift
			this.selectMatrix(row, col);
			grid.getView().focusCell(row, col);
			return;
		} else if(event.ctrlKey){ //是否按下ctrl
			isSelected = this.isSelected(row,col);
			if ((col === 0 && this.last[1] === 0)||col===1||col===2||col>=10){
				isSelected ? this.deselectRow(row) : this.selectRow(row,true);
			}
			if(isSelected){ // 是否已被选中，是则反选，否则选中
				this.deselectCell(row, col);
			} else {
				this.selectCell(row,col,true);
				this.last = [row, col];
			}
		} else if (col === 0||col===1||col===2||col>=10){ // 第一列是NumberColumn 点击则选择列
			this.selectRow(row);
			this.last = [row, col];
		} else { // 选择单个单元格
			this.selectCell(row,col);
			this.last = [row, col];
		}
		if(this.matrix)
		delete this.matrix;
	},
	// 清楚选择区内所以单元格被选中的样式
	clearCellSelections : function(){
		var l = this.selections.length,
		i = 0;
		for(; i < l; i++){
			cell = this.selections[i];
			this.grid.view.onCellDeselect(cell[0], cell[1]);// GridView的内置方法，改变某单元格样式
		}
		this.selections.length = 0;
	},
	// 反选指定单元格，并清除相应选择区缓存
	deselectCell : function(row, col, isDelrow){
		var l = this.selections.length,
		i = 0, n = 0;
		if(this.selections){
			this.grid.view.onCellDeselect(row, col);// GridView的内置方法，改变某单元格样式
			for(; i <l; i++){
				cell = this.selections[i];
				if( row !== cell[0] || col !== cell[1] ){
					this.selections[n++] = this.selections[i];
				} else if (!isDelrow) { // 是否删除行
					this.selections.splice(i,1);
					return;
				}
			}
			this.selections.length = n;
		}
	},
	// 根据选择区缓存中的数据，判断是否被选中
	isSelected : function(row, col){
		var l = this.selections.length,
		i = 0;
		for(; i < l; i++){
			cell = this.selections[i];
			if( row === cell[0] && col === cell[1] ){
				return true;
			}
		}
		return false;
	},
	// 选中某个单元格
	selectCell : function(rowIndex, colIndex, keepExisting, preventViewNotify, preventFocus){
		if(this.fireEvent("beforecellselect", this, rowIndex, colIndex) !== false){
			if(!keepExisting)
			this.clearCellSelections();
			this.selections.push([rowIndex, colIndex]); // 加入选择区缓存
			if(!preventViewNotify){
				var v = this.grid.getView();
				v.onCellSelect(rowIndex, colIndex); // GridView的内置方法，改变某单元格样式
				if(preventFocus !== true){
					v.focusCell(rowIndex, colIndex);
				}
			}
			this.fireEvent("cellselect", this, rowIndex, colIndex);
			this.fireEvent("selectionchange", this, this.selection);
		}
		Ext.getCmp("copybtn").enable();
		Ext.getCmp("pastebtn").enable();
		Ext.getCmp("rdeletebtn").enable();
	},
	// 选中某一行
	selectRow : function(rowIndex, keepExisting){
		var clen = this.grid.getColumnModel().getColumnCount(),
		c = 0;
		if(!keepExisting)// 是否清空所有已选择的单元格
		this.clearCellSelections();
		for(; c < clen; c++){
			this.selectCell(rowIndex, c, true);
		}
		Ext.getCmp("copybtn").disable();
		Ext.getCmp("pastebtn").disable();
		Ext.getCmp("rdeletebtn").disable();
	},
	// 某行反选
	deselectRow : function(row){
		var clen = this.grid.getColumnModel().getColumnCount(),
		c = 0;
		if(this.selections){
			for(; c < clen; c++){
				this.deselectCell(row, c, true);
			}
		}
	},
	// 按shift键调用的方法，选中一个矩形区域内所有的单元格
	selectMatrix : function(row, col, keepExisting){
		// 以上一次被选择的单元格为起点，形成一个矩阵区域
		var r = this.last[0],
		c = this.last[1];
		var grid = Ext.getCmp("mygrid");
		var colCount=grid.getColumnModel().getColumnCount();
		if(!keepExisting)
		this.clearCellSelections();
		if(r > row){
			var temp = row;
			row = r;
			r = temp;
		}
		if((col === 0 && c === 0)||col===1||col===2||col>=10){ // 若选择了第一列序号，则选择行
			for(; r <= row; r++){
				this.selectRow(r, true);
			}
			return;
		}
		if(c > col){
			var temp = col;
			col = c;
			c = temp;
		}
		if(c<3||c>10||col>10||col<3) return;
		for(; r <= row; r++){
			for(var i = c; i <= col; i++){
				this.selectCell(r, i, true);
			}
		}
		this.matrix = { // 矩形区域选择区数据
			start : [r, c],
			end : [row, col]
		};
	},
	handlerMouseUp:function(e,cell,p)
	{
		if(e.button==2) return;
		if(cell.parentElement.tagName=="TD")
		{
			var td=cell.parentElement;
			var col=td.cellIndex;
			//var tr=cell.parentElement.parentElement;
			var row=td.parentNode.cells[0].innerText-1;
			this.selectMatrix(row, col);
			//grid.getView().focusCell(row, col);
		}
	}
});
var ModelCombo = new Ext.form.ComboBox({
	id:'ModelCombo',
 	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'ModelName',
				'mapping':'ModelName'
			},{
				'name':'ModelId',
				'mapping':'ModelId'
			}]
		}),
		baseParams:{
			className:'DHCMGNUR.MgNurRosterModel',
			methodName:'FindModelData',
			type:'RecQuery'
		},
		listeners:{ 
			beforeload:function(tstore,e){ 
				tstore.baseParams.parr=Ext.getCmp('WardCombo').getValue();
			}
		}
	}),
	//tabIndex:0,
	listWidth:200,
	//height:18,
	width:150,xtype : 'combo',
	displayField : 'ModelName',valueField : 'ModelId',hideTrigger : false,queryParam : '',triggerAction : 'all',
	minChars : 1,pageSize : 10,typeAhead : false,typeAheadDelay : 1000,loadingText : 'Searching...'
});
var WardCombo = new Ext.form.ComboBox({
	id:'WardCombo',
 store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
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
		},
		listeners:{ 
			beforeload:function(tstore,e){ 
				tstore.baseParams.parr=Ext.getCmp('WardCombo').lastQuery;
			}
		}
	}),
	//tabIndex:'0',
	//listWidth:200,
	height:18,width:150,xtype : 'combo',
	displayField : 'WardDesc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
	minChars : 1,pageSize : 10,typeAhead : false,typeAheadDelay : 1000,loadingText : 'Searching...',
	listeners:{
		select:function(){
			ModelCombo.setValue('');
			ModelCombo.store.load({params:{start:0,limit:10}});
		}
	}
});
var contextmenu=new Ext.menu.Menu({
	id:'theContextMenu',
	plain:true,
	items:[{
			text:'排班',
 			//iconCls:'ContextMenuBtn1',
 			icon:'../images/uiimages/createschedule.png',
 			handler:function(){ChoosePostData('P');}
		},{
			text:'追加排班',
 			//iconCls:'ContextMenuBtn2',
 			icon:'../images/uiimages/schedule-plus.png',
 			handler:function(){ChoosePostData("AP");}
		},{
			text:'休班',
			icon:'../images/uiimages/schedule-minus.png',
 			//iconCls:'ContextMenuBtn3',
 			handler:function(){ChooseHolidayData()}
		},(new Ext.menu.Menu()).addSeparator(),{
			text:'加班',
 			//iconCls:'ContextMenuBtn4',
 			icon:'../images/uiimages/schedule-clock.png',
 			handler:function(){CreateOverTime();}
		},{
			text:'休息',
 			//iconCls:'ContextMenuBtn5',
 			hidden:true,
 			handler:function(){CreateRosterRest();}
		},(new Ext.menu.Menu()).addSeparator(),{
			text:'复制',
			id:'copybtn',
			icon:'../images/uiimages/ordcopy.png',
 			//iconCls:'ContextMenuBtn5',
 			handler:function(){copyRosterData();}
		},{
			text:'粘贴',
 			//iconCls:'ContextMenuBtn5',
 			icon:'../images/uiimages/paste.png',
 			id:'pastebtn',
 			handler:function(){pasteRosterData();findRec();}
		},{
			text:'删除',
 			//iconCls:'ContextMenuBtn5',
 			icon:'../images/uiimages/wastebin.png',
 			id:'rdeletebtn',
 			handler:function(){if(confirm("确认删除？")){ deleteRosterData();}}
		}]
});

function BodyLoadHandler()
{	
	createGrid();
}
function createGrid()
{
	var gform = Ext.getCmp("gform"); 
	var grid = createPanel();
	gform.add(grid);
	gform.doLayout();
	var mygrid = Ext.getCmp("mygrid");
	var tobar = mygrid.getTopToolbar();
	tobar.addItem("-");
	tobar.addItem("病区",WardCombo);
	var GroupDesc = session['LOGON.GROUPDESC'];
	if(secGrpFlag=="nurhead")
	{
		var WardId = session['LOGON.CTLOCID'];
		WardCombo.setValue(WardId);
		WardCombo.disable();
		//getNurseInfo();
		ModelCombo.store.loadData(getModelArrray());
	}
	tobar.addItem("-");
	tobar.addItem("模板",ModelCombo);
	tobar.addItem("-");
	tobar.addButton({id:'newbtn',text:'增加模板',icon:'../images/uiimages/edit_add.png',handler:function(){NewModel();}});
	tobar.addItem("-");
	tobar.addButton({id:'findbtn',text:'查询',icon:'../images/uiimages/search.png',handler:function(){createGrid();setTimeout('findRec()',1);}});
//	tobar.addItem("-");
//	tobar.addButton({id:'printbtn',text:'打印',handler:function(){PrintAJMData();}});
	//tobar.addItem("-");
	//tobar.addButton({id:'exportbtn',text:'导出',handler:function(){ExportAJMData();}});
	var bbar = mygrid.getBottomToolbar ();
	bbar.hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:200,
		store:mygrid.store,
		//hidden:true,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(mygrid.bbar);
	tobar.doLayout();
}
function createTable()
{
	var colModel = new Ext.grid.ColumnModel([ 
		new Ext.grid.RowNumberer(),
		{header: '工号', width: 50, sortable: false,dataIndex: 'NurseID',align:'center'},
		{header: '姓名', width: 60, sortable: false,dataIndex: 'NurseName',align:'center'},
		{header: '星期一', width: 70, sortable: false,dataIndex: 'Monday',align:'center'},
		{header: '星期二', width: 70, sortable: false,dataIndex: 'Tuesday',align:'center'},
		{header: '星期三', width: 70, sortable: false,dataIndex: 'Wednesday',align:'center'},
		{header: '星期四', width: 70, sortable: false,dataIndex: 'Thursday',align:'center'},
		{header: '星期五', width: 70, sortable: false,dataIndex: 'Friday',align:'center'},
		{header: '星期六', width: 70, sortable: false,dataIndex: 'Saturday',align:'center'},
		{header: '星期日', width: 70, sortable: false,dataIndex: 'Sunday',align:'center'},
		{header: '备注', width: 70, sortable: false,dataIndex: 'Remarks',align:'center'},
		{header: '班数', width: 50, sortable: false,dataIndex: 'WorkNum',align:'center'},
		{header: '夜班数', width: 50, sortable: false,dataIndex: 'NigthNum',align:'center'},
		{header: '类型', width: 50, sortable: false,dataIndex: 'NurseType',align:'center'}
	]);
	var store = new Ext.data.Store({
 		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
   	reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
   		fields:[{'name':'NurseID','mapping':'NurseID'},
   			{'name':'NurseName','mapping':'NurseName'},
   			{'name':'Monday','mapping':'Monday'},
   			{'name':'Tuesday','mapping':'Tuesday'},
   			{'name':'Wednesday','mapping':'Wednesday'},
   			{'name':'Thursday','mapping':'Thursday'},
   			{'name':'Friday','mapping':'Friday'},
   			{'name':'Saturday','mapping':'Saturday'},
   			{'name':'Sunday','mapping':'Sunday'},
   			{'name':'Remarks','mapping':'Remarks'},
   			{'name':'WorkNum','mapping':'WorkNum'},
   			{'name':'NigthNum','mapping':'NigthNum'},
   			{'name':'NurseType','mapping':'NurseType'}]
   	}),
   	baseParams:{className:'DHCMGNUR.MgNurArrangeJobModel',methodName:'QueryAJMData',type:'RecQuery'},
    listeners:{
    	beforeload:function(thisstore){
    		var WardId=WardCombo.getValue();
				var parr = ModelCombo.getValue()+"^"+WardId;
				thisstore.baseParams.parr=parr;
			},
    	load:function(mystore,recodes,o) {
   			var RCount=mystore.getTotalCount();
   			var CCount=table.getColumnModel().getColumnCount();
      	var view=table.getView();
      	var WardId=WardCombo.getValue();
				var parr = WardId+"^"+ModelCombo.getValue();
      	var ret=tkMakeServerCall("DHCMGNUR.MgNurArrangeJobModel","GetDataType",parr);
      	var array=SplitStr(ret);
      	for(var svi=0;svi<RCount;svi++)
      	{
      		if(mystore.getAt(svi)==undefined) return; 
      		var NurseId=mystore.getAt(svi).get('NurseID');
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
      		for(var cvi=3;cvi<CCount-4;cvi++)
      		{
	      		var arrindex= NurseId+'-'+table.getColumnModel().getDataIndex(cvi).toUpperCase();
	      		cell=view.getCell(svi,cvi);
	      		if(array[arrindex]=="H"){
	      			cell.style.backgroundColor='#FFFF99';
	      		}
	      		if((array[arrindex]=="H-J")||(array[arrindex]=="P-N")){
	      			
	      			cell.style.color='#FF0000';
	      		}
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
		selModel:new Ext.MultiCellSelectionModel(),
		tbar:[],
		bbar: new Ext.PagingToolbar({ 
        pageSize: 200, 
        store: store, 
        displayInfo: true, 
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
        emptyMsg: "没有记录" 
    }),
    listeners:{
    	cellcontextmenu:function(grid,row,col,e){
    		e.preventDefault();
				if(secGrpFlag!='nurse'){
					if(2<=col&&col<=9)
					{
						var Status=Ext.getCmp("mygrid").getSelectionModel().isSelected(row,col);
						var Status2=Ext.getCmp("mygrid").getSelectionModel().isSelected(row,1);
						if(Status&&!Status2)
						{
							contextmenu.showAt(e.getXY());
						}
					}
				}
    	}
    }
	});
	return table;
}
function createPanel()
{
	var table = createTable(); 
	var panel = new Ext.Panel({
		region: 'center',
		margins:'3 3 3 0',
		activeTab: 0,
		x:0,y:0,
		border:false,
		height: document.body.clientHeight-5,
		width: document.body.clientWidth-3,
		defaults:{autoScroll:true},
		items:[table]
	});
	return panel;
}

function createPostTable()
{
	var colModel = new Ext.grid.ColumnModel([
		{ header: "代码", width: 100, sortable: true,dataIndex: 'PostCode'},
    { header: "描述", width: 100, sortable: true,dataIndex: 'PostDesc'},
    { header: "班次类型", width: 80, sortable: true,dataIndex: 'TypeDesc'},
    { header: "小时数", width: 60, sortable: true,dataIndex: 'PostHours'},
    { header: "PostID", width: 0, sortable: true, dataIndex: 'PostID',hidden:true}
 	]);
	var store = new Ext.data.Store({
 		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
   	reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
   		fields:[{'name':'PostCode','mapping':'PostCode'},
   			{'name':'PostDesc','mapping':'PostDesc'},
   			{'name':'TypeDesc','mapping':'TypeDesc'},
   			{'name':'PostHours','mapping':'PostHours'},
   			{'name':'PostID','mapping':'PostID'}
   		]
   	}),
   	baseParams:{className:'DHCMGNUR.MgNurPost',methodName:'FindPostData',type:'RecQuery'},
    listeners:{
    	beforeload:function(thisstore){
				thisstore.baseParams.parr=WardCombo.getValue()+"^N";
			}
		}
	});
	var table = new Ext.grid.GridPanel({
		id:'mygrid2',
		x:0,y:0,
		width: 330,
		height: 450,
		store: store,
		tbar:[],
		cm: colModel,
		bbar: new Ext.PagingToolbar({ 
      pageSize: 200, 
      store: store,
      //hidden:true,
      displayInfo: true, 
      displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
      emptyMsg: "没有记录" 
    })
	});
	return table;
}
function CreateRoster()
{
	var table = createPostTable();
	var window= new Ext.Window({
		title : '',
		id : "CreateRosterWin",
		x:60,y:40,
		width : 345,
		height : 486,
		autoScroll : true,
		modal:true,
		layout : 'absolute',
		items : [table],
		resizable:false
	});
	return window;
}
function CreateHolidayTable()
{
	var colModel = new Ext.grid.ColumnModel([
		{ header: "代码", width: 70, sortable: true,dataIndex: 'HolidayCode'},
    { header: "名称", width: 70, sortable: true,dataIndex: 'HolidayDesc'},
    { header: "日小时数", width: 80, sortable: true,dataIndex: 'HolidayHours'},
    { header: "rw", width: 0, sortable: true, dataIndex: 'rw',hidden:true}
 	]);
	var store = new Ext.data.Store({
 		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
   	reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
   		fields: [
      {'name': 'HolidayCode','mapping':'HolidayCode'},
      {'name': 'HolidayDesc','mapping':'HolidayDesc'},
      {'name': 'HolidayHours','mapping':'HolidayHours'},
      {'name': 'rw','mapping':'rw'}
    ]
   	}),
   	baseParams:{className:'DHCMGNUR.MgNurHolidayCode',methodName:'FindHolidayData',type:'RecQuery'},
    listeners:{
    	beforeload:function(thisstore){
				thisstore.baseParams.parr="N";
			}
		}
	});
	var table = new Ext.grid.GridPanel({
		id:'mygrid3',
		x:0,y:0,
		width: 255,
		height: 550,
		store: store,
		tbar:[],
		cm: colModel,
		bbar: new Ext.PagingToolbar({ 
      pageSize: 200, 
      store: store,
      //hidden:true,
      displayInfo: true, 
      displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
      emptyMsg: "没有记录" 
    })
	});
	return table;
}
function CreateHoliday()
{	
	var table = CreateHolidayTable();
	var window= new Ext.Window({
		title : '',
		id : "CreateHolidayWin",
		x:60,y:40,
		width : 270,
		height : 585,
		autoScroll : true,
		modal:true,
		layout : 'absolute',
		items : [table],
		resizable:false
	});
	return window;
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

function ChoosePostData(postType)
{
	if(Ext.getCmp('CreateRosterWin')!=null){Ext.getCmp('CreateRosterWin').close();}
	var window = CreateRoster();
	window.setTitle("岗位代码");
	window.show();
	Ext.getCmp("mygrid2").store.load({start:0,limit:200});
	var mygrid = Ext.getCmp("mygrid2");
	var tobar = mygrid.getTopToolbar();
	var tobar2=new Ext.Toolbar();
	tobar.addItem("-");
	tobar.addItem(new Ext.form.Checkbox({id:'halfday1',boxLabel:'上午'}));
	tobar.addItem(new Ext.form.Checkbox({id:'halfday2',boxLabel:'下午'}));
	tobar.addItem("-");
	tobar.addItem(new Ext.Button({id:'checkbtn',icon:'../images/uiimages/ok.png',text:'选择',handler:function(){WritePostData(postType);window.hide();}}));
	tobar2.addItem("-");
	tobar2.addItem(new Ext.form.Label({id:'remarklabel',text:'备注'}));
	tobar2.addItem(new Ext.form.TextField({id:'remarktext',width:200}));
	tobar2.render(mygrid.tbar);
	tobar.doLayout();
	mygrid.on('rowdblclick',function(){WritePostData(postType);window.hide();});
}
function ChooseHolidayData()
{
	var window = CreateHoliday();
	Ext.getCmp("mygrid3").store.load({params:{start:0,limit:200}});
	window.setTitle("假期代码");
	window.show();
	var mygrid = Ext.getCmp("mygrid3");
	var tobar = mygrid.getTopToolbar();
	tobar.addItem("-");
	tobar.addItem(new Ext.Button({id:'checkbtn',text:'选择',icon:'../images/uiimages/ok.png',handler:function(){if(WriteHolidayData()) window.close();}}));
	tobar.addItem("-");
	tobar.doLayout();
	//mygrid.on('rowdblclick',function(){if(WriteHolidayData()) window.close();});
}

function WritePostData(postType)
{
	var mygrid = Ext.getCmp("mygrid");
	var mygrid2 = Ext.getCmp("mygrid2");
	var rowObj = mygrid2.getSelectionModel().getSelections();
	var selectedRow = mygrid2.getSelectionModel().getSelected();
	if (rowObj.length == 0)
	{
		Ext.Msg.alert('提示',"请选择一条记录!");
		return false;
	}
	var PostId = selectedRow.get("PostID");
	var PostHalfDay1 = Ext.getCmp("halfday1").getValue();
	var PostHalfDay2 = Ext.getCmp("halfday2").getValue();
	var selections=mygrid.getSelectionModel().selections;
	var cm=mygrid.getColumnModel();
	for(var i=0;i<selections.length;i++)
	{
		var cell=selections[i];
		var row = cell[0];
		var col = cell[1];
		var cellValue = mygrid.getStore().getAt(row).get(cm.getDataIndex(col));
		if(cellValue=="")
		{
			if(postType=="AP"){
				//Ext.Msg.alert('提示',"如要追加排班,请点击右键，选择追加排班!");
				Ext.Msg.alert('提示',"如要追加排班,请选择已进行排班单元格进行此操作！");
				return false;
			}
		}
		else{
			if(postType=="P"){
				//Ext.Msg.alert('提示',"如要追加排班,请点击右键，选择追加排班!");
				Ext.Msg.alert('提示',"如要追加排班,请选择已进行排班单元格进行此操作！");
				return false;
			}
		}
		//护士^班次^班次类型^班次日期^班次开始时间^班次结束时间^备注^排班护士长
		var NurseId = mygrid.getStore().getAt(row).get("NurseID");
		var halfDay="H";
		if(PostHalfDay1) halfDay="A";//上午
		if(PostHalfDay2) halfDay="P";//下午
		var RemarkText = Ext.getCmp("remarktext").getValue();
		var parrStr=NurseId+"^"+PostId+"^Post^"+cm.getDataIndex(col)+"^^^"+RemarkText+"^"+session['LOGON.USERCODE']+"^"+halfDay;
		//alert(parrStr);
		saveRec(parrStr);
	}
	//Ext.getCmp('CreateRosterWin').close();
	return true;
}
function WriteHolidayData()
{
	var mygrid = Ext.getCmp("mygrid");
	var mygrid3 = Ext.getCmp("mygrid3");
	var rowObj = mygrid3.getSelectionModel().getSelections();
	var selectedRow = mygrid3.getSelectionModel().getSelected();
	if (rowObj.length == 0)
	{
		Ext.Msg.alert('提示',"请选择一条记录!");
		return false;
	}
	var Holiday = selectedRow.get("rw");
	var HolidayName = selectedRow.get("HolidayName");
	var selections=mygrid.getSelectionModel().selections;
	var cm=mygrid.getColumnModel();
	for(i=0;i<selections.length;i++)
	{
		var cell=selections[i];
		var rowIndexNum = cell[0];
		var cellIndexNum = cell[1];
		var cellValue = mygrid.getStore().getAt(rowIndexNum).get(cm.getDataIndex(cellIndexNum));
		//护士^班次^班次类型^班次日期^班次开始时间^班次结束时间^备注^排班护士长
		var NurseId = mygrid.getStore().getAt(rowIndexNum).get("NurseID");
		var halfDay="H";
		var parrStr=NurseId+"^"+Holiday+"^Holiday^"+cm.getDataIndex(cellIndexNum)+"^^^^"+session['LOGON.USERCODE']+"^"+halfDay;
		saveRec(parrStr);
	}
	return true;
}

function NewModel()
{
	var WardId = WardCombo.getValue();
	if(WardId=="")
	{
		Ext.Msg.alert('提示',"请先选择病区");
		return;
	}
	var window = new Ext.Window({
		id:'createmodelname',
		title:'保存模板',
		width:250,
		height:100,
		x:250,y:120,
		renderTo: Ext.getBody(),
		modal:true,
		layout:'absolute',
		items:[
			new Ext.form.Label({
				id:'modelLabel',
				x:10,y:5,
				text:'模板名称',
				width:60,
				style: 'margin-top:10px;margin-left:10px'
			}),
			new Ext.form.TextField({
				id:'modelName',
				x:80,y:10,
				width:150
			}),
			new Ext.Button({
				id:'modelbtn',
				x:130,y:36,
				text:'保存',
				icon:'../images/uiimages/filesave.png',
				width:100,
				//style: 'margin-top:5px;margin-left:120px',
				handler:function(){
					var modelName = Ext.getCmp("modelName").getValue();
					if(!modelName){Ext.Msg.alert('提示','模板名不能为空！');return;}
					var WardId = WardCombo.getValue();
					var parr = modelName+"^"+WardId;
					var SaveModelData = document.getElementById("SaveModelData");
					var ret = cspRunServerMethod(SaveModelData.value,parr)
					if(ret!="fail"){ 
						ModelCombo.store.load({params:{start:0,limit:100},callback:function(){ModelCombo.setValue(ret);findRec();}});
						//findRec();
					}
					else{
						Ext.Msg.alert('提示',"保存失败！")
					}
					
					window.close();
				}
			})
		]
	});
	window.show();
}
function CreateOverTime()
{
	var window = new Ext.Window({
			id:'createovertime',
			title:'加班',
			width:270,
			height:200,
			x:250,y:120,
			renderTo: Ext.getBody(),
			modal:true,
			layout: 'absolute',
			resizable:false,
			items:[
				new Ext.form.Label({
					id:'StDateLabel',
					text:'开始日期',
					width:60,
					x:10,y:10
				}),
				new Ext.form.DateField({
					id:'StDate',
					x:80,y:10,
					width:150,
					//format:'Y-m-d',
					value:new Date()
				}),
				new Ext.form.Label({
					id:'StTimeLabel',
					text:'开始时间',
					width:60,
					x:10,y:40
				}),
				new Ext.form.TimeField({
					id:'StTime',
					x:80,y:40,
					width:150,
					increment:30,
					value:new Date(),
					format:'H:i'
				}),
				new Ext.form.Label({
					id:'EndDateLabel',
					text:'结束日期',
					width:60,
					x:10,y:70
				//	style: 'margin-top:10px;margin-left:10px'
				}),
				new Ext.form.DateField({
					id:'EndDate',
					//format:'Y-m-d',
					x:80,y:70,
					width:150,
					value:new Date()
				}),
				new Ext.form.Label({
					id:'EndTimeLabel',
					text:'结束时间',
					width:60,
					x:10,y:100
					//style: 'margin-top:10px;margin-left:10px'
				}),
				new Ext.form.TimeField({
					id:'EndTime',
					x:80,y:100,
					width:150,
					increment:30,
					value:new Date(),
					format:'H:i'
				}),
				new Ext.Button({
					id:'overtimebtn',
					text:'确定',
					width:100,
					icon:'../images/uiimages/ok.png',
					x:130,y:130,
					//style: 'margin-top:5px;margin-left:120px',
					handler:function(){
						WriteOverTimeData();
						window.close();
					}
				})
			]
		});
		window.show();
}

function WriteOverTimeData()
{
	var mygrid = Ext.getCmp("mygrid");
	var OverTimeStDate = Ext.getCmp("StDate").getValue();
	var OverTimeStTime = Ext.getCmp("StTime").getValue(); 
	var OverTimeEndDate = Ext.getCmp("EndDate").getValue();
	var OverTimeEndTime = Ext.getCmp("EndTime").getValue(); 
	var OverTimeValue="";
	if(OverTimeStDate.format('Y-m-d')>OverTimeEndDate.format('Y-m-d')){
		Ext.Msg.alert("提示","开始日期不能大于结束日期!");
		return;
	}else{
		if(OverTimeStDate.format('Y-m-d')==OverTimeEndDate.format('Y-m-d')){
			if(OverTimeStTime>=OverTimeEndTime){
				Ext.Msg.alert("提示","开始时间不能大于或等于结束时间!");
				return;
			}else{
				var OTSTime = OverTimeStTime.toString().split(':');
				var OTETime = OverTimeEndTime.toString().split(':');
				var OverTimeNum=parseFloat(OTETime[0])+parseFloat(OTETime[1])/60-parseFloat(OTSTime[0])-parseFloat(OTSTime[1])/60;
				OverTimeValue="加"+OverTimeNum.toFixed(1);
//				var OverTimeNum2=Math.round(OverTimeNum);
//				if(OverTimeNum%1>0.5) OverTimeValue="加"+OverTimeNum2;
//				else if(OverTimeNum%1==0.5) OverTimeValue="加"+OverTimeNum;
//				else OverTimeValue="加"+(OverTimeNum2+0.5);
			}
		}else{
			var OTSTime = OverTimeStTime.toString().split(':');
			var OTETime = OverTimeEndTime.toString().split(':');
			var OverTimeNum=24+parseFloat(OTETime[0])+parseFloat(OTETime[1])/60-parseFloat(OTSTime[0])-parseFloat(OTSTime[1])/60;
			OverTimeValue="加"+OverTimeNum.toFixed(1);
//			var OverTimeNum2=Math.round(OverTimeNum);
//			if(OverTimeNum%1>0.5) OverTimeValue="加"+OverTimeNum2;
//			else if(OverTimeNum%1==0.5) OverTimeValue="加"+OverTimeNum;
//			else OverTimeValue="加"+(OverTimeNum2+0.5);
		}
	}
	var selections=mygrid.getSelectionModel().selections;
	var cm=mygrid.getColumnModel();
	for(i=0;i<selections.length;i++){
		var cell=selections[i];
		var rowIndexNum = cell[0];
		var cellIndexNum = cell[1];
		var cellValue = mygrid.getStore().getAt(rowIndexNum).get(cm.getDataIndex(cellIndexNum));
		//护士^班次^班次类型^班次日期^班次开始时间^班次结束时间^备注^排班护士长
		var NurseId = mygrid.getStore().getAt(rowIndexNum).get("NurseID");
		var parrStr=NurseId+"^"+OverTimeValue+"^OverTime^"+cm.getDataIndex(cellIndexNum)+"^"+OverTimeStTime.toString()+"^"+OverTimeEndTime.toString()+"^^"+session['LOGON.USERCODE']+"^H";
		saveRec(parrStr);
	}
}

function deleteRosterData()
{
	var mygrid = Ext.getCmp("mygrid");
	var modelid=ModelCombo.getValue();
	var selections=mygrid.getSelectionModel().selections;
	var cm=mygrid.getColumnModel();
	for(i=0;i<selections.length;i++)
	{
		var cell=selections[i];
		var rowIndexNum = cell[0];
		var cellIndexNum = cell[1];
		var cellValue = mygrid.getStore().getAt(rowIndexNum).get(cm.getDataIndex(cellIndexNum));
		if(cellValue!="")
		{
			//mygrid.getStore().getAt(rowIndexNum).set(CheckWeek(cellIndexNum),"");
			var DeleteAJMData=document.getElementById("DeleteAJMData");
			var NurseId = mygrid.getStore().getAt(rowIndexNum).get("NurseID");
			var parr=modelid+"^"+WardCombo.getValue()+"^"+NurseId+"^"+cm.getDataIndex(cellIndexNum);
			var ret = cspRunServerMethod(DeleteAJMData.value,parr);
		}
		//alert(ret);
	}
	findRec();
}

function CreateRosterRest()
{
	//getHolidayData();
	var window = new Ext.Window({
			id:'CreateRosterRest',
			title:'休息',
			width:270,
			height:160,
			x:250,y:130,
			renderTo: Ext.getBody(),
			modal:true,
			layout: 'absolute',
			items:[
				new Ext.form.Label({
					id:'RosterRestLabel',
					text:'假期',
					width:60,
					x:10,y:10
				}),
				new Ext.form.ComboBox({
					id:'RestCombo',x:80,y:10,
					store:new Ext.data.Store({
						proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
						reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
							fields:[{'name':'HolidayDesc','mapping':'HolidayDesc'},{'name':'rw','mapping':'rw'}]
						}),
						baseParams:{className:'DHCMGNUR.MgNurHolidayCode',methodName:'FindHolidayData',type:'RecQuery'},
						listeners:{
							beforeload:function(tstore,e){ tstore.baseParams.parr="N"; }
						}
					}),
					listWidth:200,width:150,xtype : 'combo',mode:'local',
					displayField : 'HolidayDesc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
					minChars : 1,pageSize : 10,typeAhead : false,typeAheadDelay : 1000,loadingText : 'Searching...'
				}),
				/*new Ext.form.Label({
					id:'StDateLabel',
					text:'开始日期:',
					width:60,
					x:10,y:40
				}),
				new Ext.form.DateField({
					id:'StDate',
					x:80,y:40,
					width:150,
					format:'Y-m-d',
					value:new Date()
				}),*/
				new Ext.form.Label({
					id:'StTimeLabel2',
					text:'开始时间',
					width:60,
					x:10,y:40
				}),
				new Ext.form.TimeField({
					id:'StTime2',
					x:80,y:40,
					width:150,
					increment:30,
					value:new Date(),
					format:'H:i'
				}),
				/*new Ext.form.Label({
					id:'EndDateLabel',
					text:'结束日期:',
					width:60,
					x:10,y:100
				//	style: 'margin-top:10px;margin-left:10px'
				}),
				new Ext.form.DateField({
					id:'EndDate',
					format:'Y-m-d',
					x:80,y:100,
					width:150,
					value:new Date()
				}),*/
				new Ext.form.Label({
					id:'EndTimeLabel2',
					text:'结束时间',
					width:60,
					x:10,y:70
					//style: 'margin-top:10px;margin-left:10px'
				}),
				new Ext.form.TimeField({
					id:'EndTime2',
					x:80,y:70,
					width:150,
					increment:30,
					value:new Date(),
					format:'H:i'
				}),
				new Ext.Button({
					id:'rosterRestbtn2',
					text:'确定',
					width:100,
					x:130,y:100,
					//style: 'margin-top:5px;margin-left:120px',
					handler:function(){
						WriteRosterRest();
						window.close();
					}
				})
			]
		});
		window.show();
		Ext.getCmp("RestCombo").store.load({params:{start:0,limit:20}});
}
function WriteRosterRest()
{
	var mygrid = Ext.getCmp("mygrid");
	var RestCombo = Ext.getCmp("RestCombo");
	var RestComboId = RestCombo.getValue();
	var RestComboDesc = RestCombo.getRawValue();
	var RestStTime = Ext.getCmp("StTime2").getValue(); 
	var RestEndTime = Ext.getCmp("EndTime2").getValue(); 
	if(RestStTime>=RestEndTime)
	{
		Ext.Msg.alert("提示","开始时间不能大于或等于结束时间!");
		return;
	}
	var selections=mygrid.getSelectionModel().selections;
	var cm=mygrid.getColumnModel();
	for(i=0;i<selections.length;i++)
	{
		var cell=selections[i];
		var rowIndexNum = cell[0];
		var cellIndexNum = cell[1];
		var cellValue = mygrid.getStore().getAt(rowIndexNum).get(cm.getDataIndex(cellIndexNum));
		//护士^班次^班次类型^班次日期^班次开始时间^班次结束时间^备注^排班护士长
		var NurseId = mygrid.getStore().getAt(rowIndexNum).get("NurseID");
		var parrStr=NurseId+"^"+RestComboId+"^Rest^"+cm.getDataIndex(cellIndexNum)+"^"+RestStTime.toString()+"^"+RestEndTime.toString()+"^^"+session['LOGON.USERCODE']+"^H";
		saveRec(parrStr);
	}
}

function saveRec(parrStr)
{
	var WardId=WardCombo.getValue();
	var ModelId=ModelCombo.getValue();
	if(ModelId=="")
	{
		Ext.Msg.alert("提示",'请先点击"新建"按钮,创建模板');
		return;
	}
	var parr = WardId+"^"+ModelId+"^"+parrStr;
	var SaveAJMData = document.getElementById("SaveAJMData");
	var ret = cspRunServerMethod(SaveAJMData.value,parr);
	findRec();
}

function findRec()
{
	var WardId=WardCombo.getValue();
	var ModelId=ModelCombo.getValue();
	if(WardId==""){Ext.Msg.alert('提示',"请选择病区！"); return;}
	if(ModelId==""){Ext.Msg.alert('提示',"请选择模板！"); return;}
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({params:{start:0,limit:200}});
}

function ExportAJMData()
{
	//FindArgJobModelData3();
	var mygrid = Ext.getCmp("mygrid");
	try {
		var xls = new ActiveXObject("Excel.Application");
	} catch (e) {
		Ext.Msg.alert('提示',"要导出该表，您必须安装Excel电子表格软件，同时浏览器须使用“ActiveX 控件”，您的浏览器须允许执行控件。 请点击【帮助】了解浏览器设置方法！");
		return "";
	}
	var cm = mygrid.getColumnModel();
	var colCount = cm.getColumnCount();
	//alert('总列数：'+colCount);
	xls.visible = false; // 设置excel为可见
	var xlBook = xls.Workbooks.Add;
	//xlBook.name="aaa";
	var xlSheet = xlBook.Worksheets(1);
	var temp_obj = [];
	// 只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示)
	for (i = 0; i < colCount; i++) {
		if (cm.isHidden(i) == true) {
		} else {
			temp_obj.push(i);
		}
	}
	xlSheet.Range("A1:L1").MergeCells=true;
	xlSheet.Cells(1,1).HorizontalAlignment  = 3;//居中
	xlSheet.Cells(1,1).Font.Size=20;
	xlSheet.Cells(1,1).Value = "****医院";
	xlSheet.Range("A2:L2").MergeCells=true;
	xlSheet.Cells(2,1).Font.Size=14;
	xlSheet.Cells(2,1).HorizontalAlignment  = 3;
	xlSheet.Cells(2,1).Value = "排班模板信息";
	xlSheet.Rows(4).Font.Size=10;
	xlSheet.Range("A3:L3").MergeCells = true;
	xlSheet.Range("A4:L4").MergeCells = true;
	xlSheet.Cells(4,1).Font.Size=12;
	xlSheet.Cells(4,1)="病区:"+WardCombo.getRawValue()+"           模板:"+ModelCombo.getRawValue();
	for (l = 1; l <= temp_obj.length; l++) {
		xlSheet.Cells(5,l).HorizontalAlignment  = 3;
		xlSheet.Cells(5,l).Font.Size=10;
		//xlSheet.Cells(5,l).Font.Color='red';
		xlSheet.Cells(5,l).Value = cm.getColumnHeader(temp_obj[l-1]);
	}
	var store = mygrid.getStore();
	var recordCount = store.getCount();
	if(recordCount==0)
	{
		Ext.Msg.alert("提示","没有数据");
		return;
	}
	//alert("记录总数："+recordCount);
	//alert('总列数：'+temp_obj.length);
	var view = mygrid.getView();
	for (k = 1; k <= recordCount; k++) {
		//alert('k-'+k);
		xlSheet.Rows(k + 5).Font.Size=10;
		xlSheet.Rows(k + 5).HorizontalAlignment  = 3;
		xlSheet.Rows(k + 5).WrapText = true;
		for (j = 1; j < temp_obj.length; j++) {
			// EXCEL数据从第二行开始,故row = k + 1;
			//alert(view.getCell(k - 1, temp_obj[j- 1]).innerText);
			//xlSheet.Cells(k + 4,j).Font.Size=10;
			//xlSheet.Cells(k + 4,j).HorizontalAlignment  = 3;
			//xlSheet.Cells(k + 4,j).WrapText = true;
			xlSheet.Cells(k + 5,j).Value = "'"+view.getCell(k - 1, temp_obj[j- 1]).innerText;
		}
	}
	mygridlist(xlSheet,5,5+recordCount,1,12)
	xlSheet.Columns.AutoFit;
	xlSheet.Rows.AutoFit; 
	//xlSheet.Columns(3+":"+4).ColumnWidth = 12;
	//xlSheet.PrintOut(1,1,1,false,"",false,false);
	//xls.document.execcommand("saveas",true,"test");
	//xls.Application.GetSaveAsFilename("将tabel导出到excel.xls","Excel Spreadsheets(.xls),*xls")
	var locDesc=WardCombo.getRawValue();
	var fname =xls.GetSaveAsFilename(locDesc+"排班模板.xls", "Excel Spreadsheets (*.xls), *.xls");
	if (fname!=""){
  	xlBook.SaveAs(fname);
  }
	xlBook.Close(savechanges=false);
	xls.Quit();
	//xlSheet.PrintPreview;
	//xls.ActiveWindow.Zoom = 75;
	//xls.UserControl = false; // 很重要,不能省略,不然会出问题 意思是excel交由用户控制
//	xls = null;
//	xlBook = null;
//	xlSheet = null;
	//findRec();
}
function mygridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

function PrintAJMData()
{
	//FindArgJobModelData3();
	var mygrid = Ext.getCmp("mygrid");
	try {
		var xls = new ActiveXObject("Excel.Application");
	} catch (e) {
		Ext.Msg.alert('提示',"要导出该表，您必须安装Excel电子表格软件，同时浏览器须使用“ActiveX 控件”，您的浏览器须允许执行控件。 请点击【帮助】了解浏览器设置方法！");
		return "";
	}
	var cm = mygrid.getColumnModel();
	var colCount = cm.getColumnCount();
	//alert('总列数：'+colCount);
	xls.visible = true; // 设置excel为可见
	var xlBook = xls.Workbooks.Add;
	var xlSheet = xlBook.Worksheets(1);
	var xlSheet = xlBook.ActiveSheet;
	var temp_obj = [];
	// 只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示)
	for (i = 0; i < colCount; i++) {
		if (cm.isHidden(i) == true) {
		} else {
			temp_obj.push(i);
		}
	}
	xlSheet.Range("A1:L1").MergeCells=true;
	xlSheet.Cells(1,1).HorizontalAlignment  = 3;//居中
	xlSheet.Cells(1,1).Font.Size=20;
	xlSheet.Cells(1,1).Value = "****医院";
	xlSheet.Range("A2:L2").MergeCells=true;
	xlSheet.Cells(2,1).Font.Size=14;
	xlSheet.Cells(2,1).HorizontalAlignment  = 3;
	xlSheet.Cells(2,1).Value = "排班模板信息";
	xlSheet.Rows(4).Font.Size=10;
	xlSheet.Range("A3:L3").MergeCells = true;
	xlSheet.Range("A4:L4").MergeCells = true;
	xlSheet.Cells(4,1).Font.Size=12;
	xlSheet.Cells(4,1)="病区:"+WardCombo.getRawValue()+"           模板:"+ModelCombo.getRawValue();
	for (l = 1; l <= temp_obj.length; l++) {
		xlSheet.Cells(5,l).HorizontalAlignment  = 3;
		xlSheet.Cells(5,l).Font.Size=10;
		//xlSheet.Cells(5,l).Font.Color='red';
		xlSheet.Cells(5,l).Value = cm.getColumnHeader(temp_obj[l-1]);
	}
	var store = mygrid.getStore();
	var recordCount = store.getCount();
	if(recordCount==0)
	{
		Ext.Msg.alert("提示","没有数据");
		return;
	}
	var view = mygrid.getView();
	for (k = 1; k <= recordCount; k++) {
		xlSheet.Rows(k + 5).Font.Size=10;
		xlSheet.Rows(k + 5).HorizontalAlignment  = 3;
		for (j = 1; j < temp_obj.length; j++) {
			xlSheet.Cells(k + 5,j).Font.Size=10;
			xlSheet.Cells(k + 5,j).HorizontalAlignment  = 3;
			xlSheet.Cells(k + 5,j).WrapText = true;
			xlSheet.Cells(k + 5,j).Value = view.getCell(k - 1, temp_obj[j- 1]).innerText;
		}
	}
	mygridlist(xlSheet,5,5+recordCount,1,12)
	//xlBook.Worksheets(1).Activate;
	xlSheet.Columns.AutoFit;
	xlSheet.Rows.AutoFit; 
	xlSheet.PrintPreview();
	xlSheet.PrintOut(1,1,1,false,"",false,false);
	xls.ActiveWindow.Zoom = 100;
	//xls.UserControl = true; // 很重要,不能省略,不然会出问题 意思是excel交由用户控制
	xlBook.Close ();
	xls.Quit();
//	xls = null;
//	xlBook = null;
//	xlSheet = null;
	//findRec();
}

function deleteStr(Str,Str2)
{
	if(Str.match(Str2)==""){
		return Str;
	}
	var TempStr="";
	var i=0;
	while(i<Str.length)
	{
		var temp = Str.substr(i,Str2.length);
		if(temp!=Str2)
		{
			TempStr=TempStr+Str.substr(i,1);
			i++;
		}
		else{
			i=i+Str2.length;
		}
	}
	return TempStr;
}
var REC2 = new Array();
function copyRosterData()
{
	REC2 = new Array(); 
	var mygrid = Ext.getCmp("mygrid");
	var selections = mygrid.getSelectionModel().selections;
	for(i=0;i<selections.length;i++)
	{
		var row = selections[i][0];
		var col = selections[i][1];
		REC2[i] = new Array(row,col);
	}
}

function pasteRosterData()
{
	var mygrid = Ext.getCmp("mygrid");
	var array = REC2;
	var selections = mygrid.getSelectionModel().selections;
	var strow=selections[0][0];
	var stcol=selections[0][1];
	var cm=mygrid.getColumnModel();
	for(i=0;i<array.length;i++)
	{
		var row = array[i][0];
		var col = array[i][1];
		var rowdistance = row - array[0][0];
		var coldistance = col - array[0][1]
		var wardId = WardCombo.getValue();
		var modelId = ModelCombo.getValue();
		//复制单元格
		//alert("row:"+row+"   col:"+col);
		var NurseId = mygrid.getStore().getAt(row).get("NurseID");
		var week = cm.getDataIndex(col);
		var parr = wardId+"^"+modelId+"^"+NurseId+"^"+week;
		var FindAJMData = document.getElementById("FindAJMData2");
		var ret = cspRunServerMethod(FindAJMData.value,parr);
		//alert(ret);
		//对应粘贴单元格
		var rowIndex = strow + rowdistance;
		if(rowIndex < mygrid.store.getTotalCount()){
			var colIndex = stcol + coldistance;
			if(colIndex<10){
				var NurseId2 = mygrid.getStore().getAt(rowIndex).get("NurseID");
				//Input:病区^模板^护士^班次^班次类型^班次日期^班次开始时间^班次结束日期^备注^排班护士长
				var week2 =cm.getDataIndex(colIndex);
				if(ret!=""){
					var a = ret.split("^");
					//OutPut:AJMType_"^"_AJMCodeDR_"^"_AJStTime_"^"_AJEndTime_"^"_AJJobInterval_"^"_AJRemarks
					var parrStr=wardId+"^"+modelId+"^"+NurseId2+"^"+a[1]+"^"+a[0]+"^"+week2+"^"+a[2]+"^"+a[3]+"^"+a[5]+"^"+session['LOGON.USERCODE']+"^"+a[4];
					var SaveAJMData2 = document.getElementById("SaveAJMData2");
					var ret = cspRunServerMethod(SaveAJMData2.value,parrStr);
				}
			}
		}
	}
}