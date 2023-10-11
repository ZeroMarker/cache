function BodyLoadHandler()
{
	setsize("mygridpl","gform","mygrid",0);
	var mygridpl=Ext.getCmp('mygridpl');
//  mygridpl.setHeight(window.screen.availHeight-80)
//  alert("document.body.offsetHeight:"+document.body.offsetHeight)
	var grid = Ext.getCmp('mygrid');
	var tobar=grid.getTopToolbar(); 
	tobar.hide();  
	var getVal=document.getElementById('getVal');  
	var but1=Ext.getCmp("mygridbut1");	
	but1.hide();
	var but=Ext.getCmp("mygridbut2");
	but.hide();	
	var mygrid = Ext.getCmp("mygrid");
	tbar2=new Ext.Toolbar({});
	tbar2.addItem("-");
	tbar2.addButton({
		text:'增加',
		handler:function(){addNew();},
		id:'btnAdd',
		icon:'../images/uiimages/edit_add.png'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:'编辑',
		handler:function(){editAdd();},
		id:'btnEdit',
		icon:'../images/uiimages/pencil.png'	
	});
	tbar2.addItem("-")
	tbar2.addButton({
		text:'删除',
		handler:function(){delRecord();},
		id:'btnDelete',
		icon:'../images/uiimages/edit_remove.png'
	});
	tbar2.addItem("-")		
	tbar2.addButton(
	{
		text:"查询",
		handler:function(){SchQual(PerID);},
		id:'btnSch',
		icon:'../images/uiimages/search.png'
	});
	mygrid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	tbar2.render(grid.tbar);
	bbar2.render(mygrid.bbar);
	tobar.doLayout();
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on("beforeLoad",function(){
	 var mygrid = Ext.getCmp("mygrid");
	 mygrid.store.baseParams.parr=PerID;
	 // mygrid.store.baseParams.rowid=RowId;
	});
	var len=mygrid.getColumnModel().getColumnCount()
	for(var i=0;i<len;i++){
		if((mygrid.getColumnModel().getDataIndex(i)=="rw")||(mygrid.getColumnModel().getDataIndex(i)=="PerTranMem")){
			mygrid.getColumnModel().setHidden(i,true);
		}
	}
	SchQual(PerID);
}

function SchQual(parr)
	{
		var mygrid = Ext.getCmp("mygrid"); 
		mygrid.store.load({
				params : {
					start : 0,
					limit : 30
				}
			});		
		mygrid.store.sort('PerTranStDate','asc');	
	}
	///删除记录
	function delRecord()
	{
		var grid = Ext.getCmp("mygrid");
		var rowObj = grid.getSelectionModel().getSelections();
		if (rowObj.length == 0) {
			Ext.Msg.alert('提示',"请选择一条记录！");
			return;
		}
		var flag=rowObj[0].get('PerTranCurrent');
		if(flag=="Y"){
			Ext.Msg.alert('提示',"此条记录不能删除！");
			return;
		}
		if (confirm('确定删除选中的项？')) {
			var Par=rowObj[0].get('rw');
			var Delete=document.getElementById('Delete');
			var a=cspRunServerMethod(Delete.value,Par);
			Ext.Msg.alert('提示',a)
			SchQual();
		}	
	}
	///修改记录
function editAdd()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}	
	var flag=rowObj[0].get('PerTranCurrent');
	if(flag=="Y"){
		Ext.Msg.alert('提示',"此条记录不能修改！");
		return;
	}
	var Par = rowObj[0].get("rw");
	//var getVal=document.getElementById('getVal');
	//var ret=cspRunServerMethod(getVal.value,RowId);
	//alert(RowId)
	//var ha = new Hashtable();
  //var tm=ret.split('^')
	//sethashvalue(ha,tm);
	var getValue=document.getElementById('getValue');
	var ret1=cspRunServerMethod(getValue.value,Par);
	var ha1=new Hashtable();
	var tm1=ret1.split('^');
	sethashvalue(ha1,tm1);
	var aa=cspRunServerMethod(pdata1,"","DHCNURPerExHisAdd","","");
	arr=eval(aa);
	var window=new Ext.Window({
		title:'编辑',
		id:"gfrom21",
		x:200,y:150,
		width:400,
		height:220,
		autoScroll:true,
		layout:'absolute',
		items:[arr],
		modal:true,
		resizable:false
	});	
	var perDepart=Ext.getCmp('PerDepart');
	perDepart.setEditable(false);
	var perName=Ext.getCmp('PerName');
	perName.disabled=true;
	Ext.getCmp('PerName').setValue(ha1.items('PerName'));	
	var perID=Ext.getCmp('PerID');
	perID.disabled=true;
	Ext.getCmp('PerID').setValue(ha1.items('PerID'));	
	var departComboStore=Ext.getCmp('PerDepart').getStore();
	Ext.getCmp('PerDepart').pageSize=1000;
	Ext.getCmp('PerDepart').listWidth=Ext.getCmp('PerDepart').width;
	departComboStore.load({params:{start:0,limit:1000}});
	departComboStore.on('load',function(departComboStore, records, options){						
		Ext.getCmp('PerDepart').selectText();
		Ext.getCmp('PerDepart').setValue(ha1.items('PerDepart'));
	});
	Ext.getCmp('PerTranStDate').setValue(ha1.items('PerTranStDate'));
	Ext.getCmp('PerTranEndDate').setValue(ha1.items('PerTranEndDate'));
	window.show();
	var PerTranStDate=Ext.getCmp('PerTranStDate');
	PerTranStDate.on('select',function(dateField,date){
		var endDate=Ext.getCmp('PerTranEndDate').getValue();
		//alert(1)
		if(endDate!=""){
			var flag=date.between(date,endDate);
			if(!flag){
					Ext.Msg.alert('提示',"开始时间不能大于结束时间！");
				  PerTranStDate.setValue("");
			}				
		}
	});
	var EndDate=Ext.getCmp('PerTranEndDate');
	EndDate.on('select',function(dateField,date){
		var stDate=Ext.getCmp('PerTranStDate').getValue();
		if(stDate!=""){
			var flag=date.between(stDate,date);
			if(!flag){
				Ext.Msg.alert('提示','结束时间不能小于开始时间！');
				EndDate.setValue('');
			}
		}
	})
	var edit1="1";
	var btnSave=Ext.getCmp('btnSave');
	btnSave.setText("更新");
	var btnSave=Ext.getCmp('btnSave');
	btnSave.setIcon('../images/uiimages/reload.png');
	btnSave.on("click",function(){SureCheck(RowId,edit1,Par);SchQual();});
}
///新建记录
function addNew()
{
	var getVal=document.getElementById('getVal');
	var ret=cspRunServerMethod(getVal.value,RowId);
	var ha = new Hashtable();
  var tm=ret.split('^');
	sethashvalue(ha,tm);
	var a = cspRunServerMethod(pdata1, "", "DHCNURPerExHisAdd", "", "");
	arr = eval(a);
	var window= new Ext.Window({
		title : '添加历史调科记录',
		id : 'gform2',
		x:200,y:150,
		width : 400,
		height : 220,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [arr],
		modal:true,
		resizable:false
	});
	var perDepart=Ext.getCmp('PerDepart');
	perDepart.setEditable(false);
	var perName=Ext.getCmp('PerName');
	perName.disabled=true;
	var perID=Ext.getCmp('PerID');
	perID.disabled=true;
	Ext.getCmp('PerName').setValue(ha.items('PerName'));
	Ext.getCmp('PerID').setValue(PerID);
	window.show();
	var edit1="0";
	var Par="0"
	var btnSave=Ext.getCmp('btnSave');
	btnSave.setIcon('../images/uiimages/filesave.png');
	btnSave.on('click',function(){SureCheck(RowId,edit1,Par);SchQual();});
	var PerTranStDate=Ext.getCmp('PerTranStDate');
	PerTranStDate.on('select',function(dateField,date){
		var endDate=Ext.getCmp('PerTranEndDate').getValue();
		//alert(1)
		if(endDate!=""){
			var flag=date.between(date,endDate);
			if(!flag){
					Ext.Msg.alert('提示',"开始时间不能大于结束时间！");
				  PerTranStDate.setValue("");
			}				
		}
	});
	var EndDate=Ext.getCmp('PerTranEndDate');
	EndDate.on('select',function(dateField,date){
		var stDate=Ext.getCmp('PerTranStDate').getValue();
		if(stDate!=""){
			var flag=date.between(stDate,date);
			if(!flag){
				Ext.Msg.alert('提示','结束时间不能小于开始时间！');
				EndDate.setValue('');
			}
		}
	})
}
//function selectDate(df,date)
//{
//	if(df.id=="PerTranStDate"){
//		var stdate=Ext.getCmp('JXPersonStDate').getValue();
//		var enddate=Ext.getCmp('JXPersonEndDate').getValue()
//		if(enddate!=""&&stdate!=""&&stdate>enddate)
//		{		
//			alert("开始日期不能小于结束日期！")
//			Ext.getCmp('JXPersonEndDate').setValue(stdate)
//		}	
//	}
//}
function SureCheck(RowId,edit1,Par)
{
	var PerName=Ext.getCmp('PerName').getValue(); //姓名
	var PerID=Ext.getCmp('PerID').getValue(); //工号
	var PerDepart=Ext.getCmp('PerDepart').getValue(); //科室
	if(PerDepart==""){Ext.Msg.alert('提示',"科室不能为空！");return;}
	var PerTranStDate=Ext.getCmp('PerTranStDate').getValue();
	if(PerTranStDate==""){
		Ext.Msg.alert('提示',"请选开始日期！");
		return;
	}else{
		if(PerTranStDate instanceof Date){
			PerTranStDate = PerTranStDate.format('Y-m-d');
		}
	}
	
	var PerTranEndDate=Ext.getCmp('PerTranEndDate').getValue();
	if(PerTranEndDate==""){
		Ext.Msg.alert('提示',"请选择结束日期！");
		return;
	}else{
		if(PerTranEndDate instanceof Date){
			PerTranEndDate = PerTranEndDate.format('Y-m-d');	
		}
	}
	var parr=RowId+"^"+PerName+"^"+PerID+"^"+PerDepart+"^"+PerTranStDate+"^"+PerTranEndDate+"^"+edit1+"^"+Par;
	//alert(parr)
	var SaveHis = document.getElementById('SaveHis');
	var a=cspRunServerMethod(SaveHis.value,parr);
	if (edit1==0){
		var gform2=Ext.getCmp('gform2');
		gform2.close();
	}
	else if (edit1==1){
		var gform21=Ext.getCmp('gfrom21');
		gform21.close();
	}
	
}
