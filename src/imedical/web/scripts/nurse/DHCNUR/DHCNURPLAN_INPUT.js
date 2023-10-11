Ext.onReady(function() {
	InitializeForm()
	InitializeValue()
});
var easewidth=350;
var grid
function InitializeForm()
{
	var patientTree = CreateTree("patientTree");
	var anchorPanel = new Ext.FormPanel({
		// layout : 'anchor',
		items: [{
			xtype: 'fieldset',
			labelWidth: 55,
			collapsible: true,
			title: '护理问题',
			id: 'FsPats',
			containerScroll: true,
			collapsible: true,
			autoScroll: true,
			frame: true,
			items: [patientTree]
		}]
	})
	var yqmbTree = CreateTreeXG();
	var caseTree = CreateTreeMS();
	var anchorMBPanel = new Ext.FormPanel({
		// layout : 'anchor',
		items: [{
			xtype: 'fieldset',
			labelWidth: 55,
			collapsible: true,
			title: '预期目标',
			id: 'yqmb',
			containerScroll: true,
			collapsible: true,
			autoScroll: true,
			frame: true,
			items: [yqmbTree]
		},{
			xtype:'fieldset',
			title:'其他预期目标',
			collapsible: true,
			id:'qtmb',
			items: [{
				layout: 'table',
				layoutConfig: {
					columns: 2
				},
				items: [ {
					xtype: 'textarea',
					id: 'qtyqmb',
					height:30,
					width: easewidth-30
					
			}]}]
			
		},{
			xtype: 'fieldset',
			labelWidth: 55,
			collapsible: true,
			title: '护理措施',
			id: 'casemeasure',
			containerScroll: true,
			collapsible: true,
			autoScroll: true,
			frame: true,
			items: [caseTree]
		},{
			xtype:'fieldset',
			title:'其他护理措施',
			collapsible: true,
			autoScroll: true,
			id:'qtcase22',
			items: [{
				layout: 'table',
				layoutConfig: {
					columns: 2
				},
				items: [ {
					xtype: 'textarea',
					id: 'qtcase',
					height:50,
					width: easewidth-30
					
			}]}]
			
		}]
	})
     var DHCNURBG_ZSKJYJGLBT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'CareDate','mapping':'CareDate'},{'name':'CareTime','mapping':'CareTime'},{'name':'NurDiagnos','mapping':'NurDiagnos'},{'name':'RecNoc','mapping':'RecNoc'},{'name':'RecNic','mapping':'RecNic'},{'name':'User','mapping':'User'},{'name':'ResultDate','mapping':'ResultDate'},{'name':'ResultTime','mapping':'ResultTime'},{'name':'Result','mapping':'Result'},{'name':'ResultUser','mapping':'ResultUser'},{'name':'par','mapping':'par'},{'name':'rw','mapping':'rw'}]}),baseParams:{className:'Nur.NurRecPlan',methodName:'GetCareRecComm',type:'RecQuery'}});
	 var LisOrdgrid=new Ext.grid.EditorGridPanel({id:'nurseplan',name:'LisGridList',title:'护理计划',loadMask:true,clicksToEdit: 1, stripeRows: true,height:800,width:1000,
	 tbar:[{id:'LisGridListbut1',text:'新增',icon:'../Image/icons/add.png'},
	 {id:'LisGridListbut2',text:'修改',icon:'../Image/icons/database_save.png'},
	 {id:'LisGridListbut3',text:'删除',icon:'../Image/icons/cancel.png'}
	 ],
	 store:DHCNURBG_ZSKJYJGLBT101,
	 colModel: new Ext.grid.ColumnModel({columns:[{header:'日期',dataIndex:'CareDate',width:80,renderer:function(value){if(value instanceof Date){ return new Date(value).format("Y-m-d");}else{ return value}}, editor:new Ext.form.DateField({id:'D123',format: 'Y-m-d'})},
	 {header:'时间',dataIndex:'CareTime',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TimeField({format: 'H:i'}))},
	 {header:'护理问题',dataIndex:'NurDiagnos',width:100,editor:new Ext.grid.GridEditor(new Ext.form.TextArea({readOnly:true}))},
	 {header:'预期目标',dataIndex:'RecNoc',width:200,editor: new Ext.grid.GridEditor(new Ext.form.TextArea({readOnly:true}))},
	 {header:'护理措施',dataIndex:'RecNic',width:250,editor: new Ext.grid.GridEditor(new Ext.form.TextArea({readOnly:false,grow:true}))},
	 {header:'签名',dataIndex:'User',width:60,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
	 {header:'日期',dataIndex:'ResultDate',width:81,renderer:function(value){if(value instanceof Date){ return new Date(value).format("Y-m-d");}else{ return value}}, editor:new Ext.form.DateField({id:'D149',format: 'Y-m-d'})},
	 {header:'时间',dataIndex:'ResultTime',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TimeField({format: 'H:i'}))},
	 {header:'结果评价',dataIndex:'Result',width:89,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id', valueField:'desc',triggerAction:'all',store:new Ext.data.JsonStore({data : [{desc:'1解决',id:'1解决'},{desc:'2未解决',id:'2未解决'},{desc:'3更新',id:'3更新'}],fields: ['desc', 'id']}),mode:'local'}))},
	 {header:'签名',dataIndex:'ResultUser',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
	 {header:'par',dataIndex:'par',width:5,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
	 {header:'rw',dataIndex:'rw',width:5,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))}],
	 rows:[[{},{},{},{},{},{},{header:'护理结果评价',colspan:4,align:'center'},{},{}]],defaultSortable:false}),
	 enableColumnMove: false,viewConfig:{forceFit:false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],
	 sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),
	 bbar: new Ext.PagingToolbar({store:DHCNURBG_ZSKJYJGLBT101,displayInfo:true,pageSize:20,displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',emptyMsg:"没有记录"})});
  	 var tobar=LisOrdgrid.getTopToolbar();
	 var but1=Ext.getCmp("LisGridListbut1");
	 but1.on('click',additm);
	 var but1=Ext.getCmp("LisGridListbut2");
	 but1.on('click',saveone);
	 var but1=Ext.getCmp("LisGridListbut3");
	 but1.on('click',CancelRecord);
	 
	 tobar.addItem(
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:'mygridstdate',
			value:(diffDate(new Date(),-30))
		},
	    {
			xtype:'timefield',
			width:50,
			format: 'H:i',
			value:'0:00',
			id:'mygridsttime'
		},
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:'mygridenddate',
			value:diffDate(new Date(),1)
		},
	    {
			xtype:'timefield',
			width:50,
			id:'mygridendtime',
			format: 'H:i',
			value:'0:00'
		}
	);
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		handler:find,
		icon:'../Image/icons/find.png',
		id:'mygridSch'
	  });
	  	tobar.addItem ("-",{
			xtype:'checkbox',
			id:'IfCancelRec',
			checked:false,
			boxLabel:'显示作废记录' 		
	   });
	    tobar.addButton(
		{
			  text: "打印全部",
			  handler:printNurRec,
			  icon:'../Image/icons/printer.png',
			  id:'PrintButZK2'
		});
		
	   
	   tobar.doLayout();
	   
	   grid=Ext.getCmp('nurseplan');
	   grid.setTitle(gethead());
	   grid.on('beforeedit', beforeEditFn);
	   grid.on('afteredit',aftereditFn);
	   
	  //LisOrdgrid.getBottomToolbar().hide();
	  //LisOrdgrid.getTopToolbar().hide();
	  //LisOrdgrid.title="";
	  //LisOrdgrid.hideHeaders="true";  //隐藏表头 
   var formpanel=new Ext.form.FormPanel({
      height:600,
      width: 800,
      id:'gform',
      autoScroll:true,
      layout: 'absolute',
      items:[LisOrdgrid]
    });
	var fwidth=window.screen.availWidth-10
	var viewPort = new Ext.Viewport({
		layout: 'border',
		id: "viewPort",
		defaults: {
			border: true,
			frame: true,
			bodyBorder: true
		},
		items: [{
			region: 'west',
			width: 240,
			minWidth: 140,
			split: true,
			items: anchorPanel,
			collapsible: true
		}, {
			region: 'center',
			layout: 'fit',
			width:300,
			height:300,
			title: "护理计划",
			items: LisOrdgrid
	    },{
			region:'east',
		    width: easewidth,
			minWidth: 140,
			split: true,
			items: anchorMBPanel,
			collapsible: true
	    },{
			region:'south',
			height:200,
			split: true,
			items: [{xtype:'textarea',
			         id:'textsm',
					 height:150,
					 width:fwidth
			        }],
			collapsible: true
	    }]
	});
	Ext.QuickTips.init();
	find()
	
}
//作废
function CancelRecord()
{

	var grid=Ext.getCmp('nurseplan');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条记录!");
		return;
	} else 
	{
		var flag = confirm("你确定要作废此条记录吗!")
		if (flag) 
		{
			var par=objRow[0].get("par");
			var rw=objRow[0].get("rw");
			tkMakeServerCall("Nur.NurRecPlanSub","CancelRecord",par,rw,session['LOGON.USERID'],session['LOGON.GROUPDESC'])
		    find()
		}
	}
}
function gethead()
{
	
	var ret=tkMakeServerCall("web.DHCNurseRecordPrint","GetHead",EpisodeID)	
	var hh=ret.split("^");
	return hh[0]+"  "+hh[1]  //+" ----注意:根据护理部要求，只能修改本人签名的记录！";
}
function beforeEditFn(e){
	grid.rowIndex = e.row;   //得到当前的行
	grid.columnIndex = e.column;	//得到当前的列
}
function aftereditFn()
{
	if (grid.columnIndex==8)
	{
		        var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
	        	var result=grid.store.getAt(rowIndex).data["Result"]
				var rw=grid.store.getAt(rowIndex).data["rw"]
				var par=grid.store.getAt(rowIndex).data["par"]
				var id=par+"||"+rw
				var dd=diffDate(new Date(),0)
				var tt=new Date().dateFormat('H:i')
				tkMakeServerCall("Nur.NurRecPlanSub","SaveResult",id,dd,tt,result,session['LOGON.USERID'])
				find()
				
	           
	}
}
function saveone()
{
	var grid1=Ext.getCmp('nurseplan');
	var grid=Ext.getCmp('nurseplan');
	
    var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
    var len = rowObj.length;		
	for (var r = 0;r < len; r++) {
		list.push(rowObj[r].data);
	}		
	var recpar="" //图片
	var recrw=""  //图片
	
	for (var i = 0; i < list.length; i++) {
	  var obj=list[i];
	  var str="";
	  var CareDate="";
	  var CareTime="";
	  var flag="0";
      var isModifiedflag=""
		for (var p in obj) {
	        	var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
	        	if (store.getAt(rowIndex).isModified(p))
	            {
	      	      isModifiedflag="Y";
	            }	        
			var aa = formatDate(obj[p]);
            //alert(aa)			
			if (p=="CareDate") CareDate=aa;
			if (p=='CareTime') CareTime=obj[p];
			if (p=="par") recpar=obj[p]  //图片
	        if (p=="rw")  recrw=obj[p]   //图片
			if (p=="") continue;
			if (aa == "") 
			{
				str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			}else
			{
			  	str = str + p + "|" + aa + '^';	
			}
		}
		//alert(str)
		if ((str!="")&&(flag=="0")&&(isModifiedflag=="Y"))
		{
			if (str.indexOf("CareDate")==-1)
			{
				str=str+"CareDate|"+CareDate+"^CareTime|"+CareTime;
			}
			//str=str+"^RecLoc|"+patloc+"^RecNurseLoc|"+session['LOGON.CTLOCID']+"^RecBed|"+bedCode;  //patloc是病人当前科室，如果打印时“科室”希望打印的是科室则用该句；
			//alert(EpisodeID+";"+str+";"+session['LOGON.USERID']+";"+session['LOGON.GROUPDESC']);
			//alert(str)
			var ret=tkMakeServerCall("Nur.NurRecPlanSub","Save",EpisodeID,str,session['LOGON.USERID'],"DHCNURPL_PLAN",session['LOGON.GROUPDESC']) 
            find()	
		}
	}

}
function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (var i = 0; i < str.length; i++) {
			var code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			}
			else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				}
				else {
					result += str.charAt(i);
				}
			}
		}
	}
	else{
		result=str;
	}  
	return result;   
}
function additm()
{
	//选中的护理问题
	var patientTreeCH = Ext.getCmp("patientTree").getChecked()
	if (patientTreeCH.length==0)
	{
		alert("请先选择护理问题")
		return;
	}
	//选中的预期护理目标
	var mbchl = Ext.getCmp("yqmbTree").getChecked()
	if (mbchl.length==0)
	{
		alert("请先选择预期护理目标")
		return;
	}
	//选中的护理措施
	var casechl = Ext.getCmp("caseTree").getChecked()
	if (casechl.length==0)
	{
		alert("请先选择预期护理措施")
		return;
	}
	var diagstr=""
	for (var i=0;i<patientTreeCH.length;i++)
	{
		var val=patientTreeCH[i].text
		//alert(val)
		//alert(val+":"+patientTreeCH[i].childNodes)
		if (patientTreeCH[i].childNodes!="") {
			//val=val+":<br>"
		}
		if (diagstr=="")
		{
			diagstr=val;
		}else{
			diagstr=diagstr+"<br>"+val
		}
		//alert(diagstr)
	}
	//alert(patientTreeCH)
	var mbstr=""
	for (var i=0;i<mbchl.length;i++)
	{
		var val=mbchl[i].text
		if (mbchl[i].childNodes!="") continue;
		if (mbstr=="")
		{
			mbstr=val;
		}else{
			mbstr=mbstr+";<br>"+val
		}
	}
	var casestr=""
	for (var i=0;i<casechl.length;i++)
	{
		var val=casechl[i].text
		if (casechl[i].childNodes!="") continue;
		if (casestr=="")
		{
			casestr=val;
		}else{
			casestr=casestr+";<br>"+val
		}
	}
	var qtobj=Ext.getCmp("qtyqmb").getValue()
	if (qtobj!="") mbstr=mbstr+";<br>"+qtobj
	var qtobj=Ext.getCmp("qtcase").getValue() //其他护理措施
	if (qtobj!="") casestr=casestr+";<br>"+qtobj
    var str="CareDate|"+diffDate(new Date(),0)+"^CareTime|"+new Date().dateFormat('H:i')+"^NurDiagnos|"+diagstr+"^RecNoc|"+mbstr+"^RecNic|"+casestr
	//alert(str)
	var ret=tkMakeServerCall("Nur.NurRecPlanSub","Save",EpisodeID,str,session['LOGON.USERID'],"DHCNURPL_PLAN",session['LOGON.GROUPDESC']) 
    find()	
	//alert(casestr+"^"+mbstr)
	
}
function printNurRec()
{
		var ret=tkMakeServerCall("web.DHCMGNurComm","PatInfo",EpisodeID);	
		var stdate="" //tm[2];
		var stim="" //tm[3];
		var edate="" //tm[4];
		var etim="" //tm[5];
		//alert(ret)
		PrintCommPic.UserPrintDown = "N";
		PrintCommPic.TitleStr=ret;
		PrintCommPic.SetPreView("1");
		PrintCommPic.PrnLoc=session['LOGON.CTLOCID'];
		PrintCommPic.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
		PrintCommPic.stPage=0;
		PrintCommPic.stRow=0;
		PrintCommPic.previewPrint="1"; //是否弹出设置界面
        PrintCommPic.curPages=0;
		PrintCommPic.stprintpos=0;
		PrintCommPic.ItmName = "DHCNURMouldPrn_NURSEPLAN"; //338155!2010-07-13!0:00!!
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!DHCNURPL_PLAN";
		//alert(parr)
		PrintCommPic.ID = "";
		PrintCommPic.MultID = "";
		PrintCommPic.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
		PrintCommPic.PrintOut();
		
}
function find(){
    //alert(EpisodeID)		
	var adm = EpisodeID;
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var IfCancelRec=Ext.getCmp("IfCancelRec").getValue();
	var parr = adm + "^" + StDate.value + "^" + StTime.value + "^" + Enddate.value + "^" + EndTime.value + "^DHCNURPL_PLAN^" + IfCancelRec;
    var mygrid = Ext.getCmp("nurseplan");
	//alert(parr)
    mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
    });    
    mygrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
    mygrid.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
	})
}
   //加颜色
 function handleGridLoadEvent(store,records)
  {
	var grid=Ext.getCmp('nurseplan');
	var gridcount=0;
  
    var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var mygrid = Ext.getCmp("nurseplan");
	  store.each(function(r){	            
             var rowid=r.get("par")+"||"+r.get("rw")  
             if(r.get('CareDate')!="") //日期格式转换
			 {
			   var date=getDate(r.get('CareDate'));
			   grid.store.getAt(gridcount).set("CareDate",date);			
		     }		
			 store.commitChanges()	                                    
             gridcount=gridcount+1;           
            });	
}
function gettime()
{
	var a=Ext.util.Format.dateRenderer('h:m');
	return a;
}
function diffDate(val,addday){
	var year=val.getFullYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };
function InitializeValue() 
{
	/* 护理问题*/
	var patientTree = Ext.getCmp("patientTree")
	var patientTreeAutoHeight = function() {
			Ext.getCmp("patientTree").setHeight(Ext.getCmp("viewPort").getHeight() - 280)
		}
	patientTree.on("load", function() {		
	})
	patientTree.setHeight(patientTreeAutoHeight())
	patientTree.expandAll();
	patientTree.on("click", function(node) {		
		      
	})
	var flag=""
	patientTree.on("checkchange", function(node) {
				  var childNodeArray = node.childNodes;
				//alert(childNodeArray)
				if (childNodeArray.length == 0) {
					return;
				}
				for (var i = 0; i < childNodeArray.length; i++) {
					childNodeArray[i].getUI().toggleCheck(node.getUI().isChecked());					
				}	
	
			})
	/* 护理措施*/
	var caseTree = Ext.getCmp("caseTree")
	var caseTreeAutoHeight = function() {
			Ext.getCmp("caseTree").setHeight(Ext.getCmp("viewPort").getHeight() - Ext.getCmp("yqmbTree").getHeight()- Ext.getCmp("qtmb").getHeight()- Ext.getCmp("qtcase").getHeight()-380)
		}
	caseTree.setHeight(caseTreeAutoHeight())
	caseTree.expandAll();
	caseTree.on("checkchange", function(node) {
				var childNodeArray = node.childNodes;
				if (childNodeArray.length == 0) {
					return;
				}
				for (var i = 0; i < childNodeArray.length; i++) {
					childNodeArray[i].getUI().toggleCheck(node.getUI().isChecked());					
				}	
			})
	/* 预期目标*/
	var yqmbTree = Ext.getCmp("yqmbTree")
	var yqmbTreeAutoHeight = function() {
			Ext.getCmp("yqmbTree").setHeight(Ext.getCmp("viewPort").getHeight()/3)
		}
	yqmbTree.setHeight(caseTreeAutoHeight())
	yqmbTree.expandAll();
	yqmbTree.on("checkchange", function(node) {
				var childNodeArray = node.childNodes;
				if (childNodeArray.length == 0) {
					return;
				}
				for (var i = 0; i < childNodeArray.length; i++) {
					childNodeArray[i].getUI().toggleCheck(node.getUI().isChecked());					
				}	
			})
	/* 护理计划明细*/
	var nurseplan = Ext.getCmp("nurseplan")
	var nurseplanAutoHeight = function() {
			Ext.getCmp("nurseplan").setHeight(Ext.getCmp("viewPort").getHeight()-240)
		}
	nurseplan.setHeight(nurseplanAutoHeight())
	/* 说明*/
	var obj = Ext.getCmp("textsm")
	//obj.setDisabled(true)

}
//加载护理诊断
function CreateTree(patientTree) {
	var loader = new Ext.tree.TreeLoader({
		dataUrl: '../csp/dhc.nurse.ext.common.getdata.csp?className=Nur.DHCNurDiagnos&methodName=GetNurDiagTree&type=Method&ctlocDr=' + session['LOGON.CTLOCID'] + "&diagcode="+nursediag+ "&version=V1"
	});
	var root = new Ext.tree.AsyncTreeNode({
		
		text: "护理问题",
		iconCls: 'all'
	});
	var tree = new Ext.tree.TreePanel({
		root: root,
		// animate : true,
		// frame:true,
		// tbar:[new Ext.form.ComboBox({id:"dsds"})],
		autoScroll: true,
		id: 'patientTree',
		rootVisible: false,
		height: 100,
		width: 200,
		containerScroll: true,
		autoScroll: true,
		loader: loader,
		listeners:{
			scope:this,
			checkchange:function(node,checked){
				
				node.attributes.checked = checked;
				var chs = tree.getChecked();
				if (node.id.indexOf('sub')>-1) return;
				if ((currentnode!="")&(node.id==currentnode))
				{
					
					return;
				}
				//alert(checked+currentnode)
				if (checked)
				{
					//alert(node.id)
					currentnode=node.id;
					if (currentnode.indexOf('xnode')>-1) return;
					loadcaseandmb(node.id)
					if (node.id!="")
					{						
						var ret=tkMakeServerCall("Nur.DHCNurDiagnos","getDesc",node.id)
						Ext.getCmp('textsm').setValue(ret)
					}
					flag="Y"
					
				}else{
					//Ext.getCmp('textsm').setValue("")
				}
				//alert(node.id)
				for (var i=0;i<chs.length;i++)
				{
					//alert(chs[i].attributes['id'])
					if (chs[i].attributes['id']!=node.attributes['id'])
					{
						chs[i].ui.toggleCheck(!checked)
					}
				}
			}
			
		}
	})
	return tree;
}
var currentnode="" //当前选择node
var flag="" //触发计数
//重新加载预期目标和护理措施
function loadcaseandmb(par)
{
	    var yqmbTree = Ext.getCmp("yqmbTree") 
	    var loader = yqmbTree.getLoader();
		loader.dataUrl = '../csp/dhc.nurse.ext.common.getdata.csp?className=Nur.DHCNurDiagnos&methodName=GetNurYQMBTree&type=Method&par=' + par
		loader.load(yqmbTree.getRootNode(), function() {
			yqmbTree.expandAll();
		})
		var caseTree = Ext.getCmp("caseTree") 
	    var loader = caseTree.getLoader();
		loader.dataUrl = '../csp/dhc.nurse.ext.common.getdata.csp?className=Nur.DHCNurDiagnos&methodName=GetNurCaseTree&type=Method&par=' + par
		loader.load(caseTree.getRootNode(), function() {
			caseTree.expandAll();
		})
		var obj = Ext.getCmp("qtcase") 
		obj.setValue("")
		var obj = Ext.getCmp("qtyqmb") 
		obj.setValue("")
			
}
//预期目标
function CreateTreeXG() {
	var loader = new Ext.tree.TreeLoader({
		dataUrl: '../csp/dhc.nurse.ext.common.getdata.csp?className=Nur.DHCNurDiagnos&methodName=GetNurYQMBTree&type=Method&par='+nursediag
	});
	var root = new Ext.tree.AsyncTreeNode({
		checked: false,
		text: "预期目标",
		iconCls: 'all'
	});
	var tree = new Ext.tree.TreePanel({
		root: root,
		// animate : true,
		// frame:true,
		// tbar:[new Ext.form.ComboBox({id:"dsds"})],
		autoScroll: true,
		id: 'yqmbTree',
		rootVisible: false,
		height: 100,
		width: easewidth-30,
		containerScroll: true,
		autoScroll: true,
		loader: loader
	})
	return tree;
}
//护理措施
function CreateTreeMS() {
	var loader = new Ext.tree.TreeLoader({
		dataUrl: '../csp/dhc.nurse.ext.common.getdata.csp?className=Nur.DHCNurDiagnos&methodName=GetNurCaseTree&type=Method&par='+nursediag
	});
	var root = new Ext.tree.AsyncTreeNode({
		checked: false,
		text: "护理措施",
		iconCls: 'all'
	});
	var tree = new Ext.tree.TreePanel({
		root: root,
		// animate : true,
		// frame:true,
		// tbar:[new Ext.form.ComboBox({id:"dsds"})],
		autoScroll: true,
		id: 'caseTree',
		rootVisible: false,
		height: 100,
		width: easewidth-30,
		containerScroll: true,
		autoScroll: true,
		loader: loader
	})
	return tree;
}
