var Height = document.body.clientHeight-5;
var Width = document.body.clientWidth-3;
var REC = new Array();
var REC2 = new Array();
var rowIndexNum = "";
var cellIndexNum="";
//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);

Ext.MultiCellSelectionModel = Ext.extend(Ext.grid.CellSelectionModel, {
//	stcol:6,
//	endcol:4,
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
		//var cm=grid.getColumnModel();
		var isSelected;
		var colCount=this.grid.getColumnModel().getColumnCount();
		if(event.button !== 0 || this.isLocked())
		return;
		if(event.shiftKey && this.last !== false) { //是否按下shift
			this.selectMatrix(row, col);
			grid.getView().focusCell(row, col);
			return;
		} else if(event.ctrlKey){ //是否按下ctrl
			isSelected = this.isSelected(row,col);
			if((col === 0 && this.last[1] === 0)||this.grid.colModel.getDataIndex(col).indexOf('Date')==-1){
			//if ((col === 0 && this.last[1] === 0)||col<this.stcol ||col>(colCount-this.endcol)){
				isSelected ? this.deselectRow(row) : this.selectRow(row,true);
			}
			if(isSelected){ // 是否已被选中，是则反选，否则选中
				this.deselectCell(row, col);
			} else {
				this.selectCell(row,col,true);
				this.last = [row, col];
			}
		} else if(this.grid.colModel.getDataIndex(col).indexOf('Date')==-1){
		//else if (col < this.stcol ||col>(colCount-this.endcol)){ // 第一列是NumberColumn 点击则选择列
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
		//alert(colIndex)
		if(this.fireEvent("beforecellselect", this, rowIndex, colIndex) !== false){
			if(!keepExisting)
			this.clearCellSelections();
			this.selections.push([rowIndex, colIndex]); // 加入选择区缓存
			if(!preventViewNotify){
				var v = this.grid.getView();
				v.onCellSelect(rowIndex, colIndex); // GridView的内置方法，改变某单元格样式
//				if(preventFocus !== true){
//					v.focusCell(rowIndex, colIndex);
//				}
			}
			this.fireEvent("cellselect", this, rowIndex, colIndex);
			this.fireEvent("selectionchange", this, this.selection);
		}
		if(Ext.getCmp("copybtn")!=null) Ext.getCmp("copybtn").enable();
		if(Ext.getCmp("pastebtn")!=null) Ext.getCmp("pastebtn").enable();
		if(Ext.getCmp("rdeletebtn")!=null) Ext.getCmp("rdeletebtn").enable();
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
		if(Ext.getCmp("copybtn")!=null) Ext.getCmp("copybtn").disable();
		if(Ext.getCmp("pastebtn")!=null) Ext.getCmp("pastebtn").disable();
		if(Ext.getCmp("rdeletebtn")!=null) Ext.getCmp("rdeletebtn").disable();
	},
	// 某行反选
	deselectRow : function(row){
		debugger;
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
		var colCount=this.grid.getColumnModel().getColumnCount();
		if(!keepExisting)
		this.clearCellSelections();
		if(r > row){
			var temp = row;
			row = r;
			r = temp;
		}
		if((col===0&&c===0)||this.grid.colModel.getDataIndex(col).indexOf('Date')==-1){
		//if((col === 0 && c === 0)||col<this.stcol ||col>(colCount-this.endcol)){ // 若选择了第一列序号，则选择行
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
		if(this.grid.colModel.getDataIndex(c).indexOf('Date')==-1||this.grid.colModel.getDataIndex(col).indexOf('Date')==-1) return;
		//if(c<5||c>(colCount-this.endcol)||col>(colCount-this.endcol)||col< this.stcol) return;
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
		if(e.button==2||event.ctrlKey) return;
		if(cell.parentElement.tagName=="TD")
		{
			var td=cell.parentElement;
			var col=td.cellIndex;
			//var tr=cell.parentElement.parentElement;
			var row=td.parentNode.cells[0].innerText-1;
			if(row<0||col<0){return;}
			//if(row!=this.last[0]&&col!=this.last[1])
				//this.selectMatrix(row, col+3);
				this.selectMatrix(row, col+2);
			//grid.getView().focusCell(row, col);
		}
	}
});
function NowWeek()
{
	var date = new Date();
	var dayNum = date.format('N')-1;
	var dateFirst = date.add(Date.DAY,-dayNum)
	return dateFirst;
}
var StDate = new Ext.form.DateField({
	id:'StDate',
	editable:false,
	x:0,y:0,
	value:NowWeek(),
	format:'Y-m-d',
	width:100,
	listeners:{
		select:function(dateField,date){
			createGrid();
		}
	}
});
var EndDate = new Ext.form.DateField({
	id:'EndDate',
	editable:false,
	x:0,y:0,
	value:NowWeek().add(Date.DAY,6),
	format:'Y-m-d',
	width:100,
	listeners:{
		select:function(dateField,date){
			var StDateValue = document.getElementById("StDate");
			var EndDateValue = document.getElementById("EndDate");
			if(StDateValue.value>EndDateValue.value)
			{
				alert("结束日期不能早于开始日期！");
				EndDate.setValue(new Date().add(Date.DAY,6));
			}
			createGrid();
		}
	}
});
var combo = new Ext.form.ComboBox({
	id:'comboward',
 store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:[{'name':'WardDesc','mapping':'WardDesc'},{'name':'rw','mapping':'rw'}]
		}),
		baseParams:{className:'web.DHCNurRosterComm',methodName:'GetWardData',type:'RecQuery'},
		listeners:{ 
			beforeload:function(tstore,e){ 
				tstore.baseParams.parr=secGrpFlag+'^'+session['LOGON.USERCODE'];
				tstore.baseParams.input=Ext.getCmp('comboward').lastQuery;
			}
		}
	}),
	tabIndex:'0',listWidth:'200',height:18,width:150,xtype : 'combo',
	displayField : 'WardDesc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
	minChars : 1,pageSize : 10,typeAhead : true,typeAheadDelay : 1000,loadingText : 'Searching...',
	listeners:{
		select:function(ts,tr,e)
		{
			var bedflag=tkMakeServerCall("web.DHCNurRosterComm","HasBed",ts.getValue());
			if(bedflag==0)
			{
				Ext.getCmp('mygrid').getColumnModel().setColumnHeader(5,"备注");
			}
			else{
				Ext.getCmp('mygrid').getColumnModel().setColumnHeader(5,"床位");
			}
			FindArgJobData();
		}
	}
});

var contextmenu=new Ext.menu.Menu({
	id:'theContextMenu',
	plain:true,
	items:[{
			text:'排班',
 			//icon:'../Image/icons/bullet_black.png',
 			handler:function(){ChoosePostData("P",'mygrid');}
		},{
			text:'追加排班',
 			//icon:'../Image/icons/bullet_blue.png',
 			handler:function(){ChoosePostData("AP",'mygrid');}
		},{
			text:'休班',
 			//icon:'../Image/icons/bullet_green.png',
 			handler:function(){ChooseHolidayData('mygrid')}
		},(new Ext.menu.Menu()).addSeparator(),{
			text:'加班',
 			//icon:'../Image/icons/bullet_orange.png',
 			handler:function(){CreateOverTime('mygrid');}
		},{
			text:'休息',
			hidden:true,
 			//icon:'../Image/icons/bullet_purple.png',
 			handler:function(){CreateRestPanel('mygrid');}
		},(new Ext.menu.Menu()).addSeparator(),{
			text:'复制',
 			icon:'../Image/icons/page_copy.png',
 			id:'copybtn',
 			handler:function(){copyRosterData('mygrid');}
		},{
			text:'粘贴',
 			icon:'../Image/icons/building_edit.png',
 			id:'pastebtn',
 			handler:function(){pasteRosterData('mygrid')}
		},{
			text:'删除',
 			//icon:'../Image/icons/bullet_delete.png',
 			id:'rdeletebtn',
 			handler:function(){if(confirm("确认删除？")){deleteRosterData('mygrid');}}
		},{
			text:'关联床位',
 			handler:function(){connectBed('mygrid');}
		}]
});

var contextmenu2=new Ext.menu.Menu({
	id:'theContextMenu2',
	plain:true,
	width:100,
	items:[{
			text:'插入间隔',
 			handler:function(){insertLine('mygrid')}
		},{
			text:'删除间隔',
 			handler:function(){deleteLine('mygrid')}
		}]
});

function insertLine(gridStr)
{
	var mygrid=Ext.getCmp(gridStr);
	var selections=mygrid.getSelectionModel().selections;
	var rowIndex=selections[0][0];
	if(rowIndex==0){
		alert('此处不能插入间隔');
		return;
	}
	var wardid=combo.getValue();
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var daynum=EndDate.getValue().format('N')
	var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
	var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
	var rowidx=rowIndex+1;
	if(CheckSpace(rowidx)==1)
	{
		alert('此处不能连续插入间隔');
		return;
	}
	var parr=wardid+"^"+firstDay+"^"+lastDay+"^"+rowidx;
	var setSpaceLoc=document.getElementById('setSpaceLoc').value;
	var a=cspRunServerMethod(setSpaceLoc,parr)
	FindArgJobData();
}
function deleteLine(gridStr)
{
	var mygrid=Ext.getCmp(gridStr);
	var selections=mygrid.getSelectionModel().selections;
	var rowIndex=selections[0][0];
	var wardid=combo.getValue();
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var daynum=EndDate.getValue().format('N')
	var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
	var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
	var parr=wardid+"^"+firstDay+"^"+lastDay;
	var rowidx=rowIndex+1;
	var rowidx2=rowIndex+2;
	if(CheckSpace(rowidx)==1)
	{
		parr=parr+"^"+rowidx;
	}
	else if(CheckSpace(rowIndex+2)==1)
	{
		parr=parr+"^"+rowidx2;
	}
	else
	{
		alert("排班记录不可删除");
		return;
	}
	var deleteSpaceLoc=document.getElementById('deleteSpaceLoc').value;
	var a=cspRunServerMethod(deleteSpaceLoc,parr);
	FindArgJobData();
}
function BodyLoadHandler()
{
	createGrid();
}
function createGrid()
{
	var mypanel= createPanel();
	var panel = new Ext.Panel({
		id:'gridpanel',
		height: Height,
		width: Width,
		items:[mypanel]
	});
	var gform = Ext.getCmp("gform"); 
	gform.add(panel);
	gform.doLayout();
	addToolbar();
}
function addToolbar()
{
//	//判断安全组
//	var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
	var mainpanel = Ext.getCmp("mainpanel");
	var tobar = mainpanel.getTopToolbar();
	var UserType = session['LOGON.GROUPDESC'];
	//alert(secGrpFlag)
	//if(UserType == '住院护士长'||UserType=='住院护士'||UserType.indexOf("护士长")>0)
	if((secGrpFlag=="nurhead")||(secGrpFlag=="nurse"))
	{
		//combo.setValue(session['LOGON.CTLOCID']);
		combo.store.load({params:{start:0,limit:10000},callback:function(){combo.setValue(session['LOGON.CTLOCID']);findRec();}});
		combo.disable();
	}
	if(secGrpFlag=="nurse")
	{
		combo.disable();
	}
	tobar.addItem('-','病区:',combo);
	tobar.addItem('-','开始日期:',StDate);
	tobar.addItem('-','结束日期:',EndDate);
	tobar.addItem("-");tobar.addButton({id:'allfind',icon:'../Image/icons/find.png',text:'查询',handler:findRec});
	if((secGrpFlag=="nurhead")||(secGrpFlag=="demo"))
	{
		tobar.addItem("-");tobar.addButton({id:'sendbtn',icon:'',text:'发布',handler:sendRec});
		tobar.addItem("-");tobar.addButton({id:'unsendbtn',icon:'',text:'撤销发布',handler:unsendRec});
		//tobar.addItem("-");tobar.addButton({id:'sumbitbtn',icon:'../Image/icons/page_save.png',text:'提交',handler:setStatus});
	}
	//if(UserType=='住院护士长'||UserType=='Demo Group'||UserType.indexOf("护士长")>0)
	var tobar2=new Ext.Toolbar();
	
	tobar2.addItem("-");
	tobar2.addButton({
		id:'lastWeek',
		icon:'../Image/icons/arrow_up.png',
		text:'上周',
		handler:lastWeekRec
	});
	tobar2.addItem("-");
	tobar2.addButton({
		id:'nowWeek',
		icon:'../Image/icons/arrow_nsew.png',
		text:'本周',
		handler:nowWeekRec
	});
	tobar2.addItem("-");
	tobar2.addButton({
		id:'nextWeek',
		icon:'../Image/icons/arrow_down.png',
		text:'下周',
		handler:nextWeekRec
	});
	tobar2.addItem("-");
	tobar2.addButton({
		id:'allprint',
		icon:'../Image/icons/printer.png',
		text:'打印',
		handler:PrintAJMData
	});
	tobar2.addItem("-");
	tobar2.addButton({
		id:'allexport',
		icon:'../Image/icons/application_put.png',
		text:'导出',
		handler:ExportAJMData
	});
	if((secGrpFlag=="nurhead")||(secGrpFlag=="demo"))
	{
		tobar2.addItem("-");
		tobar2.addButton({
			id:'persavebtn',
			icon:'../Image/icons/table_save.png',
			text:'保存床位/备注',
			handler:function(){saveRec('mygrid')}
		});
		tobar2.addItem("-");
		tobar2.addButton({
			id:'loadasbtn',
			icon:'../Image/icons/table_save.png',
			text:'加载上周床位/备注',
			handler:function(){loadLastWeekAssign('mygrid');saveRec('mygrid');}
		});
		tobar2.addItem("-");
		tobar2.addButton({
			id:'weekcopybtn',
			icon:'../Image/icons/table_save.png',
			text:'复制上周班次',
			handler:function(){CopyLastWeek('mygrid')}
		});
	}
	tobar2.render(mainpanel.tbar);
	tobar.doLayout();
	if((secGrpFlag!="nurhead")&&(secGrpFlag!="demo"))
	{
		var loadlastasgnmt=Ext.getCmp('loadlastasgnmt');
		if(loadlastasgnmt!=null)loadlastasgnmt.disable();
		var asgnmtbtn=Ext.getCmp('asgnmtbtn');
		if(asgnmtbtn!=null) asgnmtbtn.disable();
		var Assignment=Ext.getCmp('Assignment');
		if(Assignment!=null) Assignment.disable();
		
	}
}
function lastWeekRec()
{
	var StDateVal=StDate.getValue().format('Y/m/d');
	var t=new Date(StDateVal);
	StDate.setValue(t.add(Date.DAY,-7).format('Y-m-d'));
	EndDate.setValue(t.add(Date.DAY,-1).format('Y-m-d'));
	createGrid();
	setTimeout('findRec()',1);
	//FindArgJobData();
}
function nowWeekRec()
{
	//var EndDateVal=EndDate.getValue().format('Y/m/d');
	var t=new Date();
	var l=t.format('N');
	StDate.setValue(t.add(Date.DAY,1-l).format('Y-m-d'));
	EndDate.setValue(t.add(Date.DAY,7-l).format('Y-m-d'));
	createGrid();
	setTimeout('findRec()',1);
}
function nextWeekRec()
{
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var t=new Date(EndDateVal);
	StDate.setValue(t.add(Date.DAY,1).format('Y-m-d'));
	EndDate.setValue(t.add(Date.DAY,7).format('Y-m-d'));
	createGrid();
	setTimeout('findRec()',1);
	//FindArgJobData();
}
function saveRec(gridStr)
{
	var wardid=combo.getValue();
	//var StDateVal=StDate.getValue().format('Y-m-d');
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var daynum=EndDate.getValue().format('N')
	var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
	var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
	var mygrid=Ext.getCmp(gridStr);
	var count=mygrid.store.getTotalCount();
	var saveArgJobC=document.getElementById("saveArgJobC").value;
	for(var si=0;si<count;si++)
	{
		var PersonID=mygrid.store.getAt(si).get("NurseId");
		if(PersonID=="")
		{
			continue;
		}
		if(PersonID!="")
		{
			var JobAssign=mygrid.store.getAt(si).get('JobAssign');
			var NurseOrder=mygrid.store.getAt(si).get("NurseOrder");
			var NurseType=mygrid.store.getAt(si).get("NurseType");
			var parr=wardid+"^"+firstDay+"^"+lastDay+"^"+PersonID+"^"+JobAssign+"^"+NurseOrder+"^"+NurseType;
			var a=cspRunServerMethod(saveArgJobC,parr);
		}
	}
	mygrid.store.commitChanges();
	//FindArgJobData();
}

function findRec()
{
	var WardId=combo.getValue();
	if(WardId=="")
	{
		Ext.Msg.alert("提示","请先选择病区");
		return;
	}
	FindArgJobData();
	getArgJob();
} 
function setStatus()
{
	var mygrid=Ext.getCmp("mygrid");
	var mystore=mygrid.getStore();
	var count=mystore.getTotalCount();
	var WardId = combo.getValue();
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var daynum=EndDate.getValue().format('N')
	var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
	var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
	var parr=WardId+"^"+firstDay+"^"+lastDay;
	var CheckEmptyPost=document.getElementById('CheckEmptyPost').value;
	var a=cspRunServerMethod(CheckEmptyPost,parr)
	var SetStatus=document.getElementById('SetStatus').value;
	if(a=="Y")
	{
		saveRec();
		var b=cspRunServerMethod(SetStatus,parr+"^"+a);
		if(b==1) alert("提交成功!");
		else alert("提交失败!");
	}
	else 
	{
		alert('还有未完成的排班，不可提交!');
	}
}
function getWeek(WeekNum)
{
	//alert(WeekNum);
	var WeekStr = "";
	switch(WeekNum)
	{
		case 1:WeekStr = "星期一";break;
		case 2:WeekStr = "星期二";break;
		case 3:WeekStr = "星期三";break;
		case 4:WeekStr = "星期四";break;
		case 5:WeekStr = "星期五";break;
		case 6:WeekStr = "星期六";break;
		case 0:WeekStr = "星期日";break;
	}
	return WeekStr;
}

function createTable()
{
	var StDateValue = StDate.getValue();
	var EndDateValue = EndDate.getValue();
	var colModelStr = new Array();
	var colData = new Array();
	var i=1;
	var AdmDate="";
	//colModelStr.push(new Ext.grid.RowNumberer({locked:true}));
	colModelStr.push({header: '序号',align:'center', width:30, sortable: false,dataIndex: 'NurseOrder'}); //,locked:true});
	colModelStr.push({header: '工号',align:'center', hidden:true,width: 0, sortable: false,dataIndex: 'NurseId'}); //,locked:true});
	colModelStr.push({header: '姓名',align:'center', width: 60, sortable: false,dataIndex: 'NurseName'}); //,locked:true});
	colModelStr.push({header: '序号',align:'center',hidden:true, width:0, sortable: false,dataIndex: 'NurseOrder'});
	colModelStr.push({header: '层级',align:'center', width: 50, sortable: false,dataIndex: 'NurseBty'});
	var wardid=combo.getValue();
	if(wardid=="") wardid=session["LOGON.CTLOCID"];
	var bedflag=tkMakeServerCall("web.DHCNurRosterComm","HasBed",wardid);
	if(bedflag==0)
	{
		colModelStr.push({header: '备注',align:'center', width: 80,sortable: false,dataIndex: 'JobAssign',editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false,listeners:{blur:function(){saveRec('mygrid')}}}))});
	}
	else{
		colModelStr.push({header: '床位',align:'center', width: 80,sortable: false,dataIndex: 'JobAssign',editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false,listeners:{blur:function(){saveRec('mygrid')}}}))});
	}
	colData.push({'name':'JobAssign','mapping':'JobAssign'});
	colData.push({'name':'NurseId','mapping':'NurseId'});
	colData.push({'name':'NurseName','mapping':'NurseName'});
	for(AdmDate=new Date(StDateValue.format('m/d/Y'));AdmDate<=new Date(EndDateValue.format('m/d/Y'));AdmDate=AdmDate.add(Date.DAY,1))
	{
		colModelStr .push({header:(AdmDate.format('m-d')+'<br>'+getWeek(AdmDate.getDay())),align:'center', width: 95, sortable: false,dataIndex: 'Date'+AdmDate.format('Y-m-d')});
		colData.push({'name':'Date'+AdmDate.format('Y-m-d'),'mapping':'Date'+AdmDate.format('Y-m-d')});
	}
	//colModelStr.push({header: '护士层级',align:'center', width: 60, sortable: false,dataIndex: 'NurseBty'});
	colModelStr.push({header: '总小时数',align:'center', width: 60, sortable: false,dataIndex: 'JobNum'});
	colModelStr.push({header: '夜小时数',align:'center', width: 60, sortable: false,dataIndex: 'NigthJobNum'});
	colModelStr.push({header: '类型',align:'center', width:110, sortable: false,dataIndex: 'NurseType'});
	colData.push({'name':'NurseBty','mapping':'NurseBty'});
	colData.push({'name':'JobNum','mapping':'JobNum'});
	colData.push({'name':'NigthJobNum','mapping':'NigthJobNum'});
	colData.push({'name':'NurseOrder','mapping':'NurseOrder'});
	colData.push({'name':'NurseType','mapping':'NurseType'});
	colData.push({'name':'NurseName2','mapping':'NurseName2'});
	var colModel = new Ext.ux.grid.LockingColumnModel(colModelStr);
	var store = new Ext.data.Store({
 		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
   	reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
   		fields:colData
   	}),
   	baseParams:{className:'DHCMGNUR.MgNurArrangeJob',methodName:'FindAJData',type:'RecQuery'},
    listeners:{
    	beforeload:function(thisstore){
    		var WardId=combo.getValue();
				var StDateValue = StDate.getValue().format('Y-m-d');
				var EndDateValue = EndDate.getValue().format('Y-m-d');
				var parr = WardId+"^"+StDateValue+"^"+EndDateValue+'^'+secGrpFlag;
				thisstore.baseParams.parr=parr;
			},
    	load:function(mystore,recodes,o) {
    		var elments1 = Ext.select(".x-grid3-row",true);
    		elments1.each(function(el) {
    			el.setStyle("border-top-color", '#DCDCDC');
        	el.setStyle("border-color", '#DCDCDC');
       	}, this); 
   			var RCount=mystore.getTotalCount();
   			var CCount=table.getColumnModel().getColumnCount();
      	var view=table.getView();
      	var WardId=combo.getValue();
				var stdate = StDate.getValue().format('Y-m-d');
				var endate = EndDate.getValue().format('Y-m-d');
				var ret="";
				for(var tmpdate=StDate.getValue();tmpdate.between(StDate.getValue(),EndDate.getValue());tmpdate=tmpdate.add(Date.DAY,15))
				{
					var tmpenddate=tmpdate.add(Date.DAY,15).format('Y-m-d');
					if(tmpenddate>endate)
					{
						tmpenddate=endate;
					}
					var parr = WardId+"^"+tmpdate.format('Y-m-d')+"^"+tmpenddate;
	      	var tmpret=tkMakeServerCall("DHCMGNUR.MgNurArrangeJob","GetDataType",parr);
	      	if(ret=="") ret=tmpret;
 					else ret=ret+"^"+tmpret;
 	      }
      	var array=SplitStr(ret);
      	var ret1=tkMakeServerCall("DHCMGNUR.MgNurArgJob","getValue",WardId+"^"+stdate+"^"+endate);
		var array1=SplitStr(ret1);
      	for(var svi=0;svi<RCount;svi++)
      	{
      		var NurseId=mystore.getAt(svi).get('NurseId');
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
      			cell.style.color='#F08080';
      		}
      		if(NurType=="T"){
      			cell=view.getCell(svi,2);
      			cell.style.color='#00CED1';
      		}
  				if((secGrpFlag!="nurse")||((secGrpFlag=="nurse")&&(array1["Status"]=="S")))
  				{
	      		for(var admdate=StDate.getValue();admdate.between(StDate.getValue(),EndDate.getValue());admdate=admdate.add(Date.DAY,1))
	      		{
	      			var cvi=table.colModel.findColumnIndex('Date'+admdate.format('Y-m-d'));
	      			if(cvi==null||cvi==-1)continue;
		      		var arrindex=NurseId+'-'+admdate.format('Y-m-d');
		      		var cell=view.getCell(svi,cvi);
		      		if(array[arrindex]=="H")
		      		{
		      			cell.style.backgroundColor='#FFFF99';
		      		}
		      		if(array[arrindex]=="H-J"||array[arrindex]=="P-N")
		      		{
		      			cell.style.color='#FF0000';
		      			//cell.style.backgroundColor='#FF0000';
		      		}
		      	}
						if(CheckSpace(svi+1)==1)
						{
							row=view.getRow(svi);
							row.style.borderTopWidth="5";
							row.style.borderTopColor="#C0C0C0";
						}
					}
      	}
   		}
    }
	});
	//var todayDesc=new Date();
	var myview=new Ext.ux.grid.LockingGridView({
		syncHeights:true,
		onLoad : Ext.emptyFn, 
    listeners : { 
      beforerefresh : function(v) { 
      	v.scrollTop = v.scroller.dom.scrollTop; 
        v.scrollHeight = v.scroller.dom.scrollHeight; 
      }, 
      refresh : function(v) { 
        v.scroller.dom.scrollTop = v.scrollTop + (v.scrollTop == 0 ? 0 : v.scroller.dom.scrollHeight - v.scrollHeight); 
      } 
    }, 
    getRowClass: function(record, rowIndex, rp, ds){
    	return "my-x-grid3-row td";
    }
  });
	var table = new Ext.grid.EditorGridPanel({
		id:'mygrid',
		x:0,y:0,
		loadMask:true,clicksToEdit: 1, stripeRows: true,
		height: Height-125,
		width: Width,
		store: store,
		cm :colModel,
		autoScroll:true,
		view: myview,
		//title:todayDesc.format('Y')+'年排班信息',
		selModel:new Ext.MultiCellSelectionModel(),
		//tbar:[],
		bbar: new Ext.PagingToolbar({ 
        pageSize: 1000, 
        store: store,
        //hidden:true,
        displayInfo: true, 
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
        emptyMsg: "没有记录" 
    }),
    viewConfig:{
    	
    },
    listeners:{
    	scope : this,  
    	render: function (grid){
        //var store = grid.getStore();  // Capture the Store.  
        var view = grid.getView();    // Capture the GridView.  
        grid.tip = new Ext.ToolTip({  
            target: view.mainBody,    // The overall target element.  
            delegate: '.x-grid3-cell', // Each grid row causes its own seperate show and hide.  
            trackMouse: true,         // Moving within the row should not hide the tip.  
            renderTo: document.body,  // Render immediately so that tip.body can be  
            anchor: 'top',  
            width:200,
            listeners: {              // Change content dynamically depending on which element triggered the show.  
                beforeshow: function updateTipBody(tip) {  
                  var rowIndex = view.findRowIndex(tip.triggerElement);  
                  var cellIndex = view.findCellIndex(tip.triggerElement); 
                  //if(!rowIndex||!cellIndex) return;  
                  var colCount=grid.getColumnModel().getColumnCount();
                  if(grid.getColumnModel().getDataIndex(cellIndex).indexOf('Date')==-1) return false;
                  var WardId=combo.getValue();
									var getBedValue=document.getElementById('getBedValue').value;
									var NurseId = grid.getStore().getAt(rowIndex).get("NurseId")
									var nowDate=new Date(grid.getColumnModel().getDataIndex(cellIndex).substring(4).replace(/\-/g,'/')).format('Y-m-d');
									var NurseType=grid.getStore().getAt(rowIndex).get("NurseType")
									var parr=WardId+"^"+NurseId+"^"+nowDate+"^"+NurseType;
									var ret=cspRunServerMethod(getBedValue,parr);
                  if(ret=="")return false;  
                  var cell = view.getCell(rowIndex, cellIndex);  
                  tip.body.dom.innerHTML = "<font color='red' size='3'>负责床位："+ret+"</font>";
                }  
            }  
        });  
    	},
    	celldblclick:function(grid,rowIndex,colIndex ,e)
    	{
//    		var colCount=grid.getColumnModel().getColumnCount();
//    		if(colIndex!=(colCount-4)) return;
//    		var cell=grid.getView().getCell(rowIndex,colIndex);
//    		cell.enable(true);
    	}, 
			cellclick:function(grid,rowIndex,colIndex ,e)
			{
			},
    	cellcontextmenu:function(grid,rowIndex,columnIndex,e){
    		e.preventDefault();
    		var UserType = session['LOGON.GROUPDESC'];
    		//if((UserType=='住院护士长'||UserType=='Demo Group'||UserType.indexOf('护士长')>0)&&(CheckDate()==true)){
    		//alert(CheckDate())
    		if((secGrpFlag=="nurhead"||secGrpFlag=="demo")&&(CheckDate()==true)){
    			var colCount=grid.getColumnModel().getColumnCount();
    			var Status=Ext.getCmp("mygrid").getSelectionModel().isSelected(rowIndex,columnIndex);
					var Status2=Ext.getCmp("mygrid").getSelectionModel().isSelected(rowIndex,1);
    			if(columnIndex==0&&Status2)
    			{
    				contextmenu2.showAt(e.getXY());
    			}
    			var ColumnHeader=grid.getColumnModel().getDataIndex(columnIndex);
					if(ColumnHeader.indexOf("Date")!==-1)
					{
						if(Status&&!Status2)
						{
							contextmenu.showAt(e.getXY());
							//rowIndexNum = rowIndex;
							//cellIndexNum= columnIndex;
						}
					}
				}
    	}
    }
	});
	return table;
}
function CheckDate()
{
	return true;
	var stvalue=StDate.getValue();
  var endvalue=EndDate.getValue();
  var nowvalue=new Date();
  if(stvalue.format('o')>nowvalue.format('o'))//年份比较
  {
  	return true;
  }
  if(stvalue.format('o')==nowvalue.format('o'))
  {
	  if(stvalue.format('W')>=nowvalue.format('W'))//周比较
	  {
	  	return true;
	  }
	  if((nowvalue.format('W')-stvalue.format('W')>=1&&nowvalue.format('W')-stvalue.format('W')<=2)||(stvalue.format('W')>=nowvalue.format('W')))
	  {
	  	return true;
	  }
	  if((nowvalue.format('W')-stvalue.format('W')==1)&&(nowvalue.format('N')==1))
	  {
	  	return true;
	  }
	}
  if((stvalue.format('o')<nowvalue.format('o')))
  {
  	var weekfirst=new Date().add(Date.DAY,-7);
  	//var weekfirst=new Date().add(Date.DAY,-14);
  	var weeklast=new Date().add(Date.DAY,-1);
  	if((nowvalue.format('N')==1)&&(stvalue.between(weekfirst,weeklast)))
  	{
  		return true;
  	}
  }
  return false;
}

function createASMPanel()
{
	var panel = new Ext.Panel({
		height: Height-100,
		width: Width,
		layout:'absolute',
		frame:true,
		tbar:['-',new Ext.Button({id:'asgnmtfindbtn',icon:'../Image/icons/find.png',text:'查找',handler:getArgJob}),
					'-',new Ext.Button({id:'loadlastasgnmt',icon:'../Image/icons/application_add.png',text:'加载上周',handler:getlastArgJob}),
					'-',new Ext.Button({id:'asgnmtbtn',icon:'../Image/icons/table_save.png',text:'保存',handler:function()
					{
						var wardid=combo.getValue();
						var EndDateVal=EndDate.getValue().format('Y/m/d');
						var daynum=EndDate.getValue().format('N')
						var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
						var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
						var Assignment=Ext.getCmp("Assignment").getValue();
						var parr=wardid+"^"+firstDay+"^"+lastDay+"^"+Assignment;
						var saveArgJob=document.getElementById("saveArgJob").value;
						var a =cspRunServerMethod(saveArgJob,parr); 
						alert(a);
					}}),
					'-',new Ext.Button({id:'amcanclebtn',icon:'../Image/icons/page_delete.png',text:'清空',handler:function()
					{
						var Assignment=Ext.getCmp("Assignment");
						Assignment.setValue("");
					}})
		],
		items:[{
			id:'Assignment',
			xtype:'textarea',
			height:Height-170,
			width:Width-10
		}]
	});
	return panel;
}

function createPanel()
{
	var todayDesc=new Date();
	var PTable=createTable(); 
	var ASMPanel=createASMPanel();
	var panel = new Ext.Panel({
		title:todayDesc.format('Y')+'年排班信息 <font color="#FF00FF">实习：粉红</font> <font color="blue">进修：蓝色</font> <font color="#F08080">护理员：暗红</font>',
		id:'mainpanel',
		//plain:true,
		height:Height,
		width: Width,
		split:true,
		forceLayout:true,
		layout:'accordion',
		tbar:[],
		items:[{
				title:'排班表',
				items:[PTable]
			},{
				title:'通知或备注',
				layout:'absolute',
				items:[ASMPanel]
			}]
	});
 	return panel;
}

function CheckSpace(num)
{
	var wardid=combo.getValue();
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var daynum=EndDate.getValue().format('N')
	var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
	var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
	var parr=wardid+"^"+firstDay+"^"+lastDay;
	var getAJValue=document.getElementById('getAJValue').value;
	var ret=cspRunServerMethod(getAJValue,parr);
	var SpaceArr=new Array();
	if(ret!="")
	{
		var array=SplitStr(ret);
		if(array['SpaceLoc']!="") 
		{
			SpaceArr=array['SpaceLoc'].split(';');
		}
	}
	for(si=0;si<SpaceArr.length;si++)
	{
		if(SpaceArr[si]==num)
		{
			return 1;
		}
	}
	return 0;
}

function createControlTable()
{
	var colModel = new Ext.grid.ColumnModel([
		{ header: "时段", width: 100, sortable: true,dataIndex: 'ControlDate'},
		{ header: "名称", width: 100, sortable: true,dataIndex: 'ControlName'},
    { header: "值", width: 100, sortable: true,dataIndex: 'ControlValue'}
 	]);
	var store = new Ext.data.JsonStore({
  	fields:['ControlDate','ControlName','ControlValue'],
  	idIndex: 0
	});
	var table = new Ext.grid.GridPanel({
		renderTo:'mygrid',
		title:'过往数据统计',
		id:'controlgrid',
		x:271,y:0,
		width: 255,
		height: 550,
		store: store,
		tbar:[],
		cm: colModel
		/*bbar: new Ext.PagingToolbar({ 
      pageSize: 1000, 
      store: store,
      disabled:true,
     	displayInfo: true, 
      displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
      emptyMsg: "没有记录" 
    })*/
	});
	return table;
}

//PostCode,PostName,PostNeedNurse,PostIsNigth,PostRemarks,PostLimits,PostHourNum,CommDictSubDesc,PostOrderNo,PostId
function createPostTable()
{
	var colModel = new Ext.grid.ColumnModel([
		{ header: "代码", width: 100, sortable: true,dataIndex: 'PostCode'},
    { header: "描述", width: 100, sortable: true,dataIndex: 'PostDesc'},
    { header: "班次类型", width: 60, sortable: true,dataIndex: 'TypeDesc'},
    { header: "小时数", width: 50, sortable: true,dataIndex: 'PostHours'},
    { header: "PostID", width: 80, sortable: true, dataIndex: 'PostID'}
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
				thisstore.baseParams.parr=combo.getValue()+"^"+"N";
			}
		}
	});
	var table = new Ext.grid.GridPanel({
		renderTo:'mygrid',
		id:'mygrid3',
		x:0,y:0,
		width: 255,
		height: 550,
		store: store,
		tbar:[],
		cm: colModel,
		bbar: new Ext.PagingToolbar({ 
      pageSize: 30, 
      store: store,
      //hidden:true,
      displayInfo: true, 
      displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
      emptyMsg: "没有记录" 
    })
	});
	return table;
}

function CreatePostPanel()
{
	var table = createPostTable();
	var table2 = createControlTable();
	var window= new Ext.Window({
		title : '',
		id : "CreateRosterWin",
		x:60,
		y:40,
		width : 540,
		height : 585,
		autoScroll : true,
		modal:true,
		layout : 'absolute',
		items : [table,table2]
	});
	return window;
}
function CreateHolidayTable()
{
	var colModel = new Ext.grid.ColumnModel([
		{ header: "代码", width: 70, sortable: true,dataIndex: 'HolidayCode'},
    { header: "名称", width: 70, sortable: true,dataIndex: 'HolidayDesc'},
    { header: "日小时数", width: 70, sortable: true,dataIndex: 'HolidayHours'},
    { header: "rw", width: 0, sortable: true, dataIndex: 'rw'}
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
		//renderTo:'mygrid',
		id:'mygrid4',
		x:0,y:0,
		width: 255,
		height: 550,
		store: store,
		tbar:[],
		cm: colModel,
		bbar: new Ext.PagingToolbar({ 
      pageSize: 30, 
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
	var table2 = createControlTable();
	var window= new Ext.Window({
		title : '',
		id : "CreateHolidayWin",
		x:60,y:40,
		width : 540,
		height : 585,
		autoScroll : true,
		modal:true,
		layout : 'absolute',
		items : [table,table2]
	});
	return window;
}

function ChoosePostData(postType,gridStr)
{
	if(Ext.getCmp('CreateRosterWin')!=null)
	{
		Ext.getCmp('CreateRosterWin').close();
	}
	var window = CreatePostPanel();
	window.setTitle("岗位代码");
	window.show();
	Ext.getCmp('mygrid3').store.load({params:{start:0,limit:30}});
	getControlData();
	var mygrid = Ext.getCmp("mygrid3");
	var tobar = mygrid.getTopToolbar();
	var tobar2=new Ext.Toolbar();
	tobar.addItem("-");
	tobar.addItem(new Ext.form.Checkbox({id:'halfday1',boxLabel:'上午',hidden:false}));
	tobar.addItem(new Ext.form.Checkbox({id:'halfday2',boxLabel:'下午',hidden:false}));
	tobar.addItem("-");
	tobar.addItem(new Ext.Button({id:'checkbtn',text:'选择',handler:function(){if(WritePostData(postType,gridStr)) {window.close();FindArgJobData();}}}));
	tobar2.addItem("-");
	tobar2.addItem(new Ext.form.Label({id:'remarklabel',text:'备注：'}));
	tobar2.addItem(new Ext.form.TextField({id:'remarktext',width:200}));
	tobar2.render(mygrid.tbar);
	tobar.doLayout();
	
	mygrid.on('rowdblclick',function(){if(WritePostData(postType,gridStr)) window.hide();FindArgJobData();});
}
function getControlData()
{
	REC=new Array(); 
	var mygrid=Ext.getCmp("mygrid");
	var selections=mygrid.getSelectionModel().selections;
	if(selections.length==1)
	{
		var row=selections[0][0];
		var cell=selections[0][1];
		var WardId=combo.getValue();
		var NurseId = mygrid.getStore().getAt(row).get("NurseId");
		var EndDateVal=EndDate.getValue().format('Y/m/d');
		var daynum=EndDate.getValue().format('N')
		var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
		var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
		var NurseType=mygrid.getStore().getAt(row).get("NurseType");
		var parr=WardId+"^"+NurseId+"^"+firstDay+"^"+lastDay+"^"+NurseType;
		var FindControlData=document.getElementById('FindControlData').value;
		var ret=cspRunServerMethod(FindControlData,parr);
		var array=SplitStr2(ret);
		for(var i=0;i<array.length;i++)
		{
			REC.push({
				ControlDate:firstDay+"至"+lastDay,
				ControlName:array[i][0],
				ControlValue:array[i][1]
			});
		}
		var MonthFirstDay=StDate.getValue().format('Y-m')+"-01";
		var MonthLastDay=StDate.getValue().format('Y-m')+"-"+StDate.getValue().format('t');
		var parr=WardId+"^"+NurseId+"^"+MonthFirstDay+"^"+MonthLastDay+"^"+NurseType;
		var ret=cspRunServerMethod(FindControlData,parr);
		var array=SplitStr2(ret);
		for(var i=0;i<array.length;i++)
		{
			REC.push({
				ControlDate:StDate.getValue().format('Y年m月'),
				ControlName:array[i][0],
				ControlValue:array[i][1]
			});
		}
		Ext.getCmp('controlgrid').store.loadData(REC);
	}
}
function ChooseHolidayData(gridStr)
{
	if(Ext.getCmp('CreateHolidayWin')!=null)
	{
		Ext.getCmp('CreateHolidayWin').close();
	}
	var window = CreateHoliday();
	window.setTitle("假期代码");
	window.show();
	Ext.getCmp('mygrid4').store.load({params:{start:0,limit:100}});
	getControlData(gridStr);
	var mygrid = Ext.getCmp("mygrid4");
	var tobar = mygrid.getTopToolbar();
	tobar.addItem("-");
	tobar.addItem(new Ext.form.Checkbox({id:'hhalfday1',boxLabel:'上午',hidden:true}));
	tobar.addItem(new Ext.form.Checkbox({id:'hhalfday2',boxLabel:'下午',hidden:true}));
	tobar.addItem("-");
	tobar.addItem(new Ext.Button({id:'checkbtn',text:'选择',handler:function(){if(WriteHolidayData(gridStr)) window.close();}}));
	tobar.addItem("-");
	tobar.doLayout();
	mygrid.on('rowdblclick',function(){if(WriteHolidayData(gridStr)) window.hide();});
}
function RecArraySort(array,Str)
{
	for(i=0;i<array.length;i++)
	{
		for(j=0;j<array.length-i-1;j++)
		{
			if(parseInt(array[j][Str])>parseInt(array[j+1][Str]))
			{
				var temp = array[j+1];
				array[j+1]=array[j];
				array[j]=temp;
			}
		}
	}
	return array;
}


function CreateOverTime(gridStr)
{
	var selections=Ext.getCmp(gridStr).getSelectionModel().selections;
	var StDateValue = StDate.getValue().format('m/d/Y');
	var date = new Date(StDateValue);
	//var nowDate = date.add(Date.DAY,selections[0][1]-3);//.format('Y-m-d'); 
	var nowDate=new Date(Ext.getCmp('mygrid').getColumnModel().getDataIndex(selections[0][1]).substring(4).replace(/\-/g,'/')).format('Y-m-d');
	var window = new Ext.Window({
			id:'createovertime',title:'加班',
			width:520,height:210,x:250,y:120,
			renderTo: Ext.getBody(),
			modal:true,layout: 'absolute',
			items:[
				new Ext.form.Label({id:'StDate2Label',text:'开始日期:',width:60,x:10,y:10}),
				new Ext.form.DateField({id:'StDate2',x:80,y:10,width:150,format:'Y-m-d',value:nowDate}),
				new Ext.form.Label({id:'StTime2Label',text:'开始时间:',width:60,x:240,y:10}),
				new Ext.form.TimeField({id:'StTime2',x:310,y:10,width:150,increment:30,value:new Date(),format:'H:i'}),
				new Ext.form.Label({id:'EndDate2Label',text:'结束日期:',width:60,x:10,y:40}),
				new Ext.form.DateField({id:'EndDate2',x:80,y:40,width:150,format:'Y-m-d',value:nowDate}),
				new Ext.form.Label({id:'EndTime2Label',text:'结束时间:',width:60,x:240,y:40}),
				new Ext.form.TimeField({id:'EndTime2',x:310,y:40,width:150,increment:30,value:new Date(),format:'H:i'}),
				new Ext.form.Label({id:'Remarks1Label',text:'加班原因:',width:60,x:10,y:70}),
				new Ext.form.TextArea({id:'Remarks1',x:80,y:70,width:380,height:70,increment:30}),
				new Ext.Button({id:'overtimebtn',text:'确定',width:100,x:360,y:150,
					handler:function(){if(WriteOverTimeData(gridStr)){ window.close(); }}
				})
			]
		});
		window.show();
}
function CreateRestPanel(gridStr)
{
	var window = new Ext.Window({
			id:'CreateRosterRest',title:'休息',
			width:270,height:160,x:250,y:130,
			renderTo: Ext.getBody(),
			modal:true,layout: 'absolute',
			items:[
				new Ext.form.Label({id:'RosterRestLabel',text:'假期:',width:60,x:10,y:10}),
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
					tabIndex:'0',listWidth:'200',height:18,width:150,xtype : 'combo',mode:'local',
					displayField : 'HolidayDesc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
					minChars : 1,pageSize : 10,typeAhead : false,typeAheadDelay : 1000,loadingText : 'Searching...'
				}),
				new Ext.form.Label({id:'StTime3Label',text:'开始时间:',width:60,x:10,y:40}),
				new Ext.form.TimeField({id:'StTime3',x:80,y:40,width:150,increment:30,value:new Date(),format:'H:i'}),
				new Ext.form.Label({id:'EndTime3Label',text:'结束时间:',width:60,x:10,y:70}),
				new Ext.form.TimeField({id:'EndTime3',x:80,y:70,width:150,increment:30,value:new Date(),format:'H:i'}),
				new Ext.Button({id:'rosterRestbtn2',text:'确定',width:100,x:130,y:100,
					handler:function(){if(WriteRestData(gridStr)) window.close(); }
				})
			]
		});
		window.show();
		Ext.getCmp('RestCombo').store.load({params:{start:0,limit:100}});
}
function WritePostData(postType,gridStr)
{
	var mygrid = Ext.getCmp(gridStr);
	var mygrid3 = Ext.getCmp("mygrid3");
	var WardId=combo.getValue();
	var parm=""
	var rowObj = mygrid3.getSelectionModel().getSelections();
	var selectedRow = mygrid3.getSelectionModel().getSelected();
	if (rowObj.length == 0)
	{
		Ext.Msg.alert('提示',"请选择一条记录!");
		return false;
	}
	var PostId = selectedRow.get("PostID");
	var PostDesc=selectedRow.get('PostDesc');
	var PostHalfDay1 = Ext.getCmp("halfday1").getValue();
	var PostHalfDay2 = Ext.getCmp("halfday2").getValue();
	var selections=mygrid.getSelectionModel().selections;
	var cm=mygrid.getColumnModel();
	for(var ii=0;ii<selections.length;ii++)
	{
		var cell=selections[ii];
		var rowIndexNum = cell[0];
		var cellIndexNum = cell[1];
		//护士^班次^班次类型^班次日期^班次开始时间^班次结束日期^备注^排班护士长^时段
		var NurseId = mygrid.getStore().getAt(rowIndexNum).get("NurseId");
		var halfDay="H";
		if(PostHalfDay1) halfDay="A";//上午
		if(PostHalfDay2) halfDay="P";//下午
		var RemarkText = Ext.getCmp("remarktext").getValue();
		var nowDate=new Date(cm.getDataIndex(cellIndexNum).substring(4).replace(/\-/g,'/')).format('Y-m-d');
		var NurseType=mygrid.getStore().getAt(rowIndexNum).get("NurseType");
		var parrStr=WardId+"^"+NurseId+"^"+PostId+"^Post^"+nowDate+"^^^"+RemarkText+"^"+session['LOGON.USERCODE']+"^"+halfDay+"^"+NurseType;
		if(parm=="") parm=parrStr;
		else parm=parm+"!"+parrStr;
		var cellvaue=mygrid.store.getAt(rowIndexNum).get(cm.getDataIndex(cellIndexNum));
		if(cellvaue=="")
		{
			mygrid.store.getAt(rowIndexNum).set(cm.getDataIndex(cellIndexNum),PostDesc);
		}
		else{
			mygrid.store.getAt(rowIndexNum).set(cm.getDataIndex(cellIndexNum),cellvaue+"/"+PostDesc);
		}
	}
	SaveArgJobData(gridStr,parm);
	return true;
}
function WriteHolidayData(gridStr)
{
	var mygrid = Ext.getCmp(gridStr);
	var mygrid4 = Ext.getCmp("mygrid4");
	var WardId=combo.getValue();
	var parm="";
	var HolidayHalfDay1 = Ext.getCmp("hhalfday1").getValue();
	var HolidayHalfDay2 = Ext.getCmp("hhalfday2").getValue();
	var rowObj = mygrid4.getSelectionModel().getSelections();
	var selectedRow = mygrid4.getSelectionModel().getSelected();
	var cm=mygrid.getColumnModel();
	if (rowObj.length == 0)
	{
		Ext.Msg.alert('提示',"请选择一条记录!");
		return false;
	}
	var Holiday = selectedRow.get("rw");
	var HolidayDesc=selectedRow.get('HolidayDesc')
	//var HolidayName = selectedRow.get("HolidayName");
	var selections=mygrid.getSelectionModel().selections;
	for(var ii=0;ii<selections.length;ii++)
	{
		var cell=selections[ii];
		var rowIndexNum = cell[0];
		var cellIndexNum = cell[1];
		
		var cellvaue=mygrid.store.getAt(rowIndexNum).get(cm.getDataIndex(cellIndexNum));
		if(cellvaue=="")
		{
			mygrid.store.getAt(rowIndexNum).set(cm.getDataIndex(cellIndexNum),HolidayDesc);
		}
		else{
			mygrid.store.getAt(rowIndexNum).set(cm.getDataIndex(cellIndexNum),cellvaue+"/"+HolidayDesc);
		}
		
//		//护士^班次^班次类型^班次日期^班次开始时间^班次结束时间^备注^排班护士长^时段
		var NurseId = mygrid.getStore().getAt(rowIndexNum).get("NurseId");
		var halfDay="H";
		if(HolidayHalfDay1) halfDay="A";
		if(HolidayHalfDay2) halfDay="P";
		var nowDate=new Date(cm.getDataIndex(cellIndexNum).substring(4).replace(/\-/g,'/')).format('Y-m-d');
		var NurseType=mygrid.getStore().getAt(rowIndexNum).get("NurseType");
		var parrStr=WardId+"^"+NurseId+"^"+Holiday+"^Holiday^"+nowDate+"^^^^"+session['LOGON.USERCODE']+"^"+halfDay+"^"+NurseType;
		if(parm=="") parm=parrStr;
		else parm=parm+"!"+parrStr;
	}
	SaveArgJobData(gridStr,parm);
	return true;
}
function WriteOverTimeData(gridStr)
{
	var mygrid = Ext.getCmp(gridStr);
	var cm=mygrid.getColumnModel();
	var WardId=combo.getValue();
	var parm="";
	var OverTimeStDate = Ext.getCmp("StDate2").getValue();
	var OverTimeStTime = Ext.getCmp("StTime2").getValue(); 
	var OverTimeEndDate = Ext.getCmp("EndDate2").getValue();
	var OverTimeEndTime = Ext.getCmp("EndTime2").getValue(); 
	var OverTimeValue="";
	if(OverTimeStDate.format('Y-m-d')>OverTimeEndDate.format('Y-m-d'))
	{
		Ext.Msg.alert("提示","开始日期不能大于结束日期!");
		return false;
	}
	else{
		if(OverTimeStDate.format('Y-m-d')==OverTimeEndDate.format('Y-m-d'))
		{
			if(OverTimeStTime>=OverTimeEndTime)
			{
				Ext.Msg.alert("提示","开始时间不能大于或等于结束时间!");
				return false;
			}
			else{
				var OTSTime = OverTimeStTime.toString().split(':');
				var OTETime = OverTimeEndTime.toString().split(':');
				var OverTimeNum=parseFloat(OTETime[0])+parseFloat(OTETime[1])/60-parseFloat(OTSTime[0])-parseFloat(OTSTime[1])/60;
				OverTimeValue="加"+OverTimeNum.toFixed(1);
			}
		}
		else{
			var OTSTime = OverTimeStTime.toString().split(':');
			var OTETime = OverTimeEndTime.toString().split(':');
			var OverTimeNum=24+parseFloat(OTETime[0])+parseFloat(OTETime[1])/60-parseFloat(OTSTime[0])-parseFloat(OTSTime[1])/60;
			OverTimeValue="加"+OverTimeNum.toFixed(1);
		}
	}
	var selections=mygrid.getSelectionModel().selections;
	for(ii=0;ii<selections.length;ii++)
	{
		var cell=selections[ii];
		var rowIndexNum = cell[0];
		var cellIndexNum = cell[1];
		
		var cellvaue=mygrid.store.getAt(rowIndexNum).get(cm.getDataIndex(cellIndexNum));
		if(cellvaue=="")
		{
			mygrid.store.getAt(rowIndexNum).set(cm.getDataIndex(cellIndexNum),OverTimeValue);
		}
		else{
			mygrid.store.getAt(rowIndexNum).set(cm.getDataIndex(cellIndexNum),cellvaue+"/"+OverTimeValue);
		}
		
		//护士^班次^班次类型^班次日期^班次开始时间^班次结束时间^备注^排班护士长
		var NurseId = mygrid.getStore().getAt(rowIndexNum).get("NurseId");
		var nowDate=new Date(cm.getDataIndex(cellIndexNum).substring(4).replace(/\-/g,'/')).format('Y-m-d');
		var NurseType=mygrid.getStore().getAt(rowIndexNum).get("NurseType");
		var Remarks1=Ext.getCmp('Remarks1').getValue();
		var parrStr=WardId+"^"+NurseId+"^"+OverTimeValue+"^OverTime^"+nowDate+"^"+OverTimeStTime.toString()+"^"+OverTimeEndTime.toString()+"^"+Remarks1+"^"+session['LOGON.USERCODE']+"^H^"+NurseType;
		if(parm=="") parm=parrStr;
		else parm=parm+"!"+parrStr;
	}
	SaveArgJobData(gridStr,parm);
	return true;
}

function WriteRestData(gridStr)
{
	var mygrid = Ext.getCmp(gridStr);
	var cm=mygrid.getColumnModel();
	var WardId=combo.getValue();
	var parm="";
	//RestCombo
	var RestCombo = Ext.getCmp("RestCombo");
	var RestComboId = RestCombo.getValue();
	if(!RestComboId){
		Ext.Msg.alert('提示','假期不能为空！');
		return false;	
	}
	var RestComboDesc = RestCombo.getRawValue();
	var RestStTime = Ext.getCmp("StTime3").getValue(); 
	var RestEndTime = Ext.getCmp("EndTime3").getValue(); 
	if(RestStTime>=RestEndTime)
	{
		Ext.Msg.alert("提示","开始时间不能大于或等于结束时间!");
		return false;
	}
	var selections=mygrid.getSelectionModel().selections;
	for(ii=0;ii<selections.length;ii++)
	{
		var cell=selections[ii];
		var rowIndexNum = cell[0];
		var cellIndexNum = cell[1];
		
		var cellvaue=mygrid.store.getAt(rowIndexNum).get(cm.getDataIndex(cellIndexNum));
		if(cellvaue=="")
		{
			mygrid.store.getAt(rowIndexNum).set(cm.getDataIndex(cellIndexNum),RestComboDesc);
		}
		else{
			mygrid.store.getAt(rowIndexNum).set(cm.getDataIndex(cellIndexNum),cellvaue+"/"+RestComboDesc);
		}
		
		//护士^班次^班次类型^班次日期^班次开始时间^班次结束时间^备注^排班护士长
		var NurseId = mygrid.getStore().getAt(rowIndexNum).get("NurseId");
		var nowDate=new Date(cm.getDataIndex(cellIndexNum).substring(4).replace(/\-/g,'/')).format('Y-m-d');
		var NurseType=mygrid.getStore().getAt(rowIndexNum).get("NurseType");
		var parrStr=WardId+"^"+NurseId+"^"+RestComboId+"^Rest^"+nowDate+"^"+RestStTime.toString()+"^"+RestEndTime.toString()+"^^"+session['LOGON.USERCODE']+"^H^"+NurseType;
		if(parm=="") parm=parrStr;
		else parm=parm+"!"+parrStr;
	}
	SaveArgJobData(gridStr,parm);
	return true;
}

function SaveArgJobData(gridStr,parr)
{
	var SaveAJData = document.getElementById("SaveAJData");
	var ret = cspRunServerMethod(SaveAJData.value,parr);
	Ext.getCmp('mygrid').store.commitChanges(); 
	//FindArgJobData();
	setColor();
}

function FindArgJobData()
{
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.load({params:{start:0,limit:1000}});
}

function getArgJob()
{
	var WardId=combo.getValue();
	if(WardId=="")
	{
		Ext.Msg.alert("提示","请先选择病区");
		return;
	}
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var daynum=EndDate.getValue().format('N')
	var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
	var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
	var parr = WardId+"^"+firstDay+"^"+lastDay;
	var Assignment=Ext.getCmp("Assignment");
	var getArgJob=document.getElementById("getArgJob").value;
	var ret=cspRunServerMethod(getArgJob,parr);
	if(ret!="")
	{
		var array=SplitStr(ret);
		var Remarks=array['Remarks'].replace(/_n/g,"\n");
		Assignment.setValue(Remarks);
	}
}
function getlastArgJob()
{
	var WardId=combo.getValue();
	if(WardId=="")
	{
		Ext.Msg.alert("提示","请先选择病区");
		return;
	}
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var daynum=EndDate.getValue().format('N')
	var AdmDate=((new Date(EndDateVal)).add(Date.DAY,1-daynum));
	var lastEndDate=AdmDate.add(Date.DAY,-1).format('Y-m-d');
	var lastStDate=AdmDate.add(Date.DAY,-7).format('Y-m-d');
	var parr=WardId+"^"+lastStDate+"^"+lastEndDate;
	var Assignment=Ext.getCmp("Assignment");
	var getArgJob=document.getElementById("getArgJob").value;
	var ret=cspRunServerMethod(getArgJob,parr);
	if(ret!="")
	{
		var array=SplitStr(ret);
		var Remarks=array['Remarks'].replace(/_n/g,"\n");
		Assignment.setValue(Remarks);
	}
}
function replaceStrAll(Str,strExp1,strExp2)
{
	while(Str.indexOf(strExp1)!=-1)
	{
		Str=Str.replace(strExp1,strExp2);
	}
	return Str;
}
function SplitStr(Str)
{
	if(Str==null) return [];
	var array=new Array();
	var StrArr=Str.split("^");
	for(i=0;i<StrArr.length;i++)
	{
		if(StrArr[i]!="")
		{
			var StrArr2=StrArr[i].split("|");
			array[StrArr2[0]]=StrArr2[1];
		}
	}
	return array;
}
function SplitStr2(Str)
{
	var array=new Array();
	var StrArr=Str.split("^");
	for(i=0;i<StrArr.length;i++)
	{
		var StrArr2=StrArr[i].split("|");
		array[i]=new Array();
		array[i][0]=StrArr2[0];
		array[i][1]=StrArr2[1];
	}
	return array;
}
function ExportAJMData()
{
	REC=new Array();
	//var Template=webIP+"/dthealth/med/Results/Template/DHCNURARGJOBLIST.xls"
	var wardid=combo.getValue();
	var stdate = StDate.getValue().format('Y-m-d');
	var endate = EndDate.getValue().format('Y-m-d');
	var parr=wardid+"^"+stdate+"^"+endate;
	var getQueryData=document.getElementById('getQueryData').value
	var a=cspRunServerMethod(getQueryData,"DHCMGNUR.MgNurArrangeJob.FindAJData","parr$"+parr,"AddRec")
	var rowlen=REC.length;
	if(rowlen==0)
	{
		Ext.Msg.alert("提示","没有数据");
		return;
	}
	var xls = new ActiveXObject("Excel.Application");
	//xls.visible = true;
	var xlBook = xls.Workbooks.Add();
	var xlSheet = xlBook.ActiveSheet;
	xlSheet.PageSetup.LeftMargin= 1/0.035;         //页边距 左2厘米   
  xlSheet.PageSetup.RightMargin = 1/0.035;      //页边距 右3厘米，   
  xlSheet.PageSetup.TopMargin = 1/0.035;        //页边距 上4厘米，   
  xlSheet.PageSetup.BottomMargin = 1/0.035;   //页边距 下5厘米   

	var mygrid=Ext.getCmp('mygrid');
	var cm=mygrid.getColumnModel();
	var view = mygrid.getView();
	
	
	var collen=0; 
	xlSheet.rows(3).HorizontalAlignment = 3;
	xlSheet.rows(4).HorizontalAlignment = 3;
	//for(var col=1;col<cm.getColumnCount()-5;col++)
	for(var col=1;col<cm.getColumnCount()-3;col++)
	{
		if(cm.getColumnWidth(col)!=0)
		{
			collen++;
			xlSheet.Columns(collen).ColumnWidth=9;
			if(cm.getColumnHeader(col).indexOf('<br>')!=-1)
			{
				xlSheet.Cells(3,collen).value="'"+cm.getColumnHeader(col).split("<br>")[0];
				xlSheet.Cells(4,collen).value="'"+cm.getColumnHeader(col).split("<br>")[1];
			}
			else{
				var thiscolASCII=String.fromCharCode(64+collen);
				xlSheet.Range(thiscolASCII+"3:"+thiscolASCII+"4").MergeCells = true;
				xlSheet.Cells(3,collen).VerticalAlignment = 2;
				xlSheet.Cells(3,collen).value=cm.getColumnHeader(col);
			}
		}
	}
	
	var lastASCII=String.fromCharCode(64+parseInt(collen));
	xlSheet.Range("A1:"+lastASCII+"1").MergeCells = true;
	xlSheet.Cells(1,1).Value=combo.getRawValue().split('-')[1]+"工作安排表";
	xlSheet.Cells(1,1).Font.Size = 16; 
	xlSheet.Cells(1,1).Font.Bold = true;
	xlSheet.rows(1).rowHeight=30;
	xlSheet.rows(1).HorizontalAlignment = 3;
	xlSheet.Cells(2,1).Value="制表时间："+(new Date()).toLocaleDateString()+" "+(new Date()).format('H:i:s');
	xlSheet.Cells(2,5).Value="时间段："+stdate+" 至 "+endate;
	
	var retArray=SplitStr(getSpace());
	var SpaceStr=';'+retArray['SpaceLoc']+';';
	var spacelen=0;
  var ret=tkMakeServerCall("DHCMGNUR.MgNurArrangeJob","GetDataType",parr);
  var array=SplitStr(ret);
	for(var k=0;k<rowlen;k++) {
		if(SpaceStr.indexOf(";"+(k+1)+";")!=-1)
		{
			xlSheet.Rows(5+k+spacelen).Interior.ColorIndex = 24;
			xlSheet.Rows(5+k+spacelen).RowHeight=5;
			spacelen++;
		}
		xlSheet.Rows(5+k+spacelen).rowHeight=22;
		xlSheet.Rows(5+k+spacelen).Font.Size=9;
		xlSheet.Rows(5+k+spacelen).WrapText=true;
		var collen2=0;
		for(var col=1;col<cm.getColumnCount()-3;col++)
		{
			if(cm.getColumnWidth(col)!=0)
			{
				collen2++;
				if(REC[k][cm.getDataIndex(col)]!=null)
				{
					xlSheet.Cells(5+k+spacelen,collen2).HorizontalAlignment=3;
					xlSheet.Cells(5+k+spacelen,collen2).Value="'"+REC[k][cm.getDataIndex(col)];
					if(cm.getDataIndex(col)=="NurseName")
					{
						if(REC[k]['NurseType']=="P")
						{
							xlSheet.Cells(5+k+spacelen,collen2).Font.ColorIndex=7; 
							xlSheet.Cells(5+k+spacelen,collen2).Value+="*"; 
						}
						if(REC[k]['NurseType']=="S") 
						{
							xlSheet.Cells(5+k+spacelen,collen2).Font.ColorIndex=5; 
							xlSheet.Cells(5+k+spacelen,collen2).Value+="*"; 
						}
						if(REC[k]['NurseType']=="W")
						{
							xlSheet.Cells(5+k+spacelen,collen2).Font.ColorIndex=22;
							xlSheet.Cells(5+k+spacelen,collen2).Value+="*"; 
						}
					}
					if(cm.getDataIndex(col).indexOf('Date')!=-1)
					{
						var arrindex=REC[k]['NurseId']+'-'+cm.getDataIndex(col).substring(4);
						if(array[arrindex]=="H")
	      		{
	      			xlSheet.Cells(5+k+spacelen,collen2).Interior.ColorIndex=36;
	      		}
	      		if(array[arrindex]=="H-J"||array[arrindex]=="P-N")
	      		{
	      			xlSheet.Cells(5+k+spacelen,collen2).Font.ColorIndex=3;
	      		}
					}
				}
			}
		}
	}
	mygridlist(xlSheet,3,4+rowlen+spacelen,1,collen);
	xlSheet.Range("A"+(5+rowlen+spacelen)+":"+lastASCII+(5+rowlen+spacelen)).MergeCells = true;
	var Assignment=Ext.getCmp('Assignment').getValue();
	xlSheet.Rows(5+rowlen+spacelen).RowHeight =50;
	xlSheet.Cells(5+rowlen+spacelen,1).VerticalAlignment=1
	xlSheet.Cells(5+rowlen+spacelen,1).Value="备注："+Assignment;
	//xlSheet.PrintOut(1,1,1,false,"",false,false);
	//xlSheet.PageSetup.BottomMargin = 3/0.035;
	var fname = xls.GetSaveAsFilename("排班表.xls", "Excel Spreadsheets (*.xls), *.xls");
  if (fname!=""){
  	xlBook.SaveAs(fname);
  }
	xlBook.Close (savechanges=false);
	xls.Quit();
	idTmr = window.setInterval("Cleanup();",1);
}
function getSpace()
{
	var wardid=combo.getValue();
	var StDateVal=StDate.getValue().format('Y-m-d');
	var EndDateVal=EndDate.getValue().format('Y-m-d');
	var parr=wardid+"^"+StDateVal+"^"+EndDateVal;
	var getAJValue=document.getElementById('getAJValue').value;
	var ret=cspRunServerMethod(getAJValue,parr);
//	var SpaceArr=new Array();
//	if(ret!="")
//	{
//		var array=SplitStr(ret);
//		if(array['SpaceLoc']!="") 
//		{
//			SpaceArr=array['SpaceLoc'].split(';');
//		}
//	}
	return ";"+ret+";";
}
function PrintAJMData()
{
	REC=new Array();
	//var Template=webIP+"/dthealth/med/Results/Template/DHCNURARGJOBLIST.xls"
	var wardid=combo.getValue();
	var stdate = StDate.getValue().format('Y-m-d');
	var endate = EndDate.getValue().format('Y-m-d');
	var parr=wardid+"^"+stdate+"^"+endate;
	var getQueryData=document.getElementById('getQueryData').value
	var a=cspRunServerMethod(getQueryData,"DHCMGNUR.MgNurArrangeJob.FindAJData","parr$"+parr,"AddRec")
	var rowlen=REC.length;
	if(rowlen==0)
	{
		Ext.Msg.alert("提示","没有数据");
		return;
	}
	var xls = new ActiveXObject("Excel.Application");
	//xls.visible = true;
	var xlBook = xls.Workbooks.Add();
	var xlSheet = xlBook.ActiveSheet;
	xlSheet.PageSetup.LeftMargin= 1/0.035;         //页边距 左2厘米   
  xlSheet.PageSetup.RightMargin = 0/0.035;      //页边距 右3厘米，   
  xlSheet.PageSetup.TopMargin = 1/0.035;        //页边距 上4厘米，   
  xlSheet.PageSetup.BottomMargin = 1/0.035;   //页边距 下5厘米   

	var mygrid=Ext.getCmp('mygrid');
	var cm=mygrid.getColumnModel();
	var view = mygrid.getView();
	
	
	var collen=0; 
	xlSheet.rows(3).HorizontalAlignment = 3;
	xlSheet.rows(4).HorizontalAlignment = 3;
	for(var col=1;col<cm.getColumnCount()-3;col++)
	{
		if(cm.getColumnWidth(col)!=0)
		{
			collen++;
			xlSheet.Columns(collen).ColumnWidth=11;
			if(collen==1) xlSheet.Columns(collen).ColumnWidth=6;
			if(collen==2){
				xlSheet.Columns(collen).WrapText=true;
				xlSheet.Columns(collen).ColumnWidth=3;
			}
			if(collen==3) xlSheet.Columns(collen).ColumnWidth=6;
			if(cm.getColumnHeader(col).indexOf('<br>')!=-1)
			{
				xlSheet.Cells(3,collen).value="'"+cm.getColumnHeader(col).split("<br>")[0];
				xlSheet.Cells(4,collen).value="'"+cm.getColumnHeader(col).split("<br>")[1];
			}
			else{
				var thiscolASCII=String.fromCharCode(64+collen);
				xlSheet.Range(thiscolASCII+"3:"+thiscolASCII+"4").MergeCells = true;
				xlSheet.Cells(3,collen).VerticalAlignment = 2;
				xlSheet.Cells(3,collen).value=cm.getColumnHeader(col);
			}
		}
	}
	
	var lastASCII=String.fromCharCode(64+parseInt(collen));
	xlSheet.Range("A1:"+lastASCII+"1").MergeCells = true;
	xlSheet.Cells(1,1).Value=combo.getRawValue().split('-')[1]+"工作安排表";
	xlSheet.Cells(1,1).Font.Size = 16; 
	xlSheet.Cells(1,1).Font.Bold = true;
	xlSheet.rows(1).rowHeight=30;
	xlSheet.rows(1).HorizontalAlignment = 3;
	xlSheet.Cells(2,1).Value="制表时间："+(new Date()).toLocaleDateString()+" "+(new Date()).format('H:i:s');
	xlSheet.Cells(2,5).Value="时间段："+stdate+" 至 "+endate;
	
	var retArray=SplitStr(getSpace());
	var SpaceStr=';'+retArray['SpaceLoc']+';';
	var spacelen=0;
  var ret=tkMakeServerCall("DHCMGNUR.MgNurArrangeJob","GetDataType",parr);
  var array=SplitStr(ret);
	for(var k=0;k<rowlen;k++) {
		if(SpaceStr.indexOf(";"+(k+1)+";")!=-1)
		{
			xlSheet.Rows(5+k+spacelen).Interior.ColorIndex = 24;
			xlSheet.Rows(5+k+spacelen).RowHeight=5;
			spacelen++;
		}
		xlSheet.Rows(5+k+spacelen).rowHeight=22;
		xlSheet.Rows(5+k+spacelen).Font.Size=9;
		xlSheet.Rows(5+k+spacelen).WrapText=true;
		var collen2=0;
		for(var col=1;col<cm.getColumnCount()-3;col++)
		{
			if(cm.getColumnWidth(col)!=0)
			{
				collen2++;
				if(REC[k][cm.getDataIndex(col)]!=null)
				{
					xlSheet.Cells(5+k+spacelen,collen2).HorizontalAlignment=3;
					if(REC[k][cm.getDataIndex(col)].split(' ').length==3){
						var cellarr=REC[k][cm.getDataIndex(col)].split(' ');
						xlSheet.Cells(5+k+spacelen,collen2).Value="'"+cellarr[0]+' '+cellarr[1]+'\n'+cellarr[2];
					}
					else xlSheet.Cells(5+k+spacelen,collen2).Value="'"+REC[k][cm.getDataIndex(col)];
					if(cm.getDataIndex(col)=="NurseName")
					{
						if(REC[k]['NurseType']=="P")
						{
							xlSheet.Cells(5+k+spacelen,collen2).Font.ColorIndex=7;
							xlSheet.Cells(5+k+spacelen,collen2).Value+="*"; 
						}
						if(REC[k]['NurseType']=="S") 
						{
							xlSheet.Cells(5+k+spacelen,collen2).Font.ColorIndex=5;
							xlSheet.Cells(5+k+spacelen,collen2).Value+="*";  
						}
						if(REC[k]['NurseType']=="W")
						{
							xlSheet.Cells(5+k+spacelen,collen2).Font.ColorIndex=22;
							xlSheet.Cells(5+k+spacelen,collen2).Value+="*"; 
						}
					}
					if(cm.getDataIndex(col).indexOf('Date')!=-1)
					{
						var arrindex=REC[k]['NurseId']+'-'+cm.getDataIndex(col).substring(4);
						if(array[arrindex]=="H")
	      		{
	      			xlSheet.Cells(5+k+spacelen,collen2).Interior.ColorIndex=36;
	      		}
	      		if(array[arrindex]=="H-J"||array[arrindex]=="P-N")
	      		{
	      			xlSheet.Cells(5+k+spacelen,collen2).Font.ColorIndex=3;
	      		}
					}
				}
			}
		}
	}
	mygridlist(xlSheet,3,4+rowlen+spacelen,1,collen);
	xlSheet.Range("A"+(5+rowlen+spacelen)+":"+lastASCII+(5+rowlen+spacelen)).MergeCells = true;
	var Assignment=Ext.getCmp('Assignment').getValue();
	xlSheet.Rows(5+rowlen+spacelen).RowHeight =50;
	xlSheet.Cells(5+rowlen+spacelen,1).VerticalAlignment=1
	xlSheet.Cells(5+rowlen+spacelen,1).Value="备注："+Assignment;
	//xlSheet.PrintOut(1,1,1,false,"",false,false);
	//xlSheet.PageSetup.BottomMargin = 3/0.035;
	xlSheet.PrintOut();
	xlBook.Close (savechanges=false);
	xls.Quit();
	idTmr = window.setInterval("Cleanup();",1);
}
function Cleanup(){   
 	window.clearInterval(idTmr);   
 	CollectGarbage();
}
function AddRec(a)
{
	var array=SplitStr(a);
	REC.push(array);
}

function mygridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
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
function ChangeAsciiCode(parr)
{
	var codeStr='A';
	var AsciiStr="";
	if(parr<=26) AsciiStr = String.fromCharCode(codeStr.charCodeAt() + parr-1);
	else{
		if(parr>702) return;
		if (parr==702) AsciiStr = "ZZ";
		else{
			var parrInt = parseInt(parr/26-1);
			var parrMode = (parr-1)%26;
			AsciiStr = String.fromCharCode(codeStr.charCodeAt() + parrInt) + String.fromCharCode(codeStr.charCodeAt() + parrMode);
		}
	}
	return AsciiStr;
}

function deleteRosterData(gridStr)
{
	var mygrid = Ext.getCmp(gridStr);
	var cm=mygrid.getColumnModel();
	var WardId=combo.getValue();
	var parm="";
	var selections=mygrid.getSelectionModel().selections;
	for(ii=0;ii<selections.length;ii++)
	{
		var cell=selections[ii];
		var rowIndexNum = cell[0];
		var cellIndexNum = cell[1];
		var cellValue = mygrid.getStore().getAt(rowIndexNum).get("Item"+(cellIndexNum-2));
		if(cellValue!="")
		{
			//mygrid.getStore().getAt(rowIndexNum).set("Item"+(cellIndexNum-2),"");
			var NurseId = mygrid.getStore().getAt(rowIndexNum).get("NurseId");
			var nowDate=new Date(cm.getDataIndex(cellIndexNum).substring(4).replace(/\-/g,'/')).format('Y-m-d');
			var NurseType=mygrid.getStore().getAt(rowIndexNum).get("NurseType");
			var parr=WardId+"^"+NurseId+"^"+nowDate+"^"+NurseType;
			if(parm=="") parm=parr;
			else parm=parm+"!"+parr;
		}
	}
	var deleteRosterData=document.getElementById("deleteRosterData");
	if(parm!="") {
		cspRunServerMethod(deleteRosterData.value,parm);
		FindArgJobData();
	}
}

function copyRosterData(gridStr)
{
	REC2 = new Array(); 
	var mygrid = Ext.getCmp(gridStr);
	var cm=mygrid.getColumnModel();
	var selections = mygrid.getSelectionModel().selections;
	for(i=0;i<selections.length;i++)
	{
		var row = selections[i][0];
		var col = selections[i][1];
		var perid=mygrid.store.getAt(row).get('NurseId');
		var tdate=new Date(cm.getDataIndex(col).substring(4).replace(/\-/g,'/')).format('Y-m-d');
		var pertype=mygrid.store.getAt(row).get('NurseType');
		REC2[i] = new Array(row,col,perid,tdate,pertype);
	}
}

function pasteRosterData(gridStr)
{
	var mygrid = Ext.getCmp(gridStr);
	var cm=mygrid.getColumnModel();
	var wardId = combo.getValue();
	var array = REC2;
	if(array.length==0){ 
		alert("未复制任何内容");
		return;
	}
	var selections = mygrid.getSelectionModel().selections;
	var strow=selections[0][0];
	var stcol=selections[0][1];
	for(var i=0;i<array.length;i++)
	{
		var row = array[i][0];
		var col = array[i][1];
		var rowdistance = row - array[0][0];
		var coldistance = col - array[0][1]
		//复制单元格
		var NurseId = array[i][2];
		var nowDate=array[i][3];
		var NurseType=array[i][4];
		var parr = wardId+"^"+NurseId+"^"+nowDate+"^"+NurseType; 
		var FindNurRosterData = document.getElementById("FindNurRosterData");
		var ret = cspRunServerMethod(FindNurRosterData.value,parr);
		//对应粘贴单元格
		var rowIndex = strow + rowdistance;
		if(rowIndex < mygrid.store.getTotalCount()){
			var colIndex = stcol + coldistance;
			var NurseId2 = mygrid.getStore().getAt(rowIndex).get("NurseId");
			var nowDate2 =new Date(cm.getDataIndex(colIndex).substring(4).replace(/\-/g,'/')).format('Y-m-d');
			var EndDateValue = EndDate.getValue().format('Y-m-d')
			var NurseType2=mygrid.getStore().getAt(rowIndex).get("NurseType");
			if(nowDate2<=EndDateValue){
				if(ret!=""){
					var a = ret.split("^");
					//OutPut:AJType^AJCodeDR^AJStTime^AJEndTime^AJJobInterval^AJRemarks
					//Input:病区^护士^班次^班次类型^班次日期^班次开始时间^班次结束日期^备注^排班护士长^时段
					var parrStr=combo.getValue()+"^"+NurseId2+"^"+a[1]+"^"+a[0]+"^"+nowDate2+"^"+a[2]+"^"+a[3]+"^"+a[5]+"^"+session['LOGON.USERCODE']+"^"+a[4]+"^"+NurseType2;
					var SaveAJData2 = document.getElementById("SaveAJData2");
					var ret = cspRunServerMethod(SaveAJData2.value,parrStr);
				}
			}
		}
	}
	FindArgJobData();
}
function connectBed(gridStr)
{
	var bedColumn=new Ext.grid.ColumnModel([
    { header: "床位", width: 80, dataIndex: 'BedCode'},
    { header: "房间", width: 150, dataIndex: 'BedRoom'},
    { header: "BedId", width: 0,  dataIndex: 'BedId'}
 	]);
	var bedstore = new Ext.data.JsonStore({
		id:'bedstore',idIndex: 0,
		fields:['BedCode','BedRoom','BedId']
  });
  var bedtable=new Ext.grid.GridPanel({
		id:'bedlistgrid',title:'床位列表',
		width:335,height:500,x:201,y:0,
		cm:bedColumn,store:bedstore //,
//		bbar:new Ext.PagingToolbar({ 
//       pageSize: 1000, store: groupstore, displayInfo: true, 
//       displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
//       emptyMsg: "没有记录" 
//    })
	});
	var groupColumn=new Ext.grid.ColumnModel([ 
		new Ext.grid.RowNumberer(),
		new Ext.grid.CheckboxSelectionModel(),
    { header: "组代码", width: 70, dataIndex: 'GroupCode'},
    { header: "组名称", width: 70, dataIndex: 'GroupDesc'},
    { header: "GroupId", width: 0,  dataIndex: 'GroupId'}
 	]);
	var groupstore = new Ext.data.JsonStore({
		id:'groupstore',idIndex: 0,
		fields:['GroupCode','GroupDesc','GroupId']
  });
	var grouptable=new Ext.grid.GridPanel({
		id:'grouplistgrid',title:'床位分组列表',
		width:200,height:500,x:0,y:0,
		cm:groupColumn,store:groupstore,
		sm:new Ext.grid.CheckboxSelectionModel(),
		tbar:['-',new Ext.Button({id:'connbtn',text:'关联',icon:'../Image/icons/link_edit.png',handler:function(){saveConnectBed(gridStr);Win.close();}})],
//		bbar:new Ext.PagingToolbar({ 
//        pageSize: 1000, 
//        store: groupstore, 
//        displayInfo: true, 
//        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
//        emptyMsg: "没有记录" 
//    }),
    listeners:{
    	rowclick:function(grid,row,e)
    	{
    		REC=new Array(); 
				//var GroupId=grid.store.getAt(row).get('GroupId');
				var GetQueryData=document.getElementById('getQueryData').value;
				var selections=grid.getSelectionModel().getSelections();
				for(var i=0;i<selections.length;i++)
				{
					var GroupId=selections[i].get('GroupId');
					cspRunServerMethod(GetQueryData,"DHCMGNUR.MgNurBedGroup.FindGroupLinkBed","parr$"+GroupId,"AddLinkBedRec");
				}
				Ext.getCmp('bedlistgrid').store.loadData(REC);
				Ext.getCmp('bedlistgrid').store.sort('BedCode','ASC');
	},
    	headerclick:function( grid, columnIndex, e ){
    		REC=new Array(); 
				//var GroupId=grid.store.getAt(row).get('GroupId');
				var GetQueryData=document.getElementById('getQueryData').value;
				var selections=grid.getSelectionModel().getSelections();
				for(var i=0;i<selections.length;i++)
				{
					var GroupId=selections[i].get('GroupId');
					cspRunServerMethod(GetQueryData,"DHCMGNUR.MgNurBedGroup.FindGroupLinkBed","parr$"+GroupId,"AddLinkBedRec");
				}
				Ext.getCmp('bedlistgrid').store.loadData(REC);
				Ext.getCmp('bedlistgrid').store.sort('BedCode','ASC');
    	}
    }
	});
	var Win=new Ext.Window({
		title : '床位列表',id : "BedListWin",
		x:200,y:50,width : 550,height : 533,
		autoScroll : true,modal:true,
		layout : 'absolute',
		items : [grouptable,bedtable]
	});
	Win.show();
	loadBed();
	setTimeout('getBed("mygrid")',1);  
	setTimeout('getSelectedBed("mygrid")',1);
}
function AddLinkBedRec(a)
{
	var array=SplitStr(a);
	REC.push({
		BedCode:array['BedCode'],
		BedRoom:array['BedRoom'],
		BedId:array['BedId']
	});
}
function getSelectedBed(gridStr)
{
	var getSelectedBed=document.getElementById("getSelectedBed").value;
	var groupgrid=Ext.getCmp('grouplistgrid');
	var mygrid=Ext.getCmp(gridStr);
	var selections=mygrid.getSelectionModel().selections;
	var WardId=combo.getValue();
	for(var i=0;i<selections.length;i++)
	{
		var StDateValue = StDate.getValue().format('m/d/Y');
		var date = new Date(StDateValue);
		var nowDate = date.add(Date.DAY,selections[i][1]-3).format('Y-m-d'); 
		var parr=WardId+"^"+nowDate;
		var ret=cspRunServerMethod(getSelectedBed,parr);
		if(ret!="")
		{
			var array=ret.split(',');
			for(var i=0;i<array.length;i++)
			{
				groupgrid.store.each(function(record)
				{
					if(record.get('GroupId')==array[i])
					{
						var rowIndex=groupgrid.store.indexOf(record);
						groupgrid.getView().getRow(rowIndex).style.backgroundColor="red";
					}
				});
			}
		}
	}
}
function saveConnectBed(gridStr)
{
	var mygrid=Ext.getCmp(gridStr);
	var cm=mygrid.getColumnModel();
	var selections=mygrid.getSelectionModel().selections;
	var WardId=combo.getValue();
	var groupgrid=Ext.getCmp('grouplistgrid');
	var selectionGroup=groupgrid.getSelectionModel().getSelections();
	var groupIds="";
	for(var j=0;j<selectionGroup.length;j++)
	{
		var groupId=selectionGroup[j].get('GroupId');
		if(groupIds=="")
		{
			groupIds=groupId;
		}
		else
		{
			groupIds=groupIds+","+groupId;
		}
	}
	var parm="";
	for(var i=0;i<selections.length;i++)
	{
		var cell=selections[i];
		var rowIndexNum = cell[0];
		var cellIndexNum = cell[1];
		var cellValue = mygrid.getStore().getAt(rowIndexNum).get(cm.getDataIndex(cellIndexNum));
		if(cellValue!="")
		{
			var NurseId = mygrid.getStore().getAt(rowIndexNum).get("NurseId")
			var nowDate=new Date(cm.getDataIndex(cellIndexNum).substring(4).replace(/\-/g,'/')).format('Y-m-d');
			var NurseType = mygrid.getStore().getAt(rowIndexNum).get("NurseType")
			var parr=WardId+"^"+NurseId+"^"+nowDate+"^"+groupIds+"^"+NurseType;
			if(parm=="") parm=parr;
			else parm=parm+"!"+parr;
		}
		else
		{
			alert('存在未排班的记录,不可关联床位');
			return;
		}
	}
	var SaveConnBed=document.getElementById('SaveConnBed').value;
	cspRunServerMethod(SaveConnBed,parm);
}
function loadBed()
{
	REC=new Array(); 
	var GetQueryData = document.getElementById("getQueryData");
	var WardId=combo.getValue();
	var a = cspRunServerMethod(GetQueryData.value,"DHCMGNUR.MgNurBedGroup.FindGroupData", "parr$"+WardId, "AddGroupRec");
	var groupgrid=Ext.getCmp('grouplistgrid');
	groupgrid.store.loadData(REC);
	//groupgrid.store.sort('BedCode','ASC')
}

function AddGroupRec(a)
{
	var array=SplitStr(a);
	REC.push({
		GroupCode:array['GroupCode'],
		GroupDesc:array['GroupDesc'],
		GroupId:array['ID']
	});
}

function getBed(gridStr)
{
	var mygrid=Ext.getCmp(gridStr);
	var cm=mygrid.getColumnModel();
	var groupgrid=Ext.getCmp('grouplistgrid')
	var WardId=combo.getValue();
	var getConnBed=getConnBed=document.getElementById('getConnBed').value;
	var selections=mygrid.getSelectionModel().selections;
	if(selections.length==1)
	{
		var NurseId = mygrid.getStore().getAt(selections[0][0]).get("NurseId");
		var nowDate=new Date(cm.getDataIndex(selections[0][1]).substring(4).replace(/\-/g,'/')).format('Y-m-d');
		var NurseType = mygrid.getStore().getAt(selections[0][0]).get("NurseType")
		var parr=WardId+"^"+NurseId+"^"+nowDate+"^"+NurseType;
		var ret=cspRunServerMethod(getConnBed,parr);
		var array=ret.split(',');
		var Records=new Array();
		for(var i=0;i<array.length;i++)
		{
			groupgrid.store.each(function(record)
			{
				if(record.get('GroupId')==array[i])
				{
					Records.push(record);
				}
			});
		}
		groupgrid.getSelectionModel().selectRecords(Records);
	}
}

function loadLastWeekAssign(gridStr)
{
	var getLastWeekAssign=document.getElementById('getLastWeekAssign').value;
	var WardId=combo.getValue();
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var daynum=EndDate.getValue().format('N')
	var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
	var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
	var parr=WardId+"^"+firstDay+"^"+lastDay;
	parr=parr+"^";
	var ret=cspRunServerMethod(getLastWeekAssign,parr)
	REC=new Array();
	var array=ret.split('^');
	for(var i=0;i<array.length-1;i++)
	{
		Ext.getCmp(gridStr).store.getAt(i).set('JobAssign',array[i]);
	}
}

function sendRec()
{
	var mygrid=Ext.getCmp("mygrid");
	var mystore=mygrid.getStore();
	var count=mystore.getTotalCount();
	var WardId = combo.getValue();
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var daynum=EndDate.getValue().format('N')
	var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
	var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
	var parr=WardId+"^"+firstDay+"^"+lastDay;
	var CheckEmptyPost=document.getElementById('CheckEmptyPost').value;
	var a=cspRunServerMethod(CheckEmptyPost,parr)
	var SetStatus=document.getElementById('SetStatus').value;
	//if(a=="Y")
	//{
	var ret=tkMakeServerCall('DHCMGNUR.MgNurArgJobChild','CheckPerson',parr);
	//alert(ret)
	saveRec("mygrid");
	var b=cspRunServerMethod(SetStatus,parr+"^S");
	if(b==1) alert("发布成功!");
	else alert("发布失败!");
	//}
	//else 
	//{
		//alert(a)
	//	alert('还有未完成的排班，不可发布!');
	//}
	FindArgJobData();
}
function unsendRec()
{
	var mygrid=Ext.getCmp("mygrid");
	var mystore=mygrid.getStore();
	var count=mystore.getTotalCount();
	var WardId = combo.getValue();
	var EndDateVal=EndDate.getValue().format('Y/m/d');
	var daynum=EndDate.getValue().format('N')
	var firstDay=((new Date(EndDateVal)).add(Date.DAY,1-daynum)).format('Y-m-d');
	var lastDay=((new Date(EndDateVal)).add(Date.DAY,7-daynum)).format('Y-m-d');
	var parr=WardId+"^"+firstDay+"^"+lastDay;
	var ret=tkMakeServerCall("DHCMGNUR.MgNurArgJob","getValue",parr);
	if(ret==""){alert("不是发布状态，不可以撤销！"); return;}
	var array=SplitStr(ret);
	if(array["Status"]=="S")
	{
		var SetStatus=document.getElementById('SetStatus').value;
		var b=cspRunServerMethod(SetStatus,parr+"^N");
		if(b==1) alert("撤销发布成功!");
		else alert("撤销发布失败!");
	}
	else 
	{
		alert("不是发布状态，不可以撤销！");
	}
	FindArgJobData();
}

function CopyLastWeek(gridStr)
{
	if(!confirm("确认复制上周排班？"))
	{
		return;
	}
	var mygrid=Ext.getCmp(gridStr);
	var wardid=combo.getValue();
	if(wardid=="")
	{
		alert('请选择排班病区！');
		return;
	}
	var stdate=StDate.getValue();
	var enddate=EndDate.getValue();
	if(stdate.format('N')!=1&&enddate.format('N')!=7&&stdate.add(Date.DAY,6)!=enddate)
	{
		alert('请选择要排班的一周时段！');
		return;
	}
	var parr=wardid+"^"+stdate.format('Y-m-d')+"^"+enddate.format('Y-m-d')+"^"+session['LOGON.USERCODE'];
	var ret=tkMakeServerCall("DHCMGNUR.MgNurArrangeJob","WeekCopy",parr);
	FindArgJobData();
}
function setColor()
{
	var table=Ext.getCmp('mygrid');
	var mystore=table.store;
	var elments1 = Ext.select(".x-grid3-row",true);
	elments1.each(function(el) {
		el.setStyle("border-top-color", '#DCDCDC');
  		el.setStyle("border-color", '#DCDCDC');
 	}, this); 
	var RCount=mystore.getTotalCount();
	var CCount=table.getColumnModel().getColumnCount();
	var view=table.getView();
	var WardId=combo.getValue();
	var stdate = StDate.getValue().format('Y-m-d');
	var endate = EndDate.getValue().format('Y-m-d');
	var ret="";
	for(var tmpdate=StDate.getValue();tmpdate.between(StDate.getValue(),EndDate.getValue());tmpdate=tmpdate.add(Date.DAY,15))
	{
		var tmpenddate=tmpdate.add(Date.DAY,15).format('Y-m-d');
		if(tmpenddate>endate)
		{
			tmpenddate=endate;
		}
		var parr = WardId+"^"+tmpdate.format('Y-m-d')+"^"+tmpenddate;
	  	var tmpret=tkMakeServerCall("DHCMGNUR.MgNurArrangeJob","GetDataType",parr);
	  	if(ret=="") ret=tmpret;
		else ret=ret+"^"+tmpret;
	}
	var array=SplitStr(ret);
	var ret1=tkMakeServerCall("DHCMGNUR.MgNurArgJob","getValue",parr)
	var array1=SplitStr(ret1);
	
	var rows=view.getRows();
	var lrows = view.getLockedRows();
	
	for(var svi=0;svi<RCount;svi++)
	{
		//设置行高
		var row=rows[svi];
		var lrow=lrows[svi];
		var el1 = Ext.get(row),
      el2 = Ext.get(lrow),
      h1 = el1.getHeight(),
      h2 = el2.getHeight(); 
    if(h1 > h2){
        el2.setHeight(h1);    
    }else if(h2 > h1){
        el1.setHeight(h2);
    }
    
		var NurseId=mystore.getAt(svi).get('NurseId');
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
			cell.style.color='#F08080';
		}
		if(NurType=="T"){
    	cell=view.getCell(svi,2);
      cell.style.color='#00CED1';
    }
		if((secGrpFlag!="nurse")||((secGrpFlag=="nurse")&&(array1["Status"]=="S")))
		{
  		for(var admdate=StDate.getValue();admdate.between(StDate.getValue(),EndDate.getValue());admdate=admdate.add(Date.DAY,1))
  		{
  			//var cvi=table.colModel.getIndexById('Date'+admdate.format('Y-m-d'));
  			var cvi=table.colModel.findColumnIndex('Date'+admdate.format('Y-m-d'));
    		var arrindex=NurseId+'-'+admdate.format('Y-m-d');
    		var cell=view.getCell(svi,cvi);
    		if(array[arrindex]=="H")
    		{
    			cell.style.backgroundColor='#FFFF99';
    		}
    		if(array[arrindex]=="H-J"||array[arrindex]=="P-N")
    		{
    			cell.style.color='#FF0000';
    		}
    	}
			if(CheckSpace(svi+1)==1)
			{
				row=view.getRow(svi);
				row.style.borderTopWidth="5";
				row.style.borderTopColor="#C0C0C0";
			}
		}
	}
}