//名称（mygrid）
var ruleCode=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'ruleCode',
	xtype:'textfield'
});
//描述（mygrid）
var ruleName=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'ruleName',
	xtype:'textfield'
});
//类名mygrid）
var className=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'className',
	xtype:'textfield'
});
//方法名（mygrid）
var MethodName=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'MethodName',
	xtype:'textfield'
});
var par="";
locdata3 = new Array();
function addloc3(a, b) {
	
	locdata3.push({
				id : a,
				desc : b
			});
}
var window=""
locdata = new Array();
function addloc(a, b) {
	
	locdata.push({
				id : a,
				desc : b
			});
}
	var store1=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo1={
		name:'只允许本人修改项维护',
		id:'BindEle',
		tabIndex:'0',
		x:84,
		y:320,
		height:21,
		width:252,
		xtype:'combo',
		editable:false,
		store:store1,
		displayField:'desc',
		valueField:'id',
		allowBlank: true,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                    }
                });
                //alert(str)
                this.setValue(str.join());
                this.value=strvalue.join();
                this.valueId= strvalue.join();
              							
                 //this.collapse();
                this.fireEvent('select', this, record, index);
                //findperson (record.get('id'),record,index);
                //if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
                //{
                 	//clearperson('RequestConDoc');
                //}
             }
        },
		value:'',
		valueId:''
	};
function BodyLoadHandler(){
	setsize("mygridpl", "gform", "mygrid");
	var mygrid = Ext.getCmp('mygrid');
	var tobar = mygrid.getTopToolbar();
	
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	
	var but1 = Ext.getCmp("mygridbut2");
	but1.hide();
	//tobar.addItem("","名称",ruleCode);
	//tobar.addItem("-","描述",ruleName);
	//tobar.addItem("-","类名",className);
	//tobar.addItem("-","方法名",MethodName);
	var tobar=new Ext.Toolbar({});
	tobar.addButton({
		id:'addbtn',
		text:'增加',
		handler:function(){add();},
		icon:'../images/uiimages/edit_remove.png'
	});
	tobar.addItem('-');
	tobar.addButton({
		id:'updatebtn',
		text:'修改',
		handler:update,
		icon:'../images/uiimages/edit_remove.png'
	});
	tobar.addItem('-');
	tobar.addButton({
		id:'delbtn',
		text:'删除',
		handler:menudelPos,
		icon:'../images/uiimages/edit_remove.png'
	});
	tobar.addItem('-');
	tobar.addButton({
		id:'exportbtn',
		text:'导出',
		handler:exportExcelData,
		//icon:'../images/uiimages/edit_remove.png'
	});
	tobar.addItem('-');
	tobar.addButton({
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
	tobar.render(mygrid.tbar);
	tobar.doLayout();
	mygrid.on('rowclick',getVal);
	find();
}
function getVal(){
	var mygrid=Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要修改的行！');
		return;
	}
	var ruleCode=rowObj[0].get('ruleCode');
	var ruleName=rowObj[0].get('ruleName');
	var className=rowObj[0].get('ClsName');
	var MethodName=rowObj[0].get('MethName');
	var ruleMode=rowObj[0].get('ruleMode');
	var par=rowObj[0].get('par');
	Ext.getCmp('ruleCode').setValue(ruleCode);
	Ext.getCmp('ruleName').setValue(ruleName);
	Ext.getCmp('className').setValue(className);
	Ext.getCmp('MethodName').setValue(MethodName);
	Ext.getCmp('ruleMode').setValue(ruleMode);

}
//增加（mygrid）
function add1()
{
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURPGD_BIND&EpisodeID="+EpisodeID+"&NurRecId="+NurRecId;//"&DtId="+DtId+"&ExamId="+ExamId
    window.open(lnk,"htm",'left=10,toolbar=no,location=no,directories=no,resizable=yes,width=450,height=260');
	
}
var window=""

function add()
{	 
	myId = "";
	par="";
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURPGD_BIND", "315", "");   
	arr = eval(a);
	for(var i = 0;i<arr.length;i++)
	{
		
		if(arr[i].name=='BindEle')
		{
			combo1.x=arr[i].x
			combo1.y=arr[i].y
			combo1.width=arr[i].width
			arr[i]=combo1;
			
		}	
	}
	var window = new Ext.Window({
			title: '',
			x:84,
		    y:320,
			width: 700,
			height: 300,
			autoScroll: true,
			layout: 'absolute',
			// plain: true,
			// modal: true,
			// bodyStyle: 'padding:5px;',
			// /buttonAlign: 'center',
			items: arr,
			buttons: [{
				id:'modSave',
				text: '保存',
				icon:'../images/uiimages/filesave.png',
				handler: function() {
					Save(window);
					window.close();
				}
			}, {
				text: '取消',
				icon:'../images/uiimages/cancel.png',
				handler: function() {
					window.close();
				}
			}]
		});
		setvalue();

window.show();	
}

function setvalue()
{
	var OnBind=Ext.getCmp("OnBind");
	OnBind.hide();
		var BindEle = Ext.getCmp("BindEle");
	    var getitms = document.getElementById('getitms');
	    cspRunServerMethod(getitms.value,NurRecId,"addloc3");
	    BindEle.store.loadData(locdata3);	
		//alert(par);
		if(par!="")
		{
			//alert(par);
			var ret=tkMakeServerCall("NurMp.DHCNurEmrBind","getBindInfoByID",par);
			var a=ret.split("^");
			//alert(ret);
			var Num=Ext.getCmp("Num");
			Num.setValue(a[0]);
			var BindName=Ext.getCmp("BindName");
			BindName.setValue(a[1]);
			var BindEle=Ext.getCmp("BindEle");
			BindEle.setValue(a[2]);
			var type=Ext.getCmp("type");
			type.setValue(a[3]);
			var ruleMode=Ext.getCmp("ruleMode");
			ruleMode.setValue(a[4]);
			
			var ClassName=Ext.getCmp("ClassName");
			ClassName.setValue(a[5]);
			var MethodName=Ext.getCmp("MethodName");
			MethodName.setValue(a[6]);
			
		
		}	
		

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

	par=objRow[0].get("par");
	//alert(par);
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURPGD_BIND", "315", "");   
	arr = eval(a);
	for(var i = 0;i<arr.length;i++)
	{
		
		if(arr[i].name=='BindEle')
		{
			combo1.x=arr[i].x
			combo1.y=arr[i].y
			combo1.width=arr[i].width
			arr[i]=combo1;
			
		}	
	}
		var window = new Ext.Window({
			title: '',
			x:84,
		    y:320,
			width: 800,
			height: 300,
			autoScroll: true,
			layout: 'absolute',
			// plain: true,
			// modal: true,
			// bodyStyle: 'padding:5px;',
			// /buttonAlign: 'center',
			items: arr,
			buttons: [{
				id:'modSave',
				text: '保存',
				icon:'../images/uiimages/filesave.png',
				handler: function() {
					Save(window);
					//window.close();
				}
			}, {
				text: '取消',
				icon:'../images/uiimages/cancel.png',
				handler: function() {
					window.close();
				}
			}]
		});
		setvalue();

		window.show();	
	}	
}
function update1(){
	
	var mygrid = Ext.getCmp("mygrid");
	var objRow=mygrid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条数据集记录!");
		return;
	} else 
	{
	var par=objRow[0].get("par");
    var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURPGD_BIND&EpisodeID="+EpisodeID+"&NurRecId="+NurRecId+"&AnaesID="+par;//"&DtId="+DtId+"&ExamId="+ExamId
    window.open(lnk,"htm",'left=10,toolbar=no,location=no,directories=no,resizable=yes,width=450,height=260');
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
			var ret=tkMakeServerCall("NurMp.DHCNurEmrBind","delete",par);
			alert("删除成功");
		}
	}	
	find();
}
//查询（mygrid）
function find(){
	var mygrid = Ext.getCmp("mygrid");
	var parr=NurRecId;
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

function Save()
{
	
	var Num=Ext.getCmp("Num");
	var BindName=Ext.getCmp("BindName");
	var BindEle=Ext.getCmp("BindEle");
	var type=Ext.getCmp("type");
	var ruleMode=Ext.getCmp("ruleMode");
	var ClassName=Ext.getCmp("ClassName");
	var MethodName=Ext.getCmp("MethodName");
	if(Num.value=="")
	{
		alert("请选择第几次！");
		return;
	}
	if(BindName.getValue()=="")
	{
		alert("请维护名称！");
		return;
	}
	if(BindEle.value=="")
	{
		alert("请选择绑定模板元素！");
		return;
	}
	if(ruleMode.value=="")
	{
		alert("请选择传输方式！");
		return;
	}

	if((ClassName.getValue()!="")&&(MethodName.getValue()=="")){
		alert("请填写方法名！");
		return;
	}
	if((ClassName.getValue()=="")&&(MethodName.getValue()!="")){
		alert("请填写类名！");
		return;
	}
	if(par!=""){
		var ret=tkMakeServerCall("NurMp.DHCNurEmrBind","save",Num.value+"^"+BindName.getValue()+"^"+BindEle.value+"^"+NurRecId+"^"+type.value+"^"+ruleMode.value+"^"+ClassName.getValue()+"^"+MethodName.getValue(),par);
	}
	else{
		var ret=tkMakeServerCall("NurMp.DHCNurEmrBind","save",Num.value+"^"+BindName.getValue()+"^"+BindEle.value+"^"+NurRecId+"^"+type.value+"^"+ruleMode.value+"^"+ClassName.getValue()+"^"+MethodName.getValue(),"");
	}
	if (ret!=0)
	{
		alert("保存成功")
		window.close();
		
	}

	find();
	return;
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
	/*
	for(i=1;i <=temp_obj.length;i++){
		//显示列的列标题
		//if(cm.getColumnHeader(temp_obj[i-1])=='par') continue;
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i-1]);
		xlSheet.Cells(1,i).Font.Bold = true;//加粗
	}*/
	xlSheet.Cells(1,1).Value = "元素";
	xlSheet.Cells(1,2).Value = "单据名称";
	xlSheet.Cells(1,3).Value = "单据Code";
	xlSheet.Cells(1,4).Value = "频次";
	xlSheet.Cells(1,5).Value = "类型";
	xlSheet.Cells(1,6).Value = "传输方式";
	xlSheet.Cells(1,7).Value = "类名";
	xlSheet.Cells(1,8).Value = "方法名";
	
	
	var store = grid.getStore();
	var recordCount = store.getCount();
	
	arrgrid = new Array();
	var tmpStore=new Ext.data.JsonStore({
		fields:['BindEle', 'BindName', 'Code', 'Num', 'Type', 'ruleMode','ClassName','MethodName'],
		data:[],
		idIndex: 0
	});
	var parr=store.lastOptions.params.parr;
	var GetQueryData=document.getElementById('GetQueryData');
	var a=cspRunServerMethod(GetQueryData.value,"NurMp.DHCNurEmrBind:getAllExport","parr$"+parr,"AddRec");
	
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
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
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
	x:300,
    y:300,
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
    for(var i=2;i<100;i++)
    {
		
		if((oSheet.Cells(i,1).value!="null")&&(oSheet.Cells(i,1).value !=undefined)) 
		{
			//'BindEle', 'BindName', 'Code', 'Num', 'Type'],//, 'ruleMode'
			var BindEle=oSheet.Cells(i,1).value;
			var BindName=oSheet.Cells(i,2).value;
			var Code=oSheet.Cells(i,3).value;
			var Num=oSheet.Cells(i,4).value;
			var Type=oSheet.Cells(i,5).value;
			var ruleMode=oSheet.Cells(i,6).value;
			var ClassName=oSheet.Cells(i,7).value;
			var MethodName=oSheet.Cells(i,8).value;
			var par=importBind(BindEle,BindName,Code,Num,Type,ruleMode,ClassName,MethodName);
		}
      }
	}catch(e){
		alert(e.message)
	}
	alert("导入成功");
   oXL.Quit();
   findsjj();
}
function importBind(BindEle,BindName,Code,Num,Type,ruleMode)
{
	var ret=tkMakeServerCall("NurMp.DHCNurEmrBind","saveimport",Num+"^"+BindName+"^"+BindEle+"^"+Code+"^"+Type+"^"+ruleMode+"^"+ClassName+"^"+MethodName);
	if(ret==1)
	{
		alert(Num+"^"+BindName+"^"+BindEle+"^"+Code+"^"+Type+"数据集已存在");
		return "";
	}
	if(ret==2)
	{
		alert(Num+"^"+BindName+"^"+BindEle+"^"+Code+"^"+Type+"找不到对应的模板记录");
		return "";
	}
}