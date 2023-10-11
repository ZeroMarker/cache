//名称（mygrid）
var sjjCode=new Ext.form.TextField({
	width:95,
	//style:{marginLeft:1},
    //height:16,
	id:'sjjCode',
	xtype:'textfield'
});
//描述（mygrid）
var sjjName=new Ext.form.TextField({
	width:95,
	//style:{marginLeft:1},
    //height:16,
	id:'sjjName',
	xtype:'textfield'
});
//类名mygrid）
var className=new Ext.form.TextField({
	width:95,
	//style:{marginLeft:1},
    //height:16,
	id:'className',
	xtype:'textfield'
});
//方法名（mygrid）
var MethodName=new Ext.form.TextField({
	width:95,
	//style:{marginLeft:1},
    //height:16,
	id:'MethodName',
	xtype:'textfield'
});
//类型
var comboboxType=new Ext.form.ComboBox({
	name:'comboboxType',
	id:'comboboxType',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'resutls',
			fields:[{
				'name':'Type',
				'mapping':'Type'
			},{
				'name':'TypeDR',
				'mapping':'TypeDR'
			}]
		}),
		baseParams:{
			className:'Nur.DHCNurEmrInfoMethod',
			methodName:'FindConfigType',
			type:'Query'
		}
	}),
	//tabIndex:'0',
	listWidth:100,
//	height:18,
	width:80,
	xtype : 'combo',
	displayField : 'Type',
	valueField : 'TypeDR',
	hideTrigger : false,
	queryParam : 'typ',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 20,
	typeAhead : false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
})
//数据传递方式
var comboboxworkway=new Ext.form.ComboBox({
	name:'comboboxworkway',
	id:'comboboxworkway',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'resutls',
			fields:[{
				'name':'workway',
				'mapping':'workway'
			},{
				'name':'workwayDR',
				'mapping':'workwayDR'
			}]
		}),
		baseParams:{
			className:'Nur.DHCNurEmrInfoMethod',
			methodName:'FindConfigworkway',
			type:'Query'
		}
	}),
	//tabIndex:'0',
	listWidth:100,
//	height:18,
	width:80,
	xtype : 'combo',
	displayField : 'workway',
	valueField : 'workwayDR',
	hideTrigger : false,
	queryParam : 'typ',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 20,
	typeAhead : false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
})

//名称（mygrid2）
var itmCode=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'itmCode',
	xtype:'textfield'
});
//描述（mygrid2）
var itmName=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'itmName',
	xtype:'textfield'
});
//参数名（mygrid2）
var itmKey=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'itmKey',
	xtype:'textfield'
});
//参数类型（mygrid2）
var itmType=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'itmType',
	xtype:'textfield'
});

//名称（mygrid3）
var desCode=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'desCode',
	xtype:'textfield'
});
//描述（mygrid3）
var desName=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'desName',
	xtype:'textfield'
});
//字段名（mygrid3）
var desKey=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'desKey',
	xtype:'textfield'
});
//字段类型（mygrid3）
var desType=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'desType',
	xtype:'textfield'
});

function BodyLoadHandler() 
{

	var mygrid = Ext.getCmp('mygrid');
	var tobar = mygrid.getTopToolbar();
	
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	
	var but1 = Ext.getCmp("mygridbut2");
	but1.hide();
	tobar.addItem("","名称",sjjCode);
	tobar.addItem("-","描述",sjjName);
	tobar.addItem("-","传输方式",comboboxworkway);
	tobar.addItem("-","类名",className);
	tobar.addItem("-","方法名",MethodName);
	tobar.addItem("-","类型",comboboxType);
	var tbar1=new Ext.Toolbar({});
	tbar1.addButton({
		id:'addbtn',
		text:'增加',
		handler:add,
		icon:'../images/uiimages/edit_remove.png'
	});
	tbar1.addItem('-');
	tbar1.addButton({
		id:'updatebtn',
		text:'修改',
		handler:update,
		icon:'../images/uiimages/edit_remove.png'
	});
	tbar1.addItem('-');
	tbar1.addButton({
		id:'delbtn',
		text:'删除',
		handler:menudelPos,
		icon:'../images/uiimages/edit_remove.png'
	});
	tbar1.addItem('-');
	tbar1.addButton({
		id:'exportbtn',
		text:'导出',
		handler:exportExcelData,
		//icon:'../images/uiimages/edit_remove.png'
	});
	tbar1.addItem('-');
	tbar1.addButton({
		id:'importbtn',
		text:'导入',
		handler:importExcelData,
		//icon:'../images/uiimages/edit_remove.png'
	});
	var bbar=mygrid.getBottomToolbar();
	bbar.hide();
	var bmbar1 = new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bmbar1.render(mygrid.bbar);
	tbar1.render(mygrid.tbar);
	tobar.doLayout();
	
	var mygrid2 = Ext.getCmp('mygrid2');
	var tobar2 = mygrid2.getTopToolbar();
	
	var but2 = Ext.getCmp("mygrid2but1");
	but2.hide();
	
	var but2 = Ext.getCmp("mygrid2but2");
	but2.hide();
	tobar2.addItem("","名称",itmCode);
	tobar2.addItem("-","描述",itmName);
	tobar2.addItem("-","参数名",itmKey);
	tobar2.addItem("-","参数类型",itmType);
	var tbar2=new Ext.Toolbar({});
	tbar2.addButton({
		id:'additmbtn',
		text:'增加',
		handler:additm,
		icon:'../images/uiimages/edit_remove.png'
	});
	tbar2.addItem('-');
	tbar2.addButton({
		id:'updateitmbtn',
		text:'修改',
		handler:updateitm,
		icon:'../images/uiimages/edit_remove.png'
	});
	tbar2.addItem('-');
	tbar2.addButton({
		id:'delitmbtn',
		text:'删除',
		handler:deleteitm,
		icon:'../images/uiimages/edit_remove.png'
	});
	var bbar2=mygrid2.getBottomToolbar();
	bbar2.hide();
	var bmbar2= new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid2.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bmbar2.render(mygrid2.bbar);
	tbar2.render(mygrid2.tbar);
	tobar2.doLayout();
	
	var mygrid3 = Ext.getCmp('mygrid3');
	var tobar3 = mygrid3.getTopToolbar();
	
	var but3= Ext.getCmp("mygrid3but1");
	but3.hide();
	
	var but3 = Ext.getCmp("mygrid3but2");
	but3.hide();
    tobar3.addItem("","名称",desCode);
	tobar3.addItem("-","描述",desName);
	tobar3.addItem("-","字段名",desKey);
	tobar3.addItem("-","字段类型",desType);
	var tbar3=new Ext.Toolbar({});
	tbar3.addButton({
		id:'adddesbtn',
		text:'增加',
		handler:adddes,
		icon:'../images/uiimages/edit_remove.png'
	});
	tbar3.addItem('-');
	tbar3.addButton({
		id:'updatedesbtn',
		text:'修改',
		handler:updatedes,
		icon:'../images/uiimages/edit_remove.png'
	});
	tbar3.addItem('-');
	tbar3.addButton({
		id:'deldesbtn',
		text:'删除',
		handler:deletedes,
		icon:'../images/uiimages/edit_remove.png'
	});
	
	var bbar3=mygrid3.getBottomToolbar();
	bbar3.hide();
	var bmbar3= new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid3.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bmbar3.render(mygrid3.bbar);
	tbar3.render(mygrid3.tbar);
	tobar3.doLayout();
	
	mygrid.on('rowclick',getValsjj);
	mygrid2.on('rowclick',getValcs);
	mygrid3.on('rowclick',getValzd);
	
	findsjj();
}
function getValsjj(){
	var mygrid=Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要修改的行！');
		return;
	}
	var sjjCode=rowObj[0].get('sCode');
	var sjjName=rowObj[0].get('sName');
	var className=rowObj[0].get('ClsName');
	var MethodName=rowObj[0].get('MethName');
	var Type=rowObj[0].get('Type');
	var workway=rowObj[0].get('workway');
	var par=rowObj[0].get('par');
	Ext.getCmp('sjjCode').setValue(sjjCode);
	Ext.getCmp('sjjName').setValue(sjjName);
	Ext.getCmp('className').setValue(className);
	Ext.getCmp('MethodName').setValue(MethodName);
	Ext.getCmp('comboboxType').setValue(Type);
	Ext.getCmp('comboboxworkway').setValue(workway);
	finditm(par);
	finddes(par);
}
//查询（mygrid）
function findsjj(){
	var mygrid = Ext.getCmp("mygrid");
	var parr="";
    mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
    });  
    mygrid.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })
}

//增加（mygrid）
function add(){
	var sjjCode=Ext.getCmp('sjjCode').getValue();
	var sjjName=Ext.getCmp('sjjName').getValue();
	var className=Ext.getCmp('className').getValue();
	var MethodName=Ext.getCmp('MethodName').getValue();
	var comboboxType=Ext.getCmp('comboboxType').getValue();
	var comboboxworkway=Ext.getCmp('comboboxworkway').getValue();
	//alert(comboboxType);
	if (comboboxType=="") 
	{
		alert("类型为空");
		return;
	}
	if (comboboxworkway=="") 
	{
		alert("传输方式为空");
		return;
	}

	var ret=tkMakeServerCall("Nur.DHCNurEmrInfoMethod","save",sjjCode+"^"+sjjName+"^"+className+"^"+MethodName+"^"+comboboxType+"^"+comboboxworkway);
	if(ret==1) alert("添加数据集已存在");
	if(ret==0) alert("添加数据集成功");
    findsjj();
}
//修改（mygrid）
function update(){
	var mygrid = Ext.getCmp("mygrid");
	var objRow=mygrid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条数据集记录!");
		return;
	} else 
	{
		var rowObj=mygrid.getSelectionModel().getSelections();
		var par=rowObj[0].get('par');
		var sjjCode=Ext.getCmp('sjjCode').getValue();
		var sjjName=Ext.getCmp('sjjName').getValue();
		var className=Ext.getCmp('className').getValue();
		var MethodName=Ext.getCmp('MethodName').getValue();
		var comboboxType=Ext.getCmp('comboboxType').getValue();
		var comboboxworkway=Ext.getCmp('comboboxworkway').getValue();
		if (comboboxType=="") 
		{
			alert("类型为空");
			return;
		}
		if (comboboxworkway=="") 
		{
			alert("传输方式为空");
			return;
		}
		var ret=tkMakeServerCall("Nur.DHCNurEmrInfoMethod","update",par+"^"+sjjCode+"^"+sjjName+"^"+className+"^"+MethodName+"^"+comboboxType+"^"+comboboxworkway);
		if(ret==0) alert("修改成功");
		if(ret==1) alert("数据源被引用，拒绝修改");
		findsjj();
	}	
}
//删除（mygrid）
function menudelPos(){
	var mygrid = Ext.getCmp("mygrid");
	var objRow=mygrid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条数据集记录!");
		return;
	} else 
	{
		var flag = confirm("你确定要删除此条记录吗!")
		if (flag) 
		{
			var par=objRow[0].get("par");
			var ret=tkMakeServerCall("Nur.DHCNurEmrInfoMethod","delete",par);
			if (ret==0)
			{
				alert("删除成功");
			}
			if (ret==1)
			{
				alert("数据源被引用，拒绝删除");
			}
		}
	}	
	findsjj();
}

function getValcs(){
	var mygrid2=Ext.getCmp('mygrid2');
	var rowObj=mygrid2.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要修改的行！');
		return;
	}
	var pCode=rowObj[0].get('pCode');
	var pName=rowObj[0].get('pName');
	var ParName=rowObj[0].get('ParName');
	var ParType=rowObj[0].get('ParType');
	Ext.getCmp('itmCode').setValue(pCode);
	Ext.getCmp('itmName').setValue(pName);
	Ext.getCmp('itmKey').setValue(ParName);
	Ext.getCmp('itmType').setValue(ParType);
}
//查询参数列表（mygrid2）
function finditm(par)
{
	var mygrid2 = Ext.getCmp("mygrid2");
	var parr=par;
    mygrid2.store.on("beforeLoad",function(){   
       mygrid2.store.baseParams.parr=par;    //传参数，根据原来的方式修改
    });  
    mygrid2.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })
}
//增加（mygrid2）
function additm(){
	var mygrid = Ext.getCmp("mygrid");
	var objRow=mygrid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条数据集记录!");
		return;
	} else 
	{
		var rowObj=mygrid.getSelectionModel().getSelections();
		var par=rowObj[0].get('par');
		var itmCode=Ext.getCmp('itmCode').getValue();
		var itmName=Ext.getCmp('itmName').getValue();
		var itmKey=Ext.getCmp('itmKey').getValue();
		var itmType=Ext.getCmp('itmType').getValue();
		var ret=tkMakeServerCall("Nur.DHCNurEmrInfoPar","save",par+"^"+itmCode+"^"+itmName+"^"+itmKey+"^"+itmType);
		if(ret==1) alert("添加参数已存在");
		if(ret==0) alert("添加参数成功");
		finditm(par);
	}
}
//修改（mygrid2）
function updateitm(){
	var mygrid2 = Ext.getCmp("mygrid2");
	var objRow=mygrid2.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条参数记录!");
		return;
	} else 
	{
		var rowObj=mygrid2.getSelectionModel().getSelections();
		var par=rowObj[0].get('ppar');
		var rw=rowObj[0].get('prw');
		var itmCode=Ext.getCmp('itmCode').getValue();
		var itmName=Ext.getCmp('itmName').getValue();
		var itmKey=Ext.getCmp('itmKey').getValue();
		var itmType=Ext.getCmp('itmType').getValue();
		var ret=tkMakeServerCall("Nur.DHCNurEmrInfoPar","update",par+"||"+rw+"^"+itmCode+"^"+itmName+"^"+itmKey+"^"+itmType);
		if(ret==0) alert("修改参数成功");
		if(ret==1) alert("数据源被引用，拒绝修改");
		finditm(par);
	}	
}
//删除（mygrid2）
function deleteitm(){
	var mygrid2 = Ext.getCmp("mygrid2");
	var objRow=mygrid2.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条参数记录!");
		return;
	} else 
	{
		var flag = confirm("你确定要删除此条记录吗!")
		if (flag) 
		{
			var par=objRow[0].get("ppar");
			var rw=objRow[0].get("prw");
			var ret=tkMakeServerCall("Nur.DHCNurEmrInfoPar","delete",par+"||"+rw);
			if (ret==0)
			{
				alert("删除参数成功");
			}
			if (ret==1)
			{
				alert("数据源被引用，拒绝删除");
			}
		}
	}	
	finditm(par);
}
function getValzd(){
	var mygrid3=Ext.getCmp('mygrid3');
	var rowObj=mygrid3.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要修改的行！');
		return;
	}
	var rCode=rowObj[0].get('rCode');
	var rName=rowObj[0].get('rName');
	var ReturnName=rowObj[0].get('ReturnName');
	var ReturnType=rowObj[0].get('ReturnType');
	Ext.getCmp('desCode').setValue(rCode);
	Ext.getCmp('desName').setValue(rName);
	Ext.getCmp('desKey').setValue(ReturnName);
	Ext.getCmp('desType').setValue(ReturnType);
}
//查询参数列表（mygrid2）
function finddes(par)
{
	var mygrid3 = Ext.getCmp("mygrid3");
	var parr=par;
    mygrid3.store.on("beforeLoad",function(){   
       mygrid3.store.baseParams.parr=par;    //传参数，根据原来的方式修改
    });  
    mygrid3.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })
}
//增加（mygrid3）
function adddes(){
	var mygrid = Ext.getCmp("mygrid");
	var objRow=mygrid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条数据集记录!");
		return;
	} else 
	{
		var rowObj=mygrid.getSelectionModel().getSelections();
		var par=rowObj[0].get('par');
		var desCode=Ext.getCmp('desCode').getValue();
		var desName=Ext.getCmp('desName').getValue();
		var desKey=Ext.getCmp('desKey').getValue();
		var desType=Ext.getCmp('desType').getValue();
		var ret=tkMakeServerCall("Nur.DHCNurEmrInfoReturn","save",par+"^"+desCode+"^"+desName+"^"+desKey+"^"+desType);
		if(ret==1) alert("添加字段已存在");
		if(ret==0) alert("添加字段成功");
		finddes(par);
	}
}

//修改（mygrid3）
function updatedes(){
	var mygrid3 = Ext.getCmp("mygrid3");
	var objRow=mygrid3.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条字段记录!");
		return;
	} else 
	{
		var rowObj=mygrid3.getSelectionModel().getSelections();
		var par=rowObj[0].get('rpar');
		var rw=rowObj[0].get('rrw');
		var desCode=Ext.getCmp('desCode').getValue();
		var desName=Ext.getCmp('desName').getValue();
		var desKey=Ext.getCmp('desKey').getValue();
		var desType=Ext.getCmp('desType').getValue();
		var ret=tkMakeServerCall("Nur.DHCNurEmrInfoReturn","update",par+"||"+rw+"^"+desCode+"^"+desName+"^"+desKey+"^"+desType);
		if(ret==0) alert("修改字段成功");
		if(ret==1) alert("数据源被引用，拒绝修改");
		finddes(par);
	}	
}
//删除（mygrid3）
function deletedes(){
	var mygrid3 = Ext.getCmp("mygrid3");
	var objRow=mygrid3.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条字段记录!");
		return;
	} else 
	{
		var flag = confirm("你确定要删除此条记录吗!")
		if (flag) 
		{
			var par=objRow[0].get("rpar");
			var rw=objRow[0].get("rrw");
			var ret=tkMakeServerCall("Nur.DHCNurEmrInfoReturn","delete",par+"||"+rw);
			if (ret==0)
			{
				alert("删除字段成功");
			}
			if (ret==1)
			{
				alert("数据源被引用，拒绝删除");
			}
		}
	}	
	finddes(par);
}
function exportExcelData()
{
	var grid=Ext.getCmp('mygrid');
	var xls = new ActiveXObject ("Excel.Application");
	
	xls.visible =true;  //设置excel为可见
	var xlBook = xls.Workbooks.Add;
	var xlSheet = xlBook.Worksheets(1);
	
 	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var temp_obj = [];
	
	//只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示) 
	//临时数组,存放所有当前显示列的下标 
	 for(i=0;i <colCount;i++){ 
		if(cm.isHidden(i) == true){ 
		}else{
			temp_obj.push(i);
		}
	}
	for(i=1;i <=temp_obj.length;i++){
		//显示列的列标题
		//if(cm.getColumnHeader(temp_obj[i-1])=='par') continue;
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i-1]);
		xlSheet.Cells(1,i).Font.Bold = true;//加粗
	}
	
	xlSheet.Cells(1,1).Value ="数据集名称";
	xlSheet.Cells(1,2).Value ="数据集描述";
	xlSheet.Cells(1,3).Value ="数据集传输方式";
	xlSheet.Cells(1,4).Value ="数据集类名";
	xlSheet.Cells(1,5).Value ="数据集方法名";
	xlSheet.Cells(1,6).Value ="数据集类型";
	xlSheet.Cells(1,7).Value ="数据集关联号";
	xlSheet.Cells(1,8).Value ="参数名称";
	xlSheet.Cells(1,9).Value ="参数描述";
	xlSheet.Cells(1,10).Value ="参数Code";
	xlSheet.Cells(1,11).Value ="参数类型";
	xlSheet.Cells(1,12).Value ="参数关联号";
	xlSheet.Cells(1,13).Value ="字段名称";
	xlSheet.Cells(1,14).Value ="字段描述";
	xlSheet.Cells(1,15).Value ="字段Code";
	xlSheet.Cells(1,16).Value ="字段类型";
	xlSheet.Cells(1,17).Value ="字段关联号";
	
	var store = grid.getStore();
	var recordCount = store.getCount();
	
	arrgrid = new Array();
	var tmpStore=new Ext.data.JsonStore({
		fields:['sCode','sName','workway','ClsName','MethName','Type','LinkCode','pCode','pName','ParName','ParType','ParLinkCode','rCode','rName','ReturnName','ReturnType','ReturnLinkCode'],
		data:[],
		idIndex: 0
	});
	var parr=store.lastOptions.params.parr;
	var GetQueryData=document.getElementById('GetQueryData');
	var a=cspRunServerMethod(GetQueryData.value,"Nur.DHCNurEmrInfoMethod:getAllExport","parr$"+parr,"AddRec");
	tmpStore.loadData(arrgrid);
	var storeLen=tmpStore.getCount();
	
	for(i=1;i<=storeLen;i++){
		for(j=0;j<=tmpStore.fields.length-1;j++){
			xlSheet.Cells(i+1,j+1).value="'"+tmpStore.getAt(i-1).get(tmpStore.fields.items[j].name)
		}
	}
	xlSheet.Columns.AutoFit;
	xls.ActiveWindow.Zoom = 1000;
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
  xls=null;
  xlBook=null; 
  xlSheet=null;
}
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function exportExcelData2()
{
	var grid=Ext.getCmp('mygrid2');
	var xls = new ActiveXObject ("Excel.Application");
	
	xls.visible =true;  //设置excel为可见
	var xlBook = xls.Workbooks.Add;
	var xlSheet = xlBook.Worksheets(1);
	
 	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var temp_obj = [];
	
	//只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示) 
	//临时数组,存放所有当前显示列的下标 
	 for(i=0;i <colCount;i++){ 
		if(cm.isHidden(i) == true){ 
		}else{
			temp_obj.push(i);
		}
	}
	for(i=1;i <=temp_obj.length;i++){
		//显示列的列标题
		//if(cm.getColumnHeader(temp_obj[i-1])=='par') continue;
		//if(cm.getColumnHeader(temp_obj[i-1])=='rw') continue;
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i-1]);
		xlSheet.Cells(1,i).Font.Bold = true;//加粗
	}
	var store = grid.getStore();
	var recordCount = store.getCount();
	
	arrgrid = new Array();
	var tmpStore=new Ext.data.JsonStore({
		fields:['pCode','pName','ParName','ParType','ppar','prw'],
		data:[],
		idIndex: 0
	});
	var parr="";
	
	var GetQueryData=document.getElementById('GetQueryData');
	var a=cspRunServerMethod(GetQueryData.value,"Nur.DHCNurEmrInfoPar:getAllVal","parr$"+parr,"AddRec");
	tmpStore.loadData(arrgrid);
	var storeLen=tmpStore.getCount();
	for(i=1;i<=storeLen;i++){
		for(j=0;j<=tmpStore.fields.length-1;j++){
			xlSheet.Cells(i+1,j+1).value="'"+tmpStore.getAt(i-1).get(tmpStore.fields.items[j].name)
		}
	}
	xlSheet.Columns.AutoFit;
	xls.ActiveWindow.Zoom = 100;
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
  xls=null;
  xlBook=null; 
  xlSheet=null;
}
function exportExcelData3()
{
	var grid=Ext.getCmp('mygrid3');
	var xls = new ActiveXObject ("Excel.Application");
	
	xls.visible =true;  //设置excel为可见
	var xlBook = xls.Workbooks.Add;
	var xlSheet = xlBook.Worksheets(1);
	
 	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var temp_obj = [];
	
	//只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示) 
	//临时数组,存放所有当前显示列的下标 
	 for(i=0;i <colCount;i++){ 
		if(cm.isHidden(i) == true){ 
		}else{
			temp_obj.push(i);
		}
	}
	for(i=1;i <=temp_obj.length;i++){
		//显示列的列标题
		//if(cm.getColumnHeader(temp_obj[i-1])=='par') continue;
		//if(cm.getColumnHeader(temp_obj[i-1])=='rw') continue;
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i-1]);
		xlSheet.Cells(1,i).Font.Bold = true;//加粗
	}
	var store = grid.getStore();
	var recordCount = store.getCount();
	
	arrgrid = new Array();
	var tmpStore=new Ext.data.JsonStore({
		fields:['rCode','rName','ReturnName','ReturnType','rpar','rrw'],
		data:[],
		idIndex: 0
	});
	var parr="";
	
	var GetQueryData=document.getElementById('GetQueryData');
	var a=cspRunServerMethod(GetQueryData.value,"Nur.DHCNurEmrInfoReturn:getAllVal","parr$"+parr,"AddRec");
	tmpStore.loadData(arrgrid);
	var storeLen=tmpStore.getCount();
	for(i=1;i<=storeLen;i++){
		for(j=0;j<=tmpStore.fields.length-1;j++){
			xlSheet.Cells(i+1,j+1).value="'"+tmpStore.getAt(i-1).get(tmpStore.fields.items[j].name)
		}
	}
	xlSheet.Columns.AutoFit;
	xls.ActiveWindow.Zoom = 100;
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
  xls=null;
  xlBook=null; 
  xlSheet=null;
}
function importExcelData()
{


	var fpFileUpload=new Ext.FormPanel({  
   id:'fpFileUpload',  
   frame:true,  
   fileUpload:true,
   items:[{
     xtype:'textfield',  
     allowBlank:false,  
     fieldLabel:'选择文件', 
     inputType:'file',  
     name:'fileName',
		 id:'fileName'
   }],  
   buttonAlign:'center',  
   buttons:[{  
     text:'上传', 
     icon:'../images/uiimages/moveup.png',	 
     handler:function(){
			var filePath=Ext.getCmp("fileName").getValue();
			var RealFilePath=""
			RealFilePath = filePath.replace(/\\/g, "\\\\");
			if(RealFilePath!=""){
				
				ReadExcel(RealFilePath);
				Ext.Msg.alert('提示',"导入完成！");
				winFielUpload.close();
				
			}else{
				Ext.Msg.alert('提示',"请选择文件！");
				return;
			}
		 }  
   },{  
     text:'取消',
     icon:'../images/uiimages/cancel.png',	 
     handler:function(){  
     	winFielUpload.close();  
		 } 
	 }]
	});
	var winFielUpload=new Ext.Window({
		id:'win',  
  	title:'文件上传',  
  	width:350,  
  	height:100,  
  	layout:'fit',  
  	autoDestory:true,  
  	modal:true,  
  	//closeAction:'hide',  
  	items:[fpFileUpload]  
 	});
 	winFielUpload.show(); 
}
function ReadExcel(RealFilePath)
{
	try{
    var filePath= RealFilePath    //"E:\\book.xls"//document.all.upfile.value;
    var oXL = new ActiveXObject("Excel.application"); 
    var oWB = oXL.Workbooks.open(filePath);
    oWB.worksheets(1).select(); 
    var oSheet = oWB.ActiveSheet;
	var par="";
    for(var i=2;i<1000;i++)
    {
		
		if((oSheet.Cells(i,1).value!="null")&&(oSheet.Cells(i,1).value !=undefined)&&(oSheet.Cells(i,1).value !="")) 
		{
			
			var sjjmc=oSheet.Cells(i,1).value;
			var sjjms=oSheet.Cells(i,2).value;
			var sjjcsfs=oSheet.Cells(i,3).value;
			var sjjlm=oSheet.Cells(i,4).value;
			var sjjffm=oSheet.Cells(i,5).value;
			var sjjlx=oSheet.Cells(i,6).value;
			var sjjlinkcode=oSheet.Cells(i,7).value;
			var par=importsjj(sjjmc,sjjms,sjjlm,sjjffm,sjjlx,sjjcsfs,sjjlinkcode);
			
		}
		if((oSheet.Cells(i,8).value!="null")&&(oSheet.Cells(i,8).value !=undefined)&&(oSheet.Cells(i,8).value !="")&&(par!="")) 
		{
			var csmc=oSheet.Cells(i,8).value;
			var csms=oSheet.Cells(i,9).value;
			var csm=oSheet.Cells(i,10).value;
			var cslx=oSheet.Cells(i,11).value;
			var cslinkcode=oSheet.Cells(i,12).value;
			var rw1=importcs(csmc,csms,csm,cslx,cslinkcode,par);
		}
		
		if((oSheet.Cells(i,13).value!="null")&&(oSheet.Cells(i,13).value !=undefined)&&(oSheet.Cells(i,13).value !="")&&(par!="")) 
		{
			var zdmc=oSheet.Cells(i,13).value;
			var zdms=oSheet.Cells(i,14).value;
			var zdm=oSheet.Cells(i,15).value;
			var zdlx=oSheet.Cells(i,16).value;
			var zdlinkcode=oSheet.Cells(i,17).value;
			var rw2=importzd(zdmc,zdms,zdm,zdlx,zdlinkcode,par);
		}
		
      }
	}catch(e){
		alert(e.message)
	}

   oXL.Quit();
   findsjj();
}
function importsjj(sjjmc,sjjms,sjjlm,sjjffm,sjjlx,sjjcsfs,sjjlinkcode)
{
	var ret=tkMakeServerCall("Nur.DHCNurEmrInfoMethod","import",sjjmc+"^"+sjjms+"^"+sjjlm+"^"+sjjffm+"^"+sjjlx+"^"+sjjcsfs+"^"+sjjlinkcode);
	if(ret==1)
	{
		alert(sjjmc+"^"+sjjms+"^"+sjjlm+"^"+sjjffm+"^"+sjjlx+"^"+sjjlinkcode+"数据集已存在");
		return "";
	}
	else
	{
		var ID=tkMakeServerCall("Nur.DHCNurEmrInfoMethod","getIdByCode",sjjmc)
		return ID;
	}
}
function importcs(csmc,csms,csm,cslx,cslinkcode,par)
{
	var ret=tkMakeServerCall("Nur.DHCNurEmrInfoPar","import",par+"^"+csmc+"^"+csms+"^"+csm+"^"+cslx+"^"+cslinkcode);
	return ret;
}
function importzd(zdmc,zdms,zdm,zdlx,zdlinkcode,par)
{
	var ret=tkMakeServerCall("Nur.DHCNurEmrInfoReturn","import",par+"^"+zdmc+"^"+zdms+"^"+zdm+"^"+zdlx+"^"+zdlinkcode);
	return ret;
}