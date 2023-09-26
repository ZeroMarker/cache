///配液减库界面JS
///Creator:LiangQiang
///CreatDate:2013-05-31
///

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask;

Ext.onReady(function() {
		Ext.QuickTips.init();// 浮动信息提示
		Ext.Ajax.timeout = 900000;

	//药房科室控件
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
	});

	phlocInfo.on(
		'beforeload',
		function(ds, o){
		    var grpdr=session['LOGON.GROUPID'] ;
			ds.proxy = new Ext.data.HttpProxy({
				url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+grpdr, method:'GET'
				});
		}
	);
 
	var PhaLocSelecter = new Ext.form.ComboBox({
		id:'PhaLocSelecter',
		fieldLabel:'药房科室',
		store: phlocInfo,
		valueField:'rowId',
		displayField:'phlocdesc',
		width : 160,
		listWidth:250,
		emptyText:'选择药房科室...',
		allowBlank: false,
		name:'PhaLocSelecter',
		mode: 'local'		  
	});

	phlocInfo.on("load",function(store,record,opts){setDefaultLoc();});

	//刷新
	var  RefreshButton = new Ext.Button({
	     width : 70,
	     id:"RefreshBtn",
	     text: '查询',
	     icon:"../scripts/dhcpha/img/find.gif",
	     listeners:{
			"click":function(){   
				FindOrdGrpDetail();
			}   
	     }
	})
  
	var OkButton = new Ext.Button({
		width : 65,
		id:"OkButton",
		text: '减库[F8]',
		tooltip:'F8快捷键',
		icon:"../scripts/dhcpha/img/update.png",
		listeners:{
			"click":function(){  
				OpStock();
			}   
		}
	})
   var map = new Ext.KeyMap(Ext.getDoc(), [{
    key: 119,
    fn:function(){OpStock()},
    scope: this
    }]
);
	var ReadBarButton = new Ext.Button({
		width : 65,
		id:"ReadBarBtn",
		text: '扫码',
		icon:"../scripts/dhcpha/img/menu.png" 
	})
    
	///查询瓶签单号 
	var FindPrintNoButton = new Ext.Button({
		width : 3,
		id:" FindPrintNoBtn",
		text: '...',
		listeners:{
			"click":function(){    
				sdate=Ext.getCmp("startdt").getRawValue().toString();
				edate=Ext.getCmp("enddt").getRawValue().toString();
				phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
				var Input=sdate+"^"+edate+"^"+phlocdr+"^"+"60";
				OpenFindNoWin(Input);
			}   
		}
	})

	//已减库
	var OnlyOpStkChkbox=new Ext.form.Checkbox({
		boxLabel : '已减库',
		id : 'OnlyOpStkChk',
		inputValue : '1',
		checked : false,
		listeners:{
			'check': function(){
			}
		}
	})
    
	///瓶签单号
	var PrintNoField=new Ext.form.TextField({
		width : 100, 
		id:"PrintNoTxt", 
		fieldLabel:"瓶签单号" ,
		listeners:{
			specialkey: function (textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
				}
			}
		}
	})

	///医嘱明细数据table
	function selectbox(re,params,record,rowIndex){
		return '<input type="checkbox" id="TSelectz'+rowIndex+'" name="TSelectz'+rowIndex+'"  value="'+re+'"  >';
	} 
	var orddetailgridcm = new Ext.grid.ColumnModel({
		columns:[
		    {header:'<input type="checkbox" id="TDSelectOrdItm" >',width:40,menuDisabled:true,dataIndex:'select',renderer:selectbox},
		    {header:'登记号',dataIndex:'patid',width:100},
		    {header:'姓名',dataIndex:'patname',width:80},
		    {header:'用药日期',dataIndex:'orddate',width:130},
		    {header:'处方号',dataIndex:'prescno',width:100},
		    {header:'处方号hide',dataIndex:'prescnoT',width:100,hidden:true},
		    {header:'药品名称',dataIndex:'incidesc',width:200},
		    {header:'数量',dataIndex:'qty',width:40},
		    {header:'单位',dataIndex:'uomdesc',width:60},
		    {header:'剂量',dataIndex:'dosage',width:80},
		    {header:'频次',dataIndex:'freq',width:60},
		    {header:'规格',dataIndex:'spec',width:80},
		    {header:'用法',dataIndex:'instruc',width:80},
		    {header:'用药疗程',dataIndex:'dura',width:60},
		    {header:'剂型',dataIndex:'form',width:80},
		    {header:'医生',dataIndex:'doctor',width:60},
		    {header:'医嘱备注',dataIndex:'remark',width:120},
		    {header:'selectflag',dataIndex:'selectflag',hidden:true},
		    {header:'dsprowid',dataIndex:'dsprowid',width:60},
		    {header:'pogid',dataIndex:'pogid',width:60},
		    {header:'打包状态',dataIndex:'packflag',width:60},
		    {header:'接收状态',dataIndex:'omflag',width:60},
		    {header:'条码',dataIndex:'barcode',width:60}
			]
	});
 
	var orddetailgridds = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
		}, [
			'select',
			'patid',
			'patname',
			'orddate',
			'prescno',
			'prescnoT',
			'incidesc',
			'qty',
			'uomdesc',
			'dosage',
			'freq',
			'spec',
			'instruc',
			'dura',
			'form',
			'doctor',
			'remark',
			'selectflag',
			'dsprowid',
			'pogid',
			'packflag',
	    	'omflag',
	    	'barcode'
		]),
	remoteSort: true
	});

	var orddetailgridcmPagingToolbar = new Ext.PagingToolbar({	
		store:orddetailgridds,
		pageSize:200,
		//显示右下角信息
		displayInfo:true,
		displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
	    prevText:"上一页",
		nextText:"下一页",
		refreshText:"刷新",
		lastText:"最后页",
		firstText:"第一页",
		beforePageText:"当前页",
		afterPageText:"共{0}页",
		emptyMsg: "没有数据"
	});

	var orddetailgrid = new Ext.grid.GridPanel({
	    stripeRows: true,
	    region:'center',
	    margins:'3 3 3 3', 
	    autoScroll:true,
	    id:'orddetailtbl',
	    enableHdMenu : false,
	    ds: orddetailgridds,
	    cm: orddetailgridcm,
	    enableColumnMove : false,
	    bbar:orddetailgridcmPagingToolbar,
	    //tbar:[OnlyReadBarChkbox,"-",BarcodeField,'-','扫码计数:',BarcodeNumField],
	    trackMouseOver:'true',
	    viewConfig:{
		//forceFit:true,
		enableRowBody : true,
		getRowClass :function(record,rowIndex,rowParams,store){
	        var cls="";
	        if(record.data.packflag=="Y"){
	            cls = 'x-grid-record-lightgreen';
	        }
	        return cls;
	        }
		}
	});

	orddetailgrid.on('cellclick',OrddetailGridCellClick);

	orddetailgrid.on('headerclick', function(grid, columnIndex, e){ 
		if(columnIndex==0){
			selectAllRows();
		};
	});

	//开始日期
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 150,
                xtype: 'datefield',
                format:'j/m/Y H:i:s' ,
                fieldLabel: '开始日期',
                name: 'startdt',
                id: 'startdt',
                invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                value:GetPIVAStDate()+" "+"00:00:00",
                listeners: {
                	select: function(m, d){ 
		            var newdate=d.format('j/m/Y')+" 00:00:00"
		            m.setValue(newdate);
		
		                }
		           }
            })	
            	
        
        
        
	 var enddatef=new Ext.form.DateField ({
  	            width : 150,
                format:'j/m/Y H:i:s' ,
                fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
	        value:GetPIVAEndDate()+" "+"23:59:59",
	        listeners: {
                	select: function(m, d){ 
		            var newdate=d.format('j/m/Y')+" 23:59:59"
		            m.setValue(newdate);
		
		                }
		           }
            })
    
    
    

	///瓶签条码
	var BarcodeField=new Ext.form.TextField({
		width : 120, 
		id:"BarcodeTxt", 
		fieldLabel:"瓶签条码" ,
		listeners: {
			specialkey: function (textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER){
					var barcode=Ext.getCmp('BarcodeTxt').getValue();
					SetLabelStat(barcode);
				}
			},
			afterrender : function (textfield, e) {
				Ext.getCmp('BarcodeTxt').focus(true,true); 
			},
			render : function SetTip(textfield, e){
				this.getEl().dom.setAttribute("ext:qtip", "扫码前确认将光标移动到这里!");
			}
		}
	})

	//病人登记号查询工具
	var patientField=new Ext.form.TextField({
		width:160, 
		id:"patientTxt", 
		fieldLabel:"登记号" ,
		listeners: {
			specialkey: function (textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					//FindOrdDetailData();	//2013-11-05 注释
					FindOrdGrpDetail();	//add 2013-11-05
				}
			}
		}
	})
    
	var DatePanel = new Ext.Panel({
		title:'配液减库',
		frame : true,
		margins:'1 0 0 0', 
		bbar:[RefreshButton,"-",OkButton],
		labelWidth:80,
		region:'center',
		items : [{
			layout : "column",
			items : [{
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [PhaLocSelecter]
			},{
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [stdatef]
			},{
				labelAlign : 'right',
				columnWidth : .183,
				layout : "form",
				items : [PrintNoField]
			},{
				columnWidth : .2,
				layout : "form",
				items : [FindPrintNoButton]
			},{
				labelAlign : 'right',
				columnWidth : .15,
				layout : "form",
				items : []
			}]
			},{
			layout : "column",
			items : [{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [patientField]
			},{
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [enddatef]
			},{
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [BarcodeField]
			}]
			},{
			layout : "column",
			items : [{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : []
				}]
			},{
			layout : "column",
			items : [{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : []
			}]
		}]
	})

	////
	var centerform = new Ext.Panel({
		id:'centerform',
		region: 'center',
		margins:'1 0 0 0', 
		frame : false,
		layout:{  
			type:'vbox', 
			align: 'stretch',  
			pack: 'start'  
			}, 
		items: [{           
			flex: 2,
			layout:'border',
			items:[DatePanel]  
			},{           
			flex: 8,
			layout:'border',
			items:[orddetailgrid]  
		}]
	});

	var port = new Ext.Viewport({
		layout : 'border',
		items : [centerform]
	});
	
	 //设置默认科室
	function setDefaultLoc()
	{
		if (phlocInfo.getTotalCount() > 0)
		{
			PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
		}
	}
		
	 //返回左边列表选择条件
	function GetListInput()
	{
		sdate=Ext.getCmp("startdt").getRawValue().toString();
		edate=Ext.getCmp("enddt").getRawValue().toString();
		phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		patid=Ext.getCmp('patientTxt').getValue();
		prtnostr=Ext.getCmp('PrintNoTxt').getValue();
		barcode=Ext.getCmp('BarcodeTxt').getValue();
		var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+patid+"^"+prtnostr+"^"+barcode ;
		return listinputstr;
	}
		
	function FindOrdGrpDetail()
	{
	    var RegNo=Ext.getCmp('patientTxt').getValue();
	    var RegNo=GetWholePatID(RegNo);
		var sdate=Ext.getCmp("startdt").getRawValue().toString();
		var edate=Ext.getCmp("enddt").getRawValue().toString();
		var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		if (sdate=="") {Ext.Msg.show({title:'注意',msg:'开始日期不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (edate=="") {Ext.Msg.show({title:'注意',msg:'结束日期不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (phlocdr=="") {Ext.Msg.show({title:'注意',msg:'科室不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		
	    var input=GetListInput();
	    waitMask = new Ext.LoadMask(Ext.getBody(), {msg: "系统正在处理数据,请稍候..." }); 
	    waitMask.show();  
	    ClearDocument();
		orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindOrdGrpDetail&RegNo='+RegNo+"&Input="+input });		
		orddetailgridds.load({
			params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
			callback: function(r, options, success){     
				waitMask.hide();
				if (success==false){
					Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				}
			}
		});
	   
	}		

	///补0病人登记号
	function GetWholePatID(RegNo)
	{    
		if (RegNo=="") {
		return RegNo;
		}
		var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
		var plen=RegNo.length;
		if (plen>patLen){
			Ext.Msg.show({title:'错误',msg:'输入登记号错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return;
		}
		for (i=1;i<=patLen-plen;i++)
		{
			RegNo="0"+RegNo;
		}
		Ext.getCmp('patientTxt').setValue(RegNo);
		return RegNo;
	}		

	 //列单击事件
	function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
	{
		if (columnIndex==0){
			var newmoeori="";
			var record = orddetailgrid.getStore().getAt(rowIndex);
			var moeori =record.data.selectflag ;
			var mprescnoT =record.data.prescnoT ;
			var view = orddetailgrid.getView();
			var store = orddetailgrid.getStore();

			if (document.getElementById("TSelectz"+rowIndex).checked)
			{
				for (i=0;i<=view.getRows().length-1;i++)
				{
					if(document.getElementById("TSelectz"+i).checked){       
						//rsm.deselectRow(i)  
					}
					else
					{ 
						var record = orddetailgrid.getStore().getAt(i);
						var newmoeori =record.data.selectflag ;
						var newprescnoT =record.data.prescnoT ;
						if ((newmoeori==moeori)||(newprescnoT==mprescnoT)){
							document.getElementById("TSelectz"+i).checked=true;
						}
						else
						{
							if (i>rowIndex) break;
						}
					}
				}
			}else{
				for (i=0;i<=view.getRows().length-1;i++)
				{
					if(document.getElementById("TSelectz"+i).checked){       
						var record = orddetailgrid.getStore().getAt(i);
						var newmoeori =record.data.selectflag ;
						var newprescnoT =record.data.prescnoT ;
						if ((newmoeori==moeori)||(newprescnoT==mprescnoT)){
							document.getElementById("TSelectz"+i).checked=false;
						}
						else
						{
							if (i>rowIndex) break;
						}
						}
					else
					{}
				}
			}
		}
	}
		
	//全选/全销事件
	function selectAllRows()
	{
		var cellselected=document.getElementById("TDSelectOrdItm").checked ;
		var view = orddetailgrid.getView();
		var rows=view.getRows().length ;
		if (rows==0) return;
		for (i=0;i<=rows-1;i++)
		{
			if (cellselected){
				document.getElementById("TSelectz"+i).checked=true;
			}else{
				document.getElementById("TSelectz"+i).checked=false;
			}
		}
	}

	//设置集点   
	function SetFocus()
	{
		Ext.getCmp('BarcodeTxt').focus(true,true); 
	}

	//清除
	function ClearDocument()
	{
		orddetailgridds.removeAll();
		document.getElementById("TDSelectOrdItm").checked=false;  
	}
	
	//库存处理 
	function OpStock()
	{
		SetFocus();
		var view = orddetailgrid.getView();
		var rows=view.getRows().length-1 ;
		if (rows==-1) return;
		var user=session['LOGON.USERID'] ;
		var h=0;  //选择标志
		var m=0;
		var dspstr="";printno="";
		for (i=0;i<=rows;i++)
		{
			var cellselected=document.getElementById("TSelectz"+i).checked
			if (!(cellselected))  continue;
			h=h+1;
			var record = orddetailgrid.getStore().getAt(i);
			var prescno =record.data.prescno ;
			var selectflag =record.data.selectflag ;
			var dsprowid =record.data.dsprowid ;
			if (selectflag!=""){
				var pogid =record.data.pogid ;
				var ret=tkMakeServerCall("web.DHCSTPIVAOUTOPSTOCK", "OpPIVAStock",pogid,user);
				if(ret=="-21"){alert("有药品未接收,不能减库存");}
				else if(ret=="-99"){alert("提示该药房人员没有在药房人员代码维护界面维护！");}
				else if(ret=="-60") {alert("有效库存不足!"+"\n"+"有效库存:不包含过期和批次不可用药品!")}
				else if(ret!="0"){alert(ret);}
			}
		}	
		FindOrdGrpDetail(); //处理完之后重新检索  	       	
	}
	
	function SetLabelStat(LabelCode)
	{
		var user=session['LOGON.USERID'];
		var view = orddetailgrid.getView();
		var rows=view.getRows().length;
		if (rows==0) return;
		var h=0;
		for (var i=0;i<rows;i++)
		{
			var record = orddetailgrid.getStore().getAt(i);
			var prescno =record.data.prescno;
			var pogid =record.data.pogid;
			var barcode =record.data.barcode;
			if(LabelCode==barcode)
			{
				if (prescno!="")
				{
					var pogid =record.data.pogid;
				    var ret=tkMakeServerCall("web.DHCSTPIVAOUTOPSTOCK", "OpPIVAStock",pogid,user);
					if(ret=="-21"){alert("有药品未接收,不能减库存");}
					else if(ret=="-80") {alert("提示已减库，不能重复减库！")}
					else if(ret=="-1") {alert("下一状态不是减库状态！")}
					else if(ret=="-60") {alert("有效库存不足!"+"\n"+"有效库存:不包含过期和批次不可用药品!")}
					else if(ret!="0"){alert(ret);}
					if(ret!="0")break;
				}
				//orddetailgrid.getView().addRowClass(i,'x-grid-record-red');
				orddetailgrid.getView().getRow(i).style.backgroundColor='#FF0000';
				h++;
			}
			if((LabelCode!=barcode)&(h!=0)) break;  //找到扫描签之后退出
		}
	}

});