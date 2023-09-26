
var unitsUrl = 'dhcst.mbccolldrugaction.csp';
var gParentId=""
//var NumberI='70' //门诊煎药状态转换 自煎转代煎
Ext.onReady(function() {
       var gUserId = session['LOGON.USERID'];
	Ext.QuickTips.init();// 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var BarCode = new Ext.form.TextField({
		fieldLabel : '条码',
		id : 'BarCode',
		name : 'BarCode',
		anchor : '90%',
		width : 140,
		listeners : {
			specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
			   MainGridDs.removeAll();
			    DecSaveCom();
		    }
		  }
		}
		
		});	
		// 保存按钮
		var TransBT = new Ext.Toolbar.Button({
					id : "TransBT",
					text : '转换',
					tooltip : '点击转换',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
	                         transData();
						}
		          
		          })
function transData()
    {
            var rowData=MainGrid.getSelectionModel().getSelected();
			// 选中行
			var JyCook = rowData.get("jycook");
			if(JyCook!="自煎"){
				Msg.info("warning", "不是自煎处方不能转换!");
				return;	
				}
		 Ext.MessageBox.show({
					title : '提示',
					msg : '是否确定转换该处方?',
					buttons : Ext.MessageBox.YESNO,
					fn : showResult,
					icon : Ext.MessageBox.QUESTION
				});
	}
			/**
		 * 转换提示
		 */
		function showResult(btn) {
			if (btn == "yes") {
                var rowData=MainGrid.getSelectionModel().getSelected();
				var prescno = rowData.get("Prescno");
				// 转换该行数据
				var url =  unitsUrl+'?action=TransTypePresc&Prescno='
						+prescno+ "&UserId=" + gUserId;

				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '转换中...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Msg.info("success", "转换成功!");
                                           MainGridDs.removeAll();
                                           MainGridDs.setBaseParam("Prescno",prescno)
                                           MainGridDs.load();
                                           PrintTransTypePresc(prescno);
								} else {
									var ret=jsonData.info;
									if(ret==-10){
										Msg.info("error", "非中草药处方，不能转换!");
									}else if(ret==-20){
										Msg.info("error", "非自煎处方，不能转换!");
									}else{
										Msg.info("error", "转换失败!错误代码"+ret);
									}
								}
							},
							scope : this
						});
			}
		}
 function PrintTransTypePresc(PrescNo)
  {
	  	//1、准备打印数据
		//2、Excel
		var prtpath=GetPrintPath();
		var Template=prtpath+"YFcycfNew.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;
		var h=0;
		var startNo=2;
		//3、打印
        var tmlist=tkMakeServerCall("web.DHCST.DHCSTMBCCollDrug", "GetPrtPrescInfoDoc",PrescNo);
        
        var tmparr=tmlist.split("!!")
        var tmpmainstr=tmparr[0].split("^") //主信息
        var paytype=tmpmainstr[32] //费别
        var doclocdesc=tmpmainstr[16] //就诊科室
        var orddate=tmpmainstr[31] //就诊日期
        var patname=tmpmainstr[1] //患者姓名
        var patsex=tmpmainstr[3] //患者性别
        var patage=tmpmainstr[2] //患者年龄
        var patno=tmpmainstr[0] //患者登记号
        var diagnodesc=tmpmainstr[4] //诊断
        var factor=tmpmainstr[26] //付数
        var CreatDoc=tmpmainstr[24] //用法
        var queinst=tmpmainstr[25] //用法
        var queqty=tmpmainstr[27] //用量
		xlsheet.Cells(1, 1).Value ="(代煎)"
		xlsheet.Cells(1, 3).Value ="首都医科大学附属北京安贞医院中药饮片煎药笺";
		xlsheet.Cells(2, 8).Value= PrescNo    //处方号条码
		xlsheet.Cells(3, 2).Value=doclocdesc
		xlsheet.Cells(3, 8).Value= "处方号:"+PrescNo    //处方号
		xlsheet.Cells(4, 2).Value =patname
		xlsheet.Cells(4, 8).Value ="登记号:"+patno
        xlsheet.Cells(5, 3).Value =diagnodesc
	    var tmpdetailstr=tmparr[1].split("@") //主信息  
	    var cnt=tmpdetailstr.length
	   for (i=0;i<cnt;i++)
		{
			
			var detaildata=tmpdetailstr[i].split("^")
			var indesc=detaildata[0] //通用名
			var dosagestr=detaildata[3] // 药品剂量取单次用量单位
			var qty=detaildata[1] // 药品数量
			var unit=detaildata[2] // 药品单位
			var price=detaildata[8]
			var remark=detaildata[13] // 药品备注
			var freq=detaildata[5]
			var BillSum=price*qty
			var Sum = BillSum + Sum
			i = i + 1
			if ((i%4)=='0')
			{
               var  Y = 8
               var  k = (i / 4) - 1
			} else
			{
               var k = parseInt(i / 4)
               var Y = 2 * (i%4 - 1) + 2
             }
              xlsheet.Cells(6 + 2 * k, Y).Value = indesc //'药品名称
              xlsheet.Cells(6 + 2 * k + 1, Y + 1).Value = qty + unit    //'药品剂量取单次用量单位
              xlsheet.Cells(6 + 2 * k, Y + 1).Value = remark    // '备注

		} 
         xlsheet.Cells(20, 4).Value = "共" + factor + "副"
         xlsheet.Cells(20, 6).Value = " " + queinst + ", " +freq+",每次"+queqty
         xlsheet.Cells(20, 9).Value = "代煎"
         xlsheet.Cells(21, 7).Value = "医师签名(签章)：" + CreatDoc
         //xlsheet.Cells(22, 1) = "处方金额：" + Format(Sum, "0.00") + "元"  //'合计
         xlsheet.Cells(22, 1).Value = "处方金额：" +Sum + "元"  //'合计
         xlsheet.Cells(1, 3).Value = "首都医科大学附属北京安贞医院中药饮片煎药笺"
         xlsheet.Cells(22, 1).Value = "代煎费金额：" +factor * 3 + "元" //'合计 
         
		xlsheet.printout();
		SetNothing(xlApp,xlBook,xlsheet);
	  
	  }

//扫描保存
function DecSaveCom(){
	var prescno=Ext.getCmp("BarCode").getValue();
	MainGridDs.removeAll();
	ChildGridDs.removeAll();
	MainGridDs.setBaseParam("Prescno",prescno)
	MainGridDs.load();
	Ext.getCmp("BarCode").setValue("");
	Ext.getCmp("BarCode").focus();
	}

	
   function addNewRow() {
	var record = Ext.data.Record.create([

                    {
			  name : 'PatLoc',
			  type : 'string'
			}, {
			  name : 'PatNo',
			  type : 'string'
			}, {
			  name : 'PatName',
			  type : 'string'
		       }, {
			  name : 'Prescno',
			  type : 'string'
			}, {
			  name : 'jycook',
			  type : 'string'
		       }
	]);
					
   }
    
    var MainGridProxy= new Ext.data.HttpProxy({url:unitsUrl+'?action=GetTransTypePresc',method:'GET'});
    var MainGridDs = new Ext.data.Store({
	proxy:MainGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [ 
		{name:'PatLoc'},
		{name:'PatNo'},
		{name:'PatName'},
		{name:'Prescno'},
		{name:'jycook'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
    });
    //模型
    var MainGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"科室",
        dataIndex:'PatLoc',
        width:100,
        align:'left',
        sortable:true
	 },{
        header:"登记号",
        dataIndex:'PatNo',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"患者姓名",
        dataIndex:'PatName',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"处方号",
        dataIndex:'Prescno',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"煎药方式",
        dataIndex:'jycook',
        width:200,
        align:'left',
        sortable:true
	 }
	 
	 ])
    MainGrid = new Ext.grid.EditorGridPanel({
	store:MainGridDs,
	cm:MainGridCm,
	trackMouseOver:true,
	stripeRows:true,
	//sm:new Ext.grid.CellSelectionModel({}),
	sm : new Ext.grid.RowSelectionModel({
		 singleSelect : true
		 }),
	loadMask:true,
    tbar:[BarCode,"条码",'-',TransBT],
	clicksToEdit:1
    });

    var ChildGridProxy= new Ext.data.HttpProxy({url:unitsUrl+'?action=GetOutPhaPrescDetail',method:'GET'});
    var ChildGridDs = new Ext.data.Store({
	proxy:ChildGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [{name:'DrugCode'},
		{name:'DrugDesc'},
		{name:'DrugQty'},
		{name:'DrugUom'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
    });
    //模型
    var ChildGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"药品代码",
        dataIndex:'DrugCode',
        width:100,
        align:'left',
        sortable:true
	 }, {
        header:"药品名称",
        dataIndex:'DrugDesc',
        width:100,
        align:'left',
        sortable:true
	 },{
        header:"药品数量",
        dataIndex:'DrugQty',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"单位",
        dataIndex:'DrugUom',
        width:200,
        align:'left',
        sortable:true
	 }
	 
	 ])
    ChildGrid = new Ext.grid.EditorGridPanel({
	store:ChildGridDs,
	cm:ChildGridCm,
	trackMouseOver:true,
	stripeRows:true,
	//sm:new Ext.grid.CellSelectionModel({}),
	sm : new Ext.grid.RowSelectionModel({
		 singleSelect : true
		 }),
	loadMask:true
    });    
 	// 添加表格单击行事件
	MainGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var Prescno = MainGridDs.getAt(rowIndex).get("Prescno");
			ChildGridDs.setBaseParam('Prescno',Prescno)
			ChildGridDs.load();
		});
		
 	// 添加表格load事件
	MainGridDs.on('load', function() {
                       MainGrid.getSelectionModel().selectFirstRow();
                       MainGrid.getView().focusRow(0);
		});		
		
        
    var MainPanel = new Ext.Panel({
		title:'处方数据',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[MainGrid]                                 
	});        	  
        
    var ChildPanel = new Ext.Panel({
		title:'处方明细',
		activeTab: 0,
		region:'south',
		height: 450,
		layout:'fit',
		items:[ChildGrid]                                 
	});  
	var por = new Ext.Viewport({

				layout : 'border', // 使用border布局

				items : [MainPanel,ChildPanel]

			});

	    Ext.getCmp("BarCode").setValue("");
        Ext.getCmp("BarCode").focus();
});
